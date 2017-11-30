;;Disassembly of "Colors PAL" (unknown programmer) by Rick Skrbina 11/27/09

      processor 6502
      include "vcs.h"

;;Constants

CB_Height	equ $0A		;height of color bars
Cycle_Limit	equ $1F		;number of frames for debounce to clear
Blank_Height	equ $20		;height of top blank
VB_Time		equ $36		;length of vertical blank
OS_Time		equ $3C		;length of overscan
Kernel_Time	equ $FF		;length of kernel


;;RAM usage

	seg.u RAM
	org $80
Debounce   	ds 1
Solid_Color     ds 1 ;0=draw bars. acts as an index for Color Table



	seg Code
       org $F800,0
 
       .byte 0		;1K of blank space
       
       
       org $FC00,0	
  
Start
       CLD            ;2
       SEI            ;2
       LDX #$FF       ;2
       TXS            ;2
       INX            ;2
       TXA            ;2
Clear_RAM: 
       STA $00,X      ;4
       INX            ;2
       BNE Clear_RAM  ;2
       
       LDX #$FF       ;2	Set up Playfield
       STX PF0        ;3
       STX PF1        ;3	
       STX PF2        ;3
       LDA #$0C       ;2	Distortion #12
       STA AUDC0      ;3
       LDA #$0F       ;2	Volume 12 (12 is highest)
       STA AUDV0      ;3
       LDA #$0E       ;2	Note = F
       STA AUDF0      ;3
       
Start_Frame: 

       LDA #$03       ;2
       STA WSYNC      ;3	
       STA VBLANK     ;3
       STA VSYNC      ;3	start vertical sync
       STA WSYNC      ;3
       STA WSYNC      ;3
       STA WSYNC      ;3
       LDX #$00       ;2
       STX VSYNC      ;3	end vertical sync
       
       LDA #VB_Time   ;2
       STA TIM64T     ;4
       
       LDA SWCHB      ;4	check Select switch
       ROR            ;2
       ROR            ;2
       BCS Not_Pushed ;2
       LDA Debounce   ;3
       BNE Debounce_Logic   ;2
       
Load_Solid_Color: 

       INC Solid_Color;5
       LDA Solid_Color;3
       CMP #$11       ;2	have all the Color_Table values been used?	
       BNE Dont_Resume_Bars   ;2
       
       LDA #$00       ;2 clears Solid_Color (displays bars)
       
Dont_Resume_Bars: 

       STA Solid_Color     ;3
       
Debounce_Logic: 
       INC  Debounce       ;5
       LDA Debounce        ;3
       AND #Cycle_Limit    ;2	Is it time to clear Debounce? 	
       BNE Vertical_Blank  ;2
       
       BEQ Load_Solid_Color;2
       
Not_Pushed: 
       LDY #$00            ;2
       STY Debounce        ;3	Allow select 
       
Vertical_Blank: 
       LDA INTIM          ;4
       BNE Vertical_Blank ;2
       
       LDA #Kernel_Time   ;2
       STA TIM64T         ;4
       
       LDA Solid_Color    ;3	bars or solid colors?
       BNE Draw_Solid     ;2
       
       LDY #Blank_Height  ;2
Top_Blank: 
       STA WSYNC       ;3
       DEY             ;2
       BNE Top_Blank   ;2

       STA WSYNC      ;3
       STY VBLANK     ;3	turn on display
       
       LDX #$01       ;2
       LDY #$00       ;2	unneeded
       
Draw_Bar: 
       STA WSYNC      ;3
       CPY #CB_Height ;2
       BNE New_Bar    ;2
       INX            ;2
       LDY    #$00    ;2
Color_Kernel: 
       LDA Color_Table,X ;4
       INY            ;2
       STA COLUPF     ;3
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2	delay
       NOP            ;2
       ADC #$02       ;2	next color...
       STA COLUPF     ;3
       ADC #$02       ;2	...
       STA COLUPF     ;3
       ADC #$02       ;2	...
       STA COLUPF     ;3
       ADC #$02       ;2	...
       STA COLUPF     ;3
       ADC #$02       ;2	...
       STA COLUPF     ;3
       ADC #$02       ;2	...
       STA COLUPF     ;3
       ADC #$02       ;2	...
       STA COLUPF     ;3
       CPX #$11       ;2	number of color bars
       BEQ Done_Drawing;2
       
       JMP Draw_Bar   ;3	could use BNE
New_Bar: 
       BNE Color_Kernel   ;2
Done_Drawing: 

       LDA #$03       ;2
       STA VBLANK     ;3	Turn off display
       JMP Remaining_Kernel_Time  ;3	could use BNE
       
Draw_Solid: 
       TAX            ;2
       LDA Color_Table,X ;4
       STA COLUPF     ;3
       LDA #$00       ;2	Turn on display
       STA VBLANK     ;3	
       STA AUDV0      ;3	volume = 0 (no more sound)
       
Remaining_Kernel_Time: 
       LDA INTIM      ;4
       BNE Remaining_Kernel_Time   ;2
       
       LDA #OS_Time   ;2
       STA TIM64T     ;4
Overscan: 
       LDA INTIM      ;4
       BNE Overscan   ;2
       
       JMP Start_Frame;3
       
       
Color_Table: 		;contains starting color of each horizontal color bar

       .byte $FF ; |XXXXXXXX| $1CD7
       .byte $00 ; |        | $1CD8
       .byte $10 ; |   X    | $1CD9
       .byte $40 ; | X      | $1CDA
       .byte $60 ; | XX     | $1CDB
       .byte $80 ; |X       | $1CDC
       .byte $A0 ; |X X     | $1CDD
       .byte $C0 ; |XX      | $1CDE
       .byte $D0 ; |XX X    | $1CDF
       .byte $B0 ; |X XX    | $1CE0
       .byte $90 ; |X  X    | $1CE1
       .byte $70 ; | XXX    | $1CE2
       .byte $50 ; | X X    | $1CE3
       .byte $30 ; |  XX    | $1CE4
       .byte $20 ; |  X     | $1CE5
       .byte $E0 ; |XXX     | $1CE6
       .byte $F0 ; |XXXX    | $1CE7
   
       
       org $FFFC
	.word Start       
	.byte $00,$00
