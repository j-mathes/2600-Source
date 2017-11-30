;***********************************************************************
;**                                                                   **
;**     Asymmetrical Playfield With Two Vertical Scrolling V1.01      **
;**                 Christian Bogey - April 17,2004                   **
;**                                                                   **
;***********************************************************************

; Speed of each Playfield Scrolling Can be ajusted playing with
; Vars : Scroll_Speed_Left & Scroll_Speed_Right 
; Lower Value = Faster Scrolling (1-n)


               processor 6502 
               include "vcs.h" 
               include "macro.h" 
                
;-----------------------------------------------------------------------
;-                          Define Variables                           -
;-----------------------------------------------------------------------
                       ; Right Playfield Pattern for current Frame 
PF0ADR = $80           ; 1st byte in RAM
PF1ADR = $81
PF2ADR = $82

PF0TMP = $83           ; Right Playfield Pattern of the 1st line
PF1TMP = $84           ; to draw for the current Frame
PF2TMP = $85

PF0Ghost = $86         ; Temp Var for Right Playfield
Scroll_Value_Right = $87

PF0Left = $88          ; Bytes for Left Playfield Pattern
PF1Left = $89
PF2Left = $8A

PF0LeftTMP = $8B       ; Left Playfield Pattern of the 1st line
PF1LeftTMP = $8C       ; to draw for the current Frame
PF2LeftTMP = $8D

Scroll_Value_Left = $8E

Scroll_Speed_Left = 1  ; Lower Value = Faster Scrolling (1-n)
Scroll_Speed_Right = 7 ; Lower Value = Faster Scrolling (1-n)

PF0DATA = #%00110011   ; Playfield Patterns (Init Values)	
PF1DATA = #%11001100
PF2DATA = #%00110011

Color_Left = #$48      ; Red
Color_Right = #$B8     ; Green

;-----------------------------------------------------------------------
;-                         Start of code here                          -
;-----------------------------------------------------------------------

               SEG 
               ORG $F000 

Reset 

;-----------------------------------------------------------------------
;-        Clear RAM, TIA registers and Set Stack Pointer to #$FF       -                               
;-----------------------------------------------------------------------
        
               SEI
               CLD	
               LDX #$FF
               TXS
               LDA #0
Clear_Mem
               STA 0,X
               DEX
               BNE Clear_Mem	

               LDA #PF0DATA     ; Init Playfield Pattern
               STA PF0LeftTMP
               STA PF0TMP
               LDA #PF1DATA
               STA PF1LeftTMP
               STA PF1TMP
               LDA #PF2DATA
               STA PF2LeftTMP
               STA PF2TMP
               LDA #Scroll_Speed_Right ; Init Scroll Vars
               STA Scroll_Value_Right
               LDA #Scroll_Speed_Left
               STA Scroll_Value_Left
               
               LDA #0
               STA COLUBK       ; Background = Black     
               LDA #%00000010   ; Active Score Bit = 2 Colors for Playfield
               STA CTRLPF
               LDA #Color_Left  ; Left Playfield Color
               STA COLUP0
               LDA #Color_Right ; Right Playfield Color
               STA COLUP1
		
;-----------------------------------------------------------------------
;-                         Start to Build Frame                        -
;-----------------------------------------------------------------------				

Start_Frame 

         
       ; Start of Vertical Blank 

               LDA #2 
               STA VSYNC 

               STA WSYNC 
               STA WSYNC 
               STA WSYNC         ; 3 scanlines of VSYNC

               LDA #0 
               STA VSYNC            
                
       
       ; Start of Vertival Blank
       ; Count 37 Scanlines

               LDA  #43          ; 2 cycles
               STA  TIM64T       ; 4 cycles

;>>>> Free space for code starts here 
               
               LDA PF0LeftTMP    ; Load Pattern (Left Side)
               STA PF0Left       ; for current Loop
               LDA PF1LeftTMP
               STA PF1Left
               LDA PF2LeftTMP
               STA PF2Left
            
               LDA PF0TMP        ; Load Pattern (Right Side)
               STA PF0ADR        ; for current loop
               LDA PF1TMP
               STA PF1ADR
               LDA PF2TMP
               STA PF2ADR

       ;>>>> Scroll Left Side <<<<
       
               DEC Scroll_Value_Left   ; Scroll Time for Left Side ?
               BNE No_Scroll_Left      ; No -> Continue
               LDA #Scroll_Speed_Left
               STA Scroll_Value_Left
               
        ; Build Pattern to Scroll for the Next Loop               
               DEC PF0LeftTMP
               DEC PF1LeftTMP
               DEC PF2LeftTMP
               
No_Scroll_Left

       ;>>>> Scroll Right Side <<<<
               
               DEC Scroll_Value_Right  ; Scroll Time for Right Side ?
               BNE No_Scroll_Right     ; No -> Continue
               LDA #Scroll_Speed_Right ; Init Scroll Vars
               STA Scroll_Value_Right 
               
       ; Build Pattern to Scroll for the Next Loop                
       ; Change Pattern PF0
               LDA PF0TMP        ; ////////// 80x86 ROL START
               ASL                               
               BCC ASL_00
               ORA #%000000001
ASL_00                  
               STA PF0TMP        ; ////////// 80x86 ROL END
                
       ; Change Pattern PF1                
               LDA PF1TMP        ; ////////// 80x86 ROL START
               LSR                               
               BCC ASL_01
               ORA #%10000000
ASL_01                  
               STA PF1TMP        ; ////////// 80x86 ROL END
               
       ; Change Pattern PF2               
               LDA PF2TMP        ; ////////// 80x86 ROL START
               ASL               
               BCC ASL_02
               ORA #%000000001
ASL_02                  
               STA PF2TMP        ; ////////// 80x86 ROL END               

No_Scroll_Right               

       
;>>>> Free space for code ends here

Wait_VBLANK_End
               LDA INTIM                 ; 4 cycles
               BPL Wait_VBLANK_End       ; 3 cycles
               STA WSYNC         ; 3 cycles  Total Amount = 21 cycles
                                 ; 2812-21 = 2791; 2791/64 = 43.60 (TIM64T)

               LDA #0 
               STA VBLANK       ; Enable TIA Output
                                
      
       ; Display 192 Scanlines of Asymmetrical Playfield with
       ; one Scrolling for each Side of the Playfield
		
               LDY #48           ; Build 48 * (2+1+1) = 192 Scanlines
               LDX #2            ; Build 2 Scanlines
Picture                          ; (+ 2 more later = 4)
               LDA PF0Left       ; Build Left Playfield
               STA PF0
               LDA PF1Left
               STA PF1
               LDA PF2Left
               STA PF2
		
               SLEEP 4           ; Build Right Playfield
               LDA PF0ADR
               STA PF0
               SLEEP 4
               LDA PF1ADR
               STA PF1
               SLEEP 4
               LDA PF2ADR                
               STA PF2
               STA WSYNC        
               DEX               ; 2 Scanlines build ?
               BNE Picture       ; No = Continue
                
       ;---------------- Build Scanline 3
               LDA PF0Left       ; Build Left Playfield
               STA PF0
               LDA PF1Left
               STA PF1
                
               LDA PF0ADR        ; ////////// 80x86 ROL START
               ASL               ; Change Pattern PF0 and store it                 
               BCC ASL_0         ; into Temp Address for Right PF
               ORA #%000000001
ASL_0                  
               STA PF0Ghost      ; ////////// 80x86 ROL END
              
               LDA PF2Left
               STA PF2
               
               LDA PF0ADR        ; Build Right Playfield
               STA PF0
               INC PF0Left       ; New PF0 Pattern for incoming
                                 ; Left Side
               LDA PF1ADR
               STA PF1
               INC PF1Left       ; New PF1 Pattern for incoming
                                 ; Left Side
               LDA PF2ADR
               STA PF2
               LDA PF0Ghost     
               STA PF0ADR        ; Update PF0 Data with New Pattern
               STA WSYNC         ; 3 Scanlines
               
       ;---------------- Build Scanline 4
                                 ; Build Left Playfield
               INC PF2Left       ; New PF2 Pattern for Left Side
               LDA PF0Left
               STA PF0           
               LDA PF1Left
               STA PF1
               
               LDA PF1ADR        ; ////////// 80x86 ROL START
               LSR               ; Change Pattern PF1 for                 
               BCC ASL_1         ; Right Playfield
               ORA #%10000000
ASL_1                
               STA PF1ADR        ; ////////// 80x86 ROL END
           
               LDA PF2Left
               STA PF2
              
               LDA PF0ADR        ; Build Right Playfield
               STA PF0
               LDA PF1ADR
               STA PF1
               LDA PF2ADR        ; ////////// 80x86 ROL START
               ASL               ; Change Pattern PF2
               BCC ASL_2
               ORA #%00000001
ASL_2           
               STA PF2ADR        ; ////////// 80x86 ROL END                
               STA PF2
               LDX #2		 ; 2 Scanlines To Draw for Next loop
               STA WSYNC	 ; 4 Scanlines
               DEY               ; * 48 = 192 Scanlines
               BEQ Picture_End   ; Lenght to Branch Overflow
               JMP Picture       ; so use JMP
Picture_End

;-----------------------------------------------------------------------
;-                            Frame Ends Here                          -
;-----------------------------------------------------------------------
    		
               LDA #%01000010 
               STA VBLANK        ; Disable TIA Output 


       ; 30 Scanlines of Overscan
        
               LDX #30 
Overscan        
               STA WSYNC 
               DEX 
               BNE Overscan 

               JMP Start_Frame   ; Build Next Frame 


;-----------------------------------------------------------------------
;-                          Set Interrup Vectors                       -
;-----------------------------------------------------------------------


               ORG $FFFA 

Interrupt_Vectors 

               .word Reset       ; NMI 
               .word Reset       ; RESET 
               .word Reset       ; IRQ 

       END 

