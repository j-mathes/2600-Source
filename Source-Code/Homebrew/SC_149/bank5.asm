; -----------------------------------------------------------------------------
; Star Castle Arcade - Atari 2600
; Copyright (C) 2012 Chris Walton (cd-w) <cwalton@gmail.com>
; Copyright (C) 2013 Thomas Jentzsch <tjentzsch@yahoo.de>
; Bank 5 - Titles & Music
; -----------------------------------------------------------------------------

  START_BANK "BANK5"

Init5
  nop     BANK6             ; switch to bank 6
  ds      3, $ea
EndTitleMusic
  nop     BANK6             ; switch to bank 6
  jmp     TitleMusic        ; from bank 6
EndTitleScreen
  nop     BANK6             ; switch to bank 6
  jmp     ShowTitles        ; from bank 6
  ds      18, 0  
EndTestScreen               ; +30
  nop     BANK6             ; switch to bank 6
  jmp     TestScreen

; -----------------------------------------------------------------------------

  ; Title Screen Music
TitleMusic
  ; Handle Tempo
  inc TEMPOCOUNT
  lda TEMPOCOUNT
  eor #TEMPO_DELAY
  bne QuitTempo
  sta TEMPOCOUNT

  ; Handle Beat
  inc BEAT
  lda BEAT
  eor #32
  bne QuitTempo
  sta BEAT
  ; Increment Song Pointer
  inc MEASURE
QuitTempo

  ; Fetch Song Data (Channel 0)
  ldx #0
  ldy MEASURE
  lda song1,Y

  ; Check If End Of Song
  cmp #255
  bne ContinueSong

  ; Go Reset to Beginning
  stx MEASURE
  lda song1,X
ContinueSong

  ; Play Pattern
  jsr PlayPattern

  ; Fetch Song Data (Channel 1)
  ldy MEASURE
  lda song2,Y

  ; Set Channel
  ldx #1
  jsr PlayPattern
  jmp EndTitleMusic


; -----------------------------------------------------------------------------
; TITLE KERNEL
; -----------------------------------------------------------------------------

;  ALIGN_FREE 256

ShowTitles
  ; Get Title Message
  ldy MESSAGE
  bne SkipMessageFlash
  ; Flash "Fire To Play" Message
  lda CYCLE
  and #%00011000
  bne SkipMessageFlash
  ldy #3
SkipMessageFlash

  ; Set Number and Message Pointers (30Hz)
  sta WSYNC                 ; [0]
  lda CYCLE                 ; [0] + 3
  lsr                       ; [3] + 2
  bcs MessageBPointers      ; [5] + 2/3
  BRANCH_PAGE_ERROR MessageBPointers, "MessageBPointers"
MessageAPointers
  ldx MessagesLo_A,Y        ; [7] + 4
  lda MessagesHi_A,Y        ; [11] + 4
  bne EndMessagePointers    ; [15] + 3
  BRANCH_PAGE_ERROR EndMessagePointers, "EndMessagePointers"

MessageBPointers
  ldx MessagesLo_B,Y        ; [8] + 4
  lda MessagesHi_B,Y        ; [12] + 4
  nop                       ; [16] + 2
EndMessagePointers
  stx TPTR                  ; [18] + 3
  sta TPTR+1                ; [21] + 3

  ; Reflect Playfield
  lda #%0000001             ; [24] + 2
  sta CTRLPF                ; [26] + 3

  ; Clear Missiles
  lsr                       ; [29] + 2
  sta ENAM0                 ; [31] + 3
  sta ENAM1                 ; [34] + 3
  sta HMCLR                 ; [37] + 3

  ; Set Star Colours
  ldx COLMODE               ; [40] + 3
  lda StarCols5,X           ; [43] + 4
  sta COLUP1                ; [47] + 3

  ; Position Missile
  lda VOL0                  ; [50] + 3
  adc VOL1                  ; [53] + 3        1..31
  cmp VOL_NOW               ; [56] + 3

  sta RESM1                 ; [59] + 3    = 62

  bcs .overwrite
;  lda CYCLE
;  and #%1                 ; %111 == %11 for Nathan
;  bne .skipDecay
;  dec VOL_NOW
;.skipDecay
  lda VOL_NOW
  sbc #1-1                  ; [] + 2        CF == 0!
.overwrite
  sta VOL_NOW
  lsr                       ;               0..15
  ; Set Logo Foreground Colour
;  lsr                      ;                0..7
;  adc #0
;  tay
;  lda PulseLum,y
  ora LogoFGCols,X          ; [50] + 4
  sta LOGOFG                ; [54] + 3

  ; Set Logo Background Colour
  lda LogoBGCols,X
  sta LOGOBG

  ; Message Counter
  ldy #6-1                  ; [57] + 2
  lda (TPTR),Y
  sta PTR5
  dey

  ; Set Message Sprite Pointers
  ldx #10
.loadTitleLoop
  dex
  dex
  lda (TPTR),Y
  sta PTRLST,X
  lda TPTR+1
  sta PTRLST+1,X
  dey
  bpl .loadTitleLoop

; this saves 2 bytes in overlay!
  sta PTR5+1

; -----------------------------------------------------------------------------

  ; Begin Frame
WaitTitleVblank
  lda INTIM
  bne WaitTitleVblank
  sta VBLANK

  ; Display Top Stars
  ldx #14+EXTRA_LINES/2
  lda CYCLE
  lsr
  bcc TitleTopStarLoopB
TitleTopStarLoopA
  sta WSYNC                 ; [0]
  ; Draw Stars
  lda TitleTopStars_A,X     ; [0] + 4
  sta ENAM1                 ; [4] + 3
  sta HMM1                  ; [7] + 3
  lda #0                    ; [10] + 2
  ; Move Sprites
  sta WSYNC                 ; [0]
  sta HMOVE                 ; [0] + 3
  ; Clear Stars
  sta ENAM1                 ; [3] + 3
  dex                       ; [6] + 2
  bpl TitleTopStarLoopA     ; [8] + 2/3
  bmi EndTitleTopStars

TitleTopStarLoopB
  ; Move Sprites
  sta WSYNC                 ; [0]
  sta HMOVE                 ; [0] + 3
  ; Clear Stars
  lda #0                    ; [3] + 2
  sta ENAM1                 ; [5] + 3
  ; Load Star Data
  lda TitleTopStars_B,X     ; [8] + 4
  ; Draw Stars
  sta WSYNC                 ; [0]
  sta HMM1                  ; [3] + 3
  sta ENAM1                 ; [6] + 3
  dex                       ; [9] + 2
  bpl TitleTopStarLoopB     ; [11] + 2/3
EndTitleTopStars

  ; Show Logo
  sta WSYNC                 ; [0]
  jmp TitleKernel

; -----------------------------------------------------------------------------

BottomStars
  ; Clear Everything!
  sta WSYNC                 ; [0]
  lda #0                    ; [0] + 2
  sta GRP0                  ; [2] + 3
  sta GRP1                  ; [5] + 3
  sta GRP0                  ; [8] + 3
  sta ENAM0                 ; [11] + 3
  sta ENAM1                 ; [14] + 3
  sta COLUBK                ; [17] + 3
  sta COLUPF                ; [20] + 3
  sta NUSIZ0                ; [23] + 3
  sta NUSIZ1                ; [26] + 3
  sta VBLANK                ; [29] + 3
  sta HMCLR                 ; [32] + 3

  ; Draw Bottom Stars
  ldy COLMODE               ; [35] + 3
  ldx #17+EXTRA_LINES/2     ; [38] + 2
  lda CYCLE                 ; [40] + 3
  lsr                       ; [43] + 2
  bcs TitleBottomStarsB     ; [45] + 2/3
  BRANCH_PAGE_ERROR TitleBottomStarsB, "TitleBottomStarsB"

  lda StarCols5,Y           ; [47] + 4
  sta COLUP1                ; [51] + 3
  SLEEP 6                   ; [54] + 6
  sta RESM1                 ; [60] + 3 = 63

TitleBottomStarLoopA
  sta WSYNC                 ; [0]
  ; Draw Stars
  lda TitleBottomStars_A,X  ; [0] + 4
  sta ENAM1                 ; [4] + 3
  sta HMM1                  ; [7] + 3
  lda #0                    ; [10] + 2
  ; Move Sprites
  sta WSYNC                 ; [0]
  sta HMOVE                 ; [0] + 3
  ; Clear Stars
  sta ENAM1                 ; [3] + 3
  dex                       ; [14] + 2
  bpl TitleBottomStarLoopA  ; [16] + 2/3
  bmi EndTitleBottomStars

TitleBottomStarsB
  sta RESM1                 ; [48] + 3  = 51
  lda StarCols5,Y           ; [51] + 4
  sta COLUP1                ; [55] + 3

TitleBottomStarLoopB
  sta WSYNC                 ; [0]
  sta HMOVE                 ; [0] + 3
  ; Clear Stars
  lda #0                    ; [3] + 2
  sta ENAM1                 ; [5] + 3
  ; Load Star Data
  lda TitleBottomStars_B,X  ; [8] + 4
  ; Draw Stars
  sta WSYNC                 ; [0]
  sta HMM1                  ; [0] + 3    > 24
  sta ENAM1                 ; [3] + 3
  dex                       ; [6] + 2
  bpl TitleBottomStarLoopB  ; [8] + 2/3
EndTitleBottomStars
  jmp ShowTitleMessage

TestScreen SUBROUTINE

  ; Do Vertical Sync
  lda #%00001110
.vsyncLoop
  sta WSYNC
  sta VSYNC
  lsr
  bne .vsyncLoop

  ; Begin Frame
 IF NTSC_TIM
  ldx   #34
 ELSE
  ldx   #53
 ENDIF
.waitVblank
  dex
  sta   WSYNC
  bne   .waitVblank
  sta   VBLANK
  sta   GRP0
  sta   GRP1

  ldy   #180+EXTRA_LINES*2
.loopGreyScale
  sta   WSYNC           ; 3 = 6
;---------------------------------------
  lda   #$0e            ; 2
  sta   COLUBK          ; 3 = 5

  ldx   #3              ; 2
.wait
  dex                   ; 2
  bne   .wait           ; 2/3 = 16
  nop

  lda   #$0c            ; 2
  sta   COLUBK          ; 3
  nop                   ; 2
  lda   #$0a            ; 2
  sta   COLUBK          ; 3
  nop                   ; 2
  lda   #$08            ; 2
  sta   COLUBK          ; 3
  nop                   ; 2
  lda   #$06            ; 2
  sta   COLUBK          ; 3
  nop                   ; 2
  lda   #$04            ; 2
  sta   COLUBK          ; 3
  nop                   ; 2
  lda   #$02            ; 2
  sta   COLUBK          ; 3
  ldx   #$00            ; 2
  dey                   ; 2
  stx   COLUBK          ; 3 = 47
  bne   .loopGreyScale  ; 2/3

  ; Begin Overscan
  sta WSYNC
;---------------------------------------
  sta VBLANK
; End Frame
 IF NTSC_TIM
  ldx   #23
 ELSE
  ldx   #42
 ENDIF
.waitOverScan
  lsr   SWCHB           ;       RESET pressed?
  bcc   .exit
  dex
  sta   WSYNC
  bne   .waitOverScan
  beq   TestScreen

.exit
  jmp   EndTestScreen

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "ShowTitleMessage"

ShowTitleMessage
.textRow = TEMP2
  ; Hide Missile
  sta WSYNC
  inx
  stx ENAM1
  sta WSYNC

  ; Display Title Text
  ; Store Text Height
  ldy #10
  sty .textRow              ; [0] + 3

  sta WSYNC                 ; [0]

  ; 3 Copies Close
  lda #%00000011            ; [3] + 2
  sta NUSIZ0                ; [5] + 3
  sta NUSIZ1                ; [8] + 3

  ; Sprite Colours
  ldx COLMODE               ; [11] + 3
  lda TextCols,X            ; [14] + 4
  sta COLUP0                ; [18] + 3
  sta COLUP1                ; [21] + 3

  ; Delay Sprites
  lda #%00010001            ; [24] + 2
  sta VDELP0                ; [26] + 3
  sta VDELP1                ; [29] + 3

  ; Fine Positions
  sta HMCLR                 ; [32] + 3
  sta HMP1                  ; [35] + 3

  nop

  ; Position Sprites
  sta RESP0                 ; [38] + 3      = 41
  sta RESP1                 ; [41] + 3      = 44

  ; Load First Char
  lda (PTR0),Y              ; [44] + 5
  sta GRP0                  ; [49] + 3
  lda (PTR1),Y              ; [52] + 5

  ; Move Sprites
  sta WSYNC                 ; [0]
  sta HMOVE                 ; [0] + 3
  SLEEP 2                   ; [3] + 3
  jmp StartTitleText        ; [6] + 3

TitleTextLoop
  ; Fetch Current Line
  ldy .textRow              ; [63] + 3
  SLEEP 6                   ; [66] + 6
  ; Display First 3 Chars
  lda (PTR0),Y              ; [72] + 5
  sta GRP0                  ; [1] + 3       > 54
  lda (PTR1),Y              ; [4] + 5
StartTitleText
  sta GRP1                  ; [9] + 3       < 43
  lda (PTR2),Y              ; [12] + 5
  sta GRP0                  ; [17] + 3      < 46
  ; Pre-fetch Remaining 3 Chars
  lax (PTR3),Y              ; [20] + 5
  lda (PTR4),Y              ; [25] + 5
  sta TEMP                  ; [30] + 3
  lda (PTR5),Y              ; [33] + 5
  tay                       ; [38] + 2
  lda TEMP                  ; [40] + 3
  ; Display Remaining 3 Chars
  stx GRP1                  ; [43] + 3      > 45 < 48
  sta GRP0                  ; [46] + 3      > 48 < 51
  sty GRP1                  ; [49] + 3      > 50 < 54
  sta GRP0                  ; [52] + 3      > 53 < 56
  ; Update Counter
  dec .textRow              ; [55] + 5
  bpl TitleTextLoop         ; [60] + 2/3
  PAGE_ERROR TitleTextLoop, "TitleTextLoop"

  jmp ClearSprites

; -----------------------------------------------------------------------------
; MUSIC PLAYER (adapted from Paul Slocum's Music Kit 2.0)
; -----------------------------------------------------------------------------

PlayPattern
  ; Save Channel Number
  stx CHAN

  ; Save Pattern Data
  sta TEMP16L

  ; Extract patternArray Offset
  asl
  asl
  asl
  sta TEMP16H

  ; Use Beat To Determine Extra Offset Within patternArray
  lda BEAT
  and #%00011000
  lsr
  lsr

  ; Add Original Offset
  adc TEMP16H
  tax

  ; Check 32
  lda TEMP16L
  and #%00100000
  bne PlayPattern32

PlayPattern0
  ; Pattern offsets greater than 128 read from a different array and play lower
  lda TEMP16L
  bmi LowPattern0

  ; Loud Version
  ; Get Pattern Address
  lda patternArrayH,X
  ldy patternArrayH+1,X

  ; Set 0 Attenuation
  ldx #0
  beq EndGetPattern

LowPattern0
  ; Soft Version
  ; Get Pattern Address
  lda patternArrayL,X
  ldy patternArrayL+1,X

  ; Set -6 Attenuation
  ldx #2
  bne EndGetPattern

PlayPattern32
  lda TEMP16L
  bmi LowPattern32

  ; Loud version
  ; Get Pattern Address
  lda patternArrayH+256,X
  ldy patternArrayH+257,X

  ; Set 0 Attenuation
  ldx #0
  beq EndGetPattern

LowPattern32
  ; Soft Version
  ; Get address of selected pattern
  lda patternArrayL,X
  ldy patternArrayL+1,X

  ; Set -6 Attenuation
  ldx #4
  ; jmp endGetPattern

EndGetPattern
  sta TEMP16L
  sty TEMP16H
  stx ATTEN

  ; BEAT contains the 32nd note that the beat is currently on
  lda BEAT

  ; Modification for 1 Quarter Per Measure (Thrust)
  and #%00000111
  tay

  ; Get sound/note data
  lda (TEMP16L),Y
  eor #255
  beq MuteNote
  eor #255

; Each byte of pattern data contains the frequency and
; sound type data.  This function separates and decodes them.
; The encoding is: the 3 high bits contain the encoded sound
; type and the lower 5 bits contain the freq data.
; - ACC must contain pattern byte
; = ACC will return the freq
; = X will return the sound type

  ; Extract Frequency
  tax
  and #%00011111
  sta FREQ

  ; Extract Sound Type
  txa
  lsr
  lsr
  lsr
  lsr
  lsr
  tax

  ; Sound Type Attenuation
  lda ATTEN
  clc
  adc soundTurnArray,X
  sta ATTEN

  ; Get Sound Type
  lda soundTypeArray,X

  ; Get Channel
  ldx CHAN

  ; Play Sound!
  sta AUDC0,X
  lda FREQ
  sta AUDF0,X

  ; Restore Beat & #%111
  tya
  tax

; Each set of pattern data is followed by 4 accept bytes.
; Each bit in order represents the accent (on or off)
; of its corresponding 32nd note.  This function
; returns the attenuation of a note in a pattern.
; - TEMP16 must contain an indirect pointer to the pattern data
; - X must contain BEAT && %00000111
; = will return the volume in ACC

  ; Accent offset is always 8 for thrust mod
  ldy #8

  lda (TEMP16L),Y
  and BitMaskArray,X
  beq NoAccent

  ; It's an Accent, so don't attenuate
  lda #15

NoAccent
  ; No accent, so use a lower volume
  ora #13
  sbc ATTEN

MuteNote
  ldy CHAN
  sta AUDV0,Y
  sta VOL0,y

; Plays high hat sound on the first frame of each beat indicated in hatPattern
;  ldy CHAN
  tya
  beq NoHat

  ; Repeat high hat pattern
  lda MEASURE
  cmp #HATSTART
  bmi NoHat
  lda BEAT
  and #%00000111
  tax
  lda BEAT
  lsr
  lsr
  lsr
  tay
  lda hatPattern,Y
  and BitMaskArray,X
  beq NoHat

  ; Only Play On First Frame
  lda TEMPOCOUNT
  bne NoHat

  ; Play High Hat
  lda #HATPITCH
  sta AUDF1
  lda #HATSOUND
  sta AUDC1
  lda #HATVOLUME
  sta AUDV1
NoHat

  ; End Player
  rts

; -----------------------------------------------------------------------------
; TITLE LOGO
; -----------------------------------------------------------------------------

TitleKernel
  ; Blank Screen
  lda #2
  sta VBLANK
  sta WSYNC                 ; [0]

  ; Sprites 3 Copies Close & Missiles x8
  lda #%00110011            ; [0] + 2
  sta NUSIZ0                ; [2] + 3
  sta NUSIZ1                ; [5] + 3

  ; Show Alternate Frames
  lda CYCLE                 ; [8] + 3
  lsr                       ; [11] + 2
  bcc TitleFrameA           ; [13] + 2/3
  BRANCH_PAGE_ERROR TitleFrameA, "TitleFrameA"

TitleFrameB
  ; Mask Colours
  lda #0                    ; [15] + 2
  sta COLUP0                ; [17] + 3
  sta COLUP1                ; [20] + 3

  ; Clear Movements
  sta HMCLR                 ; [23] + 3

  ; Missile & Player 0 Position
  sta.w RESM0               ; [26] + 4  = 30
  sta RESP0                 ; [30] + 3  = 33

  ; Fine Missile Positions
  lda #%11100010            ; [33] + 2
  sta HMM0                  ; [35] + 3
  sta HMM1                  ; [38] + 3

  ; Line Counter
  ldy #95                   ; [67] + 2

  ; Missile & Player 1 Positions
  sta RESM1                 ; [43] + 3  = 46
  sta RESP1                 ; [46] + 3  = 49

  ; Enable Missiles
  sta ENAM0                 ; [49] + 3
  sta ENAM1                 ; [52] + 3

  ; Logo Colours
  lda LOGOFG                ; [55] + 3
  sta COLUPF                ; [58] + 3
  lda LOGOBG                ; [61] + 3
  sta COLUBK                ; [64] + 3

  ; Move Sprites
  SLEEP 7                   ; [67] + 7
  sta HMOVE                 ; [74] + 3   > 74 < 4
  jmp StartBLoop            ; [1] + 3

TitleFrameA
  ; Fine Player Positions
  lda #%11110000            ; [16] + 2
  sta HMP0                  ; [18] + 3
  sta HMP1                  ; [21] + 3

  ; Missile & Player 0 Positions
  sta RESM0                 ; [24] + 3  = 27
  sta RESP0                 ; [27] + 3  = 30

  ; Fine Missile Positions
  lda #%11010010            ; [30] + 2
  sta HMM0                  ; [32] + 3
  sta HMM1                  ; [35] + 3

  ; Line Counter
  ldy #95                   ; [64] + 2

  ; Missile & Player 1 Positions
  sta RESM1                 ; [40] + 3  = 43
  sta RESP1                 ; [43] + 3  = 46

  ; Enable Missiles
  sta ENAM0                 ; [46] + 3
  sta ENAM1                 ; [49] + 3

  ; Logo Colours
  lda LOGOFG                ; [52] + 3
  sta COLUPF                ; [55] + 3
  lda LOGOBG                ; [58] + 3
  sta COLUBK                ; [61] + 3

  ; Mask Colours
  lda #0                    ; [64] + 2
  sta COLUP0                ; [66] + 3
  sta COLUP1                ; [69] + 3

  ; Move Sprites
  sta.w HMOVE               ; [72] + 4

TitleALoop
  nop                       ; [0]
  lda PF1Data,Y             ; [2] + 4
  sta PF1                   ; [6] + 3
  ldx #0                    ; [9] + 2
  lda Title0,Y              ; [11] + 4
  sta GRP0                  ; [15] + 3  <= 32
  lda Title6,Y              ; [18] + 4
  sta GRP1                  ; [22] + 3  <= 48
  lda Title2,Y              ; [25] + 4
  stx VBLANK                ; [29] + 3  = 32
  sta GRP0                  ; [32] + 3  > 34 < 38
  lda Title4,Y              ; [35] + 4
  sta GRP0                  ; [39] + 3  >= 40 < 43
  ldx #%10000010            ; [42] + 2
  lda Title8,Y              ; [44] + 4
  sta GRP1                  ; [48] + 3  > 50 < 54
  lda Title10,Y             ; [51] + 4
  sta GRP1                  ; [55] + 3  >= 56 < 59
  stx VBLANK                ; [58] + 3  = 61
  stx HMP0                  ; [61] + 3
  stx HMP1                  ; [64] + 3
  stx HMM0                  ; [67] + 3
  stx HMM1                  ; [70] + 3
  sta HMOVE                 ; [73] + 3   > 74 < 4
  dey                       ; [0] + 2
  bmi EndTitles             ; [2] + 2/3
StartBLoop
  lda PF2Data,Y             ; [4] + 4
  sta PF2                   ; [8] + 3
  ldx #0                    ; [11] + 2
  lda Title1,Y              ; [13] + 4  < 35
  sta GRP0                  ; [17] + 3
  lda Title7,Y              ; [20] + 4  < 51
  sta GRP1                  ; [24] + 3
  lda Title3,Y              ; [27] + 4
  stx VBLANK                ; [31] + 3  = 34
  sta GRP0                  ; [34] + 3  > 37 <= 40 (*)
  lda Title5,Y              ; [37] + 4
  sta GRP0                  ; [41] + 3  > 42 < 46
  ldx #%10000010            ; [44] + 2
  lda Title9,Y              ; [46] + 4
  sta GRP1                  ; [50] + 3  > 53 <= 56 (*)
  lda Title11,Y             ; [53] + 4
  sta GRP1                  ; [57] + 3  > 58 < 62
  stx VBLANK                ; [60] + 3  = 63
  nop                       ; [63] + 2
  sta HMCLR                 ; [65] + 3  > 24
  dey                       ; [68] + 2
  sta HMOVE                 ; [70] + 3  = 73/74
  bpl TitleALoop            ; [73] + 2/3
  PAGE_ERROR TitleALoop, "TitleALoop"
EndTitles
  ; Clear Playfield
  iny
  sty PF1
  sty PF2
  jmp BottomStars

; -----------------------------------------------------------------------------
; TITLE DATA
; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "TITLEDATA0"
  TITLEDATA0

  ; Title Star Data
TitleTopStars_A
  TOP_TITLE_STARS_A

  ; Clear Sprite Data
ClearSprites
  ; Begin Overscan
  lda #2
  sta WSYNC
  sta VBLANK
  lda #OVERDELAY
  sta TIM64T

  lda #0
  sta GRP0
  sta GRP1
  sta GRP0
  sta ENAM0
  sta ENAM1
  sta VDELP0
  sta VDELP1
  sta NUSIZ0
  sta NUSIZ1
  jmp EndTitleScreen

  ALIGN_FREE_LBL 256, "TITLEDATA1"
  TITLEDATA1

  ; Music Song Data
  SOUNDARRAYS
  SONGDATA

  ALIGN_FREE_LBL 256, "TITLEDATA2"
  TITLEDATA2

TitleTopStars_B
  TOP_TITLE_STARS_B

  ALIGN_FREE_LBL 256, "TITLEDATA3"
  TITLEDATA3

TitleBottomStars_A
  BOTTOM_TITLE_STARS_A
TitleBottomStars_B
  BOTTOM_TITLE_STARS_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000

  ALIGN_FREE_LBL 256, "TITLEDATA4"
  TITLEDATA4

  ; Title Colours
LogoBGCols
  DC.B  YELLOW_NTSC|$A, YELLOW_PAL|$A, $0A              ; NTSC/PAL/B&W
LogoFGCols
  DC.B  RED_NTSC|$0, RED_PAL|$0, $02                    ; NTSC/PAL/B&W
TextCols
  DC.B  TEXT_COL_NTSC|$C, TEXT_COL_PAL|$C, TEXT_COL_BW  ; NTSC/PAL/B&W
  PAGE_ERROR TextCols, "TextCols"
StarCols5
  DC.B  STAR_COL_NTSC, STAR_COL_PAL, STAR_COL_BW        ; NTSC/PAL/B&W
  PAGE_ERROR StarCols5, "StarCols5"

  ; Mask Table (used by Song Player)
BitMaskArray
  DC.B  %10000000
  DC.B  %01000000
  DC.B  %00100000
  DC.B  %00010000
  DC.B  %00001000
  DC.B  %00000100
  DC.B  %00000010
  DC.B  %00000001
  PAGE_WARN BitMaskArray, "BitMaskArray"


; -----------------------------------------------------------------------------
; Title Messages
; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "MessagesLo_A"

; Title Messages:
; 0 - BLANK
; 1 - (C) 2012
; 2 - ATARIAGE
; 3 - PUSH FIRE TO PLAY

MessagesLo_A
  DC.B  <(MessageTable0_A+18), <(MessageTable0_A+12)
  DC.B  <(MessageTable0_A+6), <(MessageTable0_A+0)

MessagesHi_A
  DC.B  >(MessageTable0_A+18), >(MessageTable0_A+12)
  DC.B  >(MessageTable0_A+6), >(MessageTable0_A+0)

MessageTable0_A
  DC.B  <Blank0_A, <Blank0_A, <Blank0_A, <Blank0_A, <Blank0_A, <Blank0_A
  DC.B  <Blank0_A, <Copyright1_A, <Copyright2_A
  DC.B  <Copyright3_A, <Copyright4_A, <Blank0_A
  DC.B  <AtariAge0_A, <AtariAge1_A, <AtariAge2_A
  DC.B  <AtariAge3_A, <AtariAge4_A, <AtariAge5_A
  DC.B  <FireToPlay0_A, <FireToPlay1_A, <FireToPlay2_A
  DC.B  <FireToPlay3_A, <FireToPlay4_A, <FireToPlay5_A

; (C) 2013
Copyright1_A
  DC.B  %11111100
  DC.B  %10000100
  DC.B  %10110100
  DC.B  %10100100
  DC.B  %10110100
  DC.B  %10000000
  DC.B  %11111100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
Copyright2_A
  DC.B  %11111001
  DC.B  %10000001
  DC.B  %10000001
  DC.B  %10000001
  DC.B  %10000001
  DC.B  %11111001
  DC.B  %00001001
  DC.B  %00001001
  DC.B  %00001001
  DC.B  %00001001
  DC.B  %11111001
Copyright3_A
  DC.B  %11110001
  DC.B  %00010001
  DC.B  %00010001
  DC.B  %00010001
  DC.B  %00010001
  DC.B  %00010001
  DC.B  %00010001
  DC.B  %00010001
  DC.B  %00010001
  DC.B  %00010001
  DC.B  %11110001
Copyright4_A
  DC.B  %00011111
  DC.B  %00000001
  DC.B  %00000001
  DC.B  %00000001
  DC.B  %00000001
  DC.B  %00000111
  DC.B  %00000010
  DC.B  %00000010
  DC.B  %00000001
  DC.B  %00000001
  DC.B  %00011111

; ATARIAGE
AtariAge0_A
  DC.B  %00000000
  DC.B  %00011100
  DC.B  %00100010
  DC.B  %01000001
  DC.B  %01010101
  DC.B  %01001001
  DC.B  %01000001
  DC.B  %01010101
  DC.B  %01001001
  DC.B  %00100010
  DC.B  %00011100
AtariAge1_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00001111
  DC.B  %00001001
  DC.B  %00001111
  DC.B  %00000001
  DC.B  %00001111
AtariAge2_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00100111
  DC.B  %00100100
  DC.B  %00100111
  DC.B  %00100000
  DC.B  %01110111
AtariAge3_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %10100001
  DC.B  %10100001
  DC.B  %10100001
  DC.B  %10110001
  DC.B  %10101101
AtariAge4_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01111011
  DC.B  %01001000
  DC.B  %01111011
  DC.B  %00001010
  DC.B  %01111011
AtariAge5_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %11011110
  DC.B  %01010000
  DC.B  %11011110
  DC.B  %01010010
  DC.B  %11011110
  ; Blank
Blank0_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000

; PUSH FIRE TO PLAY
FireToPlay0_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00001000
  DC.B  %00001000
  DC.B  %00001111
  DC.B  %00001001
  DC.B  %00001111
FireToPlay1_A
  DC.B  %01001111
  DC.B  %01001001
  DC.B  %01001001
  DC.B  %01001001
  DC.B  %11101111
  DC.B  %00000000
  DC.B  %01111011
  DC.B  %01001000
  DC.B  %01001011
  DC.B  %01001010
  DC.B  %01001011
FireToPlay2_A
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00011110
  DC.B  %00010010
  DC.B  %00011110
  DC.B  %00000000
  DC.B  %11010010
  DC.B  %01010010
  DC.B  %11011110
  DC.B  %00010010
  DC.B  %11010010
FireToPlay3_A
  DC.B  %11110111
  DC.B  %10000100
  DC.B  %10000111
  DC.B  %10000000
  DC.B  %10000111
  DC.B  %00000000
  DC.B  %00100001
  DC.B  %00100001
  DC.B  %00111001
  DC.B  %00100001
  DC.B  %00111101
FireToPlay4_A
  DC.B  %10111100
  DC.B  %10000100
  DC.B  %10111100
  DC.B  %10100100
  DC.B  %10100100
  DC.B  %00000000
  DC.B  %01000011
  DC.B  %01000010
  DC.B  %01000011
  DC.B  %01100010
  DC.B  %01011011
FireToPlay5_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %11000000
  DC.B  %00000000
  DC.B  %11000000
  DC.B  %01000000
  DC.B  %11000000

  PAGE_ERROR MessageTable0_A, "MessageTable0_A"

  .byte " Star Castle Arcade v0.92 "
  IF NTSC_TIM
  .byte "(NTSC)"
  ELSE
  .byte "(PAL)"
  ENDIF
  .byte " - (C) 2013 Thomas Jentzsch, Chris Walton "

;  ALIGN_FREE_LBL 256, "MessagesLo_B"

MessagesLo_B
  DC.B  <(MessageTable0_B+18)
  DC.B  <(MessageTable0_B+12), <(MessageTable0_B+6), <(MessageTable0_B+0)

MessagesHi_B
  DC.B  >(MessageTable0_B+18)
  DC.B  >(MessageTable0_B+12), >(MessageTable0_B+6), >(MessageTable0_B+0)

MessageTable0_B
  DC.B  <Blank0_B, <Blank0_B, <Blank0_B, <Blank0_B, <Blank0_B, <Blank0_B
  DC.B  <Blank0_B, <Copyright1_B, <Copyright2_B
  DC.B  <Copyright3_B, <Copyright4_B, <Blank0_B
  DC.B  <AtariAge0_B, <AtariAge1_B, <AtariAge2_B
  DC.B  <AtariAge3_B, <AtariAge4_B, <AtariAge5_B
  DC.B  <FireToPlay0_B, <FireToPlay1_B, <FireToPlay2_B
  DC.B  <FireToPlay3_B, <FireToPlay4_B, <FireToPlay5_B

; (C) 2013
Copyright1_B
  DC.B  %10000100
  DC.B  %00000000
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %10000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
Copyright2_B
  DC.B  %10000001
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %10001000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00001001
Copyright3_B
  DC.B  %00010000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00010000
Copyright4_B
  DC.B  %00000001
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000101
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000001
AtariAge0_B
  DC.B  %00000000
  DC.B  %00010100
  DC.B  %00000000
  DC.B  %01000001
  DC.B  %00000000
  DC.B  %00001000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01001001
  DC.B  %00000000
  DC.B  %00010100
AtariAge1_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00001001
  DC.B  %00000000
  DC.B  %00001001
  DC.B  %00000000
  DC.B  %00000001
AtariAge2_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00100000
AtariAge3_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %10000000
  DC.B  %00000000
  DC.B  %10000000
  DC.B  %00100000
  DC.B  %10001000
AtariAge4_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01001000
  DC.B  %00000000
  DC.B  %01001010
  DC.B  %00000000
  DC.B  %00001010
AtariAge5_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01010000
  DC.B  %00000000
  DC.B  %01010010
  DC.B  %00000000
  DC.B  %01010010
  ; Blank
Blank0_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000

; PUSH FIRE TO PLAY
FireToPlay0_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00001001
  DC.B  %00000000
  DC.B  %00001001
FireToPlay1_B
  DC.B  %00001001
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01001001
  DC.B  %00000000
  DC.B  %01001000
  DC.B  %00000000
  DC.B  %00000010
  DC.B  %00000000
  DC.B  %00000010
FireToPlay2_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00010010
  DC.B  %00000000
  DC.B  %00010010
  DC.B  %00000000
  DC.B  %01000000
  DC.B  %00000000
  DC.B  %01010010
  DC.B  %00000000
  DC.B  %00000000
FireToPlay3_B
  DC.B  %10000100
  DC.B  %00000000
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00100000
FireToPlay4_B
  DC.B  %10000100
  DC.B  %00000000
  DC.B  %10100100
  DC.B  %00000000
  DC.B  %10000000
  DC.B  %00000000
  DC.B  %00000010
  DC.B  %00000000
  DC.B  %00000010
  DC.B  %01000000
  DC.B  %00010010
FireToPlay5_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01000000
  DC.B  %00000000
  DC.B  %01000000

  PAGE_ERROR MessageTable0_B, "MessageTable0_B"

  ALIGN_FREE_LBL 256, "PFData"

PFData
PF2Data
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %00111111
  DC.B  %00001111
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10000000
  DC.B  %10100000
  DC.B  %10111110
  DC.B  %10111111
  DC.B  %00111111
  DC.B  %00111111
  DC.B  %00111111
  DC.B  %00111111
  DC.B  %01111111
  DC.B  %01111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
PF1Data
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111001
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11100000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %11100000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111000
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111101
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  PAGE_ERROR PFData, "PFData"

  ; Music Data
  PATTERNDATA
  PATTERNL
  PATTERNH

;  echo "----",($FFF4 - *) , "bytes left (BANK5 - TITLES & MUSIC)"

  END_BANK 5