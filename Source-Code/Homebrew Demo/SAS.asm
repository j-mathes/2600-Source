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

    processor  6502

    include vcs.h

page        equ  $81 ; Used to determine which frame to draw
tempvar     equ  $82 ; Used in various routines for temporary storage
enable      equ  $83 ; Value needed to enable SC RAM
tmpadrlo    equ  $84 ; Temporary Zeropage address lobyte
tmpadrhi    equ  $85 ; Temporary Zeropage address hibyte
xpos        equ  $86 ; Current horizontal position of cursor
ypos        equ  $87 ; Current vertical position of cursor
sclin       equ  $88 ; Current scanline (very fudged right now)
temp        equ  $89 ; Temporary storage
temp2       equ  $8a ; Temporary storage
mode        equ  $8b ; drawing mode
hknob       equ  $8c ; horizontal knob position
vknob       equ  $8d ; vertical knob position
hkdata      equ  $8e 
vkdata      equ  $8f
jshval      equ  $90
jsvval      equ  $91
jsnext      equ  $92
jsprev      equ  $93
curdev      equ  $94 ; current device number
curmode     equ  $95 ; Used in reset routine to bounce screen
keydelay    equ  $96
clrandom    equ  $97 ; clear random number
menutable   equ  $98 ; 12 bytes
grheight    equ  $a4
selmode     equ  $a5
seldelay    equ  $a6
grpos       equ  $a7
oldxpos     equ  $a8
oldypos     equ  $a9
intro       equ  $aa

; curdev values:
;
;   0 = Joystick
;   1 = Driving Controllers
;   2 = Amiga Mouse
;   3 = Atari ST Mouse

    org  $c800

    .byte $0

    org  $d000
    cld
    clc
    lda  $80
    ora  #$02
    sta  enable

;    jsr  cls
    lda  #$0
    sta  selmode
    sta  keydelay
    sta  curdev
    sta  clrandom
    jsr  seldev
    lda  #$1
    sta  intro

restart
    lda  #$8
    sta  AUDC1
    sta  AUDC0
    sta  AUDF0
    lda  #$0
    sta  AUDV1
    sta  AUDV0
    sta  page
    sta  xpos
    sta  ypos
    sta  hknob
    sta  vknob
    sta  mode
    sta  curmode
Start
    sty  WSYNC
    lda  #$8
    sta  tempvar
    lda  SWCHA
    tay
    and  pattern+7
    sta  jshval
    tya
    and  pattern+15
    sta  jsvval
jloop
    STA  WSYNC
    jsr  hreadindy
    sta  WSYNC
    jsr  plot
    dec  tempvar
    bpl  jloop
; end of pattern reader

; move ball

    lda  xpos
    clc
    adc  #$24
    jsr  calcpos
    sta  HMBL
    sta  WSYNC
resloop0
    dey
    bpl  resloop0
    sta  RESBL
    sta  WSYNC
    sta  HMOVE

; end of move ball

Start1
    inc  page
    lda  #$00       ;get contents of memory
    sta  PF0
    sta  PF1
    sta  PF2        ;save into a pattern control register
    sta  COLUBK
    sta  ENABL
    lda  #$01
    sta  CTRLPF     ;set background control register
    lda  #$42
    sta  COLUPF
    lda  #$04
    sta  COLUP1     ;set right side color
    sta  COLUP0
    ldy  #$57
    sty  WSYNC      ;wait for horizontal sync
    ora  INPT0
    sta  VBLANK     ;start vertical blanking
    sty  VSYNC      ;start vertical retrace
    lda  #$2A
    sta  TIM8T      ;set timer for appropriate length

Loop4
    ldy  INTIM
    bne  Loop4      ;waste time
    sty  WSYNC      ;wait for horizontal sync
    sty  VSYNC      ;end vertical retrace period

    lda  #$24
    sta  TIM64T     ;set timer for next wait
    lda  curmode
    beq  noswish
    sta  AUDF1
    lda  #$f
noswish
    sta  AUDV1
    lda  SWCHB
    and  #$1
    beq  respressed
    ldx  #$0
    lda  curdev
    cmp  #$1
    beq  isindy
    lda  INPT4
    bpl  isindy
    lda  SWCHB
    and  #$40
    bne  isindy
    ldx  #$1
isindy
    stx  mode

    ldx  #$0
    ldy  ypos
    lda  xpos
    cmp  oldxpos
    bne  moved
    lda  ypos
    cpy  oldypos
    beq  notmoved
moved
    sta  oldxpos
    sty  oldypos
    ldx  #$2
    lda  mode
    beq  notmoved
    ldx  #$0
notmoved
    stx  AUDV0
;    lda  curmode
;    beq  noswish
;    sta  AUDF1
;    lda  #$f
;noswish
;    sta  AUDV1
    lda  intro
    cmp  #$2
    beq  nintrost
    lda  SWCHB
    and  #$2
    bne  nosel
    lda  seldelay
    bne  nosel2
    lda  intro
    bne  nosel2

    inc  selmode
    lda  selmode
    cmp  #$5
    bne  notselend
    lda  #$0
    sta  selmode
notselend
    lda  #$1
    sta  seldelay
    jmp  nosel2
nosel
    lda  #$0
    sta  seldelay
nosel2
;    lda  SWCHB
;    and  #$1
;    sta  temp2
;    beq  respressed
;nosel3
    lda  intro
    bne  clrandok
    dec  clrandom
    bpl  clrandok
    lda  #$b
    sta  clrandom
clrandok
    lda  #$0
    sta  keydelay
    beq  noreset
respressed
    lda  intro
    beq  notintro
isintro
    cmp  #$1
    bne  nintrost
    lda  #$2
    sta  intro
    lda  #$c
    sta  clrandom
nintrost
    lda  curmode
    bne  notinmenu
    dec  clrandom
    bpl  notinmenu
    ldx  #$0
    stx  intro
    stx  clrandom
    inx
    stx  selmode
    stx  keydelay
    stx  seldelay
notintro
    lda  keydelay
    beq  reset
;    dec  keydelay
    bne  noreset
reset
    ldy  selmode
    beq  notinmenu
    dey
    sty  curdev
    jsr  seldev
    lda  #$0
    sta  selmode
    lda  #$20
    sta  keydelay
    jmp  noreset
notinmenu
    lda  curmode
    bne  noreset
    lda  #$8
    sta  curmode
    lda  #$20
    sta  keydelay
    jsr  clr
noreset
    lda  curdev
    bne  notjs

ckjoystk           ; joystick only begin
    lda  selmode
    ora  intro
    bne  Loop3
    lda  SWCHB
    bmi  nodiff
    lda  page
    and  #$1
    beq  Loop3
nodiff
    lda  SWCHA
    and  #$f0
    eor  #$f0
    bne  joymovd
    jmp  Loop3
joymovd
    eor  #$f0
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
    rol
    bcs  joy3
    ldy  ypos
    cpy  #$0
    beq  z1
    dec  ypos
    dec  vknob
joy3
    rol
    bcs  z1
    ldy  ypos
    cpy  #$77
    beq  z1
    inc  ypos
    inc  vknob     ; joystick only end

notjs
    lda  xpos
    cmp  #$5f
    bmi  z1
    lda  #$5f
    sta  xpos
z1
    lda  xpos
    bpl  z2
    lda  #$0
    sta  xpos
z2
    lda  ypos
    cmp  #$77
    bmi  z3
    lda  #$77
    sta  ypos
z3
    lda  ypos
    bpl  Loop3
    lda  #$0
    sta  ypos

Loop3
    ldy  INTIM
    bne  Loop3      ;waste time
    sty  WSYNC      ;wait for horizontal sync
	lda  #$00
    sta  VBLANK     ;end vertical blanking
	sty  WSYNC
	sty  WSYNC
    nop
    nop
    sta  RESM0

    lda  #$d4
    sta  sclin      ;set number of scanlines
	sta  WSYNC
	lda  #$00
	sta  PF0
    sta  PF2        ;clear playfield
	sta  REFP0
	sta  HMP1
    sta  HMBL
	lda  #$03
	sta  NUSIZ0
	sta  NUSIZ1

etchtop             ;loop to draw top of etch-a-sketch
	stx  WSYNC
	ldx  sclin
    cpx  #$c8       ;at the top of the etch-a-sketch?
    bne  nottop
    ldy  curmode
    beq  starttop
    jsr  junk
    dec  curmode
starttop
	lda  #$7f
	sta  PF1
	lda  #$ff
    sta  PF2        ; load pattern control registers

    ldy  #$10
    lda  curdev
    cmp  #$1
    bne  notdriving
    lda  selmode
    bne  notdriving
    lda  #$2       ; driving only begin was 4!
    sta  tempvar 
jloop2
    STA  WSYNC
    jsr  hreadindy
    dec  sclin
    sta  WSYNC
    jsr  plot
    dec  sclin
    dec  tempvar
    bpl  jloop2 
    ldy  #$1
notdriving
    jsr  junk      ; driving only end
    ldx  #$b8
    stx  sclin

nottop
    cpx  #$b8       ;at the top of the drawing screen?
	beq  b2
	dec  sclin
    bne  etchtop

b2  lda  page       ;get page number and draw screen
	and  #$01
	tax

    lda  selmode
    bne  domenu
    jsr  drawit
    jmp  scrdone
domenu              ; copies addrs to zero-page for RetroWare
    sta  WSYNC  
    sta  WSYNC
	lda  #$70
	sta  PF1
	lda  #$00
	sta  PF2 
    ldy  #$1d
    jsr  junk
    ldx  #$0b
setmenu1
    lda  menuadr1,x
    sta  menutable,x
    dex
    bpl  setmenu1
    lda  selmode
    cmp  #$1
    bne  notdev1
    lda  #$23
    sta  COLUP0
    sta  COLUP1
notdev1
    lda  #$9
    sta  grheight
    jsr  menu
    lda  #$4
    sta  COLUP0
    sta  COLUP1
    ldx  #$0b
setmenu2
    lda  menuadr2,x
    sta  menutable,x
    dex
    bpl  setmenu2
    lda  selmode
    cmp  #$2
    bne  notdev2
    lda  #$23
    sta  COLUP0
    sta  COLUP1
notdev2
    lda  #$9
    sta  grheight
    jsr  menu
    lda  #$4
    sta  COLUP0
    sta  COLUP1
    ldx  #$b
setmenu3
    lda  menuadr3,x
    sta  menutable,x
    dex
    bpl  setmenu3
    lda  selmode
    cmp  #$3
    bne  notdev3
    lda  #$23
    sta  COLUP0
    sta  COLUP1
notdev3
    lda  #$9
    sta  grheight
    jsr  menu
    lda  #$4
    sta  COLUP0
    sta  COLUP1
    ldx  #$b
setmenu4
    lda  menuadr4,x
    sta  menutable,x
    dex
    bpl  setmenu4
    lda  selmode
    cmp  #$4
    bne  notdev4
    lda  #$23
    sta  COLUP0
    STA  COLUP1
notdev4
    lda  #$9
    sta  grheight
    jsr  menu
    lda  #$4
    sta  COLUP0
    sta  COLUP1
    ldy  #$1e
    jsr  junk

scrdone
    lda  #$7f
	sta  PF1
	lda  #$ff
	sta  PF2
    lda  #$39       ;resume sclin count
    sta  sclin
    lda  #$0        ;draw 3 blank lines
    sta  ENABL
    ldy  #$1
	jsr  junk
	sta  NUSIZ0
    sta  NUSIZ1     ;set each player to 1 copy
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

    ldy  #$4
	jsr  junk
	lda  #$0
	sta  PF1
	sta  PF2
    lda  #$8
    sec
    sbc  curmode
    beq  notbot
    tay
    jsr  junk
notbot
    jmp  Start

;junk
;    sta  WSYNC
;    dey
;    bpl  junk
;    rts

drawknobs
	lda  #$1
	sta  temp
dk
	ldy  temp
	lda  hknob,y
    cmp  #$13
    bmi  dk0
	lda  #$0
	sta  hknob,y
dk0 cmp  #$00
    bpl  dk1
    lda  #$12
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

clisthi
    .byte $da,$da,$db,$db,$db,$dc,$dd,$de,$de,$df
    .byte $da,$da,$db,$dc,$dc,$dd,$dd,$de,$df,$df
    .byte $da,$db,$db,$dc,$dc,$dd,$dd,$de,$df,$df
    .byte $da,$da,$db,$db,$dc,$dd,$dd,$de,$df,$df
    .byte $da,$da,$da,$db,$dc,$dc,$dc,$dd,$de,$df
    .byte $da,$db,$db,$dc,$dc,$dd,$de,$de,$df,$df
    .byte $da,$da,$da,$db,$dc,$dd,$dd,$de,$df,$df
    .byte $da,$da,$da,$db,$dd,$de,$de,$df,$df,$df
    .byte $da,$db,$db,$dc,$dd,$dd,$de,$de,$de,$df
    .byte $db,$db,$dc,$dc,$dc,$dd,$dd,$de,$df,$df
    .byte $da,$db,$dc,$dc,$dd,$de,$de,$de,$df,$df
    .byte $da,$db,$db,$dc,$dc,$dd,$dd,$dd,$de,$de
clistlo
    .byte $18,$6c,$60,$8c,$bc,$ec,$b0,$00,$6c,$54
    .byte $48,$ec,$18,$54,$80,$24,$60,$c8,$00,$ec
    .byte $30,$00,$54,$30,$c8,$80,$ec,$24,$98,$e0
    .byte $00,$54,$30,$ec,$98,$3c,$d4,$ec,$48,$24
    .byte $60,$80,$b0,$d4,$0c,$24,$6c,$c8,$80,$6c
    .byte $24,$80,$c8,$8c,$e0,$54,$bc,$e0,$8c,$b0
    .byte $0c,$a4,$e0,$3c,$d4,$00,$6c,$a4,$0c,$c8
    .byte $8c,$c8,$d4,$e0,$0c,$3c,$60,$18,$80,$d4
    .byte $3c,$6c,$a4,$48,$18,$48,$18,$8c,$d4,$3c
    .byte $0c,$48,$00,$60,$a4,$8c,$e0,$54,$60,$a4
    .byte $98,$b0,$18,$bc,$98,$30,$48,$98,$30,$bc
    .byte $bc,$24,$98,$3c,$b0,$30,$a4,$bc,$0c,$b0



menu1
    .byte $00,$00,$00,$04,$02,$01,$01,$01,$01,$01
menu1a
    .byte $00,$00,$00,$05,$0a,$14,$08,$00,$00,$00
menu1b
    .byte $00,$00,$00,$01,$01,$01,$01,$01,$01,$01
menu1c
    .byte $00,$00,$00,$01,$02,$02,$00,$00,$00,$00
menu2
    .byte $00,$00,$00,$44,$48,$50,$50,$50,$50,$50
menu2a
    .byte $00,$00,$00,$40,$a0,$a0,$50,$28,$28,$14
menu2b
    .byte $00,$00,$00,$49,$4a,$4a,$4a,$71,$00,$00
menu2c
    .byte $00,$00,$00,$8e,$51,$51,$51,$4e,$40,$40
menu3
    .byte $00,$00,$00,$40,$4c,$4c,$52,$52,$61,$61
menu3a
    .byte $00,$00,$00,$40,$4c,$4c,$52,$52,$61,$61
menu3b
    .byte $00,$18,$04,$cc,$54,$54,$54,$d4,$40,$40
menu3c
    .byte $00,$60,$10,$37,$50,$53,$54,$53,$00,$00
menu4
    .byte $00,$00,$00,$9c,$a2,$a2,$a2,$9c,$80,$80
menu4a
    .byte $00,$00,$00,$9c,$a2,$a2,$a2,$9c,$80,$80
menu4b
    .byte $00,$00,$00,$31,$4a,$0a,$4a,$72,$42,$79
menu4c
    .byte $00,$00,$00,$14,$a5,$25,$25,$b4,$20,$04
menu5
    .byte $00,$00,$00,$77,$90,$93,$94,$93,$00,$00
menu5a
    .byte $00,$00,$00,$77,$90,$93,$94,$93,$00,$00
menu5b
    .byte $00,$00,$00,$8c,$52,$52,$52,$52,$52,$8c
menu5c
    .byte $00,$00,$00,$c9,$2a,$0c,$2c,$ca,$08,$08
menu6
    .byte $00,$00,$00,$18,$a0,$3c,$24,$98,$00,$00
menu6a
    .byte $00,$00,$00,$18,$a0,$3c,$24,$98,$00,$00
menu6b
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
menu6c
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00

seldev
    lda  #<driving      ; get lobyte of driving controller
    sta  tmpadrlo       ; save in zeropage temporary address lobyte
    lda  #>driving      ; get hibyte of driving contrlloer
    sta  tmpadrhi       ; save in zeropage temporary address hibyte
    ldx  curdev         ; find out what the current device is
    cpx  #$1            ; is it the driving controllers?
    beq  devfound       ; if it is go get the driving controller data
    lda  #<mouse        ; get lobyte of Amiga mouse data address
    sta  tmpadrlo       ; save in zeropage temporary address lobyte
    lda  #>mouse        ; get hibyte of Amiga mouse data address
    sta  tmpadrhi       ; save in zeropage temporary address hibyte
    cpx  #$2            ; is the current device the mouse?
    beq  devfound       ; if it is go get the mouse data
    lda  #<stmouse      ; get lobyte of Atari ST mouse data address
    sta  tmpadrlo       ; save in zeropage temporary address lobyte
    lda  #>stmouse      ; get hibyte of Atari ST mouse data address
    sta  tmpadrhi       ; save in zeropage temporary address hibyte
                        ; by elimination device must be Atari ST mouse
devfound            
    ldx  enable         ; get enable control byte
    lda  $f000,x        ; save in SC byte register
    sta  $fff8          ; write to SC softswitch
;   ldx  #$0     
    ldy  #$f            ; set number of bytes-1 to move
seldev1                 
    lda  (tmpadrlo),y   ; get byte to move
    tax                 ; put in x register
    lda  $f000,x        ; move to SC byte register
    nop                 ; write delay
    sta  pattern,y      ; write to device pattern stream
    dey                 ; decrease counter
    bpl  seldev1        ; loop until y<0
    ldx  $80            ; get original control byte
    lda  $f000,x        ; move to SC byte register
    sta  $fff8          ; write to SC softswitch
    rts                 ; exit device selection routine

    org $d600


pattern
    ds   16             ; device pattern stream

menu
    lda  #$03                  ; set both players to 3 copies
    sta  NUSIZ0
    sta  NUSIZ1
    ldx  #$6                   ; move players 12 columns over
    ldy  #$0
    sta  WSYNC                 ; wait for scanline
menuloop1
    dex                        ; wait for column (15 bit wide) x
    bpl  menuloop1
    nop                        ; additional delay
    sta  RESP0                 ; reset player 0
    sta  RESP1                 ; reset player 1
    lda  #$d0                  ; set player 0 to move left 1 pixel
    sta  HMP0
    lda  #$e0
    sta  HMP1
    sta  WSYNC
    sta  HMOVE                 ; move player 0

menuloop2
    lda  #$01
    sta  VDELP0
    sta  VDELP1
menuloop3
    ldy  grheight
    lda  (menutable),y           ; get player0 copy1 data
    sta  GRP0          
    sta  WSYNC
    lda  (menutable+$2),y        ; get player1 copy1 data
    sta  GRP1
    lda  (menutable+$4),y        ; get player0 copy2 data
    sta  GRP0
    lda  (menutable+$6),y        ; get player1 copy2 data
    sta  tempvar
    lda  (menutable+$8),y        ; get player0 copy3 data
    tax
    lda  (menutable+$A),y        ; get player1 copy3 data
    tay
    lda  tempvar
    sta  GRP1
    stx  GRP0
    sty  GRP1
    sta  GRP0
    dec  grheight
    bpl  menuloop3                 ; loop until done
    lda  #$0
    sta  VDELP0
    sta  VDELP1
    sta  GRP1
    sta  GRP0
    sta  GRP1
    rts

menuadr4
    .byte <menu1
    .byte >menu1
    .byte <menu2
    .byte >menu2
    .byte <menu3
    .byte >menu3
    .byte <menu4
    .byte >menu4
    .byte <menu5
    .byte >menu5
    .byte <menu6
    .byte >menu6
menuadr3
    .byte <menu1a
    .byte >menu1a
    .byte <menu2a
    .byte >menu2a
    .byte <menu3a
    .byte >menu3a
    .byte <menu4a
    .byte >menu4a
    .byte <menu5a
    .byte >menu5a
    .byte <menu6a
    .byte >menu6a
menuadr2
    .byte <menu1b
    .byte >menu1b
    .byte <menu2b
    .byte >menu2b
    .byte <menu3b
    .byte >menu3b
    .byte <menu4b
    .byte >menu4b
    .byte <menu5b
    .byte >menu5b
    .byte <menu6b
    .byte >menu6b
menuadr1
    .byte <menu1c
    .byte >menu1c
    .byte <menu2c
    .byte >menu2c
    .byte <menu3c
    .byte >menu3c
    .byte <menu4c
    .byte >menu4c
    .byte <menu5c
    .byte >menu5c
    .byte <menu6c
    .byte >menu6c

    org  $d700

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
    beq  loop2
    jmp  loop2b
loop2    
    lda  d6,y
    sta  WSYNC
    sta  GRP1
    lda  d0,y
    sta  GRP0
; 26 cycles between sta grp0 and lda d2,y
    cpy  ypos       ;3
    bne  notpot     ;3
    lda  #$2        ;2
    sta  ENABL      ;3

    cmp  tempvar    ;3
    nop             ;2
    nop             ;2
    nop             ;2
;    nop             ;2
;    nop             ;2
;    cmp  tempvar    ;3 wastes cycles only = 27 cycles
    lda  d2,y
    sta  GRP0
    lda  d4,y
    sta  GRP0
    nop
    lda  d8,y
    sta  GRP1
    lda  da,y
    sta  GRP1
    dey
	bpl  loop2
	sty  tempvar
	lda  #$00
	sta   GRP1
	sta   GRP0
	rts

notpot
    cmp  tempvar    ;3+1+6
    lda  #$0        ;2
    sta  ENABL      ;3
    nop             ;2
    cmp  tempvar    ;3

    lda  d2,y       
    sta  GRP0       
    lda  d4,y
    sta  GRP0
    nop
    lda  d8,y
    sta  GRP1
    lda  da,y
    sta  GRP1
    dey
	bpl  loop2
	sty  tempvar
	lda  #$00
    sta  GRP1
    sta  GRP0
	rts

clrofflst
    .byte $00,$0a,$14,$1e,$28,$32,$3c,$46,$50,$5a,$64,$6e

cls
    lda  #$b
    sta  clrandom
clsloop
    jsr  clr
    dec  clrandom
    bne  clsloop
clr ldx  enable         ; Get enable byte
    lda  $f000,x        ; put in SC's byte buffer
    sta  $fff8          ; write byte to SC softswitch
    ldx  #$0
    lda  #$9
    sta  temp
cl0
    ldy  clrandom
    lda  clrofflst,y
    clc
    adc  temp
    tay
    lda  clisthi,y
    sta  tmpadrhi
    lda  clistlo,y
    sta  tmpadrlo
    ldy  #$b
cl1 lda  $f000,x        ; Put 0 in SC's byte buffer
    lda  (tmpadrlo),y   ; store in bitmap
    dey                 ; decrease counter variable
    bpl  cl1            ; until < 0

    inc  tmpadrhi       ; increase page number
    dec  temp
    bpl  cl0            ;     yes = done clearing page
clend
    ldx  $80            ;   get initial SC control byte
    lda  $f000,x        ;   save it in the SC byte register
    sta  $fff8          ;   write it to the SC softswitch
    rts                 ;   done clearing


    org  $d800

loop2b
    lda  d7,y
    sta  WSYNC
    sta  GRP1
    lda  d1,y
    sta  GRP0

; 26 cycles between sta grp0 and lda d2,y
    cpy  ypos       ;3
    bne  notpot2    ;3
    lda  #$2        ;2
    sta  ENABL      ;3

    cmp  tempvar    ;3
    nop             ;2
    nop             ;2
    nop             ;2
    cmp  tempvar    ;3 wastes cycles only = 27 cycles
    lda  d3,y
    sta  GRP0
    lda  d5,y
    sta  GRP0
    nop
    lda  d9,y
    sta  GRP1
    lda  db,y
    sta  GRP1
    dey
    bpl  loop2b
	sty  tempvar
	lda  #$00
	sta   GRP1
	sta   GRP0
	rts

notpot2
    sty  temp       ;3+1+6
    lda  #$0        ;2
    sta  ENABL      ;3
    nop             ;2
    nop             ;2
    nop             ;2
    nop
    lda  d3,y       
    sta  GRP0       
    lda  d5,y
    sta  GRP0
    nop
    lda  d9,y
    sta  GRP1
    lda  db,y
    sta  GRP1
    dey
    bpl  loop2b
	sty  tempvar
	lda  #$00
	sta   GRP1
	sta   GRP0
	rts

hreadindy
    lda  curdev
    beq  jsdelay
    ldy  #$0
    lda  jshval
    cmp  pattern+3
    beq  indone
    iny
    cmp  pattern+4
    beq  indone
    iny
    cmp  pattern+5
    beq  indone
    iny
indone
    lda  SWCHA
    and  pattern+7
    sta  jshval
    cmp  pattern,y
    bne  notright
    inc  xpos
    dec  hknob
notright
    sta  WSYNC
    cmp  pattern+2,y
    bne  notleft
    dec  xpos
    inc  hknob
notleft
    ldy  #$0
    lda  jsvval
    cmp  pattern+11
    beq  vindone
    iny
    cmp  pattern+12
    beq  vindone
    iny
    cmp  pattern+13
    beq  vindone
    iny
vindone
    lda  SWCHA
    and  pattern+15
    sta  jsvval
    cmp  pattern+8,y
    bne  vnotright
    dec  ypos
    dec  vknob
vnotright
    sta  WSYNC
    cmp  pattern+10,y
    bne  vnotleft
    inc  ypos
    inc  vknob
vnotleft
xreadindy
    rts

jsdelay
    sta  WSYNC
    sta  WSYNC
    rts

calcpos

; On entry A = vertical position
; On exit Y = coarse position
;         A = fine position

    TAY            ;2
    INY            ;2
    TYA            ;2
    AND    #$0F    ;2
    STA    tempvar  ;3
    TYA            ;2
    LSR            ;2
    LSR            ;2
    LSR            ;2
    LSR            ;2
    TAY            ;2
    CLC            ;2
    ADC    tempvar  ;3
    CMP    #$0F    ;2
    BCC    nextpos ;2
    SBC    #$0F    ;2
    INY            ;2

nextpos
    EOR    #$07    ;2
    ASL            ;2
    ASL            ;2
    ASL            ;2
    ASL            ;2
    INY
    INY
    INY
    RTS            ;6

delay
	dey
	bpl  delay
	rts

junk
	sta  WSYNC
	dey
	bpl  junk
	rts


    org $d900
	
plot
    lda  xpos
    bmi  plot4
    cmp  #$60
    bpl  plot4
	tay
plot1
    ror
	ror
	ror
	ror
    and  #$f
	clc
    adc  #$fa
    sta  tmpadrhi
	tya
    and  #$0f
	tax
    and  #$08
    beq  plot2
    lda  #$80
plot2
    sta  tmpadrlo
    lda  pixel,x
    ldy  ypos
    bmi  plot4
    cpy  #$78
    bpl  plot4
    ldx  mode
    cpx  #$1
    beq  plot4
    cpx  #$5
    beq  clear
    ora  (tmpadrlo),y 
    jmp  plot2b
clear
    lda  #$0
    beq  plot2b
plot2a
    eor  (tmpadrlo),y
plot2b
    tax
    ldy  enable
    lda  $f000,y
    sta  $fff8
    ldy  ypos
    lda  $f000,x
    lda  (tmpadrlo),y
    ldy  $80
    lda  $f000,y
    sta  $fff8
plot3
    rts
plot4
    sta  WSYNC
    rts


pixel
    .byte   $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
modespeed
	.byte	$01,$03,$05,$f
modewait
	.byte   $02,$04,$02,$02,$08

; Driving Controllers
driving
dhnext
    .byte  $80,$a0
dhprev
    .byte  $b0
dhcurr
    .byte  $30,$80,$a0,$b0
dhmask
    .byte  $b0

dvnext
    .byte  $08,$0a
dvprev
    .byte  $0b
dvcurr
    .byte  $03,$08,$0a,$0b
dvmask
    .byte  $0b

mouse
    .byte $20,$a0
    .byte $80
    .byte $00,$20,$a0,$80
    .byte $a0
    .byte $10,$50
    .byte $40
    .byte $00,$10,$50,$40
    .byte $50

stmouse
    .byte $20,$30
    .byte $10
    .byte $00,$20,$30,$10
    .byte $30
    .byte $80,$c0
    .byte $40
    .byte $00,$80,$c0,$40
    .byte $c0


knoblist
	.byte   $00,$bc,$b6,$b0,$aa,$a4,$9e,$98,$92,$8c
	.byte	$06,$0c,$12,$18,$1e,$24,$2a,$30,$36,$3c

knobs
    .byte $38 ; |  XXX   |
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

;d0  ds  128
d0  .byte $00,$7f,$40,$5f,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
    .byte $50,$50,$50,$51,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
    .byte $51,$51,$51,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
    .byte $50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
    .byte $50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
    .byte $5f,$40,$5f,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
    .byte $50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
    .byte $50,$50,$50,$50,$5f,$40,$7f,$00,$00,$00,$00,$00,$00,$00,$00,$00
;d1  ds  128
d1  .byte $00,$ff,$00,$ff,$00,$00,$3e,$22,$66,$7c,$40,$c1,$03,$00,$00,$0b
    .byte $1f,$60,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3f,$60,$c0
    .byte $80,$00,$00,$c0,$40,$7f,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00
;d2  ds  128
d2  .byte $00,$ff,$00,$ff,$00,$00,$20,$20,$20,$60,$e0,$a0,$20,$00,$00,$ff
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$1c,$e0,$80,$00,$00
    .byte $00,$00,$02,$02,$0e,$f8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$07,$02,$02,$02,$03,$02,$02,$07,$00,$00,$00
    .byte $00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00
;d3  ds  128
d3  .byte $00,$ff,$00,$ff,$00,$00,$e3,$9a,$9a,$f3,$88,$88,$98,$70,$00,$c0
    .byte $40,$40,$40,$40,$40,$40,$40,$40,$40,$c0,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$01,$01,$00,$00,$00,$00,$03,$02,$03,$01,$00,$00,$00,$00,$00
    .byte $ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$33,$54,$44,$47,$c4,$23,$20,$c0,$00,$00,$00
    .byte $00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00

;d4  ds  128
d4  .byte $00,$ff,$00,$ff,$00,$00,$80,$9c,$92,$9c,$10,$30,$20,$20,$00,$40
    .byte $40,$40,$40,$40,$40,$40,$40,$c0,$83,$fe,$e0,$b0,$98,$88,$8c,$82
    .byte $81,$80,$80,$80,$80,$00,$00,$00,$00,$00,$00,$00,$c0,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $7e,$81,$00,$00,$03,$3c,$c0,$00,$00,$00,$81,$7e,$00,$00,$00,$00
    .byte $ff,$00,$ff,$00,$00,$00,$80,$80,$e4,$94,$94,$e6,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$8f,$48,$08,$c8,$48,$9f,$08,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00

;d5  ds  128
d5  .byte $00,$ff,$00,$ff,$00,$00,$00,$1f,$30,$20,$20,$10,$11,$1f,$00,$00
    .byte $08,$08,$10,$20,$21,$42,$82,$84,$0f,$08,$08,$08,$0f,$00,$00,$00
    .byte $80,$80,$80,$00,$00,$00,$00,$00,$00,$f0,$88,$04,$02,$01,$00,$01
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $06,$88,$88,$88,$08,$08,$3e,$04,$04,$84,$00,$00,$00,$00,$00,$00
    .byte $ff,$00,$ff,$00,$00,$00,$00,$00,$6c,$82,$a8,$46,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$c7,$88,$88,$88,$a8,$e7,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00
;d6  ds  128
d6  .byte $00,$ff,$00,$ff,$00,$00,$1c,$34,$38,$00,$01,$81,$81,$01,$00,$00
    .byte $03,$04,$38,$c0,$80,$00,$00,$78,$88,$08,$08,$f0,$00,$00,$01,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$04,$04,$04,$04,$84,$fc
    .byte $44,$24,$24,$14,$1c,$04,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $78,$c5,$81,$81,$e1,$91,$51,$61,$01,$01,$01,$01,$00,$00,$00,$00
    .byte $ff,$00,$ff,$00,$00,$00,$00,$00,$6a,$8a,$aa,$4c,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$04,$8c,$8a,$8a,$8a,$11,$11,$3b,$00,$00,$00
    .byte $00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00
;d7  ds  128
d7  .byte $00,$ff,$00,$ff,$00,$00,$00,$9d,$95,$9d,$b0,$20,$20,$00,$00,$00
    .byte $c0,$00,$00,$00,$00,$01,$c1,$32,$0c,$3c,$27,$20,$60,$80,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $e3,$14,$04,$86,$86,$86,$45,$45,$45,$45,$45,$45,$45,$c3,$00,$00
    .byte $ff,$00,$ff,$00,$00,$00,$00,$00,$58,$84,$90,$cc,$80,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$47,$c4,$a6,$a1,$a4,$13,$10,$b8,$00,$00,$00
    .byte $00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00
;d8  ds  128
d8  .byte $00,$ff,$00,$ff,$00,$00,$c1,$02,$e6,$27,$cd,$00,$00,$00,$00,$00
    .byte $00,$40,$40,$40,$81,$02,$02,$02,$03,$01,$01,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$c0,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $80,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$fc,$48,$48,$c8,$4a,$de,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00
;d9  ds  128
d9  .byte $00,$ff,$00,$ff,$00,$00,$00,$08,$08,$78,$3c,$10,$10,$10,$00,$00
    .byte $00,$00,$3e,$c0,$80,$00,$00,$00,$00,$00,$c0,$70,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$70,$88,$80,$f8,$88,$70,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00
;da  ds  128
da  .byte $00,$ff,$00,$ff,$00,$00,$00,$01,$00,$00,$02,$06,$04,$04,$04,$00
    .byte $00,$00,$00,$08,$08,$08,$0f,$08,$08,$08,$08,$08,$10,$10,$10,$10,$10
    .byte $10,$10,$10,$20,$20,$20,$40,$40,$40,$80,$80,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00

;db  ds  120
db  .byte $00,$fe,$02,$fa,$0a,$0a,$0a,$8a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
    .byte $0a,$0a,$4a,$4a,$4a,$4a,$8a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
    .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
    .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
    .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
    .byte $fa,$02,$fa,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
    .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
    .byte $0a,$0a,$0a,$0a,$fa,$02,$fe,$00

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
    .byte   $00,$04,$08,$0c,$10,$14,$18,$1c,$01,$05,$09,$0d
    .byte   $11,$15,$19,$1d,$02,$06,$0a,$0e,$12,$16,$1a,$1e
    org $e840
    .byte   $54,$51,$4d,$49,$45,$41,$3d,$39,$83,$02,$a6,$c3
    .byte   $bd,$43,$7d,$ef,$66,$7c,$55,$87,$d0,$6c,$55,$31
;    ds  24

    org $e8ff
    .byte     $00
