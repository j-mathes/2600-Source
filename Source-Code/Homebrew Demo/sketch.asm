; Here is my Etch-a-sketch emulator
; Please do not distribute this code
; As I plan on finishing it up sometime soon!
; The joysticks are used right for various reasons
; Sometime I would like to use the Paddles, but that
; would take some serious coding.
; the reset button clears the screen, and the select button
; changes the drawing mode.
;
; This only works on a real SC and PC Atari Emulator right now!!!
; 
; HAVE FUN!!!
;
; Code Copyright 1997 by Bob Colbert! (It will be freeware when I'm done!)
;
; Compile using DASM etch.s -f3 -oetch.bin
;
;If you want to try this on a regular 2600, try removing all of the lines 
; from "org $e800" on (near the end) and the "org $c800 / .byte $00" lines (at the beginning),
; these were included to make an acceptable .bin for the emulator, but I'm not sure 
; if the checksums are o.k. for a real SC.  At any rate, removing those lines will give you a 
; 4096 byte file that you can then use with makewav to create a good .wav.


	 processor	6502

VSYNC = $00;
VBLANK = $01;
WSYNC = $02;
RSYNC = $03;
NUSIZ0 = $04;
NUSIZ1 = $05;
COLUP0 = $06;
COLUP1 = $07;
COLUPF = $08;
COLUBK = $09;
CTRLPF = $0A;
REFP0 = $0B;
REFP1 = $0C;
PF0 = $0D;
PF1 = $0E;
PF2 = $0F;
RESP0 = $10;
POSH2 = $11;
RESP1 = $11;
RESM0 = $12;
RESM1 = $13;
RESBL = $14;
AUDC0 = $15;
AUDC1 = $16;
AUDF0 = $17;
AUDF1 = $18;
AUDV0 = $19;
AUDV1 = $1A;
GRP0 = $1B;
GRP1 = $1C;
ENAM0 = $1D;
ENAM1 = $1E;
ENABL = $1F;
HMP0 = $20;
HMP1 = $21;
HMM0 = $22;
HMM1 = $23;
HMBL = $24;
VDELP0 = $25;
VDEL01 = $26;
VDELBL = $27;
RESMP0 = $28;
RESMP1 = $29;
HMOVE = $2A;
HMCLR = $2B;
CXCLR = $2C;

CXM0P = $30;
CXM1P = $31;
CXP0FB = $32;
CXP1FB = $33;
CXM0FB = $34;
CXM1FB = $35;
CXBLPF = $36;
CXPPMM = $37;
INPT0 = $38;
INPT1 = $39;
INPT2 = $3A;
INPT3 = $3B;
INPT4 = $3C;
INPT5 = $3D;

SWCHA = $280;
SWACNT = $281;
SWCHB = $282;
SWBCNT = $283;
INTIM = $284;
TIM1T = $294;
TIM8T = $295;
TIM64T = $296;
T1024T = $297;




page	equ	$81
tempvar equ	$82

char1   equ	$84
char2	equ	$86
char3	equ	$88
char4	equ	$8a
char5	equ	$8c
char6	equ	$8e
char7   equ     $90
char8   equ     $92
char9   equ     $94
char10  equ     $96
char11	equ     $98
char12  equ	$9a
charx	equ	$9c
tmpadrlo  equ	$9e
tmpadrhi  equ	$9f
enable  equ	$a0
xpos	equ	$a1
ypos	equ	$a2
sclin   equ	$a3
temp2	equ	$a4
mode    equ     $a5
lastmode equ    $a6
pgcount equ	$a7
temp	equ	$a8
hknob	equ	$a9
vknob	equ	$aa
hkdata	equ	$ab
vkdata	equ	$ac

        org $c800

        .byte $0

        org $d000

        cld
        clc
	lda	$80
	ora	#$02
	sta	enable
    ldx #$17
loop5
    lda table1,x
    sta char1,x
    dex
    bpl loop5
restart
    lda #$0
    sta page
	sta	pgcount
	sta	xpos
	sta	ypos
	sta	hknob
	sta	vknob
	sta	mode
Start	
	ldy	#$10
	jsr	junk
Start1	inc     page
	inc	pgcount
    lda #$00    ;get contents of memory
    sta PF0
    sta PF1
	sta	PF2 	;save into a pattern control register
    sta COLUBK
    lda #$01
    sta CTRLPF ;set background control register
    lda #$42
    sta COLUPF
    lda #$04
    sta COLUP1  ;set right side color
    sta COLUP0
    ldy #$57
    sty WSYNC  ;wait for horizontal sync
    lda #$02
    ora INPT0
    sta VBLANK ;start vertical blanking
    sty VSYNC  ;start vertical retrace
    lda #$2A
    sta TIM8T  ;set timer for appropriate length
Loop4   ldy  INTIM
        bne  Loop4	;waste time
    sty WSYNC  ;wait for horizontal sync
    sty VSYNC  ;end vertical retrace period

    lda #$24
    sta TIM64T ;set timer for next wait

Loop3
    ldy  INTIM
    bne  Loop3  ;waste time
	sty  WSYNC	;wait for horizontal sync
	lda  #$00
	sta  VBLANK	;end vertical blanking
	sty  WSYNC
	sty  WSYNC
	lda  #$e4
	sta  sclin
	sta  WSYNC
	lda  #$00
	sta  PF0
	sta  PF2
	sta  REFP0
	sta  HMP1
	lda  #$03
	sta  NUSIZ0
	sta  NUSIZ1

loop6
	stx  WSYNC
	ldx  sclin
	cpx  #$e4
	bne  bb1
	lda  #$7f
	sta  PF1
	lda  #$ff
	sta  PF2
bb1	cpx  #$D0
	beq  b2
	dec  sclin
	bne  loop6
b2	lda  page
	and  #$01
	tax
	jsr  drawit

	lda  #$7f
	sta  PF1
	lda  #$ff
	sta  PF2
	lda  #$0
	ldy  #$5
	jsr  junk
	sta  NUSIZ0
	sta  NUSIZ1
	lda  #$7
	sta  COLUP0
	sta  COLUP1
	sta  WSYNC
	ldy  #$2
	jsr  delay
	sta  RESP0
	ldy  #$2
	jsr  delay
	sta  RESP1
	sta  WSYNC
	ldy  #$6
	jsr  drawknobs
	ldy  #$8
	jsr  junk
	lda  #$0
	sta  PF1
	sta  PF2
	ldy  #$1
	jsr  junk
	lda  mode
	sta  PF1
	ldy  #$08
	jsr  junk
	lda  #$0
	sta  PF1
	lda  INPT4
	and  #$80
	beq  ckjoystk
	ldy  mode
nojoy
	lda  pgcount
	cmp  modespeed,y
	beq  ckjoystk
	lda  modewait,y
	tay
	jsr  junk
	jmp  z1

ckjoystk
	lda  #$0
	sta  pgcount
	sta  temp
	lda  SWCHA
	and  #$f0
	eor  #$f0
	bne  joymovd
	ldy  #$4
	jsr  junk
	jmp  z3
joymovd
	eor  #$f0
	ldy  mode
	cpy  #$1
	bne  mode2
	pha
	jsr  plot
	pla
mode2
    ldy  #$2
	jsr  junk
	rol
	bcs  joy1
	ldy  xpos
	cpy  #$5f
	beq  joy1
	inc  xpos
	dec  hknob
joy1
	rol
	bcs  joy2
	ldy  xpos
	cpy  #$0
	beq  joy2
	dec  xpos
	inc  hknob
joy2
;	sta  WSYNC
	rol
	bcs  joy3
	ldy  ypos
	cpy  #$0
	beq  z1
	dec  ypos
	inc  vknob
joy3
	rol
	bcs  z1
	ldy  ypos
	cpy  #$77
	beq  z1
	inc  ypos
	dec  vknob
z1	jsr  plot
z3	ldy  #$0
	lda  SWCHB
	ror
	bcc  reset
	ror
	bcc  select
	lda  mode
	cmp  #$5
	beq  reset
	sty  lastmode
	jmp  Start
reset
	lda  mode
	cmp  #$5
	beq  reset0
	lda  #$5
	sta  mode
	lda  #$77
	sta  ypos
reset0	lda  #$5f
	sta  xpos
reset1
	jsr  plot
	lda  xpos
	clc
	sbc  #$7
	sta  xpos
	bpl  reset1
	dec  ypos
	bmi  reset2
	jmp  Start1
reset2
    jmp  restart
select
	iny
	cpy  lastmode
	beq  oldsel
	sty  lastmode
	dey
	sty  pgcount
	inc  mode
	lda  mode
	cmp  #$4
	bmi  oldsel
	sty  mode
oldsel
	jmp  Start

junk
	sta  WSYNC
	dey
	bpl  junk
	rts

drawknobs
	lda  #$1
	sta  temp
dk
	ldy  temp
	lda  hknob,y
	cmp  #$14
	bne  dk0
	lda  #$0
	sta  hknob,y
dk0	cmp  #$ff
	bne  dk1
	lda  #$13
	sta  hknob,y
dk1	
	tay
	ldx  #$8
	lda  knoblist,y
	bmi  dk1a
	ldx  #$0
dk1a
	ldy  temp
	stx  REFP0,y
	stx  temp2
	and  #$ff
	clc
	adc  #$0
	sta  hkdata,y
	dec  temp
	bpl  dk
	sta  WSYNC
dk1b
	lda  #$6
	sta  temp
dk2	ldx  #$1
dk2a
	lda  hkdata,x
	sta  temp2
	and  #$7f
	clc
	adc  temp
	tay
	lda  knobs,y
	ldy  temp2
	bpl  dk2b
	clc
	ror
dk2b
	sta  GRP0,x
	dex
	bpl  dk2a
	sta  WSYNC
	dec  temp
	bpl  dk2
	lda  #$0
	sta  GRP0
	sta  GRP1
	sta  REFP0
	sta  REFP1
	sta  WSYNC
	rts

subtim
	sty  temp
	lda  sclin
	clc
	sbc  temp
	rts
delay
	dey
	bpl  delay
	rts
drawit
	lda  #$01
	ldy  #$05
	sta  WSYNC
loop1
	dey
	bpl  loop1
	txa
	sta  RESP0
	clc
	ror
	ror
	tax
	nop
	nop
	sta  RESP1
	adc  #$70
	sta  HMP0
	txa
	clc
	adc  #$40
	sta  HMP1
	sta  WSYNC
	sta  HMOVE
	lda  #$77
	sta  tempvar
	tay
	lda  #$70
	sta  PF1
	lda  #$00
	sta  PF2 
	lda  #$04
	cpx  #$0
	bne  loop2b
loop2
	lda  (char11),y
	sta  charx
	sta  WSYNC
	lda  (char5),y
	tax
	lda  (char1),Y
	sta  GRP0
	lda  (char7),y
	sta  GRP1
	nop 
	cmp  tempvar
	lda  (char3),y
	sta  GRP0
	nop
	stx  GRP0
	nop
	nop
	lda  (char9),y
	sta  GRP1
	lda  charx
	sta  GRP1
	dey
	bpl  loop2
	sty  tempvar
	lda  #$00
	sta   GRP1
	sta   GRP0
	rts

loop2b
	lda  (char12),y
	sta  WSYNC
	sta  charx
	lda  (char6),y
	tax
	lda  (char2),Y
	sta  GRP0
	lda  (char8),y
	sta  GRP1
	nop 
	cmp  tempvar
	lda  (char4),y
	sta  GRP0
	NOP
	stx  GRP0
	nop
	nop
	lda  (char10),y
	sta  GRP1
	lda  charx
	sta  GRP1
	dey
	bpl  loop2b
	sty  tempvar
	lda  #$00
	sta   GRP1
	sta   GRP0
	rts

table1
    .byte   <d0
    .byte   >d0
    .byte   <d1
    .byte   >d1
    .byte   <d2
    .byte   >d2
    .byte   <d3
    .byte   >d3
    .byte   <d4
    .byte   >d4
    .byte   <d5
    .byte   >d5
    .byte   <d6
    .byte   >d6
    .byte   <d7
    .byte   >d7
    .byte   <d8
    .byte   >d8
    .byte   <d9
    .byte   >d9
    .byte   <da
    .byte   >da
    .byte   <db
    .byte   >db
   
    org $d900
	
plot	lda	xpos
	tay
plot1	ror
	ror
	ror
	ror
	and	#$f
	clc
	adc	#$fa
	sta	tmpadrhi
	tya
	and	#$0f
	tax
	and	#$08
	beq	plot2
	lda	#$80
plot2
    sta tmpadrlo
	lda	pixel,x
	ldy	ypos
	ldx	mode
	cpx	#$1
	beq	plot2a
	cpx	#$5
	beq	clear
	ora	(tmpadrlo),y	
	jmp	plot2b
clear
    lda #$0
	beq	plot2b
plot2a
	eor	(tmpadrlo),y
plot2b	tax
	ldy	enable
	lda	$f000,y
	sta	$fff8
	ldy	ypos
	lda	$f000,x
	lda	(tmpadrlo),y
	ldy	$80
	lda	$f000,y
	sta	$fff8
plot3	rts

pixel	.byte	$80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
modespeed
	.byte	$01,$03,$05,$f
modewait
	.byte   $02,$04,$02,$02,$08

knoblist
	.byte   $00,$bc,$b6,$b0,$aa,$a4,$9e,$98,$92,$8c
	.byte	$06,$0c,$12,$18,$1e,$24,$2a,$30,$36,$3c

knobs  .byte $38 ; |  XXX   |
       .byte $7C ; | XXXXX  |
       .byte $FE ; |XXXXXXX |
       .byte $EE ; |XXX XXX |
       .byte $EE ; |XXX XXX |
       .byte $6C ; | XX XX  |
       .byte $28 ; |  X X   |
       .byte $6C ; | XX XX  |
       .byte $EE ; |XXX XXX |
       .byte $EE ; |XXX XXX |
       .byte $FE ; |XXXXXXX |
       .byte $7C ; | XXXXX  |
       .byte $38 ; |  XXX   |
       .byte $74 ; | XXX X  |
       .byte $EE ; |XXX XXX |
       .byte $EE ; |XXX XXX |
       .byte $FE ; |XXXXXXX |
       .byte $7C ; | XXXXX  |
       .byte $38 ; |  XXX   |
       .byte $78 ; | XXXX   |
       .byte $F6 ; |XXXX XX |
       .byte $EE ; |XXX XXX |
       .byte $FE ; |XXXXXXX |
       .byte $7C ; | XXXXX  |
       .byte $38 ; |  XXX   |
       .byte $7C ; | XXXXX  |
       .byte $F0 ; |XXXX    |
       .byte $EE ; |XXX XXX |
       .byte $FE ; |XXXXXXX |
       .byte $7C ; | XXXXX  |
       .byte $38 ; |  XXX   |
       .byte $7C ; | XXXXX  |
       .byte $F8 ; |XXXXX   |
       .byte $E6 ; |XXX  XX |
       .byte $FE ; |XXXXXXX |
       .byte $7C ; | XXXXX  |
       .byte $38 ; |  XXX   |
       .byte $7C ; | XXXXX  |
       .byte $FE ; |XXXXXXX |
       .byte $E0 ; |XXX     |
       .byte $FE ; |XXXXXXX |
       .byte $7C ; | XXXXX  |
       .byte $38 ; |  XXX   |
       .byte $7C ; | XXXXX  |
       .byte $FE ; |XXXXXXX |
       .byte $E6 ; |XXX  XX |
       .byte $FA ; |XXXXX X |
       .byte $7C ; | XXXXX  |
       .byte $38 ; |  XXX   |
       .byte $7C ; | XXXXX  |
       .byte $FE ; |XXXXXXX |
       .byte $EE ; |XXX XXX |
       .byte $F6 ; |XXXX XX |
       .byte $78 ; | XXXX   |
       .byte $38 ; |  XXX   |
       .byte $7C ; | XXXXX  |
       .byte $FE ; |XXXXXXX |
       .byte $EE ; |XXX XXX |
       .byte $F6 ; |XXXX XX |
       .byte $74 ; | XXX X  |
       .byte $38 ; |  XXX   |
       .byte $7C ; | XXXXX  |
       .byte $FE ; |XXXXXXX |
       .byte $EE ; |XXX XXX |
       .byte $EE ; |XXX XXX |
       .byte $74 ; | XXX X  |
       .byte $38 ; |  XXX   |


    org $da00
d0  ds  128
d1  ds  128
d2  ds  128
d3  ds  128
d4  ds  128
d5  ds  128
d6  ds  128
d7  ds  128
d8  ds  128
d9  ds  128
da  ds  128
db  ds  120

    org $dffc
	.byte     $00,$F0,$00,$F0

    org $e800
    .byte     $00,$f0
    .byte     $1c
    .byte     $18
    .byte     $0b
    .byte     $00
    .byte     $24
    .byte     $02

    org $e810
    .byte     $00,$04,$08,$0c,$10,$14,$18,$1c,$01,$05,$09,$0d
    .byte     $11,$15,$19,$1d,$02,$06,$0a,$0e,$12,$16,$1a,$1e
    org $e840
    .byte     $00,$00,$00,$00,$00,$00,$00,$00,$db,$61,$6a,$48
    .byte     $44,$40,$3c,$38,$53,$c2,$4b,$47,$43,$3f,$3b,$5b

    org $e8ff
    .byte     $00

