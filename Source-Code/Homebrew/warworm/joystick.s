

check_button1	subroutine
	lda	missdir1
	bne nofire_1		;already active missle, no more firing
	lda	missdelay1		;check to implement the delay between firing
	beq	start_check_button1		
	dec missdelay1		;decrement delay count
	bpl	nofire_1		;don't fire

start_check_button1
	
;see if this is a one-player game (high digit set), 
;if we call this sub while in one-player mode, we just
;want to fire, no checking of joystick needed
	lda	gamenum
	and	#$08
	bne .no_check_button

	bit INPT5
	bmi nofire_1


.no_check_button
	;setup laser noise
	lda	#FIREFREQ
	sta	AUDF1
	lda	#FIREVOLUME
	sta	AUDV1
	lda	#FIRENOISETIME
	sta sounddelay

	lda	dir1		;if a fire, then save the direction and pos of the fire into missdir and misspos
	sta	missdir1
	lda	xpos1
	sta	xmiss1
	lda	ypos1
	sta	ymiss1

	lda	#0
	sta	RESMP1		;release it from P1

	lda	#RIGHT_DIR	;see if the missile is going (left or right) or (up or down)
	cmp missdir1
	bmi	miss1_up_or_down	
	lda	#MISS_2CLK
	jmp done_fire1

miss1_up_or_down
	lda	#MISS_1CLK
done_fire1	
	sta	NUSIZ1
nofire_1
	rts
;**********************************************************
one_player_missile		subroutine
;check 4 ahead and see if we want to fire


	lda	dir1
	beq .no_fire
	ldx	xpos1
	ldy	ypos1
;	lda	dir1
	cmp	#LEFT_DIR
	bne .check_right_for_miss
	tya	;save y
	ldy temp4
.check_left_loop
	dex	;adjust x to left
	dey
	bpl .check_left_loop
	tay	;restore y
	jmp .done_check_for_miss
;;;;;;;
.check_right_for_miss
	cmp	#RIGHT_DIR
	bne .check_up_for_miss
	tya	;save y
	ldy temp4
.check_right_loop
	inx	;adjust x to right
	dey
	bpl .check_right_loop
	tay	;restore y
	bpl .done_check_for_miss
;;;;;;;
.check_up_for_miss
	cmp #UP_DIR
	bne .check_down_for_miss
	txa	;save x
	ldx temp4
.check_up_loop
	iny ;adjust y up
	dex
	bpl .check_up_loop
	tax	;restore x
	jmp .done_check_for_miss
;
.check_down_for_miss		;if we got here we are going down
	txa	;save x
	ldx temp4
.check_down_loop
	dey ;adjust y down
	dex
	bpl .check_down_loop
	tax	;restore x

.done_check_for_miss
	bmi .no_fire	;if we just dec'ed below zero
	cpy	#PFHEIGHT
	bpl	.no_fire
	cpx #PFWIDTH
	bpl .no_fire
	jsr check_piece		;see if we there is something there
	beq .no_fire
.hit_for_miss
	jsr check_button1	;fire off a missile!
	jmp .exit_sub
.no_fire
	lda	missdelay1		;check to implement the delay between firing
	beq	.exit_sub
	dec missdelay1		;decrement delay count
.exit_sub
	rts
;**********************************************************
one_player_mode 	subroutine
;temp4 comes in with the number of spaces ahead to check, $FF for proximity check
	lda la_temp
	cmp	#$0F			;check to see if the other guy is one away in any dir
	bne .check_for_dodge
	lda	xpos1
	sec					;set carry so sub works right
	sbc xpos0
	cmp	#$01
	bne .check_FF
	jmp .hit
.check_FF
	cmp	#$FF
	bne .check_ypos
	jmp .hit
.check_ypos
	lda	ypos1
	sec					;set carry so sub works right
	sbc ypos0
	cmp	#$01
	beq .hit
	cmp	#$FF
	beq .hit	
	jmp .exit_sub	
.check_for_dodge	
	lda la_temp
	cmp	#$0E
	bne .check_for_turn
	lda ymiss0
	cmp ypos1
	beq .check_for_opp
	lda xmiss0
	cmp xpos1
	bne .go_exit_sub
.check_for_opp	
	lda	dir1		;eor'ing the dirs will yield 0101 if they are in opposite dirs
	eor missdir0
	
	cmp #$0A		
	beq .hit
.go_exit_sub
	jmp .exit_sub	
.check_for_turn
	ldx	xpos1
	ldy	ypos1
	lda	dir1
	cmp	#LEFT_DIR
	bne .check_right
	tya	;save y
	ldy la_temp
.check_left_loop
	dex	;adjust x to left
	dey
	bpl .check_left_loop
	tay	;restore y
	jmp .done_check
;;;;;;;
.check_right
	cmp	#RIGHT_DIR
	bne .check_up
	tya	;save y
	ldy la_temp
.check_right_loop
	inx	;adjust x to right
	dey
	bpl .check_right_loop
	tay	;restore y
	bpl .done_check
;;;;;;;
.check_up
	cmp #UP_DIR
	bne .check_down
	txa	;save x
	ldx la_temp
.check_up_loop
	iny ;adjust y up
	dex
	bpl .check_up_loop
	tax	;restore x
	jmp .done_check
.check_down		;if we got here we are going down
	txa	;save x
	ldx la_temp
.check_down_loop
	dey ;adjust y down
	dex
	bpl .check_down_loop
	tax	;restore x
.done_check

	cpy	#$00	
	bmi .edge_hit	;if we just dec'ed below zero
	cpx	#$00	
	bmi .edge_hit	;if we just dec'ed below zero
	cpy	#PFHEIGHT
	bpl	.edge_hit
	cpx #PFWIDTH
	bpl .edge_hit
	jsr check_piece		;see if we are about to hit something
	beq .no_hit
	bne .hit
.edge_hit
	lda gamenum		
	and	#$20	
	bne .no_hit		;if wrap, ignore edge_hits
.hit
	lda	#$01			;if we are on an odd x position move one way, even, another
	bit xpos1
	bne .even
.odd
	clc
	lda dir1
	adc #3
	cmp #15
	bne .no_wrap
	lda	#3
	bne .no_wrap
.even
	sec					;set carry so sub works right
	lda dir1
	sbc #3	
	bne .no_wrap
	lda	#12

.no_wrap
	sta dir1

	lda la_temp
	bne .no_fire
	lda	#$FF		;set up to fire a missile after the next frame starts
	sta temp3
.no_fire
	
	jmp	.exit_sub
.no_hit		;not going to hit
	lda la_temp
	beq .exit_sub
	lda	rand0	;check for random turn
	cmp #$03
	bpl .exit_sub
	cmp #$0a
	bpl .hit

;	cmp	#$5A
;	beq .hit	
.exit_sub
	rts