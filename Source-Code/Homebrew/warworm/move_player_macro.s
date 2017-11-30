;****************************************************************
;Macro to move a player
; mac_move_player CXP0FB,dir0,xpos0,ypos0,score1
; mac_move_player CXP1FB,dir1,xpos1,ypos1,score0
;{1} = name of the collsion register to check
;{2} = dir variable to use
;{3} = xpos variable to use
;{4} = ypos variable to use
;{5} = __OPPONENTS__ score variable


	MAC	mac_move_player	
;check if player one hit the playfield
	bit	{1}			;check collision register
	bpl .no_coll
	jmp .game_over

.no_coll
.check_left
	lda	#LEFT_DIR
	cmp {2}			;compare to dir variable
	bne	.check_right

	;first make sure we are not already on the edge of the screen (game over)
	lda	#0
	cmp	{3}			;check xpos
	beq	.game_over

	;next do the move
	dec {3}			;dec xpos
	bpl	.finished_move

.check_right

	lda	#RIGHT_DIR
	cmp {2}			;compare to dir variable
	bne	.check_up

	;first make sure we are not already on the edge of the screen (game over)
	lda	#PFWIDTH-1
	cmp	{3}			;check xpos
	beq	.game_over

	;next do the move
	inc {3}			;inc xpos
	bpl	.finished_move

.check_up
	lda	#UP_DIR
	cmp	{2}			;compare to dir variable
	bne	.check_down

	;first make sure we are not already on the edge of the screen (game over)
	lda	#PFHEIGHT-1
	cmp	{4}			;check ypos
	beq	.game_over

	;next do the move
	inc {4}			;inc ypos

	bpl .finished_move

.check_down
	lda	#DOWN_DIR
	cmp	{2}			;compare to dir variable
	bne	.game_over

	;first make sure we are not already on the edge of the screen (game over)
	lda	#0			
	cmp	{4}			;check ypos
	beq	.game_over

	;next do the move
	dec {4}			;dec ypos

	bpl .finished_move

.game_over

	lda	#0		;set dir to zero
	sta	{2}

	sed
	clc
	lda	#1		;add point to oppenent's score
	adc	{5}
	sta {5}
	cld
	
	lda	#PAUSE_BETWEEN
	sta	pause

.finished_move

	ENDM
;	lda	#$08	   		
;	sta	AUDV0
