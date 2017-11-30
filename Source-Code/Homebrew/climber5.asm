   LIST OFF                         ; don't print the header file equates or 
                                    ; comments in the list file
; Climber 5
; Copyright 2003/2004 Dennis Debro
;
; dasm source.s -f3 -osource.bin to compile
;
; Tested with Z26, Atari7800, Atari2600 (4-switch) via Cuttle Cart
;
; *** 108 BYTES OF RAM USED 20 BYTES FREE
; *** 45 BYTES OF ROM FREE
;
; This game displays 200 scan lines for the main kernel. The vertical blank
; and overscan time was adjusted to compensate for this.
;
   processor 6502
   include vcs.h
   include macro.h
   
   LIST ON
   
;============================================================================
; A S S E M B L E R - S W I T C H E S
;============================================================================

NTSC                    = 0
PAL                     = 1

COMPILE_VERSION         = NTSC      ; change this to compile for different
                                    ; regions -- this changes colors and
                                    ; display timing
                                    ; (NTSC 60 fps & PAL 50 fps)
CHEAT_ENABLED           = 0         ; change to 1 to enable no-defeat mode

;============================================================================
; T I A - C O N S T A N T S
;============================================================================

HMOVE_L7                = $70
HMOVE_L6                = $60
HMOVE_L5                = $50
HMOVE_L4                = $40
HMOVE_L3                = $30
HMOVE_L2                = $20
HMOVE_L1                = $10
HMOVE_0                 = $00
HMOVE_R1                = $F0
HMOVE_R2                = $E0
HMOVE_R3                = $D0
HMOVE_R4                = $C0
HMOVE_R5                = $B0
HMOVE_R6                = $A0
HMOVE_R7                = $90
HMOVE_R8                = $80

BM_SIZE_2               = %010000

DISABLE_BM              = %00
ENABLE_BM               = %10

; values for REFPx:
NO_REFLECT              = %0000
REFLECT                 = %1000

; values for NUSIZx:
ONE_COPY                = %000
TWO_COPIES              = %001
TWO_MED_COPIES          = %010
THREE_COPIES            = %011
TWO_WIDE_COPIES         = %100
DOUBLE_SIZE             = %101
THREE_MED_COPIES        = %110
QUAD_SIZE               = %111

BW_MASK                 = %00001000 ; mask for SWCHB to get the B&W value

VERTICAL_DELAY          = 1

;============================================================================
; U S E R - C O N S T A N T S
;============================================================================

NUMGRP                  = 7         ; number of graphics/platform levels
GRPHEIGHT               = 20        ; height of each girder
CLIMBER_HEIGHT          = 18        ; height of the climber
OBSTACLE_HEIGHT         = 9
LADDER_SECTION_HEIGHT   = GRPHEIGHT + 4  ; height of each ladder section
MAXSELECTLEVEL          = 2         ; maximum possible selected level

KERNEL_HEIGHT           = NUMGRP * LADDER_SECTION_HEIGHT

NUM_OBSTACLES           = 6         ; maximum number of obstacles

XMIN                    = 3         ; minimum x value for players
XMAX                    = 149       ; maximum x value for players

CLIMBER_XMIN            = XMIN      ; minimum x value for climber
CLIMBER_XMAX            = XMAX - 4

BALL_XMIN               = XMIN + 6  ; minimum x value for the ball
BALL_STARTING_PLATFORM  = 147       ; starting scanline for the ball

YMIN                    = CLIMBER_HEIGHT    ; minimum y value for players 
YMAX                    = KERNEL_HEIGHT - 6 ; maximum y value for players

LEFT_PF_BOUND           = 7         ; min horizontal position boundary for PF
RIGHT_PF_BOUND          = 135       ; max horizontal postion boundary for PF

SELECT_DELAY            = $3F       ; delay count for select button
                                    ; (updates ~ every second)
BONUS_TIMER_DELAY       = $7F

TIMER_PENALTY           = $05       ; reduction penalty for fire button
TIMER_REDUCTION         = $01       ; timer reduced ~ every 2 seconds

GAME_SOUND_VOLUME       = $A6       ; volume for game sounds

STARTING_LIVES          = $02       ; DO NOT CHANGE
                                    ; number of lives to start
                                    ; this is also used to make multiple
                                    ; COPIES of GRP0 for the player
                                    ; indicator display
BALL_START_TIMER        = 12

CLIMBER_X_START         = CLIMBER_XMAX ; horizontal postion to start the
                                    ; climber
CLIMBER_Y_START         = YMIN      ; vertical position to start the climber

GIRDER_GRAPHIC          = %00000010 ; graphic data for the girders (STATIC)

MAX_LEVEL               = $04       ; max number for speed look up

LEVEL_MAX_OUT           = $99       ; highest level player can achieve

STARTING_LEVEL          = $01       ; level to start the game

FAIR_PIXEL_DELTA        = 27

FAIR_OBSTACLE_DISTANCE  = 9         ; distance between climber and obstacle

FAIR_WARNING_TICK       = 15        ; number of moves before girders warn of
                                    ; direction change (enhanced mode)

RESERVE_LIVES_HEIGHT    = 9         ; the height of the lives indicators

STARTING_TIMER_BONUS    = $50

STARTING_SPAWN_TIME     = 128       ; starting time to spawn another obstacle

MAX_BONUS_ITEMS         = 4         ; maximum number of bonus items

;----------------------------------------------------------------------------
; ladder graphic values
;
EVEN_LADDER_PF1         = %11000000
EVEN_LADDER_PF2         = %00001100

ODD_LADDER_PF1          = %00000110
ODD_LADDER_PF2          = %10000000

;----------------------------------------------------------------------------
; region frame time values
;
   IF COMPILE_VERSION = NTSC
   
VBLANK_TIME             = $26       ; ((33 scanlines * 76 cycles) - 14) / 64
OVERSCAN_TIME           = $1F       ; ((26 scanlines * 76 cycles) - 14) / 64

   ELSE

;----------------------------------------------------------------------------
; PAL frame constants
;
VBLANK_TIME             = $45       ; ((59 scanlines * 76 cycles) - 14) / 64
OVERSCAN_TIME           = $3B       ; ((50 scanlines * 76 cycles) - 14) / 64

   ENDIF

;----------------------------------------------------------------------------
; game state options
;
GAMERUNNING             = %00000000
TITLESCREEN             = %10000000
GAMEPAUSED              = %01000000
GAME_OVER_STATE         = %00000010
START_NEW_GAME          = %00000001

ORIGINAL_MODE           = %00000010
NORMAL_MODE             = %00000001
ADVANCE_OPTION          = %00000000

;----------------------------------------------------------------------------
; game speed
;

   IF COMPILE_VERSION = PAL
;
; NOTE: NTSC valus are ~17% SLOWER than PAL
;
LEVEL_1_SPEED           = $3D-1     ; 1 pixel/5 frames
LEVEL_2_SPEED           = $4C-1     ; 1 pixel/4 frames
LEVEL_3_SPEED           = $66-1     ; 1 pixel/3 frames
LEVEL_4_SPEED           = $99-1     ; 1 pixel/2 frames

   ELSE

LEVEL_1_SPEED           = $33-1     ; 1 pixel/5 frames
LEVEL_2_SPEED           = $40-1     ; 1 pixel/4 frames
LEVEL_3_SPEED           = $55-1     ; 1 pixel/3 frames
LEVEL_4_SPEED           = $80-1     ; 1 pixel/2 frames

   ENDIF
   
;----------------------------------------------------------------------------
; color constants
;
MAX_COLOR_ENTRY         = MAX_LEVEL

BLACK                   = $00       ; RGB = 000000
WHITE                   = $0F       ; RGB = ECECEC
GREY                    = $05
BALL_COLOR              = WHITE

   IF COMPILE_VERSION = NTSC
   
LADDER_COLOR            = $99       ; RGB = 6888CC
LTBLUE                  = $78       ; RGB = 7C70D0
LTBLUE_PURPLE           = $7B       ; RGB = 9488E0
GIRDER_COLOR            = $5C       ; RGB = DC9CD0
BLUE                    = $86       ; RGB = 505CC0
PEACH                   = $3C       ; RGB = ECA890
DARK_PURPLE             = $60       ; RGB = 480078
PURPLE                  = $64       ; RGB = 783CA4
GREEN                   = $DF       ; RGB = C8FCA4
PALE_GREEN              = $BB       ; RGB = 7CD0AC
GREEN_BLUE              = $B2       ; RGB = 1C5C48
RED                     = $40       ; RGB = 880000
LTORANGE                = $2F       ; RGB = ECC878
PINK                    = $3F       ; RGB = FCBC94
SKY_BLUE                = $98       ; RGB = 6888CC
WOOD_BROWN              = $24       ; RGB = 985C28
BROWN                   = $28       ; RGB = BC8C4C
ATARI_AGE_BLUE          = $82       ; RGB = 1C209C

   ELSE

LADDER_COLOR            = $B8       ; RGB = 6888C8
LTBLUE                  = $BA       ; RGB = 7CA0DC
LTBLUE_PURPLE           = $A6       ; RGB = 9458B4
GIRDER_COLOR            = $8C       ; RGB = D09CD0
BLUE                    = $B6       ; RGB = 5074B4
PEACH                   = $4C       ; RGB = ECC09C
DARK_PURPLE             = $C0       ; RGB = 3C0080
PURPLE                  = $C4       ; RGB = 6C3CA8
GREEN                   = $3E       ; RGB = D4FCB0
PALE_GREEN              = $52       ; RGB = 208034
GREEN_BLUE              = $50       ; RGB = 006414
RED                     = $64       ; RGB = A03C50
LTORANGE                = $2C       ; RGB = ECD09C
PINK                    = $6E       ; RGB = FCB0C8
SKY_BLUE                = $B8       ; RGB = 6888C8
WOOD_BROWN              = $20       ; RGB = 805800
BROWN                   = $24       ; RGB = A8843C
ATARI_AGE_BLUE          = $D2       ; RGB = 20209C

   ENDIF

;----------------------------------------------------------------------------
; joystick mask values
;
DOWN_MOTION_MASK        = %00100000
UP_MOTION_MASK          = %00010000

;----------------------------------------------------------------------------
; font heights
;
AA_FONT_HEIGHT          = 15
PRESENTS_FONT_HEIGHT    = 8
CLIMBER_FONT_HEIGHT     = 32
NUMBER_5_HEIGHT         = 12
COPYRIGHT_HEIGHT        = 8
TEXT_HEIGHT             = 5
GAME_TEXT_HEIGHT        = 5

RAND_EOR_8              = $B2

;----------------------------------------------------------------------------
; bit equates
;
D7                      = %10000000
D6                      = %01000000
D5                      = %00100000
D4                      = %00010000
D3                      = %00001000
D2                      = %00000100
D1                      = %00000010
D0                      = %00000001

;============================================================================
; M A C R O S
;============================================================================

   MAC NOP_W
      .byte $2C
   ENDM
   
   MAC BIT_B
      .byte $24
   ENDM
   
  MAC CHECKPAGE
    IF >. != >{1}
      ECHO ""
      ECHO "ERROR: different pages! (", {1}, ",", ., ")"
      ECHO ""
      ERR
    ENDIF
  ENDM

;
; boundary macro
;
; This is used to push data to certain areas of the ROM. It fills the
; unused bytes with zeros. It also tracks the number of ROM bytes available
; by using FREE_BYTES.
;
FREE_BYTES SET 0   
   MAC BOUNDARY
      REPEAT 256
         IF <. % {1} = 0
            MEXIT
         ELSE
FREE_BYTES SET FREE_BYTES + 1
            .byte $00
         ENDIF
      REPEND
   ENDM
   
;
; time wasting macros
;
; These were suggested by Manuel Rotschkar as a way to save a few ROM bytes.
; The regular SLEEP macro would use 4 bytes to wait 7 cycles and 5 bytes to
; wait 9 cycles.
;
   MAC SLEEP_7
      pha
      pla
   ENDM
   
   MAC SLEEP_9
      SLEEP_7
      SLEEP 2
   ENDM
   
;============================================================================
; Z P - V A R I A B L E S
;============================================================================
   SEG.U variables
   org $80
   
; There is only 128 bytes of RAM available to the programmer. Locations
; $80 - $FF are available for RAM use.
;

random               ds 1           ; holds a random number
gameSelection        ds 1           ; game variation selected

lives                ds 1           ; number of lives available to the player
platformColor        ds 1           ; can be manipulated for NTSC or PAL

obstacleType         ds 1           ; type of obstacle shown
attractMode          ds 1           ; this timer is updated each 255th frame
                                    ; once D7 goes high ($80) the screen
                                    ; display is suppressed
horPosP0             ds NUMGRP      ; array of horizontal positions for the
                                    ; girders
gameState            ds 1           ; current game state (see the game
                                    ; state options constants for valid
                                    ; values)
score                ds 2           ; score in BCD (last 2 digits always 0)
selectDebounce       ds 1           ; debounce flag for the select switch             
backgroundColor      ds 1           ; these colors are stored in RAM so they
girderGraphics       ds NUMGRP      ; stored in RAM so the training option
                                    ; can show random girders
startCount           ds NUMGRP      ; count down for girder movement
girderDirection      = startCount   ; also used for girder direction in
                                    ; enhanced mode

;-----------------
; DO NOT MOVE THESE VARIABLES...
; these are placed in this order to conserve ROM bytes in the level init
; routine and the player horizontal movement routine
;
allowedMotion        ds 1           ; allowed movements for the climber
                                    ; basically mimics SWCHA but restricts
                                    ; the climber to walk based on world
                                    ; constraints :)
bonusItemCount       ds 1
bonusTimer           ds 1           ; timer bonus in BCD (last 2 digits
                                    ; always 0)
ballTimer            ds 1           ; timer for ball movement
horPosObstacle       ds 1           ; horizontal postion of the obstacle
horPosP1             ds 1           ; horizontal position of climber
verPosP1             ds 1           ; vertical position of climber
gameClock            ds 1           ; update periodically based on climber
                                    ; speed
horPosBL             ds 1           ; horizontal postion of the ball

playerState          ds 1           ; collision state of the climber
frameCount           ds 1           ; updated each frame
playerMotion         ds 1           ; speed of girders
climberMotion        ds 1           ; speed of climber
verPosObstacle       ds 1           ; vertical position of the obstacle
;----------------------

showBonusOrScore     ds 1
verPosBL             ds 1           ; ranges from 0 to 7
girderSpeedIndex     ds 1           ; speed index for lookup table
levelBCD             ds 1           ; level number in BCD
playerReflect        ds 1           ; holds the reflect value for the climber
                                    ; (this could've been used in playerState
                                    ; to save a RAM byte)
temp                 ds 1           ; temporary variable for various things
fireButtonDebounce   ds 1           ; debounce flag for the fire button
                                    ; (used for starting a new game)
soundCounter         ds 1           ; used to play the success and death
soundIndex           ds 1           ; sounds
fireSoundIndex       ds 1           ; used to play the sound for reversing
                                    ; girder movement
playerPointer        ds 2           ; pointer to the player graphics
playerColorPointer   ds 2           ; pointer to the player colors
obstaclePointer      ds 2           ; pointer to the obstacle graphics
duration             ds 1           ; used for success and death sounds
walkingSoundIndex    ds 1           ; index for climber walking sound
startSWCHB           ds 1           ; B&W switch value at game start (reset)
currentSWCHB         ds 1           ; B&W switch value during current frame
lastSWCHB            ds 1           ; B&W switch value last frame
graphicsPointers     ds 12          ; loads pointers into RAM
climberOffset        ds 1
obstacleOffset       ds 1
pf1Vars              ds NUMGRP
pf2Vars              ds NUMGRP
playerGraphicLSB     ds 1           ; these values stay constant where the LSB
                                    ; of playerPointer and playerColorPointer
                                    ; will change based on the climber's 
playerColorsLSB      ds 1           ; vertical position
obstacleGraphicLSB   ds 1
spawnTimer           ds 1           ; timer to spawn a new obstacle
obstacleDirection    ds 1

overlay              ds 8           ; overlay place holder (thank you Andrew)

   echo "***",(*-$80)d, "BYTES OF RAM USED", ($100 - *)d, "BYTES FREE"


   org overlay                      ;[7/8]
;
; the following are needed for the game kernel
;
groupCount           ds 1           ; keeps track of which group of obstacles
                                    ; is being processed during the kernel
loopCount            ds 1
walkwayPF1           ds 1
walkwayPF2           ds 1
enableBall           ds 1
ladderPF1            ds 1
ladderPF2            ds 1

   org overlay                      ;[8/8]
;
; the following are needed for the title kernel
;
groupCount           ds 1           ; keeps track of which group to draw
loopCount            ds 1           ; keeps track of how many times to loop
fontHeight           ds 1           ; used for the 6 digit display kernel
graphicGroupPointer  ds 2           ; pointer to the graphic group to draw
fontColorPointer     ds 2           ; pointer to the graphic color to draw

gameSelectionCount   ds 1           ; loop counter for game selection

   org overlay                      ;[7/8]
;
; the following are needed for the game calculations
;

ladderPointer        ds 4           ; used for ladder calculations
upMotionCheck        ds 1
downMotionCheck      ds 1
pfSection            ds 1
   
   SEG Bank0
   org $F000                        ; 4K ROM
   
;============================================================================
; G A M E  K E R N E L  (Part 1/2)
;============================================================================

; The game kernel is placed at the top of the ROM to avoid any page boundary
; timing errors.
;
; The kernel uses constant cycle counts to help squeeze everything into 76
; machince cycles. This is why there are a lot of calls to the SLEEP macro.
;

; --------------------- PF Timings --------------------
; | PF0 |   PF1   |   PF2   |   PF2   |   PF1   | PF0 |
; |22.??|27 ..  ??|38 ..  ??|48 ..  ??|59 ..  ??|70.??|

Kernel SUBROUTINE
.skipClimberDraw
   SLEEP_7                          ; 7
   lda #$00                         ; 2
   beq .drawClimber                 ; 3
   
.skipObstacleDraw
   SLEEP 4                          ; 4 = @49
   bcc .contineScanline             ; 3
   
KernelLoop
   ldx platformColor                ; 3 = @53
KernelStart
   lda #CLIMBER_HEIGHT-1            ; 2 = @55
   dcp climberOffset                ; 5
   
   lda #DISABLE_BM                  ; 2
   sta ENABL                        ; 3 = @65
   
   lda walkwayPF1                   ; 3
   sta PF1                          ; 3 = @71

   lda #LADDER_COLOR                ; 2
   sta COLUPF                       ; 3
;------------------------------------------------
   sta HMOVE                        ; 3 = @03
   sta ENAM0                        ; 3 = @06
   stx COLUBK                       ; 3 = @09
   bcc .skipClimberDraw             ; 2³
   lda (playerColorPointer),y       ; 5
   sta COLUP1                       ; 3 = @19
   lda (playerPointer),y            ; 5
.drawClimber
   sta GRP1                         ; 3 = @27
   
   lda walkwayPF2                   ; 3
   sta PF2                          ; 3 = @33
   
   dey                              ; 2
   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5 = @42
   bcc .skipObstacleDraw            ; 2³
   lda (obstaclePointer),y          ; 5
.drawObstacle
   sta GRP0                         ; 3 = @52
.contineScanline
   lda #CLIMBER_HEIGHT-1            ; 2
   dcp climberOffset                ; 5
   
   ldx groupCount                   ; 3
   lda pf1Vars-1,x                  ; 4
   sta ladderPF1                    ; 3 = @69
   ora pf1Vars-2,x                  ; 4 = @73
   sta walkwayPF1                   ; 3
;------------------------------------------------
   sta HMOVE                        ; 3 = @03
   bcs .colorClimber                ; 2
   SLEEP_9                          ; 9
   lda #$00                         ; 2
   beq .drawClimber_a               ; -10
.colorClimber
   lda (playerColorPointer),y       ; 5
   sta COLUP1                       ; 3 = @14
   lda (playerPointer),y            ; 5
.drawClimber_a
   sta GRP1                         ; 3 = @22
   
   dey                              ; 2
   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5
   bcs .drawObstacle_a              ; 2
   lda #$00                         ; 2
   NOP_W                            ; -1
.drawObstacle_a
   lda (obstaclePointer),y          ; 5
   sta GRP0                         ; 3 = @42
   
   lda horPosP0-1,x                 ; 4
   tax                              ; 2
   
   lda #CLIMBER_HEIGHT-1            ; 2
   dcp climberOffset                ; 5 = @55
   
   bcs .colorClimber_b              ; 2³
   SLEEP 6                          ; 6
   lda #$00                         ; 2
   pha                              ; 3
   beq .drawClimber_b               ; 3
.colorClimber_b
   lda (playerColorPointer),y       ; 5
   pha                              ; 3 = @66
   lda (playerPointer),y            ; 5
.drawClimber_b
   dey                              ; 2 = @73
   sta GRP1                         ; 3
;------------------------------------------------
   sta HMOVE                        ; 3 = @03
   pla                              ; 4
   sta COLUP1                       ; 3 = @10
   txa                              ; 2
   cmp #(XMAX + 1) / 2              ; 2
   bcs MoveGirderOnRight            ; 2³
   sec                              ; 2 = @18   subtraction MUST start @18
.leftSideCoarseMoveGirder
   sbc #$0F                         ; 2
   bcs .leftSideCoarseMoveGirder    ; 2³
   sta RESM0                        ; 3 = @46
   tax                              ; 2
   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5
   bcs .drawObstacle_b              ; 2
   lda #$00                         ; 2
   NOP_W                            ; -1
.drawObstacle_b
   lda (obstaclePointer),y          ; 5
   sta GRP0                         ; 3 = @66
   lda #CLIMBER_HEIGHT-1            ; 2
   bne DrawLastPlatformLine         ; 3 = @71
   
MoveGirderOnRight SUBROUTINE
   sbc #(XMAX + 1) / 2              ; 2 = @19
.coarseMoveGirder
   sbc #$0F                         ; 2
   bcs .coarseMoveGirder            ; 2³
   tax                              ; 2 = @45

   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5
   bcs .drawObstacle                ; 2
   lda #$00                         ; 2
   NOP_W                            ; -1
.drawObstacle
   lda (obstaclePointer),y          ; 5
   sta GRP0                         ; 3 = @63
   lda #CLIMBER_HEIGHT-1            ; 2
   nop                              ; 2
   sta RESM0                        ; 3 = @70

DrawLastPlatformLine SUBROUTINE
   sta WSYNC
;------------------------------------------------
   sta HMOVE                        ; 3 = @03
   dcp climberOffset                ; 5
   bcs .colorClimber                ; 2³
   SLEEP_9                          ; 9
   lda #$00                         ; 2
   beq .drawClimber                 ; 3
.colorClimber
   lda (playerColorPointer),y       ; 5
   sta COLUP1                       ; 3 = @19
   lda (playerPointer),y            ; 5
.drawClimber
   sta GRP1                         ; 3 = @27
   
   lda HorizontalMoveTable-240,x    ; 4
   sta HMM0                         ; 3 = @34

   dey                              ; 2   
   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5
   bcs .drawObstacle                ; 2
   lda #$00                         ; 2
   NOP_W                            ; -1
.drawObstacle
   lda (obstaclePointer),y          ; 5
   sta GRP0                         ; 3 = @54
   
   lda #CLIMBER_HEIGHT-1            ; 2
   dcp climberOffset                ; 5
   ldx groupCount                   ; 3 = @64
   lda #$00                         ; 2
   sta PF1                          ; 3 = @69
   lda girderGraphics-1,x           ; 4
   sta ENAM0                        ; 3
;------------------------------------------------ 1st blank line
   sta HMOVE                        ; 3 = @03
   lda backgroundColor              ; 3
   sta COLUBK                       ; 3 = @09
   bcc SkipClimberDraw              ; 2³
   lda (playerColorPointer),y       ; 5
   sta COLUP1                       ; 3 = @19
   lda (playerPointer),y            ; 5
DrawClimber
   sta GRP1                         ; 3 = @27
   lda #$00                         ; 2
   sta PF2                          ; 3 = @32
   sta HMCLR                        ; 3 = @35
   
   dey                              ; 2   
   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5
   bcs .drawObstacle_a              ; 2
   lda #$00                         ; 2
   NOP_W                            ; -1
.drawObstacle_a
   lda (obstaclePointer),y          ; 5
   sta GRP0                         ; 3 = @55
   
   lda #CLIMBER_HEIGHT-1            ; 2
   dcp climberOffset                ; 5 = @62
   
   lda pf2Vars-1,x                  ; 4
   sta ladderPF2                    ; 3
   ora pf2Vars-2,x                  ; 4
   sta walkwayPF2                   ; 3 = @76
;------------------------------------------------ 2nd blank line
   sta HMOVE                        ; 3 = @03
   bcs .colorClimber_a              ; 2³
   SLEEP_9                          ; 9
   lda #$00                         ; 2
   beq .drawClimber_a               ; 3
.colorClimber_a
   lda (playerColorPointer),y       ; 5
   sta COLUP1                       ; 3 = @14
   lda (playerPointer),y            ; 5
.drawClimber_a
   sta GRP1                         ; 3 = @22
   
   dey                              ; 2   
   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5
   bcs .drawObstacle_b              ; 2
   lda #$00                         ; 2
   NOP_W                            ; -1
.drawObstacle_b
   lda (obstaclePointer),y          ; 5
   sta GRP0                         ; 3 = @42
   SLEEP 2                          ; 2
   dec groupCount                   ; 5
   lda #$00                         ; 2 = @51
   ldx #GRPHEIGHT-2                 ; 2 = @53
   bne EmptyLadderKernel            ; 3 = @56

SkipClimberDraw
   SLEEP 6                          ; 6
   lda #$00                         ; 2
   beq DrawClimber                  ; 3
   
LadderKernel SUBROUTINE
.skipClimberDraw
   SLEEP_7                          ; 7
   lda #$00                         ; 2
   beq .drawClimber                 ; 3
   
DrawLadderKernel
   lda #CLIMBER_HEIGHT-1            ; 2 = @59
   dcp climberOffset                ; 5 = @64
   lda ladderPF1                    ; 3
   sta PF1                          ; 3 = @70
   lda #LADDER_COLOR                ; 2
   sta.w COLUPF                     ; 4
;------------------------------------------------   
   sta HMOVE                        ; 3 = @03
   bcc .skipClimberDraw             ; 2³
   lda (playerColorPointer),y       ; 5
   sta COLUP1                       ; 3 = @13
   lda (playerPointer),y            ; 5
.drawClimber
   sta GRP1                         ; 3 = @21
   lda ladderPF2                    ; 3
   sta PF2                          ; 3 = @27

   dey                              ; 2   
   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5
   bcs .drawObstacle                ; 2
   lda #$00                         ; 2
   NOP_W                            ; -1
.drawObstacle
   lda (obstaclePointer),y          ; 5
   sta.w GRP0                       ; 4 = @48
   
   dex                              ; 2

   txa                              ; 2 = @52
   and #$03                         ; 2
   bne DrawLadderKernel             ; 2³

EmptyLadderKernel SUBROUTINE
   sta PF2                          ; 3 = @59
   
   lda #CLIMBER_HEIGHT-1            ; 2
   dcp climberOffset                ; 5 = @66
   
   lda #$00                         ; 2
   sta PF1                          ; 3 = @71
   
   lda #BALL_COLOR                  ; 2
   sta COLUPF                       ; 3 = @76
;------------------------------------------------
   sta HMOVE                        ; 3 = @03
   bcc .skipClimberDraw             ; 2³
   lda (playerColorPointer),y       ; 5
   sta COLUP1                       ; 3 = @13
   lda (playerPointer),y            ; 5
.drawClimber
   sta GRP1                         ; 3 = @21
   
   dey                              ; 2   
   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5
   bcs .drawObstacle                ; 2
   lda #$00                         ; 2
   NOP_W                            ; -1
.drawObstacle
   lda (obstaclePointer),y          ; 5
   sta GRP0                         ; 3 = @41
   
   lda #ENABLE_BM                   ; 2
   cpy verPosBL                     ; 3
   bne .disableBall                 ; 2
   BIT_B                            ; 1
.disableBall
   lsr                              ; 2
   sta ENABL                        ; 3 = @54
   dex                              ; 2 = @56
   bne EmptyKernelLoop              ; 4 = @60  crosses a page boundary (ok!)
   
.skipClimberDraw
   SLEEP_7                          ; 7
   lda #$00                         ; 2
   beq .drawClimber                 ; 3
   
;----------------------------------------------------------------StartNewGame
;
StartNewGame
   lda #STARTING_LIVES
   sta lives                        ; set the starting number of lives

   lda #GIRDER_GRAPHIC
   ldx #NUMGRP+5
.resetLoop
   cpx #5
   bcs .setGirderGraphics
   sty gameState,x                  ; clear these variables (y = 0)
   NOP_W
.setGirderGraphics
   sta girderGraphics-5,x
   dex
   bpl .resetLoop

   sty showBonusOrScore             ; set to show the timer and
                                    ; no extra life gained
   iny
   sty levelBCD                     ; set the starting level (y = 1)
   
.setPlatformColors
   lda PlatformColors               ; load the start up platform colors and
   sta platformColor                ; set it
   
   jsr NewLevel                     ; restart the current level which will
                                    ; be STARTING_LEVEL
   inx
   stx frameCount                   ; make 1 so bonus timer doesn't reduce
                                    ; early
                                    
   lda SWCHB                        ; read the console switch value
   and #BW_MASK                     ; mask the B&W switch
   sta startSWCHB                   ; set the B&W switch state
   
;---------------------------------------------------------------TurnOffSounds
TurnOffSounds
   ldy #$00
   sty soundCounter
   sty AUDV0
   sty AUDV1
   rts
   
;--------------------------------------------------SetAttractModeFor30Seconds
SetAttractModeFor30Seconds
   lda #$1E                         ; to cycle between title screen and
   sta frameCount                   ; game over set the attract mode to fire
                                    ; in approximately 30 seconds (i.e. frame
   lda #$7E                         ; count updated each frame so set frame
   sta attractMode                  ; count to 255 - 30 and attract mode to 
                                    ; 127)
   rts
   
SkipLinesLoop
   sta WSYNC
;------------------------------------------------
   sta HMOVE
   dex
   bne SkipLinesLoop
   rts               ;<===========75 bytes from above EmptyKernelLoop branch

;============================================================================
; G A M E  K E R N E L  (Part 2/2)
;============================================================================

;
; As long as this kernel resides <=127 bytes from the bne call above then
; every thing is okay.
;
EmptyKernel SUBROUTINE
.skipClimberDraw
   SLEEP_7                          ; 7
   lda #$00                         ; 2
   beq .drawClimber                 ; 3
   
EmptyKernelLoop
   lda #CLIMBER_HEIGHT-1            ; 2 = @66
   dcp climberOffset                ; 5 = @71
   sta WSYNC
;------------------------------------------------
   sta HMOVE                        ; 3 = @03
   bcc .skipClimberDraw             ; 2³
   lda (playerColorPointer),y       ; 5
   sta COLUP1                       ; 3 = @13
   lda (playerPointer),y            ; 5
.drawClimber
   sta GRP1                         ; 3 = @21
   
   dey                              ; 2
   beq ScoreKernel                  ; 2³
   lda #OBSTACLE_HEIGHT-1           ; 2
   dcp obstacleOffset               ; 5
   bcs .drawObstacle                ; 2
   lda #$00                         ; 2
   NOP_W                            ; -1
.drawObstacle
   lda (obstaclePointer),y          ; 5
   sta GRP0                         ; 3 = @43
.continueLastBlankLine
   dex                              ; 2 = @45
   bne .determineLadderKernel       ; 2³
   
   jmp KernelLoop                   ; 3 = @50
   
.determineLadderKernel
   txa                              ; 2
   and #$03                         ; 2 = @52
   bne EmptyKernelLoop              ; 2³
   jmp DrawLadderKernel             ; 3 = @59

ScoreKernel SUBROUTINE
   lda platformColor                ; 3 = @34
   sty GRP0                         ; 3 = @37
   sty ENABL                        ; 3 = @40
   sta WSYNC                        ; 3 = @43
;------------------------------------------------
   sta HMOVE                        ; 3 = @03
   sta COLUBK                       ; 3
   sty PF1                          ; 3         clear all graphic registers
   sty GRP1                         ; 3         so they don't show in the
   sty GRP0                         ; 3         score kernel
   sty ENAM0                        ; 3
   sty PF2                          ; 3 = @21
  
   lda #HMOVE_L1 | THREE_COPIES     ; 2
   sta NUSIZ0                       ; 3 = @26   3 copies of GRP0 close
   sta NUSIZ1                       ; 3 = @29   3 copies of GRP1 close
   sta VDELP1                       ; 3 = @32   VDEL player 1

   sta HMP0                         ; 3 = @35   move player 0 left one pixel
   asl                              ; 2         a = $26 or HMOVE_L2
                                    ;           (only upper nybbles used)
   sta RESP0                        ; 3 = @40   coarse position player 0 @ 40
   sta RESP1                        ; 3 = @43   coarse position player 1 @ 43
   
   sta HMP1                         ; 3 = @46   move player 1 left two pixels

   sta WSYNC
;------------------------------------------------
   sta HMOVE                        ; 3

   stx COLUP0                       ; 3
   stx COLUP1                       ; 3
   stx REFP0                        ; 3 = @12   don't reflect the players
   stx REFP1                        ; 3
   
   SLEEP_9                          ; 9         waste 9 cycles to avoid early
                                    ;           HMCLR
   sta HMCLR                        ; 3 = @27   clear horizontal movement
   jsr DrawItGameTextHeight
;
; draw the level number here -- come back from DrawIt start on cycle 9
;
   ldx #$06                         ; 2
   lda #<Level3                     ; 2
   sec                              ; 2 = @15
.setLevelMSBLoop
   sta graphicsPointers,x           ; 4
   sbc #TEXT_HEIGHT                 ; 2
   dex                              ; 2
   dex                              ; 2
   bpl .setLevelMSBLoop             ; 2³ = @66

   lda levelBCD                     ; get the level number in BCD
   and #$0F                         ; mask the upper nibble
   tay                              ; used as an offset for the number
                                    ; graphic
   sta WSYNC
;------------------------------------------------
   sta HMOVE   
   lda NumberTable,y                ; load the number graphic position
   sta graphicsPointers+10          ; store the pointer to the number
 
   lda levelBCD                     ; get the level number in BCD again
   lsr                              ; shift the value down to the lower
   lsr                              ; nibble
   lsr
   lsr
   
   ldx #<Blank
   tay                              ; used as an offset for the number
                                    ; graphic
   beq .setGraphic
   ldx NumberTable,y
.setGraphic   
   stx graphicsPointers+8           ; store the pointer to the number
   jsr DrawItGameTextHeight

   ldx lives                        ; get the number of remaining lives
   bmi .drawGameOver                ; if it's rolled over the game is over
   dex                              ; used to show number of remaining lives

   bpl .displayReservedLives        ; always positive
   
   ldx #17
   bne .drawEmptyScanlines

.drawGameOver
   ldx #11                          ; used as an index to load the graphic
                                    ; pointers
.storeGameOverLoop
   ldy #$03                         ; used to keep track of how long we've
                                    ; been in the loop
                                    
; the loop to load the graphics would take 169 cycles (2 scan lines) we need
; control of this so we know when to hit the HMOVE to black out the left side
; of the screen. The following loop takes the graphic load and splits it into
; 4 iterations so we know when to hit HMOVE. At most the loop will take 15
; cycles so we can loop for 4 times before we run out of time for the scan.
; (3 * 15) + 14 = 59 cycles + 10 = 69


   sta WSYNC
;------------------------------------------------
   sta HMOVE                        ; 3
.gameOverGraphicLoop
   lda GameOverLiteral,x            ; 4
   sta graphicsPointers,x           ; 4
   dex                              ; 2
   dey                              ; 2
   bpl .gameOverGraphicLoop         ; 2³
   txa                              ; 2     used to test x for negative
   bpl .storeGameOverLoop           ; 2³
   
   sta WSYNC
;------------------------------------------------
   sta HMOVE
   jsr DrawItGameTextHeight         ; draw the "GAME OVER" literal
   
   ldx #$07
   bne .drawEmptyScanlines

.displayReservedLives
   lda #REFLECT
   sta RESP0                        ; player now at pixel 66
   sta REFP0                        ; reflect player 0
   lda LivesIndicatorCount,x
   sta NUSIZ0
   sty VDELP0                       ; turn off vertical delay
   
   ldy #RESERVE_LIVES_HEIGHT+1
.drawReservedLives
   sta WSYNC
;------------------------------------------------
   sta HMOVE
   lda LivesIndicator-2,y           ; use the horizontal frame for lives
   sta GRP0                         ; indicator
   dey
   bne .drawReservedLives
   sty GRP0                         ; clear player graphic register (y = 0)
   
   ldx #7
.drawEmptyScanlines
   jsr SkipLinesLoop
   jmp Overscan
   
;----------------------------------------------------------------------DrawIt
;
; Draw the values of the graphicsPointers. This routine was ripped from
; River Raid. It's a little different from the other 6 digit displays since
; it does a HMOVE on each scan line to blank the HMOVE bars.
;
; This routine MUST NOT cross a page boundary.
;
DrawItGameTextHeight
   ldy #GAME_TEXT_HEIGHT-1          ; set fontHeight to be used by DrawIt
   NOP_W
DrawIt
   ldy fontHeight
DrawGraphicsLoop
   lda (graphicsPointers+8),y       ; 5
   tax                              ; 2
   lda (graphicsPointers+10),y      ; 5
   sta WSYNC                        ; 3 = @76
;------------------------------------------------
   sta HMOVE                        ; 3
   sty fontHeight                   ; 3
   sta temp                         ; 3
   lda (graphicsPointers),y         ; 5
   sta GRP0                         ; 3 = @17
   lda (graphicsPointers+2),y       ; 5
   sta GRP1                         ; 3 = @25
   lda (graphicsPointers+4),y       ; 5
   sta GRP0                         ; 3 = @33
   lda (graphicsPointers+6),y       ; 5
   ldy temp                         ; 3

   sta GRP1                         ; 3 = @44
   stx GRP0                         ; 3 = @47
   sty GRP1                         ; 3 = @50
   sta GRP0                         ; 3 = @53
   ldy fontHeight                   ; 3
   dey                              ; 2
   bpl DrawGraphicsLoop             ; 2³
   
   CHECKPAGE DrawGraphicsLoop
   
   iny                              ; 2 = @62   y = 0
   sty GRP0                         ; 3 = @65   clear the player graphics
   sty GRP1                         ; 3 = @68
   sty GRP0                         ; 3 = @71   have to do twice because it's
                                    ;           VDEL'd

   sta WSYNC
;--------------------------
   sta HMOVE
   rts

CheckObstacleHorizontalPos SUBROUTINE
   lda levelBCD                     ; get the current level number
   cmp #$06
   bcc .leaveRoutine                ; if the level is less than 5 then don't
                                    ; move the obstacle
   bit CXM0P                        ; read the collision register
   bvc .checkObstacleDirection

   ldx #NUMGRP
   lda #KERNEL_HEIGHT
   sec
.findObstacleLadderSection
   sbc #LADDER_SECTION_HEIGHT       ; subtract the ladder section height to
   dex                              ; find which section the obstacle is in
   cmp verPosObstacle               ; when done x will hold the ladder
   bcs .findObstacleLadderSection   ; section

   lda #%10000000                   ; assume the obstacle will be moving left
   ldy girderDirection,x            ; get the girder's direction
   bpl .setObstacleDirectionRight
   BIT_B
.setObstacleDirectionRight
   lsr
   sta obstacleDirection
   
.checkObstacleDirection
   ldy girderSpeedIndex             ; get the current speed of the girder
   lda playerMotion                 ; get the girder fractional delay value
   sec
   adc GameSpeedTable-1,y
   bcc .leaveRoutine

   ldx horPosObstacle               ; get the horizontal postion of the
                                    ; object
   bit obstacleDirection            ; check which direction its moving
   bmi .moveObstacleLeft
   bvc .leaveRoutine                ; object just falling down
.moveObstacleRight   
   cpx #CLIMBER_XMAX                ; make sure the obstacle is not pushed
   bcs .setHorizontalPosition       ; off the right of the screen
   inx                              ; move the obstacle to the right
                                    ; carry is clear for the next instruction
   NOP_W                            ; byte to skip the next 2 bytes
.moveObstacleLeft
   cpx #CLIMBER_XMIN+1              ; make sure the obstacle is not pushed off
   bcc .setHorizontalPosition       ; the left of the screen
   dex                              ; move the obstacle to the left
.setHorizontalPosition
   stx horPosObstacle               ; store the new horizontal position
   
   lda levelBCD                     ; get the current level (BCD)
   cmp #$11                         ; beginning at level 11 the obstacles are
   bcs .leaveRoutine                ; "pushed" by the girders
   lda #$00
   sta obstacleDirection            ; reset the obstacle's direction

.leaveRoutine
   rts
   
;-------------------------------------------------------------------PlaySound
;
; The volume and channel will be set this routine. The x register must hold
; the frequency. This sound routine only manipulates sound channel 1
;
PlaySound
   lda #GAME_SOUND_VOLUME
   sta AUDV1
   lda #$0C
   sta AUDC1
   stx AUDF1
   dec soundIndex
   rts
   
ClimberDeathAnimationTable
   .byte <DeathFrame1 - KERNEL_HEIGHT - 1
   .byte <DeathFrame2 - KERNEL_HEIGHT - 1
   
WalkwayValues
PLATFORM SET YMIN
   REPEAT  NUMGRP
   .byte PLATFORM
PLATFORM SET PLATFORM + LADDER_SECTION_HEIGHT
   REPEND
   
   BOUNDARY (KERNEL_HEIGHT - 6)
ClimberColors
HorizontalColors
   .byte LTBLUE
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte PEACH
   .byte PEACH
   .byte PEACH
   .byte PEACH
   .byte PEACH
   .byte PEACH
   .byte GREEN
   .byte GREEN
   .byte GREEN
   
VerticalColors
   .byte LTBLUE
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte PEACH
   .byte PEACH
;
; last 4 bytes shared with table below
;
DeathAnimationColors
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte PEACH
   .byte PEACH
   .byte PEACH
   .byte PEACH
   .byte PEACH
   .byte PEACH
   .byte GREEN
   .byte GREEN
   .byte GREEN
   .byte WHITE
   .byte WHITE
   .byte WHITE

DeathAnimationFrames
DeathFrame1
   .byte $FE ;|XXXXXXX.|
   .byte $BE ;|X.XXXXX.|
   .byte $32 ;|..XX..X.|
   .byte $3A ;|..XXX.X.|
   .byte $F9 ;|XXXXX..X|
   .byte $3F ;|..XXXXXX|
   .byte $1C ;|...XXX..|
   .byte $3E ;|..XXXXX.|
   .byte $7F ;|.XXXXXXX|
   .byte $7F ;|.XXXXXXX|
   .byte $5F ;|.X.XXXXX|
   .byte $3E ;|..XXXXX.|
   .byte $FE ;|XXXXXXX.|
   .byte $3E ;|..XXXXX.|
   .byte $1C ;|...XXX..|
   .byte $14 ;|...X.X..|
   .byte $42 ;|.X....X.|   
   .byte $28 ;|..X.X...|

DeathFrame2
   .byte $FE ;|XXXXXXX.|
   .byte $BE ;|X.XXXXX.|
   .byte $32 ;|..XX..X.|
   .byte $3A ;|..XXX.X.|
   .byte $F9 ;|XXXXX..X|
   .byte $3F ;|..XXXXXX|
   .byte $1C ;|...XXX..|
   .byte $3E ;|..XXXXX.|
   .byte $7F ;|.XXXXXXX|
   .byte $7F ;|.XXXXXXX|
   .byte $5F ;|.X.XXXXX|
   .byte $3E ;|..XXXXX.|
   .byte $FE ;|XXXXXXX.|
   .byte $3E ;|..XXXXX.|
   .byte $1C ;|...XXX..|
   .byte $28 ;|..X.X...|
   .byte $42 ;|.X....X.|   
   .byte $14 ;|...X.X..|

;------------------------------------------------------------------RandomByte
;
; The VCS has no random routine so one must be written by the programmer.
; This routine comes from Thomas Jentzsch. I'm using #$B2 to eor the random
; seed.
; Any of the following numbers would work though:
; 8E,95,96,A6,AF,B1,B2,B4,B8,C3,C6,D4,E1,E7,F3,FA
; These numbers generate sequences of 255 values. For more information see
; http://www.ece.cmu.edu/~koopman/lfsr/
;
RandomByte
   lda random
   lsr
   bcc .skipEor
   eor #RAND_EOR_8
.skipEor
   sta random
   rts
   
GameSpeedTable
   .byte LEVEL_1_SPEED,LEVEL_2_SPEED,LEVEL_3_SPEED,LEVEL_4_SPEED
   
LowHorizontalMovementTable
   .byte <HorizontalMoveFrame1 - KERNEL_HEIGHT - 1
   .byte <HorizontalMoveFrame2 - KERNEL_HEIGHT - 1
   .byte <HorizontalMoveFrame3 - KERNEL_HEIGHT - 1
   .byte <HorizontalMoveFrame2 - KERNEL_HEIGHT - 1
   
FontHeightTable
   .byte COPYRIGHT_HEIGHT-1
   .byte NUMBER_5_HEIGHT-1
   .byte CLIMBER_FONT_HEIGHT-1
   .byte PRESENTS_FONT_HEIGHT-1
   .byte AA_FONT_HEIGHT-1
   
ClimberLiteral
   .word Climber0,Climber1,Climber2,Climber3,Climber4,Climber5
CopyrightLiteral
   .word Copyright0,Copyright1,Copyright2,Copyright3,Copyright4,Copyright5
GameOverLiteral
   .word GameOver0,GameOver1,GameOver2,GameOver3,GameOver4,GameOver5
   
LadderMasking
   .byte D7,D6,D5,D4,D3,D2,D1,D0
   
AtariAgeLiteral
   .word AtariAgeSymbol0,AtariAgeSymbol1
   .word AtariAge0,AtariAge1,AtariAge2,AtariAge3
   
PresentsLiteral
   .word Blank,Presents0,Presents1,Presents2,Presents3
;
; last word shared with next table so don't cross page boundaries
;   

Climber5Literal
   .word Blank,Climber50,Climber51,Climber52,Climber53
;
; last word shared with next table so don't cross page boundaries
;
GameOptionLiterals
NormalLiteral
   .word Blank,Normal0,Normal1,Normal2,Normal3,Blank
AdvancedLiteral
   .word Advanced0,Advanced1,Advanced2,Advanced3,Advanced4,Advanced5
OriginalLiteral
   .word Original0,Original1,Original2,Original3,Original4,Blank
   
ObstacleLSB
   .byte <CupIcon - KERNEL_HEIGHT + 1
   .byte <BearIcon - KERNEL_HEIGHT + 1
   .byte <Butterfly - KERNEL_HEIGHT + 1
   .byte <AA_Icon - KERNEL_HEIGHT + 1
   .byte <Lunchbox - KERNEL_HEIGHT + 1
   .byte <Hammer - KERNEL_HEIGHT + 1   
   .byte <Brick - KERNEL_HEIGHT + 1
   
LowVerticalMovementTable
   .byte <VerticalMoveFrame1 - KERNEL_HEIGHT - 1
   .byte <VerticalMoveFrame2 - KERNEL_HEIGHT - 1
   
;---------------------------------------------------------DetermineLevelIndex
;
; This routine alters the accumulator value and x-register. It takes the
; current accumulator value (BCD) and reduces it by 5 until the number is
; between 1 and 5
;
DetermineLevelIndex
   sed                              ; set to decimal mode
   bne .compareToMaxValue

.decrementLevelLoop
   inx                              ; increment x
   sbc #MAX_LEVEL+1                 ; this routine gets a number between the
.compareToMaxValue
   cmp #MAX_LEVEL+2                 ; max color level limit for color cycling
   bcs .decrementLevelLoop
   cld                              ; clear decimal mode
   rts
   
;--------------------------------------------------------------ShowAllGirders
;
; When the game is over, its possible for all the girders not to show on the
; game over screen. This happens when the player is playing either the NORMAL
; or ADVANCED game option on difficulty B setting.
;
ShowAllGirders SUBROUTINE
   ldx #NUMGRP-1
   
.loadGirderGraphic
   lda #GIRDER_GRAPHIC
   sta girderGraphics,x             ; set the girder's graphic value
   dex
   bpl .loadGirderGraphic
   rts
   
BonusAmountTable
   .BYTE $01,$03,$05,$07,$09,$11,$13,$15
   
   BOUNDARY (KERNEL_HEIGHT + 8)     ; add 8 to get contiguous free ROM
                                    ; (adding 8 pushes HorizontalMoveTable to
                                    ; page end)
ObstacleSprites
BearIcon   
   .byte $3C ;|..XXXX..|
   .byte $7E ;|.XXXXXX.|
   .byte $E7 ;|XXX..XXX|
   .byte $FF ;|XXXXXXXX|
   .byte $DB ;|XX.XX.XX|
   .byte $5A ;|.X.XX.X.|
   .byte $FF ;|XXXXXXXX|
   .byte $99 ;|X..XX..X|
   .byte $66 ;|.XX..XX.|
CupIcon
   .byte $00 ;|........|
   .byte $1E ;|...XXXX.|
   .byte $7F ;|.XXXXXXX|
   .byte $BF ;|X.XXXXXX|
   .byte $BF ;|X.XXXXXX|
   .byte $BF ;|X.XXXXXX|
   .byte $BF ;|X.XXXXXX|
   .byte $BF ;|X.XXXXXX|
   .byte $7F ;|.XXXXXXX|
AA_Icon
   .byte $00 ;|........|
   .byte $3C ;|..XXXX..|
   .byte $42 ;|.X....X.|
   .byte $A5 ;|X.X..X.X|
   .byte $DB ;|XX.XX.XX|
   .byte $A5 ;|X.X..X.X|
   .byte $99 ;|X..XX..X|
   .byte $42 ;| X....X |
   .byte $3C ;|..XXXX..|
Hammer
   .byte $00 ;|........|
   .byte $18 ;|...XX...|
   .byte $18 ;|...XX...|
   .byte $18 ;|...XX...|
   .byte $98 ;|X..XX...|
   .byte $BD ;|X.XXXX.X|
   .byte $BE ;|X.XXXXX.|
   .byte $BC ;|X.XXXX..|
   .byte $98 ;|X..XX...|
Brick
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|
Lunchbox
   .byte $00 ;|........|
   .byte $FF ;|XXXXXXXX|
   .byte $C3 ;|XX....XX|
   .byte $DF ;|XX.XXXXX|
   .byte $DF ;|XX.XXXXX|
   .byte $FF ;|XXXXXXXX|
   .byte $42 ;|.X....X.|
   .byte $42 ;|.X....X.|
   .byte $3C ;|..XXXX..|
Butterfly
   .byte $00 ;|........|
   .byte $18 ;|...XX...|
   .byte $DB ;|XX.XX.XX|
   .byte $E7 ;|XXX..XXX|
   .byte $66 ;|.XX..XX.|
   .byte $18 ;|...XX...|
   .byte $66 ;|.XX..XX.|
   .byte $E7 ;|XXX..XXX|
   .byte $DB ;|XX.XX.XX|
   .byte $24 ;|..X..X..|
   
;---------------------------------------------------------HorizontalMoveTable
;
; This table holds HMPx values to adjust the player for fine horizonatal
; movement. This comes from a combination of Manuel Rotschkar and Eric Ball.
;
; This table should be placed at the end of a page boundary to avoid masking
; the upper nibbles.
;
HorizontalMoveTable
   .byte HMOVE_L7,HMOVE_L6,HMOVE_L5,HMOVE_L4
   .byte HMOVE_L3,HMOVE_L2,HMOVE_L1,HMOVE_0
   .byte HMOVE_R1,HMOVE_R2,HMOVE_R3,HMOVE_R4
   .byte HMOVE_R5,HMOVE_R6,HMOVE_R7,HMOVE_R8
   
Start
;
; Set up everything so the power up state is known.
;
;   sei                             ; No interrupts are used for this game.
                                    ; This is here for clarity purposes and
                                    ; commented out to save 1 byte :)
   cld                              ; clear BCD bit
   ldy INTIM                        ; for random number seed
   
; The next routine comes courtesy of Andrew Davie :) The routine clears all
; variables, TIA registers, and initializes the stack pointer to #$FF in 8
; bytes. It does this in the unusual way of wrapping the stack. Very
; ingenious!!
   
   ldx #$00
   txa                              ; accumulator now 0
.clear
   dex
   txs                              ; stack pointer now equals x
   pha                              ; pushes 0 to stack pointer and moves
                                    ; stack pointer
   bne .clear                       ; continue until x reaches 0 (255 times)
   
;----------------------------------------------------------GameInitialization
;
; Initialize the game variables on cart start up. These variables must be
; set for the game to function properly.
;
GameInitialization

   lda #MAXSELECTLEVEL
   sta gameSelection

   sty random                       ; set the random number seed
   ldx #%00010001                   ; reflect the playfield and set ball size
   stx CTRLPF                       ; to two clocks
  
   ldx #TITLESCREEN                 ; set the present game state to the
   stx gameState                    ; title screen
   
   lda #>ClimberColors              ; MSB for the colors (never changes)
   sta playerColorPointer+1
   
MainLoop   
;--------------------------------------------------------CheckConsoleSwitches
;
; Check the VCS's console switches.
; ------------------------
; SELECT = Select game variation
; RESET = Restart the game for the selected game variation
; B&W (7800 Pause) = Pause
;
CheckConsoleSwitches SUBROUTINE
   ldy #$00
   ldx SWCHB                        ; read the console switch value
   lda gameState                    ; check the game state to see if the game
   cmp #GAME_OVER_STATE             ; is over -- if so then skip the B/W
   beq .checkConsoleSwitches        ; pause check
   
   txa                              ; SWCHB loaded in x above
   and #BW_MASK                     ; mask the B&W switch
   sta currentSWCHB                 ; and store the current state
   
   cmp lastSWCHB                    ; if the B&W value didn't change skip
   beq .checkConsoleSwitches        ; pause check
   
   cmp startSWCHB                   ; again if the B&W value didn't change
   bne .checkConsoleSwitches        ; skip pause check
   
   bit attractMode                  ; if in attract mode then check to enable
   bmi .tiaEnableCheck              ; TIA

   lda gameState                    ; get the current game state
   eor #GAMEPAUSED                  ; EOR will switch the bits to set the
   sta gameState                    ; game mode to pause or running
.checkConsoleSwitches
   txa                              ; lda with SWCHB value
   lsr                              ; move the reset value to the carry bit
   bcc .startNewGame

CheckSelectSwitch
   lsr                              ; move the select value to the carry bit
   bcc .selectSwitchDown            ; carry clear -- select switch down
   
   bit gameState                    ; if we are not on the menu screen then
   bpl .selectNotPressed            ; we don't use the joystick for game
                                    ; options
   
   lda SWCHA                        ; get the joystick value
   asl                              ; shift left twice to but down/up values in
   asl                              ; D7 and D6 (then we can use bit)
   sta allowedMotion                ; put it in allowed motion for now
   bpl .selectSwitchDown            ; D7 = 0 so joystick is down
   asl                              ; move joystick up value to D7
   bpl .selectSwitchDown            ; D7 = 0 so joystick is up
   
.selectNotPressed
   sty selectDebounce               ; show select not pressed (D7 = 0)
   jmp .continueConsoleSwitchCheck
   
.selectSwitchDown
   bit selectDebounce               ; if D7 = 0 then select was not held
   bpl .continueSelectSwitchDown
   
   lda frameCount                   ; get the current frame count
   and #SELECT_DELAY                ; the select switch is checked ~ every 60
   bne .continueConsoleSwitchCheck  ; frames or ~ every second
.continueSelectSwitchDown
   sty frameCount                   ; reset frame count
   dey                              ; y now #$FF   
   sty selectDebounce               ; show that the select switch is held for
                                    ; the next frame
   jsr TurnOffSounds
   sty levelBCD
   
   bit attractMode                  ; if we are in attract mode then enable
.tiaEnableCheck                     ; the TIA
   bmi .checkToEnableTIA
   
   bit gameState                    ; if currently on the title screen then
   bmi .changeGameSelection         ; increase the game selection
   
   lda #TITLESCREEN                 ; game select was pressed and recorded so
   sta gameState                    ; put the user back to the title screen
   bmi .continueConsoleSwitchCheck  ; the game selection is only increased
                                    ; while on the title screen so continue
                                    ; checking the console switches
.changeGameSelection
   ldx gameSelection                ; get the current game selection
   bit allowedMotion                ; test D7 and D6 of allowedMotion
   bvc .increaseGameSelection       ; D6 = 0 so pushing up
   dex                              ; decrement the game selection
   bpl .setGameSelection            ; never negative -- saves a byte
   
   ldx #MAXSELECTLEVEL-1            ; set the value to the max level select
   
.increaseGameSelection
   inx                              ; increase game selection
   cpx #MAXSELECTLEVEL+1            ; check to see if the game selection
   bne .setGameSelection            ; needs to wrap around
   ldx #$00
.setGameSelection
   stx gameSelection
  
.continueConsoleSwitchCheck
   lda gameState                    ; if the game is over then end the
   cmp #GAME_OVER_STATE             ; console switch check
   beq .endConsoleSwitchCheck
   
   lda frameCount                   ; check the fire button ~every 60 seconds
   and #SELECT_DELAY
   beq .checkJoystick               ; the joystick is checked to determine if
                                    ; the attract mode should be turned off
CheckFireButton
   lda playerState                  ; get the current player state
   and #%11000000                   ; mask all but D7 and D6
   bne .clearFireButtonDebounce     ; if the player collided with an object
                                    ; then clear the fire button debounce
                                    ; state
   lda INPT4                        ; D7 of INPT4 is set high so the fire
   bmi .clearFireButtonDebounce     ; button is not depressed
;
; The fire button was pressed. Check to see if it was held down. If so then
; ignore the button press. If the button press is valid (it wasn't held down
; and enough time has elapsed) then set the game state accordingly.
;
   cmp fireButtonDebounce           ; check if the fire button is down from
                                    ; the previous frame
   beq .checkJoystick
   sta fireButtonDebounce           ; show the fire button was pressed
   
   bit gameState
   bvs .checkToEnableTIA            ; if the game is paused reset attract
                                    ; timer and enable TIA output
   bpl .reverseGirderDirection      ; the game is running so reverse girder
                                    ; direction
.startNewGame
   lda #START_NEW_GAME              ; the game is on the menu so start a
   sta gameState                    ; new game
   bpl .checkToEnableTIA

.reverseGirderDirection
   lda gameSelection
   lsr
   bne .clearFireButtonDebounce     ; not the ADVANCED_OPTION so check the 
                                    ; joystick for movement
;
; Here we know the user is playing the enhanced version so reverse the
; movement of the girders.
;
   lda #$0C
   sta fireSoundIndex
   lda #TIMER_PENALTY               ; reduce the timer as a penalty
   jsr DecrementBonusTimer
   ldx #NUMGRP-1
.reverseDirectionLoop
   lda girderDirection,x            ; get the girder movement
   eor #$FF                         ; and negate it to make it's movement
   clc                              ; reverse directions
   adc #$01
   sta girderDirection,x
   dex
   bpl .reverseDirectionLoop
   
   bmi .checkToEnableTIA            ; same as jmp -- saves a byte
   
.clearFireButtonDebounce
   sty fireButtonDebounce           ; show the fire button was not pressed
   
.checkJoystick
   lda SWCHA                        ; if the joystick was moved turn off
   cmp #$FF                         ; attract mode (enable TV output)
   beq .endConsoleSwitchCheck
   
.checkToEnableTIA
   bit gameState                    ; if the game state is not in title
   bpl .enableTIA                   ; screen mode then enable the TIA
   lda levelBCD                     ; if the level is not 0 then we must be
   bne .endConsoleSwitchCheck       ; cycling between title and game over

.enableTIA
   sty attractMode                  ; clear the attract mode timer
   
.endConsoleSwitchCheck
   lda currentSWCHB                 ; get the current B&W value
   sta lastSWCHB                    ; and store it in last B&W value for
                                    ; next frame
   lda gameState                    ; get the current game state
   cmp #START_NEW_GAME              ; if we're not starting a new game then
   bne .waitLoop                    ; continue checking
   
   jsr StartNewGame                 ; start a new game
   
.waitLoop
   ldy INTIM
   bne .waitLoop
   
;----------------------------------------------------------------VerticalSync
;
; This routine will take care of vertical sync house keeping. Vertical sync
; starts a new television frame. Each frame starts with 3 vertical sync
; lines. These signal to the television to start a new frame.
;
VerticalSync
   ldx #VBLANK_TIME                 ; used to set the timer with the wait
                                    ; time
   lda #D1                          ; D1 = 1
   sta WSYNC                        ; make sure VSYNC happens on a new line
   sta VSYNC                        ; start a new frame
   
   inc frameCount                   ; frame count is update every frame
   bne .skipAttractMode             ; if it didn't roll over then skip
                                    ; attract mode logic
   bit attractMode                  ; if already in attract mode then skip
   bmi .skipAttractMode             ; incrementing the attract mode counter
   inc attractMode                  ; attract mode updated every 255 frames
                                    ; until it reaches #$80
.skipAttractMode
   lsr                              ; accumulator = 1 (Thanks Thomas!)
   sta WSYNC                        ; first line for VSYNC
   sta WSYNC                        ; second line of VSYNC
   sta WSYNC                        ; third and final line of VSYNC
   sta VSYNC                        ; end the VSYNC period (D0 = 1)
   stx TIM64T                       ; set timer for vertical blank wait
   
   
   lda gameState
   cmp #GAME_OVER_STATE             ; if the game is over cycle between the
   bne .continueCheckingGameState   ; title screen and game over screen
   
   lda attractMode                  ; once D7 has gone high switch to the
   bpl .doneGameCalculations        ; title screen
   
   sta gameState                    ; D7 = 1 here so move it to game state to
                                    ; show the title screen -- saves 2 bytes
                                    ; because the value is already set :)
   jsr SetAttractModeFor30Seconds

.continueCheckingGameState
   bit gameState                    ; bit will set N, V, and Z status
   bpl GameCalculations             ; game is in progress
                                    ; (fall through if not)

;-----------------------------------------------------TitleScreenCalculations
;
; Set up the players for a 6 digit display. They will be centered on the
; screen for the title screen information.
;
TitleScreenCalculations   
   ldx #$05                         ; used to coarse move the players
   jsr RandomByte                   ; re-seed the random number
   sta WSYNC                        ; wait for next scan line
.coarseMovePlayers
   dex
   bpl .coarseMovePlayers
;
; Using a technique suggested by Thomas we can or $03 (THREE_COPIES) with the
; accumulator to set number of GRPx copies and the VDELPx values
;
   lda #HMOVE_L1 | THREE_COPIES     ; = $13 (%00010011) only top nybbles used
                                    ; for HMPx
   sta NUSIZ0                       ; 3 copies of GRP0 close (D1 and D0 = 1)
   sta NUSIZ1                       ; 3 copies of GRP1 close (D1 and D0 = 1)
   
   sta RESP0                        ; set to cycle 40 or pixel 120 (40 * 3)
   sta RESP1                        ; set to cycle 43 or pixel 129 (43 * 3)
   
   sta VDELP0                       ; vertical delay for GRP0 (D0 = 1)
   sta VDELP1                       ; vertical delay for GRP1 (D0 = 1)
   
   sta HMP0                         ; move player 0 left one pixel
   asl                              ; a = $26 or HMOVE_L2   
   sta HMP1                         ; move player 1 left two pixels
   
   sta REFP0                        ; set the players not to reflect so the
   sta REFP1                        ; title screen displays properly (D3 = 0)
   
   sta WSYNC                        ; next scan line
   sta HMOVE                        ; move the players
   
   lda levelBCD                     ; if cycling through game over and title
   beq .resetAttractMode            ; screen level will not be zero
   
   bit attractMode                  ; check attract mode for screen
   bpl .gotoDisplayKernel           ; "flip time" if no attract mode display
                                    ; the kernel
   
   lda #GAME_OVER_STATE             ; set game state to game over so we know to
   sta gameState                    ; "flip" the screen
   jsr SetAttractModeFor30Seconds
   bpl .doneGameCalculations
   
.resetAttractMode
   sta attractMode                  ; reset the attract mode
.gotoDisplayKernel
   lda #WOOD_BROWN                  ; get the playfield color for the title
   sta COLUPF
   lda #SKY_BLUE                    ; get the background color for the title
   sta COLUBK
   
   jmp DisplayKernel

;------------------------------------------------------------GameCalculations
;
; The players will be moved in this routine. The sound will be done during
; overscan calculations.
;
GameCalculations
   bvc MoveGirders                  ; if the game is not paused then move the
                                    ; players (bit gameState from above)
   jsr TurnOffSounds
.climberCantMove
   dey                              ; set the allowed motion to no motion
                                    ; y was 0 before getting here so now
                                    ; it's #$FF
   sty allowedMotion                ; y used so the iny will set it to zero

.doneGameCalculations
   jmp DoneGameCalculations         ; game paused so nothing to do
;
; Move the obstacles horizontally. This routine is used courtesy of Piero
; Cavina. It is based on his PCMSD demo which eventually became Oyston. His
; original PCMSD source can be found at
; http://www.biglist.com/lists/stella/archives/199704/msg00015.html. His
; game Oystron (great game!) can be purchased at
; http://www.atariage.com/store
; Visit http://atariage.com/software_page.html?SoftwareLabelID=869 to learn
; more about the game :)
;
MoveGirders
   sty attractMode                  ; reset attract mode -- y = 0
   
   bit playerState                  ; pause the action if the player
   bvs .climberCantMove             ; retrieved the ball
   
   ldy girderSpeedIndex             ; get the current speed of the girder
   lda playerMotion                 ; get the girder fractional delay value
   clc
   sbc GameSpeedTable-1,y
   sta playerMotion                 ; set the girder fractional delay value
   bcs .doneMovingGirders           ; didn't cross 0 -- don't move this
                                    ; girder
   ldx #NUMGRP-1                    ; index for the number of girders
.moveGirdersLoop
   lda gameSelection                ; get the game selection
   lsr                              ; shift the value to the right to find
   bne MoveGirderForStandard        ; the game mode -- (saves a byte vs. cmp)
   
;-------------------------------------------------------MoveGirderForAdvanced
MoveGirderForAdvanced
   dec girderDirection,x
   bmi MoveGirderLeft               ; if start count >= #$80 then move left
                                    ; this gives the girder movement a range
                                    ; of 127 pixels
   lda #FAIR_WARNING_TICK
   jsr CheckToFlashGirderColor   
MoveGirderRight
   cmp #XMAX                        ; make sure the position < XMAX
   bcc IncreaseGirderPosition       ; if so then move right
.wrapGirderToLeft
   lda #XMIN-1                      ; load the minimum value so girder wraps to
   sta horPosP0,x                   ; the left side of the screen
IncreaseGirderPosition
   inc horPosP0,x                   ; increase the horizontal position
   bne .checkNextGroup              ; never 0 -- saves 1 byte
   
MoveGirderLeft
   lda #127+FAIR_WARNING_TICK
   jsr CheckToFlashGirderColor
   cmp #XMIN                        ; make sure the position > XMIN
   bcs DecrementGirderPosition      ; if so the move left
   lda #XMAX                        ; load the maximum value so girder wraps to
   sta horPosP0,x                   ; the right side of the screen
DecrementGirderPosition
   dec horPosP0,x                   ; decrease the horizontal position
   bne .checkNextGroup              ; never 0 -- saves 1 byte
   
;-------------------------------------------------------MoveGirderForStandard
MoveGirderForStandard
   ldy horPosP0,x                   ; get the horizontal position of the
                                    ; girder
   lda startCount,x                 ; get the girder's start count
   beq .moveGirder                  ; if it = 0 then okay to move the girder
   dec startCount,x                 ; reduce the start count until
   bpl .checkNextGroup              ; it reaches 0
.moveGirder
   cpy #XMAX                        ; if the girder hasn't reached right edge
   bcc IncreaseGirderPosition       ; then continue moving right
   jsr RandomByte                   ; get a random start count for the girder
   and #$0F                         ; mask the upper nybble
  
CalculateFairStartCount
   sta startCount,x                 ; store it into the start count of girder
   ldy startCount-1,x               ; check the start count of the adjacent
                                    ; girder
   sty temp                         ; to be used in calculation
   sec                              ; set carry for subtraction
   bne .adjustViaStartCount         ; not moving -- compute offset from start
                                    ; count
                                    
   lda horPosP0-1,x                 ; get the adjacent girder's position
   sbc #XMIN                        ; subtract by XMIN -- this is to be used to
   sta temp                         ; help the girders have a "fair" gap for
                                    ; climber to squeeze through
   lda startCount,x                 ; reset a with startCount
   
.adjustViaStartCount
   sbc temp                         ; distance between values
   bcs .greaterThan
   eor #$FF                         ; subtraction made a < 0 so make a > 0
   adc #$01                         ; carry was cleared from subtraction
.greaterThan
   cmp #FAIR_PIXEL_DELTA
   bcs .wrapGirderToLeft            ; if distance > fair pixel value continue
   
   lda #FAIR_PIXEL_DELTA
   cmp temp                         ; if the adjacent startCount < fair pixel
   bcs .incrementStartCount         ; delta then increment start count
   lda #-FAIR_PIXEL_DELTA           ; make the number negative so we subtract
.incrementStartCount
   clc
   adc temp
   sta startCount,x                 ; start count +/- FAIR_PIXEL_DELTA
   bpl .wrapGirderToLeft
.checkNextGroup
   dex
   bpl .moveGirdersLoop

.doneMovingGirders
   lda frameCount                   ; get the current frame count
   and #BONUS_TIMER_DELAY           ; the bonus timer is reduced by 1 ~ every
   bne CheckPlayerState             ; 127 frames or ~ every 2 seconds
   lda #TIMER_REDUCTION
   jsr DecrementBonusTimer
   dec ballTimer
      
CheckPlayerState SUBROUTINE
   ldx #0                           ; used to turn off the walking sound
   lda allowedMotion                ; get the allowed motion
   cmp #$FF                         ; see if the player is moving the climber
   beq .clearIndex                  ; if not -- turn off the walking sound
   lda gameClock                    ; get the game clock for walking sound
   and #$03                         ; mask all but D0 and D1
   bne .clearIndex
   lda walkingSoundIndex
   bne .clearIndex
   inx
.clearIndex
   stx walkingSoundIndex


   ldy levelBCD
   iny
.continueSpeedDetermination
   cpy #MAX_LEVEL+1
   bcc .setClimberSpeed             ; if less than MAX_LEVEL set climber
                                    ; speed
   ldy #MAX_LEVEL-1                 ; decrease climber speed to be slower
                                    ; than the girders
.setClimberSpeed
   lda climberMotion                ; get climber's fractional delay value
   clc
   sbc GameSpeedTable-1,y           ; subtract by 2 -- rol multiplied by 2
   sta climberMotion                ; set the climber fraction delay value
   bcs .doneGameCalculations        ; not time to move climber -- do nothing
   
   inc gameClock                    ; gameClock used for player animation
   bit playerState                  ; check the current player state if not
   bpl CheckJoystickValues          ; doing death animation check joysticks
;
; death animation
;
   lda allowedMotion                ; if the climber is not a walkway he is
   and #DOWN_MOTION_MASK            ; descended until he hits the walkway
   bne .doDeathAnimation            ; same as jmp but save 1 byte
   
   dec verPosP1                     ; move the climber down 1 pixel
.doDeathAnimation
   lda #>DeathAnimationFrames
   sta playerPointer+1              ; set the MSB for the death animation

   lda gameClock                    ; get the game clock for player animation
   and #$01                         ; the death animation is updated every
                                    ; other frame
   tax
   lda ClimberDeathAnimationTable,x ; get the offset for the animation frame
   sta playerGraphicLSB             ; store the LSB for the death animation

   ldy #<DeathAnimationColors - KERNEL_HEIGHT - 1  ; LSB of the colors
   bne .setVerticalColorPointer     ; set the color pointers
   
CheckJoystickValues
   lda lives                        ; get the number of lives remaining
   bpl .checkAllowedMotion          ; lives >=0 check climber allowed motion
   
   sta allowedMotion                ; the game is over so set the allowed
                                    ; motion to no motion allowed (#$FF)
.checkAllowedMotion   
   lda SWCHA                        ; get the real joystick value
   ora allowedMotion                ; combine it with allowed motion
;
; suggested by Thomas Jentzsch (saves 2 bytes)
;
; The eor is great here! The trick here is if eor #$FF on 0 gives #$FF and
; eor on #FF gives 0! What magic :) This save from setting the accumulator
; to 0 for the walkingSoundIndex.
;
   eor #$FF
   bne .checkJoystickMovement       ; if not pushing the joystick
   sta walkingSoundIndex            ; then turn off the walking sound
   
.checkJoystickMovement
   ldx horPosP1                     ; get the climber's horizontal position
   bit allowedMotion                ; allowedMotion was determined during
                                    ; overscan
   bmi .checkForLeftJoystickMove
   
   cpx #CLIMBER_XMAX                ; if the climber has reached his right
   bcs .doneHorizontalCalculations  ; most edge then don't move him
   
.moveClimberRight
   inx                              ; move the climber right 1 pixel
   lda #$0F                         ; make the climber face right
   bne .setReflectPosP1             ; same as jmp but saves a byte
   
.checkForLeftJoystickMove
   bvs .checkForDownJoystickMove    ; value was bit'd above

   cpx #CLIMBER_XMIN                ; if the climber has reached his left
   bcc .doneHorizontalCalculations  ; most edge then don't move him
   
.moveClimberLeft
   dex                              ; move the climber left 1 pixel
   lda #$00                         ; make the climber face left
.setReflectPosP1
   sta playerReflect                ; keep the reflect value of the climber
   stx horPosP1
   bpl .doneHorizontalCalculations
   
.checkForDownJoystickMove
   lda allowedMotion
   and #DOWN_MOTION_MASK

   bne .checkForUpJoystickMove      ; player not pushing joystick down

   lda verPosP1                     ; if the climber has reached his lower
   cmp #YMIN+1                      ; bound then don't move him
   bcc DoneGameCalculations
   
.moveClimberDown
   dec verPosP1                     ; move the climber down 1 pixel
   bne .doneVerticalCalculations    ; verPosP1 will never be zero
   
.checkForUpJoystickMove
   lda allowedMotion
   and #UP_MOTION_MASK

.doneGameCalc
   bne DoneGameCalculations         ; player not pushing joystick up
   
   lda verPosP1                     ; if the climber has reached his upper
   cmp #YMAX                        ; bound then don't move him
.doneGameCalculations
   bcs DoneGameCalculations

.moveClimberUp
   inc verPosP1                     ; move climber up 1 pixel
   
.doneVerticalCalculations  
   ldx #$00                         ; don't reflect the climber when moving
   stx playerReflect                ; vertically
   lda gameClock                    ; get the game clock for player animation
   lsr                              ; updated every 4 frames
   lsr
   and #$01
   tax

   lda LowVerticalMovementTable,x   ; load the pointers to the animation
   sta playerGraphicLSB             ; frame data
   lda #>VerticalMoveTables
   sta playerPointer+1

   ldy #<VerticalColors - KERNEL_HEIGHT - 1 ; get the pointers for the
                                            ; vertical colors
.setVerticalColorPointer
   sty playerColorsLSB
   bne DoneGameCalculations
   
.doneHorizontalCalculations
   lda gameClock                    ; get the game clock for player animation
   and #$03                         ; 4 frames of horizontal animation
   tax
   lda LowHorizontalMovementTable,x ; load the pointers to the animation
   sta playerGraphicLSB             ; frame data
   lda #>HorizontalMoveTables
   sta playerPointer+1
   
   lda #<HorizontalColors - KERNEL_HEIGHT - 1
   sta playerColorsLSB
   lda #>ClimberColors
   sta playerColorPointer+1
   bmi .checkForDownJoystickMove    ; D7 always high
                                    ; (MSB will always be > $F0)
   
DoneGameCalculations
;
; Here we will determine which literal gets placed in the graphics pointers
; to be displayed in the score kernel.
;
   ldx #$0A
   lda #>Level0                     ; number fonts and level literal reside
                                    ; on the same page!!
   ldy #<Blank
.setMSBLoop
   sta graphicsPointers+1,x         ; set the MSB pointers to display status
   sty graphicsPointers,x
   dex                              ; in the score kernel
   dex                              ; level literal resides on the same page
   bpl .setMSBLoop                  ; so set the MSB to the same value
   
   lda gameSelection                ; get the game selection
   lsr
   beq SetupEnhancedParameters
   jmp SetPlayerGraphics            ; skip ball and score draw if not in
                                    ; enhanced mode
SetupEnhancedParameters
   lda ballTimer                    ; if it's not time to reset the ball
   bpl DrawScoreOrBonus             ; position then skip to draw the score or
                                    ; bonus literals
   lda #BALL_START_TIMER            ; reset the ball timer
   sta ballTimer
   
   jsr RandomByte                   ; get a random number
   sbc #BALL_XMIN                   ; make sure ball's horizontal position
   adc #XMAX                        ; is in range (BALL_XMIN <= a <= XMAX)
   bcs .storeNewBallPosition
   sbc #XMAX
.storeNewBallPosition
   sta horPosBL
   and #NUMGRP                      ; and the value with the number of groups to
   tax                              ; get the ball's new group number
                                    ; (range 0 - 7)
   lda VerticalBallPosition,x       ; look up the balls scanline based on
                                    ; it's group
   sta verPosBL

DrawScoreOrBonus
   ldy #$01
   sty loopCount                    ; how many times to loop (number of BCD)
   bit showBonusOrScore             ; which to show?
   bmi .drawScore                   ; D7 = 1 -- show the score
;
; draw the bonus timer
;
   dec loopCount

   ldx #$02                         ; load the TIME literal in
   lda #<Time2                      ; graphic pointers
   sta graphicsPointers+2
   lda #<Time1
   sta graphicsPointers
   ldy #bonusTimer-score            ; used as an offset to draw score or
                                    ; timer
.drawScore
   ldx #$06+2
   lda #<zero
   sta graphicsPointers+10
   sta graphicsPointers+8
   
BCDToDigitsLoop
   dex
   dex
   sty temp
   lda score,y                      ; get the value to display
                                    ; (score or timer)
   pha
   and #$0F                         ; mask the upper nybbles and move it to y
   tay                              ; to read number table
   lda NumberTable,y                ; get the LSB for the number to show
   sta graphicsPointers,x           ; store it in the graphics pointer
   dex
   dex
   pla
   lsr                              ; move upper nybble to the lower nybble
   lsr
   lsr
   lsr
   tay                              ; move it to y to read number table
   lda NumberTable,y                ; get the LSB for the number to show
   sta graphicsPointers,x           ; store it in the graphics pointer
   ldy temp
   dey
   dec loopCount
   bpl BCDToDigitsLoop

   bit showBonusOrScore
   bmi .suppressZeroLoop
   ldx #$04
.suppressZeroLoop
   lda graphicsPointers,x           ; cycle through the graphics pointers to
   cmp #<zero                       ; find one that points to zero (starting 
   bne SetUpFallingObstacles        ; from the 4th pointer -- skipping last 2
                                    ; zeros)
   
   lda #<Blank                      ; if one is found then set the LSB to
   sta graphicsPointers,x           ; point to the space
   inx
   inx
   cpx #$08
   bcc .suppressZeroLoop
   
;----------------------------------------------------------
;
SetUpFallingObstacles
   lda lives                        ; if the game is over then skip the
   bmi .skipObstacle                ; obstacle falling routine
   
   lda gameState                    ; if the game is paused
   ora playerState                  ; or the player retrieved the ball then
   asl                              ; don't move the obstacle
   bmi .skipObstacle

   lda verPosObstacle               ; get the obstacle's vertical position
   bne .moveObstacleDown

   dec spawnTimer                   ; reduce the spawing timer
   bpl .skipObstacle                ; if not time to spawn then skip spawning
   
   lda gameSelection                ; if the user is not playing the advanced
   bne .skipObstacle                ; option then skip the spawning
   
   jsr RandomByte                   ; get a random number
   lsr
   cmp #NUM_OBSTACLES+1             ; if the number is greater than the
   bcs .skipObstacle                ; number of obstacles then don't spawn
   sta obstacleType                 ; keep the item number for later
   tax
   lda #STARTING_SPAWN_TIME
   sta spawnTimer                   ; reset the obstacle spawn timer

   asl                              ; a = 0
   sta obstacleDirection            ; set the obstacle direction to fall down
   
   lda #>ObstacleSprites            ; set the MSB of the obstacle
   sta obstaclePointer+1
   lda ObstacleLSB,x
   sta obstacleGraphicLSB
   lda horPosP1                     ; get horizontal position of the climber
   adc #FAIR_OBSTACLE_DISTANCE      ; offset the value by the fair obstacle
                                    ; distance
   cmp #CLIMBER_XMAX                ; if it's less than the maximum x then
   bcc .setObstalceHorizontalPosition; set
   sbc #(FAIR_OBSTACLE_DISTANCE * 2); make the object appear to the right of
                                    ; the climber
.setObstalceHorizontalPosition
   sta horPosObstacle               ; set the horizontal position of the
                                    ; obstacle
   lda #KERNEL_HEIGHT
   sta verPosObstacle               ; place the obstacle at the top of the
                                    ; playfield
.moveObstacleDown
   lda #4
   sta AUDC0
   sta AUDV0
   jsr CheckObstacleHorizontalPos   ; the routine could go here to save 4
                                    ; bytes I choose to have a separate
                                    ; subroutine so I'd have more control
                                    ; over where it can go
                                    ; (also to avoid any branch out of range
                                    ; errors)
   dec verPosObstacle
   lda verPosObstacle
   eor #$FF                         ; negate the obstacle's vertical position
   clc
   adc #$01
   lsr                              ; divide the value by 6
   lsr                              ; valid values for AUDFx %xxx11111
   lsr
   sta AUDF0
   bne SetPlayerGraphics
   sta AUDV0                        ; turn off the falling sound
.skipObstacle
SetPlayerGraphics
   lda playerReflect                ; player reflect held in RAM because
   sta REFP1                        ; level data for kernel will change it
   
   bit playerState                  ; if the climber collided with anything
   bmi .skipWalkingSound            ; don't play walking sound
   bvs .skipWalkingSound
   lda gameState                    ; also if the game is over don't play the
   cmp #GAME_OVER_STATE             ; walking sound
   beq .skipWalkingSound
   asl                              ; shift player state left to check for
   bmi .skipWalkingSound            ; pause state (no walking sound)
;
; play the walking sound
;
   ldx walkingSoundIndex
   lda AudioControl,x
   sta AUDC1
   lda VolumeControl,x
   sta AUDV1
   lda WalkingSound,x
   sta AUDF1
   bne .skipReversedGirderSound
   
.skipWalkingSound
   lda fireSoundIndex
   bmi .skipReversedGirderSound
   dec fireSoundIndex
;
; taken from SCSIcide incorrect data bit sound
; I hope you don't mind Joe ;-)
;
   sta AUDV1
   lda #$0B
   sta AUDF1
   lda #$07
   sta AUDC1
   
.skipReversedGirderSound
   ldy #BM_SIZE_2
   sty NUSIZ0                       ; set the size of the players to 1 clock
   sty NUSIZ1                       ; and their missiles to 2 clocks (M1 not
                                    ; used)
   sty VDELP1                       ; don't vertically delay climber

   lda levelBCD                     ; get the current level number
   jsr DetermineLevelIndex

.setLevelColors
   tax                              ; used for table look up
   lda PlatformColors-1,x           ; load the platform colors
   sta platformColor
   lda GameBackgroundColors-1,x
   sta backgroundColor
   sta COLUBK
;
; Position all the game objects horizontally. This routine also positions M1.
; The values for the M1 move will be redone in the kernel since M1 is
; repositioned on the fly.
;
; The subtraction *MUST* start @ cycle 17 for this to work properly!!
;

PositionObjects
   ldx #$05                         ; position 4 objects
.positionObjectsLoop                ; (GRP0/GRP1/M0/M1/BALL)
   sta WSYNC                        ; wait for the next scan line before
                                    ; positioning
   lda #NUMGRP                      ; set the groupCount and ladder colors
   sta groupCount                   ; for each loop. It wastes processing
   lda #LADDER_COLOR                ; time but saves precious ROM bytes :)
   sta.w COLUPF
   lda horPosObstacle-1,x           ; get the objects horizontal position
   sec
CoarseMoveObjects
   sbc #$0F                         ; subtract by 15 until the value crosses 0
   bcs CoarseMoveObjects
   
   CHECKPAGE CoarseMoveObjects      ; make sure this doesn't cross a page
   
   sta RESP0-1,x                    ; set the objects coarse position
   tay                              ; use the remainder for an offset to read
   lda HorizontalMoveTable-240,y    ; the fine position table (object moved
                                    ; +/- 8 pixels)
   sta HMP0-1,x                     ; store in the object's fine movement
                                    ; register
   dex                              ; continue looping until x = 0
   bne .positionObjectsLoop
   
   lda #GIRDER_COLOR                ; load the girder colors for player GRP0
   sta WSYNC                        ; wait for next scan line
;-------------------------
   sta HMOVE
   sta COLUP0

   stx walkwayPF1                   ; clear the walkway playfield values
   stx walkwayPF2                   ; remember x = 0 from the above position
                                    ; routine
   stx REFP0                        ; don't reflect the GRP0

;---------------------------------------------------------SetupPlayerPointers
;
; Setup the player pointers and offsets for the game display kernel. These
; pointers to ROM data will be offsets to the true data. This is done so the
; y-register can be used to count kernel lines. This saves those precious
; cycles in the display kernel.
;
SetupPlayerPointers
;
; calculate the climber offset
;
   sec
   lda #KERNEL_HEIGHT
   tay                              ; used for the kernel
   sbc verPosP1                     ; subtract the climber vertical position
   adc #CLIMBER_HEIGHT-1            ; add back in the climber height to get
                                    ; the offset
   sta climberOffset                ; this is decremented in the kernel to
                                    ; determine when the y-register is in
                                    ; range to draw the climber
   clc
   adc playerGraphicLSB             ; add value to the graphic pointer LSB
   sta playerPointer                ; so the indirect read doesn't cross a
                                    ; page boundary
   lda climberOffset
   clc
   adc playerColorsLSB              ; now calculate the color pointer LSB the
   sta playerColorPointer           ; same way

;---------------------------------------------------------------DisplayKernel
;
; The screen must be updated each frame on the 2600. Here the program waits
; for vertical blank to end and then jumps to the appropriate display kernel
; (i.e. GameKernel or TitleDisplayKernel). If the game is in attract mode
; then the TIA is turned off to save CRT burn.
;
DisplayKernel SUBROUTINE
   sta HMCLR                        ; clear horizontal movement
   sta CXCLR                        ; clear the previous frame collisions
.loop
   ldx INTIM                        ; big timer wait
   bne .loop
   
   stx WSYNC                        ; end the current scan line
;-------------------------
   stx HMOVE
   
   bit attractMode                  ; check the attract mode if D7 low
   bpl .enableTIA                   ; enable TIA output
.disableTIA
   ldx #D1                          ; D7 high so disable TIA output
.enableTIA
   stx VBLANK                       ; set TIA value for output
   bit gameState
   bmi TitleDisplayKernel
   
   sec
   tya                              ; y holds the KERNEL_HEIGHT

   sbc verPosObstacle               ; subtract the vertical position of the 
   adc #OBSTACLE_HEIGHT-1           ; obstacle and add it's height back in to
                                    ; get the offset
   sta obstacleOffset               ; this is decremented in the kernel to
                                    ; determine when the y-register is in
                                    ; range to draw the obstacle
   clc
   adc obstacleGraphicLSB           ; add value to the obstacle pointer LSB
   sta obstaclePointer              ; so the indirect read doesn't cross a
                                    ; page boundary
   ldx backgroundColor

   lda #VERTICAL_DELAY
   sta VDELP0                       ; vertically delay the girders
   sta VDELBL                       ; and the ball
   nop
   jmp KernelStart                  ; = @43
   
;----------------------------------------------------------TitleDisplayKernel
;
; The title screen display is drawn here.
;
TitleDisplayKernel SUBROUTINE
   lda #$04
   sta groupCount                   ; groupCount used for table lookup
   sta WSYNC
;------------------------------------------------
   sta HMOVE

.atariAgePresentsKernel
   lsr
   sta loopCount                    ; set loopCount to 2 (cycles to draw 2
                                    ; groups of literals)
   jsr DisplayGraphicsLiteral       ; draw the literals

   ldx #$02
   stx loopCount
   inx
   jsr SkipLinesLoop
   
   lda #%11111110                   ; set the playfield data for the "wood"
   sta PF2                          ; background for Climber 5 literal
                                    ; (playfield set to reflect)
   ldx #2
   jsr SkipLinesLoop
   
   jsr DisplayGraphicsLiteral       ; draw Climber 5 literal

   ldx #8
   jsr SkipLinesLoop
   
                                    ; stop drawing "wood" background for
   stx PF2                          ; Climber 5 literal
   
   ldx #21                          ; draw 21 blank lines
   jsr SkipLinesLoop
   
   lda #>OriginalLiteral
   sta graphicGroupPointer+1
   
   lda #$01
   sta gameSelectionCount


   sta WSYNC
;------------------------------------------------
   sta HMOVE
   lda #<OriginalLiteral
   sta graphicGroupPointer
   
   lda #TEXT_HEIGHT-1
   sta fontHeight
   
   lda #WHITE
   ldy gameSelection
   cpy #MAXSELECTLEVEL
   bne .setColor
   lda #RED
.setColor
   inc groupCount
   inc loopCount
   jsr BeginningGraphicLoop
   
DrawGameSelections
   sta WSYNC
;------------------------------------------------
   sta HMOVE
   ldy gameSelectionCount
   lda GameSelectionGroupLow,y
   sta graphicGroupPointer

   lda #TEXT_HEIGHT-1
   sta fontHeight
   
   lda #WHITE
   
   cpy gameSelection
   bne .drawLiterals
   
   lda #RED
.drawLiterals
   inc groupCount
   inc loopCount
   jsr BeginningGraphicLoop
   dec gameSelectionCount
   bpl DrawGameSelections
   
   ldx #19                          ; skip 19 lines
   jsr SkipLinesLoop
   
   stx groupCount
   inc loopCount                    ; only draw 1 literal (was 0 before this)
   jsr DisplayGraphicsLiteral       ; draw copyright literal

;--------------------------------------------------------------------Overscan
;
Overscan
   lda #OVERSCAN_TIME               ; get the value for the overscan wait
                                    ; time
   ldx #D1
   sta WSYNC                        ; end the last scanline
   stx VBLANK                       ; turn off TIA (D1 = 1)
   sta TIM64T                       ; set the timer for the "big wait"

   lda gameState                    ; get the current game state
   beq DetermineClimberAllowedMotion
   jmp DoneOverscan                 ; if the game isn't being played then
                                    ; leave overscan
DetermineClimberAllowedMotion
   ldx #NUMGRP-1                    ; cycle through all platforms to see if
   lda verPosP1                     ; the climber is "standing" on a platform
.determineWalkwayLoop
   cmp WalkwayValues,x
   beq .walkwayFound                ; the climber is standing on a platform
   dex
   bpl .determineWalkwayLoop
;
; climber not standing on a platform
;
   lda #%11011111
   bit playerState                  ; if the player was hit and no walkway
   bmi .setAllowedMotion            ; was found make the player fall
   
   lda SWCHA                        ; don't allow horizontal movement but
   ora #%11000000                   ; allow vertical movement (climber is 
   bmi .setAllowedMotion            ; between platforms)
.walkwayFound
   lda #%11110000                   ; masking to not allow joystick movement
   bit playerState                  ; D7 = 1 so don't move climber
   bmi .setAllowedMotion
   and SWCHA                        ; allow horizontal movement
   
   sta allowedMotion

   lda horPosP1                     ; get the climber horizontal position
   cmp #RIGHT_PF_BOUND
   bcs .noVerticalMotion
   cmp #LEFT_PF_BOUND               ; if the climber is outside the playfield
   bcc .noVerticalMotion            ; boundaries then he cannot move vertically
   
; Understanding how the climber's vertical movement is calculated...
; ------------------------------------------------------------------
;
; The vertical movement of the climber is calculated instead of reading the
; CXP1FB register. This would have been easier but wouldn't have given the
; results I'm trying to achieve. The ladders don't extend past the platform
; so using the collision register wouldn't have allowed the player to move
; down. Also if the player was on a ladder it would make the player move
; past the platform. So I came up with this algorithm to calculate when the
; climber is on a ladder.
;****************************************************************************
; Theory behind the playfield computations
;
; The playfield is broken into chunks of 32 (based on the horizontal
; positions of the objects).
; The objects have a PF range of 7 - 135. (135 - 7) / 4 PF sections = 32
;
; The PF has 4 pixel res and there are 40 bits across.
;
; ----------------------- PF Pixels -----------------------
; |  PF0  |   PF1   |   PF2   |   PF2   |   PF1   |  PF0  |
; |68 . 83|84 .. 115|116.. 147|148.. 179|180.. 211|212.227|
;
;                        -- or --
;
; ----------------------- PF Pixels -----------------------
; |  PF0  |   PF1   |   PF2   |   PF2   |   PF1   |  PF0  |
; |0  . 15|16 ..  47|48 ..  79|80 .. 111|112.. 143|144.159|
;
;
; The climber has a horizontal range of 3 - 144 (72 - 213)
; In relationship to the PF that would be (80 - 221) ... pixels shifted by 8
; because of HMOVE
;
; And a PF range of 7 - 135 (76 - 204) -or- (84 - 212) ... again shifting 8
; pixels
; There are 4 sections of the PF that we're concerned about (PF1/PF2/PF2/PF1)
; So we subtract by 32 [(212 - 84) / 4] to find the PF section the climber
; is in. We keep subtracting until the value is between the PF1 values
; (i.e. less than 116)

   sbc #LEFT_PF_BOUND               ; subtract LEFT_PF_BOUND to remove offset
   ldy #-1                          ; when done y will hold the PF section
                                    ; the climber is in (0 - 3)
.computePFSection
   iny                              ; increase the playfield section
   sbc #32                          ; reduce the value to find the playfield
                                    ; section
   bcs .computePFSection
   adc #32                          ; add the value back in -- value went
                                    ; negative
   lsr
   lsr
   sty pfSection                    ; y holds the PF section (0 - 3)
   tay

.setPfSection
   lda pfSection                    ; the playfield is reflected so sections
   beq .loadPF1Vars                 ; 0 and 3 are for PF1 and sections 1 and
   cmp #$03                         ; 2 are for PF2
   bcs .loadPF1Vars
   
.loadPF2Vars
   lda pf2Vars,x
   sta upMotionCheck
   lda pf2Vars-1,x
   sta downMotionCheck
   bcc .done
   
.loadPF1Vars
   lda pf1Vars,x
   sta upMotionCheck
   lda pf1Vars-1,x
   sta downMotionCheck

.done
   lsr pfSection                    ; shift the pfSection to determine if the
   bcc .loadAndValue                ; playfield bits are flipped (sections 1
                                    ; and 3 are flipped)
   tya
   eor #$07
   tay
.loadAndValue
   lda upMotionCheck
   and LadderMasking,y
   bne .checkForDown
   ldx #%00010000
.checkForDown
   lda downMotionCheck
   and LadderMasking,y
   bne .setVerticalMotion
   txa
   ora #%00100000
   tax
   NOP_W
   
.noVerticalMotion
   ldx #%00110000
   
.setVerticalMotion
   txa
   ora allowedMotion                ; or with allowed motion to get climber
.setAllowedMotion                   ; motion
   ora #%00001111
   sta allowedMotion                ; store the value in RAM to be used
                                    ; during VBLANK processing
CheckPlayerCollisions
   lda playerState                  ; get the current player state
   bmi .playDeathSound              ; if climber previously hit -- play death
                                    ; sound
   ora CXP1FB                       ; D6 = player1 and ball collision
   and #%01000000                   ; mask to get P1/BALL collision value
   bne .playerBallCollision
   
   lda gameSelection                ; get the current game selection
   lsr
   bne .checkPlayerToGirderCollision; if not enhanced then skip bonus timer
                                    ; check
   
   lda bonusTimer                   ; get the bonus timer value
   bne .checkPlayerToGirderCollision; if it hadn't reached 0 then check for
                                    ; collisions
   lda #%10000000                   ; show the player collided to simulate
   bmi .playerGirderCollision       ; the player losing a life
   
.checkObstacleCollision
   lda CXPPMM                       ; read the player collisions
                                    ; (stored in D7)
   bpl .overscanWait                ; if no collisions jump to the big wait
   ldx obstacleType                 ; get the obstacle type
   cpx #MAX_BONUS_ITEMS             ; see if the obstacle is harmful to the
                                    ; climber
   
   IF CHEAT_ENABLED

   bcs .overscanWait                ; don't kill player by falling obstacles                 
   
   ELSE
   
   bcs .playerGirderCollision       ; harmful obstacle -- simulate life lost
   
   ENDIF
   
.bonusItemCaught
   lda #$00
   sta AUDV0                        ; turn off the obstacle falling sound
   ldx obstacleType                 ; get the type of obstacle
   cpx bonusItemCount               ; compare it with the next correct type
   bne .notCorrectSequence
.correctSequence
   cpx #MAX_BONUS_ITEMS-1
   bcs .resetBonusItemCount
   inc bonusItemCount               ; increment the next correct object type
   bne .incrementScore              ; unconditional branch
.notCorrectSequence
   tax                              ; give the player the lowest possible
                                    ; bonus value for this item
.resetBonusItemCount
   sta bonusItemCount
.incrementScore
   sta verPosObstacle               ; clear the obstacle's vertical position
   jsr IncrementBonusItemScore
   lda #$80                         ; set the spawn timer to not spawn
   sta spawnTimer                   ; another obstacle for 128 frames
   bmi DoneOverscan                 ; same as jmp -- saves a byte
  
.checkPlayerToGirderCollision

   IF CHEAT_ENABLED
   
   lda #$00                         ; don't allow a girder to kill player

   ELSE
   
   lda CXM0P                        ; D7 = missile 0 and player 1 collision
   
   ENDIF
   
   and #%10000000                   ; mask missile 0 and player 0 collision
   bpl .checkObstacleCollision      ; if climber didn't hit girder then check
                                    ; obstacles
.playerGirderCollision
   sta playerState                  ; store CXM0P in playerState
   lda #21
   sta soundIndex                   ; serves as an index for sound time
   jsr TurnOffSounds                ; turn off any game sounds being played
   iny                              ; y now = 1
   sty duration                     ; set duration to 1 so it goes off for
                                    ; this round
.playDeathSound
   dec duration                     ; once duration (hold note) reaches 0
                                    ; then play the next note
.overscanWait
   bpl DoneOverscan                 ; hold previous note -- leave overscan
   
.playNextDeathNote
   lda #10                          ; set the hold note duration to 10 frames
   sta duration
   ldx soundCounter                 ; used as the sound frequency
   inc soundCounter
   jsr PlaySound                    ; play the current note
   bne DoneOverscan                 ; if soundIndex !=0 then leave overscan
   lda #$00
   sta playerState                  ; show the player has not been hit
   sta walkingSoundIndex
   
   dec lives                        ; decrease the number of lives
   bmi .gameOver                    ; number of lives is negative
   
   jsr RestartLevel
   bne .turnOffSound

.gameOver   
   lda #GAME_OVER_STATE             ; set the game state to show game over
   sta gameState

   jsr ShowAllGirders               ; turn all girder graphics on
   
   lda #%10000000                   ; show score when in game over state
   sta showBonusOrScore
   
   jsr SetAttractModeFor30Seconds   ; set attract mode to cycle between title
                                    ; and game screen ~ every 30 seconds
   bne .turnOffSound                ; implicit jmp (saves 1 byte)
   
.playerBallCollision
   bit playerState                  ; get the current player state
   bvs .playSuccessSound            ; if player previously retrieved ball
                                    ; then play the success sound
   sta playerState                  ; store player/ball collision for later
                                    ; use
   lda bonusTimer
   jsr IncrementScore
   
   jsr TurnOffSounds                ; turn off any game sounds being played
   sty duration                     ; set duration to 1 so it goes off for
                                    ; this round
   lda #$06                         ; serves an index for success sound
   sta soundIndex                   ; values
   
.playSuccessSound
   ldx #$FF                         ; set the allowed motion to not allow the
   stx allowedMotion                ; climber to move
   
   dec duration                     ; once duration (hold note) reaches 0
                                    ; then play the next note
   bpl DoneOverscan                 ; hold previous note -- leave overscan
   
   lda #$09                         ; set hold note duration to 10 frames
   sta duration
   
   ldx soundIndex                   ; get the sound value for the frequency
   
   jsr PlaySound                    ; play the current note
   bne DoneOverscan                 ; if soundIndex !=0 then leave overscan

.incrementLevel
   lda levelBCD                     ; get the level number (BCD)
   cmp #LEVEL_MAX_OUT               ; if the player is at highest level then
   bcs .continueGame                ; don't increase level number
   
   sed                              ; set to decimal mode
   adc #$01                         ; increase the value by 1
   sta levelBCD   
   cld                              ; clear decimal mode
   
.continueGame
   jsr NewLevel                     ; restart with the current level number
   
.turnOffSound
   jsr TurnOffSounds

DoneOverscan
   jmp MainLoop
   
;
; NOTE: Level literals and number fonts should reside on the same page
;
Level0
   .byte $1F ;|...XXXXX|
   .byte $10 ;|...X....|
   .byte $10 ;|...X....|
   .byte $10 ;|...X....|
   .byte $10 ;|...X....|
Level1
   .byte $7C ;|.XXXXX..|
   .byte $40 ;|.X......|
   .byte $79 ;|.XXXX..X|
   .byte $41 ;|.X.....X|
   .byte $7D ;|.XXXXX.X|
Level2
   .byte $47 ;|.X...XXX|
   .byte $A4 ;|X.X..X..|
   .byte $17 ;|...X.XXX|
   .byte $14 ;|...X X..|
   .byte $17 ;|...X.XXX|   
Level3
   .byte $DF ;|XX.XXXXX|
   .byte $10 ;|...X....|
   .byte $90 ;|X..X....|
   .byte $10 ;|...X....|
LevelInitTable
   .byte $D0 ;|XX.X....|

   .byte MAX_BONUS_ITEMS
   .byte STARTING_TIMER_BONUS
   .byte BALL_START_TIMER
   .byte CLIMBER_X_START-FAIR_OBSTACLE_DISTANCE ; can be any value 
   .byte CLIMBER_X_START
   .byte CLIMBER_Y_START
   .byte $00
   .byte BALL_XMIN
   
Blank
   REPEAT AA_FONT_HEIGHT - 2        ; last byte shared with
      .byte $00                     ; LivesIndicatorCount
   REPEND
   
LivesIndicatorCount
   .byte ONE_COPY,TWO_COPIES,THREE_COPIES
   
zero
   .byte $3C; |..XXXX..|
   .byte $66; |.XX..XX.|
   .byte $66; |.XX..XX.|
   .byte $66; |.XX..XX.|
three
   .byte $3C; |..XXXX..|
   .byte $46; |.X...XX.|
   .byte $0C; |....XX..|
   .byte $46; |.X...XX.|
six   
   .byte $3C; |..XXXX..|
   .byte $66; |.XX..XX.|
   .byte $7C; |.XXXXX..|
   .byte $60; |.XX.....|
eight   
   .byte $3C; |..XXXX..|
   .byte $66; |.XX..XX.|
   .byte $3C; |..XXXX..|
   .byte $66; |.XX..XX.|
nine   
   .byte $3C; |..XXXX..|
   .byte $06; |.....XX.|   
   .byte $3E; |..XXXXX.|
   .byte $66; |.XX..XX.|
one
   .byte $3C; |..XXXX..|
   .byte $18; |...XX...|
   .byte $18; |...XX...|
   .byte $38; |..XXX...|
seven   
   .byte $18; |...XX...|
   .byte $18; |...XX...|
   .byte $0C; |....XX..|
   .byte $06; |.....XX.|
two
   .byte $7E; |.XXXXXX.|
   .byte $60; |.XX.....|
   .byte $3C; |..XXXX..|
   .byte $06; |.....XX.|
five   
   .byte $7C; |.XXXXX..|
   .byte $06; |.....XX.|
   .byte $7C; |.XXXXX..|
   .byte $60; |.XX.....|
   .byte $7E; |.XXXXXX.|
four   
   .byte $0C; |....XX..|
   .byte $0C; |....XX..|
   .byte $7E; |.XXXXXX.|   
   .byte $4C; |.X..XX..|
   .byte $4C; |.X..XX..|
   
Time1
   .byte $4A;|.X..X.X.|
   .byte $4A;|.X..X.X.|
   .byte $4A;|.X..X.X.|
   .byte $4A;|.X..X.X.|
   .byte $EB;|XXX.X.XX|
Time2   
   .byte $AE;|X.X.XXX.|
   .byte $A8;|X.X.X...|
   .byte $AE;|X.X.XXX.|
   .byte $A8;|X.X.X...|
   .byte $EE;|XXX.XXX.|
   
   CHECKPAGE Time2
   
GameSelectionGroupLow
   .byte <AdvancedLiteral
   .byte <NormalLiteral
   
Copyright0
   .byte $38 ;|..XXX...|
   .byte $44 ;|.X...X..|
   .byte $BA ;|X.XXX.X.|
   .byte $A2 ;|X.X...X.|
   .byte $BA ;|X.XXX.X.|
   .byte $44 ;|.X...X..|
   .byte $38 ;|..XXX...|
   
AudioControl
   .byte $00,$0E
VolumeControl
   .byte $00,$06
WalkingSound
   .byte $00,$08

IncrementBonusItemScore
   lda levelBCD
   cmp #$20
   bcc .determineBonusAmount
   lda #$20
.determineBonusAmount
   jsr DetermineLevelIndex
   lda BonusAmountTable,x
   
;--------------------------------------------------------------IncrementScore
; a is set the value to increment the score by before coming into this
; routine
;
IncrementScore
   ldy gameSelection
   cpy #ORIGINAL_MODE
   beq .leaveSubroutine
   sed                              ; set decimal mode
   adc score+1                      ; add to score LSB (carry clear)
   sta score+1                      ; store the value in score LSB
   lda #$00                         ; take care of the carry
   adc score
   sta score
   cld                              ; clear decimal mode
   beq .showScore
   lda showBonusOrScore             ; get the current player state
   lsr                              ; bonus life indicator in carry bit
   bcs .showScore

   inc lives   
   lda #%10000001                   ; show the player gained a bonus life
   bne .setBonusOrScoreStatus
.showScore
   lda #%10000000
.orBonusOrScoreStatus
   ora showBonusOrScore             ; show the score now that it's been
.setBonusOrScoreStatus              ; increased
   sta showBonusOrScore
   rts
   
;---------------------------------------------------------DecrementBonusTimer
DecrementBonusTimer
   ldy #$00
   ldx bonusTimer
   beq .leaveSubroutine
   
   bit playerState                  ; get the current player state
   bvs .leaveSubroutine             ; if player previously retrieved ball
                                    ; then don't reduce timer
   cmp bonusTimer
   bcs .setToZero
   sta temp                         ; save reduction
   txa                              ; get the bonus timer
   sed                              ; set decimal mode
   sec                              ; set carry bif for subtraction
   sbc temp                         ; decrement the timer
   sta bonusTimer
   cld                              ; clear decimal mode
   bit showBonusOrScore             ; check status of the indicator screen
   bvs .showBonusTimer              ; show timer if the score was shown the
                                    ; last 2 counts
   bpl .leaveSubroutine             ; nothing to change
   lda #%11000000
   bmi .orBonusOrScoreStatus        ; or the value to keep extra life flag
.setToZero
   sty bonusTimer                   ; set the timer to 0
.showBonusTimer
   lda #%00000001                   ; and the value to keep extra life flag
   and showBonusOrScore
   sta showBonusOrScore
.leaveSubroutine
   rts
   
;-----------------------------------------------------CheckToFlashGirderColor
CheckToFlashGirderColor SUBROUTINE
   bit SWCHB                        ; check the console switch value
   sec                              ; set the carry bit for subtraction
   bvs .loadGirderGraphic           ; D6 = 1 left difficulty set to expert

.checkGirderFlashState
   sbc girderDirection,x            ; subtract the current start count
   bcs .resultPositive
   eor #$FF                         ; result < 0 so make it positive for the
   adc #$01                         ; comparison
.resultPositive
   cmp #FAIR_WARNING_TICK           ; check for 15 "ticks" before changing
                                    ; direction
.loadGirderGraphic
   lda #GIRDER_GRAPHIC              ; load the girder graphics (in enhanced
                                    ; so this is okay -- all girders on)
   bcs .setGirderGraphics           ; outside 15 "tick" window don't flash
   eor girderGraphics,x             ; eor makes the girder flicker and warn
                                    ; the player before girder changes
                                    ; direction
.setGirderGraphics
   sta girderGraphics,x             ; set the girder's graphic value
.leaveRoutine
   lda horPosP0,x
   rts

;--------------------------------------------------------------------NewLevel
;
; When a new level happens the current speed of the players will be adjusted.
;
NewLevel SUBROUTINE
   lda #BALL_STARTING_PLATFORM
   sta verPosBL                     ; reset the ball to the top rafter
   lda #BALL_XMIN                   ; position
   sta horPosBL

   ldx levelBCD                     ; get the current level number
   inx
   cpx #MAX_LEVEL
   bcc .calculateGirderSpeedIndex   ; if less than MAX_LEVEL set girder speed
   ldx #MAX_LEVEL                   ; keep the girder speed constant

.calculateGirderSpeedIndex
   stx girderSpeedIndex
   
   jsr RandomByte                   ; get a random byte
   sta temp                         ; hold it for later
   
   ldx #NUMGRP-2
.newLadderLoop
   txa                              ; move x to a to determine
                                    ; odd/even walkway
   lsr                              ; shift right to set the carry
   lda #$00
   ldy gameSelection                ; see if this is for the enhanced option
   bcs SetPF1Graphics               ; carry set so odd walkway
   
   cpy #ORIGINAL_MODE
   bne .setPF2GraphicsForAdvanced
   
   lda #EVEN_LADDER_PF2             ; set up ladders for the original game
   sta pf2Vars,x                    ; option
   
   lda #EVEN_LADDER_PF1
   bmi .setPF1                      ; same as jmp but saves 1 byte :)
   
.setPF2GraphicsForAdvanced
   sta pf2Vars,x                    ; mask the PF2 values for ladders

   jsr SetPFGraphics
   lda PossiblePF1Values,y

.setPF1
   sta pf1Vars,x
   bne .nextX
   
SetPF1Graphics
   cpy #ORIGINAL_MODE
   bne .setPF1GraphicsForAdvanced

   lda #ODD_LADDER_PF1
   sta pf1Vars,x
   
   lda #ODD_LADDER_PF2
   bmi .setPF2
   
.setPF1GraphicsForAdvanced
   sta pf1Vars,x
   jsr SetPFGraphics
   lda PossiblePF2Values,y
.setPF2
   sta pf2Vars,x
.nextX
   dex
   bpl .newLadderLoop
   
;----------------------------------------------------------------RestartLevel
;
RestartLevel
   ldx #NUMGRP                      ; load with NUMGRP so x=0 when done
   lda gameSelection                ; get the game selection
   lsr
   beq AdvancedResetStart           ; equal zero -- restart for advanced
   
   ldy levelBCD                     ; level number used to read masking value
   cpy #MAX_LEVEL                   ; table -- this will manipulate the
   bcc .readMaskingValue            ; girder start frequency for a new level
   ldy #MAX_LEVEL
.readMaskingValue
   lda GirderStartMaskingValue-1,y
   sta temp
   ldy #$01                         ; every other start count will be 1   
   
.resetStartCountLoop
   jsr RandomByte                   ; get a random number
   and temp                         ; mask the random number based on level
   cmp #FAIR_PIXEL_DELTA            ; make sure it's greater than fair
   bcs .setGroupStartCount          ; distance
   lda #FAIR_PIXEL_DELTA-1          ; set the start count from fair distance
.setGroupStartCount
   sta startCount-1,x
   lda #XMIN
   sta horPosP0-1,x                 ; position girders on the left
   dex
   beq SetInitLevelValues           ; x wrapped around then leave routine
   sty startCount-1,x               ; makes the girder start immediately
   sta horPosP0-1,x
   dex
   bpl .resetStartCountLoop
   
AdvancedResetStart SUBROUTINE
   jsr RandomByte                   ; get a random number for the start count
   cmp girderDirection,x            ; check accumulator against adjacent
                                    ; girder
   bne .setGirderPosition           ; not the same then okay to set :)

   eor #$FF                         ; they're the same so negate number to
   adc #$01-1                       ; make them travel in different
                                    ; directions
                                    ; NOTE: carry set here so adc #$01-1
                                    ; saves a byte
                                    ; (i.e. ADC M: A = A + M + C)
.setGirderPosition
   sta girderDirection-1,x          ; start count determines to move left or
                                    ; right
   sec
   sbc horPosP0,x                   ; make sure adjacentGirder <= a < XMAX
   adc #CLIMBER_X_START-4
   bcs .storePosition
   sbc #CLIMBER_X_START-4
   
.storePosition
   sta horPosP0-1,x                 ; store in the girders horizontal
                                    ; position
.nextGirder
   dex
   bne AdvancedResetStart
   
   lda horPosP0,x                   ; bottom girder now (x = 0)
   cmp #(XMAX / 2)                  ; which half of the screen it's
                                    ; positioned
   ldy girderDirection,x            ; y holds whether moving left or right
   bpl .movingRight
   
   bcs SetInitLevelValues           ; right side and moving left -- okay
   
.negateStartCount
   tya                              ; negate the start count to "flip" moving
   eor #$FF                         ; direction
   sta girderDirection,x
   NOP_W                            ; skips the next 2 instructions :)
   
.movingRight
   bcs .negateStartCount            ; right side moving right -- bad
   
SetInitLevelValues
   ldx #14
.initLoop
   cpx #9                           ; skip horPosBL value
   beq .nextLevelInit
   lda LevelInitTable-1,x           ; the values are offset by 1 so x = 0
   sta allowedMotion-1,x            ; when the loop finishes
.nextLevelInit
   dex
   bne .initLoop
   
   lda #%00000001                   ; keep the extra life indicator
   and showBonusOrScore
   sta showBonusOrScore
   
   lda #>HorizontalMoveFrame1       ; set animation frame so the climber is
   sta playerPointer+1              ; standing pointing left ready to go
   
   lda LowHorizontalMovementTable
   sta playerGraphicLSB
   
   stx REFP1                        ; don't refect the climber ( x = 0 )
   
   lda #<HorizontalColors - KERNEL_HEIGHT - 1
   sta playerColorsLSB
   lda #>HorizontalColors
   sta playerColorPointer+1
   rts

DisplayGraphicsLiteral
   sta WSYNC
;------------------------------------------------
   sta HMOVE                        ; 3
   
   ldy groupCount                   ; 2
   lda GraphicsGroupLow,y           ; 4
   sta graphicGroupPointer          ; 3
   lda #>CopyrightLiteral           ; 2
   sta graphicGroupPointer+1        ; 3
   lda FontHeightTable,y            ; 3
   sta fontHeight                   ; 3
   
   lda #<FontColorTable             ; 4
   sta fontColorPointer             ; 3
   
   lda #>FontColorTable             ; 4
   sta fontColorPointer+1           ; 3
   
   lda (fontColorPointer),y         ; 5
   
BeginningGraphicLoop
   sta COLUP0                       ; 3
   sta COLUP1                       ; 3
   
   ldy #$0B                         ; 2
   ldx #$02                         ; 2

.storeGraphicLoop 
   sta WSYNC
;------------------------------------------------
   sta HMOVE                        ; 3
.graphicPointerLoop
   lda (graphicGroupPointer),y      ; 5
   sta graphicsPointers,y           ; 5
   dey                              ; 2
   dex                              ; 2
   bpl .graphicPointerLoop          ; 2³

   ldx #$02                         ; 2
   tya                              ; 2
   bpl .storeGraphicLoop            ; 2³
   
   sta WSYNC
;------------------------------------------------
   sta HMOVE
   
   jsr DrawIt
   dec groupCount
   dec loopCount
   bne DisplayGraphicsLiteral
   rts

GraphicsGroupLow
   .byte <CopyrightLiteral
   .byte <Climber5Literal
   .byte <ClimberLiteral
   .byte <PresentsLiteral
   .byte <AtariAgeLiteral
   
GameBackgroundColors
   .byte BLACK, GREEN_BLUE, PURPLE, DARK_PURPLE, LTBLUE_PURPLE

PlatformColors
   .byte PINK, LTBLUE_PURPLE+2, PALE_GREEN, LTORANGE,WHITE

FontColorTable
   .byte WHITE, BROWN, BROWN, WHITE, ATARI_AGE_BLUE
   
VerticalBallPosition
BALL_POSITION SET BALL_STARTING_PLATFORM - ((NUMGRP - 1) * LADDER_SECTION_HEIGHT)
   REPEAT   NUMGRP
      .byte BALL_POSITION
BALL_POSITION SET BALL_POSITION + LADDER_SECTION_HEIGHT
   REPEND
   .byte BALL_STARTING_PLATFORM
   
NumberTable
   .byte <zero,<one,<two,<three,<four
   .byte <five,<six,<seven,<eight,<nine
   
;---------------------------------------------------------------SetPFGraphics
SetPFGraphics
   lda temp
   and INTIM                        ; and with the timer for sort of a better
                                    ; random ladder pattern
.checkValue
   cmp #$0A                         ; make sure the value isn't greater than
   bcc .setIndex                    ; the look-up table values
.reduceValue
   sbc #$09                         ; subtract by the maximum table entries
   bcs .checkValue                  ; until the value is within range
.setIndex
   dec temp                         ; reduce the current random number for
                                    ; next check
   tay                              ; move the value to y for table lookup
   rts
 
PossiblePF1Values
   .byte $C0,$CC,$C3,$30,$33,$0C  
PossiblePF2Values
   .byte $30,$33,$0C,$03,$80,$98,$86,$60,$66,$63
   
   BOUNDARY (KERNEL_HEIGHT - 6)
   
HorizontalMoveTables
HorizontalMoveFrame1
   .byte $36 ;|..XX.XX.|
   .byte $12 ;|...X..X.|
   .byte $36 ;|..XX.XX.|
   .byte $36 ;|..XX.XX.|
   .byte $3E ;|..XXXXX.|
   .byte $32 ;|..XX..X.|
   .byte $3A ;|..XXX.X.|
   .byte $F9 ;|XXXXX..X|
   .byte $3F ;|..XXXXXX|
LivesIndicator
   .byte $1C ;|...XXX..|
   .byte $3E ;|..XXXXX.|
   .byte $7F ;|.XXXXXXX|
   .byte $7F ;|.XXXXXXX|
   .byte $5F ;|.X.XXXXX|
   .byte $3E ;|..XXXXX.|
   .byte $FE ;|XXXXXXX.|
   .byte $3E ;|..XXXXX.|   
   .byte $1C ;|...XXX..|

HorizontalMoveFrame2
   .byte $61 ;|.XX....X|
   .byte $27 ;|..X..XXX|
   .byte $6F ;|.XX.XXXX|
   .byte $6E ;|.XX.XXX.|
   .byte $7E ;|.XXXXXX.|
   .byte $72 ;|.XXX..X.|
   .byte $23 ;|..X...XX|
   .byte $2B ;|..X.X.XX|
   .byte $3E ;|..XXXXX.|
   .byte $1C ;|...XXX..|
   .byte $3E ;|..XXXXX.|
   .byte $7F ;|.XXXXXXX|
   .byte $7F ;|.XXXXXXX|
   .byte $5F ;|.X.XXXXX|
   .byte $3E ;|..XXXXX.|
   .byte $FE ;|XXXXXXX.|
   .byte $3E ;|..XXXXX.|   
   .byte $1C ;|...XXX..|

HorizontalMoveFrame3
   .byte $03 ;|......XX|
   .byte $07 ;|.....XXX|
   .byte $66 ;|.XX..XX.|
   .byte $2F ;|.X.XXXX.|
   .byte $7E ;|.XXXXXX.|
   .byte $76 ;|.XXX.XX.|
   .byte $3A ;|..XXX.X.|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|
   .byte $9C ;|X..XXX..|
   .byte $3E ;|..XXXXX.|
   .byte $7F ;|.XXXXXXX|
   .byte $7F ;|.XXXXXXX|
   .byte $5F ;|.X.XXXXX|
   .byte $3E ;|..XXXXX.|
   .byte $FE ;|XXXXXXX.|
   .byte $3E ;|..XXXXX.|
   .byte $1C ;|...XXX..|
   
VerticalMoveTables
VerticalMoveFrame1
   .byte $04 ;|.....X..|
   .byte $0E ;|....XXX.|
   .byte $6E ;|.XX.XXX.|
   .byte $FE ;|XXXXXXX.|
   .byte $FE ;|XXXXXXX.|
   .byte $FE ;|XXXXXXX.|
   .byte $F2 ;|XXXX..X.|
   .byte $7B ;|.XXXX.XX|
   .byte $13 ;|...X..XX|
   .byte $37 ;|..XX.XXX|
   .byte $73 ;|.XXX..XX|
   .byte $FE ;|XXXXXXX.|
   .byte $DC ;|XX.XXX..|
   .byte $BE ;|X.XXXXX.|
   .byte $3E ;|..XXXXX.|
   .byte $3E ;|..XXXXX.|
   .byte $3E ;|..XXXXX.|
   .byte $1C ;|...XXX..|
   
VerticalMoveFrame2
   .byte $20 ;|..X.....|
   .byte $70 ;|.XXX....|
   .byte $76 ;|.XXX.XX.|
   .byte $7F ;|.XXXXXXX|
   .byte $7F ;|.XXXXXXX|
   .byte $7F ;|.XXXXXXX|
   .byte $4F ;|.X..XXXX|
   .byte $EE ;|XXX.XXX.|
   .byte $C8 ;|XX..X...|
   .byte $DC ;|XX.XXX..|
   .byte $CE ;|XX..XXX.|
   .byte $7F ;|.XXXXXXX|
   .byte $3B ;|..XXX.XX|
   .byte $7D ;|.XXXXX.X|
   .byte $7C ;|.XXXXX..|
   .byte $7C ;|.XXXXX..|
   .byte $7C ;|.XXXXX..|
   .byte $38 ;|..XXX...|
   
GirderStartMaskingValue
   .byte $3F,$2F,$1F,$0F
   
Climber0
   .byte $38 ;|..XXX...|
   .byte $7C ;|.XXXXX..|
   .byte $7C ;|.XXXXX..|
   .byte $EE ;|XXX.XXX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C0 ;|XX......|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $EE ;|XXX.XXX.|
   .byte $7C ;|.XXXXX..|
   .byte $7C ;|.XXXXX..|
   .byte $38 ;|..XXX...|
Climber1
   .byte $F6 ;|XXXX.XX.|
   .byte $F6 ;|XXXX.XX.|
   .byte $F6 ;|XXXX.XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
   .byte $C6 ;|XX...XX.|
Climber2
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $CC ;|XX..XX..|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|
   .byte $7F ;|.XXXXXXX|
   .byte $7F ;|.XXXXXXX|
   .byte $33 ;|..XX..XX|
Climber3
   .byte $CE ;|XX..XXX.|
   .byte $DF ;|XX.XXXXX|
   .byte $DF ;|XX.XXXXX|
   .byte $DB ;|XX.XX.XX|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $DB ;|XX.XX.XX|
   .byte $DF ;|XX.XXXXX|
   .byte $DE ;|XX.XXXX.|
   .byte $DF ;|XX.XXXXX|
   .byte $DB ;|XX.XX.XX|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $D9 ;|XX.XX..X|
   .byte $DB ;|XX.XX.XX|
   .byte $9F ;|X..XXXXX|
   .byte $9F ;|X..XXXXX|
;
; last byte shared with next table so don't cross page boundaries
;   
Climber4
   .byte $0E ;|....XXX.|
   .byte $1F ;|...XXXXX|
   .byte $1F ;|...XXXXX|
   .byte $98 ;|X..XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $98 ;|X..XX...|
   .byte $1F ;|...XXXXX|
   .byte $1F ;|...XXXXX|
   .byte $1F ;|...XXXXX|
   .byte $98 ;|X..XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $D8 ;|XX.XX...|
   .byte $98 ;|X..XX...|
   .byte $1F ;|...XXXXX|
   .byte $1F ;|...XXXXX|
   .byte $0E ;|....XXX.|
Climber5
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $6E ;|.XX.XXX.|
   .byte $7C ;|.XXXXX..|
   .byte $78 ;|.XXXX...|
   .byte $6C ;|.XX.XX..|
   .byte $6E ;|.XX.XXX.|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $67 ;|.XX..XXX|
   .byte $6E ;|.XX.XXX.|
   .byte $6C ;|.XX.XX..|
   .byte $7C ;|.XXXXX..|
   .byte $38 ;|..XXX...|

AtariAgeSymbol0
   .byte $0F ;|....XXXX|
   .byte $10 ;|...X....|
   .byte $2F ;|..X.XXXX|
   .byte $5F ;|.X.XXXXX|
   .byte $BF ;|X.XXXXXX|
   .byte $AF ;|X.X.XXXX|
   .byte $B7 ;|X.XX.XXX|
   .byte $BA ;|X.XXX.X.|
   .byte $AD ;|X.X.XX.X|
   .byte $B7 ;|X.XX.XXX|
   .byte $BA ;|X.XXX.X.|
   .byte $5D ;|.X.XXX.X|
   .byte $2F ;|..X.XXXX|
   .byte $10 ;|...X....|
   .byte $0F ;|....XXXX|
   
AtariAgeSymbol1
   .byte $80 ;|X.......|
   .byte $40 ;|.X......|
   .byte $A0 ;|X.X.....|
   .byte $D0 ;|XX.X....|
   .byte $E8 ;|XXX.X...|
   .byte $A8 ;|X.X.X...|
   .byte $68 ;|.XX.X...|
   .byte $E8 ;|XXX.X...|
   .byte $A8 ;|X.X.X...|
   .byte $68 ;|.XX.X...|
   .byte $E8 ;|XXX.X...|
   .byte $D0 ;|XX.X....|
   .byte $A0 ;|X.X.....|
   .byte $40 ;|.X......|
   .byte $80 ;|X.......|
   
Presents0
   .byte $40 ;|.X......|
   .byte $40 ;|.X......|
   .byte $74 ;|.XXX.X..|
   .byte $54 ;|.X.X.X..|
   .byte $54 ;|.X.X.X..|
   .byte $54 ;|.X.X.X..|
   .byte $76 ;|.XXX.XX.|
;
; last empty byte shared with next table so don't cross page boundaries
;   
Presents1
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $EE ;|XXX.XXX.|
   .byte $82 ;|X.....X.|
   .byte $EE ;|XXX.XXX.|
   .byte $A8 ;|X.X.X...|
   .byte $EE ;|XXX.XXX.|
;
; last empty byte shared with next table so don't cross page boundaries
;   
Presents2
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $EA ;|XXX.X.X.|
   .byte $8A ;|X...X.X.|
   .byte $EA ;|XXX.X.X.|
   .byte $AA ;|X.X.X.X.|
   .byte $EE ;|XXX.XXX.|
;
; last empty byte shared with next table so don't cross page boundaries
;   
Presents3
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $6E ;|.XX.XXX.|
   .byte $42 ;|.X....X.|
   .byte $4E ;|.X..XXX.|
   .byte $48 ;|.X..X...|
   .byte $EE ;|XXX.XXX.|
   .byte $40 ;|.X......|
         
   BOUNDARY 0                    ; push to the next page to avoid page
                                 ; boundary errors
AtariAge0
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $A2 ;|X.X...X.|
   .byte $A4 ;|X.X..X..|
   .byte $A4 ;|X.X..X..|
   .byte $E4 ;|XXX..X..|
   .byte $AE ;|X.X.XXX.|
   .byte $A4 ;|X.X..X..|
   .byte $40 ;|.X......|
;
; last 3 empty bytes shared with next table so don't cross page boundaries
;
AtariAge1
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $74 ;|.XXX.X..|
   .byte $94 ;|X..X.X..|
   .byte $74 ;|.XXX.X..|
   .byte $16 ;|...X.XX.|
   .byte $65 ;|.XX..X.X|
;
; last 5 empty bytes shared with next table so don't cross page boundaries
;
AtariAge2
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $2A ;|..X.X.X.|
   .byte $2A ;|..X.X.X.|
   .byte $2A ;|..X.X.X.|
   .byte $AE ;|X.X.XXX.|
   .byte $2A ;|..X.X.X.|
   .byte $0A ;|....X.X.|
   .byte $24 ;|..X..X..|
;
; last 3 empty bytes shared with next table so don't cross page boundaries
;   
AtariAge3
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $60 ;|.XX.....|
   .byte $90 ;|X..X....|
   .byte $13 ;|...X..XX|
   .byte $74 ;|.XXX.X..|
   .byte $97 ;|X..X.XXX|
   .byte $75 ;|.XXX.X.X|
   .byte $02 ;|......X.|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
;
; last 2 empty bytes shared with next table so don't cross page boundaries
;   
Climber50
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $01 ;|.......X|
   .byte $01 ;|.......X|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $01 ;|.......X|
   .byte $01 ;|.......X|
   .byte $01 ;|.......X|
   .byte $01 ;|.......X|
   .byte $01 ;|.......X|
   .byte $01 ;|.......X|
   
Climber51
   .byte $3F ;|..XXXXXX|
   .byte $3F ;|..XXXXXX|
   .byte $F8 ;|XXXXX...|
   .byte $F8 ;|XXXXX...|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|
   .byte $F8 ;|XXXXX...|
   .byte $F8 ;|XXXXX...|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|
   
Climber52
   .byte $FC ;|XXXXXX..|
   .byte $FC ;|XXXXXX..|
   .byte $1F ;|...XXXXX|
   .byte $1F ;|...XXXXX|
   .byte $1F ;|...XXXXX|
   .byte $1F ;|...XXXXX|
   .byte $FC ;|XXXXXX..|
   .byte $FC ;|XXXXXX..|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $FF ;|XXXXXXXX|
   .byte $FF ;|XXXXXXXX|

Climber53
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $80 ;|X.......|
   .byte $80 ;|X.......|
   .byte $80 ;|X.......|
   .byte $80 ;|X.......|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $00 ;|........|
   .byte $80 ;|X.......|
   .byte $80 ;|X.......|
   
Copyright1
   .byte $00 ;|........|
   .byte $EE ;|XXX.XXX.|
   .byte $8A ;|X...X.X.|
   .byte $EA ;|XXX.X.X.|
   .byte $2A ;|..X.X.X.|
   .byte $EE ;|XXX.XXX.|
   .byte $00 ;|........|
;
; last empty byte shared with next table so don't cross page boundaries
;
Copyright2
   .byte $00 ;|........|
   .byte $E2 ;|XXX...X.|
   .byte $A2 ;|X.X...X.|
   .byte $AE ;|X.X.XXX.|
   .byte $AA ;|X.X.X.X.|
   .byte $EA ;|XXX.X.X.|
   .byte $00 ;|........|
;
; last empty byte shared with next table so don't cross page boundaries
;
Copyright5
   .byte $00 ;|........|
   .byte $A7 ;|X.X..XXX|
   .byte $A5 ;|X.X..X.X|
   .byte $A5 ;|X.X..X.X|
   .byte $A5 ;|X.X..X.X|
   .byte $B7 ;|X.XX.XXX|
   .byte $00 ;|........|
;
; last empty byte shared with next table so don't cross page boundaries
;
Copyright3
   .byte $00 ;|........|
   .byte $6B ;|.XX.X.XX|
   .byte $52 ;|.X.X..X.|
   .byte $52 ;|.X.X..X.|
   .byte $52 ;|.X.X..X.|
   .byte $52 ;|.X.X..X.|
   .byte $52 ;|.X.X..X.|
   .byte $63 ;|.XX...XX|
Copyright4
   .byte $00 ;|........|
   .byte $3B ;|..XXX.XX|
   .byte $A2 ;|X.X...X.|
   .byte $BA ;|X.XXX.X.|
   .byte $AA ;|X.X.X.X.|
   .byte $BB ;|X.XXX.XX|
   .byte $82 ;|X.....X.|
   .byte $02 ;|......X.|

GameOver0
   .byte $3A ;|..XXX.X.|
   .byte $4A ;|.X..X.X.|
   .byte $5B ;|.X.XX.XX|
   .byte $42 ;|.X....X.|
   .byte $39 ;|..XXX..X|
GameOver1
   .byte $51 ;|.X.X...X|
   .byte $51 ;|.X.X...X|
   .byte $D5 ;|XX.X.X.X|
   .byte $5B ;|.X.XX.XX|
   .byte $91 ;|X..X...X|
GameOver2
   .byte $78 ;|.XXXX...|
   .byte $40 ;|.X......|
   .byte $70 ;|.XXX....|
   .byte $40 ;|.X......|
   .byte $78 ;|.XXXX...|   
GameOver3
   .byte $0C ;|....XX..|
   .byte $12 ;|...X..X.|
   .byte $12 ;|...X..X.|
   .byte $12 ;|...X..X.|
   .byte $0C ;|....XX..|   
GameOver4
   .byte $23 ;|..X...XX|
   .byte $52 ;|.X.X..X.|
   .byte $8B ;|X...X.XX|
   .byte $8A ;|X...X.X.|
   .byte $8B ;|X...X.XX|   
GameOver5
   .byte $D2 ;|XX.X..X.|
   .byte $12 ;|...X..X.|
   .byte $9C ;|X..XXX..|
   .byte $12 ;|...X..X.|
   .byte $DC ;|XX.XXX..|
   
Advanced0
   .byte $09 ;|....X..X|
   .byte $09 ;|....X..X|
   .byte $0F ;|....XXXX|
   .byte $09 ;|....X..X|
   .byte $06 ;|.....XX.|
Advanced1
   .byte $70 ;|.XXX....|
   .byte $49 ;|.X..X..X|
   .byte $4A ;|.X..X.X.|
   .byte $4A ;|.X..X.X.|
   .byte $72 ;|.XXX..X.|
Advanced2
   .byte $89 ;|X...X..X|
   .byte $49 ;|.X..X..X|
   .byte $2F ;|..X.XXXX|
   .byte $29 ;|..X.X..X|
   .byte $26 ;|..X..XX.|
Advanced3
   .byte $49 ;|.X..X..X|
   .byte $4A ;|.X..X.X.|
   .byte $5A ;|.X.XX.X.|
   .byte $6A ;|.XX.X.X.|
   .byte $49 ;|.X..X..X|
Advanced4
   .byte $9E ;|X..XXXX.|
   .byte $50 ;|.X.X....|
   .byte $1C ;|...XXX..|
   .byte $50 ;|.X.X....|
   .byte $9E ;|X..XXXX.|
Advanced5
   .byte $E0 ;|XXX.....|
   .byte $90 ;|X..X....|
   .byte $90 ;|X..X....|
   .byte $90 ;|X..X....|
   .byte $E0 ;|XXX.....|

Normal0
   .byte $49 ;|.X..X..X|
   .byte $4A ;|.X..X.X.|
   .byte $5A ;|.X.XX.X.|
   .byte $6A ;|.XX.X.X.|
   .byte $49 ;|.X..X..X|
Normal1
   .byte $92 ;|X..X..X.|
   .byte $52 ;|.X.X..X.|
   .byte $5C ;|.X.XXX..|
   .byte $52 ;|.X.X..X.|
   .byte $9C ;|X..XXX..|
Normal2
   .byte $8A ;|X...X.X.|
   .byte $AA ;|X.X.X.X.|
   .byte $AB ;|X.X.X.XX|
   .byte $DA ;|XX.XX.X.|
   .byte $89 ;|X...X..X|
Normal3
   .byte $5E ;|.X.XXXX.|
   .byte $50 ;|.X.X....|
   .byte $D0 ;|XX.X....|
   .byte $50 ;|.X.X....|
   .byte $90 ;|X..X....|
   
Original0
   .byte $00 ;|........|
   .byte $01 ;|.......X|
   .byte $01 ;|.......X|
   .byte $01 ;|.......X|
   .byte $00 ;|........|
Original1
   .byte $C9 ;|XX..X..X|
   .byte $29 ;|..X.X..X|
   .byte $2E ;|..X.XXX.|
   .byte $29 ;|..X.X..X|
   .byte $CE ;|XX..XXX.|
Original2
   .byte $4E ;|.X..XXX.|
   .byte $52 ;|.X.X..X.|
   .byte $56 ;|.X.X.XX.|
   .byte $50 ;|.X.X....|
   .byte $4E ;|.X..XXX.|
Original3
   .byte $A5 ;|X.X..X.X|
   .byte $A5 ;|X.X..X.X|
   .byte $AD ;|X.X.XX.X|
   .byte $B5 ;|X.XX.X.X|
   .byte $A4 ;|X.X..X..|
Original4
   .byte $2F ;|..X.XXXX|
   .byte $28 ;|..X.X...|
   .byte $E8 ;|XXX.X...|
   .byte $28 ;|..X.X...|
   .byte $C8 ;|XX..X...|
   
   BOUNDARY 252                  ; push to the RESET vector (this was done
                                 ; instead of using an .ORG to easily keep
                                 ; track of free ROM
   
   echo "***", (FREE_BYTES)d, "BYTES OF ROM FREE"

   .word Start                      ; RESET vector
   .word Start                      ; IRQ vector (not used in this game)