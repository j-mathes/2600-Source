;
;
; UU   UU  LL     TTTTTT  RRRRRR  AAAAAAA
; UU   UU  LL       TT    RR   R  AA   AA
; UU   UU  LL       TT    RRRRRR  AAAAAAA
; UU   UU  LL       TT    RR  R   AA   AA
; UUUUUUU  LLLLLLL  TT    RR   R  AA   AA
;
;
; SSSSSSSSSSS CCCCCCCCCCCC SSSSSSSSSSS III                       dd
; SSSSSSSSSSS CC      CCCC SSSSSSSSSSS III                       dd
; SS       SS CC      CCCC SS       SS III           iii         dd
; SS       SS CC      CCCC SS       SS III           iii         dd
; SS       SS CC      CCCC SS       SS III                       dd
; SS       SS CC      CCCC SS       SS III                       dd
; SS          CC           SS          III  cccccccc ii   ddddddddd eeeeeeeee
; SSSSSSSSSSS CC           SSSSSSSSSSS III  cccccccc ii   ddddddddd eeeeeeeee
; SSSSSSSSSSS CC           SSSSSSSSSSS IIII cc  cccc ii   dddd   dd eeee   ee
;        SSSS CC        CC        SSSS IIII cc  cccc ii   dddd   dd eeee   ee
;        SSSS CC        CC        SSSS IIII cc       iiii dddd   dd eeeeeeeee
; SS     SSSS CC        CC SS     SSSS IIII cc       iiii dddd   dd eeeeeeeee
; SS     SSSS CC        CC SS     SSSS IIII cc       iiii dddd   dd eeee
; SS     SSSS CC        CC SS     SSSS IIII cc    cc iiii dddd   dd eeee   ee
; SS     SSSS CC        CC SS     SSSS IIII cc    cc iiii dddd   dd eeee   ee
; SSSSSSSSSSS CCCCCCCCCCCC SSSSSSSSSSS IIII cccccccc iiii ddddddddd eeeeeeeee
; SSSSSSSSSSS CCCCCCCCCCCC SSSSSSSSSSS IIII cccccccc iiii ddddddddd eeeeeeeee
;
; The Atari VCS Game Concept
;
; Copyright (c) 2001, 2005 Pixels Past, a division of Grand Idea Studio, Inc.
; By Joe Grand, joe@grandideastudio.com
;
; dasm source.s -f3 -osource.bin to compile
; z26 -)PC source.bin to force paddle
; z26 -)JS source.bin to force joystick
;
;
; NEW ADDITIONS
;
; o Fixed the FLICKER that used to occur at the beginning of each level (taking too much time on calculations)
; o Added automatic controller support drivehead control (hit paddle or joystick fire button to start game)
; o Changed background and data bit color palette to make bits easier to distinguish
; o Reduced track size from 10 to 8 (one byte per level)
; o Changed speed increase per level - two random data bits at a time
; o Modified the scoring routines to account for longer gameplay and higher levels
; o Adjusted easter egg trigger and text
; o Changed title screen text and added GIS and PP logos
; o Major source code clean-up
; o Added NTSC/PAL selection via ASSEMBLER compile-time switch
; o Adjusted screen drawing routines for a proper scanline count (both NTSC and PAL)
; o Adjusted joystick control sensitivity for PAL systems
; o Optimized sound routine and added different pitched correct data bit sound depending on track
;
;
; TO DO
;
; o Nothing!
;
;

   LIST OFF                         ; don't print the header file equates or comments in the list file

        processor 6502
        include vcs.h

   LIST ON

;============================================================================
; A S S E M B L E R - S W I T C H E S
;============================================================================

NTSC                    = 0
PAL                     = 1

COMPILE_VERSION         = NTSC      ; change this to compile for different
                                    ; regions -- this changes colors and
                                    ; display timing
                                    ; (NTSC 60 fps & PAL 50 fps)

NO                      = 0
YES                     = 1

;============================================================================
; C O N S T A N T S
;============================================================================
        SEG.U defines

NUMGRP                  = 8    ; Number of graphics (player 1 data)
GRPHEIGHT               = 8    ; Height of each graphic

XMIN                    = 8
XMAX                    = 158

YTOP                    = 1     ; Top-most line of playfield (as drawn in two-line kernel)
YBOTTOM                 = 64    ; Bottom-most line of playfield

HORPOS_P0               = 148   ; Horizontal position player 0 (drivehead) - fixed

SOUND_CORRECT           = $8F   ; Correct data bit
SOUND_INCORRECT         = $5C   ; Incorrect data bit
SOUND_MISSED            = $2E   ; Data bit missed

SOUND_AMBIENT_MAX_PITCH = 26    ; Starting background pitch
SOUND_CORRECT_PITCH_0   = 6
SOUND_CORRECT_PITCH_1   = 7
SOUND_CORRECT_PITCH_2   = 8
SOUND_CORRECT_PITCH_3   = 9
SOUND_CORRECT_PITCH_4   = 10
SOUND_CORRECT_PITCH_5   = 11
SOUND_CORRECT_PITCH_6   = 12
SOUND_CORRECT_PITCH_7   = 13

COLOR_REPEAT            = 9     ; Number of times to repeat with the same data for title drawing

;----------------------------------------------------------------------------
; color constants
;

COLOR_BLACK           = $00
COLOR_WHITE           = $0F

   IF COMPILE_VERSION = NTSC

COLOR_RED             =  $42
COLOR_PP_ORANGE       =  $2B
COLOR_YELLOW          =  $1E
COLOR_GREEN           =  $C4
COLOR_GIS_GREEN       =  $D8
COLOR_SKY_BLUE        =  $9C
COLOR_PURPLE          =  $57
COLOR_PINK            =  $3F
COLOR_BROWN           =  $20
COLOR_LTBROWN         =  $22
COLOR_WOOD_BROWN      =  $F2
COLOR_GREY            =  $06

   ELSE

COLOR_RED             =  $64
COLOR_PP_ORANGE       =  $49
COLOR_YELLOW          =  $2D
COLOR_GREEN           =  $54
COLOR_GIS_GREEN       =  $58
COLOR_SKY_BLUE        =  $BC
COLOR_PURPLE          =  $C4
COLOR_PINK            =  $6E
COLOR_BROWN           =  $20
COLOR_LTBROWN         =  $22
COLOR_WOOD_BROWN      =  $42
COLOR_GREY            =  $0A

   ENDIF

;----------------------------------------------------------------------------
; region frame time values
;

   IF COMPILE_VERSION = NTSC

VBLANK_TIME     =  44         ; ((37 scanlines * 76 cycles) - 14) / 64
OVERSCAN_TIME   =  34         ; ((30 scanlines * 76 cycles) - 14) / 64

   ELSE

;----------------------------------------------------------------------------
; PAL frame constants
;
; Usual VBLANK is 45 lines, but the values below account for only 192 lines
; of actual display to stay consistent with NTSC
;
VBLANK_TIME      =  75         ; ((63 scanlines * 76 cycles) - 14) / 64
OVERSCAN_TIME    =  62         ; ((53 scanlines * 76 cycles) - 14) / 64

   ENDIF

;============================================================================
; Z P - V A R I A B L E S
;============================================================================
        SEG.U vars
        org $80

; There is only 128 bytes of RAM available to the programmer. Locations
; $80 - $FF are available for RAM use. Stack goes up from $FF.
;

temp                    ds      1       ; Temporary variable
temp_stack              ds      1       ; Temporary variable
loopCount               ds      1       ; Counter for loops
startDelay              ds      1       ; Timer for switch debounce
random                  ds      1       ; Holder for random number generator
newGameFlag             ds      1       ; Set to 1 when game is just starting, 0 after first level data is configured
isNextLevel             ds      1       ; Are we still processing next level data?
controllerType          ds      1       ; Controller type for auto-detect (0 for paddle, 1 for joystick)
pot0                    ds      1       ; Player 0's paddle value
joy0                    ds      1       ; Player 0's joystick value
horPosP1                ds      NUMGRP  ; Horizontal position player 1 (data)
horPosP1_FC             ds      NUMGRP  ; Horizontal position player 1 FC values
horMotP1                ds      NUMGRP  ; Motion values player 1 (data)
horMotP1_Real           ds      NUMGRP  ; Real motion values player 1 (horMotP1 gets clobbered each level)
verPosP0                ds      1       ; Vertical position player 0 (drivehead)
grpCount                ds      1       ; Group counter
grpY                    ds      NUMGRP
grpY_Next               ds      1       ; First line of next group
grpDistance             ds      1       ; Distance between player0 and top of group
gameInProgress          ds      1       ; Flag set when game is in progress
levelDone               ds      1       ; Flag set when level is completed
titleScreen             ds      1       ; Flag set when title screen should be disabled
soundType               ds      1
ambientPitch            ds      1       ; Current pitch for ambient noise
currentPitch            ds      1       ; Current pitch for correct data bit (depends on track number)
headSize                ds      1       ; Size of drivehead based on difficulty switch
coll                    ds      NUMGRP  ; Collision flags
nodata                  ds      1
nocc                    ds      1
color0                  ds      1       ; For color cycling, top of the current line
color1                  ds      1
currentSpeed            ds      1       ; Current data bit speed
currentDataColor        ds      1       ; Color of data to match
dataColorIndex          ds      1       ; Index to the next data color in table
dataColorTable          ds      NUMGRP  ; Color order of data for current level
nextColorTable          ds      NUMGRP  ; Color order of data to match for current level
score                   ds      3       ; Player score (6 hex digits: 00 00 00)
                                        ;                             /   |   \
                                        ;                          score  +1   +2
                                        ;                 Platter Level  Actual Score
scorePtr0               ds      2       ; Pointer to score shapes
scorePtr1               ds      2
scorePtr2               ds      2
scorePtr3               ds      2
scorePtr4               ds      2
scorePtr5               ds      2
bitCount                ds      1       ; Number of data bits read
bitCount_PF             ds      3       ; PF0, PF1 and PF2 (2nd half of screen)
gauge_PF                ds      2       ; Data latency buffer, PF0 and PF1 (1st half of screen)


   echo "***",*-$80, "BYTES OF RAM USED", $80 - (*-$80), "BYTES FREE"


        SEG code
        org $F000       ; 4K ROM

        .byte "Ultra SCSIcide v2.0 "

   IF COMPILE_VERSION = NTSC
        .byte "NTSC, "
   ELSE
        .byte "PAL, "
   ENDIF

        .byte "January 15, 2005, "
        .byte "Joe Grand [joe@grandideastudio.com]"

;----------------------------------------------------------Start
;
Start
;
; The 2600 powers up in a completely random state, except for the PC which
; is set to the location at $FFC.  Therefore the first thing we must do is
; to set everything up inside the 6502.
;

        SEI             ; Disable interrupts, if there are any.
        CLD             ; Clear BCD math bit.
        LDX  #$FF
        TXS             ; Set stack to beginning.

        LDY INTIM       ; For random number seed

        ; Loop to clear memory and TIA registers
        ;
        ; The 2600 has 128 bytes of RAM. This routine will not clear VSYNC
        ;
        LDA  #0
B1      STA  0,X
        DEX
        BNE  B1

        JSR  GameInitialization         ; Initial variable and register setup
MainLoop
        JSR  VerticalSync               ; Execute the vertical sync.
        JSR  CheckConsoleSwitches       ; Check console switches.
        JSR  GameCalculations           ; Do calculations during VBLANK
        JSR  DrawScreen                 ; Draw the screen
        JSR  OverScan                   ; Do more calculations during overscan
        JMP  MainLoop                   ; Continue forever.


;----------------------------------------------------------GameInitialization
;
; Initialize the game variables on cart start up. These variables must be
; set for the game to function properly.
;
GameInitialization
        STY  random

        JSR  DataReset          ; We need to set up some of the data before the game starts

        ;
        ; Clear data pointers
        ;
        LDX  #12-1
        LDA  #0
.clearptr
        STA  scorePtr0,X
        DEX
        BPL  .clearptr

        STA  WSYNC
        LDY  #3
.initpos0
        DEY
        BNE  .initpos0
        STA  RESP0

        ; A = 0
        STA  gameInProgress
        STA  titleScreen
        STA  color0

        LDA  #YBOTTOM
        STA  joy0

        LDA  #COLOR_GREEN       ; Color of score and drivehead before the game starts
        STA  currentDataColor

        RTS

;----------------------------------------------------------------VerticalSync
;
; This routine will take care of vertical sync house keeping. Vertical sync
; starts a new television frame. Each frame starts with 3 vertical sync
; lines. These signal to the television to start a new frame.
;
; Beginning of the frame - at the end of overscan.
;
VerticalSync
        LDA  #$82       ; VB_DumpPots & VB_Enable (Thanks Eckhard!)
        STA  VBLANK     ; Discharge paddle potentiometer

        ; Set the timer to go off just before the end of vertical blank space
        LDX  #VBLANK_TIME

        LDA  #2
        STA  WSYNC      ; Make sure VSYNC happens on a new line
        STA  WSYNC

        STA  VSYNC      ; Begin vertical sync, start a new frame
        STA  WSYNC      ; First line of VSYNC
        STA  WSYNC      ; Second line of VSYNC

        LDA  #0
        STA  WSYNC      ; Third and final line of VSYNC
        STA  VSYNC      ; End the VSYNC period

        LDA  #2
        STA  VBLANK     ; Start recharge of paddle capacitor

        STX  TIM64T     ; Set timer for vertical blank wait

        RTS


;--------------------------------------------------------CheckConsoleSwitches
;
; Check the VCS's console switches.
CheckConsoleSwitches
        LDA  SWCHB              ; Read the switches
        LSR                     ; Shift the Reset switch
        ROR                     ; Rotate Reset to Negative flag and Carry has Select
        BMI  .noReset

        ;
        ; Start new game if reset
        ;
        LDA  #1
        STA  gameInProgress
        STA  titleScreen

        JSR  DataReset
        JSR  RefillBuffer       ; Fill latency buffer
        LDA  #1
        STA  levelDone
        RTS
.noReset

        LDA  SWCHB              ; Read the switches
        ASL                     ; Shift the Player 0 Difficulty switch into Carry
        ASL
        ;
        ; Player 0 (Left)
        ;
        BCS  .p0Easy            ; Set size of drivehead
        LDX  #P_Single          ; B
        JMP  .p0Done
.p0Easy
        LDX  #P_Double          ; A
.p0Done
        STX  headSize

        RTS


;------------------------------------------------------------GameCalculations
;
GameCalculations
        JSR  RandomByte  ; Seed the PRNG

        LDA  #1
        STA  pot0

        ;
        ; Check to see if latency buffer is empty. If it is, end game
        ;
        LDA  gauge_PF
        BNE  .gaugeNotEmpty
        JSR  EndGame
.gaugeNotEmpty

        ;
        ; Start new level when paddle/joystick button is pressed
        ;
        LDA  startDelay
        BNE  .debounceDelay

        LDA  levelDone  ; If flag is set...
        BEQ  .noButtonYet
        LDA  #15        ; Delay...
        STA  startDelay
.debounceDelay
        DEC  startDelay
        BNE  .noButtonYet

        LDX  #1
        CPX  newGameFlag        ; If flag is set, game is just starting
        BNE  .dontCheck         ; So auto-select controller type (paddle or joystick)

        LDA  INPT4              ; Has joystick fire button been pressed?
        BMI  .joyNotReady
        STX  controllerType     ; If yes, set controllerType to 1
        JMP  .dontCheck
.joyNotReady
        LDA  SWCHA              ; Has paddle fire button been pressed?
        BMI  .dontCheck
        LDX  #0
        STX  controllerType     ; If yes, set controllerType to 0
   ENDIF

.dontCheck
        LDA  controllerType
        BNE  .p1JoyFire
        LDA  SWCHA              ; Has paddle fire button been pressed?
        JMP  .p1ChkButton
.p1JoyFire
        LDA  INPT4              ; Has joystick fire button been pressed?
.p1ChkButton
        BMI  .noButtonYet
        JSR  NextLevel          ; If yes, begin next level
        JMP  .levelSetupDone
.noButtonYet

        ; Stretch out function over multiple frames to stay
        ; within the timing constraints of VBLANK.
        ; Removes the flicker that occurred at the start of each level.
        LDA  isNextLevel ; Are we still calculating data for the next level?
        BEQ  .levelSetupDone
        CMP  #3
        BEQ  .nextLevel4
        CMP  #2
        BEQ  .nextLevel3
        CMP  #1
        BNE  .levelSetupDone
        JSR  NextLevel2
        JMP  .levelSetupDone
.nextLevel3
        JSR  NextLevel3
        JMP  .levelSetupDone
.nextLevel4
        JSR  NextLevel4
.levelSetupDone

;
; Move data objects horizontally (Courtesy of Piero Cavina PCMSD 1.1 source)
;
        LDX  #NUMGRP-1
.moveLP
        LDA  horPosP1,X         ; Get current position
        CLC
        ADC  horMotP1,X         ; Increment/decrement by motion value
        STA  horPosP1,X
        CMP  #XMIN              ; Are we at the minimum X value (left edge of screen)?
        BCC  .swapX0
        CMP  #XMAX              ; Are we at the maximum X value (right edge of screen)?
        BCS  .swapX
        JMP  .moveDone          ; We must be somewhere in between
.swapX0
        LDA  #XMIN              ; Minimum
        SEC
        SBC  horPosP1,X
        CLC
        ADC  #XMIN
        STA  horPosP1,X
.swapX                          ; Maximum
        LDA  #XMIN              ; Wrap around to the beginning of the track
        STA  horPosP1,X

        ; Is this the current data bit? If so, decrement latency buffer
        LDA  currentDataColor
        CMP  dataColorTable,X
        BNE  .moveDone
        LDA  levelDone          ; If level is not done, game is in progress...
        BNE  .moveDone

        LDA  #SOUND_MISSED      ; Play sound
        STA  soundType

        JSR  DecGauge           ; ...so gauge can be decremented
        JSR  DecScore

.moveDone
        LDA  horPosP1,X         ; Convert X position to FC format
        JSR  Convert
        STA  horPosP1_FC,X
        DEX
        BPL  .moveLP

        LDA  #0
        STA  grpCount           ; Initialize group counter
        STA  grpY               ; First line of first group
        LDA  #GRPHEIGHT+1
        STA  grpY_Next          ; First line of next (second) group
        LDA  verPosP0
        STA  grpDistance

        LDA  SWCHA              ; Have all four directions of P0 been pressed at once?
        AND  #$F0
        BEQ  DrawEgg            ; If so, set score to easter egg text

        ;
        ; Set pointers to number data (based on current score)
        ; score score+1 score+2
        ;
        LDX  #3-1
        LDY  #10
.scoreLoop
        LDA  score,X
        AND  #$0F               ; Mask it
        ASL                     ; Multiply by 8
        ASL
        ASL

        CLC
        ADC  #<FontPage         ; Store the 2-byte pointer
        STA  scorePtr0,Y
        LDA  #0
        ADC  #>FontPage
        STA  scorePtr0+1,Y

        DEY
        DEY

        LDA  score,X
        AND  #$F0               ; Mask it
        LSR                     ; $00,$08,$10,$18,$20, ... ( / 8 = value)

        ADC  #<FontPage         ; Store the 2-byte pointer
        STA  scorePtr0,Y
        LDA  #0
        ADC  #>FontPage
        STA  scorePtr0+1,Y

        DEY
        DEY
        DEX
        BPL  .scoreLoop

        RTS


;------------------------------------------------------------DrawEgg
;
; Load easter egg characters into score pointers
;
DrawEgg
        LDA  #<HeadFrame
        STA  scorePtr0
        LDA  #>HeadFrame
        STA  scorePtr0+1

        LDA  #<J
        STA  scorePtr1
        LDA  #>J
        STA  scorePtr1+1

        LDA  #<G
        STA  scorePtr2
        LDA  #>G
        STA  scorePtr2+1

        LDA  #<HEART
        STA  scorePtr3
        LDA  #>HEART
        STA  scorePtr3+1

        LDA  #<K
        STA  scorePtr4
        LDA  #>K
        STA  scorePtr4+1

        LDA  #<S
        STA  scorePtr5
        LDA  #>S
        STA  scorePtr5+1

        RTS

;----------------------------------------------------------DrawTitleScreen
;
DrawTitleScreen
        ; Set the timer to go off just before the end of actual TV picture to prevent flicker
        ; 192 scanlines * 76 cycles = 14592 cycles / 64 = 228
        LDA  #228
        STA  TIM64T

        LDX  #13
.preDraw
        STA  WSYNC              ; Move down to position title
        DEX
        BNE  .preDraw

        CLC
        LDA  color0             ; What is the color at the top of current line?
        ADC  #$02
        STA  color0             ; Store the new top color
        STA  color1

        ;
        ; Draw SCSIcide title
        ;
        LDY  #COLOR_REPEAT
        LDX  #8-1
.drawTitle
        STA  WSYNC              ; Wait for line to finish
        STA  COLUPF             ; Set new playfield color
        LDA  PFData0,X          ; Get the Xth line for playfield 0 (left half of screen)
        STA  PF0
        LDA  PFData1,X          ; Get the Xth line for playfield 1
        STA  PF1
        LDA  PFData2,X          ; Get the Xth line for playfield 2
        STA  PF2

        NOP
        NOP
        NOP
        NOP

        LDA  PFData3,X          ; Get the Xth line for playfield 0 (right half of screen)
        STA  PF0
        LDA  PFData4,X          ; Get the Xth line for playfield 1
        STA  PF1
        LDA  PFData5,X          ; Get the Xth line for playfield 2
        STA  PF2

        INC  color1             ; Increment color of the next line
        LDA  color1

        DEY
        BNE  .drawTitle
        LDY  #COLOR_REPEAT      ; Number of times to repeat with the same data

        DEX                     ; Done with data yet?
        BPL  .drawTitle         ; If not, do next line

        LDY  #0
        STY  PF0
        STY  PF1
        STY  PF2

        LDX  #14
.postDraw
        STA  WSYNC              ; Add space between logo and text
        DEX
        BNE  .postDraw

        ;
        ; Draw text
        ;
        LDX  #P_TwoClose
        STX  NUSIZ0             ; 2 shapes, close together
        STX  NUSIZ1
        LDA  #COLOR_GIS_GREEN   ; "Grand Idea Studio" Green
        STA  COLUP0
        STA  COLUP1

        ;
        ; Horizontally position P0 and P1
        ;
        STA  HMOVE
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        STA  HMCLR           ;Clear horizontal motion registers
        STA  RESP0           ;Set the X coordinate
        STA  RESP1
        LDA  #$10            ;Move P1 one pixel to the left
        STA  HMP1
        LDA  #$00
        STA  HMP0

        ;
        ; All the shapes end with a shape of zero. This way, I can assume
        ; the video display is pure black after the loop is finished.
        ;
        LDX  #8-1
.drawName
        STA  WSYNC              ; 3 Wait for sync
        STA  HMOVE              ; 3 Move the players (Only first time)
        LDA  NameData0,X        ; 4 Draw the shape
        STA  GRP0               ; 3
        LDA  NameData1,X        ; 4 Draw in player #1
        STA  GRP1               ; 3
        NOP                     ; 2 Waste cycles for horizontal position
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        LDA  NameData3,X        ; 4 Preload the final 2 bytes
        TAY                     ; 2
        LDA  NameData2,X        ; 4
        STA  GRP0               ; 3 Store in shape
        STY  GRP1               ; 3
        STA  HMCLR              ; 3 Clear horiz. motion for future loops

        ; Repeat for double height
        STA  WSYNC              ; 3
        STA  HMOVE
        LDA  NameData0,X        ; 4 Draw the shape
        STA  GRP0               ; 3
        LDA  NameData1,X        ; 4 Draw in player #1
        STA  GRP1               ; 3
        NOP                     ; 2 Waste cycles for horizontal position
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        LDA  NameData3,X        ; 4 Preload the final 2 bytes
        TAY                     ; 2
        LDA  NameData2,X        ; 4
        STA  GRP0               ; 3 Store in shape
        STY  GRP1               ; 3
        STA  HMCLR
        DEX                     ; 2 All done?
        BPL  .drawName          ; 3 Loop

        STA  WSYNC              ; Add space between text and logos
        STA  WSYNC
        STA  WSYNC

        ;
        ; Draw GIS logo
        ;
        LDX  #34-1
.drawGISLogo
        STA  WSYNC              ; 3 Wait for sync
        STA  HMOVE              ; 3 Move the players (Only first time)
        LDA  GISLogoData0,X     ; 4 Draw the shape
        STA  GRP0               ; 3
        LDA  GISLogoData1,X     ; 4 Draw in player #1
        STA  GRP1               ; 3
        NOP                     ; 2 Waste cycles for horizontal position
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        LDA  GISLogoData3,X     ; 4 Preload the final 2 bytes
        TAY                     ; 2
        LDA  GISLogoData2,X     ; 4
        STA  GRP0               ; 3 Store in shape
        STY  GRP1               ; 3
        STA  HMCLR              ; 3 Clear horiz. motion for future loops
        DEX                     ; 2 All done?
        BPL  .drawGISLogo       ; 3 Loop

        STA  WSYNC              ; Add space between text and small logo
        STA  WSYNC
        STA  WSYNC
        STA  WSYNC

        ;
        ; Draw PP logo
        ;
        LDA  #COLOR_PP_ORANGE   ; "Pixels Past" Orange
        STA  COLUP0
        STA  COLUP1

        LDX  #34-1
.drawPPLogo
        STA  WSYNC              ; 3 Wait for sync
        STA  HMOVE              ; 3 Move the players (Only first time)
        LDA  PPLogoData0,X      ; 4 Draw the shape
        STA  GRP0               ; 3
        LDA  PPLogoData1,X      ; 4 Draw in player #1
        STA  GRP1               ; 3
        NOP                     ; 2 Waste cycles for horizontal position
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        NOP                     ; 2
        LDA  PPLogoData3,X      ; 4 Preload the final 2 bytes
        TAY                     ; 2
        LDA  PPLogoData2,X      ; 4
        STA  GRP0               ; 3 Store in shape
        STY  GRP1               ; 3
        STA  HMCLR              ; 3 Clear horiz. motion for future loops
        DEX                     ; 2 All done?
        BPL  .drawPPLogo        ; 3 Loop

   IF COMPILE_VERSION = PAL
        STA  WSYNC
   ENDIF

.waitOverscan
        LDA  INTIM              ; Loop until timer is done
        BNE  .waitOverscan      ; Finish drawing the rest of the screen to prevent flicker

        RTS

;----------------------------------------------------------DrawScreen
;
DrawScreen

;
; Initialize display variables.
;
        LDA  #COLOR_BLACK
        STA  COLUBK             ; Background will be black

.waitVBLANK
        LDA  INTIM              ; Loop until timer is done - wait for the proper scanline
                                ; (i.e. somewhere in the last line of VBLANK)
        BNE  .waitVBLANK        ; Whew! We're at the beginning of the frame
        LDA  #0

        STA  WSYNC              ; End the current scanline
        STA  HMOVE              ; Add horizontal motion to position sprites
        STA  VBLANK             ; End the VBLANK period with a zero, enable video, charge pot.

        LDA  titleScreen
        BNE  .noTitleScreen
        JMP  DrawTitleScreen    ; Draw the title screen

.noTitleScreen
        LDA  currentDataColor   ; Set the score color (P0 and P1)
        STA  COLUP0
        STA  COLUP1
        LDX  #P_ThreeClose
        STX  NUSIZ0             ; Three copies of player, close together (for score)
        STX  NUSIZ1

        STA  WSYNC
        STA  WSYNC              ; Wait 2 scanlines before drawing score

        ;
        ; Horizontally position P0 and P1 for score
        ;
        LDX  #22
.horPause1
        DEX
        BNE  .horPause1
        STA  RESP0

        STA  WSYNC
        LDX  #22
.horPause2
        DEX
        BNE  .horPause2
        NOP
        STA  RESP1
        STA  HMCLR
        LDA  #%10100000         ; P1 position 2 less than P0
        STA  HMP1
        LDA  #%11000000
        STA  HMP0
        STA  WSYNC
        STA  HMOVE
        STA  WSYNC

;
; There are 228/3 cycles per line, so we have a maximum of 73 cycles
; after STA WSYNC
;
; Display the scores - 6 digit, courtesy of Robin Harbron
;
        LDA  #8-1              ; Lines to display
        STA  loopCount

        LDX  #9                ; 2
.posWait
        DEX                    ; 2
        BNE  .posWait          ; 3 if branch, 2 if not
        NOP                    ; 2
        NOP
        NOP

        TSX                     ; 2
        STX  temp_stack         ; 3, Save the stack pointer (Andrew Davie)
.drawScore
        LDY  loopCount          ; 3
        LDA  (scorePtr0),Y      ; 5
        STA  GRP0               ; 3 = 11

        BIT  $00

        LDA  (scorePtr1),Y      ; 5
        STA  GRP1               ; 3
        LDA  (scorePtr5),Y      ; 5
        TAX                     ; 2
        TXS                     ; 2
        LDA  (scorePtr2),Y      ; 5
        STA  temp               ; 3
        LDA  (scorePtr3),Y      ; 5
        TAX                     ; 2
        LDA  (scorePtr4),Y      ; 5 = 37

        LDY  temp               ; 3
        STY  GRP0               ; 3
        STX  GRP1               ; 3
        STA  GRP0               ; 3
        TSX                     ; 2
        STX  GRP1               ; 3 = 17

        DEC  loopCount          ; 5
        BPL  .drawScore         ; 3 =  8

        LDX  temp_stack         ; 2
        TXS                     ; 2

        LDA  #0
        STA  GRP0
        STA  GRP1

        ;
        ; Position drivehead (horizontally)
        ;
        LDA  #HORPOS_P0         ; Convert Player0 X position to FC format
        JSR  Convert
        STA  WSYNC              ; Prepare to position Player0
        STA  HMP0               ; Remember, we're still doing VBLANK now
        AND  #$0F
        TAY
.posWait2
        DEY
        BPL  .posWait2
        STA  RESP0
        STA  WSYNC
        STA  HMOVE

        LDX  headSize           ; Set size of drivehead based on difficulty switch
        STX  NUSIZ0

        LDX  #P_Single          ; One copy of data
        STX  NUSIZ1

        LDA  currentDataColor
        STA  COLUP0

        STA  HMCLR              ; Clear horizontal motion (of Player 0)

        LDA  #0                 ; Use playfield (black) to shorten length of track
        STA  COLUPF
        STA  PF1
        STA  PF2
        LDA  #$30
        STA  PF0
        LDA  #$05               ; Reflect,No score,High Priority,1 pixel-wide ball
        STA  CTRLPF

;
; Start drawing the actual disk playfield
;
; We're going to draw #NUMGRP groups, each made of:
; 2 scanlines for Player1 positioning with Player0, plus
; #GRPHEIGHT*2 scanlines with Player1 and Player0.
;
; (Courtesy of Piero Cavina PCMSD 1.1 source)
;
.kernel
        LDA  grpDistance        ; Distance between Player0 <-> top of group
        CMP  #GRPHEIGHT+1       ; Is Player0 inside current group?
        BCC  .drawP0            ; Yes, we'll draw it...
        LDX  #0                 ; No, draw instead a blank sprite
        BEQ  .blankP0
.drawP0
        LDA  grpY_Next          ; We must draw Player0, and we'll start
        SEC                     ; from the (grpY_Next-verPosP0)th byte.
        SBC  verPosP0
        TAX                     ; Put the index to the first byte into X
.blankP0
        STX  temp               ; ...and remember it.

        LDY  grpCount           ; Store any collision between Player0 and
        LDA  CXPPMM             ; Player1 happened while drawing the last group.
        STA  coll,Y

        LDA  dataColorTable,Y
        STA  COLUP1

        LDA  horPosP1_FC,Y      ; Get Player1 position

        LDY  gameInProgress     ; If game over, don't draw drivehead
        BEQ  .noDrivehead
        LDY  HeadFrame,X        ; Get Player0 pattern
.noDrivehead

        STA  WSYNC              ; Start with a new scanline.
        STY  GRP0               ; Set Player0 pattern
        STA  HMP1               ; Prepare Player1 fine motion
        AND  #$0F               ; Prepare Player1 coarse positioning
        TAY
.posWait3
        DEY                     ; Waste time
        BPL  .posWait3
        STA  RESP1              ; Position Player1

        STA  WSYNC              ; Wait for next scanline
        STA  HMOVE              ; Apply fine motion

        LDA  #COLOR_LTBROWN
        STA  COLUBK             ; Draw track separator

;
; Now prepare various things for the next group
;
        LDA  grpY_Next          ; Update this group and next group
        STA  grpY               ; top line numbers
        CLC
        ADC  #GRPHEIGHT+1
        STA  grpY_Next

        LDA  verPosP0           ; Find out which 'slice'
        SEC                     ; of Player0 we'll have to draw.
        SBC  grpY               ; We need the distance of Player0
        BPL  .dPos              ; from the top of the group.
        EOR  #$FF
        CLC
        ADC  #1                 ; A = ABS(verPosP0-grpY)
.dPos
        STA  grpDistance

        LDX  temp               ; Pointer to the next byte of Player0
        INX                     ; pattern. Use X while drawing the group

        LDA  #0                 ; Clear collisions
        STA  CXCLR

        LDY  #GRPHEIGHT-1       ; Initialize line counter (going backwards)
.drawGroup
        LDA  #0
        STA  WSYNC              ; Wait for a new line

        LDA  #COLOR_BROWN
        STA  COLUBK             ; Set background color

        LDA  DataFrame,Y
        STA  GRP1               ; Set Player1 shape

        LDA  gameInProgress     ; If game over, don't draw drivehead
        BEQ  .noDrivehead2
        LDA  HeadFrame,X
.noDrivehead2
        STA  GRP0               ; Set Player0 shape

        LDA  INPT0              ; Read paddle 0
        BMI  .potCharged        ; Capacitor already charged, skip increment
        INC  pot0               ; Increment paddle position value
.potCharged
        STA  WSYNC              ; Wait for a new scanline

        INX                     ; Update the index to next byte of Player0
        DEY                     ; Decrement line counter
        BPL  .drawGroup         ; Go on with this group if needed

        INC  grpCount           ; Increment current group number
        LDA  grpCount           ;
        CMP  #NUMGRP            ; Is there another group to do?
        BCS  .outerKernel       ; No, exit
        JMP  .kernel            ; Yes, go back. (Using JMP because a branch is out of range)

.outerKernel
        STA  WSYNC              ; Finish current scanline

        LDA  #0                 ; Avoid bleeding
        STA  GRP0
        STA  GRP1
        STA  WSYNC              ; Draw final line of last track
        LDA  #COLOR_LTBROWN     ; ...then draw the bottom track seperator
        STA  COLUBK
        STA  WSYNC

        LDA  #COLOR_BLACK       ; Black line
        STA  COLUBK
        LDY  #7
.drawBlack
        STA  WSYNC
        DEY
        BNE  .drawBlack

;
; Draw data latency buffer and bit counter
;
        LDA  #$30
        STA  CTRLPF             ; No Reflect,No score,Low Priority,8 pixel-wide ball

        LDX  #$07               ; Number of lines alike
.drawGauge
        STA  WSYNC              ; Wait for line to finish

        LDA  #COLOR_GREEN       ; [0] +2 green
        STA  COLUPF             ; [2] +3
        LDA  #COLOR_RED         ; [5] +2 red
        STA  COLUBK             ; [7] +3 set background

        ; First half of screen
        LDA  gauge_PF           ; [10] +3
        STA  PF0                ; [13] +3
        LDA  gauge_PF+1         ; [16] +3
        STA  PF1                ; [19] +3
        LDA  #0                 ; [22] +2
        STA  PF2                ; [24] +3

        NOP                     ; [27] +2
        LDY  currentDataColor   ; [29] +3 - use in place of NOP

        LDY  currentDataColor   ; [32] +3
        STA  COLUBK             ; [35] +3 end of gauge -> background color back to black

        ; Second half of screen - display number of bytes currently retrieved
        STY  COLUPF             ; [38] +3
        LDA  bitCount_PF        ; [41] +3
        STA  PF0                ; [44] +3
        LDA  bitCount_PF+1      ; [47] +3
        STA  PF1                ; [50] +3
        LDA  bitCount_PF+2      ; [53] +3
        STA  PF2                ; [56] +3

        DEX                     ; [59] +5
        BNE  .drawGauge         ; [64] +3 (take branch)

        LDA  #COLOR_BLACK        ; Black line and playfield
        STA  COLUBK
        STA  COLUPF

        LDY  #10
.finishFrame
        STA  WSYNC              ; Draw the rest of the screen (to get us to 192 lines)
        DEY
        BNE  .finishFrame

;
; Clear all registers here to prevent any possible bleeding.
;
        LDA  #2
        STA  WSYNC              ; Finish this scanline.
        STA  VBLANK             ; Make TIA output invisible,
        ; Now we need to worry about it bleeding when we turn
        ; the TIA output back on.
        LDY  #0
        STY  PF0
        STY  PF1
        STY  PF2
        RTS


;----------------------------------------------------------Overscan
;
OverScan
        ; Set the timer to go off just before the end of overscan
        LDA  #OVERSCAN_TIME
        STA  TIM64T

        ; If game is over, disable joystick/paddle
        LDA  gameInProgress
        BNE  .gameInPlay
        JMP  .noController
.gameInPlay
        ;
        ; Set new vertical position of drivehead based on joystick/paddle value
        ;

        LDA  controllerType
        BNE  .p1Joy
        LDX  pot0

        CPX  #YBOTTOM
        BMI  .chkTrack
        LDX  #YBOTTOM   ; If paddle is lower than the max, set it to max
        JMP  .chkTrack

.p1Joy
        LDX  joy0

        LDA  SWCHA      ; Read joystick 0
        ROL
        ROL
        BMI  .joyUp
        CPX  #YBOTTOM
        BEQ  .chkTrack  ; If verPosP0 > YBOTTOM, don't change
        INX             ; Joystick pushed down

   IF COMPILE_VERSION = PAL
        CPX  #YBOTTOM
        BEQ  .chkTrack
        INX             ; Increase joystick speed for PAL systems
   ENDIF
        JMP  .chkTrack
.joyUp
        ROL
        BMI  .noController
        CPX  #YTOP
        BEQ  .chkTrack  ; If verPosP0 < YTOP, don't change
        DEX             ; Joystick pushed up

   IF COMPILE_VERSION = PAL
        CPX  #YTOP
        BEQ  .chkTrack
        DEX             ; Increase joystick speed for PAL systems
   ENDIF
.chkTrack               ; X already contains the vertical position
        STX  joy0
        LDA  SWCHB      ; Read the Player 1 (Right) Difficulty switch
        BPL  .p1Done

        ;
        ; Check paddle position and set for track-to-track (non-smooth) motion
        ;
        CPX  #15
        BPL  .nextTrack
        LDX  #YTOP      ; If position is anywhere within the track, keep it at the beginning
        JMP  .p1Done
.nextTrack
        CPX  #23
        BPL  .nextTrack2
        LDX  #YTOP+9
        JMP  .p1Done
.nextTrack2
        CPX  #31
        BPL  .nextTrack3
        LDX  #YTOP+18
        JMP  .p1Done
.nextTrack3
        CPX  #39
        BPL  .nextTrack4
        LDX  #YTOP+27
        JMP  .p1Done
.nextTrack4
        CPX  #47
        BPL  .nextTrack5
        LDX  #YTOP+36
        JMP  .p1Done
.nextTrack5
        CPX  #55
        BPL  .nextTrack6
        LDX  #YTOP+45
        JMP  .p1Done
.nextTrack6
        CPX  #63
        BPL  .nextTrack7
        LDX  #YTOP+54
        JMP  .p1Done
.nextTrack7
        CPX  #71
        BPL  .p1Done
        LDX  #YBOTTOM
.p1Done
        STX  verPosP0   ; Store value

.noController

;
; Check and handle any collisions between P1 (data) and P0 (drivehead)
;
        LDA  gameInProgress     ; Don't read button if game is over
        BEQ  .noButton

        LDA  levelDone          ; If level is completed and we're waiting for a new one to start
        BNE  .noButton

        LDA  nodata
        BNE  .delay

        LDA  controllerType
        BNE  .p1JoyFire2
        LDA  SWCHA              ; Has paddle fire button been pressed?
        JMP  .p1Button
.p1JoyFire2
        LDA  INPT4              ; Has joystick fire button been pressed?
.p1Button
        BMI  .noButton          ; If yes, check for collisions

        LDX  #NUMGRP-1
        LDA  #0
.chkCollisionFlg                ; Check all collision flags
        ORA  coll,X
        DEX
        BPL  .chkCollisionFlg
        CMP  #0                 ; If there are no collisions...
        BMI  .dataExists
        JSR  DecGauge           ; There is NO data to read, so decrement latency buffer
        LDA  #20                ; Delay to prevent multiple collisions
        STA  nodata
        JMP  .noButton
.delay
        DEC  nodata
.dataExists

        LDX  #NUMGRP-1
.chkCollision
        LDA  nocc
        BNE  .collisionDelay

        LDA  coll,X
        BPL  .noCollision

        ; Button has been pressed and there is data to read
        STX  temp
        DEX
        BPL  .noRoll            ; We are looking at the previous groups collision
        LDX  #NUMGRP-1          ; So if X=0, need to set to X=9
.noRoll
        ; Is the color correct?
        LDA  currentDataColor
        CMP  dataColorTable,X
        BEQ  .sameBitColor
        ; If not, decrement score
        JSR  DecScore

        LDA  #SOUND_INCORRECT   ; Play sound
        STA  soundType

        JMP  .noButton
.sameBitColor
        LDA  #0                 ; Hide/remove block
        STA  horPosP1,X
        STA  horMotP1,X

        LDA  SoundCorrectPitch,X
        STA  currentPitch
        LDA  #SOUND_CORRECT     ; Play sound (pitch depends on track number)
        STA  soundType

        JSR  IncCount           ; Increase bit counter
        JSR  IncBonus           ; Refill latency buffer and give bonus points
        JSR  GetNextColor       ; Change to next color

        LDA  #15                ; Delay to prevent multiple collisions
        STA  nocc
        LDX  temp
.collisionDelay
        DEC  nocc
.noCollision
        LDA  #0                 ; Clear collision flag
        STA  coll,X
        DEX
        BPL  .chkCollision
.noButton

        JSR  PlaySound

.waitOverscan2
        LDA  INTIM              ; Loop until timer is done - wait for the proper scanline
        BNE  .waitOverscan2

        RTS

;----------------------------------------------------------DataReset
;
; Called when Reset switch is pressed
;
DataReset
        LDA  #1
        STA  newGameFlag

        ; Variables
        LDA  #0
        STA  nodata
        STA  nocc
        STA  dataColorIndex
        STA  startDelay
        STA  currentSpeed
        STA  isNextLevel
        STA  currentPitch

        ; Score
        STA  score
        STA  score+1
        STA  score+2

        ; Clear bit counter
        STA  bitCount
        STA  bitCount_PF
        STA  bitCount_PF+1
        STA  bitCount_PF+2

        ; Clear latency buffer
        STA  gauge_PF
        STA  gauge_PF+1

        ; Disable sound
        STA  soundType
        STA  AUDC0      ; Control (Type)
        STA  AUDF0      ; Frequency (Pitch)
        STA  AUDV0      ; Volume
        STA  AUDC1
        STA  AUDF1
        STA  AUDV1

        LDX  #NUMGRP-1
.p1Clear
        STA  horPosP1,X
        STA  horMotP1,X
        DEX
        BPL  .p1Clear

        LDA  #SOUND_AMBIENT_MAX_PITCH
        STA  ambientPitch

        RTS

;----------------------------------------------------------GetNextColor
;
; Set the next color of data block to retrieve
;
GetNextColor
        LDA  bitCount
        CMP  #NUMGRP            ; If all data bits have been read, go to next level
        BEQ  LevelDone

        LDY  bitCount           ; Otherwise, change to next color
        LDA  nextColorTable,Y
        STA  currentDataColor

        RTS


;----------------------------------------------------------LevelDone
;
; Level is complete, clear variables and set flag
;
LevelDone
        ; Clear bit counter
        LDA  #0
        STA  bitCount
        STA  bitCount_PF
        STA  bitCount_PF+1
        STA  bitCount_PF+2

        ; Disable sound
        STA  AUDC0      ; Control (Type)
        STA  AUDF0      ; Frequency (Pitch)
        STA  AUDV0      ; Volume
        STA  AUDC1
        STA  AUDF1
        STA  AUDV1

        LDA  #1
        STA  levelDone

        RTS


;----------------------------------------------------------RandomizeDataColorTable
;
; Randomly arrange the color order of data bits: dataColorTable
;
RandomizeDataColorTable
        LDY  #NUMGRP-1
        LDA  #0
.clearFlags
        STA  coll,Y             ; Use coll as temporary color flag
        DEY
        BPL  .clearFlags

        LDY  #NUMGRP-1
.createDataTable
        JSR  RandomByte         ; Use random number to select next color (to prevent patterns)
                                ; Random number returned in A
.getDataValue
        AND #$07                ; Use the LSB for calculating dataColorTable
        TAX
        LDA  coll,X
        BEQ  .dataColorFound
        TXA                     ; Else, color has already been done, so...
        CLC                     ; ...increment random number and try again
        ADC  #1
        JMP  .getDataValue
.dataColorFound
        LDA  DataColors,X
        STA  dataColorTable,Y
        STA  coll,X             ; Set flag

        DEY
        BPL  .createDataTable

        RTS


;----------------------------------------------------------RandomizeNextColorTable
;
; Precalculate the color order of data to match: nextColorTable
;
RandomizeNextColorTable
        LDY  #NUMGRP-1
        LDA  #0
.clearFlags2
        STA  coll,Y             ; Use coll as temporary color flag
        DEY
        BPL  .clearFlags2

        LDY  #NUMGRP-1
.createNextTable
        JSR  RandomByte         ; Use random number to select next color (to prevent patterns)
                                ; Random number returned in A
.getNextValue
        AND #$07
        TAX
        LDA  coll,X
        BEQ  .nextColorFound
        TXA                     ; Else, color has already been done, so...
        CLC                     ; ...increment random number and try again
        ADC  #1
        JMP  .getNextValue
.nextColorFound
        LDA  DataColors,X
        STA  nextColorTable,Y
        STA  coll,X             ; Set flag

        DEY
        BPL  .createNextTable

        RTS


;----------------------------------------------------------IncBonus
;
; Give extra points: Remaining latency buffer
;
IncBonus
        LDX  gauge_PF
        BEQ  .refillBuffer   ; No bonus if latency buffer is equal to 0 (it never should be, or the game will be over)
        JSR  DecGauge
        LDA  #1
        JSR  IncScore
        JMP  IncBonus


;----------------------------------------------------------RefillBuffer (part of IncBonus)
;
RefillBuffer
.refillBuffer
        ; Refill latency buffer
        LDA  #$F0
        STA  gauge_PF
        LDA  #$FF
        STA  gauge_PF+1
        RTS


;----------------------------------------------------------NextLevel
;
; Setup data for the next level
;
NextLevel
        LDA  #1
        STA  isNextLevel

        LDA  #0
        STA  levelDone

        ;
        ; Set object position and motion
        ;
        LDY  #NUMGRP-1
.newPosition
        JSR  RandomByte         ; Random number returned in A
        AND  #$7F               ; Choose random positioning of data bits
        STA  horPosP1,Y
        DEY
        BPL  .newPosition

        JSR  RandomizeDataColorTable

        RTS

;----------------------------------------------------------NextLevel2
;
; Setup data for the next level
; (Called on the second frame to prevent flickering from the heavy computations)
;
NextLevel2
        JSR  RandomizeNextColorTable

        LDA  #2
        STA  isNextLevel

        RTS

;-----------------------------------------------------------NextLevel3
;
; Setup data for the next level
; (Called on the second frame to prevent flickering from the heavy computations)
;
NextLevel3
        JSR  GetNextColor

        ;
        ; Set object speed
        ;
        LDX  #1
        CPX  newGameFlag        ; If flag is set, game is just starting
        BNE  .setNewMotion
        LDY  #NUMGRP-1          ; ...so set initial bit speed to all 1
        STX  currentSpeed
.setInitialMotion
        STX  horMotP1_Real,Y
        DEY
        BPL  .setInitialMotion
        DEX                     ; X = 0
        STX  newGameFlag
        JMP  .setMotionDone

.setNewMotion
        INC  score               ; Increment level counter

        LDY  #2-1                ; Increase two bits per level
.albert
        LDX  #NUMGRP-1           ; Have all bits been set to currentSpeed+1?
.chkBitSpeed
        LDA  horMotP1_Real,X
        SEC
        SBC  #1
        CMP  currentSpeed
        BNE  .bitSpeedDone
        DEX
        BPL  .chkBitSpeed
        INC  currentSpeed        ; If yes, then increment the speed counter
.bitSpeedDone

        JSR  RandomByte          ; Random number returned in A
.chkBitSpeed2
        AND  #$07
        TAX
        LDA  horMotP1_Real,X
        SEC
        SBC  #1
        CMP  currentSpeed        ; Is the bit already at currentSpeed+1?
        BNE  .addRandomSpeed
        TXA
        CLC
        ADC  #1
        JMP  .chkBitSpeed2       ; If so, look for another
.addRandomSpeed                  ; Otherwise...
        INC  horMotP1_Real,X     ; ...increment the speed of one random data bit per level

        DEY
        BPL  .albert

.setMotionDone

        LDA  #3
        STA  isNextLevel

        RTS

;-----------------------------------------------------------NextLevel4
;
; Setup data for the next level
; (Called on the second frame to prevent flickering from the heavy computations)
;
NextLevel4
        ; horMotP1 is used and clobbered each level, so we need to restuff it
        LDY  #NUMGRP-1
.fillP1
        LDX  horMotP1_Real,Y
        STX  horMotP1,Y
        DEY
        BPL  .fillP1


        ; Increase pitch of ambient sound (Channel 0, hard drive spinning)
        LDA  #15
        STA  AUDC0              ; 5 bit poly div 6

        LDA  #5
        STA  AUDV0

        LDA  score
        AND  #$0F
        STA  temp
        LDA  SOUND_AMBIENT_MAX_PITCH
        SEC
        SBC  temp
        STA  AUDF0

        LDA  #0
        STA  isNextLevel

        RTS


;----------------------------------------------------------EndGame
;
; Stop all data bits, prevent drive head from moving
;
EndGame
        LDA  #0
        STA  gameInProgress

        ; Disable sound
        STA  AUDC0      ; Control (Type)
        STA  AUDF0      ; Frequency (Pitch)
        STA  AUDV0      ; Volume
        STA  AUDC1
        STA  AUDF1
        STA  AUDV1

        LDX  #NUMGRP-1
.noMotion
        STA  horMotP1,X
        DEX
        BPL  .noMotion
        RTS


;-------------------------------------------------------------------PlaySound
;
; Sound routine for handling Channel 1 sounds (non-ambient)
; Play sound effect depending on value of soundType
;
; (Used Ed Federmeyer's SoundX utility to experiment with sound effects)
;
PlaySound
        LDA  soundType
        BEQ  .soundDone

        AND  #$40
        BNE  .soundIncorrect

        LDA  soundType
        AND  #$20
        BNE  .soundMissed

.soundCorrect
        LDA  soundType
        STA  AUDV1
        LDA  #12        ; Div 31 pure tone
        STA  AUDC1
        LDA  currentPitch
        STA  AUDF1
        DEC  soundType  ; Count down the sound timer
        JMP  .soundDone

.soundIncorrect
        LDA  soundType
        STA  AUDV1
        LDA  #11
        STA  AUDF1
        LDA  #7
        STA  AUDC1      ; 5 bit poly -> div 2
        DEC  soundType  ; Count down the sound timer
        JMP  .soundDone

.soundMissed
        LDA  soundType
        STA  AUDV1
        EOR  #$FF
        STA  AUDF1
        LDA  #5         ; Div 2 pure tone
        STA  AUDC1
        DEC  soundType  ; Count down the sound timer

.soundDone
        LDA  soundType  ; Done?
        AND  #$0F
        BNE  .soundOn
        LDA  #0         ; Kill the sound
        STA  AUDV1
        STA  soundType
.soundOn

        RTS


;----------------------------------------------------------IncScore
;
; Increase the score by A, accumulator (up to $FF)
; Handles roll of score from 00FF to 0100, etc.
;
IncScore
        CLC             ; Clear carry
        LDX  #2-1
.rollScore
        ADC  score+1,X  ; Add LSB
        STA  score+1,X
        LDA  #0         ; MSB 2 bytes = 0
        DEX
        BPL  .rollScore
        RTS


;----------------------------------------------------------DecScore
;
; Decrement the score by 1 point
; Handle roll of score from 0100 to 00FF, etc.
; Prevent roll if score is already at 0000
;
DecScore
        ; Check for 0000
        LDA  score+2
        BNE  .lsb           ; If not 0, just decrement it
        ORA  score+1        ; Else, score+2 is 0, so check score+1
        BEQ  .decrementDone
        DEC  score+1
.lsb
        DEC  score+2
.decrementDone
        RTS


;----------------------------------------------------------IncGauge
;
; Increase the value of the data latency buffer by 1 pixel
;
IncGauge
        LDA  gauge_PF
        CMP  #$F0
        BEQ  .incGauge
        ASL
        ORA  #$10
        STA  gauge_PF
        JMP  .incGaugeDone
.incGauge
        LDA  gauge_PF+1
        LSR
        ORA  #$80
        STA  gauge_PF+1
.incGaugeDone
        RTS


;----------------------------------------------------------DecGauge
;
; Decrease the value of the data latency buffer by 1 pixel
;
DecGauge
        LDA  gauge_PF+1
        CMP  #$0
        BEQ  .decGauge
        ASL
        STA  gauge_PF+1
        JMP  .decGaugeDone
.decGauge
        LDA  gauge_PF
        LSR
        AND  #$F0
        STA  gauge_PF
.decGaugeDone
        RTS


;----------------------------------------------------------IncCount
;
; Increase the value of the bit counter by 2 pixels, increment counter variable
;
IncCount
        INC  bitCount
        LDA  bitCount_PF
        CMP  #$F0
        BEQ  .incCounterPF1
        ASL
        ASL
        ORA  #$30
        STA  bitCount_PF
        JMP  .incCounterDone
.incCounterPF1
        LDA  bitCount_PF+1
        CMP  #$FF
        BEQ  .incCounterPF2
        LSR
        LSR
        ORA  #$C0
        STA  bitCount_PF+1
        JMP  .incCounterDone
.incCounterPF2
        LDA  bitCount_PF+2
        ASL
        ASL
        ORA  #$03
        STA  bitCount_PF+2
.incCounterDone
        RTS


;------------------------------------------------------------------RandomByte
;
; The VCS has no random routine so one must be written by the programmer.
;
; Before calling this routine random MUST be set to a non-zero number. Upon
; return from this function, the accumulator will hold a pseudo random
; number.
;
RandomByte
   LDA  random
   BNE  .skipInit
   LDA  #$FE
.skipInit
   ASL
   ASL
   ASL
   EOR  random
   ASL
   ROL  random
   LDA  random
   RTS


;----------------------------------------------------------Convert
;
; Straight from "Air-Sea Battle", here's the routine
; to convert from standard X positions to FC positions
;
Convert
        STA  temp
        BPL  .lF34B
        CMP  #$9E
        BCC  .lF34B
        LDA  #$00
        STA  temp
.lF34B
        LSR
        LSR
        LSR
        LSR
        TAY
        LDA  temp
        AND  #$0F
        STY  temp
        CLC
        ADC  temp
        CMP  #$0F
        BCC  .lF360
        SBC  #$0F
        INY
.lF360
        CMP  #$08
        EOR  #$0F
        BCS  .lF369
        ADC  #$01
        DEY
.lF369
        INY
        ASL
        ASL
        ASL
        ASL
        STA  temp
        TYA
        ORA  temp

        RTS


;-----------------------------------------------------------GraphicsData

       org $FB00

; Need 8 distinct colors to avoid confusion
DataColors
                .byte COLOR_RED, COLOR_YELLOW, COLOR_GIS_GREEN, COLOR_SKY_BLUE, COLOR_PURPLE, COLOR_PINK, COLOR_WOOD_BROWN, COLOR_GREY


; Different pitched sound depending on track number
SoundCorrectPitch
                .byte SOUND_CORRECT_PITCH_0, SOUND_CORRECT_PITCH_1, SOUND_CORRECT_PITCH_2, SOUND_CORRECT_PITCH_3, SOUND_CORRECT_PITCH_4, SOUND_CORRECT_PITCH_5, SOUND_CORRECT_PITCH_6, SOUND_CORRECT_PITCH_7

;
; All shapes are upside down to allow decrementing by Y as both
; a counter and a shape index
;

;
; Numeric font, 8 x 8
;
FontPage
;Zero
                .byte   %00111100 ; |  XXXX  |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %00111100 ; |  XXXX  |
;One
                .byte   %00111100 ; |  XXXX  |
                .byte   %00011000 ; |   XX   |
                .byte   %00011000 ; |   XX   |
                .byte   %00011000 ; |   XX   |
                .byte   %00011000 ; |   XX   |
                .byte   %00011000 ; |   XX   |
                .byte   %00111000 ; |  XXX   |
                .byte   %00011000 ; |   XX   |
;Two
                .byte   %01111110 ; | XXXXXX |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %00111100 ; |  XXXX  |
                .byte   %00000110 ; |     XX |
                .byte   %00000110 ; |     XX |
                .byte   %01000110 ; | X   XX |
                .byte   %00111100 ; |  XXXX  |
;Three
                .byte   %00111100 ; |  XXXX  |
                .byte   %01000110 ; | X   XX |
                .byte   %00000110 ; |     XX |
                .byte   %00001100 ; |    XX  |
                .byte   %00001100 ; |    XX  |
                .byte   %00000110 ; |     XX |
                .byte   %01000110 ; | X   XX |
                .byte   %00111100 ; |  XXXX  |
;Four
                .byte   %00001100 ; |    XX  |
                .byte   %00001100 ; |    XX  |
                .byte   %00001100 ; |    XX  |
                .byte   %01111110 ; | XXXXXX |
                .byte   %01001100 ; | X  XX  |
                .byte   %00101100 ; |  X XX  |
                .byte   %00011100 ; |   XXX  |
                .byte   %00001100 ; |    XX  |
;Five
                .byte   %01111100 ; | XXXXX  |
                .byte   %01000110 ; | X   XX |
                .byte   %00000110 ; |     XX |
                .byte   %00000110 ; |     XX |
                .byte   %01111100 ; | XXXXX  |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01111110 ; | XXXXXX |
;Six
                .byte   %00111100 ; |  XXXX  |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01111100 ; | XXXXX  |
                .byte   %01100000 ; | XX     |
                .byte   %01100010 ; | XX   X |
                .byte   %00111100 ; |  XXXX  |
;Seven
                .byte   %00011000 ; |   XX   |
                .byte   %00011000 ; |   XX   |
                .byte   %00011000 ; |   XX   |
                .byte   %00011000 ; |   XX   |
                .byte   %00001100 ; |    XX  |
                .byte   %00000110 ; |     XX |
                .byte   %01000010 ; | X    X |
                .byte   %01111110 ; | XXXXXX |
;Eight
                .byte   %00111100 ; |  XXXX  |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %00111100 ; |  XXXX  |
                .byte   %00111100 ; |  XXXX  |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %00111100 ; |  XXXX  |
;Nine
                .byte   %00111100 ; |  XXXX  |
                .byte   %01000110 ; | X   XX |
                .byte   %00000110 ; |     XX |
                .byte   %00111110 ; |  XXXXX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %00111100 ; |  XXXX  |
;A
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01111110 ; | XXXXXX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %00111100 ; |  XXXX  |
;B
                .byte   %01111100 ; | XXXXX  |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01111100 ; | XXXXX  |
                .byte   %01111100 ; | XXXXX  |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100110 ; | XX  XX |
                .byte   %01111100 ; | XXXXX  |
;C
                .byte   %00111100 ; |  XXXX  |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01100110 ; | XX  XX |
                .byte   %00111100 ; |  XXXX  |
;D
                .byte   %01111100 ; | XXXXX  |
                .byte   %01100110 ; | XX  XX |
                .byte   %01100010 ; | XX   X |
                .byte   %01100010 ; | XX   X |
                .byte   %01100010 ; | XX   X |
                .byte   %01100010 ; | XX   X |
                .byte   %01100110 ; | XX  XX |
                .byte   %01111100 ; | XXXXX  |
;E
                .byte   %01111110 ; | XXXXXX |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01111110 ; | XXXXXX |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01111110 ; | XXXXXX |
;F
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01111110 ; | XXXXXX |
                .byte   %01100000 ; | XX     |
                .byte   %01100000 ; | XX     |
                .byte   %01111110 ; | XXXXXX |

;
; Additional characters for Easter Egg, 8 x 8
;

J
                .byte   %01111100 ; | XXXXX  |
                .byte   %01000100 ; | X   X  |
                .byte   %01000100 ; | X   X  |
                .byte   %00000100 ; |     X  |
                .byte   %00000100 ; |     X  |
                .byte   %00000100 ; |     X  |
                .byte   %00011100 ; |   XXX  |
                .byte   %00011100 ; |   XXX  |
G
                .byte   %11111100 ; |XXXXXX  |
                .byte   %10001100 ; |X   XX  |
                .byte   %10001100 ; |X   XX  |
                .byte   %10011100 ; |X  XXX  |
                .byte   %10000000 ; |X       |
                .byte   %10000000 ; |X    X  |
                .byte   %10000100 ; |X    X  |
                .byte   %11111100 ; |XXXXXX  |

K
                .byte   %00011001 ; |   XX  X|
                .byte   %00011001 ; |   XX  X|
                .byte   %00011001 ; |   XX  X|
                .byte   %00011001 ; |   XX  X|
                .byte   %00011111 ; |   XXXXX|
                .byte   %00010010 ; |   X  X |
                .byte   %00010010 ; |   X  X |
                .byte   %00010010 ; |   X  X |

S
                .byte   %00111111 ; |  XXXXXX|
                .byte   %00100011 ; |  X   XX|
                .byte   %00000011 ; |      XX|
                .byte   %00000011 ; |      XX|
                .byte   %00111111 ; |  XXXXXX|
                .byte   %00100000 ; |  X     |
                .byte   %00100001 ; |  X    X|
                .byte   %00111111 ; |  XXXXXX|

HEART
                .byte   %00001000 ; |    X   |
                .byte   %00011100 ; |   XXX  |
                .byte   %00111110 ; |  XXXXX |
                .byte   %01111111 ; | XXXXXXX|
                .byte   %01111111 ; | XXXXXXX|
                .byte   %01111111 ; | XXXXXXX|
                .byte   %00110110 ; |  XX XX |
                .byte   %00000000 ; |        |

HeadFrame
                ; Note the leading and trailing $00's
                .byte $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 9

                .byte   %00111110 ; |  XXXXX |
                .byte   %01101011 ; | XX X XX|
                .byte   %00001000 ; |    X   |
                .byte   %00001000 ; |    X   |
                .byte   %00001000 ; |    X   |
                .byte   %00001000 ; |    X   |
                .byte   %01101011 ; | XX X XX|
                .byte   %00111110 ; |  XXXXX |

                .byte $00, $00, $00, $00, $00, $00, $00, $00 ; 8

DataFrame
                 .byte   %00000000 ; |        |
                 .byte   %01111110 ; | XXXXXX |
                 .byte   %11111111 ; |XXXXXXXX|
                 .byte   %11111111 ; |XXXXXXXX|
                 .byte   %11111111 ; |XXXXXXXX|
                 .byte   %11111111 ; |XXXXXXXX|
                 .byte   %01111110 ; | XXXXXX |
                 .byte   %00000000 ; |        |

;
; Playfield graphics for title screen (40 x 8, generated using Stella-Graph)
;

PFData0:        ; S
                .byte $E0, $20, $20, $00, $E0, $20, $20, $E0
PFData1:        ; C
                .byte $DF, $D1, $D1, $D0, $D0, $13, $53, $DF
PFData2:        ; SI
                .byte $BE, $B2, $B2, $B0, $BE, $82, $A2, $BE
PFData3:        ; c
                .byte $D0, $50, $50, $50, $C0, $00, $00, $00
PFData4:        ; i
                .byte $DB, $5B, $1B, $D3, $D3, $00, $10, $00
PFData5:        ; de
                .byte $7B, $1A, $7A, $5A, $7B, $02, $02, $02


;
; Name bitmap, 32 x 8
;

NameData0
                .byte   %00000000
                .byte   %11110100
                .byte   %10010000
                .byte   %00010000
                .byte   %00010000
                .byte   %00110000
                .byte   %00110000
                .byte   %00000000

NameData1
                .byte   %00000000
                .byte   %11111011
                .byte   %10011011
                .byte   %10111010
                .byte   %10000010
                .byte   %10001011
                .byte   %11111000
                .byte   %00000000

NameData2
                .byte   %00000000
                .byte   %00111101
                .byte   %00110101
                .byte   %00111101
                .byte   %10000101
                .byte   %10111101
                .byte   %00000000
                .byte   %00000000

NameData3
                .byte   %00000000
                .byte   %10101111
                .byte   %10101101
                .byte   %10101101
                .byte   %00101101
                .byte   %11101111
                .byte   %00000001
                .byte   %00000001

;
; Logo bitmaps, 32 x 32 (top and bottom row to be all 00s for a total of 32 rows)
;

PPLogoData0
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000001
                .byte   %00000011
                .byte   %00000111
                .byte   %00001111
                .byte   %00011110
                .byte   %00111100
                .byte   %00111000
                .byte   %01110000
                .byte   %01110000
                .byte   %01110000
                .byte   %11100000
                .byte   %11100000
                .byte   %11100000
                .byte   %11100000
                .byte   %11100000
                .byte   %11100000
                .byte   %11100000
                .byte   %11100000
                .byte   %01110000
                .byte   %01110000
                .byte   %01110000
                .byte   %00111000
                .byte   %00111100
                .byte   %00011110
                .byte   %00001111
                .byte   %00000111
                .byte   %00000011
                .byte   %00000001
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000

PPLogoData1
                .byte   %00000000
                .byte   %00001111
                .byte   %01111111
                .byte   %11111111
                .byte   %11110000
                .byte   %10000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000011
                .byte   %00000011
                .byte   %00000011
                .byte   %00000011
                .byte   %00111111
                .byte   %00111111
                .byte   %00110001
                .byte   %00110001
                .byte   %00110001
                .byte   %00110001
                .byte   %00111111
                .byte   %00111111
                .byte   %00001100
                .byte   %00011000
                .byte   %00011000
                .byte   %00110000
                .byte   %00110000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %10000000
                .byte   %11110000
                .byte   %11111111
                .byte   %01111111
                .byte   %00001111
                .byte   %00000000

PPLogoData2
                .byte   %00000000
                .byte   %11110000
                .byte   %11111110
                .byte   %11111111
                .byte   %00001111
                .byte   %00000001
                .byte   %00000000
                .byte   %00000000
                .byte   %11000000
                .byte   %11000000
                .byte   %11000000
                .byte   %11000000
                .byte   %11111100
                .byte   %11111100
                .byte   %10001100
                .byte   %10001100
                .byte   %10001100
                .byte   %10001100
                .byte   %11111100
                .byte   %11111100
                .byte   %00110000
                .byte   %00011000
                .byte   %00011000
                .byte   %00001100
                .byte   %00001100
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000011
                .byte   %00001111
                .byte   %11111111
                .byte   %11111110
                .byte   %11110000
                .byte   %00000000

PPLogoData3
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %10000000
                .byte   %11000000
                .byte   %11100000
                .byte   %11110000
                .byte   %01111000
                .byte   %00111100
                .byte   %00011100
                .byte   %00001110
                .byte   %00001110
                .byte   %00001110
                .byte   %00000111
                .byte   %00000111
                .byte   %00000111
                .byte   %00000111
                .byte   %00000111
                .byte   %00000111
                .byte   %00000111
                .byte   %00000111
                .byte   %00001110
                .byte   %00001110
                .byte   %00001110
                .byte   %00011100
                .byte   %00111100
                .byte   %01111000
                .byte   %11110000
                .byte   %11100000
                .byte   %11000000
                .byte   %10000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000

GISLogoData0
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000001
                .byte   %00000011
                .byte   %00000011
                .byte   %00000011
                .byte   %00000001
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000001
                .byte   %00000001
                .byte   %00000001
                .byte   %00000001
                .byte   %00000001
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000

GISLogoData1
                .byte   %00000000
                .byte   %00000001
                .byte   %00000011
                .byte   %00011111
                .byte   %01111111
                .byte   %11110011
                .byte   %11000001
                .byte   %10000000
                .byte   %00000000
                .byte   %10000000
                .byte   %11000001
                .byte   %11111001
                .byte   %00111111
                .byte   %01111111
                .byte   %11100001
                .byte   %11000001
                .byte   %11100001
                .byte   %01111111
                .byte   %00111111
                .byte   %01110001
                .byte   %11100001
                .byte   %11000011
                .byte   %10000011
                .byte   %10000011
                .byte   %10000011
                .byte   %11000111
                .byte   %11100111
                .byte   %11110111
                .byte   %01111111
                .byte   %00111111
                .byte   %00001111
                .byte   %00000011
                .byte   %00000001
                .byte   %00000000

GISLogoData2
                .byte   %00000000
                .byte   %10000000
                .byte   %11000000
                .byte   %11111100
                .byte   %11111110
                .byte   %11000111
                .byte   %10000011
                .byte   %00000001
                .byte   %00000000
                .byte   %00000001
                .byte   %10000011
                .byte   %10011111
                .byte   %11111110
                .byte   %11111000
                .byte   %10000000
                .byte   %10000000
                .byte   %10000000
                .byte   %11111000
                .byte   %11111100
                .byte   %10001110
                .byte   %10000111
                .byte   %11000011
                .byte   %11000001
                .byte   %11000001
                .byte   %11000001
                .byte   %11100011
                .byte   %11100111
                .byte   %11101111
                .byte   %11111110
                .byte   %11111100
                .byte   %11110000
                .byte   %11000000
                .byte   %10000000
                .byte   %00000000

GISLogoData3
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %10000000
                .byte   %11000000
                .byte   %11000000
                .byte   %11000000
                .byte   %10000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %10000000
                .byte   %10000000
                .byte   %10000000
                .byte   %10000000
                .byte   %10000000
                .byte   %10000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000
                .byte   %00000000

;
; Avoid $FFF8 to allow use with Supercharger
;

;
; Set up the 6502 interrupt vector table
;
        org $FFFC

        .word Start     ; Reset
        .word Start     ; IRQ

        END