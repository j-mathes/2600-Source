;drawit routine taken from Bob Colbert's Okie Dokie (modified some)
;this whole routine must reside with the high byte of the address the same
;or it won't work

;*******************************************************
;initialize position of p0,p1 for the draw routines
drawit_init		subroutine
    lda  #$03                  ; set both players to 3 copies
    sta  NUSIZ0
    sta  NUSIZ1
    ldx  #$6                   ; move players 12 columns over
    ldy  #$0
    sta  WSYNC                 ; wait for scanline
.loop1
    dex                        ; wait for column (15 bit wide) x
    bpl  .loop1
    nop                        ; additional delay
    sta  RESP0                 ; reset player 0
    sta  RESP1                 ; reset player 1
    lda  #$d0                  ; set player 0 to move left 1 pixel
    sta  HMP0
    lda  #$e0
    sta  HMP1
    sta  WSYNC
    sta  HMOVE                 ; move player 0
	rts	

;****************************************************************
;draw the graphics whose addresses are stored in GRTABLE
drawit		subroutine
    lda  #$01
    sta  VDELP0
    sta  VDELP1
.loop2
    ldy  GRHEIGHT
    lda  (GRTABLE),y           ; get player0 copy1 data
    sta  GRP0
    sta  WSYNC
    lda  (GRTABLE+$2),y        ; get player1 copy1 data
    sta  GRP1
    lda  (GRTABLE+$4),y        ; get player0 copy2 data
    sta  GRP0
    lda  (GRTABLE+$6),y        ; get player1 copy2 data
    sta  TEMPVAR
    lda  (GRTABLE+$8),y        ; get player0 copy3 data
    tax
    lda  (GRTABLE+$A),y        ; get player1 copy3 data
    tay
    lda  TEMPVAR
    sta  GRP1
    stx  GRP0
    sty  GRP1
    sta  GRP0
    dec  GRHEIGHT
    bpl  .loop2                 ; loop until done
    lda  #$0
    sta  VDELP0
    sta  VDELP1
    sta  GRP1
    sta  GRP0
    sta  GRP1

    rts

;****************************************************************
;load and display graphics
;pass in A with (height-1)
;pass in temp0 and temp1 with address of the table to load
load_and_draw	subroutine
    sta	GRHEIGHT
    ldy #12	
.loop1
    lda	(temp0),y
    sta	GRTABLE,y
    dey
    bpl	.loop1

    jsr	drawit               ; go draw it
	rts
