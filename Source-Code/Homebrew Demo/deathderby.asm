; ***************************************************************************************
; ***																				***
; *** This code requires a modified DASM which was posted to [stella] at 02/19/2001 ! ***
; ***																				***
; ***************************************************************************************

; *** DEATH DERBY ***
;FILENAME	DATE				WORKED ON BY

;DD_2LK_15	03/10/2003			(Glenn Saunders)
;--game reset code is just about done now.  No color cycling yet.  
;Now it's time to work on incrementing the player scores when gremlins wrap
;work on car movement routines


;DD_2LK_14	03/5/2003			(Glenn Saunders)
;--working on game reset debounce, not completely finished yet


;DD_2LK_13	02/24/2003			(Glenn Saunders)
;--Working timer countdown
;--fixed car glitch bug


;DD_2LK_12	02/24/2003			(Glenn Saunders/Thomas Jentzsch)
;--Thomas fixed the M1 glitch when crossing top boundary.
;--I re-integrated the fix he made to the new codebase.
;--I was then able to finish off the HMMx precompensation routine for M1.
;--Re-integrated stagger-step demo animation for gremlins.



;DD_2LK_10	02/21/2003			(Glenn Saunders)
;--score kernel functional
;--reverse gear indicators finished
;--controller reading code complete.  Cars rotate again finally!!
;--Wrote first 'real' code ever for the Y-cable (for the reverse gear indicators).
;--reading triggers.  Got the cars moving (just up for now).


;DD_2LK_07	02/20/2003			(Glenn Saunders)
;--started working on added reverse gear indicators
;--working on a fully functional score display
;--to do indirect y load of digits



;DD_2LK_06	02/17/2003			(Glenn Saunders)
; -fixed horizontal position of Gremlin0 when cut off at top of screen
; -Gremlin1 still a little messed up
; -got a static score up there, started work on score digit graphics
; -set up top and	bottom borders, colors come from RAM 
; -implemented color/BW switch.  All colors switch to Greyscale
; -implemented typing scheme for border and	grenade for game-state purposes



;DD_2LK_02	 02/10/2003			(Glenn Saunders)
; -standardized labels
; -Removed random tombstone generator
; -created new title screen (not easy!)

; -added initial walkcycle animation for the zombies
; -added hardcoded zigzag movement of zombies (as a demo)

;			01/26/2003:			(Thomas Jentzsch)
; - optimized kernel, *no* tearing of Gremlins and	Cars
; - kernel initialisation code added, all four objects can be freely moved
;	*everywhere* (DEBUG: use left, right joystick and	left fire button)
;	TODO: correct X-position if Gremlin enters at top of screen
; - reduced Gremlin RAM usage
; - halved tombstone RAM usge

;			01/19/2003 (later):	 (Thomas Jentzsch) 
; - improved grenade code:
;	- no safe zone colouring
;	- taler ball
;	- fullscreen ball mode switchable with right difficulty

;			01/19/2003:			(Thomas Jentzsch)
; - first working 2LK demo version with preliminary grenade


;NAMING CONVENTION:
; CONSTANTS (all caps)
; variables (Mixed case)
; subroutines (Mixed case)
; please be verbose, avoid abbreviations and	acronyms
; all should use underscores between logical words (i.e. Car0_X)



	processor 6502
	include vcs.h

;===============================================================================
; T I A - C O N S T A N T S
;===============================================================================

BM_SIZE_1	= %000000
BM_SIZE_2	= %010000
BM_SIZE_4	= %100000
BM_SIZE_8	= %110000

HMOVE_L7	= $70
HMOVE_L6	= $60
HMOVE_L5	= $50
HMOVE_L4	= $40
HMOVE_L3	= $30
HMOVE_L2	= $20
HMOVE_L1	= $10
HMOVE_0		= $00
HMOVE_R1	= $f0
HMOVE_R2	= $e0
HMOVE_R3	= $d0
HMOVE_R4	= $c0
HMOVE_R5	= $b0
HMOVE_R6	= $a0
HMOVE_R7	= $90
HMOVE_R8	= $80

;JS1_LEFT	 = %00000000
;JS1_RIGHT	 = %00000000
;JS1_UP			= %00000000
;JS1_DOWN	 = %00000000

JS1_LEFT	= %00001000
JS1_RIGHT	= %00000100
JS1_DOWN		= %00000010
JS1_UP	= %00000001
JS1_UP_LEFT	= JS1_UP | JS1_LEFT
JS1_UP_RIGHT	= JS1_UP | JS1_RIGHT
JS1_DOWN_LEFT	= JS1_DOWN | JS1_LEFT
JS1_DOWN_RIGHT	= JS1_DOWN | JS1_RIGHT


DISABLE_BM  	= %00
ENABLE_BM	= %10

;===============================================================================
; U S E R - C O N S T A N T S
;===============================================================================

BCD_0 = 0
BCD_1 = 1
BCD_2 = 2
BCD_3 = 3
BCD_4 = 4
BCD_5 = 5
BCD_6 = 6
BCD_7 = 7
BCD_8 = 8
BCD_9 = 9

BCD0_ = 0 << 4
BCD1_ = 1 << 4
BCD2_ = 2 << 4
BCD3_ = 3 << 4
BCD4_ = 4 << 4
BCD5_ = 5 << 4
BCD6_ = 6 << 4
BCD7_ = 7 << 4
BCD8_ = 8 << 4
BCD9_ = 9 << 4

GAME_TIMER_INITIAL 		= BCD0_|BCD_0
GAME_TIMER_START 		= BCD9_|BCD_9

; constants that reference rotation index pointers
PointUp 			= 0
PointRight 			= 4
PointDown 			= 8
PointLeft 			= 12

TurnOnSpriteReflect 		= %00001000
TurnOffSpriteReflect 		= 0

CarPage				= $FF;00
CarDataAlign			= $65
FlipThreshold			= #9


GAME_STATE_START 		= 1
GAME_STATE_OVER 		= 0

GAME_STATE_INITIAL 		= GAME_STATE_OVER; game over

SCREEN_WIDTH			= 160

TOMBSTONE_HEIGHT 		= 8  ; 8*2 = 16 (single scanlines) high per tombstone
TOMBSTONE_ROWS			= 11 ; 11 rows of tombstones per screen

CAR_HEIGHT			= 8  ; 8 doubled scanlines (used as offset)
GREMLIN_HEIGHT			= 8

SCORE_HEIGHT 			= 5

KERNEL_HEIGHT			= TOMBSTONE_ROWS*TOMBSTONE_HEIGHT+CAR_HEIGHT

CAR_Y_INITIAL 			= KERNEL_HEIGHT/2+40
CAR0_X_INITIAL 			= 17
CAR1_X_INITIAL 			= 135

GREMLIN0_X_INITIAL		= 0
GREMLIN1_X_INITIAL		= 160
GREMLIN0_Y_INITIAL		= 210
GREMLIN1_Y_INITIAL		= 140


;ANIMATION
GREMLIN_SPEED			= 2
GREMLIN_FRAMES 			= 5

;INITIALIZATION CONSTANTS...


;INITIAL SETTINGS (COLOR)
CAR0_COLOR_C			= $36;Also colors Gremlin 0
CAR1_COLOR_C			= $c6;Also colors Gremlin 1
FORCEFIELD_GENERATOR_COLOR_C 	= $93
TIMER_COLOR_C	 		= $18


;INITIAL SETTINGS (B&W)
CAR0_COLOR_BW			= $0F;Also colors Gremlin 0
CAR1_COLOR_BW			= $06;Also colors Gremlin 1
FORCEFIELD_GENERATOR_COLOR_BW 	= $02
TIMER_COLOR_BW	 		= $0F



;GAME OVER SETTINGS (COLOR)
CAR0_COLOR_C_GO			= $36;Also colors Gremlin 0
CAR1_COLOR_C_GO			= $c6;Also colors Gremlin 1
FORCEFIELD_GENERATOR_COLOR_C_GO = $93
TIMER_COLOR_C_GO	 	= $18


BACKGROUND_COLOR_GAME_OVER	= $04
BACKGROUND_COLOR		= 0


;GAME OVER SETTINGS (B&W)
CAR0_COLOR_BW_GO		= $0F;Also colors Gremlin 0
CAR1_COLOR_BW_GO		= $06;Also colors Gremlin 1
FORCEFIELD_GENERATOR_COLOR_BW_GO = $02
TIMER_COLOR_BW_GO	 	= $0F



;STATE
BORDER_STATE_INITIAL 		= 0;solid

BALL_COLUMN_INITIAL		= $58;This should be moved to RAM
BALL_WIDTH			= BM_SIZE_1/4


RAND_EOR_8	 		= $b2


FACING_LEFT 			= 0
FACING_RIGHT 			= GREMLIN_FRAMES; use as an +X offset to frames of graphics



;SCORE_PAGE = >Score_0

CAR0_GEAR_INDICATOR_FORWARD 	= %00000000
CAR1_GEAR_INDICATOR_FORWARD 	= %00000000

CAR0_GEAR_INDICATOR_REVERSE 	= %01110000
CAR1_GEAR_INDICATOR_REVERSE 	= %11100000

Y_BOUNDARY_BOTTOM		= KERNEL_HEIGHT+80+(CAR_HEIGHT*2)


;===============================================================================
; Z P - V A R I A B L E S
;===============================================================================

	SEG.U	variables
	ORG	$80

Frame_Counter			ds 1

Random				ds 1

;TEMP VARIABLE OVERLAYS

Overlay0			ds 1
Overlay1			ds 1
Overlay2			ds 1
Car_Picker			ds 1
OverlayDouble			ds 2

Temp_Var			= Overlay0
Gremlin_Pointer_Temp 		= Overlay0
P0_P1_PARAMETER 		= Overlay0

;SWCHA_Nybble		= Overlay1
Temp_PF_Left			= Overlay1
Temp_PF_Right			= Overlay2
Gremlin0_X_Save 		= Overlay1
Gremlin1_X_Save 		= Overlay2
SWCHB_Current			ds 1
SWCHA0_FAKE	 		ds 1
SWCHA1_FAKE	 		ds 1

Car_Current_Delta		= OverlayDouble

SWCHA_Nybble			ds 2
SWCHA_Previous			ds 2
SWCHA_Current			ds 1

SWCHB_Last			ds 1

Gremlin_Direction_Counter 	ds 1
;sprite graphics pointers
P0_CurrentRotationSequence 	ds 1; 0-15
P1_CurrentRotationSequence 	ds 1; 0-15

;these above reference addresses that get stored below

P0_CurrentFramePtr 		ds 2; this will wind up being a constant $FF in the high byte
P1_CurrentFramePtr 		ds 2; this will wind up being a constant $FF in the high byte


;Playfield Bitmap RAM
Data_PF_Left			ds TOMBSTONE_ROWS
Data_PF_Right			ds TOMBSTONE_ROWS

Car0_Y				ds 1
Car1_Y				ds 1
Gremlin0_Y			ds 1
Gremlin1_Y			ds 1
Gremlin0_Y_Temp			ds 1
Gremlin1_Y_Temp			ds 1

Car0_X				ds 1
Car1_X				ds 1
Gremlin0_X			ds 1
Gremlin1_X			ds 1
Ball_X				ds 1

Car0_YFullres			ds 1				; 0..KERNEL_HEIGHT*2-2
Car1_YFullres			ds 1

Car0_Pointer			ds 2
Car1_Pointer			ds 2
Gremlin0_Pointer  		ds 2
Gremlin1_Pointer  		ds 2


Gremlin0_ID			ds 1
Gremlin1_ID			ds 1

Gremlin0_Anim_Counter 		ds 1
Gremlin1_Anim_Counter 		ds 1
Gremlin0_Direction_Counter	ds 1
Gremlin1_Direction_Toggle	ds 1


Gremlin0_Facing 		ds 1
Gremlin1_Facing 		ds 1

Gremlin0_Overscan_Count 	ds 1
Gremlin1_Overscan_Count 	ds 1

Gremlin0_SubDirection_A 	ds 1
Gremlin1_SubDirection_A 	ds 1

Gremlin0_SubDirection_B 	ds 1
Gremlin1_SubDirection_B 	ds 1

Border_State 			ds 1
Border_Top_Color 		ds 1
Border_Bottom_Color 		ds 1

Grenade_Column			ds 1


;these two can probably be merged
Ball_Type			ds 1 ;identifies the mode of the ball
Ball_Size 			ds 1


Ball_Row		 	ds 1
Ball_Control			ds 1		; dual purpose - 
;since bit 0 is insignificant for color, use it to determine mode.
;bit 0 = 1 -> full screen
Forcefield_Generator_Color 	ds 1


;use these in order to "go greyscale" for Color/BW mode
P0_Color			ds 1
P1_Color			ds 1

Timer_Color			ds 1

Background_Color		ds 1

Car0_Score			ds 1;bcd
Car1_Score			ds 1;bcd

Game_Timer			ds 1

Game_State			ds 1; determines when game is running or game over

Car0_Gear			ds 1
Car1_Gear			ds 1


Car0_Score_Pointer_0X		ds 2
Car0_Score_Pointer_X0		ds 2

Car1_Score_Pointer_0X		ds 2
Car1_Score_Pointer_X0		ds 2


Timer_Pointer_0X		ds 2
Timer_Pointer_X0		ds 2

Seconds_Counter			ds 1
; CURRENT RAM STATISTICS:

;DESC					BYTES
;---------------------- -------
;PLAYFIELD BITMAP		22 ; big savings due to interleave technique
;OTHER					53

;TOTAL RAM USED			75

;FREE RAM		 	53 ; plenty left for game state, AI, anim/sound



;===============================================================================
; M A C R O S
;===============================================================================

  MAC BIT_B
	.byte	$24
  ENDM

  MAC BIT_W
	.byte	$2c
  ENDM

  MAC SLEEP
	IF {1} = 1
	 ECHO "ERROR: SLEEP 1 not allowed !"
	 END
	ENDIF
	IF {1} & 1
	 nop $00
	 REPEAT ({1}-3)/2
		nop
	 REPEND
	ELSE
	 REPEAT ({1})/2
		nop
	 REPEND
	ENDIF
  ENDM


;===============================================================================
; R O M - C O D E
;===============================================================================

	SEG	Bank0
	ORG	$f000

Start SUBROUTINE
	sei						;			Disable interrupts, if there are any.
	cld						;			Clear BCD math bit.
	ldx	#0
	txs
	pha						;			Set stack to beginning.
	txa
.clearLoop:
	pha
	dex
	bne	.clearLoop


;GAME INIT
;GAME INIT
;GAME INIT
;GAME INIT
;GAME INIT
.Game_Boot ; RUNS ONLY ONCE WHEN THE MACHINE BOOTS UP



	lda	SWCHB
	sta	SWCHB_Last
	;sta	SWCHB_Current

	;lda	#GAME_STATE_INITIAL
	;sta	Game_State

	lda	#GAME_TIMER_INITIAL
	sta	Game_Timer

	lda	#60
	sta	Seconds_Counter

	lda	#0
	sta	Car0_Score
	sta	Car1_Score
	lda	#0
	sta	Game_State

	lda	#JS1_RIGHT
	sta	Gremlin0_SubDirection_A
	lda	#JS1_UP
	sta	Gremlin0_SubDirection_B

	lda	#JS1_LEFT
	sta	Gremlin1_SubDirection_A
	lda	#JS1_UP
	sta	Gremlin1_SubDirection_B


	lda	#CAR0_GEAR_INDICATOR_REVERSE
	sta	Car0_Gear
	lda	#CAR1_GEAR_INDICATOR_REVERSE
	sta	Car1_Gear

	lda	#0
	sta	SWCHA0_FAKE
	sta	SWCHA1_FAKE

	lda	#BALL_COLUMN_INITIAL
	sta	Grenade_Column
	

;load in the title graphics
	ldx	#TOMBSTONE_ROWS-1
.titleLoader

	lda	Title_PF_L,X
	sta	Data_PF_Left,X
	lda	Title_PF_R,X
	sta	Data_PF_Right,X 
	dex
	bpl	.titleLoader

; initialize animation counters
	lda	#GREMLIN_SPEED
	sta	Gremlin0_Anim_Counter
	sta	Gremlin1_Anim_Counter
	
	lda	#1
	sta	Gremlin1_Direction_Toggle

	lda	#FACING_RIGHT
	sta	Gremlin0_Facing

	lda	#FACING_LEFT
	sta	Gremlin1_Facing
	
;update ball state
.updateBallState
  ; lda	#BM_SIZE_2|1
  ; sta	CTRLPF

.updateCarColors
	;lda	#$00
	;sta	COLUBK
	;lda	#CAR0_COLOR	;$36
	;sta	COLUP0
  ; lda	#CAR1_COLOR	;$c6
	;sta	COLUP1

.updateCarPositions
	lda	#CAR_Y_INITIAL;16		 ;KERNEL_HEIGHT*2-2;16
	sta	Car0_YFullres
	lda	#CAR_Y_INITIAL;16
	sta	Car1_YFullres

	lda	#CAR0_X_INITIAL
	sta	Car0_X
	lda	#CAR1_X_INITIAL
	sta	Car1_X

.updateGremlinPositions
	lda	#GREMLIN0_Y_INITIAL
	sta	Gremlin0_Y
	lda	#GREMLIN1_Y_INITIAL
	sta	Gremlin1_Y

	lda	#GREMLIN0_X_INITIAL
	sta	Gremlin0_X
	lda	#GREMLIN1_X_INITIAL
	sta	Gremlin1_X

.updateBallPosition
	lda	#50
	sta	Ball_X
	
	lda	#6
	sta	Ball_Row

	lda	#1
	sta	VDELBL
	
.updateCarPointers
	lda	#>Car_Rotation_Frame0
	sta	Car0_Pointer+1
	sta	Car1_Pointer+1


	ldx	#0
	stx	P0_CurrentRotationSequence
	ldx	#8
	stx	P1_CurrentRotationSequence

.updateGremlinPointers
	lda	#>Gremlin_Frame0_Left; take care of the high order byte (should all be on the same page of ROM)
	sta	Gremlin0_Pointer+1
	sta	Gremlin1_Pointer+1

	
	ldx	#1
	stx	Gremlin0_ID
	ldx	#3
	stx	Gremlin1_ID
	
.updateScorePointers

	;take care of the high byte (the page)
	lda	#>Score_0
	sta	Car0_Score_Pointer_0X+1
	sta	Car1_Score_Pointer_0X+1
	sta	Car0_Score_Pointer_X0+1
	sta	Car1_Score_Pointer_X0+1
	sta	Timer_Pointer_X0+1
	sta	Timer_Pointer_0X+1
	
	jsr	Update_Score_Pointers


;here we want to have 3 mainloops




.mainLoop:
	jsr	VerticalBlank
	jsr	GameCalc
	jsr	Setup_Player_Missile_Graphics
	jsr	Draw_Screen
	jsr	OverScan
	jmp	.mainLoop


Update_Score_Pointers SUBROUTINE
	;cld
	;extract BCD timer into pointer variables
	lda	Game_Timer
	and	#%00001111
	tax
	lda	Score1_Digit_Table,X
	sta	Timer_Pointer_0X
	
	lda	Game_Timer
	lsr
	lsr
	lsr
	lsr
	tax
	lda	Score1_Digit_Table,X
	sta	Timer_Pointer_X0



	;CAR0 SCORE
	lda	Car0_Score
	and	#%00001111
	tax
	lda	Score0_Digit_Table,X
	sta	Car0_Score_Pointer_0X
	
	lda	Car0_Score
	lsr
	lsr
	lsr
	lsr
	tax
	lda	Score0_Digit_Table,X
	sta	Car0_Score_Pointer_X0
	
	
	
	;CAR1 SCORE
	lda	Car1_Score
	and	#%00001111
	tax
	lda	Score1_Digit_Table,X
	sta	Car1_Score_Pointer_0X

	lda	Car1_Score
	lsr
	lsr
	lsr
	lsr
	tax

	lda	Score0_Digit_Table,X
	sta	Car1_Score_Pointer_X0

	
	rts

VerticalBlank SUBROUTINE
	lda	#2
	sta	WSYNC
	sta	VSYNC
	sta	WSYNC
	sta	WSYNC
	lsr
	ldx	#44
	sta	WSYNC
	sta	VSYNC
	stx	TIM64T
	rts
	



Stagger_Step_Animation SUBROUTINE

	lda	Frame_Counter
	and	#$5 ; determines speed
	beq	.do_Gremlin_Move

	lda	#0
	sta	SWCHA0_FAKE
	sta	SWCHA0_FAKE+1
	rts

.do_Gremlin_Move
	lda	Gremlin_Direction_Counter
	bne	.keep_going
	lda	#GREMLIN_SPEED
	sta	Gremlin_Direction_Counter
.keep_going	
	cmp	#GREMLIN_SPEED/2
	bmi	.do_SubDirection_B
	
.do_SubDirection_A
	lda	Gremlin0_SubDirection_A
	sta	SWCHA0_FAKE
	
	lda	Gremlin0_SubDirection_A+1
	sta	SWCHA0_FAKE+1
	rts

.do_SubDirection_B
	lda	Gremlin0_SubDirection_B
	sta	SWCHA0_FAKE

	lda	Gremlin0_SubDirection_B+1
	sta	SWCHA0_FAKE+1

	lda	#GREMLIN_SPEED
	sta	Gremlin_Direction_Counter
	rts





Game_Reset SUBROUTINE
	;lda	#$4b
	;sta	COLUBK

	lda	#GAME_STATE_START
	sta	Game_State

	lda	#GAME_TIMER_START
	sta	Game_Timer

	lda	#60
	sta	Seconds_Counter
	


	lda	#0
	sta	Car0_Score
	sta	Car1_Score

	;reset frame timers
  
  

;.clear title graphics or any leftover tombstones

	lda	#0
	ldx	#TOMBSTONE_ROWS-1
.Clear_Tombstones
	sta	Data_PF_Left,X
	sta	Data_PF_Right,X 
	dex
	bpl	.Clear_Tombstones

	
.ResetCarPositions
	lda	#CAR_Y_INITIAL;16		 ;KERNEL_HEIGHT*2-2;16
	sta	Car0_YFullres
	sta	Car1_YFullres

	lda	#CAR0_X_INITIAL
	sta	Car0_X
	lda	#CAR1_X_INITIAL
	sta	Car1_X

.ResetGremlinPositions
	lda	#GREMLIN0_Y_INITIAL
	sta	Gremlin0_Y
	lda	#GREMLIN1_Y_INITIAL
	sta	Gremlin1_Y

	lda	#GREMLIN0_X_INITIAL
	sta	Gremlin0_X
	lda	#GREMLIN1_X_INITIAL
	sta	Gremlin1_X

.ResetScore
	;zero out the scores
	lda	Score0_Digit_Table
	sta	Car0_Score_Pointer_X0
	sta	Car0_Score_Pointer_0X
	sta	Car1_Score_Pointer_X0
	sta	Car1_Score_Pointer_0X
	
	jsr	Update_Score_Pointers
	;lda	#0
	;sta	SWCHB_Current
	rts
	
; this has to branch off depending on game mode
GameCalc SUBROUTINE



	inc	Frame_Counter
	lda	SWCHB
	and	%00000001
	sta	SWCHB_Current
	
	;IF current state eq 1 (reset not depressed)
	bne	.bind_ON_RESET_TOGGLE;we have to check for ON_RESET_TOGGLE event
	;lda	#$CF
	;sta	COLUBK	
	;ELSE if current state eq 0 	(reset depressed)
		;we do NOT have to check for ON_RESET_TOGGLE event

	
	lda	#0
	sta	Game_State;freeze the game
	
	jmp	.finish_timer; just skip ahead

;figure out if this is the ON_RESET_DOWN event or not

;IF (current state eq 0 ...			(reset not depressed)
.bind_ON_RESET_TOGGLE
	;brk
	;lda	#$F4
	;sta	COLUBK

	lda	SWCHB_Last
	and	%00000001
	;...and	previous state eq 0) 		(reset previously depressed) 
	beq	.ON_RESET_TOGGLE; THEN perform game reset
 
	;ELSE just skip ahead

	jmp	.skip_game_reset; just skip ahead
	
.ON_RESET_TOGGLE; previous was 1 and	current is 0 so do reset

	jsr	Game_Reset
	jmp	.SetColors
	
.skip_game_reset
	;inc	Frame_Counter

	lda	Game_State
	beq	.finish_timer ;if game_state = 0 (game over) then do not decrement timer


	lda	Frame_Counter
	dec	Seconds_Counter
	bne	.SetColors




.Decrement_Timer
	lda	#60 ; reset counter
	sta	Seconds_Counter


	
	;testing score increment
	;lda	Car0_Score
	;sed
	;adc	#1
	;cld
	;sta	Car0_Score

	;lda	Car1_Score
	;sed
	;adc	#1
	;cld
	;sta	Car1_Score
	;/testing score increment
	
	sed
	lda	Game_Timer
	sbc	#0
	cld
	sta	Game_Timer


	
	

	beq	.end_Game
	jsr	Update_Score_Pointers
	jmp	.finish_timer
	
.end_Game
	jsr	Update_Score_Pointers
	;lda	#GAME_STATE_OVER; end game due to timer running out
	;sta	Game_State
	; there is a bug here, so disable game over
.finish_timer



;this block should always execute except when colors are cycling
.SetColors
	lda	SWCHB_Current
	sta	SWCHB_Last

	lda	Game_State
	beq	.Game_Over_Colors

	lda	#BACKGROUND_COLOR; set to black
	sta	Background_Color
	jmp	.continue_SetColors

.Game_Over_Colors
	lda	#BACKGROUND_COLOR_GAME_OVER; set to grey
	sta	Background_Color
	
.continue_SetColors

	;finish the rest of the score graphics later
	lda	SWCHB
	and	%00001000
	beq	.SetColors_Black_and_White
	;COLOR
	
	;BORDER
	lda	#BORDER_STATE_INITIAL
	sta	Border_State

	;set border colors based on Border_State
	ldx	Border_State
	lda	Border_Type_Table,X
	sta	Border_Top_Color
	sta	Border_Bottom_Color
	
	
	lda	#FORCEFIELD_GENERATOR_COLOR_C
	sta	Forcefield_Generator_Color
	
	;GRENADE
	ldx	Ball_Type
	lda	Grenade_Color_Table,x
	sta	Ball_Control
	
	;TIMER
	lda	#TIMER_COLOR_C
	sta	Timer_Color
	
	;P0/P1
	lda	#CAR0_COLOR_C
	sta	COLUP0
	sta	P0_Color; this is only used in the score display
	lda	#CAR1_COLOR_C
	sta	COLUP1
	sta	P1_Color; this is only used in the score display
	
	jmp	.SetColors_Done

	;B&W
.SetColors_Black_and_White

	;BORDER
	ldx	Border_State
	lda	Border_Type_Table+3,X
	sta	Border_Top_Color
	sta	Border_Bottom_Color
	
	lda	#FORCEFIELD_GENERATOR_COLOR_BW
	sta	Forcefield_Generator_Color
	
	;GRENADE
	ldx	Ball_Type
	lda	Grenade_Color_Table+4,x
	sta	Ball_Control

	;TIMER
	lda	#TIMER_COLOR_BW
	sta	Timer_Color

	
	;P0/P1
	lda	#CAR0_COLOR_BW
	sta	COLUP0
	sta	P0_Color
	lda	#CAR1_COLOR_BW
	sta	COLUP1
	sta	P1_Color





.SetColors_Done


;set ball config based on Ball_Type variable
	ldx	Ball_Type
	cpx	#3
	bne	.ClearBarrier
.SetBarrier
	lda	#1
  ; brk
	;ora Ball_Control
	sta	Ball_Control
.ClearBarrier
	lda	Ball_Control
	and	%11111110
	sta	Ball_Control


	ldx	Ball_Type
	lda	Grenade_Size_Table,x
	sta	Ball_Size

	
.skipRandom:

; move the ball:
	lda	Frame_Counter
	and	#$03
	bne	.skipMoveBL

	ldx	Ball_X
	dex
	cpx	#17
	bcs	.okBall_X
	ldx	#143
.okBall_X:
	stx	Ball_X
.skipMoveBL:



;this chunk should always execute regardless of game state


;update zombie walkcycles
.walkCycler0
;first, update counters and	determine whether or not to update
;the walk cycle on this frame
	dec	Gremlin0_Anim_Counter
	bne	.walkCycler1 ; don't update until timer reaches 0
.walkCycle0Reset
	ldy	#GREMLIN_SPEED; this should be based on zombie speed, variable
	sty	Gremlin0_Anim_Counter

;animate zombie
	dec	Gremlin0_ID
	bne	.walkCycler1
.walkCycle0Repeat
	ldy	#GREMLIN_FRAMES
	sty	Gremlin0_ID




;update zombie walkcycles
.walkCycler1
;first, update counters and	determine whether or not to update
;the walk cycle on this frame
	dec	Gremlin1_Anim_Counter
	bne	.exitWalkCycle ; don't update until timer reaches 0
.walkCycle1Reset
	ldy	#GREMLIN_SPEED; this should be based on zombie speed, variable
	sty	Gremlin1_Anim_Counter

;animate zombie1
	;ldx	#1


	lda 	Game_State

	jsr	Stagger_Step_Animation


	;jsr	moveGremlin1
	dec	Gremlin_Direction_Counter
	
	dec	Gremlin1_ID
	bne	.exitWalkCycle
.walkCycle1Repeat
	ldy	#GREMLIN_FRAMES
	sty	Gremlin1_ID


.exitWalkCycle

	rts



Setup_Player_Missile_Graphics SUBROUTINE
; *** calculate kernel variables: ***
; calculate pointer to Car #0 graphics:
	lda	Car0_YFullres
	sta	VDELP0
	lsr
	sta	Car0_Y

	ldy	P0_CurrentRotationSequence
	lda	Car_Rotation_Sequence,y
	clc
	adc	Car0_Y
	sta	Car0_Pointer

; calculate pointer to Car #1 graphics:
	lda	Car1_YFullres
	eor	#1
	sta	VDELP1
	eor	#1
	lsr
	adc	#0
	sta	Car1_Y

	ldy	P1_CurrentRotationSequence
	lda	Car_Rotation_Sequence,y
	clc
	adc	Car1_Y
	sta	Car1_Pointer



; calculate pointer to missile #0 graphics:
	lda	Gremlin0_Y
	and	#~$80
	clc
	adc	#GREMLIN_HEIGHT-1
	sta	Gremlin0_Y_Temp
	tay

	lda	Gremlin0_ID
	adc	Gremlin0_Facing	
	tax
	lda	Gremlin_Table,x
	sec
	sbc	Gremlin0_Y_Temp
	sta	Gremlin0_Pointer


	;fix
	cpy	#KERNEL_HEIGHT-1
	bmi	 .skipWrap0
	ldy	#KERNEL_HEIGHT
	;/end Fix
	
	
.skipWrap0:

	lda	(Gremlin0_Pointer),y
	asl
	asl 
	sta	NUSIZ0

; calculate pointer to missile #1 graphics:
	lda	Gremlin1_Y
	and	#~$80
	clc
	adc	#GREMLIN_HEIGHT-1
	sta	Gremlin1_Y_Temp
	tay

	lda	Gremlin1_ID
	adc	Gremlin1_Facing	
	tax
	lda	Gremlin_Table,x
	sec
	sbc	Gremlin1_Y_Temp
	sta	Gremlin1_Pointer

;fix
	cpy	 #KERNEL_HEIGHT
	bmi	 .skipWrap1
	ldy	 #KERNEL_HEIGHT-1
.skipWrap1:
;/end fix

	lda	(Gremlin1_Pointer),y
	asl
	asl
	sta	NUSIZ1
	
;BEGIN PRECOMPENSATION

	;The missiles rely on the cumulative effect of relative position changes.
	;When the missiles are at the top of the screen, however, their starting horizontal
	;position needs to be absolutely defined.  So what we have to do is add up
	;all the relative changes up to the first visible missile row and	apply this
	;as precompensation before the screen starts.  That way the horizontal position
	;will match what it would be if the zombie were not at the top of the screen.
	
	;the first thing we need to do is figure out which zombie may be at the top of the screen.
	
	;then we need to figure out how many rows of the zombie are being cut off.
	;we then take this number and	loop over it, aggregating the HMMx values
	;as we go along.  This simulates what the kernel would have done had the
	;zombie been completely in the screen.  The final aggregate value is converted
	;back into the proper HMMx constant and	stored in HMMx and	applied with an HMOVE.

	;save off Gremlin X position
	lda	Gremlin1_X
	sta	Gremlin1_X_Save
	
	lda	Gremlin0_X
	sta	Gremlin0_X_Save
	


;loop through this 8 times

;FROM: KERNEL_HEIGHT-1+GREMLIN_HEIGHT (maximum extent of gremlin, off screenn at top)
;TO: KERNEL_HEIGHT-1 (minimum extent of gremlin, collision with top)

	ldy	#KERNEL_HEIGHT-1+GREMLIN_HEIGHT
.do_adjustments
	jsr	HMMx_Aggregate_Line
	dey
	cpy	#KERNEL_HEIGHT-1
	bpl	.do_adjustments



; perform initial horizontal positioning updates for all objects
	ldx	#4
.loopPos:
	lda	Car0_X,x
	jsr	SetPosX
	dex
	bpl	.loopPos
	sta	WSYNC

	sta	HMOVE
	sta	WSYNC

	sta	HMCLR
	
	;restore Gremlin X position
	lda	Gremlin1_X_Save
	sta	Gremlin1_X
	
	lda	Gremlin0_X_Save
	sta	Gremlin0_X 
	

	rts


;LOAD Y with SCANLINE BEFORE CALLING THIS FUNCTION
HMMx_Aggregate_Line SUBROUTINE

	
.isM0atTop 
; determine whether to draw Gremlin #0:
	cpy	Gremlin0_Y_Temp
	bpl	.Gremlin1_Compensation_Start; no gremlin1, so go to g0 routine
	;.drawM1:

	iny ; this is necessary because of the interleaved nature of M0 vs. M1
	lda	(Gremlin0_Pointer),y
	dey ; this is necessary because of the interleaved nature of M0 vs. M1
	tax
	
	;this is really only necessary on the top line
	;this is wasting a fair amount of cycles
	asl
	asl
	sta	NUSIZ0
	txa
	lsr
	lsr
	lsr
	lsr
	sta	Gremlin_Pointer_Temp
	clc
;	if the offset is less than 12, then it's either zero or a positive offset
	cmp	#12
	bcc	.Gremlin0_Compensation_Positive_to_Negative
.Gremlin0_Compensation_Negative_to_Positive
	;brk
	sbc	#12; brings the numbers back down to a 0-3 range
	tax
	lda	HMMx_Compensation_Table,X; look up the conversion index based on the table
	adc	Gremlin0_X; Gremlin1_X = Gremlin1_X + A
	sta	Gremlin0_X
	jmp	.Gremlin1_Compensation_Start
.Gremlin0_Compensation_Positive_to_Negative
	;just use the accumulator as is to subtract from Gremlin1_X
	lda	Gremlin0_X
	adc	#1; I don't know why this hack is necessary
	sbc	Gremlin_Pointer_Temp; Gremlin1_X = Gremlin1_X - A
	sta	Gremlin0_X 


.Gremlin1_Compensation_Start


; determine whether to draw Gremlin #1:
	ldx	Gremlin1_Y_Temp
	cpy	Gremlin1_Y_Temp
	bpl	.Gremlin1_Compensation_End; no gremlin1
	;.drawM1:
	
	;this dey/iny thing is a hack.
	;dey
	lda	(Gremlin1_Pointer),y
	;iny
	tax
	
	;this is really only necessary on the top line
	;this is wasting a fair amount of cycles
	asl
	asl
	;this might be the wrong value
	sta	NUSIZ1
	txa
	lsr
	lsr
	lsr
	lsr
	sta	Gremlin_Pointer_Temp
	clc
;	if the offset is less than 12, then it's either zero or a positive offset
	cmp	#12
	bcc	.Gremlin1_Compensation_Positive_to_Negative
.Gremlin1_Compensation_Negative_to_Positive
	;brk
	sbc	#12; brings the numbers back down to a 0-3 range
	tax
	lda	HMMx_Compensation_Table,X; look up the conversion index based on the table
	adc	Gremlin1_X; Gremlin1_X = Gremlin1_X + A
	sta	Gremlin1_X
	rts
.Gremlin1_Compensation_Positive_to_Negative
	;just use the accumulator as is to subtract from Gremlin1_X
	lda	Gremlin1_X
	adc	#1; I don't know why this hack is necessary
	sbc	Gremlin_Pointer_Temp; Gremlin1_X = Gremlin1_X - A
	sta	Gremlin1_X 

	
.Gremlin1_Compensation_End
;END PRECOMPENSATION




	rts

	
NextRandom SUBROUTINE
;	lda	Random			 		; 3
;	lsr						; 2
;	bcc	.skipEor				; 2³
;	eor	#RAND_EOR_8				; 2
;.skipEor:						;	= 11/12 (~11.5)
;	sta	Random			 		; 3

	lda	Random					; 3
	asl						; 2
	eor	Random					; 3
	asl						; 2
	eor	Random					; 3
	asl						; 2
	asl						; 2
	eor	Random					; 3
	asl						; 2
	rol	Random					; 5
	rts						; 6
;NextRandom END


	align 256

Draw_Screen	SUBROUTINE



	
	lda	#%00010010
	ora Ball_Size; important
	sta	CTRLPF
	lda	Forcefield_Generator_Color
	sta	COLUPF

	; lda	#$02  ; use this for a custom background color for the score
	; sta	COLUBK

; setting up a timer to make experimenting inside the kernel easier
; (the final code shouldm't need this):
	ldx	#228
.waitTim:
	lda	INTIM
	bne	.waitTim
	sta	WSYNC
	sta	VBLANK
	stx	TIM64T


	STA	WSYNC
	
	ldy	#SCORE_HEIGHT

	ldx	#0

;This whole score section required some very careful timing, but naturally, I did
;it mostly though trial and	error, rather than calculating the cycle times. :)

	;sleep 3
.Draw_Score
	;SLEEP 4
	stx	PF0;blank out PF0, or set it to GEAR graphic (on next line)
	stx.w	PF2
	lda	(Car0_Score_Pointer_X0),y; CAR0 - TENS DIGIT
	and	#%11100000
	sta	PF1 ; get the write over with ASAP to buy us time
	lda	(Car0_Score_Pointer_0X),y; CAR0 - ONES DIGIT
	and	#%00001111
	sta	PF1
	

	SLEEP 6
	
	lda	(Car1_Score_Pointer_X0),y; CAR1 - TENS DIGIT
	and	#%00001111
	lsr
	sta.w	PF1
	lda	(Car1_Score_Pointer_0X),y; CAR1 - ONES DIGIT
	and	#%00001111
	sta	PF2

	

	stx	PF0
	stx	PF1
	stx	PF2
;	------------------------------------  
 
	lda	Car0_Gear
	and	%11100000
	sta	PF0
	 
	SLEEP 15
	;toggle in and	out of PF modes
	lda	Timer_Color
	STA.W	COLUP1
	sta	COLUP0



	lda	(Timer_Pointer_X0),y;TIMER - TENS DIGIT
	and	#%11110000
	sta	PF2
	
	;INSERT TIMER CODE HERE
	lda	(Timer_Pointer_0X),y;TIMER - ONES DIGIT
	and	#%11110000
	sta	PF0; write in PF0

	
	;SLEEP  9
	lda	Car1_Gear; gear indicator
	and	#%11100000
	sta	PF2

	
	lda	P1_Color
	sta	COLUP1
	;lda	Car0_Gear; gear indicator
	;and	#%11101111
	;sta	PF0
	SLEEP 2
	
	lda	P0_Color
	sta	COLUP0


	sta	WSYNC ; end of scanline pair

	dey
	bne	.Draw_Score
	
	
	lda	 Background_Color
	sta	 COLUBK
	sty	 PF0
	sty	 PF1
	sty	 PF2

; reset playfield/ball settings
	lda	Ball_Size
	ora	#1
  ;  and	Ball_Size; important
	sta	CTRLPF
	ldx	Border_Top_Color
	lda	#$FF; top border
	sta	WSYNC


	stx	COLUPF
	sta	PF0
	sta	PF1
	sta	PF2


	; sta	WSYNC

; *** initialize the kernel loop: ***

; From here on in to .ExitKernel this is all Thomas Jentzsch and	it's a complete work of art.
;
;	lda	MaskTbl+TOMBSTONE_ROWS-1 ; 4
	lda	#%01010101
	and	Data_PF_Left+TOMBSTONE_ROWS-1		; 4
	sta	Temp_PF_Left				; 3
	lda	Data_PF_Right+TOMBSTONE_ROWS-1		; 4
	sta	Temp_PF_Right				; 3 = 18

	;lda	#0			 		; 2
	;sta	COLUP0		 			; 3
	;sta	COLUP1		 			; 3 =  8

	nop
	nop
	nop
	nop

;BEGIN FIX

	ldy	#KERNEL_HEIGHT-2 			; 2 =  4

	cpy	Gremlin1_Y_Temp				; 3
	bpl	.skipEnableM1				; 2³
	lda	Gremlin1_Y				; 3
	sta	Gremlin1_Y_Temp				; 3
	iny
	cpy	Gremlin1_Y_Temp				; 3
	bpl	.skipEnableM1a  			; 2³
	lda	#2				 	; 2
	; lda	#0
	sta	 ENAM1			 		; 3
.skipEnableM1a
	dey
.skipEnableM1:
	iny

	cpy	Gremlin0_Y_Temp				; 3
	bpl	.skipEnableM0				; 2³
	lda	Gremlin0_Y				; 3
	sta	Gremlin0_Y_Temp				; 3
	lda	#2				 	; 2
	sta	ENAM0			 		; 3
.skipEnableM0:
;END OF FIX


	iny						; 2
	ldx	#TOMBSTONE_ROWS-1			; 2 =  4

; draw Car #1:
	lda	#CAR_HEIGHT-1				; 2
	cmp	Car1_Y					; 3
	bcs	.doDraw1				; 2³
	lda	#0			 		; 2
	BIT_W						;-1
.doDraw1:
	lda	(Car1_Pointer),y	 		; 5
	sta	GRP1					; 3 = 16

	lda	#CAR_HEIGHT-1				; 2
	cmp	Car0_Y					; 3
	bcs	.doDraw0				; 2³
	lda	#0					; 2
	BIT_W						;-1
.doDraw0:
	lda	(Car0_Pointer),y	 		; 5
	sta	GRP0					; 3 = 16

	dey						; 2 =  2

; draw Car #1:
	lda	#CAR_HEIGHT-1				; 2
	dcp	Car1_Y					; 5
	bcs	.doDraw1_a	 			; 2³
	lda	#0			 		; 2
	BIT_W						;-1
.doDraw1_a:
	lda	(Car1_Pointer),y	 		; 5
	sta	GRP1					; 3 = 18

	lda	Ball_Control	 			; 3
	asl						; 2 =  5
  
  ;end border
	sta	ENABL					; 3 =  3			VDELed
	
	lda	#$0F

	sta	WSYNC
	sta	COLUPF

;---------------------------------------


  ; lda	#CAR1_COLOR					; 2
	;sta	COLUP1		 			; 3
	;lda	#CAR0_COLOR				; 2
  ; sta	COLUP0		 				; 3
	
	nop
	nop
	nop
	nop
	nop
	
	
	lda	#$90					; 2				enable left and	right borders
	sta	PF0					; 3

	jmp	EnterKernel				; 3 = 18	@21
;***************************************

	align	256

; wasting some bytes to avoid page penalties:
	ds	 $74, 0

Kernel SUBROUTINE

.disableM1:						; 9
	SLEEP	2					; 2				waste two cycles for constant timing
	lda	#DISABLE_BM				; 2
	beq	.continueM1a				;10

.checkM1:						; 6
	bne	.disableM1	 			; 2³
;.enableM1:
	lda	Gremlin1_Y				; 3
	sta	Gremlin1_Y_Temp				; 3
	lda	#ENABLE_BM	 			; 2
.continueM1a:
	sta.w	ENAM1					; 4		@00	(>= @00)
	bpl	.continueM1				; 3

.disableM0:						; 8
	SLEEP	2					; 5				waste two cycles for constant timing
	lda	#DISABLE_BM				; 2
	beq	.continueM0a				; 9

.checkM0:						; 6
	bne	.disableM0	 			; 2³
;.enableM0:
	lda	Gremlin0_Y				; 3
	sta	Gremlin0_Y_Temp				; 3
	lda	#ENABLE_BM	 			; 2
.continueM0a:
	sta.w	ENAM0					; 4		@01	(>= @00)
	bpl	.continueM0				; 3

;***************************************


; cycle count (tombstone row):
; - loop overhead			 9
; - COLUPF			   5 =	 5
; - playfield			29+8 =  37
; - players			18*2 =  36
; - missiles/HMOVE  		23*2 =  46
; - HMCLR			3*2  =	 6
; - free			4+9  =  13
;				----------------
; Total				76*2 = 152 :-)

.contBlock:						;			@42
	SLEEP	9					; 9
	asl						; 2 = 11

.nextBlock:
	sta	COLUPF		 			; 3 =  3	@56	too early for 2nd row of ball

; draw Gremlin #1:
	cpy	Gremlin1_Y_Temp				; 3
	bpl	.checkM1				; 2³
;.drawM1:
	lda	(Gremlin1_Pointer),y	 		; 5
	sta	HMM1					; 3
	asl						; 2
	asl						; 2
	sta	HMOVE					; 3		@00	three cycles too early, ok
;---------------------------------------
	sta	NUSIZ1		 			; 3		@03	(>= @00)
.continueM1:						;	= 23			timing is constant!

; draw Car #1:
	lda	#CAR_HEIGHT-1				; 2
	dcp	Car1_Y					; 5
	bcs	.doDraw1				; 2³
	lda	#0			 		; 2
	BIT_W						;-1
.doDraw1:
	lda	(Car1_Pointer),y	 		; 5
	sta	GRP1					; 3 = 18	@21
EnterKernel:			 ;

; draw tomstones (part 1/2):
	lda	Temp_PF_Left				; 3
	sta	PF1					; 3		@27	(<= @27)
	eor	Data_PF_Left,x	 			; 4
	sta	PF2					; 3		@34	(<= @38)

	SLEEP	4					; 4

; draw tomstones (part 2/2):
	lda	MaskTbl,x				; 4
	and	Temp_PF_Right				; 3
	sta	PF2					; 3		@48	(== @48)
	eor	Temp_PF_Right				; 3
	sta	PF1					; 3		@54	(<= @54)

; clear all hmov registers:
	sta	HMCLR					; 3 =  3	@57

; draw Gremlin #0:
	cpy	Gremlin0_Y_Temp				; 3
	bpl	.checkM0				; 2³
;.drawM0:
	lda	(Gremlin0_Pointer),y			; 5
	sta	HMM0					; 3
	asl						; 2
	asl						; 2
;---------------------------------------
	sta	HMOVE					; 3		@01	two cycles too early, ok
	sta	NUSIZ0		 			; 3		@04	(>= @00)
.continueM0:						;	= 23			timing is constant!

; draw Car #0:
	lda	#CAR_HEIGHT-1				; 2
	dcp	Car0_Y					; 5
	bcs	.doDraw0				; 2³
	lda	#0			 		; 2
	BIT_W						;-1
.doDraw0:
	lda	(Car0_Pointer),y	 		; 5
	sta	GRP0					; 3 = 18	@22

; disable playfield:
	lda	#0			 		; 2
	sta	PF1					; 3		@27	(<= @27)
	sta	PF2					; 3 =  8	@30	(<= @38)

; clear all hmov registers:
	sta	HMCLR					; 3 =  3	@33

; tombstone indexer routine (part 1/2):
	dey						; 2
	tya						; 2
	and	#7			 		; 2
	bne	.contBlock	 			; 2³=  8

	SLEEP	5					; 5 =  5

; draw grenade:
	lda	#ENABLE_BM	 			; 2
	cpx	Ball_Row	 			; 3
	beq	.enableBL				; 2³
	BIT_W						; 1
.enableBL:
	sta	ENABL					; 3 = 11	@57	VDELed!

; draw Gremlin #1:
	cpy	Gremlin1_Y_Temp				; 3
	bpl	.checkGremlin1_a	 		; 2³
;.drawGremlin1_a:
	lda	(Gremlin1_Pointer),y	 		; 5
	sta	HMM1					; 3
	asl						; 2
	asl						; 2
;---------------------------------------
	sta	HMOVE					; 3		@01	two cycles too early, ok
	sta	NUSIZ1		 			; 3		@04	(>= @00)
.continueGremlin1_a:			 		;	= 23			timing is constant!

; draw Car #1:
	lda	#CAR_HEIGHT-1				; 2
	dcp	Car1_Y					; 5
	bcs	.doDraw1_a	 			; 2³
	lda	#0			 		; 2
	BIT_W						;-1
.doDraw1_a:
	lda	(Car1_Pointer),y	 		; 5
	sta	GRP1					; 3 = 18	@22

; set grenade color and	clear PF0:
	lda	Ball_Control				; 3
	sta	COLUPF		 			; 3		@28
	stx	PF0					; 3 =  9	@31	clear PF0 (bits 0..3: don't Care)

; prepare tombstone row:
	lda	MaskTbl-1,x				; 4
	and	Data_PF_Left-1,x			; 4
	sta	Temp_PF_Left				; 3
	lda	Data_PF_Right-1,x			; 4
	sta	Temp_PF_Right				; 3 = 18

	SLEEP	4					; 4 =  4

; clear all hmov registers:
	sta	HMCLR					; 3 =  3	@56

; draw Gremlin #0:
	cpy	Gremlin0_Y_Temp				; 3
	bpl	.checkGremlin0_a	 		; 2³
;.drawGremlin0_a:
	lda	(Gremlin0_Pointer),y	 		; 5
	sta	HMM0					; 3
	asl						; 2
	asl						; 2
	sta	HMOVE					; 3		@75	four cycles too early, (just!) ok
;---------------------------------------
	sta	NUSIZ0		 			; 3		@03	(>= @00)
.continueGremlin0_a:			 		;	= 23			timing is constant!

; draw Car #0:
	lda	#CAR_HEIGHT-1				; 2
	dcp	Car0_Y					; 5
	bcs	.doDraw0_a	 			; 2³
	lda	#0			 		; 2
	BIT_W						;-1
.doDraw0_a:
	lda	(Car0_Pointer),y	 		; 5
	sta	GRP0					; 3 = 18	@21

; set color for second ball row:
	lda	#$0e					; 2
	sta	COLUPF		 			; 3 =  5	@26	(<= @27)

; tombstone indexer routine (part 2/2):
	dex						; 2
	bmi	.exitLoop				; 2³=  4

; disable grenade:
	lda	Ball_Control	 			; 3
	asl						; 2
	sta	ENABL					; 3		@38	VDELed!
	lda	#$90					; 2
	sta	PF0					; 3 = 13	@43

; clear all hmov registers:
	sta	HMCLR					; 3 =  3	@46

; TombstoneIndexer routine:
	dey						; 2
	lda	#$0e					; 2
	jmp	.nextBlock	 			; 3 =  7

.exitLoop:
	jmp	ExitKernel
;***************************************

.disableGremlin1_a:					; 9
	SLEEP	2					; 2				waste two cycles for constant timing
	lda	#DISABLE_BM				; 2
	beq	.continueM1a_a  			;10

.checkGremlin1_a:					; 6
	bne	.disableGremlin1_a			; 2³
;.enableGremlin1_a:
	lda	Gremlin1_Y				; 3
	sta	Gremlin1_Y_Temp  			; 3
	lda	#ENABLE_BM	 			; 2
.continueM1a_a:
;---------------------------------------
	sta.w	ENAM1					; 4		@01	(>= @00)
	bpl	.continueGremlin1_a			; 3

.disableGremlin0_a:					; 8
	SLEEP	2					; 5				waste two cycles for constant timing
	lda	#DISABLE_BM				; 2
	beq	.continueM0a_a  			; 9

.checkGremlin0_a:					; 6
	bne	.disableGremlin0_a			; 2³
;.enableGremlin0_a:
	lda	Gremlin0_Y				; 3
	sta	Gremlin0_Y_Temp  			; 3
	lda	#ENABLE_BM	 			; 2
.continueM0a_a:
;---------------------------------------
	sta.w	ENAM0					; 4		@02	(>= @00)
	bpl	.continueGremlin0_a			; 3
;***************************************
;end of Thomas Jentzsch's miracle kernel


ExitKernel:
	ldx	#$FF
	lda	#0
	ldy	Border_Bottom_Color
	sta	WSYNC
	sta	ENAM0
	sta	ENAM1
	sta	GRP0
	sta	GRP1
	sta	GRP0; this is necessary due to VDEL
	
;---------------------------------------
	sty	COLUPF
	stx	PF0			;					already 0
	stx	PF1
	stx	PF2
	ldx	#0
	sta	WSYNC; do 2nd line of border
	ldx	Forcefield_Generator_Color
  ; sta	WSYNC
	sta	PF0
	sta	PF1
	sta	PF2
	stx	COLUPF
	sta	WSYNC
	ldx	#2
.waitScreen0:
	lda	INTIM
	bne	.waitScreen0
	sta	WSYNC
	stx	VBLANK
	rts

;check boundaries
Rotation_Check_Boundaries SUBROUTINE
	lda	P0_CurrentRotationSequence,X
	cmp	#$FF
	beq	.Rotation_Wrap_Left
	cmp	#16
	beq	.Rotation_Wrap_Right
	rts ; no boundary crossed
.Rotation_Wrap_Left
	lda	#15
	sta	P0_CurrentRotationSequence,X
	rts
.Rotation_Wrap_Right
	lda	#0
	sta	P0_CurrentRotationSequence,X
	rts

Player_Reflect_Check SUBROUTINE
	;this will have been modified by the controller routines
	ldy	#TurnOffSpriteReflect; initialize to no flip
	
	;this will load either P0 or P1 depending on P0_P1_PARAMETER
	lda	P0_CurrentRotationSequence,X;0-15
	cmp	#FlipThreshold
	bmi	.Continue0	; if A < 9 then sigN will be 1
			; so do not flip, just .Continue
.FlipSprite0
	ldy	#TurnOnSpriteReflect

.Continue0
	sty	REFP0,X
	RTS
	


;DRIVING CONTROLLER CODE
Read_Driving_Controller SUBROUTINE
	; ldy	SWCHA_Previous
	lda	SWCHA_Previous,X
	tay
	lda	SWCHA_Nybble,X
	and	#%00000011
	sta	SWCHA_Previous,X; this might have to move
	lda	SWCHA_Nybble,X

	and	#%00000011
	eor	NextDCTab,y  ; works like cmp	for beq
	beq	.leftTurn
	eor	#%00000011
	beq	.rightTurn
	RTS
.leftTurn:
	dec	P0_CurrentRotationSequence,X
	RTS
.rightTurn:
	inc	P0_CurrentRotationSequence,X
	RTS
;/DRIVING CONTROLLER CODE

Transmission SUBROUTINE
	stx	Car_Picker
	lda	SWCHA_Nybble,X
	and	#%00001100
	cmp	#%00000100
	beq	.CarReverseGear
	cmp	#%00001000
	beq	.CarForwardGear
	RTS
	;bcs	.Car1Transmission
.CarForwardGear
	lda	#0
	sta	Car0_Gear,X
	RTS
.CarReverseGear
	lda	#$FF
	sta	Car0_Gear,X
	RTS

Gas_Pedal SUBROUTINE
	;do gas pedal
	ldx	Car_Picker
	txa
	;read the fire button
	beq	.other_button
	lda	INPT5;INPT,X
	bpl	.Accelerate
	jmp     .Decelerate

.other_button
	lda	INPT4;INPT,X


	bpl	.Accelerate
.Decelerate
	rts
	
.Accelerate 
	;rts
	jmp 	.Process_Acceleration
	
	lda	Car_Vector_Sequence_Forward
	sta	Overlay2
	
	jmp	.odd_frame; disable below for now

	lda	Frame_Counter
	clc
	lsr
	bcs	.odd_frame
.even_frame
	lda	Overlay2
	lsr
	lsr
	lsr
	lsr
	sta	Overlay2
.odd_frame


	
	;WORK ON THIS AREA!!
	;jmp 	.VL_Check0
.Process_Acceleration
	ldx	Car_Picker
	;ldx 	#1



	lda	Car0_Gear,X
	beq	.do_forward_acceleration
	lda	P0_CurrentRotationSequence,X
	tax
	lda	Car_Vector_Sequence_Reverse,X
	jmp	.continue_acceleration
	
.do_forward_acceleration
	lda	P0_CurrentRotationSequence,X
	tax
	lda	Car_Vector_Sequence_Forward,X

.continue_acceleration
	ldx	Car_Picker

	
	ldy	Car0_YFullres,X
	
	lsr
	bcs	.skipUpCar
.doDownCar:
	iny	; Car0_Y++
	cpy	#Y_BOUNDARY_BOTTOM;#KERNEL_HEIGHT+1|$80
	bne	.skipUpCar

	ldy	#1;|$80
.skipUpCar:

	lsr
	bcs	.skipDownCar
.doUpCar:

	dey


	;bounds check for top of screen
	cpy	#0
	bne	.skipDownCar
	;brk
	ldy	#Y_BOUNDARY_BOTTOM;|$80; reset to bottom of screen
.skipDownCar:
	
	sty	Car0_YFullres,X

	lsr
	ldy	Car0_X,X
	bcs	.skipLeftCar
	bne	.doLeftCar
	ldy	#SCREEN_WIDTH
.doLeftCar:
	dey; Car0_X-- 
.skipLeftCar:
	lsr
	bcs	.skipRightCar
.doRightCar:
	iny ; Car0_X++
	cpy	#SCREEN_WIDTH
	bne	.skipRightCar

	ldy	#0

.skipRightCar:
	sty	Car0_X,X



	rts



OverScan SUBROUTINE
	lda	#36
	sta	TIM64T

	bit	SWCHB
	bmi	.set_Barrier; difficulty switch was toggled
	lda	#0; powerup
	jmp	.store_Ball_type
.set_Barrier
	lda	#3; barrier
.store_Ball_type
	sta	Ball_Type


;COLLISION DETECTION

	
	ldx	#1
.collision_detection
	lda	CXM0P,X
 	bpl	.no_killings


	;testing score increment
	lda	Car0_Score,X
	sed
	clc
	adc	#1
	cld
	sta	Car0_Score,X
	
	lda	#0
	sta	Gremlin0_X,X

	
	
	
.no_killings
 	dex
 	bpl	.collision_detection
 

	sta	CXCLR
;BEGIN USER INPUT SEGMENT
;BEGIN USER INPUT SEGMENT
;BEGIN USER INPUT SEGMENT
;BEGIN USER INPUT SEGMENT

	;this should be the only sample of SWCHA for the frame
	lda	SWCHA

	sta	SWCHA_Current

	;SPLIT OFF THE DATA INTO TWO BYTES WITH THE BITS ALIGNED THE SAME
	;THAT WAY THE Read_Driving_Controller CAN BE GENERAL-PURPOSE
	sta	SWCHA_Nybble+1
	LSR
	LSR
	lSR
	lSR
	sta	SWCHA_Nybble


	;if game is over, freeze the cars wherever they last were
	lda 	Game_State
	beq 	.skip_Car_Engine
	
	ldx	#2 
.Read_Controllers
	dex 
	stx	Temp_Var
	jsr	Read_Driving_Controller
	jsr	Rotation_Check_Boundaries
	jsr	Player_Reflect_Check



	jsr	Transmission
	jsr	Gas_Pedal

	ldx	Temp_Var
	bne	.Read_Controllers

.skip_Car_Engine



	ldx	#1 

;GREMLIN ANIMATION
; turn this into a bounds-checking-only routine
.moveGremlins:
	;lda	Frame_Counter
	;and	#$02 ; determines speed
	;bne	.skipJoystick

.loopMoveGremlins:
	lda	SWCHA0_FAKE,X
	;lda	SWCHA_Nybble,X
	ldy	Gremlin0_Y,x
	lsr
	bcs	.skipUpGremlin
	iny
	cpy	#KERNEL_HEIGHT+1|$80
	bne	.skipUpGremlin
	ldy	#1|$80
.skipUpGremlin:;SWCHA0_FAKE = %00000001

	lsr
	bcs	.skipDownGremlin

	dey
	
	
	cpy	#0|$80
	bne	.skipDownGremlin
	ldy	#KERNEL_HEIGHT|$80
.skipDownGremlin:;SWCHA0_FAKE = %00000010
	sty	Gremlin0_Y,x

	lsr
	ldy	Gremlin0_X,x
	bcs	.skipLeftGremlin
	bne	.skipResetLeftGremlin
	ldy	#SCREEN_WIDTH
.skipResetLeftGremlin:;SWCHA0_FAKE = %00000100
	dey
.skipLeftGremlin:

	lsr
	bcs	.skipRightGremlin





	iny
	cpy	#SCREEN_WIDTH
	bne	.skipRightGremlin


	
	ldy	#0

	;cpx	#0	
	;bne	.skipRightGremlin
	



.skipRightGremlin:
	sty	Gremlin0_X,x


	dex
	bpl	.loopMoveGremlins
	
	
	
	
	
.skipJoystick:

.waitTim:
	lda	INTIM
	bne	.waitTim
	rts


SetPosX SUBROUTINE
; TODO: use new Fatal Run method discovered by Manuel
; calculates the values and	positions objects:
; Input:
; - a = x-position
	tay					; 2
	iny					; 2
	tya				 	; 2
	and	#$0F			 	; 2
	sta	Temp_Var		 	; 3
	tya					; 2
	lsr					; 2
	lsr					; 2
	lsr					; 2
	lsr					; 2
	tay					; 2
	clc					; 2
	adc	Temp_Var			; 3
	cmp	#$0F			 	; 2
	bcc	.skipIny		 	; 2
	sbc	#$0F			 	; 2
	iny					; 2
.skipIny:
	sta	WSYNC				; 3
	eor	#$07			 	; 2
	asl					; 2
	asl					; 2
	asl					; 2
	asl					; 2
	sta.wx	HMP0,x				; 5		@15
.waitPos:
	dey					; 2
	bpl	.waitPos		 	; 2³
.bankCheck:
	sta	RESP0,X				; 4
	rts					; 6
;SetPosX END


;===============================================================================
; R O M - T A B L E S (Bank 0)
;===============================================================================
	org	$fA00

Title_PF_L  ;	76543210
	.byte %00000000 | %00000000 ;%00000000
	.byte %00000000 | %00000000
	.byte %00000000 | %00000000
	.byte %00000000 | %00101111
	.byte %00011000 | %00000000
	.byte %00011000 | %00000000
	.byte %00100100 | %00000000
	.byte %01000010 | %00000000
	.byte %10000001 | %00000000
	.byte %01000000 | %00011111
	.byte %00000000 | %00000000

	.byte 0
Title_PF_R  ;	01234567

	.byte %00000000 | %00000000
	.byte %00000000 | %00000000
	.byte %01010111 | %00000000
	.byte %00000100 | %00100000
	.byte %00001000 | %00010000
	.byte %00010000 | %00001000
	.byte %00100000 | %00000100
	.byte %01000000 | %00000010
	.byte %00111111 | %00000000
	.byte %00000000 | %00000000
	.byte %00000000 | %00000000  
	
	.byte 0
	
Car_Rotation_Sequence:
	;NO FLIP BIT - FACE RIGHT
	.byte <Car_Rotation_Frame0 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;0  - point up
	.byte <Car_Rotation_Frame1 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;1  - 
	.byte <Car_Rotation_Frame2 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;2  - 
	.byte <Car_Rotation_Frame3 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;3  - 
	.byte <Car_Rotation_Frame4 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;4  - point right
	.byte <Car_Rotation_Frame5 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;5  - 
	.byte <Car_Rotation_Frame6 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;6  - 
	.byte <Car_Rotation_Frame7 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;7  - 
	.byte <Car_Rotation_Frame8 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;8  - point down
	; WITH FlipThreshold - FACE LEFT
	.byte <Car_Rotation_Frame7 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;9  - 
	.byte <Car_Rotation_Frame6 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;10 - 
	.byte <Car_Rotation_Frame5 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;11 - 
	.byte <Car_Rotation_Frame4 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;12 - point left
	.byte <Car_Rotation_Frame3 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;13 - 
	.byte <Car_Rotation_Frame2 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;14 - 
	.byte <Car_Rotation_Frame1 - TOMBSTONE_ROWS*TOMBSTONE_HEIGHT - CAR_HEIGHT;15 - 
	

Gremlin_Table:
	.byte	0;dummy byte
	.byte	<Gremlin_Frame0_Left  + GREMLIN_HEIGHT-1; points to top of graphics
	.byte	<Gremlin_Frame1_Left  + GREMLIN_HEIGHT-1
	.byte	<Gremlin_Frame2_Left  + GREMLIN_HEIGHT-1
	.byte	<Gremlin_Frame3_Left  + GREMLIN_HEIGHT-1
	.byte	<Gremlin_Frame4_Left  + GREMLIN_HEIGHT-1
	
	.byte	<Gremlin_Frame0_Right + GREMLIN_HEIGHT-1
	.byte	<Gremlin_Frame1_Right + GREMLIN_HEIGHT-1
	.byte	<Gremlin_Frame2_Right + GREMLIN_HEIGHT-1
	.byte	<Gremlin_Frame3_Right + GREMLIN_HEIGHT-1
	.byte	<Gremlin_Frame4_Right + GREMLIN_HEIGHT-1



; I don't know why these have to be -1 less but they do
HMMx_Compensation_Table:
;neg to pos
	.byte	3
	.byte	2
	.byte	1
	.byte	0

Pot2Tbl:
V SET 1
  REPEAT	8
	.byte V
V SET V + V
  REPEND
;	.byte	$01, $02, $04, $08, $10, $20, $40, $80

MaskTbl:
V SET %01010101
  REPEAT	TOMBSTONE_ROWS
	.byte V
V SET V ^ $ff
  REPEND

	org	$fA00 + TOMBSTONE_ROWS*TOMBSTONE_HEIGHT + CAR_HEIGHT

Car_Rotation_Frame0;UP (ACTUAL)
  ;.byte %00000000
	.byte %01011010; .X.XX.X.
	.byte %01111110; .XXXXXX.
	.byte %01100110; .XX..XX.
	.byte %00011000; ...XX...
	.byte %01011010; .X.XX.X.
	.byte %01111110; .XXXXXX.
	.byte %01011010; .X.XX.X.
	.byte %00011000; ...XX...

Car_Rotation_Frame1
  ;.byte %00000000
	.byte %00000110; ....XX..
	.byte %00011110; ..XXXX..
	.byte %01110100; XXX.X...
	.byte %00011010; XX.XX.X.
	.byte %00011010; ...XX.X.
	.byte %01011111; .X.XXXXX
	.byte %00111100; ..XXXX..
	.byte %00101100; ..X.XX..

Car_Rotation_Frame2
  ;.byte %00000000
	.byte %00011000; ...XX...
	.byte %01111000; .XXXX...
	.byte %01000010; .X....X.
	.byte %11011011; XX.XX.XX
	.byte %11011100; XX.XXX..
	.byte %00011110; ...XXXX.
	.byte %00110110; ..XX.XX.
	.byte %00010000; ...X....

Car_Rotation_Frame3
  ;.byte %00000000
	.byte %00110000; ..XX....
	.byte %00110010; ..XX.X..
	.byte %01100011; .XX...XX
	.byte %01011110; .X.XXXX.
	.byte %11111111; XXXXXXXX
	.byte %11000111; XX...XXX
	.byte %00011100; ...XXX..
	.byte %00000100; .....X..

Car_Rotation_Frame4;RIGHT|LEFT
  ;.byte %00000000
	.byte %00000000; ........
	.byte %11101110; XXX.XXX.
	.byte %01100100; .XX..X..
	.byte %11011111; XX.XXXXX
	.byte %11011111; XX.XXXXX
	.byte %01100100; .XX..X..
	.byte %11101110; XXX.XXX.
	.byte %00000000; ........

Car_Rotation_Frame5
  ;.byte %00000000
	.byte %00000100; .....X..
	.byte %00011100; ...XXX..
	.byte %11000111; XX...XXX
	.byte %11111111; XXXXXXXX
	.byte %01011110; .X.XXXX.
	.byte %01100011; .XX...XX
	.byte %00110010; ..XX.X..
	.byte %00110000; ..XX....

Car_Rotation_Frame6
  ;.byte %00000000
	.byte %00010000; ...X....
	.byte %00110110; ..XX.XX.
	.byte %00011110; ...XXXX.
	.byte %11011100; XX.XXX..
	.byte %11011011; XX.XX.XX
	.byte %01000010; .X....X.
	.byte %01111000; .XXXX...
	.byte %00011000; ...XX...

Car_Rotation_Frame7
  ;.byte %00000000
	.byte %00101100; ..X.XX..
	.byte %00111100; ..XXXX..
	.byte %01011111; .X.XXXXX
	.byte %00011010; ...XX.X.
	.byte %11011010; XX.XX.X.
	.byte %11101000; XXX.X...
	.byte %00111100; ..XXXX..
	.byte %00001100; ....XX..

Car_Rotation_Frame8;DOWN (ACTUAL)
  ;.byte %00000000
	.byte %00011000; ...XX...
	.byte %01011010; .X.XX.X.
	.byte %01111110; .XXXXXX.
	.byte %01011010; .X.XX.X.
	.byte %00011000; ...XX...
	.byte %01100110; .XX..XX.
	.byte %01111110; .XXXXXX.
	.byte %01011010; .X.XX.X.

Gremlin_Frame0_Left;	OOOOWWAA
	.byte HMOVE_R1|BM_SIZE_2/4|0 ; .....XX. 2
	.byte HMOVE_R3|BM_SIZE_2/4|0 ; ....XX.. 1
	.byte HMOVE_L2|BM_SIZE_4/4|0 ; .XXXX...-2
	.byte HMOVE_R2|BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_L3|BM_SIZE_4/4|0 ; .XXXX...-2
	.byte HMOVE_R1|BM_SIZE_1/4|0 ; ....X... 1
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0

Gremlin_Frame1_Left;	OOOOWWAA
	.byte HMOVE_R1|BM_SIZE_2/4|0 ; ....XX.. 1
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_R2|BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_L3|BM_SIZE_4/4|0 ; .XXXX...-2
	.byte HMOVE_R1|BM_SIZE_1/4|0 ; ....X... 1
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	
Gremlin_Frame2_Left;	OOOOWWAA
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_R2|BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_L3|BM_SIZE_4/4|0 ; .XXXX...-2
	.byte HMOVE_R1|BM_SIZE_1/4|0 ; ....X... 1
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0

Gremlin_Frame3_Left;	OOOOWWAA
	.byte HMOVE_L1|BM_SIZE_2/4|0 ; ..XX....-1
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_R2|BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_L3|BM_SIZE_4/4|0 ; .XXXX...-2
	.byte HMOVE_R1|BM_SIZE_1/4|0 ; ....X... 1
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0

Gremlin_Frame4_Left;	OOOOWWAA
	.byte HMOVE_L2|BM_SIZE_2/4|0 ; .XX.....-2
	.byte HMOVE_0 |BM_SIZE_4/4|0 ; ...XXXX. 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_R2|BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_L3|BM_SIZE_4/4|0 ; .XXXX...-2
	.byte HMOVE_R1|BM_SIZE_1/4|0 ; ....X... 1
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0




Gremlin_Frame0_Right;	OOOOWWAA
	.byte HMOVE_L1|BM_SIZE_2/4|0 ; .XX..... 0
	.byte HMOVE_L1|BM_SIZE_2/4|0 ; ..XX.... 0
	.byte HMOVE_0 |BM_SIZE_4/4|0 ; ...XXXX. 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_4/4|0 ; ...XXXX. 0
	.byte HMOVE_0 |BM_SIZE_1/4|0 ; ...X.... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0

Gremlin_Frame1_Right;	OOOOWWAA
	.byte HMOVE_L1|BM_SIZE_2/4|0 ; ..XX.... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_4/4|0 ; ...XXXX. 0
	.byte HMOVE_0 |BM_SIZE_1/4|0 ; ...X.... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0

Gremlin_Frame2_Right;	OOOOWWAA
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_4/4|0 ; ...XXXX. 0
	.byte HMOVE_0 |BM_SIZE_1/4|0 ; ...X.... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0


Gremlin_Frame3_Right;	OOOOWWAA
	.byte HMOVE_R1|BM_SIZE_2/4|0 ; ....XX.. 1
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_4/4|0 ; ...XXXX. 0
	.byte HMOVE_0 |BM_SIZE_1/4|0 ; ...X.... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0

Gremlin_Frame4_Right;	OOOOWWAA
	.byte HMOVE_R4|BM_SIZE_2/4|0 ; .....XX.+2
	.byte HMOVE_L2|BM_SIZE_4/4|0 ; .XXXX...-2
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; . .XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_4/4|0 ; ...XXXX. 0
	.byte HMOVE_0 |BM_SIZE_1/4|0 ; ...X.... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0
	.byte HMOVE_0 |BM_SIZE_2/4|0 ; ...XX... 0

	Align 256

Score0_Digit_Table:
	.byte <Score_0-1;0
	.byte <Score_1-1;1
	.byte <Score_2-1;2
	.byte <Score_3-1
	.byte <Score_4-1
	.byte <Score_5-1
	.byte <Score_6-1
	.byte <Score_7-1
	.byte <Score_8-1
	.byte <Score_9-1
	.byte <Score_1st_Gear-1 ;ID 10
	.byte <Score_2nd_Gear-1 ;ID 11
	.byte <Score_3rd_Gear-1 ;ID 12
	.byte <Score_Reverse_Gear-1 ;ID 13
	.byte <Score_Blank
Score1_Digit_Table:
	.byte <Score_0-1 ;0
	.byte <Score_1b-1 ;1
	.byte <Score_2b-1 ;2
	.byte <Score_3b-1 
	.byte <Score_4b-1 
	.byte <Score_5b-1 
	.byte <Score_6b-1
	.byte <Score_7b-1 
	.byte <Score_8-1 
	.byte <Score_9b-1
	;special characters
	.byte <Score_1st_Gear-1 ;ID 10
	.byte <Score_2nd_Gear-1 ;ID 11
	.byte <Score_3rd_Gear-1 ;ID 12
	.byte <Score_Reverse_Gear-1 ;ID 13
	.byte <Score_Blank

Score_0
	.byte %11101110
	.byte %10101010
	.byte %10101010
	.byte %10101010
	.byte %11101110

Score_1
	.byte %01000100
	.byte %01000100
	.byte %01000100
	.byte %01000100
	.byte %01000100

Score_2
	.byte %11101110
	.byte %10001000
	.byte %11101110
	.byte %00100010
	.byte %11101110



Score_3
	.byte %11101110
	.byte %00100010
	.byte %01100110
	.byte %00100010
	.byte %11101110
	
Score_4

	.byte %00100010
	.byte %00100010
	.byte %11101110
	.byte %10101010
	.byte %10101010
	
Score_5
	.byte %11101110
	.byte %00100010
	.byte %11101110
	.byte %10001000
	.byte %11101110
	
Score_6
	.byte %11101110
	.byte %10101010
	.byte %11101110
	.byte %10001000
	.byte %11101110


Score_7

	.byte %00100010
	.byte %00100010
	.byte %00100010
	.byte %00100010
	.byte %11101110


Score_8
	.byte %11101110
	.byte %10101010
	.byte %11101110
	.byte %10101010
	.byte %11101110


Score_9
	.byte %00100010
	.byte %00100010
	.byte %11101110
	.byte %10101010
	.byte %11101110

	

Score_1b

	.byte %01000100
	.byte %01000100
	.byte %01000100
	.byte %01000100
	.byte %01000100

	
Score_2b
	.byte %11101110
	.byte %00100010
	.byte %11101110
	.byte %10001000
	.byte %11101110

Score_3b
	.byte %11101110
	.byte %10001000
	.byte %11001100
	.byte %10001000
	.byte %11101110

	
Score_4b

	.byte %10001000
	.byte %10001000
	.byte %11101110
	.byte %10101010
	.byte %10101010


Score_5b
	.byte %11101110
	.byte %10001000
	.byte %11101110
	.byte %00100010
	.byte %11101110



Score_6b
	.byte %11101110
	.byte %10101010
	.byte %11101110
	.byte %00100010
	.byte %11101110
	
Score_7b

	.byte %10001000
	.byte %10001000
	.byte %10001000
	.byte %10001000
	.byte %11101110


Score_9b
	.byte %10001000
	.byte %10001000
	.byte %11101110
	.byte %10101010
	.byte %11101110


Score_Blank
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0


Score_1st_Gear:
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %01100000
	.byte %00000000
Score_2nd_Gear:
	.byte %00000000
	.byte %01100000
	.byte %00000000
	.byte %01100000
	.byte %00000000
Score_3rd_Gear:
	.byte %00000000
	.byte %01100000
	.byte %01100000
	.byte %01100000
	.byte %00000000
	
Score_Reverse_Gear:
	.byte %10100000
	.byte %10100000
	.byte %11000000
	.byte %10100000
	.byte %11000000


Car_Vector_Sequence_Forward:
	;     1111		EVEN FRAME DELTA
	;               1111	ODD FRAME  DELTA
	.byte JS1_UP        ;|JS1_UP         << 4	;0	UP
	.byte JS1_UP        ;|JS1_UP_RIGHT   << 4	;1
	.byte JS1_UP_RIGHT  ;|JS1_UP_RIGHT   << 4	;2
	.byte JS1_RIGHT     ;|JS1_UP_RIGHT   << 4	;3
	.byte JS1_RIGHT     ;|JS1_RIGHT      << 4	;4	RIGHT
	.byte JS1_RIGHT     ;|JS1_DOWN_RIGHT << 4	;5
	.byte JS1_DOWN_RIGHT;|JS1_DOWN_RIGHT << 4	;6
	.byte JS1_DOWN      ;|JS1_DOWN_RIGHT << 4	;7
	.byte JS1_DOWN      ;|JS1_DOWN       << 4	;8	DOWN
	.byte JS1_DOWN      ;|JS1_DOWN_LEFT  << 4	;9
	.byte JS1_DOWN_LEFT ;|JS1_DOWN_LEFT  << 4	;10
	.byte JS1_LEFT      ;|JS1_DOWN_LEFT  << 4	;11
	.byte JS1_LEFT      ;|JS1_LEFT 	    << 4	;12	LEFT
	.byte JS1_LEFT      ;|JS1_UP_LEFT    << 4	;13
	.byte JS1_UP_LEFT   ;|JS1_UP_LEFT    << 4	;14
	.byte JS1_UP        ;|JS1_UP_LEFT    << 4	;15


Car_Vector_Sequence_Reverse:
	.byte JS1_DOWN        ;|JS1_UP_LEFT    << 4	;15
	.byte JS1_DOWN        ;|JS1_UP         << 4	;0	UP
	.byte JS1_DOWN_LEFT   ;|JS1_UP_LEFT    << 4	;14
	.byte JS1_LEFT      ;|JS1_UP_LEFT    << 4	;13
	.byte JS1_LEFT      ;|JS1_LEFT 	    << 4	;12	LEFT
	.byte JS1_LEFT      ;|JS1_DOWN_LEFT  << 4	;11
	.byte JS1_UP_LEFT ;|JS1_DOWN_LEFT  << 4	;10
	.byte JS1_UP      ;|JS1_DOWN_LEFT  << 4	;9
	.byte JS1_UP      ;|JS1_DOWN       << 4	;8	DOWN
	.byte JS1_UP      ;|JS1_DOWN_RIGHT << 4	;7
	.byte JS1_UP_RIGHT;|JS1_DOWN_RIGHT << 4	;6
	.byte JS1_RIGHT     ;|JS1_DOWN_RIGHT << 4	;5
	.byte JS1_RIGHT     ;|JS1_RIGHT      << 4	;4	RIGHT
	.byte JS1_RIGHT     ;|JS1_UP_RIGHT   << 4	;3
	.byte JS1_DOWN_RIGHT  ;|JS1_UP_RIGHT   << 4	;2
	.byte JS1_DOWN        ;|JS1_UP_RIGHT   << 4	;1



Border_Type_Table:
	.byte $32; red 	- solid
	.byte $1D; yellow 	- crashthru
	.byte $CD; green 	- passthru
;for greyscale
	.byte $0F; white 	- solid
	.byte $06; grey 	- crashthru
	.byte $02; dark grey	- passthru
	
Grenade_Size_Table:
	.byte BM_SIZE_8 ; powerups are big
	.byte BM_SIZE_2 ; grenades are small
	.byte BM_SIZE_1 ; easter egg
	.byte BM_SIZE_2 ; barrier
	
Grenade_Color_Table:
	.byte $56; purple 	- powerup
	.byte $D4; olive 	- grenade
	.byte $00; black 	- easter egg
	.byte $0F; ; barrier	
	
;for greyscale
	.byte $0F; white 	- powerup
	.byte $06; grey	 - grenade
	.byte $04; grey 	- easter egg (give those with B&W TVs an advantage)
	.byte $0F; ; barrier	
Gremlin_Offset:
	.byte 1
	.byte 0

;Gremlin_X_Reset:
;	.byte	0
;	.byte	0

INPT:
	.byte INPT5
	.byte INPT4
NextDCTab:
	.byte %01, %11, %00, %10
	
	org $FFFC;4K ROM
	.word	Start
	.word	Start
