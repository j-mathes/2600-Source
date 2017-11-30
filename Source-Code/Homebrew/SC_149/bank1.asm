; Bank 0:
; - Check for Pause Mode
; - Siren Sound (skipped if Gun explodes, should be done here)
; - Joystick Handler [283]
; x Move Sprites (Ship, Bullets, Projectile) [357]
; - Flicker Mines & Bullets [64]

; Bank 1:
; Old task order:
; x Mine Movements (abortable)
; - Bullet/Mine Collisions
; - Ship/Projectile Collision (skips to EnterKernel if Gun explodeds, if ship hit skips to Bullet/Ring/Gun Collision)
; - Ship/Ring Collision
; x Gun Rotation & Firing (abortable) (skips to EnterKernel if Gun explodeds)
; - Bullet/Ring/Gun Collision (exit to EnterKernel, Gun test skips to Mine Logic???)
; x Mine/Ring Collision
; x Mine Logic (abortable)

; New task order:
; - Bullet/Mine Collisions (now from previous frame)
; - Ship/Projectile Collision (if ship hit skips to Bullet/Ring/Gun Collision)
; - Ship/Ring Collision
; - Bullet/Ring/Gun Collision (if gun hit skips to Enterkernel)
; x Mine/Ring Collision (now from previous frame, abortable)
; x Mine Movements (abortable)
; x Gun Rotation & Firing (abortable)
; x Mine Logic (abortable) [??]

; Bank 2: [~10.6 * 64]
; - Setup Player Sprite (Ship & Projectile) [310]
; - Setup Missile Sprite (Bullets) [152]
; - Setup Ball Sprite (Mines) [161]
; - Setup Kernel Variables [56]

; TODO: fine tuning
; o test and adjust timer checks
; + mine phase handling
; + move code between banks 0..2
; + define priorities of tasks and reorder accordingly


; -----------------------------------------------------------------------------
; Star Castle Arcade - Atari 2600
; Copyright (C) 2012 Chris Walton (cd-w) <cwalton@gmail.com>
; Copyright (C) 2013 Thomas Jentzsch <tjentzsch@yahoo.de>
; Bank 1 - Mines, Collision Detection, Ring Gap Search & AA Logo
; -----------------------------------------------------------------------------

  START_BANK "BANK1"
  TASK_VECTORS 1
  ds    2, 0
LeaveStartup                        ; +18
  nop   BANK6                       ; switch to bank 6 (EndStartupScreen)
  jmp   EnterStartup                ; from bank 6 (ShowStartupScreen)

; -----------------------------------------------------------------------------

  MAC CheckBullet ; ring [~750]
  ; Check Bullet to Center Distances
CheckBullet
  ; Skip If No Bullet
  lda BULLETDIR,X                   ; [0] + 4
  bmi .endBulletCheck0              ; [4] + 2/3

  ; Store Bullet Coordinates
  stx TEMPBPOS                      ; [6] + 3

  ; Bullet Distance from Centre
  ldy BULLETY_HI,X                  ; [9] + 4
  lda BULLETX_HI,X                  ; [13] + 4
  jsr CentreDistance                ; [17] + 6 + 48

  ; Compare With Ring Radii
  bcs .endBulletCheck               ; [71] + 2/3    17^2
;  cmp #128                          ; [] + 2        17^2
;  bcc .bulletInsideRing0            ; [] + 2/3
;  bpl .bulletInsideRing0            ; [] + 2/3
  cmp #196;215                      ; [73] + 2      21/22^2
  bcs .endBulletCheck               ; [75] + 2/3
  ldy INTIM                         ; [77] + 4
  cpy #13                           ; [81] + 2      stressed @ 11.9.2013, changed from 12 to 13
  bcs .contBulletRingCollisions     ; [83] + 2/3
  ldx #BulletRingCollisions_BANK    ; [85] + 2
  jmp AbortTasks                    ; [87] + 3

.contBulletRingCollisions
  dec taskBits                      ; [86] + 5
  tay                               ; [91] + 2
  bpl .bulletInsideRing0            ; [93] + 2/3
  jmp BulletCollideRing0            ; [95] + 645

.bulletInsideRing0
  cmp #64                           ; [96] + 2       12^2
  bcs BulletCollideRing1            ; [98] + 2/3
  cmp #22                           ; [100] + 2       7^2
  bcc CollideGun                    ; [102] + 2/3
  jmp BulletCollideRing2            ; [104] + 645

.endBulletCheck
;  ldx TEMPBPOS                      ; [] + 3
.endBulletCheck0                    ; [74]
  ENDM

; -----------------------------------------------------------------------------

  MAC BulletCollideRing ; ring [641]
  ; Bullet Collision With Ring X
BulletCollideRing{1}
  ; Bullet Angle From Centre
  ldy TEMPBX                        ; [0] + 3
  lda TEMPBY                        ; [3] + 3
  jsr VectorAngleCenter             ; [6] + 159
  jsr CollideRing{1}                ; [165] + 371
  bpl .bulletCollide                ; [536] + 2/3
  jmp EndBulletCheck                ; [538] + 3

.bulletCollide
  ; A = SECTORMAP{1},y
  ; Y = hit sector
 IF L_DIFF_SINGLE ;{
  bne .skipDotted                   ; [0] + 2/3     $00 = FULL_SEC?
  lda #DOTTED_SEC                   ; [2] + 2       $55 = dotted sector
  bit difficulty                    ; [4] + 3
  bvs .skipClear                    ; [7] + 2/3
.skipDotted
  lda #CLEAR_SEC                    ; [9] + 2       $FF = clear sector
.skipClear
 ELSE ;}
  asl                               ; [0] + 2       $00 -> $55
  ora #DOTTED_SEC                   ; [2] + 2       $55 -> $ff (CLEAR_SEC)
 ENDIF
  sta SECTORMAP{1}_W,Y              ; [4] + 5
  tax                               ; [9] + 2       remember for sound
  tya                               ; [11] + 2
  asl                               ; [13] + 2
  asl                               ; [15] + 2
 IF {1} > 0
  ora #{1}                          ; [17] + 2      %00, %01, %10
 ENDIF
  sta BCLEAR                        ; [19] + 3      remember cleared sector and ring
  lda #({1}+1) << 4                 ; [22] + 2      scoring ($10, $20, $30)
  jmp ClearBullet                   ; [24] + 3 + X
  ENDM                              ; WORST = 566 + X

; -----------------------------------------------------------------------------

  MAC COLLIDE_RING ; ring
  ; A = direction
  ; Uses: TEMPX, TEMPY, TEMPBX, TEMPBY
  ; Returns:
  ;   N-Flag == 0 if collision found
  ;   Y = sector
  ; checks calculated sector and +/-1 sector
CollideRing{1}
  jsr DirToSectorA{1}               ; [0] + 77      TODO: remove JSR
  sty cxSector                      ; [77] + 3
.loop
  ; TODO: check if this experimental code helps
  lda SECTORMAP{1}_R,y              ; [2] + 4       CLEAR_SEC?
  bmi .noCollide

  lda OFFSET{1}                     ; [0] + 4
  sec                               ; [4] + 2
  sbc Sector{1}End1,y               ; [6] + 4
  bcs .ok                           ; [10] + 2/3
  adc #RING{1}_SIZE                 ; [12] + 2
.ok
  tax                               ; [14] + 2

  ; Calculate X Box
  lda Ring{1}XPosition+SEC{1}_SIZE,x; [0] + 4      requires extra 5-9 bytes at end of table
  ; sec
  sbc Ring{1}XPosition,x            ; [4] + 4
  bcc .reverseX                     ; [8] + 2/3
  adc #2                            ; [10] + 2      +3 inc carry
  sta tempXY                        ; [12] + 3
  lda Ring{1}XPosition,x            ; [15] + 4
  bne .testX                        ; [19] + 3

.reverseX
  eor #$FF                          ; [11] + 2
  adc #4                            ; [13] + 2      +1 for negation
  sta tempXY                        ; [15] + 3
  lda Ring{1}XPosition+SEC{1}_SIZE,x; [18] + 4
.testX
  ; Check X Overlap
  sbc TEMPBX                        ; [22] + 3
  sbc #2                            ; [25] + 2
  adc tempXY                        ; [27] + 3
  bcc .noCollide                    ; [30] + 2/3

  ; This part is executed max. 4/12 cases!
  ; Calculate Y Box
  lda Ring{1}YPosition+SEC{1}_SIZE,x; [-1] + 4      requires extra 5-9 bytes at end of table
  sbc Ring{1}YPosition,x            ; [3] + 4
  bcc .reverseY                     ; [7] + 2/3
  adc #2                            ; [9] + 2       +3 inc carry
  sta tempXY                        ; [11] + 3
  lda Ring{1}YPosition,x            ; [14] + 4
  bne .testY                        ; [18] + 3

.reverseY
  eor #$FF                          ; [10] + 2
  adc #4                            ; [12] + 2      +1 for negation
  sta tempXY                        ; [14] + 3
  lda Ring{1}YPosition+SEC{1}_SIZE,x; [17] + 4
.testY
  ; Check Y Overlap
  sbc TEMPBY                        ; [21] + 3
  sbc #2                            ; [24] + 2
  adc tempXY                        ; [26] + 3
; WORST
;   hit = 78 CYCLES
;   not = 49/78 CYCLES

  bcc .noCollide                    ; [0] + 2/3

;  tya
;  eor cxSector
;  beq .firstHit
;  lda #$42
;.firstHit
;  sta COLUBK

  lda SECTORMAP{1}_R,y              ; [2] + 4       CLEAR_SEC?
  rts                               ; [6] + 6

.noCollide
  cpy cxSector                      ; [3] + 3
  bne .skipNext                     ; [6] + 2/3
  ; 2. try next sector (~5%)
  iny                               ; [8] + 2
  cpy #NUM_SECS                     ; [10 + 2
  bcc .loop                         ; [12] + 2/3
  ldy #0                            ; [14] + 2
  bpl .loop                         ; [16] + 3      average ~16

.skipNext
  dey                               ; [9] + 2
  bpl .ok1                          ; [11] + 2/3
  ldy #NUM_SECS-1                   ; [13] + 2
.ok1
  cpy cxSector                      ; [15] + 3
  bne .done                         ; [18] + 2/3
  ; 3. try previous sector (~5%)
  dey                               ; [20] + 2
  bpl .loop                         ; [22] + 2/3
  ldy #NUM_SECS-1                   ; [24] + 2
  bpl .loop                         ; [26] + 3      average ~24

.done
  lda #$80                          ; [21] + 2
  rts                               ; [23] + 6
; WORST = 371 CYCLES
; AVERG = 170*90% + 264*5% + 366*5% = 185 CYCLES
  ENDM

; -----------------------------------------------------------------------------

  MAC DIR_TO_SECTOR ; ring
DirToSectorA{1}
  tax
DirToSector{1}
  ; find the sector (Y) for a given direction (X)
  lda DirOffset{1},x        ; [0] + 4
  sec                       ; [4] + 2
  sbc OFFSET{1}             ; [6] + 3
  bcs .dirOK                ; [9] + 2/3
  adc #RING{1}_SIZE         ; [11] + 2
.dirOK
  ; optimization: check if 1st or 2nd half
  sbc #RING{1}_SIZE/2       ; [13] + 2
  bcc .loIdx                ; [15] + 2/3
  ldy #NUM_SECS/2-1         ; [17] + 2
GapSearchHiLoop{1}
  iny                       ; [0] + 2
  sbc #SEC{1}_SIZE          ; [2] + 2
  bcs GapSearchHiLoop{1}    ; [4] + 2/3
  PAGE_WARN_1 GapSearchHiLoop{1}, "GapSearchHiLoop?", {1}
  bcc .idxFound             ; [19] + 3

.loIdx
  adc #RING{1}_SIZE/2       ; [18] + 2
  ldy #<-1                  ; [20] + 2
GapSearchLoLoop{1}
  iny                       ; [0] + 2
  sbc #SEC{1}_SIZE          ; [2] + 2
  bcs GapSearchLoLoop{1}    ; [4] + 2/3
  PAGE_WARN_1 GapSearchLoLoop{1}, "GapSearchLoLoop?", {1}
.idxFound
  rts                       ; [4] + 6
; WORST: 22 + 6 * 7 - 1 + 6 = 69 (0.9 SCANLINES)
  ENDM

  MAC GUN_DIR_SEARCH ; ring
  ; Search For Ring X Gap
  ; X = GUNDIR
  ; 1. find the sector the gun is pointing at
  jsr DirToSector{1}        ; [0] + 75

; CANCELLED: some correction for "late" shots
;  adc #SEC{1}_SIZE/2
;  bcc EndSearch
;  dex
;  bpl .sameSector
;  ldx #NUM_SECS-1
;.sameSector

  ; 2. check if sector is open
  lda SECTORMAP{1}_R,y      ; [75] + 4           CLEAR_SEC = $ff
  bpl EndGapSearch          ; [79] + 2/3
  ENDM

; -----------------------------------------------------------------------------

  MAC DIROFFSET ; ring
  ; Direction Conversion Table for Ring X
  ; Base formula: IDX * RING{1}_SIZE / NUM_DIRS
  ;   NUM_DIRS / 2 added for rounding
  ; (Note: The bigger the value, the earlier the gun shots)
DirOffset{1}
  LIST OFF
IDX SET NUM_DIRS / 2 - 1
  REPEAT NUM_DIRS
  LIST ON
  .byte  (IDX * RING{1}_SIZE + NUM_DIRS / 2) / NUM_DIRS ; - {1}
  LIST OFF
IDX SET IDX + 1
 IF IDX = NUM_DIRS
IDX SET 0
 ENDIF
  REPEND
  PAGE_WARN_1 DirOffset{1}, "DirOffset? table", {1}
  ENDM


; *****************************************************************************

; -----------------------------------------------------------------------------
; Bullet/Mine Collisions [274]
; -----------------------------------------------------------------------------

  START_TASK BulletMineCollisions, 5+1, NO_SKIP, BulletRingCollisions ; 22.7.2013

  ldy #NUM_BULLETS-1        ; [0] + 2       = 2
.bulletLoop
  lda BULLETDIR,Y           ; [0] + 4
  bmi .nextBullet           ; [4] + 2/3
  ; prevent shots kill mines approaching the ship from the side
  lda bulletTime,x          ; [] + 4
  cmp #BULLET_TIME-1        ; [] + 2
  bcs .nextBullet           ; [] + 2/3
;  clc                       ; [6] + 2
  ldx #NUM_MINES-1          ; [8] + 2       = 10
.mineLoop
  ; Only Check Homing Mines
  lda MINEDIR_R,X           ; [0] + 4
  bpl .nextMine             ; [4] + 2/3
  ; Check Region Overlap
  ; clc
  lda MINEX_HI_R,X          ; [6] + 4
  sbc BULLETX_HI,Y          ; [10] + 4
  sbc #2                    ; [14] + 2
  adc #4                    ; [16] + 2
  bcc .nextMine             ; [18] + 2/3
  ; clc
  lda MINEY_HI_R,X          ; [20] + 4
  sbc BULLETY_HI,Y          ; [24] + 4
  sbc #2                    ; [28] + 2
  adc #4                    ; [30] + 2
  bcs .bulletMineCollision  ; [32] + 2/3
.nextMine
  dex                       ; [34] + 2
  bpl .mineLoop             ; [36] + 2/3    INNER = 39*3 - 1 = 116
.nextBullet                 ;               WORST = 39*2+36+96 = 209
  ; Check remaining time
  lda INTIM                 ; [126] + 4     abort early in case of no more time left
  cmp #5                    ; [130] + 2
  bcc .endBulletMineCol     ; [132] + 2/3
  dey                       ; [134] + 2
  bpl .bulletLoop           ; [136] + 2/3   OUTER = 139*3 - 1 = 424

.endBulletMineCol           ; WORST = 232*3-1 = 695

  END_TASK BulletMineCollisions

.bulletMineCollision
  ; Mine Explode            ;               @394 max.
  lda #MINE_DEAD            ; [0] + 2       == 0
  sta MINEDIR_W,X           ; [2] + 4
  sta MINECOUNT_W,X         ; [6] + 4
;------------------------------------------------
  ; Display spark
  bit PROJDIR               ; [10] + 3
  bmi .unused               ; [13] + 2/3
  bvc .usedbyProj           ; [15] + 2/3    SPARK_FLAG?
.unused
  ; sec
  lda MINEX_HI_R,X          ; [17] + 4
  sbc #3                    ; [21] + 2
  bcs .setX                 ; [23] + 2/3
  adc #SCREEN_WIDTH         ; [25] + 2
.setX
  sta PROJX_HI              ; [27] + 3
  lda MINEY_HI_R,X          ; [30] + 4
  sbc #4                    ; [34] + 2
  bcs .setY                 ; [36] + 2/3
  adc #YSTART               ; [38] + 2
.setY
  sta PROJY_HI              ; [40] + 3
  lda #SPARK_FRAMES-1       ; [43] + 2
  sta PROJFRAME             ; [45] + 3
  lda #SPARK_FLAG           ; [47] + 2
  sta PROJDIR               ; [49] + 3
  lda MINECOL,X             ; [52] + 4
  sta projCol               ; [56] + 3
.usedbyProj
;------------------------------------------------
  ; Play Sound
  lda #SFX_BLLT_MINE        ; [59] + 2
  jsr StartSFX_1            ; [61] + 26
  ; Clear Bullet
  lda #$FF                  ; [87] + 2
  sta BULLETDIR,Y           ; [89] + 4
  bmi .nextBullet           ; [93] + 3      loop!
                            ; TOTAL = 96

; -----------------------------------------------------------------------------
; Ship Collisions [341]
; -----------------------------------------------------------------------------

  START_TASK ShipCollisions, 7, NO_SKIP, BulletMineCollisions ; 24.7.2013
  SUBROUTINE

; -----------------------------------------------------------------------------
; Ship/Projectile Collision
; -----------------------------------------------------------------------------

  ; Skip Projectile & Ring Collisions If Dead
  ldx SHIPS                 ; [0] + 3
  bpl .projectileCol        ; [3] + 2/3
  jmp .skipShipCheck        ; [5] + 3

.projectileCol
  ; Projectile Visible
  bit PROJDIR               ; [8] + 3
  bmi .endProjCollision     ; [11] + 2/3
  bvs .endProjCollision     ; [13] + 2/3     SPARK_FLAG
  ; Projectile Start Position
  ; projectile is mostly 8x8 outside the ring
  ; Check Overlap
  sec                       ; [15] + 2
  lda SHIPX_HI              ; [17] + 3
  sbc PROJX_HI              ; [20] + 3
  sbc #10                   ; [22] + 2
  adc #5+SHIP_SIZE          ; [24] + 2
  bcc .endProjCollision     ; [26] + 2/3
;  sec
  lda SHIPY_HI              ; [28] + 3
  sbc PROJY_HI              ; [31] + 3
  sbc #10                   ; [34] + 2
  adc #5+SHIP_SIZE          ; [36] + 2
 IF CHEAT
  jmp .endProjCollision
 ELSE
  bcc .endProjCollision     ; [38] + 2/3
 ENDIF
  ; Explode Ship
  txa                       ; [40] + 2
  ora #%10000000            ; [42] + 2
  sta SHIPS                 ; [44] + 3
  ldx #10*4                 ; [47] + 2
  stx SHIPEXP_FRAME         ; [49] + 3
  ; stop projectile
  sta PROJDIR               ; [52] + 3
  ; Play Sound
  lda #SFX_EXPL_SHIP        ; [55] + 2
  sta sfx0                  ; [57] + 3
  bne .endShipCheck         ; [60] + 3      who cares for exploding ships bumping? :)

.endProjCollision           ; WORST = 41 CYCLES

; -----------------------------------------------------------------------------
; Ship/Ring Collision
; -----------------------------------------------------------------------------

  ; Ship Angle From Centre
  ldy SHIPX_HI              ; [0] + 3
  lda SHIPY_HI              ; [3] + 3
  jsr VectorAngleCenter     ; [6] + 6 + 153
  sta SHIPANGLE             ; [165] + 3

  ; Disable Ring Bounce if Right Difficulty Set To A
  bit difficulty            ; [168] + 3
  bmi .endShipCheck         ; [171] + 2/3

  ; Ship Distance from Centre
  lda SHIPX_HI              ; [173] + 3
  ldy SHIPY_HI              ; [176] + 3
  jsr CentreDistanceB       ; [179] + 6 + 42 = 227

  ; Compare With Ring Radius
  bcs .endShipCheck         ; [0] + 2/3
  cmp #255-20               ; [2] + 2           24^2
  bcs .endShipCheck         ; [4] + 2/3
  ; Ship Inside Ring
  ; Update Ship Direction
  ldx SHIPANGLE             ; [6] + 3
  stx SHIPDIR_HI            ; [9] + 3
  lda #<-SHIP_VSPEED        ; [12] + 2
  sta SHIPVDIR              ; [14] + 3          ~45° off reversed direction

  ; Update Ship Speed (bounce out of ring)
  ldy #0                    ; [17] + 2
  lda KickShipX,X           ; [19] + 4
  sta SHIPVX_LO             ; [23] + 3
  bpl .posKickX             ; [26] + 2/3
  dey                       ; [28] + 2
.posKickX:
  sty SHIPVX_HI             ; [30] + 3
  ldy #0                    ; [33] + 2
  lda KickShipY,X           ; [35] + 4
  sta SHIPVY_LO             ; [39] + 3
  bpl .posKickY             ; [42] + 2/3
  dey                       ; [44] + 2
.posKickY:
  sty SHIPVY_HI             ; [46] + 3

  ; Play Sound
  lda #SFX_SHIP_RING        ; [49] + 2
  cmp sfx1                  ; [51] + 3
  bcc .endShipCheck         ; [54] + 2/3
  sta sfx1                  ; [56] + 2          only in channel 1, this avoids double sound
.endShipCheck

.skipShipCheck
  ; Skip Bullet Checks If Gun Is Exploding
  lda MODE                  ; [0] + 3
  cmp #MODE_EXPLOSION       ; [3] + 2
  bcc .gunNotExploding      ; [5] + 2/3
  ; update gun explosion animation frame delay
  dec gunExplodeDelay       ; [7] + 5
  bmi .nextExplosionFrame   ; [12] + 2/3
  EXIT_TO_TASK Joystick

.nextExplosionFrame
  EXIT_TO_TASK ExplodeGun0  ; WORST = 41 + 227 + 58 + 15 = 341 CYCLES

.gunNotExploding
  END_TASK ShipCollisions


; -----------------------------------------------------------------------------
; Bullet/Ring/Gun Collision [~762]
; -----------------------------------------------------------------------------

  BulletCollideRing 0       ; [] + 645
  BulletCollideRing 2       ; [] + 645
  BulletCollideRing 1       ; [] + 645

  START_TASK BulletRingCollisions, 3, NO_SKIP, CheckSectorClear ; 11.9.2013, changed from 2 to 3
; DONE:
; + check all bullets, even if the previous one is inside the ring
; x adjust usage of BCLEAR (also used for clearing segments)
; + use taskBits
; + also adjust CheckSectorClear
                                    ; [9]
  lda taskBits                      ; [0] + 3
  and #BULLET_TASK                  ; [3] + 2
  tax                               ; [5] + 2
  dex                               ; [7] + 2
  CheckBullet                       ; [9] + 74      or 575 + X
  dec taskBits                      ; [83] + 5
EndBulletCheck                      ;               @738
  lda taskBits                      ; [0] + 3
  and #BULLET_TASK                  ; [3] + 2
  beq .bulletsDone                  ; [5] + 2/3
  ; More bullets
  ldx #BulletRingCollisions_BANK    ; [7] + 2
  bpl BulletRingCollisions          ; [9] + 3
;  EXIT_TO_TASK BulletRingCollisions

.bulletsDone
  EXIT_TO_TASK MineRingCollisions


; -----------------------------------------------------------------------------

ClearBullet                 ;                   @580
  ; A = BCD score to add
  ldy #0                    ; [0] + 2
  jsr AddScore              ; [2] + 6 + 84
  cpx #CLEAR_SEC            ; [92] + 2          CLEAR_SEC?
  ldx TEMPBPOS              ; [94] + 3
  lda #$FF                  ; [97] + 2
  sta BULLETDIR,X           ; [99] + 4
  bcs .explodeSegment       ; [103] + 2/3
  ; some sound when segment gets 1st hit
  lda sfx1                  ; [] + 3
  bne .noHitSound           ; [] + 2/3
  lda #SFX_SECTOR_HIT       ; [] + 2
  sta sfx1                  ; [] + 3
  lda #$06                  ; [] + 2
  sta AUDC1                 ; [] + 3
.noHitSound
  bne EndBulletCheck        ; [] + 3

.explodeSegment
  ; hit spark
  ; check if sprite for hit spark is free
  bit PROJDIR               ; [106] + 2
  bmi .unused               ; [108] + 2
  bvc .usedbyProj           ; [110] + 2/3          SPARK_FLAG?
.unused
;  lda BULLETX_HI,x          ; [112] + 4
  lda TEMPBX
  sbc #4                    ; [116] + 2
  sta PROJX_HI              ; [118] + 3
;  lda BULLETY_HI,x          ; [121] + 4
  lda TEMPBY
  sbc #4                    ; [125] + 2
  sta PROJY_HI              ; [127] + 3
  lda #SPARK_FRAMES-1       ; [130] + 2
  sta PROJFRAME             ; [132] + 3
  lda #SPARK_FLAG           ; [135] + 2
  sta PROJDIR               ; [137] + 3
  lda BCLEAR                ; [140] + 3
  and #%11                  ; [143] + 2
  tax                       ; [145] + 2
  lda RINGCOLS,x            ; [147] + 4
  sta projCol               ; [151] + 3
.usedbyProj
  ; Play Sound
  lda #SFX_SECTOR_EXPL      ; [154] + 2
  jsr StartSFX_1            ; [156] + 6 + 20
                            ; WORST = 762

  END_TASK BulletRingCollisions

  ; Bullet Collision with Gun
CollideGun
  lda disableGunKill        ; [] + 3
  bne EndBulletCheck        ; [] + 2/3      gun kill is disabled while the castle is generated
  ; clc
  lda TEMPBX                ; [2] + 3
  sbc #MIDDLEX-3            ; [5] + 2
  sbc #7                    ; [7] + 2
  adc #8                    ; [9] + 2
  bcc EndBulletCheck        ; [11] + 2/3
  clc                       ; [13] + 2
  lda TEMPBY                ; [15] + 3
  sbc #MIDDLEY-3            ; [18] + 2
  sbc #7                    ; [20] + 2
  adc #8                    ; [22] + 2
  bcc EndBulletCheck        ; [24] + 2/3

  ; Set Gun Explosion Mode
  lda #MODE_EXPLOSION       ; [26] + 2
  sta MODE                  ; [28] + 3
  lda #EXPLODEFRAMES-1      ; [31] + 2
  sta gunExplodeIdx         ; [33] + 3

  ; Explosion Sound
  lda #SFX_GUN_EXPL         ; [] + 2        highest priority, always in channel 1
  sta sfx1                  ; [] + 3         siren continues, other sounds will stop
  ; Increment castle number
  ldx castle                ; [36] + 3
  inx
  cpx #MAX_CASTLES
  bcc .skipReset
  ldx #MAX_CASTLES-8        ;               repeat last 8 castles
.skipReset
  stx castle
  ; kill mines and bullets
  ldy #%00000000            ;               MINE_DEAD
  sty SECTORS               ; [] + 3        allow siren to increase during explosion
  sty MINEDIR               ; [] + 3
  sty MINEDIR+1             ; [] + 3
  sty MINEDIR+2             ; [] + 3
  dey                       ; [] + 2        = $ff
  sty BULLETDIR             ; [] + 3
  sty BULLETDIR+1           ; [] + 3
 IF NUM_BULLETS = 3
  sty BULLETDIR+2           ; [] + 3
 ENDIF
  sty gunExplodeDelay       ; [] + 3        negative!
  ; New Ship
  lda SHIPS                 ; [58] + 3
  and #%01111111            ; [61] + 2
  ; Max 99 Ships
  cmp #MAX_SHIPS-1          ; [63] + 2
  bcs .skipNewShip          ; [65] + 2/3
  inc SHIPS                 ; [67] + 5
.skipNewShip
  ; Increment Score
  lda #$40
  ldy #$14
  jsr AddScore              ; [] + 6 + 84
  EXIT_TO_TASK ExplodeGun0

AddScore SUBROUTINE
  ; Update Score (BCD Mode)
 IF TEST_FRAME_SKIP
  ldy #10
.delaySkip
  dey
  bne .delaySkip
 ELSE
  sed                       ; [0] + 2
  clc                       ; [2] + 2
  adc SCORE+0               ; [4] + 3
  sta SCORE+0               ; [7] + 3
  tya                       ; [10] + 2          0/14
  adc SCORE+1               ; [12] + 3
  sta SCORE+1               ; [15] + 3
  lda #0                    ; [18] + 2
  adc SCORE+2               ; [20] + 3
  sta SCORE+2               ; [23] + 3
  cld                       ; [26] + 2
; calculate game speed; difficulty = score/2000
  lsr                       ; [0] + 2           >= 20k?
  bne .maxSpeed             ; [2] + 2/3          yes, maximum speed
  lda SCORE+1               ; [4] + 3
  bcc .below10k             ; [7] + 2/3          < 10k!
  adc #$a0-1                ; [9] + 2
  bcs .maxSpeed             ; [11] + 2/3         >= 16k!
.below10k:
 IF L_DIFF_SINGLE = 0
  bit difficulty            ; [13] + 2
  bvc .skipHiDiff           ; [15] + 2/3
  adc #$80                  ; [17] + 2
  bcs .maxSpeed             ; [19] + 2/3
.skipHiDiff
 ENDIF
  lsr                       ; [21] + 2
  lsr                       ; [23] + 2
  lsr                       ; [25] + 2
  lsr                       ; [27] + 2
  NOP_W                     ; [29] + 2
.maxSpeed
  lda #NUM_SPEEDS*2-1       ; [31] + 2
.setSpeed
  sta gameSpeed             ; [33] + 3
; calculate ring speeds
  cmp #RING_SPEEDS          ; [36] + 2
  bcc .ok                   ; [38] + 2/3
  lda #RING_SPEEDS-1        ; [40] + 2
.ok
  eor ringSpeedIdx          ; [42] + 2
  and #%111                 ; [44] + 2
  eor ringSpeedIdx          ; [46] + 2
  sta ringSpeedIdx          ; [48] + 2
 ENDIF
  rts                       ; [50] + 6
                            ; WORST: 28 + 56 = 84

; -----------------------------------------------------------------------------
; Mine/Ring Collision [~679]
; -----------------------------------------------------------------------------

  START_TASK MineRingCollisions, 11+1, NO_SKIP, MoveMines

  ; Only Check Homing Mines
  ldx MPHASE                ; [0] + 3
  lda MINEDIR_R,X           ; [3] + 4
  cmp #MINE_HOMING          ; [7] + 2
  bcc .endMineCheckJmp      ; [9] + 2/3

  ; Mine Coordinates
  ldy MINEY_HI_R,X          ; [11] + 4
  lda MINEX_HI_R,X          ; [15] + 4

  ; Mine Distance from Centre
  jsr CentreDistance        ; [19] + 54
  ldx MPHASE                ; [73] + 3

  ; Compare With Ring Radii
  bcs .mineOutsideRings     ; [76] + 2/3
  cmp #114                  ;               16^2
  bcc .mineInsideRing0      ;
  cmp #178+1                ; [80] + 2      20^2
  bcs .mineOutsideRings     ; [82] + 2/3
  bcc .mineCollideRing0     ; [84] + 2/3

.mineInsideRing0
  cmp #64                   ; [85] + 2      12^2
  bcs .mineCollideRing1     ; [87] + 2/3
  cmp #22                   ; [89] + 2       7^2
  bcs .mineCollideRing2     ; [91] + 2/3
  ; Mine At Centre
  lda RINGCOL2
  bne .setMineCol2

.mineOutsideRings
  ldy COLMODE
  lda MineCols,Y
.setMineCol2
  sta MINECOL,X
.endMineCheckJmp
  jmp .endMineCheck

; -----------------------------------------------------------------------------

.mineCollideRing0
  lda RINGCOL0                  ; [87] + 3
  jsr VectorAngleCenterMineCol  ; [90] + 172
  jsr CollideRing0              ; [262] + 377
  bmi .endMineCol               ; [639] + 2/3
  ; Attach Mine To Ring 0
  tya                           ; [641] + 2
  ora #MINE_RING0               ; [643] + 2
  bne .setMinePhase             ; [645] + 3

.mineCollideRing1
  lda RINGCOL1                  ; [90] + 3
  jsr VectorAngleCenterMineCol  ; [] + 172
  jsr CollideRing1
  bmi .endMineCol               ; [] + 2/3
  ; Attach Mine To Ring 1
  tya                           ; [] + 2
  ora #MINE_RING1
  bne .setMinePhase

.mineCollideRing2
  lda RINGCOL2                  ; [94] + 3
  jsr VectorAngleCenterMineCol  ; [97] + 172
  jsr CollideRing2              ; [269] + 377
  bmi .endMineCol               ; [646] + 2/3
  ; Attach Mine To Ring 2
  tya                           ; [648] + 2
  ora #MINE_RING2               ; [650] + 2
.setMinePhase                   ;
  ldx MPHASE                    ; [0] + 3
  sta MINEDIR_W,X               ; [3] + 4
.endMineCol
.endMineCheck

  END_TASK MineRingCollisions


; -----------------------------------------------------------------------------
; Mine Movements [372]
; -----------------------------------------------------------------------------

  START_TASK MoveMines, 6+1, NO_SKIP, HandleGun ; GunLogic
  SUBROUTINE

  ; Mine Speed Table Offset (Increase every 2000 points, 0..7)
  lda gameSpeed             ; [0] + 3       mine speed
  and #%00011110            ; [3] + 2
;  asl                       ; [3] + 2
  asl                       ; [5] + 2
  asl                       ; [7] + 2
  asl                       ; [9] + 2
  sta TEMP                  ; [11] + 3      n*16

  ; Iterate Mines
  ldx #NUM_MINES-1          ; [14] + 2
.moveMineLoop
  ; Check For Homing Mine
  lda MINEDIR_R,X           ; [0] + 4
  cmp #MINE_HOMING          ; [4] + 2
  ; Calc Sector/Direction
  and #MINE_DIR_MASK        ; [6] + 2
  tay                       ; [8] + 2
  bcc .ringMine             ; [10] + 2/3

  ; Store Direction
  sta TEMP2                 ; [12] + 3

  ; Calculate X Table Index
  lda MineXIndex,Y          ; [15] + 4
  bmi .skipMineX            ; [19] + 2/3
  clc                       ; [21] + 2
  adc TEMP                  ; [23] + 3
  tay                       ; [26] + 2
  ; Move Mine X
  ; clc
  lda MineSpeedLo,Y         ; [28] + 4
  adc MINEX_LO_R,X          ; [32] + 4
  sta MINEX_LO_W,X          ; [36] + 5--
  lda MineSpeedHi,Y         ; [41] + 4
  bpl .posMineX             ; [45] + 2/3
  adc MINEX_HI_R,X          ; [47] + 4
  bcs .storeMineX           ; [51] + 2/3
  lda #SCREEN_WIDTH-1       ; [53] + 2      mine wraps around
  bne .storeMineX           ; [55] + 3

.posMineX
  adc MINEX_HI_R,X          ; [48] + 4
  cmp #SCREEN_WIDTH         ; [52] + 2
  bcc .storeMineX           ; [54] + 2/3
  lda #0                    ; [56] + 2      mine wraps around
.storeMineX
  sta MINEX_HI_W,X          ; [58] + 5--
.skipMineX

  ; Calculate Y Table Index
  ldy TEMP2                 ; [63] + 3
  lda MineYIndex,Y          ; [66] + 4
  bmi .skipMineY            ; [70] + 2/3
  clc                       ; [72] + 2
  adc TEMP                  ; [74] + 3
  tay                       ; [77] + 2
  ; Move Mine Y
  ; clc
  lda MineSpeedLo,Y         ; [79] + 4
  adc MINEY_LO_R,X          ; [83] + 4
  sta MINEY_LO_W,X          ; [87] + 5--
  lda MineSpeedHi,Y         ; [92] + 4
  bpl .posMineY             ; [96] + 2/3
  adc MINEY_HI_R,X          ; [98] + 4
  bcs .storeMineY           ; [102] + 2/3
  lda #YSTART-1             ; [104] + 2     mine wraps around
  bne .storeMineY           ; [106] + 3

.posMineY
  adc MINEY_HI_R,X          ; [99] + 4
  cmp #YSTART               ; [103] + 2
  bcc .storeMineY           ; [105] + 2/3
  lda #0                    ; [107] + 2     mine wraps around
.storeMineY
  sta MINEY_HI_W,X          ; [109] + 5--
.skipMineY
.nextMine
  dex                       ; [114] + 2
  bpl .moveMineLoop         ; [116] + 2/3
; was: WORST = 130*3.1 = 389 = 5.1 SCANLINES
; now: WORST = 119*3-1 = 356 = 4.7 SCANLINES

  END_TASK MoveMines

; -----------------------------------------------------------------------------

  ; Mine Ring Movements
.ringMine
  ; Y = sector
  eor MINEDIR_R,X                   ; [13] + 4
  bmi .nextMine                     ; [17] + 2/3    Skip Exploding Mine
;  and #%11100000                    ; [19] + 2
  beq .nextMine                     ; [17] + 2/3    Skip Unspawned Mine
  cmp #MINE_RING1                   ; [19] + 2
  beq .mineRing1                    ; [21] + 2/3
  bcs .mineRing2                    ; [23] + 2/3
;.mineRing0
  lda OFFSET0                       ; [25] + 3
  sec
  sbc Sector0End1,Y
  bcs .ok0
  adc #RING0_SIZE
.ok0
  tay                               ; [29] + 2
  lda Ring0XPosition+SEC0_SIZE/2,Y  ; [31] + 4
  sta MINEX_HI_W,X                  ; [35] + 5--
  lda Ring0YPosition+SEC0_SIZE/2,Y  ; [40] + 4
  bne .storeMineY                   ; [44] + 3

.mineRing1
  lda OFFSET1                       ; [25] + 4
  ; sec
  sbc Sector1End1,Y
  bcs .ok1
  adc #RING1_SIZE
.ok1
  tay                               ; [28] + 2
  lda Ring1XPosition+SEC1_SIZE/2,Y  ; [30] + 4
  sta MINEX_HI_W,X                  ; [34] + 5--
  lda Ring1YPosition+SEC1_SIZE/2,Y  ; [39] + 4
  bne .storeMineY                   ; [43] + 3

.mineRing2
  lda OFFSET2                       ; [25] + 3
  ; sec
  sbc Sector2End1,Y
  bcs .ok2
  adc #RING2_SIZE
.ok2
  tay                               ; [30] + 2
  lda Ring2XPosition+SEC2_SIZE/2,Y  ; [32] + 4
  sta MINEX_HI_W,X                  ; [36] + 5--
  lda Ring2YPosition+SEC2_SIZE/2,Y  ; [41] + 4
  bne .storeMineY                   ; [45] + 3


; -----------------------------------------------------------------------------
; Mine Logic [325]
; -----------------------------------------------------------------------------

  START_TASK MineLogic, 7, NO_SKIP, CheckRegenerate

  ; Extract Direction/Sector
  ldx MPHASE                ; [0] + 3
  lda MINEDIR_R,X           ; [3] + 4
  tay
  and #MINE_DIR_MASK        ; [7] + 2
  sta CURRSECTOR            ; [9] + 3

  ; Decrement Mine Counter
  lda MINECOUNT,X           ; [12] + 4
  beq .skipMineCounter      ; [16] + 2/3
  lda taskCycle
  and #%11                  ;               every 4th frame
  bne .skipMineCounter
  dec MINECOUNT,X           ; [12] + 4
  beq .expireMine           ; [16] + 2/3
  tya                       ; [27] + 2      MINE_HOMING?
  bpl .nonHoming            ; [29] + 2/3
  dec MINECOUNT,X           ; [12] + 4      decrement twice while homing
  beq .expireMine           ; [16] + 2/3
.skipMineCounter

  ; Check For Phase 0 to 3
  tya                       ; [27] + 2      MINE_HOMING?
  bpl .nonHoming            ; [29] + 2/3
  jmp .minePhase4           ; [41] + 3      homing mine

  ; Expire Mine
.expireMine
  lda #0                    ;               == MINE_DEAD
  sta MINEDIR_W,X
  sta MINECOL,X
.endMineLogicA
  jmp .endMineLogic

.nonHoming
  ; Check For Phase 0
  and #MINE_MODE_MASK       ; [32] + 2
  bne .notMinePhase0        ; [34] + 2/3
  ; mine phase 0
  ; spread initial mine spawn
  lda MINECOUNT_R,X
  bne .endMineLogicB
  ; create new mine
  lda GUNDIR
  sec
  sbc #NUM_DIRS/4
  and #NUM_DIRS-1
  ; Change to Phase 4
  ora #MINE_HOMING
  sta MINEDIR_W,X
  ; Set To Centre Position
  lda #MIDDLEX
  sta MINEX_HI_W,X
  lda #MIDDLEY
  sta MINEY_HI_W,X
  ; Mine Expire Counter
  lda #MINE_TIME
  sta MINECOUNT_W,X
  ; Mine Colour
  lda RINGCOL2
  sta MINECOL,X
 IF SONAR_EVENT ;{
  lda #SFX_SONAR
  cmp sfx1
  bcc .skipSfx
  sta sfx1
.skipSfx
 ENDIF ;}

.endMineLogicB
  jmp .endMineLogic

.notMinePhase0
  ; Mine Angle From Centre
  jsr VectorAngleCenterMine ; [22] + 143
  sta MINEANGLE             ; [200-35] + 3
  ; check if mine's current sector is empty
  ldx MPHASE                ; [203] + 3
  lda MINEDIR_R,X           ; [206] + 4
  ldy CURRSECTOR            ; [210] + 3
  and #MINE_MODE_MASK       ; [213] + 2
  sta TEMP
  cmp #MINE_RING1           ; [215] + 2
  beq .minePhase2           ; [217] + 2/3
  bcs .minePhase3           ; [219] + 2/3
;.minePhase1
  lda SECTORMAP0_R,Y        ; [221] + 4
  bcc .checkSector          ; [225] + 3

.minePhase2
  lda SECTORMAP1_R,Y        ; [220] + 4
  bcs .checkSector          ; [224] + 3

.minePhase3
  lda SECTORMAP2_R,Y        ; [222] + 4
.checkSector
;  cmp #CLEAR_SEC            ; [228] + 2     = $ff
;  beq .kickMineOut          ; [230] + 2/3
  bmi .kickMineOut
.minePhase123

  ; Mine kick delay table offset (chance increases at 1000 and then every 2000 points)
  lda taskCycle
  and #$07
  bne .endMineLogicC

  ldy gameSpeed             ; [] + 3        kick mine
  lda RANDOM                ; [] + 3
  cmp MineKickChance,Y      ; [] + 5
  bcs .endMineLogicC        ; [4] + 2/3
  ; allow mines at outer ring to be kicked inside again
  ldy TEMP
  cpy #MINE_RING1           ; [] + 2        don't kick mine in if at two inner rings
  bcs .kickMineOut
  eor taskCycle
  lsr                       ;
  bcs .kickMineOut
  lda MINEANGLE             ; [6] + 3
  eor #NUM_DIRS/2
  bpl .kickMineIn           ; [] + 3

.kickMineOut
  ; Change to Phase 4
  lda MINEANGLE             ; [6] + 3
.kickMineIn
  tay
  ora #MINE_HOMING          ; [9] + 2
  sta MINEDIR_W,X           ; [11] + 5--
  ; Kick Mine From Ring
  clc                       ; [16] + 2
  lda MINEX_LO_R,X          ; [18] + 4
  adc KickLoX,Y             ; [22] + 4
  sta MINEX_LO_W,X          ; [26] + 5--
  lda MINEX_HI_R,X          ; [31] + 4
  adc KickHiX,Y             ; [35] + 4
  sta MINEX_HI_W,X          ; [39] + 5--
  clc                       ; [44] + 2
  lda MINEY_LO_R,X          ; [46] + 4
  adc KickLoY,Y             ; [50] + 4
  sta MINEY_LO_W,X          ; [54] + 5--
  lda MINEY_HI_R,X          ; [59] + 4
  adc KickHiY,Y             ; [63] + 4
  sta MINEY_HI_W,X          ; [68] + 5--
 IF SONAR_EVENT ;{
  ; start sound
  lda #SFX_SONAR
  cmp sfx1
  bcc .skipSfxB
  sta sfx1
.skipSfxB
 ENDIF ;}
.endMineLogicC
  jmp .endMineLogic         ; [80] + 3
; TOTAL: 36 + 232 + 83 = 351

  ; Homing mine
.minePhase4
  ; Mine turning Speed Table Offset (increases every 2000 points, 0..7)
  lda gameSpeed             ; [0] + 3   mine turning
  lsr                       ; [3] + 2
  tay                       ; [5] + 2
  lda MineTurnSpeed,y       ; [7] + 4   variable mine turning speed with some randomization
  cmp RANDOM                ; [11] + 2
  bcc .endMineLogic         ; [13] + 2

  ; Calculate Ship Angle From Mine
  ; sec
  lda SHIPX_HI              ; [0] + 3
  sbc MINEX_HI_R,X          ; [3] + 4
  ; prevent mines from wrapping due to 8 bit overflow
  bmi .negDx                ; [7] + 2/3
  bcs .setDx                ; [9] + 2/3
  lda #$80                  ; [11] + 2
;  bne .setDx                ; [13] + 3
.negDx
  bcc .setDx                ; [10] + 2/3
  lda #$7f                  ; [12] + 2
.setDx
  sta TEMPX                 ; [16] + 3
 IF SONAR_DELTA
  ; calculate distance to ship
  bmi .endLeftCheck         ; [4] + 2/3
  eor #$ff                  ; [6] + 2
  clc                       ; [] + 2
  adc #1                    ; [8] + 2
.endLeftCheck
  sta TEMPY                 ; [10] + 2
 ENDIF
  sec                       ; [13] + 2
  lda SHIPY_HI              ; [15] + 3
  sbc MINEY_HI_R,X          ; [18] + 4--
 IF SONAR_DELTA
  tay
  bcc .endDownCheck         ; [18] + 2/3
  eor #$ff                  ; [20] + 2
  adc #0                    ; [22] + 2
.endDownCheck
  adc TEMPY
  sty TEMPY                 ; [22] + 3
  ror
  ; lower distances have MUCH more weight than far away ones
  cmp #256-96               ; distance < 96?
  bcs .notFar
  lsr
.notFar
  cmp #256-48               ; distance < 48?
  bcs .notMedium
  lsr
.notMedium
  cmp #256-24               ; distance < 24?
  bcs .notClose
  lsr
.notClose
  lsr
  lsr
  adc mineSfxSum_R
  sta mineSfxSum_W
  bcc .skipSonar
  lda #SFX_SONAR
  cmp sfx1
  bcc .trySfx0
  sta sfx1
  bcs .skipSonar

.trySfx0
  cmp sfx0
  bcc .skipSonar
  sta sfx0
.skipSonar
 ELSE
  sta TEMPY                 ; [22] + 3
 ENDIF

  jsr VectorAngle           ; [25] + 143

  ; Rotate Mine To Face Ship
  ldx MPHASE                ; [203-35] + 3
  sec                       ; [206] + 2
  sbc CURRSECTOR            ; [208] + 3
  beq .endMineLogic         ; [211] + 2/3
  and #NUM_DIRS-1           ; [213] + 2
  cmp #NUM_DIRS/2           ; [215] + 2
  lda CURRSECTOR            ; [217] + 3
  bcs .mineAntiClockwise    ; [220] + 2/3
;MineClockwise
  adc #1+2                  ; [222] + 2
.mineAntiClockwise
  sbc #1                    ; [224] + 2
  and #MINE_DIR_MASK        ; [228] + 2
  ora #MINE_HOMING          ; [230] + 2
  sta MINEDIR,X             ; [232] + 5--
; TOTAL: 44 + 17 + 235 = 296

.endMineLogic
  ; Update Mine Phase
  dex                       ; [0] + 2
  bpl .storeMinePhase       ; [2] + 2/3
  ldx #NUM_MINES-1          ; [4] + 2
.storeMinePhase
  stx MPHASE                ; [6] + 3
; WORST: 351 + 9 = 360

  END_TASK MineLogic

;  ; Mine Indices (255 = no movement)
;MineXIndex
;  DC.B  255,  7,  6,  5,  4,  3,  2,  1
;MineYIndex
;  DC.B    0,  1,  2,  3,  4,  5,  6,  7
;  DC.B  255,  8,  9, 10, 11, 12, 13, 14
;  DC.B   15, 14, 13, 12, 11, 10,  9,  8
;  PAGE_WARN MineXIndex, "MineXIndex"
;  DC.B  255,  7,  6,  5,  4,  3,  2,  1
;  PAGE_WARN MineYIndex, "MineYIndex"


StartSFX_1 SUBROUTINE
; must NOT change Y!
; 14 bytes
  cmp sfx1          ; [] + 3
  bcc .trySfx0      ; [] + 2/3
  sta sfx1          ; [] + 3
  rts               ; [] + 6

.trySfx0
  cmp sfx0          ; [] + 3
  bcc .exit         ; [] + 2/3
  sta sfx0          ; [] + 3
.exit
  rts               ; [] + 6
                    ; WORST = 20


; -----------------------------------------------------------------------------
; Find Ring Gaps [261]
; -----------------------------------------------------------------------------

  START_TASK CheckRingGap, 4+1, SKIP_1, RotateRing0Odd

  ; only search if gun is not fireing
  bit PROJDIR               ; [0] + 3
  bmi .notFireing           ; [] + 2/3
  bvc EndGapSearch          ; [3] + 2/3     ignore SPARK_FLAG
.notFireing
  ldx GUNDIR                ; [0] + 3
  GUN_DIR_SEARCH 2          ; [3] + 81
  GUN_DIR_SEARCH 1          ; [84] + 81
  GUN_DIR_SEARCH 0          ; [165] + 81    fails least likely

  ; Gap found, set breach bit
  lda SECTORS               ; [246] + 3
  ora #BREACH_BIT           ; [249] + 2
  sta SECTORS               ; [251] + 3
EndGapSearch
  END_TASK CheckRingGap

; -----------------------------------------------------------------------------

  ; Check Collision With Ring 0
  COLLIDE_RING 0

  DIR_TO_SECTOR 0
  DIR_TO_SECTOR 1
  DIR_TO_SECTOR 2

; -----------------------------------------------------------------------------

  ; Check Collision With Ring 1
  COLLIDE_RING 1

; -----------------------------------------------------------------------------

; IF <. > 10
;  ALIGN_FREE_LBL 256, "DirOffset1"
; ENDIF

  DIROFFSET 1

;  ALIGN_FREE 256

  ; Check Collision With Ring 2
  COLLIDE_RING 2

;  DIROFFSET 2

; -----------------------------------------------------------------------------

  ; Vector Angle (TEMPX, TEMPY)
  ; Returns ANGLE
  ; (very approximate CORDIC atan2 algorithm)

VectorAngleCenterMineCol SUBROUTINE ;   = 166 cylces
  sta MINECOL,X             ; [0] + 5
VectorAngleCenterMine       ;           = 161 cylces
  ldy MINEX_HI_R,X          ; [0] + 4
  lda MINEY_HI_R,X          ; [4] + 4
VectorAngleCenter           ;           = 153 cycles
  sec                       ; [0] + 2
  sbc #MIDDLEY              ; [2] + 2
  sta TEMPY                 ; [4] + 3
  tya                       ; [7] + 2
  sec                       ; [9] + 2
  sbc #MIDDLEX              ; [11] + 2
  sta TEMPX                 ; [13] + 3

VectorAngle                 ;           = 137 cycles
  ldy #1                    ; [0] + 2       A = 0
; make Y positive:
  lda TEMPX                 ; [2] + 3
  bpl .adjustX              ; [5] + 2/3     Y < 0?
  sec                       ; [7] + 2
  sbc #1                    ; [9] + 2
  eor #$FF                  ; [11] + 2
  sta TEMPX                 ; [13] + 2      Y' = -Y
  ; sec
  lda #0                    ; [15] + 2
  sbc TEMPY                 ; [17] + 3
  sta TEMPY                 ; [20] + 3      X' = -X
  ldy #16+1                 ; [23] + 2      A = 16

; make X positive:
.adjustX
  lda TEMPY                 ; [25] + 3
  bpl .calc1                ; [28] + 2/3    X < 0
  ldx TEMPX                 ; [30] + 3
  stx TEMPY                 ; [33] + 3      X' = Y
  clc                       ; [36] + 2
  eor #$FF                  ; [38] + 2
  adc #1                    ; [40] + 2
  sta TEMPX                 ; [42] + 3      Y' = -X
  tya                       ; [45] + 2
  ora #8                    ; [47] + 2
  tay                       ; [49] + 2      A += 8
; X/Y = 0..~100

; 1st calculation
.calc1
  sec                       ; [51] + 2
  lax TEMPX                 ; [53] + 3
  sbc TEMPY                 ; [56] + 3
  bcc .calc2                ; [59] + 2/3    Y >= X?
  sta TEMPX                 ; [61] + 3      Y' = Y - X
  clc                       ; [64] + 2
  txa                       ; [66] + 2
  adc TEMPY                 ; [68] + 3
  sta TEMPY                 ; [71] + 3      X' = X + Y
  tya                       ; [74] + 2
  ora #4                    ; [76] + 2
  tay                       ; [78] + 2      A += 4
; X = 0..199; Y = 0..100

; 2nd calculation
.calc2
  lax TEMPX                 ; [80] + 3
  asl                       ; [83] + 2
  sec                       ; [85] + 2
  sbc TEMPY                 ; [87] + 3
  bcc .calc3                ; [90] + 2/3    2Y >= X?
  lsr                       ; [92] + 2
  sta TEMPX                 ; [94] + 3      Y' = (2Y - X)/2 = Y - X/2
  txa                       ; [97] + 2
  lsr                       ; [99] + 2
  ; clc                     ;               allow some "rounding" to save time :)
  adc TEMPY                 ; [101] + 3
  sta TEMPY                 ; [104] + 3     X' = X + Y/2
  iny                       ; [107] + 2
  iny                       ; [109] + 2     A += 2
; X = 0..249; Y = 0..100

; 3rd calculation
.calc3
  lda TEMPX                 ; [111] + 3
  asl                       ; [114] + 2
  bmi .posCalc3             ; [116] + 2/3
  asl                       ; [118] + 2
  ; sec                     ;               we don't need the result, so we check for > here
  sbc TEMPY                 ; [120] + 3
  bcc .endCalc              ; [123] + 2/3   4Y > X?
.posCalc3
  iny                       ; [125] + 2     A += 1

.endCalc
  tya                       ; [127] + 2
  and #NUM_DIRS-1           ; [129] + 2
  rts                       ; [131] + 6
                            ; TOTAL = 137 CYCLES
  PAGE_WARN VectorAngle, "VectorAngle"


; -----------------------------------------------------------------------------
; Game Data
; -----------------------------------------------------------------------------

 IF <. > $80
  ALIGN_FREE_LBL 256, "Ring0XPosition"
 ENDIF

  ; Ring Positions (X Coordinates)
Ring0XPosition
  DC.B  15+XXX, 14+XXX, 13+XXX, 12+XXX, 11+XXX, 10+XXX,  9+XXX,  8+XXX,  7+XXX
  DC.B   6+XXX,  5+XXX,  4+XXX,  3+XXX,  3+XXX,  2+XXX,  2+XXX,  1+XXX,  1+XXX
  DC.B   1+XXX,  0+XXX,  0+XXX,  0+XXX,  0+XXX,  0+XXX,  0+XXX,  0+XXX,  0+XXX
  DC.B   1+XXX,  1+XXX,  1+XXX,  2+XXX,  2+XXX,  3+XXX,  3+XXX,  4+XXX,  5+XXX
  DC.B   6+XXX,  7+XXX,  8+XXX,  9+XXX, 10+XXX, 11+XXX, 12+XXX, 13+XXX, 14+XXX
  DC.B  15+XXX, 16+XXX, 17+XXX, 18+XXX, 19+XXX, 20+XXX, 21+XXX, 22+XXX, 23+XXX
  DC.B  24+XXX, 25+XXX, 26+XXX, 27+XXX, 28+XXX, 29+XXX, 30+XXX, 31+XXX, 32+XXX
  DC.B  33+XXX, 34+XXX, 35+XXX, 36+XXX, 36+XXX, 37+XXX, 37+XXX, 38+XXX, 38+XXX
  DC.B  38+XXX, 39+XXX, 39+XXX, 39+XXX, 39+XXX, 39+XXX, 39+XXX, 39+XXX, 39+XXX
  DC.B  38+XXX, 38+XXX, 38+XXX, 37+XXX, 37+XXX, 36+XXX, 36+XXX, 35+XXX, 34+XXX
  DC.B  33+XXX, 32+XXX, 31+XXX, 30+XXX, 29+XXX, 28+XXX, 27+XXX, 26+XXX, 25+XXX
  DC.B  24+XXX, 23+XXX, 22+XXX, 21+XXX, 20+XXX, 19+XXX, 18+XXX, 17+XXX, 16+XXX
; repeat first sector:
  DC.B  15+XXX, 14+XXX, 13+XXX, 12+XXX, 11+XXX, 10+XXX,  9+XXX,  8+XXX,  7+XXX
  PAGE_WARN Ring0XPosition, "Ring0XPosition"

; possible optimization for Ring0XPosition(x+SEG0SIZE) - Ring0XPosition(x)
;Ring0DXPosition
;  DC.B  -9, -9, -9, -9, -8, -8, -7, -7, -6
;  DC.B  -5, -5, -4, -3, -3, -2, -2, -1, -1
;  DC.B   0,  1,  1,  2,  2,  3,  3,  4,  5
;  DC.B   5,  6,  7,  7,  8,  8,  9,  9,  9
;  DC.B   9,  9,  9,  9,  9,  9,  9,  9,  9
;  DC.B   9,  9,  9,  9,  9,  9,  9,  9,  9
;  DC.B   9,  9,  9,  9,  8,  8,  7,  7,  6
;  DC.B   5,  5,  4,  3,  3,  2,  2,  1,  1
;  DC.B   0, -1, -1, -2, -2, -3, -3, -4, -5
;  DC.B  -5, -6, -7, -7, -8, -8, -9, -9, -9
;  DC.B  -9, -9, -9, -9, -9, -9, -9, -9, -9
;  DC.B  -9, -9, -9, -9, -9, -9, -9, -9, -9
;; repeat first sector:
;  DC.B  -9, -9, -9, -9, -9, -9, -9, -9, -9


Ring1XPosition
  DC.B  16+XXX, 15+XXX, 14+XXX, 13+XXX, 12+XXX, 11+XXX, 10+XXX
  DC.B   9+XXX,  8+XXX,  7+XXX,  7+XXX,  6+XXX,  6+XXX,  6+XXX
  DC.B   5+XXX,  5+XXX,  5+XXX,  5+XXX,  5+XXX,  5+XXX,  5+XXX
  DC.B   5+XXX,  6+XXX,  6+XXX,  6+XXX,  7+XXX,  7+XXX,  8+XXX
  DC.B   9+XXX, 10+XXX, 11+XXX, 12+XXX, 13+XXX, 14+XXX, 15+XXX
  DC.B  16+XXX, 17+XXX, 18+XXX, 19+XXX, 20+XXX, 21+XXX, 22+XXX
  DC.B  23+XXX, 24+XXX, 25+XXX, 26+XXX, 27+XXX, 28+XXX, 29+XXX
  DC.B  30+XXX, 31+XXX, 32+XXX, 32+XXX, 33+XXX, 33+XXX, 33+XXX
  DC.B  34+XXX, 34+XXX, 34+XXX, 34+XXX, 34+XXX, 34+XXX, 34+XXX
  DC.B  34+XXX, 33+XXX, 33+XXX, 33+XXX, 32+XXX, 32+XXX, 31+XXX
  DC.B  30+XXX, 29+XXX, 28+XXX, 27+XXX, 26+XXX, 25+XXX, 24+XXX
  DC.B  23+XXX, 22+XXX, 21+XXX, 20+XXX, 19+XXX, 18+XXX, 17+XXX
; repeat first sector:
  DC.B  16+XXX, 15+XXX, 14+XXX, 13+XXX, 12+XXX, 11+XXX, 10+XXX
  PAGE_WARN Ring1XPosition, "Ring1XPosition"

  ALIGN_FREE_LBL 256, "Ring0YPosition"

  ; Ring Positions (Y Coordinates)
Ring0YPosition
  DC.B   1+YYY,  1+YYY,  1+YYY,  2+YYY,  2+YYY,  3+YYY,  3+YYY,  4+YYY
  DC.B   5+YYY,  6+YYY,  7+YYY,  8+YYY,  9+YYY, 10+YYY, 11+YYY, 12+YYY
  DC.B  13+YYY, 14+YYY, 15+YYY, 16+YYY, 17+YYY, 18+YYY, 19+YYY, 20+YYY
  DC.B  21+YYY, 22+YYY, 23+YYY, 24+YYY, 25+YYY, 26+YYY, 27+YYY, 28+YYY
  DC.B  29+YYY, 30+YYY, 31+YYY, 32+YYY, 33+YYY, 34+YYY, 35+YYY, 36+YYY
  DC.B  36+YYY, 37+YYY, 37+YYY, 38+YYY, 38+YYY, 38+YYY, 39+YYY, 39+YYY
  DC.B  39+YYY, 39+YYY, 39+YYY, 39+YYY, 39+YYY, 39+YYY, 38+YYY, 38+YYY
  DC.B  38+YYY, 37+YYY, 37+YYY, 36+YYY, 36+YYY, 35+YYY, 34+YYY, 33+YYY
  DC.B  32+YYY, 31+YYY, 30+YYY, 29+YYY, 28+YYY, 27+YYY, 26+YYY, 25+YYY
  DC.B  24+YYY, 23+YYY, 22+YYY, 21+YYY, 20+YYY, 19+YYY, 18+YYY, 17+YYY
  DC.B  16+YYY, 15+YYY, 14+YYY, 13+YYY, 12+YYY, 11+YYY, 10+YYY,  9+YYY
  DC.B   8+YYY,  7+YYY,  6+YYY,  5+YYY,  4+YYY,  3+YYY,  3+YYY,  2+YYY
  DC.B   2+YYY,  1+YYY,  1+YYY,  1+YYY,  0+YYY,  0+YYY,  0+YYY,  0+YYY
  DC.B   0+YYY,  0+YYY,  0+YYY,  0+YYY
; repeat first sector:
  DC.B   1+YYY,  1+YYY,  1+YYY,  2+YYY,  2+YYY,  3+YYY,  3+YYY,  4+YYY,  5+YYY
  PAGE_WARN Ring0YPosition, "Ring0YPosition"

Ring2XPosition
  DC.B  17+XXX, 16+XXX, 15+XXX, 14+XXX, 13+XXX, 12+XXX, 11+XXX, 11+XXX
  DC.B  11+XXX, 10+XXX, 10+XXX, 10+XXX, 10+XXX, 10+XXX, 10+XXX, 11+XXX
  DC.B  11+XXX, 11+XXX, 12+XXX, 13+XXX, 14+XXX, 15+XXX, 16+XXX, 17+XXX
  DC.B  17+XXX, 18+XXX, 19+XXX, 20+XXX, 21+XXX, 22+XXX, 22+XXX, 23+XXX
  DC.B  24+XXX, 25+XXX, 26+XXX, 27+XXX, 28+XXX, 28+XXX, 28+XXX, 29+XXX
  DC.B  29+XXX, 29+XXX, 29+XXX, 29+XXX, 29+XXX, 28+XXX, 28+XXX, 28+XXX
  DC.B  27+XXX, 26+XXX, 25+XXX, 24+XXX, 23+XXX, 22+XXX, 22+XXX, 21+XXX
  DC.B  20+XXX, 19+XXX, 18+XXX, 17+XXX
; repeat first sector:
  DC.B  17+XXX, 16+XXX, 15+XXX, 14+XXX, 13+XXX
  PAGE_WARN Ring2XPosition, "Ring2XPosition"

Ring2YPosition
  DC.B  11+YYY, 11+YYY, 11+YYY, 12+YYY, 13+YYY, 14+YYY, 15+YYY, 16+YYY
  DC.B  17+YYY, 17+YYY, 18+YYY, 19+YYY, 20+YYY, 21+YYY, 22+YYY, 22+YYY
  DC.B  23+YYY, 24+YYY, 25+YYY, 26+YYY, 27+YYY, 28+YYY, 28+YYY, 28+YYY
  DC.B  29+YYY, 29+YYY, 29+YYY, 29+YYY, 29+YYY, 29+YYY, 28+YYY, 28+YYY
  DC.B  28+YYY, 27+YYY, 26+YYY, 25+YYY, 24+YYY, 23+YYY, 22+YYY, 22+YYY
  DC.B  21+YYY, 20+YYY, 19+YYY, 18+YYY, 17+YYY, 17+YYY, 16+YYY, 15+YYY
  DC.B  14+YYY, 13+YYY, 12+YYY, 11+YYY, 11+YYY, 11+YYY, 10+YYY, 10+YYY
  DC.B  10+YYY, 10+YYY, 10+YYY, 10+YYY
; repeat first sector:
  DC.B  11+YYY, 11+YYY, 11+YYY, 12+YYY, 13+YYY
  PAGE_WARN Ring2YPosition, "Ring2YPosition"

MineTurnSpeed
_IDX SET 0
 ECHO NUM_SPEEDS, MIN_MINE_TURN_SPEED, MAX_MINE_TURN_SPEED
_D_MINE_TURN_SPEED = 256*(MAX_MINE_TURN_SPEED - MIN_MINE_TURN_SPEED + (NUM_SPEEDS-1)/2)/(NUM_SPEEDS-1)

;  REPEAT NUM_SPEEDS
;_VAL SET ($ff*(MIN_MINE_TURN_SPEED*256+_D_MINE_TURN_SPEED*_IDX) + MAX_MINE_TURN_SPEED/2)/MAX_MINE_TURN_SPEED
;   LIST OFF
;   IF _VAL > 255*256
;     ECHO "WARNING: MineTurnSpeed too large! (", _VAL, "> 255)"
;_VAL SET 255*256
;   ENDIF
;   LIST ON
;    .byte >_VAL
;   LIST OFF
;_IDX SET _IDX +1
;  REPEND
;  LIST ON

  REPEAT NUM_SPEEDS
   LIST OFF
_VAL SET MIN_MINE_TURN_SPEED*256 + _D_MINE_TURN_SPEED*_IDX
   IF _VAL > 100*256-1
     ECHO "WARNING: MineTurnSpeed too large! (", _VAL, "> ", 100*256-1, ")"
_VAL SET 100*256-1
   ENDIF
   LIST ON
    .byte >(256*_VAL/100)
   LIST OFF
_IDX SET _IDX +1
  REPEND
  LIST ON

  ALIGN_FREE_LBL 256, "MineSpeedLo"

    INIT_SPEEDS MIN_MINE_SPEED, MAX_MINE_SPEED, NUM_SPEEDS

  ; Mine X/Y speeds (LO)
MineSpeedLo
    LIST OFF
IDX SET 0
  REPEAT NUM_SPEEDS
    DEF_SPEEDS LO, IDX, SPEEDS_0_16
    LIST ON
IDX SET IDX + 1
    LIST OFF
  REPEND
    LIST ON
    PAGE_WARN MineSpeedLo, "MineSpeedLo"

  ; Mine X & Y speeds (HI)
MineSpeedHi
    LIST OFF
IDX SET 0
  REPEAT NUM_SPEEDS
    DEF_SPEEDS HI, IDX, SPEEDS_0_16
    LIST ON
IDX SET IDX + 1
    LIST OFF
  REPEND
    LIST ON
    PAGE_WARN MineSpeedHi, "MineSpeedHi"

;  ; Mine X/Y speeds (LO)
;MineSpeedLo
;    ; 0.25
;    .byte   $40, $3f, $3b, $35, $2d, $24, $18, $0c
;    .byte   $f4, $e8, $dc, $d3, $cb, $c5, $c1, $c0
;  ; 0.35
;  DC.B  %01011010, %01011000, %01010011, %01001010
;  DC.B  %00111111, %00110010, %00100010, %00010001
;  DC.B  %11101111, %11011110, %11001110, %11000001
;  DC.B  %10110110, %10101101, %10101000, %10100110
;  ; 0.45
;  DC.B  %01110011, %01110001, %01101010, %01100000
;  DC.B  %01010001, %01000000, %00101100, %00010110
;  DC.B  %11101010, %11010100, %11000000, %10101111
;  DC.B  %10100000, %10010110, %10001111, %10001101
;  ; 0.55
;  DC.B  %10001101, %10001010, %10000010, %01110101
;  DC.B  %01100100, %01001110, %00110110, %00011011
;  DC.B  %11100101, %11001010, %10110010, %10011100
;  DC.B  %10001011, %01111110, %01110110, %01110011
;  ; 0.65
;  DC.B  %10100110, %10100011, %10011010, %10001010
;  DC.B  %01110110, %01011100, %01000000, %00100000
;  DC.B  %11100000, %11000000, %10100100, %10001010
;  DC.B  %01110110, %01100110, %01011101, %01011010
;  ; 0.75
;  DC.B  %11000000, %10111100, %10110001, %10100000
;  DC.B  %10001000, %01101011, %01001001, %00100101
;  DC.B  %11011011, %10110111, %10010101, %01111000
;  DC.B  %01100000, %01001111, %01000100, %01000000
;  ; 0.85
;  DC.B  %11011010, %11010101, %11001001, %10110101
;  DC.B  %10011010, %01111001, %01010011, %00101010
;  DC.B  %11010110, %10101101, %10000111, %01100110
;  DC.B  %01001011, %00110111, %00101011, %00100110
;  ; 0.95
;  DC.B  %11110011, %11101111, %11100001, %11001010
;  DC.B  %10101100, %10000111, %01011101, %00101111
;  DC.B  %11010001, %10100011, %01111001, %01010100
;  DC.B  %00110110, %00011111, %00010001, %00001101
;;    ; 1.20
;;    .byte   $33, $2d, $1c, $ff, $d9, $ab, $76, $3c
;;    .byte   $c4, $8a, $55, $27, $01, $e4, $d3, $cd
;
;  ; Mine X & Y speeds (HI)
;MineSpeedHi
;    ; 0.25
;    .byte   $00, $00, $00, $00, $00, $00, $00, $00
;    .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;    ; 0.35
;    .byte   $00, $00, $00, $00, $00, $00, $00, $00
;    .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;    ; 0.45
;    .byte   $00, $00, $00, $00, $00, $00, $00, $00
;    .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;    ; 0.55
;    .byte   $00, $00, $00, $00, $00, $00, $00, $00
;    .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;    ; 0.65
;    .byte   $00, $00, $00, $00, $00, $00, $00, $00
;    .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;    ; 0.75
;    .byte   $00, $00, $00, $00, $00, $00, $00, $00
;    .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;    ; 0.85
;    .byte   $00, $00, $00, $00, $00, $00, $00, $00
;    .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;    ; 0.95
;    .byte   $00, $00, $00, $00, $00, $00, $00, $00
;    .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;;    ; 1.20
;;    .byte   $01, $01, $01, $00, $00, $00, $00, $00
;;    .byte   $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fe


  ALIGN_FREE_LBL 256, "Ring1YPosition"

Ring1YPosition
  DC.B   5+YYY,  6+YYY,  6+YYY,  7+YYY,  7+YYY,  8+YYY,  9+YYY
  DC.B  10+YYY, 11+YYY, 12+YYY, 13+YYY, 14+YYY, 15+YYY, 16+YYY
  DC.B  16+YYY, 17+YYY, 18+YYY, 19+YYY, 20+YYY, 21+YYY, 22+YYY
  DC.B  23+YYY, 23+YYY, 24+YYY, 25+YYY, 26+YYY, 27+YYY, 28+YYY
  DC.B  29+YYY, 30+YYY, 31+YYY, 32+YYY, 32+YYY, 33+YYY, 33+YYY
  DC.B  34+YYY, 34+YYY, 34+YYY, 34+YYY, 34+YYY, 34+YYY, 34+YYY
  DC.B  34+YYY, 33+YYY, 33+YYY, 32+YYY, 32+YYY, 31+YYY, 30+YYY
  DC.B  29+YYY, 28+YYY, 27+YYY, 26+YYY, 25+YYY, 24+YYY, 23+YYY
  DC.B  23+YYY, 22+YYY, 21+YYY, 20+YYY, 19+YYY, 18+YYY, 17+YYY
  DC.B  16+YYY, 16+YYY, 15+YYY, 14+YYY, 13+YYY, 12+YYY, 11+YYY
  DC.B  10+YYY,  9+YYY,  8+YYY,  7+YYY,  7+YYY,  6+YYY,  6+YYY
  DC.B   5+YYY,  5+YYY,  5+YYY,  5+YYY,  5+YYY,  5+YYY,  5+YYY
; JTZ: repeat first sector:
  DC.B   5+YYY,  6+YYY,  6+YYY,  7+YYY,  7+YYY,  8+YYY,  9+YYY
  PAGE_WARN Ring1YPosition, "Ring1YPosition"


  ; Ship/Mine Kick (2.0)
KickTable
KickLoX
  DC.B  %00000000, %01100100, %11000100, %00011100
  DC.B  %01101010, %10101010, %11011001, %11110110
  ; 24 bytes overlap
KickLoY
  DC.B  %00000000, %11110110, %11011001, %10101010
  DC.B  %01101010, %00011100, %11000100, %01100100
  DC.B  %00000000, %10011100, %00111100, %11100100
  DC.B  %10010110, %01010110, %00100111, %00001010
  DC.B  %00000000, %00001010, %00100111, %01010110
  DC.B  %10010110, %11100100, %00111100, %10011100
  PAGE_WARN KickLoX, "KickLoX"
  DC.B  %00000000, %01100100, %11000100, %00011100
  DC.B  %01101010, %10101010, %11011001, %11110110
  PAGE_WARN KickLoY, "KickLoY"
KickHiX
  DC.B  %00000000, %00000000, %00000000, %00000001
  DC.B  %00000001, %00000001, %00000001, %00000001
  ; 24 bytes overlap
KickHiY
  DC.B  %00000010, %00000001, %00000001, %00000001
  DC.B  %00000001, %00000001, %00000000, %00000000
  DC.B  %00000000, %11111111, %11111111, %11111110
  DC.B  %11111110, %11111110, %11111110, %11111110
  DC.B  %11111110, %11111110, %11111110, %11111110
  DC.B  %11111110, %11111110, %11111111, %11111111
  PAGE_WARN KickHiX, "KickHiX"
  DC.B  %00000000, %00000000, %00000000, %00000001
  DC.B  %00000001, %00000001, %00000001, %00000001
  PAGE_WARN KickHiY, "KickHiY"

KickShipX
    .byte   $00, $19, $31, $47, $5A, $6A, $75, $7D
    ; 24 bytes overlap
KickShipY
    .byte   $7F, $7D, $75, $6A, $5A, $47, $31, $19
    .byte   $00, $E7, $CF, $B9, $A6, $96, $8B, $83
    .byte   $81, $83, $8B, $96, $A6, $B9, $CF, $E7
    PAGE_WARN KickShipX, "KickShipX"
    .byte   $00, $19, $31, $47, $5A, $6A, $75, $7D
    PAGE_WARN KickShipY, "KickShipY"

  ; Mine Indices (255 = no movement)
MineXIndex
  DC.B  255,  7,  6,  5,  4,  3,  2,  1
MineYIndex
  DC.B    0,  1,  2,  3,  4,  5,  6,  7
  DC.B  255,  8,  9, 10, 11, 12, 13, 14
  DC.B   15, 14, 13, 12, 11, 10,  9,  8
  PAGE_WARN MineXIndex, "MineXIndex"
  DC.B  255,  7,  6,  5,  4,  3,  2,  1
  PAGE_WARN MineYIndex, "MineYIndex"

;StartSFX_1 SUBROUTINE
;; must NOT change Y!
;; 14 bytes
;  cmp sfx1          ; [] + 3
;  bcc .trySfx0      ; [] + 2/3
;  sta sfx1          ; [] + 3
;  rts               ; [] + 6
;
;.trySfx0
;  cmp sfx0          ; [] + 3
;  bcc .exit         ; [] + 2/3
;  sta sfx0          ; [] + 3
;.exit
;  rts               ; [] + 6
;                    ; WORST = 20

;; 12 bytes
;  ldx #2
;.loopChannel
;  dex
;  bmi .exit
;  cmp sfxLst,x
;  bcs .startSound
;  sta sfxLst,x
;.exit
;  rts

;; 13 bytes
;  ldx #1
;.loopChannel
;  cmp sfxLst,x
;  bcs .startSound
;  dex
;  bpl .loopChannel
;  NOP_W
;.startSound
;  sta sfxLst,x
;  rts

;; 14 bytes
;  ldx #1
;  cmp sfxLst,x
;  bcs .startSound
;  dex
;  cmp sfxLst,x
;  bcc .exit
;.startSound
;  sta sfxLst,x
;.exit
;  rts


  ALIGN_FREE_LBL 256, "SquaresTbl"

SquaresTbl ; factor: 256/576
; all values above index 23 can be ignored (=255)
  .byte   0,   0,   2,   4,   7,  11,  16,  22
  .byte  28,  36,  44,  54,  64,  75,  87, 100
  .byte 114, 128, 144, 160, 178, 196, 215, 235
  .byte 255, 255, 255, 255, 255, 255, 255, 255
  .byte 255, 255, 255, 255, 255, 255, 255, 255
  .byte 255, 255, 255, 255, 255, 255, 255, 255
  .byte 255, 255, 255, 255, 255, 255, 255, 255
  .byte 255, 255, 255, 255, 255, 255, 255, 255
  .byte 255, 255, 255, 255, 255, 255, 255, 255
  .byte 255, 255, 255, 255, 255, 255, 255, 255
  .byte 255, 255, 255, 255, 255, 255, 255, 255 ; 3 bytes too many (MIDDLEX+1)
  PAGE_WARN SquaresTbl, "SquaresTbl"

  MAC SEC_OFFSETS1
Sector{1}End1
  LIST OFF
VAL SET 0
  REPEAT NUM_SECS
  LIST ON
  .byte VAL
  LIST OFF
VAL SET VAL - SEC{1}_SIZE
  IF VAL < 0
VAL SET VAL + RING{1}_SIZE
  ENDIF
  REPEND
  LIST ON
  ENDM

SectorOffsets1
  SEC_OFFSETS1 0
  SEC_OFFSETS1 1
  SEC_OFFSETS1 2
  PAGE_WARN SectorOffsets1, "SectorOffsets1"

; -----------------------------------------------------------------------------
; Ring Gaps Data
; -----------------------------------------------------------------------------

  DIROFFSET 0

  DIROFFSET 2

MineKickChance
_VAL SET MIN_MINE_KICK_CHANCE * _MULT
  REPEAT NUM_SPEEDS
    .byte (_VAL + _MULT/2)/_MULT
_VAL SET (_VAL*MINE_KICK_FACTOR+FACTOR_MULT/2)/FACTOR_MULT
    .byte (_VAL + _MULT/2)/_MULT
  REPEND

; -----------------------------------------------------------------------------
; Subroutines
; -----------------------------------------------------------------------------

  ; Distance from Centre
  ; Uses: A, X, Y
  ; Returns: A, DISTANCE_LO
CentreDistance SUBROUTINE
  sta TEMPBX                ; [0] + 3   used later for CollideRing!
  sty TEMPBY                ; [3] + 3
CentreDistanceB
  sec                       ; [0] + 2
  sbc #MIDDLEX              ; [2] + 2
  bcs .endLeftCheck         ; [4] + 2/3
  eor #$ff                  ; [6] + 2
  adc #1                    ; [8] + 2
.endLeftCheck
  tax                       ; [10] + 2
  tya                       ; [12] + 2
  sec                       ; [14] + 2
  sbc #MIDDLEY              ; [16] + 2
  bcs .endDownCheck         ; [18] + 2/3
  eor #$ff                  ; [20] + 2
  adc #1                    ; [22] + 2
.endDownCheck
  tay                       ; [24] + 2
  ; Square Distance
  clc                       ; [26] + 2
  lda SquaresTbl,X          ; [28] + 4
  adc SquaresTbl,Y          ; [32] + 4
  rts                       ; [36] + 6
                            ; WORST = 42 CYCLES

; -----------------------------------------------------------------------------
; Startup Logo
; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "EnterStartup"

EnterStartup
.textRow = TEMP2
  ; Skip Lines
  ldx #69+EXTRA_LINES
StartupSkipLoop
  sta WSYNC
  dex
  bne StartupSkipLoop

  ; Non-Reflected Playfield & Black Sprites
;  stx CTRLPF
;  stx COLUP0
;  stx COLUP1

  ; Blank Screen and Set Playfield
  ldx #%00110010
  stx VBLANK
  stx ENAM0
  stx PF0
  ldx #%11111100
  stx PF2

  ; Logo Colours (For Both NTSC & PAL)
  ldx #BLUE_CYAN_NTSC|8     ; = CYAN_PAL
  stx COLUPF
  ldx #BROWN_NTSC|8         ; = YELLOW_PAL
  stx COLUBK

  ldy #24+1
  ; Begin Logo Display
AALogoLoop
  dey
  sty .textRow            ; [65] + 3
  lda AALogo0,Y           ; [68] + 4
  sta WSYNC               ; [72] + 3
;---------------------------------------
  nop                     ; [0] + 2
  sta GRP0                ; [2] + 3
  lda AALogo1,Y           ; [5] + 4
  sta GRP1                ; [9] + 3  < 42
  lda AALogo2,Y           ; [12] + 4
  sta GRP0                ; [16] + 3  < 44
  ldx AALogo4,Y           ; [19] + 4
  lda AALogo5,Y           ; [23] + 4
  sta TEMP                ; [27] + 3
  lda AALogo3,Y           ; [30] + 4
  ldy #0                  ; [34] + 2
  sty VBLANK              ; [36] + 3  = 39
  ldy TEMP                ; [39] + 3
  sta GRP1                ; [42] + 3  > 44 < 47
  stx GRP0                ; [45] + 3  > 46 < 50
  sty GRP1                ; [48] + 3  > 49 < 52
  sta GRP0                ; [51] + 3  > 52 < 55
  stx VBLANK              ; [54] + 3  = 57
  ldy .textRow            ; [57] + 5
  bne AALogoLoop          ; [62] + 2/3
  PAGE_WARN AALogoLoop, "AALogoLoop"
;  ldx #0                  ; [64] + 2
;  sty GRP0                ; [66] + 3
;  sty GRP1                ; [69] + 3
;  sty GRP0                ; [72] + 3
  sty ENAM0               ; [4] + 3
  sty PF0                 ; [7] + 3
  sty PF2                 ; [10] + 3
  sty COLUBK              ; [13] + 3
;  stx NUSIZ0              ; [16] + 3
;  stx NUSIZ1              ; [19] + 3
;  stx VDELP0              ; [22] + 3
;  stx VDELP1              ; [25] + 3
  jmp LeaveStartup

AALogo0
  DC.B  %11111000
  DC.B  %11110000
  DC.B  %11100111
  DC.B  %11001111
  DC.B  %11011000
  DC.B  %10010000
  DC.B  %10111000
  DC.B  %10101000
  DC.B  %00101101
  DC.B  %01100101
  DC.B  %01000101
  DC.B  %01000111
  DC.B  %01001010
  DC.B  %01001010
  DC.B  %01001101
  DC.B  %01100101
  DC.B  %00100101
  DC.B  %10100111
  DC.B  %10110010
  DC.B  %10010010
  DC.B  %11011000
  DC.B  %11001111
  DC.B  %11100111
  DC.B  %11110000
  DC.B  %11111000

AALogo1
  DC.B  %11111111
  DC.B  %01111111
  DC.B  %00111111
  DC.B  %10011111
  DC.B  %11011111
  DC.B  %01001111
  DC.B  %11101111
  DC.B  %10101101
  DC.B  %10100101
  DC.B  %00110101
  DC.B  %00010100
  DC.B  %00010100
  DC.B  %10010110
  DC.B  %10010110
  DC.B  %10010110
  DC.B  %00110110
  DC.B  %00100110
  DC.B  %00101111
  DC.B  %01101111
  DC.B  %01001111
  DC.B  %11011111
  DC.B  %10011111
  DC.B  %00111111
  DC.B  %01111111
  DC.B  %11111111
AALogo5
  DC.B  %11111111
  PAGE_WARN AALogo1, "AALogo1"
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %01111111
  DC.B  %00111111
  DC.B  %10011111
  DC.B  %11011111
  DC.B  %11011001
  DC.B  %01010000
  DC.B  %00010110
  DC.B  %10010111
  DC.B  %11010000
  DC.B  %11010000
  DC.B  %11010110
  DC.B  %11010110
  DC.B  %00010000
  DC.B  %00111001
  DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
AALogo2
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  PAGE_WARN AALogo5, "AALogo5"
  DC.B  %11011011
  DC.B  %11010010
  DC.B  %11010110
  DC.B  %00010110
  DC.B  %00010110
  DC.B  %10110111
  DC.B  %10110111
  DC.B  %10110110
  DC.B  %10100010
  DC.B  %00110111
  DC.B  %01110111
  DC.B  %01111111
  DC.B  %01111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
AALogo3
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  PAGE_WARN AALogo2, "AALogo2"
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %00100110
  DC.B  %00000110
  DC.B  %11010110
  DC.B  %11010110
  DC.B  %00010110
  DC.B  %00010110
  DC.B  %11010010
  DC.B  %11010000
  DC.B  %00110100
  DC.B  %00111111
  DC.B  %11111111
  DC.B  %11111110
  DC.B  %11111110
  DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
; DC.B  %11111111
AALogo4
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  PAGE_WARN AALogo3, "AALogo3"
  DC.B  %11111110
  DC.B  %11111110
  DC.B  %11111111
  DC.B  %10111011
  DC.B  %10111011
  DC.B  %10111010
  DC.B  %10000010
  DC.B  %10000010
  DC.B  %11010110
  DC.B  %11010110
  DC.B  %11010110
  DC.B  %11010111
  DC.B  %11000111
  DC.B  %11101111
  DC.B  %11101111
  DC.B  %11101111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  DC.B  %11111111
  PAGE_WARN AALogo4, "AALogo4"

  ; Next Sectors
NextSectorIndexA
  DC.B  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0
  PAGE_WARN NextSectorIndexA, "NextSectorIndexA"

  ; Homing Mine Colours
MineCols
  DC.B  MINE_COL_NTSC, MINE_COL_PAL|$C, MINE_COL_BW ; NTSC/PAL/B&W
  PAGE_WARN MineCols, "MineCols"

  END_BANK 1