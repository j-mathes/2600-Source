update_missiles
	lda	missspeed
	sta	misscount

;check missile zero collision with PF
	bit	CXM0FB
	bpl no_hit_pf0
	ldx	xmiss0
	ldy ymiss0
	jsr remove_piece
	;make a noise
	lda	#BLOCKFREQ
	sta	AUDF1
	lda	#BLOCKVOLUME
	sta	AUDV1
	lda	#BLOCKDESTROYTIME
	sta sounddelay
	
	bpl clear_miss0 ;works as long as BLOCKDESTROYTIME is seen as positive
no_hit_pf0
	lda	missdir0
	beq no_hit0
	
	lda	xmiss0
	cmp xpos1
	bne no_hit_before_move0
	lda ymiss0
	cmp ypos1
	beq player0_wins
no_hit_before_move0	

	lda	missdir0
check_left_miss0
	cmp #LEFT_DIR
	bne	check_right_miss0

	;first make sure we are not on the edge of the screen, if so clear the missile
	lda	#0
	cmp	xmiss0
	beq	clear_miss0

	;next do the move
	dec xmiss0
	lda	#$40		;move missile left
	sta	HMM0
	bpl	finished_missile0

check_right_miss0

	cmp	#RIGHT_DIR
	bne	check_up_miss0

	;first make sure we are not on the edge of the screen, if so clear the missile
	lda	#PFWIDTH-1
	cmp	xmiss0
	beq	clear_miss0

	;next do the move
	inc xmiss0
	lda	#$c0		;move missile right
	sta	HMM0
	bmi	finished_missile0

check_up_miss0
	cmp	#UP_DIR
	bne	down_miss0

;first make sure we are not on the edge of the screen, if so clear the missile
	lda	#PFHEIGHT-1
	cmp	ymiss0
	beq	clear_miss0

	;next do the move
	inc ymiss0
	bpl finished_missile0

down_miss0
	;cmp	#DOWN_DIR
	;bne	no_move_missile0

	;first make sure we are not already on the edge of the screen
	lda	#0
	cmp	ymiss0
	beq	clear_miss0

	;next do the move
	dec ymiss0
	bpl finished_missile0

clear_miss0
	lda	#0
	sta	missdir0		;clear missdir to zero (off)
	lda	#$02			
	sta	RESMP0			;set the missile to lock back with p0
	lda	#MISSILE_DELAY	;delay missile
	sta	missdelay0

finished_missile0
;check missile zero collision with P1
;	bit CXM0P
;	bpl no_hit0

	lda	xmiss0
	cmp xpos1
	bne no_hit0
	lda ymiss0
	cmp ypos1
	bne no_hit0	

player0_wins
	sed
	clc
	lda	#1		;add point to P0 score
	adc score0
	sta	score0
	cld
	lda	#0
	sta	dir1
	
	lda	#PAUSE_BETWEEN
	sta	pause
	
	jmp game_over
;	bpl finished_missile0
no_hit0


;check player 1 missile
;check missile 1 collision with PF
	bit	CXM1FB
	bpl no_hit_pf1
	ldx	xmiss1
	ldy ymiss1
	jsr remove_piece
	;make a noise
	lda	#BLOCKFREQ
	sta	AUDF1
	lda	#BLOCKVOLUME
	sta	AUDV1
	lda	#BLOCKDESTROYTIME
	sta sounddelay

	bpl clear_miss1
no_hit_pf1
	lda	missdir1
	beq no_hit1

	lda	xmiss1
	cmp xpos0
	bne no_hit_before_move1
	lda ymiss1
	cmp ypos0
	beq player1_wins

no_hit_before_move1	

	lda	missdir1
check_left_miss1
	cmp	#LEFT_DIR
	bne	check_right_miss1

	;first make sure we are not on the edge of the screen, if so clear the missile
	lda	#0
	cmp	xmiss1
	beq	clear_miss1

	;next do the move
	dec xmiss1
	lda	#$40		;move missile left
	sta	HMM1

	bpl	finished_missile1

check_right_miss1

	cmp	#RIGHT_DIR
	bne	check_up_miss1

	;first make sure we are not on the edge of the screen, if so clear the missile
	lda	#PFWIDTH-1
	cmp	xmiss1
	beq	clear_miss1

	;next do the move
	inc xmiss1
	lda	#$c0		;move missile right
	sta	HMM1

	bmi	finished_missile1

check_up_miss1
	cmp	#UP_DIR
	bne	down_miss1

;first make sure we are not on the edge of the screen, if so clear the missile
	lda	#PFHEIGHT-1
	cmp	ymiss1
	beq	clear_miss1

	;next do the move
	inc ymiss1

	bpl finished_missile1

down_miss1

	;first make sure we are not already on the edge of the screen (game over)
	lda	#0
	cmp	ymiss1
	beq	clear_miss1

	;next do the move
	dec ymiss1
	bpl finished_missile1


clear_miss1

	lda	#0
	sta	missdir1		;clear missdir to zero (off)
	lda	#$02			
	sta	RESMP1			;set the missile to lock back with p0
	lda	#MISSILE_DELAY	;delay missile
	sta	missdelay1
	bpl no_move_missile1 ;skip the sound turn back on

finished_missile1
;check missile zero collision with P1
;	bit CXM1P
;	bpl no_hit1

	lda	xmiss1
	cmp xpos0
	bne no_hit1
	lda ymiss1
	cmp ypos0
	bne no_hit1	

player1_wins		
	sed
	clc
	lda	#1		;add point to P1 score
	adc score1
	sta	score1
	cld

	lda	#0
	sta	dir0
	
	lda	#PAUSE_BETWEEN
	sta	pause
	
	jmp game_over
	
;	bmi finished_missile1
no_hit1


no_move_missile1


