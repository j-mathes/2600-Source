;Check the state of the joystick and update dir if needed
;the trickery going on here is that the BIT command not only ands A with memory,
;it also puts the High bit (B7) of the memory location into the N bit and 
;B6 into the overflow bit

check_joystick0		subroutine
	lda	#$10
	bit SWCHA			
	beq	move_up	;if bit 5 is 0, then move up
	bpl	move_right	;if the N bit is clear, move right
	bvs	not_left	;if the overflow bit is set, it is not a left move
	
	lda	#LEFT_DIR	;if we got here, we are moving left
	bne	done_moving

not_left			;if we got here we are moving down or not at all
	lda	#$20
	bit	SWCHA		
	bne	no_moves	;if the bit is not set, we are not moving
	lda	#DOWN_DIR	;got here, must be going down
	bne done_moving

move_up
	lda	#UP_DIR
	bne done_moving	

move_right
	lda	#RIGHT_DIR	

done_moving
	bit gamenum		;check for easy/hard control game bit 7 set = hard
	bmi joy0_pro
	tax				;save off new dir
	eor dir0
	cmp #$0A		;see if we are changing to the opposite direction
	beq no_moves
	txa				;restore old dir
joy0_pro
	sta	dir0
no_moves

