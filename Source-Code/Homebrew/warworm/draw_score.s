draw_score	subroutine
	lda	#8
	sta	innercnt	;use innercount to count the eight rows in the numbers

;setup the players to double
	lda	#4
	sta	NUSIZ0
	sta	NUSIZ1

;set the counter for positioning P0,P1
	ldy	#6

	lda	#<score_digits
	sta	digits_base
	lda	#>score_digits
	sta	digits_base+$01

	sta	WSYNC	
	nop
;position P0,P1
.wait_pos		;delay loop
	dey
	bne .wait_pos
	sta	RESP0
	sta	RESP1

;show scores cannot cross a page boundary, thus the org statement may be required
;	jmp show_scores
;	org	$f400

;	ldx	#P1COLOR
	ldx	temp7
show_scores
	sta	WSYNC
;	lda	#P0COLOR
	lda	temp6
	sta	COLUP0
	sta	COLUP1

	ldy	temp0
	lda	(digits_base),y
	sta	GRP0

	ldy	temp1
	lda	(digits_base),y
	sta	GRP1

	ldy	temp2
	lda	(digits_base),y
	sta	GRP0
	stx	COLUP0

	ldy	temp3
	lda	(digits_base),y
	sta	GRP1
	stx	COLUP1

	inc digits_base

	dec	innercnt
	bne	show_scores

	sta WSYNC
	lda	#0
	sta	GRP0
	sta	GRP1

;set the colors back right
	lda	#P0COLOR
	sta	COLUP0
	lda	#P1COLOR
	sta	COLUP1
;setup the players back to the correct width
;	lda	#RIGHT_DIR	;see if the missile is going (left or right) or (up or down)
;	cmp missdir0
;	bmi	after_score_miss0_up_or_down	
;	lda	#MISS_4CLK
;	jmp after_score_miss0_right_or_left	
;after_score_miss0_up_or_down
;	lda	#MISS_1CLK
;after_score_miss0_right_or_left	
;	sta	NUSIZ0
;
;	lda	#RIGHT_DIR	;see if the missile is going (left or right) or (up or down)
;	cmp missdir1
;	bmi	after_score_miss1_up_or_down	
;	lda	#MISS_4CLK
;	jmp after_score_miss1_right_or_left	
;after_score_miss1_up_or_down
;	lda	#MISS_1CLK
;after_score_miss1_right_or_left	
;	sta	NUSIZ1
	

	lda	#$0
	sta	NUSIZ0
	sta	NUSIZ1