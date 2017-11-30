win0
	lda	#P0COLOR
	sta	win_color
	bne draw_win_screen
win1
	
	lda	#P1COLOR
	sta	win_color
draw_win_screen
	cld
	lda     #$00
   	sta     AUDV0
   	sta     AUDV1
	;set playfield color	
;	lda	win_color
;	sta COLUPF
	lda	#60
	sta	pause
win_screen_frame
;Vertical sync
	jsr start_vertical_sync

;clear this stuff out so the heads or missiles don't get drawn with the playfield
	lda	#0
	sta	dir0
	sta	dir1
	sta	miss0index
	sta	miss1index

	dec pause
	lda	pause
	cmp #30
	bmi win_normal
	
win_inverse
	lda	#BLACK
	sta	COLUPF
	lda	win_color
	sta	COLUBK
	jmp	no_reset_win_delay
	
win_normal
	lda	win_color
	sta	COLUPF
	lda	#BLACK
	sta	COLUBK

	lda	pause
	bne no_reset_win_delay
	lda	#60
	sta	pause
	
no_reset_win_delay
	
;check the switches
;check for reset
;	lda SWCHB
;	and	#1
;	bne	win_no_reset
;	jmp	main_game
win_no_reset
;check for select
	lda	SWCHB
	and #$02
	bne win_no_select
	jmp select_screen
win_no_select

;wait for the vertical blank to end
	jsr wait_timer
	sta WSYNC
	sta	VBLANK   ;A comes back as zero, end vblank

	ldy	#40
	jsr wait_lines	;wait ten lines

	jsr load_warring_worms

	lda	#14
	sta	outercnt
	jsr	fielddraw

	ldy	#40
	jsr wait_lines	;wait ten lines

	sta WSYNC

	jsr start_Overscan			;start overscan
	jsr wait_timer             	;wait for overscan to end

	jmp win_screen_frame

