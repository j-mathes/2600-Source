;some redundancy removed
;some data shared
;indirect-return routines removed
;pause function added (B&W switch)
;Digit pointer temps shared with all display temps (frees 8 bytes of ram)
;7800 detect added




; Disassembly of Demonatk.bin
; Disassembled Sat Jul 09 20:32:24 2005
; Using DiStella v2.0
;
; Command Line: C:\BIN\DISTELLA.EXE -pafscDemonatk.cfg Demonatk.bin 
;
; Demonatk.cfg contents:
;
;      CODE 1000 12A0
;      GFX 12A1 12A6
;      CODE 12A7 12EE
;      GFX 12EF 12F6
;      CODE 12F7 1ACD
;      GFX 1ACE 1AD1
;      CODE 1AD2 1B9E
;      GFX 1B9F 1BAE
;      CODE 1BAF 1CB1
;      GFX 1CB2 1CC1
;      CODE 1CC2 1D87
;      GFX 1D88 1FFF
;      

      processor 6502

;hardware register equates
VSYNC   =  $00 ;Vertical Sync Set-Clear
VBLANK  =  $01 ;Vertical Blank Set-Clear
WSYNC   =  $02 ;Wait for Horizontal Blank
RSYNC   =  $03 ;Reset Horizontal Sync Counter
NUSIZ0  =  $04 ;Number-Size player/missle 0
NUSIZ1  =  $05 ;Number-Size player/missle 1
COLUP0  =  $06 ;Color-Luminance Player 0
COLUP1  =  $07 ;Color-Luminance Player 1
COLUPF  =  $08 ;Color-Luminance Playfield
COLUBK  =  $09 ;Color-Luminance Background
CTRLPF  =  $0A ;Control Playfield, Ball, Collisions
REFP0   =  $0B ;Reflection Player 0
REFP1   =  $0C ;Reflection Player 1
PF0     =  $0D ;Playfield Register Byte 0 (upper nybble used only)
PF1     =  $0E ;Playfield Register Byte 1
PF2     =  $0F ;Playfield Register Byte 2
RESP0   =  $10 ;Reset Player 0
RESP1   =  $11 ;Reset Player 1
RESM0   =  $12 ;Reset Missle 0
RESM1   =  $13 ;Reset Missle 1
RESBL   =  $14 ;Reset Ball
;Audio registers
AUDC0   =  $15 ;Audio Control - Voice 0 (distortion)
AUDC1   =  $16 ;Audio Control - Voice 1 (distortion)
AUDF0   =  $17 ;Audio Frequency - Voice 0
AUDF1   =  $18 ;Audio Frequency - Voice 1
AUDV0   =  $19 ;Audio Volume - Voice 0
AUDV1   =  $1A ;Audio Volume - Voice 1
;Sprite registers
GRP0    =  $1B ;Graphics Register Player 0
GRP1    =  $1C ;Graphics Register Player 1
ENAM0   =  $1D ;Graphics Enable Missle 0
ENAM1   =  $1E ;Graphics Enable Missle 1
ENABL   =  $1F ;Graphics Enable Ball
HMP0    =  $20 ;Horizontal Motion Player 0
HMP1    =  $21 ;Horizontal Motion Player 1
HMM0    =  $22 ;Horizontal Motion Missle 0
HMM1    =  $23 ;Horizontal Motion Missle 1
HMBL    =  $24 ;Horizontal Motion Ball
VDELP0  =  $25 ;Vertical Delay Player 0
VDELP1  =  $26 ;Vertical Delay Player 1
VDEL01  =  $26 ;Vertical Delay Player 1
VDELBL  =  $27 ;Vertical Delay Ball
RESMP0  =  $28 ;Reset Missle 0 to Player 0
RESMP1  =  $29 ;Reset Missle 1 to Player 1
HMOVE   =  $2A ;Apply Horizontal Motion
HMCLR   =  $2B ;Clear Horizontal Move Registers
CXCLR   =  $2C ;Clear Collision Latches
Waste1  =  $2D ;Unused
Waste2  =  $2E ;Unused
Waste3  =  $2F ;Unused
;collisions                     (bit 7) (bit 6)
CXM0P   =  $30 ;Read Collision - M0-P1   M0-P0
CXM1P   =  $31 ;Read Collision - M1-P0   M1-P1
CXP0FB  =  $32 ;Read Collision - P0-PF   P0-BL
CXP1FB  =  $33 ;Read Collision - P1-PF   P1-BL
CXM0FB  =  $34 ;Read Collision - M0-PF   M0-BL
CXM1FB  =  $35 ;Read Collision - M1-PF   M1-BL
CXBLPF  =  $36 ;Read Collision - BL-PF   -----
CXPPMM  =  $37 ;Read Collision - P0-P1   M0-M1
INPT0   =  $38 ;Read Pot Port 0
INPT1   =  $39 ;Read Pot Port 1
INPT2   =  $3A ;Read Pot Port 2
INPT3   =  $3B ;Read Pot Port 3
INPT4   =  $3C ;Read Input - Trigger 0 (bit 7)
INPT5   =  $3D ;Read Input - Trigger 1 (bit 7)
;RIOT registers
SWCHA  = $0280 ;Port A data register for joysticks (High nybble:player0,low nybble:player1)
SWACNT = $0281 ;Port A data direction register (DDR)
SWCHB  = $0282 ;Port B data (console switches) bit pattern LR--B-SR
SWBCNT = $0283 ;Port B data direction register (DDR)
INTIM  = $0284 ;Timer output
TIMINT = $0285 ;
WasteA = $0286 ;Unused/undefined
WasteB = $0287 ;Unused/undefined
WasteC = $0288 ;Unused/undefined
WasteD = $0289 ;Unused/undefined
WasteE = $028A ;Unused/undefined
WasteF = $028B ;Unused/undefined
WasteG = $028C ;Unused/undefined
WasteH = $028D ;Unused/undefined
WasteI = $028E ;Unused/undefined
WasteJ = $028F ;Unused/undefined
WasteK = $0290 ;Unused/undefined
WasteL = $0291 ;Unused/undefined
WasteM = $0292 ;Unused/undefined
WasteN = $0293 ;Unused/undefined
TIM1T  = $0294 ;set 1 clock interval
TIM8T  = $0295 ;set 8 clock interval
TIM64T = $0296 ;set 64 clock interval
T1024T = $0297 ;set 1024 clock interval

Score        = $81 ;($81-86)
FrameCounter = $BD
Level        = $BE
Temp         = $DC

PrintTemp    = $DD ;($DD-$E8)
;shared...corrupted when score printed
Sprite0Ptr   = PrintTemp ;moved...was $C0-$C1
Sprite1Ptr   = PrintTemp+2 ;moved...was $C2-$C3
ColorPtr     = PrintTemp+4 ;moved...was $CD-$CE
EnemyYtmp    = PrintTemp+6 ;moved...was $C4
Temp2        = PrintTemp+10 ;moved...was $D4

;added functions
DifSw        = $C4
Type         = $D4

;current free ram = $CD,$CE,$C0,$C1,$C2,$C3, and 6 lower bits of $D4

       ORG $1000

L1000:
       LDY    #$00                    ;2
       STA    WSYNC                   ;3
       LDA.wy $96,Y                   ;4
       STA    HMBL                    ;3
       AND    #$0F                    ;2
       TAY                            ;2
       LDA    $BD,X                   ;4
L100E:
       DEY                            ;2
       BPL    L100E                   ;2
       LDX    #$03                    ;2
       LDY    #$07                    ;2
       STA    RESBL                   ;3
       LDA    $D2                     ;3
       AND    $D1                     ;3
       STA    COLUP0                  ;3
       STA    COLUP1                  ;3
       STX    NUSIZ0                  ;3
       STX    NUSIZ1                  ;3
       STA    WSYNC                   ;3
L1027:
       DEY                            ;2
       BNE    L1027                   ;2
       LDA    #$F0                    ;2
       STX    RESP0                   ;3
       STX    RESP1                   ;3
       LDX    #$01                    ;2
       STA    HMP0                    ;3
       STY    HMP1                    ;3
       STX    VDELP0                  ;3
       STX    VDELP1                  ;3
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       LDY    $BC                     ;3
L1049:
       LDA    INTIM                   ;4
       BNE    L1049                   ;2
       STA    WSYNC                   ;3
       STA    VBLANK                  ;3
       STA    HMCLR                   ;3
       STA    CXCLR                   ;3
       STY    COLUBK                  ;3
       LDY    #$09                    ;2
L105A:
       STY    Temp                    ;3
       LDA    (PrintTemp),Y           ;5
       STA    GRP0                    ;3
       STA    WSYNC                   ;3
       LDA    (PrintTemp+2),Y         ;5
       STA    GRP1                    ;3
       LDA    (PrintTemp+4),Y         ;5
       STA    GRP0                    ;3
       LDA    (PrintTemp+6),Y         ;5
       STA    $BF                     ;3
       LDA    (PrintTemp+8),Y         ;5
       TAX                            ;2
       LDA    (PrintTemp+10),Y        ;5
       TAY                            ;2
       LDA    $BF                     ;3
       STA    GRP1                    ;3
       STX    GRP0                    ;3
       STY    GRP1                    ;3
       STY    GRP0                    ;3
       LDY    Temp                    ;3
       DEY                            ;2
       BPL    L105A                   ;2
       STY    $BF                     ;3 Y=FF
       INY                            ;2 Y=0
       STY    GRP0                    ;3
       STY    GRP1                    ;3
       STY    VDELP0                  ;3
       STY    VDELP1                  ;3
       LDA    #$08                    ;2
       STA    REFP1                   ;3
       LDX    #$A5                    ;2

;enemy sprite high bytes
       LDA    #>L1E00                 ;2 page of enemy GFX
       STA    Sprite0Ptr+1            ;3
       STA    Sprite1Ptr+1            ;3

;set up enemy color pointer
       LDA    Level                   ;3
       SEC                            ;2
L14C7:
       SBC    #$07                    ;2
       BCS    L14C7                   ;2
       ADC    #$07                    ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       CLC                            ;2
       ADC    #<L1FAE                 ;2
       STA    ColorPtr                ;3
       LDA    #>L1FAE                 ;2
       STA    ColorPtr+1              ;3

L1095:
       INC    $BF                     ;5
       STA    WSYNC                   ;3
       LDY.w  $BF                     ;4
       LDA.wy $8D,Y                   ;4
       STA    HMP0                    ;3
       AND    #$0F                    ;2
       TAY                            ;2
L10A4:
       DEY                            ;2
       BPL    L10A4                   ;2
       LDY    $BF                     ;3
       STA    RESP0                   ;3
       STA    WSYNC                   ;3
       LDA.wy $91,Y                   ;4
       STA    HMP1                    ;3
       AND    #$0F                    ;2
       TAY                            ;2
       NOP                            ;2
       NOP                            ;2
L10B7:
       DEY                            ;2
       BPL    L10B7                   ;2
       LDY    $BF                     ;3
       STA    RESP1                   ;3
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       CPY    #$03                    ;2
       BEQ    L1117                   ;2
       LDA.wy $9D,Y                   ;4
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       STA    Sprite0Ptr              ;3
       LDA.wy $A1,Y                   ;4
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       STA    Sprite1Ptr              ;3
       LDA.wy $C5,Y                   ;4
       STA    EnemyYtmp               ;3
       LDA    #$00                    ;2
       CPY    $97                     ;3
       BNE    L10E3                   ;2
       LDA    #$07                    ;2
L10E3:
       STA    NUSIZ0                  ;3
       STA    NUSIZ1                  ;3
       DEX                            ;2
       DEX                            ;2
       DEX                            ;2



L10EA:
       STA    WSYNC                   ;3
       TXA                            ;2
       SEC                            ;2
       SBC    EnemyYtmp               ;3
       TAY                            ;2
       AND    #$F8                    ;2
       BNE    L1103                   ;2
       LDA    (Sprite0Ptr),Y          ;5
       STA    GRP0                    ;3
       LDA    (Sprite1Ptr),Y          ;5
       STA    GRP1                    ;3
       LDA    (ColorPtr),Y            ;5
       STA    COLUP0                  ;3
       STA    COLUP1                  ;3
L1103:
       TXA                            ;2
       SEC                            ;2
       SBC    $95                     ;3
       LDY    #$01                    ;2
       AND    #$F8                    ;2
       BNE    L110E                   ;2
       INY                            ;2
L110E:
       STY    ENABL                   ;3
       DEX                            ;2
       CPX    EnemyYtmp               ;3
       BCC    L1095                   ;2
       BCS    L10EA                   ;2
L1117:
       LDA    $D3                     ;3
       AND    $D1                     ;3
       STA    COLUP0                  ;3
       LDA    CXPPMM                  ;3
       STA    Temp                    ;3
       LDA    $99                     ;3
       BNE    L1168                   ;2
       STA    REFP1                   ;3
       STA    NUSIZ0                  ;3
       STA    NUSIZ1                  ;3
       BIT    $EB                     ;3

;       BPL    L1132                   ;2
;       JMP    L11B2                   ;3
       BMI    L11B2                   ;2
;L1132:
       LDA    $B3                     ;3
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       STA    Sprite0Ptr              ;3
L1139:
       STA    WSYNC                   ;3
       CPX    #$0C                    ;2
       BCS    L1144                   ;2
       LDA    L1D88,X                 ;4
       STA    GRP0                    ;3
L1144:
       TXA                            ;2
       SEC                            ;2
       SBC    $C8                     ;3
       TAY                            ;2
       AND    #$F8                    ;2
       BNE    L1155                   ;2
       LDA    (Sprite0Ptr),Y          ;5
       STA    GRP1                    ;3
       LDA    (ColorPtr),Y            ;5
       STA    COLUP1                  ;3

L1155:
       TXA                            ;2
       SEC                            ;2
       SBC    $95                     ;3
       LDY    #$01                    ;2
       AND    #$F8                    ;2
       BNE    L1160                   ;2
       INY                            ;2
L1160:
       STY    ENABL                   ;3
       DEX                            ;2
       BPL    L1139                   ;2
;       JMP    L11F0                   ;3
       JMP    L11EF                   ;3
;       BMI    L11EF                   ;2 always branch

L1168:
       AND    #$38                    ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       TAY                            ;2
       LDA    L1DBC,Y                 ;4
       STA    Sprite0Ptr              ;3
       LDA    #>L1DC4                 ;2
       STA    Sprite0Ptr+1            ;3
       LDA    #$00                    ;2
       STA    NUSIZ0                  ;3
       STA    NUSIZ1                  ;3
L117D:
       STA    WSYNC                   ;3
       STA    GRP0                    ;3
       STA    GRP1                    ;3
       TXA                            ;2
       LDY    #$01                    ;2
       SEC                            ;2
       SBC    $95                     ;3
       AND    #$F8                    ;2
       BNE    L118E                   ;2
       INY                            ;2
L118E:
       STY    ENABL                   ;3
       TXA                            ;2
       LSR                            ;2
       LSR                            ;2
       BCS    L11A8                   ;2
       LSR                            ;2
       TAY                            ;2
       BCS    L11A8                   ;2
       CPY    #$05                    ;2
       BCS    L11A8                   ;2
       LDA    L1DEC,Y                 ;4
       STA    COLUP0                  ;3
       STA    COLUP1                  ;3
       LDA    (Sprite0Ptr),Y          ;5
;       BCC    L11AA                   ;2
       .byte $2C                      ;4
L11A8:
       LDA    #$00                    ;2
;L11AA:
       DEX                            ;2
       BPL    L117D                   ;2
       INX                            ;2
       STX    REFP1                   ;3
       BEQ    L11F0                   ;2 always branch

L11B2:
       LDA    #$4E                    ;2
       STA    COLUP1                  ;3
       LDA    CXP1FB                  ;3
       STA    $BF                     ;3
L11BA:
       STA    WSYNC                   ;3
       CPX    #$0C                    ;2
       BCS    L11C5                   ;2
       LDA    L1D88,X                 ;4
       STA    GRP0                    ;3
L11C5:
       TXA                            ;2
       SEC                            ;2
       SBC    $95                     ;3
       LDY    #$01                    ;2
       AND    #$F8                    ;2
       BNE    L11D0                   ;2
       INY                            ;2
L11D0:
       STY    ENABL                   ;3
       TXA                            ;2
       CMP    #$50                    ;2
       BCS    L11ED                   ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       TAY                            ;2
       TXA                            ;2
       EOR    #$FF                    ;2
       EOR    $BD                     ;3
       AND    $EC                     ;3
       BEQ    L11E8                   ;2
       LDA    #$00                    ;2
       BEQ    L11EB                   ;2 always branch

L11E8:
       LDA.wy $A5,Y                   ;4
L11EB:
       STA    GRP1                    ;3
L11ED:
       DEX                            ;2
       BPL    L11BA                   ;2

L11EF:
       INX                            ;2

L11F0:
;       LDX    #$00                    ;2
       STA    WSYNC                   ;3
       STX    GRP0                    ;3
       STX    GRP1                    ;3
       STX    HMP0                    ;3
       LDA    #$10                    ;2
       STA    HMP1                    ;3
       LDA    $F7                     ;3
       AND    $D1                     ;3
       STA    Temp2                   ;3
       STA    RESP0                   ;3
       STA    RESP1                   ;3
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       BIT    $F8                     ;3
       BMI    L1212                   ;2
       LDX    $ED                     ;3
L1212:
       LDY    $F2,X                   ;4
       LDA    L1DAE,Y                 ;4
       STA    NUSIZ0                  ;3
       LDA    L1DB5,Y                 ;4
       STA    NUSIZ1                  ;3

;       LDX    $D4                     ;3

       LDX    #$4C                    ;3 extra player color (pink)
       LDA    $F4                     ;3
       BEQ    L1220                   ;2 branch if tune not playing
       LDX    FrameCounter            ;3 flash the remaining players
L1220:

       STX    COLUP0                  ;3
       STX    COLUP1                  ;3
       LDX    #$06                    ;2
       LDA    Temp2                   ;3
L1228:
       STA    WSYNC                   ;3
       STA    COLUBK                  ;3
       DEX                            ;2
       BMI    L1247                   ;2
       LDA    L1D9C,X                 ;4
       CPY    #$00                    ;2
       BEQ    L123E                   ;2
       STA    GRP0                    ;3
       CPY    #$02                    ;2
       BCC    L123E                   ;2
       STA    GRP1                    ;3
L123E:
       DEC    Temp2                   ;5
       DEC    Temp2                   ;5
       LDA    Temp2                   ;3
       JMP    L1228                   ;3
L1247:
       JMP    L187A                   ;3












L1CED:
       LDA    $99                     ;3
       BEQ    L1CF5                   ;2
       LDA    #$00                    ;2
       STA    COLUPF                  ;3
L1CF5:
       LDA    #$03                    ;2
       STA    $95                     ;3
       LDA    $9C                     ;3
       AND    #$BF                    ;2
       STA    $9C                     ;3
       LDA    $90                     ;3
       LDY    #$01                    ;2
       JSR    L1CCF                   ;6
       STA    $96                     ;3
       RTS                            ;6


























;pause status
L1277:
       LDA    SWCHB                   ;4
       tax                            ;2  copy to X (to be used later)

       AND    #$08                    ;2 keep B&W
       TAY                            ;2
       eor    DifSw                   ;2  check previous switches
       beq    Switch_ending           ;2� branch if the same (branch to end)
       AND    #$08                    ;2 did the B&W switch change?
       beq    Save_Switches           ;2� branch if not (branch & save)
       lda    Type                    ;3  first, load in the console type
       bpl    AA2600                  ;2� Branch if 2600

       CPY    #$08                    ;2 Color selected?
       bne    Save_Switches           ;2� branch if not (branch & save)



AA2600:
       EOR    #$40                    ;2 flip pause status
       STA    Type                    ;3 ...and save
Save_Switches:
       stx    DifSw                   ;2
Switch_ending:
       LDA    #$02                    ;2
       STA    VBLANK                  ;3
       LDX    #$19                    ;2
       STA    WSYNC                   ;3
       STX    TIM8T                   ;4
       STA    VSYNC                   ;3




;pause2
       BIT    Type                    ;3
       BVS    L1280                   ;2
       LDX    #$00                    ;2
       STX    AUDV0                   ;3 clear voice 0
       JMP    L1388                   ;3
L1280:


;=========================
;do the sounds for voice 0
;=========================
       LDX    #$00                    ;2
       BIT    $F1                     ;3
       BMI    L128E                   ;2
       STX    $B5                     ;3
;       BPL    L1292                   ;2
L1292:
       LDA    $B5                     ;3
       AND    #$0F                    ;2 get sound (low nybble from $B5)
;       ASL                            ;2
;       TAY                            ;2
;       LDA    L12A2,Y                 ;4
;       PHA                            ;3
;       LDA    L12A1,Y                 ;4
;       PHA                            ;3
;       RTS                            ;6
;replacement eliminates those tables above
       BEQ    L12D2                   ;2
       CMP    #$01                    ;2
       BEQ    L12CC                   ;2

;...when A = 2:

;player shooting sound
L12B2:
       LDA    $CF                     ;3
       ASL                            ;2
       TAX                            ;2
       LDA    $CF                     ;3
       EOR    #$FF                    ;2
       AND    #$07                    ;2
       LDY    #$0F                    ;2
       DEC    $CF                     ;5
       BPL    L12D2                   ;2
       LDA    $B5                     ;3
       AND    #$F0                    ;2
       STA    $B5                     ;3
       LDX    #$00                    ;2
       BEQ    L12D2                   ;2


L128E:
       LDA    $99                     ;3
;       BNE    L12A7                   ;2
       BEQ    L1292                   ;2
;player explosion audio routine
;L12A7:
       LSR                            ;2
       LSR                            ;2
       TAX                            ;2
       LDA    $99                     ;3
       AND    #$1F                    ;2
       LDY    #$08                    ;2 white noise
       BNE    L12D2                   ;2



;enemy warp-in sound
L12CC:
       LDX    #$0C                    ;2 loud
       LDA    $BB                     ;3
       LDY    #$08                    ;2 white noise

;no sound
L12D2:
       STX    AUDV0                   ;3
       STY    AUDC0                   ;3
       STA    AUDF0                   ;3













;=============================
;now do the sounds for voice 1
;=============================
       LDX    #$00                    ;2
       LDA    $F4                     ;3
       BNE    L131D                   ;2
       LDA    $B5                     ;3
       AND    #$F0                    ;2
;       LSR                            ;2
;       LSR                            ;2
;       LSR                            ;2
;       TAY                            ;2
;       LDA    L12F0,Y                 ;4
;       PHA                            ;3
;       LDA    L12EF,Y                 ;4
;       PHA                            ;3
;       RTS                            ;6
;replacement eliminates those tables:
       CMP    #$30                    ;2
       BEQ    L12F7                   ;2
       CMP    #$20                    ;2
       BEQ    L134F                   ;2
       CMP    #$10                    ;2
       BEQ    L135C                   ;2
       JMP    L1388                   ;3 no sound when A = 0





;end of game sound
L12F7:
       DEC    $D0                     ;5
       LDA    $D0                     ;3
       BNE    L1305                   ;2
       STA    $B5                     ;3
       LDA    #$4C                    ;2
       STA    $F7                     ;3
       BNE    L1317                   ;2 always branch
L1305:
       TAY                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       TAX                            ;2
       INC    $F7                     ;5
       LDA    L1E00,Y                 ;4
       AND    #$07                    ;2
       STA    AUDF0                   ;3
       ADC    #$05                    ;2
       STX    AUDV0                   ;3
L1317:
       LDY    #$0C                    ;2
       STY    AUDC0                   ;3
       BNE    L1388                   ;2 always branch





L131D:
       DEC    $F4                     ;5
       LDA    $F4                     ;3
       BNE    L1330                   ;2
       LDX    $ED                     ;3
       BIT    $F8                     ;3
       BPL    L132B                   ;2
       LDX    #$00                    ;2
L132B:
       INC    $F2,X                   ;6
       INX                            ;2
       STX    $BA                     ;3
L1330:
       CMP    #$3D                    ;2
       BCS    L1388                   ;2

;extra life tune
;       EOR    #$FF                    ;2
;       STA    $D4                     ;3
;       EOR    #$FF                    ;2
       LSR                            ;2
       LSR                            ;2
       TAY                            ;2
       LDA    L1FEC,Y                 ;4 load note
       BEQ    L1388                   ;2 branch when no note needed
       TAY                            ;2
       LDA    $F4                     ;3
       AND    #$03                    ;2
       ASL                            ;2
       ASL                            ;2
       TAX                            ;2
       TYA                            ;2
       LDY    #$04                    ;2
       BNE    L1388                   ;2 always branch



;demon hit explosion
L134F:
       LDX    #$08                    ;2
       LDY    $D0                     ;3
       INC    $D0                     ;5
       LDA    L1E00,Y                 ;4
       AND    #$07                    ;2
       BPL    L137F                   ;2

;new explosion
;       LSR                            ;2
;       LSR                            ;2
;       TAX                            ;2
;       INC    $D0                     ;5
;       LDA    $D0                     ;3
;       EOR    #$0A                    ;2
;       LDY    #$08                    ;2 white noise
;       BPL    L1388                   ;2 always branch

L135C:
       LDA    $BD                     ;3
       EOR    #$FF                    ;2
       AND    #$0F                    ;2
       SEC                            ;2
       SBC    #$04                    ;2
       BCC    L1388                   ;2
       TAX                            ;2
       BIT    $B2                     ;3
       BMI    L1383                   ;2 branch when small demon is falling
;background thump sound
       LDA    $BD                     ;3 framecount
       AND    #$10                    ;2
       BEQ    L1376                   ;2
       LDX    #$00                    ;2 no sound every alternating 16 frames
       BEQ    L1388                   ;2
L1376:
       LDY    #$01                    ;2
       TXA                            ;2
       LSR                            ;2
       BCS    L1377                   ;2
       TAY                            ;2
       INY                            ;2
L1377:
       TYA                            ;2
       CLC                            ;2
       ADC    #$14                    ;2
       SEC                            ;2
       SBC    $9B                     ;3
L137F:
       LDY    #$0C                    ;2
       BNE    L1388                   ;2

;bird chirp
L1383:

       LDA    L1F96,X                 ;4
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2

;alternate...very similar to what the above 5 instructions would accomplish (but not exact)
;this would eliminate those plus table L1F96 if used
;       EOR    #$0F                    ;2

       LDY    #$04                    ;2

L1388:
       STX    AUDV1                   ;3
       STY    AUDC1                   ;3
       STA    AUDF1                   ;3
L138E:
       LDA    INTIM                   ;4
       BNE    L138E                   ;2
       STA    VSYNC                   ;3
       STA    WSYNC                   ;3
       LDA    #$2D                    ;2
       STA    TIM64T                  ;4



;pause3
       BIT    Type                    ;3
       BVS    L1390                   ;2


       JMP    L1822                   ;3
L1390:






       INC    $BD                     ;5
       BNE    L13BC                   ;2
       INC    $B9                     ;5
       BIT    $CC                     ;3
       BMI    L13B2                   ;2
       LDA    $B9                     ;3
       BNE    L13AE                   ;2
       LDA    #$F3                    ;2
       STA    $D1                     ;3
L13AE:
       LDA    $F5                     ;3
       BNE    L13B6                   ;2
L13B2:
       BIT    $F8                     ;3
       BPL    L13BC                   ;2
L13B6:
       LDA    $ED                     ;3
       EOR    #$01                    ;2
       STA    $ED                     ;3
L13BC:
       LDA    $D5                     ;3
       ASL                            ;2
       EOR    $D5                     ;3
       ASL                            ;2
       ASL                            ;2
       ROL    $D5                     ;5
       LDA    DifSw                   ;3
       ROR    $9C                     ;5
       BCS    L13D0                   ;2
       LSR                            ;2
       BCS    L141C                   ;2
       ROL                            ;2
L13D0:
       LSR                            ;2
       ROL    $9C                     ;5
       LSR                            ;2
       BIT    $E9                     ;3
       BCC    L13DC                   ;2
       ROL    $E9                     ;5
       BNE    L1405                   ;2
L13DC:
       BPL    L13FD                   ;2
L13DE:
       LDA    $BD                     ;3
       AND    #$1F                    ;2
       STA    $E9                     ;3
       JSR    L1AA7                   ;6
       JSR    L1AD2                   ;6
       SED                            ;2
       LDA    $EA                     ;3
       CLC                            ;2
       ADC    #$01                    ;2
       CLD                            ;2
       STA    $EA                     ;3
       CMP    #$11                    ;2
       BNE    L1405                   ;2
       LDA    #$01                    ;2
       STA    $EA                     ;3
       BNE    L1405                   ;2
L13FD:
       LDA    $E9                     ;3
       EOR    $BD                     ;3
       AND    #$1F                    ;2
       BEQ    L13DE                   ;2
L1405:
       BIT    $CC                     ;3
       BMI    L1419                   ;2
       LDA    $B5                     ;3
       CMP    #$30                    ;2
       BEQ    L1419                   ;2
       LDA    INPT4                   ;3
       BPL    L1417                   ;2
       BIT    $F9                     ;3
       BPL    L141C                   ;2
L1417:
       STA    $F9                     ;3
L1419:
       JMP    L14DC                   ;3
L141C:
       LDX    #$FF                    ;2
       STX    $F1                     ;3
       STX    $CC                     ;3
       STX    Level                   ;3


;level test
;       LDY    #$52                    ;2
;       STY    Level                   ;3


       INX                            ;2
       LDY    $EA                     ;3
       DEY                            ;2
       TYA                            ;2
       LDY    #$00                    ;2
       STY    $F8                     ;3
       CMP    #$08                    ;2
       BCS    L1442                   ;2
       LSR                            ;2
       BCC    L1435                   ;2
       INY                            ;2
L1435:
       LSR                            ;2
       BCC    L1439                   ;2
       DEX                            ;2
L1439:
       LSR                            ;2
       BCC    L144A                   ;2
       LDA    #$0B                    ;2
       STA    Level                   ;3
       BNE    L144A                   ;2
L1442:
       DEX                            ;2
       STX    $F8                     ;3
       CMP    #$08                    ;2
       BNE    L144A                   ;2
       INX                            ;2
L144A:
       STX    $F6                     ;3
       STY    $F5                     ;3
       STY    $ED                     ;3
       LDA    #$03                    ;2
       STA    $F2                     ;3
       STA    $F3                     ;3
       LDX    #$81                    ;2
       BNE    L145C                   ;2 always branch






;@$124A
START:
       SEI                            ;2
       CLD                            ;2



       LDX    #$FF                    ;2
       TXS                            ;2
       INX                            ;2
       TXA                            ;2

;detect the console type
       tay                            ;2  Console type = 2600
       ldx    $D0                     ;3  Check $D0
       cpx    #$2C                    ;2  Does it contain value $2C?
       bne    Save_Console            ;2  If not, branch (keep 2600 mode)
       ldx    $D1                     ;3  Check $D1
       cpx    #$A9                    ;2  Does it contain value $A9?
       bne    Save_Console            ;2  If not, branch (keep 2600 mode)
       ldy    #$80                    ;2  set 7800 mode
Save_Console:
;now, clear out all ram
       tax                            ;2
L1251:
       STA    VSYNC,X                 ;4
       INX                            ;2
       BNE    L1251                   ;2

       STY    Type                    ;3 save the console type



       INX                            ;2
       STX    $EA                     ;3
       JSR    L1AA7                   ;6
       LDA    #$AB                    ;2
       STA    Score                   ;3
       LDA    #$CD                    ;2
       STA    Score+2                 ;3
       LDA    #$EA                    ;2
       STA    Score+4                 ;3
       STA    $D5                     ;3
;       LDX    #$0A                    ;2
;       LDA    #>Digits                ;2
;L126E:
;       STA    PrintTemp+1,X           ;4
;       DEX                            ;2
;       DEX                            ;2
;       BPL    L126E                   ;2
;       JMP    L145A                   ;3



L145A:
       LDX    #$87                    ;2
L145C:
       LDA    #$00                    ;2
L145E:
       STA    VSYNC,X                 ;4
       INX                            ;2
       CPX    #$BD                    ;2
       BNE    L145E                   ;2
       BIT    $F8                     ;3
       BMI    L147C                   ;2
       LDA    $F5                     ;3
       BEQ    L147C                   ;2
       LDA    $ED                     ;3
       EOR    #$01                    ;2
       TAX                            ;2
       LDA    $F2,X                   ;4
       BMI    L147C                   ;2
       STX    $ED                     ;3
       CPX    #$00                    ;2
       BNE    L147E                   ;2
L147C:
       INC    Level                   ;5 increase level
L147E:
       LDA    Level                   ;3
       CMP    #$54                    ;2 level 85?

;note: original code loops infinitely when level 84 is beaten (game crash)
;L1482:
;       BEQ    L1482                   ;2 branch if so


;corrected routine
       BNE    L1482                   ;2
       LDA    #$00                    ;2 go back to first level
       STA    Level                   ;3
L1482:



       STA    $80                     ;3
       CMP    #$0C                    ;2
       BCC    L1496                   ;2
L148A:
       SBC    #$0C                    ;2
       CMP    #$0C                    ;2
       BCS    L148A                   ;2
       STA    $80                     ;3
       AND    #$03                    ;2
       ADC    #$08                    ;2
L1496:
       STA    $F0                     ;3
       LSR                            ;2
       TAX                            ;2
       LDA    #$2C                    ;2
       SEC                            ;2
       SBC    $F0                     ;3
       SBC    $F0                     ;3
       STA    $98                     ;3
       LDA    L1DF1,X                 ;4
       STA    $EB                     ;3
       LDY    #$01                    ;2
       AND    #$20                    ;2
       BEQ    L14B0                   ;2
       LDY    #$81                    ;2
L14B0:
       TYA                            ;2
       ORA    $9C                     ;3
       STA    $9C                     ;3
       LDA    #$04                    ;2
       BIT    $EB                     ;3
       BVC    L14BD                   ;2
       LDA    #$00                    ;2
L14BD:
       STA    $EC                     ;3
       LDA    L1DF7,X                 ;4
       STA    $EE                     ;3

;set up enemy color pointer
;       LDA    Level                   ;3
;       SEC                            ;2
;L14C7:
;       SBC    #$07                    ;2
;       BCS    L14C7                   ;2
;       ADC    #$07                    ;2
;       ASL                            ;2
;       ASL                            ;2
;       ASL                            ;2
;       CLC                            ;2
;       ADC    #<L1FAE                 ;2
;       STA    ColorPtr                ;3
;       LDA    #>L1FAE                 ;2
;       STA    ColorPtr+1              ;3

       JSR    L1AA7                   ;6
L14DC:
       BIT    $F1                     ;3
       BPL    L14E7                   ;2
       BIT    $CC                     ;3
       BMI    L14E7                   ;2
       JMP    L1822                   ;3
L14E7:
       LDA    $BD                     ;3
       AND    #$07                    ;2
       TAY                            ;2
       LDX    L1D94,Y                 ;4
       BMI    L1535                   ;2
       CPX    #$03                    ;2
       BNE    L14FF                   ;2
       LDA    $B3                     ;3
       JSR    L1B28                   ;6
       STA    $B3                     ;3
       JMP    L1533                   ;3
L14FF:
       LDA    $B6,X                   ;4
       BPL    L152C                   ;2
       LDA    $9D,X                   ;4
       CMP    $A1,X                   ;4
       BNE    L1515                   ;2
       CMP    #$05                    ;2
       BCC    L1515                   ;2
       JSR    L1B03                   ;6
       STA    $9D,X                   ;4
       JMP    L1533                   ;3
L1515:
       LDA    #$BF                    ;2
       STA    $BF                     ;3
       LDA    $9D,X                   ;4
       JSR    L1B03                   ;6
       STA    $9D,X                   ;4
       LDA    #$DF                    ;2
       STA    $BF                     ;3
       LDA    $A1,X                   ;4
       JSR    L1B03                   ;6
       JMP    L1533                   ;3
L152C:
       LDA    $9D,X                   ;4
       JSR    L1B28                   ;6
       STA    $9D,X                   ;4
L1533:
       STA    $A1,X                   ;4
L1535:
       LDA    $99                     ;3
       BNE    L15AB                   ;2
       BIT    $B2                     ;3
       BMI    L154F                   ;2
       LDA    $B8                     ;3
       AND    #$60                    ;2
       BEQ    L154F                   ;2
       CMP    #$60                    ;2
       BEQ    L154F                   ;2
       JSR    L1D31                   ;6
       BCS    L154F                   ;2
       JSR    L1BB8                   ;6
L154F:
       BIT    $F1                     ;3
       BMI    L155D                   ;2
       LDX    #$06                    ;2
       BIT    $BD                     ;3
       BVC    L156B                   ;2
       LDX    #$0A                    ;2
       BNE    L156B                   ;2
L155D:
       LDA    SWCHA                   ;4
       LDX    $ED                     ;3
       BNE    L1568                   ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
L1568:
       AND    #$0F                    ;2
       TAX                            ;2
L156B:
       LDY    #$01                    ;2
       BIT    $F6                     ;3
       BPL    L1572                   ;2
       INY                            ;2
L1572:
       LDA    $90                     ;3
       CPX    #$08                    ;2
       BCC    L158B                   ;2
       BEQ    L15AB                   ;2
       CPX    #$0C                    ;2
       BCS    L15AB                   ;2
       CMP    #$31                    ;2
       BEQ    L15AB                   ;2
       CMP    #$21                    ;2
       BEQ    L15AB                   ;2
       JSR    L1CDE                   ;6
       BEQ    L159A                   ;2
L158B:
       CPX    #$05                    ;2
       BCC    L15AB                   ;2
       CMP    #$C8                    ;2
       BEQ    L15AB                   ;2
       CMP    #$D8                    ;2
       BEQ    L15AB                   ;2
       JSR    L1CCF                   ;6
L159A:
       STA    $90                     ;3
       BIT    $F6                     ;3
       BMI    L15A4                   ;2
       BIT    $9C                     ;3
       BVS    L15AB                   ;2
L15A4:
       LDY    #$01                    ;2
       JSR    L1CCF                   ;6
       STA    $96                     ;3
L15AB:
       BIT    $9C                     ;3
       BVS    L15D5                   ;2
       LDA    $99                     ;3
       BNE    L15E3                   ;2
       BIT    $F1                     ;3
       BPL    L15BD                   ;2
       LDX    $ED                     ;3
       LDA    INPT4,X                 ;4
       BMI    L15E3                   ;2
L15BD:
       LDA    $9C                     ;3
       ORA    #$40                    ;2
       STA    $9C                     ;3
       LDA    $97                     ;3
       BPL    L15E3                   ;2
       LDA    $B5                     ;3
       AND    #$F0                    ;2
       ORA    #$02                    ;2
       STA    $B5                     ;3
       LDA    #$07                    ;2
       STA    $CF                     ;3
       BNE    L15E3                   ;2
L15D5:
       LDA    $95                     ;3
       CLC                            ;2
       ADC    $EE                     ;3
       STA    $95                     ;3
       CMP    #$A0                    ;2
       BCC    L15E3                   ;2
       JSR    L1CED                   ;6
L15E3:
       LDY    $BB                     ;3
       BNE    L1635                   ;2
       LDX    #$02                    ;2
L15E9:
       LDA    $AF,X                   ;4
       AND    #$C0                    ;2
       BEQ    L161C                   ;2
       INY                            ;2
L15F0:
       DEX                            ;2
       BPL    L15E9                   ;2
       CPY    #$00                    ;2
       BNE    L1633                   ;2
       BIT    $B2                     ;3
       BMI    L1633                   ;2
       LDA    $99                     ;3
       ORA    $F4                     ;3
       BNE    L1635                   ;2
       LDX    $ED                     ;3
       BIT    $F8                     ;3
       BPL    L1609                   ;2
       LDX    #$00                    ;2
L1609:
       LDA    $BA                     ;3
       BNE    L1619                   ;2
       LDA    $F2,X                   ;4
       CMP    #$06                    ;2
       BCS    L1619                   ;2
       LDA    #$48                    ;2
       STA    $F4                     ;3
       BNE    L1633                   ;2
L1619:
       JMP    L145A                   ;3
L161C:
       BIT    $F1                     ;3
       BPL    L1626                   ;2
       LDA    $9B                     ;3
       CMP    #$08                    ;2
       BEQ    L15F0                   ;2
L1626:
       LDA    $D5                     ;3
       AND    #$1F                    ;2
       ORA    #$01                    ;2
       STA    $BB                     ;3
       JSR    L1D09                   ;6
       STA    $C5,X                   ;4
L1633:
       STX    $97                     ;3
L1635:
       LDA    $BD                     ;3
       AND    #$03                    ;2
       BEQ    L166B                   ;2
       TAX                            ;2
       DEX                            ;2
       JSR    L1D09                   ;6
       CMP    $C5,X                   ;4
       BCS    L1648                   ;2
       DEC    $C5,X                   ;6
       BNE    L164A                   ;2
L1648:
       INC    $C5,X                   ;6
L164A:
       LDA    $D5                     ;3
       CPX    #$02                    ;2
       BNE    L1661                   ;2
       LDA    $8D,X                   ;4
       JSR    L1D3D                   ;6
       BIT    $9C                     ;3
       BVC    L166B                   ;2
       LDA    $95                     ;3
       CMP    $C7                     ;3
       BCC    L1665                   ;2
       BCS    L166B                   ;2
L1661:
       AND    #$07                    ;2
       BNE    L166B                   ;2
L1665:
       LDA    $AF,X                   ;4
       EOR    #$10                    ;2
       STA    $AF,X                   ;4
L166B:
       JSR    L1C33                   ;6
       BIT    $9C                     ;3
       BPL    L16BA                   ;2
       LDX    #$02                    ;2
L1674:
       LDA    $B6,X                   ;4
       AND    #$20                    ;2
       BEQ    L16B7                   ;2
       LDA    $B6,X                   ;4
       AND    #$08                    ;2
       BEQ    L16B7                   ;2
       LDY    #$01                    ;2
       LDA    $B6,X                   ;4
       AND    #$10                    ;2
       BEQ    L16A6                   ;2
       LDA    $91,X                   ;4
       CMP    #$C9                    ;2
       BEQ    L1696                   ;2
       JSR    L1CCF                   ;6
       STA    $91,X                   ;4
;       JMP    L16B1                   ;3
       BEQ    L16B1                   ;2 always branch (subroutine L1CCF leaves zero flag set)


L1696:
       LDA    $B6,X                   ;4
       EOR    #$10                    ;2
       STA    $B6,X                   ;4
       LDA    $AF,X                   ;4
       AND    #$F0                    ;2
       ORA    #$01                    ;2
       STA    $AF,X                   ;4
       BNE    L16B1                   ;2
L16A6:
       LDA    $91,X                   ;4
       CMP    #$71                    ;2
       BEQ    L1696                   ;2
       JSR    L1CDE                   ;6
       STA    $91,X                   ;4
L16B1:
       LDA    $B6,X                   ;4
       AND    #$F7                    ;2
       STA    $B6,X                   ;4
L16B7:
       DEX                            ;2
       BPL    L1674                   ;2
L16BA:
       LDA    $98                     ;3
       BIT    $B2                     ;3
       BPL    L16C5                   ;2
       LDA    $C8                     ;3
       CLC                            ;2
       ADC    #$0C                    ;2
L16C5:
       STA    Temp                    ;3
       LDA    $C5                     ;3
       CMP    #$97                    ;2
       BCC    L16CF                   ;2
       LDA    #$97                    ;2
L16CF:
       CMP    #$48                    ;2
       BCS    L16D5                   ;2
       LDA    #$48                    ;2
L16D5:
       STA    $C5                     ;3
       SEC                            ;2
       SBC    #$0C                    ;2
       CMP    $C6                     ;3
       BCS    L16E0                   ;2
       STA    $C6                     ;3
L16E0:
       LDA    $C6                     ;3
       SEC                            ;2
       SBC    #$0C                    ;2
       CMP    $C7                     ;3
       BCS    L16EB                   ;2
       STA    $C7                     ;3
L16EB:
       LDA    $C7                     ;3
       CMP    Temp                    ;3
       BCS    L16F5                   ;2
       LDA    Temp                    ;3
       STA    $C7                     ;3
L16F5:
       LDA    $EB                     ;3
       AND    #$10                    ;2
       BEQ    L1712                   ;2
       LDA    $99                     ;3
       BNE    L1712                   ;2
       LDA    $97                     ;3
       CMP    #$02                    ;2
       BEQ    L1712                   ;2
       BIT    $B2                     ;3
       BMI    L1712                   ;2
       LDA    $8F                     ;3
       LDY    #$04                    ;2
       JSR    L1CCF                   ;6
       STA    $94                     ;3
L1712:
       LDX    $97                     ;3
       BMI    L1744                   ;2
       LDA    $BB                     ;3
       BEQ    L1783                   ;2
       DEC    $BB                     ;5
       BNE    L1783                   ;2
       LDA    $AF,X                   ;4
       AND    #$C0                    ;2
       BEQ    L1747                   ;2
       LDA    #$90                    ;2
       STA    $AF,X                   ;4
;       LDA    #$4C                    ;2
;       STA    $D4                     ;3
       LDA    #$10                    ;2
       STA    $B5                     ;3
       LDA    $80                     ;3
       LSR                            ;2
       TAY                            ;2
       LDA    L1B9F,Y                 ;4
       STA    $9D,X                   ;4
       STA    $A1,X                   ;4
       LDA    $8D,X                   ;4
       LDY    #$08                    ;2
       JSR    L1CCF                   ;6
       STA    $91,X                   ;4
L1744:
       JMP    L17CF                   ;3
L1747:
       INC    $9B                     ;5
       LDA    $AF,X                   ;4
       ORA    #$40                    ;2
       STA    $AF,X                   ;4
       LDA    $D5                     ;3
       AND    #$7C                    ;2
       CLC                            ;2
       ADC    #$10                    ;2
       STA    Temp                    ;3
       LSR                            ;2
       STA    $D6                     ;3
       LDA    #$A0                    ;2
       SEC                            ;2
       SBC    Temp                    ;3
       LSR                            ;2
       STA    $D7                     ;3
       LDY    #$00                    ;2
       STY    $D8                     ;3
       STY    $D9                     ;3
       STY    $DA                     ;3
       STY    $DB                     ;3
       STY    $B6,X                   ;4
       LDA    #$70                    ;2
       STA    $8D,X                   ;4
       LDA    #$A9                    ;2
       STA    $91,X                   ;4
       LDA    #$20                    ;2
       STA    $BB                     ;3
       LDA    $B5                     ;3
       AND    #$F0                    ;2
       ORA    #$01                    ;2
       STA    $B5                     ;3
L1783:
       LDA    $AF,X                   ;4
       AND    #$C0                    ;2
       CMP    #$40                    ;2
       BNE    L17CF                   ;2
       LDY    $D8                     ;3
       LDA    $87,X                   ;4
       CLC                            ;2
       ADC    $D9                     ;3
       STA    $87,X                   ;4
       BCC    L1797                   ;2
       INY                            ;2
L1797:
       CPY    #$00                    ;2
       BEQ    L17A2                   ;2
       LDA    $8D,X                   ;4
       JSR    L1CCF                   ;6
       STA    $8D,X                   ;4
L17A2:
       LDY    $DA                     ;3
       LDA    $8A,X                   ;4
       CLC                            ;2
       ADC    $DB                     ;3
       STA    $8A,X                   ;4
       BCC    L17AE                   ;2
       INY                            ;2
L17AE:
       CPY    #$00                    ;2
       BEQ    L17B9                   ;2
       LDA    $91,X                   ;4
       JSR    L1CDE                   ;6
       STA    $91,X                   ;4
L17B9:
       LDA    $D9                     ;3
       CLC                            ;2
       ADC    $D6                     ;3
       STA    $D9                     ;3
       BCC    L17C4                   ;2
       INC    $D8                     ;5
L17C4:
       LDA    $DB                     ;3
       CLC                            ;2
       ADC    $D7                     ;3
       STA    $DB                     ;3
       BCC    L17CF                   ;2
       INC    $DA                     ;5
L17CF:
       BIT    $EB                     ;3
       BPL    L1822                   ;2
       LDY    $F0                     ;3
       INC    $9A                     ;5


;       LDA    $9A                     ;3
;       CMP    L1DA2,Y                 ;4

       LDA    L1DA2,Y                 ;4
       AND    #$0F                    ;2
       CMP    $9A                     ;3



       BNE    L1822                   ;2
       JSR    L1AE6                   ;6
       LDX    #$00                    ;2
       STX    $9A                     ;3
L17E5:
       LDA    $A6,X                   ;4
       STA    $A5,X                   ;4
       INX                            ;2
       CPX    #$09                    ;2
       BNE    L17E5                   ;2
       LDA    $C7                     ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       TAX                            ;2
       CPX    #$0A                    ;2
       BCC    L17FA                   ;2
       LDX    #$09                    ;2
L17FA:
       LDA    $B4                     ;3
       BNE    L1802                   ;2
       LDX    #$09                    ;2
       BNE    L1820                   ;2
L1802:
       DEC    $B4                     ;5
       BIT    $EB                     ;3
       BVC    L1812                   ;2
       LDA    #$81                    ;2
       BIT    $B8                     ;3
       BPL    L1820                   ;2
       LDA    #$80                    ;2
       BNE    L1820                   ;2
L1812:
       LDA    #$0F                    ;2
       BIT    $B8                     ;3
       BPL    L181A                   ;2
       LDA    #$03                    ;2
L181A:
       AND    $D5                     ;3
       TAY                            ;2
       LDA    L1EE0,Y                 ;4
L1820:
       STA    $A5,X                   ;4
L1822:
       LDX    #$00                    ;2
       TXA                            ;2
       BIT    $F1                     ;3 print logo?
       BPL    L183D                   ;2 branch if so
       BIT    $CC                     ;3 print score?
       BVS    L183D                   ;2 branch if so

;print game select
       JSR    L1C11                   ;6 clear first 2 digits
       LDA    $EA                     ;3 game selection
       JSR    L1C11                   ;6 ...use as next 2 digits
       LDA    #$AA                    ;2
       JSR    L1C11                   ;6
       JMP    L1851                   ;3

;set up score pointers
;L183D:
;       LDY    $ED                     ;3
;       LDA.wy Score,Y                 ;4
;       JSR    L1C11                   ;6
;       LDA.wy Score+2,Y               ;4
;       JSR    L1C11                   ;6
;       LDA.wy Score+4,Y               ;4
;       JSR    L1C11                   ;6


L183D:
       LDY    $ED                     ;3
L183F:
       LDA.wy Score,Y                 ;4
       JSR    L1C11                   ;6
       INY                            ;2
       INY                            ;2
       CPY    #$06                    ;2
       BCC    L183F                   ;2 branch until done







L1851:
       LDX    #$00                    ;2
L1853:
       LDA    PrintTemp,X             ;4
       BNE    L1861                   ;2
       LDA    #$64                    ;2
       STA    PrintTemp,X             ;4
       INX                            ;2
       INX                            ;2
       CPX    #$0A                    ;2
       BNE    L1853                   ;2
L1861:
       LDX    $B5                     ;3
       CPX    #$30                    ;2
       BNE    L186B                   ;2
       LDA    $BC                     ;3
       BCS    L1870                   ;2
L186B:
       LDY    $ED                     ;3
       LDA    L1ACE,Y                 ;4
L1870:
       STA    $D3                     ;3
       LDA    L1AD0,Y                 ;4
       STA    $D2                     ;3
       JMP    L1000                   ;3





L187A:
       LDA    #$26                    ;2
       STA    TIM64T                  ;4

;pause1
       BIT    Type                    ;3
       BVS    L1880                   ;2
       JMP    L1A7D                   ;3


L1880:
       BIT    $EB                     ;3
       BMI    L1887                   ;2
       LDA    CXP1FB                  ;3
       STA    $BF                     ;3
L1887:
       LDA    CXPPMM                  ;3
       BPL    L18B5                   ;2
       BIT    Temp                    ;3
       BMI    L18B5                   ;2
       LDA    #$40                    ;2
       STA    $99                     ;3
       STA    $BA                     ;3
       LDA    $90                     ;3
       LDY    #$04                    ;2
       JSR    L1CDE                   ;6
       STA    $90                     ;3
       LDY    #$08                    ;2
       JSR    L1CCF                   ;6
       STA    $94                     ;3
       STY    $B4                     ;3
       STY    $B2                     ;3
       LDA    $EB                     ;3
       ORA    #$80                    ;2
       STA    $EB                     ;3
       BIT    $9C                     ;3
       BVS    L18B5                   ;2
       STY    COLUPF                  ;3
L18B5:
       LDA    $99                     ;3
       BEQ    L191F                   ;2
       DEC    $99                     ;5
       BNE    L1915                   ;2
       LDA    #$6E                    ;2
       STA    COLUPF                  ;3
       LDA    #$05                    ;2
       STA    $90                     ;3
       JSR    L1CED                   ;6
       BIT    $F1                     ;3
       BPL    L1915                   ;2
       LDX    $ED                     ;3
       BIT    $F8                     ;3
       BPL    L18DF                   ;2
       TXA                            ;2
       EOR    #$01                    ;2
       TAY                            ;2
       LDX    #$05                    ;2
       LDA    #$00                    ;2
       JSR    L1A85                   ;6
       LDX    #$00                    ;2
L18DF:
       DEC    $F2,X                   ;6
       BPL    L1915                   ;2
       LDA    $F5                     ;3
       BEQ    L18FF                   ;2
       TXA                            ;2
       EOR    #$01                    ;2
       TAX                            ;2
       LDA    $F2,X                   ;4




;       BMI    L18FF                   ;2
;       LDA    #$08                    ;2
;       STA    $9B                     ;3
;       STY    $AF                     ;3
;       STY    $B0                     ;3
;       STY    $B1                     ;3
;       STY    $BB                     ;3
;       STY    $B2                     ;3
;       BPL    L1915                   ;2
;L18FF:
;       STX    COLUPF                  ;3
;       STX    $D3                     ;3
;       JSR    L1AD2                   ;6
;       LDA    #$40                    ;2
;       STA    $CC                     ;3
;       LDA    #$30                    ;2
;       STA    $B5                     ;3
;       LDA    #$78                    ;2
;       STA    $D0                     ;3
;       JMP    L1A7D                   ;3



       BPL    L1900                   ;2
L18FF:
       STX    COLUPF                  ;3
       STX    $D3                     ;3
       JSR    L1AD2                   ;6
       LDA    #$40                    ;2
       STA    $CC                     ;3
       LDA    #$30                    ;2
       STA    $B5                     ;3
       LDA    #$78                    ;2
       STA    $D0                     ;3
       JMP    L1A7D                   ;3
L1900:
       LDA    #$08                    ;2
       STA    $9B                     ;3
       STY    $AF                     ;3
       STY    $B0                     ;3
       STY    $B1                     ;3
       STY    $BB                     ;3
       STY    $B2                     ;3
;       BPL    L1915                   ;2
L1915:
       LDA    $99                     ;3
       CMP    #$30                    ;2
       BCC    L191F                   ;2
       AND    #$0F                    ;2
       STA    $BC                     ;3
L191F:
       BIT    $9C                     ;3
       BVS    L1926                   ;2
L1923:
       JMP    L19D6                   ;3
L1926:
       LDA    CXP0FB                  ;3
       ORA    $BF                     ;3
       AND    #$40                    ;2

;       BEQ    L1942                   ;2 ???
       BEQ    L1923                   ;2

       LDX    #$00                    ;2
       LDA    $95                     ;3
       CMP    #$0D                    ;2
       BCC    L1923                   ;2
       CLC                            ;2
       ADC    #$08                    ;2
L1939:
       CMP    $C5,X                   ;4
       BCS    L1944                   ;2
       INX                            ;2
       CPX    #$04                    ;2
       BNE    L1939                   ;2
L1942:
       BEQ    L1923                   ;2
L1944:
       CPX    $97                     ;3
       BEQ    L1923                   ;2
       LDA    #$03                    ;2
       CPX    #$03                    ;2
       BNE    L195E                   ;2
       BIT    $EB                     ;3
       BMI    L1923                   ;2
       CMP    $B3                     ;3
       BCS    L1923                   ;2
       STA    $B3                     ;3
       LDY    #$04                    ;2
       STY    Temp                    ;3
       BCC    L1998                   ;2
L195E:
       LDY    $B6,X                   ;4
       BPL    L197E                   ;2
       LDY    #$02                    ;2
       STY    Temp                    ;3
       BIT    CXP0FB                  ;3
       BVS    L1976                   ;2
       BIT    $BF                     ;3
       BVC    L19D6                   ;2
       CMP    $A1,X                   ;4
       BCS    L19D6                   ;2
       STA    $A1,X                   ;4
       BVS    L19A0                   ;2
L1976:
       CMP    $9D,X                   ;4
       BCS    L19D6                   ;2
       STA    $9D,X                   ;4
       BVS    L19A0                   ;2
L197E:
       LDY    #$01                    ;2
       STY    Temp                    ;3
       BIT    $9C                     ;3
       BMI    L198C                   ;2
       CMP    $9D,X                   ;4
       BCS    L19D6                   ;2
       BCC    L1994                   ;2
L198C:
       LDA    #$18                    ;2
       LDY    $9D,X                   ;4
       CPY    #$16                    ;2
       BCS    L19D6                   ;2
L1994:
       STA    $9D,X                   ;4
       STA    $A1,X                   ;4
L1998:
       LDA    $AF,X                   ;4
       AND    #$3F                    ;2
       ORA    #$C0                    ;2
       STA    $AF,X                   ;4
L19A0:
       JSR    L1CED                   ;6
       BIT    $F1                     ;3
       BPL    L19D6                   ;2
       LDX    #$00                    ;2
       LDA    $F0                     ;3
       LSR                            ;2
       TAY                            ;2
       TXA                            ;2
       SED                            ;2
L19AF:
       CLC                            ;2
       ADC    L1FE6,Y                 ;4
       BCC    L19B6                   ;2
       INX                            ;2
L19B6:
       DEC    Temp                    ;5
       BNE    L19AF                   ;2
       CLD                            ;2
       LDY    $ED                     ;3
       JSR    L1A85                   ;6
       LDA    #$00                    ;2
       STA    $B4                     ;3
       LDY    $80                     ;3
       LDA    L1B9F,Y                 ;4
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       STA    $D0                     ;3
       LDA    $B5                     ;3
       AND    #$0F                    ;2
       ORA    #$20                    ;2
       STA    $B5                     ;3
L19D6:
       LDA    $BD                     ;3
       AND    #$03                    ;2
       TAX                            ;2
       LDA    $AF,X                   ;4
       AND    #$F0                    ;2
       STA    Temp                    ;3
       INC    $AF,X                   ;6
       LDA    $AF,X                   ;4
       AND    #$0F                    ;2
       ORA    Temp                    ;3
       STA    $AF,X                   ;4
       LDX    #$02                    ;2
L19ED:
       LDA    $AF,X                   ;4
       AND    #$C0                    ;2
       CMP    #$80                    ;2

;       BEQ    L19F8                   ;2
;       JMP    L1A77                   ;3
;L19F8:
       BNE    L1A77                   ;2 xx


       LDA    $B4                     ;3
       BEQ    L1A00                   ;2
       CPX    #$02                    ;2
       BEQ    L1A1B                   ;2
L1A00:
       LDA    $AF,X                   ;4
       AND    #$07                    ;2
       TAY                            ;2

;       LDA    $C9,X                   ;4
;       CLC                            ;2
;       ADC    L1EF0,Y                 ;4

       LDA    L1EF0,Y                 ;4
       AND    #$F0                    ;2
       CLC                            ;2
       ADC    $C9,X                   ;4

       STA    $C9,X                   ;4
       BCC    L1A1B                   ;2
       LDA    $AF,X                   ;4
       AND    #$08                    ;2
       BEQ    L1A19                   ;2
       INC    $C5,X                   ;6
;       BNE    L1A1B                   ;2
       .byte $2C                      ;4
L1A19:
       DEC    $C5,X                   ;6
L1A1B:
       LDA    $B6,X                   ;4
       STA    Temp                    ;3
       LDA    $87,X                   ;4
       CLC                            ;2
       ADC    L1EF8,Y                 ;4
       STA    $87,X                   ;4
       BCC    L1A77                   ;2
       BIT    Temp                    ;3
       BPL    L1A35                   ;2
       LDA    $B6,X                   ;4
       ORA    #$08                    ;2
       STA    $B6,X                   ;4
       BVC    L1A77                   ;2
L1A35:
       CPX    #$02                    ;2
       BNE    L1A3D                   ;2
       LDA    $B4                     ;3
       BNE    L1A77                   ;2
L1A3D:
       LDY    #$01                    ;2
       LDA    $AF,X                   ;4
       AND    #$10                    ;2
       BEQ    L1A61                   ;2
       LDA    $8D,X                   ;4
       CMP    #$49                    ;2
       BEQ    L1A53                   ;2
       JSR    L1CCF                   ;6
       STA    $8D,X                   ;4
;       JMP    L1A6C                   ;3
       BEQ    L1A6C                   ;2 always branch (subroutine L1CCF leaves zero flag set)

L1A53:
       LDA    $AF,X                   ;4
       EOR    #$10                    ;2
       AND    #$F0                    ;2
       ORA    #$01                    ;2
       STA    $AF,X                   ;4
       LDA    $8D,X                   ;4
       BNE    L1A6C                   ;2
L1A61:
       LDA    $8D,X                   ;4
       CMP    #$71                    ;2
       BEQ    L1A53                   ;2
       JSR    L1CDE                   ;6
       STA    $8D,X                   ;4
L1A6C:
       LDY    $B6,X                   ;4
       BNE    L1A77                   ;2
       LDY    #$08                    ;2
       JSR    L1CCF                   ;6
       STA    $91,X                   ;4
L1A77:
       DEX                            ;2
       BMI    L1A7D                   ;2
       JMP    L19ED                   ;3
L1A7D:
       LDA    INTIM                   ;4
       BNE    L1A7D                   ;2
       JMP    L1277                   ;3



L1ACE: ;2 bytes
       .byte $56 ; | X X XX | $1ACE
;       .byte $F8 ; |XXXXX   | $1ACF
L1A85:
       SED                            ;2 (shared)
       CLC                            ;2
       ADC.wy Score+4,Y               ;4
       STA.wy Score+4,Y               ;5
       TXA                            ;2
       BCC    L1A92                   ;2
       ADC    #$00                    ;2
L1A92:
       CLC                            ;2
       ADC.wy Score+2,Y               ;4
       STA.wy Score+2,Y               ;5
       LDA    #$00                    ;2
       BCC    L1A9F                   ;2
       ADC    #$00                    ;2
L1A9F:
       ADC.wy Score,Y                 ;4
       STA.wy Score,Y                 ;5
       CLD                            ;2
       RTS                            ;6

L1AA7:
       LDA    #$05                    ;2
       STA    $90                     ;3
       LDA    #$F5                    ;2
       STA    $96                     ;3
       STA    $F9                     ;3
       LDA    #$03                    ;2
       STA    $95                     ;3
       LDA    #$96                    ;2
       STA    $C5                     ;3
       LDA    #$87                    ;2
       STA    $C6                     ;3
       LDA    #$78                    ;2
       STA    $C7                     ;3
       LDA    #$6E                    ;2
       STA    COLUPF                  ;3
       LDA    #$8C                    ;2
       STA    $F7                     ;3
       LDA    #$FF                    ;2
       STA    $D1                     ;3
       RTS                            ;6





L1AD2:
       LDA    #$00                    ;2
       STA    $CC                     ;3
       LDX    #$9D                    ;2
L1AD8:
       STA    VSYNC,X                 ;4
       INX                            ;2
       CPX    #$BD                    ;2
       BNE    L1AD8                   ;2
       STX    $F1                     ;3
       STA    $F2                     ;3
       STA    $F3                     ;3
       RTS                            ;6

L1AE6:
       LDA    $D5                     ;3
       STA    Temp                    ;3
       LDX    #$07                    ;2
L1AEC:
       LDA    $A5,X                   ;4
       BEQ    L1AFF                   ;2
       CLC                            ;2
       BIT    Temp                    ;3
       BPL    L1AF8                   ;2
L1AF5:
       ROR                            ;2
       BCC    L1AFB                   ;2
L1AF8:
       ROL                            ;2
       BCS    L1AF5                   ;2
L1AFB:
       STA    $A5,X                   ;4
       ASL    Temp                    ;5
L1AFF:
       DEX                            ;2
       BPL    L1AEC                   ;2
L1B07:
       RTS                            ;6

L1B03:
       CMP    #$00                    ;2
;       BNE    L1B08                   ;2
;L1B07:
;       RTS                            ;6
       BEQ    L1B07                   ;2

L1B08:
       LDY    $AF,X                   ;4
       STY    Temp                    ;3
       CMP    #$04                    ;2
       BCS    L1B21                   ;2
       SEC                            ;2
       SBC    #$01                    ;2
       BNE    L1B07                   ;2
       LDA    $B6,X                   ;4
       AND    $BF                     ;3
       STA    $B6,X                   ;4
       AND    #$60                    ;2
       BEQ    L1B52                   ;2
       BNE    L1B5F                   ;2
L1B21:
       TAY                            ;2
       LDA    #$07                    ;2
       STA    $BF                     ;3
       BNE    L1B7D                   ;2
L1B28:
       LDY    $AF,X                   ;4
       STY    Temp                    ;3
       BIT    Temp                    ;3
       BMI    L1B33                   ;2
       BVS    L1B65                   ;2
       RTS                            ;6

L1B33:
       BVC    L1B6F                   ;2
       SEC                            ;2
       SBC    #$01                    ;2
       BEQ    L1B52                   ;2
       CMP    #$15                    ;2
       BNE    L1B64                   ;2
       LDA    Temp                    ;3
       AND    #$0F                    ;2
       ORA    #$80                    ;2
       STA    $AF,X                   ;4
       LDA    $B6,X                   ;4
       ORA    #$F0                    ;2
       STA    $B6,X                   ;4
       JSR    L1BAF                   ;6
       LDA    #$19                    ;2
       RTS                            ;6

L1B52:
       LDA    Temp                    ;3
       AND    #$3F                    ;2
       STA    $AF,X                   ;4
       CPX    #$03                    ;2
       BNE    L1B5F                   ;2
       JSR    L1CC2                   ;6
L1B5F:
       JSR    L1BAF                   ;6
       LDA    #$00                    ;2
L1B64:
       RTS                            ;6

L1B65:
       CLC                            ;2
       ADC    #$01                    ;2
       CMP    #$04                    ;2
       BNE    L1B64                   ;2
       LDA    #$01                    ;2
       RTS                            ;6

L1B6F:
       TAY                            ;2
       LDA    $80                     ;3
       LSR                            ;2
       STA    $BF                     ;3
       CPX    #$03                    ;2
       BNE    L1B7D                   ;2
       LDA    #$07                    ;2
       STA    $BF                     ;3
L1B7D:
       LDA    Temp                    ;3
       AND    #$20                    ;2
       BNE    L1B95                   ;2
       INY                            ;2
       TYA                            ;2
       LDY    $BF                     ;3
       CMP    L1BA7,Y                 ;4
       BNE    L1B64                   ;2
L1B8C:
       TAY                            ;2
       LDA    Temp                    ;3
       EOR    #$20                    ;2
       STA    $AF,X                   ;4
       TYA                            ;2
       RTS                            ;6

L1B95:
       DEY                            ;2
       TYA                            ;2
       LDY    $BF                     ;3
       CMP    L1B9F,Y                 ;4
       BEQ    L1B8C                   ;2
       RTS                            ;6






L1BAF:
       LDA    $B5                     ;3
       AND    #$0F                    ;2
       ORA    #$10                    ;2
       STA    $B5                     ;3
       RTS                            ;6

L1BB8:
       LDY    $8F                     ;3
       LDX    $9F                     ;3
       CPX    #$05                    ;2
       BCS    L1BC8                   ;2
       LDX    $A3                     ;3
       LDY    $93                     ;3
       CPX    #$05                    ;2
       BCC    L1C10                   ;2
L1BC8:
       STY    $94                     ;3
       STX    $B3                     ;3
       LDA    $EB                     ;3
       AND    #$7F                    ;2
       STA    $EB                     ;3
       LDA    $C7                     ;3
       STA    $C8                     ;3
       LDA    $B1                     ;3
       AND    #$F0                    ;2
       STA    $B2                     ;3
       LDX    #$01                    ;2
L1BDE:
       LDA    $AF,X                   ;4
       STA    $B0,X                   ;4
       LDA    $8D,X                   ;4
       STA    $8E,X                   ;4
       LDA    $91,X                   ;4
       STA    $92,X                   ;4
       LDA    $9D,X                   ;4
       STA    $9E,X                   ;4
       LDA    $A1,X                   ;4
       STA    $A2,X                   ;4
       LDA    $C5,X                   ;4
       STA    $C6,X                   ;4
       LDA    $B6,X                   ;4
       STA    $B7,X                   ;4
       DEX                            ;2
       BPL    L1BDE                   ;2
       LDA    $97                     ;3
       BMI    L1C03                   ;2
       INC    $97                     ;5
L1C03:
       INX                            ;2
       STX    $AF                     ;3
       STX    $9D                     ;3
       STX    $A1                     ;3
       STX    $B6                     ;3
       LDA    #$96                    ;2
       STA    $C5                     ;3
L1C10:
       RTS                            ;6





L1C11:
       STA    Temp                    ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       JSR    L1C2A                   ;6
       LDA    Temp                    ;3
       AND    #$0F                    ;2
       JSR    L1C2A                   ;6
       LDA    #>Digits                ;2
       STA    PrintTemp-3,X           ;4
       STA    PrintTemp-1,X           ;4
       RTS                            ;6


L1C2A:
       ASL                            ;2
       STA    $BF                     ;3
       ASL                            ;2
       ASL                            ;2
       CLC                            ;2
       ADC    $BF                     ;3
       STA    PrintTemp,X             ;4
       INX                            ;2
       INX                            ;2
       RTS                            ;6

L1C33:
       LDA    $99                     ;3
       BNE    L1C6D                   ;2
       BIT    $B2                     ;3
       BMI    L1C6E                   ;2
       LDA    $9F                     ;3
       CMP    #$04                    ;2
       BCC    L1C6D                   ;2
       LDY    $D5                     ;3
       CPY    #$B0                    ;2
       BCC    L1C6D                   ;2
       LDA    $8F                     ;3
       LDY    #$04                    ;2
       JSR    L1CCF                   ;6
       JSR    L1D31                   ;6
       BCS    L1C6D                   ;2
       LDY    $C7                     ;3
       CPY    #$50                    ;2
       BCS    L1C6D                   ;2
       STA    $94                     ;3


;       BIT    $EB                     ;3
;       BVC    L1C63                   ;2
;       LDA    #$04                    ;2
;       BNE    L1C67                   ;2
;L1C63:
;       LDA    $D5                     ;3
;       AND    #$07                    ;2
;L1C67:
       LDA    #$04                    ;2
       BIT    $EB                     ;3
       BVS    L1C67                   ;2
       LDA    $D5                     ;3
       AND    #$07                    ;2
L1C67:







       STA    $B4                     ;3
       LDA    #$00                    ;2
       STA    $9A                     ;3
L1C6D:
       RTS                            ;6

L1C6E:
       BIT    $B2                     ;3
       BVS    L1CCE                   ;2
       LDA    $B2                     ;3
       AND    #$07                    ;2
       BNE    L1C81                   ;2
       LDX    #$03                    ;2
       LDA    $91,X                   ;4
       JSR    L1D3D                   ;6
       LDA    #$00                    ;2
L1C81:
       TAY                            ;2
       LDA    $C8                     ;3
       CLC                            ;2
       ADC    L1CB2,Y                 ;4
       STA    $C8                     ;3
       BEQ    L1CC2                   ;2
       LDA    $EF                     ;3
       CLC                            ;2
       ADC    L1CBA,Y                 ;4
       STA    $EF                     ;3
       BCC    L1CCE                   ;2
       LDY    #$01                    ;2
       LDA    $B2                     ;3
       AND    #$10                    ;2
       BEQ    L1CA6                   ;2
       LDA    $94                     ;3
       JSR    L1CCF                   ;6
;       JMP    L1CAF                   ;3
       BEQ    L1CAF                   ;2 always branch (subroutine L1CCF leaves zero flag set)

L1CA6:
       LDA    $94                     ;3
       CMP    #$71                    ;2
       BEQ    L1CAF                   ;2
       JSR    L1CDE                   ;6
L1CAF:
       STA    $94                     ;3
       RTS                            ;6
L1CC2:
       LDA    #$00                    ;2
       STA    $B2                     ;3
       STA    $B3                     ;3
       LDA    $EB                     ;3
       ORA    #$80                    ;2
       STA    $EB                     ;3
L1CCE:
       RTS                            ;6










L1CCF:
       SEC                            ;2
       SBC    #$10                    ;2
       BMI    L1CDA                   ;2
       CMP    #$70                    ;2
       BCC    L1CDA                   ;2
       ADC    #$F0                    ;2
L1CDA:
       DEY                            ;2
       BNE    L1CCF                   ;2
       RTS                            ;6







L1CDE:
       CLC                            ;2
       ADC    #$10                    ;2
       BPL    L1CE9                   ;2
       CMP    #$90                    ;2
       BCS    L1CE9                   ;2
       SBC    #$F0                    ;2
L1CE9:
       DEY                            ;2
       BNE    L1CDE                   ;2
       RTS                            ;6










L1D09:
       CPX    #$00                    ;2
       BNE    L1D15                   ;2
       LDA    #$97                    ;2
       CLC                            ;2
       ADC    $C6                     ;3
;       JMP    L1D2F                   ;3
       ROR                            ;2
       RTS                            ;6

L1D15:
       CPX    #$01                    ;2
       BNE    L1D21                   ;2
       LDA    $C5                     ;3
       CLC                            ;2
       ADC    $C7                     ;3
;       JMP    L1D2F                   ;3
       ROR                            ;2
       RTS                            ;6

L1D21:
       LDA    $C6                     ;3
       CLC                            ;2
       BIT    $B2                     ;3
       BPL    L1D2D                   ;2
       ADC    $C8                     ;3
;       JMP    L1D2F                   ;3
       ROR                            ;2
       RTS                            ;6

L1D2D:
       ADC    $98                     ;3
;L1D2F:
       ROR                            ;2
       RTS                            ;6




L1D31:
       LDX    #$09                    ;2
       SEC                            ;2
L1D34:
       LDY    $A5,X                   ;4
       BNE    L1D3C                   ;2
       DEX                            ;2
       BPL    L1D34                   ;2
       CLC                            ;2
L1D3C:
       RTS                            ;6





L1D3D:
       LDY    #$04                    ;2
       JSR    L1CCF                   ;6
       STA    $BF                     ;3
       AND    #$0F                    ;2
       STA    Temp                    ;3
       LDA    $90                     ;3
       AND    #$0F                    ;2
       CMP    Temp                    ;3
       BNE    L1D7B                   ;2
       LDA    DifSw                   ;3
       ASL                            ;2
       LDY    $ED                     ;3
       BNE    L1D59                   ;2
       ASL                            ;2
L1D59:
       LDY    #$FF                    ;2
       BCC    L1D5F                   ;2
       LDY    #$0F                    ;2
L1D5F:
       STY    Sprite0Ptr              ;3
       LDA    $BF                     ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       CLC                            ;2
       ADC    #$08                    ;2
       EOR    Sprite0Ptr              ;3
       STA    Temp                    ;3
       LDA    $90                     ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       CLC                            ;2
       ADC    #$08                    ;2
       EOR    Sprite0Ptr              ;3
       CMP    Temp                    ;3
L1D7B:
       LDA    $AF,X                   ;4
       BCC    L1D83                   ;2
       ORA    #$10                    ;2
       BNE    L1D85                   ;2
L1D83:
       AND    #$EF                    ;2
L1D85:
       STA    $AF,X                   ;4
       RTS                            ;6





;       ORG $1D7B
;       .byte $00 ; |        | $1FED

       ORG $1D7B



;L1DA2: ;12 bytes
;       .byte $08 ; |    X   | $1DA2
;       .byte $06 ; |     XX | $1DA3
;       .byte $06 ; |     XX | $1DA4
;       .byte $03 ; |      XX| $1DA5
;       .byte $05 ; |     X X| $1DA6
;       .byte $04 ; |     X  | $1DA7
;       .byte $05 ; |     X X| $1DA8
;       .byte $04 ; |     X  | $1DA9
;       .byte $05 ; |     X X| $1DAA
;       .byte $04 ; |     X  | $1DAB
;       .byte $05 ; |     X X| $1DAC
;       .byte $04 ; |     X  | $1DAD


L1DA2: ;12 bytes (low)
L1F96: ;12 bytes (high)
       .byte $68 ; |     XX | $1F96
       .byte $76 ; |     XXX| $1F97
       .byte $86 ; |    X   | $1F98
       .byte $73 ; |     XXX| $1F99
       .byte $65 ; |     XX | $1F9A
       .byte $74 ; |     XXX| $1F9B
       .byte $65 ; |     XX | $1F9C
       .byte $54 ; |     X X| $1F9D
       .byte $45 ; |     X  | $1F9E
       .byte $34 ; |      XX| $1F9F
       .byte $45 ; |     X  | $1FA0
       .byte $64 ; |     XX | $1FA1

;L1FA2: ;12 bytes
;       .byte $01 ; |       X| $1FA2
;       .byte $00 ; |        | $1FA3
;       .byte $02 ; |      X | $1FA4
;       .byte $00 ; |        | $1FA5
;       .byte $03 ; |      XX| $1FA6
;       .byte $00 ; |        | $1FA7
;       .byte $04 ; |     X  | $1FA8
;       .byte $00 ; |        | $1FA9
;       .byte $05 ; |     X X| $1FAA
;       .byte $00 ; |        | $1FAB
;       .byte $06 ; |     XX | $1FAC
;       .byte $00 ; |        | $1FAD

L1DEC: ;6 bytes
       .byte $8A ; |X   X X | $1DEC
       .byte $6A ; | XX X X | $1DED
       .byte $4A ; | X  X X | $1DEE
       .byte $7A ; | XXXX X | $1DEF
       .byte $9A ; |X  XX X | $1DF0
L1DF1: ;6 bytes
       .byte $80 ; |X       | $1DF1 (shared)
       .byte $C0 ; |XX      | $1DF2
       .byte $A0 ; |X X     | $1DF3
       .byte $E0 ; |XXX     | $1DF4
       .byte $B0 ; |X XX    | $1DF5
       .byte $F0 ; |XXXX    | $1DF6




L1EF8:
       .byte $FF ; |XXXXXXXX| $1EF8
       .byte $C0 ; |XX      | $1EF9
       .byte $A0 ; |X X     | $1EFA
       .byte $80 ; |X       | $1EFB
       .byte $80 ; |X       | $1EFC
       .byte $A0 ; |X X     | $1EFD
       .byte $C0 ; |XX      | $1EFE
;       .byte $FF ; |XXXXXXXX| $1EFF
L1CB2: ;8 bytes
       .byte $FF ; |XXXXXXXX| $1CB2 shared
       .byte $FF ; |XXXXXXXX| $1CB3
       .byte $FF ; |XXXXXXXX| $1CB4
       .byte $FF ; |XXXXXXXX| $1CB5
       .byte $FF ; |XXXXXXXX| $1CB6
       .byte $01 ; |       X| $1CB7
       .byte $01 ; |       X| $1CB8
       .byte $01 ; |       X| $1CB9


L1D94: ;8 bytes
       .byte $00 ; |        | $1D94
       .byte $80 ; |X       | $1D95
       .byte $01 ; |       X| $1D96
       .byte $03 ; |      XX| $1D97
       .byte $02 ; |      X | $1D98
       .byte $80 ; |X       | $1D99
       .byte $03 ; |      XX| $1D9A
;       .byte $80 ; |X       | $1D9B
L1DE7: ;5 bytes
       .byte $80 ; |X       | $1DE7 shared
       .byte $00 ; |        | $1DE8
       .byte $00 ; |        | $1DE9
       .byte $00 ; |        | $1DEA
       .byte $84 ; |X    X  | $1DEB




L1DBC: ;8 bytes
       .byte <L1DE7 ; |XXX  XXX| $1DBC
       .byte <L1DE2 ; |XXX   X | $1DBD
       .byte <L1DDD ; |XX XXX X| $1DBE
       .byte <L1DD8 ; |XX XX   | $1DBF
       .byte <L1DD3 ; |XX X  XX| $1DC0
       .byte <L1DCE ; |XX  XXX | $1DC1
       .byte <L1DC9 ; |XX  X  X| $1DC2
       .byte <L1DC4 ; |XX   X  | $1DC3

;(all must be on 1 page)
L1DCE: ;5 bytes
       .byte $0A ; |    X X | $1DCE
       .byte $00 ; |        | $1DCF
       .byte $02 ; |      X | $1DD0
       .byte $10 ; |   X    | $1DD1
       .byte $04 ; |     X  | $1DD2


;extra life tune data
L1FEC: ;16 bytes
       .byte $15 ; |   X X X| $1FEC
       .byte $00 ; |        | $1FED
       .byte $00 ; |        | $1FEE
       .byte $1A ; |   XX X | $1FEF
       .byte $00 ; |        | $1FF0
       .byte $00 ; |        | $1FF1
       .byte $00 ; |        | $1FF2
       .byte $1C ; |   XXX  | $1FF3
       .byte $17 ; |   X XXX| $1FF4
       .byte $1A ; |   XX X | $1FF5
       .byte $15 ; |   X X X| $1FF6
       .byte $17 ; |   X XXX| $1FF7
       .byte $13 ; |   X  XX| $1FF8
       .byte $15 ; |   X X X| $1FF9
       .byte $11 ; |   X   X| $1FFA
;       .byte $00 ; |        | $1FFB
L1D9C: ;6 bytes
       .byte $00 ; |        | $1D9C shared
       .byte $28 ; |  X X   | $1D9D
       .byte $28 ; |  X X   | $1D9E
       .byte $38 ; |  XXX   | $1D9F
       .byte $10 ; |   X    | $1DA0
;       .byte $10 ; |   X    | $1DA1
L1DD3: ;5 bytes
       .byte $10 ; |   X    | $1DD3 shared
       .byte $02 ; |      X | $1DD4
       .byte $04 ; |     X  | $1DD5
       .byte $40 ; | X      | $1DD6
;       .byte $10 ; |   X    | $1DD7
L1FE6: ;6 bytes
       .byte $10 ; |   X    | $1FE6 shared
       .byte $15 ; |   X X X| $1FE7
       .byte $20 ; |  X     | $1FE8
       .byte $25 ; |  X  X X| $1FE9
       .byte $30 ; |  XX    | $1FEA
       .byte $35 ; |  XX X X| $1FEB


;L1EF0:
;       .byte $40 ; | X      | $1EF0
;       .byte $80 ; |X       | $1EF1
;       .byte $C0 ; |XX      | $1EF2
;       .byte $F0 ; |XXXX    | $1EF3
;       .byte $F0 ; |XXXX    | $1EF4
;       .byte $C0 ; |XX      | $1EF5
;       .byte $80 ; |X       | $1EF6
;       .byte $40 ; | X      | $1EF7
L1EF0: ;routine trims off lower nybble so both tables can be shared
L1CBA: ;8 bytes
       .byte $40 ; | X      | $1CBA shared
       .byte $80 ; |X       | $1CBB shared
       .byte $C0 ; |XX      | $1CBC shared
       .byte $FF ; |XXXXXXXX| $1CBD shared
       .byte $FF ; |XXXXXXXX| $1CBE shared
       .byte $C0 ; |XX      | $1CBF shared
       .byte $80 ; |X       | $1CC0 shared
;       .byte $40 ; | X      | $1CC1 shared
L1DE2: ;5 bytes
       .byte $40 ; | X      | $1DE2 shared x2
       .byte $80 ; |X       | $1DE3
       .byte $08 ; |    X   | $1DE4
       .byte $00 ; |        | $1DE5
       .byte $24 ; |  X  X  | $1DE6




L1DC4: ;5 bytes
       .byte $06 ; |     XX | $1DC4
       .byte $03 ; |      XX| $1DC5
       .byte $01 ; |       X| $1DC6
;       .byte $00 ; |        | $1DC7
;       .byte $00 ; |        | $1DC8
;edited...both tables shared
L1DB5: ;7 bytes
       .byte $00 ; |        | $1DB5 shared
L1DAE: ;7 bytes
       .byte $00 ; |        | $1DAE shared x2
       .byte $00 ; |        | $1DAF shared
       .byte $00 ; |        | $1DB0 shared
       .byte $01 ; |       X| $1DB1 shared
       .byte $01 ; |       X| $1DB2 shared
       .byte $03 ; |      XX| $1DB3 shared
;       .byte $03 ; |      XX| $1DB4
L1DF7: ;6 bytes
       .byte $03 ; |      XX| $1DF7 shared
       .byte $04 ; |     X  | $1DF8
       .byte $05 ; |     X X| $1DF9
       .byte $05 ; |     X X| $1DFA
       .byte $06 ; |     XX | $1DFB
;       .byte $06 ; |     XX | $1DFC
L1DC9: ;5 bytes
       .byte $06 ; |     XX | $1DC9 shared
       .byte $01 ; |       X| $1DCA
       .byte $04 ; |     X  | $1DCB
       .byte $02 ; |      X | $1DCC
;       .byte $00 ; |        | $1DCD
L1DD8: ;5 bytes
       .byte $00 ; |        | $1DD8 shared
       .byte $10 ; |   X    | $1DD9
       .byte $82 ; |X     X | $1DDA
       .byte $44 ; | X   X  | $1DDB
;       .byte $00 ; |        | $1DDC
L1DDD: ;5 bytes
       .byte $00 ; |        | $1DDD shared
       .byte $40 ; | X      | $1DDE
       .byte $90 ; |X  X    | $1DDF
       .byte $02 ; |      X | $1DE0
       .byte $08 ; |    X   | $1DE1




       ORG $1E00


L1E00:
       .byte $00 ; |        | $1E00
       .byte $00 ; |        | $1E01
       .byte $00 ; |        | $1E02
       .byte $00 ; |        | $1E03
       .byte $00 ; |        | $1E04
       .byte $00 ; |        | $1E05
       .byte $00 ; |        | $1E06
       .byte $00 ; |        | $1E07

       .byte $00 ; |        | $1E08
       .byte $88 ; |X   X   | $1E09
       .byte $20 ; |  X     | $1E0A
       .byte $08 ; |    X   | $1E0B
       .byte $00 ; |        | $1E0C
       .byte $02 ; |      X | $1E0D
       .byte $40 ; | X      | $1E0E
       .byte $10 ; |   X    | $1E0F

       .byte $00 ; |        | $1E10
       .byte $40 ; | X      | $1E11
       .byte $08 ; |    X   | $1E12
       .byte $40 ; | X      | $1E13
       .byte $04 ; |     X  | $1E14
       .byte $00 ; |        | $1E15
       .byte $48 ; | X  X   | $1E16
       .byte $02 ; |      X | $1E17

       .byte $00 ; |        | $1E18
       .byte $44 ; | X   X  | $1E19
       .byte $00 ; |        | $1E1A
       .byte $40 ; | X      | $1E1B
       .byte $04 ; |     X  | $1E1C
       .byte $20 ; |  X     | $1E1D
       .byte $09 ; |    X  X| $1E1E
       .byte $00 ; |        | $1E1F

       .byte $00 ; |        | $1E20
       .byte $03 ; |      XX| $1E21
       .byte $07 ; |     XXX| $1E22
       .byte $0E ; |    XXX | $1E23
       .byte $19 ; |   XX  X| $1E24
       .byte $F0 ; |XXXX    | $1E25
       .byte $02 ; |      X | $1E26
       .byte $00 ; |        | $1E27

       .byte $00 ; |        | $1E28
       .byte $06 ; |     XX | $1E29
       .byte $03 ; |      XX| $1E2A
       .byte $CE ; |XX  XXX | $1E2B
       .byte $71 ; | XXX   X| $1E2C
       .byte $00 ; |        | $1E2D
       .byte $04 ; |     X  | $1E2E
       .byte $00 ; |        | $1E2F

       .byte $00 ; |        | $1E30
       .byte $4C ; | X  XX  | $1E31
       .byte $46 ; | X   XX | $1E32
       .byte $23 ; |  X   XX| $1E33
       .byte $1F ; |   XXXXX| $1E34
       .byte $02 ; |      X | $1E35
       .byte $01 ; |       X| $1E36
       .byte $08 ; |    X   | $1E37

       .byte $00 ; |        | $1E38
       .byte $10 ; |   X    | $1E39
       .byte $21 ; |  X    X| $1E3A
       .byte $22 ; |  X   X | $1E3B
       .byte $24 ; |  X  X  | $1E3C
       .byte $14 ; |   X X  | $1E3D
       .byte $0F ; |    XXXX| $1E3E
       .byte $0C ; |    XX  | $1E3F

       .byte $00 ; |        | $1E40
       .byte $40 ; | X      | $1E41
       .byte $82 ; |X     X | $1E42
       .byte $84 ; |X    X  | $1E43
       .byte $64 ; | XX  X  | $1E44
       .byte $1F ; |   XXXXX| $1E45
       .byte $06 ; |     XX | $1E46
       .byte $00 ; |        | $1E47

       .byte $00 ; |        | $1E48
       .byte $44 ; | X   X  | $1E49
       .byte $24 ; |  X  X  | $1E4A
       .byte $14 ; |   X X  | $1E4B
       .byte $0F ; |    XXXX| $1E4C
       .byte $03 ; |      XX| $1E4D
       .byte $00 ; |        | $1E4E
       .byte $00 ; |        | $1E4F

       .byte $00 ; |        | $1E50
       .byte $36 ; |  XX XX | $1E51
       .byte $1D ; |   XXX X| $1E52
       .byte $02 ; |      X | $1E53
       .byte $04 ; |     X  | $1E54
       .byte $0A ; |    X X | $1E55
       .byte $04 ; |     X  | $1E56
       .byte $00 ; |        | $1E57

       .byte $00 ; |        | $1E58
       .byte $09 ; |    X  X| $1E59
       .byte $1E ; |   XXXX | $1E5A
       .byte $32 ; |  XX  X | $1E5B
       .byte $24 ; |  X  X  | $1E5C
       .byte $08 ; |    X   | $1E5D
       .byte $0A ; |    X X | $1E5E
       .byte $00 ; |        | $1E5F

       .byte $00 ; |        | $1E60
       .byte $02 ; |      X | $1E61
       .byte $9F ; |X  XXXXX| $1E62
       .byte $B2 ; |X XX  X | $1E63
       .byte $E4 ; |XXX  X  | $1E64
       .byte $48 ; | X  X   | $1E65
       .byte $10 ; |   X    | $1E66
       .byte $24 ; |  X  X  | $1E67

       .byte $00 ; |        | $1E68
       .byte $9F ; |X  XXXXX| $1E69
       .byte $8F ; |X   XXXX| $1E6A
       .byte $87 ; |X    XXX| $1E6B
       .byte $88 ; |X   X   | $1E6C
       .byte $90 ; |X  X    | $1E6D
       .byte $64 ; | XX  X  | $1E6E
       .byte $00 ; |        | $1E6F

       .byte $00 ; |        | $1E70
       .byte $4F ; | X  XXXX| $1E71
       .byte $98 ; |X  XX   | $1E72
       .byte $8C ; |X   XX  | $1E73
       .byte $87 ; |X    XXX| $1E74
       .byte $88 ; |X   X   | $1E75
       .byte $70 ; | XXX    | $1E76
       .byte $04 ; |     X  | $1E77

       .byte $00 ; |        | $1E78
       .byte $27 ; |  X  XXX| $1E79
       .byte $4C ; | X  XX  | $1E7A
       .byte $98 ; |X  XX   | $1E7B
       .byte $8C ; |X   XX  | $1E7C
       .byte $87 ; |X    XXX| $1E7D
       .byte $48 ; | X  X   | $1E7E
       .byte $32 ; |  XX  X | $1E7F

       .byte $00 ; |        | $1E80
       .byte $04 ; |     X  | $1E81
       .byte $44 ; | X   X  | $1E82
       .byte $24 ; |  X  X  | $1E83
       .byte $23 ; |  X   XX| $1E84
       .byte $23 ; |  X   XX| $1E85
       .byte $14 ; |   X X  | $1E86
       .byte $08 ; |    X   | $1E87

       .byte $00 ; |        | $1E88
       .byte $20 ; |  X     | $1E89
       .byte $24 ; |  X  X  | $1E8A
       .byte $28 ; |  X X   | $1E8B
       .byte $24 ; |  X  X  | $1E8C
       .byte $23 ; |  X   XX| $1E8D
       .byte $27 ; |  X  XXX| $1E8E
       .byte $18 ; |   XX   | $1E8F

       .byte $00 ; |        | $1E90
       .byte $10 ; |   X    | $1E91
       .byte $20 ; |  X     | $1E92
       .byte $48 ; | X  X   | $1E93
       .byte $44 ; | X   X  | $1E94
       .byte $42 ; | X    X | $1E95
       .byte $47 ; | X   XXX| $1E96
       .byte $3F ; |  XXXXXX| $1E97

       .byte $00 ; |        | $1E98
       .byte $00 ; |        | $1E99
       .byte $00 ; |        | $1E9A
       .byte $00 ; |        | $1E9B
       .byte $01 ; |       X| $1E9C
       .byte $01 ; |       X| $1E9D
       .byte $00 ; |        | $1E9E
       .byte $00 ; |        | $1E9F

       .byte $00 ; |        | $1EA0
       .byte $00 ; |        | $1EA1
       .byte $00 ; |        | $1EA2
       .byte $03 ; |      XX| $1EA3
       .byte $05 ; |     X X| $1EA4
       .byte $03 ; |      XX| $1EA5
       .byte $00 ; |        | $1EA6
       .byte $00 ; |        | $1EA7

       .byte $00 ; |        | $1EA8
       .byte $00 ; |        | $1EA9
       .byte $06 ; |     XX | $1EAA
       .byte $09 ; |    X  X| $1EAB
       .byte $09 ; |    X  X| $1EAC
       .byte $09 ; |    X  X| $1EAD
       .byte $06 ; |     XX | $1EAE
       .byte $00 ; |        | $1EAF

       .byte $00 ; |        | $1EB0
       .byte $20 ; |  X     | $1EB1
       .byte $04 ; |     X  | $1EB2
       .byte $11 ; |   X   X| $1EB3
       .byte $80 ; |X       | $1EB4
       .byte $14 ; |   X X  | $1EB5
       .byte $42 ; | X    X | $1EB6
       .byte $90 ; |X  X    | $1EB7

       .byte $00 ; |        | $1EB8
       .byte $40 ; | X      | $1EB9
       .byte $04 ; |     X  | $1EBA
       .byte $12 ; |   X  X | $1EBB
       .byte $A0 ; |X X     | $1EBC
       .byte $14 ; |   X X  | $1EBD
       .byte $40 ; | X      | $1EBE
       .byte $84 ; |X    X  | $1EBF

       .byte $00 ; |        | $1EC0
       .byte $00 ; |        | $1EC1
       .byte $20 ; |  X     | $1EC2
       .byte $14 ; |   X X  | $1EC3
       .byte $68 ; | XX X   | $1EC4
       .byte $08 ; |    X   | $1EC5
       .byte $14 ; |   X X  | $1EC6
       .byte $20 ; |  X     | $1EC7

       .byte $00 ; |        | $1EC8
       .byte $00 ; |        | $1EC9
       .byte $00 ; |        | $1ECA
       .byte $10 ; |   X    | $1ECB
       .byte $28 ; |  X X   | $1ECC
       .byte $6C ; | XX XX  | $1ECD
       .byte $C6 ; |XX   XX | $1ECE
       .byte $82 ; |X     X | $1ECF

       .byte $00 ; |        | $1ED0
       .byte $00 ; |        | $1ED1
       .byte $82 ; |X     X | $1ED2
       .byte $82 ; |X     X | $1ED3
       .byte $D6 ; |XX X XX | $1ED4
       .byte $6C ; | XX XX  | $1ED5
       .byte $00 ; |        | $1ED6
       .byte $00 ; |        | $1ED7

       .byte $00 ; |        | $1ED8
       .byte $00 ; |        | $1ED9
       .byte $44 ; | X   X  | $1EDA
       .byte $82 ; |X     X | $1EDB
       .byte $82 ; |X     X | $1EDC
       .byte $C6 ; |XX   XX | $1EDD
       .byte $7C ; | XXXXX  | $1EDE
       .byte $10 ; |   X    | $1EDF

L1EE0:
       .byte $80 ; |X       | $1EE0
       .byte $20 ; |  X     | $1EE1
       .byte $10 ; |   X    | $1EE2
       .byte $50 ; | X X    | $1EE3
       .byte $41 ; | X     X| $1EE4
       .byte $84 ; |X    X  | $1EE5
       .byte $88 ; |X   X   | $1EE6
       .byte $42 ; | X    X | $1EE7
       .byte $40 ; | X      | $1EE8
       .byte $08 ; |    X   | $1EE9
       .byte $04 ; |     X  | $1EEA
       .byte $01 ; |       X| $1EEB
       .byte $81 ; |X      X| $1EEC
       .byte $22 ; |  X   X | $1EED
       .byte $11 ; |   X   X| $1EEE
       .byte $44 ; | X   X  | $1EEF



L1B9F: ;8 bytes
       .byte $04 ; |     X  | $1B9F
       .byte $07 ; |     XXX| $1BA0
       .byte $0A ; |    X X | $1BA1
       .byte $0D ; |    XX X| $1BA2
       .byte $10 ; |   X    | $1BA3
       .byte $13 ; |   X  XX| $1BA4
       .byte $16 ; |   X XX | $1BA5
       .byte $19 ; |   XX  X| $1BA6


L1BA7: ;8 bytes
       .byte $06 ; |     XX | $1BA7
       .byte $09 ; |    X  X| $1BA8
       .byte $0C ; |    XX  | $1BA9
       .byte $0F ; |    XXXX| $1BAA
       .byte $12 ; |   X  X | $1BAB
       .byte $15 ; |   X X X| $1BAC
       .byte $18 ; |   XX   | $1BAD
       .byte $1B ; |   XX XX| $1BAE



       ORG $1F00


Digits:
       .byte $7C ; | XXXXX  | $1F00
       .byte $64 ; | XX  X  | $1F01
       .byte $64 ; | XX  X  | $1F02
       .byte $64 ; | XX  X  | $1F03
       .byte $64 ; | XX  X  | $1F04
       .byte $64 ; | XX  X  | $1F05
       .byte $64 ; | XX  X  | $1F06
       .byte $64 ; | XX  X  | $1F07
       .byte $7C ; | XXXXX  | $1F08
       .byte $00 ; |        | $1F09

       .byte $18 ; |   XX   | $1F0A
       .byte $18 ; |   XX   | $1F0B
       .byte $18 ; |   XX   | $1F0C
       .byte $18 ; |   XX   | $1F0D
       .byte $18 ; |   XX   | $1F0E
       .byte $18 ; |   XX   | $1F0F
       .byte $18 ; |   XX   | $1F10
       .byte $18 ; |   XX   | $1F11
       .byte $38 ; |  XXX   | $1F12
       .byte $00 ; |        | $1F13

       .byte $7C ; | XXXXX  | $1F14
       .byte $4C ; | X  XX  | $1F15
       .byte $4C ; | X  XX  | $1F16
       .byte $40 ; | X      | $1F17
       .byte $3C ; |  XXXX  | $1F18
       .byte $0C ; |    XX  | $1F19
       .byte $4C ; | X  XX  | $1F1A
       .byte $4C ; | X  XX  | $1F1B
       .byte $7C ; | XXXXX  | $1F1C
       .byte $00 ; |        | $1F1D

       .byte $7C ; | XXXXX  | $1F1E
       .byte $4C ; | X  XX  | $1F1F
       .byte $4C ; | X  XX  | $1F20
       .byte $0C ; |    XX  | $1F21
       .byte $38 ; |  XXX   | $1F22
       .byte $0C ; |    XX  | $1F23
       .byte $4C ; | X  XX  | $1F24
       .byte $4C ; | X  XX  | $1F25
       .byte $7C ; | XXXXX  | $1F26
       .byte $00 ; |        | $1F27

       .byte $0C ; |    XX  | $1F28
       .byte $0C ; |    XX  | $1F29
       .byte $7E ; | XXXXXX | $1F2A
       .byte $4C ; | X  XX  | $1F2B
       .byte $4C ; | X  XX  | $1F2C
       .byte $4C ; | X  XX  | $1F2D
       .byte $4C ; | X  XX  | $1F2E
       .byte $4C ; | X  XX  | $1F2F
       .byte $4C ; | X  XX  | $1F30
       .byte $00 ; |        | $1F31

       .byte $7C ; | XXXXX  | $1F32
       .byte $4C ; | X  XX  | $1F33
       .byte $4C ; | X  XX  | $1F34
       .byte $0C ; |    XX  | $1F35
       .byte $0C ; |    XX  | $1F36
       .byte $7C ; | XXXXX  | $1F37
       .byte $40 ; | X      | $1F38
       .byte $4C ; | X  XX  | $1F39
       .byte $7C ; | XXXXX  | $1F3A
       .byte $00 ; |        | $1F3B

       .byte $7C ; | XXXXX  | $1F3C
       .byte $4C ; | X  XX  | $1F3D
       .byte $4C ; | X  XX  | $1F3E
       .byte $4C ; | X  XX  | $1F3F
       .byte $7C ; | XXXXX  | $1F40
       .byte $40 ; | X      | $1F41
       .byte $4C ; | X  XX  | $1F42
       .byte $4C ; | X  XX  | $1F43
       .byte $7C ; | XXXXX  | $1F44
       .byte $00 ; |        | $1F45

       .byte $30 ; |  XX    | $1F46
       .byte $30 ; |  XX    | $1F47
       .byte $30 ; |  XX    | $1F48
       .byte $18 ; |   XX   | $1F49
       .byte $18 ; |   XX   | $1F4A
       .byte $0C ; |    XX  | $1F4B
       .byte $4C ; | X  XX  | $1F4C
       .byte $4C ; | X  XX  | $1F4D
       .byte $7C ; | XXXXX  | $1F4E
       .byte $00 ; |        | $1F4F

       .byte $7C ; | XXXXX  | $1F50
       .byte $4C ; | X  XX  | $1F51
       .byte $4C ; | X  XX  | $1F52
       .byte $4C ; | X  XX  | $1F53
       .byte $7C ; | XXXXX  | $1F54
       .byte $64 ; | XX  X  | $1F55
       .byte $64 ; | XX  X  | $1F56
       .byte $64 ; | XX  X  | $1F57
       .byte $7C ; | XXXXX  | $1F58
       .byte $00 ; |        | $1F59

       .byte $7C ; | XXXXX  | $1F5A
       .byte $4C ; | X  XX  | $1F5B
       .byte $4C ; | X  XX  | $1F5C
       .byte $0C ; |    XX  | $1F5D
       .byte $7C ; | XXXXX  | $1F5E
       .byte $4C ; | X  XX  | $1F5F
       .byte $4C ; | X  XX  | $1F60
       .byte $4C ; | X  XX  | $1F61
       .byte $7C ; | XXXXX  | $1F62
       .byte $00 ; |        | $1F63

       .byte $00 ; |        | $1F64
       .byte $00 ; |        | $1F65
       .byte $00 ; |        | $1F66
       .byte $00 ; |        | $1F67
       .byte $00 ; |        | $1F68
       .byte $00 ; |        | $1F69
       .byte $00 ; |        | $1F6A
       .byte $00 ; |        | $1F6B
       .byte $00 ; |        | $1F6C
       .byte $00 ; |        | $1F6D

       .byte $3F ; |  XXXXXX| $1F6E
       .byte $40 ; | X      | $1F6F
       .byte $49 ; | X  X  X| $1F70
       .byte $89 ; |X   X  X| $1F71
       .byte $89 ; |X   X  X| $1F72
       .byte $89 ; |X   X  X| $1F73
       .byte $89 ; |X   X  X| $1F74
       .byte $48 ; | X  X   | $1F75
       .byte $40 ; | X      | $1F76
       .byte $3F ; |  XXXXXX| $1F77

       .byte $FF ; |XXXXXXXX| $1F78
       .byte $00 ; |        | $1F79
       .byte $54 ; | X X X  | $1F7A
       .byte $54 ; | X X X  | $1F7B
       .byte $57 ; | X X XXX| $1F7C
       .byte $54 ; | X X X  | $1F7D
       .byte $54 ; | X X X  | $1F7E
       .byte $A3 ; |X X   XX| $1F7F
       .byte $00 ; |        | $1F80
       .byte $FF ; |XXXXXXXX| $1F81

       .byte $FF ; |XXXXXXXX| $1F82
       .byte $00 ; |        | $1F83
       .byte $99 ; |X  XX  X| $1F84
       .byte $A5 ; |X X  X X| $1F85
       .byte $AD ; |X X XX X| $1F86
       .byte $A1 ; |X X    X| $1F87
       .byte $A5 ; |X X  X X| $1F88
       .byte $19 ; |   XX  X| $1F89
       .byte $00 ; |        | $1F8A
       .byte $FF ; |XXXXXXXX| $1F8B

       .byte $FC ; |XXXXXX  | $1F8C
       .byte $02 ; |      X | $1F8D
       .byte $32 ; |  XX  X | $1F8E
       .byte $49 ; | X  X  X| $1F8F
       .byte $41 ; | X     X| $1F90
       .byte $41 ; | X     X| $1F91
       .byte $49 ; | X  X  X| $1F92
       .byte $32 ; |  XX  X | $1F93
       .byte $02 ; |      X | $1F94
       .byte $FC ; |XXXXXX  | $1F95




;enemy colors
L1FAE:
       .byte $C8 ; |XX  X   | $1FAE
       .byte $C8 ; |XX  X   | $1FAF
       .byte $88 ; |X   X   | $1FB0
       .byte $48 ; | X  X   | $1FB1
       .byte $38 ; |  XXX   | $1FB2
;       .byte $28 ; |  X X   | $1FB3
;       .byte $76 ; | XXX XX | $1FB4
;text color
L1AD0: ;slight color change to share text color w/ enemy table
       .byte $2A ; |  X XX  | $1AD0 shared
       .byte $78 ; | XXXX X | $1AD1 shared


       .byte $78 ; | XXXX   | $1FB5
       .byte $0C ; |    XX  | $1FB6
       .byte $0C ; |    XX  | $1FB7
       .byte $8A ; |X   X X | $1FB8
       .byte $7A ; | XXXX X | $1FB9
       .byte $6A ; | XX X X | $1FBA
       .byte $5A ; | X XX X | $1FBB
       .byte $4A ; | X  X X | $1FBC
       .byte $3A ; |  XXX X | $1FBD
       .byte $48 ; | X  X   | $1FBE
       .byte $48 ; | X  X   | $1FBF
       .byte $48 ; | X  X   | $1FC0
       .byte $78 ; | XXXX   | $1FC1
       .byte $88 ; |X   X   | $1FC2
       .byte $98 ; |X  XX   | $1FC3
       .byte $A8 ; |X X X   | $1FC4
       .byte $B8 ; |X XXX   | $1FC5
L1D88: ;12 bytes
       .byte $C6 ; |XX   XX | $1FC6 shared
       .byte $C6 ; |XX   XX | $1FC7 shared
       .byte $C6 ; |XX   XX | $1FC8 shared
       .byte $C6 ; |XX   XX | $1FC9 shared
       .byte $EE ; |XXX XXX | $1FCA shared
       .byte $EE ; |XXX XXX | $1FCB shared
       .byte $6C ; | XX XX  | $1FCC shared
       .byte $6C ; | XX XX  | $1FCD shared

;       .byte $46 ; | X   XX | $1FCE
;       .byte $46 ; | X   XX | $1FCF
;       .byte $46 ; | X   XX | $1FD0
;       .byte $46 ; | X   XX | $1FD1

;slight color change to share both tables
       .byte $28 ; |  X X   | $1D90 shared
       .byte $28 ; |  X X   | $1D91 shared
       .byte $28 ; |  X X   | $1D92 shared
       .byte $28 ; |  X X   | $1D93 shared

       .byte $3E ; |  XXXXX | $1FD2
       .byte $3E ; |  XXXXX | $1FD3
       .byte $9C ; |X  XXX  | $1FD4
       .byte $9C ; |X  XXX  | $1FD5
       .byte $86 ; |X    XX | $1FD6
       .byte $86 ; |X    XX | $1FD7
       .byte $48 ; | X  X   | $1FD8
       .byte $48 ; | X  X   | $1FD9
       .byte $E4 ; |XXX  X  | $1FDA
       .byte $E4 ; |XXX  X  | $1FDB
       .byte $28 ; |  X X   | $1FDC
       .byte $28 ; |  X X   | $1FDD
       .byte $38 ; |  XXX   | $1FDE
       .byte $38 ; |  XXX   | $1FDF
       .byte $48 ; | X  X   | $1FE0
       .byte $48 ; | X  X   | $1FE1
       .byte $68 ; | XX X   | $1FE2
       .byte $68 ; | XX X   | $1FE3
       .byte $78 ; | XXXX   | $1FE4
       .byte $78 ; | XXXX   | $1FE5

;42+4 free bytes...byline
       .byte "Demon Attack- hacked by Kurt (Nukey Shay) Howe"

       ORG $1FFC
       .word START,START
