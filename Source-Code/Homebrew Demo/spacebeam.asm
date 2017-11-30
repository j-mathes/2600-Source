    processor 6502
    include vcs.h
    include macro.h
    include music.h

; Compile switches

NTSC                    = 0
PAL                     = 1
COMPILE_VERSION         = NTSC

; Equates

STRIPE_SIZE              = 6
ALIEN_STRIPES            = 16
LEFTBORDER               = 0
LEFTBORDER               = 0

; Variables

    SEG.U vars
    ORG $80

spritePointer1      ds 2
spritePointer2      ds 2
xPosAlienLeft       ds ALIEN_STRIPES
xPosAlienRight      ds ALIEN_STRIPES
xPosAlienLeftFloat  ds ALIEN_STRIPES
xPosAlienRightFloat ds ALIEN_STRIPES
frameCounter        ds 1
rnd                 ds 1
tempVar1            ds 1
tempVar3            ds 1

    SEG     Bank0
    ORG $F000

;#######################
;# MAIN SCREEN DISPLAY #
;#######################

; Start display kernel
Maindisplay
    LDY #ALIEN_STRIPES-1
    STY tempVar3

AlienStripe
    LDA #$00
    STA WSYNC
    STA VBLANK          ; Stop VBLANK
    STA GRP0
    STA GRP1
    LDY tempVar3
    TYA
    ASL
    ASL
    ASL
    ASL
    ORA #$07
    STA COLUP0
    EOR #$FF
    STA COLUP1

    STA WSYNC                ;
    LDA xPosAlienLeft,Y
    SEC
.waitzone1
    SBC #$0F                 ;
    BCS .waitzone1           ; RESP loop
    EOR #$07                 ;
    ASL                      ;
    ASL                      ;
    ASL                      ;
    ASL                      ;
    STA HMP0
    STA RESP0

    STA WSYNC                ;
    LDA xPosAlienRight,Y
    SEC
.waitzone2
    SBC #$0F                 ;
    BCS .waitzone2           ; RESP loop
    EOR #$07                 ;
    ASL                      ;
    ASL                      ;
    ASL                      ;
    ASL                      ;
    STA HMP1
    STA RESP1

    LDY #STRIPE_SIZE-1
StripeLine2
    STA WSYNC
    STA HMOVE
    LAX (spritePointer2),Y
    LDA (spritePointer1),Y
    STA GRP0
    STX GRP1
    SLEEP 20
    STA HMCLR
    DEY
    BPL StripeLine2
    DEC tempVar3
    BMI DoTorpedoStripe
    JMP AlienStripe

DoTorpedoStripe
    STA WSYNC
    LDA #$00
    STA GRP0
    STA GRP1

    JMP Overscan

;########################
;# CARTRIDGE MAIN ENTRY #
;########################

Start
    CLEAN_START

    SET_POINTER spritePointer1, alien
    SET_POINTER spritePointer2, alien

    LDX #ALIEN_STRIPES-1
Initaliens
    JSR Random
    AND #$7F
    STA xPosAlienLeft,X
    JSR Random
    AND #$7F
    ORA #$80
    STA xPosAlienRight,X
    DEX
    BPL Initaliens

; Main Program Loop

NEWSCREEN
    VERTICAL_SYNC

; Set VBLANK timer
    IF COMPILE_VERSION = PAL
        LDA #73
    ELSE
        LDA #43
    ENDIF
    STA TIM64T

    LDX #ALIEN_STRIPES-1


    LDA frameCounter
    AND #$07
    BNE MoveDone

Movealiens
    INC xPosAlienLeft,X
    DEC xPosAlienRight,X
    LDA xPosAlienLeft,X
    AND #$7F
    STA xPosAlienLeft,X
    LDA xPosAlienRight,X
    AND #$7F
    STA xPosAlienRight,X


    DEX
    BPL Movealiens
MoveDone

VBLANKLOOP
    LDA INTIM
    BNE VBLANKLOOP  ; WAIT FOR VBLANK TIMER
    JMP Maindisplay

Overscan

    LDX #47
Burn
    STA WSYNC
    DEX
    BPL Burn

; Set Overscan timer
    IF COMPILE_VERSION = PAL
        LDA #65
    ELSE
        LDA #36
    ENDIF
    STA TIM64T

; Frame Stuff
    JSR Random
    INC frameCounter

OVERSCANLOOP:
    LDA INTIM
    BNE OVERSCANLOOP    ; WAIT FOR OVERSCAN TIMER
    STA WSYNC       ; FINISH WAITING FOR THE CURRENT LINE

    JMP NEWSCREEN


;-----------------------------------------------------------
;ITERATE A RANDOM VALUE
;-----------------------------------------------------------

Random
    LDA rnd
    BNE .skipInit
    LDA #$FF
.skipInit:
    ASL
    ASL
    ASL
    EOR rnd
    ASL
    ROL rnd
    RTS

alien
    .byte %00101000
    .byte %01111100
    .byte %01101100
    .byte %00101000
    .byte %00111000
    .byte %00010000

    ORG $FFFA
    .WORD Start
    .WORD Start
    .WORD Start