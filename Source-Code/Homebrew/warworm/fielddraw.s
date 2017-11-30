;draw the playfield
;one blank line followed by 6 drawn lines
;outercnt must be set up outside the subroutine to tell it how many lines to draw

fielddraw	subroutine	

	lda	#0			;a needs to start zero (is cleared again at end of outer loop)
outer_draw
;------------------------------------
	sta	head0index	;initialize the head indexes
	sta	head1index

	lda	ypos0				;3
	cmp outercnt			;4
	bne no_head0			;2-3
	lda	dir0				;3   	;add dir to get to the correct offset
	sta	head0index			;3
no_head0

	lda	ypos1
	cmp outercnt
	bne no_head1		
	lda	dir1				;add dir to get to the correct offset
	sta	head1index
no_head1
;------------------------------------
	lda #3				;inner draw loop is 3
	sta	innercnt

	ldx	outercnt		;load the linecnt into x
	lda	leftpf1,x
	ldy	leftpf2,x
	
inner_draw
	sta	WSYNC		;wait for the sync

	sta	PF1			;store the graphics for the left side of the screen
	sty	PF2+$100	;add $100 so that it will not be a zero page store and take
					;one cycle extra so this turns out just barely right! 
					;(registers are mirrored at $100 intervals)

	ldy	head0index
	lda	#snake_heads,y	
	sta	GRP0

	ldy	head1index
	lda	#snake_heads,y	
	sta	GRP1

	inc	head1index	;increment the indexes
	inc	head0index

	lda	rightpf1,x	;load the right side
	ldy	rightpf2,x

	sty	PF2			;store the graphics for the right side of the screen
	sta	PF1			

	lda	leftpf1,x	;reload the left side
	ldy	leftpf2,x	

;	nop
;	nop

	sta	WSYNC		;wait for the sync
	
	sta	PF1			;store the graphics for the left side of the screen
	sty	PF2+$100

	ldy	miss0index
	lda	#missile_enables,y	
	sta	ENAM0

	ldy	miss1index
	lda	#missile_enables,y	
	sta	ENAM1

	inc	miss0index	;increment the indexes
	inc	miss1index

	lda	rightpf1,x	;load the right side
	ldy	rightpf2,x

	sty	PF2			;store the graphics for the right side of the screen
	sta	PF1			

	lda	leftpf1,x	;reload the left side
	ldy	leftpf2,x	
	
	dec innercnt
	bne inner_draw

	lda	#0			;clear out the PFs and GRP
	sta	GRP0		;clear the graphics
	sta	GRP1		

	sta	PF1			
	sta	PF2


	dec	outercnt		;count from PFHEIGHT-1 down to 0
	bpl outer_draw		

	rts
;************************************************************************
;clear the whole playfield

clear_playfield 	subroutine
	lda	#0
	ldx	#92
.loop
	sta	leftpf1,x
	dex
	bpl .loop
	rts
;************************************************************************
;place piece subroutine
;x position to place comes in x, y position in y
place_piece 	subroutine

	txa
	and #$18		;take away the stuff we don't care about
;check which column it is in
.check0
;	cmp	#$00	;don't need the cmp #$00
	bne	.check1

	jsr	gen_nor_mask	;generate the mask 
	ora	#leftpf1,y	;or in what is already there
	sta	#leftpf1,y	;save it off
	
	jmp done_placing

.check1
	cmp	#$08
	bne	.check2

	jsr	gen_inv_mask	;generate the mask 
 	ora	#leftpf2,y
	sta	#leftpf2,y
	
	jmp done_placing

.check2
	cmp	#$10
	bne	.check3

	jsr	gen_nor_mask	;generate the mask 
 	ora	#rightpf2,y
	sta	#rightpf2,y

	jmp done_placing

.check3
	cmp	#$18
	bne	done_placing

	jsr	gen_inv_mask	;generate the mask 
 	ora	#rightpf1,y
	sta	#rightpf1,y


done_placing
	rts	

;************************************************************************
;remove piece subroutine
;x position to place comes in x, y position in y
remove_piece 	subroutine

	txa
	and #$18		;take away the stuff we don't care about
;check which column it is in
.check0
;	cmp	#$00	;don't need the cmp #$00
	bne	.check1

	jsr	gen_nor_mask	;generate the mask	
	eor	#$FF			;invert the mask
	and	#leftpf1,y	;and in what is already there
	sta	#leftpf1,y	;save it off
	
	jmp .done

.check1
	cmp	#$08
	bne	.check2

	jsr	gen_inv_mask	;generate the mask 
	eor	#$FF			;invert the mask
 	and	#leftpf2,y
	sta	#leftpf2,y
	
	jmp .done

.check2
	cmp	#$10
	bne	.check3

	jsr	gen_nor_mask	;generate the mask 
	eor	#$FF			;invert the mask
 	and	#rightpf2,y
	sta	#rightpf2,y

	jmp .done

.check3
	cmp	#$18
	bne	.done

	jsr	gen_inv_mask	;generate the mask 
	eor	#$FF			;invert the mask
 	and	#rightpf1,y
	sta	#rightpf1,y
.done
	rts	

;************************************************************************
;check piece subroutine
;x position to checl comes in x, y position in y; A returns True or false
check_piece 	subroutine

	txa
	and #$18		;take away the stuff we don't care about
;check which column it is in
.check0
;	cmp	#$00		;don't need the cmp #$00
	bne	.check1

	jsr	gen_nor_mask	;generate the mask	
	and	#leftpf1,y	;and it
	jmp .done

.check1
	cmp	#$08
	bne	.check2

	jsr	gen_inv_mask	;generate the mask 
 	and	#leftpf2,y
	jmp .done

.check2
	cmp	#$10
	bne	.check3

	jsr	gen_nor_mask	;generate the mask 
 	and	#rightpf2,y
	jmp .done

.check3
	cmp	#$18
	bne	.done

	jsr	gen_inv_mask	;generate the mask 
 	and	#rightpf1,y

.done
	rts	

;************************************************************************
;generate mask subroutine, inverse and normal
;arguments:
;X	- the x postion
;returns
;X  - is zero
;A	- is set to the mask
gen_nor_mask	subroutine
	;jsr mask_setup		;common to both inverse and normal
	txa			;put the position into A
	and	#$07	;only care about the low 3 bytes
	tax
	inx			;increment x (rotate one more than the bit)
	sec
	lda	#$00

	;bits go 7->0, so use ror, we want to ror at least once so we
	;don't have to check for zero before we even start.  Set the carry bit and
	;set A to $00.  Note: ROR rotates through the carry bit
.rotate_right
	ror
	dex
	bne .rotate_right
	
	rts

gen_inv_mask	subroutine
	;jsr	mask_setup
	txa			;put the position into A
	and	#$07	;only care about the low 3 bytes
	tax
	inx			;increment x (rotate one more than the bit)
	sec
	lda	#$00

	;this is leftpf2, bits go 0->7, so use rol, set the carry bit and clear A
.rotate_left
	rol
	dex
	bne .rotate_left

	rts

;mask_setup		subroutine
;	txa			;put the position into A
;	and	#$07	;only care about the low 3 bytes
;	tax
;	inx			;increment x (rotate one more than the bit)
;	sec
;	lda	#$00

;	rts
;************************************************************************
;sets up a stock playfield
;arguments:
;A	- is set to the playfield number

load_playfield subroutine
	clc		;multiply by 4
	rol
	rol
	tax
	lda	Playfields,x
	sta	temp0
	lda	Playfields+1,x
	sta	temp1
	lda	Playfields+2,x
	sta	temp2
	lda Playfields+3,x
	sta	temp3
		
	ldy	#22
.load_playfield_loop
	lda	(temp0),y
	sta	leftpf1,y
	sta	rightpf1,y
	lda	(temp2),y
	sta leftpf2,y
	sta rightpf2,y
	dey
	bpl	.load_playfield_loop

	rts
	
;;;;;;;;;;;;;;;;;;;
;copy the Wormy_Blaster stuff to the Playfield
;This is of course called Warring Worms now, Wormy_Blaster was the old
;name and I am too lazy to change the stuff!!
load_warring_worms
	ldx	#15
loop_WB
	lda	WBlpf1,x
	sta	leftpf1,x
	lda	WBlpf2,x
	sta	leftpf2,x
	lda	WBrpf2,x
	sta	rightpf2,x
	lda	WBrpf1,x
	sta	rightpf1,x
	dex
	bpl	loop_WB
	rts