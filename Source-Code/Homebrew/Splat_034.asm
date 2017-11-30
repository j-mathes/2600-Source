; *** S P L A T F O R M   2 6 0 0 ***

; Atari 2600 version of the 2002 Minigames Competition
; 1K winning game by Robin Harbron
; (C)2003 - Thomas Jentzsch

; TODOs:
; + better collision detection
; o improved platform generation (TODO: various platform offsets?)
;   + P0 easy = non-random, hard = random
; x animated Bouncy (no space!)
; o scoring (TODO: more points at higher levels?)
; + sounds
; + variable x-speed
; + lifes
; + lifes display at left
; + wait at start (firebutton)
; + loose life at 0 points
; + high score
; - show version number at start (0 points before start)
; + limit minimum platform density (table?)
; x no flicker at RESET/next level (level generation is a problem)
; ? visual end of level
; + smooth scrolling
; + scroll in new playfield
; + lenghtLst
; o new bouncing physics (TODO: different sounds?)
;   + P1 easy = height (new), hard = const (old)


    processor 6502
    include vcs.h


;===============================================================================
; A S S E M B L E R - S W I T C H E S
;===============================================================================

VERSION         = $0101

BASE_ADR        = $f800

DEBUG           = 0
INVINCIBLE      = 0             ; invincible Bouncy
UNLIMITED       = 0

NTSC            = 1

LARGE_BOUNCY    = 1             ; (+ ?) Bouncy size: 7x12 or 5x8
MULTI_COLOR     = 1             ; (+12) multiple colors for Bouncy
RANDOM          = 1             ; (+13)
RIGHT_SCORE     = 1             ; ( +2)
NEW_BUMP        = 1             ; ( +7)
FLICKER         = 1             ; ( +4) background flicker when losing life


;===============================================================================
; C O N S T A N T S
;===============================================================================

SCW             = 160

DIGIT_HEIGHT    = 9

NUM_ROWS        = 18
ROW_H           = 8
KERNEL_TOP      = 45                            ; = 45
KERNEL_H        = NUM_ROWS * ROW_H + KERNEL_TOP ; = 189

;total: DIGIT_HEIGHT + 2 + KERNEL_H = 200

  IF LARGE_BOUNCY
BOUNCY_H        = 12
BOUNCY_W        = 7
  ELSE
BOUNCY_H        = 8
BOUNCY_W        = 5
  ENDIF
BOUNCY_Y        = KERNEL_H-BOUNCY_H

  IF NTSC
BOUNCY_COL      = $1c                   ; yellow
BOUNCY_COL_STOP = $3a                   ; orange
BOUNCY_COL_BACK = $46                   ; red

SCORE_COLOR     = $0a                   ; white
HISCORE_COLOR   = $46                   ; red
  ELSE
BOUNCY_COL      = $2e                   ; yellow
BOUNCY_COL_STOP = $4a                   ; orange
BOUNCY_COL_BACK = $66                   ; red

SCORE_COLOR     = $0a                   ; white
HISCORE_COLOR   = $66                   ; red
  ENDIF
RAND_EOR_8      = $b4                   ;$b2; $e7; $c3
RAND_SEED       = $-1                   ; (unused?)


; difficulty speed parameters:
GRAVITY         = 55
BUMP            = $550
;GRAVITY         = 50
;BUMP            = $510
;GRAVITY         = 45
;BUMP            = $4d0

SPEED_X         = $18
SPEED_MAX_X     = 2
BOUNCY_MIN_X    = 8
BOUNCY_MAX_X    = SCW*3/8-BOUNCY_W/2

; platform generation parameters:
MAX_PLATFORM    = 8-1                               ; maximum platform length
FACTOR          = (255+NUM_ROWS)/(NUM_ROWS*2)       ; 7.58 = 7 (~1/18/2)
INIT_SPEED      = 2                                 ; initial scrolling speed
;DENSITY         = $2c0                              ; initial plattfrom density ($2d0)
DENSITY         = ($3c)*(FACTOR+(MAX_PLATFORM+1)/2)   ; initial plattfrom density
DENSITY_MASK    = >DENSITY|>DENSITY/2
ADVANCE         = 16                                ; advance of difficulty (1/ADVANCE)
NUM_LEVEL       = 10


;===============================================================================
; Z P - V A R I A B L E S
;===============================================================================

    SEG.U   variables
    ORG     $80

tmpVars     ds 9
tmpVar      = tmpVars
tmpVar2     = tmpVars+1
tmpVar3     = tmpVars+2

frameCnt    .byte
random      .byte

xPosLst     ds NUM_ROWS
hmPosLst    ds NUM_ROWS
pfLst       ds NUM_ROWS
lenghtLst   ds NUM_ROWS         ; saves *1* byte

ySpeed      ds 2
ySpeedHi    = ySpeed
ySpeedLo    = ySpeed+1

xSpeed      ds 2
xSpeedHi    = xSpeed
xSpeedLo    = xSpeed+1

;cxRowY      .byte               ; 0..NUM_ROWS-1
sound       .byte
levelCnt    .byte

yBouncy     ds 2
yBouncyHi   = yBouncy
yBouncyLo   = yBouncy+1

xBouncy     ds 2
xBouncyHi   = xBouncy
xBouncyLo   = xBouncy+1

scrollIn    .byte
scrollSum   .byte

pfSum       ds 2
pfSumHi     = pfSum
pfSumLo     = pfSum+1

end_of_next  = .

; variables not resetted for next level:
level       .byte

score       ds 2
scoreHi     = score
scoreLo     = score+1

end_of_reset = .

compMode    .byte               ; random mode?

; variables initialized at start of game:
initVars    = .

saveRandom  .byte
colorP1     .byte               ; cccc111. bits
lifes       .byte
cxRowY      .byte               ; 0..NUM_ROWS-1
scoreMax     ds 2
scoreMaxHi  = scoreMax
scoreMaxLo  = scoreMax+1

NUM_INIT    = . - initVars

  ECHO "*** RAM: ", ., " ***"


;===============================================================================
; M A C R O S
;===============================================================================

  MAC DEBUG_BRK
    IF DEBUG
      brk                         ;
    ENDIF
  ENDM

  MAC BIT_B
    .byte   $24
  ENDM

  MAC BIT_W
    .byte   $2c     ; 4 cylces
  ENDM

  MAC SLEEP
    IF {1} = 1
      ECHO "ERROR: SLEEP 1 not allowed !"
      END
    ENDIF
    IF {1} & 1
      nop $00
      REPEAT ({1}-3)/2
        nop
      REPEND
    ELSE
      REPEAT ({1})/2
        nop
      REPEND
    ENDIF
  ENDM

  MAC CHECKPAGE
    IF >. != >{1}
      ECHO ""
      ECHO "ERROR: different pages! (", {1}, ",", ., ")"
      ECHO ""
      ERR
    ENDIF
  ENDM

  MAC DEC2BCD
    IF {1} > 99
      ECHO "ERROR: Value too large for BCD! (", {1}, ")"
      ERR
    ENDIF
    .byte ({1}) / 10 << 4 | ({1}) % 10
  ENDM


;===============================================================================
; R O M - C O D E
;===============================================================================
    SEG     Bank0

    ORG     BASE_ADR

;---------------------------------------------------------------
Start SUBROUTINE
;---------------------------------------------------------------
; cart inserted

    cld
    ldx     #NUM_INIT-1

;---------------------------------------------------------------
Reset:
;---------------------------------------------------------------
; RESET pressed

.loopInit:
    lda     InitTbl,x
    sta     initVars,x
    dex
    bpl     .loopInit

  IF RANDOM
    lda     SWCHB
    sta     compMode
  ENDIF

    ldx     #end_of_reset

;---------------------------------------------------------------
StartLevel:
;---------------------------------------------------------------
; (re)start level
; x contains number of resetted variables

    lda     #0
.clearLoop:
    dex
    txs
    pha
    bne     .clearLoop

  IF DEBUG
    lda     #$80
    sta     COLUBK
    lda     #$04
    sta     COLUPF
  ENDIF

;---------------------------------------------------------------
GameInit SUBROUTINE
;---------------------------------------------------------------
;    lda     #BOUNCY_Y
;    sta     yBouncy
;    dec     yBouncy

    lda     saveRandom
    sta     random

    lda     #(SCW-8)/INIT_SPEED
    sta     scrollIn

;    lda     #$10
;    sta     scrollSum

    .byte   $a9
    DEC2BCD 100-(SCW-8)/4       ; add missing ~60 points (total: 100 points)
    jsr     Add16_ScorePos

;    lda     #$01
;    sta     scoreHi
;    lsr
;    sta     scoreLo
;GameInit

;;    lda     #%100000
;;    sta     CTRLPF
;    lda     #$30
;    sta     HMBL
;    sta     WSYNC
;    sta     HMOVE
;;    lda     #157+3
;;    ldx     #4
;;    jsr     XPosObject
;    sta     WSYNC
;    sta     HMCLR

;---------------------------------------------------------------
OverScan SUBROUTINE
;---------------------------------------------------------------
    lda     #36-6               ; 2
    sta     TIM64T              ; 4

    stx     GRP0                ; 3         @02
    stx     VDELP1              ; 3

; *** handle collisions: ***
;    lda     #0
;    sta     COLUBK

; calculate old row:
;    sec                         ;       almost doesn't matter
    lda     yBouncyLo           ;       C=1!
    sbc     ySpeedLo
    lda     yBouncyHi
    sbc     ySpeedHi
    sbc     #ROW_H*2            ;       C=0!
    bcc     .skipCollision      ;        no, skip
    sbc     cxRowY              ;       was previous row above?
    bcc     .skipCollision      ;        no, skip

; *** bump ***
    lda     #<BUMP
    ldx     #>BUMP
    bit     compMode            ;       constant bump mode?
    bmi     .contBump           ;        yes
    sbc     ySpeedLo            ;        no, 50% additional bump for previous height
    tay
    txa
    sbc     ySpeedHi
    lsr
    tax
    tya
    ror
.contBump:
    sta     ySpeedLo
    stx     ySpeedHi

; start bouncing sound:
;    clc
;    adc     #5
;    sta     sound
    lda     #$0c
    sta     AUDC0
    sta     sound

    lda     #$95                ;       -5 points
    ldy     #$99
    jsr     Add16_Score

    bcc     .resetScore         ;       score below zero, loose life!

.skipCollision:
    ldy     #-1                 ;       reinitialize collision variable
    sty     cxRowY

; *** play sounds: ***
    lax     sound
    beq     .skipSound
    bpl     .bounce
    dex
    asl
    bpl     .falling
    asl                         ;       falling sound over?
    beq     .nextLevel
    stx     AUDV0
    lda     #$04
    sta     AUDC0
    txa
    bne     .setAudF0

; goto next level
.nextLevel:
    inc     level               ;        yes, increase level,...

    lda     colorP1             ;        ...calculate new level color,...
    adc     #$2f                ;       C=1! (color repeats after 16 levels)
    sta     colorP1

    lda     random              ;        ...save new initial random value,...
    sta     saveRandom
.startLevel:
    ldx     #end_of_next        ;        ...and start new level
    bne     StartLevel          ; 3

; make falling sound:
.falling:
    bne     .contFalling
; loose one life:
  IF UNLIMITED = 0
    lsr     lifes
    lsr     lifes               ;       any more lifes?
    bne     .startLevel         ;        yes, restart current level
                                ;        no, game over!!!
  ELSE
    beq     .startLevel
  ENDIF
    jsr     CheckHigh           ;       new high score?
    bcc     .skipHigh
    stx     scoreMaxLo
    sty     scoreMaxHi
.skipHigh:
    ldx     #0
    stx     scrollIn

.contFalling:
    txa
  IF FLICKER
    sta     COLUBK
  ENDIF
    lsr
    lsr
    sta     AUDV0
    lda     #$03
    sta     AUDC0
    lda     #$0c
    bne     .setAudF0

;---------------------------------------
.resetScore:                    ;       set score to zero
    lda     #0
    sta     scoreLo
    sta     scoreHi
.looseLife:
    lda     #$b8                ;       start dying sound ($0b..$00)
    sta     sound
.endMoveJmp:
    jmp     .endMove
;---------------------------------------

; make bouncing sound:
.bounce:
    dex
    txa
    sta     AUDV0
    adc     #$13                ;       C=1!
.setAudF0:
    sta     AUDF0
    stx     sound
.skipSound:

; *** check RESET switch: ***
    ldx     #NUM_INIT-3         ;       number of initialized variables
    lsr     SWCHB
    bcc     .doReset            ;       brk!

; *** wait at start of level: ***
    lda     scrollIn
    bmi     .skipWait
    bne     .endMoveJmp
    bit     INPT4
    bmi     .endMoveJmp
    lda     lifes
    beq     .doReset            ;       brk!
    dec     scrollIn            ;
.skipWait:

    bit     sound
    bmi     .endMoveJmp

; *** move Bouncy vertically: ***
;    ldy     #-1
    lda     #-GRAVITY           ;       y = -1!
    ldx     #ySpeed
    jsr     Add16

    tay
    lda     ySpeedLo
    ldx     #yBouncy
    jsr     Add16

; check for falling down:
  IF INVINCIBLE = 0
    cmp     #-18
    bcs     .looseLife
  ELSE
    clc
  ENDIF

;    lda     #BOUNCY_H+ROW_H-3-1      ; -> just above bottom row
;    lda     #KERNEL_H-1              ; -> directly at top
;    lda     #-1
;    sta     yBouncyHi

; *** horizontal movement: ***

; *** move Bouncy horizontally: ***
.doReset = . + 1
; check joystick:
    ldy     #0                  ;       brk!
    lda     #SPEED_X
    bit     SWCHA
    bpl     .addSpeedX
    tya
    bvs     .addSpeedX
    dey
    lda     #-SPEED_X           ;       brakes faster than accelerating
.addSpeedX:
    ldx     #xSpeed
    jsr     Add16

; friction:
    asl                         ;       positive or negative speed?
    ldy     #0
    lda     #SPEED_X/3
    bcs     .subSpeedX
    dey
    lda     #-SPEED_X/3
.subSpeedX:
    jsr     Add16               ;       x = <xSpeed!

; check for direction switch due to friction
    bcc     .checkNeg
    dey
.checkNeg:
    iny
    beq     .stopX              ;       friction changed direction, set x-speed to 0

; limit positive horizontal speed:
    tay                         ;       a = xSpeedHi!
    eor     #SPEED_MAX_X
    bne     .skipLimit
    sta     xSpeedLo            ;       a = 0!
.skipLimit:

; move:
    lda     xSpeedLo
    ldx     #xBouncy
    jsr     Add16               ;       y = xSpeedHi

; limit xBouncy to the left:
    cmp     #BOUNCY_MIN_X       ;       a = xBouncyHi
    bcs     .xBouncyOk
    lda     #BOUNCY_MIN_X
    sta     xBouncyHi
    ldy     #0
.stopX
    sty     xSpeedHi
    sty     xSpeedLo
.xBouncyOk:

;-------------------------------------------------

;    lda     #BOUNCY_H-2
;    sta     yBouncy
.endMove:

; *** position score sprites and blanking ball: ***
  IF RIGHT_SCORE
    lda     #38-16+3*6-2        ;               -2: dirty tweak to avoid additional HMCLR
  ELSE
    lda     #38-16
  ENDIF
    jsr     XPosObject0
    sta     WSYNC
    sta     RESBL
;    sta     HMCLR
    lda     #$20|%011
    sta     HMBL
    sta     NUSIZ0              ;       %011
    inx
    stx     NUSIZ1              ;       %001
  IF RIGHT_SCORE
    lda     #38+8+3*6
  ELSE
    lda     #38+8
  ENDIF
    jsr     XPosObject

.waitTim:
    ldx     INTIM
    bne     .waitTim
    sta     HMCLR               ;               stop ball
; OverScan


;---------------------------------------------------------------
VerticalBlank SUBROUTINE
;---------------------------------------------------------------
    lda     #%01101011              ;           bit 0 sets carry!
    sta     WSYNC
    sta     VSYNC
    sta     WSYNC

  IF DEBUG = 0
    sta     ENABL
  ENDIF
    inc     frameCnt

    sta     WSYNC
    lsr
    sta     CTRLPF                  ;           8 pixel ball
    ldy     #44-5
    sta     WSYNC
    sta     VSYNC
    sty     TIM64T
; VerticalBlank

;---------------------------------------------------------------
GameCalc SUBROUTINE
;---------------------------------------------------------------

; check, if current level is over:
    lda     xBouncy
    bit     sound
    bmi     .skipXScroll
    bit     levelCnt                ;           128 platforms?
    bpl     .contLevel              ;            no, continue with current level
    cmp     #SCW                    ; 2          yes, Bouncy at the very right? (160)
    bcc     .skipXScroll            ;             no, continue, but stop scrolling
    ldx     #$d0                    ;             yes, start sound for finishing the level
    stx     sound                   ;
    bcs     .skipXScroll            ; 3

.contLevel:
    ldy     scrollIn                ;           used in ScrollRight!
    lda     #BOUNCY_MAX_X
;    sec
    sbc     xBouncy                 ;           C = 1!
    bcc     .doScroll

; *** scroll in new platforms: ***
    dey
    bmi     .skipXScroll

    lda     #-INIT_SPEED
    dec     scrollIn
    bne     .doScroll2

; initial platform scrolling finished, now show Bouncy:
;    ldx     #124
;    stx     levelCnt
    ldx     #BOUNCY_Y
    stx     yBouncy
.doScroll:
    ldx     #BOUNCY_MAX_X
    stx     xBouncy
.doScroll2:
    jsr     ScrollRight
.skipXScroll:

; *** setup score colors: ***
    jsr     CheckHigh
    ldy     #1                  ;
    ldx     #HISCORE_COLOR
    lda     lifes
    bne     .currentScore       ;           running
    lda     frameCnt            ;           stopped, score switches...
    bpl     .hiScore            ;           ...between current and high score (c=0!)
    clc
.currentScore:
    bcs     .currentScoreHi
    ldx     #SCORE_COLOR
    BIT_W
.hiScore:
    ldy     #(scoreMax-score)+1
.currentScoreHi:
    stx     COLUP0
    stx     COLUP1
; GameCalc


;---------------------------------------------------------------
Kernel SUBROUTINE
;---------------------------------------------------------------
.ptrScore   = tmpVars       ;..+7
.tmpY       = tmpVars+8
;---------------------------------------
.ptrBouncy  = tmpVars       ;..+1
.yBouncy    = tmpVars+7
.rows       = tmpVars+8     ; == .tmpY !

DrawScreen:
; setup score pointers:
;    ldy     #1
    ldx     #4-1                ; 2
.loopScore:
    lda     #>Zero              ; 2
    sta     .ptrScore,x         ; 4
    sta     .ptrScore+4,x       ; 4
    dex                         ; 2
    sty     .tmpY               ; 3
    lda     score,y             ; 4
    pha                         ; 3
    lsr                         ; 2
    lsr                         ; 2
    lsr                         ; 2
    lsr                         ; 2
    tay                         ; 2
    lda     DigitTbl,y          ; 4
    sta     .ptrScore,x         ; 4
    pla                         ; 4
    and     #$0f                ; 2
    tay                         ; 2
    lda     DigitTbl,y          ; 4
    sta     .ptrScore+4,x       ; 4
    ldy     .tmpY               ; 3
    dey                         ; 2
    dex                         ; 2
    bpl     .loopScore          ; 2³
;total: 133

.waitTim:
    lda     INTIM
    bne     .waitTim
;    sta     VBLANK

;===============================================
    ldy     #DIGIT_HEIGHT
.loopDigits:
    sta     WSYNC
;---------------------------------------
    ldx     #NUM_ROWS           ; 2
    stx     .rows               ; 3
    lda     lifes               ; 3
    sta     GRP0                ; 3         @11
    lda     (.ptrScore+4),y     ; 5
    sta     GRP1                ; 3         @19
  IF RIGHT_SCORE
    lda     (.ptrScore,x)       ; 6             = SLEEP 6
  ENDIF
    lax     (.ptrScore+6),y     ; 5
    lda     (.ptrScore),y       ; 5
    sta     GRP0                ; 3         @38
    lda     (.ptrScore+2),y     ; 5
    sta     GRP0                ; 3         @46
    stx     GRP1                ; 3         @49
    dey                         ; 2
    bne     .loopDigits         ; 2³        @53³

    sty     GRP1                ; 3
    sty     GRP0                ; 3 =  6

    lda     xBouncy             ; 3
    jsr     XPosObject0         ; 6 =  9    @68/@09

    lda     #<Bouncy+BOUNCY_H-2 ; 2
    sbc     yBouncyHi           ; 3             C=1!
    sta     .ptrBouncy          ; 3
    sec                         ; 2
    sbc     #<Bouncy-KERNEL_H-1-1;2          
    sta     .yBouncy            ; 3 = 15

    sty     NUSIZ0              ; 3
    dey                         ; 2
    sty     NUSIZ1              ; 3             quad width players
    sty     VDELP1              ; 3             enable vertical delay
    sta     HMCLR               ; 3 = 14

  IF MULTI_COLOR
    ldy     #BOUNCY_COL_BACK    ; 2             TODO?: use for NUSIZ1
    lda     xSpeed              ; 3
    bmi     .setColor           ; 2³
    ldy     #BOUNCY_COL_STOP    ; 2
    ora     xSpeedLo            ; 3
    beq     .setColor           ; 2³
  ENDIF
    ldy     #BOUNCY_COL         ; 2
.setColor:
    sty     COLUP0              ; 3 = 10-19

;=====================================================
; right 8 pixels are blanked by black ball!
    ldy     #KERNEL_H-1+2
.loopKernel:                    ;           @30
    ldx     #ROW_H-2            ; 2
.loopY:                         ;
    lda     #BOUNCY_H-1         ; 2
    dcp     .yBouncy            ; 5 =  7
    sta     WSYNC               ; 3
;---------------------------------------
    bcs     .doDraw             ; 2³
    lda     #0                  ; 2
    BIT_W                       ;-1
.doDraw:
    lda     (.ptrBouncy),y      ; 5
    sta     GRP0                ; 3 = 11    @11
    lda     ColTbl-1,x          ; 4
    and     colorP1             ; 3
    sta     COLUP1              ; 3         @21
    dey                         ; 2

; check for special loop at top of kernel:
    cpy     #(KERNEL_H-KERNEL_TOP)-1+(ROW_H-1); 2
    bcs     .loopY              ; 2

    dex                         ; 2
    bne     .loopY              ; 2³= 20³   @31

; bottom platform row:
    lda     #BOUNCY_H-1         ; 2
    dcp     .yBouncy            ; 5
    bcs     .doDraw0            ; 2³
    txa                         ; 2             x=0
    BIT_W                       ;-1
.doDraw0:
    lda     (.ptrBouncy),y      ; 5
    stx     GRP1                ; 3 = 18    @49 x=0 (delayed!)

; check collisions:
    bit     CXPPMM              ; 3         @52
    bmi     .setcxRowY          ; 2³            save *last* row *with* collision
    BIT_W                       ; 1
.setcxRowY:

    sty     cxRowY              ; 3
    dey                         ; 2
    sta     CXCLR               ; 3 = 14    @63

; update row counter:
    ldx     .rows               ; 3
    beq     .exitKernel         ; 2³
    dex                         ; 2
    stx     .rows               ; 3 = 10

    sta     GRP0                ; 3 =  3    @76
;---------------------------------------
; empty platform row, reposition next platform:
    lda     pfLst,x             ; 4
    sta     GRP1                ; 3
    lda     hmPosLst,x          ; 4
    sta     HMP1                ; 3
    and     #$0f                ; 2
    beq     .veryLeft           ; 2³
    sec                         ; 2
WaitObject1:
    sbc     #1                  ; 2
    bne     WaitObject1         ; 2³
.veryLeft:
    sta.w   RESP1               ; 4         @23..73!
    sta     WSYNC               ; 3
;---------------------------------------
; top platform row (black)
    sta     HMOVE               ; 3
    sta     COLUP1              ; 3 =  6

    tax                         ; 2         a = 0!
    lda     #BOUNCY_H-1         ; 2
    dcp     .yBouncy            ; 5
    bcc     .skipDraw1          ; 2³
    lax     (.ptrBouncy),y      ; 5
.skipDraw1:
    stx     GRP0                ; 3 = 19    @25 (@25, besser 24!)

    dey                         ; 2
    bne     .loopKernel         ; 3 =  5

;=====================================================
.exitKernel:                    ;           @69
    jmp     OverScan


;***************************************************************
ScrollRight SUBROUTINE
;***************************************************************
; a = .dPixel (negative!)
; y = scrollIn

.dPixel     = tmpVar
.dPixel16   = tmpVar+1
.newPixel   = tmpVar+2
  IF RANDOM
.random     = tmpVar+3
  ENDIF

    sta     .dPixel
    asl
    asl
    asl
    asl
    sta     .dPixel16

    lda     scrollSum
    clc
    adc     .dPixel
    and     #$03
    sta     scrollSum
    ror     .newPixel           ;       N = smooth scroll only

    bmi     .skipNew            ;           
  IF (NUM_ROWS & 1) = 0
    jsr     NextRandom
.skipRandom:
  ENDIF

; *** update platform counter: ***
; limit level number:
    ldx     level
;    ldx     #9
    cpx     #NUM_LEVEL-1
    bcc     .levelOk
    ldx     #NUM_LEVEL-1
.levelOk:
; get platform denisty of current level:
    lda     DensityTbl,x
    tax
    and     #DENSITY_MASK
; create safety platform at start of level: 
    cpy     #51                   ;       y = scrollIn          
    bne     .skipSafety
    adc     #FACTOR/2-1         ;       increase new platform probability
.skipSafety:
; increase platform possibility:
    tay
    txa
    ldx     #pfSum
    jsr     Add16
.skipNew:

; *** main scrolling loop: ***
    ldx     #NUM_ROWS-1
.loopScroll:
; *** smooth scrolling: ***
    ldy     pfLst,x
    beq     .skipSmooth

.smoothScroll:
    lda     xPosLst,x
    clc
    adc     .dPixel
    bcs     .xPosOk

; remove left platform piece:
    adc     #4
    dec     lenghtLst,x
    asl     pfLst,x             ;       remove platform piece
    clc
.xPosOk:
    sta     xPosLst,x

    lda     hmPosLst,x
    bcs     .xPosOk2
    sbc     #$40-1              ;       move 4 pixel right, C=0!
    bvc     .hmOk
    adc     #$f1-1              ;       C=1!
.hmOk:
    sec
.xPosOk2:
    sbc     .dPixel16
    bvc     .hmOk2
    adc     #$10-1              ;       C=0!
.hmOk2:
    sta     hmPosLst,x
.skipSmooth:

; *** create new platform pieces ***
    bit     .newPixel
    bmi     .nextLoop

    jsr     NextRandom

    ldy     lenghtLst,x
    beq     .emptyRow

; check for enlarging existing platform:
  IF RANDOM
    sta     .random
  ENDIF
    tya
    asl
    asl
    adc     xPosLst,x
    sbc     scrollSum           ;       C = 0!
    cmp     #(SCW-8)-1-1
    bne     .nextLoop
  IF RANDOM
    lda     .random
  ELSE
    lda     random
  ENDIF
    cmp     RandomTbl-1,y
    bcs     .nextLoop
; enlarge existing platform:
    lda     #-1
    bcc     .setBit

; check for new platform:
.emptyRow:
    bit     pfSum
    bmi     .nextLoop
    and     #$7f                ;       a = random number!
    cmp     pfSum
    bcs     .nextLoop

; create new platform:
    inc     levelCnt            ;       increase level length counter
    ldy     scrollSum
    lda     HmStartTbl,y
    sta     hmPosLst,x
    tya
    adc     #(SCW-8)-1          ;       C = 0!
    sta     xPosLst,x
    lda     #-FACTOR
.setBit:
    adc     pfSum               ;       C = 0!
    sta     pfSum
    sec
    ror     pfLst,x
    inc     lenghtLst,x

.nextLoop:
    dex
    bpl     .loopScroll

; *** add points: ***
    bit     .newPixel
    bmi     Exit

    lda     #$01                ;       add 1 point
;    lda     level
;    lsr
;    adc     #1

; ScrollRight

;***************************************************************
Add16_ScorePos SUBROUTINE
;***************************************************************
    ldy     #$00
Add16_Score:
    ldx     #score
    sed
Add16:
    clc
    adc     $01,x
    sta     $01,x
    tya
    adc     $00,x
    sta     $00,x
    cld
Exit:
    rts
; Add16_ScorePos


;***************************************************************
NextRandom:
;***************************************************************
    lda     random              ; 3
    lsr                         ; 2
    bcc     .skipEor            ; 2³
    eor     #RAND_EOR_8         ; 2
.skipEor:                       ;
    sta     random              ; 3
  IF RANDOM
    bit     compMode            ; 3
    bvc     .skipRandom         ; 2³
;    eor     yBouncyLo           ; 3
    eor     frameCnt            ; 3
.skipRandom:
  ENDIF
; NextRandom
    rts


;***************************************************************
XPosObject0 SUBROUTINE
;***************************************************************
    ldx     #0              ; 2
XPosObject:
    sec                     ; 2
    sta     WSYNC           ; 3
;---------------------------------------
WaitObject:
    sbc     #$0f            ; 2
    bcs     WaitObject      ; 2³

  CHECKPAGE WaitObject

    eor     #$07            ; 2
    asl                     ; 2
    asl                     ; 2
    asl                     ; 2
    asl                     ; 2
    sta     HMP0,x          ; 4
    sta.wx  RESP0,x         ; 5     @23!
    sta     WSYNC
;---------------------------------------
    sta     HMOVE
    rts
; XPosObject0


;***************************************************************
CheckHigh SUBROUTINE
;***************************************************************
; carry doesn't matter!
    lax     scoreLo
    sbc     scoreMaxLo
    lda     scoreHi
    tay
    sbc     scoreMaxHi
    rts
; CheckHigh

CodeEnd:


;===============================================================================
; R O M - T A B L E S (Bank 0)
;===============================================================================

FREE SET 0

HmStartTbl:
    .byte   $1a, $0a, $fa, $ea  ;       -4, -3, -2, -1

DensityTbl:
Y2 SET DENSITY*1024
  REPEAT NUM_LEVEL
Y SET (Y2+1024/2)/1024
    .byte (<Y & ~DENSITY_MASK) | (>Y & DENSITY_MASK)
Y2 SET (Y2 * (ADVANCE-1) + ADVANCE/2)/ADVANCE
  REPEND

InitTbl:
    .byte   RAND_SEED   ; saveRandom
    .byte   $2e         ; colorP1
    .byte   %01010101   ; lifes (4 lifes, only three are shown!)
    .byte   -1          ; cxRowY
    .byte   >VERSION    ; scoreMaxHi
    .byte   <VERSION    ; scoreMaxLo

RandomTbl:
Y SET MAX_PLATFORM
  REPEAT MAX_PLATFORM
Y SET Y - 1
    .byte (256*Y+(Y+1)/2)/(Y+1)
  REPEND
;    .byte   256/8*7, 256/7*6, 256/6*5, 256/5*4,.byte   256/4*3, 256/3*2, 256/2*1, 256/1*0
;    .byte   256/15*14, 256/14*12, 256/12*10, 256/10*8, 256/8*6, 256/6*4, 256/4*2, 256/2*0
;    .byte   $0

DigitTbl:
    .byte   #<Zero-1,  #<One-1,   #<Two-1,   #<Three-1, #<Four-1
    .byte   #<Five-1,  #<Six-1,   #<Seven-1, #<Eight-1, #<Nine-1

ColTbl:
    .byte   $f0, $f4, $f6, $f8, $fa, $0e;
;    .byte   $00                             ; overlapping!!!

One:
    .byte   %00000000
    .byte   %00000010
    .byte   %00000010
    .byte   %00000010
Seven:
    .byte   %00000000
    .byte   %00000010
    .byte   %00000010
    .byte   %00000010
Four:
    .byte   %00000000
    .byte   %00000010
    .byte   %00000010
    .byte   %00000010
Zero:
    .byte   %00111100
    .byte   %01000010
    .byte   %01000010
    .byte   %01000010
    .byte   %00000000
    .byte   %01000010
    .byte   %01000010
    .byte   %01000010
Three:
    .byte   %00111100
    .byte   %00000010
    .byte   %00000010
    .byte   %00000010
Nine:
    .byte   %00111100
    .byte   %00000010
    .byte   %00000010
    .byte   %00000010
Eight:
    .byte   %00111100
    .byte   %01000010
    .byte   %01000010
    .byte   %01000010
Six:
    .byte   %00111100
    .byte   %01000010
    .byte   %01000010
    .byte   %01000010
Two:
    .byte   %00111100
    .byte   %01000000
    .byte   %01000000
    .byte   %01000000
Five:
    .byte   %00111100
    .byte   %00000010
    .byte   %00000010
    .byte   %00000010
    .byte   %00111100
    .byte   %01000000
    .byte   %01000000
    .byte   %01000000
    .byte   %00111100

  CHECKPAGE One

DataEnd1:

  IF <. < KERNEL_H-1
    ORG (. & ~$ff) + KERNEL_H-1
  ENDIF

FREE SET FREE + . - DataEnd1
  IF LARGE_BOUNCY
Bouncy:
    .byte   %00111000
    .byte   %01111100
    .byte   %01111100
    .byte   %11000110
    .byte   %10111010
    .byte   %11111110
    .byte   %11111110
    .byte   %11010110
    .byte   %11010110
    .byte   %01111100
    .byte   %01111100
    .byte   %00111000
  ELSE
Bouncy:
    .byte   %01110000
    .byte   %11011000
    .byte   %10101000
    .byte   %11111000
    .byte   %10101000
    .byte   %10101000
    .byte   %11111000
    .byte   %01110000
  ENDIF

DataEnd2:
;    .byte   "Splatform v1.00 - (C) 2003 Thomas Jentzsch"

FREE SET FREE + BASE_ADR + $3fc - DataEnd2

  ECHO "*** Free ", FREE, " bytes ***"

    org $fffc, 0

    .word   Start
    .word   Reset
