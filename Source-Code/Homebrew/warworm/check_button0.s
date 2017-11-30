;check the joystick buttons
check_button0 	subroutine
	lda	missdir0
	bne nofire_0		;already active missle, no more firing
	lda	missdelay0		;check to implement the delay between firing
	beq	start_check_button0		
	dec missdelay0		;decrement delay count
	bpl	nofire_0		;don't fire

start_check_button0
	bit	INPT4
	bmi	nofire_0

;turn on fire noise and set time	
	lda	#FIREFREQ
	sta	AUDF1
	lda	#FIREVOLUME
	sta	AUDV1
	lda	#FIRENOISETIME
	sta sounddelay


	lda	dir0		;if a fire, then save the direction and pos of the fire into missdir and misspos
	sta	missdir0
	lda	xpos0
	sta	xmiss0
	lda	ypos0
	sta	ymiss0

	lda	#0
	sta	RESMP0		;release it from P0

	lda	#RIGHT_DIR	;see if the missile is going (left or right) or (up or down)
	cmp missdir0
	bmi	miss0_up_or_down	
	lda	#MISS_2CLK
	jmp done_fire0

miss0_up_or_down
	lda	#MISS_1CLK
done_fire0	
	sta	NUSIZ0
nofire_0

