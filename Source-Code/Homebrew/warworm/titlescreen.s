TITLE_PF_COL 		=  GREEN | LUM5
TITLE_BORDER		= WHITE
TITLE_SCREEN_BACKGROUND	= BLACK
TITLE_BACKGROUND	= GRAY | LUM2

	IF	MW_CLASSIC = 1
TITLE_COLOR			= BLUE | LUM7
PRESENTS_COLOR		= BLUE | LUM5
	ELSE
TITLE_COLOR			= GOLD | LUM7
PRESENTS_COLOR		= GOLD | LUM5
	EIF
	
COPYRIGHT_COLOR		= GRAY | LUM4


;set this to 1 to get the Electronics Game Expo edition
EGE_EDITION	= 0
EGE_COLOR = PURPLE_BLUE | LUM4

title_screen

;	lda	#0			;clear out the PFs
;	sta	PF1			
;	sta	PF2
;	sta	PF0

;set playfield color
	lda	#TITLE_PF_COL
	sta COLUPF

	IF	EGE_EDITION = 1
	lda	#$00
	sta	pause
	EIF
	
title_frame
;Vertical sync
	jsr start_vertical_sync

;clear this stuff out so the heads or missiles don't get drawn with the playfield
	lda	#0
	sta	dir0
	sta	dir1
	sta	miss0index
	sta	miss1index

;check the switches
;check for reset
	lda SWCHB
	and	#1
	bne	title_no_reset
	jmp	main_game
title_no_reset

;check for select
	lda	SWCHB
	and #$02
	bne title_no_select
	jmp select_screen
title_no_select

	jsr random			;next random number
;wait for the vertical blank to end
	jsr wait_timer
	sta WSYNC
	sta	VBLANK   ;A comes back as zero, end vblank

; set up draw routine, this is called here because otherwise it leaves lines on the edge
; that overwrite the border (I am not sure why it leaves the lines)
    jsr	drawit_init	
						
;top border
	sta WSYNC
	lda	#TITLE_BORDER
	sta	COLUBK

	ldy	#9		;1 previous WSYNC's + 9 = 10
	jsr wait_lines	;wait 8 lines

	lda	#TITLE_SCREEN_BACKGROUND		
	sta	COLUBK

	sta WSYNC	;space two lines
	sta	WSYNC

    lda	#TITLE_COLOR                  ; set color for graphic
    sta	COLUP0
    sta	COLUP1

;setup a background for the text
	sta WSYNC
	lda	#TITLE_BACKGROUND
	sta	COLUPF
	lda	#$fe
	sta	PF2

;load and draw "Baroque Gaming"
	mac_load_and_draw baroque_gaming_table,18

;set color for "Presents"
    lda	#PRESENTS_COLOR                  ; set color for graphic
    sta	COLUP0
    sta	COLUP1

;load and draw "Presents"
	mac_load_and_draw presents_table,7

;turn off background
	sta WSYNC
	lda	#TITLE_PF_COL
	sta	COLUPF
	lda	#$00
	sta	PF2

	jsr load_warring_worms

	lda	#14
	sta	outercnt
	jsr	fielddraw

	ldy	#10
	jsr wait_lines	;wait ten lines
	
	lda	#TITLE_BORDER
	sta	COLUBK

	ldy	#8
	jsr wait_lines	;wait 8 lines

	;clear border
	lda	#$00
	sta	WSYNC
	lda	#TITLE_SCREEN_BACKGROUND		
	sta	COLUBK

	
    lda	#COPYRIGHT_COLOR                  ; set color for graphic
    sta	COLUP0
    sta	COLUP1


;load and draw "copyright"
	mac_load_and_draw copyright_table,7
	IF	EGE_EDITION = 1
	
	lda #EGE_COLOR
    sta	COLUP0
    sta	COLUP1

	inc pause
	lda pause
	cmp #60
	bmi draw_electronic
	cmp	#120
	bmi draw_games
	cmp	#180
	bmi draw_expo

	lda	#00
	sta	pause
	
	
draw_electronic
	mac_load_and_draw electronic_table,8
	jmp end_titlescreen_frame
	
draw_games
	mac_load_and_draw games_table,8
	jmp end_titlescreen_frame	
	
draw_expo
	mac_load_and_draw expo_table,9
	jmp end_titlescreen_frame	

	EIF
end_titlescreen_frame	
	sta WSYNC

	jsr start_Overscan			;start overscan
	jsr wait_timer             	;wait for overscan to end

	jmp title_frame

