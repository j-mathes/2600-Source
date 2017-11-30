ff; boing! Demo for Atari 2600
; (No, not Boing the Q-bert ripoff)
; Started 29 November 1999
; by Rob Kudla
; http://www.kudla.org/raindog/games
;
; First release, 1 December 1999
; Second release, 2 December 1999 (made color cycling slightly less lame)
; Third release, 3 December 1999 (doubled the anim frames to make it smoother)
; Fourth release, 4 December 1999 (added hilarious "4 voice sound" routine)
; Fifth release, 29 December 1999 (fixed bug that could have caused TV's to roll
;                                  and also left a dead black area at the bottom)

; Sixth release, 03 July 2003 (modified bouncing and double height) - DCG

;
; The important parts of this (the big sprite routines, 
; the init, etc) are from bigmove.a65 by Eckhard Stolberg.
; Then I guess he adapted the funky 6-digit score routines from somewhere else.
; I basically made the object bigger and animated it, added a little 
; sound, ripped out the joystick functions, and stroked my own ego.
; - RK



        processor 6502

; TIA (Stella) write-only registers
;
Vsync		equ	$00
Vblank		equ	$01
Wsync		equ	$02
Rsync		equ	$03
Nusiz0		equ	$04
Nusiz1		equ	$05
ColuP0          equ     $06
ColuP1          equ     $07
Colupf		equ	$08
ColuBK          equ     $09
Ctrlpf		equ	$0A
Refp0		equ	$0B
Refp1		equ	$0C
Pf0             equ     $0D
Pf1             equ     $0E
Pf2             equ     $0F
RESP0           equ     $10
RESP1           equ     $11
Resm0		equ	$12
Resm1		equ	$13
Resbl		equ	$14
Audc0		equ	$15
Audc1		equ	$16
Audf0		equ	$17
Audf1		equ	$18
Audv0		equ	$19
Audv1		equ	$1A
GRP0            equ     $1B
GRP1            equ     $1C
Enam0		equ	$1D
Enam1		equ	$1E
Enabl		equ	$1F
HMP0            equ     $20
HMP1            equ     $21
Hmm0		equ	$22
Hmm1		equ	$23
Hmbl		equ	$24
VdelP0          equ     $25
VdelP1          equ     $26
Vdelbl		equ	$27
Resmp0		equ	$28
Resmp1		equ	$29
HMOVE           equ     $2A
Hmclr		equ	$2B
Cxclr		equ	$2C
;
; TIA (Stella) read-only registers
;
Cxm0p		equ	$00
Cxm1p		equ	$01
Cxp0fb		equ	$02
Cxp1fb		equ	$03
Cxm0fb		equ	$04
Cxm1fb		equ	$05
Cxblpf		equ	$06
Cxppmm		equ	$07
Inpt0		equ	$08
Inpt1		equ	$09
Inpt2		equ	$0A
Inpt3		equ	$0B
Inpt4		equ	$0C
Inpt5		equ	$0D
;
; RAM definitions
; Note: The system RAM maps in at 0080-00FF and also at 0180-01FF. It is
; used for variables and the system stack. The programmer must make sure
; the stack never grows so deep as to overwrite the variables.
;
RamStart	equ	$0080
RamEnd		equ	$00FF
StackBottom	equ	$00FF
StackTop	equ	$0080
;
; 6532 (RIOT) registers
;
SWCHA           equ     $0280
Swacnt		equ	$0281
SWCHB		equ	$0282
Swbcnt		equ	$0283
Intim		equ	$0284
Tim1t		equ	$0294
Tim8t		equ	$0295
Tim64t		equ	$0296
T1024t		equ	$0297
;
; ROM definitions
;
RomStart        equ     $F000
RomEnd          equ     $FFFF
IntVectors      equ     $FFFA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

s1              EQU     $80
s2              EQU     $82
s3              EQU     $84
s4              EQU     $86
s5              EQU     $88
s6              EQU     $8A
DelayPTR        EQU     $8C
LoopCount       EQU     $8E
TopDelay        EQU     $8F
BottomDelay     EQU     $90
MoveCount       EQU     $91
Temp            EQU     $92
RotateDir       EQU     $93
SkipFrame       EQU     $94
VerticalDir     EQU     $95
HorizontalDir   EQU     $96
VerticalPos     EQU     $97
HorizontalPos   EQU     $98
SoundQ          EQU     $99
SkipMove        EQU     $9a
FrameCycle	EQU	$9b
SpeedLo         EQU     $9c
SpeedHi         EQU     $9d
Frame		EQU	$9e

SHEIGHT		equ	90
LINEC		equ	100

		org	$0000
                rorg	$F000

Cart_Init:
		SEI			; Disable interrupts.:
		CLD			; Clear "decimal" mode.

;		LDX	#$FF
;		TXS			; Clear the stack
                BIT	$1FF9		; Bank 0

Common_Init:
		LDX	#$28		; Clear the TIA registers ($04-$2C)
		LDA	#$00
TIAClear:
		STA	$04,X
		DEX
                BPL     TIAClear        ; loop exits with X=$FF

		TXS				; Reset the stack
	
;		LDX	#$FF
RAMClear:
		STA	$00,X		; Clear the RAM ($FF-$80)
		DEX
                BMI     RAMClear        ; loop exits with X=$7F
	
;		LDX	#$FF
 
IOClear:
		STA	Swbcnt		; console I/O always set to INPUT
		STA	Swacnt		; set controller I/O to INPUT

DemoInit:       LDA     #$01
                STA     VdelP0
                STA     VdelP1
                LDA     #$03
                STA     Nusiz0
                STA     Nusiz1
                LDA     #$36      ; a nice shade of red
                STA     ColuP0
                STA     ColuP1

                LDY     #$f4      ; page to get gfx from initially
                STY     s1+1
                STY     s2+1
                INY
                STY     s3+1
                STY     s4+1
                INY
                STY     s5+1
                STY     s6+1

;                LDA     #0        ; offset in the gfx data
;                STA     s1
                LDA     #90       ; offset in the gfx data
                STA     s2
;                LDA     #00      ; offset in the gfx data
;                STA     s3
;                LDA     #90      ; offset in the gfx data
                STA     s4
;                LDA     #00      ; offset in the gfx data
;                STA     s5
;                LDA     #90        ;
                STA     s6

                LDA     #1	; +1 or -1, rotating the ball
                STA     RotateDir
                STA     HorizontalDir
                STA     SoundQ    ; Start out by making a noise
                STA     SkipFrame
                STA     SkipMove

;                LDA     #0
;                STA     TopDelay
;                STA     MoveCount
;                STA     SpeedLo
;                STA     SpeedHi

                LDA     #LINEC		; 140 - 50 = 90
                STA     BottomDelay

                LDA     #8
                STA     VerticalPos


                LDA     #$f2
                STA     DelayPTR+1
                LDA     #$1d+36 ;?????
                STA     DelayPTR
                STA     Wsync
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                STA     RESP0
                STA     RESP1
                LDA     #$50    ;?????
                STA     HMP1
                LDA     #$40    ;?????
                STA     HMP0
                STA     Wsync
                STA     HMOVE
                STA     Wsync
                LDA     #$0f
                STA     ColuBK
                

NewScreen:
                LDA     #$02
		STA	Wsync		; Wait for horizontal sync
		STA	Vblank		; Turn on Vblank
                STA	Vsync		; Turn on Vsync
		STA	Wsync		; Leave Vsync on for 3 lines
		STA	Wsync
		STA	Wsync
                LDA     #$00
		STA	Vsync		; Turn Vsync off

                LDA     #43             ; Vblank for 37 lines
                                        ; changed from 43 to 53 for 45 lines PAL
		STA	Tim64t		; 43*64intvls=2752=8256colclks=36.2lines

                JSR     DoSound         ; was too big to leave inline :P
                INC	FrameCycle
                
                DEC     SkipFrame
                BNE     Movement        ; skip the animation most of the time
                LDA     #3              ; number of frames to skip
                STA     SkipFrame       ; if it's zero, reset it

                LDA     RotateDir       ; which direction to rotate it in?
		CLC
                ADC	Frame
		BPL	.low
                LDA	#6
.low		CMP	#7
		BCC	.low1
                LDA	#0
.low1  		STA	Frame

		CMP 	#4
                BCC	.b1
            	BIT	$1FF9
                SBC	#4
                BCS	.b2
.b1		BIT	$1FF8
.b2		TAX
		LDY	AnimPtr,X
                
                STY	s1+1
                STY	s2+1

		INY
                STY	s3+1
                STY	s4+1

		INY
                STY	s5+1
                STY	s6+1

Movement:	LDA     SkipMove
                INC     SkipMove
                AND     #1              ; basically i lamed out and said 
                BNE     MoveHorizontal  ; "skip every other frame"
		JMP     VblankLoop

MoveHorizontal: LDA     HorizontalPos   ; i couldn't figure out how to use HMOVE 
                CLC                     ; without blowing up yet, so let's glom 
                ADC     HorizontalDir   ; onto the joystick routines
                STA     HorizontalPos
                LDA     HorizontalDir
                CMP     #0
                BMI     GoLeft

GoRight:        JSR     Right
                LDA     HorizontalPos
                CMP     #112            ; i also haven't figured out how to make the
                BNE     MoveVertical    ; sprite go all the way to the right edge!
                LDA     HorizontalDir   ; since we're not using the 6th copy
                LDA     #$FF
                STA     HorizontalDir
		LDA     #1              ; if we're reversing direction, we've hit a wall
                STA     SoundQ          ; so make a sound
                LDA     RotateDir
                EOR     #$FE
                STA     RotateDir       ; and change 1 into -1 (255)
                JMP     MoveVertical

GoLeft:         JSR     Left
                LDA     HorizontalPos
                CMP     #1
                BNE     MoveVertical
                LDA     #$01
                STA     HorizontalDir
                STA     SoundQ
                LDA     RotateDir
                EOR     #$FE
                STA     RotateDir

MoveVertical:   LDA     SpeedLo
                CLC
                ADC     #$50			; gravity constant
                STA     SpeedLo

                LDA     SpeedHi
                ADC     #0
                STA     SpeedHi

		LDA     SpeedLo
                CLC
                ADC     #$80			; 0.5 Bias
                LDA     VerticalPos
                ADC     SpeedHi

		; (140 - 50 = 90)  DCG
                CMP     #LINEC			; kind of a rough approximation, yeah.
                BCC     CalcDelays

Bounce:         
		LDA     SpeedLo			; flip dir
                EOR     #$FF
                STA     SpeedLo
                LDA     SpeedHi
                EOR     #$FF
                STA     SpeedHi

                LDA     #1
                STA     SoundQ

                LDA     VerticalPos		; throw away invalid VerticalPos value by reloading

CalcDelays:
                STA     VerticalPos
                STA     TopDelay
                LDA     #LINEC			; 140 - 50 = 90
                SEC
                SBC     VerticalPos
                STA     BottomDelay

                JMP     VblankLoop
                                

Right:          LDX     MoveCount
                INX 
                STX     MoveCount
                CPX     #3
                BNE     R2
                LDX     DelayPTR
                DEX
                STX     DelayPTR
                CPX     #$1c ;?????
                BNE     R1
                LDA     #$1d ;?????
                STA     DelayPTR
                LDA     #2
                STA     MoveCount
                RTS; was JMP     VblankLoop
R1:             LDA     #0
                STA     MoveCount
R2:             LDA     #$f0
                STA     HMP0
                STA     HMP1
                STA     Wsync
                STA     HMOVE
                RTS; was JMP     VblankLoop

Left:           LDX     MoveCount
                DEX
                STX     MoveCount
                CPX     #$ff
                BNE     L2
                LDX     DelayPTR
                INX
                STX     DelayPTR
                CPX     #$1d+37 ; indexing into a code segment with a literal - naughty
                BNE     L1
                LDA     #$1d+36 ; indexing into a code segment with a literal - naughty
                STA     DelayPTR
                LDA     #0
                STA     MoveCount
                RTS; was JMP     VblankLoop
L1:             LDA     #2
                STA     MoveCount
L2:             LDA     #$10
                STA     HMP0
                STA     HMP1
                STA     Wsync
                STA     HMOVE
                RTS; was JMP     VblankLoop

		org	$0200
                rorg	$F200
VblankLoop:
		LDA	Intim
		BNE	VblankLoop	; wait for vblank timer
		STA	Wsync		; finish waiting for the current line
		STA	Vblank		; Turn off Vblank

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ScreenStart:
                LDY     TopDelay
                INY     ;?????
X1:             STA     Wsync
                DEY
                BNE     X1
                LDY     #4 ;?????
X2:             DEY
                BPL     X2
                LDA     #SHEIGHT-1 ; 50 pixels high x 2 (doubled lines)
                STA     LoopCount
                JMP     (DelayPTR)
JNDelay:        .byte   $c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9
                .byte   $c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9
                .byte   $c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9
                .byte   $c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c5
                NOP
X3:             NOP
		LDY	LoopCount
                NOP			; double graphics vertical
                NOP
                LDA     (s1),Y
                STA     GRP0
                LDA     (s2),Y
                STA     GRP1
                LDA     (s3),Y
                STA     GRP0
                LDA     (s6),Y
                STA     Temp
                LDA     (s5),Y
                TAX
                LDA     (s4),Y
                LDY     Temp
                STA     GRP1
                STX     GRP0
                STY     GRP1
                STA     GRP0
                DEC     LoopCount
                BPL     X3
                LDA     #$00
                STA     GRP0
                STA     GRP1
                STA     GRP0
                STA     GRP1
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                LDY     BottomDelay
                INY     ;?????
X4:             STA     Wsync
                DEY
                BNE     X4
                LDA     #$02
                STA     Vblank
                STA     Wsync
                
                
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OverscanStart:  LDA     #37             ;skip 37 lines (overscan)
                                        ;(thanks to Eckhard for pointing out this issue)
                                        ;(this results in 222 lines, same as mspacman)
		STA	Tim64t

OverscanLoop:
		LDA	Intim
		BNE	OverscanLoop	; wait for Overscan timer

OverscanDone:	STA	Wsync		; finish waiting for the current line


                JMP     NewScreen
																						

; sound routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DoSound:	LDA     FrameCycle      ; so we can skip every 3, 7 or 15 frames
                AND     #$03            ; let's try 15
                BNE     EndSound
                LDA     SoundQ          ; is there sound to be played?
                CMP     #0
                BEQ     EndSound        ; no? how sad.
                TAY
                CPY     #1              ; if it's note #1 we can't do the cheezy echo.
                BEQ     DoVoice1
                DEY
DoVoice2:       LDA     SoundFData,Y    ; basically you just set SoundQ to an
                STA     Audf1           ; offset and put frequency, control and
                LDA     SoundCData,Y    ; volume data in the data segment below
                STA     Audc1           ; with zero termination.  I was gonna do
                LDA     SoundVData,Y    ; a channel multiplexing music thing 
                                        ; but I'm too lame.
                LSR                     ; Divide volume in half for the cheezy echo
                STA     Audv1
                INY
DoVoice1:       LDA     SoundFData,Y    ; see above
                STA     Audf0
                LDA     SoundCData,Y
                STA     Audc0
                LDA     SoundVData,Y
                STA     Audv0
                CMP     #0
                BNE     NextNote        ; if it's not zero there's more
                STA     Audf0
                STA     Audc0
                STA     Audv1
                STA     SoundQ          ; otherwise we turn off the sound and empty the Q
                RTS
NextNote:       INC     SoundQ
EndSound:       RTS

; sound data (bounce noise)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SoundFData: .byte $1f,$19,$1a,$1b,$1c,$1d,$1e,$1f
SoundCData: .byte $07,$06,$06,$06,$06,$06,$06,$06
SoundVData: .byte $0f,$0b,$0a,$08,$06,$04,$02,$00

AnimPtr	.byte $F4,$F7,$FA,$FD
		
                org $03ff
                .byte $ff
