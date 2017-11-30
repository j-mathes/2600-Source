; Disassembly of centiped.002
; Disassembled Sun Mar 28 11:08:18 2004
; Using DiStella v2.0
;
; Command Line: C:\BIN\DISTELLA.EXE -pafsccent2.cfg centiped.002 
;
; cent2.cfg contents:
;
;      CODE F000 F0D4
;      GFX F0D5 F0E6
;      CODE F0E7 F29D
;      GFX F29E F2A7
;      CODE F2A8 F525
;      GFX F526 F535
;      CODE F536 F6FA
;      GFX F6FB F702
;      CODE F703 F741
;      GFX F742 F761
;      CODE F762 FA9F
;      GFX FAA0 FABF
;      CODE FAC0 FE26
;      GFX FE27 FFEB
;      CODE FFEC FFF7
;      GFX FFF8 FFFA

      processor 6502
VSYNC   =  $00
VBLANK  =  $01
WSYNC   =  $02
AUDC0   =  $15
AUDC1   =  $16
AUDF0   =  $17
AUDF1   =  $18
AUDV0   =  $19
AUDV1   =  $1A
INPT4   =  $3C
SWCHA   =  $0280
SWCHB   =  $0282
INTIM   =  $0284
TIM64T  =  $0296

       ORG $F000

START:
       LDA    #$01    ;2
       NOP            ;2
       SEI            ;2
       CLD            ;2
       LDX    #$FF    ;2
       LDA    #$00    ;2
LF009: STA    WSYNC,X ;4
       DEX            ;2
       BNE    LF009   ;2
       STX    $ED     ;3
       LDA    #$E0    ;2
       STA    $F2     ;3
       STA    $F4     ;3
       JMP    LF116   ;3
LF019: LDA    #$00    ;2
       STA    $A6     ;3
       LDA    #$30    ;2
       STA    $ED     ;3
LF021: LDX    #$26    ;2
LF023: LDA    LFEA8,X ;4
       STA    $AD,X   ;4
       DEX            ;2
       BPL    LF023   ;2
       STX    $F7     ;3
       STX    $F9     ;3
       INX            ;2
       STX    $F0     ;3
       STX    AUDV0   ;3
       STX    $F6     ;3
       STX    $F5     ;3
       STX    $F4     ;3
LF03A: LDA    #$3C    ;2
       STA    $EF     ;3
       LDA    #$38    ;2
       STA    $F1     ;3
       LDX    $F4     ;3
       LDA    $ED     ;3
       SEC            ;2
       SBC    #$01    ;2
       AND    #$0F    ;2
       CPX    #$04    ;2
       BMI    LF051   ;2
       AND    #$0E    ;2
LF051: STA    $AA     ;3
       LDA    $ED     ;3
       AND    #$F0    ;2
       ORA    $AA     ;3
       STA    $ED     ;3
       LDX    #$12    ;2
       LDA    #$16    ;2
LF05F: STA    $94,X   ;4
       DEX            ;2
       BPL    LF05F   ;2
       STX    $FC     ;3
       INX            ;2
       STX    AUDV0   ;3
       STX    AUDV1   ;3
       LDA    $A7     ;3
       AND    #$60    ;2
       ORA    #$16    ;2
       STA    $A7     ;3
       LDA    $ED     ;3
       CMP    #$10    ;2
       BCS    LF081   ;2
       LDA    $A6     ;3
       ORA    #$40    ;2
       STA    $A6     ;3
       BNE    LF08A   ;2
LF081: SEC            ;2
       SBC    #$10    ;2
       STA    $ED     ;3
       LDA    #$00    ;2
       STA    $FE     ;3
LF08A: LDX    #$08    ;2
       STX    $F2     ;3
       LDX    $F4     ;3
       LDA    $ED     ;3
       CPX    #$04    ;2
       BMI    LF098   ;2
       ORA    #$01    ;2
LF098: CLC            ;2
       ADC    #$01    ;2
       AND    #$0F    ;2
       STA    $AA     ;3
       LDA    $ED     ;3
       AND    #$F0    ;2
       ORA    $AA     ;3
       STA    $ED     ;3
       LDA    #$0F    ;2
       BIT    $A7     ;3
       BVS    LF0B2   ;2
       SEC            ;2
       SBC    $ED     ;3
       AND    #$0F    ;2
LF0B2: CLC            ;2
       ADC    #$03    ;2
       LSR            ;2
       STA    $AA     ;3
       LDA    #$3C    ;2
       LDY    #$B3    ;2
       LDX    #$00    ;2
LF0BE: CPX    $AA     ;3
       BMI    LF0E7   ;2
       LDA    LF0D5,X ;4
       STA    $E4,X   ;4
       LDA    LF0DE,X ;4
       STA    $DB,X   ;4
       LDA    $94,X   ;4
       ORA    #$40    ;2
       STA    $94,X   ;4
       JMP    LF102   ;3
LF0D5: .byte $40 ; | X      | $F0D5
       .byte $2F ; |  X XXXX| $F0D6
       .byte $4D ; | X  XX X| $F0D7
       .byte $0E ; |    XXX | $F0D8
       .byte $6C ; | XX XX  | $F0D9
       .byte $1F ; |   XXXXX| $F0DA
       .byte $5D ; | X XXX X| $F0DB
       .byte $02 ; |      X | $F0DC
       .byte $7C ; | XXXXX  | $F0DD
LF0DE: .byte $33 ; |  XX  XX| $F0DE
       .byte $12 ; |   X  X | $F0DF
       .byte $32 ; |  XX  X | $F0E0
       .byte $12 ; |   X  X | $F0E1
       .byte $32 ; |  XX  X | $F0E2
       .byte $12 ; |   X  X | $F0E3
       .byte $33 ; |  XX  XX| $F0E4
       .byte $13 ; |   X  XX| $F0E5
       .byte $33 ; |  XX  XX| $F0E6
LF0E7: CLC            ;2
       ADC    #$04    ;2
       STA    $E4,X   ;4
       STY    $DB,X   ;4
       LDA    $ED     ;3
       AND    #$01    ;2
       BEQ    LF0FC   ;2
       LDA    $94,X   ;4
       AND    #$9F    ;2
       STA    $94,X   ;4
       BNE    LF102   ;2
LF0FC: LDA    $94,X   ;4
       ORA    #$40    ;2
       STA    $94,X   ;4
LF102: INX            ;2
       LDA    $E3,X   ;4
       CPX    #$09    ;2
       BNE    LF0BE   ;2
       LDA    #$33    ;2
       STA    $DB     ;3
       LDA    $9D     ;3
       AND    #$DF    ;2
       STA    $9D     ;3
       JMP    LF8A9   ;3
LF116: LDX    #$02    ;2
       STX    WSYNC   ;3
       STX    VSYNC   ;3
       STX    VBLANK  ;3
       STX    WSYNC   ;3
       STX    WSYNC   ;3
       STX    WSYNC   ;3
       LDX    #$00    ;2
       STX    VSYNC   ;3
       LDX    #$2B    ;2
       STX    TIM64T  ;4
       LDA    $F4     ;3
       CMP    #$E0    ;2
       BNE    LF136   ;2
       JMP    LFFEC   ;3
LF136: INC    $A9     ;5
       BIT    $A6     ;3
       BVC    LF140   ;2
       BIT    INPT4   ;3
       BPL    LF16B   ;2
LF140: LDA    SWCHB   ;4
       LSR            ;2
       BCC    LF16B   ;2
       LSR            ;2
       LDA    $FF     ;3
       BNE    LF16E   ;2
       BCS    LF16E   ;2
       STA    $F4     ;3
       STA    $F5     ;3
       STA    $F6     ;3
       LDA    #$0F    ;2
       STA    $FF     ;3
       LDA    $A6     ;3
       ORA    #$40    ;2
       STA    $A6     ;3
       LDA    $A7     ;3
       EOR    #$40    ;2
       STA    $A7     ;3
       LDA    $ED     ;3
       AND    #$0F    ;2
       STA    $ED     ;3
       BPL    LF16E   ;2
LF16B: JMP    LF019   ;3
LF16E: LDA    $FF     ;3
       BEQ    LF174   ;2
       DEC    $FF     ;5
LF174: LDA    $A3     ;3
       AND    #$60    ;2
       BEQ    LF1A6   ;2
       CMP    #$60    ;2
       BEQ    LF18E   ;2
       LDA    $A9     ;3
       AND    #$1F    ;2
       BNE    LF1A6   ;2
       LDA    #$20    ;2
       CLC            ;2
       ADC    $A3     ;3
       STA    $A3     ;3
       JMP    LF1A6   ;3
LF18E: LDA    $A3     ;3
       AND    #$9F    ;2
       STA    $A3     ;3
       LDA    $A4     ;3
       ORA    #$40    ;2
       STA    $A4     ;3
       LDA    #$FE    ;2
       STA    $EB     ;3
       LDA    #$20    ;2
       STA    $EC     ;3
       LDA    #$00    ;2
       STA    $E9     ;3
LF1A6: BIT    $A4     ;3
       BVS    LF1AD   ;2
       JMP    LF283   ;3
LF1AD: STA    $F0     ;3
       LDY    #$32    ;2
       STY    $EA     ;3
       LDY    $EB     ;3
       LDX    $EC     ;3
       LDA    $E9     ;3
       AND    #$03    ;2
       BNE    LF1F4   ;2
LF1BD: DEC    $EA     ;5
       BEQ    LF1E0   ;2
       INY            ;2
       INY            ;2
       TXA            ;2
       EOR    #$20    ;2
       TAX            ;2
       CPY    #$28    ;2
       BMI    LF1E8   ;2
       INX            ;2
       LDY    #$00    ;2
       CPX    #$10    ;2
       BMI    LF1D3   ;2
       INY            ;2
LF1D3: CPX    #$20    ;2
       BNE    LF1E8   ;2
       JMP    LF26F   ;3
LF1DA: LDA    #$00    ;2
       STA    AUDV0   ;3
       STA    AUDF0   ;3
LF1E0: STY    $EB     ;3
       STX    $EC     ;3
       JMP    LF8A9   ;3
       INY            ;2
LF1E8: LDA.wy $00AD,Y ;4
       AND    LFED0,X ;4
       BEQ    LF1BD   ;2
       STY    $EB     ;3
       STX    $EC     ;3
LF1F4: LDA    $E9     ;3
       INC    $E9     ;5
       AND    #$02    ;2
       BNE    LF1DA   ;2
       TYA            ;2
       LSR            ;2
       EOR    #$FF    ;2
       CLC            ;2
       ADC    #$14    ;2
       TAY            ;2
       TXA            ;2
       AND    #$DF    ;2
       ASL            ;2
       ASL            ;2
       BEQ    LF20D   ;2
       SBC    #$01    ;2
LF20D: TAX            ;2
       STX    $80,Y   ;4
       LDA    $E9     ;3
       AND    #$03    ;2
       STA    $AA     ;3
       LDA.wy $0094,Y ;4
       AND    #$E0    ;2
       ORA    #$10    ;2
       ORA    $AA     ;3
       STA.wy $0094,Y ;5
       BIT    $A6     ;3
       BVS    LF26C   ;2
       BIT    $A5     ;3
       BVS    LF236   ;2
       LDA    #$08    ;2
       STA    AUDC0   ;3
       LDA    #$0A    ;2
       STA    AUDF0   ;3
       LDA    #$FF    ;2
       STA    AUDV0   ;3
LF236: LDA    $E9     ;3
       AND    #$07    ;2
       CMP    #$01    ;2
       BNE    LF26C   ;2
       SED            ;2
       CLC            ;2
       LDA    #$05    ;2
       ADC    $F6     ;3
       STA    $F6     ;3
       LDA    #$00    ;2
       ADC    $F5     ;3
       STA    $F5     ;3
       BCC    LF26B   ;2
       LDA    #$00    ;2
       ADC    $F4     ;3
       STA    $F4     ;3
       CLD            ;2
       LDA    $ED     ;3
       CMP    #$70    ;2
       BPL    LF26B   ;2
       ADC    #$10    ;2
       STA    $ED     ;3
       LDA    $A5     ;3
       ORA    #$20    ;2
       STA    $A5     ;3
       LDA    $A9     ;3
       AND    #$0F    ;2
       STA    $A9     ;3
LF26B: CLD            ;2
LF26C: JMP    LF8A9   ;3
LF26F: LDA    $A4     ;3
       AND    #$BF    ;2
       STA    $A4     ;3
       LDA    #$F0    ;2
       STA    $F2     ;3
       BIT    $A6     ;3
       BVS    LF280   ;2
       JMP    LF8A9   ;3
LF280: JMP    LFFEC   ;3
LF283: LDY    #$00    ;2
       LDA    #$FF    ;2
       STA    $A8     ;3
       LDA    $F2     ;3
       BPL    LF2A8   ;2
       CMP    #$F0    ;2
       BNE    LF294   ;2
       JMP    LF03A   ;3
LF294: CMP    #$E0    ;2
       BNE    LF29B   ;2
       JMP    LF021   ;3
LF29B: JMP    LF08A   ;3
LF29E: .byte $00 ; |        | $F29E
       .byte $00 ; |        | $F29F
       .byte $01 ; |       X| $F2A0
       .byte $01 ; |       X| $F2A1
       .byte $02 ; |      X | $F2A2
       .byte $02 ; |      X | $F2A3
       .byte $03 ; |      XX| $F2A4
       .byte $04 ; |     X  | $F2A5
       .byte $05 ; |     X X| $F2A6
       .byte $06 ; |     XX | $F2A7
LF2A8: BIT    $A6     ;3
       BVS    LF301   ;2
       BIT    $A5     ;3
       BVS    LF301   ;2
       LDA    $FD     ;3
       AND    #$0C    ;2
       BEQ    LF2CF   ;2
       CMP    #$0C    ;2
       BEQ    LF2C5   ;2
       CLC            ;2
       LDA    #$04    ;2
       ADC    $FD     ;3
       STA    $FD     ;3
       LDA    #$08    ;2
       BNE    LF2D7   ;2
LF2C5: LDA    #$F3    ;2
       AND    $FD     ;3
       STA    $FD     ;3
       LDA    #$08    ;2
       BNE    LF2D7   ;2
LF2CF: LDA    $A9     ;3
       AND    #$0F    ;2
       BNE    LF2E1   ;2
       LDA    #$0F    ;2
LF2D7: STA    AUDF0   ;3
       STA    AUDC0   ;3
       LDA    #$0F    ;2
       STA    AUDV0   ;3
       BNE    LF301   ;2
LF2E1: LDX    $F1     ;3
       LDA    LFF90,X ;4
       CLC            ;2
       ADC    #$03    ;2
       SBC    $F0     ;3
       TAY            ;2
       LDX    #$00    ;2
       CPY    #$09    ;2
       BEQ    LF2FB   ;2
       BPL    LF2FD   ;2
       LDX    #$FF    ;2
       LDA    LF29E,Y ;4
       LDY    #$08    ;2
LF2FB: STY    AUDC0   ;3
LF2FD: STX    AUDV0   ;3
       STA    AUDF0   ;3
LF301: LDA    $A3     ;3
       AND    #$60    ;2
       BEQ    LF329   ;2
       LDA    #$FF    ;2
       STA    $FC     ;3
       STA    $F7     ;3
       STA    $F9     ;3
       BIT    $A6     ;3
       BVS    LF329   ;2
       BIT    $A5     ;3
       BVS    LF329   ;2
       STA    AUDV0   ;3
       LDA    #$08    ;2
       STA    AUDC0   ;3
       LDA    $A9     ;3
       AND    #$01    ;2
       BNE    LF325   ;2
       INC    $FB     ;5
LF325: LDA    $FB     ;3
       STA    AUDF0   ;3
LF329: LDY    #$00    ;2
       STY    $AC     ;3
       STY    $AB     ;3
       LDA    $DB     ;3
LF331: AND    #$1F    ;2
       STA    $AA     ;3
       LDX    #$00    ;2
       STY    $D3     ;3
LF339: CPY    $F2     ;3
       BEQ    LF361   ;2
       INY            ;2
       LDA.wy $00DB,Y ;4
       AND    #$1F    ;2
       CMP    $AA     ;3
       BNE    LF339   ;2
       LDA.wy $00DB,Y ;4
       BPL    LF355   ;2
       LDA.wy $00DA,Y ;4
       AND    #$1F    ;2
       CMP    $AA     ;3
       BEQ    LF339   ;2
LF355: LDA    $AC     ;3
       ORA    LFFCF,Y ;4
       STA    $AC     ;3
       INX            ;2
       STY    $D3,X   ;4
       BNE    LF339   ;2
LF361: CPX    #$00    ;2
       BEQ    LF38B   ;2
       LDA    $A9     ;3
       CPX    #$01    ;2
       BEQ    LF37B   ;2
       CPX    #$02    ;2
       BEQ    LF380   ;2
       CPX    #$03    ;2
       BEQ    LF388   ;2
       AND    #$3F    ;2
       TAY            ;2
       LDX    LFE68,Y ;4
       BPL    LF38B   ;2
LF37B: AND    #$01    ;2
       TAX            ;2
       BPL    LF38B   ;2
LF380: AND    #$3F    ;2
       TAY            ;2
       LDX    LFE28,Y ;4
       BPL    LF38B   ;2
LF388: AND    #$03    ;2
       TAX            ;2
LF38B: LDY    $D3,X   ;4
       LDA.wy $00E4,Y ;4
       LDX    $AA     ;3
       STA    $80,X   ;4
       INC    $94,X   ;6
LF396: CPY    $F2     ;3
       BEQ    LF3B6   ;2
       INY            ;2
       LDA.wy $00DB,Y ;4
       BPL    LF3B6   ;2
       LDA.wy $00DB,Y ;4
       AND    #$1F    ;2
       CMP    $AA     ;3
       BNE    LF3B6   ;2
       INC    $94,X   ;6
       LDA.wy $00E4,Y ;4
       CMP    $80,X   ;4
       BCS    LF396   ;2
       STA    $80,X   ;4
       BCC    LF396   ;2
LF3B6: LDA    $94,X   ;4
       AND    #$1F    ;2
       CMP    #$1A    ;2
       BMI    LF3CB   ;2
       AND    #$01    ;2
       BEQ    LF3CB   ;2
       STX    $A8     ;3
       LDA    $80,X   ;4
       CLC            ;2
       ADC    #$04    ;2
       STA    $80,X   ;4
LF3CB: LDY    $AB     ;3
       CPY    $F2     ;3
       BEQ    LF426   ;2
       INY            ;2
       STY    $AB     ;3
       LDA    $AC     ;3
       AND    LFFCF,Y ;4
       BNE    LF3CB   ;2
       LDA.wy $00DB,Y ;4
       BPL    LF3F0   ;2
       LDA.wy $00DB,Y ;4
       AND    #$1F    ;2
       STA    $AA     ;3
       LDA.wy $00DA,Y ;4
       AND    #$1F    ;2
       CMP    $AA     ;3
       BEQ    LF3CB   ;2
LF3F0: LDA.wy $00DB,Y ;4
       JMP    LF331   ;3
LF3F6: LDA    #$FF    ;2
       STA    $FC     ;3
       JMP    LF570   ;3
LF3FD: LDA    $FC     ;3
       EOR    #$40    ;2
LF401: STA    $FC     ;3
       LDA    $FD     ;3
       AND    #$FD    ;2
       STA    $FD     ;3
       ADC    $E4     ;3
       ADC    $DC     ;3
       ADC    INTIM   ;4
       AND    #$02    ;2
       ORA    $FD     ;3
       STA    $FD     ;3
       JMP    LF4D1   ;3
LF419: LDA    $FC     ;3
       AND    #$BF    ;2
       JMP    LF401   ;3
LF420: LDA    $FC     ;3
       ORA    #$40    ;2
       BNE    LF401   ;2
LF426: LDA    #$00    ;2
       STA    $D3     ;3
       STA    $D4     ;3
       LDA    $FC     ;3
       CMP    #$FF    ;2
       BEQ    LF494   ;2
       BIT    $FD     ;3
       BVS    LF48E   ;2
       BMI    LF48E   ;2
       LDA    $A9     ;3
       AND    #$07    ;2
       CMP    #$02    ;2
       BEQ    LF491   ;2
       CMP    #$04    ;2
       BEQ    LF491   ;2
       LDA    $FB     ;3
       CMP    #$79    ;2
       BEQ    LF3F6   ;2
       CMP    #$00    ;2
       BEQ    LF3F6   ;2
       LDA    $FD     ;3
       AND    #$02    ;2
       BEQ    LF467   ;2
       LDA    $FD     ;3
       AND    #$01    ;2
       AND    $A9     ;3
       BNE    LF467   ;2
       BIT    $FC     ;3
       BMI    LF465   ;2
       DEC    $FB     ;5
       JMP    LF467   ;3
LF465: INC    $FB     ;5
LF467: LDA    $A9     ;3
       AND    #$03    ;2
       BNE    LF491   ;2
       LDA    $FD     ;3
       AND    #$01    ;2
       BEQ    LF479   ;2
       LDA    $A9     ;3
       AND    #$04    ;2
       BNE    LF491   ;2
LF479: LDA    $FC     ;3
       AND    #$1F    ;2
       BEQ    LF419   ;2
       CMP    #$07    ;2
       BEQ    LF420   ;2
       ADC    $E5     ;3
       ADC    $F0     ;3
       AND    #$AB    ;2
       BNE    LF4D1   ;2
       JMP    LF3FD   ;3
LF48E: JMP    LF4DF   ;3
LF491: JMP    LF536   ;3
LF494: LDA    $A9     ;3
       CMP    #$37    ;2
       BNE    LF4C3   ;2
       LDA    $A3     ;3
       AND    #$60    ;2
       BNE    LF4C3   ;2
       LDX    #$00    ;2
       LDA    $F4     ;3
       BNE    LF4AD   ;2
       LDA    $F5     ;3
       CMP    #$50    ;2
       BPL    LF4AD   ;2
       INX            ;2
LF4AD: TXA            ;2
       ORA    #$02    ;2
       STA    $FD     ;3
       LDA    INTIM   ;4
       ADC    $EF     ;3
       AND    #$04    ;2
       BEQ    LF4C6   ;2
       LDA    #$01    ;2
       STA    $FB     ;3
       LDA    #$E6    ;2
       STA    $FC     ;3
LF4C3: JMP    LF570   ;3
LF4C6: LDA    #$78    ;2
       STA    $FB     ;3
       LDA    #$46    ;2
       STA    $FC     ;3
       JMP    LF570   ;3
LF4D1: BIT    $FC     ;3
       BVC    LF4DA   ;2
       DEC    $FC     ;5
       JMP    LF536   ;3
LF4DA: INC    $FC     ;5
       JMP    LF536   ;3
LF4DF: LDA    $FC     ;3
       AND    #$1F    ;2
       TAY            ;2
       LDA.wy $0094,Y ;4
       AND    #$1F    ;2
       CMP    #$16    ;2
       BEQ    LF4F2   ;2
       LDA    $A9     ;3
       LSR            ;2
       BCS    LF570   ;2
LF4F2: LDA    $FD     ;3
       AND    #$C0    ;2
       CLC            ;2
       ROL            ;2
       ROL            ;2
       ROL            ;2
       ADC    #$05    ;2
       STA    $AA     ;3
       LDA.wy $0094,Y ;4
       AND    #$E0    ;2
       ORA    $AA     ;3
       STA.wy $0094,Y ;5
       LDX    $FB     ;3
       STX    $80,Y   ;4
       LDA    $A9     ;3
       AND    #$0F    ;2
       BNE    LF570   ;2
       LDA    $FD     ;3
       ADC    #$10    ;2
       STA    $FD     ;3
       AND    #$30    ;2
       BNE    LF570   ;2
       LDA    #$FF    ;2
       STA    $FC     ;3
       LDA    #$00    ;2
       STA    $FD     ;3
       BEQ    LF570   ;2
LF526: .byte $1E ; |   XXXX | $F526
       .byte $1B ; |   XX XX| $F527
       .byte $12 ; |   X  X | $F528
       .byte $00 ; |        | $F529
       .byte $12 ; |   X  X | $F52A
       .byte $1B ; |   XX XX| $F52B
       .byte $1E ; |   XXXX | $F52C
       .byte $1B ; |   XX XX| $F52D
       .byte $12 ; |   X  X | $F52E
       .byte $00 ; |        | $F52F
       .byte $1E ; |   XXXX | $F530
       .byte $1B ; |   XX XX| $F531
       .byte $12 ; |   X  X | $F532
       .byte $00 ; |        | $F533
       .byte $12 ; |   X  X | $F534
       .byte $1B ; |   XX XX| $F535
LF536: LDA    $FC     ;3
       AND    #$1F    ;2
       TAY            ;2
       LDA    $A9     ;3
       AND    #$18    ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       ADC    #$02    ;2
       STA    $AA     ;3
       LDA.wy $0094,Y ;4
       AND    #$E0    ;2
       ORA    $AA     ;3
       STA.wy $0094,Y ;5
       LDX    $FB     ;3
       STX    $80,Y   ;4
       BIT    $A6     ;3
       BVS    LF570   ;2
       BIT    $A5     ;3
       BVS    LF570   ;2
       LDA    #$04    ;2
       STA    AUDC1   ;3
       LDA    $A9     ;3
       AND    #$3F    ;2
       LSR            ;2
       LSR            ;2
       TAY            ;2
       LDA    LF526,Y ;4
       STA    AUDF1   ;3
       LDA    #$07    ;2
       BPL    LF572   ;2
LF570: LDA    #$00    ;2
LF572: STA    AUDV1   ;3
       LDA    $F7     ;3
       BPL    LF57B   ;2
       JMP    LF615   ;3
LF57B: LDA    $A9     ;3
       AND    #$0F    ;2
       BEQ    LF597   ;2
       CMP    #$05    ;2
       BEQ    LF597   ;2
       CMP    #$0A    ;2
       BEQ    LF597   ;2
       AND    #$03    ;2
       BNE    LF5DE   ;2
       LDA    $F4     ;3
       CMP    #$06    ;2
       BPL    LF597   ;2
       BIT    $F8     ;3
       BVC    LF5DE   ;2
LF597: DEC    $F8     ;5
       LDA    $F8     ;3
       AND    #$1E    ;2
       CMP    #$1E    ;2
       BNE    LF5AA   ;2
       LDX    #$FF    ;2
       STX    $F7     ;3
       INX            ;2
       STX    $F8     ;3
       BEQ    LF612   ;2
LF5AA: ADC    $AD     ;3
       ADC    $BA     ;3
       ADC    $B5     ;3
       ADC    $F8     ;3
       TAY            ;2
       LDA    LF570,Y ;4
       BMI    LF5DE   ;2
       LDA    $F7     ;3
       LSR            ;2
       LSR            ;2
       TAY            ;2
       LDA    $F8     ;3
       LSR            ;2
       TYA            ;2
       BCS    LF5C5   ;2
       ADC    #$20    ;2
LF5C5: TAX            ;2
       LDA    #$13    ;2
       SEC            ;2
       SBC    $F8     ;3
       AND    #$1F    ;2
       ASL            ;2
       TAY            ;2
       TXA            ;2
       AND    #$10    ;2
       BEQ    LF5D5   ;2
       INY            ;2
LF5D5: LDA.wy $00AD,Y ;4
       ORA    LFED0,X ;4
       STA.wy $00AD,Y ;5
LF5DE: LDA    $F8     ;3
       AND    #$1F    ;2
       TAY            ;2
       LDA.wy $0094,Y ;4
       AND    #$E0    ;2
       TAX            ;2
       LDA    $A9     ;3
       AND    #$02    ;2
       BNE    LF5F0   ;2
       INX            ;2
LF5F0: STX    $94,Y   ;4
       LDX    $F7     ;3
       STX    $80,Y   ;4
       LDA    $A9     ;3
       AND    #$01    ;2
       BEQ    LF612   ;2
       BIT    $A6     ;3
       BVS    LF612   ;2
       BIT    $A5     ;3
       BVS    LF612   ;2
       LDA    $F8     ;3
       EOR    #$FF    ;2
       STA    AUDF1   ;3
       LDA    #$0F    ;2
       STA    AUDV1   ;3
       LDA    #$0D    ;2
       STA    AUDC1   ;3
LF612: JMP    LF766   ;3
LF615: BIT    $F8     ;3
       BMI    LF61F   ;2
       LDA    $A9     ;3
       CMP    #$29    ;2
       BNE    LF672   ;2
LF61F: LDA    INTIM   ;4
       CMP    #$13    ;2
       BMI    LF65A   ;2
       LDA    $F9     ;3
       CMP    #$FF    ;2
       BNE    LF672   ;2
       LDA    $ED     ;3
       AND    #$0F    ;2
       BEQ    LF672   ;2
       LDX    #$0F    ;2
       LDA    #$00    ;2
       STA    $F9     ;3
LF638: LDA    $C3,X   ;4
       LSR            ;2
       TAY            ;2
       LDA    LFF10,Y ;4
       ADC    $F9     ;3
       STA    $F9     ;3
       DEX            ;2
       BPL    LF638   ;2
       STX    $F9     ;3
       CMP    #$05    ;2
       BMI    LF65D   ;2
       CMP    #$0A    ;2
       BPL    LF656   ;2
       LDA    $F4     ;3
       CMP    #$12    ;2
       BPL    LF65D   ;2
LF656: LDA    #$7F    ;2
       STA    $F8     ;3
LF65A: JMP    LF766   ;3
LF65D: ADC    $EF     ;3
       ADC    $B4     ;3
       ADC    $DB     ;3
       ADC    $FC     ;3
       AND    #$1F    ;2
       ASL            ;2
       ASL            ;2
       STA    $F7     ;3
       LDA    #$13    ;2
       STA    $F8     ;3
       JMP    LF766   ;3
LF672: LDA    $F9     ;3
       CMP    #$FF    ;2
       BNE    LF67B   ;2
       JMP    LF703   ;3
LF67B: BIT    $FA     ;3
       BPL    LF6AC   ;2
       BVC    LF683   ;2
       DEC    $F9     ;5
LF683: DEC    $F9     ;5
       BPL    LF6B6   ;2
LF687: LDA    #$FF    ;2
       STA    $F9     ;3
       LDA    #$13    ;2
       SEC            ;2
       SBC    $FA     ;3
       AND    #$1F    ;2
       ASL            ;2
       TAY            ;2
       LDA.wy $00AD,Y ;4
       BNE    LF69E   ;2
       LDA.wy $00AE,Y ;4
       BEQ    LF6A9   ;2
LF69E: LDA    $FA     ;3
       AND    #$1F    ;2
       TAX            ;2
       LDA    $94,X   ;4
       ORA    #$80    ;2
       STA    $94,X   ;4
LF6A9: JMP    LF766   ;3
LF6AC: BVC    LF6B0   ;2
       INC    $F9     ;5
LF6B0: INC    $F9     ;5
       CMP    #$77    ;2
       BPL    LF687   ;2
LF6B6: LDX    #$0A    ;2
       LDA    $FA     ;3
       BPL    LF6BD   ;2
       INX            ;2
LF6BD: AND    #$1F    ;2
       TAY            ;2
       LDA    $A9     ;3
       AND    #$08    ;2
       BEQ    LF6C8   ;2
       INX            ;2
       INX            ;2
LF6C8: LDA.wy $0094,Y ;4
       AND    #$E0    ;2
       STA.wy $0094,Y ;5
       TXA            ;2
       ORA.wy $0094,Y ;4
       STA.wy $0094,Y ;5
       LDX    $F9     ;3
       STX    $80,Y   ;4
       BIT    $A6     ;3
       BVS    LF6F8   ;2
       BIT    $A6     ;3
       BVS    LF6F8   ;2
       LDA    $A9     ;3
       LSR            ;2
       BCC    LF6F8   ;2
       AND    #$07    ;2
       TAY            ;2
       LDA    LF6FB,Y ;4
       STA    AUDF1   ;3
       LDA    #$0D    ;2
       STA    AUDC1   ;3
       LDA    #$0F    ;2
       STA    AUDV1   ;3
LF6F8: JMP    LF766   ;3
LF6FB: .byte $0C ; |    XX  | $F6FB
       .byte $14 ; |   X X  | $F6FC
       .byte $0C ; |    XX  | $F6FD
       .byte $14 ; |   X X  | $F6FE
       .byte $0A ; |    X X | $F6FF
       .byte $18 ; |   XX   | $F700
       .byte $0A ; |    X X | $F701
       .byte $18 ; |   XX   | $F702
LF703: LDA    $A9     ;3
       CMP    #$93    ;2
       BNE    LF766   ;2
       LDA    $ED     ;3
       AND    #$0F    ;2
       CMP    #$03    ;2
       BMI    LF766   ;2
       LDA    $B1     ;3
       ADC    $DB     ;3
       ADC    $E4     ;3
       ADC    $FB     ;3
       AND    #$03    ;2
       BNE    LF766   ;2
       LDA    $E5     ;3
       ADC    $DD     ;3
       ADC    $F6     ;3
       ADC    $B3     ;3
       AND    #$1F    ;2
       TAY            ;2
       LDA    $F4     ;3
       CMP    #$02    ;2
       BMI    LF735   ;2
       TYA            ;2
       AND    #$03    ;2
       BEQ    LF735   ;2
       LDA    #$40    ;2
LF735: ORA    LF742,Y ;4
       STA    $FA     ;3
       BMI    LF762   ;2
       LDA    #$00    ;2
       STA    $F9     ;3
       BEQ    LF766   ;2
LF742: .byte $09 ; |    X  X| $F742
       .byte $8A ; |X   X X | $F743
       .byte $0B ; |    X XX| $F744
       .byte $8C ; |X   XX  | $F745
       .byte $0D ; |    XX X| $F746
       .byte $8E ; |X   XXX | $F747
       .byte $0F ; |    XXXX| $F748
       .byte $90 ; |X  X    | $F749
       .byte $11 ; |   X   X| $F74A
       .byte $92 ; |X  X  X | $F74B
       .byte $13 ; |   X  XX| $F74C
       .byte $89 ; |X   X  X| $F74D
       .byte $0A ; |    X X | $F74E
       .byte $8B ; |X   X XX| $F74F
       .byte $0C ; |    XX  | $F750
       .byte $0D ; |    XX X| $F751
       .byte $8E ; |X   XXX | $F752
       .byte $0A ; |    X X | $F753
       .byte $89 ; |X   X  X| $F754
       .byte $0F ; |    XXXX| $F755
       .byte $90 ; |X  X    | $F756
       .byte $91 ; |X  X   X| $F757
       .byte $92 ; |X  X  X | $F758
       .byte $93 ; |X  X  XX| $F759
       .byte $13 ; |   X  XX| $F75A
       .byte $12 ; |   X  X | $F75B
       .byte $91 ; |X  X   X| $F75C
       .byte $90 ; |X  X    | $F75D
       .byte $09 ; |    X  X| $F75E
       .byte $08 ; |    X   | $F75F
       .byte $8A ; |X   X X | $F760
       .byte $12 ; |   X  X | $F761
LF762: LDA    #$77    ;2
       STA    $F9     ;3
LF766: LDA    $A3     ;3
       AND    #$60    ;2
       BEQ    LF798   ;2
       LDY    $F1     ;3
       LDA    LFF90,Y ;4
       EOR    #$FF    ;2
       CLC            ;2
       ADC    #$13    ;2
       TAY            ;2
       LDA    $A9     ;3
       LSR            ;2
       LSR            ;2
       AND    #$03    ;2
       CLC            ;2
       ADC    #$10    ;2
       STA.wy $0094,Y ;5
       LDA    $EF     ;3
       SEC            ;2
       SBC    #$04    ;2
       BPL    LF78C   ;2
       LDA    #$00    ;2
LF78C: STA.wy $0080,Y ;5
       LDA    #$61    ;2
       STA    $D9     ;3
       STA    $DA     ;3
       JMP    LFFF2   ;3
LF798: BIT    $A6     ;3
       BVC    LF79F   ;2
       JMP    LF837   ;3
LF79F: LDA    SWCHA   ;4
       ASL            ;2
       ASL            ;2
       BPL    LF7B5   ;2
       ASL            ;2
       BMI    LF7BF   ;2
       DEC    $F1     ;5
       LDA    $F1     ;3
       CMP    #$2D    ;2
       BNE    LF7BF   ;2
       INC    $F1     ;5
       BNE    LF7BF   ;2
LF7B5: INC    $F1     ;5
       LDA    $F1     ;3
       CMP    #$39    ;2
       BNE    LF7BF   ;2
       DEC    $F1     ;5
LF7BF: LDA    SWCHA   ;4
       BPL    LF804   ;2
       ASL            ;2
       BPL    LF7DD   ;2
       LDA    $EF     ;3
       AND    #$03    ;2
       BEQ    LF7D7   ;2
       LDA    $FE     ;3
       AND    #$C0    ;2
       STA    $FE     ;3
       BMI    LF7F1   ;2
       BPL    LF81A   ;2
LF7D7: LDA    #$00    ;2
       STA    $FE     ;3
       BEQ    LF825   ;2
LF7DD: LDA    $A9     ;3
       AND    #$07    ;2
       BNE    LF7F3   ;2
       LDA    $FE     ;3
       BMI    LF7EB   ;2
       LDA    #$80    ;2
       STA    $FE     ;3
LF7EB: AND    #$3F    ;2
       CMP    #$03    ;2
       BEQ    LF7F3   ;2
LF7F1: INC    $FE     ;5
LF7F3: LDA    $FE     ;3
       AND    #$3F    ;2
       EOR    #$FF    ;2
       CLC            ;2
       ADC    #$01    ;2
       CLC            ;2
       ADC    $EF     ;3
       STA    $EF     ;3
       JMP    LF825   ;3
LF804: LDA    $A9     ;3
       AND    #$07    ;2
       BNE    LF81C   ;2
       LDA    $FE     ;3
       BIT    $FE     ;3
       BVS    LF814   ;2
       LDA    #$40    ;2
       STA    $FE     ;3
LF814: AND    #$3F    ;2
       CMP    #$03    ;2
       BEQ    LF81C   ;2
LF81A: INC    $FE     ;5
LF81C: LDA    $FE     ;3
       AND    #$3F    ;2
       CLC            ;2
       ADC    $EF     ;3
       STA    $EF     ;3
LF825: LDA    $EF     ;3
       BPL    LF82D   ;2
       LDA    #$00    ;2
       STA    $EF     ;3
LF82D: CMP    #$7D    ;2
       BMI    LF890   ;2
       LDA    #$7C    ;2
       STA    $EF     ;3
       BNE    LF890   ;2
LF837: LDA    $A9     ;3
       BPL    LF88A   ;2
       AND    #$01    ;2
       BNE    LF865   ;2
       BIT    $FE     ;3
       BPL    LF855   ;2
       LDA    $F1     ;3
       CMP    #$38    ;2
       BNE    LF851   ;2
       LDA    $FE     ;3
       EOR    #$80    ;2
       STA    $FE     ;3
       BPL    LF865   ;2
LF851: INC    $F1     ;5
       BNE    LF865   ;2
LF855: LDA    $F1     ;3
       CMP    #$2C    ;2
       BNE    LF863   ;2
       LDA    $FE     ;3
       EOR    #$80    ;2
       STA    $FE     ;3
       BMI    LF865   ;2
LF863: DEC    $F1     ;5
LF865: BIT    $FE     ;3
       BVC    LF87A   ;2
       LDA    $EF     ;3
       BNE    LF876   ;2
       LDA    $FE     ;3
       EOR    #$40    ;2
       STA    $FE     ;3
       JMP    LF88A   ;3
LF876: DEC    $EF     ;5
       BPL    LF88A   ;2
LF87A: LDA    $EF     ;3
       CMP    #$7C    ;2
       BNE    LF888   ;2
       LDA    $FE     ;3
       EOR    #$40    ;2
       STA    $FE     ;3
       BNE    LF88A   ;2
LF888: INC    $EF     ;5
LF88A: LDA    $F0     ;3
       BNE    LF8A7   ;2
       BEQ    LF898   ;2
LF890: LDA    $F0     ;3
       BNE    LF8A7   ;2
       LDA    INPT4   ;3
       BMI    LF8A9   ;2
LF898: LDX    $EF     ;3
       INX            ;2
       STX    $EE     ;3
       LDX    $F1     ;3
       LDA    LFF90,X ;4
       CLC            ;2
       ADC    #$02    ;2
       STA    $F0     ;3
LF8A7: DEC    $F0     ;5
LF8A9: LDA    $F0     ;3
       BEQ    LF8B3   ;2
       ASL            ;2
       ADC    $F0     ;3
       SEC            ;2
       SBC    #$02    ;2
LF8B3: STA    $D9     ;3
       LDA    $F1     ;3
       SEC            ;2
       SBC    $D9     ;3
       STA    $DA     ;3
       LDA    $D9     ;3
       BNE    LF8C4   ;2
       DEC    $D9     ;5
       INC    $DA     ;5
LF8C4: JMP    LFFF2   ;3
LF8C7: LDX    #$24    ;2
       STX    TIM64T  ;4
       BIT    $A4     ;3
       BVC    LF8D3   ;2
       JMP    LFE1F   ;3
LF8D3: LDA    $9D     ;3
       AND    #$20    ;2
       BEQ    LF91B   ;2
       LDA    $A9     ;3
       LDX    $F4     ;3
       CPX    #$10    ;2
       BMI    LF8E5   ;2
       AND    #$3F    ;2
       BPL    LF8ED   ;2
LF8E5: CPX    #$04    ;2
       BMI    LF8ED   ;2
       AND    #$7F    ;2
       BPL    LF8ED   ;2
LF8ED: CMP    #$0D    ;2
       BNE    LF91B   ;2
       LDX    $F2     ;3
       CPX    #$08    ;2
       BEQ    LF91B   ;2
       INX            ;2
       STX    $F2     ;3
       LDA    $EF     ;3
       ADC    $FB     ;3
       LSR            ;2
       BCC    LF90B   ;2
       LDA    #$00    ;2
       STA    $E4,X   ;4
       LDA    #$26    ;2
       STA    $DB,X   ;4
       BNE    LF913   ;2
LF90B: LDA    #$7C    ;2
       STA    $E4,X   ;4
       LDA    #$06    ;2
       STA    $DB,X   ;4
LF913: LDA    $94,X   ;4
       AND    #$DF    ;2
       ORA    #$40    ;2
       STA    $94,X   ;4
LF91B: LDX    #$00    ;2
       LDA    $F0     ;3
       BNE    LF924   ;2
       JMP    LFC10   ;3
LF924: LDA    #$FF    ;2
       STA    $D6     ;3
       LDA    #$14    ;2
       SEC            ;2
       SBC    $F0     ;3
       STA    $AC     ;3
LF92F: LDA    $EE     ;3
       SEC            ;2
       SBC    $E4,X   ;4
       CMP    #$04    ;2
       BCS    LF93C   ;2
       CMP    #$00    ;2
       BCS    LF946   ;2
LF93C: CPX    $F2     ;3
       BNE    LF943   ;2
       JMP    LF9DF   ;3
LF943: INX            ;2
       BPL    LF92F   ;2
LF946: LDA    $DB,X   ;4
       AND    #$1F    ;2
       CMP    $AC     ;3
       BNE    LF93C   ;2
       DEC    $F2     ;5
       LDY    $E4,X   ;4
       LDA    $DB,X   ;4
       STA    $AB     ;3
       STX    $D6     ;3
       CPX    $F2     ;3
       BMI    LF95E   ;2
       BNE    LF993   ;2
LF95E: LDA    $DC,X   ;4
       AND    #$7F    ;2
       STA    $DB,X   ;4
       LDA    $E5,X   ;4
       STA    $E4,X   ;4
       LDA    $95,X   ;4
       AND    #$60    ;2
       STA    $D3     ;3
       LDA    $94,X   ;4
       AND    #$9F    ;2
       ORA    $D3     ;3
       STA    $94,X   ;4
LF976: CPX    $F2     ;3
       BEQ    LF993   ;2
       INX            ;2
       LDA    $DC,X   ;4
       STA    $DB,X   ;4
       LDA    $E5,X   ;4
       STA    $E4,X   ;4
       LDA    $95,X   ;4
       AND    #$60    ;2
       STA    $D3     ;3
       LDA    $94,X   ;4
       AND    #$9F    ;2
       ORA    $D3     ;3
       STA    $94,X   ;4
       BPL    LF976   ;2
LF993: BIT    $A6     ;3
       BVS    LF9D4   ;2
       BIT    $AB     ;3
       SED            ;2
       CLC            ;2
       BMI    LF9C4   ;2
       LDA    #$01    ;2
LF99F: ADC    $F5     ;3
       STA    $F5     ;3
       BCC    LF9CE   ;2
       LDA    #$00    ;2
       ADC    $F4     ;3
       STA    $F4     ;3
       CLD            ;2
       LDA    $ED     ;3
       CMP    #$70    ;2
       BPL    LF9CE   ;2
       ADC    #$10    ;2
       STA    $ED     ;3
       LDA    $A5     ;3
       ORA    #$20    ;2
       STA    $A5     ;3
       LDA    $A9     ;3
       AND    #$0F    ;2
       STA    $A9     ;3
       BPL    LF9CE   ;2
LF9C4: LDA    #$0A    ;2
       ADC    $F6     ;3
       STA    $F6     ;3
       LDA    #$00    ;2
       BEQ    LF99F   ;2
LF9CE: LDA    $FD     ;3
       ORA    #$04    ;2
       STA    $FD     ;3
LF9D4: CLD            ;2
       LDX    $D6     ;3
       DEX            ;2
       CPX    $F2     ;3
       BPL    LF9E3   ;2
       JMP    LF943   ;3
LF9DF: LDX    $D6     ;3
       BMI    LFA26   ;2
LF9E3: LDA    $F0     ;3
       LSR            ;2
       TYA            ;2
       BCC    LF9EB   ;2
       SBC    #$04    ;2
LF9EB: TAY            ;2
       LDA    $AB     ;3
       AND    #$20    ;2
       BNE    LF9F7   ;2
       TYA            ;2
       CLC            ;2
       ADC    #$07    ;2
       TAY            ;2
LF9F7: TYA            ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       ASL            ;2
       TAY            ;2
       LDA    $F0     ;3
       LSR            ;2
       TYA            ;2
       BCS    LFA05   ;2
       ADC    #$1F    ;2
LFA05: TAX            ;2
       INX            ;2
       CMP    #$3F    ;2
       BMI    LFA0D   ;2
       LDX    #$3F    ;2
LFA0D: LDA    $F0     ;3
       SEC            ;2
       SBC    #$01    ;2
       ASL            ;2
       TAY            ;2
       TXA            ;2
       AND    #$10    ;2
       BEQ    LFA1A   ;2
       INY            ;2
LFA1A: LDA.wy $00AD,Y ;4
       ORA    LFED0,X ;4
       JMP    LFBE8   ;3
LFA23: JMP    LFAC0   ;3
LFA26: BIT    $FD     ;3
       BVS    LFA23   ;2
       BMI    LFA23   ;2
       LDA    $FC     ;3
       CMP    #$FF    ;2
       BEQ    LFA23   ;2
       LDA    $EE     ;3
       SEC            ;2
       SBC    $FB     ;3
       CMP    #$09    ;2
       BCC    LFA3E   ;2
       JMP    LFAC0   ;3
LFA3E: CMP    #$FF    ;2
       BMI    LFAC0   ;2
       LDA    $FC     ;3
       AND    #$1F    ;2
       CMP    $AC     ;3
       BEQ    LFA51   ;2
       SEC            ;2
       SBC    #$01    ;2
       CMP    $AC     ;3
       BNE    LFAC0   ;2
LFA51: LDA    #$13    ;2
       SEC            ;2
       SBC    $FC     ;3
       AND    #$1F    ;2
       STA    $AC     ;3
       ASL            ;2
       CLC            ;2
       ADC    $AC     ;3
       SEC            ;2
       SBC    $F1     ;3
       BPL    LFA65   ;2
       EOR    #$FF    ;2
LFA65: TAX            ;2
       LDA    LFAA0,X ;4
       TAY            ;2
       BIT    $A6     ;3
       BVS    LFA93   ;2
       SED            ;2
       CLC            ;2
       ADC    $F5     ;3
       STA    $F5     ;3
       BCC    LFA93   ;2
       LDA    #$00    ;2
       ADC    $F4     ;3
       STA    $F4     ;3
       CLD            ;2
       LDA    $ED     ;3
       CMP    #$70    ;2
       BPL    LFA93   ;2
       ADC    #$10    ;2
       STA    $ED     ;3
       LDA    $A5     ;3
       ORA    #$20    ;2
       STA    $A5     ;3
       LDA    $A9     ;3
       AND    #$0F    ;2
       STA    $A9     ;3
LFA93: CLD            ;2
       TYA            ;2
       LSR            ;2
       LSR            ;2
       TAY            ;2
       LDA    LFABD,Y ;4
       STA    $FD     ;3
       JMP    LFC0A   ;3
LFAA0: .byte $09 ; |    X  X| $FAA0
       .byte $09 ; |    X  X| $FAA1
       .byte $09 ; |    X  X| $FAA2
       .byte $09 ; |    X  X| $FAA3
       .byte $09 ; |    X  X| $FAA4
       .byte $09 ; |    X  X| $FAA5
       .byte $06 ; |     XX | $FAA6
       .byte $06 ; |     XX | $FAA7
       .byte $06 ; |     XX | $FAA8
       .byte $06 ; |     XX | $FAA9
       .byte $06 ; |     XX | $FAAA
       .byte $06 ; |     XX | $FAAB
       .byte $03 ; |      XX| $FAAC
       .byte $03 ; |      XX| $FAAD
       .byte $03 ; |      XX| $FAAE
       .byte $03 ; |      XX| $FAAF
       .byte $03 ; |      XX| $FAB0
       .byte $03 ; |      XX| $FAB1
       .byte $03 ; |      XX| $FAB2
       .byte $03 ; |      XX| $FAB3
       .byte $03 ; |      XX| $FAB4
       .byte $03 ; |      XX| $FAB5
       .byte $03 ; |      XX| $FAB6
       .byte $03 ; |      XX| $FAB7
       .byte $03 ; |      XX| $FAB8
       .byte $03 ; |      XX| $FAB9
       .byte $03 ; |      XX| $FABA
       .byte $03 ; |      XX| $FABB
       .byte $03 ; |      XX| $FABC
LFABD: .byte $44 ; | X   X  | $FABD
       .byte $84 ; |X    X  | $FABE
       .byte $C4 ; |XX   X  | $FABF
LFAC0: LDA    $F7     ;3
       BMI    LFB21   ;2
       LDA    $EE     ;3
       SEC            ;2
       SBC    $F7     ;3
       CMP    #$04    ;2
       BCS    LFB21   ;2
       CMP    #$00    ;2
       BCC    LFB21   ;2
       LDA    $F8     ;3
       AND    #$1F    ;2
       CMP    $AC     ;3
       BEQ    LFAE0   ;2
       SEC            ;2
       SBC    #$01    ;2
       CMP    $AC     ;3
       BNE    LFB21   ;2
LFAE0: BIT    $F8     ;3
       BVS    LFAEC   ;2
       LDA    $F8     ;3
       ORA    #$40    ;2
       STA    $F8     ;3
       BNE    LFB21   ;2
LFAEC: BIT    $A6     ;3
       BVS    LFB17   ;2
       LDA    #$02    ;2
       CLC            ;2
       SED            ;2
       ADC    $F5     ;3
       STA    $F5     ;3
       BCC    LFB17   ;2
       LDA    #$00    ;2
       ADC    $F4     ;3
       STA    $F4     ;3
       CLD            ;2
       LDA    $ED     ;3
       CMP    #$70    ;2
       BPL    LFB17   ;2
       ADC    #$10    ;2
       STA    $ED     ;3
       LDA    $A5     ;3
       ORA    #$20    ;2
       STA    $A5     ;3
       LDA    $A9     ;3
       AND    #$0F    ;2
       STA    $A9     ;3
LFB17: CLD            ;2
       LDY    #$FF    ;2
       STY    $F7     ;3
       STY    $F8     ;3
       JMP    LFC10   ;3
LFB21: BIT    $F9     ;3
       BMI    LFB73   ;2
       LDA    $EE     ;3
       SEC            ;2
       SBC    $F9     ;3
       CMP    #$08    ;2
       BCS    LFB73   ;2
       CMP    #$00    ;2
       BCC    LFB73   ;2
       LDA    $FA     ;3
       AND    #$1F    ;2
       CMP    $AC     ;3
       BNE    LFB73   ;2
       BIT    $A6     ;3
       BVS    LFB6B   ;2
       LDA    #$0A    ;2
       CLC            ;2
       SED            ;2
       ADC    $F5     ;3
       STA    $F5     ;3
       BCC    LFB65   ;2
       LDA    #$00    ;2
       ADC    $F4     ;3
       STA    $F4     ;3
       CLD            ;2
       LDA    $ED     ;3
       CMP    #$70    ;2
       BPL    LFB65   ;2
       ADC    #$10    ;2
       STA    $ED     ;3
       LDA    $A5     ;3
       ORA    #$20    ;2
       STA    $A5     ;3
       LDA    $A9     ;3
       AND    #$0F    ;2
       STA    $A9     ;3
LFB65: LDA    $FD     ;3
       ORA    #$04    ;2
       STA    $FD     ;3
LFB6B: CLD            ;2
       LDY    #$FF    ;2
       STY    $F9     ;3
       JMP    LFC0A   ;3
LFB73: LDA    $EE     ;3
       LSR            ;2
       LSR            ;2
       TAY            ;2
       LDA    $F0     ;3
       LSR            ;2
       TYA            ;2
       BCS    LFB80   ;2
       ADC    #$20    ;2
LFB80: TAX            ;2
       LDA    $F0     ;3
       SEC            ;2
       SBC    #$01    ;2
       ASL            ;2
       TAY            ;2
       TXA            ;2
       AND    #$10    ;2
       BEQ    LFB8E   ;2
       INY            ;2
LFB8E: LDA.wy $00AD,Y ;4
       AND    LFED0,X ;4
       BEQ    LFC10   ;2
       CPX    $F3     ;3
       BEQ    LFBA5   ;2
       TXA            ;2
       ORA    #$80    ;2
       CMP    $F3     ;3
       BEQ    LFBAC   ;2
       STX    $F3     ;3
       BNE    LFC0A   ;2
LFBA5: TXA            ;2
       ORA    #$80    ;2
       STA    $F3     ;3
       BNE    LFC0A   ;2
LFBAC: LDA    #$FF    ;2
       STA    $F3     ;3
       BIT    $A6     ;3
       BVS    LFBE1   ;2
       SED            ;2
       LDA    #$01    ;2
       CLC            ;2
       ADC    $F6     ;3
       STA    $F6     ;3
       LDA    #$00    ;2
       ADC    $F5     ;3
       STA    $F5     ;3
       BCC    LFBE1   ;2
       LDA    #$00    ;2
       ADC    $F4     ;3
       STA    $F4     ;3
       CLD            ;2
       LDA    $ED     ;3
       CMP    #$70    ;2
       BPL    LFBE1   ;2
       ADC    #$10    ;2
       STA    $ED     ;3
       LDA    $A5     ;3
       ORA    #$20    ;2
       STA    $A5     ;3
       LDA    $A9     ;3
       AND    #$0F    ;2
       STA    $A9     ;3
LFBE1: CLD            ;2
       LDA.wy $00AD,Y ;4
       EOR    LFED0,X ;4
LFBE8: STA.wy $00AD,Y ;5
       BNE    LFC0A   ;2
       TYA            ;2
       LSR            ;2
       BCC    LFC07   ;2
       DEY            ;2
LFBF2: LDX    $AD,Y   ;4
       BNE    LFC0A   ;2
       SEC            ;2
       SBC    #$13    ;2
       EOR    #$FF    ;2
       CLC            ;2
       ADC    #$01    ;2
       TAX            ;2
       LDA    $94,X   ;4
       AND    #$7F    ;2
       STA    $94,X   ;4
       BPL    LFC0A   ;2
LFC07: INY            ;2
       BCC    LFBF2   ;2
LFC0A: LDA    #$00    ;2
       STA    AUDV0   ;3
       STA    $F0     ;3
LFC10: LDA    $F2     ;3
       BPL    LFC17   ;2
       JMP    LFE1F   ;3
LFC17: LDX    #$00    ;2
       LDA    #$3A    ;2
       SEC            ;2
       SBC    $F1     ;3
       TAY            ;2
       LDA    LFF90,Y ;4
       STA    $AC     ;3
LFC24: LDA    $A3     ;3
       AND    #$60    ;2
       BNE    LFC53   ;2
       LDA    $EF     ;3
       SEC            ;2
       SBC    $E4,X   ;4
       CMP    #$04    ;2
       BCS    LFC37   ;2
       CMP    #$FD    ;2
       BPL    LFC3E   ;2
LFC37: CPX    $F2     ;3
       BEQ    LFC53   ;2
       INX            ;2
       BNE    LFC24   ;2
LFC3E: LDA    $DB,X   ;4
       AND    #$1F    ;2
       CMP    $AC     ;3
       BNE    LFC37   ;2
       LDA    #$20    ;2
       ORA    $A3     ;3
       STA    $A3     ;3
       LDA    #$00    ;2
       STA    $FB     ;3
       JMP    LFE1F   ;3
LFC53: BIT    $A7     ;3
       BVC    LFC5A   ;2
       JMP    LFCAC   ;3
LFC5A: BIT    $FD     ;3
       BMI    LFC82   ;2
       BVS    LFC82   ;2
       LDA    $EF     ;3
       SEC            ;2
       SBC    $FB     ;3
       CMP    #$08    ;2
       BCS    LFC82   ;2
       CMP    #$FD    ;2
       BMI    LFC82   ;2
       LDA    $FC     ;3
       AND    #$1F    ;2
       CMP    $AC     ;3
       BNE    LFC82   ;2
       LDA    #$20    ;2
       ORA    $A3     ;3
       STA    $A3     ;3
       LDA    #$00    ;2
       STA    $FB     ;3
       JMP    LFE1F   ;3
LFC82: LDA    $F7     ;3
       BMI    LFCAC   ;2
       LDA    $EF     ;3
       SEC            ;2
       SBC    $F7     ;3
       CMP    #$04    ;2
       BCS    LFCAC   ;2
       CMP    #$FD    ;2
       BMI    LFCAC   ;2
       LDA    $F8     ;3
       AND    #$1F    ;2
       CMP    $AC     ;3
       BNE    LFCAC   ;2
       LDA    #$20    ;2
       ORA    $A3     ;3
       STA    $A3     ;3
       LDA    #$00    ;2
       STA    $FB     ;3
       LDA    #$F0    ;2
       STA    $F7     ;3
       JMP    LFE1F   ;3
LFCAC: BIT    $FD     ;3
       BVS    LFCE1   ;2
       BMI    LFCE1   ;2
       LDA    $FB     ;3
       CLC            ;2
       ADC    #$03    ;2
       LSR            ;2
       LSR            ;2
       TAY            ;2
       LDA    $FC     ;3
       CMP    #$FF    ;2
       BEQ    LFCE1   ;2
       LSR            ;2
       TYA            ;2
       BCS    LFCC6   ;2
       ADC    #$20    ;2
LFCC6: TAX            ;2
       LDA    #$13    ;2
       SEC            ;2
       SBC    $FC     ;3
       AND    #$1F    ;2
       ASL            ;2
       TAY            ;2
       TXA            ;2
       AND    #$10    ;2
       BEQ    LFCD6   ;2
       INY            ;2
LFCD6: LDA    LFED0,X ;4
       EOR    #$FF    ;2
       AND.wy $00AD,Y ;4
       STA.wy $00AD,Y ;5
LFCE1: LDA    $A9     ;3
       AND    #$00    ;2
       BNE    LFD0B   ;2
       BIT    $A4     ;3
       BVS    LFD0B   ;2
       LDX    #$00    ;2
       STX    $D7     ;3
       LDX    $F2     ;3
       LDA    $A3     ;3
       AND    #$60    ;2
       BNE    LFD0B   ;2
       LDA    $A9     ;3
       AND    #$07    ;2
       CMP    #$03    ;2
       BEQ    LFD0B   ;2
LFCFF: LDA    $94,X   ;4
       AND    #$40    ;2
       BNE    LFD0E   ;2
       LDA    $A9     ;3
       AND    #$01    ;2
       BEQ    LFD0E   ;2
LFD0B: JMP    LFE1F   ;3
LFD0E: LDA    $DB,X   ;4
       STA    $AC     ;3
       BPL    LFD40   ;2
       LDA    $D7     ;3
       BNE    LFD24   ;2
       LDA    INTIM   ;4
       CMP    #$06    ;2
       BPL    LFD22   ;2
       JMP    LFE1F   ;3
LFD22: STX    $D7     ;3
LFD24: LDA    $DA,X   ;4
       AND    #$1F    ;2
       STA    $AA     ;3
       LDA    $AC     ;3
       AND    #$1F    ;2
       CMP    $AA     ;3
       BEQ    LFD6C   ;2
       LDA    $E4,X   ;4
       AND    #$03    ;2
       BNE    LFD6C   ;2
       LDA    $DA,X   ;4
       ORA    #$80    ;2
       STA    $DB,X   ;4
       BNE    LFD78   ;2
LFD40: LDA    $DC,X   ;4
       BMI    LFD4E   ;2
       LDA    INTIM   ;4
       CMP    #$06    ;2
       BPL    LFD4E   ;2
       JMP    LFE1F   ;3
LFD4E: LDA    $AC     ;3
       AND    #$20    ;2
       BNE    LFD5C   ;2
       LDA    $E4,X   ;4
       CMP    #$7C    ;2
       BEQ    LFDD7   ;2
       BNE    LFD64   ;2
LFD5C: LDA    $E4,X   ;4
       BEQ    LFDD7   ;2
       CMP    #$7C    ;2
       BEQ    LFD6C   ;2
LFD64: CMP    #$00    ;2
       BEQ    LFD6C   ;2
       AND    #$03    ;2
       BEQ    LFD86   ;2
LFD6C: LDA    $AC     ;3
       AND    #$20    ;2
       BNE    LFD76   ;2
       INC    $E4,X   ;6
       BNE    LFD78   ;2
LFD76: DEC    $E4,X   ;6
LFD78: BIT    $AC     ;3
       BMI    LFD80   ;2
       LDA    #$00    ;2
       STA    $D7     ;3
LFD80: DEX            ;2
       BMI    LFD0B   ;2
       JMP    LFCFF   ;3
LFD86: LDA    $E4,X   ;4
       LSR            ;2
       LSR            ;2
       TAY            ;2
       LDA    $AC     ;3
       LSR            ;2
       AND    #$10    ;2
       BNE    LFD94   ;2
       INY            ;2
       INY            ;2
LFD94: DEY            ;2
       BMI    LFD6C   ;2
       TYA            ;2
       BCS    LFD9C   ;2
       ADC    #$20    ;2
LFD9C: STA    $D5     ;3
       TAY            ;2
       LDA    $94,X   ;4
       AND    #$20    ;2
       BEQ    LFDAC   ;2
       LDA    LFED0,Y ;4
       BNE    LFDD7   ;2
       BEQ    LFD6C   ;2
LFDAC: LDA    $AC     ;3
       AND    #$1F    ;2
       STA    $AB     ;3
       LDA    #$13    ;2
       SEC            ;2
       SBC    $AB     ;3
       ASL            ;2
       TAY            ;2
       LDA    $D5     ;3
       AND    #$10    ;2
       BEQ    LFDC0   ;2
       INY            ;2
LFDC0: LDA.wy $00AD,Y ;4
       LDY    $D5     ;3
       AND    LFED0,Y ;4
       BEQ    LFD6C   ;2
       LDY    $AB     ;3
       LDA.wy $0094,Y ;4
       BPL    LFDD7   ;2
       LDA    $94,X   ;4
       ORA    #$20    ;2
       STA    $94,X   ;4
LFDD7: LDA    $AC     ;3
       TAY            ;2
       AND    #$1F    ;2
       BEQ    LFDE8   ;2
       CMP    #$05    ;2
       BNE    LFE0F   ;2
       BIT    $AC     ;3
       BVC    LFE16   ;2
       BVS    LFE0A   ;2
LFDE8: LDA    $94,X   ;4
       AND    #$20    ;2
       BEQ    LFDF7   ;2
       LDA    $94,X   ;4
       AND    #$DF    ;2
       STA    $94,X   ;4
       JMP    LFE0A   ;3
LFDF7: LDA    $9D     ;3
       ORA    #$20    ;2
       STA    $9D     ;3
       LDA    $D7     ;3
       BEQ    LFE0A   ;2
       TAY            ;2
       LDA.wy $00DB,Y ;4
       EOR    #$A0    ;2
       STA.wy $00DB,Y ;5
LFE0A: LDA    $AC     ;3
       EOR    #$40    ;2
       TAY            ;2
LFE0F: TYA            ;2
       AND    #$40    ;2
       BEQ    LFE16   ;2
       INY            ;2
       INY            ;2
LFE16: DEY            ;2
       TYA            ;2
       EOR    #$20    ;2
       STA    $DB,X   ;4
       JMP    LFD78   ;3
LFE1F: LDX    INTIM   ;4
       BNE    LFE1F   ;2
       JMP    LF116   ;3
       .byte $40 ; | X      | $FE27
LFE28: .byte $00 ; |        | $FE28
       .byte $01 ; |       X| $FE29
       .byte $02 ; |      X | $FE2A
       .byte $00 ; |        | $FE2B
       .byte $01 ; |       X| $FE2C
       .byte $02 ; |      X | $FE2D
       .byte $00 ; |        | $FE2E
       .byte $01 ; |       X| $FE2F
       .byte $02 ; |      X | $FE30
       .byte $00 ; |        | $FE31
       .byte $01 ; |       X| $FE32
       .byte $02 ; |      X | $FE33
       .byte $00 ; |        | $FE34
       .byte $01 ; |       X| $FE35
       .byte $02 ; |      X | $FE36
       .byte $00 ; |        | $FE37
       .byte $01 ; |       X| $FE38
       .byte $02 ; |      X | $FE39
       .byte $00 ; |        | $FE3A
       .byte $01 ; |       X| $FE3B
       .byte $02 ; |      X | $FE3C
       .byte $00 ; |        | $FE3D
       .byte $01 ; |       X| $FE3E
       .byte $02 ; |      X | $FE3F
       .byte $00 ; |        | $FE40
       .byte $01 ; |       X| $FE41
       .byte $02 ; |      X | $FE42
       .byte $00 ; |        | $FE43
       .byte $01 ; |       X| $FE44
       .byte $02 ; |      X | $FE45
       .byte $00 ; |        | $FE46
       .byte $01 ; |       X| $FE47
       .byte $02 ; |      X | $FE48
       .byte $00 ; |        | $FE49
       .byte $01 ; |       X| $FE4A
       .byte $02 ; |      X | $FE4B
       .byte $00 ; |        | $FE4C
       .byte $01 ; |       X| $FE4D
       .byte $02 ; |      X | $FE4E
       .byte $00 ; |        | $FE4F
       .byte $01 ; |       X| $FE50
       .byte $02 ; |      X | $FE51
       .byte $00 ; |        | $FE52
       .byte $01 ; |       X| $FE53
       .byte $02 ; |      X | $FE54
       .byte $00 ; |        | $FE55
       .byte $01 ; |       X| $FE56
       .byte $02 ; |      X | $FE57
       .byte $00 ; |        | $FE58
       .byte $01 ; |       X| $FE59
       .byte $02 ; |      X | $FE5A
       .byte $00 ; |        | $FE5B
       .byte $01 ; |       X| $FE5C
       .byte $02 ; |      X | $FE5D
       .byte $00 ; |        | $FE5E
       .byte $01 ; |       X| $FE5F
       .byte $02 ; |      X | $FE60
       .byte $00 ; |        | $FE61
       .byte $01 ; |       X| $FE62
       .byte $02 ; |      X | $FE63
       .byte $00 ; |        | $FE64
       .byte $01 ; |       X| $FE65
       .byte $02 ; |      X | $FE66
       .byte $00 ; |        | $FE67
LFE68: .byte $00 ; |        | $FE68
       .byte $01 ; |       X| $FE69
       .byte $02 ; |      X | $FE6A
       .byte $03 ; |      XX| $FE6B
       .byte $04 ; |     X  | $FE6C
       .byte $00 ; |        | $FE6D
       .byte $01 ; |       X| $FE6E
       .byte $02 ; |      X | $FE6F
       .byte $03 ; |      XX| $FE70
       .byte $04 ; |     X  | $FE71
       .byte $00 ; |        | $FE72
       .byte $01 ; |       X| $FE73
       .byte $02 ; |      X | $FE74
       .byte $03 ; |      XX| $FE75
       .byte $04 ; |     X  | $FE76
       .byte $00 ; |        | $FE77
       .byte $01 ; |       X| $FE78
       .byte $02 ; |      X | $FE79
       .byte $03 ; |      XX| $FE7A
       .byte $04 ; |     X  | $FE7B
       .byte $00 ; |        | $FE7C
       .byte $01 ; |       X| $FE7D
       .byte $02 ; |      X | $FE7E
       .byte $03 ; |      XX| $FE7F
       .byte $04 ; |     X  | $FE80
       .byte $00 ; |        | $FE81
       .byte $01 ; |       X| $FE82
       .byte $02 ; |      X | $FE83
       .byte $03 ; |      XX| $FE84
       .byte $04 ; |     X  | $FE85
       .byte $00 ; |        | $FE86
       .byte $01 ; |       X| $FE87
       .byte $02 ; |      X | $FE88
       .byte $03 ; |      XX| $FE89
       .byte $04 ; |     X  | $FE8A
       .byte $00 ; |        | $FE8B
       .byte $01 ; |       X| $FE8C
       .byte $02 ; |      X | $FE8D
       .byte $03 ; |      XX| $FE8E
       .byte $04 ; |     X  | $FE8F
       .byte $00 ; |        | $FE90
       .byte $01 ; |       X| $FE91
       .byte $02 ; |      X | $FE92
       .byte $03 ; |      XX| $FE93
       .byte $04 ; |     X  | $FE94
       .byte $00 ; |        | $FE95
       .byte $01 ; |       X| $FE96
       .byte $02 ; |      X | $FE97
       .byte $03 ; |      XX| $FE98
       .byte $04 ; |     X  | $FE99
       .byte $00 ; |        | $FE9A
       .byte $01 ; |       X| $FE9B
       .byte $02 ; |      X | $FE9C
       .byte $03 ; |      XX| $FE9D
       .byte $04 ; |     X  | $FE9E
       .byte $00 ; |        | $FE9F
       .byte $01 ; |       X| $FEA0
       .byte $02 ; |      X | $FEA1
       .byte $03 ; |      XX| $FEA2
       .byte $04 ; |     X  | $FEA3
       .byte $00 ; |        | $FEA4
       .byte $01 ; |       X| $FEA5
       .byte $02 ; |      X | $FEA6
       .byte $03 ; |      XX| $FEA7
LFEA8: .byte $00 ; |        | $FEA8
       .byte $00 ; |        | $FEA9
       .byte $00 ; |        | $FEAA
       .byte $84 ; |X    X  | $FEAB
       .byte $00 ; |        | $FEAC
       .byte $30 ; |  XX    | $FEAD
       .byte $00 ; |        | $FEAE
       .byte $0A ; |    X X | $FEAF
       .byte $01 ; |       X| $FEB0
       .byte $00 ; |        | $FEB1
       .byte $20 ; |  X     | $FEB2
       .byte $00 ; |        | $FEB3
       .byte $80 ; |X       | $FEB4
       .byte $00 ; |        | $FEB5
       .byte $10 ; |   X    | $FEB6
       .byte $10 ; |   X    | $FEB7
       .byte $03 ; |      XX| $FEB8
       .byte $10 ; |   X    | $FEB9
       .byte $40 ; | X      | $FEBA
       .byte $00 ; |        | $FEBB
       .byte $00 ; |        | $FEBC
       .byte $02 ; |      X | $FEBD
       .byte $01 ; |       X| $FEBE
       .byte $00 ; |        | $FEBF
       .byte $00 ; |        | $FEC0
       .byte $08 ; |    X   | $FEC1
       .byte $00 ; |        | $FEC2
       .byte $42 ; | X    X | $FEC3
       .byte $00 ; |        | $FEC4
       .byte $20 ; |  X     | $FEC5
       .byte $41 ; | X     X| $FEC6
       .byte $00 ; |        | $FEC7
       .byte $18 ; |   XX   | $FEC8
       .byte $00 ; |        | $FEC9
       .byte $01 ; |       X| $FECA
       .byte $40 ; | X      | $FECB
       .byte $00 ; |        | $FECC
       .byte $00 ; |        | $FECD
       .byte $00 ; |        | $FECE
       .byte $00 ; |        | $FECF
LFED0: .byte $00 ; |        | $FED0
       .byte $40 ; | X      | $FED1
       .byte $00 ; |        | $FED2
       .byte $10 ; |   X    | $FED3
       .byte $00 ; |        | $FED4
       .byte $04 ; |     X  | $FED5
       .byte $00 ; |        | $FED6
       .byte $01 ; |       X| $FED7
       .byte $00 ; |        | $FED8
       .byte $02 ; |      X | $FED9
       .byte $00 ; |        | $FEDA
       .byte $08 ; |    X   | $FEDB
       .byte $00 ; |        | $FEDC
       .byte $20 ; |  X     | $FEDD
       .byte $00 ; |        | $FEDE
       .byte $80 ; |X       | $FEDF
       .byte $00 ; |        | $FEE0
       .byte $40 ; | X      | $FEE1
       .byte $00 ; |        | $FEE2
       .byte $10 ; |   X    | $FEE3
       .byte $00 ; |        | $FEE4
       .byte $04 ; |     X  | $FEE5
       .byte $00 ; |        | $FEE6
       .byte $01 ; |       X| $FEE7
       .byte $00 ; |        | $FEE8
       .byte $02 ; |      X | $FEE9
       .byte $00 ; |        | $FEEA
       .byte $08 ; |    X   | $FEEB
       .byte $00 ; |        | $FEEC
       .byte $20 ; |  X     | $FEED
       .byte $00 ; |        | $FEEE
       .byte $80 ; |X       | $FEEF
       .byte $80 ; |X       | $FEF0
       .byte $00 ; |        | $FEF1
       .byte $20 ; |  X     | $FEF2
       .byte $00 ; |        | $FEF3
       .byte $08 ; |    X   | $FEF4
       .byte $00 ; |        | $FEF5
       .byte $02 ; |      X | $FEF6
       .byte $00 ; |        | $FEF7
       .byte $01 ; |       X| $FEF8
       .byte $00 ; |        | $FEF9
       .byte $04 ; |     X  | $FEFA
       .byte $00 ; |        | $FEFB
       .byte $10 ; |   X    | $FEFC
       .byte $00 ; |        | $FEFD
       .byte $40 ; | X      | $FEFE
       .byte $00 ; |        | $FEFF
       .byte $80 ; |X       | $FF00
       .byte $00 ; |        | $FF01
       .byte $20 ; |  X     | $FF02
       .byte $00 ; |        | $FF03
       .byte $08 ; |    X   | $FF04
       .byte $00 ; |        | $FF05
       .byte $02 ; |      X | $FF06
       .byte $00 ; |        | $FF07
       .byte $01 ; |       X| $FF08
       .byte $00 ; |        | $FF09
       .byte $04 ; |     X  | $FF0A
       .byte $00 ; |        | $FF0B
       .byte $10 ; |   X    | $FF0C
       .byte $00 ; |        | $FF0D
       .byte $40 ; | X      | $FF0E
       .byte $00 ; |        | $FF0F
LFF10: .byte $00 ; |        | $FF10
       .byte $01 ; |       X| $FF11
       .byte $01 ; |       X| $FF12
       .byte $02 ; |      X | $FF13
       .byte $01 ; |       X| $FF14
       .byte $02 ; |      X | $FF15
       .byte $02 ; |      X | $FF16
       .byte $03 ; |      XX| $FF17
       .byte $01 ; |       X| $FF18
       .byte $02 ; |      X | $FF19
       .byte $02 ; |      X | $FF1A
       .byte $03 ; |      XX| $FF1B
       .byte $02 ; |      X | $FF1C
       .byte $03 ; |      XX| $FF1D
       .byte $03 ; |      XX| $FF1E
       .byte $04 ; |     X  | $FF1F
       .byte $01 ; |       X| $FF20
       .byte $02 ; |      X | $FF21
       .byte $02 ; |      X | $FF22
       .byte $03 ; |      XX| $FF23
       .byte $02 ; |      X | $FF24
       .byte $03 ; |      XX| $FF25
       .byte $03 ; |      XX| $FF26
       .byte $04 ; |     X  | $FF27
       .byte $02 ; |      X | $FF28
       .byte $03 ; |      XX| $FF29
       .byte $03 ; |      XX| $FF2A
       .byte $04 ; |     X  | $FF2B
       .byte $03 ; |      XX| $FF2C
       .byte $04 ; |     X  | $FF2D
       .byte $04 ; |     X  | $FF2E
       .byte $05 ; |     X X| $FF2F
       .byte $01 ; |       X| $FF30
       .byte $02 ; |      X | $FF31
       .byte $02 ; |      X | $FF32
       .byte $03 ; |      XX| $FF33
       .byte $02 ; |      X | $FF34
       .byte $03 ; |      XX| $FF35
       .byte $03 ; |      XX| $FF36
       .byte $04 ; |     X  | $FF37
       .byte $02 ; |      X | $FF38
       .byte $03 ; |      XX| $FF39
       .byte $03 ; |      XX| $FF3A
       .byte $04 ; |     X  | $FF3B
       .byte $03 ; |      XX| $FF3C
       .byte $04 ; |     X  | $FF3D
       .byte $04 ; |     X  | $FF3E
       .byte $05 ; |     X X| $FF3F
       .byte $02 ; |      X | $FF40
       .byte $03 ; |      XX| $FF41
       .byte $03 ; |      XX| $FF42
       .byte $04 ; |     X  | $FF43
       .byte $03 ; |      XX| $FF44
       .byte $04 ; |     X  | $FF45
       .byte $04 ; |     X  | $FF46
       .byte $05 ; |     X X| $FF47
       .byte $03 ; |      XX| $FF48
       .byte $04 ; |     X  | $FF49
       .byte $04 ; |     X  | $FF4A
       .byte $05 ; |     X X| $FF4B
       .byte $04 ; |     X  | $FF4C
       .byte $05 ; |     X X| $FF4D
       .byte $05 ; |     X X| $FF4E
       .byte $06 ; |     XX | $FF4F
       .byte $01 ; |       X| $FF50
       .byte $02 ; |      X | $FF51
       .byte $02 ; |      X | $FF52
       .byte $03 ; |      XX| $FF53
       .byte $02 ; |      X | $FF54
       .byte $03 ; |      XX| $FF55
       .byte $03 ; |      XX| $FF56
       .byte $04 ; |     X  | $FF57
       .byte $02 ; |      X | $FF58
       .byte $03 ; |      XX| $FF59
       .byte $03 ; |      XX| $FF5A
       .byte $04 ; |     X  | $FF5B
       .byte $03 ; |      XX| $FF5C
       .byte $04 ; |     X  | $FF5D
       .byte $04 ; |     X  | $FF5E
       .byte $05 ; |     X X| $FF5F
       .byte $02 ; |      X | $FF60
       .byte $03 ; |      XX| $FF61
       .byte $03 ; |      XX| $FF62
       .byte $04 ; |     X  | $FF63
       .byte $03 ; |      XX| $FF64
       .byte $04 ; |     X  | $FF65
       .byte $04 ; |     X  | $FF66
       .byte $05 ; |     X X| $FF67
       .byte $03 ; |      XX| $FF68
       .byte $04 ; |     X  | $FF69
       .byte $04 ; |     X  | $FF6A
       .byte $05 ; |     X X| $FF6B
       .byte $04 ; |     X  | $FF6C
       .byte $05 ; |     X X| $FF6D
       .byte $05 ; |     X X| $FF6E
       .byte $06 ; |     XX | $FF6F
       .byte $02 ; |      X | $FF70
       .byte $03 ; |      XX| $FF71
       .byte $03 ; |      XX| $FF72
       .byte $04 ; |     X  | $FF73
       .byte $03 ; |      XX| $FF74
       .byte $04 ; |     X  | $FF75
       .byte $04 ; |     X  | $FF76
       .byte $05 ; |     X X| $FF77
       .byte $03 ; |      XX| $FF78
       .byte $04 ; |     X  | $FF79
       .byte $04 ; |     X  | $FF7A
       .byte $05 ; |     X X| $FF7B
       .byte $04 ; |     X  | $FF7C
       .byte $05 ; |     X X| $FF7D
       .byte $05 ; |     X X| $FF7E
       .byte $06 ; |     XX | $FF7F
       .byte $03 ; |      XX| $FF80
       .byte $04 ; |     X  | $FF81
       .byte $04 ; |     X  | $FF82
       .byte $05 ; |     X X| $FF83
       .byte $04 ; |     X  | $FF84
       .byte $05 ; |     X X| $FF85
       .byte $05 ; |     X X| $FF86
       .byte $06 ; |     XX | $FF87
       .byte $04 ; |     X  | $FF88
       .byte $05 ; |     X X| $FF89
       .byte $05 ; |     X X| $FF8A
       .byte $06 ; |     XX | $FF8B
       .byte $05 ; |     X X| $FF8C
       .byte $06 ; |     XX | $FF8D
       .byte $06 ; |     XX | $FF8E
       .byte $07 ; |     XXX| $FF8F
LFF90: .byte $00 ; |        | $FF90
       .byte $00 ; |        | $FF91
       .byte $00 ; |        | $FF92
       .byte $01 ; |       X| $FF93
       .byte $01 ; |       X| $FF94
       .byte $01 ; |       X| $FF95
       .byte $02 ; |      X | $FF96
       .byte $02 ; |      X | $FF97
       .byte $02 ; |      X | $FF98
       .byte $03 ; |      XX| $FF99
       .byte $03 ; |      XX| $FF9A
       .byte $03 ; |      XX| $FF9B
       .byte $04 ; |     X  | $FF9C
       .byte $04 ; |     X  | $FF9D
       .byte $04 ; |     X  | $FF9E
       .byte $05 ; |     X X| $FF9F
       .byte $05 ; |     X X| $FFA0
       .byte $05 ; |     X X| $FFA1
       .byte $06 ; |     XX | $FFA2
       .byte $06 ; |     XX | $FFA3
       .byte $06 ; |     XX | $FFA4
       .byte $07 ; |     XXX| $FFA5
       .byte $07 ; |     XXX| $FFA6
       .byte $07 ; |     XXX| $FFA7
       .byte $08 ; |    X   | $FFA8
       .byte $08 ; |    X   | $FFA9
       .byte $08 ; |    X   | $FFAA
       .byte $09 ; |    X  X| $FFAB
       .byte $09 ; |    X  X| $FFAC
       .byte $09 ; |    X  X| $FFAD
       .byte $0A ; |    X X | $FFAE
       .byte $0A ; |    X X | $FFAF
       .byte $0A ; |    X X | $FFB0
       .byte $0B ; |    X XX| $FFB1
       .byte $0B ; |    X XX| $FFB2
       .byte $0B ; |    X XX| $FFB3
       .byte $0C ; |    XX  | $FFB4
       .byte $0C ; |    XX  | $FFB5
       .byte $0C ; |    XX  | $FFB6
       .byte $0D ; |    XX X| $FFB7
       .byte $0D ; |    XX X| $FFB8
       .byte $0D ; |    XX X| $FFB9
       .byte $0E ; |    XXX | $FFBA
       .byte $0A ; |    X X | $FFBB
       .byte $0E ; |    XXX | $FFBC
       .byte $0F ; |    XXXX| $FFBD
       .byte $0F ; |    XXXX| $FFBE
       .byte $0F ; |    XXXX| $FFBF
       .byte $10 ; |   X    | $FFC0
       .byte $10 ; |   X    | $FFC1
       .byte $10 ; |   X    | $FFC2
       .byte $11 ; |   X   X| $FFC3
       .byte $11 ; |   X   X| $FFC4
       .byte $11 ; |   X   X| $FFC5
       .byte $12 ; |   X  X | $FFC6
       .byte $12 ; |   X  X | $FFC7
       .byte $12 ; |   X  X | $FFC8
       .byte $13 ; |   X  XX| $FFC9
       .byte $13 ; |   X  XX| $FFCA
       .byte $13 ; |   X  XX| $FFCB
       .byte $14 ; |   X X  | $FFCC
       .byte $14 ; |   X X  | $FFCD
       .byte $14 ; |   X X  | $FFCE
LFFCF: .byte $00 ; |        | $FFCF
       .byte $01 ; |       X| $FFD0
       .byte $02 ; |      X | $FFD1
       .byte $04 ; |     X  | $FFD2
       .byte $08 ; |    X   | $FFD3
       .byte $10 ; |   X    | $FFD4
       .byte $20 ; |  X     | $FFD5
       .byte $40 ; | X      | $FFD6
       .byte $80 ; |X       | $FFD7
       .byte $00 ; |        | $FFD8
       .byte $01 ; |       X| $FFD9
       .byte $02 ; |      X | $FFDA
       .byte $03 ; |      XX| $FFDB
       .byte $04 ; |     X  | $FFDC
       .byte $05 ; |     X X| $FFDD
       .byte $06 ; |     XX | $FFDE
       .byte $0B ; |    X XX| $FFDF
       .byte $0B ; |    X XX| $FFE0
       .byte $0B ; |    X XX| $FFE1
       .byte $0C ; |    XX  | $FFE2
       .byte $0C ; |    XX  | $FFE3
       .byte $0C ; |    XX  | $FFE4
       .byte $00 ; |        | $FFE5
       .byte $09 ; |    X  X| $FFE6
       .byte $09 ; |    X  X| $FFE7
       .byte $0A ; |    X X | $FFE8
       .byte $0A ; |    X X | $FFE9
       .byte $0A ; |    X X | $FFEA
       .byte $0B ; |    X XX| $FFEB
LFFEC: STA    LFFF8   ;4
       JMP    LF8C7   ;3
LFFF2: STA    LFFF8   ;4
       JMP    LF8C7   ;3
LFFF8: .byte $00 ; |        | $FFF8
       .byte $00 ; |        | $FFF9
       .byte $00 ; |        | $FFFA
LFFFB: .byte $00

       ORG $FFFC

       .word START
       .byte $50,$FF
