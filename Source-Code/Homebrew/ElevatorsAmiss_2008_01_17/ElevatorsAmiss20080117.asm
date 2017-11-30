;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
;         Elevators Amiss
;         2007
;         Bob Montgomery
;
;
;
;
;   To Do:
;      -DONE: add maid animation
;      -DONE: change end-of-level bonus (and make it happen before level is increased)
;      -DONE: add level display at *bottom* of screen
;      -CANCELLED: add game title to top of screen - looked bad.  instead:
;      -DONE: add copyright to bottom of screen
;      -DONE: (for NTSC): Fix scanline count (270 for NTSC, 300 for PAL)
;      -DONE: give each line of text a unique color
;      -CANCELLED: add extra measure to gameplay tune - ran out of room.
;      -PROBABLY CANCELLED: polish music - ran out of room.
;      -DONE: finalize all colors
;      -gameplay tweaking
;      -DONE: add SaveKey/high score support (requires testing)
;      -PROBABLY CANCELLED: add ability to erase SaveKey high scores (by holding down RESET on poweron) - ran out of room
;
;
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------

   processor 6502
   include vcs.h
   include macro.h
   include i2c_v2.2.inc

;-------------------------Constants Below---------------------------------


;----------------------Compile  Flags-------------------------------------

NTSC = 0				;0 for PAL60 (no support for PAL50.  Well, sort of.  See below.)
TEST	=	0			;right now, just makes screen 312 lines tall by making Vblank longer - helps
						;		emulators autodetect PAL colors for easier testing.

STARTINGLEVEL   =   $01     ;set to > 1 for testing.

STARTINGLIVES	=	$09		;default is $09


;-------------------------------------------------------------------------

AUTOMOVEMENT_UPDATE_FREQ   =   3   ;how often (in frames) the hero moves automagically.  ANDed with FrameCounter.

MAID_VELOCITY      =      70
BOOST_VELOCITY      =      MAID_VELOCITY*3/2

ELEV_HEIGHT         =      9
MAID_HEIGHT         =      17      ;double since 2-line kernel...too much to explain,
                           ;   just look in the kernel.
PLAYAREAHEIGHT      =      80

NUM_RAMBANDS   =   13



NUM_ELEVATORS   = 7

SAVEKEYADDRESS	=		$0300		;confirm with Richard H.  Confirmed!

;--color constants--------------------------

	IF NTSC
APRONCOLOR      =   GRAY+14
MAIDFACECOLOR   =   BROWN+10

FLOOR1COLOR      =   BLUE2+10
FLOOR2COLOR      =   TURQUOISE+10
FLOOR3COLOR      =   BLUE2+10
FLOOR4COLOR      =   LIGHTBLUE+10
FLOOR5COLOR      =   TURQUOISE+10
FLOOR6COLOR      =   BLUE2+10
FLOOR7COLOR      =   LIGHTBLUE+10
FLOOR8COLOR      =   TURQUOISE+10

TOPOFHOTELCOLOR      =      GRAY+12      ;border on top and bottom of play area
BOTTOMOFHOTELCOLOR   =      GRAY+12

TEXTCOLOR         =      GRAY+14

TEXTCOLOR1		=		GRAY+12
TEXTCOLOR2		=		GRAY+14
TEXTCOLOR3		=		GRAY+12

ELEVCOLOR_LVL0      =      GRAY+12
ELEVCOLOR_LVL1      =      GRAY+14
ELEVCOLOR_LVL2      =      RED+14
ELEVCOLOR_LVL3      =      GRAY+2
ELEVCOLOR_LVL4      =      TURQUOISE+14
ELEVCOLOR_LVL5      =      GOLD+2
ELEVCOLOR_LVL6      =      LIGHTBLUE+8
ELEVCOLOR_LVL7      =      BLUE2+2
ELEVCOLOR_LVL8      =      BROWN+0
ELEVCOLOR_LVL9      =      GOLD+14


      ;--these values are EORed with the original background colors.  The bottom bit must be clear!
BGCOLOR_LVL0      =      $AC         ;original colors (yellow/tan)
BGCOLOR_LVL1      =      $8C
BGCOLOR_LVL2      =      $08         ;
BGCOLOR_LVL3      =      $B8
BGCOLOR_LVL4      =      $38
BGCOLOR_LVL5      =      $60
BGCOLOR_LVL6      =      $98
BGCOLOR_LVL7      =      $24
BGCOLOR_LVL8      =      $C8
BGCOLOR_LVL9      =      $50
	ELSE
APRONCOLOR      =   GRAY+14
MAIDFACECOLOR   =   $28			;BROWN+10



	;--these are plugged directly into COLUPF
ELEVCOLOR_LVL0      =      GRAY+12
ELEVCOLOR_LVL1      =      GRAY+14
ELEVCOLOR_LVL2      =      $6E		;RED+14
ELEVCOLOR_LVL3      =      GRAY+2
ELEVCOLOR_LVL4      =      $7E		;TURQUOISE+14
ELEVCOLOR_LVL5      =      $20		;GOLD+2
ELEVCOLOR_LVL6      =      $9E		;LIGHTBLUE+8
ELEVCOLOR_LVL7      =      $D2		;BLUE2+2
ELEVCOLOR_LVL8      =      $2E		;BROWN+0
ELEVCOLOR_LVL9      =      GRAY+4	;GOLD+14

	;--these are EORed with the values below to get different colors for each level
PALCOLOR1		=	$BA
PALCOLOR2		=	$CA
PALCOLOR3		=	$DA
FLOOR1COLOR      =   PALCOLOR1	;BLUE2+10
FLOOR2COLOR      =   PALCOLOR2	;TURQUOISE+10
FLOOR3COLOR      =   PALCOLOR1	;BLUE2+10
FLOOR4COLOR      =   PALCOLOR3	;LIGHTBLUE+10
FLOOR5COLOR      =   PALCOLOR2	;TURQUOISE+10
FLOOR6COLOR      =   PALCOLOR1	;BLUE2+10
FLOOR7COLOR      =   PALCOLOR3	;LIGHTBLUE+10
FLOOR8COLOR      =   PALCOLOR2	;TURQUOISE+10

      ;--these values are EORed with the original floor colors.  The bottom bit must be clear!
		;							transformed colors will be
BGCOLOR_LVL0      =      $FC	
BGCOLOR_LVL1      =      $EC	
BGCOLOR_LVL2      =      $0C	
BGCOLOR_LVL3      =      $80	
BGCOLOR_LVL4      =      $60	
BGCOLOR_LVL5      =      $9C	
BGCOLOR_LVL6      =      $BC		
BGCOLOR_LVL7      =      $00	
BGCOLOR_LVL8      =      $8C	
BGCOLOR_LVL9      =      $E0	


TOPOFHOTELCOLOR      =      GRAY+12      ;border on top and bottom of play area
BOTTOMOFHOTELCOLOR   =      GRAY+12

TEXTCOLOR         =      GRAY+14

TEXTCOLOR1		=		GRAY+12
TEXTCOLOR2		=		GRAY+14
TEXTCOLOR3		=		GRAY+12
	ENDIF




;--end color constants--------------------------

;--HeroAutoMovement bits

BETWEENFLOOR_AUTOMOVEMENT_LENGTH      =      16
COMPLETELEVEL_AUTOMOVEMENT_LENGTH      =      33
DEATH_AUTOMOVEMENT_LENGTH            =      60
BETWEENFLOORL_AUTOMOVEMENT            =   %00000000
BETWEENFLOORR_AUTOMOVEMENT            =   %01000000
COMPLETELEVEL_AUTOMOVEMENT            =   %10000000
DEATH_AUTOMOVEMENT                  =   %11000000
AUTOMOVEMENT_BITS                  =   %11000000

;--GameFlags bits

GAMEON_BIT      =      %00000001
GAMEDIFF_BITS   =      %00000110
GAMEDIFF_LOBIT   =      %00000010
DEBOUNCE_BIT   =      %00001000
MAIDDIR_BIT      =      %00010000      ;direction maid is facing (0=left, 1=right)
MAIDMOVE_BIT   =      %00100000      ;is maid moving?
SONG_BITS      =      %11000000      ;which song is playing

;--GameFlags values

DIFF_CHILD      =      %00000000
DIFF_NOVICE      =      %00000010
DIFF_NORMAL      =      %00000100
DIFF_EXPERT      =      %00000110
SONG_SILENCE      =      %00000000
SONG_GAMEPLAY      =      %01000000
SONG_LEVELCOMPLETE   =      %10000000
SONG_DEATH         =      %11000000

;--GameFlags2 bits


MUSICON_BIT         =   %10000000
CONSOLETYPE_BIT      =  %01000000
PAUSESTATE_BIT      =   %00100000      ;only used when 7800
MAIDFRAME_BIT      =    %00010000      ;used to switch between animations
SFXCOUNTER_BITS      =  %00001111

;--GameFlags2 values

CONSOLE7800         =   %01000000

;--GameFlags3 bits

TICK_BIT         =   %00000001
;other bits used during kernel.

;--SaveKeyFlags bits

CHECKHISCORE_BIT	=	%10000000
SAVEKEYSTEP_BITS	=	%00111111


;--SaveKeyFlags values



; automovement flags:
HORZ_NON = %00
HORZ_POS = %01
HORZ_NEG = %11
VERT_NON = %00 << 6
VERT_POS = %10 << 6
VERT_NEG = %11 << 6


;--sound effect type values

SFXCOUNTER_FLOOR_COMPLETE   =   11         ;max is 15

TICK_DIST      =      3
TICK_FREQ      =      31
TICK_VOL      =      5

    ;--MUSIC CONSTANTS FOLLOW:

SLUR_BIT   =   %10000000
LENGTH_BITS   =   %01100000
NOTE_BITS   =   %00011111

RESTFLAG   =   0

TEMPO112    =      %00000011   ;112.5 BPM


SLUR         =      %10000000
VOLUMECHANGE   =      %00000000
INDEXCHANGE      =      %00010000

THIRTYSECOND   =      %00000000
SIXTEENTH      =      %00100000
EIGHTH         =      %01000000
QUARTER         =      %01100000


V0      =   %00000000
V1      =   %00000001
V2      =   %00000010
V3      =   %00000011
V4      =   %00000100
V5      =   %00000101
V6      =   %00000110
V7      =   %00000111
V8      =   %00001000
V9      =   %00001001
V10     =   %00001010
V11     =   %00001011
V12     =   %00001100
V13     =   %00001101
V14     =   %00001110
V15     =   %00001111

;-------------------------COLOR CONSTANTS (NTSC)--------------------------

GRAY      =   $00
GOLD      =   $10
ORANGE      =   $20
BURNTORANGE   =   $30
RED         =   $40
PURPLE      =   $50
PURPLEBLUE   =   $60
BLUE      =   $70
BLUE2      =   $80
LIGHTBLUE   =   $90
TURQUOISE   =   $A0
GREEN      =   $B0
BROWNGREEN   =   $C0
TANGREEN   =   $D0
TAN         =   $E0
BROWN      =   $F0

;--------------------------TIA CONSTANTS----------------------------------

   ;--NUSIZx CONSTANTS
   ;   player:
ONECOPYNORMAL      =   $00
TWOCOPIESCLOSE      =   $01
TWOCOPIESMED      =   $02
THREECOPIESCLOSE   =   $03
TWOCOPIESWIDE      =   $04
ONECOPYDOUBLE      =   $05
THREECOPIESMED      =   $06
ONECOPYQUAD      =   $07
   ;   missile:
SINGLEWIDTHMISSILE   =   $00
DOUBLEWIDTHMISSILE   =   $10
QUADWIDTHMISSILE   =   $20
OCTWIDTHMISSILE      =   $30

   ;---CTRLPF CONSTANTS
   ;   playfield:
REFLECTEDPF      =   %00000001
SCOREPF         =   %00000010
PRIORITYPF      =   %00000100
   ;   ball:
SINGLEWIDTHBALL      =   SINGLEWIDTHMISSILE
DOUBLEWIDTHBALL      =   DOUBLEWIDTHMISSILE
QUADWIDTHBALL      =   QUADWIDTHMISSILE
OCTWIDTHBALL      =   OCTWIDTHMISSILE

   ;---HMxx CONSTANTS
LEFTSEVEN      =   $70
LEFTSIX         =   $60
LEFTFIVE      =   $50
LEFTFOUR      =   $40
LEFTTHREE      =   $30
LEFTTWO         =   $20
LEFTONE         =   $10
NOMOVEMENT      =   $00
RIGHTONE      =   $F0
RIGHTTWO      =   $E0
RIGHTTHREE      =   $D0
RIGHTFOUR      =   $C0
RIGHTFIVE      =   $B0
RIGHTSIX      =   $A0
RIGHTSEVEN      =   $90
RIGHTEIGHT      =   $80

   ;---AUDCx CONSTANTS (P Slocum's naming convention)
SAWSOUND      =   1
ENGINESOUND      =   3
SQUARESOUND      =   4
BASSSOUND      =   6
PITFALLSOUND   =   7
NOISESOUND      =   8
LEADSOUND      =   12
BUZZSOUND      =   15

   ;---SWCHA CONSTANTS (JOYSTICK)
J0RIGHT      =   %10000000
J0LEFT      =   %01000000
J0DOWN      =   %00100000
J0UP      =   %00010000
J1RIGHT      =   %00001000
J1LEFT      =   %00000100
J1DOWN      =   %00000010
J1UP      =   %00000001

   ;---SWCHB CONSTANTS (CONSOLE SWITCHES)
P1DIFF      =   %10000000
P0DIFF      =   %01000000
BWCOLOR      =   %00001000
SELECT      =   %00000010
RESET      =   %00000001


;TODO:
; use constants for 16 and 136 (Hero positions)
; positions Hero one pixel further away from elevator (personal opinion)

;-------------------------End Constants-----------------------------------

;---Macros

  MAC CHECKPAGE
    IF >. != >{1}
      ECHO ""
      ECHO "ERROR: different pages! (", {1}, ",", ., ")"
      ECHO ""
      ERR
    ENDIF
  ENDM



;--------Variables To Follow-------------

   SEG.U Variables
      org $80

FrameCounter ds 1
RandomNumber ds 1

initLst = .
Score ds 3               ;bcd
Timer ds 1               ;bcd
HeroMovementCounter ds 1   ;used for automatic movement (upon completing floor, completing level, and dying)
Lives ds 1               ;only using bottom nibble here (0-9).

Level ds 1               ;bcd 1-99

HeroY ds 1
HeroX ds 1
NUM_INITS = . - initLst

HeroXfract ds 1

GameFlags ds 1
GameFlags2 ds 1
GameFlags3 ds 1

   ;--used in kernel:
HeroTop0 ds 1
HeroBottom0 ds 1
MaidLineCounter2 ds 1

HeroGfx0Ptra ds 2
HeroGfx0Ptrb ds 2
HeroGfx1Ptra ds 2
HeroGfx1Ptrb ds 2
HeroColorPtra ds 2
   ;--end used in kernel



ElevRAM ds NUM_RAMBANDS*4
ElevBandHeight ds NUM_RAMBANDS

ElevY ds 7
ElevVel ds 7

            ;plan is for top...two?  bits to be sound index, bottom 6 bits
                        ;are counter.

   ;--music vars
SongIndexC0 ds 1
SongIndexC1 ds 1
LengthVolumeC0 ds 1
LengthVolumeC1 ds 1



MiscPtr ds 5
Temp ds 8

   ; Display Remaining RAM
   echo "----",($100 - *) , "bytes left (ZP RAM)"

   org SongIndexC0
HighScore ds 3
SaveKeyFlags ds 1


   org Temp+2
AUDVTemp
AUDCTemp ds 2
AUDFTemp ds 2
NoteData ds 2

;---End Variables

   seg Bank0

   org $F000

FREE SET 0

;----------------------------------------------------------------------------
;-------------------VBLANK Routine-------------------------------------------
;----------------------------------------------------------------------------
VBLANKRoutine
   lda #%00000111
VSYNCWaitLoop
   sta WSYNC
   sta VSYNC
   lsr
   bcs VSYNCWaitLoop
	IF TEST
	lda #93
	ELSE
   lda #43
	ENDIF
   sta TIM64T

   jsr UpdateTimersSubroutine

   jsr SetElevRAMSubroutine

WaitForVblankEnd
   ldx INTIM
   bne WaitForVblankEnd



;----------------------------------------------------------------------------
;----------------------Kernel Routine----------------------------------------
;----------------------------------------------------------------------------

KernelRoutineGame

   ;--top of screen stuff
   stx HMCLR
   sta WSYNC
   stx HMOVE
   stx VBLANK
   stx CXCLR                   ;clear collisions
   lda #OCTWIDTHMISSILE        ;A=#$30
   sta NUSIZ0
;   lda #$30
   sta PF0
   lda #TOPOFHOTELCOLOR        ;A==GRAY+12 == #$0C
   sta COLUBK
   lsr                         ;A=#$06
   sta ENAM0
;   ldx #GRAY+0
   stx COLUP0                  ;X==0 (see above)
   lsr                         ;A=#$03
   sta VDELP1
   sta ENABL

   sta WSYNC
   sta HMOVE
   sta WSYNC
   sta HMOVE,X                 ;+4       4      X==0.  not too late, I hope. ;)


   lda BackgroundColorTable+75
   eor GameFlags3
   sta COLUBK,X                ;+11     15      Y==0
   ldx.w Temp                  ;+4      19
   ;--waste time efficiently
   jsr Waste20CyclesSubroutine
   jsr Waste20CyclesSubroutine ;+40     59

   lda Temp+1                  ;            (Y==0)  if this is non-zero then we go to the special case kernel
   beq NoSpecialCaseKernel     ;+6      65
                               ;        64
   bne SpecialCaseKernel1      ;+3      67      branch always
NoSpecialCaseKernel
   jmp MainKernel              ;+3      68

   ;--special case kernel with no elevators, very top.

WaitDraw1SC1                       ;        61
   nop
   bne BackFromSwitchDraw1SC1Jump  ;+3      66

SwitchDraw1SC1                 ;        54
   SLEEP 4                     ;+4      58
   bne WaitDraw1SC1            ;+2      60
   lda HeroBottom0
   sta HeroTop0                ;+6      66
BackFromSwitchDraw1SC1Jump
   jmp BackFromSwitchDraw1SC1  ;+3      69

WaitDraw3SC1                   ;         1
   SLEEP 4                     ;+4       5
   bpl BackFromSwitchDraw3SC1  ;+3       8

NoSpritesKernelSC1             ;        53
   jmp NoSpritesKernelSC1Subroutine

SpecialCaseKernel1             ;        67
   SLEEP 3
   ldy #PLAYAREAHEIGHT         ;+2      72

KernelLoopOuterSC1             ;        72
   SLEEP 4                     ;+4      76
KernelLoopInnerSC1             ;        76
   sta HMOVE                   ;+3       3

   lda #MAID_HEIGHT
   dcp MaidLineCounter2
   bcs DoDraw2SC1
   lda #0
   .byte $2C
DoDraw2SC1
   lda (HeroGfx1Ptra),Y
   sta GRP0                    ;+18     21

   ;--waste time efficiently
   jsr Return                  ;+12     33
BackFromNoSpritesKernelSC1     ;        33

   lda BackgroundColorTable-1,Y
   eor GameFlags3
   pha                         ;+10     43      I think I have a byte of stack to work with here

   lda StairCaseTable,Y
   sta HMBL              
   beq NoSpritesKernelSC1      ;+9      52


   cpy HeroTop0
   bpl SwitchDraw1SC1
   lda (HeroGfx0Ptra),Y
   sta GRP1                    ;            VDEL
   lda (HeroColorPtra),Y
   sta COLUP1                  ;+21     73      too early?  doesn't seem to be...
BackFromSwitchDraw1SC1


   sta HMOVE                   ;+3      76

   pla
   sta COLUBK                  ;+7       7

   ;--can't use SwitchDraw for P0 since P1 is VDELed - have to
   ;   use DoDraw, which draws *something* every line.
   lda #MAID_HEIGHT
   dcp MaidLineCounter2
   bcs DoDraw1SC1
   lda #0
   .byte $2C
DoDraw1SC1
   lda (HeroGfx1Ptrb),Y
   sta GRP0                   ;+18      25   not too late, I don't think

   jsr Return
   lda ($80,X)                ;+18      43      waste time efficiently
   sta HMCLR                  ;+3       46


   cpy HeroTop0
   bpl WaitDraw3SC1
   lda (HeroGfx0Ptrb),Y
   sta GRP1                   ;               VDEL
BackFromSwitchDraw3SC1        ;+15      61

   nop
   ;--must use DoDraw here as well so that P1 is written to every line

   SLEEP 3
   dey
   cpy Temp+1
   bne KernelLoopOuterSC1     ;+11      72
                              ;         71
   nop                        ;+2       73
   jmp KernelLoopInner        ;+3       76


;----------------------------------------------------------------------------

PositionASpriteSubroutine153:
   lda #153
PositionASpriteSubroutine
   sec
   sta HMCLR
   sta WSYNC
DivideLoop          ;            this loop can't cross a page boundary!!!
   sbc #15
   bcs DivideLoop   ;+4       4
   eor #7
   asl
   asl
   asl
   asl              ;+10     14
   sta.wx HMP0,X    ;+5      19
   sta RESP0,X      ;+4      23
   sta WSYNC
   sta HMOVE
Return              ;label for cycle-burning code
   rts

;----------------------------------------------------------------------------

AutomovementHorPtr
   .byte <NextFloorMovementL
   .byte <NextFloorMovementR
   .byte <CompleteBuildingMovement
   .byte <DeathMovement

StartEEPROMWriteSubroutine
	jsr i2c_startwrite
	beq NoEEPROMError
	;--EEPROM error!
	ldx #Score
	ldy #HighScore
	jsr CopyScoreLoopSubroutine
	lda #15
	sta SaveKeyFlags
NoEEPROMError
	rts

;----------------------------------------------------------------------------

Waste20CyclesSubroutine   ;trashes Accumulator
   lda ($80,X)         ;assumes reads from $00-$7F won't harm anything.
   nop
   rts               ;6 to get here, 6 to return, plus 8 = 20 cycles

;----------------------------------------------------------------------------


   ;---about 1 free bytes here

FREE set FREE - .
   align 256
FREE set FREE + .

   ;--main kernel

WaitDraw1                      ;        59
   nop                         ;+2
   bne WaitSomeMore1           ;+3      64      branch always

SwitchDraw1                    ;        57
   bne WaitDraw1               ;+2      59
   lda HeroBottom0
   sta HeroTop0                ;+6      65
WaitSomeMore1
   dcp MaidLineCounter2        ;+5      70
   nop
   nop                         ;+4      74
   sta HMOVE				   ;+3		 1		
   jmp BackFromSwitchDraw1     ;+3       4      branch always

WaitDraw3                    ;        75
   SLEEP 3
   nop
   bpl BackFromSwitchDraw3     ;+8             branch always

NoSpritesKernelMain           ;         50
   jmp NoSpritesKernelMainSubroutine

NoDraw1                        ;        17
	lda #0
	sta GRP0
	sta.w PF1
	beq BackFromNoDraw1        ;+12     29

MainKernel
   nop
   ldy #PLAYAREAHEIGHT         ;+2      72

KernelLoopOuter                ;        72
   SLEEP 4                     ;+4      76
KernelLoopInner                ;        76
   sta HMOVE                   ;+3       3

   lda #MAID_HEIGHT
   dcp MaidLineCounter2
   bcs DoDraw2
   lda #0
   .byte $2C
DoDraw2
   lda (HeroGfx1Ptra),Y
   sta GRP0                    ;+18     21

   lda ElevRAM,X
   sta PF1                     ;+7      28
   lda #0
   sta PF2                     ;+5      33
   lda ElevRAM+[NUM_RAMBANDS*3],X
   sta PF1                     ;+7      40
BackFromNoSpritesKernelMain

   lda StairCaseTable,Y
   sta HMBL                    ;+7      47
   beq NoSpritesKernelMain     ;+2      49


   lda #MAID_HEIGHT            ;+2      51
   cpy HeroTop0
   bpl SwitchDraw1             ;+5      56
   dcp MaidLineCounter2        ;+5      61
   lda (HeroGfx0Ptra),Y
   sta GRP1                    ;            VDEL
   lda (HeroColorPtra),Y
   sta HMOVE                   ;+16      1

   sta COLUP1                  ;+3       4      
BackFromSwitchDraw1


   lda GameFlags3
   eor BackgroundColorTable-1,Y
   sta COLUBK                  ;+10     14


   ;--can't use SwitchDraw for P1 since P0 is VDELed - have to
   ;   use DoDraw, which draws *something* every line.
;   lda #MAID_HEIGHT
;   dcp MaidLineCounter2
   bcc NoDraw1
   lda (HeroGfx1Ptrb),Y
   sta GRP0                    ;+10     24		too late?  No.

   lda #0
   sta PF1                     ;+5      29      too late?  Maybe.
BackFromNoDraw1

   lda ElevRAM+NUM_RAMBANDS,X
   sta PF2                     ;+7      36

   sta.w HMCLR
   lda ElevRAM+[NUM_RAMBANDS*2],X

   cpy HeroTop0

   sta PF2                     ;+14     50

   bpl WaitDraw3
   lda (HeroGfx0Ptrb),Y
   sta.w GRP1                  ;            VDEL
BackFromSwitchDraw3            ;+11     61

;   nop

   dey
   tya
   cmp ElevBandHeight,X
   bne KernelLoopOuter         ;+11    (72)
   dex
   bpl KernelLoopInner         ;+5      76
                               ;        75
   sta HMOVE                   ;+3       2
   cpy #0
   bne NotDoneWithPlayAreaKernels   ;+5       7
                               ;         6
   beq DoneWithPlayAreaKernels ;+3       9   branch always

NoSpritesKernelSC2                    ;        53   
   jmp NoSpritesKernelSC2Subroutine

   ;--special case kernel with no elevators, very bottom

WaitDraw1SC2                   ;        57
   nop                         ;+2      59      waste cycles efficiently
   bne WaitSomeMore1SC2        ;+3      62      branch always

SwitchDraw1SC2                 ;        54
   bne WaitDraw1SC2            ;+2      56
   lda HeroBottom0
   sta HeroTop0                ;+6      62
WaitSomeMore1SC2
   nop
   sec                         ;+4      66
   bcs BackFromSwitchDraw1SC2  ;+3      69      branch always

WaitDraw3SC2                   ;         1
   SLEEP 4                     ;+4       5
   bpl BackFromSwitchDraw3SC2  ;+3       8      branch always






KernelLoopOuterSC2             ;        72
   SLEEP 4                     ;+4      76
KernelLoopInnerSC2             ;        76
   sta HMOVE                   ;+3       3
   SLEEP 4                     ;                     four free cycles
NotDoneWithPlayAreaKernels     ;         7
   lda #MAID_HEIGHT
   dcp MaidLineCounter2
   bcs DoDraw2SC2
   lda #0
   .byte $2C
DoDraw2SC2
   lda (HeroGfx1Ptra),Y
   sta GRP0                    ;+18     25

   lda #0
   sta PF2                     ;+5      30
BackIntoSCKernelFromNoSprites
   lda BackgroundColorTable-1,Y
   eor GameFlags3
   tax                         ;+9      39

   nop
   nop                         ;+4      43            4 free cycles

   lda StairCaseTable,Y
   sta HMBL                    ;+7      50
   beq NoSpritesKernelSC2      ;+2      52

   cpy HeroTop0
   bpl SwitchDraw1SC2
   lda (HeroGfx0Ptra),Y
   sta GRP1                    ;            VDEL
   lda (HeroColorPtra),Y
   sta COLUP1                  ;+21     73      
BackFromSwitchDraw1SC2

   sta HMOVE                   ;+3      76
   txa
   sta COLUBK                  ;+5       5

   ;--can't use SwitchDraw for P1 since P0 is VDELed - have to
   ;   use DoDraw, which draws *something* every line.
   lda #MAID_HEIGHT
   dcp MaidLineCounter2
   bcs DoDraw1SC2
   lda #0
   .byte $2C
DoDraw1SC2
   lda (HeroGfx1Ptrb),Y
   sta GRP0                    ;+18     23


   jsr Waste20CyclesSubroutine
   nop
   nop
   nop                         ;+26     49         ;26 free cycles

   sta HMCLR                   ;+3      52

   cpy HeroTop0
   bpl WaitDraw3SC2
   lda (HeroGfx0Ptrb),Y
   sta GRP1                    ;            VDEL
BackFromSwitchDraw3SC2         ;+15     67

   nop

   dey
   bne KernelLoopOuterSC2      ;+5      72      This is just barely on the same page as the target
                               ;            so if changes are made and the display is all messed up
                               ;            check this!
                               ;        71
   nop                         ;+2      73
   nop
   sta HMOVE                   ;+5       2


DoneWithPlayAreaKernels
   lda #BOTTOMOFHOTELCOLOR
   sta COLUBK
;   lda #0
   sty PF1               ;Y is zero following end of loop above
   sty PF2

   sta WSYNC
   sta HMOVE
   sta WSYNC

   sty ENABL
   sty COLUBK                  ;Y is zero
   sty PF0
   sty REFP0
   sty REFP1                   ;+15     15

   lda #THREECOPIESCLOSE|LEFTONE
   sta VDELP0
   sta VDELP1                  ;+8      23      turn on VDELPx (bit0==1)

   sta NUSIZ0
   sta NUSIZ1                  ;+6      29

   sta HMP0                    ;                LEFTONE
   asl
   sta HMP1                    ;+8      37      LEFTTWO

   sta RESP0                   ;+8      40      positioned at 57 (move left 1)
   sta RESP1                   ;+3      43      positioned at 66 (move left 2)

   sty GRP1
   sty GRP0
   sty ENAM0                   ;+7      50

   lda #TEXTCOLOR1
   sta COLUP0
   sta COLUP1

   sta WSYNC
   sta HMOVE

   ;--setup score ptrs

   ldx #10
SetupScorePtrsLoop
   txa
   lsr
   lsr
   tay
   lda Score,Y
   pha
   jsr GetDigitDataLo       ; 20        too slow? (costs ~1 scanline)
   sta MiscPtr,X
   pla
   jsr Lsr4Tay              ; 22        too slow?
   lda DigitDataLo,Y
   sta MiscPtr-2,X
   lda #>DigitData
   sta MiscPtr+1,X
   sta MiscPtr-1,X
   dex
   dex
   dex
   dex
   bpl SetupScorePtrsLoop

   jsr DrawScoreKernelSubroutine

   lda #TEXTCOLOR2
   sta COLUP0
   sta COLUP1

   lda GameFlags
   lsr
   bcs GameOnSoDisplayTimer
   ;--else display difficulty level
   and #GAMEDIFF_BITS>>1
   adc #1                               ; + 1 * 6  bugfix
   sta MiscPtr
   asl
   adc MiscPtr
   asl
   tay
   jsr SetPtr2_10
   beq DrawTimerOrDifficultyLevel      ; branch always

GameOnSoDisplayTimer

   lda Lives
   jsr GetDigitDataLo
   sta MiscPtr
   lda #<Maids1
   sta MiscPtr+2
   ldy #<Maids2
   lda #<BlankDigit
   ldx Timer
   jsr SetPtr4_10
DrawTimerOrDifficultyLevel

   lda #TEXTCOLOR3
   sta COLUP0
   sta COLUP1

   ;--now draw copyright (when Level==0) or level number (otherwise)
   ;   i.e., copyright only shown upon powerup, before first game is played
   ldx Level
   beq DrawCopyright
   ldy #<Child4
   sty MiscPtr
   lda #<Novice3
   sta MiscPtr+2
   lda #<ColonGfx
   jsr SetPtr4_10
   beq DrawCopyrightOrLevel      ;branch always


SetPtr2_10:
   ldx #10
.loopPtr:
   lda CopyrightPtrTbl,Y     ; also DiffDisplayLo
   sta MiscPtr,X
   iny
   dex
   dex
   bpl .loopPtr
   bmi DrawScoreKernelSubroutineJmp		;branch always

SetPtr4_10:
   sty MiscPtr+4
   sta MiscPtr+6
   txa
   jsr Lsr4Tay
   lda DigitDataLo,Y
   sta MiscPtr+8
   txa
   jsr GetDigitDataLo
   sta MiscPtr+10
DrawScoreKernelSubroutineJmp
   jmp DrawScoreKernelSubroutine

DrawCopyright
   jsr SetPtr2_10

DrawCopyrightOrLevel                  ;this returns with Y==0

   sty VDELP0
;   sty VDELP1             ;unnecessary
;   sty GRP0
;   sty GRP1               ;unnecessary

;   lda #ONECOPYNORMAL         ;==0
;   sty NUSIZ0               ;unnecessary
   sty NUSIZ1



;----------------------------------------------------------------------------
;------------------------Overscan Routine------------------------------------
;----------------------------------------------------------------------------
OverscanRoutine

   ldy #2
   sty WSYNC
   sty VBLANK
   lda  #44
   sta  TIM64T

   lda GameFlags
   lsr
   bcc SkipCollisionsAndUserInput

   jsr MusicSubroutine         ;I think this needs to be before the SFX subroutine

   jsr SoundEffectsSubroutine

   lda HeroMovementCounter
   bne DoNotMoveHeroNormally

   jsr CollisionHandlerSubroutine
   jsr ReadJoystickSubroutine
   jsr MoveHeroNormallySubroutine
   jsr GetOtherUserInputSubroutine			;skip this if reading from EEPROM!

   jmp SkipHighScoreSubroutine

DoNotMoveHeroNormally
   jsr DoNotMoveHeroNormallySubroutine
	jmp SkipHighScoreSubroutine
SkipCollisionsAndUserInput
	jsr HighScoreSubroutine
	lda SaveKeyFlags
	bne SkipOtherUserInputSub
   jsr GetOtherUserInputSubroutine			;skip this if reading from EEPROM!
SkipOtherUserInputSub
SkipHighScoreSubroutine
; TODO: remove subroutines



   jsr MoveElevatorsSubroutine

;---	SetupSpriteSubroutine
   lda GameFlags2
   and #MAIDFRAME_BIT      ;5th bit.  We want this bit (1 or 0) plus 8.
   jsr Lsr4Tay
   ldx #8
SetupHeroGfxPtrsLoop
   lda MaidGfxLoByteTable,Y
   sec
   sbc HeroY
   sta HeroGfx0Ptra,X
   iny
   iny
   dex
   dex
   bpl SetupHeroGfxPtrsLoop

   ;--setup MaidLineCounter2 for P1
   lda #(PLAYAREAHEIGHT*2)+MAID_HEIGHT+1
;   sec
   sbc HeroY
   sbc HeroY         ;twice as high
   sta MaidLineCounter2

   lda HeroY
   sta HeroTop0
;   sec
   sbc #9
   ora #$80
   sta HeroBottom0

   ;--make sure she's facing the right way
   lda GameFlags
   eor #MAIDDIR_BIT
   lsr
   sta REFP0
   sta REFP1


   lda #OCTWIDTHBALL|REFLECTEDPF
   sta CTRLPF

   ;--sprite positioning
   ldx #4
   jsr PositionASpriteSubroutine153
   lda HeroX
   ldx #1
   jsr PositionASpriteSubroutine
   lda HeroX
   dex
   jsr PositionASpriteSubroutine

   lda Level
   and #$0F
   tay
   lda ElevatorColorTable,Y
   sta COLUPF
   lda GameFlags3
   ora BackGroundEORTable,Y
   sta GameFlags3

  



WaitForOverscanEnd
   lda INTIM
   bpl WaitForOverscanEnd

   jmp VBLANKRoutine

;----------------------------------------------------------------------------
;----------------------------End Main Routines-------------------------------
;----------------------------------------------------------------------------

;****************************************************************************

;----------------------------------------------------------------------------
;----------------------Begin Functions---------------------------------------
;----------------------------------------------------------------------------

NoSpritesSubKernelSubroutine
   lda StairCaseTable-1,Y
   sta HMBL                   ;+7            set HMBL properly (we still need to move the ball)
   sta WSYNC
   sta HMOVE
   lda #0
   sta GRP1                   ;                VDEL
   sta GRP0                   ;+8       64     clear sprites
   sta PF1
   sta PF2                    ;+9        9     clear PF registers
   dec MaidLineCounter2
   dec MaidLineCounter2
   sta HMCLR                  ;+3       24

   cpy HeroTop0
   bne NoSwitchDrawUpdateNoSpritesSC2
   lda HeroBottom0
   sta HeroTop0
NoSwitchDrawUpdateNoSpritesSC2

   dey

   rts

;----------------------------------------------------------------------------

NoSpritesKernelSC1Subroutine
   jsr NoSpritesSubKernelSubroutine
   pla                        ;              pull background color of stack (and discard)

   cpy Temp+1
   sta WSYNC
   sta HMOVE                            ;+3       3
   bne DontLeaveNoSpritesSC2Yet         ;+2       5
   jsr Waste20CyclesSubroutine
   jsr Return
;   SLEEP 32                             ;+32     37
   jmp BackFromNoSpritesKernelMain      ;+3      40

DontLeaveNoSpritesSC2Yet           ;         6
   jsr Waste20CyclesSubroutine
   nop
   nop
;   SLEEP 24                        ;+24     30
   jmp BackFromNoSpritesKernelSC1  ;+3      33

;----------------------------------------------------------------------------

NoSpritesKernelSC2Subroutine  ;         59
   jsr NoSpritesSubKernelSubroutine

   sta WSYNC
   sta HMOVE                   ;+3       3
   bne NotDoneWithPlayAreaKernelsNoSpritesSC2
   jmp DoneWithPlayAreaKernels
NotDoneWithPlayAreaKernelsNoSpritesSC2
                                      ;         6 
   jsr Return
   pha
   pla
   nop
;   SLEEP 21                           ;+21     27
   jmp BackIntoSCKernelFromNoSprites  ;+3      30

;----------------------------------------------------------------------------

NoSpritesKernelMainSubroutine ;         56
   jsr NoSpritesSubKernelSubroutine
   tya
   cmp ElevBandHeight,X
   bne DontSwitchKernelsMain         ;+10      34
   dex
   bpl DontSwitchKernelsMain         ;+5       38
   cpy #0
   sta WSYNC
   sta HMOVE                         ;+3       3
   beq DoneWithPlayAreaKernels1      ;+2       5
   bne NotDoneWithPlayAreaKernelsNoSprites  ;+3       8
DoneWithPlayAreaKernels1             ;         6
   jmp DoneWithPlayAreaKernels       ;+3       9   branch always
DontSwitchKernelsMain
   sta WSYNC
   sta HMOVE                         ;+3        3
   jsr Waste20CyclesSubroutine
   jsr Return
   nop
;   SLEEP 34                          ;+34      37

   jmp BackFromNoSpritesKernelMain   ;+3       40

NotDoneWithPlayAreaKernelsNoSprites         ;         8
   jsr Return
   pha
   pla
;   SLEEP 19                                 ;+19     27
   jmp BackIntoSCKernelFromNoSprites        ;+3      30




;----------------------------------------------------------------------------

GetOtherUserInputSubroutine
   ;--first read B&W/COLOR switch to turn music on/off
   lda SWCHB
   and #BWCOLOR
   cmp #BWCOLOR

   ;   if 7800, use two state changes!  If 2600, B&W=music off, COLOR=music on.
   lda GameFlags2
   and #CONSOLETYPE_BIT
   beq ReadBWCOLORSwitch
   ;---7800 PAUSE switch routine
   lda GameFlags2
   bcc PauseDepressed
   ;--else Pause switch up
   ;   if PAUSESTATE_BIT is set, then flip MUSICON_BIT and clear PAUSESTATE_BIT
   ;   else do nothing
   and #PAUSESTATE_BIT
   beq DoneWithBWCOLORSwitch
   lda GameFlags2
   eor #MUSICON_BIT
   and #~PAUSESTATE_BIT
   bcs SetBWCOLORSwitch

PauseDepressed
   ;--if PAUSE switch depressed, set PAUSESTATE_BIT and do nothing else
   ora #PAUSESTATE_BIT
   bne SetBWCOLORSwitch

ReadBWCOLORSwitch
   ;--2600 BW/COLOR switch routine
   lda GameFlags2
   and #~MUSICON_BIT
   bcc TurnMusicOff
   ;--else turn music on
   ora #MUSICON_BIT
TurnMusicOff
SetBWCOLORSwitch
   sta GameFlags2
DoneWithBWCOLORSwitch


   ;--other console switches.  Only one state change per switch depress

   ;--new routine: RESET always (re-)starts a game with the current diff.  SELECT always stops a game and
   ;            changes the difficulty level.

   ldx GameFlags         ;load this up now so we can quickly reload it multiple times later
   lda SWCHB
   and #SELECT|RESET
   eor #SELECT|RESET
   bne ResetOrSelectPressed
   ;--else clear debounce bit
   txa                  ;X holds GameFlags
   and #~DEBOUNCE_BIT
   sta GameFlags
   jmp DontReadConsoleSwitches      ;since they aren't pressed, skip this routine!
                           ;can replace with conditional branch?

ResetOrSelectPressed
   txa                  ;X holds GameFlags
   and #DEBOUNCE_BIT
   bne DontReadConsoleSwitches
   ;--okay, they are pressed and we are accepting state changes:
   ;   first, set debounce bit
   txa
   ora #DEBOUNCE_BIT
   sta GameFlags         ;now GameFlags is changed, so X != GameFlags !!!
   ;--is select pressed?
   lda SWCHB
   and #RESET
   beq StartNewGame
   ;--increase difficulty (with wrap) and stop game if ongoing.

   ;--new routine.  With 4-byte table, saves 3 bytes.
   lax GameFlags            ;load A and X with GameFlags
   and #GAMEDIFF_BITS
   lsr                     ;get GAMEDIFF_BITS in bottom two bits (and clear carry)
   tay
   txa                     ;get GameFlags back in A
   adc GameDiffUpdateTable,Y   ;four-byte table

   ;--and stop game in progress
   and #~(GAMEON_BIT|MAIDMOVE_BIT)      ;stop game, stop maid
   sta GameFlags
   ;--stop music

 	jsr TurnOffMusicSubroutine		;returns with A==0.
   sta HeroMovementCounter            ;--stop automovement!
   sta Score
   sta Score+1
   sta Score+2
   lda #1
   sta SaveKeyFlags				;load new high score!

   ;--reset not pressed
DontReadConsoleSwitches
   lda INPT4
   bmi TriggerNotPressed
   ;--else trigger pressed
   ;--if game over (or not yet started), then trigger starts it.
   lda GameFlags
   lsr
   bcs DontRestartGameWithTrigger
StartNewGame
   ldx #NUM_INITS-1
.loopInit
   lda InitTbl,x
   sta initLst,x
   dex
   bpl .loopInit

   lda GameFlags
   ora #GAMEON_BIT|MAIDDIR_BIT
   sta GameFlags

;   lda #STARTINGLEVEL
;   sta Level                        ; *!*
;   lda #$99
;   sta Timer                        ; *!*
;   lda #$09
;   sta Lives                        ; *!*
;   lda #16
;   sta HeroX                        ; *!*
;   lda #0
;   sta Score                        ; *!*
;   sta Score+1                      ; *!*
;   sta Score+2                      ; *!*
;   sta HeroMovementCounter          ; *!*
;   lda #10
;   sta HeroY                        ; *!*
   ;--start music:
   ldx #SONG_GAMEPLAY
   jsr NewSongSubroutine
   ;--also need to set initial elevator Y position
   ;   and the following loop needs to be difficulty-dependent
   lda GameFlags
   and #GAMEDIFF_BITS
   lsr
   tay               ;difficulty times two in Y
; TODO: maybe rearrange data to allow simple loop:
   lda InitialElevVelPtrs,Y
   sta MiscPtr
   lda #>ChildElevY
   sta MiscPtr+1
   sta MiscPtr+3
   lda InitialElevYPtrs,Y
   sta MiscPtr+2
   ldy #6
SetInitialElevSpeedOnGameStart
   lda (MiscPtr),Y
   sta ElevVel,Y
   lda (MiscPtr+2),Y
   sta ElevY,Y
   dey
   bpl SetInitialElevSpeedOnGameStart

   rts

DontRestartGameWithTrigger
TriggerNotPressed
   ;--every frame that trigger not pressed we update random number
NextRandom
    lda RandomNumber
    lsr
    bcc SkipEOR
    eor #$B2
SkipEOR
    sta RandomNumber

   rts




;----------------------------------------------------------------------------

;----------------------------------------------------------------------------

;--xxstartxx		<--for quick finding

Start
    cld                         ; was missing!
; TODO: sent to Andrew Davie as a nice extension of macro.h
   ;--7800 detection code
    ldy #0
    lda $D0
    cmp #$2C                ;check RAM location #1
    bne MachineIs2600
    lda $D1
    cmp #$A9                ;check RAM location #2
    bne MachineIs2600
    ;--else this is running on a 7800.  Thanks, Nukey!
    ldy #CONSOLE7800
MachineIs2600
    ldx #0
    txa
ClearStackLoop
   dex
    txs
    pha
    bne ClearStackLoop

;--Some Initial Setup

   tya
   ora #MUSICON_BIT
    sta GameFlags2               ;set Machine Type and turn music on to start (only makes a difference for 7800)

   lda #MAIDDIR_BIT|DIFF_NORMAL
   sta GameFlags         ;so maid faces right at poweron and default is normal difficulty

;TOTO: use INTIM for random intialisation here (check for 0!)
   sta RandomNumber         ;random seed

   ;--X is already zero
   inx                  ; x == #REFLECTEDPF == 1
   stx CTRLPF
   stx SaveKeyFlags

   inx                  ; x = 2
   jsr PositionASpriteSubroutine153

   lda #10
   sta HeroY
   lda #16
   sta HeroX

   ;--this might not be necessary...
;   lda #GRAY+14
;   sta COLUPF


   ldx #6
InitialSetupLoop
   txa
   asl
   tay

   lda #>Frame2a
   sta HeroGfx0Ptra+1,Y

   lda NormalElevY,X
   sta ElevY,X
   lda NormalElevVel,X
   sta ElevVel,X

   dex
   bpl InitialSetupLoop

   stx VDELP0         ;X==$FF

   jmp OverscanRoutine      ;cuz we set up sprites in overscan - prevents 1st
                     ;   frame from looking goofy.

;----------------------------------------------------------------------------


GetDigitDataLo
   and #$0F
   tay
   lda DigitDataLo,Y
   rts
;----------------------------------------------------------------------------

DrawScoreKernelSubroutine

   sta WSYNC
   ;--waste time efficiently:
   ldy #11      ; 2
.wait
   dey          ; 2
   bne .wait    ; 3

   SLEEP 2

   ldy #4+1
ScoreKernelLoop             ;        59      this loop can't cross a page boundary!
                            ;            (or - if it does, adjust the timing!)
   SLEEP 3
   dey                      ;+5      64
   sty Temp+7               ;+3      67
   lda (MiscPtr),Y
   sta GRP0                 ;+8      75
   lda (MiscPtr+2),Y
   sta GRP1                 ;+8       7
   lda (MiscPtr+4),Y
   sta GRP0                 ;+8      15
   lda (MiscPtr+6),Y
   tax                      ;+7      22
   lda (MiscPtr+8),Y
   pha                      ;+8      30
   lda (MiscPtr+10),Y
   tay                      ;+7      37
   pla                      ;+4      41
   stx GRP1                 ;+3      44
   sta GRP0
   sty GRP1
   sty GRP0                 ;+9      53
   ldy Temp+7               ;+3      56
   bne ScoreKernelLoop      ;+3      59
                            ;        58
   sty GRP0
   sty GRP1
   sty GRP0                 ;+9      67
Exit:
   rts                      ;         1

;----------------------------------------------------------------------------



;----------------------------------------------------------------------------

Lsr5Tay:
   lsr
Lsr4Tay:
   lsr
   lsr
   lsr
   lsr
   tay
   rts

;----------------------------------------------------------------------------


CollisionHandlerSubroutine

   lda CXP0FB
   ora CXP1FB  ; TODO: enable collisions again
;   lda #0
   bpl Exit ; HeroDidntHitElev
   ;--to do: set auto-move counter
   lda #DEATH_AUTOMOVEMENT|DEATH_AUTOMOVEMENT_LENGTH
   sta HeroMovementCounter
   ;--also, start death tune
   ldx #SONG_DEATH
   bne NewSongSubroutine

;----------------------------------------------------------------------------

PutHeroBackAtCorrectSideOfFloorSubroutine
   ;--to determine which side we need to go back to, look at floor
   ;   divide by 20: 0 = go back to right, -10 = go back to left
   lda HeroY
   sec
DivideBy20LoopCollision
   sbc #20
   bcc PutBackOnLeft
   bne DivideBy20LoopCollision
   ;--else put back on right
   lda GameFlags
   and #~MAIDDIR_BIT
   ldx #136
   bne DonePuttingHeroBackOnCorrectSide

PutBackOnLeft
   ;--make maid face right and stop
   lda GameFlags
   ora #MAIDDIR_BIT
   ldx #16
DonePuttingHeroBackOnCorrectSide
   stx HeroX
   .byte $2c
StopMaid:
   lda GameFlags
   and #~MAIDMOVE_BIT
   sta GameFlags
   rts

;----------------------------------------------------------------------------

DecrementLivesSubroutine
   dec Lives
   bpl Exit2                    ; GameNotOver
   inc Lives
   ;--out of lives means game over, man.  Game over.
   lsr GameFlags
   asl GameFlags      ;clear game bit
   ;--also turn off music
   lda #1|CHECKHISCORE_BIT
   sta SaveKeyFlags				;load new high score!
	jmp TurnOffMusicSubroutine	;return from here.


;----------------------------------------------------------------------------

TurnOffMusicSubroutine
	lda #0
   sta AUDV0
   sta AUDV1							;stop music
   sta HighScore
   sta HighScore+1
   sta HighScore+2
	rts
;----------------------------------------------------------------------------

NewSongSubroutine
   ;--X holds new song number in high two bits (bits 6 and7)
   ;--first set song number in GameFlags variable
   stx Temp+7
   lda GameFlags
   and #~SONG_BITS
   ora Temp+7
   sta GameFlags
   ;--now reset all variables
   ldx #$FF
   stx SongIndexC0
   stx SongIndexC1
   inx      ;X==0
   stx LengthVolumeC0
   stx LengthVolumeC1
Exit2:
   rts

;----------------------------------------------------------------------------

UpdateTimersSubroutine

   dec FrameCounter

   ;--don't update timer while hero is moving between floors
   lda HeroMovementCounter
   bne NoChangeInTimerThisFrame
   ;--also don't update when game not ongoing
   lda GameFlags
   lsr
   bcc NoChangeInTimerThisFrame

   ;--if trigger pressed, decrement timer eight times as fast!
   ;   But only when maid is moving!
   bit INPT4
   bmi DecrementTimerNormally
   lda GameFlags
   and #MAIDMOVE_BIT
   beq DecrementTimerNormally
   lda #$01
   .byte $2c
DecrementTimerNormally
   lda #$0F
UpdateTimer
   and FrameCounter
   bne NoChangeInTimerThisFrame
   lda Timer
   beq TimerAlreadyAtZero
   sed               ;bcd!
;   sec
   sbc #$01
   sta Timer
   cld               ;no more bcd!
TimerAlreadyAtZero
NoChangeInTimerThisFrame

   rts

;----------------------------------------------------------------------------



;----------------------------------------------------------------------------


ReadJoystickSubroutine

   ldx HeroX
   lda GameFlags
   asl SWCHA
   bcs NoRight
   cpx #136
   beq DoneReadingJoystick
   ora #MAIDDIR_BIT|MAIDMOVE_BIT
   bne SetGameFlags            ;branch always

NoRight
   bmi NoLeft
   cpx #16
   beq DoneReadingJoystick
   and #~MAIDDIR_BIT
   ora #MAIDMOVE_BIT
   bne SetGameFlags         ;branch always

NoLeft
   ;--neither right nor left pressed, therefore, on CHILD difficulty stop the maid!
   and #GAMEDIFF_BITS
   cmp #DIFF_NOVICE
   bne DoneReadingJoystick
   lda GameFlags
   and #~MAIDMOVE_BIT
SetGameFlags
   sta GameFlags
DoneReadingJoystick

Exit3:
   rts

;----------------------------------------------------------------------------

DoNotMoveHeroNormallySubroutine
   ;--else, hero NOT under player control
   ;--only move every other frame
   lda FrameCounter
   and #AUTOMOVEMENT_UPDATE_FREQ
   bne Exit3

   ;--determine which automovement routine to use
   lda HeroMovementCounter
   and #AUTOMOVEMENT_BITS
   sta Temp            ;save this
   lsr
   jsr Lsr5Tay

   lda AutomovementHorPtr,Y
   sta MiscPtr
   lda #>DeathMovement
   sta MiscPtr+1

   lda HeroMovementCounter
   and #~AUTOMOVEMENT_BITS
;   sec
   sbc #1-1
   bne AutomovementCounterNotAtZero
   sta Temp+1
   ;--last automovement, so if completed level/floor, reset timer.
   ;   if just died, reset player position, decrement lives
   ;   Also: restart the gameplay tune (unless we are moving up stairs, in that case it hasn't stopped)

   ;--if top bit of HeroMovementCounter (in Temp) is set then not between floor automovement
   lda Temp
   bpl BetweenFloorsSoDontRestartGameplaySong
   ldx #SONG_GAMEPLAY
   jsr NewSongSubroutine
   lda Temp
BetweenFloorsSoDontRestartGameplaySong
   eor #DEATH_AUTOMOVEMENT
   bne DidntDieResetTimer
   ;--else died.
   ;--if died, reset heromovementcounter and skip last automovement (since we just put the hero back)
   sta HeroMovementCounter
   jsr DecrementLivesSubroutine
   jmp PutHeroBackAtCorrectSideOfFloorSubroutine

DidntDieResetTimer
   ;--reset timer now
   lda #$99
   sta Timer
MovementCounterAtZero
   lda #0
   .byte $2C
AutomovementCounterNotAtZero
   ora Temp
   sta HeroMovementCounter
   and #~AUTOMOVEMENT_BITS
   tay

   lax (MiscPtr),Y
   bpl .noVert
   asl
   asl
   lda #1
   bcc .posVert
   lda #-70-1
.posVert
   adc HeroY
   sta HeroY
.noVert:

   txa
   lsr
   bcc MaidFacesSameDirection
   and #%1
   beq .posHorz
   lda #-1-1
.posHorz:
   adc HeroX
   sta HeroX

   ;--now make maid face the proper direction:
   lda GameFlags
   and #~MAIDDIR_BIT
   bcs MaidFacesRight            ; carry is set after addition above
   ;--else maid faces left
   ora #MAIDDIR_BIT
MaidFacesRight
   sta GameFlags
MaidFacesSameDirection

   ;--add animation code in here: if change in position is nonzero, update animation
   txa
   beq NoChangeInMaidFrame
   ;--else, animate!
;   lda FrameCounter
;   and #3                      ; == AUTOMOVEMENT_UPDATE_FREQ
;   bne NoChangeInMaidFrame

   lda GameFlags2
   eor #MAIDFRAME_BIT
   sta GameFlags2

NoChangeInMaidFrame


   ;--increment level if and when automovement is between levels and counter = 17
   lda HeroMovementCounter
   cmp #COMPLETELEVEL_AUTOMOVEMENT|17
   bne NoLevelIncrease

   ;--we are between levels so increment level here instead of immediately
   lda Level
   cmp #$99         ;at max level?
   beq NoLevelIncrease
   sed
   adc #$01
   sta Level
   cld
   ;--also add the additional elevators while maid is off screen
   ;--add missing elevators

   lda #PLAYAREAHEIGHT+1  ;first check middle elevator
   cmp ElevY+3
   bne MiddleElevatorOnScreen
   ;--else, put middle elevator (only) on screen
   lsr
   sta ElevY+3
   bne DoneAddingElevators      ;branch always because we add the middle only
MiddleElevatorOnScreen
   ;--else add all other elevators
   ldx #6
MoveElevatorsOnScreenLoop
   lda #PLAYAREAHEIGHT+1
   cmp ElevY,X
   bne ThisElevatorOnScreen
   lsr
   sta ElevY,X
ThisElevatorOnScreen
   dex
   bpl MoveElevatorsOnScreenLoop
DoneAddingElevators
NoLevelIncrease

   rts

;----------------------------------------------------------------------------




MoveHeroNormallySubroutine
   ldx #2

MoveHeroLoop

   lda GameFlags
   and #MAIDMOVE_BIT
   beq DontMoveHero
   ;--else don't move hero
;   rts

MoveHero
   ldy #0
   asl INPT4
   lda GameFlags
   and #MAIDDIR_BIT
   php
   ;--move hero right

   lda #MAID_VELOCITY
   ;---add boost when trigger pressed
   bcs NoBoost
   lda #BOOST_VELOCITY
NoBoost
   plp
   clc
   bne MoveHeroRight
   dey
   eor #$ff
   adc #1
MoveHeroRight:
   adc HeroXfract
   sta HeroXfract
   tya
   adc HeroX
   sta HeroX
   eor #136
   bcc CheckRight
   eor #136^16
CheckRight:
	bne DoneMovingHero
CheckSide:

   ;--reached right side - if on even floor (0, 2, 4, 6, ...) then we add
   ;      timer to score and move up a level.
   ;   Else, just stop moving.

   ;--for now, with floors 8 lines high:
	;--EDIT!  New routine means we don't know if we've reached the right side!
   lax HeroY
   sec
DivideBy20LoopR
   sbc #20
   beq IsZero
   bcs DivideBy20LoopR
   tya
   bne StopHeroFlip
   lda #BETWEENFLOOR_AUTOMOVEMENT_LENGTH|BETWEENFLOORR_AUTOMOVEMENT
   bne ReachedSideGoal

IsZero:
   tya
   beq StopHeroFlip
   cpx #80         ;are we at the top?
   beq CompletedBuilding
   lda #BETWEENFLOOR_AUTOMOVEMENT_LENGTH|BETWEENFLOORL_AUTOMOVEMENT
ReachedSideGoal
   ;--else, reached right-side goal:
   ;--set auto-movement
   sta HeroMovementCounter

   ;--stop maid movement so she doesn't come shooting out after climbing stairs
   jsr StopMaid
   ;--start sound effect
   ldx #0               ;can change X here because we won't come through this loop again
                     ;   since we stopped the maid.
   ;--new routine!  Only one sound effect!  And they should never overlap.
   lda GameFlags2
   and #~SFXCOUNTER_BITS
   ora #SFXCOUNTER_FLOOR_COMPLETE
   sta GameFlags2

   ;--also, add timer to score:
AddTimerToScore
   ;--also add difficulty bonus (0, 20, 40, 60) per floor completed
   ldy #0
   jsr AddToScoreSubroutineDiff
StopHero
   jsr StopMaid
DoneMovingHero
   dex
   bne MoveHeroLoop

   ;--now flip MAIDFRAME_BIT (GameFlags2) every 4 frames while moving

   lda FrameCounter
   and #3
   bne DontChangeMaidFrame

   lda GameFlags2
   eor #MAIDFRAME_BIT
   sta GameFlags2
DontChangeMaidFrame
DontMoveHero
   rts

StopHeroFlip
   lda GameFlags
   eor #MAIDDIR_BIT
   sta GameFlags
   jmp StopHero

CompletedBuilding
   ;--completed building.
   ;   Actions:   reposition hero at bottom left of building.
   ;            add timer to score
   ;            add some kind of bonus to score
   ;            reset timer
   ;            increase speed of at least one elevator
   ;            increase level (max at 99)
   ;            if all elevators aren't on screen, add some
   ;            start complete-level tune
   ldx #SONG_LEVELCOMPLETE
   jsr NewSongSubroutine

   ;--standard complete-floor scoring (Timer + Difficulty bonus)
   ldy Level             ;plus extra level-completion bonus: Level x 100
   jsr AddToScoreSubroutineDiff





   ;--also: extra life after every level (subject to difficulty level)
   lda GameFlags
   and #GAMEDIFF_BITS
   lsr
   tay
   lda Level
   cmp MaxExtraLifeLevelTable,Y
   bcs NoExtraLife
   lda Lives
   cmp #$09
   beq NoMoreThanNineLives
   inc Lives
NoMoreThanNineLives
NoExtraLife



   lda #COMPLETELEVEL_AUTOMOVEMENT|COMPLETELEVEL_AUTOMOVEMENT_LENGTH
   sta HeroMovementCounter
GetAnotherRandomNumber
   jsr NextRandom   ; jsr below, why saving space here?
   ;--inlining this to conserve stack space/RAM
;    lda RandomNumber
;    lsr
;    bcc SkipEOR2
;    eor #$B2
;SkipEOR2
;    sta RandomNumber
   and #7<<3
   beq GetAnotherRandomNumber
   lsr
   lsr
   lsr
   tax
   dex
   lda ElevVel,X
   and #$80
   sta Temp
   eor ElevVel,X
   sta Temp+1
   lda RandomNumber
   and #7
   beq GetAnotherRandomNumber
   adc Temp+1
   adc #10
   and #%00111111
   ora Temp
   sta ElevVel,X

;--stop maid movement so she doesn't come shooting out after starting new building
   bcc StopHero ; branch always


;----------------------------------------------------------------------------
AddToScoreSubroutineDiff SUBROUTINE
; y either contains 0 or level
   lda GameFlags           ;--also add difficulty bonus (0, 20, 40, 60) per floor completed
   and #GAMEDIFF_BITS
   asl
   asl
   asl
   asl
   jsr .AddToScore
   lda Timer
   ldy #0
.AddToScore
   sed
   clc
   adc Score+2         ;add to score
   sta Score+2
   tya
   adc Score+1
   sta Score+1
   lda Score
   adc #0
   sta Score
   cld

   rts

;----------------------------------------------------------------------------

MoveElevatorsSubroutine

   ;--clear TICK_BIT
   lda #0
   sta GameFlags3         ;have to change this if we use GameFlags3 for anything else!  Maybe not...

   ldx #6
   ;--if player is in the process of dying, then don't move elevators!
   lda HeroMovementCounter
   beq HeroNotDyingSoMoveElevators
   and #AUTOMOVEMENT_BITS
   cmp #DEATH_AUTOMOVEMENT
   bne HeroNotDyingSoMoveElevators
   ;--still need to clear the top bit of ElevY for all elevators
ClearElevYTopBitLoop
   asl ElevY,X
   lsr ElevY,X
   dex
   bpl ClearElevYTopBitLoop
   rts

HeroNotDyingSoMoveElevators
ApplyElevSpeedLoop
   ;--ElevY will hold the value of the top of the elevators ORed with #$80
   ;   so first clear the top bit
   lda ElevY,X
   and #$7F
   sta ElevY,X

   ;--if elevators are above the play area then they are NOT to be moved
   cmp #PLAYAREAHEIGHT+1
   bcs EndOfApplyElevSpeedLoop

;ElevatorIsInUseMoveIt
;   lda #0
;   sta Temp
   lda ElevVel,X
   and #%00111000
   lsr
   lsr
   lsr
   tay
   lda AddTable,Y
;   adc Temp         ;carry cleared after LSR above
   sta Temp
   lda ElevVel,X
   and #%00011111
   cmp #%00011000
   beq NoAdditionalAdd      ;no need to do following junk if speed is zero
   lda FrameCounter
   and #31
   asl
   sta Temp+1
   iny
   tya
   and #2
   cmp #2               ; former CrazyIndexing
   ;--normal idexing
   bcc .skipCrazy0
   dey                ; flips bit 0
.skipCrazy0:
   tya
   and #1
   ora Temp+1         ;index into table
   tay
   lda ElevatorSpeedTable,Y
   sta Temp+1         ;save byte, now find which bit
   lda ElevVel,X
   bcc .skipCrazy1
   eor #7
.skipCrazy1:
   and #7
   tay
   lda Temp+1
   and SpeedMaskTable,Y
   beq NoAdditionalAdd
YesAdditionalAdd
   inc Temp
NoAdditionalAdd
   ;--now we know what to add/subtract, now determine which it is:
   lda ElevVel,X
   asl
   lda ElevY,X
   bcs MoveElevatorDown
   adc Temp
   cmp #PLAYAREAHEIGHT+1
   bcc ElevatorNotTooHigh
   ;--else too high, so reset position and flip direction
   ldy #PLAYAREAHEIGHT
FlipElevatorDirection
   lda ElevVel,X
   eor #$80
   sta ElevVel,X
   ;--also start TICK sound
   lda #TICK_BIT
   sta GameFlags3            ;have to change this if we use GameFlags3 for anything else.  Maybe not...
   tya
ElevatorNotTooHigh
ElevatorNotTooLow
   sta ElevY,X
EndOfApplyElevSpeedLoop
   dex
   bpl ApplyElevSpeedLoop
   rts

MoveElevatorDown
   sbc Temp
   cmp #ELEV_HEIGHT
   bcs ElevatorNotTooLow
   ;--else too low, so reset position and flip direction
   ldy #ELEV_HEIGHT
   bne FlipElevatorDirection      ;branch always; #ELEV_HEIGHT is nonzero


;----------------------------------------------------------------------------




;----------------------------------------------------------------------------

SoundEffectsSubroutine

   ;--new routine!  As it turned out, there is only one sound effect!

   ;--all sound effects played in channel 1

   lda GameFlags2
   and #SFXCOUNTER_BITS
   beq NoSoundEffectToPlay
   tax
   dex            ;subtract one from counter for indexing

   ;--do we play SFX this frame?
   lda FrameCounter
   and #3
   bne NoSoundEffectThisFrame
   ;--set AUDC1
   lda #NOISESOUND
   sta AUDC1
   ;--now set AUDF1 and AUDV1
   lda SFXFloorCompleteFreqTable,X
   sta AUDF1
   lda SFXFloorCompleteVolumeTable,X
   sta AUDV1
   ;--now decrease counter
   dec GameFlags2         ;this is ok since the lower 4 bits are always nonzero here.
NoSoundEffectThisFrame

NoSoundEffectToPlay

   rts




;----------------------------------------------------------------------------

MusicSubroutine
   ;--play music constantly in channel 0 (unless music-on bit is clear, then
   ;   set AUDV0 to zero constantly)
   ;--play music in channel 1 unless a sound effect is playing (same music-on bit stuff here)

   ;---music data format:
   ;byte: xxxxxxxx
   ;bits: 76543210
   ;   bit7    =   articulate bit (0=articulate, 1=slur)
   ;   bit6-5   =   note length bits.  %00=32nd, %01=16th, %10=8th, %11=quarter
   ;   bit4-0   =   note value.  index into lookup table (or something similar) - *not* an AUDxx value!
   ;
   ;special cases:
   ;      note value of 31 (%xxx11111) is a rest (volume zero)
   ;       articulated 32nd notes (not possible with the music driver) indicate non-note codes:
   ;         %0000xxxx   =   new volume (bits3-0 is new volume)
   ;         %0001xxxx   =   new index (new index value in next byte)
   ;


   ldx #1            ;index into which channel
MusicLoop
   ;--first get song number into Y
   lda GameFlags
   and #SONG_BITS
   asl
   rol
   rol
   tay
   lda #$FF
   sta Temp+1            ;new note flag
   ;--special case:
   cmp SongIndexC0,X      ;is song index #$FF?  Then get a new note immediately, song is just beginning:
   beq NewNote
   lda FrameCounter
   and #TEMPO112         ;hardcoded tempo for all music is 112.5 bpm
   bne BeatHasNotEnded
   lda LengthVolumeC0,X
;   sec
   sbc #$10					;carry always SET here!!
   bmi NewNote
   ;--no new note, but need to read note to set AUDFx/AUDCx
   sta LengthVolumeC0,X      ;update note length
BeatHasNotEnded
   lda #0
   sta Temp+1               ;reset new note flag
   .byte $2C               ;skip next opcode
NewNote
   ;--note has ended, time for a new note!
   inc SongIndexC0,X         ;increment song index
   tya
   asl                     ;this will clear carry
   sta Temp               ;save song number * 2
   txa                     ;take channel
   adc Temp               ;Song*2 + channel
   asl                     ;whole thing times two
   tay
   lda SongPtr,Y
   sta MiscPtr
   lda SongPtr+1,Y
   sta MiscPtr+1            ;now MiscPtr is pointing at correct song
GetNewNote
   ldy SongIndexC0,X            ;Y holds note index
   lda (MiscPtr),Y            ;<-new note
   ;--process new note
;   and #%11110000            ;check for special cases
;   cmp #%00010000            ;which special case?
;   beq NewVolume
;   bcs RegularNote

   and #%11100000            ;check for special case
   bne RegularNote
   ;--special case (volume change or index change)
   lda (MiscPtr),Y
   and #%00010000            ;which special case?
   beq NewVolume
   ;--else new index (in following byte)
   iny                     ;new index in following byte
   lda (MiscPtr),Y            ;get new index
   sta SongIndexC0,X         ;save new index
   bcc GetNewNote            ;and get the next note

NewVolume                  ;new volume is bottom four bits of special case byte
   lda LengthVolumeC0,X
   and #$F0               ;save note length, clear volume
   ora (MiscPtr),Y            ;top four bits are clear if it is volume
   sta LengthVolumeC0,X
   inc SongIndexC0,X       ;move index to new note
   bcc GetNewNote

RegularNote
NoChangeInNote
   lda (MiscPtr),Y            ;get note
   sta NoteData,X            ;save it
   and #%00011111            ;get note index
   tay
   lda AUDCTable,Y
   sta AUDCTemp,X
   lda AUDFTable,Y
   sta AUDFTemp,X            ;get and save new distortion# and frequency
   ;--only reset length if this is a new note!
   lda Temp+1               ;new note flag
   beq NoChangeInNoteLength
   lda NoteData,X            ;get note data
   and #%01100000
   jsr Lsr5Tay               ;get note length lookup into Y
   lda LengthVolumeC0,X      ;length part of this is zero already!
   ora LengthLookupTable,Y
   sta LengthVolumeC0,X
NoChangeInNoteLength
   dex
   bpl MusicLoop

;DoneWithMusicLoop

   ldx #1
   lda GameFlags2
   and #SFXCOUNTER_BITS
   bne SoundEffectPlayingDoNotTouchC1
PlayMusicLoop
   lda AUDFTemp,X
   sta AUDF0,X
   lda AUDCTemp,X
   sta AUDC0,X
;   cmp #RESTFLAG                  ; == 0
   beq RestVolume
   ;--regular volume routine
   lda LengthVolumeC0,X
   and #$0F
   sta AUDVTemp,X
   lda NoteData,X
   and #SLUR_BIT
   bne NoArticulation
   ;--else articulate the note
   lda LengthVolumeC0,X
   jsr Lsr4Tay        ;get length into Y
   lda AUDVTemp,X
   sec
   sbc ArticulationTable,Y
   bcs SetVolume
   lda #0            ;no negative volumes!
SetVolume
   sta AUDVTemp,X
NoArticulation
   ;--SFX?  If a sound effect is playing, we will only reach this point for C0
   lda GameFlags2
   and #SFXCOUNTER_BITS
   beq NoSoundEffectPlaying
   ;--sound effect is playing, cut volume in half
   lsr AUDVTemp,X
NoSoundEffectPlaying
   ;--if MUSICON_BIT is clear, set volume to zero ONLY IF we are playing gameplay tune
   lda GameFlags
   and #SONG_BITS
   cmp #SONG_GAMEPLAY
   bne NormalVolume
   lda GameFlags2
   and #MUSICON_BIT
   beq MusicNotOn
NormalVolume
   lda AUDVTemp,X
   .byte $2C
RestVolume
   lda #0
SetAUDVx
   sta AUDV0,X
SoundEffectPlayingDoNotTouchC1
   dex
   bpl PlayMusicLoop

   rts

MusicNotOn
   ;--here: music is not on, song is gameplay (or silence?)
   ;--check if TICK_BIT is set and SFX_BITS are clear and channel == 0. If so, play TICK
   ;   else, play nothing
   txa
   bne RestVolume         ;if X != 0 then channel is 1 and we don't play tick
   lda GameFlags3
   lsr
   bcc RestVolume
   lda GameFlags2
   and #SFXCOUNTER_BITS
   bne RestVolume
   ;--else, play tick
   lda #TICK_DIST
   sta AUDC0
   lda #TICK_FREQ
   sta AUDF0
   lda #TICK_VOL
   bne SetAUDVx         ;branch always

;----------------------------------------------------------------------------


   ;***about 0 bytes free***

;   align 256

;----------------------------------------------------------------------------

SetElevRAMSubroutine

   ;--new method:
   ;--Y position of elevators ranges from 0 to 80
   ;--so:
   ;   upon beginning this routine, ElevY will hold values pointing to the tops
   ;      of the elevators
   ;   -so first thing to do is to subtract ELEV_HEIGHT from each Y position
   ;      so that ElevY holds the   *bottom* of the elevators
   ;   -after processing the bottom of the elevators, flag that we processed
   ;      the bottom of that elevator (temp variables) and add ELEV_HEIGHT back to the
   ;      the Y position so that it points to the top.
   ;   -after processing the top of the elevators, ORA ElevY with 128 (set top bit)
   ;   -when the lowest Y position (ElevY) is a negative number (top bit set) then we are done.

   ldy #1
   ldx #NUM_ELEVATORS-1
InitializeElevYLoop
   lda ElevY,X
   ;--if above play area, don't subtract
   cmp #PLAYAREAHEIGHT+1
   bcs SkipElevHeightSubtract
   sbc #ELEV_HEIGHT-1         ;adjust because carry always clear
   sta ElevY,X
SkipElevHeightSubtract
   sty Temp,X         ;set flags also
   dex
   bpl InitializeElevYLoop

   ;--initialize the bottom band with zeroes
   dey         ;Y back to zero
   sty ElevRAM
   sty ElevRAM+NUM_RAMBANDS
   sty ElevRAM+[NUM_RAMBANDS*2]
   sty ElevRAM+[NUM_RAMBANDS*3]
   sty ElevBandHeight
   sty MiscPtr+1

   dey         ;Y==$FF
   ;--now loop to set up RAM
SetElevRAMLoop
   ldx #0
   lda ElevY
   cmp ElevY+1
   bcc Elev2NotLowest
   ldx #1
   lda ElevY+1
Elev2NotLowest
   cmp ElevY+2
   bcc Elev3NotLowest
   ldx #2
   lda ElevY+2
Elev3NotLowest
   cmp ElevY+3
   bcc Elev4NotLowest
   ldx #3
   lda ElevY+3
Elev4NotLowest
   cmp ElevY+4
   bcc Elev5NotLowest
   ldx #4
   lda ElevY+4
Elev5NotLowest
   cmp ElevY+5
   bcc Elev6NotLowest
   ldx #5
   lda ElevY+5
Elev6NotLowest
   cmp ElevY+6
   bcc Elev7NotLowest
   ldx #6
   lda ElevY+6
Elev7NotLowest


; this would be much smaller, but seems too slow
;   sty Temp+7
;   ldy #NUM_ELEVATORS-2
;   ldx #NUM_ELEVATORS-1
;   lda ElevY+NUM_ELEVATORS-1
;.loopLowest
;   cmp ElevY,y
;   bcc .notLower
;   tya
;   tax                  ; new lowest index
;   lda ElevY,x          ; new lowest value
;.notLower
;   dey
;   bpl .loopLowest
;   ldy Temp+7


   ;--now A holds lowest value
   ;   and X holds index into which elevator is the lowest
   cmp #PLAYAREAHEIGHT+1      ;if value is higher than top of playfield then we are done
   bcs AllDone
   cpy #$FF
   beq LowestBand

   cmp ElevBandHeight,Y
   beq SameBand
   ;--else: new band, so
   ;   bring all values from old band into new band:
NotLowestBand
   iny
   cpy #NUM_RAMBANDS
   beq AlmostAllDone
   sta ElevBandHeight,Y
   lda ElevRAM-1,Y
   sta ElevRAM,Y
   lda ElevRAM+NUM_RAMBANDS-1,Y
   sta ElevRAM+NUM_RAMBANDS,Y
   lda ElevRAM+[NUM_RAMBANDS*2]-1,Y
   sta ElevRAM+[NUM_RAMBANDS*2],Y
   lda ElevRAM+[NUM_RAMBANDS*3]-1,Y
   sta ElevRAM+[NUM_RAMBANDS*3],Y
SameBand
   lda ElevPtrTableLo,X
   sta MiscPtr
   lda (MiscPtr),Y
   eor ElevFlipTable,X
   sta (MiscPtr),Y
   lsr Temp,X         ;flags that determine top or bottom of elev
   lda ElevY,X
   bcs JustProcessedElevBottom
   ;--else that was the top
   ora #$80
   .byte $2c
JustProcessedElevBottom
   ;--that was the bottom, now set it for the top
   adc #ELEV_HEIGHT-1      ;carry is set following bcs
SetElevRAMLoopJmp
   sta ElevY,X
   jmp SetElevRAMLoop      ;branch always.  Also, obviously, too far for a conditional branch.

LowestBand
   iny
   sta ElevBandHeight,Y
   bpl SameBand         ;Branch always.  Y is never <0 or >127 here...I think.  bcs would work too!

AlmostAllDone
   ;--here, the top band is empty so we are going to special-case it
   ;   A holds where the first elevator starts
   ;   Y holds 14
   ;--now save the height of the top band
   ;   if it is the very top of the screen, though, then we don't special-case
   cmp #PLAYAREAHEIGHT
   bne SetupSpecialCase
   lda #0
SetupSpecialCase
   sta Temp+1
   ;--so reset Y first:
   dey
   bne SaveFirstBandNumber      ;branch always

AllDone
   lda #0
   sta Temp+1
   ;--now we have to deal with situation where the highest
   ;   elevator(s) is at the top line
   lda ElevBandHeight,Y
   cmp #PLAYAREAHEIGHT
   bne NoElevAtVeryTop
   dey
SaveFirstBandNumber
NoElevAtVeryTop
   sty Temp         ;save this value for later

   rts


;----------------------------------------------------------------------------


;****************************************************************************


;----------------------------------------------------------------------------
;-------------------------Data Below-----------------------------------------
;----------------------------------------------------------------------------

GameplaySongC0
   .byte VOLUMECHANGE|V6
   .byte SIXTEENTH|REST
   .byte SIXTEENTH|A5
   .byte EIGHTH|C5
   .byte SIXTEENTH|C5
   .byte EIGHTH|D5
   .byte SIXTEENTH|C5
   .byte SIXTEENTH|D5
   .byte EIGHTH|E5
   .byte EIGHTH|C5
   .byte EIGHTH|D5
   .byte EIGHTH|E5

   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|EIGHTH|A5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|D5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|C6
   .byte QUARTER|Bb5

   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|EIGHTH|Bb5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|EIGHTH|G5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|D5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|QUARTER|A5
GameplayTuneRepeatC0
   .byte SIXTEENTH|C6
   .byte EIGHTH|C6
   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|A5
   .byte SIXTEENTH|C6
   .byte EIGHTH|C6
   .byte SLUR|SIXTEENTH|Bb5
   .byte QUARTER|A5

   .byte SIXTEENTH|C6
   .byte EIGHTH|C6
   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|EIGHTH|A5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|C5
   .byte QUARTER|F4

   .byte SLUR|SIXTEENTH|D5
   .byte SLUR|SIXTEENTH|Cs5
   .byte SLUR|SIXTEENTH|D5
   .byte SLUR|EIGHTH|A5
   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|EIGHTH|G5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|QUARTER|E5

   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|EIGHTH|D5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|EIGHTH|F5
   .byte SLUR|QUARTER|G5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|D5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|A5

   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|SIXTEENTH|C6
   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|EIGHTH|A5
   .byte SLUR|SIXTEENTH|D5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|SIXTEENTH|C6
   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|QUARTER|A5

   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|SIXTEENTH|C6
   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|Cs5
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|QUARTER|D5
   .byte SLUR|EIGHTH|D5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|D5

   .byte EIGHTH|A5
   .byte SLUR|QUARTER|A5
   .byte SLUR|EIGHTH|Bb5
   .byte SLUR|QUARTER|A5
   .byte SLUR|EIGHTH|A5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|C5

   .byte EIGHTH|A5
   .byte SLUR|QUARTER|A5
   .byte SLUR|EIGHTH|Bb5
   .byte SLUR|QUARTER|A5
   .byte SLUR|EIGHTH|A5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|C5

   .byte EIGHTH|G5
   .byte SLUR|QUARTER|G5
   .byte SLUR|EIGHTH|A5
   .byte SLUR|QUARTER|G5
   .byte SLUR|EIGHTH|G5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|C5

   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|EIGHTH|G5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|QUARTER|G5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|G5

   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|EIGHTH|A5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|QUARTER|Bb5
   .byte SLUR|SIXTEENTH|Bb5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|D5
   .byte SLUR|SIXTEENTH|C5

   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|EIGHTH|G5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|F5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|QUARTER|A5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|Bb5

   .byte INDEXCHANGE,GameplayTuneRepeatC0-GameplaySongC0

GameplaySongC1
   .byte VOLUMECHANGE|V5
   .byte SIXTEENTH|REST


   .byte SIXTEENTH|F3
   .byte EIGHTH|F3
   .byte SIXTEENTH|F3
   .byte EIGHTH|F3
   .byte SIXTEENTH|F3
   .byte SIXTEENTH|F3
   .byte EIGHTH|C4
   .byte EIGHTH|E4
   .byte EIGHTH|D4
   .byte EIGHTH|C4

   .byte SLUR|EIGHTH|F3
   .byte SIXTEENTH|F3
   .byte SLUR|EIGHTH|C4
   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|SIXTEENTH|A3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|EIGHTH|D4
   .byte SLUR|EIGHTH|D3
   .byte SLUR|EIGHTH|F3
   .byte EIGHTH|A3

   .byte SLUR|EIGHTH|G3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|EIGHTH|D4
   .byte SLUR|SIXTEENTH|D4
   .byte SLUR|EIGHTH|G3
   .byte SLUR|EIGHTH|C4
   .byte SLUR|EIGHTH|E3
   .byte SLUR|EIGHTH|F3
   .byte SLUR|EIGHTH|C4
GameplayTuneRepeatC1
   .byte SIXTEENTH|C4
   .byte EIGHTH|C4
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|SIXTEENTH|A3
   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|F4
   .byte SIXTEENTH|C5
   .byte EIGHTH|C5
   .byte SLUR|SIXTEENTH|G5
   .byte EIGHTH|F5
   .byte SLUR|SIXTEENTH|A3
   .byte SLUR|SIXTEENTH|Bb3

   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|SIXTEENTH|A3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|A3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|A3
   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|SIXTEENTH|A3
   .byte EIGHTH|F3
   .byte EIGHTH|E3

   .byte SLUR|EIGHTH|D3
   .byte SLUR|SIXTEENTH|D3
   .byte SLUR|EIGHTH|F3
   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|EIGHTH|D3
   .byte SLUR|SIXTEENTH|E3
   .byte SLUR|EIGHTH|Bb3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|SIXTEENTH|A3
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|SIXTEENTH|Cs4
   .byte SLUR|SIXTEENTH|A3

   .byte SLUR|EIGHTH|G3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|EIGHTH|D4
   .byte SLUR|SIXTEENTH|D4
   .byte SLUR|EIGHTH|G3
   .byte SLUR|EIGHTH|Bb3
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|EIGHTH|C4
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|EIGHTH|D4

   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|D4
   .byte SLUR|EIGHTH|D4
   .byte SLUR|EIGHTH|D3
   .byte SLUR|EIGHTH|G3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|EIGHTH|A3
   .byte SLUR|SIXTEENTH|A3
   .byte SLUR|EIGHTH|Cs4

   .byte SLUR|SIXTEENTH|D4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|D5
   .byte SLUR|SIXTEENTH|E5
   .byte SLUR|SIXTEENTH|Cs5
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|EIGHTH|D4
   .byte SLUR|EIGHTH|D3
   .byte SLUR|EIGHTH|E3

   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|C4

   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|C5
   .byte SLUR|SIXTEENTH|A4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|C4

   .byte SLUR|SIXTEENTH|E3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|SIXTEENTH|E3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|SIXTEENTH|G3

   .byte SLUR|SIXTEENTH|E3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|SIXTEENTH|E3
   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|Bb3
   .byte SLUR|SIXTEENTH|G3

   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|EIGHTH|F4
   .byte SLUR|SIXTEENTH|F4
   .byte SLUR|SIXTEENTH|E3
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|D4
   .byte SLUR|EIGHTH|E4
   .byte SLUR|EIGHTH|C4
   .byte SLUR|EIGHTH|G3
   .byte SLUR|EIGHTH|C4

   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|D4
   .byte SLUR|EIGHTH|E4
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|SIXTEENTH|C4
   .byte SLUR|SIXTEENTH|D4
   .byte SLUR|SIXTEENTH|E4
   .byte SLUR|EIGHTH|F4
   .byte SLUR|EIGHTH|F3
   .byte SLUR|EIGHTH|A3
   .byte SLUR|EIGHTH|C4

   .byte INDEXCHANGE,GameplayTuneRepeatC1-GameplaySongC1





	i2c_subs



HighScoreSubroutine
	;--routine:

	lda SaveKeyFlags
	and #SAVEKEYSTEP_BITS
	beq DoneCheckingForNewHighScore	;--SAVEKEYSTEP_BITS==0 means we're done.
	;--else, read subroutine address from jump table and go there
	tay
	dey
	lda SaveKeyJumpTableLo,Y
	sta Temp
	lda SaveKeyJumpTableHi,Y
	sta Temp+1
	;--now adjust SAVEKEYSTEP_BITS index before we jump
	inc SaveKeyFlags
	jmp (Temp)



DoneCheckingForNewHighScore
	;--if we reach here, then switch Score and HighScore every 128 frames (~2 seconds)
	lda FrameCounter
	and #127
	bne DontSwitchDisplayedScore	;this is just a branch to an RTS, this label is inside i2c_subs
	;--else switch them
	;	put this in a loop!!!
	ldx #Score
	ldy #Temp
	jsr CopyScoreLoopSubroutine
	ldx #HighScore
	ldy #Score
	jsr CopyScoreLoopSubroutine
	ldx #Temp
	ldy #HighScore
	jmp CopyScoreLoopSubroutine	;return from there.



	

ReadByteSubroutine
	jsr i2c_startread

	lda SaveKeyFlags
	and #SAVEKEYSTEP_BITS
	sec
	sbc #6				;get index between 0 and 2	- this shouldn't change the overflow flag.  I think!
	tax
	jsr i2c_rxbyte
	cmp #$9A				;check for bigger than BCD.  Not a perfect check, but oh wells...
	bcs NonBCDByte
	sta HighScore,X
NowSendStopRead
	jmp i2c_stopread
NonBCDByte
	lda #9|CHECKHISCORE_BIT
	sta SaveKeyFlags
	bne NowSendStopRead

	


   ;--about ?? free bytes here

FREE set FREE -.


   align 256
FREE set FREE +.


DigitData

Seven
        .byte #%00011000;--
        .byte #%00011000;--
        .byte #%00001100;--
        .byte #%00000110;--
;        .byte #%01111110;--         ;shared with next table
One
        .byte #%01111110;--
        .byte #%00011000;--
        .byte #%00011000;--
        .byte #%00111000;--
        .byte #%00011000;--
Five
        .byte #%01111100;--
        .byte #%00000110;--
        .byte #%01111100;--
        .byte #%01100000;--
;        .byte #%01111110;--         ;shared with next table
Two
        .byte #%01111110;--
        .byte #%00011000;--
        .byte #%00001100;--
        .byte #%01100110;--
;        .byte #%00111100;--         ;shared with next table
Three
        .byte #%00111100;--
        .byte #%01100110;--
        .byte #%00001100;--
        .byte #%01100110;--
;        .byte #%00111100;--         ;shared with next table


Six
        .byte #%00111100;--
        .byte #%01100110;--
        .byte #%01111100;--
        .byte #%01100000;--
;        .byte #%00111100;--         ;shared with next table

Nine
        .byte #%00111100;--
        .byte #%00000110;--
        .byte #%00111110;--
        .byte #%01100110;--
;        .byte #%00111100;--         ;shared with next table
Eight
        .byte #%00111100;--
        .byte #%01100110;--
        .byte #%00111100;--
        .byte #%01100110;--
;        .byte #%00111100;--         ;shared with next table
Novice2
Normal2
Zero
        .byte #%00111100;--
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%00111100;--
Four
        .byte #%00001100;--
        .byte #%01111110;--
        .byte #%01101100;--
        .byte #%01101100;--
        .byte #%01100000;--


ColonGfx
        .byte #%00000000;--
        .byte #%00100000;--
        .byte #%00000000;--
        .byte #%00100000;--
;        .byte #%00000000;--      shared with next table
BlankDigit
Child6
   .byte 0,0,0,0;,0      ;shared with next table
Maids2
        .byte #%00000000;--
        .byte #%01110100;--
        .byte #%01010111;--
        .byte #%01010101;--
        .byte #%01010111;--
Maids1
        .byte #%00000111;--
        .byte #%01010010;--
        .byte #%00100010;--
        .byte #%01010110;--
        .byte #%00000010;--

Novice5
Child1
        .byte #%00111100;--
        .byte #%01100110;--
        .byte #%01100000;--
        .byte #%01100110;--
        .byte #%00111100;--
Child2
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%01111110;--
        .byte #%01100110;--
;        .byte #%01100110;--      ;shared with next table
Novice1
Normal1
        .byte #%01100110;--
        .byte #%01101110;--
        .byte #%01111110;--
        .byte #%01110110;--
;        .byte #%01100110;--      ;shared with next table

Normal3
Expert5
        .byte #%01100110;--
        .byte #%01101100;--
        .byte #%01111100;--
        .byte #%01100110;--
        .byte #%01111100;--
Novice4
Child3
        .byte #%01111110;--
        .byte #%00011000;--
        .byte #%00011000;--
        .byte #%00011000;--
        .byte #%01111110;--
Child4
Normal6
        .byte #%01111110;--
        .byte #%01100000;--
        .byte #%01100000;--
        .byte #%01100000;--
        .byte #%01100000;--
Child5
        .byte #%01111100;--
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%01111100;--

Normal4
        .byte #%01100011;--
        .byte #%01101011;--
        .byte #%01111111;--
        .byte #%01110111;--
        .byte #%01100011;--

Expert6
        .byte #%00011000;--
        .byte #%00011000;--
        .byte #%00011000;--
        .byte #%00011000;--
;        .byte #%01111110;--      ;shared with next table
Expert1
Expert4
Novice6
        .byte #%01111110;--
        .byte #%01100000;--
        .byte #%01111100;--
        .byte #%01100000;--
        .byte #%01111110;--
Novice3
        .byte #%00011000;--
        .byte #%00111100;--
        .byte #%01100110;--
        .byte #%01100110;--
;        .byte #%01100110;--      ;shared with next table
Expert2
        .byte #%01100110;--
        .byte #%00111100;--
      .byte #%00011000
        .byte #%00111100;--
;        .byte #%01100110;--      ;shared with next table
Normal5
        .byte #%01100110;--
        .byte #%01111110;--
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%00111100;--
Expert3
        .byte #%01100000;--
        .byte #%01111100;--
        .byte #%01100110;--
        .byte #%01100110;--
        .byte #%01111100;--

  CHECKPAGE DigitData

CopyrightSymbolGfx
        .byte #%00111100;--
        .byte #%01011010;--
        .byte #%01010010;--
        .byte #%01011010;--
        .byte #%00111100;--











AUDFTable
   .byte 14,15,16,17,19,20,22,23      ;CBbBAGF#FE
   .byte 26,28,29,11,14,15,16,17      ;DC#CAFEEbD
   .byte 18,19,20,22,23,26,27,29   ;C#CBBbAGF#F
   .byte 31,6,10,10,10,10,10,00      ;ED         other values unused and therefore unnecessary (?).  Seem to be necessary?
                              ;         Look into that.
AUDCTable
   .byte 4,4,4,4,4,4,4,4
   .byte 4,4,4,12,12,12,12,12
   .byte 12,12,12,12,12,12,12,12
   .byte 12,6,10,10,10,10,10,00      ;other values unused and therefore unnecessary (?)

   ;--NOTE CONSTANTS
C6      =      0
B5      =      1
Bb5      =      2
A5      =      3
G5      =      4
Fs5      =      5
F5      =      6
E5      =      7
D5      =      8
Cs5      =      9
C5      =      10
A4      =      11
F4      =      12
E4      =      13
Eb4      =      14
D4      =      15
Cs4      =      16
C4      =      17
B3      =      18
Bb3      =      19
A3      =      20
G3      =      21
Fs3      =      22
F3      =      23
E3      =      24
D3      =      25

REST   =      31

CompleteLevelSongC0
   .byte VOLUMECHANGE|V6
   .byte SIXTEENTH|REST

   .byte SLUR|THIRTYSECOND|C6
   .byte SLUR|THIRTYSECOND|G5
   .byte SLUR|THIRTYSECOND|E5
   .byte SLUR|THIRTYSECOND|C5

   .byte SLUR|THIRTYSECOND|D5
   .byte SLUR|THIRTYSECOND|E5
   .byte SLUR|THIRTYSECOND|F5
   .byte SLUR|THIRTYSECOND|G5

   .byte SLUR|THIRTYSECOND|D5
   .byte SLUR|THIRTYSECOND|G5
   .byte SLUR|THIRTYSECOND|A5
   .byte SLUR|THIRTYSECOND|B5

   .byte SLUR|EIGHTH|C6
   .byte SLUR|QUARTER|REST
   .byte SLUR|QUARTER|REST

   .byte INDEXCHANGE,16

CompleteLevelSongC1
   .byte VOLUMECHANGE|V6
   .byte SIXTEENTH|REST

   .byte SLUR|THIRTYSECOND|G5
   .byte SLUR|THIRTYSECOND|E5
   .byte SLUR|THIRTYSECOND|C5
   .byte SLUR|THIRTYSECOND|E4

   .byte SLUR|THIRTYSECOND|D4
   .byte SLUR|THIRTYSECOND|C4
   .byte SLUR|THIRTYSECOND|D4
   .byte SLUR|THIRTYSECOND|E4

   .byte SLUR|THIRTYSECOND|G3
   .byte SLUR|THIRTYSECOND|B3
   .byte SLUR|THIRTYSECOND|C4
   .byte SLUR|THIRTYSECOND|D4

   .byte SLUR|SIXTEENTH|G3
   .byte SLUR|SIXTEENTH|A3
   .byte SLUR|SIXTEENTH|B3
   .byte SLUR|EIGHTH|C4
   .byte SLUR|SIXTEENTH|REST
   .byte SLUR|QUARTER|REST

   .byte INDEXCHANGE,19

DeathSongC0
   .byte VOLUMECHANGE|V6
   .byte SIXTEENTH|REST

   .byte SLUR|QUARTER|C6
   .byte SLUR|EIGHTH|C6
   .byte SLUR|QUARTER|Bb5
   .byte SLUR|EIGHTH|Bb5
   .byte SLUR|EIGHTH|F5
   .byte EIGHTH|Bb5
;   .byte SLUR|SIXTEENTH|Bb5

   .byte REST|SIXTEENTH
   .byte SLUR|SIXTEENTH|A5
   .byte SLUR|SIXTEENTH|G5
   .byte SLUR|SIXTEENTH|Fs5
   .byte SLUR|QUARTER|F4
   .byte SLUR|EIGHTH|F4
DeathSongC0Repeat
   .byte QUARTER|REST
   .byte INDEXCHANGE,DeathSongC0Repeat-DeathSongC0

DeathSongC1
   .byte VOLUMECHANGE|V4
   .byte SIXTEENTH|REST

   .byte SLUR|EIGHTH|C4
   .byte SLUR|EIGHTH|Eb4
   .byte EIGHTH|C4
   .byte SLUR|EIGHTH|Bb3
   .byte SLUR|EIGHTH|Cs4
   .byte SLUR|EIGHTH|Bb3
   .byte SLUR|EIGHTH|F3
   .byte EIGHTH|G3
;   .byte SLUR|SIXTEENTH|G3

   .byte REST|SIXTEENTH
   .byte SLUR|SIXTEENTH|F3
   .byte SLUR|EIGHTH|Fs3
   .byte SLUR|QUARTER|F3
   .byte SLUR|EIGHTH|F3
DeathSongC1Repeat
   .byte QUARTER|REST
   .byte INDEXCHANGE,DeathSongC1Repeat-DeathSongC1

;InitialElevVelPtrs
 ;  .byte <ChildElevVel,<NoviceElevVel,<NormalElevVel,<ExpertElevVel
;InitialElevYPtrs
;   .byte <ChildElevY,<NoviceElevY,<NormalElevY,<ExpertElevY



ChildElevY
   .byte PLAYAREAHEIGHT+1,48,PLAYAREAHEIGHT+1,PLAYAREAHEIGHT+1,PLAYAREAHEIGHT+1,48,PLAYAREAHEIGHT+1
NoviceElevY
   .byte 48,PLAYAREAHEIGHT+1,48,PLAYAREAHEIGHT+1,48,PLAYAREAHEIGHT+1,48
ExpertElevY
NormalElevY
   .byte 38,44,48,54,47,43,37

ChildElevVel
   .byte 0,$80|2,$81,0,2,0,3
NoviceElevVel
NormalElevVel
   .byte 5,7,$80|5,$80|7,8,6,5
ExpertElevVel
   .byte 20,15,$80|30,25,$80|21,$80|24,35

   ;--next four tables share values with each other.
ArticulationTable      ;shares three bytes (all zeros) with following table
   .byte 6,1
   .byte 0,0,0;,0,0,0

AddTable
   .byte 0,0,0,1,1,1,1,2

BackgroundColorTable      ;needs to start at least one byte past page boundary
                     ;   and needs to stay on one page
   ds 2,FLOOR1COLOR-2
   ds 8,FLOOR1COLOR
   ds 2,FLOOR2COLOR-2
   ds 8,FLOOR2COLOR
   ds 2,FLOOR3COLOR-2
   ds 8,FLOOR3COLOR
   ds 2,FLOOR4COLOR-2
   ds 8,FLOOR4COLOR
   ds 2,FLOOR5COLOR-2
   ds 8,FLOOR5COLOR
   ds 2,FLOOR6COLOR-2
   ds 8,FLOOR6COLOR
   ds 2,FLOOR7COLOR-2
   ds 8,FLOOR7COLOR
   ds 2,FLOOR8COLOR-2
   ds 8,FLOOR8COLOR

DigitDataLo
   .byte <Zero,<One,<Two,<Three,<Four,<Five,<Six,<Seven,<Eight,<Nine

SaveKeyJumpTableLo
	.byte <StartEEPROMWriteSubroutine,<WriteAddressHiSubroutine
	.byte <WriteAddressLoSubroutine,<i2c_stopwrite
	.byte <ReadByteSubroutine,<ReadByteSubroutine
	.byte <ReadByteSubroutine
	.byte <EvaluateHighScoreSubroutine
	.byte <StartEEPROMWriteSubroutine,<WriteAddressHiSubroutine
	.byte <WriteAddressLoSubroutine
	.byte <WriteByteSubroutine,<WriteByteSubroutine
	.byte <WriteByteSubroutine,<i2c_stopwrite
	.byte <DoneWritingSubroutine

SaveKeyJumpTableHi
	.byte >StartEEPROMWriteSubroutine,>WriteAddressHiSubroutine
	.byte >WriteAddressLoSubroutine,>i2c_stopwrite
	.byte >ReadByteSubroutine,>ReadByteSubroutine
	.byte >ReadByteSubroutine
	.byte >EvaluateHighScoreSubroutine
	.byte >StartEEPROMWriteSubroutine,>WriteAddressHiSubroutine
	.byte >WriteAddressLoSubroutine
	.byte >WriteByteSubroutine,>WriteByteSubroutine
	.byte >WriteByteSubroutine,>i2c_stopwrite
	.byte >DoneWritingSubroutine

EvaluateHighScoreSubroutine

	lda SaveKeyFlags
	bpl DoneAccessingSaveKey
	;--else we must evaluate the newly-loaded high score - is it greater than the player's score?

	ldx #0
CheckHighScoreLoop
	lda HighScore,X
	cmp Score,X
	bcc NewHighScore
	bne NoNewHighScore
	;--else HighScore,X == Score,X so move down to next pair of digits.
	inx
	cpx #3
	bne CheckHighScoreLoop
	;--if we've reached this point then the player has tied the high score so it
	;	doesn't matter whether we treat it as a new high score or not.
NoNewHighScore
DoneAccessingSaveKey
	lda #0
	sta SaveKeyFlags
NewHighScore		;--new high score means don't do anything - SAVEKEYSTEP_BITS index already updated
	rts

DoneWritingSubroutine
	lda #0
	sta SaveKeyFlags
	ldx #Score
	ldy #HighScore
;	jmp CopyScoreLoopSubroutine		;return from there
	

CopyScoreLoopSubroutine
	lda #3
	sta Temp+3			;
CopyScoreLoop
	lda $02,X
	sta $0002,Y
	dex
	dey
	dec Temp+3
	bne CopyScoreLoop

	rts

WriteByteSubroutine
	lda SaveKeyFlags
	and #SAVEKEYSTEP_BITS
	sec
	sbc #13				;get index between 0 and 2
	tax
	lda Score,X
	jmp i2c_txbyte		;branch always


   ;--about 0 free bytes here


FREE set FREE - .
   align 256
FREE set FREE + .



ElevatorSpeedTable
   .byte %11111111,%11111111
   .byte %00000000,%00000000
   .byte %00000000,%00001001
   .byte %00000000,%01110110
   .byte %00000001,%10000001
   .byte %00000110,%00001110
   .byte %00001000,%01110001
   .byte %00000000,%10001110
   .byte %00010001,%00010001
   .byte %00000010,%00100110
   .byte %00100000,%01001001
   .byte %00000100,%10010010
   .byte %00000001,%00101101
   .byte %00001000,%01000010
   .byte %00000010,%10010101
   .byte %00000000,%00101010

   .byte %01010101,%01010101
   .byte %00000000,%00101010
   .byte %00000010,%10000001
   .byte %00001000,%01010100
   .byte %00000001,%00101011
   .byte %00100100,%10000100
   .byte %00000000,%01011011
   .byte %00000010,%00100100
   .byte %00010001,%00010011
   .byte %00000000,%10001100
   .byte %00001000,%01100011
   .byte %00000110,%00011000
   .byte %00000001,%10000111
   .byte %00000000,%01100000
   .byte %00000000,%00011111
   .byte %00000000,%00000000

ElevPtrTableLo
   .byte <ElevRAM,<ElevRAM,<ElevRAM+NUM_RAMBANDS,<ElevRAM+NUM_RAMBANDS
   .byte <ElevRAM+[NUM_RAMBANDS*2],<ElevRAM+[NUM_RAMBANDS*3],<ElevRAM+[NUM_RAMBANDS*3]


SpeedMaskTable
   .byte $80,$40,$20,$10,$08,$04,$02,$01

LengthLookupTable
   .byte $00,$10,$30,$70

MaxExtraLifeLevelTable   ;level at which you stop getting extra lives, for each difficulty
                  ;   (child, novice, normal, expert)
   .byte $99,$99,$11,$04

;ChildElevVel
;   .byte 0,$80|2,$81,0,2,0,3
InitialElevVelPtrs
   .byte <ChildElevVel,<NoviceElevVel,<NormalElevVel,<ExpertElevVel

ElevatorColorTable         ;for each level
   .byte ELEVCOLOR_LVL0,ELEVCOLOR_LVL1,ELEVCOLOR_LVL2,ELEVCOLOR_LVL3
   .byte ELEVCOLOR_LVL4,ELEVCOLOR_LVL5,ELEVCOLOR_LVL6,ELEVCOLOR_LVL7
   .byte ELEVCOLOR_LVL8,ELEVCOLOR_LVL9

SongPtr = .-4
	.word GameplaySongC0,GameplaySongC1,CompleteLevelSongC0,CompleteLevelSongC1
   .word DeathSongC0,DeathSongC1

WriteAddressLoSubroutine
	lda GameFlags
	and #GAMEDIFF_BITS		;0-6
	asl						;0-12		(clears carry also)
;	adc #<SAVEKEYADDRESS	;low address is zero, so not necessary!
	jmp i2c_txbyte		;return from there

GameDiffUpdateTable
   .byte %00000010,%00000010,%00000010,%11111010

   ;--about 1 free bytes here

FREE set FREE - .
   org $FE80
FREE set FREE + .



Frame3a            ;all black
        .byte 0
        .byte #%01111111;--
        .byte #%01111000;--
        .byte #%00000000;--
        .byte #%00011110;--
        .byte #%00111000;--
        .byte #%01110000;--
        .byte #%00011110;--
        .byte 0;,0               ;shared with next table
Frame1b      ;--all black.
        .byte 0
        .byte #%01111111;--
        .byte #%01111000;--
        .byte #%00000000;--
        .byte #%00011110;--
        .byte #%00000000;--
        .byte #%01111000;--
        .byte #%00111000;--
        .byte #%00001100;--
Frame1a            ;all black
        .byte 0
        .byte #%01111100;--
        .byte #%00111000;--
        .byte #%00011100;--
        .byte #%00011110;--
        .byte #%00111000;--
        .byte #%01110000;--
        .byte #%00011110;--
        .byte 0;,0            ;shared with next table

Frame2b   ;--color
      .byte 0
        .byte #%00010010;$0E
        .byte #%00000011;$0E
        .byte #%00000111;$0E
        .byte #%00000000;$0E
        .byte #%00000000;$0E
        .byte #%00000100;$FA
        .byte #%00001110;$FA
;       .byte 0,0            ;shared with next table
Frame2a      ;--color
        .byte 0,0
        .byte #%00000111;$0E
        .byte #%00011110;$0E
        .byte #%00000000;$0E
        .byte #%00001100;$0E
        .byte #%00000110;$FA
        .byte #%00000110;$FA
;      .byte 0,0            ;shared with next table
Frame4a      ;--color
        .byte 0,0
        .byte #%00000011;$0E
        .byte #%00000111;$0E
        .byte #%00000000;$0E
        .byte #%00001100;$0E
        .byte #%00000110;$FA
        .byte #%00000110;$FA
        .byte 0;,0            ;shared with next table
Frame4b   ;--color
        .byte 0
        .byte #%00001100;$0E
        .byte #%00000000;$0E
        .byte #%00000111;$0E
        .byte #%00011110;$0E
        .byte #%00000000;$0E
        .byte #%00000100;$FA
        .byte #%00001110;$FA
        .byte 0;,0            ;shared with next table

Frame3b            ;all black
        .byte 0
        .byte #%01111111;--
        .byte #%01111100;--
        .byte #%00111000;--
        .byte #%00011110;--
        .byte #%00000000;--
        .byte #%01111000;--
        .byte #%00111000;--
        .byte #%00001100;--
      .byte 0
ColorFrame4
ColorFrame2
      .byte #APRONCOLOR
      .byte #APRONCOLOR
        .byte #APRONCOLOR
        .byte #APRONCOLOR
        .byte #APRONCOLOR
        .byte #APRONCOLOR
        .byte #MAIDFACECOLOR
        .byte #MAIDFACECOLOR
        .byte #MAIDFACECOLOR

MaidGfxLoByteTable
   .byte <ColorFrame2+9,<ColorFrame2+9
   .byte <Frame3b+9,<Frame1b+9,<Frame3a+9,<Frame1a+9
   .byte <Frame4b+9,<Frame2b+9,<Frame4a+9,<Frame2a+9



   ;--for now: AUDC1 and AUDV1 values (in order) are followed by AUDF1 values
   ;   AUDF1 values are used in backwards order
   ;   Last volume value must be zero to turn off SFX.
SFXFloorCompleteFreqTable
   .byte 11,11,12,12,12,14,14,14,16,16,16

;NoSongC0
;NoSongC1
;   .byte QUARTER|REST
;   .byte INDEXCHANGE      ;,0      ;share 1 byte with next table

   ;--for now: AUDC1 and AUDV1 values (in order) are followed by AUDF1 values
   ;   AUDF1 values are used in backwards order; first value is unused (for now)
   ;   since volume is zeroes (to turn off) on last value.
SFXFloorCompleteVolumeTable
   .byte 0,6,0,0,6,0,0,6,0,0,6

ElevFlipTable
   .byte %00110000,%00000011,%00011000,%10000000,%00011000,%00000011,%00110000
;ExpertElevY
;NormalElevY
;   .byte 38,44,48,54,47,43,37
InitialElevYPtrs
   .byte <ChildElevY,<NoviceElevY,<NormalElevY,<ExpertElevY

WriteAddressHiSubroutine
	lda #>SAVEKEYADDRESS
	jmp i2c_txbyte		;return from there

   ;--about 0 free bytes here

FREE set FREE - .
   align 256
FREE set FREE + .


StairCaseTable         ;pattern is 20 bytes long
   .byte RIGHTSEVEN
   .byte 0
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTTWO
   .byte 0|1
   .byte LEFTSEVEN
   .byte 0
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTTWO
   .byte 0|1
   .byte RIGHTSEVEN
   .byte 0
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTTWO
   .byte 0|1
   .byte LEFTSEVEN
   .byte 0
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTTWO
   .byte 0|1
   .byte RIGHTSEVEN
   .byte 0
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTTWO
   .byte 0|1
   .byte LEFTSEVEN
   .byte 0
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTONE
   .byte RIGHTTWO
   .byte 0|1
   .byte RIGHTSEVEN
   .byte 0
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte LEFTONE
   .byte 0|1
   .byte 0|1
   .byte 0
   .byte 0|1
   .byte 0|1
   .byte 0|1
   .byte 0|1
   .byte 0|1
   .byte 0|1
   .byte 0|1
   .byte 0|1
   .byte 0|1

  CHECKPAGE StairCaseTable

DeathMovement
   .byte HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON
   .byte HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON
   .byte HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON
   .byte HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON
   .byte HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON
   .byte HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON
   .byte HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON
   .byte HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON, HORZ_NON|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON, HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON, HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON, HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON, HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON, HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON, HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_POS|VERT_NON, HORZ_NEG|VERT_NON;, HORZ_POS|VERT_NON

NextFloorMovementL
   .byte HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_POS|VERT_NON, HORZ_POS|VERT_POS, HORZ_POS|VERT_POS, HORZ_NON|VERT_POS
   .byte HORZ_NON|VERT_POS, HORZ_NEG|VERT_POS, HORZ_NEG|VERT_POS, HORZ_NEG|VERT_POS
   .byte HORZ_NEG|VERT_POS, HORZ_NEG|VERT_POS, HORZ_NEG|VERT_POS;, HORZ_NEG|VERT_NON

NextFloorMovementR:
   .byte HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_NEG|VERT_POS, HORZ_NEG|VERT_POS, HORZ_NON|VERT_POS
   .byte HORZ_NON|VERT_POS, HORZ_POS|VERT_POS, HORZ_POS|VERT_POS, HORZ_POS|VERT_POS
   .byte HORZ_POS|VERT_POS, HORZ_POS|VERT_POS, HORZ_POS|VERT_POS;, HORZ_POS|VERT_NON

CompleteBuildingMovement
   .byte HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON, HORZ_POS|VERT_NON
   .byte HORZ_NON|VERT_NEG
   .byte HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON
   .byte HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON, HORZ_NEG|VERT_NON


BackGroundEORTable
   .byte BGCOLOR_LVL0,BGCOLOR_LVL1,BGCOLOR_LVL2,BGCOLOR_LVL3
   .byte BGCOLOR_LVL4,BGCOLOR_LVL5,BGCOLOR_LVL6,BGCOLOR_LVL7
   .byte BGCOLOR_LVL8,BGCOLOR_LVL9



; belong together!
CopyrightPtrTbl:
   .byte <Seven, <Zero, <Zero, <Two, <BlankDigit, <CopyrightSymbolGfx
DiffDisplayLo
   .byte <Child6, <Child5, <Child4, <Child3, <Child2, <Child1
   .byte <Novice6,<Novice5,<Novice4,<Novice3,<Novice2,<Novice1
   .byte <Normal6,<Normal5,<Normal4,<Normal3,<Normal2,<Normal1
   .byte <Expert6,<Expert5,<Expert4,<Expert3,<Expert2,<Expert1

InitTbl:
   .byte 0, 0, 0                ; Score
   .byte $99, 0, STARTINGLIVES, STARTINGLEVEL       ; Timer, HeroMovementCounter, Lives, Level
   .byte 10, 16                 ; HeroY, HeroX

   ;--about 0 bytes free

FREE set FREE - .
   org $FFFC
FREE set FREE + .
   .word Start
   .word Start       ; TODO: use break vector

  echo "*** free ROM:", FREE, "bytes ***"