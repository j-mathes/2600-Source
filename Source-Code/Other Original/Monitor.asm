        processor 6502
;
; NEW MONITOR
;
;
;
; DAVE CRANE FEB 7 1978
;
; LARRY WAGNER COPY PROM TO RAM DEC 18 1978
;
;
;
; PIA AND TIMER (6532) LOCATIONS

SWCHA   = $280  ;P0,P1 JOYSTICKS **A=B DUE TO WIRING IN STELLAX BOARD**
SWCHB   = $280  ;CONSOLE SWITCHES
CTLSWA  = $281
CTLSWB  = $281
INTIM   = $284  ;INTERVAL TIMER IN
TIM8T   = $295  ;TIMER 8T WRITE OUT
TIM64T  = $296  ;TIMER 64T WRITE OUT
TIM1KT  = $297

; STELLA (TIA) REGISTER ADDRESSES

VSYNC   = $00   ;BIT 1 VERTICAL SYNC SET-CLR
VBLANK  = $01   ;BIT 1 VERTICAL BLANK SET-CLR
WSYNC   = $02   ;STROBE WAIT FOR HORIZ BLANK
RSYNC   = $03   ;STROBE RESET HORIZ SYNC COUNTER
NUSIZ0  = $04   ;BITS 54 210 NUMBER-SIZE PLAYER/MISSILE 0
NUSIZ1  = $05   ;BITS 54 210 NUMBER-SIZE PLAYER/MISSILE 1
COLUP0  = $06   ;BITS 7654321 COLOR(4)-LUM(3) PLAYER 0
COLUP1  = $07   ;BITS 7654321 COLOR(4)-LUM(3) PLAYER 1
COLUPF  = $08   ;BITS 7654321 COLOR(4)-LUM(3) PLAYFIELD
COLUBK  = $09   ;BITS 7654321 COLOR(4)-LUM(3) BACKGROUND
CTRLPF  = $0A   ;BITS 7 54 210 PLAYFIELD CONTROL
REFP0   = $0B   ;BIT 3 REFLECT PLAYER 0
REFP1   = $0C   ;BIT 3 REFLECT PLAYER 1
PF0     = $0D   ;BITS 7654 PLAYFIELD REG BYTE 0
PF1     = $0E   ;BITS ALL PLAYFIELD REG BYTE 1
PF2     = $0F   ;BITS ALL PLAYFIELD REG BYTE 2
RESP0   = $10   ;STROBE RESET PLAYER 0
RESP1   = $11   ;STROBE RESET PLAYER 1
RESM0   = $12   ;STROBE RESET MISSILE 0
RESM1   = $13   ;STROBE RESET MISSILE 1
RESBL   = $14   ;STROBE RESET BALL
AUDC0   = $15   ;BITS 3210 AUDIO CONTROL 0
AUDC1   = $16   ;BITS 3210 AUDIO CONTROL 1
AUDF0   = $17   ;BITS 3210 AUDIO FREQUENCY 0
AUDF1   = $18   ;BITS 3210 AUDIO FREQUENCY 1
AUDV0   = $19   ;BITS 3210 AUDIO VOLUME 0
AUDV1   = $1A   ;BITS 3210 AUDIO VOLUME 1
GRP0    = $1B   ;BITS ALL GRAPHICS FOR PLAYER 0
GRP1    = $1C   ;BITS ALL GRAPHICS FOR PLAYER 1
ENAM0   = $1D   ;BIT 1 ENABLE MISSILE 0
ENAM1   = $1E   ;BIT 1 ENABLE MISSILE 1
ENABL   = $1F   ;BIT 1 ENABLE BALL
HMP0    = $20   ;BITS 7654 HORIZ MOTION PLAYER 0
HMP1    = $21   ;BITS 7654 HORIZ MOTION PLAYER 1

;.PAGE
HMM0    = $22   ;BITS 7654 HORIZ MOTION MISSILE 0
HMM1    = $23   ;BITS 7654 HORIZ MOTION MISSILE 1
HMBL    = $24   ;BITS 7654 HORIZ MOTION BALL
VDELP0  = $25   ;BIT 0 VERTICAL DELAY PLAYER 0
VDELP1  = $26   ;BIT 0 VERTICAL DELAY PLAYER 1
VDELBL  = $27   ;BIT 0 VERTICAL DELAY BALL
RESMP0  = $28   ;BIT 1 RESET MISSILE TO PLAYER 0
RESMP1  = $29   ;BIT 1 RESET MISSILE TO PLAYER 1
HMOVE   = $2A   ;STROBE ACT ON HORIZ MOTION
HMCLR   = $2B   ;STROBE CLEAR ALL HM REGISTERS
CXCLR   = $2C   ;STROBE CLEAR COLLISION LATCHES

; READ ADDRESSES - BITS 7 & 6 ONLY
CXM0P   = $30
CXM1P   = $31
CXP0FB  = $32
CXP1FB  = $33
CXM0FB  = $34
CXM1FB  = $35
CXBLPF  = $36
CXPPMM  = $37
INPT0   = $38
INPT1   = $39
INPT2   = $3A
INPT3   = $3B
INPT4   = $3C
INPT5   = $3D

;.PAGE
        SEG.U ZPAGERAM

; RAM PAGE ZERO DEFINITIONS

        ORG $A0

POINTL  ds 1    ;LOW MEMORY POINTER
POINTH  ds 1    ;HIGH MEMORY POINTER

        SEG.U E8RAM
        ORG $E800

USERAC  ds 1    ;AC
USERX   ds 1    ;REG
USERY   ds 1    ;Y REG
USERSP  ds 1    ;STACK POINTER
PCL     ds 1    ;PC LOW
PCH     ds 1    ;PC HIGH
STATUS  ds 1    ;STATUS REG
CHKSUM  ds 1
CHKHI   ds 1
ERRFLG  ds 1
ERR0    ds 1
ERR1    ds 1
CNTR    ds 1    ;OUTPUT COUNTER
INL     ds 1    ;LOW INPUT BUFFER
INH     ds 1    ;HIGH INPUT BUFFER
TEMP2   ds 1
TMPX    ds 1
TMPX1   ds 1
TMPX2   ds 1
CHAR    ds 1
CNTL30  ds 1
CNTH30  ds 1
TIMH    ds 1
TEMP    ds 1
TEMP1   ds 1
OFFSET  ds 1    ;OFFSET FOR MOVING ZERO PAGE

;.PAGE

        SEG CODE
        ORG $E400
;
;
CTLCON = $282   ;CONTROL CONSOLE SWITCHES
SWHCON = $283   ;DATA CONSOLE SWITCHES
;
RST     LDA #$04        ;SET PROM/RAM SWITCH
        STA CTLCON      ;TO RAM
        LDX #$FF
        STX SWHCON
        STX USERSP
        TXS
        JMP START4
START   STA USERAC      ;(BREAK ENTRY POINT)
        PLA
        STA STATUS
SAVE1   PLA             ;(JSR ENTRY POINT)
        STA PCL
        PLA
        STA PCH
SAVE2   STY USERY
        STX USERX
        TSX
        STX USERSP
        JSR SWAP
        LDA PCL
        STA POINTL
        LDA PCH
        STA POINTH
        CLD
        JMP BREAK
START4  CLD
        SEI
        JSR SWAP
START2  LDA #0
        STA ERRFLG
START3  LDX #$FF
        TXS
        LDA #1
        STA CNTH30      ;SET 300 BAUD
        LDA #$1C
        STA CNTL30
        LDA #$3F
        STA CTLSWB
PROMPT  LDA ERRFLG
        BEQ PROMPA
        JMP ENDLD2
PROMPA  JSR CRLF
PROMP1  LDA #$3E        ;'>'
        JSR OUTCH
        LDA #0          ;CLEAR INPUT BUFFER
        STA INH
        STA INL
        STA ERRFLG
GETHEX  JSR GETBYT
        BEQ GETHEX
        CMP #$20        ;SPACE
        BEQ PROC1
        CMP #$2E        ;'.'
        BEQ PROC2
        CMP #$D         ;CARRIAGE RETURN
        BEQ PROC3
        CMP #$A         ;LINE FEED
        BEQ PROC4
        CMP #$52        ;'R' RAM TESTER
        BNE GETHE1
        JMP RAMTST
GETHE1  CMP #$48        ;'H'
        BEQ HIBAUD
        CMP #$4D        ;'M' TO MOVE PROM TO RAM
        BNE GETHE2
        JMP COPY
GETHE2  CMP #$4C        ;'L'
        BEQ LOBAU1
        CMP #$47        ;'G'
        BEQ PROC5
        CMP #$7F        ;RUBOUT
        BEQ START2
        JMP GETHEX      ;IGNORE ILLEGAL CHARACTERS
PROC1   JSR OPEN        ;OPEN AND DISPLAY CURRENT CELL
        JSR TESTLM      ;TEST FOR E0-FF LIMITS
        JMP SHOW
PROC2   LDY #0
        JSR TESTLM      ;GO GET OFFSET
        JSR ADDOFF
        LDA INL
        STA (POINTL),Y  ;STORE DATA
        LDA TEMP2       ;RESTORE POINTH
        STA POINTH
PROC3   JSR INCPT       ;NEXT CELL
        JMP SHOW
PROC4   SEC
        LDA POINTL      ;DECREMENT POINTER
        SBC #1
        STA POINTL
        BCS PROC4A
        DEC POINTH
PROC4A  JMP SHOW
PROC5   LDX #$A0        ;RESTORE RAM
        LDA POINTL
        STA PCL
        LDA POINTH
        STA PCH
PROC5A  LDA $E800,X
        STA $00,X
        INX
        BNE PROC5A
GOEXEC  LDX USERSP
        TXS
        LDA PCH
        PHA
        LDA PCL
        PHA
        LDA STATUS
        PHA
        LDA #0          ;RESTORE JOYSTICK PORT TO READ ONLY
        STA CTLSWA
        LDX USERX
        LDY USERY
        LDA USERAC
        RTI
HIBAUD  JSR CRLF
        LDA #$44
        STA CNTL30
        LDA #0
        STA CNTH30
        JMP LOBAUD
LOBAU1  JSR CRLF
LOBAUD  LDY #0
        JSR GETCH       ;LOADER ROUTINE
        CMP #$3B        ;SEMICOLON
        BNE LOBAUD      ;WAIT FOR SEMICOLON
LOAD1   LDA #0          ;CLR CHKSUM
        STA CHKSUM
        STA CHKHI
        JSR GETTST
        TAX             ;PUT BYTE COUNT IN X
        BEQ ENDLD       ;IF ZERO BYTE COUNT, GO END
        JSR CHK         ;ADD TO CHKSUM
        ;
        JSR GETTST      ;GET HIGH ADDRESS
        STA POINTH
        JSR CHK
        JSR GETTST      ;GET LOW ADDRESS
        STA POINTL
        JSR CHK
        ;
LOAD2   JSR GETTST      ;GET DATA
        STA (POINTL),Y
        JSR CHK
        JSR INCPT
LOAD3   DEX
        BNE LOAD2
        ;
LOAD4   JSR GETTST      ;COMPARE CHKSUM
        CMP CHKHI
        JSR ERROR1
        JSR GETTST
        CMP CHKSUM
        JSR ERROR1
        JMP LOBAUD
        ;
        ;
GETTST  JSR GETBYT
        BEQ GETTS1
        LDA #1          ;BIT 0 IS ILLEGAL CHARACTER
ERROR2  STA ERRFLG
        LDA POINTL      ;SAVE ERROR ADDRESS
        STA ERR0
        LDA POINTH
        STA ERR1
        PLA
        PLA
        JMP LOBAUD
GETTS1  LDA INL
ERROR3  RTS
ERROR1  BEQ ERROR3
        LDA ERRFLG
        ORA #2          ;BIT 1 IS CHECKSUM ERROR
        JMP ERROR2
        ;
ENDLD   LDX #2          ;READ REMAINING ZEROS
ENDLD1  JSR GETTST
        DEX
        BPL ENDLD1
ENDLD2  JSR CRLF
        LDX #9          ;PRINT ERROR MESSAGE
ENDLD3  LDA MSGTBL,X
        JSR OUTCH
        DEX
        BPL ENDLD3
        LDA ERRFLG
        JSR PRTBYT
        JSR OUTSP
        LDA ERR1
        JSR PRTBYT
        LDA ERR0
        JSR PRTBYT
        JMP START2
        ;
        ;
SHOW    JSR CRLF
        JSR PRTPNT
        JSR OUTSP
        JSR ADDOFF
        LDY #0
        LDA (POINTL),Y
        JSR PRTBYT
        LDA TEMP2
        STA POINTH
        JSR OUTSP
        JMP PROMP1
        ;
        ;
        ; BEGIN SUBROUTINES
        ;
;.PAGE
        ;
        ; ADD OFFSET TO POINTH
        ;
ADDOFF  CLC             ;ADD IT IN
        LDA POINTH
        STA TEMP2
        ADC OFFSET
        STA POINTH
        RTS
        ;
        ; GET CHARACTER
        ;
GETCH   STX TMPX        ;SAVE X
        LDY #$7
GET1    BIT SWCHA
        BMI GET1        ;WAIT FOR START BIT
        JSR DELAY       ;DELAY 1 BIT
GET5    JSR DEHALF      ;DELAY 1/2 BIT
GET2    LDA SWCHA       ;GET 8 BITS
        AND #$80        ;MASK OFF LOW ORDER BITS
        LSR CHAR        ;SHIFT RIGHT CHARACTER
        ORA CHAR
        STA CHAR
        JSR DELAY       ;DELAY 1 BIT TIME
        DEY
        BNE GET2        ;GET NEXT CHAR
        JSR DEHALF      ;EXIT THIS RTN
        ;
        LDX TMPX
        LDA CHAR
        LSR
GET6    RTS
        ;
        ;
        ; PRINT CARRIAGE RETURN AND LINE FEED
        ;
CRLF    STX TMPX1
        LDA #$0D        ;CR
        JSR OUTCH
        LDA #$0A        ;LF
        JSR OUTCH
        LDX #5          ;PRINT NULLS
CRLF1   LDA #0
        JSR OUTCH
        DEX
        BPL CRLF1
        LDX TMPX1
        RTS
        ;
        ; PRINT CHARACTER
        ; X IS PRESERVED Y = $FF
        ; OUTSP PRINTS 1 SPACE
        ;
OUTSP   LDA #$20
OUTCH   STA CHAR
        STX TMPX2
        LDA #$3F        ;MAKE JOYSTICK PORT READ/WRITE
        STA CTLSWB
OUT3    JSR DELAY
        LDA SWCHB       ;START BIT
        AND #$FE
        STA SWCHB
        JSR DELAY
        LDY #$8
OUT1    LDA SWCHB       ;DATA BIT
        AND #$FE
        LSR CHAR
        ADC #0
        STA SWCHB
        JSR DELAY
        DEY
        BNE OUT1
        LDA SWCHB       ;STOP BIT
        ORA #$1
        STA SWCHB
        JSR DELAY       ;STOP BIT
        LDX TMPX2
        LDA #0
        STA CTLSWA
        RTS
        ;
        ; DELAY 1 BIT TIME
        ;
DELAY   LDA CNTH30
        STA TIMH
        LDA CNTL30
DE2     SEC
DE4     SBC #$1
        BCS DE3
        DEC TIMH
DE3     LDX TIMH
        BPL DE2
        RTS
        ;
        ; DELAY 1/2 BIT TIME
        ;
DEHALF  LDA CNTH30
        STA TIMH
        LDA CNTL30
        LSR
        LSR TIMH
        BCC DE2
        ORA #$80
        BCS DE4
        ;
        ;
        ;
        ;
        ; SUB TO PRINT POINTL,POINTH
        ;
PRTPNT  LDA POINTH
        JSR PRTBYT
        LDA POINTL
        JSR PRTBYT
        RTS
        ;
        ;
        ; PRINT 1 HEX BYTE AS TWO ASCII CHARACTERS
        ;
PRTBYT  STA TEMP
        LSR
        LSR
        LSR
        LSR
        JSR HEXTA       ;CONVERT TO HEX AND PRINT
        LDA TEMP        ;GET BOTTOM HALF
        JSR HEXTA
        LDA TEMP        ;RESTORE ACCUMULATOR
        RTS
        ;
HEXTA   AND #$F         ;MASK
        CMP #$A
        CLC
        BMI HEXTA1
        ADC #7          ;ALPHA HEX
HEXTA1  ADC #$30        ;DEC HEX
        JMP OUTCH
        ;
        ;
        ; SUBROUTINE TO INCREMENT MEMORY POINTER
        ;
INCPT   INC POINTL
        BNE INCPT2
        INC POINTH
INCPT2  RTS
        ;
        ;
        ; GET 2 HEX CHARACTERS AND PACK THEM INTO
        ; THE INPUT BUFFER. X IS PRESERVED. ANY NON-HEX
        ; CHARACTER IS RETURNED IN THE AC. ANY ENTRY
        ; BETWEEN 0 AND F INCLUSIVE CAUSES A 0 RETURN IN THE AC.
        ;
GETBYT  JSR GETCH
        JSR PACK
        BNE GETBY1      ;RETURN IF NON-HEX
        JSR GETCH       ;IF HEX, GET SECOND DIGIT
        JSR PACK
GETBY1  RTS
        ;
        ;
        ; SHIFT AC INTO INPUT BUFFER
        ;
PACK    CMP #$30        ;CHECK FOR HEX
        BMI UPDAT2
        CMP #$47        ;NOT HEX EXIT
        BPL UPDAT2
HEXNUM  CMP #$40        ;CONVERT TO HEX
        BMI UPDATE
HEXALP  CLC
        ADC #$9
UPDATE  ROL
        ROL
        ROL
        ROL
        LDY #4          ;SHIFT INTO BUFFER
UPDAT1  ROL
        ROL INL
        ROL INH
        DEY
        BNE UPDAT1
        LDA #0          ;RETURN 0 IF HEX
UPDAT2  CMP #0          ;RESTORE FLAGS
        RTS
        ;
        ;
        ; OPEN CELL BY MOVING INPUT BUFFER INTO POINTER
        ;
OPEN    LDA INL
        STA POINTL
        LDA INH
        STA POINTH
        RTS
        ;
        ;
        ;
        ; COMPUTE CHKSUM
        ;
CHK     CLC
        ADC CHKSUM
        STA CHKSUM
        LDA CHKHI
        ADC #0
        STA CHKHI
        RTS
        ;
        ;
        ; TEST LIMITS. TEST FOR E0-FF, IF SO, OFFSET=$FC
        ;
TESTLM  LDA #0
        STA OFFSET
        LDA POINTH
        BNE TESTL1
        LDA POINTL
        CMP #$A0
        BCC TESTL1      ;BRANCH IF POINTH.LT.$E0
        LDA #$E8
        STA OFFSET
TESTL1  RTS
        ;
SWAP    LDX #$A0        ;SAVE 80-FF AT E880-E8FF
START1  LDA $00,X
        STA $E800,X
        INX
        BNE START1
        RTS
        ;
        ;
        ; PRINT BYTE FOLLOWED BY A SPACE
        ;
PBYTSP  JSR PRTBYT
        JMP OUTSP
        ;
        ;
        ;
        ;
        ;
        ;
        ; BL : R O R R E BL
MSGTBL  .BYTE $07,$20,$3A,$20,$52,$4F,$52,$52,$45,$07
        .BYTE "PS SP A Y X CP"
        ;
        ;
        ;
        ; BREAK DISPLAY
        ;
BREAK   JSR CRLF
        LDX #$12
BREAK1  LDA MSGTBL+10,X
        JSR OUTCH
        DEX
        BPL BREAK1
        JSR CRLF
        LDA PCH
        JSR PRTBYT
        LDA PCL
        JSR PBYTSP
        LDA USERX
        JSR PBYTSP
        LDA USERY
        JSR PBYTSP
        LDA USERAC
        JSR PBYTSP
        LDA STATUS
        JSR PBYTSP
        LDA USERSP
        JSR PRTBYT
        JMP START4
        ;
        ;
        ;
        ; RAM TESTER: TEST RAM FROM POINTL,H TO INL,H
        ; REMOVED TO ALLOW COPY
        ;
RAMTST  JMP PROMPT      ;STUB UNTIL MORE ROOM
        ;
        ; COPY PROM TO RAM
        ;
COPY    LDA #$04
        STA CTLCON
        LDA #$E8
        STA POINTH
        LDA #$00
        STA POINTL
        TAY
        TAX
HOW     STX SWHCON
        LDA (POINTL),Y
        LDX #$FF
        STX SWHCON
        STA (POINTL),Y
        INC POINTL
        LDX #$00
        CPX POINTL
        BNE HOW
        INC POINTH
        CPX POINTH
        BNE HOW
        JMP RST
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ORG $E7FC
        .WORD RST
        .WORD START
        ;
        ;
        .END
