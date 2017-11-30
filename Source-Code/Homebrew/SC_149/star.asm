; breakif {_scan>#34 && PC==53ec}
; breakif {_scan>#266 && PC==1226}

; -----------------------------------------------------------------------------
; Star Castle Arcade - Atari 2600
; Copyright (C) 2012 Chris Walton (cd-w) <cwalton@gmail.com>
; Copyright (C) 2013 Thomas Jentzsch <tjentzsch@yahoo.de>
; -----------------------------------------------------------------------------

; Explanation:
; - = open
; o = partially
; + = done
; ? = debatable
; x = cancelled

; Arcade Differences:
; + 3..6 lives via dip switches; 5 or 3 lives depending on left difficulty
;
; x extra lives > 100
; + game speed increases with score, segments, time...?
;   + gamespeed (0..15) now based on score (increases every 1000 points)
; + ring rotation
;   + not in sync
;   + direction moves with ring (DONE: check mines on rings, gun gaps)
;   + speed moves with the ring
;   + speeds
;     + increases with score (not castle)
;     + reverse rotation at constant speed: 4.7s/loop, (1st castle: middle)
;     + others: 0..1250 pts: 4.7 (outside)/3.2s (inside); ..2500 pts: 3.2/2.35s; then: 2.4/1.9s
;       own speed range defined
;   + offsets are transfered with the expanding rings
;   + hit sparks (DONE: graphics)
;   + castle slowly regenerates after being killed (NOT at start!), starting with two rings (inner and tiny inner)
; + killing gun and getting killed costs one life
; + shield kick
;   + ignores previous speed
;   + gives new speed
;   + doesn't reposition
; + ships
;   + facing left at life start
;   + start position moves up with each new life? (10 positions, 1st is from previous game, 2nd one is bottom + 1?)
;     1st one not reset at new game
;     + index: ships - initial - castle
;     - number indexes = 10? (currently 8)
;   ? X and Y speed are NOT linked together
;   + deceleration is linear and lower
;   x ship decelerates differently in left/down (100%) than in right/up (~50%) direction!!!
;   + after castle completed, ship continues at current spot in next castle
;   + ship bounces during explosion
;   + increased turning speed acceleration
;   + max turning speed too slow (~10%)
; o mines
;   + immediate respawn
;   + spawn position depends on gun direction (dir - 90°)
;   + spawn independent from ship direction
;   o hop back and forth on the rings
;   + higher homing speed at higher scores (as fast as player's ship)
;   + homing mine movement has some randomness to prevent mine grouping
;   + homing mine lifetime varies (lifetime counted on ring too, but only 50%)
;   + slower turning speed in lower castles
;   o mines hop much faster in arcade in higher levels
;   ? max. one mine per ring segment
;   + disappear when they hit a ship
;   + mines on ring do not kill ship
;   + hit sparks (DONE: graphics)
; + gun
;   + shots immediately when there is a gap
;   + projectile moves a bit faster (using bullet speeds now)
;   + projectile disappears when ship is hit
;   + starts new gun life at last direction
;   + starts next ship at last direction
;   + shots whenever there is space, no matter where the player's ship is
;   + is turning slower, especially initially
; + bullets
;   + max. 3 at a time
; o sounds
;   o siren frequency depending on segments (~65..260Hz):
;     + intermediate screen (highest pitch, slightly higher than 3)
;     + 36..28: 0 (lowest pitch)
;     + 27..24: 1 (slightly higher)
;     + 23..20: 2
;     + 19..16: 3 (high pitch)
;     + 15..12: 4 (reset to between 1 and 2)
;     + 11.. 8  5 (slightly higher, still lower than 2)
;     +  7.. 4  6 (slightly higher than 3)
;     +  3..    7 (slightly higher = intermediate)
;   o decide for siren (and other) sound volumes
;   x no sound when hitting segment first time
;   + thrust sound very low
;   ? projectile sound starts like fire sound
;   + better sound mapping
;     + channel 0:
;       + 2. ship explosion (x channel 1?)
;       + 9. siren
;     + channel 1:
;       + 1. gun explosion
;       + 3. projectile
;       + 6. bullet fire (DONE)
;       + 8. ship ring bounce
;       + 10. bullet sector 1st hit
;       + 11. thrust
;     + both (but only once!):
;       + 4. bullet mine hits
;       + 5. bullet sector explosion
;       + 7. homing mine sound (delta mode, improved)
;       + prevent same sound twice
; + scoring:
;   + 10/20/30 points per segment hit (not per segment destroyed)
;   + no leading zeroes
;     + score
;     + castle
;     + ships
;     + highscore
;   x scores are centered
;   + digits are slightly wider
; - ...

; Bugs/TODOs:
; + it seems that the gun is correcting direction after finding a gap but before fireing
;   this leads to shots going through intact sectors
; + increase vertical screen size (DONE: use gained time)
;   + define extra stars data
;   + adjust stars in various screens
;   + center/resize other screens
; + make ring 1 data ordered like ring 0 + 2 data
; + gun needs gaps in all three rings
; o general task management
;   + allow individual tasks with priority and order
;   o adjust parameters of tasks (check if they could be skipped)
; + regenerate if middle ring is empty (test arcade).
; + homing mines broken at higher castles (>=6)
; + explosion too slow (check again when CPU time is reduced!)
; + vector angle gives too coarse results
; + occasional glitch when mine is shot
; + bullet sometimes glitches when it hits (could be same problem as with initial mine?)
; + DIR_SEARCH
;   x gap found a bit too early (counter clockwise)
;   + no gap found when GUNDIR = 17
; + occasional reversed intermediate castle/ship graphics
; + first mine glitch (only if thrusting or fireing!?)
;   resulted from following order: 1. x-pos mine; 2. create mine; 3. display mine
; + thrust sound corrupted
; + thrust sound set to lowest possible frequency and made 50% louder
; + siren twice as loud
; + bullet/ring check may have flaws
; + occasional single pixel glitch on empty ring segments
; + another occasional single pixel glitch at start of new life (reason: odd without even rotate)
; + empty high score initials ... (instead of aaa)
; + difficulty switches fixed at start of game (4 different high score tables)
;   + make different high socre tables identifialble (DONE: "Game 1", removed colors)
; + stop gun shooting when ship is exploding
; o more ring colors
;   + 8 different sets
;   o define colors (NTSC done, TODO: PAL)
; + mine graphics (maybe slower?)
; + mines do not change colors when ring regenerates (automagically DONE by phase regeneration)
; + thrust sound broken after gun explosion
; + occasional crash!!! (X used in CheckRegenerate)
; + fixed last color mode remembered
; o check PAL colors on real hardware
; + mine explosion graphics
; + add "arcade" to the title graphics
; + pulse red part of the title graphics in sync with music
; + (c) 201*3* (fixed "3" font)
; x new ship must not start at blind gun spot (but arcade does too)
; + highlights in small letters M and W and score 4
; + adjusted flashing text on/off ratio
; x vary ship's thrust display frames %10 -> e.g. %101
; + white vertical line before highscore
; o more gun explosion animations
;   o gain space (TODO: fix position of some gun directions)
;   + optimize overlapping
;   + implement new data (center structure need more details)
; + rings once suddendly degenerated, starting with a shot mine (not 100% sure fixed)
; + occasional pre-kernel timer overrun glitch
; + bullet glitch when shot is started
; + stall code with 50Hz timing wrong
; + loop bullet vs mine code
; + 50Hz music speed adjusted
; o adjust game speeds depending on FPS
; + position 10 for new high score displayed as "01"
; + ship not comming to a full stop
; + ship is not slowing down while thrusting at a 90° different direction
; + artefacts when rotating gun top to right
; + artefacts when rotating gun right to top
; + top row gun is missing when rotated left
; o check frame losses (too many?)
; + some factors fail with 50Hz (MineKickChance & GunSpeed)
; + ship rotationg must be doubled (asl!)
; + siren flanging a bit more dynamic
; + make bullets/ships a bit brighter (+2)
; + ship very close to ring can kill new castle while generating (v140)
; + mines approaching from the side are killed by ship's shots (v140)
; + mines wrap horizontally too easy (v140)
; + mines turn speed wraps to zero at highest level
; - ...

; Ideas:
; + transfer colors with rings too
;   + gun changes color too, is that OK?
;   + smoother transitions, e.g. phased
;   ? use a 4th color
; + PAL50 timing option
; + smaller ship to allow better manouvering?
;   + data (ship, ship + flames)
;   + offset
;   + reflection
;   + projectile collision
; + use direction search for mine/bullet ring hits
; x using VDELP0 to move ship smoother vertically (not possible)
; x reverse display of double hit segments (dotted = complete, full = hit once)
;   x done, but is it a good idea?
; + increase some difficulties 1000 points earlier (kick chance, gun turning)
; x better do 16 difficulties for those?
; ? reduce maximum ring rotatation speed (saves CPU time)
; + rename "Wave" into "Castle"
; ! more kernel lines (200/262 -> 208..212/270), adjust scanlines
;   + AA logo
;   + title
;   + Melody load
;   + highscores
;   + game
;   + messages
; + remove single-shot segment option, allow switch for something else
; + left difficulty starts at 50% of max. level
; + added sound for sector 1st hit (not existing in arcade)
; + always get initials from last highscore
; + wipe only deletes highscores (not color mode and initials)
; + add copyright and version into code
; + reworked spinner graphics (a bit more fancy now)
; + move kernel left by 3 pixel (better centered then)
;   + kernel
;   + messages
; x make sonar ping event driven (cleanup channel 0 data)
; o save CPU time to reduce task frame skips
;   + merge GunLogic with DrawGun and frameskip both (->HandleGun)
;   x frameskip Joystick task (moved debounce fire into task) (becomes sluggish!)
;   + moved mine and bullet flicker code into VSYNC
;   - improve BulletCollideRing
; + allow one undo of kernel miss
; + RESET at high score input still saves the score
; + add simple grayscale test screen (LEFT + FIRE)
; + FINAL BETA @ 134 released
; + FINAL BETA @ 140 released

  ; DASM Processor Type
  PROCESSOR 6502

  LIST OFF
  ; VCS Constants & Macros
  INCLUDE "vcs.h"
  INCLUDE "macro.h"
  LIST ON

; -----------------------------------------------------------------------------
; Assembler Switches
; -----------------------------------------------------------------------------

DEBUG               = 0     ; Enable Debugging (1 = Yes)
DEMO                = 0     ; Use Beta Demo colors

 IF DEBUG
NTSC_TIM            = 1     ; 0 = 50Hz (PAL)
; some debugging options
TEST_FRAME_SKIP     = 0
FAKESPIN            = 1     ; Fake Spinner (1 = Yes)
ECHO_FREE           = 1     ; Enable free space output
CHEAT               = 0     ; Disables (most) collisions, adds 50 lives

MELODY              = 1     ; enables highscore R/W

SMALL_SHIP          = 1     ; 6x6 instead of 7x7
SONAR               = 1     ; homing mines make sonar sound
SONAR_DELTA         = 1     ; sonar ping depends on mine distance
SONAR_EVENT         = 0     ; sonar ping is event driven
PHASED_REGEN        = 1     ; regenerate rings phased
L_DIFF_SINGLE       = 0     ; left difficulty switch B = single shot segments
KERNEL_SHL_3        = 1
OVERHEAT            = 1
 ELSE ;{ release version, do NOT touch!
NTSC_TIM            = 1     ; 0 = 50Hz (PAL)
; some debugging options
TEST_FRAME_SKIP     = 0
FAKESPIN            = 1     ; Fake Spinner (1 = Yes)
ECHO_FREE           = 1     ; Enable free space output
CHEAT               = 0     ; Disables (most) collisions, adds 50 lives

MELODY              = 1     ; enables highscore R/W

SMALL_SHIP          = 1     ; 6x6 instead of 7x7
SONAR               = 1     ; homing mines make sonar sound
SONAR_DELTA         = 1     ; sonar ping depends on mine distance
SONAR_EVENT         = 0     ; sonar ping is event driven
PHASED_REGEN        = 1     ; regenerate rings phased
L_DIFF_SINGLE       = 0     ; left difficulty switch B = single shot segments
KERNEL_SHL_3        = 1
OVERHEAT            = 1
 ENDIF ;}

  ; RAM+ Base Addresses
  IFNCONST RAM_BASE_ADDRESS
RAM_BASE_ADDRESS = $1000
  ENDIF
  IFNCONST RAM_BASE_WRITE_ADDRESS
RAM_BASE_WRITE_ADDRESS = RAM_BASE_ADDRESS
  ENDIF
  IFNCONST RAM_BASE_READ_ADDRESS
RAM_BASE_READ_ADDRESS = RAM_BASE_ADDRESS+$100
  ENDIF


; -----------------------------------------------------------------------------
; Game Constants
; -----------------------------------------------------------------------------

; general color constants
YELLOW_NTSC         = $10
BROWN_NTSC          = $20
ORANGE_NTSC         = $30
RED_NTSC            = $40
MAUVE_NTSC          = $50
VIOLET_NTSC         = $60
PURPLE_NTSC         = $70
BLUE_NTSC           = $80
BLUE_CYAN_NTSC      = $90
CYAN_NTSC           = $a0
CYAN_GREEN_NTSC     = $b0
GREEN_NTSC          = $c0
GREEN_YELLOW_NTSC   = $d0
GREEN_BEIGE_NTSC    = $e0
BEIGE_NTSC          = $f0

YELLOW_PAL          = $20
BROWN_PAL           = $40
ORANGE_PAL          = BROWN_PAL
RED_PAL             = $60
MAUVE_PAL           = $80
VIOLET_PAL          = $a0
PURPLE_PAL          = $c0
BLUE_PAL            = $d0
BLUE_CYAN_PAL       = $b0
CYAN_PAL            = $90
CYAN_GREEN_PAL      = $70
GREEN_PAL           = $50
GREEN_YELLOW_PAL    = $30
GREEN_BEIGE_PAL     = GREEN_YELLOW_PAL
BEIGE_PAL           = YELLOW_PAL

; in game color constants
SHIP_COL_NTSC           = BLUE_NTSC|$a
SHIP_COL_PAL            = BLUE_PAL|$a
SHIP_COL_BW             = $a

SHIP_FLICKER_COL_NTSC   = BLUE_NTSC|$c
SHIP_FLICKER_COL_PAL    = BLUE_PAL|$c
SHIP_FLICKER_COL_BW     = $c

MINE_COL_NTSC           = SHIP_FLICKER_COL_NTSC
MINE_COL_PAL            = SHIP_FLICKER_COL_PAL
MINE_COL_BW             = SHIP_FLICKER_COL_BW

STAR_COL_NTSC           = BLUE_NTSC|$4
STAR_COL_PAL            = BLUE_PAL|$4
STAR_COL_BW             = $4

TEXT_COL_NTSC           = BLUE_NTSC|$c
TEXT_COL_PAL            = BLUE_PAL|$c
TEXT_COL_BW             = $c

; Bank Switching Constants
HOTSPOTS        = $fff5
BANK0           = HOTSPOTS+0
BANK1           = HOTSPOTS+1
BANK2           = HOTSPOTS+2
BANK3           = HOTSPOTS+3
BANK4           = HOTSPOTS+4
BANK5           = HOTSPOTS+5
BANK6           = HOTSPOTS+6

; Melody constants
MELODY_READ     = 1
MELODY_WRITE    = 2

RAMSPINNER      = $B0       ; Stall Code Address

;-------------------------------------------------------------------------------

  MAC DEFINE_FPS
FPS         = (SCAN_FREQ + SCAN_LINES/2)/SCAN_LINES
  ENDM

  MAC DEFINE_FPS_MULT
{1} = ({2}*60 + FPS/2)/FPS
  ENDM

  MAC DEFINE_FPS_DIV
{1} = ({2}*FPS + 60/2)/60
  ENDM

  MAC DEFINE_OVERDELAY
 IF NTSC_TIM
OVERDELAY   = ((SCAN_LINES-VISIBLE_LINES-3)*76*3/8+32)/64 + 1
 ELSE
OVERDELAY   = ((SCAN_LINES-VISIBLE_LINES-3)*76*4/8+32)/64 + 1
 ENDIF
;OVERDELAY   = ((SCAN_LINES-VISIBLE_LINES-3)*76*44/100+32)/64 + 1
  ENDM

  MAC DEFINE_VBLANKDELAY
VBLANKDELAY = ((SCAN_LINES-VISIBLE_LINES-3)*76+32)/64 - (OVERDELAY + KERNEL_DELAY)
  ENDM

  MAC DEFINE_FRAMEDELAY
FRAMEDELAY  = (VISIBLE_LINES*76+32)/64
  ENDM

;-------------------------------------------------------------------------------
KERNEL_DELAY    = 7+2

ORIGINAL_LINES  = 180

; Time Constants
  IF NTSC_TIM
SCAN_FREQ       = 15700
SCAN_LINES      = 262+8
EXTRA_LINES     = 14       ; 7 double scan lines each at top and bottom
  ELSE
SCAN_FREQ       = 15557
SCAN_LINES      = 312
EXTRA_LINES     = 16       ; 8 double scan lines each at top and bottom
  ENDIF

VISIBLE_LINES   = ORIGINAL_LINES + EXTRA_LINES * 2

  DEFINE_FPS                ; 262 = 60; 312 = 50; 270 = 58
  DEFINE_OVERDELAY          ; 262/200   = $1b
  DEFINE_VBLANKDELAY        ; 262/200   = $24
  DEFINE_FRAMEDELAY         ; 262/200   = $ee

;-------------------------------------------------------------------------------
; Hiscore Constants
MAXSCORES       = 10        ; Scores In Table

; Game Constants
EXPLODEFRAMES   = 18+1+7+1  ; was 120

; Screen Constants
SCREEN_WIDTH    = 160
YRINGS          = 40        ; Ring Area Height
YOFFSET         = 25+EXTRA_LINES/2      ; Top and Bottom Space
YSTART          = (YRINGS + (YOFFSET * 2))  ; 90 = kernel height/2
YSPACE          = YRINGS + YOFFSET          ; 65
 IF KERNEL_SHL_3
MIDDLEX         = SCREEN_WIDTH / 2 + 1      ;
 ELSE
MIDDLEX         = SCREEN_WIDTH / 2 + 4      ; off center! kernel limitations???
 ENDIF
MIDDLEY         = YSTART / 2                ; ??? (was 45)
XXX             = (MIDDLEX - 20)            ; 64
YYY             = (MIDDLEY - 20)            ; 25

; Ring Constants:
NUM_RINGS       = 3
NUM_SECS        = 12
TOTAL_SECS      = NUM_RINGS * NUM_SECS

SEC0_SIZE       = 9
SEC1_SIZE       = 7
SEC2_SIZE       = 5

RING0_SIZE      = NUM_SECS * SEC0_SIZE  ; 108   (< 128!)
RING1_SIZE      = NUM_SECS * SEC1_SIZE  ; 84
RING2_SIZE      = NUM_SECS * SEC2_SIZE  ; 60

BREACH_BIT      = 1<<7      ; $80

RING0_DIR       = 1<<7
RING1_DIR       = 1<<6
RING2_DIR       = 1<<5
 IF PHASED_REGEN
RINGX_DIR       = 1<<4
 ENDIF
RING_SPEEDS     = 8

MAX_CASTLES     = 99

; general direction constant
NUM_DIRS        = 1<<5      ; 32

  IF SMALL_SHIP
SHIP_SIZE = 6
  ELSE ;{
SHIP_SIZE = 7
  ENDIF ;}

INIT_SHIPS_B    = 5
INIT_SHIPS_A    = 3
MAX_SHIPS       = 99

NUM_PROJ_FRAMES = 16
SPARK_FRAMES    = NUM_PROJ_FRAMES + 3 ; last one is empty (collision fix)
SPARK_FLAG      = %01000000

; Mine Constants
NUM_MINES       = 3
; MINEDIR_R/W constants
MINE_MODE_MASK  = %11100000
MINE_DIR_MASK   = %00011111
MINE_DEAD       = %000<<5   ; Unspawned
MINE_RING0      = %001<<5
MINE_RING1      = %010<<5
MINE_RING2      = %011<<5
;MINE_EXPL       = %100<<5
MINE_HOMING     = %111<<5

MINE_TIME       = 30*(FPS/NUM_MINES/4)+NUM_MINES    ; ~30s (50% outside ring)

; Bullet Constants
NUM_BULLETS     = 3
HEAT_INC        = (4 * FPS+30)/60   ; ~15Hz allowed
MAX_HEAT        = HEAT_INC*6        ; 6 shots bursts

; SectorMap Constants
FULL_SEC        = $00
CLEAR_SEC       = $FF
DOTTED_SEC      = %01010101 ;$55

BW_BIT          = 1<<3

; MODE constants:
MODE_TIMER          = %11111        ; updated every 8 frames
  DEFINE_FPS_DIV GET_READY_TIM,    %01111    ; 15
  DEFINE_FPS_DIV GAME_OVER_TIM,    %11111    ; 31
  DEFINE_FPS_DIV SHIPS_CASTLE_TIM, %10111    ; 23

MODE_MASK           = %111<<5
MODE_MAIN_GAME      = %000<<5
MODE_SCORE_SHIPS    = %001<<5   ; (after death)
MODE_SCORE_CASTLE   = %010<<5   ; (on new castle)
MODE_GET_READY      = %011<<5
MODE_GAME_OVER      = %100<<5
MODE_PAUSED         = %101<<5
MODE_UNKNOWN        = %110<<5   ; ???
MODE_EXPLOSION      = %111<<5

NUM_COLMODES        = 3

; SFX constants:
; channel 0
SFX_SWITCH          = SFXSwitchEnd - SoundData0 - 1          ; 12
 IF SONAR
SFX_SONAR           = SFXSonarEnd - SoundData0 - 1
 ENDIF
SFX_SECTOR_EXPL     = SFXSectorExplosionEnd - SoundData0 - 1 ; 50
SFX_BLLT_MINE       = SFXMineExplosionEnd - SoundData0 - 1   ; 69
SFX_EXPL_SHIP       = SFXShipExplosionEnd - SoundData0 - 1   ; 169
; channel 1
SFX_SHIP_RING       = SFXRingBounceEnd - SoundData1 - 1      ; 20
 IF SONAR
SFX_SONAR           = SFXSonarEnd1 - SoundData1 - 1
 ENDIF
SFX_FIRE_BLLT       = SFXBulletEnd - SoundData1 - 1          ; 34
SFX_SECTOR_EXPL     = SFXSectorExplosionEnd1 - SoundData1 - 1 ; 50
SFX_SECTOR_HIT      = SFX_SECTOR_EXPL - 7
SFX_BLLT_MINE       = SFXMineExplosionEnd1 - SoundData1 - 1   ; 69
SFX_FIRE_PROJ       = SFXGunEnd - SoundData1 - 1             ; 126
SFX_GUN_EXPL        = SFXRingExplosionEnd - SoundData1 - 1   ; 254


; siren constants
;BUZZY       = $1
;PURE_DIV2   = $4
PURE_DIV6   = $c
PURE_DIV31  = $6
;PURE_DIV93  = $e

PURE_DIV_LO = PURE_DIV31
PURE_DIV_HI = PURE_DIV6


; game speed constants:
NUM_SPEEDS  =    8                          ; maximum game speed

  DEFINE_FPS_MULT SHIP_VACC,            5

; one turn per second, value added twice/frame!
SHIP_VSPEED = ((128*NUM_DIRS/FPS + SHIP_VACC/2) / SHIP_VACC) * SHIP_VACC ; must be <128!

SPEED_MULT          =  100                  ; multiplier for speed constants (do NOT FPS adjust these!)
FACTOR_MULT         = 1000                  ; multiplier for speed factors (do NOT FPS adjust these!)

  DEFINE_FPS_MULT MAX_SHIP_SPEED,       120
  DEFINE_FPS_MULT SHIP_ACCEL_SPEED,     5
  DEFINE_FPS_MULT SHIP_DECEL_SPEED,     6 ; /4

  DEFINE_FPS_MULT BULLET_SPEED_X,       180 ; WARNING: >2 pixel/frame may break collision detection!
  DEFINE_FPS_MULT BULLET_SPEED_Y,       160 ; WARNING: >2 pixel/frame may break collision detection!
  DEFINE_FPS_DIV  BULLET_TIME,          60  ; bullet life time (1s, original ~1.25s, shorter due to less vertical space)

; Mine logic:
; Speed:       20..100 (factor = 5, linear)
; Turn chance: 31.. 93 (factor = 3, linear) -> wrap around more likely at high difficulty
; Kick chance:  4.. 1s (factor = 4, exponential)
;  DEFINE_FPS_MULT MIN_MINE_SPEED,       25
  DEFINE_FPS_MULT MIN_MINE_SPEED,       20
;  DEFINE_FPS_MULT MAX_MINE_SPEED,       120 ; = MAX_SHIP_SPEED
  DEFINE_FPS_MULT MAX_MINE_SPEED,       100;  = 80% MAX_SHIP_SPEED

  DEFINE_FPS_MULT MIN_MINE_TURN_SPEED,  31  ; 31% chance
  DEFINE_FPS_MULT MAX_MINE_TURN_SPEED,  93  ; 93% chance

  DEFINE_FPS_MULT MIN_MINE_KICK_CHANCE, 25  ; / 256     MAX = 100 (every ~4s..1s)
MINE_KICK_FACTOR    = 1189                  ; / 1000    1.189 = (100/25)^(1/8)

MIN_GUN_TURN_SPEED  = 250                   ; /100      2.5s (MAX = 0.5s) (do NOT FPS adjust these!)
GUN_TURN_FACTOR     = 1223                  ; /1000     1.223 = (2.5/0.5)^(1/8)
;GUN_TURN_FACTOR = 1208 ; no overflow in NTSC

; -----------------------------------------------------------------------------
; Macros (Part 1/2)
; -----------------------------------------------------------------------------

OVERLAY_SIZE SET 10

  MAC OVERLAY ; {name}
    SEG.U   OVERLAY_{1}
    ORG     Overlay
  ENDM

  ;--------------------------------------------------------------------------

  MAC CHECK_OVERLAY
    LIST OFF
    IF . - Overlay > OVERLAY_SIZE
      ECHO "ERROR: Overlay size to big!", "(", . - Overlay - OVERLAY_SIZE, "bytes)"
      ERR
    ENDIF
    LIST ON
  ENDM

; -----------------------------------------------------------------------------
; Game Variables
; -----------------------------------------------------------------------------

  SEG.U   VARS
  ORG     $80

; Game Variables
CYCLE         DS.B  1           ; Frame Counter
RANDOM        DS.B  1           ; Random Seed

DEBOUNCE      DS.B  1           ; 7 = Fire, 6 = Fire State, 5 = Pause, 4 = B&W State
                                ; 0 = Select, 1 = Joystick, 2 = 2600(1)/7800(0) Console
SELECT_FLAG   = 1<<0
JOY_FLAG      = 1<<1
CONSOLE_FLAG  = 1<<2
BW_FLAG       = 1<<4
PAUSE_FLAG    = 1<<5
BUTTON_FLAG   = 1<<6
BUTTON_BIT    = 1<<7            ; indicates a valid fire button press

COLMODE       DS.B  1           ; 0 = NTSC, 1 = PAL60, 2 = B&W
difficulty    DS.B  1           ; bit6+7 of SWCHB

castle        DS.B  1           ; 0-6 = castle
gameSpeed     DS.B  1           ; difficulty depending on score (0..15)
SHIPS         DS.B  1           ; 0-6 = Ships, 7 = Ship Explosion,

SCORE         DS.B  3           ; 3 Digit Score (BCD)

MODE          DS.B  1           ; 0-4 = Timer, 5-7 = Mode
                                ; 000 = Main Game
                                ; 001 = Get Ready
                                ; 010 = Score + Castle (on new castle)
                                ; 011 = Score + Ships (after death)
                                ; 100 = Game Over
                                ; 101 = Paused
                                ; 110 = ??
                                ; 111 = Explosion

; Sound Variables
sfxLst        DS.B  2           ; vvvfffff; v=volume/2, f=frequency
sfx0          = sfxLst+0
sfx1          = sfxLst+1
sirenFreqHi     .byte           ; current base frequency, modfied by itself
sirenFreqLo     .byte           ; added to sirenFreqSum, modified depending on sirenFreqHi
sirenFreqSum    .byte           ; overflow increases frequency by 1

sirenVolIdx     .byte           ; index into sinus volume table (0..15)
sirenVolIdxSum  .byte           ; depends on sirenFreqHi
sirenVolSum     .byte           ; overflow increases volume by 1

;saveAudC1       .byte           ; used to make space for siren

; Ship Variables
SHIPDIR_HI    DS.B  1           ; Ship Direction & Explosion Frame
SHIPDIR_LO    DS.B  1
SHIPX_HI      DS.B  1           ; Ship Coordinates (16-bit)
SHIPY_HI      DS.B  1
SHIPX_LO      DS.B  1
SHIPY_LO      DS.B  1
SHIPEXP_FRAME = SHIPDIR_LO
SHIPVX_HI     DS.B  1           ; Ship Velocity (16-bit)
SHIPVY_HI     DS.B  1
SHIPVX_LO     DS.B  1
SHIPVY_LO     DS.B  1
SHIPVDIR      DS.B  1           ; Ship Velocity Direction

; Bullet Variables
BULLETX_HI    DS.B  NUM_BULLETS ; Bullet Coordinates (16-bit)
BULLETY_HI    DS.B  NUM_BULLETS
BULLETX_LO    DS.B  NUM_BULLETS
BULLETY_LO    DS.B  NUM_BULLETS
BULLETDIR     DS.B  NUM_BULLETS ; Bullet Direction (0->31)
bulletTime    DS.B  NUM_BULLETS ; bullet life time

; Projectile
PROJX_HI      DS.B  1           ; Projectile Coordinates (16-bit)
PROJY_HI      DS.B  1
PROJX_LO      DS.B  1
PROJY_LO      DS.B  1
PROJDIR       DS.B  1           ; Projectile Direction (0->31) nx.ddddd
PROJFRAME     DS.B  1           ; Projectile Animation Frame (0->15)
projCol       DS.B  1           ; projectile color, used for hit sparks

; Flickersort Variables
MPOS          DS.B  1           ; Visible Mine (2 bit, 0-2)
BPOS          DS.B  1           ; Visible Bullet (1 bit)

; Mine Variables
MPHASE          DS.B  1         ; Mine Phase (2 bit, 0-2, current frame mine AI)
MINECOL         DS.B  NUM_MINES ; Mine Colour Cache

; Overlay variables
Overlay         ds OVERLAY_SIZE

; Temp Variables
TEMP            DS.B  1
TEMP2           DS.B  1

; Ring Variables
SECTORS         DS.B  1         ; 0-36 = Sector Counter; Bit7 = BREACH
ringDirs        DS.B  1         ; Ring Directions; Bits 5..7
ringSpeedIdx    DS.B  1
RINGCOUNTS      DS.B  NUM_RINGS ; Ring Rotation Delay Counters
RING0COUNT      = RINGCOUNTS
RING1COUNT      = RINGCOUNTS+1
RING2COUNT      = RINGCOUNTS+2

OFFSET0         DS.B  1         ; Ring Coordinate Offsets, Spaced 9
OFFSET1         DS.B  1         ;                          Spaced 7
OFFSET2         DS.B  1         ;                          Spaced 5


; Gun Variables
GUNDIR          DS.B  1         ; Gun Direction
GUNCOUNT        DS.B  1         ; Gun Movement Delay
gunExplodeDelay = GUNCOUNT      ; delay for each frame

MINEX_LO        DS.B    NUM_MINES
MINEX_HI        DS.B    NUM_MINES
MINEY_LO        DS.B    NUM_MINES
MINEY_HI        DS.B    NUM_MINES
MINECOUNT       DS.B    NUM_MINES
MINEDIR         DS.B    NUM_MINES   ; 0->4 = Direction/Sector, 5-7 = Mode
; old RAM+ names:
MINEX_LO_W      =   MINEX_LO
MINEX_HI_W      =   MINEX_HI
MINEY_LO_W      =   MINEY_LO
MINEY_HI_W      =   MINEY_HI
MINECOUNT_W     =   MINECOUNT
MINEDIR_W       =   MINEDIR
MINEX_LO_R      =   MINEX_LO
MINEX_HI_R      =   MINEX_HI
MINEY_LO_R      =   MINEY_LO
MINEY_HI_R      =   MINEY_HI
MINECOUNT_R     =   MINECOUNT
MINEDIR_R       =   MINEDIR

gunExplodeIdx   =   MINEX_LO    ; gun explosion frame index

RINGCOLS        DS.B  NUM_RINGS ; Ring Colours
RINGCOL0        =   RINGCOLS
RINGCOL1        =   RINGCOLS+1
RINGCOL2        =   RINGCOLS+2
 IF PHASED_REGEN
ringColX        .byte
offsetX         .byte
regenPhase      .byte
disableGunKill  .byte           ; gun kill is disabled not 0, prevents killing castle right at the start
 ENDIF
 IF OVERHEAT
overheat        .byte
 ENDIF

; task handling variables:
jmpVec          .word
jmpBank         .byte
taskBits        .byte           ; %km....bb
KERNEL_EXEC     = $80           ; k = kernel execution flag
KERNEL_MISSED   = $40           ; m = task loop skipped
;OVERFLOW_EXEC   = $40           ; o = overflow execution flag (TODO, for gun explosion)
BULLET_TASK     = %11           ; b = bullet to check
taskCycle       .byte
taskVars        ds 3            ; three variables which can be transferred to the next task(s)

BCLEAR          = taskVars      ; Sector to Clear & Score   (BulletRingCollisions -> CheckSectorClear)
SHIPANGLE       = taskVars+1    ; Ship Angle From Centre    (ShipCollisions -> MineLogic)

pRingDataLo     = taskVars      ; (RotateRingOdd? -> RotateRing?Even)
pRingPosLo      = taskVars+1    ; (RotateRingOdd? -> RotateRing?Even)
DOTTEDMASK      = taskVars+2    ; (RotateRingOdd? -> RotateRing?Even)

explodeGunId    = taskVars      ; (ExplodeGun0 -> ExplodeGun1)

 IF TEST_FRAME_SKIP
frameCycle      .byte
 ENDIF

  ; Display Remaining RAM
  echo "----",($100 - *) , "bytes left (RAM)"


; Kernel Variables (TEMP)
  OVERLAY Kernel
PPTR            DS.B  3     ; Player Sprite
PMASKPTR        DS.B  3     ; Player Mask
BPTR            DS.B  2     ; Ball Pointer
MPTR            DS.B  2     ; Missile Pointer
  CHECK_OVERLAY

  OVERLAY Siren
SIRENOFFSET     DS.B 1
  CHECK_OVERLAY

  OVERLAY Parameters        ; VectorAngle, CentreDistance, CollideRing
TEMPX           DS.B 1
tempXY          = TEMPX
TEMPY           DS.B 1
cxSector        = TEMPY
TEMPBX          DS.B 1
TEMPBY          DS.B 1
  CHECK_OVERLAY

NUM_PARAMS = . - Overlay

  OVERLAY ClearSector
dummy           DS.B NUM_PARAMS
COUNT           DS.B 1
TEMPMAP         DS.B 1
  CHECK_OVERLAY

  OVERLAY MineLogic
dummy           DS.B NUM_PARAMS
CURRSECTOR      DS.B 1
MINEANGLE       DS.B 1      ; Mine Angle From Center/Ship
  CHECK_OVERLAY

  OVERLAY CheckBullet
dummy           DS.B NUM_PARAMS
TEMPBPOS        DS.B 1
  CHECK_OVERLAY

; Rotation Pointers
  OVERLAY RotateRing
PRINGDATA       DS.B 2
PRINGPOS        DS.B 2
  CHECK_OVERLAY

; Explosion Pointers
  OVERLAY ExplopdeGun
EXP0            DS.B  2
EXP1            DS.B  2
EXP2            DS.B  2
  CHECK_OVERLAY

; Text Pointers
NPTR            EQU BULLETX_HI  ; 2
LPTR            EQU BULLETY_HI  ; 2
PTR5            EQU BULLETX_LO  ; 2
  OVERLAY Text
PTRLST          DS.B  2*5
PTR0            =   PTRLST + 2*0
PTR1            =   PTRLST + 2*1
PTR2            =   PTRLST + 2*2
PTR3            =   PTRLST + 2*3
PTR4            =   PTRLST + 2*4
;PTR5            = PTRLST + 2*5
  CHECK_OVERLAY

;--------------------------------------------------------------

; Title Screen Variables
SLOWCYCLE     EQU MODE
LOGOFG        EQU RINGCOL0
LOGOBG        EQU RINGCOL1
SPTR          EQU SECTORS       ; 2   Sound Effects Table Pointer
TPTR          EQU RING0COUNT    ; 2   Text Pointer
MESSAGE       EQU RING2COUNT
MTIMER        EQU RINGCOL2

; Title Music Variables
MEASURE       EQU SHIPX_HI
BEAT          EQU SHIPY_HI
TEMPOCOUNT    EQU SHIPX_LO
CHAN          EQU SHIPY_LO
TEMP16L       EQU SHIPDIR_HI
TEMP16H       EQU SHIPDIR_LO
FREQ          EQU SHIPVX_HI
ATTEN         EQU SHIPVY_HI
VOL0            = SHIPVX_LO
VOL1            = SHIPVY_LO
VOL_NOW         = SHIPVDIR

; High Score Table Variables
  OVERLAY HIGH_SCORE
SLPTR         ds.b 2        ; EQU LINE0     ; 2
SLLPTR        ds.b 2        ; EQU LINE1     ; 2
SLHPTR        ds.b 2        ; EQU LINE2     ; 2
HDPTR         ds.b 2        ; EQU LINE3     ; 2
  CHECK_OVERLAY
NAMECOL       EQU MINECOL   ; 3
HPOS          EQU PROJX_HI  ; 1
HROW          EQU PROJY_HI  ; 1

; HiScore Table Variables
HBUFF         EQU OFFSET0   ; (38)
HTEXT0        EQU HBUFF+0   ; HiScore Text
HTEXT1        EQU HBUFF+1
HTEXT2        EQU HBUFF+5
HTEXT3        EQU HBUFF+6
HTEXT4        EQU HBUFF+10
HTEXT5        EQU HBUFF+11
HTEXT6        EQU HBUFF+15
HTEXT7        EQU HBUFF+16
HTEXT8        EQU HBUFF+20
HTEXT9        EQU HBUFF+21
HTEXT10       EQU HBUFF+25
HTEXT11       EQU HBUFF+26
HTEXT12       EQU HBUFF+30
HTEXT13       EQU HBUFF+31

; Name Entry Variables
HPTR0         EQU HBUFF+0   ; 2
HPTR1         EQU HBUFF+2   ; 2
HPTR2         EQU HBUFF+4   ; 2
HPTR3         EQU HBUFF+6   ; 2
HPTR4         EQU HBUFF+8   ; 2
HPTR5         EQU HBUFF+10  ; 2
NAME          EQU HBUFF+31  ; 3
CURSOR        EQU HBUFF+34  ; 1
HSCORE        EQU HBUFF+35  ; 3

;------------------------------------------------------------------------------

  SEG.U RAM_REGISTERS_WRITE
  ORG RAM_BASE_WRITE_ADDRESS

XRAM_SIZE       = $100

  ; RAM+ Write Variables
RAM_W
HI_WRITE        ; highscore tables (6 * 10 * 4 = 240 bytes)

  ; Sector Map
SECTORMAP_W     DS.B    TOTAL_SECS  ; = 36
SECTORMAP0_W    = SECTORMAP_W + NUM_SECS*0  ; could be optimized to 3 bytes
SECTORMAP1_W    = SECTORMAP_W + NUM_SECS*1
SECTORMAP2_W    = SECTORMAP_W + NUM_SECS*2
  ; Grid
GRID_W          DS.B    YRINGS * 5  ; = 200
GRID_W0         = GRID_W+YRINGS * 0 ; 0..4, 35..39: never used, except for explosion
GRID_W1         = GRID_W+YRINGS * 1
GRID_W2         = GRID_W+YRINGS * 2
GRID_W3         = GRID_W+YRINGS * 3
GRID_W4         = GRID_W+YRINGS * 4 ; 0..4, 35..39: never used, except for explosion

GRID_D0         = GRID_W0 - GRID_W
GRID_D1         = GRID_W1 - GRID_W
GRID_D2         = GRID_W2 - GRID_W
GRID_D3         = GRID_W3 - GRID_W
GRID_D4         = GRID_W4 - GRID_W

sirenF0_W       .byte
sirenF1_W       .byte
sirenF2_W       .byte
sirenF3_W       .byte
 IF SONAR_DELTA
mineSfxSum_W    .byte
 ENDIF
; last 4 bytes unused by high score table (and not wiped!)
initials_W      = RAM_W + XRAM_SIZE - 4                     ; initials (2 bytes packed), permanently stored
COLMODE_W       = RAM_W + XRAM_SIZE - 2                     ; last but one byte
OPERATION_W     = RAM_BASE_WRITE_ADDRESS + XRAM_SIZE - 1    ; has to be last byte in page!

  ; Display Remaining RAM
  echo "----",((RAM_BASE_WRITE_ADDRESS + XRAM_SIZE) - * - 4) , "bytes left (RAM+)"

  SEG.U RAM_REGISTERS_READ
  ORG RAM_BASE_READ_ADDRESS

  ; RAM+ Read Variables
RAM_R           =   RAM_W + XRAM_SIZE
HI_READ         =   HI_WRITE + XRAM_SIZE

  ; Sector Map
SECTORMAP0_R    =   SECTORMAP0_W + XRAM_SIZE
SECTORMAP1_R    =   SECTORMAP1_W + XRAM_SIZE
SECTORMAP2_R    =   SECTORMAP2_W + XRAM_SIZE
  ; Grid
GRID_R          =   GRID_W + XRAM_SIZE
GRID_R0         =   GRID_W0 + XRAM_SIZE
GRID_R1         =   GRID_W1 + XRAM_SIZE
GRID_R2         =   GRID_W2 + XRAM_SIZE
GRID_R3         =   GRID_W3 + XRAM_SIZE
GRID_R4         =   GRID_W4 + XRAM_SIZE

sirenF0_R       =   sirenF0_W + XRAM_SIZE
sirenF1_R       =   sirenF1_W + XRAM_SIZE
sirenF2_R       =   sirenF2_W + XRAM_SIZE
sirenF3_R       =   sirenF3_W + XRAM_SIZE
 IF SONAR_DELTA
mineSfxSum_R    =   mineSfxSum_W + XRAM_SIZE
 ENDIF

initials_R      =   initials_W + XRAM_SIZE
COLMODE_R       =   COLMODE_W + XRAM_SIZE
ERRORCODE_R     =   OPERATION_W + XRAM_SIZE


; -----------------------------------------------------------------------------
; Macros
; -----------------------------------------------------------------------------

  MAC DEFINE_OVERDELAY
OVERDELAY = ((SCAN_LINES-VISIBLE_LINES)*76*3/8+32)/64 - 1 + {1}
  ENDM

  ; Start Vertical Blank Macro
  MAC _BEGIN_VBLANK
; return: A = 0, C = 1
.WaitOverscan
  lda INTIM
  bne .WaitOverscan
  lda #%00001110
.SyncLoop
  sta WSYNC
  sta VSYNC
  lsr
  bne .SyncLoop
  ldx #{1}
  stx TIM64T
  ENDM

  ; Start Vertical Blank Macro (main game loop)
  MAC BEGIN_VBLANK
    _BEGIN_VBLANK VBLANKDELAY
  ENDM

  ; Start Vertical Blank Macro (outside main game loop)
  MAC BEGIN_VBLANK_MSG
    _BEGIN_VBLANK (VBLANKDELAY+KERNEL_DELAY)
  ENDM

  ; Start Frame Macro
  MAC BEGIN_FRAME
.WaitVblank
  lda INTIM
  bne .WaitVblank
  sta VBLANK
  sta WSYNC
  lda #FRAMEDELAY
  sta TIM64T
  ENDM

  ; Start Overscan Macro
  MAC BEGIN_OVERSCAN
.WaitFrame
  lda INTIM
  bne .WaitFrame
  lda #2
  sta WSYNC
  sta VBLANK
  lda #OVERDELAY
  sta TIM64T
  ENDM

  MAC NOP_B
    .byte   $82 ; 2 bytes, 2 cycles
  ENDM

  MAC NOP_ZP
    .byte   $04 ; 2 bytes, 3 cycles
  ENDM

  MAC NOP_W
    .byte   $0c ; 3 bytes, 4 cycles
  ENDM

  MAC DEBUG_BRK
    IF DEBUG
      brk                         ;
    ENDIF
  ENDM

  ; Timer Based Abortion Macros
  ; Usage:
  ; - {1} = ceiling (required cycles/64)
  ; - {2} = where to continue if check fails
  ;         jump to the next check with smaller {1}
  MAC CHECK_TIM
    lda INTIM           ; [0] + 4
    cmp #{1} + 1        ; [4] + 2
    bmi {2}             ; [6] + 2/3 = 8
  ENDM

  MAC CHECK_TIM_JMP
    lda INTIM           ; [0] + 4
    cmp #{1} + 1        ; [4] + 2
    bpl .ok             ; [6] + 2/3 = 9
    jmp {2}             ; [8] + 3
.ok
  ENDM

  ; Timer Based Abortion Macros (these stress the timer for debugging)
  MAC XCHECK_TIM
.stress
    lda INTIM           ; [0] + 4
    cmp #{1} + 1        ; [4] + 2
    bpl .stress         ; [6] + 2/3
    cmp #{1}            ; [8] + 2
    bmi {2}             ; [10] + 2/3 = 12
    echo "WARNING @" , ": XCHECK_TIM enabled!"
  ENDM

  MAC XCHECK_TIM_JMP
.stress
    lda INTIM           ; [0] + 4
    cmp #{1} + 1        ; [4] + 2
    bpl .stress         ; [6] + 2/2
    cmp #{1}            ; [8] + 2
    bpl .ok             ; [10] + 2/3 = 13
    jmp {2}             ; [12] + 3
.ok
    echo "WARNING @" , ": XCHECK_TIM enabled!"
  ENDM


  ; Page Crossing Macros
  MAC PAGE_WARN
   LIST OFF
   IF (>{1} < >(.-1)) | (>{1} > >.)
    echo "WARNING @", ., ":", {2}, "crosses a page boundary!"
   ENDIF
   LIST ON
  ENDM

  MAC PAGE_WARN_1
   LIST OFF
   IF (>{1} < >(.-1)) | (>{1} > >.)
    echo "WARNING @", ., ":", {2}, "crosses a page boundary!", {3}
   ENDIF
   LIST ON
  ENDM

  MAC PAGE_WARN_12
   LIST OFF
   IF (>{1} < >(.-1)) | (>{1} > >.)
    echo "WARNING @", ., ":", {2}, "crosses a page boundary!", {3}, {4}
   ENDIF
   LIST ON
  ENDM

  MAC PAGE_ERROR
   LIST OFF
   IF (>{1} < >(.-1)) | (>{1} > >.)
    echo "ERROR @", ., ":", {2}, "crosses a page boundary!"
    err
   ENDIF
   LIST ON
  ENDM

  MAC BRANCH_PAGE_ERROR
   LIST OFF
   IF (>{1} < >.) | (>{1} > >.)
    echo "ERROR @", ., ":", {2}, "crosses a page boundary!"
    err
   ENDIF
   LIST ON
  ENDM


  ; Free Space Macros
FREE_TOTAL SET 0

  MAC BANK_FREE
   LIST OFF
FREE_BANK SET 0
   IF ECHO_FREE
    echo "*****", {1}, "*****"
   ENDIF
   LIST ON
  ENDM

  MAC ALIGN_FREE_LBL
   LIST OFF
FREE_GAP SET -.
    ALIGN {1}
FREE_GAP SET FREE_GAP + .
FREE_BANK SET FREE_BANK + FREE_GAP
FREE_TOTAL SET FREE_TOTAL + FREE_GAP
   IF ECHO_FREE && FREE_GAP > 0
     echo "@", ., "; Gap:", [FREE_GAP]d, "; Bank:", [FREE_BANK]d, "; Total:", [FREE_TOTAL]d, " ", {2}
   ENDIF
   LIST ON
  ENDM

  MAC ALIGN_FREE
    ALIGN_FREE_LBL {1}, ""
  ENDM

  MAC RORG_FREE
   LIST OFF
FREE_GAP SET - .
    RORG {1}
FREE_GAP SET FREE_GAP + {1}
FREE_BANK SET FREE_BANK + FREE_GAP
FREE_TOTAL SET FREE_TOTAL + FREE_GAP
   IF ECHO_FREE && FREE_GAP > 0
    echo "@", ., "; Gap:", [FREE_GAP]d, "; Bank:", [FREE_BANK]d, "; Total:", [FREE_TOTAL]d
   ENDIF
   LIST ON
  ENDM

;  ; Play Sound Macro
;  MAC START_SFX
;  lda #{1}                  ; [0] + 2
;  cmp SFX                   ; [2] + 3
;  bcc .skip                 ; [5] + 2/3
;  sta SFX                   ; [7] + 3
;.skip                       ;           = 10
;  ENDM

BANK_SIZE = $1000
_ORG SET -BANK_SIZE
_RORG SET -BANK_SIZE

  MAC START_BANK ; bank name
_ORG SET _ORG + BANK_SIZE
_RORG SET _RORG + BANK_SIZE*2
    SEG     {1}
    ORG     _ORG
    RORG    _RORG
_CURRENT_BANK SET _ORG / BANK_SIZE

    BANK_FREE {1}

    ; Space for RAM+
    DS.B    $200, "#"
  ENDM

  MAC END_START_BANK
   LIST ON
    ORG     _ORG + $FF4
    RORG_FREE _RORG + $FF4
    DC.B    "BANK", $30+_CURRENT_BANK, 0, 0, 0
  ENDM

  MAC END_BANK
   LIST OFF
    END_START_BANK {}
    DC.W    Init{1}, Init{1}
  ENDM


  MAC TASK_VECTORS ; bank
   LIST ON
Init{1}
    nop     BANK6           ;               on init switch to bank 6
;------------------------------
JmpToTasks = . & $1fff
    sta     jmpVec          ; [9] + 3
    sty     jmpVec+1        ; [12] + 3
ContToTasks = . & $1fff
    nop     HOTSPOTS,x      ; [15] + 4
    jmp     (jmpVec)        ; [19] + 5 = 24
;------------------------------
AbortTasks = . & $1fff
    nop     BANK0           ; [11] + 4 = 15
  ENDM ; 16 bytes

  MAC FIRST_TASK_VECTORS ; bank
   LIST OFF
    TASK_VECTORS {1}        ; [15] + 7
    rts                     ; [22] + 6 = 28
  ENDM ; 17 bytes


  MAC DEFINE_SUBROUTINE ; name
; Note: SUBROUTINE has no effect inside macros!
{1} ;SUBROUTINE
{1}_BANK SET _CURRENT_BANK
  ENDM

  MAC GET_JMPVEC ; label
   LIST ON
    lda #<{1}               ; [0] + 2
    ldy #>{1}               ; [2] + 2 = 4
  ENDM


  MAC GET_BANK_JMPVEC ; label
   LIST OFF
    GET_JMPVEC {1}          ; [0] + 4
    ldx #{1}_BANK           ; [4] + 2 = 6
  ENDM


  MAC JMP_TO_BANK ; label
   LIST OFF
; {1}_JUMP SET .
   IFNCONST {1}_BANK
{1}_BANK SET 255
   ENDIF
    GET_BANK_JMPVEC {1}     ; [0] + 6
    jmp JmpToTasks          ; [6] + 18 = 24
  ENDM


; *** Macros for tasks which control: ***
; - task skipping
; - task timeing
; - task reentrance (after aborting)
; - next task

NO_SKIP = %00
SKIP_1  = %01
SKIP_3  = %11

FIRST_TASK = 0  ; Joystick
;FIRST_TASK = 1  ; MoveSprites

  MAC _START_TASK ; label, timer, cycle, next task, stress timer
    DEFINE_SUBROUTINE {1}
_TASK_NAME SET {1}

{1}_NEXT_TASK = {4}
   IFNCONST {4}_BANK
{4}_BANK SET 255
   ENDIF
{1}_NEXT_TASK_BANK SET {4}_BANK
{1}_SKIP SET {3}

   LIST OFF
; handle task skip by frame (part 1/2):
  IF {3} != NO_SKIP
   LIST ON
    lda taskCycle           ; [0] + 3   TODO: odd/even spreading
    and #{3}                ; [3] + 2
    bne {1}_Exit            ; [5] + 2/3 = 7/8
   LIST OFF
  ENDIF
; handle task abortion due to timer:
  IF {5} != 0
   LIST ON
.stress
    lda INTIM               ; [0] + 4
    cmp #{2} + 1            ; [4] + 2
    bpl .stress             ; [6] + 2/2
    cmp #{2}                ; [8] + 2
    bpl .exec_{1}           ; [10] + 2/3
   LIST OFF
  ELSE
   LIST ON
    lda INTIM               ; [0] + 4
    cmp #{2}+1              ; [4] + 2
    bpl .exec_{1}           ; [6] + 2/3
   LIST OFF
  ENDIF
   LIST ON
    jmp AbortTasks          ; [8] + 3 = 11
   LIST OFF
; handle task skip by frame (part 2/2):
  IF {3} != NO_SKIP
{1}_TASK_EXIT SET .
   LIST ON
{1}_Exit
   LIST OFF
    JMP_TO_BANK {4}         ; [8] + 3/24
  ENDIF
   LIST ON
.exec_{1}                   ; [9/16]
   LIST OFF
  ENDIF
  ENDM
; exec: 9/16; skip: 11/32; abort: 36

  MAC START_TASK ; label, timer, cycle, next task
   LIST OFF
; normal task
    _START_TASK {1}, {2}, {3}, {4}, 0
   LIST ON
  ENDM

  MAC XSTART_TASK ; label, timer, cycle, next task
   LIST OFF
; task with timer stress
    echo "DEBUG @", ., ":", "Stressed timer used!"
    _START_TASK {1}, {2}, {3}, {4}, 1
   LIST ON
  ENDM


  MAC END_TASK ; label
   LIST OFF
;   IF {1}_TASK_EXIT > 0
  IF ({1}_SKIP != NO_SKIP) && (_CURRENT_BANK = {1}_BANK)
   LIST ON
    jmp {1}_Exit
   LIST OFF
  ELSE
   LIST ON
{1}_TASK_EXIT SET .
    JMP_TO_BANK {1}_NEXT_TASK ; [0] + 3/21
   LIST OFF
  ENDIF
   LIST ON
;  IF {1}_NEXT_TASK = .
;    ECHO "WARNING @", . , ": Superfluous (END_TASK)_JMP"
;  ENDIF
  ENDM

  MAC XEND_TASK ; label
    lda INTIM
    cmp #2
    bcs .ok
    lda #$40
    sta COLUBK
.ok
    END_TASK {1}
  ENDM


  MAC EXIT_TASK ; label
    jmp {1}_TASK_EXIT
  ENDM

  MAC EXIT_TO_TASK ; next task
   LIST OFF
    JMP_TO_BANK {1}     ; [0] + 3/24
  ENDM

  MAC LOOP_TASK
    ldx #{1}_BANK
    jmp {1}
  ENDM


; -----------------------------------------------------------------------------
; Macros for speeds depending on angle and game speed
; -----------------------------------------------------------------------------

_MULT           = 256*32

SIN_0   =   _MULT
SIN_1   =   _MULT*981/1000
SIN_2   =   _MULT*924/1000
SIN_3   =   _MULT*831/1000
SIN_4   =   _MULT*707/1000
SIN_5   =   _MULT*556/1000
SIN_6   =   _MULT*383/1000
SIN_7   =   _MULT*195/1000
SIN_8   =   0
SIN_9   =  -SIN_7
SIN_10  =  -SIN_6
SIN_11  =  -SIN_5
SIN_12  =  -SIN_4
SIN_13  =  -SIN_3
SIN_14  =  -SIN_2
SIN_15  =  -SIN_1
SIN_16  =  -SIN_0

  MAC INIT_SPEEDS
_MIN_SPEED  SET (256*256 * {1} + SPEED_MULT/2) / SPEED_MULT
_MAX_SPEED  SET (256*256 * {2} + SPEED_MULT/2) / SPEED_MULT
   IF _MAX_SPEED > 0
_D_SPEED    SET (_MAX_SPEED - _MIN_SPEED + {3}/2)/({3}-1)
   ELSE
_D_SPEED    SET 0
   ENDIF
  ENDM

  MAC SPEED_LO
   IF SIN_{2} < 0
_RND SET -128
   ELSE
_RND SET 128
   ENDIF
_VAL SET ((_MIN_SPEED+_D_SPEED*{1})*SIN_{2}/_MULT+_RND)/256
    LIST ON
    .byte <_VAL
    LIST OFF
  ENDM

  MAC SPEED_HI
   IF SIN_{2} < 0
_RND SET -128
   ELSE
_RND SET 128
   ENDIF
_VAL SET ((_MIN_SPEED+_D_SPEED*{1})*SIN_{2}/_MULT+_RND)/256
    LIST ON
    .byte >_VAL
    LIST OFF
  ENDM

SPEEDS_8_1      = %1        ; 8 values  (x-speeds, for overlapping with 0_1)
SPEEDS_0_15     = %10       ; 16 values (y-speeds)
SPEEDS_0_16     = %100      ; 16 values (y-speeds, skips 8)
SPEEDS_8_9      = %1000     ; 32 values (x-speeds)
SPEEDS_0_1      = %10000    ; 32 values (y-speeds)

  MAC DEF_SPEEDS
   IF ({3} & (SPEEDS_8_1|SPEEDS_8_9)) != 0
    SPEED_{1} {2}, 8
    SPEED_{1} {2}, 7
    SPEED_{1} {2}, 6
    SPEED_{1} {2}, 5
    SPEED_{1} {2}, 4
    SPEED_{1} {2}, 3
    SPEED_{1} {2}, 2
    SPEED_{1} {2}, 1
   ENDIF
  IF ({3} & (SPEEDS_0_15|SPEEDS_0_16|SPEEDS_8_9|SPEEDS_0_1)) != 0
    SPEED_{1} {2}, 0
    SPEED_{1} {2}, 1
    SPEED_{1} {2}, 2
    SPEED_{1} {2}, 3
    SPEED_{1} {2}, 4
    SPEED_{1} {2}, 5
    SPEED_{1} {2}, 6
    SPEED_{1} {2}, 7
   IF ({3} & SPEEDS_0_16) = 0
    SPEED_{1} {2}, 8
   ENDIF
    SPEED_{1} {2}, 9
    SPEED_{1} {2}, 10
    SPEED_{1} {2}, 11
    SPEED_{1} {2}, 12
    SPEED_{1} {2}, 13
    SPEED_{1} {2}, 14
    SPEED_{1} {2}, 15
   IF ({3} & (SPEEDS_0_16)) != 0
    SPEED_{1} {2}, 16
   ENDIF
  ENDIF
   IF ({3} & (SPEEDS_8_9|SPEEDS_0_1)) != 0
    SPEED_{1} {2}, 16
    SPEED_{1} {2}, 15
    SPEED_{1} {2}, 14
    SPEED_{1} {2}, 13
    SPEED_{1} {2}, 12
    SPEED_{1} {2}, 11
    SPEED_{1} {2}, 10
    SPEED_{1} {2}, 9
   ENDIF
   IF ({3} & (SPEEDS_0_1)) != 0
    SPEED_{1} {2}, 8
    SPEED_{1} {2}, 7
    SPEED_{1} {2}, 6
    SPEED_{1} {2}, 5
    SPEED_{1} {2}, 4
    SPEED_{1} {2}, 3
    SPEED_{1} {2}, 2
    SPEED_{1} {2}, 1
   ENDIF
    LIST ON
  ENDM


  ; Game Data
  INCLUDE "startitle.h"
  INCLUDE "starsprites.h"
  INCLUDE "starexplosion.h"
  INCLUDE "starmusic.h"
  INCLUDE "stars.h"

; -----------------------------------------------------------------------------
; BANKS 0-5
; -----------------------------------------------------------------------------

; BANK 0 FFF5 - GAME LOGIC (VSync + VBlank, $a5 -> $173 bytes)
; BANK 1 FFF6 - COLLISION DETECTION (VBlank, $149 -> $a3 bytes)
; BANK 2 FFF7 - GAME KERNEL (VBlank + Kernel, $8b -> $1ac bytes)
; BANK 3 FFF8 - RING ROTATION (OverScan, $82 -> $1b0 bytes)
; BANK 4 FFF9 - EXPLOSIONS & GUN FRAMES (OverScan, $f9 -> $de bytes)
; BANK 5 FFFA - TITLE & MUSIC ($164 -> $17d bytes)
; BANK 6 FFFB - STARTUP & HISCORES ($fd -> $11a bytes)

  INCLUDE bank0.asm
  INCLUDE bank1.asm
  INCLUDE bank2.asm
  INCLUDE bank3.asm
  INCLUDE bank4.asm
  INCLUDE bank5.asm
  INCLUDE bank6.asm

; -----------------------------------------------------------------------------
; Total: 36*64 + 27*64 = 2304 + 1728
; Old task order:
; - Joystick [295]
; - MoveSprites [314]
; - ShipCollisions [~409] (->ExplodeGun0)
; - BulletMineCollisions
; - BulletRingCollisions (->ExplodeGun0)
; - MineRingCollisions
; - MoveMines -> Bank 3
; - GunLogic -> Bank 3
; - MineLogic -> Bank 3
; - CheckSectorClear (->CheckRingGap)
; - CheckRegenerate (->RotateRing0Odd)
; - CheckRingGap (->RotateRing0Odd) -> Bank 2
; - RotateRing?Odd
; - RotateRing?Even
; - DrawGun (->Joystick)
; - ExplodeGun0 [1505]
; - ExplodeGun1 [1061] (->Joystick)

; New task order for three bullets, DONE:
; - Joystick [295]
; - MoveSprites [314]
; - ShipCollisions [~409] (->ExplodeGun0)
; - BulletMineCollisions
; - BulletRingCollisions (->ExplodeGun0)
; - CheckSectorClear (DONE->BulletRingCollisions)
; - MineRingCollisions
; - MoveMines
; - HandleGun (logic and draw)
; - MineLogic
; - CheckRegenerate (every frame, remove loop, skip CheckRingGap when regenerating)
; - CheckRingGap
; - RotateRing?Odd
; - RotateRing?Even (->Joystick)
; - ExplodeGun0 [1505]
; - ExplodeGun1 [1061] (->Joystick)



