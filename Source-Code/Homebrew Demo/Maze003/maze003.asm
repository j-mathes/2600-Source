;--------------------------------------------------------------------
;Maze Engine v003 by Andrew Schwerin
;Draws a scrollable maze image using playfield graphics.
;Joystick controls the scrolling.
;Thanks to Eckhard Stolberg for init/VBLANK code in trick.a65
;
;FEATURE:
;  Slow horizontal motion to 1 pixel per 4 frames
;  Optimized Precompute loop
;
;This source, the binary, and the documentation is public domain.
;Please give credit if you incorporate this engine into a game.
;Enjoy!  Feedback welcome! (schwerin@tiac.net)

    processor    6502
    include      vcs.h

;Constants ----------------------------------------------------------

THE_DRAWH   = 8   ;DrawHeight MUST BE "8" in this version.
PICT_LINES  = 192 ;Number of picture scanlines
                  ;I hope to support PAL in the future, but for now,
                  ;tweak this only at your own risk.  The code
                  ;"runs out" of stuff to draw soon after 192nd line.
                  ;Playfield/Background colors.  Change if you like.
FORE_COLOR  = $7F ;White.  Color = %1111, Lumina = %111
BACK_COLOR  = $00 ;Black.  Color = %0000, Lumina = %000

;Addresses ----------------------------------------------------------

FieldH00    = $80 ;These are the 32 precomputed Playfield registers.
FieldH01    = $81 ;Each "unique" scanline requires 4 bytes:
FieldH02    = $82 ; "0" PF1L, "1" PF2L, "2" PF2R, "3" PF1R
FieldH03    = $83 ;There are 8 unique scanlines
FieldV00    = $84 ; H0, V0, H1, V1, H2, V2, H3, V3
FieldV01    = $85 ;
FieldV02    = $86 ;Note that PF0left and PF0right are not utilized.
FieldV03    = $87 ;
FieldH10    = $88 ;The 32 bytes are needed as a screen data buffer.
FieldH11    = $89 ;The maze graphics can be computed offscreen
FieldH12    = $8A ;freeing up more processor time during the drawing.
FieldH13    = $8B ;
FieldV10    = $8C ;If you need zero page memory, the screen math can
FieldV11    = $8D ;be done during drawing time (but it's not simple).
FieldV12    = $8E ;
FieldV13    = $8F ;If you increase DrawHeight, you can eliminate some
FieldH20    = $90 ;of the precomputed buffer, because there will be
FieldH21    = $91 ;less "unique" scanlines to buffer.
FieldH22    = $92 ;
FieldH23    = $93 ;If you decrease DrawHeight, more buffer space will 
FieldV20    = $94 ;be needed.
FieldV21    = $95 ;
FieldV22    = $96 ;
FieldV23    = $97 ;
FieldH30    = $98 ;
FieldH31    = $99 ;
FieldH32    = $9A ;
FieldH33    = $9B ;
FieldV30    = $9C ;
FieldV31    = $9D ;
FieldV32    = $9E ; 
FieldV33    = $9F ;

MazePtr     = $A0 ;maze shape table (address MUST be page aligned)
TempPtrH    = $A2 ;Temp Pointer to maze data
TempPtrV    = $A4
field       = $A6 ;Pointer to PlayField buffer
lookup1     = $A8 ;Pointer to a graphics lookup table
lookup2     = $AA
lookup3     = $AC
lookup4     = $AE

DrawHeight  = $B0 ;Vertical thickness (1 thin to 16 thick)
                  ;DrawHeight MUST BE "8" in this version.
ScrollH     = $B1 ;leftmost (H)oriz. byte(0-3);segment (B)it(0-7);
                  ;(F)ield block(0-7);D7--->D0:  HHBBBFFF
HorizByte   = $B2 ;
SegmentBits = $B3 ;
FieldOffset = $B4 ;
ScrollV     = $B5 ;uppermost byte in display:0 to 124 (multiple of 4)
ScrollVfine = $B6 ;uppermost scanline visable (0 to 63)
ScanLine    = $B7 ;Count number of visible scanlines left to draw.
DrawH       = $B8 ;Count number of H draws left (counts down to zero)
DrawV       = $B9 ;Count number of V draws left (counts down to zero)
temp        = $BA

TempHL      = $BB ;buffer for 4 "local" maze shape bytes
TempHR      = $BC
TempVL      = $BD
TempVR      = $BE
FrameCount  = $BF


RomStart    = $F000
RomEnd      = $FFFF
IntVectors  = $FFFA

;Initialization -----------------------------------------------------

                org     RomStart
            
Cart_Init:
                sei                    ;Disable interrupts.
                cld                    ;Clear "decimal" mode.
            
                ldx     #$FF           ;Reset Stack to the top ($FF)
                txs
            
Common_Init:
                ldx     #$28           ;Clear the TIA regs ($04-$2C)
                lda     #$00
TIA_Clear:
                sta     $04,X
                dex
                bpl     TIA_Clear      ;Loop until X = $FF
                
                ldx     #$FF           ;(is this operation needed?)
RAM_Clear:
                sta     $00,X          ;Clear the RAM ($FF-$80)
                dex
                bmi     RAM_Clear      ;Loop until X = $7F
                
                ldx     #$FF           ;Reset the Stack.
                txs                    ;(Um, didn't we already?)
IO_Clear:
                sta     SWACNT         ;Port A <-- Input mode.
                                       ;(Port B hardwired for input)
                                    
Maze_Init:                             ;Do some One Time Only stuff
                lda     #$00           ;low byte of Table address
                sta     MazePtr
                lda     #$FD           ;high byte of Table address
                sta     MazePtr+1
                lda     #THE_DRAWH
                sta     DrawHeight
                lda     #$00           ;clear the scroll registers
                sta     ScrollH        ;(Yes,I know they are cleared)
                sta     ScrollV        ;(Here is a good place to try)
                sta     ScrollVfine    ;(other initial scroll values)
                sta     PF0            ;"disable" this Playfield reg.
                sta     GRP0           ;"disable" the player graphics
                sta     GRP1
                sta     ENAM0          ;disable the missiles
                sta     ENAM1
                sta     ENABL          ;disable the ball
                
                lda     #FORE_COLOR
                sta     COLUPF         ;Playfield Color Register
                lda     #BACK_COLOR
                sta     COLUBK         ;Background Color Register
                lda     #1
                sta     CTRLPF         ;enable Playfield reflection
                                
;Main Program Loop --------------------------------------------------

New_Screen:
                lda     #2             ;prepare to set D1
                sta     WSYNC          ;Wait for horizontal sync
                sta     VBLANK         ;Turn on VBLANK
                sta     VSYNC          ;Turn on VSYNC
                sta     WSYNC          ;Leave VSYNC on for 3 lines.
                                       ;This cues the TV to VBLANK
                sta     WSYNC
                sta     WSYNC
                lda     #0
                sta     VSYNC          ;Turn VSYNC off
                
                lda     #43            ;VBLANK for 37 lines
                sta     TIM64T         ;count for 43  "64 intervals"
                                       ;That's 43*64 = 2752 clocks
                                       ;2752 * 3 = 8256 color clocks
                                       ;8256 / 228 = 36.2 lines

;Vertical Blanking Interval -----------------------------------------

Do_Math_Here:                        
                inc     FrameCount     ;"slow down" Horiz. scrolling
                lda     FrameCount     ;(H. scrolls only on Frame=0)
                and     #3             ;if 4, wrap around
                sta     FrameCount
                lda     ScrollV        ;Initialize Pointer: Maze + V
                sta     TempPtrH       ;(ScrollV is a multiple of 4)
                ora     #$80           ;set hi bit, V maze table
                sta     TempPtrV
                lda     MazePtr+1      ;Maze Table (page aligned)
                sta     TempPtrH+1
                sta     TempPtrV+1
                lda     ScrollH        ;HHxxxxxx get Horiz Byte
                rol
                rol
                rol
                and     #3             ;000000HH
                sta     HorizByte
                lda     ScrollH        ;xxBBBxxx get Segment Bits
                lsr
                lsr
                lsr
                and     #7             ;00000BBB
                sta     SegmentBits
                lda     ScrollH        ;xxxxxFFF get Field Shift
                and     #7             ;00000FFF
                asl
                asl                    ;multiply by 4(pointer offset)
                sta     FieldOffset    ;000FFF00
                lda     #FieldH00
                sta     field
                lda     #$00
                sta     field+1        ;Initialize zp field pointer
                jsr     Setup_DrawHV
                jsr     PreDrawPtr     ;setup ptrs for predraw

Precompute:                            ;Compute playfield buffer

                jsr     ReadMaze       ;get 4 maze data bytes
                jsr     Combine        ;make "middle" from left/right
                jsr     ShiftMaze      ;shifted maze bits --> Temp*L
                jsr     PreDraw        ;Compute Playfield Graphics
        
                lda     TempPtrH       ;down one V row in maze data.
                clc
                adc     #4
                and     #$7F           ;clear hi-bit (wrap around)
                sta     TempPtrH
                ora     #$80           ;set hi-bit
                sta     TempPtrV       ;
                
                lda     field          ;more drawing needed?
                cmp     #FieldV33      ;
                bcc     Precompute     ;if (field < #FieldV33), loop
                
                
Do_Other_Setup:                                                                    
                lda     #PICT_LINES    ;Should be 192
                sta     ScanLine
                
VBLANK_Loop:
                lda     INTIM
                bne     VBLANK_Loop    ;wait for VBLANK timer
                sta     WSYNC          ;finish waiting for line
                sta     VBLANK         ;Turn off VBLANK
                
                
; Drawing Code ------------------------------------------------------

Draw_Screen:


                lda     DrawH
                beq     V0             ;branch if DrawH = 0
H0:    

                                       ;          [70] from previous
                sta     WSYNC          ;          [70] + 3
                                       ;          [73]
                                       ;          sleep for 2 cycles.    
                lda     FieldH00       ;[00] + 3
                sta     PF1            ;[03] + 3  *5*  < 28
                lda     FieldH01       ;[06] + 3
                sta     PF2            ;[09] + 3  *11* < 38
                lda     FieldH02       ;[12] + 3
                pha                    ;[15] + 3  kill some time
                pla                    ;[18] + 4
                pha                    ;[22] + 3
                pla                    ;[25] + 4
                nop                    ;[29] + 2
                nop                    ;[31] + 2
                nop                    ;[33] + 2
                nop                    ;[35] + 2
                lda     FieldH03       ;[37] + 3
                sta     PF1            ;[40] + 3  *42* < 60
                lda     FieldH02       ;[43] + 3
                sta     PF2            ;[46] + 3  *48* < 49 (or 50)
                dec     ScanLine       ;[49] + 5
                beq     Exit0          ;[54] + 2 {not taken}
                dec     DrawH          ;[56] + 5
                bne     H0             ;[61] + 3 {taken}
                
V0:                                    ;Loop:             Fall:
                                       ;[61] + 3 {taken}  [61] + 2{n}
                sta     WSYNC          ;[64] + 3          [63] + 3
                                       ;[67] {sleep 9}    [66] {10}
                                       ;            
                lda     FieldV00       ;[00] + 3
                sta     PF1            ;[03] + 3  *5*  < 28
                lda     FieldV01       ;[06] + 3
                sta     PF2            ;[09] + 3  *11* < 38
                lda     FieldV02       ;[12] + 3
                pha                    ;[15] + 3  kill some time
                pla                    ;[18] + 4
                pha                    ;[22] + 3
                pla                    ;[25] + 4
                lda     #8             ;[29] + 2
                sta     DrawH          ;[31] + 3
                lda     FieldV03       ;[34] + 3
                lda     FieldV03       ;[37] + 3
                sta     PF1            ;[40] + 3  *42* < 60
                lda     FieldV02       ;[43] + 3
                sta     PF2            ;[46] + 3  *48* < 49 (or 50)
                dec     ScanLine       ;[49] + 5
                beq     Exit0          ;[54] + 2 {not taken}
                dec     DrawV          ;[56] + 5
                bne     V0             ;[61] + 2 {not taken}
                beq     Next0          ;[63] + 3 {taken}
                
Exit0:          jmp     Setup_Overscan
                                
Next0:          lda     #56            ;[66] + 2
                sta     DrawV          ;[68] + 3    V = 56

H1:                                    ;Loop:             Fall:
                                       ;                  [71]
                sta     WSYNC          ;[64] + 3          [71] + 3
                                       ;[67] {sleep 9}    [74] {sl 2}
                lda     FieldH10       ;[00] + 3
                sta     PF1            ;[03] + 3  *5*  < 28
                lda     FieldH11       ;[06] + 3
                sta     PF2            ;[09] + 3  *11* < 38
                lda     FieldH12       ;[12] + 3
                pha                    ;[15] + 3  kill some time
                pla                    ;[18] + 4
                pha                    ;[22] + 3
                pla                    ;[25] + 4
                nop                    ;[29] + 2
                nop                    ;[31] + 2
                nop                    ;[33] + 2
                nop                    ;[35] + 2
                lda     FieldH13       ;[37] + 3
                sta     PF1            ;[40] + 3  *42* < 60
                lda     FieldH12       ;[43] + 3
                sta     PF2            ;[46] + 3  *48* < 49 (or 50)
                dec     ScanLine       ;[49] + 5
                beq     Exit1          ;[54] + 2 {not taken}
                dec     DrawH          ;[56] + 5
                bne     H1             ;[61] + 3 (taken)
                                    
V1:                                    ;Loop:             Fall:
                                       ;[61] + 3 {taken}  [61] + 2{n}
                sta     WSYNC          ;[64] + 3          [63] + 3
                                       ;[67] {sleep 9}    [66] {sl10}
                lda     FieldV10       ;[00] + 3
                sta     PF1            ;[03] + 3  *5*  < 28
                lda     FieldV11       ;[06] + 3
                sta     PF2            ;[09] + 3  *11* < 38
                lda     FieldV12       ;[12] + 3
                pha                    ;[15] + 3  kill some time
                pla                    ;[18] + 4
                pha                    ;[22] + 3
                pla                    ;[25] + 4
                lda     #8             ;[29] + 2
                sta     DrawH          ;[31] + 3
                lda     FieldV13       ;[34] + 3
                lda     FieldV13       ;[37] + 3
                sta     PF1            ;[40] + 3  *42* < 60
                lda     FieldV12       ;[43] + 3
                sta     PF2            ;[46] + 3  *48* < 49 (or 50)
                dec     ScanLine       ;[49] + 5
                beq     Exit1          ;[54] + 2 {not taken}
                dec     DrawV          ;[56] + 5
                bne     V1             ;[61] + 2 {not taken}
                beq     Next1          ;[63] + 3 {taken}
                
Exit1:          jmp     Setup_Overscan

Next1:          lda     #56            ;[66] + 2
                sta     DrawV          ;[68] + 3
                                
H2:                                    ;Loop:             Fall:
                                       ;                  [71]
                sta     WSYNC          ;[64] + 3          [71] + 3
                                       ;[67] {sleep 9}    [74] {sl 2}
                lda     FieldH20       ;[00] + 3
                sta     PF1            ;[03] + 3  *5*  < 28
                lda     FieldH21       ;[06] + 3
                sta     PF2            ;[09] + 3  *11* < 38
                lda     FieldH22       ;[12] + 3
                pha                    ;[15] + 3  kill some time
                pla                    ;[18] + 4
                pha                    ;[22] + 3
                pla                    ;[25] + 4
                nop                    ;[29] + 2
                nop                    ;[31] + 2
                nop                    ;[33] + 2
                nop                    ;[35] + 2
                lda     FieldH23       ;[37] + 3
                sta     PF1            ;[40] + 3  *42* < 60
                lda     FieldH22       ;[43] + 3
                sta     PF2            ;[46] + 3  *48* < 49 (or 50)
                dec     ScanLine       ;[49] + 5
                beq     Exit2          ;[54] + 2 {not taken}
                dec     DrawH          ;[56] + 5
                bne     H2             ;[61] + 3 (taken)
                            
V2:                                    ;Loop:             Fall:
                                       ;[61] + 3 {taken}  [61] + 2{n}
                sta     WSYNC          ;[64] + 3          [63] + 3
                                       ;[67] {sleep 9}    [66] {sl10}
                lda     FieldV20       ;[00] + 3
                sta     PF1            ;[03] + 3  *5*  < 28
                lda     FieldV21       ;[06] + 3
                sta     PF2            ;[09] + 3  *11* < 38
                lda     FieldV22       ;[12] + 3
                pha                    ;[15] + 3  kill some time
                pla                    ;[18] + 4
                pha                    ;[22] + 3
                pla                    ;[25] + 4
                lda     #8             ;[29] + 2
                sta     DrawH          ;[31] + 3
                lda     FieldV23       ;[34] + 3
                lda     FieldV23       ;[37] + 3
                sta     PF1            ;[40] + 3  *42* < 60
                lda     FieldV22       ;[43] + 3
                sta     PF2            ;[46] + 3  *48* < 49 (or 50)
                dec     ScanLine       ;[49] + 5
                beq     Exit2          ;[54] + 2 {not taken}
                dec     DrawV          ;[56] + 5
                bne     V2             ;[61] + 2 {not taken}
                beq     Next2          ;[63] + 3 {taken}
                
Exit2:          jmp     Setup_Overscan

Next2:          lda     #56            ;[66] + 2
                sta     DrawV          ;[68] + 3
                
H3:                                    ;Loop:             Fall:
                                       ;                  [71]
                sta     WSYNC          ;[64] + 3          [71] + 3
                                       ;[67] {sleep 9}    [74] {sl 2}
                lda     FieldH30       ;[00] + 3
                sta     PF1            ;[03] + 3  *5*  < 28
                lda     FieldH31       ;[06] + 3
                sta     PF2            ;[09] + 3  *11* < 38
                lda     FieldH32       ;[12] + 3
                pha                    ;[15] + 3  kill some time
                pla                    ;[18] + 4
                pha                    ;[22] + 3
                pla                    ;[25] + 4
                nop                    ;[29] + 2
                nop                    ;[31] + 2
                nop                    ;[33] + 2
                nop                    ;[35] + 2
                lda     FieldH33       ;[37] + 3
                sta     PF1            ;[40] + 3  *42* < 60
                lda     FieldH32       ;[43] + 3
                sta     PF2            ;[46] + 3  *48* < 49 (or 50)
                dec     ScanLine       ;[49] + 5
                beq     Exit3          ;[54] + 2 {not taken}
                dec     DrawH          ;[56] + 5
                bne     H3             ;[61] + 3 (taken)
                        
V3:                                    ;Loop:             Fall:
                                       ;[61] + 3 {taken}  [61] + 2{n}
                sta     WSYNC          ;[64] + 3          [63] + 3
                                       ;[67] {sleep 9}    [66] {sl10}
                lda     FieldV30       ;[00] + 3
                sta     PF1            ;[03] + 3  *5*  < 28
                lda     FieldV31       ;[06] + 3
                sta     PF2            ;[09] + 3  *11* < 38
                lda     FieldV32       ;[12] + 3
                pha                    ;[15] + 3  kill some time
                pla                    ;[18] + 4
                pha                    ;[22] + 3
                pla                    ;[25] + 4
                lda     #8             ;[29] + 2
                sta     DrawH          ;[31] + 3
                lda     FieldV33       ;[34] + 3
                lda     FieldV33       ;[37] + 3
                sta     PF1            ;[40] + 3  *42* < 60
                lda     FieldV32       ;[43] + 3
                sta     PF2            ;[46] + 3  *48* < 49 (or 50)
                dec     ScanLine       ;[49] + 5
                beq     Exit3          ;[54] + 2 {not taken}
                dec     DrawV          ;[56] + 5
                bne     V3             ;[61] + 2 {not taken}
                beq     Next3          ;[63] + 3 {taken}
                
Exit3:          jmp     Setup_Overscan

Next3:                                 ;SHOULD NEVER get here!
                                       ;(Unless DrawHeight changed.)
                                       ;draw background for lines.
                                    
                lda     #0             ;[66] + 2
                sta     WSYNC          ;[68] + 3
                                       ;[71] {sleep 5}
                sta     PF0            ;[00] + 3
                sta     PF1            ;[03] + 3
                sta     PF2            ;[06] + 3
                dec     ScanLine       ;[09] + 5
                bne     Next3          ;[14] + 3 {not taken}

Setup_Overscan:
                lda     #2
                sta     VBLANK         ;Turn on VBLANK
                sta     WSYNC
                sta     WSYNC
; Overscan Interval -------------------------------------------------

Start_Overscan:
                lda     #35            ;skip 30 lines (overscan)
                sta     TIM64T         ;35 * 64 = 2240
                                       ;(2240 * 3) / 228 = 29.4 lines
                                    
Do_More_Math:

Check_Joystick:                        ;Scroll when joystick is moved
                                       ;If button pressed, move twice
                                       ;Use Processor N flag to
                                       ;detect D7 set or cleared.
                lda     INPT4          ;read joystick0 button
                bpl     Pressed        ;"0" means button down.
                
                                       ;get joystick bits
                                       ;"0" = moved, "1" = not moved
                lda     SWCHA          ;N = P0right
                bmi     skip1          ;branch on N=1    
                jsr     ScrollRight    ;Save/Restore the Acc!
skip1:          asl                    ;N = P0left
                bmi     skip2
                jsr     ScrollLeft
skip2:          asl                    ;N = P0down
                bmi     skip3
                jsr     ScrollDown
skip3:          asl                    ;N = P0up
                bmi     skip4
                jsr     ScrollUp
skip4:          jmp     joy_exit

Pressed:        lda     SWCHA          ;N = P0right
                bmi     skip5        
                jsr     ScrollRight 
                jsr     ScrollRight
skip5:          asl                    ;N = P0left
                bmi     skip6
                jsr     ScrollLeft
                jsr     ScrollLeft
skip6:          asl                    ;N = P0down
                bmi     skip7
                jsr     ScrollDown
                jsr     ScrollDown
skip7:          asl                    ;N = P0up
                bmi     joy_exit
                jsr     ScrollUp
                jsr     ScrollUp
joy_exit:        
        
        
                                                                    
Overscan_Loop:                    
                lda     INTIM
                bne     Overscan_Loop  ;wait for Overscan timer
                sta     WSYNC          ;waiting for the current line
                
                jmp     New_Screen     ;start all over again...
                
; Subroutines -------------------------------------------------------

Setup_DrawHV:
                                       ;Do the Setup Computations
                                       ;needed by the drawing loop
                                    
                                       ;compute DrawH and DrawV.
                                       ;how many H lines to draw top,
                                       ;how many V lines afterwards.
                                       ;"8"s are the DrawHeight.
                                    
                                 ;if (ScrollVfine <  8) H=8-S, V=56
                                 ;if (ScrollVfine >= 8) H=0  , V=64-S
                lda     #8
                cmp     ScrollVfine
                bcc     Zero_DrawH     ;branch if 8 < Scroll
                sec
                sbc     ScrollVfine    ;
                sta     DrawH          ;H = 8 - S
                lda     #56
                sta     DrawV          ;V = 56
                rts
Zero_DrawH:
                lda     #0
                sta     DrawH          ;H = 0
                lda     #64            ;DrawHeight*8
                sec
                sbc     ScrollVfine
                sta     DrawV          ;V = 64 - S                    
                rts

ReadMaze:                              ;Reads 4 bytes from maze table
                                       ;Copies the data to:
                                       ;TempHL,TempHR,TempVL,TempVR
                                       ;This data allows computation
                                       ;for one H line and one V line
                                       ;it's called 4 times per frame
                ldy     HorizByte
                lda     (TempPtrH),Y
                sta     TempHL
                lda     (TempPtrV),Y
                sta     TempVL
                iny
                cpy     #4
                bne     No_Wrap
                ldy     #0
No_Wrap:        lda     (TempPtrH),Y
                sta     TempHR
                lda     (TempPtrV),Y
                sta     TempVR
                rts            
Combine:                               ;Combine left and right flags
                                       ;store middle in Temp*R
                lda     TempHR
                asl
                asl
                asl
                asl                    ;RRRR
                sta     TempHR         ;DCBA0000
                lda     TempHL
                lsr
                lsr
                lsr                    ;    LLLL
                lsr                    ;0000HGFE
                                       ;RRRRLLLL
                ora     TempHR         ;DCBAHGFE
                sta     TempHR
                lda     TempVR
                asl
                asl
                asl
                asl                    ;RRRR
                sta     TempVR         ;DCBA0000
                lda     TempVL
                lsr
                lsr
                lsr                    ;    LLLL
                lsr                    ;0000HGFE
                                       ;RRRRLLLL
                ora     TempVR         ;DCBAHGFE
                sta     TempVR
                rts
ShiftMaze:                             ;Use Left and Middle flags
                                       ;generate the shifted flags
                                       ;store the result in Temp*L        
                ldy     SegmentBits
                lda     TempHL
                cpy     #4
                bcs     middle1
left1:          dey
                bmi     done1
                lsr
                jmp     left1
middle1:        dey
                dey
                dey
                dey
                lda     TempHR
mloop1:         dey
                bmi     done1        
                lsr
                jmp     mloop1
done1:          sta     TempHL        
                ldy     SegmentBits
                lda     TempVL
                cpy     #4
                bcs     middle2
left2:          dey
                bmi     done2
                lsr
                jmp     left2
middle2:        dey
                dey
                dey
                dey
                lda     TempVR
mloop2:         dey
                bmi     done2        
                lsr
                jmp     mloop2
done2:          sta     TempVL
                rts        
PreDraw:                               ;Compute Playfield Graphics
                                       ;enter with lookup,
                                       ;and field pointers set.
                lda     TempHL
                tax
                and     #3             ;mask for flags B and A
                tay                    ;use Y as a 0-3 mini-index
                lda     (lookup1),Y
                ldy     #0
                sta     (field),Y      ;store in the Field array.
                inc     field
                txa
                lsr
                tax
                and     #3             ;flags C and B
                tay
                lda     (lookup2),Y
                ldy     #0
                sta     (field),Y
                inc     field
                txa
                lsr
                tax
                and     #3             ;flags D anc C
                tay                
                lda     (lookup1),Y
                ldy     #0
                sta     (field),Y
                inc     field
                txa
                lsr
                and     #3             ;flags E and D                
                tay
                lda     (lookup2),Y
                ldy     #0
                sta     (field),Y
                inc     field

                lda     TempVL
                tax
                and     #3             ;mask for flags B and A
                tay                    ;use Y as a 0-3 mini-index
                lda     (lookup3),Y
                ldy     #0
                sta     (field),Y      ;store in the Field array.
                inc     field
                txa
                lsr
                tax
                and     #3             ;flags C and B
                tay
                lda     (lookup4),Y
                ldy     #0
                sta     (field),Y
                inc     field
                txa
                lsr
                tax
                and     #3             ;flags D anc C
                tay                
                lda     (lookup3),Y
                ldy     #0
                sta     (field),Y
                inc     field
                txa
                lsr
                and     #3             ;flags E and D                
                tay
                lda     (lookup4),Y
                ldy     #0
                sta     (field),Y
                inc     field
                rts
PreDrawPtr:                            ;Setup pointers for Predraw

                lda     #$00           ;ptr to $FE00 + Offset
                clc                    ;addition here to be obvious
                adc     FieldOffset    ;even though X + 0 = X :)
                sta     lookup1
                clc                    ;these clcs probably redundant
                adc     #$20           ;ptr to $FE20 + Offset
                sta     lookup2
                clc                    ;but I like to be SURE anyway
                adc     #$20           ;ptr to $FE40 + Offset
                sta     lookup3
                clc
                adc     #$20           ;ptr to $FE60 + Offset
                sta     lookup4
                lda     #$FE
                sta     lookup1+1
                sta     lookup2+1
                sta     lookup3+1
                sta     lookup4+1
                rts
    
ScrollRight:    ldx     FrameCount     ;Scroll Maze Right - save Acc.
                bne     SRexit         ;forbid scrolling on !0 frames
                inc     ScrollH
SRexit:         rts
ScrollLeft:     ldx     FrameCount     ;Scroll Maze Left - save Acc.
                bne     SLexit
                dec     ScrollH
SLexit:         rts
ScrollDown:                            ;Scroll Maze Down - save Acc.
                pha
                lda     ScrollVfine
                clc
                adc     #1
                sta     ScrollVfine
                cmp     #64            ;overflow?
                bne     SD_done        ;nope
                lda     #0             ;yep
                sta     ScrollVfine        
                lda     ScrollV
                clc
                adc     #4
                and     #$7F           ;mask out overflow bit
                sta     ScrollV
SD_done:        pla
                rts    
ScrollUp:                              ;Scroll Maze Up - save Acc.
                pha
                lda     ScrollVfine
                sec
                sbc     #1
                sta     ScrollVfine    ;wrap below zero?
                bpl     SU_done        ;nope
                lda     #63
                sta     ScrollVfine
                lda     ScrollV
                sec
                sbc     #4
                and     #$7F           ;mask out underflow bit
                sta     ScrollV
SU_done:        pla
                rts

; DATA SEGMENT ------------------------------------------------------

                org     $FD00
                
                           ;The maze data table is exactly 256 bytes
                           ;long and must be page aligned.
                           ;It is split into two segments:
                           ;The horizontal (top) data, and
                           ;The vertical (sides) data.
                           ;H_Table resides at $00 to $7F
                           ;V_Table resides at $80 to $FF
                           ;The maze data is stored left to right
                           ;top to bottom.
                           ;Each line is 4 bytes long
                           ;(which is 32 (4*8) segments).
                           ;There are 32 lines.
                           ;The 32 by 32 maze is about 8 times wider
                           ;and 10 times higher than the screen.
                           ;Within each byte, D0 is leftmost bit.
                           ;To access the data for X (0-3),Y(0-31)
                           ;H_Table index = 4*Y + X
                           ;V_Table index = 4*Y + X + 128  
Table:
H_Table:
                .byte   $00,$11,$22,$33
                .byte   $44,$55,$66,$77
                .byte   $88,$99,$AA,$BB
                .byte   $CC,$DD,$EE,$FF
                
                           ;The $FF padding makes the remaining
                           ;lines into a grid pattern
                            
                org     $FD80
V_Table
                .byte   $00,$11,$22,$33
                .byte   $44,$55,$66,$77
                .byte   $88,$99,$AA,$BB
                .byte   $CC,$DD,$EE,$FF
                
                           ;A clever game would store several
                           ;smaller mazes on this one maze map,
                           ;and use scrolling changes and limits
                           ;to swap maps for levels.
                           ;If you want several maps this size, just
                           ;swap the maze page pointer as needed.
               
                           ;There are four lookup tables.
                           ;each is 32 bytes long.
                           ;They follow each other, starting at $XX00
                            
                org     $FE00
Look_Table1                                ;H shift table, D7 is left
                .byte   $00,$FF,$00,$FF    ;BA:00,01,10,11
                .byte   $00,$FE,$01,$FF
                .byte   $00,$FC,$03,$FF
                .byte   $00,$F8,$07,$FF
                .byte   $00,$F0,$0F,$FF
                .byte   $00,$E0,$1F,$FF
                .byte   $00,$C0,$3F,$FF
                .byte   $00,$80,$7F,$FF

                ;org    $FE20
Look_Table2                                ;H shift table, D0 is left
                .byte   $00,$FF,$00,$FF    ;CB:00,01,10,11
                .byte   $00,$7F,$80,$FF
                .byte   $00,$3F,$C0,$FF
                .byte   $00,$1F,$E0,$FF
                .byte   $00,$0F,$F0,$FF
                .byte   $00,$07,$F8,$FF
                .byte   $00,$03,$FC,$FF
                .byte   $00,$01,$FE,$FF

                ;org    $FE40
Look_Table3                                ;V shift table, D7 is left
                .byte   $00,$80,$00,$80    ;BA:00,01,10,11
                .byte   $00,$00,$01,$01
                .byte   $00,$00,$02,$02
                .byte   $00,$00,$04,$04
                .byte   $00,$00,$08,$08
                .byte   $00,$00,$10,$10
                .byte   $00,$00,$20,$20
                .byte   $00,$00,$40,$40

                ;org    $FE60
Look_Table4                                ;V shift table, D0 is left
                .byte   $00,$01,$00,$00    ;CB:00,01,10,11
                .byte   $00,$00,$80,$80
                .byte   $00,$00,$40,$40
                .byte   $00,$00,$20,$20
                .byte   $00,$00,$10,$10
                .byte   $00,$00,$08,$08
                .byte   $00,$00,$04,$04
                .byte   $00,$00,$02,$02
                
; Vectors -----------------------------------------------------------

                org     IntVectors
                
NMI             .word   Cart_Init
Reset           .word   Cart_Init
IRQ             .word   Cart_Init

;               END
