;;RAM Frog Pond By: Rick Skrbina 6/17/09 - 6/26/09

	processor 6502
	include "vcs.h"
	include "macro.h"
	
	seg.u vars
	org $80
	
	seg code
	org $F800
Start
	CLEAN_START
	
	lda #$84
	sta COLUBK
	lda #$16
	sta COLUP0

	ldy #4
	sty AUDC0
	dey
	sty AUDF0
	
	lda #%00110000
	sta NUSIZ0
	sta NUSIZ1
	
	lda #%00010001
	sta CTRLPF
	
	lda #152
	inx
	jsr PositionSprites
	lda #29
	inx
	jsr PositionSprites

	
	lda #%11100000
	sta HMBL
	
	ldx #0
	txs
Load_Game
	lda Start_Frame,X
	sta $80,X
	inx
	cpx #129
	bne Load_Game
	
	lda #200
	sta P0_Y
	clc
	adc #12
	sta P0_End

	ldy #0
	sty Score
	lda #10
	sta Timer2
	dey
	sty GRP1

	
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
	
	org $F980
Start_Frame

	txa
VerticalSync           
	sta WSYNC           
        sta VSYNC
        lsr
        bne VerticalSync 
	
	sta HMOVE
	

Picture
	sta WSYNC
	
	sta ENABL
	
	cpy #100
	bne No_Fly
	stx ENABL

No_Fly

P0_Y = . - $F900 + 1
	cpy #P0_Y
	bne No_Enable_P0
	stx ENAM0
No_Enable_P0

P0_End = . - $F900 + 1
	cpy #P0_End
	bne No_Disable_P0
	sta ENAM0
No_Disable_P0

	
	iny
	bne Picture
	
	tsx	;x=0, incase of no movement
	lda SWCHA
	asl
	bcs Check_Left
	ldx #%11110000
Check_Left
	asl
	bcs Store_HMM0
	ldx #%00010000
Store_HMM0
	stx HMM0
	
Done_Joystick

	ldx #200
	lda INPT4
	bmi No_Button

	dec P0_Y
	.byte $2c
No_Button
	stx P0_Y

	lda P0_Y
	adc #12
	sta P0_End
	
	inc Timer
Timer = . - $F900 + 1
	ldx #Timer
	bne No_Inc_Larger
	
	dec Timer2
Timer2 = . - $F900 + 1
	ldx #Timer2
	bne No_Inc_Larger

	ldx #$FF
	
	bne Game_Over
	
No_Inc_Larger

	
	sty AUDV0
	
	bit CXM0FB
	bvc No_CXM0FB

	lsr AUDV0
	inc Score

	
No_CXM0FB

	sta CXCLR

Score = . - $F900 + 1
	lda #Score
	sta GRP1
	
	ldx #$FF
	
	bne Start_Frame
	
Game_Over

StartGO
	txa
VerticalSyncGO           
	sta WSYNC           
        sta VSYNC
        lsr
        bne VerticalSyncGO
	
PicGO
	sta WSYNC
	iny
	bne PicGO
	
	lda INPT4
	bmi Dont_Reset_Game
	
	sty Score
	bpl Start_Frame
	
Dont_Reset_Game	
	
	bmi StartGO

	org $FFFC
	.word Start
	.byte "RS"
