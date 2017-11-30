; Beamrider for the Atari 2600 VCS
;
; Copyright 1983 Activision
; Written by David Rolfe
;
; Distella'd by Manuel Rotschkar (cybergoth@nexgo.de)
; Compiles with DASM
;
; History
; 21.01.2.5K      - Started

TIA_BASE_READ_ADDRESS = $30

    include vcs.h
    processor 6502

; First bank
       ORG $1000
       RORG $D000

       BIT    $FFF9   ;4
       .byte $3C,$66,$66,$66,$66,$66,$66,$3C,$3C,$18,$18,$18,$18
       .byte $18,$38,$18,$7E,$60,$60,$3C,$06,$06,$46,$3C,$3C,$46,$06,$0C,$0C
       .byte $06,$46,$3C,$0C,$0C,$0C,$7E,$4C,$2C,$1C,$0C,$7C,$46,$06,$06,$7C
       .byte $60,$60,$7E,$3C,$66,$66,$66,$7C,$60,$62,$3C,$18,$18,$18,$18,$0C
       .byte $06,$42,$7E,$3C,$66,$66,$3C,$3C,$66,$66,$3C,$3C,$46,$06,$3E,$66
       .byte $66,$66,$3C,$EE,$AA,$28,$EE,$88,$AA,$EE,$EE,$E4,$A4,$84,$84,$84
       .byte $AA,$EE,$EE,$E9,$AA,$AC,$AE,$AB,$AB,$EF,$EE,$00,$00,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$3C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$1C
       .byte $7F,$2A,$1C,$00,$00,$00,$00,$00,$00,$08,$14,$22,$14,$08,$00,$00
       .byte $00,$00,$00,$00,$42,$5A,$7E,$24,$18,$00,$00,$00,$00,$00,$00,$08
       .byte $1C,$14,$00
LD0A3: .byte $00,$00,$02,$03
LD0A7: .byte $1A,$56,$46,$20,$EC,$D9,$2C,$F9,$FF
LD0B0: .byte $0A,$8F,$A2,$00

       JSR    LD4EB   ;6
       BIT    $FFF9   ;4
       .byte $3A ;.NOOP       ;2
       .byte $44 ;.NOOP       ;3
       .byte $42 ;.JAM;0
       .byte $DA ;.NOOP       ;2
       .byte $44 ;.NOOP       ;3
       .byte $42 ;.JAM;0
       STY    $4381   ;4
       .byte $3F ;.RLA;7
       EOR    $5A,X   ;4
       .byte $8F ;.SAX;4
       ORA    ($00,X) ;6
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       CLC    ;2
       ROR    $1824,X ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       .byte $1A ;.NOOP       ;2
       PHP    ;3
       .byte $0C ;.NOOP       ;4
       .byte $1C ;.NOOP       ;4
       ASL    ;2
       .byte $1A ;.NOOP       ;2
       CLC    ;2
       .byte $44 ;.NOOP       ;3
       ORA    #$3A    ;2
       LDA    RESM0,X ;4
       ORA    #$26    ;2
       BIT    AUDC1   ;3
       ROL    RESMP0  ;5
       .byte $1A ;.NOOP       ;2
       CLC    ;2
       BIT    VBLANK  ;3
       .byte $22 ;.JAM;0
       RTI    ;6

LD0EE: .byte $05,$44,$22,$09,$22,$44,$26,$44,$24,$42,$22,$44,$08,$91,$02,$11
       .byte $88,$43,$00,$94,$60,$40,$10,$78,$D0,$65,$B0,$34,$30,$94,$60,$40
       .byte $F0,$78,$E0,$65,$70,$38,$50,$94,$60,$40,$E0,$78,$F0,$65,$50,$38
       .byte $90,$50,$60,$40,$D0,$78,$00,$65,$20,$38,$B0,$50,$60,$40,$C0,$78
       .byte $20,$65,$00,$38,$E0,$50,$60,$40,$A0,$78,$30,$65,$D0,$38,$00,$50
       .byte $20,$00,$C0,$AC,$60,$40,$90,$78,$50,$65,$A0,$38,$40,$50,$B0,$00
       .byte $30,$AC,$60,$40,$60,$85,$60,$65,$50,$78,$70,$50,$30,$34,$B0,$94
       .byte $60,$40,$40,$85,$90,$40,$20,$78,$C0,$65,$C0,$34,$20,$94,$60,$40
       .byte $20,$85,$B0,$40,$E0,$78,$F0,$65,$00,$00,$00,$00,$00,$00,$41,$22
       .byte $36,$1C,$1C,$14,$20,$00,$00,$00,$00,$00,$00,$28,$86,$5A,$24,$58
       .byte $38,$10,$00,$00,$00,$00,$00,$00,$18,$3C,$7E,$81,$7E,$3C,$18,$00
       .byte $00,$00,$00,$00,$00,$18,$3C,$42,$81,$42,$3C,$18,$00,$00,$00,$00
       .byte $00,$00,$18,$7E,$3A,$5C,$38,$00,$00,$00,$00,$00,$00,$18,$3E,$2C
       .byte $18,$00,$00,$00,$00,$00,$00,$14,$1C,$08,$08,$00,$00,$00,$00,$00
       .byte $00,$08,$14,$08,$00,$00,$00,$00,$00,$00,$10,$3C,$18,$00,$00,$00
       .byte $00,$00,$00,$1C,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .byte $08,$00,$00,$00,$85,$11,$D5,$00,$85,$2A,$4C,$04,$D2,$85,$10,$A2
       .byte $00,$EA,$85,$2A,$85,$1C,$86,$1B,$B9,$00,$D1,$85,$F1,$85,$1F,$F0
       .byte $05,$C5,$FB,$6C,$F1,$00,$EA,$85,$14,$C6,$EF,$C5,$00,$B9,$FF,$D0
       .byte $85,$2B,$88,$F0,$5F,$85,$24,$B1,$E7,$AA,$C5,$00,$B1,$E9,$88,$C5
       .byte $FB,$38,$6C,$ED,$00,$FF,$85,$14,$B0,$E3,$B9,$FF,$D0,$85,$14,$B0
       .byte $DF,$FF,$85
LD241: .byte $2B,$B9,$FF,$D0,$85,$24,$88,$F0,$38,$B1,$E7,$85,$14,$B0,$D7,$85
       .byte $2B,$B9,$FF,$D0,$85,$24,$88,$F0,$28,$B1,$E7,$AA,$B1,$E9,$C5,$FB
       .byte $85,$14,$B0,$C7,$85,$2B,$B9,$FF,$D0,$85,$24,$88,$F0,$13,$B1,$E7
       .byte $AA,$C5,$FB,$85,$14,$B0,$B2,$85,$2B,$B9,$FF,$D0,$88,$85,$14,$B0
       .byte $9F
LD282: JMP    LD7CC   ;3
LD285: .byte $85,$2B,$B9,$FF,$D0,$85,$24,$88,$F0,$F3,$85,$14,$B0,$92,$FF,$85
       .byte $2B,$B9,$FF,$D0,$85,$24,$88,$F0,$E4,$B1,$E7,$AA,$B1,$E9,$88,$D5
       .byte $00,$C9,$00,$85,$14,$B0,$83,$85,$2B,$B9,$FF,$D0,$85,$24,$88,$F0
       .byte $CC,$68,$48,$EA,$B1,$E7,$AA,$B1,$E9,$88,$C9,$00,$85,$14,$6C,$ED
       .byte $00
LD2C6: STA    WSYNC   ;3
       STA    RESBL   ;3
       STA    HMOVE   ;3
       STX    GRP0    ;3
       STA    GRP1    ;3
       LDA    $F4     ;3
       STA    PF0     ;3
       STA    PF1     ;3
       STA    PF2     ;3
       BNE    LD2E4   ;2
       LDX    $F3     ;3
       LDA    $F5,X   ;4
       STA    $F5     ;3
       LDA    #$FF    ;2
       BNE    LD2EA   ;2
LD2E4: INC    $F3     ;5
       PLA    ;4
       PHA    ;3
       LDA    #$00    ;2
LD2EA: STA    $F4     ;3
       DEY    ;2
       BEQ    LD282   ;2
       STA    HMCLR   ;3
       CMP    VSYNC,X ;4
       LDA    ($E7),Y ;5
       TAX    ;2
       LDA    ($E9),Y ;5
       DEY    ;2
       CMP    #$00    ;2
       JMP.ind ($00ED);5
LD2FE: .byte $FF,$FF,$85,$2A,$85,$1C,$D0,$15,$4C,$56,$D4,$FF,$85,$2A,$A9,$02
       .byte $85,$1F,$C4,$EC,$90,$73,$C4,$EB,$B0,$35,$4C,$30,$D4,$A9,$02,$85
       .byte $1F,$86,$1B,$8A,$D0,$26,$A9,$A2,$85,$F0,$A6,$FC,$B5,$DD,$85,$EB
       .byte $B5,$CB,$85,$E7,$B5,$D5,$85,$06,$B5,$C1,$85,$ED,$A2,$00,$B1,$E9
       .byte $85,$2B,$C4,$F5,$90,$03,$4C,$00,$D2,$4C,$C8,$D2,$4C,$A1,$D4,$4C
       .byte $E2,$D4,$85,$2A,$4C,$6F,$DA,$85,$2A,$4C,$A7,$DA,$85,$2A,$4C,$C2
       .byte $DA,$85,$2A,$4C,$EB,$DA,$85,$2A,$4C,$0D,$DB,$85,$2A,$4C,$00,$DA
       .byte $85,$2A,$4C,$21,$DA,$85,$2A,$4C,$46,$DA,$85,$2A,$4C,$2B,$DB,$85
       .byte $2A,$4C,$57
LD381: .byte $DB,$85,$2A,$4C,$86,$DB,$EA,$C4,$EB,$90,$BE,$4C,$B1,$D4,$85,$2A
       .byte $C4,$EC,$90,$86,$A9,$02,$85,$1F,$86,$1B,$8A,$D0,$7C,$4C,$C0,$D4
       .byte $FF,$85,$2A,$85,$1C,$D0,$07,$C4,$EB,$90,$46,$4C,$83,$D4,$A9,$02
       .byte $85,$1F,$EA,$C4,$EB,$90,$92,$4C,$3F,$D4,$85,$2A,$4C,$58,$DC,$85
       .byte $2A,$4C,$90,$DC,$85,$2A,$4C,$AB,$DC,$85,$2A,$4C,$D4,$DC,$85,$2A
       .byte $4C,$F8,$DC,$85,$2A,$4C,$0E,$DC,$85,$2A,$4C,$BC,$DB,$85,$2A,$4C
       .byte $2F,$DC,$85,$2A,$4C,$E7,$DB,$85,$2A,$4C,$16,$DD,$85,$2A,$4C,$45
       .byte $DD,$A9,$8F,$85,$F0,$85,$1F,$A6,$FC,$B5,$DD,$85,$EC,$B5
LD3FF: .byte $CB,$85,$E9,$B5,$D5,$85,$07,$B5,$C1,$E9,$6A,$85,$ED,$B1,$E7,$AA
       .byte $A9,$00,$85,$2B,$C4,$F5,$90,$69,$4C,$00,$D2,$88,$B1,$E7,$D0,$18
       .byte $C8,$98,$E9
LD422: .byte $04,$C5,$EC,$B0,$14,$A5,$EC,$69,$02,$85,$EC,$18,$90,$42,$A9,$8F
       .byte $85,$ED,$D5,$00,$88,$C8,$68,$48,$EA,$EA,$18,$90,$EE,$EA,$88,$B1
       .byte $E9,$D0,$73,$C8,$98,$E9,$04,$C5,$EB,$B0,$6F,$A5,$EB,$69,$02,$85
       .byte $EB,$4C,$3A,$D3,$86,$1B,$A9,$8F,$85,$F0,$85,$1F,$A6,$FC,$B5,$DD
       .byte $85,$EC,$B5,$CB,$85,$E9,$B5,$D5,$85,$07,$B5,$C1,$E9,$6B,$85,$ED
       .byte $B1,$E7,$AA,$A9,$00,$85,$2B,$C4,$F5,$90,$03,$4C,$00,$D2,$4C,$C8
       .byte $D2,$A9,$0A,$85,$F0,$85,$1F,$A6,$FC,$B5,$DD,$85,$EC,$B5,$CB,$85
       .byte $E9,$B5,$D5,$85,$07,$B5,$C1,$E9,$6B,$85,$ED,$A2,$00,$F0,$37,$A9
       .byte $00,$85,$ED,$68,$48,$68,$48,$C6,$EF,$B1,$E7,$AA,$4C,$3C,$D3,$A9
       .byte $A2,$85,$ED,$C6,$EF,$88,$C8,$68,$48,$EA,$EA,$18,$90,$93,$A6,$FC
       .byte $B5,$DD,$85,$EB,$B5,$CB,$85,$E7,$B5,$D5,$85,$06,$B5,$C1,$85,$ED
       .byte $A9,$0A,$85,$F0,$A6,$FB,$8A,$85,$2B,$C4,$F5,$90,$A1,$4C,$00,$D2
       .byte $A2,$05,$CA,$10,$FD,$C5,$FB,$B0,$EB
LD4EB: PHA    ;3
       TXA    ;2
       LDY    $DD     ;3
       CPY    #$7A    ;2
       ADC    #$00    ;2
       LDY    $DE     ;3
       CPY    #$7A    ;2
       ADC    #$00    ;2
       STA    $FC     ;3
       LDY    #$0C    ;2
LD4FD: LDA    $8B,X   ;4
       LSR    $F3     ;5
       BCC    LD508   ;2
       ASL    ;2
       ASL    ;2
       ASL    ;2
       ASL    ;2
       DEX    ;2
LD508: AND    #$F0    ;2
       LSR    ;2
       ADC    #$03    ;2
       STA.wy $00E3,Y ;5
       LDA    #$D0    ;2
       STA.wy $00E4,Y ;5
       DEY    ;2
       DEY    ;2
       BNE    LD4FD   ;2
LD519: LDA    INTIM   ;4
       BPL    LD519   ;2
       LDA    $B9     ;3
       SBC    #$0F    ;2
       STA    HMM0    ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       SEC    ;2
       LDA    #$23    ;2
       LDX    $C1     ;3
       BMI    LD539   ;2
       BEQ    $D533   ;2
       DEX    ;2
       BIT    $EA     ;3
LD534: DEX    ;2
       BPL    LD534   ;2
       STA    RESM0   ;3
LD539: STA    WSYNC   ;3
       STA    HMOVE   ;3
       STY    VBLANK  ;3
       STA    VDELP0  ;3
       STA    VDELP1  ;3
       STY    GRP0    ;3
       STY    GRP1    ;3
       STA    NUSIZ0  ;3
       STA    NUSIZ1  ;3
       STA    HMP1    ;3
       LDA    $BA     ;3
       SBC    #$10    ;2
       STY    HMM0    ;3
       STA    HMM1    ;3
       STA    RESP0   ;3
       STA.w  $0011   ;4
       LDX    $C2     ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       BMI    LD56D   ;2
       BEQ    $D566   ;2
       NOP    ;2
       BIT    $E8     ;3
       NOP    ;2
LD568: DEX    ;2
       BPL    LD568   ;2
       STA    RESM1   ;3
LD56D: LDY    #$07    ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDX    #$0A    ;2
LD575: DEX    ;2
       BPL    LD575   ;2
       STA    HMCLR   ;3
LD57A: LDA    ($EF),Y ;5
       STA    GRP0    ;3
       LDA    ($ED),Y ;5
       STA.w  $002A   ;4
       STA    GRP1    ;3
       LDA    ($EB),Y ;5
       STA    GRP0    ;3
       STY    $F3     ;3
       LDA    ($E5),Y ;5
       STA    $FB     ;3
       LDA    ($E7),Y ;5
       TAX    ;2
       LDA    ($E9),Y ;5
       LDY    $FB     ;3
       NOP    ;2
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       LDY    $F3     ;3
       DEY    ;2
       BPL    LD57A   ;2
       LDA    #$53    ;2
       STA    $EF     ;3
       LDA    #$5B    ;2
       STA    $ED     ;3
       LDA    #$63    ;2
       STA    $EB     ;3
       STA    HMOVE   ;3
       INY    ;2
       STY    GRP0    ;3
       STY    GRP1    ;3
       STY    GRP0    ;3
       LDA    $80     ;3
       TAX    ;2
       AND    #$F0    ;2
       LSR    ;2
       ADC    #$03    ;2
       STA    $E7     ;3
       TXA    ;2
       AND    #$0F    ;2
       ASL    ;2
       ASL    ;2
       ASL    ;2
       ADC    #$03    ;2
       STA    $E5     ;3
       LDA    #$6B    ;2
       CMP    $E9     ;3
       STA    $E9     ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       BNE    LD56D   ;2
       STY    VDELP0  ;3
       STY    VDELP1  ;3
       STY    NUSIZ0  ;3
       STY    NUSIZ1  ;3
       STY    $FB     ;3
       STY    $E5     ;3
       STY    $E6     ;3
       LDX    $D3     ;3
       LDA    LD9E7,X ;4
       STA    $EB     ;3
       LDA    #$62    ;2
       STA    COLUPF  ;3
       LDA    $D4     ;3
       BMI    LD5F9   ;2
       JMP    LD684   ;3
LD5F9: LDA    $F1     ;3
       STA    HMP1    ;3
       SBC    #$10    ;2
       STA    HMP0    ;3
       AND    #$0F    ;2
       TAY    ;2
       LDA    #$08    ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       STA    REFP1   ;3
       LDA    $F2     ;3
       STA    $E9     ;3
       SEC    ;2
       SBC    #$07    ;2
       STA    $E7     ;3
LD615: DEY    ;2
       BPL    LD615   ;2
       STA    RESP0   ;3
       STA    RESP1   ;3
       LDY    #$0C    ;2
LD61E: DEY    ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    #$00    ;2
       BEQ    LD62D   ;2
LD627: STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    ($E9),Y ;5
LD62D: STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    ($E7),Y ;5
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDX    #$00    ;2
       STX    PF2     ;3
       PLA    ;4
       PHA    ;3
       CPY    #$04    ;2
       BMI    LD64B   ;2
       STA    HMCLR   ;3
       LDA    $EB     ;3
       STA    PF2     ;3
       CPY    #$08    ;2
       BCS    LD61E   ;2
LD64B: DEY    ;2
       BPL    LD627   ;2
       STX    COLUPF  ;3
       STY    PF0     ;3
       STY    PF1     ;3
       STY    PF2     ;3
       LDA    #$D1    ;2
       STA    $E8     ;3
       STA    $EA     ;3
       LDA    #$77    ;2
       STA    $E7     ;3
       STA    $E9     ;3
       LDA    #$00    ;2
       STA    HMOVE   ;3
       STA    $ED     ;3
       LDA    #$D3    ;2
       STA    $EE     ;3
       LDY    #$75    ;2
       LDA    #$A4    ;2
       STA    COLUPF  ;3
       STX    GRP0    ;3
       STX    GRP1    ;3
       STX    REFP1   ;3
       LDA    #$D2    ;2
       STA    $F2     ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       TXA    ;2
       JMP    LD2C6   ;3
LD684: LDX    #$6B    ;2
       CMP    #$0A    ;2
       BCC    LD68E   ;2
       LDX    #$0B    ;2
       SBC    #$0A    ;2
LD68E: STX    $E9     ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       ASL    ;2
       ASL    ;2
       ASL    ;2
       ADC    #$03    ;2
       STA    $E7     ;3
       LDA    #$D4    ;2
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDA    #$30    ;2
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    HMP1    ;3
       LDY    #$07    ;2
LD6AB: STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    ($E9),Y ;5
       STA    GRP0    ;3
       LDA    ($E7),Y ;5
       STA    GRP1    ;3
       LDX    #$00    ;2
       STX    PF2     ;3
       PLA    ;4
       PHA    ;3
       CLC    ;2
       STA    HMCLR   ;3
       STX    GRP0    ;3
       STX    GRP1    ;3
       LDA    $EB     ;3
       STA    PF2     ;3
       DEY    ;2
       BPL    LD6AB   ;2
       LDX    $FC     ;3
       LDA    $B9,X   ;4
       STA    HMP0    ;3
       AND    #$0F    ;2
       ORA    #$D0    ;2
       STA    $E8     ;3
       LDA    #$00    ;2
       STA    PF2     ;3
       NOP    ;2
       STA    HMOVE   ;3
       STA    COLUPF  ;3
       LDY    $C1,X   ;4
       BEQ    LD6E7   ;2
       DEY    ;2
       BPL    LD6E8   ;2
LD6E7: NOP    ;2
LD6E8: DEY    ;2
       BPL    LD6E8   ;2
       NOP    ;2
       STA    RESP0   ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       STY    PF0     ;3
       STY    PF1     ;3
       STY    PF2     ;3
       LDA    $CB,X   ;4
       STA    $E7     ;3
       LDA    $DD,X   ;4
       STA    $EB     ;3
       LDA    $D5,X   ;4
       STA    $ED     ;3
       INX    ;2
       LDA    $CB,X   ;4
       STA    $E9     ;3
       LDA    $DD,X   ;4
       STA    $EC     ;3
       LDA    $D5,X   ;4
       STA    $EE     ;3
       STA    HMCLR   ;3
       LDA    #$08    ;2
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDA    $B9,X   ;4
       STA    HMP1    ;3
       AND    #$0F    ;2
       STA    HMOVE   ;3
       ORA    #$D0    ;2
       STA    $EA     ;3
       LDY    $C1,X   ;4
       BEQ    LD72C   ;2
       DEY    ;2
       BPL    LD72D   ;2
LD72C: NOP    ;2
LD72D: DEY    ;2
       BPL    LD72D   ;2
       STA    RESP1   ;3
       LDY    #$78    ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    LD0A3,X ;4
       STA    ENAM0   ;3
       ASL    ;2
       STA    ENAM1   ;3
       CPY    $EB     ;3
       BCC    LD748   ;2
       LDA    $FB     ;3
       BEQ    LD74A   ;2
LD748: LDA    ($E7),Y ;5
LD74A: STA    GRP0    ;3
       INX    ;2
       STX    $FC     ;3
       LDA    #$D2    ;2
       STA    $F2     ;3
       CMP    VSYNC   ;3
       STA    HMCLR   ;3
       DEY    ;2
       CPY    $EB     ;3
       BCC    LD760   ;2
       LDA    $FB     ;3
       BEQ    LD762   ;2
LD760: LDA    ($E7),Y ;5
LD762: TAX    ;2
       CPY    $EC     ;3
       BCC    LD76B   ;2
       LDA    $FB     ;3
       BEQ    LD76D   ;2
LD76B: LDA    ($E9),Y ;5
LD76D: LDY    #$A4    ;2
       STY    COLUPF  ;3
       STA    HMOVE   ;3
       STX    GRP0    ;3
       STA    GRP1    ;3
       STA    ENAM0   ;3
       STA    ENAM1   ;3
       LDA    $ED     ;3
       STA    COLUP0  ;3
       LDA    $EE     ;3
       STA    COLUP1  ;3
       LDA    #$D3    ;2
       STA    $EE     ;3
       LDY    #$76    ;2
       LDA    #$00    ;2
       CPY    $EB     ;3
       BCS    LD791   ;2
       LDA    ($E7),Y ;5
LD791: TAX    ;2
       LDA    #$00    ;2
       CPY    $EC     ;3
       BCS    LD79A   ;2
       LDA    ($E9),Y ;5
LD79A: STA    WSYNC   ;3
       STA    HMOVE   ;3
       STX    GRP0    ;3
       STA    GRP1    ;3
       LDX    $FC     ;3
       LDA    #$00    ;2
       LDY    $DC,X   ;4
       CPY    #$76    ;2
       ROL    ;2
       LDY    $DB,X   ;4
       CPY    #$76    ;2
       ROL    ;2
       TAX    ;2
       LDA    LD0B0,X ;4
       STA    $ED     ;3
       LDY    #$75    ;2
       LDA    #$00    ;2
       CPY    $EB     ;3
       BCS    LD7C0   ;2
       LDA    ($E7),Y ;5
LD7C0: TAX    ;2
       LDA    #$00    ;2
       CPY    $EC     ;3
       BCS    LD7C9   ;2
       LDA    ($E9),Y ;5
LD7C9: JMP    LD2C6   ;3
LD7CC: LDA    $8F     ;3
       STA    HMP0    ;3
       STA    HMP1    ;3
       AND    #$0F    ;2
       TAX    ;2
       LDA    $8E     ;3
       AND    #$F8    ;2
       STA    $E7     ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       STY    RESP0   ;3
       STY    RESP1   ;3
       LDA    #$DF    ;2
       STA    $E8     ;3
       STA    REFP1   ;3
       LDY    #$08    ;2
       LDA    ($E7),Y ;5
LD7ED: DEX    ;2
       BNE    LD7ED   ;2
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    $81     ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       STX    PF0     ;3
       STX    PF1     ;3
       STX    PF2     ;3
       ASL    ;2
       AND    #$2E    ;2
       LDX    $B1     ;3
       BEQ    LD80D   ;2
       LDA    #$02    ;2
LD80D: ADC    #$40    ;2
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDA    #$F0    ;2
       STA    HMP0    ;3
       LDA    #$10    ;2
       STA    HMP1    ;3
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    ($E7),Y ;5
       ASL    ;2
       STA    GRP0    ;3
LD824: STA    GRP1    ;3
       DEY    ;2
       STA    HMCLR   ;3
LD829: STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    ($E7),Y ;5
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    $8E     ;3
       AND    #$07    ;2
       TAX    ;2
       LDA    LD0A7,X ;4
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       DEY    ;2
       BNE    LD829   ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       STY    GRP0    ;3
       STY    GRP1    ;3
       STY    REFP1   ;3
       LDA    #$1A    ;2
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDA    #$9D    ;2
       LDX    $85     ;3
       BMI    LD8B9   ;2
       BEQ    LD875   ;2
       LDA    #$B5    ;2
       DEX    ;2
       BEQ    LD875   ;2
       LDA    #$01    ;2
       STA    NUSIZ0  ;3
       STA    NUSIZ1  ;3
       CPX    #$0D    ;2
       BMI    LD86F   ;2
       LDX    #$0C    ;2
LD86F: TXA    ;2
       ASL    ;2
       EOR    #$FF    ;2
       ADC    #$98    ;2
LD875: STA    $ED     ;3
       LDA    #$D8    ;2
       STA    $EE     ;3
       LDX    #$0A    ;2
       BNE    LD8A1   ;2
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       STY    GRP0    ;3
       STY    GRP1    ;3
LD8A1: STA    WSYNC   ;3
       STA    HMOVE   ;3
       DEX    ;2
       BEQ    LD8B2   ;2
       LDA    LDD80,X ;4
       STA    GRP0    ;3
       STA    GRP1    ;3
       JMP.ind ($00ED);5
LD8B2: JMP    LD944   ;3
LD8B5: .byte $84,$1C,$50,$E0
LD8B9: LDA    #$0C    ;2
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       SBC    $81     ;3
       STA    RESP0   ;3
       STA    RESP1   ;3
       AND    #$7C    ;2
       LSR    ;2
       LSR    ;2
       SBC    #$07    ;2
       CMP    #$10    ;2
       BMI    LD8D1   ;2
       LDA    #$0F    ;2
LD8D1: CMP    #$07    ;2
       BPL    LD8D7   ;2
       LDA    #$07    ;2
LD8D7: TAY    ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       ASL    ;2
       ASL    ;2
       ASL    ;2
       ASL    ;2
       EOR    #$F0    ;2
       ADC    #$D0    ;2
       STA    HMBL    ;3
       LDA    #$03    ;2
       STA    NUSIZ0  ;3
       LSR    ;2
       STA    NUSIZ1  ;3
       STA    VDELP0  ;3
       STA    VDELP1  ;3
       LSR    ;2
       STA    GRP0    ;3
       STA    COLUPF  ;3
       STA    RESBL   ;3
       TAX    ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    #$1F    ;2
       STA    PF2     ;3
       STA    ENABL   ;3
       LDA    #$30    ;2
       STA    CTRLPF  ;3
       LDA    #$08    ;2
       STA    $EF     ;3
       ASL    ;2
       STA    HMP1    ;3
       STA    HMBL    ;3
LD910: STA    WSYNC   ;3
       STA    HMOVE   ;3
       CPY    #$08    ;2
       BCS    LD95F   ;2
       LDX    LDFA0,Y ;4
LD91B: STX    COLUPF  ;3
       LDA    LDFA8,Y ;4
       STA    GRP0    ;3
       LDA    LDFB8,Y ;4
       STA    GRP1    ;3
       LDA    LDFC8,Y ;4
       STA    GRP0    ;3
       LDA    LDFD8,Y ;4
       TAX    ;2
       LDA    LDFE8,Y ;4
       STX    GRP1    ;3
       STA    GRP0    ;3
       STA    GRP1    ;3
       DEY    ;2
       LDX    #$00    ;2
       STX    COLUPF  ;3
       STX    HMP1    ;3
       DEC    $EF     ;5
       BNE    LD910   ;2
LD944: STA    WSYNC   ;3
       LDA    #$28    ;2
       STA    TIM64T  ;4
       LDA    #$02    ;2
       STA    VBLANK  ;3
       STX    VDELP0  ;3
       STX    VDELP1  ;3
       STX    GRP0    ;3
       STX    GRP1    ;3
       STX    ENABL   ;3
       STX    PF2     ;3
       PLA    ;4
       STA    COLUBK  ;3
       RTS    ;6

LD95F: BCS    LD91B   ;2
       .byte $FF ;.ISB;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       STA    ($99,X) ;6
       LDA    $C3FF,X ;4
       ROR    INPT4   ;5
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       PHP    ;3
       PHP    ;3
       .byte $14 ;.NOOP       ;4
       .byte $7F ;.RRA;7
       .byte $14 ;.NOOP       ;4
       PHP    ;3
       PHP    ;3
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BIT    $42     ;3
       STA    ($42,X) ;6
       .byte $3C ;.NOOP       ;4
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BIT    CXM0P   ;3
       LSR    ;2
       AND    #$95    ;2
       .byte $7A ;.NOOP       ;2
       .byte $5C ;.NOOP       ;4
       BMI    LD997   ;2
LD997: BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       CLC    ;2
       .byte $3C ;.NOOP       ;4
       ROR    $7EFF,X ;7
       .byte $3C ;.NOOP       ;4
       CLC    ;2
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       CLC    ;2
       BIT    $42     ;3
       STA    ($42,X) ;6
       BIT    AUDF1   ;3
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       PHP    ;3
       .byte $14 ;.NOOP       ;4
       ROL    $2241,X ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       PHP    ;3
       .byte $14 ;.NOOP       ;4
       ROL    $1422,X ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       .byte $22 ;.JAM;0
       ROL    $0814,X ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       .byte $3C ;.NOOP       ;4
       CLC    ;2
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       BRK    ;7
       .byte $14 ;.NOOP       ;4
       .byte $1C ;.NOOP       ;4
       PHP    ;3
       BRK    ;7
       BRK    ;7
LD9E7: BRK    ;7
       BPL    $D9FE   ;2
       ORA    $FF,X   ;4
       LDY    $91,X   ;4
       LDA    LDE6E,Y ;4
       STA    $ED     ;3
       LDA    LDD97,Y ;4
       STA    $EF     ;3
       LDA    LDD96,Y ;4
       STA    $EE     ;3
       AND    #$07    ;2
       RTS    ;6

LDA00: .byte $A5,$F0,$85,$ED,$85,$1F,$10,$14,$86,$1B,$B1,$E7,$85,$F0,$A6,$FC
       .byte $85,$2B,$B5,$B9,$85,$21,$29,$0F,$85,$11,$B0,$75,$EA,$A9,$00,$F0
       .byte $EB,$A5,$F0,$85,$ED,$85,$1F,$10,$18,$86,$1B,$B1,$E7,$85,$F0,$A6
       .byte $FC,$85,$2B,$B5,$B9,$85,$21,$29,$0F,$69,$CF,$85,$EA,$85,$11,$90
       .byte $54,$EA,$A9,$00,$F0,$E7,$A5,$F0,$85,$ED,$85,$1F,$10,$1C,$86,$1B
       .byte $B1,$E7,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9,$85,$21,$29,$0F,$69,$CF
       .byte $85,$EA,$A6,$F0,$A9,$00,$85,$11,$90,$2F,$EA,$A9,$00,$F0,$E3,$A5
       .byte $F0,$85,$ED,$85,$1F,$30,$07,$A6,$FB,$95,$11,$8A,$F0,$06,$86,$1B
       .byte $85,$11,$B1,$E7,$A6,$FC,$EA,$85,$F0,$B5,$B9,$85,$2B,$85,$21,$29
       .byte $0F,$69,$CF,$85,$EA,$A6,$F0,$A9,$00,$E6,$FC,$EA,$C4,$F5,$B0,$04
       .byte $EA,$4C,$C8,$D2,$4C,$00,$D2,$A5,$F0,$85,$ED,$85,$1F,$10,$0A,$86
       .byte $1B,$A6,$FC,$85,$11,$B1,$E7,$B0,$CE,$A6,$FC,$EA,$85,$11,$A9,$00
       .byte $F0,$F5,$A5,$F0,$85,$ED,$85,$1F,$10,$0A,$86,$1B,$A6,$FC,$B1,$E7
       .byte $85,$11,$B0,$B3,$A6,$FC,$EA,$A9,$00,$F0,$F5,$A9,$00,$85,$F0,$A6
       .byte $FC,$85,$2B,$B5,$B9,$85,$11,$C6,$EF,$B0,$A2,$A5,$F0,$85,$ED,$85
       .byte $1F,$10,$E8,$86,$1B,$A6,$FC,$B5,$B9,$85,$2B,$85,$21,$85,$11,$29
       .byte $0F,$69,$CF,$85,$EA,$B1,$E7,$AA,$EA,$EA,$4C,$97,$DA,$A5,$F0,$85
       .byte $ED,$85,$1F,$10,$11,$86,$1B,$B1,$E7,$85,$F0,$A6,$FC,$85,$2B,$B5
       .byte $B9,$85,$11,$4C,$8D,$DA,$EA,$A9,$00,$F0,$EE,$A5,$F0,$85,$ED,$85
       .byte $1F,$10,$1F,$86,$1B,$B1,$E7,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9,$85
       .byte $21,$29,$0F,$69,$CF,$85,$EA,$E6,$FC,$A6,$F0,$A9,$00,$85,$11,$4C
       .byte $9B,$DA,$EA,$A9,$00,$F0,$E0,$A5,$F0,$85,$ED,$85,$1F,$10,$22,$86
       .byte $1B,$B1,$E7,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9,$85,$21,$29,$0F,$69
       .byte $CF,$85,$EA,$E6,$FC,$A6,$F0,$A9,$00,$EA,$C4,$F5,$85,$11,$4C,$9E
       .byte $DA,$EA,$A9,$00,$F0,$DD,$A5,$F0,$85,$ED,$85,$1F,$10,$29,$86,$1B
       .byte $B1,$E7,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9,$85,$21,$29,$0F,$69,$CF
       .byte $85,$EA,$E6,$FC,$A6,$F0,$EA,$EA,$C4,$F5,$90,$03,$4C,$F2,$D1,$A9
       .byte $00,$85,$11,$EA,$4C,$C8,$D2,$EA,$A9,$00,$F0,$D6,$A6,$F0,$86,$ED
       .byte $86,$1F,$10,$19,$85,$1C,$B1,$E9,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9
       .byte $85,$20,$29,$0F,$69,$CF,$85,$E8,$85,$10,$4C,$7E,$DC,$EA,$A9,$00
       .byte $F0,$E6,$EA,$A9,$00,$F0,$0C,$A6,$F0,$86,$ED,$86,$1F,$10,$F3,$85
       .byte $1C,$B1,$E9,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9,$85,$20,$29,$0F,$69
       .byte $CF,$85,$E8,$E6,$FC,$A5,$F0,$A2,$00,$85,$10,$4C,$84,$DC,$A6,$F0
       .byte $86,$ED,$86,$1F,$10,$14,$85,$1C,$B1,$E9,$85,$F0,$A6,$FC,$85,$2B
       .byte $B5,$B9,$85,$20,$29,$0F,$85,$10,$B0,$50,$EA,$A9,$00,$F0,$EB,$A6
       .byte $F0,$86,$ED,$86,$1F,$10,$1C,$85,$1C,$B1,$E9,$85,$F0,$A6,$FC,$85
       .byte $2B,$B5,$B9,$85,$20,$29,$0F,$69,$CF,$85,$E8,$A5,$F0,$A2,$00,$85
       .byte $10,$90,$2F,$EA,$A9,$00,$F0,$E3,$A6,$F0,$86,$ED,$86,$1F,$30,$07
       .byte $A6,$FB,$95,$10,$8A,$F0,$06,$85,$1C,$85,$10,$B1,$E9,$A6,$FC,$EA
       .byte $85,$F0,$B5,$B9,$85,$2B,$85,$20,$29,$0F,$69,$CF,$85,$E8,$A5,$F0
       .byte $A2,$00,$E6,$FC,$EA,$C4,$F5,$B0,$04,$EA,$4C,$C8,$D2,$4C,$00,$D2
       .byte $A6,$F0,$86,$ED,$86,$1F,$10,$0A,$85,$1C,$A6,$FC,$85,$10,$B1,$E9
       .byte $B0,$CE,$A6,$FC,$EA,$85,$10,$A9,$00,$F0,$F5,$A6,$F0,$86,$ED,$86
       .byte $1F,$10,$0A,$85,$1C,$A6,$FC,$B1,$E9,$85,$10,$B0,$B3,$A6,$FC,$EA
       .byte $A9,$00,$F0,$F5,$A9,$00,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9,$85,$10
       .byte $C6,$EF,$B0,$A2,$A6,$F0,$86,$ED,$86,$1F,$10,$E8,$85,$1C,$A6,$FC
       .byte $B5,$B9,$85,$2B,$85,$20,$85,$10,$29,$0F,$69,$CF,$85,$E8,$EA,$EA
       .byte $EA,$B1,$E9,$90,$8B,$FF,$FF,$FF,$A6,$F0,$86,$ED,$86,$1F,$10,$11
       .byte $85,$1C,$B1,$E9,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9,$85,$10,$4C,$76
       .byte $DC,$EA,$A9,$00,$F0,$EE,$A6,$F0,$86,$ED,$86,$1F,$10,$22,$85,$1C
       .byte $B1,$E9,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9,$85,$20,$29,$0F,$69,$CF
       .byte $85,$E8,$E6,$FC,$A5,$F0,$A2,$00,$EA,$C4,$F5,$85,$10,$4C,$87,$DC
       .byte $EA,$A9,$00,$F0,$DD,$A6,$F0,$86,$ED,$86,$1F,$10,$29,$85,$1C,$B1
       .byte $E9,$85,$F0,$A6,$FC,$85,$2B,$B5,$B9,$85,$20,$29,$0F,$69,$CF,$85
       .byte $E8,$E6,$FC,$A5,$F0,$EA,$EA,$C4,$F5,$90,$03,$4C,$FB,$D1,$A2,$00
       .byte $85,$10,$EA,$4C,$C8,$D2,$EA,$A9,$00,$F0,$D6,$00,$00,$00,$00,$00
LDD80: .byte $00,$22,$3E,$3E,$1C,$1C,$14,$14,$00,$00,$00,$00,$00,$00,$42,$91
       .byte $24,$92,$64,$00,$00,$00
LDD96: .byte $00
LDD97: .byte $03,$08,$1A,$01,$04,$10,$83,$04,$00,$83,$90,$04,$08,$01,$83,$80
       .byte $04,$08,$01,$80,$81,$04,$00,$8B,$80,$04,$10,$8B,$81,$82,$80,$81
       .byte $04,$10,$8B,$89,$82,$80,$04,$08,$83,$81,$00,$83,$81,$04,$00,$83
       .byte $80,$80,$80,$04,$18,$83,$81,$8A,$89,$04,$10,$8B,$8A,$01,$83,$04
       .byte $10,$89,$88,$04,$00,$8B,$8A,$08,$83,$04,$00,$A3,$04,$00,$8B,$82
       .byte $80,$00,$83,$04,$00,$83,$00,$83,$80,$8A,$01,$83,$81,$04,$00,$8B
       .byte $80,$12,$01,$83,$80,$02,$90,$04,$00,$8B,$88,$81,$04,$08,$8B,$88
       .byte $04,$00,$8B,$90,$82,$99,$04,$08,$8B,$01,$83,$80,$04,$00,$93,$90
       .byte $04,$08,$93,$92,$81,$04,$00,$83,$80,$01,$8B,$04,$00,$83,$00,$83
       .byte $00,$83,$80,$04,$00,$83,$00,$8B,$80,$04,$00,$83,$00,$83,$09,$83
       .byte $80,$04,$00,$8B,$08,$83,$91,$8A,$80,$04,$08,$8B,$01,$83,$04,$00
       .byte $8B,$08,$83,$04,$08,$8B,$81,$88,$01,$83,$04,$00,$83,$10,$83,$11
       .byte $83,$04,$10,$93,$92,$09,$83,$04,$00,$8B,$90,$82,$01,$83,$82,$01
       .byte $83,$04,$00,$93,$88,$81,$04
LDE6E: .byte $0F,$1C,$16,$1D,$11,$00,$0F,$22,$00,$11,$2C,$0D,$00,$0D,$13,$22
       .byte $13,$00,$0D,$08,$08,$08,$00,$0D,$30,$15,$00,$19,$30,$1D,$1D,$21
       .byte $21,$00,$17,$30,$1D,$1D,$1D,$00,$0D,$3E,$21,$21,$3E,$21,$00,$0D
       .byte $1F,$19,$19,$19,$00,$0F,$2A,$18,$18,$1A,$00,$19,$2B,$18,$19,$4D
       .byte $00,$0E,$0E,$1D,$00,$0D,$2B,$4D,$2A,$35,$00,$0D,$4D,$00,$0D,$2B
       .byte $26,$21,$21,$4D,$00,$0D,$30,$24,$30,$24,$30,$24,$35,$24,$00,$0D
       .byte $2B,$19,$30,$1D,$35,$1D,$1D,$21,$00,$15,$2B,$21,$21,$00,$11,$30
       .byte $32,$00,$0F,$3A,$2E,$1D,$32,$00,$12,$4D,$24,$4D,$24,$00,$11,$56
       .byte $3F,$00,$11,$4D,$48,$1D,$00,$11,$30,$2E,$2E,$4D,$00,$10,$3E,$26
       .byte $3E
LDEFF: .byte $26,$4D,$26,$00,$10,$3A,$21,$4D,$26,$00,$11,$35,$24,$3A,$28,$48
       .byte $2C,$00,$0D,$48,$2E,$52,$3F,$2B,$3F,$00,$11,$48,$2A,$4D,$00,$0D
       .byte $48,$2E,$52,$00,$19,$48,$26,$26,$26,$4D,$00,$11,$43,$3F,$48,$3F
       .byte $4D,$00,$0F,$53,$35,$3B,$52,$00,$11,$48,$2E,$48,$28,$4D,$48,$28
       .byte $4D,$00,$11,$4D,$32,$2A,$00,$00,$00,$00,$00,$00,$00,$18,$24,$FF
       .byte $5A,$3C,$18,$00,$00,$00,$00,$00,$00,$1C,$BE,$7D,$BE,$6C,$18,$00
       .byte $00,$00,$00,$00,$00,$18,$18,$18,$18,$18,$18,$00,$00,$00,$00,$00
       .byte $00,$08,$14,$3E,$7F,$49,$22,$00,$00,$00,$00,$00,$00,$3C,$5A,$BD
       .byte $A5,$BD,$7E,$3C,$00,$00,$00,$00,$00,$00,$24,$3C,$18,$18,$18,$00
       .byte $00,$00,$FF,$77,$30,$18,$1C,$0D,$07,$02,$FF,$7C,$18,$8C,$58,$30
       .byte $00
LDFA0: .byte $00,$84,$D6,$D6,$1A,$26,$26,$44
LDFA8: .byte $00,$0C,$06,$03,$01,$00,$00,$00,$00,$78,$84,$B4,$A4,$B4,$84,$78
LDFB8: .byte $00,$2D,$29,$E9,$A9,$ED,$61,$2F,$00,$00,$00,$8B,$8A,$BB,$AA,$BB
LDFC8: .byte $00,$50,$58,$5C,$56,$53,$11,$F0,$00,$00,$02,$BA,$88,$98,$88,$B8
LDFD8: .byte $00,$BA,$8A,$BA,$A2,$3A,$80,$FE,$00,$00,$00,$45,$45,$5D,$55,$5D
LDFE8: .byte $00,$E9,$AB,$AF,$AD,$E9,$00,$00,$00,$00,$00,$C4,$44,$DC,$54,$D4
       .byte $FF
LDFF9: .byte $FF
    .word $F000
    .word $F000
    .word $F000

; Second bank
       ORG $2000
       RORG $F000

START:
       BIT    LFFF9   ;4
       SEI    ;2
       CLD    ;2
       LDA    #$00    ;2
       TAX    ;2
LF008: STA    VSYNC,X ;4
       TXS    ;2
       INX    ;2
       BNE    LF008   ;2
       SEC    ;2
       ROR    $A9     ;5
       LDA    #$20    ;2
       STA    $84     ;3
       STA    $B4     ;3
       DEC    $D4     ;5
LF019: LDA    #$03    ;2
       STA    $D3     ;3
       DEC    $85     ;5
LF01F: LDA    $8C     ;3
       CMP    #$04    ;2
       BNE    LF029   ;2
       LDA    #$FF    ;2
       STA    $D4     ;3
LF029: JSR    LF213   ;6
       LSR    ;2
       JMP    LF0B1   ;3
LF030: LDX    #$06    ;2
LF032: LDA    $D5,X   ;4
       LSR    ;2
       BCC    LF07E   ;2
       DEC    $D5,X   ;6
       LDA    $DF,X   ;4
       BEQ    LF044   ;2
       CLC    ;2
       SBC    $CA     ;3
       CMP    #$F3    ;2
       BCS    LF07C   ;2
LF044: LDY    #$00    ;2
       LDA    $D4     ;3
       BMI    LF058   ;2
       LDY    #$02    ;2
       LDA    #$7A    ;2
       CMP    $DD     ;3
       BNE    LF058   ;2
       INY    ;2
       CMP    $DE     ;3
       BNE    LF058   ;2
       INY    ;2
LF058: STY    $E8     ;3
       LDA    $CA     ;3
       STA    $DD,X   ;4
       LDA    $D2     ;3
       STA    $CB,X   ;4
       LDA    $DC     ;3
       STA    $D5,X   ;4
       LDA    $C0     ;3
       STA    $B9,X   ;4
       LDA    $C8     ;3
       CPX    $E8     ;3
       BCS    LF07A   ;2
       SBC    #$BA    ;2
       LDY    #$FF    ;2
LF074: INY    ;2
       SBC    #$05    ;2
       BCS    LF074   ;2
       TYA    ;2
LF07A: STA    $C1,X   ;4
LF07C: LDX    #$01    ;2
LF07E: DEX    ;2
       BNE    LF032   ;2
       STX    $EC     ;3
       LDY    #$F0    ;2
       CPY    SWCHA   ;4
       BCC    LF08C   ;2
       STX    $83     ;3
LF08C: INC    $81     ;5
       BNE    LF0A3   ;2
       INC    $83     ;5
       BNE    LF0A3   ;2
       STX    AUDV0   ;3
       STX    AUDV1   ;3
LF098: LDA    SWCHB   ;4
       LSR    ;2
       BCC    LF0A3   ;2
       CPY    SWCHA   ;4
       BCC    LF098   ;2
LF0A3: JMP    LF0C3   ;3
LF0A6: .byte $FF,$2C,$F8,$FF,$1C,$5C,$AA,$56,$A4,$E4,$60
LF0B1: BIT    LFFF8   ;4
       ASL.w  $0000   ;6
       .byte $32 ;.JAM;0
       BRK    ;7
       .byte $62 ;.JAM;0
       LSR    ;2
       BCC    LF0C0   ;2
       JMP    LF030   ;3
LF0C0: JMP    LF12A   ;3
LF0C3: STX    $E5     ;3
       LDA    $81     ;3
       LSR    ;2
       ROL    $E5     ;5
       LSR    ;2
       ROL    $E5     ;5
       LSR    ;2
       ROL    $E5     ;5
       LSR    ;2
       ROL    $E5     ;5
       INC    $E5     ;5
       LDA    $82     ;3
       ASL    ;2
       ASL    ;2
       ASL    ;2
       EOR    $82     ;3
       ASL    ;2
       ROL    $82     ;5
       LDX    #$FF    ;2
       JSR    LF420   ;6
       AND    #$1F    ;2
       STA    $98     ;3
       LDA    SWCHB   ;4
       LSR    ;2
       BCC    LF12D   ;2
       LDA    $8C     ;3
       ADC    #$07    ;2
       JSR    LFB5F   ;6
LF0F5: LDX    #$FF    ;2
       TXS    ;2
       LDA    $A9     ;3
       SEC    ;2
       SBC    #$53    ;2
       STA    $E8     ;3
       LSR    ;2
       ADC    $E8     ;3
       JSR    LFCA3   ;6
       ORA    $E8     ;3
       STA    $8F     ;3
       LDX    #$9A    ;2
       LDA    $8C     ;3
       CMP    #$05    ;2
       BCS    LF11E   ;2
       LDX    #$90    ;2
       CMP    #$01    ;2
       BNE    LF11E   ;2
       LDA    $81     ;3
       AND    #$08    ;2
       BEQ    LF11E   ;2
       INX    ;2
LF11E: STX    $8E     ;3
       JSR    LF398   ;6
       LDA    $EC     ;3
       STA    COLUBK  ;3
       JMP    LF0B1   ;3
LF12A: JMP    LF01F   ;3
LF12D: AND    #$20    ;2
       BEQ    LF133   ;2
       LDA    #$07    ;2
LF133: STA    $80     ;3
       LDA    #$00    ;2
       TAX    ;2
LF138: STA    $81,X   ;4
       INX    ;2
       BPL    LF138   ;2
       INC    $82     ;5
       LDA    #$02    ;2
       STA    $85     ;3
       LDA    #$72    ;2
       STA    $94     ;3
LF147: LDA    #$00    ;2
       STA    $84     ;3
       STA    $88     ;3
       LDA    #$83    ;2
       STA    $8D     ;3
       LDA    #$0F    ;2
       STA    $D4     ;3
       LSR    ;2
       LSR    ;2
       STA    $D3     ;3
       LDA    $80     ;3
       SED    ;2
       ADC    #$00    ;2
       CLD    ;2
       BCS    LF163   ;2
       STA    $80     ;3
LF163: JSR    LF1C7   ;6
       TAY    ;2
       BPL    LF16B   ;2
LF169: SBC    #$07    ;2
LF16B: CMP    #$26    ;2
       BCS    LF169   ;2
       STA    $90     ;3
       DEY    ;2
       TYA    ;2
       CMP    #$07    ;2
       BCC    LF179   ;2
       LDA    #$06    ;2
LF179: EOR    #$07    ;2
       ASL    ;2
       ASL    ;2
       ASL    ;2
       STA    $86     ;3
       TYA    ;2
       CMP    #$18    ;2
       BCC    LF187   ;2
       LDA    #$17    ;2
LF187: ADC    #$16    ;2
       STA    $87     ;3
       JSR    LF1B0   ;6
       LDA    $8D     ;3
       ASL    ;2
       BMI    LF197   ;2
       LDA    $D4     ;3
       BEQ    LF147   ;2
LF197: LDA    #$01    ;2
       STA    $8C     ;3
       LDA    #$80    ;2
       STA    $A9     ;3
       STA    $B1     ;3
       LDY    #$FF    ;2
       STY    $A0     ;3
       INC    $83     ;5
       JSR    LF71F   ;6
       JSR    LFE0B   ;6
       JMP    LF0F5   ;3
LF1B0: LDA    #$00    ;2
       LDX    #$07    ;2
LF1B4: STA    $AA,X   ;4
       DEX    ;2
       BPL    LF1B4   ;2
       LDY    $D4     ;3
       BMI    LF1C6   ;2
LF1BD: STA    $DE,X   ;4
       STA    $C2,X   ;4
       STA    $CC,X   ;4
       INX    ;2
       BEQ    LF1BD   ;2
LF1C6: RTS    ;6

LF1C7: LDA    $80     ;3
       AND    #$0F    ;2
       STA    $E9     ;3
       EOR    $80     ;3
       LSR    ;2
       STA    $E8     ;3
       LSR    ;2
       LSR    ;2
       ADC    $E8     ;3
       ADC    $E9     ;3
LF1D8: RTS    ;6

LF1D9: .byte $84,$78,$6B,$7D,$7D,$91,$91,$97,$97,$94,$94,$E6,$D1,$9A,$70,$E4
       .byte $CA,$8F,$89,$A3,$C7,$BC,$77,$DC,$C0,$B6,$5F,$B1,$AB,$9E,$A4,$84
       .byte $84,$84,$89,$F0,$D3,$8F,$F0,$E4,$DD,$D4,$84,$53,$A5,$E4,$85,$CA
       .byte $A6,$EE,$86,$EF,$F6,$D4,$A2,$00,$F0,$18
LF213: LDX    #$08    ;2
LF215: LDA    $98,X   ;4
       STA    $EF,X   ;4
       DEX    ;2
       BNE    LF215   ;2
       LDA    #$BB    ;2
       STA    $C9     ;3
       STA    $CA     ;3
       LDA    #$F2    ;2
       STA    $ED     ;3
       STX    $EF     ;3
       DEX    ;2
       STX    $E5     ;3
       STX    $EE     ;3
       LDA    #$31    ;2
       STA    $EC     ;3
LF231: LDA    INTIM   ;4
       CMP    #$05    ;2
       BCS    LF23F   ;2
       INC    $E5     ;5
       BNE    LF2B7   ;2
       JSR    LFE0B   ;6
LF23F: LDX    #$07    ;2
       BNE    LF249   ;2
LF243: CMP    $F0,X   ;4
       BCC    LF24D   ;2
       BEQ    LF24D   ;2
LF249: TXA    ;2
       TAY    ;2
       LDA    $F0,X   ;4
LF24D: DEX    ;2
       BPL    LF243   ;2
LF250: STX    $F0,Y   ;4
       CMP    #$D2    ;2
       BCS    LF2B3   ;2
       CMP    #$20    ;2
       BCS    LF27C   ;2
       LDA    #$7A    ;2
       LDX    $EF     ;3
       STA    $DD,X   ;4
       CPX    #$02    ;2
       BCS    LF2C0   ;2
       LDA    #$05    ;2
       ADC.wy $00A1,Y ;4
       TAX    ;2
       LDA    INTIM   ;4
       CMP    #$07    ;2
       BCS    LF278   ;2
       INC    $E5     ;5
       BNE    LF2B7   ;2
       JSR    LFE0B   ;6
LF278: LDA    #$7A    ;2
       BNE    LF2D2   ;2
LF27C: TAX    ;2
       LDA    $FEEF,X ;4
       ADC    #$01    ;2
       LDX    $EF     ;3
       STA    $DD,X   ;4
       CPX    #$02    ;2
       BCC    LF2C0   ;2
       CLC    ;2
       SBC    $DB,X   ;4
       CMP    #$F3    ;2
       BCC    LF2BE   ;2
       LDA    $DB,X   ;4
       CMP    #$7A    ;2
       BEQ    LF2BE   ;2
       SBC    $DD,X   ;4
       SBC    #$0D    ;2
       CMP    #$FD    ;2
       BCS    LF2BA   ;2
       LDA    $EE     ;3
       BPL    LF231   ;2
       STX    $EE     ;3
       LDA    $DD,X   ;4
       STA    $E4     ;3
       LDX    #$05    ;2
       STX    $EC     ;3
       LDX    #$07    ;2
       STX    $EF     ;3
       BNE    LF2C0   ;2
LF2B3: CMP    #$FF    ;2
       BNE    LF303   ;2
LF2B7: JMP    LF348   ;3
LF2BA: ADC    $DD,X   ;4
       STA    $DD,X   ;4
LF2BE: LDA    $DD,X   ;4
LF2C0: LDX    INTIM   ;4
       CPX    #$07    ;2
       BCS    LF2D0   ;2
       INC    $E5     ;5
       BNE    LF2B7   ;2
       PHA    ;3
       JSR    LFE0B   ;6
       PLA    ;4
LF2D0: LDX    $A1,Y   ;4
LF2D2: JSR    LFC69   ;6
       BCS    LF303   ;2
       STA    $E9     ;3
       LDA.wy $00AA,Y ;4
       AND    #$3F    ;2
       BEQ    LF303   ;2
       CPY    #$03    ;2
       BCC    LF31B   ;2
LF2E4: TAY    ;2
       LDX    $EF     ;3
       LDA    LFD8E,Y ;4
       STA    $D5,X   ;4
LF2EC: LDA    LF1D8,Y ;4
       SBC    $DD,X   ;4
       STA    $CB,X   ;4
       LDA    LFCE8,Y ;4
       ORA    $E9     ;3
       STA    $B9,X   ;4
       LDA    $E8     ;3
       STA    $C1,X   ;4
       INC    $EF     ;5
       JMP.ind ($00EC);5
LF303: LDX    #$FF    ;2
       LDA    $EE     ;3
       BMI    LF313   ;2
       BEQ    LF313   ;2
       STA    $EF     ;3
       STX    $EE     ;3
       LDA    #$31    ;2
       STA    $EC     ;3
LF313: STX    $99,Y   ;4
       INX    ;2
       STX    $AA,Y   ;4
       JMP    LF231   ;3
LF31B: CMP    #$06    ;2
       BCS    LF2E4   ;2
       LDX    $99,Y   ;4
       LDY    #$08    ;2
       CPX    #$5E    ;2
       BCC    LF329   ;2
       LDY    #$0E    ;2
LF329: LDA    #$27    ;2
       CPX    #$30    ;2
       ADC    #$00    ;2
       CPX    #$50    ;2
       ADC    #$00    ;2
       CPX    #$70    ;2
       ADC    #$00    ;2
       CPX    #$90    ;2
       ADC    #$00    ;2
       CPX    #$B8    ;2
       ADC    #$00    ;2
       LDX    $EF     ;3
       STY    $D5,X   ;4
       TAY    ;2
       SEC    ;2
       JMP    LF2EC   ;3
LF348: LDA    $E5     ;3
       BPL    LF34F   ;2
       JSR    LFE0B   ;6
LF34F: LDX    $EF     ;3
       LDY    #$00    ;2
       CPX    #$08    ;2
       BEQ    LF377   ;2
       STY    $DD,X   ;4
       CPX    #$07    ;2
       BNE    LF361   ;2
       LDA    $EE     ;3
       BPL    LF377   ;2
LF361: STY    $C1,X   ;4
       STY    $CB,X   ;4
       CPX    #$07    ;2
       BEQ    LF377   ;2
       STY    $DE,X   ;4
       CPX    #$06    ;2
       BNE    LF373   ;2
       LDA    $EE     ;3
       BPL    LF377   ;2
LF373: STY    $C2,X   ;4
       STY    $CC,X   ;4
LF377: LDX    $D4     ;3
       BMI    LF389   ;2
       LDX    #$01    ;2
       LDA    #$7A    ;2
       CMP    $DD     ;3
       BNE    LF389   ;2
       INX    ;2
       CMP    $DE     ;3
       BNE    LF389   ;2
       INX    ;2
LF389: INX    ;2
       LDA    $C1,X   ;4
       ASL    ;2
       ASL    ;2
       ADC    $C1,X   ;4
       ADC    #$BB    ;2
       STA    $C1,X   ;4
       CPX    #$07    ;2
       BCC    LF389   ;2
LF398: LDA    $D4     ;3
       BPL    LF3DF   ;2
       LDA    $B4     ;3
       SEC    ;2
       SBC    #$07    ;2
       STA    $E8     ;3
       LSR    ;2
       LSR    ;2
       ADC    $E8     ;3
       ROR    ;2
       JSR    LFCA9   ;6
       ORA    $E8     ;3
       STA    $F1     ;3
       LDA    $B3     ;3
       BPL    LF3C4   ;2
       LDX    #$07    ;2
       CLC    ;2
       ADC    #$54    ;2
       BCS    LF3DA   ;2
       ADC    #$24    ;2
       LSR    ;2
       LSR    ;2
       TAX    ;2
       LDA    LF409,X ;4
       BNE    LF3DD   ;2
LF3C4: LDX    #$00    ;2
       LDA    #$07    ;2
       CLC    ;2
       SBC    $B4     ;3
       CMP    #$F9    ;2
       BCS    LF3D7   ;2
       LDA    $B4     ;3
       SBC    #$DE    ;2
       CMP    #$F9    ;2
       BCC    LF3DA   ;2
LF3D7: ADC    #$06    ;2
       TAX    ;2
LF3DA: TXA    ;2
       ADC    #$C1    ;2
LF3DD: STA    $F2     ;3
LF3DF: LDX    #$06    ;2
       LDA    $98     ;3
       ORA    #$E0    ;2
       SEC    ;2
LF3E6: SBC    #$20    ;2
       TAY    ;2
       LDA    $FEEF,Y ;4
       AND    #$FE    ;2
       STA    $F4,X   ;4
       TYA    ;2
       DEX    ;2
       BNE    LF3E6   ;2
       STX    $F4     ;3
       CMP    #$28    ;2
       BCS    LF3FC   ;2
       DEC    $F4     ;5
LF3FC: LDA    #$2A    ;2
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       STA    $F3     ;3
       LDY    #$10    ;2
       STY    CTRLPF  ;3
       RTS    ;6

LF409: .byte $DD,$EB,$DD,$EB,$F9,$EB,$F9,$EB,$F9,$A5,$84,$85,$E9,$A9
LF417: .byte $1C,$D0,$0C,$85,$E9,$A9,$08,$D0,$06
LF420: LDA    $84     ;3
       STA    $E9     ;3
       LDA    #$00    ;2
       STX    $E8     ;3
       CLC    ;2
       ADC    $E8     ;3
       TAX    ;2
       LDA    $E9     ;3
       AND    #$0F    ;2
       CMP    $E5     ;3
       PHP    ;3
       EOR    $E9     ;3
       LSR    ;2
       LSR    ;2
       LSR    ;2
       LSR    ;2
       EOR    #$08    ;2
       SBC    #$07    ;2
       PLP    ;4
       ADC    $99,X   ;4
       STA    $99,X   ;4
       LDX    $E8     ;3
       RTS    ;6

LF445: .byte $86,$E8,$84,$E9,$A2,$06,$A0,$FE,$D5,$99,$D0,$01,$C8,$CA,$10,$F8
       .byte $A6,$E8,$98,$A4,$E9,$0A,$60,$A5,$81,$29,$07,$D0,$1B,$C6,$88,$10
       .byte $17,$A6,$86,$CA,$CA,$F0,$02,$86,$86,$A6,$90,$E8,$E0,$26,$90,$02
       .byte $A2,$1F,$86,$90,$A9,$5A,$85
LF47C: .byte $88,$A2,$02,$B5,$AA,$4A,$C9,$02,$D0,$1C,$20,$A7,$F0,$4A,$F0,$13
       .byte $A5,$84,$85,$E9,$A9,$19,$20,$26,$F4,$C9,$D6,$90,$09,$A9,$D6,$95
       .byte $B2,$D0,$03,$20,$20,$F4,$CA,$10,$DA,$A2,$03,$B5,$AD,$0A,$10,$05
       .byte $A5,$84,$20,$31,$FA,$CA,$10,$F3,$A5,$D4,$30,$14,$A2,$02,$B5,$AA
       .byte $C9,$07,$90,$02,$A9,$05,$69,$0F,$20,$5F,$FB,$CA,$10,$F0,$30,$53
       .byte $A5,$98,$C9,$02,$A6,$B3,$F0,$36,$30,$0B,$C6,$B3,$D0,$45,$E6,$B3
       .byte $B0,$41,$4C,$43,$F1,$B0,$07,$E0,$E2,$90,$03,$4A,$85,$84,$E6,$B3
       .byte $D0,$31,$C6,$B3,$A5,$81,$29,$0F,$D0,$29,$A9,$6A,$85,$94,$A0,$01
       .byte $20,$B1,$F7,$C6,$85,$10,$1C,$A5,$B2,$85,$85,$4C,$47,$F1,$E6,$A1
       .byte $A2,$13,$A5,$B2,$20,$1A,$F4,$C9,$08,$90,$04,$C9,$DE,$90,$04,$A9
       .byte $37,$85,$B3,$20,$0B,$FE,$A2,$03,$B5,$AD,$29,$3F,$18,$69,$16,$20
       .byte $5F,$FB,$CA,$10,$F3,$20,$C0,$F6,$A2,$06,$B5,$99,$C9,$CE,$90,$1C
       .byte $A5,$A9,$69,$05,$F5,$A1,$C9,$09,$B0,$12,$B5,$AA,$29,$3F,$F0,$0C
       .byte $C9,$13,$F0,$44,$C9,$06,$90,$09,$C9,$0C,$B0,$05,$CA,$10,$DB,$30
       .byte $49,$E0,$03,$B0,$07,$C6,$D4,$A0,$04,$20,$B1,$F7,$A5,$8D,$A6,$D4
       .byte $D0,$04,$09,$40,$D0,$06,$10,$06,$E6,$D4,$29,$BF,$85,$8D,$20,$B0
       .byte $F1,$85,$81,$A9,$1E,$85,$84,$4A,$85,$98,$A5,$85,$85,$B2,$A9,$05
       .byte $85,$8C,$A9,$78,$85,$94,$D0,$15,$A9,$00,$95,$AA,$A9,$EA,$85,$EC
       .byte $E6,$85,$10,$02,$C6,$85,$A9,$30,$85,$94,$20,$56,$F7,$A5,$B1,$29
       .byte $3F,$F0,$77,$85,$EA,$A9,$FF,$85,$E8,$85,$E9,$A2,$06,$A5,$A8,$18
       .byte $69,$07,$F5,$A1,$C9,$0D,$B0,$36,$A5,$A0,$69,$09,$F5,$99,$C9,$11
       .byte $B0,$2C,$A8,$B5,$AA,$29,$3F,$F0,$25,$E0,$03,$B0,$06,$C9,$06,$90
       .byte $15,$B0,$1B,$C9,$06,$90,$04,$C9,$0C,$90,$13,$4A,$C9,$01,$D0,$06
       .byte $A5,$EA,$C9,$23,$F0,$08,$C4,$E9,$B0,$04,$86,$E8,$84,$E9,$CA,$10
       .byte $BC,$8A,$A6,$E8,$30,$24,$85,$A0,$A9,$C0,$85,$B1,$E0,$03,$B0,$1B
       .byte $C6,$D4,$A5,$88,$18,$E9,$15,$85,$88,$A0,$04,$20,$B1,$F7,$A9,$06
       .byte $95,$AA,$A9,$08,$95,$B2,$A9,$1B,$85,$94,$60,$B5,$AA,$29,$3F,$4A
       .byte $4A,$C9,$04,$F0,$1B,$A0,$03,$C9,$07,$F0,$E0,$A4,$EA,$C0,$23,$D0
       .byte $DD,$C9,$03,$F0,$04,$A9,$14,$D0,$DF,$16,$AA,$38,$76,$AA,$D0,$F5
       .byte $B5,$99,$E9,$0A,$95,$99,$A9,$01,$95,$AA,$A9,$5B,$D0,$CA,$1E,$0E
       .byte $8C,$48,$14,$42,$50,$40,$A5,$81,$4A,$B0,$22,$4A,$B0,$22,$4A,$A5
       .byte $B2,$E9,$00,$30,$02,$85,$85,$C6
LF674: .byte $84,$D0,$2B,$A2,$50,$86,$81,$A6,$B2,$CA,$86,$85,$30,$1E,$A9,$72
       .byte $85,$94,$4C,$8E,$F1,$4A,$90,$16,$C9,$08,$B0,$12,$A8,$B9,$5A,$F6
       .byte $85,$EC,$90,$0A,$A5,$83,$D0,$06,$A9,$98,$85,$94,$E6,$8C,$4C,$0B
       .byte $FE,$C6,$84,$C6,$84,$A5,$84,$49,$80,$4A,$C9,$06,$B0,$06,$AA,$BC
       .byte $B4,$F0,$84,$EC,$C9,$4A,$D0,$E6,$C6,$84,$D0,$E0,$A5,$D4,$10,$04
       .byte $A5,$B3,$D0,$1F,$AD,$80,$02,$A2,$04,$0A,$10,$08,$B0,$15,$A9,$A2
       .byte $A2,$08,$D0,$02,$A9,$5E,$C5,$A9,$F0,$09,$20,$1F,$F7,$86,$8D,$05
       .byte $8D,$85,$8D,$A5,$8D,$29,$0C,$F0,$38,$C9,$08,$A5,$A9,$B0,$16,$A0
       .byte $05,$88,$D9,$F9,$F7,$90,$FA,$F0,$F8,$E9,$03,$85,$A9,$D9,$F9,$F7
       .byte $90,$14,$F0,$12,$60,$A0,$01,$C8,$D9,$F9,$F7,$B0,$FA,$69,$03,$85
       .byte $A9,$D9,$F9,$F7,$90,$0B,$B9,$F9,$F7,$85,$A9
LF71F: LDA    $8D     ;3
       AND    #$F3    ;2
       STA    $8D     ;3
       RTS    ;6

LF726: .byte $A5,$8D,$29,$0C,$D0,$29,$A2,$23,$A0,$01,$A5,$0C,$10,$15,$AD,$80
       .byte $02,$29,$10,$D0,$1A,$A2,$C0,$A0,$54,$A5,$D3,$F0,$0E,$C6,$D3,$A2
       .byte $26,$A0,$46,$A5,$A9,$85,$A8,$A9,$CE,$85,$A0,$86,$B1,$84,$95,$60
       .byte $A5,$D4,$10,$06,$A9,$C0,$A6,$B3,$D0,$0A,$A5,$B1,$F0,$C2,$C9,$40
       .byte $90,$05,$E9,$40,$85,$B1,$60,$AA,$A5,$A0,$E9,$07,$85,$A0,$E0,$23
       .byte $D0,$08,$C9,$62,$B0,$F0,$A9,$00,$F0,$EA,$A8,$A9,$24,$C0,$80,$69
       .byte $00,$C0,$4E,$69,$00,$C0,$35,$B0,$DB,$A5,$D4,$10,$E9,$A5,$A8,$38
       .byte $E5,$B4,$C9,$1C,$B0,$E0,$A9,$88,$85,$B3,$A9,$0E,$85,$EC,$A9,$8D
       .byte $85,$94,$A5,$85,$85,$B2,$20,$B0,$F1,$A0,$03,$F8,$A5,$80,$18,$69
       .byte $10,$90,$02,$A9,$99,$85,$E8,$A9,$00,$85,$E9,$C0,$04,$08,$18,$65
       .byte $E8,$90,$02,$E6,$E9,$88,$D0,$F6,$28,$F0,$08,$A0,$04,$0A,$26,$E9
       .byte $88,$D0,$FA,$18,$65,$89,$85,$89,$A5,$8A,$65,$E9,$85,$8A,$A5,$8B
       .byte $69,$00,$85,$8B,$90,$08,$A9,$99,$85,$89,$85,$8A,$85,$8B,$D8,$60
       .byte $00,$00
LF7F8: .byte $00,$3C,$5E,$6F,$80,$91,$A2,$C4,$FF,$FF,$FF,$A0,$00,$86,$E8,$A2
       .byte $02,$B5,$AA,$F0,$01,$C8,$CA,$10,$F8,$A6,$E8,$C4,$D4,$B0,$18,$A9
       .byte $80,$95,$A1,$A5,$82,$0A,$A9,$00,$95,$99,$69,$02,$95,$AA,$A5,$82
       .byte $29,$0F,$65,$86,$95,$B2,$60,$98,$D0,$FC,$AA,$E6,$8C,$85,$B3,$85
       .byte $A1,$A9,$07,$A0,$10,$24,$82,$30,$04,$A9,$DE,$A0,$F0,$85,$B4,$84
       .byte $B2,$A9,$0E,$85,$94,$60,$A9,$B3,$20,$22,$F4,$C9,$20,$90,$C4,$60
       .byte $D6,$A1,$B5,$A1,$DD,$AA,$F0,$B0,$0E,$F6,$AA,$60,$F6,$A1,$B5,$A1
       .byte $DD,$AD,$F0,$90,$02,$D6,$AA,$D6,$B2,$D0,$F0,$A9,$05,$95,$B2,$A0
       .byte $02,$B9,$AA,$00,$4A,$C9,$02,$D0,$07,$B9,$99,$00,$C9,$40,$90,$DB
       .byte $88,$10,$EE,$A5,$98,$95,$99,$A0,$04,$B5,$A1,$30,$01,$C8,$94,$AA
       .byte $A4,$90,$B9,$C3,$FC,$A8,$4C,$6A,$F9,$CA,$CA,$CA,$20,$09,$FB,$E8
       .byte $E8,$E8,$60,$20,$A7,$F0,$4A,$D0,$28,$B5,$AA,$6A,$10,$0C,$B0,$0C
       .byte $A5,$ED,$20,$1A,$F4,$D5,$B2,$B0,$11,$60,$B0,$F4,$A9,$00,$38,$E5
       .byte $ED,$20,$1A,$F4,$D5,$B2,$F0,$02,$B0,$EF,$B5,$B2,$95,$A1,$4C,$0B
       .byte $F9,$B0,$23,$E5,$ED,$20,$22,$F4,$D5,$B2,$F0,$23,$90,$21,$60,$A5
       .byte $EE,$29,$07,$4A,$F0,$2D,$A9,$1F,$B0,$02,$A9,$E0,$75,$B2,$95,$B2
       .byte $60,$A9,$01,$95,$AA,$60,$A5,$ED,$20,$22,$F4,$D5,$B2,$90,$DF,$B5
       .byte $B2,$95,$99,$B4,$91,$A5,$EF,$29,$07,$4A,$D0,$07,$B5,$99,$20,$45
       .byte $F4,$90,$CC,$A5,$EE,$10,$4A,$A0,$03,$B9,$AD,$00,$F0,$05,$88,$10
       .byte $F8,$30,$3C,$B5,$99,$C9,$C7,$B0,$36,$C9,$60,$90,$32,$69,$07,$99
       .byte $9C,$00,$B5,$A1,$C9,$3C,$F0,$27,$C9,$C4,$F0,$23,$99,$A4,$00,$84
       .byte $E8,$A0,$03,$C4,$E8,$F0,$0A,$B5,$99,$18,$F9,$9C,$00,$C9,$F2,$B0
       .byte $0E,$88,$10,$EF,$A9,$25,$85,$95,$A9,$02,$A4,$E8,$99,$AD,$00,$B4
       .byte $91,$C8,$94,$91,$20,$A7,$F0,$C9,$04,$B0,$86,$4A,$D0,$40,$B5,$AA
       .byte $6A,$30,$13,$B0,$13,$B5,$A1,$A0,$0A,$88,$D9,$F6,$F7,$90,$FA,$F0
       .byte $01,$C8,$A9,$18,$D0,$12,$B0,$ED,$B5,$A1,$A0,$02,$C8,$D9,$F6,$F7
       .byte $F0,$03,$B0,$F8,$88,$C8,$A9,$20,$84,$E8,$B4,$91,$45,$EE,$29,$38
       .byte $4A,$4A,$4A,$65,$E8,$E9,$03,$A8,$B9,$F6,$F7,$95,$B2,$60,$A9,$20
       .byte $B0,$02,$A9,$E0,$85,$E8,$A5,$EE,$29,$38,$4A,$4A,$4A,$A8,$B5,$99
       .byte $18,$65,$E8,$C9,$E0,$B0,$E4,$88,$10,$F6,$30,$DF,$A5,$81,$29,$01
       .byte $55,$AD,$95,$AD,$A5,$87,$D0,$51,$A9,$2D,$D0,$4A,$A5,$87,$4A,$69
       .byte $13,$D0,$05,$A9,$0C,$18,$65,$87,$20,$31,$FA,$A8,$B5,$AD,$29,$FC
       .byte $C0,$68,$69,$00,$C0,$90,$69,$00,$C0,$B0,$69,$00,$95,$AD,$60,$B4
       .byte $AD,$30,$08,$C8,$98,$C9,$5F,$D0,$0A,$F0,$06,$88,$98,$C9,$DC,$D0
       .byte $02,$49,$80,$95,$AD,$B5,$B5,$85,$E9,$A9,$0B,$4C,$26,$F4,$20,$37
       .byte $FA,$F6,$AD,$60,$A9,$0E,$18,$65,$87,$85,$E9,$A9,$03,$D0,$EC,$20
       .byte $1D,$FA,$E5,$A9,$55,$B5,$30,$10,$A0,$05,$B9,$F9,$F7,$69,$03,$F5
       .byte $A4,$C9,$07,$90,$06,$88,$D0,$F2
LFA50: .byte $68,$68,$60,$B9,$F9,$F7,$95,$A4,$60,$B5,$A4,$A0,$00,$C8,$D9,$F9
       .byte $F7,$B0,$FA,$B5,$B5,$08,$20,$1D,$FA,$28,$30,$06,$D9,$F9,$F7,$B0
       .byte $07,$60,$D9,$F8,$F7,$B0,$FA,$88,$B9,$F9,$F7,$95,$A4,$D0,$AA,$A9
       .byte $FB,$20,$2E,$FA,$C9,$CF,$90
LFA87: .byte $E9,$A9,$CF,$95,$9C,$D0,$9B,$A9,$E0,$E5,$87,$20,$31,$FA,$A5,$98
       .byte $09,$80,$D5,$9C,$90,$D4,$95,$9C,$B5,$B5,$10,$02,$D6,$A4,$A9,$60
       .byte $95,$AD,$60,$B5,$AD,$30,$40,$20,$12,$F4,$A9,$13,$20,$ED,$F9,$98
       .byte $D5,$B5,$90,$32,$A5,$80,$C9,$19,$90,$02,$A9,$19,$0A,$0A,$0A,$E9
       .byte $0F,$D5,$9C,$90,$2D,$B5,$A4,$C5,$A9,$F0,$27,$B5,$B5,$95,$9C,$20
       .byte $45,$F4,$90,$1E,$B5,$A4,$C5,$A9,$A9,$2C,$90,$02,$A9,$D4,$95,$B5
       .byte $B5,$AD,$49,$C0,$95,$AD,$60,$B4,$9C,$20,$F4,$F9,$20,$37,$FA,$20
       .byte $E7,$FA,$A9,$20,$18,$75,$9C,$95,$B5,$60,$30,$30,$30,$32,$34,$36
       .byte $00,$1C,$B4,$B5,$F0,$07,$D6,$B5,$B9,$00,$FB,$85,$EC,$D6,$9C,$D6
       .byte $9C,$A5,$81,$4A,$B5,$AD
LFB1D: .byte $69,$00,$C9,$0C,$90,$02,$A9,$00,$95,$AD,$60,$8A,$45,$81,$29,$07
       .byte $D0,$F8,$A4,$8D,$10,$05,$A4,$D4,$88,$F0,$04,$A5,$82,$29,$07,$A8
       .byte $85,$E8,$F8,$65,$E8,$D8,$C5,$80,$90,$02,$D0,$DE,$A5,$D4,$F0,$0A
       .byte $10,$0A,$A5,$B3,$D0,$D4,$A5,$A1,$30,$D0,$A0,$03,$B9,$87,$FD,$95
       .byte $AD,$98
LFB5F: TAY    ;2
       LDA    LFD15,Y ;4
       STA    $E8     ;3
       LDA    LFD4E,Y ;4
       STA    $E9     ;3
       JMP.ind ($00E8);5
LFB6D: .byte $B5,$AD,$30,$20,$B5,$B5,$10,$12,$A9,$13,$20,$ED,$F9,$C0,$CE,$90
       .byte $08,$A9,$CE,$95,$9C,$A9,$3C,$95,$B5,$60,$F0,$03,$D6,$B5,$60,$A9
       .byte $08,$4C,$31,$FA,$A9,$8D,$20,$F0,$F9,$C0,$20,$90,$61,$60,$86,$E8
       .byte $A0,$03,$C4,$E8,$F0,$09,$B9,$AD,$00,$4A,$4A,$C9,$03,$F0,$4F,$88
       .byte $10,$F0,$94,$B5,$A5,$82,$0A,$2A,$29,$01,$69,$02,$10,$0F,$A9,$40
       .byte $05,$98,$95,$B5,$A5,$82,$0A,$2A,$2A,$29,$03,$69,$01,$A8,$B9,$F9
       .byte $F7,$95,$A4,$A0,$06,$B9,$99,$00,$F0,$04,$C9,$40,$90,$20,$88,$10
       .byte $F4,$A9,$20,$95,$9C,$4A,$D5,$AD,$D0,$04,$06,$8D,$46,$8D,$60,$A5
       .byte $D4,$C9,$0A,$10,$09,$A5,$82,$0A,$0A,$0A,$25,$8D,$30,$C6,$A9,$00
       .byte $95,$AD,$60,$A5,$82,$29,$38,$D0,$F5,$A5,$8D,$29,$03,$F0,$EF,$A9
       .byte $28,$A0,$20,$24,$82,$30,$04,$A9,$D8,$A0,$E0,$95,$B5,$94,$A4,$A9
       .byte $40,$05,$98,$95,$9C,$20,$45,$F4,$D0,$04,$A5,$D4,$30,$0E,$90,$CE
LFC2D: .byte $B5,$AD,$C9,$5C,$D0,$06,$C6,$8D,$A9,$38,$85,$94,$60,$86,$E8,$A0
       .byte $03,$C4,$E8,$F0,$0B,$B9,$AD,$00,$C9,$60,$90,$04,$C9,$63,$90,$AE
       .byte $88,$10,$EE,$A5,$82,$0A,$29,$C0,$D0,$A4,$A9,$34,$A0,$36,$90,$04
       .byte $A9,$CC,$A0,$C3,$95,$B5,$94,$A4,$A9,$80,$D0,$B5
LFC69: STA    $E9     ;3
       LSR    ;2
LFC6C: LSR    ;2
       LSR    ;2
       LSR    ;2
       SBC    $E9     ;3
       ADC    #$C7    ;2
       STA    $E8     ;3
       TXA    ;2
       DEX    ;2
       EOR    #$7F    ;2
       BMI    LFC7E   ;2
       TXA    ;2
       ORA    #$80    ;2
LFC7E: STA    $E9     ;3
       LDA    #$00    ;2
       BEQ    LFC87   ;2
LFC84: ADC    $E8     ;3
       ROR    ;2
LFC87: LSR    $E9     ;5
       BCC    LFC84   ;2
       BEQ    LFC94   ;2
LFC8D: LSR    ;2
       LSR    $E9     ;5
       BCC    LFC84   ;2
       BNE    LFC8D   ;2
LFC94: CLC    ;2
       INX    ;2
       BMI    LFC9B   ;2
       EOR    #$FF    ;2
       SEC    ;2
LFC9B: ADC    #$4C    ;2
       CMP    #$9A    ;2
       BCS    LFCC4   ;2
       ADC    #$0B    ;2
LFCA3: CMP    #$0F    ;2
       BCS    LFCA9   ;2
       SBC    #$0A    ;2
LFCA9: TAX    ;2
       LSR    ;2
       LSR    ;2
       LSR    ;2
       LSR    ;2
       STA    $E8     ;3
       TXA    ;2
       AND    #$0F    ;2
       CLC    ;2
       ADC    $E8     ;3
       CMP    #$0F    ;2
       BCC    LFCBE   ;2
       INC    $E8     ;5
       SBC    #$0F    ;2
LFCBE: EOR    #$07    ;2
       ASL    ;2
       ASL    ;2
       ASL    ;2
       ASL    ;2
LFCC4: RTS    ;6

LFCC5: .byte $00,$06,$09,$0D,$12,$17,$1B,$22,$28,$2F,$35,$3B,$41,$45,$4B,$4E
       .byte $55,$5F,$69,$6E,$72,$78,$7E,$82,$87,$8D,$95,$9B,$A3,$AB,$B0,$B5
       .byte $BC,$C3,$C9
LFCE8: .byte $D3,$01,$00,$0F,$09,$09,$01,$01,$09,$09,$0D,$0D,$09,$09,$00,$09
       .byte $01,$01,$0F,$0D,$00,$09,$09,$0F,$01,$01,$01,$0F,$09,$01,$01,$09
       .byte $0F,$0F,$0F,$09,$01,$01,$00,$01,$01,$09,$00,$00,$0F
LFD15: .byte $EC,$C1,$00,$0C,$3A,$9B,$BB,$FB,$A2,$98,$A5,$5C,$A5,$62,$A2,$03
       .byte $4E,$58,$64,$AB,$AB,$A1,$28,$E0,$D4,$D4,$26,$2C,$09,$09,$09,$09
       .byte $09,$09,$6D,$6D,$6D,$6D,$E4,$E4,$E4,$E4,$AA,$AA,$AA,$AA,$EB,$EB
       .byte $EB,$EB,$07,$07,$07,$07,$59,$7F,$8E
LFD4E: .byte $FB,$FB,$FC,$FC,$FC,$FB,$FB,$FB,$F6,$F6,$F6,$F4,$F4,$F6,$F6,$F8
       .byte $F8,$F8,$F8,$F8,$F8,$F8,$FB,$F9,$F9,$F9,$FA,$FA,$FB,$FB,$FB
LFD6D: .byte $FB,$FB,$FB,$FB,$FB,$FB,$FB,$F9,$F9,$F9,$F9,$FA,$FA,$FA,$FA,$F9
       .byte $F9,$F9,$F9,$FA,$FA,$FA,$FA,$FA,$FA,$FA,$10,$18,$5C,$44,$60,$0C
       .byte $14
LFD8E: .byte $00,$34,$68,$56,$D8,$D8,$1A,$18,$16,$0E,$26,$56,$CA,$CA,$CA,$CA
       .byte $18,$18,$18,$18,$28,$28,$28,$28,$14,$14,$14,$14,$1A,$1A,$1A,$1A
       .byte $DA,$DA,$DA,$36,$68,$68,$68
LFDB5: STA    AUDV0,X ;4
       BNE    LFDE8   ;2
LFDB9: LSR    ;2
       STA    AUDV0,X ;4
       ROL    ;2
LFDBD: LSR    ;2
       INY    ;2
       LDA    LFE65,Y ;4
       STA    AUDC0,X ;4
       ROR    ;2
       LSR    ;2
       LSR    ;2
       LSR    ;2
       CPY    #$A4    ;2
       BCC    LFDE2   ;2
       JSR    LF1C7   ;6
       CMP    #$31    ;2
       BCC    LFDD5   ;2
       LDA    #$30    ;2
LFDD5: EOR    #$FF    ;2
       LSR    ;2
       BPL    LFDE2   ;2
LFDDA: AND    #$07    ;2
       EOR    #$04    ;2
       SBC    #$04    ;2
       ADC    $96,X   ;4
LFDE2: STA    AUDF0,X ;4
       AND    #$1F    ;2
       STA    $96,X   ;4
LFDE8: INY    ;2
       STY    $94,X   ;4
       LDA    LFE65,Y ;4
       TAY    ;2
       AND    #$8F    ;2
       BEQ    LFE01   ;2
       AND    #$83    ;2
       CMP    #$02    ;2
       BEQ    LFE01   ;2
       TYA    ;2
       AND    #$70    ;2
       ASL    ;2
       ORA    $96,X   ;4
LFDFF: STA    $96,X   ;4
LFE01: LDA    #$2F    ;2
       DEX    ;2
       BPL    LFE13   ;2
       LDX    $E6     ;3
       LDY    $E7     ;3
       RTS    ;6

LFE0B: STX    $E6     ;3
       STY    $E7     ;3
       LDX    #$01    ;2
       LDA    #$03    ;2
LFE13: LDY    INTIM   ;4
       BPL    LFE13   ;2
       STA    WSYNC   ;3
       STA    TIM64T  ;4
       TXA    ;2
       ASL    ;2
       STA    VSYNC   ;3
       LDA    $96,X   ;4
       SEC    ;2
       SBC    #$20    ;2
       BCS    LFDFF   ;2
       LDY    $94,X   ;4
       LDA    LFE65,Y ;4
       BMI    LFDB5   ;2
       LSR    ;2
       BCS    LFDDA   ;2
       LSR    ;2
       BCS    LFDB9   ;2
       LSR    ;2
       BCS    LFDBD   ;2
       LSR    ;2
       BCC    LFE4D   ;2
       INY    ;2
       LDA    LFE65,Y ;4
       EOR    $96,X   ;4
       STA    $E9     ;3
       AND    #$1F    ;2
       BEQ    LFDE8   ;2
       EOR    $E9     ;3
       ASL    ;2
       ROL    ;2
       ROL    ;2
       ROL    ;2
LFE4D: STA    $E8     ;3
       BNE    LFE53   ;2
       STA    AUDV0,X ;4
LFE53: TYA    ;2
       SBC    $E8     ;3
       TAY    ;2
       DEC    $E8     ;5
       BNE    LFDE8   ;2
       LDY    #$A3    ;2
       LDA    $D4     ;3
       BPL    LFDE8   ;2
       LDY    #$0D    ;2
       BNE    LFDE8   ;2
LFE65: BRK    ;7
       .byte $5A ;.NOOP       ;2
       .byte $03 ;.SLO;8
       ORA    ($01,X) ;6
       ORA    ($01,X) ;6
       ORA    #$01    ;2
LFE6E: ORA    ($01,X) ;6
       ORA    ($01,X) ;6
       BRK    ;7
       .byte $42 ;.JAM;0
       LDY    $2A87,X ;4
       BIT    $5250   ;4
       PLP    ;4
       .byte $0F ;.SLO;6
       .byte $0F ;.SLO;6
LFE7D: .byte $0F ;.SLO;6
       .byte $0F ;.SLO;6
       BPL    LFEFB   ;2
       .byte $32 ;.JAM;0
       .byte $13 ;.SLO;8
       ORA    $A214,Y ;4
       .byte $0F ;.SLO;6
       PHP    ;3
       EOR    ($10,X) ;6
       .byte $62 ;.JAM;0
       SEC    ;2
       LDY    $D142   ;4
       STY    $92     ;3
       ORA    ($18,X) ;6
       STY    VSYNC,X ;4
       .byte $02 ;.JAM;0
       .byte $0C ;.NOOP       ;4
       .byte $0F ;.SLO;6
       .byte $80 ;.NOOP       ;2
       .byte $9F ;.SHA;5
       PLP    ;4
       .byte $9C ;.SHY;5
       BPL    LFF18   ;2
       LDY    PF2     ;3
       .byte $83 ;.SAX;6
       .byte $8F ;.SAX;4
       PHP    ;3
       STX    COLUP1  ;3
       .byte $0F ;.SLO;6
       .byte $83 ;.SAX;6
       .byte $8F ;.SAX;4
       PHP    ;3
       STX    RESP0   ;3
       .byte $7A ;.NOOP       ;2
       .byte $23 ;.RLA;8
       .byte $3C ;.NOOP       ;4
       .byte $7C ;.NOOP       ;4
       .byte $0B ;.ANC;2
       .byte $0B ;.ANC;2
       .byte $0B ;.ANC;2
       .byte $0C ;.NOOP       ;4
       .byte $7C ;.NOOP       ;4
       ORA    #$09    ;2
       ORA    #$09    ;2
       BRK    ;7
       .byte $42 ;.JAM;0
       .byte $23 ;.RLA;8
       TAY    ;2
       ROR    LFFDC,X ;7
       BRK    ;7
       ROR    $147C,X ;7
       CPX    $1417   ;4
       .byte $DC ;.NOOP       ;4
       .byte $17 ;.SLO;6
LFEC8: .byte $83 ;.SAX;6
       ORA    #$1C    ;2
       .byte $3C ;.NOOP       ;4
       ORA    $1019,Y ;4
       ROR    $8F7C,X ;7
       .byte $0F ;.SLO;6
       .byte $80 ;.NOOP       ;2
       PHP    ;3
       .byte $93 ;.SHA;6
       BEQ    LFEC8   ;2
       .byte $74 ;.NOOP       ;4
       LSR    $F8,X   ;6
       ADC    $7A50   ;4
       .byte $1F ;.SLO;7
       .byte $07 ;.SLO;5
       PHP    ;3
       EOR    $6F04   ;4
       .byte $07 ;.SLO;5
       PHP    ;3
       LSR    NUSIZ0,X;6
       .byte $DF ;.DCP;7
       .byte $07 ;.SLO;5
       PHP    ;3
       EOR    $130C,X ;4
       ADC    ($18),Y ;5
       .byte $5F ;.SRE;7
       BRK    ;7
       ROR    $77F8,X ;7
       ORA    ($38,X) ;6
       BVC    LFE7D   ;2
       ORA    ($68,X) ;6
LFEFB: .byte $5F ;.SRE;7
       BRK    ;7
       .byte $7A ;.NOOP       ;2
       BIT    $B674   ;4
       .byte $7C ;.NOOP       ;4
       SED    ;2
       .byte $2F ;.RLA;6
LFF04: PHP    ;3
       .byte $47 ;.SRE;5
       .byte $FF ;.ISB;7
       .byte $FF ;.ISB;7
       .byte $F3 ;.ISB;8
       ASL    $FC     ;5
       SBC    ($F3),Y ;5
       .byte $A3 ;.LAX;6
       RTS    ;6

LFF0F: .byte $77,$77,$77,$76,$76,$76,$76,$76,$75
LFF18: ADC    $75,X   ;4
       ADC    $74,X   ;4
       .byte $74 ;.NOOP       ;4
       .byte $74 ;.NOOP       ;4
       .byte $74 ;.NOOP       ;4
       .byte $73 ;.RRA;8
       .byte $73 ;.RRA;8
       .byte $73 ;.RRA;8
       .byte $73 ;.RRA;8
       .byte $73 ;.RRA;8
       .byte $72 ;.JAM;0
       .byte $72 ;.JAM;0
       .byte $72 ;.JAM;0
       .byte $72 ;.JAM;0
       ADC    ($71),Y ;5
       ADC    ($70),Y ;5
       BVS    LFF9E   ;2
       BVS    LFF9F   ;2
       .byte $6F ;.RRA;6
       .byte $6F ;.RRA;6
       .byte $6F ;.RRA;6
       ROR    $6E6E   ;6
       ADC    $6D6D   ;4
       ADC    $6C6C   ;4
       .byte $6C,$6B,$6B
LFF3F: .byte $6B,$6A,$6A,$6A,$6A,$69,$69,$69,$68,$68,$67,$67,$67,$66,$66,$66
       .byte $65,$65,$65,$64,$64,$63,$63,$63,$62,$62,$61,$61,$61,$60,$60,$5F
       .byte $5F,$5F,$5E,$5E,$5D,$5D,$5C,$5C,$5B,$5B,$5A,$5A,$59,$59,$58,$58
       .byte $57,$57,$56,$56,$55,$55,$54,$53,$53,$52,$52,$51,$50
LFF7C: .byte $50,$4F,$4F,$4E,$4D,$4D,$4C,$4B,$4B,$4A,$49,$48,$48,$47,$46,$46
       .byte $45,$44,$43,$42,$42,$41,$40,$3F,$3E,$3D,$3C,$3B,$3A,$39,$39,$38
       .byte $37,$36
LFF9E: .byte $34 ;.NOOP       ;4
LFF9F: .byte $33 ;.RLA;8
LFFA0: .byte $32,$31,$30,$2F,$2E,$2D,$2C,$2A,$29,$28,$27,$25,$24,$22,$21,$20
       .byte $1E,$1D,$1B,$1A,$18
LFFB5: ASL    AUDC0,X ;6
LFFB7: .byte $13,$11,$10,$0E,$0C,$0A,$08,$06,$04,$02,$00,$00,$00,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF
LFFDC: .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
LFFF8  .byte $FF
LFFF9: .byte $FF
    .word $F000
    .word $F000
    .word $F000
