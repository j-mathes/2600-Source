	PROCESSOR 6502
	INCLUDE	"VCS.H"

	INCLUDE "SKELRAM.ASM"

	SEG	ROM
	ORG	$1000

	DC.B	"Skeleton (c)2002 Eric Ball",0

KERN0	STA	WSYNC		;69-0
	LDA	(MAZE0L),Y	;-5
	STA	PF0		;-8
	STX	PF1		;-11
	STX	PF2		;-14
	LDX	#5		;-16
WAIT0	DEX			;+2
	BNE	WAIT0		;+2/3
	LDA	(MAZE0R),Y	;40-45
	STA	PF0		;-48
	INY			;-50
	LDA	WALL		;-53
	CMP	#1		;-55
	BEQ	WALL15		;-57/58
	CPY	#20		;-59
	BNE	KERN0		;-61/62
	BEQ	KERN20		;-64
WALL15	CPY	#15		;58-60
	BCC	KERN0		;-62/63
	DEX			;-64
	CPY	#20		;-66
	BNE	KERN0		;-68/69

WALL20	STA	WSYNC		;44-0
	LDA	#$80		;-2
	STA	PF0		;-5
	LDA	#$00		;-7
	STA	PF1		;-10
	STA	PF2		;-13
	LDX	#170-20		;-15
	JSR	XWALL		;-21
	DEX			;36-38
	JMP	KERN170		;-41

KERN20	STA	WSYNC		;72-0
	TXA			;-2
	AND	#$0F		;-4
	ORA	(MAZE1L),Y	;-9
	STA	PF1		;-12
	STX	PF2		;-15
	LDX	#$80		;-17
	STX	PF0		;-20
	LDX	#4		;-22
WAIT20	DEX			;+2
	BNE	WAIT20		;+2/3
	AND	#$0F		;41-43
	ORA	(MAZE1R),Y	;-48
	STA	PF1		;-51
	INY			;-53
	LDA	WALL		;-56
	CMP	#2		;-58
	BEQ	WALL35		;-60/61
	CPY	#40		;-62
	BNE	KERN20		;-64/65
	BEQ	KERN40		;-67
WALL35	CPY	#35		;61-63
	BCC	KERN20		;-65/66
	DEX			;-67
	CPY	#40		;-69
	BNE	KERN20		;-71/72

WALL40	STA	WSYNC		;41-0
	LDA	#$10		;-2
	STA	PF1		;-5
	LDA	#$00		;-7
	STA	PF2		;-10
	LDX	#150-40		;-12
	JSR	XWALL		;-18
	DEX			;36-38
	JMP	KERN150		;-41

KERN40	STA	WSYNC		;72-0
	LDA	(MAZE2L),Y	;-5
	STA	PF1		;-8
	STX	PF2		;-11
	LDX	#5		;-13
	CPY	SKELTOP		;-15
	BCC	WAIT40		;-17/18
	LDA	(SKEL0),Y	;-22
	STA	GRP0		;-24
	LDA	(SKEL1),Y	;-29
	STA	GRP1		;-32
	LDX	#2		;-34
WAIT40	DEX			;+2
	BNE	WAIT40		;+2/3
	LDA	(MAZE2R),Y	;42/43-47/48
	STA	PF1		;-50/51
	INY			;-53
	LDA	WALL		;-56
	CMP	#3		;-58
	BEQ	WALL55		;-60/61
	CPY	#60		;-62
	BNE	KERN40		;-64/65
	LDA	#$00		;-66
	BEQ	KERN60		;-69
WALL55	CPY	#55		;61-63
	BCC	KERN40		;-65/66
	DEX			;-67
	CPY	#60		;-69
	BNE	KERN40		;-71/72

WALL60	STA	WSYNC		;41-0
	LDA	#$11		;-2
	STA	PF1		;-5
	LDA	#$00		;-7
	STA	PF2		;-10
	LDX	#130-60		;-12
	JSR	XWALL		;-18
	DEX			;36-38
	JMP	KERN130		;-41

PVIEW4	LDA	$00,X		; right/left step 2 subroutine
	BEQ	PVIEW5		; open found, check next
	LDA	#>TYPE0		; closed, show wall
	BNE	PVIEW7
PVIEW5	LDA	$01,X		; is next open too?
	BEQ	PVIEW6
	LDA	#>TYPE1		; open, show hole
	BNE	PVIEW7
PVIEW6	LDA	#>TYPE2		; both open, show Y
PVIEW7	INX			; next test position
	STA	$0001,Y		; pointer MSB to RAM
	LDA	#$00
	STA	$0000,Y		; LSB = 0
	INY			; next pointer position
	INY
	RTS

WAIT60	LDX	#3		;20-22
WAIT61	DEX			;+2
	BNE	WAIT61		;+2/3
	BEQ	KERN61		;36-39

KERN60	STA	WSYNC		;70-0
	AND	#$F0		;-2
	ORA	(MAZE3L),Y	;-7
	STA	PF2		;-10
	LDX	#$11		;-12
	STX	PF1		;-15
	CPY	SKELTOP		;-17
	BCC	WAIT60		;-19/20
	TAX			;-21
	LDA	(SKEL0),Y	;-26
	STA	GRP0		;-29
	LDA	(SKEL1),Y	;-34
	STA	GRP1		;-37
	TXA			;-39
KERN61	AND	#$F0		;39-41
	ORA	(MAZE3R),Y	;-46
	STA	PF2		;-49
	INY			;-51
	LDA	WALL		;-54
	CMP	#4		;-56
	BEQ	WALL75		;-58/59
	CPY	#80		;-60
	BNE	KERN60		;-62/63
	BEQ	KERN80		;-65
WALL75	CPY	#75		;59-61
	BCC	KERN60		;-63/64
	LDA	#$FF		;-65
	CPY	#80		;-67
	BNE	KERN60		;-69/70

KERN80	STA	WSYNC		;36-0
	LDA	#$08		;-2
	STA	PF2		;-5
	LDX	#110-80		;-7
	JSR	XWALL		;-13
	DEX			;36-38

KERN110	STA	WSYNC		;56-0
	LDA	(MAZE3L),Y	;-5
	STA	PF2		;-8
	LDX	#4		;-10
	CPY	SKELBOT		;-12
	BCS	WAIT110		;-14/15
	LDA	(SKEL0),Y	;-19
	STA	GRP0		;-22
	LDA	(SKEL1),Y	;-27
	STA	GRP1		;-30
	LDX	#1		;-32
WAIT110	DEX			;+2
	BPL	WAIT110		;+2/3
	LDA	(MAZE3R),Y	;39/41-44/46
	STA	PF2		;-47/49
	INY			;-51
	CPY	#130		;-53
	BNE	KERN110		;-55/56

KERN130	STA	WSYNC		;64-0
	LDA	(MAZE2L),Y	;-5
	STA	PF1		;-8
	STX	PF2		;-10
	LDX	#4		;-12
	CPY	SKELBOT		;-14
	BCS	WAIT130		;-16/17
	LDA	(SKEL0),Y	;-21
	STA	GRP0		;-24
	LDA	(SKEL1),Y	;-29
	STA	GRP1		;-32
	LDX	#1		;-34
WAIT130	DEX			;+2
	BPL	WAIT130		;+2/3
	LDA	(MAZE2R),Y	;41/43-46/48
	STA	PF1		;-49/51
	INY			;-53
	CPY	#135		;-55
	BCC	KERN130		;-57/58
	LDX	#$00		;-59
	CPY	#150		;-61
	BNE	KERN130		;-63/64
	LDX	#$FF		;-65

KERN150	STA	WSYNC		;64-0
	LDA	(MAZE1L),Y	;-5
	STA	PF1		;-8
	STX	PF2		;-10
	LDX	#4		;-12
	CPY	SKELBOT		;-14
	BCS	WAIT150		;-16/17
	LDA	(SKEL0),Y	;-21
	STA	GRP0		;-24
	LDA	(SKEL1),Y	;-29
	STA	GRP1		;-32
	LDX	#1		;-34
WAIT150	DEX			;+2
	BPL	WAIT150		;+2/3
	LDA	(MAZE1R),Y	;41/43-46/48
	STA	PF1		;-49/51
	INY			;-53
	CPY	#155		;-55
	BCC	KERN150		;-57/58
	LDX	#$00		;-59
	CPY	#170		;-61
	BNE	KERN150		;-63/64
	LDX	#$FF		;-65

KERN170	STA	WSYNC		;64-0
	LDA	(MAZE0L),Y	;-5
	STA	PF0		;-8
	STX	PF1		;-10
	STX	PF2		;-12
	LDX	#5		;-14
WAIT170	DEX			;+2
	BPL	WAIT170		;+2/3
	LDA	(MAZE0R),Y	;43-48
	STA	PF0		;-51
	INY			;-53
	CPY	#175		;-55
	BCC	KERN170		;-57/58
	LDX	#$00		;-59
	CPY	#190		;-61
	BNE	KERN170		;-63/64

LAST	LDA	#30*76/64+1
	STA	WSYNC		;-0
	STA	TIM64T		;-4
	STX	PF0

	LDX	SOUNDEL		; sound countdown
	BEQ	COLUPA		; already zero?
	DEX
	BNE	COLUPA		; zero?
	STX	AUDV0		; turn off sound
	STX	AUDV1

COLUPA	STX	SOUNDEL
	LDA	SKELIFE		; skeleton still alive?
	BPL	COLUPB
	LDX	FIREDEL
	LDA	SKELDIE,X
	BNE	COLUPC
	BEQ	COLUPC
COLUPB	LDA	FIREDEL		; fire flash?
	CMP	#55
	BCS	FIRETST
	LDA	MAZECOL		; set playfield colour
	STA	COLUPF
	LDX	SKELIFE		; set skeleton color
	LDA	LIFELUM,X
COLUPC	STA	COLUP0
	STA	COLUP1

FIRETST	LDA	INPT4		; fire button
	AND	#$80
	CMP	THISFIR		; debounce
	BNE	PLAYMOV		; not the same
	LDX	LASTFIR		; check last button position
	STA	LASTFIR		; save current
	BPL	PLAYMOV		; do nothing if last was down
	ASL			; check current
	BCS	PLAYMOV		; do nothing if up
	LDA	FIREDEL		; check reload delay
	BNE	PLAYMOV		; do nothing if reloading
	STA	AUDF0		; BANG!
	STA	AUDF1
	LDA	#8		
	STA	AUDC0
	STA	AUDC1
	STA	AUDV0
	STA	AUDV1
	STA	SOUNDEL
	LDA	SKELDIS		; is skeleton in view?
	AND	#$03
	BEQ	SETDEL		; not in view
	LDA	#$00		; make skeleton turn
	SEC			; and face plaer
	SBC	PLAYDIR
	STA	SKELNXT
	LDA	RANDOM		; generate random damage
	AND	#$0F		; 0-15
	STA	FIREDEL		; save temp
	LDA	SKELIFE		; reduce skeleton life
	SEC
	SBC	FIREDEL
	STA	SKELIFE
	LDA	FIREDEL		; set skeleton colour flash
	ASL
	ASL
	ASL
	ASL
	STA	FIREDEL		; save msn
	LDX	SKELIFE		; set luminance
	LDA	LIFELUM,X
	ORA	FIREDEL		; combine
	STA	COLUP0
	STA	COLUP1
SETDEL	LDA	MAZECOL		; set playfield colour
	AND	#$0F		; flash maze too
	STA	COLUPF
	LDA	#60		; set reload timer = 1 sec
	STA	FIREDEL
	BNE	PLAYMOV

PLAYMOV	LDA	SWCHA		; PLAYER MOVE
	ORA	#$0F
	CMP	THISMOV		; DEBOUNCE
	BNE	SKELMOV
	LDX	LASTMOV		; moved last frame?
	CPX	#$FF
	BNE	PMOVEA		; no
	CMP	#$EF		; forward?
	BEQ	PMOVEC
	CMP	#$7F		; turn right?
	BEQ	PMOVEB
	CMP	#$BF		; turn left?
	BNE	SKELMOV
	STA	LASTMOV		
	LDX	PLAYDIR		; turn left
	LDA	#$00
	SEC
	SBC	PLAYRIG
	STX	PLAYRIG
	STA	PLAYDIR
	BNE	SKELMOV
PMOVEA	CMP	#$FF		; return to center?
	BNE	SKELMOV
	STA	LASTMOV		; centered
	BEQ	SKELMOV
PMOVEB	STA	LASTMOV		; right turn
	LDX	PLAYRIG
	LDA	#$00
	SEC
	SBC	PLAYDIR
	STX	PLAYDIR
	STA	PLAYRIG
	BNE	SKELMOV
PMOVEC	STA	LASTMOV		; step forward
	LDA	WALL
	CMP	#1
	BEQ	SKELMOV
	LDA	PLAYPOS
	CLC
	ADC	PLAYDIR
	STA	PLAYPOS
	CMP	SKELPOS
	BNE	SKELMOV
	JMP	GOTYOU

SKELMOV	LDA	SKELIFE		; skeleton still alive?
	BMI	SKELSTP
	DEC	SKELDEL		; main skeleton movement delay
	BEQ	SKDEL1
SKELSTP	JMP	BOTTOM		; no movement, skip everything
	
SKDEL1	LDA	SKELSEC		; decrease rate counter
	SEC
	SBC	SKELPER
	STA	SKELSEC
	BCS	SKDEL2		; no carry = underflow
	ADC	#60
	STA	SKELSEC
	LDA	SKELMIN
	SEC
	SBC	SKELPER		; decrease square counter
	STA	SKELMIN
	BCS	SKDEL2		; no carry = underflow
	ADC	#87
	STA	SKELMIN
	LDA	SKELHRS
	SEC
	SBC	SKELPER		; decrease cube counter
	STA	SKELHRS
	BCS	SKDEL2		; no carry = underflow
	ADC	#76
	STA	SKELHRS
	DEC	SKELPER		; speed up skeleton!
SKDEL2	LDA	SKELPER
	STA	SKELDEL 

	LDA	SKELNXT		; forced move?
	BEQ	SMOVEA		; nope, start the decision tree
	LDX	#0		; clear forced move flag
	STX	SKELNXT
	CMP	SKELDIR		; forced=facing?
	BNE 	SKNXT0
	JMP	SMOVE1		; step forward
SKNXT0	STA	SKELDIR		; turn and set SKELRIG correctly
	CMP	#1
	BEQ	SKNXT1
	BMI	SKNXT2
	LDA	#-1
	STA	SKELRIG
	BNE	SKELSTP
SKNXT1	LDA	#16
	STA	SKELRIG
	BNE	SKELSTP
SKNXT2	CMP	#-1
	BEQ	SKNXT3
	LDA	#1
	STA	SKELRIG
	BNE	SKELSTP
SKNXT3	LDA	#-16
	STA	SKELRIG
	BNE	SKELSTP
SMOVEA	LDX	#0		; direction flags
	LDA	SKELPOS		; can we go forward?
	CLC
	ADC	SKELDIR
	TAY
	LDA	LVLMASK
	AND	MAZES,Y
	BNE	SMOVED		; can't go forward
	INX			; forward flag
	LDA	#$01		; determine facing
	BIT	SKELDIR		; use bit to test for neg too
	BNE	SMOVEB		; SKELDIR = +1/-1
	LDA	PLAYPOS		; check for player in same column
	SEC
	SBC	SKELPOS
	AND	#$0F
	BNE	SMOVED
	JMP	SMOVE1
SMOVEB	BMI	SMOVEC		; SKELDIR = -1
	LDA	PLAYPOS
	SEC
	SBC	SKELPOS
	AND	#$F0		; player ahead
	BNE	SMOVED
	JMP	SMOVE1
SMOVEC	LDA	SKELPOS		; player ahead (behind)
	SEC
	SBC	PLAYPOS
	AND	#$F0		; player ahead
	BNE	SMOVED
	BEQ	SMOVE1
SMOVED	LDA	SKELPOS		; can we go right?
	CLC
	ADC	SKELRIG
	TAY
	LDA	LVLMASK
	AND	MAZES,Y
	BNE	SMOVEE
	INX
	INX
SMOVEE	LDA	SKELPOS		; can we go left?
	SEC
	SBC	SKELRIG
	TAY
	LDA	LVLMASK
	AND	MAZES,Y
	BNE	SMOVEF
	INX
	INX
	INX
	INX
SMOVEF	CPX	#0
	BEQ	SMOVE0		; no directions, turn around
	DEX	
	BEQ	SMOVE1		; forward only
	DEX
	BEQ	SMOVE2		; right only
	DEX
	BEQ	SMOVE3		; right or forward
	DEX
	BEQ	SMOVE4		; left only
	DEX
	BEQ	SMOVE5		; left or forward
	DEX
	BEQ	SMOVE6		; right or left
	BIT	RANDOM		; all directions	
	BPL	SMOVE1
	BMI	SMOVE6
SMOVE0	LDA	#$00		; turn around
	SEC
	SBC	SKELDIR
	STA	SKELDIR
	LDA	#$00
	SEC
	SBC	SKELRIG
	STA	SKELRIG
	JMP	BOTTOM
SMOVE2	LDX	SKELRIG		; turn right
	LDA	#$00
	SEC
	SBC	SKELDIR
	STX	SKELDIR
	STA	SKELRIG
	STX	SKELNXT		; force forward
	JMP	BOTTOM
SMOVE3	BIT	RANDOM
	BPL	SMOVE1
	BMI	SMOVE2
SMOVE4	LDX	SKELDIR		; turn left
	LDA	#$00
	SEC
	SBC	SKELRIG
	STX	SKELRIG
	STA	SKELDIR
	STA	SKELNXT		; force forward
	JMP	BOTTOM
SMOVE5	BIT	RANDOM
	BPL	SMOVE1
	BMI	SMOVE4
SMOVE6	BIT	RANDOM
	BVC	SMOVE2
	BVS	SMOVE4
SMOVE1	LDA	SKELPOS		; step forward
	CLC
	ADC	SKELDIR
	STA	SKELPOS
	CMP	PLAYPOS
	BNE	SMOVE7
	JMP	GOTYOU
SMOVE7	LDA	SOUNDEL		; check for existing sound
	BNE	BOTTOM
	JSR	SKPOSXY		; calculate distance for sound
	JSR	SKSTEP
	LDA	#1
	STA	AUDC0
	STA	AUDC1
	LDA	RANDOM
	ORA	#30
	STA	AUDF0
	STA	AUDF1
	CPX	#-15
	BPL	AUDX
	LDX	#-15
AUDX	STX	AUDV0		; left speaker
	STX	COLUP0
	CPY	#-15
	BPL	AUDY
	LDY	#-15
AUDY	STY	AUDV1		; right speaker
;	STY	COLUP1
	LDA	SKELDEL
	LSR
	STA	SOUNDEL

BOTTOM	JSR	WAITIM

	LDA	#$02
	STA	VSYNC
	JSR	RAND		; cycle LFSR
	LDA	#$01
	STA	CTRLPF		; reflect playfield

	STA	WSYNC		; set initial skeleton position
	LDX	#8		;-2
SKPOS	DEX			;+2
	BNE	SKPOS		;+2/3
	STA	RESP0		;46-49
	LDA	#$60		; shift left half left
	STA	RESP1
	STA	HMP0
	LDA	#$40		; center right half (final position)
	STA	HMP1
	STA	WSYNC	
	STA	HMOVE

	LDA	#38*76/64+1
	STA	WSYNC
	STA	TIM64T
	LDA	#$00
	STA	VSYNC
	STA	HMCLR

NEWSKEL	LDA	SKELIFE		; skeleton dead?
	BPL	PVIEW
	LDA	FIREDEL		; done death flash?
	BNE	PVIEW
	LDX	SKELNUM		; increment skeleton life
	INX
	STX	SKELNUM
	STX	SKELIFE
	LDX	MAZECOL		; increment maze luminance
	INX
	TXA
	AND	#$0F
	CMP	#13
	BEQ	NEXTLVL		; ten down, new level
	STX	MAZECOL
	LDA	#$00
	STA	SKELPOS
	JSR	SKPOSXY		; figure out restart position
;	LDA	SKELX
	BPL	NEWSK1
	EOR	#$FF		; NEG
	CLC
	ADC	#$01
NEWSK1	BIT	SKELY
	BPL	NEWSK2
	SEC
	SBC	SKELY
	BPL	NEWSK3
NEWSK2	CLC
	ADC	SKELY
NEWSK3	CMP	#$07
	BPL	NEWSK4
	LDA	#120
	STA	SKELPOS
NEWSK4	LDX	#LOADDEL-LOADRAM; reset skeleton move timers
	BNE	REINIT
NEXTLVL	TXA			; increment maze colour
	CLC
	ADC	#$16
	STA	MAZECOL
	LDX	#LOADLVL-LOADRAM
	ASL	LVLMASK
	BNE	REINIT
	JMP	YOUWIN

REINIT	LDA	LOADRAM-1,X	; refresh initial values
	STA	RAMLOAD-1,X
	DEX
	BNE	REINIT

PVIEW	LDX	#0		; center view & skeleton distance
	STX	SKELDIS
	LDY	PLAYPOS
	JSR	PVIEW1
	BNE	PVIEWA
	JSR	PVIEW1
	BNE	PVIEWA
	JSR	PVIEW1
	BNE	PVIEWA
	JSR	PVIEW1
	BNE	PVIEWA
	INX
PVIEWA	STX	WALL		; save wall distance
	LDA	PLAYPOS		; right view, step 1
	CLC
	ADC	PLAYRIG
	LDX	#MAZE1R+1	; save bits here
PVIEWE	JSR	PVIEW3		; test and save bits
	CPX	#MAZE3R+2
	BNE	PVIEWE
	LDA	PLAYPOS		; left view, step 1
	SEC			;
	SBC	PLAYRIG		;
	LDX	#MAZE1L+1	; save bits here
PVIEWF	JSR	PVIEW3		;
	CPX	#MAZE3L+2	;
	BNE	PVIEWF		;
	LDX	#MAZE1R+1	; right view, step 2
	LDY	#MAZE0R		; 
PVIEWG	JSR	PVIEW4		; change bits to pointers
	CPY	#MAZE3R+2	;
	BNE	PVIEWG		;
	LDX	#MAZE1L+1	; left view, step 2
	LDY	#MAZE0L		;
PVIEWH	JSR	PVIEW4		; change bits to pointers
	CPY	#MAZE3L+2	;
	BNE	PVIEWH		;

	LDA	SKELDIS		; skeleton view
	AND	#$03		; check distance
	BNE	SKPOSA
	STA	SKELBOT		; force skeleton off
	SBC	#1		; by reversing top & bottom
	STA	SKELTOP
	JMP	SKVIEW
SKPOSA	SEC			; decrement for table access
	SBC	#1
	ASL			; multiply by 16
	ASL
	ASL
	ASL
	TAY
	LDA	SKTABLE,Y	; use table to update RAM
	STA	HMP0
	LDA	SKTABLE+1,Y
	STA	SKELTOP
	LDA	SKTABLE+2,Y
	STA	SKELBOT
	LDA	SKTABLE+3,Y
	STA	NUSIZ0
	STA	NUSIZ1
	LDA	PLAYDIR		; figure out facing
	CMP	SKELDIR
	BEQ	SKPOSB		; same dir = back
	CMP	SKELRIG		; left
	BEQ	SKPOSC
	CLC
	ADC	SKELDIR
	BEQ	SKPOSD		; inverse = front
	LDA	SKTABLE+8,Y	; must be right
	STA	SKEL1		; arm on the right
	LDA	SKTABLE+9,Y
	STA	SKEL1+1
	LDA	SKTABLE+10,Y	; body on the left
	STA	SKEL0
	LDA	SKTABLE+11,Y
	STA	SKEL0+1
	LDA	#$18		; mirror both
	BNE	SKVIEW
SKPOSB	LDA	SKTABLE+6,Y	; back for both
	STA	SKEL0		
	STA	SKEL1		
	LDA	SKTABLE+7,Y	
	STA	SKEL0+1		
	STA	SKEL1+1		
	LDA	#$08		; left normal, right mirror
	BNE	SKVIEW
SKPOSC	LDA	SKTABLE+8,Y	; arm on the left
	STA	SKEL0
	LDA	SKTABLE+9,Y
	STA	SKEL0+1
	LDA	SKTABLE+10,Y	; body on the right
	STA	SKEL1
	LDA	SKTABLE+11,Y
	STA	SKEL1+1
	LDA	#$00		; no mirror
	BEQ	SKVIEW
SKPOSD	LDA	SKTABLE+4,Y	; front for both
	STA	SKEL0
	STA	SKEL1
	LDA	SKTABLE+5,Y
	STA	SKEL0+1
	STA	SKEL1+1
	LDA	#$08		; left normal, right mirror
SKVIEW	STA	WSYNC		; hmove P0 for size
	STA	HMOVE
	STA	REFP1		; set reflection registers
	LSR
	STA	REFP0
	STA	WSYNC
	STA	HMOVE

	JSR	WAITIM

	LDA	INPT4		; save button for debounce
	AND	#$80
	STA	THISFIR
	LDX	FIREDEL		; decrement reload counter
	BEQ	RELOAD
	DEX
	STX	FIREDEL

RELOAD	LDA	SWCHA		; save joystick for debounce
	ORA	#$0F
	STA	THISMOV

	LDY	#$00
	LDX	#$00
	JMP	KERN0

PVIEW1	INX			; center view subroutine
	TYA			; move forward one step
	CLC
	ADC	PLAYDIR
	CMP	SKELPOS		; check skeleton position
	BNE	PVIEW2
	STX	SKELDIS		; save if found
PVIEW2	TAY			; check for wall
	LDA	LVLMASK
	AND	MAZES,Y		; BNE done after return
	RTS

PVIEW3	TAY			; right/left step 1 subroutine
	LDA	LVLMASK		; move bits from ROM to RAM
	AND	MAZES,Y
	STA	$00,X
	INX
	TYA
	CLC			; move forward one step
	ADC	PLAYDIR
	RTS

SKPOSXY	LDA	SKELPOS		; change SKPOS-PLAYPOS to SKELX+SKELY
	SEC
	SBC	PLAYPOS
	STA	SKELX
	LSR
	LSR
	LSR
	LSR
	BIT	TESTBIT		; negative?
	BEQ	SKXY2
	ORA	#$F0
SKXY2	STA	SKELY
	LDA	SKELX
	BIT	TESTBIT		; negative?
	BEQ	SKXY3
	INC	SKELY
	ORA	#$F0
	BMI	SKXY4
SKXY3	AND	#$0F
SKXY4	STA	SKELX
	RTS

SKSTEP	LDA	#$01
	BIT	PLAYDIR
	BEQ	SKSTEPG		; PLAYDIR = 16 or -16
	BMI	SKSTEPD		; PLAYDIR = -1
	LDA	SKELX		; PLAYDIR = 1
	BMI	SKSTEPA		; skeleton behind
	EOR	#$FF		; NEG
	CLC
	ADC	#$01
	BMI	SKSTEPB
SKSTEPA	ASL			; multiply by 2
SKSTEPB	STA	SKELX
	LDA	SKELY
	BPL	SKSTEPC		; skeleton right
	CLC
	ADC	SKELX
	TAX			; left = X + Y
	CLC
	ADC	SKELY
	TAY			; right = X + 2Y
	RTS
SKSTEPC	LDA	SKELX
	SEC
	SBC	SKELY
	TAY			; right = X - Y
	SEC
	SBC	SKELY
	TAX			; left = X - 2Y
	RTS
SKSTEPD	LDA	SKELX		; PLAYDIR = -1
	BMI	SKSTEPE		; skeleton ahead
	EOR	#$FF		; NEG
	CLC
	ADC	#$01
	ASL			; multiply by 2
	STA	SKELX
SKSTEPE	LDA	SKELY
	BPL	SKSTEPF		; skeleton left
	CLC
	ADC	SKELX
	TAY			; right = X + Y
	CLC
	ADC	SKELY
	TAX			; left = X + 2Y
	RTS
SKSTEPF	LDA	SKELX
	SEC
	SBC	SKELY
	TAX			; left = X - Y
	SEC
	SBC	SKELY
	TAY			; right = X - 2Y
	RTS
SKSTEPG	BMI	SKSTEPK		; PLAYDIR = -16
	LDA	SKELY		; PLAYDIR = 16
	BMI	SKSTEPH		; skeleton behind
	EOR	#$FF		; NEG
	CLC
	ADC	#$01
	BMI	SKSTEPI
SKSTEPH	ASL			; multiply by 2
SKSTEPI	STA	SKELY
	LDA	SKELX
	BPL	SKSTEPJ		; skeleton left
	CLC
	ADC	SKELY
	TAY			; right = Y + X
	CLC
	ADC	SKELX
	TAX			; left = Y + 2X
	RTS
SKSTEPJ	LDA	SKELY
	SEC
	SBC	SKELX
	TAX			; left = Y - X
	SEC
	SBC	SKELX
	TAY			; right = Y - 2X
	RTS
SKSTEPK	LDA	SKELY		; PLAYDIR = -16
	BMI	SKSTEPL		; skeleton ahead
	EOR	#$FF		; NEG
	CLC
	ADC	#$01
	ASL			; multiply by 2
	STA	SKELY
SKSTEPL	LDA	SKELX
	BPL	SKSTEPM		; skeleton left
	CLC
	ADC	SKELY
	TAX			; left = Y + X
	CLC
	ADC	SKELX
	TAY			; right = Y + 2X
	RTS
SKSTEPM	LDA	SKELY
	SEC
	SBC	SKELX
	TAY			; right = Y - X
	SEC
	SBC	SKELX
	TAX			; left = Y - 2X
	RTS
				; simple 8 bit LFSR
RAND	LDA	RANDOM		;+3
	BEQ	XSEED		;+5/6
	LSR			;+7
	BCC	SRAND		;+9/10
XSEED	EOR	#$A9		;+6/9-8/11
SRAND	STA	RANDOM		;+8/10/11-11/14
	RTS			;+17/20

WAITIM	STA	WSYNC		;-0
	LDA	INTIM		;-4
	BNE	WAITIM		; wait for bottom of frame
	RTS

XWALL0	STA	WSYNC		;-0
XWALL	CPY	SKELTOP		;-2
	BCC	XWALL1		;-4/5
	CPY	SKELBOT		;-6
	BCS	XWALL1		;-8/9
	LDA	(SKEL0),Y	;-13
	STA	GRP0		;-16
	LDA	(SKEL1),Y	;-21
	STA	GRP1		;-24
XWALL1	INY			;-26
	DEX			;-28
	BNE	XWALL0		;-30/31
	RTS			;-36

START	SEI			; enable interupts
	CLD			; turn off BCD math
	LDA	#$00		; clear zero page memory & registers
	LDX	#$44		; start with the TIA shadow
NULL	STA	0,X
	INX
	BNE	NULL
	DEX			; set stack to bottom of RAM
	TXS

	STX	COLUPF		; set up title screen
	LDX	#<GOT
	STX	TITLEND
	LDX	#<TITLEPF
	STX	TITLEX
	LDY	#11
	STY	TITLEY
	LDA	#32*76/64+1
	STA	TITLBOT
	LDA	#41*76/64+1
	STA	TITLTOP

TITLE3	LDA	#$02
	STA	VSYNC
	STA	WSYNC
	JSR	RAND		; cycle LFSR
	STA	WSYNC	
	LDA	TITLTOP
	STA	WSYNC
	STA	TIM64T
	LDA	#$00
	STA	VSYNC
	LDX	TITLEX
TITLE2	JSR	WAITIM

TITLE	STA	WSYNC
	LDA	TITLEPF+1,X	;-4
	STA	PF1		;-7
	LDA	TITLEPF+2,X	;-11
	STA	PF2		;-14
	LDA	TITLEPF,X	;-18
	STA	PF0		;-21
	ASL			;-23
	ASL			;-25
	ASL			;-27
	ASL			;-31
	STA	PF0		;-34
	LDA	TITLEPF+3,X	;-38
	STA	PF1		;-41
	LDA	TITLEPF+4,X	;-45
	DEY			;-47
	BNE	TITLE0		;-49/50
	LDY	TITLEY		;-52
	INX			;-54
	INX			;-56
	INX			;-58
	INX			;-60
	INX			;-62
TITLE0	STA	PF2		;50/62-53/65
	CPX	TITLEND		;-67
	BNE	TITLE		;-69/70

	LDA	TITLBOT		;-72
	STA	WSYNC		;-0
	STA	TIM64T		;-4
	LDA	#0
	STA	PF0
	STA	PF1
	STA	PF2
	STA	AUDV0
	STA	AUDV1
	LDA	SWCHB		; check reset/select
	AND	#$03
	CMP	#$03
	BNE	INIT
TITLE1	JSR	WAITIM
	BEQ	TITLE3

YOUWIN	LDX	#<SKBODY3
	STX	TITLEND
	LDx	#<YOU
	STX	TITLEX
	LDY	#15
	STY	TITLEY
	LDA	#42*76/64+1
	STA	TITLBOT
	LDA	#49*76/64+1
	STA	TITLTOP
	BNE	TITLE2

GOTYOU	LDX	#<WIN-5
	STX	TITLEND
	LDX	#<GOT
	STX	TITLEX
	LDY	#15
	STY	TITLEY
	LDA	#42*76/64+1
	STA	TITLBOT
	LDA	#49*76/64+1
	STA	TITLTOP
	BNE	TITLE1
	
INIT	LDX	#LOADEND-LOADRAM
INITL	LDA	LOADRAM-1,X	; copy in initial values
	STA	RAMLOAD-1,X
	DEX
	BNE	INITL
	JMP	LAST

	INCLUDE "SKELDATA.ASM"

	ORG	$1FFC		; end of 4K cart
	DC.W	START		; reset vector
	DC.W	START		; IRQ vector
