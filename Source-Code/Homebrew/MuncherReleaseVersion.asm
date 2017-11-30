;;Muncher for Atari 2600
;;¨2011 Rick Skrbina 
;;
;;
;;ROM Size:	2K
;;
;;Started:		7/18/11
;;Finished:		6/25/13
;;Source Release:	9/3/13
;;
;;
;;Released for reference and educational purposes only.  Do not distribute or 
;;manufacture cartridges with out concent from Rick Skrbina
;;
;;For any questions or inquiries, please contact me via personal message on
;;AtariAge (user: Wickeycolumbus) or email (nubby1984@yahoo.com)
;;

	processor 6502

	include "vcs.h"
	include "macro.h"
;;Constants	
	
	
	
VerticalBlank_Time	equ #40
Overscan_Time		equ #37	
	
SpriteHeigth		equ #8-1		;12
PlayerHeigth		equ #3

Temp1			equ LineCounter



;;RAM usage


	seg.u	RIOT_RAM
	org	$0080
	
RFC			ds 1
FrameCounter		ds 1
MovmentCounter		ds 1
BlackCounter		ds 1

ButtonTimer		ds 1

BoardsCleared		ds 1
	
LineCounter		ds 1
Temp			ds 1
Temp2			ds 1
Temp3			ds 1

Debounce2		ds 1

CurrentGame		ds 1
CurrentWave		ds 1
GamePtr			ds 2

ScorePtr5		ds 2
ScorePtr3		ds 2
ScorePtr1		ds 2
ScorePtr4		ds 2
ScorePtr2		ds 2
ScorePtr0		ds 2

Score			ds 3

;;Enemy Movment
;;
;;X,Y
;;
;;D0,D1		E0 movment  D0 = 1 = move R D1 = 1 = U
;;D2,D3		E1 movment  D2 = 1 = move R D3 = 1 = U
;;D4		1 = game in play
;;D5		1 = advanced (one life, no bonus lives)
;;D6		1 = in between lives
;;D7		1 = game over

EnemyMovment		ds 1

DeathSoundCounter	ds 1
BlockClearCounter	ds 1
PointDropCounter	ds 1

ExtraLifeCounter	ds 1

PlayerX			ds 1
                 
PlayerY			ds 1
Enemy0Y			ds 1
Enemy1Y			ds 1

PlayerEnd		ds 1
Enemy0End		ds 1
Enemy1End		ds 1

Enemy0Index		ds 1
Enemy0X			ds 1

Enemy1X			ds 1	
Enemy1Index		ds 1	
Enemy1Color		ds 1

ObjectColor		ds 1
LastGameColor		ds 1

NumberOfLives		ds 1
CurrentLevel		ds 1

PlayerFastFlag		ds 1
FastPoints		ds 1

LevelColorST		ds 1
StoreColorPF		ds 1

LevelColor		ds 1
GreenColor		ds 1
BlueColor		ds 1
BlackColor		ds 1

BoardsToWave		ds 1
CurrentFastSpeed	ds 1

PF2ABuffer		ds 16
PF0BBuffer		ds 16
PF1BBuffer		ds 16



;;ROM code

	
	seg ROM_CODE
	org $1800
	
	
MainKernel

	ldx #$FF

	lda PlayerY
	bne DontPreEnablePlayer
	
	stx ENAM0
	
DontPreEnablePlayer
	
	lda #64-1
	sta LineCounter
	tya
	tax
	
	beq Picture
	
	
SkipDrawEnemy0
	nop			;2
	nop			;2
	lda #0			;2
	jmp DoneEnemy0		;3
	
SkipDrawEnemy1
	nop			;2
	nop			;2
	lda #0			;2
	jmp DoneEnemy1		;3


;;PF0A done at 28
;;PF1A done at 38.6666667
;;PF2A done at 49.3333333

;;PF0B done at 54.6666667
;;PF1B done at 65.3333333
;;PF2B done at 76


Picture
	sta WSYNC		;3
	
	sty PF0			;3
	sty PF1			;3	6
	
	ldy Enemy0Index		;3	9

	lda #SpriteHeigth	;2
	dcp Enemy0End		;5
	bcc SkipDrawEnemy0	;2	18

	lda Enemy0Graphics,Y	;4
	inc Enemy0Index		;5	27
	
DoneEnemy0
	
	ldy PF2ABuffer,X	;4
	sty PF2			;3	34
	
	ldy PF0BBuffer,X	;4
	sty PF0			;3	41
	
	ldy PF1BBuffer,X	;4
	sty PF1			;3	48
	
	sta GRP0		;3	51
	
	lda #0			;2
	sta PF2			;3	56
	sta PF0			;3	59
	sta PF1			;3	62
	
	ldy Enemy1Index		;3	65

	lda #SpriteHeigth	;2	67
	dcp Enemy1End		;5	72
	bcc SkipDrawEnemy1	;2	74

	lda Enemy0Graphics,Y	;4	2
	inc Enemy1Index		;5	7
	
DoneEnemy1

	sta GRP1		;3	10
	
	ldy #0			;2	12
	
	lda #PlayerHeigth	;2
	dcp PlayerEnd		;5
	bcc DonePlayer		;2	21
	
	dey			;2
	
DonePlayer

	sty ENAM0		;3	24	26
	
	lda PF2ABuffer,X	;4
	sta PF2			;3	31	33
	
	lda PF0BBuffer,X	;4
	sta PF0			;3	38	40
	
	lda PF1BBuffer,X	;4
	sta PF1			;3	45	47
	
	lda LineCounter		;3
	and #%00000011		;2
	bne NoNewPF		;2

	inx			;2
		
	
NoNewPF

	
	ldy #0			;2
	sty PF2

	
	dec LineCounter		;5	
	bpl Picture		;2

	sta WSYNC
	sty GRP0

	sty PF0
	sty PF1
	sty PF2

	lda GreenColor
	sta WSYNC
	sta COLUBK
	
	sta COLUPF
	
	sty ENAM0
	sty GRP1

	
	sty Enemy0Index
	sty Enemy1Index
Dummy	
	rts
	
Break
	
        sta HMCLR
        sec
        sta WSYNC         
PositionSpriteLoopb
        sbc    #15
        bcs    PositionSpriteLoopb

        eor    #7         
        asl
        asl
        asl
        asl               

        sta.wx HMP0,X     
        sta    RESP0,X   
        sta    WSYNC      
        sta    HMOVE   
	sta    WSYNC
	
	dec $FE		;adjust return address
	rti		;return from interrupt

FillBuffers

	ldx #$0F

FillBufferLoop

	lda #$FF

	sta PF2ABuffer,X
	lda #$F0
	sta PF0BBuffer,X	

	sta PF1BBuffer,X

	dex
	bpl FillBufferLoop
	
	sty PF2ABuffer+7
	
	rts
	
ReadJoystick

	ldy BoardsToWave



	lda PlayerFastFlag
	beq DoNotMoveFaster

	
	ldx FastPlayerSpeeds,Y
	stx CurrentFastSpeed
	lda FastPoints
	bne StoreMoveSpeed

	
	
;; Player speed control


DoNotMoveFaster

	
	ldx SlowPlayerSpeeds,Y

StoreMoveSpeed
	stx Temp

	inc MovmentCounter

	lda MovmentCounter
	cmp Temp
	bmi SkipJoystick


	
	lda #0
	sta MovmentCounter
	
	lda SWCHA
	and #$F0
	cmp #$F0
	beq SkipJoystick

	ldx Temp
	cpx CurrentFastSpeed
	bne DontDecFP
	
	dec FastPoints
	
DontDecFP

	asl
	bcs NoRight
	
	tax
	
	lda PlayerX
	clc
	adc #4
	sta PlayerX
	
	txa

NoRight

	asl
	bcs NoLeft
	
	tax
	
	lda PlayerX
	sec
	sbc #4
	sta PlayerX


	txa
NoLeft

	asl
	bcs NoDown
	
	tax
	
	lda PlayerY
	clc
	adc #4
	sta PlayerY

	txa
NoDown

	asl
	bcs SkipJoystick
	
	lda PlayerY
	sec
	sbc #4
	sta PlayerY

	
SkipJoystick

	

	rts
	
	
SetInitialValues
	
	
	
	ldx #3
	stx NumberOfLives
	
	stx EnemyMovment
	
	inx
	stx LevelColor
	
	ldx #2
	stx BoardsToWave
StoreColorLoop
	lda Colors,X
	sta GreenColor,X
	dex
	bpl StoreColorLoop
	
	
	lda #<Zero
	sta ScorePtr0
	sta ScorePtr1
	sta ScorePtr2
	sta ScorePtr3
	sta ScorePtr4
	sta ScorePtr5
	
	lda #24
	sta FastPoints
	
	ldx #$FF
	stx DeathSoundCounter
	stx BlockClearCounter
	stx PointDropCounter
	stx ExtraLifeCounter
	

	inx	
	stx Score
	stx Score+1
	stx Score+2
	stx CurrentLevel
	stx CurrentWave
	stx BoardsCleared


SetInitialPositions
	
	lda #76+1
	sta PlayerX
	
	lda #28
	sta Enemy1Y
	sta Enemy0Y
	sta PlayerY
	

	ldx #0
	stx Enemy0X

	
	inx
	stx BlackCounter
	
	
	ldx CurrentWave
	
	lda WaveE1Pos,X
	sta Enemy1X
	
	
	rts
	
Start

	CLEAN_START
	
	
	lda #>Graphics
	ldx #14
	
StorePtrLoop
	
	sta GamePtr+1,X
	dex
	dex
	bpl StorePtrLoop
	
		
	lda #8
	sta AUDC0
	lda #12
	sta AUDC1
	
	
	jmp ResetGame
	
	
StartFrame

	lda #%00001110
	
VerticalSync

	sta WSYNC
	sta VSYNC
	lsr
	bne VerticalSync
	
	lda #VerticalBlank_Time
	sta TIM64T

	
	lda #$35		;set some horizontal positions
	ldx #0
	brk
	lda #$3D
	inx
	brk
	inx
	lda PlayerX
	brk
	lda #10;+2
	inx
	brk
	
	ldx CurrentWave
	inx
	lda NumberPointers,X
	sta GamePtr
	
	
	ldx CurrentWave
	ldy WaveE1Color,X
	
	lda EnemyMovment
	and #%10000000
	beq NormalE1Color
	
	cpy #0
	bne NormalE1Color
	
	ldy BlackColor

NormalE1Color
	sty Enemy1Color
	
	lda FastPoints
	cmp #5
	bpl NormalPositioning
	
	tay
	lda HealthPositions,Y
	bne PositionBall	


NormalPositioning

	lda FastPoints
	sec
	sbc #3
	
PositionBall
	ldx #4
	brk
		
	ldx #2
ObjectEndLoop

	lda PlayerY,X
	clc
	adc ObjectHeigths,X
	sta PlayerEnd,X
	
	dex
	bpl ObjectEndLoop
	

	
VBLoop
	lda INTIM
	bne VBLoop
	
	sta WSYNC
	sta VBLANK
	

	
	ldy #10-1-2-1
GameDisplay

	sta WSYNC
	
	lda (GamePtr),Y
	sta GRP1
	
	dey
	bpl GameDisplay

	
	iny
	sta WSYNC
	sty GRP1

	
	lda #3
	sta NUSIZ0
	sta NUSIZ1
	sta VDELP0
	sta VDELP1
	

	sta WSYNC

	
	
;;Score kernel taken from Tempest (probably in other games too)
	

	
	lda #10-1-2-1
	sta Temp1
	
ScoreK

	ldy Temp1	

	lda (ScorePtr5),Y	;6
	sta GRP0		;3
	
	sta WSYNC
	
	lda (ScorePtr4),Y	;6
	sta GRP1		;3
	lda (ScorePtr3),Y	;6
	sta GRP0		;3	27

	
	lda (ScorePtr2),Y	;6
	sta Temp			;3
	lda (ScorePtr1),Y	;6
	tax	
	lda (ScorePtr0),Y	;6	48	
	tay


	lda Temp	

	sta GRP1
	stx GRP0
	sty GRP1
	sty GRP0
	

	
	dec Temp1
	bpl ScoreK
	

	ldx #0
	sta WSYNC
	stx VDELP0
	stx VDELP1
	stx GRP0
	stx GRP1
	
	
	ldy CurrentWave
	lda WaveNUSIZx,Y

	ldy #0
	
	sta NUSIZ1
	ora #%00100000
	sta NUSIZ0
	

	lda Enemy0X
	brk
	inx
	lda Enemy1X
	brk

	lda BlackColor
	sta WSYNC
	sta COLUBK
	
	
	lda Enemy1Color
	sta COLUP1

	
	sty Temp


	
	jsr MainKernel
	

	
	ldx #$1F
	sta WSYNC
	stx COLUP1
	stx COLUP0	


	ldx #2
	txa	
	brk

	
	ldy NumberOfLives
	lda LivesNUSIZ0Table,Y
	sta NUSIZ0
	lda LivesNUSIZ1Table,Y
	sta NUSIZ1
	
	lda LivesENAM0Table,Y
	ldx LivesENAM1Table,Y

	ldy #9
DisplayLives
	sta WSYNC
	stx ENAM1
	sta ENAM0
	dey
	bne DisplayLives
	
	sty ENAM0
	sty ENAM1
	sty NUSIZ1
	
	
	ldy #6+3+2+1
BottomBlank
	sta WSYNC
	dey
	bne BottomBlank
	
	
	sty GRP0
	sty GRP1

	
	lda #%00100001
	sta CTRLPF
	
	
	tsx
	stx ENABL
	
	lda BlueColor
	
	ldy #5
HealthBar

	sta WSYNC
	
;	lda #$FF		;2
;	sta ENABL		;3
	
;	lda HealthBarColor	;3
	sta COLUPF		;2
		
	lda FastPoints	;3
	lsr			;2
	lsr			;2
	tax			;2	14
	
	lda HealthPF0,X		;4*
	sta PF0			;3	
	lda HealthPF1,X		;4*
	sta PF1			;3	28
	
	
	jsr Dummy
	
	lda GreenColor
	sta COLUPF
	
	lda BlueColor
	
	dey
	bne HealthBar
	
	sty CTRLPF



	lda LevelColor	
	asl
	asl
	asl
	asl
	sta LevelColorST
	sta WSYNC
	sta COLUPF
	sty PF0
	sty PF1
	sty ENABL
	


	lda #2
	
	ldy #8-1+3+1-2
BBlank
	sta WSYNC
	dey
	bne BBlank


	sta VBLANK
	
	
	lda #Overscan_Time
	sta TIM64T
	
	
	
	lda SWCHB
	lsr
	bcs DontResetGame

	
	sty ButtonTimer
ResetGame	
	jsr SetInitialValues
	ldy #%01111111
	jsr FillBuffers
	
	lda EnemyMovment
	ora #%10000000
	sta EnemyMovment
	
	
DontResetGame
	



	lda EnemyMovment
	and #%00010000
	beq DontSubtractPoints

	lda PlayerX
	cmp #$31
	bmi NoBufferChange
	cmp #$71
	bpl NoBufferChange
	

	lda PlayerX
	lsr
	lsr
	
	sec
	sbc #12
	tax
	
	lda PlayerY
	lsr
	lsr
	tay

	
	lda PF2ABuffer,Y
	sta Temp
	and PF2AndTable,X
	sta PF2ABuffer,Y
	
	lda PF0BBuffer,Y
	sta Temp1
	and PF0AndTable,X
	sta PF0BBuffer,Y
	
	lda PF1BBuffer,Y
	sta Temp2
	and PF1AndTable,X
	sta PF1BBuffer,Y
	
	
	lda PF2ABuffer,Y
	cmp Temp
	bne AddPoints
	lda PF0BBuffer,Y
	cmp Temp1
	bne AddPoints
	lda PF1BBuffer,Y
	cmp Temp2
	beq DontAddPoints
	
	
	
AddPoints

	
	jsr UpdateFP
	
	lda #1
	sta BlackCounter
	
	sta BlockClearCounter

	bne DontIncBlockCounter
	
DontAddPoints
	                 
	

NoBufferChange

	inc BlackCounter
	
DontIncBlockCounter


	lda BlackCounter
	cmp #100
	bne DontSubtractPoints
	
	lda #0
	sta BlackCounter
	
	jsr SubtractPoint
	
DontSubtractPoints


	ldx #$0F
	
CheckBufferStatus

	lda PF2ABuffer,X
	bne BufferNotCleared
	lda PF0BBuffer,X
	bne BufferNotCleared
	lda PF1BBuffer,X
	bne BufferNotCleared
	
	dex
	bpl CheckBufferStatus
	
	;;board cleared
	
	ldy #$FF
	jsr FillBuffers
	
	inc CurrentLevel
	
	inc BoardsCleared
	
	
	lda BoardsCleared
	cmp BoardsToWave
	bne DoneLives
	
	lda #0
	sta BoardsCleared
	
	;;new wave
	
	lda EnemyMovment
	and #%11101111
	sta EnemyMovment
	

	ldx CurrentWave
	inx
	cpx #9	;8
	bne DontZeroWave
	
	;;wave roll over detected
	;;add point bonus here 
	
	inc BoardsToWave
	
	sed
	
	ldx NumberOfLives
AddBonusPoints	
	clc
	lda Score
	adc #1
	sta Score
	dex
	bpl AddBonusPoints
	
	jsr ClearDecimal
	
	ldx #0

DontZeroWave	
	
	stx CurrentWave		;original preserved from branch

	jsr SetInitialPositions
	
	
	
	lda #15
	sta ExtraLifeCounter
	
	tsx
	stx ButtonTimer
	
	
	ldy #%01111111
	jsr FillBuffers
	
	inc NumberOfLives
	lda NumberOfLives
	cmp #7
	bne DoneLives
	
	lda #6
	sta NumberOfLives
	
DoneLives
	
	
	lda CurrentLevel
	cmp #8
	bne SetFP
	
	lda #7
	sta CurrentLevel
	
SetFP

	lda CurrentLevel
	lsr
	tax
	lda FPTable,X
	sta FastPoints
	
	inc LevelColor
	lda LevelColor
	and #$0F
	bne BufferNotCleared
	
	inc LevelColor
	
BufferNotCleared


	lda BoardsToWave
	cmp #5
	bne DontDecBTW
	
	dec BoardsToWave
	
DontDecBTW


;;check deadly collisions, read button

	lda CXM0P
	and #%01000000
	bne CXM0PDetected


	ldx CurrentWave
	lda WaveE1Color,X
	beq NoCXM0P
	
	
	lda CXM0P
	and #%10000000
	beq NoCXM0P
	
CXM0PDetected
	
	lda EnemyMovment
	and #%00010000
	beq NoCXM0P

	lda EnemyMovment
	and #%00001111			;no longer in play
	sta EnemyMovment
	
	tsx
	stx ButtonTimer
	
	lda #9
	sta DeathSoundCounter
	
	lda #$50
	sta ButtonTimer
	
	dec NumberOfLives
	lda NumberOfLives
	cmp #$FF			;game over detected
	beq NoCXM0P
		

	jsr SetInitialPositions

	lda PF2ABuffer+7		
	and #%01111111
	sta PF2ABuffer+7
	
;Conserve D5

	lda EnemyMovment
	and #%00100000
	ora #%01000011
	sta EnemyMovment
	
	
NoCXM0P

	lda NumberOfLives
	cmp #$FF
	bne DontSetGameOver
	
	lda #0
	sta NumberOfLives
	
	lda EnemyMovment
	ora #%10000000
	sta EnemyMovment
	

	
DontSetGameOver


	lda EnemyMovment
	and #%00010000
	beq GameNotInPlay
	
	jsr ReadJoystick
	

	
EnemyMovLoop
	
	ldx #0
	
	ldy CurrentWave
	lda WaveE1Pos,y

	sta Temp
	
	lda LevelColorST
	sta StoreColorPF
	

	ldy CurrentWave 
	beq Wave1Movment
	
	dey
	beq Wave2Movment
	
	dey
	beq Wave3Movment
	
	dey
	beq Wave4Movment
	
	dey
	beq Wave5Movment
	
	dey
	beq Wave6Movment
	
	dey
	beq Wave7Movment
	
	dey
	beq Wave8Movment
	
	jsr SmartE0Movment
	jsr FlashBackground
	
	bvc DoneMovment
	

Wave8Movment	
Wave6Movment
	inx
	
Wave5Movment

	
	jsr AutomatedMovment
	
	jsr FlashBackground

	
	bvc DoneMovment
	

	
Wave3Movment
	
	jsr SmartE0Movment
	
	
	bne DoneMovment
	

	

Wave7Movment
Wave4Movment
	inx
Wave1Movment
Wave2Movment

	jsr AutomatedMovment

	
	
GameNotInPlay


	
DoneMovment


	

	lda PlayerY
	cmp #$FC
	beq ResetTop
	cmp #$40
	bne DonePlayerY
	
	lda #$3C
	.byte $2C
	
ResetTop
	lda #0
	sta PlayerY

DonePlayerY

	lda PlayerX
	cmp #$FD
	beq ResetLeft
	cmp #$A1
	bne DonePlayerX
	
	lda #$9D
	.byte $2C
	
ResetLeft

	lda #1
	sta PlayerX
	
DonePlayerX


;;Enemy Movment
;;
;;X,Y
;;
;;D0,D1		E0 movment  D0 = 1 = move R D1 = 1 = U
;;D2,D3		E1 movment  D2 = 1 = move R D3 = 1 = U
;;D4		1 = game in play
;;D5		1 = advanced (one life, no bonus lives)
;;D6		1 = in between lives
;;D7		1 = game over

	lda ButtonTimer
	beq SkipDecBT
	
	dec ButtonTimer
	
SkipDecBT

	lda ButtonTimer
	bne ButtonNotPushed

	lda INPT4
	bmi ButtonNotPushed

	
	lda EnemyMovment
	and #%00010000
	beq ContinueChecks
	
	lda #$FF
	sta PlayerFastFlag
	bne DontZeroPlayerFF
	
ContinueChecks
	
	lda PlayerFastFlag
	bne DontZeroPlayerFF

	lda EnemyMovment
	and #%00010000
	bne GameIsInPlay
	
	lda EnemyMovment
	and #%10000000
	bne GameIsInPlay
	
	lda EnemyMovment
	ora #%00010000
	sta EnemyMovment
	
	lda EnemyMovment
	and #%00100000
	ora #%01000011
	sta EnemyMovment
	
GameIsInPlay
	

	lda EnemyMovment
	and #%01000000
	bne PutGameInPlay

	lda EnemyMovment
	and #%10000000
	beq ButtonNotPushed


	jsr SetInitialValues
	ldy #%01111111
	jsr FillBuffers

	
PutGameInPlay
	
	lda EnemyMovment
	and #%00111111
	ora #%00010000
	sta EnemyMovment
	
ButtonNotPushed

	lda PlayerFastFlag

	beq DontZeroPlayerFF
	
	lda #0
	sta PlayerFastFlag
	
DontZeroPlayerFF


;;sound effects


	lda DeathSoundCounter
	cmp #$FF
	beq SkipDeathSound
	
	tax
	lda DeathSoundPitches,X
	sta AUDF0
	
	dec DeathSoundCounter
	lda DeathSoundVolumes,X

	.byte $2C
	
	
SkipDeathSound
	
	lda #0
	sta AUDV0
	
	
	lda ExtraLifeCounter
	cmp #$FF
	beq NormalAUDx1
	
	tay
	
	lda #$FF
	sta BlockClearCounter
	sta PointDropCounter
	
	
	tya
	and #%00001100
	lsr
	lsr
	tax
	
	lda ExtraLifePitches,X
	sta AUDF1
	dec ExtraLifeCounter
	
	tya
	and #%00000011
	tax
	
	lda ExtraLifeVolumes,X
	sta AUDV1
	bne DoneAUDx1
	
	
NormalAUDx1
	

	
	lda PointDropCounter
	cmp #$FF
	bne PlayPointDrop
	
	lda SWCHB
	and #%00001000
	beq SkipBlockClearSound
	
	lda BlockClearCounter
	cmp #$FF
	beq SkipBlockClearSound
	
	dec BlockClearCounter
	
	tax
	lda BlockSoundPitches,X
	sta AUDF1
	
	lda BlockSoundVolumes,X
	.byte $2C
	
SkipBlockClearSound

	lda #0
	sta AUDV1

	jmp DoneAUDx1
	
PlayPointDrop
	
	lda PointDropCounter
	cmp #$FF
	beq SkipPointDropSound
	
	dec PointDropCounter
	
	tax
	lda PointDropPitches,X
	sta AUDF1
	
	lda PointDropVolumes,X
	.byte $2C
	
SkipPointDropSound

	lda #0
	sta AUDV1
	
DoneAUDx1



	inc RFC
	
	lda EnemyMovment
	and #%10000000
	beq NoColorShow
	
	lda RFC
	bne NoColorShow
	
	inc LevelColor
	
	ldx #2
ColorShowLoop

	
	ldy #$0F
CSINCLoop
	inc GreenColor,X
	dey
	bpl CSINCLoop

	dex
	bpl ColorShowLoop
	
	
NoColorShow

	
	sta CXCLR

OSLoop
	lda INTIM
	bne OSLoop
	
	jmp StartFrame
	


	
ExtraLifePitches

	.byte 9,12,15,19



	
FPTable
	.byte 24,20,16,12
	
HealthPF0

	.byte 0
	.byte #%00010000
	.byte #%00110000
	.byte #%01110000
	.byte #%11110000
	.byte #%11110000
	.byte #%11110000

	
HealthPF1

	.byte 0
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%10000000
	.byte #%11000000

	


LivesNUSIZ1Table

	.byte %00100000
	
LivesNUSIZ0Table

	.byte %00100000,%00100000,%00100000,%00100001,%00100001,%00100011,%00100011



ObjectHeigths
	
	.byte #PlayerHeigth;,#SpriteHeigth,#SpriteHeigth 	;= 7 shared
	
PointDropPitches

	.byte 7,7,7,12,12,12,20,20,20
	


PointDropVolumes

	.byte 12,6,2,12,6,2,12,6;,2	;shares 2 with extra life volumes
	
ExtraLifeVolumes
	
	.byte 2
BlockSoundVolumes
	.byte 6,12,8
	


BlockSoundPitches

	.byte 23,19


	
HealthPositions

	.byte #157,#158,#159,#160;,#0

LivesENAM1Table		;borrows data from the death sound pitches for enabling 
			;missiles for lives display
	.byte 0
LivesENAM0Table
	.byte 0

DeathSoundPitches

	.byte 23,23,23,23,23,14,14,14,14,14

DeathSoundVolumes
	
	.byte 6,8,12,4,2,6,8,12,4,2
	

PF2AndTable


	.byte #%11111110
	.byte #%11111101
	.byte #%11111011
	.byte #%11110111
	.byte #%11101111
	.byte #%11011111
	.byte #%10111111
	.byte #%01111111
	repeat 8
	.byte #%11111111
	repend
	.byte $FF
PF0AndTable
	repeat 8
	.byte #%11111111
	repend
	.byte #%11101111
	.byte #%11011111
	.byte #%10111111
	.byte #%01111111
	.byte $FF
PF1AndTable
	repeat 8+4
	.byte #%11111111
	repend
	.byte #%01111111
	.byte #%10111111
	.byte #%11011111
	.byte #%11101111
	.byte $FF
	
SubtractPoint


	
	lda Score+2
	bne ScoreNotZero
	lda Score+1
	bne ScoreNotZero
	lda Score
	beq ClearDecimal
	
ScoreNotZero

	lda #9
	sta PointDropCounter

	lda Score+1
	bne DontZeroScore
	lda Score
	bne DontZeroScore
	lda Score+2
	and #$F0
	bne DontZeroScore
	
	lda #0
	sta Score+2
	beq ClearDecimal
	
DontZeroScore
	
	sed

	sec
	lda Score+2
	sbc #10
	sta Score+2
	
	lda Score+2
	and #$F0
	cmp #$90
	bne ClearDecimal
	
	sec
	lda Score+1
	sbc #1
	sta Score+1
	
	lda Score+1
	cmp #$99
	bne ClearDecimal
	
	sec
	lda Score
	sbc #1
	sta Score
	
	
	jmp ClearDecimal

	
	
UpdateScore



	sed
	
	
	clc
	lda Score+2
	adc #5

	sta Score+2
	
	lda Score+2
	bne ClearDecimal
	
	clc
	lda Score+1
	adc #1
	sta Score+1
	
	
;CheckThousands

	lda Score+1
	bne ClearDecimal
	
	clc
	lda Score
	adc #1
	sta Score
	
;AdjustLives
	

	
ClearDecimal
	

	cld
	
	lda #0
	sta Temp
	sta Temp1
	
SetScorePointers0
	ldy Temp

	lda Score,Y
	and #%11110000
	lsr
	lsr
	lsr
	lsr
	tax
	
	ldy Temp1
	
	lda NumberPointers,X
	sta ScorePtr5,Y
	
	ldy Temp
	
	lda Score,Y
	and #%00001111
	tax
	
	ldy Temp1
	
	lda NumberPointers,X
	sta ScorePtr4,Y
	
	inc Temp1
	inc Temp1
	
	inc Temp
	lda Temp
	cmp #3
	bne SetScorePointers0	;50

	rts
	
UpdateFP

	lda PlayerFastFlag
	bne DontAddMoreFP
	
	inc FastPoints

	lda CurrentLevel
	lsr
	tax
	lda FPTable,X
	sta Temp
	
	lda FastPoints
	cmp Temp

	bmi DontAddMoreFP
	

	lda Temp
	sta FastPoints
	
DontAddMoreFP

	jmp UpdateScore
	
	
NumberPointers

	.byte #<Zero
	.byte #<One
	.byte #<Two
	.byte #<Three
	.byte #<Four
	.byte #<Five
	.byte #<Six
	.byte #<Seven
	.byte #<Eight
	.byte #<Nine
	

	
SmartE0Movment

	inc FrameCounter

	lda FrameCounter
	cmp #4

	bne DoneSmartE0

	lda #0
	sta FrameCounter

	lda PlayerX
	cmp Enemy0X
	beq DoneEnemy0X
	bpl MoveEnemy0Right
	
	dec Enemy0X
	.byte $2C
MoveEnemy0Right

	inc Enemy0X
	
DoneEnemy0X
	

	lda PlayerY
	cmp Enemy0Y
	beq DoneSmartE0
	bpl MoveEnemy0
	
	dec Enemy0Y
	.byte $2C
MoveEnemy0
	inc Enemy0Y
	
DoneSmartE0

	lda Enemy0Y
	bne DontIncE0Y
	
	inc Enemy0Y
	
DontIncE0Y

	rts
	
YAndOr
	.byte %00000010,%00001000

YAnd
	.byte %11111101,%11110111

XAndOr
	.byte %00000001,%00000100
	
XAnd
	.byte %11111110,%11111011
	
	
AutomatedMovment

;;can move both enemies by setting X to 1

	lda EnemyMovment
	
	and YAndOr,X
	beq MoveEXDown

	dec Enemy0Y,X
	.byte $2C
	
MoveEXDown

	inc Enemy0Y,X

	
	lda Enemy0Y,X
	cmp #56
	bne NoEXUp
	
	lda EnemyMovment

	ora YAndOr,X
	sta EnemyMovment
	
NoEXUp

	
	ldy Enemy0Y,X
	dey
	bne NoEXDown
	
	lda EnemyMovment
	
	and YAnd,X
	sta EnemyMovment
	
NoEXDown

	lda EnemyMovment
	
	and XAndOr,X
	beq MoveEXL
	
	inc Enemy0X,X
	.byte $2C
	
MoveEXL

	dec Enemy0X,X
	

	
	lda Enemy0X,X

	cmp Temp
	bne NoEXLeft
	
	lda EnemyMovment
	
	and XAnd,X
	sta EnemyMovment
	
NoEXLeft

	lda Enemy0X,X
	bne NoEXRight
	
	lda EnemyMovment
	
	ora XAndOr,X
	sta EnemyMovment
	
NoEXRight

	dex
	bpl AutomatedMovment

	rts
	

	
FlashBackground



	ldx LevelColorST

	lda RFC
	and #%00100000
	bne BackgroundVisable
	
	ldx #0
	
	
BackgroundVisable

	
	stx COLUPF
	
	clv
	
	rts

Colors
	.byte $C0,$80;,$00
	
WaveNUSIZx

	.byte 0,5,0,0,0,0,5,5,5

WaveE1Pos
	
	.byte 152,143,152,152,152,152,143,143,143
	
WaveE1Color

	.byte $00,$00,$00,$1F,$00,$1F,$1F,$1F,$00
	


Graphics
	
	


	
One

	.byte #%00111000
	.byte #%00010000
	.byte #%00010000
	.byte #%00010000
	.byte #%00010000
	.byte #%00110000
Seven
	.byte #%00010000
	.byte #%00010000
	.byte #%00001000
	.byte #%00000100
	.byte #%00000100
	.byte #%00000010
	.byte #%00111110
	
	
	
Four

	.byte #%00000100
	.byte #%00000100
	.byte #%00000100
	.byte #%01111110
	.byte #%00100100
	.byte #%00010100
	.byte #%00001100
	
Three

	.byte #%00111100
	.byte #%01000010
	.byte #%00000010
	.byte #%00001100
	.byte #%00000010
	.byte #%01000010
Five
	.byte #%00111100				
	.byte #%01000010
	.byte #%00000010
	.byte #%00000010
	.byte #%01111100
	.byte #%01000000
Two				
	.byte #%01111110
	.byte #%00100000
	.byte #%00011000
	.byte #%00000100
	.byte #%00000010
	.byte #%01000010
Nine
	.byte #%00111100	
	.byte #%00000010
	.byte #%00000010
Eight
	.byte #%00111100
	.byte #%01000010
	.byte #%01000010
Six
	.byte #%00111100
	.byte #%01000010
	.byte #%01000010
	.byte #%00111100
	.byte #%01000000
	.byte #%01000000
Zero
	.byte #%00111100
	.byte #%01000010
	.byte #%01000010
	.byte #%01000010
	.byte #%01000010
	.byte #%01000010
Enemy0Graphics
	.byte #%00111100
	
;Enemy0Graphics

;	.byte #%00111100
	.byte #%01111110
	.byte #%10011001
	.byte #%11011011
	.byte #%01111110
	.byte #%00100100
	.byte #%00100100
	.byte #%00011000

SlowPlayerSpeeds = . - 2	;;shares first 2 bytes with Enemy0Graphics
	.byte 6,7,8
	
FastPlayerSpeeds = . - 2

	.byte 3,4,5
	

	
	.byte "RS"
	

	org $1FFC
	
	.word Start
	.word Break
