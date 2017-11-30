;Warring Worms
;First try is to just make something work.
;01 - In this case I am just going to draw a background;
;02 - drawing a moving background (not really gonna use it in snakes, but who knows?)
;03 - just a wierd intermidiate step along the way
;04	- getting the playing field going
;05 - playfield seems to be working
;06	- joystick working, full playfield working, now what do I make the game do?
;07	-	?
;08 - example of how the missiles work, swithcing to snake heads!!!
;09	- snake heads started!
;10	- snake zero fully functional
;11 - semi-functional two snakes, playfield not being drawn well
;		starting over with v10
;12 - re-functional with one snake, yposition is now inverted
;13 - some functional with the head of the second snake
;14 - making the heads,missiles be repositioned during the vertical blank
;15 - didn't do what I said in 14, now about to try something to make no blank lines
;16 - missiles now functioning!  Collision detection activated! Almost a real game!
;17 - both snakes now fully functioning
;18 - score functioning, snake heads broken
;19 - score display working, snake heads, missiles good.
;20 - start of an opening screen
;21 - Opening screen display working
;22 - more improvements to opening screen, missile delay implemented
;23 - save before renaming select screen to title screen
;24 - Now Possible to change background screens, 10 choices!
;25 - Beta release one (except for a few background changes)
;26 - Working AI, release to Stella
;27 - few changes, cleaning dir to un-seperate subroutines for performance reasons :<
;28 - made heads indestructable, moved the select numbers, release to Stella
;29 - randomly appearing blocks added to higher levels
;;;;;
;Difficulty (Left Player)
;B-Faster
;A-Slower

;Game Selects
;Normal Edges
;00-09 : 2-player
;10-19 : 1-player and 1 computer player
;20-29 : 2-player, hostile enviroment
;30-39 : 1-player and 1 computer player, hostile enviroment
;Wrap Mode
;40-49 : 2-player
;50-59 : 1-player and 1 computer player
;60-69 : 2-player, hostile enviroment
;70-79 : 1-player and 1 computer player, hostile enviroment


;Things to maybe do:
;1. Use the REFP0 & REFP1 registers to eliminate the need for left and right heads
;By Billy Eno
	processor 6502
    include "vcs.h"
;color defines
GRAY		=	$00
GOLD		=	$10
ORANGE		=	$20
BRT_ORANGE	=	$30
PINK		=	$40
PURPLE		=	$50
PURPLE_BLUE	=	$70
BLUE		=	$80
GREEN		=	$C0
LT_ORANGE	=	$F0

LUM1		= 	$00	
LUM2		=	$02
LUM3		= 	$04	
LUM4		= 	$06	
LUM5		= 	$08	
LUM6		= 	$0a	
LUM7		= 	$0c	
LUM8		=	$0e

;missile size defines
MISS_1CLK	=	$00
MISS_2CLK	=	$10
MISS_4CLK	=	$20
MISS_8CLK	=	$30


SNAKECOLOR	=	BLUE | LUM8
P0COLOR		=	BRT_ORANGE | LUM4
P1COLOR		=	GREEN | LUM4

P0SCORECOLOR =	BRT_ORANGE | LUM3
P1SCORECOLOR =	GREEN | LUM3

BACKGROUND	= 	GRAY | LUM2
BLACK		= 	GRAY | LUM1
WHITE		=	$FF
SELECTNUMCO0 =	LT_ORANGE | LUM4
SELECTNUMCO1 =	BRT_ORANGE | LUM4

;direction defines
LEFT_DIR	=	3		;%0011	U0101 R1010 D1111
UP_DIR		=	6		;%0110	L0101 R1111 D1010
RIGHT_DIR	=	9		;%1001  L1010 U1111 D0101
DOWN_DIR	=	12		;$1100	L1111 U1010 R0101

;playing field defines
PFHEIGHT	=	23
PFWIDTH		=	32

MISS_SPEED	=	3		;frames that a missile takes to move one block
SNAKE_MULT	=	3		;how many times slower the snake moves than the missiles
SNAKE_MULT_AM = 6

BLOCK_SPEED	=	MISS_SPEED * SNAKE_MULT * 2;starting block speed for hostile enviroment

NUM_GAMES	=	$80		;number of selectable games + 1, in BCD (Binary Coded Decimal)
START_GAME_NUM = $00	;starting game number (for debug)

PAUSE_BETWEEN = 60		;number of frames to pause between games
MISSILE_DELAY = 12		;number of frames between firing
SELECT_DELAY  = 30		;number of frames between selects

CHECK_FOR_FIRE = 5		;how far ahead to look ahead for firing missile
CHECK_FOR_TURN1 = 2
CHECK_FOR_TURN2	= 1

FIRENOISETIME	= 20
BLOCKDESTROYTIME = 10

FIREFREQ	= 1
FIREVOLUME	= 6
BLOCKFREQ	= $E
BLOCKVOLUME = 8

WIN_NUMBER	= $99		;score to show win screen (bcd)
;Ram variables.....

	        SEG.U   variables

;play field looks like this
;  |leftpf1 |leftpf2 |rightpf2|rightpf1| 
;--+--------+--------+--------+--------+
;  |76543210|01233457|76543210|01234567|
;--+--------+--------+--------+--------+
;\X|        |  111111|11112222|22222233|
;Y\|01234567|89012345|67890123|45678901|
;--+--------+--------+--------+--------+
;22| 
; ||
; 0|
	     	org $80
GRTABLE						;used by the drawing routine in the title screen
leftpf1		ds 23			;pf1 part of display (23 lines)
GRHEIGHT					;used by the drawing routine in the title screen
leftpf2		ds 23			;pf2 part of display (23 lines)
TEMPVAR						;used by the drawing routine in the title screen
rightpf2	ds 23			;pf2 part of display (23 lines)
rightpf1	ds 23			;pf1 part of display (23 lines)
						 	;=92 bytes

win_color					;used to save the win color
xpos0		ds	1			;current x position
ypos0		ds	1			;current y position
dir0		ds	1			;current direction

xpos1		ds	1			;current x position
ypos1		ds	1			;current y position
dir1		ds	1			;current direction

xmiss0		ds	1
ymiss0		ds	1
missdir0	ds	1

xmiss1		ds	1
ymiss1		ds	1
missdir1	ds	1

speedup		ds	1			;counter controlling the speed-up rate
la_temp						;innercnt aliases to a lookahead temp
innercnt	ds	1			;used to draw the screen and scores

missspeed	ds	1			;what missspeed gets updated with
misscount	ds	1			;frames between missile move
gamecount	ds	1			;number of missile updates per move
sounddelay	ds	1			;how long before sound channel 1 is silenced
blockcount	ds	1			;block count (frames till a new block is added in hostile enviroment game)

score0		ds	1			;score, player0
score1		ds	1			;score, player1

rand0		ds	1			;16 bit random number
rand1		ds	1

gamenum		ds	1			;select number

missdelay0					;delay between missiles, p0
pause		ds	1			;counts the frames between games
missdelay1	ds	1			;delay between missiles, p1

head0index					;index into the head graphics
temp0		ds 	1			;used for temp variables, including digit offsets
head1index					;index into the head graphics
temp1		ds	1
miss0index					;index into the missile graphics
temp2		ds	1
miss1index					;index into the missile graphics
temp3		ds	1

temp4
digits_base	ds	1			;digits_base uses both temp4 and temp5
temp5		ds	1			;31bytes

outercnt					;used to draw the screen, outerloop, also the y position
temp6		ds	1			;these 4 bytes are used for the stack (they will get wiped when calling subs)
temp7		ds	1
temp8		ds	1
temp9		ds	1

;max stack depth is two subroutines deep (4 bytes)
	SEG code

	org	$f000
	include "macros.s"				;some macros
	include "move_player_macro.s"	;player move macro
	include "wrap_move_player_macro.s"	;wrap mode player move macro
	include "fielddraw.s"			;fielddraw clear_playfield subroutine
	include "common.s"				;common subs

	include "joystick.s"			;joystick subs


;Setup stuff
start
	sei             ;clear interupts
	cld             ;set to non-BCD mode

;initialize the registers/ram and intialize the random bits
;from Kevin Hortons random number generator post on the Stella list, Oct, 2001
init2600
	ldx #$000     ;start at byte 00h in RAM

ir_loop
	txa
	eor #$01      	;prevent XORing regs with themselves
    and #$01      	;make sure all both regs get a chance at being
    tay           	;seeded
    lda $000,x
    eor rand0,y   	;xor is best for this since all bits have an
    sta rand0,y   	;equal chance at being flipped.
    lda #$00    	;load #00h into RAM
    sta $000,x
    txs           	;set stack to 0ffh at end of loop :-)
    inx
    bne ir_loop
    lda rand0
    ora rand1		;check for $0000h state. bad juju if so

    bne no_prob
	inc rand0     ;set rand0 to 001h.
no_prob

	ldx #$ff        ;set up top of stack to $ff	
	txs             ;transfer to stack
    
;Clear all memory except $ff/$1ff - Stack end
;	lda #0
;clear
;	sta $ff,x		;x still has $ff in it
;	dex
;	bne clear		;x comes out with 0

;set up playfield mirroring
	lda	#1
	sta	CTRLPF	;set playfield to mirror

;initialize gamenum
	lda	#START_GAME_NUM
	sta	gamenum	

;; Title screen code
	include	"titlescreen.s"
;;
	include "select_screen.s"
	
main_game
;initialize variables and stuff
	lda	#23
	sta	AUDF0
	lda	#$00	   		
	sta	AUDV0
	lda	#$02
	sta	AUDC0

;	lda	#00
	lda	#$1
	sta	AUDF1
	lda	#$00	   		
	sta	AUDV1
;	lda	#$03
	lda	#$08
	sta	AUDC1

;set scores to 0
	lda #$00
	sta	score0
	lda	#$00
	sta	score1

;clear playfield	
normal_repeat				;repeat point
;set delay intially on missiles so firing to 
;start a game doesn't cause a fire in the game
	lda	#MISSILE_DELAY
	sta	missdelay0
	sta	missdelay1

	lda	score0
	cmp	#WIN_NUMBER
	beq win0
	lda	score1
	cmp	#WIN_NUMBER
	beq win1
	jmp no_winner
	
	include "win_screen.s"	
	
no_winner		
	lda	#0
	sta	speedup

;select_repeat				;repeat point for select mode
;	jsr	clear_playfield		;in the fielddraw.s file

;load up playfield
	lda	#$07
	and gamenum
	
	jsr load_playfield
	
;	clc		;multiply by 4
;	rol
;	rol
;	tax
;	lda	Playfields,x
;	sta	temp0
;	lda	Playfields+1,x
;	sta	temp1
;	lda	Playfields+2,x
;	sta	temp2
;	lda Playfields+3,x
;	sta	temp3

	
;	ldy	#22
;load_ply
;	lda	(temp0),y
;	sta	leftpf1,y
;	sta	rightpf1,y
;	lda	(temp2),y
;	sta leftpf2,y
;	sta rightpf2,y
;	dey
;	bpl	load_ply

not_ply1 
;set player numbers to 0
	lda	#0
	sta	NUSIZ0
	sta	NUSIZ1

;put the snake starting in the middle
;setup position
	;check for no_missile game, if so pull them out from the edge
	lda gamenum		
	and	#$40
	bne pull_out_from_edge

	lda	#0		;starting x is 0
	sta	xpos0
	sta	xmiss0
	lda	#31
	sta xpos1
	sta	xmiss1
	bne position_y
	
pull_out_from_edge
	lda	#3		;starting x is 4
	sta	xpos0
	sta	xmiss0
	lda	#28
	sta xpos1
	sta	xmiss1

position_y	
	ldx	#11		;starting y is 11
	stx ypos0
	stx	ymiss0
	stx ypos1
	stx	ymiss1

;setup initial direction
	lda	#RIGHT_DIR
	sta	dir0

	ldx	#LEFT_DIR
	stx dir1
		
;	lda	#LEFT_DIR
;	sta	dir1

	lda	#0
	sta	missdir0
	sta	missdir1

;setup speed
	lda	#MISS_SPEED
	sta	missspeed
	sta	misscount

;snakespeed (gamecount) is three times missspeed to begin with
	clc
	lda misscount
	adc misscount
	adc misscount
	sta gamecount
;check for a/b and set accordingly	
	bit SWCHB
	bvs	pro_game1
	rol gamecount	;multiply gamespeed by 2 for amateur
pro_game1
;setup the missiles
	lda	#$02
	sta	RESMP0		;lock the missiles to the players (and disable)
	sta	RESMP1
;
;Draw the frame
;set the playfield to snake colored
	lda	#SNAKECOLOR
	sta	COLUPF

frame
	;Vertical sync
	jsr start_vertical_sync
	
;position the heads
	lda	xpos0
	sta	temp0

	lda	xpos1
	sta	temp1
	
	ldx	#31
position_heads_loop
	dec temp0
	bpl move_head0
	jmp check_head1
move_head0
	lda	#$c0
	sta	HMP0
check_head1
	dec	temp1
	bpl move_head1
	jmp no_move_head1
move_head1
	lda	#$c0
	sta	HMP1
no_move_head1
	sta WSYNC
	sta	HMOVE
pause_it
	ldy	#1
	dey
	bne	pause_it
	sta HMCLR
	dex
	bne	position_heads_loop
	
;set the Player / missile color
	lda	#P0COLOR
	sta	COLUP0
	lda	#P1COLOR
	sta	COLUP1

;wait for the vertical blank to end
	jsr wait_timer
	sta	WSYNC
	sta	VBLANK   ;A comes back as zero, end vblank
	
;put a color border around the play field	
	sta WSYNC
	sta WSYNC
	lda	#SNAKECOLOR
	sta	COLUBK
;use pf0 to make the left and right outline
	lda	#$FF
	sta	PF0		;make an outline

	lda	#8			;518 clocks, 8 tim64s, 7 lines
	sta	TIM64T

;check for game over, dir = 0
	lda	dir0
	bne miss_no_game_over_0
	jmp	game_over_skip_missiles
miss_no_game_over_0
	lda dir1
	bne miss_no_game_over_1
	jmp game_over_skip_missiles
miss_no_game_over_1

;check for missiles on/off
	lda gamenum
	and #$40
	beq missiles_enabled
	jmp skip_missiles
missiles_enabled
	include "check_button0.s"

;see if this is a one-player game
	lda gamenum
	and	#$08
	beq button_not_one_player
	lda	temp3
	cmp #$FF		;temp3 will be changed by the score routine, no need to clear
	bne check_for_one_player_fire
	jsr check_button1	;fire a missile
	jmp skip_check_button1
check_for_one_player_fire
	lda	#CHECK_FOR_FIRE		;save how far ahead to look in temp4
	sta	temp4			
	jsr one_player_missile
	
	jmp skip_check_button1
button_not_one_player	
	jsr check_button1
skip_check_button1

skip_missiles
game_over_skip_missiles

;set up the missiles

	clc				;clear carry so the rol works like *2
	lda	ymiss0
	sta	miss0index	
	rol
	adc	miss0index
	sta	miss0index	;net result is miss0index=ymiss0 * 3

	lda	ymiss1
	sta	miss1index
	rol
	adc	miss1index
	sta	miss1index

	jsr wait_timer

;set the background	
	sta	WSYNC		
	lda	#BACKGROUND
	sta	COLUBK		

	lda	#0			;a needs to start zero (is cleared again at end of outer loop)
	;set up the counts so the subroutine knows how many lines to draw
	lda #PFHEIGHT-1
	sta	outercnt

;;;;;;;Draw the field	
	jsr fielddraw
;;;;;;;;

	; a is 0 coming out of the subroutine
	sta	ENAM0
	sta	ENAM1

;wait one more line, then change the background to make the border
	sta	WSYNC
	lda	#SNAKECOLOR
	sta	COLUBK

;put a color border around the play field	
	lda	#8			;8 tim64s, 7 lines
	sta	TIM64T

	;setup the temp0-temp3 for the score indices
	include "setup_score.s"
	;see if this is select mode or normal mode

set_score_color
	lda	#P0SCORECOLOR
	sta	temp6				;temp6 and 7 control the colors used in the draw_score part
	lda	#P1SCORECOLOR
	sta	temp7

done_score_color
	jsr wait_timer

	sta	WSYNC	
	lda #0
	sta	COLUBK		;set back to black
	sta	PF0			;clear outline

;draw the digits of the score
	
	include "draw_score.s"

;put the player graphics on the edges of the playfield in prep for the 
;positioning during the vertical blank
	sta	WSYNC
	sta	RESP0	;doing this during the horizontal blank puts them on the far left
	sta	RESP1

	lda	#$A0	;move them 6 to the right
	sta HMP0
	sta HMP1
	sta	WSYNC
	sta	HMOVE
	sta	WSYNC
	lda	#$B0
	sta HMP0
	sta HMP1
	sta	WSYNC
	sta	HMOVE	;move them 5 to the right
	sta	WSYNC
	lda	#0
	sta HMP0
	sta	HMP1

;Overscan
	jsr start_Overscan	

;check for reset
	lda SWCHB
	and	#1
	bne	no_reset
reset
	jmp	main_game
no_reset

;check for select
	lda SWCHB
	and #$02
	bne no_select
	
	jmp select_screen

no_select

;check for game over, dir = 0
	lda	dir0
	bne no_game_over_0
	jmp	game_over
no_game_over_0
	lda dir1
	bne no_game_over_1
	jmp game_over
no_game_over_1

;check joysticks
	include "check_joystick0.s"
;see if this is a one-player game 
	lda	gamenum
	and	#$08
	beq jstick_not_one_player
	
	lda	gamecount
	cmp	#1
	bne skip_one_player_mode_move	
	lda	misscount			;only do this once per move
	cmp	#1
	bne skip_one_player_mode_move

	lda	#$0F
	sta	la_temp
	jsr one_player_mode
	
	lda	#$0E
 	sta	la_temp
	jsr one_player_mode

	
	lda	#2
	sta	la_temp
	jsr one_player_mode
	lda	#$0
	sta	la_temp
	jsr one_player_mode
	lda	#$0
	sta	la_temp
	jsr one_player_mode
	lda	#$0
	sta	la_temp
	jsr one_player_mode


skip_one_player_mode_move
	jmp skip_joystick1	
jstick_not_one_player
	include "check_joystick1.s"

skip_joystick1

;turn off the sound if needed
	lda sounddelay
	beq	no_sound_on
	dec sounddelay
	bne no_turn_off
	lda	#$00
	sta	AUDV1
	
no_turn_off
no_sound_on

	lda	gamenum		;check for hostile enviroment
	and #$10
	beq no_hostile_enviroment
	
hostile_enviroment	
	dec blockcount
	bne check_misscount
	lda	#BLOCK_SPEED 	;reset block count
	sta	blockcount
	
	lda rand0			;get randomx
	and	#$1F			;clip it at 31
	tax
	lda	rand1
	and	#$1f			;clip it at 31
	cmp	#21
	bmi	y_is_good	
	clc					;if y is greater than 21, divide it by two
	ror
y_is_good
	tay
	jsr place_piece

no_hostile_enviroment	
check_misscount
	dec	misscount
	beq	go_update_missiles

;	jmp frame_done
	jmp	go_check_for_graphics_update

go_update_missiles

	inc	speedup			;increment the speedup
	bne	no_miss_speedup
	dec	missspeed
	bne missspeed_not_zero
	inc missspeed
missspeed_not_zero
no_miss_speedup
;	lda	speedup
;	and	#$
;	beq	no_block_speedup
;	dec	blockspeed
;no_block_speedup		


	clv			;clear overflow, so we can use bvc as a branch 
				;instruction in the subroutinese (shouldn't overflow in the subs)
				;I think I removed the dependence on this...

	include "missiles.s"

	;stop the moving noise
	lda	#$00	   		
	sta	AUDV0

go_check_for_graphics_update
;	ldx missspeed
;	cpx	#1
;	beq go_dec_gamecount
;	dex
;	cpx	misscount
;	beq go_dec_gamecount
;	jmp frame_done
go_dec_gamecount		
	dec	gamecount
;	beq reset_gamecount
;	lda	gamecount
;	cmp	#$01
	beq	update_graphics	
	jmp	frame_done

update_graphics
reset_gamecount
;snakespeed (gamecount) is three times missspeed to begin with
	clc
	lda misscount
	adc misscount
	adc misscount
	sta gamecount
;check for a/b and set accordingly	
	bit SWCHB
	bvs	pro_game2
	rol gamecount	;multiply gamespeed by 2 for amateur
pro_game2
;	jmp frame_done



	;place the block where the head is now
	ldx	xpos0
	ldy	ypos0
	jsr place_piece

	ldx	xpos1
	ldy	ypos1
	jsr place_piece

	lda	#$20		;check for wrap-mode game
	and gamenum		
	beq not_wrap_mode
	jmp wrap_mode	
	
not_wrap_mode
	;move player 0
	mac_move_player CXP0FB,dir0,xpos0,ypos0,score1
	;move player 1
	mac_move_player CXP1FB,dir1,xpos1,ypos1,score0		

		;make the moving noise
	lda	#$0F	   		
	sta	AUDV0

	jmp frame_done

wrap_mode	
	;move player 0
	mac_wrap_move_player CXP0FB,dir0,xpos0,ypos0,score1
	;move player 1
	mac_wrap_move_player CXP1FB,dir1,xpos1,ypos1,score0	
		
	;make the moving noise
	lda	#$0F	   		
	sta	AUDV0
;	lda	#$00
;	sta	AUDV1

	sta	CXCLR			;clear collision latches
	jmp frame_done	
	
game_over
	lda	#$00	   		
	sta	AUDV0
	sta	AUDV1

	dec pause
	bne frame_done

	jsr wait_timer		;wait for overscan to end
	jmp normal_repeat

frame_done

;move the missiles
	sta	WSYNC
	sta HMOVE
	sta	WSYNC
	sta	HMCLR

	sta	CXCLR			;clear collision latches

	jsr random			;next random number

;wait for overscan to end	
wait_FF
	lda INTIM		;timer ended?
	bne	wait_FF



	jmp frame

;this packs graphics.c and drawit.s all the way down to the bottom, where all should work	
	org	$fcf1		
	include "graphics.s"
	include "drawit.s"
;make sure nothing gets put here so unmodified superchargers 
;can play the game
	org	$fff8
	ds	4
;Boot up points....

	org	$fffc
	dc.w	start                    ; Reset vector
    dc.w	start                    ; IRQ vector
