;  Subject: [stella] Asymmetrical Reflected Playfield 
;  From: Glenn Saunders <cybpunks2@earthlink.net> 
;  Date: Thu, 20 Sep 2001 23:54:38 -0700 

; How to Draw an Asymmetric Reflected Playfield
; by Roger Williams
; Reflected mode modifications by Glenn Saunders

; with a lot of help from Nick Bensema
; (this started out as his "How to Draw a Playfield")

;Roger Williams:

; For comparison, I have tightened up Nick's code
; just a little by eliminating all the subroutine
; calling overhead, which is more like how a real
; game would work, and eliminated the scrolling and
; color effects to isolate them from the pure act of
; displaying a bitmap.
;
	processor 6502
	include vcs.h

	org $F000
       
Temp       = $80
ScanLine   = $90
ScanPix    = $91
PFColorRAM = $92
;FrameCounter = $93 was going to try some color cycling


Start
;
	SEI  ; Disable interrupts, if there are any.
	CLD  ; Clear BCD math bit.
	LDX  #$FF
	TXS  ; Set stack to beginning.
	LDA #0
B1      STA 0,X
	DEX
	BNE B1

MainLoop
	LDX  #0	   ;vertical blank
	LDA  #2
	STA  WSYNC  
	STA  WSYNC
	STA  WSYNC
	STA  VSYNC ;Begin vertical sync.
	STA  WSYNC ; First line of VSYNC
	STA  WSYNC ; Second line of VSYNC.

	LDA  #44   ;init timer for overscan
	STA  TIM64T

	STA  WSYNC ; Third line of VSYNC.
	STA  VSYNC ; (0)


	LDA #0
	STA COLUBK  ; Background will be black.

VBLOOP	LDA INTIM
	BNE VBLOOP ; Whew!
	STA WSYNC
	STA VBLANK  ;End the VBLANK period with a zero.
	LDA PF_Reflect
	STA CTRLPF  ; set playfield to reflect - G.S.
	LDA #0
	;
	STA COLUP0
	STA COLUP1; blacking out player colors
	LDA #$34 ; set playfield color to deep red
	STA COLUPF
	STA PFColorRAM
	;
	LDA #191 
	STA ScanLine
	LDA #6
	STA ScanPix
	;
	; The height of the screen is not an even multiple of 36
	; (the character height including blank.)  Here we waste
	; the extra lines.
	;
	; NB we may do away with this by adding 2 scans to each
	; char in the blank or fore and aft bigpix lines
	;
	LDX #12
	LDA #0
	STA PF0
	STA PF1
	STA PF2; zero out player shapes
VPosition
	STA WSYNC
	DEC ScanLine
	DEX
	BNE VPosition
	;
	LDX #6
ScanLoop
	DEC ScanPix		;next screen pixel line
	BNE ScanGo
	LDA #5
	STA ScanPix
	DEX			;next big pixel line
	BNE ScanGo
	LDX #6
ScanGo
	STA WSYNC
	;
	; Time to begin cycle counting
	;
	LDA PFData0,X           ;[0]+4
	STA PF0                 ;[4]+3 = *7*   < 23	;PF0 visible
	
	LDA PFData1,X           ;[7]+4
	STA PF1                 ;[11]+3 = *14*  < 29	;PF1 visible
	
	LDA PFData2,X           ;[14]+4
	STA PF2                 ;[18]+3 = *21*  < 40	;PF2 visible

	nop			;[21]+2
	nop			;[23]+2
	nop			;[25]+2
	;six cycles available  Might be able to do something here
	
	LDA PFData0b,X          ;[27]+4

	;PF0 no longer visible, safe to rewrite
	STA PF0                 ;[31]+3 = *34* 

	LDA PFData1b,X		;[34]+4

	;PF1 no longer visible, safe to rewrite
	STA PF1			;[38]+3 = *41*  


	LDA PFData2b,X		;[41]+4
	
	;PF2 rewrite must begin at exactly cycle 45!!, no more, no less
	STA PF2			;[45]+2 = *47*  ; > 46 PF2 no longer visible

	;76-47 = 29 cycles left per scanline available for
	; further calculations (i.e. sprites), not counting the rest of the
	; existing code below that branches off and changes the indexing to the letter graphics

	;nop adding even this one nop, however, breaks this kernel!
	;-Glenn Saunders

	DEC ScanLine
	BNE ScanLoop
	;
	LDA #2
	STA WSYNC  ;Finish scanline 192.
	STA VBLANK ; Make TIA output invisible,
	;
	LDA #0
	STY PF0
	STY PF1
	STY PF1
	STY GRP0
	STY GRP1
	STY ENAM0
	STY ENAM1
	STY ENABL

OverScan
	LDX #30
KillLines
	STA WSYNC
	DEX
	BNE KillLines

	JMP  MainLoop      ;Continue forever.


	org $FF00 ; *********************** GRAPHICS DATA

;               REFLECTED PLAYFIELD
;   PF0|   PF1  |  PF2   |   PF2b |   PF1b |PF0b|
;  4567|76543210|01234567|76543210|01234567|7654|


PFData0  ;D       4 5 6 7
	.byte %00000000
	.byte %00000000
	.byte %00110000
	.byte %01010000
	.byte %01010000
	.byte %01010000
	.byte %00110000
PFData1  ;EA      7 6 5 4 3 2 1 0
	.byte %00000000
	.byte %00000000
	.byte %11101010
	.byte %10001010
	.byte %11001110
	.byte %10001010
	.byte %11100100


PFData2  ;TH      0 1 2 3 4 5 6 7
	.byte %00000000
	.byte %00000000
	.byte %01010010
	.byte %01010010
	.byte %01110010
	.byte %01010010
	.byte %01010111
	
        
PFData2b ;DE   76543210;<--- scanning order
	.byte %00000000
	.byte %00000000
	.byte %01100111
	.byte %01010100
	.byte %01010110
	.byte %01010100
	.byte %01100111

	
PFData1b;RB    01234567;<--- scanning order
	.byte %00000000
	.byte %00000000
	.byte %01101010
	.byte %10101010
	.byte %01100110
	.byte %10101010
	.byte %01100110

PFData0b;Y     7654    ;<--- scanning order
	.byte %00000000
	.byte %00000000
	.byte %00100000
	.byte %00100000
	.byte %01110000
	.byte %01010000
	.byte %01010000
	
        
 
	org $FFFC
        .word Start
        .word Start


