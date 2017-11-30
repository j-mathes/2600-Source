;-----------------------SQUISH 'EM----------------------------------------
;-----------------BOB MONTGOMERY (C)2007----------------------------------
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;--------------------TO DO:
;
;		-*DONE*re-write main kernel loop into two loops: 	top loop doesn't draw enemy
;													bottom loop does (save gfx ROM)
;		-*DONE*use actual enemy graphics (and animate)
;		-*DONE*add multiple entrance points to kernel with appropriate timings
;		-*DONE*add girder color changes
;		-*DONE*clean up kernel transitions, tighten up all SLEEPs, and finalize all page-crossing locations
;			(and get scanline count at steady 262 [or?])
;		-*CANCELLED*stripe brick? - it turned out to be much more work than I thought
;		-*DONE*add scrolling
;		-*DONE BUT BUGGY*add enemy/girder data generator !!!!!!!!!OCCASIONAL BUGS!!!!!!!!!!
;		-*DONE*add enemy movement schemes 
;		-*DONE*constrain player movement
;		-*DONE*add collision detection 
;		-*DONE*animate player
;		-*DONE*add squishing			(start thread in homebrew forum here?  Or earlier?)
;	-----------need to be at this point by Thanksgiving!------------------
;		-*DONE*death animation (figure out how to scroll player off bottom of screen)
;		-*DONE*add sfx - Death sound still needs completing
;		-*DONE*add music
;		-*DONE*add scoring
;		-*DONE*add background/girder flashing effects - need to move enemy pointer setup to 
;							kernel prep subroutine (so it doesn't get skipped when we don't move enemies)
;		-*DONE*change girder colors between levels
;		-*DONE*all gamestate transitions
;		-*DONE*add level transitions
;		-*DONE*console controls - decided: no pause.
;		-testing/polishing/match to original
;	-----------aim for December 1 at this point!--------------------------
;		-*CANCELLED*SaveKey/AVox?  No time and not worth the trouble.
;		-*DONE*PAL60 conversion
;
;
;	----------FINAL POLISHING LIST OF ISSUES------------------------------
;
;		-*DONE*girder colors should not reset when you hit SELECT
;		-*DONE*enemies should pause at the sides
;		-*DONE*brick sound should (I think?) start sooner before the brick appears 
;		-*CANCELLED*striping brick? - it turned out to be much more work than I thought
;		-*DONE*score color didn't reset after level-up music while brick onscreen
;
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------


	processor 6502
	include vcs.h
	include macro.h


;-------------------------Constants Below---------------------------------


	;--compile flags
NTSC			=	1		;0 == PAL60.  No provision for PAL50 or SECAM right now (or, probably, ever)
INFINITELIVES	=	0		;self-explanatory
QUICKDEATH		=	0		;start with zero extra lives
	;--end compile flags


INITIALPLAYERY		=		36
INITIALPLAYERX		=		50

ENDMONSTERVALUE		=		$F0	;other possible values: 02-03, 05-07, 09-0B, 0D-0F
								;						10, 12-17, 1B
								;						20-23, 26-27, 29, 2B, 2D-2F
								;						31-33, 35, 37, 39-3B, 3D
								;						etc.

INITIALLEVEL		=		1

	IF QUICKDEATH
INITIALLIVES		=		0
	ELSE
INITIALLIVES		=		3
	ENDIF



MAXVISIBLELEVELS	=		6
BRICKHEIGHT			=		3
ENEMYHEIGHT			=		11
PLAYAREAHEIGHT		=		80

PLAYERHEIGHT		=		27
STATICGIRDER_PF1	=		%11000100
STATICGIRDER_PF2	=		%00100010


	IF NTSC
INITIALGIRDERCOLOR1		=		GRADIENTCOLOR+10
INITIALGIRDERCOLOR2		=		RED+8		;PURPLE+6

GRADIENTCOLOR		=		BURNTORANGE+0		;RED+0
PANTSCOLOR			=		GREEN+14			;BROWNGREEN+14
SHIRTCOLOR			=		TANGREEN+10			;TAN+8
HEADCOLOR			=		ORANGE+14			;BROWN+12
	ELSE
INITIALGIRDERCOLOR1		=		GRADIENTCOLOR+10
INITIALGIRDERCOLOR2		=		$48		

GRADIENTCOLOR		=		$40		
PANTSCOLOR			=		$7E		
SHIRTCOLOR			=		$3A		
HEADCOLOR			=		$2E		
	ENDIF

LBOUND_ENEMY		=		24
RBOUND_ENEMY		=		127

RANDOMSEED			=		$A5


STOP				=		0
BOUNCE				=		1
FOLLOW				=		2
ERRATIC				=		3

;---EnemyMovement bits

ENEMYDIRECTION_BIT		=	%10000000
ENEMYSQUISHED_BIT		=	%01000000
ENEMYSTOPCOUNTER_BITS	=	%00111111

;---EnemyMovement values

ENEMYR				=	%00000000
ENEMYL				=	%10000000


ENEMYSTOPLOBIT		=	%00000001





;---EnemyType values

BLANKENEMY			=	0
SUITCASE			=	20


;---PlayerFlags values & bits

SMASH_BIT			=	%00000001

DYING_BIT			=	%00000100
PLAYERDIR_BIT		=	%00001000
PLAYERMOVE16_BIT	=	%00010000

PLAYERRIGHT			=	%00001000
PLAYERLEFT			=	%00000000


;---PlayerFrame bits & values

HANGINGFRAME		=	%000
CLIMBINGFRAME		=	%001
LEGSUPFRAME			=	%010
SHIMMY1FRAME		=	%011
SHIMMY2FRAME		=	%100


;--LegsUpCounter values

LEGSUPTIME			=	%00011111


;--MusicIndex values

BEGINGAMEMUSICLENGTH	=	$68
SUITCASEMUSICLENGTH		=	$A0
DIEDRESTARTMUSICLENGTH	=	$30
NEWLEVELMUSICLENGTH		=	$18

;-------------------------COLOR CONSTANTS (NTSC)--------------------------

GRAY		=	$00
GOLD		=	$10
ORANGE		=	$20
BURNTORANGE	=	$30
RED		=	$40
PURPLE		=	$50
PURPLEBLUE	=	$60
BLUE		=	$70
BLUE2		=	$80
LIGHTBLUE	=	$90
TURQUOISE	=	$A0
GREEN		=	$B0
BROWNGREEN	=	$C0
TANGREEN	=	$D0
TAN		=	$E0
BROWN		=	$F0

;--------------------------TIA CONSTANTS----------------------------------

	;--NUSIZx CONSTANTS
	;	player:
ONECOPYNORMAL		=	$00
TWOCOPIESCLOSE		=	$01
TWOCOPIESMED		=	$02
THREECOPIESCLOSE	=	$03
TWOCOPIESWIDE		=	$04
ONECOPYDOUBLE		=	$05
THREECOPIESMED		=	$06
ONECOPYQUAD		=	$07
	;	missile:
SINGLEWIDTHMISSILE	=	$00
DOUBLEWIDTHMISSILE	=	$10
QUADWIDTHMISSILE	=	$20
OCTWIDTHMISSILE		=	$30

	;---CTRLPF CONSTANTS
	;	playfield:
REFLECTEDPF		=	%00000001
SCOREPF			=	%00000010
PRIORITYPF		=	%00000100
	;	ball:
SINGLEWIDTHBALL		=	SINGLEWIDTHMISSILE
DOUBLEWIDTHBALL		=	DOUBLEWIDTHMISSILE
QUADWIDTHBALL		=	QUADWIDTHMISSILE
OCTWIDTHBALL		=	OCTWIDTHMISSILE

	;---HMxx CONSTANTS
LEFTSEVEN		=	$70
LEFTSIX			=	$60
LEFTFIVE		=	$50
LEFTFOUR		=	$40
LEFTTHREE		=	$30
LEFTTWO			=	$20
LEFTONE			=	$10
NOMOVEMENT		=	$00
RIGHTONE		=	$F0
RIGHTTWO		=	$E0
RIGHTTHREE		=	$D0
RIGHTFOUR		=	$C0
RIGHTFIVE		=	$B0
RIGHTSIX		=	$A0
RIGHTSEVEN		=	$90
RIGHTEIGHT		=	$80

	;---AUDCx CONSTANTS (P Slocum's naming convention)
SAWSOUND		=	1
ENGINESOUND		=	3
SQUARESOUND		=	4
BASSSOUND		=	6
PITFALLSOUND		=	7
NOISESOUND		=	8
LEADSOUND		=	12
BUZZSOUND		=	15

	;---SWCHA CONSTANTS (JOYSTICK)
J0RIGHT		=	%10000000
J0LEFT		=	%01000000
J0DOWN		=	%00100000
J0UP		=	%00010000
J1RIGHT		=	%00001000
J1LEFT		=	%00000100
J1DOWN		=	%00000010
J1UP		=	%00000001

	;---SWCHB CONSTANTS (CONSOLE SWITCHES)
P1DIFF		=	%10000000
P0DIFF		=	%01000000
BWCOLOR		=	%00001000
SELECT		=	%00000010
RESET		=	%00000001

;-------------------------End Constants-----------------------------------

;-----------------------------Macros--------------------------------------

	MAC FILLER
		REPEAT {1}
		.byte {2}
		REPEND
	ENDM
	


;------------------------------Variables----------------------------------

	SEG.U Variables
   	org $80

FrameCounter ds 1

ScrollCounter ds 1


StartLevel ds 1
Floor ds 1
Level ds 1				

RandomNumber ds 1

Score ds 3

ScoreColor ds 1
GirderColor1 ds 1		;color of horizontal (floor) girders
GirderColor2 ds 1		;color of vertical (climbing) girders

ColorMask ds 1
FlashScreenTimer ds 1


EnemyPtr ds MAXVISIBLELEVELS*2
EnemyColor ds MAXVISIBLELEVELS
EnemyPosition ds MAXVISIBLELEVELS
EnemyMovement ds MAXVISIBLELEVELS
EnemyType ds MAXVISIBLELEVELS


GirderPattern ds MAXVISIBLELEVELS

MoveEnemiesDelay ds 1

EnemyCollisions ds 1
BrickCollision ds 1

PF1Temp ds 1
PF2Temp ds 1
PF3Temp ds 1
PF4Temp ds 1

PlayerGfxPtr1 ds 2
PlayerGfxPtr2 ds 2
PlayerClrPtr1 ds 2
PlayerClrPtr2 ds 2

PlayerY ds 1
PlayerX ds 1

PlayerMove ds 1
PlayerFrame ds 1
PlayerFrameOffset ds 1
PlayerFlags ds 1
LegsUpCounter ds 1
ClearedEnemy ds 1		;0 for didn't, 1 for possible clear, 2 for definite clear.
PlayerDeathTimer ds 1
DyingSoundFlag ds 1

BrickX ds 1
BrickY ds 1
BrickMovement ds 1
BrickFallingSound ds 1
BrickTimer ds 1			;timer for new brick

ExtraLives ds 1
MusicIndex ds 1
SFXIndex0 ds 1
SFXIndex1 ds 1
GameOnFlag ds 1

ConsoleSwitchDebounce ds 1
TriggerDebounce ds 1

KernelPtr ds 2
LineCounter ds 1
PlayerTemp ds 1
BrickTemp ds 1
StackTemp ds 1
Temp ds 3

MiscPtr ds 12

   ; Display Remaining RAM
   echo "----",($100 - *) , "bytes left (ZP RAM)"

;-------------------------End Variables-----------------------------------
	
	SEG Bank0
	org $F000

Start
	CLEAN_START

;--any initial setup

	jsr InitialSetupSubroutine

;-------------------------------------------------------------------------
;--------------GAME MAIN LOOP---------------------------------------------
;-------------------------------------------------------------------------

;MainGameLoop
;
;	jsr VBLANKRoutine
;	jsr KernelRoutine
;	jsr OverscanRoutine
;	jmp MainGameLoop

;-------------------------------------------------------------------------
;-------------------VBLANK Routine----------------------------------------
;-------------------------------------------------------------------------

VBLANKRoutine
	lda #%00001111
VSYNCLoop
	sta WSYNC
	sta VSYNC
	lsr
	bcs VSYNCLoop

	lda #43
	sta TIM64T


	lda FlashScreenTimer
	bne EverythingOnHoldVblank

	jsr ProcessEnemiesSubroutine	
	jsr MoveBrickSubroutine			;combine these two subs?

EverythingOnHoldVblank

	jsr KernelPrepSubroutine		;combine this sub with UpdateCounterSubroutine above? Done.




WaitForVblankEnd
	lda INTIM
	bne WaitForVblankEnd

	sta WSYNC
	sta VBLANK	;turn off VBLANK - it was turned on by overscan


;-------------------------------------------------------------------------
;----------------------Kernel Routine-------------------------------------
;-------------------------------------------------------------------------


KernelRoutine			;		 3

	lda #$C0
	sta PF0				;+5		 8
	lda #$FF
	sta PF1
	sta PF2				;+8		16
	lda #GRADIENTCOLOR
	sta COLUPF			;+7		23

	ldx #2
KernelAboveScoreLoop
	sta WSYNC
	lda ColorGradientTable+11,X
	sta.w COLUPF
	dex
	bne KernelAboveScoreLoop	;+12	12

;******************

    ;--waste time efficiently:
   ldy #11       ; 2				14
.wait
   dey          ; 2
   bne .wait    ; 3			5*10 + 4 = 54	
							;+54	68	


   ldy #6+1					;+2		70
ScoreKernelLoop             ;       69      this loop can't cross a page boundary!
                            ;            (or - if it does, adjust the timing!)
	lda ColorGradientTable+4,Y
	sta.w COLUPF

   dey                      ;+2       3
   sty Temp+1               ;+3       6
   lda (MiscPtr),Y
   sta GRP0                 ;+8      14
   lda (MiscPtr+2),Y
   sta GRP1                 ;+8      22
   lda (MiscPtr+4),Y
   sta GRP0                 ;+8      30
   lax (MiscPtr+6),Y        ;+5      35
   lda (MiscPtr+8),Y
   sta Temp                 ;+8      43
   lda (MiscPtr+10),Y
   ldy Temp                 ;+8      51
   stx GRP1                 ;+3      54
   sty GRP0
   sta GRP1
   sta GRP0                 ;+9      63		
   ldy Temp+1               ;+3      66
   bne ScoreKernelLoop      ;+3      69
                            ;        68
   sty GRP0
   sty GRP1
   sty GRP0                 ;+9       1

;**************

	sta WSYNC

	lda #GRADIENTCOLOR+6
	sta COLUPF

	lda FrameCounter		;				skip this when screen is flashing?
	sta REFP0

	lda PlayerX 
	ldx #1
	jsr PositionASpriteSubroutine
	lda #GRADIENTCOLOR+10
	sta COLUPF
	tsx
	stx StackTemp
	lda ScrollCounter
	lsr
	tax
	tay							;save ScrollCounter/2 in Y
	lda InitialLineTable,X
	tax
	txs							;careful with the stack now...
	tya
	tax							;restore ScrollCounter/2 to X
	lda PlayerFlags
	sta REFP1
	lda #OCTWIDTHMISSILE
	sta NUSIZ1
	lda #0
	sta NUSIZ0
	sta VDELP1	
	sta WSYNC
	sta HMCLR
	sta CXCLR
	sta GRP0
	sta GRP1					;+12	12	put this in a loop to save ROM?  Is there time?





	ldy PFColorPresetIndexTable,X
	lda GirderColor1,Y
	and ColorMask
	tay
	lda InitialXTable,X
	tax					;+6		12
	lda #BRICKHEIGHT
	dcp BrickTemp
	sbc #BRICKHEIGHT-2
	

	sta WSYNC
	sta ENAM1			;		 3
	lda #0
	sta.w PF0			;		 9
	sty COLUPF			;+3		12
	ldy #PLAYAREAHEIGHT	;+2		14
	jmp (KernelPtr)		;+5		19

;-------------------------------------------------------------------------

PositionASpriteSubroutine
	sta HMCLR
	sec
	sta WSYNC
DivideLoop
	sbc #15
	bcs DivideLoop			;+4		 4
	eor #7
	asl
	asl
	asl
	asl						;+10	14
	sta.wx HMP0,X			;+5		19
	sta RESP0,X				;+4		23
	sta WSYNC
	sta HMOVE
	rts						;+9		 9


;-------------------------------------------------------------------------


	;---14 free bytes

	align 256

DrawBlank1					;		75
	dec $2D
	nop						;+7		11		waste time efficiently
	lda #0
	sta GRP1				;+5		 4
	beq BackFromDrawBlank1	;+3		14


MainKernelLoopInner			;		15
	lda PF1Temp
	sta PF1
	lda PF2Temp
	sta PF2					;+12	27

	lda (EnemyPtr,X)
	sta GRP0				;+9		35		VDEL

	lda PF4Temp
	sta PF1
	lda PF3Temp
	sta PF2					;+12	48

	dec EnemyPtr,X			;+6		54

	lda #BRICKHEIGHT
	dcp BrickTemp
	sbc #BRICKHEIGHT-2
	sta ENAM1				;+12	66		VDEL



	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank1			;+9		75
	lda (PlayerGfxPtr1),Y
	sta GRP1				;+8		 7
	lda (PlayerClrPtr1),Y
	sta COLUP1				;+8		15	
BackFromDrawBlank1

	lda PF1Temp
	sta PF1
	lda PF2Temp
	sta PF2					;+12	27

	lax (EnemyPtr,X)
	cmp #ENDMONSTERVALUE
	beq MainKernelLoopOuter	;+10	37
MainKernelLoopOuter7Entrance
	lda PF4Temp
	sta PF1
	lda PF3Temp
	sta PF2					;+12	49		one cycle late!  *might* be OK...It's fine.

	stx GRP0				;				VDEL
	tsx						;+5		54

	dec EnemyPtr,X			;+6		60
MainKernelInner1Entrance
	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank2			;+9		69
	lda (PlayerGfxPtr2),Y
	sta.w GRP1				;+9		 2
BackFromDrawBlank2
	lda (PlayerClrPtr2),Y
	sta COLUP1				;+8		10



	dey
	bpl MainKernelLoopInner	;+5		15

EndKernel
	jmp BottomKernel


DrawBlank2					;		70
	lda #0					;+2		72
	sta GRP1				;+3		75
	beq BackFromDrawBlank2	;+3		 2

DrawBlank3					;		60
	dec $2D
	nop						;+4		64
	lda #0
	sta GRP1
	beq BackFromDrawBlank3	;+3		67

DrawBlank4					;		14
	nop
	nop
	bcc BackFromDrawBlank4	;+7		21


MainKernelLoopOuter			;		38
	lda PF4Temp
	sta PF1
	lda PF3Temp
	sta PF2					;+12	50		this is surely too late...hmmmm	.  Seems to be fine.

	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank3			;+9		59
	lda (PlayerGfxPtr2),Y
	sta GRP1				;+8		67
	lda (PlayerClrPtr2),Y
	sta COLUP1				;+8		75
BackFromDrawBlank3

	dey
	bmi EndKernel			;+4		 3

	tsx
	dex
	dex
	txs						;+8		11

	lda GirderColor1
	and ColorMask
	sta COLUPF				;+9		20

	lda #STATICGIRDER_PF1
	sta PF1
	lda #STATICGIRDER_PF2
	sta PF2					;+10	30		too late?

	txa
	lsr
	tax						;6		36

	lda EnemyColor,X
	and ColorMask
	sta COLUP0				;+10	46

	lda GirderPattern,X
	txs
	tax						;+8		54

	lda #BRICKHEIGHT
	dcp BrickTemp
	sbc #BRICKHEIGHT-2
	sta ENAM1				;+12	66		VDEL

	lda PF1GirderLookup,X
	sta PF1Temp
	lda PF2GirderLookup,X
	sta PF2Temp				;+14	 4

	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank4			;+9		13
	lda (PlayerGfxPtr1),Y
	sta GRP1				;+8		21
BackFromDrawBlank4
	lda (PlayerClrPtr1),Y
	sta COLUP1				;+8		29		this should be early enough...or?


	lda PF3GirderLookup,X
	sta PF3Temp
	lda PF4GirderLookup,X
	sta PF4Temp				;+14	43

	tsx						;+2		45
MainKernelLoopOuter2Entrance
	txa
	asl
	tax
	txs
	lsr
	tax						;+12	57

	jmp ContinueKernel2

;----------------------------------------------------------------------------

GetDigitDataLo
   and #$0F
   tay
   lda DigitDataLo,Y
   rts

;----------------------------------------------------------------------------


KernelSubEntrance1		;		19		13 bytes
	lda PF1Temp
	sta PF1
	lda PF2Temp
	sta PF2				;+12	31
	nop
	nop
	jmp MainKernelLoopOuter				;		38

;----------------------------------------------------------------------------

	;--about 0 free bytes here

	align 256

DrawBlank5					;		65
	dec $2D
	nop
	lda #0
	sta GRP1
	beq BackFromDrawBlank5	;+3		 4

EndKernel4
	jmp BottomKernel

DrawBlank6					;		55
	lda #BRICKHEIGHT
	dcp BrickTemp
	sbc #BRICKHEIGHT-2
	sta ENAM1				;+12	67		VDEL
	nop
	nop
	jmp BackFromDrawBlank6	;+3		 6

DrawBlank7
	dec $2D
	nop
	lda #0
	sta GRP1
	bcc BackFromDrawBlank7	;+3		 7



ContinueKernel2				;		60
	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank5			;+9		69
	lda (PlayerGfxPtr2),Y
	sta GRP1
	lda (PlayerClrPtr2),Y
	sta COLUP1				;+16	 9
BackFromDrawBlank5

	dey
	bmi EndKernel4			;+4		13

	lda #$FF
	sta PF1
	sta PF2					;+8		21



	lda CXPPMM				;+3
	asl						;+2
	ror EnemyCollisions		;+5
	lda CXM1P				;+3
	and #%01000000			;+2
	ora BrickCollision		;+3
	sta BrickCollision		;+3
	sta CXCLR				;+24	45



	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank6			;+9		54
	lda #BRICKHEIGHT
	dcp BrickTemp
	sbc #BRICKHEIGHT-2
	sta ENAM1				;+12	66		VDEL
	lda (PlayerGfxPtr1),Y
	sta GRP1
BackFromDrawBlank6
	lda (PlayerClrPtr1),Y
	sta COLUP1				;+16	 6


	sec
	lda EnemyPosition,X		;+6		12

DivideLoopKernel
	sbc #15
	bcs DivideLoopKernel	;+4		16

	tax
	lda #PLAYERHEIGHT-1		;+4		20

	sta RESP0				;+3		23
MainKernelLoopOuter3Entrance		
	sta WSYNC				;+3		26

	dey
	bmi EndKernel2			;+4		 4
	iny

	dcp PlayerTemp
	bcc DrawBlank7			;+7		13
	lda (PlayerGfxPtr2),Y
	sta GRP1

	lda (PlayerClrPtr2),Y
	sta COLUP1				;+16	29		;not too late?
BackFromDrawBlank7

	dey						;+2		31

	txa
	eor #7
	asl
	asl
	asl
	asl
	sta HMP0				;+15	46
	tsx						;+2		48

	dec $2D					;+5		53

	lda #BRICKHEIGHT
	dcp BrickTemp
	sbc #BRICKHEIGHT-2
	sta ENAM1				;+12	65		VDEL


	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank8			;+9		74
	sta HMOVE				;+3		 1
	lda (PlayerGfxPtr1),Y	;+5		 6
	sta GRP1				;+3		 9		 
BackFromDrawBlank8
	lda (PlayerClrPtr1),Y
	sta COLUP1				;+8 	17



	lda #7
	sec						;+4		21
DelayLoop1
MainKernelLoopOuter4Entrance	;	41
	sbc #1
	bne DelayLoop1			;+34	55

	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank9			;+9		64
	lda (PlayerGfxPtr2),Y
	sta GRP1
	lda (PlayerClrPtr2),Y
	sta COLUP1				;+16	 4
BackFromDrawBlank9

	dey
	bmi EndKernel3			;+4		 8

	lda #STATICGIRDER_PF1
	sta PF1
	lda #STATICGIRDER_PF2
	sta PF2					;+10	18





	jmp ContinueKernel1		;+3		21

EndKernel2
	jmp BottomKernel

DrawBlank8					;		75
	sta HMOVE				;+3		 2
	nop
	nop
	bcc BackFromDrawBlank8	;+3		12

DrawBlank9
	dec $2D
	nop
	lda #0
	sta GRP1
	beq BackFromDrawBlank9	;+3		 7



Monster12
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%01111110;--
        .byte #%11111111;--
        .byte #%01010101;--
        .byte #%01111110;--
        .byte #%00101100;--
        .byte #%00011000;--
        .byte #%00001000;--
        .byte #%00000100;--
        .byte #%00000000;--
;		.byte 0

	;000000,001001,010010,011011,100100,101101,110110,111111

PF2GirderLookup		;00300020
	.byte %00000000,%00100000,%00000010,%00100010,%00000000,%00100000,%00000010,%00100010

	;000000,001001,010010,011011,100100,101101,110110,111111
PF4GirderLookup		;11000600
	.byte %11000000,%11000100,%11000000,%11000100,%11000000,%11000100,%11000000,%11000100

	;--about 0 free bytes here


	align 256

DrawBlank10
	nop
	nop
	bcc BackFromDrawBlank10	;+3		 7

EndKernel3
	jmp BottomKernel

ContinueKernel1				;		21
	lda #6
	sta LineCounter			;+5	 	26

	lda #5
	sec						;+4		30
DelayLoop2
	sbc #1
	bne DelayLoop2			;+24	54

	lda #BRICKHEIGHT
	dcp BrickTemp
	sbc #BRICKHEIGHT-2
	sta ENAM1				;+12	66		VDEL

	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank10			;+9		75
	lda (PlayerGfxPtr1),Y
	sta GRP1
BackFromDrawBlank10
	lda (PlayerClrPtr1),Y
	sta COLUP1				;+16	15




	lda #7
	sec						;+4		19
DelayLoop3
MainKernelLoopOuter5Entrance	;	39		
	sbc #1
	bne DelayLoop3			;+34	53



	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank11			;+9		62
	lda (PlayerGfxPtr2),Y
	sta GRP1				;+8		70

	lda (PlayerClrPtr2),Y
	sta COLUP1				;+8		 2
BackFromDrawBlank11

	dey
	bmi EndKernel3			;+4		 6

	lda GirderColor2
	and ColorMask
	sta COLUPF				;+9		15

MainKernelLoopInner2
	lda PF1Temp
	sta PF1
	lda PF2Temp
	sta PF2					;+12	27

	dec $2D
	nop
	nop						;+9		36		waste time efficiently

	lda PF4Temp
	sta PF1
	lda PF3Temp
	sta PF2					;+12	48

	dec $2D					;+5		53		waste time efficiently

	lda #BRICKHEIGHT
	dcp BrickTemp
	sbc #BRICKHEIGHT-2
	sta ENAM1				;+12	65		

	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank1b			;+9		74
	lda (PlayerGfxPtr1),Y
	sta.w GRP1				;+9		 7
BackFromDrawBlank1b
	lda (PlayerClrPtr1),Y
	sta COLUP1				;+8		15	


	lda PF1Temp
	sta PF1
	lda PF2Temp
	sta PF2					;+12	27

	rol $80
	ror $80					;+10	37

MainKernelLoopOuter6Entrance

	lda PF4Temp
	sta PF1
	lda PF3Temp
	sta PF2					;+12	49		one cycle late!  *might* be OK...



	dec.w LineCounter				;+6		55
	bne DontExitMainKernelInner2Yet	;+2		57
	jmp MainKernelInner1Entrance	;+3		60
DontExitMainKernelInner2Yet			;+3		58

	nop						;		60

	lda #PLAYERHEIGHT-1
	dcp PlayerTemp
	bcc DrawBlank2b			;+9		69
	lda (PlayerGfxPtr2),Y
	sta.w GRP1				;+9		 2
BackFromDrawBlank2b
	lda (PlayerClrPtr2),Y
	sta COLUP1				;+8		10


	dey
	bpl MainKernelLoopInner2	;+5		15
	jmp BottomKernel



DrawBlank11
	dec $2D
	nop
	lda #0
	sta GRP1
	beq BackFromDrawBlank11	;+3		 7


DrawBlank1b					;		75
	lda #0
	sta GRP1				;+5		 4

	beq BackFromDrawBlank1b	;+3		 7


DrawBlank2b					;		70
	lda #0					;+2		72
	sta GRP1				;+3		75
	beq BackFromDrawBlank2b	;+3		 2

BottomKernel
	lda #GRADIENTCOLOR
	sta COLUPF
	lda #$C0
	sta PF0
	sty PF1			;Y == $FF
	sty PF2
	iny
	sty ENAM1

	ldx StackTemp
	txs

	sta WSYNC
	sty GRP0
	sty GRP1
	sty VDELP0			;+14	14
	sty REFP0
	sty REFP1			;+6		20
	lda ScoreColor
	sta COLUP0			;+5		25
	sta COLUP1			;+3		31
	nop					;+2		25
	sta RESP0			;+3		28

	ldy ExtraLives		;+3		31

	lda #RIGHTTHREE
	sta HMP0			;+5		36
	cpy #7				;+2		38
	nop
	nop					;+4		42
	sta RESP1			;+3		45
	
	bcc NoAdjustToExtraLives	;+2/3	38
	ldy #6				;+2		40
NoAdjustToExtraLives	;		39/40

	lda ExtraLivesNUSIZ0Table,Y
	sta NUSIZ0			;+3		48
	lda ExtraLivesNUSIZ1Table,Y
	sta NUSIZ1			;+7		55



	sta WSYNC
	sta HMOVE
	
	lda #GRADIENTCOLOR+10
	sta COLUPF

	ldx #13
BottomKernelLoop
	sta WSYNC
	lda ColorGradientTable,X
	sta COLUPF

	lda ExtraLifeGfxTable,X
	and ExtraLivesP0MaskTable,Y
	sta GRP0
	lda ExtraLifeGfxTable,X
	and ExtraLivesP1MaskTable,Y
	sta GRP1
	dex
	bpl BottomKernelLoop


;-------------------------------------------------------------------------
;------------------------Overscan Routine---------------------------------
;-------------------------------------------------------------------------


OverscanRoutine




	lda #2
	sta WSYNC
	sta VBLANK	;turn on VBLANK
	lda  #34
	sta  TIM64T






	lda FlashScreenTimer
	bne StopEverything
	lda GameOnFlag
	beq GameNotOnSkipCollisionsAndJoystick
	jsr CollisionsSubroutine


GameNotOnSkipCollisionsAndJoystick
	jsr ReadJoystickSubroutine

	jsr MoveAnimatePlayerSubroutine

	jsr GeneratePlayfieldSubroutine

	jsr ConsoleSwitchesSubroutine
StopEverything

		lda #0			;2479 A9 00		
		sta AUDF0		;247B 8D 00 D2		AUDF0 = 0
		sta AUDV0		;247E 8D 01 D2		AUDC0 = 0
		sta AUDV1		;2481 8D 03 D2		AUDC1 = 0



	jsr PlayMusicSubroutine

	jsr PlaySFXSubroutine



WaitForOverscanEnd
	lda INTIM
	bne WaitForOverscanEnd

	jmp VBLANKRoutine

;-------------------------------------------------------------------------
;----------------------------End Main Routines----------------------------
;-------------------------------------------------------------------------


;*************************************************************************

;-------------------------------------------------------------------------
;----------------------Begin Subroutines----------------------------------
;-------------------------------------------------------------------------




;-------------------------------------------------------------------------

PlaySFXSubroutine
	;--moving left/right/up/down sounds, legs up sound, squish sound (?)
	;	and dying sound

	lda PlayerFlags
	and #DYING_BIT
	beq DontPlayDyingSFX
	lda DyingSoundFlag
	bne PlayDyingSFX
	lda #0
	sta AUDV0
	rts
PlayDyingSFX
	;--play dying sound effect
		lda SFXIndex0		;2793 A5 88
		lsr 				;2795 0A
		sta AUDF0			;2796 8D 00 D2	
		lda #SQUARESOUND	;2799 A9 ED
		sta AUDC0			;279B 8D 01 D2
	lda #13
	sta AUDV0
	bne EndSFXRoutine		;branch always
DontPlayDyingSFX
	;--legs up?
	lda LegsUpCounter
	beq DontPlayLegsUpSound
	sta AUDF0
	lda #SQUARESOUND
	sta AUDC0
	lda #12
	sta AUDV0
	bne EndSFXRoutine
DontPlayLegsUpSound
	;--player moving sideways?
	lda PlayerMove
	jsr Lsr3Tay
	lda PlayerMove
	beq DontPlaySidewaysSound
	and #7
	cmp #7
	bne EndSFXRoutine
	lda #15	
	sta AUDV0
	lda MoveSidewaysFreqTable,Y
	sta AUDF0
	lda #SQUARESOUND
	sta AUDC0

	bne EndSFXRoutine
DontPlaySidewaysSound
	;--play climbing sound
	lda ScrollCounter
	beq EndSFXRoutine
	cmp #24
	bne ScrollCounterNot24
PlayHighClimbingSound
	lda #8
	sta AUDF0
SetClimbSoundVolume
	lda #15
	sta AUDV0
	lda #SQUARESOUND
	sta AUDC0
	bne EndSFXRoutine		;branch always
ScrollCounterNot24
	cmp #8
	beq PlayHighClimbingSound
	cmp #16
	bne ScrollCounterNot16
PlayLowClimbingSound
	lda #12
	sta AUDF0
	bne SetClimbSoundVolume
ScrollCounterNot16
	cmp #1
	beq PlayLowClimbingSound
EndSFXRoutine
	rts

;-------------------------------------------------------------------------

PlayMusicSubroutine

	;--priority for channel 1:
	;	1st, flash screen
	;	2nd, crunch sound effects (squish, pop-up, brick hitting player)
	;	3rd, music
	;	4th, brick falling
	;	5th, background wah-wah


	lda FlashScreenTimer
	beq NoFlashScreenEffect
	dec FlashScreenTimer
	lda ColorMask
	lsr
	sta AUDF1
		inc ColorMask		;24A2 E6 8A
		inc ColorMask		;24A4 E6 8A	
	lda #PITFALLSOUND
	bne SetAUDC1Volume10
NoFlashScreenEffect


	;--stole this routine also

		ldy SFXIndex1		;24D8 A4 F3
		beq PlayMusic		;24DA F0 14			
		dec SFXIndex1		;24DC C6 F3
		lda SoundEffectFrequencyTable,Y			;24DE B9 15 2B
		bne PlaySFX			;24E1 D0 04
		sta SFXIndex1		;24E3 85 F3			;if frequency == 0, set SFXCounter to zero and play music
		beq PlayMusic		;24E5 F0 09			branch always
PlaySFX
		sta AUDF1			;24E7 8D 02 D2		store into AUDF1
		lda #ENGINESOUND
		sta AUDC1
		lda #9				;24EA A9 49			
		bne SetAUDV1		;24EE D0 39			branch always
PlayMusic
	;--shamefully stole this routine from A800 Squish 'Em code
	;--music works this way:
	;	MusicIndex is decremented every frame
	;	upper 5 bits are used to index into frequency table, so frequency changes every 8 frames
	;	lower 4 bits are put into volume, so each note starts at full/half volume ($F or $7) and
	;		thereafter volume decreases every frame until the next note.
	;	Same sequence of notes used for beginning of game, new level, grabbing suitcase (new building), 
	;		and beginning a new life after dying.  Each one is just a different portion of the music:
	;		Grab suitcase: 		21 notes (entire thing)
	;		New game: 			last 14 notes
	;		Resume after dying:	last 7 notes
	;		New level			last 4 notes
	;		
		lda MusicIndex		;24F0 A5 99			sound index 
		beq SkipMusicRoutine		;24F2 F0 20
		dec MusicIndex		;24F4 C6 99
		tax				;24F6 AA			put index (unchanged) into X
		jsr Lsr3Tay
		lda MusicFrequencyTable,Y	;24FB B9 3D 2B		index into table of AUDFx values
		sta AUDF1			;24FE 8D 02 D2		store into AUDF1
		beq SkipScoreColorChange	;2501 F0 07		don't change score color if freq value == 0
		lda SFXIndex0		;2503 A5 88
		asl 				;2505 0A
		adc ScoreColor		;2506 65 90
		sta ScoreColor		;2508 85 90
SkipScoreColorChange
		txa					;250A 8A		
		and #$0F			;250B 29 0F			MusicIndex into volume
		sta AUDV1
		lda #SQUARESOUND		;250D 09 A0			
		sta AUDC1			;250F 8D 03 D2		put into AUDC1
		bne EndMusicRoutine	;2512 D0 18		branch always 
SkipMusicRoutine
	;--if brick falling or if grabbing bonus item or if game over or if game-ending
	;	then play the appropriate sound effect for those events.
	;	Otherwise - play background music sound
	;	Unless game not on!

	lda #GRAY+14
	sta ScoreColor
	ldx #$FF
	stx ColorMask

	lda BrickY
	bmi NoBrickSound
	lda BrickFallingSound
	beq NoBrickSound
	cmp #$80
	bcc BrickFallingStillSquareSound
	and #$7F
	clc
	adc #40
	lsr
	lsr
	sta AUDF1
	lda #LEADSOUND
	bne SetAUDC1Volume10
BrickFallingStillSquareSound
	lsr
	lsr
	sta AUDF1
	lda #SQUARESOUND
SetAUDC1Volume10
	sta AUDC1
	lda #10
	bne SetAUDV1
NoBrickSound
	lda SFXIndex0
	and #$1F
	tay
	lda BackgroundSoundFreqTable,Y
	sta AUDF1
	lda GameOnFlag
	beq SetAUDV1	
	lda #SQUARESOUND
	sta AUDC1
	lda #3
SetAUDV1
	sta AUDV1


EndMusicRoutine
	rts



;-------------------------------------------------------------------------

InitialSetupSubroutine

	lda #RANDOMSEED
	sta RandomNumber

	lda #REFLECTEDPF|OCTWIDTHBALL
	sta CTRLPF
	lda #GRAY+15
	sta ScoreColor

	ldx #$FF
	stx VDELP0

	ldy #INITIALLEVEL
	sty StartLevel

	jmp ContinueInitialSetup

;-------------------------------------------------------------------------

NewGameSetupSubroutine


	lda #BEGINGAMEMUSICLENGTH
	sta MusicIndex

ContinueInitialSetup
	lda #INITIALGIRDERCOLOR1
	sta GirderColor1
	lda #INITIALGIRDERCOLOR2
	sta GirderColor2

StopGameSetup
	ldy StartLevel
	dey
	sty Level

	lda #INITIALLIVES
	sta ExtraLives



	ldx #$FF
	stx ColorMask
	inx
	stx Floor
	stx PlayerFrameOffset
	stx ClearedEnemy
	stx PlayerMove
	inx
	stx MoveEnemiesDelay

InitialLevelSetupSubroutine

	lda #INITIALPLAYERY
	sta PlayerY
	lda #INITIALPLAYERX
	sta PlayerX

	lda #PLAYERLEFT
	sta PlayerFlags

	ldx #MAXVISIBLELEVELS-1
SetupInitialEnemyVariablesLoop
	lda #%00000111				;fill visible girders completely
	sta GirderPattern,X
	lda #0
	sta EnemyType,X
	sta EnemyMovement,X 
	lda #80
	sta EnemyPosition,X			;needed so positioning routine isn't wonky
	dex
	bpl SetupInitialEnemyVariablesLoop

	lda #$FB
	sta BrickY

	inx					;X == 0
	stx ScrollCounter
	stx PlayerMove
	stx BrickTimer


	lda Floor
	cmp #$30
	bcc NoFloorAdjustment
	lda #$2F
	sta Floor
	dec Level
NoFloorAdjustment


	ldx #MAXVISIBLELEVELS-1
	jsr CreateNewEnemySubroutine	;needs X set


Return
	rts




;-------------------------------------------------------------------------

CollisionsSubroutine
	;--first, don't care about collisions if player is dying already
	lda PlayerFlags
	and #DYING_BIT
	beq NotDyingCollideAway
	jmp NoCollisionsWhileDying
NotDyingCollideAway
	;--first, player to player collisions
	lda EnemyCollisions
	and #%11000000
	beq NoPlayerToPlayerCollisions	;collide with other player?
	;--which enemy are we colliding with?
	asl
	bcc CollidedWithHeadOnly
	;--else, collided with leg.
	;--if enemy is white, no smash!
	lda EnemyColor+1
	cmp #GRAY+14
	beq PlayerDead
	;--is item a bonus item or suitcase?
	lda EnemyType+1
	;--enemy types: 0 is blank enemy, 1-15 are monsters, 16-20 are bonus items
	;	21 is suitcase
	cmp #16
	bcc PlayerHitAMonster
	ldx #1
	;--else bonus item or suitcase
HitBonusItemOrSuitcase
	cmp #SUITCASE
	beq PlayerGotSuitcase
	;--else bonus item - remove it, flash the screen, play sound effect, and increase extra lives
	lda #$1F
	sta FlashScreenTimer

	inc ExtraLives			;increase extra lives
	bpl NotTooManyExtraLives
	dec ExtraLives
NotTooManyExtraLives
	lda #BLANKENEMY
	sta EnemyType,X			;remove from screen
	beq DoneWithPlayerToPlayerCollisions		;branch always
PlayerGotSuitcase
	;--add point bonus, start new level IMMEDIATELY, start music
	lda #SUITCASEMUSICLENGTH
	sta MusicIndex

	lda #0
	sta Temp+2
	lda #$10
	sta Temp+1
	jsr IncreaseScoreSubroutine


	lda #0
	sta Floor
	jsr InitialLevelSetupSubroutine
	jmp DoneWithPlayerToPlayerCollisions
CollidedWithHeadOnly
	;--for head collision, just look at safe item vs. enemy.  Can't smash with your head
	;	the enemy can't be white yet.
	lda EnemyType+2
	cmp #16
	bcc PlayerDead
	;--else, hit a suitcase or bonus item
	ldx #2
	bne HitBonusItemOrSuitcase		;branch always

PlayerHitAMonster
	;--were we smashing?
	lda PlayerFlags
	and #SMASH_BIT
	beq PlayerDead
	;--else, squish the enemy!

	lda #$17
	sta SFXIndex1

	lda #0
	sta Temp+2
	lda #$01
	sta Temp+1
	jsr IncreaseScoreSubroutine

	ldy Level
	lda SquishedTimeTable,Y
	adc #$18
	ora #ENEMYSQUISHED_BIT
	sta EnemyMovement+1
	bne DoneWithPlayerToPlayerCollisions		;branch always
DoneWithPlayerToPlayerCollisions
NoPlayerToPlayerCollisions
	;--now, player to brick (ball)
	bit BrickCollision		;overflow flag set on P1-to-BL collision (bit 6)
	bvc NoCollisionWithBrick
	;--else, collision with brick.  Player dies, brick moves over
	lda #$27
	sta SFXIndex1
	lda #0
	sta BrickFallingSound	;turn off falling sound
	;--brick moves left 10 pixels when it whacks the player.
	lda #10
	sta BrickMovement		;brick moves 10 pixels over
PlayerDead
	lda PlayerFlags
	ora #DYING_BIT
	sta PlayerFlags
	sta DyingSoundFlag
	lda #0
	sta TriggerDebounce

	lda #4
	sta SFXIndex0

NoCollisionWithBrick
NoCollisionsWhileDying
	lda #0
	sta BrickCollision
	sta EnemyCollisions
	rts

;-------------------------------------------------------------------------

MoveAnimatePlayerSubroutine
	;--first check if we're dying
	lda PlayerFlags
	and #DYING_BIT
	beq NotDyingRegularMovement
	;--dying routine:
	;	move downward, offscreen, using CLIMBING2 frame (flipping (REFPing) back and forth)
	lda FrameCounter
	lsr
	bcc MoveDyingPlayerDown
	jmp NoChangePlayerMove
MoveDyingPlayerDown
	lda #CLIMBINGFRAME
	sta PlayerFrame
	lda FrameCounter
	and #PLAYERDIR_BIT
	sta Temp
	lda PlayerFlags
	and #~PLAYERDIR_BIT
	ora Temp
	sta PlayerFlags
	dec PlayerY
	dec PlayerY			;can only move player in 2-line increments!
	bmi SpecialCaseDyingFrames
	jmp NoChangePlayerMove		;too far for branch
SpecialCaseDyingFrames
	lda #0
	sta PlayerY
	inc PlayerFrameOffset
	lda PlayerFrameOffset
	cmp #14
	bne PlayerNotDoneFalling
	;--else, player offscreen - now turn SFX off, wait for 128 frames, and
	;	 then take life away and restart (or game over)
	lda #0
	sta DyingSoundFlag
	dec PlayerFrameOffset		;reset this value
	dec PlayerDeathTimer
	bpl NotFirstFrameOffscreen
	;--player just went offscreen
	lda #$40				;we get here every other frame
	sta PlayerDeathTimer
PlayerStillWaitingOffscreen
	jmp NoChangePlayerMove
NotFirstFrameOffscreen
	bne PlayerStillWaitingOffscreen
	;--else died and restart
	lda #0	
	sta PlayerFrameOffset
	lda PlayerFlags
	and #~DYING_BIT
	sta PlayerFlags
	IF INFINITELIVES
	nop
	jmp NotGameOver
	ELSE
	dec ExtraLives
	bpl NotGameOver
	ENDIF
	;--game over!
	inc ExtraLives		;get back to zero
	lda #$7F
	sta FlashScreenTimer
	lda #HANGINGFRAME		;==0
	sta PlayerFrame
;	lda #0
	sta GameOnFlag
	.byte $2C
NotGameOver
	lda #DIEDRESTARTMUSICLENGTH
	sta MusicIndex
	jsr InitialLevelSetupSubroutine
PlayerNotDoneFalling
	jmp NoChangePlayerMove		;too far for branch

NotDyingRegularMovement
	;--then check if we are climbing
	lda ScrollCounter
	bne ClimbingMovement
	;--finally, check if we are moving left or right
	lda PlayerMove
	beq PlayerNotMoving		;--if none of those things, we ain't moving at all
	lda PlayerFlags
	asl
	asl
	asl
	asl							;get MOVEPLAYER16_BIT into carry
	lda PlayerMove
	rol							;essentially, add MOVEPLAYER16_BIT to PlayerMove*2
	tax
	dex
	dex							;adjust value
	lda PlayerFlags			
	and #PLAYERDIR_BIT			;which direction to move
	bne MovePlayerRight
	;--else move player left
	lda PlayerX
	sec
	sbc PlayerMoveLRTable,X
	sta PlayerX
	bne PlayerXChanged			;branch always
MovePlayerRight
	lda PlayerX
	clc
	adc PlayerMoveLRTable,X
	sta PlayerX
;	bne PlayerXChanged
PlayerNotMoving
DoneMovingPlayer
PlayerXChanged

	;--animate player.  
	;--first, if legs-up counter is > zero than legs up frame.
	lda LegsUpCounter
	beq LegsNotUp
	dec LegsUpCounter
	beq ChangeFromLegsUpFrame
	;--check here for PlayerX = EnemyX ??
	lda PlayerX
	cmp EnemyPosition+1
	bne DoneChangingFrame
	lda #$02
	sta ClearedEnemy
	bne DoneChangingFrame		;branch always

ChangeFromLegsUpFrame
	;--make player face to left if not moving
	;--add points if jumped over enemy
	lda #0
	sta Temp
	sta Temp+2
	lda ClearedEnemy
	sta Temp+1
	jsr IncreaseScoreSubroutine
	lda #0
	sta ClearedEnemy
	lda PlayerMove
	bne PlayerMovingWhenSmashing
	lda PlayerFlags
	and #~PLAYERDIR_BIT
	ora #PLAYERLEFT
	sta PlayerFlags
PlayerMovingWhenSmashing
	;--set smash state
	lda PlayerFlags
	ora #SMASH_BIT
	sta PlayerFlags
	bne ChangeToSmashFrame		;branch always


LegsNotUp
ChangeFrameIfNecessary
	lda PlayerFlags
	and #~SMASH_BIT
	sta PlayerFlags

ChangeToSmashFrame
ClimbingMovement
	;--if player not moving L or R (or U or D), hanging frame
	lda ScrollCounter
	beq NotClimbing
	;--climbing, so...
	clc
	adc #6
	jsr Lsr5Tay			;subroutine puts it into Y but we don't care
	bcs ClimbingRightSide
	lda PlayerFlags
	and #~PLAYERDIR_BIT
	sta PlayerFlags
	jmp SetClimbingFrame

ClimbingRightSide
	lda PlayerFlags
	ora #PLAYERDIR_BIT
	sta PlayerFlags
SetClimbingFrame
	lda ScrollCounter
 	sec
	sbc #2
	lsr
	lsr
	lsr
	eor #1
	and #1
;	lsr
;	adc #HANGINGFRAME			;==0
	sta PlayerFrame
	jmp DoneChangingFrame
NotClimbing
	lda PlayerMove
	bne MovingFrame
HangingFrame
;	lda #HANGINGFRAME		;==0
	sta PlayerFrame
	jmp DoneChangingFrame
MovingFrame
	ldx PlayerMove
	dex							;adjust value	
	txa	
	beq HangingFrame
	jsr Lsr4Tay					;puts value into Y but we don't care
	lda #0
	adc #SHIMMY1FRAME
	sta PlayerFrame


DoneChangingFrame
	lda PlayerMove
	beq NoChangePlayerMove
	dec PlayerMove
NoChangePlayerMove
	rts

;-------------------------------------------------------------------------

GeneratePlayfieldSubroutine
	;--first, if player dying, don't scroll
	lda PlayerFlags
	and #DYING_BIT
	beq PlayerNotDyingScrollNormally
	jmp NoChangeToScrollCounter
PlayerNotDyingScrollNormally
	lda ScrollCounter
	bne ChangeToScrollCounter
	jmp NoChangeToScrollCounter
ChangeToScrollCounter
	dec ScrollCounter
	lda ScrollCounter
	cmp #1
	beq DoneScrollingNow
;	lda ScrollCounter
;	and #1
;	bne NotDoneScrollingYet
	jmp NoChangeToScrollCounterThisFrame
DoneScrollingNow
	;--scrolled one floor, so increase score by 10.  Also increase floor by 1
	lda #$10
	sta Temp+2
	lda #0
	sta Temp+1
	jsr IncreaseScoreSubroutine
	inc Floor
	lda Floor
	and #$0F
	bne NotNewLevel
	lda Level
	cmp #15
	beq NotNewLevel
	inc Level
NotNewLevel
	lda Floor
	cmp #$30
	beq NotNewLevelSound
	and #$0F
	bne NotNewLevelSound
	lda #NEWLEVELMUSICLENGTH
	sta MusicIndex
	lda GirderColor1
	clc
	adc #$10
	sta GirderColor1
	lda GirderColor2
	clc
	adc #$10
	sta GirderColor2
NotNewLevelSound

;NotDoneScrollingYet
;	lda ScrollCounter
;	cmp #1
;	beq UpdateGirderData
;	jmp DoNotUpdateGirderData

UpdateGirderData
	ldx #0
MovePlayfieldDataLoop
	lda GirderPattern+1,X
	sta GirderPattern,X
	lda EnemyPosition+1,X
	sta EnemyPosition,X
	lda EnemyMovement+1,X
	sta EnemyMovement,X
	lda EnemyColor+1,X
	sta EnemyColor,X
	lda EnemyType+1,X
	sta EnemyType,X

	inx
	cpx #MAXVISIBLELEVELS-1
	bne MovePlayfieldDataLoop

	lda Floor
	cmp #$30
	bcc NoSuitcaseOnScreenNormalGirderPattern
	lda #0
	beq SetNewGirderPattern
NoSuitcaseOnScreenNormalGirderPattern
NewRandomGirderPattern
	jsr UpdateRandomNumberSubroutine
	and #%00000111
	beq NewRandomGirderPattern
SetNewGirderPattern
	sta GirderPattern,X

	;--create new enemy
	jsr CreateNewEnemySubroutine


NoChangeToScrollCounter
DoNotUpdateGirderData
	
NoChangeToScrollCounterThisFrame
	rts

;-------------------------------------------------------------------------

CreateNewEnemySubroutine
	ldy Level
	lda Floor
	and #$0F
	cmp #$0F
	bcc DontAdjustLevel
	iny
DontAdjustLevel
	jsr UpdateRandomNumberSubroutine
	and #$87							;I think this will work OK
	ora #1
	sta EnemyMovement,X

	;--new enemy color
	jsr UpdateRandomNumberSubroutine
	and #$F0
	sta EnemyColor,X
	;--new enemy
	;--if suitcase on screen, no new enemies
	lda Floor
	cmp #$30
	bcc NoSuitcaseOnscreenNormalEnemy
	lda #BLANKENEMY
	beq SetNewEnemyType			;branch always
NoSuitcaseOnscreenNormalEnemy
	lda Floor
	and #$0F
	cmp #$0F
	bne NormalNewEnemy
	;--else: 	levels 3, 6, 9, 12, 15, etc. - display suitcase
	;--			levels 1, 4, 7, 10, 13, etc. - display normal enemy
	;--			levels 2, 5, 8, 11, 14, etc. - display bonus life
	lda Floor
	;--if  	= $2F then suitcase
	;	 	= $0F then normal
	;		= $1F then bonus item
	and #$30
	beq NormalNewEnemy
	;--else suitcase or bonus item, they have following position routine
	jsr UpdateRandomNumberSubroutine
	and #$53
	adc #LBOUND_ENEMY+10
	sta EnemyPosition,X
	lda Floor
	and #$30
	cmp #$20
	bne NotSuitcase
	;--else is suitcase
	lda #SUITCASE
	bne SetNewEnemyType		;branch always
NotSuitcase
	;--else display bonus item
	jsr UpdateRandomNumberSubroutine
	and #3
	clc				;get between 0 and 3
	adc #16 		;get between 16 and 19 (bonus items)	
	bne SetNewEnemyType		;branch always
NormalNewEnemy
	;--first set normal enemy position
	jsr UpdateRandomNumberSubroutine
	and #$5F
	adc #LBOUND_ENEMY
	sta EnemyPosition,X
	jsr UpdateRandomNumberSubroutine
	cpy #15			;Y holds adjusted level!
	bcs NewRandomEnemy
	;--else new enemy is same as level
	iny
	tya
	jmp SetNewEnemyType

NewRandomEnemy
	jsr UpdateRandomNumberSubroutine
	and #$0F
SetNewEnemyType
	sta EnemyType,X

	rts

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------


;-------------------------------------------------------------------------

ProcessEnemiesSubroutine

	dec MoveEnemiesDelay
	beq MoveEnemiesThisFrame
	rts

MoveEnemiesThisFrame
		ldy Level		;2B56 A4 92
		lda MoveEnemiesDelayTable,Y	;2B58 B9 F9 2A
		sta MoveEnemiesDelay		;2B5B 85 8B

	
	ldx #MAXVISIBLELEVELS-1
	bne SkipColorChangeFirstTimeThrough		;branch always
ProcessEnemiesLoop
	;--brighten color if necessary (only if too dim and enemy is onscreen)
	lda EnemyColor,X
	and #$0F
	cmp #$0A
	bcs DoneWithEnemyColor
	inc EnemyColor,X
DoneWithEnemyColor
NoChangeToEnemyColorThisFrame
SkipColorChangeFirstTimeThrough
	;--enemy movement
	lda EnemyMovement,X
	and #ENEMYSQUISHED_BIT
	beq RegularEnemyMovement
	;--else squished enemy

	;--update stopped timer
	lda EnemyMovement,X
	sec
	sbc #ENEMYSTOPLOBIT
	sta EnemyMovement,X

	;--check if enemy should pop back up now
	and #ENEMYSTOPCOUNTER_BITS
	beq PopEnemyBackUp
	jmp DoNotMoveEnemy		;enemy still down for the count!
PopEnemyBackUp
	;--pop him up, turn him white, new random direction, and play pop-up sound effect
	lda EnemyMovement,X
	and #~ENEMYSQUISHED_BIT
	sta EnemyMovement,X
	lda #11					
	sta SFXIndex1
	lda #GRAY+14
	sta EnemyColor,X

	jsr UpdateRandomNumberSubroutine
	and #ENEMYDIRECTION_BIT
	sta Temp
	lda EnemyMovement,X
	and #~ENEMYDIRECTION_BIT
	ora Temp					;new random direction for popped-up enemies
	sta EnemyMovement,X
RegularEnemyMovement
	;--move enemy----------------

	;---direction of enemy determined here
	lda EnemyType,X
	tay
	lda MonsterMovementTable,Y
	beq EnemyStopPattern
	cmp #BOUNCE
	beq EnemyBouncePattern
	cmp #FOLLOW
	beq EnemyFollowPattern
	;--else erratic pattern
	lda EnemyMovement,X
	and #ENEMYSTOPCOUNTER_BITS
	beq ChangeDirectionOfErraticEnemy
	dec EnemyMovement,X
	jmp EnemyBouncePattern
ChangeDirectionOfErraticEnemy
	jsr UpdateRandomNumberSubroutine
	and #ENEMYSTOPCOUNTER_BITS
	ora #1
	sta Temp+1
	lda EnemyMovement,X
	eor #ENEMYDIRECTION_BIT
	ora Temp+1
	sta EnemyMovement,X
	jmp EnemyBouncePattern

EnemyFollowPattern
	;--following enemies move slower than regular enemies!
	lda EnemyMovement,X
	and #ENEMYSTOPCOUNTER_BITS
	beq MoveFollowingEnemy
	dec EnemyMovement,X
	jmp DoNotMoveEnemy
MoveFollowingEnemy
	;--reset move delay
	lda EnemyMovement,X
	ora #3
	sta EnemyMovement,X
	;--try to match X position with player
	lda PlayerX
	cmp EnemyPosition,X
	bcc MoveEnemyLeft
	bcs MoveEnemyRight		;branch always.  We still move even when equal
JustMoveErraticEnemy
EnemyBouncePattern
	;--enemy moves left until hits wall, then moves right until hits wall, then moves left until...
	lda EnemyMovement,X
	and #ENEMYDIRECTION_BIT
	bne MoveEnemyRight
	;--else move enemy left
MoveEnemyLeft
	dec EnemyPosition,X
	.byte $2C
MoveEnemyRight
	inc EnemyPosition,X
	;--check left/right boundaries
	lda EnemyPosition,X
	cmp #LBOUND_ENEMY
	bcc MonsterTooFarLeft
	cmp #RBOUND_ENEMY+1
	bcc MonsterNotTooFarRight
	lda #RBOUND_ENEMY
	.byte $2C
MonsterTooFarLeft
	lda #LBOUND_ENEMY
	sta EnemyPosition,X
	lda EnemyMovement,X
	eor #ENEMYDIRECTION_BIT	
	sta EnemyMovement,X
MonsterNotTooFarRight
EnemyStopPattern
DoNotMoveEnemy

	dex
	bmi DoneProcessingEnemies
 	jmp ProcessEnemiesLoop			;too long for branch
DoneProcessingEnemies

	rts

;-------------------------------------------------------------------------

MoveBrickSubroutine
	lda GameOnFlag
	beq NoNewBrickYet
	lda BrickY
	cmp #252
	bcs MoveBrick
	;--else maybe don't move brick
	cmp #125
	bcc MoveBrick
	;--else brick is still offscreen, so figure out when to drop it
	lda Floor
	cmp #$30			;no new brick once suitcase makes appearance.
	bcs NoNewBrickYet
	lda Level
	cmp #2				;no new brick until level 3
	bcc NoNewBrickYet
	;--else, bring on the brick
	dec BrickTimer
	bne NoNewBrickYet
	;--else, create a new brick!
	lda #PLAYAREAHEIGHT+16
	sta BrickY
	lda #$02
	sta BrickFallingSound
	lda PlayerX
	sta BrickX
	inc BrickX

MoveBrick
	;--but move brick left as necessary (left only!)
	lda BrickMovement
	beq DontMoveBrickLR
	dec BrickMovement
	dec BrickX
	bne DontMoveBrickDown
DontMoveBrickLR
	lda BrickFallingSound
	beq NoChangeToBrickFallingSound
	inc BrickFallingSound		;do this every frame
NoChangeToBrickFallingSound
	lda FrameCounter
	and #1
	beq DontMoveBrickDown
	lda ScrollCounter
	beq MoveBrickNormalSpeed
	lda PlayerFlags
	and #DYING_BIT
	bne MoveBrickNormalSpeed		;normal speed if dying since scroll stopped
	dec BrickY
MoveBrickNormalSpeed
	dec BrickY
DontMoveBrickDown
NoNewBrickYet
	rts


;-------------------------------------------------------------------------

KernelPrepSubroutine

	lda GirderPattern+MAXVISIBLELEVELS-1
	tax

	lda PF1GirderLookup,X
	sta PF1Temp
	lda PF2GirderLookup,X
	sta PF2Temp
	lda PF3GirderLookup,X
	sta PF3Temp
	lda PF4GirderLookup,X
	sta PF4Temp

	lda #PLAYAREAHEIGHT
	sec
	sbc BrickY
	sta BrickTemp

	lda #PLAYAREAHEIGHT*2
	sec
	sbc PlayerY
	sta PlayerTemp

	lda PlayerY
	lsr
	sta Temp

	lda PlayerFrame
	asl
	tay

	lda PlayerGfxPtrTableb,Y
	sec
	sbc Temp
	clc
	adc PlayerFrameOffset
	sta PlayerGfxPtr1
	lda PlayerGfxPtrTableb+1,Y
	sta PlayerGfxPtr1+1

	lda PlayerGfxPtrTablea,Y
	sec
	sbc Temp
	clc
	adc PlayerFrameOffset
	sta PlayerGfxPtr2
	lda PlayerGfxPtrTablea+1,Y
	sta PlayerGfxPtr2+1

	lda #<PlayerColorTablea
	sec
	sbc Temp
	clc
	adc PlayerFrameOffset
	sta PlayerClrPtr1
	lda #>PlayerColorTablea
	sta PlayerClrPtr1+1

	lda #<PlayerColorTableb
	sec
	sbc Temp
	clc
	adc PlayerFrameOffset
	sta PlayerClrPtr2
	lda #>PlayerColorTableb
	sta PlayerClrPtr2+1

	lda BrickX
	ldx #3
	jsr PositionASpriteSubroutine


	ldy #THREECOPIESCLOSE			;3
	sty NUSIZ0
	sty NUSIZ1
	sty VDELP0
	sty VDELP1
	iny
	sty PF0
	sty PF1
	sty PF2
	lda #96
	ldx #1
	jsr PositionASpriteSubroutine

	lda ScoreColor
	sta COLUP0
	sta COLUP1

	lda #88
	dex
	jsr PositionASpriteSubroutine

	;--setup score pointers
   ldx #10
SetupScorePtrsLoop
   txa
   lsr
   lsr
   tay
   lda Score,Y
   pha
   jsr GetDigitDataLo       ; 20        too slow? (costs ~1 scanline)
   sta MiscPtr,X
   pla
   jsr Lsr4Tay              ; 22        

   lda DigitDataLo,Y
   sta MiscPtr-2,X
   lda #>DigitData
   sta MiscPtr+1,X
   sta MiscPtr-1,X
   dex
   dex
   dex
   dex
   bpl SetupScorePtrsLoop


	ldy #(MAXVISIBLELEVELS-1)*2
	ldx #MAXVISIBLELEVELS-1
ProcessEnemyPtrsLoop
	lda EnemyMovement,X
	and #ENEMYSQUISHED_BIT
	beq RegularEnemyPtr
	lda #<Squished+ENEMYHEIGHT
	sta EnemyPtr,Y
	lda #>Squished
	sta EnemyPtr+1,Y
	bne DoneWithThisEnemyPtr

RegularEnemyPtr
	stx Temp
	lda EnemyType,X
	asl
	tax
	lda MonsterPtrTable,X
	sta EnemyPtr,Y
	lda MonsterPtrTable+1,X
	sta EnemyPtr+1,Y
	ldx Temp

DoneWithThisEnemyPtr
	dey
	dey
	dex
	bpl ProcessEnemyPtrsLoop

	lda ScrollCounter
	lsr
	tax
	lda LineCounterPresetTable,X
	sta LineCounter

	lda ScrollCounter
	beq RegularMonsterOnTopLine
	lda #<BlankMonster
	clc
	adc TopEnemyPtrPresetTable,X
	sta EnemyPtr+10 ;(MAXVISIBLELEVELS-1)*2
	lda #>(BlankMonster+ENEMYHEIGHT)
	sta EnemyPtr+11	;1+(MAXVISIBLELEVELS-1)*2
RegularMonsterOnTopLine

	txa
	asl
	tax
	lda KernelEntranceJumpTable,X
	sta KernelPtr
	lda KernelEntranceJumpTable+1,X
	sta KernelPtr+1
	
	sta HMCLR		


;UpdateCountersSubroutine
	dec FrameCounter
	;--temporary testing stuff
;	lda FrameCounter
;	and #31
;	bne NoUpdateExtraLivesTEMP
;	inc ExtraLives 
;NoUpdateExtraLivesTEMP
	;--end temp testing stuff

	inc SFXIndex0
UpdateRandomNumberSubroutine		;do this once per frame as well as all the other times.
	;--update random number
    lda RandomNumber
    lsr
    bcc SkipEOR
    eor #$B2
SkipEOR
    sta RandomNumber

	rts	


;----------------------------------------------------------------------------




IncreaseScoreSubroutine
	sed
	clc
	lda Score+2
	adc Temp+2
	sta Score+2
	lda Score+1
	adc Temp+1
	sta Score+1
	lda Score
	adc #0
	sta Score

	cld
	rts

;----------------------------------------------------------------------------
Lsr5Tay
	lsr
Lsr4Tay
   lsr
Lsr3Tay
   lsr
   lsr
   lsr
   tay
   rts

;-------------------------------------------------------------------------





ReadJoystickSubroutine
	lda GameOnFlag
	bne GameOnSoAllowAllInput
	jmp TriggerInputOnlyWhenGameNotOn

GameOnSoAllowAllInput
	lda PlayerFlags
	and #DYING_BIT
	beq PlayerNotDyingAllowInput
	rts
PlayerNotDyingAllowInput
	lda PlayerMove
	beq PlayerNotMovingLR
	jmp PlayerAlreadyMovingLR
PlayerNotMovingLR
	lda ScrollCounter
	beq PlayerNotMovingUp
	jmp PlayerAlreadyMovingUp
PlayerNotMovingUp
	lax SWCHA
	and #J0UP
	bne NoUp
	;--can only move up if there is a girder above
	;-first, translate PlayerX into an index 0-5
	lda PlayerX			;==34, 50, 66, 86, 102, 118
	cmp #86
	bcc PlayerOnLeftSide
	sbc #4				;carry set following bcc
						;==34, 50, 66, 82, 98, 114
PlayerOnLeftSide
	sec
	sbc #34				;==0, 16, 32, 48, 64, 80
	jsr Lsr4Tay			;==0, 1, 2, 3, 4, 5
	lda GirderPattern+2	;this is the one right above player
	and GirderToClimbTable,Y
	beq NoGirderCannotClimb
	;--can climb, and WILL!

	lda #32
	sta ScrollCounter
	lda #HANGINGFRAME			;==0
	sta PlayerFrame
	sta LegsUpCounter
	beq PlayerAlreadyMovingUp		;can't move up diagonally (branch always)
NoGirderCannotClimb
NoUp

NoDown

	lda PlayerX
	cmp #118		;far right as we can go
	beq NoRight
	txa
	and #J0RIGHT
	bne NoRight
	lda PlayerFlags
	ora #PLAYERRIGHT
	sta PlayerFlags	
	lda PlayerX
	cmp #66
	bne MoveRight16
	;--else move right 20
	lda PlayerFlags
	ora #PLAYERMOVE16_BIT
	sta PlayerFlags
	bne SetPlayerMove
MoveRight16
	lda PlayerFlags
	and #~PLAYERMOVE16_BIT
	sta PlayerFlags
SetPlayerMove
	lda #32
	sta PlayerMove
NoRight
	lda PlayerX
	cmp #34		;far left as we can go
	beq NoLeft
	txa
	and #J0LEFT
	bne NoLeft
	lda PlayerFlags	
	and #~PLAYERRIGHT
	sta PlayerFlags	
	lda PlayerX
	cmp #86
	bne MoveLeft16
	;--else move right 20 (x2)
	lda PlayerFlags
	ora #PLAYERMOVE16_BIT
	sta PlayerFlags
	bne SetPlayerMoveL
MoveLeft16
	lda PlayerFlags
	and #~PLAYERMOVE16_BIT
	sta PlayerFlags
SetPlayerMoveL
	lda #32
	sta PlayerMove
NoLeft
PlayerAlreadyMovingLR
	;--now the joystick button
	;---debounce trigger
TriggerInputOnlyWhenGameNotOn
	lda INPT4
	bpl TriggerPressed
	;--reset trigger debounce if legs are not up
	lda LegsUpCounter
	bne NoTrigger
	sta TriggerDebounce
	beq NoTrigger			;branch always
TriggerPressed
	;--first check debounce bit
	lda TriggerDebounce
	bne NoTrigger	
	;--if game not on, start game.
	;	else, make him lift his legs
	lda GameOnFlag
	bne GameOnLiftThoseLegs
	lda #$FF
	sta TriggerDebounce
	jmp StartNewGame
GameOnLiftThoseLegs
	;--set proper frame and frame counter
	lda #LEGSUPFRAME
	sta PlayerFrame
	lda #LEGSUPTIME
	sta LegsUpCounter
	sta TriggerDebounce

NoTrigger

PlayerAlreadyMovingUp


	rts

;-------------------------------------------------------------------------



KernelSubEntrance2		;				16 bytes
	lda #STATICGIRDER_PF1
	sta PF1
	lda #STATICGIRDER_PF2
	sta PF2				;+10	29
	lda ($80,X)
	dec $2D
	nop					;+13
	jmp MainKernelLoopOuter2Entrance	;		45
KernelSubEntrance3		;				13 bytes
	lda #$FF
	sta PF1
	sta PF2				;+18	27
	lda ($80,X)			;+6
	lda #PLAYERHEIGHT-1
	jmp MainKernelLoopOuter3Entrance	;		38
KernelSubEntrance4		;		19		15 bytes
	lda #$FF
	sta PF1
	sta PF2				;+8		27
	dec $2D
	nop					;+7		34
	lda #3
	sec					;+4		38
	jmp MainKernelLoopOuter4Entrance	;		41
KernelSubEntrance5				;		16 bytes
	lda #STATICGIRDER_PF1
	sta PF1
	lda #STATICGIRDER_PF2
	sta PF2				;+10	29
	lda #3
	sec					;+4		33
	SLEEP 3					;+2		35
	jmp MainKernelLoopOuter5Entrance	;		39
KernelSubEntrance6				;		13 bytes
	lda PF1Temp
	sta PF1
	lda PF2Temp
	sta PF2				;+12	31
	SLEEP 3
	jmp MainKernelLoopOuter6Entrance	;		37
KernelSubEntrance7				;		13 bytes
	lda PF1Temp
	sta PF1
	lda PF2Temp
	sta PF2				;+12	31
	SLEEP 3
	jmp MainKernelLoopOuter7Entrance	;		37

;-------------------------------------------------------------------------

ConsoleSwitchesSubroutine
	;--also check trigger here when game is not on since the start routine is the same.
	lax SWCHB
	ldy ConsoleSwitchDebounce
	beq ReadConsoleSwitches
	and #SELECT|RESET
	eor #SELECT|RESET
	bne ConsoleSwitchesStillHeldDown	
	sta ConsoleSwitchDebounce
	txa
ReadConsoleSwitches
	and #RESET
	bne ResetNotPressed
	;--RESET pressed, so (re)start game
StartNewGame
	ldx #$FF
	stx GameOnFlag
	stx ConsoleSwitchDebounce
	inx
	stx Score
	stx Score+1
	stx Score+2
	jmp NewGameSetupSubroutine
ResetNotPressed
	txa
	and #SELECT
	bne SelectNotPressed
	ldx #$FF
	stx ConsoleSwitchDebounce
	inx
	stx GameOnFlag
	stx MusicIndex
StartLevelTooHigh
	inc StartLevel
	lda StartLevel
	and #$0F
	sta StartLevel
	beq StartLevelTooHigh
StartLevelNotTooHigh
	sec
	sbc #10
	bcc StartLevelUnder10
	ora #$10
	bne SetLevelDisplay
StartLevelUnder10
	lda StartLevel
	ora #$A0
SetLevelDisplay
	sta Score
	lda #$AA
	sta Score+1
	sta Score+2
	jmp StopGameSetup	

SelectNotPressed
ConsoleSwitchesStillHeldDown

	rts

;-------------------------------------------------------------------------



;*************************************************************************

;-------------------------------------------------------------------------
;-------------------------Data Below--------------------------------------
;-------------------------------------------------------------------------

MoveSidewaysFreqTable			
;		.byte $18,$12,$18,$15
		.byte $0C,$09,$0C,$0A
;		.byte 5,3,5,4
;		.byte 7,5,7,6

	;Girders: 
	;	PF1			PF2			PF3			PF4
	;     1       3   2       4   5          6
	;11000x00	00x000x0	00x000x0	11000x00

	;000000,001001,010010,011011,100100,101101,110110,111111

PF1GirderLookup		;11000x00
	.byte %11000000,%11000000,%11000000,%11000000,%11000100,%11000100,%11000100,%11000100


MoveEnemiesDelayTable
SquishedTimeTable
		.byte $08,$07,$07,$06,$06,$05,$05,$04,$04,$03,$03,$02,$02,$02,$02,$02
		.byte $01


BackgroundSoundFreqTable	
		.byte $0E,$0E,$0F,$0F,$0F,$0F,$10,$10,$00,$00,$00,$00,$00,$00,$00,$00
		.byte $10,$10,$0F,$0F,$0F,$0F,$0E,$0E,$00,$00,$00,$00,$00,$00,$00,$00
SoundEffectFrequencyTable		;zero separates different sound effects
		.byte $00,$0A,$0A,$0B,$0B,$0B,$0F,$0F,$0F,$0F,$0C,$0C,$00,$0C,$0C,$0F
		.byte $0F,$0F,$0F,$0B,$0B,$0B,$0A,$0A,$08,$08,$06,$06,$04,$04,$03,$03
		.byte $03,$03,$08,$08,$FF,$FF,$FF,$FF
MusicFrequencyTable
		.byte $00,$05,$04,$05,$07,$00,$05,$07,$05,$04,$05,$07,$05,$05,$03,$05
		.byte $00,$04,$00,$05

		;--following are original A800 values.  Each one (+1) is divided into 64 KHz
		;	problem: base frequency for 2600 is 31.44 KHz or about half.  So pitches
		;	are an octave down.  Could divide all pitches by 2 but...lose a little 
		;	accuracy since some of the frequencies have bit 0 set.
		;...But it seems to work OK.
;		.byte $00,$0B,$09,$0B,$0F,$00,$0B,$0F,$0B,$09,$0B,$0F,$0B,$0B,$06,$0B
;		.byte $00,$08,$00,$0A

ExtraLivesNUSIZ1Table			;shares bytes with following table
	.byte ONECOPYNORMAL,ONECOPYNORMAL,ONECOPYNORMAL
ExtraLivesNUSIZ0Table
	.byte ONECOPYNORMAL,ONECOPYNORMAL,TWOCOPIESCLOSE,THREECOPIESCLOSE,THREECOPIESCLOSE,THREECOPIESCLOSE,THREECOPIESCLOSE

ExtraLivesP1MaskTable			;shares bytes with following table
	.byte $00,$00,$00
ExtraLivesP0MaskTable
	.byte $00,$FF,$FF,$FF,$FF,$FF,$FF

LineCounterPresetTable
	.byte 6,6,6
	.byte 6,6
	.byte 6,5
	.byte 4,3
	.byte 2
;	.byte 0,0
;	.byte 0,0
;	.byte 0,0
PlayerMoveLRTable			;move-16 and move-20 data interlaced. move-16 data is first
	.byte 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1
	.byte 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1
	.byte 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1
	.byte 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1





MonsterPtrTable
	.word BlankMonster+ENEMYHEIGHT
	.word Monster0+ENEMYHEIGHT,Monster1+ENEMYHEIGHT,Monster2+ENEMYHEIGHT,Monster3+ENEMYHEIGHT
	.word Monster4+ENEMYHEIGHT,Monster5+ENEMYHEIGHT,Monster6+ENEMYHEIGHT,Monster7+ENEMYHEIGHT
	.word Monster8+ENEMYHEIGHT,Monster9+ENEMYHEIGHT,Monster10+ENEMYHEIGHT,Monster11+ENEMYHEIGHT
	.word Monster12+ENEMYHEIGHT,Monster13+ENEMYHEIGHT,Monster14+ENEMYHEIGHT
	.word Bonus0+ENEMYHEIGHT,Bonus1+ENEMYHEIGHT,Bonus2+ENEMYHEIGHT,Bonus3+ENEMYHEIGHT
	.word Suitcase+ENEMYHEIGHT



PlayerGfxPtrTablea
	.word Hanging1a,Climbinga,LegsUpa,Shimmy1a,Shimmy2a
PlayerGfxPtrTableb
	.word Hanging1b,Climbingb,LegsUpb,Shimmy1b,Shimmy2b

GirderToClimbTable
	.byte %100,%010,%001,%100,%010	;,%001

PFColorPresetIndexTable
	.byte 1,0,0
	.byte 0,0
	.byte 1,1
	.byte 1,1
	.byte 1
	.byte 1,1
;	.byte 1,1
;	.byte 1,1
MonsterMovementTable
;	.byte STOP			;doesn't matter since this is movement pattern for blank enemy
	.byte 1
	.byte BOUNCE,BOUNCE,BOUNCE,ERRATIC
	.byte ERRATIC,ERRATIC,ERRATIC,FOLLOW
	.byte FOLLOW,ERRATIC,FOLLOW,ERRATIC
	.byte ERRATIC,FOLLOW,FOLLOW
	.byte STOP,STOP,STOP,STOP		;,STOP==0==<Zero

DigitDataLo
	.byte <Zero,<One,<Two,<Three,<Four,<Five,<Six,<Seven,<Eight,<Nine,<BlankDigit

KernelEntranceJumpTable
	.word KernelSubEntrance1,KernelSubEntrance2,KernelSubEntrance3
	.word KernelSubEntrance4,KernelSubEntrance5
	.word KernelSubEntrance6,KernelSubEntrance6
	.word KernelSubEntrance6,KernelSubEntrance6
	.word KernelSubEntrance6
	.word KernelSubEntrance7,KernelSubEntrance7
	.word KernelSubEntrance7,KernelSubEntrance7
	.word KernelSubEntrance7,KernelSubEntrance7

InitialLineTable
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2

InitialXTable
	.byte MAXVISIBLELEVELS*2,(MAXVISIBLELEVELS*2-2)/2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2,MAXVISIBLELEVELS*2-2
	.byte MAXVISIBLELEVELS*2-2
	.byte 0		;,0
;	.byte 0,0
;	.byte 0,0
ExtraLifeGfxTable
	.byte 0,0,0,0,0
	.byte %00010100
	.byte %00010100
	.byte %00011100
	.byte %00101010
	.byte %00111110
	.byte %00001000
	.byte %00011100
	.byte %00011100
	.byte 0



ColorGradientTable
	.byte GRADIENTCOLOR+10,GRADIENTCOLOR+10
	.byte GRADIENTCOLOR+6,GRADIENTCOLOR+6
	.byte GRADIENTCOLOR+4,GRADIENTCOLOR+4
	.byte GRADIENTCOLOR,GRADIENTCOLOR,GRADIENTCOLOR
	.byte GRADIENTCOLOR+4,GRADIENTCOLOR+4
	.byte GRADIENTCOLOR+6,GRADIENTCOLOR+6
	.byte GRADIENTCOLOR+10,GRADIENTCOLOR+10
	.byte GRADIENTCOLOR



Monster13
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%10000000;--
        .byte #%01100101;--
        .byte #%00011010;--
        .byte #%00011000;--
        .byte #%01111110;--
        .byte #%11011011;--
        .byte #%11101101;--
        .byte #%01111110;--
        .byte #%00011000;--
		.byte 0
Monster14
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%00101010;--
        .byte #%00011001;--
        .byte #%00011010;--
        .byte #%00111100;--
        .byte #%01011000;--
        .byte #%10011000;--
        .byte #%00101100;--
        .byte #%01100110;--
        .byte #%00011000;--
		.byte 0


	;--8 free bytes

	align 256


DigitData
Zero
        .byte #%01111111;--
        .byte #%01000011;--
        .byte #%01000011;--
        .byte #%01000011;--
        .byte #%01000001;--
        .byte #%01000001;--
;        .byte #%01111111;--
Two
        .byte #%01111111;--
        .byte #%01100000;--
        .byte #%01100000;--
        .byte #%01111111;--
        .byte #%00000001;--
        .byte #%01000001;--
;        .byte #%01111111;--
Three
        .byte #%01111111;--
        .byte #%01000011;--
        .byte #%00000011;--
        .byte #%00111111;--
        .byte #%00000010;--
        .byte #%01000010;--
        .byte #%01111110;--
Seven
        .byte #%00000011;--
        .byte #%00000011;--
        .byte #%00000011;--
        .byte #%00000011;--
        .byte #%00000001;--
        .byte #%00000001;--
;        .byte #%01111111;--

Five
        .byte #%01111111;--
        .byte #%01000011;--
        .byte #%00000011;--
        .byte #%01111111;--
        .byte #%01000000;--
        .byte #%01000001;--
;        .byte #%01111111;--
Six
        .byte #%01111111;--
        .byte #%01000011;--
        .byte #%01000011;--
        .byte #%01111111;--
        .byte #%01000000;--
        .byte #%01000001;--
        .byte #%01111111;--

Nine
        .byte #%00000011;--
        .byte #%00000011;--
        .byte #%00000011;--
        .byte #%01111111;--
        .byte #%01000001;--
        .byte #%01000001;--
;        .byte #%01111111;--
Eight
        .byte #%01111111;--
        .byte #%01000011;--
        .byte #%01000011;--
        .byte #%01111111;--
        .byte #%00100010;--
        .byte #%00100010;--
        .byte #%00111110;--

One
        .byte #%00001100;--
        .byte #%00001100;--
        .byte #%00001100;--
        .byte #%00001100;--
        .byte #%00000100;--
        .byte #%00000100;--
        .byte #%00000100;--

Four
        .byte #%00000110;--
        .byte #%00000110;--
        .byte #%00000110;--
        .byte #%01111111;--
        .byte #%01000010;--
        .byte #%01000010;--
        .byte #%01000010;--



Monster0
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00011101;--
        .byte #%10111010;--
        .byte #%01011000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0
Monster1
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%00000001;--
        .byte #%10011010;--
        .byte #%01111100;--
        .byte #%00100100;--
        .byte #%00011000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0
Monster2
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%01001000;--
        .byte #%00100100;--
        .byte #%11111111;--
        .byte #%11000011;--
        .byte #%10111101;--
        .byte #%01101110;--
        .byte #%00111100;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0
Monster3
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%00110110;--
        .byte #%00100100;--
        .byte #%01111110;--
        .byte #%11100011;--
        .byte #%11111011;--
        .byte #%01111110;--
        .byte #%00111100;--
        .byte #%01000100;--
        .byte #%00000000;--
		.byte 0
Monster4
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%01111110;--
        .byte #%11011111;--
        .byte #%11011011;--
        .byte #%01011010;--
        .byte #%01111010;--
        .byte #%00111100;--
        .byte #%00011000;--
        .byte #%00100101;--
        .byte #%11000010;--
		.byte 0
Monster5
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%10101000;--
        .byte #%01111110;--
        .byte #%00110000;--
        .byte #%01111000;--
        .byte #%11111110;--
        .byte #%10010010;--
        .byte #%11010110;--
        .byte #%01111100;--
        .byte #%00111000;--
		.byte 0
BlankMonster
		.byte ENDMONSTERVALUE
BlankDigit
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0
Bonus0
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%11111111;--
        .byte #%01100110;--
        .byte #%00111100;--
        .byte #%00000000;--
        .byte #%00101000;--
        .byte #%01000010;--
        .byte #%00010001;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0
Bonus1
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%01111110;--
        .byte #%11000011;--
        .byte #%10010001;--
        .byte #%10001001;--
        .byte #%11000011;--
        .byte #%01111110;--
        .byte #%00011000;--
        .byte #%11111000;--
        .byte #%00011111;--
		.byte 0
Squished
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%01110011;--
        .byte #%01011100;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0
Suitcase
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%11111111;--
        .byte #%11111111;--
        .byte #%11111111;--
        .byte #%11100111;--
        .byte #%11111111;--
        .byte #%00100100;--
        .byte #%00111100;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0

Monster6
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%10000000;--
        .byte #%10011000;--
        .byte #%11111110;--
        .byte #%01111111;--
        .byte #%00011001;--
        .byte #%00101010;--
        .byte #%00100100;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0
Monster7
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%11011011;--
        .byte #%01001001;--
        .byte #%11111111;--
        .byte #%01111110;--
        .byte #%00000100;--
        .byte #%00000100;--
        .byte #%00111110;--
        .byte #%00101100;--
        .byte #%00011100;--
		.byte 0
Monster8
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%01001001;--
        .byte #%00101010;--
        .byte #%01111110;--
        .byte #%00101100;--
        .byte #%01110110;--
        .byte #%01101110;--
        .byte #%01111110;--
        .byte #%00111100;--
;        .byte #%00000000;--
;		.byte 0

	;000000,001001,010010,011011,100100,101101,110110,111111

PF3GirderLookup		;00400050
	.byte %00000000,%00000000,%00000010,%00000010,%00100000,%00100000,%00100010,%00100010

TopEnemyPtrPresetTable
	.byte ENEMYHEIGHT,ENEMYHEIGHT,ENEMYHEIGHT
	.byte ENEMYHEIGHT,ENEMYHEIGHT
	.byte ENEMYHEIGHT,ENEMYHEIGHT
	.byte ENEMYHEIGHT,ENEMYHEIGHT
	.byte ENEMYHEIGHT
	.byte ENEMYHEIGHT+1,ENEMYHEIGHT-1
	.byte ENEMYHEIGHT-3,ENEMYHEIGHT-5
	.byte ENEMYHEIGHT-7,ENEMYHEIGHT-9


	;---1 free bytes

	align 256

Bonus2
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%01110000;--
        .byte #%01111110;--
        .byte #%01110110;--
        .byte #%11111110;--
        .byte #%10111100;--
        .byte #%11111100;--
        .byte #%00011100;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0

Bonus3
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%01111110;--
        .byte #%00111100;--
        .byte #%00011000;--
        .byte #%00110100;--
        .byte #%01110010;--
        .byte #%01110010;--
        .byte #%01110010;--
        .byte #%00111100;--
        .byte #%00000000;--
		.byte 0

Monster9
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%11111000;--
        .byte #%00111100;--
        .byte #%00111100;--
        .byte #%01111101;--
        .byte #%11111111;--
        .byte #%10011100;--
        .byte #%00111110;--
        .byte #%00101010;--
        .byte #%00011100;--
		.byte 0
Monster10
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%00000000;--
        .byte #%01010101;--
        .byte #%01010101;--
        .byte #%11111111;--
        .byte #%00111111;--
        .byte #%00011110;--
        .byte #%00001100;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0
Monster11
		.byte ENDMONSTERVALUE
        .byte #%00000000;--
        .byte #%10111000;--
        .byte #%01011101;--
        .byte #%00011010;--
        .byte #%00011000;--
        .byte #%00110100;--
        .byte #%00110100;--
        .byte #%00011000;--
        .byte #%00000000;--
        .byte #%00000000;--
		.byte 0



	;--0 free bytes

;	align 64





LegsUpb
        .byte #%00000000;$FC
        .byte #%00000000;$FC
        .byte #%00000000;$FC
        .byte #%11011000;$FC
        .byte #%11011000;$FC
        .byte #%11110110;$FC
        .byte #%00011100;$FC
        .byte #%00011100;$D6
        .byte #%01111111;$D6
        .byte #%01111111;$D6
        .byte #%01011101;$FC
        .byte #%01011101;$FC
        .byte #%01011101;$FC
LegsUpa
		.byte 0
        .byte #%00000000;$FC
        .byte #%00000000;$FC
        .byte #%00000000;$FC
        .byte #%01001000;$FC
        .byte #%11011000;$FC
        .byte #%11111110;$FC
        .byte #%00011100;$D6
        .byte #%00011100;$D6
        .byte #%01111111;$D6
        .byte #%01001001;$FC
        .byte #%01011101;$FC
        .byte #%01011101;$FC
        .byte #%01001001;$FC

		.byte 0
Hanging1b
        .byte #%00110110;$FC
        .byte #%00110110;$FC
        .byte #%00110110;$FC
        .byte #%00110110;$FC
        .byte #%00111110;$FC
        .byte #%00011100;$FC
        .byte #%00011100;$FC
        .byte #%01011100;$D6
        .byte #%01111111;$D6
        .byte #%00111111;$D6
        .byte #%00011101;$FC
        .byte #%00011101;$FC
        .byte #%00011101;$FC
	
Hanging1a
		.byte 0
        .byte #%00010100;$FC
        .byte #%00110110;$FC
        .byte #%00110110;$FC
        .byte #%00111110;$FC
        .byte #%00111110;$FC
        .byte #%00011100;$FC
        .byte #%00111100;$D6
        .byte #%01011110;$D6
        .byte #%01111111;$D6
        .byte #%00001001;$FC
        .byte #%00011101;$FC
        .byte #%00011101;$FC
        .byte #%00001001;$FC

PlayerColorTableb
	.byte PANTSCOLOR,PANTSCOLOR,PANTSCOLOR
	.byte PANTSCOLOR,PANTSCOLOR,PANTSCOLOR,PANTSCOLOR
	.byte SHIRTCOLOR,SHIRTCOLOR,SHIRTCOLOR
	.byte HEADCOLOR,HEADCOLOR,HEADCOLOR,HEADCOLOR

PlayerColorTablea
	.byte PANTSCOLOR,PANTSCOLOR,PANTSCOLOR
	.byte PANTSCOLOR,PANTSCOLOR,PANTSCOLOR
	.byte SHIRTCOLOR,SHIRTCOLOR,SHIRTCOLOR,SHIRTCOLOR
	.byte HEADCOLOR,HEADCOLOR,HEADCOLOR

Shimmy1b
        .byte #%00110110;--
        .byte #%00110110;--
        .byte #%00110110;--
        .byte #%00110110;--
        .byte #%00111110;--
        .byte #%00011100;--
        .byte #%00011100;--
        .byte #%00111110;--
        .byte #%01111111;--
        .byte #%01001001;--
        .byte #%01011101;--
        .byte #%01011101;--
        .byte #%00101010;--
Shimmy1a
        .byte #%00000000;--
        .byte #%00010100;--
        .byte #%00110110;--
        .byte #%00110110;--
        .byte #%00110110;--
        .byte #%00111110;--
        .byte #%00011100;--
        .byte #%00011100;--
        .byte #%01111111;--
        .byte #%01111111;--
        .byte #%01011101;--
        .byte #%01011101;--
        .byte #%01011101;--
        .byte #%00100010;--
Shimmy2b
        .byte #%01100011;--
        .byte #%01100011;--
        .byte #%01100011;--
        .byte #%01100011;--
        .byte #%01111111;--
        .byte #%00111110;--
        .byte #%00011100;--
        .byte #%00111110;--
        .byte #%01111111;--
        .byte #%11111111;--
        .byte #%10011101;--
        .byte #%10011101;--
        .byte #%10011101;--
Shimmy2a
        .byte #%00000000;--
        .byte #%00100010;--
        .byte #%01100011;--
        .byte #%01100011;--
        .byte #%01100011;--
        .byte #%01111111;--
        .byte #%00011100;--
        .byte #%00011100;--
        .byte #%01111111;--
        .byte #%01111111;--
        .byte #%10001001;--
        .byte #%10011101;--
        .byte #%10011101;--
        .byte #%10001001;--

Climbingb
        .byte #%01100000;--
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%01111110;--
        .byte #%00111110;--
        .byte #%00111000;--
        .byte #%00111000;--
        .byte #%11111110;--
        .byte #%11111111;--
        .byte #%11111001;--
        .byte #%00111001;--
        .byte #%00111000;--
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0		;shares 1 bytes with next table.
Climbinga
        .byte #%00000000;--
        .byte #%00100000;--
        .byte #%01100100;--
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%01111110;--
        .byte #%00111000;--
        .byte #%00111000;--
        .byte #%01111100;--
        .byte #%11111110;--
        .byte #%10010001;--
        .byte #%00111001;--
        .byte #%00111010;--
        .byte #%00010000;--
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0






;-------------------------------------------------------------------------
;-------------------------End Data----------------------------------------
;-------------------------------------------------------------------------


	org $FFFC
	.word Start
	.word Start

