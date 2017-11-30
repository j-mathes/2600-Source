    include vcs2600.h
    org $F000

ROMLoop = $FF00

;RAM locations

;-------------------------------------------------------Graphics control

TopLine = $80           ;line at which to start calculating invader block
CycleOffset = $81       ;0, 1, or 2.. how many extra cycles to delay block
                        ;When this becomes 3, advance invaders a column
PixelOffset = $82       ;0-5, which inv graphics set to use.  When this
                        ;becomes 3 or 6, inc CycleOffset .
CurrMissile = $83       ;missile/bomb 0 or 1 this frame
MissileY = $84          ;beginning of missile on current frame

Scanline = $85          ;current scanline, count from 0
CurrentRow = $86        ;Start at 16, shift it right each time.
InvGraphics = $88       ;16-bit pointer to top of inv gfx current row
MissGraphics = $8A      ;16-bit pointer to top of missile gfx current row

;-------------------------------------------------------Player data
Player0Pos = $90        ;player 0 position
Player0MX = $91         ;player 0 missile X (=Player0Pos+3 when fired)
Player0MY = $92         ;player 0 missile Y (scanline to turn on missile)
Player0Lives = $93      ;EXcluding current life (-1 = not playing)
Player0Score = $94

Player1Pos = $98
Player1MX = $99
Player1MY = $9A
Player1Lives = $9B
Player1Score = $9C

;----------------------------------------------------------Shields
Shields = $A0           ;Four bytes for each shield, from bottom

;-------------------------------------------------------Invader data
Invaders = $B0          ;16 bytes of invader data.  In the 15 possible
                        ;columns, each byte is 00054321, the set bits meaning
                        ;there's an invader in that row of that column.
                        ;Last byte is used for control...

InvLeft = $C0           ;Invaders left on current board
BombDelay = $C1         ;Frames until we try to shoot again
FramesLeft = $C2        ;Frames until advancing PixelOffset.
Direction = $C3         ;0 = moving to right, 1 = moving to left

CurrentWave = $C4       ;start at 0
GameStatus = $C5        ;bit 7 = game over
                        ;bit 6 = Select pressed last frame, don't select again
                        ;bit 5 = waiting for button-press
                        ;bit 1 = player dying (bit 0 says which player died)
CurrentGame = $C6

;-------------------------------------------------Space for the RAM loop.

RAMLoop = $C8           ;The main display loop goes here.
RAMOperand = RAMLoop + $0D  ;Offset of operand of first RESP0.
RAMCycle = RAMLoop + $08    ;Change this to $85 normal, $95 for +1 cycle

Rand1 = $F6         ;Numbers for rand# generator
Rand2 = $F7
Rand3 = $F8
Rand4 = $F9

Temp1 = $FA
Temp2 = $FB

;=========================================================================

Start
    SEI  ; Disable interrupts, if there are any.
    CLD  ; Clear BCD math bit.
    LDX  #$FF
    TXS  ; Set stack to top of RAM.
    LDA #0  ;Zero everything except VSYNC.
B1  STA 0,X
    DEX
    BNE B1
    STX SWACNT  ;set data direction registers to input
    STX SWBCNT

    lda #$6D
    sta Rand1
    sta Rand2
    sta Rand3
    sta Rand4

    lda #$80
    sta GameStatus

    JSR GameInit

MainLoop
    JSR  VerticalBlank ;Execute the vertical blank.
    JSR  CheckSwitches ;Check console switches.
    JSR  GameCalc      ;Do calculations during Vblank
    JSR  DrawScreen    ;Draw the screen
    JSR  OverScan      ;Do more calculations during overscan
    JMP  MainLoop      ;Continue forever.

;---------------------------------------------GameInit, set up new game.

GameInit
    ldx #45         ;Copy main loop to RAM.  Loop is 46 bytes.
CopyLoop
    lda ROMLoop,X
    sta RAMLoop,X
    dex
    bpl CopyLoop

    lda #2
    sta Player0Lives
    sta Player1Lives

    lda CurrentGame
    and #$01
    beq GI0
    lda #$FF
    sta Player1Lives
GI0
    lda #39
    sta Player0Pos
    lda #119
    sta Player1Pos
    lda #0
    sta Player0Score
    sta Player1Score
    sta Player0Score+1
    sta Player1Score+1
    sta Player0MX
    sta Player1MX
    sta Player0MY
    sta Player1MY
    sta CurrentWave

    jsr BoardInit
    RTS

BoardInit

    sec
    lda #%00011111  ;Fill invader formation.
    ldx #10
FillInv
    sta Invaders,X
    sec
    sbc #1
    dex
    bpl FillInv
    lda #%00011111
    sta Invaders+15

    lda #0
    sta Invaders+11
    sta Invaders+12
    sta Invaders+13
    sta Invaders+14
    sta Direction
    
    lda #41
    sta TopLine

    lda #55
    sta InvLeft

    lda #60
    sta FramesLeft

    lda GameStatus
    ora #%00100000          ;waiting for button
;    sta GameStatus

    inc CurrentWave

    RTS


;------------------------------------------------------------------vblank

VerticalBlank          ;Beginning of the frame - at the end of overscan.
    LDA  #2            ;VBLANK was set at the beginning of overscan.
    STA  WSYNC
    STA  VSYNC ;Begin vertical sync.
    STA  WSYNC ;First line of VSYNC
    STA  WSYNC ;Second line of VSYNC.
    LDA #44    ;Set timer to activate during the last line of VBLANK.
    STA TIM64T
    LDA #0
    STA  WSYNC ; Third line of VSYNC.
    STA  VSYNC ; Writing zero to VSYNC ends vertical sync period.
    RTS

;--------------------------------------------------------------checkswitches

CheckSwitches

    LDA SWCHB           ;check console switches
    and #$02            ;check Select
    bne NoSelect        ;

    lda GameStatus      ;Select is now pressed.
    and #$40            ;If it was pressed last frame, don't reselect.
    bne NoSelect1

    inc CurrentGame     ;
    lda GameStatus
    ora #$C0            ;game over and select pressed
    sta GameStatus
    jmp S1

NoSelect                ;
    lda GameStatus      ;
    and #$BF            ;turn off select pressed
    sta GameStatus      ;
NoSelect1
    lda SWCHB           ;
    and #$01            ;only care about bit 0 - reset
    bne NoReset         ;was it pressed?
    lda GameStatus
    and #$7F            ;turn off game over
    sta GameStatus
S1                      ;
    jsr GameInit        ;yes (0), init new game

NoReset                 ;

    lda SWCHA           ;check bit 7
    bmi J0              ;if set, "right" not pressed
    lda Player0Pos
    cmp #140            ;140+displace+width+1+invwidth = 159
    beq J0
    inc Player0Pos
J0
    lda SWCHA
    and #$40
    bne J1
    lda Player0Pos
    cmp #26
    beq J1
    dec Player0Pos
J1  
    lda SWCHA           ;check bit 7
    and #$08
    bne J2              ;if set, "right" not pressed
    lda Player1Pos
    cmp #140            ;140+displace+width+1+invwidth = 159
    beq J2
    inc Player1Pos
J2
    lda SWCHA
    and #$04
    bne J3
    lda Player1Pos
    cmp #26
    beq J3
    dec Player1Pos
J3  RTS



;-------------------------------------------------------------------gamecalc

GameCalc

    lda GameStatus
    and #%10100010
    beq Move00          ;If not game over and not player dying
    jmp DontMove        ;and not button waiting, move legal

Move00
    dec FramesLeft      ;is it time to move invaders?
    beq Move01
    jmp DontMove

Move01
    ldx InvLeft         ;reset frames-left count
    lda advancetable,X
    sta FramesLeft

    lda Direction
    bne MovingLeft

    lda PixelOffset
    clc
    adc #1
    sta PixelOffset     ;move invaders right one pixel.
    cmp #3
    beq MI1
    cmp #6
    beq MI0
    jmp DontMove

MI0 lda #0              ;move invaders right one cycle.
    sta PixelOffset
MI1
    lda CycleOffset 
    clc
    adc #1
    sta CycleOffset 
    cmp #3
    bne DontMove

    lda #0              ;Reset CycleOffset  and move invaders right one column.
    sta CycleOffset 

    lda Invaders+14     ;check rightmost byte of formation
    bne MoveDown        ;if nonzero, move formation down

    ldx #14             ;start by moving Invaders,13 into Invaders,14
MI2 lda Invaders-1,X
    sta Invaders,X
    dex
    bne MI2             ;do not copy a byte when X=0
    stx Invaders        ;clear leftmost byte.
    jmp DontMove

MovingLeft
    lda PixelOffset
    sec
    sbc #1
    sta PixelOffset     ;move invaders left one pixel.
    cmp #2
    beq MI4
    cmp #$FF
    beq MI3
    jmp DontMove

MI3 lda #5              ;move invaders left one cycle.
    sta PixelOffset
MI4
    lda CycleOffset 
    sec
    sbc #1
    sta CycleOffset 
    cmp #$FF
    bne DontMove

    lda #2              ;Reset CycleOffset  to max, move invs left one column.
    sta CycleOffset 

    lda Invaders        ;check leftmost byte of formation
    bne MoveDown        ;if nonzero, move formation down

    ldx #0              ;start by moving Invaders,1 into Invaders
MI5 lda Invaders+1,X
    sta Invaders,X
    inx
    cpx #14
    bne MI5             ;do not copy a byte when X=14
    ldx #0
    stx Invaders+14     ;clear rightmost byte.
    jmp DontMove

MoveDown
    lda TopLine         ;move formation DOWN
    clc
    adc #7
    sta TopLine
    lda Direction       ;and flip direction
    eor #1
    sta Direction
    beq M11             ;if we just switched to right, zero cycle/pixel

    lda PixelOffset     ;if we just switched to left, sub 1 from pixeloffset
    clc
    sbc #1
    cmp #$FF
    bne M20
    lda #5
M20 sta PixelOffset
    lda #2              ;and CycleOffset must be 2
    sta CycleOffset
    jmp DontMove

M11 lda #0
    sta CycleOffset
    sta PixelOffset

DontMove

;---------------------------------------------------------Set up for screen

    lda #$85
    sta RAMCycle
    sta RAMCycle+2

    ldx CycleOffset     ;do we need to delay formation 1 or 2 cycles?
    beq C00
    
    lda #$95            ;yes, delay 1 cycle
    sta RAMCycle

    dex                 ;do we need another cycle?
    beq C00

    sta RAMCycle+2      ;yes.

C00 lda #$FE
    sta InvGraphics+1

    RTS

;================================================================draw screen

DrawScreen
    lda #$FF
    sta Scanline
    lda #16
    sta CurrentRow


    LDA INTIM
    BNE DrawScreen
    STA VBLANK     ;here we go!

DoScores
    sta WSYNC      ;begin scanlines 0 through 20
    inc Scanline   ;incs to current line
    lda Scanline
    cmp #20
    bne DoScores

;------------------------------------------------------skip to TopLine
SkipTop
    sta WSYNC      ;begin lines 21 to TopLine
    inc Scanline   ;incs to current line
    lda Scanline
    cmp TopLine
    bne SkipTop

;------------------------------------------------------Do invader formation.
    sta WSYNC           ;begin first line of gap, which is TopLine+1.
                        ;Scanline = TopLine.
    lda Scanline
    sec
    sbc #7
    sta Scanline

DoEachRow               ;We should come here between 0 and 23
                        ;cycles into first line of gap.
    lda Scanline
    clc
    adc #7
    sta Scanline        ;now set for current
                        ;do missiles/bombs here

    sta WSYNC           ;begin second line of gap
                        

    lda #RESP0          ;
    sta RAMOperand
    sta RAMOperand+4
    sta RAMOperand+8
    sta RAMOperand+12
    sta RAMOperand+16
    sta RAMOperand+20
    sta RAMOperand+24
    sta RAMOperand+28   ;+26 26

    lda #RESP1
    sta RAMOperand+2
    sta RAMOperand+6
    sta RAMOperand+10
    sta RAMOperand+14
    sta RAMOperand+18
    sta RAMOperand+22
    sta RAMOperand+26   ;+23 49

    sta WSYNC           ;begin third line of gap

    ldx CurrentRow
    lda PixelOffsetTable,X
    sta Temp1

    lda PixelOffset     ;Multiply! Multiply! My kingdom for a multiply!
    asl                 ;
    sta Temp2           ;
    asl                 ;
    adc Temp2           ;
    adc Temp1           ;
    sta InvGraphics     ;multiplied by 6.

    ldx #Invaders-1     ;We'll get the column bytes from stack.
    txs
    ldx #RAMOperand     ;X has offset into zeropage to write to.
    ldy #Temp2          ;to clear invader, we change the inst to STA Temp2 instead of STA RESP0.
    
CalcColumn
    sta WSYNC           ;Begin lines 4,5,6,7 of gap.
                        ;Do loop 4x, with X being RAMOperand+0,+8,+16,+24

    pla                 ;+4  4    get byte containing invaders
    bit CurrentRow      ;+3  7    is current bit set?
    bne C01             ;+2  9    If bit set, don't alter byte.
    sty 0,X             ;+4 13    redirect STA RESPx to harmless location    
C01
    pla                 ;+4 17
    bit CurrentRow      ;+3 20
    bne C02             ;+2 22
    sty 2,X             ;+4 26
C02
    pla                 ;+4 30
    bit CurrentRow      ;+3 33
    bne C03             ;+2 35
    sty 4,X             ;+4 39
C03 cpx #RAMOperand+24  ;+2 41
    beq C05             ;+2 43

    pla                 ;+4 47
    bit CurrentRow      ;+3 50
    bne C04             ;+2 52
    sty 6,X             ;+4 56
C04
    clc                 ;+2 58
    txa                 ;+2 60
    adc #8              ;+2 62
    tax                 ;+2 64
    jmp CalcColumn      ;+3 67
                        ;-----
C05 lda #1              ;+2 46
    sta NUSIZ0          ;+3 49
    sta NUSIZ1          ;+3 52

    lda #$DD            ;+2 54
    sta COLUP0          ;+3 57
    sta COLUP1          ;+3 60

    sta WSYNC           ;begin eighth and final line of gap
    lda Scanline
    clc
    adc #7
    sta Scanline        ;now set for current

    ldx #$FD
    txs
    ldx #0

    ldy #5

    jsr RAMLoop

RAMLoopReturn
    stx GRP0            ;+3  4 (80)
    stx GRP1            ;+3  7

    lsr CurrentRow      ;+5 12
    lda Invaders+15     ;+3 15  get control byte
    and CurrentRow      ;+3 18
    beq DoneBlock       ;+2 20 if no invaders in new currentrow, exit block
    jmp DoEachRow       ;+3 23
DoneBlock

;-----------------------------------------------Between invaders and players

DoBottom
    inc Scanline        ;onto next line
    sta WSYNC
    lda #163
    bit GameStatus
    bpl BO0
    lda #171
BO0 cmp Scanline
    bne DoBottom

;------------------------------------------------------Setup to draw players

SetPlayers

    lda GameStatus
    bmi NoPlayers       ;skip drawing players if game over

    ldx #$CC            ;player 0 color - green
    lda Player0Lives    ;if player 0 absent, don't draw him
    bpl E00             
    ldx #$0             ;if -1, he's not here, clear COLUP0
E00 stx COLUP0          ;
    ldx #$38            ;player 1 is red
    lda Player1Lives    ;
    bpl E01
    ldx #$0             ;or black
E01 stx COLUP1          ;

    lda #0              ;only one copy each player
    sta NUSIZ0
    sta NUSIZ1
    sta HMCLR

    sta WSYNC           ;begin scanline 164
    ldx Player0Pos      ;+3  3
    lda HorzTable,X     ;+4  7
    sta HMP0            ;+3 10 
    and #$0F            ;+2 12
    tax                 ;+2 14
P0  dex                 ;+2 16
    bpl P0              ;when branch not taken: +2 (18 + x*5)
    sta RESP0           ;(21 + x*5) NOW! =)

    sta WSYNC           ;begin scanline 165
    ldx Player1Pos      ;+3  3
    lda HorzTable,X     ;+4  7
    sta HMP1            ;+3 10
    and #$0F            ;+2 12
    tax                 ;+2 14   
P1  dex                 ;+2 16
    bpl P1              ;when branch not taken: +2 (18 + x*5)
                        ;
    sta RESP1           ;

    sta WSYNC
    sta HMOVE

;----------------------------------------------------------Draw the players

    ldx #6              ;players are 6 lines tall

DrawPlayers             ;
    
    ldy [playerpict-1],X;
    sty GRP0            ;
    sty GRP1            ;

    inc Scanline

    dex                 ;
    sta WSYNC           ;begin scanlines 166-171 (players on 165-170)
    bne DrawPlayers     ;+2  2

NoPlayers
    lda #0
    sta GRP0
    sta GRP1
    sta COLUP0
    sta COLUP1
    ldx #20

BelowPlayers    
    sta WSYNC           ;begin scanlines 172-191
    dex
    bne BelowPlayers

    RTS

;-------------------------------------------------------------Overscan

OverScan
    LDA #35        ;Set timer to activate during the last line of overscan.
    STA TIM64T
    LDA #2
    STA VBLANK
    ;do other calculations here
EndOverscan
    LDA INTIM
    BNE EndOverscan
    STA WSYNC
    RTS


;------------------------------------------------Horz positioning table
    org $FD00
HorzTable
    .byte $00,$F0,$E0,$D0,$C0,$B0,$A0,$90
    .byte $71,$61,$51,$41,$31,$21,$11,$01,$F1,$E1,$D1,$C1,$B1,$A1,$91
    .byte $72,$62,$52,$42,$32,$22,$12,$02,$F2,$E2,$D2,$C2,$B2,$A2,$92
    .byte $73,$63,$53,$43,$33,$23,$13,$03,$F3,$E3,$D3,$C3,$B3,$A3,$93
    .byte $74,$64,$54,$44,$34,$24,$14,$04,$F4,$E4,$D4,$C4,$B4,$A4,$94
    .byte $75,$65,$55,$45,$35,$25,$15,$05,$F5,$E5,$D5,$C5,$B5,$A5,$95
    .byte $76,$66,$56,$46,$36,$26,$16,$06,$F6,$E6,$D6,$C6,$B6,$A6,$96
    .byte $77,$67,$57,$47,$37,$27,$17,$07,$F7,$E7,$D7,$C7,$B7,$A7,$97
    .byte $78,$68,$58,$48,$38,$28,$18,$08,$F8,$E8,$D8,$C8,$B8,$A8,$98
    .byte $79,$69,$59,$49,$39,$29,$19,$09,$F9,$E9,$D9,$C9,$B9,$A9,$99
    .byte $7A,$6A,$5A,$4A,$3A,$2A,$1A,$0A,$FA,$EA,$DA,$CA,$BA,$AA,$9A

;------------------------------------------------------Invader graphics

    org $FE00

    .byte %10000100
    .byte %01001000
    .byte %11111100
    .byte %10101100
    .byte %01111000
    .byte %00110000

    .byte %00100100
    .byte %01000010
    .byte %01111110
    .byte %01101010
    .byte %00111100
    .byte %00011000

    .byte %00100001
    .byte %00010010
    .byte %00111111
    .byte %00101011
    .byte %00011110
    .byte %00001100

    .byte %01001000
    .byte %10000100
    .byte %11111100
    .byte %11010100
    .byte %01111000
    .byte %00110000

    .byte %01000010
    .byte %00100100
    .byte %01111110
    .byte %01010110
    .byte %00111100
    .byte %00011000

    .byte %00010010
    .byte %00100001
    .byte %00111111
    .byte %00110101
    .byte %00011110
    .byte %00001100


    .byte %11001100
    .byte %10000100
    .byte %11111100
    .byte %10110100
    .byte %11111100
    .byte %01001000

    .byte %01100110
    .byte %00100100
    .byte %01111110
    .byte %01011010
    .byte %01111110
    .byte %01000010

    .byte %00110011
    .byte %00100001
    .byte %00111111
    .byte %00101101
    .byte %00111111
    .byte %00010010

    .byte %11001100
    .byte %01001000
    .byte %11111100
    .byte %10110100
    .byte %11111100
    .byte %10000100

    .byte %01100110
    .byte %01000010
    .byte %01111110
    .byte %01011010
    .byte %01111110
    .byte %00100100

    .byte %00110011
    .byte %00010010
    .byte %00111111
    .byte %00101101
    .byte %00111111
    .byte %00100001


    .byte %01001000
    .byte %10000100
    .byte %11111100
    .byte %10110100
    .byte %11111100
    .byte %01111000

    .byte %01000010
    .byte %00100100
    .byte %01111110
    .byte %01011010
    .byte %01111110
    .byte %00111100

    .byte %00010010
    .byte %00100001
    .byte %00111111
    .byte %00101101
    .byte %00111111
    .byte %00011110

    .byte %10000100
    .byte %01001000
    .byte %11111100
    .byte %10110100
    .byte %11111100
    .byte %01111000

    .byte %00100100
    .byte %01000010
    .byte %01111110
    .byte %01011010
    .byte %01111110
    .byte %00111100

    .byte %00100001
    .byte %00010010
    .byte %00111111
    .byte %00101101
    .byte %00111111
    .byte %00011110

advancetable            ;that was 108 bytes, we have 148 left
    .byte 255           ;this is invleft = 0; should not happen
    .byte 2
    .byte 4
    .byte 4
    .byte 6,6
    .byte 8,8,8
    .byte 10,12,14      ;9-11
    .byte 18,20,24      ;12-14
    .byte 30,30,30,30,30,30 ;15-20
    .byte 40,40,40,40,40,40 ;21-26
    .byte 60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60
    .byte 60,60,60,60,60,60,60,10

;-----------------------------------------------------------The ROM Loop.
;This gets copied to RAM to be the main invader display loop.
;X=0, Y=5 to display 6 lines of invaders.
;
    org ROMLoop

    sta WSYNC           ;
    lda (MissGraphics),Y;+5  5
    sta ENAM0           ;+3  8
    lda (InvGraphics),Y ;+5 13
    sta GRP0            ;+3 16
    sta GRP1            ;+3 19

    sta RESP0           ;+3 22
    sta RESP1           ;+3 25
    sta RESP0           ;+3 28
    sta RESP1           ;+3 31
    sta RESP0           ;+3 34
    sta RESP1           ;+3 37
    sta RESP0           ;+3 30
    sta RESP1           ;+3 43
    sta RESP0           ;+3 46
    sta RESP1           ;+3 49
    sta RESP0           ;+3 52
    sta RESP1           ;+3 55
    sta RESP0           ;+3 58
    sta RESP1           ;+3 61
    sta RESP0           ;+3 64

    dey                 ;+2 66
    .byte $10,$D3       ;+3 69/71  BPL ROMLoop
    RTS                 ;onto next line

PixelOffsetTable
    .byte 72,72,72,72,36,36,36,36,36,36,36,36,36,36,36,36,0

livestable  ;these are NUSIZ values for the number of lives a player has
    .byte 0     ;1 lives - 1 copy
    .byte 1     ;2 lives - 2 copies
    .byte 3     ;3 lives - 3 copies

playerpict              ;
    .byte %11111110     ;
    .byte %11111110     ;
    .byte %11111110     ;
    .byte %01111100     ;
    .byte %00010000     ;
    .byte %00010000     ;

;Starting positions for PC
    org $FFFC
    .word Start
    .word Start
