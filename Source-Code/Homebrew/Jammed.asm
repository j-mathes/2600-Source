; TODOs:
; + Moves berechnen
; + Exit open (disable cursor, stop game)
; + PAL/NTSC
; + Flackern beim Laden eines neuen Puzzles
; + Sound (stop cursor, finished/optimal)
; + optimierte Puzzles (mehr freie Flächen)

    processor   6502
    include     vcs.h

;===============================================================================
; A S S E M B L E R - S W I T C H E S
;===============================================================================
DEBUG           = 0
DEMO            = 0
ILLEGAL         = 1
CURMOVE         = 1
DISABLE         = 0
PAL             = 1
SYNCFRAMES      = 5 ; bei 5 flackert's bei längerer Auswahl

;===============================================================================
; C O N S T A N T S
;===============================================================================
EXITROW         = 2
GRIDSIZE        = 6
NUMSTRIPS       = GRIDSIZE*2
NUMPATTERN      = 22

NUMBLOCKS       = GRIDSIZE*2-1
MAXCARS         = 14                    ; has been verified!
MAXLEVEL        = 6

Y0              = 12
CH              = 20+1
SH              = 6+1
BH              = CH+SH
BW              = [4*4]
OFFSETX         = 31
OFFSETY         = CH*6+SH*7+Y0-18
CARRIGHT        = 6*BW+4

NUMDIGITS       = 5

; colors:
BLOCKCOL        = $0e
CARCOL          = $1e
STOPCOL         = $48
ARROWCOL        = $88
CARCOL_PAL      = $5c   ;$2e
STOPCOL_PAL     = $68
ARROWCOL_PAL    = $d8

; sounds:
SOUND_CAR       = 2
SOUND_TRUCK     = SOUND_CAR   + 1           ; must!
  IF DEMO
SOUND_BEST      = SOUND_TRUCK + 5
  ELSE
SOUND_BEST      = SOUND_TRUCK + 17
  ENDIF
SOUND_SOLVED    = SOUND_BEST  + 3

; masks for carLst:
CARMASK_X       = %00000111
CARMASK_Y       = %00111000
CARMASK_3       = %01000000

; masks for State:
RESETMASK       = %00000001                 ; SWCHB
SELECTMASK      = %00000010                 ; SWCHB
SWITCHESMASK    = RESETMASK|SELECTMASK
BUTTONMASK      = %00001000                 ; from INPT4
SOLVEDMASK      = %10000000

; opcodes:
opBIT_B     = $24               ; opcode for bit.b
opBIT_W     = $2c               ; opcode for bit.w
opLAX       = $af               ; illegal opcode for lax absolute
opLAX_ZP    = $a7               ; illegal opcode for lax ZP
opLAX_IY    = $b3               ; illegal opcode for lax(),y
opLAX_Y     = $bf               ; illegal opcode for lax,y
opNOP_W     = $0c


;===============================================================================
; Z P - V A R I A B L E S
;===============================================================================

    SEG.U   variables
    ORG     $80

tmpVar          .word
tmpVar2         = tmpVar + 1
column          .word
row             = column + 1

lastCar         .byte
movedCar        .byte
CurEnd          .byte
CurPtr          = column    ;.word
CurCol          = movedCar  ;.byte
CarPosX         .byte
SyncFrames      .byte
;---------------------------------------
; these variables are cleared together
CurXY           .word
CurY            = CurXY
CurX            = CurXY + 1
CurMoveXY       .ds 3
CurMoveY        = CurMoveXY
CurMoveX        = CurMoveXY + 1
CarMoveX        = CurMoveXY + 2
State           .byte
PlusMinus       .byte               ; $80
;---------------------------------------
; audio variables:
AudTim0         .byte
AudIdx0         .byte
;---------------------------------------
; playfied variables:
PF1Left         .ds     NUMBLOCKS
PF2Left         .ds     NUMBLOCKS
PF2Right        .ds     NUMBLOCKS
PF1Right        .ds     NUMBLOCKS
PFLst           = PF1Left
;---------------------------------------
FrameCnt        .byte
;---------------------------------------
; level variables:
Level           .byte
Card            .byte
Moves           .byte
numCars         .byte
carLst          .ds     MAXCARS

;---------------------------------------
; score display variables:
digitPtr        ds.w    NUMDIGITS    ;                    10*8 Kernel (digits only)
digitColPtr     .word
minusPatPtr     .word
;---------------------------------------
; static decompress variables:
valuePtr        .word
valueIdx        .byte
shift           .byte
oldValues       .ds     shift-valuePtr+1
;-------------------------------------------
    ORG     PFLst
; temporary decompress variables:
stripPat        .ds     NUMSTRIPS
curStripPat     .byte
rowColIdx       .byte
gridLst         .ds     NUMSTRIPS


;===============================================================================
; M A C R O S
;===============================================================================

  MAC BIT_B
    .byte   opBIT_B
  ENDM

  MAC BIT_W
    .byte   opBIT_W
  ENDM

  MAC LAX_IY
   IF ILLEGAL
    lax     ({1}),y
   ELSE
    lda     ({1}),y
;    tax
   ENDIF
  ENDM


;===============================================================================
; R O M - C O D E
;===============================================================================
    SEG     Bank0
    ORG     $f000


  IF SYNCFRAMES
DoSync:
    dec     SyncFrames
    bpl     ContSync
  ENDIF
;***********************************************************
DrawScreen SUBROUTINE
;***********************************************************
.waitTim:
    lda     #$c0
    eor     INTIM
    bne     .waitTim
    sta     WSYNC

;*** display score: ***
    sta     HMOVE               ; 3
;    sta     VBLANK              ; 3 =  6        end the VBLANK period with a zero

  sta     PF1
;    sta     PF2

    lda     FrameCnt            ; 3
    and     #%00111000          ; 2
    lsr                         ; 2
    lsr                         ; 2
    lsr                         ; 2
    adc     #<DigitColTab       ; 2             CF=0!
    sta     digitColPtr         ; 3 = 16
  IF SYNCFRAMES
    ldx     #3                  ; 2
  ELSE
    ldx     #4                  ; 2
  ENDIF
.waitDigit:
    dex                         ; 2
    bne     .waitDigit          ; 2³= 26

;    clc                         ; 2
    stx     COLUP0              ; 3
    stx     COLUP1              ; 3
    lda     #%11111100          ; 2
    sta     PF2                 ; 3 = 13

  IF SYNCFRAMES
    lda     SyncFrames
    bne     DoSync
  ENDIF
    stx     VBLANK
ContSync:

    ldy     #NUMHEIGHT          ; 2 =  2
.digitLoop:
    lda     (minusPatPtr),y     ; 5  64
    sta     ENABL               ; 3  67
    lda     (digitColPtr),y     ; 5  72
    sta     COLUPF              ; 3  75
    bit     tmpVar              ; 3   2    6
    lda     (digitPtr+$0),y     ; 5   7   21
    sta     GRP0                ; 3  10   30      D1     --      --     --
    lda     (digitPtr+$2),y     ; 5  15   45
    sta     GRP1                ; 3  18   52      D1     D1      D2     --
    lda     #-1                 ; 2  20   60
    sta     GRP0                ; 3  23   69      D3     D1      D2     D2
    LAX_IY  digitPtr+$8         ; 5  28   84      lax (digitPtr+$a),y
    txs                         ; 2  30   90
    LAX_IY  digitPtr+$4         ; 5  35  105      lax (digitPtr+$6),y
    lda     (digitPtr+$6),y     ; 5  40  120               !
    stx     GRP1                ; 3  43  129      D3     D3      D4     D2!
    sta     GRP0                ; 3  46  138      D5     D3!     D4     D4
    tsx                         ; 2  48  144
    stx     GRP1                ; 3  51  153      D5     D5      D6     D4!
    sty     GRP0                ; 3  54  162      D4*    D5!     D6     D6
    dey                         ; 2  56  168                              !
    bne     .digitLoop          ; 2³ 59  177

    sty     PF2                 ; 3
    sty     GRP1                ; 3
    sty     GRP0                ; 3
    sty     VDELP1              ; 3
    sty     VDELP0              ; 3
    sty     NUSIZ0              ; 3
    lda     #BLOCKCOL           ; 2
    sta     COLUPF              ; 3
    ldx     #$fd                ; 2             restore
    txs                         ; 2 = 27         stack pointer

;***** positon car: *****
    lda     CarPosX             ; 3
    clc                         ; 2
    adc     CarMoveX            ; 3
    jsr     CalcXPos            ;55 = 63

    sta     WSYNC               ; 3

    sta     HMP1                ; 3
    lda     CurX                ; 3
    asl                         ; 2
    asl                         ; 2
    asl                         ; 2
    asl                         ; 2
.waitP1:
    dey                         ; 2
    bpl     .waitP1             ; 2³
    sta.w   RESP1               ; 4 = 22

    sta     WSYNC               ;

;***** positon cursor: *****
    adc     #OFFSETX+8          ; 2
    adc     CurMoveX            ; 3
    jsr     CalcXPos            ;55 = 60

    sta     WSYNC               ; 3

    sta     HMP0                ; 3
    lda     #%111               ; 2
    sta     NUSIZ1              ; 3
    lda     CurCol              ; 3
    sta     COLUP0              ; 3
.waitP0:
    dey                         ; 2
    bpl     .waitP0             ; 2³
    sta.w   RESP0               ; 4 = 22

    sta     WSYNC
;-----------------------------------------------------------
    sta     HMOVE

    lda     #CARCOL
  IF PAL
    bit     SWCHB
    bpl     .noPAL
    lda     #CARCOL_PAL
.noPAL:
  ENDIF
    sta     COLUP1

    ldx     #6
.wait:
    dex
    bpl     .wait

    jsr     .drawFullBlock      ;               x=$ff!
    jsr     .drawEmptyBlock     ;               x=$00!

    ldy     #Y0                 ; 2
    tya                         ; 2
    ldx     #NUMBLOCKS          ; 2|57

;***** main kernel loop: *****
.loopBlock:
    nop                         ; 2
    sec                         ; 2
.nextBlock:                     ;  |61
    sbc     CurEnd              ; 3
    adc     #ARROWH             ; 2
    bcc     .noCursor           ; 2³
    lda     (CurPtr),y          ; 5|73 = 12
    bit     tmpVar              ; 3
.contCursor:
    bit     tmpVar              ; 3
    sta     GRP0                ; 3

    cpx     #NUMBLOCKS-EXITROW*2; 2             7
    beq     .doCar              ; 2³
    lda     #0                  ; 2
    beq     .contCar            ; 3

.noCursor:
    lda     #0                  ; 2|71
    nop                         ; 2
    bcc     .contCursor         ; 3

.doCar:
    lda     CarPat-BH*2-Y0,y    ; 4
.contCar:                       ;
    sta     GRP1                ; 3
    iny                         ; 2    = 20

    lda     PF1Left-1,x         ; 4
    sta     PF1                 ; 3|27
    lda     PF2Left-1,x         ; 4
    sta     PF2                 ; 3|34 = 14

    lda     PF1Right-1,x        ; 4
    sta     PF1                 ; 3|41
    lda     PF2Right-1,x        ; 4
    sta     PF2                 ; 3|48 = 14

    tya                         ; 2
    cmp     BlockSizeTab-1,x    ; 4
    bcc     .loopBlock          ; 2³
    dex                         ; 2
    bne     .nextBlock          ; 2³   = 12/13

    jsr     .drawEmptyBlock     ;               x=$00
    dex                         ;               x=$ff
;DrawScreen END

.drawFullBlock:
    lda     #$3f
    BIT_W
.drawEmptyBlock:
    lda     #$20
;***************************************************************
DrawBlock SUBROUTINE
; Input : x (->PF2), a (->PF1)
; Output: x, y = 0
; Flags : ZF = 1, CF = 0
; Uses  : a, x, y
; Cycles:
;***************************************************************
    ldy     #SH                 ; 2
    stx     PF2                 ; 3
.loopRows:
    sta     WSYNC               ; 3

    sta     PF1                 ; 3
    ldx     #6                  ; 2
.waitRow:
    dex                         ; 2
    bne     .waitRow            ; 2³
    lsr                         ; 2
    sta     PF1                 ; 3
    rol                         ; 2
    dey                         ; 2
    bne     .loopRows           ; 2
    rts                         ; 6|51
;DrawBlock END

;***********************************************************
CalcXPos SUBROUTINE
; Input : a (= xpos)
; Output: a (=HMOVE), y (=delay)
; Uses  : a, y,
;         tmpVar
; Cycles: 43-49 (avg.:~45)
;***********************************************************
    tay                         ; 2
    lsr                         ; 2
    lsr                         ; 2
    lsr                         ; 2
    lsr                         ; 2
    sta     tmpVar              ; 3 = 13
    tya                         ; 2
    and     #$0f                ; 2
    clc                         ; 2
    adc     tmpVar              ; 3
    ldy     tmpVar              ; 3
    cmp     #$0f                ; 2
    bcc     .nextPos            ; 2³
    sbc     #$0f                ; 2
    iny                         ; 2
.nextPos:                       ;   = 17/20
    eor     #%00000111          ; 2
    asl                         ; 2
    asl                         ; 2
    asl                         ; 2
    asl                         ; 2
    rts                         ; 6 = 16
;CalcXPos END

;***********************************************************
VerticalSync SUBROUTINE
;***********************************************************
    ldx     #2
    sta     WSYNC

    stx     VSYNC               ; 3             begin vertical sync.
    dec     FrameCnt            ; 5 =  8

;*** calc end of cursor: ***
    lda     CurMoveY            ; 3
    asl                         ; 2
    clc                         ; 2
    ldy     CurY                ; 3
    adc     CurYTab,y           ; 4
    sta     CurEnd              ; 3 = 17

;*** setup lo-pointers for score: (part1/2) ***
; -MM CCC
    lda     #<MinusPat-1        ; 2
    bit     PlusMinus           ; 3
    bpl     .showMinus          ; 2³
    lda     #<NoMinusPat-1      ; 2
.showMinus:
    sta     minusPatPtr         ; 3 = 11/12

    ldy     Level               ; 3
    lda     DigitTab,y          ; 4
    sta     digitPtr+$4         ; 4
    lda     Card                ; 3
    ldx     #6                  ; 2
    jsr     SetDigit            ;49 = 65

    sta     WSYNC               ; 3             first and second line of VSYNC

    ldx     #1                  ; 2
    lda     #%011               ; 2             3 copies close
.loopSet:
    sta     NUSIZ0,x            ; 4
    sta     VDELP0,x            ; 4
    dex                         ; 2
    bpl     .loopSet            ; 2³= 29

    lda     #$e0                ; 2
    ldy     #$b0                ; 2
    sta     RESBL               ; 3
    sta     RESP0               ; 3|39 -> *3 + 1 = 118
    sta     RESP1               ; 3|42 -> *3 + 0 = 126
    sty     HMBL                ; 3
    sta     HMP0                ; 3             + 1 pixel
    stx     HMP1                ; 3 = 15        +/- 0 pixel

    ldx     #$c0+43-10          ; 2             29 lines (NTSC)
  IF PAL
    bit     SWCHB               ; 4
    bpl     .noPAL              ; 3
    ldx     #$c0+43-10+27       ; 2             51 lines (PAL)
.noPAL:
  ENDIF
    sta     WSYNC               ; 3             third line of VSYNC.

    sta     VSYNC               ; 3
    stx     TIM64T              ; 4
;VerticalSync END

;***********************************************************
CheckSwitches SUBROUTINE
;***********************************************************
    lda     SWCHB               ; 4
    and     #~SWITCHESMASK      ; 2
    eor     State               ; 3
    and     #~SWITCHESMASK      ; 2
    eor     SWCHB               ; 4
    tax                         ; 2
    lda     State               ; 3
    eor     #SWITCHESMASK       ; 2
    ora     SWCHB               ; 4
    stx     State               ; 3
    lsr                         ; 2
    bcc     RestartCard         ; 2³
    lsr                         ; 2
    bcs     GameCalc            ; 2³= 37/38
;***********************************************************
SelectLevel SUBROUTINE
;***********************************************************
    bit     INPT4               ;           fire pressed?
    bpl     LoadRandomCard      ;            yes, select random puzzle

    ldy     Level
    iny
    cpy     #MAXLEVEL
    bcc     .skipReset
    ldy     #0
.skipReset:
    sty     Level
GameInit:
    jsr     LoadFirstCard
    bmi     StartCard

;***********************************************************
LoadRandomCard SUBROUTINE
;***********************************************************
  IF DEBUG
    jsr     LoadNextCard
    jmp     StartCard
  ENDIF

    lda     FrameCnt            ; 3
    and     #$3f                ; 2
    tax

  IF SYNCFRAMES
    lsr                         ; 2         sync longer for higher values
    lsr
    lsr
    adc     #SYNCFRAMES
    sta     SyncFrames
  ENDIF

    BIT_W                       ; 2
NextCard:
    ldx     #0                  ; 2
    stx     tmpVar2             ; 3
.loopNext:
    jsr     LoadNextCard        ; 6
    dec     tmpVar2             ; 3
    bpl     .loopNext           ; 2³
    bmi     StartCard           ; 3         verhindert 2-faches Decode
;LoadRandomCard END
;SelectLevel END

;***********************************************************
RestartCard SUBROUTINE
;***********************************************************
    jsr     LoadCurrentCard
StartCard:
    jsr     PostDecodeCard      ;3207

    pla                         ; 4         pop return address
    pla                         ; 4         pop return address

.waitTim:
    lda     INTIM               ; 4
    bne     .waitTim            ; 2³

    ldx     #42
.wait:
    sta     WSYNC
    dex
    bne     .wait
    beq     SkipScreen          ; 3
;RestartCard END

;***************************************************************
InitVCS SUBROUTINE
;***************************************************************
    sei                         ;           disable interrupts, if there are any.
    cld                         ;           clear BCD math bit.

    ldx     #0
    txs
    pha                         ;           set stack to beginning.
    txa
.clearLoop:
    pha
    dex
    bne     .clearLoop

;*** init some variables: ***
;    lda     #$10
;    sta     PF0

;    lda     #1
;    sta     CurX
;    lda     #0
;    sta     CurY

;    lda     #9
;    sta     Level
;    lda     #$25
;    sta     Card

;    ldy     #1
;    sty     Level
;    jsr     LoadFirstCard

    lda     #%100001            ;           relect PF, BL size = 4
    sta     CTRLPF
    lda     #$0c                ; 2         set sound
    sta     AUDC0               ; 3

;*** set hi-pointers for score display: ***
    ldx     #[NUMDIGITS+2]*2    ;           includes minusPatPtr & digitColPtr
    lda     #>zero
.loopPtr:
    dex
    sta     digitPtr,x
    bne     .loopPtr
    jsr     GameInit

;***** the main loop: *****
.mainLoop:
    jsr     VerticalSync        ;           execute the vertical sync and blank
    jsr     DrawScreen          ;           draw the screen
SkipScreen:
    jsr     OverScan            ;           execute overscan
    bmi     .mainLoop           ; 3         continue forever
;InitVCS END

;***********************************************************
GameCalc SUBROUTINE
; Input : x = State
; Output: none
; Uses  : tmpVar
; Cycles:
;***********************************************************
    txa                         ;           x = State
    bpl     .checkMove

;*** check for fire button to start next card: ***
    jsr     CheckButton         ;           fire button pressed?
    bcs     NextCard            ; 2³         yes, goto next card

;*** check for yellow car moving: ***
.checkMove:
    ldx     CarMoveX
    beq     .contCalc

;*** check for yellow car exiting: ***
    lda     CarPosX
    cmp     #OFFSETX+CARRIGHT   ;           card solved?
    bne     .jmpShowStop      ;            no, car is just moving
.contDemo:
    lda     #SOLVEDMASK|BUTTONMASK;         set solved state
    sta     State
    lda     #GRIDSIZE-1         ;           position cursor at exit
    sta     CurX
    lda     #GRIDSIZE-1-EXITROW
    sta     CurY
    sta     CurEnd              ;           disable cursor!

    inx                         ;           car exit finished?
    bne     .jmpShowStop        ;            no, skip
    jsr     UpdateMoves         ;            yes, update moves...
    ldx     #SOUND_SOLVED
    lda     Moves
    bne     .soundSolved        ;             ...and...
    ldx     #SOUND_BEST         ;
    bne     .soundSolved        ; 3

;*** show red stop cursor: ***
.checkStopMove:
    jsr     CheckButton
    bcc     .jmpShowStop
    ldx     movedCar
    lda     carLst,x
    and     #CARMASK_3
    ldx     #SOUND_CAR
    asl
    bpl     .soundCar
    inx
.soundCar:
.soundSolved:
;*** start new tune: ***
    stx     AudIdx0             ; 4         replace old tune with new one...
    lda     #-1                 ; 2          ...and...
    sta     AudTim0             ; 4          ...start new sequence
.jmpShowStop:
    jmp     .showStop

.contCalc:
  IF DEMO
    bit     State
    bmi     .jmpShowStop
DemoCheck:
    lda     Card
    and     #$1f
    bne     .contDemo
DemoCheckEnd:
  ENDIF

;*** check, if cursor is currently moving: ***
    lda     CurMoveX
    ora     CurMoveY
    bne     .jmpShowStop

    ldx     CurX
    lda     CurY
    jsr     CheckGrid
    bne     .jmpShowStop      ;           cursor is on empty space
; x = car, y = pos
    stx     movedCar
    lda     carLst,x
    asl
    ldx     #0
    bcc     .horzCar
    inx
.horzCar:
    lda     #1
    dey
    bmi     .uprightMove
    lda     #-1
.uprightMove:
    rol
    sta     tmpVar              ;           a = -2,-1,2,3
    ror
    clc
    adc     column,x
    cmp     #GRIDSIZE
    bcs     .checkStopMove
    sta     column,x

    ldx     movedCar
    jsr     CheckSpace
    beq     .checkStopMove

;*** check fire button: ***
    jsr     CheckButton
    bcc     .showArrow           ; 2³= 22    skip if (not pressed) or (pressed before)

; ***** update number of moves: *****
    ldx     movedCar
    cpx     lastCar
    beq     .skipUpdateMoves
    stx     lastCar

    jsr     UpdateMoves
.skipUpdateMoves:

;***** update kernel data: *****
    jsr     SetupCar            ;           clear old data
    ldx     lastCar
    lda     tmpVar              ;
    cmp     #$80                ;           set CF
    ror                         ;           horizontal move?
    bcc     .horz               ;            yes, skip multiplication
    asl
    asl
    asl
    clc
.horz:
    adc     carLst,x            ;           move car
    sta     carLst,x
    jsr     SetupCar            ;           set new data

;***** move cursor with car: *****
  IF CURMOVE
    bit     SWCHB
    bvs     .skipMoveCur

    lda     tmpVar
    cmp     #$80
    ror
    tay
    ldx     #1
    bcc     .horzMoveCur
    dex
    clc
.horzMoveCur:
    adc     CurXY,x
    sta     CurXY,x

    ldx     lastCar             ;           yellow car?
    bne     .skipMoveCur
    iny
    lda     CarMoveTab,y
    sta     CarMoveX            ;           animate yellow car
    sta     CurMoveX            ;            and cursor
.skipMoveCur:
  ENDIF

;***** show red stop cursor: *****
.showStop:
    lda     #<ArrowStop+ARROWH  ; 2         show 'STOP' cursor
    ldx     #STOPCOL            ; 2          in red
  IF PAL
    bit     SWCHB
    bpl     .noPAL
    ldx     #STOPCOL_PAL
.noPAL:
  ENDIF
    bne     .endMove

;***** get blue 'ARROW' cursor pattern: *****
.showArrow:
    ldy     tmpVar
    iny
    iny
    lda     CurPtrTab,y
    ldx     #ARROWCOL
  IF PAL
    bit     SWCHB
    bpl     .noPAL2
    ldx     #ARROWCOL_PAL
.noPAL2:
  ENDIF

;***** set cursor pattern and color: *****
.endMove:
    stx     CurCol
    sec
    sbc     CurEnd
    sta     CurPtr
    lda     #>[ArrowUp+ARROWH]
    sta     CurPtr+1

;***********************************************************
PlayAudio SUBROUTINE
; Cycles: 6-44
;***********************************************************
;-2 = first note
;-1 = next note
; 0 = pause
;>0 = continue
    ldy     AudIdx0             ; 3         playing a tune?
    beq     .skipAudio          ; 2³         no, skip
    ldx     AudTim0             ; 3         decrease timer
    dex                         ; 2
    beq     .zeroVolume         ; 2³         if zero, play break
    bpl     .playAudio          ; 2³         if > 0, continue current note
;*** start next note: ***
    dey                         ; 2
    lda     AudF0Tab-1,y        ; 4         if( FxTab,y & $80 == 0 &&     (FxTab-Startwert: Bit 7 = 0 sonst = 1)
    sta     AUDF0               ; 3
    ora     AudTim0             ; 3             TimVx == 0 )
    bmi     .setAudio           ; 2³
    ldy     #0                  ; 2         stop audio-sequence
.zeroVolume:
    lda     #0                  ; 2         set volume = 0
    beq     .contAudio          ; 3

.setAudio
    lda     #$0f                ; 2         set volume
    ldx     AudT0Tab-1,y        ; 4
.contAudio:
    sty     AudIdx0             ; 3
    sta     AUDV0               ; 3
.playAudio:
    stx     AudTim0             ; 3
.skipAudio:

;    ldy     AudIdx0             ; 4         playing a tune?
;    beq     .skipAudio          ; 2          no, skip
;    dec     AudTim0             ; 6         decrease timer
;    bmi     .startAudio         ; 2          if negative, start new tune
;    bne     .skipAudio          ; 2          if not zero, continue current note
;    dey                         ; 2          else, next note
;.startAudio:
;    lda     AudF0Tab-1,y        ; 4         if( FxTab,y & $80 == 0 &&     (FxTab-Startwert: Bit 7 = 0 sonst = 1)
;    sta     AUDF0               ; 4
;    ora     AudTim0             ; 4             TimVx == 0 )
;    bmi     .setAudio           ; 2³
;    lda     #0                  ; 2         disable sound
;    tay                         ; 2         stop play-sequence
;    beq     .contAudio          ; 3
;
;.setAudio
;    lda     AudT0Tab-1,y        ; 4
;    sta     AudTim0             ; 4
;    lda     AudVC0Tab-1,y       ; 4
;    sta     AUDC0               ; 4
;    lsr                         ; 2
;    lsr                         ; 2
;    lsr                         ; 2
;    lsr                         ; 2
;.contAudio:
;    sta     AUDV0               ; 4
;    sty     AudIdx0             ; 4
;.skipAudio:
;PlayAudio END

;********** read joystick: **********
    bit     State               ;           game solved?
    bmi     .skipJoystick

    ldx     #1                  ; 2
    ldy     #0                  ; 2
    lda     SWCHA               ; 4
.loopDir:
    asl                         ; 2         a) joystick moved?
    pha                         ; 3
    lda     CurMoveXY,x         ; 4         b) cursor currently moving?
    rol                         ; 2
    bne     .skipDir            ; 2³         a) yes AND b) no
    lda     CurXY,x             ; 4
    cmp     CurStopTab,y        ; 4
    beq     .skipDir            ; 2³
    adc     CurTab,y            ; 4
    sta     CurXY,x             ; 4
    lda     CurMoveTab,y        ; 4
    sta     CurMoveXY,x         ; 4
.skipDir:
    tya                         ; 2
    lsr                         ; 2
    iny                         ; 2
    pla                         ; 4
    bcc     .loopDir            ; 2³
    dex                         ; 2
    bpl     .loopDir            ; 2³

.skipJoystick:
    ldx     #3                  ; 2         horz, vert and the yellow car
.loopMove:
    ldy     CurMoveXY-1,x       ; 4
    beq     .skipMoveX          ; 2³
    bpl     .moveUpLeft         ; 2³
    iny                         ; 2
    BIT_B                       ; 1
.moveUpLeft:
    dey                         ; 2
    sty     CurMoveXY-1,x       ; 4
.skipMoveX:
    dex                         ; 2
    bne     .loopMove           ; 2³= 37-67

;*** setup lo-pointers for score: (part 2/2) ***
; -MM CCC
;    ldx     #0                  ; 2
    lda     Moves               ; 3         x=0!
;GameCalc END

;***********************************************************
SetDigit SUBROUTINE
;***********************************************************
    pha                         ; 3
    and     #%1111              ; 2
    tay                         ; 2
    lda     DigitTab,y          ; 4
    sta     digitPtr+2,x        ; 4
    pla                         ; 4
    lsr                         ; 2
    lsr                         ; 2
    lsr                         ; 2
    lsr                         ; 2
    tay                         ; 2
    lda     DigitTab,y          ; 4
    sta     digitPtr,x          ; 4
    rts                         ; 6 = 43
;SetDigit END

;***********************************************************
CheckButton SUBROUTINE
; Output: CF (1 == pressed)
; Cycles: 22/26
;***********************************************************
    clc                         ; 2
    lda     State               ; 3
    and     #~BUTTONMASK        ; 2         unmask button-bit
    bit     INPT4               ; 3         button pressed ?
    bmi     .noButton           ; 2³         no, skip button
    cmp     State               ; 3         button pressed before?
    ora     #BUTTONMASK         ; 2         mark as pressed
.noButton:
    sta     State               ; 3         save current state
    rts                         ; 6 = 22/26
;CheckButton END

;***********************************************************
UpdateMoves SUBROUTINE
;***********************************************************
    lda     Moves
    bmi     .skipUpdate         ;               stop at 80 moves
    sed
    clc
    adc     #$01
    bit     PlusMinus
    bmi     .minus
    adc     #$98
.minus:
    sta     Moves
    cld
    tay
    bne     .skipUpdate
    ror     PlusMinus           ;               disable minus
.skipUpdate:
    rts
;UpdateMoves END

;***********************************************************
CheckGrid SUBROUTINE
; Input : x, a (position to check)
; Output: CF, ZF (1 == no space), y (0 == right/up)
; Uses  : a, x, y,
;         column, row
; Cycles: ~470 - ~600
;***********************************************************
    stx     column              ; 3
    sta     row                 ; 3

CheckSpace:
    ldx     numCars             ; 3         -1!
.loopCars:
    lda     carLst,x            ; 4
    ldy     #1                  ; 2
    asl                         ; 2
    bpl     .len2               ; 2³
    iny                         ; 2
.len2:
    ror                         ; 2
    bmi     .vertCar            ; 2³= 15-17

    and     #CARMASK_Y          ; 2
    lsr                         ; 2
    lsr                         ; 2
    lsr                         ; 2
    eor     row                 ; 3
    bne     .nextCar            ; 2³= 13/14

    lda     carLst,x            ; 4
    and     #CARMASK_X          ; 2 =  6
.loopHorz:
    cmp     column              ; 3
    bcs     .nextCar            ; 2³
    adc     #1                  ; 2             CF=0!
    dey                         ; 2
    bpl     .loopHorz           ; 2³= 11/12
    bmi     .nextCar            ; 2³

;horz:
;2er: 100%: 36
;3er: 100%: 37
;vert:
;2er: 33%: 63, 67%: 31 = ~42
;3er: 50%: 78, 50%: 32 = ~55

.vertCar:                       ;16/17
    and     #CARMASK_X          ; 2
    eor     column              ; 3
    bne     .nextCar            ; 2³= 24

    lda     carLst,x            ; 4
    and     #CARMASK_Y          ; 2
    lsr                         ; 2
    lsr                         ; 2
    lsr                         ; 2 = 12
.loopVert:
    cmp     row                 ; 3
    bcs     .nextCar            ; 2³
    adc     #1                  ; 2             CF=0!
    dey                         ; 2
    bpl     .loopVert           ; 2³= 11/12

.nextCar:
    beq     .noSpace            ; 2³
    dex                         ; 2
    bpl     .loopCars           ; 2³
.noSpace:                       ;               CF, ZF=1!
    rts                         ; 6
;CheckGrid END


;***********************************************************
OverScan SUBROUTINE
;***********************************************************
;*** start VBLANK: ***          ;57
    ldy     #2                  ; 2
    sta     WSYNC               ;               finish the last kernel scanline

    sty     VBLANK              ;               make TIA output invisible

;*** start overscan timer: ***
    lda     #38+2               ; 2             34 lines (NTSC)
  IF PAL
    bit     SWCHB               ; 4
    bpl     .noPAL              ; 3
    lda     #38+2+10            ; 2             42 lines (PAL)
.noPAL:
  ENDIF
    sta     TIM64T              ; 4

    bit     State
    bmi     .noExit
;*** check for open exit: ***
    lda     carLst
    and     #CARMASK_X
    tax
    inx
.loopExit:
    lda     #GRIDSIZE-1-EXITROW
    inx
    jsr     CheckGrid
    beq     .noExit
    ldx     column
    cpx     #GRIDSIZE-1
    bne     .loopExit

;*** start car leaving the grid: ***
    lda     #OFFSETX+CARRIGHT
    sta     CarPosX
    lda     carLst
    asl
    asl
    asl
    asl
    sbc     #$80+CARRIGHT
    sta     CarMoveX
.noExit:

.waitTim:
    lda     INTIM
    bpl     .waitTim
    rts
;OverScan END


;***********************************************************
PostDecodeCard SUBROUTINE
; Input : -
; Output: Moves, x = -1, NF = 1
; Uses  : ?
; Cycles: ~1254 (+ ~1947 = ~3201)
;***********************************************************
;*** compute moves to solution: ***
    ldy     Level                   ; 3
    ldx     MovesOffsetTab,y        ; 4
    sed                             ; 2
    lda     MinMovesTab,y           ; 4
    clc                             ; 2 = 15
.loopMoves:
    adc     #$00                    ; 2
    tay                             ; 2
    lda     Card                    ; 3
    cmp     LevelMovesTab,x         ; 4
    inx                             ; 2
    tya                             ; 2
    bcs     .loopMoves              ; 2³
    sty     Moves                   ; 3
    cld                             ; 2 = ~184  (10.)

;*** convert strips to cars: ***
    lda     #-1                     ; 2
    sta     numCars                 ; 3
    ldx     #EXITROW                ; 2 =  7
.loopConvert:
    stx     rowColIdx               ; 3
    ldy     gridLst,x               ; 4
    beq     .nextStrip              ; 2³
    jsr     SetCar                  ;53
    cpy     #<Pattern2Tab-PatternTab; 2         two cars in strip?
    bcc     .nextStrip              ; 2³
    tya                             ; 2
    adc     #CarTab2End-CarTab2-1   ; 2         CF=1!
    tay                             ; 2
    jsr     SetCar                  ;53
.nextStrip:
    ldy     rowColIdx               ; 3
    ldx     RowColTab,y             ; 4
    bpl     .loopConvert            ; 2³= 20/77/135 (2/6/4:~1042)
;PostDecodeCard END
;***********************************************************
SetupKernel SUBROUTINE
; Input : none
; Output: x = -1, CF = 0
; Uses  : a, x, y,
;         tmpVar, tmpVar2
; Cycles: ~1981
;***********************************************************
;*** clear PF blocks: ***
    ldx     #NUMBLOCKS-1        ; 2         = 11
.loopBorder:
    lda     #%00100000          ; 2
    sta     PF1Left,x           ; 4
    lsr                         ; 2
    sta     PF1Right,x          ; 4
    lda     #0                  ; 2
    sta     PF2Left,x           ; 4
    sta     PF2Right,x          ; 4
    dex                         ; 2
    bpl     .loopBorder         ; 2³

    sta     PF1Right+5          ; 3         clear exit
    sta     PF1Right+6          ; 3         clear exit
    sta     PF1Right+7          ; 3 = 307   clear exit

;*** clear variables: ***
    ldx     #<PlusMinus-CurXY   ; 2         = 6
.loopClear:
    sta     CurXY,x             ; 4         a = 0
    dex                         ; 2
    bpl     .loopClear          ; 2³
    stx     lastCar             ; 3 = 67    set lastCar = -1

;*** set PF blocks: ***
    ldx     numCars             ; 3         = ~14
.loopCars:
    stx     tmpVar              ; 3
    jsr     SetupCar            ;101
    ldx     tmpVar              ; 3
    dex                         ; 2
    bpl     .loopCars           ; 2³
    jmp     CheckButton         ;29 = 1599  set state = button pressed
;SetupKernel END

;***********************************************************
SetCar SUBROUTINE
; Cycles: 50/44 (~47)
;***********************************************************
; x = RowCol, a = value
    lda     rowColIdx               ; 3
    sec                             ; 2
    sbc     #GRIDSIZE               ; 2
    tax                             ; 2
    lda     CarTab-1,y              ; 4
    bcc     .horzCar                ; 2³= 15/16

    and     #$80|CARMASK_3|CARMASK_Y; 2
    sta     tmpVar                  ; 3
    txa                             ; 2
    bcs     .contCar                ; 3 = 10

.horzCar:
    and     #CARMASK_3|CARMASK_X    ; 2
    sta     tmpVar                  ; 3
    txa                             ; 2
    eor     #$ff                    ; 2
    asl                             ; 2
    asl                             ; 2
    asl                             ; 2 = 15
.contCar:
    ora     tmpVar                  ; 3
    inc     numCars                 ; 3
    ldx     numCars                 ; 3
    sta     carLst,x                ; 4
    rts                             ; 6 = 19
;SetCar END

;***********************************************************
SetupCar SUBROUTINE
; Input : x (number of car)
; Output: CF = 0
; Uses  : a, y,
;         tmpVar2
; Cycles: 30-151 (~95)
;***********************************************************
    lda     carLst,x            ; 4
    and     #CARMASK_X          ; 2
    dex                         ; 2
    bmi     .setupRedCar        ; 2³
    tay                         ; 2         index in PFStartTab
    lda     carLst+1,x          ; 4
    sta     tmpVar2             ; 3
    and     #CARMASK_Y          ; 2
    lsr                         ; 2
    lsr                         ; 2
    adc     PFStartTab,y        ; 4         CF=0!
    tax                         ; 2 = 31    offset in PFLst-Row

    bit     tmpVar2             ; 3
    bmi     .vertCar            ; 2³
    bvc     .horzCar2           ; 2³
    tya                         ; 2
    adc     #(HorzCar3Tab1-HorzCar2Tab1);2
    tay                         ; 2
.horzCar2:                      ;   = 8/13
;y = PFStartTab[X]
;x = Y * 8 + PFStartTab[X]
    lda     HorzCar2Tab1,y      ; 4
    eor     PFLst,x             ; 4
    sta     PFLst,x             ; 4
    lda     HorzCar2Tab2,y      ; 4
    eor     PFLst + NUMBLOCKS,x ; 4
    sta     PFLst + NUMBLOCKS,x ; 4
    rts                         ; 6 = 30        total: 69/74

.vertCar:                       ; 6
    lda     #3                  ; 2
    bvc     .vertCar2           ; 2³
    lda     #5                  ; 2
.vertCar2:
    sta     tmpVar2             ; 3 = 14/15

.nextVertCar:
    lda     VertCarTab,y        ; 4
    eor     PFLst,x             ; 4
    sta     PFLst,x             ; 4
    inx                         ; 2
    dec     tmpVar2             ; 3
    bne     .nextVertCar        ; 2³
    rts                         ; 6 = 65/105    total: 110/151

.setupRedCar:                   ;11
    asl                         ; 2
    asl                         ; 2
    asl                         ; 2
    asl                         ; 2
    adc     #OFFSETX            ; 2
    sta     CarPosX             ; 3
    rts                         ; 6 = 30
;SetupCar END

;***********************************************************
LoadCurrentCard SUBROUTINE
;***********************************************************
    ldx     #3
.loadOld:
    lda     oldValues,x
    sta     valuePtr,x
    dex
    bpl     .loadOld
    bmi     DecodeCard
;LoadCurrentCard END
;***********************************************************
LoadNextCard SUBROUTINE
;***********************************************************
    lda     Card
    clc
    sed
    adc     #$01
    cld                         ; 2         Card == 0 ?
    bcc     ContNextCard        ; 2³         no, skip LoadFirstCard
;LoadNextCard END
;***********************************************************
LoadFirstCard SUBROUTINE
;***********************************************************
    ldy     Level
    lda     LevelTabLo,y
    sta     valuePtr
    lda     LevelTabHi,y
    sta     valuePtr+1

  IF DEMO
    lda     #$80^$3d
    ldx     #DemoCheckEnd-DemoCheck-1
.loopDemo:
    eor     DemoCheck,x
    dex
    bpl     .loopDemo
  ELSE
    lda     #$80                ; 2
  ENDIF
    sta     shift               ; 3         prepare shift register
    asl                         ; 2
    sta     valueIdx            ; 3         reset value idx (a=0!)
ContNextCard:
    sta     Card                ; 3          and card
;LoadFirstCard END
;***********************************************************
DecodeCard SUBROUTINE
;***********************************************************
    ldx     #4
.saveOld:
    lda     valuePtr-1,x
    sta     oldValues-1,x
    dex
    bne     .saveOld

; ~6100 cycles/card
; clear strip-pattern:
    txa                         ; 2         a = 0
    ldx     #NUMSTRIPS          ; 2
.loopClear:
    dex                         ; 2
    sta     stripPat,x          ; 4
    bne     .loopClear          ; 2³

    ldx     #27+6               ; 2         compression-table-offset for first strip
    ldy     #EXITROW            ; 2
    BIT_W                       ; 2 = 117   skip next instruction

.loopStrips:
    ldx     #0                  ; 2
    sty     rowColIdx           ; 3
    lda     stripPat,y          ; 4
    sta     curStripPat         ; 3
    beq     .skipFree           ; 2³= 14    a=0,x=27/0!, EXITROW/empty stripPat (table4exit/table22)

;*** count free pattern (except empty pattern): ***
    ldy     #NUMPATTERN-1       ; 2
.loopFree:
    lda     PatternTab,y        ; 4
    and     curStripPat         ; 3
    bne     .notFree            ; 2³
    inx                         ; 2
.notFree:
    dey                         ; 2
    bne     .loopFree           ; 2³=~321   (5 free)

;*** determine compression table: ***
; x = number of free pattern-1 (empty is always free!)
    txa                         ; 2
    beq     .onePattern         ; 2³        only one (empty) pattern free
; y = 0!
.loopSize:
    iny                         ; 2
    eor     SizeTab-1,y         ; 4
    bne     .loopSize           ; 2³
; y = index of compression-table
    ldx     OffsetTab-1,y       ; 4 =~34    (3 loops)

;*** decode packed values: ***
.skipFree:                      ;           x = offset for table22/table4exit
; a = 0!
.loopValue:
    asl     shift               ; 5
    beq     .loadValue          ; 2³
.contValue:
    rol                         ; 2
    inx                         ; 2
    sec                         ; 2
    sbc     SubTab,x            ; 4
    bcs     .loopValue          ; 2³
.loopAdd:
    adc     SubTab,x            ; 4
    dex                         ; 2
    tay                         ; 2         restore N-flag
    bpl     .loopAdd            ; 2³
    ldx     FreeIdxTab-$80,y    ; 4 =~93    (2.5 bits/strip)

;*** load pattern-index: ***
; x = number of free pattern-1
    ldy     #-1                 ; 2
.loopFind:
    iny                         ; 2
    lda     PatternTab,y        ; 4
    and     curStripPat         ; 3
    bne     .loopFind           ; 2³
    dex                         ; 2
    bpl     .loopFind           ; 2³=~85    (6th entry, 50% free)

; y = index of pattern
.onePattern:                    ;           a,x,y=0!
    ldx     rowColIdx           ; 3
    tya                         ; 2
    sta     gridLst,x           ; 4         save pattern of current rowcol
    beq     .emptyPattern       ; 2³= 11

;*** set bits in crossing stripes: ***
    lda     PatternTab,y        ; 4
    ldy     MaskTab,x           ; 4         negative value expected
    bmi     .setColumns         ; 2³         row? yes, set columns
    ldy     MaskTab-GRIDSIZE,x  ; 4
    ldx     #GRIDSIZE           ; 2          no, set rows
    BIT_W                       ; 2         skip next instruction
.setColumns:
    ldx     #GRIDSIZE*2         ; 2
.loopSet:
    dex                         ; 2
    lsr                         ; 2
    bcc     .loopSet            ; 2³
    pha                         ; 3
    tya                         ; 2
    ora     stripPat,x          ; 4
    sta     stripPat,x          ; 4
    pla                         ; 4
    bne     .loopSet            ; 2³=~81    (4 bits, 50% free)

;*** continue with next stripe: ***
    ldx     rowColIdx           ; 3
.emptyPattern:
    ldy     RowColTab,x         ; 4
    bpl     .loopStrips         ; 2³= 9/10
    rts

;*** load next value: ***
.loadValue:
    pha                         ; 3         load next shift value
    ldy     valueIdx            ; 3
    lda     (valuePtr),y        ; 5/6
    rol                         ; 2         C=1!
    sta     shift               ; 3
    pla                         ; 4
    inc     valueIdx            ; 5 (~7.5)  overflow not possible!
    bne     .contValue          ; 2³
    inc     valuePtr+1          ; 5
    bne     .contValue          ; 3
;DecodeCard END

;===============================================================================
; R O M - T A B L E S
;===============================================================================

RowColTab:                      ; EXITROW,5,3,0,4,1
    .byte   0+GRIDSIZE,1+GRIDSIZE
    .byte   EXITROW+GRIDSIZE,3+GRIDSIZE
    .byte   4+GRIDSIZE,5+GRIDSIZE
    .byte   4,-1
    .byte   5,0
    .byte   1,3

SizeTab:
    .byte   2-1,(4-1)^(2-1),(7-1)^(4-1),(8-1)^(7-1),(13-1)^(8-1)

OffsetTab:
    .byte  26+5,23+4,18+3,13+2,7+1                              ; 0,..,27+6

SubTab:
    .byte    0+$7f,$0,1,1,7,2,5,6                               ; 22 (3..7)
    .byte   22+$7f,$0,2,2,1,4,4                                 ; 13 (2..6)
    .byte   35+$7f,$0,2,3,1,2                                   ;  8 (2..5)
    .byte   43+$7f,1,1,1,$0,4                                   ;  7 (1..3,5)
    .byte   50+$7f,1,1,2                                        ;  4 (1..3)
    .byte   54+$7f,2                                            ;  2 (1)
    .byte   56+$7f,1,1,2                                        ;  4 (1..3) exit strip

MaskTab:
    .byte   $80|$20,$80|$10,$80|$08,$80|$04,$80|$02,$80|$01
; the next 6 values MUST be positive!

FreeIdxTab:
    .byte   0 ,10 ,2,5,6,7,9,11,12 ,4,8 ,1,3,13,15,17 ,14,16,18,19,20,21; 22
    .byte   6,8 ,5,7 ,4 ,0,3,9,11 ,1,2,10,12                            ; 13
    .byte   1,4 ,2,3,6 ,5 ,0,7                                          ; 8
    .byte   4 ,5 ,3  ,0,1,2,6                                           ; 7
    .byte   2 ,1 ,0,3                                                   ; 4
    .byte   0,1                                                         ; 2
    .byte   1, 9, 4,3                                                   ; 4 <- immer manuell anpassen!

PatternTab:
    .byte   %000000,%110000,%000011,%000110
    .byte   %011000,%111000,%000111,%011100
    .byte   %001110,%001100
Pattern2Tab:
    .byte   %001111, %011110
    .byte   %111100, %110011, %110110, %011011
    .byte   %111110, %011111, %111110, %011111          ; 23,23,32,32
    .byte   %111011, %110111                            ; 32,23

; format: 1-3?-yyy-xxx
CarTab:
    .byte              %10100000, %10000100, %10001011
    .byte   %10011001, %11011000, %11000011, %11010001
    .byte   %11001010, %10010010

    .byte   %10010010, %10011001
    .byte   %10100000, %10100000, %10100000, %10011001
    .byte   %10100000, %10011001, %11011000, %11010001
    .byte   %11011000, %10100000

CarTab2:
    .byte   %10000100, %10001011
    .byte   %10010010, %10000100, %10001011, %10000100
    .byte   %11001010, %11000011, %10001011, %10000100
    .byte   %10000100, %11000011
CarTab2End:

LevelTabLo:
    .byte   <Level0,<Level1,<Level2,<Level3,<Level4,<Level5
LevelTabHi:
    .byte   >Level0,>Level1,>Level2,>Level3,>Level4,>Level5

; tables to define moves:
MovesOffsetTab:
    .byte   <LevelMoves0 -LevelMovesTab
    .byte   <LevelMoves14-LevelMovesTab, <LevelMoves14-LevelMovesTab
    .byte   <LevelMoves14-LevelMovesTab, <LevelMoves14-LevelMovesTab
    .byte   <LevelMoves5 -LevelMovesTab
MinMovesTab:
    .byte   $07, $18, $23, $28, $33, $38

LevelMovesTab:
LevelMoves0:
    .byte   $5,$10,$16,$23,$31,$40,$50,$61,$73,$86,-1
LevelMoves14:
    .byte   $20,$40,$60,$80,-1
LevelMoves5:
    .byte   $19,$37,$49,$63,$75,$81,$86,$90,$93,$96,$97,$98,$99,-1

Level0:
    .byte   %01010000, %01101000                                    ; (23) 7
    .byte   %00010100, %01011000, %00010011, %10110100              ; (25) 7
    .byte   %10000000, %11011110, %01000001                         ; (25) 7
    .byte   %00000000, %00000001, %01011101                         ; (26) 7
    .byte   %11010111, %10000001, %01010000                         ; (28) 7
    .byte   %00011101, %11101100, %10010000, %01110000              ; (26) 8
    .byte   %01100000, %00000100, %10010100                         ; (26) 8
    .byte   %11011010, %10001010, %00000011                         ; (28) 8
    .byte   %00001101, %11101110, %00010110, %00011000              ; (26) 8
    .byte   %00100100, %00100000, %11001100                         ; (27) 8
    .byte   %10001101, %01000000, %00000101                         ; (26) 9
    .byte   %10011001, %01100000, %10110110, %10110100              ; (26) 9
    .byte   %10000111, %00000001, %01000101                         ; (26) 9
    .byte   %01101111, %00010011, %01000001                         ; (27) 9
    .byte   %10000000, %00001100, %01011110                         ; (26) 9
    .byte   %01010000, %11000001, %10100000, %10000011              ; (28) 9
    .byte   %00010100, %01000000, %00011001                         ; (24) 10
    .byte   %00000000, %00100111, %01000001                         ; (26) 10
    .byte   %00010100, %10000001, %00001100, %10110110              ; (27) 10
    .byte   %00001011, %00010000, %00000011                         ; (27) 10
    .byte   %11010101, %01010111, %01100000                         ; (27) 10
    .byte   %11000001, %00100000, %10010001, %10010110              ; (27) 10
    .byte   %01000000, %00010101, %00101010                         ; (26) 10
    .byte   %11010011, %00000000, %00101111                         ; (23) 11
    .byte   %11110000, %00011000, %11110000                         ; (25) 11
    .byte   %10110110, %00001101, %10100010                         ; (25) 11
    .byte   %11011101, %00011000, %00000001                         ; (25) 11
    .byte   %11000111, %01101000, %00100001                         ; (25) 11
    .byte   %00000110, %10111011, %00001000, %00100110              ; (26) 11
    .byte   %11001100, %00011000, %00011101                         ; (26) 11
    .byte   %10110001, %11000000, %00100010                         ; (28) 11
    .byte   %00000111, %01000110, %11000000                         ; (24) 12
    .byte   %00100010, %01100000, %01110010                         ; (24) 12
    .byte   %00101001, %11100100, %01001101                         ; (25) 12
    .byte   %00101100, %01000000, %10101010, %11101011              ; (25) 12
    .byte   %10000010, %01001100, %10001101                         ; (26) 12
    .byte   %10010110, %11000010, %00001111                         ; (26) 12
    .byte   %01010101, %00110011, %10000000                         ; (27) 12
    .byte   %00100000, %10100000, %00001010, %00111110              ; (27) 12
    .byte   %01110100, %01100110, %11010000                         ; (26) 12
    .byte   %00001010, %10010011, %11000010                         ; (23) 13
    .byte   %00010110, %00000011, %01011001                         ; (24) 13
    .byte   %00010000, %01000000, %00000010                         ; (23) 13
    .byte   %00110100, %00000010, %00000010                         ; (24) 13
    .byte   %00001010, %00000010, %00011000                         ; (23) 13
    .byte   %01000000, %00110010, %11001000                         ; (25) 13
    .byte   %10100110, %00000010, %00000001                         ; (24) 13
    .byte   %11100000, %00110010, %00100010                         ; (24) 13
    .byte   %01101100, %00010001, %01001100                         ; (24) 13
    .byte   %10001100, %10011000, %00000000                         ; (25) 13
    .byte   %11001100, %00001101, %10101000                         ; (22) 14
    .byte   %11010100, %00000010, %11010100                         ; (24) 14
    .byte   %01010000, %00001000, %00110111                         ; (25) 14
    .byte   %00010010, %00001100, %10010001                         ; (24) 14
    .byte   %00110100, %01001000, %00000011                         ; (24) 14
    .byte   %00001001, %00001000, %00110001                         ; (24) 14
    .byte   %10101000, %10000110, %00011010                         ; (24) 14
    .byte   %10100000, %00110001, %11011011                         ; (26) 14
    .byte   %00000110, %00010000, %10010001                         ; (23) 14
    .byte   %10101010, %00100011, %00000000                         ; (27) 14
    .byte   %00101010, %10100000, %01010001                         ; (25) 14
    .byte   %00111010, %01010001, %10000011                         ; (24) 15
    .byte   %01010000, %01100100, %01101000                         ; (23) 15
    .byte   %10001011, %00000101, %11000000                         ; (24) 15
    .byte   %00000000, %10110100, %00000001                         ; (23) 15
    .byte   %10011110, %11100000, %10110000                         ; (24) 15
    .byte   %00100100, %00110010, %01110101                         ; (24) 15
    .byte   %10000100, %00010010, %10010010                         ; (25) 15
    .byte   %01010100, %11010000, %01110000                         ; (23) 15
    .byte   %10100101, %01000000, %00001111                         ; (25) 15
    .byte   %01100011, %01010000, %00000001, %01011110              ; (26) 15
    .byte   %10000010, %00001101, %00000111                         ; (25) 15
    .byte   %10010101, %10000000, %00111110                         ; (24) 15
    .byte   %01001001, %00100001, %10100000                         ; (23) 16
    .byte   %00111001, %00000000, %00000001                         ; (24) 16
    .byte   %10000110, %00000010                                    ; (23) 16
    .byte   %01101101, %10101000, %00010110                         ; (24) 16
    .byte   %00100000, %10101101, %10011100                         ; (24) 16
    .byte   %00000000, %10100010, %00010000                         ; (24) 16
    .byte   %10110101, %01000101, %01110000, %11001100              ; (26) 16
    .byte   %10101000, %00110010, %11011011                         ; (25) 16
    .byte   %00110001, %10100001, %00100000                         ; (26) 16
    .byte   %10000101, %00000101, %11000000                         ; (25) 16
    .byte   %11011001, %10000010, %01011000                         ; (26) 16
    .byte   %10011000, %11000000, %00000001, %01001100              ; (27) 16
    .byte   %11010100, %00011010, %00000011                         ; (24) 16
    .byte   %01001001, %00000000                                    ; (20) 17
    .byte   %01100001, %10000001, %01110101                         ; (24) 17
    .byte   %01000111, %10111011, %00001111                         ; (24) 17
    .byte   %00001001, %00100000, %11110101                         ; (24) 17
    .byte   %11000010, %10100000, %00010001                         ; (24) 17
    .byte   %01000100, %10111000, %01100010                         ; (24) 17
    .byte   %01100000, %10100011, %10000001, %01000110              ; (26) 17
    .byte   %00110001, %00101110                                    ; (23) 17
    .byte   %00010101, %01001101, %00010000, %00000000              ; (26) 17
    .byte   %01010100, %10110101, %00001000                         ; (24) 17
    .byte   %10101001, %10000100, %00001110                         ; (24) 17
    .byte   %00101100, %01110100, %00010010                         ; (24) 17
    .byte   %01010011, %00000110, %00101100                         ; (26) 17
    .byte   %00001001, %00010000, %10100100                         ; (25) 17
    .byte   %10000000                                               ; (flushed:4)

Level1:
    .byte   %10010010, %01000001                                    ; (20) 18
    .byte   %10000110, %00000110, %11010100                         ; (23) 18
    .byte   %00110000, %10000000, %10010011                         ; (22) 18
    .byte   %10010001, %10001000, %01100001                         ; (24) 18
    .byte   %01010011, %00000110, %00001000                         ; (24) 18
    .byte   %01100000, %00110000, %01000100                         ; (24) 18
    .byte   %01011101, %00001000, %01000000                         ; (24) 18
    .byte   %00101100, %10101010, %11000100                         ; (24) 18
    .byte   %00101000, %10000100, %01010110                         ; (24) 18
    .byte   %00101000, %01010000, %01000100                         ; (25) 18
    .byte   %10101000, %00000000, %10011011                         ; (25) 18
    .byte   %01000010, %00001101, %10000010                         ; (26) 18
    .byte   %00000010, %10000010, %11100011                         ; (24) 18
    .byte   %00011010, %11000011, %00001110                         ; (23) 18
    .byte   %10000010, %00101011, %11010010                         ; (25) 18
    .byte   %11100100, %00010010, %01101010                         ; (26) 18
    .byte   %00101101, %10101000, %11000100, %10001000              ; (26) 18
    .byte   %00011001, %00100000, %01000100                         ; (26) 18
    .byte   %11001010, %00000101, %11000100                         ; (27) 18
    .byte   %11011000, %10000000, %00101000, %11111010              ; (27) 18
    .byte   %11000010, %00001000                                    ; (20) 19
    .byte   %01111110, %10010100, %01110100                         ; (25) 19
    .byte   %01000001, %10000100, %00100100                         ; (24) 19
    .byte   %01100101, %00100011, %10100000                         ; (25) 19
    .byte   %10011001, %01010000, %00101010, %01001100              ; (26) 19
    .byte   %11010000, %00011001, %00010010                         ; (26) 19
    .byte   %11011000, %00100000, %10101000                         ; (26) 19
    .byte   %10111010, %10000011, %01100010                         ; (25) 19
    .byte   %01101100, %10101000, %01010000                         ; (25) 19
    .byte   %11110010, %10010000, %01110101, %01010000              ; (26) 19
    .byte   %11000110, %10001010, %01000010                         ; (28) 19
    .byte   %00000001, %10000001, %01010001, %11111100              ; (27) 19
    .byte   %01010101, %00011000, %00101011                         ; (27) 19
    .byte   %11011010, %10000001, %10010001                         ; (27) 19
    .byte   %10101001, %01100101, %11001000, %10000110              ; (26) 19
    .byte   %01001001, %10000011, %11101001                         ; (28) 19
    .byte   %10000101, %00001010, %01100001                         ; (26) 19
    .byte   %00010111, %01010000, %00001000, %01010110              ; (28) 19
    .byte   %10010100, %01011101, %01100111                         ; (26) 19
    .byte   %10010101, %10000111, %01000100, %11011000              ; (29) 19
    .byte   %00010100, %01100000                                    ; (22) 20
    .byte   %00100010, %10010110, %00000010                         ; (23) 20
    .byte   %01100001, %01000110, %01000010                         ; (24) 20
    .byte   %01100001, %01100100, %11111100                         ; (24) 20
    .byte   %00100011, %01100010, %11111011                         ; (25) 20
    .byte   %00011001, %01010111, %10000000, %01010110              ; (25) 20
    .byte   %11001101, %00000000, %10000000                         ; (25) 20
    .byte   %00011000, %00110101, %00000100                         ; (25) 20
    .byte   %00001011, %10000111, %01001000                         ; (24) 20
    .byte   %00100000, %10010100, %01101011                         ; (26) 20
    .byte   %00011010, %00000101, %00001101                         ; (27) 20
    .byte   %00010010, %10100000, %01100111, %11000010              ; (27) 20
    .byte   %00100000, %00110011, %01001100                         ; (27) 20
    .byte   %00100010, %01101010, %01100100                         ; (25) 20
    .byte   %00000001, %01000010, %00110000                         ; (25) 20
    .byte   %00111101, %01010100, %11011000, %10001000              ; (26) 20
    .byte   %00110100, %00010110, %00100011                         ; (26) 20
    .byte   %10011001, %10100000, %10011110                         ; (27) 20
    .byte   %00110010, %00000000, %11110100, %00100101              ; (31) 20
    .byte   %10010010, %10000110, %00010001, %01110001              ; (28) 20
    .byte   %01010100, %00000011, %00101000                         ; (23) 21
    .byte   %01010011, %00001100                                    ; (23) 21
    .byte   %01101011, %10000100, %00100100                         ; (22) 21
    .byte   %00100101, %10000000, %10100001                         ; (24) 21
    .byte   %01110100, %00111100, %00111100                         ; (23) 21
    .byte   %00010011, %00000101, %10111001                         ; (25) 21
    .byte   %11000110, %01011110, %10000000                         ; (25) 21
    .byte   %01100010, %11001000, %10110000                         ; (23) 21
    .byte   %01000010, %10000100, %10011000                         ; (23) 21
    .byte   %10100011, %00000110, %00010010                         ; (23) 21
    .byte   %10111011, %01011000, %00000001                         ; (23) 21
    .byte   %00010110, %01000101, %00100010                         ; (24) 21
    .byte   %00010110, %01100111, %10101010                         ; (25) 21
    .byte   %00011001, %10100010, %11001010                         ; (27) 21
    .byte   %01011001, %01000001, %01100000                         ; (24) 21
    .byte   %00101001, %10000101, %11010000                         ; (24) 21
    .byte   %01100010, %11001110, %01000101, %00000110              ; (28) 21
    .byte   %10011000, %01000010, %00010101                         ; (23) 21
    .byte   %01100000, %00001011, %01101011                         ; (28) 21
    .byte   %10101001, %01000011, %11100010                         ; (25) 21
    .byte   %01100010, %10101110, %00001000                         ; (21) 22
    .byte   %00000101, %00100000, %10000010                         ; (23) 22
    .byte   %10101100, %11100101, %00000010                         ; (23) 22
    .byte   %00100100, %01000001, %01101000                         ; (23) 22
    .byte   %01001011, %00101100, %01001001                         ; (24) 22
    .byte   %00100100, %01010000                                    ; (21) 22
    .byte   %11100100, %00111000, %00100010                         ; (25) 22
    .byte   %11001010, %01001001, %00000011                         ; (25) 22
    .byte   %10011101, %01101011, %00000001, %10011001              ; (25) 22
    .byte   %01001001, %10001000, %00001100                         ; (25) 22
    .byte   %01000000, %01001010, %01101110                         ; (26) 22
    .byte   %01011010, %00000110, %10101000                         ; (26) 22
    .byte   %01000110, %10110110, %00001000                         ; (24) 22
    .byte   %10000010, %01110000, %10000000, %01001010              ; (27) 22
    .byte   %01010001, %00100010, %00001001                         ; (26) 22
    .byte   %10011011, %10010100, %00010001                         ; (27) 22
    .byte   %00010110, %00000011, %01101100, %00011001              ; (29) 22
    .byte   %10010110, %00001101, %10011111, %01011000              ; (30) 22
    .byte   %10001000, %11010011, %10000100                         ; (26) 22
    .byte   %00101010, %01000100, %00111001                         ; (28) 22
    .byte   %10110000                                               ; (flushed:6)

Level2:
    .byte   %10010010, %01000000, %11100110                         ; (24) 23
    .byte   %00101001, %11001000, %00010100                         ; (25) 23
    .byte   %01010100, %10001000, %01001100                         ; (24) 23
    .byte   %01000010, %00011010, %11000100                         ; (23) 23
    .byte   %01001011, %00101110, %10010010                         ; (26) 23
    .byte   %00010100, %01011000, %01010110                         ; (26) 23
    .byte   %01101000, %00100100, %00000100                         ; (26) 23
    .byte   %01110001, %01000100, %00100000                         ; (25) 23
    .byte   %01110101, %01101101, %11111000, %00100010              ; (27) 23
    .byte   %00011000, %01011101, %00000110                         ; (26) 23
    .byte   %11000110, %11110010, %00000000                         ; (27) 23
    .byte   %10010001, %00010001, %10110111, %00001000              ; (26) 23
    .byte   %00101000, %10000111, %01001101                         ; (25) 23
    .byte   %01101100, %11100101, %00010110                         ; (27) 23
    .byte   %01110100, %01110000, %01001000                         ; (25) 23
    .byte   %01000101, %10000111, %00101000, %10111100              ; (28) 23
    .byte   %10010110, %01000010, %11001100                         ; (27) 23
    .byte   %11000001, %11001000, %00101100, %11110010              ; (29) 23
    .byte   %00100000, %00011001, %01110001                         ; (28) 23
    .byte   %01110010, %00001010, %10001011, %10111001              ; (27) 23
    .byte   %00011000, %00110000, %11010101                         ; (23) 24
    .byte   %00101000, %00111010, %00000011                         ; (25) 24
    .byte   %11011000, %10001111, %00010110                         ; (24) 24
    .byte   %11101011, %01110101, %00100010                         ; (25) 24
    .byte   %01011000, %10011100, %00001110                         ; (25) 24
    .byte   %10010101, %01111010, %10011010                         ; (25) 24
    .byte   %00000100, %10100010, %01000111                         ; (25) 24
    .byte   %01101101, %01010011, %01010001                         ; (23) 24
    .byte   %00100101, %00000010, %01010001                         ; (26) 24
    .byte   %01110011, %01000000, %11010101, %10001101              ; (26) 24
    .byte   %11110110, %00111100, %11000000                         ; (28) 24
    .byte   %01011101, %01000110, %00110011                         ; (27) 24
    .byte   %00100000, %10111101, %10011011, %11011000              ; (27) 24
    .byte   %10010011, %11011010, %11000100                         ; (26) 24
    .byte   %10000100, %10001110, %11001011                         ; (27) 24
    .byte   %01000011, %11101001, %11100110, %01000100              ; (27) 24
    .byte   %10010100, %00010010, %01010001                         ; (28) 24
    .byte   %00110001, %01100110, %00100001, %00101011              ; (27) 24
    .byte   %01101000, %00110110, %10101000                         ; (28) 24
    .byte   %01100011, %00000010, %11100010                         ; (23) 24
    .byte   %00101011, %01011000, %01111000                         ; (24) 25
    .byte   %10111011, %00111100, %00000001                         ; (22) 25
    .byte   %00110001, %00000000, %01000100                         ; (23) 25
    .byte   %00011000, %10100101, %10001111                         ; (25) 25
    .byte   %10101010, %00111001, %10001000                         ; (23) 25
    .byte   %01100001, %11100001, %11001010                         ; (25) 25
    .byte   %00010011, %10001001, %01000000                         ; (25) 25
    .byte   %11000110, %00001010, %01110000                         ; (25) 25
    .byte   %11101100, %11100001, %01100100                         ; (26) 25
    .byte   %01011010, %11101111, %01001010, %01000110              ; (26) 25
    .byte   %01101010, %11000001, %01000010                         ; (26) 25
    .byte   %10010110, %01100111, %00111110                         ; (26) 25
    .byte   %10001010, %10111000, %00110011                         ; (26) 25
    .byte   %11001011, %00000001, %10000010, %11101100              ; (26) 25
    .byte   %00111101, %10111011, %00101000                         ; (27) 25
    .byte   %00001100, %00100001, %00100001                         ; (25) 25
    .byte   %11010011, %00010111, %11000011                         ; (25) 25
    .byte   %01000010, %10011110, %11010000, %11011101              ; (28) 25
    .byte   %01100000, %00010011, %00010110                         ; (28) 25
    .byte   %01100010, %11110111, %00010000, %00110110              ; (28) 25
    .byte   %00100111, %00010000, %00110100                         ; (25) 26
    .byte   %00001000, %01100101, %10110010                         ; (24) 26
    .byte   %01001000, %10011110, %01001010                         ; (23) 26
    .byte   %10101001, %11100001, %00001111                         ; (26) 26
    .byte   %01001001, %01001100, %00001110                         ; (25) 26
    .byte   %10010101, %00000100, %11000100                         ; (26) 26
    .byte   %10011010, %01000111, %10100000                         ; (25) 26
    .byte   %10011101, %01010100, %11010000, %11010011              ; (25) 26
    .byte   %01010100, %01100100, %01010001                         ; (26) 26
    .byte   %00101000, %01000011, %01000011                         ; (26) 26
    .byte   %11000111, %01100110, %00001001                         ; (26) 26
    .byte   %01100011, %01010011, %00100000, %01010110              ; (28) 26
    .byte   %10011010, %00110001, %10100101                         ; (27) 26
    .byte   %01010101, %10011110, %10000110                         ; (26) 26
    .byte   %10111101, %11110110, %01001100, %00000101              ; (26) 26
    .byte   %00100110, %11100000, %00101011                         ; (26) 26
    .byte   %00010110, %00110010, %00101011                         ; (24) 26
    .byte   %10001101, %00000100, %10110100, %01111100              ; (29) 26
    .byte   %11110110, %11101110, %01110000                         ; (26) 26
    .byte   %00010100, %11010111, %00100000, %10000110              ; (30) 26
    .byte   %10101101, %10000111, %10001001                         ; (24) 27
    .byte   %10111010, %01000100, %10001010                         ; (25) 27
    .byte   %10101111, %01100001, %00000000                         ; (24) 27
    .byte   %00101000, %01011101, %10010001                         ; (25) 27
    .byte   %10101000, %10110111, %00100110                         ; (25) 27
    .byte   %00010000, %01100100, %01000101                         ; (25) 27
    .byte   %00101101, %10101110, %00000100                         ; (24) 27
    .byte   %01000011, %01011000, %10000100                         ; (26) 27
    .byte   %00001011, %10100010, %11110001, %10100011              ; (28) 27
    .byte   %10110000, %00110100, %00110000                         ; (28) 27
    .byte   %10011011, %01001100, %01010010, %00010001              ; (27) 27
    .byte   %01110100, %11100100, %00000011                         ; (28) 27
    .byte   %01000010, %10001000, %01010100                         ; (26) 27
    .byte   %01001001, %00011100, %00010010, %10000100              ; (26) 27
    .byte   %11001100, %11000011, %00111100                         ; (29) 27
    .byte   %10110011, %00000110, %00011001, %01110011              ; (29) 27
    .byte   %11001110, %11000011, %01110110, %01001001              ; (29) 27
    .byte   %11000110, %00010100, %01110100                         ; (31) 27
    .byte   %01100000, %10100010, %00111001, %00101111              ; (29) 27
    .byte   %11001101, %00000011, %00100010, %10001101              ; (28) 27

Level3:
    .byte   %11011000, %11001110, %11010010                         ; (25) 28
    .byte   %00110101, %10011000, %10000010                         ; (24) 28
    .byte   %11000111, %01010010, %00000100                         ; (25) 28
    .byte   %01010111, %01001000, %10110101                         ; (25) 28
    .byte   %00001010, %00011101, %10000011                         ; (26) 28
    .byte   %11001010, %01110001, %00101000                         ; (26) 28
    .byte   %11010001, %10100000, %01101011, %00100010              ; (27) 28
    .byte   %01101110, %00100101, %01110010                         ; (26) 28
    .byte   %11010101, %01001011, %11000101                         ; (27) 28
    .byte   %00011001, %00111001, %11001110, %11001011              ; (27) 28
    .byte   %01100001, %11000110, %01011010                         ; (28) 28
    .byte   %01111010, %00111000, %10101000, %10100100              ; (27) 28
    .byte   %10010010, %00111101, %00110110                         ; (27) 28
    .byte   %01100101, %01011000, %11010100, %01011101              ; (28) 28
    .byte   %10000010, %01001111, %01110010                         ; (28) 28
    .byte   %01010010, %10100100, %00100100                         ; (27) 28
    .byte   %10101101, %11101101, %11011100, %11100001              ; (26) 28
    .byte   %01010011, %00001111, %11100111                         ; (27) 28
    .byte   %00001000, %10100101, %01010100, %10001101              ; (30) 28
    .byte   %10100000, %01011100, %11010110                         ; (29) 28
    .byte   %10001001, %01110001, %00001100                         ; (23) 29
    .byte   %00110010, %10101001, %10101100                         ; (23) 29
    .byte   %10010100, %10010010, %01000001                         ; (24) 29
    .byte   %00110101, %01010001, %01001000                         ; (22) 29
    .byte   %01001100, %00011010, %01000011                         ; (26) 29
    .byte   %01101110, %11011001, %00000011                         ; (26) 29
    .byte   %01001011, %01000100, %10010110, %11000100              ; (26) 29
    .byte   %00101111, %01110001, %01000001                         ; (26) 29
    .byte   %00001010, %11110100, %11101000                         ; (27) 29
    .byte   %00100010, %11011011, %11001001, %00011010              ; (26) 29
    .byte   %01101000, %11001000, %10000111                         ; (28) 29
    .byte   %11001111, %01110001, %10010000                         ; (27) 29
    .byte   %00000000, %11001011, %10000001, %10010100              ; (25) 29
    .byte   %11001001, %11101101, %01010001                         ; (28) 29
    .byte   %10000111, %01100101, %10000101, %10110011              ; (28) 29
    .byte   %10010111, %00000001, %00111010                         ; (27) 29
    .byte   %10101010, %00100101, %00111100                         ; (28) 29
    .byte   %00011001, %10101010, %10010010, %01001101              ; (28) 29
    .byte   %11000100, %00010110, %01101101                         ; (28) 29
    .byte   %11111010, %10100001, %10010110, %10011111              ; (29) 29
    .byte   %11000110, %00111010, %01000101                         ; (22) 30
    .byte   %01111010, %10101110, %01110000                         ; (25) 30
    .byte   %10011110, %10010001, %01001000                         ; (24) 30
    .byte   %11110101, %01110000, %01000011                         ; (25) 30
    .byte   %11100010, %00011001, %00011110                         ; (24) 30
    .byte   %11010101, %00001001, %00100111                         ; (25) 30
    .byte   %01010101, %01010101, %10101100                         ; (25) 30
    .byte   %10100001, %00110111, %00001001                         ; (25) 30
    .byte   %00110010, %11001110, %11000110, %00101100              ; (25) 30
    .byte   %10110011, %11111010, %00100010                         ; (26) 30
    .byte   %10011011, %01111000, %01100101                         ; (27) 30
    .byte   %00010110, %10101110, %11001010, %00110110              ; (28) 30
    .byte   %01111101, %10010101, %11101111                         ; (29) 30
    .byte   %10010010, %10000101, %11011011, %11001101              ; (28) 30
    .byte   %10010101, %00111001, %10010000                         ; (28) 30
    .byte   %10001001, %01111011, %11101100, %00000001              ; (29) 30
    .byte   %10010001, %11010100, %10001111                         ; (28) 30
    .byte   %00010011, %11011101, %01001100, %00011110              ; (30) 30
    .byte   %00110111, %11110010, %10111100, %00000101              ; (31) 30
    .byte   %10101111, %10111101, %11001101, %00000101              ; (29) 30
    .byte   %00101011, %00110000, %00001100                         ; (23) 31
    .byte   %10010111, %10010011, %10100100                         ; (25) 31
    .byte   %00101000, %10000110, %00101101                         ; (26) 31
    .byte   %11110111, %00010010, %11010011                         ; (27) 31
    .byte   %11100100, %11000100, %00010101, %00101001              ; (27) 31
    .byte   %01011001, %11100100, %01101011                         ; (26) 31
    .byte   %11010111, %01000100, %00000111                         ; (27) 31
    .byte   %01101000, %11000110, %00101111, %11111101              ; (27) 31
    .byte   %01010111, %01110001, %01001111                         ; (27) 31
    .byte   %10001101, %01011100, %01010010, %11010110              ; (28) 31
    .byte   %00110101, %01010000, %10001100                         ; (28) 31
    .byte   %10100101, %00111100, %00111010                         ; (27) 31
    .byte   %01111010, %11110111, %10101000, %01110001              ; (29) 31
    .byte   %00100100, %00011110, %00011101, %01101100              ; (29) 31
    .byte   %00110100, %01011011, %00010001                         ; (29) 31
    .byte   %11100011, %00100110, %11001001, %01011110              ; (29) 31
    .byte   %10011000, %11000010, %00111100, %10010011              ; (30) 31
    .byte   %01111111, %00101011, %11000000, %10011000              ; (31) 31
    .byte   %10000110, %00100011, %00000111                         ; (29) 31
    .byte   %10110010, %10000000, %11001000, %10001111              ; (30) 31
    .byte   %10010101, %01111100, %10010000                         ; (23) 32
    .byte   %00100011, %10100010, %00101000                         ; (25) 32
    .byte   %00001011, %11110011, %10100010                         ; (26) 32
    .byte   %11000010, %10100110, %11000100                         ; (26) 32
    .byte   %01001011, %01011011, %01110011, %10010001              ; (25) 32
    .byte   %10110110, %10100011, %10011000                         ; (26) 32
    .byte   %00011100, %10000000, %10100010                         ; (26) 32
    .byte   %00001100, %01010010, %11100100                         ; (27) 32
    .byte   %10100000, %01110010, %00011110, %01011101              ; (28) 32
    .byte   %10001011, %11011011, %01000010                         ; (28) 32
    .byte   %01001101, %01011011, %00000010, %01001101              ; (27) 32
    .byte   %11010100, %00101010, %01000110                         ; (29) 32
    .byte   %01010000, %01111100, %10000001, %00011101              ; (29) 32
    .byte   %00101000, %00001001, %01110001                         ; (24) 32
    .byte   %00100100, %11101101, %10100011, %01110010              ; (29) 32
    .byte   %01101110, %00100001, %10101000                         ; (30) 32
    .byte   %11011010, %01110010, %00011000, %11011110              ; (29) 32
    .byte   %10010101, %00001111, %00101001, %00100110              ; (29) 32
    .byte   %01010110, %11000011, %11100100                         ; (24) 32
    .byte   %10110100, %01110000, %11010000, %10001101              ; (31) 32

Level4:
    .byte   %11001000, %10001001, %01011110                         ; (27) 33
    .byte   %10000110, %00110001, %01111111                         ; (25) 33
    .byte   %10100101, %11011111, %01010000, %00001000              ; (28) 33
    .byte   %10110110, %10100111, %10011001                         ; (27) 33
    .byte   %10001100, %11011011, %01000001                         ; (27) 33
    .byte   %10111111, %00011011, %01011100, %10010100              ; (28) 33
    .byte   %00010011, %11010110, %00110010                         ; (29) 33
    .byte   %10010011, %11011101, %01001100, %00011110              ; (29) 33
    .byte   %11100101, %11111101, %11101001, %01010100              ; (30) 33
    .byte   %10010011, %00011001, %00011011, %00011001              ; (30) 33
    .byte   %01101001, %11101101, %10001010                         ; (31) 33
    .byte   %11110001, %11111100, %10101111, %00000010              ; (32) 33
    .byte   %01100101, %10001111, %01001101, %00011110              ; (31) 33
    .byte   %00100001, %01011011, %11101010, %00001101              ; (29) 33
    .byte   %11000110, %00110011, %01110011, %00111111              ; (31) 33
    .byte   %00110011, %10100000, %11110011, %01011001              ; (33) 33
    .byte   %00101010, %00010010, %11111100, %01010011              ; (31) 33
    .byte   %10110101, %01111110, %00010110, %10110101              ; (32) 33
    .byte   %10110111, %00001101, %10101001, %01101011              ; (33) 33
    .byte   %11011010, %11111100, %11001001, %00100110              ; (31) 33
    .byte   %00100000, %10011000, %11000100                         ; (24) 34
    .byte   %10110010, %10000110, %11010101                         ; (26) 34
    .byte   %00000101, %00010000, %11101001                         ; (27) 34
    .byte   %01101111, %11110111, %10110111, %00101110              ; (30) 34
    .byte   %01010110, %10110110, %10101110, %00100101              ; (29) 34
    .byte   %10101000, %01110111, %01010100, %01101111              ; (30) 34
    .byte   %11011011, %10111011, %11011001                         ; (30) 34
    .byte   %00110100, %11010110, %00100001, %00111111              ; (30) 34
    .byte   %00100101, %01001010, %10100000, %11001010              ; (30) 34
    .byte   %00011011, %00011010, %01100110, %00000110              ; (30) 34
    .byte   %11010101, %11110001, %00000011                         ; (31) 34
    .byte   %11100101, %10101101, %10110001, %11001100              ; (29) 34
    .byte   %10010111, %00100000, %00101010, %10011111              ; (30) 34
    .byte   %00110101, %10110110, %00101100, %00100110              ; (31) 34
    .byte   %10101000, %01010110, %01000011                         ; (30) 34
    .byte   %11001101, %10100101, %00011101, %10000111, %00110110   ; (33) 34
    .byte   %00111111, %00010000, %11000101, %11011110              ; (33) 34
    .byte   %10011000, %01011011, %10011111, %00011100              ; (32) 34
    .byte   %11111110, %11001001, %11001011, %01011101              ; (34) 34
    .byte   %11001101, %11101011, %00010001, %11101011              ; (33) 34
    .byte   %10001101, %11001111, %01010010                         ; (26) 35
    .byte   %01100000, %11000100, %00010101, %00111101              ; (27) 35
    .byte   %01011101, %00011000, %00000011                         ; (25) 35
    .byte   %00101010, %11111001, %00110000                         ; (28) 35
    .byte   %11111000, %11000010, %10101110                         ; (25) 35
    .byte   %01011101, %00011100, %01100101, %00001001              ; (28) 35
    .byte   %11101110, %11011100, %01100110, %10101000              ; (30) 35
    .byte   %00101111, %01011000, %10000100                         ; (27) 35
    .byte   %11101010, %10101101, %00010010, %11110100              ; (30) 35
    .byte   %11011010, %00111001, %01011111, %10101000              ; (30) 35
    .byte   %01110010, %01100100, %10001000                         ; (26) 35
    .byte   %00001111, %10101001, %00100100, %11101000              ; (31) 35
    .byte   %00101010, %01011110, %01010100                         ; (30) 35
    .byte   %10011001, %10110110, %11011011, %10100000              ; (31) 35
    .byte   %01101001, %01101110, %11010010, %01110111              ; (31) 35
    .byte   %00010111, %11101100, %11001100, %01101100              ; (31) 35
    .byte   %11101100, %00001010, %11010110, %11101100              ; (32) 35
    .byte   %11010110, %11111011, %01001111, %10001101              ; (32) 35
    .byte   %10100011, %00001111, %11000010, %00101111              ; (30) 35
    .byte   %00001101, %11100001, %11101110, %00100001              ; (32) 35
    .byte   %10001100, %00111101, %11100001                         ; (27) 36
    .byte   %11100110, %10000010, %10110111, %01101100              ; (28) 36
    .byte   %01100011, %00110100, %00000100                         ; (28) 36
    .byte   %10100101, %01101110, %01100010, %01001111              ; (29) 36
    .byte   %11010100, %11101001, %00101011                         ; (27) 36
    .byte   %11010110, %01001111, %01100110, %10100011              ; (28) 36
    .byte   %00011000, %00101001, %01101111                         ; (28) 36
    .byte   %11110101, %01111110, %11001011, %11010101              ; (30) 36
    .byte   %00111001, %10101000, %11110111, %01100100              ; (29) 36
    .byte   %01010010, %01100011, %11101011                         ; (30) 36
    .byte   %11000110, %00111110, %11100011, %00011100              ; (31) 36
    .byte   %10111101, %00001100, %10001110, %00110110              ; (30) 36
    .byte   %10001101, %01011110, %01101101, %00001000              ; (30) 36
    .byte   %01111011, %11101101, %11000110, %10001111              ; (32) 36
    .byte   %00100111, %01101101, %11001111, %00101011              ; (33) 36
    .byte   %01001111, %01101010, %11100111, %11000111              ; (34) 36
    .byte   %10000110, %10001100, %10010011, %11110101              ; (32) 36
    .byte   %11000011, %00011110, %11110111, %10011111              ; (31) 36
    .byte   %01001011, %10111110, %11011111, %01101111              ; (32) 36
    .byte   %00001101, %00111111, %00001101, %00001111              ; (33) 36
    .byte   %01011000, %11100000, %10010111                         ; (27) 37
    .byte   %00100000, %01110111, %10000111, %10001000              ; (25) 37
    .byte   %10111000, %10011010, %01101011                         ; (30) 37
    .byte   %11011111, %00011001, %11101000, %11110101              ; (30) 37
    .byte   %00001000, %00100111, %01001001, %01010100              ; (31) 37
    .byte   %11001011, %11011111, %01010000, %10000110              ; (29) 37
    .byte   %00110101, %00100100, %10011100                         ; (31) 37
    .byte   %11110100, %10100111, %11110000, %11111111              ; (30) 37
    .byte   %01000111, %10111100, %01011010, %10111100              ; (32) 37
    .byte   %00110001, %11110101, %00001111, %01110011              ; (31) 37
    .byte   %01100110, %10110011, %10000110, %00011001              ; (31) 37
    .byte   %10111000, %00100001, %10101111, %10011101              ; (32) 37
    .byte   %00010101, %01110100, %01110001, %11110111              ; (32) 37
    .byte   %11011110, %11110110, %11111100, %11001010              ; (33) 37
    .byte   %11001100, %01000011, %10101000, %11111001              ; (33) 37
    .byte   %00100110, %10010110, %00111000, %11110001              ; (33) 37
    .byte   %01100011, %00011000, %11010100, %01110101, %01110000   ; (34) 37
    .byte   %00110111, %11001101, %11110001, %11101111              ; (33) 37
    .byte   %00110101, %00011100, %11011000, %10110110              ; (33) 37
    .byte   %00011010, %10111000, %10101111, %00001101              ; (35) 37
    .byte   %01011000                                               ; (flushed:5)

Level5:
    .byte   %00111110, %10100100, %10010011                         ; (30) 38
    .byte   %10101010, %11011110, %11111100, %10100111              ; (31) 38
    .byte   %01110101, %01010110, %00010111, %01111010              ; (30) 38
    .byte   %01101101, %11110110, %10011010, %01101101              ; (30) 38
    .byte   %00101010, %01010101, %11001000, %11001100              ; (32) 38
    .byte   %00011110, %11010101, %11001101, %01111000              ; (31) 38
    .byte   %11011011, %01111101, %01110100, %10001100              ; (32) 38
    .byte   %01010011, %11111000, %10011111, %01011001              ; (32) 38
    .byte   %11000110, %01000101, %00111010, %10111000              ; (33) 38
    .byte   %00101011, %01011001, %00100010, %10001110              ; (31) 38
    .byte   %01101011, %10001110, %01010111, %11111010              ; (33) 38
    .byte   %01101001, %01100011, %00011101, %10100110              ; (34) 38
    .byte   %11011111, %01010101, %01110011, %00101110              ; (35) 38
    .byte   %11110001, %10101001, %01010111, %00100010, %11100111   ; (35) 38
    .byte   %00110100, %11011100, %10010011, %11110101              ; (35) 38
    .byte   %11001101, %01111110, %11101100, %10111110, %11001110   ; (37) 38
    .byte   %01101000, %01110110, %11010101, %00101111              ; (36) 38
    .byte   %11111011, %01001111, %11100110, %11100011, %11101011   ; (39) 38
    .byte   %10000110, %10111000, %11101011, %10111101, %11111111   ; (40) 38
    .byte   %11001010, %01101000, %01110000                         ; (26) 39
    .byte   %11110001, %00111001, %10001100, %00100100              ; (27) 39
    .byte   %00100111, %01101101, %11001101                         ; (30) 39
    .byte   %10101100, %11011101, %11000001, %11100001              ; (31) 39
    .byte   %10010111, %00011001, %01111010, %00001011              ; (31) 39
    .byte   %10100011, %01110111, %10101000, %11011000              ; (30) 39
    .byte   %01000110, %00111010, %11101111, %00111110              ; (31) 39
    .byte   %10100011, %11101100, %11011111, %10111011              ; (34) 39
    .byte   %01011100, %01111100, %11011010, %01101111              ; (33) 39
    .byte   %00010011, %10011011, %01110001, %00100110              ; (28) 39
    .byte   %10101000, %11101110, %01010010, %00000011              ; (34) 39
    .byte   %11011000, %11100110, %00010011, %11100111              ; (34) 39
    .byte   %01000000, %11010011, %10101011, %11011111, %10101010   ; (36) 39
    .byte   %10111001, %01101110, %01001010, %11001111              ; (34) 39
    .byte   %10001101, %01111011, %11001101, %10110010              ; (34) 39
    .byte   %10010101, %00100111, %00100011, %10011001, %10111101   ; (38) 39
    .byte   %11011111, %01010010, %10100110, %11111010, %11110111   ; (41) 39
    .byte   %10110110, %10111101, %11111001, %01110111, %11010101   ; (42) 39
    .byte   %11010001, %11001110, %10000001, %00010000              ; (26) 40
    .byte   %11000011, %10001011, %01011010                         ; (27) 40
    .byte   %10110100, %11001010, %11001101, %00010111              ; (29) 40
    .byte   %00110101, %10101100, %01100010                         ; (30) 40
    .byte   %00011000, %11101111, %00001100, %10001101              ; (31) 40
    .byte   %11101010, %10110001, %00111111, %11110101              ; (30) 40
    .byte   %00011001, %01111011, %01010010, %01111110              ; (33) 40
    .byte   %10101101, %00101011, %00111101, %01001001              ; (32) 40
    .byte   %11101100, %01101101, %01111000, %00011101              ; (34) 40
    .byte   %01111001, %01010101, %00011101, %11100101, %10101001   ; (34) 40
    .byte   %11111101, %11000011, %10001111, %00000111              ; (36) 40
    .byte   %01101100, %01111100, %01011010, %10001001, %01110111   ; (38) 40
    .byte   %00010011, %00011001, %00011011                         ; (29) 41
    .byte   %00010010, %01101010, %11010010, %01001101              ; (29) 41
    .byte   %10101000, %11100010, %10100011                         ; (27) 41
    .byte   %10010011, %10101101, %10101011, %10001001              ; (27) 41
    .byte   %00101001, %01010110, %11111001, %11010011              ; (32) 41
    .byte   %00010101, %00101000, %11111001, %01010010              ; (30) 41
    .byte   %11001110, %01000111, %10111010                         ; (28) 41
    .byte   %01000011, %11110000, %11110001, %10000110              ; (30) 41
    .byte   %00001100, %00101010, %11010111                         ; (29) 41
    .byte   %11111101, %10101110, %11100001, %11100110              ; (32) 41
    .byte   %01001000, %01111111, %01101010, %10010110              ; (32) 41
    .byte   %11101001, %11101001, %01001001, %11110110, %01011101   ; (34) 41
    .byte   %00011000, %11001101, %10101000, %11111111              ; (34) 41
    .byte   %10111010, %11111100, %11001101, %01101111, %01111111   ; (44) 41
    .byte   %10111100, %10011100, %01001001, %11101000              ; (25) 42
    .byte   %11110111, %01101001, %11010001                         ; (29) 42
    .byte   %10110011, %01101111, %00101100, %10100001              ; (29) 42
    .byte   %10111101, %11101101, %11000001, %00111010              ; (31) 42
    .byte   %01000111, %01011010, %10010111                         ; (30) 42
    .byte   %00100001, %11111011, %00100111, %00101101              ; (32) 42
    .byte   %01110101, %11011001, %11101111, %00011101, %01011110   ; (35) 42
    .byte   %10011011, %01111011, %01000101, %01110111              ; (33) 42
    .byte   %01011011, %01101110, %00101010, %11001111              ; (35) 42
    .byte   %11110001, %10100111, %11001101, %10100010, %10011110   ; (34) 42
    .byte   %01110011, %10101001, %10010111, %00110011              ; (35) 42
    .byte   %00011010, %11111011, %11110011, %01011010, %00111111   ; (44) 42
    .byte   %11100100, %01101011, %00010000, %10010010              ; (28) 43
    .byte   %01000110, %11010011, %10001100, %01011100              ; (29) 43
    .byte   %01100110, %10010010, %01110111                         ; (31) 43
    .byte   %11101000, %01110010, %00011001, %11110111              ; (31) 43
    .byte   %01111001, %10011011, %11110010, %10101010              ; (33) 43
    .byte   %10110101, %11110101, %11100110, %00110011, %10101101   ; (37) 43
    .byte   %01101111, %01110111, %10010010                         ; (26) 44
    .byte   %10101010, %00001011, %11110001, %00011101              ; (29) 44
    .byte   %01001010, %01111000, %11110011, %11001001              ; (31) 44
    .byte   %11010101, %00111101, %11001010, %10001001              ; (33) 44
    .byte   %00010100, %00100111, %00101111, %11011110              ; (35) 44
    .byte   %11010101, %11011011, %11110011, %11000110              ; (29) 45
    .byte   %10010001, %11010111, %10110001, %11000000              ; (29) 45
    .byte   %01110011, %10101010, %10010100                         ; (30) 45
    .byte   %11000000, %11111101, %00010011, %01010110              ; (30) 45
    .byte   %11000111, %00110111, %10010010                         ; (26) 46
    .byte   %01000110, %10000011, %10100111, %11101010              ; (32) 46
    .byte   %11110111, %11110110, %11110111, %01101011, %11101110   ; (36) 46
    .byte   %00100011, %10101001, %00011001                         ; (25) 47
    .byte   %00101010, %00011011, %10110010                         ; (27) 47
    .byte   %00010011, %11101011, %11110000, %10110011              ; (33) 47
    .byte   %10111000, %01001000, %01000000                         ; (22) 48
    .byte   %00110101, %01010110, %00010111, %01011101              ; (28) 49
    .byte   %11101101, %11001100, %01110011, %00101100              ; (31) 50
    .byte   %11111101, %11101001, %11000101                         ; (31) 51
    .byte   %01110100                                               ; (flushed:7)


;---------------------------------------------------------------
  IF DEMO
    .byte   " JAMMED (Demo) - (c) 2001 Thomas Jentzsch "

    ORG     $ff00+16-20
  ELSE
    .byte   " JAMMED - (c) 2001 Thomas Jentzsch "

    ORG     $ff00+16-44
  ENDIF

;*** audio tables: ***
AudT0Tab:
    .byte   $10
    .byte   $14
  IF DEMO
    .byte   $12,$12,$09,$09,$09
  ELSE
    .byte   $12,$09,$09,$09,$09,$09,$09,$12,$12,$09,$09,$09,$12,$12,$09,$09,$09
  ENDIF
    .byte   $18,$0c,$0c
AudF0Tab:
    .byte   $0f
    .byte   $1f
  IF DEMO
    .byte   $87,$89,$8d,$8d,$0d
  ELSE
    .byte   $92,$90,$90,$8e,$8e,$8d,$8d,$87,$89,$8d,$8d,$8d,$87,$89,$8d,$8d,$0d
  ENDIF
    .byte   $90,$8d,$10

;AudT0Tab:
;    .byte   $10
;    .byte   $14
;    .byte   $12,$01,$12
;    .byte    $01,$09,$01,$09,$01,$09
;    .byte   $18,$06,$0c
;AudF0Tab:
;    .byte   $0f
;    .byte   $1f
;    .byte   $87,$80,$89
;    .byte    $80,$8d,$80,$8d,$80,$0d
;    .byte   $91,$80,$11
;AudVC0Tab:
;    .byte   $fc                             ; SOUND_CAR
;    .byte   $fc                             ; SOUND_TRUCK
;    .byte   $fc,$00,$fc                     ; SOUND_BEST
;    .byte    $00,$fc,$00,$fc,$00,$fc
;    .byte   $fc,$00,$fc                     ; SOUND_SOLVED

;16 free byte
;    .ds     16, -1

DigitColTab:    ;must be on same page as digit data!
    .byte   $1c,$3e,$4c,$6c,$8e,$ae,$be,$de
    .byte   $1c,$3e,$4c,$6c,$8e,$ae,$be,$de

NUMHEIGHT = 9
one:
    .byte   %11111111
    .byte   %11111011
    .byte   %11111011
    .byte   %11111011
seven:
    .byte   %11111111
    .byte   %11111011
    .byte   %11111011
    .byte   %11111011
four:
    .byte   %11111111
    .byte   %11111011
    .byte   %11111011
    .byte   %11111011
zero:
    .byte   %10000111
    .byte   %01111011
    .byte   %01111011
    .byte   %01111011
    .byte   %11111111
    .byte   %01111011
    .byte   %01111011
    .byte   %01111011
;    .byte   %10000111

three:
    .byte   %10000111
    .byte   %11111011
    .byte   %11111011
    .byte   %11111011
nine:
    .byte   %10000111
    .byte   %11111011
    .byte   %11111011
    .byte   %11111011
eight:
    .byte   %10000111
    .byte   %01111011
    .byte   %01111011
    .byte   %01111011
six:
    .byte   %10000111
    .byte   %01111011
    .byte   %01111011
    .byte   %01111011
two:
    .byte   %10000111
    .byte   %01111111
    .byte   %01111111
    .byte   %01111111
five:
    .byte   %10000111
    .byte   %11111011
    .byte   %11111011
    .byte   %11111011
    .byte   %10000111
    .byte   %01111111
    .byte   %01111111
    .byte   %01111111
    .byte   %10000111

NoMinusPat:
    .ds     NUMHEIGHT/2, 0
    .byte   0
MinusPat:
    .ds     NUMHEIGHT/2, 0
    .byte   2
    .ds     NUMHEIGHT/2, 0

DigitTab:
    .byte   #<zero-1,  #<one-1,   #<two-1,   #<three-1, #<four-1
    .byte   #<five-1,  #<six-1,   #<seven-1, #<eight-1, #<nine-1


;    PF0  |     PF1       |      PF2
;  4 5 6 7|7 6 5 4 3 2 1 0|0 1 2 3 4 5 6 7

;| PF1-L  | PF2_L  | PF2-R  | PF1-R  |
;|··X·XXX·|XXX·XXX·|XXX·XXX·|XXX·X···|

PFStartTab:
    .byte   0, NUMBLOCKS, NUMBLOCKS, NUMBLOCKS*2
    .byte   NUMBLOCKS*2                       ; used for CAR2 & Vert only
    .byte   NUMBLOCKS*3                       ; used for Vert only

HorzCar2Tab1:
    .byte   %00001111   ; PF1-L, PF2-L
    .byte   %01111111   ; PF2-L
    .byte   %11110000   ; PF2-L, PF2-R
    .byte   %11111110   ; PF2-R
    .byte   %00001111   ; PF2-R, PF1-R
HorzCar3Tab1:
    .byte   %00001111   ; PF1-L, PF2-L
    .byte   %11111111   ; PF2-L, PF2-R
    .byte   %11110000   ; PF2-L, PF2-R
    .byte   %11111111   ; PF2-R, PF1-R

VertCarTab:
    .byte   %00001110   ; PF1-L
    .byte   %00000111   ; PF2-L
    .byte   %01110000   ; PF2-L
    .byte   %11100000   ; PF2-R
    .byte   %00001110   ; PF2-R
;    .byte   %00000111   ; PF1-R

HorzCar2Tab2:
    .byte   %00000111
    .byte   0
    .byte   %11100000
    .byte   0
    .byte   %00000111
HorzCar3Tab2:
    .byte   %01111111
    .byte   %11100000
    .byte   %11111110
    .byte   %00000111

CarMoveTab:
    .byte   BW,0    ;,-BW
CurMoveTab:
    .byte   -BW,BW
    .byte   -#BH/2,#BH/2
CurStopTab:
    .byte   #GRIDSIZE-1,0
    .byte   0,#GRIDSIZE-1
CurTab:
    .byte   1,-2
    .byte   -2,1

;    ORG     $ff00 + OFFSETY - ARROWH*3+15
BlockSizeTab:
    .byte   CH*6+SH*5+Y0, CH*5+SH*5+Y0
    .byte   CH*5+SH*4+Y0, CH*4+SH*4+Y0, CH*4+SH*3+Y0, CH*3+SH*3+Y0
    .byte   CH*3+SH*2+Y0, CH*2+SH*2+Y0, CH*2+SH*1+Y0, CH*1+SH*1+Y0
    .byte   CH*1+SH*0+Y0

ARROWH  = 12    ;ArrowUpEnd - ArrowUp

ArrowUp:
    .byte   %00111000
    .byte   %01101100
    .byte   %01101100
    .byte   %11000110
    .byte   %11000110
    .byte   %10000010
    .byte   %10000010
    .byte   %11101110
    .byte   %11101110
    .byte   %01101100
    .byte   %01101100
;    .byte   %00011100
ArrowDown:
    .byte   %00111000
    .byte   %01101100
    .byte   %01101100
    .byte   %11101110
    .byte   %11101110
    .byte   %10000010
    .byte   %10000010
    .byte   %11000110
    .byte   %11000110
    .byte   %01101100
    .byte   %01101100
;    .byte   %00011100
ArrowLeft:
    .byte   %00111000
    .byte   %01111100
    .byte   %01101100
    .byte   %11101110
    .byte   %11001110
    .byte   %10000010
    .byte   %10000010
    .byte   %11001110
    .byte   %11101110
    .byte   %01101100
    .byte   %01111100
;    .byte   %00011100
ArrowRight:
    .byte   %00111000
    .byte   %01111100
    .byte   %01101100
    .byte   %11101110
    .byte   %11100110
    .byte   %10000010
    .byte   %10000010
    .byte   %11100110
    .byte   %11101110
    .byte   %01101100
    .byte   %01111100
;    .byte   %00011100
ArrowStop
    .byte   %00111000
    .byte   %01111100
    .byte   %01111100
    .byte   %11111110
    .byte   %11111110
    .byte   %10000010
    .byte   %10000010
    .byte   %11111110
    .byte   %11111110
    .byte   %01111100
    .byte   %01111100
    .byte   %00111000

CurPtrTab:  ; TODO: interleave with start vector
    .byte   <ArrowLeft+ARROWH, <ArrowDown+ARROWH, 0, 0, <ArrowRight+ARROWH, <ArrowUp+ARROWH

CurYTab:
    .byte   OFFSETY, [OFFSETY-BH], [OFFSETY-BH*2], [OFFSETY-BH*3], [OFFSETY-BH*4], [OFFSETY-BH*5]

;    ORG     $fff8-CH        ;ORG     $FF00 + BH*2 + Y0
CarPat:
    .byte   %0111110
    .byte   %1111111
    .byte   %1100111
    .byte   %0010011
    .byte   %1111001
    .byte   %1011010
    .byte   %1011011
    .byte   %1111011
    .byte   %1100011
    .byte   %1011011
    .byte   %1011011
    .byte   %1011011
    .byte   %1100011
    .byte   %1111011
    .byte   %1011011
    .byte   %1011010
    .byte   %1111001
    .byte   %0010011
    .byte   %1100111
    .byte   %1111111
    .byte   %0111110

;    .byte   %1111111
;    .byte   %0100111
;    .byte   %1011011
;    .byte   %1011001
;    .byte   %1011010
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011011
;    .byte   %1011010
;    .byte   %1011001
;    .byte   %1011011
;    .byte   %0100111
;    .byte   %1111111

;---------------------------------------------------------------
    ORG     $fff8
    .word   0               ; used by Supercharger!
    .word   0
    .word   InitVCS         ; start vector
    .word   0               ; brk vector
