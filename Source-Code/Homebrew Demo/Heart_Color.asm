;/////////////////////////////////////////////////////////////////
;// Heart Playfied Demo V1.00 - Christian Bogey, April 16, 2004 //
;//      Mirrored Playfield with Playfield Color Scrolling      //		
;/////////////////////////////////////////////////////////////////

                processor 6502 
                include "vcs.h" 
                include "macro.h" 


;///////////////////////// Vars ///////////////////////////////////////

Color_Start = $80	; Playfield Color (Color of the 1st Line)
Color = $81		; Temp Var Address

;/////////////////// Playfield Datas //////////////////////////////////
; PF0
;PFData0_0 = #%11110000	; Up and Down * 8 Lines  // Idem as PFData2_0
PFData0_1 = #%00010000	; Middle * 176

; PF1
;PFData1_0 = #%11111111	; Up and Down * 8 Lines	// Idem as PFData2_0
;PFData1_1 = #%00000000	; Middle * 176		// Idem as PFData2_1
        
; PF2
PFData2_0 = #%11111111	; Up and Down * 8 Lines
PFData2_1 = #%00000000	; Empty Lines * 8 (5 Up and 5 Down)


;/////////////////  Start of Code ///////////////////////////////////// 

                SEG 
                ORG $F000 

Reset 

    		; Clear RAM, TIA registers and Set Stack Pointer to #$FF
		SEI
		CLD	
		LDX #$FF
		TXS
		LDA #0
Clear_Mem
		STA 0,X
		DEX
		BNE Clear_Mem			
		
		STA Color_Start ; Init Playfield Color
                LDA #1
                STA CTRLPF	; Mirrored Playfiels
                LDA #$00
                STA COLUBK	; Set Background to Black

;///////////////////  Picture Starts Here /////////////////////////////

Start_Frame 

    	; Start VSYNC

                LDA #2 
                STA VSYNC 

                STA WSYNC 
                STA WSYNC 
                STA WSYNC    	; 3 Scanlines of VSYNC 

                LDA #0 
                STA VSYNC	; End VSYNC         


	; 37 Scanlines of Vertical Blank... 
           
       		LDX 37
Vertical_Blank  STA WSYNC 
                DEX 
                BNE Vertical_Blank 
                
                LDA #0 
                STA VBLANK 	; Enable TIA Output
                                
;////////////// Start To Draw Playfield ///////////////////////////////      	
          
		LDX Color_Start
		STX Color	
		STX COLUPF  
	; Draw Top Bar		
		LDY #8		; 8 Lines to Draw
		LDA #PFData2_0
		STA PF0
	  	STA PF1
	  	STA PF2
Draw_Bar1   	   
		STA WSYNC   
		DEX
		STX COLUPF  
                DEY
                BNE Draw_Bar1 
                
             
                
	; Draw 5 Empty Lines
                LDY #5*8
		LDA #PFData0_1
		STA PF0
		LDA PFData2_1
		STA PF1
		STA PF2
Empty_Lines1
		STA WSYNC 
		DEX
		STX COLUPF  
	        DEY
                BNE Empty_Lines1                

		
	; Draw Heart
		STX Color
		LDX #$0C	; Init Index
Draw_Heart		
		LDA PF2HeartData-1,X	; (Keep PF0 & PF1)
		STA PF2
		LDY #8		; 8 Lines
		TXA		; Save Index
		LDX Color
Draw_Heart_Line
		STA WSYNC
		DEX
		STX COLUPF  
		DEY
		BNE Draw_Heart_Line
		STX Color	; Save Color Index
		TAX		; Restore Index
		DEX
		BNE Draw_Heart

	; Draw 5 Empty Lines
		LDX Color	; Restore Color Index
                LDY #5*8
		LDA PFData2_1
		STA PF2		; Clear PF2 (Keep PF0 & PF1)
Empty_Lines2
		STA WSYNC   
		DEX
		STX COLUPF  
	        DEY
                BNE Empty_Lines2

	; Draw Bottom Bar		
		LDY #8		; 8 Lines to Draw
		LDA #PFData2_0
		STA PF0
	  	STA PF1
	  	STA PF2
Draw_Bar2   	        
		STA WSYNC   
		DEX
		STX COLUPF             
                DEY
                BNE Draw_Bar2
                
;////////////// End To Draw Playfield /////////////////////////////////     	

	; Makes Colors to Scroll Up	                
                LDX Color_Start
                DEX			; Use INX instead of DEX to Scroll Up
                STX Color_Start

;////////////// End Of Display ////////////////////////////////////////      	
    
		LDA #%01000010 		; Disable VIA Output
                STA VBLANK           

	; 30 scanlines of overscan... 

                LDX #30 
Overscan        STA WSYNC 
                DEX 
                BNE Overscan 

		JMP Start_Frame 	; Build Next Frame

;////////////// Heart Data ////////////////////////////////////////////

PF2HeartData
	.byte #%10000000	; Heart Pic Data End * 8 Lines
 	.byte #%11000000	;
 	.byte #%11100000	;
 	.byte #%11110000	;
 	.byte #%11111000	;
 	.byte #%11111100	;
 	.byte #%11111110	; 12 * 8 = 96
 	.byte #%11111110	;	
 	.byte #%11111110	;
 	.byte #%11111100	;
 	.byte #%11111000	;
 	.byte #%01110000  	; Heart Pic Data Start * 8 Lines
 	
;////////////// Set Vectors ///////////////////////////////////////////

            ORG $FFFA 

; Interrupt Vectors 

            .word Reset           ; NMI 
            .word Reset           ; RESET 
            .word Reset           ; IRQ 

          END 

