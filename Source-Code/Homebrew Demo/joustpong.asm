;
;
;bugs
;-framerate problem on title?
;-have computer flap wing down graphic last longer
;

;todo
;-make sure things are reset better 
;-change game by joystick hit, start game with button
;-move pterry up and down
;better logic when ball hits pterry







; JoustPong by Kirk Israel
	
	processor 6502
	include vcs.h
	include macro.h





;--------------------------------------
;CONSTANTS
;--------------------------------------


CEILING_HEIGHT = #88


SLOW_GRAV_LO_BYTE = #%11110000
SLOW_GRAV_HI_BYTE = #%11111111

SLOW_FLAP_LO_BYTE = #%11001000
SLOW_FLAP_HI_BYTE = #%00000000


SLOW_REBOUND_LO_BYTE = #%00000000
SLOW_REBOUND_HI_BYTE = #%11111111





FAST_FLAP_LO_BYTE = #%00000000
FAST_FLAP_HI_BYTE = #%00000001


SLOW_BALL_RIGHT_SPEED_LO_BYTE = #%10000000
SLOW_BALL_RIGHT_SPEED_HI_BYTE = #%00000000

SLOW_BALL_LEFT_SPEED_LO_BYTE = #%10000000
SLOW_BALL_LEFT_SPEED_HI_BYTE = #%11111111




GAMEFIELD_HEIGHT_IN_BRICKS = #22

SPRITEHEIGHT = #8
;floor heights are different, because heights are actually
;relative to the 'top' of the player or ball, but we want to
;make sure that the bottoms are hitting the floor
FLOOR_HEIGHT_FOR_BALL = #4	
FLOOR_HEIGHT_FOR_PLAYERS = #10

STRENGTH_OF_CEILING_REBOUND = #3;


SCORE_KERNAL_LENGTH = #5
GAME_KERNAL_LENGTH = #88

LENGTH_OF_FLAPSOUND = #15
PITCH_OF_FLAPSOUND = #15
;2!,8-,15 all kind of worked
TYPE_OF_FLAPSOUND = #2






VOLUME_OF_PONGHIT = #7
PITCH_OF_PONGHIT = #7
PITCH_OF_GOAL = #15
PITCH_OF_PONG_WALL_HIT = #25


;was 6 pixel height, 6 scanlines per

; 74 - 36 = 38

PIXEL_HEIGHT_OF_TITLE = #30
PIXEL_HEIGHT_OF_TITLE_PONG = #7

SCANLINES_PER_TITLE_PIXEL = #2
WINNING_SCORE = #10

BALLPOS_LEFT = #5  ;had to hack so it didn't show up on right side before reset...
BALLPOS_CENTER = #80 
BALLPOS_RIGHT = #160


PTERRY_LEFT_BOUNDARY = #25  ;had to hack so it didn't show up on right side before reset...
PTERRY_RIGHT_BOUNDARY = #125



MUSICRIFF_NOTECOUNT = #16
MUSICBEAT_NOTECOUNT = #12



PTERRY_LENGTH_OF_WINGCHANGE = #10




;--------------------------------------
;VARIABLES
;--------------------------------------

	SEG.U VARS 
	ORG $80

copyIntegerCoordP0 ds 1
copyIntegerCoordP1 ds 1

slowP0YCoordFromBottom ds 2
slowP0YSpeed ds 2

slowP1YCoordFromBottom ds 2
slowP1YSpeed ds 2



p0VisibleLine ds 1
p0DrawBuffer ds 1
p1VisibleLine ds 1
p1DrawBuffer ds 1



but0WasOn ds 1
but1WasOn ds 1


ballPosFromBot ds 1
ballVisibleLine ds 1
ballVertSpeed ds 1
ballBuffer ds 1

p0score ds 1
p1score ds 1

pointerP0Score ds 2
pointerP1Score ds 2

pointerP0Graphic ds 2
pointerP1Graphic ds 2


booleanBallRight ds 1
flapsoundRemaining ds 1
booleanGameIsTwoPlayers ds 1
;variableGameMode ds 1
booleanSelectSwitchIsDown ds 1
booleanResetSwitchIsDown ds 1
booleanGameOver ds 1
booleanOverrideSelectChangeThisTime  ds 1



bufferPFLeft ds 1;;WALL;;
bufferPFRight ds 1;;WALL;;


playfieldMatrixLeft ds 22;;WALL;;
playfieldMatrixRight ds 22;;WALL;;

booleanFujiFrame ds 1


musicRiffNotePointer ds 2
musicRiffNoteCounter ds 1
musicRiffNoteTimeLeft ds 1

musicBeatNotePointer ds 2
musicBeatNoteCounter ds 1
musicBeatNoteTimeLeft ds 1




;for horiz pos...
;PlayerX ds 2
;!!!temp
PS_temp ds 1



ballXposition ds 2

booleanDisplayPterry ds 1
booleanSwitchP0AndPterry ds 1 
cacheRefP0 ds 1
cacheRefP1 ds 1

cacheSizingP0 ds 1
cacheSizingP1 ds 1


booleanPterryGoesRight ds 1

booleanPterryWingIsUp ds 1
counterPterryWingChange ds 1

bufferPterryGraphic ds 1

pterryHorizPosition ds 1

cachePterryReflection ds 1



tempVar ds 1


physicalPlayerHorizPos ds 1



 echo ($100 - *) , "bytes of RAM left"



	SEG CODE
	org $F000
;MAXIMUM_SPEED = #6

;--------------------------------------
;BOILER PLATE STARTUP
;--------------------------------------
Start
	sei	
	cld  	
	txs	
	ldx #$FF	
	lda #0		
ClearMem 
	sta 0,X		
	dex		
	bne ClearMem	
	lda #$00		
	sta COLUBK	

;--------------------------------------
;OTHER INITIALIZATIONS
;--------------------------------------


	lda #>Score0Graphic ;grab the hight byte of the graphic location for score graphics....
	sta pointerP0Score+1
	sta pointerP1Score+1



	lda #33	
	sta COLUP0	;Set P0 Reddish

	lda #66
	sta COLUP1	;Set P1 Purplish


	;lda #%11111111
	lda #0
	sta booleanGameIsTwoPlayers 


	lda #0
	sta booleanBallRight ;start ball moving right


	lda #BALLPOS_CENTER 
	sta pterryHorizPosition


	lda #%00100000 ;;WALL;;
	;;wALL;;
	ldx #GAMEFIELD_HEIGHT_IN_BRICKS-1;;WALL;;
InitTheBricks;;WALL;;
;every other	lda #%00100000 ;;WALL;;
;every other	sta playfieldMatrixLeft,X;;WALL;;
;every other	sta playfieldMatrixRight,X;;WALL;;
;every other	dex;;WALL;;
;every other	beq NoMoBricks
;every other	lda #%00000000 ;;WALL;;
	sta playfieldMatrixLeft,X;;WALL;;
	sta playfieldMatrixRight,X;;WALL;;
	dex;;WALL;;
;every other	NoMoBricks
	bne InitTheBricks;;WALL;;




;--------------------------------------
;START THE TITLE SCREEN
;--------------------------------------
TitleStart


;ok, now we're getting the usual 'just hit reset stuff'

	lda #$1F
	sta COLUPF  ;colored playfield for title


	lda #0
	sta CTRLPF	;playfield ain't reflected


	;sta AUDV0 
	;sta AUDV1 


	LDA #12
	STA AUDC0

	LDA #8;8
	STA AUDC1




;--------------------------------------
;OBJECT POSITIONING--VERY PRIMITIVE!
;--------------------------------------

;use NOPs to position the players
	lda #0
	sta WSYNC


	SLEEP 20 ;Thomas's Sleep Macro

	sta RESM0	
	sta RESP0


	SLEEP 37 ;Thomas's Sleep Macro


	
	sta RESP1 
	nop
	sta RESM1




;--------------------------------------
;--------------------------------------
; TITLE SCREEN
;--------------------------------------
;--------------------------------------


TitleMainLoop

	lda SWCHB 		;read console switches
	and #%00000001 		;is game reset?
	bne TitleResetWasNotHit ;(no, sjip next jump)
	jmp MainGameStart	;yes, go to start of game
TitleResetWasNotHit
	lda SWCHB			;read console switches again
	and #%00000010 			;is game select?
	bne TitleSelectIsNotDownNow	;(no, skip next jump)

;
; our key to only reacting to select once is to react when someone 
; lets go of it
; if its down we record that its down in booleanSelectSwitchIsDown
; if its up, we see if it was down last go around
TitleSelectIsDownNow
	lda #1				
	sta booleanSelectSwitchIsDown	;note in boolean (representing select switch STATE)
	jmp TitleDoneCheckingSelect	;we're done, since we're reacting to switch being released
TitleSelectIsNotDownNow
	lda booleanSelectSwitchIsDown 	;see if it was on before
	bne TitleSelectWasAlreadyOn	;if it's up now, but was down before, time to act...
TitleSelectWasNotOn 		
	jmp TitleDoneCheckingSelect	; it wasn't on, it's still not on, what are we worried about?
TitleSelectWasAlreadyOn 		; NOW: it was down, is now up, time to act...
	lda #0
	sta booleanSelectSwitchIsDown 	;record that it's up for future reference

	lda booleanOverrideSelectChangeThisTime 	;???
	bne OverridingSelectChange		

	lda booleanGameIsTwoPlayers 
	eor #%11111111 			;toggle the boolean for # of players
	sta booleanGameIsTwoPlayers 
	
	;;;;;;;DEC variableGameMode
	
	
	
OverridingSelectChange
	lda #0
	sta booleanOverrideSelectChangeThisTime 

TitleDoneCheckingSelect














;
;MUSIC!
;

	DEC musicRiffNoteTimeLeft
	BPL DoneWithChangingNote

	DEC musicRiffNoteCounter
	BPL DoneCheckResetNoteCounter

	LDA #MUSICRIFF_NOTECOUNT-1
	STA musicRiffNoteCounter

DoneCheckResetNoteCounter
	LDY musicRiffNoteCounter
	
	LDA MusicLengthData,Y
	STA musicRiffNoteTimeLeft
	DEC musicRiffNoteTimeLeft ;off by one error...
	
	LDA MusicPitchData,Y 
	
	BMI ZeroOutSound

	STA AUDF0
	LDA #8 ;noise
	STA AUDV0 
	JMP DoneSettingPitchAndVolume
ZeroOutSound	
	LDA #0	;silence
	STA AUDV0 

DoneSettingPitchAndVolume



DoneWithChangingNote



	DEC musicBeatNoteTimeLeft
	BPL DoneWithChangingBeat

	DEC musicBeatNoteCounter
	BPL DoneCheckResetBeatCounter

	LDA #MUSICBEAT_NOTECOUNT-1
	STA musicBeatNoteCounter

DoneCheckResetBeatCounter
	LDY musicBeatNoteCounter
	
	LDA BeatLengthData,Y
	STA musicBeatNoteTimeLeft
	
	DEC musicBeatNoteTimeLeft ;off by one error...
	
	LDA BeatPitchData,Y 
	
	BMI ZeroOutBeatSound

	STA AUDF1
	LDA #8 ;noise
	STA AUDV1
	JMP DoneSettingBeatPitchAndVolume
ZeroOutBeatSound	
	LDA #0 ;silence
	STA AUDV1

DoneSettingBeatPitchAndVolume



DoneWithChangingBeat
















;MainLoop starts with usual VBLANK code,
;and the usual timer seeding
	lda  #2
	sta  VSYNC	
	sta  WSYNC	
	sta  WSYNC 	
	sta  WSYNC	
	lda  #43	
	sta  TIM64T	
	lda #0		
	sta  VSYNC 	


;---------------------
;alternate the fuji logo for kicks
;---------------------
	lda booleanFujiFrame 
	beq FujiWasZeroInBlank
FujiWasNotZeroInBlank
	lda #0
	sta booleanFujiFrame 
	jmp DoneSettingFuji
FujiWasZeroInBlank
	lda #1
	sta booleanFujiFrame 
DoneSettingFuji




TitleWaitForVblankEnd	
	lda INTIM	
	bne TitleWaitForVblankEnd	
	sta VBLANK  	



;just burning scanlines....you could do something else
	ldy #20		;20 scanlines

;FIRST WE DO JOUST
TitlePreLoop
	sta WSYNC	;wait for sync for each one...
	dey
	bne TitlePreLoop


	lda #$1E
	sta COLUPF


	ldx #PIXEL_HEIGHT_OF_TITLE 	; X will hold what letter pixel we're on
	ldy #SCANLINES_PER_TITLE_PIXEL	; Y will hold which scan line we're on for each pixel
;
;the next part is careful cycle counting from those 
;who have gone before me to get full non-reflected playfield

TitleShowLoop
	sta WSYNC 	
	lda PFDataTitleJoust0Left-1,X           ;[0]+4
	sta PF0                 ;[4]+3 = *7*   < 23	;PF0 visible
	lda PFDataTitleJoust1Left-1,X           ;[7]+4
	sta PF1                 ;[11]+3 = *14*  < 29	;PF1 visible
	lda PFDataTitleJoust2Left-1,X           ;[14]+4
	sta PF2                 ;[18]+3 = *21*  < 40	;PF2 visible
	nop			;[21]+2
	nop			;[23]+2
	nop			;[25]+2
	;six cycles available  Might be able to do something here
	lda PFDataTitleJoust0Right-1,X          ;[27]+4
	;PF0 no longer visible, safe to rewrite
	sta PF0                 ;[31]+3 = *34* 
	lda PFDataTitleJoust1Right-1,X		;[34]+4
	;PF1 no longer visible, safe to rewrite
	sta PF1			;[38]+3 = *41*  
	lda PFDataTitleJoust2Right-1,X		;[41]+4
	;PF2 rewrite must begin at exactly cycle 45!!, no more, no less
	sta PF2			;[45]+2 = *47*  ; >

	dey ;ok, we've drawn one more scaneline for this 'pixel'
	bne NotChangingWhatTitlePixel ;go to not changing if we still have more to do for this pixel
	dex ; we *are* changing what title pixel we're on...

	beq DoneWithTitle ; ...unless we're done, of course
	
	ldy #SCANLINES_PER_TITLE_PIXEL ;...so load up Y with the count of how many scanlines for THIS pixel...
NotChangingWhatTitlePixel


	jmp TitleShowLoop

DoneWithTitle	
	nop
	nop
	nop

	lda #$7C
	sta COLUPF


	ldx #PIXEL_HEIGHT_OF_TITLE_PONG ; X will hold what letter pixel we're on
	ldy #SCANLINES_PER_TITLE_PIXEL ; Y will hold which scan line we're on for each pixel
;
;THEN WE DO PONG

PongTitleShowLoop
	sta WSYNC 	
	lda PFDataTitlePong0Left-1,X           ;[0]+4
	sta PF0                 ;[4]+3 = *7*   < 23	;PF0 visible
	lda PFDataTitlePong1Left-1,X           ;[7]+4
	sta PF1                 ;[11]+3 = *14*  < 29	;PF1 visible
	lda PFDataTitlePong2Left-1,X           ;[14]+4
	sta PF2                 ;[18]+3 = *21*  < 40	;PF2 visible
	nop			;[21]+2
	nop			;[23]+2
	nop			;[25]+2
	;six cycles available  Might be able to do something here
	lda PFDataTitlePong0Right-1,X          ;[27]+4
	;PF0 no longer visible, safe to rewrite
	sta PF0                 ;[31]+3 = *34* 
	lda PFDataTitlePong1Right-1,X		;[34]+4
	;PF1 no longer visible, safe to rewrite
	sta PF1			;[38]+3 = *41*  
	lda PFDataTitlePong2Right-1,X		;[41]+4
	;PF2 rewrite must begin at exactly cycle 45!!, no more, no less
	sta PF2			;[45]+2 = *47*  ; >



	dey ;ok, we've drawn one more scaneline for this 'pixel'
	bne NotChangingWhatPongTitlePixel ;go to not changing if we still have more to do for this pixel
	dex ; we *are* changing what title pixel we're on...

	beq DoneWithPongTitle ; ...unless we're done, of course
	
	ldy #SCANLINES_PER_TITLE_PIXEL ;...so load up Y with the count of how many scanlines for THIS pixel...
NotChangingWhatPongTitlePixel



;	stx tempVar 
;
;	lda #7
;	clc
;	cmp tempVar 
;	bcc DoneCheckingChangePFColor
;



	jmp PongTitleShowLoop



DoneWithPongTitle	

	;clear out the playfield registers for obvious reasons	
	lda #0
	sta PF2 ;clear out PF2 first, I found out through experience
	sta PF0
	sta PF1

;just burning scanlines....
	ldy #40     ;was 138
TitlePostLoop
	sta WSYNC
	dey
	bne TitlePostLoop


	;mirror player 1 who's on the right
	lda #%00001000
	sta REFP1


	ldy #8
TitlePlayerLoop
	sta WSYNC	
	
	lda WingUpGraphic-1,Y
	sta GRP0

	lda booleanGameIsTwoPlayers
	beq TitleDrawPlayer1ForTwoPlayers

	lda booleanFujiFrame 
	beq FujiWasZeroFrame

FujiWasNotZeroFrame
	lda FujiGraphic0-1,Y
	jmp TitleDoneChooseDrawPlayer1

FujiWasZeroFrame
	lda FujiGraphic1-1,Y
	jmp TitleDoneChooseDrawPlayer1

TitleDrawPlayer1ForTwoPlayers
	lda WingUpGraphic-1,Y
	
TitleDoneChooseDrawPlayer1
	sta GRP1

	dey
	
	sta WSYNC
	
	
	
	bne TitlePlayerLoop

	lda #0
	sta GRP0
	sta GRP1


;just burning scanlines....you could do something else
	ldy #44
TitlePostPostLoop
	sta WSYNC
	dey
	bne TitlePostPostLoop


; usual vblank
	lda #2		
	sta VBLANK 	
	ldx #30		
TitleOverScanWait
	sta WSYNC
	dex
	bne TitleOverScanWait
	jmp  TitleMainLoop      


;--------------------------------------
;--------------------------------------
; MAIN GAME
;--------------------------------------
;--------------------------------------

MainGameStart
	lda #%00010001
	sta CTRLPF 

	lda #44
	sta slowP0YCoordFromBottom + 1 	;44 in integer part of players position
	sta slowP1YCoordFromBottom + 1 	;('bout half way up)

	lda #0
	sta slowP0YCoordFromBottom ;0 in fractional part of players position
	sta slowP1YCoordFromBottom 

	;0 in all player's speed, integer and fractional

	sta slowP0YSpeed + 1
	sta slowP0YSpeed 	
	sta slowP1YSpeed + 1
	sta slowP1YSpeed 

	;zero out scores and game being over
	sta p0score
	sta p1score
	sta booleanGameOver
	

	lda #>GraphicsPage ;grab the high byte of the graphic location
	sta pointerP0Graphic+1	;2 byte memory lookup
	sta pointerP1Graphic+1	


	
;generate the background
;this is just one dot on the edge
;reflected. we'll use it for collision
;detection to know when a goal
;is scored

;--------------------------------------
;SETTING UP PLAYFIELD AND BALL ETC
;--------------------------------------
	lda #99
	sta COLUPF
	;color here
	

	lda #BALLPOS_CENTER
	sta ballXposition+1


	
	

	lda #1
	sta ballVertSpeed
	
	
;!!!position ball
	lda #41
	sta ballPosFromBot


;make missiles double wide
	lda #%00110000
	sta NUSIZ0 


;seed the sound buffers
	
	lda #TYPE_OF_FLAPSOUND
	sta AUDC0 ;type of sound 
	lda #PITCH_OF_FLAPSOUND
	sta AUDF0 ;pitch

	lda #4
	sta AUDC1 ;type of sound 







;--------------------------------------
;--------------------------------------
;START MAIN LOOP W/ VSYNC
;--------------------------------------
;--------------------------------------
MainLoop



	lda SWCHB
	and #%00000001 ;is game reset?
	bne ResetWasNotHit ;if so jump to MainGame
	jmp MainGameStart
ResetWasNotHit
	lda SWCHB
	and #%00000010 ;is game select hit?
	bne SelectWasNotHit ;if so jump to the title screen


	;hopefully these are the only initialzations we have to perform? 
	;might need to change logic if not...	
	lda #0
	sta CTRLPF	;playfield ain't reflected

	LDA #12
	STA AUDC0

	LDA #8;8
	STA AUDC1




	lda #1
	sta booleanOverrideSelectChangeThisTime 


	jmp TitleSelectIsDownNow
SelectWasNotHit







	lda  #2
	sta  VSYNC	
	sta  WSYNC	
	sta  WSYNC 	
	sta  WSYNC	
	lda  #43	
	sta  TIM64T	
	lda #0		
	sta  VSYNC 	


	sta AUDV1 ;volume for dinger










;
; for now assume wings are up
;






;--------------------------------------
;SEE IF BUTTON 0 IS NEWLY PRESSED
;--------------------------------------


CheckButton0
	lda INPT4
	bmi NoButton0


	;buttons down, graphic is down...
	lda #<WingDownGraphic-1 ;add in the low byte of the graphic location
	sta pointerP0Graphic


	;Check to see if the button was already down
	lda but0WasOn
	bne Button0WasAlreadyDown


	;this is a new button press...
	;time to flap!  do 16 bit math
	;to get integer and fractional speed
	clc
	lda slowP0YSpeed
	adc #SLOW_FLAP_LO_BYTE 
	sta slowP0YSpeed
	lda slowP0YSpeed+1            
	adc #SLOW_FLAP_HI_BYTE 
	sta slowP0YSpeed+1


	lda #1
	sta but0WasOn
	
	
	lda #LENGTH_OF_FLAPSOUND 
	sta flapsoundRemaining 




	
Button0WasAlreadyDown
	jmp EndButton0
NoButton0	;button wasn't pressed, remember that
	lda #0
	sta but0WasOn

	lda #<WingUpGraphic-1 ;add in the low byte of the graphic location	
	sta pointerP0Graphic
EndButton0


;--------------------------------------
;PLAYER 1  CONTROL, JOYSTICK OR AI?
;--------------------------------------

	lda booleanGameIsTwoPlayers
	bne Player1AI


;--------------------------------------
;SEE IF BUTTON 1 IS NEWLY PRESSED
;--------------------------------------


CheckButton1
	lda INPT5
	bmi NoButton1

	;buttons down, graphic is down...
	lda #<WingDownGraphic-1 ;add in the low byte of the graphic location
	sta pointerP1Graphic



	;Check to see if the button was already down
	lda but1WasOn
	bne Button1WasAlreadyDown

	;this is a new button press...
	;time to flap!  do 16 bit math
	;to get integer and fractional speed
	clc
	lda slowP1YSpeed
	adc #SLOW_FLAP_LO_BYTE ; HIGH BYTE OF 16-BIT Y MOVEMENT SPEED
	sta slowP1YSpeed
	lda slowP1YSpeed+1          
	adc #SLOW_FLAP_HI_BYTE 
	sta slowP1YSpeed+1
	
	lda #1
	sta but1WasOn
	
	
	lda #LENGTH_OF_FLAPSOUND 
	sta flapsoundRemaining 
		
	lda #<WingDownGraphic-1 ;add in the low byte of the graphic location
	sta pointerP1Graphic

	
Button1WasAlreadyDown
	jmp EndButton1
NoButton1	;button wasn't pressed, remember that
	lda #0
	sta but1WasOn
	
	lda #<WingUpGraphic-1 ;add in the low byte of the graphic location	
	sta pointerP1Graphic


EndButton1

	jmp AllDoneWithPlayer1


;--------------------------------------
;AI for Player 1
;--------------------------------------

Player1AI
;don't do anything if game is over
	lda booleanGameOver
	beq ContinueP1GameIsOn ;on your way 


	lda #0 ;don't let the guy flap up...
	sta but1WasOn ;needed to make wing up appear

	
	jmp DoneCheckingP1BeneathBall


ContinueP1GameIsOn

	lda #<WingUpGraphic-1 ;add in the low byte of the graphic location	
	sta pointerP1Graphic



;don't do anything if ball is heading away
	lda booleanBallRight
	beq DoneCheckingP1BeneathBall

;is p1 lower than the ball?
	lda slowP1YCoordFromBottom+1
	cmp ballPosFromBot
	bcs ResetP1WingGraphic
	;P1 is lower, give it a flap


	;time to flap!  do 16 bit math
	;to get integer and fractional speed
	clc
	lda slowP1YSpeed
	adc #FAST_FLAP_LO_BYTE ; HIGH BYTE OF 16-BIT Y MOVEMENT SPEED
	sta slowP1YSpeed
	lda slowP1YSpeed+1          
	adc #FAST_FLAP_HI_BYTE 
	sta slowP1YSpeed+1
	
	
	lda #1
	sta but1WasOn ;needed to make wing down appear

	lda #LENGTH_OF_FLAPSOUND 
	sta flapsoundRemaining 

	lda #<WingDownGraphic-1 ;add in the low byte of the graphic location	
	sta pointerP1Graphic



	jmp DoneCheckingP1BeneathBall
ResetP1WingGraphic
	lda #0
	sta but1WasOn ;needed to make wing up appear



DoneCheckingP1BeneathBall


AllDoneWithPlayer1






;SLOW....

;add in gravity constant to speed....16 bit math..

	clc
	lda slowP0YSpeed
	adc #SLOW_GRAV_LO_BYTE ; HIGH BYTE OF 16-BIT Y MOVEMENT SPEED
	sta slowP0YSpeed
	lda slowP0YSpeed+1          
	adc #SLOW_GRAV_HI_BYTE 
	sta slowP0YSpeed+1


;add speed to coordinate....

	clc
	lda slowP0YCoordFromBottom
	adc slowP0YSpeed        ; HIGH BYTE OF 16-BIT Y MOVEMENT SPEED
	sta slowP0YCoordFromBottom
	lda slowP0YCoordFromBottom+1          
	adc slowP0YSpeed+1
	sta slowP0YCoordFromBottom+1

;add in gravity constant to speed....16 bit math..

	clc
	lda slowP1YSpeed
	adc #SLOW_GRAV_LO_BYTE ; HIGH BYTE OF 16-BIT Y MOVEMENT SPEED
	sta slowP1YSpeed
	lda slowP1YSpeed+1
	adc #SLOW_GRAV_HI_BYTE 
	sta slowP1YSpeed+1


;add speed to coordinate....

	clc
	lda slowP1YCoordFromBottom
	adc slowP1YSpeed        ; HIGH BYTE OF 16-BIT Y MOVEMENT SPEED
	sta slowP1YCoordFromBottom
	lda slowP1YCoordFromBottom+1          
	adc slowP1YSpeed+1
	sta slowP1YCoordFromBottom+1









;--------------------------------------
;SEE IF BALL HIT PLAYER 0
;--------------------------------------
	lda #%01000000
	bit CXP0FB 		
	beq NoCollisionBallP0	;skip if not hitting...
;we have a hit
	lda #1
	sta booleanBallRight


;;!!!adjust ball vert speed w/ players speed
;	;lda slowP0YSpeed+1
;	;sta ballVertSpeed
;
;;!!!adjust the ball vertical speed; it's the difference of the 
;;ball from the center of the player
;
;	lda slowP0YCoordFromBottom+1
;	sec
;	sbc ballPosFromBot 
;	sec
;	sbc #3
;
;	;right shift (divide by 2)
;  	cmp #$80 ;preserves sign via carry...thanks Thomas
;  	ror
;	
;	sta ballVertSpeed
;	
	

;;;divide ball speed by 2 preserving sign
;;	LDA ballVertSpeed
;;	BPL slowingBallP0PosVal
;;slowingBallP0NegVal
;;	LSR
;;	ORA #%10000000
;;	JMP slowingBallP0Done
;;slowingBallP0PosVal
;;	LSR
;;slowingBallP0Done
;;	STA ballVertSpeed 
;;
	lda #PITCH_OF_PONGHIT
	sta AUDF1 ;pitch
	lda #VOLUME_OF_PONGHIT
	sta AUDV1 ;volume for dinger



NoCollisionBallP0





;--------------------------------------
;SEE IF BALL HIT PLAYER 1
;--------------------------------------
	lda #%01000000
	bit CXP1FB  		
	beq NoCollisionBallP1	;skip if not hitting...
;we have a hit

	lda #0
	sta booleanBallRight








;;adjust the ball vertical speed; it's the difference of the 
;;ball from the center of the player
;
;	lda slowP1YCoordFromBottom+1
;	sec
;	sbc ballPosFromBot 
;	sec
;	sbc #3
;
;	;right shift (divide by 2)
;  	cmp #$80 ;preserves sign via carry...thanks Thomas
;  	ror
;
;	sta ballVertSpeed
;	
;
;
;;
;;
;;;divide ball speed by 2 preserving sign
;;	LDA ballVertSpeed
;;	BPL slowingBallP1PosVal
;;slowingBallP1NegVal
;;	LSR
;;	ORA #%10000000
;;	JMP slowingBallP1Done
;;slowingBallP1PosVal
;;	LSR
;;slowingBallP1Done
;;	STA ballVertSpeed 
;;




	lda #PITCH_OF_PONGHIT
	sta AUDF1 ;pitch
	lda #VOLUME_OF_PONGHIT
	sta AUDV1 ;volume for dinger


NoCollisionBallP1





;--------------------------------------
;SEE IF BALL HIT A WALL
;--------------------------------------

	lda #%10000000
	bit CXBLPF 
	beq NoBallPlayfieldCollision


	lda #PITCH_OF_PONG_WALL_HIT
	sta AUDF1 ;pitch
	lda #VOLUME_OF_PONGHIT
	sta AUDV1 ;volume for dinger




	dec ballPosFromBot ;need to adjust, ball not quite aligned
	
	
	lda ballPosFromBot
	lsr
	lsr
	tay
	
	inc ballPosFromBot  ;undo previous adjustment


	lda #BALLPOS_CENTER
	clc
	cmp ballXposition+1
	bcc WallHitOnRight
WallHitOnLeft
	;if ball hits between bricks, higher brick is removed
	;however, if ball hit top of brick with blank space above,
	;this math was trying to remove the blank space!
	;so if the space is already blank, we Decrement Y and remove
	;the brick below

	lda playfieldMatrixLeft,Y
	bne noNeedToAdjustWallHitOnLeft
	DEY

noNeedToAdjustWallHitOnLeft

	lda #0;;WALL;;
	sta playfieldMatrixLeft,Y;;WALL;;
	
	lda #1
	sta booleanBallRight 

	jmp DoneWithWallHits

WallHitOnRight
	;if ball hits between bricks, higher brick is removed
	;however, if ball hit top of brick with blank space above,
	;this math was trying to remove the blank space!
	;so if the space is already blank, we Decrement Y and remove
	;the brick below

	lda playfieldMatrixRight,Y
	bne noNeedToAdjustWallHitOnRight
	DEY

noNeedToAdjustWallHitOnRight
	lda #0;;WALL;;
	sta playfieldMatrixRight,Y;;WALL;;

	lda #0
	sta booleanBallRight 


;	lda #PITCH_OF_GOAL
;	sta AUDF1 ;pitch
;	lda #VOLUME_OF_PONGHIT
;	sta AUDV1 ;volume for dinger

DoneWithWallHits





NoBallPlayfieldCollision





	sta CXCLR



;--------------------------------------
;SEE IF BALL GOT TO PLAYER GOAL
;--------------------------------------


	lda booleanGameOver
	bne DoneCheckingAllScores

	lda #BALLPOS_RIGHT
	cmp ballXposition+1
	bcs DoneCheckingP0Won

	;do dinger
	lda #PITCH_OF_GOAL
	sta AUDF1 ;pitch
	lda #VOLUME_OF_PONGHIT
	sta AUDV1 ;volume for dinger
	;reset ball
	lda #BALLPOS_CENTER
	sta ballXposition+1

	inc p0score
	
	lda #WINNING_SCORE-1
	cmp p0score
	bcs DoneCheckingP0Won




;game over man, game over
	
	lda #1
	sta booleanGameOver
	
DoneCheckingP0Won


	lda #BALLPOS_LEFT
	clc
	cmp ballXposition+1 
	bcc DoneCheckingP1Won


	;do dinger
	lda #PITCH_OF_GOAL
	sta AUDF1 ;pitch
	lda #VOLUME_OF_PONGHIT
	sta AUDV1 ;volume for dinger
	;reset ball
	lda #BALLPOS_CENTER
	sta ballXposition+1

	inc p1score


	lda #WINNING_SCORE-1
	cmp p1score
	bcs DoneCheckingP1Won

;game over man, game over
	
	lda #1
	sta booleanGameOver
	
DoneCheckingP1Won

DoneAddingToScore









DoneCheckingAllScores












;--------------------------------------
;ADJUST BALL VERTICAL POSITION
;--------------------------------------
;add negative of ball speed to ball to "0"
	lda #0
	sec
	sbc ballVertSpeed
;and add old psition to that
	clc
	adc ballPosFromBot
	sta ballPosFromBot



;--------------------------------------
;SEE IF BALL HIT FLOOR
;--------------------------------------

	lda #FLOOR_HEIGHT_FOR_BALL
	clc
	cmp ballPosFromBot
	bcc DoneCheckingHitFloorBall

;ball speed is negative of previous ball speed
	lda #0;
	sec
	sbc ballVertSpeed
	sta ballVertSpeed
;place ball on floor
	lda #FLOOR_HEIGHT_FOR_BALL ; floor for ball?
	sta ballPosFromBot
DoneCheckingHitFloorBall

;--------------------------------------
;SEE IF BALL HIT CEILING
;--------------------------------------


;check if player 0 hit ceiling - full rebound
	lda #CEILING_HEIGHT ;#was 180 before 2 line kernal
	cmp ballPosFromBot
	bcs DoneCheckingHitCeilingBall

;ball speed is negative of previous ball speed
	lda #0;
	sec
	sbc ballVertSpeed
	sta ballVertSpeed

;place ball on floor
	lda #CEILING_HEIGHT ;#was 180
	sta ballPosFromBot
DoneCheckingHitCeilingBall




;--------------------------------------
;ADD OR SUBTRACT FROM BALL HORIZONTAL POSITION
;--------------------------------------


	lda booleanBallRight
	beq adjustBallToLeft
adjustBallToRight
	clc
	lda ballXposition
	adc #SLOW_BALL_RIGHT_SPEED_LO_BYTE 
	sta ballXposition
	lda ballXposition+1            
	adc #SLOW_BALL_RIGHT_SPEED_HI_BYTE 
	sta ballXposition+1

	jmp doneAdjustingBallPosition
adjustBallToLeft	
	clc
	lda ballXposition
	adc #SLOW_BALL_LEFT_SPEED_LO_BYTE 
	sta ballXposition
	lda ballXposition+1            
	adc #SLOW_BALL_LEFT_SPEED_HI_BYTE 
	sta ballXposition+1
doneAdjustingBallPosition

;--------------------------------------
;SET BALL HORIZONTAL POSITION
;--------------------------------------

        sta HMCLR                       ; clear any previous movement 
        sta WSYNC 
        lda ballXposition+1
        tay 
        lsr    ; divide by 2 
        lsr    ; again 
        lsr    ; again 
        lsr    ; again 
        sta tempVar 
        tya 
        and #15 
        clc 
        adc tempVar 
        ldy tempVar 
        cmp #15 
        bcc NoBallHangover
        sbc #15 
        iny 
NoBallHangover
;do fine adjusment
        eor #7 
        asl 
        asl 
        asl 
        asl 
        sta HMBL
        sta WSYNC 
	SLEEP 15
DelayRoughPos  
	dey 
        bpl DelayRoughPos
        sta RESBL
;;;
;;; now, everything roughly positioned,
;;; apply the fine, fine movement...

        sta WSYNC 
        sta HMOVE 
        sta WSYNC 



























;--------------------------------------
;SEE IF PLAYER 0 HIT FLOOR 
;--------------------------------------

;check if player 0 hit floor
	lda #FLOOR_HEIGHT_FOR_PLAYERS	;10 is floor
	clc
	cmp slowP0YCoordFromBottom+1
	bcc DoneCheckingHitFloorP0


;cut downward speed by half and reverse it for nice rebound effect

;divide by 2, preserving negative
	lda slowP0YSpeed+1   ; HIGH byte!
	cmp #128
	ror slowP0YSpeed+1
	ror slowP0YSpeed    ; LOW byte!


;negate result
	sec
	lda #0
	sbc slowP0YSpeed
	sta slowP0YSpeed
	lda #0
	sbc slowP0YSpeed+1
	sta slowP0YSpeed+1



	lda #FLOOR_HEIGHT_FOR_PLAYERS
	sta slowP0YCoordFromBottom+1 ;putplayer on floor
DoneCheckingHitFloorP0


;--------------------------------------
;SEE IF PLAYER 1 HIT FLOOR 
;--------------------------------------

;check if player 1 hit floor
	lda #FLOOR_HEIGHT_FOR_PLAYERS	;10 is floor
	clc
	cmp slowP1YCoordFromBottom+1
	bcc DoneCheckingHitFloorP1


;cut downward speed by half and reverse it for nice rebound effect

;divide by 2, preserving negative
	lda slowP1YSpeed+1   ; HIGH byte!
	cmp #128
	ror slowP1YSpeed+1
	ror slowP1YSpeed    ; LOW byte!


;negate result
	sec
	lda #0
	sbc slowP1YSpeed
	sta slowP1YSpeed
	lda #0
	sbc slowP1YSpeed+1
	sta slowP1YSpeed+1


	lda #FLOOR_HEIGHT_FOR_PLAYERS
	sta slowP1YCoordFromBottom+1 ;putplayer on floor
DoneCheckingHitFloorP1




;--------------------------------------
;SEE IF PLAYER 0 HIT CEILING
;--------------------------------------

;check if player 0 hit ceiling - 
	lda #CEILING_HEIGHT 
	cmp slowP0YCoordFromBottom+1
	bcs DoneCheckingHitCeilingP0


	lda #SLOW_REBOUND_HI_BYTE
	sta slowP0YSpeed+1
	lda #SLOW_REBOUND_LO_BYTE
	sta slowP0YSpeed

	lda #CEILING_HEIGHT ;#was 180
	sta slowP0YCoordFromBottom+1

DoneCheckingHitCeilingP0

;--------------------------------------
;SEE IF PLAYER 1 HIT CEILING
;--------------------------------------

;check if player 1 hit ceiling - 
	lda #CEILING_HEIGHT 
	cmp slowP1YCoordFromBottom+1
	bcs DoneCheckingHitCeilingP1


	lda #SLOW_REBOUND_HI_BYTE
	sta slowP1YSpeed+1
	lda #SLOW_REBOUND_LO_BYTE
	sta slowP1YSpeed

	lda #CEILING_HEIGHT ;#was 180
	sta slowP1YCoordFromBottom+1

DoneCheckingHitCeilingP1




;--------------------------------------
;CALCULATE SCORE POINTERS
;--------------------------------------

;Erik Mooney 
;So, let's create a 16-bit value in memory that is the offset to the start
;of your digit.  After you've multiplied A by 5:
;Now we will create a 16-bit pointer in the memory location called
;TempPointer that points to your digit.  That odd-looking LDA means "load
;the high byte of the 16-bit hardcoded value Score0Graphic".  All of this
;you only need to do once, not for every line of the score.  From here it's
;simple:	




CheckIfWeDrawScoreP0
	lda booleanDisplayPterry 
	beq OkToDrawScoreP0
	lda booleanSwitchP0AndPterry
	beq OkToDrawScoreP0

	lda #<ScoreBlankGraphic-1 ;add in the low byte of the graphic location
	sta pointerP0Score
;	lda #>ScoreBlankGraphic ;grab the hight byte of the graphic location
;	sta pointerP0Score+1

	jmp CheckIfWeDrawScoreP1
OkToDrawScoreP0
	lda p0score ;accumulator = score
	asl ;accumulator = score * 2
	asl ;accumulator = score * 4
	adc p0score  ;accumulator = (score * 4) + score = score * 5
	adc #<Score0Graphic-1 ;add in the low byte of the graphic location
	sta pointerP0Score
;	lda #>Score0Graphic ;grab the hight byte of the graphic location
;	sta pointerP0Score+1

CheckIfWeDrawScoreP1
	lda booleanDisplayPterry 
	beq OkToDrawScoreP1
	lda booleanSwitchP0AndPterry
	bne OkToDrawScoreP1

	lda #<ScoreBlankGraphic-1 ;add in the low byte of the graphic location
	sta pointerP1Score
;	lda #>ScoreBlankGraphic ;grab the hight byte of the graphic location
;	sta pointerP1Score+1


	jmp DoneSeeingIfWeDrawScores
OkToDrawScoreP1
	lda p1score ;accumulator = score
	asl ;accumulator = score * 2
	asl ;accumulator = score * 4
	adc p1score  ;accumulator = (score * 4) + score = score * 5
	adc #<Score0Graphic-1 ;add in the low byte of the graphic location

	sta pointerP1Score
;	lda #>Score0Graphic ;grab the hight byte of the graphic location
;	sta pointerP1Score+1

DoneSeeingIfWeDrawScores





;--------------------------------------
;DIMINISH FLAP SOUND
;--------------------------------------

	lda flapsoundRemaining
	bmi NoFlapSound
	sta AUDV0 ;volume
	dec flapsoundRemaining
NoFlapSound







	
	ldx #22;;WALL;;
	lda playfieldMatrixLeft,X;;WALL;;
	sta bufferPFLeft;;WALL;;
	lda playfieldMatrixRight,X;;WALL;;
	sta bufferPFRight;;WALL;;






	lda slowP0YCoordFromBottom+1
	sta copyIntegerCoordP0

	lda slowP1YCoordFromBottom+1
	sta copyIntegerCoordP1



;------------------------------------
;PTERRY PTIME!!!
;------------------------------------

	lda booleanPterryGoesRight
	beq PterryMustBeGoingLeft



PterryMustBeGoingRight
	inc pterryHorizPosition 

	lda #PTERRY_RIGHT_BOUNDARY
	cmp pterryHorizPosition
	bcs DoneNotReboundOffRightBoundary

	lda #0
	sta booleanPterryGoesRight

DoneNotReboundOffRightBoundary	

	lda #%00000000

	sta cachePterryReflection
	jmp DoneMovingPterry




PterryMustBeGoingLeft
	dec pterryHorizPosition 


	lda #PTERRY_LEFT_BOUNDARY
	clc
	cmp pterryHorizPosition
	bcc DoneNotReboundOffLeftBoundary
	
	lda #1
	sta booleanPterryGoesRight

DoneNotReboundOffLeftBoundary
	lda #%00001000
	sta cachePterryReflection


DoneMovingPterry



	;make Pterry's wing flap....
	
	lda counterPterryWingChange

	bne NotTimeToChangePterryWing

	lda #PTERRY_LENGTH_OF_WINGCHANGE 
	sta counterPterryWingChange

	lda booleanPterryWingIsUp
	eor #%11111111
	sta booleanPterryWingIsUp

NotTimeToChangePterryWing
	dec counterPterryWingChange

	;assume 
	lda #<PterryWingDownGraphic-1
	sta bufferPterryGraphic

	lda booleanPterryWingIsUp
	beq DoneCheckingPterryWing

	lda #<PterryWingUpGraphic-1
	sta bufferPterryGraphic

DoneCheckingPterryWing

;booleanPterryWingIsUp ds 1
;counterPterryWingChange ds 1




	;start by assuming Physical P0 will be P0
	;and physical p1 will be p1....then override
	;those if one of 'em because pterry
	lda #11
	sta physicalPlayerHorizPos
	lda #140
	sta physicalPlayerHorizPos+1

	lda #%00000000
	sta cacheRefP0

	sta cacheSizingP0
	sta cacheSizingP1

	lda #%00001000
	sta cacheRefP1


	lda booleanDisplayPterry
	beq NotDisplayingPterryThisFrame



	lda booleanSwitchP0AndPterry
	beq SwappingP0ForPterry

	lda bufferPterryGraphic ; holds ptr to pterry graphiccurrent
	sta pointerP0Graphic


	lda #44
	sta copyIntegerCoordP0

	lda #%00000101
	sta cacheSizingP0



	lda cachePterryReflection
	sta cacheRefP0



	lda pterryHorizPosition 
	sta physicalPlayerHorizPos

	lda #0
	sta booleanSwitchP0AndPterry ;next time do P1 instead


	jmp DisplayingPterryNowNotLater
SwappingP0ForPterry
	lda bufferPterryGraphic ; holds ptr to pterry graphiccurrent
	sta pointerP1Graphic

	lda #44
	sta copyIntegerCoordP1



	lda #%00000101
	sta cacheSizingP1



	lda pterryHorizPosition 
	sta physicalPlayerHorizPos+1


	lda cachePterryReflection
	sta cacheRefP1


	lda #1
	sta booleanSwitchP0AndPterry ;next time do P0 instead


DisplayingPterryNowNotLater
	
	lda #0
	sta booleanDisplayPterry ;don't display pterry next time




	jmp DoneDecidingDisplayPterry
NotDisplayingPterryThisFrame
	lda #1
	sta booleanDisplayPterry ;display pterry next time

DoneDecidingDisplayPterry


















;----------------------
;precisely position physical players
;------------------------


	lda #1
	tax
SpritePositioningLoop
        sta HMCLR                       ; clear any previous movement 
        sta WSYNC 
        lda #physicalPlayerHorizPos,x
        tay 
        lsr    ; divide by 2 
        lsr    ; again 
        lsr    ; again 
        lsr    ; again 
        sta tempVar 
        tya 
        and #15 
        clc 
        adc tempVar 
        ldy tempVar 
        cmp #15 
        bcc NoPterryHangover
        sbc #15 
        iny 
NoPterryHangover
;do fine adjusment
        eor #7 
        asl 
        asl 
        asl 
        asl 
        sta HMP0,x
        sta WSYNC 
	SLEEP 15
DelayRoughPosPterry  
	dey 
        bpl DelayRoughPosPterry
        sta RESP0,x
;;;
;;; now, everything roughly positioned,
;;; apply the fine, fine movement...

        sta WSYNC 
        sta HMOVE 
        sta WSYNC 


	dex
	bpl SpritePositioningLoop








	;;!!!freezing player 0 in middle
	;lda #44
	;sta copyIntegerCoordP0



;--------------------------------------
;WAIT FOR VBLANK TO END
;--------------------------------------


WaitForVblankEnd
	lda INTIM	
	bne WaitForVblankEnd	

	sta VBLANK  	
	

	sta GRP0
	sta GRP1
	sta ENABL

	sta WSYNC	




waste	jmp kernal
	align 256


kernal


;	STA HMOVE 	

	;STA PF0

	


;--------------------------------------
;SCORE DISPLAY KERNAL
;--------------------------------------

	ldy #SCORE_KERNAL_LENGTH

	;make sure p1 isn't reversed
	lda #%00000000
	sta REFP1


	;make sure not double width
	lda #0
	sta NUSIZ0
	sta NUSIZ1




	sta WSYNC

	lda #$06
	sta COLUBK	



	sta WSYNC	


ScoreDisplayLoop

;!!!was overriding score display
	;lda slowP0YSpeed+1
	;lda PS_temp

	lda (pointerP0Score),Y
	sta GRP0

;	lda ballVertSpeed
	lda (pointerP1Score),Y
	sta GRP1

	dey		
	sta WSYNC
	sta WSYNC
	bne ScoreDisplayLoop	

	
	lda #0
	sta GRP0
	sta GRP1
	
	sta WSYNC
;	sta WSYNC
;	sta WSYNC

	;flip p1 before game kernal


;--------------------------------------------------
;AFTER SCORE KERNAL
;BEFORE GAME KERNAL
;---------------------------------------------------


	lda cacheRefP0
	sta REFP0
	lda cacheRefP1
	sta REFP1

	lda cacheSizingP0
	sta NUSIZ0

	lda cacheSizingP1
	sta NUSIZ1




	sta WSYNC




;--------------------------------------
;MAIN GAME KERNAL
;--------------------------------------

	ldx #GAME_KERNAL_LENGTH
;--------------------------------------
;MAIN SCANLINE LOOP
;--------------------------------------



MainGameLoop 
	sta WSYNC 	
	lda #$00
	sta COLUBK	


	lda bufferPFLeft ;get leftside of PF loaded;;WALL;;
	sta PF0;;WALL;;




	lda booleanGameOver
	bne DoneWithBall ;game is over, never draw ball

	lda ballBuffer 
	sta ENABL
DoneWithBall 

	lda p0DrawBuffer	
	sta GRP0		

	lda p1DrawBuffer	
	sta GRP1	

;--------------------------------------
;do buffer for P0
;--------------------------------------

	txa; transfer scanline count to A
 	sec
      	sbc copyIntegerCoordP0
	adc #SPRITEHEIGHT+1
	bcc skipDrawP0          ; out of range???
	tay
	lda (pointerP0Graphic),y
	sta p0DrawBuffer
skipDrawP0
	
	lda bufferPFRight ;left pf is drawn, ready for right;;WALL;;
	sta PF0;;WALL;;

;--------------------------------------
;do buffer for P1
;--------------------------------------
	txa; transfer scanline count to A
 	sec                     ; well for this example I don't know the state
      	sbc copyIntegerCoordP1           ; so that's 96 - 96 = 0
	adc #SPRITEHEIGHT+1 	; remember the sprite is 8 lines high
	bcc skipDrawP1           ; out of range???
	tay
	lda (pointerP1Graphic),y   ; use indirect loading here
	sta p1DrawBuffer
skipDrawP1


;--------------------------------------
;do buffer for Ball
;--------------------------------------
	ldy #0
	txa; transfer scanline count to A
 	sec                     ; well for this example I don't know the state
      	sbc ballPosFromBot           ; so that's 96 - 96 = 0
	adc #2
	lda bufferPFLeft;;WALL;;
	sta PF0;;WALL;;
	bcc skipDrawBall           ; out of range???
	tay
	ldy #2   ; use indirect loading here
skipDrawBall
	sty ballBuffer

	;txa
	;sta COLUPF


	SLEEP 6 ; was 8
	txa;;WALL;;
	lsr;;WALL;;
	lsr;;WALL;;
	tay;;WALL;;

	lda bufferPFRight;;WALL;;
	sta PF0	;;WALL;;
	

	lda playfieldMatrixLeft,Y;;WALL;;
	sta bufferPFLeft;;WALL;;
	lda playfieldMatrixRight,Y;;WALL;;
	sta bufferPFRight;;WALL;;



DoneChangingPlayfieldBrick;;WALL;;



	;SLEEP 41-43
	
;	SLEEP 60


;now just finish counting of scanloop
	dex		
	bne MainGameLoop	



	sta WSYNC  	
	lda #$06   ;grey for background...
	sta COLUBK	

	lda #0
	sta GRP0
	sta GRP1


	sta WSYNC  	


	lda #2		
	sta WSYNC  	
	sta VBLANK 	
endkernal
	ldx #30		

OverScanWait
	sta WSYNC
	dex
	bne OverScanWait

	
	sta PF0	


	lda #$00
	sta COLUBK	


	jmp MainLoop      
 
	org $FE00

;--------------------------------------
;GRAPHICS
;--------------------------------------
GraphicsPage
        .byte #%00000000 ;here to stop page errors




WingUpGraphic
        .byte #%00001100
        .byte #%00001100
        .byte #%10001100
        .byte #%11011100
        .byte #%11111100
        .byte #%01111100
        .byte #%00101100
        .byte #%00001100

        .byte #%00000000  ;here because my skipdraw's a bit off...

WingDownGraphic
        .byte #%00001100
        .byte #%00011100
        .byte #%00111100
        .byte #%01111100
        .byte #%01111100
        .byte #%00111100
        .byte #%00001100
        .byte #%00001100

        .byte #%00000000  ;here because my skipdraw's a bit off...


PterryWingUpGraphic
        .byte #%00000000
        .byte #%00000000
        .byte #%01111101
        .byte #%11111110
        .byte #%01110100
        .byte #%00111110
        .byte #%01110001
        .byte #%11100000

        .byte #%00000000  ;here because my skipdraw's a bit off...




PterryWingDownGraphic
        .byte #%11100000
        .byte #%01110000
        .byte #%00111000
        .byte #%01111100
        .byte #%11111111
        .byte #%01110100
        .byte #%00001111
        .byte #%00000000
        .byte #%00000000  ;here because my skipdraw's a bit off...




Score0Graphic
        .byte #%00111100
        .byte #%01000010
        .byte #%01000010
        .byte #%01000010
        .byte #%00111100
Score1Graphic
        .byte #%00111110
        .byte #%00001000
        .byte #%00001000
        .byte #%00101000
        .byte #%00011000
Score2Graphic
        .byte #%01111110
        .byte #%01100000
        .byte #%00011100
        .byte #%01000010
        .byte #%00111100
Score3Graphic
        .byte #%01111100
        .byte #%00000010
        .byte #%00011100
        .byte #%00000010
        .byte #%01111100
Score4Graphic
        .byte #%00000100
        .byte #%00000100
        .byte #%01111110
        .byte #%01000100
        .byte #%01000100
Score5Graphic
        .byte #%01111100
        .byte #%00000010
        .byte #%01111100
        .byte #%01000000
        .byte #%01111110
Score6Graphic
        .byte #%00111100
        .byte #%01000010
        .byte #%01111100
        .byte #%01100000
        .byte #%00011110
Score7Graphic
        .byte #%00010000
        .byte #%00001000
        .byte #%00000100
        .byte #%00000010
        .byte #%01111110
Score8Graphic
        .byte #%00111100
        .byte #%01000010
        .byte #%00111100
        .byte #%01000010
        .byte #%00111100
Score9Graphic
        .byte #%00000010
        .byte #%00000010
        .byte #%00011110
        .byte #%00100010
        .byte #%00011100
ScoreWGraphic
        .byte #%01000100
        .byte #%10101010
        .byte #%10010010
        .byte #%10000010
        .byte #%00000000

ScoreBlankGraphic
        .byte #0
        .byte #0
        .byte #0
        .byte #0
        .byte #0






PFDataTitlePong0Left
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
PFDataTitleJoust0Left
        .byte #%00000000
        .byte #%10000000
        .byte #%11000000
        .byte #%11000000
        .byte #%11000000
        .byte #%11100000
        .byte #%01100000
        .byte #%01100000
        .byte #%01100000
        .byte #%01000000
        .byte #%01000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000

PFDataTitlePong1Left
        .byte #%00000000
        .byte #%00000011
        .byte #%00000011
        .byte #%11110011
        .byte #%00111011
        .byte #%11110011
        .byte #%11110000
PFDataTitleJoust1Left
        .byte #%00000001
        .byte #%11000001
        .byte #%11100011
        .byte #%11100011
        .byte #%11100011
        .byte #%11100110
        .byte #%01110110
        .byte #%00110110
        .byte #%00110110
        .byte #%00110110
        .byte #%00110100
        .byte #%00110100
        .byte #%00110100
        .byte #%00110100
        .byte #%00110100
        .byte #%00110100
        .byte #%00110110
        .byte #%00110110
        .byte #%00110110
        .byte #%00110110
        .byte #%10110110
        .byte #%01110010
        .byte #%00110011
        .byte #%00010011
        .byte #%00000011
        .byte #%00000001
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000

PFDataTitlePong2Left
        .byte #%00011111
        .byte #%01111111
        .byte #%01110001
        .byte #%01110001
        .byte #%01110001
        .byte #%01111111
        .byte #%00011111
PFDataTitleJoust2Left
        .byte #%00000001
        .byte #%11000001
        .byte #%11000011
        .byte #%11000011
        .byte #%11100111
        .byte #%11100110
        .byte #%11100110
        .byte #%11100110
        .byte #%01110110
        .byte #%01110100
        .byte #%01110100
        .byte #%00110100
        .byte #%00110100
        .byte #%00110100
        .byte #%00110100
        .byte #%00110100
        .byte #%00110100
        .byte #%00110110
        .byte #%00100110
        .byte #%00100110
        .byte #%00100110
        .byte #%01100110
        .byte #%01100111
        .byte #%01000011
        .byte #%01010011
        .byte #%01010001
        .byte #%01010000
        .byte #%10110000
        .byte #%10100000
        .byte #%11000000















PFDataTitlePong0Right
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
        .byte #%11100000
PFDataTitleJoust0Right
        .byte #%00000000
        .byte #%10110000
        .byte #%10110000
        .byte #%11110000
        .byte #%11110000
        .byte #%11110000
        .byte #%11110000
        .byte #%11100000
        .byte #%11000000
        .byte #%11000000
        .byte #%11000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000
        .byte #%10000000

PFDataTitlePong1Right
        .byte #%00111100
        .byte #%00111100
        .byte #%01111101
        .byte #%11111101
        .byte #%11011101
        .byte #%10011100
        .byte #%00011100
PFDataTitleJoust1Right
        .byte #%00000100
        .byte #%10001110
        .byte #%10111110
        .byte #%10111110
        .byte #%10111111
        .byte #%10111111
        .byte #%10111111
        .byte #%10110011
        .byte #%10110001
        .byte #%10100011
        .byte #%10100010
        .byte #%10100010
        .byte #%10000110
        .byte #%10000110
        .byte #%10001100
        .byte #%10011100
        .byte #%10011000
        .byte #%10111000
        .byte #%10110000
        .byte #%10110000
        .byte #%10110010
        .byte #%10110010
        .byte #%10100110
        .byte #%10111110
        .byte #%10111100
        .byte #%11011100
        .byte #%11010000
        .byte #%11000000
        .byte #%10000000
        .byte #%00000000

PFDataTitlePong2Right
        .byte #%01111110
        .byte #%11111111
        .byte #%11000011
        .byte #%11110011
        .byte #%00000011
        .byte #%11111111
        .byte #%01111110
PFDataTitleJoust2Right
        .byte #%00011000
        .byte #%01111100
        .byte #%01111110
        .byte #%01111110
        .byte #%01001110
        .byte #%00001110
        .byte #%00001110
        .byte #%00000110
        .byte #%00000110
        .byte #%00000110
        .byte #%00000110
        .byte #%00000110
        .byte #%00001110
        .byte #%00001100
        .byte #%00001100
        .byte #%00001100
        .byte #%00001100
        .byte #%00011000
        .byte #%00011001
        .byte #%11111011
        .byte #%01111111
        .byte #%00111111
        .byte #%00100111
        .byte #%01000000
        .byte #%01000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000







FujiGraphic0

        .byte #%00000000
        .byte #%10011001
        .byte #%01011010
        .byte #%00111100
        .byte #%00111100
        .byte #%00111100
        .byte #%00111100
        .byte #%00000000


        .byte #%00000000
        .byte #%10011001
        .byte #%11011011
        .byte #%01111110
        .byte #%00111100
        .byte #%00111100
        .byte #%00111100
        .byte #%00000000

        
;        .byte #%00000000
;        .byte #%10000010
;        .byte #%01000100
;        .byte #%00101000
;        .byte #%00101000
;        .byte #%00101000
;        .byte #%00101000
;        .byte #%00000000

FujiGraphic1
        .byte #%00000000
        .byte #%00011000
        .byte #%00011000
        .byte #%00011000
        .byte #%00011000
        .byte #%00011000
        .byte #%00011000
        .byte #%00000000

;        .byte #%00000000
;        .byte #%00010000
;        .byte #%00010000
;        .byte #%00010000
;        .byte #%00010000
;        .byte #%00010000
;        .byte #%00010000
;        .byte #%00000000




MusicPitchData
	.byte #-1
	.byte #17
	.byte #-1
	.byte #17
	.byte #-1
	.byte #16
	.byte #-1
	.byte #16
	.byte #-1
	.byte #15
	.byte #-1
	.byte #15
	.byte #-1
	.byte #18
	.byte #-1
	.byte #18

MusicLengthData
	.byte #40
	.byte #20
	.byte #10
	.byte #26
	.byte #40
	.byte #20
	.byte #10
	.byte #26
	.byte #40
	.byte #20
	.byte #10
	.byte #26
	.byte #40
	.byte #20
	.byte #10
	.byte #26





BeatPitchData
	.byte #-1
	.byte #120
	.byte #-1
	.byte #40
	.byte #-1
	.byte #120
	.byte #-1
	.byte #120
	.byte #-1
	.byte #40
	.byte #-1
	.byte #120
	
BeatLengthData
	.byte #16
	.byte #2
	.byte #4
	.byte #2
	.byte #10
	.byte #2
	.byte #22
	.byte #2
	.byte #10
	.byte #2
	.byte #22
	.byte #2








	org $FFFC
	.word Start
	.word Start


;;;;THE JUNKYARD
;;See if we're going too darn fast
;	LDA MaximumSpeed
;	SEC
;	;;;;SBC MaximumSpeed ; Maximum Speed
;
;	CMP p0VertSpeed
;	BCS SpeedNotMaxxed
;
;
;;	BMI SpeedNotMaxxed ;if speed - maxspeed is positive, we need to slow down
;	LDA MaximumSpeed
;	STA p0VertSpeed
;
;SpeedNotMaxxed











;;assum horiz movement will be zero
;	LDX #$00	
;	LDA #$40	;Left?
;	BIT SWCHA 
;	BNE SkipMoveLeftP0
;	LDX #$10	
;	LDA #%00001000
;	STA REFP0	;show reflected version
;SkipMoveLeftP0
;
;	LDA #$80	;Right?
;	BIT SWCHA 
;	BNE SkipMoveRightP0
;	LDX #$F0	
;	LDA %00000000
;	STA REFP0
;SkipMoveRightP0
;
;	STX HMP0	;set horiz movement for player 0
;
;
;;assum horiz movement will be zero
;	LDX #$00	
;	LDA #$04	;Left?
;	BIT SWCHA 
;	BNE SkipMoveLeftP1
;	LDX #$10	
;	LDA #%00001000
;	STA REFP1
;SkipMoveLeftP1
;
;	LDA #$08	;Right?
;	BIT SWCHA 
;	BNE SkipMoveRightP1
;	LDX #$F0	
;	LDA %00000000
;	STA REFP1
;SkipMoveRightP1
;
;	STX HMP1	;set horiz movement for player 0



;BigHeadGraphic
;	.byte %00111100
;	.byte %01111110
;	.byte %11000001
;	.byte %10111111
;	.byte %11111111
;	.byte %11101011
;	.byte %01111110
;	.byte %00111100

	echo "Kernal alignment wastes",(kernal - waste),"bytes"


	if (>kernal != >endkernal)
	  echo "WARNING: Kernel crosses a page boundary!"
	endif

