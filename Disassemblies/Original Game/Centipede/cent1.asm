; Disassembly of centiped.001
; Disassembled Sun Mar 28 12:18:29 2004
; Using DiStella v2.0
;
; Command Line: C:\BIN\DISTELLA.EXE -pafsccent1.cfg centiped.001 
;
; cent1.cfg contents:
;
;      ORG D000
;      CODE D000 D091
;      GFX D092 D0B1
;      CODE D0B2 D9C3
;      GFX D9C4 D9ED
;      GFX D9EE DA81
;      GFX DA82 DDFF
;      GFX DE00 DE65
;      GFX DE66 DFF1
;      CODE DFF2 DFF7
;      GFX DFF8 DFFA

      processor 6502
VSYNC   =  $00
VBLANK  =  $01
WSYNC   =  $02
NUSIZ0  =  $04
NUSIZ1  =  $05
COLUP0  =  $06
COLUP1  =  $07
COLUPF  =  $08
CTRLPF  =  $0A
PF1     =  $0E
PF2     =  $0F
RESP0   =  $10
RESP1   =  $11
RESM0   =  $12
RESM1   =  $13
RESBL   =  $14
AUDC0   =  $15
AUDC1   =  $16
AUDF0   =  $17
AUDF1   =  $18
AUDV0   =  $19
AUDV1   =  $1A
GRP0    =  $1B
GRP1    =  $1C
ENAM0   =  $1D
ENAM1   =  $1E
ENABL   =  $1F
HMP0    =  $20
HMP1    =  $21
HMM0    =  $22
HMBL    =  $24
VDELP0  =  $25
VDEL01  =  $26
HMOVE   =  $2A
HMCLR   =  $2B
INPT4   =  $3C
SWCHB   =  $0282
INTIM   =  $0284
TIM64T  =  $0296

       ORG $D000

START:
       STA    $FFF9   ;4
LD003: STA    WSYNC   ;3
       LDX    $A8     ;3
       LDY    $80,X   ;4
       INY            ;2
       LDA    LDD00,Y ;4
       STA    HMM0    ;3
       AND    #$0F    ;2
       TAY            ;2
LD012: DEY            ;2
       BPL    LD012   ;2
       STA    RESM0   ;3
       STA    WSYNC   ;3
       LDY    $80,X   ;4
       LDA    LDD00,Y ;4
       STA    $0123   ;4
       AND    #$0F    ;2
       TAY            ;2
       LDX    #$AC    ;2
       TXS            ;2
LD027: DEY            ;2
       BPL    LD027   ;2
       STA    RESM1   ;3
       STA    WSYNC   ;3
       LDY    #$13    ;2
       STY    $D6     ;3
       NOP            ;2
       LDX    $EE     ;3
       LDA    LDD01,X ;4
       STA    HMBL    ;3
       AND    #$0F    ;2
       TAY            ;2
LD03D: DEY            ;2
       BPL    LD03D   ;2
       STA    RESBL   ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    $ED     ;3
       CLC            ;2
       ADC    #$03    ;2
       AND    #$07    ;2
       TAY            ;2
       LDA    LDFC9,Y ;4
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDA    #$00    ;2
       STA    $AB     ;3
       STA    ENABL   ;3
LD05B: LDX    INTIM   ;4
       BNE    LD05B   ;2
       STA    WSYNC   ;3
       STX    VBLANK  ;3
       STA    HMCLR   ;3
       LDY    #$13    ;2
LD068: LDA.wy $0094,Y ;4
       AND    #$1F    ;2
       TAX            ;2
       STX    $AA     ;3
       LDA    LDF89,X ;4
       STA    NUSIZ0  ;3
       LDA    LDFA9,X ;4
       STA    NUSIZ1  ;3
       LDA.wy $0080,Y ;4
       TAY            ;2
       LDA    LDD00,Y ;4
       STA    HMP0    ;3
       CLC            ;2
       ADC    #$10    ;2
       STA    HMP1    ;3
       AND    #$0F    ;2
       TAY            ;2
       CPX    #$1A    ;2
       BMI    LD0B5   ;2
       JMP    LD3A0   ;3
LD092: .byte $01 ; |       X| $D092
       .byte $01 ; |       X| $D093
       .byte $05 ; |     X X| $D094
       .byte $05 ; |     X X| $D095
       .byte $05 ; |     X X| $D096
       .byte $05 ; |     X X| $D097
       .byte $05 ; |     X X| $D098
       .byte $06 ; |     XX | $D099
       .byte $07 ; |     XXX| $D09A
       .byte $07 ; |     XXX| $D09B
       .byte $07 ; |     XXX| $D09C
       .byte $07 ; |     XXX| $D09D
       .byte $07 ; |     XXX| $D09E
       .byte $07 ; |     XXX| $D09F
       .byte $03 ; |      XX| $D0A0
       .byte $03 ; |      XX| $D0A1
       .byte $00 ; |        | $D0A2
       .byte $01 ; |       X| $D0A3
       .byte $02 ; |      X | $D0A4
       .byte $04 ; |     X  | $D0A5
       .byte $03 ; |      XX| $D0A6
       .byte $03 ; |      XX| $D0A7
       .byte $03 ; |      XX| $D0A8
       .byte $03 ; |      XX| $D0A9
       .byte $03 ; |      XX| $D0AA
       .byte $03 ; |      XX| $D0AB
       .byte $03 ; |      XX| $D0AC
       .byte $03 ; |      XX| $D0AD
       .byte $03 ; |      XX| $D0AE
       .byte $03 ; |      XX| $D0AF
       .byte $03 ; |      XX| $D0B0
       .byte $03 ; |      XX| $D0B1
LD0B2: JMP    LD23D   ;3
LD0B5: CPX    #$19    ;2
       BPL    LD0B2   ;2
       LDA    $AB     ;3
       STA    WSYNC   ;3
       STA    ENABL   ;3
       LDA    LD092,X ;4
       ADC    $ED     ;3
       AND    #$07    ;2
       TAX            ;2
       LDA    LDFC9,X ;4
       STA    COLUP0  ;3
LD0CC: DEY            ;2
       BPL    LD0CC   ;2
       STA    RESP0   ;3
       LDX    $EF     ;3
       STA    WSYNC   ;3
       BIT    $DA     ;3
       BVC    LD0EA   ;2
       LDA    #$3F    ;2
       STA    $DA     ;3
       LDA    LDD01,X ;4
       STA    HMBL    ;3
       AND    #$0F    ;2
       TAY            ;2
LD0E5: DEY            ;2
       BPL    LD0E5   ;2
       STA    RESBL   ;3
LD0EA: STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDX    $01AA   ;4
       LDY    #$05    ;2
       LDA    LDF70,X ;4
       STA    $D7     ;3
       LDA    #$DE    ;2
       STA    $D8     ;3
       LDA    ($D7),Y ;5
       STA    GRP0    ;3
       DEY            ;2
       LDX    $D6     ;3
       LDA    $94,X   ;4
       BPL    LD112   ;2
       LDA    $A9     ;3
       ASL            ;2
       ASL            ;2
       ORA    #$0F    ;2
       STA    COLUPF  ;3
       JMP    LD11D   ;3
LD112: LDA    $ED     ;3
       AND    #$07    ;2
       TAX            ;2
       LDA    LDFC9,X ;4
       STA    $0108   ;4
LD11D: LDX    $D9     ;3
       BMI    LD12B   ;2
       DEC    $01D9   ;6
       LDA    LDE8A,X ;4
       TAX            ;2
       JMP    LD135   ;3
LD12B: LDA    $DA     ;3
       STA    $D9     ;3
       LDX    #$61    ;2
       STX    CTRLPF  ;3
       STX    $DA     ;3
LD135: STX    ENABL   ;3
       LDA    ($D7),Y ;5
       STA    GRP0    ;3
       LDA    $D6     ;3
       BNE    LD149   ;2
       STA    $AA     ;3
       STA    $AB     ;3
       STA    $AC     ;3
       STA    $D5     ;3
       BEQ    LD17A   ;2
LD149: TSX            ;2
       TXA            ;2
       LSR            ;2
       LSR            ;2
       BCC    LD166   ;2
       PLA            ;4
       TAX            ;2
       AND    #$AA    ;2
       STA    $AA     ;3
       TXA            ;2
       AND    #$55    ;2
       STA    $AB     ;3
       PLA            ;4
       TAX            ;2
       AND    #$55    ;2
       STA    $AC     ;3
       TXA            ;2
       AND    #$AA    ;2
       JMP    LD17A   ;3
LD166: PLA            ;4
       TAX            ;2
       AND    #$55    ;2
       STA    $AA     ;3
       TXA            ;2
       AND    #$AA    ;2
       STA    $AB     ;3
       PLA            ;4
       TAX            ;2
       AND    #$AA    ;2
       STA    $AC     ;3
       TXA            ;2
       AND    #$55    ;2
LD17A: STA    $D5     ;3
       DEY            ;2
       STA    WSYNC   ;3
       LDA    ($D7),Y ;5
       STA    GRP0    ;3
       LDA    $AA     ;3
       STA    PF1     ;3
       LDA    $AB     ;3
       STA    PF2     ;3
       LDX    $01D6   ;4
       LDA    $94,X   ;4
       AND    #$E0    ;2
       ORA    #$16    ;2
       STA    $94,X   ;4
       LDA    #$00    ;2
       STA    $80,X   ;4
       LDA    $D5     ;3
       STA    PF2     ;3
       LDA    $AC     ;3
       STA    PF1     ;3
       DEY            ;2
       STA    WSYNC   ;3
       LDA    ($D7),Y ;5
       STA    GRP0    ;3
       LDA    $AA     ;3
       STA    PF1     ;3
       LDA    $AB     ;3
       STA    PF2     ;3
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       LDA    $01D5   ;4
       STA    PF2     ;3
       LDA    $AC     ;3
       STA    PF1     ;3
       DEY            ;2
       STA    WSYNC   ;3
       LDA    ($D7),Y ;5
       STA    GRP0    ;3
       LDA    $AA     ;3
       STA    PF1     ;3
       LDA    $AB     ;3
       STA    PF2     ;3
       LDX    $D9     ;3
       BMI    LD1DD   ;2
       DEC    $01D9   ;6
       LDA    LDE8A,X ;4
       TAX            ;2
       JMP    LD1E7   ;3
LD1DD: LDA    $DA     ;3
       STA    $D9     ;3
       LDX    #$61    ;2
       STX    CTRLPF  ;3
       STX    $DA     ;3
LD1E7: NOP            ;2
       LDA    $D5     ;3
       STA    PF2     ;3
       LDA    $AC     ;3
       STA    PF1     ;3
       DEY            ;2
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       STX    ENABL   ;3
       STA    WSYNC   ;3
       LDA    ($D7),Y ;5
       STA    GRP0    ;3
       LDA    #$00    ;2
       STA    PF1     ;3
       STA    PF2     ;3
       STA    HMBL    ;3
       NOP            ;2
       NOP            ;2
       NOP            ;2
LD208: LDX    $D9     ;3
       BMI    LD216   ;2
       DEC    $01D9   ;6
       LDA    LDE8A,X ;4
       TAX            ;2
       JMP    LD220   ;3
LD216: LDA    $DA     ;3
       STA    $D9     ;3
       LDX    #$61    ;2
       STX    CTRLPF  ;3
       STX    $DA     ;3
LD220: STX    $AB     ;3
       LDA    #$00    ;2
       STA    HMBL    ;3
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       DEC    $01D6   ;6
       STA    ENAM0   ;3
       STA    GRP1    ;3
       STA    GRP0    ;3
       LDY    $D6     ;3
       BMI    LD23A   ;2
       JMP    LD068   ;3
LD23A: JMP    LD53A   ;3
LD23D: LDA    $AB     ;3
       STA    ENABL   ;3
       LDA    $ED     ;3
       ADC    #$02    ;2
       AND    #$07    ;2
       TAX            ;2
       LDA    LDFC9,X ;4
       STA    COLUP0  ;3
       LDX    $EF     ;3
       NOP            ;2
LD250: DEY            ;2
       BPL    LD250   ;2
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    WSYNC   ;3
       BIT    $DA     ;3
       BVC    LD26E   ;2
       LDA    #$3F    ;2
       STA    $DA     ;3
       LDA    LDD01,X ;4
       STA    HMBL    ;3
       AND    #$0F    ;2
       TAY            ;2
LD269: DEY            ;2
       BPL    LD269   ;2
       STA    RESBL   ;3
LD26E: STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDY    #$05    ;2
       LDA    LDE72,Y ;4
       STA    GRP0    ;3
       LDA    LDE6C,Y ;4
       STA    GRP1    ;3
       DEY            ;2
       LDX    $D6     ;3
       LDA    $94,X   ;4
       BPL    LD290   ;2
       LDA    $A9     ;3
       ASL            ;2
       ASL            ;2
       ORA    #$0F    ;2
       STA    COLUPF  ;3
       JMP    LD29B   ;3
LD290: LDA    $ED     ;3
       AND    #$07    ;2
       TAX            ;2
       LDA    LDFC9,X ;4
       STA    $0108   ;4
LD29B: LDX    $D9     ;3
       BMI    LD2A9   ;2
       DEC    $01D9   ;6
       LDA    LDE8A,X ;4
       TAX            ;2
       JMP    LD2B3   ;3
LD2A9: LDA    $DA     ;3
       STA    $D9     ;3
       LDX    #$61    ;2
       STX    CTRLPF  ;3
       STX    $DA     ;3
LD2B3: STA    WSYNC   ;3
       STX    ENABL   ;3
       LDA    LDE72,Y ;4
       STA    GRP0    ;3
       LDA    LDE6C,Y ;4
       STA    GRP1    ;3
       LDA    $D6     ;3
       BEQ    LD2E2   ;2
       TSX            ;2
       TXA            ;2
       LSR            ;2
       LSR            ;2
       BCC    LD2ED   ;2
       PLA            ;4
       TAX            ;2
       AND    #$AA    ;2
       STA    $AA     ;3
       TXA            ;2
       AND    #$55    ;2
       STA    $AB     ;3
       PLA            ;4
       TAX            ;2
       AND    #$55    ;2
       STA    $AC     ;3
       TXA            ;2
       AND    #$AA    ;2
       JMP    LD301   ;3
LD2E2: STA    $AA     ;3
       STA    $AB     ;3
       STA    $AC     ;3
       STA    $D5     ;3
       JMP    LD301   ;3
LD2ED: PLA            ;4
       TAX            ;2
       AND    #$55    ;2
       STA    $AA     ;3
       TXA            ;2
       AND    #$AA    ;2
       STA    $AB     ;3
       PLA            ;4
       TAX            ;2
       AND    #$AA    ;2
       STA    $AC     ;3
       TXA            ;2
       AND    #$55    ;2
LD301: STA    $D5     ;3
       DEY            ;2
       STA    WSYNC   ;3
       LDA    LDE72,Y ;4
       STA    GRP0    ;3
       LDA    LDE6C,Y ;4
       STA    GRP1    ;3
       LDA    $AA     ;3
       STA    PF1     ;3
       LDA    $AB     ;3
       STA    PF2     ;3
       LDX    $D6     ;3
       LDA    #$00    ;2
       STA    $80,X   ;4
       PLA            ;4
       PHA            ;3
       LDA    $D5     ;3
       STA    PF2     ;3
       LDA    $AC     ;3
       STA    PF1     ;3
       DEY            ;2
       STA    WSYNC   ;3
       LDA    LDE72,Y ;4
       STA    GRP0    ;3
       LDA    LDE6C,Y ;4
       STA    GRP1    ;3
       LDA    $AA     ;3
       STA    PF1     ;3
       LDA    $AB     ;3
       STA    PF2     ;3
       LDA    $94,X   ;4
       AND    #$E0    ;2
       ORA    #$16    ;2
       STA    $94,X   ;4
       NOP            ;2
       NOP            ;2
       LDA    $D5     ;3
       STA    PF2     ;3
       LDA    $AC     ;3
       STA    PF1     ;3
       DEY            ;2
       LDA    LDE72,Y ;4
       STA    WSYNC   ;3
       STA    GRP0    ;3
       LDA    LDE6C,Y ;4
       STA    GRP1    ;3
       LDA    $AA     ;3
       STA    PF1     ;3
       LDA    $AB     ;3
       STA    PF2     ;3
       LDX    $D9     ;3
       BMI    LD372   ;2
       DEC    $01D9   ;6
       LDA    LDE8A,X ;4
       TAX            ;2
       JMP    LD37C   ;3
LD372: LDA    $DA     ;3
       STA    $D9     ;3
       LDX    #$61    ;2
       STX    CTRLPF  ;3
       STX    $DA     ;3
LD37C: LDA    $D5     ;3
       STA    PF2     ;3
       LDA    $AC     ;3
       STA    PF1     ;3
       DEY            ;2
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       STX    ENABL   ;3
       STA    WSYNC   ;3
       LDA    LDE72,Y ;4
       STA    GRP0    ;3
       LDA    LDE6C,Y ;4
       STA    GRP1    ;3
       LDA    #$00    ;2
       STA    PF1     ;3
       STA    PF2     ;3
       JMP    LD208   ;3
LD3A0: LDA    $AB     ;3
       NOP            ;2
       STA    $011F   ;4
       STA    WSYNC   ;3
       LDA    $ED     ;3
       ADC    #$02    ;2
       AND    #$07    ;2
       TAX            ;2
       LDA    LDFC9,X ;4
       STA    COLUP0  ;3
       LDX    $EF     ;3
       NOP            ;2
LD3B7: DEY            ;2
       BPL    LD3B7   ;2
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    WSYNC   ;3
       BIT    $DA     ;3
       BVC    LD3D5   ;2
       LDA    #$3F    ;2
       STA    $DA     ;3
       LDA    LDD01,X ;4
       STA    HMBL    ;3
       AND    #$0F    ;2
       TAY            ;2
LD3D0: DEY            ;2
       BPL    LD3D0   ;2
       STA    RESBL   ;3
LD3D5: LDX    #$00    ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDY    $D6     ;3
       CPY    $A8     ;3
       BNE    LD3E3   ;2
       LDX    #$02    ;2
LD3E3: LDA    LDE77   ;4
       STA    GRP0    ;3
       STX    ENAM0   ;3
       STA    GRP1    ;3
       LDY    $D6     ;3
       LDA.wy $0094,Y ;4
       BPL    LD3FE   ;2
       LDA    $A9     ;3
       ASL            ;2
       ASL            ;2
       ORA    #$0F    ;2
       STA    COLUPF  ;3
       JMP    LD408   ;3
LD3FE: LDA    $ED     ;3
       AND    #$07    ;2
       TAY            ;2
       LDA    LDFC9,Y ;4
       STA    COLUPF  ;3
LD408: LDY    $D9     ;3
       BMI    LD416   ;2
       DEC    $01D9   ;6
       LDA    LDE8A,Y ;4
       TAY            ;2
       JMP    LD420   ;3
LD416: LDA    $DA     ;3
       STA    $D9     ;3
       LDY    #$61    ;2
       STY    CTRLPF  ;3
       STY    $DA     ;3
LD420: STA    WSYNC   ;3
       STY    ENABL   ;3
       STX    ENAM1   ;3
       LDA    LDE76   ;4
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    $D6     ;3
       BNE    LD43B   ;2
       STA    $AA     ;3
       STA    $AB     ;3
       STA    $AC     ;3
       STA    $D5     ;3
       BEQ    LD46C   ;2
LD43B: TSX            ;2
       TXA            ;2
       LSR            ;2
       LSR            ;2
       BCC    LD458   ;2
       PLA            ;4
       TAX            ;2
       AND    #$AA    ;2
       STA    $AA     ;3
       TXA            ;2
       AND    #$55    ;2
       STA    $AB     ;3
       PLA            ;4
       TAX            ;2
       AND    #$55    ;2
       STA    $AC     ;3
       TXA            ;2
       AND    #$AA    ;2
       JMP    LD46C   ;3
LD458: PLA            ;4
       TAX            ;2
       AND    #$55    ;2
       STA    $AA     ;3
       TXA            ;2
       AND    #$AA    ;2
       STA    $AB     ;3
       PLA            ;4
       TAX            ;2
       AND    #$AA    ;2
       STA    $AC     ;3
       TXA            ;2
       AND    #$55    ;2
LD46C: STA    $D5     ;3
       LDY    #$03    ;2
       STA    WSYNC   ;3
       LDA    LDE72,Y ;4
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    $AA     ;3
       STA    PF1     ;3
       LDA    $AB     ;3
       STA    PF2     ;3
       LDX    $01D6   ;4
       LDA    $94,X   ;4
       AND    #$E0    ;2
       ORA    #$16    ;2
       STA    $94,X   ;4
       NOP            ;2
       NOP            ;2
       LDA    $D5     ;3
       STA    PF2     ;3
       LDA    $AC     ;3
       STA    PF1     ;3
       DEY            ;2
       STA    WSYNC   ;3
       LDA    LDE72,Y ;4
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    $AA     ;3
       STA    PF1     ;3
       LDA    $AB     ;3
       STA    PF2     ;3
       LDA    #$00    ;2
       STA    $80,X   ;4
       TSX            ;2
       NOP            ;2
       PLA            ;4
       PLA            ;4
       TXS            ;2
       LDA    $D5     ;3
       STA    PF2     ;3
       LDA    $AC     ;3
       STA    PF1     ;3
       DEY            ;2
       STA    WSYNC   ;3
       LDA    LDE72,Y ;4
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    $AA     ;3
       STA    PF1     ;3
       LDA    $AB     ;3
       STA    PF2     ;3
       LDX    $D9     ;3
       BMI    LD4D9   ;2
       DEC    $01D9   ;6
       LDA    LDE8A,X ;4
       TAX            ;2
       JMP    LD4E3   ;3
LD4D9: LDA    $DA     ;3
       STA    $D9     ;3
       LDX    #$61    ;2
       STX    CTRLPF  ;3
       STX    $DA     ;3
LD4E3: LDA    $D5     ;3
       STA    PF2     ;3
       LDA    $AC     ;3
       STA    PF1     ;3
       DEY            ;2
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       STX    ENABL   ;3
       STA    WSYNC   ;3
       LDY    #$00    ;2
       STY    ENAM1   ;3
       STY    PF1     ;3
       STY    PF2     ;3
       LDA    LDE72,Y ;4
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDX    $D9     ;3
       BMI    LD511   ;2
       DEC    $01D9   ;6
       LDA    LDE8A,X ;4
       TAX            ;2
       JMP    LD51B   ;3
LD511: LDA    $DA     ;3
       STA    $D9     ;3
       LDX    #$61    ;2
       STX    CTRLPF  ;3
       STX    $DA     ;3
LD51B: STX    $AB     ;3
       PLA            ;4
       PHA            ;3
       LDA    #$00    ;2
       STA    HMBL    ;3
       NOP            ;2
       NOP            ;2
       NOP            ;2
       DEC    $D6     ;5
       STA    ENAM0   ;3
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDY    $D6     ;3
       BMI    LD53A   ;2
       JMP    LD068   ;3
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
LD53A: STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    #$DF    ;2
       STA    $81     ;3
       STA    $83     ;3
       STA    $85     ;3
       STA    $87     ;3
       STA    $89     ;3
       STA    $8B     ;3
       LDY    #$0A    ;2
       STY    $8D     ;3
       BIT    $A7     ;3
       BVC    LD558   ;2
       LDA    #$0B    ;2
       BVS    LD562   ;2
LD558: LDA    $F4     ;3
       LSR            ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       BNE    LD562   ;2
       LDA    #$0A    ;2
LD562: STA    $8D     ;3
       TAY            ;2
       LDA    LDF10,Y ;4
       STA    $80     ;3
       LDA    $ED     ;3
       CLC            ;2
       ADC    #$06    ;2
       AND    #$07    ;2
       TAY            ;2
       LDA    LDFC9,Y ;4
       AND    #$F0    ;2
       ORA    #$07    ;2
       STA    COLUPF  ;3
       LDA    #$FF    ;2
       STA    PF1     ;3
       STA    PF2     ;3
       LDA    $F4     ;3
       AND    #$0F    ;2
       BNE    LD591   ;2
       LDA    #$0A    ;2
       CMP    $8D     ;3
       BMI    LD591   ;2
       BEQ    LD591   ;2
       LDA    #$00    ;2
LD591: STA    $8D     ;3
       TAY            ;2
       LDA    LDF10,Y ;4
       STA    $82     ;3
       LDA    $F5     ;3
       LSR            ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       BNE    LD5A9   ;2
       LDA    #$0A    ;2
       CMP    $8D     ;3
       BEQ    LD5A9   ;2
       LDA    #$00    ;2
LD5A9: STA    $8D     ;3
       TAY            ;2
       LDA    LDF10,Y ;4
       STA    $84     ;3
       LDA    $F5     ;3
       AND    #$0F    ;2
       BNE    LD5BF   ;2
       LDA    #$0A    ;2
       CMP    $8D     ;3
       BEQ    LD5BF   ;2
       LDA    #$00    ;2
LD5BF: STA    $8D     ;3
       TAY            ;2
       LDA    LDF10,Y ;4
       STA    $86     ;3
       LDA    $F6     ;3
       LSR            ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       JMP    LD5D7   ;3
       NOP            ;2
       CMP    $8D     ;3
       BEQ    LD5D7   ;2
       LDA    #$00    ;2
LD5D7: TAY            ;2
       LDA    LDF10,Y ;4
       STA    $88     ;3
       LDA    $F6     ;3
       AND    #$0F    ;2
       STA    WSYNC   ;3
       TAY            ;2
       LDA    LDF10,Y ;4
       STA    $8A     ;3
       LDX    #$00    ;2
       STX    COLUPF  ;3
       LDA    $ED     ;3
       LSR            ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       TAY            ;2
       LDA    LDF00,Y ;4
       STA    PF1     ;3
       LDA    LDF08,Y ;4
       STA    PF2     ;3
       STX    HMP1    ;3
       INX            ;2
       STX    VDELP0  ;3
       LDA    #$03    ;2
       STA    RESP0   ;3
       STA    RESP1   ;3
       STX    VDEL01  ;3
       STA    NUSIZ0  ;3
       STA    NUSIZ1  ;3
       LDA    #$F0    ;2
       STA    HMP0    ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       BIT    $A6     ;3
       BVC    LD620   ;2
       LDA    $A9     ;3
       JMP    LD624   ;3
LD620: LDA    #$7F    ;2
       STA    COLUP0  ;3
LD624: STA    COLUP0  ;3
       STA    $0107   ;4
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       LDA    $AA     ;3
       LDA    #$7F    ;2
       STA    COLUPF  ;3
       STA    WSYNC   ;3
       LDY    #$06    ;2
       LDA    ($80),Y ;5
       STA    GRP0    ;3
       LDA    ($82),Y ;5
       STA    GRP1    ;3
       LDA    ($84),Y ;5
       STA    GRP0    ;3
       LDA    ($86),Y ;5
       STA    $8C     ;3
       LDA    ($88),Y ;5
       TAX            ;2
       LDA    ($8A),Y ;5
       TAY            ;2
       LDA    #$00    ;2
       STA    COLUPF  ;3
       LDA    $8C     ;3
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       LDA    #$7F    ;2
       STA    COLUPF  ;3
       STA    WSYNC   ;3
       LDY    #$05    ;2
       LDA    ($80),Y ;5
       STA    GRP0    ;3
       LDA    ($82),Y ;5
       STA    GRP1    ;3
       LDA    ($84),Y ;5
       STA    GRP0    ;3
       LDA    ($86),Y ;5
       STA    $8C     ;3
       LDA    ($88),Y ;5
       TAX            ;2
       LDA    ($8A),Y ;5
       TAY            ;2
       LDA    #$00    ;2
       STA    COLUPF  ;3
       LDA    $8C     ;3
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       LDA    #$7F    ;2
       STA    COLUPF  ;3
       STA    WSYNC   ;3
       LDY    #$04    ;2
       LDA    ($80),Y ;5
       STA    GRP0    ;3
       LDA    ($82),Y ;5
       STA    GRP1    ;3
       LDA    ($84),Y ;5
       STA    GRP0    ;3
       LDA    ($86),Y ;5
       STA    $8C     ;3
       LDA    ($88),Y ;5
       TAX            ;2
       LDA    ($8A),Y ;5
       TAY            ;2
       LDA    #$00    ;2
       STA    COLUPF  ;3
       LDA    $8C     ;3
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       LDA    #$7F    ;2
       STA    COLUPF  ;3
       STA    WSYNC   ;3
       LDY    #$03    ;2
       LDA    ($80),Y ;5
       STA    GRP0    ;3
       LDA    ($82),Y ;5
       STA    GRP1    ;3
       LDA    ($84),Y ;5
       STA    GRP0    ;3
       LDA    ($86),Y ;5
       STA    $8C     ;3
       LDA    ($88),Y ;5
       TAX            ;2
       LDA    ($8A),Y ;5
       TAY            ;2
       LDA    #$00    ;2
       STA    COLUPF  ;3
       LDA    $8C     ;3
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       LDA    #$7F    ;2
       STA    COLUPF  ;3
       STA    WSYNC   ;3
       LDY    #$02    ;2
       LDA    ($80),Y ;5
       STA    GRP0    ;3
       LDA    ($82),Y ;5
       STA    GRP1    ;3
       LDA    ($84),Y ;5
       STA    GRP0    ;3
       LDA    ($86),Y ;5
       STA    $8C     ;3
       LDA    ($88),Y ;5
       TAX            ;2
       LDA    ($8A),Y ;5
       TAY            ;2
       LDA    #$00    ;2
       STA    COLUPF  ;3
       LDA    $8C     ;3
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       LDA    #$7F    ;2
       STA    COLUPF  ;3
       STA    WSYNC   ;3
       LDY    #$01    ;2
       LDA    ($80),Y ;5
       STA    GRP0    ;3
       LDA    ($82),Y ;5
       STA    GRP1    ;3
       LDA    ($84),Y ;5
       STA    GRP0    ;3
       LDA    ($86),Y ;5
       STA    $8C     ;3
       LDA    ($88),Y ;5
       TAX            ;2
       LDA    ($8A),Y ;5
       TAY            ;2
       LDA    #$00    ;2
       STA    COLUPF  ;3
       LDA    $8C     ;3
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       LDA    #$7F    ;2
       STA    COLUPF  ;3
       STA    WSYNC   ;3
       LDY    #$00    ;2
       LDA    ($80),Y ;5
       STA    GRP0    ;3
       LDA    ($82),Y ;5
       STA    GRP1    ;3
       LDA    ($84),Y ;5
       STA    GRP0    ;3
       LDA    ($86),Y ;5
       STA    $8C     ;3
       LDA    ($88),Y ;5
       TAX            ;2
       LDA    ($8A),Y ;5
       TAY            ;2
       LDA    #$00    ;2
       STA    COLUPF  ;3
       LDA    $8C     ;3
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       LDA    #$00    ;2
       STA    VDELP0  ;3
       STA    VDEL01  ;3
       STA    GRP0    ;3
       STA    GRP1    ;3
       STA    PF1     ;3
       STA    PF2     ;3
       STA    WSYNC   ;3
       JMP    LDFF2   ;3
       LDA    #$00    ;2
       STA    $80     ;3
       STA    $85     ;3
       STA    $8A     ;3
       STA    $A9     ;3
       STA    $8E     ;3
       LDX    $F4     ;3
       CPX    #$E0    ;2
       BNE    LD79C   ;2
       STA    $F4     ;3
LD79C: LDA    #$10    ;2
       STA    $86     ;3
       STA    $89     ;3
       LDA    #$20    ;2
       STA    $87     ;3
       STA    $88     ;3
       LDA    #$E0    ;2
       STA    $82     ;3
       STA    $83     ;3
       LDA    #$F0    ;2
       STA    $81     ;3
       STA    $84     ;3
       LDA    #$9A    ;2
       STA    COLUP1  ;3
LD7B8: LDA    #$00    ;2
LD7BA: LDX    INTIM   ;4
       BNE    LD7BA   ;2
       STA    WSYNC   ;3
       STX    VBLANK  ;3
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       STA    $012B   ;4
       LDA    LDA7D   ;4
       STA    COLUP0  ;3
       STA    RESP1   ;3
       LDA    $A9     ;3
       AND    #$07    ;2
       NOP            ;2
       STA    RESP0   ;3
       STA    WSYNC   ;3
       BEQ    LD7E4   ;2
       STA    WSYNC   ;3
       STA    WSYNC   ;3
       BNE    LD7F5   ;2
LD7E4: LDX    $80     ;3
       LDY    #$00    ;2
LD7E8: LDA.wy $0081,Y ;4
       STA.wy $0080,Y ;5
       INY            ;2
       CPY    #$0A    ;2
       BNE    LD7E8   ;2
       STX    $8A     ;3
LD7F5: STX    WSYNC   ;3
       LDX    #$09    ;2
       STX    $8B     ;3
       DEX            ;2
       LDY    #$59    ;2
       LDA    $89     ;3
       STA    HMP0    ;3
       JMP    LD805   ;3
LD805: STA    WSYNC   ;3
       STA    HMOVE   ;3
LD809: LDA    LDA00,Y ;4
       STA    GRP0    ;3
       LDA    LDA5A,X ;4
       STA    GRP1    ;3
       DEY            ;2
       BMI    LD852   ;2
       DEX            ;2
       BMI    LD834   ;2
       STX    $8C     ;3
       LDX    $8B     ;3
       LDA    LDA6C,X ;4
       STA    $8D     ;3
       LDX    $8C     ;3
       LDA    LDA63,X ;4
       LDX    $8D     ;3
       STA    COLUP1  ;3
       STX    NUSIZ1  ;3
       LDX    $8C     ;3
       STA    WSYNC   ;3
       JMP    LD809   ;3
LD834: LDA    $8B     ;3
       STA    RESP1   ;3
       TAX            ;2
       LSR            ;2
       LDA    $80,X   ;4
       STA    HMP0    ;3
LD83E: LDA    LD83E,X ;4
       STA    HMP1    ;3
       BCC    LD847   ;2
       STA    RESP1   ;3
LD847: LDA    LDA76,X ;4
       STA    COLUP0  ;3
       DEC    $8B     ;5
       LDX    #$08    ;2
       BNE    LD805   ;2
LD852: STA    WSYNC   ;3
       LDA    #$00    ;2
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    #$90    ;2
       STA    HMP0    ;3
       LDA    #$A0    ;2
       STA    HMP1    ;3
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       NOP            ;2
       NOP            ;2
       STA    RESP0   ;3
       STA    RESP1   ;3
       LDX    #$0F    ;2
LD86E: STA    WSYNC   ;3
       DEX            ;2
       BPL    LD86E   ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    #$03    ;2
       STA    NUSIZ0  ;3
       STA    NUSIZ1  ;3
       LDA    #$01    ;2
       STA    VDELP0  ;3
       STA    VDEL01  ;3
       LDY    #$31    ;2
       STY    $8D     ;3
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       PLA            ;4
       PHA            ;3
       NOP            ;2
       LDY    $8D     ;3
LD894: LDY    $8D     ;3
       LDA    LDA99,Y ;4
       STA    $011B   ;4
       LDA    LDB19,Y ;4
       STA    GRP1    ;3
       LDA    LDB65,Y ;4
       STA    GRP0    ;3
       LDA    LDC19,Y ;4
       STA    $8C     ;3
       TYA            ;2
       ASL            ;2
       ADC    $A9     ;3
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDA    LDC65,Y ;4
       LDX    LDBB0,Y ;4
       LDY    $8C     ;3
       STX    GRP1    ;3
       STY    GRP0    ;3
       STA    GRP1    ;3
       STA    GRP0    ;3
       DEC    $8D     ;5
       BPL    LD894   ;2
       LDA    #$10    ;2
       STA    HMP0    ;3
       STA    HMP1    ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    #$00    ;2
       STA    GRP0    ;3
       STA    GRP1    ;3
       STA    GRP0    ;3
       STA    WSYNC   ;3
       STA    WSYNC   ;3
       STA    WSYNC   ;3
       STA    WSYNC   ;3
       LDA    #$18    ;2
       STA    $8D     ;3
LD8E5: LDY    $8D     ;3
       LDA    LDA80,Y ;4
       STA    GRP0    ;3
       STA    WSYNC   ;3
       LDA    LDB00,Y ;4
       STA    GRP1    ;3
       LDA    LDB4C,Y ;4
       STA    GRP0    ;3
       LDA    LDC00,Y ;4
       STA    $8C     ;3
       TYA            ;2
       LDA    #$7F    ;2
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDA    LDC4C,Y ;4
       LDX    LDB97,Y ;4
       LDY    $8C     ;3
       STX    GRP1    ;3
       STY    GRP0    ;3
       STA    GRP1    ;3
       STA    GRP0    ;3
       DEC    $8D     ;5
       BPL    LD8E5   ;2
       LDX    #$00    ;2
       STX    NUSIZ0  ;3
       STX    NUSIZ1  ;3
       STX    GRP0    ;3
       STX    GRP1    ;3
       STX    GRP0    ;3
       STX    VDELP0  ;3
       STX    VDEL01  ;3
       STA    WSYNC   ;3
       BIT    INPT4   ;3
       BPL    LD94D   ;2
       LDA    SWCHB   ;4
       LSR            ;2
       BCC    LD94D   ;2
       LSR            ;2
       LDA    $FF     ;3
       BNE    LD93B   ;2
       BCC    LD94D   ;2
LD93B: INC    $A9     ;5
       BNE    LD950   ;2
       LDA    $FF     ;3
       BEQ    LD945   ;2
       DEC    $FF     ;5
LD945: INC    $8E     ;5
       LDA    $8E     ;3
       CMP    #$02    ;2
       BNE    LD950   ;2
LD94D: JMP    LDFEC   ;3
LD950: LDA    #$21    ;2
       STA    TIM64T  ;4
LD955: LDA    INTIM   ;4
       BNE    LD955   ;2
       LDX    #$02    ;2
       STX    WSYNC   ;3
       STX    VSYNC   ;3
       STX    WSYNC   ;3
       STX    WSYNC   ;3
       STX    WSYNC   ;3
       STX    WSYNC   ;3
       LDX    #$00    ;2
       STX    VSYNC   ;3
       LDX    #$2B    ;2
       STX    TIM64T  ;4
       JMP    LD7B8   ;3
LD974: BIT    $A5     ;3
       BVS    LD98C   ;2
       LDA    $A9     ;3
       AND    #$7F    ;2
       CMP    #$0F    ;2
       BNE    LD9BD   ;2
       LDA    $A5     ;3
       AND    #$20    ;2
       BEQ    LD9BD   ;2
       LDA    $A5     ;3
       ORA    #$40    ;2
       STA    $A5     ;3
LD98C: LDA    $A9     ;3
       AND    #$7F    ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       TAY            ;2
       LDA    #$0D    ;2
       CPY    #$0A    ;2
       BMI    LD99C   ;2
       LDA    #$04    ;2
LD99C: STA    AUDC0   ;3
       LDA    LD9C4,Y ;4
       STA    AUDF0   ;3
       LDA    #$0F    ;2
       STA    AUDV0   ;3
       LDA    #$00    ;2
       STA    AUDC1   ;3
       STA    AUDV1   ;3
       STA    AUDF1   ;3
       LDA    $A9     ;3
       AND    #$7F    ;2
       CMP    #$7F    ;2
       BNE    LD9BD   ;2
       LDA    $A5     ;3
       AND    #$9F    ;2
       STA    $A5     ;3
LD9BD: LDA    #$01    ;2
       STA    CTRLPF  ;3
       JMP    LD003   ;3
LD9C4: .byte $00 ; |        | $D9C4
       .byte $00 ; |        | $D9C5
       .byte $18 ; |   XX   | $D9C6
       .byte $13 ; |   X  XX| $D9C7
       .byte $10 ; |   X    | $D9C8
       .byte $10 ; |   X    | $D9C9
       .byte $13 ; |   X  XX| $D9CA
       .byte $10 ; |   X    | $D9CB
       .byte $10 ; |   X    | $D9CC
       .byte $10 ; |   X    | $D9CD
       .byte $18 ; |   XX   | $D9CE
       .byte $18 ; |   XX   | $D9CF
       .byte $1D ; |   XXX X| $D9D0
       .byte $18 ; |   XX   | $D9D1
       .byte $18 ; |   XX   | $D9D2
       .byte $18 ; |   XX   | $D9D3
       .byte $00 ; |        | $D9D4
       .byte $00 ; |        | $D9D5
       .byte $00 ; |        | $D9D6
       .byte $00 ; |        | $D9D7
       .byte $00 ; |        | $D9D8
       .byte $00 ; |        | $D9D9
       .byte $00 ; |        | $D9DA
       .byte $00 ; |        | $D9DB
       .byte $00 ; |        | $D9DC
       .byte $00 ; |        | $D9DD
       .byte $00 ; |        | $D9DE
       .byte $00 ; |        | $D9DF
       .byte $00 ; |        | $D9E0
       .byte $00 ; |        | $D9E1
       .byte $00 ; |        | $D9E2
       .byte $00 ; |        | $D9E3
       .byte $00 ; |        | $D9E4
       .byte $00 ; |        | $D9E5
       .byte $00 ; |        | $D9E6
       .byte $00 ; |        | $D9E7
       .byte $00 ; |        | $D9E8
       .byte $00 ; |        | $D9E9
       .byte $00 ; |        | $D9EA
       .byte $00 ; |        | $D9EB
       .byte $00 ; |        | $D9EC
       .byte $00 ; |        | $D9ED
       .byte $A5 ; |X X  X X| $D9EE
       .byte $85 ; |X    X X| $D9EF
       .byte $29 ; |  X X  X| $D9F0
       .byte $07 ; |     XXX| $D9F1
       .byte $AA ; |X X X X | $D9F2
       .byte $E6 ; |XXX  XX | $D9F3
       .byte $85 ; |X    X X| $D9F4
       .byte $B1 ; |X XX   X| $D9F5
       .byte $82 ; |X     X | $D9F6
       .byte $4C ; | X  XX  | $D9F7
       .byte $0E ; |    XXX | $D9F8
       .byte $FA ; |XXXXX X | $D9F9
       .byte $85 ; |X    X X| $D9FA
       .byte $02 ; |      X | $D9FB
       .byte $B1 ; |X XX   X| $D9FC
       .byte $80 ; |X       | $D9FD
       .byte $85 ; |X    X X| $D9FE
       .byte $1B ; |   XX XX| $D9FF
LDA00: .byte $3C ; |  XXXX  | $DA00
       .byte $42 ; | X    X | $DA01
       .byte $4E ; | X  XXX | $DA02
       .byte $CF ; |XX  XXXX| $DA03
       .byte $C3 ; |XX    XX| $DA04
       .byte $CF ; |XX  XXXX| $DA05
       .byte $4E ; | X  XXX | $DA06
       .byte $42 ; | X    X | $DA07
       .byte $3C ; |  XXXX  | $DA08
       .byte $3C ; |  XXXX  | $DA09
       .byte $46 ; | X   XX | $DA0A
       .byte $52 ; | X X  X | $DA0B
       .byte $D3 ; |XX X  XX| $DA0C
       .byte $D3 ; |XX X  XX| $DA0D
       .byte $D3 ; |XX X  XX| $DA0E
       .byte $46 ; | X   XX | $DA0F
       .byte $7E ; | XXXXXX | $DA10
       .byte $3C ; |  XXXX  | $DA11
       .byte $3C ; |  XXXX  | $DA12
       .byte $42 ; | X    X | $DA13
       .byte $4E ; | X  XXX | $DA14
       .byte $CF ; |XX  XXXX| $DA15
       .byte $C3 ; |XX    XX| $DA16
       .byte $CF ; |XX  XXXX| $DA17
       .byte $4E ; | X  XXX | $DA18
       .byte $42 ; | X    X | $DA19
       .byte $3C ; |  XXXX  | $DA1A
       .byte $3C ; |  XXXX  | $DA1B
       .byte $4E ; | X  XXX | $DA1C
       .byte $4E ; | X  XXX | $DA1D
       .byte $C3 ; |XX    XX| $DA1E
       .byte $C9 ; |XX  X  X| $DA1F
       .byte $C9 ; |XX  X  X| $DA20
       .byte $42 ; | X    X | $DA21
       .byte $7E ; | XXXXXX | $DA22
       .byte $3C ; |  XXXX  | $DA23
       .byte $3C ; |  XXXX  | $DA24
       .byte $42 ; | X    X | $DA25
       .byte $66 ; | XX  XX | $DA26
       .byte $E7 ; |XXX  XXX| $DA27
       .byte $E7 ; |XXX  XXX| $DA28
       .byte $E7 ; |XXX  XXX| $DA29
       .byte $42 ; | X    X | $DA2A
       .byte $7E ; | XXXXXX | $DA2B
       .byte $3C ; |  XXXX  | $DA2C
       .byte $3C ; |  XXXX  | $DA2D
       .byte $66 ; | XX  XX | $DA2E
       .byte $66 ; | XX  XX | $DA2F
       .byte $E7 ; |XXX  XXX| $DA30
       .byte $E7 ; |XXX  XXX| $DA31
       .byte $C3 ; |XX    XX| $DA32
       .byte $42 ; | X    X | $DA33
       .byte $7E ; | XXXXXX | $DA34
       .byte $3C ; |  XXXX  | $DA35
       .byte $3C ; |  XXXX  | $DA36
       .byte $5A ; | X XX X | $DA37
       .byte $5A ; | X XX X | $DA38
       .byte $D3 ; |XX X  XX| $DA39
       .byte $C3 ; |XX    XX| $DA3A
       .byte $CB ; |XX  X XX| $DA3B
       .byte $5A ; | X XX X | $DA3C
       .byte $5A ; | X XX X | $DA3D
       .byte $3C ; |  XXXX  | $DA3E
       .byte $3C ; |  XXXX  | $DA3F
       .byte $42 ; | X    X | $DA40
       .byte $4E ; | X  XXX | $DA41
       .byte $CF ; |XX  XXXX| $DA42
       .byte $C3 ; |XX    XX| $DA43
       .byte $CF ; |XX  XXXX| $DA44
       .byte $4E ; | X  XXX | $DA45
       .byte $42 ; | X    X | $DA46
       .byte $3C ; |  XXXX  | $DA47
       .byte $3C ; |  XXXX  | $DA48
       .byte $62 ; | XX   X | $DA49
       .byte $4E ; | X  XXX | $DA4A
       .byte $CF ; |XX  XXXX| $DA4B
       .byte $CF ; |XX  XXXX| $DA4C
       .byte $CF ; |XX  XXXX| $DA4D
       .byte $4E ; | X  XXX | $DA4E
       .byte $62 ; | XX   X | $DA4F
       .byte $3C ; |  XXXX  | $DA50
       .byte $3C ; |  XXXX  | $DA51
       .byte $7E ; | XXXXXX | $DA52
       .byte $7E ; | XXXXXX | $DA53
       .byte $FF ; |XXXXXXXX| $DA54
       .byte $DB ; |XX XX XX| $DA55
       .byte $5A ; | X XX X | $DA56
       .byte $7E ; | XXXXXX | $DA57
       .byte $99 ; |X  XX  X| $DA58
       .byte $81 ; |X      X| $DA59
LDA5A: .byte $00 ; |        | $DA5A
       .byte $18 ; |   XX   | $DA5B
       .byte $18 ; |   XX   | $DA5C
       .byte $7E ; | XXXXXX | $DA5D
       .byte $7E ; | XXXXXX | $DA5E
       .byte $7A ; | XXXX X | $DA5F
       .byte $76 ; | XXX XX | $DA60
       .byte $3C ; |  XXXX  | $DA61
       .byte $00 ; |        | $DA62
LDA63: .byte $56 ; | X X XX | $DA63
       .byte $56 ; | X X XX | $DA64
       .byte $52 ; | X X  X | $DA65
       .byte $56 ; | X X XX | $DA66
       .byte $56 ; | X X XX | $DA67
       .byte $58 ; | X XX   | $DA68
       .byte $58 ; | X XX   | $DA69
       .byte $5A ; | X XX X | $DA6A
       .byte $5A ; | X XX X | $DA6B
LDA6C: .byte $04 ; |     X  | $DA6C
       .byte $04 ; |     X  | $DA6D
       .byte $06 ; |     XX | $DA6E
       .byte $03 ; |      XX| $DA6F
       .byte $04 ; |     X  | $DA70
       .byte $00 ; |        | $DA71
       .byte $04 ; |     X  | $DA72
       .byte $06 ; |     XX | $DA73
       .byte $06 ; |     XX | $DA74
       .byte $04 ; |     X  | $DA75
LDA76: .byte $7F ; | XXXXXXX| $DA76
       .byte $CA ; |XX  X X | $DA77
       .byte $1A ; |   XX X | $DA78
       .byte $58 ; | X XX   | $DA79
       .byte $46 ; | X   XX | $DA7A
       .byte $78 ; | XXXX   | $DA7B
       .byte $D8 ; |XX XX   | $DA7C
LDA7D: .byte $9C ; |X  XXX  | $DA7D
       .byte $3A ; |  XXX X | $DA7E
       .byte $4C ; | X  XX  | $DA7F
LDA80: .byte $00 ; |        | $DA80
       .byte $00 ; |        | $DA81
       .byte $77 ; | XXX XXX| $DA82
       .byte $45 ; | X   X X| $DA83
       .byte $77 ; | XXX XXX| $DA84
       .byte $00 ; |        | $DA85
       .byte $00 ; |        | $DA86
       .byte $00 ; |        | $DA87
       .byte $00 ; |        | $DA88
       .byte $00 ; |        | $DA89
       .byte $04 ; |     X  | $DA8A
       .byte $04 ; |     X  | $DA8B
       .byte $06 ; |     XX | $DA8C
       .byte $06 ; |     XX | $DA8D
       .byte $07 ; |     XXX| $DA8E
       .byte $03 ; |      XX| $DA8F
       .byte $03 ; |      XX| $DA90
       .byte $03 ; |      XX| $DA91
       .byte $01 ; |       X| $DA92
       .byte $01 ; |       X| $DA93
       .byte $01 ; |       X| $DA94
       .byte $00 ; |        | $DA95
       .byte $00 ; |        | $DA96
       .byte $00 ; |        | $DA97
       .byte $00 ; |        | $DA98
LDA99: .byte $00 ; |        | $DA99
       .byte $00 ; |        | $DA9A
       .byte $00 ; |        | $DA9B
       .byte $00 ; |        | $DA9C
       .byte $00 ; |        | $DA9D
       .byte $00 ; |        | $DA9E
       .byte $00 ; |        | $DA9F
       .byte $00 ; |        | $DAA0
       .byte $00 ; |        | $DAA1
       .byte $00 ; |        | $DAA2
       .byte $00 ; |        | $DAA3
       .byte $00 ; |        | $DAA4
       .byte $00 ; |        | $DAA5
       .byte $00 ; |        | $DAA6
       .byte $00 ; |        | $DAA7
       .byte $00 ; |        | $DAA8
       .byte $00 ; |        | $DAA9
       .byte $00 ; |        | $DAAA
       .byte $00 ; |        | $DAAB
       .byte $00 ; |        | $DAAC
       .byte $00 ; |        | $DAAD
       .byte $00 ; |        | $DAAE
       .byte $00 ; |        | $DAAF
       .byte $00 ; |        | $DAB0
       .byte $00 ; |        | $DAB1
       .byte $00 ; |        | $DAB2
       .byte $00 ; |        | $DAB3
       .byte $00 ; |        | $DAB4
       .byte $00 ; |        | $DAB5
       .byte $00 ; |        | $DAB6
       .byte $00 ; |        | $DAB7
       .byte $00 ; |        | $DAB8
       .byte $00 ; |        | $DAB9
       .byte $00 ; |        | $DABA
       .byte $00 ; |        | $DABB
       .byte $00 ; |        | $DABC
       .byte $00 ; |        | $DABD
       .byte $00 ; |        | $DABE
       .byte $00 ; |        | $DABF
       .byte $00 ; |        | $DAC0
       .byte $00 ; |        | $DAC1
       .byte $00 ; |        | $DAC2
       .byte $00 ; |        | $DAC3
       .byte $00 ; |        | $DAC4
       .byte $00 ; |        | $DAC5
       .byte $00 ; |        | $DAC6
       .byte $00 ; |        | $DAC7
       .byte $00 ; |        | $DAC8
       .byte $00 ; |        | $DAC9
       .byte $00 ; |        | $DACA
       .byte $00 ; |        | $DACB
       .byte $4F ; | X  XXXX| $DACC
       .byte $4F ; | X  XXXX| $DACD
       .byte $4F ; | X  XXXX| $DACE
       .byte $4F ; | X  XXXX| $DACF
       .byte $4F ; | X  XXXX| $DAD0
       .byte $4F ; | X  XXXX| $DAD1
       .byte $4F ; | X  XXXX| $DAD2
       .byte $4F ; | X  XXXX| $DAD3
       .byte $4F ; | X  XXXX| $DAD4
       .byte $4F ; | X  XXXX| $DAD5
       .byte $F7 ; |XXXX XXX| $DAD6
       .byte $85 ; |X    X X| $DAD7
       .byte $88 ; |X   X   | $DAD8
       .byte $A9 ; |X X X  X| $DAD9
       .byte $F7 ; |XXXX XXX| $DADA
       .byte $85 ; |X    X X| $DADB
       .byte $89 ; |X   X  X| $DADC
       .byte $A5 ; |X X  X X| $DADD
       .byte $AF ; |X X XXXX| $DADE
       .byte $29 ; |  X X  X| $DADF
       .byte $F0 ; |XXXX    | $DAE0
       .byte $4A ; | X  X X | $DAE1
       .byte $4A ; | X  X X | $DAE2
       .byte $4A ; | X  X X | $DAE3
       .byte $4A ; | X  X X | $DAE4
       .byte $A8 ; |X X X   | $DAE5
       .byte $B9 ; |X XXX  X| $DAE6
       .byte $91 ; |X  X   X| $DAE7
       .byte $F7 ; |XXXX XXX| $DAE8
       .byte $85 ; |X    X X| $DAE9
       .byte $84 ; |X    X  | $DAEA
       .byte $B9 ; |X XXX  X| $DAEB
       .byte $96 ; |X  X XX | $DAEC
       .byte $FC ; |XXXXXX  | $DAED
       .byte $85 ; |X    X X| $DAEE
       .byte $85 ; |X    X X| $DAEF
       .byte $A9 ; |X X X  X| $DAF0
       .byte $01 ; |       X| $DAF1
       .byte $85 ; |X    X X| $DAF2
       .byte $04 ; |     X  | $DAF3
       .byte $85 ; |X    X X| $DAF4
       .byte $05 ; |     X X| $DAF5
       .byte $A0 ; |X X     | $DAF6
       .byte $04 ; |     X  | $DAF7
       .byte $85 ; |X    X X| $DAF8
       .byte $02 ; |      X | $DAF9
       .byte $A9 ; |X X X  X| $DAFA
       .byte $00 ; |        | $DAFB
       .byte $85 ; |X    X X| $DAFC
       .byte $08 ; |    X   | $DAFD
       .byte $A9 ; |X X X  X| $DAFE
       .byte $0C ; |    XX  | $DAFF
LDB00: .byte $43 ; | X    XX| $DB00
       .byte $41 ; | X     X| $DB01
       .byte $77 ; | XXX XXX| $DB02
       .byte $55 ; | X X X X| $DB03
       .byte $75 ; | XXX X X| $DB04
       .byte $00 ; |        | $DB05
       .byte $00 ; |        | $DB06
       .byte $00 ; |        | $DB07
       .byte $00 ; |        | $DB08
       .byte $00 ; |        | $DB09
       .byte $04 ; |     X  | $DB0A
       .byte $04 ; |     X  | $DB0B
       .byte $0C ; |    XX  | $DB0C
       .byte $0C ; |    XX  | $DB0D
       .byte $FC ; |XXXXXX  | $DB0E
       .byte $F8 ; |XXXXX   | $DB0F
       .byte $18 ; |   XX   | $DB10
       .byte $18 ; |   XX   | $DB11
       .byte $10 ; |   X    | $DB12
       .byte $B0 ; |X XX    | $DB13
       .byte $B0 ; |X XX    | $DB14
       .byte $E0 ; |XXX     | $DB15
       .byte $E3 ; |XXX   XX| $DB16
       .byte $E3 ; |XXX   XX| $DB17
       .byte $43 ; | X    XX| $DB18
LDB19: .byte $F0 ; |XXXX    | $DB19
       .byte $F8 ; |XXXXX   | $DB1A
       .byte $FC ; |XXXXXX  | $DB1B
       .byte $FE ; |XXXXXXX | $DB1C
       .byte $FF ; |XXXXXXXX| $DB1D
       .byte $FF ; |XXXXXXXX| $DB1E
       .byte $3F ; |  XXXXXX| $DB1F
       .byte $0F ; |    XXXX| $DB20
       .byte $07 ; |     XXX| $DB21
       .byte $07 ; |     XXX| $DB22
       .byte $03 ; |      XX| $DB23
       .byte $01 ; |       X| $DB24
       .byte $01 ; |       X| $DB25
       .byte $00 ; |        | $DB26
       .byte $00 ; |        | $DB27
       .byte $00 ; |        | $DB28
       .byte $00 ; |        | $DB29
       .byte $00 ; |        | $DB2A
       .byte $00 ; |        | $DB2B
       .byte $00 ; |        | $DB2C
       .byte $00 ; |        | $DB2D
       .byte $00 ; |        | $DB2E
       .byte $00 ; |        | $DB2F
       .byte $00 ; |        | $DB30
       .byte $00 ; |        | $DB31
       .byte $00 ; |        | $DB32
       .byte $00 ; |        | $DB33
       .byte $00 ; |        | $DB34
       .byte $00 ; |        | $DB35
       .byte $00 ; |        | $DB36
       .byte $00 ; |        | $DB37
       .byte $00 ; |        | $DB38
       .byte $00 ; |        | $DB39
       .byte $00 ; |        | $DB3A
       .byte $00 ; |        | $DB3B
       .byte $00 ; |        | $DB3C
       .byte $00 ; |        | $DB3D
       .byte $00 ; |        | $DB3E
       .byte $00 ; |        | $DB3F
       .byte $00 ; |        | $DB40
       .byte $00 ; |        | $DB41
       .byte $00 ; |        | $DB42
       .byte $00 ; |        | $DB43
       .byte $00 ; |        | $DB44
       .byte $00 ; |        | $DB45
       .byte $00 ; |        | $DB46
       .byte $00 ; |        | $DB47
       .byte $00 ; |        | $DB48
       .byte $00 ; |        | $DB49
       .byte $00 ; |        | $DB4A
       .byte $00 ; |        | $DB4B
LDB4C: .byte $01 ; |       X| $DB4C
       .byte $00 ; |        | $DB4D
       .byte $4B ; | X  X XX| $DB4E
       .byte $4A ; | X  X X | $DB4F
       .byte $6B ; | XX X XX| $DB50
       .byte $00 ; |        | $DB51
       .byte $08 ; |    X   | $DB52
       .byte $00 ; |        | $DB53
       .byte $00 ; |        | $DB54
       .byte $00 ; |        | $DB55
       .byte $62 ; | XX   X | $DB56
       .byte $62 ; | XX   X | $DB57
       .byte $63 ; | XX   XX| $DB58
       .byte $63 ; | XX   XX| $DB59
       .byte $63 ; | XX   XX| $DB5A
       .byte $61 ; | XX    X| $DB5B
       .byte $61 ; | XX    X| $DB5C
       .byte $61 ; | XX    X| $DB5D
       .byte $60 ; | XX     | $DB5E
       .byte $60 ; | XX     | $DB5F
       .byte $60 ; | XX     | $DB60
       .byte $60 ; | XX     | $DB61
       .byte $FC ; |XXXXXX  | $DB62
       .byte $FC ; |XXXXXX  | $DB63
       .byte $FC ; |XXXXXX  | $DB64
LDB65: .byte $01 ; |       X| $DB65
       .byte $01 ; |       X| $DB66
       .byte $01 ; |       X| $DB67
       .byte $01 ; |       X| $DB68
       .byte $01 ; |       X| $DB69
       .byte $01 ; |       X| $DB6A
       .byte $81 ; |X      X| $DB6B
       .byte $81 ; |X      X| $DB6C
       .byte $C1 ; |XX     X| $DB6D
       .byte $C1 ; |XX     X| $DB6E
       .byte $E1 ; |XXX    X| $DB6F
       .byte $E1 ; |XXX    X| $DB70
       .byte $E1 ; |XXX    X| $DB71
       .byte $F1 ; |XXXX   X| $DB72
       .byte $F1 ; |XXXX   X| $DB73
       .byte $71 ; | XXX   X| $DB74
       .byte $79 ; | XXXX  X| $DB75
       .byte $79 ; | XXXX  X| $DB76
       .byte $79 ; | XXXX  X| $DB77
       .byte $39 ; |  XXX  X| $DB78
       .byte $3D ; |  XXXX X| $DB79
       .byte $3D ; |  XXXX X| $DB7A
       .byte $1D ; |   XXX X| $DB7B
       .byte $1D ; |   XXX X| $DB7C
       .byte $1D ; |   XXX X| $DB7D
       .byte $1D ; |   XXX X| $DB7E
       .byte $1D ; |   XXX X| $DB7F
       .byte $0D ; |    XX X| $DB80
       .byte $0D ; |    XX X| $DB81
       .byte $0D ; |    XX X| $DB82
       .byte $0D ; |    XX X| $DB83
       .byte $0D ; |    XX X| $DB84
       .byte $0D ; |    XX X| $DB85
       .byte $0D ; |    XX X| $DB86
       .byte $0D ; |    XX X| $DB87
       .byte $0D ; |    XX X| $DB88
       .byte $0D ; |    XX X| $DB89
       .byte $0D ; |    XX X| $DB8A
       .byte $0D ; |    XX X| $DB8B
       .byte $0D ; |    XX X| $DB8C
       .byte $0D ; |    XX X| $DB8D
       .byte $0D ; |    XX X| $DB8E
       .byte $0D ; |    XX X| $DB8F
       .byte $0D ; |    XX X| $DB90
       .byte $0D ; |    XX X| $DB91
       .byte $0D ; |    XX X| $DB92
       .byte $0D ; |    XX X| $DB93
       .byte $0D ; |    XX X| $DB94
       .byte $0D ; |    XX X| $DB95
       .byte $0D ; |    XX X| $DB96
LDB97: .byte $80 ; |X       | $DB97
       .byte $80 ; |X       | $DB98
       .byte $AB ; |X X X XX| $DB99
       .byte $AA ; |X X X X | $DB9A
       .byte $BA ; |X XXX X | $DB9B
       .byte $22 ; |  X   X | $DB9C
       .byte $27 ; |  X  XXX| $DB9D
       .byte $22 ; |  X   X | $DB9E
       .byte $00 ; |        | $DB9F
       .byte $00 ; |        | $DBA0
       .byte $02 ; |      X | $DBA1
       .byte $02 ; |      X | $DBA2
       .byte $06 ; |     XX | $DBA3
       .byte $06 ; |     XX | $DBA4
       .byte $FE ; |XXXXXXX | $DBA5
       .byte $FC ; |XXXXXX  | $DBA6
       .byte $8C ; |X   XX  | $DBA7
       .byte $8C ; |X   XX  | $DBA8
       .byte $88 ; |X   X   | $DBA9
       .byte $D8 ; |XX XX   | $DBAA
       .byte $D8 ; |XX XX   | $DBAB
       .byte $70 ; | XXX    | $DBAC
       .byte $70 ; | XXX    | $DBAD
       .byte $70 ; | XXX    | $DBAE
       .byte $20 ; |  X     | $DBAF
LDBB0: .byte $E0 ; |XXX     | $DBB0
       .byte $E0 ; |XXX     | $DBB1
       .byte $E0 ; |XXX     | $DBB2
       .byte $E0 ; |XXX     | $DBB3
       .byte $E0 ; |XXX     | $DBB4
       .byte $E0 ; |XXX     | $DBB5
       .byte $E0 ; |XXX     | $DBB6
       .byte $E0 ; |XXX     | $DBB7
       .byte $E0 ; |XXX     | $DBB8
       .byte $E0 ; |XXX     | $DBB9
       .byte $E1 ; |XXX    X| $DBBA
       .byte $E1 ; |XXX    X| $DBBB
       .byte $E1 ; |XXX    X| $DBBC
       .byte $E3 ; |XXX   XX| $DBBD
       .byte $E3 ; |XXX   XX| $DBBE
       .byte $E3 ; |XXX   XX| $DBBF
       .byte $E7 ; |XXX  XXX| $DBC0
       .byte $E7 ; |XXX  XXX| $DBC1
       .byte $E7 ; |XXX  XXX| $DBC2
       .byte $E7 ; |XXX  XXX| $DBC3
       .byte $EF ; |XXX XXXX| $DBC4
       .byte $EF ; |XXX XXXX| $DBC5
       .byte $EE ; |XXX XXX | $DBC6
       .byte $EE ; |XXX XXX | $DBC7
       .byte $EE ; |XXX XXX | $DBC8
       .byte $EE ; |XXX XXX | $DBC9
       .byte $EE ; |XXX XXX | $DBCA
       .byte $EC ; |XXX XX  | $DBCB
       .byte $EC ; |XXX XX  | $DBCC
       .byte $EC ; |XXX XX  | $DBCD
       .byte $EC ; |XXX XX  | $DBCE
       .byte $EC ; |XXX XX  | $DBCF
       .byte $EC ; |XXX XX  | $DBD0
       .byte $EC ; |XXX XX  | $DBD1
       .byte $EC ; |XXX XX  | $DBD2
       .byte $EC ; |XXX XX  | $DBD3
       .byte $EC ; |XXX XX  | $DBD4
       .byte $EC ; |XXX XX  | $DBD5
       .byte $EC ; |XXX XX  | $DBD6
       .byte $EC ; |XXX XX  | $DBD7
       .byte $EC ; |XXX XX  | $DBD8
       .byte $EC ; |XXX XX  | $DBD9
       .byte $EC ; |XXX XX  | $DBDA
       .byte $EC ; |XXX XX  | $DBDB
       .byte $EC ; |XXX XX  | $DBDC
       .byte $EC ; |XXX XX  | $DBDD
       .byte $EC ; |XXX XX  | $DBDE
       .byte $EC ; |XXX XX  | $DBDF
       .byte $EC ; |XXX XX  | $DBE0
       .byte $EC ; |XXX XX  | $DBE1
       .byte $EC ; |XXX XX  | $DBE2
       .byte $00 ; |        | $DBE3
       .byte $00 ; |        | $DBE4
       .byte $00 ; |        | $DBE5
       .byte $00 ; |        | $DBE6
       .byte $00 ; |        | $DBE7
       .byte $00 ; |        | $DBE8
       .byte $00 ; |        | $DBE9
       .byte $00 ; |        | $DBEA
       .byte $00 ; |        | $DBEB
       .byte $00 ; |        | $DBEC
       .byte $00 ; |        | $DBED
       .byte $00 ; |        | $DBEE
       .byte $00 ; |        | $DBEF
       .byte $80 ; |X       | $DBF0
       .byte $80 ; |X       | $DBF1
       .byte $80 ; |X       | $DBF2
       .byte $C0 ; |XX      | $DBF3
       .byte $C0 ; |XX      | $DBF4
       .byte $C0 ; |XX      | $DBF5
       .byte $E0 ; |XXX     | $DBF6
       .byte $E0 ; |XXX     | $DBF7
       .byte $E0 ; |XXX     | $DBF8
       .byte $F0 ; |XXXX    | $DBF9
       .byte $F0 ; |XXXX    | $DBFA
       .byte $F8 ; |XXXXX   | $DBFB
       .byte $F8 ; |XXXXX   | $DBFC
       .byte $FC ; |XXXXXX  | $DBFD
       .byte $FC ; |XXXXXX  | $DBFE
       .byte $FE ; |XXXXXXX | $DBFF
LDC00: .byte $00 ; |        | $DC00
       .byte $00 ; |        | $DC01
       .byte $17 ; |   X XXX| $DC02
       .byte $11 ; |   X   X| $DC03
       .byte $17 ; |   X XXX| $DC04
       .byte $15 ; |   X X X| $DC05
       .byte $17 ; |   X XXX| $DC06
       .byte $00 ; |        | $DC07
       .byte $00 ; |        | $DC08
       .byte $00 ; |        | $DC09
       .byte $61 ; | XX    X| $DC0A
       .byte $61 ; | XX    X| $DC0B
       .byte $63 ; | XX   XX| $DC0C
       .byte $63 ; | XX   XX| $DC0D
       .byte $67 ; | XX  XXX| $DC0E
       .byte $7E ; | XXXXXX | $DC0F
       .byte $7E ; | XXXXXX | $DC10
       .byte $7F ; | XXXXXXX| $DC11
       .byte $67 ; | XX  XXX| $DC12
       .byte $63 ; | XX   XX| $DC13
       .byte $61 ; | XX    X| $DC14
       .byte $63 ; | XX   XX| $DC15
       .byte $77 ; | XXX XXX| $DC16
       .byte $7E ; | XXXXXX | $DC17
       .byte $3C ; |  XXXX  | $DC18
LDC19: .byte $03 ; |      XX| $DC19
       .byte $07 ; |     XXX| $DC1A
       .byte $0F ; |    XXXX| $DC1B
       .byte $1F ; |   XXXXX| $DC1C
       .byte $3F ; |  XXXXXX| $DC1D
       .byte $3F ; |  XXXXXX| $DC1E
       .byte $7F ; | XXXXXXX| $DC1F
       .byte $7C ; | XXXXX  | $DC20
       .byte $F8 ; |XXXXX   | $DC21
       .byte $F8 ; |XXXXX   | $DC22
       .byte $F0 ; |XXXX    | $DC23
       .byte $E0 ; |XXX     | $DC24
       .byte $E0 ; |XXX     | $DC25
       .byte $C0 ; |XX      | $DC26
       .byte $C0 ; |XX      | $DC27
       .byte $80 ; |X       | $DC28
       .byte $80 ; |X       | $DC29
       .byte $80 ; |X       | $DC2A
       .byte $80 ; |X       | $DC2B
       .byte $00 ; |        | $DC2C
       .byte $00 ; |        | $DC2D
       .byte $00 ; |        | $DC2E
       .byte $00 ; |        | $DC2F
       .byte $00 ; |        | $DC30
       .byte $00 ; |        | $DC31
       .byte $00 ; |        | $DC32
       .byte $00 ; |        | $DC33
       .byte $00 ; |        | $DC34
       .byte $00 ; |        | $DC35
       .byte $00 ; |        | $DC36
       .byte $00 ; |        | $DC37
       .byte $00 ; |        | $DC38
       .byte $00 ; |        | $DC39
       .byte $00 ; |        | $DC3A
       .byte $00 ; |        | $DC3B
       .byte $00 ; |        | $DC3C
       .byte $00 ; |        | $DC3D
       .byte $00 ; |        | $DC3E
       .byte $00 ; |        | $DC3F
       .byte $00 ; |        | $DC40
       .byte $00 ; |        | $DC41
       .byte $00 ; |        | $DC42
       .byte $00 ; |        | $DC43
       .byte $00 ; |        | $DC44
       .byte $00 ; |        | $DC45
       .byte $00 ; |        | $DC46
       .byte $00 ; |        | $DC47
       .byte $00 ; |        | $DC48
       .byte $00 ; |        | $DC49
       .byte $00 ; |        | $DC4A
       .byte $00 ; |        | $DC4B
LDC4C: .byte $00 ; |        | $DC4C
       .byte $00 ; |        | $DC4D
       .byte $77 ; | XXX XXX| $DC4E
       .byte $54 ; | X X X  | $DC4F
       .byte $77 ; | XXX XXX| $DC50
       .byte $51 ; | X X   X| $DC51
       .byte $77 ; | XXX XXX| $DC52
       .byte $00 ; |        | $DC53
       .byte $00 ; |        | $DC54
       .byte $00 ; |        | $DC55
       .byte $98 ; |X  XX   | $DC56
       .byte $98 ; |X  XX   | $DC57
       .byte $98 ; |X  XX   | $DC58
       .byte $18 ; |   XX   | $DC59
       .byte $18 ; |   XX   | $DC5A
       .byte $18 ; |   XX   | $DC5B
       .byte $18 ; |   XX   | $DC5C
       .byte $18 ; |   XX   | $DC5D
       .byte $18 ; |   XX   | $DC5E
       .byte $98 ; |X  XX   | $DC5F
       .byte $98 ; |X  XX   | $DC60
       .byte $18 ; |   XX   | $DC61
       .byte $18 ; |   XX   | $DC62
       .byte $18 ; |   XX   | $DC63
       .byte $18 ; |   XX   | $DC64
LDC65: .byte $C0 ; |XX      | $DC65
       .byte $C0 ; |XX      | $DC66
       .byte $C0 ; |XX      | $DC67
       .byte $C0 ; |XX      | $DC68
       .byte $C0 ; |XX      | $DC69
       .byte $C0 ; |XX      | $DC6A
       .byte $00 ; |        | $DC6B
       .byte $00 ; |        | $DC6C
       .byte $00 ; |        | $DC6D
       .byte $00 ; |        | $DC6E
       .byte $00 ; |        | $DC6F
       .byte $00 ; |        | $DC70
       .byte $00 ; |        | $DC71
       .byte $00 ; |        | $DC72
       .byte $00 ; |        | $DC73
       .byte $00 ; |        | $DC74
       .byte $00 ; |        | $DC75
       .byte $00 ; |        | $DC76
       .byte $00 ; |        | $DC77
       .byte $00 ; |        | $DC78
       .byte $00 ; |        | $DC79
       .byte $00 ; |        | $DC7A
       .byte $00 ; |        | $DC7B
       .byte $00 ; |        | $DC7C
       .byte $00 ; |        | $DC7D
       .byte $00 ; |        | $DC7E
       .byte $00 ; |        | $DC7F
       .byte $00 ; |        | $DC80
       .byte $00 ; |        | $DC81
       .byte $00 ; |        | $DC82
       .byte $00 ; |        | $DC83
       .byte $00 ; |        | $DC84
       .byte $00 ; |        | $DC85
       .byte $00 ; |        | $DC86
       .byte $00 ; |        | $DC87
       .byte $00 ; |        | $DC88
       .byte $00 ; |        | $DC89
       .byte $00 ; |        | $DC8A
       .byte $00 ; |        | $DC8B
       .byte $00 ; |        | $DC8C
       .byte $00 ; |        | $DC8D
       .byte $00 ; |        | $DC8E
       .byte $00 ; |        | $DC8F
       .byte $00 ; |        | $DC90
       .byte $00 ; |        | $DC91
       .byte $00 ; |        | $DC92
       .byte $00 ; |        | $DC93
       .byte $00 ; |        | $DC94
       .byte $00 ; |        | $DC95
       .byte $00 ; |        | $DC96
       .byte $00 ; |        | $DC97
       .byte $F7 ; |XXXX XXX| $DC98
       .byte $F7 ; |XXXX XXX| $DC99
       .byte $F7 ; |XXXX XXX| $DC9A
       .byte $F7 ; |XXXX XXX| $DC9B
       .byte $F7 ; |XXXX XXX| $DC9C
       .byte $F7 ; |XXXX XXX| $DC9D
       .byte $F7 ; |XXXX XXX| $DC9E
       .byte $F7 ; |XXXX XXX| $DC9F
       .byte $FC ; |XXXXXX  | $DCA0
       .byte $FC ; |XXXXXX  | $DCA1
       .byte $FC ; |XXXXXX  | $DCA2
       .byte $FC ; |XXXXXX  | $DCA3
       .byte $FC ; |XXXXXX  | $DCA4
       .byte $FC ; |XXXXXX  | $DCA5
       .byte $FC ; |XXXXXX  | $DCA6
       .byte $FC ; |XXXXXX  | $DCA7
       .byte $16 ; |   X XX | $DCA8
       .byte $F6 ; |XXXX XX | $DCA9
       .byte $DB ; |XX XX XX| $DCAA
       .byte $C0 ; |XX      | $DCAB
       .byte $AA ; |X X X X | $DCAC
       .byte $B8 ; |X XXX   | $DCAD
       .byte $F2 ; |XXXX  X | $DCAE
       .byte $F2 ; |XXXX  X | $DCAF
       .byte $F3 ; |XXXX  XX| $DCB0
       .byte $F4 ; |XXXX X  | $DCB1
       .byte $F5 ; |XXXX X X| $DCB2
       .byte $F6 ; |XXXX XX | $DCB3
       .byte $00 ; |        | $DCB4
       .byte $00 ; |        | $DCB5
       .byte $00 ; |        | $DCB6
       .byte $00 ; |        | $DCB7
       .byte $18 ; |   XX   | $DCB8
       .byte $3C ; |  XXXX  | $DCB9
       .byte $5A ; | X XX X | $DCBA
       .byte $18 ; |   XX   | $DCBB
       .byte $3C ; |  XXXX  | $DCBC
       .byte $18 ; |   XX   | $DCBD
       .byte $99 ; |X  XX  X| $DCBE
       .byte $BD ; |X XXXX X| $DCBF
       .byte $FF ; |XXXXXXXX| $DCC0
       .byte $FF ; |XXXXXXXX| $DCC1
       .byte $DB ; |XX XX XX| $DCC2
       .byte $99 ; |X  XX  X| $DCC3
       .byte $81 ; |X      X| $DCC4
       .byte $81 ; |X      X| $DCC5
       .byte $4F ; | X  XXXX| $DCC6
       .byte $4F ; | X  XXXX| $DCC7
       .byte $4F ; | X  XXXX| $DCC8
       .byte $4F ; | X  XXXX| $DCC9
       .byte $4F ; | X  XXXX| $DCCA
       .byte $4F ; | X  XXXX| $DCCB
       .byte $4F ; | X  XXXX| $DCCC
       .byte $4F ; | X  XXXX| $DCCD
       .byte $4F ; | X  XXXX| $DCCE
       .byte $4F ; | X  XXXX| $DCCF
       .byte $4F ; | X  XXXX| $DCD0
       .byte $4F ; | X  XXXX| $DCD1
       .byte $4F ; | X  XXXX| $DCD2
       .byte $4F ; | X  XXXX| $DCD3
       .byte $4F ; | X  XXXX| $DCD4
       .byte $4F ; | X  XXXX| $DCD5
       .byte $00 ; |        | $DCD6
       .byte $00 ; |        | $DCD7
       .byte $00 ; |        | $DCD8
       .byte $00 ; |        | $DCD9
       .byte $00 ; |        | $DCDA
       .byte $00 ; |        | $DCDB
       .byte $00 ; |        | $DCDC
       .byte $00 ; |        | $DCDD
       .byte $00 ; |        | $DCDE
       .byte $00 ; |        | $DCDF
       .byte $00 ; |        | $DCE0
       .byte $00 ; |        | $DCE1
       .byte $00 ; |        | $DCE2
       .byte $00 ; |        | $DCE3
       .byte $00 ; |        | $DCE4
       .byte $00 ; |        | $DCE5
       .byte $00 ; |        | $DCE6
       .byte $00 ; |        | $DCE7
       .byte $00 ; |        | $DCE8
       .byte $00 ; |        | $DCE9
       .byte $00 ; |        | $DCEA
       .byte $00 ; |        | $DCEB
       .byte $00 ; |        | $DCEC
       .byte $00 ; |        | $DCED
       .byte $00 ; |        | $DCEE
       .byte $00 ; |        | $DCEF
       .byte $00 ; |        | $DCF0
       .byte $00 ; |        | $DCF1
       .byte $00 ; |        | $DCF2
       .byte $00 ; |        | $DCF3
       .byte $00 ; |        | $DCF4
       .byte $00 ; |        | $DCF5
       .byte $00 ; |        | $DCF6
       .byte $00 ; |        | $DCF7
       .byte $00 ; |        | $DCF8
       .byte $00 ; |        | $DCF9
       .byte $00 ; |        | $DCFA
       .byte $00 ; |        | $DCFB
       .byte $00 ; |        | $DCFC
       .byte $00 ; |        | $DCFD
       .byte $00 ; |        | $DCFE
       .byte $00 ; |        | $DCFF
LDD00: .byte $50 ; | X X    | $DD00
LDD01: .byte $40 ; | X      | $DD01
       .byte $30 ; |  XX    | $DD02
       .byte $20 ; |  X     | $DD03
       .byte $10 ; |   X    | $DD04
       .byte $00 ; |        | $DD05
       .byte $F0 ; |XXXX    | $DD06
       .byte $E0 ; |XXX     | $DD07
       .byte $D0 ; |XX X    | $DD08
       .byte $C0 ; |XX      | $DD09
       .byte $B0 ; |X XX    | $DD0A
       .byte $A0 ; |X X     | $DD0B
       .byte $90 ; |X  X    | $DD0C
       .byte $80 ; |X       | $DD0D
       .byte $61 ; | XX    X| $DD0E
       .byte $51 ; | X X   X| $DD0F
       .byte $41 ; | X     X| $DD10
       .byte $31 ; |  XX   X| $DD11
       .byte $21 ; |  X    X| $DD12
       .byte $11 ; |   X   X| $DD13
       .byte $01 ; |       X| $DD14
       .byte $F1 ; |XXXX   X| $DD15
       .byte $E1 ; |XXX    X| $DD16
       .byte $D1 ; |XX X   X| $DD17
       .byte $C1 ; |XX     X| $DD18
       .byte $B1 ; |X XX   X| $DD19
       .byte $A1 ; |X X    X| $DD1A
       .byte $91 ; |X  X   X| $DD1B
       .byte $81 ; |X      X| $DD1C
       .byte $62 ; | XX   X | $DD1D
       .byte $52 ; | X X  X | $DD1E
       .byte $42 ; | X    X | $DD1F
       .byte $32 ; |  XX  X | $DD20
       .byte $22 ; |  X   X | $DD21
       .byte $12 ; |   X  X | $DD22
       .byte $02 ; |      X | $DD23
       .byte $F2 ; |XXXX  X | $DD24
       .byte $E2 ; |XXX   X | $DD25
       .byte $D2 ; |XX X  X | $DD26
       .byte $C2 ; |XX    X | $DD27
       .byte $B2 ; |X XX  X | $DD28
       .byte $A2 ; |X X   X | $DD29
       .byte $92 ; |X  X  X | $DD2A
       .byte $82 ; |X     X | $DD2B
       .byte $63 ; | XX   XX| $DD2C
       .byte $53 ; | X X  XX| $DD2D
       .byte $43 ; | X    XX| $DD2E
       .byte $33 ; |  XX  XX| $DD2F
       .byte $23 ; |  X   XX| $DD30
       .byte $13 ; |   X  XX| $DD31
       .byte $03 ; |      XX| $DD32
       .byte $F3 ; |XXXX  XX| $DD33
       .byte $E3 ; |XXX   XX| $DD34
       .byte $D3 ; |XX X  XX| $DD35
       .byte $C3 ; |XX    XX| $DD36
       .byte $B3 ; |X XX  XX| $DD37
       .byte $A3 ; |X X   XX| $DD38
       .byte $93 ; |X  X  XX| $DD39
       .byte $83 ; |X     XX| $DD3A
       .byte $64 ; | XX  X  | $DD3B
       .byte $54 ; | X X X  | $DD3C
       .byte $44 ; | X   X  | $DD3D
       .byte $34 ; |  XX X  | $DD3E
       .byte $24 ; |  X  X  | $DD3F
       .byte $14 ; |   X X  | $DD40
       .byte $04 ; |     X  | $DD41
       .byte $F4 ; |XXXX X  | $DD42
       .byte $E4 ; |XXX  X  | $DD43
       .byte $D4 ; |XX X X  | $DD44
       .byte $C4 ; |XX   X  | $DD45
       .byte $B4 ; |X XX X  | $DD46
       .byte $A4 ; |X X  X  | $DD47
       .byte $94 ; |X  X X  | $DD48
       .byte $84 ; |X    X  | $DD49
       .byte $65 ; | XX  X X| $DD4A
       .byte $55 ; | X X X X| $DD4B
       .byte $45 ; | X   X X| $DD4C
       .byte $35 ; |  XX X X| $DD4D
       .byte $25 ; |  X  X X| $DD4E
       .byte $15 ; |   X X X| $DD4F
       .byte $05 ; |     X X| $DD50
       .byte $F5 ; |XXXX X X| $DD51
       .byte $E5 ; |XXX  X X| $DD52
       .byte $D5 ; |XX X X X| $DD53
       .byte $C5 ; |XX   X X| $DD54
       .byte $B5 ; |X XX X X| $DD55
       .byte $A5 ; |X X  X X| $DD56
       .byte $95 ; |X  X X X| $DD57
       .byte $85 ; |X    X X| $DD58
       .byte $66 ; | XX  XX | $DD59
       .byte $56 ; | X X XX | $DD5A
       .byte $46 ; | X   XX | $DD5B
       .byte $36 ; |  XX XX | $DD5C
       .byte $26 ; |  X  XX | $DD5D
       .byte $16 ; |   X XX | $DD5E
       .byte $06 ; |     XX | $DD5F
       .byte $F6 ; |XXXX XX | $DD60
       .byte $E6 ; |XXX  XX | $DD61
       .byte $D6 ; |XX X XX | $DD62
       .byte $C6 ; |XX   XX | $DD63
       .byte $B6 ; |X XX XX | $DD64
       .byte $A6 ; |X X  XX | $DD65
       .byte $96 ; |X  X XX | $DD66
       .byte $86 ; |X    XX | $DD67
       .byte $67 ; | XX  XXX| $DD68
       .byte $57 ; | X X XXX| $DD69
       .byte $47 ; | X   XXX| $DD6A
       .byte $37 ; |  XX XXX| $DD6B
       .byte $27 ; |  X  XXX| $DD6C
       .byte $17 ; |   X XXX| $DD6D
       .byte $07 ; |     XXX| $DD6E
       .byte $F7 ; |XXXX XXX| $DD6F
       .byte $E7 ; |XXX  XXX| $DD70
       .byte $D7 ; |XX X XXX| $DD71
       .byte $C7 ; |XX   XXX| $DD72
       .byte $B7 ; |X XX XXX| $DD73
       .byte $A7 ; |X X  XXX| $DD74
       .byte $97 ; |X  X XXX| $DD75
       .byte $87 ; |X    XXX| $DD76
       .byte $68 ; | XX X   | $DD77
       .byte $58 ; | X XX   | $DD78
       .byte $48 ; | X  X   | $DD79
       .byte $38 ; |  XXX   | $DD7A
       .byte $28 ; |  X X   | $DD7B
       .byte $18 ; |   XX   | $DD7C
       .byte $08 ; |    X   | $DD7D
       .byte $F8 ; |XXXXX   | $DD7E
       .byte $E8 ; |XXX X   | $DD7F
       .byte $D8 ; |XX XX   | $DD80
       .byte $00 ; |        | $DD81
       .byte $00 ; |        | $DD82
       .byte $00 ; |        | $DD83
       .byte $00 ; |        | $DD84
       .byte $00 ; |        | $DD85
       .byte $00 ; |        | $DD86
       .byte $00 ; |        | $DD87
       .byte $00 ; |        | $DD88
       .byte $00 ; |        | $DD89
       .byte $00 ; |        | $DD8A
       .byte $00 ; |        | $DD8B
       .byte $00 ; |        | $DD8C
       .byte $00 ; |        | $DD8D
       .byte $00 ; |        | $DD8E
       .byte $00 ; |        | $DD8F
       .byte $00 ; |        | $DD90
       .byte $00 ; |        | $DD91
       .byte $00 ; |        | $DD92
       .byte $00 ; |        | $DD93
       .byte $00 ; |        | $DD94
       .byte $00 ; |        | $DD95
       .byte $00 ; |        | $DD96
       .byte $00 ; |        | $DD97
       .byte $00 ; |        | $DD98
       .byte $00 ; |        | $DD99
       .byte $00 ; |        | $DD9A
       .byte $00 ; |        | $DD9B
       .byte $00 ; |        | $DD9C
       .byte $00 ; |        | $DD9D
       .byte $00 ; |        | $DD9E
       .byte $00 ; |        | $DD9F
       .byte $00 ; |        | $DDA0
       .byte $00 ; |        | $DDA1
       .byte $00 ; |        | $DDA2
       .byte $00 ; |        | $DDA3
       .byte $00 ; |        | $DDA4
       .byte $00 ; |        | $DDA5
       .byte $00 ; |        | $DDA6
       .byte $00 ; |        | $DDA7
       .byte $00 ; |        | $DDA8
       .byte $00 ; |        | $DDA9
       .byte $00 ; |        | $DDAA
       .byte $00 ; |        | $DDAB
       .byte $00 ; |        | $DDAC
       .byte $00 ; |        | $DDAD
       .byte $00 ; |        | $DDAE
       .byte $00 ; |        | $DDAF
       .byte $00 ; |        | $DDB0
       .byte $00 ; |        | $DDB1
       .byte $00 ; |        | $DDB2
       .byte $00 ; |        | $DDB3
       .byte $00 ; |        | $DDB4
       .byte $00 ; |        | $DDB5
       .byte $00 ; |        | $DDB6
       .byte $00 ; |        | $DDB7
       .byte $00 ; |        | $DDB8
       .byte $00 ; |        | $DDB9
       .byte $00 ; |        | $DDBA
       .byte $00 ; |        | $DDBB
       .byte $00 ; |        | $DDBC
       .byte $00 ; |        | $DDBD
       .byte $00 ; |        | $DDBE
       .byte $00 ; |        | $DDBF
       .byte $00 ; |        | $DDC0
       .byte $00 ; |        | $DDC1
       .byte $00 ; |        | $DDC2
       .byte $00 ; |        | $DDC3
       .byte $00 ; |        | $DDC4
       .byte $00 ; |        | $DDC5
       .byte $00 ; |        | $DDC6
       .byte $00 ; |        | $DDC7
       .byte $00 ; |        | $DDC8
       .byte $00 ; |        | $DDC9
       .byte $00 ; |        | $DDCA
       .byte $00 ; |        | $DDCB
       .byte $00 ; |        | $DDCC
       .byte $00 ; |        | $DDCD
       .byte $00 ; |        | $DDCE
       .byte $00 ; |        | $DDCF
       .byte $00 ; |        | $DDD0
       .byte $00 ; |        | $DDD1
       .byte $00 ; |        | $DDD2
       .byte $00 ; |        | $DDD3
       .byte $00 ; |        | $DDD4
       .byte $00 ; |        | $DDD5
       .byte $00 ; |        | $DDD6
       .byte $00 ; |        | $DDD7
       .byte $00 ; |        | $DDD8
       .byte $00 ; |        | $DDD9
       .byte $00 ; |        | $DDDA
       .byte $00 ; |        | $DDDB
       .byte $00 ; |        | $DDDC
       .byte $00 ; |        | $DDDD
       .byte $00 ; |        | $DDDE
       .byte $00 ; |        | $DDDF
       .byte $00 ; |        | $DDE0
       .byte $00 ; |        | $DDE1
       .byte $00 ; |        | $DDE2
       .byte $00 ; |        | $DDE3
       .byte $00 ; |        | $DDE4
       .byte $00 ; |        | $DDE5
       .byte $00 ; |        | $DDE6
       .byte $00 ; |        | $DDE7
       .byte $00 ; |        | $DDE8
       .byte $00 ; |        | $DDE9
       .byte $00 ; |        | $DDEA
       .byte $00 ; |        | $DDEB
       .byte $00 ; |        | $DDEC
       .byte $00 ; |        | $DDED
       .byte $00 ; |        | $DDEE
       .byte $00 ; |        | $DDEF
       .byte $00 ; |        | $DDF0
       .byte $00 ; |        | $DDF1
       .byte $00 ; |        | $DDF2
       .byte $00 ; |        | $DDF3
       .byte $00 ; |        | $DDF4
       .byte $00 ; |        | $DDF5
       .byte $00 ; |        | $DDF6
       .byte $00 ; |        | $DDF7
       .byte $00 ; |        | $DDF8
       .byte $00 ; |        | $DDF9
       .byte $00 ; |        | $DDFA
       .byte $00 ; |        | $DDFB
       .byte $00 ; |        | $DDFC
       .byte $00 ; |        | $DDFD
       .byte $00 ; |        | $DDFE
       .byte $00 ; |        | $DDFF
       .byte $A0 ; |X X     | $DE00
       .byte $50 ; | X X    | $DE01
       .byte $F0 ; |XXXX    | $DE02
       .byte $B0 ; |X XX    | $DE03
       .byte $70 ; | XXX    | $DE04
       .byte $60 ; | XX     | $DE05
       .byte $28 ; |  X X   | $DE06
       .byte $50 ; | X X    | $DE07
       .byte $F0 ; |XXXX    | $DE08
       .byte $B0 ; |X XX    | $DE09
       .byte $70 ; | XXX    | $DE0A
       .byte $60 ; | XX     | $DE0B
       .byte $7C ; | XXXXX  | $DE0C
       .byte $FE ; |XXXXXXX | $DE0D
       .byte $8E ; |X   XXX | $DE0E
       .byte $9F ; |X  XXXXX| $DE0F
       .byte $9E ; |X  XXXX | $DE10
       .byte $51 ; | X X   X| $DE11
       .byte $3C ; |  XXXX  | $DE12
       .byte $7E ; | XXXXXX | $DE13
       .byte $4E ; | X  XXX | $DE14
       .byte $5F ; | X XXXXX| $DE15
       .byte $55 ; | X X X X| $DE16
       .byte $91 ; |X  X   X| $DE17
       .byte $3C ; |  XXXX  | $DE18
       .byte $7E ; | XXXXXX | $DE19
       .byte $72 ; | XXX  X | $DE1A
       .byte $FA ; |XXXXX X | $DE1B
       .byte $AA ; |X X X X | $DE1C
       .byte $89 ; |X   X  X| $DE1D
       .byte $3E ; |  XXXXX | $DE1E
       .byte $7F ; | XXXXXXX| $DE1F
       .byte $71 ; | XXX   X| $DE20
       .byte $F9 ; |XXXXX  X| $DE21
       .byte $A9 ; |X X X  X| $DE22
       .byte $8A ; |X   X X | $DE23
       .byte $81 ; |X      X| $DE24
       .byte $5A ; | X XX X | $DE25
       .byte $7E ; | XXXXXX | $DE26
       .byte $3C ; |  XXXX  | $DE27
       .byte $BD ; |X XXXX X| $DE28
       .byte $7E ; | XXXXXX | $DE29
       .byte $99 ; |X  XX  X| $DE2A
       .byte $7E ; | XXXXXX | $DE2B
       .byte $3C ; |  XXXX  | $DE2C
       .byte $3C ; |  XXXX  | $DE2D
       .byte $A5 ; |X X  X X| $DE2E
       .byte $42 ; | X    X | $DE2F
       .byte $7E ; | XXXXXX | $DE30
       .byte $BD ; |X XXXX X| $DE31
       .byte $3C ; |  XXXX  | $DE32
       .byte $7E ; | XXXXXX | $DE33
       .byte $5A ; | X XX X | $DE34
       .byte $81 ; |X      X| $DE35
       .byte $99 ; |X  XX  X| $DE36
       .byte $7E ; | XXXXXX | $DE37
       .byte $3C ; |  XXXX  | $DE38
       .byte $3C ; |  XXXX  | $DE39
       .byte $A5 ; |X X  X X| $DE3A
       .byte $42 ; | X    X | $DE3B
       .byte $FE ; |XXXXXXX | $DE3C
       .byte $2A ; |  X X X | $DE3D
       .byte $6A ; | XX X X | $DE3E
       .byte $2A ; |  X X X | $DE3F
       .byte $FE ; |XXXXXXX | $DE40
       .byte $00 ; |        | $DE41
       .byte $FE ; |XXXXXXX | $DE42
       .byte $AA ; |X X X X | $DE43
       .byte $EA ; |XXX X X | $DE44
       .byte $AA ; |X X X X | $DE45
       .byte $BE ; |X XXXXX | $DE46
       .byte $00 ; |        | $DE47
       .byte $3E ; |  XXXXX | $DE48
       .byte $2A ; |  X X X | $DE49
       .byte $EA ; |XXX X X | $DE4A
       .byte $AA ; |X X X X | $DE4B
       .byte $FE ; |XXXXXXX | $DE4C
       .byte $00 ; |        | $DE4D
       .byte $4A ; | X  X X | $DE4E
       .byte $90 ; |X  X    | $DE4F
       .byte $3D ; |  XXXX X| $DE50
       .byte $FE ; |XXXXXXX | $DE51
       .byte $7D ; | XXXXX X| $DE52
       .byte $BA ; |X XXX X | $DE53
       .byte $11 ; |   X   X| $DE54
       .byte $4A ; | X  X X | $DE55
       .byte $1C ; |   XXX  | $DE56
       .byte $3C ; |  XXXX  | $DE57
       .byte $5D ; | X XXX X| $DE58
       .byte $AA ; |X X X X | $DE59
       .byte $10 ; |   X    | $DE5A
       .byte $4A ; | X  X X | $DE5B
       .byte $A0 ; |X X     | $DE5C
       .byte $14 ; |   X X  | $DE5D
       .byte $55 ; | X X X X| $DE5E
       .byte $28 ; |  X X   | $DE5F
       .byte $11 ; |   X   X| $DE60
       .byte $4E ; | X  XXX | $DE61
       .byte $B5 ; |X XX X X| $DE62
       .byte $3E ; |  XXXXX | $DE63
       .byte $5D ; | X XXX X| $DE64
       .byte $AA ; |X X X X | $DE65
       .byte $00 ; |        | $DE66
       .byte $00 ; |        | $DE67
       .byte $00 ; |        | $DE68
       .byte $00 ; |        | $DE69
       .byte $00 ; |        | $DE6A
       .byte $00 ; |        | $DE6B
LDE6C: .byte $40 ; | X      | $DE6C
       .byte $E0 ; |XXX     | $DE6D
       .byte $F0 ; |XXXX    | $DE6E
       .byte $F0 ; |XXXX    | $DE6F
       .byte $E0 ; |XXX     | $DE70
       .byte $40 ; | X      | $DE71
LDE72: .byte $44 ; | X   X  | $DE72
       .byte $EE ; |XXX XXX | $DE73
       .byte $FF ; |XXXXXXXX| $DE74
       .byte $FF ; |XXXXXXXX| $DE75
LDE76: .byte $EE ; |XXX XXX | $DE76
LDE77: .byte $44 ; | X   X  | $DE77
       .byte $49 ; | X  X  X| $DE78
       .byte $ED ; |XXX XX X| $DE79
       .byte $FF ; |XXXXXXXX| $DE7A
       .byte $FF ; |XXXXXXXX| $DE7B
       .byte $ED ; |XXX XX X| $DE7C
       .byte $49 ; | X  X  X| $DE7D
       .byte $22 ; |  X   X | $DE7E
       .byte $B7 ; |X XX XXX| $DE7F
       .byte $FF ; |XXXXXXXX| $DE80
       .byte $FF ; |XXXXXXXX| $DE81
       .byte $B7 ; |X XX XXX| $DE82
       .byte $22 ; |  X   X | $DE83
       .byte $92 ; |X  X  X | $DE84
       .byte $DB ; |XX XX XX| $DE85
       .byte $FF ; |XXXXXXXX| $DE86
       .byte $FF ; |XXXXXXXX| $DE87
       .byte $DB ; |XX XX XX| $DE88
       .byte $92 ; |X  X  X | $DE89
LDE8A: .byte $00 ; |        | $DE8A
       .byte $02 ; |      X | $DE8B
       .byte $02 ; |      X | $DE8C
       .byte $02 ; |      X | $DE8D
       .byte $00 ; |        | $DE8E
       .byte $00 ; |        | $DE8F
       .byte $00 ; |        | $DE90
       .byte $00 ; |        | $DE91
       .byte $00 ; |        | $DE92
       .byte $00 ; |        | $DE93
       .byte $00 ; |        | $DE94
       .byte $00 ; |        | $DE95
       .byte $00 ; |        | $DE96
       .byte $00 ; |        | $DE97
       .byte $00 ; |        | $DE98
       .byte $00 ; |        | $DE99
       .byte $00 ; |        | $DE9A
       .byte $00 ; |        | $DE9B
       .byte $00 ; |        | $DE9C
       .byte $00 ; |        | $DE9D
       .byte $00 ; |        | $DE9E
       .byte $04 ; |     X  | $DE9F
       .byte $00 ; |        | $DEA0
       .byte $00 ; |        | $DEA1
       .byte $00 ; |        | $DEA2
       .byte $00 ; |        | $DEA3
       .byte $00 ; |        | $DEA4
       .byte $00 ; |        | $DEA5
       .byte $00 ; |        | $DEA6
       .byte $00 ; |        | $DEA7
       .byte $00 ; |        | $DEA8
       .byte $00 ; |        | $DEA9
       .byte $00 ; |        | $DEAA
       .byte $00 ; |        | $DEAB
       .byte $00 ; |        | $DEAC
       .byte $00 ; |        | $DEAD
       .byte $00 ; |        | $DEAE
       .byte $00 ; |        | $DEAF
       .byte $00 ; |        | $DEB0
       .byte $00 ; |        | $DEB1
       .byte $00 ; |        | $DEB2
       .byte $00 ; |        | $DEB3
       .byte $00 ; |        | $DEB4
       .byte $00 ; |        | $DEB5
       .byte $00 ; |        | $DEB6
       .byte $00 ; |        | $DEB7
       .byte $00 ; |        | $DEB8
       .byte $00 ; |        | $DEB9
       .byte $00 ; |        | $DEBA
       .byte $00 ; |        | $DEBB
       .byte $00 ; |        | $DEBC
       .byte $00 ; |        | $DEBD
       .byte $00 ; |        | $DEBE
       .byte $00 ; |        | $DEBF
       .byte $00 ; |        | $DEC0
       .byte $00 ; |        | $DEC1
       .byte $00 ; |        | $DEC2
       .byte $00 ; |        | $DEC3
       .byte $00 ; |        | $DEC4
       .byte $00 ; |        | $DEC5
       .byte $00 ; |        | $DEC6
       .byte $00 ; |        | $DEC7
       .byte $00 ; |        | $DEC8
       .byte $00 ; |        | $DEC9
       .byte $00 ; |        | $DECA
       .byte $00 ; |        | $DECB
       .byte $00 ; |        | $DECC
       .byte $00 ; |        | $DECD
       .byte $00 ; |        | $DECE
       .byte $00 ; |        | $DECF
       .byte $00 ; |        | $DED0
       .byte $00 ; |        | $DED1
       .byte $00 ; |        | $DED2
       .byte $00 ; |        | $DED3
       .byte $00 ; |        | $DED4
       .byte $00 ; |        | $DED5
       .byte $00 ; |        | $DED6
       .byte $00 ; |        | $DED7
       .byte $00 ; |        | $DED8
       .byte $00 ; |        | $DED9
       .byte $00 ; |        | $DEDA
       .byte $00 ; |        | $DEDB
       .byte $00 ; |        | $DEDC
       .byte $00 ; |        | $DEDD
       .byte $00 ; |        | $DEDE
       .byte $00 ; |        | $DEDF
       .byte $00 ; |        | $DEE0
       .byte $00 ; |        | $DEE1
       .byte $00 ; |        | $DEE2
       .byte $00 ; |        | $DEE3
       .byte $00 ; |        | $DEE4
       .byte $00 ; |        | $DEE5
       .byte $00 ; |        | $DEE6
       .byte $00 ; |        | $DEE7
       .byte $00 ; |        | $DEE8
       .byte $00 ; |        | $DEE9
       .byte $00 ; |        | $DEEA
       .byte $00 ; |        | $DEEB
       .byte $00 ; |        | $DEEC
       .byte $50 ; | X X    | $DEED
       .byte $28 ; |  X X   | $DEEE
       .byte $A8 ; |X X X   | $DEEF
       .byte $5E ; | X XXXX | $DEF0
       .byte $1F ; |   XXXXX| $DEF1
       .byte $BB ; |X XXX XX| $DEF2
       .byte $51 ; | X X   X| $DEF3
       .byte $18 ; |   XX   | $DEF4
       .byte $1C ; |   XXX  | $DEF5
       .byte $0C ; |    XX  | $DEF6
       .byte $00 ; |        | $DEF7
       .byte $00 ; |        | $DEF8
       .byte $00 ; |        | $DEF9
       .byte $00 ; |        | $DEFA
       .byte $00 ; |        | $DEFB
       .byte $00 ; |        | $DEFC
       .byte $00 ; |        | $DEFD
       .byte $00 ; |        | $DEFE
       .byte $00 ; |        | $DEFF
LDF00: .byte $00 ; |        | $DF00
       .byte $80 ; |X       | $DF01
       .byte $A0 ; |X X     | $DF02
       .byte $A8 ; |X X X   | $DF03
       .byte $AA ; |X X X X | $DF04
       .byte $AA ; |X X X X | $DF05
       .byte $AA ; |X X X X | $DF06
       .byte $AA ; |X X X X | $DF07
LDF08: .byte $00 ; |        | $DF08
       .byte $00 ; |        | $DF09
       .byte $00 ; |        | $DF0A
       .byte $00 ; |        | $DF0B
       .byte $00 ; |        | $DF0C
       .byte $01 ; |       X| $DF0D
       .byte $05 ; |     X X| $DF0E
       .byte $15 ; |   X X X| $DF0F
LDF10: .byte $1C ; |   XXX  | $DF10
       .byte $23 ; |  X   XX| $DF11
       .byte $2A ; |  X X X | $DF12
       .byte $31 ; |  XX   X| $DF13
       .byte $38 ; |  XXX   | $DF14
       .byte $3F ; |  XXXXXX| $DF15
       .byte $46 ; | X   XX | $DF16
       .byte $4D ; | X  XX X| $DF17
       .byte $54 ; | X X X  | $DF18
       .byte $5B ; | X XX XX| $DF19
       .byte $62 ; | XX   X | $DF1A
       .byte $69 ; | XX X  X| $DF1B
       .byte $38 ; |  XXX   | $DF1C
       .byte $6C ; | XX XX  | $DF1D
       .byte $C6 ; |XX   XX | $DF1E
       .byte $C6 ; |XX   XX | $DF1F
       .byte $C6 ; |XX   XX | $DF20
       .byte $6C ; | XX XX  | $DF21
       .byte $38 ; |  XXX   | $DF22
       .byte $7E ; | XXXXXX | $DF23
       .byte $18 ; |   XX   | $DF24
       .byte $18 ; |   XX   | $DF25
       .byte $18 ; |   XX   | $DF26
       .byte $18 ; |   XX   | $DF27
       .byte $38 ; |  XXX   | $DF28
       .byte $18 ; |   XX   | $DF29
       .byte $FE ; |XXXXXXX | $DF2A
       .byte $C0 ; |XX      | $DF2B
       .byte $E0 ; |XXX     | $DF2C
       .byte $3C ; |  XXXX  | $DF2D
       .byte $06 ; |     XX | $DF2E
       .byte $C6 ; |XX   XX | $DF2F
       .byte $7C ; | XXXXX  | $DF30
       .byte $FC ; |XXXXXX  | $DF31
       .byte $06 ; |     XX | $DF32
       .byte $06 ; |     XX | $DF33
       .byte $7C ; | XXXXX  | $DF34
       .byte $06 ; |     XX | $DF35
       .byte $06 ; |     XX | $DF36
       .byte $FC ; |XXXXXX  | $DF37
       .byte $0C ; |    XX  | $DF38
       .byte $0C ; |    XX  | $DF39
       .byte $0C ; |    XX  | $DF3A
       .byte $FE ; |XXXXXXX | $DF3B
       .byte $CC ; |XX  XX  | $DF3C
       .byte $CC ; |XX  XX  | $DF3D
       .byte $CC ; |XX  XX  | $DF3E
       .byte $FC ; |XXXXXX  | $DF3F
       .byte $06 ; |     XX | $DF40
       .byte $06 ; |     XX | $DF41
       .byte $FC ; |XXXXXX  | $DF42
       .byte $C0 ; |XX      | $DF43
       .byte $C0 ; |XX      | $DF44
       .byte $FC ; |XXXXXX  | $DF45
       .byte $7C ; | XXXXX  | $DF46
       .byte $C6 ; |XX   XX | $DF47
       .byte $C6 ; |XX   XX | $DF48
       .byte $FC ; |XXXXXX  | $DF49
       .byte $C0 ; |XX      | $DF4A
       .byte $C0 ; |XX      | $DF4B
       .byte $7C ; | XXXXX  | $DF4C
       .byte $30 ; |  XX    | $DF4D
       .byte $30 ; |  XX    | $DF4E
       .byte $18 ; |   XX   | $DF4F
       .byte $18 ; |   XX   | $DF50
       .byte $0C ; |    XX  | $DF51
       .byte $06 ; |     XX | $DF52
       .byte $FE ; |XXXXXXX | $DF53
       .byte $7C ; | XXXXX  | $DF54
       .byte $C6 ; |XX   XX | $DF55
       .byte $C6 ; |XX   XX | $DF56
       .byte $7C ; | XXXXX  | $DF57
       .byte $C6 ; |XX   XX | $DF58
       .byte $C6 ; |XX   XX | $DF59
       .byte $7C ; | XXXXX  | $DF5A
       .byte $7C ; | XXXXX  | $DF5B
       .byte $06 ; |     XX | $DF5C
       .byte $06 ; |     XX | $DF5D
       .byte $7E ; | XXXXXX | $DF5E
       .byte $C6 ; |XX   XX | $DF5F
       .byte $C6 ; |XX   XX | $DF60
       .byte $7C ; | XXXXX  | $DF61
       .byte $00 ; |        | $DF62
       .byte $00 ; |        | $DF63
       .byte $00 ; |        | $DF64
       .byte $00 ; |        | $DF65
       .byte $00 ; |        | $DF66
       .byte $00 ; |        | $DF67
       .byte $00 ; |        | $DF68
       .byte $38 ; |  XXX   | $DF69
       .byte $6C ; | XX XX  | $DF6A
       .byte $6C ; | XX XX  | $DF6B
       .byte $7C ; | XXXXX  | $DF6C
       .byte $54 ; | X X X  | $DF6D
       .byte $BA ; |X XXX X | $DF6E
       .byte $C6 ; |XX   XX | $DF6F
LDF70: .byte $00 ; |        | $DF70
       .byte $06 ; |     XX | $DF71
       .byte $24 ; |  X  X  | $DF72
       .byte $2A ; |  X X X | $DF73
       .byte $30 ; |  XX    | $DF74
       .byte $36 ; |  XX XX | $DF75
       .byte $3C ; |  XXXX  | $DF76
       .byte $42 ; | X    X | $DF77
       .byte $48 ; | X  X   | $DF78
       .byte $00 ; |        | $DF79
       .byte $0C ; |    XX  | $DF7A
       .byte $18 ; |   XX   | $DF7B
       .byte $12 ; |   X  X | $DF7C
       .byte $1E ; |   XXXX | $DF7D
       .byte $00 ; |        | $DF7E
       .byte $00 ; |        | $DF7F
       .byte $4E ; | X  XXX | $DF80
       .byte $54 ; | X X X  | $DF81
       .byte $5A ; | X XX X | $DF82
       .byte $60 ; | XX     | $DF83
       .byte $00 ; |        | $DF84
       .byte $00 ; |        | $DF85
       .byte $66 ; | XX  XX | $DF86
       .byte $6C ; | XX XX  | $DF87
       .byte $72 ; | XXX  X | $DF88
LDF89: .byte $10 ; |   X    | $DF89
       .byte $10 ; |   X    | $DF8A
       .byte $10 ; |   X    | $DF8B
       .byte $10 ; |   X    | $DF8C
       .byte $10 ; |   X    | $DF8D
       .byte $10 ; |   X    | $DF8E
       .byte $10 ; |   X    | $DF8F
       .byte $10 ; |   X    | $DF90
       .byte $10 ; |   X    | $DF91
       .byte $10 ; |   X    | $DF92
       .byte $10 ; |   X    | $DF93
       .byte $10 ; |   X    | $DF94
       .byte $10 ; |   X    | $DF95
       .byte $10 ; |   X    | $DF96
       .byte $10 ; |   X    | $DF97
       .byte $10 ; |   X    | $DF98
       .byte $10 ; |   X    | $DF99
       .byte $10 ; |   X    | $DF9A
       .byte $10 ; |   X    | $DF9B
       .byte $10 ; |   X    | $DF9C
       .byte $10 ; |   X    | $DF9D
       .byte $10 ; |   X    | $DF9E
       .byte $10 ; |   X    | $DF9F
       .byte $10 ; |   X    | $DFA0
       .byte $10 ; |   X    | $DFA1
       .byte $10 ; |   X    | $DFA2
       .byte $10 ; |   X    | $DFA3
       .byte $10 ; |   X    | $DFA4
       .byte $11 ; |   X   X| $DFA5
       .byte $11 ; |   X   X| $DFA6
       .byte $11 ; |   X   X| $DFA7
       .byte $11 ; |   X   X| $DFA8
LDFA9: .byte $10 ; |   X    | $DFA9
       .byte $10 ; |   X    | $DFAA
       .byte $10 ; |   X    | $DFAB
       .byte $10 ; |   X    | $DFAC
       .byte $10 ; |   X    | $DFAD
       .byte $10 ; |   X    | $DFAE
       .byte $20 ; |  X     | $DFAF
       .byte $20 ; |  X     | $DFB0
       .byte $20 ; |  X     | $DFB1
       .byte $20 ; |  X     | $DFB2
       .byte $20 ; |  X     | $DFB3
       .byte $20 ; |  X     | $DFB4
       .byte $20 ; |  X     | $DFB5
       .byte $20 ; |  X     | $DFB6
       .byte $20 ; |  X     | $DFB7
       .byte $20 ; |  X     | $DFB8
       .byte $20 ; |  X     | $DFB9
       .byte $20 ; |  X     | $DFBA
       .byte $20 ; |  X     | $DFBB
       .byte $20 ; |  X     | $DFBC
       .byte $20 ; |  X     | $DFBD
       .byte $20 ; |  X     | $DFBE
       .byte $20 ; |  X     | $DFBF
       .byte $20 ; |  X     | $DFC0
       .byte $20 ; |  X     | $DFC1
       .byte $20 ; |  X     | $DFC2
       .byte $20 ; |  X     | $DFC3
       .byte $20 ; |  X     | $DFC4
       .byte $20 ; |  X     | $DFC5
       .byte $20 ; |  X     | $DFC6
       .byte $21 ; |  X    X| $DFC7
       .byte $21 ; |  X    X| $DFC8
LDFC9: .byte $34 ; |  XX X  | $DFC9
       .byte $84 ; |X    X  | $DFCA
       .byte $18 ; |   XX   | $DFCB
       .byte $56 ; | X X XX | $DFCC
       .byte $44 ; | X   X  | $DFCD
       .byte $66 ; | XX  XX | $DFCE
       .byte $D6 ; |XX X XX | $DFCF
       .byte $98 ; |X  XX   | $DFD0
       .byte $34 ; |  XX X  | $DFD1
       .byte $84 ; |X    X  | $DFD2
       .byte $E4 ; |XXX  X  | $DFD3
       .byte $10 ; |   X    | $DFD4
       .byte $10 ; |   X    | $DFD5
       .byte $10 ; |   X    | $DFD6
       .byte $54 ; | X X X  | $DFD7
       .byte $7D ; | XXXXX X| $DFD8
       .byte $00 ; |        | $DFD9
       .byte $D3 ; |XX X  XX| $DFDA
       .byte $93 ; |X  X  XX| $DFDB
       .byte $95 ; |X  X X X| $DFDC
       .byte $95 ; |X  X X X| $DFDD
       .byte $95 ; |X  X X X| $DFDE
       .byte $99 ; |X  XX  X| $DFDF
       .byte $D9 ; |XX XX  X| $DFE0
       .byte $00 ; |        | $DFE1
       .byte $33 ; |  XX  XX| $DFE2
       .byte $4A ; | X  X X | $DFE3
       .byte $4A ; | X  X X | $DFE4
       .byte $4B ; | X  X XX| $DFE5
       .byte $4A ; | X  X X | $DFE6
       .byte $4A ; | X  X X | $DFE7
       .byte $4B ; | X  X XX| $DFE8
       .byte $00 ; |        | $DFE9
       .byte $C4 ; |XX   X  | $DFEA
       .byte $40 ; | X      | $DFEB
LDFEC: .byte $8D ; |X   XX X| $DFEC
       .byte $F9 ; |XXXXX  X| $DFED
       .byte $FF ; |XXXXXXXX| $DFEE
       .byte $4C ; | X  XX  | $DFEF
       .byte $88 ; |X   X   | $DFF0
       .byte $D7 ; |XX X XXX| $DFF1
LDFF2: STA    $FFF9   ;4
       JMP    LD974   ;3
       .byte $00 ; |        | $DFF8
LDFF9: .byte $00 ; |        | $DFF9
       .byte $00 ; |        | $DFFA
LDFFB: .byte $00

       ORG $DFFC

       .word START
       .byte $DE,$F4

