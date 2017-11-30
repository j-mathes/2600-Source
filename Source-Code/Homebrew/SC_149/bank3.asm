; -----------------------------------------------------------------------------
; Star Castle Arcade - Atari 2600
; Copyright (C) 2012 Chris Walton (cd-w) <cwalton@gmail.com>
; Copyright (C) 2013 Thomas Jentzsch <tjentzsch@yahoo.de>
; Bank 3 - Ring Rotation & Gun Logic
; -----------------------------------------------------------------------------

  START_BANK "BANK3"
  TASK_VECTORS 3

; -----------------------------------------------------------------------------

  ; Update OFFSET Macro
  MAC UPDATE_OFFSET  ; ring
UpdateOffset{1}
  ; rotates first sector directly and other sectors relatively
  ldx OFFSET{1}                         ; [0] + 3      1st sector

 IF {1} = 2
  lda ringDirs                          ; [3] + 3
  and #RING2_DIR                        ; [6] + 2
  beq .normalDir                        ; [8] + 2/3
 ELSE
  bit ringDirs                          ; [3] + 3
  IF {1} = 0
  bpl .normalDir                        ; [6] + 2/3     RING0_DIR
  ELSE
  bvc .normalDir                        ; [6] + 2/3     RING1_DIR
  ENDIF
 ENDIF
;.reversedDir ; (1 ring)
  lda #<Ring{1}Data + SEC{1}_SIZE-1     ; [10] + 2      offset to end of sector
  ldy #<Ring{1}Position + SEC{1}_SIZE-1 ; [12] + 2
  inx                                   ; [14] + 2
  cpx #RING{1}_SIZE                     ; [16] + 2      always makes V = 0
  bcc .dirOK                            ; [18] + 2/3
  ldx #0                                ; [20] + 2      branch taken max. once/frame
  bcs .dirOK                            ; [22] + 3

.normalDir ; (2 rings)
  lda #<Ring{1}Data                     ; [11] + 2
  ldy #<Ring{1}Position                 ; [13] + 2
  dex                                   ; [15] + 2
  bpl .dirOK                            ; [17] + 2/3
  ldx #RING{1}_SIZE-1                   ; [19] + 2      branch taken max. once/frame
.dirOK
  stx OFFSET{1}                         ; [25] + 3
  ; use pointer to be able to add an offset
  sta pRingDataLo                       ; [28] + 3
  sta PRINGDATA                         ; [31] + 3
  sty pRingPosLo                        ; [34] + 3
  sty PRINGPOS                          ; [37] + 3
  txa                                   ; [40] + 2
; normal = 36/40; reversed = 38/42; average = 36/40.17; WORST = 36/42

  ; Setup Mask For Dotted Sectors
  lsr                                   ; [0] + 2       A = Offset{1} + 1
  lda #DOTTED_SEC                       ; [2] + 2
  bcs .evenOffset                       ; [4] + 2/3
  asl                                   ; [6] + 2
.evenOffset
  sta DOTTEDMASK                        ; [8] + 3
; WORST = 51/53 CYCLES (= 0.6 LINES) (per ring)
  ENDM

; -----------------------------------------------------------------------------

  MAC PREP_ROTATE_ODD ; ring
  ; use pointer to be able to add an offset
  lda #>Ring{1}Data                     ; [0] + 2
  sta PRINGDATA+1                       ; [2] + 3
  lda #>Ring{1}Position                 ; [5] + 2
  sta PRINGPOS+1                        ; [7] + 3
  ENDM

  MAC PREP_ROTATE_EVEN ; ring
  PREP_ROTATE_ODD {1}                  ; [0] + 10

  lda pRingDataLo                       ; [10] + 3
  sta PRINGDATA                         ; [13] + 3
  lda pRingPosLo                        ; [16] + 3
  sta PRINGPOS                          ; [19] + 3
  clv                                   ; [22] + 2      required for ROTATE!
  ENDM                                  ; = 24

; -----------------------------------------------------------------------------

  ; Rotate Ring X Macro
  MAC ROTATE                    ; 30 BYTES
  ; Y = offset
  ; There are only 3 values for SECTORMAP0/1/2:
  ; $00 = all filled
  ; $ff = all empty
  ; $55 = dotted -> on/off

  ; Calculate Ring Coordinate
  lax (PRINGPOS),Y              ; [0] + 5

  ; Check Sector Map
  lda SECTORMAP{1}_R + {2}      ; [5] + 4
  and DOTTEDMASK                ; [9] + 3

  ; Check For Add/Delete Pixel
RotateBranch{1}_{2}
  beq .sectorNotEmpty{1}        ; [12] + 2/3
  ; Delete Pixel
  lda (PRINGDATA),Y             ; [14] + 5
  and GRID_R,X                  ; [19] + 4
  bvc .endSector{1}             ; [23] + 3      V=0 (still from UPDATE_OFFSET or CLV!)
;  DEBUG_BRK

.sectorNotEmpty{1}
  ; Add Pixel
  lda (PRINGDATA),Y             ; [15] + 5
  eor #$ff                      ; [20] + 2      reverse pattern
  ora GRID_R,X                  ; [22] + 4
.endSector{1}
  PAGE_WARN_12 RotateBranch{1}_{2}, "RotateBranch?_?", {1}, {2}
  sta GRID_W,X                  ; [26] + 5
 ; Get next offset (except for last call)
 IF {3} = 0
  lda Ring{1}Offset,y           ; [31] + 4
  tay                           ; [35] + 2
 ENDIF
; WORST = 37/31 CYCLES (37*10+31*2 = 432 CYCLES = 5.8 LINES) (per ring, average 36)
  ENDM

  ; Rotate Ring 0 Macro
  MAC ROTATE0
  ROTATE 0, {1}, {2}            ; [] + 37 (31)
  ENDM

  ; Rotate Ring 1 Macro
  MAC ROTATE1
  ROTATE 1, {1}, {2}            ; [] + 37 (31)
  ENDM

  ; Rotate Ring 2 Macro
  MAC ROTATE2
  ROTATE 2, {1}, {2}            ; [] + 37 (31)
  ENDM

; -----------------------------------------------------------------------------

  MAC RING_OFFSETS
Ring{1}Offset
; defines previous*2 sector's offset
  LIST OFF
VAL SET RING{1}_SIZE - SEC{1}_SIZE*2
  REPEAT RING{1}_SIZE
  LIST ON
  .byte VAL
  LIST OFF
VAL SET VAL + 1
  IF VAL = RING{1}_SIZE
VAL SET 0
  ENDIF
  REPEND
  LIST ON
  ENDM

; -----------------------------------------------------------------------------

  MAC SEC_OFFSETS
Sector{1}End3
  LIST OFF
VAL SET 0
  REPEAT NUM_SECS
VAL SET VAL - SEC{1}_SIZE
  IF VAL < 0
VAL SET VAL + RING{1}_SIZE
  ENDIF
  LIST ON
  .byte VAL
  LIST OFF
  REPEND
  LIST ON
  ENDM

; -----------------------------------------------------------------------------

  MAC ClearSector ; ring
ClearSector{1}
  ; Get Starting Offset
  lda OFFSET{1}             ; [0] + 3
  sec                       ; [3] + 2
  sbc Sector{1}End3,x       ; [5] + 2
  bcs .ok1                  ; [7] + 2/3
  adc #RING{1}_SIZE         ; [9] + 2
.ok1
  tay                       ; [11] + 2
  ; Get Ending Offset
  sbc #SEC{1}_SIZE          ; [13] + 2
  bcs .ok2                  ; [15] + 2/3
  adc #RING{1}_SIZE         ; [--] + 2
.ok2
  sta COUNT                 ; [18] + 3  now: 21 (was: 15)

  ; X = sector to clear
  lda SECTORMAP{1}_R,X      ; [21] + 4
  cmp #CLEAR_SEC            ; [25] + 2      $ff
  bne .notClearSector       ; [27] + 2/3
  ; Decrease Sector Count & Set Score
  dec SECTORS               ; [29] + 5
.notClearSector

  ; Rotate SectorMap For Operation (Carry for Bit9 set here too)
  cmp #DOTTED_SEC           ; [34] + 2      $55
  bne .skipDotted           ; [36] + 2/3
  tya                       ; [38] + 2
  lsr                       ; [40] + 2      odd or even offset?
  lda #DOTTED_SEC << 1      ; [42] + 2
  bcs .skipDotted           ; [44] + 2/3
  lsr                       ; [46] + 2      -> DOTTED_SEC, C == 0
.skipDotted
  sta TEMPMAP               ; [48] + 3

  ; Iterate Sector Coordinates
ClearSector{1}Loop
  dey                       ; [0] + 2
  bpl .storeSector          ; [2] + 2/3
  ldy #RING{1}_SIZE-1       ; [-] + 2       max. taken once/loop
.storeSector
  ; Rotate Sector Map
  rol TEMPMAP               ; [5] + 5       9 bits max, carry only relevant in 1st loop

  ; Skip Deletion For Dotted Sectors
  bcc .skipSector           ; [10] + 2/3
  ; Fetch Sector Offset
  lda Ring{1}Data,y         ; [12] + 4
  ldx Ring{1}Position,y     ; [16] + 4
  and GRID_R,x              ; [20] + 4
  sta GRID_W,x              ; [24] + 5
.skipSector
  ; Next Iteration
  cpy COUNT                 ; [29] + 3
  bne ClearSector{1}Loop    ; [32] + 2/3
  PAGE_WARN_1 ClearSector{1}Loop, "ClearSector?Loop", {1}

; WORST CASE = 35 * 5/7/9/ + 2-1 + 51 = 227/297/367 (3.0/3.9/4.8 SCANLINES) (per frame?)
  ENDM


; *****************************************************************************

; -----------------------------------------------------------------------------
; Clear Sectors [393]
; -----------------------------------------------------------------------------

  START_TASK CheckSectorClear, 7+1, NO_SKIP, BulletRingCollisions
  ; only called from BulletRingCollisions if segment was hit
  ; loops back to BulletRingCollisions twice

  ; Branch To Clearing Routine
  lda BCLEAR                ; [0] + 3
  lsr                       ; [3] + 2
  bcc .skipClearSector1     ; [5] + 2/3
  lsr
  tax
  ClearSector 1             ; [] + 296
  beq .finishSectorClear1   ; [] +3

; -----------------------------------------------------------------------------
.skipClearSector1
  lsr                       ; [20] + 2
  tax                       ; [22] + 2
  bcc ClearSector0          ; [24] + 2/3

  ClearSector 2             ; [] + 226
.finishSectorClear1
  beq .finishSectorClear    ; [] +3

; -----------------------------------------------------------------------------
  ClearSector 0             ; [27] + 366

.finishSectorClear
  lda taskBits
  and #BULLET_TASK
  beq .bulletsDone
  END_TASK CheckSectorClear

.bulletsDone
  EXIT_TO_TASK MineRingCollisions


; -----------------------------------------------------------------------------
; Ring Explosion Part 1 [1460]
; -----------------------------------------------------------------------------
; the previous tasks have to make sure this is done in Overscan
;  (so that Gun1 can be done in VBLANK)

  START_TASK ExplodeGun0, 24, NO_SKIP, ExplodeGun1

  ldy gunExplodeIdx         ; [0] + 3 + 9
  bne .skipExplTransition   ; [3] + 2/3
  ; Check If Dead
  bit SHIPS                 ; [5] + 3
  bmi .skipExplosionUpdate  ; [8] + 2/3
  ; Score + Castle Mode
  lda #MODE_SCORE_CASTLE|SHIPS_CASTLE_TIM;[10] + 2
  sta MODE                  ; [12] + 3
  NOP_W                     ; [15] - 1
.skipExplTransition
  ; Update Explosion Counter
  dec gunExplodeIdx         ; [14] + 5
.skipExplosionUpdate
  lda GunExplodeDelay,y     ; [19] + 4
  sta gunExplodeDelay       ; [23] + 3
  ldx GunExplodeIdx,y       ; [26] + 4
  stx explodeGunId          ; [30] + 3

  ; Set Explosion Pointers (X = Frame)
  lda ExplodePtrLo+1,X      ; [33] + 4
  sta EXP0                  ; [37] + 3
  lda ExplodePtrLo+2,X      ; [40] + 4
  sta EXP1                  ; [44] + 3
  lda ExplodePtrLo+3,X      ; [47] + 4
  sta EXP2                  ; [51] + 3

  ; Set Explosion Pointers (X = Frame)
  lda ExplodePtrHi+1,X      ; [54] + 4
  sta EXP0+1                ; [58] + 3
  lda ExplodePtrHi+2,X      ; [61] + 4
  sta EXP1+1                ; [65] + 3
  lda ExplodePtrHi+3,X      ; [68] + 4
  sta EXP2+1                ; [72] + 3

; task continues here:
  JMP_TO_BANK ContExplodeGun0;[75] + 24


GunExplodeDelay = . - 1
    .byte   24
    .byte   6+0, 6+0, 6+0, 6+0, 6+0, 6+0, 6+0, 6+0, 6+0, 6+0, 6+0
    .byte   6+0
    .byte   2+0, 2+0, 2+0, 2+0, 2+0, 2+0, 2+0, 2+0, 2+0, 2+0, 2+0
  PAGE_WARN GunExplodeDelay, "GunExplodeDelay"

; -----------------------------------------------------------------------------
; SectorGaps [377]
; -----------------------------------------------------------------------------

  START_TASK CheckRegenerate, 6+1, NO_SKIP, RotateRing0Odd

  ; Check For Empty Outer Ring
 IF PHASED_REGEN
  ldy regenPhase                ; [0] + 3
  bne .phase1                   ; [3] + 2/3
                                ; TOTAL = 5/6
 ENDIF

  lda SECTORMAP0_R+0            ; [0] + 4
  and SECTORMAP0_R+1            ; [4] + 4
  and SECTORMAP0_R+2            ; [8] + 4
  and SECTORMAP0_R+3            ; [12] + 4
  and SECTORMAP0_R+4            ; [16] + 4
  and SECTORMAP0_R+5            ; [20] + 4
  and SECTORMAP0_R+6            ; [24] + 4
  and SECTORMAP0_R+7            ; [28] + 4
  and SECTORMAP0_R+8            ; [32] + 4
  and SECTORMAP0_R+9            ; [36] + 4
  and SECTORMAP0_R+10           ; [40] + 4
  and SECTORMAP0_R+11           ; [44] + 4
  eor #CLEAR_SEC                ; [48] + 2      all empty?
  beq .regenerateRing           ; [50] + 2/3
                                ; TOTAL = 53
  EXIT_TO_TASK CheckRingGap

; -----------------------------------------------------------------------------
; Regenerate Inner Ring
; -----------------------------------------------------------------------------
.regenerateRing
;   lsr disableGunKill           ;               allow fire again
 IF PHASED_REGEN
  ; *** Transfer ring 1 to ring 0 ***
.phase0
  inc regenPhase                ; [0] + 5
  ; Copy sectors of ring 1 to ring 0
  ldy #NUM_SECS-1               ; [5] + 2
Sector1CopyLoop
  lda SECTORMAP1_R,y            ; [0] + 4
  sta SECTORMAP0_W,y            ; [4] + 5
  lda #CLEAR_SEC                ; [9] + 2
  sta SECTORMAP1_W,y            ; [11] + 5
  dey                           ; [16] + 2
  bpl Sector1CopyLoop           ; [18] + 2/3
                                ; TOTAL = 7 + 21 * 12 - 1 = 258
  PAGE_WARN Sector1CopyLoop, "Sector1CopyLoop"

  ; Copy offset of ring 1 to ring 0
  ; OFFSET0 = OFFSET1 * 1.25 (~9/7 = 1.286)
  lda OFFSET1                   ; [0] + 3
  lsr                           ; [3] + 2
  lsr                           ; [5] + 2
  adc OFFSET1                   ; [7] + 3
  sta OFFSET0                   ; [10] + 3

  ; Save ring 0 direction and copy ring 1 direction to ring 0
  ; 012-xxxx -> 1120xxxx
  lda ringDirs                  ; [13] + 3
  bpl .skipReverse2_0           ; [16] + 2/3
  ora #RINGX_DIR                ; [18] + 2      copy old outer ring direction to new inner ring
  and <#~RING0_DIR              ; [20] + 2
.skipReverse2_0
  bit ringDirs                  ; [22] + 2
  bvc .skipReverse1_0           ; [24] + 2/3
  ora #RING0_DIR                ; [26] + 2
.skipReverse1_0
  sta ringDirs                  ; [28] + 3
                                ; TOTAL = 31

  ; wait for next phase until ring 1 is completely deleted
  lda OFFSET1                   ; [0] + 3
;  clc
  bvs .negDir1                  ; [3] + 2/3
  sbc #SEC1_SIZE-1              ; [5] + 2
  bcs .setOffset1               ; [7] + 2/3
  adc #RING1_SIZE               ; [9] + 2
  bcs .setOffset1               ; [11] + 3

.negDir1
  adc #SEC1_SIZE                ; [6] + 2
  cmp #RING1_SIZE               ; [8] + 2
  bcc .setOffset1               ; [10] + 2/3
  sbc #RING1_SIZE               ; [12] + 2
.setOffset1
  sta offsetX                   ; [14] + 3

  ; Save ring 0 color and copy ring 1 color to ring 0
  lda RINGCOL0                  ; [18] + 3
  sta ringColX                  ; [21] + 3
  lda RINGCOL1                  ; [24] + 3
  sta RINGCOL0                  ; [27] + 3
                                ; TOTAL = 30
  EXIT_TASK CheckRegenerate

  ; *** Transfer ring 2 to ring 1 ***
.phase1
  dey                           ; [6] + 2
  bne .phase2                   ; [8] + 2/3
  lda OFFSET1
  cmp offsetX
  beq .startPhase1
  END_TASK CheckRegenerate

.startPhase1
;  sty disableGunKill            ;               allow fire again
DEBUG1
  inc regenPhase                ; [] + 5

  ; Copy sectors of ring 2 to ring 1
  ldy #NUM_SECS-1               ; [0] + 2
Sector2CopyLoop
  lda SECTORMAP2_R,y            ; [0] + 4
  sta SECTORMAP1_W,y            ; [8] + 5
  lda #CLEAR_SEC                ; [22] + 2
  sta SECTORMAP2_W,y            ; [24] + 5
  dey                           ; [29] + 2
  bpl Sector2CopyLoop           ; [31] + 2/3
                                ; WORST = 34 * 12 + 1 = 409
  PAGE_WARN Sector2CopyLoop, "Sector2CopyLoop"

  ; Copy offset of ring 2 to ring 1
  ; OFFSET1 = OFFSET2 * 1.375 (~7/5 = 1.400)
  lda OFFSET2                   ; [39] + 3
  lsr                           ; [42] + 2
  lsr                           ; [44] + 2
  sta TEMP                      ; [46] + 3
  lsr                           ; [49] + 2
  adc TEMP                      ; [51] + 3
  adc OFFSET2                   ; [54] + 3
  sta OFFSET1                   ; [57] + 3

  ; Copy ring 2 direction to ring 1
  ; 1120xxxx -> 1220xxxx
  lda ringDirs                  ; [] + 3
  asl
  and <#~RING0_DIR
  tay
  ror
  cpy #RING1_DIR
  bcc .skipReverse1_1
  ora #RING1_DIR
.skipReverse1_1
  sta ringDirs                  ; [] + 3

  ; wait for next phase until ring 2 is completely deleted
  lda OFFSET2
  bcs .negDir2
.posDir2
  sbc #SEC2_SIZE-1
  bcs .setOffset2
  adc #RING2_SIZE
  bcs .setOffset2

.negDir2
  adc #SEC2_SIZE-1
  cmp #RING2_SIZE
  bcc .setOffset2
  sbc #RING2_SIZE
.setOffset2
  sta offsetX

  ; Copy ring 2 color to ring 1
  lda RINGCOL2                  ; [69] + 3
  sta RINGCOL1                  ; [72] + 3

  ; Transfer Speeds to new Rings (DONE: maybe one phase earlier? Nope!)
  lda ringSpeedIdx              ; [0] + 3
  cmp #RING_SPEEDS*(NUM_RINGS-1); [3] + 2
  bcc .contSpeedLoop            ; [5] + 2/3
  lda #<-(RING_SPEEDS+1)        ; [7] + 2
.contSpeedLoop
  adc #RING_SPEEDS              ; [9] + 2
  sta ringSpeedIdx              ; [11] + 3

  EXIT_TASK CheckRegenerate

  ; *** Regenerate ring 2 ***
.phase2
  lda OFFSET2                   ; [11] + 3
  eor offsetX                   ; [14] + 2
  beq .startPhase2              ; [16] + 2/3
;DEBUG2
;  dey
;  sty disableGunKill
  EXIT_TASK CheckRegenerate

.startPhase2
  lsr disableGunKill            ; [] + 5            allow gun kill after three shifts
  sta regenPhase                ; [19] + 3          == 0

  ldy #NUM_SECS-1               ; [22] + 2
;  lda #FULL_SEC                 ; [0] + 2
Sector2FillLoop
  sta SECTORMAP2_W,y            ; [0] + 5
  dey                           ; [5] + 2
  bpl Sector2FillLoop           ; [7] + 2/3
                                ; TOTAL = 10 * 12 - 1 = 119
  PAGE_WARN Sector2FillLoop, "Sector2FillLoop"

  ; Offset doesn't matter

  ; Copy remembered ring 0 direction to ring 2
  ; 1220xxxx -> 120-xxxx
  lda ringDirs                  ; [0] + 3
  asl                           ; [3] + 2
  and <#~RING0_DIR              ; [5] + 2
  bcc .skipReverse0_2           ; [7] + 2
  ora #RING0_DIR                ; [9] + 2
  clc                           ; [11] + 2
.skipReverse0_2
  sta ringDirs                  ; [13] + 3

  ; Copy remembered ring 0 color to ring 2
  lda ringColX                  ; [16] + 2
  sta RINGCOL2                  ; [18] + 3

  ; Increase Sector Count
;  clc
  lda SECTORS                   ; [21] + 3
  adc #NUM_SECS                 ; [24] + 2
  sta SECTORS                   ; [26] + 3
  EXIT_TASK CheckRegenerate

 ELSE ;{

  ldy #NUM_SECS-1           ; [0] + 2
SectorCopyLoop
  lda SECTORMAP1_R,y        ; [0] + 4
  sta SECTORMAP0_W,y        ; [8] + 5
  lda SECTORMAP2_R,y        ; [13] + 4
  sta SECTORMAP1_W,y        ; [17] + 5
  lda #FULL_SEC             ; [22] + 2
  sta SECTORMAP2_W,y        ; [24] + 5
  dey                       ; [29] + 2
  bpl SectorCopyLoop        ; [31] + 2/3
                            ; WORST = 34 * 12 + 1 = 409
  PAGE_WARN SectorCopyLoop, "SectorCopyLoop"

  ; experimental: clear inner ring (TODO: adjust timings and check for different options)
  lda GRID_R1+11
  and #%11110000
  sta GRID_W1+11
  lda GRID_R3+11
  and #%00001111
  sta GRID_W3+11
  lda GRID_R1+YRINGS-1-11
  and #%11110000
  sta GRID_W1+YRINGS-1-11
  lda GRID_R3+YRINGS-1-11
  and #%00001111
  sta GRID_W3+YRINGS-1-11
  lda #0
  sta GRID_W2+10
  sta GRID_W2+11
  sta GRID_W2+YRINGS-1-10
  sta GRID_W2+YRINGS-1-11
  ldy #YRINGS-1-24
.loopClear
  sta GRID_W1+12,y
  sta GRID_W3+12,y
  dey
  bpl .loopClear

  ; Transfer Speeds to new Rings
  lda ringSpeedIdx              ; [0] + 3
  cmp #RING_SPEEDS*(NUM_RINGS-1); [3] + 2
  bcc .contSpeedLoop            ; [5] + 2/3
  lda #<-(RING_SPEEDS+1)        ; [7] + 2
.contSpeedLoop
  adc #RING_SPEEDS              ; [9] + 2
  sta ringSpeedIdx              ; [11] + 3

  ; Transfer Directions to new Rings
  lda ringDirs                  ; [14] + 3
  asl                           ; [17] + 2
  bcc .skipReverse2             ; [19] + 2/3
  ora #RING2_DIR                ; [21] + 2      copy old outer ring direction to new inner ring
.skipReverse2
  sta ringDirs                  ; [23] + 3

  ; Transfer Offsets to new Rings
  ; OFFSET0 = OFFSET1 * 1.25 (~9/7 = 1.286)
  lda OFFSET1                   ; [26] + 3
  lsr                           ; [29] + 2
  lsr                           ; [31] + 2
  adc OFFSET1                   ; [33] + 3
  sta OFFSET0                   ; [36] + 3
  ; OFFSET1 = OFFSET2 * 1.375 (~7/5 = 1.400)
  lda OFFSET2                   ; [39] + 3
  lsr                           ; [42] + 2
  lsr                           ; [44] + 2
  sta TEMP                      ; [46] + 3
  lsr                           ; [49] + 2
  adc TEMP                      ; [51] + 3
  adc OFFSET2                   ; [54] + 3
  sta OFFSET1                   ; [57] + 3

  ; Transfer ring colors to new rings
  lda RINGCOL0                  ; [60] + 3
  ldy RINGCOL1                  ; [63] + 3
  sty RINGCOL0                  ; [66] + 3
  ldy RINGCOL2                  ; [69] + 3
  sty RINGCOL1                  ; [72] + 3
  sta RINGCOL2                  ; [75] + 3

  ; Increase Sector Count
  ; clc
  lda SECTORS                   ; [78] + 3
  adc #NUM_SECS                 ; [81] + 2
  sta SECTORS                   ; [83] + 3
  jmp CheckRegenerate           ; [86] + 3      make 100% sure that X (required for bank switching) is unchanged!
 ENDIF;}


; -----------------------------------------------------------------------------
; Rotate Ring 0 Odd; WORST: 79 + 228 = 307; MIN: 17
; -----------------------------------------------------------------------------

  START_TASK RotateRing0Odd, 6, NO_SKIP, RotateRing0Even
  SUBROUTINE

  ldx ringSpeedIdx          ; [0] + 3
  clc                       ; [3] + 2
  lda RING0COUNT            ; [5] + 3
  adc Ring0Speeds,X         ; [8] + 4
  sta RING0COUNT            ; [12] + 3
  bcs .doRotate0            ; [15] + 2/3
.exit
  EXIT_TO_TASK RotateRing1Odd

.doRotate0
  bit SHIPS
  bpl .cont
  lda SHIPEXP_FRAME
  beq .exit
.cont

  UPDATE_OFFSET  0          ; [18] + 51
  PREP_ROTATE_ODD 0         ; [69] + 10
                            ; WORST: 79
; -----------------------------------------------------------------------------
  ; start with odd sectors
  txa                       ; [0] + 2       x = OFFSET0
  sec                       ; [2] + 2
  sbc #SEC0_SIZE            ; [4] + 2
  bcs .ok                   ; [6] + 2/3
  adc #RING0_SIZE           ; [8] + 2
.ok
  tay                       ; [10] + 2
  ROTATE0 11, 0             ; [12] + 37
  ROTATE0 9, 0              ; [49] + 37
  ROTATE0 7, 0              ; [86] + 37
  ROTATE0 5, 0              ; [123] + 37
  ROTATE0 3, 0              ; [160] + 37
  ROTATE0 1, 1              ; [197] + 31
  END_TASK RotateRing0Odd   ; WORST: 228


; -----------------------------------------------------------------------------
; Rotate Ring 0 Even; WORST: 27 + 221 = 248
; -----------------------------------------------------------------------------

  START_TASK RotateRing0Even, 5, NO_SKIP, RotateRing1Odd
  ; adjust for even sectors
  lsr DOTTEDMASK            ; [0] + 5
  PREP_ROTATE_EVEN 0        ; [5] + 24
                            ; WORST: 29
; -----------------------------------------------------------------------------
  ldy OFFSET0               ; [0] + 3
  sec                       ; [3] + 2
  ROTATE0 0, 0              ; [5] + 37
  ROTATE0 10, 0             ; [42] + 37
  ROTATE0 8, 0              ; [79] + 37
  ROTATE0 6, 0              ; [116] + 37
  ROTATE0 4, 0              ; [153] + 37
  ROTATE0 2, 1              ; [190] + 31
  END_TASK RotateRing0Even


; -----------------------------------------------------------------------------
; Rotate Ring 1 Odd; WORST:
; -----------------------------------------------------------------------------

  START_TASK RotateRing1Odd, 6, NO_SKIP, RotateRing1Even
  SUBROUTINE

  ldx ringSpeedIdx
  clc                       ; [16] + 2
  lda RING1COUNT            ; [18] + 3
  adc Ring1Speeds,X         ; [21] + 4
  sta RING1COUNT            ; [25] + 3
  bcs .doRotate1            ; [28] + 2/3
.exit
  EXIT_TO_TASK RotateRing2Odd

.doRotate1
  bit SHIPS
  bpl .cont
  lda SHIPEXP_FRAME
  beq .exit
.cont

  UPDATE_OFFSET  1
  PREP_ROTATE_ODD 1         ; [9] + 10

; -----------------------------------------------------------------------------
  ; start with odd sectors
  txa
  sec
  sbc #SEC1_SIZE
  bcs .ok
  adc #RING1_SIZE
.ok
  tay
  ROTATE1 11, 0                ; [31] + 40
  ROTATE1 9, 0                 ; [71] + 40
  ROTATE1 7, 0                 ; [111] + 40*
  ROTATE1 5, 0                 ; [151] + 40
  ROTATE1 3, 0                 ; [191] + 40
  ROTATE1 1, 1                 ; [231] + 40
  END_TASK RotateRing1Odd      ; [271] + 24


; -----------------------------------------------------------------------------
; Rotate Ring 1 Even;
; -----------------------------------------------------------------------------

  START_TASK RotateRing1Even, 5, NO_SKIP, RotateRing2Odd
  PREP_ROTATE_EVEN 1
  ; adjust for even sectors
  lsr DOTTEDMASK
  ldy OFFSET1
  sec
  ROTATE1 0, 0
  ROTATE1 10, 0
  ROTATE1 8, 0
  ROTATE1 6, 0
  ROTATE1 4, 0
  ROTATE1 2, 1
  END_TASK RotateRing1Even


; -----------------------------------------------------------------------------
; Rotate Ring 2 Odd; WORST:
; -----------------------------------------------------------------------------

  START_TASK RotateRing2Odd, 6, NO_SKIP, RotateRing2Even
  SUBROUTINE

  ldx ringSpeedIdx
  clc                       ; [15] + 2
  lda RING2COUNT            ; [17] + 3
  adc Ring2Speeds,X         ; [20] + 4
  sta RING2COUNT            ; [24] + 3
  bcs DoRotate2             ; [27] + 2/3
.exit
  EXIT_TO_TASK Joystick ; DrawGun      ; [29] + ??

DoRotate2
  bit SHIPS
  bpl .cont
  lda SHIPEXP_FRAME
  beq .exit
.cont

  UPDATE_OFFSET  2
  PREP_ROTATE_Odd 2

; -----------------------------------------------------------------------------
  ; start with odd sectors
  txa
  sec
  sbc #SEC2_SIZE
  bcs .ok
  adc #RING2_SIZE
.ok
  tay
  ROTATE2 11, 0
  ROTATE2 9, 0
  ROTATE2 7, 0
  ROTATE2 5, 0
  ROTATE2 3, 0
  ROTATE2 1, 1
  END_TASK RotateRing2Odd


; -----------------------------------------------------------------------------
; Rotate Ring 2 Even; WORST:
; -----------------------------------------------------------------------------

  START_TASK RotateRing2Even, 5, NO_SKIP, Joystick; DrawGun
  PREP_ROTATE_EVEN 2
  ; adjust for even sectors
  lsr DOTTEDMASK
  ldy OFFSET2
  sec
  ROTATE2 0, 0
  ROTATE2 10, 0
  ROTATE2 8, 0
  ROTATE2 6, 0
  ROTATE2 4, 0
  ROTATE2 2, 1
  END_TASK RotateRing2Even


; -----------------------------------------------------------------------------
; Gun Rotation & Firing [66] + Draw [???]
; -----------------------------------------------------------------------------

;  START_TASK GunLogic, 2, NO_SKIP, MineLogic ; 30.7.2013
  START_TASK HandleGun, 5, SKIP_1, MineLogic ; 30.7.2013
  SUBROUTINE

; fire first, then rotate if not fired
; this avoids shots going through intact ring sectors

  ; Skip If Projectile Already Fired
  bit PROJDIR               ; [0] + 3
  bmi .notFireing           ; [3] + 2/3
  bvc .endProjectile        ; [5] + 2/3
.notFireing
  ; Check Hole In Centre Ring
  bit SHIPS                 ; [7] + 3           ship already exploding?
  bmi .endProjectile        ; [10] + 2/3
  ; Reset Breach
  lda SECTORS               ; [12] + 3          BREACH?
  bpl .endProjectile        ; [15] + 2/3
  and #<~BREACH_BIT         ; [17] + 2
  sta SECTORS               ; [19] + 3
  ; Fire Projectile
  lda GUNDIR                ; [22] + 3          allow for coarser targetting?
  sta PROJDIR               ; [25] + 3
  lda #MIDDLEX-4            ; [28] + 2
  sta PROJX_HI              ; [30] + 3
  lda #MIDDLEY-4            ; [33] + 2
  sta PROJY_HI              ; [35] + 3
  lda #NUM_PROJ_FRAMES-1    ; [38] + 2
  sta PROJFRAME             ; [40] + 3
  ; Firing Sound
  lda #SFX_FIRE_PROJ        ; [54] + 2
  cmp sfx1                  ; [56] + 3
  bcc .skipSound            ; [59] + 2/3
  sta sfx1                  ; [61] + 2
.skipSound
  lda #$0e                  ; [43] + 2
  sta projCol               ; [45] + 3
;;  ldx #0                    ; [38] + 2          #$80 ??? (nope!)
;  stx PROJX_LO              ; [48] + 3           x = 3 (good enough)
;  stx PROJY_LO              ; [51] + 3
  bpl .endGunLogic          ; [63] + 3
                            ; WORST = 66-6 CYCLES
.endProjectile
  ; Gun Rotation Speed
  ldy gameSpeed             ; [18] + 3      gun turning
  sec                       ; [21] + 2
  lda GUNCOUNT              ; [23] + 3
  adc GunSpeeds,Y           ; [26] + 4
  sta GUNCOUNT              ; [30] + 3
  lax GUNDIR                ; [33] + 3
  bcc .endGunLogic          ; [36] + 2/3    skip turning
  ; Rotate Gun To Face Ship
  sbc SHIPANGLE             ; [38] + 3
  beq .endGunLogic          ; [41] + 2/3    already facing at ship
  and #NUM_DIRS-1           ; [43] + 2
  cmp #NUM_DIRS/2           ; [45] + 2
  bcc .rotateAntiClockWise  ; [47] + 2/3
  inx                       ; [49] + 2
  NOP_B                     ; [51] + 0
.rotateAntiClockWise
  dex                       ; [51] + 2
  txa                       ; [53] + 2
  and #NUM_DIRS-1           ; [55] + 2
  sta GUNDIR                ; [57] + 3
                            ; WORST = 60 CYCLES
.endGunLogic
  JMP_TO_BANK ContHandleGun
;  END_TASK GunLogic


; -----------------------------------------------------------------------------
; Ring Gaps Data
; -----------------------------------------------------------------------------

  RING_OFFSETS 1
  RING_OFFSETS 2

  ; Explosion Pointers (Hi)
ExplodePtrHi
  DC.B  >Explode11_1, >Explode11_1, >Explode11_1, >Explode11_1, >Explode11_1 ; Blank
  DC.B  >Explode0_0, >Explode0_1, >Explode0_2, >Explode0_3, >Explode0_4
  DC.B  >Explode1_0, >Explode1_1, >Explode1_2, >Explode1_3, >Explode1_4
  DC.B  >Explode2_0, >Explode2_1, >Explode2_2, >Explode2_3, >Explode2_4
  DC.B  >Explode3_0, >Explode3_1, >Explode3_2, >Explode3_3, >Explode3_4
  DC.B  >Explode4_0, >Explode4_1, >Explode4_2, >Explode4_3, >Explode4_4
  DC.B  >Explode5_0, >Explode5_1, >Explode5_2, >Explode5_3, >Explode5_4
  DC.B  >Explode6_0, >Explode6_1, >Explode6_2, >Explode6_3, >Explode6_4
  DC.B  >Explode7_0, >Explode7_1, >Explode7_2, >Explode7_3, >Explode7_4
  DC.B  >Explode8_0, >Explode8_1, >Explode8_2, >Explode8_3, >Explode8_4
  DC.B  >Explode9_0, >Explode9_1, >Explode9_2, >Explode9_3, >Explode9_4
  DC.B  >Explode10_0, >Explode10_1, >Explode10_2, >Explode10_3, >Explode10_4
  DC.B  >Explode11_0, >Explode11_1, >Explode11_2, >Explode11_3, >Explode11_4
  DC.B  >Explode12_0, >Explode12_1, >Explode12_2, >Explode12_3, >Explode12_4
  DC.B  >Explode13_0, >Explode13_1, >Explode13_2, >Explode13_3, >Explode13_4
  DC.B  >Explode14_0, >Explode14_1, >Explode14_2, >Explode14_3, >Explode14_4
  DC.B  >Explode15_0, >Explode15_1, >Explode15_2, >Explode15_3, >Explode15_4

  DC.B  >Explode16_0, >Explode16_1, >Explode16_2, >Explode16_3, >Explode16_4
  DC.B  >Explode17_0, >Explode17_1, >Explode17_2, >Explode17_3, >Explode17_4
  DC.B  >Explode18_0, >Explode18_1, >Explode18_2, >Explode18_3, >Explode18_4
  DC.B  >Explode19_0, >Explode19_1, >Explode19_2, >Explode19_3, >Explode19_4
  DC.B  >Explode20_0, >Explode20_1, >Explode20_2, >Explode20_3, >Explode20_4
  DC.B  >Explode21_0, >Explode21_1, >Explode21_2, >Explode21_3, >Explode21_4
  DC.B  >Explode22_0, >Explode22_1, >Explode22_2, >Explode22_3, >Explode22_4

  PAGE_WARN ExplodePtrHi, "ExplodePtrHi"

; -----------------------------------------------------------------------------
; Game Data
; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "Ring0Data"

  ; Ring 0 - 108 bytes
  ; Pattern Index
Ring0Data
  DC.B  %11111110, %11111101, %11111011, %11110111
  DC.B  %11101111, %11011111, %10111111, %01111111
  DC.B  %11111110, %11111101, %11111011, %11110111
  DC.B  %11101111, %11101111, %11011111, %11011111

  DC.B  %10111111, %10111111, %10111111, %01111111
  DC.B  %01111111, %01111111, %01111111, %01111111
  DC.B  %01111111, %01111111, %01111111, %10111111
  DC.B  %10111111, %10111111, %11011111, %11011111

  DC.B  %11101111, %11101111, %11110111, %11111011
  DC.B  %11111101, %11111110, %01111111, %10111111
  DC.B  %11011111, %11101111, %11110111, %11111011
  DC.B  %11111101, %11111110, %01111111, %10111111

  DC.B  %11011111, %11101111, %11110111, %11111011
  DC.B  %11111101, %11111110, %01111111, %10111111
  DC.B  %11011111, %11101111, %11110111, %11111011
  DC.B  %11111101, %11111110, %01111111, %10111111

  DC.B  %11011111, %11101111, %11110111, %11110111
  DC.B  %11111011, %11111011, %11111101, %11111101
  DC.B  %11111101, %11111110, %11111110, %11111110
  DC.B  %11111110, %11111110, %11111110, %11111110

  DC.B  %11111110, %11111101, %11111101, %11111101
  DC.B  %11111011, %11111011, %11110111, %11110111
  DC.B  %11101111, %11011111, %10111111, %01111111
  DC.B  %11111110, %11111101, %11111011, %11110111

  DC.B  %11101111, %11011111, %10111111, %01111111
  DC.B  %11111110, %11111101, %11111011, %11110111
  DC.B  %11101111, %11011111, %10111111, %01111111
  ; repeat 1st sector (but 1)
  DC.B  %11111110, %11111101, %11111011, %11110111
  DC.B  %11101111, %11011111, %10111111, %01111111

  PAGE_ERROR Ring0Data, "Ring0Data table"

  ; Ring Positions (Y + X*40 Coordinates)
Ring0Position
  DC.B   1+GRID_D1,  1+GRID_D1,  1+GRID_D1,  2+GRID_D1
  DC.B   2+GRID_D1,  3+GRID_D1,  3+GRID_D1,  4+GRID_D1
  DC.B   5+GRID_D0,  6+GRID_D0,  7+GRID_D0,  8+GRID_D0
  DC.B   9+GRID_D0, 10+GRID_D0, 11+GRID_D0, 12+GRID_D0

  DC.B  13+GRID_D0, 14+GRID_D0, 15+GRID_D0, 16+GRID_D0
  DC.B  17+GRID_D0, 18+GRID_D0, 19+GRID_D0, 20+GRID_D0
  DC.B  21+GRID_D0, 22+GRID_D0, 23+GRID_D0, 24+GRID_D0
  DC.B  25+GRID_D0, 26+GRID_D0, 27+GRID_D0, 28+GRID_D0

  DC.B  29+GRID_D0, 30+GRID_D0, 31+GRID_D0, 32+GRID_D0
  DC.B  33+GRID_D0, 34+GRID_D0, 35+GRID_D1, 36+GRID_D1
  DC.B  36+GRID_D1, 37+GRID_D1, 37+GRID_D1, 38+GRID_D1
  DC.B  38+GRID_D1, 38+GRID_D1, 39+GRID_D2, 39+GRID_D2

  DC.B  39+GRID_D2, 39+GRID_D2, 39+GRID_D2, 39+GRID_D2
  DC.B  39+GRID_D2, 39+GRID_D2, 38+GRID_D3, 38+GRID_D3
  DC.B  38+GRID_D3, 37+GRID_D3, 37+GRID_D3, 36+GRID_D3
  DC.B  36+GRID_D3, 35+GRID_D3, 34+GRID_D4, 33+GRID_D4

  DC.B  32+GRID_D4, 31+GRID_D4, 30+GRID_D4, 29+GRID_D4
  DC.B  28+GRID_D4, 27+GRID_D4, 26+GRID_D4, 25+GRID_D4
  DC.B  24+GRID_D4, 23+GRID_D4, 22+GRID_D4, 21+GRID_D4
  DC.B  20+GRID_D4, 19+GRID_D4, 18+GRID_D4, 17+GRID_D4

  DC.B  16+GRID_D4, 15+GRID_D4, 14+GRID_D4, 13+GRID_D4
  DC.B  12+GRID_D4, 11+GRID_D4, 10+GRID_D4,  9+GRID_D4
  DC.B   8+GRID_D4,  7+GRID_D4,  6+GRID_D4,  5+GRID_D4
  DC.B   4+GRID_D3,  3+GRID_D3,  3+GRID_D3,  2+GRID_D3

  DC.B   2+GRID_D3,  1+GRID_D3,  1+GRID_D3,  1+GRID_D3
  DC.B   0+GRID_D2,  0+GRID_D2,  0+GRID_D2,  0+GRID_D2
  DC.B   0+GRID_D2,  0+GRID_D2,  0+GRID_D2,  0+GRID_D2
  ; repeat 1st sector (but 1)
  DC.B   1+GRID_D1,  1+GRID_D1,  1+GRID_D1,  2+GRID_D1
  DC.B   2+GRID_D1,  3+GRID_D1,  3+GRID_D1,  4+GRID_D1
  PAGE_ERROR Ring0Position, "Ring0Position table"

  ; Gun Movement Speeds
GunSpeeds
_VAL SET ((NUM_DIRS/2*2*256*256*SPEED_MULT+FPS/2)/FPS+MIN_GUN_TURN_SPEED/2)/MIN_GUN_TURN_SPEED

  REPEAT NUM_SPEEDS
    .byte (_VAL + 128)/256 - 1
  LIST OFF
_VAL SET (_VAL * GUN_TURN_FACTOR + FACTOR_MULT/2)/FACTOR_MULT
 IF (_VAL+128)/256 > 256
  LIST ON
    echo "WARNING @", ., ": GunSpeed too large! (", (_VAL+128)/256, "> 256)"
;    err
_VAL SET 256*256
 ENDIF
  LIST ON
    .byte (_VAL + 128)/256 - 1
  LIST OFF
  REPEND
  PAGE_WARN GunSpeeds, "GunSpeeds"

  ALIGN_FREE_LBL 256, "Ring1Data"

  ; Ring 1 - 84 bytes
  ; Pattern Index
Ring1Data
  DC.B  %01111111, %11111110, %11111101, %11111011, %11110111, %11101111, %11011111
  DC.B  %10111111, %01111111, %11111110, %11111110, %11111101, %11111101, %11111101
  DC.B  %11111011, %11111011, %11111011, %11111011, %11111011, %11111011, %11111011
  DC.B  %11111011, %11111101, %11111101, %11111101, %11111110, %11111110, %01111111
  DC.B  %10111111, %11011111, %11101111, %11110111, %11111011, %11111101, %11111110
  DC.B  %01111111, %10111111, %11011111, %11101111, %11110111, %11111011, %11111101
  DC.B  %11111110, %01111111, %10111111, %11011111, %11101111, %11110111, %11111011
  DC.B  %11111101, %11111110, %01111111, %01111111, %10111111, %10111111, %10111111
  DC.B  %11011111, %11011111, %11011111, %11011111, %11011111, %11011111, %11011111
  DC.B  %11011111, %10111111, %10111111, %10111111, %01111111, %01111111, %11111110
  DC.B  %11111101, %11111011, %11110111, %11101111, %11011111, %10111111, %01111111
  DC.B  %11111110, %11111101, %11111011, %11110111, %11101111, %11011111, %10111111
  ; repeat 1st sector (but 1)
  DC.B  %01111111, %11111110, %11111101, %11111011, %11110111, %11101111
  PAGE_ERROR Ring1Data, "Ring1Data table"

Ring1Position
  DC.B   5+GRID_D2,  6+GRID_D1,  6+GRID_D1,  7+GRID_D1,  7+GRID_D1,  8+GRID_D1,  9+GRID_D1
  DC.B  10+GRID_D1, 11+GRID_D1, 12+GRID_D0, 13+GRID_D0, 14+GRID_D0, 15+GRID_D0, 16+GRID_D0
  DC.B  16+GRID_D0, 17+GRID_D0, 18+GRID_D0, 19+GRID_D0, 20+GRID_D0, 21+GRID_D0, 22+GRID_D0
  DC.B  23+GRID_D0, 23+GRID_D0, 24+GRID_D0, 25+GRID_D0, 26+GRID_D0, 27+GRID_D0, 28+GRID_D1
  DC.B  29+GRID_D1, 30+GRID_D1, 31+GRID_D1, 32+GRID_D1, 32+GRID_D1, 33+GRID_D1, 33+GRID_D1
  DC.B  34+GRID_D2, 34+GRID_D2, 34+GRID_D2, 34+GRID_D2, 34+GRID_D2, 34+GRID_D2, 34+GRID_D2
  DC.B  34+GRID_D2, 33+GRID_D3, 33+GRID_D3, 32+GRID_D3, 32+GRID_D3, 31+GRID_D3, 30+GRID_D3
  DC.B  29+GRID_D3, 28+GRID_D3, 27+GRID_D4, 26+GRID_D4, 25+GRID_D4, 24+GRID_D4, 23+GRID_D4
  DC.B  23+GRID_D4, 22+GRID_D4, 21+GRID_D4, 20+GRID_D4, 19+GRID_D4, 18+GRID_D4, 17+GRID_D4
  DC.B  16+GRID_D4, 16+GRID_D4, 15+GRID_D4, 14+GRID_D4, 13+GRID_D4, 12+GRID_D4, 11+GRID_D3
  DC.B  10+GRID_D3,  9+GRID_D3,  8+GRID_D3,  7+GRID_D3,  7+GRID_D3,  6+GRID_D3,  6+GRID_D3
  DC.B   5+GRID_D2,  5+GRID_D2,  5+GRID_D2,  5+GRID_D2,  5+GRID_D2,  5+GRID_D2,  5+GRID_D2
  ; repeat 1st sector (but 1)
  DC.B   5+GRID_D2,  6+GRID_D1,  6+GRID_D1,  7+GRID_D1,  7+GRID_D1,  8+GRID_D1
  PAGE_ERROR Ring1Position, "Ring1Position table"

  ; Ring2 - 60 bytes
  ; Pattern Index
Ring2Data
  DC.B  %10111111, %01111111, %11111110, %11111101
  DC.B  %11111011, %11110111, %11101111, %11101111
  DC.B  %11101111, %11011111, %11011111, %11011111
  DC.B  %11011111, %11011111, %11011111, %11101111
  DC.B  %11101111, %11101111, %11110111, %11111011
  DC.B  %11111101, %11111110, %01111111, %10111111
  DC.B  %10111111, %11011111, %11101111, %11110111
  DC.B  %11111011, %11111101, %11111101, %11111110
  DC.B  %01111111, %10111111, %11011111, %11101111
  DC.B  %11110111, %11110111, %11110111, %11111011
  DC.B  %11111011, %11111011, %11111011, %11111011
  DC.B  %11111011, %11110111, %11110111, %11110111
  DC.B  %11101111, %11011111, %10111111, %01111111
  DC.B  %11111110, %11111101, %11111101, %11111011
  DC.B  %11110111, %11101111, %11011111, %10111111
  ; repeat 1st sector (but 1)
  DC.B  %10111111, %01111111, %11111110, %11111101
  PAGE_ERROR Ring2Data, "Ring2Data table"

  ALIGN_FREE_LBL 256, "Ring2Position"

Ring2Position
  DC.B  11+GRID_D2, 11+GRID_D2, 11+GRID_D1, 12+GRID_D1

  DC.B  13+GRID_D1, 14+GRID_D1, 15+GRID_D1, 16+GRID_D1
  DC.B  17+GRID_D1, 17+GRID_D1, 18+GRID_D1, 19+GRID_D1
  DC.B  20+GRID_D1, 21+GRID_D1, 22+GRID_D1, 22+GRID_D1
  DC.B  23+GRID_D1, 24+GRID_D1, 25+GRID_D1, 26+GRID_D1

  DC.B  27+GRID_D1, 28+GRID_D1, 28+GRID_D2, 28+GRID_D2

  DC.B  29+GRID_D2, 29+GRID_D2, 29+GRID_D2, 29+GRID_D2
  DC.B  29+GRID_D2, 29+GRID_D2, 28+GRID_D2, 28+GRID_D2

  DC.B  28+GRID_D3, 27+GRID_D3, 26+GRID_D3, 25+GRID_D3
  DC.B  24+GRID_D3, 23+GRID_D3, 22+GRID_D3, 22+GRID_D3
  DC.B  21+GRID_D3, 20+GRID_D3, 19+GRID_D3, 18+GRID_D3
  DC.B  17+GRID_D3, 17+GRID_D3, 16+GRID_D3, 15+GRID_D3
  DC.B  14+GRID_D3, 13+GRID_D3, 12+GRID_D3, 11+GRID_D3

  DC.B  11+GRID_D2, 11+GRID_D2, 10+GRID_D2, 10+GRID_D2
  DC.B  10+GRID_D2, 10+GRID_D2, 10+GRID_D2, 10+GRID_D2
  ; repeat 1st sector (but 1)
  DC.B  11+GRID_D2, 11+GRID_D2, 11+GRID_D1, 12+GRID_D1
  PAGE_ERROR Ring2Position, "Ring2Position table"

  ; Explosion Pointers (Lo)
  ; 17*5 (85 bytes)
ExplodePtrLo
  DC.B  <Explode11_1, <Explode11_1, <Explode11_1, <Explode11_1, <Explode11_1 ; Blank
  DC.B  <Explode0_0, <Explode0_1, <Explode0_2, <Explode0_3, <Explode0_4
  DC.B  <Explode1_0, <Explode1_1, <Explode1_2, <Explode1_3, <Explode1_4
  DC.B  <Explode2_0, <Explode2_1, <Explode2_2, <Explode2_3, <Explode2_4
  DC.B  <Explode3_0, <Explode3_1, <Explode3_2, <Explode3_3, <Explode3_4
  DC.B  <Explode4_0, <Explode4_1, <Explode4_2, <Explode4_3, <Explode4_4
  DC.B  <Explode5_0, <Explode5_1, <Explode5_2, <Explode5_3, <Explode5_4
  DC.B  <Explode6_0, <Explode6_1, <Explode6_2, <Explode6_3, <Explode6_4
  DC.B  <Explode7_0, <Explode7_1, <Explode7_2, <Explode7_3, <Explode7_4
  DC.B  <Explode8_0, <Explode8_1, <Explode8_2, <Explode8_3, <Explode8_4
  DC.B  <Explode9_0, <Explode9_1, <Explode9_2, <Explode9_3, <Explode9_4
  DC.B  <Explode10_0, <Explode10_1, <Explode10_2, <Explode10_3, <Explode10_4
  DC.B  <Explode11_0, <Explode11_1, <Explode11_2, <Explode11_3, <Explode11_4
  DC.B  <Explode12_0, <Explode12_1, <Explode12_2, <Explode12_3, <Explode12_4
  DC.B  <Explode13_0, <Explode13_1, <Explode13_2, <Explode13_3, <Explode13_4
  DC.B  <Explode14_0, <Explode14_1, <Explode14_2, <Explode14_3, <Explode14_4
  DC.B  <Explode15_0, <Explode15_1, <Explode15_2, <Explode15_3, <Explode15_4
  DC.B  <Explode16_0, <Explode16_1, <Explode16_2, <Explode16_3, <Explode16_4
  DC.B  <Explode17_0, <Explode17_1, <Explode17_2, <Explode17_3, <Explode17_4
  DC.B  <Explode18_0, <Explode18_1, <Explode18_2, <Explode18_3, <Explode18_4
  DC.B  <Explode19_0, <Explode19_1, <Explode19_2, <Explode19_3, <Explode19_4
  DC.B  <Explode20_0, <Explode20_1, <Explode20_2, <Explode20_3, <Explode20_4
  DC.B  <Explode21_0, <Explode21_1, <Explode21_2, <Explode21_3, <Explode21_4
  DC.B  <Explode22_0, <Explode22_1, <Explode22_2, <Explode22_3, <Explode22_4
  PAGE_WARN ExplodePtrLo, "ExplodePtrLo"

 IF <. > ($100-TOTAL_SECS)
  ALIGN_FREE_LBL 256, "SectorOffsets3"
 ENDIF

SectorOffsets3
  SEC_OFFSETS 0
  SEC_OFFSETS 1
  SEC_OFFSETS 2
  PAGE_WARN SectorOffsets3, "SectorOffsets3"

  ; Gun Explosion Frames (120+1 entries)
GunExplodeIdx
    .byte    0*5 ; extra index for simultaneous ship explosion
    .byte    0*5
    .byte   23*5, 22*5, 21*5, 20*5, 19*5, 18*5, 17*5, 16*5, 15*5, 14*5, 13*5
    .byte   12*5
    .byte   11*5, 10*5,  9*5,  8*5,  7*5,  6*5,  5*5,  4*5,  3*5,  2*5,  1*5
  PAGE_WARN GunExplodeIdx, "GunExplodeIdx"


  MAC SPEED
VAL SET (256*{2}*1000/(FPS*{1})+5)/10
   IF VAL > 255
VAL SET 255
   ENDIF
   LIST ON
    .byte VAL
  ENDM

  MAC SPEED0
   LIST OFF
    SPEED {1}, RING0_SIZE
  ENDM

  MAC SPEED1
   LIST OFF
    SPEED {1}, RING1_SIZE
  ENDM

  MAC SPEED2
   LIST OFF
    SPEED {1}, RING2_SIZE
  ENDM

  ; Castle Speed Table
; Arcade (outside to inside, speeds and directions move with rings outside):
; Game: (slow ring constant, other two în icrease speed with score)
; 470 (/1), 315 (/1.5), 235 (/2), 190 (/2.5)
;           <     >     <
; Speed 0: 4.75, 4.75, 3.17 /1.0;1.5
; Speed 1: 4.22, 4.75, 2.92 /1.125;1.625
; Speed 2: 3.80, 4.75, 2.71 /1.25;1.75
; Speed 3: 3.45, 4.75, 2.53 /1.375;1.875
; Speed 4: 3.17, 4.75, 2.38 /1.5;2
; Speed 5: 2.92, 4.75, 2.24 /1.625;2.125
; Speed 6: 2.71, 4.75, 2.11 /1.75;2.25
; Speed 7: 2.53, 4.75, 2.00 /1.875;2.375

  ALIGN_FREE_LBL 256, "Ring0Speeds"

Ring0Speeds ; 108
  SPEED0 475
  SPEED0 422
  SPEED0 380
  SPEED0 345
  SPEED0 317
  SPEED0 292
  SPEED0 271
  SPEED0 253

  SPEED0 475
  SPEED0 475
  SPEED0 475
  SPEED0 475
  SPEED0 475
  SPEED0 475
  SPEED0 475
  SPEED0 475

  SPEED0 317
  SPEED0 292
  SPEED0 271
  SPEED0 253
  SPEED0 238
  SPEED0 224
  SPEED0 211    ; PAL50 limit ~2.2
  SPEED0 200
  PAGE_WARN Ring0Speeds, "Ring0Speeds"

; -----------------------------------------------------------------------------

;  ALIGN_FREE_LBL 256, "Ring1Speeds"

Ring1Speeds ; 84
  SPEED1 475
  SPEED1 475
  SPEED1 475
  SPEED1 475
  SPEED1 475
  SPEED1 475
  SPEED1 475
  SPEED1 475

  SPEED1 317
  SPEED1 292
  SPEED1 271
  SPEED1 253
  SPEED1 238
  SPEED1 224
  SPEED1 211    ; PAL50 limit ~2.2
  SPEED1 200

  SPEED1 475
  SPEED1 422
  SPEED1 380
  SPEED1 345
  SPEED1 317
  SPEED1 292
  SPEED1 271
  SPEED1 253
  PAGE_WARN Ring1Speeds, "Ring1Speeds"

Ring2Speeds ; 60
  SPEED2 317
  SPEED2 292
  SPEED2 271
  SPEED2 253
  SPEED2 238
  SPEED2 224
  SPEED2 211    ; PAL50 limit ~2.2
  SPEED2 200

  SPEED2 475
  SPEED2 422
  SPEED2 380
  SPEED2 345
  SPEED2 317
  SPEED2 292
  SPEED2 271
  SPEED2 253

  SPEED2 475
  SPEED2 475
  SPEED2 475
  SPEED2 475
  SPEED2 475
  SPEED2 475
  SPEED2 475
  SPEED2 475
  PAGE_WARN Ring2Speeds, "Ring2Speeds"

  RING_OFFSETS 0

; -----------------------------------------------------------------------------
; Ring Explosion Part 2 [770]
; -----------------------------------------------------------------------------
; the previous task makes sure this is done in Vertical Blank

  START_TASK ExplodeGun1, 13, NO_SKIP, Joystick

  ldx explodeGunId          ; [9] + 3
  lda ExplodePtrLo+0,X      ; [12] + 4
  sta EXP0                  ; [16] + 3
  lda ExplodePtrLo+4,X      ; [19] + 4
  sta EXP1                  ; [23] + 3
  lda ExplodePtrHi+0,X      ; [26] + 4
  sta EXP0+1                ; [30] + 3
  lda ExplodePtrHi+4,X      ; [33] + 4
  sta EXP1+1                ; [37] + 3

; task continues here:
  JMP_TO_BANK ContExplodeGun1;[40] + 24

  END_BANK 3