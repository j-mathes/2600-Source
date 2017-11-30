;;RAM Combat By Rick Skrbina 5/6/09
;;Final version 6/16/09

	processor 6502
	
	include "vcs.h"
	include "macro.h"
	
	
	seg code
	org $F800
Start
	CLEAN_START
	
	lda #$EA	;background color from the original Combat (Regular Tanks)
	sta COLUBK
	lda #$44	;P0 color from Combat	
	sta COLUP0
	lda #$82	;P1 color from Combat
	sta COLUP1
	lda #$3C	;PF color from Combat
	sta COLUPF
	
	lda #15
	sta AUDC0
	lda #12
	sta AUDF0
	
	lda #%00010000
	sta PF0
	lda #1
	sta CTRLPF
	
	lda #24
	ldx #0
	jsr PositionSprites
	sta WSYNC
	ldx #2
	jsr PositionSprites
	sta WSYNC
	lda #128
	ldx #1
	jsr PositionSprites
	sta WSYNC
	ldx #3
	jsr PositionSprites
	sta WSYNC
	
	sta HMCLR
	
	lda #0
	sta VBLANK
	

	
	ldx #0
Load_Game
	lda Start_Frame,X
	sta $80,X
	inx
	cpx #129
	bne Load_Game
	
	ldx #$FF
	
	lda #$83	;initial Y position for both 'Tanks'
	sta P0_Y
	sta P1_Y
	clc
	adc #12
	sta P0_End
	sta P1_End
	
	lda #%11100000
	sta HMM0
	lda #%00100000
	sta HMM1

	lda #%00000010
	sta RESMP0
	sta RESMP1

	ldx #1
	txs
	
	ldy #0
	jmp $0080


PositionSprites
        sta HMCLR
        sec
        sta WSYNC         
PositionSpriteLoop
        sbc    #15
        bcs    PositionSpriteLoop 

        eor    #7         
        asl
        asl
        asl
        asl               

        sta.wx HMP0,X     
        sta    RESP0,X   
        sta    WSYNC      
        sta    HMOVE     
        rts  
	
	
;;;Game loop



	org $F980
	
Start_Frame
	    
VerticalSync           
	sta WSYNC           
        sta VSYNC
        lsr
        bne VerticalSync         

	sta HMOVE	
Picture
	sta WSYNC
	sta ENAM0
	sta ENAM1
	
P0_Y = . - $F900 + 1
	
	cpy #P0_Y
	bne Dont_Draw_P0
	
	stx GRP0
	stx ENAM0

Dont_Draw_P0


P0_End = . - $F900 + 1
	cpy #P0_End
	bne Dont_Clear_P0
	sta GRP0
Dont_Clear_P0	

P1_Y = . - $F900 + 1
	
	cpy #P1_Y
	bne Dont_Draw_P1
	
	stx GRP1
	stx ENAM1

Dont_Draw_P1


P1_End = . - $F900 + 1
	cpy #P1_End
	bne Dont_Clear_P1
	sta GRP1
Dont_Clear_P1	
	
	iny
	bne Picture	
	
	lda SWCHA
	lsr
	bcc Check_Right_Down
	
	inc P1_Y
	inc P1_End
	
Check_Right_Down

	lsr
	bcc Check_Left_Controller

	dec P1_Y
	dec P1_End
	
Check_Left_Controller

	lsr
	lsr
	lsr
	bcc Check_Other_Direction
	
	inc P0_Y
	inc P0_End
	
Check_Other_Direction

	lsr
	bcc Done_Controlls
	
	dec P0_Y
	dec P0_End
	
Done_Controlls

	tsx
	sty AUDV0

Check_Buttons
	lda INPT4,X
	bmi skip_RESMPX
	
	sty RESMP0,X
	
skip_RESMPX
	dex
	bpl Check_Buttons


	bit CXM0FB
	bpl Check_CXM1FB
	
	stx RESMP0


Check_CXM1FB
	bit CXM1FB
	bpl Check_Missile_Player_CX

	stx RESMP1


	
Check_Missile_Player_CX



	bit CXM0P
	bpl Check_Other_Colision
	
	inc P0_End
	dec P1_End
	lsr AUDV0

Check_Other_Colision

	bit CXM1P
	bpl Done_CX

	
	inc P1_End
	dec P0_End
	lsr AUDV0
	
Done_CX


	sta CXCLR

	txa		;used to be at top, put here just incase

	bne Start_Frame


	

	org $FFFC
	.word Start
	.byte "RS"
