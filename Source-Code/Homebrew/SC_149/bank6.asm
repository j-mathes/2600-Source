; -----------------------------------------------------------------------------
; Star Castle Arcade - Atari 2600
; Copyright (C) 2012 Chris Walton (cd-w) <cwalton@gmail.com>
; Copyright (C) 2013 Thomas Jentzsch <tjentzsch@yahoo.de>
; Bank 6 - Startup Code & Hiscore Table
; -----------------------------------------------------------------------------

  START_BANK "BANK6"
  ds      3, 0
  ; Entry Point
  jmp     Start
PlayTitleMusic              ; +6
  nop     BANK5             ; switch to bank 5
  ; End Of Title Music
  jmp     ResumeTitleMusic  ; return from bank 5
ShowTitleScreen             ; +12
  nop     BANK5             ; switch to bank 5
  ; End Of Title Screen
  jmp     TitlesLoop        ; return from bank 5
ShowStartupScreen           ; +18
  nop     BANK1             ; switch to bank 1
  jmp     EndStartupScreen
ReturnFromDrawStars
  nop     BANK0             ; switch to bank 0
  jmp     DrawStarsBank3
EnterGame                   ; +24
  nop     BANK0             ; switch to bank 0
  ; End Of Game
  jmp     EndOfGame
ShowTestScreen              ; +30
  nop     BANK5             ; switch to bank 0
  jmp     EndStartupScreen

ResumeTitleMusic
  ; Show Tiles Screen or HiScore Table
  bit SLOWCYCLE
  bpl ShowTitleScreen
HiScorePhase
  jmp HiScoreTable

; -----------------------------------------------------------------------------
; STARTUP
; -----------------------------------------------------------------------------

Start
  ; Check for 7800 Console (needed for pause button handling)
;  sei
  lda #0
  ldy #CONSOLE_FLAG
  ldx $D0
  cpx #$2C
  bne Not7800
  ldx $D1
  cpx #$A9
  bne Not7800
  tay                     ; 7800 - bit7 = 0
Not7800                   ; 2600 - bit7 = 1

  ; Clear RIOT RAM
  tax
  cld
ClearMemLoop
  dex
  txs
  pha
  bne ClearMemLoop        ; SP=$FF, X = A = 0

  ; Store 7800 Console Bit
  sty DEBOUNCE

  ; Clear RAM+ Memory
  jsr ClearExtraRam

  ; Startup Delay
  lda #127
  sta CYCLE
  sta RANDOM                ; prevent 0

EndStartupScreen
  jsr NextFrame

  ; Update Counter
  dec CYCLE
  beq FinishStartup

  ; Check For Wipe Scores (Fire + Right)
  lda INPT4
  bmi StartupKernel
  ; Debounce Fire
  lda DEBOUNCE
  and #CONSOLE_FLAG
  ora #BUTTON_FLAG
  sta DEBOUNCE
  ; Check For Joystick Right
  bit SWCHA
  bmi .checkTestScreen
  jmp WipeHiScores

  ; Check For Joystick Left
.checkTestScreen
  bvs FinishStartup
  jmp ShowTestScreen

StartupKernel
  ; Show Startup Logo
  jsr PositionText
  jsr StartFrame
  bne ShowStartupScreen

FinishStartup
  ; Read Hiscore Table
  jsr DoReadOperation
  ; Get Stored Colour Mode (ensure validity)
  lax COLMODE_R
  eor #NUM_COLMODES
  bne UpdateColMode
  tax
UpdateColMode
  stx COLMODE
  ; preload initials last saved high score
  lda initials_R
  lda initials_R+1

; -----------------------------------------------------------------------------
; TITLE SCREENS
; -----------------------------------------------------------------------------

  ; Display Title Screen
  ldx #127
StartTitles
  stx SLOWCYCLE

  ; Title Starting Message
  lda #0
  sta MESSAGE

  ; Reset Title Tune
  sta AUDV0
  sta AUDV1
  sta MEASURE
  sta BEAT
  sta TEMPOCOUNT
  sta VOL_NOW

  ; Next Message Timer
  lda #FPS-1
  sta MTIMER
  bne .skipTitleVBlank

TitlesLoop
  BEGIN_VBLANK_MSG

.skipTitleVBlank
  ; Update Frame Counter
  dec CYCLE

  ; Update Slow Cycle & Message Timer
  lda CYCLE
  and #%00000011
  cmp #%00000011
  bne .endSlowCycle
  dec SLOWCYCLE
.endSlowCycle
  lsr
  bcs .skipTimerReset
  dec MTIMER
  bpl .skipTimerReset
  ldx MESSAGE
  dex
  bpl .skipMessageReset
  ldx #3-1
;  lda SLOWCYCLE
;  eor #$80
;  sta SLOWCYCLE
.skipMessageReset
  stx MESSAGE
  lda MessageDelay,X
  sta MTIMER
.skipTimerReset

  ; Select Button
  lda SWCHB
  and #%00000010
  bne SelectNotPressed
  ; Debounce Select Button
  lda DEBOUNCE
  and #SELECT_FLAG
  bne EndSelectPressed
  ; Update Colour Mode
  ldx COLMODE
  inx
  cpx #NUM_COLMODES
  bcc .storeColMode
  ldx #0
.storeColMode
  stx COLMODE
  ; Debounce Select Button
  lda DEBOUNCE
  ora #SELECT_FLAG
  bne StoreSelectDebounce

SelectNotPressed
  lda DEBOUNCE
  and #<~SELECT_FLAG
StoreSelectDebounce
  sta DEBOUNCE
EndSelectPressed

  ; Joystick Left/Right
  lda SWCHA
  and #%11000000
  cmp #%11000000
  lax DEBOUNCE
  bcs .resetTitleJoy
  ; Debounce Left/Right
  and #JOY_FLAG
  bne .endTitleJoy
  ; Flip Screen
  lda SLOWCYCLE
  eor #%10000000
  ora #%01111111
  sta SLOWCYCLE
  txa
  ora #JOY_FLAG
  NOP_W
.resetTitleJoy
  and #<~JOY_FLAG
  sta DEBOUNCE
.endTitleJoy

  ; Fire Button Start
  jsr CheckTitleFire
;  bit DEBOUNCE          ; FIRE_BIT
  bpl NoTitleFire
  jsr ClearExtraRam
  BEGIN_OVERSCAN

  ; remember initial difficulty switches
  lda SWCHB
  and #%11000000
  sta difficulty

; moved from bank 0 (to make space)
  ; Initialise Audio
  lda #SFX_SWITCH
  sta sfx0
  lda #0
  sta AUDV0
  sta AUDV1

  ; Ring directions and speed, only initialize once per game
  sta ringSpeedIdx
  sta castle
;  ldx #1
;  stx castle

  ; Initialise Score & Castle
  sta SCORE+0
  sta SCORE+1
;  lda #$47
  sta SCORE+2
 IF OVERHEAT
  sta overheat
 ENDIF

  ; Start with 5 or 3 ships
 IF CHEAT  
  ldx #$80|60-1  
 ELSE
  ldx #$80|INIT_SHIPS_B-1     ; bit7==1 -> reset ship too!
 ENDIF
  bit difficulty
  bvc .lowDiff
  lda #8
 IF CHEAT  
  ldx #$80|60-1    
 ELSE
  ldx #$80|INIT_SHIPS_A-1     ; bit7==1 -> reset ship too!
 ENDIF
.lowDiff
  sta gameSpeed
  stx SHIPS            

  lda #8
  sta GUNDIR                    ; set gun facing right

  lda #RING1_DIR                ; middle ring rotates in opposite direction
;  lda #%11110000                ; all rings reversed
  sta ringDirs

  lda #$a3
  sta sirenFreqLo
  lda #20
  sta sirenFreqHi

  ; Get Ready Message
  lda #MODE_GET_READY|GET_READY_TIM
  sta MODE
  jmp EnterGame

NoTitleFire
  ; Play Title Screen Music
  jmp PlayTitleMusic

; -----------------------------------------------------------------------------
; HISCORE UPDATE
; -----------------------------------------------------------------------------

EndOfGame SUBROUTINE
  bcs .skipScoreReset
  ; Reset Score to prevent new highscore
  sta SCORE+0
  sta SCORE+1
  sta SCORE+2
.skipScoreReset
;  lda INTIM
;  clc
;  adc #KERNEL_DELAY
;  sta TIM64T

  jsr ClearExtraRam
  ; Silence Sound Effects
;  ldy #0
  sty AUDV0
  sty AUDV1

  jsr NextFrame

  ; Debounce (assume fire is still pressed)
  lda DEBOUNCE
  and #CONSOLE_FLAG
  ora #BUTTON_FLAG
  sta DEBOUNCE

  ; Read Hi Score Table
  jsr DoReadOperation

  ; Calculate Position
  ldx #MAXSCORES-1
.findPositionLoop
; new score has to be greater (>, not >= !):
  lda ScoreOffsets,X        ; [0] + 4
  ora difficulty
  tay
  lda SCORE+2               ; [4] + 3
  cmp HI_READ+2,Y           ; [7] + 4
  bcc .nextScorePosition    ; [11] + 2/3  <
  bne .storeScorePosition   ; [13] + 2/3  >
  lda SCORE+1               ; [15] + 3
  cmp HI_READ+1,Y           ; [18] + 4
  bcc .nextScorePosition    ; [22] + 2/3  <
  bne .storeScorePosition   ; [24] + 2/3  >
  lda HI_READ+0,Y           ; [29] + 4
  cmp SCORE+0               ; [26] + 3
  bcs .nextScorePosition    ; [33] + 2/3  <
.storeScorePosition
  stx HPOS                  ; [0] + 3
  ; Move Entries Down
  ldx #0                    ; [3] + 2
.copyLoop
  cpx HPOS                  ; [63] + 3
  bcs .nameEntry            ; [66] + 2/3
  stx HROW                  ; [0] + 3
  lda ScoreOffsets+1,X      ; [4] + 4
  ora difficulty
  tay
  lda ScoreOffsets,X        ; [0] + 4
  ora difficulty
  tax                       ; [8] + 2
  lda HI_READ+0,Y           ; [10] + 4
  sta HI_WRITE+0,X          ; [14] + 4
  lda HI_READ+1,Y           ; [18] + 4
  sta HI_WRITE+1,X          ; [22] + 4
  lda HI_READ+2,Y           ; [26] + 4
  sta HI_WRITE+2,X          ; [30] + 4
  lda HI_READ+3,Y           ; [34] + 4
  sta HI_WRITE+3,X          ; [38] + 4
  lda HI_READ+4,Y           ; [42] + 4
  sta HI_WRITE+4,X          ; [46] + 4
  lda HI_READ+5,Y           ; [50] + 4
  sta HI_WRITE+5,X          ; [54] + 4
  ldx HROW                  ; [58] + 3
  inx                       ; [61] + 2
  bne .copyLoop             ; [68] + 3 = 75

.nextScorePosition
  dex                       ; [36] + 2
  bpl .findPositionLoop     ; [38] + 2/3
                            ; WORST CASE = 41*8 + 40 + 12 + 8*75
                            ;            = 980 (APPROX 13 SCANLINES)
; no new highscore found
FinishHiScores
  ; Debounce Fire Button
  lda DEBOUNCE
  and #CONSOLE_FLAG
  ora #BUTTON_FLAG
  sta DEBOUNCE
  ; Show HiScore Table
  ldx #255
  jmp StartTitles

.nameEntry
  ; Reflect PF and Set Ball Size
  ldx #%00100001
  stx CTRLPF

  ; Reset Cursor Position
  ldx #0
  stx CURSOR

  ; Unpack Stored Initials
  lda initials_R
  and #%00011111
  sta NAME+0
  eor initials_R
  lsr
  lsr
  lsr
  sta TEMP
  lax initials_R+1
  and #%00000011
  ora TEMP
  sta NAME+1
  txa
  and #%01111100
  lsr
  lsr
  sta NAME+2

NameLoop
  ; Update Game Cycle
  dec CYCLE

  ; Vector Text Setup
  jsr SetScorePointers

  ; Play Sound Effects
  jsr HiScoreSFX

  ; Move Cursor With Joystick
  lax SWCHA
  and #%11110000
  cmp #%11110000
  lda DEBOUNCE
  bcs .resetNameJoy
  ; Debounce Joystick
  and #JOY_FLAG
  bne .endNameJoy
  ; Move Cursor
  txa
  ldx CURSOR
  ldy NAME,X
;CheckCursorLeft
  asl
  bmi .checkCursorRight
  dex
  bpl .storeCursor
  ldx #2-1
  NOP_W
.checkCursorRight
  bcs .checkCursorDown
  inx
  cpx #3
  bcc .storeCursor
  ldx #0
  beq .storeCursor

.checkCursorDown
  asl
  bmi .checkCursorUp
  dey
  bcs .storeName

.checkCursorUp
  asl
  bmi .endNameJoy
  iny
.storeName
  tya
  and #32-1         ; only 32 different characters supported
  sta NAME,X
  lda #((2<<5)|3)
  NOP_W
.storeCursor
  lda #((1<<5)|3)
  stx CURSOR
.storeNameSFX
  sta sfx0
  lda DEBOUNCE
  ora #JOY_FLAG
  NOP_W
.resetNameJoy
  and #<~JOY_FLAG
.storeNameJoy
  sta DEBOUNCE
.endNameJoy

  ; Check If Fire Pressed
  jsr CheckTitleFire
;  bit DEBOUNCE              ; FIRE_BIT
;  bpl EndCheckNameFire      ; not pressed
  bmi .saveHighScore        ; fire pressed
  lda SWCHB
  lsr
  bcs EndCheckNameFire
.saveHighScore
  ; Copy Score Into Table
  ldx HPOS
  lda ScoreOffsets,X
  ora difficulty
  tay
  lda SCORE+0
  sta HI_WRITE+0,Y
  lda SCORE+1
  sta HI_WRITE+1,Y
  lda SCORE+2
  sta HI_WRITE+2,Y
  ; Copy Initials Into Table
  ; Pack NAME Into 2 Bytes
  lax NAME+1
  and #%00011100
  asl
  asl
  asl
  ora NAME+0
  sta initials_W
  sta HI_WRITE+3,Y
  txa
  and #%00000011
  sta TEMP
  lda NAME+2
  asl
  asl
  ora TEMP
  sta initials_W+1
  sta HI_WRITE+4,Y
  ; Copy Castle+1 Into Table
  lda castle
  asl
  lsr
  adc #1
  sta HI_WRITE+5,Y
  ; Store Colour Mode
  lda COLMODE
  sta COLMODE_W
  ; Write Score Table
  jsr DoWriteOperation
  jmp FinishHiScores

EndCheckNameFire
  ; Start Screen
  jsr StartFrame
  ldy #43*60/FPS;+(KERNEL_DELAY*64+32)/76
  jsr SkipLinesB

  ; Show New HiScore Message
  jsr PositionText
  ldy #<MsgNewHiscore
  jsr ShowHeadingMsg

  ; Display Last Score
  ldx COLMODE
  lda ScoreCol,X
  sta COLUP1
  sta COLUP0

  ; Create Text Showing Score and Table Position
  lda #MAXSCORES
  sec
  sbc HPOS
  tay
  cpy #MAXSCORES
  lda (HDPTR),Y
  ldy #<HL_GAP
  bcc .not10
  tay               ; 0
  lda SLHPTR        ; 1
.not10
  sta HTEXT0
  sty HTEXT1
  ldy #GAP_IDX
  lda (HDPTR),Y
  sta HTEXT2
  sta HTEXT3
  sta HTEXT4
  lda <#HL_GAP
  sta HTEXT5
  ldx #<SCORE
  jsr CopyScore
  jsr NormalTextCopy
  jsr NormalTextKernel
  ldy #16*60/FPS
  jsr SkipLinesB

  ; Show Enter Name Message
  ldy #<MsgEnterName
  jsr ShowHeadingMsg

  ldy #5*60/FPS
  jsr SkipLinesB

  ; Default Name Colours
  ldx COLMODE
  lda ScoreCol,X
  sta NAMECOL+0
  sta NAMECOL+1
  sta NAMECOL+2

  ; Flash Cursor Colour
  ldy CURSOR
  lda CYCLE
  and #%00011000
  bne .skipNameFlash
  sta NAMECOL,Y
.skipNameFlash

  ; Show Name
  jsr NameKernel
  ldy #13*60/FPS
  jsr SkipLinesB

  ; Show Fire To Save Message
  jsr PositionText
  ldy #<MsgFireToSave

  ; Flash Fire Message Colour
  ldx COLMODE
  lda CYCLE
  and #%00110000
  beq .storeFireCol
  lda FireCol,X
.storeFireCol
  jsr NormalTextKernelColorLoad

  ; Skip to Next Frame
  jsr NextFrame
  jmp NameLoop

ShowHeadingMsg SUBROUTINE
  ldx COLMODE
  lda HeadingCol+3-3,X        ; Yellow
  jmp NormalTextKernelColorLoad

; -----------------------------------------------------------------------------
; HIGH SCORE TABLE
; -----------------------------------------------------------------------------

GAP_IDX     = 11
DASH_IDX    = 12

HiScoreTable SUBROUTINE
  ; Set Vector Font Pointers
  jsr SetScorePointers

  ; Set Sprite Positions
  jsr PositionText

  ; Start Screen
  jsr StartFrame

  ; Flash Heading Colour
;  lda difficulty
;  lsr
;  adc difficulty
;  rol
;  rol
;  rol
;  rol
;  adc COLMODE
;  tay
  ldy COLMODE
  lda CYCLE
  and #%00011000
  beq .storeHeadingCol
  ; load heading color
  lda HeadingCol,y
.storeHeadingCol

  ; Load Heading Text
  ldy #<MsgHallOfFame
  ; Show "Hall Of Fame"
  jsr NormalTextKernelColorLoad
  ; load difficulty text
  lda difficulty
  and #%11000000
  asl
  rol
  rol
  tax
  ldy DifficultyMsgTbl,x
  ; Show "Game: AB"
  ; Set Row Colour
  ldx COLMODE
  lda ScoreCol,X
  jsr NormalTextKernelColorLoad

  ; Adjust Sprite Positions
  jsr PositionHiScore

;  ; Set Row Colour
;  ldx COLMODE
;  lda ScoreCol,X
;  sta COLUP0
;  sta COLUP1

  ; Set Lines For Score Table
  ldy #MAXSCORES

  ; Show Coloured Score Table
.scoreTableLoop
;  sta WSYNC               ; [0]
  dey
  sty HROW

  ; Copy Score 1/2
  lda ScoreOffsets,Y
  ora difficulty
  tax
  lda HI_READ+$00,X
  sta HSCORE+0
  lda HI_READ+$01,X
  sta HSCORE+1
  lda HI_READ+$02,X
  sta HSCORE+2

  ; Copy Name
  lda HI_READ+$03,X
  and #%00011111
  tay
  lda (SLPTR),Y
  sta HTEXT3
  lda HI_READ+$03,X
  and #%11100000
  lsr
  lsr
  lsr
  sta TEMP
  lda HI_READ+$04,X
  and #%00000011
  ora TEMP
  tay
  lda (SLPTR),Y
  sta HTEXT4
  lda HI_READ+$04,X
  and #%01111100
  lsr
  lsr
  tay
  lda (SLPTR),Y
  sta HTEXT5

  ; Show Score Position (1 to 10)
  lda #MAXSCORES
  sec
  sbc HROW
  tay
  lda #<HL_GAP
  sta HTEXT2
  lda (HDPTR),Y
  sta HTEXT1
  lda #<HL_GAP
  cpy #MAXSCORES
  bcc .not10
  lda SLHPTR
.not10
  sta HTEXT0

  ; Copy Castle Number
  ldy #GAP_IDX              ; gap
  lda HI_READ+$05,X

; convert into BCD (0..127)
  sta TEMP
  sed                       ; [0] + 2
  lda #0                    ; [2] + 2
  ldx #7-1                  ; [4] + 2 = 6   set bit count
BitLoop6
  lsr TEMP                  ; [0] + 5       bit to carry
  bcc .skipAdd              ; [7] + 2/3     branch if no add
  adc BCDTable6,x           ; [9] + 4       else add bcd value
.skipAdd
  dex                       ; [13] + 2      decrement bit count
  bpl BitLoop6              ; [15] + 2/3    loop if more to do
                            ; = 6*16-1 = 95
  PAGE_WARN BitLoop6, "BitLoop6"
  cld                       ; [0] + 2        do not forget! :)

  tax
  lsr
  lsr
  lsr
  lsr
  beq .blankCastleHi
  tay
.blankCastleHi
  lda (HDPTR),Y
  sta HTEXT12
  txa
  and #%00001111
  bne .notBlankCastleLo
  cpy #GAP_IDX              ; still gap?
  bne .notBlankCastleLo
  lda #DASH_IDX             ; yes, show dash
.notBlankCastleLo
  tay
  lda (HDPTR),Y
  sta HTEXT13

  ; Copy Score 2/2
  ldx #<HSCORE
  jsr CopyScore

  ; Show Line
  jsr HiScoreTextCopy
  jsr HiScoreKernel
  ldy HROW
  beq .endScoreTableLoop
  jmp .scoreTableLoop

.endScoreTableLoop
  ; Reset Sprites
  sty NUSIZ0
  sty NUSIZ1
  sty VDELP0
  sty VDELP1

  BEGIN_OVERSCAN
  jmp TitlesLoop

BCDTable6:
  ; Note: values are -1 because the ADC is always done with the carry set
  .byte $63
  .byte $31, $15, $07, $03, $01, $00
  PAGE_WARN BCDTable6, "BCDTable6"

; -----------------------------------------------------------------------------
; WIPE HISCORE TABLES
; -----------------------------------------------------------------------------

WipeHiScores

WIPE_FLAG   = %11111000

  ; Initialise Prompt
  ldx #0
  stx HROW
  ; clear remains from AA logo
  stx GRP0
  stx GRP1
  stx GRP0

HiScoreWipeLoop
  ; Update Frame Counter
  dec CYCLE

  ; Play Sound Effects
  jsr HiScoreSFX

  ; Joystick Up/Down
  lda SWCHA
  and #%00110000
  cmp #%00110000
  lax DEBOUNCE
  bcs .resetWipeJoy
  ; Debounce Left/Right
  and #JOY_FLAG
  bne .endWipeJoy
  ; Play Sound
  lda #((1<<5)|3)
  sta sfx0
  ; Invert Selection
  lda HROW
  eor #WIPE_FLAG
  sta HROW
  txa
  ora #JOY_FLAG
  NOP_W
.resetWipeJoy
  and #<~JOY_FLAG
  sta DEBOUNCE
.endWipeJoy

  ; Check If Fire Pressed
  jsr CheckTitleFire
;  bit DEBOUNCE              ; FIRE_BIT
  bpl EndCheckWipeFire
  ; Check Result
  lda HROW
  beq EndWipeScores
  ; Wipe Score Table
  jsr DoReadOperation
  ldy #64*3 + 6*10 -1
  jsr ClearHiScoreRam
  jsr DoWriteOperation
EndWipeScores
  jmp FinishStartup

EndCheckWipeFire
  ; Reflect PF and Set PF Colour
  ldx #%00000001
  stx CTRLPF
  ldx #RED_NTSC|$4                  ; Red (NTSC) / Orange (PAL)
  stx COLUPF

  ; Set Message Colour
  ldx #$0E
  stx COLUP1
  stx COLUP0

  ; Position Sprites and Load First Message
  jsr PositionText
  ldy #<MsgWipeScores
  jsr LoadText

  ; Start Screen and Show First Message
  jsr StartFrame
  ldy #56*60/FPS
  jsr SkipLinesB
  jsr NormalTextKernel
  ldy #28*60/FPS
  jsr SkipLinesB

  ; Load "Wipe" Message
  tya                   ; Y = 0
  ldy #<MsgWipe
  jsr ShowWipeMsg

  ldy #7*60/FPS
  jsr SkipLinesB

  ; Load "Ignore" Message
  lda #WIPE_FLAG
  ldy #<MsgIgnore
  jsr ShowWipeMsg

  ; Skip To Next Frame
  jsr NextFrame
  jmp HiScoreWipeLoop

ShowWipeMsg SUBROUTINE
  eor HROW
  pha
  jsr LoadText

  sta WSYNC
  pla
  sta PF2
.noHighlight
  jsr NormalTextKernel
  sta WSYNC
  stx PF2               ; X = 0
  rts

; -----------------------------------------------------------------------------
; FLASH OPERATIONS
; -----------------------------------------------------------------------------

  ; X = Operation:
  ; 1 = Read Score Table
  ; 2 = Write Score Table

DoWriteOperation
  ldx #MELODY_WRITE
  NOP_W
DoReadOperation
  ldx #MELODY_READ
DoOperation SUBROUTINE
  ; Store Operation & Index
  stx OPERATION_W

  ; Do Operation
  jmp DoStall
Resume
  ; Set Vblank Timer
  ldx #VBLANKDELAY+KERNEL_DELAY
  stx TIM64T

  ; Reset Sprites
  ldx #0
  stx REFP0
  stx REFP1
  stx GRP0
  stx GRP1
  stx GRP0

  ; Check Error
  ; IF (MELODY)
  ; lda ERRORCODE_R
  ; beq EndOperation
  ; HANDLE ERROR ???
  ; ENDIF
EndOperation
  rts

; -----------------------------------------------------------------------------
; HISCORE SUBROUTINES
; -----------------------------------------------------------------------------

  ; Copy Text into ZP RAM (Y Contains Message Offset)
LoadText SUBROUTINE
  lda CYCLE
  lsr
  tya
  bcc .loadFlickerText
  bcs .loadNormalText
.loadFlickerText
  adc #MSG_DL_OFFSET
.loadNormalText
  tay
  lda HiScoreMsg+11,Y
  sta HTEXT11
  lda HiScoreMsg+10,Y
  sta HTEXT10
  lda HiScoreMsg+9,Y
  sta HTEXT9
  lda HiScoreMsg+8,Y
  sta HTEXT8
  lda HiScoreMsg+7,Y
  sta HTEXT7
  lda HiScoreMsg+6,Y
  sta HTEXT6
  lda HiScoreMsg+5,Y
  sta HTEXT5
  lda HiScoreMsg+4,Y
  sta HTEXT4
  lda HiScoreMsg+3,Y
  sta HTEXT3
  lda HiScoreMsg+2,Y
  sta HTEXT2
  lda HiScoreMsg+1,Y
  sta HTEXT1
  lda HiScoreMsg+0,Y
  sta HTEXT0
  jmp NormalTextCopy

; -----------------------------------------------------------------------------

  ; Copy text Into Buffer For Display (Combining Pairs Of Characters)
HiScoreTextCopy
  ldx HTEXT13       ; [0] + 3
  ldy HTEXT12       ; [3] + 3
  lda HRChars+4,X   ; [6] + 4
  ora HLChars+4,Y   ; [10] + 4
  sta HBUFF+34      ; [14] + 3
  lda HRChars+3,X   ; [17] + 4
  ora HLChars+3,Y   ; [21] + 4
  sta HBUFF+33      ; [25] + 3
  lda HRChars+2,X   ; [28] + 4
  ora HLChars+2,Y   ; [32] + 4
  sta HBUFF+32      ; [36] + 3
  lda HRChars+1,X   ; [39] + 4
  ora HLChars+1,Y   ; [43] + 4
  sta HBUFF+31      ; [45] + 3
  lda HRChars+0,X   ; [50] + 4
  ora HLChars+0,Y   ; [54] + 4
  sta HBUFF+30      ; [58] + 3
NormalTextCopy
  ldx HTEXT11       ; [0] + 3
  ldy HTEXT10       ; [3] + 3
  lda HRChars+4,X   ; [6] + 4
  ora HLChars+4,Y   ; [10] + 4
  sta HBUFF+29      ; [14] + 3
  lda HRChars+3,X   ; [17] + 4
  ora HLChars+3,Y   ; [21] + 4
  sta HBUFF+28      ; [25] + 3
  lda HRChars+2,X   ; [28] + 4
  ora HLChars+2,Y   ; [32] + 4
  sta HBUFF+27      ; [36] + 3
  lda HRChars+1,X   ; [39] + 4
  ora HLChars+1,Y   ; [43] + 4
  sta HBUFF+26      ; [45] + 3
  lda HRChars+0,X   ; [50] + 4
  ora HLChars+0,Y   ; [54] + 4
  sta HBUFF+25      ; [58] + 3

  ldx HTEXT9        ; [0] + 3
  ldy HTEXT8        ; [3] + 3
  lda HRChars+4,X   ; [6] + 4
  ora HLChars+4,Y   ; [10] + 4
  sta HBUFF+24      ; [14] + 3
  lda HRChars+3,X   ; [17] + 4
  ora HLChars+3,Y   ; [21] + 4
  sta HBUFF+23      ; [25] + 3
  lda HRChars+2,X   ; [28] + 4
  ora HLChars+2,Y   ; [32] + 4
  sta HBUFF+22      ; [36] + 3
  lda HRChars+1,X   ; [39] + 4
  ora HLChars+1,Y   ; [43] + 4
  sta HBUFF+21      ; [45] + 3
  lda HRChars+0,X   ; [50] + 4
  ora HLChars+0,Y   ; [54] + 4
  sta HBUFF+20      ; [58] + 3

  ldx HTEXT7        ; [0] + 3
  ldy HTEXT6        ; [3] + 3
  lda HRChars+4,X   ; [6] + 4
  ora HLChars+4,Y   ; [10] + 4
  sta HBUFF+19      ; [14] + 3
  lda HRChars+3,X   ; [17] + 4
  ora HLChars+3,Y   ; [21] + 4
  sta HBUFF+18      ; [25] + 3
  lda HRChars+2,X   ; [28] + 4
  ora HLChars+2,Y   ; [32] + 4
  sta HBUFF+17      ; [36] + 3
  lda HRChars+1,X   ; [39] + 4
  ora HLChars+1,Y   ; [43] + 4
  sta HBUFF+16      ; [45] + 3
  lda HRChars+0,X   ; [50] + 4
  ora HLChars+0,Y   ; [54] + 4
  sta HBUFF+15      ; [58] + 3

  ldx HTEXT5        ; [0] + 3
  ldy HTEXT4        ; [3] + 3
  lda HRChars+4,X   ; [6] + 4
  ora HLChars+4,Y   ; [10] + 4
  sta HBUFF+14      ; [14] + 3
  lda HRChars+3,X   ; [17] + 4
  ora HLChars+3,Y   ; [21] + 4
  sta HBUFF+13      ; [25] + 3
  lda HRChars+2,X   ; [28] + 4
  ora HLChars+2,Y   ; [32] + 4
  sta HBUFF+12      ; [36] + 3
  lda HRChars+1,X   ; [39] + 4
  ora HLChars+1,Y   ; [43] + 4
  sta HBUFF+11      ; [45] + 3
  lda HRChars+0,X   ; [50] + 4
  ora HLChars+0,Y   ; [54] + 4
  sta HBUFF+10      ; [58] + 3

  ldx HTEXT3        ; [0] + 3
  ldy HTEXT2        ; [3] + 3
  lda HRChars+4,X   ; [6] + 4
  ora HLChars+4,Y   ; [10] + 4
  sta HBUFF+9       ; [14] + 3
  lda HRChars+3,X   ; [17] + 4
  ora HLChars+3,Y   ; [21] + 4
  sta HBUFF+8       ; [25] + 3
  lda HRChars+2,X   ; [28] + 4
  ora HLChars+2,Y   ; [32] + 4
  sta HBUFF+7       ; [36] + 3
  lda HRChars+1,X   ; [39] + 4
  ora HLChars+1,Y   ; [43] + 4
  sta HBUFF+6       ; [45] + 3
  lda HRChars+0,X   ; [50] + 4
  ora HLChars+0,Y   ; [54] + 4
  sta HBUFF+5       ; [58] + 3

  ldx HTEXT1        ; [0] + 3
  ldy HTEXT0        ; [3] + 3
  lda HRChars+4,X   ; [6] + 4
  ora HLChars+4,Y   ; [10] + 4
  sta HBUFF+4       ; [14] + 3
  lda HRChars+3,X   ; [17] + 4
  ora HLChars+3,Y   ; [21] + 4
  sta HBUFF+3       ; [25] + 3
  lda HRChars+2,X   ; [28] + 4
  ora HLChars+2,Y   ; [32] + 4
  sta HBUFF+2       ; [36] + 3
  lda HRChars+1,X   ; [39] + 4
  ora HLChars+1,Y   ; [43] + 4
  sta HBUFF+1       ; [45] + 3
  lda HRChars+0,X   ; [50] + 4
  ora HLChars+0,Y   ; [54] + 4
  sta HBUFF+0       ; [58] + 3

  rts               ; [0] + 6
                    ; TOTAL: 7*61 + 6 = 433

; -----------------------------------------------------------------------------

; Copy Score (Score Start Pointer Is In X)
CopyScore
  bit HDPTR+1           ; set overflow flag
  ldy #GAP_IDX          ; blank/gap
  lda $02,X
  lsr
  lsr
  lsr
  lsr
  beq .blank0           ; remove leading zeroes
  clv
  tay
.blank0
  lda (HDPTR),Y
  sta HTEXT6
  lda $02,X
  and #%00001111
  bvc .noBlank1         ; remove leading zeroes
  beq .blank1
  clv
.noBlank1
  tay
.blank1
  lda (HDPTR),Y
  sta HTEXT7
  lda $01,X
  lsr
  lsr
  lsr
  lsr
  bvc .noBlank2         ; remove leading zeroes
  beq .blank2
  clv
.noBlank2
  tay
.blank2
  lda (HDPTR),Y
  sta HTEXT8
  lda $01,X
  and #%00001111
  bvc .noBlank3         ; remove leading zeroes
  beq .blank3
  clv
.noBlank3
  tay
.blank3
  lda (HDPTR),Y
  sta HTEXT9
  lda $00,X
  lsr
  lsr
  lsr
  lsr
  bvc .noBlank4         ; remove leading zeroes
  beq .blank4
  clv
.noBlank4
  tay
.blank4
  lda (HDPTR),Y
  sta HTEXT10
  lda $00,X
  and #%00001111
  bvc .noBlank5         ; remove leading zeroes
  bne .noBlank5
  lda #DASH_IDX         ; dash
.noBlank5
  tay
.blank5
  lda (HDPTR),Y
  sta HTEXT11
  rts

; -----------------------------------------------------------------------------

SetScorePointers SUBROUTINE
  ; Set Pointers
  lda CYCLE
  lsr
  bcs .hiscoreBPointers
;HiscoreAPointers
  lda #<ScoreLettersA
  sta SLPTR
  lda #<HiScoreDigitsA
  sta HDPTR
;  lda #<ScoreLabelsLoA
;  sta SLLPTR
;  ldx #<ScoreLabelsHiA
  ldy #>ScoreLettersA
  lda #>HiScoreDigitsA
  ldx #<HL_11
  bne .setPointers

.hiscoreBPointers
  lda #<ScoreLettersB
  sta SLPTR
  lda #<HiScoreDigitsB
  sta HDPTR
;  lda #<ScoreLabelsLoB
;  sta SLLPTR
;  ldx #<ScoreLabelsHiB
  ldy #>ScoreLettersB
  lda #>HiScoreDigitsB
  ldx #<DL_11
.setPointers
  stx SLHPTR
  sty SLPTR+1
  sta HDPTR+1
;  sta SLLPTR+1
;  sta SLHPTR+1
  rts

; -----------------------------------------------------------------------------

HiScoreSFX
  ; Play High Score SFX
  ldx #>HSoundTab
  stx SPTR+1
  lax sfx0
  beq EndHSounds
  and #%00011111
  tay
  dey
  bpl PlayHSound
  ldx #0
  stx sfx0
  beq EndHSounds

PlayHSound
  sty TEMP
  txa
  and #%11100000
  ora TEMP
  sta sfx0
  lsr
  lsr
  lsr
  lsr
  lsr
  tax
  lda HSoundTab,X
  sta SPTR
  lda (SPTR),Y
  sta AUDF1
  ldx #5
  stx AUDC1
EndHSounds
  stx AUDV1
  rts

; -----------------------------------------------------------------------------
; HISCORE DISPLAY KERNELS
; -----------------------------------------------------------------------------

NameKernel
  sta WSYNC                 ; [0]

  ; Reset Movements
  sta HMCLR                 ; [0] + 3

  ; Player 0 Two Copies Close
  ldx #%11110001            ; [3] + 2
  stx HMP0                  ; [5] + 3
  stx NUSIZ0                ; [8] + 3

  ; No Sprite Delays
  ldx #0                    ; [11] + 2
  stx NUSIZ1                ; [13] + 3
  stx VDELP0                ; [16] + 3
  stx VDELP1                ; [19] + 3

  ; Name Pointers
  ldy NAME+0                ; [22] + 3
  lda (SLPTR),Y             ; [25] + 5
  sta HPTR0                 ; [30] + 3
  ldy NAME+1                ; [33] + 3
  lda (SLPTR),Y             ; [36] + 5

  ; Sprite Positions (Coarse)
  sta RESP0                 ; [41] + 3 = 44 EXACT
  sta RESP1                 ; [44] + 3 = 47 EXACT

  sta HPTR1                 ; [47] + 3
  ldy NAME+2                ; [50] + 3
  lda (SLPTR),Y             ; [53] + 5
  sta HPTR2                 ; [58] + 3

  ; Name High Pointers
  ldx #>HLChars             ; [61] + 2
  stx HPTR0+1               ; [63] + 3
  stx HPTR1+1               ; [66] + 3
  stx HPTR2+1               ; [69] + 3

  ; Move Sprites (Fine)
  sta HMOVE                 ; [72] + 3

  ; Show Name
  ldy #5-1                  ; [13] + 2
NameKernelLoop
  sta WSYNC                 ; [0]
  lda NAMECOL+0             ; [0] + 3
  sta COLUP0                ; [3] + 3   < 46
  lda (HPTR0),Y             ; [6] + 5
  sta GRP0                  ; [11] + 3  < 46
  lda NAMECOL+1             ; [14] + 3
  sta COLUP1                ; [17] + 3  < 48
  lda (HPTR1),Y             ; [20] + 5
  sta GRP1                  ; [25] + 3  < 48
  ldx NAMECOL+2             ; [28] + 3
  lda (HPTR2),Y             ; [31] + 5
  SLEEP 7                   ; [36] + 7
  dey                       ; [43] + 2
  sta GRP0                  ; [45] + 3  > 48 < 52
  stx COLUP0                ; [48] + 3  > 48 < 52
  bpl NameKernelLoop

  ; Clear Sprites
  iny
  sta WSYNC
  sty GRP1
  sty GRP0
  sty GRP1
  rts

; -----------------------------------------------------------------------------
; Some code moved here from Bank 0
; -----------------------------------------------------------------------------

DrawStarsBank3 SUBROUTINE
; 158 bytes with 10 extra lines
  ldx #YOFFSET
  bcc .contLoop
.starsLoop
  dey
  ; Draw Stars
  sta WSYNC                 ; [0]
;--------------------------------------
  lda TopStars_A,y          ; [0] + 4
  bcs .drawStarsA           ; [0] + 2/3
  lda TopStars_B,y          ; [2] + 4
.drawStarsA
  sta ENAM1                 ; [6] + 3
  sta HMM1                  ; [9] + 3
  dex                       ; [12] + 2
  bne .contLoop             ; [14] + 2/3
  bcc .exitLoop             ; [16] + 2/3
.contLoop
  ; Move Sprites
  sta WSYNC                 ; [0]
;--------------------------------------
  sta HMOVE                 ; [0] + 3
  ; Clear Stars
  lda #0                    ; [3] + 2
  sta ENAM1                 ; [5] + 3
  txa                       ; [8] + 2
  bne .starsLoop            ; [10] + 2/3
.exitLoop
  txa
  sta WSYNC
  sta ENAM1
  jmp ReturnFromDrawStars   ; [19/12] + 3

; -----------------------------------------------------------------------------

  ; Sound Effects (Lower = Higher Priority)
  ; 1 = Select
  ; 2 = Move
HSoundTab
  DC.B  0, <HSelectSnd, <HMoveSnd
HSelectSnd
  DC.B  31, 31, 31, 31
HMoveSnd
  DC.B  24, 24, 24, 24

  ; Star Data
TopStars_A
  TOP_STARS_A
TopStars_B
  TOP_STARS_B
BottomStars_A
  BOTTOM_STARS_A
BottomStars_B
  BOTTOM_STARS_B
;  PAGE_WARN TopStars_A, "TopStars_A"

; -----------------------------------------------------------------------------

PositionHiScore
  ; Position Sprites
  sta WSYNC                 ; [0]
  SLEEP 5                   ; [0] + 5
  ; Set 3 sprite copies (medium) and no delay
  lda #%00000110            ; [5] + 2
  sta NUSIZ0                ; [7] + 3
  sta VDELP0                ; [10] + 3
  sta VDELP1                ; [13] + 3
  ; Set 3 sprite copies (close)
  lsr                       ; [16] + 2
  sta NUSIZ1                ; [18] + 3
  ; Position Sprites
  lda #%11100000            ; [21] + 2
  sta HMP0                  ; [23] + 3
  nop                       ; [26] + 2
  sta RESP0                 ; [28] + 3  = 31
  sta HMP1                  ; [31] + 3
  nop                       ; [34] + 2
  sta RESP1                 ; [36] + 3  = 39
  bne FinePos

; -----------------------------------------------------------------------------

PositionText
  sta WSYNC                 ; [0]
  ; Set 3 Copies Close and Delay
  lda #%00110011            ; [0] + 2
  sta VDELP0                ; [2] + 3
  sta VDELP1                ; [5] + 3
  sta NUSIZ0                ; [8] + 3
  sta NUSIZ1                ; [11] + 3
  ; Coarse Position
  sta HMCLR                 ; [14] + 3
  lda #%11110000            ; [29] + 2
  sta HMP1                  ; [31] + 3
  sta.w RESM0               ; [22] + 4  = 26
  asl                       ; [17] + 2
  sta HMP0                  ; [19] + 3
  sta HMM0                  ; [26] + 3
  nop                       ; [34] + 2
  sta RESP0                 ; [36] + 3  = 39
  sta RESP1                 ; [39] + 3  = 42
  sta ENAM0                 ; [42] + 3
  sta ENAM1                 ; [45] + 3
FinePos
  ; Fine Position
  sta WSYNC                 ; [0]
  sta HMOVE                 ; [0] + 3
  rts                       ; [8] + 6 = 14

; -----------------------------------------------------------------------------

  ; Wait For Next Frame
NextFrame SUBROUTINE
  BEGIN_OVERSCAN
  BEGIN_VBLANK_MSG
  rts

; -----------------------------------------------------------------------------

;  ALIGN_FREE_LBL 256, "HiScoreKernel"

  ; Display Hi Score Table Line (Unrolled)
HiScoreKernel
  sta WSYNC                 ; [0]
  SLEEP 10                  ; [0] + 10
  lda #%00000011            ; [10] + 2
  sta NUSIZ1                ; [12] + 3
  lda HBUFF+4               ; [15] + 3
  sta GRP0                  ; [18] + 3   < 34
  lda HBUFF+19              ; [21] + 3
  sta GRP1                  ; [24] + 3  < 42
  ldx HBUFF+14              ; [27] + 3
  ldy HBUFF+34              ; [30] + 3
  lda HBUFF+24              ; [33] + 3
  sta GRP0                  ; [36] + 3  > 36 < 44
  lda HBUFF+29              ; [39] + 3
  sta GRP1                  ; [42] + 3  > 44 < 47
  lda HBUFF+9               ; [45] + 3
  sta GRP1                  ; [48] + 3  > 49 < 52
  stx GRP0                  ; [51] + 3  > 46 < 55
  lda #%00000110            ; [54] + 2
  sta NUSIZ1                ; [56] + 3  > 54 < 63
  sty GRP1                  ; [59] + 3  > 54 < 63
  sta WSYNC                 ; [0]
  SLEEP 10                  ; [0] + 5
  lsr                       ; [5] + 2
  sta NUSIZ1                ; [7] + 3
  lda HBUFF+3               ; [10] + 3
  sta GRP0                  ; [13] + 3   < 34
  lda HBUFF+18              ; [16] + 3
  sta GRP1                  ; [19] + 3  < 42
  ldx HBUFF+13              ; [22] + 3
  ldy HBUFF+33              ; [25] + 3
  lda HBUFF+23              ; [28] + 3
  sta GRP0                  ; [34] + 3  > 36 < 44
  lda HBUFF+28              ; [39] + 3
  sta GRP1                  ; [42] + 3  > 44 < 47
  lda HBUFF+8               ; [45] + 3
  sta GRP1                  ; [48] + 3  > 49 < 52
  stx GRP0                  ; [51] + 3  > 46 < 55
  lda #%00000110            ; [54] + 2
  sta NUSIZ1                ; [56] + 3  > 54 < 63
  sty GRP1                  ; [59] + 3  > 54 < 63
  sta WSYNC                 ; [0]
  SLEEP 10                  ; [0] + 5
  lsr                       ; [5] + 2
  sta NUSIZ1                ; [7] + 3
  lda HBUFF+2               ; [10] + 3
  sta GRP0                  ; [13] + 3   < 34
  lda HBUFF+17              ; [16] + 3
  sta GRP1                  ; [19] + 3  < 42
  ldx HBUFF+12              ; [22] + 3
  ldy HBUFF+32              ; [25] + 3
  lda HBUFF+22              ; [28] + 3
  sta GRP0                  ; [34] + 3  > 36 < 44
  lda HBUFF+27              ; [39] + 3
  sta GRP1                  ; [42] + 3  > 44 < 47
  lda HBUFF+7               ; [45] + 3
  sta GRP1                  ; [48] + 3  > 49 < 52
  stx GRP0                  ; [51] + 3  > 46 < 55
  lda #%00000110            ; [54] + 2
  sta NUSIZ1                ; [56] + 3  > 54 < 63
  sty GRP1                  ; [59] + 3  > 54 < 63
  sta WSYNC                 ; [0]
  SLEEP 10                  ; [0] + 10
  lsr                       ; [5] + 2
  sta NUSIZ1                ; [7] + 3
  lda HBUFF+1               ; [10] + 3
  sta GRP0                  ; [13] + 3   < 34
  lda HBUFF+16              ; [16] + 3
  sta GRP1                  ; [19] + 3  < 42
  ldx HBUFF+11              ; [22] + 3
  ldy HBUFF+31              ; [25] + 3
  lda HBUFF+21              ; [28] + 3
  sta GRP0                  ; [34] + 3  > 36 < 44
  lda HBUFF+26              ; [39] + 3
  sta GRP1                  ; [42] + 3  > 44 < 47
  lda HBUFF+6               ; [45] + 3
  sta GRP1                  ; [48] + 3  > 49 < 52
  stx GRP0                  ; [51] + 3  > 46 < 55
  lda #%00000110            ; [54] + 2
  sta NUSIZ1                ; [56] + 3  > 54 < 63
  sty GRP1                  ; [59] + 3  > 54 < 63
  sta WSYNC                 ; [0]
  SLEEP 10                  ; [0] + 5
  lsr                       ; [5] + 2
  sta NUSIZ1                ; [7] + 3
  lda HBUFF+0               ; [10] + 3
  sta GRP0                  ; [13] + 3   < 34
  lda HBUFF+15              ; [16] + 3
  sta GRP1                  ; [19] + 3  < 42
  ldx HBUFF+10              ; [22] + 3
  ldy HBUFF+30              ; [25] + 3
  lda HBUFF+20              ; [28] + 3
  sta GRP0                  ; [34] + 3  > 36 < 44
  lda HBUFF+25              ; [39] + 3
  sta GRP1                  ; [42] + 3  > 44 < 47
  lda HBUFF+5               ; [45] + 3
  sta GRP1                  ; [48] + 3  > 49 < 52
  stx GRP0                  ; [51] + 3  > 46 < 55
  lda #%00000110            ; [54] + 2
  sta NUSIZ1                ; [56] + 3  > 54 < 63
  sty GRP1                  ; [59] + 3  > 54 < 63
  lda #0                    ; [62] + 2
  sta GRP0                  ; [64] + 3  > 57
  sta GRP1                  ; [67] + 3  > 65
  sta GRP0                  ; [70] + 3
  rts                       ; [5] + 6 = 11
;  PAGE_WARN HiScoreKernel, "HiScoreKernel"

; -----------------------------------------------------------------------------

CheckTitleFire SUBROUTINE
  ; Debounce Fire Button
  lax DEBOUNCE
  bit INPT4
  bmi .resetTitleFire
  ; Ignore If Previously Pressed
  and #BUTTON_FLAG
  bne .clearTitleFire
  ; Set Fire Pressed & State
  txa
  ora #(BUTTON_FLAG|BUTTON_BIT)
  bne .storeTitleFire

.resetTitleFire
  and #<~(BUTTON_FLAG|BUTTON_BIT)
  NOP_B
.clearTitleFire
  txa
  and #<~BUTTON_BIT
.storeTitleFire
  sta DEBOUNCE
  rts


; -----------------------------------------------------------------------------
; HISCORE DATA
; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "HiScoreMsg"

  ; HiScore Message
HiScoreMsg
MsgWipeScores   ; Wipe Scores?
  DC.B  <HL_WW, <HL_II, <HL_PP, <HL_EE, <HL_GAP, <HL_SS
  DC.B  <HL_CC, <HL_OO, <HL_RR, <HL_EE, <HL_SS, <HL_QMARK
MsgNewHiscore   ; New Hiscore!
  DC.B  <HL_NN, <HL_EE, <HL_WW, <HL_GAP, <HL_HH, <HL_II
  DC.B  <HL_SS, <HL_CC, <HL_OO, <HL_RR, <HL_EE, <HL_BANG
MsgFireToSave   ; Fire To Save
  DC.B  <HL_FF, <HL_II, <HL_RR, <HL_EE, <HL_GAP, <HL_TT
  DC.B  <HL_OO, <HL_GAP, <HL_SS, <HL_AA, <HL_VV, <HL_EE
MsgHallOfFame   ; Hall Of Fame
  DC.B  <HL_HH, <HL_AA, <HL_LL, <HL_LL, <HL_GAP, <HL_OO
  DC.B  <HL_FF, <HL_GAP, <HL_FF, <HL_AA, <HL_MM, <HL_EE
MsgEnterName    ; Enter Name
  DC.B  <HL_GAP, <HL_EE, <HL_NN, <HL_TT, <HL_EE, <HL_RR
  DC.B  <HL_GAP, <HL_NN, <HL_AA, <HL_MM, <HL_EE;, <HL_GAP
MsgWipe         ; Wipe!!
  DC.B  <HL_GAP, <HL_GAP, <HL_GAP, <HL_WW, <HL_II, <HL_PP
  DC.B  <HL_EE, <HL_BANG, <HL_BANG;, <HL_GAP, <HL_GAP, <HL_GAP
MsgIgnore       ; Ignore
  DC.B  <HL_GAP, <HL_GAP, <HL_GAP, <HL_II, <HL_GG, <HL_NN
  DC.B  <HL_OO, <HL_RR, <HL_EE, <HL_GAP;, <HL_GAP, <HL_GAP
;MsgGameBB       ; Game: BB
;  DC.B  <HL_GAP, <HL_GAP, <HL_GG, <HL_AA, <HL_MM, <HL_EE
;  DC.B  <HL_COLON, <HL_GAP, <HL_BB, <HL_BB;, <HL_GAP, <HL_GAP
;MsgGameAB       ; Game: AB
;  DC.B  <HL_GAP, <HL_GAP, <HL_GG, <HL_AA, <HL_MM, <HL_EE
;  DC.B  <HL_COLON, <HL_GAP, <HL_AA, <HL_BB;, <HL_GAP, <HL_GAP
;MsgGameBA       ; Game: BA
;  DC.B  <HL_GAP, <HL_GAP, <HL_GG, <HL_AA, <HL_MM, <HL_EE
;  DC.B  <HL_COLON, <HL_GAP, <HL_Bb, <HL_AA;, <HL_GAP, <HL_GAP
;MsgGameAA       ; Game: AA
;  DC.B  <HL_GAP, <HL_GAP, <HL_GG, <HL_AA, <HL_MM, <HL_EE
;  DC.B  <HL_COLON, <HL_GAP, <HL_AA, <HL_AA, <HL_GAP, <HL_GAP
MsgGameBB       ; Game: BB
  DC.B  <HL_GAP, <HL_GAP, <HL_GAP, <HL_GG, <HL_AA, <HL_MM
  DC.B  <HL_EE, <HL_GAP, <HL_11;, <HL_GAP, <HL_GAP, <HL_GAP
MsgGameAB       ; Game: AB
  DC.B  <HL_GAP, <HL_GAP, <HL_GAP, <HL_GG, <HL_AA, <HL_MM
  DC.B  <HL_EE, <HL_GAP, <HL_22;, <HL_GAP, <HL_GAP, <HL_GAP
MsgGameBA       ; Game: BA
  DC.B  <HL_GAP, <HL_GAP, <HL_GAP, <HL_GG, <HL_AA, <HL_MM
  DC.B  <HL_EE, <HL_GAP, <HL_33;, <HL_GAP, <HL_GAP, <HL_GAP
MsgGameAA       ; Game: AA
  DC.B  <HL_GAP, <HL_GAP, <HL_GAP, <HL_GG, <HL_AA, <HL_MM
  DC.B  <HL_EE, <HL_GAP, <HL_44, <HL_GAP, <HL_GAP, <HL_GAP

MSG_DL_OFFSET = . - HiScoreMsg

  ; Wipe Scores?
  DC.B  <DL_WW, <DL_II, <DL_PP, <DL_EE, <DL_GAP, <DL_SS
  DC.B  <DL_CC, <DL_OO, <DL_RR, <DL_EE, <DL_SS, <DL_QMARK
  ; New Hiscore!
  DC.B  <DL_NN, <DL_EE, <DL_WW, <DL_GAP, <DL_HH, <DL_II
  DC.B  <DL_SS, <DL_CC, <DL_OO, <DL_RR, <DL_EE, <DL_BANG
  ; Fire To Save
  DC.B  <DL_FF, <DL_II, <DL_RR, <DL_EE, <DL_GAP, <DL_TT
  DC.B  <DL_OO, <DL_GAP, <DL_SS, <DL_AA, <DL_VV, <DL_EE
  ; Hall Of Fame
  DC.B  <DL_HH, <DL_AA, <DL_LL, <DL_LL, <DL_GAP, <DL_OO
  DC.B  <DL_FF, <DL_GAP, <DL_FF, <DL_AA, <DL_MM, <DL_EE
  ; Enter Name
  DC.B  <DL_GAP, <DL_EE, <DL_NN, <DL_TT, <DL_EE, <DL_RR
  DC.B  <DL_GAP, <DL_NN, <DL_AA, <DL_MM, <DL_EE;, <DL_GAP
  ; Wipe!!
  DC.B  <DL_GAP, <DL_GAP, <DL_GAP, <DL_WW, <DL_II, <DL_PP
  DC.B  <DL_EE, <DL_BANG, <DL_BANG;, <DL_GAP, <DL_GAP, <DL_GAP
  ; Ignore
  DC.B  <DL_GAP, <DL_GAP, <DL_GAP, <DL_II, <DL_GG, <DL_NN
  DC.B  <DL_OO, <DL_RR, <DL_EE, <DL_GAP;, <DL_GAP, <DL_GAP
;  ; Game: BB
;  DC.B  <DL_GAP, <DL_GAP, <DL_GG, <DL_AA, <DL_MM, <DL_EE
;  DC.B  <DL_COLON, <DL_GAP, <DL_BB, <DL_BB;, <DL_GAP, <DL_GAP
;  ; Game: BA
;  DC.B  <DL_GAP, <DL_GAP, <DL_GG, <DL_AA, <DL_MM, <DL_EE
;  DC.B  <DL_COLON, <DL_GAP, <DL_AA, <DL_BB;, <DL_GAP, <DL_GAP
;  ; Game: AB
;  DC.B  <DL_GAP, <DL_GAP, <DL_GG, <DL_AA, <DL_MM, <DL_EE
;  DC.B  <DL_COLON, <DL_GAP, <DL_BB, <DL_AA;, <DL_GAP, <DL_GAP
;  ; Game: AA
;  DC.B  <DL_GAP, <DL_GAP, <DL_GG, <DL_AA, <DL_MM, <DL_EE
;  DC.B  <DL_COLON, <DL_GAP, <DL_AA, <DL_AA, <DL_GAP, <DL_GAP
  ; Game 1
  DC.B  <DL_GAP, <DL_GAP, <DL_GAP, <DL_GG, <DL_AA, <DL_MM
  DC.B  <DL_EE, <DL_GAP, <DL_11;, <DL_GAP, <DL_GAP, <DL_GAP
  ; Game 2
  DC.B  <DL_GAP, <DL_GAP, <DL_GAP, <DL_GG, <DL_AA, <DL_MM
  DC.B  <DL_EE, <DL_GAP, <DL_22;, <DL_GAP, <DL_GAP, <DL_GAP
  ; Game 3
  DC.B  <DL_GAP, <DL_GAP, <DL_GAP, <DL_GG, <DL_AA, <DL_MM
  DC.B  <DL_EE, <DL_GAP, <DL_33;, <DL_GAP, <DL_GAP, <DL_GAP
  ; Game 4
  DC.B  <DL_GAP, <DL_GAP, <DL_GAP, <DL_GG, <DL_AA, <DL_MM
  DC.B  <DL_EE, <DL_GAP, <DL_44, <DL_GAP, <DL_GAP, <DL_GAP

  PAGE_WARN HiScoreMsg, "HiScoreMsg"

DifficultyMsgTbl
  .byte <MsgGameBB, <MsgGameAB, <MsgGameBA, <MsgGameAA

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL   256, "LEFTCHARS"

  ; Small Font LHS
  LEFTCHARS

  ; Score Digits Table (30 Entries)
HiScoreDigitsA
  DC.B  <HL_00, <HL_11, <HL_22, <HL_33, <HL_44
  DC.B  <HL_55, <HL_66, <HL_77, <HL_88, <HL_99, <HL_00, <HL_GAP, HL_DASH
HiScoreDigitsB
  DC.B  <DL_00, <DL_11, <DL_22, <DL_33, <DL_44
  DC.B  <DL_55, <DL_66, <DL_77, <DL_88, <DL_99, <DL_00, <DL_GAP, DL_DASH
;ScoreLabelsLoA
;  DC.B  <HL_00, <HL_99, <HL_88, <HL_77, <HL_66
;  DC.B  <HL_55, <HL_44, <HL_33, <HL_22, <HL_11
;ScoreLabelsLoB
;  DC.B  <DL_00, <DL_99, <DL_88, <DL_77, <DL_66
;  DC.B  <DL_55, <DL_44, <DL_33, <DL_22, <DL_11
;ScoreLabelsHiA
;ScoreLabelsHiB
;  DC.B  <HL_GAP, <HL_GAP, <HL_GAP, <HL_GAP, <HL_GAP
;  DC.B  <HL_GAP, <HL_GAP, <HL_GAP, <HL_GAP, <HL_GAP
;  DC.B  <HL_11
  PAGE_WARN HiScoreDigitsA, "HiScoreDigitsA"

  ; Score Tables
ScoreOffsets
;  DC.B  54, 48, 42, 36, 30, 24, 18, 12, 6, 0
_ENTRIES_SIZE = 6
_VAL SET MAXSCORES * _ENTRIES_SIZE
 REPEAT MAXSCORES
_VAL SET _VAL - _ENTRIES_SIZE
    .byte  _VAL
 REPEND

  ; Wait For Start Of Screen
StartFrame
  BEGIN_FRAME
  rts

  ; Skip Screen Lines
SkipLinesB
  sta WSYNC
  dey
  bne SkipLinesB
  rts

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "RIGHTCHARS"

  ; Small Font RHS
  RIGHTCHARS

  ; Score Letters Table (32 Entries)
ScoreLettersA
  DC.B  <HL_DASH
  DC.B  <HL_AA, <HL_BB, <HL_CC, <HL_DD, <HL_EE, <HL_FF, <HL_GG, <HL_HH
  DC.B  <HL_II, <HL_JJ, <HL_KK, <HL_LL, <HL_MM, <HL_NN, <HL_OO, <HL_PP
  DC.B  <HL_QQ, <HL_RR, <HL_SS, <HL_TT, <HL_UU, <HL_VV, <HL_WW, <HL_XX
  DC.B  <HL_YY, <HL_ZZ, <HL_BANG
  DC.B  <HL_QMARK, <HL_DOT, <HL_COLON, <HL_GAP
ScoreLettersB
  DC.B  <DL_DASH
  DC.B  <DL_AA, <DL_BB, <DL_CC, <DL_DD, <DL_EE, <DL_FF, <DL_GG, <DL_HH
  DC.B  <DL_II, <DL_JJ, <DL_KK, <DL_LL, <DL_MM, <DL_NN, <DL_OO, <DL_PP
  DC.B  <DL_QQ, <DL_RR, <DL_SS, <DL_TT, <DL_UU, <DL_VV, <DL_WW, <DL_XX
  DC.B  <DL_YY, <DL_ZZ, <DL_BANG
  DC.B  <DL_QMARK, <DL_DOT, <DL_COLON, <DL_GAP
  PAGE_WARN ScoreLettersA, "ScoreLettersA"

  ; Score Colours
ScoreCol
  DC.B  TEXT_COL_NTSC|$C, TEXT_COL_PAL|$C, TEXT_COL_BW  ; NTSC/PAL/B&W
HeadingCol
;  DC.B  GREEN_NTSC|$C,  GREEN_PAL|$C,  $08             ; NTSC/PAL/B&W
  DC.B  YELLOW_NTSC|$C, YELLOW_PAL|$e, $0a+2              ; NTSC/PAL/B&W
;  DC.B  ORANGE_NTSC|$C, ORANGE_PAL|$a, $0c              ; NTSC/PAL/B&W
FireCol
  DC.B  RED_NTSC|$a,    RED_PAL|$a,    $0e              ; NTSC/PAL/B&W

  ; Title Message Delays
MessageDelay
;  DC.B  127, 63, 63
  DC.B  FPS*2-1, FPS-1, FPS-1

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "NormalTextKernelColorLoad"

NormalTextKernelColorLoad
  sta COLUP1
  sta COLUP0
NormalTextKernelLoad
  jsr LoadText
NormalTextKernel
  ldx #5
HiScoreTextLoop
  dex                       ; [60] + 3
  sta WSYNC                 ; [63]
  stx TEMP2                 ; [0] + 3
  ldy HBUFF+0,X             ; [3] + 4                  0A 0B 1A 1B
  sty GRP0                  ; [7] + 3                  0 - - -
  lda HBUFF+5,X             ; [10] + 4
  sta GRP1                  ; [14] + 3  < 42            - 0 1 0
  lda HBUFF+10,X            ; [17] + 4
  sta GRP0                  ; [21] + 3  < 44            2 0 - 1
  ldy HBUFF+20,X            ; [24] + 4
  lda HBUFF+25,X            ; [28] + 4
  sta TEMP                  ; [32] + 3
  lda HBUFF+15,X            ; [35] + 4
  ldx TEMP                  ; [39] + 3
  sta GRP1                  ; [42] + 3  > 44 < 47       - 2 3 1
  sty GRP0                  ; [45] + 3  > 46 < 50       4 2 - 3
  stx GRP1                  ; [48] + 3  > 49 < 52       - 4 5 3
  sta GRP0                  ; [51] + 3  > 52 < 55       - 4 - 5
  ldx TEMP2                 ; [54] + 3
  bne HiScoreTextLoop       ; [57] + 2/3
  PAGE_WARN HiScoreTextLoop, "HiScoreTextLoop"
  stx GRP0                  ; [59] + 3
  stx GRP1                  ; [62] + 3
  stx GRP0                  ; [65] + 3
  rts                       ; [68] + 6

; -----------------------------------------------------------------------------

  ; Clear RAM+ Memory
ClearExtraRam SUBROUTINE
  jsr StartFrame
  ldy #0
ClearHiScoreRam
  lda #0                    ; TOTAL_SECS + YRINGS * 5 - 20 is enough
.clearRamLoop
  dey                       ; [4] + 2
  sta RAM_W,Y               ; [0] + 4
  bne .clearRamLoop         ; [6] + 2/3
  rts                       ; TOTAL = 9 * 256 = 2304 (30 SCANLINES)

; -----------------------------------------------------------------------------
; STALL CODE
; -----------------------------------------------------------------------------

DoStall SUBROUTINE
  ; Initialise & Reposition Stall Sprites
  ldx #2
.stallPosLoop
  sta WSYNC                 ; [0]
  ldy #0                    ; [0] + 2
  sty GRP0                  ; [2] + 3
  sty GRP1                  ; [5] + 3
  sty VDELP0                ; [8] + 3
  sty VDELP1                ; [11] + 3
  sty NUSIZ0                ; [14] + 3
  sty NUSIZ1                ; [17] + 3
;  sty COLUPF                ; [20] + 3
;  sty PF0                   ; [23] + 3
;  sty PF1                   ; [26] + 3
;  sty PF2                   ; [29] + 3
  SLEEP 10
  ldy #BLUE_CYAN_NTSC|$4    ; [37] + 2    = CYAN_PAL
  sty COLUP0                ; [39] + 3
  ldy #$0E                  ; [32] + 2    White
  sty COLUP1                ; [34] + 3
  dex
  sta RESP0,X               ; [42] + 4    = 46
  bne .stallPosLoop

  ; Copy Stall Code
  BEGIN_FRAME
  ldx #(EndStall - RAMSPINNER)
.copyStall
  lda $FFA0,X
  sta RAMSPINNER,X
  dex
  bpl .copyStall

  ; Begin Stall
  BEGIN_OVERSCAN
.waitOverscan
  lda INTIM
  bne .waitOverscan
  jmp StartStall

;  echo "----",($FFA0 - *) , "bytes left (BANK6 - HISCORE TABLE)"
  RORG_FREE _RORG + $FA0

; -----------------------------------------------------------------------------

RamSpinner

  ORG   $6FA0
  RORG  RAMSPINNER

  ; Spinner Data
Spinner
;  DC.B %10011111
;  DC.B %00001111
;  DC.B %00000111
;  DC.B %00000111
;  DC.B %00001111
;  DC.B %10011111
;  DC.B %11111001
;  DC.B %11110000
;  DC.B %11100000
;  DC.B %11100000
;  DC.B %11110000
;  DC.B %11111001

;  DC.B %00001111
;  DC.B %00111111
;  DC.B %01111111
;  DC.B %01111111
;  DC.B %11111111
;  DC.B %11111111
;  DC.B %11111111
;  DC.B %11111111
;  DC.B %11111110
;  DC.B %11111110
;  DC.B %11111100
;  DC.B %11110000

  DC.B %10001111
  DC.B %00011110
  DC.B %00111100
  DC.B %01111000
  DC.B %11110001
  DC.B %11100011
  DC.B %11000111
  DC.B %10001111
  DC.B %00011110
  DC.B %00111100
  DC.B %01111000
  DC.B %11110001

;  DC.B %11000111
;  DC.B %10001111
;  DC.B %00011110
;  DC.B %00111100
;  DC.B %01111000
;  DC.B %11110001
;  DC.B %11100011
;  DC.B %11000111
;  DC.B %10001111
;  DC.B %00011110
;  DC.B %00111100
;  DC.B %01111000

  ; Spinner Loop
SpriteLoop
SpriteOffset
  lda Spinner,X
  sta GRP0
  dex
  sta WSYNC
  sta WSYNC
  bpl SpriteLoop

  ; End Of Frame
 IF NTSC_TIM
STALL_VBLANK = 115+EXTRA_LINES-10
 ELSE
STALL_VBLANK = #$7f
 ENDIF
 IF (STALL_VBLANK & 2) = 0
   echo "ERROR: STALL_VBLANK bit 1 must be set!"
   err
 ENDIF
  ldx #STALL_VBLANK                 ; bit 1 must be set!
  stx VBLANK
LastLoop
  dex
  sta WSYNC
  bpl LastLoop
  stx GRP1

  ; Entry Point
StartStall
  ; Do Vertical Sync
  lda #%00001110
SyncLoop
  sta WSYNC
  sta VSYNC
  lsr
  bne SyncLoop

  ; Check End of Stall
 IF MELODY
  bit $1FF4
  bvc FinishStall
 ELSE ;{
  IF (FAKESPIN)
  cpy #256+14-60                    ; Y=14 intially
  beq FinishStall
  nop
  ELSE
  jmp FinishStall
  nop
  nop
  ENDIF
 ENDIF ;}

  ; Calculate Spinner Frame
  dey
  sty REFP0
  tya
  lsr
  lsr
  and #%00000100
  ora #RAMSPINNER
  sta SpriteOffset+1

  ; Start Of Frame
 IF NTSC_TIM
  ldx #126+EXTRA_LINES-10
 ELSE
  ldx #164
 ENDIF
FirstLoop
  dex
  sta WSYNC
  bne FirstLoop
  stx VBLANK

  ; Draw Sprite
  ldx #7
  bne SpriteLoop

  ; Resume
FinishStall
  jmp ($FFFE)
EndStall                  ; Leave Space For Stack!

;  echo "----",($100 - *) , " bytes left (BANK 6 - STALL CODE)"

; -----------------------------------------------------------------------------

  RORG RamSpinner + . - RAMSPINNER; fix for RORG_FREE macro

  .byte " JTZ "

  END_START_BANK
  DC.W    Start, Resume