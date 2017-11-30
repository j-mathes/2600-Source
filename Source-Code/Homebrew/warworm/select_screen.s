;gamenum determines game type
;bit7	: 0 = Easy Control, 1 = Hard Control
;bit6   : 0 = Missiles Enabled, 1 = Missiles Disabled
;bit5	: 0 = Non-Wrap Game, 1 = Wrap Game
;bit4   : 0 = Non-Hostile Env, 1 = Hostile Env
;bit3   : 0 = 2-Player, 1 = 1-Player
;bit2-0 : screen type

select_screen

	lda	#SELECT_DELAY
	sta	pause
	
;set the playfield to snake colored
	lda	#SNAKECOLOR
	sta	COLUPF
;set the ypos of the players
	ldx	#11		;starting y is 11
	stx ypos0
	stx ypos1

select_screen_frame
;Vertical sync
	jsr start_vertical_sync
	
	lda pause
	beq select_skip_dec_pause
	dec pause
select_skip_dec_pause	

;position heads and missiles
	lda	#0
	sta RESMP0
	sta RESMP1	
	sta	NUSIZ0
	sta	NUSIZ1
   	sta AUDV0
  	sta AUDV1


	sta	WSYNC
	ldx	#4
sel_pos_head0_loop
	dex
	bne	sel_pos_head0_loop
	nop
	sta RESP0
	
	nop
	nop
	nop
	sta RESM0
		
	ldx	#4
sel_pos_miss1_loop
	dex
	bne sel_pos_miss1_loop
	sta RESM1

	nop
	sta RESP1 + $100
	
	lda #$D0
	sta HMP0
	lda #$E0
	sta HMP1
	lda #$A0
	sta HMM1
	sta WSYNC
	sta HMOVE
	

	;set the Player / missile color
	lda	#P0COLOR
	sta	COLUP0
	lda	#P1COLOR
	sta	COLUP1

	;check the switches
	lda pause
	bne select_select_delay
	
	lda	#$10
	bit SWCHA
	bne select_check_for_down
;moving up, add 8 to the gamenum
	clc
	lda #$8
	adc gamenum
	sta gamenum
	jmp select_set_pause_it_20
	
select_check_for_down		
	lda	#$20
	bit	SWCHA		
	bne	select_no_move_joy0	;if the bit is not set, we are not moving down
	sec
	lda gamenum
	sbc #$8
	sta gamenum
	jmp select_set_pause_it_20

select_no_move_joy0
	
;check for select
	lda	SWCHB
	and #$02
	bne select_no_select
	;check for reset and select at the same time
	lda SWCHB
	and	#1
	bne select_no_reset_gamenum
	inc gamenum
	lda	#10
	bne select_set_pause_it

select_no_reset_gamenum		
	lda pause
	bne select_select_delay
	inc gamenum

select_set_pause_it_20
	lda	#20
select_set_pause_it	
	sta	pause
select_select_delay
	;dec pause
	jmp select_no_reset

select_no_select	
;check for reset
	lda SWCHB
	and	#1
	bne	select_no_reset
	jmp	main_game
select_no_reset	


;load up playfield
	lda	#$07
	and gamenum
	
	jsr load_playfield
	
;setup the way to display the screen to reflect game
	lda gamenum
	and #$10
	beq select_no_hostile_env

	ldy	#22	
select_show_hostile	
	lda	leftpf1,y
	ora #$10
	sta	leftpf1,y
		
	lda	rightpf1,y
	ora #$10
	sta	rightpf1,y
	
	lda	leftpf2,y
	ora #$10
	sta leftpf2,y
	
	lda	rightpf2,y
	ora #$10
	sta rightpf2,y
	dey
	dey
	dey
	dey
	bpl	select_show_hostile
	
select_no_hostile_env
;see if this is a hard control or easy control game
	lda gamenum	
	and #$80
	beq select_not_hard
	lda	#$80
	sta leftpf1+11
	sta rightpf1+11
	
select_not_hard		
;setup 1player/2player	
	lda	#RIGHT_DIR
	sta	dir0

	lda gamenum
	and	#$08	
	bne select_1_player_game
	lda	#LEFT_DIR
	sta dir1
	lda #33
	sta miss1index
	jmp select_check_miss_on_off
select_1_player_game	
	lda	#0
	sta dir1
	lda #67
	sta miss1index

select_check_miss_on_off
	lda gamenum
	and #$40
	beq select_missiles_on
	lda #67
	sta	miss0index
	sta	miss1index
	bne select_done_miss
select_missiles_on
	lda #33
	sta	miss0index
select_done_miss

	;wait for the vertical blank to end
	jsr wait_timer
	sta WSYNC
	sta	VBLANK   ;A comes back as zero, end vblank

;	ldy	#10
;	jsr wait_lines	;wait ten lines

	sta WSYNC
	lda	#SNAKECOLOR
	sta	COLUBK

;use pf0 to make the left and right outline, if non-wrap mode
	lda gamenum
	and #$20
	bne select_wrap_game	
	lda	#$80
	bne select_sta_PF0
select_wrap_game
	lda	#$00
select_sta_PF0		
	sta	PF0		;make an outline

	ldy	#7			;wait 7 lines
	jsr wait_lines	
	
;set the background	
	sta	WSYNC		
	lda	#BACKGROUND
	sta	COLUBK		

	;set up the counts so the subroutine knows how many lines to draw
	lda #PFHEIGHT-1
	sta	outercnt
	jsr	fielddraw

	sta WSYNC
	lda	#SNAKECOLOR
	sta	COLUBK

	ldy	#7			;wait 7 lines
	jsr wait_lines	
	
	lda	#$00
	sta	PF0		;clear outline
	
	lda	#$00
	sta COLUBK


	sta	WSYNC
	ldx	#7
sel_pos_head0_loop_2
	dex
	bne	sel_pos_head0_loop_2
	nop
	sta RESP0 + $100
	nop
	nop
	sta RESP1 + $100
	
	lda #SELECTNUMCO0
	sta COLUP0
	lda #SELECTNUMCO1
	sta COLUP1

	sta WSYNC
	lda	#$08
	sta	PF2	
	sta WSYNC
	
	lda #$07
	sta NUSIZ0	
	
	lda gamenum		;show the high 5 bits as indicators
	and #$F8
	sta GRP0
	
	lda	#<score_digits
	sta	digits_base
	lda	#>score_digits
	sta	digits_base+$01

	lda gamenum		;show the low three to represent playfield
	and #$07
	asl
	asl
	asl
	tay
	

	ldx #8
select_draw_fieldnum
	sta WSYNC
	lda	(digits_base),y
	sta	GRP1
	iny
	dex
	bne select_draw_fieldnum
	sta WSYNC

	lda #0
	sta GRP0
	sta GRP1
	sta WSYNC
	sta	PF2

	jsr start_Overscan			;start overscan
	
	jsr wait_timer             	;wait for overscan to end

	jmp select_screen_frame


	
