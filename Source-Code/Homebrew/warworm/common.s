;start the vertical sync and set the timer for 37 lines of blank
start_vertical_sync		subroutine

	LDA #2
	STA WSYNC  
	STA WSYNC
	STA WSYNC
	STA VSYNC ; Begin vertical sync.
	STA WSYNC ; First line of VSYNC
	STA WSYNC ; Second line of VSYNC.

	LDA #44		;timer for 27 lines of blanking
	STA TIM64T
	LDA	#0
	STA WSYNC ; Third line of VSYNC.
	STA VSYNC ; (0)

	rts
;**************************************************************
;wait for the timer to end
wait_timer			subroutine
.wait
	lda INTIM		;timer ended?
	bne	.wait

	rts
;**************************************************************
;start the overscan
start_Overscan			;end scanline 191, begin overscan
	lda	#2	   		;First line turns on VBLANK 
	sta	WSYNC

	sta	HMCLR		;clear all the move registers

	sta	VBLANK

	lda	#36		;Timer for 30 scanlines
	sta	TIM64T

	rts
;**************************************************************
;wait number of line in Y
wait_lines	subroutine
.loop
	dey
	sta WSYNC
	bne .loop
	rts
;**************************************************************
;random:       lda rand3    ;we need to XOR bits 27 and 30 (counting from 0)
;              rol a        ;30 in bit #6 (of rand3)
;               rol a        ;27 in bit #4 (of rand3)
;               eor rand3    ;XOR the two together
;               rol a
;               rol a        ;pop the XOR'd bit out into carry
;               rol rand0
;               rol rand1
;               rol rand2    ;rotate 32 bits' worth
;               rol rand3    ;note carry = random bit
;               rts

random	subroutine
	lda rand1	;we need to XOR bits 11 and 15 (counting from 0)
    rol         ;15 in bit #6 (of rand3)
    rol         ;11 in bit #4 (of rand3)
    eor rand1   ;XOR the two together
    rol 
    rol         ;pop the XOR'd bit out into carry
    rol rand0   ;rotate 16 bits' worth
    rol rand1   ;note carry = random bit
    rts

