; -----------------------------------------------------------------------------
; Star Castle Arcade - Atari 2600
; Copyright (C) 2012 Chris Walton (cd-w) <cwalton@gmail.com>
; Copyright (C) 2013 Thomas Jentzsch <tjentzsch@yahoo.de>
; Bank 4 - Gun & Explosion Frames
; -----------------------------------------------------------------------------

  START_BANK "BANK4"
  TASK_VECTORS 4

; -----------------------------------------------------------------------------
; Draw Explosion Frame [1474] (in OverScan)
; -----------------------------------------------------------------------------

  DEFINE_SUBROUTINE ContExplodeGun0

  ; Draw Frame
  ldy #YRINGS-1             ; [108] + 2
DrawExplodeLoop0
  lda (EXP0),Y              ; [0] + 5
  sta GRID_W1,Y             ; [5] + 5
  lda (EXP1),Y              ; [10] + 5
  sta GRID_W2,Y             ; [15] + 5
  lda (EXP2),Y              ; [20] + 5
  sta GRID_W3,Y             ; [25] + 5
  dey                       ; [30] + 2
  lda (EXP0),Y              ; [32] + 5
  sta GRID_W1,Y             ; [37] + 5
  lda (EXP1),Y              ; [42] + 5
  sta GRID_W2,Y             ; [47] + 5
  lda (EXP2),Y              ; [52] + 5
  sta GRID_W3,Y             ; [57] + 5
  dey                       ; [62] + 2
  bpl DrawExplodeLoop0      ; [64] + 2/3
  PAGE_WARN DrawExplodeLoop0, "DrawExplodeLoop0"

  END_TASK ExplodeGun0      ; [1449] + ??
; TOTAL = 20*67 = 1340 (17.6 SCANLINES)


; -----------------------------------------------------------------------------
; Draw Explosion Frame Part 2 [1027] (in VBlank)
; -----------------------------------------------------------------------------

  DEFINE_SUBROUTINE ContExplodeGun1

  ; Draw Frame
  ldy #YRINGS-1-10          ; [64] + 2
DrawExplodeLoop1
  lda (EXP0),Y              ; [0] + 5
  sta GRID_W0+5,Y           ; [5] + 5
  lda (EXP1),Y              ; [10] + 5
  sta GRID_W4+5,Y           ; [15] + 5
  dey                       ; [20] + 2
  lda (EXP0),Y              ; [22] + 5
  sta GRID_W0+5,Y             ; [27] + 5
  lda (EXP1),Y              ; [32] + 5
  sta GRID_W4+5,Y           ; [37] + 5
  dey                       ; [42] + 2
  bpl DrawExplodeLoop1      ; [44] + 2/3
  PAGE_WARN DrawExplodeLoop1, "DrawExplodeLoop1"

  END_TASK ExplodeGun1      ; [770] + ??
; TOTAL = 15*47 = 705 (12.4 SCANLINES)


; -----------------------------------------------------------------------------
; Draw Gun Turret [145]
; -----------------------------------------------------------------------------

;DrawGun
; TODO:
; - check if direction and cycle bits have changed
; - abortable
; + every 2nd frame (to allow 16 steps in 30 frames)

FLIPPED_GUN = 1

;  START_TASK DrawGun, 4, SKIP_1, Joystick
  DEFINE_SUBROUTINE ContHandleGun

 IF FLIPPED_GUN
  lda GUNDIR                ; [0] + 3
  clc                       ; [3] + 2
  adc #$08                  ; [5] + 2
  and #$1f                  ; [7] + 2
  cmp #$11                  ; [9] + 2
  bcc .dirOk                ; [11] + 2/3
  sbc #1                    ; [13] + 2      -> C=1!
  eor #$1f                  ; [15] + 2
.dirOk
  tax                       ; [17] + 2
 ELSE ;{
  ldx GUNDIR                ; [0] + 3
 ENDIF ;}
  lda taskCycle             ; [19] + 3
  and #%00011000            ; [22] + 2
; optimize: compare with last, if equal: exit!
;  clc
;  adc GunPtrLo,X
  ora GunPtrLo,X            ; [24] + 4      now gun data has to be aligned to % 64! (no overlapping!)
  sta BPTR                  ; [28] + 3
  lda GunPtrHi,X            ; [31] + 4
  sta BPTR+1                ; [35] + 3
  ldy #8-1                  ; [38] + 2
 IF FLIPPED_GUN
DEBUG5
  bcs .drawNormal           ; [40] + 2/3
; draw reversed
  lda GunOffset,X
  tax
; bugfix for bottom artefacts when turning top to right
  lda #0
  sta GRID_W2+16-2,x
DrawGunLoopReversed
  lda (BPTR),Y              ; [0] + 5
  sta GRID_W2+16-1,x        ; [5] + 5
  inx                       ; [10] + 2
  dey                       ; [12] + 2
  bpl DrawGunLoopReversed   ; [14] + 2/3
  PAGE_WARN DrawGunLoopReversed, "DrawGunLoopReversed"
                            ; TOTAL = 17*8-1 = 135
;  END_TASK DrawGun          ; [174/165]
  END_TASK HandleGun
 ENDIF

.drawNormal                 ; [43]
DrawGunLoop
  lda (BPTR),Y              ; [0] + 5
  sta GRID_W2+16,Y          ; [5] + 5
  dey                       ; [10] + 2
  bpl DrawGunLoop           ; [12] + 2/3
  PAGE_WARN DrawGunLoop, "DrawGunLoop"
                            ; TOTAL = 15*8-1 = 119
 IF FLIPPED_GUN
;  EXIT_TASK DrawGun         ; [162] + 3
  EXIT_TASK HandleGun
 ELSE ;{
;  END_TASK DrawGun          ; [107] + 3
  END_TASK HandleGun
 ENDIF ;}

; -----------------------------------------------------------------------------
; Gun & Explosion Data
; -----------------------------------------------------------------------------

  EXPLOSIONDATA4b   ; 74

  ALIGN_FREE_LBL 256, "GUNDATA0"
  GUNDATA0

  ALIGN_FREE_LBL 256, "GUNDATA1"
  GUNDATA1

  ALIGN_FREE_LBL 256, "GUNDATA2"
  GUNDATA2

  ALIGN_FREE_LBL 256, "GUNDATA3"
  GUNDATA3

  EXPLOSIONDATA10

  ALIGN_FREE_LBL 256, "EXPLOSIONDATA1"
  EXPLOSIONDATA1

  ALIGN_FREE_LBL 256, "EXPLOSIONDATA2"
  EXPLOSIONDATA2

  ALIGN_FREE_LBL 256, "EXPLOSIONDATA3"
  EXPLOSIONDATA3

  ALIGN_FREE_LBL 256, "EXPLOSIONDATA9"
  EXPLOSIONDATA9

  ALIGN_FREE_LBL 256, "EXPLOSIONDATA5"
  EXPLOSIONDATA5

  ALIGN_FREE_LBL 256, "EXPLOSIONDATA6"
  EXPLOSIONDATA6

  ALIGN_FREE_LBL 256, "EXPLOSIONDATA7"
  EXPLOSIONDATA7

  ALIGN_FREE_LBL 256, "EXPLOSIONDATA0"
  EXPLOSIONDATA0

; -----------------------------------------------------------------------------
; Gun Data
; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "GunPtrLo"

  ; Gun Pointers (Lo)
  ; 8*4 (32 bytes)
GunPtrLo
 IF FLIPPED_GUN
  DC.B  <Gun24, <Gun23, <Gun22, <Gun21, <Gun20, <Gun19, <Gun18, <Gun17
  DC.B  <Gun16, <Gun15, <Gun14, <Gun13, <Gun12, <Gun11, <Gun10, <Gun9
  DC.B  <Gun8
;  DC.B  <Gun24, <Gun25, <Gun26, <Gun27, <Gun28, <Gun29, <Gun30, <Gun31
;  DC.B  <Gun0, <Gun1, <Gun2, <Gun3, <Gun4, <Gun5, <Gun6, <Gun7
;  DC.B  <Gun8
 ELSE ;{
  DC.B  <Gun0, <Gun1, <Gun2, <Gun3, <Gun4, <Gun5, <Gun6, <Gun7
  DC.B  <Gun8, <Gun9, <Gun10, <Gun11, <Gun12, <Gun13, <Gun14, <Gun15
  DC.B  <Gun16, <Gun17, <Gun18, <Gun19, <Gun20, <Gun21, <Gun22, <Gun23
  DC.B  <Gun24, <Gun25, <Gun26, <Gun27, <Gun28, <Gun29, <Gun30, <Gun31
 ENDIF ;}
  PAGE_WARN GunPtrLo, "GunPtrLo"

GunPtrHi
 IF FLIPPED_GUN
  DC.B  >Gun24, >Gun23, >Gun22, >Gun21, >Gun20, >Gun19, >Gun18, >Gun17
  DC.B  >Gun16, >Gun15, >Gun14, >Gun13, >Gun12, >Gun11, >Gun10, >Gun9
  DC.B  >Gun8
;  DC.B  >Gun24, >Gun25, >Gun26, >Gun27, >Gun28, >Gun29, >Gun30, >Gun31
;  DC.B  >Gun0, >Gun1, >Gun2, >Gun3, >Gun4, >Gun5, >Gun6, >Gun7
;  DC.B  >Gun8
 ELSE ;{
  DC.B  >Gun0, >Gun1, >Gun2, >Gun3, >Gun4, >Gun5, >Gun6, >Gun7
  DC.B  >Gun8, >Gun9, >Gun10, >Gun11, >Gun12, >Gun13, >Gun14, >Gun15
  DC.B  >Gun16, >Gun17, >Gun18, >Gun19, >Gun20, >Gun21, >Gun22, >Gun23
  DC.B  >Gun24, >Gun25, >Gun26, >Gun27, >Gun28, >Gun29, >Gun30, >Gun31
 ENDIF ;}
  PAGE_WARN GunPtrHi, "GunPtrHi"

GunOffset
  .byte 0, 0, 1, 1, 1, 1, 1, 1
  .byte 1, 1, 1, 1, 1, 1, 1, 2
  .byte 2

  EXPLOSIONDATA4a   ; 176

  ALIGN_FREE_LBL 256, "EXPLOSIONDATA8"
  EXPLOSIONDATA8   ; 240

  END_BANK 4

