; colors.asm

; color tweaker - use to test various color combos

; by Brian Watson <atari@xxxxxxxxxxxxxx>

; Tested on z26 v1.46 on a windows machine
; Tested on xstella 1.1 on a linux machine
; *Not* tested on a real Atari (yet)

; v1.0rc1

; The only reason this is `release candidate 1' rather than v1.0 is
; that it hasn't been tested on a real 2600.

 processor 6502
 include "vcs.h"

 seg.u vars
 org $80
framectr ds 1 ; increments once per frame, used for coloring title screen
titleflag ds 1 ; 0 if we're showing the title, 1 otherwise

; color registers. These keep track of current color displayed, for each
; section of screen. due to the way check_stick works, bg0-4 must be located
; immediately after color0-4 (don't put any variables in between)
color0 ds 1
color1 ds 1
color2 ds 1
color3 ds 1
num_colors = [*-color0]-1
bg0 ds 1
bg1 ds 1
bg2 ds 1
bg3 ds 1
current_color ds 1 ; which of the 4 color regs the player is modifying
color_or_bg ds 1 ; (0=color, 1=bg) whether the color reg being modified is color or bg (color+4)
hexpointer ds 4 ; vectors for digit font data
ctemp ds 1 ; temp used in font calculations (could be used by other routines)
p0shape ds 6 ; final result of font calculations, 2 hex digits in one player
p1shape ds 6 ; same, for the other 2 digits
ptrcolor ds 1 ; the pointer color gets incremented once every 4 frames

 echo *-$80,"bytes of zero page RAM used"
 
 if *>$ff
 echo "***ERROR: You're all out of zero page RAM!"
	; error: we're all out of powdered toast
 endif

 seg code
 org $F000

 sei
 cld
 ldx #$ff
 txs
 lda #0
iloop
 sta 0,x
 bne iloop

; now, set everything up to display the title screen
; (this routine also gets called whenever player hits `game reset')
game_reset
 lda #0
 sta titleflag ; 0 means `show the title', we check this in main_loop to decide which kernel to run
 sta color_or_bg
 ldy #num_colors*2+1 ; more fencepost error...
init_colors ; set default colors from ROM
 lda default_colors,y
 sta color0,y
 dey
 bpl init_colors

 lda #>hexfont
 sta hexpointer+1 ; set up hi bytes of pointers
 sta hexpointer+3

 lda #num_colors ; player starts in upper left, color 0 is at bottom of screen, so..
 sta current_color

 lda #5
 sta NUSIZ0 ; doublewide p0
 ; (we will modify NUSIZ1 inside main_kernel, since the pointer is single
 ; width, but the 2nd set of digits is double width, and they're both player 1)

 lda #12 ; p0 is always white
 sta COLUP0
 ; (we modify COLUP1 inside main_kernel, see above)

main_loop ; start of TV frame
 lda #2
 sta VSYNC ; start blanking
 sta WSYNC
 sta WSYNC
 lda #44
 sta TIM64T ; go ahead & set timer
 lda #0
 sta WSYNC
 sta VSYNC ; 3 WSYNC's, then turn off VSYNC

game_calc
 inc framectr
 sta COLUBK ; initially, blank the background (a still 0 from above)
 lda ptrcolor
 sta COLUP1

check_switches
 lda SWCHB ; did player hit game reset?
 and #1
 bne check_stick ; no, so check the joystick
 jmp game_reset ; yes, so reset the game
 
check_stick
 ; we really only want to check the stick every so many frames...
 lda framectr
 and #$03
 bne skip_stick ; skip over input routine unless current frame is multiple of 4
 ldx current_color
 lda color_or_bg ; decide which color reg to modify: color0 + color_or_bg*4
 beq skipbg
 inx
 inx
 inx
 inx

; at this point, X holds the register we need to modify. Let's see what we should
; do with it. No, this isn't the most efficient joystick-checking code ever :)
skipbg
 lda SWCHA
 asl ; did player move right?
 bcs skr ; if not, skip the increments
 inc color0,x ; if so increment twice (since the low bit of the COLU* regs is ignored anyway)
 inc color0,x
skr
 asl
 bcs skl
 dec color0,x
 dec color0,x
skl
 asl
 bcs skd
 tay
 lda color0,x
 sbc #15 ; carry is always clear, this actually subtracts 16
 sta color0,x
 tya
skd
 asl
 bcs sku
 lda color0,x
 adc #16
 sta color0,x
sku
 
check_fire
 lda framectr
 and #$07 ; only check fire button every 8 frames (FIXME: need debounce?)
 bne skip_stick
 inc ptrcolor ; while we're at it, change pointer color, whether fire pressed or not.
 lda INPT4
 and #$80 ; did player press fire button?
 bne skip_stick ; if not, skip the rest of this routine, otherwise...
 lda #2 ; unlatch the triggers
 sta VBLANK
 lda titleflag
 bne not_in_title
 inc titleflag ; the first time the player hits fire, just set titleflag to 1...
 bne skip_stick ; ...but don't move the pointer (since it isn't visible yet anyway)
not_in_title
 lda color_or_bg
 eor #$FF
 sta color_or_bg ; toggle color_or_bg
 bne skip_stick ; and if we did set it to zero, that's all we do (effect is move pointer to the right)
 ldx current_color ; otherwise we need to move the pointer down
 dex
 bpl skip_zero
 ldx #num_colors
skip_zero
 stx current_color

skip_stick

;; position player 1 (the pointer)
 sta WSYNC
 lda color_or_bg
 beq reset_p1 ; if color_or_bg == 0, pointer is on the left, so skip positioning
; I was hoping to get by without using HMOVE, but it looks like crap without it.
 lda #$E0
 sta HMP1
 sta WSYNC
 repeat 16
 nop
 repend
reset_p1
 sta RESP1
 sta WSYNC
 sta HMOVE
 repeat 13 ; TIA docs say wait at least 24 cycles after HMOVE before modifying HMP* (or HMCLR)
 nop       ; so we actually wait 26.
 repend
 sta HMCLR

; done with vblank calculations. Wait for the TV to get to first scan line.
wait_timer
 lda INTIM
 bne wait_timer ; busy-wait for timer to expire
 lda #64 ; latch the triggers
 sta WSYNC
 sta VBLANK ; let there be graphics!

; decide which kernel to run, based on game mode
; unfortunately this wastes a good chunk of the first scanline...
; ...but we're not displaying anything there anyway.
 lda titleflag
 beq title_kernel
 jmp main_kernel ; Main Kernel Turn On!

title_kernel
 ldy #191-title_bytes ; single (high) resolution, 192 scanlines

t_blank_top
 sta WSYNC
 dey
 bpl t_blank_top

 ldy #title_bytes

; Asymmetrical playfield code. This is the bit I *really* want to
; test on a real Atari (it works ok on z26 and xstella)
draw_t_pf
 sta WSYNC
 sta COLUPF ; 3
 lda left_title0,y ; 4
 sta PF0 ; 3
 lda left_title1,y ; 4
 sta PF1 ; 3
 lda left_title2,y ; 4
 sta PF2 ; 3 (so far, 24 cycles. the first 22.6 are during horiz. blank)
 lda right_title1,y ; 4
 ldx right_title2,y ; 4
 nop ; 2
 nop ; 2
 nop ; 2
 sta PF1 ; 3
 lda right_title0,y ; 4
 sta PF0 ; 3 (why does this work? we're at 48 cycles past WSYNC, 26 past first visible color clock)
 stx PF2 ; 3 (29 past 1st visible, and done modifying PF* regs)
 tya
 adc framectr ; load A with next scanline's color
 dey
 bne draw_t_pf

end_kernels ; common code (jmp'ed to by main_kernel)
 sta WSYNC ; finish last scanline

 lda #37 ; set overscan timer
 sta TIM64T

 lda #66 ; latch triggers and disable TIA graphics
 sta VBLANK

 ldy #0
 sty COLUPF ; blank playfiels
 sty PF0
 sty PF1
 sty PF2

; calculate offset to data for hi digit
 ldx current_color
 lda color0,x
 ; in C, a = (a >> 4) * 5;
 and #$F0 ; hi nybble first
 lsr
 lsr ; now we have: 0, 4, 8...,60
 sta ctemp ; in ctemp
 lsr ; finish shifting
 lsr ; now we have 0, 1, 2...,15 in A
 clc
 adc ctemp ; now we have 0, 5, 10...,75 in A
 sta hexpointer ; stash it
 lda color0,x ; now the low digit...
 ; in C, a = (a & 0x0F) * 5;
 and #$0F
 sta ctemp
 asl
 asl ; a = (a * 4) ...
 clc
 adc ctemp ; plus a, gives us a*5
 sta hexpointer+2 ; *whew*

; now we've got hexpointer as a pointer to the 5 bytes worth of
; font data we are wanting to draw for this digit...
 ldy #4
make_shape ; draw into RAM to simplify kernel (needs 5 bytes)
 lda (hexpointer),y
 ; we're doing the high digit, so we need to shift the data up 4 bits
 asl
 asl
 asl
 asl
 sta ctemp
 lda (hexpointer+2),y ; now get the low digit, which doesn't need to be shifted
 ora ctemp
 sta p0shape,y
 dey
 bpl make_shape ; get the next byte, until we're done.

; #define LAME_CUT_AND_PASTE
 ldx current_color
 lda bg0,x
 and #$F0 ; hi nybble first
 lsr
 lsr ; now we have: 0, 4, 8...,60
 sta ctemp ; in ctemp
 lsr ; finish shifting
 lsr ; now we have 0, 1, 2...,15 in A
 clc
 adc ctemp ; now we have 0, 5, 10...,75 in A
 sta hexpointer ; stash it
 lda bg0,x ; now the low digit...
 and #$0F
 sta ctemp
 asl
 asl ; a = (a * 4) ...
 clc
 adc ctemp ; plus a, gives us a*5
 ;ora hexpointer ; grab top 4 bits from hi nybble calc
 sta hexpointer+2 ; *whew*

 ldy #4
make_shape2 ; draw into RAM to simplify kernel (needs 5 bytes)
 lda (hexpointer),y
 asl
 asl
 asl
 asl
 sta ctemp
 lda (hexpointer+2),y
 ora ctemp
 sta p1shape,y
 dey
 bpl make_shape2

;ARGH what a waste. But it works.
; #undef LAME_CUT_AND_PASTE

; we're done with overscan calculations, so wait for the timer to run
; out and tell us it's time to start a new frame.
t_overscan
 lda INTIM
 bne t_overscan

 jmp main_loop ; time's up, start new frame now.

 org [>.+1]*256
main_kernel
 ldy #96-[main_bytes*4]-1 ; single (high) resolution, 192 scanlines
 ldx #num_colors
 txs ; use stack ptr as temp register, since we never use the stack! 

m_blank_top
 sta WSYNC
 dey
 bne m_blank_top

draw_one_section
 sta WSYNC ; maybe not need this here
 tya ; lda #0
 lda color0,x
 sta COLUPF
 lda bg0,x
 sta COLUBK
 cpx current_color
 bne no_player1
 lda ptrcolor
no_player1
 sta COLUP1
 ldy #main_bytes
draw_m_pf
 lda ptrshape,y
 sta GRP1
 sta WSYNC
 lda left_main0,y ; 3
 sta PF0 ; 5
 lda left_main1,y ; 8
 sta PF1 ; 10
 lda left_main2,y ; 13
 sta PF2 ; 15
 sta WSYNC 
 dey
 bne draw_m_pf
 sty GRP1

 tsx
 dex
 txs
 bpl draw_one_section


 repeat 8
 nop
 repend
 sta RESP1

 lda #0 ; waste one scan line turning bottom background black
 ldy #12 ; ...and player 1 white...
 ldx #5 ; ...and player 1 double-wide
 sty COLUP1
 sta WSYNC
 stx NUSIZ1
 sta PF0
 sta PF1
 sta PF2
 sta COLUBK
 ldy #4 ; draw player for 5 scanlines
draw_digits
 sta WSYNC
 sta RESP0
 lda p0shape,y ; we calculated this last overscan period
 sta GRP0
 lda p1shape,y
 sta GRP1
 sta WSYNC ; display it twice
 sta WSYNC ; display it thrice
 dey 
 bpl draw_digits 

 sta WSYNC
 lda #0
 sta GRP0 ; done drawing player
 sta GRP1 ; done drawing player
 sta NUSIZ1

; currently 10 scanlines left
; ldy #4
;t_blank_bottom
; sta WSYNC
; dey
; bne t_blank_bottom 

 jmp end_kernels ; our work is done here...

 org $F800


; 4x5 hex font, upside-down, low nybble only
hexfont
hex0
 byte %00000010
 byte %00000101
 byte %00000101
 byte %00000101
 byte %00000010
hex1
 byte %00000111
 byte %00000010
 byte %00000010
 byte %00000110
 byte %00000010
hex2
 byte %00000111
 byte %00000100
 byte %00000010
 byte %00000001
 byte %00000110
hex3
 byte %00000110
 byte %00000001
 byte %00000110
 byte %00000001
 byte %00000110
hex4
 byte %00000001
 byte %00000001
 byte %00000111
 byte %00000101
 byte %00000001
hex5
 byte %00000110
 byte %00000001
 byte %00000111
 byte %00000100
 byte %00000111
hex6
 byte %00000111
 byte %00000101
 byte %00000111
 byte %00000100
 byte %00000011
hex7
 byte %00000010
 byte %00000010
 byte %00000001
 byte %00000001
 byte %00000111
hex8
 byte %00000111
 byte %00000101
 byte %00000010
 byte %00000101
 byte %00000111
hex9
 byte %00000110
 byte %00000001
 byte %00000111
 byte %00000101
 byte %00000111
hexA
 byte %00000101
 byte %00000101
 byte %00000111
 byte %00000101
 byte %00000010
hexB
 byte %00000111
 byte %00000101
 byte %00000110
 byte %00000101
 byte %00000110
hexC
 byte %00000011
 byte %00000100
 byte %00000100
 byte %00000100
 byte %00000011
hexD
 byte %00000110
 byte %00000101
 byte %00000101
 byte %00000101
 byte %00000110
hexE
 byte %00000111
 byte %00000100
 byte %00000111
 byte %00000100
 byte %00000111
hexF
 byte %00000100
 byte %00000100
 byte %00000111
 byte %00000100
hexfont_end
 byte %00000111
hexfont_size = hexfont_end - hexfont
 echo "hexfont_size is",hexfont_size

default_colors byte $0a,$2a,$3a,$4a,$00,$10,$20,$30

ptrshape ; main_bytes bytes, which is 24 now I think
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %10000000
 byte %11000000
 byte %11100000
 byte %11000000
 byte %10000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000


 org $F900

; these tables were in include files generated by a script,
; but I put them in here so the source would be self-contained


left_title0
 byte %00000000
 byte %00000000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01110000
 byte %01110000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %01110000
 byte %01110000
 byte %01110000
 byte %01110000
 byte %01110000
 byte %01110000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %00010000
 byte %01100000
 byte %01100000
 byte %01100000
 byte %01100000
 byte %01100000
 byte %01100000
 byte %00000000
 byte %00000000
title_bytes = [.-left_title0]-1

 org [>.]*256+256

left_title1
 byte %00000000
 byte %00000000
 byte %10101010
 byte %10101010
 byte %10101010
 byte %10101010
 byte %10101010
 byte %10101010
 byte %10101010
 byte %10101010
 byte %11101100
 byte %11101100
 byte %10101010
 byte %10101010
 byte %10101010
 byte %10101010
 byte %01001100
 byte %01001100
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00001111
 byte %00001111
 byte %00010000
 byte %00010000
 byte %00010110
 byte %00010110
 byte %00010100
 byte %00010100
 byte %00010100
 byte %00010100
 byte %00010110
 byte %00010110
 byte %00010000
 byte %00010000
 byte %00001111
 byte %00001111
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %01001110
 byte %01001110
 byte %01001110
 byte %01001110
 byte %01001110
 byte %01001110
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %01001000
 byte %01001000
 byte %01001000
 byte %01001000
 byte %01001000
 byte %01001000
 byte %00000000
 byte %00000000
 org [>.]*256+256

left_title2
 byte %00000000
 byte %00000000
 byte %01100011
 byte %01100011
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %01100011
 byte %01100011
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %10011100
 byte %10011100
 byte %01000101
 byte %01000101
 byte %01000101
 byte %01000101
 byte %01000101
 byte %01000101
 byte %01001001
 byte %01001001
 byte %01010001
 byte %01010001
 byte %01010001
 byte %01010001
 byte %10001100
 byte %10001100
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %01010010
 byte %01010010
 byte %01010010
 byte %01010010
 byte %01010010
 byte %01010010
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %00110101
 byte %00110101
 byte %00110101
 byte %00110101
 byte %00110101
 byte %00110101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %00110010
 byte %00110010
 byte %00110010
 byte %00110010
 byte %00110010
 byte %00110010
 byte %00000000
 byte %00000000
 org [>.]*256+256

right_title0
 byte %00000000
 byte %00000000
 byte %00100000
 byte %00100000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %00100000
 byte %00100000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %10000000
 byte %10000000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %01010000
 byte %10000000
 byte %10000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %00100000
 byte %01110000
 byte %01110000
 byte %01110000
 byte %01110000
 byte %01110000
 byte %01110000
 byte %00000000
 byte %00000000
 org [>.]*256+256

right_title1
 byte %00000000
 byte %00000000
 byte %11001110
 byte %11001110
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101100
 byte %10101100
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %11001110
 byte %11001110
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00111000
 byte %00111000
 byte %10010000
 byte %10010000
 byte %10010000
 byte %10010000
 byte %10010000
 byte %10010000
 byte %10010000
 byte %10010000
 byte %10010000
 byte %10010000
 byte %10110000
 byte %10110000
 byte %00010000
 byte %00010000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %10101110
 byte %10101110
 byte %10101110
 byte %10101110
 byte %10101110
 byte %10101110
 byte %11101000
 byte %11101000
 byte %11101000
 byte %11101000
 byte %11101000
 byte %11101000
 byte %11101100
 byte %11101100
 byte %11101100
 byte %11101100
 byte %11101100
 byte %11101100
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101000
 byte %10101110
 byte %10101110
 byte %10101110
 byte %10101110
 byte %10101110
 byte %10101110
 byte %00000000
 byte %00000000
 org [>.]*256+256

right_title2
 byte %00000000
 byte %00000000
 byte %00110101
 byte %00110101
 byte %01000101
 byte %01000101
 byte %01000101
 byte %01000101
 byte %01000101
 byte %01000101
 byte %00100011
 byte %00100011
 byte %00010101
 byte %00010101
 byte %00010101
 byte %00010101
 byte %01100011
 byte %01100011
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %00110111
 byte %00110111
 byte %00110111
 byte %00110111
 byte %00110111
 byte %00110111
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010101
 byte %01010010
 byte %01010010
 byte %01010010
 byte %01010010
 byte %01010010
 byte %01010010
 byte %00000000
 byte %00000000
 org [>.]*256+256


left_main0
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
 byte %11000000
main_bytes = [.-left_main0]-1


left_main1
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100
 byte %11111100

left_main2
 byte %00000000
 byte %00000000
 byte %00000000
 byte %00000000
 byte %11111111
 byte %11111111
 byte %11111111
 byte %11111111
 byte %10000001
 byte %10000001
 byte %10000001
 byte %10000001
 byte %10000001
 byte %10000001
 byte %10000001
 byte %10000001
 byte %11111111
 byte %11111111
 byte %11111111
 byte %11111111

; echo *-$F900,"bytes of included data"

 org $FFFC
 word $F000
 word $F000