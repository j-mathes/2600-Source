setup_score 	subroutine
;set up the score indexes
	clc				;clear carry so the rol works like *2

	
score_set_not_select
;setup the indices into player 0 score
	;tens digit
	lda	score0
	sta	temp0
	lda	#$F0
	and temp0
	ror 
	sta	temp0
	;ones digit
	lda	score0
	sta	temp1
	lda	#$0F
	and	temp1
	rol 
	rol 
	rol 
	sta	temp1

;setup the indices into player 1 score
	;tens digit
	lda	score1
	sta	temp2
	lda	#$F0
	and temp2
	ror 
	sta	temp2
	;ones digit
	lda	score1
	sta	temp3
	lda	#$0F
	and	temp3
	rol 
	rol 
	rol 
	sta	temp3