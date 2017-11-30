   LIST OFF
; ***  A I R - S E A  B A T T L E  ***
; Copyright 1977 Atari, Inc.
; Designer: Larry Kaplan

; Analyzed, labeled and commented
;  by Dennis Debro
; Last Update: July 27, 2004

      processor 6502

   include vcs.h

   LIST ON

;===============================================================================
; A S S E M B L E R - S W I T C H E S
;===============================================================================

NTSC                    = 0
PAL                     = 1

COMPILE_VERSION         = NTSC      ; change this to compile for different
                                    ; regions
   
;============================================================================
; T I A - C O N S T A N T S
;============================================================================

HMOVE_L7          =  $70
HMOVE_L6          =  $60
HMOVE_L5          =  $50
HMOVE_L4          =  $40
HMOVE_L3          =  $30
HMOVE_L2          =  $20
HMOVE_L1          =  $10
HMOVE_0           =  $00
HMOVE_R1          =  $F0
HMOVE_R2          =  $E0
HMOVE_R3          =  $D0
HMOVE_R4          =  $C0
HMOVE_R5          =  $B0
HMOVE_R6          =  $A0
HMOVE_R7          =  $90
HMOVE_R8          =  $80

; values for ENAMx and ENABL
DISABLE_BM        = %00
ENABLE_BM         = %10

; values for NUSIZx
ONE_COPY          = %000
DOUBLE_SIZE       = %101
QUAD_SIZE         = %111
MSBL_SIZE1        = %000000
MSBL_SIZE2        = %010000
MSBL_SIZE4        = %100000
MSBL_SIZE8        = %110000

; values for REFPx
NO_REFLECT        = %0000
REFLECT           = %1000

; mask for SWCHB
P1_DIFF_MASK      = %10000000
BW_MASK           = %00001000       ; black and white bit
SELECT_MASK       = %00000010
RESET_MASK        = %00000001

; SWCHA joystick bits
MOVE_RIGHT        = %1000
MOVE_LEFT         = %0100
MOVE_DOWN         = %0010
MOVE_UP           = %0001
NO_MOVE           = %11111111

;============================================================================
; U S E R - C O N S T A N T S
;============================================================================

   IF COMPILE_VERSION = NTSC

; frame time values   
VBLANK_TIME          = $2C

; color constants
BLACK          = $00
WHITE          = $0E

GREEN_BLUE     = $A0
RED            = $30
YELLOW         = $10
GREEN          = $C0
BLUE           = $90
LIGHT_BLUE     = $80
PURPLE         = $60
BROWN          = $E0

; kernel constants
H_KERNEL             = 102
MISSILE_VELOCITY     = 48
MISSILE_YMIN         = 231

   ELSE

; frame time values   
VBLANK_TIME          = $2D

; color constants
BLACK          = $00
WHITE          = $0E

GREEN_BLUE     = $A0
RED            = $30
YELLOW         = $10
GREEN          = $C0
BLUE           = $90
LIGHT_BLUE     = $B0
PURPLE         = $60
BROWN          = $20

; kernel constants
H_KERNEL             = 123
MISSILE_VELOCITY     = 64
MISSILE_YMIN         = 240

   ENDIF
   
XMIN                 = 8
XMAX                 = 158
MISSILE_XMAX         = XMAX - 7

OBJECT_XMAX_SINGLE   = XMAX-9
OBJECT_XMAX_DOUBLE   = OBJECT_XMAX_SINGLE-9

YMAX                 = 255-H_KERNEL+7

YPOS_PLAYER1         = 255-H_KERNEL+12
YPOS_PLAYER2         = YPOS_PLAYER1+8

PLAYER1_GUN_XMIN     = 2
PLAYER2_GUN_XMIN     = 77

PLAYER1_GUN_XMAX     = 69
PLAYER2_GUN_XMAX     = 144

PLAYER1_STARTING_X   = 32
PLAYER2_STARTING_X   = 120

GUN_PIXEL_MOVEMENT   = 2

MAX_GAME_SELECTION   = 27

SELECT_DELAY         = $3F
SCORE_FLASH_DELAY    = $30

BW_HUE_MASK          = $0F
COLOR_HUE_MASK       = $FF

NUM_KERNEL_ZONES     = 9

STARTING_GAME_TIME   = 128

;game state values
SYSTEM_POWERUP       = %00001010
GAME_RUNNING         = %11111111

; game variation flags
POLARIS_OR_BOMBER = %10000000
MOVE_LEFT_RIGHT   = %01000000
POLARIS_VS_BOMBER = %00100000
SINGLEPLAYER      = %00010000
SHOOTING_GALLERY  = %00001000
WATER_OBSTACLES   = %00000100
OBSTACLES         = %00000010
GUIDED_MISSILES   = %00000001

; objectType ids
ID_LARGE_JET         = 0
ID_SMALL_JET         = 8
ID_747               = 16
ID_HELICOPTER        = 24
ID_BLIMP             = 32
ID_RABBIT            = 40
ID_CLOWN             = 48
ID_DUCK              = 56
ID_AIRCRAFT_CARRIER  = 64
ID_PT_BOAT           = 72
ID_FREIGHTER         = 80
ID_PIRATE_SHIP       = 88
ID_MINE_0            = 96
ID_MINE_1            = 104

; object score values (BCD)
LARGE_JET_SCORE         = $03
SMALL_JET_SCORE         = $04
_747_SCORE              = $01
HELICOPTER_SCORE        = $02
BLIMP_SCORE             = $00
RABBIT_SCORE            = $03
CLOWN_SCORE             = $01
DUCK_SCORE              = $02
AIRCRAFT_CARRIER_SCORE  = $03 
PT_BOAT_SCORE           = $04
FREIGHTER_SCORE         = $01
PIRATE_SHIP_SCORE       = $02
MINE_SCORE              = $00

MAX_SCORE               = $99

; velocity values
VELOCITY_SLOW           = 0
VELOCITY_REST           = 16
VELOCITY_FAST           = VELOCITY_REST*2

OBJECT_VELOCITY_MEDIUM  = 2

MISSILE_HORZ_VELOCITY_90   = 0
MISSILE_HORZ_VELOCITY_60   = 1
MISSILE_HORZ_VELOCITY_30   = 2

MISSILE_VERT_VELOCITY_30   = 1
MISSILE_VERT_VELOCITY_60   = 2
MISSILE_VERT_VELOCITY_90   = 2

;============================================================================
; Z P - V A R I A B L E S
;============================================================================

frameCount                 = $80
currentScanline            = $81
gameTimer                  = $82
selectDebounce             = $83
startingKernelScanline     = $84
scoreGraphics              = $85    ; $85 - $86
;--------------------------------------
scoreGraphic1              = scoreGraphics
scoreGraphic2              = scoreGraphics+1
temp                       = $87
;--------------------------------------
tempMissileHorizPos        = temp
;--------------------------------------
tempKernelZone             = temp
;--------------------------------------
tempPlayerIndex            = temp
;--------------------------------------
objectVelocity             = temp
objectXMax                 = $88
hueMask                    = $89
;--------------------------------------
objectStateMask            = hueMask
colorXOR                   = $8A
;--------------------------------------
hitObstacleKernelZone      = colorXOR

playerScores               = $8B    ; $8B - $8C
;--------------------------------------
player1Score               = playerScores
player2Score               = player1Score+1

scoreOffsets               = $8D    ; $8D - $90
;--------------------------------------
lsbScoreOffsets            = scoreOffsets
player1LSBOffset           = lsbScoreOffsets
player2LSBOffset           = lsbScoreOffsets+1
;--------------------------------------
msbScoreOffsets            = scoreOffsets+2
player1MSBOffset           = msbScoreOffsets
player2MSBOffset           = msbScoreOffsets+1

missileVertPos             = $93    ; $93 - $94
;--------------------------------------
missile2VertPos            = missileVertPos
missile1VertPos            = missileVertPos+1
randomSeed                 = $95
tempRandomSeed             = $96
gameState                  = $97
gameSelection              = $98
gameSelectionBCD           = $99
gameVariation              = $9A
scoreMask                  = $9B
playerVelocity             = $9C    ; $9C - $9D
;--------------------------------------
player1Velocity            = playerVelocity
player2Velocity            = playerVelocity+1

explosionSpriteOffset      = $9E

obstacleZones              = $A1    ; $A1 - $A2
;--------------------------------------
obstacle1Zone              = obstacleZones
obstacle2Zone              = obstacleZones+1

playerGraphicOffsets       = $A3
;--------------------------------------
player1GraphicOffset       = playerGraphicOffsets
player2GraphicOffset       = playerGraphicOffsets+1
joystickValues             = $A5
;--------------------------------------
player1JoystickValue       = joystickValues
player2JoystickValue       = joystickValues+1
missileTrajectory          = $A7
;--------------------------------------
player1MissileTrajectory   = missileTrajectory
player2MissileTrajectory   = missileTrajectory+1

missileHorizPos            = $A9    ; $A9 - $AA
;--------------------------------------
missile1HorizPos           = missileHorizPos
missile2HorizPos           = missileHorizPos+1

missileMask                = $AB    ; $AB - $AC
;--------------------------------------
player2MissileMask         = missileMask
player1MissileMask         = missileMask+1
audioFrequencies           = $AD    ; $AD - $B0
;--------------------------------------
player1AudioFreq           = audioFrequencies
player2AudioFreq           = audioFrequencies+1

objectGraphicIndex         = $B1
objectAttributes           = $B2    ; $B2 - $BB holds the object's size and reflect state
;--------------------------------------
playerDiffState            = objectAttributes+8
;--------------------------------------
player1DiffState           = playerDiffState
player2DiffState           = playerDiffState+1

zoneHorizPos               = $BC    ; $BC - $C3
playerHorizPos             = $C4    ; $C4 - $C5
;--------------------------------------
player1HorizPos            = playerHorizPos
player2HorizPos            = playerHorizPos+1
kernelZoneHorizPos         = $C6    ; $C6 - $CD
playerFineCoarsePos        = $CE    ; $CE - $CF
;--------------------------------------
player1FineCoarsePos       = playerFineCoarsePos
player2FineCoarsePos       = playerFineCoarsePos+1

objectIds                  = $D0    ; $D0 - $D8

missileCollisions          = $D9    ; $D9 - $E0

playerColors               = $E2    ; $E2 - $EB
kernelZoneColors           = $EC    ; $EC - $F5
;--------------------------------------
groundColor                = $F5

;============================================================================
; R O M - C O D E (Part 1)
;============================================================================

   SEG Bank0
   org $F000
   
Start
;
; Set up everything so the power up state is known.
;
   sei                              ; disable interrupts
   cld                              ; clear decimal mode
   lda #0
   tax
.clearLoop
   sta VSYNC,x
   inx
   bne .clearLoop
   lda #SYSTEM_POWERUP
   sta REFP1                        ; REFLECT player 1
   sta CTRLPF                       ; set to SCORE mode and non-relective PF
   sta gameState
   
   IF COMPILE_VERSION = NTSC

   lda #%00010000                   ; set D4 of SWCHB as output -- used to
   sta SWBCNT                       ; set missile size based on difficulty

   ENDIF
   
MainLoop
VerticalSync
   lda #$02
   sta WSYNC
   sta VBLANK                       ; disable TIA (D1 = 1)
   sta WSYNC                        ; wait 3 scan lines before starting new
   sta WSYNC                        ; frame
   sta WSYNC
   sta VSYNC                        ; start vertical sync (D1 = 1)
   inc frameCount                   ; increment frame count each new frame
   sta WSYNC                        ; first line of VSYNC
   sta WSYNC                        ; second line of VSYNC
   lda #0
   sta WSYNC                        ; third line of VSYNC
   sta VSYNC                        ; end vertical sync (D1 = 0)
   lda #VBLANK_TIME
   sta TIM64T                       ; set timer for vertical blanking period
   ldx #$FF
   txs                              ; point stack to the beginning
   jsr GameCalculations
   
   lda #255-H_KERNEL                ; the scan line variable is incremented
   sta currentScanline              ; until it reaches 0
DisplayKernel SUBROUTINE
.waitTime
   lda INTIM
   bne .waitTime
   sta WSYNC                        ; end last scan line
   sta HMOVE
   sta VBLANK                       ; enable TIA (D1 = 0)
.scoreKernelWait
   sta WSYNC
   sta HMCLR                        ; clear all horizontal positioning
   inc currentScanline
   sta WSYNC
;--------------------------------------
   lda currentScanline        ; 3         continue looping until the
   cmp startingKernelScanline ; 2         appropriate starting scan line has
   bcc .scoreKernelWait       ; 2³        been reached
   cmp #255-H_KERNEL+3        ; 2
   bcs BeginPlayfieldKernel   ; 2³
ScoreKernel
   sta WSYNC
;--------------------------------------
   lda scoreGraphic1          ; 3         get the score graphic for display
   sta PF1                    ; 3 = @06
   ldy player1MSBOffset       ; 3
   lda NumberFonts,y          ; 4         read the number fonts
   and #$F0                   ; 2         mask the lower nybble
   sta scoreGraphic1          ; 3         save it in the score graphic
   ldy player1LSBOffset       ; 3
   lda NumberFonts,y          ; 4         read the number fonts
   and #$0F                   ; 2         mask the upper nybble
   ora scoreGraphic1          ; 3         or with score graphic to get LSB
   sta scoreGraphic1          ; 3         value
   lda scoreGraphic2          ; 3         get the score graphic for display
   sta PF1                    ; 3 = @39
   ldy player2MSBOffset       ; 3
   lda NumberFonts,y          ; 4         read the number fonts
   and #$F0                   ; 2         mask the lower nybble
   sta scoreGraphic2          ; 3         save it in the score graphic
   ldy player2LSBOffset       ; 3
   lda NumberFonts,y          ; 4         read the number fonts
   and scoreMask              ; 3         scoreMask turns on/off right digits
   ora scoreGraphic2          ; 3         or with score graphic to get LSB
   sta scoreGraphic2          ; 3         value
   sta WSYNC                  ; 3 = @70
;--------------------------------------
   inc currentScanline        ; 5
   lda currentScanline        ; 3
   cmp #YMAX                  ; 2
   bcs BeginPlayfieldKernel   ; 2³
   lda scoreGraphic1          ; 3
   sta PF1                    ; 3 = @18
   inc player1LSBOffset       ; 5
   inc player1MSBOffset       ; 5
   inc player2LSBOffset       ; 5
   inc player2MSBOffset       ; 5
   lda scoreGraphic2          ; 3
   sta PF1                    ; 3 = @44
   jmp ScoreKernel            ; 3
   
BeginPlayfieldKernel
   ldx #0                     ; 2
   stx PF1                    ; 3 = @18   clear PF1 so digit doesn't bleed
   stx objectGraphicIndex     ; 3
.playfieldKernelLoop
   lda objectAttributes,x     ; 4
   sta NUSIZ0                 ; 3         set the size of the object
   sta REFP0                  ; 3         set the object's reflect state
   lda CXM0P                  ; 3         read the missile 0 collisions
   lsr                        ; 2         shift the values to D5 and D4
   lsr                        ; 2
   ora CXM1P                  ; 3         read the missile 1 collisions
   sta missileCollisions,x    ; 4         store the collision value
   lda playerColors,x         ; 4         get the colors for objects in zone
   sta COLUP0                 ; 3
   sta COLUP1                 ; 3
   lda kernelZoneColors,x     ; 4         get the kernel zone color
   sta COLUBK                 ; 3
   
   IF COMPILE_VERSION = PAL
   
   lda #$03                   ; 2
   sta $88                    ; 3
   
   ENDIF
   
   sta WSYNC
;--------------------------------------
   lda kernelZoneHorizPos,x   ; 4
   sta HMP0                   ; 3         set the object's fine motion value
   lda kernelZoneHorizPos,x   ; 4         read again to waste 4 cycles
   and #$0F                   ; 2         mask upper nybble for coarse value
   tay                        ; 2
.coarseMoveObject
   dey                        ; 2
   bpl .coarseMoveObject      ; 2³
   sta RESP0                  ; 3         set the object's coarse position
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   bmi .setMissileState       ; 3
   
ZoneKernel
   sta WSYNC
;--------------------------------------
.setMissileState
   txa                        ; 2         save kernel zone in accumulator
   ldx #ENAM1                 ; 2         load x with location of ENAM1
   txs                        ; 2         set stack to point to ENAM1
   tax                        ; 2         restore kernel zone in x
   sec                        ; 2
   lda currentScanline        ; 3
   sbc missile1VertPos        ; 3
   and player1MissileMask     ; 3
   php                        ; 3         enables/disables missile 1
   sec                        ; 2
   lda currentScanline        ; 3
   sbc missile2VertPos        ; 3
   and player2MissileMask     ; 3
   sta temp                   ; 3
   lda objectIds,x            ; 4
   bpl .determineSpriteOffset ; 2³
   asl                        ; 2
   bpl .setToExplosionSprite  ; 2³
   lda #0                     ; 2
   beq DrawObjectSprite       ; 3
   
.setToExplosionSprite
   lda explosionSpriteOffset  ; 3
.determineSpriteOffset
   ora objectGraphicIndex     ; 3
   tay                        ; 2
   lda GameSprites,y          ; 4
DrawObjectSprite
   inc currentScanline        ; 5
   sta WSYNC
;--------------------------------------
   sta GRP0                   ; 3 = @03
   lda temp                   ; 3
   php                        ; 3
   inc objectGraphicIndex     ; 5
   lda objectGraphicIndex     ; 3
   and #$07                   ; 2
   bne ZoneKernel             ; 2³+1
   
   IF COMPILE_VERSION = PAL
   
   dec objectGraphicIndex     ; 5
   dec $88                    ; 5
   bpl ZoneKernel             ; 2³+1
   
   ENDIF
   
   sta objectGraphicIndex     ; 3
   inx                        ; 2
   cpx #NUM_KERNEL_ZONES      ; 2
   bcc .playfieldKernelLoop   ; 2³+1
   sta HMP0                   ; 3 = @33
   sta WSYNC
;--------------------------------------
   lda kernelZoneHorizPos,x   ; 4         get player2's fine/coarse value
   sta HMP1                   ; 3 = @07   set player2's fine motion
   lda kernelZoneHorizPos,x   ; 4         waste 4 cycles
   and #$0F                   ; 2         mask fine motion
   tay                        ; 2
.coarseMovePlayer2
   dey                        ; 2
   bpl .coarseMovePlayer2     ; 2³
   sta RESP1                  ; 3
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   lda #0                     ; 2
   sta ENAM0                  ; 3 = @08   disable the missiles
   sta ENAM1                  ; 3 = @11
   lda playerColors+9         ; 3
   sta COLUP1                 ; 3 = @17
   bit gameVariation          ; 3         if this game doesn't have the gun
   bmi Overscan               ; 2³        at the bottom then go to Overscan
   ldy player1GraphicOffset   ; 3
   ldx player2GraphicOffset   ; 3
AntiAircraftKernel
   sta WSYNC
;--------------------------------------
   lda AntiAircraftGuns,y     ; 4         read player1's gun graphic
   sta GRP0                   ; 3 = @07
   lda AntiAircraftGuns,x     ; 4         read player2's gun graphic
   sta GRP1                   ; 3 = @14
   sta WSYNC
;--------------------------------------
   iny                        ; 2
   inx                        ; 2
   inc currentScanline        ; 5
   txa                        ; 2
   and #$07                   ; 2
   bne AntiAircraftKernel     ; 2³
   sta GRP0                   ; 3 = @18   clear the player graphics (a = 0)
   sta GRP1                   ; 3 = @21
   lda groundColor            ; 3
   sta COLUBK                 ; 3 = @27
Overscan
.overscanWait
   sta WSYNC
   sta WSYNC
   inc currentScanline
   bne .overscanWait
   jmp MainLoop
       
GameCalculations
ReadConsoleSwitches
   lda gameState                    ; get the current game state
   
   IF COMPILE_VERSION = NTSC
   
   sta SWCHB                        ; set D4 of SWCHB -- used to set missile
                                    ; size based on difficulty
   ENDIF
   
   cmp #SYSTEM_POWERUP              ; show game selection if the game is
   beq .showGameSelection           ; powering up
   lda SWCHB                        ; read the console switches
   ror                              ; RESET value now in carry
   bcs .skipGameReset
;
; start new game
;
   lda #GAME_RUNNING                ; RESET pressed so show the game is in
   sta gameState                    ; progress
   lda #0
   sta player1Score                 ; reset the player scores
   sta player2Score
   sta selectDebounce               ; reset the select debounce value
   lda #STARTING_GAME_TIME
   sta gameTimer                    ; set the starting game time
   lda frameCount                   ; get the current frame count
   and #$01                         ; make the value between 0 and 1
   sta frameCount
   lda #$0F                         ; set score mask to show player2's score
   sta scoreMask
   jmp ResetPlayerPositions
       
.skipGameReset
   ldy #255-H_KERNEL+1              ; initial scan line to start kernel
   lda gameTimer
   and gameState
   cmp #$F0
   bcc .setKernelStartScanline
   lda frameCount                   ; get the current frame count
   and #SCORE_FLASH_DELAY           ; see if the score is to drawn (flashing)
   bne .setKernelStartScanline
   ldy #YMAX                        ; ensures score is not drawn
.setKernelStartScanline
   sty startingKernelScanline       ; set scan line to start kernel
   lda frameCount                   ; get current frame count
   and #SELECT_DELAY                ; the select switch is checked ~ every 60
   bne .checkGameSelectSwitch       ; frames or ~ every second
   sta selectDebounce               ; reset select debounce flag
   inc gameTimer                    ; increment timer (rolls over at 255)
   bne .checkGameSelectSwitch
   sta gameState                    ; if timer rolls over set to game over
.checkGameSelectSwitch
   lda SWCHB                        ; read the console switches
   and #SELECT_MASK                 ; mask to find SELECT value
   beq .selectSwitchPressed
   sta selectDebounce               ; show SELECT not pressed this frame
   bne CheckMissileCollisions       ; unconditional branch
   
.selectSwitchPressed
   bit selectDebounce               ; if SELECT held then skip SELECT button
   bmi CheckMissileCollisions       ; logic
   lda #$FF
   sta selectDebounce               ; show the SELECT button is held
   inc gameSelection                ; increment game selection

.showGameSelection
   lda gameSelectionBCD             ; store the game selection (BCD) in
   sta player1Score                 ; player1's score
   ldx #0
   stx player2Score                 ; reset player2's score
   stx scoreMask                    ; clear the score mask
   stx gameState                    ; show that game is over
   stx frameCount                   ; reset frame count
   lda gameSelection                ; get the current game selection number
   cmp #MAX_GAME_SELECTION          ; make sure it doesn't go over the max
   bcc .incrementGameSelection
   stx player1Score                 ; clear player1's score
   stx gameSelection                ; wrap game selection around to 0
.incrementGameSelection

   ldy #$FF                         ; makes the game selection increment by 1
   jsr CalculateScore
   lda player1Score                 ; get new game selection
   sta gameSelectionBCD             ; save for next frame

   ldx #NUM_KERNEL_ZONES-1
   lda #$FE
.setObjectIds
   sta objectIds,x
   dex
   bpl .setObjectIds

   ldx gameSelection
   lda GameVariationTable,x         ; set the game variation based on game
   sta gameVariation                ; selection
   bmi .polarisOrBomberGameSelection
       LDY    #$01    ;2
   and #SHOOTING_GALLERY|OBSTACLES
   beq LF225
       LDA    #$C0    ;2
   bne LF225                        ; unconditional branch
       
.polarisOrBomberGameSelection
   rol
   rol
   rol
   rol
   and #$03
       TAY            ;2
       LDA    LF61B,Y ;4
   cpx #24
   bcc LF225
;   and #%11100111
LF225:
   LDA #$0C
   STA    $A0     ;3

   lda Obstacle1ZoneTable,y         ; set the kernel zone for obstacle 1
   sta obstacle1Zone
   lda Obstacle2ZoneTable,y         ; set the kernel zone for obstacle 2
   sta obstacle2Zone
ResetPlayerPositions
   lda #HMOVE_R2|2
   sta player1FineCoarsePos         ; sets player to pixel 98
   sta RESMP0                       ; lock missiles to players
   sta RESMP1                       ; and disable them
   lda #HMOVE_0|8
   sta player2FineCoarsePos         ; sets player to pixel 147
   lda #PLAYER1_STARTING_X
   sta player1HorizPos
   lda #PLAYER2_STARTING_X
   sta player2HorizPos
   bne DoneCollisionCheck           ; unconditional branch
       
CheckMissileCollisions
   ldx #1
.checkPlayerCollisionLoop
   lda CXM0P,x                      ; read missile collisions for this frame
   and MissileCollisionMask,x
   beq .checkNextPlayer             ; if no collision then check next player
   ldy #-1
.checkZoneCollisions
   iny
   cpy #NUM_KERNEL_ZONES-1
   bcs .checkNextPlayer
   lda missileCollisions+1,y        ; get missile collision zone value
   and MissileCollisionZoneTable,x
   beq .checkZoneCollisions         ; if none here then check next zone
   jsr CalculateScore               ; collision found -- increment score
.checkNextPlayer
   dex
   bpl .checkPlayerCollisionLoop
   
DoneCollisionCheck
   sta CXCLR                        ; clear all collisions
   lda gameVariation                ; get the game variation
   and #SINGLEPLAYER                ; mask value to get SINGLEPLAYER flag
   tay
   lda #$F0                         ; assume this is a one player game
   cpy #0                           ; if one player game then branch to
   bne .shiftP1JoystickValues       ; shift the joystick values
   lda SWCHA                        ; read the player joystick values
   and #$F0                         ; mask out player 2's values
.shiftP1JoystickValues
   lsr                              ; shift the value to the lower nybble
   lsr
   lsr
   lsr
   sta player1JoystickValue         ; store player1's joystick value
   lda SWCHA                        ; read the joystick port
   and #$0F                         ; mask out player 1's values
   sta player2JoystickValue         ; store player2's joystick value
   lda frameCount                   ; get the current frame count
   and #$01                         ; make the value between 0 and 1
   tax
   
   IF COMPILE_VERSION = NTSC
   
   lda SWCHB                        ; read the console switch values
   eor #$FF
   and DifficultySwitchMask,x
   beq .setMissileSize
   lda #MSBL_SIZE4                  ; make the missiles 4 clocks wide
.setMissileSize
   sta playerDiffState,x
   sta NUSIZ0,x                     ; set missile size
   
   ELSE
   
   ldy #MSBL_SIZE2                  ; assume EXPERT setting
   lda SWCHB                        ; read the console switch values
   and DifficultySwitchMask,x
   bne .setMissileSize
   ldy #MSBL_SIZE4                  ; make the missiles 4 clocks wide
.setMissileSize
   sty playerDiffState,x
   sty NUSIZ0,x                     ; set missile size
   
   ENDIF   
   
   lda gameVariation                ; get the current game variation
   bpl DeterminePlayerVelocity      ; branch if not a polaris game
   and #GUIDED_MISSILES             ; check for the guided missile option
   bne DeterminePlayerVelocity      ; branch to guided missiles
   lda missileVertPos,x             ; get the missile's vertical position
   bne .setMissileTrajectory        ; skip logic if missile still active
DeterminePlayerVelocity
   lda joystickValues,x             ; get the player's joystick value
   and #MOVE_DOWN|MOVE_UP           ; mask all but up and down values
   tay
   lda PlayerVelocityTable,y        ; get player velocity from look up table
   sta playerVelocity,x
   clc
   adc #VELOCITY_REST*4
   tay
   lda #SHOOTING_GALLERY
   bit gameVariation
   bne DeterminePlayerHorizMovement ; branch if not variable movement
   bvc DetermineAntiAirSpriteOffset ; brach if up down movement
   txa
   bne .setPlayerVelocity           ; branch if player 1
   lda gameVariation                ; get the current game variation
   and #POLARIS_VS_BOMBER
   bne .setMissileTrajectory        ; branch if Polaris vs. Bomber
.setPlayerVelocity
   sty playerVelocity,x
DeterminePlayerHorizMovement
   bit gameVariation
   bmi .setMissileTrajectory        ; branch if Polaris style game
   lda joystickValues,x             ; get the player's joystick value
   and #MOVE_RIGHT                  ; get the right motion flag
   beq .movePlayerRight
   lda joystickValues,x             ; get the player's joystick value
   and #MOVE_LEFT                   ; get the left motion flag
   bne .skipPlayerHorizPos
   sec
   lda playerHorizPos,x             ; get the player's horizontal position
   sbc #GUN_PIXEL_MOVEMENT          ; reduce by gun pixel movement
   cmp GunXMinTable,x               ; make sure the gun stays within range
   bcs .setPlayersHorizPos
   lda GunXMinTable,x               ; set the player's position to the minimum
   bne .setPlayersHorizPos          ; gun position (unconditional branch)
   
.movePlayerRight
   clc
   lda playerHorizPos,x             ; get the player's horizontal position
   adc #GUN_PIXEL_MOVEMENT          ; increment by gun pixel movement
   cmp GunXMaxTable,x               ; make sure the gun stays within range
   bcc .setPlayersHorizPos
   lda GunXMaxTable,x               ; set the player's position to the maximum
                                    ; gun position
.setPlayersHorizPos
   sta playerHorizPos,x
   jsr CalcXPos                     ; calculate player's fine/coarse value
   sta playerFineCoarsePos,x
.skipPlayerHorizPos
   lda gameVariation
   and #SHOOTING_GALLERY|WATER_OBSTACLES
   cmp #WATER_OBSTACLES
   beq .setSubmarineSpriteOffset
DetermineAntiAirSpriteOffset
   lda joystickValues,x             ; get the player's joystick value
   and #MOVE_DOWN|MOVE_UP           ; mask all but up and down values
   asl                              ; multiply by 8 to get sprite offset
   asl
.setSubmarineSpriteOffset
   asl
   sta playerGraphicOffsets,x
.setMissileTrajectory
   lda gameVariation
   and #GUIDED_MISSILES
   beq .skipGuidedMissiles
   lda joystickValues,x             ; get the player's joystick value
   sta missileTrajectory,x          ; save in trajectory for guided missiles
.skipGuidedMissiles
   lda missileVertPos,x             ; get the missile's vertical position
   bne LF36E                        ; branch if not off screen
   bit gameState                    ; check the game state
   bpl LF329                        ; branch if game not in play
   lda INPT4+48,x                   ; read the player's fire button
   bpl DetermineMissilePosition     ; branch if fire button not pressed
   lda gameVariation                ; get the current game variation
   and #SINGLEPLAYER                ; see if this is a two player game
   beq LF329
   txa
   beq DetermineMissilePosition
LF329: JMP    LF3F6   ;3

DetermineMissilePosition
   lda gameVariation                ; get the current game variation
   and #POLARIS_VS_BOMBER           ; mask Polaris vs. Bomber value
   tay
   lda #MISSILE_YMIN
   bit gameVariation
   bpl .setMissileVerticalPosition  ; branch if not Polaris vs. Bomber
   lda PlayerVertPosTable,x
   bvc .setMissileVerticalPosition  ; branch if cannot move left or right
   cpx #0
   bne .incrementMissileVertPosition
   cpy #0
   bne .setMissileVerticalPosition
.incrementMissileVertPosition
   clc
   adc #MISSILE_VELOCITY
.setMissileVerticalPosition
   sta missileVertPos,x
   lda #0
   sta RESMP0,x
   lda joystickValues,x             ; get the player's joystick value
   sta missileTrajectory,x          ; save in trajectory
   lda #$1F
   sta audioFrequencies,x           ; set audio frequency for firing
   lda #~DISABLE_BM
   sta missileMask,x                ; set to disable missile
   lda playerHorizPos,x             ; get the player's horizontal position
   sta missileHorizPos,x            ; and set the missile's to the same
   bit gameVariation
   bvc LF36E                        ; branch if can't move left and right
   txa                              ; move player index to accumulator
   bne .setMissileMaskToEnable      ; branch if player 2
   lda gameVariation                ; get the current game variation
   and #POLARIS_VS_BOMBER
   bne LF36E                        ; branch if Polaris Vs. Bomber game
.setMissileMaskToEnable
   lda #(ENABLE_BM ^ $FE)
   sta missileMask,x                ; set to enable missile
LF36E:
   lda obstacleZones,x              ; get the kernel zone for the obstacle
   bmi CalculateMissileXPos         ; branch if shot
   tay                              ; y holds index to obstacle object
   lda objectIds,y                  ; disable missile if the obstacle was
   bmi DisablePlayerMissile         ; shot this frame
CalculateMissileXPos
   lda missileHorizPos,x            ; get the missile's horizontal position
   sta tempMissileHorizPos          ; save it for later
   ldy #2
   bit gameVariation
   bmi LF38B                        ; branch if this is a polaris style game
   bvc LF392                        ; branch if can't move left or right
   lda gameVariation                ; get the game variation
   and #GUIDED_MISSILES
   tay
   beq DetermineMissileXPos
LF38B:
   lda playerHorizPos,x             ; get the player's horizontal position
   sta tempMissileHorizPos          ; save it for later
   jmp DetermineMissileXPos
       
LF392:
   lda missileTrajectory,x          ; get missile trajectory
   and #MOVE_DOWN|MOVE_UP
   tay
   lda MissileAngleTable,y
   cpx #0                           ; if this is not player 1 then the value
   beq .incrementMissileXPos        ; is negated so the missile angle can be
   clc                              ; subtracted below
   eor #$FF
   adc #1
.incrementMissileXPos
   clc
   adc missileHorizPos,x
   sta tempMissileHorizPos
   cmp #MISSILE_XMAX
   bcs DisablePlayerMissile
DetermineMissileXPos
   sec
   lda missileHorizPos,x            ; get the missile horizontal position
   sbc tempMissileHorizPos          ; subtract by the temp position
   cmp #$FC
   bcs .setMissileFineMotion
   cmp #$05
   bcs DisablePlayerMissile
.setMissileFineMotion
   asl                              ; move fine motion value to upper nybble
   asl
   asl
   asl
   sta HMM0,x                       ; set missile fine motion
   lda tempMissileHorizPos
   sta missileHorizPos,x
   lda #POLARIS_VS_BOMBER
   bit gameVariation
   bpl LF3DE                        ; branch if not polaris style game
   bvc LF3D0                        ; branch if can't move left or right
   beq LF3DE                        ; branch if Polaris vs. Bomber
   txa
   bne LF3DE                        ; branch if player 2
LF3D0:
   clc
   lda MissileVertVelocityTable,y
   adc missileVertPos,x
   sta missileVertPos,x
   cmp #$E0
   bcs DisablePlayerMissile
   bcc LF3F6                        ; unconditional branch
       
LF3DE:
   sec
   lda missileVertPos,x
   sbc MissileVertVelocityTable,y
   sta missileVertPos,x
   cmp #YMAX
   bcs LF3F6
DisablePlayerMissile
   lda #$02
   sta RESMP0,x                     ; reset missile position and disable
   lda #0
   sta missileVertPos,x             ; reset the missile's vertical position
   lda #$FF                         ; set frequency high to disable this
   sta audioFrequencies,x           ; frame
LF3F6:
   jsr NextRandom                   ; re-seed random number
   txa
   bne LF40F                        ; branch if player 2
   lda randomSeed                   ; get the current random number
   sta tempRandomSeed               ; save for later
   ldy #5
LF402:
   lda objectIds,y
   cmp #$E0
   ror
   bpl LF40D
   dey
   bpl LF402
LF40D: STA    $9F     ;3
LF40F:
   lda PlayerValueMasks,x           ; get D7/D6 mask values
   sta objectStateMask              ; set value of object state mask
   txa                              ; move player number to accumulator
   ora #6
   tax                              ; x = 6 for player 1 x = 7 for player 2
SetObjectStates
   lda objectAttributes,x           ; get the object attributes
   and #$0F                         ; mask the direction -- keep size
   ora player1DiffState             ; or with difficulty for size of missile
   sta objectAttributes,x           ; get the object attributes
   ror                              ; shift D0 to carry
   lda #OBJECT_XMAX_DOUBLE          ; assume this is a double size object
   bcs .setObjectXMax
   lda #OBJECT_XMAX_SINGLE
.setObjectXMax
   sta objectXMax
       LDY    #$01    ;2
       CPX    obstacle2Zone     ;3
       BEQ    LF435   ;2
       DEY            ;2
       CPX    obstacle1Zone     ;3
       BEQ    LF435   ;2
       DEY            ;2
LF435: STY    hitObstacleKernelZone     ;3
       LDA    objectIds,X   ;4
       BMI    LF43E   ;2
       JMP    LF4DF   ;3
       
LF43E: CMP    #$E1    ;2
       BCS    LF444   ;2
       INC    objectIds,X   ;6
LF444: LDA    #WATER_OBSTACLES
       BIT    gameVariation     ;3
       BPL    LF44C   ;2
       BNE    LF454   ;2
LF44C: BIT    $9F     ;3
       BMI    LF45B   ;2
       CPX    #$06    ;2
   bcc .jmpNextObject
LF454: INC    objectIds,X   ;6
       BPL    LF45B   ;2
.jmpNextObject
   jmp .nextObject

LF45B:
   lda player1DiffState
   sta objectAttributes,x           ; set missile size
   lda gameVariation                ; get the current game variation
   and #OBSTACLES                   ; branch if this game has obstacles
   bne LF469
   lda randomSeed                   ; get the current random number
   sta tempRandomSeed               ; save it for later use
LF469: LDA    $A0     ;3
       AND    objectStateMask
       BNE    LF4B0   ;2
       LDY    hitObstacleKernelZone     ;3
       BMI    LF47B   ;2
       LDA    playerVelocity,Y ;4
       AND    #$40    ;2
       JMP    SetObjectId   ;3
       
LF47B:
   lda gameVariation                ; get the current game variation
   and #SHOOTING_GALLERY|WATER_OBSTACLES
   tay
   cmp #SHOOTING_GALLERY
   bne LF491
       LDA    tempRandomSeed     ;3
       AND    #$18    ;2
   clc
   adc #40
   cmp #ID_AIRCRAFT_CARRIER
   bcc SetObjectId
   bcs LF4B0                        ; unconditional branch
       
LF491:
   bit gameVariation
   bmi .polarisOrBomberGame
   cpx #6
   bcc .polarisOrBomberGame
   lda #ID_BLIMP
   bne LF4B4                        ; unconditional branch
       
.polarisOrBomberGame
   lda gameSelection                ; get the current game selection
   cmp #24                          ; if less than game 24 then determine
   bcc SpawnNewObject               ; new object to spawn
   lda #ID_MINE_1                   ; spawn a new mine
   bne SetObjectId
       
SpawnNewObject
   lda randomSeed                   ; get the random seed
   lsr                              ; shift D0 to carry
   lda tempRandomSeed
   and #%00011000
   bcs LF4B4
LF4B0:
   lda #$C0
   bne SetObjectId                  ; unconditional branch
       
LF4B4:
   cpy #0                           ; set the object id if this is not a
   beq SetObjectId                  ; shooting gallery or water obstacle game
   clc
   adc #64
SetObjectId
   sta objectIds,x
   and #$08
   bne LF4C7
   lda #NO_REFLECT|DOUBLE_SIZE      ; set to no reflect and double size
   ora player1DiffState             ; or in player 1 missile size
   sta objectAttributes,x           ; set object's attributes
LF4C7:
   ldy #HMOVE_0|0
   lda tempRandomSeed               ; get the held random number value
   and #REFLECT >> 1                ; and the value to determine which side
   beq .setObjectInitHorizPos       ; object should appear
   asl
   ora objectAttributes,x           ; reflect the object (i.e. travel left)
   sta objectAttributes,x
   lda #OBJECT_XMAX_DOUBLE+1
   ldy #HMOVE_R6|9
.setObjectInitHorizPos
   sta zoneHorizPos,x
   sty kernelZoneHorizPos,x
   jmp .nextObject
       
LF4DF: LDY    hitObstacleKernelZone     ;3
       BMI    LF4E6   ;2
       LDA    playerVelocity,Y ;4
LF4E6:
   ldy #OBJECT_VELOCITY_MEDIUM      ; set the object's velocity -- used below
   sty objectVelocity               ; when calculating object movement
       AND    #$30    ;2
       BEQ    LF4FA   ;2
   dec objectVelocity               ; slow the object down
       CMP    #$20    ;2
       BCC    LF4FA   ;2
   lda frameCount                   ; get the frame count
   and #$02
   bne .nextObject
LF4FA:
   lda gameVariation                ; get the game variation
   and #SHOOTING_GALLERY|WATER_OBSTACLES
   tay
   cmp #SHOOTING_GALLERY
   bne MoveObjects
   lda frameCount                   ; get the frame count
   and #$7C
   bne MoveObjects                  ; change ~every 2 seconds
   bit randomSeed
   bvc MoveObjects
   lda objectAttributes,x           ; get the object's attributes
   eor #REFLECT                     ; change it's reflect/direction
   sta objectAttributes,x
   
MoveObjects
   lda objectAttributes,x           ; get the object's attributes
   and #REFLECT                     ; get it's reflect/direction
   beq .moveObjectRight
   lda zoneHorizPos,x               ; get the object's horizontal position
   sec
   sbc objectVelocity               ; move the object to the left
   bcs .setObjectHorizontalPosition
   lda objectXMax
   bne LF52F                        ; unconditional branch
   
.moveObjectRight
   clc
   lda zoneHorizPos,x               ; get the object's horizontal position
   adc objectVelocity               ; move the object to the right
   cmp objectXMax
   bcc .setObjectHorizontalPosition
   lda #$00
LF52F:
   cpy #WATER_OBSTACLES
   bne .setObjectHorizontalPosition
   bit gameVariation
   bmi .setObjectHorizontalPosition
   lda #$C0
   sta objectIds,x
   bne .nextObject                  ; unconditional branch
   
.setObjectHorizontalPosition
   sta zoneHorizPos,x
   jsr CalcXPos
   sta kernelZoneHorizPos,x
       LDY    $8A     ;3
   bmi .nextObject
   sta playerFineCoarsePos,y
   lda zoneHorizPos,x
   sta playerHorizPos,y
.nextObject
   dex
   dex
   bmi DoneGameCalculations
   lsr objectStateMask              ; right shift object state mask value
   lsr objectStateMask              ; for next object iteration
   jsr NextRandom                   ; re-seed random number
   jmp SetObjectStates              ; set states of all objects
       
DoneGameCalculations SUBROUTINE
   ldx #1
.loop
   stx tempPlayerIndex
   lda gameVariation                ; get the current game variation
   and #SHOOTING_GALLERY|WATER_OBSTACLES
   lsr
   ora tempPlayerIndex
   tay                              ; save for audio channel offset
   lda #0
   sta AUDV0,x                      ; turn off sounds
   sta scoreGraphics,x              ; clear the score graphics
   lda audioFrequencies,x           ; get the frequency value
   bmi LF581
   sta AUDF0,x
   lda AudioChannelTable,y
   sta AUDC0,x
   lda #8
   sta AUDV0,x
   dec audioFrequencies,x
LF581:
   lda audioFrequencies+2,x
   bmi CalculateScoreOffsets
   eor #$1F
   sta AUDF0,x
   lda AudioChannelTable+1,y
   sta AUDC0,x
   lda #8
   sta AUDV0,x
   dec audioFrequencies+2,x
CalculateScoreOffsets
   lda playerScores,x               ; get the player's score
   and #$0F                         ; mask off the upper nybbles
   sta temp                         ; save the value for later
   asl                              ; shift the value left to multiply by 4
   asl
   clc                              ; add in original so it's multiplied by 5
   adc temp                         ; [i.e. x * 5 = (x * 4) + x]
   sta lsbScoreOffsets,x
   lda playerScores,x
   and #$F0                         ; mask off the lower nybbles
   lsr                              ; divide the value by 4
   lsr
   sta temp                         ; save the value for later
   lsr                              ; divide the value by 16
   lsr
   clc                              ; add in original so it's multiplied by
   adc temp                         ; 5/16 [i.e. 5x/16 = (x / 16) + (x / 4)]
   sta msbScoreOffsets,x
   dex
   bpl .loop
   
   lda gameState                    ; get the current game state
   eor #GAME_RUNNING                ; (#$00 = game over, #$FF = game running)
   and gameTimer
   sta colorXOR                     ; save to colorXOR (cycles colors during attract
   lda #BW_HUE_MASK                 ; mode)
   sta hueMask                      ; set default color hue mask (assume B/W)
   ldx #NUM_KERNEL_ZONES
   ldy #NUM_KERNEL_ZONES
   lda SWCHB                        ; read the console switch value
   and #BW_MASK                     ; get the B/W switch value
   beq .storePlayerColors
   lda #COLOR_HUE_MASK
   sta hueMask                      ; set hue mask for color setting
   ldy #NUM_KERNEL_ZONES*2+1
.storePlayerColors
   lda PlayerColorTable,y
   eor colorXOR
   and hueMask
   sta playerColors,x
   dey                              ; reduce table offset index
   dex
   bpl .storePlayerColors
   ldx #NUM_KERNEL_ZONES
   ldy #NUM_KERNEL_ZONES
   bit gameVariation
   bpl .storeKernelZoneColors
   ldy #NUM_KERNEL_ZONES*2+1
.storeKernelZoneColors
   lda KernelZoneColorTable,y
   eor colorXOR
   and hueMask
   sta kernelZoneColors,x
   dey                              ; reduce table offset index
   dex
   bpl .storeKernelZoneColors
   sta COLUBK
   lda frameCount
   and #$04                         ; explosion updated every 4th frame
   asl                              ; now a = 0 or 8 (sprite height)
   ora #ExplosionSprites-GameSprites
   sta explosionSpriteOffset
   rts

GameVariationTable
; ** Anti-Aircraft **
   .byte OBSTACLES
   .byte OBSTACLES|GUIDED_MISSILES
   .byte SINGLEPLAYER|OBSTACLES
   .byte $00
   .byte GUIDED_MISSILES
   .byte SINGLEPLAYER
; ** Torpedo **
   .byte MOVE_LEFT_RIGHT|WATER_OBSTACLES|OBSTACLES
   .byte MOVE_LEFT_RIGHT|WATER_OBSTACLES|OBSTACLES|GUIDED_MISSILES
   .byte MOVE_LEFT_RIGHT|SINGLEPLAYER|WATER_OBSTACLES|OBSTACLES
   .byte MOVE_LEFT_RIGHT|WATER_OBSTACLES
   .byte MOVE_LEFT_RIGHT|WATER_OBSTACLES|GUIDED_MISSILES
   .byte MOVE_LEFT_RIGHT|SINGLEPLAYER|WATER_OBSTACLES
; ** Shooting Gallery
   .byte SHOOTING_GALLERY
   .byte SHOOTING_GALLERY|GUIDED_MISSILES
   .byte SINGLEPLAYER|SHOOTING_GALLERY
; ** Polaris **
   .byte POLARIS_OR_BOMBER|MOVE_LEFT_RIGHT
   .byte POLARIS_OR_BOMBER|MOVE_LEFT_RIGHT|GUIDED_MISSILES
   .byte POLARIS_OR_BOMBER|MOVE_LEFT_RIGHT|SINGLEPLAYER
; ** Bomber **
   .byte POLARIS_OR_BOMBER|WATER_OBSTACLES
   .byte POLARIS_OR_BOMBER|WATER_OBSTACLES|GUIDED_MISSILES
   .byte POLARIS_OR_BOMBER|SINGLEPLAYER|WATER_OBSTACLES
; ** Polaris vs. Bomber **
   .byte POLARIS_OR_BOMBER|MOVE_LEFT_RIGHT|POLARIS_VS_BOMBER|WATER_OBSTACLES
   .byte POLARIS_OR_BOMBER|MOVE_LEFT_RIGHT|POLARIS_VS_BOMBER|WATER_OBSTACLES|GUIDED_MISSILES
   .byte POLARIS_OR_BOMBER|MOVE_LEFT_RIGHT|POLARIS_VS_BOMBER|SINGLEPLAYER|WATER_OBSTACLES
   .byte POLARIS_OR_BOMBER|MOVE_LEFT_RIGHT|POLARIS_VS_BOMBER|WATER_OBSTACLES
   .byte POLARIS_OR_BOMBER|MOVE_LEFT_RIGHT|POLARIS_VS_BOMBER|WATER_OBSTACLESGUIDED_MISSILES
   .byte POLARIS_OR_BOMBER|MOVE_LEFT_RIGHT|POLARIS_VS_BOMBER|SINGLEPLAYER|WATER_OBSTACLES
   
LF61B: .byte $0C ; |    XX  | $F61B
       .byte $00 ; |        | $F61C
       .byte $30 ; |  XX    | $F61D
       .byte $7E ; | XXXXXX | $F61E

Obstacle1ZoneTable
   .byte $00,$FF,$06,$00
   
Obstacle2ZoneTable
   .byte $01,$FF,$07,$07
       
PlayerVertPosTable
   .byte YPOS_PLAYER1, YPOS_PLAYER2
       
KernelZoneColorTable
   .byte LIGHT_BLUE,LIGHT_BLUE+2,LIGHT_BLUE+2,LIGHT_BLUE+4,LIGHT_BLUE+6
   .byte LIGHT_BLUE+8,LIGHT_BLUE+10,LIGHT_BLUE+12,LIGHT_BLUE+14,BROWN+8
   
   .byte LIGHT_BLUE+2,LIGHT_BLUE+2,LIGHT_BLUE+2,LIGHT_BLUE+2,LIGHT_BLUE+6
   .byte LIGHT_BLUE+8,LIGHT_BLUE+10,LIGHT_BLUE+12,LIGHT_BLUE+14,BROWN+8
       
PlayerColorTable
.blackAndWhite
   .byte BLACK+12,BLACK+6,BLACK+10,BLACK+12,WHITE
   .byte BLACK,BLACK+6,BLACK,BLACK+8,BLACK+6
.color
   .byte GREEN_BLUE+8,RED+8,YELLOW+6,GREEN+12,BLUE+12
   .byte PURPLE+6,GREEN_BLUE+6,RED+8,GREEN_BLUE+8,RED+8
   
PlayerVelocityTable
   .byte VELOCITY_FAST              ; value not used
   .byte VELOCITY_FAST              ; joystick pushed up
   .byte VELOCITY_SLOW              ; joystick pulled back
   .byte VELOCITY_REST              ; joystick at rest

ScoreTable
   .byte LARGE_JET_SCORE,SMALL_JET_SCORE,_747_SCORE,HELICOPTER_SCORE
   .byte BLIMP_SCORE,RABBIT_SCORE,CLOWN_SCORE,DUCK_SCORE
   .byte AIRCRAFT_CARRIER_SCORE,PT_BOAT_SCORE,FREIGHTER_SCORE
   .byte PIRATE_SHIP_SCORE,MINE_SCORE,MINE_SCORE
   
NumberFonts
zero
   .byte $0E ; |....XXX.|
   .byte $0A ; |....X.X.|
   .byte $0A ; |....X.X.|
   .byte $0A ; |....X.X.|
   .byte $0E ; |....XXX.|
one
   .byte $22 ; |..X...X.|
   .byte $22 ; |..X...X.|
   .byte $22 ; |..X...X.|
   .byte $22 ; |..X...X.|
   .byte $22 ; |..X...X.|
two
   .byte $EE ; |XXX.XXX.|
   .byte $22 ; |..X...X.|
   .byte $EE ; |XXX.XXX.|
   .byte $88 ; |X...X...|
   .byte $EE ; |XXX.XXX.|
three
   .byte $EE ; |XXX.XXX.|
   .byte $22 ; |..X...X.|
   .byte $66 ; |.XX..XX.|
   .byte $22 ; |..X...X.|
   .byte $EE ; |XXX.XXX.|
four
   .byte $AA ; |X.X.X.X.|
   .byte $AA ; |X.X.X.X.|
   .byte $EE ; |XXX.XXX.|
   .byte $22 ; |..X...X.|
   .byte $22 ; |..X...X.|
five
   .byte $EE ; |XXX.XXX.|
   .byte $88 ; |X...X...|
   .byte $EE ; |XXX.XXX.|
   .byte $22 ; |..X...X.|
   .byte $EE ; |XXX.XXX.|
six
   .byte $EE ; |XXX.XXX.|
   .byte $88 ; |X...X...|
   .byte $EE ; |XXX XXX.|
   .byte $AA ; |X.X.X.X.|
   .byte $EE ; |XXX.XXX.|
seven
   .byte $EE ; |XXX.XXX.|
   .byte $22 ; |..X...X.|
   .byte $22 ; |..X...X.|
   .byte $22 ; |..X...X.|
   .byte $22 ; |..X...X.|
eight
   .byte $EE ; |XXX.XXX.|
   .byte $AA ; |X.X.X.X.|
   .byte $EE ; |XXX.XXX.|
   .byte $AA ; |X.X.X.X.|
   .byte $EE ; |XXX.XXX.|
nine
   .byte $EE ; |XXX.XXX.|
   .byte $AA ; |X.X.X.X.|
   .byte $EE ; |XXX.XXX.|
   .byte $22 ; |..X...X.|
   .byte $EE ; |XXX.XXX.|
   
GameSprites
LargeJet
   .byte $00 ; |........|
   .byte $80 ; |X.......|
   .byte $86 ; |X....XX.|
   .byte $FF ; |XXXXXXXX|
   .byte $FF ; |XXXXXXXX|
   .byte $38 ; |..XXX...|
   .byte $30 ; |..XX....|
   .byte $00 ; |........|
SmallJet
   .byte $00 ; |........|
   .byte $BE ; |X.XXXXX.|
   .byte $88 ; |X...X...|
   .byte $FF ; |XXXXXXXX|
   .byte $FF ; |XXXXXXXX|
   .byte $08 ; |....X...|
   .byte $3E ; |..XXXXX.|
   .byte $00 ; |........|
_747
   .byte $00 ; |........|
   .byte $80 ; |X.......|
   .byte $C0 ; |XX......|
   .byte $FE ; |XXXXXXX.|
   .byte $0F ; |....XXXX|
   .byte $18 ; |...XX...|
   .byte $30 ; |..XX....|
   .byte $00 ; |........|
Helicopter
   .byte $1F ; |...XXXXX|
   .byte $84 ; |X....X..|
   .byte $CF ; |XX..XXXX|
   .byte $7D ; |.XXXXX.X|
   .byte $0D ; |....XX.X|
   .byte $0F ; |....XXXX|
   .byte $00 ; |........|
   .byte $00 ; |........|
ObservationBlimp
   .byte $7E ; |.XXXXXX.|
   .byte $C3 ; |XX....XX|
   .byte $DB ; |XX.XX.XX|
   .byte $C3 ; |XX....XX|
   .byte $DB ; |XX.XX.XX|
   .byte $7E ; |.XXXXXX.|
   .byte $18 ; |...XX...|
   .byte $00 ; |........|
Rabbit
   .byte $00 ; |........|
   .byte $00 ; |........|
   .byte $08 ; |....X...|
   .byte $44 ; |.X...X..|
   .byte $3A ; |..XXX.X.|
   .byte $7C ; |.XXXXX..|
   .byte $46 ; |.X...XX.|
   .byte $00 ; |........|
Clown
   .byte $7E ; |.XXXXXX.|
   .byte $DB ; |XX.XX.XX|
   .byte $FF ; |XXXXXXXX|
   .byte $E7 ; |XXX..XXX|
   .byte $BD ; |X.XXXX.X|
   .byte $81 ; |X......X|
   .byte $FF ; |XXXXXXXX|
   .byte $00 ; |........|
Duck
   .byte $00 ; |........|
   .byte $00 ; |........|
   .byte $0C ; |....XX..|
   .byte $0B ; |....X.XX|
   .byte $44 ; |.X...X..|
   .byte $FE ; |XXXXXXX.|
   .byte $7E ; |.XXXXXX.|
   .byte $00 ; |........|
AircraftCarrier
   .byte $00 ; |........|
   .byte $10 ; |...X....|
   .byte $38 ; |..XXX...|
   .byte $FF ; |XXXXXXXX|
   .byte $FE ; |XXXXXXX.|
   .byte $7E ; |.XXXXXX.|
   .byte $00 ; |........|
   .byte $00 ; |........|
PTBoat
   .byte $00 ; |........|
   .byte $10 ; |...X....|
   .byte $54 ; |.X.X.X..|
   .byte $7F ; |.XXXXXXX|
   .byte $FE ; |XXXXXXX.|
   .byte $FC ; |XXXXXX..|
   .byte $3C ; |..XXXX..|
   .byte $00 ; |........|
Freighter
   .byte $10 ; |...X....|
   .byte $10 ; |...X....|
   .byte $36 ; |..XX.XX.|
   .byte $FF ; |XXXXXXXX|
   .byte $7E ; |.XXXXXX.|
   .byte $3C ; |..XXXX..|
   .byte $00 ; |........|
   .byte $00 ; |........|
PirateShip
   .byte $28 ; |..X.X...|
   .byte $28 ; |..X.X...|
   .byte $28 ; |..X.X...|
   .byte $AB ; |X.X.X.XX|
   .byte $FF ; |XXXXXXXX|
   .byte $7E ; |.XXXXXX.|
   .byte $7C ; |.XXXXX..|
   .byte $00 ; |........|
Mine_0
   .byte $2A ; |..X.X.X.|
   .byte $1C ; |...XXX..|
   .byte $1C ; |...XXX..|
   .byte $2A ; |..X.X.X.|
   .byte $08 ; |....X...|
   .byte $30 ; |..XX....|
   .byte $C0 ; |XX......|
   .byte $00 ; |........|
Mine_1
   .byte $18 ; |...XX...|
   .byte $5A ; |.X.XX.X.|
   .byte $3C ; |..XXXX..|
   .byte $FF ; |XXXXXXXX|
   .byte $3C ; |..XXXX..|
   .byte $5A ; |.X.XX.X.|
   .byte $18 ; |...XX...|
   .byte $00 ; |........|
   
ExplosionSprites
Explosion_0
   .byte $18 ; |...XX...|
   .byte $24 ; |..X..X..|
   .byte $42 ; |.X....X.|
   .byte $81 ; |X......X|
   .byte $42 ; |.X....X.|
   .byte $24 ; |..X..X..|
   .byte $18 ; |...XX...|
   .byte $00 ; |........|
Explosion_1
   .byte $42 ; |.X....X.|
   .byte $81 ; |X......X|
   .byte $99 ; |X..XX..X|
   .byte $24 ; |..X..X..|
   .byte $99 ; |X..XX..X|
   .byte $81 ; |X......X|
   .byte $42 ; |.X....X.|
   .byte $00 ; |........|
   
AudioChannelTable
   .byte $08,$09,$04,$0C,$03,$01,$08
   
AntiAircraftGuns
_60Degrees_0
   .byte $1C ; |...XXX..|
   .byte $1C ; |...XXX..|
   .byte $38 ; |..XXX...|
   .byte $38 ; |..XXX...|
   .byte $70 ; |.XXX....|
   .byte $70 ; |.XXX....|
   .byte $FF ; |XXXXXXXX|
   .byte $FF ; |XXXXXXXX|
_90Degress
   .byte $70 ; |.XXX....|
   .byte $70 ; |.XXX....|
   .byte $70 ; |.XXX....|
   .byte $70 ; |.XXX....|
   .byte $70 ; |.XXX....|
   .byte $70 ; |.XXX....|
   .byte $FF ; |XXXXXXXX|
   .byte $FF ; |XXXXXXXX|
_30Degress
   .byte $00 ; |........|
   .byte $01 ; |.......X|
   .byte $07 ; |.....XXX|
   .byte $1E ; |...XXXX.|
   .byte $3C ; |..XXXX..|
   .byte $70 ; |.XXX....|
   .byte $FF ; |XXXXXXXX|
   .byte $FF ; |XXXXXXXX|
_60Degress_1
   .byte $1C ; |...XXX..|
   .byte $1C ; |...XXX..|
   .byte $38 ; |..XXX...|
   .byte $38 ; |..XXX...|
   .byte $70 ; |.XXX....|
   .byte $70 ; |.XXX....|
   .byte $FF ; |XXXXXXXX|
   .byte $FF ; |XXXXXXXX|
   
MissileAngleTable
   .byte MISSILE_HORZ_VELOCITY_60   ; value not used
   .byte MISSILE_HORZ_VELOCITY_90   ; joystick pushed back
   .byte MISSILE_HORZ_VELOCITY_30   ; joystick pulled up
   .byte MISSILE_HORZ_VELOCITY_60   ; joystick at rest
   
MissileVertVelocityTable
   .byte MISSILE_VERT_VELOCITY_60   ; value not used
   .byte MISSILE_VERT_VELOCITY_90   ; joystick pushed back
   .byte MISSILE_VERT_VELOCITY_30   ; joystick pushed forward
   .byte MISSILE_VERT_VELOCITY_60   ; joystick at rest
       
MissileCollisionZoneTable
   .byte %00010000, %10000000
       
DifficultySwitchMask
MissileCollisionMask
PlayerValueMasks
LF746: .byte $40,$80

GunXMinTable
   .byte PLAYER1_GUN_XMIN,PLAYER2_GUN_XMIN
GunXMaxTable
   .byte PLAYER1_GUN_XMAX,PLAYER2_GUN_XMAX
       
CalcXPos
   sta temp                         ; save off the x position
   bpl .determineCoarseValue        ; this instruction isn't really needed
   cmp #XMAX                        ; make sure object not out of range
   bcc .determineCoarseValue        ; if not compute coarse value
   lda #0
   sta temp                         ; set to min value
.determineCoarseValue
   lsr                              ; shift top nybble to lower nybble
   lsr
   lsr
   lsr
   tay                              ; save the value
   lda temp                         ; get the object's x position
   and #$0F                         ; mask upper nybble
   sty temp                         ; save coarse value for later
   clc
   adc temp                         ; add in coarse value (A = C + F)
   cmp #15
   bcc .skipSubtractions
   sbc #15                          ; subtract 15
   iny                              ; and increment coarse value
.skipSubtractions
   cmp #XMIN                        ; make sure hasn't gone pass min x value
   eor #$0F
   bcs .skipFineIncrement
   adc #1                           ; increment fine motion value
   dey                              ; reduce coarse value
.skipFineIncrement
   iny                              ; increment coarse value
   asl                              ; move fine motion value to upper nybble
   asl
   asl
   asl
   sta temp                         ; save it for later
   tya                              ; move coarse value to accumulator
   ora temp                         ; accumualtor holds fine/coarse value
   rts

NextRandom
   lsr randomSeed
   rol
   eor randomSeed
   lsr
   lda randomSeed
   bcs .leaveNextRandom
   ora #$40
   sta randomSeed
.leaveNextRandom
   rts

CalculateScore SUBROUTINE
   sty tempKernelZone               ; save off zone where collision happened
   ldy #2                           ; offset for 1 point
   lda tempKernelZone
   bmi .incrementScore
   cmp obstacleZones,x              ; if an obstacle was hit then
   beq .leaveRoutine                ; leave routine
   txa                              ; move player number to accumulator
   eor #1                           ; XOR the value to check the next
   tay                              ; obstacle
   lda tempKernelZone
   cmp obstacleZones,y              ; if an obstacle not hit then
   bne .determinePointValue         ; determine point value
   lda gameVariation                ; get the current game variation
   and #POLARIS_VS_BOMBER           ; no points for obstacles
   beq .leaveRoutine
   ldy #2                           ; offset for 1 point
   bne .incrementScore              ; unconditional branch

.determinePointValue
   ldy tempKernelZone
   lda objectIds,y
   bmi .leaveRoutine
   lsr                              ; divide the value by 8 to get point
   lsr                              ; value offset
   lsr
   tay                              ; move point value offset to y
   lda gameVariation                ; get the current game variation
   and #OBSTACLES                   ; see if obstacles are present
                                    ; (i.e. every item is one point)
   beq .incrementScore
   tay                              ; move to y so score increments by 1
.incrementScore
   lda ScoreTable,y                 ; read the point value from table
   sed                              ; set to decimal mode
   clc
   adc playerScores,x               ; increment player's score
   sta playerScores,x
   cld                              ; clear decimal mode
   bcs .maxScoreReached             ; end game if score over 99
   cmp #MAX_SCORE                   ; compare to the max score to see if game
   bne .setAudioFrequency           ; should end
.maxScoreReached
   lda #0
   sta gameState                    ; show the game is over
   sta gameTimer                    ; reset the game timer
   sta frameCount                   ; reset the frame count
   lda #MAX_SCORE                   ; set the player's score to the maximum
   sta playerScores,x
.setAudioFrequency
   ldy tempKernelZone
   lda #$1F
   sta audioFrequencies+2,x
   cpy #8
   bcs .resetPlayerMissile
   lda #$A0
   sta objectIds,y
.resetPlayerMissile
   lda #0
   sta missileVertPos,x             ; reset the missile's vertical position
   lda #2
   sta RESMP0,x                     ; lock missile to player and disable
.leaveRoutine
   ldy tempKernelZone               ; restore y register
   rts

   IF COMPILE_VERSION = NTSC
   
   .org $F7FA, 106
   .word Start
   .word Start
   .word Start
   
   ELSE
   
   .org $F7FC, 234
   .word Start
   .word Start
   
   ENDIF
