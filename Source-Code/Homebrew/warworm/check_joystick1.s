check_joystick1		subroutine
;check right joystick, p1
	lda	SWCHA	;get the joystick register
	rol			;shift the low nibble into the high nibble
	rol
	rol
	rol
	sta	temp0	;save it in a temp
	;treat the temp like we did before with SWCHA
	lda	#$10
	bit temp0			
	beq	move_up1	;if bit 5 is 0, then move up
	bpl	move_right1	;if the N bit is clear, move right
	bvs	not_left1	;if the overflow bit is set, it is not a left move
	
	lda	#LEFT_DIR	;if we got here, we are moving left
	bne	done_moving1

not_left1			;if we got here we are moving down or not at all
	lda	#$20
	bit	temp0		
	bne	no_moves1	;if the bit is not set, we are not moving
	lda	#DOWN_DIR	;got here, must be going down
	bne done_moving1

move_up1
	lda	#UP_DIR
	bne done_moving1

move_right1
	lda	#RIGHT_DIR	

done_moving1
	bit gamenum		;check for right pro/am, amateur = can't move back on yourself
	bmi joy1_pro
	tax				;save off new dir
	eor dir1
	cmp #$0A		;see if we are changing to the opposite direction
	beq no_moves1
	txa				;restore old dir
joy1_pro

	sta	dir1
no_moves1