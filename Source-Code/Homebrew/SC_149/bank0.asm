DISABLE = 0 ; 868 bytes (required for moving tasks from this bank)

; -----------------------------------------------------------------------------
; Star Castle Arcade - Atari 2600
; Copyright (C) 2012 Chris Walton (cd-w) <cwalton@gmail.com>
; Copyright (C) 2013 Thomas Jentzsch <tjentzsch@yahoo.de>
; Bank 0 - Game Logic, Sounds & Messages
; -----------------------------------------------------------------------------

  START_BANK "BANK0"
  FIRST_TASK_VECTORS 0      ; +17
  ds    1, 0
EnterKernelJmp              ; +18
  nop   BANK2               ; [34] + 4
  jmp   OverScan
DrawStars
  nop   BANK6
  rts
  ds    2, 0
EndGame                     ; +24
  nop   BANK6               ; switch to bank 6 (EndOfGame)
;  jmp   GameInit            ; from bank 6 (EnterGame)

; -----------------------------------------------------------------------------
; Game Initialisation
; -----------------------------------------------------------------------------
;GameInit

; -----------------------------------------------------------------------------
; Main Loop
; -----------------------------------------------------------------------------

MainLoop                    ; [34]
  ; Finish Overscan
.waitMainOverscan
  lda INTIM
  bne .waitMainOverscan

; -----------------------------------------------------------------------------
; Vertical Sync
; -----------------------------------------------------------------------------

  ; VSYNC enable
  ldx #%11010
  sta WSYNC                 ; [] + 3
;---------------------------------------
DEBUG9
  stx VSYNC                 ; [0] + 3       bit1 = 1!
  dex                       ; [3] + 2       = 25
  stx TIM8T                 ; [5] + 4
                            ; WORST: 9

  ; Pseudo-Random Number
  lda RANDOM                ; [0] + 3
  asl                       ; [3] + 2
  bcc .noRndEor             ; [5] + 2/3
  eor #$AF                  ; [7] + 2
.noRndEor
  sta RANDOM                ; [9] + 3
                            ; WORST: 12

  ; Test B&W/Pause Switch
  lda SWCHB                 ; [7] + 3
  and #BW_BIT               ; [10] + 2
  cmp #BW_BIT               ; [12] + 2
  ; Fetch Pause Status
  lax DEBOUNCE              ; [14] + 3
  ; Check For 7800 Mode
  and #CONSOLE_FLAG         ; [17] + 2
  beq .pause7800            ; [19] + 2/3
  ; pause 2600
  txa                       ; [21] + 2
  and #<~PAUSE_FLAG         ; [23] + 2
  bcs .storePause           ; [25] + 2/3
  ; pause game
  ora #PAUSE_FLAG           ; [27] + 2
  bne .storePause           ; [29] + 3

.pauseNotPressed
  ; Clear Previous Status
  and #<~BW_FLAG            ; [26] + 2
  bcs .storePause           ; [28] + 3

.pause7800
  txa                       ; [21] + 2
  bcs .pauseNotPressed      ; [23] + 2/3
  ; pause pressed
  ; Previously Pressed?
  and #BW_FLAG              ; [25] + 2
  bne .endPause             ; [27] + 2/3
  ; Toggle Pause & Button Status
  txa                       ; [29] + 2
  eor #(BW_FLAG|PAUSE_FLAG) ; [31] + 2
.storePause
  sta DEBOUNCE              ; [33] + 3
.endPause
                            ; WORST: 36

; -----------------------------------------------------------------------------


;; visualize frame skips
;  lda CYCLE
;  sec
;  sbc taskCycle
;  sta COLUBK
;  sta WSYNC                 ; [] + 3
; -----------------------------------------------------------------------------

;  IF (DEBUG) ;{
;  ; Debugging Mode
;  lda SWCHB
;  and #%00000010
;  bne NoSelect
;  lda MODE
;  cmp #%11100000
;  beq NoSelect
;  ; Set Explosion Mode
;  lda #%11100000
;  sta MODE
;  lda #EXPLODEFRAMES-1
;  sta gunExplodeIdx
;  lda #254
;  sta SFX
;  ; Increment Castle
;  lax castle
;  and #%11000000
;  sta TEMP
;  txa
;  clc
;  ; and #%00111111
;  adc #1
;  and #%00111111
;  ora TEMP
;  sta castle
;  jmp .endModeCounter
;
;NoSelect
;  ENDIF ;}

 IF TEST_FRAME_SKIP
  dec frameCycle
 ENDIF
  ; Frame Counter
  dec CYCLE                 ; [0] + 5
  ; Update Mode Counter
  lda CYCLE                 ; [5] + 3
  and #%00000111            ; [8] + 2        Update Every 8 Frames (7.5Hz)
  bne .endModeCounter       ; [10] + 2/3
  lda MODE                  ; [12] + 3
  and #MODE_TIMER           ; [15] + 2
  beq .endModeCounter       ; [17] + 2/3
  dec MODE                  ; [19] + 5
.endModeCounter
                            ; WORST: 24

  ; Check for Pause Switch
  lda MODE                  ; [0] + 3
  and #MODE_MASK            ; [3] + 2
  bne .skipPause            ; [5] + 2/3
  lda DEBOUNCE              ; [7] + 3
  and #PAUSE_FLAG           ; [10] + 2
  beq .skipPause            ; [12] + 2/3
  ; enable pause mode
  lda #MODE_PAUSED          ; [14] + 2
  sta MODE                  ; [17] + 3
  lda #SFX_SWITCH           ; [19] + 2
  sta sfx0                  ; [21] + 3      sfx1 stops siren!
.skipPause
                            ; WORST: 24

  ; Flicker Mines
  ldy MPOS                  ; [0] + 3
  lda #MINE_DIR_MASK        ; [3] + 2       = $1f
  ldx NextMineTab+2,Y       ; [5] + 4
  cmp MINEDIR_R,X           ; [9] + 4       MINE_DEAD?
  bcc .storeMinePos         ; [13] + 2/3
  ldx NextMineTab+1,Y       ; [15] + 4
  cmp MINEDIR_R,X           ; [19] + 4      MINE_DEAD?
  bcc .storeMinePos         ; [23] + 2/3
  ldx NextMineTab,Y         ; [25] + 4
.storeMinePos
  stx MPOS                  ; [29] + 3
                            ; WORST = 32 CYCLES

  ; Flicker Bullets
 IF NUM_BULLETS = 2 ;{
  ; works only for NUM_BULLETS == 2!
  lda BPOS                  ; [0] + 3
  eor #%1                   ; [3] + 2
  tax                       ; [5] + 2
  lda BULLETDIR,X           ; [7] + 4
  bmi .skipBulletPos        ; [11] + 2/3
  stx BPOS                  ; [13] + 3      0/1
.skipBulletPos              ; WORST = 16 CYCLES
 ELSE ;}
  ldy BPOS                  ; [0] + 3
  ldx NextBulletTab+2,Y     ; [3] + 4
  lda BULLETDIR,X           ; [7] + 4
  bpl .storeBulletPos       ; [11] + 2/3
  ldx NextBulletTab+1,Y     ; [13] + 4
  lda BULLETDIR,X           ; [17] + 4
  bpl .storeBulletPos       ; [21] + 2/3
  ldx NextBulletTab,Y       ; [23] + 4
.storeBulletPos
  stx BPOS                  ; [27] + 3      0/1
                            ; WORST = 30 CYCLES
 ENDIF
; TOTAL: 9+12+36+24+24+32+30 = 167

.waitTim
  lda INTIM                 ; [0] + 4
  bne .waitTim              ; [4] + 2/3

  ; Check For Reset Switch
  lsr SWCHB                 ; [6] + 6
  bcs .noReset              ; [12] + 2/3
  ; Do VBlank
  sta WSYNC                 ; [14] + 3
                            ; WORST: 17+1
;--------------------------------------
  sta VSYNC                 ; [0] + 3
  jmp EndGameTim            ; [3] + 3       C==0! (clear score)

; -----------------------------------------------------------------------------

.noReset
  ; VSYNC disable
  ldx #VBLANKDELAY          ; [66] + 2
  sta WSYNC                 ; [68]
;--------------------------------------
  sta VSYNC                 ; [0] + 3       A==0
  stx TIM64T                ; [3] + 43


; -----------------------------------------------------------------------------
; Vertical Blank [21]
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Siren Sound
; -----------------------------------------------------------------------------

; move ch 0 to empty ch 1 to make space for siren sound
;  lda sfx1
;  bne .sfx1Used
;  lda sfx0
;  sta sfx1
;  lda #0
;  sta sfx0
;  lda saveAudC1
;  sta AUDC1
;.sfx1Used:

  ; Check Game Mode
  lda MODE                  ; [6] + 3
  and #MODE_MASK            ; [9] + 2
  beq .sectorMode           ; [] + 2/3
  eor #MODE_SCORE_CASTLE
  beq .highSirenMode
  eor #MODE_SCORE_CASTLE^MODE_SCORE_SHIPS
  beq .highSirenMode
  eor #MODE_EXPLOSION^MODE_SCORE_SHIPS
  beq .sectorMode
  lda #0                   ;               low 5 bits are 0
  sta AUDV0
.noSirenMode
  jmp .skipSirenSound

.sectorMode
  ; calculate frequency index
  lda SECTORS               ; [0] + 3       0..3,   4..7,  8..11, 12..15, 16..19, 20..23, 24..27, 28..31/32..35/36
  and #%00111111            ; [3] + 2       eliminate breach bit
.highSirenMode
  lsr                       ; [3] + 2
  lsr                       ; [5] + 2
  tay                       ; [7] + 2
  ; determine if we have to move frequency up or down
  lda sirenFreqLo           ; [9] + 3
  sec                       ; [12] + 2
  sbc FreqLoTbl,y           ; [14] + 4
  lax sirenFreqHi           ; [18] + 3
  sbc FreqHiTbl,y           ; [21] + 4
  lda sirenFreqLo           ; [25] + 3
  bcc .freqAbove            ; [28] + 2/3
; current frequency below target frequency
;  ldy #$c4
;  sty COLUBK
  ; sec
  sbc FreqAddTbl,x          ; [30] + 4
  bcs .setFreqLo            ; [34] + 2/3
  dex                       ; [36] + 2
  cpx #(LO_MIN-1)|$20       ; [38] + 2          switch time DIV6?
  bne .setFreqHi            ; [40] + 2/3
  ; switch to hi-div
  asl                       ; [42] + 2
  asl                       ; [44] + 2
  ldx #HI_MAX               ; [46] + 2
  bne .setFreqHi            ; [48] + 3

; current frequency above target frequency
.freqAbove
;  ldy #$44
;  sty COLUBK
  ; clc
  adc FreqAddTbl,x          ; [31] + 4
  bcc .setFreqLo            ; [35] + 2/3
  inx                       ; [37] + 2
  cpx #HI_MAX+1             ; [39] + 2        switch time DIV31?
  bne .setFreqHi            ; [41] + 2/3
  ; switch to low-div
  lsr                       ; [43] + 2
  lsr                       ; [45] + 2
; correct sirenFreqLo???
;  adc #$38
  ldx #LO_MIN|$20           ; [47] + 2
.setFreqHi
  stx sirenFreqHi           ; [51] + 3
.setFreqLo
  sta sirenFreqLo           ; [54] + 3
                            ; WORST: 57; AVG: 45

  ; skip playing siren if channel used:
  ldy sfx0
  bne .skipSirenSound

  ; update AUDC0
  ldy #PURE_DIV_LO          ; [0] + 2
  cpx #LO_MIN|$20           ; [2] + 2
  bcs .lowDiv               ; [4] + 2/3
  ldy #PURE_DIV_HI          ; [6] + 2
  clc                       ; [8] + 2
.lowDiv
  sty AUDC0                 ; [10] + 3
                            ; WORST: 13

; precalculate frequencies
; a = sirenFreqLo
; x = sirenFreqHi
  adc sirenFreqSum          ; [0] + 3
  tay                       ; [3] + 2
  txa                       ; [5] + 2
  adc #0                    ; [7] + 2
  sta sirenF0_W             ; [9] + 4
  tya                       ; [13] + 2
  adc sirenFreqLo           ; [15] + 3
  tay                       ; [18] + 2
  txa                       ; [20] + 2
  adc #0                    ; [22] + 2
  sta sirenF1_W             ; [24] + 4
  tya                       ; [28] + 2
  adc sirenFreqLo           ; [30] + 3
  tay                       ; [33] + 2
  txa                       ; [35] + 2
  adc #0                    ; [37] + 2
  sta sirenF2_W             ; [39] + 4
  tya                       ; [43] + 2
  adc sirenFreqLo           ; [45] + 3
  sta sirenFreqSum          ; [48] + 3
  txa                       ; [51] + 2
  adc #0                    ; [53] + 2
  sta sirenF3_W             ; [55] + 4
                            ; TOTAL: 59

;  adc sirenFreqSum          ; [0] + 3
;  bcs .high0                ; [3] + 2/3
;  stx sirenF0_W             ; [5] + 4
;  adc sirenFreqLo           ; [9] + 3
;  bcc .low1                 ; [12] + 2/3
;  inx
;.high1
;  stx sirenF1_W
;  adc sirenFreqLo           ; [0] + 3
;  bcs .high2                ; [7] + 2/3
;  dex
;.low2
;  stx sirenF2_W
;  adc sirenFreqLo           ; [0] + 3
;  bcc .low3                 ; [7] + 2/3
;  inx
;.high3
;  clc
;  bcc .low3                 ; [] + 3
;;  stx sirenF3_W
;
;.high0
;  inx
;  stx sirenF0_W             ; [3] + 4
;  adc sirenFreqLo           ; [0] + 3
;  bcs .high1                ; [7] + 2/3
;  dex
;.low1
;  stx sirenF1_W
;  adc sirenFreqLo           ; [0] + 3
;  bcc .low2                 ; [7] + 2/3
;  inx
;.high2
;  stx sirenF2_W
;  adc sirenFreqLo           ; [0] + 3
;  bcs .high3                ; [7] + 2/3
;  dex
;.low3
;  stx sirenF3_W
;  sta sirenFreqSum          ; [48] + 3


; *** modify the siren volume ***
; - volume high:low factor = 2:1
; - change frequency = siren frequency/63
;  ldx sirenFreqHi
  lda sirenVolIdxSum        ; [3] + 3
  ; clc
  adc VolAddTbl,x           ; [8] + 4
  sta sirenVolIdxSum        ; [12] + 3
  lda sirenVolIdx           ; [15] + 3
  adc #0                    ; [18] + 2
  and #$1f                  ; [20] + 2
  sta sirenVolIdx           ; [22] + 3
  tay                       ; [25] + 2
  ; clc
  lda SirenVolLoTbl,y       ; [27] + 4
  adc sirenVolSum           ; [31] + 3
  sta sirenVolSum           ; [34] + 3
  lda SirenVolHiTbl,y       ; [37] + 4
  adc #0                    ; [41] + 2
  sta AUDV0                 ; [43] + 3
                            ; TOTAL: 41
.skipSirenSound


; -----------------------------------------------------------------------------
; SFX Sound
; -----------------------------------------------------------------------------

  ; Play Sound Effects
  ldx #1                    ; [0] + 2
  ; Play Channel 1
  ldy sfx1                  ; [2] + 3
  beq .endGSounds           ; [5] + 2/3
  lda SoundData1,Y          ; [7] + 4
  beq .resetGSounds         ; [11] + 2/3
  cmp #$ff                  ; [13] + 2
  bne .playGSound1          ; [15] + 2/3
  dey                       ; [17] + 2
  lda SoundData1,Y          ; [19] + 4
  sta AUDC1                 ; [23] + 3
;  sta saveAudC1             ; [] + 3
  dey                       ; [26] + 2
  lda SoundData1,Y          ; [28] + 4
  bcs .playGSound1          ; [32] + 3 = 35   CF still set from cmp #$ff

.loopSounds
  ; Play Channel 0
  ldy sfx0                  ; [0] + 3
  beq .endGSounds           ; [3] + 2/3
  lda SoundData0,Y          ; [5] + 4
  beq .resetGSounds         ; [9] + 2/3
  cmp #$ff                  ; [11] + 2
  bne .playGSound0          ; [13] + 2/3
  dey                       ; [15] + 2
  lda SoundData0,Y          ; [17] + 4
  sta AUDC0                 ; [21] + 3
  dey                       ; [24] + 2
  lda SoundData0,Y          ; [26] + 4
.playGSound0
  sta sirenF0_W             ; [30] + 4
  sta sirenF1_W             ; [34] + 4
  sta sirenF2_W             ; [38] + 4
  sta sirenF3_W             ; [42] + 4 = 46
.playGSound1
  dey                       ; [0] + 2
  sta AUDF0,x               ; [2] + 4
  and #%11100000            ; [6] + 2
  lsr                       ; [8] + 2
  lsr                       ; [10] + 2
  lsr                       ; [12] + 2
  lsr                       ; [14] + 2
  NOP_B                     ; [16] + 0
.resetGSounds
  tay                       ; [16] + 2
  sty sfxLst,x              ; [18] + 4
  sta AUDV0,x               ; [22] + 4
.endGSounds
  dex                       ; [26] + 2
  bpl .loopSounds           ; [28] + 2/3 =30/31
                            ; WORST: 35+46+31+30 = 142
                            ; BEST : 13+10 = 26

; -----------------------------------------------------------------------------
; Handle Game Mode
; -----------------------------------------------------------------------------

  lda MODE                  ; [6] + 3
  and #MODE_MASK            ; [9] + 2           MODE_MAIN_GAME
  beq .normalMode           ; [11] + 2/3
  eor #MODE_EXPLOSION       ; [13] + 2
  beq .normalMode           ; [11] + 2/3
  jmp ShowMessages

.normalMode

; -----------------------------------------------------------------------------
; Check For Ship Explosion [18] (frame task)
; -----------------------------------------------------------------------------

  lda SHIPS                 ; [0] + 3
  bpl .skipShipExplosion    ; [3] + 2/3   = 6

  ; Update Ship Explosion Frame
  ldx SHIPEXP_FRAME         ; [5] + 3
  beq .endShipExplosion     ; [8] + 2/3
  ; Skip Joystick Controls
  dec SHIPEXP_FRAME         ; [10] + 5
.skipJoystick
  bpl .skipShipExplosion    ; [15] + 3    = 18

.endShipExplosion
  ; Check Ring Explosion Mode
  ldy MODE
  cpy #MODE_EXPLOSION
  bcc .noRingExplosion
  ; Wait For End Of Ring Explosion
  ldx gunExplodeIdx
  bne .skipShipExplosion

  ; Finish Sound Effects
;  stx AUDV1                 ;           gun explosion is fix at channel 1
.noRingExplosion
  ; Show Game Over Message
  ldx #MODE_GAME_OVER|GAME_OVER_TIM
  ; Check For Game Over
;  lda SHIPS
  and #%01111111
  beq .setMode
  ; Decrease Ship Count
  dec SHIPS
  ; Show New Castle
  ldx #MODE_SCORE_CASTLE|SHIPS_CASTLE_TIM
  ; Check For Explode Mode
;  cpy #MODE_EXPLOSION
  bcs .setMode
  ; Show Remaining Ships
  ldx #MODE_SCORE_SHIPS|SHIPS_CASTLE_TIM
.setMode
  stx MODE
  jmp ShowMessages

.skipShipExplosion


; -----------------------------------------------------------------------------
; Flicker and position Mines & Bullets [50] (frame task)
; -----------------------------------------------------------------------------

  ; Position Ball (Mine) (moved here to optimize CPU usage)
  ; CYCLES:
  ; 00: --  ;x  , y  , NUSIZ=2, ysize=1
  ; 01: |.  ;x  , y  , NUSIZ=1, ysize=2
  ; 10: __  ;x  , y+1, NUSIZ=2, ysize=1
  ; 11: .|  ;x+1, y  , NUSIZ=1, ysize=2
  ldx MPOS                  ; [0] + 3
  lda CYCLE                 ; [3] + 3
  and #%11                  ; [6] + 2
  cmp #%11                  ; [8] + 2
  lda MINEX_HI_R,X          ; [10] + 4
  adc #0                    ; [14] + 2
  ldx #RESBL-RESP0          ; [16] + 2
  jsr XPosition0            ; [18] + 158 (worst case)

;  ; Position Missile 0 (Bullet) (WAS moved here to optimize CPU usage, caused glitches)
; IF NUM_BULLETS = 2 ;{
;  ldx BPOS                  ; [0] + 3
; ENDIF ;}
;  lda BULLETDIR,X           ; [3] + 4
;  bmi .hideBullet           ; [7] + 2/3
;  lda BULLETX_HI,X          ; [9] + 4
;  ldx #RESM0-RESP0          ; [13] + 2
;  jsr XPosition0            ; [15] + 158 (worst case)
;.hideBullet
;  sta WSYNC
;---------------------------------------
;  sta HMOVE

; -----------------------------------------------------------------------------
; Task handling during vertical blank
; -----------------------------------------------------------------------------

  ldx jmpBank
  jsr ContToTasks       ; [0] + 28
  stx jmpBank           ; [28] + 3
; IF TEST_FRAME_SKIP ;{
;  lda INTIM
;  cmp #1
;  bpl .ok
;  ldx jmpVec+1
;  stx COLUBK
;.ok
; ENDIF ;}
  jmp EnterKernelJmp    ; [31] + 3


; -----------------------------------------------------------------------------
; Start of overscan processing
; -----------------------------------------------------------------------------
OverScan SUBROUTINE
; 1. stuff which has to be done every frame
; 2. schedule some tasks


; -----------------------------------------------------------------------------
; Ship/Mine/Ring Collisions [53] (frame task)
; -----------------------------------------------------------------------------
  ; Skip If Already Dead
  ldy SHIPS                 ; [0] + 3
  bmi .skipMineRingColl     ; [3] + 2/3
  ; Skip Projectile Collisions
  bit PROJDIR               ; [5] + 3       ship/projectile flickering?
  bmi .checkMineRingColl    ; [8] + 2/3      no, always check
  bvs .skipMineRingColl     ; [15] + 2/3     SPARK_FLAG, skip!
  lda CYCLE                 ; [10] + 3
  lsr                       ; [13] + 2      ship cycle?
  bcc .skipMineRingColl     ; [15] + 2/3     no, skip
.checkMineRingColl
  ; Only Check For Ring Collisions if Right Difficulty Set To A
 IF CHEAT
  jmp .skipMineRingColl
 ELSE
  ; Check For Ring Collision
  lda difficulty            ; [17] + 3
  and CXPPMM                ; [21] + 3      ship vs ring
  bmi .explodeShip          ; [24] + 2/3
  ; Check For Mine Collision
  bit CXP0FB                ; [26] + 3      ship vs mine
  bvc .skipMineRingColl     ; [29] + 2/3
  ldx MPOS                  ; [0] + 3
  lda MINEDIR_R,X
  cmp MINE_HOMING
  bcc .skipMineRingColl     ;               mine was not homing
  lda #MINE_DEAD
  sta MINEDIR_W,X           ; [3] + 4
 ENDIF
.explodeShip
  ; Explode Ship
  tya                       ; [31] + 2
  ora #%10000000            ; [33] + 2
  sta SHIPS                 ; [35] + 3
  lda #10*4                 ; [38] + 2
  sta SHIPEXP_FRAME         ; [40] + 3
  ; Play Sound
  lda #SFX_EXPL_SHIP        ; [] + 2
  sta sfx0                  ; [] + 3
.skipMineRingColl

; -----------------------------------------------------------------------------
; Task handling during overscan
; -----------------------------------------------------------------------------

HandleTasksInOverscan SUBROUTINE
  ldx jmpBank
  jsr ContToTasks
  stx jmpBank           ; [28] + 3
; IF TEST_FRAME_SKIP ;{
;  ldx #0
;  lda INTIM
;  cmp #1
;  bpl .ok
;  ldx jmpVec+1
;.ok
;  stx COLUBK
; ENDIF ;}
  jmp MainLoop          ; [31] + 3


; -----------------------------------------------------------------------------
; Joystick Handler [413] (35+58+114+123+12+22+49)
; -----------------------------------------------------------------------------

; IF FIRST_TASK = 0
;  START_TASK Joystick, 8, NO_SKIP, MoveSprites ; 01.08.2013
; ELSE ; saves 26 cycles
  START_TASK Joystick, 7, NO_SKIP, MoveSprites ; 01.08.2013
; ENDIF

 IF DISABLE = 0

 IF FIRST_TASK = 0
  ; speed limitation
  lda taskBits                  ; [9] + 3       kernel displayed since last cycle start?
;  bmi MoveSprites               ; [12] + 2/3     no, wait until time is up!
  bpl .doTask                   ; [12] + 2/3
  ; kernel not yet executed
  cmp #KERNEL_EXEC|KERNEL_MISSED; [14] + 2      was the kernel missed before?
  bcc Joystick                  ; [16] + 2/3     no, wait until time is up!
  and #<~KERNEL_MISSED          ; [18] + 2       yes, "undo" one kernel miss
.doTask
  ora #KERNEL_EXEC|NUM_BULLETS  ; [20] + 2       yes, set all flags again...
  sta taskBits                  ; [22] + 3       ...and start task loop
  dec taskCycle                 ; [25] + 5

 IF TEST_FRAME_SKIP
  sec
  lax taskCycle
  sbc frameCycle
  sta COLUBK
  sta SCORE
;  sec
;  lax taskCycle
;  sbc frameCycle
;  bmi .okCycle
;  beq .okCycle
;;  lax taskCycle
;;  eor frameCycle
;;;  asl
;;  beq .okCycle
;DEBUG1
;  stx frameCycle
;  sed
;  clc
;  lda SCORE
;  adc #1
;  sta SCORE
;  lda SCORE+1
;  adc #0
;  sta SCORE+1
;  cld
;  lda #$40
;  NOP_W
;.okCycle
;  lda #0
;  sta COLUBK
 ENDIF ; TEST_FRAME_SKIP
 ENDIF ; FIRST_TASK

  ; Check For Ship Explosion
  bit SHIPS                     ; [30] + 3
  bpl .checkJoystick            ; [33] + 2/3
                                ; WORST = 35
  EXIT_TASK Joystick

.checkJoystick
  ldy #0                    ; [0] + 2       prepare sign
  ; Check For Rotation
  lax SHIPVDIR              ; [2] + 3
  bit SWCHA                 ; [5] + 3
  bpl .rotRight             ; [8] + 2/3
  bvc .rotLeft              ; [10] + 2/3
  ; Damp Movement
  txa                       ; [12] + 2
  beq .endRotate            ; [14] + 2/3    no turning speed left
  bpl .rotLeft              ; [16] + 2/3    Reverse Direction
.rotRight
  cmp #SHIP_VSPEED          ; [18] + 2      Max Rotation (< 128)
  beq .rotateShip           ; [20] + 2/3
  clc                       ; [22] + 2
  adc #SHIP_VACC            ; [24] + 2
  bvc .storeRotate          ; [26] + 3

.rotLeft
  cmp #<-SHIP_VSPEED        ; [19] + 2      Min Rotation (> -128)
  beq .rotateShip           ; [21] + 2/3
  sec                       ; [23] + 2
  sbc #SHIP_VACC            ; [25] + 2
.storeRotate
  sta SHIPVDIR              ; [29] + 3
.rotateShip
  ; Sign Extend
  tax                       ; [32] + 2
  bpl .posRot               ; [34] + 2
  dey                       ; [36] + 2
.posRot
  ; Add Rotation
  asl                       ; [38] + 2
  clc                       ; [40] + 2
  adc SHIPDIR_LO            ; [42] + 3
  sta SHIPDIR_LO            ; [45] + 3
  tya                       ; [48] + 2
  adc SHIPDIR_HI            ; [50] + 3
  and #NUM_DIRS-1           ; [53] + 2
  sta SHIPDIR_HI            ; [55] + 3
.endRotate                  ; WORST = 58 CYCLES

; -----------------------------------------------------------------------------

  ; Check For Thrust
; - NTSC: accel: 12; decel: 1.5
; - PAL : accel: 13: decel: 1.75
  ; fine tuning via cycle skip
  lda taskCycle             ; [0] + 3
  and #%11                  ; [3] + 2
  bne .endDecelerateXY      ; [5] + 2/3
  ; Decelerate Ship
  ; Skip If X Velocity = 0
  lax SHIPVX_HI             ; [7] + 3
  ora SHIPVX_LO             ; [10] + 3
  beq .endDecelerateX       ; [13] + 2/3
  ; X Veclocity Decrement
  ldy #0                    ; [15] + 2
  lda #SHIP_DECEL_SPEED-1   ; [17] + 2
  cpx #%10000000            ; [19] + 2
  bcs .decPosX              ; [21] + 2/3
  lda #<-SHIP_DECEL_SPEED   ; [23] + 2         Arcade: half deceleration right
  dey                       ; [25] + 2
.decPosX
  adc SHIPVX_LO             ; [27] + 3
  sta SHIPVX_LO             ; [30] + 3
  tya                       ; [33] + 2
;  1 + -3 = -2   Z=0; N=1; C=0; V=0
;  1 + -2 = -1   Z=0; N=1; C=0; V=0
;  1 + -1 =  0 ! Z=1; N=0; C=1; V=0
; -1 +  2 =  1   Z=0; N=0; C=1; V=0
; -1 +  1 =  0   Z=1; N=0; C=1; V=0
; -1 +  0 = -1 ! Z=0; N=1; C=0; V=0
  adc SHIPVX_HI             ; [35] + 3
;  sta SHIPVX_HI             ; [39] + 3
  ; make sure the ship really stops
  iny                       ; [38] + 2
  beq .decPosX2             ; [40] + 2
  bcs .clearVX              ; [42] + 2/3        A = 0!
  sec                       ; [44] + 2
.decPosX2
  bcs .setVX                ; [46] + 2/3
  tya                       ; [48] + 2
.clearVX
  sta SHIPVX_LO             ; [50] + 3
.setVX
  sta SHIPVX_HI             ; [53] + 3
.endDecelerateX

  ; Skip If Y Velocity = 0
  lax SHIPVY_HI             ; [56] + 3
  ora SHIPVY_LO             ; [59] + 3
  beq .endDecelerateY       ; [62] + 2/3
  ; Y Velocity Decrement
  ldy #0                    ; [64] + 2
  lda #SHIP_DECEL_SPEED-1   ; [66] + 2
  cpx #%10000000            ; [68] + 2
  bcs .decPosY              ; [70] + 2/3
  lda #<-SHIP_DECEL_SPEED   ; [72] + 2          Arcade: half deceleration up
  dey                       ; [74] + 2
.decPosY
  adc SHIPVY_LO             ; [76] + 3
  sta SHIPVY_LO             ; [79] + 3
  tya                       ; [82] + 2
  adc SHIPVY_HI             ; [84] + 3
;  sta SHIPVY_HI             ; [73] + 3
  ; make sure the ship really stops
  iny                       ; [87] + 2
  beq .decPosY2             ; [89] + 2
  bcs .clearVY              ; [91] + 2/3        A = 0!
  sec                       ; [93] + 2
.decPosY2
  bcs .setVY                ; [95] + 2/3
  tya                       ; [97] + 2
.clearVY
  sta SHIPVY_LO             ; [99] + 3
.setVY
  sta SHIPVY_HI             ; [102] + 3
.endDecelerateY
.endDecelerateXY

  lda SWCHA                 ; [105] + 4
  and #%00010000            ; [109] + 2
  beq .accelerateXY         ; [111] + 2/3
  lda sfx1                  ; [113] + 3         other sound playing?
  beq .stopThrustSound      ; [116] + 2/3        no, stop thrust sound
  bne .endThrust            ; [118] + 3          yes, continue other sound
                            ; WORST: 114
.accelerateXY
  ; Accelerate X Axis
  ldx SHIPDIR_HI            ; [0] + 3
  ; inc Velocity X
  ; Check Max Velocity
  lda ShipMaxLoX,X          ; [3] + 4
  cmp SHIPVX_LO             ; [7] + 3
  lda ShipMaxHiX,X          ; [10] + 4
  sbc SHIPVX_HI             ; [14] + 3
  bvc .skipIncEorX          ; [17] + 2/3
  eor #$80                  ; [19] + 2
.skipIncEorX
  eor ShipAccelX,X          ; [21] + 4
  bmi .endAccelerateX       ; [25] + 2/3
  ldy #0                    ; [27] + 2
  lda ShipAccelX,X          ; [29] + 4
  bpl .posVelocityX         ; [33] + 2/3
  dey                       ; [35] + 2
.posVelocityX
  clc                       ; [37] + 2
  adc SHIPVX_LO             ; [39] + 3
  sta SHIPVX_LO             ; [42] + 3
  tya                       ; [45] + 2
  adc SHIPVX_HI             ; [47] + 3
  sta SHIPVX_HI             ; [50] + 3
.endAccelerateX

  ; Accelerate Y Axis
  ; Inc Velocity Y
  lda ShipMaxLoY,X          ; [53] + 4
  cmp SHIPVY_LO             ; [57] + 3
  lda ShipMaxHiY,X          ; [60] + 4
  sbc SHIPVY_HI             ; [64] + 3
  bvc .skipIncEorY          ; [67] + 2/3
  eor #$80                  ; [69] + 2
.skipIncEorY
  eor ShipAccelY,X          ; [71] + 4
  bmi .endAccelerateY       ; [75] + 2/3
  ldy #0                    ; [77] + 2
  lda ShipAccelY,X          ; [79] + 4
  bpl .posVelocityY         ; [83] + 2/3
  dey                       ; [85] + 2
.posVelocityY
  ; Accelerate
  clc                       ; [87] + 2
  adc SHIPVY_LO             ; [89] + 3
  sta SHIPVY_LO             ; [92] + 3
  tya                       ; [95] + 2
  adc SHIPVY_HI             ; [97] + 3
  sta SHIPVY_HI             ; [100] + 3
.endAccelerateY
  ; Play Thrust Sound
  lda sfx1                  ; [103] + 3
  bne .skipThrustSound      ; [106] + 2/3
  lda #8                    ; [108] + 2         white noise
  sta AUDC1                 ; [110] + 3
  lda #31                   ; [113] + 2         lowest frequency
  sta AUDF1                 ; [115] + 3
  lda #6                    ; [118] + 2         medium volume
.stopThrustSound
  sta AUDV1                 ; [120] + 3
.skipThrustSound

.endThrust                  ; WORST = 123 CYCLES
; -----------------------------------------------------------------------------

  lda MODE                  ; [0] + 3
  cmp #MODE_EXPLOSION       ; [3] + 2
  bcs .endFireButton        ; [5] + 2/3

  jsr DebounceFire          ; [] + 6 + 28

  ; Check Fire Button
;  bit DEBOUNCE              ; [7] + 3
;  tax
  bpl .endFireButton        ; [10] + 2/3     BUTTON_BIT?
;  lda disableGunKill
;  bne .endFireButton
                            ; WORST = 12 CYCLES
  ; Find Space for Bullet
  ldx #NUM_BULLETS-1        ; [0] + 2
 IF NUM_BULLETS = 3
  lda BULLETDIR+2           ; [2] + 3
  bmi .storeBulletSpace     ; [5] + 2/3
  dex                       ; [7] + 3
 ENDIF
  lda BULLETDIR+1           ; [10] + 3
  bmi .storeBulletSpace     ; [13] + 2/3
  lda BULLETDIR+0           ; [15] + 3
  bpl .endFireButton        ; [18] + 2/3
  dex                       ; [20] + 2
.storeBulletSpace           ; WORST = 22 CYCLES

  ; Set Bullet to Ship Centre
  ldy SHIPX_HI              ; [0] + 3
  iny                       ; [3] + 2
  sty BULLETX_HI,X          ; [5] + 4
  lda SHIPY_HI              ; [9] + 3
  sta BULLETY_HI,X          ; [12] + 4
  lda SHIPDIR_HI            ; [16] + 3
  sta BULLETDIR,X           ; [19] + 4
  lda #0                    ; [23] + 2
  sta BULLETX_LO,X          ; [25] + 4
  sta BULLETY_LO,X          ; [29] + 4
  lda #BULLET_TIME          ; [33] + 2
  sta bulletTime,x          ; [35] + 4
  ; Play Bullet Sound
  lda #SFX_FIRE_BLLT        ; [39] + 2
  cmp sfx1                  ; [41] + 3      ; using both channels interrupts siren way too much!
  bcc .skipSound            ; [44] + 2/3
  sta sfx1                  ; [46] + 3
.skipSound                  ; WORST = 49 CYCLES

.endFireButton
 ENDIF ; DISABLE
  END_TASK Joystick


; -----------------------------------------------------------------------------
; Move Sprites [314]
; -----------------------------------------------------------------------------

; IF FIRST_TASK = 0
;  START_TASK MoveSprites, 7, NO_SKIP, ShipCollisions ; 23.07.2013
; ELSE
  START_TASK MoveSprites, 7, NO_SKIP, ShipCollisions ; TODO!
; ENDIF

 IF DISABLE = 0
 IF FIRST_TASK = 1
  ; speed limitation
  lda taskBits                  ; [9] + 3       kernel displayed since last cycle start?
;  bmi MoveSprites               ; [12] + 2/3     no, wait until time is up!
  bpl .doTask                   ; [12] + 2/3
  ; kernel not yet executed
  cmp #KERNEL_EXEC|KERNEL_MISSED; [14] + 2      was the kernel missed before?
  bcc MoveSprites               ; [16] + 2/3     no, wait until time is up!
  and #<~KERNEL_MISSED          ; [18] + 2       yes, "undo" one kernel miss
.doTask
  ora #KERNEL_EXEC|NUM_BULLETS  ; [20] + 2       yes, set all flags again...
  sta taskBits                  ; [22] + 3       ...and start task loop
  dec taskCycle                 ; [25] + 5

 IF TEST_FRAME_SKIP
  sec
  lax taskCycle
  sbc frameCycle
  sta COLUBK
  sta SCORE
;  sec
;  lax taskCycle
;  sbc frameCycle
;  bmi .okCycle
;  beq .okCycle
;;  lax taskCycle
;;  eor frameCycle
;;;  asl
;;  beq .okCycle
;DEBUG1
;  stx frameCycle
;  sed
;  clc
;  lda SCORE
;  adc #1
;  sta SCORE
;  lda SCORE+1
;  adc #0
;  sta SCORE+1
;  cld
;  lda #$40
;  NOP_W
;.okCycle
;  lda #0
;  sta COLUBK
 ENDIF
 ENDIF ; FIRST_TASK

  ; Move Ship Sprite
  bit SHIPS                 ; [0] + 3
  bmi .skipMoveShip         ; [3] + 2/3
  ; only move if not exploding
  clc                       ; [0] + 2
  lda SHIPX_LO              ; [2] + 3
  adc SHIPVX_LO             ; [5] + 3
  sta SHIPX_LO              ; [8] + 3
  lda SHIPX_HI              ; [11] + 3
  adc SHIPVX_HI             ; [14] + 3
  ; Check Hi/Low Wrap
  cmp #SCREEN_WIDTH         ; [17] + 2      254/161->158/1
  bcc .storeX               ; [19] + 2/3
  sbc #256-SCREEN_WIDTH     ; [21] + 2
  bmi .storeX               ; [23] + 2/3
  sbc #<(SCREEN_WIDTH*2)    ; [25] + 2
.storeX
  sta SHIPX_HI              ; [27] + 3

  clc                       ; [0] + 2
  lda SHIPY_LO              ; [2] + 3
  adc SHIPVY_LO             ; [5] + 3
  sta SHIPY_LO              ; [8] + 3
  lda SHIPY_HI              ; [11] + 3
  adc SHIPVY_HI             ; [14] + 3
  ; Check Hi/Low Wrap
  cmp #YSTART               ; [17] + 2      254/101->98/1
  bcc .storeY               ; [19] + 2/3
  sbc #YSTART               ; [21] + 2
  bpl .storeY               ; [23] + 2/3
  sbc #256-YSTART*2         ; [25] + 2
.storeY
  sta SHIPY_HI              ; [27] + 3
.skipMoveShip               ; WORST = 5+2*30 = 65 CYCLES

; -----------------------------------------------------------------------------
  ; Move Bullet 0
  ldy BULLETDIR+0           ; [0] + 3
  bmi .endMoveBullet0       ; [3] + 2/3

  dec bulletTime+0          ; [5] + 5
  bne .contBullet0          ; [10] + 2/3
  lda #$FF                  ; [] + 2
  sta BULLETDIR+0           ; [] + 3
  bne .endMoveBullet0       ; [] + 3

.contBullet0
  ; Update X Position
  clc                       ; [13] + 2
  lda BulletLoX,Y           ; [15] + 4
  adc BULLETX_LO+0          ; [19] + 3
  sta BULLETX_LO+0          ; [22] + 3
  lda BulletHiX,Y           ; [25] + 4      157->159 C=1, N=0
  adc BULLETX_HI+0          ; [29] + 3      159->161 C=1, N=0
  cmp BULLETX_HI+0          ; [32] + 3        1->255 C=1, N=1
  beq .endBulletX0          ; [35] + 2/3      3->  1 C=0, N=1
  bpl .posXBullet0          ; [37] + 2/3
  bcc .storeXBullet0        ; [39] + 2/3
  adc #SCREEN_WIDTH         ; [41] + 2      bullet wraps around
  bcs .storeXBullet0        ; [43] + 3

.posXBullet0
  cmp #SCREEN_WIDTH         ; [40] + 2
  bcc .storeXBullet0        ; [42] + 2/3
  sbc #SCREEN_WIDTH         ; [44] + 2      bullet wraps around
.storeXBullet0
  sta BULLETX_HI+0          ; [46] + 3
.endBulletX0

  ; Update Y Position
  clc                       ; [49] + 2
  lda BulletLoY,Y           ; [51] + 4
  adc BULLETY_LO+0          ; [55] + 3
  sta BULLETY_LO+0          ; [58] + 3
  lda BulletHiY,Y           ; [61] + 4
  adc BULLETY_HI+0          ; [65] + 3
  cmp BULLETY_HI+0          ; [68] + 3
  beq .endBulletY0          ; [71] + 2/3
  bpl .posYBullet0          ; [73] + 2/3
  bcc .storeYBullet0        ; [75] + 2/3
  adc #YSTART               ; [77] + 2      bullet wraps around
  bcs .storeYBullet0        ; [79] + 3

.posYBullet0
  cmp #YSTART               ; [76] + 2
  bcc .storeYBullet0        ; [78] + 2/3
  sbc #YSTART               ; [80] + 2      bullet wraps around
.storeYBullet0
  sta BULLETY_HI+0          ; [82] + 3
.endBulletY0
.endMoveBullet0             ; WORST = 85 CYCLES

; -----------------------------------------------------------------------------
  ; Move Bullet 1
  ldy BULLETDIR+1           ; [0] + 3
  bmi .endMoveBullet1       ; [3] + 2/3

  dec bulletTime+1          ; [5] + 5
  bne .contBullet1          ; [10] + 2/3
  lda #$FF                  ; [] + 2
  sta BULLETDIR+1           ; [] + 3
  bne .endMoveBullet1       ; [] + 3

.contBullet1
  ; Update X Position
  clc                       ; [13] + 2
  lda BulletLoX,Y           ; [15] + 4
  adc BULLETX_LO+1          ; [19] + 3
  sta BULLETX_LO+1          ; [22] + 3
  lda BulletHiX,Y           ; [25] + 4      157->159 C=1, N=0
  adc BULLETX_HI+1          ; [29] + 3      159->161 C=1, N=0
  cmp BULLETX_HI+1          ; [32] + 3        1->255 C=1, N=1
  beq .endBulletX1          ; [35] + 2/3      3->  1 C=0, N=1
  bpl .posXBullet1          ; [37] + 2/3
  bcc .storeXBullet1        ; [39] + 2/3
  adc #SCREEN_WIDTH         ; [41] + 2      bullet wraps around
  bcs .storeXBullet1        ; [43] + 3

.posXBullet1
  cmp #SCREEN_WIDTH         ; [40] + 2
  bcc .storeXBullet1        ; [42] + 2/3
  sbc #SCREEN_WIDTH         ; [44] + 2      bullet wraps around
.storeXBullet1
  sta BULLETX_HI+1          ; [46] + 3
.endBulletX1

  ; Update Y Position
  clc                       ; [49] + 2
  lda BulletLoY,Y           ; [51] + 4
  adc BULLETY_LO+1          ; [55] + 3
  sta BULLETY_LO+1          ; [58] + 3
  lda BulletHiY,Y           ; [61] + 4
  adc BULLETY_HI+1          ; [65] + 3
  cmp BULLETY_HI+1          ; [68] + 3
  beq .endBulletY1          ; [71] + 2/3
  bpl .posYBullet1          ; [73] + 2/3
  bcc .storeYBullet1        ; [75] + 2/3
  adc #YSTART               ; [77] + 2      bullet wraps around
  bcs .storeYBullet1        ; [79] + 3

.posYBullet1
  cmp #YSTART               ; [76] + 2
  bcc .storeYBullet1        ; [78] + 2/3
  sbc #YSTART               ; [80] + 2      bullet wraps around
.storeYBullet1
  sta BULLETY_HI+1          ; [82] + 3
.endBulletY1
.endMoveBullet1             ; WORST = 85 CYCLES

; -----------------------------------------------------------------------------

  IF NUM_BULLETS = 3
  ; Move Bullet 2
  ldy BULLETDIR+2           ; [0] + 3
  bmi .endMoveBullet2       ; [3] + 2/3

  dec bulletTime+2          ; [5] + 5
  bne .contBullet2          ; [10] + 2/3
  lda #$FF                  ; [] + 2
  sta BULLETDIR+2           ; [] + 3
  bne .endMoveBullet2       ; [] + 3

.contBullet2
  ; Update X Position
  clc                       ; [13] + 2
  lda BulletLoX,Y           ; [15] + 4
  adc BULLETX_LO+2          ; [19] + 3
  sta BULLETX_LO+2          ; [22] + 3
  lda BulletHiX,Y           ; [25] + 4      157->159 C=1, N=0
  adc BULLETX_HI+2          ; [29] + 3      159->161 C=1, N=0
  cmp BULLETX_HI+2          ; [32] + 3        1->255 C=1, N=1
  beq .endBulletX2          ; [35] + 2/3      3->  1 C=0, N=1
  bpl .posXBullet2          ; [37] + 2/3
  bcc .storeXBullet2        ; [39] + 2/3
  adc #SCREEN_WIDTH         ; [41] + 2      bullet wraps around
  bcs .storeXBullet2        ; [43] + 3

.posXBullet2
  cmp #SCREEN_WIDTH         ; [40] + 2
  bcc .storeXBullet2        ; [42] + 2/3
  sbc #SCREEN_WIDTH         ; [44] + 2      bullet wraps around
.storeXBullet2
  sta BULLETX_HI+2          ; [46] + 3
.endBulletX2

  ; Update Y Position
  clc                       ; [49] + 2
  lda BulletLoY,Y           ; [51] + 4
  adc BULLETY_LO+2          ; [55] + 3
  sta BULLETY_LO+2          ; [58] + 3
  lda BulletHiY,Y           ; [61] + 4
  adc BULLETY_HI+2          ; [65] + 3
  cmp BULLETY_HI+2          ; [68] + 3
  beq .endBulletY2          ; [71] + 2/3
  bpl .posYBullet2          ; [73] + 2/3
  bcc .storeYBullet2        ; [75] + 2/3
  adc #YSTART               ; [77] + 2      bullet wraps around
  bcs .storeYBullet2        ; [79] + 3

.posYBullet2
  cmp #YSTART               ; [76] + 2
  bcc .storeYBullet2        ; [78] + 2/3
  sbc #YSTART               ; [80] + 2      bullet wraps around
.storeYBullet2
  sta BULLETY_HI+2          ; [82] + 3
.endBulletY2
.endMoveBullet2             ; WORST = 85 CYCLES
  ENDIF ; DISABLE

; -----------------------------------------------------------------------------
  ; Move Projectile
  lax PROJDIR               ; [0] + 3
  bmi .endMoveProjectile    ; [3] + 2/3
  asl
  bmi .endMoveProjectile    ; [3] + 2/3         explosion spark
  ; Update X Position
;  clc                       ; [5] + 2
  lda PROJX_LO              ; [7] + 3
;  adc ShipMaxLoX,X          ; [10] + 4
 adc BulletLoX,X
  sta PROJX_LO              ; [14] + 3
  lda PROJX_HI              ; [17] + 3
;  adc ShipMaxHiX,X          ; [20] + 4
 adc BulletHiX,X
  sta PROJX_HI              ; [24] + 3
  cmp #SCREEN_WIDTH-6       ; [27] + 2          -5 to avoid wrap around
  bcs .stopProjectile       ; [29] + 2/3
  ; Update Y Position
;  clc                       ; [31] + 2
  lda PROJY_LO              ; [31] + 3
;  adc ShipMaxLoY,X          ; [34] + 4
 adc BulletLoY,X
  sta PROJY_LO              ; [38] + 3
  lda PROJY_HI              ; [41] + 3
;  adc ShipMaxHiY,X          ; [44] + 4
 adc BulletHiY,X
  sta PROJY_HI              ; [48] + 3
  cmp #YSTART               ; [51] + 2
  bcc .endMoveProjectile    ; [53] + 2/3
.stopProjectile
  ror PROJDIR               ; [55] + 5          C=1
.endMoveProjectile          ; WORST = 60 CYCLES
 ENDIF ; DISABLE
  END_TASK MoveSprites


; -----------------------------------------------------------------------------

CastleSetup SUBROUTINE
  ; Ring Colour Index
  lda COLMODE
  beq .modeNTSC
  eor #%100010              ; 100000, 100011
  lsr                       ;  10000,  10001
  bcc .modeBW
  lsr                       ;   1000
.modeNTSC
  eor castle
  and #%11111000            ; 0 -> 7
  eor castle
.modeBW
  tay
 IF PHASED_REGEN
  ; Set Ring Colours
  lda RingCols0,Y
  sta ringColX
  lda RingCols1,Y
  sta RINGCOL0
  lda RingCols2,Y
  sta RINGCOL1

  ; 012xxxxx ->12x0xxxx
  lda ringDirs
  asl
  bcc .skipReverse
  ora #RINGX_DIR
.skipReverse
  sta ringDirs
  lda #2                        ; start with phase 2, phase 0 is automatically started in
  sta regenPhase                ;  parallel one frame later (sequence is once repeated)
  asl
  sta disableGunKill            ; disable gun kill until all rings are generated

  ; transfer speeds once (so that after 2 more transfers they are back to original)
  lda ringSpeedIdx              ; [0] + 3
  cmp #RING_SPEEDS*(NUM_RINGS-1); [3] + 2
  bcc .contSpeedLoop            ; [5] + 2/3
  lda #<-(RING_SPEEDS+1)        ; [7] + 2
.contSpeedLoop
  adc #RING_SPEEDS              ; [9] + 2
  sta ringSpeedIdx              ; [11] + 3

  ; clear all sectors
  ldx #TOTAL_SECS
  lda #CLEAR_SEC                ;           = $ff
.sectorInitLoop
  dex
  sta SECTORMAP_W,x
  bne .sectorInitLoop
  stx SECTORS                   ;           clears BREACH_BIT too
  ; Set Sector Offsets
  stx OFFSET0
  stx OFFSET1
  stx OFFSET2
  stx offsetX
 ELSE ;{
  ; Set Ring Colours
  lda RingCols0,Y
  sta RINGCOL0
  lda RingCols1,Y
  sta RINGCOL1
  lda RingCols2,Y
  sta RINGCOL2

  ; Sector Count
  ldy #TOTAL_SECS
  sty SECTORS               ; clears BREACH_BIT too
  ; Set Sector Offsets
  lda #FULL_SEC             ; = 0
.sectorInitLoop
  dey
  sta SECTORMAP_W,y
  bne .sectorInitLoop
  sty OFFSET0
  sty OFFSET1
  sty OFFSET2
 ENDIF ;}

;  lda #8
;  sta GUNDIR                ; set gun facing right

; DEBUG
;  lda #$00
;  sta SECTORMAP0_W
;  stx SECTORMAP0_W
;  stx SECTORMAP0_W+10
;  stx SECTORMAP1_W
;  stx SECTORMAP1_W+10
;  stx SECTORMAP2_W
;  stx SECTORMAP2_W+10
;
;  ldx #YRINGS-1
;.loopS
;  lda #$c3
;  sta GRID_W1,x
;  lda #$3c
;  sta GRID_W2,x
;  lda #$55
;  sta GRID_W3,x
;  lda #$aa
;  sta GRID_W4,x
;  lda #$c3
;  sta GRID_W0,x
;  dex
;  bpl .loopS

  ldx #<BULLETX_HI

; -----------------------------------------------------------------------------
ShipSetup SUBROUTINE
  lda SHIPS                 ; ShipSetup: N=1; CastleSetup: N=0/1
  bpl ResetVars             ; keep ship data if not exploding too!
  asl
  lsr                       ; remove explosion flag
  sta SHIPS
 IF INIT_SHIPS_A != INIT_SHIPS_B
  bit difficulty
  bvc .lowDiff
  sbc #INIT_SHIPS_A-1       ; C=0!
  NOP_W
.lowDiff
 ENDIF
  sbc #INIT_SHIPS_B-1       ; C=0!
  sec
  sbc castle
  and #%111
  tay

;  lda #50+2
;  sta SHIPY_HI
;  lda #(MIDDLEX+23)
;  sta SHIPX_HI
;  ldx #24                   ; new ship initially facing left
;  stx SHIPDIR_HI

;  lda #50-17
;  sta SHIPY_HI
;  lda #(MIDDLEX+14)
;  sta SHIPX_HI
;  ldx #29                   ; new ship initially facing left
;  stx SHIPDIR_HI


  ; Set Ship Position and Direction
  lda ShipYStart,Y
  sta SHIPY_HI
  lda #(MIDDLEX+60)
  sta SHIPX_HI
  ldx #24                   ; new ship initially facing left
  stx SHIPDIR_HI

  ; Reset Game Variables
  ldx #<SHIPX_LO
ResetVars
  lda #0
 IF OVERHEAT
  sta overheat
 ENDIF
.clearVarsLoop
  sta $00,X
  inx
  cpx #<SECTORS
  bne .clearVarsLoop

  ; Clear Mine Modes & Initial Mine Counters
  ldx #NUM_MINES-1
  tay
 IF PHASED_REGEN
  lda #17
 ELSE
  lda #11
 ENDIF
;  sec
.loopMines
  sty MINEDIR_W,X         ; MINE_DEAD
  sta MINECOUNT_W,x
  sbc #5
  dex
  bpl .loopMines

  ; fix for initial mine flicker:
  lda #MIDDLEX
  sta MINEX_HI_W

  ; Hide Bullets & Projectile
  stx BULLETDIR+0
  stx BULLETDIR+1
 IF NUM_BULLETS = 3
  stx BULLETDIR+2
 ENDIF
  stx PROJDIR

 IF TEST_FRAME_SKIP
  lda frameCycle
  sta taskCycle
 ENDIF

  ; prepare first task loop:
 IF FIRST_TASK = 0
  GET_BANK_JMPVEC Joystick
 ELSE
  GET_BANK_JMPVEC MoveSprites
 ENDIF
  sta   jmpVec              ; [0] + 3
  sty   jmpVec+1            ; [3] + 3
  stx   jmpBank             ; [6] + 3
  ; bpl flag used on return!
Wait12_0
  rts


; -----------------------------------------------------------------------------
; Game Messages
; -----------------------------------------------------------------------------
ShowMessages SUBROUTINE
  ; Set Number and Message Pointers (30Hz)
  sta WSYNC                 ; [0]
;--------------------------------------
  lda CYCLE                 ; [0] + 3
  lsr                       ; [3] + 2
  bcs TextBPointers         ; [5] + 2/3
  BRANCH_PAGE_ERROR TextBPointers, "TextBPointers"
;TextAPointers
  lda #<NumberTableA        ; [7] + 2
  ldx #<MessageTableA       ; [14] + 2
  ldy #>MessageTableA       ; [16] + 2
  bne StoreTextPointers     ; [18] + 3
  BRANCH_PAGE_ERROR StoreTextPointers, "StoreTextPointers"

TextBPointers
  lda #<NumberTableB        ; [8] + 2
  ldx #<MessageTableB       ; [10] + 2
  ldy #>MessageTableB       ; [12] + 2
  nop                       ; [14] + 2
StoreTextPointers
  sta NPTR                  ; [16] + 3
  stx LPTR                  ; [19] + 3
  sty LPTR+1                ; [22] + 3
  lda #>NumberTableA        ; [25] + 2
  sta NPTR+1                ; [27] + 3

  ; Set Star Colour
  ldx COLMODE               ; [30] + 3
  stx REFP0                 ; [33] + 3          disable ship reflection
  lda StarCols0,X           ; [36] + 4
  sta COLUP1                ; [40] + 3
  pha                       ; [43] + 3          remember for bottom stars

  ; Star Position
  jsr Wait12_0              ; [46] + 12
  sta.w RESM1               ; [58] + 4    = 62
  php

  ; Begin Frame
.waitMessagesVblank
  ldx INTIM
  bne .waitMessagesVblank
  stx VBLANK
  stx AUDV1                 ; [47] + 3
; wait 11*64/76 = ~9 extra lines
  ldx #(KERNEL_DELAY*64+32)/76-1-1
  jsr SkipLines

; -----------------------------------------------------------------------------

  ; update siren sound (scan line 35)
  lda sirenF0_R
  sta AUDF0

  ; Set Line Counter & Jump To Top Kernel
  ldy #YOFFSET
  jsr DrawStars                 ; draws top stars

; -----------------------------------------------------------------------------

  ; Check Game Mode
  lda MODE
  and #MODE_MASK
  cmp #MODE_GET_READY
  bne .showScore
  ; Show Get Ready Message
  ldy #0+5
  jsr LoadMessage
  ldx #34-1-1
  jsr TextDisplay
  ldx #36
  bne .showBottomStars

.showScore
  ; Display Score
  jsr LoadScore
  ldx #16-1
  jsr TextDisplay
  lda MODE
  and #MODE_TIMER
  cmp #SHIPS_CASTLE_TIM/2       ; switch between ships and castle
  eor MODE
  ; Check Game Mode
  eor #MODE_SCORE_CASTLE
  beq .showCastle
  eor #(MODE_SCORE_SHIPS^MODE_SCORE_CASTLE)
  bne .showGameOver
;.showShips
  bcc .showCastle2
.showShips2
  ldy #28
  ; Check For Final Ship
  lda SHIPS
  and #%01111111
  bne .showRemainingShips
  ; Display Last Ship Message
  ldy #6+5
.displayMessage
  ldx #18-8
  jsr SkipLines
  jsr LoadMessage
  bne .textDisplay

.showGameOver ; or Paused
  ; Display Game Over Message
  ldy #12+5
  eor #(MODE_GAME_OVER^MODE_SCORE_SHIPS)
  beq .displayMessage
  ; Display Paused Message
  ldy #18+5
  bne .displayMessage

.showCastle
  bcc .showShips2
.showCastle2
  ldy #24                   ; [3] + 2
  lda castle                ; [0] + 3
.showRemainingShips
  jsr LoadCastleShips       ; 11 lines
  ldx #12-1-8
  jsr SkipLines
.textDisplay
  ; update siren sound (scan line 105)
  lda sirenF1_R
  sta AUDF0
  ldx #8-1
  jsr TextDisplay
  ldx #19-10
  jsr SkipLines
  ; update siren sound (scan line 165)
  lda sirenF2_R
  sta AUDF0

  ldx #10-1
.showBottomStars
  plp
  pla
  sta COLUP1
  jsr SkipLines

; -----------------------------------------------------------------------------

  ; Set Line Counter & Jump To Bottom Kernel
  ldy #YOFFSET+BottomStars_A-TopStars_A
  jsr DrawStars             ; draws bottom stars

  ; update siren sound (scan line 235)
  lda sirenF3_R
  sta AUDF0

  ; Begin Overscan
  lda #2
  sta VBLANK

  lda #OVERDELAY            ; + 1 saves WSYNC
  sta TIM64T

  ; Update Modes
;  jmp ModeTransition

; -----------------------------------------------------------------------------
; Mode Transitions (from Message Screen)
; -----------------------------------------------------------------------------

ModeTransition
  jsr DebounceFire

;  ldy DEBOUNCE                  ; FIRE_BIT
  tay
  lda MODE
  and #MODE_TIMER
  tax                           ; timer
  eor MODE                      ; == MODE & MODE_MASK
  asl
  bcc .mainGameTransition
  beq .gameOverTransition       ; (MODE_GAME_OVER==%100)<<1 == %000
  ; now it must be MODE_PAUSED
;.pauseTransition                ; (MODE_PAUSED==%101)<<1 = %010
  ; Check Pause Button
  tya
  and #PAUSE_FLAG
  bne .endTransitions           ; more time left/pause still enabled
  beq .resumeGameTransition

.gameOverTransition
  ; Check Timer
  txa                           ; == MODE & %00011111
  bne .endTransitions
  ; End of Game
  BEGIN_VBLANK_MSG
EndGameTim = . - 5              ; points to lda #(VBLANKDELAY+KERNEL_DELAY)
  jmp EndGame                   ; C==1! (do NOT clear score)

.mainGameTransition
  asl
  tya
  bcs .nextCastleTransition
;.nextShipTransition             ; (MODE_SCORE_SHIPS==%001)<<2 == %100
  ; Skip If Fire Pressed
  bmi .endShipTransition        ; FIRE_BIT
  ; Check Timer
  txa                           ; == MODE & %00011111
  bne .endTransitions
.endShipTransition
  ; Setup Next Ship
  jsr ShipSetup
  bpl .resumeGameTransition

.nextCastleTransition           ; (MODE_SCORE_CASTLE==%010)<<2 == %000
;.getReadyTransition             ; (MODE_GET_READY==%011)<<2 == %100
  ; Skip If Fire Pressed
  bmi .endCastleTransition      ; FIRE_BIT
  ; Check Timer
  txa                           ; == MODE & %00011111
  bne .endTransitions
.endCastleTransition
  ; Setup Next Castle
  jsr CastleSetup
.resumeGameTransition
  lda #MODE_MAIN_GAME           ; ==0
  sta MODE
.endTransitions
  jmp MainLoop


; -----------------------------------------------------------------------------
; Subroutines
; -----------------------------------------------------------------------------

  ; Load Message Pointers
LoadMessage SUBROUTINE
  lda (LPTR),Y              ; [0] + 5
  sta PTR5                  ; [5] + 3
  ldx #8                    ; [8] + 2 = 10
.loop
  dey                       ; [0] + 2
  lda (LPTR),Y              ; [2] + 5
  sta PTR0,x                ; [7] + 4
  dex                       ; [11] + 2
  dex                       ; [13] + 2
  bpl .loop                 ; [15] + 2/3 = 89
  lax LPTR+1                ; [0] + 3
  ldy #5-1                  ;               character height
  bne LoadHi                ; [3] + 29
                            ; TOTAL = 131 CYCLES

; -----------------------------------------------------------------------------

BLANK SET 10

  ; Load Score Pointers
LoadScore SUBROUTINE
  ; Digits 5 & 4
  ldy #BLANK                ;               blank digit
  lax SCORE+2               ; [0] + 3
  lsr                       ; [3] + 2
  lsr                       ; [5] + 2
  lsr                       ; [7] + 2
  lsr                       ; [9] + 2
  beq .blank5               ; [11] + 2/3    remove leading zeroes
  tay                       ; [11] + 2
.blank5
  lda (NPTR),Y              ; [13] + 5
  sta PTR0                  ; [18] + 3
  txa                       ; [21] + 2
  and #%00001111            ; [23] + 2
  bne .noBlank4
  cpy #BLANK
  beq .blank4
.noBlank4
  tay                       ; [25] + 2
.blank4
  lda (NPTR),Y              ; [27] + 5
  sta PTR1                  ; [32] + 3
  ; Digits 3 & 2
  lax SCORE+1               ; [35] + 3
  lsr                       ; [38] + 2
  lsr                       ; [40] + 2
  lsr                       ; [42] + 2
  lsr                       ; [44] + 2
  bne .noBlank3
  cpy #BLANK
  beq .blank3
.noBlank3
  tay                       ; [46] + 2
.blank3
  lda (NPTR),Y              ; [48] + 5
  sta PTR2                  ; [53] + 3
  txa                       ; [56] + 2
  and #%00001111            ; [58] + 2
  bne .noBlank2
  cpy #BLANK
  beq .blank2
.noBlank2
  tay                       ; [60] + 2
.blank2
  lda (NPTR),Y              ; [62] + 5
  sta PTR3                  ; [67] + 3
  ; Digits 1 & 0
  lda #>NumbersA            ; [105] + 2
  ldx SCORE+0               ; [70] + 3
Load1_2
  pha
  txa
  lsr                       ; [73] + 2
  lsr                       ; [75] + 2
  lsr                       ; [77] + 2
  lsr                       ; [79] + 2
  bne .noBlank1
  cpy #BLANK
  beq .blank1
.noBlank1
  tay                       ; [81] + 2
.blank1
  lda (NPTR),Y              ; [83] + 5
  sta PTR4                  ; [88] + 3
  txa                       ; [91] + 2
  and #%00001111            ; [93] + 2
  tay                       ; [95] + 2
  lda (NPTR),Y              ; [97] + 5
  sta PTR5                  ; [102] + 3
  ldx #>NumbersA            ; [105] + 2
  pla                       ; [107] + 2
  ldy #11-1                 ;               digit height
LoadHi
  ; High Pointers
  stx PTR4+1                ; [0] + 3
  stx PTR5+1                ; [3] + 3
  sta PTR0+1                ; [6] + 3
  sta PTR1+1                ; [9] + 3
  sta PTR2+1                ; [11] + 3
  sta PTR3+1                ; [14] + 3
  rts                       ; [17] + 6 = 23
                            ; TOTAL = 135 CYCLES

; -----------------------------------------------------------------------------

  ; Load Castle & Ships Messages
LoadCastleShips SUBROUTINE
  sta TEMP                  ; [11] + 3 = 14
  ; Message Pointers
  lda (LPTR),Y              ; [0] + 5
  sta PTR0                  ; [5] + 3
  iny                       ; [8] + 2
  lda (LPTR),Y              ; [10] + 5
  sta PTR1                  ; [15] + 3
  iny                       ; [18] + 2
  lda (LPTR),Y              ; [20] + 5
  sta PTR2                  ; [25] + 3
  iny                       ; [28] + 2
  lda (LPTR),Y              ; [30] + 5
  sta PTR3                  ; [35] + 3 = 38
  ; Number Pointers
; convert into BCD (0..127)
  sed                       ; [0] + 2
  lda #0+1                  ; [2] + 2       show value + 1
  ldx #7-1                  ; [4] + 2 = 6   set bit count
BitLoop
  lsr TEMP                  ; [0] + 5       bit to carry
  bcc .skipAdd              ; [7] + 2/3     branch if no add
  adc BCDTable,x            ; [9] + 4       else add bcd value
.skipAdd
  dex                       ; [13] + 2      decrement bit count
  bpl BitLoop               ; [15] + 2/3    loop if more to do
                            ; = 6*16-1 = 95
  PAGE_WARN BitLoop, "BitLoop"
  cld                       ; [0] + 2        do not forget! :)
  tax                       ; [2] + 2
  lda LPTR+1                ; [4] + 3
  ldy #BLANK                ; [7] + 2
  bne Load1_2               ; [9] + 3
                            ; TOTAL = 205..223 CYCLES

; -----------------------------------------------------------------------------
TextDisplay SUBROUTINE ; 468 bytes including char data
.textRow = TEMP2
  jsr SkipLines

  ; Store Text Height
 IF KERNEL_SHL_3
  sta WSYNC                 ; [0]
  sty .textRow              ; [0] + 3
 ELSE
  sty .textRow              ; [0] + 3
  sta WSYNC                 ; [0]
 ENDIF

  ; 3 Copies Close
  lda #%00010011            ; [3] + 2
  sta NUSIZ0                ; [5] + 3
  sta NUSIZ1                ; [8] + 3

  ; Delay Sprites

  sta VDELP0                ; [26] + 3
  sta VDELP1                ; [29] + 3

  ; Fine Positions
  sta HMCLR                 ; [32] + 3
  sta HMP1                  ; [35] + 3

  ; Sprite Colours
  ldx COLMODE               ; [11] + 3
  lda TextCols0,X           ; [14] + 4
  sta COLUP0                ; [18] + 3
  sta COLUP1                ; [21] + 3

 IF KERNEL_SHL_3
  ; Position Sprites
  sta.w RESP0               ; [38] + 3      = 41
  sta RESP1                 ; [41] + 3      = 44

  ; Load First Chars
  lax (PTR0),Y              ; [44] + 5
  lda (PTR4),Y              ; [49] + 5
  sta TEMP                  ; [30] + 3
 ELSE
  ; Load First Chars
  lax (PTR0),Y              ; [44] + 5

  ; Position Sprites
  sta RESP0                 ; [38] + 3      = 41
  sta RESP1                 ; [41] + 3      = 44

  ; Load First Chars
  lda (PTR1),Y              ; [49] + 5
 ENDIF
  ; Move Sprites
  sta WSYNC                 ; [0]
  sta HMOVE                 ; [0] + 3       > 74 < 4
  jmp .startText            ; [6] + 3

TextLoop
  ; Update Counter
  dey
 IF KERNEL_SHL_3
  ; Display First 3 Chars
  lax (PTR0),Y              ; [66] + 5
  lda (PTR4),Y              ; [25] + 5
  sta WSYNC                 ; [71] + 3
  sty .textRow              ; [55] + 5
  sta TEMP                  ; [30] + 3
.startText
  lda (PTR1),Y              ; [6] + 5
  stx.w GRP0                ; [11] + 4      > 54
  sta GRP1                  ; [15] + 3      < 43
  lda (PTR2),Y              ; [18] + 5
  sta GRP0                  ; [23] + 3      < 46
  ; Pre-fetch Remaining 3 Chars
  lax (PTR3),Y              ; [26] + 5
 ELSE
  sty .textRow              ; [60] + 3
  ; Display First 3 Chars
  lax (PTR0),Y              ; [63] + 5
  sta WSYNC                 ; [68] + 3
  lda (PTR1),Y              ; [0] + 5
.startText
  stx GRP0                  ; [5] + 3       > 54
  sta GRP1                  ; [8] + 3       < 43
  lda (PTR2),Y              ; [11] + 5
  sta GRP0                  ; [16] + 3      < 46
  ; Pre-fetch Remaining 3 Chars
  lax (PTR3),Y              ; [19] + 5
  lda (PTR4),Y              ; [24] + 5
  sta TEMP                  ; [29] + 3
 ENDIF
  lda (PTR5),Y              ; [32] + 5
  tay                       ; [37] + 2
  lda TEMP                  ; [39] + 3
  ; Display Remaining 3 Chars
  stx GRP1                  ; [42] + 3      > 45 < 48
  sta GRP0                  ; [45] + 3      > 48 < 51
  sty GRP1                  ; [48] + 3      > 50 < 54
  sta GRP0                  ; [51] + 3      > 53 < 56
  ; Fetch Current Line
  ldy .textRow              ; [54] + 3
  bne TextLoop              ; [57] + 2/3
  PAGE_WARN TextLoop, "TextLoop"
  ; Clear Sprite Data
;  iny                       ; [62] + 2
  sty GRP1                  ; [64] + 3
  sty GRP0                  ; [67] + 3
  sty GRP1                  ; [70] + 3
  sty VDELP0                ; [73] + 3
  sty VDELP1                ; [0] + 3
  sty NUSIZ0                ; [3] + 3
  sty NUSIZ1                ; [6] + 3
  rts                       ; [9] + 6

DebounceFire SUBROUTINE
  ; Debounce Fire Button
  lda DEBOUNCE              ; [0] + 3
 IF OVERHEAT
  ldx overheat
;  stx COLUBK
 ENDIF
  bit INPT4                 ; [3] + 3
  bmi .resetFirePressed     ; [6] + 2/3     BUTTON_BIT?
  ; Ignore If Previously Pressed
  asl                       ; [8] + 2       BUTTON_FLAG?
  bmi .clearFirePressed     ; [10] + 2/3

  ; Set Fire Pressed & State
  ; TODO: heat up and suppress fire
  ror                       ; [12] + 2
  ora #(BUTTON_FLAG|BUTTON_BIT);[14] + 2
 IF OVERHEAT
 REPEAT HEAT_INC+1
  inx
 REPEND
  cpx #MAX_HEAT
  bcc .storeFire            ; [16] + 3
  ldx #MAX_HEAT - HEAT_INC
  bne .ignoreFirePressed
 ELSE
  bne .storeFire            ; [16] + 3
 ENDIF

.resetFirePressed
 IF OVERHEAT
  dex
  bpl .coolDown
  inx
.coolDown
.ignoreFirePressed
 ENDIF
  ; button got released
  ; TODO: cool down here
  and #<~(BUTTON_FLAG|BUTTON_BIT); [9] + 2
  bpl .storeFire            ; [11] + 3

.clearFirePressed
  ; button was not released, ignore pressed button
  ror                       ; [13] + 2
  and #<~BUTTON_BIT         ; [15] + 2
.storeFire
 IF OVERHEAT
  stx overheat
 ENDIF
  sta DEBOUNCE              ; [19] + 3
  rts                       ; [22] + 6
                            ; WORST: 28

; -----------------------------------------------------------------------------
; Game Data
; -----------------------------------------------------------------------------

 IF <. > 60
  ALIGN_FREE_LBL 256, "MessageTableA"
 ENDIF

  ; Message Pointers A
MessageTableA
  DC.B  <GetReady0_A, <GetReady1_A, <GetReady2_A
  DC.B  <GetReady3_A, <GetReady4_A, <GetReady5_A
  DC.B  <LastShip0_A, <LastShip1_A, <LastShip2_A
  DC.B  <LastShip3_A, <LastShip4_A, <LastShip5_A
  DC.B  <GameOver0_A, <GameOver1_A, <GameOver2_A
  DC.B  <GameOver3_A,< GameOver4_A, <GameOver5_A
  DC.B  <Paused0_A, <Paused1_A, <Paused2_A
  DC.B  <Paused3_A, <Paused4_A, <Paused0_A
  DC.B  <Castle0_A, <Castle1_A, <Castle2_A, <Castle3_A
  DC.B  <ShipsLeft0_A, ShipsLeft1_A, ShipsLeft2_A, Blank_A
  PAGE_WARN MessageTableA, "MessageTableA"

  ; Messages A
TextA
GetReady1_A
  DC.B  %11100100
  DC.B  %00000100
  DC.B  %11100100
  DC.B  %00100100
  DC.B  %11101110
GetReady2_A
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00011000
  DC.B  %00010110

Paused3_A
  DC.B  %11110111
  DC.B  %00010100
;  DC.B  %11110111
;  DC.B  %10000100
;  DC.B  %11110111
GetReady3_A
  DC.B  %11110111
  DC.B  %10000100
  DC.B  %11110111
  DC.B  %10010000
  DC.B  %11110111

GetReady4_A
  DC.B  %10111101
  DC.B  %10100100
  DC.B  %10111101
  DC.B  %10000101
  DC.B  %10000101
GetReady5_A
  DC.B  %11101000
  DC.B  %00100000
  DC.B  %11101000
  DC.B  %00101000
  DC.B  %00101000
LastShip0_A                 ; Last Ship
  DC.B  %00000111
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %00000100
LastShip1_A
  DC.B  %10111101
  DC.B  %00100100
;  DC.B  %00111101
;  DC.B  %00000101
;  DC.B  %00111101
GetReady0_A                 ; Get Ready
  DC.B  %00111101
  DC.B  %00000101
  DC.B  %00111101
  DC.B  %00100101
;  DC.B  %00111101
GameOver0_A                 ; Game Over
  DC.B  %00111101
  DC.B  %00000101
  DC.B  %00111101
  DC.B  %00100100
  DC.B  %00111101
LastShip2_A
  DC.B  %11100100
  DC.B  %00100100
  DC.B  %11100100
  DC.B  %00000100
  DC.B  %11101110
LastShip3_A
  DC.B  %00011110
  DC.B  %00000010
  DC.B  %00011110
  DC.B  %00010000
  DC.B  %00011110
LastShip4_A
  DC.B  %10010101
  DC.B  %10010101
  DC.B  %11110101
  DC.B  %10010101
  DC.B  %10010101
GameOver1_A
  DC.B  %11101010
  DC.B  %00101010
  DC.B  %11101010
  DC.B  %00101010
  DC.B  %11101101

GameOver2_A
  DC.B  %10111100
  DC.B  %10100000
  DC.B  %10111100
  DC.B  %10100100
;  DC.B  %00111100
GameOver3_A
  DC.B  %00111100
  DC.B  %00100100
  DC.B  %00100100
  DC.B  %00100101
  DC.B  %00111101

GameOver4_A
  DC.B  %01000111
  DC.B  %10100100
  DC.B  %10100111
  DC.B  %00010100
  DC.B  %00010111
GameOver5_A
  DC.B  %10100000
  DC.B  %00100000
  DC.B  %10100000
  DC.B  %10110000
  DC.B  %10101100
Paused1_A
  DC.B  %01000011
  DC.B  %01000010
  DC.B  %01111011
  DC.B  %01001000
  DC.B  %01111011
Paused2_A
  DC.B  %11011110
  DC.B  %01010010
  DC.B  %11010010
  DC.B  %01010010
  DC.B  %11010010
Paused4_A
  DC.B  %10111100
  DC.B  %00100100
  DC.B  %10111100
  DC.B  %10000100
  DC.B  %10000100
Castle0_A                     ; Castle
  DC.B  %00111101
  DC.B  %00100001
  DC.B  %00100001
  DC.B  %00100000
  DC.B  %00111101
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
LastShip5_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %11100000
  DC.B  %00100000
  DC.B  %11100000
Castle1_A
  DC.B  %11101111
  DC.B  %00100001
  DC.B  %11101111
  DC.B  %00101000
  DC.B  %11101111
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
Castle2_A
  DC.B  %00100111
  DC.B  %00100100
  DC.B  %00100100
  DC.B  %00100100
  DC.B  %01110100
Paused0_A                   ; Paused
Blank_A
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
ShipsLeft0_A                ; Ships Left
  DC.B  %00111101
  DC.B  %00000101
  DC.B  %00111101
  DC.B  %00100001
  DC.B  %00111101
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
ShipsLeft1_A
  DC.B  %00101010
  DC.B  %00101010
  DC.B  %11101011
  DC.B  %00101010
  DC.B  %00101011
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
ShipsLeft2_A
  DC.B  %00011110
  DC.B  %00000010
  DC.B  %11011110
  DC.B  %01010000
  DC.B  %11011110
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
Castle3_A
  DC.B  %10111100
  DC.B  %00100000
  DC.B  %00111100
  DC.B  %00100100
  DC.B  %00111100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  PAGE_ERROR MessageTableA, "MessageTableA"

; -----------------------------------------------------------------------------

  ; Number Pointers
NumberTableA
  DC.B  <Number0_A, <Number1_A, <Number2_A, <Number3_A, <Number4_A
  DC.B  <Number5_A, <Number6_A, <Number7_A, <Number8_A, <Number9_A
  DC.B  <NumberBlank
NumberTableB
  PAGE_ERROR NumberTableA, "NumberTableA"
  DC.B  <Number0_B, <Number1_B, <Number2_B, <Number3_B, <Number4_B
  DC.B  <Number5_B, <Number6_B, <Number7_B, <Number8_B, <Number9_B
  DC.B  <NumberBlank
  PAGE_WARN NumberTableA, "NumberTableA"

BCDTable:
  ; Note: values are -1 as the ADC is always done with the carry set
  .byte $63
  .byte $31, $15, $07, $03, $01, $00
  PAGE_WARN BCDTable, "BCDTable"

; -----------------------------------------------------------------------------

  ALIGN_FREE_LBL 256, "MessageTableB"

  ; Message Pointers B
MessageTableB
  DC.B  <GetReady0_B, <GetReady1_B, <GetReady2_B
  DC.B  <GetReady3_B, <GetReady4_B, <GetReady5_B
  DC.B  <LastShip0_B, <LastShip1_B, <LastShip2_B
  DC.B  <LastShip3_B, <LastShip4_B, <LastShip5_B
  DC.B  <GameOver0_B, <GameOver1_B, <GameOver2_B
  DC.B  <GameOver3_B,< GameOver4_B, <GameOver5_B
  DC.B  <Paused0_B, <Paused1_B, <Paused2_B
  DC.B  <Paused3_B, <Paused4_B, <Paused0_B
  DC.B  <Castle0_B, <Castle1_B, <Castle2_B, <Castle3_B
  DC.B  <ShipsLeft0_B, ShipsLeft1_B, ShipsLeft2_B, Blank_B
  PAGE_WARN MessageTableB, "MessageTableB"

  ; Messages B
TextB
GetReady5_B
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00100000
;  DC.B  %00000000
;  DC.B  %00000000
GetReady1_B
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00100000
;  DC.B  %00000000
;  DC.B  %00100100
GameOver2_B
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00100100
  DC.B  %10000000
;  DC.B  %00100100
GameOver3_B
  DC.B  %00100100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00100100
LastShip1_B
  DC.B  %00100100
  DC.B  %00000000
  DC.B  %00100101
  DC.B  %00000000
;  DC.B  %00000101
GetReady0_B
  DC.B  %00000101
  DC.B  %00000000
  DC.B  %00100101
  DC.B  %00000000
  DC.B  %00100101

GetReady3_B
  DC.B  %10000100
  DC.B  %00000000
  DC.B  %10010100
  DC.B  %00000000
  DC.B  %10010000
GetReady4_B
  DC.B  %10100100
  DC.B  %00000000
  DC.B  %10100101
  DC.B  %00000000
  DC.B  %10000000

LastShip2_B
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00100000
  DC.B  %00000000
;  DC.B  %00000100
LastShip0_B
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000

LastShip3_B
  DC.B  %00000010
  DC.B  %00000000
  DC.B  %00010010
  DC.B  %00000000
  DC.B  %00010000

GameOver0_B
  DC.B  %00000101
  DC.B  %00000000
  DC.B  %00100101
  DC.B  %00000000
;  DC.B  %00100100
Paused4_B
  DC.B  %00100100
  DC.B  %00000000
  DC.B  %10100100
  DC.B  %00000000
  DC.B  %10000000
GameOver1_B
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00100000
  DC.B  %00000010
  DC.B  %00101001
GameOver4_B
  DC.B  %01000100
  DC.B  %00000000
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00000100
Paused1_B
  DC.B  %00000010
  DC.B  %00000000
  DC.B  %01001010
  DC.B  %00000000
  DC.B  %01001000
Paused2_B
  DC.B  %01010010
  DC.B  %00000000
  DC.B  %01000000
  DC.B  %00000000
  DC.B  %01000000
Paused3_B
  DC.B  %00010100
  DC.B  %00000000
  DC.B  %10010100
  DC.B  %00000000
  DC.B  %10000100
Castle1_B
  DC.B  %00100001
  DC.B  %00000000
  DC.B  %00101001
  DC.B  %00000000
  DC.B  %00101000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
GetReady2_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00010000
;  DC.B  %00000100
Castle2_B
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
LastShip4_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %10010001
  DC.B  %00000000
  DC.B  %00000001
Castle0_B
  DC.B  %00100001
  DC.B  %00000000
  DC.B  %00000001
  DC.B  %00000000
  DC.B  %00100000
;  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
Paused0_B
Blank_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
LastShip5_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00100000
ShipsLeft0_B
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00100101
  DC.B  %00000000
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
GameOver5_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %10000000
  DC.B  %00100000
  DC.B  %10001000

ShipsLeft2_B
  DC.B  %00000010
  DC.B  %00000000
  DC.B  %01010010
  DC.B  %00000000
  DC.B  %01010000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000000
;  DC.B  %00000000
ShipsLeft1_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00100010
  DC.B  %00000000
  DC.B  %00000010
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
Castle3_B
  DC.B  %00100000
  DC.B  %00000000
  DC.B  %00100100
  DC.B  %00000000
  DC.B  %00100100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  PAGE_ERROR MessageTableB, "MessageTableB"

 IF DISABLE = 0
  ; Ship X Acceleration Table (+0.05 pixels/frame)
    INIT_SPEEDS SHIP_ACCEL_SPEED, 0, 0
ShipAccelX
    DEF_SPEEDS LO, 0, SPEEDS_8_1
  ; Ship Y Acceleration Table (+0.05 pixels/frame)
ShipAccelY
    DEF_SPEEDS LO, 0, SPEEDS_0_1
    PAGE_WARN ShipAccelX, "ShipAccelX"
 ENDIF

NextMineTab
NextBulletTab
  DC.B  0, 1, 2, 0, 1

  ; Skip Scanlines Subroutine
SkipLines SUBROUTINE
  sta WSYNC
  dex
  bpl SkipLines
  rts

 IF <. > 93
  ALIGN_FREE_LBL 256, "NumbersA"
 ENDIF

NumbersA
Number1_A
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
Number4_A
  DC.B  %00001000
  DC.B  %00001000
  DC.B  %00001000
  DC.B  %00001000
  DC.B  %00001000
  DC.B  %01111100
  DC.B  %01001000
  DC.B  %00101000
  DC.B  %00101000
  DC.B  %00011000
  DC.B  %00011000
Number7_A
  DC.B  %00100000
  DC.B  %00100000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00010000
  DC.B  %00001000
  DC.B  %00001000
  DC.B  %00001000
  DC.B  %00000100
  DC.B  %00000100
Number0_A
  DC.B  %01111100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
Number3_A
  DC.B  %01111100
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %00011100
  DC.B  %00001000
  DC.B  %00001000
  DC.B  %00000100
  DC.B  %00000100
Number9_A
  DC.B  %01111100
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %00000100
Number8_A
  DC.B  %01111100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
Number6_A
  DC.B  %01111100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
  DC.B  %01000100
Number2_A
  DC.B  %01111100
  DC.B  %01000000
  DC.B  %01000000
  DC.B  %01000000
  DC.B  %01000000
Number5_A
  DC.B  %01111100
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %00000100
  DC.B  %01111100
  DC.B  %01000000
  DC.B  %01000000
  DC.B  %01000000
  DC.B  %01000000
  DC.B  %01111100

  ; Numbers B
NumberBlank
Number1_B
  DC.B  %00000000
Number7_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000100
Number9_B
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
Number8_B
  DC.B  %01000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
Number6_B
  DC.B  %01000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %01000000
Number2_B
  DC.B  %01000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000100
Number3_B
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00010100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
;  DC.B  %00000100
Number5_B
  DC.B  %00000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01000000

Number0_B
  DC.B  %01000100
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01000100

Number4_B
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %01001000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00000000
  DC.B  %00011000
  PAGE_ERROR NumbersA, "NumbersA"

;  ALIGN_FREE 256

StarCols0
  DC.B  STAR_COL_NTSC, STAR_COL_PAL, STAR_COL_BW        ; NTSC/PAL/B&W
  PAGE_ERROR StarCols0, "StarCols0"
TextCols0
  DC.B  TEXT_COL_NTSC|$C, TEXT_COL_PAL|$C, TEXT_COL_BW  ; NTSC/PAL/B&W
  PAGE_ERROR TextCols0, "TextCols0"

 IF DISABLE = 0
  ; Max Ship Speed (1.2 pixels/frame), also used for projectile
    INIT_SPEEDS MAX_SHIP_SPEED, 0, 0
ShipMaxLoX
    DEF_SPEEDS LO, 0, SPEEDS_8_1
ShipMaxLoY
    DEF_SPEEDS LO, 0, SPEEDS_0_1
    PAGE_WARN ShipMaxLoX, "ShipMaxLoX"
ShipMaxHiX
    DEF_SPEEDS HI, 0, SPEEDS_8_1
ShipMaxHiY
    DEF_SPEEDS HI, 0, SPEEDS_0_1
    PAGE_WARN ShipMaxHiX, "ShipMaxHiX"

  ALIGN_FREE_LBL 256, "BulletLoX"

  ; Bullet Velocity Table (2 pixels/frame)
    INIT_SPEEDS BULLET_SPEED_X, 0, 0
BulletLoX
    DEF_SPEEDS LO, 0, SPEEDS_8_9
    PAGE_WARN BulletLoX, "BulletLoX"
BulletHiX
    DEF_SPEEDS HI, 0, SPEEDS_8_9
    PAGE_WARN BulletHiX, "BulletHiX"

    INIT_SPEEDS BULLET_SPEED_Y, 0, 0
BulletLoY
    DEF_SPEEDS LO, 0, SPEEDS_0_1
    PAGE_WARN BulletLoY, "BulletLoY"
BulletHiY
    DEF_SPEEDS HI, 0, SPEEDS_0_1
    PAGE_WARN BulletHiY, "BulletHiY"
 ENDIF ; DISABLE


;             7,   6,   5,   4,   3,   2,   1,   0,   0,   0 (three times!)
FreqLoTbl
    .byte   $a3, $be, $32, $09, $e1, $9c, $36, $9e, $9e, $9e ; 65..242
FreqHiTbl
    .byte    20, 21,  7|$20,  8|$20, 25,  27, 12|$20, 14|$20, 14|$20, 14|$20 ; 65..242

HI_MAX      = 29
LO_MIN      =  5

HI_MIN      = 20
LO_MAX      = 14

_MULT_FREQ SET 256*16
_BASE_FREQ SET 31440

FreqAddTbl = . - HI_MIN
DIV SET 1 + HI_MIN
  REPEAT 32 - HI_MIN
    .byte   (_MULT_FREQ*3/5)/(_MULT_FREQ-(DIV*_MULT_FREQ+(DIV+1)/2)/(DIV+1))
DIV SET DIV+1
  REPEND
DIV SET 1
  REPEAT LO_MAX+1 ; 32
    .byte   (_MULT_FREQ*3/5)/(_MULT_FREQ-(DIV*_MULT_FREQ+(DIV+1)/2)/(DIV+1))
DIV SET DIV+1
  REPEND

DIV SET 1 + HI_MIN
_FREQ SET _BASE_FREQ/6;*31/32
VolAddTbl = . - HI_MIN
  REPEAT 32 - HI_MIN
    .byte _FREQ/DIV
DIV SET DIV+1
  REPEND
DIV SET 1
_FREQ SET _BASE_FREQ/31;*31/32
  REPEAT LO_MAX+1 ; 32
    .byte _FREQ/DIV
DIV SET DIV+1
  REPEND

; -----------------------------------------------------------------------------
 IF DISABLE ;{
  ds 10, 0
 ENDIF ;}
  ; Sprite Fine Tuning Table
HMoveTable0
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
  PAGE_ERROR HMoveTable0, "HMoveTable0"
FineTuneEnd0 = HMoveTable0 - 241

  ; Sprite Positioning (X = Object)
XPosition0 SUBROUTINE
  sta WSYNC                 ; [0]
  nop                       ; [0] + 2
  sec                       ; [2] + 2
  ; Divide Position by 15
Divide15_0
  sbc #15                   ; [4] + 2
  bcs Divide15_0            ; [6] + 2/3
  BRANCH_PAGE_ERROR Divide15_0, "Divide15_0"
  tay                       ; [8] + 2
  ; Store Coarse and Fine Position
  lda FineTuneEnd0,Y        ; [10] + 5*
  sta HMP0,X                ; [15] + 4
  sta RESP0,X               ; [19] + 4
  rts                       ; Positions: [23/28/33/38/43/48/53/58/63/68]
; WORST: 152 (78+68+6); MIN: 32 (3+23+6)

RingCols0
 IF DEMO
  DC.B  RED_NTSC|$8         ; $48   NTSC
  DC.B  BEIGE_NTSC|$C
  DC.B  ORANGE_NTSC|$C
  DC.B  VIOLET_NTSC|$C
  DC.B  BLUE_CYAN_NTSC|$a
  DC.B  MAUVE_NTSC|$e
  DC.B  GREEN_YELLOW_NTSC|$a
  DC.B  BLUE_CYAN_NTSC|$a

  DC.B  RED_PAL|$8          ; $68   PAL
  DC.B  BEIGE_PAL|$C
  DC.B  ORANGE_PAL|$C
  DC.B  VIOLET_PAL|$C
  DC.B  BLUE_CYAN_PAL|$a
  DC.B  MAUVE_PAL|$e
  DC.B  GREEN_YELLOW_PAL|$a
  DC.B  BLUE_CYAN_PAL|$a
 ELSE
  DC.B  RED_NTSC|$8         ; $48   NTSC
  DC.B  VIOLET_NTSC|$8      ; $68
  DC.B  BLUE_NTSC|$8+2      ; $88
  DC.B  CYAN_NTSC|$6+2      ; $a8
  DC.B  GREEN_NTSC|$8       ; $c8
  DC.B  GREEN_BEIGE_NTSC|$8 ; $e8
  DC.B  $08                 ; $08
  DC.B  ORANGE_NTSC|$8      ; $28

  DC.B  RED_PAL|$8          ; $68   PAL
  DC.B  VIOLET_PAL|$8       ; $a8
  DC.B  BLUE_PAL|$8         ; $d8
  DC.B  CYAN_PAL|$8         ; $98
  DC.B  GREEN_PAL|$8        ; $58
  DC.B  GREEN_BEIGE_PAL|$6  ; $36
  DC.B  $0a                 ; $0a
  DC.B  ORANGE_PAL|$a       ; $4a
 ENDIF
  DC.B  $06                 ; B&W
  PAGE_WARN RingCols0, "RingCols0"

  ALIGN_FREE_LBL 256, "SoundData0" ; optional

  ; Sound Effects (Highest Priority Last)
SoundData0   ; N * vvvfffff; 1 * 0000cccc; $ff = reset
;  DC.B  $00
 IF SONAR
  ds 3+5, 0
SFXSonar        ; 19 bytes/14 frames
  .byte $00
 IF SONAR_EVENT ;{ more volume
  .byte %00100100, %00000100, %00100100, %01000100, %00100100, %01000100
  .byte %00100100, %01000100, %00100100, %01000100, %01100100, %10000100
  .byte %00100100, %01000100, %11000100, %11100100
 ELSE ;}
  .byte %00100100, %00000100, %00100100, %00000100, %00100100, %01000100
  .byte %00100100, %01000100, %00100100, %01000100, %01000100, %01000100
  .byte %00100100, %00100100, %01100100, %10000100
 ENDIF
  .byte $0C, $FF
SFXSonarEnd
  ds 14
 ELSE
  ds 14-5, 0    ; SFXBullet gap (-5 only until homing mine sound is enabled!)
 ENDIF

SFXSectorExplosion
  DC.B $00 ; 35
  DC.B %01001101, %01001101, %01101100, %01101100, %10001100, %10101011 ; 41
  DC.B %11001010, %11101001, %11000011, %11100101, %11100010, %11100001 ; 47
  DC.B %11100000 ; 48
  DC.B $02, $FF ; 50
SFXSectorExplosionEnd

SFXMineExplosion
  DC.B  $00                                                               ; 51
  DC.B  %00011111, %01001110, %00011111, %01101101, %00011111, %10001110  ; 57
  DC.B  %00111111, %10101011, %00111111, %11001010, %00111111, %11011001  ; 63
  DC.B  %00111111, %11111001, %00111111, %11101000                        ; 67
  DC.B  $04, $FF                                                          ; 69
SFXMineExplosionEnd

SFXShipExplosion
  DC.B  $00                                                               ; 127
  DC.B  %00101111, %00000001, %00101111, %00110010, %00110000, %00101111  ; 133
  DC.B  %00000001, %00101111, %01011001, %01011111, %00111100, %00111111  ; 139
  DC.B  %01011100, %00111011, %01011100, %01001110, %01111100, %01001111  ; 145
  DC.B  %01101110, %01101110, %01101111, %10001110, %10101111, %01101110  ; 151
  DC.B  %10001110, %11001101, %10001111, %10101100, %10101100, %10001110  ; 157
  DC.B  %01101110, %10101101, %01001100, %11101011, %11001100, %11001011  ; 163
  DC.B  %11101010, %11101010, %11101001, %11101011                        ; 167
  DC.B  $08, $FF                                                          ; 169
SFXShipExplosionEnd

SFXSwitch       ; 13 bytes
  DC.B $00 ; 0
  DC.B %11100100, %11100011, %11100100, %11000101, %11000110, %10100101 ; 6
  DC.B %10000111, %01100110, %01100111, %01001000 ; 10
  DC.B $0F, $FF ; 12
SFXSwitchEnd

  PAGE_ERROR SoundData0, "SoundData0"

SoundData1
SFXRingBounce   ; 8 bytes
  DC.B $00 ; 13
  DC.B %11100101, %00000001, %11100101, %00000001, %11000101 ; 18
  DC.B $03, $FF ; 20
SFXRingBounceEnd

 IF SONAR ;
;  ds 11, 0   ; enable when homing mine sound is enabled!
SFXSonar1      ; 19 bytes/16 frames
  .byte $00
 IF SONAR_EVENT ;{
  .byte %00100100, %00000100, %00100100, %01000100, %00100100, %01000100
  .byte %00100100, %01000100, %00100100, %01000100, %01100100, %10000100
  .byte %00100100, %01000100, %11000100, %11100100
 ELSE ;}
  .byte %00100100, %00000100, %00100100, %00000100, %00100100, %01000100
  .byte %00100100, %01000100, %00100100, %01000100, %01000100, %01000100
  .byte %00100100, %00100100, %01100100, %10000100
 ENDIF
  .byte $0C, $FF
SFXSonarEnd1
 ENDIF;}

SFXBullet       ; 14 bytes
; Ivan new: volume reduction (7/4, 6/3, 4/2)
  .byte $00
  .byte %00000001, %00000001, %00000001, %01000100, %10000011, %00000001
  .byte %01100011, %11000010, %00000001, %10000010, %11100001
  .byte $01, $FF
SFXBulletEnd

SFXSectorExplosion1
  DC.B  $00                                                               ; 35
  DC.B  %01001101, %01001101, %01101100, %01101100, %10001100, %10101011  ; 41
  DC.B  %11001010, %11101001, %11000011, %11100101, %11000001, %11000010  ; 47
  DC.B  %11100001                                                         ; 48
  DC.B  $02, $FF                                                          ; 50
SFXSectorExplosionEnd1

SFXMineExplosion1
  DC.B  $00                                                               ; 51
  DC.B  %00011111, %01001110, %00011111, %01101101, %00011111, %10001110  ; 57
  DC.B  %00111111, %10101011, %00111111, %11001010, %00111111, %11011001  ; 63
  DC.B  %00111111, %11111001, %00111111, %11101000                        ; 67
  DC.B  $04, $FF                                                          ; 69
SFXMineExplosionEnd1

SFXGun
  DC.B  $00                                                               ; 70
  DC.B  %00101100, %01001011, %00101100, %00101011, %01001100, %01001011  ; 76
  DC.B  %01101100, %01001010, %01001011, %01101010, %01001011, %01101010  ; 82
  DC.B  %10001010, %01101011, %10001010, %10001011, %10001010, %10001010  ; 88
  DC.B  %10001011, %10101011, %10001010, %10101010, %10001100, %10101011  ; 94
  DC.B  %10101010, %10101011, %10101010, %10101011, %11001011, %10101010  ; 100
  DC.B  %11001010, %10101011, %11001011, %11001010, %10101010, %11001100  ; 106
  DC.B  %11001010, %11101100, %11001011, %11001010, %11101010, %11101011  ; 112
  DC.B  %11001011, %11101010, %11101011, %11001010, %11101001, %11001001  ; 118
  DC.B  %11101001, %11001000, %11101000, %11100100, %11100110, %11101000  ; 124
  DC.B  $08, $FF                                                          ; 126
SFXGunEnd

SFXRingExplosion
;Big Explosion - 123 bytes
 .byte  $00
 .byte  %00111110, %00000001, %00111100, %00000001, %00111110, %00111100
 .byte  %00111110, %00111110, %01011101, %00111101, %00111111, %00111011, %00111011, %00111101, %01011001, %00111111, %01011001, %00111110, %01011111
 .byte  %01011100, %00111111, %01011011, %00111101, %01111011, %00111011, %01011011, %00111101, %01111001, %00111111, %01011001, %00111110, %00111111
 .byte  %00111100, %01011101, %00111011, %01111100, %00111011, %01011010, %01011011, %00111010, %01111001, %01111010, %10011001, %01111010, %01011101
 .byte  %01111000, %01110111, %01011000, %01110110, %10010111, %01011001, %11011101, %10010111, %10110110, %01111000, %10011000, %01110101, %10011001
 .byte  %10110110, %10110111, %11010100, %10010110, %10110111, %11110110, %10110101, %11010110, %11011101, %10110100, %11010110, %11010010, %11010100
 .byte  %11110110, %11010101, %11101111, %11111010, %11110101, %11101111, %11110110, %11110101, %11110010, %11110011, %11010100, %11110110, %11110111

 .byte  %01011000, %00111000, %01011000, %01011000, %01010111, %01010110, %01010011, %01011101, %01110111, %01010111
 .byte  %01110111, %01010111, %01111000, %01010111, %01110110, %10010101, %01110010, %10010101, %10110001, %10010000, %10101111, %10110000, %11001111
 .byte  %11010000, %10001111, %11101111, %10001100, %11101100, %11101010, %11101010, %10001000, %11100110, %10000100, %11100011, %11100100, %11100101

 .byte  $08, $FF
SFXRingExplosionEnd

  IF SFX_GUN_EXPL > 255
    echo "ERROR @", ., ": SoundData1 > 256 bytes! (", SFX_GUN_EXPL, ")"
    err
  ENDIF

  ; old colors: Original, 1, 2, 3
  ; new colors: Ice, Neon (too similar to 3?), Toxic, AtariAge
RingCols1
 IF DEMO
  DC.B  ORANGE_NTSC|$A      ; $3a   NTSC
  DC.B  GREEN_NTSC|$C
  DC.B  MAUVE_NTSC|$C
  DC.B  BLUE_NTSC|$C
  DC.B  CYAN_NTSC|$e
  DC.B  CYAN_NTSC|$e
  DC.B  GREEN_NTSC|$c
  DC.B  ORANGE_NTSC|$c

  DC.B  ORANGE_PAL|$A       ; $4a   PAL
  DC.B  GREEN_PAL|$C
  DC.B  MAUVE_PAL |$C
  DC.B  BLUE_PAL |$C
  DC.B  CYAN_PAL|$e
  DC.B  CYAN_PAL |$e
  DC.B  GREEN_PAL |$c
  DC.B  ORANGE_PAL |$c
 ELSE
  DC.B  ORANGE_NTSC|$A      ; $3a   NTSC
  DC.B  MAUVE_NTSC|$a       ; $5a
  DC.B  PURPLE_NTSC|$a      ; $7a
  DC.B  BLUE_CYAN_NTSC|$c+2 ; $9a
  DC.B  CYAN_GREEN_NTSC|$a  ; $ba
  DC.B  GREEN_YELLOW_NTSC|$a; $da
  DC.B  BEIGE_NTSC|$a       ; $fa
  DC.B  YELLOW_NTSC|$a      ; $1a

  DC.B  ORANGE_PAL|$A       ; $4a   PAL
  DC.B  MAUVE_PAL|$a        ; $8a
  DC.B  PURPLE_PAL|$a       ; $ca
  DC.B  BLUE_CYAN_PAL|$a    ; $ba
  DC.B  CYAN_GREEN_PAL|$a   ; $9a
  DC.B  GREEN_YELLOW_PAL|$a ; $3a
  DC.B  BEIGE_PAL|$a        ; $2a
  DC.B  YELLOW_PAL|$e       ; $2e
 ENDIF
  DC.B  $0A                 ; B&W
  PAGE_WARN RingCols1, "RingCols1"

RingCols2 ; inner ring
 IF DEMO
  DC.B  YELLOW_NTSC|$C      ; NTSC
  DC.B  CYAN_NTSC|$C
  DC.B  PURPLE_NTSC|$C
  DC.B  GREEN_NTSC|$C
  DC.B  $0e
  DC.B  YELLOW_NTSC|$e
  DC.B  YELLOW_NTSC|$e
  DC.B  $0e

  DC.B  YELLOW_PAL |$E      ; PAL
  DC.B  CYAN_PAL |$C
  DC.B  PURPLE_PAL |$C
  DC.B  GREEN_PAL |$C
  DC.B  $0e
  DC.B  YELLOW_PAL |$e
  DC.B  YELLOW_PAL |$e
  DC.B  $0e
 ELSE
  DC.B  YELLOW_NTSC|$C      ; $1c   NTSC
  DC.B  ORANGE_NTSC|$c      ; $3c
  DC.B  MAUVE_NTSC|$c       ; $5c
  DC.B  PURPLE_NTSC|$c+2    ; $7c
  DC.B  BLUE_CYAN_NTSC|$c+2 ; $9c
  DC.B  CYAN_GREEN_NTSC|$c  ; $bc
  DC.B  GREEN_YELLOW_NTSC|$c; $dc
;  DC.B  BEIGE_NTSC|$c       ; $fc
  DC.B  $0c

  DC.B  YELLOW_PAL |$E      ; $2e   PAL
  DC.B  ORANGE_PAL|$c       ; $4c
  DC.B  MAUVE_PAL|$c        ; $8c
  DC.B  PURPLE_PAL|$c       ; $cc
  DC.B  BLUE_CYAN_PAL|$c    ; $bc
  DC.B  CYAN_GREEN_PAL|$c   ; $7c
  DC.B  GREEN_YELLOW_PAL|$c ; $3c
  DC.B  $0c                 ; $0c
 ENDIF
  DC.B  $0E                 ; B&W
  PAGE_WARN RingCols2, "RingCols2"

ShipYStart
  DC.B  MIDDLEY+42, MIDDLEY+30, MIDDLEY+18, MIDDLEY +6
  DC.B  MIDDLEY- 6, MIDDLEY-18, MIDDLEY-30, MIDDLEY-42
  PAGE_WARN ShipYStart, "ShipYStart"

SirenVolLoTbl:
;    .byte   $8F, $3B, $E4, $96, $5B, $3A, $38, $52, $82, $BF, $FC, $2E, $4C, $4F, $35, $01
;    .byte   $BB, $6C, $20, $E5, $C5, $C5, $E7, $29, $82, $E8, $4D, $A4, $E2, $00, $F9, $D1
; Flanging is a bit more dynamic (2.75 instead of 2.23)
    .byte   $74, $0D, $A2, $41, $F8, $D0, $CD, $ED, $29, $74, $BF, $FE, $22, $26, $06, $C6
    .byte   $6E, $0D, $B0, $67, $3F, $3E, $69, $BA, $29, $A7, $23, $8F, $DC, $00, $F8, $C7

SirenVolHiTbl:
;    ; 2.77 - 5.00
;    .byte   4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4
;    .byte   3, 3, 3, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 4, 4
;    ; 4.77 - 7.00
;    .byte   6, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6
;    .byte   5, 5, 5, 4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 6, 6
;    ; 7.77 - 10.00
;    .byte   9, 9, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9,  9, 9, 9
;    .byte   8, 8, 8, 7, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 9, 9
;    ; 10.77 - 13.00
;    .byte   12, 12, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12, 12
;    .byte   11, 11, 11, 10, 10, 10, 10, 11, 11, 11, 12, 12, 12, 13, 12, 12
; DONE: volume 5.27 - 8
; Flanging is a bit more dynamic (2.75 instead of 2.23)
    ; 5.25 - 8.00
    .byte   7, 7, 6, 6, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 6
    .byte   6, 6, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 8, 7, 7

  END_BANK 0
