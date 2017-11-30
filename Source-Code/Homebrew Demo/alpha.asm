; Stella Megademo
; This demo contains most demos posted to the Stellalist from the 
; very beginning to March '97 in more or less chronological order.
;
; It compiles on DASM and is tested with Stella & Z26. 
; No tests on the real thing, sorry. 
; (Bug reports are only accepted when they include the fix :-))
;
; Done by Manuel Polik (cybergoth@nexgo.de)
;
; Featured (and not featured :-)) are:
;
; ###################################################################
; Matt by John Matthews
;
; It displays 'Matt' with playfield graphics and has rainbow colors 
; scrolling through it.
; Actually I changed nearly 100% of the code, there's only
; the graphics left. 
; And even these I turned upside down :-)
; ###################################################################
; Robbie by John Matthews
;
; It displays an animated robot sprite
; Again I changed 80% of the original code, I use only one variable
; instead of five. Most important I reduced the sprite data a lot,
; there's no need to have the robot body 4 times in the ROM...
; ###################################################################
; //Test by John Matthews
;
; This didn't make it in the Megademo, because I decided
; to include only the two best demos per coder. 
; ###################################################################
; //Say by Eckhard Stollberg
;
; This didn't make it because it simply was too big.
; ###################################################################
; How To Draw A Playfield by Nick Bensema
; 
; Vertical scrolling playfield demonstration saying 'Hello'.
; Only changed 20%. No need to do a lot, just removed some garbage and
; fixed a little bug :-)
; ###################################################################
; Sucky Zep by Nick Bensema
; 
; Plays some Led Zeppelin notes and does equalizer-ish vertical bars.
; I put it to the end of the Megademo, since it isn't synchronized 
; with the screen and messes a bit with my skip mechanism. 
; I changed less than 10% and didn't bother about providing a proper
; synchronisation to the screen. (Ok, I tried to, but gave up soon :-))
; ###################################################################
; Sprites by Bob Colbert
; 
; Shows 6 copies of player 0 bouncing around the screen.
; I did a lot of optimizing the needed space. The original code was
; very good, though - in fact the most advanced homebrew code I've seen
; so far...
; ###################################################################
; //MultiXX by Bob Colbert
;
; All more advanced versions of 'Sprites' didn't make it in the 
; Megademo. They were getting way to big and its now a halfway finished
; game. Hopefully Bob continues working on it once.
; ###################################################################
; //Etch A Sketch by Bob Colbert
;
; This was done for the supercharger and won't work on a plain 2600,
; so I just said 'no'.
; ###################################################################
; Another Playfield by Chris Cracknell
;
; Draws a Bat to the playfield and let's you move a 'Bira Bira' sprite
; around with the joystick
;
; Uh... Oh... lot's of bugfixing had to be done... feeling dizzy now...
; I hadn't yet the nerve, to give it a 100% fixed single scanline
; kernel, but believe me, it's a _LOT_ better now than the original.
; (I think somewhere in the source Chris said that it was 'Stream Of 
; Consciousness' programming :-))
; I hope this is close now to what Chris originally wanted to do...
; ###################################################################
; Aaaargh by Chris Cracknell
;
; Moves both a friendly & an evil sprite left to right and back
;
; Rewrote it from scratch for space optimizing.
; ###################################################################
; // Clock, Playfield & Colortest by Chris Cracknell
;
; These didn't make it in the Megademo, again because I decided
; to include only the two best demos per coder. 
; His latest work, the virtual pet also looked brilliant, hopefully 
; he continues that some time!
; ###################################################################
; How to Draw a Playfield II by Erik Mooney
;
; Another playfield variant. 
;
; Did the usual space optimizing
; ###################################################################
; //INV & RPG by Erik Mooney
;
; Eriks other stuff didn't make it, since it either was a halfway 
; finished game (INV) or didn't include a source code (RPG)
; hopefully he soon continues working on these very promising projects!
; ###################################################################
; PCMSD by Piero Cavino
;
; Brilliant early Oystron demo. 
; 
; Didn't touch it too much (NOW :-)), just made it share calcpos from 
; Bob Colberts Sprites engine. I haven't had yet the time to see why
; it's a bit buggy now. The original version was totally 
; smooth, so blame me, not Piero.
; ###################################################################
; // X-Mas demo by Piero Cavino
;
; This just didn't made it, 'cause the 2K were used to the max now.
; Just wait, I might do a 4K version, adding another 7 demos some
; time, maybe for next X-Mas :-)
; And again something to finish for Piero: Where's that Jump'n'Run you 
; started?

; Reserved Variables $80+$81 & $82
; (These cannot be used within the demos)
demoVector      = $80   ; vector used to skip to the next demo
switchesRead    = $82   ; stores the value of the switches 

; Variable for Matt demo
topColor        = $83   ; color at top of letters

; Variable for Robbie demo
frameNumber     = $83   ; Number of frames drawn.

; Variable for Nickfield demo
verticalShift   = $83   ; Offset of the playfield scrolling

; Variables for Sprites demo
MAXSPRITE       = $05
hpos            = $83   ; horizontal position of sprites 0 - 5
vpos            = $89   ; vertical position of sprites 0 - 5
vline           = $A0   ; current vertical line being drawn
sprhmot         = $A1   ; vertical motion for sprite 0 - 5
sprvmot         = $A7   ; horizontal motion for sprite 0 - 5
flglst          = $C0   ; 0 - 5
nxtsprt         = $C8   ; 0 - 5
curclr          = $D0   ; current color(?)
p0count         = $D1   ; number of lines left to draw for player 0
sprtptr         = $D2   ; pointer to current sprite
tempVar         = $D3   ; temp variable
tempVar2        = $D4   ; another temp variable
sprtlst         = $D6   ; list of sprites to draw 0 - 5

; Variables for Aaaargh

frameNumber     = $83   ; Number of frames drawn.

; Variables for Another
VERTPOS         = $83   ;This is the vertical position of the sprite
GRP0SIZE        = $85   ;This is how many scan lines the sprite is

; Playfield 2 now don't uses any variable at all :-)

; Variables for PCMSD

NUMGRP    =  11
GRPHEIGHT =  7
XMIN      =  8
XMAX      =  150

GRPCOUNT  =  $83
TEMP      =  GRPCOUNT+1
FC_XPOS   =  TEMP+4
XPOS      =  FC_XPOS+NUMGRP
XMOT      =  XPOS+NUMGRP
GRPY      =  XMOT+NUMGRP
PLYPOS    =  GRPY+1
NXTGRPY   =  PLYPOS+1
PLYMOT    =  NXTGRPY+1
PLXPOS    =  PLYMOT+1
FC_PLXPOS =  PLXPOS+1
PLXMOT    =  FC_PLXPOS+1
COLL      =  PLXMOT+1
NOCC      =  COLL+NUMGRP
FRAMEC    =  NOCC+1
PLGRD     =  FRAMEC+1
PLOFF     =  PLGRD+1

; Variable for Suckyzep demo
zepNote         = $83   ; currently played note

; Code Begin

    processor 6502
    include vcs.h

    ORG     $F000

; This part is the Matt demo
Start               JMP MattReset       ; Reset everything for Matt
MattLoop            JSR VerticalSync    ; Common vertical sync                   
                    JSR VerticalBlank   ; Do-nothing vertical blank
                    JSR MattScreen      ; MattScreen does Overscan
                    BEQ MattLoop        ; Repeat

    ORG     $F010

; This part is the Robbie demo (There's no need to reset anything)
RobbieLoop          JSR VerticalSync    ; Common vertical sync                   
                    JSR VerticalBlank   ; Do-nothing vertical blank
                    JSR RobbieScreen    ; RobbieScreen does Overscan
                    BEQ RobbieLoop      ; Repeat

    ORG     $F020

; This part is the How To Draw A Playfield demo (no reset, too)
NickFieldLoop       JSR VerticalSync    ; Common vertical sync                   
                    JSR VerticalBlank   ; Do-nothing vertical blank
                    JSR NickFieldScreen ; NickFieldScreen does Overscan
                    BEQ NickFieldLoop   ; Repeat

    ORG     $F030

; This part is the Sprites demo
                    JSR SpritesReset
SpritesLoop         JSR VerticalSync    ; Common vertical sync                   
                    JSR SpritesVBlank   ; Sprites vertical blank
                    JSR SpritesScreen   ; SpritesScreen does Overscan
                    JMP SpritesLoop     ; Repeat

    ORG     $F040

; This part is the Aaaargh demo (There's no need to reset anything)
AaaarghLoop         JSR VerticalSync    ; Common vertical sync                   
                    JSR VerticalBlank   ; Aaaargh vertical blank
                    JSR AaaarghScreen   ; AaaarghScreen does Overscan
                    JMP AaaarghLoop     ; Repeat

    ORG     $F050

; This part is the Another demo (reset bit done right here)
                    LDA  #$60           ;
                    STA  VERTPOS        ; Starting vertical position
AnotherLoop         JSR VerticalSync    ; Common vertical sync                   
                    JSR AnotherVBlank   ; Another vertical blank
                    JSR AnotherScreen   ; AnotherScreen does Overscan
                    JMP AnotherLoop     ; Repeat

    ORG     $F060

; This part is the How To Draw A Playfield 2 demo (no reset, too)
ErikFieldLoop       JSR VerticalSync    ; Common vertical sync                   
                    JSR VerticalBlank   ; Do-nothing vertical blank
                    JSR ErikFieldScreen ; ErikFieldScreen does Overscan
                    BEQ ErikFieldLoop   ; Repeat

    ORG     $F070

; This part is the PCMSD demo
                    JSR PCMSDReset      ; PCMSD Rest
PCMSDLoop           JSR VerticalSync    ; Common vertical sync                   
                    JSR PCMSDBlank      ; PCMSD vertical blank
                    JSR PCMSDScreen     ; PCMSDScreen does Overscan
                    BEQ PCMSDLoop       ; Repeat

    ORG     $F080

; This part is the Sucky Zep demo (reset bit done right here)
suckyzep            LDA #$00
                    STA CTRLPF
                    LDA #$0F
                    STA COLUPF
SuckyZepLoop        JSR VerticalSync    ; Common vertical sync                   
                    JSR SuckyZepScreen  ; SuckyZepScreen
                    BEQ SuckyZepLoop    ; Repeat

; This is the one & only vertical sync. Every demo uses it
VerticalSync        LDA #$02            ;
                    STA WSYNC           ; Finish current line
                    STA VSYNC           ; start vertical sync
                    LDA #$03            ;
                    STA TIM64T          ;
                    LDA SWCHB           ; Reset/Select button....
                    CMP switchesRead    ; same as last read?
                    BEQ WaitVSync       ; Y: Continue
                    STA switchesRead    ; N: Store new value
                    LSR                 ; Reset?
                    BCS NoReset         ; N: Continue
                    JMP Start           ; Y: Start over
NoReset             LSR                 ; Select?
                    BCS WaitVSync       ; N: Continue with vertical sync
                    LDA demoVector      ; Skip to next demo
                    ADC #$10            ;
                    STA demoVector      ;
                    LDX #$FF            ; 
                    TXS                 ; Restore Stack     
                    STA VSYNC           ; stop vertical sync
                    JMP (demoVector)    ; Jump to the next demo
WaitVSync           JMP WaitIntimReady  ; Wait until vertical sync finished

; This is the standard do-nothing vertical blank
VerticalBlank       JSR VBlankInit      ;
WaitIntimReady      LDA INTIM           ; Wait until vertical blank finished
                    BNE WaitIntimReady  ;
                    RTS
                    
; This wastes X Lines
Waste               STA WSYNC           ; Waste a line
                    DEX                 ;
                    BNE Waste           ; if X is not zero, do more lines
                    RTS

; This positions a player
PosPlayer1          STA WSYNC
PosPlayer2          DEX                 ; 
                    BNE PosPlayer2      ; kill some time...
                    STA RESP0           ; start player 0 at this point
                    RTS

; This is a usual vertical Blank init

VBlankInit          STA WSYNC           ; Finish current line
                    STA VSYNC           ; Stop vertical sync
                    LDA #$02            ;
                    STA VBLANK          ; Start vertical blank
                    LDA #$2B            ;
                    STA TIM64T          ; Init timer
                    RTS

; This resets the Matt demo
MattReset           SEI                 ; Disable interrupts
                    CLD                 ; Binary mode
                    LDY switchesRead    ;
                    LDX #$00            ; 
                    LDA #$00            ;
Clearloop           STA VSYNC,X         ;
                    TXS                 ; Sets stack to #$FF at end of loop
                    INX                 ;
                    BNE Clearloop       ; zero out the zero page
                    LDA #$F0            ;
                    STA demoVector+1    ; Init the demoVector
                    STY switchesRead    ;
                    JMP MattLoop        ;

; This builds the screen for the Matt demo:
MattScreen          STA WSYNC           ; Finish current line
                    STA VBLANK          ; Stop vertical blank
                    INC topColor        ; Increment to new top color
                    LDA topColor        ; Load it
                    LDX #20             ; 
                    JSR Waste           ; Waste 32 lines
                    LDX #$1F            ; 32 playfield lines
DrawMatt            LDY matttable,X     ; get the current line of playfield
                    STY PF1             ; store it in playfield 1
                    STY PF2             ; store it in playfield 2
                    LDY #$04            ;
Lines               STA COLUPF          ; store in playfield register
                    STA WSYNC           ; Finish current line
                    ADC #$01            ; increase by one
                    DEY                 ;
                    BNE Lines           ;
                    DEX                 ; decrease X by one
                    BPL DrawMatt        ; draw next 4 lines
                    LDX #$3D            ; Waste 32 + 29 lines
                    JMP Waste           ; (Finish Screen / Overscan)

matttable .byte $00   ; ........
          .byte $03   ; ......xx
          .byte $01   ; .......x
          .byte $01   ; .......x
          .byte $01   ; .......x
          .byte $01   ; .......x
          .byte $09   ; ....x..x
          .byte $0F   ; ....xxxx
          .byte $00   ; ........
          .byte $03   ; ......xx
          .byte $01   ; .......x
          .byte $01   ; .......x
          .byte $01   ; .......x
          .byte $01   ; .......x
          .byte $09   ; ....x..x
          .byte $0F   ; ....xxxx
          .byte $00   ; ........
          .byte $0C   ; ....xx..
          .byte $0C   ; ....xx..
          .byte $0C   ; ....xx..
          .byte $0F   ; ....xxxx
          .byte $0C   ; ....xx..
          .byte $07   ; .....xxx
          .byte $03   ; ......xx
          .byte $00   ; ........
          .byte $0C   ; ....xx..
          .byte $0C   ; ....xx..
          .byte $0C   ; ....xx..
          .byte $0D   ; ....xx.x
          .byte $0F   ; ....xxxx
          .byte $0E   ; ....xxx.
          .byte $0C   ; ....xx..

; This builds the screen for the Robbie demo:
RobbieScreen        STA WSYNC           ; Finish current line
                    STA VBLANK          ; Stop vertical blank

                    LDX #$08            ;
                    LDA frameNumber     ; 
                    ROL                 ;
                    BCS DontTurn        ;
                    LDX #$F7            ; This sequence makes robot turn      
DontTurn            STX REFP0           ; every 128 frames

                    LDX #$20            ; Waste 32 Lines
                    JSR Waste           ;

                    LDX #$05            ; 
                    JSR PosPlayer1
                    STA WSYNC           ; Finish current line

                    LDA #$A2            ; 
                    STA COLUP0          ; make robot grey

                    LDX #$08            ; 
Body                LDA robbiedata,X    ; 
                    STA GRP0            ; 
                    STA WSYNC           ; 
                    DEX                 ;
                    BPL Body            ; Draw robot body line by line
                   
                    LDA #$1F            ; 
                    STA COLUP0          ; make chains yellow

                    LDA frameNumber     ; Get current frame number
                    AND #$0C            ; Mask '....xx..' 
                    TAX                 ; We use the Offsets 0, 4, 8, 12
                    LDY #$04            ; They change every fourth frame
Chaines             LDA chaindata,X     ; -> Perfect for smooth animation!
                    STA GRP0            ; store this line of data in player graphic 0 register
                    STA WSYNC           ; done with this line
                    INX                 ; Next line
                    DEY                 ;
                    BNE Chaines         ; Draw Chaines

                    STY GRP0            ; Clear Sprite                                       
                    INC frameNumber     ; One frame done
NextScr             LDX #$AE            ; Waste 174 lines
                    JMP Waste           ; (Finish Screen / Overscan)

robbiedata .byte $18   ; ...xx...
           .byte $99   ; x..xx..x
           .byte $BD   ; x.xxxx.x
           .byte $FF   ; xxxxxxxx
           .byte $7E   ; .xxxxxx.
           .byte $18   ; ...xx...
           .byte $78   ; .xxxx...
           .byte $78   ; .xxxx...
           .byte $38   ; ..xxx...

chaindata  .byte $76   ; .xxx.xx.
           .byte $29   ; ..x.x..x
           .byte $94   ; x..x.x..
           .byte $6E   ; .xx.xxx.

           .byte $3A   ; ..xxx.x.
           .byte $A9   ; x.x.x..x
           .byte $95   ; x..x.x.x
           .byte $5C   ; .x.xxx..

           .byte $5C   ; .x.xxx..
           .byte $A9   ; x.x.x..x
           .byte $95   ; x..x.x.x
           .byte $3A   ; ..xxx.x.

           .byte $6E   ; .xx.xxx.
           .byte $A8   ; x.x.x...
           .byte $15   ; ...x.x.x
           .byte $76   ; .xxx.xx.

; This builds the screen for the Nickfield demo:
NickFieldScreen     STA WSYNC           ; Finish current line
                    STA VBLANK          ; Stop vertical blank

                    LDA #$02            ;
                    STA CTRLPF          ; Display playfield in score mode

                    LDY #191            ;
NickLoop            TYA                 ;
                    SBC verticalShift   ;
                    LSR                 ; Divide by 4
                    LSR                 ;
                    AND #7              ; X values ranging from 0-7
                    TAX                 ;
                    STA WSYNC           ; Finish current line     
                    LDA nicklcolor,X ;
                    STA COLUP0          ; New left color
                    LDA nickpfdata0,X   ;
                    STA PF0             ; 
                    LDA nickpfdata1,X   ;
                    STA PF1             ;
                    LDA nickpfdata2,X   ;
                    STA PF2             ; New playfield data
                    LDA nickrcolor,X;
                    STA COLUP1          ; New right color
                    DEY
                    BNE NickLoop

                    STA WSYNC           ; Finish current line     

                    STY PF0             ;
                    STY PF1             ;
                    STY PF2             ; Clear playfield
                    INC verticalShift   ; 
                    
                    LDX #$1D            ; Waste 29 lines
                    JMP Waste           ; (Overscan)

nickpfdata0 .byte $00   ; ........
            .byte $f0   ; xxxx....
            .byte $00   ; ........
            .byte $A0   ; x.x.....
            .byte $A0   ; x.x.....
            .byte $E0   ; xxx.....
            .byte $A0   ; x.x.....
            .byte $A0   ; x.x.....

nickpfdata1 .byte $00   ; ........
            .byte $FF   ; xxxxxxxx
            .byte $00   ; ........
            .byte $77   ; .xxx.xxx
            .byte $44   ; .x...x..
            .byte $64   ; .xx..x..
            .byte $44   ; .x...x..
            .byte $74   ; .xxx.x..
            
nickpfdata2 .byte $00   ; ........
            .byte $FF   ; xxxxxxxx
            .byte $00   ; ........
            .byte $EE   ; xxx.xxx.
            .byte $A2   ; x.x...x.
            .byte $A2   ; x.x...x.
            .byte $A2   ; x.x...x.
            .byte $E2   ; xxx...x.
            
nicklcolor  .byte $00,$FF,$00,$22,$26,$2A,$2C,$2E
nickrcolor  .byte $00,$1F,$00,$6E,$6C,$6A,$66,$62

; This builds the screen for the Suckyzep demo:
SuckyZepScreen      LDA #$F0            ;
                    STA demoVector      ;
                    LDA #$02            ;
                    STA WSYNC           ; Finish current line
                    STA VSYNC           ; stop vertical sync
                    LDA #127
                    STA T1024T
                    INC zepNote
                    LDA zepNote
                    AND #$0F
                    TAX
                    ROL
                    ROL
                    ROL
                    ROL
                    STA PF2
                    LDA PTCHDATA,X
                    STA AUDF0
                    STA PF0
                    LDA TYPEDATA,X
                    STA AUDC0
                    STA PF1
                    AND #4
                    CLC
                    ADC #4
                    STA AUDV0
WaitUp              LDX INTIM
                    BNE WaitUp
                    SBC #2          
                    STA AUDV0           ; Decrease volume a little bit.
                    LDX #100
                    STX T1024T
                    JMP WaitIntimReady

                    
PTCHDATA dc.b 23,15,15,18,15,27,15,29
         dc.b 23,15,23,29,23,15,23,29
TYPEDATA dc.b 06,06,06,06,06,01,06,01
         dc.b 06,06,06,01,06,06,06,01

; This resets the Sprites demo
SpritesReset        LDA #$01            ;
                    STA CTRLPF          ; set background control register
                    LDA #$43            ;
                    STA COLUPF          ; Make Playfield red

                    LDX #$05            ; 6 sprites to init
SpritesInit         LDA isprvpos,x      ; 
                    STA vpos,x          ; Init vertical position
                    LDA isprhpos,x      ;    
                    STA hpos,x          ; Init horizontal position
                    LDA isprvmot,x      ;
                    STA sprvmot,x       ; Init vertical movement
                    LDA isprhmot,x      ;
                    STA sprhmot,x       ; Init horizontal movement
                    DEX                 ;
                    BPL SpritesInit     ;
                    RTS

; This is the Sprites vertical blank
SpritesVBlank       JSR VBlankInit      ;
                    LDA #$38            ;
                    STA tempVar2        ; Max vertical screen position
                    LDX #$0B            ; 12 Positions to update
MoveXVertical       JSR MoveX           ; 
                    DEX                 ; 
                    CPX #$05            ;
                    BNE MoveXVertical   ; First move 6 times vertical
                    LDA #$9C            ;
                    STA tempVar2        ; Max horizontal screen position
MoveXHorizontal     JSR MoveX           ; 
                    TXA                 ;
                    STA sprtlst,x       ; Reset spritelist for sort
                    DEX                 ; 
                    BPL MoveXHorizontal ; Then move 6 times horizontal
                    STX tempVar2        ; Init TempVar2 with #FF before sort

srtsprt             ldx #MAXSPRITE-1    ;
srtloop             ldy sprtlst,x       ;4
                    lda vpos,y          ;4
                    ldy sprtlst+1,x     ;4
                    cmp vpos,y          ;4
                    bpl noswtch         ;2/3 = 18/19
                    lda sprtlst,x       ;4
                    sty sprtlst,x       ;4
                    sta sprtlst+1,x     ;4
noswtch             dex                 ;2
                    cpx tempVar2        ;
                    bne srtloop         ;2/3 = 37/38
                    inc tempVar2        ;
                    lda tempVar2        ; 
                    cmp #MAXSPRITE-1    ;
                    bne srtsprt         ;2/3 = 42/43
                    JSR pri0            ;
                    JSR res0            ;
                    JSR zrtsprt         ;
                    JMP WaitIntimReady  ; Finish vertical blank

; This builds the screen for the Sprites demo:
SpritesScreen   STA WSYNC           ; Finish current line
                STA VBLANK          ; Stop vertical blank
                ldx     #$0
                stx     sprtptr
                LDX     #$38    ;  number of lines to draw on screen
                stx     vline
                stx     PF1     ;

Loop3           STY     WSYNC   ;   wait for horizontal sync
Loop3a          lda     vline
                sta     PF1     ;   change a background pattern with each line
                ldy     sprtptr
                lda     nxtsprt,y
                bmi     notstart
                tax
                lda     xcolor,x
                sta     curclr
                lda     vline
                cmp     vpos,x
                bne     notstart
                lda     p0count
                bne     notstart2
                sta     WSYNC
                lda     #$8
                sta     p0count
                lda     hpos,x
                jsr     calcpos
                sta     HMP0
                lda     #$0
                sta     GRP0
                iny
                iny
                iny
                sta     WSYNC
resloop0        dey
                bpl     resloop0
                sta     RESP0
                sta     WSYNC
                sta     HMOVE
                dec     vline
                bne     Loop3a

notstart        lda     p0count
notstart2       tay
                beq     nodraw1
                dec     p0count
                lda     curclr
                sta     COLUP0
                lda     shape,y
                tay
nodraw1         sta     WSYNC
                sty     GRP0
                sta     WSYNC
nosync          jsr     drawplr
                BNE     Loop3
                STA PF1 ; Clear playfield for next demo
pagend          RTS     


drawplr lda     p0count
        tay
        beq     nodraw
        LDA     #$0
        sta     tempVar
        dec     p0count
        bne     ndr2
        inc     tempVar

ndr2    lda     shape,y
        tay

nodraw  sta     WSYNC
        sty     GRP0
        dec     vline
        ldx     sprtptr
        lda     tempVar
        beq     nxt
        inx
        cpx     #MAXSPRITE+1
        bne     ndr1
        ldx     #$0

ndr1    lda     nxtsprt,x
        tay
        lda     vline
        cmp     vpos,y
        bne     endraw

nxt     stx     sprtptr
endraw  ldx     sprtptr
        lda     vline
        rts

mvright JSR    calcpos
        STA    HMP0
        lda    #$0
        sta    GRP0
        INY            ;2
        INY            ;2
        INY            ;2
        STA    WSYNC   ;3

resloop     DEY            ;2
            BPL    resloop ;2
            STA    RESP0
            sta    WSYNC
            sta    HMOVE
            RTS            ;6
    
calcpos     TAY
            AND    #$0F    ;2
            STA    tempVar  ;3
            TYA            ;2
            LSR            ;2
            LSR            ;2
            LSR            ;2
            LSR            ;2
            TAY            ;2
            CLC            ;2
            ADC    tempVar  ;3
            CMP    #$0F    ;2
            BCC    nextpos ;2
            SBC    #$0F    ;2
            INY            ;2

nextpos     EOR    #$07    ;2
            ASL            ;2
            ASL            ;2
            ASL            ;2
            ASL            ;2
            RTS            ;6
                                                                                
zrtsprt     ldx     #$0
            ldy     #$0
zrtloop     lda     flglst,x
            and     #$40
            bne     zrt1
            lda     sprtlst,x
            sta     nxtsprt,y
            lda     flglst,x
            ora     #$80
            sta     flglst,x
            iny
zrt1        lda     flglst,x
            and     #$8f
            sta     flglst,x
            inx
            cpx     #MAXSPRITE+1
            bne     zrtloop
            cpy     #MAXSPRITE+1
            beq     zrt2
            lda     #$ff
            sta     nxtsprt,y
zrt2        rts

res0                lda #$0             ;
                    sta tempVar         ; first conflicting sprite
                    sta tempVar2        ; last sprite drawn
                    ldx #MAXSPRITE      ;

res1                lda flglst,x        ; get sprite #
                    cmp #$20            ; check bit 5
                    bne res2            ; if conflict go to res2
                    ldy tempVar2        ;
                    cpy #$1             ;
                    bne res1a           ;
                    TXA                 ;
                    TAY                 ; Copy X to Y
                    JMP res1b           ; To missuse res1a ending

res1a               ldy tempVar         ; was there a conflict before?
                    beq res5            ; nope get otta here
                    ora #$40            ;
                    sta flglst,x        ; set the "don't draw" flag
                    ldy tempVar2        ; we're at the last conflicting sprite
                    bmi res6            ; if a sprite has been chosen, get out
                    ldy tempVar         ; get first sprite w/conflict
res1b               lda flglst,y        ;
                    and #$bf            ; clear the "don't draw" flag
                    sta flglst,y        ;
                    jmp res6            ;

res2                ora #$40            ;
                    sta flglst,x        ; set "don't draw" flag
                    ldy tempVar         ; check to see if first conflict
                    bne res3            ; nope, go to res3
                    stx tempVar         ; yep, save table index in tempVar

res3                and #$80            ; was it drawn?
                    beq res4            ; nope, go to res4
                    lda #$1             ;
                    sta tempVar2        ; found 1 drawn, next non-drawn is o.k.
                    bne res5            ;

res4                lda tempVar2        ; see if drawn sprite found
                    cmp #$1             ; 
                    beq res4a           ; yes
                    bne res5            ;

res4a               lda flglst,x        ; get sprite #
                    and #$bf            ; clear "don't draw" flag
                    sta flglst,x        ;
                    lda #$81            ;
                    sta tempVar2        ;
                    bne res5            ;

res6                lda #$0             ;
                    sta tempVar         ;
                    sta tempVar2        ;

res5                lda flglst,x        ;
                    and #$4f            ; change to 4f
                    sta flglst,x        ;
                    dex                 ;
                    bpl res1            ;
                    rts                 ;
                    
pri0                lda #$38            ;
                    sta tempVar         ;
                    ldx #$0             ;
pri1                lda sprtlst,x       ;   Get first sprite #
                    tay                 ;
                    lda vpos,y          ;   Get sprite y's vpos
                    cmp tempVar         ;   Compare to current line
                    bpl pri2            ;   If there is a conflict go to pri2
                    sbc #$7             ;
                    sta tempVar         ;   Save as next possible vpos
pri5                inx                 ;
                    cpx #MAXSPRITE+1    ;
                    bne pri1            ;
                    rts                 ;

pri2                lda flglst,x        ;   get sprite #
                    ora #$20            ;   Set "conflict" flag
                    sta flglst,x        ;
                    bne pri5            ;

MoveX               LDA hpos,x          ; Load x or y position of sprite
                    CLC                 ;
                    ADC sprhmot,x       ; move it
                    CMP #$8             ; upper/left border reached?
                    BEQ TurnX           ; Y: Turn around
                    CMP tempVar2        ; lower/right border reached?
                    BNE StorePosX       ; N: Store the position
TurnX               LDA #$0             ; 
                    SBC sprhmot,x       ;
                    STA sprhmot,x       ; Swap sign of movement (+-)
                    BNE MoveX           ; Erase Move
StorePosX           STA hpos,x          ;
                    RTS                 ;
                
shape    .byte $00  ;........
         .byte $81  ;x......x
         .byte $42  ;.x....x.
         .byte $24  ;..x..x..
         .byte $18  ;...xx...
         .byte $24  ;..x..x..
         .byte $42  ;.x....x.
         .byte $81  ;x......x
         .byte $00  ;........

isprhpos .byte $30,$40,$22,$28,$12,$50
isprvpos .byte $30,$32,$20,$28,$18,$10
isprhmot .byte $1,$FE,$FF,$2,$FF,$1
isprvmot .byte $ff,$1,$1,$ff,$1,$ff
xcolor   .byte $0e,$73,$16,$33,$22,$12

AaaarghScreen       STA WSYNC           ; Finish current line
                    STA VBLANK          ; Stop vertical blank

                    lda  #$96           ; Set Player color 
                    sta  COLUP0         ;

                    LDA frameNumber     ;
                    LSR
                    LSR
                    LSR
                    LSR
                    TAX
                    ADC #$08
                    AND #$0F
                    TAY
                    LDA AaaarghTab,x
                    TAX
                    LDA AaaarghTab,y
                    PHA
                    JSR PosPlayer1      ;
                    STA WSYNC           ; Set player position
                    ldx #$08            ; 9 Spritelines
                    ldy #$08            ; Offset 9
                    JSR DrawFoePlayer   ; Draw player
                    lda  #$38           ;
                    sta  COLUP0         ; Set foe color
                    PLA
                    TAX
                    JSR PosPlayer1      ;
                    STA WSYNC           ; Set foe position
                    ldx #$08            ; 9 Spritelines
                    ldy #$11            ; Offset 18
                    JSR DrawFoePlayer   ; Draw foe
                    LDX #$C7            ;
                    INC frameNumber     ;
                    JMP Waste           ;

DrawFoePlayer       lda sprt1,y         ;
                    sta GRP0            ;
                    sta WSYNC           ;
                    dey                 ;
                    dex                 ;
                    bpl DrawFoePlayer   ;
                    rts                 ;

AaaarghTab .byte $05,$06,$07,$08,$09,$0A,$0B,$0C,$0C,$0B,$0A,$09,$08,$07,$06,$05

sprt1 .byte $00 ;........
      .byte $66 ;.xx..xx.
      .byte $24 ;..x..x..
      .byte $3C ;..xxxx..
      .byte $18 ;...xx...
      .byte $18 ;...xx...
      .byte $FF ;xxxxxxxx
      .byte $3C ;..xxxx..
      .byte $3C ;..xxxx..

sprt2 .byte $00 ;........
      .byte $AA ;x.x.x.x.
      .byte $AA ;x.x.x.x.
      .byte $FF ;xxxxxxxx
      .byte $FF ;xxxxxxxx
      .byte $BB ;x.xxx.xx
      .byte $99 ;x..xx..x
      .byte $7E ;.xxxxxx.
      .byte $3C ;..xxxx..

; This is the Another vertical blank
AnotherVBlank   JSR VBlankInit;

        LDA  #$4F       ;screen variables should clean this up later...
        STA  COLUPF
        LDA  #$32           ;
        STA  COLUP0         ; Sprite colour
        LDY #$C0
        JMP WaitIntimReady                    

AnotherScreen    STA WSYNC           ; Finish current line
                 STA HMOVE
                 STA WSYNC
                 STA VBLANK          ; Stop vertical blank

load    STA WSYNC
        TYA
        LSR
        LSR
        LSR
        TAX
        LDA  playf0,X
        STA  PF0
        LDA  playf1,X
        STA  PF1
        LDA  playf2,X
        STA  PF2
        DEY
        CPY  VERTPOS
        BNE sprite1
        LDA #$1B
        STA GRP0SIZE
sprite1 LDX GRP0SIZE

        BMI  grfx2      ;See if we're finished drawing the sprite.
        LDA  p0data,x   ;If not then load the sprite data.
        STA  GRP0
        DEC  GRP0SIZE    ;get set up for next sprite line

grfx2   TYA
        BEQ  oscan2     ;or is it time for a new block?
        BNE  load      ;get ready for next scanline

oscan2  JSR  joy        ;overscan. Time to read the joysticks.
        STY  HMP0
        LDX  #$1E
        JMP Waste 

joy     LDY #$00
        LDA  SWCHA      
        ASL
        BCC right
        ASL
        BCC left
        ASL
        BCC down
        ASL
        BCC up
        RTS
    
right   LDY  #$f0       ;set horizontal motion register to one pixel right
        rts

left    LDY  #$10       ;set horizontal motion register to one pixel left
        rts

up      LDA  VERTPOS    ;make sure we haven't gone over the top of the screen
        CMP #$B0
        BEQ NoClimb
        INC  VERTPOS    ;if not then increase the vertical position
NoClimb RTS

down    LDA VERTPOS
        CMP #$20
        BEQ NoSink
        DEC  VERTPOS    ;decrease the vertical position
NoSink  RTS


playf0  .byte $00       ;playfield data... you know. That "BAT"
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $20
        .byte $20
        .byte $70
        .byte $f0
        .byte $f0
        .byte $f0
        .byte $e0
        .byte $e0
        .byte $c0
        .byte $80
        .byte $00
        .byte $00
        .byte $00
playf1  .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $10
        .byte $10
        .byte $11
        .byte $3b
        .byte $7b
        .byte $ff
        .byte $ff
        .byte $ff
        .byte $ff
        .byte $ff
        .byte $ff
        .byte $ff
        .byte $7c
        .byte $30
playf2  .byte $00
        .byte $00
        .byte $80
        .byte $80
        .byte $c0
        .byte $c0
        .byte $c0
        .byte $e2
        .byte $e2
        .byte $f2
        .byte $fa
        .byte $ff
        .byte $ff
        .byte $bf
        .byte $bf
        .byte $7f
        .byte $df
        .byte $cf
        .byte $a7
        .byte $93
        .byte $71
        .byte $38
        .byte $0c
        .byte $04

p0data  .byte $00       ;sprite data. Stored upside down. BIRA BIRA!
        .byte $ff
        .byte $81
        .byte $ff
        .byte $ff
        .byte $ff
        .byte $7e
        .byte $7e
        .byte $7e
        .byte $7e
        .byte $3c
        .byte $ff
        .byte $81
        .byte $ff
        .byte $ff
        .byte $e7
        .byte $66
        .byte $3c
        .byte $3c
        .byte $42
        .byte $7e
        .byte $42
        .byte $ff
        .byte $99
        .byte $66
        .byte $99
        .byte $ff
        .byte $ff

ErikFieldScreen     LDA SWCHA       ;Read joystick 0
                    AND #$F0        ;Only care about top four bits, which is joystick 0
                    CMP #$F0        ;If top four=1111, stick centered, don't change
                    BEQ NoStick
                    LDX #$88        ;otherwise, make the background medium blue
NoStick             STX COLUBK
                    LDA #$55        ;Alternate pixels: 01010101 = $55
                    STA PF0
                    STA PF2         ;Store alternating bit pattern to the playfield registers
                    ASL             ;Because PF1 displays in the opposite bit order from PF0
                    STA PF1         ;and PF2, we need 10101010 instead of 01010101.
                    LDA #1
                    STA CTRLPF      ;Let's reflect the playfield just cause we feel like it =)
                    STA WSYNC       ;End the current scanline - the last line of VBLANK.
                    STA VBLANK      ;End the VBLANK period.  The TIA will display stuff
                    LDY #192        ;We're going to use Y to count scanlines.
ScanLoop            STY COLUPF      ;Keep changing the playfield color every line
                    STA WSYNC       ;Wait for end of scanline
                    DEY
                    BNE ScanLoop    ;Count scanlines.
                    LDX #30         ; Overscan
                    JMP Waste       ;


PCMSDReset:         DEX
                    STX    COLUP0

; Initialize objects positions and motion

       LDX    #NUMGRP-1
INILP:
       TXA
       ASL
       ASL
       ASL
       CLC
       ADC    #10
       STA    XPOS,X
       TXA
       LSR
       CLC
       ADC    #1
       STA    XMOT,X
       DEX
       BPL    INILP

; Player initialization

       LDA    #40
       STA    PLXPOS
       LDA    #1
       STA    PLXMOT
       LDA    #10
       STA    PLYPOS
       LDA    #1
       STA    PLYMOT
       RTS
                                        
PCMSDBlank:         JSR VBlankInit      ;
                    INC    FRAMEC       ; Count frames...

; Move objects horizontally, handle collisions

       LDX    #NUMGRP-1
MOVLP: LDA    XPOS,X
       CLC
       ADC    XMOT,X
       STA    XPOS,X
       CMP    #XMIN
       BCC    SWPX0
       CMP    #XMAX
       BCS    SWAPX
       JMP    OKMV
SWPX0: LDA    #XMIN
       SEC
       SBC    XPOS,X
       CLC
       ADC    #XMIN
       STA    XPOS,X
SWAPX: LDA    XMOT,X
       EOR    #$FF
       CLC
       ADC    #1
       STA    XMOT,X
OKMV:  LDA    XPOS,X
;       CLC
;       ADC #$07
       JSR    CNV
       STA    FC_XPOS,X

       LDA    NOCC
       BNE    NOCL

       LDA    COLL,X
       BPL    NOCL1

       LDA    XMOT,X
       EOR    PLXMOT
       BMI    DOSW
       LDA    XMOT,X
       STA    PLXMOT
       JMP    NOTSW

DOSW:  LDA    PLXMOT
       EOR    #$FF
       CLC
       ADC    #1
       STA    PLXMOT


NOTSW: LDA    #64
       STA    NOCC
NOCL:  DEC    NOCC
NOCL1: LDA    #0
       STA    COLL,X
       DEX
       BPL    MOVLP

; Player0 vertical motion

       LDA    PLYPOS
       CLC
       ADC    PLYMOT
       STA    PLYPOS
       CMP    #6
       BCC    SWAPPLYM
       CMP    #[[1+GRPHEIGHT]*NUMGRP]-12
       BCS    SWAPPLYM
       JMP    OKPLYM
SWAPPLYM:
       LDA    PLYMOT
       EOR    #$FF
       CLC
       ADC    #1
       STA    PLYMOT

; Player0 horizontal motion

OKPLYM:
       LDA    PLXPOS
       CLC
       ADC    PLXMOT
       STA    PLXPOS
       CMP    #25
       BCS    OKX0
       LDA    #25
       STA    PLXPOS
       JMP    SWAPPLXM
OKX0:  CMP    #154
       BCC    OKPLXM
       LDA    #154
       STA    PLXPOS
SWAPPLXM:
       LDA    PLXMOT
       EOR    #$FF
       CLC
       ADC    #1
       STA    PLXMOT
OKPLXM:

       LDA    PLXPOS            ; Convert Player0 X position
;       CLC
;       ADC #$07
       JSR    CNV              ; to FC format.
       STA    FC_PLXPOS
       STA    WSYNC             ; Prepare to position Player0
       STA    HMP0              ; remember, we're still doing Vblank now
       AND    #$0F
       TAY
PLPSL: DEY
       BPL    PLPSL
       STA    RESP0
       STA    WSYNC
       STA    HMOVE
       LDA    #0
       STA    GRPCOUNT          ; Initialize group counter
       STA    GRPY              ; First line of first group
       LDA    #GRPHEIGHT+1
       STA    NXTGRPY           ; First line of next (second) group
       LDA    PLYPOS
       STA    PLGRD
       JMP    WaitIntimReady

PCMSDScreen:    STA    WSYNC
       STA    VBLANK
       STA    HMCLR
; We're going to draw #NUMGRP groups, each made of:
; 2 scanlines for Player1 positioning with Player0, plus
; #GRPHEIGHT*2 scanlines with Player1 and Player0.

KERNEL:
       LDA    PLGRD             ; Distance between Player0<->top of group
       CMP    #GRPHEIGHT+1      ; Is Player0 inside current group?
       BCC    DOPL              ; Yes, we'll draw it...
       LDX    #0                ; No, draw instead a
       BEQ    GOPL              ; blank sprite.
DOPL:  LDA    NXTGRPY           ; We must draw Player0, and we'll start
       SEC                      ; from the (NXTGRPY-PLYPOS)th byte.
       SBC    PLYPOS
       TAX                      ; Put the index to the first byte into X
GOPL:  STX    PLOFF             ; and remember it.

       LDY    GRPCOUNT          ; Store any collision between Player0 and
       LDA    CXPPMM            ; Player1 happened while drawing the
       ORA    COLL,Y            ; last group.
       STA    COLL,Y

       LDA    FC_XPOS,Y         ; Get Player1 position
       LDY    PLPTN,X           ; Get Player0 pattern

       LDX    #0
       STA    WSYNC             ; Start with a new scanline.
       STY    GRP0              ; Set Player0 pattern
       STX    GRP1              ; Blank Player1 pattern to avoid 'bleeding'
       STA    HMP1              ; Prepare Player1 fine motion
       AND    #$0F              ; Prepare Player1 coarse positioning
       TAY
POSLP: DEY                      ; Waste time
       BPL    POSLP
       STA    RESP1             ; Position Player1

       STA    WSYNC             ; Wait for next scanline
       STA    HMOVE             ; Apply fine motion

; Now prepare various things for the next group

       LDA    NXTGRPY           ; Updade this group and next group
       STA    GRPY              ; top line numbers
       CLC
       ADC    #GRPHEIGHT+1
       STA    NXTGRPY

       LDA    PLYPOS            ; Find out which 'slice'
       SEC                      ; of Player0 we'll have to draw.
       SBC    GRPY              ; We need the distance of Player0
       BPL    DPOS              ; from the top of the group.
       EOR    #$FF              ;
       CLC
       ADC    #1                ; A = ABS(PLYPOS-GRPY)
DPOS:  STA    PLGRD             ;

       LDX    PLOFF             ; Pointer to the next byte of Player0
       INX                      ; pattern. Use X while drawing the group

       LDA    #0                ; Clear collisions
       STA    CXCLR

       LDY    #GRPHEIGHT-1      ; Initialize line counter (going backwards)
GRPLP:
       TYA                      ; Find the shade of Player1 color
       ASL                      ; to be used in the next line
       ORA    #$40
       STA    TEMP              ; ...and remember it.

       STA    WSYNC             ; Wait for a new line
       LDA    PLPTN,X
       STA    GRP0              ; Set Player0 shape
       LDA    GRPPTN,Y
       STA    GRP1              ; Set Player1 shape
       LDA    TEMP
       STA    COLUP1            ; Set Player1 color

       STA    WSYNC             ; Wait for a new scanline

       INX                      ; Update the index to next byte of Player0
       DEY                      ; Decrement line counter
       BPL    GRPLP             ; Go on with this group if needed

       INC    GRPCOUNT          ; Increment current group number
       LDA    GRPCOUNT          ;
       CMP    #NUMGRP           ; Is there another group to do?
       BCS    OUTKERNEL         ; No, exit
       JMP    KERNEL            ; Yes, go back. (Using JMP because a branch
                                ; would be out of range).

OUTKERNEL:
       STA    WSYNC             ; Finish current scanline
       LDA    #0                ; Avoid bleeding of Player1
       STA    GRP1
       LDA    #$C0              ; How many scanlines are missing...?
       SEC
       SBC    #[1+GRPHEIGHT]*2*NUMGRP+2  ; It's clear, isn't it?
       TAY
FILLER:
       STA    WSYNC
       DEY
       BNE    FILLER            ; draw them.

       LDA    #$02              ; Overscan
       STA    WSYNC
       LDA    #$1D
       TAX
       JMP Waste       ;

GRPPTN: .byte %00111100         ;  Pattern for Player1
        .byte %01111110
        .byte %11111111
        .byte %11111111
        .byte %11111111
        .byte %01111110
        .byte %00111100

PLPTN:  .BYTE $00               ; Pattern for Player0. Please note
        .BYTE $00               ; the leading and trailing 0's
        .BYTE $00
        .BYTE $00
        .BYTE $00
        .BYTE $00
        .BYTE $00
        .BYTE $00
        .BYTE $00
        .BYTE %01111110
        .BYTE %11111111
        .BYTE %11111111
        .BYTE %11111111
        .BYTE %11111111
        .BYTE %11111111
        .BYTE %01111110
        .BYTE $00
        .BYTE $00
        .BYTE $00
        .BYTE $00
        .BYTE $00
        .BYTE $00
        .BYTE $00

; here's the routine
; to convert from standard X positions to FC positions.
; Could a good man explain me how it works?

CNV:                CLC
                    ADC #$07
                    JSR calcpos
                    STY    TEMP+1
                    ORA    TEMP+1
                    RTS

; Reset Vector
        ORG        $F7FC   
        .byte $00, $F0
        .byte $00, $00