	processor 6502
	include vcs.h
	include macro.h
	
;SpaceBattles	
;by Dave Neuman
;6/29/2005
;option 1 standard play
;option 2 moveable laser shot
;Created from tutorials found on AtariAge and the Stella list
;---------------------------------------------------------------------------------------------------
;variables....

	SEG.U VARS
	ORG $80

;Player0 (7)
P0_YPosFromBot ds 1	;vertical position
P0_XPos ds 1		;horizontal position
P0_Y ds 1		;needed for skipdraw
P0_Ptr ds 2		;ptr to current graphic
Lives_Remaining ds 1	;how many lives do we have remaining?
Shields_Up ds 1		;Shields are up

;Enemy (49)
Enemy_YPosFromBot ds 1	;vertical position
Enemy_XPos ds 8		;horizontal positions
Enemy_Y ds 1		;needed for skipdraw
Enemy_Ptr ds 16		;ptr to current graphic
Enemy_YPos ds 1		;vertical positions of enemies
Enemy_Index ds 1	;speed of enemy movement
Enemies_Remaining ds 8	;how many enemies do we have remaining?
Last_Enemy ds 1		;is it the last enemy?
Enemy_Hits ds 1		;how many hits on anemies
Enemy_Copy_Hit ds 1	;which enemy copy was hit?
Enemy_Move_Ptr ds 2	;which enemy movement to use
Enemy_Destroyed ds 8    ;offset for destroyed enemy
	

;Index Counters and Timers (9)
Frame_Counter ds 1	;frame counter
Movement_Index ds 1 	;index for enemy movements 
Damage_Index ds 1	;which enemy is damaged?
Destroyed_Index ds 1	;which enemy is destroyed?
Change_Index ds 1	;which enemy to Change?
Enemy_Explode_Timer ds 1;enemy explosion timer
Delay_Timer ds 1	;general purpose timer
Delay_Switch ds 1       ;timer for switch debounce
Blank_Timer ds 1	;number of frames to blank display max 255

;Score and Temp(21)
Temp_Score_Ptr ds 12	;score pointer to current graphic
Score ds 3		;holds three bytes of score for BCD conversion
Level ds 1		;what level are we on?
TmpVar ds 1		;used by 6 digit BCD conversion and display, enemy position and damage BITs
TmpVar2 ds 1		;used by 6 digit score display and screen blank routine
TmpVar3 ds 1		;used in enemy display routine
TmpVar4 ds 1		;used in enemy change routine
TmpVar5 ds 1		;used in enemy change routine
TmpVar6 ds 1

;Missiles and Bombs(9)
Missile_Enable ds 1	;which missile band should be enabled?
Missile_Pos ds 1 	;vertical position of missile in band
Missile_YPos ds 1	;overall missile vertical position
Missile_XPos ds 1	;missile horizontal position when fired
Bomb_Enable ds 1	;which bomb band should be enabled?
Bomb_YPos ds 1 		;vertical position
Base_Hit ds 1		;is base hit?	
Bomb_Color ds 1		;bomb or fuel pod?
Bomb_Band ds 1		;which band to drop bomb from

;Sound (12)
Sound_Pointer ds 4	;pointer to sound byte
Sound_Type ds 2		;type of sound
Notes_Played ds 2	;which note are we playing?
Note_Counter ds 2 	;note beat counter
Note_Sustain ds 2	;how long to hold note
;---------------------------------------------------------------------------------------------------

;Pointer 0 sounds
;Opening Sound
;Laser Fire Sound
;Low Fuel Warning Sound	
;Exploding Enemy Sound	
;Exploding Base Sound	

;Pointer 2 sounds
;Opening Sound
;Bomb Dropping Sound
;Bomb Hittting Ground Sound
;Bomb Deflecting from Shield Sound
;Shields Up Sound
;Catch Fuel Pod Sound	
;Level Complete Sound

;---------------------------------------------------------------------------------------------------

;Fuel Bar (10)
FuelBar ds 6		;Fuel indicator (6 bytes)
Fuel_Level ds 1
Fuel_Decrease ds 1
Fuel_Color ds 1
Fuel_Gone ds 1	

;Misc (2)
Screen_Select ds 1	;screen to display
Game_Selected ds 1	;game option selected

;Total Ram Usage
;119 of 128-stack

	SEG CODE
	org $F000
	
;---------------------------------------------------------------------------------------------------
;CONSTANTS...

BLACK =         $00 ;0 
GREY =   	$06 ;6 0110
LTGREY =	$0C ;12 1100
SILVER =      	$0F ;15
YELLOW =	$1E ;30
DARKORANGE =	$32
ORANGE =     	$38 ;56
RED =  		$40 ;64
PINK =		$48
PURPLE =      	$54 ;84
DARKBLUE =      $71 ;113
MEDBLUE =      	$86 ;134 
LTBLUE =        $AC ;172
DARKGREEN =     $C4 ;196
MEDGREEN =      $D6 ;214
LTGREEN =       $DF ;223
BROWN =  	$F4 ;244
TAN =   	$FD ;253
         
  
C_P0_HEIGHT = 10		;height of player 0 sprite was 7
	
C_Enemy_HEIGHT = 12		;height of player 1 sprite	

C_ENEMY_KERNAL_HEIGHT = 14	;height of enemy kernal 

C_PO_KERNAL_HEIGHT = 25;26;33;26	;height of base kernal

C_LEFT_BOUND_ENEMY = 25		;left boundary for graphics (4 min no wrap) artifact at

C_RIGHT_BOUND_ENEMY = 115 	;right boundary for graphics (160-36) max before wrap at 3 copies

C_LEFT_BOUND_BASE = 19		;left boundary for graphics 

C_RIGHT_BOUND_BASE = 147  	;right boundary for graphics

C_SCORE_HEIGHT = 5		;height of score sprite	

C_TITLE_HEIGHT = 11		;height of title	

C_TITLE_LINES = 10		;number of lines in title

C_MISSILE_BOTTOM = 12		;missile start position bottom

C_MISSILE_BANDS = 6		;missile start position for bands

C_MISSILE_LENGTH = 5		;length of missile

C_BOMB_HEIGHT = 27;35;28		;vertical start position bottom

C_BOMB_BANDS = 16		;vertical start position for bands

C_BOMB_LENGTH = 4		;length of bomb

C_BOMB_BOTTOM = 7		;ending position of bomb in bottom band

C_SCORE_XPOS_P1 = 127		;score horizontal position

C_NOTE_COUNT = 15		;actually 16 notes (0-15)

C_FUEL_START = 36		;Starting fuel level

C_FUEL_RATE = 65		;Fuel decrease delay (in frames) - The lower, the faster

C_FUEL_OK = DARKGREEN

C_FUEL_LOW = YELLOW

C_FUEL_GONE = RED

C_BOMB_COLOR = RED

C_FUEL_POD_COLOR = DARKGREEN
;---------------------------------------------------------------------------------------------------

DigitTab:
	.byte <Digit0tab
	.byte <Digit1tab
	.byte <Digit2tab
	.byte <Digit3tab
	.byte <Digit4tab
	.byte <Digit5tab
	.byte <Digit6tab
	.byte <Digit7tab
	.byte <Digit8tab
	.byte <Digit9tab
     
;each digit is using 5 lines each...many of the bytes shared with other digits.
;For a set of 10 BITmaps of 5 bytes each, that would normally take 50 bytes of graphics data.
;The table below is only 24 bytes. In order for the program to know which lines are 
;for each digit, you create a lookup table that holds the addresses of each of those BITmaps: 

Digit1tab:
      	.byte $06; |     XX |
Digit7tab:
      	.byte $06; |     XX |(shared)
Digit4tab:
      	.byte $06; |     XX |(shared)x3
Digit9tab:
      	.byte $06; |     XX |(shared)x4
      	.byte $06; |     XX |(shared)x4
Digit6tab:
      	.byte $3E; |  XXXXX |(shared)x4
      	.byte $26; |  X  XX |(shared)x3
Digit2tab:
      	.byte $3E; |  XXXXX |(shared)x3
      	.byte $20; |  X     |(shared)
Digit3tab:
      	.byte $3E; |  XXXXX |(shared)x3
      	.byte $06; |     XX |(shared)
Digit5tab:
      	.byte $3E; |  XXXXX |(shared)x3
      	.byte $06; |     XX |(shared)
      	.byte $3E; |  XXXXX |(shared)
      	.byte $20; |  X     |
Digit8tab:
      	.byte $3E; |  XXXXX |(shared)
      	.byte $26; |  X  XX |
      	.byte $3E; |  XXXXX |
      	.byte $26; |  X  XX |
Digit0tab:
      	.byte $3E; |  XXXXX |(shared)
      	.byte $26; |  X  XX |
      	.byte $26; |  X  XX |
      	.byte $26; |  X  XX |
      	.byte $3E; |  XXXXX |
Text0tab:;CA
	.byte #%11101010
	.byte #%10001110
	.byte #%10001010
	.byte #%10001110
	.byte #%11100100
Text1tab:;TC
	.byte #%01001110
	.byte #%01001000
	.byte #%01001000
	.byte #%01001000
	.byte #%11101110
Text2tab:;H
	.byte #%10100000
	.byte #%10100000
	.byte #%11100000
	.byte #%10100000
	.byte #%10100000
Text3tab:;FU
	.byte #%10001110
	.byte #%10001010
	.byte #%11001010
	.byte #%10001010
	.byte #%11101010
Text4tab:;EL
 	.byte #%11101110
        .byte #%10001000
        .byte #%11001000
        .byte #%10001000
        .byte #%11101000
Text5tab:;LE
	.byte #%11101110
	.byte #%10001000
	.byte #%10001100
	.byte #%10001000
	.byte #%10001110
Text6tab:;VE
	.byte #%00100111
	.byte #%01010100
	.byte #%01010110
	.byte #%01010100
	.byte #%01010111
Text7tab:;M
	.byte #%01000101
	.byte #%01000101
	.byte #%01010101
	.byte #%01010101
	.byte #%01101100
Text8tab:;L
	.byte #%01110000
	.byte #%01000000
	.byte #%01000000
	.byte #%01000000
	.byte #%01000000
Text9tab:;GA	
	.byte #%11110101
	.byte #%10010101
	.byte #%10110111
	.byte #%10000101
	.byte #%11110111
Text10tab:;EO	
	.byte #%11000111
	.byte #%00000101
	.byte #%10000101
	.byte #%00000101
	.byte #%11000111
Text11tab:;R	
	.byte #%01010000
	.byte #%01100000
	.byte #%01110000
	.byte #%01010000
	.byte #%01110000
Text12tab:;Blank	
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
Text13tab:;PT	
	.byte #%01000010
	.byte #%01000010
	.byte #%01110010
	.byte #%01010010
	.byte #%01110111
Text14tab:;DA
	.byte #%01100101
	.byte #%01010111
	.byte #%01010101
	.byte #%01010101
	.byte #%01100010
Text15tab:;N
	.byte #%00001001
	.byte #%00001011
	.byte #%00001111
	.byte #%00001101
	.byte #%00001001
Text16tab:;EU	
	.byte #%01110111
	.byte #%01000101
	.byte #%01100101
	.byte #%01000101
	.byte #%01110101
Text17tab:;M
	.byte #%01000101
	.byte #%01000101
	.byte #%01010101
	.byte #%01010101
	.byte #%01101100
Text18tab:;AN
	.byte #%01010010
	.byte #%11010110
	.byte #%01011110
	.byte #%01011010
	.byte #%10010010
Text19tab:;(C	
	.byte #%01000110
	.byte #%10001000
	.byte #%10001000
	.byte #%10001000
	.byte #%01000110
Text20tab:;)	
	.byte #%01000000
	.byte #%00100000
	.byte #%00100000
	.byte #%00100000
	.byte #%01000000
	
;---------------------------------------------------------------------------------------------------
;8 bytes
ColorTab:
	.byte	YELLOW
	.byte	DARKORANGE
	.byte   ORANGE
	.byte   PURPLE
	.byte   DARKBLUE
	.byte   MEDBLUE
	.byte   DARKGREEN
	.byte   SILVER

;---------------------------------------------------------------------------------------------------
;First byte stores hidden enemy nusiz value must trigger BMI to work with other code 
; 
EnemyNusiz
	.byte $C0, $0,  $0,  $1
        .byte $C0, $0,  $C0, $2
        .byte $C0, $C0, $0,  $1
EnemyShift
	.byte $0,  $10, $20, $10
        .byte $FF, $0,  $FF, $0
        .byte $FF, $FF, $0,  $0

DeadEnemyShift
	.byte $0, $-16, $-32, $-16
	.byte $FF, $10, $FF, $10
        .byte $FF, $FF,	$20, $20
        
;---------------------------------------------------------------------------------------------------
	
Start
	
	CLEAN_START
	
	JSR GameInit
	JSR Initialize_Fuel
	
MainLoop
	JSR VerticalBlank
	JSR GameCalc
	JSR WaitVblank
	JSR ScreenSelector
	JSR OverScan
	JMP MainLoop

;---------------------------------------------------------------------------------------------------
	
GameInit SUBROUTINE

	
	LDX #11			;9
	STX P0_YPosFromBot	;initial Y position
			
	LDX #70
	STX P0_XPos 		;initial X position
		
;initial X position Spider,Capsule,UFO,Teepee,Robot,Frog,Pacman,Smiley	
;initial Y position 	
	
	ldx #7			;Thomas Jentzsch
.loopXPos
	lda   XPosTable,x
	sta   Enemy_XPos,x
	dex
	bpl   .loopXPos
	sta   Enemy_YPosFromBot

		
	ldx #15			;Thomas Jentzsch
.loopSprite
	lda   #>Sprite_Data0
	sta   Enemy_Ptr,x
	dex
	dex
	bpl   .loopSprite
		
			
	LDX #>Sprite_Destroyed 	;high byte of graphic location
	STX P0_Ptr+1		;store in high byte of graphic pointer
		
	LDX #>MoveTab	 	;high byte of movement location
	STX Enemy_Move_Ptr+1	;store in high byte of movement pointer
		
	LDX #>GameSounds	;high byte of sound pointer
	STX Sound_Pointer+1	;store in high byte of sound pointer
	
	LDX #>GameSounds	;high byte of sound pointer
	STX Sound_Pointer+3	;store in high byte of sound pointer
		
	LDX #%00000001
	STX Game_Selected
	
	JSR GameReset
	
;Opening Sound

	LDA #<Sprite_Destroyed	;low byte of sound pointer
	STA Sound_Pointer	;store in low byte of sound pointer
	LDA #25
	STA Notes_Played
	LDA #12
	STA Sound_Type
	LDA #4
	STA Note_Sustain 
	
	LDA #<Sprite_Data7	;low byte of sound pointer
	STA Sound_Pointer+2	;store in low byte of sound pointer
	LDA #25	
	STA Notes_Played+1
	LDA #10
	STA Sound_Type+1
	LDA #4
	STA Note_Sustain+1 
	
;---------------------------------------------------------------------------------------------------

VerticalBlank SUBROUTINE
	
	VERTICAL_SYNC
	LDA #43
	STA TIM64T
	RTS
	
;---------------------------------------------------------------------------------------------------

ScreenSelector SUBROUTINE

	LDA Screen_Select
	
	CMP #1
	BEQ .AttractScreen
	
	CMP #2
	BEQ .MainScreen
		
	CMP #3
	BEQ .LevelScreen
		
	CMP #4
	BEQ .FinishScreen

.AttractScreen
	JMP AttractScreen	
	
.MainScreen
	JMP MainScreen
	
.LevelScreen
	LDA Blank_Timer		;flag/timer for screen blank
	BEQ .EndLevelBlank	;branch after Blank_Timer been reset to zero in BlankScreen
	JMP BlankScreen
	
.EndLevelBlank	
	JMP LevelScreen
	
.FinishScreen
	JMP MainScreen
	
	RTS

;---------------------------------------------------------------------------------------------------

GameReset SUBROUTINE
;reset all variables to initial values
	
	LDX #0
	STX AUDV0		
	STX AUDV1
	STX COLUBK 
	STX Change_Index	 
	STX Damage_Index
	STX Destroyed_Index
	STX CTRLPF
	STX Enemy_Hits
	LDX #31
	STX Enemy_YPosFromBot	;initial Y position 
	STX Enemy_Explode_Timer
	LDX #C_BOMB_HEIGHT	;vertical start position of bomb
	STX Bomb_YPos	
	LDX #9
	STX Bomb_Enable		;reset 
	LDX #4
	STX Enemy_Index
	
	LDX #3
	STX Lives_Remaining
	LDY #7
ResetEnemies	
	STX Enemies_Remaining,Y
	DEY
	BPL ResetEnemies	

	JSR Initialize_Fuel
	
	RTS
	
;---------------------------------------------------------------------------------------------------

ResetScore SUBROUTINE
	
	LDX #2
.ResetScore
	LDA #0    
	STA Score,X
	DEX
	BNE .ResetScore
	
	RTS
;---------------------------------------------------------------------------------------------------

GameCalc SUBROUTINE	

	LDA Shields_Up
	BEQ .YELLOW
	CMP #2
	BCC .TAN
	CMP #4
	BCC .ORANGE
	CMP #6
	BCC .DARKORANGE
	CMP #8
	BCC .RED
	CMP #11
	BCC .OVERHEAT
	
		
.TAN	
	LDX #TAN
	.byte $2c 
.ORANGE	
	LDX #ORANGE
	.byte $2c 
.DARKORANGE	
	LDX #DARKORANGE 		
	.byte $2c  
.RED	
	LDX #RED 		
	.byte $2c  
.OVERHEAT
	LDX #SILVER
	.byte $2c  
.YELLOW	
	LDX #YELLOW	
	STX COLUP0 
	STX COLUP1 
	
	LDX #2			;1 in D1 that sets RESMP0
	LDA Game_Selected
	CMP #%00000010		;option 2 moveable missile
	BNE NoMoveableMissile
	LDA Frame_Counter	;load Frame_Counter		
	LSR			;bit zero shifted to carry
	BCS .RESMP0		;branch if carry =1
	LDX #0			;release and set
.RESMP0	
	STX RESMP0		;missile locked to center of player 0 moves with Base
		
NoMoveableMissile	
	
; check joystick:
	LDA SWCHA
	ASL
	BCS noRight 		;Branch if Carry = 1
	INC P0_XPos		;increment player 0
	BCS withJoy    		;3 always taken branch, saves 1 byte compared to JMP
noRight:
	ASL
	BCS noLeft 		;Branch if Carry = 1
	DEC P0_XPos		;decrement player 0
	BCS withJoy    		;3 always taken branch, saves 1 byte compared to JMP
noLeft:
   
withJoy:
	LDA P0_XPos
	CMP #C_LEFT_BOUND_BASE
	BCC outOfLeftBound
	CMP #C_RIGHT_BOUND_BASE 
	BCC inXBounds
	LDA #C_RIGHT_BOUND_BASE
	.byte $2c       ;       op code for BIT.w, this hides the next instruction
outOfLeftBound:
	LDA #C_LEFT_BOUND_BASE
	STA P0_XPos
inXBounds:
	
;---------------------------------------------------------------------------------------------------	

;Check joystick button
		
	LDA Screen_Select	;load screen we are using	
	CMP #4	
	BEQ NoButton		;inhibit firing if game over
	
	LDA Destroyed_Index
	CMP #%11111111
	BEQ NoButton           ;inhibit firing if all enemeies damaged
	
	LDA Shields_Up
	BNE NoButton           ;inhibit firing if Shields are up
	
	LDA Base_Hit
	CMP #1
	BEQ NoButton           ;inhibit firing if base is hidden
	
	LDA INPT4		;Seventh BIT is set if button pressed
	BMI NoButton		;Branch if button not pressed
;button has been pressed
	LDX #0	;
	STX Missile_YPos	;reset overal missile vertical position
	LDX #SILVER   		;load %00001111 used with STX RESMP0
	LDA Game_Selected
	CMP #%00000000		;must compare with BCD number
	BCC NoMoveableMissile1
	STX RESMP0		;missile locked to center of player 0 moves with Base
NoMoveableMissile1
	LDA Sound_Type		;if low fuel warning is playing 	
	CMP #4			;sound type 4
	BEQ NoLaserSound	;inhibit laser fire sound
;Laser Fire Sound	

;Only play sound if these sounds are not playing
;Low Fuel Warning Sound	
;Exploding Enemy Sound	
;Exploding Base Sound	
;Remove next four lines to always play

	LDA Notes_Played
	BMI LaserSound
	BNE NoLaserSound
LaserSound	
	LDA #<Laser		;low byte of sound pointer
	STA Sound_Pointer	;store in low byte of sound pointer
	LDA #1	
	STA Notes_Played
	LDA #3
	STA Sound_Type
	
NoLaserSound	
	LDX #C_MISSILE_BOTTOM	;reload missile bottom position
	STX Missile_Pos		;missile position
	LDX P0_XPos
	STX Missile_XPos	;missile horizontal position when fired
	LDX #8
	STX Missile_Enable      ;enable initial missile loop
	
;button not pushed	
NoButton
	
			
	;Writing a 1 to D1 of the reset missile-to-player register (RESMP0, RESMP1)
	;disables that missiles’ graphics (turns it off) and repositions it
	;horizontally to the center of its’ associated player.
	;Until a 0 is written to the register, the missiles’horizontal position is 
	;locked to the center of its’ player in preparation to be fired again.
	
;---------------------------------------------------------------------------------------------------	

;Check Reset Switch


;SWCHB (HEX 282) to determine the status of all the console switches

;Data BIT Switch BIT Meaning
;D7 P1 difficulty 0 = amateur (B), 1 = pro (A)
;D6 P0 difficulty 0 = amateur (B), 1 = pro (A)
;D5/D4 (not used)
;D3 color - B/W 0 = B/W, 1 = color
;D2 (not used)
;D1 game select 0 = switch pressed
;D0 game reset 0 = switch pressed

 
	LDA  Delay_Switch
	BNE  Delay

	LDA  #10    
	STA  Delay_Switch
Delay
	DEC  Delay_Switch
	BNE  NoSelectGame

	LDA SWCHB 		;11111111
	LSR			;BIT 0 is put into carry Flag
	BCS NoResetGame		;Branch if carry=1 (switch not pressed)
;reset switch pressed	
	JSR GameReset		;reset all variables 
	LDA #1			;
	STA Screen_Select	;goto splash screen
NoResetGame
	LSR			;BIT 0 is put into carry Flag
	BCS NoSelectGame   	;Then check for button press...
;select switch pressed	
	LDA CTRLPF
	BEQ NoSetCTRLPF
	LDA #0
	STA CTRLPF
	STA AUDV0		;inhibit sound
	STA AUDV1		;during pause
NoSetCTRLPF	
	LDA Screen_Select	;load current screen
	CMP #1			;is it intro screen? 
	BEQ NoPause		;if intro screen do not pause
	LDA #1			;if any other screen pause it
	STA Screen_Select	;goto splash screen
	BNE NoSelectGame	;branch out
NoPause	
	SED			;Set decimal mode
	LDA Game_Selected	;2 digit of select 
	CMP #%00000011		;must compare with BCD number
	BCC NoResetSelect
	LDA #%00000000		;reset select to 0
NoResetSelect	
	CLC			;clear carry
	ADC #1 			;increase ten thousands, hundred thousands
	STA Game_Selected	;store new score
	CLD			;Clear decimal mode
NoSelectGame

;---------------------------------------------------------------------------------------------------	

; -- Play Some Sounds using Register 0--

	
	LDA Notes_Played	
	BMI HoldNoteReg0	;if index is less than 0 do not play
	LDA Sound_Type
	STA AUDC0		;sound type	
	DEC Note_Counter		
	BPL HoldNoteReg0  	;hold note until it reaches zero
	DEC Notes_Played	;change note 
	BPL PlayNextNoteReg0	;play next note until we run out of notes
	LDA #0
	STA AUDV0
	BEQ HoldNoteReg0

PlayNextNoteReg0
	LDY Notes_Played
	LDA Note_Sustain
	STA Note_Counter
	LDA (Sound_Pointer),Y 
	STA AUDF0		;pitch
	LDA #11 
	STA AUDV0 		;volume
	
HoldNoteReg0

;---------------------------------------------------------------------------------------------------	

; -- Play Some Sounds using Register 1--

	
	LDA Notes_Played+1	
	BMI HoldNoteReg1	;if index is less than 0 do not play
	LDA Sound_Type+1
	STA AUDC1		;sound type	
	DEC Note_Counter+1		
	BPL HoldNoteReg1  	;hold note until it reaches zero
	DEC Notes_Played+1	;change note 
	BPL PlayNextNoteReg1	;play next note until we run out of notes
	LDA #0
	STA AUDV1
	BEQ HoldNoteReg1

PlayNextNoteReg1
	LDY Notes_Played+1
	LDA Note_Sustain+1
	STA Note_Counter+1
	LDA (Sound_Pointer+2),Y 
	STA AUDF1		;pitch
	LDA #11 
	STA AUDV1 		;volume

HoldNoteReg1

;---------------------------------------------------------------------------------------------------	

; -- Decrease fuel level --
	
	LDA Screen_Select
	CMP #2
	BNE NoChangeFuelColor  ;inhibit decrease if not on Main Screen
	
	LDA Base_Hit
	BNE NoChangeFuelColor  ;inhibit decrease if Base has been hit
	
	DEC Fuel_Decrease
	BNE NoZeroFuelDelay
	; Decrease fuel level (and reset fuel delay)
	LDA #C_FUEL_RATE
	STA Fuel_Decrease
	DEC Fuel_Level         ;used for changing fuel color
	LDA FuelBar+3           ;Segment6
	BEQ Fuel4
	ASL
	STA FuelBar+3
	JMP NoZeroFuelDelay
Fuel4
	LDA FuelBar+4		;segment5
	BEQ Fuel3
	LSR
	STA FuelBar+4
	BCS NoZeroFuelDelay
Fuel3
	LDA FuelBar+5
	BEQ Fuel2
	ASL
	STA FuelBar+5
	JMP NoZeroFuelDelay
Fuel2
	LDA FuelBar+2
	BEQ Fuel1
	LSR
	STA FuelBar+2
	BCS NoZeroFuelDelay
Fuel1
	LDA FuelBar+1
	BEQ Fuel0
	ASL
	STA FuelBar+1
	JMP NoZeroFuelDelay
Fuel0
	LDA FuelBar+0
	BEQ EndOfFuel
	LSR
	AND #%11000000
	STA FuelBar+0
	JMP NoZeroFuelDelay
EndOfFuel
	; Player explodes if fuel has finished
	LDA #1
	STA Fuel_Gone
NoZeroFuelDelay

	LDA Fuel_Level
	CMP #10
	BNE NoDanger
	LDA #C_FUEL_GONE
	STA Fuel_Color
;Low Fuel Warning Sound	
	LDA #<LowFuel		;low byte of sound pointer
	STA Sound_Pointer	;store in low byte of sound pointer
	LDA #45
	STA Notes_Played 	;trigger sound
	LDA #4
	STA Sound_Type
	LDA #4
	STA Note_Sustain 
NoDanger
	LDA Fuel_Level
	CMP #18
	BNE NoChangeFuelColor
	LDA #C_FUEL_LOW
	CMP Fuel_Color
	BEQ NoChangeFuelColor
	STA Fuel_Color

NoChangeFuelColor
					
;---------------------------------------------------------------------------------------------------	

;Missile movement 
	LDA Missile_Enable     	;inhibit false firing
	CMP #9
	BCS NoMissile
	
	LDA Missile_Enable
	CMP #8
	BNE BandHeigth
	LDA #C_PO_KERNAL_HEIGHT ;26
	.byte $2c 
BandHeigth	
	;adjust value on next line to simulate different missile speeds
	;maximum is about 20 any higher missile disapears between bands
	
	LDA #12			;C_ENEMY_KERNAL_HEIGHT 15
	CMP Missile_Pos 	;check missile position in accumulator
	BNE DoneBand		
	LDA #C_MISSILE_BANDS	;6 reload missile bottom position for bands
	STA Missile_Pos		
	DEC Missile_Enable
DoneBand	
	INC Missile_Pos
	
NoMissile	

;---------------------------------------------------------------------------------------------------	

;Bomb Dropping Sounds	
	
	LDA Bomb_Enable
	CMP #8
	BNE NoBombSounds
	
	
	LDA Bomb_YPos	
	CMP #C_BOMB_HEIGHT-1
	BNE NoBombDropSound
	
	LDA Bomb_Color
	CMP #C_BOMB_COLOR
	BNE NoBombDropSound
	
;Bomb Dropping Sound
	LDA #<Sprite_Data10	;low byte of sound pointer
	STA Sound_Pointer+2	;store in low byte of sound pointer
	LDA #15			;sound of falling bomb
	STA Notes_Played+1
	LDA #4			;15;12;10;9;7;6
	STA Sound_Type+1
	STA AUDV1
	
NoBombDropSound
	LDA Bomb_YPos
	CMP #10
	BNE NoBombSounds
	
;Bomb Hittting Ground Sound	
	LDA #<LowFuel		;low byte of sound pointer
	STA Sound_Pointer+2	;store in low byte of sound pointer
	LDA #1			;sound of shield repeling bombs
	STA Notes_Played+1
	LDA #8			;15;12;10;9;7;6
	STA Sound_Type+1
NoBombSounds	

;---------------------------------------------------------------------------------------------------	

;Bomb movement 

	LDA Enemy_Hits
	BNE NoHoldBomb 		;hold bomb in bay door until we hit an enemy
	LDA #2	
	STA RESMP1
NoHoldBomb	
	
;checking bomb position and reseting variables accordingly
	LDA Bomb_YPos		;Bomb position
	CMP #C_BOMB_BOTTOM			;compare 
	BCS NoRePositionBomb	;branch if Bomb_YPos is 6 lines from bottom of band
;increment bomb enable and reset bomb height
;whenever we reach 7 lines above bottom of band
	INC Bomb_Enable
	LDA #7
	CMP Bomb_Enable
	BCC NotBombBands	;branch if Bomb_Enable > 7
;top band will always be loaded with 35 because bomb enable is reset below

	LDA #C_BOMB_BANDS	;vertical start position of bomb in bands 16
	.byte $2c 
NotBombBands	
	LDA #C_BOMB_HEIGHT	;vertical start position of bomb in bottom band 35
	STA Bomb_YPos
	
NoRePositionBomb
	LDX Bomb_Enable		;
	CPX #8			;
	BEQ NoRESMP1	
	LDA Bomb_YPos		;load Bomb vertical position	
	CMP #C_BOMB_HEIGHT	;if we equal max height of bottom band 
	BEQ .RESMP1		;branch to set RESMP1
RESMP1Bands	
	LDX #8			;check to se if we are in bottom band	
	CPX Bomb_Enable		;if so branch out so we can't hit RESMP1
	BEQ NoRESMP1		;because we already did above
	
	LDA Bomb_YPos		;load Bomb vertical position	
	CMP #C_BOMB_BANDS+3	;otherwise check for max height+2 of middle bands
	BNE NoRESMP1		;branch out if not at max height oterwise	
.RESMP1				;set RESMP1 2 lines before bomb is visible in bands
	LDA #2	
	STA RESMP1
NoRESMP1	
	LDA Bomb_Enable     	;inhibit false firing
	CMP #9
	BNE NoBombReset
	
;Only reset Bomb_Enable when we have completed bomb drop	
	LDX #7			;Number of Enemies to check			
CheckifVisible	
	LDA Enemies_Remaining,X	;Load Enemies_Remaining
	BPL StillVisible	;any Enemies visible ?
	DEX			;decrease x and loop until less than 0
	BPL CheckifVisible
StillVisible
	STX Bomb_Band
	INX
	STX Bomb_Enable		;set starting band for bombs
		
NoBombReset	
	LDA Missile_Enable     	;missile set to #$FF after hit or it goes of screen
	BMI NoCollisionCheck	;only check collision when missile active
	JSR Collision		;check collision missile 0 and player 
NoCollisionCheck

	LDA Shields_Up		;Inhibit Collision detection if shields are up
	BEQ CheckCollisionM1	;Branch if Shields are down
;check for hit on shield	
	LDA #%10000000		;               D7    D6
	BIT CXM1P		;read collision M1 P0 M1 Enemy
	BEQ NoShieldHit 	;branch out if zero -no collision detected

;Bomb Deflecting from Shield Sound	
	LDA #<Laser		;low byte of sound pointer
	STA Sound_Pointer+2	;store in low byte of sound pointer
	LDA #1			;sound of shield repeling bombs
	STA Notes_Played+1
	LDA #4			;15;12;10;9;7;6
	STA Sound_Type+1
	LDA #19			;repel bomb
	STA Bomb_YPos
	
	LDA Bomb_Color		;Only allow shields to overheat if red bomb hits
	CMP #C_BOMB_COLOR		
	BNE NoShieldHeat	
	INC Shields_Up		
	LDA Shields_Up		
	CMP #11			;if you get 11 red hits on shield you die
	BNE NoShieldHeat
	JSR CollisionM1		;check for collision if you have 11 hits
	LDA #1			
	STA Shields_Up
		
	
NoShieldHeat	
	BNE NoCheckCollisionM1  ;fall through
	
NoShieldHit

;Shields Up Sound
	LDA #<Shields		;low byte of sound pointer
	STA Sound_Pointer+2	;store in low byte of sound pointer
	LDA #1	
	STA Notes_Played+1
	LDA #14;15;12;10;9;7;6
	STA Sound_Type+1
	BNE NoCheckCollisionM1 
	
CheckCollisionM1	
	JSR CollisionM1
	JSR CollisionM0M1
	
NoCheckCollisionM1
	STA CXCLR		;clear collision latches
	JSR EndLevel		;this must stay here to function properly
		
	LDA Enemy_Hits
	BEQ NoDropBombs 
	LDA Frame_Counter	;load Frame_Counter		
	LSR			;divied by four
	LSR
	BCS NoDropBombs		;branch if carry =1
	DEC Bomb_YPos		;decrement every other frame
NoDropBombs	
	LDA Missile_Enable
	CMP #8
	BCS DoneBombs
	INC Missile_YPos
	
DoneBombs	
		
	LDA Missile_YPos    	;reset when missile reaches top	
	CMP #48  
	BEQ YPosReset  	
	BNE NoYPosReset
YPosReset	
	LDA #0
	STA Missile_YPos 
NoYPosReset
	
;---------------------------------------------------------------------------------------------------

;Frame_Counter
	
	DEC Frame_Counter 	;0-255
	

;---------------------------------------------------------------------------------------------------

;Set Pointers for animation every 128 frames alternate score AND message also
		
	LDA Frame_Counter
	BMI HighFrames
	
	LDA #<Sprite_Data0	;low byte of ptr is normal graphic
	STA Enemy_Ptr		;(high byte already set)

	LDA #<Sprite_Data1	;low byte of ptr is normal graphic
	STA Enemy_Ptr+2	

	LDA #<Sprite_Data2	;low byte of ptr is normal graphic
	STA Enemy_Ptr+4		;(high byte already set)

	LDA #<Sprite_Data3	;low byte of ptr is normal graphic
	STA Enemy_Ptr+6	

	LDA #<Sprite_Data4 	;low byte of ptr is normal graphic
	STA Enemy_Ptr+8		;(high byte already set)

	LDA #<Sprite_Data5	;low byte of ptr is normal graphic
	STA Enemy_Ptr+10	

	LDA #<Sprite_Data6	;low byte of ptr is normal graphic
	STA Enemy_Ptr+12	;(high byte already set)
	
	LDA #<Sprite_Data7	;low byte of ptr is normal graphic
	STA Enemy_Ptr+14	;(high byte already set)
	
	
;Only change color if bomb is high enough to see	
	LDA Bomb_YPos		;Bomb position
	CMP #C_BOMB_HEIGHT	;compare 
	BCC NoChangeBombRed	
	LDX #C_BOMB_COLOR
	STX Bomb_Color
NoChangeBombRed	
	BNE NoChangeBombGreen   ;get out
	
HighFrames	
	
	LDA #<Sprite_Data1	;low byte of ptr is normal graphic
	STA Enemy_Ptr		;(high byte already set)

	LDA #<Sprite_Data0	;low byte of ptr is normal graphic
	STA Enemy_Ptr+2	

	LDA #<Sprite_Data3	;low byte of ptr is normal graphic
	STA Enemy_Ptr+4		;(high byte already set)

	LDA #<Sprite_Data2	;low byte of ptr is normal graphic
	STA Enemy_Ptr+6	

	LDA #<Sprite_Data5 	;low byte of ptr is normal graphic
	STA Enemy_Ptr+8		;(high byte already set)

	LDA #<Sprite_Data4	;low byte of ptr is normal graphic
	STA Enemy_Ptr+10	

	LDA #<Sprite_Data7	;low byte of ptr is normal graphic
	STA Enemy_Ptr+12	;(high byte already set)
	
	LDA #<Sprite_Data6	;low byte of ptr is normal graphic
	STA Enemy_Ptr+14	;(high byte already set)
	
;Only change color if bomb is high enough to see	
	LDA Bomb_YPos		;Bomb position
	CMP #C_BOMB_HEIGHT	;compare 
	BCC NoChangeBombGreen
	LDX #C_FUEL_POD_COLOR
	STX Bomb_Color
NoChangeBombGreen	

;---------------------------------------------------------------------------------------------------	

;Process Messages	
	
	LDA Screen_Select	;load screen we are using	
	CMP #4			;if at finish screen	
	BEQ ShowGameOver	;display GameOver message
	BNE ShowMessages	;otherwise show Messages
ShowGameOver	
	JSR GameOver		;gosub to GameOver message
	BNE DoneMessages	;branch over CatchMessage

ShowMessages	
	
	LDA Fuel_Color
	CMP #C_FUEL_GONE
	BNE NoLowFuelMessage
	LDA Bomb_Color
	CMP #C_FUEL_POD_COLOR
	BEQ CatchFuel
	JSR FuelLevel		;gosub to build fuel pointers
	.byte $02c
NoLowFuelMessage	
	JSR BuildScore		;gosub to build score pointers
	LDA Bomb_Color
	CMP #C_FUEL_POD_COLOR
	BNE DoneMessages
CatchFuel	
	LDA Enemy_Hits
	BEQ DoneMessages 
	JSR CatchMessage	;gosub to build CatchMessage pointers

DoneMessages
	
;---------------------------------------------------------------------------------------------------	

;Set Pointers for base explosion
	
	LDA Game_Selected
	CMP #%00000011		;option 3 NO Shields
	BEQ NoShields
	LDA SWCHA
	ASL
	ASL
	ASL
	ASL
	BCC ShieldsUp		;Branch if Carry = 0 (SWCHA)
NoShields
	LDX #0			;Default Shields Down
	STX Shields_Up		;Store Shield Value
	LDA Base_Hit		;Check for Destroyed Base
	BNE ExplodeBase		;Branch if Destroyed
ShieldsUp
	BCS NoShieldsUp		;Branch if Carry = 1 (SWCHA)
	LDA Shields_Up		;Only set to 1 if Shields_Up =0
	BNE ShieldsOn		;So I can add to value for heat increase
	LDX #1			;Shields UP
	STX Shields_Up		;Store Shield Value
ShieldsOn	
	LDA Base_Hit		;Check for Destroyed Base
	BNE ExplodeBase		;Branch if Destroyed
	LDA #<Sprite_Data9	;Shield Graphic
	.byte $02c
NoShieldsUp	
	LDA #<Sprite_Data8	;Base Graphic
	.byte $02c
ExplodeBase
	LDA #<Sprite_Destroyed	;Exploded Base Graphic
	STA P0_Ptr		;(high byte already set)
	
	
;---------------------------------------------------------------------------------------------------	

;Set P0_Y 	
	
	;for skipDraw, P0_Y needs to be set (usually during VBLANK)
	;to Vertical position (0 = top) + height of sprite - 1.
	;we're storing distance from bottom, not top, so we have
	;to start with the kernal height AND YPosFromBot...
	
	LDA #C_PO_KERNAL_HEIGHT + #C_P0_HEIGHT - #1 ;(192+12-1)
	SEC ;Set Carry
	SBC P0_YPosFromBot ;subtract integer byte of distance from bottom
	STA P0_Y

	;we also need to adjust the graphic pointer for skipDraw
	;it equals what it WOULD be at 'normally' - it's position
	;from bottom plus sprite height - 1.
	;(note this requires that the 'normal' starting point for
	;the graphics be at least align 256 + kernal height ,
	;or else this subtraction could result in a 'negative'
	; (page boundary crossing) value
	
	LDA P0_Ptr
	SEC ;Set Carry
	SBC P0_YPosFromBot	;integer part of distance from bottom
	CLC
	ADC #C_P0_HEIGHT-#1
	STA P0_Ptr	;2 byte
	
;---------------------------------------------------------------------------------------------------	

;setting pointers AND positions 	

	LDA #C_ENEMY_KERNAL_HEIGHT + #C_Enemy_HEIGHT - #1 ;(15+12-1)
	SEC ;Set Carry
	SBC Enemy_YPosFromBot	;distance from bottom (13)
	STA Enemy_Y		;26-13=13
	
			
	LDX #14
RePointer	
	LDA Enemy_Ptr,x 	;12,10,8,6,4,2,0
	SEC ;Set Carry
	SBC Enemy_YPosFromBot	;distance from bottom
	CLC
	ADC #C_Enemy_HEIGHT-#1 
	STA Enemy_Ptr,x		;2 byte
	DEX
	DEX
	BPL RePointer
	
;---------------------------------------------------------------------------------------------------
;Enemy_Movements 
   	
   	 	 	
 	LDA Frame_Counter	;load Frame_Counter		
	LSR			;(128)... divide by 128
	LSR			;(64) ... divide by 64
	LSR			;(32) ... divide by 32
	LSR			;0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 ... divide by 16
	
;Determine number of additional shifts based on Enemy_Index which decreases every level
;from max of 4 to min of 1. 

	;1 LSR			;0,1,2,3,4,5,6,7 ... divide by 32	
	;2 LSR			;0,1,2,3 ... divide by 64	
	;3 LSR			;0,1 ... divide by 128	
	;4 LSR			;0 ... divide by 256

	LDX Enemy_Index  	;1-4 	
	STX TmpVar3		;Set to known number
.Enemy_Index
	LSR
	DEX
	BNE .Enemy_Index
	
	STA TmpVar5
    	

;Speedup/Slowdown routine slow, jerky, fast

	LDX Enemy_Hits 		;Load Number of Enemy Hits
	CPX #17			;If > 16 
	BCS NoSlow		;branch out no slowdown
	CPX #9			;If < 8	
	BCC NoSetTmp		;branch out 
	LDX #0			;otherwise use TmpVar3 as flag
	STX TmpVar3
NoSetTmp	
	
	LDA Frame_Counter	;load Frame_Counter		1 or 4
	LSR			;bit zero shifted to carry
	LDX TmpVar3		;load 	
	BNE NoLSR		
	LSR
	LSR
	LSR
	LSR
NoLSR	
	BCS slowdown		;branch if carry =1
NoSlow
	
	
	LDX #7

NextEnemy 
			
	LDA #MoveTab,X		;move pattern to use 
	STA Enemy_Move_Ptr	;(high byte already set)
	
	LDA TmpVar5
	TAY  
	LDA (Enemy_Move_Ptr),Y
	STA Movement_Index

	

	LDA Enemy_XPos,X
	CMP #C_LEFT_BOUND_ENEMY
	BCC outLeftBound
	CMP #C_RIGHT_BOUND_ENEMY
	BCC inBounds
	LDA #C_LEFT_BOUND_ENEMY
	STA Enemy_XPos,X
	BNE inBounds
outLeftBound:
	LDA #C_RIGHT_BOUND_ENEMY
	STA Enemy_XPos,X
inBounds:
	
	CLC
	ADC Movement_Index
	STA Enemy_XPos,X
	DEX
	BPL NextEnemy

slowdown

	RTS
	
;---------------------------------------------------------------------------------------------------

Initialize_Fuel

	LDA #%11000000
	STA FuelBar+0
	STA FuelBar+3
	LDA #%11111111
	STA FuelBar+1
	STA FuelBar+2
	STA FuelBar+4
	STA FuelBar+5

	LDA #C_FUEL_START
	STA Fuel_Level
	LDA #C_FUEL_RATE
	STA Fuel_Decrease

	LDA #C_FUEL_OK
	STA Fuel_Color
	RTS			
;---------------------------------------------------------------------------------------------

Collision SUBROUTINE 

;Check collision from bottom enemy to top 
	
	LDX #7			;Number of Enemies			
	STX Enemy_YPos		;Vertical position of lowest enemy must start at 7 or first enemy
				;explodes before being hit and SBC #6 must not change
			
	LDA #%10000000		;first BIT to test
	STA TmpVar		;holds BIT to test against damage index
	
CheckCollision

;checking x collision

;check copy one for collision
	LDA Enemy_XPos,X	;Load enemy X position
	ADC #3			;Hit first copy?
	SBC Missile_XPos	;subtract Missile_XPos
	STA TmpVar4		;store for later
	BPL GotHit0		;branch if positive
;check copy two for collision
	LDA Enemy_XPos,X	;Load enemy X position
	ADC #19			;Hit second copy?
	SBC Missile_XPos	;subtract Missile_XPos
	STA TmpVar4		;store for later
	BMI CheckCopy3		;branch if negative to check Copy 3
;check to see if enemy copy two is alive		
	LDA Enemies_Remaining,X ;0,1,2,3
	CMP #2			;if middle copy has already been hit
	BEQ CheckCopy3		;branch and check last copy
		
	LDA Enemies_Remaining,X ;We must have not already hit middle copy
	CMP #1			;if we are here, but only register a hit
	BPL GotHit1		;if Enemies_Remaining,X is 0,1,2
;check copy three for collision		
CheckCopy3	
	LDA Enemy_XPos,X	;Load enemy X position
	ADC #35			;Hit third copy?
	SBC Missile_XPos	;subtract Missile_XPos
	STA TmpVar4		;store for later
	BMI NoHit		;branch if negative
;check to see if enemy copy three is alive		
	LDA Enemies_Remaining,X ;0,1,2,3
	CMP #2			;3-2=1;2-2=0;1-2=-1,0-2=-2 
	BMI NoHit		;No hit if Enemies_Remaining,X is 1 or 0
	LDA #2	

	.byte $2c
GotHit0
	LDA #0
	.byte $2c
GotHit1	
	LDA #1
	STA Enemy_Copy_Hit
		
	LDA TmpVar4
	SBC #6			;subtract 8
	BPL NoHit		;branch if sign = 0
	
;checking y collision	
	LDA Enemy_YPos		;load Enemy Y position (7,13,19,25,31,37,43,49)
	SBC Missile_YPos	;subtract missile Y position from enemy position(1,7,13,19,25,31,37,43)
	BMI NoHit		;branch if result is negative (missile is higher than enemy)
	SBC #6			;take result in accumulator and subtract Enemy height 
	BPL NoHit		;if result is positive missile is below enemy

;Enemy got hit!	
	LDA Destroyed_Index	;load Index
	BIT TmpVar		;mask BITs not tested (both bits must be 1 to branch)
        BNE NoHit              ;branch out if BIT already used to store destroyed status
	
	LDA Enemies_Remaining,X	;load Enemies_Remaining and if it is less than
	BMI Destroyed		;zero enemy is detroyed and not visible
	BPL NotDestroyed	;so update destroyed index
Destroyed	
	CLC
	LDA Destroyed_Index	;load index
	ADC TmpVar		;add current damage BIT to Destroyed_Index
	STA Destroyed_Index	;store new Destroyed_Index
	BNE DoneCollision	;added to inhibit ghost hits
NotDestroyed	
	LDA Damage_Index	;load Index (both bits must be 1 to branch)
	BIT TmpVar		;set Flag Z as if AND had been performed if both bits are 1 otherwise result is zero
	BNE NoHit		;branch out if Z=1 BIT already used to store damage
	;Damage_Index still in Accumulator
	EOR TmpVar		;flip bit in accumulator 
	STA Damage_Index	;store new Damage_Index
		
;find the index to the table values for the new configuration/offset:
;Y = index to hit copy * 4 + index to sprite configuration
	LDA Enemy_Copy_Hit
	ASL
	ASL 
	CLC
	ADC Enemies_Remaining,X 
	TAY
;get the new configuration
	LDA EnemyNusiz,Y
	STA Enemies_Remaining,X ;3,2,1,0
;get the offset and add it to get the new position
	;CLC
	LDA Enemy_XPos,X
	ADC EnemyShift,Y
	STA Enemy_XPos,X
;get offset for dead enemy	
	LDA DeadEnemyShift,Y
	STA Enemy_Destroyed,X
	
	JSR IncreaseScore
	INC Enemy_Hits
	
	LDX #ORANGE		;flash background red if collision
	STX COLUBK
	;STX COLUPF
	
;Exploding Enemy Sound	
	LDA #<LowFuel		;low byte of sound pointer
	STA Sound_Pointer	;store in low byte of sound pointer
	LDA #10	
	STA Notes_Played
	LDA #3
	STA Sound_Type
	LDA #4
	STA Note_Sustain 
		
	LDA Last_Enemy
	CMP #1		
	BEQ LastRow
	LDX #$FF
	STX Missile_Enable       
LastRow	
	BNE DoneCollision

	
NoHit	
	LDA TmpVar		;holds BIT to test against damage index
	LSR			;shift left to test next BIT of Damage_Index
	STA TmpVar		;store to TmpVar
	LDA Enemy_YPos		;load current vertical position	
	;CLC
	ADC #6			;add index to next enemy 
	STA Enemy_YPos		;store next vertical position to check
	DEX
	BMI DoneCollision
	JMP CheckCollision
DoneCollision
	
	RTS
	
;---------------------------------------------------------------------------------------------------

IncreaseScore SUBROUTINE

;Score keeping routine if collision detected
;Thomas Jentzsch the magic of the carry flag  

        SED                     ;Set decimal mode
        LDA     Score+2
        CLC                     ;clear carry
        ADC     #10             ;tens
        STA     Score+2         ;store new score
        LDA     Score+1         ;next 2 digits of score
        ADC     #0              ;increase hundreds, thousands
        STA     Score+1         ;store new score
        LDA     Score           ;next 2 digits of score
        ADC     #0              ;increase ten thousands, hundred thousands
        STA     Score           ;store new score
        CLD                     ;Clear decimal mode
        RTS

;---------------------------------------------------------------------------------------------------

IncreaseLevel SUBROUTINE
;Level keeping routine if collision detected

	SED			;Set decimal mode
	CLC			;clear carry
	LDA Level		;next 2 digits of score 
	ADC #1 			;increase
 	STA Level		;store new score
	CLD			;Clear decimal mode
	
;starts at 4 and decreases to 1
	
	LDA Enemy_Index
	CMP #1
	BNE DecreaseIndex
	LDA #5
	STA Enemy_Index 
DecreaseIndex
	DEC Enemy_Index		;level 4 is max
	
;Increase Lives	
	LDA Lives_Remaining
	CMP #6			;maximum lives is 6
	BEQ NoIncreaseLives
	INC Lives_Remaining
NoIncreaseLives	
	
;Bonus Score

	LDA Level		
	LSR
	BCS NoBonus    ;Bonus Score every other level 
	
	LDX #20
BonusScoreLoop	
	JSR IncreaseScore
	DEX
	BNE BonusScoreLoop
NoBonus	
	
	RTS
;---------------------------------------------------------------------------------------------------
	
CollisionM0M1 SUBROUTINE
	
	LDA Base_Hit		;don't allow collision unless base is active
	BNE DoneCollisionM0M1

;checking for collisions missile 1 missile 0	
	LDA #%01000000		;               D7    D6
	BIT CXPPMM		;read collision P0 P1 M0 M1
	BEQ DoneCollisionM0M1 	;branch out if zero -no collision detected	
	DEC Bomb_Enable
	INC Missile_Enable
	STA COLUBK
	JSR IncreaseScore
	
DoneCollisionM0M1	

	RTS
;---------------------------------------------------------------------------------------------------
	
CollisionM1 SUBROUTINE

	LDA Base_Hit		;don't allow collision unless base is active
	BNE DoneCollisionM1
	

;checking for collisions missile 1 AND player	
	LDA Fuel_Gone		;check to see if fuel ran out
	BNE NoCatchMissile	;explode base if fuel gone 
		
	LDA #%10000000		;               D7    D6
	BIT CXM1P		;read collision M1 P0 M1 Enemy
	BEQ DoneCollisionM1 	;branch out if zero -no collision detected

;collision detected run following

	
	LDA Bomb_Color			;Only allow base to be destroyed 
	CMP #C_BOMB_COLOR		;if bomb is red
	BEQ NoCatchMissile
;catch missile for bonus	
	JSR IncreaseScore	;Gosub 
	;Increase Fuel if you catch white Bomb
	
	;0 1 2 5 4 3

	LDA FuelBar+1
	BNE Refuel2
	LDA #%11000000
	STA FuelBar+0
	LDA #2
	STA Fuel_Level
	BNE DoneRefuel
Refuel2	
	LDA FuelBar+2
	BNE Refuel5
	LDA #%11111111
	STA FuelBar+1
	LDA #10
	STA Fuel_Level
	BNE DoneRefuel
Refuel5		
	LDA FuelBar+5
	BNE Refuel4
	LDA #%11111111
	STA FuelBar+2
	LDA #18
	STA Fuel_Level
	BNE DoneRefuel
Refuel4	
	LDA FuelBar+4
	BNE Refuel3
	LDA #%11111111
	STA FuelBar+5
	LDA #26
	STA Fuel_Level
	BNE DoneRefuel
Refuel3		
	LDA FuelBar+3
	BNE DoneRefuel
	LDA #%11111111
	STA FuelBar+4
	LDA #34
	STA Fuel_Level
DoneRefuel

;Catch Fuel Pod Sound	
	LDA #<LowFuel		;low byte of sound pointer
	STA Sound_Pointer+2	;store in low byte of sound pointer
	LDA #10	
	STA Notes_Played+1
	LDA #12
	STA Sound_Type+1
	LDA #4
	STA Note_Sustain+1 
	BNE DoneCollisionM1	;branch out

NoCatchMissile	

	LDX #0
	STX Fuel_Gone		;clear fuel out explode base variable
	
;Exploding Base Sound		
	LDA #<LowFuel		;low byte of sound pointer
	STA Sound_Pointer	;store in low byte of sound pointer
	LDA #60
	STA Notes_Played 	;trigger sound
	LDA #8
	STA Sound_Type
	LDX #1			
	STX Note_Sustain 
	STX Base_Hit		;ouch ... record a hit
			
DoneCollisionM1	
	RTS

;---------------------------------------------------------------------------------------------------

WaitVblank SUBROUTINE	

WaitForVblankEnd
	LDA INTIM
	BNE WaitForVblankEnd
	STA WSYNC
	STA VBLANK
	RTS
	
;---------------------------------------------------------------------------------------------------

AttractScreen SUBROUTINE	

	LDA INPT4		;Seventh BIT is set if button pressed
	BMI ButtonNotPushed	;Branch if button not pressed
	LDA #2			;load main screen
	STA Screen_Select
	
ButtonNotPushed
	JSR SixDigitDisplay
	LDA #BLACK
	STA COLUBK  
	JSR BuildScore	
	
	
	LDX #9 
LoopBeforeTitle	
	STA WSYNC
	DEX 
	BNE LoopBeforeTitle
		
	DEC Blank_Timer
	LDA Blank_Timer
	LSR
	STA COLUPF  		;colored playfield	

;This section brinks down Title one line at a time until it reaches bottom
;timer starts at 31 and runs until 191 then "stops"
	INC Enemy_Explode_Timer	;Decrement Delay Timer
	LDA Enemy_Explode_Timer	;load Timer
	CMP #191
	BNE NoResetTimer
	LDA #190
	STA Enemy_Explode_Timer
NoResetTimer	
	LSR	
	LSR
	LSR
	LSR			;divide by 16		
	TAX			;1,2,3,4,5,6,7,8,9,10,11
		
	;LDX #C_TITLE_HEIGHT ; 
	LDY #C_TITLE_LINES ; 

TitleShowLoop
	STA WSYNC 	
	LDA PFData0-1,X           ;[0]+4
	STA PF0                 ;[4]+3 = *7*   < 23	;PF0 visible
	LDA PFData1-1,X           ;[7]+4
	STA PF1                 ;[11]+3 = *14*  < 29	;PF1 visible
	LDA PFData2-1,X           ;[14]+4
	STA PF2                 ;[18]+3 = *21*  < 40	;PF2 visible
	LDA #BLACK
	STA COLUBK  ;black background 			;[25]+2
	;six cycles available  Might be able to do something here
	LDA PFData3-1,X          ;[27]+4
	;PF0 no longer visible, safe to rewrite
	STA PF0                 ;[31]+3 = *34* 
	LDA PFData4-1,X		;[34]+4
	;PF1 no longer visible, safe to rewrite
	STA PF1			;[38]+3 = *41*  
	LDA PFData5-1,X		;[41]+4
	;PF2 rewrite must begin at exactly cycle 45!!, no more, no less
	STA PF2			;[45]+2 = *47*  ; >
	DEY 
	BNE NotChangingTitle
	DEX 
	BEQ DoneWithTitle 
	LDY #C_TITLE_LINES 

NotChangingTitle
	
	JMP TitleShowLoop

DoneWithTitle	
	STA WSYNC 
	LDA #0
	STA COLUBK  	;black background 	
	STA PF2 
	STA PF0
	STA PF1	
	
	LDX #8
LoopAfterTitle	
	STA WSYNC
	DEX 
	BNE LoopAfterTitle

	JSR By
	JSR SixDigitDisplay
	
	JSR Name		;gosub to build Name pointers
	JSR SixDigitDisplay
	
	LDX #15
LoopAfterName	
	STA WSYNC
	DEX 
	BNE LoopAfterName

	JSR BuildSelect		;gosub to BuildSelect message
	JSR SixDigitDisplay
	
	RTS

;---------------------------------------------------------------------------------------------------

LevelScreen SUBROUTINE	
		
	LDA INPT4		;Seventh BIT is set if button pressed
	BMI LButtonNotPushed	;Branch if button not pressed
	;button pushed 
	LDA #2			;load main screen
	STA Screen_Select
	
;Level Complete Sound
	LDA #<Sprite_Destroyed	;low byte of sound pointer
	STA Sound_Pointer+2	;store in low byte of sound pointer
	LDA #10	
	STA Notes_Played+1
	LDA #12
	STA Sound_Type+1
	LDA #4
	STA Note_Sustain+1
	BNE EndLevelScreen
LButtonNotPushed
	LDA #%00000000
	STA Change_Index	 
	STA Damage_Index
	STA Destroyed_Index
	STA Enemy_Hits
	LDX #80
DelayBeforeScore	
	STA WSYNC
	DEX 
	BNE DelayBeforeScore
	
;Buld AND Display Score	
	
	JSR BuildScore	
	JSR SixDigitDisplay
	
	STA WSYNC	
	STA WSYNC
	STA WSYNC
	STA WSYNC
	STA WSYNC
	
;Buld AND Display Level	

	JSR BuildLevel
	JSR SixDigitDisplay

	LDX #80
DelayAfterLevel	
	STA WSYNC
	DEX 
	BNE DelayAfterLevel	
	JSR Initialize_Fuel
 	
EndLevelScreen    	
 	RTS

;---------------------------------------------------------------------------------------------------
	
BlankScreen SUBROUTINE  
	
	LDX #0		
	STX Notes_Played
	STX Notes_Played+1
	STX COLUBK 
	STX Enemy_Explode_Timer
	LDX #192
	
LoopBlank	
	STA WSYNC
	DEX 			;decrease to 0
	BNE LoopBlank		;branch up if not 0
	DEC Blank_Timer		;decrement Blank_Timer 
	RTS
;---------------------------------------------------------------------------------------------------

;Check for end of level

EndLevel SUBROUTINE
	
	LDX #0
	STX Last_Enemy
	LDX #7			;Number of Enemies to check			
CheckforVisible	
	LDA Enemies_Remaining,X	;Load Enemies_Remaining
	BPL HowManyLeft		;if any Enemies are visible store how many and Enemy 
	DEX			;decrease x and loop until less than 0
	BPL CheckforVisible
	BMI CheckLast 		;if X has fallen bellow zero do not store Enemy 
HowManyLeft
	INC Last_Enemy		;Increment to check for only one enemy remaining below
	STX TmpVar5		;store X for the enemy that is remaining
	DEX
	BPL CheckforVisible     ;decrease x and loop until less than 0
	
CheckLast	
	LDA Last_Enemy		
	BEQ NextLevel		;if Last_Enemy is zero we are done with this level
	CMP #1			;if we have only one enemy left
	BEQ Checkfor2copies	;check for 2 or less copies	
	BNE DoneLevelCheck	;if we have more than 1 enemy left we are done checking
Checkfor2copies
	LDX TmpVar5		;Enemy index number that is remaining	
	LDA Enemies_Remaining,X	;Load Last Enemies_Remaining
	CMP #2
	BEQ ResetIndex
	CMP #1
	BEQ ResetIndex
	CMP #0
	BEQ ResetIndex
	BNE DoneLevelCheck
	
ResetIndex
	LDA Change_Index
	BEQ DoneLevelCheck
	LDA #0;
	STA Change_Index
	STA Damage_Index
	BEQ DoneLevelCheck 	;always branch out
	
NextLevel
	STA Destroyed_Index
	
;reset Enemies here or Enemies_Remaining,X stays negative and Last Enemy remains 0
;thus BlankTimer keeps reseting to 90 and does not work

	LDX #3
	LDY #7
ReviveEnemies	
	STX Enemies_Remaining,Y
	DEY
	BPL ReviveEnemies
		
	LDA #90
	STA Blank_Timer		;Number of frames to blank display max 255
	JSR IncreaseLevel	;Increase Level	
		
	LDA #3			;load level screen		
	STA Screen_Select
	
DoneLevelCheck	
	
	RTS
	
;---------------------------------------------------------------------------------------------------

MainScreen SUBROUTINE

;Enemy drop into bands 

	LDX Enemy_YPosFromBot
	CPX #13
	BEQ NoEnemyDown
	
	LDA Frame_Counter	;load Frame_Counter		
	LSR			;bit zero shifted to carry
	BCS NoEnemyDown		;branch if carry =1
	DEC Enemy_YPosFromBot			
NoEnemyDown	
		
	JSR SixDigitDisplay  ;display Score
	
;---------------------------------------------------------------------------------------------------

;Enemy Bands
	
	LDX #0			;number of enemy bands (loops)				
	LDA Enemy_Y 		;load y position
	STA TmpVar		;store y position for use in loops
	LDA #%00000001		;first BIT to test
	STA TmpVar3		;holds BIT to test against damage/change index
	
;Enemy Reflect Animation
	
	LDA Frame_Counter	;load Frame_Counter		
	LSR			;divide by two
	LSR			;divide by two
	LSR			;divide by two
	LSR			;divide by two
	LSR			;divide by two
	LSR			;divide by two
	BCS NoReflectP1		;branch if carry =1
	LDA #%00001000   ;a 1 in D3 of REFP1 says make it mirror
	STA REFP0
	STA REFP1
	BNE DoneReflectP1	
NoReflectP1	
	LDA #%00000000   ;a 0 in D3 of REFP1 says make it mirror
	STA REFP0
	STA REFP1
	
DoneReflectP1
;ToDo
;This prevents a line jump after the low enemy is blacked out

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	
DrawEnemies

	LDA #BLACK		;Black Out if all enemies dead
	STA TmpVar6
	
	TXA			;transfer x to accumulator			
	ASL			;ASL to get 14,12,10,8,6,4,2,0			
	TAX			;transfer back to x				
	LDA Enemy_Ptr,X 	;14,12,10,8,6,4,2,0					
	STA Enemy_Ptr		;store new pointer					
	TXA			;transfer back to accumulator 			
	LSR			;shift it back					
	TAX			;transfer result back to x			
		
	LDA Change_Index	;load Change_Index (both bits must be 1 to branch)
	BIT TmpVar3		;BIT Comparison Z=1 if Compare Fails
	BNE ChangeEnemy		;Branch if Enemy needs to Change Z not equal to 0
;Enemy is  not hidden so check it for damage
	LDA Damage_Index	;load Damage_Index		
	BIT TmpVar3		;set Flag Z as if AND had been performed if both bits are 1 otherwise result is zero
	BEQ ShowEnemy		;branch if Flag Z is 0 Enemy has not been damaged

;Enemy has been damaged	
;Only fall through to here if both bits are 1 (Damage_Index and TmpVar3)
	LDA Enemy_Explode_Timer	;load Timer
	STA COLUP0		;colorful explosion
	STA COLUPF
	STA TmpVar6
	BNE ShowEnemy		;when timer drops to 0
	LDA TmpVar3		;flip bit of TmpVar3 
	STA Damage_Index	;reset to allow another hit
	STA Change_Index	;Store new index
	
ChangeEnemy
	;201=Rotate,35;29,28,27,23,12,11=frog;26=spaceman;39,10,1=spaceship;44,41=smiley
	;Cool patterns 180 200 201
	;test 190-216	
	;LDY #212;212
	;LDA #<Sprite_Data0,Y 
	
	LDA #<Sprite_Data0
	EOR #<Sprite_Shield
	STA Enemy_Ptr 
			
ShowEnemy
	LDA Enemies_Remaining,X
	STA NUSIZ1
	BMI Hide
	LDA #ColorTab,X		;Base Color						
	STA COLUP1
	BNE NoHide
Hide	
	LDA #LTGREY		;Black Out if all enemies dead
	STA TmpVar6
NoHide			
	
	LDA TmpVar 		;load y position
	STA Enemy_Y		;store y position for use in loop
	
	STX TmpVar2		;temporarily store X		
	
	LDA Bomb_Band
	CMP #7
	BCS NoAdjustP1
	TAX
	LDA Enemy_XPos,X	;mirror movement of highest live enemy
	STA Enemy_XPos+7	;to drop bomb from proper position
NoAdjustP1	
	LDX TmpVar2 
	LDA Enemy_XPos,X	;load movements					
	LDX #1			;specify movement for P1			
	JSR bzoneRepos		;Battlezone position routine			
	
	STA WSYNC
	
	
;Adjust P0 if enemy is hit
	LDX TmpVar6
	BEQ NoAdjustP0
	LDX TmpVar2 
	LDA Enemy_XPos,X
	ADC Enemy_Destroyed,X	;add offset for destroyed enemy
	BNE AdjustP0
NoAdjustP0	
	LDX TmpVar2 
	LDA Enemy_XPos,X
AdjustP0	
	LDX #0			;specify movement for P0			
	JSR bzoneRepos		;Battlezone position routine			
			
	STA WSYNC
	STA HMOVE 		;move objects that were finely positioned

	LDY #C_ENEMY_KERNAL_HEIGHT - 1; (off by one error) 15-1
EnemyLoop
	
 ;draw player sprite 1:
	LDA     #C_Enemy_HEIGHT-1; 2
	DCP     Enemy_Y         ; 5 (DEC AND CMP)
	BCS     EnemyDrawLoop   ; 2/3
	LDA     #0              ; 2
	.byte   $2c             ;-1 (BIT ABS to skip next 2 bytes)
EnemyDrawLoop:
	LDA     (Enemy_Ptr),y   ; 5 = 15
	LDX     TmpVar6		; 3 = 18
	BEQ	NoDraw0		; *2/3 = 20/21
	CPX 	#LTGREY		; 2 = 22
	BEQ	NoDraw1		; ~2/3 = 24/25
	STA     GRP0		; 3+24 = 27
NoDraw0				; *21	
	STA     GRP1		; *3+21=24 or 30 if drawing both during explosion
NoDraw1				; ~25		

;;Drawing GRP1 alone =24
;;Drawing GRP1 and GRP0 = 30
	
;Draw Bombs
	LDX TmpVar2		; 3 Enemies drawn 0 to 7 top to bottom
	CPX Bomb_Enable		; 3 1234567
	BNE EndBombLoop		; 2/3
		
	TYA                 	; 2 assuming y contains the scanline
	SBC Bomb_YPos         	; 3 carry must be 1 (else use DCP)
	ADC #C_BOMB_LENGTH   	; 2
	LDA #2		    	; 2
	ADC #$FF            	; 2 carry is always set!
  	STA ENAM1        	; 3 bit 1 depends on the carry after ADC

;;Not Drawing Bombs = 9
;;Drawing Bombs =22

EndBombLoop

;Draw Missiles	
	CPX Missile_Enable	; 3		
	BNE EndMissileLoop	; 2/3  

	TYA                 	; 2 assuming y contains the scanline
	SBC Missile_Pos         ; 3 carry must be 1 (else use DCP)
	ADC #C_MISSILE_LENGTH   ; 2
	LDA #2		    	; 2
	ADC #$FF            	; 2 carry is always set!
	STA ENAM0        	; 3 bit 1 depends on the carry after ADC
	
;;Not Drawing Missiles = 6
;;Drawing Missiles =19

EndMissileLoop			; 39 to 71 max
	
	DEY			; 2+39=41 or 2+71=73
	STA WSYNC               ; start counting
	BNE EnemyLoop		; 3+73=76
		
;You can directly shift registers. Thomas Jentzsch

	ASL TmpVar3             ;holds BIT to test against damage index	
	LDX TmpVar2		;restore x	
	INX											
	CPX #8			;number of enemy bands (loops)	
	BEQ DoneEnemyLoop
	JMP DrawEnemies	

DoneEnemyLoop		
		
	
	DEC Enemy_Explode_Timer	;Decrement Delay Timer
	LDA Enemy_Explode_Timer	;load Timer
	CMP #$FF
	BNE NoReset_Explode_Timer
	LDA #60		;length of explosion flash
	STA Enemy_Explode_Timer
NoReset_Explode_Timer	
		
	LDX #0
	STX RESMP1
	
;---------------------------------------------------------------------------------------------------

;Base Loop
;position comes from joystick routine
	
	
	LDA Shields_Up
	BNE .NOYELLOW
	LDA #YELLOW
	STA COLUP0
	
.NOYELLOW
	LDA Bomb_Color
	STA COLUP1
	CMP #C_BOMB_COLOR	;RED64 1000000 DKGREEN;196 11000100	
	BEQ NoFuelpod
	ASL			;10001000			
	ASL			;00010000
NoFuelpod	
	STA TmpVar	
		
	LDA Base_Hit 		;has base been hit?
	CMP #1
	BNE ShowBase		;branch if base has not been hit.
;Base has been damaged	
	LDA Delay_Timer		;load Timer
	DEC Delay_Timer		;decrement Timer
	STA COLUP0		;colorful explosion
	
	BNE ShowHideBase	;when timer drops to 0
	DEC Lives_Remaining
	LDX #0				
	STX Base_Hit		;reset Base_Hit
	STX Delay_Timer		;reset Timer
	STX Enemy_Hits
	LDX #70
	STX P0_XPos 		;initial position
	STX Bomb_YPos	
	JSR Initialize_Fuel
	
ShowHideBase	
	BMI ShowBase 		;branch if Timer is between 128-255
	LDX #BLACK		;load Black 
	STX COLUP0		;store it to hide Base
ShowBase	

;Shield/Base Animation		
	LDA Frame_Counter	;load Frame_Counter		
	LDX Shields_Up
	BNE Shields_On
	LSR			;divide by two
	LSR			;divide by two
	LSR			;divide by two
	LSR			;divide by two
Shields_On	
	LSR			;divide by two
	LSR			;divide by two
	BCS NoReflectP0		;branch if carry =1
	LDA #%00001000   ;a 1 in D3 of REFP0 says make it mirror
	STA REFP0
	BNE DoneReflectP0	
NoReflectP0	
	LDA #%00000000   ;a 0 in D3 of REFP0 says make it mirror
	STA REFP0
DoneReflectP0	
	
	LDA P0_XPos
	LDX #0
	JSR bzoneRepos
		
	STA WSYNC
	STA HMOVE 		;move objects that were finely positioned
	
				
	LDY #C_PO_KERNAL_HEIGHT - 1; (off by one error) 35
		
BaseLoop

;Draw Base
	LDA     #C_P0_HEIGHT-1  ; 2
	DCP     P0_Y            ; 5 (DEC AND CMP)
	BCS     DrawBaseLoop    ; 2/3
	LDA     #0              ; 2
	.byte   $2c             ;-1 (BIT ABS to skip next 2 bytes)
DrawBaseLoop:
	LDA     (P0_Ptr),y      ; 5
	STA     GRP0            ; 3 = 18 cycles (constant, if drawing or not!)
	
;Draw Bombs
	LDA Bomb_Enable		; 3
	CMP #8			; 2 from joystick button routine
	BNE EndBaseBombLoop	; 3
	LDA TmpVar		; 3
	STA NUSIZ1		; 3 single bomb
	TYA                 	; 2 assuming y contains the scanline
	SBC Bomb_YPos         	; 3 carry must be 1 (else use DCP)
	ADC #C_BOMB_LENGTH   	; 2
	LDA #2		    	; 2
	ADC #$FF            	; 2 carry is always set!
  	STA ENAM1        	; 3 bit 1 depends on the carry after ADC
  	
EndBaseBombLoop	

;Draw Missile
	LDA Missile_Enable	;+3
	CMP #8			;+2 from joystick button routine
	BNE EndBaseMissileLoop		;+3=26
	
	TYA                 	; 2 assuming y contains the scanline
	SBC Missile_Pos         ; 3 carry must be 1 (else use DCP)
	ADC #C_MISSILE_LENGTH   ; 2
	LDA #2		    	; 2
	ADC #$FF            	; 2 carry is always set!11111111
  	STA ENAM0        	; 3 bit 1 depends on the carry after ADC
	
EndBaseMissileLoop	
	
	STA WSYNC		;+3
	DEY			;+2	
	BNE BaseLoop		;+3 70
	
	STY RESMP0		;missile unlocked from player 0	
	STY REFP0		;reset to nonreflect
	STY REFP1		;reset to nonreflect

		
	LDX #DARKBLUE
	STX COLUBK
	
	LDX Bomb_Color
	CPX #C_BOMB_COLOR	;are we dropping a bomb?
	BNE NoBombExplode	;if not a bomb branch out
	LDX Bomb_YPos
	CPX #6
	BNE NoBombExplode
	LDX #Bomb_Color		;flash bar if bomb hits
	STX COLUBK
	
NoBombExplode	
	STX WSYNC	
	


;---------------------------------------------------------------------------------------------------	

;Lives Remaining and Fuel Loop	
	
	LDX Fuel_Color
	STX COLUP0
	STX COLUP1
	
;NUSIZ0	
	
	LDA Lives_Remaining
	CMP #0
	BNE NoAdjustLives
	LDA #4			;load finish screen
	STA Screen_Select
	JSR GameReset
	
NoAdjustLives	
	CMP #1			;compare with 4
	BNE AdjustLive		;branch past if not 4
	LDA #0			;otherwise load 0 for NUSIZ1 (1 copy)
AdjustLive	
	CMP #2			;compare it with two
	BEQ AdjustLives		;branch if  two
	.byte   $2c
AdjustLives
	LDA #1			;adjust it to one
	STA NUSIZ0		;0,1,3 number of lives remaining
	
	LDA Lives_Remaining
	CMP #4
	BCC AdjustNusiz0  	;Accumulator less than 4
	LDA #3 
	STA NUSIZ0
AdjustNusiz0	
	
	
;NUSIZ1

	LDA Lives_Remaining
	CMP #4			;compare with 4
	BNE AdjustLives0	;branch past if not 4
	LDA #0			;otherwise load 0 for NUSIZ1 (1 copy)
AdjustLives0	
	LSR
	CMP #2			;compare it with two
	BEQ AdjustLives1	;branch if  two
	.byte   $2c
AdjustLives1
	LDA #1			;adjust it to one
	STA NUSIZ1		;0,1,3 number of lives remaining
	
;Space and Display lives 
	
	STX WSYNC
	LDX #0
	SLEEP 15
	STX COLUBK
	STX RESP0       	;Set Player 0 	
	SLEEP 13
	STX RESP1 
	
;Hide GRP1 if not needed	         
     	LDA Lives_Remaining
     	CMP #4
     	BCS  ShowGRP1			;Accumulator less than 4
     	STX COLUP1
ShowGRP1     
          
   	LDY #4
LivesLoop

	NOP
	NOP
	LDA Sprite_Data10,Y    	                    
	STA GRP0
	STA GRP1
	STA WSYNC 
	DEY
	STY GRP1 
	BNE LivesLoop		
	STY GRP0
	STY GRP1
	
;Draw Fuel Bar
	
	LDA  #1		;Mirrored playfield 00000101
	STA  CTRLPF

	LDA #0
	STA COLUBK

	TAX		
	STX PF0
	STX PF1
	STX PF2

	LDA Fuel_Color
	STA COLUPF	; Removing PF graphics and blanking line 1 scanline before doing the fuel in order to maintain a correct cycle count

	LDY #2

LoopDrawFuelBar
	STA WSYNC

	LDA FuelBar,X	; 3
	STA PF0		; 6
	LDA FuelBar+1,X	; 9
	STA PF1		; 12
	LDA FuelBar+2,X	; 15
	STA PF2		; 18

	NOP
	NOP
	NOP

	LDA FuelBar+3,X	; 3
	STA PF0		; 6
	LDA FuelBar+4,X	; 9
	STA PF1		; 12
	LDA FuelBar+5,X	; 15
	STA PF2		; 18

	DEY

	BNE LoopDrawFuelBar

	STY WSYNC
	STY COLUPF
	STY PF1
	STY PF2
	STY COLUBK
	LDA #%00110000	; Restore black border...
	STA PF0

	RTS
;---------------------------------------------------------------------------------------------------
	
OverScan SUBROUTINE	
	
	;STA WSYNC
	STA VBLANK
	
	LDX #30
OverScanWait
	STA WSYNC
	DEX
	BNE OverScanWait
	RTS
;---------------------------------------------------------------------------------------------------

FuelLevel SUBROUTINE
	
	LDA #<Text3tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr	
	
	LDA #<Text4tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+2	
	
	LDA #<Text12tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+4	
		
	LDA #<Text5tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+6
	
	LDA #<Text6tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+8	
			
	LDA #<Text8tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+10

	RTS
		
;---------------------------------------------------------------------------------------------------

CatchMessage SUBROUTINE
	
	LDA #<Text0tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr	
	
	LDA #<Text1tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+2	
	
	LDA #<Text2tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+4	
		
	LDA #<Text12tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+6
	
	LDA #<Text3tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+8	
			
	LDA #<Text4tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+10

	RTS
	
;---------------------------------------------------------------------------------------------------

GameOver SUBROUTINE

	LDA #<Text9tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr	
	
	LDA #<Text7tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+2	
	
	LDA #<Text10tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+4	
		
	LDA #<Text6tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+6
	
	LDA #<Text11tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+8	
			
	LDA #<Text12tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+10

	RTS
	
;---------------------------------------------------------------------------------------------------

Name SUBROUTINE
	LDA #<Text14tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr	
	
	LDA #<Text6tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+2	
	
	LDA #<Text15tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+4	
		
	LDA #<Text16tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+6
	
	LDA #<Text17tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+8	
			
	LDA #<Text18tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+10

	RTS
	
;---------------------------------------------------------------------------------------------------

By SUBROUTINE
	LDA #<Text19tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr	
	
	LDA #<Text20tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+2	
	
	LDA #<Digit2tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+4	
		
	LDA #<Digit0tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+6
	
	LDA #<Digit0tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+8	
			
	LDA #<Digit5tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+10

	RTS
	
;---------------------------------------------------------------------------------------------------

SixDigitDisplay SUBROUTINE
       	
	LDA #C_SCORE_XPOS_P1
	LDX #1;PLAYER1
	JSR bzoneRepos
	LDA #0
			
	LDA #$03 	;triple copy sprites
	STA NUSIZ0
	STA NUSIZ1	;for both player objects
	STX VDELP0   	;X=1 turn on vertical delay for both players
	STX VDELP1
	STX WSYNC	;new line, start counting

	LDY #21

.loop: 	
	DEY		;14
	BPL  .loop	;20
	NOP		;2	;loop totals 36 cycles
	
	STA    RESP0	;P0 at pixel 108?
	STA    RESP1	;P1 at pixel 117?
	LDA    #$F0 	;shift P0 one posn to the right (109?)
	STA    HMP0	;load the motion register for P0
	STA    WSYNC	;new line
	STA    HMOVE	;reset both players to new horizontal positions

	
	LDY #C_SCORE_HEIGHT	;Height of graphics
.msgLoop:
	 
	DEY                         ; 2     61
	STY     TmpVar              ; 3     64
	LDA     (Temp_Score_Ptr+$8),y     ; 5     69
	TAX                         ; 2     71
	STA     WSYNC               ; 3 --- 76 ---
	LDA     (Temp_Score_Ptr),y        ; 5      5
	STA     GRP0                ; 3      8
	LDA     (Temp_Score_Ptr+$2),y     ; 5     13
	STA     GRP1                ; 3     16
	LDA     (Temp_Score_Ptr+$4),y     ; 5     21
	STA     GRP0                ; 3     24
	LDA     (Temp_Score_Ptr+$6),y     ; 5     29
	STA     TmpVar2             ; 3     32
	LDA     (Temp_Score_Ptr+$A),y     ; 5     37
	LDY.w   TmpVar2             ; 4     41
	STY     GRP1                ; 3     44
	STX     GRP0                ; 3     47
	STA     GRP1                ; 3     50
	STA     GRP0                ; 3     53
	LDY     TmpVar              ; 3     56
	BNE     .msgLoop            ; 2³    59

	STY     GRP0
	STY     GRP1
	STY     GRP0
	STY 	NUSIZ0
	STY 	NUSIZ1
	STA   	VDELP0  ;Clear vertical delays
	STA   	VDELP1 
	RTS

;---------------------------------------------------------------------------------------------------

	;Battlezone style exact horizontal repositioning
	;subroutine as rediscovered by R. Mundschau AND explained by Andrew Davie,
	;set A = desired horizontal position, then X to object
	;to be positioned (0->4 = P0->BALL)

bzoneRepos SUBROUTINE
	STA WSYNC                   ; 00     Sync to start of scanline.
	SEC                         ; 02     Set the carry flag so no borrow will be applied during the division.
.divideby15
	SBC #15                     ; 04     Waste the necessary amount of time dividing X-pos by 15!
	BCS .divideby15             ; 06/07  11/16/21/26/31/36/41/46/51/56/61/66

	TAY
	LDA fineAdjustTable,y       ; 13 -> Consume 5 cycles by guaranteeing we cross a page boundary
	STA HMP0,x

	STA RESP0,x                 ; 21/ 26/31/36/41/46/51/56/61/66/71 - Set the rough position.
	RTS
	
	echo "***", (*-Start), "BYTES USED HERE TO Start"
	;1788 BYTES USED HERE TO Start
	
;---------------------------------------------------------------------------------------------------

; This table converts the "remainder" of the division by 15 (-1 to -15) to the correct
; fine adjustment value. This table is on a page boundary to guarantee the processor
; will cross a page boundary AND waste a cycle in order to be at the precise position
; for a RESP0,x write

            ORG $FE00
fineAdjustBegin

	DC.B %01110000 ; Left 7
	DC.B %01100000 ; Left 6
	DC.B %01010000 ; Left 5
	DC.B %01000000 ; Left 4
	DC.B %00110000 ; Left 3
	DC.B %00100000 ; Left 2
	DC.B %00010000 ; Left 1
	DC.B %00000000 ; No movement.
	DC.B %11110000 ; Right 1
	DC.B %11100000 ; Right 2
	DC.B %11010000 ; Right 3
	DC.B %11000000 ; Right 4
	DC.B %10110000 ; Right 5
	DC.B %10100000 ; Right 6
	DC.B %10010000 ; Right 7

fineAdjustTable EQU fineAdjustBegin - %11110001 ; NOTE: %11110001 = -15


;---------------------------------------------------------------------------------------------------

BuildSelect SUBROUTINE

	LDX    #$0A                     ;2 initial offset for saving to ram

	LDA    Game_Selected        	;4 load a digit...
	AND    #$0F                     ;2 ...AND strip off the upper nibble
	JSR    TransDigit               ;6 convert it to an address
	LDA    Game_Selected            ;4 load a digit...
	
	
	LDA #<Text9tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr	

	LDA #<Text7tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+2	

	LDA #<Text10tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+4	

	LDA #<Text13tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+6

	LDA #<Text12tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+8	
		
		
	RTS
	
;---------------------------------------------------------------------------------------------

BuildLevel SUBROUTINE

	LDX    #$0A                     ;2 initial offset for saving to ram

	LDA    Level           		;4 load a digit...
	AND    #$0F                     ;2 ...AND strip off the upper nibble
	JSR    TransDigit               ;6 convert it to an address
	LDA    Level                 	;4 load a digit...
	LSR                             ;2...AND shift it low
	LSR                             ;2
	LSR                             ;2
	LSR                             ;2
	JSR    TransDigit               ;6 convert it to an address
	
	
	LDA #<Text5tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr	
	
	LDA #<Text6tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+2	
	
	LDA #<Text8tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+4	
		
	LDA #<Text12tab	;low byte of ptr is normal graphic
	STA Temp_Score_Ptr+6
	
		
	RTS

;---------------------------------------------------------------------------------------------

;grabs each ram byte of the score (3 bytes in ram)...shifts the nibbles to the proper position,
;AND then JSR's to the routine that sets up the ROM address of each BITmap
;(which uses a 13th TmpVar variable to hold the offset of the current score byte being worked with).
;Each byte of the score is done twice...once for the lower digit, AND once for the upper digit.
;Then when the display is being created, you can use that temporary table (Temp_Score_Ptr to Temp_Score_Ptr+11)
;with indirect y instructions to grab the BITmap info on-the-fly AND send it to the display.
;All the above code must be executed before TIA is turned on. Once the display is done making 
;the digits on the screen, all of those temp variables in ram can be reused for anything else
;during that frame (nothing permanent, since they will all be used again on the next frame). 
BuildScore SUBROUTINE 
	LDX    #$0A                     ;2 initial offset for saving to ram
	LDY    #$02                     ;2 (3 score digits)

Convert_score:

	LDA    Score,y                  ;4 load a digit...
	AND    #$0F                     ;2 ...AND strip off the upper nibble
	JSR    TransDigit               ;6 convert it to an address
	LDA    Score,y                  ;4 load a digit...
	LSR                             ;2...AND shift it low
	LSR                             ;2
	LSR                             ;2
	LSR                             ;2
	JSR    TransDigit               ;6 convert it to an address
	DEY                             ;2
	BPL    Convert_score            ;2 branch until Y falls below zero
	RTS
	
;---------------------------------------------------------------------------------------------

;subroutine that will transfer addresses to a temporary table of 12 bytes
;in ram memory (each digit will need 2 bytes)... 

;We have a zero page variable (2 bytes long) which holds the address of the score table
;containing the shape we want to display. Addresses are 16-BITs long, AND we've already
;seen how the 6502 represents 16-BIT addresses by a pair of bytes - 
;the low byte followed by the high byte (little-endian order).
;So into our sprite pointer variable, we are writing this byte-pair.
;The '>' operator tells the assembler to use the high byte of an address,
;AND the '<' operator tells the assembler to use the low byte of an address.

TransDigit: SUBROUTINE 

	STY    TmpVar                   ;3 save Y for a second
	TAY                           ;2 transfer the digit value to Y
	LDA    DigitTab,y              ;4...AND use it as an offset
	LDY    TmpVar                 ;3 restore Y
	STA    Temp_Score_Ptr,x       ;5 save the low byte
	LDA    #>DigitTab	      ;2 (i.e. page # of all digit gfx)
	STA    Temp_Score_Ptr+1,x     ;5 save the high byte
	DEX                           ;2 shift X 2 spots down
	DEX                           ;2 
	RTS                           ;6 
	echo "***", (*-fineAdjustBegin), "BYTES USED HERE TO fineAdjustBegin"
	;125 BYTES USED HERE TO fineAdjustBegin
;---------------------------------------------------------------------------------------------------
	
GameSounds
;48 bytes

LowFuel
	.byte 31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,9,29,29,9,9,29,29,9,9,29,29,9,9,29,29,9,9,29,29,9,9,29,29
Laser
	.byte 5
Shields 
	.byte 2
	
	org $FEC0
;66 bytes
PFData0
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
PFData1
	.byte #%00001110
	.byte #%00001010
	.byte #%00001110
	.byte #%00001010
	.byte #%00001110
	.byte #%00000000
	.byte #%00000111
	.byte #%00000001
	.byte #%00000111
	.byte #%00000100
	.byte #%00000111
PFData2
	.byte #%00100101
	.byte #%00100101
	.byte #%00100111
	.byte #%00100101
	.byte #%01110010
	.byte #%00000000
	.byte #%00100010
	.byte #%01100010
	.byte #%11001110
	.byte #%01001010
	.byte #%10001110
PFData3
	.byte #%00100000
	.byte #%00100000
	.byte #%00100000
	.byte #%00100000
	.byte #%01110000
	.byte #%00000000
	.byte #%10100000
	.byte #%10110000
	.byte #%10010000
	.byte #%10010000
	.byte #%10000000
PFData4
	.byte #%11101110
	.byte #%10001000
	.byte #%10001100
	.byte #%10001000
	.byte #%10001110
	.byte #%00000000
	.byte #%11011100
	.byte #%00010000
	.byte #%00011000
	.byte #%00010000
	.byte #%11011100
PFData5
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
	
;---------------------------------------------------------------------------------------------------
;132 bytes
Sprite_Data0 ;Smiley-12bytes
	.byte #%00011000
	.byte #%00111100
	.byte #%01100110
	.byte #%11000011
	.byte #%10011001
	.byte #%10100101
	.byte #%10000001
	.byte #%10010101
	.byte #%11000011
	.byte #%01100110
	.byte #%00111100
	.byte #%00011000
Sprite_Data1 ;Pacman-12bytes
	.byte #%00011000
	.byte #%01111100
	.byte #%01111110
	.byte #%11111100
	.byte #%11111000
	.byte #%11110000
	.byte #%11110000
	.byte #%11111000
	.byte #%11111100
	.byte #%01101110
	.byte #%01111100
	.byte #%00011000
Sprite_Data2 ;Frog-12bytes
	.byte #%00000011
	.byte #%11000010
	.byte #%00100100
	.byte #%00011000
	.byte #%00011000
	.byte #%00011000
	.byte #%01011000
	.byte #%01011000
	.byte #%01111110
	.byte #%00011010
	.byte #%00011010
	.byte #%00011000
Sprite_Data3 ;Robot-12bytes
        .byte #%11000110
        .byte #%01000010
        .byte #%01111110
        .byte #%00111100
        .byte #%00011000
        .byte #%00011001
        .byte #%11111111
        .byte #%10011000
        .byte #%00111100
        .byte #%01111110
        .byte #%01100010
        .byte #%01111110
Sprite_Data4 ;Teepee-12bytes
	.byte #%11111111
	.byte #%11110111
	.byte #%01101110
	.byte #%01110110
	.byte #%01101110
	.byte #%00110100
	.byte #%00101100
	.byte #%00111100
	.byte #%00011000
	.byte #%00011000
	.byte #%00011000
	.byte #%00011000
Sprite_Data5 ;UFO-12bytes
	.byte #%10000001
	.byte #%01011010
	.byte #%00111100
	.byte #%01111110
	.byte #%10101011
	.byte #%01010101
	.byte #%10101011
	.byte #%01111110
	.byte #%00111100
	.byte #%00111100
	.byte #%01000100
	.byte #%10000110
Sprite_Data6 ;Capsule-12bytes
	.byte #%11000000
	.byte #%10100000
	.byte #%10010000
	.byte #%11001000
	.byte #%10100110
	.byte #%10010101
	.byte #%10010101
	.byte #%10100110
	.byte #%11001000
	.byte #%10010000
	.byte #%10100000
	.byte #%11000000
Sprite_Data7 ;Spider-12bytes
	.byte #%00000011
	.byte #%11011010
	.byte #%01011010
	.byte #%01011010
	.byte #%01111110
	.byte #%00011000
	.byte #%00011000
	.byte #%01111110
	.byte #%01000010
	.byte #%01011010
	.byte #%01000011
	.byte #%11000000
Sprite_Destroyed;-12bytes 
	.byte #%00010000
	.byte #%01000100
	.byte #%00100000
	.byte #%00001000
	.byte #%00100100
	.byte #%00010000
	.byte #%00001001
	.byte #%00100100
	.byte #%01000100
	.byte #%00010010
	.byte #%00000000
	.byte #%10000000
Sprite_Data8 ;Base-10bytes 
	.byte #%01111110  ; XXXXXX 
	.byte #%01110110  ; XXXRXX
	.byte #%01101110  ; XXRXXX
	.byte #%00110100  ;  XXRX
	.byte #%00101100  ;  XRXX  
	.byte #%00011000  ;   XX  
	.byte #%00011000  ;   XX   
	.byte #%00010000  ;   XR	
	.byte #%00000000  ;      
	.byte #%00000000  ;    
Sprite_Data9 ;Base with Shield-10bytes  (fast reflected)R is reflected bit
	.byte #%01111111  ;RXXXXXXX
	.byte #%11110110  ;XXXXRXXR
	.byte #%01101111  ;RXXRXXXX
	.byte #%10111100  ;X XXXX R
	.byte #%00111101  ;R XXXX X
	.byte #%10011000  ;X  XX  R
	.byte #%00011010  ; R XX X   
	.byte #%01000000  ; X    R   
	.byte #%00000100  ;  R  X  
	.byte #%00010000  ;   XR
Sprite_Data10;4 bytes Small Base
	.byte #%00111110
	.byte #%00111110
	.byte #%00011100
	.byte #%00001000
Sprite_Shield
	.byte #%00111100
	.byte #%01000010
	.byte #%10011001
	.byte #%10111101
	.byte #%10100101
	.byte #%10110101
	.byte #%10101101
	.byte #%10100101
	.byte #%10111101
	.byte #%10011001
	.byte #%01000010
	.byte #%00111100

;---------------------------------------------------------------------------------------------------
;Enemy Movements read 8,4,2,1
MoveTab
	.byte <MoveTable0
    	.byte <MoveTable1
	.byte <MoveTable2
	.byte <MoveTable3
	.byte <MoveTable4
	.byte <MoveTable5
	.byte <MoveTable6
	.byte <MoveTable7
	
MoveTable0
	.byte #1,#0,#1,#0,#1,#0,#1,#0
MoveTable1
	.byte #-1,#0,#1,#0,#-1,#0,#-1,#0
MoveTable2
	.byte #1,#0,#1,#0,#1,#0,#1,#0
MoveTable3
	.byte #-1,#0,#1,#0,#-1,#0,#-1,#0
MoveTable4
	.byte #1,#0,#1,#1,#1,#0,#1,#0
MoveTable5
	.byte #-1,#0,#1,#1,#-1,#0,#-1,#0
MoveTable6
	.byte #1,#0,#1,#1,#1,#0,#1,#0
MoveTable7
	.byte #-1,#0,#1,#0,#-1,#0,#-1,#0
XPosTable:
	.byte 30, 35, 40, 60, 70, 30, 60, 35
	
	
 
	echo "***", (*-PFData0), "BYTES USED HERE TO PFData0"
	;206 BYTES USED HERE TO PFData0
	
	org $FFFC
	.word Start
	.word Start

			