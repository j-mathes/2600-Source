
;*********************************
;DROP EGG
;*********************************
;
;	BKER = KER NUMBER
;	BULLSEYE = KER OFFSET
;*********************************

INITDROP:
	STA	TEMP0		;SAVE VALUE CALLED WITH
	BNE	.BIRD_DROPPING	;NONZERO VALUE IN ACCUMULATOR
	LDA	HOFFSET	; INDICATES BIRD IS DROPPING EGG
	JMP	.CALC

.BIRD_DROPPING:
	LDA	R_BKER
	LSR
	TAX
	LDA	X,r_xpos

.CALC:	clc
	adc	#4
	STA	W_EGGX
	STAI	0,W_SIZE
	LDA	R_EGGY
	CMP	#192-8
	BCS	.EG1
	STAI	0,W_EGGY
.EG1:	LDA	R_EGGX
	cmp	#159
	bcc	.set
	lda	#5
	STA	W_EGGX
.set:
RESOBJ:
;	CPX	#M0
;	BCC	.OK
	CLC		;2;
	ADC	#1	;2;
;.OK:
	TAY		;2;2
	WSYNC
	LDA	Y,HMTAB	;4;4
	STA	HMM0	;4;8
	AND	#$0F	;2;10
	TAY		;2;12
.LOP2:	DEY		;2;14	
	BNE .LOP2	;2;16
;	WASTE3		;3;19
	NOP
	NOP
	STA	RESM0	;4;23

	LDA	TEMP0
	BNE	.BIRDDROPPING
	LDA	VOFFSET
	JMP	.SETYPOS

.BIRDDROPPING:
	lda	R_BKER
	lsr
	tax
	lda	x,r_ypos
	ldx	R_BKER
	inx
	inx
	clc
	adc	X,TREETOPKER
.SETYPOS:
	STA	W_EGGY
	RTS
