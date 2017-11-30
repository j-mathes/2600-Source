; -----------------------------------------------------------------------------
; Star Castle Arcade - Atari 2600
; Copyright (C) 2012 Chris Walton (cd-w) <cwalton@gmail.com>
; Copyright (C) 2013 Thomas Jentzsch <tjentzsch@yahoo.de>
; Bank 2 - Main Kernel
; -----------------------------------------------------------------------------

  START_BANK "BANK2"
  TASK_VECTORS 2            ; +16
  ds 2, 0
JmpOverscan
  nop     BANK0             ; Switch to Bank 0

; -----------------------------------------------------------------------------
; Setup Player Sprite (Ship & Projectile) [319]
; -----------------------------------------------------------------------------

.waitKernelSetup            ; [38]
  lda INTIM
  bne .waitKernelSetup
  lda #KERNEL_DELAY
  sta TIM64T

PlayerSetup SUBROUTINE
.tempX = BPTR
.tempY = BPTR+1
  ldx COLMODE               ; [0] + 3
  ; Show Projectile On Alternate Frames If Visible
  bit PROJDIR               ; [3] + 3
  bmi .showShip             ; [6] + 2/3
  lda CYCLE                 ; [8] + 3
  lsr                       ; [11] + 2
  bcs .flickerShip          ; [13] + 2/3
  ; Set Projectile Colour
  lda projCol               ; [15] + 3
  sta COLUP0                ; [17] + 3+1

  ; Set Projectile Pointers
  lda PROJX_HI              ; [20] + 3
  sta .tempX                ; [23] + 3
  lda PROJY_HI              ; [26] + 3
  sta .tempY                ; [29] + 3
  sta TEMP2                 ; [32] + 3
  sec                       ; [35] + 2
  ldx PROJFRAME             ; [37] + 3
  lda ProjLoPtrTable,X      ; [40] + 4
  sbc .tempY                ; [45] + 3
  sta PPTR                  ; [47] + 3
  sta PPTR+2                ; [50] + 3
  lda ProjHiPtrTable,X      ; [53] + 4
  sta PPTR+1                ; [57] + 3

  ; Update Projectile Frame (repeat final 4 frames)
  cpx #NUM_PROJ_FRAMES
  bne .contProjectile
  ; stop spark
  ror                       ;           == 1xxxxxxxx
  sta PROJDIR
.contProjectile
  ldy #8-1
  bcc .noReflect            ;           no spark
  lda RANDOM
  lsr
  bcc .noReflect
  iny
.noReflect
;  lda #0                    ; [69] + 2
  sty REFP0                 ; [71] + 3
  dex                       ; [60] + 2
  bpl .storeProjFrame       ; [62] + 2/3
  ldx #3                    ; [64] + 2
.storeProjFrame
  stx PROJFRAME             ; [66] + 3

  jmp .endShipPtrs          ; [74] + 3        = 77

; -----------------------------------------------------------------------------

.showShip
  ; Normal Ship Colour
  lda ShipCols,X            ; [9] + 4
  sec                       ; [13] + 2
  bne .storeShipColour      ; [15] + 3

.flickerShip
  ; Lighten Ship Colour
  lda ShipColsLight,X       ; [16] + 4
  ; sec
.storeShipColour
  sta COLUP0                ; [20] + 3

  lda SHIPX_HI              ; [23] + 3
  ; Check For Explosion
  bit SHIPS                 ; [26] + 3
  bpl .showShipFrame        ; [29] + 2/3

  ; Explosion Colour
  ldx #$0E                  ; [33] + 2
  stx COLUP0                ; [35] + 3

  ; Ship Explosion X Offset
  sbc #4                    ; [38] + 2
  bcs .storeShipXOffsetA    ; [40] + 2/3
  ; clc
  adc #SCREEN_WIDTH         ; [42] + 2      correct horizontal wrap arround
.storeShipXOffsetA
  sta .tempX                ; [44] + 3

  ; Ship Explosion Y Offset
;  sec
  lda SHIPY_HI              ; [47] + 3
  sbc #4                    ; [50] + 2
  bcs .storeShipYOffsetA    ; [52] + 2/3
  ; clc
  adc #YSTART               ; [54] + 2      correct vertical wrap arround
.storeShipYOffsetA
  sta .tempY                ; [56] + 3

  ; Ship Explosion Wrap
  cmp #(YSTART-8)           ; [65] + 2
  bcc .endShipWrapA         ; [67] + 2/3
  ; sec
  sbc #YSTART               ; [69] + 2
.endShipWrapA
  sta TEMP2                 ; [71] + 3

  lda #0                    ; [74] + 2
  sta REFP0                 ; [76] + 3

  ; Ship Explosion Pointers
  lda SHIPEXP_FRAME         ; [79] + 3
  lsr                       ; [82] + 2
  lsr                       ; [84] + 2
  tay                       ; [86] + 2
  sec                       ; [88] + 2
  lax ShipExplodePtrLo,Y    ; [90] + 4
  sbc .tempY                ; [94] + 3
  sta PPTR                  ; [97] + 3
  lda ShipExplodePtrHi,Y    ; [102] + 4
  bne .storeShipPtrs        ; [106] + 3     = 109

; -----------------------------------------------------------------------------

.showShipFrame
  ; Calculate Ship X Offset
  ldy SHIPDIR_HI            ; [32] + 3
  sbc ShipXOffset,Y         ; [35] + 4
  bcs .storeShipXOffsetB    ; [39] + 2/3
  ; clc
  adc #SCREEN_WIDTH         ; [41] + 2      correct horizontal wrap arround
.storeShipXOffsetB
  sta .tempX                ; [43] + 3

  ; Calculate Ship Y Offset
;  sec
  lda SHIPY_HI              ; [46] + 3
  sbc ShipYOffset,Y         ; [49] + 4
  bcs .storeShipYOffsetB    ; [53] + 2/3
  ; clc
  adc #YSTART               ; [55] + 2      correct vertical wrap arround
.storeShipYOffsetB
  sta .tempY                ; [57] + 3

  ; Ship Wrap
  cmp #(YSTART-8)           ; [66] + 2
  bcc .endShipWrapB         ; [68] + 2/3
  ; sec
  sbc #YSTART               ; [70] + 2      -> negative value!
.endShipWrapB
  sta TEMP2                 ; [72] + 3

  lda ShipReflect,y         ; [75] + 4
  sta REFP0                 ; [79] + 3

  ; Ship Pointers
  sec                       ; [82] + 2
  lda SWCHA                 ; [84] + 4
  and #%00010000            ; [88] + 2
  bne .noShipFlame          ; [90] + 2/3
  lda CYCLE                 ; [92] + 3
  and #%10                  ; [95] + 2
  beq .noShipFlame          ; [97] + 2/3
  ; Show Flame Frames
  lax ShipFlamePtrLo,Y      ; [99] + 4
  sbc .tempY                ; [103] + 3
  sta PPTR                  ; [106] + 3
  lda ShipFlamePtrHi,Y      ; [111] + 4
  bne .storeShipPtrs        ; [115] + 3     = 118

.noShipFlame
  ; Show Normal Frames
  lax ShipPtrLo,Y           ; [100] + 4
  sbc .tempY                ; [104] + 3
  sta PPTR                  ; [107] + 3
  lda ShipPtrHi,Y           ; [112] + 4
.storeShipPtrs
  sta PPTR+1                ; [116] + 3
  txa                       ; [119] + 2
  ; sec
  sbc TEMP2                 ; [121] + 3
  sta PPTR+2                ; [124] + 3     2nd ptr used when ring starts
.endShipPtrs                ; WORST = 127 CYCLES

;  sta HMCLR

  ; Position Player 0
  ldx #RESP0-RESP0          ; [0] + 2
  lda .tempX                ; [2] + 3
  jsr XPosition             ; [5] + 158
                            ; WORST = 163 CYCLES
; -----------------------------------------------------------------------------

  ; Player Masks
  ; clc
  lda #<PlayerMask+1        ; [3] + 2
  sbc .tempY                ; [5] + 3
  sta PMASKPTR              ; [8] + 3

  lda #<PlayerMask          ; [11] + 2
  ; sec
  sbc TEMP2                 ; [13] + 3
  sta PMASKPTR+2            ; [16] + 3

;  SLEEP 5                  ; free cycles

; -----------------------------------------------------------------------------
; Setup Missile Sprite (Bullets) [22]
; -----------------------------------------------------------------------------

;  ; Show/Hide Bullets
;  ldx BPOS                  ; [0] + 3
;  lda #<BulletData          ; [3] + 2
;  sec                       ; [5] + 2
;  sbc BULLETY_HI,X          ; [7] + 4
;  ldy BULLETDIR,X           ; [11] + 4
;  bpl .storeBulletY         ; [15] + 2/3
;  lda #<BulletData-YSTART   ; [17] + 2      hide bullet
;.storeBulletY
;  sta MPTR                  ; [19] + 3
;
;  ; Position Missile 0 (Bullet)
;  tya                       ; [21] + 2
;  bmi .hideBullet           ; [23] + 2/3
;  lda BULLETX_HI,X          ; [25] + 4
;  ldx #RESM0-RESP0          ; [29] + 2
;  jsr XPosition             ; [31] + 158 (worst case)
;.hideBullet

  ; Show/Hide Bullets
  ldx BPOS                  ; [0] + 3
  lda BULLETDIR,X           ; [3] + 4
  bmi .hideBullet           ; [7] + 2/3
  lda #<BulletData          ; [9] + 2
  sec                       ; [11] + 2
  sbc BULLETY_HI,X          ; [13] + 4
  sta MPTR                  ; [17] + 3
  lda BULLETX_HI,X          ; [20] + 4
  ldx #RESM0-RESP0          ; [24] + 2
  jsr XPosition             ; [26] + 158 (worst case)
.endBullet

; -----------------------------------------------------------------------------
; Setup Ball Sprite (Mines) [30, until WSYNC]
; -----------------------------------------------------------------------------

  ; Hide Mines In State 0
  ldy #>MineData            ; [0] + 2
  ldx MPOS                  ; [2] + 3
  lda MINEDIR_R,X           ; [5] + 4
  cmp #MINE_DEAD + (%1<<5)  ; [9] + 2
  bcc .hideMine             ; [11] + 2/3

  ; CYCLES:
  ; 00: --  ;x  , y  , NUSIZ=2, ysize=1
  ; 01: |.  ;x  , y  , NUSIZ=1, ysize=2
  ; 10: __  ;x  , y+1, NUSIZ=2, ysize=1
  ; 11: .|  ;x+1, y  , NUSIZ=1, ysize=2
  lda CYCLE                 ; [13] + 3
  lsr                       ; [16] + 2
  bcs .ySize2               ; [18] + 2/3
  dey                       ; [20] + 2
  lsr                       ; [22] + 2     + 11+2
.ySize2
  lda #<MineData            ; [24] + 2
  sbc MINEY_HI_R,X          ; [26] + 4
.contMine

  ; Move Sprites (done here to avoid extra line for very right mines)
  sta WSYNC                 ; [30] + 3
; --------------------------------------
  sta HMOVE                 ; [0] + 3
  sta BPTR                  ; [3] + 3
  sty BPTR+1                ; [6] + 3
  jmp KernelSetup           ; [9] + 3

.hideBullet
  lda #<BulletData-YSTART   ; [17] + 2      hide bullet
  sta MPTR                  ; [19] + 3
  bpl .endBullet

.hideMine
  lda #<MineData-YSTART     ; [12] + 2
  bcc .contMine             ; [14] + 3

; -----------------------------------------------------------------------------

Wait27 SUBROUTINE
  NOP_W                     ; [] + 1
Wait26
  NOP_ZP                    ; [] + 1
;Wait25
  nop
  nop
  nop
  nop
Wait17
  NOP_B                     ; [] + 1
Wait16
  NOP_W                     ; [] + 1
Wait15
  NOP_ZP                    ; [] + 1
Wait14
  nop                       ; [] + 2
Wait12
  rts                       ; [] + 6

  COND_ALIGN_SHIP_FREE "PROJDATA0"
  PROJDATA0

  ; Ship Rotation Offsets
ShipYOffset
 IF SMALL_SHIP
  DC.B  5,5,5,5,5,5,5,5,3,3,3,3,3,3,3,3
  DC.B  3,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5
 ELSE ;{
  DC.B  4,4,4,4,4,4,5,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,5,4,4,4,4,4
 ENDIF ;}
  PAGE_WARN ShipYOffset, "ShipYOffset"

; -----------------------------------------------------------------------------
; Setup Kernel Variables [56]
; -----------------------------------------------------------------------------

KernelSetup
  ; Set Sprite Colours
  ldy COLMODE               ; [12] + 3
  lda StarCols2,Y           ; [15] + 4
  sta COLUP1                ; [19] + 3

  ; Set 1 Copy Of Player 1
  lda #0                    ; [22] + 2
  sta NUSIZ1                ; [24] + 3

  ; Hide Missiles
  sta ENAM0                 ; [27] + 3
  sta ENAM1                 ; [30] + 3

  ; Clear Collision Registers
  sta CXCLR                 ; [33] + 3

  ; Set Mine Colour
  ; ldx MPOS
  lda MINECOL,X             ; [36] + 4
  sta COLUPF                ; [40] + 3

  ; set high pointers for player and bullet
  lda #>PlayerMask          ; [43] + 2
  sta PMASKPTR+1            ; [45] + 3
  lda #>BulletData          ; [48] + 2
  sta MPTR+1                ; [50] + 3

  ; Alternate Kernel Depending on Frame (also used for mine size)
  lda CYCLE                 ; [53] + 3

  ; Reset Sprite Positions
  sta HMCLR                 ; [56] + 3  > 24
  sta RESM1                 ; [59] + 3    = 62  2256

; -----------------------------------------------------------------------------
; Top Kernels
; -----------------------------------------------------------------------------

  ; Start Kernel
  ; Begin Frame
WaitVblank
  ldx INTIM
  bne WaitVblank
  stx VBLANK

  ; update siren sound (scan line 35)
  ldy sirenF0_R             ; [50] + 4
  sty AUDF0

  ; Set Mine Size
;  lda CYCLE
  lsr
  txa                       ;               x=0!
  bcs .singleWidth
  lda #%00010001            ; [35] + 2
.singleWidth
  sta CTRLPF                ; [37] + 3

  ; Set Line Counters
  ldy #(YSTART - 1)         ; [53] + 2
  ldx #(YOFFSET - 1)

  ; Alternate Kernel Depending on Frame
;  lda CYCLE
;  lsr
; -----------------------------------------------------------------------------

TopKernelLoop
  lda (PPTR),Y              ; [18] + 5
  bcc .topEven0             ; [23] + 2/3
  sta WSYNC                 ; [33]
; --------------------------------------
  bcs .topOdd0

.topEven0
  sta WSYNC                 ; [26] + 3
; --------------------------------------
  sta HMOVE                 ; [0] + 3
.topOdd0

  ; Draw Player
  and (PMASKPTR),Y          ; [3] + 5
  sta GRP0                  ; [8] + 3    > 75 < 26

  ; Draw Bullets
  lda (MPTR),Y              ; [11] + 5
  sta ENAM0                 ; [16] + 3

  bcc .topEven1             ; [19] + 2/3
  ; Draw Stars
  lda TopStarsA,X           ; [21] + 4
  sta ENAM1                 ; [25] + 3
  sta HMM1                  ; [28] + 3

  sta WSYNC                 ; [31] + 3
; --------------------------------------
  ; Clear Stars
  lda #0                    ; [0] + 2
  sta HMOVE                 ; [2] + 3
  bcs .topOdd1              ; [5] + 3

.topEven1
  lda #0                    ; [21] + 2
  sta ENAM1                 ; [23] + 3
  ; Load Star Data
  lda TopStarsB,X           ; [26] + 4
  sta HMM1                  ; [30] + 3
  ; Move Sprites
  sta WSYNC                 ; [33] + 3
; --------------------------------------
.topOdd1
  sta ENAM1                 ; [0+8] + 3

  ; Draw Mines
  lda (BPTR),Y              ; [3] + 5
  sta ENABL                 ; [8] + 3    > 75 < 26

  dey                       ; [11] + 2
  dex                       ; [13] + 2
  bpl TopKernelLoop         ; [15] + 2/3

  ; Set 3 Copies of Player 1
  lda #%00000011            ; [] + 2
  sta NUSIZ1                ; [] + 3

  bcs .top0dd2              ; [17] + 2/3
  sta HMCLR                 ; [19] + 3
  jmp StartKernelB          ; [22] + 3    = 25

.top0dd2
;  ; Set 3 Copies of Player 1
;  lda #%00000011            ; [28] + 2
;  sta.w NUSIZ1              ; [30] + 4
  jmp StartKernelA          ; [34] + 3    = 37

; -----------------------------------------------------------------------------

  COND_ALIGN_SHIP_FREE "SHIPDATA0"
  SHIPDATA0

; -----------------------------------------------------------------------------
; Bottom Kernels
; -----------------------------------------------------------------------------

BottomKernelA               ; odd
  sec                       ; [36] + 2
BottomKernelB               ; even
  ldx COLMODE               ; [38] + 3
  lda StarCols2,X           ; [41] + 4
  sta COLUP1                ; [45] + 3
  lda #0                    ; [48] + 2
  sta NUSIZ1                ; [50] + 3
; Y = YOFFSET - 1
; Y = 24 / 49
BottomKernelLoop
  lda (PPTR),Y              ; [24] + 5
  and (PMASKPTR),Y          ; [29] + 5
  bcc .btmEven0             ; [34] + 2/3
  sta WSYNC                 ; [36] + 3
; --------------------------------------
  bcs .btmOdd0              ; [0] + 2/3

.btmEven0
  sta WSYNC                 ; [37] + 3
; --------------------------------------
  sta HMOVE                 ; [0] + 3
.btmOdd0
  sta GRP0                  ; [3] + 3       > 75 < 26

  ; Draw Bullets
  lda (MPTR),Y              ; [6] + 5
  sta ENAM0                 ; [11] + 3

  bcc .btmEven1             ; [14] + 2/3
  ; Draw Stars
  lda BottomStarsA,Y        ; [16] + 4
  sta ENAM1                 ; [20] + 3
  sta HMM1                  ; [23] + 3

  sta WSYNC                 ; [26] + 3
; --------------------------------------
  ; Move Sprites
  sta HMOVE                 ; [0] + 3
  ; Clear Stars
  lda #0                    ; [3] + 2
  bcs .btmOdd1              ; [5] + 3

.btmEven1
  lda #0                    ; [21] + 2
  sta ENAM1                 ; [23] + 3
  ; Load Star Data
  lda BottomStarsB,Y        ; [26] + 4
  sta HMM1                  ; [30] + 3
  sta WSYNC                 ; [33]
; --------------------------------------
.btmOdd1
  sta ENAM1                 ; [0+8] + 3

  ; Draw Mines
  lda (BPTR),Y              ; [11] + 5
  sta ENABL                 ; [16] + 3      > 75 < 26

  dey                       ; [19] + 2
  bpl BottomKernelLoop      ; [21] + 2/3

; -----------------------------------------------------------------------------
  lda sirenF3_R             ; [23] + 4
  sta AUDF0                 ; [27] + 3

  lda taskBits              ; [30] + 3       mark kernel as executed
  bmi .kernelNotMissed      ; [33] + 2/3     KERNEL_EXEC
  ora #KERNEL_MISSED        ; [35] + 2
.kernelNotMissed
  and #<~KERNEL_EXEC        ; [37] + 2
  sta taskBits              ; [39] + 3

  iny                       ; [42] + 2
  lda #2                    ; [44] + 2
  ldx #OVERDELAY            ; [46] + 2
  sta WSYNC                 ; [48] + 3      <= 76!
; --------------------------------------
  ; Begin Overscan
  sta VBLANK
  stx TIM64T

  ; Clear Sprites
  ; ldy #0
  sty ENAM1
  sty ENAM0
  sty ENABL
  sty GRP0

  jmp JmpOverscan

; -----------------------------------------------------------------------------
; Kernel A
; -----------------------------------------------------------------------------

; Y = YOFFSET + YRINGS - 1
; Y = 64 / 89
StartKernelA
; this is the more complex kernel with mid-scanline color changes
; rings at 61..100 -> @80.5 (was 64..103 -> @83.5)

  ; Copy Player Pointer
  lda PPTR+2                ; [30] + 3

  ; Position Player 1
 IF KERNEL_SHL_3
  sta RESP1                 ; [33] + 4    = 43
  sta PPTR+0                ; [33] + 3
  ldx #$a0                  ; [43] + 2    (-2)
 ELSE
  ldx #$d0                  ; [43] + 2    (-2)
  sta RESP1                 ; [33] + 4    = 43
  sta PPTR+0                ; [33] + 3
 ENDIF
  stx HMP1                  ; [45] + 3
  lda #$80                  ; [48] + 2    (0)
  sta HMP0                  ; [50] + 3
  sta HMM0                  ; [53] + 3
  sta HMM1                  ; [56] + 3
  sta HMBL                  ; [59] + 3

  ; Copy Mask Pointer
  lda PMASKPTR+2            ; [62] + 3
  sta PMASKPTR+0            ; [65] + 3

  ; Move Sprites
  sta HMOVE                 ; [70] + 3    = 73/74
  SLEEP 4                   ; [73] + 4

; --------------
---------------------------------------------------------------

KernelLoop0A
  ; Draw Player
  lda (PPTR),Y              ; [1] + 5
  and (PMASKPTR),Y          ; [6] + 5
  sta GRP0                  ; [11] + 3    > 75 < 26

  ; Draw Bullets (Bit 7 Must Be Set)
  lax (MPTR),Y              ; [14] + 5
  stx ENAM0                 ; [19] + 3    > 75 < 26

  ; Set Colour
  lda RINGCOL0              ; [22] + 3
  sta COLUP1                ; [25] + 3    < 44

  ; Set Position
  sta HMCLR                 ; [28] + 3    > 24
  stx HMP1                  ; [31] + 3    > 24

  ; Draw Rings
  ldx #0                    ; [34] + 2
  stx GRP1                  ; [36] + 3    < 44
  lda GRID_R2-YOFFSET,Y     ; [39] + 4
  sta.w GRP1                ; [43] + 4    > 46 < 50
  SLEEP 3                   ; [47] + 3
  stx GRP1                  ; [50] + 3    >= 52 < 55

  ; Move Sprites
  sta WSYNC                 ; [0]
; --------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Mines
  lda (BPTR),Y              ; [3] + 5
  sta ENABL                 ; [8] + 3     > 75 < 26

  ; Set Sprite Positions
  jsr Wait26
  SLEEP 4

  sta HMCLR                 ; [47] + 4    > 24
  sta HMP0                  ; [51] + 3    > 24
  sta HMM0                  ; [54] + 3    > 24
  sta HMM1                  ; [57] + 3    > 24
  sta HMBL                  ; [60] + 3    > 24

  lda sirenF1_R

  dey                       ; [63] + 2
  cpy #(YOFFSET + 35)       ; [65] + 2
  bcc StartKernel1A         ; [67] + 2/3
  BRANCH_PAGE_ERROR StartKernel1A, "StartKernel1A"

  ; Move Sprites
;  nop                       ; [69] + 2
  SLEEP 5
  sta HMOVE                 ; [71] + 3    = 73/74

  ; Loop
  bcs KernelLoop0A          ; [74] + 2/3
  BRANCH_PAGE_ERROR KernelLoop0A, "KernelLoop0A"

StartKernel1A
  ; update siren sound (scan line 105)
  sta AUDF0
  sta HMOVE                 ; [70] + 3    = 73/74
  jmp KernelLoop1A          ; [73] + 3


; -----------------------------------------------------------------------------

  COND_ALIGN_SHIP_FREE "SHIPDATA1"
  SHIPDATA1

; -----------------------------------------------------------------------------

KernelLoop1A
  ; Draw Player
  lda (PPTR),Y              ; [0] + 5
  and (PMASKPTR),Y          ; [5] + 5
  sta GRP0                  ; [10] + 3    > 75 < 26

  ; Draw Bullets
  lda (MPTR),Y              ; [13] + 5
  sta ENAM0                 ; [18] + 3

  ; Set Colour
  lda RINGCOL0              ; [21] + 3
  sta COLUP1                ; [24] + 3    < 44

  ; Draw Rings & Set Sprite Positions
  sta HMCLR                 ; [27] + 3    > 24
  lda GRID_R0-YOFFSET,y     ; [30] + 4
  sta.w GRP1                ; [34] + 4    < 44
  ldx GRID_R4-YOFFSET,y     ; [38] + 4
  lda #0                    ; [42] + 2
  sta GRP1                  ; [44] + 3    > 46 < 50
  lda #%10000000            ; [47] + 2
  stx GRP1                  ; [49] + 3    >= 52 < 55
  sta HMP1                  ; [52] + 3    > 24

  ; Move Sprites
  sta WSYNC                 ; [0]
; --------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Mines
  lax (BPTR),Y              ; [3] + 5
  stx ENABL                 ; [8] + 3     > 75 < 26

  ; Set Colour
  lda RINGCOL1              ; [11] + 3
  sta COLUP1                ; [14] + 3    <  44

  ; Draw Rings
  lda GRID_R1-YOFFSET,y     ; [17] + 4
  sta GRP1                  ; [21] + 3    < 47

  ; Set Sprite Positions
  sta HMCLR                 ; [24] + 3    > 24
  stx HMP0                  ; [27] + 3    > 24
  stx HMM0                  ; [30] + 3    > 24
  stx HMM1                  ; [33] + 3    > 24
  stx HMBL                  ; [36] + 3    > 24

  ; Draw Rings
  SLEEP 4                   ; [39] + 4
  lda GRID_R3-YOFFSET,y     ; [43] + 4
  sta GRP1                  ; [47] + 3    > 49 < 52
  lda #0                    ; [50] + 2
  sta GRP1                  ; [52] + 3    > 54 < 58
  SLEEP 8                   ; [55] + 8

  dey                       ; [63] + 2
  cpy #(YOFFSET + 30)       ; [65] + 2
  bcc StartKernelLoop2A     ; [67] + 2/3
  BRANCH_PAGE_ERROR StartKernelLoop2A, "StartKernelLoop2A"

  ; Move Sprites
  sta.w HMOVE               ; [69] + 4    = 73/74

  ; Loop
  bcs KernelLoop1A          ; [73] + 3
  BRANCH_PAGE_ERROR KernelLoop1A, "KernelLoop1A"

StartKernelLoop2A
  sta HMOVE                 ; [70] + 3    = 73/74
  jmp KernelLoop2A          ; [73] + 3

; -----------------------------------------------------------------------------

 IF <. > $80
  ALIGN_FREE_LBL 256, "KernelLoop2A"
 ENDIF

KernelLoop2A
; --------------------------------------
  ; Draw Player
  lda (PPTR),Y              ; [0] + 5
  and (PMASKPTR),Y          ; [5] + 5
  sta GRP0                  ; [10] + 3    > 75 < 26

  ; Draw Bullets
  lda (MPTR),Y              ; [13] + 5
  sta ENAM0                 ; [18] + 3    > 75 < 26

  ; Set Colour
  lda RINGCOL0              ; [21] + 3
  sta COLUP1                ; [24] + 3    < 44

  ; Draw Rings
  sta HMCLR                 ; [27] + 3    > 24
  lda GRID_R0-YOFFSET,y     ; [30] + 4
  sta GRP1                  ; [34] + 3    < 44
  ldx GRID_R4-YOFFSET,y     ; [37] + 4
  lda #0                    ; [41] + 2
  sta GRP1                  ; [43] + 3    > 46 < 50
  lda #%10000001            ; [46] + 2
  stx GRP1                  ; [48] + 3    >= 52 < 55
  sta HMP1                  ; [51] + 3    > 24

  ; Set 2 copies
  sta NUSIZ1                ; [54] + 3    < 44

  ; Set Colour
  lda RINGCOL1              ; [57] + 2
  sta COLUP1                ; [59] + 3    <  44

  ; Store Line Counter
  sty TEMP                  ; [62] + 3

  sta WSYNC                 ; [70] + 3
; --------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Load Projectile
  lax (BPTR),Y              ; [3] + 5

  ; Draw Mines
  stx ENABL                 ; [8] + 3     > 75 < 26

  ; Draw Rings
  lda GRID_R1-YOFFSET,y     ; [11] + 4
  sta GRP1                  ; [15] + 3    < 47
  lda GRID_R3-YOFFSET,y     ; [18] + 4

  ; Set Sprite Positions
  sta.w HMCLR               ; [22] + 4    > 24
  stx HMP0                  ; [26] + 3    > 24
  stx HMM0                  ; [29] + 3    > 24
  stx HMM1                  ; [32] + 3    > 24
  stx HMBL                  ; [35] + 3    > 24

  ; Draw Rings
  ldx RINGCOL2              ; [38] + 3
  ldy RINGCOL1              ; [41] + 3
 IF KERNEL_SHL_3
  stx COLUP1                ; [44] + 4    = 48
 ELSE
  stx.w COLUP1              ; [44] + 4    = 48
 ENDIF
  sta GRP1                  ; [48] + 3    > 49 < 52
  sty COLUP1                ; [51] + 3    = 53/54

  ; Restore Counter
  ldy TEMP                  ; [54] + 3

  ; Set 3 Copies
  ldx #%00000011            ; [57] + 2
  stx NUSIZ1                ; [59] + 3    < 44
 IF KERNEL_SHL_3
  SLEEP 3                   ; [62] + 2
 ELSE
  SLEEP 2                   ; [62] + 2
 ENDIF

  dey                       ; [64] + 2
  cpy #(YOFFSET + 28)       ; [66] + 2
  bcc KernelLoop3A          ; [68] + 2/3
  BRANCH_PAGE_ERROR KernelLoop3A, "KernelLoop3A"
  sta HMOVE                 ; [70] + 3    = 73/74
  bcs KernelLoop2A          ; [73] + 2/3
  BRANCH_PAGE_ERROR KernelLoop2A, "KernelLoop2A"

; -----------------------------------------------------------------------------

  COND_ALIGN_SHIP_FREE "SHIPDATA2"
  SHIPDATA2
  PROJDATA1

; -----------------------------------------------------------------------------

KernelLoop3A
; central kernel
  sta HMOVE                 ; [71] + 3    = 73/74

  ; Draw Player
  lda (PPTR),Y              ; [74] + 5
  and (PMASKPTR),Y          ; [3] + 5
  sta GRP0                  ; [8] + 3    > 75 < 26

  ; Draw Bullets
  lda (MPTR),Y              ; [11] + 5
  sta ENAM0                 ; [16] + 3

  ; Set Colour
  lda RINGCOL0              ; [19] + 3
  sta COLUP1                ; [22] + 3    < 44

  ; Draw Rings
  lda GRID_R0-YOFFSET,y     ; [25] + 4
  and #%11111000            ; [29] + 2
  sta GRP1                  ; [31] + 3    < 44
  ldx GRID_R2-YOFFSET,y     ; [34] + 4
  lda GRID_R4-YOFFSET,y     ; [38] + 4
 IF KERNEL_SHL_3
  and #%00011111            ; [48] + 2
  stx GRP1                  ; [45] + 3    > 46 < 50
  sta HMCLR
  sta GRP1                  ; [50] + 3    >= 52 < 55
 ELSE ;{
  sta HMCLR                 ; [42] + 3
  stx GRP1                  ; [45] + 3    > 46 < 50
  and #%00011111            ; [48] + 2
  sta GRP1                  ; [50] + 3    >= 52 < 55
 ENDIF ;}
  ; Move Sprites
  lda #%10000000            ; [53] + 2
  sta HMP1                  ; [55] + 3    > 24

  sta WSYNC                 ; [58] + 3
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Mines
  lax (BPTR),Y              ; [3] + 5
  stx ENABL                 ; [8] + 3     > 75 < 26

  ; Set Colour
  lda RINGCOL2              ; [11] + 3
  sta COLUP1                ; [14] + 3    <  44

  ; Draw Rings
  lda GRID_R1-YOFFSET,y     ; [17] + 4
  sta GRP1                  ; [21] + 3    < 47

  ; Set Sprite Positions
  sta HMCLR                 ; [24] + 3    > 24
  stx HMP0                  ; [27] + 3    > 24
  stx HMM0                  ; [30] + 3    > 24
  stx HMM1                  ; [33] + 3    > 24
  stx HMBL                  ; [36] + 3    > 24

  ; Draw Rings
  lda GRID_R3-YOFFSET,y     ; [39] + 4
  dey                       ; [43] + 2
  cpy #(YOFFSET + 12)       ; [45] + 2
  sta GRP1                  ; [47] + 3    > 49 < 52
  lda #0                    ; [50] + 2
  sta.w GRP1                ; [52] + 4    > 54 < 58
  jsr Wait12                ; [56] + 12
  bcs KernelLoop3A          ; [69] + 2/3
  BRANCH_PAGE_ERROR KernelLoop3A, "KernelLoop3A"

  sta HMOVE                 ; [70] + 3    = 73/74
  jmp KernelLoop4A          ; [73] + 3

; -----------------------------------------------------------------------------
  ALIGN_FREE_LBL 256, "KernelLoop4A"

KernelLoop4A
;---------------------------------------
  ; Draw Player
  lda (PPTR),Y              ; [0] + 5
  and (PMASKPTR),Y          ; [5] + 5
  sta GRP0                  ; [10] + 3    > 75 < 26

  ; Draw Bullets
  lda (MPTR),Y              ; [13] + 5
  sta ENAM0                 ; [18] + 3    > 75 < 26

  ; Set Colour
  lda RINGCOL0              ; [21] + 3
  sta COLUP1                ; [24] + 3    < 44

  ; Draw Rings
  sta HMCLR                 ; [27] + 3    > 24
  lda GRID_R0-YOFFSET,y     ; [30] + 4
  sta GRP1                  ; [34] + 3    < 44
  ldx GRID_R4-YOFFSET,y     ; [37] + 4
  SLEEP 2                   ; [41] + 2
  lda #0                    ; [43] + 2
  sta GRP1                  ; [45] + 3    > 46 < 50
  lda #%10000001            ; [48] + 2
  stx GRP1                  ; [50] + 3    >= 52 < 55
  sta HMP1                  ; [53] + 3    > 24

  ; Set 2 copies
  sta NUSIZ1                ; [56] + 3     < 44

  ; Set Colour
  lda RINGCOL1              ; [59] + 2
  sta COLUP1                ; [61] + 3    <  44

  ; Store Line Counter
  sty TEMP                  ; [64] + 3

  sta WSYNC                 ; [67] + 3
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Load Projectile
  lax (BPTR),Y              ; [3] + 5

  ; Draw Mines
  stx ENABL                 ; [8] + 3     > 75 < 26

  ; Draw Rings
  lda GRID_R1-YOFFSET,y     ; [11] + 4
  sta GRP1                  ; [15] + 3    < 47
  lda GRID_R3-YOFFSET,y     ; [18] + 4

  ; Set Sprite Positions
  sta HMCLR                 ; [22] + 3    > 24
  stx HMP0                  ; [25] + 3    > 24
  stx HMM0                  ; [28] + 3    > 24
  stx HMM1                  ; [31] + 3    > 24
  stx HMBL                  ; [34] + 3    > 24

  ; Draw Rings
  ldx RINGCOL2              ; [37] + 3
  ldy RINGCOL1              ; [40] + 3
 IF KERNEL_SHL_3
  stx.w COLUP1                ; [45] + 3    = 48
  sta GRP1                  ; [48] + 3    > 49 < 52
  sty COLUP1                ; [51] + 3    = 53/54
 ELSE
  SLEEP 2                   ; [43] + 2
  stx COLUP1                ; [45] + 3    = 48
  sta GRP1                  ; [48] + 3    > 49 < 52
  sty COLUP1                ; [51] + 3    = 53/54
 ENDIF
  ; Restore Counter
  ldy TEMP                  ; [54] + 3

  ; Set 3 Copies
  ldx #%10000011            ; [57] + 2
  stx NUSIZ1                ; [59] + 3    < 44
 IF KERNEL_SHL_3
  SLEEP 3
 ELSE
  nop                       ; [62] + 2
 ENDIF
  dey                       ; [64] + 2
  cpy #(YOFFSET + 10)       ; [66] + 2
  bcc StartKernel5A         ; [68] + 2/3
  BRANCH_PAGE_ERROR StartKernel5A, "StartKernel5A"

  sta HMOVE                 ; [70] + 3    = 73/74
  bcs KernelLoop4A          ; [73] + 2/3
  BRANCH_PAGE_ERROR KernelLoop4A, "KernelLoop4A"

StartKernel5A
  sta HMOVE                 ; [71] + 3    = 73/74
  jmp KernelLoop5A          ; [74] + 3

; -----------------------------------------------------------------------------

ShipReflect
  IF SMALL_SHIP
    DS NUM_DIRS/2, 0
    DS NUM_DIRS/2, 8
  ELSE ;{
    DS NUM_DIRS/2+1, 0
    DS NUM_DIRS/2-1, 8
  ENDIF ;}

; -----------------------------------------------------------------------------

KernelLoop5A
  ; Draw Player
  lda (PPTR),Y              ; [1] + 5
  and (PMASKPTR),Y          ; [6] + 5
  sta GRP0                  ; [11] + 3    > 75 < 26

  ; Draw Bullets
  lda (MPTR),Y              ; [14] + 5
  sta ENAM0                 ; [19] + 3

  ; Set Colour
  lda RINGCOL0              ; [22] + 3
  sta COLUP1                ; [25] + 3    < 44

  ; Draw Rings & Set Sprite Positions
  sta HMCLR                 ; [28] + 3    > 24
  lda GRID_R0-YOFFSET,y     ; [] + 4
  sta GRP1                  ; [36] + 3    < 44
  ldx GRID_R4-YOFFSET,y     ; [] + 4
 IF KERNEL_SHL_3
  lda #0                    ; [44] + 2
  sta.w GRP1                ; [46] + 3    > 46 < 50
  lda #$80
 ELSE
  sec
  lda #0                    ; [44] + 2
  sta GRP1                  ; [46] + 3    > 46 < 50
  ror
 ENDIF
  stx GRP1                  ; [51] + 3    >= 52 < 55
  sta HMP1                  ; [54] + 3    > 24

  sta WSYNC                 ; [0]
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Mines
  lax (BPTR),Y              ; [3] + 5
  stx ENABL                 ; [8] + 3     > 75 < 26

  ; Set Colour
  lda RINGCOL1              ; [11] + 3
  sta COLUP1                ; [14] + 3    <  44

  ; Draw Rings
  lda GRID_R1-YOFFSET,y     ; [17] + 4
  sta GRP1                  ; [21] + 3    < 47

  ; Set Sprite Positions
  sta HMCLR                 ; [24] + 3    > 24
  stx HMP0                  ; [27] + 3    > 24
  stx HMM0                  ; [30] + 3    > 24
  stx HMM1                  ; [33] + 3    > 24
  stx HMBL                  ; [36] + 3    > 24

  ; Draw Rings
  lda GRID_R3-YOFFSET,Y     ; [39] + 4
  dey                       ; [43] + 2
  nop                       ; [45] + 2
  sta GRP1                  ; [47] + 3    > 49 < 52
  lda #0                    ; [50] + 2
  sta GRP1                  ; [52] + 3    > 54 < 58
  SLEEP 3                   ; [55] + 3
  lda sirenF2_R             ; [58] + 4

  cpy #(YOFFSET + 5)        ; [62] + 2
  bcc StartKernelLoop6A     ; [64] + 2/3

  ; Move Sprites
  SLEEP 4
  sta HMOVE                 ; [70] + 3    = 73/74
  bcs KernelLoop5A          ; [73] + 3
  BRANCH_PAGE_ERROR KernelLoop5A, "KernelLoop5A"

StartKernelLoop6A
  sta AUDF0

  sta HMOVE                 ; [71] + 3    = 73/74
  jmp KernelLoop6A          ; [74] + 3

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "KernelLoop6A"

KernelLoop6A
  ; Draw Player
  lda (PPTR),Y              ; [1] + 5
  and (PMASKPTR),Y          ; [6] + 5
  sta GRP0                  ; [11] + 3    > 75 < 26

  ; Draw Bullets (Bit 7 Must Be Set)
  lax (MPTR),Y              ; [14] + 5
  stx ENAM0                 ; [19] + 3    > 75 < 26

  ; Set Colour
  lda RINGCOL0              ; [22] + 3
  sta COLUP1                ; [25] + 3    < 44

  ; Set Position
  sta HMCLR                 ; [28] + 3    > 24
  stx HMP1                  ; [31] + 3    > 24

  ; Draw Rings
  ldx #0                    ; [34] + 2
  stx GRP1                  ; [36] + 3    < 44
  lda GRID_R2-YOFFSET,Y     ; [38] + 4
  sta.w GRP1                ; [44] + 3    > 46 < 50
  SLEEP 2                   ; [47] + 3
  stx GRP1                  ; [50] + 3    >= 52 < 55

  ; Move Sprites
  sta WSYNC                 ; [0]
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Mines
  lda (BPTR),Y              ; [3] + 5
  sta ENABL                 ; [8] + 3     > 75 < 26

  ; Set Sprite Positions
  jsr Wait12                ; [11] + 12
  sta HMCLR                 ; [23] + 3    > 24

  dey                       ; [26] + 2
  cpy #(YOFFSET + 0)        ; [28] + 2
  bcc StartBottom           ; [30] + 2/3

  sta HMP0                  ; [32] + 3    > 24
  sta HMM0                  ; [35] + 3    > 24
  sta HMM1                  ; [38] + 3    > 24
  sta HMBL                  ; [41] + 3    > 24

  jsr Wait27

  ; Move Sprites
  sta HMOVE                 ; [71] + 3    = 73/74

  ; Loop
  bcs KernelLoop6A          ; [74] + 2/3
  BRANCH_PAGE_ERROR KernelLoop6A, "KernelLoop6A"

StartBottom
  jmp BottomKernelA         ; [33] + 3

; -----------------------------------------------------------------------------

  COND_ALIGN_SHIP_FREE "SHIPDATA4"
  SHIPDATA4

; -----------------------------------------------------------------------------
; Kernel B
; -----------------------------------------------------------------------------

StartKernelB
;  ; Set 3 Copies of Player 1
;  lda #%00000011            ; [25] + 2
;  sta NUSIZ1                ; [27] + 3

  ; Copy Player Pointer
  lda PPTR+2                ; [30] + 3
  sta PPTR+0                ; [33] + 3

  ; Copy Mask Pointer
  lda PMASKPTR+2            ; [36] + 3
 IF KERNEL_SHL_3
  nop
  ; Position Player 1
  sta RESP1                 ; [42] + 3    = 45
  sta PMASKPTR+0            ; [39] + 3
 ELSE
  sta PMASKPTR+0            ; [39] + 3

  ; Position Player 1
  sta RESP1                 ; [42] + 3    = 45
 ENDIF

KernelLoop0B
  sta WSYNC                 ; [0]
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Player
  lda (PPTR),Y              ; [3] + 5
  and (PMASKPTR),Y          ; [8] + 5
  sta GRP0                  ; [13] + 3    > 75 < 26

  ; Draw Bullets
  lax (MPTR),Y              ; [16] + 5
  stx ENAM0                 ; [21] + 3    > 75 < 26

  ; Set Start Colour
  lda RINGCOL0              ; [24] + 3
  sta COLUP1                ; [27] + 3    < 44

  ; Rings
  lda GRID_R1-YOFFSET,Y     ; [38] + 4
  sta GRP1                  ; [35] + 3    < 47
 IF KERNEL_SHL_3
  SLEEP 4                   ; [38] + 3
 ELSE
  SLEEP 5                   ; [38] + 3
 ENDIF
  ; Draw Rings
  lda GRID_R3-YOFFSET,Y     ; [38] + 4
  sta GRP1                  ; [46] + 3    >= 49 < 52
  sta HMCLR                 ; [49] + 3    > 24
  lda #0                    ; [52] + 2
  sta GRP1                  ; [54] + 3    > 54 < 58
  stx HMBL                  ; [57] + 3    > 24
  stx HMM0                  ; [60] + 3    > 24
  stx HMM1                  ; [63] + 3    > 24
  stx HMP0                  ; [66] + 3    > 24

  ; Move Sprites
 IF KERNEL_SHL_3
  SLEEP 3
 ELSE
  nop                       ; [69] + 2
 ENDIF
  sta HMOVE                 ; [71] + 3    = 73/74

  ; Draw Mines
  lax (BPTR),Y              ; [74] + 5
;---------------------------------------
  stx ENABL                 ; [3] + 3     > 75 < 26

  ; Position Sprites
  jsr Wait16                ; [6] + 16
  sta HMCLR                 ; [22] + 3    > 24
  stx HMP1                  ; [25] + 3    > 24

  ; Loop
  dey                       ; [28] + 2
  cpy #(YOFFSET + 35)       ; [30] + 2
  bcs KernelLoop0B          ; [32] + 2/3

  ; update siren sound (scan line 105)
  lda sirenF1_R
  sta AUDF0

; -----------------------------------------------------------------------------

KernelLoop1B
  sta WSYNC                 ; [0]
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Player
  lda (PPTR),Y              ; [3] + 5
  and (PMASKPTR),Y          ; [8] + 5
  sta GRP0                  ; [13] + 3    > 75 < 26

  ; Draw Bullets
  lax (MPTR),Y              ; [16] + 5
  stx ENAM0                 ; [21] + 3    > 75 < 26

  ; Clear Rings
  lda #0                    ; [24] + 2
  sta GRP1                  ; [26] + 3    > 54 < 58

  ; Draw Rings
  sta HMCLR                 ; [29] + 3    > 24
  stx HMBL                  ; [32] + 3    > 24
  stx HMM0                  ; [35] + 3    > 24
  stx HMM1                  ; [38] + 3    > 24
  stx HMP0                  ; [41] + 3    > 24

  ; Move Sprites
  jsr Wait27
  sta HMOVE                 ; [71] + 3    = 73/74

  ; Draw Mines
  lax (BPTR),Y              ; [74] + 5
;---------------------------------------
  stx ENABL                 ; [3] + 3     > 75 < 26

  ; Set Start Colour
  lda RINGCOL1              ; [6] + 3
  sta COLUP1                ; [9] + 3    < 44

  ; Position Sprites
  jsr Wait16                ; [12] + 16
  sta HMCLR                 ; [29] + 3    > 24
  stx HMP1                  ; [32] + 3    > 24

  ; Clear Rings
  ldx #0                    ; [35] + 2
  stx GRP1                  ; [37] + 3    < 44
  lda GRID_R2-YOFFSET,Y     ; [38] + 4
  dey                       ; [48] + 2
  sta GRP1                  ; [45] + 3    > 46 < 50

  cpy #(YOFFSET + 30)       ; [53] + 2
  stx GRP1                  ; [50] + 3    >= 52 < 55

  ; Loop
  bcs KernelLoop1B          ; [55] + 2/3
  jmp KernelLoop2B

; -----------------------------------------------------------------------------

ShipCols
  DC.B  SHIP_COL_NTSC, SHIP_COL_PAL, SHIP_COL_BW    ; NTSC/PAL/B&W
ShipColsLight
  DC.B  SHIP_FLICKER_COL_NTSC, SHIP_FLICKER_COL_PAL, SHIP_FLICKER_COL_BW    ; NTSC/PAL/B&W
StarCols2
  DC.B  STAR_COL_NTSC, STAR_COL_PAL, STAR_COL_BW    ; NTSC/PAL/B&W

  COND_ALIGN_SHIP_FREE "SHIPDATA5"
  SHIPDATA5

; -----------------------------------------------------------------------------

KernelLoop2B
  sta WSYNC                 ; [0]
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Player
  lda (PPTR),Y              ; [3] + 5
  and (PMASKPTR),Y          ; [8] + 5
  sta GRP0                  ; [13] + 3    > 75 < 26

  ; Draw Bullets
  lax (MPTR),Y              ; [16] + 5
  stx ENAM0                 ; [21] + 3    > 75 < 26

  ; Empty Rings
  lda #0                    ; [24] + 2
  sta GRP1                  ; [26] + 3    < 47

  ; Set Sprite Positions
  sta HMCLR                 ; [29] + 3    > 24
  stx HMP0                  ; [32] + 3    > 24
  stx HMM0                  ; [35] + 3    > 24
  stx HMBL                  ; [38] + 3    > 24
  stx HMM1                  ; [41] + 3    > 24

  ; Move Sprites
  jsr Wait26
  sta HMOVE                 ; [70] + 3    = 73
;---------------------------------------

  ; Draw Mines
  lax (BPTR),Y              ; [73] + 5
  stx ENABL                 ; [2] + 3     > 75 < 26

  ; Set Colour
  lda RINGCOL2              ; [5] + 3
  sta COLUP1                ; [8] + 3     < 44

  ; Position Sprites
  jsr Wait16                ; [11] + 16
  sta HMCLR                 ; [28] + 3    > 24
  stx HMP1                  ; [31] + 3    > 24

  ; Draw Rings
  ldx #0                    ; [34] + 2
  stx GRP1                  ; [36] + 3    < 44
  lda GRID_R2-YOFFSET,Y     ; [38] + 4
  dey                       ; [47] + 2
  sta GRP1                  ; [44] + 3    > 46 < 50

  cpy #(YOFFSET + 28)       ; [52] + 2
  stx GRP1                  ; [49] + 3    >= 52 < 55

  bpl KernelLoop2B          ; [54] + 2/3

; -----------------------------------------------------------------------------

KernelLoop3B
  sta WSYNC                 ; [0]
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Player
  lda (PPTR),Y              ; [3] + 5
  and (PMASKPTR),Y          ; [8] + 5
  sta GRP0                  ; [13] + 3    > 75 < 26

  ; Draw Bullets
  lax (MPTR),Y              ; [16] + 5
  stx ENAM0                 ; [21] + 3    > 75 < 26

  ; Empty Rings
  lda #0                    ; [24] + 2
  sta GRP1                  ; [26] + 3    < 47

  ; Set Sprite Positions
  stx HMCLR                 ; [29] + 3    > 24
  stx HMP0                  ; [32] + 3    > 24
  stx HMM0                  ; [35] + 3    > 24
  stx HMBL                  ; [38] + 3    > 24
  stx HMM1                  ; [41] + 3    > 24

  ; Move Sprites
  jsr Wait26
  sta HMOVE                 ; [70] + 3    = 73

  ; Draw Mines
  lda (BPTR),Y              ; [73] + 5
;---------------------------------------
  sta ENABL                 ; [2] + 3    > 75 < 26

  ; Set Start Colour
  lda RINGCOL1              ; [5] + 3
  sta COLUP1                ; [8] + 3    < 44

  ; Draw Rings
  jsr Wait14                ; [11] + 14
  lda GRID_R0-YOFFSET,Y     ; [25] + 4
  and #%00000111            ; [29] + 2
  sta GRP1                  ; [31] + 3    < 44
  ldx GRID_R2-YOFFSET,Y     ; [34] + 4
  lda GRID_R4-YOFFSET,Y     ; [38] + 4

  and #%11100000            ; [42] + 2
  stx GRP1                  ; [44] + 3    > 46 < 50
  ldx #%10000000            ; [47] + 2
  sta GRP1                  ; [49] + 3    >= 52 < 55

  ; Position Sprites
  sta HMCLR                 ; [52] + 3    > 24
  stx HMP1                  ; [55] + 3    > 24

  dey                       ; [58] + 2
  cpy #(YOFFSET + 12)       ; [60] + 2
  bpl KernelLoop3B          ; [62] + 2/3
  jmp KernelLoop4B          ; [64] + 3

; -----------------------------------------------------------------------------

  ; Ship Rotation Offsets
ShipXOffset ; 0..359°, clockwise
 IF SMALL_SHIP
  DC.B  5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
  DC.B  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
 ELSE ;{
  DC.B  3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,3
  DC.B  3,4,3,3,3,3,3,3,3,3,3,3,3,3,3,4
 ENDIF ;}
  PAGE_WARN ShipXOffset, "ShipXOffset"

; -----------------------------------------------------------------------------

KernelLoop4B
  sta WSYNC                 ; [0]
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Player
  lda (PPTR),Y              ; [3] + 5
  and (PMASKPTR),Y          ; [8] + 5
  sta GRP0                  ; [13] + 3    > 75 < 26

  ; Draw Bullets
  lax (MPTR),Y              ; [16] + 5
  stx ENAM0                 ; [21] + 3    > 75 < 26

  ; Empty Rings
  lda #0                    ; [24] + 2
  sta GRP1                  ; [26] + 3    < 47

  ; Set Sprite Positions
  sta HMCLR                 ; [29] + 3    > 24
  stx HMP0                  ; [32] + 3    > 24
  stx HMM0                  ; [35] + 3    > 24
  stx HMBL                  ; [38] + 3    > 24
  stx HMM1                  ; [41] + 3    > 24

  ; Move Sprites
  jsr Wait26
  sta HMOVE                 ; [70] + 3    = 73

  ; Draw Mines
  lax (BPTR),Y              ; [73] + 5
;---------------------------------------
  stx ENABL                 ; [2] + 3     > 75 < 26

  ; Set Colour
  lda RINGCOL2              ; [5] + 3
  sta COLUP1                ; [8] + 3     < 44

  ; Position Sprites
  jsr Wait16                ; [11] + 16
  lda #0                    ; [27] + 2
  sta HMCLR                 ; [29] + 3    > 24
  stx HMP1                  ; [32] + 3    > 24

  ; Draw Rings
  sta GRP1                  ; [35] + 3    < 44
  ldx GRID_R2-YOFFSET,Y     ; [38] + 4
  dey                       ; [42] + 3
  stx GRP1                  ; [45] + 3    > 46 < 50
  cpy #(YOFFSET + 10)       ; [48] + 2
  sta GRP1                  ; [50] + 3    >= 52 < 55

  bpl KernelLoop4B          ; [56] + 2/3

; -----------------------------------------------------------------------------

KernelLoop5B
  sta WSYNC                 ; [0]
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Player
  lda (PPTR),Y              ; [3] + 5
  and (PMASKPTR),Y          ; [8] + 5
  sta GRP0                  ; [13] + 3    > 75 < 26

  ; Draw Bullets
  lax (MPTR),Y              ; [16] + 5
  stx ENAM0                 ; [21] + 3    > 75 < 26

  ; Clear Rings
  lda #0                    ; [24] + 2
  sta GRP1                  ; [26] + 3    > 54 < 58

  ; Draw Rings
  sta HMCLR                 ; [29] + 3    > 24
  stx HMBL                  ; [32] + 3    > 24
  stx HMM0                  ; [35] + 3    > 24
  stx HMM1                  ; [38] + 3    > 24
  stx HMP0                  ; [41] + 3    > 24

  ; Move Sprites
  jsr Wait27
  sta HMOVE                 ; [71] + 3    = 73/74

  ; Draw Mines
  lax (BPTR),Y              ; [74] + 5
;---------------------------------------
  stx ENABL                 ; [3] + 3     > 75 < 26

  ; Set Start Colour
  lda RINGCOL1              ; [6] + 3
  sta COLUP1                ; [9] + 3    < 44

  ; Position Sprites
  jsr Wait17                ; [12] + 17
  sta HMCLR                 ; [28] + 3    > 24
  stx HMP1                  ; [32] + 3    > 24

  ; Clear Rings
  ldx #0                    ; [35] + 2
  stx GRP1                  ; [37] + 3    < 44
  lda GRID_R2-YOFFSET,Y     ; [39] + 5
  sta GRP1                  ; [45] + 3    > 46 < 50
  dey                       ; [48] + 2
  stx GRP1                  ; [50] + 3    >= 52 < 55

  ; Loop
  cpy #(YOFFSET + 5)        ; [53] + 2
  bcs KernelLoop5B          ; [55] + 2/3

  lda sirenF2_R
  sta AUDF0
  jmp KernelLoop6B

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "BottomStarsA"

  ; Star Data
BottomStarsA
  BOTTOM_STARS_A
  PAGE_WARN BottomStarsA, "BottomStarsA"

BottomStarsB
  BOTTOM_STARS_B
  PAGE_WARN BottomStarsB, "BottomStarsB"

  COND_ALIGN_SHIP_FREE "SHIPDATA7"
  SHIPDATA7

; -----------------------------------------------------------------------------

KernelLoop6B
  sta WSYNC                 ; [0]
;---------------------------------------
  sta HMOVE                 ; [0] + 3     > 74 < 4

  ; Draw Player
  lda (PPTR),Y              ; [3] + 5
  and (PMASKPTR),Y          ; [8] + 5
  sta GRP0                  ; [13] + 3    > 75 < 26

  ; Draw Bullets
  lax (MPTR),Y              ; [16] + 5
  stx ENAM0                 ; [21] + 3    > 75 < 26

  ; Set Start Colour
  lda RINGCOL0              ; [24] + 3
  sta COLUP1                ; [27] + 3    < 44

  ; Rings
  lda GRID_R1-YOFFSET,Y     ; [39] + 5
  sta GRP1                  ; [35] + 3    < 47

  ; Draw Rings
  lda GRID_R3-YOFFSET,Y     ; [39] + 5
 IF KERNEL_SHL_3
  SLEEP 4                   ; [38] + 3
 ELSE
  SLEEP 5                   ; [38] + 3
 ENDIF
  sta GRP1                  ; [44] + 3    > 46 < 50

  sta HMCLR                 ; [49] + 3    > 24
  lda #0                    ; [52] + 2
  sta GRP1                  ; [54] + 3    > 54 < 58
  stx HMBL                  ; [57] + 3    > 24
  stx HMM0                  ; [60] + 3    > 24
  stx HMM1                  ; [63] + 3    > 24
  stx HMP0                  ; [66] + 3    > 24

  ; Move Sprites
 IF KERNEL_SHL_3
  SLEEP 3
 ELSE
  nop                       ; [69] + 2
 ENDIF
  sta HMOVE                 ; [71] + 3    = 73/74

  ; Draw Mines
  lax (BPTR),Y              ; [74] + 5
;---------------------------------------
  stx ENABL                 ; [3] + 3     > 75 < 26

  ; Position Sprites
  jsr Wait16                ; [6] + 16
  sta HMCLR                 ; [22] + 3    > 24
  stx HMP1                  ; [25] + 3    > 24

  ; Loop
  dey                       ; [28] + 2
  cpy #(YOFFSET + 0)        ; [30] + 2
  bcs KernelLoop6B          ; [32] + 2/3

  jmp BottomKernelB         ; [34] + 3


; -----------------------------------------------------------------------------
; Sprite Data
; -----------------------------------------------------------------------------

  ; Projectile Pointers
ProjLoPtrTable
  DC.B  <Projectile0, <Projectile1, <Projectile2, <Projectile3
  DC.B  <Projectile4, <Projectile4, <Projectile5, <Projectile5
  DC.B  <Projectile6, <Projectile6, <Projectile7, <Projectile7
  DC.B  <Projectile8, <Projectile8, <Projectile9, <Projectile9
  ; used for explosion sparks
  .byte <ProjectileBlank, <Spark1, <Spark0
  PAGE_WARN ProjLoPtrTable, "ProjLoPtrTable"

ProjHiPtrTable
  DC.B  >Projectile0, >Projectile1, >Projectile2, >Projectile3
  DC.B  >Projectile4, >Projectile4, >Projectile5, >Projectile5
  DC.B  >Projectile6, >Projectile6, >Projectile7, >Projectile7
  DC.B  >Projectile8, >Projectile8, >Projectile9, >Projectile9
  ; used for explosion sparks
  .byte >ProjectileBlank, >Spark1, >Spark0
  PAGE_WARN ProjHiPtrTable, "ProjHiPtrTable"

  ALIGN_FREE_LBL 256, "ShipPtrLo"

  ; Ship Sprite Pointers
ShipPtrLo
  DC.B  <Ship0, <Ship1, <Ship2, <Ship3, <Ship4, <Ship5, <Ship6, <Ship7
  DC.B  <Ship8, <Ship9, <Ship10, <Ship11, <Ship12, <Ship13, <Ship14, <Ship15
  DC.B  <Ship16, <Ship15, <Ship14, <Ship13, <Ship12, <Ship11, <Ship10, <Ship9
  DC.B  <Ship8, <Ship7, <Ship6, <Ship5, <Ship4, <Ship3, <Ship2, <Ship1
  PAGE_WARN ShipPtrLo, "ShipPtrLo"
ShipPtrHi
  DC.B  >Ship0, >Ship1, >Ship2, >Ship3, >Ship4, >Ship5, >Ship6, >Ship7
  DC.B  >Ship8, >Ship9, >Ship10, >Ship11, >Ship12, >Ship13, >Ship14, >Ship15
  DC.B  >Ship16, >Ship15, >Ship14, >Ship13, >Ship12, >Ship11, >Ship10, >Ship9
  DC.B  >Ship8, >Ship7, >Ship6, >Ship5, >Ship4, >Ship3, >Ship2, >Ship1
  PAGE_WARN ShipPtrHi, "ShipPtrHi"
ShipFlamePtrLo
  DC.B  <ShipFlame0, <ShipFlame1, <ShipFlame2, <ShipFlame3
  DC.B  <ShipFlame4, <ShipFlame5, <ShipFlame6, <ShipFlame7
  DC.B  <ShipFlame8, <ShipFlame9, <ShipFlame10, <ShipFlame11
  DC.B  <ShipFlame12, <ShipFlame13, <ShipFlame14, <ShipFlame15
  DC.B  <ShipFlame16, <ShipFlame15, <ShipFlame14, <ShipFlame13
  DC.B  <ShipFlame12, <ShipFlame11, <ShipFlame10, <ShipFlame9
  DC.B  <ShipFlame8, <ShipFlame7, <ShipFlame6, <ShipFlame5
  DC.B  <ShipFlame4, <ShipFlame3, <ShipFlame2, <ShipFlame1
  PAGE_WARN ShipFlamePtrLo, "ShipFlamePtrLo"

; -----------------------------------------------------------------------------

  COND_ALIGN_SHIP_FREE "SHIPDATA8"
  SHIPDATA8

; -----------------------------------------------------------------------------

ShipFlamePtrHi
  DC.B  >ShipFlame0, >ShipFlame1, >ShipFlame2, >ShipFlame3
  DC.B  >ShipFlame4, >ShipFlame5, >ShipFlame6, >ShipFlame7
  DC.B  >ShipFlame8, >ShipFlame9, >ShipFlame10, >ShipFlame11
  DC.B  >ShipFlame12, >ShipFlame13, >ShipFlame14, >ShipFlame15
  DC.B  >ShipFlame16, >ShipFlame15, >ShipFlame14, >ShipFlame13
  DC.B  >ShipFlame12, >ShipFlame11, >ShipFlame10, >ShipFlame9
  DC.B  >ShipFlame8, >ShipFlame7, >ShipFlame6, >ShipFlame5
  DC.B  >ShipFlame4, >ShipFlame3, >ShipFlame2, >ShipFlame1
  PAGE_WARN ShipFlamePtrHi, "ShipFlamePtrHi"
ShipExplodePtrLo
  DC.B  <ShipExplode10, <ShipExplode9, <ShipExplode8, <ShipExplode7
  DC.B  <ShipExplode6, <ShipExplode5, <ShipExplode4, <ShipExplode3
  DC.B  <ShipExplode2, <ShipExplode1, <ShipExplode0
  PAGE_WARN ShipExplodePtrLo, "ShipExplodePtrLo"
ShipExplodePtrHi
  DC.B  >ShipExplode10, >ShipExplode9, >ShipExplode8, >ShipExplode7
  DC.B  >ShipExplode6, >ShipExplode5, >ShipExplode4, >ShipExplode3
  DC.B  >ShipExplode2, >ShipExplode1, >ShipExplode0
  PAGE_WARN ShipExplodePtrHi, "ShipExplodePtrHi"

; -----------------------------------------------------------------------------

  ; Sprite Positioning (X = Object)
XPosition
  sta WSYNC                 ; [0]
;---------------------------------------
  nop                       ; [0] + 2
  sec                       ; [2] + 2
  ; Divide Position by 15
Divide15
  sbc #15                   ; [4] + 2
  bcs Divide15              ; [6] + 2/3
  BRANCH_PAGE_ERROR Divide15, "Divide15"
  tay                       ; [8] + 2
  ; Store Coarse and Fine Position
  lda FineTuneEnd,Y         ; [10] + 5*
  sta HMP0,X                ; [15] + 4
  sta RESP0,X               ; [19] + 4
  rts                       ; Positions: [23/28/33/38/43/48/53/58/63/68/73]
; WORST: 152 (78+68+6); MIN: 32 (3+23+6)

  ; Sprite Fine Tuning Table
HMoveTable
  DC.B  $60                 ; - 6 (Left)
  DC.B  $50                 ; - 5
  DC.B  $40
  DC.B  $30
  DC.B  $20
  DC.B  $10
  DC.B  $00                 ; Centre
  DC.B  $f0
  DC.B  $e0
  DC.B  $d0
  DC.B  $c0
  DC.B  $b0
  DC.B  $a0
  DC.B  $90                 ; + 7
  DC.B  $80                 ; + 8 (Right)
  PAGE_ERROR HMoveTable, "HMoveTable"
FineTuneEnd = HMoveTable - 241

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "StartBulletData"

  ; Bullet Data
StartBulletData
  DS.B  YSTART, %10000000
BulletData
  DS.B  1, %10000010
  DS.B  YSTART-1, %10000000
  PAGE_ERROR StartBulletData, "BulletData"

  ; Star Data
TopStarsA
  TOP_STARS_A
  PAGE_WARN TopStarsA, "TopStarsA"

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "StartMineData"

  ; Mine Data
StartMineData
  DS.B  YSTART, %10000000
MineData
  DS.B  2, %10000010
  DS.B  YSTART-2, %10000000
  PAGE_ERROR StartMineData, "MineData"

TopStarsB
  TOP_STARS_B
  PAGE_WARN TopStarsB, "TopStarsB"

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "StartPlayerMask"

StartPlayerMask
  DS.B  YSTART, %00000000
PlayerMask
  DS.B  8, %11111111
  DS.B  YSTART-8, %00000000
  PAGE_ERROR StartPlayerMask, "PlayerMask"

; -----------------------------------------------------------------------------

  END_BANK 2

