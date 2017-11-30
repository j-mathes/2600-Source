;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Attack Of The Mighty Aliens From Outer Space		     ;	
;by Maciej Kozlowski					     ;
;matzieq@poczta.onet.pl					     ;
;please, don't laugh at this...				     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	processor 6502
	include vcs.h

	org $F000
	SEG.U VARS
	ORG $80	



Ship_Y = #50			;ship y is a constant - it doesn't change during the game
Ufo_Y ds 1
Player_Missile_Y ds 1		;player's missile
Ufo_Missile_Y ds 1

Ship_X ds 1			;used in moving the ship to make sure it doesn't leave the
				;screen

Visible_Ship_Line ds 1		;these variables are used to store the actual lines
Visible_Ufo_Line ds 1		;of graphics to draw
Visible_Score_Line ds 1
Visible_Missile_Line ds 1
Visible_Ufo_Missile_Line ds 1

ShipBuffer ds 1			;used to store actual line of graphics data

Ufo_HP ds 1			;parameter's of ufo: it's 'hit points'
Ufo_Speed ds 1			;horizontal speed
Ufo_Move_Frequency ds 1		;how many frames to wait before it moves
Ufo_Moves ds 1			;and the counter for it
Ufo_Pos_Count ds 1		;frequency of the ufo descents
Ufo_Descending ds 1		;counter for it

Ufo_Chdir ds 1			;a counter to make sure, that ufo doesn't get stuck on the wall

UfoBuffer ds 1			;line of graphics data 


Lives ds 1			;number of remaining lives 
Score_Low ds 1			;two bytes of score in BCD - from 0 to 9999
Score_High ds 1

Extra_Life ds 1			;in any politically corect game
;Extra_Life_Counter ds 1		;player must get extra lives

Left_Score ds 1			;these store values to display as playfield	
Right_Score ds 1

Digit1_Offset ds 1		;these are used to access the right data for each digit 
Digit2_Offset ds 1		;to display
Digit3_Offset ds 1
Digit4_Offset ds 1
Digit1_Buffer ds 6		;this data is stored in these variables, for quick use
Digit2_Buffer ds 6		;in the kernel
Digit3_Buffer ds 6
Digit4_Buffer ds 6

Life_Loss ds 1			;indicator of the fact, that life has been lost
Lives_Offset ds 1		;offset to right data (like in score offsets)
Lives_Buffer ds 6		;and identical buffer
		

WhichSound ds 1			;chooses the sound to play
FireNoiseOn ds 1		;duration of the sound

GameStarted ds 1		;indicates that game is on!

Ufo_Frame_Offset ds 1		;this is used for displaying particular frame of the
Current_Ufo_Frame_Offset ds 1	;ufo

BKG_Noise ds 1




Score_Temp ds 1			;a variable used to store temporary values during counting
				;score

Frame_Destroy_Duration ds 1	;this stores duration of the life loss sequence

Writing_Color ds 1
GameOver ds 1			;if the game is over, we gotta know it!


Note_Duration = #55

Note_Counter ds 1
Note_Duration_Counter ds 1


	SEG 
	org $F000



;THE BEGINNING OF ALL THIS......
Start
	SEI
	CLD
	LDX #$FF
	TXS
	
	LDA #0
Clear
	STA 0,X
	DEX
	BNE Clear

	STA COLUBK
	STA AUDV0
	STA AUDV1

	;LDA #8
	;STA Note_Counter


	JMP GameOverSequence
Reset
	SEI
	CLD
	LDX #$FF
	TXS
	
	LDA #0
Clear2
	STA 0,X
	DEX
	BNE Clear2

	STA COLUBK

	LDA #$1E
	STA COLUP0		;color of the ship
	LDA #$24
	STA COLUP1		;color of the ufo

	LDA #$1E	
	STA COLUPF		;color of the playfield

	LDA #3
	STA Lives		;store the number of lives
	LDA #5
	STA Ufo_Move_Frequency	
	STA Ufo_Moves
	
 	LDA #1
	STA Ufo_Speed		;ufo goes slowly at the beginning
	LDA #149
	STA Extra_Life
	
	
	LDA #8
	STA Ufo_HP		;you need to hit the ufo 8 times before you destroy it
	LDA #20
	STA FireNoiseOn		;it must be initialised with something
	LDA #199
	STA Ufo_Y
	LDA #100
	STA Ufo_Descending
	STA Ufo_Pos_Count
	;LDA #200
	;STA Ufo_Chdir
	LDA #32
	STA Ufo_Frame_Offset
	LDA #$F0
	STA HMP1
	LDA #7
	STA NUSIZ1
	LDA #0
	STA GameOver
	
	

;HERE WE START WITH THE FRAME


Frame
	LDA #2			;VSYNC
	STA VSYNC
	STA WSYNC
	STA WSYNC
	STA WSYNC
	
	LDA #43			;set the timer so that we know, when the VBLANK ends
	STA TIM64T
	LDA #0
	STA VSYNC
	STA ShipBuffer	
	
	LDA GameStarted		;it checks if game is on
	BNE JoyHandling
	STA RESP0
	STA RESP1
	LDA #1
	STA GameStarted


;JOYSTICK HANDLING



JoyHandling

	
	LDA SWCHB
	AND #%00000001
	BNE Ok
	JMP Reset

	LDA GameOver
	BEQ Ok
	JMP Wait
Ok
	
	LDX #0			;ok, so now we'll handle the joystick 
	
	LDA #%01000000 		;Left
	BIT SWCHA
	BNE NoLeft
	
	LDY Ship_X		;check, if ship is not too far on the left
	CPY #0
	BEQ NoLeft		;if so, dont move him
	
	CLC
	LDX #$20	
	LDA Ship_X
	ADC #1
	STA Ship_X

NoLeft

	LDA #%10000000 		;Right
	BIT SWCHA
	BNE NoRight
	
	LDY Ship_X		;check, if ship is not too far on the right
	CPY #180
	BEQ NoRight		;if so, dont move him

	SEC
	LDX #$E0
	LDA Ship_X
	SBC #1
	STA Ship_X

NoRight
	
	STX HMP0		;if player didn't move the joystick, 0 will be written
	
	LDA INPT4		;fire
	BMI NoFire
	
	LDA Player_Missile_Y
	BNE NoFire
	LDA Ship_Y		;if missile's not already on the screen
	STA Player_Missile_Y	;set it's Y equal to ship's Y
	LDA #2
	STA RESMP0		;and set it's x position 
	LDA #0
	STA RESMP0
	STA WhichSound
	LDA #5
	STA FireNoiseOn  
NoFire
	LDA #1			;set the (very) simple playfield
	STA CTRLPF
	LDA #%00110000
	STA PF0
	LDA #0
	STA PF1
	STA PF2


;MOVING THE OBJECTS
	

RestOfCode
	LDA Player_Missile_Y 		;now, we move the missile
	BEQ NoMovePlayerMissile
	INC Player_Missile_Y
	INC Player_Missile_Y
	INC Player_Missile_Y
	INC Player_Missile_Y
	INC Player_Missile_Y
	INC Player_Missile_Y
	INC Player_Missile_Y
	INC Player_Missile_Y
	LDY #234
	CPY Player_Missile_Y		;if missile is on the top of the screen
	BNE NoMovePlayerMissile
	LDA #0				;we disable it
	STA Player_Missile_Y
	

NoMovePlayerMissile

	

	LDA Ufo_Frame_Offset
	STA Current_Ufo_Frame_Offset
	

	DEC Ufo_Descending		;check, if the ufo should go down
	LDA Ufo_Descending
	BNE NoDescend
	LDA Ufo_Pos_Count		;begin the countdown again
	STA Ufo_Descending
	LDA Ufo_Y
	SEC
	SBC #8
	STA Ufo_Y
	LDA #8
	STA BKG_Noise
	

NoDescend
	
	LDA Ufo_Y			;if ufo is too low, player loses a life
	CMP Ship_Y			
	BCS NoLifeLoss	
	LDA #1				
	STA Life_Loss
	LDA #155			;store the duration of lifeloss sequence
	STA Frame_Destroy_Duration
	DEC Lives


NoLifeLoss
	


Wait			;wait for VBLANK end
	LDA INTIM
	BNE Wait
	
	LDY #200	;number of scanlines. I want PAL stuff!
	STA WSYNC
	STA HMOVE
	STA VBLANK

Line
	STA WSYNC
	LDA ShipBuffer	;I use the Kirk Israel's method PlayerBufferStuffer(R) :)
	STA GRP0	;it works fine
	LDA UfoBuffer
	STA GRP1

MissileActive
	
	CPY Player_Missile_Y		;now we check if the missile is active
	BNE UfoMissileActive
	
	LDA #2				;if so, enable it
	STA ENAM0
	LDA #6				;6 lines long
	STA Visible_Missile_Line
	;LDA #$77
	;STA COLUP0			;other color than ship
	;JMP DrawMissile

UfoMissileActive
	
	CPY Ufo_Missile_Y		;now we check if the missile is active
	BNE SkipUfoMissileActive
	
	LDA #2				;if so, enable it
	STA ENAM1
	;LDA #6				;6 lines long
	;STA Visible_Ufo_Missile_Line
	;LDA #$77
	;STA COLUP1			;other color than ship
	JMP DrawMissile

SkipUfoMissileActive
	;LDA Visible_Ufo_Missile_Line	;enable the missile if it still has to be visible
	;BNE DrawMissile
	LDA #0
	STA ENAM1


SkipMissileActive
	;LDA Visible_Missile_Line	;enable the missile if it still has to be visible
	;BNE DrawMissile
	;LDA #0
	;STA ENAM0



DrawMissile
	DEC Visible_Missile_Line
	BNE EndDrawingMissile
	LDA #0
	STA ENAM0
EndDrawingMissile
	
ShipActive			;check if the ship is active in this line
	CPY Ship_Y
	BNE SkipShipActive
	LDA #15			;number of lines in the ship's sprite
	STA Visible_Ship_Line
	LDA #$1E	
	STA COLUP0	
SkipShipActive
	

	LDA #0
	STA ShipBuffer

	LDX Visible_Ship_Line	;if we've drawn the whole ship
	BEQ EndOfDrawingShip	;draw no more

	LDA ShipSprite-1,X	;choose the correct line
	STA ShipBuffer		;and store it in the buffer
	
	DEC Visible_Ship_Line	;then go to the next one

EndOfDrawingShip
	STA WSYNC
	DEY

UFoActive			;check if the ufo is active in this line
	CPY Ufo_Y
	BNE SkipUfoActive
	LDA #4			;number of lines in the ufo's sprite
	STA Visible_Ufo_Line

SkipUfoActive
	

	LDA #0
	STA UfoBuffer
	LDX Current_Ufo_Frame_Offset
	;STX COLUP1
	LDA Visible_Ufo_Line	;if we've drawn the whole ufo
	BEQ EndOfDrawingUfo	;draw no more

	LDA UfoSprite-1,X	;choose the correct line
	STA UfoBuffer		;and store it in the buffer
	
	DEC Visible_Ufo_Line	;then go to the next one
	DEC Current_Ufo_Frame_Offset

EndOfDrawingUfo
	DEY
	BNE Line
	LDA #0
	STA CTRLPF		;we clear all the trash that may lie in playfield regs
	STA PF0
	STA PF1
	STA PF2
	

	LDA #41			;ok, stop and take a breath!
	STA TIM64T		;we'll waste the next 32(!) lines to calculate what we want
				;to display in last 5, because it's a bit complicated
				;(as I don't know any tricks, that would probably do this
				;in 2 machine cycles)
				;I didn't actually count how many lines we have to waste
				;I just want to be sure all I want fits in here
				;and if I'd want to put something else here, that I'll be able
	LDA #0
	STA Score_Temp

	LDA Score_Low
	AND #%00001111		;we want the right digit of low score byte
	STA Score_Temp		;this is the method used in Combat
	ASL			;multiplying by 5 in tricky way
	ASL
	CLC
	ADC Score_Temp
	
	STA Digit1_Offset	;now we know what part of digit data to display!

	LDA Score_Low		;we want left digit of low score byte
	AND #%11110000
	LSR			;multiplying by 5 in even stranger and more mysterious way
	LSR			
	STA Score_Temp
	LSR
	LSR
	CLC
	ADC Score_Temp
	
	
	STA Digit2_Offset	;now we know what part of digit data to display!
	
	LDA Score_High
	AND #%00001111		;we want the right digit of high score byte
	STA Score_Temp		
	ASL
	ASL
	CLC
	ADC Score_Temp
	
	STA Digit3_Offset	;now we know what part of digit data to display!

	LDA Score_High		;we want left digit of low score byte
	AND #%11110000
	LSR
	LSR
	STA Score_Temp
	LSR
	LSR
	CLC
	ADC Score_Temp
	
	
	STA Digit4_Offset	;now we know what part of digit data to display!

	LDA Lives		;now we want to display lives
	
	STA Score_Temp		
	ASL
	ASL
	CLC
	ADC Score_Temp
	
	STA Lives_Offset	;now we know what part of digit data to display!

	LDX #6
	LDA #0
ZeroBuffer			;zero the buffers of digits - just in case
	DEX 
	
	STA Digit1_Buffer,X
	STA Digit2_Buffer,X
	STA Digit3_Buffer,X
	STA Digit4_Buffer,X
	STA Lives_Buffer,X
	CPX #0
	BNE ZeroBuffer

	LDX #6

FillBuffer				;okay, so this fills buffers with digit data
					;it's partly thinked out, and partly (mostly;)
	DEX				;worked by experimenting
					;I don't really know why It works:) I just can
	LDY Digit1_Offset		;point the instructions that made it work
	LDA Digits-1,Y			;I did this by the trials and errors method
	AND #$F0			;don't kill me
	STA Digit1_Buffer,X		;as long as it works (and it does) I'm happy
					;this is what it's supposed to be:
	LDY Digit2_Offset		;count down from 5 to 0, on each cycle 
	LDA Digits-1,Y			;read data pointed by digit offsets
	AND #$0F			;shifted by the counter
	STA Digit2_Buffer,X
	
	LDY Digit3_Offset
	LDA DigitsCorrect-1,Y
	AND #$0F
	STA Digit3_Buffer,X

	LDY Digit4_Offset
	LDA DigitsCorrect-1,Y
	AND #$F0
	STA Digit4_Buffer,X	

	LDY Lives_Offset
	LDA DigitsCorrect-1,Y
	AND #$0F
	STA Lives_Buffer,X	

	INC Digit1_Offset		
	INC Digit2_Offset		
	INC Digit3_Offset		
	INC Digit4_Offset	
	INC Lives_Offset	
	CPX #0
	BNE FillBuffer

	LDA #0				;this is what cleared trash which appeared
	STA Lives_Buffer+5		;along with the lives number
	
	LDA Ufo_Missile_Y 		;now, we move the Ufo missile
	BEQ NoMoveUfoMissile
	DEC Ufo_Missile_Y
	;DEC Ufo_Missile_Y
	;DEC Ufo_Missile_Y
	LDY #10
	CPY Ufo_Missile_Y		;if missile is on the top of the screen
	BNE NoMoveUfoMissile
	LDA #0				;we disable it
	STA Ufo_Missile_Y
	

NoMoveUfoMissile

	LDA Ufo_Missile_Y
	BNE NoUfoFire
	LDA Ufo_Y		;if missile's not already on the screen
	STA Ufo_Missile_Y	;set it's Y equal to ship's Y
	LDA #2
	STA RESMP1		;and set it's x position 
	LDA #0
	STA RESMP1
	STA WhichSound
	LDA #6
	STA FireNoiseOn  
NoUfoFire

	LDA Extra_Life
	BNE MakeNoise
	LDA #149
	STA Extra_Life
	INC Lives
MakeNoise
	LDA BKG_Noise
	BNE NoSilence
	LDA #0
	STA AUDV1
	JMP EndOfMakingNoise
	
NoSilence
	DEC BKG_Noise
	LDA #10
	STA AUDF1
	LDA #10
	STA AUDC1
	LDA #14
	STA AUDV1

EndOfMakingNoise

WaitForCalculationsEnd
	LDA INTIM
	BNE WaitForCalculationsEnd


	LDY #7
	LDA #6
	STA Visible_Score_Line		
	LDA #0				;and these cleared trash which appeared
	STA Left_Score			;with the score
	STA Right_Score
	;STA Lives_Line
ScoreLine			;these lines will be used to display game score and lives
	STA WSYNC
	LDA #0
	STA PF1
	STA PF2
	LDX Visible_Score_Line
	BEQ EndLine

	DEX				;why two of them? It works, so don't
	DEX				;ask stupid questions!
					

	LDA Left_Score			;store data in the playfield regs
        STA PF1	
	LDA Right_Score
	STA PF2
	

	LDA Digit3_Buffer,X	;here we send the actual digit data to the playfield registers
	ORA Digit4_Buffer,X
	STA Left_Score
	

	LDA Lives_Buffer+1,X		;and here we display lives
	STA PF1
	
	
	LDA Digit1_Buffer,X
	ORA Digit2_Buffer,X
	STA Right_Score
	
	LDA #0				;it's a damn assymetrical playfield!
	STA PF2				;and I didn't actually count cycles
					;how I made it work?
					;hmm....
					;nice weather today, isn't it? :-P
					;and seriously: just trials and errors...
	

	DEC Visible_Score_Line		

EndLine
	DEY
	BNE ScoreLine
	LDA GameOver
	BEQ ContinueGame
	JMP HereFromScoreLine
ContinueGame

	LDA #2
	STA WSYNC
	STA VBLANK	
	

Overscan
	LDA #42			;set the timer so that we know, when the Overscan ends
	STA TIM64T
	
	LDA WhichSound		;which sound we have to play?
	BNE Other
	LDY FireNoiseOn		;this section is for firing noise
				;we're checking if there's something to play
	CPY #20
	BEQ TurnOff		;if not, we turn the sound off
	LDA #1			
	STA AUDC0
	LDA FireNoiseOn
	STA AUDF0
	LDA #8
	STA AUDV0
	INC FireNoiseOn
	JMP EndOfPlay
Other
	LDY FireNoiseOn		;this section is for explosion sound
	BEQ TurnOff
	STY AUDV0
	LDA #15
	STA AUDC0
	LDA #30
	STA AUDF0
	
	DEC FireNoiseOn
	JMP EndOfPlay

TurnOff					;and here we turn the sound off, when it finishes
	LDA #0			
	
	STA AUDF0
	STA AUDV0

EndOfPlay
	


	

	LDA #%10000000			;this deals with direction changing
	BIT CXP1FB			;if ufo collides with the PF
	BEQ NoChange	
	
	LDA Ufo_Speed			;change it's speed signum to opposite
	EOR #%00001111			;god bless the one who invented U2 code
	CLC
	ADC #1
	
	STA Ufo_Speed			

	LDA #100			;then load this little counter, so that ufo
	STA Ufo_Chdir			;doesn't go crazy
	


NoChange
		
	DEC Ufo_Chdir			;if the counter is not zero yet
	LDA Ufo_Chdir			;we can't change directions
	BNE NoZero			;the ufo doesn't get stuck
	LDA #0				;when it touches the walls
	STA CXCLR
NoZero
	
	LDA #%10000000			;here we check if player's 'photon torpedo';) hit the ufo
	BIT CXM0P
	BNE Gut
	JMP NoHit			;if not, go on with the code
Gut
	LDA #226			;reset the missile (in the next Vblank)
	STA Player_Missile_Y
	LDA #1				;signal to make noise
	STA WhichSound
	LDA #15	
	STA FireNoiseOn
	DEC Ufo_HP			;dec hit points of the ufo
	LDA Ufo_HP			;if zero, make new ufo
	BEQ KillUfo			
	LDA Ufo_Frame_Offset		;now, update the offset so that we see the correct frame
	SEC
	SBC #4
	STA Ufo_Frame_Offset	
	SED
	LDA Score_Low			;we add a 1 to player's score (in BCD)
	CLC
	ADC #1
	STA Score_Low
	LDA Score_High
	ADC #0
	STA Score_High
	CLD
	DEC Extra_Life
	JMP NoHit

KillUfo
	LDA #8				;restore ufo's endurance and bring it back to the top
	STA Ufo_HP			;of the screen
	LDA #199
	STA Ufo_Y
	LDA #32				;restore the frame counter
	STA Ufo_Frame_Offset
	STA RESP1
	SED
	LDA Score_Low			;give player points
	CLC
	ADC #1
	STA Score_Low
	LDA Score_High
	ADC #0
	STA Score_High
	CLD
	DEC Extra_Life
	LDX #5
GoDown
	DEC Ufo_Pos_Count		;shorten the time in which ufo descends
	DEX
	BNE GoDown
	LDA Ufo_Pos_Count
	CMP #10
	BCS Desc			;if it reaches 10(frames)
	LDA Ufo_Move_Frequency		;then if the frequency is greater than 1, decrease it
	CMP #1
	BEQ IncreaseSpeed
	DEC Ufo_Move_Frequency
	DEC Ufo_Move_Frequency
	LDA #60				;set the speed again
	JMP Desc			

IncreaseSpeed				;and if frequency is equal to 1
	LDA Ufo_Speed			;check, if speed is not negative
	CMP #7
	BCS ChangeSpeed
			
	JMP DealWithSpeed
ChangeSpeed				;if it is, change it into positive
	EOR #%00001111
	CLC
	ADC #1
	STA Ufo_Speed

DealWithSpeed
	LDA Ufo_Speed
	CMP #2
	BCS Desc
	INC Ufo_Speed	
	LDA Ufo_Speed			;increment speed, load it into A
	ROL				;shift left 4 times and store as horizontal speed)
	ROL
	ROL
	ROL
	STA HMP1
	LDA #60
	
Desc
	STA Ufo_Descending
	STA Ufo_Pos_Count
NoHit

	LDA #%10000000			;if ufo hits, player loses a life
	BIT CXM1P			
	BEQ NoLifeLossFromMissile	
	LDA #1				
	STA Life_Loss
	LDA #155			;store the duration of lifeloss sequence
	STA Frame_Destroy_Duration
	DEC Lives
	LDA #0
	STA Ufo_Missile_Y
NoLifeLossFromMissile

	STA CXCLR			;and now, clear the collision registers	

	DEC Ufo_Moves
	BNE NoMove
	LDA Ufo_Move_Frequency
	STA Ufo_Moves
	LDA Ufo_Speed
	ROL				;shift left 4 times and store as horizontal speed)
	ROL
	ROL
	ROL
	STA HMP1
	JMP AfterMove
NoMove
	LDA #0				
	STA HMP1
AfterMove
	
	
	
WaitOverscan			;wait for Overscan end
	LDA INTIM
	BNE WaitOverscan	
	

	LDA Life_Loss		;if player lost a life during this frame
	BNE FrameDestroy	;jump to the other kernel
	JMP Frame


FrameDestroy			;this frame is used, when player loses a life
	LDA #2			;VSYNC
	STA VSYNC
	STA WSYNC
	STA WSYNC
	STA WSYNC
	
	LDA #43			;set the timer so that we know, when the VBLANK ends
	STA TIM64T
	LDA #0
	STA VSYNC
	STA AUDV1
	LDA Lives
	BNE NotYetOver
	LDA #1
	STA GameOver
	
NotYetOver
	LDA #0
	STA PF0			;clear the playfield
	STA PF1
	STA PF2
	LDA #199
	STA Ufo_Y
	LDA Frame_Destroy_Duration	;some audio-visual effects:)
	CMP #128
	BCC Effects
	LDA #2
	STA AUDC0
	LDA #10
	STA AUDV0
	LDA Frame_Destroy_Duration
	SEC
	SBC #128
	STA AUDF0
	JMP EndOfEffects

Effects
	LDA Frame_Destroy_Duration	;even more effects
					;I won't comment, 'cause they're pretty simple and cheap

	STA COLUBK
	
	LDA #7
	STA AUDC0
	LDA #10
	STA AUDV0
	LDA Frame_Destroy_Duration
	AND #%00001111
	CLC
	ADC #10
	STA AUDF0

EndOfEffects
	DEC Frame_Destroy_Duration
Wait2
	LDA INTIM
	BNE Wait2

	LDY #241
	STA WSYNC
	STA VBLANK
LineOfTheOtherFrame			;here we do absolutely nothing!
	STA WSYNC
	
	DEY
	BNE LineOfTheOtherFrame
	LDA #2
	STA WSYNC
	STA VBLANK
	LDY #30				
DestroyOverscan				;and here also!
	STA WSYNC			
	DEY
	BNE DestroyOverscan
	LDA GameOver
	BNE GameOverSequence
	LDA Frame_Destroy_Duration
	BNE NextFrame			;if we ended the sequence
	LDA #0				;indicate it
	STA Life_Loss
	STA AUDV0			;silence, please!
	JMP Frame			;and go back into action!
NextFrame
	JMP FrameDestroy		;or, do that again


GameOverSequence			;This displays gameover
	LDA #2			;VSYNC
	STA VSYNC
	STA WSYNC
	STA WSYNC
	STA WSYNC
	
	LDA #43			;set the timer so that we know, when the VBLANK ends
	STA TIM64T
	LDA #0
	STA VSYNC
	LDA #$1E	
	STA COLUPF		;color of the playfield
	;LDA #8
	;STA AUDV0		
	;STA AUDV1
	LDA #13
	STA AUDC0
	LDA #10
	STA AUDC1
	INC Writing_Color

	LDA SWCHB		;on reset - start the game
	AND #%00000001
	BNE NoReset
	LDA #0
	STA AUDV0
	STA AUDV1
	JMP Reset
NoReset
	


	LDA Note_Duration_Counter		;play some music
	BNE KeepPlaying
	LDA Note_Duration
	STA Note_Duration_Counter
	LDA Note_Counter
	CMP #16
	BNE PlayNewNote
	LDA #0
	STA Note_Counter

PlayNewNote
	LDX Note_Counter
	LDA MusicData,X
	STA AUDF0
	LDA MusicData+16,X
	STA AUDF1
	LDA MusicData+32,X
	STA AUDV0
	LDA MusicData+48,X
	STA AUDV1
	INC Note_Counter
KeepPlaying
	DEC Note_Duration_Counter
Wait3
	LDA INTIM
	BNE Wait3

	LDY #96
	STA WSYNC
	STA VBLANK
LineGameOver		
	STA WSYNC
	LDA #0
	STA PF1
	STA PF2
	DEY
	BNE LineGameOver
	
	LDY #5
	LDA Writing_Color
	STA COLUPF

LineGameOver2					;display title and my initials ;)
	STA WSYNC
	
	LDA GameOverBytes-1,Y
	STA PF1
	LDA GameOverBytes+4,Y
	STA PF2
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
	NOP
	NOP
	LDA GameOverBytes+9,Y
	STA PF1
	LDA GameOverBytes+14,Y
	STA PF2

	STA WSYNC
	
	LDA GameOverBytes-1,Y
	STA PF1
	LDA GameOverBytes+4,Y
	STA PF2
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
	NOP
	NOP
	LDA GameOverBytes+9,Y
	STA PF1
	LDA GameOverBytes+14,Y
	STA PF2

	DEY
	BNE LineGameOver2

	
	LDY #4
	
LineGameOver25		
	STA WSYNC
	LDA #0
	STA PF1
	STA PF2
	DEY
	BNE LineGameOver25
	LDY #5
	LDA #$1E	
	STA COLUPF		
LineGameOver3		
	STA WSYNC	
	LDA GameOverBytes+19,Y
	STA PF1
	
	LDA GameOverBytes+24,Y
	STA PF2
	
	STA WSYNC
	STA WSYNC
	DEY
	BNE LineGameOver3
	LDY #110
	
LineGameOver4		
	
	STA WSYNC
	LDA #0
	STA PF1
	STA PF2
	DEY
	BNE LineGameOver4

	LDY #7
	LDA #6
	STA Visible_Score_Line		
	LDA #0				
	STA Left_Score			
	STA Right_Score
	JMP ScoreLine			;display score
HereFromScoreLine
	LDA #2
	STA WSYNC
	STA VBLANK
	LDY #30				
GameOverOverscan				
	STA WSYNC			
	DEY
	BNE GameOverOverscan
	
	JMP GameOverSequence

	

ShipSprite
	
	.byte #%10000010
	.byte #%11000110
	.byte #%11000110	
	.byte #%11101110
	.byte #%01101100
	.byte #%01111100
	.byte #%01101100
	.byte #%01000100
	.byte #%01000100
	.byte #%01101100
	.byte #%00101000
	.byte #%00111000
	.byte #%00111000
	.byte #%00010000
	.byte #%00010000



UfoSprite

	.byte #%00010000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000

	.byte #%00011000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000

	.byte #%00001000
	.byte #%00011100
	.byte #%00000000
	.byte #%00000000

	.byte #%00011000
	.byte #%00111100
	.byte #%00000000
	.byte #%00000000

	.byte #%00011100
	.byte #%00111110
	.byte #%00001000
	.byte #%00000000

	.byte #%00111100
	.byte #%01111110
	.byte #%00011000
	.byte #%00000000

	.byte #%00001000
	.byte #%00111110
	.byte #%01111111
	.byte #%00011100

	.byte #%00011000
	.byte #%01111110
	.byte #%11111111
	.byte #%00111100

Digits				;these are reversed, 'cause the PF2 is reversed
				;oh, Lord....
	.byte #%11101110
	.byte #%10101010
	.byte #%10101010
	.byte #%10101010
	.byte #%11101110

	.byte #%01000100
	.byte #%01100110
	.byte #%01000100
	.byte #%01000100
	.byte #%11101110
	
	.byte #%11101110
	.byte #%10001000
	.byte #%11101110
	.byte #%00100010
	.byte #%11101110

	.byte #%11101110
	.byte #%10001000
	.byte #%11101110
	.byte #%10001000
	.byte #%11101110

	.byte #%10101010
	.byte #%10101010
	.byte #%11101110
	.byte #%10001000
	.byte #%10001000

	.byte #%11101110
	.byte #%00100010
	.byte #%11101110
	.byte #%10001000
	.byte #%11101110

	.byte #%11101110
	.byte #%00100010
	.byte #%11101110
	.byte #%10101010
	.byte #%11101110

	.byte #%11101110
	.byte #%10001000
	.byte #%10001000
	.byte #%10001000
	.byte #%10001000

	.byte #%11101110
	.byte #%10101010
	.byte #%11101110
	.byte #%10101010
	.byte #%11101110

	.byte #%11101110
	.byte #%10101010
	.byte #%11101110
	.byte #%10001000
	.byte #%11101110


DigitsCorrect

	.byte #%01110111
	.byte #%01010101
	.byte #%01010101
	.byte #%01010101
	.byte #%01110111

	.byte #%00100010
	.byte #%01100110
	.byte #%00100010
	.byte #%00100010
	.byte #%01110111
	
	.byte #%01110111
	.byte #%00010001
	.byte #%01110111
	.byte #%01000100
	.byte #%01110111

	.byte #%01110111
	.byte #%00010001
	.byte #%01110111
	.byte #%00010001
	.byte #%01110111

	.byte #%01010101
	.byte #%01010101
	.byte #%01110111
	.byte #%00010001
	.byte #%00010001

	.byte #%01110111
	.byte #%01000100
	.byte #%01110111
	.byte #%00010001
	.byte #%01110111

	.byte #%01110111
	.byte #%01000100
	.byte #%01110111
	.byte #%01010101
	.byte #%01110111

	.byte #%01110111
	.byte #%00010001
	.byte #%00010001
	.byte #%00010001
	.byte #%00010001

	.byte #%01110111
	.byte #%01010101
	.byte #%01110111
	.byte #%01010101
	.byte #%01110111

	.byte #%01110111
	.byte #%01010101
	.byte #%01110111
	.byte #%00010001
	.byte #%01110111


GameOverBytes
	

	.byte #%10101110
	.byte #%10101010
	.byte #%11101010
	.byte #%10101010
	.byte #%11101110

	.byte #%10010010
	.byte #%10010010
	.byte #%10010010
	.byte #%11010010
	.byte #%10110111

	.byte #%10101000
	.byte #%10101000
	.byte #%11101100
	.byte #%10101000
	.byte #%11101110

	.byte #%01110111
	.byte #%01000101
	.byte #%01110101
	.byte #%00010101
	.byte #%01110111

	.byte #%10000001
	.byte #%10000001
	.byte #%10011001
	.byte #%10100101
	.byte #%11000011

	.byte #%10000100
	.byte #%01100100
	.byte #%00011100
	.byte #%01100100
	.byte #%10000100

MusicData

;TRACK 1
	.byte #23
	.byte #23
	.byte #19
	.byte #23


	.byte #23
	.byte #26
	.byte #23
	.byte #17
	
	.byte #19
	.byte #19
	.byte #19
	.byte #17


	.byte #23
	.byte #23
	.byte #23
	.byte #23

;TRACK 2
	.byte #13
	.byte #13
	.byte #13
	.byte #13


	.byte #26
	.byte #26
	.byte #13
	.byte #13

	.byte #13
	.byte #13
	.byte #13
	.byte #26


	.byte #13
	.byte #26
	.byte #13
	.byte #13

;VOL TRK1
	.byte #0
	.byte #5
	.byte #6
	.byte #7

	.byte #0
	.byte #8
	.byte #9
	.byte #10

	.byte #7
	.byte #0
	.byte #7
	.byte #7

	.byte #5
	.byte #0
	.byte #5
	.byte #4

;VOL TRK2
	.byte #8
	.byte #8
	.byte #8
	.byte #8
	
	.byte #8
	.byte #8
	.byte #8
	.byte #8

	.byte #8
	.byte #8
	.byte #8
	.byte #8
	
	.byte #8
	.byte #8
	.byte #8
	.byte #8

	org $FFFC
	.word Start
	.word Start