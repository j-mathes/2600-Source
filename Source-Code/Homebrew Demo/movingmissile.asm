;  ------------------------------------------------------------------------
;   * Subject: [stella] Distella --> DAsm problem
;   * From: Ruffin Bailey <rufbo@bellsouth.net>
;   * Date: Fri, 21 Aug 98 13:55:03 -0000
;  ------------------------------------------------------------------------

; See original message post for details
;   http://www.biglist.com/lists/stella/archives/9808/msg00065.html
; dasm source.s -f3 -osource.bin

; Disassembly of missile.bin aka How to move a missile around your screen.
; Disassembled Sat Aug 15 11:32:54 1998
; Using DiStella v2.0 on a Mac, no less!
;
; Command Line: distella -pafs missile.bin
;
        processor 6502
        include vcs.h

       ORG $F000

START:
       SEI            ;2
       CLD            ;2
       LDA    #$40    ;2
       STA    $80     ;3	$80 is holding the value where missle zero should be shown (the "y-value")
	   				  ;		starting at $40 (64 decimal)
       STA    $81     ;3	$81 is holding the value where missle one should be shown (the "y-value")
	   				  ;		also starting at $40 (64 decimal)

       LDX    #$FF    ;2
       TXS            ;2
       LDA    #$00    ;2
LF00B: STA    VSYNC,X ;4
       DEX            ;2
       BNE    LF00B   ;2
       JSR    LF0D8   ;6
LF013: JSR    LF025   ;6
       JSR    LF03F   ;6
       JSR    LF044   ;6
       JSR    LF07D   ;6
       JSR    LF0D0   ;6
       JMP    LF013   ;3
LF025: LDX    #$00    ;2
       LDA    #$02    ;2
       STA    WSYNC   ;3
       STA    WSYNC   ;3
       STA    WSYNC   ;3
       STA    VSYNC   ;3
       STA    WSYNC   ;3
       STA    WSYNC   ;3
       LDA    #$2C    ;2
       STA    TIM64T  ;4
       STA    WSYNC   ;3
       STA    VSYNC   ;3
       RTS            ;6

LF03F: LDA    #$00    ;2
       STA    COLUBK  ;3
       RTS            ;6



LF044: LDA    #$88    ;2  setting up the colors
       STA    COLUP0  ;3  P0 is blue
       LDA    #$36    ;2
       STA    COLUPF  ;3  PF redish (won't see that here, though)
       LDA    #$D8    ;2
       STA    COLUP1  ;3  P1 yellow (Sir Not Pictured in this film)
       LDA    #$00    ;2
       STA    COLUBK  ;3  BK black
       LDA    #$00    ;2
       STA    CTRLPF  ;3
       LDA    #$00    ;2
       STA    HMM0    ;3

;SWCHA dissection

;Player 0       | Player 1
;===============|===============
;D7  D6  D5  D4 | D3  D2  D1  D0
;rt  lt  dn  up | rt  lt  dn  up


       LDA    SWCHA   ;4
       BMI    LF065   ;2	; if D7 latched, don't move right
       LDY    #%11110000
       STY    HMM0    ;3
LF065: ROL            ;2
       BMI    LF06C   ;2
       LDY    #%00010000    ;2  
	   				  
					  ;I'm using BMI to read D7 of SWCHA
       STY    HMM0    ;3  (which has been read into the accumulator)
LF06C: ROL            ;2  Then rolling the byte to the left and reading the
       BMI    LF073   ;2  next bit (D6,5,4...) with BMI since the next
       INC    $80     ;5  bit would now be D7.
       INC    $80     ;5
LF073: ROL            ;2  $80 holds the scan line that the missile
       BMI    MISSLE1CHECK   ;2  will appear on, and since I'm counting up from 1
       DEC    $80     ;5  in the screen drawing loop, I decrease $80 to move
       DEC    $80     ;5  the missile up and increase $80 to go down.

; we're going to do the same thing now with missile 1
; SWCHA's got that too!  Keep rolling left
MISSLE1CHECK: rol	; grab the next bit      
	   LDA    SWCHA   ;4  
       BMI    M1LEFT   ;2  
       LDY    #$F0    ;2  
       STY    HMM1    ;3  
M1LEFT: ROL            ;2  
       BMI    M1DOWN   ;2
       LDY    #$00    ;2 
       STY    HMM1    ;3 
M1DOWN: ROL            ;2 
       BMI    M1UP   ;2 
       INC    $81     ;5 
       INC    $81     ;5
M1UP: ROL            ;2 
       BMI    JOYDONE   ;2 
       DEC    $81     ;5 
       DEC    $81     ;5 



JOYDONE: STA    CXCLR   ;3	Clear the collision latches.




; see what's in $80 by sticking it in P1's graphic
	lda $80
	sta GRP1

       RTS            ;6  I assume the HMM0 commands are self-explanatory!  ;)


; SCREEN DRAW
LF07D: LDA    INTIM   ;4  Here's the screen draw routine.
       BNE    LF07D   ;2
       STA    WSYNC   ;3

; move HMOVE after WSYNC? -- um, yes
       STA    HMOVE   ;3 DON'T FORGET TO HIT HMOVE!! or the object won't move
	   				  ;  horizontally.  I might have forgotten that for a while,
					  ;  causing nearly unbearable psychological pain.

	   
       STA    VBLANK  ;3
       LDA    #$02    ;2
       STA    CTRLPF  ;3
       LDX    #$01    ;2


LF08E: STA    WSYNC   ;3 
       INX            ;2 	Increase the line counter
       BEQ    LF0B7   ;2


       CPX    $80     ;3	Are we on the line where the missle should be drawn?
       BEQ    LF09A   ;2	If so, jump down to "Turn the missile on"
       JMP    LF08E   ;3	Else jump back to this loop



; "Turn the missile on"
LF09A: LDA    #$02    ;2
       STA    ENAM0   ;3 Turn the missile on by putting %00000010 into ENAM0
       STA    WSYNC   ;3 
       INX            ;2
       CPX    #$C1    ;2	Are we at the last scan line we're going to display?
       BEQ    LF0B7   ;2	If so, jump on down
       STA    WSYNC   ;3	Else just keep going to the next line and loop
       INX            ;2	increase line counter
       CPX    #$C1    ;2	Same deal.  Two scan line missile
       BEQ    LF0B7   ;2
       LDA    #$00    ;2
       STA    ENAM0   ;3 Turn it off by putting zero into ENAM0.  Here, the missile
       STA    WSYNC   ;3 is two scans tall.  Cute little bugger.

LF0B2: INX            ;2
       CPX    #$C1    ;2
       STA WSYNC	;3 looks like I was missing this line
       BNE    LF0B2   ;2



; Clean everything out and skip on out of the

LF0B7: LDA    #$02    ;2
       STA    WSYNC   ;3
       STA    VBLANK  ;3
       LDY    #$00    ;2
       STY    PF0     ;3
       STY    PF1     ;3
       STY    PF1     ;3
       STY    GRP0    ;3
       STY    GRP1    ;3
       STY    ENAM0   ;3
       STY    ENAM1   ;3
       STY    ENABL   ;3
       RTS            ;6

LF0D0: LDX    #$1E    ;2
LF0D2: STA    WSYNC   ;3
       DEX            ;2
       BNE    LF0D2   ;2
       RTS            ;6

LF0D8: LDA    #$00    ;2
       STA    $90     ;3
       RTS            ;6

        org $FFFC
        .word START
        .word START