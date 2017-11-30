;DOUBLE DRAGON...merged disassembly by Kurt (Nukey Shay) Howe

;options...
PAL   = 0 ; color palette
PAL50 = 0 ; timing adjust for 50hz
CCE   = 0 ; use CCE logo instead of ActiVision
INFINITE_LIFE = 0
EVERYONE_WEAK = 0
TWO_BUTTON    = 1

; Disassembly of DDragon1
; Disassembled Thu Jun 24 16:53:17 2010
; Using DiStella v3.0
; Command Line: C:\BIN\D3.EXE -pafscDDragon.cfg DDragon1
; DDragon.cfg contents:
;      ORG  9000
;      CODE 9000 9003
;      GFX  9004 906E
;      CODE 906F 90D2
;      GFX  90D3 92A9
;      CODE 92AA 9610
;      GFX  9611 9620
;      CODE 9621 98E2
;      GFX  98E3 9BBE
;      CODE 9BBF 9BDA
;      GFX  9BDB 9FCF
;      CODE 9FD0 9FF3
;      GFX  9FF4 9FFF
;
; Disassembly of DDragon2
; Disassembled Thu Jun 24 17:02:22 2010
; Using DiStella v3.0
; Command Line: C:\BIN\D3.EXE -pafscDDragon.cfg DDragon2
; DDragon.cfg contents:
;      ORG  B000
;      CODE B000 B168
;      GFX  B169 BE30
;      CODE BE31 BEE2
;      GFX  BEE3 BF52
;      CODE BF53 BFA0
;      GFX  BFA1 BFC3
;      CODE BFC4 BFF3
;      GFX  BFF4 BFFF
;
; Disassembly of DDragon3
; Disassembled Thu Jun 24 17:22:18 2010
; Using DiStella v3.0
; Command Line: C:\BIN\D3.EXE -pafscDDragon.cfg DDragon3 
; DDragon.cfg contents:
;      ORG  D000
;      CODE D000 D0B0
;      GFX  D0B1 D103
;      CODE D104 D1FE
;      GFX  D1FF D1FF
;      CODE D200 D2FC
;      GFX  D2FD D8E9
;      CODE D8EA D8FA
;      GFX  D8FB DAC3
;      CODE DAC4 DC22
;      GFX  DC23 DC23
;      CODE DC24 DCE1
;      GFX  DCE2 DCE2
;      CODE DCE3 DEF9
;      GFX  DEFA DF5F
;      CODE DF60 DFA4
;      GFX  DFA5 DFB7
;      CODE DFB8 DFF3
;      GFX  DFF4 DFFF
;
; Disassembly of DDragon4
; Disassembled Thu Jun 24 17:34:35 2010
; Using DiStella v3.0
; Command Line: C:\BIN\D3.EXE -pafscDDragon.cfg DDragon4 
; DDragon.cfg contents:
;      ORG  F000
;      CODE F000 FAF3
;      GFX  FAF4 FAF4
;      CODE FAF5 FCC7
;      GFX  FCC8 FCD0
;      CODE FCD1 FEE9
;      GFX  FEEA FFB7
;      CODE FFB8 FFF3
;      GFX  FFF4 FFFF

      processor 6502

;equates...
VSYNC   =  $00
VBLANK  =  $01
WSYNC   =  $02
NUSIZ0  =  $04
NUSIZ1  =  $05
COLUP0  =  $06
COLUP1  =  $07
COLUPF  =  $08
COLUBK  =  $09
CTRLPF  =  $0A
REFP0   =  $0B
REFP1   =  $0C
PF0     =  $0D
PF1     =  $0E
PF2     =  $0F
RESP0   =  $10
RESP1   =  $11
RESM0   =  $12
RESM1   =  $13
RESBL   =  $14
AUDC0   =  $15
AUDF0   =  $17
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
HMM1    =  $23
HMBL    =  $24
VDELP0  =  $25
VDELP1  =  $26
VDELBL  =  $27
HMOVE   =  $2A
HMCLR   =  $2B
CXCLR   =  $2C
CXP0FB  =  $02 ;read player-ball collision for bat object (program also reads CXP1FB)

INPT1   =  $09 ;read trigger

INPT4   =  $0C ;read trigger
INPT5   =  $0D ;read trigger
SWCHA   =  $0280
SWCHB   =  $0282
INTIM   =  $0284
TIM64T  =  $0296

;constants...
  IF PAL
COLOR0  =  $00
COLOR1  =  $20
COLOR2  =  $40
COLOR3  =  $60
COLOR4  =  $60
COLOR5  =  $80
COLOR6  =  $C0
COLOR7  =  $C0
COLOR8  =  $B0
COLOR9  =  $D0
COLORC  =  $50
    IF PAL50
TIME1   =  $41
TIME2   =  $52
    ELSE
TIME1   =  $21
TIME2   =  $36
    ENDIF
  ELSE
COLOR0  =  $00
COLOR1  =  $10
COLOR2  =  $20
COLOR3  =  $30
COLOR4  =  $40
COLOR5  =  $50
COLOR6  =  $60
COLOR7  =  $70
COLOR8  =  $80
COLOR9  =  $90
COLORC  =  $C0
TIME1   =  $21
TIME2   =  $36
  ENDIF

;bankswitch hotspots called via BIT radr...
BANK1  =  $FFF6
BANK2  =  $FFF7
BANK3  =  $FFF8
BANK4  =  $FFF9


       SEG.U variables
       ORG  $80

frameCounter    DS 1 ; $80
r81             DS 1 ; $81
r82             DS 1 ; $82
r83             DS 1 ; $83
r84             DS 1 ; $84
r85             DS 1 ; $85
r86             DS 1 ; $86
r87             DS 1 ; $87
r88             DS 1 ; $88
r89             DS 1 ; $89
r8A             DS 1 ; $8A
r8B             DS 1 ; $8B
r8C             DS 1 ; $8C
r8D             DS 1 ; $8D
r8E             DS 1 ; $8E
r8F             DS 1 ; $8F
r90             DS 1 ; $90
r91             DS 1 ; $91
r92             DS 1 ; $92
r93             DS 1 ; $93
r94             DS 1 ; $94
r95             DS 1 ; $95
r96             DS 1 ; $96
r97             DS 1 ; $97
r98             DS 1 ; $98
r99             DS 1 ; $99
r9A             DS 1 ; $9A
r9B             DS 1 ; $9B
r9C             DS 1 ; $9C
r9D             DS 1 ; $9D
r9E             DS 1 ; $9E
r9F             DS 1 ; $9F
rA0             DS 1 ; $A0
rA1             DS 1 ; $A1
rA2             DS 1 ; $A2
rA3             DS 1 ; $A3
rA4             DS 1 ; $A4
rA5             DS 1 ; $A5
rA6             DS 1 ; $A6
rA7             DS 1 ; $A7
rA8             DS 1 ; $A8
rA9             DS 1 ; $A9
rAA             DS 1 ; $AA
rAB             DS 1 ; $AB
rAC             DS 1 ; $AC
rAD             DS 1 ; $AD
rAE             DS 1 ; $AE
rAF             DS 1 ; $AF
rB0             DS 1 ; $B0
rB1             DS 1 ; $B1
rB2             DS 1 ; $B2
rB3             DS 1 ; $B3
rB4             DS 1 ; $B4
rB5             DS 1 ; $B5
ballSpritePtr   DS 3 ; $B6-$B8
rB8        =  ballSpritePtr+2 ; $B8
rB9             DS 1 ; $B9
rBA             DS 1 ; $BA
rBB             DS 1 ; $BB
rBC             DS 1 ; $BC
rBD             DS 1 ; $BD
rBE             DS 1 ; $BE
rBF             DS 1 ; $BF
rC0             DS 1 ; $C0
gameVariation   DS 1 ; $C1
rC2             DS 1 ; $C2
rC3             DS 2 ; $C3-$C4
rC5             DS 2 ; $C5-$C6
rC7             DS 2 ; $C7-$C8
rC9             DS 2 ; $C9-$CA
rCB             DS 2 ; $CB-$CC
rCD             DS 2 ; $CD-$CE
rCF             DS 2 ; $CF-$D0
rD1             DS 2 ; $D1-$D2
rD3             DS 12 ; $D3-$DE
rDF             DS 1 ; $DF
rE0             DS 2 ; $E0-$E1
rE2             DS 2 ; $E2-$E3
rE4             DS 2 ; $E4-$E5
rE6             DS 2 ; $E6-$E7
rE7        =  rE6+1 ; $E7
rE8             DS 2 ; $E8-$E9
rE9        =  rE8+1 ; $E9
rEA             DS 2 ; $EA-$EB
rEB        =  rEA+1 ; $EB
rEC             DS 2 ; $EC-$ED
rEE             DS 2 ; $EE-$EF
checkAC    =  rEE+1 ; $EF
rF0             DS 2 ; $F0-$F1
rF1        =  rF0+1 ; $F1
rF2             DS 2 ; $F2-$F3
rF4             DS 2 ; $F4-$F5
rF5        =  rF4+1 ; $F5
rF6             DS 2 ; $F6-$F7
temp       =  rF6+1 ; $F7
bckgrndColorPtr DS 2 ; $F8-$F9
ballSpiteSize   DS 2 ; $FA-$FB
checkB6    =  ballSpiteSize+1 ; $FB
musicAdr        DS 2 ; $FC-$FD
tempGFX    =  musicAdr ; $FC
loopCount2 =  musicAdr ; $FC
loopCount  =  musicAdr+1 ; $FD


       SEG rom code

       ORG  $1000
       RORG $9000

L9008:
  IF CCE
       .byte $07 ; |     XXX| $9008
       .byte $0F ; |    XXXX| $9009
       .byte $4C ; | X  XX  | $900A
       .byte $AC ; |X X XX  | $900B
       .byte $4C ; | X  XX  | $900C
       .byte $0F ; |    XXXX| $900D
       .byte $07 ; |     XXX| $900E
       .byte $00 ; |        | $900F

;digit C
       .byte $00 ; |        | $9060
       .byte $00 ; |        | $9061
       .byte $00 ; |        | $9062
       .byte $00 ; |        | $9063
       .byte $00 ; |        | $9064
       .byte $00 ; |        | $9065
       .byte $00 ; |        | $9066
       .byte $00 ; |        | $9067

       .byte $C7 ; |XX   XXX| $9010
       .byte $EF ; |XXX XXXX| $9011
       .byte $6C ; | XX XX  | $9012
       .byte $0C ; |    XX  | $9013
       .byte $6C ; | XX XX  | $9014
       .byte $EF ; |XXX XXXX| $9015
       .byte $C7 ; |XX   XXX| $9016
       .byte $00 ; |        | $9017

       .byte $C7 ; |XX   XXX| $9018
       .byte $EF ; |XXX XXXX| $9019
       .byte $6C ; | XX XX  | $901A
       .byte $0F ; |    XXXX| $901B
       .byte $6C ; | XX XX  | $901C
       .byte $EF ; |XXX XXXX| $901D
       .byte $C7 ; |XX   XXX| $901E
       .byte $00 ; |        | $901F

       .byte $C0 ; |XX      | $9020
       .byte $E0 ; |XXX     | $9021
       .byte $04 ; |     X  | $9022
       .byte $EA ; |XXX X X | $9023
       .byte $64 ; | XX  X  | $9024
       .byte $E0 ; |XXX     | $9025
       .byte $C0 ; |XX      | $9026
       .byte $00 ; |        | $9027

       .byte $00 ; |        | $9028
       .byte $00 ; |        | $9029
       .byte $00 ; |        | $902A
       .byte $00 ; |        | $902B
       .byte $00 ; |        | $902C
       .byte $00 ; |        | $902D
       .byte $00 ; |        | $902E
       .byte $00 ; |        | $902F

       .byte $C4 ; |XX   X  | $9030
       .byte $AA ; |X X X X | $9031
       .byte $AA ; |X X X X | $9032
       .byte $AA ; |X X X X | $9033
       .byte $C4 ; |XX   X  | $9034
       .byte $00 ; |        | $9035
       .byte $00 ; |        | $9036
       .byte $00 ; |        | $9037

       .byte $EC ; |XXX XX  | $9038
       .byte $AA ; |X X X X | $9039
       .byte $AC ; |X X XX  | $903A
       .byte $AA ; |X X X X | $903B
       .byte $AC ; |X X XX  | $903C
       .byte $00 ; |        | $903D
       .byte $00 ; |        | $903E
       .byte $00 ; |        | $903F

       .byte $EE ; |XXX XXX | $9040
       .byte $88 ; |X   X   | $9041
       .byte $8C ; |X   XX  | $9042
       .byte $88 ; |X   X   | $9043
       .byte $8E ; |X   XXX | $9044
       .byte $00 ; |        | $9045
       .byte $00 ; |        | $9046
       .byte $00 ; |        | $9047

       .byte $65 ; | XX  X X| $9048
       .byte $55 ; | X X X X| $9049
       .byte $56 ; | X X XX | $904A
       .byte $55 ; | X X X X| $904B
       .byte $67 ; | XX  XXX| $904C
       .byte $00 ; |        | $904D
       .byte $00 ; |        | $904E
       .byte $00 ; |        | $904F

       .byte $57 ; | X X XXX| $9050
       .byte $55 ; | X X X X| $9051
       .byte $75 ; | XXX X X| $9052
       .byte $54 ; | X X X  | $9053
       .byte $77 ; | XXX XXX| $9054
       .byte $00 ; |        | $9055
       .byte $00 ; |        | $9056
       .byte $00 ; |        | $9057

       .byte $25 ; |  X  X X| $9058
       .byte $57 ; | X X XXX| $9059
       .byte $57 ; | X X XXX| $905A
       .byte $57 ; | X X XXX| $905B
       .byte $25 ; |  X  X X| $905C
  ELSE
       .byte $61 ; | XX    X| $9008
       .byte $31 ; |  XX   X| $9009
       .byte $1F ; |   XXXXX| $900A
       .byte $0D ; |    XX X| $900B
       .byte $07 ; |     XXX| $900C
       .byte $03 ; |      XX| $900D
       .byte $01 ; |       X| $900E
       .byte $00 ; |        | $900F

;digit C
       .byte $00 ; |        | $9060
       .byte $00 ; |        | $9061
       .byte $00 ; |        | $9062
       .byte $00 ; |        | $9063
       .byte $00 ; |        | $9064
       .byte $00 ; |        | $9065
       .byte $00 ; |        | $9066
       .byte $00 ; |        | $9067

       .byte $6A ; | XX X X | $9010
       .byte $4A ; | X  X X | $9011
       .byte $4A ; | X  X X | $9012
       .byte $4A ; | X  X X | $9013
       .byte $6A ; | XX X X | $9014
       .byte $08 ; |    X   | $9015
       .byte $7F ; | XXXXXXX| $9016
       .byte $00 ; |        | $9017

       .byte $85 ; |X    X X| $9018
       .byte $C4 ; |XX   X  | $9019
       .byte $E5 ; |XXX  X X| $901A
       .byte $B5 ; |X XX X X| $901B
       .byte $99 ; |X  XX  X| $901C
       .byte $8C ; |X   XX  | $901D
       .byte $87 ; |X    XXX| $901E
       .byte $00 ; |        | $901F

       .byte $D7 ; |XX X XXX| $9020
       .byte $55 ; | X X X X| $9021
       .byte $D5 ; |XX X X X| $9022
       .byte $15 ; |   X X X| $9023
       .byte $D7 ; |XX X XXX| $9024
       .byte $00 ; |        | $9025
       .byte $F0 ; |XXXX    | $9026
       .byte $00 ; |        | $9027

       .byte $48 ; | X  X   | $9028
       .byte $58 ; | X XX   | $9029
       .byte $78 ; | XXXX   | $902A
       .byte $68 ; | XX X   | $902B
       .byte $48 ; | X  X   | $902C
       .byte $00 ; |        | $902D
       .byte $00 ; |        | $902E
       .byte $00 ; |        | $902F

;digits 6 thru B
       .byte $4E ; | X  XXX | $9030
       .byte $48 ; | X  X   | $9031
       .byte $4C ; | X  XX  | $9032
       .byte $48 ; | X  X   | $9033
       .byte $EE ; |XXX XXX | $9034
       .byte $00 ; |        | $9035
       .byte $00 ; |        | $9036
       .byte $00 ; |        | $9037

       .byte $EA ; |XXX X X | $9038
       .byte $8A ; |X   X X | $9039
       .byte $8E ; |X   XXX | $903A
       .byte $8A ; |X   X X | $903B
       .byte $EA ; |XXX X X | $903C
       .byte $00 ; |        | $903D
       .byte $00 ; |        | $903E
       .byte $00 ; |        | $903F

       .byte $AE ; |X X XXX | $9040
       .byte $EA ; |XXX X X | $9041
       .byte $EA ; |XXX X X | $9042
       .byte $EA ; |XXX X X | $9043
       .byte $AE ; |X X XXX | $9044
       .byte $00 ; |        | $9045
       .byte $00 ; |        | $9046
       .byte $00 ; |        | $9047

       .byte $E2 ; |XXX   X | $9048
       .byte $21 ; |  X    X| $9049
       .byte $E1 ; |XXX    X| $904A
       .byte $81 ; |X      X| $904B
       .byte $E1 ; |XXX    X| $904C
       .byte $00 ; |        | $904D
       .byte $00 ; |        | $904E
       .byte $00 ; |        | $904F

       .byte $54 ; | X X X  | $9050
       .byte $54 ; | X X X  | $9051
       .byte $77 ; | XXX XXX| $9052
       .byte $55 ; | X X X X| $9053
       .byte $77 ; | XXX XXX| $9054
       .byte $00 ; |        | $9055
       .byte $00 ; |        | $9056
       .byte $00 ; |        | $9057

       .byte $55 ; | X X X X| $9058
       .byte $57 ; | X X XXX| $9059
       .byte $77 ; | XXX XXX| $905A
       .byte $57 ; | X X XXX| $905B
       .byte $75 ; | XXX X X| $905C
  ENDIF
L90FA:
       .byte $00 ; |        | $90FA shared
       .byte $00 ; |        | $90FB shared
       .byte $00 ; |        | $90FC shared
       .byte $00 ; |        | $90FD
       .byte $00 ; |        | $90FE
       .byte $03 ; |      XX| $90FF

L9277:
       .byte $08 ; |    X   | $9277 digit 1 offset from L9100
       .byte $08 ; |    X   | $9278
       .byte $08 ; |    X   | $9279
       .byte $10 ; |   X    | $927A digit 2 offset from L9100
       .byte $10 ; |   X    | $927B
       .byte $10 ; |   X    | $927C
       .byte $18 ; |   XX   | $927D digit 3 offset from L9100
       .byte $18 ; |   XX   | $927E
       .byte $18 ; |   XX   | $927F
       .byte $18 ; |   XX   | $9280
       .byte $18 ; |   XX   | $9281
       .byte $18 ; |   XX   | $9282
       .byte $18 ; |   XX   | $9283
       .byte $18 ; |   XX   | $9284
       .byte $18 ; |   XX   | $9285
       .byte $20 ; |  X     | $9286 digit 4 offset from L9100
       .byte $20 ; |  X     | $9287
       .byte $20 ; |  X     | $9288

L9289:
       .byte $00 ; |        | $9289
       .byte $03 ; |      XX| $928A
       .byte $0F ; |    XXXX| $928B
       .byte $3F ; |  XXXXXX| $928C
       .byte $FF ; |XXXXXXXX| $928D
       .byte $FF ; |XXXXXXXX| $928E

L929C:
       .byte COLOR3+8 ; |  XXX   | $929C
       .byte COLOR3+8 ; |  XXX   | $929D
       .byte COLOR3+8 ; |  XXX   | $929E
       .byte COLOR7+4 ; | XXX X  | $929F
       .byte COLOR7+4 ; | XXX X  | $92A0
       .byte COLOR7+4 ; | XXX X  | $92A1
       .byte COLOR7+4 ; | XXX X  | $92A2
L92A3:
       .byte COLOR3+8 ; |  XXX   | $92A3
       .byte COLOR3+8 ; |  XXX   | $92A4
       .byte COLOR3+8 ; |  XXX   | $92A5
       .byte COLOR3+4 ; |  XX X  | $92A6
       .byte COLOR3+4 ; |  XX X  | $92A7
       .byte COLOR3+4 ; |  XX X  | $92A8
       .byte COLOR3+4 ; |  XX X  | $92A9

;       ORG  $1089
;       RORG $9089

L9200: ;background color table...119
       .byte COLOR9+4 ; |X  X X  | $9200
       .byte COLOR0+2 ; |      X | $9201
       .byte COLOR0+4 ; |     X  | $9202
       .byte COLOR0+4 ; |     X  | $9203
       .byte COLOR0+6 ; |     XX | $9204
       .byte COLOR0+6 ; |     XX | $9205
       .byte COLOR0+8 ; |    X   | $9206
       .byte COLOR0+8 ; |    X   | $9207
       .byte COLOR0+6 ; |     XX | $9208
       .byte COLOR0+8 ; |    X   | $9209
       .byte COLOR0+8 ; |    X   | $920A
       .byte COLOR0+6 ; |     XX | $920B
       .byte COLOR0+8 ; |    X   | $920C
       .byte COLOR0+6 ; |     XX | $920D
       .byte COLOR0+4 ; |     X  | $920E
       .byte COLOR0+2 ; |      X | $920F
       .byte COLOR8+4 ; |X    X  | $9210
       .byte COLOR0+4 ; |     X  | $9211
       .byte COLOR0+6 ; |     XX | $9212
       .byte COLOR0+6 ; |     XX | $9213
       .byte COLOR0+6 ; |     XX | $9214
       .byte COLOR0+8 ; |    X   | $9215
       .byte COLOR0+10; |    X X | $9216
       .byte COLOR0+4 ; |     X  | $9217
       .byte COLOR0+8 ; |    X   | $9218
       .byte COLOR0+8 ; |    X   | $9219
       .byte COLOR0+8 ; |    X   | $921A
       .byte COLOR0+8 ; |    X   | $921B
       .byte COLOR0+8 ; |    X   | $921C
       .byte COLOR0+8 ; |    X   | $921D
       .byte COLOR0+8 ; |    X   | $921E
       .byte COLOR0+2 ; |      X | $921F
       .byte COLORC+4 ; |XX   X  | $9220
       .byte COLORC+2 ; |XX    X | $9221
       .byte COLOR1+4 ; |   X X  | $9222
       .byte COLOR1+4 ; |   X X  | $9223
       .byte COLOR1+4 ; |   X X  | $9224
       .byte COLOR1+4 ; |   X X  | $9225
       .byte COLOR1+4 ; |   X X  | $9226
       .byte COLOR1+4 ; |   X X  | $9227
       .byte COLOR1+4 ; |   X X  | $9228
       .byte COLOR1+4 ; |   X X  | $9229
       .byte COLOR1+4 ; |   X X  | $922A
       .byte COLOR1+4 ; |   X X  | $922B
       .byte COLOR1+4 ; |   X X  | $922C
       .byte COLOR1+0 ; |   X    | $922D
       .byte COLOR1+2 ; |   X  X | $922E
       .byte COLOR1+2 ; |   X  X | $922F
       .byte COLOR1+2 ; |   X  X | $9230
       .byte COLOR1+0 ; |   X    | $9231
       .byte COLOR1+6 ; |   X XX | $9232
       .byte COLOR0+6 ; |     XX | $9233
       .byte COLOR0+6 ; |     XX | $9234
       .byte COLOR0+6 ; |     XX | $9235
       .byte COLOR0+6 ; |     XX | $9236
       .byte COLOR0+6 ; |     XX | $9237
       .byte COLOR0+6 ; |     XX | $9238
       .byte COLOR0+6 ; |     XX | $9239
       .byte COLOR0+6 ; |     XX | $923A
       .byte COLOR0+6 ; |     XX | $923B
       .byte COLOR0+6 ; |     XX | $923C
       .byte COLOR0+6 ; |     XX | $923D
       .byte COLOR0+6 ; |     XX | $923E
       .byte COLOR0+6 ; |     XX | $923F
       .byte COLOR0+6 ; |     XX | $9240
       .byte COLOR0+6 ; |     XX | $9241
       .byte COLOR0+6 ; |     XX | $9242
       .byte COLOR0+6 ; |     XX | $9243
       .byte COLOR1+4 ; |   X X  | $9244
       .byte COLOR1+6 ; |   X XX | $9245
       .byte COLOR1+6 ; |   X XX | $9246
       .byte COLOR1+6 ; |   X XX | $9247
       .byte COLOR1+8 ; |   XX   | $9248
       .byte COLOR1+10; |   XX X | $9249
       .byte COLOR1+4 ; |   X X  | $924A
       .byte COLOR1+8 ; |   XX   | $924B
       .byte COLOR1+8 ; |   XX   | $924C
       .byte COLOR1+8 ; |   XX   | $924D
       .byte COLOR1+8 ; |   XX   | $924E
       .byte COLOR1+8 ; |   XX   | $924F
       .byte COLOR1+8 ; |   XX   | $9250
       .byte COLOR1+8 ; |   XX   | $9251
       .byte COLOR1+2 ; |   X  X | $9252
       .byte COLORC+4 ; |XX   X  | $9253
       .byte COLORC+2 ; |XX    X | $9254
       .byte COLORC+4 ; |XX   X  | $9255
       .byte COLORC+4 ; |XX   X  | $9256
       .byte COLORC+4 ; |XX   X  | $9257
       .byte COLORC+4 ; |XX   X  | $9258
       .byte COLORC+4 ; |XX   X  | $9259
       .byte COLORC+4 ; |XX   X  | $925A
       .byte COLORC+4 ; |XX   X  | $925B
       .byte COLORC+4 ; |XX   X  | $925C
       .byte COLORC+4 ; |XX   X  | $925D
       .byte COLORC+4 ; |XX   X  | $925E
       .byte COLORC+4 ; |XX   X  | $925F
       .byte COLORC+2 ; |XX    X | $9260
       .byte COLORC+2 ; |XX    X | $9261
       .byte COLORC+2 ; |XX    X | $9262
       .byte COLORC+2 ; |XX    X | $9263
       .byte COLORC+0 ; |XX      | $9264
       .byte COLORC+0 ; |XX      | $9265
       .byte COLOR0+4 ; |     X  | $9266
       .byte COLOR0+4 ; |     X  | $9267
       .byte COLOR0+4 ; |     X  | $9268
       .byte COLOR0+4 ; |     X  | $9269
       .byte COLOR0+4 ; |     X  | $926A
       .byte COLOR0+4 ; |     X  | $926B
       .byte COLOR0+4 ; |     X  | $926C
       .byte COLOR0+4 ; |     X  | $926D
       .byte COLOR0+4 ; |     X  | $926E
       .byte COLOR0+4 ; |     X  | $926F
       .byte COLOR0+4 ; |     X  | $9270
       .byte COLOR0+6 ; |     XX | $9271
       .byte COLOR0+6 ; |     XX | $9272
       .byte COLOR0+6 ; |     XX | $9273
       .byte COLOR0+6 ; |     XX | $9274
       .byte COLOR0+2 ; |      X | $9275
       .byte COLOR0+2 ; |      X | $9276

       ORG  $1100
       RORG $9100

L9100: ;NOTE: digit gfx must begin on page break, 0123456789+space+(C) @ 8 bytes each
       .byte $3C ; |  XXXX  | $9100
       .byte $66 ; | XX  XX | $9101
       .byte $66 ; | XX  XX | $9102
       .byte $66 ; | XX  XX | $9103
       .byte $66 ; | XX  XX | $9104
       .byte $66 ; | XX  XX | $9105
       .byte $3C ; |  XXXX  | $9106
       .byte $00 ; |        | $9107

       .byte $3C ; |  XXXX  | $9108
       .byte $18 ; |   XX   | $9109
       .byte $18 ; |   XX   | $910A
       .byte $18 ; |   XX   | $910B
       .byte $18 ; |   XX   | $910C
       .byte $38 ; |  XXX   | $910D
       .byte $18 ; |   XX   | $910E
       .byte $00 ; |        | $910F

       .byte $7E ; | XXXXXX | $9110
       .byte $60 ; | XX     | $9111
       .byte $60 ; | XX     | $9112
       .byte $3C ; |  XXXX  | $9113
       .byte $06 ; |     XX | $9114
       .byte $46 ; | X   XX | $9115
       .byte $3C ; |  XXXX  | $9116
       .byte $00 ; |        | $9117

       .byte $3C ; |  XXXX  | $9118
       .byte $46 ; | X   XX | $9119
       .byte $06 ; |     XX | $911A
       .byte $0C ; |    XX  | $911B
       .byte $06 ; |     XX | $911C
       .byte $46 ; | X   XX | $911D
       .byte $3C ; |  XXXX  | $911E
       .byte $00 ; |        | $911F

       .byte $0C ; |    XX  | $9120
       .byte $0C ; |    XX  | $9121
       .byte $7E ; | XXXXXX | $9122
       .byte $4C ; | X  XX  | $9123
       .byte $2C ; |  X XX  | $9124
       .byte $1C ; |   XXX  | $9125
       .byte $0C ; |    XX  | $9126
       .byte $00 ; |        | $9127

       .byte $7C ; | XXXXX  | $9128
       .byte $46 ; | X   XX | $9129
       .byte $06 ; |     XX | $912A
       .byte $7C ; | XXXXX  | $912B
       .byte $60 ; | XX     | $912C
       .byte $60 ; | XX     | $912D
       .byte $7E ; | XXXXXX | $912E
       .byte $00 ; |        | $912F

       .byte $3C ; |  XXXX  | $9130
       .byte $66 ; | XX  XX | $9131
       .byte $66 ; | XX  XX | $9132
       .byte $7C ; | XXXXX  | $9133
       .byte $60 ; | XX     | $9134
       .byte $62 ; | XX   X | $9135
       .byte $3C ; |  XXXX  | $9136
       .byte $00 ; |        | $9137

       .byte $18 ; |   XX   | $9138
       .byte $18 ; |   XX   | $9139
       .byte $18 ; |   XX   | $913A
       .byte $0C ; |    XX  | $913B
       .byte $06 ; |     XX | $913C
       .byte $42 ; | X    X | $913D
       .byte $7E ; | XXXXXX | $913E
       .byte $00 ; |        | $913F

       .byte $3C ; |  XXXX  | $9140
       .byte $66 ; | XX  XX | $9141
       .byte $66 ; | XX  XX | $9142
       .byte $3C ; |  XXXX  | $9143
       .byte $66 ; | XX  XX | $9144
       .byte $66 ; | XX  XX | $9145
       .byte $3C ; |  XXXX  | $9146
       .byte $00 ; |        | $9147

       .byte $3C ; |  XXXX  | $9148
       .byte $46 ; | X   XX | $9149
       .byte $06 ; |     XX | $914A
       .byte $3E ; |  XXXXX | $914B
       .byte $66 ; | XX  XX | $914C
       .byte $66 ; | XX  XX | $914D
       .byte $3C ; |  XXXX  | $914E
       .byte $00 ; |        | $914F
L9150: ;space (digit A)
       .byte $00 ; |        | $9150
       .byte $00 ; |        | $9151
L928F: ;PF0-low nybble irrelivant
       .byte $00 ; |        | $928F shared
       .byte $00 ; |        | $9290 shared
       .byte $00 ; |        | $9291 shared
       .byte $00 ; |        | $9292 shared
       .byte $00 ; |        | $9293 shared
       .byte $C0 ; |XX      | $9294
;copyright (digit B)
       .byte $3C ; |  XXXX  | $9158
       .byte $42 ; | X    X | $9159
       .byte $5A ; | X XX X | $915A
       .byte $52 ; | X X  X | $915B
       .byte $5A ; | X XX X | $915C
       .byte $42 ; | X    X | $915D
L9295: ;head icon
       .byte $3C ; |  XXXX  | $9295 shared
       .byte $7E ; | XXXXXX | $9296
       .byte $7E ; | XXXXXX | $9297
       .byte $FF ; |XXXXXXXX| $9298
       .byte $DF ; |XX XXXXX| $9299
       .byte $7F ; | XXXXXXX| $929A
       .byte $7E ; | XXXXXX | $929B

L9C71: ;3
       .byte $87 ; |X    XXX| $9C71
       .byte $85 ; |X    X X| $9C72
       .byte $FF ; |XXXXXXXX| $9C73

L91F9:
       .byte $7A ; | XXXX X | $91F9
       .byte $FA ; |XXXXX X | $91FA
       .byte $8A ; |X   X X | $91FB
       .byte $9B ; |X  XX XX| $91FC
       .byte $82 ; |X     X | $91FD
       .byte $FB ; |XXXXX XX| $91FE
       .byte $79 ; | XXXX  X| $91FF
       .byte $00 ; |        | $9067

L9170: ;"GAME OVER" text (6 sprites)...
       .byte $28 ; |  X X   | $9170
       .byte $28 ; |  X X   | $9171
       .byte $28 ; |  X X   | $9172
       .byte $EA ; |XXX X X | $9173
       .byte $2F ; |  X XXXX| $9174
       .byte $ED ; |XXX XX X| $9175
       .byte $C8 ; |XX  X   | $9176
       .byte $00 ; |        | $9067

L9178: ;shared between game over and time text
       .byte $BC ; |X XXXX  | $9178
       .byte $BC ; |X XXXX  | $9179
       .byte $A0 ; |X X     | $917A
       .byte $B8 ; |X XXX   | $917B
       .byte $A0 ; |X X     | $917C
       .byte $BC ; |X XXXX  | $917D
       .byte $BC ; |X XXXX  | $917E

;the rest of the gfx is called with their own addresses, but must exist on the same page
L9160: ;"PTS" text (2 sprites)...
       .byte $00 ; |        | $9160
       .byte $08 ; |    X   | $9161
       .byte $0C ; |    XX  | $9162
       .byte $0A ; |    X X | $9163
       .byte $0A ; |    X X | $9164
       .byte $0C ; |    XX  | $91AA
L9168:
       .byte $00 ; |        | $9168 shared
       .byte $4C ; | X  XX  | $9169
       .byte $42 ; | X    X | $916A
       .byte $44 ; | X   X  | $916B
       .byte $48 ; | X  X   | $916C
       .byte $E6 ; |XXX  XX | $916D
L91E9: ;16
       .byte $00 ; |        | $91E9 shared
       .byte $08 ; |    X   | $91EA
       .byte $10 ; |   X    | $91EB
       .byte $18 ; |   XX   | $91EC
       .byte $20 ; |  X     | $91ED
       .byte $28 ; |  X X   | $91EE
       .byte $30 ; |  XX    | $91EF
       .byte $38 ; |  XXX   | $91F0
       .byte $40 ; | X      | $91F1
       .byte $48 ; | X  X   | $91F2
       .byte $50 ; | X X    | $91F3
       .byte $58 ; | X XX   | $91F4
       .byte $60 ; | XX     | $91F5
       .byte $68 ; | XX X   | $91F6
       .byte $70 ; | XXX    | $91F7
L91C6:
       .byte $78 ; | XXXX   | $91F8 shared
       .byte $CC ; |XX  XX  | $91C7
       .byte $CC ; |XX  XX  | $91C8
       .byte $CC ; |XX  XX  | $91C9
       .byte $CC ; |XX  XX  | $91CA
       .byte $CC ; |XX  XX  | $91CB
L91CD:
       .byte $78 ; | XXXX   | $91CD shared
       .byte $CC ; |XX  XX  | $91CE
       .byte $CC ; |XX  XX  | $91CF
       .byte $CC ; |XX  XX  | $91D0
       .byte $CC ; |XX  XX  | $91D1
       .byte $CC ; |XX  XX  | $91D2
       .byte $CC ; |XX  XX  | $91D3

L9180: ;"MISSION" text (4 sprites)...
       .byte $8A ; |X   X X | $9180
       .byte $8A ; |X   X X | $9181
       .byte $8A ; |X   X X | $9182
       .byte $8A ; |X   X X | $9183
       .byte $AA ; |X X X X | $9184
       .byte $DA ; |XX XX X | $9185
       .byte $8A ; |X   X X | $9186
L9187:
       .byte $F7 ; |XXXX XXX| $9187
       .byte $10 ; |   X    | $9188
       .byte $10 ; |   X    | $9189
       .byte $F7 ; |XXXX XXX| $918A
       .byte $84 ; |X    X  | $918B
       .byte $84 ; |X    X  | $918C
       .byte $F7 ; |XXXX XXX| $918D
L918E:
       .byte $AF ; |X X XXXX| $918E
       .byte $A8 ; |X X X   | $918F
       .byte $A8 ; |X X X   | $9190
       .byte $A8 ; |X X X   | $9191
       .byte $28 ; |  X X   | $9192
       .byte $28 ; |  X X   | $9193
       .byte $AF ; |X X XXXX| $9194
L9195:
       .byte $A2 ; |X X   X | $9195
       .byte $A2 ; |X X   X | $9196
       .byte $A6 ; |X X  XX | $9197
       .byte $AA ; |X X X X | $9198
       .byte $B2 ; |X XX  X | $9199
       .byte $A2 ; |X X   X | $919A
       .byte $A2 ; |X X   X | $919B

L919C: ;"TIME" text (3 sprites)...
       .byte $02 ; |      X | $919C
       .byte $02 ; |      X | $919D
       .byte $02 ; |      X | $919E
       .byte $02 ; |      X | $919F
       .byte $02 ; |      X | $91A0
       .byte $0F ; |    XXXX| $91A1
       .byte $0F ; |    XXXX| $91A2

L91A3:
       .byte $28 ; |  X X   | $91A3
       .byte $28 ; |  X X   | $91A4
       .byte $28 ; |  X X   | $91A5
       .byte $2A ; |  X X X | $91A6
       .byte $2F ; |  X XXXX| $91A7
       .byte $AD ; |X X XX X| $91A8
       .byte $A8 ; |X X X   | $91A9

L91AA:
       .byte $0C ; |    XX  | $91AA
       .byte $1E ; |   XXXX | $91AB
       .byte $12 ; |   X  X | $91AC
       .byte $12 ; |   X  X | $91AD
       .byte $12 ; |   X  X | $91AE
       .byte $1E ; |   XXXX | $91AF
       .byte $0C ; |    XX  | $91B0

L91B1:
       .byte $23 ; |  X   XX| $91B1
       .byte $73 ; | XXX  XX| $91B2
       .byte $DA ; |XX XX X | $91B3
       .byte $8B ; |X   X XX| $91B4
       .byte $8A ; |X   X X | $91B5
       .byte $8B ; |X   X XX| $91B6
       .byte $8B ; |X   X XX| $91B7

L91B8:
       .byte $D1 ; |XX X   X| $91B8
       .byte $D1 ; |XX X   X| $91B9
       .byte $12 ; |   X  X | $91BA
       .byte $9E ; |X  XXXX | $91BB
       .byte $11 ; |   X   X| $91BC
       .byte $DF ; |XX XXXXX| $91BD
       .byte $DE ; |XX XXXX | $91BE

L91D4:
       .byte $0D ; |    XX X| $91D4
       .byte $1F ; |   XXXXX| $91D5
       .byte $3F ; |  XXXXXX| $91D6
       .byte $37 ; |  XX XXX| $91D7
       .byte $32 ; |  XX  X | $91D8
L91BF: ;"YOU WIN" text (6 sprites)...
       .byte $30 ; |  XX    | $91BF shared
       .byte $30 ; |  XX    | $91C0 shared
       .byte $30 ; |  XX    | $91C1
       .byte $78 ; | XXXX   | $91C2
       .byte $CC ; |XX  XX  | $91C3
       .byte $CC ; |XX  XX  | $91C4
       .byte $CC ; |XX  XX  | $91C5

L91DB:
       .byte $86 ; |X    XX | $91DB
       .byte $C6 ; |XX   XX | $91DC
       .byte $E6 ; |XXX  XX | $91DD
       .byte $66 ; | XX  XX | $91DE
       .byte $66 ; | XX  XX | $91DF
       .byte $66 ; | XX  XX | $91E0
       .byte $66 ; | XX  XX | $91E1

L91E2:
       .byte $63 ; | XX   XX| $91E2
       .byte $67 ; | XX  XXX| $91E3
       .byte $6F ; | XX XXXX| $91E4
       .byte $7F ; | XXXXXXX| $91E5
       .byte $7B ; | XXXX XX| $91E6
       .byte $73 ; | XXX  XX| $91E7
       .byte $63 ; | XX   XX| $91E8

       ORG  $1200
       RORG $9200

L9909: ;PF2 list
       .byte <LB397 ; $9909
       .byte <LB3A5 ; $990A
       .byte <LB400 ; $990B
       .byte <LB3A5 ; $990C
       .byte <LB5AD ; $990D
       .byte <LB3A5 ; $990E
       .byte <LB3A5 ; $990F
       .byte <LB3A5 ; $9910
       .byte <LB3A5 ; $9911
       .byte <LB871 ; $9912
       .byte <LB871 ; $9913
       .byte <LB871 ; $9914
       .byte <LB3A5 ; $9915
       .byte <LB3A5 ; $9916
       .byte <LB43C ; $9917
       .byte <LBB4C ; $9918
       .byte <LB3A5 ; $9919
       .byte <LB3A5 ; $991A
       .byte <LB43C ; $991B

L906F: ;97
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       sta    RESM1                   ;3
       ldy    #$F3                    ;2
       sty    VDELP0                  ;3
       sty    VDELP1                  ;3
       sta    COLUP0                  ;3
       sta    COLUP1                  ;3
       sty    NUSIZ0                  ;3
       sty    NUSIZ1                  ;3
       lda    #$30                    ;2
       sta    HMM1                    ;3
       sta    REFP0                   ;3
       sty    HMP0                    ;3
       sta    RESP0                   ;3
       sta    RESP1                   ;3
       dec    $2E                     ;5 waste
       sta    REFP1                   ;3
L9094:
       sta    $2E                     ;3 waste
L9096:
       ldy    #$06                    ;2
       dec    $2E                     ;5 waste
       .byte $2C                      ;4 skip 2 bytes
L909D:
       sta    HMCLR                   ;3
       sty    loopCount               ;3
       lda    (rD3),y                 ;5
       sta    GRP0                    ;3
       sta    HMOVE                   ;3
       lda    (rD3+8),y               ;5
       sta    tempGFX                 ;3
       lda    (rD3+10),y              ;5
       tax                            ;2
       lda    (rD3+2),y               ;5
       sta    GRP1                    ;3
       lda    (rD3+4),y               ;5
       sta    GRP0                    ;3
       lda    (rD3+6),y               ;5
       ldy    tempGFX                 ;3
       sta    GRP1                    ;3
       sty    GRP0                    ;3
       stx    GRP1                    ;3
       sta    GRP0                    ;3
       ldy    loopCount               ;3
       dey                            ;2
       bpl    L909D                   ;2
       bmi    L90C6                   ;2 always branch

L92AA: ;draw lives remaining
       ldy    #$06                    ;2
L92B0:
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       ldx    L929C,y                 ;4
       stx    COLUP0                  ;3
       lda    L9295,y                 ;4 head icon
       sta    GRP0                    ;3
       sta    REFP0                   ;3
       lda    (rD3+8),y               ;5
       sta    GRP1                    ;3
       ldx    L92A3,y                 ;4
       sty    REFP0                   ;3
       lda    (rD3+10),y              ;5
       sta    GRP1                    ;3
       stx    COLUP0                  ;3
       dey                            ;2
       sta    HMCLR                   ;3
       bpl    L92B0                   ;2
L90C6:
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       iny                            ;2
       sty    GRP0                    ;3
       sty    GRP1                    ;3
       sty    GRP0                    ;3
L90D2:
       rts                            ;6

L92D6:
       lda    #>L9200                 ;2
       sta    bckgrndColorPtr+1       ;3
       lda    #$10                    ;2
       sta    ENABL                   ;3
       sta    ENAM1                   ;3
       sta    REFP0                   ;3
       sta    REFP1                   ;3
       sta    RESP0                   ;3
       sta    RESP1                   ;3
       sta    HMP1                    ;3
       sta    NUSIZ0                  ;3
       sta    NUSIZ1                  ;3
       ldy    #$10                    ;2
L92F0:
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       lda    #COLOR0+15              ;2
       sta    COLUP0                  ;3
       sta    COLUP1                  ;3
       lda    (bckgrndColorPtr),y     ;5
       sta    COLUBK                  ;3
       lda    frameCounter            ;3
       and    #$20                    ;2
       bne    L9312                   ;2
       cpx    #$90                    ;2
       bcc    L9312                   ;2
       lda    L90D3,y                 ;4
       sta    GRP0                    ;3
       lda    L90E4,y                 ;4
       sta    GRP1                    ;3
L9312:
       sta    HMCLR                   ;3
       dey                            ;2
       bpl    L92F0                   ;2
       lda    #$00                    ;2
       sta    GRP0                    ;3
       sta    GRP1                    ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       cpx    #$90                    ;2
       bcs    L933D                   ;2
       cpx    #$60                    ;2
       bcc    L933D                   ;2
       lda    #<L9168                 ;2 "PTS" text...
       sta    rD3+10                  ;3
       lda    #<L9160                 ;2
       sta    rD3+8                   ;3
       lda    #<L9100                 ;2
       sta    rD3+6                   ;3
       ldx    rAC                     ;3
       ldy    L9B1D,x                 ;4
       tax                            ;2
       beq    L9371                   ;2
L933D:
       lda    rAB                     ;3
       and    #$0C                    ;2
       beq    L9378                   ;2 branch if no resolution yet
       cmp    #$0C                    ;2
       beq    L935F                   ;2 branch if game won
       cmp    #$04                    ;2
       beq    L9378                   ;2 branch if level starting
       lda    #<L91B8                 ;2 "GAME OVER" text...
       sta    rD3+10                  ;3
       lda    #<L91B1                 ;2
       sta    rD3+8                   ;3
       lda    #<L91AA                 ;2
       sta    rD3+6                   ;3
       lda    #<L9178                 ;2
       ldx    #<L9170                 ;2
       ldy    #<L91F9                 ;2
       bne    L9371                   ;2 always branch

L935F:
       lda    #<L91E2                 ;2 "YOU WIN" text...
       sta    rD3+10                  ;3
       lda    #<L91DB                 ;2
       sta    rD3+8                   ;3
       lda    #<L91D4                 ;2
       sta    rD3+6                   ;3
       lda    #<L91CD                 ;2
       ldx    #<L91C6                 ;2
       ldy    #<L91BF                 ;2
L9371:
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       jmp    L939B                   ;3

L9378:
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       ldy    rAA                     ;3
       cpy    #$60                    ;2
       bcc    L9386                   ;2
       ldx    #$3E                    ;2
       bne    L93B2                   ;2 always branch

L9386:
       ldy    rAC                     ;3
       lda    L9277,y                 ;4 load level digit pointer
       sta    rD3+10                  ;3
       lda    #<L9150                 ;2 space
       sta    rD3+8                   ;3
       lda    #<L9195                 ;2 "MISSION"
       sta    rD3+6                   ;3
       lda    #<L918E                 ;2
       ldx    #<L9187                 ;2
       ldy    #<L9180                 ;2
L939B:
       sta    rD3+4                   ;3
       stx    rD3+2                   ;3
       sty    rD3                     ;3
       lda    #>L9100                 ;2 MSB of text sprites
       sta    rD3+1                   ;3
       sta    rD3+3                   ;3
       sta    rD3+5                   ;3
       sta    rD3+7                   ;3
       lda    #COLOR1+8               ;2
       jsr    L906F                   ;6 y=0 after
       ldx    #$35                    ;2
L93B2:
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       dex                            ;2
       bpl    L93B2                   ;2
L93B9:
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       ldy    #$00                    ;2
       sty    COLUBK                  ;3
       sty    GRP0                    ;3
       sty    GRP1                    ;3
       sty    ENAM1                   ;3
       sty    VDELP0                  ;3
       sty    REFP0                   ;3
       sty    REFP1                   ;3
       lda    r93                     ;3
       and    #$0F                    ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3+10                  ;3
       lda    r93                     ;3
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3+8                   ;3
       ldx    #$D0                    ;2
       lda    #COLOR0+2               ;2
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       sta    COLUBK                  ;3
       stx    VDELP0                  ;3
       stx    VDELP1                  ;3
       ldy    #$C4                    ;2
       lda    #COLOR8+12              ;2
       sta    COLUP0                  ;3
       sta    COLUP1                  ;3
       sty.w  NUSIZ0                  ;4
       sty    NUSIZ1                  ;3
       jsr    L90D2                   ;6 waste 12 cycles
       jsr    L90D2                   ;6 waste 12 cycles
       sty    RESP0                   ;3
       sta    RESP1                   ;3
       ldy    #$90                    ;2
       sty    HMP0                    ;3
       ldy    #$80                    ;2
       sty    HMP1                    ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       jsr    L92AA                   ;6 y=0 after
       ldx    #$D0                    ;2
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       stx    VDELP0                  ;3
       stx    VDELP1                  ;3
       ldy    #$C3                    ;2
       lda    #COLOR0+12              ;2
       sta    COLUP0                  ;3
       sta    COLUP1                  ;3
       sta    RESP0                   ;3
       sty    NUSIZ0                  ;3
       sta    RESM0                   ;3
       sty    NUSIZ1                  ;3
       jsr    L90D2                   ;6 waste 12 cycles
       stx    HMM0                    ;3
       sty    HMP0                    ;3
       dec    $2E                     ;5 waste 5 cycles
       sta    RESP1                   ;3
       sta    RESM1                   ;3
       sty    HMM1                    ;3
       sty    HMP1                    ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       jsr    L90D2                   ;6 waste 12 cycles
       jsr    L90D2                   ;6 waste 12 cycles
       sta    HMCLR                   ;3
       lda    #$01                    ;2
       sta    CTRLPF                  ;3
       lda    #COLOR0+12              ;2
       sta    COLUPF                  ;3
       lda    #$FF                    ;2
       ldy    #$04                    ;2
       sty    loopCount               ;3
       dey                            ;2
       ldx    #$C0                    ;2
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       sta    PF1                     ;3
       lda    #$80                    ;2
       sta    GRP0                    ;3
       sta    GRP1                    ;3
       sta    GRP0                    ;3
       sty    ENAM0                   ;3
       sty    ENAM1                   ;3
       sty    PF2                     ;3
       lda    r92                     ;3 p1 energy in upper nybble
       and    #$7F                    ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       stx    PF0                     ;3
       tay                            ;2
       lda    r92                     ;3 p2 energy in low nybble
       and    #$0F                    ;2
       tax                            ;2
       lda    #$00                    ;2
       sta    PF2                     ;3
L9489: ;draw energy bars...
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       sta    PF0                     ;3
       lda    L90F4,y                 ;4
       sta    PF1                     ;3
       lda    #COLOR7+4               ;2
       sta    COLUPF                  ;3
       lda    L90FA,y                 ;4
       sta    PF2                     ;3
       lda    L928F,x                 ;4
       sta    PF0                     ;3
       lda    L9289,x                 ;4
       sta    PF1                     ;3
       lda    #COLOR3+4               ;2
       sta    COLUPF                  ;3
       lda    #$00                    ;2
       sta    PF2                     ;3
       dec    loopCount               ;5
       bne    L9489                   ;2
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       tay                            ;2
       sty    PF0                     ;3
       dey                            ;2
       sty    PF1                     ;3
       ldx    #$03                    ;2
       stx    PF2                     ;3
       ldx    #COLOR0+12              ;2
       stx    COLUPF                  ;3
       ldx    #$C3                    ;2
       stx    NUSIZ1                  ;3
       jsr    L90D2                   ;6 waste 12 cycles
       sta    PF2                     ;3 a=0
       lda    #$C1                    ;2
       sta    PF0                     ;3
       jsr    L90C6                   ;6 y=0 after
       sty    PF0                     ;3
       sty    PF1                     ;3
       sty    ENAM0                   ;3
       sty    PF2                     ;3
       sty    ENAM1                   ;3
       ldx    #TIME1                  ;2
       asl                            ;2 a=#$82
       sta    WSYNC                   ;3
       stx    TIM64T                  ;4
       sta    VBLANK                  ;3
       jmp    L9FD0                   ;3 (LF04E destination)

L94F7:
       lda    gameVariation           ;3
       cmp    #$03                    ;2
       beq    L9578                   ;2
       ldx    #$00                    ;2
       stx    r92                     ;3
       stx    r93                     ;3
       lda    gameVariation           ;3
       beq    L9516                   ;2
       cmp    #$01                    ;2
       beq    L953B                   ;2
       cmp    #$02                    ;2
       beq    L9536                   ;2
       cmp    #$04                    ;2
       beq    L9526                   ;2
L9516:
       lda    rE7                     ;3
       bne    L9520                   ;2
       ldx    rE8                     ;3
       lda    #$01                    ;2
       bne    L9541                   ;2 always branch

L9520:
       ldy    rE8                     ;3
       lda    #$02                    ;2
       bne    L9541                   ;2 always branch

L9526:
       lda    rE7                     ;3
       bne    L9530                   ;2
       ldx    rEA                     ;3
       lda    #$01                    ;2
       bne    L9541                   ;2 always branch

L9530:
       ldy    rEA                     ;3
       lda    #$02                    ;2
       bne    L9541                   ;2 always branch

L9536:
       ldy    rE9                     ;3
       .byte $2C                      ;4 skip next 2 bytes
L953B:
       ldy    rEA                     ;3
       ldx    rE8                     ;3
       lda    #$03                    ;2
L9541:
       sta    rE2                     ;3
       and    #$01                    ;2 check if p1 alive
       beq    L9555                   ;2  branch if no
  IF INFINITE_LIFE
       lda    #$25                    ;2
       sta    r9C,x                   ;4
       lda    #$20                    ;2
       sta    r93                     ;3
       lda    #$14                    ;2
  ELSE
       lda    r9C,x                   ;4
       and    #$F0                    ;2
       sta    r93                     ;3
       lda    r9C,x                   ;4
       asl                            ;2
       asl                            ;2
  ENDIF
       asl                            ;2
       asl                            ;2
       sta    r92                     ;3 store p1 energy in upper nybble
L9555:
       lda    rE2                     ;3
       and    #$02                    ;2 check if p2 alive
       beq    L956F                   ;2  branch if no
       lda.wy r9C,y                   ;4
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       ora    r93                     ;3
       sta    r93                     ;3
       lda.wy r9C,y                   ;4
       and    #$0F                    ;2
       ora    r92                     ;3
       sta    r92                     ;3 store p2 energy in low nybble
L956F:
       lda    rE7                     ;3
       clc                            ;2
       ror                            ;2
       ror                            ;2
       ora    r92                     ;3
       sta    r92                     ;3
L9578:
       ldx    #$00                    ;2
       lda    gameVariation           ;3
       cmp    #$03                    ;2
       beq    L958D                   ;2
       lda    r8E                     ;3
       cmp    #$AA                    ;2
       bne    L958F                   ;2
       stx    AUDV0                   ;3
       stx    AUDV1                   ;3
       jmp    L96DC                   ;3

L958D:
       stx    r82                     ;3
L958F:
       lda    r82                     ;3
       bne    L95A1                   ;2
       lda    r85                     ;3
       bne    L95CE                   ;2
L9597:
       lda    #$00                    ;2
       sta    r82                     ;3
       sta    r83                     ;3
       beq    L95CC                   ;2 always branch

L95A1:
       tax                            ;2
       asl                            ;2
       tay                            ;2
       dec    r84                     ;5
       bpl    L95AF                   ;2
       lda    L9B9A,x                 ;4
       sta    r84                     ;3
       inc    r83                     ;5
L95AF:
       lda    L9BA7-2,y               ;4 done
       sta    musicAdr                ;3
       lda    L9BA7-1,y               ;4 done
       sta    musicAdr+1              ;3
       lda    L9B8E,x                 ;4
       sta    AUDC0                   ;3
       ldy    r83                     ;3
       lda    (musicAdr),y            ;5
       beq    L9597                   ;2
       sta    AUDF0                   ;3
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       and    #$0E                    ;2
L95CC:
       sta    AUDV0                   ;3
L95CE:
       ldx    gameVariation           ;3
       cpx    #$03                    ;2
       bne    L95D8                   ;2
       lda    #$01                    ;2
       bne    L95F7                   ;2 always branch

L95D8:
       lda    rE0                     ;3
       bne    L95F7                   ;2
       cpx    #$02                    ;2
       bne    L95E4                   ;2
       txa                            ;2 a=2
       bne    L95F7                   ;2 always branch

L95E4:
       ldx    rAC                     ;3
       lda    rF0                     ;3
       cmp    #$02                    ;2
       beq    L95F5                   ;2
       cmp    #$03                    ;2
       beq    L95F5                   ;2
       lda    L9ABE,x                 ;4
       .byte $2C                      ;4 skip next 2 bytes
L95F5:
       lda    #$03                    ;2
L95F7:
       cmp    r85                     ;3
       beq    L9604                   ;2
       ldx    r85                     ;3
       cpx    #$07                    ;2
       beq    L9604                   ;2
       jsr    L9BBF                   ;6
L9604:
       lda    frameCounter            ;3
       and    #$0F                    ;2
       tax                            ;2
       lda    L9611,x                 ;4
       bne    L9621                   ;2
       jmp    L96DC                   ;3

L9630:
       lda    #$00                    ;2
       .byte $2C                      ;4 skip next 2 bytes
L965F:
       lda    r85                     ;3
       jsr    L9BBF                   ;6
       beq    L9648                   ;2 always branch

L9635:
       asl                            ;2
       asl                            ;2
       sta    loopCount2              ;3
       txa                            ;2
       asl                            ;2
       adc    loopCount2              ;3
       tay                            ;2
       lda    L9BE9-4,y               ;4
       sta    musicAdr                ;3
       lda    L9BE9-3,y               ;4
       sta    musicAdr+1              ;3
L9648:
       lda    r86,x                   ;4
       asl                            ;2
       tay                            ;2
       lda    (musicAdr),y            ;5
       sta    rE8                     ;3
       iny                            ;2
       lda    (musicAdr),y            ;5
       cmp    #$FF                    ;2 check for delimiters
       beq    L965F                   ;2
       cmp    #$FE                    ;2
       beq    L9630                   ;2
       sta    rE8+1                   ;3 no delimiter...store as MSB
       ldy    r88,x                   ;4
       lda    r8A,x                   ;4
       bmi    L9681                   ;2
       dec    r8A,x                   ;6
       bpl    L9681                   ;2
       iny                            ;2
       lda    (rE8),y                 ;5
       cmp    #$FF                    ;2
       bne    L9681                   ;2
       inc    r86,x                   ;6
       ldy    #$00                    ;2
       sty    r88,x                   ;4
       beq    L9648                   ;2 always branch

L9621:
       ldx    #$01                    ;2
L9623:
       lda    r85                     ;3
       bne    L9635                   ;2
       ldy    r82                     ;3
       beq    L96D8                   ;2
       cpx    #$01                    ;2
       bne    L9635                   ;2
       beq    L96D8                   ;2 always branch

L9681:
       sty    r88,x                   ;4
       lda    r8A,x                   ;4
       bpl    L9694                   ;2
       lda    (rE8),y                 ;5
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       tay                            ;2
       lda    L9FB3,y                 ;4
       sta    r8A,x                   ;4
L9694:
       txa                            ;2
       bne    L969B                   ;2
       lda    r82                     ;3
       bne    L96D2                   ;2
L969B:
       ldy    r88,x                   ;4
       lda    (rE8),y                 ;5
       and    #$1F                    ;2
       beq    L96D0                   ;2
       tay                            ;2
       lda    L9F9C,y                 ;4
       sta    AUDF0,x                 ;4
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       and    #$0E                    ;2
       sta    AUDC0,x                 ;4
       ldy    r88,x                   ;4
       lda    (rE8),y                 ;5
       and    #$E0                    ;2
       cmp    #$40                    ;2
       beq    L96C2                   ;2
       bcs    L96C8                   ;2
       lda    r8A,x                   ;4
       asl                            ;2
       bpl    L96C4                   ;2
L96C2:
       lda    r8A,x                   ;4
L96C4:
       cpx    #$00                    ;2
       beq    L96D0                   ;2
L96C8:
       lda    #$0A                    ;2
       ldy    r8A,x                   ;4
       bne    L96D0                   ;2
       lda    #$05                    ;2
L96D0:
       sta    AUDV0,x                 ;4
L96D2:
       dex                            ;2
       bmi    L96DC                   ;2
       bpl    L9623                   ;2 always branch

L96D8:
       sta    AUDV0                   ;3
L96DA:
       sta    AUDV1                   ;3
L96DC:
       inc    frameCounter            ;5
       ldx    #$0A                    ;2
       lda    #>L9100                 ;2
L96E2:
       sta    rD3+1,x                 ;4
       dex                            ;2
       dex                            ;2
       bpl    L96E2                   ;2
       ldx    #$02                    ;2 convert score to pointers...
L96EA:
       txa                            ;2
       asl                            ;2
       asl                            ;2
       tay                            ;2
       lda    r8C,x                   ;4
       and    #$F0                    ;2
       lsr                            ;2
       sta.wy rD3,y                   ;5
       lda    r8C,x                   ;4
       and    #$0F                    ;2
       asl                            ;2
       asl                            ;2
       asl                            ;2
       sta.wy rD3+2,y                 ;5
       dex                            ;2
       bpl    L96EA                   ;2
       inx                            ;2 x=0
       ldy    #<L9150                 ;2 blank space
L9706: ;remove leading zeroes...
       lda    rD3,x                   ;4
       bne    L9712                   ;2
       sty    rD3,x                   ;4
       inx                            ;2
       inx                            ;2
       cpx    #$0A                    ;2
       bcc    L9706                   ;2
L9712:
       ldx    #$00                    ;2
L9714:
       lda    r8F,x                   ;4
       and    #$F0                    ;2
       bne    L972F                   ;2
       lda    r8F,x                   ;4
       ora    #$A0                    ;2
       sta    r8F,x                   ;4
       cmp    #$A0                    ;2
       bne    L972F                   ;2
       cpx    #$02                    ;2
       beq    L972F                   ;2
       lda    #$AA                    ;2
       sta    r8F,x                   ;4
       inx                            ;2
       bne    L9714                   ;2 always branch

L972F:
       lda    rC2                     ;3
       cmp    #$10                    ;2
       bcs    L9739                   ;2
       ora    #$A0                    ;2
       sta    rC2                     ;3
L9739:
       ldx    rAC                     ;3
       lda    L9AAB,x                 ;4 done
       sta    bckgrndColorPtr         ;3
       lda    #>LB1DB                 ;2
       sta    bckgrndColorPtr+1       ;3

       lda    L9AF7,x                 ;4
       sta    rB9                     ;3
       lda    L9B0A,x                 ;4
       sta    rBA                     ;3
       lda    L9AD1,x                 ;4
       sta    rBB                     ;3
       lda    L9AE4,x                 ;4
       sta    rBC                     ;3

       lda    L998E,x                 ;4 done
       sta    rF2                     ;3
       lda    L9A26,x                 ;4 done
       sta    rF2+1                   ;3
       lda    L99B4,x                 ;4 done
       sta    rF6                     ;3
       lda    L9A4C,x                 ;4 done
       sta    rF6+1                   ;3
       lda    L99A1,x                 ;4 done
       sta    rE8                     ;3
       lda    L9A39,x                 ;4 done
       sta    rE8+1                   ;3
       lda    L99C7,x                 ;4 done
       sta    rEA                     ;3
       lda    L9A5F,x                 ;4 done
       sta    rEA+1                   ;3
       lda    L99DA,x                 ;4 done
       sta    rEC                     ;3
       lda    L9A72,x                 ;4 done
       sta    rEC+1                   ;3
       lda    L99ED,x                 ;4 done
       sta    rEE                     ;3
       lda    L9A85,x                 ;4 done
       sta    rEE+1                   ;3
       lda    L9A00,x                 ;4 done
       sta    rF4                     ;3
       lda    L9A98,x                 ;4 done
       sta    rF4+1                   ;3
       lda    L997B,x                 ;4 done
       sta    rF0                     ;3
       lda    L9A13,x                 ;4 done
       sta    rF0+1                   ;3
       cpx    #$12                    ;2
       bne    L97B8                   ;2
       lda    rAB                     ;3
       and    #$0C                    ;2
       cmp    #$0C                    ;2
       beq    L97C0                   ;2
       cmp    #$04                    ;2
       beq    L97C0                   ;2
L97B8:
       lda    L991C,x                 ;4 done
       ldy    L9968,x                 ;4 done
       bne    L97C4                   ;2 always branch

L97C0:
       lda    #<LB3A5                 ;2
       ldy    #>LB3A5                 ;2
L97C4:
       sta    rE4                     ;3
       sty    rE4+1                   ;3
       lda    L98E3,x                 ;4 done
       sta    rE0                     ;3
       lda    L992F,x                 ;4 done
       sta    rE0+1                   ;3
       lda    L98F6,x                 ;4 done
       sta    rE2                     ;3
L97D7:
       ldy    INTIM                   ;4
       cpy    #$04                    ;2
       bcs    L97D7                   ;2
       ldy    #$01                    ;2
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       sty    VBLANK                  ;3
       lda    #COLOR0+2               ;2
       sta    COLUBK                  ;3
       dey                            ;2 y=0
       sty    PF0                     ;3
       sty    REFP0                   ;3
       sty    REFP1                   ;3
       lda    L9942,x                 ;4 done
       sta    rE2+1                   ;3
       lda    L9909,x                 ;4 done
       sta    rE6                     ;3
       lda    L9955,x                 ;4 done
       sta    rE6+1                   ;3
       lda    #COLOR7+6               ;2
       jsr    L906F                   ;6 y=0 after
       ldx    #>L9008                 ;2 check if text should be previous page...
       bit    rAB                     ;3
       bmi    L9829                   ;2
       lda    gameVariation           ;3
       cmp    #$03                    ;2
       bne    L9829                   ;2
       stx    rD3+9                   ;3 update MSBs...
       stx    rD3+11                  ;3
       stx    rD3+5                   ;3
       stx    rD3+7                   ;3
       stx    rD3+3                   ;3
       stx    rD3+1                   ;3
L9829:
       lda    r8F                     ;3
       and    #$0F                    ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3+2                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       lda    r8F                     ;3
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3                     ;3
       lda    r90                     ;3
       and    #$0F                    ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3+6                   ;3
       lda    r90                     ;3
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3+4                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       lda    r91                     ;3
       and    #$0F                    ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3+10                  ;3
       lda    r91                     ;3
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3+8                   ;3
       lda    #COLOR3+6               ;2
       sta    COLUP0                  ;3
       sta    COLUP1                  ;3
       jsr    L9094                   ;6 y=0 after
       sty    COLUP1                  ;3
       lda    rC2                     ;3
       and    #$0F                    ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3+10                  ;3
       lda    rC2                     ;3
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       tay                            ;2
       lda    L91E9,y                 ;4
       sta    rD3+8                   ;3
       lda    #$91                    ;2
       sta    rD3+9                   ;3
       sta    rD3+11                  ;3
       ldx    #$30                    ;2
       stx    NUSIZ1                  ;3
       lda    rDF                     ;3
       and    #$0F                    ;2
       tay                            ;2
       lda    #$FF                    ;2
       sta    ENAM1                   ;3
       lda    #$F3                    ;2
L98AC:
       dey                            ;2
       bpl    L98AC                   ;2
       ldy    #COLOR0+2               ;2
       sta    RESBL                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       stx    ENAM1                   ;3
       sta    NUSIZ1                  ;3
       lda    r91                     ;3
       and    #$0F                    ;2
       bne    L98C8                   ;2
       ldy    #COLOR1+8               ;2
       .byte $2C                      ;4 skip next 2 bytes
L98C8:
       dec    $2E                     ;5
       sty    COLUP0                  ;3
       sty    COLUP1                  ;3
       lda    #<L919C                 ;2 "TIME" text...
       sta    rD3                     ;3
       lda    #<L91A3                 ;2
       sta    rD3+2                   ;3
       lda    #<L9178                 ;2
       sta    rD3+4                   ;3
       lda    #<L9150                 ;2
       sta    rD3+6                   ;3
       jsr    L9096                   ;6 ends @20...y=0 after
       jmp    L9FDC                   ;3 @23 (LB004 destination)

;       ORG  $186B
;       RORG $986B
;       .byte 0

       ORG  $1907,0
       RORG $9907,0

L9BDB:
       .byte $03 ; |      XX| $9BDB
       .byte $03 ; |      XX| $9BDC
       .byte $01 ; |       X| $9BDD
       .byte $03 ; |      XX| $9BDE
       .byte $03 ; |      XX| $9BDF
       .byte $03 ; |      XX| $9BE0
       .byte $03 ; |      XX| $9BE1
L9BE2:
       .byte $07 ; |     XXX| $9BE2
       .byte $07 ; |     XXX| $9BE3
       .byte $03 ; |      XX| $9BE4
       .byte $07 ; |     XXX| $9BE5
       .byte $17 ; |   X XXX| $9BE6
       .byte $07 ; |     XXX| $9BE7
       .byte $0F ; |    XXXX| $9BE8

L90E4: ;17
       .byte $00 ; |        | $90E4
       .byte $00 ; |        | $90E5
       .byte $80 ; |X       | $90E6
       .byte $80 ; |X       | $90E7
       .byte $C0 ; |XX      | $90E8
       .byte $C0 ; |XX      | $90E9
       .byte $C0 ; |XX      | $90EA
       .byte $E0 ; |XXX     | $90EB
       .byte $E0 ; |XXX     | $90EC
       .byte $60 ; | XX     | $90ED
       .byte $70 ; | XXX    | $90EE
       .byte $78 ; | XXXX   | $90EF
       .byte $3C ; |  XXXX  | $90F0
       .byte $3C ; |  XXXX  | $90F1
       .byte $1C ; |   XXX  | $90F2
       .byte $0C ; |    XX  | $90F3
L90D3: ;17
       .byte $00 ; |        | $90D3 shared
       .byte $3F ; |  XXXXXX| $90D4
       .byte $7F ; | XXXXXXX| $90D5
       .byte $FF ; |XXXXXXXX| $90D6
       .byte $FF ; |XXXXXXXX| $90D7
       .byte $9F ; |X  XXXXX| $90D8
       .byte $C7 ; |XX   XXX| $90D9
       .byte $D1 ; |XX X   X| $90DA
       .byte $D4 ; |XX X X  | $90DB
       .byte $D5 ; |XX X X X| $90DC
       .byte $D5 ; |XX X X X| $90DD
       .byte $55 ; | X X X X| $90DE
       .byte $75 ; | XXX X X| $90DF
       .byte $35 ; |  XX X X| $90E0
       .byte $1D ; |   XXX X| $90E1
       .byte $0F ; |    XXXX| $90E2
       .byte $06 ; |     XX | $90E3

L9D6D: ;17
       .byte $13 ; |   X  XX| $9D6D
       .byte $10 ; |   X    | $9D6E
       .byte $0D ; |    XX X| $9D6F
       .byte $0B ; |    X XX| $9D70
       .byte $09 ; |    X  X| $9D71
       .byte $05 ; |     X X| $9D72
       .byte $04 ; |     X  | $9D73
       .byte $03 ; |      XX| $9D74
       .byte $01 ; |       X| $9D75
       .byte $03 ; |      XX| $9D76
       .byte $04 ; |     X  | $9D77
       .byte $05 ; |     X X| $9D78
       .byte $09 ; |    X  X| $9D79
       .byte $0B ; |    X XX| $9D7A
       .byte $0D ; |    XX X| $9D7B
       .byte $10 ; |   X    | $9D7C
       .byte $FF ; |XXXXXXXX| $9D7D

L9E39: ;33
       .byte $41 ; | X     X| $9E39
       .byte $40 ; | X      | $9E3A
       .byte $55 ; | X X X X| $9E3B
       .byte $40 ; | X      | $9E3C
       .byte $49 ; | X  X  X| $9E3D
       .byte $40 ; | X      | $9E3E
       .byte $56 ; | X X XX | $9E3F
       .byte $40 ; | X      | $9E40
       .byte $41 ; | X     X| $9E41
       .byte $40 ; | X      | $9E42
       .byte $55 ; | X X X X| $9E43
       .byte $40 ; | X      | $9E44
       .byte $49 ; | X  X  X| $9E45
       .byte $40 ; | X      | $9E46
       .byte $56 ; | X X XX | $9E47
       .byte $40 ; | X      | $9E48
       .byte $41 ; | X     X| $9E49
       .byte $40 ; | X      | $9E4A
       .byte $55 ; | X X X X| $9E4B
       .byte $40 ; | X      | $9E4C
       .byte $49 ; | X  X  X| $9E4D
       .byte $40 ; | X      | $9E4E
       .byte $45 ; | X   X X| $9E4F
       .byte $40 ; | X      | $9E50
       .byte $45 ; | X   X X| $9E51
       .byte $40 ; | X      | $9E52
       .byte $45 ; | X   X X| $9E53
       .byte $40 ; | X      | $9E54
       .byte $47 ; | X   XXX| $9E55
       .byte $40 ; | X      | $9E56
       .byte $47 ; | X   XXX| $9E57
       .byte $40 ; | X      | $9E58
       .byte $FF ; |XXXXXXXX| $9E59

L98F6:
       .byte <LB3B9 ; $98F6
       .byte <LB3A5 ; $98F7
       .byte <LB41E ; $98F8
       .byte <LB800 ; $98F9
       .byte <LB3A5 ; $98FA
       .byte <LB64C ; $98FB
       .byte <LB814 ; $98FC
       .byte <LB41E ; $98FD
       .byte <LB3A5 ; $98FE
       .byte <LB83E ; $98FF
       .byte <LBC00 ; $9900
       .byte <LB83E ; $9901
       .byte <LB3A5 ; $9902
       .byte <LB3A5 ; $9903
       .byte <LBA20 ; $9904
       .byte <LB3A5 ; $9905
       .byte <LB3A5 ; $9906
       .byte <LB3A5 ; $9907
       .byte <LB3A5 ; $9908

L991C:
       .byte <LB24A ; $991C
       .byte <LB225 ; $991D
       .byte <LB200 ; $991E
       .byte <LB515 ; $991F
       .byte <LB561 ; $9920
       .byte <LB270 ; $9921
       .byte <LB726 ; $9922
       .byte <LB3A5 ; $9923
       .byte <LB225 ; $9924
       .byte <LB700 ; $9925
       .byte <LB864 ; $9926
       .byte <LB700 ; $9927
       .byte <LB6BE ; $9928
       .byte <LB864 ; $9929
       .byte <LB9A3 ; $992A
       .byte <LBB72 ; $992B
       .byte <LBA92 ; $992C
       .byte <LBB98 ; $992D
       .byte <LBC46 ; $992E

L9955:
       .byte >LB397 ; $9955
       .byte >LB3A5 ; $9956
       .byte >LB400 ; $9957
       .byte >LB3A5 ; $9958
       .byte >LB5AD ; $9959
       .byte >LB3A5 ; $995A
       .byte >LB3A5 ; $995B
       .byte >LB3A5 ; $995C
       .byte >LB3A5 ; $995D
       .byte >LB871 ; $995E
       .byte >LB871 ; $995F
       .byte >LB871 ; $9960
       .byte >LB3A5 ; $9961
       .byte >LB3A5 ; $9962
       .byte >LB43C ; $9963
       .byte >LBB4C ; $9964
       .byte >LB3A5 ; $9965
       .byte >LB3A5 ; $9966
       .byte >LB43C ; $9967

L9968:
       .byte >LB24A ; $9968
       .byte >LB225 ; $9969
       .byte >LB200 ; $996A
       .byte >LB515 ; $996B
       .byte >LB561 ; $996C
       .byte >LB270 ; $996D
       .byte >LB726 ; $996E
       .byte >LB3A5 ; $996F
       .byte >LB225 ; $9970
       .byte >LB700 ; $9971
       .byte >LB864 ; $9972
       .byte >LB700 ; $9973
       .byte >LB6BE ; $9974
       .byte >LB864 ; $9975
       .byte >LB9A3 ; $9976
       .byte >LBB72 ; $9977
       .byte >LBA92 ; $9978
       .byte >LBB98 ; $9979
       .byte >LBC46 ; $997A

L997B:
       .byte <LB2E9 ; $997B
       .byte <LB2DE ; $997C
       .byte <LB2D3 ; $997D
       .byte <LB2F4 ; $997E
       .byte <LB5E9 ; $997F
       .byte <LB5F4 ; $9980
       .byte <LBAE9 ; $9981
       .byte <LBAF4 ; $9982
       .byte <LBAF4 ; $9983
       .byte <LBBE4 ; $9984
       .byte <LBBE4 ; $9985
       .byte <LBBE4 ; $9986
       .byte <LBAF4 ; $9987
       .byte <LBAF4 ; $9988
       .byte <LB9EF ; $9989
       .byte <LBCA6 ; $998A
       .byte <LBCA6 ; $998B
       .byte <LBCA6 ; $998C
       .byte <LBC9B ; $998D

L998E:
       .byte <LB296 ; $998E
       .byte <LB3A5 ; $998F
       .byte <LB2A1 ; $9990
       .byte <LB3A5 ; $9991
       .byte <LB3E9 ; $9992
       .byte <LB3A5 ; $9993
       .byte <LB6EF ; $9994
       .byte <LB3A5 ; $9995
       .byte <LB3A5 ; $9996
       .byte <LB3A5 ; $9997
       .byte <LB3A5 ; $9998
       .byte <LB3A5 ; $9999
       .byte <LB3A5 ; $999A
       .byte <LB3A5 ; $999B
       .byte <LB3A5 ; $999C
       .byte <LBE26 ; $999D
       .byte <LB3A5 ; $999E
       .byte <LB3A5 ; $999F
       .byte <LB3A5 ; $99A0

L99A1:
       .byte <LB2A9 ; $99A1
       .byte <LB3A5 ; $99A2
       .byte <LB2B4 ; $99A3
       .byte <LB3A5 ; $99A4
       .byte <LB3F4 ; $99A5
       .byte <LB3A5 ; $99A6
       .byte <LB3A5 ; $99A7
       .byte <LB3A5 ; $99A8
       .byte <LB3A5 ; $99A9
       .byte <LB7E4 ; $99AA
       .byte <LB7E4 ; $99AB
       .byte <LB7E4 ; $99AC
       .byte <LB3A5 ; $99AD
       .byte <LBBEF ; $99AE
       .byte <LB3A5 ; $99AF
       .byte <LBB00 ; $99B0
       .byte <LB3A5 ; $99B1
       .byte <LB3A5 ; $99B2
       .byte <LB3A5 ; $99B3

L99ED:
       .byte <LB2C8 ; $99ED
       .byte <LB2BE ; $99EE
       .byte <LB3A5 ; $99EF
       .byte <LB3A5 ; $99F0
       .byte <LB5D3 ; $99F1
       .byte <LB3A5 ; $99F2
       .byte <LB3A5 ; $99F3
       .byte <LB8E4 ; $99F4
       .byte <LB8E4 ; $99F5
       .byte <LB8EB ; $99F6
       .byte <LB8EB ; $99F7
       .byte <LB8EB ; $99F8
       .byte <LB8E4 ; $99F9
       .byte <LB8E4 ; $99FA
       .byte <LB3A5 ; $99FB
       .byte <LB3A5 ; $99FC
       .byte <LB3A5 ; $99FD
       .byte <LB3A5 ; $99FE
       .byte <LB3A5 ; $99FF

       ORG  $1A00
       RORG $9A00

L9CAE: ;8
       .byte $80 ; |X       | $9CAE
       .byte $C0 ; |XX      | $9CAF
       .byte $8B ; |X   X XX| $9CB0
       .byte $C0 ; |XX      | $9CB1
       .byte $80 ; |X       | $9CB2
       .byte $8D ; |X   XX X| $9CB3
       .byte $C0 ; |XX      | $9CB4
       .byte $FF ; |XXXXXXXX| $9CB5

L9A13:
       .byte >LB2E9 ; $9A13
       .byte >LB2DE ; $9A14
       .byte >LB2D3 ; $9A15
       .byte >LB2F4 ; $9A16
       .byte >LB5E9 ; $9A17
       .byte >LB5F4 ; $9A18
       .byte >LBAE9 ; $9A19
       .byte >LBAF4 ; $9A1A
       .byte >LBAF4 ; $9A1B
       .byte >LBBE4 ; $9A1C
       .byte >LBBE4 ; $9A1D
       .byte >LBBE4 ; $9A1E
       .byte >LBAF4 ; $9A1F
       .byte >LBAF4 ; $9A20
       .byte >LB9EF ; $9A21
       .byte >LBCA6 ; $9A22
       .byte >LBCA6 ; $9A23
       .byte >LBCA6 ; $9A24
       .byte >LBC9B ; $9A25

L9A26:
       .byte >LB296 ; $9A26
       .byte >LB3A5 ; $9A27
       .byte >LB2A1 ; $9A28
       .byte >LB3A5 ; $9A29
       .byte >LB3E9 ; $9A2A
       .byte >LB3A5 ; $9A2B
       .byte >LB6EF ; $9A2C
       .byte >LB3A5 ; $9A2D
       .byte >LB3A5 ; $9A2E
       .byte >LB3A5 ; $9A2F
       .byte >LB3A5 ; $9A30
       .byte >LB3A5 ; $9A31
       .byte >LB3A5 ; $9A32
       .byte >LB3A5 ; $9A33
       .byte >LB3A5 ; $9A34
       .byte >LBE26 ; $9A35
       .byte >LB3A5 ; $9A36
       .byte >LB3A5 ; $9A37
       .byte >LB3A5 ; $9A38

L9A39:
       .byte >LB2A9 ; $9A39
       .byte >LB3A5 ; $9A3A
       .byte >LB2B4 ; $9A3B
       .byte >LB3A5 ; $9A3C
       .byte >LB3F4 ; $9A3D
       .byte >LB3A5 ; $9A3E
       .byte >LB3A5 ; $9A3F
       .byte >LB3A5 ; $9A40
       .byte >LB3A5 ; $9A41
       .byte >LB7E4 ; $9A42
       .byte >LB7E4 ; $9A43
       .byte >LB7E4 ; $9A44
       .byte >LB3A5 ; $9A45
       .byte >LBBEF ; $9A46
       .byte >LB3A5 ; $9A47
       .byte >LBB00 ; $9A48
       .byte >LB3A5 ; $9A49
       .byte >LB3A5 ; $9A4A
       .byte >LB3A5 ; $9A4B

L9A85:
       .byte >LB2C8 ; $9A85
       .byte >LB2BE ; $9A86
       .byte >LB3A5 ; $9A87
       .byte >LB3A5 ; $9A88
       .byte >LB5D3 ; $9A89
       .byte >LB3A5 ; $9A8A
       .byte >LB3A5 ; $9A8B
       .byte >LB8E4 ; $9A8C
       .byte >LB8E4 ; $9A8D
       .byte >LB8EB ; $9A8E
       .byte >LB8EB ; $9A8F
       .byte >LB8EB ; $9A90
       .byte >LB8E4 ; $9A91
       .byte >LB8E4 ; $9A92
       .byte >LB3A5 ; $9A93
       .byte >LB3A5 ; $9A94
       .byte >LB3A5 ; $9A95
       .byte >LB3A5 ; $9A96
       .byte >LB3A5 ; $9A97

L9AAB:
       .byte <LB1DD ; $9AAB
       .byte <LB1DB ; $9AAC
       .byte <LB1E0 ; $9AAD
       .byte <LB1E5 ; $9AAE
       .byte <LB1E8 ; $9AAF
       .byte <LB1EB ; $9AB0
       .byte <LB1F1 ; $9AB1
       .byte <LB1DB ; $9AB2
       .byte <LB1DB ; $9AB3
       .byte <LB1EE ; $9AB4
       .byte <LB1EE ; $9AB5
       .byte <LB1EE ; $9AB6
       .byte <LB1DB ; $9AB7
       .byte <LB1DB ; $9AB8
       .byte <LB1E2 ; $9AB9
       .byte <LB1F4 ; $9ABA
       .byte <LB1F4 ; $9ABB
       .byte <LB1F4 ; $9ABC
       .byte <LB1F4 ; $9ABD

L9A00:
       .byte <LB2C8 ; $9A00
       .byte <LB2BE ; $9A01
       .byte <LB3A5 ; $9A02
       .byte <LB3A5 ; $9A03
       .byte <LB5DE ; $9A04
       .byte <LB3A5 ; $9A05
       .byte <LB3A5 ; $9A06
       .byte <LB8E4 ; $9A07
       .byte <LB8E4 ; $9A08
       .byte <LBADE ; $9A09
       .byte <LBADE ; $9A0A
       .byte <LBADE ; $9A0B
       .byte <LB8E4 ; $9A0C
       .byte <LB8E4 ; $9A0D
       .byte <LB3A5 ; $9A0E
       .byte <LBC90 ; $9A0F
       .byte <LB3A5 ; $9A10
       .byte <LB3A5 ; $9A11
L99DA: ;PF0 pointer
       .byte <LB3A5 ; $99DA shared
       .byte <LB2BE ; $99DB
       .byte <LB3A5 ; $99DC
       .byte <LB3A5 ; $99DD
       .byte <LB3DF ; $99DE
       .byte <LB3A5 ; $99DF
       .byte <LB7C8 ; $99E0
       .byte <LB8E4 ; $99E2 sunset
       .byte <LB8E4 ; $99E2 sunset
       .byte <LB3A5 ; $99E3
       .byte <LB3A5 ; $99E4
       .byte <LB3A5 ; $99E5
       .byte <LB8E4 ; $99E6
       .byte <LB8E4 ; $99E7
L98E3:
       .byte <LB3A5 ; $98E3 shared
       .byte <LB3A5 ; $98E4 shared
       .byte <LB3A5 ; $98E5 shared
       .byte <LB3A5 ; $98E6 shared
       .byte <LB3A5 ; $98E7 shared
       .byte <LB626 ; $98E8
       .byte <LB7BE ; $98E9
       .byte <LB3A5 ; $98EA
       .byte <LB3A5 ; $98EB
       .byte <LB3A5 ; $98EC
       .byte <LBC00 ; $98ED
       .byte <LB3A5 ; $98EE
       .byte <LB3A5 ; $98EF
       .byte <LB3A5 ; $98F0
       .byte <LBA00 ; $98F1
       .byte <LB3A5 ; $98F2
       .byte <LB3A5 ; $98F3
L99B4:
       .byte <LB3A5 ; $99B4 shared
       .byte <LB3A5 ; $99B5 shared
       .byte <LB2A1 ; $99B6
       .byte <LB3A5 ; $99B7
       .byte <LB3E9 ; $99B8
       .byte <LB3A5 ; $99B9
       .byte <LB6E4 ; $99BA
       .byte <LB3A5 ; $99BB
       .byte <LB3A5 ; $99BC
       .byte <LB3A5 ; $99BD
       .byte <LB3A5 ; $99BE
       .byte <LB3A5 ; $99BF
       .byte <LB3A5 ; $99C0
       .byte <LB3A5 ; $99C1
       .byte <LB3A5 ; $99C2
       .byte <LBE26 ; $99C3
       .byte <LB3A5 ; $99C4
L99C7:
       .byte <LB3A5 ; $99C7 shared
       .byte <LB3A5 ; $99C8 shared
       .byte <LB2B4 ; $99C9
       .byte <LB3A5 ; $99CA
       .byte <LB3F4 ; $99CB
       .byte <LB3A5 ; $99CC
       .byte <LB7EF ; $99CD
       .byte <LB3A5 ; $99CE
       .byte <LB3A5 ; $99CF
       .byte <LB3A5 ; $99D0
       .byte <LB3A5 ; $99D1
       .byte <LB3A5 ; $99D2
       .byte <LB3A5 ; $99D3
       .byte <LBBEF ; $99D4
       .byte <LB3A5 ; $99D5
       .byte <LBB00 ; $99D6
       .byte <LB3A5 ; $99D7
       .byte <LB3A5 ; $99D8
       .byte <LB3A5 ; $99D9

L9A98:
       .byte >LB2C8 ; $9A98
       .byte >LB2BE ; $9A99
       .byte >LB3A5 ; $9A9A
       .byte >LB3A5 ; $9A9B
       .byte >LB5DE ; $9A9C
       .byte >LB3A5 ; $9A9D
       .byte >LB3A5 ; $9A9E
       .byte >LB8E4 ; $9A9F
       .byte >LB8E4 ; $9AA0
       .byte >LBADE ; $9AA1
       .byte >LBADE ; $9AA2
       .byte >LBADE ; $9AA3
       .byte >LB8E4 ; $9AA4
       .byte >LB8E4 ; $9AA5
       .byte >LB3A5 ; $9AA6
       .byte >LBC90 ; $9AA7
       .byte >LB3A5 ; $9AA8
       .byte >LB3A5 ; $9AA9
L9A72:
       .byte >LB3A5 ; $9A72 shared
       .byte >LB2BE ; $9A73
       .byte >LB3A5 ; $9A74
       .byte >LB3A5 ; $9A75
       .byte >LB3DF ; $9A76
       .byte >LB3A5 ; $9A77
       .byte >LB7C8 ; $9A78
       .byte >LB8E4 ; $9A7A sunset
       .byte >LB8E4 ; $9A7A sunset
       .byte >LB3A5 ; $9A7B
       .byte >LB3A5 ; $9A7C
       .byte >LB3A5 ; $9A7D
       .byte >LB8E4 ; $9A7E
       .byte >LB8E4 ; $9A7F
L992F:
       .byte >LB3A5 ; $992F shared
       .byte >LB3A5 ; $9930 shared
       .byte >LB3A5 ; $9931 shared
       .byte >LB3A5 ; $9932 shared
       .byte >LB3A5 ; $9933 shared
       .byte >LB626 ; $9934
       .byte >LB7BE ; $9935
       .byte >LB3A5 ; $9936
       .byte >LB3A5 ; $9937
       .byte >LB3A5 ; $9938
       .byte >LBC00 ; $9939
       .byte >LB3A5 ; $993A
       .byte >LB3A5 ; $993B
       .byte >LB3A5 ; $993C
       .byte >LBA00 ; $993D
       .byte >LB3A5 ; $993E
       .byte >LB3A5 ; $993F
L9A4C:
       .byte >LB3A5 ; $9A4C shared
       .byte >LB3A5 ; $9A4D shared
       .byte >LB2A1 ; $9A4E
       .byte >LB3A5 ; $9A4F
       .byte >LB3E9 ; $9A50
       .byte >LB3A5 ; $9A51
       .byte >LB6E4 ; $9A52
       .byte >LB3A5 ; $9A53
       .byte >LB3A5 ; $9A54
       .byte >LB3A5 ; $9A55
       .byte >LB3A5 ; $9A56
       .byte >LB3A5 ; $9A57
       .byte >LB3A5 ; $9A58
       .byte >LB3A5 ; $9A59
       .byte >LB3A5 ; $9A5A
       .byte >LBE26 ; $9A5B
       .byte >LB3A5 ; $9A5C
       .byte >LB3A5 ; $9A5D
       .byte >LB3A5 ; $9A5E

       ORG  $1B00
       RORG $9B00

L9BA7: ;24
       .word L9B46  ; $9BA7 - $9BA8
       .word L9B6D  ; $9BA9 - $9BAA
       .word L9B35  ; $9BAB - $9BAC
       .word L9B68  ; $9BAD - $9BAE
       .word L9B49  ; $9BAF - $9BB0
       .word L9B43  ; $9BB1 - $9BB2
       .word L9B2D  ; $9BB3 - $9BB4
       .word L9B57  ; $9BB5 - $9BB6
       .word L9B62  ; $9BB7 - $9BB8
       .word L9B77  ; $9BB9 - $9BBA
       .word L9B85  ; $9BBB - $9BBC
       .word L9B87  ; $9BBD - $9BBE

L9BE9:
       .word L9E5A  ; $9BE9 - $9BEA
       .word L9E6C  ; $9BEB - $9BEC
       .word L9DB1  ; $9BED - $9BEE
       .word L9DBB  ; $9BEF - $9BF0
       .word L9D3D  ; $9BF1 - $9BF2
       .word L9D5F  ; $9BF3 - $9BF4
       .word L9CDA  ; $9BF5 - $9BF6
       .word L9CE2  ; $9BF7 - $9BF8
       .word L9C09  ; $9BF9 - $9BFA
       .word L9C3B  ; $9BFB - $9BFC
       .word L9C01  ; $9BFD - $9BFE
       .word L9C05  ; $9BFF - $9C00
L9C01:
       .word L9CEA  ; $9C01 - $9C02
       .word $FEFE  ; $9C03 - $9C04

L9C05:
       .word L9CF9  ; $9C05 - $9C06
       .word $FEFE  ; $9C07 - $9C08

L9C09:
       .word L9CBA  ; $9C09 - $9C0A
       .word L9CBA  ; $9C0B - $9C0C
       .word L9CCA  ; $9C0D - $9C0E
       .word L9CBA  ; $9C0F - $9C10
       .word L9CBA  ; $9C11 - $9C12
       .word L9CBA  ; $9C13 - $9C14
       .word L9CCA  ; $9C15 - $9C16
       .word L9CBA  ; $9C17 - $9C18
       .word L9CBA  ; $9C19 - $9C1A
       .word L9CBA  ; $9C1B - $9C1C
       .word L9C5F  ; $9C1D - $9C1E
       .word L9C6E  ; $9C1F - $9C20
       .word L9C5F  ; $9C21 - $9C22
       .word L9C74  ; $9C23 - $9C24
       .word L9C5F  ; $9C25 - $9C26
       .word L9C6E  ; $9C27 - $9C28
       .word L9C79  ; $9C29 - $9C2A
       .word L9C5F  ; $9C2B - $9C2C
       .word L9C6E  ; $9C2D - $9C2E
       .word L9C5F  ; $9C2F - $9C30
       .word L9C74  ; $9C31 - $9C32
       .word L9C5F  ; $9C33 - $9C34
       .word L9C6E  ; $9C35 - $9C36
       .word L9C79  ; $9C37 - $9C38
       .word $FFFF  ; $9C39 - $9C3A

L9C3B:
       .word L9C8A  ; $9C3B - $9C3C
       .word L9CA7  ; $9C3D - $9C3E
       .word L9CAE  ; $9C3F - $9C40
       .word L9C5F  ; $9C41 - $9C42
       .word L9C6C  ; $9C43 - $9C44
       .word L9C5F  ; $9C45 - $9C46
       .word L9C71  ; $9C47 - $9C48
       .word L9C5F  ; $9C49 - $9C4A
       .word L9C6C  ; $9C4B - $9C4C
       .word L9C79  ; $9C4D - $9C4E
       .word L9C5F  ; $9C4F - $9C50
       .word L9C6C  ; $9C51 - $9C52
       .word L9C5F  ; $9C53 - $9C54
       .word L9C71  ; $9C55 - $9C56
       .word L9C5F  ; $9C57 - $9C58
       .word L9C6C  ; $9C59 - $9C5A
       .word L9C79  ; $9C5B - $9C5C
       .word $FFFF  ; $9C5D - $9C5E

L9D3D:
       .word L9D6D  ; $9D3D - $9D3E
       .word L9D6D  ; $9D3F - $9D40
       .word L9D6D  ; $9D41 - $9D42
       .word L9D6D  ; $9D43 - $9D44
       .word L9D6D  ; $9D45 - $9D46
       .word L9D6D  ; $9D47 - $9D48
       .word L9D6D  ; $9D49 - $9D4A
       .word L9D6D  ; $9D4B - $9D4C
       .word L9DA0  ; $9D4D - $9D4E
       .word L9DA0  ; $9D4F - $9D50
       .word L9DA0  ; $9D51 - $9D52
       .word L9DA0  ; $9D53 - $9D54
       .word L9DA0  ; $9D55 - $9D56
       .word L9DA0  ; $9D57 - $9D58
       .word L9DA0  ; $9D59 - $9D5A
       .word L9DA0  ; $9D5B - $9D5C
       .word $FFFF  ; $9D5D - $9D5E

L9D5F:
       .word L9D7E  ; $9D5F - $9D60
       .word L9D7E  ; $9D61 - $9D62
       .word L9D7E  ; $9D63 - $9D64
       .word L9D7E  ; $9D65 - $9D66
       .word L9D8F  ; $9D67 - $9D68
       .word L9D8F  ; $9D69 - $9D6A
       .word $FFFF  ; $9D6B - $9D6C

L9DB1:
       .word L9E18  ; $9DB1 - $9DB2
       .word L9E39  ; $9DB3 - $9DB4
       .word L9E18  ; $9DB5 - $9DB6
       .word L9DF7  ; $9DB7 - $9DB8
       .word $FFFF  ; $9DB9 - $9DBA

L9DBB:
       .word L9DBF  ; $9DBB - $9DBC
       .word $FFFF  ; $9DBD - $9DBE

L9E5A:
       .word L9E78  ; $9E5A - $9E5B
       .word L9EE9  ; $9E5C - $9E5D
       .word L9E78  ; $9E5E - $9E5F
       .word L9EFA  ; $9E60 - $9E61
       .word L9F0E  ; $9E62 - $9E63
       .word L9F0E  ; $9E64 - $9E65
       .word L9F2F  ; $9E66 - $9E67
       .word L9EED  ; $9E68 - $9E69
       .word $FFFF  ; $9E6A - $9E6B

L9E6C:
       .word L9F40  ; $9E6C - $9E6D
       .word L9F64  ; $9E6E - $9E6F
       .word L9F40  ; $9E70 - $9E71
       .word L9F71  ; $9E72 - $9E73
       .word L9F65  ; $9E74 - $9E75
       .word $FFFF  ; $9E76 - $9E77

L9CDA:
       .word L9CEA  ; $9CDA - $9CDB
       .word L9D1E  ; $9CDC - $9CDD
       .word L9D1E  ; $9CDE - $9CDF
       .word $FEFE  ; $9CE0 - $9CE1

L9CE2:
       .word L9CF9  ; $9CE2 - $9CE3
       .word L9D01  ; $9CE4 - $9CE5
       .word L9D01  ; $9CE6 - $9CE7
       .word $FEFE  ; $9CE8 - $9CE9

L90F4: ;6
       .byte $00 ; |        | $90F4
       .byte $C0 ; |XX      | $90F5
       .byte $F0 ; |XXXX    | $90F6
       .byte $FC ; |XXXXXX  | $90F7
       .byte $FF ; |XXXXXXXX| $90F8
       .byte $FF ; |XXXXXXXX| $90F9

       ORG  $1C00
       RORG $9C00

L9CA7: ;7
       .byte $80 ; |X       | $9CA7
       .byte $C0 ; |XX      | $9CA8
       .byte $8B ; |X   X XX| $9CA9
       .byte $C0 ; |XX      | $9CAA
       .byte $80 ; |X       | $9CAB
       .byte $8D ; |X   XX X| $9CAC
       .byte $FF ; |XXXXXXXX| $9CAD

L9611: ;16
  IF PAL50
       .byte $00 ; |        | $9611
       .byte $FF ; |XXXXXXXX| $9612
       .byte $FF ; |XXXXXXXX| $9613
       .byte $FF ; |XXXXXXXX| $9614
       .byte $00 ; |        | $9615
       .byte $FF ; |XXXXXXXX| $9616
       .byte $FF ; |XXXXXXXX| $9617
       .byte $FF ; |XXXXXXXX| $9618
       .byte $00 ; |        | $9619
       .byte $FF ; |XXXXXXXX| $961A
       .byte $FF ; |XXXXXXXX| $961B
       .byte $FF ; |XXXXXXXX| $961C
       .byte $00 ; |        | $961D
       .byte $FF ; |XXXXXXXX| $961E
       .byte $FF ; |XXXXXXXX| $961F
       .byte $FF ; |XXXXXXXX| $9620
  ELSE
       .byte $00 ; |        | $9611
       .byte $FF ; |XXXXXXXX| $9612
       .byte $FF ; |XXXXXXXX| $9613
       .byte $00 ; |        | $9614
       .byte $FF ; |XXXXXXXX| $9615
       .byte $00 ; |        | $9616
       .byte $FF ; |XXXXXXXX| $9617
       .byte $00 ; |        | $9618
       .byte $FF ; |XXXXXXXX| $9619
       .byte $FF ; |XXXXXXXX| $961A
       .byte $00 ; |        | $961B
       .byte $FF ; |XXXXXXXX| $961C
       .byte $00 ; |        | $961D
       .byte $FF ; |XXXXXXXX| $961E
       .byte $00 ; |        | $961F
       .byte $FF ; |XXXXXXXX| $9620
  ENDIF

L9ABE:
       .byte $02 ; |      X | $9ABE
       .byte $02 ; |      X | $9ABF
       .byte $02 ; |      X | $9AC0
       .byte $02 ; |      X | $9AC1
       .byte $02 ; |      X | $9AC2
       .byte $02 ; |      X | $9AC3
       .byte $05 ; |     X X| $9AC4
       .byte $05 ; |     X X| $9AC5
       .byte $05 ; |     X X| $9AC6
       .byte $05 ; |     X X| $9AC7
       .byte $05 ; |     X X| $9AC8
       .byte $05 ; |     X X| $9AC9
       .byte $05 ; |     X X| $9ACA
       .byte $05 ; |     X X| $9ACB
       .byte $05 ; |     X X| $9ACC
       .byte $05 ; |     X X| $9ACD
       .byte $05 ; |     X X| $9ACE
       .byte $05 ; |     X X| $9ACF
       .byte $05 ; |     X X| $9AD0
L9AD1:
       .byte $34 ; |  XX X  | $9AD1
       .byte $B0 ; |X XX    | $9AD2
       .byte $78 ; | XXXX   | $9AD3
       .byte $81 ; |X      X| $9AD4
       .byte $69 ; | XX X  X| $9AD5
       .byte $68 ; | XX X   | $9AD6
       .byte $70 ; | XXX    | $9AD7
       .byte $78 ; | XXXX   | $9AD8
       .byte $B0 ; |X XX    | $9AD9
       .byte $43 ; | X    XX| $9ADA
       .byte $60 ; | XX     | $9ADB
       .byte $2F ; |  X XXXX| $9ADC
       .byte $40 ; | X      | $9ADD
       .byte $5B ; | X XX XX| $9ADE
       .byte $51 ; | X X   X| $9ADF
       .byte $73 ; | XXX  XX| $9AE0
       .byte $58 ; | X XX   | $9AE1
       .byte $56 ; | X X XX | $9AE2
       .byte $45 ; | X   X X| $9AE3
L9AE4:
       .byte $79 ; | XXXX  X| $9AE4
       .byte $94 ; |X  X X  | $9AE5
       .byte $B2 ; |X XX  X | $9AE6
       .byte $79 ; | XXXX  X| $9AE7
       .byte $71 ; | XXX   X| $9AE8
       .byte $75 ; | XXX X X| $9AE9
       .byte $70 ; | XXX    | $9AEA
       .byte $B2 ; |X XX  X | $9AEB
       .byte $94 ; |X  X X  | $9AEC
       .byte $79 ; | XXXX  X| $9AED
       .byte $B9 ; |X XXX  X| $9AEE
       .byte $84 ; |X    X  | $9AEF
       .byte $A0 ; |X X     | $9AF0
       .byte $C3 ; |XX    XX| $9AF1
       .byte $30 ; |  XX    | $9AF2
       .byte $87 ; |X    XXX| $9AF3
       .byte $A7 ; |X X  XXX| $9AF4
       .byte $72 ; | XXX  X | $9AF5
       .byte $C1 ; |XX     X| $9AF6
L9AF7:
       .byte $5D ; | X XXX X| $9AF7
       .byte $B0 ; |X XX    | $9AF8
       .byte $43 ; | X    XX| $9AF9
       .byte $55 ; | X X X X| $9AFA
       .byte $59 ; | X XX  X| $9AFB
       .byte $59 ; | X XX  X| $9AFC
       .byte $70 ; | XXX    | $9AFD
       .byte $43 ; | X    XX| $9AFE
       .byte $B0 ; |X XX    | $9AFF
       .byte $5D ; | X XXX X| $9B00
       .byte $5D ; | X XXX X| $9B01
       .byte $5D ; | X XXX X| $9B02
       .byte $B0 ; |X XX    | $9B03
       .byte $5B ; | X XX XX| $9B04
       .byte $51 ; | X X   X| $9B05
       .byte $77 ; | XXX XXX| $9B06
       .byte $59 ; | X XX  X| $9B07
       .byte $59 ; | X XX  X| $9B08
       .byte $59 ; | X XX  X| $9B09
L9B0A:
       .byte $C4 ; |XX   X  | $9B0A
       .byte $B0 ; |X XX    | $9B0B
       .byte $A5 ; |X X  X X| $9B0C
       .byte $60 ; | XX     | $9B0D
       .byte $61 ; | XX    X| $9B0E
       .byte $61 ; | XX    X| $9B0F
       .byte $70 ; | XXX    | $9B10
       .byte $A5 ; |X X  X X| $9B11
       .byte $B0 ; |X XX    | $9B12
       .byte $C4 ; |XX   X  | $9B13
       .byte $C4 ; |XX   X  | $9B14
       .byte $C4 ; |XX   X  | $9B15
       .byte $B0 ; |X XX    | $9B16
       .byte $C3 ; |XX    XX| $9B17
       .byte $30 ; |  XX    | $9B18
       .byte $83 ; |X     XX| $9B19
       .byte $61 ; | XX    X| $9B1A
       .byte $61 ; | XX    X| $9B1B
       .byte $61 ; | XX    X| $9B1C
L9B1D:
       .byte $18 ; |   XX   | $9B1D
       .byte $18 ; |   XX   | $9B1E
       .byte $18 ; |   XX   | $9B1F
       .byte $18 ; |   XX   | $9B20
       .byte $18 ; |   XX   | $9B21
       .byte $28 ; |  X X   | $9B22
       .byte $28 ; |  X X   | $9B23
       .byte $28 ; |  X X   | $9B24
       .byte $28 ; |  X X   | $9B25
       .byte $28 ; |  X X   | $9B26
       .byte $28 ; |  X X   | $9B27
       .byte $28 ; |  X X   | $9B28
       .byte $28 ; |  X X   | $9B29
       .byte $28 ; |  X X   | $9B2A
       .byte $40 ; | X      | $9B2B
       .byte $40 ; | X      | $9B2C

L9B2D: ;audio tables...bits0-4 = freq, bits 5-7 = vol (rolled to low nybble)
       .byte $F8 ; |XXXXX   | $9B2D
       .byte $E0 ; |XXX     | $9B2E
       .byte $C0 ; |XX      | $9B2F
       .byte $A1 ; |X X    X| $9B30
       .byte $81 ; |X      X| $9B31
       .byte $61 ; | XX    X| $9B32
       .byte $41 ; | X     X| $9B33
       .byte $00 ; |        | $9B34 delimiter
L9B35:
       .byte $9C ; |X  XXX  | $9B35
       .byte $BA ; |X XXX X | $9B36
       .byte $D8 ; |XX XX   | $9B37
       .byte $F6 ; |XXXX XX | $9B38
       .byte $F4 ; |XXXX X  | $9B39
       .byte $F4 ; |XXXX X  | $9B3A
       .byte $F5 ; |XXXX X X| $9B3B
       .byte $F6 ; |XXXX XX | $9B3C
       .byte $F7 ; |XXXX XXX| $9B3D
       .byte $F8 ; |XXXXX   | $9B3E
       .byte $D9 ; |XX XX  X| $9B3F
       .byte $BA ; |X XXX X | $9B40
       .byte $9C ; |X  XXX  | $9B41
       .byte $00 ; |        | $9B42 delimiter
L9B43:
       .byte $DF ; |XX XXXXX| $9B43
       .byte $9F ; |X  XXXXX| $9B44
       .byte $00 ; |        | $9B45 delimiter
L9B46:
       .byte $F1 ; |XXXX   X| $9B46
       .byte $01 ; |       X| $9B47
       .byte $00 ; |        | $9B48 delimiter
L9B49:
       .byte $E2 ; |XXX   X | $9B49
       .byte $01 ; |       X| $9B4A
       .byte $E3 ; |XXX   XX| $9B4B
       .byte $01 ; |       X| $9B4C
       .byte $E4 ; |XXX  X  | $9B4D
       .byte $01 ; |       X| $9B4E
       .byte $E5 ; |XXX  X X| $9B4F
       .byte $01 ; |       X| $9B50
       .byte $E6 ; |XXX  XX | $9B51
       .byte $01 ; |       X| $9B52
       .byte $E7 ; |XXX  XXX| $9B53
       .byte $01 ; |       X| $9B54
       .byte $E8 ; |XXX X   | $9B55
       .byte $00 ; |        | $9B56 delimiter
L9B57:
       .byte $2C ; |  X XX  | $9B57
       .byte $4B ; | X  X XX| $9B58
       .byte $6A ; | XX X X | $9B59
       .byte $89 ; |X   X  X| $9B5A
       .byte $A8 ; |X X X   | $9B5B
       .byte $C7 ; |XX   XXX| $9B5C
       .byte $A8 ; |X X X   | $9B5D
       .byte $89 ; |X   X  X| $9B5E
       .byte $6A ; | XX X X | $9B5F
       .byte $4B ; | X  X XX| $9B60
       .byte $00 ; |        | $9B61 delimiter
L9B62:
       .byte $60 ; | XX     | $9B62
       .byte $81 ; |X      X| $9B63
       .byte $64 ; | XX  X  | $9B64
       .byte $46 ; | X   XX | $9B65
       .byte $28 ; |  X X   | $9B66
       .byte $00 ; |        | $9B67 delimiter
L9B68:
       .byte $CC ; |XX  XX  | $9B68
       .byte $AD ; |X X XX X| $9B69
       .byte $8E ; |X   XXX | $9B6A
       .byte $6F ; | XX XXXX| $9B6B
       .byte $00 ; |        | $9B6C delimiter
L9B6D:
       .byte $30 ; |  XX    | $9B6D
       .byte $50 ; | X X    | $9B6E
       .byte $70 ; | XXX    | $9B6F
       .byte $90 ; |X  X    | $9B70
       .byte $B0 ; |X XX    | $9B71
       .byte $90 ; |X  X    | $9B72
       .byte $70 ; | XXX    | $9B73
       .byte $50 ; | X X    | $9B74
       .byte $30 ; |  XX    | $9B75
       .byte $00 ; |        | $9B76 delimiter
L9B77:
       .byte $DF ; |XX XXXXX| $9B77
       .byte $01 ; |       X| $9B78
       .byte $DF ; |XX XXXXX| $9B79
       .byte $01 ; |       X| $9B7A
       .byte $DF ; |XX XXXXX| $9B7B
       .byte $01 ; |       X| $9B7C
       .byte $DF ; |XX XXXXX| $9B7D
       .byte $01 ; |       X| $9B7E
       .byte $DF ; |XX XXXXX| $9B7F
       .byte $01 ; |       X| $9B80
       .byte $DF ; |XX XXXXX| $9B81
       .byte $01 ; |       X| $9B82
       .byte $DF ; |XX XXXXX| $9B83
       .byte $00 ; |        | $9B84 delimiter
L9B85:
       .byte $3F ; |  XXXXXX| $9B85
       .byte $00 ; |        | $9B86 delimiter
L9B87:
       .byte $30 ; |  XX    | $9B87
       .byte $50 ; | X X    | $9B88
       .byte $70 ; | XXX    | $9B89
       .byte $90 ; |X  X    | $9B8A
       .byte $71 ; | XXX   X| $9B8B
       .byte $52 ; | X X  X | $9B8C
       .byte $33 ; |  XX  XX| $9B8D
L9B8E:
       .byte $00 ; |        | $9B8E shared (delimiter)
       .byte $04 ; |     X  | $9B8F
       .byte $0C ; |    XX  | $9B90
       .byte $09 ; |    X  X| $9B91
       .byte $09 ; |    X  X| $9B92
       .byte $0C ; |    XX  | $9B93
       .byte $08 ; |    X   | $9B94
       .byte $08 ; |    X   | $9B95
       .byte $08 ; |    X   | $9B96
       .byte $08 ; |    X   | $9B97
       .byte $08 ; |    X   | $9B98
       .byte $08 ; |    X   | $9B99
L9B9A:
       .byte $0C ; |    XX  | $9B9A
       .byte $1B ; |   XX XX| $9B9B
       .byte $00 ; |        | $9B9C
       .byte $02 ; |      X | $9B9D
       .byte $00 ; |        | $9B9E
       .byte $00 ; |        | $9B9F
       .byte $03 ; |      XX| $9BA0
       .byte $00 ; |        | $9BA1
       .byte $00 ; |        | $9BA2
       .byte $00 ; |        | $9BA3
       .byte $03 ; |      XX| $9BA4
       .byte $1F ; |   XXXXX| $9BA5
       .byte $00 ; |        | $9BA6

       ORG  $1D00
       RORG $9D00

L9BBF: ;28
       sta    r85                     ;3
       tay                            ;2
       lda    L9BDB-1,y               ;4
       sta    r8A                     ;3
       lda    L9BE2-1,y               ;4
       sta    r8B                     ;3
       lda    #$00                    ;2
       sta    r88                     ;3
       sta    r89                     ;3
       sta    r86                     ;3
       sta    r87                     ;3
       sta    AUDV0                   ;3
       sta    AUDV1                   ;3
       rts                            ;6

L9C79: ;17
       .byte $44 ; | X   X  | $9C79
       .byte $44 ; | X   X  | $9C7A
       .byte $44 ; | X   X  | $9C7B
       .byte $44 ; | X   X  | $9C7C
       .byte $49 ; | X  X  X| $9C7D
       .byte $44 ; | X   X  | $9C7E
       .byte $44 ; | X   X  | $9C7F
       .byte $47 ; | X   XXX| $9C80
       .byte $44 ; | X   X  | $9C81
       .byte $44 ; | X   X  | $9C82
       .byte $45 ; | X   X X| $9C83
       .byte $44 ; | X   X  | $9C84
       .byte $44 ; | X   X  | $9C85
       .byte $44 ; | X   X  | $9C86
       .byte $43 ; | X    XX| $9C87
       .byte $44 ; | X   X  | $9C88
       .byte $FF ; |XXXXXXXX| $9C89

L9CBA: ;16
       .byte $44 ; | X   X  | $9CBA
       .byte $40 ; | X      | $9CBB
       .byte $44 ; | X   X  | $9CBC
       .byte $40 ; | X      | $9CBD
       .byte $44 ; | X   X  | $9CBE
       .byte $40 ; | X      | $9CBF
       .byte $41 ; | X     X| $9CC0
       .byte $40 ; | X      | $9CC1
       .byte $43 ; | X    XX| $9CC2
       .byte $40 ; | X      | $9CC3
       .byte $43 ; | X    XX| $9CC4
       .byte $40 ; | X      | $9CC5
       .byte $80 ; |X       | $9CC6
       .byte $43 ; | X    XX| $9CC7
       .byte $40 ; | X      | $9CC8
       .byte $FF ; |XXXXXXXX| $9CC9

L9CCA: ;16
       .byte $47 ; | X   XXX| $9CCA
       .byte $40 ; | X      | $9CCB
       .byte $47 ; | X   XXX| $9CCC
       .byte $40 ; | X      | $9CCD
       .byte $47 ; | X   XXX| $9CCE
       .byte $40 ; | X      | $9CCF
       .byte $43 ; | X    XX| $9CD0
       .byte $40 ; | X      | $9CD1
       .byte $45 ; | X   X X| $9CD2
       .byte $40 ; | X      | $9CD3
       .byte $45 ; | X   X X| $9CD4
       .byte $40 ; | X      | $9CD5
       .byte $80 ; |X       | $9CD6
       .byte $43 ; | X    XX| $9CD7
       .byte $40 ; | X      | $9CD8
       .byte $FF ; |XXXXXXXX| $9CD9

L9C8A: ;29
       .byte $E4 ; |XXX  X  | $9C8A
       .byte $E0 ; |XXX     | $9C8B
       .byte $83 ; |X     XX| $9C8C
       .byte $E1 ; |XXX    X| $9C8D
       .byte $80 ; |X       | $9C8E
       .byte $E0 ; |XXX     | $9C8F
       .byte $85 ; |X    X X| $9C90
       .byte $89 ; |X   X  X| $9C91
       .byte $E7 ; |XXX  XXX| $9C92
       .byte $E0 ; |XXX     | $9C93
       .byte $85 ; |X    X X| $9C94
       .byte $E4 ; |XXX  X  | $9C95
       .byte $E0 ; |XXX     | $9C96
       .byte $E0 ; |XXX     | $9C97
       .byte $E4 ; |XXX  X  | $9C98
       .byte $E0 ; |XXX     | $9C99
       .byte $85 ; |X    X X| $9C9A
       .byte $E4 ; |XXX  X  | $9C9B
       .byte $E0 ; |XXX     | $9C9C
       .byte $80 ; |X       | $9C9D
       .byte $85 ; |X    X X| $9C9E
       .byte $86 ; |X    XX | $9C9F
       .byte $E7 ; |XXX  XXX| $9CA0
       .byte $E0 ; |XXX     | $9CA1
       .byte $89 ; |X   X  X| $9CA2
       .byte $E4 ; |XXX  X  | $9CA3
       .byte $E0 ; |XXX     | $9CA4
       .byte $80 ; |X       | $9CA5
       .byte $FF ; |XXXXXXXX| $9CA6

L9C5F: ;13
       .byte $44 ; | X   X  | $9C5F
       .byte $44 ; | X   X  | $9C60
       .byte $44 ; | X   X  | $9C61
       .byte $44 ; | X   X  | $9C62
       .byte $44 ; | X   X  | $9C63
       .byte $44 ; | X   X  | $9C64
       .byte $44 ; | X   X  | $9C65
       .byte $44 ; | X   X  | $9C66
       .byte $44 ; | X   X  | $9C67
       .byte $44 ; | X   X  | $9C68
       .byte $44 ; | X   X  | $9C69
       .byte $44 ; | X   X  | $9C6A
       .byte $FF ; |XXXXXXXX| $9C6B

L9C6C: ;2
       .byte $85 ; |X    X X| $9C6C
       .byte $FF ; |XXXXXXXX| $9C6D

L9C74: ;5
       .byte $47 ; | X   XXX| $9C74
       .byte $40 ; | X      | $9C75
       .byte $45 ; | X   X X| $9C76
       .byte $40 ; | X      | $9C77
       .byte $FF ; |XXXXXXXX| $9C78

L9CEA: ;15
       .byte $43 ; | X    XX| $9CEA
       .byte $40 ; | X      | $9CEB
       .byte $43 ; | X    XX| $9CEC
       .byte $40 ; | X      | $9CED
       .byte $43 ; | X    XX| $9CEE
       .byte $40 ; | X      | $9CEF
       .byte $45 ; | X   X X| $9CF0
       .byte $40 ; | X      | $9CF1
       .byte $45 ; | X   X X| $9CF2
       .byte $40 ; | X      | $9CF3
       .byte $45 ; | X   X X| $9CF4
       .byte $40 ; | X      | $9CF5
       .byte $45 ; | X   X X| $9CF6
       .byte $40 ; | X      | $9CF7
       .byte $FF ; |XXXXXXXX| $9CF8

L9D1E: ;31
       .byte $56 ; | X X XX | $9D1E
       .byte $40 ; | X      | $9D1F
       .byte $56 ; | X X XX | $9D20
       .byte $40 ; | X      | $9D21
       .byte $55 ; | X X X X| $9D22
       .byte $40 ; | X      | $9D23
       .byte $56 ; | X X XX | $9D24
       .byte $40 ; | X      | $9D25
       .byte $56 ; | X X XX | $9D26
       .byte $40 ; | X      | $9D27
       .byte $55 ; | X X X X| $9D28
       .byte $40 ; | X      | $9D29
       .byte $56 ; | X X XX | $9D2A
       .byte $89 ; |X   X  X| $9D2B
       .byte $55 ; | X X X X| $9D2C
       .byte $56 ; | X X XX | $9D2D
       .byte $40 ; | X      | $9D2E
       .byte $56 ; | X X XX | $9D2F
       .byte $40 ; | X      | $9D30
       .byte $55 ; | X X X X| $9D31
       .byte $40 ; | X      | $9D32
       .byte $56 ; | X X XX | $9D33
       .byte $40 ; | X      | $9D34
       .byte $56 ; | X X XX | $9D35
       .byte $40 ; | X      | $9D36
       .byte $55 ; | X X X X| $9D37
       .byte $40 ; | X      | $9D38
       .byte $56 ; | X X XX | $9D39
       .byte $8B ; |X   X XX| $9D3A
       .byte $55 ; | X X X X| $9D3B
       .byte $FF ; |XXXXXXXX| $9D3C

L9D7E: ;17
       .byte $41 ; | X     X| $9D7E
       .byte $41 ; | X     X| $9D7F
       .byte $49 ; | X  X  X| $9D80
       .byte $41 ; | X     X| $9D81
       .byte $49 ; | X  X  X| $9D82
       .byte $41 ; | X     X| $9D83
       .byte $41 ; | X     X| $9D84
       .byte $49 ; | X  X  X| $9D85
       .byte $41 ; | X     X| $9D86
       .byte $49 ; | X  X  X| $9D87
       .byte $49 ; | X  X  X| $9D88
       .byte $41 ; | X     X| $9D89
       .byte $49 ; | X  X  X| $9D8A
       .byte $41 ; | X     X| $9D8B
       .byte $41 ; | X     X| $9D8C
       .byte $49 ; | X  X  X| $9D8D
       .byte $FF ; |XXXXXXXX| $9D8E

L9D8F: ;17
       .byte $C4 ; |XX   X  | $9D8F
       .byte $C5 ; |XX   X X| $9D90
       .byte $C4 ; |XX   X  | $9D91
       .byte $C7 ; |XX   XXX| $9D92
       .byte $C4 ; |XX   X  | $9D93
       .byte $C5 ; |XX   X X| $9D94
       .byte $C4 ; |XX   X  | $9D95
       .byte $C7 ; |XX   XXX| $9D96
       .byte $C4 ; |XX   X  | $9D97
       .byte $C5 ; |XX   X X| $9D98
       .byte $C4 ; |XX   X  | $9D99
       .byte $C7 ; |XX   XXX| $9D9A
       .byte $C9 ; |XX  X  X| $9D9B
       .byte $C8 ; |XX  X   | $9D9C
       .byte $C7 ; |XX   XXX| $9D9D
       .byte $C5 ; |XX   X X| $9D9E
       .byte $FF ; |XXXXXXXX| $9D9F

L9DA0: ;17
       .byte $4B ; | X  X XX| $9DA0
       .byte $4D ; | X  XX X| $9DA1
       .byte $4F ; | X  XXXX| $9DA2
       .byte $4B ; | X  X XX| $9DA3
       .byte $4F ; | X  XXXX| $9DA4
       .byte $50 ; | X X    | $9DA5
       .byte $4B ; | X  X XX| $9DA6
       .byte $4D ; | X  XX X| $9DA7
       .byte $4F ; | X  XXXX| $9DA8
       .byte $4B ; | X  X XX| $9DA9
       .byte $4F ; | X  XXXX| $9DAA
       .byte $50 ; | X X    | $9DAB
       .byte $4B ; | X  X XX| $9DAC
       .byte $4D ; | X  XX X| $9DAD
       .byte $4F ; | X  XXXX| $9DAE
       .byte $50 ; | X X    | $9DAF
       .byte $FF ; |XXXXXXXX| $9DB0

L9DF7: ;33
       .byte $41 ; | X     X| $9DF7
       .byte $40 ; | X      | $9DF8
       .byte $55 ; | X X X X| $9DF9
       .byte $40 ; | X      | $9DFA
       .byte $49 ; | X  X  X| $9DFB
       .byte $40 ; | X      | $9DFC
       .byte $56 ; | X X XX | $9DFD
       .byte $40 ; | X      | $9DFE
       .byte $41 ; | X     X| $9DFF
       .byte $40 ; | X      | $9E00
       .byte $55 ; | X X X X| $9E01
       .byte $40 ; | X      | $9E02
       .byte $49 ; | X  X  X| $9E03
       .byte $40 ; | X      | $9E04
       .byte $47 ; | X   XXX| $9E05
       .byte $40 ; | X      | $9E06
       .byte $55 ; | X X X X| $9E07
       .byte $40 ; | X      | $9E08
       .byte $49 ; | X  X  X| $9E09
       .byte $40 ; | X      | $9E0A
       .byte $56 ; | X X XX | $9E0B
       .byte $40 ; | X      | $9E0C
       .byte $44 ; | X   X  | $9E0D
       .byte $40 ; | X      | $9E0E
       .byte $44 ; | X   X  | $9E0F
       .byte $40 ; | X      | $9E10
       .byte $55 ; | X X X X| $9E11
       .byte $40 ; | X      | $9E12
       .byte $47 ; | X   XXX| $9E13
       .byte $40 ; | X      | $9E14
       .byte $49 ; | X  X  X| $9E15
       .byte $40 ; | X      | $9E16
       .byte $FF ; |XXXXXXXX| $9E17

       ORG  $1E00
       RORG $9E00

L9D01: ;29
       .byte $41 ; | X     X| $9D01
       .byte $40 ; | X      | $9D02
       .byte $41 ; | X     X| $9D03
       .byte $40 ; | X      | $9D04
       .byte $41 ; | X     X| $9D05
       .byte $40 ; | X      | $9D06
       .byte $41 ; | X     X| $9D07
       .byte $40 ; | X      | $9D08
       .byte $41 ; | X     X| $9D09
       .byte $40 ; | X      | $9D0A
       .byte $41 ; | X     X| $9D0B
       .byte $40 ; | X      | $9D0C
       .byte $41 ; | X     X| $9D0D
       .byte $A3 ; |X X   XX| $9D0E
       .byte $41 ; | X     X| $9D0F
       .byte $40 ; | X      | $9D10
       .byte $41 ; | X     X| $9D11
       .byte $40 ; | X      | $9D12
       .byte $41 ; | X     X| $9D13
       .byte $40 ; | X      | $9D14
       .byte $41 ; | X     X| $9D15
       .byte $40 ; | X      | $9D16
       .byte $41 ; | X     X| $9D17
       .byte $40 ; | X      | $9D18
       .byte $41 ; | X     X| $9D19
       .byte $40 ; | X      | $9D1A
       .byte $41 ; | X     X| $9D1B
       .byte $A4 ; |X X  X  | $9D1C
       .byte $FF ; |XXXXXXXX| $9D1D

L9DBF: ;56
       .byte $80 ; |X       | $9DBF
       .byte $8C ; |X   XX  | $9DC0
       .byte $8B ; |X   X XX| $9DC1
       .byte $80 ; |X       | $9DC2
       .byte $8C ; |X   XX  | $9DC3
       .byte $8B ; |X   X XX| $9DC4
       .byte $80 ; |X       | $9DC5
       .byte $8C ; |X   XX  | $9DC6
       .byte $80 ; |X       | $9DC7
       .byte $8B ; |X   X XX| $9DC8
       .byte $8C ; |X   XX  | $9DC9
       .byte $EF ; |XXX XXXX| $9DCA
       .byte $CD ; |XX  XX X| $9DCB
       .byte $80 ; |X       | $9DCC
       .byte $8C ; |X   XX  | $9DCD
       .byte $8B ; |X   X XX| $9DCE
       .byte $80 ; |X       | $9DCF
       .byte $8C ; |X   XX  | $9DD0
       .byte $8B ; |X   X XX| $9DD1
       .byte $80 ; |X       | $9DD2
       .byte $8C ; |X   XX  | $9DD3
       .byte $80 ; |X       | $9DD4
       .byte $8B ; |X   X XX| $9DD5
       .byte $8C ; |X   XX  | $9DD6
       .byte $ED ; |XXX XX X| $9DD7
       .byte $CF ; |XX  XXXX| $9DD8
       .byte $80 ; |X       | $9DD9
       .byte $8C ; |X   XX  | $9DDA
       .byte $8B ; |X   X XX| $9DDB
       .byte $80 ; |X       | $9DDC
       .byte $8C ; |X   XX  | $9DDD
       .byte $8B ; |X   X XX| $9DDE
       .byte $80 ; |X       | $9DDF
       .byte $8C ; |X   XX  | $9DE0
       .byte $80 ; |X       | $9DE1
       .byte $8B ; |X   X XX| $9DE2
       .byte $8C ; |X   XX  | $9DE3
       .byte $EF ; |XXX XXXX| $9DE4
       .byte $CD ; |XX  XX X| $9DE5
       .byte $80 ; |X       | $9DE6
       .byte $8C ; |X   XX  | $9DE7
       .byte $8B ; |X   X XX| $9DE8
       .byte $80 ; |X       | $9DE9
       .byte $8C ; |X   XX  | $9DEA
       .byte $8B ; |X   X XX| $9DEB
       .byte $80 ; |X       | $9DEC
       .byte $8F ; |X   XXXX| $9DED
       .byte $80 ; |X       | $9DEE
       .byte $90 ; |X  X    | $9DEF
       .byte $80 ; |X       | $9DF0
       .byte $8B ; |X   X XX| $9DF1
       .byte $8B ; |X   X XX| $9DF2
       .byte $8C ; |X   XX  | $9DF3
       .byte $8F ; |X   XXXX| $9DF4
       .byte $90 ; |X  X    | $9DF5
       .byte $FF ; |XXXXXXXX| $9DF6

L9E18: ;33
       .byte $41 ; | X     X| $9E18
       .byte $40 ; | X      | $9E19
       .byte $55 ; | X X X X| $9E1A
       .byte $40 ; | X      | $9E1B
       .byte $49 ; | X  X  X| $9E1C
       .byte $40 ; | X      | $9E1D
       .byte $56 ; | X X XX | $9E1E
       .byte $40 ; | X      | $9E1F
       .byte $41 ; | X     X| $9E20
       .byte $40 ; | X      | $9E21
       .byte $55 ; | X X X X| $9E22
       .byte $40 ; | X      | $9E23
       .byte $49 ; | X  X  X| $9E24
       .byte $40 ; | X      | $9E25
       .byte $56 ; | X X XX | $9E26
       .byte $40 ; | X      | $9E27
       .byte $41 ; | X     X| $9E28
       .byte $40 ; | X      | $9E29
       .byte $55 ; | X X X X| $9E2A
       .byte $40 ; | X      | $9E2B
       .byte $49 ; | X  X  X| $9E2C
       .byte $40 ; | X      | $9E2D
       .byte $47 ; | X   XXX| $9E2E
       .byte $40 ; | X      | $9E2F
       .byte $47 ; | X   XXX| $9E30
       .byte $40 ; | X      | $9E31
       .byte $47 ; | X   XXX| $9E32
       .byte $40 ; | X      | $9E33
       .byte $49 ; | X  X  X| $9E34
       .byte $40 ; | X      | $9E35
       .byte $49 ; | X  X  X| $9E36
       .byte $40 ; | X      | $9E37
       .byte $FF ; |XXXXXXXX| $9E38

L9CF9: ;8
       .byte $85 ; |X    X X| $9CF9
       .byte $85 ; |X    X X| $9CFA
       .byte $85 ; |X    X X| $9CFB
       .byte $89 ; |X   X  X| $9CFC
       .byte $89 ; |X   X  X| $9CFD
       .byte $89 ; |X   X  X| $9CFE
       .byte $89 ; |X   X  X| $9CFF
       .byte $FF ; |XXXXXXXX| $9D00

L9E78: ;113
       .byte $55 ; | X X X X| $9E78
       .byte $55 ; | X X X X| $9E79
       .byte $55 ; | X X X X| $9E7A
       .byte $55 ; | X X X X| $9E7B
       .byte $44 ; | X   X  | $9E7C
       .byte $40 ; | X      | $9E7D
       .byte $55 ; | X X X X| $9E7E
       .byte $40 ; | X      | $9E7F
       .byte $44 ; | X   X  | $9E80
       .byte $40 ; | X      | $9E81
       .byte $55 ; | X X X X| $9E82
       .byte $40 ; | X      | $9E83
       .byte $44 ; | X   X  | $9E84
       .byte $40 ; | X      | $9E85
       .byte $55 ; | X X X X| $9E86
       .byte $40 ; | X      | $9E87
       .byte $44 ; | X   X  | $9E88
       .byte $40 ; | X      | $9E89
       .byte $55 ; | X X X X| $9E8A
       .byte $40 ; | X      | $9E8B
       .byte $43 ; | X    XX| $9E8C
       .byte $40 ; | X      | $9E8D
       .byte $55 ; | X X X X| $9E8E
       .byte $40 ; | X      | $9E8F
       .byte $43 ; | X    XX| $9E90
       .byte $40 ; | X      | $9E91
       .byte $55 ; | X X X X| $9E92
       .byte $40 ; | X      | $9E93
       .byte $43 ; | X    XX| $9E94
       .byte $40 ; | X      | $9E95
       .byte $55 ; | X X X X| $9E96
       .byte $40 ; | X      | $9E97
       .byte $43 ; | X    XX| $9E98
       .byte $40 ; | X      | $9E99
       .byte $55 ; | X X X X| $9E9A
       .byte $40 ; | X      | $9E9B
       .byte $45 ; | X   X X| $9E9C
       .byte $40 ; | X      | $9E9D
       .byte $55 ; | X X X X| $9E9E
       .byte $40 ; | X      | $9E9F
       .byte $45 ; | X   X X| $9EA0
       .byte $40 ; | X      | $9EA1
       .byte $55 ; | X X X X| $9EA2
       .byte $40 ; | X      | $9EA3
       .byte $45 ; | X   X X| $9EA4
       .byte $40 ; | X      | $9EA5
       .byte $55 ; | X X X X| $9EA6
       .byte $40 ; | X      | $9EA7
       .byte $45 ; | X   X X| $9EA8
       .byte $40 ; | X      | $9EA9
       .byte $55 ; | X X X X| $9EAA
       .byte $40 ; | X      | $9EAB
       .byte $47 ; | X   XXX| $9EAC
       .byte $40 ; | X      | $9EAD
       .byte $55 ; | X X X X| $9EAE
       .byte $40 ; | X      | $9EAF
       .byte $47 ; | X   XXX| $9EB0
       .byte $40 ; | X      | $9EB1
       .byte $55 ; | X X X X| $9EB2
       .byte $40 ; | X      | $9EB3
       .byte $47 ; | X   XXX| $9EB4
       .byte $40 ; | X      | $9EB5
       .byte $55 ; | X X X X| $9EB6
       .byte $40 ; | X      | $9EB7
       .byte $47 ; | X   XXX| $9EB8
       .byte $40 ; | X      | $9EB9
       .byte $55 ; | X X X X| $9EBA
       .byte $40 ; | X      | $9EBB
       .byte $42 ; | X    X | $9EBC
       .byte $40 ; | X      | $9EBD
       .byte $55 ; | X X X X| $9EBE
       .byte $40 ; | X      | $9EBF
       .byte $42 ; | X    X | $9EC0
       .byte $40 ; | X      | $9EC1
       .byte $55 ; | X X X X| $9EC2
       .byte $40 ; | X      | $9EC3
       .byte $42 ; | X    X | $9EC4
       .byte $40 ; | X      | $9EC5
       .byte $55 ; | X X X X| $9EC6
       .byte $40 ; | X      | $9EC7
       .byte $42 ; | X    X | $9EC8
       .byte $40 ; | X      | $9EC9
       .byte $55 ; | X X X X| $9ECA
       .byte $40 ; | X      | $9ECB
       .byte $41 ; | X     X| $9ECC
       .byte $40 ; | X      | $9ECD
       .byte $55 ; | X X X X| $9ECE
       .byte $40 ; | X      | $9ECF
       .byte $41 ; | X     X| $9ED0
       .byte $40 ; | X      | $9ED1
       .byte $55 ; | X X X X| $9ED2
       .byte $40 ; | X      | $9ED3
       .byte $41 ; | X     X| $9ED4
       .byte $40 ; | X      | $9ED5
       .byte $55 ; | X X X X| $9ED6
       .byte $40 ; | X      | $9ED7
       .byte $41 ; | X     X| $9ED8
       .byte $40 ; | X      | $9ED9
       .byte $55 ; | X X X X| $9EDA
       .byte $40 ; | X      | $9EDB
       .byte $55 ; | X X X X| $9EDC
       .byte $56 ; | X X XX | $9EDD
       .byte $40 ; | X      | $9EDE
       .byte $55 ; | X X X X| $9EDF
       .byte $56 ; | X X XX | $9EE0
       .byte $40 ; | X      | $9EE1
       .byte $55 ; | X X X X| $9EE2
       .byte $56 ; | X X XX | $9EE3
       .byte $40 ; | X      | $9EE4
       .byte $55 ; | X X X X| $9EE5
       .byte $56 ; | X X XX | $9EE6
       .byte $40 ; | X      | $9EE7
       .byte $FF ; |XXXXXXXX| $9EE8

L9EE9: ;17
       .byte $55 ; | X X X X| $9EE9
       .byte $55 ; | X X X X| $9EEA
       .byte $55 ; | X X X X| $9EEB
       .byte $55 ; | X X X X| $9EEC
L9EED:
       .byte $56 ; | X X XX | $9EED
       .byte $40 ; | X      | $9EEE
       .byte $56 ; | X X XX | $9EEF
       .byte $40 ; | X      | $9EF0
       .byte $56 ; | X X XX | $9EF1
       .byte $40 ; | X      | $9EF2
       .byte $56 ; | X X XX | $9EF3
       .byte $40 ; | X      | $9EF4
       .byte $56 ; | X X XX | $9EF5
       .byte $40 ; | X      | $9EF6
       .byte $55 ; | X X X X| $9EF7
       .byte $55 ; | X X X X| $9EF8
       .byte $FF ; |XXXXXXXX| $9EF9

       ORG  $1F00
       RORG $9F00

L9942:
       .byte >LB3B9 ; $9942
       .byte >LB3A5 ; $9943
       .byte >LB41E ; $9944
       .byte >LB800 ; $9945
       .byte >LB3A5 ; $9946
       .byte >LB64C ; $9947
       .byte >LB814 ; $9948
       .byte >LB41E ; $9949
       .byte >LB3A5 ; $994A
       .byte >LB83E ; $994B
       .byte >LBC00 ; $994C
       .byte >LB83E ; $994D
       .byte >LB3A5 ; $994E
       .byte >LB3A5 ; $994F
       .byte >LBA20 ; $9950
       .byte >LB3A5 ; $9951
       .byte >LB3A5 ; $9952
;       .byte >LB3A5 ; $9953
;       .byte >LB3A5 ; $9954
L9A5F:
       .byte >LB3A5 ; $9A5F shared
       .byte >LB3A5 ; $9A60 shared
       .byte >LB2B4 ; $9A61
       .byte >LB3A5 ; $9A62
       .byte >LB3F4 ; $9A63
       .byte >LB3A5 ; $9A64
       .byte >LB7EF ; $9A65
       .byte >LB3A5 ; $9A66
       .byte >LB3A5 ; $9A67
       .byte >LB3A5 ; $9A68
       .byte >LB3A5 ; $9A69
       .byte >LB3A5 ; $9A6A
       .byte >LB3A5 ; $9A6B
       .byte >LBBEF ; $9A6C
       .byte >LB3A5 ; $9A6D
       .byte >LBB00 ; $9A6E
       .byte >LB3A5 ; $9A6F
       .byte >LB3A5 ; $9A70
       .byte >LB3A5 ; $9A71

L9EFA:
       .byte $55 ; | X X X X| $9EFA
       .byte $55 ; | X X X X| $9EFB
       .byte $55 ; | X X X X| $9EFC
       .byte $55 ; | X X X X| $9EFD
       .byte $55 ; | X X X X| $9EFE
       .byte $40 ; | X      | $9EFF
       .byte $56 ; | X X XX | $9F00
       .byte $40 ; | X      | $9F01
       .byte $55 ; | X X X X| $9F02
       .byte $40 ; | X      | $9F03
       .byte $56 ; | X X XX | $9F04
       .byte $40 ; | X      | $9F05
       .byte $55 ; | X X X X| $9F06
       .byte $40 ; | X      | $9F07
       .byte $56 ; | X X XX | $9F08
       .byte $40 ; | X      | $9F09
       .byte $55 ; | X X X X| $9F0A
       .byte $55 ; | X X X X| $9F0B
       .byte $55 ; | X X X X| $9F0C
       .byte $55 ; | X X X X| $9F0D
L9F0E:
       .byte $44 ; | X   X  | $9F0E
       .byte $40 ; | X      | $9F0F
       .byte $44 ; | X   X  | $9F10
       .byte $40 ; | X      | $9F11
       .byte $55 ; | X X X X| $9F12
       .byte $40 ; | X      | $9F13
       .byte $43 ; | X    XX| $9F14
       .byte $40 ; | X      | $9F15
       .byte $43 ; | X    XX| $9F16
       .byte $40 ; | X      | $9F17
       .byte $55 ; | X X X X| $9F18
       .byte $40 ; | X      | $9F19
       .byte $45 ; | X   X X| $9F1A
       .byte $40 ; | X      | $9F1B
       .byte $45 ; | X   X X| $9F1C
       .byte $40 ; | X      | $9F1D
       .byte $55 ; | X X X X| $9F1E
       .byte $40 ; | X      | $9F1F
       .byte $55 ; | X X X X| $9F20
       .byte $40 ; | X      | $9F21
       .byte $55 ; | X X X X| $9F22
       .byte $40 ; | X      | $9F23
       .byte $55 ; | X X X X| $9F24
       .byte $40 ; | X      | $9F25
       .byte $56 ; | X X XX | $9F26
       .byte $56 ; | X X XX | $9F27
       .byte $40 ; | X      | $9F28
       .byte $56 ; | X X XX | $9F29
       .byte $55 ; | X X X X| $9F2A
       .byte $55 ; | X X X X| $9F2B
       .byte $55 ; | X X X X| $9F2C
       .byte $55 ; | X X X X| $9F2D
       .byte $FF ; |XXXXXXXX| $9F2E

L9F2F:
       .byte $55 ; | X X X X| $9F2F
       .byte $40 ; | X      | $9F30
       .byte $56 ; | X X XX | $9F31
       .byte $40 ; | X      | $9F32
       .byte $55 ; | X X X X| $9F33
       .byte $40 ; | X      | $9F34
       .byte $56 ; | X X XX | $9F35
       .byte $40 ; | X      | $9F36
       .byte $55 ; | X X X X| $9F37
       .byte $40 ; | X      | $9F38
       .byte $56 ; | X X XX | $9F39
       .byte $40 ; | X      | $9F3A
       .byte $55 ; | X X X X| $9F3B
       .byte $55 ; | X X X X| $9F3C
       .byte $55 ; | X X X X| $9F3D
       .byte $55 ; | X X X X| $9F3E
       .byte $FF ; |XXXXXXXX| $9F3F

L9F40:
       .byte $89 ; |X   X  X| $9F40
       .byte $89 ; |X   X  X| $9F41
       .byte $EB ; |XXX X XX| $9F42
       .byte $C0 ; |XX      | $9F43
       .byte $4D ; | X  XX X| $9F44
       .byte $AC ; |X X XX  | $9F45
       .byte $8B ; |X   X XX| $9F46
       .byte $EC ; |XXX XX  | $9F47
       .byte $C0 ; |XX      | $9F48
       .byte $4F ; | X  XXXX| $9F49
       .byte $AD ; |X X XX X| $9F4A
       .byte $8C ; |X   XX  | $9F4B
       .byte $ED ; |XXX XX X| $9F4C
       .byte $C0 ; |XX      | $9F4D
       .byte $50 ; | X X    | $9F4E
       .byte $AF ; |X X XXXX| $9F4F
       .byte $8D ; |X   XX X| $9F50
       .byte $CF ; |XX  XXXX| $9F51
       .byte $8B ; |X   X XX| $9F52
       .byte $CF ; |XX  XXXX| $9F53
       .byte $84 ; |X    X  | $9F54
       .byte $87 ; |X    XXX| $9F55
       .byte $89 ; |X   X  X| $9F56
       .byte $EA ; |XXX X X | $9F57
       .byte $C0 ; |XX      | $9F58
       .byte $8A ; |X   X X | $9F59
       .byte $89 ; |X   X  X| $9F5A
       .byte $87 ; |X    XXX| $9F5B
       .byte $E9 ; |XXX X  X| $9F5C
       .byte $C0 ; |XX      | $9F5D
       .byte $89 ; |X   X  X| $9F5E
       .byte $87 ; |X    XXX| $9F5F
       .byte $85 ; |X    X X| $9F60
       .byte $E7 ; |XXX  XXX| $9F61
       .byte $E0 ; |XXX     | $9F62
       .byte $FF ; |XXXXXXXX| $9F63

L9F64:
       .byte $C0 ; |XX      | $9F64
L9F65:
       .byte $43 ; | X    XX| $9F65
       .byte $40 ; | X      | $9F66
       .byte $43 ; | X    XX| $9F67
       .byte $40 ; | X      | $9F68
       .byte $43 ; | X    XX| $9F69
       .byte $40 ; | X      | $9F6A
       .byte $43 ; | X    XX| $9F6B
       .byte $40 ; | X      | $9F6C
       .byte $43 ; | X    XX| $9F6D
       .byte $40 ; | X      | $9F6E
       .byte $80 ; |X       | $9F6F
       .byte $FF ; |XXXXXXXX| $9F70

L9F71:
       .byte $8B ; |X   X XX| $9F71
       .byte $8D ; |X   XX X| $9F72
       .byte $CF ; |XX  XXXX| $9F73
       .byte $CF ; |XX  XXXX| $9F74
       .byte $CF ; |XX  XXXX| $9F75
       .byte $CF ; |XX  XXXX| $9F76
       .byte $EB ; |XXX X XX| $9F77
       .byte $EC ; |XXX XX  | $9F78
       .byte $8F ; |X   XXXX| $9F79
       .byte $ED ; |XXX XX X| $9F7A
       .byte $C0 ; |XX      | $9F7B
       .byte $45 ; | X   X X| $9F7C
       .byte $45 ; | X   X X| $9F7D
       .byte $40 ; | X      | $9F7E
       .byte $45 ; | X   X X| $9F7F
       .byte $45 ; | X   X X| $9F80
       .byte $40 ; | X      | $9F81
       .byte $8C ; |X   XX  | $9F82
       .byte $EB ; |XXX X XX| $9F83
       .byte $EC ; |XXX XX  | $9F84
       .byte $83 ; |X     XX| $9F85
       .byte $ED ; |XXX XX X| $9F86
       .byte $C0 ; |XX      | $9F87
       .byte $45 ; | X   X X| $9F88
       .byte $45 ; | X   X X| $9F89
       .byte $40 ; | X      | $9F8A
       .byte $45 ; | X   X X| $9F8B
       .byte $45 ; | X   X X| $9F8C
       .byte $40 ; | X      | $9F8D
       .byte $8C ; |X   XX  | $9F8E
       .byte $EB ; |XXX X XX| $9F8F
       .byte $EC ; |XXX XX  | $9F90
       .byte $8F ; |X   XXXX| $9F91
       .byte $ED ; |XXX XX X| $9F92
       .byte $80 ; |X       | $9F93
       .byte $E0 ; |XXX     | $9F94
       .byte $8B ; |X   X XX| $9F95
       .byte $8D ; |X   XX X| $9F96
       .byte $CF ; |XX  XXXX| $9F97
       .byte $CF ; |XX  XXXX| $9F98
       .byte $CF ; |XX  XXXX| $9F99
       .byte $CF ; |XX  XXXX| $9F9A
       .byte $FF ; |XXXXXXXX| $9F9B

L9F9C:
       .byte $00 ; |        | $9F9C
       .byte $DF ; |XX XXXXX| $9F9D
       .byte $DD ; |XX XXX X| $9F9E
       .byte $DA ; |XX XX X | $9F9F
       .byte $D7 ; |XX X XXX| $9FA0
       .byte $D3 ; |XX X  XX| $9FA1
       .byte $D2 ; |XX X  X | $9FA2
       .byte $D1 ; |XX X   X| $9FA3
       .byte $D0 ; |XX X    | $9FA4
       .byte $CF ; |XX  XXXX| $9FA5
       .byte $CE ; |XX  XXX | $9FA6
       .byte $CB ; |XX  X XX| $9FA7
       .byte $5F ; | X XXXXX| $9FA8
       .byte $C9 ; |XX  X  X| $9FA9
       .byte $5B ; | X XX XX| $9FAA
       .byte $5A ; | X XX X | $9FAB
       .byte $C7 ; |XX   XXX| $9FAC
       .byte $54 ; | X X X  | $9FAD
       .byte $52 ; | X X  X | $9FAE
       .byte $C5 ; |XX   X X| $9FAF
       .byte $56 ; | X X XX | $9FB0
       .byte $84 ; |X    X  | $9FB1
       .byte $82 ; |X     X | $9FB2
L9FB3:
       .byte $01 ; |       X| $9FB3
       .byte $02 ; |      X | $9FB4
       .byte $03 ; |      XX| $9FB5
       .byte $05 ; |     X X| $9FB6
       .byte $07 ; |     XXX| $9FB7
       .byte $0B ; |    X XX| $9FB8
       .byte $0F ; |    XXXX| $9FB9
       .byte $17 ; |   X XXX| $9FBA

       ORG  $1FE5
       RORG $9FE5

       jmp    L93B9                   ;3 from 3

L9FD0:
       bit    BANK4                   ;4
       jmp    L94F7                   ;3 from 2

L9FDC:
       bit    BANK2                   ;4 @27

L9C6E:
       .byte $45 ; | X   X X| $9C6E
       .byte $40 ; | X      | $9C6F
       .byte $FF ; |XXXXXXXX| $9C70

       ORG  $1FF4
       RORG $9FF4
       jmp    L92D6                   ;3 from 3
       .word 0      ; $DFF7 - $DFF8
START1:
       jmp    START                   ;3 bankswitch to 4 and boot
       .word START1 ; $9FFC - $9FFD
       .word START1 ; $9FFE - $9FFF








       ORG  $2000
       RORG $B000

LB600:
       .byte COLOR1+8 ; |   XX   | $B600
       .byte COLORC+8 ; |XX  X   | $B601
       .byte COLOR0+4 ; |     X  | $B602
       .byte COLOR0+4 ; |     X  | $B603
       .byte COLORC+8 ; |XX  X   | $B604
       .byte COLOR0+4 ; |     X  | $B605
       .byte COLOR0+4 ; |     X  | $B606
       .byte COLORC+8 ; |XX  X   | $B607
       .byte COLOR0+4 ; |     X  | $B608
       .byte COLOR0+4 ; |     X  | $B609
       .byte COLORC+8 ; |XX  X   | $B60A
       .byte COLOR0+4 ; |     X  | $B60B
       .byte COLOR0+4 ; |     X  | $B60C
       .byte COLORC+8 ; |XX  X   | $B60D
       .byte COLOR0+4 ; |     X  | $B60E
       .byte COLOR0+4 ; |     X  | $B60F
       .byte COLORC+8 ; |XX  X   | $B610
       .byte COLOR0+4 ; |     X  | $B611
       .byte COLOR0+4 ; |     X  | $B612
       .byte COLORC+8 ; |XX  X   | $B613
       .byte COLOR0+4 ; |     X  | $B614
       .byte COLOR0+4 ; |     X  | $B615
       .byte COLORC+8 ; |XX  X   | $B616
       .byte COLOR0+4 ; |     X  | $B617
       .byte COLOR0+4 ; |     X  | $B618
       .byte COLORC+8 ; |XX  X   | $B619
       .byte COLOR0+4 ; |     X  | $B61A
       .byte COLOR0+4 ; |     X  | $B61B
       .byte COLORC+8 ; |XX  X   | $B61C
       .byte COLOR0+4 ; |     X  | $B61D
       .byte COLOR0+4 ; |     X  | $B61E
       .byte COLORC+8 ; |XX  X   | $B61F
       .byte COLOR0+4 ; |     X  | $B620
       .byte COLOR0+4 ; |     X  | $B621
       .byte COLORC+8 ; |XX  X   | $B622
       .byte COLOR0+4 ; |     X  | $B623
       .byte COLOR0+4 ; |     X  | $B624
       .byte COLORC+8 ; |XX  X   | $B625

LB626:
       .byte $00 ; |        | $B626
       .byte $70 ; | XXX    | $B627
       .byte $70 ; | XXX    | $B628
       .byte $70 ; | XXX    | $B629
       .byte $70 ; | XXX    | $B62A
       .byte $70 ; | XXX    | $B62B
       .byte $70 ; | XXX    | $B62C
       .byte $70 ; | XXX    | $B62D
       .byte $70 ; | XXX    | $B62E
       .byte $70 ; | XXX    | $B62F
       .byte $70 ; | XXX    | $B630
       .byte $70 ; | XXX    | $B631
       .byte $70 ; | XXX    | $B632
       .byte $70 ; | XXX    | $B633
       .byte $70 ; | XXX    | $B634
       .byte $70 ; | XXX    | $B635
       .byte $C0 ; |XX      | $B636
       .byte $C0 ; |XX      | $B637
       .byte $C0 ; |XX      | $B638
       .byte $C0 ; |XX      | $B639
       .byte $C0 ; |XX      | $B63A
       .byte $C0 ; |XX      | $B63B
       .byte $C0 ; |XX      | $B63C
       .byte $C0 ; |XX      | $B63D
       .byte $C0 ; |XX      | $B63E
       .byte $C0 ; |XX      | $B63F
       .byte $C0 ; |XX      | $B640
       .byte $C0 ; |XX      | $B641
       .byte $C0 ; |XX      | $B642
       .byte $C0 ; |XX      | $B643
       .byte $C0 ; |XX      | $B644
       .byte $00 ; |        | $B645
       .byte $00 ; |        | $B646
       .byte $00 ; |        | $B647
       .byte $00 ; |        | $B648
       .byte $00 ; |        | $B649
       .byte $00 ; |        | $B64A
       .byte $00 ; |        | $B64B

LB64C:
       .byte $00 ; |        | $B64C
       .byte $EE ; |XXX XXX | $B64D
       .byte $EE ; |XXX XXX | $B64E
       .byte $EE ; |XXX XXX | $B64F
       .byte $EE ; |XXX XXX | $B650
       .byte $EE ; |XXX XXX | $B651
       .byte $EE ; |XXX XXX | $B652
       .byte $EE ; |XXX XXX | $B653
       .byte $EE ; |XXX XXX | $B654
       .byte $EE ; |XXX XXX | $B655
       .byte $EE ; |XXX XXX | $B656
       .byte $EE ; |XXX XXX | $B657
       .byte $EE ; |XXX XXX | $B658
       .byte $EE ; |XXX XXX | $B659
       .byte $EE ; |XXX XXX | $B65A
       .byte $EE ; |XXX XXX | $B65B
       .byte $B8 ; |X XXX   | $B65C
       .byte $B8 ; |X XXX   | $B65D
       .byte $B8 ; |X XXX   | $B65E
       .byte $B8 ; |X XXX   | $B65F
       .byte $B8 ; |X XXX   | $B660
       .byte $B8 ; |X XXX   | $B661
       .byte $B8 ; |X XXX   | $B662
       .byte $B8 ; |X XXX   | $B663
       .byte $B8 ; |X XXX   | $B664
       .byte $B8 ; |X XXX   | $B665
       .byte $B8 ; |X XXX   | $B666
       .byte $B8 ; |X XXX   | $B667
       .byte $B8 ; |X XXX   | $B668
       .byte $B8 ; |X XXX   | $B669
       .byte $B8 ; |X XXX   | $B66A
       .byte $00 ; |        | $B66B
       .byte $00 ; |        | $B66C
       .byte $00 ; |        | $B66D
       .byte $00 ; |        | $B66E
       .byte $00 ; |        | $B66F
       .byte $00 ; |        | $B670
       .byte $00 ; |        | $B671

LB672:
       .byte COLOR8+6 ; |X    XX | $B672
       .byte COLOR7+4 ; | XXX X  | $B673
       .byte COLOR7+4 ; | XXX X  | $B674
       .byte COLOR7+4 ; | XXX X  | $B675
       .byte COLOR7+4 ; | XXX X  | $B676
       .byte COLOR7+4 ; | XXX X  | $B677
       .byte COLOR7+4 ; | XXX X  | $B678
       .byte COLOR7+4 ; | XXX X  | $B679
       .byte COLOR7+4 ; | XXX X  | $B67A
       .byte COLOR7+4 ; | XXX X  | $B67B
       .byte COLOR7+4 ; | XXX X  | $B67C
       .byte COLOR7+4 ; | XXX X  | $B67D
       .byte COLOR7+4 ; | XXX X  | $B67E
       .byte COLOR7+4 ; | XXX X  | $B67F
       .byte COLOR7+4 ; | XXX X  | $B680
       .byte COLOR7+4 ; | XXX X  | $B681
       .byte COLOR7+4 ; | XXX X  | $B682
       .byte COLOR7+4 ; | XXX X  | $B683
       .byte COLOR7+4 ; | XXX X  | $B684
       .byte COLOR7+4 ; | XXX X  | $B685
       .byte COLOR7+4 ; | XXX X  | $B686
       .byte COLOR7+4 ; | XXX X  | $B687
       .byte COLOR7+4 ; | XXX X  | $B688
       .byte COLOR7+4 ; | XXX X  | $B689
       .byte COLOR7+4 ; | XXX X  | $B68A
       .byte COLOR7+4 ; | XXX X  | $B68B
       .byte COLOR7+4 ; | XXX X  | $B68C
       .byte COLOR7+4 ; | XXX X  | $B68D
       .byte COLOR7+4 ; | XXX X  | $B68E
       .byte COLOR7+4 ; | XXX X  | $B68F
       .byte COLOR7+4 ; | XXX X  | $B690
       .byte COLOR7+4 ; | XXX X  | $B691
       .byte COLOR7+4 ; | XXX X  | $B692
       .byte COLOR7+4 ; | XXX X  | $B693
       .byte COLOR7+4 ; | XXX X  | $B694
       .byte COLOR7+4 ; | XXX X  | $B695
       .byte COLOR7+2 ; | XXX  X | $B696
       .byte COLOR7+2 ; | XXX  X | $B697

LB698:
       .byte $00 ; |        | $B698
       .byte $00 ; |        | $B699
       .byte $FF ; |XXXXXXXX| $B69A
       .byte $FF ; |XXXXXXXX| $B69B
       .byte $FF ; |XXXXXXXX| $B69C
       .byte $FF ; |XXXXXXXX| $B69D
       .byte $FF ; |XXXXXXXX| $B69E
       .byte $00 ; |        | $B69F
       .byte $00 ; |        | $B6A0
       .byte $FF ; |XXXXXXXX| $B6A1
       .byte $FF ; |XXXXXXXX| $B6A2
       .byte $FF ; |XXXXXXXX| $B6A3
       .byte $FF ; |XXXXXXXX| $B6A4
       .byte $FF ; |XXXXXXXX| $B6A5
       .byte $00 ; |        | $B6A6
       .byte $00 ; |        | $B6A7
       .byte $FF ; |XXXXXXXX| $B6A8
       .byte $FF ; |XXXXXXXX| $B6A9
       .byte $FF ; |XXXXXXXX| $B6AA
       .byte $FF ; |XXXXXXXX| $B6AB
       .byte $FF ; |XXXXXXXX| $B6AC
       .byte $FF ; |XXXXXXXX| $B6AD
       .byte $00 ; |        | $B6AE
       .byte $00 ; |        | $B6AF
       .byte $FF ; |XXXXXXXX| $B6B0
       .byte $FF ; |XXXXXXXX| $B6B1
       .byte $FF ; |XXXXXXXX| $B6B2
       .byte $FF ; |XXXXXXXX| $B6B3
       .byte $FF ; |XXXXXXXX| $B6B4
       .byte $00 ; |        | $B6B5
       .byte $00 ; |        | $B6B6
       .byte $FF ; |XXXXXXXX| $B6B7
       .byte $FF ; |XXXXXXXX| $B6B8
       .byte $FF ; |XXXXXXXX| $B6B9
       .byte $FF ; |XXXXXXXX| $B6BA
       .byte $FF ; |XXXXXXXX| $B6BB
       .byte $00 ; |        | $B6BC
       .byte $00 ; |        | $B6BD

LB6BE:
       .byte $00 ; |        | $B6BE
       .byte $00 ; |        | $B6BF
       .byte $3C ; |  XXXX  | $B6C0
       .byte $3C ; |  XXXX  | $B6C1
       .byte $3C ; |  XXXX  | $B6C2
       .byte $3C ; |  XXXX  | $B6C3
       .byte $3C ; |  XXXX  | $B6C4
       .byte $3C ; |  XXXX  | $B6C5
       .byte $3C ; |  XXXX  | $B6C6
       .byte $3C ; |  XXXX  | $B6C7
       .byte $3C ; |  XXXX  | $B6C8
       .byte $3C ; |  XXXX  | $B6C9
       .byte $3C ; |  XXXX  | $B6CA
       .byte $3C ; |  XXXX  | $B6CB
       .byte $3C ; |  XXXX  | $B6CC
       .byte $3C ; |  XXXX  | $B6CD
       .byte $3C ; |  XXXX  | $B6CE
       .byte $3C ; |  XXXX  | $B6CF
       .byte $3C ; |  XXXX  | $B6D0
       .byte $3C ; |  XXXX  | $B6D1
       .byte $3C ; |  XXXX  | $B6D2
       .byte $3C ; |  XXXX  | $B6D3
       .byte $3C ; |  XXXX  | $B6D4
       .byte $3C ; |  XXXX  | $B6D5
       .byte $3C ; |  XXXX  | $B6D6
       .byte $3C ; |  XXXX  | $B6D7
       .byte $18 ; |   XX   | $B6D8
       .byte $00 ; |        | $B6D9
       .byte $00 ; |        | $B6DA
       .byte $00 ; |        | $B6DB
       .byte $00 ; |        | $B6DC
       .byte $00 ; |        | $B6DD
       .byte $00 ; |        | $B6DE
       .byte $00 ; |        | $B6DF
       .byte $00 ; |        | $B6E0
       .byte $00 ; |        | $B6E1
       .byte $00 ; |        | $B6E2
       .byte $00 ; |        | $B6E3

LB6E4:
       .byte $FF ; |XXXXXXXX| $B6E4
       .byte $00 ; |        | $B6E5
       .byte $00 ; |        | $B6E6
       .byte $FF ; |XXXXXXXX| $B6E7
       .byte $FF ; |XXXXXXXX| $B6E8
       .byte $FF ; |XXXXXXXX| $B6E9
       .byte $FF ; |XXXXXXXX| $B6EA
       .byte $FF ; |XXXXXXXX| $B6EB
       .byte $00 ; |        | $B6EC
       .byte $00 ; |        | $B6ED
       .byte $FF ; |XXXXXXXX| $B6EE
LB6EF:
       .byte $24 ; |  X  X  | $B6EF
       .byte $24 ; |  X  X  | $B6F0
       .byte $24 ; |  X  X  | $B6F1
       .byte $24 ; |  X  X  | $B6F2
       .byte $24 ; |  X  X  | $B6F3
       .byte $24 ; |  X  X  | $B6F4
       .byte $24 ; |  X  X  | $B6F5
       .byte $24 ; |  X  X  | $B6F6
       .byte $24 ; |  X  X  | $B6F7
       .byte $24 ; |  X  X  | $B6F8
       .byte $24 ; |  X  X  | $B6F9
       .byte $00 ; |        | $B6FA
       .byte $00 ; |        | $B6FB
       .byte $00 ; |        | $B6FC
       .byte $00 ; |        | $B6FD
       .byte $00 ; |        | $B6FE
       .byte $00 ; |        | $B6FF

       ORG  $2100
       RORG $B100

LB700:
       .byte $00 ; |        | $B700
       .byte $C3 ; |XX    XX| $B701
       .byte $76 ; | XXX XX | $B702
       .byte $7C ; | XXXXX  | $B703
       .byte $7C ; | XXXXX  | $B704
       .byte $DE ; |XX XXXX | $B705
       .byte $FC ; |XXXXXX  | $B706
       .byte $7C ; | XXXXX  | $B707
       .byte $7C ; | XXXXX  | $B708
       .byte $7C ; | XXXXX  | $B709
       .byte $6E ; | XX XXX | $B70A
       .byte $7E ; | XXXXXX | $B70B
       .byte $7C ; | XXXXX  | $B70C
       .byte $7C ; | XXXXX  | $B70D
       .byte $7C ; | XXXXX  | $B70E
       .byte $7C ; | XXXXX  | $B70F
       .byte $3C ; |  XXXX  | $B710
       .byte $3C ; |  XXXX  | $B711
       .byte $7E ; | XXXXXX | $B712
       .byte $7C ; | XXXXX  | $B713
       .byte $7C ; | XXXXX  | $B714
       .byte $7C ; | XXXXX  | $B715
       .byte $74 ; | XXX X  | $B716
       .byte $7C ; | XXXXX  | $B717
       .byte $FC ; |XXXXXX  | $B718
       .byte $FC ; |XXXXXX  | $B719
       .byte $DC ; |XX XXX  | $B71A
       .byte $5C ; | X XXX  | $B71B
       .byte $7C ; | XXXXX  | $B71C
       .byte $7C ; | XXXXX  | $B71D
       .byte $7C ; | XXXXX  | $B71E
       .byte $7C ; | XXXXX  | $B71F
       .byte $7C ; | XXXXX  | $B720
       .byte $3C ; |  XXXX  | $B721
       .byte $3C ; |  XXXX  | $B722
       .byte $78 ; | XXXX   | $B723
       .byte $7C ; | XXXXX  | $B724
       .byte $66 ; | XX  XX | $B725

LB726:
       .byte COLOR0+0 ; |        | $B726
       .byte $24 ; |  X  X  | $B727
       .byte $24 ; |  X  X  | $B728
       .byte $24 ; |  X  X  | $B729
       .byte $24 ; |  X  X  | $B72A
       .byte $24 ; |  X  X  | $B72B
       .byte $24 ; |  X  X  | $B72C
       .byte $24 ; |  X  X  | $B72D
       .byte $24 ; |  X  X  | $B72E
       .byte $24 ; |  X  X  | $B72F
       .byte $24 ; |  X  X  | $B730
       .byte $24 ; |  X  X  | $B731
       .byte $24 ; |  X  X  | $B732
       .byte $24 ; |  X  X  | $B733
       .byte $24 ; |  X  X  | $B734
       .byte $24 ; |  X  X  | $B735
       .byte $24 ; |  X  X  | $B736
       .byte $24 ; |  X  X  | $B737
       .byte $24 ; |  X  X  | $B738
       .byte $24 ; |  X  X  | $B739
       .byte $24 ; |  X  X  | $B73A
       .byte $24 ; |  X  X  | $B73B
       .byte $24 ; |  X  X  | $B73C
       .byte $24 ; |  X  X  | $B73D
       .byte $24 ; |  X  X  | $B73E
       .byte $24 ; |  X  X  | $B73F
       .byte $24 ; |  X  X  | $B740
       .byte $24 ; |  X  X  | $B741
       .byte $24 ; |  X  X  | $B742
       .byte $24 ; |  X  X  | $B743
       .byte $24 ; |  X  X  | $B744
       .byte $24 ; |  X  X  | $B745
       .byte $24 ; |  X  X  | $B746
       .byte $24 ; |  X  X  | $B747
       .byte $24 ; |  X  X  | $B748
       .byte $24 ; |  X  X  | $B749
       .byte $24 ; |  X  X  | $B74A
       .byte $24 ; |  X  X  | $B74B

LB74C:
       .byte COLOR0+6 ; |     XX | $B74C
       .byte COLOR0+2 ; |      X | $B74D
       .byte COLOR0+2 ; |      X | $B74E
       .byte COLOR0+2 ; |      X | $B74F
       .byte COLOR0+2 ; |      X | $B750
       .byte COLOR0+2 ; |      X | $B751
       .byte COLOR0+2 ; |      X | $B752
       .byte COLOR0+2 ; |      X | $B753
       .byte COLOR0+2 ; |      X | $B754
       .byte COLOR0+2 ; |      X | $B755
       .byte COLOR0+2 ; |      X | $B756
       .byte COLOR0+2 ; |      X | $B757
       .byte COLOR0+2 ; |      X | $B758
       .byte COLOR0+2 ; |      X | $B759
       .byte COLOR0+2 ; |      X | $B75A
       .byte COLOR0+2 ; |      X | $B75B
       .byte COLOR0+2 ; |      X | $B75C
       .byte COLOR0+2 ; |      X | $B75D
       .byte COLOR0+2 ; |      X | $B75E
       .byte COLOR0+2 ; |      X | $B75F
       .byte COLOR0+2 ; |      X | $B760
       .byte COLOR0+2 ; |      X | $B761
       .byte COLOR0+2 ; |      X | $B762
       .byte COLOR0+2 ; |      X | $B763
       .byte COLOR0+2 ; |      X | $B764
       .byte COLOR0+2 ; |      X | $B765
       .byte COLOR0+2 ; |      X | $B766
       .byte COLOR0+2 ; |      X | $B767
       .byte COLOR0+2 ; |      X | $B768
       .byte COLOR0+2 ; |      X | $B769
       .byte COLOR0+2 ; |      X | $B76A
       .byte COLOR0+2 ; |      X | $B76B
       .byte COLOR0+2 ; |      X | $B76C
       .byte COLOR0+2 ; |      X | $B76D
       .byte COLOR0+2 ; |      X | $B76E
       .byte COLOR0+2 ; |      X | $B76F
       .byte COLOR0+2 ; |      X | $B770
       .byte COLOR0+2 ; |      X | $B771
LB772:
       .byte COLOR2+0 ; |  X     | $B772
       .byte COLOR2+0 ; |  X     | $B773
       .byte COLOR2+0 ; |  X     | $B774
       .byte COLOR2+0 ; |  X     | $B775
       .byte COLOR2+0 ; |  X     | $B776
       .byte COLOR2+0 ; |  X     | $B777
       .byte COLOR2+0 ; |  X     | $B778
       .byte COLOR2+0 ; |  X     | $B779
       .byte COLOR2+0 ; |  X     | $B77A
       .byte COLOR2+0 ; |  X     | $B77B
       .byte COLOR2+0 ; |  X     | $B77C
       .byte COLOR2+0 ; |  X     | $B77D
       .byte COLOR2+0 ; |  X     | $B77E
       .byte COLOR2+0 ; |  X     | $B77F
       .byte COLOR2+0 ; |  X     | $B780
       .byte COLOR2+0 ; |  X     | $B781
       .byte COLOR2+0 ; |  X     | $B782
       .byte COLOR2+0 ; |  X     | $B783
       .byte COLOR2+0 ; |  X     | $B784
       .byte COLOR2+0 ; |  X     | $B785
       .byte COLOR2+0 ; |  X     | $B786
       .byte COLOR2+0 ; |  X     | $B787
       .byte COLOR2+0 ; |  X     | $B788
       .byte COLOR2+0 ; |  X     | $B789
       .byte COLOR2+0 ; |  X     | $B78A
       .byte COLOR2+0 ; |  X     | $B78B
       .byte COLOR2+0 ; |  X     | $B78C
       .byte COLOR0+2 ; |      X | $B78D
       .byte COLOR0+2 ; |      X | $B78E
       .byte COLOR0+2 ; |      X | $B78F
       .byte COLOR0+2 ; |      X | $B790
       .byte COLOR0+2 ; |      X | $B791
       .byte COLOR0+2 ; |      X | $B792
       .byte COLOR0+2 ; |      X | $B793
       .byte COLOR0+2 ; |      X | $B794
       .byte COLOR0+2 ; |      X | $B795
       .byte COLOR0+2 ; |      X | $B796
       .byte COLOR0+2 ; |      X | $B797
LB798:
       .byte COLOR1+2 ; |   X  X | $B798
       .byte COLOR1+2 ; |   X  X | $B799
       .byte COLOR1+2 ; |   X  X | $B79A
       .byte COLOR1+2 ; |   X  X | $B79B
       .byte COLOR1+2 ; |   X  X | $B79C
       .byte COLOR1+2 ; |   X  X | $B79D
       .byte COLOR1+2 ; |   X  X | $B79E
       .byte COLOR1+2 ; |   X  X | $B79F
       .byte COLOR1+2 ; |   X  X | $B7A0
       .byte COLOR1+2 ; |   X  X | $B7A1
       .byte COLOR1+2 ; |   X  X | $B7A2
       .byte COLOR1+2 ; |   X  X | $B7A3
       .byte COLOR1+2 ; |   X  X | $B7A4
       .byte COLOR1+2 ; |   X  X | $B7A5
       .byte COLOR1+2 ; |   X  X | $B7A6
       .byte COLOR1+2 ; |   X  X | $B7A7
       .byte COLOR1+2 ; |   X  X | $B7A8
       .byte COLOR1+2 ; |   X  X | $B7A9
       .byte COLOR1+2 ; |   X  X | $B7AA
       .byte COLOR1+2 ; |   X  X | $B7AB
       .byte COLOR1+2 ; |   X  X | $B7AC
       .byte COLOR1+2 ; |   X  X | $B7AD
       .byte COLOR1+2 ; |   X  X | $B7AE
       .byte COLOR1+2 ; |   X  X | $B7AF
       .byte COLOR1+2 ; |   X  X | $B7B0
       .byte COLOR1+2 ; |   X  X | $B7B1
       .byte COLOR1+2 ; |   X  X | $B7B2
       .byte COLOR1+2 ; |   X  X | $B7B3
       .byte COLOR1+2 ; |   X  X | $B7B4
       .byte COLOR1+2 ; |   X  X | $B7B5
       .byte COLOR1+2 ; |   X  X | $B7B6
       .byte COLOR1+2 ; |   X  X | $B7B7
       .byte COLOR1+2 ; |   X  X | $B7B8
       .byte COLOR1+2 ; |   X  X | $B7B9
       .byte COLOR1+2 ; |   X  X | $B7BA
       .byte COLOR1+2 ; |   X  X | $B7BB
       .byte COLOR1+2 ; |   X  X | $B7BC
       .byte COLOR1+2 ; |   X  X | $B7BD
LB7BE:
       .byte $00 ; |        | $B7BE
       .byte $30 ; |  XX    | $B7BF
       .byte $30 ; |  XX    | $B7C0
       .byte $30 ; |  XX    | $B7C1
       .byte $30 ; |  XX    | $B7C2
       .byte $30 ; |  XX    | $B7C3
       .byte $30 ; |  XX    | $B7C4
       .byte $30 ; |  XX    | $B7C5
       .byte $30 ; |  XX    | $B7C6
       .byte $30 ; |  XX    | $B7C7
LB7C8:
       .byte $30 ; |  XX    | $B7C8
       .byte $30 ; |  XX    | $B7C9
       .byte $30 ; |  XX    | $B7CA
       .byte $30 ; |  XX    | $B7CB
       .byte $30 ; |  XX    | $B7CC
       .byte $30 ; |  XX    | $B7CD
       .byte $30 ; |  XX    | $B7CE
       .byte $30 ; |  XX    | $B7CF
       .byte $30 ; |  XX    | $B7D0
       .byte $30 ; |  XX    | $B7D1
       .byte $30 ; |  XX    | $B7D2
       .byte $30 ; |  XX    | $B7D3
       .byte $30 ; |  XX    | $B7D4
       .byte $30 ; |  XX    | $B7D5
       .byte $30 ; |  XX    | $B7D6
       .byte $30 ; |  XX    | $B7D7
       .byte $30 ; |  XX    | $B7D8
       .byte $30 ; |  XX    | $B7D9
       .byte $30 ; |  XX    | $B7DA
       .byte $30 ; |  XX    | $B7DB
       .byte $30 ; |  XX    | $B7DC
       .byte $30 ; |  XX    | $B7DD
       .byte $30 ; |  XX    | $B7DE
       .byte $30 ; |  XX    | $B7DF
       .byte $30 ; |  XX    | $B7E0
       .byte $30 ; |  XX    | $B7E1
       .byte $30 ; |  XX    | $B7E2
       .byte $30 ; |  XX    | $B7E3
LB7E4:
       .byte $00 ; |        | $B7E4
       .byte $00 ; |        | $B7E5
       .byte $00 ; |        | $B7E6
       .byte $00 ; |        | $B7E7
       .byte $00 ; |        | $B7E8
       .byte $00 ; |        | $B7E9
       .byte $00 ; |        | $B7EA
       .byte $00 ; |        | $B7EB
       .byte $08 ; |    X   | $B7EC
       .byte $06 ; |     XX | $B7ED
       .byte $08 ; |    X   | $B7EE
LB7EF:
       .byte $02 ; |      X | $B7EF
       .byte $02 ; |      X | $B7F0
       .byte $02 ; |      X | $B7F1
       .byte $02 ; |      X | $B7F2
       .byte $02 ; |      X | $B7F3
       .byte $02 ; |      X | $B7F4
       .byte $02 ; |      X | $B7F5
       .byte $02 ; |      X | $B7F6
       .byte $02 ; |      X | $B7F7
       .byte $02 ; |      X | $B7F8
       .byte $02 ; |      X | $B7F9
       .byte $00 ; |        | $B7FA
       .byte $00 ; |        | $B7FB
       .byte $00 ; |        | $B7FC
       .byte $00 ; |        | $B7FD
       .byte $00 ; |        | $B7FE
       .byte $00 ; |        | $B7FF

       ORG  $2200
       RORG $B200

LB200:
       .byte $00 ; |        | $B200
       .byte $FF ; |XXXXXXXX| $B201
       .byte $FF ; |XXXXXXXX| $B202
       .byte $FF ; |XXXXXXXX| $B203
       .byte $FF ; |XXXXXXXX| $B204
       .byte $FF ; |XXXXXXXX| $B205
       .byte $FF ; |XXXXXXXX| $B206
       .byte $FF ; |XXXXXXXX| $B207
       .byte $FF ; |XXXXXXXX| $B208
       .byte $FF ; |XXXXXXXX| $B209
       .byte $FF ; |XXXXXXXX| $B20A
       .byte $FF ; |XXXXXXXX| $B20B
       .byte $FF ; |XXXXXXXX| $B20C
       .byte $FF ; |XXXXXXXX| $B20D
       .byte $FF ; |XXXXXXXX| $B20E
       .byte $FF ; |XXXXXXXX| $B20F
       .byte $FF ; |XXXXXXXX| $B210
       .byte $FF ; |XXXXXXXX| $B211
       .byte $FF ; |XXXXXXXX| $B212
       .byte $FF ; |XXXXXXXX| $B213
       .byte $FF ; |XXXXXXXX| $B214
       .byte $FF ; |XXXXXXXX| $B215
       .byte $FF ; |XXXXXXXX| $B216
       .byte $FF ; |XXXXXXXX| $B217
       .byte $FF ; |XXXXXXXX| $B218
       .byte $FF ; |XXXXXXXX| $B219
       .byte $FF ; |XXXXXXXX| $B21A
       .byte $00 ; |        | $B21B
       .byte $00 ; |        | $B21C
       .byte $00 ; |        | $B21D
       .byte $00 ; |        | $B21E
       .byte $00 ; |        | $B21F
       .byte $00 ; |        | $B220
       .byte $00 ; |        | $B221
       .byte $00 ; |        | $B222
       .byte $00 ; |        | $B223
       .byte $00 ; |        | $B224
LB225:
       .byte $00 ; |        | $B225
       .byte $FF ; |XXXXXXXX| $B226
       .byte $FF ; |XXXXXXXX| $B227
       .byte $FF ; |XXXXXXXX| $B228
       .byte $FF ; |XXXXXXXX| $B229
       .byte $FF ; |XXXXXXXX| $B22A
       .byte $FF ; |XXXXXXXX| $B22B
       .byte $FF ; |XXXXXXXX| $B22C
       .byte $FF ; |XXXXXXXX| $B22D
       .byte $FF ; |XXXXXXXX| $B22E
       .byte $FF ; |XXXXXXXX| $B22F
       .byte $FF ; |XXXXXXXX| $B230
       .byte $FF ; |XXXXXXXX| $B231
       .byte $FF ; |XXXXXXXX| $B232
       .byte $FF ; |XXXXXXXX| $B233
       .byte $FF ; |XXXXXXXX| $B234
       .byte $FF ; |XXXXXXXX| $B235
       .byte $FF ; |XXXXXXXX| $B236
       .byte $FF ; |XXXXXXXX| $B237
       .byte $FF ; |XXXXXXXX| $B238
       .byte $FF ; |XXXXXXXX| $B239
       .byte $FF ; |XXXXXXXX| $B23A
       .byte $FF ; |XXXXXXXX| $B23B
       .byte $FF ; |XXXXXXXX| $B23C
       .byte $FF ; |XXXXXXXX| $B23D
       .byte $FF ; |XXXXXXXX| $B23E
       .byte $FF ; |XXXXXXXX| $B23F
       .byte $FF ; |XXXXXXXX| $B240
       .byte $FF ; |XXXXXXXX| $B241
       .byte $FF ; |XXXXXXXX| $B242
       .byte $FF ; |XXXXXXXX| $B243
       .byte $FF ; |XXXXXXXX| $B244
       .byte $FF ; |XXXXXXXX| $B245
       .byte $FF ; |XXXXXXXX| $B246
       .byte $FF ; |XXXXXXXX| $B247
       .byte $FF ; |XXXXXXXX| $B248
       .byte $FF ; |XXXXXXXX| $B249
LB24A:
       .byte $00 ; |        | $B24A
       .byte $FF ; |XXXXXXXX| $B24B
       .byte $FF ; |XXXXXXXX| $B24C
       .byte $FF ; |XXXXXXXX| $B24D
       .byte $FF ; |XXXXXXXX| $B24E
       .byte $FF ; |XXXXXXXX| $B24F
       .byte $FF ; |XXXXXXXX| $B250
       .byte $FF ; |XXXXXXXX| $B251
       .byte $FF ; |XXXXXXXX| $B252
       .byte $FF ; |XXXXXXXX| $B253
       .byte $FF ; |XXXXXXXX| $B254
       .byte $FF ; |XXXXXXXX| $B255
       .byte $FF ; |XXXXXXXX| $B256
       .byte $FF ; |XXXXXXXX| $B257
       .byte $FF ; |XXXXXXXX| $B258
       .byte $FF ; |XXXXXXXX| $B259
       .byte $FF ; |XXXXXXXX| $B25A
       .byte $FF ; |XXXXXXXX| $B25B
       .byte $FF ; |XXXXXXXX| $B25C
       .byte $FF ; |XXXXXXXX| $B25D
       .byte $FF ; |XXXXXXXX| $B25E
       .byte $FF ; |XXXXXXXX| $B25F
       .byte $FF ; |XXXXXXXX| $B260
       .byte $FF ; |XXXXXXXX| $B261
       .byte $FF ; |XXXXXXXX| $B262
       .byte $FF ; |XXXXXXXX| $B263
       .byte $FF ; |XXXXXXXX| $B264
       .byte $FF ; |XXXXXXXX| $B265
       .byte $FF ; |XXXXXXXX| $B266
       .byte $FF ; |XXXXXXXX| $B267
       .byte $FF ; |XXXXXXXX| $B268
       .byte $FF ; |XXXXXXXX| $B269
       .byte $FF ; |XXXXXXXX| $B26A
       .byte $FF ; |XXXXXXXX| $B26B
       .byte $FF ; |XXXXXXXX| $B26C
       .byte $FF ; |XXXXXXXX| $B26D
       .byte $FF ; |XXXXXXXX| $B26E
       .byte $FF ; |XXXXXXXX| $B26F
LB270:
       .byte $00 ; |        | $B270
       .byte $84 ; |X    X  | $B271
       .byte $84 ; |X    X  | $B272
       .byte $84 ; |X    X  | $B273
       .byte $84 ; |X    X  | $B274
       .byte $84 ; |X    X  | $B275
       .byte $FC ; |XXXXXX  | $B276
       .byte $84 ; |X    X  | $B277
       .byte $84 ; |X    X  | $B278
       .byte $84 ; |X    X  | $B279
       .byte $84 ; |X    X  | $B27A
       .byte $FC ; |XXXXXX  | $B27B
       .byte $84 ; |X    X  | $B27C
       .byte $84 ; |X    X  | $B27D
       .byte $84 ; |X    X  | $B27E
       .byte $84 ; |X    X  | $B27F
       .byte $FC ; |XXXXXX  | $B280
       .byte $84 ; |X    X  | $B281
       .byte $84 ; |X    X  | $B282
       .byte $84 ; |X    X  | $B283
       .byte $84 ; |X    X  | $B284
       .byte $FC ; |XXXXXX  | $B285
       .byte $84 ; |X    X  | $B286
       .byte $84 ; |X    X  | $B287
       .byte $84 ; |X    X  | $B288
       .byte $84 ; |X    X  | $B289
       .byte $FC ; |XXXXXX  | $B28A
       .byte $84 ; |X    X  | $B28B
       .byte $84 ; |X    X  | $B28C
       .byte $84 ; |X    X  | $B28D
       .byte $84 ; |X    X  | $B28E
       .byte $FC ; |XXXXXX  | $B28F
       .byte $84 ; |X    X  | $B290
       .byte $84 ; |X    X  | $B291
       .byte $84 ; |X    X  | $B292
       .byte $A5 ; |X X  X X| $B293
       .byte $42 ; | X    X | $B294
       .byte $00 ; |        | $B295
LB296:
       .byte $00 ; |        | $B296
       .byte $00 ; |        | $B297
       .byte $00 ; |        | $B298
       .byte $FF ; |XXXXXXXX| $B299
       .byte $FF ; |XXXXXXXX| $B29A
       .byte $FF ; |XXXXXXXX| $B29B
       .byte $FF ; |XXXXXXXX| $B29C
       .byte $FF ; |XXXXXXXX| $B29D
       .byte $FF ; |XXXXXXXX| $B29E
       .byte $FF ; |XXXXXXXX| $B29F
       .byte $FF ; |XXXXXXXX| $B2A0
LB2A1:
       .byte $00 ; |        | $B2A1
       .byte $40 ; | X      | $B2A2
       .byte $20 ; |  X     | $B2A3
       .byte $10 ; |   X    | $B2A4
       .byte $08 ; |    X   | $B2A5
       .byte $04 ; |     X  | $B2A6
       .byte $02 ; |      X | $B2A7
       .byte $01 ; |       X| $B2A8
LB2A9:
       .byte $00 ; |        | $B2A9
       .byte $00 ; |        | $B2AA
       .byte $00 ; |        | $B2AB
       .byte $00 ; |        | $B2AC
       .byte $00 ; |        | $B2AD
       .byte $00 ; |        | $B2AE
       .byte $00 ; |        | $B2AF
       .byte $00 ; |        | $B2B0
       .byte $08 ; |    X   | $B2B1
       .byte $06 ; |     XX | $B2B2
       .byte $08 ; |    X   | $B2B3
LB2B4:
       .byte $02 ; |      X | $B2B4
       .byte $02 ; |      X | $B2B5
       .byte $02 ; |      X | $B2B6
       .byte $02 ; |      X | $B2B7
       .byte $02 ; |      X | $B2B8
       .byte $02 ; |      X | $B2B9
       .byte $02 ; |      X | $B2BA
       .byte $02 ; |      X | $B2BB
       .byte $02 ; |      X | $B2BC
       .byte $02 ; |      X | $B2BD
LB2BE:
       .byte $00 ; |        | $B2BE
       .byte $7B ; | XXXX XX| $B2BF
       .byte $7B ; | XXXX XX| $B2C0
       .byte $69 ; | XX X  X| $B2C1
       .byte $69 ; | XX X  X| $B2C2
       .byte $69 ; | XX X  X| $B2C3
       .byte $60 ; | XX     | $B2C4
       .byte $60 ; | XX     | $B2C5
       .byte $00 ; |        | $B2C6
       .byte $00 ; |        | $B2C7
LB2C8:
       .byte $00 ; |        | $B2C8
       .byte $01 ; |       X| $B2C9
       .byte $03 ; |      XX| $B2CA
       .byte $03 ; |      XX| $B2CB
       .byte $03 ; |      XX| $B2CC
       .byte $03 ; |      XX| $B2CD
       .byte $03 ; |      XX| $B2CE
       .byte $03 ; |      XX| $B2CF
       .byte $03 ; |      XX| $B2D0
       .byte $03 ; |      XX| $B2D1
       .byte $03 ; |      XX| $B2D2
LB2D3:
       .byte COLOR0+2 ; |      X | $B2D3
       .byte COLOR0+6 ; |     XX | $B2D4
       .byte COLOR0+6 ; |     XX | $B2D5
LB2D6:
       .byte COLOR0+6 ; |     XX | $B2D6
       .byte COLOR0+6 ; |     XX | $B2D7
       .byte COLOR0+6 ; |     XX | $B2D8
       .byte COLOR0+4 ; |     X  | $B2D9
       .byte COLOR0+2 ; |      X | $B2DA
       .byte COLOR3+0 ; |  XX    | $B2DB
       .byte COLOR3+2 ; |  XX  X | $B2DC
       .byte COLOR3+4 ; |  XX X  | $B2DD
LB2DE:
       .byte COLOR0+2 ; |      X | $B2DE
       .byte COLOR2+8 ; |  X X   | $B2DF
       .byte COLOR3+8 ; |  XXX   | $B2E0
       .byte COLOR3+8 ; |  XXX   | $B2E1
       .byte COLOR4+8 ; | X  X   | $B2E2
       .byte COLOR4+8 ; | X  X   | $B2E3
       .byte COLOR5+8 ; | X XX   | $B2E4
       .byte COLOR6+8 ; | XX X   | $B2E5
       .byte COLOR6+8 ; | XX X   | $B2E6
       .byte COLOR7+8 ; | XXXX   | $B2E7
       .byte COLOR8+8 ; |X   X   | $B2E8
LB2E9:
       .byte COLOR8+2 ; |X     X | $B2E9
       .byte COLOR8+2 ; |X     X | $B2EA
       .byte COLOR8+2 ; |X     X | $B2EB
       .byte COLOR8+2 ; |X     X | $B2EC
       .byte COLOR8+2 ; |X     X | $B2ED
       .byte COLOR8+2 ; |X     X | $B2EE
       .byte COLOR8+2 ; |X     X | $B2EF
       .byte COLOR8+2 ; |X     X | $B2F0
       .byte COLOR8+2 ; |X     X | $B2F1
       .byte COLOR8+2 ; |X     X | $B2F2
       .byte COLOR8+2 ; |X     X | $B2F3
LB2F4:
       .byte COLOR0+5 ; |     X X| $B2F4
       .byte COLOR0+5 ; |     X X| $B2F5
       .byte COLOR0+6 ; |     XX | $B2F6
       .byte COLOR0+5 ; |     X X| $B2F7
       .byte COLOR0+6 ; |     XX | $B2F8
       .byte COLOR0+6 ; |     XX | $B2F9
       .byte COLOR0+6 ; |     XX | $B2FA
       .byte COLOR0+5 ; |     X X| $B2FB
       .byte COLOR0+6 ; |     XX | $B2FC
       .byte COLOR0+5 ; |     X X| $B2FD
       .byte COLOR0+5 ; |     X X| $B2FE

;unused byte
       .byte $00 ; |        | $B2FF

       ORG  $2300
       RORG $B300

LB300: ;s/b on page break!
       .byte $00 ; |        | $B300
       .byte $FE ; |XXXXXXX | $B301
       .byte $FE ; |XXXXXXX | $B302
       .byte $FE ; |XXXXXXX | $B303
       .byte $FE ; |XXXXXXX | $B304
       .byte $FE ; |XXXXXXX | $B305
       .byte $EE ; |XXX XXX | $B306
       .byte $EE ; |XXX XXX | $B307
       .byte $EE ; |XXX XXX | $B308
       .byte $EE ; |XXX XXX | $B309
       .byte $EE ; |XXX XXX | $B30A
       .byte $EE ; |XXX XXX | $B30B
       .byte $EE ; |XXX XXX | $B30C
       .byte $EE ; |XXX XXX | $B30D
       .byte $EE ; |XXX XXX | $B30E
       .byte $EE ; |XXX XXX | $B30F
       .byte $EE ; |XXX XXX | $B310
       .byte $EE ; |XXX XXX | $B311
       .byte $EE ; |XXX XXX | $B312
       .byte $EE ; |XXX XXX | $B313
       .byte $EE ; |XXX XXX | $B314
       .byte $EE ; |XXX XXX | $B315
       .byte $EE ; |XXX XXX | $B316
       .byte $EE ; |XXX XXX | $B317
       .byte $EE ; |XXX XXX | $B318
       .byte $EE ; |XXX XXX | $B319
       .byte $EE ; |XXX XXX | $B31A
       .byte $EE ; |XXX XXX | $B31B
       .byte $EE ; |XXX XXX | $B31C
       .byte $EE ; |XXX XXX | $B31D
       .byte $EE ; |XXX XXX | $B31E
       .byte $EE ; |XXX XXX | $B31F
       .byte $EE ; |XXX XXX | $B320
       .byte $EE ; |XXX XXX | $B321
       .byte $FE ; |XXXXXXX | $B322
       .byte $FE ; |XXXXXXX | $B323
       .byte $FE ; |XXXXXXX | $B324
       .byte $FE ; |XXXXXXX | $B325

LB326:
       .byte COLORC+2 ; |XX    X | $B326
       .byte COLORC+2 ; |XX    X | $B327
       .byte COLORC+2 ; |XX    X | $B328
       .byte COLORC+2 ; |XX    X | $B329
       .byte COLORC+2 ; |XX    X | $B32A
       .byte COLORC+2 ; |XX    X | $B32B
       .byte COLORC+2 ; |XX    X | $B32C
       .byte COLORC+2 ; |XX    X | $B32D
       .byte COLORC+0 ; |XX      | $B32E
       .byte COLOR0+0 ; |        | $B32F
       .byte COLOR1+6 ; |   X XX | $B330
       .byte COLOR1+6 ; |   X XX | $B331
       .byte COLOR1+6 ; |   X XX | $B332
       .byte COLOR1+6 ; |   X XX | $B333
       .byte COLOR1+2 ; |   X  X | $B334
       .byte COLOR1+2 ; |   X  X | $B335
       .byte COLOR1+2 ; |   X  X | $B336
       .byte COLOR1+0 ; |   X    | $B337
       .byte COLOR1+0 ; |   X    | $B338
       .byte COLOR1+0 ; |   X    | $B339
       .byte COLOR0+0 ; |        | $B33A
       .byte COLOR0+2 ; |      X | $B33B
       .byte COLOR0+2 ; |      X | $B33C
       .byte COLOR0+2 ; |      X | $B33D
       .byte COLOR0+2 ; |      X | $B33E
       .byte COLOR0+2 ; |      X | $B33F
       .byte COLOR0+2 ; |      X | $B340
       .byte COLOR0+2 ; |      X | $B341
       .byte COLOR0+2 ; |      X | $B342
       .byte COLOR0+2 ; |      X | $B343
       .byte COLOR0+2 ; |      X | $B344
       .byte COLOR0+2 ; |      X | $B345
       .byte COLOR0+2 ; |      X | $B346
       .byte COLOR0+2 ; |      X | $B347
       .byte COLOR0+2 ; |      X | $B348
       .byte COLOR0+2 ; |      X | $B349
       .byte COLOR0+2 ; |      X | $B34A
LB34B:
       .byte COLOR0+2 ; |      X | $B34B shared
       .byte COLOR0+8 ; |    X   | $B34C
       .byte COLOR0+6 ; |     XX | $B34D
       .byte COLOR0+4 ; |     X  | $B34E
       .byte COLOR0+4 ; |     X  | $B34F
       .byte COLOR0+8 ; |    X   | $B350
       .byte COLOR0+6 ; |     XX | $B351
       .byte COLOR0+4 ; |     X  | $B352
       .byte COLOR0+4 ; |     X  | $B353
       .byte COLOR0+8 ; |    X   | $B354
       .byte COLOR0+6 ; |     XX | $B355
       .byte COLOR0+4 ; |     X  | $B356
       .byte COLOR0+4 ; |     X  | $B357
       .byte COLOR0+8 ; |    X   | $B358
       .byte COLOR0+6 ; |     XX | $B359
       .byte COLOR0+4 ; |     X  | $B35A
       .byte COLOR0+4 ; |     X  | $B35B
       .byte COLOR0+8 ; |    X   | $B35C
       .byte COLOR0+6 ; |     XX | $B35D
       .byte COLOR0+4 ; |     X  | $B35E
       .byte COLOR0+4 ; |     X  | $B35F
       .byte COLOR0+8 ; |    X   | $B360
       .byte COLOR0+6 ; |     XX | $B361
       .byte COLOR0+4 ; |     X  | $B362
       .byte COLOR0+4 ; |     X  | $B363
       .byte COLOR0+8 ; |    X   | $B364
       .byte COLOR0+6 ; |     XX | $B365
       .byte COLOR0+4 ; |     X  | $B366
       .byte COLOR0+4 ; |     X  | $B367
       .byte COLOR0+8 ; |    X   | $B368
       .byte COLOR0+6 ; |     XX | $B369
       .byte COLOR0+4 ; |     X  | $B36A
       .byte COLOR0+4 ; |     X  | $B36B
       .byte COLOR0+8 ; |    X   | $B36C
       .byte COLOR0+2 ; |      X | $B36D
       .byte COLOR8+6 ; |X    XX | $B36E
       .byte COLOR8+6 ; |X    XX | $B36F
       .byte COLOR8+6 ; |X    XX | $B370

LB371:
       .byte COLOR0+2 ; |      X | $B371
       .byte COLOR0+8 ; |    X   | $B372
       .byte COLOR0+6 ; |     XX | $B373
       .byte COLOR0+6 ; |     XX | $B374
       .byte COLOR0+6 ; |     XX | $B375
       .byte COLOR0+8 ; |    X   | $B376
       .byte COLOR0+6 ; |     XX | $B377
       .byte COLOR0+6 ; |     XX | $B378
       .byte COLOR0+6 ; |     XX | $B379
       .byte COLOR0+6 ; |     XX | $B37A
       .byte COLOR0+6 ; |     XX | $B37B
       .byte COLOR0+6 ; |     XX | $B37C
       .byte COLOR0+6 ; |     XX | $B37D
       .byte COLOR0+6 ; |     XX | $B37E
       .byte COLOR0+6 ; |     XX | $B37F
       .byte COLOR0+6 ; |     XX | $B380
       .byte COLOR0+6 ; |     XX | $B381
       .byte COLOR0+6 ; |     XX | $B382
       .byte COLOR0+6 ; |     XX | $B383
       .byte COLOR0+6 ; |     XX | $B384
       .byte COLOR0+6 ; |     XX | $B385
       .byte COLOR0+6 ; |     XX | $B386
       .byte COLOR0+6 ; |     XX | $B387
       .byte COLOR0+6 ; |     XX | $B388
       .byte COLOR0+6 ; |     XX | $B389
       .byte COLOR0+6 ; |     XX | $B38A
       .byte COLOR0+6 ; |     XX | $B38B
       .byte COLOR0+6 ; |     XX | $B38C
       .byte COLOR0+6 ; |     XX | $B38D
       .byte COLOR0+6 ; |     XX | $B38E
       .byte COLOR0+6 ; |     XX | $B38F
       .byte COLOR0+6 ; |     XX | $B390
       .byte COLOR0+6 ; |     XX | $B391
       .byte COLOR0+6 ; |     XX | $B392
       .byte COLOR0+8 ; |    X   | $B393
       .byte COLOR0+6 ; |     XX | $B394
       .byte COLOR0+6 ; |     XX | $B395
       .byte COLOR0+6 ; |     XX | $B396

LB397: ;PF2
       .byte $00 ; |        | $B397
       .byte $00 ; |        | $B398
       .byte $00 ; |        | $B399
       .byte $00 ; |        | $B39A
       .byte $00 ; |        | $B39B
       .byte $00 ; |        | $B39C
       .byte $00 ; |        | $B39D
       .byte $04 ; |     X  | $B39E
       .byte $04 ; |     X  | $B39F
       .byte $04 ; |     X  | $B3A0
       .byte $00 ; |        | $B3A1
       .byte $08 ; |    X   | $B3A2
       .byte $08 ; |    X   | $B3A3
       .byte $08 ; |    X   | $B3A4
LB3A5:
       .byte $00 ; |        | $B3A5 shared
       .byte $00 ; |        | $B3A6 shared
       .byte $00 ; |        | $B3A7 shared
       .byte $00 ; |        | $B3A8 shared
       .byte $00 ; |        | $B3A9 shared
       .byte $00 ; |        | $B3AA shared
       .byte $00 ; |        | $B3AB shared
       .byte $00 ; |        | $B3AC shared
       .byte $00 ; |        | $B3AD
       .byte $00 ; |        | $B3AE
       .byte $00 ; |        | $B3AF
       .byte $00 ; |        | $B3B0
       .byte $00 ; |        | $B3B1
       .byte $00 ; |        | $B3B2
       .byte $00 ; |        | $B3B3
       .byte $00 ; |        | $B3B4
       .byte $00 ; |        | $B3B5
       .byte $00 ; |        | $B3B6
       .byte $00 ; |        | $B3B7
       .byte $00 ; |        | $B3B8
LB3B9:
       .byte $00 ; |        | $B3B9 shared
       .byte $00 ; |        | $B3BA shared
       .byte $00 ; |        | $B3BB
       .byte $00 ; |        | $B3BC
       .byte $00 ; |        | $B3BD
       .byte $00 ; |        | $B3BE
       .byte $00 ; |        | $B3BF
       .byte $00 ; |        | $B3C0
       .byte $00 ; |        | $B3C1
       .byte $00 ; |        | $B3C2
       .byte $00 ; |        | $B3C3
       .byte $00 ; |        | $B3C4
       .byte $00 ; |        | $B3C5
       .byte $00 ; |        | $B3C6
       .byte $00 ; |        | $B3C7
       .byte $00 ; |        | $B3C8
       .byte $00 ; |        | $B3C9
       .byte $00 ; |        | $B3CA
       .byte $00 ; |        | $B3CB
       .byte $00 ; |        | $B3CC
       .byte $00 ; |        | $B3CD
       .byte $14 ; |   X X  | $B3CE
       .byte $14 ; |   X X  | $B3CF
       .byte $14 ; |   X X  | $B3D0
       .byte $00 ; |        | $B3D1
       .byte $08 ; |    X   | $B3D2
       .byte $08 ; |    X   | $B3D3
       .byte $08 ; |    X   | $B3D4
       .byte $00 ; |        | $B3D5
       .byte $00 ; |        | $B3D6
       .byte $01 ; |       X| $B3D7
       .byte $01 ; |       X| $B3D8
       .byte $01 ; |       X| $B3D9
       .byte $00 ; |        | $B3DA
       .byte $00 ; |        | $B3DB
       .byte $00 ; |        | $B3DC
       .byte $00 ; |        | $B3DD
       .byte $00 ; |        | $B3DE

LB3DF:
       .byte $00 ; |        | $B3DF
       .byte $FF ; |XXXXXXXX| $B3E0
       .byte $FF ; |XXXXXXXX| $B3E1
       .byte $FF ; |XXXXXXXX| $B3E2
       .byte $FF ; |XXXXXXXX| $B3E3
LB3E4:
       .byte $FF ; |XXXXXXXX| $B3E4
       .byte $FF ; |XXXXXXXX| $B3E5
       .byte $FF ; |XXXXXXXX| $B3E6
       .byte $FF ; |XXXXXXXX| $B3E7
       .byte $FF ; |XXXXXXXX| $B3E8
LB3E9: ;used for sunset
       .byte $00 ; |        | $B3E9
       .byte $F0 ; |XXXX    | $B3EA
       .byte $F0 ; |XXXX    | $B3EB
       .byte $E1 ; |XXX    X| $B3EC
       .byte $E1 ; |XXX    X| $B3ED
       .byte $C3 ; |XX    XX| $B3EE
       .byte $C3 ; |XX    XX| $B3EF
       .byte $87 ; |X    XXX| $B3F0
       .byte $87 ; |X    XXX| $B3F1
       .byte $0F ; |    XXXX| $B3F2
       .byte $0F ; |    XXXX| $B3F3

LB3F4:
       .byte COLOR1+8 ; |   XX   | $B3F4
       .byte COLOR1+8 ; |   XX   | $B3F5
       .byte COLOR1+8 ; |   XX   | $B3F6
       .byte COLOR1+8 ; |   XX   | $B3F7
       .byte COLOR1+8 ; |   XX   | $B3F8
       .byte COLOR1+8 ; |   XX   | $B3F9
       .byte COLOR1+8 ; |   XX   | $B3FA
       .byte COLOR1+8 ; |   XX   | $B3FB
       .byte COLOR1+8 ; |   XX   | $B3FC
       .byte COLOR1+8 ; |   XX   | $B3FD
       .byte COLOR1+8 ; |   XX   | $B3FE

;unused byte
       .byte $00 ; |        | $B3FF

       ORG  $2400
       RORG $B400

LB400:
       .byte $00 ; |        | $B400
       .byte $20 ; |  X     | $B401
       .byte $20 ; |  X     | $B402
       .byte $20 ; |  X     | $B403
       .byte $20 ; |  X     | $B404
       .byte $20 ; |  X     | $B405
       .byte $20 ; |  X     | $B406
       .byte $20 ; |  X     | $B407
       .byte $20 ; |  X     | $B408
       .byte $20 ; |  X     | $B409
       .byte $20 ; |  X     | $B40A
       .byte $20 ; |  X     | $B40B
       .byte $20 ; |  X     | $B40C
       .byte $20 ; |  X     | $B40D
       .byte $20 ; |  X     | $B40E
       .byte $20 ; |  X     | $B40F
       .byte $20 ; |  X     | $B410
       .byte $20 ; |  X     | $B411
       .byte $20 ; |  X     | $B412
       .byte $20 ; |  X     | $B413
       .byte $20 ; |  X     | $B414
       .byte $20 ; |  X     | $B415
       .byte $20 ; |  X     | $B416
       .byte $20 ; |  X     | $B417
       .byte $20 ; |  X     | $B418
       .byte $20 ; |  X     | $B419
       .byte $20 ; |  X     | $B41A
       .byte $E0 ; |XXX     | $B41B
       .byte $E0 ; |XXX     | $B41C
       .byte $C0 ; |XX      | $B41D
LB41E:
       .byte $00 ; |        | $B41E shared
       .byte $00 ; |        | $B41F shared
       .byte $00 ; |        | $B420 shared
       .byte $00 ; |        | $B421 shared
       .byte $00 ; |        | $B422 shared
       .byte $00 ; |        | $B423 shared
       .byte $00 ; |        | $B424 shared
       .byte $00 ; |        | $B425 shared
       .byte $00 ; |        | $B426
       .byte $02 ; |      X | $B427
       .byte $02 ; |      X | $B428
       .byte $02 ; |      X | $B429
       .byte $00 ; |        | $B42A
       .byte $04 ; |     X  | $B42B
       .byte $04 ; |     X  | $B42C
       .byte $04 ; |     X  | $B42D
       .byte $00 ; |        | $B42E
       .byte $00 ; |        | $B42F
       .byte $00 ; |        | $B430
       .byte $00 ; |        | $B431
       .byte $00 ; |        | $B432
       .byte $00 ; |        | $B433
       .byte $00 ; |        | $B434
       .byte $00 ; |        | $B435
       .byte $00 ; |        | $B436
       .byte $00 ; |        | $B437
       .byte $00 ; |        | $B438
       .byte $80 ; |X       | $B439
       .byte $80 ; |X       | $B43A
       .byte $80 ; |X       | $B43B
LB43C:
       .byte $00 ; |        | $B43C shared
       .byte $00 ; |        | $B43D shared
       .byte $00 ; |        | $B43E shared
       .byte $00 ; |        | $B43F shared
       .byte $00 ; |        | $B440 shared
       .byte $00 ; |        | $B441 shared
       .byte $00 ; |        | $B442 shared
       .byte $00 ; |        | $B443 shared
       .byte $E0 ; |XXX     | $B444
       .byte $E0 ; |XXX     | $B445
       .byte $E0 ; |XXX     | $B446
       .byte $E0 ; |XXX     | $B447
       .byte $E0 ; |XXX     | $B448
       .byte $E0 ; |XXX     | $B449
       .byte $E0 ; |XXX     | $B44A
       .byte $E0 ; |XXX     | $B44B
       .byte $E0 ; |XXX     | $B44C
       .byte $E0 ; |XXX     | $B44D
       .byte $E0 ; |XXX     | $B44E
       .byte $E0 ; |XXX     | $B44F
       .byte $E0 ; |XXX     | $B450
       .byte $E0 ; |XXX     | $B451
       .byte $E0 ; |XXX     | $B452
       .byte $E0 ; |XXX     | $B453
       .byte $E0 ; |XXX     | $B454
       .byte $E0 ; |XXX     | $B455
       .byte $E0 ; |XXX     | $B456
       .byte $E0 ; |XXX     | $B457
       .byte $E0 ; |XXX     | $B458
       .byte $E0 ; |XXX     | $B459
       .byte $E0 ; |XXX     | $B45A
       .byte $E0 ; |XXX     | $B45B
       .byte $C0 ; |XX      | $B45C
       .byte $80 ; |X       | $B45D
       .byte $00 ; |        | $B45E
       .byte $00 ; |        | $B45F
       .byte $00 ; |        | $B460
       .byte $00 ; |        | $B461

LB462:
       .byte COLORC+2 ; |XX    X | $B462
       .byte COLOR0+2 ; |      X | $B463
       .byte COLOR0+4 ; |     X  | $B464
       .byte COLOR0+4 ; |     X  | $B465
       .byte COLOR0+4 ; |     X  | $B466
       .byte COLOR0+4 ; |     X  | $B467
       .byte COLOR0+0 ; |        | $B468
       .byte COLOR3+4 ; |  XX X  | $B469
       .byte COLOR3+4 ; |  XX X  | $B46A
       .byte COLOR3+4 ; |  XX X  | $B46B
       .byte COLOR3+4 ; |  XX X  | $B46C
       .byte COLOR3+4 ; |  XX X  | $B46D
       .byte COLOR3+4 ; |  XX X  | $B46E
       .byte COLOR3+4 ; |  XX X  | $B46F
       .byte COLOR3+4 ; |  XX X  | $B470
       .byte COLOR3+4 ; |  XX X  | $B471
       .byte COLOR3+4 ; |  XX X  | $B472
       .byte COLOR3+4 ; |  XX X  | $B473
       .byte COLOR3+4 ; |  XX X  | $B474
       .byte COLOR3+4 ; |  XX X  | $B475
       .byte COLOR3+4 ; |  XX X  | $B476
       .byte COLOR3+4 ; |  XX X  | $B477
       .byte COLOR3+4 ; |  XX X  | $B478
       .byte COLOR3+4 ; |  XX X  | $B479
       .byte COLOR3+4 ; |  XX X  | $B47A
       .byte COLOR3+4 ; |  XX X  | $B47B
       .byte COLOR3+4 ; |  XX X  | $B47C
       .byte COLOR3+4 ; |  XX X  | $B47D
       .byte COLOR3+4 ; |  XX X  | $B47E
       .byte COLOR3+4 ; |  XX X  | $B47F
       .byte COLOR3+4 ; |  XX X  | $B480
       .byte COLOR3+4 ; |  XX X  | $B481
       .byte COLOR3+4 ; |  XX X  | $B482
       .byte COLOR3+4 ; |  XX X  | $B483
       .byte COLOR3+4 ; |  XX X  | $B484
       .byte COLOR3+2 ; |  XX  X | $B485
       .byte COLOR3+0 ; |  XX    | $B486
       .byte COLOR0+2 ; |      X | $B487

LB488:
       .byte COLORC+2 ; |XX    X | $B488
       .byte COLOR0+2 ; |      X | $B489
       .byte COLOR1+4 ; |   X X  | $B48A
       .byte COLOR1+4 ; |   X X  | $B48B
       .byte COLOR1+4 ; |   X X  | $B48C
       .byte COLOR1+4 ; |   X X  | $B48D
       .byte COLOR1+4 ; |   X X  | $B48E
       .byte COLOR1+4 ; |   X X  | $B48F
       .byte COLOR1+4 ; |   X X  | $B490
       .byte COLOR1+4 ; |   X X  | $B491
       .byte COLOR1+6 ; |   X XX | $B492
       .byte COLOR1+4 ; |   X X  | $B493
       .byte COLOR1+4 ; |   X X  | $B494
       .byte COLOR1+4 ; |   X X  | $B495
       .byte COLOR1+4 ; |   X X  | $B496
       .byte COLOR1+4 ; |   X X  | $B497
       .byte COLOR1+4 ; |   X X  | $B498
       .byte COLOR1+4 ; |   X X  | $B499
       .byte COLOR1+6 ; |   X XX | $B49A
       .byte COLOR1+4 ; |   X X  | $B49B
       .byte COLOR1+4 ; |   X X  | $B49C
       .byte COLOR1+4 ; |   X X  | $B49D
       .byte COLOR1+4 ; |   X X  | $B49E
       .byte COLOR1+4 ; |   X X  | $B49F
       .byte COLOR1+4 ; |   X X  | $B4A0
       .byte COLOR1+4 ; |   X X  | $B4A1
       .byte COLOR1+6 ; |   X XX | $B4A2
       .byte COLOR1+4 ; |   X X  | $B4A3
       .byte COLOR1+4 ; |   X X  | $B4A4
       .byte COLOR1+4 ; |   X X  | $B4A5
       .byte COLOR1+4 ; |   X X  | $B4A6
       .byte COLOR1+4 ; |   X X  | $B4A7
       .byte COLOR1+0 ; |   X    | $B4A8
       .byte COLOR1+6 ; |   X XX | $B4A9
       .byte COLOR1+6 ; |   X XX | $B4AA
       .byte COLOR0+0 ; |        | $B4AB
       .byte COLOR0+2 ; |      X | $B4AC
       .byte COLOR0+2 ; |      X | $B4AD

LB4AE:
       .byte COLORC+2 ; |XX    X | $B4AE
       .byte COLOR8+4 ; |X    X  | $B4AF
       .byte COLOR8+6 ; |X    XX | $B4B0
       .byte COLOR8+6 ; |X    XX | $B4B1
       .byte COLOR8+6 ; |X    XX | $B4B2
       .byte COLOR8+6 ; |X    XX | $B4B3
       .byte COLOR8+6 ; |X    XX | $B4B4
       .byte COLOR8+6 ; |X    XX | $B4B5
       .byte COLOR8+6 ; |X    XX | $B4B6
       .byte COLOR8+6 ; |X    XX | $B4B7
       .byte COLOR8+6 ; |X    XX | $B4B8
       .byte COLOR8+6 ; |X    XX | $B4B9
       .byte COLOR8+6 ; |X    XX | $B4BA
       .byte COLOR8+6 ; |X    XX | $B4BB
       .byte COLOR8+6 ; |X    XX | $B4BC
       .byte COLOR8+6 ; |X    XX | $B4BD
       .byte COLOR8+6 ; |X    XX | $B4BE
       .byte COLOR8+6 ; |X    XX | $B4BF
       .byte COLOR8+6 ; |X    XX | $B4C0
       .byte COLOR8+6 ; |X    XX | $B4C1
       .byte COLOR8+6 ; |X    XX | $B4C2
       .byte COLOR8+6 ; |X    XX | $B4C3
       .byte COLOR8+6 ; |X    XX | $B4C4
       .byte COLOR8+6 ; |X    XX | $B4C5
       .byte COLOR8+6 ; |X    XX | $B4C6
       .byte COLOR8+6 ; |X    XX | $B4C7
       .byte COLOR8+6 ; |X    XX | $B4C8
       .byte COLOR8+6 ; |X    XX | $B4C9
       .byte COLOR8+6 ; |X    XX | $B4CA
       .byte COLOR8+6 ; |X    XX | $B4CB
       .byte COLOR8+6 ; |X    XX | $B4CC
       .byte COLOR8+6 ; |X    XX | $B4CD
       .byte COLOR8+6 ; |X    XX | $B4CE
       .byte COLOR8+6 ; |X    XX | $B4CF
       .byte COLOR8+6 ; |X    XX | $B4D0
       .byte COLOR8+6 ; |X    XX | $B4D1
       .byte COLOR8+6 ; |X    XX | $B4D2
       .byte COLOR8+6 ; |X    XX | $B4D3

LB4D4:
       .byte COLOR4+3 ; | X    XX| $B4D4
       .byte COLOR4+1 ; | X     X| $B4D5
       .byte COLOR4+3 ; | X    XX| $B4D6
       .byte COLOR4+3 ; | X    XX| $B4D7
       .byte COLOR4+3 ; | X    XX| $B4D8
       .byte COLOR4+3 ; | X    XX| $B4D9
       .byte COLOR4+3 ; | X    XX| $B4DA
       .byte COLOR4+1 ; | X     X| $B4DB
       .byte COLOR4+3 ; | X    XX| $B4DC
       .byte COLOR4+3 ; | X    XX| $B4DD
       .byte COLOR4+3 ; | X    XX| $B4DE
       .byte COLOR4+3 ; | X    XX| $B4DF
       .byte COLOR4+3 ; | X    XX| $B4E0
       .byte COLOR4+1 ; | X     X| $B4E1
       .byte COLOR4+3 ; | X    XX| $B4E2
       .byte COLOR4+3 ; | X    XX| $B4E3
       .byte COLOR4+3 ; | X    XX| $B4E4
       .byte COLOR4+3 ; | X    XX| $B4E5
       .byte COLOR4+3 ; | X    XX| $B4E6
       .byte COLOR4+1 ; | X     X| $B4E7
       .byte COLOR4+3 ; | X    XX| $B4E8
       .byte COLOR4+3 ; | X    XX| $B4E9
       .byte COLOR4+3 ; | X    XX| $B4EA
       .byte COLOR4+3 ; | X    XX| $B4EB
       .byte COLOR4+3 ; | X    XX| $B4EC
       .byte COLOR4+1 ; | X     X| $B4ED
       .byte COLOR4+3 ; | X    XX| $B4EE
       .byte COLOR4+3 ; | X    XX| $B4EF
       .byte COLOR4+3 ; | X    XX| $B4F0
       .byte COLOR4+3 ; | X    XX| $B4F1
       .byte COLOR4+3 ; | X    XX| $B4F2
       .byte COLOR4+1 ; | X     X| $B4F3
       .byte COLOR4+3 ; | X    XX| $B4F4
       .byte COLOR4+3 ; | X    XX| $B4F5
       .byte COLOR4+3 ; | X    XX| $B4F6
       .byte COLOR4+3 ; | X    XX| $B4F7
       .byte COLOR4+1 ; | X     X| $B4F8
       .byte COLOR4+3 ; | X    XX| $B4F9

;unused
       .byte COLOR0+0 ; |        | $B4FA
       .byte COLOR0+0 ; |        | $B4FB
       .byte COLOR0+0 ; |        | $B4FC
       .byte COLOR0+0 ; |        | $B4FD
       .byte COLOR0+0 ; |        | $B4FE
       .byte COLOR0+0 ; |        | $B4FF

       ORG  $2500
       RORG $B500

LB500:
       .byte $00 ; |        | $B500
       .byte $FF ; |XXXXXXXX| $B501
       .byte $FF ; |XXXXXXXX| $B502
       .byte $FF ; |XXXXXXXX| $B503
       .byte $FF ; |XXXXXXXX| $B504
       .byte $FF ; |XXXXXXXX| $B505
       .byte $FF ; |XXXXXXXX| $B506
       .byte $FF ; |XXXXXXXX| $B507
       .byte $FF ; |XXXXXXXX| $B508
       .byte $FF ; |XXXXXXXX| $B509
       .byte $FF ; |XXXXXXXX| $B50A
       .byte $FF ; |XXXXXXXX| $B50B
       .byte $FF ; |XXXXXXXX| $B50C
       .byte $FF ; |XXXXXXXX| $B50D
       .byte $FF ; |XXXXXXXX| $B50E
       .byte $FF ; |XXXXXXXX| $B50F
       .byte $FF ; |XXXXXXXX| $B510
       .byte $FF ; |XXXXXXXX| $B511
       .byte $FF ; |XXXXXXXX| $B512
       .byte $FF ; |XXXXXXXX| $B513
       .byte $00 ; |        | $B514
LB515:
       .byte $00 ; |        | $B515
       .byte $00 ; |        | $B516
       .byte $00 ; |        | $B517
       .byte $00 ; |        | $B518
       .byte $00 ; |        | $B519
       .byte $00 ; |        | $B51A
       .byte $00 ; |        | $B51B
       .byte $00 ; |        | $B51C
       .byte $00 ; |        | $B51D
       .byte $00 ; |        | $B51E
       .byte $00 ; |        | $B51F
       .byte $00 ; |        | $B520
       .byte $00 ; |        | $B521
       .byte $00 ; |        | $B522
       .byte $00 ; |        | $B523
       .byte $00 ; |        | $B524
       .byte $00 ; |        | $B525
       .byte $00 ; |        | $B526
       .byte $00 ; |        | $B527
       .byte $FF ; |XXXXXXXX| $B528
       .byte $FF ; |XXXXXXXX| $B529
       .byte $FF ; |XXXXXXXX| $B52A
       .byte $FF ; |XXXXXXXX| $B52B
       .byte $FF ; |XXXXXXXX| $B52C
       .byte $FF ; |XXXXXXXX| $B52D
       .byte $FF ; |XXXXXXXX| $B52E
       .byte $FF ; |XXXXXXXX| $B52F
       .byte $FF ; |XXXXXXXX| $B530
       .byte $FF ; |XXXXXXXX| $B531
       .byte $FF ; |XXXXXXXX| $B532
       .byte $FF ; |XXXXXXXX| $B533
       .byte $FF ; |XXXXXXXX| $B534
       .byte $FF ; |XXXXXXXX| $B535
       .byte $FF ; |XXXXXXXX| $B536
       .byte $FF ; |XXXXXXXX| $B537
       .byte $FF ; |XXXXXXXX| $B538
       .byte $FF ; |XXXXXXXX| $B539
       .byte $FF ; |XXXXXXXX| $B53A

LB53B:
       .byte COLORC+4 ; |XX   X  | $B53B
       .byte COLORC+4 ; |XX   X  | $B53C
       .byte COLORC+4 ; |XX   X  | $B53D
       .byte COLORC+6 ; |XX   XX | $B53E
       .byte COLOR0+0 ; |        | $B53F
       .byte COLOR0+6 ; |     XX | $B540
       .byte COLOR0+5 ; |     X X| $B541
       .byte COLOR0+6 ; |     XX | $B542
       .byte COLOR0+5 ; |     X X| $B543
       .byte COLOR0+5 ; |     X X| $B544
       .byte COLOR0+6 ; |     XX | $B545
       .byte COLOR0+5 ; |     X X| $B546
       .byte COLOR0+6 ; |     XX | $B547
       .byte COLOR0+6 ; |     XX | $B548
       .byte COLOR0+6 ; |     XX | $B549
       .byte COLOR0+5 ; |     X X| $B54A
       .byte COLOR0+6 ; |     XX | $B54B
       .byte COLOR0+5 ; |     X X| $B54C
       .byte COLOR0+5 ; |     X X| $B54D
       .byte COLOR0+6 ; |     XX | $B54E
       .byte COLOR0+5 ; |     X X| $B54F
       .byte COLOR0+6 ; |     XX | $B550
       .byte COLOR0+6 ; |     XX | $B551
       .byte COLOR0+6 ; |     XX | $B552
       .byte COLOR0+5 ; |     X X| $B553
       .byte COLOR0+6 ; |     XX | $B554
       .byte COLOR0+5 ; |     X X| $B555
       .byte COLOR0+5 ; |     X X| $B556
       .byte COLOR0+6 ; |     XX | $B557
       .byte COLOR0+5 ; |     X X| $B558
       .byte COLOR0+6 ; |     XX | $B559
       .byte COLOR0+6 ; |     XX | $B55A
       .byte COLOR0+6 ; |     XX | $B55B
       .byte COLOR0+5 ; |     X X| $B55C
       .byte COLOR0+6 ; |     XX | $B55D
       .byte COLOR0+5 ; |     X X| $B55E
       .byte COLOR0+5 ; |     X X| $B55F
       .byte COLOR0+6 ; |     XX | $B560
LB561:
       .byte $00 ; |        | $B561
       .byte $FF ; |XXXXXXXX| $B562
       .byte $42 ; | X    X | $B563
       .byte $24 ; |  X  X  | $B564
       .byte $18 ; |   XX   | $B565
       .byte $24 ; |  X  X  | $B566
       .byte $42 ; | X    X | $B567
       .byte $81 ; |X      X| $B568
       .byte $42 ; | X    X | $B569
       .byte $24 ; |  X  X  | $B56A
       .byte $18 ; |   XX   | $B56B
       .byte $24 ; |  X  X  | $B56C
       .byte $42 ; | X    X | $B56D
       .byte $81 ; |X      X| $B56E
       .byte $42 ; | X    X | $B56F
       .byte $24 ; |  X  X  | $B570
       .byte $18 ; |   XX   | $B571
       .byte $24 ; |  X  X  | $B572
       .byte $42 ; | X    X | $B573
       .byte $81 ; |X      X| $B574
       .byte $42 ; | X    X | $B575
       .byte $24 ; |  X  X  | $B576
       .byte $18 ; |   XX   | $B577
       .byte $24 ; |  X  X  | $B578
       .byte $42 ; | X    X | $B579
       .byte $81 ; |X      X| $B57A
       .byte $42 ; | X    X | $B57B
       .byte $24 ; |  X  X  | $B57C
       .byte $18 ; |   XX   | $B57D
       .byte $24 ; |  X  X  | $B57E
       .byte $42 ; | X    X | $B57F
       .byte $81 ; |X      X| $B580
       .byte $42 ; | X    X | $B581
       .byte $24 ; |  X  X  | $B582
       .byte $18 ; |   XX   | $B583
       .byte $24 ; |  X  X  | $B584
       .byte $42 ; | X    X | $B585
       .byte $FF ; |XXXXXXXX| $B586

LB587:
       .byte $C6 ; |XX   XX | $B587
       .byte $C6 ; |XX   XX | $B588
       .byte $C6 ; |XX   XX | $B589
       .byte $CC ; |XX  XX  | $B58A
       .byte $C6 ; |XX   XX | $B58B
       .byte $C6 ; |XX   XX | $B58C
       .byte $CC ; |XX  XX  | $B58D
       .byte $CC ; |XX  XX  | $B58E
       .byte $C6 ; |XX   XX | $B58F
       .byte $C6 ; |XX   XX | $B590
       .byte $C6 ; |XX   XX | $B591
       .byte $C6 ; |XX   XX | $B592
       .byte $C6 ; |XX   XX | $B593
       .byte $CC ; |XX  XX  | $B594
       .byte $CC ; |XX  XX  | $B595
       .byte $CC ; |XX  XX  | $B596
       .byte $C6 ; |XX   XX | $B597
       .byte $CC ; |XX  XX  | $B598
       .byte $C6 ; |XX   XX | $B599
       .byte $C6 ; |XX   XX | $B59A
       .byte $C6 ; |XX   XX | $B59B
       .byte $C6 ; |XX   XX | $B59C
       .byte $C6 ; |XX   XX | $B59D
       .byte $CC ; |XX  XX  | $B59E
       .byte $CD ; |XX  XX X| $B59F
       .byte $CD ; |XX  XX X| $B5A0
       .byte $CC ; |XX  XX  | $B5A1
       .byte $CD ; |XX  XX X| $B5A2
       .byte $CD ; |XX  XX X| $B5A3
       .byte $C6 ; |XX   XX | $B5A4
       .byte $C6 ; |XX   XX | $B5A5
       .byte $C6 ; |XX   XX | $B5A6
       .byte $CD ; |XX  XX X| $B5A7
       .byte $CD ; |XX  XX X| $B5A8
       .byte $CD ; |XX  XX X| $B5A9
       .byte $CC ; |XX  XX  | $B5AA
       .byte $CC ; |XX  XX  | $B5AB
       .byte $C6 ; |XX   XX | $B5AC
LB5AD:
       .byte $00 ; |        | $B5AD
       .byte $FC ; |XXXXXX  | $B5AE
       .byte $FC ; |XXXXXX  | $B5AF
       .byte $FC ; |XXXXXX  | $B5B0
       .byte $FC ; |XXXXXX  | $B5B1
       .byte $FC ; |XXXXXX  | $B5B2
       .byte $FC ; |XXXXXX  | $B5B3
       .byte $FC ; |XXXXXX  | $B5B4
       .byte $FC ; |XXXXXX  | $B5B5
       .byte $FC ; |XXXXXX  | $B5B6
       .byte $FC ; |XXXXXX  | $B5B7
       .byte $FC ; |XXXXXX  | $B5B8
       .byte $FC ; |XXXXXX  | $B5B9
       .byte $FC ; |XXXXXX  | $B5BA
       .byte $FC ; |XXXXXX  | $B5BB
       .byte $FC ; |XXXXXX  | $B5BC
       .byte $FC ; |XXXXXX  | $B5BD
       .byte $FC ; |XXXXXX  | $B5BE
       .byte $FC ; |XXXXXX  | $B5BF
       .byte $FC ; |XXXXXX  | $B5C0
       .byte $FC ; |XXXXXX  | $B5C1
       .byte $FC ; |XXXXXX  | $B5C2
       .byte $FC ; |XXXXXX  | $B5C3
       .byte $FC ; |XXXXXX  | $B5C4
       .byte $FC ; |XXXXXX  | $B5C5
       .byte $FC ; |XXXXXX  | $B5C6
       .byte $FC ; |XXXXXX  | $B5C7
       .byte $FC ; |XXXXXX  | $B5C8
       .byte $FC ; |XXXXXX  | $B5C9
       .byte $FC ; |XXXXXX  | $B5CA
       .byte $FC ; |XXXXXX  | $B5CB
       .byte $FC ; |XXXXXX  | $B5CC
       .byte $FC ; |XXXXXX  | $B5CD
       .byte $FC ; |XXXXXX  | $B5CE
       .byte $FC ; |XXXXXX  | $B5CF
       .byte $FC ; |XXXXXX  | $B5D0
       .byte $FC ; |XXXXXX  | $B5D1
       .byte $FC ; |XXXXXX  | $B5D2
LB5D3:
       .byte $00 ; |        | $B5D3
       .byte $FC ; |XXXXXX  | $B5D4
       .byte $FC ; |XXXXXX  | $B5D5
       .byte $FC ; |XXXXXX  | $B5D6
       .byte $FC ; |XXXXXX  | $B5D7
       .byte $FC ; |XXXXXX  | $B5D8
       .byte $FC ; |XXXXXX  | $B5D9
       .byte $FC ; |XXXXXX  | $B5DA
       .byte $FC ; |XXXXXX  | $B5DB
       .byte $FC ; |XXXXXX  | $B5DC
       .byte $00 ; |        | $B5DD
LB5DE:
       .byte $00 ; |        | $B5DE
       .byte $3C ; |  XXXX  | $B5DF
       .byte $3C ; |  XXXX  | $B5E0
       .byte $3C ; |  XXXX  | $B5E1
       .byte $3C ; |  XXXX  | $B5E2
       .byte $3C ; |  XXXX  | $B5E3
       .byte $3C ; |  XXXX  | $B5E4
       .byte $3C ; |  XXXX  | $B5E5
       .byte $3C ; |  XXXX  | $B5E6
       .byte $3C ; |  XXXX  | $B5E7
       .byte $00 ; |        | $B5E8
LB5E9:
       .byte COLOR1+8 ; |   XX   | $B5E9
       .byte COLOR0+0 ; |        | $B5EA
       .byte COLOR0+0 ; |        | $B5EB
       .byte COLOR0+0 ; |        | $B5EC
       .byte COLOR0+0 ; |        | $B5ED
       .byte COLOR0+0 ; |        | $B5EE
       .byte COLOR0+0 ; |        | $B5EF
       .byte COLOR0+0 ; |        | $B5F0
       .byte COLOR0+0 ; |        | $B5F1
       .byte COLOR0+0 ; |        | $B5F2
       .byte COLOR1+8 ; |   XX   | $B5F3
LB5F4:
       .byte COLOR0+2 ; |      X | $B5F4
       .byte COLOR8+2 ; |X     X | $B5F5
       .byte COLOR8+4 ; |X    X  | $B5F6
       .byte COLOR8+6 ; |X    XX | $B5F7
       .byte COLOR0+2 ; |      X | $B5F8
       .byte COLOR9+2 ; |X  X  X | $B5F9
       .byte COLOR9+2 ; |X  X  X | $B5FA
       .byte COLOR9+2 ; |X  X  X | $B5FB
       .byte COLOR9+2 ; |X  X  X | $B5FC
       .byte COLOR9+2 ; |X  X  X | $B5FD
       .byte COLOR9+2 ; |X  X  X | $B5FE
       .byte COLOR0+0 ; |        | $B5FF

       ORG  $2600
       RORG $B600

LB004: ;@30
       ldy    rB2                     ;3
       lda    LBD29,y                 ;4
       sta    rD3+4                   ;3
       ldy    rBA                     ;3
       lda    LBD29,y                 ;4
       sta    rD3+2                   ;3
       ldx    rBB                     ;3
       lda    LBD29,x                 ;4
       sta    rD3+3                   ;3
       ldy    rB9                     ;3
       lda    LBD29,y                 ;4 @67
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       sta    rD3+1                   ;3
       and    #$0F                    ;2
       tay                            ;2
LB027:
       dey                            ;2
       bpl    LB027                   ;2
       sta    RESP0                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       lda    rD3+2                   ;3
       and    #$0F                    ;2
       tay                            ;2
LB035:
       dey                            ;2
       bpl    LB035                   ;2
       sta    RESP1                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       nop                            ;2
       nop                            ;2
       ldx    rBC                     ;3
       lda    LBD29,x                 ;4
       sta    rD3                     ;3
       ldx    rAC                     ;3
       lda    LB17C,x                 ;4
       sta    NUSIZ0                  ;3
       lda    LBD33,x                 ;4
       sta    CTRLPF                  ;3
       lda    LB18F,x                 ;4
       sta    NUSIZ1                  ;3
       lda    rD3+1                   ;3
       sta    HMP0                    ;3
       lda    rD3+2                   ;3
       sta    HMP1                    ;3
       lda    rDF                     ;3
       sta    HMBL                    ;3
       lda    LBD46,x                 ;4
       sta    REFP1                   ;3
       lda    #$00                    ;2
       sta    VDELP0                  ;3
       sta    VDELP1                  ;3
       ldy    #$0A                    ;2 @76
       sta    HMOVE                   ;3
       sta    COLUBK                  ;3
       lda    LB169,x                 ;4
       sta    COLUPF                  ;3
       ldx    rB3                     ;3
       lda    LBD29,x                 ;4
       sta    rD3+5                   ;3
       ldx    rB4                     ;3
       lda    LBD29,x                 ;4
       sta    rD3+6                   ;3
       ldx    rB5                     ;3
       lda    LBD29,x                 ;4
       sta    rD3+7                   ;3
       sta    HMCLR                   ;3
LB091:
       lda    (rE8),y                 ;5
       sta.w  COLUP0                  ;4
       lda    (rEE),y                 ;5
       tax                            ;2
       lda    (rEA),y                 ;5
       sta.w  COLUP1                  ;4
       lda    (rEC),y                 ;5
       sta    HMOVE                   ;3
       sta    PF0                     ;3
       lda    (rF0),y                 ;5
       sta    COLUBK                  ;3

;       nop                            ;2
;       lda    (rF0),y                 ;5
;       tax                            ;2
;       lda    (rE8),y                 ;5
;       sta    COLUP0                  ;3
;       lda    (rEA),y                 ;5
;       sta    COLUP1                  ;3
;       lda    (rEC),y                 ;5
;       sta    HMOVE                   ;3
;       sta    PF0                     ;3
;       stx    COLUBK                  ;3
;       lax    (rEE),y                 ;5


       lda    (rF2),y                 ;5
       sta    GRP0                    ;3
       stx    PF1                     ;3
       lda    (rF4),y                 ;5
       sta    PF2                     ;3
       lda    (rF6),y                 ;5
       sta    GRP1                    ;3
       dey                            ;2
       bpl    LB091                   ;2
       ldx    rAC                     ;3
       lda    LBCEA,x                 ;4 done
       sta    rF2                     ;3
       lda    LBE13,x                 ;4 done
       sta    rEA                     ;3
       lda    rD3+3                   ;3
       and    #$0F                    ;2
       tax                            ;2
       ldy    #$02                    ;2
       lda    (bckgrndColorPtr),y     ;5
       sta    HMOVE                   ;3
       sta    COLUBK                  ;3
       nop                            ;2
       nop                            ;2
LB0D4:
       dex                            ;2
       bpl    LB0D4                   ;2
       sta    RESP0                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       lda    rD3                     ;3
       and    #$0F                    ;2
       tax                            ;2
LB0E2:
       dex                            ;2
       bpl    LB0E2                   ;2
       sta    RESP1                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       ldy    #$01                    ;2
       lda    (bckgrndColorPtr),y     ;5
       sta    COLUBK                  ;3
       ldx    rAC                     ;3
       lda    LB1B5,x                 ;4
       sta    NUSIZ0                  ;3
       lda    rD3+3                   ;3
       sta    HMP0                    ;3
       lda    rD3                     ;3
       sta    HMP1                    ;3
       lda    LBD26,x                 ;4
       sta    CTRLPF                  ;3
       lda    LB1C8,x                 ;4
       sta    NUSIZ1                  ;3
       lda    LBCD7,x                 ;4 done
       sta    rF2+1                   ;3
       lda    LBCB1,x                 ;4 done
       sta    rF6                     ;3
       ldy    #$00                    ;2
       lda    (bckgrndColorPtr),y     ;5
       ldy    LB1A2,x                 ;4
       nop                            ;2
       sta    HMOVE                   ;3
       sta    COLUBK                  ;3
       sty    COLUPF                  ;3
       lda    LBD13,x                 ;4 done
       sta    rF6+1                   ;3
       lda    LBCC4,x                 ;4 done
       sta    rE8                     ;3
       lda    LBD00,x                 ;4 done
       sta    rE8+1                   ;3
       sta    HMCLR                   ;3
       lda    LBE00,x                 ;4 done
       sta    rEA+1                   ;3
       nop                            ;2
       nop                            ;2
       ldy    #$25                    ;2
LB13C:
       lda    (rE2),y                 ;5
       tax                            ;2
       lda    (rE8),y                 ;5
       sta.w  COLUP0                  ;4
       lda    (rEA),y                 ;5
       sta.w  COLUP1                  ;4
       lda    (rE0),y                 ;5
       sta    HMOVE                   ;3
       sta    PF0                     ;3
       lda    (rF2),y                 ;5
       sta    COLUBK                  ;3
       lda    (rE4),y                 ;5
       sta    GRP0                    ;3
       stx    PF1                     ;3
       lda    (rE6),y                 ;5
       sta    PF2                     ;3
       lda    (rF6),y                 ;5
       sta    GRP1                    ;3
       dey                            ;2
       bpl    LB13C                   ;2
       sty    ENAM1                   ;3
       jmp    LBFD6                   ;3




LBE31:
       tax                            ;2
       asl                            ;2
       sta    rF4                     ;3
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LBEB4                   ;2
       ldy    r94,x                   ;4
       lda    LBEEC,y                 ;4
       tay                            ;2
       lda    rAB                     ;3
       and    #$04                    ;2
       cmp    #$04                    ;2
       bne    LBE53                   ;2
       bit    rAB                     ;3
       bpl    LBE53                   ;2
       lda    rA0,x                   ;4
       and    #$02                    ;2
       beq    LBE69                   ;2
LBE53:
       ldx    rF1                     ;3
       lda    LBEE3,x                 ;4
       sta    rE4                     ;3
       lda    #>LBE61                 ;2
       sta    rE4+1                   ;3
       jmp.ind (rE4)                  ;5

LBE61:
       ldx    LBF03,y                 ;4
       lda    LBF0F,y                 ;4
       bne    LBEA7                   ;2 always branch

LBE69:
       ldx    LBF2B,y                 ;4
       lda    LBF2F,y                 ;4
       bne    LBEA7                   ;2 always branch

LBE71:
       ldx    LBF33,y                 ;4
       lda    LBF37,y                 ;4
       bne    LBEA7                   ;2 always branch

LBE79:
       ldx    LBF4B,y                 ;4
       lda    LBF4F,y                 ;4
       bne    LBEA7                   ;2 always branch

LBE81:
       ldx    LBF13,y                 ;4
       lda    LBF17,y                 ;4
       bne    LBEA7                   ;2 always branch

LBE89:
       ldx    LBF1B,y                 ;4
       lda    LBF1F,y                 ;4
       bne    LBEA7                   ;2 always branch

LBE91:
       ldx    LBF23,y                 ;4
       lda    LBF27,y                 ;4
       bne    LBEA7                   ;2 always branch

LBE99:
       ldx    LBF3B,y                 ;4
       lda    LBF3F,y                 ;4
       bne    LBEA7                   ;2 always branch

LBEA1:
       ldx    LBF43,y                 ;4
       lda    LBF47,y                 ;4
LBEA7:
       ldy    rF4                     ;3
       stx    rCB,y                   ;4
       sta.wy rCB+1,y                 ;5
       rts                            ;6

LBEAF:
       tax                            ;2
       asl                            ;2
       sta    rF4                     ;3
       tya                            ;2
LBEB4:
       sta    rF6                     ;3
       ldy    r94,x                   ;4
       lda    LBEEC,y                 ;4
       tay                            ;2
       lda    rAB                     ;3
       and    #$04                    ;2
       cmp    #$04                    ;2
       bne    LBECE                   ;2
       bit    rAB                     ;3
       bpl    LBECE                   ;2
       lda    rA0,x                   ;4
       and    #$02                    ;2
       beq    LBE69                   ;2
LBECE:
       lda    rF6                     ;3 NOTE: LD9D9 mislabelled in next tables!
       bne    LBEDA                   ;2 branch if player 2?
       ldx    LBEFB,y                 ;4 ;use player 1 color table
       lda    LBF07,y                 ;4
       bne    LBEE0                   ;2 always branch

LBEDA: ;use player 2 color table
       ldx    LBEFF,y                 ;4
       lda    LBF0B,y                 ;4
LBEE0:
       jmp    LBEA7                   ;3

LBF53:
       ldy    rAA                     ;3
       beq    LBF75                   ;2
       cpy    #$90                    ;2
       bcs    LBF65                   ;2
       lda    rE0                     ;3
       bne    LBF75                   ;2
       lda    #$04                    ;2
       sta    rE0                     ;3
       bne    LBF75                   ;2 always branch

LBF65:
       lda    frameCounter            ;3
       and    #$3F                    ;2
       bne    LBF75                   ;2
       lda    #$01                    ;2
       sta    r82                     ;3
       lda    #$FF                    ;2
       sta    r84                     ;3
       sta    r83                     ;3
LBF75:
       ldy    rB8                     ;3
       lda    LBD29,y                 ;4
       sta    rDF                     ;3
;player 1
       lda    rE8                     ;3
       ldy    rE7                     ;3
       jsr    LBEAF                   ;6
       lda    rE9                     ;3
       jsr    LBE31                   ;6
       lda    rEA                     ;3
       ldx    gameVariation           ;3
       cpx    #$04                    ;2
       beq    LBF94                   ;2
;player 2
       ldy    #$01                    ;2
       bne    LBF96                   ;2 always branch

LBF94:
       ldy    rE7                     ;3
LBF96:
       jsr    LBEAF                   ;6
       lda    rEB                     ;3
       jsr    LBE31                   ;6
       jmp    LBFE2                   ;3



;       ORG  $2865
;       RORG $B865
;       .byte 0

       ORG  $28C5,0
       RORG $B8C5,0

LBEE3:
       .byte <LBE61 ; $BEE3
       .byte <LBE69 ; $BEE4
       .byte <LBE71 ; $BEE5
       .byte <LBE79 ; $BEE6
       .byte <LBE81 ; $BEE7
       .byte <LBE89 ; $BEE8
       .byte <LBE91 ; $BEE9
       .byte <LBE99 ; $BEEA
       .byte <LBEA1 ; $BEEB

LBEEC:
       .byte $00 ; |        | $BEEC
       .byte $00 ; |        | $BEED
       .byte $01 ; |       X| $BEEE
       .byte $00 ; |        | $BEEF
       .byte $01 ; |       X| $BEF0
       .byte $03 ; |      XX| $BEF1
       .byte $02 ; |      X | $BEF2
       .byte $00 ; |        | $BEF3
       .byte $00 ; |        | $BEF4
       .byte $00 ; |        | $BEF5
       .byte $00 ; |        | $BEF6
       .byte $00 ; |        | $BEF7
       .byte $00 ; |        | $BEF8
       .byte $00 ; |        | $BEF9
       .byte $00 ; |        | $BEFA

LBCC4:
       .byte <LB34B ; $BCC4
       .byte <LB326 ; $BCC5
       .byte <LB83A ; $BCC6
       .byte <LB4D4 ; $BCC7
       .byte <LB587 ; $BCC8
       .byte <LB3A5 ; $BCC9
       .byte <LB3A5 ; $BCCA
       .byte <LB83A ; $BCCB
       .byte <LB326 ; $BCCC
       .byte <LB798 ; $BCCD
       .byte <LBA46 ; $BCCE
       .byte <LB798 ; $BCCF
       .byte <LB772 ; $BCD0
       .byte <LBA46 ; $BCD1
       .byte <LB931 ; $BCD2
       .byte <LBB00 ; $BCD3
       .byte <LBAB8 ; $BCD4
       .byte <LB3A5 ; $BCD5
       .byte <LBC6B ; $BCD6

LBF3F:
       .byte >LD0C2 ; $BF3F
       .byte >LD0C1 ; $BF40
       .byte >LD0B1 ; $BF41
       .byte >LD0C1 ; $BF42

LBF43:
       .byte <LD511 ; $BF43
       .byte <LD510 ; $BF44
       .byte <LD500 ; $BF45
       .byte <LD510 ; $BF46

LBF4B:
       .byte <LD8BE ; $BF4B
       .byte <LD8BD ; $BF4C
       .byte <LD87B ; $BF4D
       .byte <LD8BE ; $BF4E

LBF4F:
       .byte >LD8BE ; $BF4B
       .byte >LD8BD ; $BF4C
       .byte >LD87B ; $BF4D
       .byte >LD8BE ; $BF4E

       ORG  $2900
       RORG $B900

LBC00:
       .byte $00 ; |        | $BC00
       .byte $FF ; |XXXXXXXX| $BC01
       .byte $FF ; |XXXXXXXX| $BC02
       .byte $FF ; |XXXXXXXX| $BC03
       .byte $FF ; |XXXXXXXX| $BC04
       .byte $FF ; |XXXXXXXX| $BC05
       .byte $FF ; |XXXXXXXX| $BC06
       .byte $FF ; |XXXXXXXX| $BC07
       .byte $FF ; |XXXXXXXX| $BC08
       .byte $FF ; |XXXXXXXX| $BC09
       .byte $FF ; |XXXXXXXX| $BC0A
       .byte $FF ; |XXXXXXXX| $BC0B
       .byte $00 ; |        | $BC0C
       .byte $00 ; |        | $BC0D
       .byte $00 ; |        | $BC0E
       .byte $00 ; |        | $BC0F
LBC10:
       .byte $00 ; |        | $BC10
       .byte $00 ; |        | $BC11
       .byte $00 ; |        | $BC12
       .byte $00 ; |        | $BC13
       .byte $00 ; |        | $BC14
       .byte $00 ; |        | $BC15
       .byte $00 ; |        | $BC16
       .byte $00 ; |        | $BC17
       .byte $00 ; |        | $BC18
       .byte $00 ; |        | $BC19
       .byte $00 ; |        | $BC1A
       .byte $00 ; |        | $BC1B
       .byte $00 ; |        | $BC1C
       .byte $00 ; |        | $BC1D
       .byte $00 ; |        | $BC1E
       .byte $00 ; |        | $BC1F
       .byte $00 ; |        | $BC20
LBC21:
       .byte $00 ; |        | $BC21
       .byte $00 ; |        | $BC22
       .byte $00 ; |        | $BC23
       .byte $00 ; |        | $BC24
       .byte $00 ; |        | $BC25
       .byte $FF ; |XXXXXXXX| $BC26
       .byte $FF ; |XXXXXXXX| $BC27
       .byte $FF ; |XXXXXXXX| $BC28
       .byte $FF ; |XXXXXXXX| $BC29
       .byte $FF ; |XXXXXXXX| $BC2A
       .byte $FF ; |XXXXXXXX| $BC2B
       .byte $FF ; |XXXXXXXX| $BC2C
       .byte $AA ; |X X X X | $BC2D
       .byte $AA ; |X X X X | $BC2E
       .byte $AA ; |X X X X | $BC2F
       .byte $FF ; |XXXXXXXX| $BC30
       .byte $7F ; | XXXXXXX| $BC31
       .byte $55 ; | X X X X| $BC32
       .byte $55 ; | X X X X| $BC33
       .byte $7F ; | XXXXXXX| $BC34
       .byte $3F ; |  XXXXXX| $BC35
       .byte COLOR1+2 ; |   X  X | $BC36
       .byte COLOR1+4 ; |   X X  | $BC37
       .byte COLOR0+0 ; |        | $BC38
       .byte COLOR0+2 ; |      X | $BC39
       .byte COLOR0+2 ; |      X | $BC3A
       .byte COLOR0+0 ; |        | $BC3B
       .byte COLOR1+2 ; |   X  X | $BC3C
       .byte COLOR0+0 ; |        | $BC3D
       .byte COLOR0+0 ; |        | $BC3E
       .byte COLOR0+0 ; |        | $BC3F
       .byte COLOR1+2 ; |   X  X | $BC40
       .byte COLOR1+4 ; |   X X  | $BC41
       .byte COLOR0+0 ; |        | $BC42
       .byte COLOR0+0 ; |        | $BC43
       .byte COLOR1+2 ; |   X  X | $BC44
       .byte COLOR1+4 ; |   X X  | $BC45
LBC46:
       .byte $00 ; |        | $BC46
       .byte $00 ; |        | $BC47
       .byte $00 ; |        | $BC48
       .byte $00 ; |        | $BC49
       .byte $00 ; |        | $BC4A
       .byte $00 ; |        | $BC4B
       .byte $00 ; |        | $BC4C
       .byte $00 ; |        | $BC4D
       .byte $00 ; |        | $BC4E
       .byte $00 ; |        | $BC4F
       .byte $00 ; |        | $BC50
       .byte $00 ; |        | $BC51
       .byte $00 ; |        | $BC52
       .byte $00 ; |        | $BC53
       .byte $50 ; | X X    | $BC54
       .byte $50 ; | X X    | $BC55
       .byte $F0 ; |XXXX    | $BC56
       .byte $50 ; | X X    | $BC57
       .byte $50 ; | X X    | $BC58
       .byte $50 ; | X X    | $BC59
       .byte $50 ; | X X    | $BC5A
       .byte $70 ; | XXX    | $BC5B
       .byte $70 ; | XXX    | $BC5C
       .byte $E8 ; |XXX X   | $BC5D
       .byte $B8 ; |X XXX   | $BC5E
       .byte $B0 ; |X XX    | $BC5F
       .byte $F8 ; |XXXXX   | $BC60
       .byte $78 ; | XXXX   | $BC61
       .byte $60 ; | XX     | $BC62
       .byte $20 ; |  X     | $BC63
       .byte $14 ; |   X X  | $BC64
       .byte $3C ; |  XXXX  | $BC65
       .byte $3E ; |  XXXXX | $BC66
       .byte $3C ; |  XXXX  | $BC67
       .byte $1E ; |   XXXX | $BC68
       .byte $1C ; |   XXX  | $BC69
       .byte $08 ; |    X   | $BC6A
LBC6B:
       .byte COLOR0+0 ; |        | $BC6B
       .byte COLOR0+0 ; |        | $BC6C
       .byte COLOR0+0 ; |        | $BC6D
       .byte COLOR0+0 ; |        | $BC6E
       .byte COLOR0+0 ; |        | $BC6F
       .byte COLOR0+0 ; |        | $BC70
       .byte COLOR0+0 ; |        | $BC71
       .byte COLOR0+0 ; |        | $BC72
       .byte COLOR0+0 ; |        | $BC73
       .byte COLOR0+0 ; |        | $BC74
       .byte COLOR0+0 ; |        | $BC75
       .byte COLOR0+0 ; |        | $BC76
       .byte COLOR0+0 ; |        | $BC77
       .byte COLOR0+0 ; |        | $BC78
       .byte COLOR3+12; |  XXXX  | $BC79
       .byte COLOR3+12; |  XXXX  | $BC7A
       .byte COLOR3+12; |  XXXX  | $BC7B
       .byte COLOR3+4 ; |  XX X  | $BC7C
       .byte COLOR3+4 ; |  XX X  | $BC7D
       .byte COLOR3+4 ; |  XX X  | $BC7E
       .byte COLOR3+4 ; |  XX X  | $BC7F
       .byte COLOR4+0 ; | X      | $BC80
       .byte COLOR4+0 ; | X      | $BC81
       .byte COLOR4+0 ; | X      | $BC82
       .byte COLOR4+0 ; | X      | $BC83
       .byte COLOR4+0 ; | X      | $BC84
       .byte COLOR4+0 ; | X      | $BC85
       .byte COLOR4+0 ; | X      | $BC86
       .byte COLOR4+0 ; | X      | $BC87
       .byte COLOR3+12; |  XXXX  | $BC88
       .byte COLOR3+12; |  XXXX  | $BC89
       .byte COLOR3+12; |  XXXX  | $BC8A
       .byte COLOR3+12; |  XXXX  | $BC8B
       .byte COLOR3+12; |  XXXX  | $BC8C
       .byte COLOR3+12; |  XXXX  | $BC8D
       .byte COLOR3+12; |  XXXX  | $BC8E
       .byte COLOR3+12; |  XXXX  | $BC8F
LBC90:
       .byte COLOR0+0 ; |        | $BC90
       .byte COLOR0+0 ; |        | $BC91
       .byte COLOR8+0 ; |X       | $BC92
       .byte COLOR8+0 ; |X       | $BC93
       .byte COLOR8+0 ; |X       | $BC94
       .byte COLOR8+0 ; |X       | $BC95
       .byte COLOR4+0 ; | X      | $BC96
       .byte COLOR4+0 ; | X      | $BC97
       .byte COLOR4+0 ; | X      | $BC98
       .byte COLOR0+0 ; |        | $BC99
       .byte COLOR0+0 ; |        | $BC9A
LBC9B:
       .byte COLOR1+0 ; |   X    | $BC9B
       .byte COLOR1+2 ; |   X  X | $BC9C
       .byte COLOR1+4 ; |   X X  | $BC9D
       .byte COLOR1+6 ; |   X XX | $BC9E
       .byte COLOR1+0 ; |   X    | $BC9F
       .byte COLOR1+2 ; |   X  X | $BCA0
       .byte COLOR1+2 ; |   X  X | $BCA1
       .byte COLOR1+2 ; |   X  X | $BCA2
       .byte COLOR1+2 ; |   X  X | $BCA3
       .byte COLOR1+2 ; |   X  X | $BCA4
       .byte COLOR1+2 ; |   X  X | $BCA5
LBCA6:
       .byte COLOR1+4 ; |   X X  | $BCA6
       .byte COLOR1+2 ; |   X  X | $BCA7
       .byte COLOR1+6 ; |   X XX | $BCA8
       .byte COLOR1+4 ; |   X X  | $BCA9
       .byte COLOR1+4 ; |   X X  | $BCAA
       .byte COLOR1+4 ; |   X X  | $BCAB
       .byte COLOR1+4 ; |   X X  | $BCAC
       .byte COLOR1+4 ; |   X X  | $BCAD
       .byte COLOR1+4 ; |   X X  | $BCAE
       .byte COLOR1+2 ; |   X  X | $BCAF
       .byte COLOR1+6 ; |   X XX | $BCB0

;color pointers
LBF03:
       .byte <LD996 ; $BF03
       .byte <LD995 ; $BF04
       .byte <LD97E ; $BF05
       .byte <LD997 ; $BF06

LBF07:
       .byte >LD91E ; $BF07
       .byte >LD91D ; $BF08
       .byte >LD94E ; $BF09
       .byte >LD91F ; $BF0A

LBF0B:
       .byte >LD936 ; $BF0B
       .byte >LD935 ; $BF0C
       .byte >LD966 ; $BF0D
       .byte >LD937 ; $BF0E

LBF0F:
       .byte >LD996 ; $BF0F
       .byte >LD995 ; $BF10
       .byte >LD97E ; $BF11
       .byte >LD997 ; $BF12

LBF13:
       .byte <LD530 ; $BF13
       .byte <LD52F ; $BF14
       .byte <LD377 ; $BF15
       .byte <LD531 ; $BF16

LBF17:
       .byte >LD530 ; $BF17
       .byte >LD52F ; $BF18
       .byte >LD377 ; $BF19
       .byte >LD531 ; $BF1A

LBF1B:
       .byte <LD3BF ; $BF1B
       .byte <LD3BE ; $BF1C
       .byte <LD3D7 ; $BF1D
       .byte <LD3C0 ; $BF1E

LBF1F:
       .byte >LD3BF ; $BF1F
       .byte >LD3BE ; $BF20
       .byte >LD3D7 ; $BF21
       .byte >LD3C0 ; $BF22

LBF23:
       .byte <LD38F ; $BF23
       .byte <LD38E ; $BF24
       .byte <LD3A7 ; $BF25
       .byte <LD390 ; $BF26

LBF27:
       .byte >LD38F ; $BF27
       .byte >LD38E ; $BF28
       .byte >LD3A7 ; $BF29
       .byte >LD390 ; $BF2A

LBF2B:
       .byte <LD9AE ; $BF2B
       .byte <LD9AD ; $BF2C
       .byte <LD9C5 ; $BF2D
       .byte <LD9AE ; $BF2E

LBF2F:
       .byte >LD9AE ; $BF2F
       .byte >LD9AD ; $BF30
       .byte >LD9C5 ; $BF31
       .byte >LD9AE ; $BF32

LBF33:
       .byte <LD88C ; $BF33
       .byte <LD88B ; $BF34
       .byte <LD8AB ; $BF35
       .byte <LD88B ; $BF36

LBF37:
       .byte >LD88C ; $BF37
       .byte >LD88B ; $BF38
       .byte >LD8AB ; $BF39
       .byte >LD88B ; $BF3A

LBF3B:
       .byte <LD0C2 ; $BF3B
       .byte <LD0C1 ; $BF3C
       .byte <LD0B1 ; $BF3D
       .byte <LD0C1 ; $BF3E

LBCD7:
       .byte >LB4AE ; $BCD7
       .byte >LB488 ; $BCD8
       .byte >LB462 ; $BCD9
       .byte >LB53B ; $BCDA
       .byte >LB600 ; $BCDB
       .byte >LB672 ; $BCDC
       .byte >LB897 ; $BCDD
       .byte >LB462 ; $BCDE
       .byte >LB488 ; $BCDF
       .byte >LB957 ; $BCE0
       .byte >LBBBE ; $BCE1
       .byte >LB957 ; $BCE2
       .byte >LB900 ; $BCE3
       .byte >LB926 ; $BCE4
       .byte >LB9C9 ; $BCE5
       .byte >LBB26 ; $BCE6
       .byte >LBB26 ; $BCE7
       .byte >LBB26 ; $BCE8
       .byte >LBA6C ; $BCE9

       ORG  $2A00
       RORG $BA00

LBB00:
       .byte COLOR2+2 ; |  X   X | $BB00
       .byte COLOR2+2 ; |  X   X | $BB01
       .byte COLOR2+2 ; |  X   X | $BB02
       .byte COLOR2+2 ; |  X   X | $BB03
       .byte COLOR2+2 ; |  X   X | $BB04
       .byte COLOR2+2 ; |  X   X | $BB05
       .byte COLOR2+2 ; |  X   X | $BB06
       .byte COLOR2+2 ; |  X   X | $BB07
       .byte COLOR2+2 ; |  X   X | $BB08
       .byte COLOR2+2 ; |  X   X | $BB09
       .byte COLOR2+2 ; |  X   X | $BB0A
       .byte COLOR2+2 ; |  X   X | $BB0B
       .byte COLOR2+2 ; |  X   X | $BB0C
       .byte COLOR2+2 ; |  X   X | $BB0D
       .byte COLOR2+2 ; |  X   X | $BB0E
       .byte COLOR2+2 ; |  X   X | $BB0F
       .byte COLOR2+2 ; |  X   X | $BB10
       .byte COLOR2+2 ; |  X   X | $BB11
       .byte COLOR2+2 ; |  X   X | $BB12
       .byte COLOR2+2 ; |  X   X | $BB13
       .byte COLOR2+2 ; |  X   X | $BB14
       .byte COLOR2+2 ; |  X   X | $BB15
       .byte COLOR2+2 ; |  X   X | $BB16
       .byte COLOR2+2 ; |  X   X | $BB17
       .byte COLOR2+2 ; |  X   X | $BB18
       .byte COLOR2+2 ; |  X   X | $BB19
       .byte COLOR2+2 ; |  X   X | $BB1A
       .byte COLOR2+2 ; |  X   X | $BB1B
       .byte COLOR2+2 ; |  X   X | $BB1C
       .byte COLOR2+2 ; |  X   X | $BB1D
       .byte COLOR2+2 ; |  X   X | $BB1E
       .byte COLOR2+2 ; |  X   X | $BB1F
       .byte COLOR2+2 ; |  X   X | $BB20
       .byte COLOR2+2 ; |  X   X | $BB21
       .byte COLOR2+2 ; |  X   X | $BB22
       .byte COLOR2+2 ; |  X   X | $BB23
       .byte COLOR2+2 ; |  X   X | $BB24
       .byte COLOR2+2 ; |  X   X | $BB25
LBB26:
       .byte COLOR1+6 ; |   X XX | $BB26
       .byte COLOR1+2 ; |   X  X | $BB27
       .byte COLOR1+2 ; |   X  X | $BB28
       .byte COLOR1+2 ; |   X  X | $BB29
       .byte COLOR1+2 ; |   X  X | $BB2A
       .byte COLOR1+2 ; |   X  X | $BB2B
       .byte COLOR1+6 ; |   X XX | $BB2C
       .byte COLOR1+4 ; |   X X  | $BB2D
       .byte COLOR1+4 ; |   X X  | $BB2E
       .byte COLOR1+4 ; |   X X  | $BB2F
       .byte COLOR1+4 ; |   X X  | $BB30
       .byte COLOR1+2 ; |   X  X | $BB31
       .byte COLOR1+6 ; |   X XX | $BB32
       .byte COLOR1+4 ; |   X X  | $BB33
       .byte COLOR1+4 ; |   X X  | $BB34
       .byte COLOR1+4 ; |   X X  | $BB35
       .byte COLOR1+4 ; |   X X  | $BB36
       .byte COLOR1+4 ; |   X X  | $BB37
       .byte COLOR1+4 ; |   X X  | $BB38
       .byte COLOR1+2 ; |   X  X | $BB39
       .byte COLOR1+6 ; |   X XX | $BB3A
       .byte COLOR1+4 ; |   X X  | $BB3B
       .byte COLOR1+4 ; |   X X  | $BB3C
       .byte COLOR1+4 ; |   X X  | $BB3D
       .byte COLOR1+4 ; |   X X  | $BB3E
       .byte COLOR1+4 ; |   X X  | $BB3F
       .byte COLOR1+4 ; |   X X  | $BB40
       .byte COLOR1+2 ; |   X  X | $BB41
       .byte COLOR1+6 ; |   X XX | $BB42
       .byte COLOR1+4 ; |   X X  | $BB43
       .byte COLOR1+4 ; |   X X  | $BB44
       .byte COLOR1+4 ; |   X X  | $BB45
       .byte COLOR1+4 ; |   X X  | $BB46
       .byte COLOR1+4 ; |   X X  | $BB47
       .byte COLOR1+4 ; |   X X  | $BB48
       .byte COLOR1+2 ; |   X  X | $BB49
       .byte COLOR1+6 ; |   X XX | $BB4A
       .byte COLOR1+4 ; |   X X  | $BB4B
LBB4C:
       .byte $00 ; |        | $BB4C
       .byte $00 ; |        | $BB4D
       .byte $00 ; |        | $BB4E
       .byte $00 ; |        | $BB4F
       .byte $E0 ; |XXX     | $BB50
       .byte $E0 ; |XXX     | $BB51
       .byte $E0 ; |XXX     | $BB52
       .byte $E0 ; |XXX     | $BB53
       .byte $E0 ; |XXX     | $BB54
       .byte $E0 ; |XXX     | $BB55
       .byte $E0 ; |XXX     | $BB56
       .byte $E0 ; |XXX     | $BB57
       .byte $E0 ; |XXX     | $BB58
       .byte $E0 ; |XXX     | $BB59
       .byte $E0 ; |XXX     | $BB5A
       .byte $E0 ; |XXX     | $BB5B
       .byte $E0 ; |XXX     | $BB5C
       .byte $E0 ; |XXX     | $BB5D
       .byte $E0 ; |XXX     | $BB5E
       .byte $E0 ; |XXX     | $BB5F
       .byte $E0 ; |XXX     | $BB60
       .byte $E0 ; |XXX     | $BB61
       .byte $E0 ; |XXX     | $BB62
       .byte $E0 ; |XXX     | $BB63
       .byte $E0 ; |XXX     | $BB64
       .byte $E0 ; |XXX     | $BB65
       .byte $E0 ; |XXX     | $BB66
       .byte $E0 ; |XXX     | $BB67
       .byte $E0 ; |XXX     | $BB68
       .byte $E0 ; |XXX     | $BB69
       .byte $E0 ; |XXX     | $BB6A
       .byte $E0 ; |XXX     | $BB6B
       .byte $E0 ; |XXX     | $BB6C
       .byte $E0 ; |XXX     | $BB6D
       .byte $E0 ; |XXX     | $BB6E
       .byte $E0 ; |XXX     | $BB6F
       .byte $E0 ; |XXX     | $BB70
       .byte $E0 ; |XXX     | $BB71
LBB72:
       .byte $00 ; |        | $BB72
       .byte $00 ; |        | $BB73
       .byte $00 ; |        | $BB74
       .byte $00 ; |        | $BB75
       .byte $3F ; |  XXXXXX| $BB76
       .byte $3E ; |  XXXXX | $BB77
       .byte $3C ; |  XXXX  | $BB78
       .byte $3C ; |  XXXX  | $BB79
       .byte $3E ; |  XXXXX | $BB7A
       .byte $3F ; |  XXXXXX| $BB7B
       .byte $7B ; | XXXX XX| $BB7C
       .byte $79 ; | XXXX  X| $BB7D
       .byte $70 ; | XXX    | $BB7E
       .byte $70 ; | XXX    | $BB7F
       .byte $70 ; | XXX    | $BB80
       .byte $70 ; | XXX    | $BB81
       .byte $70 ; | XXX    | $BB82
       .byte $60 ; | XX     | $BB83
       .byte $60 ; | XX     | $BB84
       .byte $60 ; | XX     | $BB85
       .byte $60 ; | XX     | $BB86
       .byte $E0 ; |XXX     | $BB87
       .byte $E0 ; |XXX     | $BB88
       .byte $E0 ; |XXX     | $BB89
       .byte $C0 ; |XX      | $BB8A
       .byte $C0 ; |XX      | $BB8B
       .byte $C0 ; |XX      | $BB8C
       .byte $C0 ; |XX      | $BB8D
       .byte $C0 ; |XX      | $BB8E
       .byte $C0 ; |XX      | $BB8F
       .byte $C0 ; |XX      | $BB90
       .byte $C4 ; |XX   X  | $BB91
       .byte $CC ; |XX  XX  | $BB92
       .byte $D9 ; |XX XX  X| $BB93
       .byte $FB ; |XXXXX XX| $BB94
       .byte $7E ; | XXXXXX | $BB95
       .byte $3E ; |  XXXXX | $BB96
       .byte $3F ; |  XXXXXX| $BB97
LBB98:
       .byte $00 ; |        | $BB98
       .byte $FF ; |XXXXXXXX| $BB99
       .byte $FF ; |XXXXXXXX| $BB9A
       .byte $FF ; |XXXXXXXX| $BB9B
       .byte $FF ; |XXXXXXXX| $BB9C
       .byte $FF ; |XXXXXXXX| $BB9D
       .byte $FF ; |XXXXXXXX| $BB9E
       .byte $FF ; |XXXXXXXX| $BB9F
       .byte $FF ; |XXXXXXXX| $BBA0
       .byte $FF ; |XXXXXXXX| $BBA1
       .byte $FF ; |XXXXXXXX| $BBA2
       .byte $FF ; |XXXXXXXX| $BBA3
       .byte $FF ; |XXXXXXXX| $BBA4
       .byte $FF ; |XXXXXXXX| $BBA5
       .byte $FF ; |XXXXXXXX| $BBA6
       .byte $FF ; |XXXXXXXX| $BBA7
       .byte $FF ; |XXXXXXXX| $BBA8
       .byte $FF ; |XXXXXXXX| $BBA9
       .byte $FF ; |XXXXXXXX| $BBAA
       .byte $FF ; |XXXXXXXX| $BBAB
       .byte $FF ; |XXXXXXXX| $BBAC
       .byte $FF ; |XXXXXXXX| $BBAD
       .byte $FF ; |XXXXXXXX| $BBAE
       .byte $FF ; |XXXXXXXX| $BBAF
       .byte $FF ; |XXXXXXXX| $BBB0
       .byte $FF ; |XXXXXXXX| $BBB1
       .byte $FF ; |XXXXXXXX| $BBB2
       .byte $FF ; |XXXXXXXX| $BBB3
       .byte $7E ; | XXXXXX | $BBB4
       .byte $3C ; |  XXXX  | $BBB5
       .byte $00 ; |        | $BBB6
       .byte $00 ; |        | $BBB7
       .byte $00 ; |        | $BBB8
       .byte $00 ; |        | $BBB9
       .byte $00 ; |        | $BBBA
       .byte $00 ; |        | $BBBB
       .byte $00 ; |        | $BBBC
       .byte $00 ; |        | $BBBD

LBBBE:
       .byte COLORC+2 ; |XX    X | $BBBE
       .byte COLOR8+12; |X   XX  | $BBBF
       .byte COLOR8+12; |X   XX  | $BBC0
       .byte COLOR0+2 ; |      X | $BBC1
       .byte COLOR0+2 ; |      X | $BBC2
       .byte COLOR0+2 ; |      X | $BBC3
       .byte COLOR0+2 ; |      X | $BBC4
       .byte COLOR8+4 ; |X    X  | $BBC5
       .byte COLOR8+8 ; |X   X   | $BBC6
       .byte COLOR8+8 ; |X   X   | $BBC7
       .byte COLOR8+8 ; |X   X   | $BBC8
       .byte COLOR8+4 ; |X    X  | $BBC9
       .byte COLOR0+2 ; |      X | $BBCA
       .byte COLOR0+2 ; |      X | $BBCB
       .byte COLOR0+2 ; |      X | $BBCC
       .byte COLOR0+2 ; |      X | $BBCD
       .byte COLOR0+2 ; |      X | $BBCE
       .byte COLOR0+2 ; |      X | $BBCF
       .byte COLOR0+2 ; |      X | $BBD0
       .byte COLOR0+2 ; |      X | $BBD1
       .byte COLOR0+2 ; |      X | $BBD2
       .byte COLOR0+2 ; |      X | $BBD3
       .byte COLOR0+2 ; |      X | $BBD4
       .byte COLOR0+2 ; |      X | $BBD5
       .byte COLOR0+2 ; |      X | $BBD6
       .byte COLOR0+2 ; |      X | $BBD7
       .byte COLOR0+2 ; |      X | $BBD8
       .byte COLOR0+2 ; |      X | $BBD9
       .byte COLOR0+2 ; |      X | $BBDA
       .byte COLOR0+2 ; |      X | $BBDB
       .byte COLOR0+2 ; |      X | $BBDC
       .byte COLOR0+2 ; |      X | $BBDD
       .byte COLOR0+2 ; |      X | $BBDE
       .byte COLOR0+2 ; |      X | $BBDF
       .byte COLORC+4 ; |XX   X  | $BBE0
       .byte COLORC+4 ; |XX   X  | $BBE1
       .byte COLORC+2 ; |XX    X | $BBE2
       .byte COLORC+2 ; |XX    X | $BBE3
LBBE4:
       .byte COLORC+2 ; |XX    X | $BBE4
       .byte COLORC+4 ; |XX   X  | $BBE5
       .byte COLORC+4 ; |XX   X  | $BBE6
       .byte COLORC+4 ; |XX   X  | $BBE7
       .byte COLORC+4 ; |XX   X  | $BBE8
       .byte COLORC+4 ; |XX   X  | $BBE9
       .byte COLORC+6 ; |XX   XX | $BBEA
       .byte COLORC+6 ; |XX   XX | $BBEB
       .byte COLORC+8 ; |XX  X   | $BBEC
       .byte COLORC+8 ; |XX  X   | $BBED
       .byte COLORC+4 ; |XX   X  | $BBEE
LBBEF:
       .byte COLORC+6 ; |XX   XX | $BBEF
       .byte COLORC+6 ; |XX   XX | $BBF0
       .byte COLORC+6 ; |XX   XX | $BBF1
       .byte COLORC+6 ; |XX   XX | $BBF2
       .byte COLORC+6 ; |XX   XX | $BBF3
       .byte COLORC+6 ; |XX   XX | $BBF4
       .byte COLORC+6 ; |XX   XX | $BBF5
       .byte COLORC+6 ; |XX   XX | $BBF6
       .byte COLORC+6 ; |XX   XX | $BBF7
       .byte COLORC+6 ; |XX   XX | $BBF8
       .byte COLORC+6 ; |XX   XX | $BBF9

;unused bytes
       .byte $00 ; |        | $BBFA
       .byte $00 ; |        | $BBFB

LBF47:
       .byte >LD511 ; $BF47
       .byte >LD510 ; $BF48
       .byte >LD500 ; $BF49
       .byte >LD510 ; $BF4A

       ORG  $2B00
       RORG $BB00

LB800:
       .byte $00 ; |        | $B800
       .byte $00 ; |        | $B801
       .byte $36 ; |  XX XX | $B802
       .byte $36 ; |  XX XX | $B803
       .byte $36 ; |  XX XX | $B804
       .byte $36 ; |  XX XX | $B805
       .byte $36 ; |  XX XX | $B806
       .byte $36 ; |  XX XX | $B807
       .byte $36 ; |  XX XX | $B808
       .byte $36 ; |  XX XX | $B809
       .byte $36 ; |  XX XX | $B80A
       .byte $36 ; |  XX XX | $B80B
       .byte $36 ; |  XX XX | $B80C
       .byte $36 ; |  XX XX | $B80D
       .byte $36 ; |  XX XX | $B80E
       .byte $36 ; |  XX XX | $B80F
       .byte $36 ; |  XX XX | $B810
       .byte $36 ; |  XX XX | $B811
       .byte $36 ; |  XX XX | $B812
       .byte $36 ; |  XX XX | $B813
LB814:
       .byte $00 ; |        | $B814
       .byte $00 ; |        | $B815
       .byte $00 ; |        | $B816
       .byte $00 ; |        | $B817
       .byte $00 ; |        | $B818
       .byte $00 ; |        | $B819
       .byte $00 ; |        | $B81A
       .byte $00 ; |        | $B81B
       .byte $00 ; |        | $B81C
       .byte $00 ; |        | $B81D
       .byte $00 ; |        | $B81E
       .byte $00 ; |        | $B81F
       .byte $00 ; |        | $B820
       .byte $00 ; |        | $B821
       .byte $00 ; |        | $B822
       .byte $00 ; |        | $B823
       .byte $00 ; |        | $B824
       .byte $00 ; |        | $B825
       .byte $00 ; |        | $B826
       .byte $00 ; |        | $B827
       .byte $00 ; |        | $B828
       .byte $00 ; |        | $B829
       .byte $00 ; |        | $B82A
       .byte $00 ; |        | $B82B
       .byte $00 ; |        | $B82C
       .byte $00 ; |        | $B82D
       .byte $00 ; |        | $B82E
       .byte $00 ; |        | $B82F
       .byte $00 ; |        | $B830
       .byte $80 ; |X       | $B831
       .byte $F8 ; |XXXXX   | $B832
       .byte $00 ; |        | $B833
       .byte $F8 ; |XXXXX   | $B834
       .byte $81 ; |X      X| $B835
       .byte $0F ; |    XXXX| $B836
       .byte $00 ; |        | $B837
       .byte $0F ; |    XXXX| $B838
       .byte $01 ; |       X| $B839
LB83A:
       .byte $06 ; |     XX | $B83A
       .byte $04 ; |     X  | $B83B
       .byte $02 ; |      X | $B83C
       .byte $00 ; |        | $B83D
LB83E:
       .byte $00 ; |        | $B83E
       .byte $00 ; |        | $B83F
       .byte $00 ; |        | $B840
       .byte $00 ; |        | $B841
       .byte $00 ; |        | $B842
       .byte $00 ; |        | $B843
       .byte $00 ; |        | $B844
       .byte $00 ; |        | $B845
       .byte $00 ; |        | $B846
       .byte $00 ; |        | $B847
       .byte $00 ; |        | $B848
       .byte $00 ; |        | $B849
       .byte $00 ; |        | $B84A
       .byte $00 ; |        | $B84B
       .byte $00 ; |        | $B84C
       .byte $00 ; |        | $B84D
       .byte $00 ; |        | $B84E
       .byte $00 ; |        | $B84F
       .byte $00 ; |        | $B850
       .byte $00 ; |        | $B851
       .byte $00 ; |        | $B852
       .byte $00 ; |        | $B853
       .byte $00 ; |        | $B854
       .byte $00 ; |        | $B855
       .byte $00 ; |        | $B856
       .byte $00 ; |        | $B857
       .byte $00 ; |        | $B858
       .byte $00 ; |        | $B859
       .byte $00 ; |        | $B85A
       .byte $00 ; |        | $B85B
       .byte $00 ; |        | $B85C
       .byte $00 ; |        | $B85D
       .byte $00 ; |        | $B85E
       .byte $00 ; |        | $B85F
       .byte $0E ; |    XXX | $B860
       .byte $04 ; |     X  | $B861
       .byte $00 ; |        | $B862
       .byte $00 ; |        | $B863
LB864:
       .byte $00 ; |        | $B864
       .byte $7E ; | XXXXXX | $B865
       .byte $7E ; | XXXXXX | $B866
       .byte $7E ; | XXXXXX | $B867
       .byte $7E ; | XXXXXX | $B868
       .byte $7E ; | XXXXXX | $B869
       .byte $7E ; | XXXXXX | $B86A
       .byte $7E ; | XXXXXX | $B86B
       .byte $7E ; | XXXXXX | $B86C
       .byte $7E ; | XXXXXX | $B86D
       .byte $7E ; | XXXXXX | $B86E
       .byte $7E ; | XXXXXX | $B86F
       .byte $3C ; |  XXXX  | $B870
LB871:
       .byte $00 ; |        | $B871
       .byte $00 ; |        | $B872
       .byte $00 ; |        | $B873
       .byte $00 ; |        | $B874
       .byte $00 ; |        | $B875
       .byte $00 ; |        | $B876
       .byte $00 ; |        | $B877
       .byte $00 ; |        | $B878
       .byte $00 ; |        | $B879
       .byte $00 ; |        | $B87A
       .byte $00 ; |        | $B87B
       .byte $00 ; |        | $B87C
       .byte $00 ; |        | $B87D
       .byte $00 ; |        | $B87E
       .byte $00 ; |        | $B87F
       .byte $00 ; |        | $B880
       .byte $00 ; |        | $B881
       .byte $00 ; |        | $B882
       .byte $00 ; |        | $B883
       .byte $00 ; |        | $B884
       .byte $00 ; |        | $B885
       .byte $00 ; |        | $B886
       .byte $00 ; |        | $B887
       .byte $00 ; |        | $B888
       .byte $00 ; |        | $B889
       .byte $00 ; |        | $B88A
       .byte $00 ; |        | $B88B
       .byte $00 ; |        | $B88C
       .byte $00 ; |        | $B88D
       .byte $00 ; |        | $B88E
       .byte $00 ; |        | $B88F
       .byte $00 ; |        | $B890
       .byte $00 ; |        | $B891
       .byte $00 ; |        | $B892
       .byte $80 ; |X       | $B893
       .byte $C0 ; |XX      | $B894
       .byte $00 ; |        | $B895
       .byte $00 ; |        | $B896
LB897:
       .byte $00 ; |        | $B897
       .byte $04 ; |     X  | $B898
       .byte $04 ; |     X  | $B899
       .byte $04 ; |     X  | $B89A
       .byte $04 ; |     X  | $B89B
       .byte $02 ; |      X | $B89C

       .byte COLOR3+4 ; |  XX X  | $B89D
       .byte COLOR3+4 ; |  XX X  | $B89E
       .byte COLOR3+4 ; |  XX X  | $B89F
       .byte COLOR3+4 ; |  XX X  | $B8A0
       .byte COLOR3+4 ; |  XX X  | $B8A1
       .byte COLOR3+4 ; |  XX X  | $B8A2
       .byte COLOR3+4 ; |  XX X  | $B8A3
       .byte COLOR3+4 ; |  XX X  | $B8A4
       .byte COLOR3+4 ; |  XX X  | $B8A5
       .byte COLOR3+4 ; |  XX X  | $B8A6
       .byte COLOR3+4 ; |  XX X  | $B8A7
       .byte COLOR3+4 ; |  XX X  | $B8A8
       .byte COLOR3+4 ; |  XX X  | $B8A9
       .byte COLOR3+4 ; |  XX X  | $B8AA
       .byte COLOR3+4 ; |  XX X  | $B8AB
       .byte COLOR3+4 ; |  XX X  | $B8AC
       .byte COLOR3+4 ; |  XX X  | $B8AD
       .byte COLOR3+4 ; |  XX X  | $B8AE
       .byte COLOR3+4 ; |  XX X  | $B8AF
       .byte COLOR3+4 ; |  XX X  | $B8B0
       .byte COLOR3+4 ; |  XX X  | $B8B1
       .byte COLOR3+4 ; |  XX X  | $B8B2
       .byte COLOR3+4 ; |  XX X  | $B8B3
       .byte COLOR3+4 ; |  XX X  | $B8B4
       .byte COLOR3+4 ; |  XX X  | $B8B5
       .byte COLOR3+4 ; |  XX X  | $B8B6
       .byte COLOR3+4 ; |  XX X  | $B8B7
       .byte COLOR3+4 ; |  XX X  | $B8B8
       .byte COLOR3+4 ; |  XX X  | $B8B9
       .byte COLOR3+4 ; |  XX X  | $B8BA
       .byte COLOR3+4 ; |  XX X  | $B8BB
       .byte COLOR3+4 ; |  XX X  | $B8BC
LB8BD:
       .byte COLOR0+4 ; |     X  | $B8BD
       .byte COLOR0+6 ; |     XX | $B8BE
       .byte COLOR0+6 ; |     XX | $B8BF
       .byte COLOR0+6 ; |     XX | $B8C0
       .byte COLOR0+6 ; |     XX | $B8C1
       .byte COLOR0+6 ; |     XX | $B8C2
       .byte COLOR0+6 ; |     XX | $B8C3
       .byte COLOR0+4 ; |     X  | $B8C4
       .byte COLOR0+6 ; |     XX | $B8C5
       .byte COLOR0+6 ; |     XX | $B8C6
       .byte COLOR0+6 ; |     XX | $B8C7
       .byte COLOR0+6 ; |     XX | $B8C8
       .byte COLOR0+6 ; |     XX | $B8C9
       .byte COLOR0+4 ; |     X  | $B8CA
       .byte COLOR0+6 ; |     XX | $B8CB
       .byte COLOR0+6 ; |     XX | $B8CC
       .byte COLOR0+6 ; |     XX | $B8CD
       .byte COLOR0+6 ; |     XX | $B8CE
       .byte COLOR0+6 ; |     XX | $B8CF
       .byte COLOR0+4 ; |     X  | $B8D0
       .byte COLOR0+6 ; |     XX | $B8D1
       .byte COLOR0+6 ; |     XX | $B8D2
       .byte COLOR0+6 ; |     XX | $B8D3
       .byte COLOR0+6 ; |     XX | $B8D4
       .byte COLOR0+6 ; |     XX | $B8D5
       .byte COLOR0+4 ; |     X  | $B8D6
       .byte COLOR0+6 ; |     XX | $B8D7
       .byte COLOR0+6 ; |     XX | $B8D8
       .byte COLOR0+6 ; |     XX | $B8D9
       .byte COLOR0+6 ; |     XX | $B8DA
       .byte COLOR0+4 ; |     X  | $B8DB
       .byte COLOR0+4 ; |     X  | $B8DC
       .byte COLOR0+4 ; |     X  | $B8DD
       .byte COLOR0+4 ; |     X  | $B8DE
       .byte COLOR0+4 ; |     X  | $B8DF
       .byte COLOR0+4 ; |     X  | $B8E0
       .byte COLOR0+4 ; |     X  | $B8E1
       .byte COLOR0+4 ; |     X  | $B8E2
       .byte COLOR0+4 ; |     X  | $B8E3

LB8E4:
       .byte $00 ; |        | $B8E4
       .byte $FF ; |XXXXXXXX| $B8E5
       .byte $FF ; |XXXXXXXX| $B8E6
       .byte $FE ; |XXXXXXX | $B8E7
       .byte $7C ; | XXXXX  | $B8E8
       .byte $38 ; |  XXX   | $B8E9
       .byte $10 ; |   X    | $B8EA
LB8EB:
       .byte $00 ; |        | $B8EB
       .byte $00 ; |        | $B8EC
       .byte $00 ; |        | $B8ED
       .byte $00 ; |        | $B8EE
       .byte $00 ; |        | $B8EF
       .byte $00 ; |        | $B8F0
       .byte $00 ; |        | $B8F1
       .byte $00 ; |        | $B8F2
       .byte $04 ; |     X  | $B8F3
       .byte $0E ; |    XXX | $B8F4
       .byte $1F ; |   XXXXX| $B8F5
       .byte $00 ; |        | $B8F6
       .byte $00 ; |        | $B8F7
       .byte $00 ; |        | $B8F8
       .byte $00 ; |        | $B8F9
       .byte $00 ; |        | $B8FA
       .byte $00 ; |        | $B8FB
       .byte $00 ; |        | $B8FC
       .byte $00 ; |        | $B8FD
       .byte $00 ; |        | $B8FE
       .byte $00 ; |        | $B8FF

       ORG  $2C00
       RORG $BC00

LB900:
       .byte COLORC+2 ; |XX    X | $B900
       .byte COLOR2+0 ; |  X     | $B901
       .byte COLOR2+4 ; |  X  X  | $B902
       .byte COLOR2+4 ; |  X  X  | $B903
       .byte COLOR2+4 ; |  X  X  | $B904
       .byte COLOR2+4 ; |  X  X  | $B905
       .byte COLOR2+4 ; |  X  X  | $B906
       .byte COLOR2+2 ; |  X   X | $B907
       .byte COLOR2+0 ; |  X     | $B908
       .byte COLOR2+4 ; |  X  X  | $B909
       .byte COLOR2+4 ; |  X  X  | $B90A
       .byte COLOR2+4 ; |  X  X  | $B90B
       .byte COLOR2+4 ; |  X  X  | $B90C
       .byte COLOR2+4 ; |  X  X  | $B90D
       .byte COLOR2+4 ; |  X  X  | $B90E
       .byte COLOR2+4 ; |  X  X  | $B90F
       .byte COLOR2+2 ; |  X   X | $B910
       .byte COLOR2+0 ; |  X     | $B911
       .byte COLOR2+4 ; |  X  X  | $B912
       .byte COLOR2+4 ; |  X  X  | $B913
       .byte COLOR2+4 ; |  X  X  | $B914
       .byte COLOR2+4 ; |  X  X  | $B915
       .byte COLOR2+4 ; |  X  X  | $B916
       .byte COLOR2+2 ; |  X   X | $B917
       .byte COLOR2+0 ; |  X     | $B918
       .byte COLOR0+2 ; |      X | $B919
       .byte COLOR0+2 ; |      X | $B91A
       .byte COLOR0+2 ; |      X | $B91B
       .byte COLOR0+2 ; |      X | $B91C
       .byte COLOR0+2 ; |      X | $B91D
       .byte COLOR0+2 ; |      X | $B91E
       .byte COLOR0+2 ; |      X | $B91F
       .byte COLOR0+2 ; |      X | $B920
       .byte COLOR0+2 ; |      X | $B921
       .byte COLOR0+2 ; |      X | $B922
       .byte COLOR0+2 ; |      X | $B923
       .byte COLOR0+2 ; |      X | $B924
       .byte COLOR0+2 ; |      X | $B925
LB926:
       .byte COLORC+2 ; |XX    X | $B926
       .byte COLOR0+2 ; |      X | $B927
       .byte COLOR0+2 ; |      X | $B928
       .byte COLOR0+2 ; |      X | $B929
       .byte COLOR0+2 ; |      X | $B92A
       .byte COLOR0+2 ; |      X | $B92B
       .byte COLOR0+2 ; |      X | $B92C
       .byte COLOR0+6 ; |     XX | $B92D
       .byte COLOR0+2 ; |      X | $B92E
       .byte COLOR0+2 ; |      X | $B92F
       .byte COLOR0+6 ; |     XX | $B930
LB931:
       .byte COLOR0+2 ; |      X | $B931
       .byte COLOR0+2 ; |      X | $B932
       .byte COLOR0+2 ; |      X | $B933
       .byte COLOR0+2 ; |      X | $B934
       .byte COLOR0+2 ; |      X | $B935
       .byte COLOR0+2 ; |      X | $B936
       .byte COLOR0+2 ; |      X | $B937
       .byte COLOR0+2 ; |      X | $B938
       .byte COLOR0+2 ; |      X | $B939
       .byte COLOR0+2 ; |      X | $B93A
       .byte COLOR0+2 ; |      X | $B93B
       .byte COLOR0+2 ; |      X | $B93C
       .byte COLOR0+2 ; |      X | $B93D
       .byte COLOR0+2 ; |      X | $B93E
       .byte COLOR0+2 ; |      X | $B93F
       .byte COLOR0+2 ; |      X | $B940
       .byte COLOR0+2 ; |      X | $B941
       .byte COLOR0+2 ; |      X | $B942
       .byte COLOR0+2 ; |      X | $B943
       .byte COLOR0+2 ; |      X | $B944
       .byte COLOR0+2 ; |      X | $B945
       .byte COLOR0+2 ; |      X | $B946
       .byte COLOR0+2 ; |      X | $B947
       .byte COLOR0+2 ; |      X | $B948
       .byte COLOR0+2 ; |      X | $B949
       .byte COLOR0+2 ; |      X | $B94A
       .byte COLOR0+2 ; |      X | $B94B
       .byte COLOR0+2 ; |      X | $B94C
       .byte COLOR0+2 ; |      X | $B94D
       .byte COLOR0+2 ; |      X | $B94E
       .byte COLOR0+2 ; |      X | $B94F
       .byte COLOR0+2 ; |      X | $B950
       .byte COLOR0+2 ; |      X | $B951
       .byte COLOR0+2 ; |      X | $B952
       .byte COLOR0+2 ; |      X | $B953
       .byte COLOR0+2 ; |      X | $B954
       .byte COLOR0+2 ; |      X | $B955
       .byte COLOR0+2 ; |      X | $B956
LB957:
       .byte COLOR1+4 ; |   X X  | $B957
       .byte COLOR1+4 ; |   X X  | $B958
       .byte COLOR1+4 ; |   X X  | $B959
       .byte COLOR1+4 ; |   X X  | $B95A
       .byte COLOR1+2 ; |   X  X | $B95B
       .byte COLOR1+2 ; |   X  X | $B95C
       .byte COLOR1+0 ; |   X    | $B95D
       .byte COLOR0+2 ; |      X | $B95E
       .byte COLOR0+2 ; |      X | $B95F
       .byte COLOR0+2 ; |      X | $B960
       .byte COLOR0+2 ; |      X | $B961
       .byte COLOR0+2 ; |      X | $B962
       .byte COLOR0+2 ; |      X | $B963
       .byte COLOR0+2 ; |      X | $B964
       .byte COLOR0+2 ; |      X | $B965
       .byte COLOR0+2 ; |      X | $B966
       .byte COLOR0+2 ; |      X | $B967
       .byte COLOR0+2 ; |      X | $B968
       .byte COLOR0+2 ; |      X | $B969
       .byte COLOR0+2 ; |      X | $B96A
       .byte COLOR0+2 ; |      X | $B96B
       .byte COLOR0+2 ; |      X | $B96C
       .byte COLOR0+2 ; |      X | $B96D
       .byte COLOR0+2 ; |      X | $B96E
       .byte COLOR0+2 ; |      X | $B96F
       .byte COLOR0+2 ; |      X | $B970
       .byte COLOR0+2 ; |      X | $B971
       .byte COLOR0+2 ; |      X | $B972
       .byte COLOR0+2 ; |      X | $B973
       .byte COLOR0+2 ; |      X | $B974
       .byte COLOR0+2 ; |      X | $B975
       .byte COLOR0+2 ; |      X | $B976
       .byte COLOR0+2 ; |      X | $B977
       .byte COLOR0+2 ; |      X | $B978
       .byte COLORC+4 ; |XX   X  | $B979
       .byte COLORC+4 ; |XX   X  | $B97A
       .byte COLORC+2 ; |XX    X | $B97B
       .byte COLORC+2 ; |XX    X | $B97C
LB97D:
       .byte $00 ; |        | $B97D
       .byte $FC ; |XXXXXX  | $B97E
       .byte $FC ; |XXXXXX  | $B97F
       .byte $FC ; |XXXXXX  | $B980
       .byte $FC ; |XXXXXX  | $B981
       .byte $FC ; |XXXXXX  | $B982
       .byte $FC ; |XXXXXX  | $B983
       .byte $FC ; |XXXXXX  | $B984
       .byte $FC ; |XXXXXX  | $B985
       .byte $FF ; |XXXXXXXX| $B986
       .byte $FF ; |XXXXXXXX| $B987
       .byte $FF ; |XXXXXXXX| $B988
       .byte $FF ; |XXXXXXXX| $B989
       .byte $FF ; |XXXXXXXX| $B98A
       .byte $FF ; |XXXXXXXX| $B98B
       .byte $FF ; |XXXXXXXX| $B98C
       .byte $FF ; |XXXXXXXX| $B98D
       .byte $FF ; |XXXXXXXX| $B98E
       .byte $FF ; |XXXXXXXX| $B98F
       .byte $FF ; |XXXXXXXX| $B990
       .byte $FF ; |XXXXXXXX| $B991
       .byte $FF ; |XXXXXXXX| $B992
       .byte $FF ; |XXXXXXXX| $B993
       .byte $FF ; |XXXXXXXX| $B994
       .byte $FF ; |XXXXXXXX| $B995
       .byte $FF ; |XXXXXXXX| $B996
       .byte $FF ; |XXXXXXXX| $B997
       .byte $FF ; |XXXXXXXX| $B998
       .byte $FF ; |XXXXXXXX| $B999
       .byte $FF ; |XXXXXXXX| $B99A
       .byte $FF ; |XXXXXXXX| $B99B
       .byte $FF ; |XXXXXXXX| $B99C
       .byte $FF ; |XXXXXXXX| $B99D
       .byte $FF ; |XXXXXXXX| $B99E
       .byte $FF ; |XXXXXXXX| $B99F
       .byte $FF ; |XXXXXXXX| $B9A0
       .byte $FF ; |XXXXXXXX| $B9A1
       .byte $FF ; |XXXXXXXX| $B9A2
LB9A3:
       .byte $00 ; |        | $B9A3
       .byte $80 ; |X       | $B9A4
       .byte $C0 ; |XX      | $B9A5
       .byte $E0 ; |XXX     | $B9A6
       .byte $F0 ; |XXXX    | $B9A7
       .byte $F8 ; |XXXXX   | $B9A8
       .byte $FC ; |XXXXXX  | $B9A9
       .byte $FE ; |XXXXXXX | $B9AA
       .byte $FF ; |XXXXXXXX| $B9AB
       .byte $FF ; |XXXXXXXX| $B9AC
       .byte $FF ; |XXXXXXXX| $B9AD
       .byte $FF ; |XXXXXXXX| $B9AE
       .byte $FF ; |XXXXXXXX| $B9AF
       .byte $FF ; |XXXXXXXX| $B9B0
       .byte $FF ; |XXXXXXXX| $B9B1
       .byte $FF ; |XXXXXXXX| $B9B2
       .byte $FF ; |XXXXXXXX| $B9B3
       .byte $FF ; |XXXXXXXX| $B9B4
       .byte $FF ; |XXXXXXXX| $B9B5
       .byte $FF ; |XXXXXXXX| $B9B6
       .byte $FF ; |XXXXXXXX| $B9B7
       .byte $FF ; |XXXXXXXX| $B9B8
       .byte $FF ; |XXXXXXXX| $B9B9
       .byte $FF ; |XXXXXXXX| $B9BA
       .byte $FF ; |XXXXXXXX| $B9BB
       .byte $FF ; |XXXXXXXX| $B9BC
       .byte $FF ; |XXXXXXXX| $B9BD
       .byte $FF ; |XXXXXXXX| $B9BE
       .byte $FF ; |XXXXXXXX| $B9BF
       .byte $FF ; |XXXXXXXX| $B9C0
       .byte $7F ; | XXXXXXX| $B9C1
       .byte $3F ; |  XXXXXX| $B9C2
       .byte $1F ; |   XXXXX| $B9C3
       .byte $0F ; |    XXXX| $B9C4
       .byte $07 ; |     XXX| $B9C5
       .byte $03 ; |      XX| $B9C6
       .byte $01 ; |       X| $B9C7
       .byte $00 ; |        | $B9C8
LB9C9:
       .byte $04 ; |     X  | $B9C9
       .byte $04 ; |     X  | $B9CA
       .byte $04 ; |     X  | $B9CB
       .byte $04 ; |     X  | $B9CC
       .byte $04 ; |     X  | $B9CD
       .byte $04 ; |     X  | $B9CE
       .byte $04 ; |     X  | $B9CF
       .byte $04 ; |     X  | $B9D0
       .byte $04 ; |     X  | $B9D1
       .byte $06 ; |     XX | $B9D2
       .byte $06 ; |     XX | $B9D3
       .byte $06 ; |     XX | $B9D4
       .byte $06 ; |     XX | $B9D5
       .byte $06 ; |     XX | $B9D6
       .byte $04 ; |     X  | $B9D7
       .byte $06 ; |     XX | $B9D8
       .byte $06 ; |     XX | $B9D9
       .byte $06 ; |     XX | $B9DA
       .byte $06 ; |     XX | $B9DB
       .byte $06 ; |     XX | $B9DC
       .byte $04 ; |     X  | $B9DD
       .byte $06 ; |     XX | $B9DE
       .byte $06 ; |     XX | $B9DF
       .byte $06 ; |     XX | $B9E0
       .byte $06 ; |     XX | $B9E1
       .byte $06 ; |     XX | $B9E2
       .byte $04 ; |     X  | $B9E3
       .byte $06 ; |     XX | $B9E4
       .byte $06 ; |     XX | $B9E5
       .byte $06 ; |     XX | $B9E6
       .byte $06 ; |     XX | $B9E7
       .byte $06 ; |     XX | $B9E8
       .byte $04 ; |     X  | $B9E9
       .byte $06 ; |     XX | $B9EA
       .byte $06 ; |     XX | $B9EB
       .byte $06 ; |     XX | $B9EC
       .byte $06 ; |     XX | $B9ED
       .byte $06 ; |     XX | $B9EE
LB9EF:
       .byte $06 ; |     XX | $B9EF
       .byte $06 ; |     XX | $B9F0
       .byte $04 ; |     X  | $B9F1
       .byte $06 ; |     XX | $B9F2
       .byte $06 ; |     XX | $B9F3
       .byte $06 ; |     XX | $B9F4
       .byte $06 ; |     XX | $B9F5
       .byte $06 ; |     XX | $B9F6
       .byte $04 ; |     X  | $B9F7
       .byte $06 ; |     XX | $B9F8
       .byte $06 ; |     XX | $B9F9
       .byte $00 ; |        | $B9FA
       .byte $00 ; |        | $B9FB
       .byte $00 ; |        | $B9FC
       .byte $00 ; |        | $B9FD
       .byte $00 ; |        | $B9FE
       .byte $00 ; |        | $B9FF

       ORG  $2D00
       RORG $BD00

LBA00:
       .byte $00 ; |        | $BA00
       .byte $00 ; |        | $BA01
       .byte $00 ; |        | $BA02
       .byte $00 ; |        | $BA03
       .byte $00 ; |        | $BA04
       .byte $00 ; |        | $BA05
       .byte $00 ; |        | $BA06
       .byte $00 ; |        | $BA07
       .byte $80 ; |X       | $BA08
       .byte $80 ; |X       | $BA09
       .byte $80 ; |X       | $BA0A
       .byte $80 ; |X       | $BA0B
       .byte $80 ; |X       | $BA0C
       .byte $80 ; |X       | $BA0D
       .byte $80 ; |X       | $BA0E
       .byte $80 ; |X       | $BA0F
       .byte $80 ; |X       | $BA10
       .byte $80 ; |X       | $BA11
       .byte $80 ; |X       | $BA12
       .byte $80 ; |X       | $BA13
       .byte $80 ; |X       | $BA14
       .byte $80 ; |X       | $BA15
       .byte $80 ; |X       | $BA16
       .byte $80 ; |X       | $BA17
       .byte $80 ; |X       | $BA18
       .byte $80 ; |X       | $BA19
       .byte $80 ; |X       | $BA1A
       .byte $80 ; |X       | $BA1B
       .byte $80 ; |X       | $BA1C
       .byte $80 ; |X       | $BA1D
       .byte $80 ; |X       | $BA1E
       .byte $80 ; |X       | $BA1F
LBA20:
       .byte $00 ; |        | $BA20
       .byte $00 ; |        | $BA21
       .byte $00 ; |        | $BA22
       .byte $00 ; |        | $BA23
       .byte $00 ; |        | $BA24
       .byte $00 ; |        | $BA25
       .byte $00 ; |        | $BA26
       .byte $00 ; |        | $BA27
       .byte $F8 ; |XXXXX   | $BA28
       .byte $F8 ; |XXXXX   | $BA29
       .byte $F8 ; |XXXXX   | $BA2A
       .byte $F8 ; |XXXXX   | $BA2B
       .byte $F8 ; |XXXXX   | $BA2C
       .byte $F8 ; |XXXXX   | $BA2D
       .byte $F8 ; |XXXXX   | $BA2E
       .byte $F8 ; |XXXXX   | $BA2F
       .byte $F8 ; |XXXXX   | $BA30
       .byte $F8 ; |XXXXX   | $BA31
       .byte $F8 ; |XXXXX   | $BA32
       .byte $F8 ; |XXXXX   | $BA33
       .byte $F8 ; |XXXXX   | $BA34
       .byte $F8 ; |XXXXX   | $BA35
       .byte $F8 ; |XXXXX   | $BA36
       .byte $F8 ; |XXXXX   | $BA37
       .byte $F8 ; |XXXXX   | $BA38
       .byte $F8 ; |XXXXX   | $BA39
       .byte $F8 ; |XXXXX   | $BA3A
       .byte $F8 ; |XXXXX   | $BA3B
       .byte $F8 ; |XXXXX   | $BA3C
       .byte $F8 ; |XXXXX   | $BA3D
       .byte $F8 ; |XXXXX   | $BA3E
       .byte $F8 ; |XXXXX   | $BA3F
       .byte $F0 ; |XXXX    | $BA40
       .byte $60 ; | XX     | $BA41
       .byte $00 ; |        | $BA42
       .byte $00 ; |        | $BA43
       .byte $00 ; |        | $BA44
       .byte $00 ; |        | $BA45
LBA46:
       .byte COLOR8+12; |X   XX  | $BA46
       .byte COLOR8+12; |X   XX  | $BA47
       .byte COLOR8+12; |X   XX  | $BA48
       .byte COLOR8+6 ; |X    XX | $BA49
       .byte COLOR8+6 ; |X    XX | $BA4A
       .byte COLOR8+6 ; |X    XX | $BA4B
       .byte COLOR8+6 ; |X    XX | $BA4C
       .byte COLOR8+6 ; |X    XX | $BA4D
       .byte COLOR8+6 ; |X    XX | $BA4E
       .byte COLOR8+6 ; |X    XX | $BA4F
       .byte COLOR8+6 ; |X    XX | $BA50
       .byte COLOR8+6 ; |X    XX | $BA51
       .byte COLOR8+6 ; |X    XX | $BA52
       .byte COLOR8+6 ; |X    XX | $BA53
       .byte COLOR8+6 ; |X    XX | $BA54
       .byte COLOR8+6 ; |X    XX | $BA55
       .byte COLOR8+6 ; |X    XX | $BA56
       .byte COLOR8+6 ; |X    XX | $BA57
       .byte COLOR8+6 ; |X    XX | $BA58
       .byte COLOR8+6 ; |X    XX | $BA59
       .byte COLOR8+6 ; |X    XX | $BA5A
       .byte COLOR8+6 ; |X    XX | $BA5B
       .byte COLOR8+6 ; |X    XX | $BA5C
       .byte COLOR8+6 ; |X    XX | $BA5D
       .byte COLOR8+6 ; |X    XX | $BA5E
       .byte COLOR8+6 ; |X    XX | $BA5F
       .byte COLOR8+6 ; |X    XX | $BA60
       .byte COLOR8+6 ; |X    XX | $BA61
       .byte COLOR8+6 ; |X    XX | $BA62
       .byte COLOR8+6 ; |X    XX | $BA63
       .byte COLOR8+6 ; |X    XX | $BA64
       .byte COLOR8+6 ; |X    XX | $BA65
       .byte COLOR8+6 ; |X    XX | $BA66
       .byte COLOR8+6 ; |X    XX | $BA67
       .byte COLOR8+6 ; |X    XX | $BA68
       .byte COLOR8+12; |X   XX  | $BA69
       .byte COLOR8+12; |X   XX  | $BA6A
       .byte COLOR8+12; |X   XX  | $BA6B
LBA6C:
       .byte COLOR0+6 ; |     XX | $BA6C
       .byte COLOR0+6 ; |     XX | $BA6D
       .byte COLOR0+6 ; |     XX | $BA6E
       .byte COLOR0+6 ; |     XX | $BA6F
       .byte COLOR0+6 ; |     XX | $BA70
       .byte COLOR0+6 ; |     XX | $BA71
       .byte COLOR0+4 ; |     X  | $BA72
       .byte COLOR0+2 ; |      X | $BA73
       .byte COLOR1+0 ; |   X    | $BA74
       .byte COLOR1+2 ; |   X  X | $BA75
       .byte COLOR1+2 ; |   X  X | $BA76
       .byte COLOR1+2 ; |   X  X | $BA77
       .byte COLOR1+0 ; |   X    | $BA78
       .byte COLOR1+4 ; |   X X  | $BA79
       .byte COLOR1+4 ; |   X X  | $BA7A
       .byte COLOR1+4 ; |   X X  | $BA7B
       .byte COLOR1+4 ; |   X X  | $BA7C
       .byte COLOR1+4 ; |   X X  | $BA7D
       .byte COLOR1+4 ; |   X X  | $BA7E
       .byte COLOR1+4 ; |   X X  | $BA7F
       .byte COLOR1+2 ; |   X  X | $BA80
       .byte COLOR1+6 ; |   X XX | $BA81
       .byte COLOR1+4 ; |   X X  | $BA82
       .byte COLOR1+4 ; |   X X  | $BA83
       .byte COLOR1+4 ; |   X X  | $BA84
       .byte COLOR1+4 ; |   X X  | $BA85
       .byte COLOR1+4 ; |   X X  | $BA86
       .byte COLOR1+4 ; |   X X  | $BA87
       .byte COLOR1+2 ; |   X  X | $BA88
       .byte COLOR1+6 ; |   X XX | $BA89
       .byte COLOR1+4 ; |   X X  | $BA8A
       .byte COLOR1+4 ; |   X X  | $BA8B
       .byte COLOR1+4 ; |   X X  | $BA8C
       .byte COLOR1+4 ; |   X X  | $BA8D
       .byte COLOR1+4 ; |   X X  | $BA8E
       .byte COLOR1+2 ; |   X  X | $BA8F
       .byte COLOR1+6 ; |   X XX | $BA90
       .byte COLOR1+4 ; |   X X  | $BA91
LBA92:
       .byte $00 ; |        | $BA92
       .byte $7E ; | XXXXXX | $BA93
       .byte $3C ; |  XXXX  | $BA94
       .byte $3C ; |  XXXX  | $BA95
       .byte $3C ; |  XXXX  | $BA96
       .byte $34 ; |  XX X  | $BA97
       .byte $34 ; |  XX X  | $BA98
       .byte $34 ; |  XX X  | $BA99
       .byte $34 ; |  XX X  | $BA9A
       .byte $34 ; |  XX X  | $BA9B
       .byte $34 ; |  XX X  | $BA9C
       .byte $34 ; |  XX X  | $BA9D
       .byte $34 ; |  XX X  | $BA9E
       .byte $34 ; |  XX X  | $BA9F
       .byte $34 ; |  XX X  | $BAA0
       .byte $34 ; |  XX X  | $BAA1
       .byte $34 ; |  XX X  | $BAA2
       .byte $34 ; |  XX X  | $BAA3
       .byte $34 ; |  XX X  | $BAA4
       .byte $34 ; |  XX X  | $BAA5
       .byte $3C ; |  XXXX  | $BAA6
       .byte $7E ; | XXXXXX | $BAA7
       .byte $FF ; |XXXXXXXX| $BAA8
       .byte $7E ; | XXXXXX | $BAA9
       .byte $7C ; | XXXXX  | $BAAA
       .byte $78 ; | XXXX   | $BAAB
       .byte $FC ; |XXXXXX  | $BAAC
       .byte $FC ; |XXXXXX  | $BAAD
       .byte $F2 ; |XXXX  X | $BAAE
       .byte $E7 ; |XXX  XXX| $BAAF
       .byte $FF ; |XXXXXXXX| $BAB0
       .byte $FE ; |XXXXXXX | $BAB1
       .byte $CC ; |XX  XX  | $BAB2
       .byte $CC ; |XX  XX  | $BAB3
       .byte $78 ; | XXXX   | $BAB4
       .byte $78 ; | XXXX   | $BAB5
       .byte $FC ; |XXXXXX  | $BAB6
       .byte $B4 ; |X XX X  | $BAB7
LBAB8:
       .byte $00 ; |        | $BAB8
       .byte $00 ; |        | $BAB9
       .byte $02 ; |      X | $BABA
       .byte $06 ; |     XX | $BABB
       .byte $06 ; |     XX | $BABC
       .byte $06 ; |     XX | $BABD
       .byte $06 ; |     XX | $BABE
       .byte $06 ; |     XX | $BABF
       .byte $06 ; |     XX | $BAC0
       .byte $06 ; |     XX | $BAC1
       .byte $06 ; |     XX | $BAC2
       .byte $06 ; |     XX | $BAC3
LBAC4:
       .byte $06 ; |     XX | $BAC4
       .byte $06 ; |     XX | $BAC5
       .byte $06 ; |     XX | $BAC6
       .byte $06 ; |     XX | $BAC7
       .byte $06 ; |     XX | $BAC8
       .byte $06 ; |     XX | $BAC9
       .byte $06 ; |     XX | $BACA
       .byte $06 ; |     XX | $BACB
       .byte $06 ; |     XX | $BACC
       .byte $06 ; |     XX | $BACD
       .byte $02 ; |      X | $BACE
       .byte $00 ; |        | $BACF

       .byte COLOR3+0 ; |  XX    | $BAD0
       .byte COLOR3+2 ; |  XX  X | $BAD1
       .byte COLOR3+2 ; |  XX  X | $BAD2
       .byte COLOR3+2 ; |  XX  X | $BAD3
       .byte COLOR3+2 ; |  XX  X | $BAD4
       .byte COLOR3+2 ; |  XX  X | $BAD5
       .byte COLOR3+2 ; |  XX  X | $BAD6
       .byte COLOR3+2 ; |  XX  X | $BAD7
       .byte COLOR3+2 ; |  XX  X | $BAD8
       .byte COLOR3+2 ; |  XX  X | $BAD9
       .byte COLOR3+2 ; |  XX  X | $BADA
       .byte COLOR3+2 ; |  XX  X | $BADB
       .byte COLOR2+0 ; |  X     | $BADC
       .byte COLOR2+0 ; |  X     | $BADD
LBADE:
       .byte COLOR0+0 ; |        | $BADE
       .byte COLOR0+0 ; |        | $BADF
       .byte COLOR0+0 ; |        | $BAE0
       .byte COLOR0+0 ; |        | $BAE1
       .byte COLOR0+0 ; |        | $BAE2
       .byte COLOR0+0 ; |        | $BAE3
       .byte COLOR0+0 ; |        | $BAE4
       .byte COLOR0+0 ; |        | $BAE5
       .byte COLOR0+0 ; |        | $BAE6
       .byte COLOR8+0 ; |X       | $BAE7
       .byte COLORC+0 ; |XX      | $BAE8
LBAE9:
       .byte COLOR3+4 ; |  XX X  | $BAE9
       .byte COLOR3+4 ; |  XX X  | $BAEA
       .byte COLOR3+4 ; |  XX X  | $BAEB
       .byte COLOR3+4 ; |  XX X  | $BAEC
       .byte COLOR3+4 ; |  XX X  | $BAED
       .byte COLOR3+4 ; |  XX X  | $BAEE
       .byte COLOR3+4 ; |  XX X  | $BAEF
       .byte COLOR3+4 ; |  XX X  | $BAF0
       .byte COLOR3+4 ; |  XX X  | $BAF1
       .byte COLOR3+4 ; |  XX X  | $BAF2
       .byte COLOR3+4 ; |  XX X  | $BAF3
LBAF4:
       .byte COLOR0+2 ; |      X | $BAF4
       .byte COLOR2+8 ; |  X X   | $BAF5
       .byte COLOR3+8 ; |  XXX   | $BAF6
       .byte COLOR3+8 ; |  XXX   | $BAF7
       .byte COLOR4+8 ; | X  X   | $BAF8
       .byte COLOR4+8 ; | X  X   | $BAF9
       .byte COLOR5+8 ; | X XX   | $BAFA
       .byte COLOR6+8 ; | XX X   | $BAFB
       .byte COLOR6+8 ; | XX X   | $BAFC
       .byte COLOR7+8 ; | XXXX   | $BAFD
       .byte COLOR8+8 ; |X   X   | $BAFE
       .byte COLOR0+0 ; |        | $BAFF

       ORG  $2E00
       RORG $BE00

LBD00:
       .byte >LB34B ; $BD00
       .byte >LB326 ; $BD01
       .byte >LB83A ; $BD02
       .byte >LB4D4 ; $BD03
       .byte >LB587 ; $BD04
       .byte >LB3A5 ; $BD05
       .byte >LB3A5 ; $BD06
       .byte >LB83A ; $BD07
       .byte >LB326 ; $BD08
       .byte >LB798 ; $BD09
       .byte >LBA46 ; $BD0A
       .byte >LB798 ; $BD0B
       .byte >LB772 ; $BD0C
       .byte >LBA46 ; $BD0D
       .byte >LB931 ; $BD0E
       .byte >LBB00 ; $BD0F
       .byte >LBAB8 ; $BD10
       .byte >LB3A5 ; $BD11
       .byte >LBC6B ; $BD12

LBD13:
       .byte >LB300 ; $BD13
       .byte >LB3A5 ; $BD14
       .byte >LB270 ; $BD15
       .byte >LB500 ; $BD16
       .byte >LB561 ; $BD17
       .byte >LB225 ; $BD18
       .byte >LB698 ; $BD19
       .byte >LB3A5 ; $BD1A
       .byte >LB3A5 ; $BD1B
       .byte >LB700 ; $BD1C
       .byte >LB700 ; $BD1D
       .byte >LB700 ; $BD1E
       .byte >LB6BE ; $BD1F
       .byte >LB24A ; $BD20
       .byte >LB97D ; $BD21
       .byte >LBB72 ; $BD22
       .byte >LBA92 ; $BD23
       .byte >LBB98 ; $BD24
       .byte >LBC10 ; $BD25

LBD26:
       .byte $31 ; |  XX   X| $BD26
       .byte $35 ; |  XX X X| $BD27
       .byte $31 ; |  XX   X| $BD28
LBD29:
       .byte $30 ; |  XX    | $BD29
       .byte $31 ; |  XX   X| $BD2A
       .byte $31 ; |  XX   X| $BD2B
       .byte $31 ; |  XX   X| $BD2C
       .byte $30 ; |  XX    | $BD2D
       .byte $35 ; |  XX X X| $BD2E
       .byte $31 ; |  XX   X| $BD2F
       .byte $31 ; |  XX   X| $BD30
       .byte $31 ; |  XX   X| $BD31
       .byte $31 ; |  XX   X| $BD32
LBD33:
       .byte $31 ; |  XX   X| $BD33
       .byte $31 ; |  XX   X| $BD34
       .byte $31 ; |  XX   X| $BD35
       .byte $30 ; |  XX    | $BD36
       .byte $31 ; |  XX   X| $BD37
       .byte $31 ; |  XX   X| $BD38
       .byte $31 ; |  XX   X| $BD39
       .byte $31 ; |  XX   X| $BD3A
       .byte $31 ; |  XX   X| $BD3B
       .byte $31 ; |  XX   X| $BD3C
       .byte $31 ; |  XX   X| $BD3D
       .byte $31 ; |  XX   X| $BD3E
       .byte $31 ; |  XX   X| $BD3F
       .byte $31 ; |  XX   X| $BD40
       .byte $31 ; |  XX   X| $BD41
       .byte $31 ; |  XX   X| $BD42
       .byte $31 ; |  XX   X| $BD43
       .byte $31 ; |  XX   X| $BD44
       .byte $32 ; |  XX  X | $BD45
LBD46:
       .byte $00 ; |        | $BD46
       .byte $00 ; |        | $BD47
       .byte $00 ; |        | $BD48
       .byte $00 ; |        | $BD49
       .byte $00 ; |        | $BD4A
       .byte $00 ; |        | $BD4B
       .byte $00 ; |        | $BD4C
       .byte $00 ; |        | $BD4D
       .byte $00 ; |        | $BD4E
       .byte $00 ; |        | $BD4F
       .byte $00 ; |        | $BD50
       .byte $00 ; |        | $BD51
       .byte $00 ; |        | $BD52
       .byte $00 ; |        | $BD53
       .byte $00 ; |        | $BD54
       .byte $08 ; |    X   | $BD55
       .byte $08 ; |    X   | $BD56
       .byte $00 ; |        | $BD57
       .byte $00 ; |        | $BD58

;repositioning table
       .byte $41 ; | X     X| $BD59
       .byte $31 ; |  XX   X| $BD5A
       .byte $21 ; |  X    X| $BD5B
       .byte $11 ; |   X   X| $BD5C
       .byte $01 ; |       X| $BD5D
       .byte $F1 ; |XXXX   X| $BD5E
       .byte $E1 ; |XXX    X| $BD5F
       .byte $D1 ; |XX X   X| $BD60
       .byte $C1 ; |XX     X| $BD61
       .byte $B1 ; |X XX   X| $BD62
       .byte $A1 ; |X X    X| $BD63
       .byte $91 ; |X  X   X| $BD64
       .byte $72 ; | XXX  X | $BD65
       .byte $62 ; | XX   X | $BD66
       .byte $52 ; | X X  X | $BD67
       .byte $42 ; | X    X | $BD68
       .byte $32 ; |  XX  X | $BD69
       .byte $22 ; |  X   X | $BD6A
       .byte $12 ; |   X  X | $BD6B
       .byte $02 ; |      X | $BD6C
       .byte $F2 ; |XXXX  X | $BD6D
       .byte $E2 ; |XXX   X | $BD6E
       .byte $D2 ; |XX X  X | $BD6F
       .byte $C2 ; |XX    X | $BD70
       .byte $B2 ; |X XX  X | $BD71
       .byte $A2 ; |X X   X | $BD72
       .byte $92 ; |X  X  X | $BD73
       .byte $73 ; | XXX  XX| $BD74
       .byte $63 ; | XX   XX| $BD75
       .byte $53 ; | X X  XX| $BD76
       .byte $43 ; | X    XX| $BD77
       .byte $33 ; |  XX  XX| $BD78
       .byte $23 ; |  X   XX| $BD79
       .byte $13 ; |   X  XX| $BD7A
       .byte $03 ; |      XX| $BD7B
       .byte $F3 ; |XXXX  XX| $BD7C
       .byte $E3 ; |XXX   XX| $BD7D
       .byte $D3 ; |XX X  XX| $BD7E
       .byte $C3 ; |XX    XX| $BD7F
       .byte $B3 ; |X XX  XX| $BD80
       .byte $A3 ; |X X   XX| $BD81
       .byte $93 ; |X  X  XX| $BD82
       .byte $74 ; | XXX X  | $BD83
       .byte $64 ; | XX  X  | $BD84
       .byte $54 ; | X X X  | $BD85
       .byte $44 ; | X   X  | $BD86
       .byte $34 ; |  XX X  | $BD87
       .byte $24 ; |  X  X  | $BD88
       .byte $14 ; |   X X  | $BD89
       .byte $04 ; |     X  | $BD8A
       .byte $F4 ; |XXXX X  | $BD8B
       .byte $E4 ; |XXX  X  | $BD8C
       .byte $D4 ; |XX X X  | $BD8D
       .byte $C4 ; |XX   X  | $BD8E
       .byte $B4 ; |X XX X  | $BD8F
       .byte $A4 ; |X X  X  | $BD90
       .byte $94 ; |X  X X  | $BD91
       .byte $75 ; | XXX X X| $BD92
       .byte $65 ; | XX  X X| $BD93
       .byte $55 ; | X X X X| $BD94
       .byte $45 ; | X   X X| $BD95
       .byte $35 ; |  XX X X| $BD96
       .byte $25 ; |  X  X X| $BD97
       .byte $15 ; |   X X X| $BD98
       .byte $05 ; |     X X| $BD99
       .byte $F5 ; |XXXX X X| $BD9A
       .byte $E5 ; |XXX  X X| $BD9B
       .byte $D5 ; |XX X X X| $BD9C
       .byte $C5 ; |XX   X X| $BD9D
       .byte $B5 ; |X XX X X| $BD9E
       .byte $A5 ; |X X  X X| $BD9F
       .byte $95 ; |X  X X X| $BDA0
       .byte $76 ; | XXX XX | $BDA1
       .byte $66 ; | XX  XX | $BDA2
       .byte $56 ; | X X XX | $BDA3
       .byte $46 ; | X   XX | $BDA4
       .byte $36 ; |  XX XX | $BDA5
       .byte $26 ; |  X  XX | $BDA6
       .byte $16 ; |   X XX | $BDA7
       .byte $06 ; |     XX | $BDA8
       .byte $F6 ; |XXXX XX | $BDA9
       .byte $E6 ; |XXX  XX | $BDAA
       .byte $D6 ; |XX X XX | $BDAB
       .byte $C6 ; |XX   XX | $BDAC
       .byte $B6 ; |X XX XX | $BDAD
       .byte $A6 ; |X X  XX | $BDAE
       .byte $96 ; |X  X XX | $BDAF
       .byte $77 ; | XXX XXX| $BDB0
       .byte $67 ; | XX  XXX| $BDB1
       .byte $57 ; | X X XXX| $BDB2
       .byte $47 ; | X   XXX| $BDB3
       .byte $37 ; |  XX XXX| $BDB4
       .byte $27 ; |  X  XXX| $BDB5
       .byte $17 ; |   X XXX| $BDB6
       .byte $07 ; |     XXX| $BDB7
       .byte $F7 ; |XXXX XXX| $BDB8
       .byte $E7 ; |XXX  XXX| $BDB9
       .byte $D7 ; |XX X XXX| $BDBA
       .byte $C7 ; |XX   XXX| $BDBB
       .byte $B7 ; |X XX XXX| $BDBC
       .byte $A7 ; |X X  XXX| $BDBD
       .byte $97 ; |X  X XXX| $BDBE
       .byte $78 ; | XXXX   | $BDBF
       .byte $68 ; | XX X   | $BDC0
       .byte $58 ; | X XX   | $BDC1
       .byte $48 ; | X  X   | $BDC2
       .byte $38 ; |  XXX   | $BDC3
       .byte $28 ; |  X X   | $BDC4
       .byte $18 ; |   XX   | $BDC5
       .byte $08 ; |    X   | $BDC6
       .byte $F8 ; |XXXXX   | $BDC7
       .byte $E8 ; |XXX X   | $BDC8
       .byte $D8 ; |XX XX   | $BDC9
       .byte $C8 ; |XX  X   | $BDCA
       .byte $B8 ; |X XXX   | $BDCB
       .byte $A8 ; |X X X   | $BDCC
       .byte $98 ; |X  XX   | $BDCD
       .byte $79 ; | XXXX  X| $BDCE
       .byte $69 ; | XX X  X| $BDCF
       .byte $59 ; | X XX  X| $BDD0
       .byte $49 ; | X  X  X| $BDD1
       .byte $39 ; |  XXX  X| $BDD2
       .byte $29 ; |  X X  X| $BDD3
       .byte $19 ; |   XX  X| $BDD4
       .byte $09 ; |    X  X| $BDD5
       .byte $F9 ; |XXXXX  X| $BDD6
       .byte $E9 ; |XXX X  X| $BDD7
       .byte $D9 ; |XX XX  X| $BDD8
       .byte $C9 ; |XX  X  X| $BDD9
       .byte $B9 ; |X XXX  X| $BDDA
       .byte $A9 ; |X X X  X| $BDDB
       .byte $99 ; |X  XX  X| $BDDC
       .byte $7A ; | XXXX X | $BDDD
       .byte $6A ; | XX X X | $BDDE
       .byte $5A ; | X XX X | $BDDF
       .byte $4A ; | X  X X | $BDE0
       .byte $3A ; |  XXX X | $BDE1
       .byte $2A ; |  X X X | $BDE2
       .byte $1A ; |   XX X | $BDE3
       .byte $0A ; |    X X | $BDE4
       .byte $FA ; |XXXXX X | $BDE5
       .byte $EA ; |XXX X X | $BDE6
       .byte $DA ; |XX XX X | $BDE7
       .byte $CA ; |XX  X X | $BDE8
       .byte $BA ; |X XXX X | $BDE9
       .byte $AA ; |X X X X | $BDEA
       .byte $9A ; |X  XX X | $BDEB
       .byte $7B ; | XXXX XX| $BDEC
       .byte $6B ; | XX X XX| $BDED
       .byte $5B ; | X XX XX| $BDEE
       .byte $4B ; | X  X XX| $BDEF
       .byte $3B ; |  XXX XX| $BDF0
       .byte $2B ; |  X X XX| $BDF1
       .byte $1B ; |   XX XX| $BDF2
       .byte $0B ; |    X XX| $BDF3
       .byte $FB ; |XXXXX XX| $BDF4
       .byte $EB ; |XXX X XX| $BDF5
       .byte $DB ; |XX XX XX| $BDF6
       .byte $CB ; |XX  X XX| $BDF7
       .byte $BB ; |X XXX XX| $BDF8
       .byte $AB ; |X X X XX| $BDF9
       .byte $9B ; |X  XX XX| $BDFA
       .byte $7C ; | XXXXX  | $BDFB

LBEFF:
       .byte <LD936 ; $BEFF
       .byte <LD935 ; $BF00
       .byte <LD966 ; $BF01
       .byte <LD937 ; $BF02

       ORG  $2F00
       RORG $BF00

LBE00:
       .byte >LB371 ; $BE00
       .byte >LB3A5 ; $BE01
       .byte >LB371 ; $BE02
       .byte >LB4D4 ; $BE03
       .byte >LB587 ; $BE04
       .byte >LB3A5 ; $BE05
       .byte >LB74C ; $BE06
       .byte >LB371 ; $BE07
       .byte >LB3A5 ; $BE08
       .byte >LB798 ; $BE09
       .byte >LB798 ; $BE0A
       .byte >LB798 ; $BE0B
       .byte >LB772 ; $BE0C
       .byte >LBA46 ; $BE0D
       .byte >LB8BD ; $BE0E
       .byte >LBB00 ; $BE0F
       .byte >LBAB8 ; $BE10
       .byte >LB3A5 ; $BE11
       .byte >LBC21 ; $BE12

LBE13:
       .byte <LB371 ; $BE13
       .byte <LB3A5 ; $BE14
       .byte <LB371 ; $BE15
       .byte <LB4D4 ; $BE16
       .byte <LB587 ; $BE17
       .byte <LB3A5 ; $BE18
       .byte <LB74C ; $BE19
       .byte <LB371 ; $BE1A
       .byte <LB3A5 ; $BE1B
       .byte <LB798 ; $BE1C
       .byte <LB798 ; $BE1D
       .byte <LB798 ; $BE1E
       .byte <LB772 ; $BE1F
       .byte <LBA46 ; $BE20
       .byte <LB8BD ; $BE21
       .byte <LBB00 ; $BE22
       .byte <LBAB8 ; $BE23
       .byte <LB3A5 ; $BE24
       .byte <LBC21 ; $BE25

LBE26:
       .byte $00 ; |        | $BE26
       .byte $01 ; |       X| $BE27
       .byte $02 ; |      X | $BE28
       .byte $02 ; |      X | $BE29
       .byte $06 ; |     XX | $BE2A
       .byte $04 ; |     X  | $BE2B
       .byte $38 ; |  XXX   | $BE2C
       .byte $7C ; | XXXXX  | $BE2D
       .byte $AA ; |X X X X | $BE2E
       .byte $72 ; | XXX  X | $BE2F
       .byte $3C ; |  XXXX  | $BE30


LB169:
       .byte COLOR1+2 ; |   X  X | $B169
       .byte COLOR0+2 ; |      X | $B16A
       .byte COLORC+4 ; |XX   X  | $B16B
       .byte COLOR1+0 ; |   X    | $B16C
       .byte COLOR0+6 ; |     XX | $B16D
       .byte COLORC+2 ; |XX    X | $B16E
       .byte COLOR0+0 ; |        | $B16F
       .byte COLOR0+2 ; |      X | $B170
       .byte COLOR0+2 ; |      X | $B171
       .byte COLOR0+2 ; |      X | $B172
       .byte COLOR0+2 ; |      X | $B173
       .byte COLOR0+2 ; |      X | $B174
       .byte COLOR0+2 ; |      X | $B175
       .byte COLOR0+2 ; |      X | $B176
       .byte COLOR0+0 ; |        | $B177
       .byte COLOR0+0 ; |        | $B178
       .byte COLORC+2 ; |XX    X | $B179
       .byte COLORC+2 ; |XX    X | $B17A
       .byte COLORC+2 ; |XX    X | $B17B

LB17C:
       .byte $04 ; |     X  | $B17C
       .byte $07 ; |     XXX| $B17D
       .byte $06 ; |     XX | $B17E
       .byte $03 ; |      XX| $B17F
       .byte $06 ; |     XX | $B180
       .byte $03 ; |      XX| $B181
       .byte $05 ; |     X X| $B182
       .byte $06 ; |     XX | $B183
       .byte $07 ; |     XXX| $B184
       .byte $06 ; |     XX | $B185
       .byte $06 ; |     XX | $B186
       .byte $06 ; |     XX | $B187
       .byte $07 ; |     XXX| $B188
       .byte $06 ; |     XX | $B189
       .byte $00 ; |        | $B18A
       .byte $00 ; |        | $B18B
       .byte $03 ; |      XX| $B18C
       .byte $03 ; |      XX| $B18D
       .byte $03 ; |      XX| $B18E

LB18F:
       .byte $07 ; |     XXX| $B18F
       .byte $07 ; |     XXX| $B190
       .byte $02 ; |      X | $B191
       .byte $01 ; |       X| $B192
       .byte $06 ; |     XX | $B193
       .byte $03 ; |      XX| $B194
       .byte $05 ; |     X X| $B195
       .byte $02 ; |      X | $B196
       .byte $07 ; |     XXX| $B197
       .byte $06 ; |     XX | $B198
       .byte $06 ; |     XX | $B199
       .byte $06 ; |     XX | $B19A
       .byte $07 ; |     XXX| $B19B
       .byte $07 ; |     XXX| $B19C
       .byte $07 ; |     XXX| $B19D
       .byte $00 ; |        | $B19E
       .byte $03 ; |      XX| $B19F
       .byte $03 ; |      XX| $B1A0
       .byte $03 ; |      XX| $B1A1

LB1A2:
       .byte COLOR8+4 ; |X    X  | $B1A2
       .byte COLOR0+4 ; |     X  | $B1A3
       .byte COLOR0+2 ; |      X | $B1A4
       .byte COLOR2+0 ; |  X     | $B1A5
       .byte COLOR0+0 ; |        | $B1A6
       .byte COLOR0+4 ; |     X  | $B1A7
       .byte COLOR0+0 ; |        | $B1A8
       .byte COLOR0+2 ; |      X | $B1A9
       .byte COLOR0+4 ; |     X  | $B1AA
       .byte COLOR0+2 ; |      X | $B1AB
       .byte COLOR0+2 ; |      X | $B1AC
       .byte COLOR0+2 ; |      X | $B1AD
       .byte COLOR0+4 ; |     X  | $B1AE
       .byte COLOR0+0 ; |        | $B1AF
       .byte COLOR8+4 ; |X    X  | $B1B0
       .byte COLOR0+0 ; |        | $B1B1
       .byte COLOR0+4 ; |     X  | $B1B2
       .byte COLOR0+4 ; |     X  | $B1B3
       .byte COLOR0+0 ; |        | $B1B4

LB1B5:
       .byte $07 ; |     XXX| $B1B5
       .byte $07 ; |     XXX| $B1B6
       .byte $05 ; |     X X| $B1B7
       .byte $01 ; |       X| $B1B8
       .byte $03 ; |      XX| $B1B9
       .byte $00 ; |        | $B1BA
       .byte $05 ; |     X X| $B1BB
       .byte $05 ; |     X X| $B1BC
       .byte $07 ; |     XXX| $B1BD
       .byte $06 ; |     XX | $B1BE
       .byte $06 ; |     XX | $B1BF
       .byte $06 ; |     XX | $B1C0
       .byte $06 ; |     XX | $B1C1
       .byte $06 ; |     XX | $B1C2
       .byte $00 ; |        | $B1C3
       .byte $00 ; |        | $B1C4
       .byte $05 ; |     X X| $B1C5
       .byte $05 ; |     X X| $B1C6
LBCB1:
       .byte <LB300 ; $BCB1 shared
       .byte <LB3A5 ; $BCB2
       .byte <LB270 ; $BCB3
       .byte <LB500 ; $BCB4
       .byte <LB561 ; $BCB5
       .byte <LB225 ; $BCB6
       .byte <LB698 ; $BCB7
       .byte <LB3A5 ; $BCB8
       .byte <LB3A5 ; $BCB9
       .byte <LB700 ; $BCBA
       .byte <LB700 ; $BCBB
       .byte <LB700 ; $BCBC
       .byte <LB6BE ; $BCBD
       .byte <LB24A ; $BCBE
       .byte <LB97D ; $BCBF
       .byte <LBB72 ; $BCC0
       .byte <LBA92 ; $BCC1
       .byte <LBB98 ; $BCC2
       .byte <LBC10 ; $BCC3


LB1C8:
       .byte $06 ; |     XX | $B1C8
       .byte $01 ; |       X| $B1C9
       .byte $04 ; |     X  | $B1CA
       .byte $03 ; |      XX| $B1CB
       .byte $03 ; |      XX| $B1CC
       .byte $07 ; |     XXX| $B1CD
       .byte $05 ; |     X X| $B1CE
       .byte $04 ; |     X  | $B1CF
       .byte $01 ; |       X| $B1D0
       .byte $06 ; |     XX | $B1D1
       .byte $06 ; |     XX | $B1D2
       .byte $06 ; |     XX | $B1D3
       .byte $06 ; |     XX | $B1D4
       .byte $07 ; |     XXX| $B1D5
       .byte $07 ; |     XXX| $B1D6
       .byte $00 ; |        | $B1D7
       .byte $05 ; |     X X| $B1D8
       .byte $05 ; |     X X| $B1D9
       .byte $05 ; |     X X| $B1DA

LB1DB:
       .byte COLOR0+2 ; |      X | $B1DB
       .byte COLOR0+2 ; |      X | $B1DC
LB1DD:
       .byte COLOR0+2 ; |      X | $B1DD
       .byte COLOR8+6 ; |X    XX | $B1DE
       .byte COLOR8+4 ; |X    X  | $B1DF
LB1E0:
       .byte COLOR0+4 ; |     X  | $B1E0
       .byte COLOR0+4 ; |     X  | $B1E1
LB1E2:
       .byte COLOR0+4 ; |     X  | $B1E2
       .byte COLOR0+6 ; |     XX | $B1E3
       .byte COLOR0+6 ; |     XX | $B1E4
LB1E5:
       .byte COLOR0+5 ; |     X X| $B1E5
       .byte COLOR0+6 ; |     XX | $B1E6
       .byte COLOR0+6 ; |     XX | $B1E7
LB1E8:
       .byte COLOR1+8 ; |   XX   | $B1E8
       .byte COLOR1+8 ; |   XX   | $B1E9
       .byte COLOR0+6 ; |     XX | $B1EA
LB1EB:
       .byte COLOR0+0 ; |        | $B1EB
       .byte COLOR9+2 ; |X  X  X | $B1EC
       .byte COLOR9+2 ; |X  X  X | $B1ED
LB1EE:
       .byte COLORC+2 ; |XX    X | $B1EE
       .byte COLORC+2 ; |XX    X | $B1EF
       .byte COLORC+2 ; |XX    X | $B1F0

LBEFB:
       .byte <LD91E ; |   XXXX | $BEFB
       .byte <LD91D ; |   XXX X| $BEFC
       .byte <LD94E ; | X  XXX | $BEFD
       .byte <LD91F ; |   XXXXX| $BEFE

LBCEA:
       .byte <LB4AE ; $BCEA
       .byte <LB488 ; $BCEB
       .byte <LB462 ; $BCEC
       .byte <LB53B ; $BCED
       .byte <LB600 ; $BCEE
       .byte <LB672 ; $BCEF
       .byte <LB897 ; $BCF0
       .byte <LB462 ; $BCF1
       .byte <LB488 ; $BCF2
       .byte <LB957 ; $BCF3
       .byte <LBBBE ; $BCF4
       .byte <LB957 ; $BCF5
       .byte <LB900 ; $BCF6
       .byte <LB926 ; $BCF7
       .byte <LB9C9 ; $BCF8
       .byte <LBB26 ; $BCF9
       .byte <LBB26 ; $BCFA
       .byte <LBB26 ; $BCFB
       .byte <LBA6C ; $BCFC

       ORG  $2FE2
       RORG $BFE2

LBFD6:
       bit    BANK3                   ;4 go to LD004

LB1F1:
       .byte COLOR3+4 ; |  XX X  | $B1F1
       .byte COLOR3+4 ; |  XX X  | $B1F2
       .byte COLOR3+4 ; |  XX X  | $B1F3

LBFE2:
       bit    BANK1                   ;4 go to L94F7
       jmp    LBF53                   ;3 from 3

LB1F4:
       .byte COLOR1+4 ; |   X X  | $B1F4
       .byte COLOR1+4 ; |   X X  | $B1F5
       .byte COLOR1+4 ; |   X X  | $B1F6

       jmp    LB004                   ;3 @30 from 1

       ORG  $2FF4
       RORG $BFF4
       jmp    L92D6                   ;3 from 3
       .word 0      ; $BFF7 - $BFF8
START2:
       jmp    START                   ;3 bankswitch to 4 and boot
       .word START2 ; $BFFC - $BFFD
       .word START2 ; $BFFE - $BFFF






       ORG  $3000
       RORG $D000

LDA00: ;ball enable (for the bat object)
       .byte $00 ; |        | $DA00
       .byte $00 ; |        | $DA01
       .byte $00 ; |        | $DA02
       .byte $00 ; |        | $DA03
LDA04:
       .byte $00 ; |        | $DA04
       .byte $00 ; |        | $DA05
       .byte $00 ; |        | $DA06
       .byte $00 ; |        | $DA07
       .byte $00 ; |        | $DA08
       .byte $00 ; |        | $DA09
       .byte $00 ; |        | $DA0A
       .byte $00 ; |        | $DA0B
       .byte $00 ; |        | $DA0C
       .byte $00 ; |        | $DA0D
       .byte $00 ; |        | $DA0E
       .byte $00 ; |        | $DA0F
       .byte $00 ; |        | $DA10
       .byte $00 ; |        | $DA11
       .byte $00 ; |        | $DA12
       .byte $00 ; |        | $DA13
       .byte $00 ; |        | $DA14
       .byte $00 ; |        | $DA15
       .byte $00 ; |        | $DA16
       .byte $00 ; |        | $DA17
       .byte $00 ; |        | $DA18
       .byte $00 ; |        | $DA19
       .byte $00 ; |        | $DA1A
       .byte $00 ; |        | $DA1B
       .byte $00 ; |        | $DA1C
       .byte $00 ; |        | $DA1D
       .byte $00 ; |        | $DA1E
       .byte $00 ; |        | $DA1F
       .byte $00 ; |        | $DA20
       .byte $00 ; |        | $DA21
       .byte $00 ; |        | $DA22
       .byte $00 ; |        | $DA23
       .byte $00 ; |        | $DA24
       .byte $00 ; |        | $DA25
       .byte $00 ; |        | $DA26
       .byte $00 ; |        | $DA27
       .byte $00 ; |        | $DA28
       .byte $00 ; |        | $DA29
       .byte $00 ; |        | $DA2A
       .byte $00 ; |        | $DA2B
       .byte $00 ; |        | $DA2C
       .byte $00 ; |        | $DA2D
       .byte $00 ; |        | $DA2E
       .byte $00 ; |        | $DA2F
       .byte $00 ; |        | $DA30
       .byte $00 ; |        | $DA31
       .byte $00 ; |        | $DA32
       .byte $00 ; |        | $DA33
       .byte $00 ; |        | $DA34
       .byte $00 ; |        | $DA35
       .byte $00 ; |        | $DA36
       .byte $00 ; |        | $DA37
       .byte $00 ; |        | $DA38
       .byte $00 ; |        | $DA39
       .byte $FF ; |XXXXXXXX| $DA3A
       .byte $FF ; |XXXXXXXX| $DA3B
       .byte $FF ; |XXXXXXXX| $DA3C
       .byte $FF ; |XXXXXXXX| $DA3D
       .byte $FF ; |XXXXXXXX| $DA3E
       .byte $FF ; |XXXXXXXX| $DA3F
       .byte $FF ; |XXXXXXXX| $DA40
       .byte $00 ; |        | $DA41
       .byte $00 ; |        | $DA42
       .byte $00 ; |        | $DA43
       .byte $00 ; |        | $DA44
       .byte $00 ; |        | $DA45
       .byte $00 ; |        | $DA46
       .byte $00 ; |        | $DA47
       .byte $00 ; |        | $DA48
       .byte $00 ; |        | $DA49
       .byte $00 ; |        | $DA4A
       .byte $00 ; |        | $DA4B
       .byte $00 ; |        | $DA4C
       .byte $00 ; |        | $DA4D
       .byte $00 ; |        | $DA4E
       .byte $00 ; |        | $DA4F
       .byte $00 ; |        | $DA50
       .byte $00 ; |        | $DA51
       .byte $00 ; |        | $DA52
       .byte $00 ; |        | $DA53
       .byte $00 ; |        | $DA54
       .byte $00 ; |        | $DA55
       .byte $00 ; |        | $DA56
       .byte $00 ; |        | $DA57
       .byte $00 ; |        | $DA58
       .byte $00 ; |        | $DA59
       .byte $00 ; |        | $DA5A
       .byte $00 ; |        | $DA5B
       .byte $00 ; |        | $DA5C
       .byte $00 ; |        | $DA5D
       .byte $00 ; |        | $DA5E
       .byte $00 ; |        | $DA5F
       .byte $00 ; |        | $DA60
       .byte $00 ; |        | $DA61
       .byte $00 ; |        | $DA62
       .byte $00 ; |        | $DA63
       .byte $00 ; |        | $DA64
       .byte $00 ; |        | $DA65
       .byte $00 ; |        | $DA66
       .byte $00 ; |        | $DA67
       .byte $00 ; |        | $DA68
       .byte $00 ; |        | $DA69
       .byte $00 ; |        | $DA6A
       .byte $00 ; |        | $DA6B
       .byte $00 ; |        | $DA6C
       .byte $00 ; |        | $DA6D
       .byte $00 ; |        | $DA6E
       .byte $00 ; |        | $DA6F
       .byte $00 ; |        | $DA70
       .byte $00 ; |        | $DA71
       .byte $00 ; |        | $DA72
       .byte $00 ; |        | $DA73
       .byte $00 ; |        | $DA74
       .byte $00 ; |        | $DA75
       .byte $00 ; |        | $DA76
       .byte $00 ; |        | $DA77
       .byte $00 ; |        | $DA78
       .byte $00 ; |        | $DA79
       .byte $00 ; |        | $DA7A
       .byte $00 ; |        | $DA7B
       .byte $00 ; |        | $DA7C
       .byte $00 ; |        | $DA7D
       .byte $00 ; |        | $DA7E
       .byte $00 ; |        | $DA7F
       .byte $00 ; |        | $DA80
       .byte $00 ; |        | $DA81
       .byte $00 ; |        | $DA82
       .byte $00 ; |        | $DA83
       .byte $00 ; |        | $DA84
       .byte $FF ; |XXXXXXXX| $DA85
       .byte $FF ; |XXXXXXXX| $DA86
       .byte $00 ; |        | $DA87
       .byte $00 ; |        | $DA88
       .byte $00 ; |        | $DA89
       .byte $00 ; |        | $DA8A
       .byte $00 ; |        | $DA8B
       .byte $00 ; |        | $DA8C
       .byte $00 ; |        | $DA8D
       .byte $00 ; |        | $DA8E
       .byte $00 ; |        | $DA8F
       .byte $00 ; |        | $DA90
       .byte $00 ; |        | $DA91
       .byte $00 ; |        | $DA92
       .byte $00 ; |        | $DA93
       .byte $00 ; |        | $DA94
       .byte $00 ; |        | $DA95
       .byte $00 ; |        | $DA96
       .byte $00 ; |        | $DA97
       .byte $00 ; |        | $DA98
       .byte $00 ; |        | $DA99
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
;       .byte $00 ; |        | $DAC2
;       .byte $00 ; |        | $DAC3
LDEFA:
       .byte <LD400 ; $DEFA shared
       .byte <LD400 ; $DEFB shared
       .byte <LD41F ; $DEFC
       .byte <LD43E ; $DEFD
       .byte <LD45D ; $DEFE
       .byte <LD4BA ; $DEFF
       .byte <LD584 ; $DF00
       .byte <LDA04 ; $DF01
       .byte <LD49B ; $DF02
       .byte <LD47C ; $DF03
       .byte <LD565 ; $DF04
       .byte <LD9DC ; $DF05
       .byte <LD4D9 ; $DF06
       .byte <LD549 ; $DF07

LD0E1: ;19
       .byte <LD311 ; $D0E1
       .byte <LD311 ; $D0E2
       .byte <LD311 ; $D0E3
       .byte <LD311 ; $D0E4
       .byte <LD311 ; $D0E5
       .byte <LD300 ; $D0E6
       .byte <LD344 ; $D0E7
       .byte <LD344 ; $D0E8
       .byte <LD344 ; $D0E9
       .byte <LD355 ; $D0EA
       .byte <LD355 ; $D0EB
       .byte <LD355 ; $D0EC
       .byte <LD355 ; $D0ED
       .byte <LD355 ; $D0EE
       .byte <LD366 ; $D0EF
       .byte <LD322 ; $D0F0
       .byte <LD322 ; $D0F1
       .byte <LD322 ; $D0F2
       .byte <LD333 ; $D0F3

LD0F4: ;6 bytes
       .byte $17 ; |   X XXX| $D0F4
       .byte $17 ; |   X XXX| $D0F5
       .byte $40 ; | X      | $D0F6
       .byte $40 ; | X      | $D0F7
       .byte $17 ; |   X XXX| $D0F8
       .byte $40 ; | X      | $D0F9
LD0FA: ;6 bytes
       .byte $00 ; |        | $D0FA
       .byte $01 ; |       X| $D0FB
       .byte $02 ; |      X | $D0FC
       .byte $02 ; |      X | $D0FD
       .byte $01 ; |       X| $D0FE
       .byte $02 ; |      X | $D0FF

LD3EF: ;17
       .byte $30 ; |  XX    | $D3EF
       .byte $00 ; |        | $D3F0
       .byte $30 ; |  XX    | $D3F1
       .byte $30 ; |  XX    | $D3F2
       .byte $20 ; |  X     | $D3F3
       .byte $00 ; |        | $D3F4
       .byte $FF ; |XXXXXXXX| $D3F5
       .byte $20 ; |  X     | $D3F6
       .byte $30 ; |  XX    | $D3F7
       .byte $30 ; |  XX    | $D3F8
       .byte $30 ; |  XX    | $D3F9
       .byte $30 ; |  XX    | $D3FA
       .byte $10 ; |   X    | $D3FB
       .byte $10 ; |   X    | $D3FC
       .byte $10 ; |   X    | $D3FD
       .byte $10 ; |   X    | $D3FE
       .byte $00 ; |        | $D3FF

       ORG  $3100
       RORG $D100

LD800:
       .byte $00 ; |        | $D800
       .byte $18 ; |   XX   | $D801
       .byte $50 ; | X X    | $D802
       .byte $50 ; | X X    | $D803
       .byte $70 ; | XXX    | $D804
       .byte $70 ; | XXX    | $D805
       .byte $70 ; | XXX    | $D806
       .byte $70 ; | XXX    | $D807
       .byte $30 ; |  XX    | $D808
       .byte $78 ; | XXXX   | $D809
       .byte $78 ; | XXXX   | $D80A
       .byte $78 ; | XXXX   | $D80B
       .byte $00 ; |        | $D80C
       .byte $88 ; |X   X   | $D80D
       .byte $EF ; |XXX XXXX| $D80E
       .byte $32 ; |  XX  X | $D80F
       .byte $32 ; |  XX  X | $D810
       .byte $DA ; |XX XX X | $D811
       .byte $BC ; |X XXXX  | $D812
       .byte $FC ; |XXXXXX  | $D813
       .byte $FC ; |XXXXXX  | $D814
       .byte $E6 ; |XXX  XX | $D815
       .byte $58 ; | X XX   | $D816
       .byte $28 ; |  X X   | $D817
       .byte $74 ; | XXX X  | $D818
       .byte $7C ; | XXXXX  | $D819
       .byte $28 ; |  X X   | $D81A
       .byte $7C ; | XXXXX  | $D81B
       .byte $7C ; | XXXXX  | $D81C
       .byte $38 ; |  XXX   | $D81D
       .byte $00 ; |        | $D81E
LD81F:
       .byte $00 ; |        | $D81F shared
       .byte $C6 ; |XX   XX | $D820
       .byte $84 ; |X    X  | $D821
       .byte $84 ; |X    X  | $D822
       .byte $CC ; |XX  XX  | $D823
       .byte $CC ; |XX  XX  | $D824
       .byte $6C ; | XX XX  | $D825
       .byte $6C ; | XX XX  | $D826
       .byte $3C ; |  XXXX  | $D827
       .byte $78 ; | XXXX   | $D828
       .byte $78 ; | XXXX   | $D829
       .byte $78 ; | XXXX   | $D82A
       .byte $78 ; | XXXX   | $D82B
       .byte $38 ; |  XXX   | $D82C
       .byte $40 ; | X      | $D82D
       .byte $32 ; |  XX  X | $D82E
       .byte $32 ; |  XX  X | $D82F
       .byte $E8 ; |XXX X   | $D830
       .byte $FF ; |XXXXXXXX| $D831
       .byte $BC ; |X XXXX  | $D832
       .byte $FC ; |XXXXXX  | $D833
       .byte $FE ; |XXXXXXX | $D834
       .byte $C6 ; |XX   XX | $D835
       .byte $18 ; |   XX   | $D836
       .byte $28 ; |  X X   | $D837
       .byte $74 ; | XXX X  | $D838
       .byte $7C ; | XXXXX  | $D839
       .byte $28 ; |  X X   | $D83A
       .byte $7C ; | XXXXX  | $D83B
       .byte $7C ; | XXXXX  | $D83C
       .byte $38 ; |  XXX   | $D83D
LD83E:
       .byte $00 ; |        | $D83E shared
       .byte $02 ; |      X | $D83F
       .byte $0F ; |    XXXX| $D840
       .byte $0A ; |    X X | $D841
       .byte $0A ; |    X X | $D842
       .byte $1A ; |   XX X | $D843
       .byte $1E ; |   XXXX | $D844
       .byte $36 ; |  XX XX | $D845
       .byte $6C ; | XX XX  | $D846
       .byte $7C ; | XXXXX  | $D847
       .byte $78 ; | XXXX   | $D848
       .byte $88 ; |X   X   | $D849
       .byte $EF ; |XXX XXXX| $D84A
       .byte $FA ; |XXXXX X | $D84B
       .byte $60 ; | XX     | $D84C
       .byte $70 ; | XXX    | $D84D
       .byte $B0 ; |X XX    | $D84E
       .byte $B0 ; |X XX    | $D84F
       .byte $BC ; |X XXXX  | $D850
       .byte $FC ; |XXXXXX  | $D851
       .byte $FA ; |XXXXX X | $D852
       .byte $4A ; | X  X X | $D853
       .byte $32 ; |  XX  X | $D854
       .byte $52 ; | X X  X | $D855
       .byte $E8 ; |XXX X   | $D856
       .byte $F8 ; |XXXXX   | $D857
       .byte $50 ; | X X    | $D858
       .byte $F8 ; |XXXXX   | $D859
       .byte $F8 ; |XXXXX   | $D85A
       .byte $70 ; | XXX    | $D85B
       .byte $00 ; |        | $D85C
LD85D:
       .byte $00 ; |        | $D85D shared
       .byte $88 ; |X   X   | $D85E
       .byte $EF ; |XXX XXXX| $D85F
       .byte $FA ; |XXXXX X | $D860
       .byte $70 ; | XXX    | $D861
       .byte $F8 ; |XXXXX   | $D862
       .byte $F8 ; |XXXXX   | $D863
       .byte $F8 ; |XXXXX   | $D864
       .byte $78 ; | XXXX   | $D865
       .byte $30 ; |  XX    | $D866
       .byte $7E ; | XXXXXX | $D867
       .byte $BA ; |X XXX X | $D868
       .byte $84 ; |X    X  | $D869
       .byte $38 ; |  XXX   | $D86A
       .byte $68 ; | XX X   | $D86B
       .byte $2C ; |  X XX  | $D86C
       .byte $04 ; |     X  | $D86D
       .byte $00 ; |        | $D86E
       .byte $00 ; |        | $D86F
       .byte $00 ; |        | $D870
       .byte $00 ; |        | $D871
       .byte $00 ; |        | $D872
       .byte $00 ; |        | $D873
       .byte $00 ; |        | $D874
       .byte $00 ; |        | $D875
       .byte $00 ; |        | $D876
       .byte $00 ; |        | $D877
       .byte $00 ; |        | $D878
       .byte $00 ; |        | $D879
       .byte $00 ; |        | $D87A
LD87B:
       .byte $00 ; |        | $D87B shared
       .byte $00 ; |        | $D87C shared
       .byte $00 ; |        | $D87D
       .byte $34 ; |  XX X  | $D87E
       .byte $34 ; |  XX X  | $D87F
       .byte $34 ; |  XX X  | $D880
       .byte $34 ; |  XX X  | $D881
       .byte $18 ; |   XX   | $D882
       .byte $18 ; |   XX   | $D883
       .byte $18 ; |   XX   | $D884
       .byte $04 ; |     X  | $D885
       .byte $04 ; |     X  | $D886
       .byte $04 ; |     X  | $D887
       .byte $04 ; |     X  | $D888
       .byte $04 ; |     X  | $D889
       .byte $04 ; |     X  | $D88A
LD88B:
       .byte COLOR0+4 ; |     X  | $D88B
LD88C:
       .byte COLOR2+6 ; |  X  XX | $D88C
       .byte COLOR2+6 ; |  X  XX | $D88D
       .byte COLOR2+4 ; |  X  X  | $D88E
       .byte COLOR2+4 ; |  X  X  | $D88F
       .byte COLOR2+4 ; |  X  X  | $D890
       .byte COLOR2+4 ; |  X  X  | $D891
       .byte COLOR2+6 ; |  X  XX | $D892
       .byte COLOR8+0 ; |X       | $D893
       .byte COLOR8+0 ; |X       | $D894
       .byte COLOR8+0 ; |X       | $D895
       .byte COLOR8+0 ; |X       | $D896
       .byte COLOR8+0 ; |X       | $D897
       .byte COLOR8+0 ; |X       | $D898
       .byte COLOR2+4 ; |  X  X  | $D899
       .byte COLOR2+4 ; |  X  X  | $D89A
       .byte COLOR2+4 ; |  X  X  | $D89B
       .byte COLOR2+4 ; |  X  X  | $D89C
       .byte COLOR2+6 ; |  X  XX | $D89D
       .byte COLOR2+4 ; |  X  X  | $D89E
       .byte COLOR2+4 ; |  X  X  | $D89F
       .byte COLOR2+6 ; |  X  XX | $D8A0
       .byte COLOR2+4 ; |  X  X  | $D8A1
       .byte COLOR2+4 ; |  X  X  | $D8A2
       .byte COLOR2+4 ; |  X  X  | $D8A3
       .byte COLOR2+4 ; |  X  X  | $D8A4
       .byte COLOR2+4 ; |  X  X  | $D8A5
       .byte COLOR2+6 ; |  X  XX | $D8A6
       .byte COLOR2+4 ; |  X  X  | $D8A7
       .byte COLOR2+4 ; |  X  X  | $D8A8
       .byte COLOR2+6 ; |  X  XX | $D8A9
       .byte COLOR2+6 ; |  X  XX | $D8AA
LD8AB:
       .byte COLOR2+6 ; |  X  XX | $D8AB
       .byte COLOR2+6 ; |  X  XX | $D8AC
       .byte COLOR2+4 ; |  X  X  | $D8AD
       .byte COLOR2+4 ; |  X  X  | $D8AE
       .byte COLOR2+4 ; |  X  X  | $D8AF
       .byte COLOR2+4 ; |  X  X  | $D8B0
       .byte COLOR2+6 ; |  X  XX | $D8B1
       .byte COLOR2+6 ; |  X  XX | $D8B2
       .byte COLOR2+6 ; |  X  XX | $D8B3
       .byte COLOR8+0 ; |X       | $D8B4
       .byte COLOR8+0 ; |X       | $D8B5
       .byte COLOR8+0 ; |X       | $D8B6
       .byte COLOR2+4 ; |  X  X  | $D8B7
       .byte COLOR2+4 ; |  X  X  | $D8B8
       .byte COLOR2+4 ; |  X  X  | $D8B9
       .byte COLOR2+4 ; |  X  X  | $D8BA
       .byte COLOR2+4 ; |  X  X  | $D8BB
       .byte COLOR2+6 ; |  X  XX | $D8BC
LD8BD:
       .byte COLOR2+6 ; |  X  XX | $D8BD
LD8BE:
       .byte COLOR0+8 ; |    X   | $D8BE
       .byte COLOR0+8 ; |    X   | $D8BF
       .byte COLOR0+8 ; |    X   | $D8C0
       .byte COLOR0+4 ; |     X  | $D8C1
       .byte COLOR0+4 ; |     X  | $D8C2
       .byte COLOR0+4 ; |     X  | $D8C3
       .byte COLOR0+4 ; |     X  | $D8C4
       .byte COLOR0+4 ; |     X  | $D8C5
       .byte COLOR0+4 ; |     X  | $D8C6
       .byte COLOR0+4 ; |     X  | $D8C7
       .byte COLOR0+4 ; |     X  | $D8C8
       .byte COLOR0+0 ; |        | $D8C9
       .byte COLOR0+0 ; |        | $D8CA
       .byte COLOR0+0 ; |        | $D8CB
       .byte COLOR3+4 ; |  XX X  | $D8CC
       .byte COLOR3+4 ; |  XX X  | $D8CD
       .byte COLOR1+8 ; |   XX   | $D8CE
       .byte COLOR1+8 ; |   XX   | $D8CF
       .byte COLOR1+8 ; |   XX   | $D8D0
       .byte COLOR1+8 ; |   XX   | $D8D1
       .byte COLOR1+8 ; |   XX   | $D8D2
       .byte COLOR1+8 ; |   XX   | $D8D3
       .byte COLOR1+8 ; |   XX   | $D8D4
       .byte COLOR3+4 ; |  XX X  | $D8D5
       .byte COLOR3+4 ; |  XX X  | $D8D6
       .byte COLOR3+4 ; |  XX X  | $D8D7
       .byte COLOR3+4 ; |  XX X  | $D8D8
       .byte COLOR3+4 ; |  XX X  | $D8D9
       .byte COLOR3+4 ; |  XX X  | $D8DA
       .byte COLOR3+4 ; |  XX X  | $D8DB
       .byte COLOR3+4 ; |  XX X  | $D8DC
       .byte COLOR3+4 ; |  XX X  | $D8DD

LD8DE:
       .byte $F9 ; |XXXXX  X| $D8DE
       .byte $F9 ; |XXXXX  X| $D8DF
       .byte $F9 ; |XXXXX  X| $D8E0
       .byte $43 ; | X    XX| $D8E1
LD8E2:
       .byte $21 ; |  X    X| $D8E2
       .byte $21 ; |  X    X| $D8E3
       .byte $21 ; |  X    X| $D8E4
       .byte $6C ; | XX XX  | $D8E5
LD8E6:
       .byte $05 ; |     X X| $D8E6
       .byte $03 ; |      XX| $D8E7
       .byte $07 ; |     XXX| $D8E8
       .byte $0A ; |    X X | $D8E9

LD8EA:
       ldy    r82                     ;3
       beq    LD8F2                   ;2
       cmp    r82                     ;3
       bcs    LD8FA                   ;2
LD8F2:
       sta    r82                     ;3
       lda    #$FF                    ;2
       sta    r84                     ;3
       sta    r83                     ;3
LD8FA:
       rts                            ;6

LD8FB:
       .byte COLOR1+0 ; |   X    | $D8FB
       .byte COLOR0+10; |    X X | $D8FC
       .byte COLOR1+2 ; |   X  X | $D8FD
       .byte COLOR0+0 ; |        | $D8FE
       .byte COLOR0+0 ; |        | $D8FF
       .byte COLOR0+8 ; |    X   | $D900
       .byte COLOR0+8 ; |    X   | $D901
       .byte COLOR0+8 ; |    X   | $D902
       .byte COLOR8+0 ; |X       | $D903
       .byte COLOR8+0 ; |X       | $D904
       .byte COLOR8+0 ; |X       | $D905
       .byte COLOR8+0 ; |X       | $D906
       .byte COLOR8+0 ; |X       | $D907
       .byte COLOR8+0 ; |X       | $D908
       .byte COLOR8+0 ; |X       | $D909
       .byte COLOR8+0 ; |X       | $D90A
       .byte COLOR8+0 ; |X       | $D90B
       .byte COLOR8+0 ; |X       | $D90C
       .byte COLOR8+0 ; |X       | $D90D
       .byte COLOR3+4 ; |  XX X  | $D90E
       .byte COLOR3+4 ; |  XX X  | $D90F
       .byte COLOR0+8 ; |    X   | $D910
       .byte COLOR0+8 ; |    X   | $D911
       .byte COLOR8+0 ; |X       | $D912
       .byte COLOR8+0 ; |X       | $D913
       .byte COLOR8+0 ; |X       | $D914
       .byte COLOR8+0 ; |X       | $D915
       .byte COLOR8+0 ; |X       | $D916
       .byte COLOR3+4 ; |  XX X  | $D917
       .byte COLOR3+4 ; |  XX X  | $D918
       .byte COLOR3+4 ; |  XX X  | $D919
       .byte COLOR3+4 ; |  XX X  | $D91A
       .byte COLOR3+4 ; |  XX X  | $D91B
       .byte COLOR0+8 ; |    X   | $D91C
LD91D:
       .byte COLOR0+8 ; |    X   | $D91D
LD91E:
       .byte COLOR3+2 ; |  XX  X | $D91E
LD91F:
       .byte COLOR3+2 ; |  XX  X | $D91F
       .byte COLOR3+2 ; |  XX  X | $D920
       .byte COLOR3+2 ; |  XX  X | $D921
       .byte COLOR8+2 ; |X     X | $D922
       .byte COLOR8+2 ; |X     X | $D923
       .byte COLOR8+2 ; |X     X | $D924
       .byte COLOR8+2 ; |X     X | $D925
       .byte COLOR8+2 ; |X     X | $D926
       .byte COLOR8+2 ; |X     X | $D927
       .byte COLOR8+0 ; |X       | $D928
       .byte COLOR8+0 ; |X       | $D929
       .byte COLOR8+0 ; |X       | $D92A
       .byte COLOR8+0 ; |X       | $D92B
       .byte COLOR8+0 ; |X       | $D92C
       .byte COLOR8+0 ; |X       | $D92D
       .byte COLOR8+0 ; |X       | $D92E
       .byte COLOR3+4 ; |  XX X  | $D92F
       .byte COLOR3+4 ; |  XX X  | $D930
       .byte COLOR3+4 ; |  XX X  | $D931
       .byte COLOR3+4 ; |  XX X  | $D932
       .byte COLOR8+0 ; |X       | $D933
       .byte COLOR8+0 ; |X       | $D934
LD935:
       .byte COLOR8+4 ; |X    X  | $D935
LD936:
       .byte COLOR3+2 ; |  XX  X | $D936
LD937:
       .byte COLOR3+2 ; |  XX  X | $D937
       .byte COLOR3+2 ; |  XX  X | $D938
       .byte COLOR3+2 ; |  XX  X | $D939
       .byte COLOR3+4 ; |  XX X  | $D93A
       .byte COLOR3+4 ; |  XX X  | $D93B
       .byte COLOR3+4 ; |  XX X  | $D93C
       .byte COLOR3+4 ; |  XX X  | $D93D
       .byte COLOR3+4 ; |  XX X  | $D93E
       .byte COLOR3+4 ; |  XX X  | $D93F
       .byte COLOR3+0 ; |  XX    | $D940
       .byte COLOR3+0 ; |  XX    | $D941
       .byte COLOR3+0 ; |  XX    | $D942
       .byte COLOR3+0 ; |  XX    | $D943
       .byte COLOR3+0 ; |  XX    | $D944
       .byte COLOR3+0 ; |  XX    | $D945
       .byte COLOR3+0 ; |  XX    | $D946
       .byte COLOR3+4 ; |  XX X  | $D947
       .byte COLOR3+4 ; |  XX X  | $D948
       .byte COLOR3+4 ; |  XX X  | $D949
       .byte COLOR3+4 ; |  XX X  | $D94A
       .byte COLOR3+0 ; |  XX    | $D94B
       .byte COLOR3+0 ; |  XX    | $D94C
       .byte COLOR3+4 ; |  XX X  | $D94D
LD94E:
       .byte COLOR8+0 ; |X       | $D94E
       .byte COLOR8+0 ; |X       | $D94F
       .byte COLOR8+0 ; |X       | $D950
       .byte COLOR3+4 ; |  XX X  | $D951
       .byte COLOR3+4 ; |  XX X  | $D952
       .byte COLOR8+0 ; |X       | $D953
       .byte COLOR8+0 ; |X       | $D954
       .byte COLOR8+0 ; |X       | $D955
       .byte COLOR8+0 ; |X       | $D956
       .byte COLOR3+4 ; |  XX X  | $D957
       .byte COLOR8+2 ; |X     X | $D958
       .byte COLOR8+2 ; |X     X | $D959
       .byte COLOR8+2 ; |X     X | $D95A
       .byte COLOR8+2 ; |X     X | $D95B
       .byte COLOR8+2 ; |X     X | $D95C
       .byte COLOR3+4 ; |  XX X  | $D95D
       .byte COLOR8+0 ; |X       | $D95E
       .byte COLOR3+4 ; |  XX X  | $D95F
       .byte COLOR3+4 ; |  XX X  | $D960
       .byte COLOR3+4 ; |  XX X  | $D961
       .byte COLOR3+4 ; |  XX X  | $D962
       .byte COLOR8+0 ; |X       | $D963
       .byte COLOR8+0 ; |X       | $D964
       .byte COLOR8+4 ; |X    X  | $D965
LD966:
       .byte COLOR3+0 ; |  XX    | $D966
       .byte COLOR3+0 ; |  XX    | $D967
       .byte COLOR3+0 ; |  XX    | $D968
       .byte COLOR3+4 ; |  XX X  | $D969
       .byte COLOR3+4 ; |  XX X  | $D96A
       .byte COLOR3+0 ; |  XX    | $D96B
       .byte COLOR3+0 ; |  XX    | $D96C
       .byte COLOR3+0 ; |  XX    | $D96D
       .byte COLOR3+0 ; |  XX    | $D96E
       .byte COLOR3+4 ; |  XX X  | $D96F
       .byte COLOR3+4 ; |  XX X  | $D970
       .byte COLOR3+4 ; |  XX X  | $D971
       .byte COLOR3+4 ; |  XX X  | $D972
       .byte COLOR3+4 ; |  XX X  | $D973
       .byte COLOR3+4 ; |  XX X  | $D974
       .byte COLOR3+4 ; |  XX X  | $D975
       .byte COLOR3+0 ; |  XX    | $D976
       .byte COLOR3+4 ; |  XX X  | $D977
       .byte COLOR3+4 ; |  XX X  | $D978
       .byte COLOR3+4 ; |  XX X  | $D979
       .byte COLOR3+4 ; |  XX X  | $D97A
       .byte COLOR3+0 ; |  XX    | $D97B
       .byte COLOR3+0 ; |  XX    | $D97C
       .byte COLOR8+4 ; |X    X  | $D97D
LD97E:
       .byte COLOR2+2 ; |  X   X | $D97E
       .byte COLOR2+2 ; |  X   X | $D97F
       .byte COLOR2+2 ; |  X   X | $D980
       .byte COLOR3+4 ; |  XX X  | $D981
       .byte COLOR3+4 ; |  XX X  | $D982
       .byte COLOR2+2 ; |  X   X | $D983
       .byte COLOR2+2 ; |  X   X | $D984
       .byte COLOR2+2 ; |  X   X | $D985
       .byte COLOR2+2 ; |  X   X | $D986
       .byte COLOR3+4 ; |  XX X  | $D987
       .byte COLOR0+2 ; |      X | $D988
       .byte COLOR0+2 ; |      X | $D989
       .byte COLOR0+2 ; |      X | $D98A
       .byte COLOR0+2 ; |      X | $D98B
       .byte COLOR0+2 ; |      X | $D98C
       .byte COLOR3+4 ; |  XX X  | $D98D
       .byte COLOR2+2 ; |  X   X | $D98E
       .byte COLOR3+4 ; |  XX X  | $D98F
       .byte COLOR3+4 ; |  XX X  | $D990
       .byte COLOR3+4 ; |  XX X  | $D991
       .byte COLOR3+4 ; |  XX X  | $D992
       .byte COLOR2+2 ; |  X   X | $D993
       .byte COLOR2+2 ; |  X   X | $D994
LD995:
       .byte COLOR2+2 ; |  X   X | $D995
LD996:
       .byte COLOR3+2 ; |  XX  X | $D996
LD997:
       .byte COLOR3+2 ; |  XX  X | $D997
       .byte COLOR3+2 ; |  XX  X | $D998
       .byte COLOR3+2 ; |  XX  X | $D999
       .byte COLOR0+2 ; |      X | $D99A
       .byte COLOR0+2 ; |      X | $D99B
       .byte COLOR0+2 ; |      X | $D99C
       .byte COLOR0+2 ; |      X | $D99D
       .byte COLOR0+2 ; |      X | $D99E
       .byte COLOR0+2 ; |      X | $D99F
       .byte COLOR2+2 ; |  X   X | $D9A0
       .byte COLOR2+2 ; |  X   X | $D9A1
       .byte COLOR2+2 ; |  X   X | $D9A2
       .byte COLOR2+2 ; |  X   X | $D9A3
       .byte COLOR2+2 ; |  X   X | $D9A4
       .byte COLOR2+2 ; |  X   X | $D9A5
       .byte COLOR2+2 ; |  X   X | $D9A6
       .byte COLOR3+4 ; |  XX X  | $D9A7
       .byte COLOR3+4 ; |  XX X  | $D9A8
       .byte COLOR3+4 ; |  XX X  | $D9A9
       .byte COLOR3+4 ; |  XX X  | $D9AA
       .byte COLOR2+2 ; |  X   X | $D9AB
       .byte COLOR2+2 ; |  X   X | $D9AC
LD9AD:
       .byte COLOR2+2 ; |  X   X | $D9AD
LD9AE:
       .byte COLOR3+12; |  XXXX  | $D9AE
       .byte COLOR3+12; |  XXXX  | $D9AF
       .byte COLOR3+12; |  XXXX  | $D9B0
       .byte COLOR3+12; |  XXXX  | $D9B1
       .byte COLOR3+4 ; |  XX X  | $D9B2
       .byte COLOR3+4 ; |  XX X  | $D9B3
       .byte COLOR3+4 ; |  XX X  | $D9B4
       .byte COLOR4+0 ; | X      | $D9B5
       .byte COLOR4+0 ; | X      | $D9B6
       .byte COLOR4+0 ; | X      | $D9B7
       .byte COLOR4+0 ; | X      | $D9B8
       .byte COLOR4+0 ; | X      | $D9B9
       .byte COLOR4+0 ; | X      | $D9BA
       .byte COLOR4+0 ; | X      | $D9BB
       .byte COLOR4+0 ; | X      | $D9BC
       .byte COLOR1+12; |   XXX  | $D9BD
       .byte COLOR1+12; |   XXX  | $D9BE
       .byte COLOR1+12; |   XXX  | $D9BF
       .byte COLOR1+12; |   XXX  | $D9C0
       .byte COLOR1+12; |   XXX  | $D9C1
       .byte COLOR1+12; |   XXX  | $D9C2
       .byte COLOR1+12; |   XXX  | $D9C3
       .byte COLOR1+12; |   XXX  | $D9C4
LD9C5:
       .byte COLOR1+12; |   XXX  | $D9C5
       .byte COLOR1+12; |   XXX  | $D9C6
       .byte COLOR1+12; |   XXX  | $D9C7
       .byte COLOR1+12; |   XXX  | $D9C8
       .byte COLOR1+12; |   XXX  | $D9C9
       .byte COLOR1+12; |   XXX  | $D9CA
       .byte COLOR4+0 ; | X      | $D9CB
       .byte COLOR4+0 ; | X      | $D9CC
       .byte COLOR4+0 ; | X      | $D9CD
       .byte COLOR3+4 ; |  XX X  | $D9CE
       .byte COLOR3+4 ; |  XX X  | $D9CF
       .byte COLOR3+4 ; |  XX X  | $D9D0
       .byte COLOR3+12; |  XXXX  | $D9D1
       .byte COLOR3+12; |  XXXX  | $D9D2
       .byte COLOR3+12; |  XXXX  | $D9D3
       .byte COLOR3+12; |  XXXX  | $D9D4
       .byte COLOR3+12; |  XXXX  | $D9D5
       .byte COLOR3+12; |  XXXX  | $D9D6
       .byte COLOR3+12; |  XXXX  | $D9D7
       .byte COLOR3+12; |  XXXX  | $D9D8
       .byte COLOR3+12; |  XXXX  | $D9D9
       .byte COLOR3+12; |  XXXX  | $D9DA
       .byte COLOR3+12; |  XXXX  | $D9DB

LD9DC:
       .byte $00 ; |        | $D9DC
       .byte $24 ; |  X  X  | $D9DD
       .byte $46 ; | X   XX | $D9DE
       .byte $44 ; | X   X  | $D9DF
       .byte $44 ; | X   X  | $D9E0
       .byte $24 ; |  X  X  | $D9E1
       .byte $2C ; |  X XX  | $D9E2
       .byte $38 ; |  XXX   | $D9E3
       .byte $38 ; |  XXX   | $D9E4
       .byte $30 ; |  XX    | $D9E5
       .byte $30 ; |  XX    | $D9E6
       .byte $38 ; |  XXX   | $D9E7
       .byte $38 ; |  XXX   | $D9E8
       .byte $58 ; | X XX   | $D9E9
       .byte $58 ; | X XX   | $D9EA
       .byte $B0 ; |X XX    | $D9EB
       .byte $F0 ; |XXXX    | $D9EC
       .byte $0C ; |    XX  | $D9ED
       .byte $1C ; |   XXX  | $D9EE
       .byte $1C ; |   XXX  | $D9EF
       .byte $1C ; |   XXX  | $D9F0
       .byte $1C ; |   XXX  | $D9F1
LD9F2:
       .byte $1C ; |   XXX  | $D9F2 shared
       .byte $08 ; |    X   | $D9F3 shared
       .byte $00 ; |        | $D9F4 shared
       .byte $00 ; |        | $D9F5 shared
       .byte $00 ; |        | $D9F6 shared
       .byte $00 ; |        | $D9F7 shared
       .byte $00 ; |        | $D9F8 shared
       .byte $00 ; |        | $D9F9 shared
       .byte $00 ; |        | $D9FA shared
       .byte $00 ; |        | $D9FB shared
       .byte $0C ; |    XX  | $D9FC
       .byte $0C ; |    XX  | $D9FD
       .byte $FF ; |XXXXXXXX| $D9FE
       .byte $FF ; |XXXXXXXX| $D9FF

       ORG  $3300
       RORG $D300

LDF08: ;14
       .byte >LD400 ; $DF08
       .byte >LD400 ; $DF09
       .byte >LD41F ; $DF0A
       .byte >LD43E ; $DF0B
       .byte >LD45D ; $DF0C
       .byte >LD4BA ; $DF0D
       .byte >LD584 ; $DF0E
       .byte >LDA04 ; $DF0F
       .byte >LD49B ; $DF10
       .byte >LD47C ; $DF11
       .byte >LD565 ; $DF12
       .byte >LD9DC ; $DF13
       .byte >LD4D9 ; $DF14
       .byte >LD549 ; $DF15

LDF16: ;10
       .byte <LD5A3 ; $DF16
       .byte <LD5A3 ; $DF17
       .byte <LD5C2 ; $DF18
       .byte <LD600 ; $DF19
       .byte <LD61F ; $DF1A
       .byte <LD65D ; $DF1B
       .byte <LD5E0 ; $DF1C
       .byte <LDA04 ; $DF1D
       .byte <LD63E ; $DF1E
       .byte <LD63E ; $DF1F

LDF20: ;10
       .byte >LD5A3 ; $DF20
       .byte >LD5A3 ; $DF21
       .byte >LD5C2 ; $DF22
       .byte >LD600 ; $DF23
       .byte >LD61F ; $DF24
       .byte >LD65D ; $DF25
       .byte >LD5E0 ; $DF26
       .byte >LDA04 ; $DF27
       .byte >LD63E ; $DF28
       .byte >LD63E ; $DF29

LDF2A: ;13
       .byte <LD67C ; $DF2A
       .byte <LD67C ; $DF2B
       .byte <LD69B ; $DF2C
       .byte <LD6BA ; $DF2D
       .byte <LD6D9 ; $DF2E
       .byte <LD75D ; $DF2F
       .byte <LD77C ; $DF30
       .byte <LDA04 ; $DF31
       .byte <LD700 ; $DF32
       .byte <LD71F ; $DF33
       .byte <LD73E ; $DF34
       .byte <LD73E ; $DF35
       .byte <LD73E ; $DF36

LDF37: ;13
       .byte >LD67C ; $DF37
       .byte >LD67C ; $DF38
       .byte >LD69B ; $DF39
       .byte >LD6BA ; $DF3A
       .byte >LD6D9 ; $DF3B
       .byte >LD75D ; $DF3C
       .byte >LD77C ; $DF3D
       .byte >LDA04 ; $DF3E
       .byte >LD700 ; $DF3F
       .byte >LD71F ; $DF40
       .byte >LD73E ; $DF41
       .byte >LD73E ; $DF42
       .byte >LD73E ; $DF43

LDF44: ;14
       .byte <LD79B ; $DF44
       .byte <LD79B ; $DF45
       .byte <LD7BA ; $DF46
       .byte <LD7D9 ; $DF47
       .byte <LD800 ; $DF48
       .byte <LD83E ; $DF49
       .byte <LD85D ; $DF4A
       .byte <LDA04 ; $DF4B
       .byte <LD81F ; $DF4C
       .byte <LD81F ; $DF4D
       .byte <LD81F ; $DF4E
       .byte <LD81F ; $DF4F
       .byte <LD81F ; $DF50
       .byte <LD81F ; $DF51

LDF52: ;14
       .byte >LD79B ; $DF52
LDF53:
       .byte >LD79B ; $DF53
       .byte >LD7BA ; $DF54
       .byte >LD7D9 ; $DF55
       .byte >LD800 ; $DF56
       .byte >LD83E ; $DF57
       .byte >LD85D ; $DF58
       .byte >LDA04 ; $DF59
       .byte >LD81F ; $DF5A
       .byte >LD81F ; $DF5B
       .byte >LD81F ; $DF5C
       .byte >LD81F ; $DF5D
       .byte >LD81F ; $DF5E
       .byte >LD81F ; $DF5F

LD0B1: ;48 (needs 49)
       .byte COLOR2+4 ; |  X  X  | $D0B1
       .byte COLOR2+4 ; |  X  X  | $D0B2
       .byte COLOR2+2 ; |  X   X | $D0B3
       .byte COLOR2+2 ; |  X   X | $D0B4
       .byte COLOR2+2 ; |  X   X | $D0B5
       .byte COLOR2+2 ; |  X   X | $D0B6
       .byte COLOR2+4 ; |  X  X  | $D0B7
       .byte COLOR2+4 ; |  X  X  | $D0B8
       .byte COLOR2+4 ; |  X  X  | $D0B9
       .byte COLOR0+4 ; |     X  | $D0BA
       .byte COLOR0+4 ; |     X  | $D0BB
       .byte COLOR0+4 ; |     X  | $D0BC
       .byte COLOR2+2 ; |  X   X | $D0BD
       .byte COLOR2+2 ; |  X   X | $D0BE
       .byte COLOR2+2 ; |  X   X | $D0BF
       .byte COLOR2+2 ; |  X   X | $D0C0
LD0C1:
       .byte COLOR2+2 ; |  X   X | $D0C1
LD0C2:
       .byte COLOR2+4 ; |  X  X  | $D0C2
       .byte COLOR2+4 ; |  X  X  | $D0C3
       .byte COLOR2+2 ; |  X   X | $D0C4
       .byte COLOR2+2 ; |  X   X | $D0C5
       .byte COLOR2+2 ; |  X   X | $D0C6
       .byte COLOR2+2 ; |  X   X | $D0C7
       .byte COLOR2+4 ; |  X  X  | $D0C8
       .byte COLOR0+4 ; |     X  | $D0C9
       .byte COLOR0+4 ; |     X  | $D0CA
       .byte COLOR0+4 ; |     X  | $D0CB
       .byte COLOR0+4 ; |     X  | $D0CC
       .byte COLOR0+4 ; |     X  | $D0CD
       .byte COLOR0+4 ; |     X  | $D0CE
       .byte COLOR2+2 ; |  X   X | $D0CF
       .byte COLOR2+2 ; |  X   X | $D0D0
       .byte COLOR2+2 ; |  X   X | $D0D1
       .byte COLOR2+2 ; |  X   X | $D0D2
       .byte COLOR2+4 ; |  X  X  | $D0D3
       .byte COLOR2+2 ; |  X   X | $D0D4
       .byte COLOR2+2 ; |  X   X | $D0D5
       .byte COLOR2+4 ; |  X  X  | $D0D6
       .byte COLOR2+2 ; |  X   X | $D0D7
       .byte COLOR2+2 ; |  X   X | $D0D8
       .byte COLOR2+2 ; |  X   X | $D0D9
       .byte COLOR2+2 ; |  X   X | $D0DA
       .byte COLOR2+2 ; |  X   X | $D0DB
       .byte COLOR2+4 ; |  X  X  | $D0DC
       .byte COLOR2+2 ; |  X   X | $D0DD
       .byte COLOR2+2 ; |  X   X | $D0DE
       .byte COLOR2+4 ; |  X  X  | $D0DF
       .byte COLOR2+4 ; |  X  X  | $D0E0
       .byte $00 ; |        | $D3FF bugfix

;       ORG  $3389
;       RORG $D389

LD300: ;s/b=L9200
       .byte COLOR9+4 ; |X  X X  | $D300
       .byte COLOR0+2 ; |      X | $D301
       .byte COLOR0+4 ; |     X  | $D302
       .byte COLOR0+4 ; |     X  | $D303
       .byte COLOR0+6 ; |     XX | $D304
       .byte COLOR0+6 ; |     XX | $D305
       .byte COLOR0+8 ; |    X   | $D306
       .byte COLOR0+8 ; |    X   | $D307
       .byte COLOR0+6 ; |     XX | $D308
       .byte COLOR0+8 ; |    X   | $D309
       .byte COLOR0+8 ; |    X   | $D30A
       .byte COLOR0+6 ; |     XX | $D30B
       .byte COLOR0+8 ; |    X   | $D30C
       .byte COLOR0+6 ; |     XX | $D30D
       .byte COLOR0+4 ; |     X  | $D30E
       .byte COLOR0+2 ; |      X | $D30F
       .byte COLOR8+4 ; |X    X  | $D310
LD311:
       .byte COLOR0+4 ; |     X  | $D311
       .byte COLOR0+6 ; |     XX | $D312
       .byte COLOR0+6 ; |     XX | $D313
       .byte COLOR0+6 ; |     XX | $D314
       .byte COLOR0+8 ; |    X   | $D315
       .byte COLOR0+10; |    X X | $D316
       .byte COLOR0+4 ; |     X  | $D317
       .byte COLOR0+8 ; |    X   | $D318
       .byte COLOR0+8 ; |    X   | $D319
       .byte COLOR0+8 ; |    X   | $D31A
       .byte COLOR0+8 ; |    X   | $D31B
       .byte COLOR0+8 ; |    X   | $D31C
       .byte COLOR0+8 ; |    X   | $D31D
       .byte COLOR0+8 ; |    X   | $D31E
       .byte COLOR0+2 ; |      X | $D31F
       .byte COLORC+4 ; |XX   X  | $D320
       .byte COLORC+2 ; |XX    X | $D321
LD322:
       .byte COLOR1+4 ; |   X X  | $D322
       .byte COLOR1+4 ; |   X X  | $D323
       .byte COLOR1+4 ; |   X X  | $D324
       .byte COLOR1+4 ; |   X X  | $D325
       .byte COLOR1+4 ; |   X X  | $D326
       .byte COLOR1+4 ; |   X X  | $D327
       .byte COLOR1+4 ; |   X X  | $D328
       .byte COLOR1+4 ; |   X X  | $D329
       .byte COLOR1+4 ; |   X X  | $D32A
       .byte COLOR1+4 ; |   X X  | $D32B
       .byte COLOR1+4 ; |   X X  | $D32C
       .byte COLOR1+0 ; |   X    | $D32D
       .byte COLOR1+2 ; |   X  X | $D32E
       .byte COLOR1+2 ; |   X  X | $D32F
       .byte COLOR1+2 ; |   X  X | $D330
       .byte COLOR1+0 ; |   X    | $D331
       .byte COLOR1+6 ; |   X XX | $D332
LD333:
       .byte COLOR0+6 ; |     XX | $D333
       .byte COLOR0+6 ; |     XX | $D334
       .byte COLOR0+6 ; |     XX | $D335
       .byte COLOR0+6 ; |     XX | $D336
       .byte COLOR0+6 ; |     XX | $D337
       .byte COLOR0+6 ; |     XX | $D338
       .byte COLOR0+6 ; |     XX | $D339
       .byte COLOR0+6 ; |     XX | $D33A
       .byte COLOR0+6 ; |     XX | $D33B
       .byte COLOR0+6 ; |     XX | $D33C
       .byte COLOR0+6 ; |     XX | $D33D
       .byte COLOR0+6 ; |     XX | $D33E
       .byte COLOR0+6 ; |     XX | $D33F
       .byte COLOR0+6 ; |     XX | $D340
       .byte COLOR0+6 ; |     XX | $D341
       .byte COLOR0+6 ; |     XX | $D342
       .byte COLOR0+6 ; |     XX | $D343
LD344:
       .byte COLOR1+4 ; |   X X  | $D344
       .byte COLOR1+6 ; |   X XX | $D345
       .byte COLOR1+6 ; |   X XX | $D346
       .byte COLOR1+6 ; |   X XX | $D347
       .byte COLOR1+8 ; |   XX   | $D348
       .byte COLOR1+10; |   XX X | $D349
       .byte COLOR1+4 ; |   X X  | $D34A
       .byte COLOR1+8 ; |   XX   | $D34B
       .byte COLOR1+8 ; |   XX   | $D34C
       .byte COLOR1+8 ; |   XX   | $D34D
       .byte COLOR1+8 ; |   XX   | $D34E
       .byte COLOR1+8 ; |   XX   | $D34F
       .byte COLOR1+8 ; |   XX   | $D350
       .byte COLOR1+8 ; |   XX   | $D351
       .byte COLOR1+2 ; |   X  X | $D352
       .byte COLORC+4 ; |XX   X  | $D353
       .byte COLORC+2 ; |XX    X | $D354
LD355:
       .byte COLORC+4 ; |XX   X  | $D355
       .byte COLORC+4 ; |XX   X  | $D356
       .byte COLORC+4 ; |XX   X  | $D357
       .byte COLORC+4 ; |XX   X  | $D358
       .byte COLORC+4 ; |XX   X  | $D359
       .byte COLORC+4 ; |XX   X  | $D35A
       .byte COLORC+4 ; |XX   X  | $D35B
       .byte COLORC+4 ; |XX   X  | $D35C
       .byte COLORC+4 ; |XX   X  | $D35D
       .byte COLORC+4 ; |XX   X  | $D35E
       .byte COLORC+4 ; |XX   X  | $D35F
       .byte COLORC+2 ; |XX    X | $D360
       .byte COLORC+2 ; |XX    X | $D361
       .byte COLORC+2 ; |XX    X | $D362
       .byte COLORC+2 ; |XX    X | $D363
       .byte COLORC+0 ; |XX      | $D364
       .byte COLORC+0 ; |XX      | $D365
LD366:
       .byte COLOR0+4 ; |     X  | $D366
       .byte COLOR0+4 ; |     X  | $D367
       .byte COLOR0+4 ; |     X  | $D368
       .byte COLOR0+4 ; |     X  | $D369
       .byte COLOR0+4 ; |     X  | $D36A
       .byte COLOR0+4 ; |     X  | $D36B
       .byte COLOR0+4 ; |     X  | $D36C
       .byte COLOR0+4 ; |     X  | $D36D
       .byte COLOR0+4 ; |     X  | $D36E
       .byte COLOR0+4 ; |     X  | $D36F
       .byte COLOR0+4 ; |     X  | $D370
       .byte COLOR0+6 ; |     XX | $D371
       .byte COLOR0+6 ; |     XX | $D372
       .byte COLOR0+6 ; |     XX | $D373
       .byte COLOR0+6 ; |     XX | $D374
       .byte COLOR0+2 ; |      X | $D375
       .byte COLOR0+2 ; |      X | $D376

       ORG  $3400
       RORG $D400

LD400:
       .byte $00 ; |        | $D400
       .byte $20 ; |  X     | $D401
       .byte $30 ; |  XX    | $D402
       .byte $60 ; | XX     | $D403
       .byte $60 ; | XX     | $D404
       .byte $60 ; | XX     | $D405
       .byte $20 ; |  X     | $D406
       .byte $20 ; |  X     | $D407
       .byte $60 ; | XX     | $D408
       .byte $60 ; | XX     | $D409
       .byte $70 ; | XXX    | $D40A
       .byte $B8 ; |X XXX   | $D40B
       .byte $B8 ; |X XXX   | $D40C
       .byte $F0 ; |XXXX    | $D40D
       .byte $F0 ; |XXXX    | $D40E
       .byte $F0 ; |XXXX    | $D40F
       .byte $60 ; | XX     | $D410
       .byte $30 ; |  XX    | $D411
       .byte $70 ; | XXX    | $D412
       .byte $70 ; | XXX    | $D413
       .byte $70 ; | XXX    | $D414
       .byte $70 ; | XXX    | $D415
       .byte $70 ; | XXX    | $D416
       .byte $20 ; |  X     | $D417
       .byte $00 ; |        | $D418
       .byte $00 ; |        | $D419
       .byte $00 ; |        | $D41A
       .byte $00 ; |        | $D41B
       .byte $00 ; |        | $D41C
       .byte $00 ; |        | $D41D
       .byte $00 ; |        | $D41E
LD41F:
       .byte $00 ; |        | $D41F shared
       .byte $20 ; |  X     | $D420
       .byte $40 ; | X      | $D421
       .byte $40 ; | X      | $D422
       .byte $50 ; | X X    | $D423
       .byte $58 ; | X XX   | $D424
       .byte $48 ; | X  X   | $D425
       .byte $78 ; | XXXX   | $D426
       .byte $78 ; | XXXX   | $D427
       .byte $70 ; | XXX    | $D428
       .byte $70 ; | XXX    | $D429
       .byte $B8 ; |X XXX   | $D42A
       .byte $B8 ; |X XXX   | $D42B
       .byte $F0 ; |XXXX    | $D42C
       .byte $F0 ; |XXXX    | $D42D
       .byte $F0 ; |XXXX    | $D42E
       .byte $F0 ; |XXXX    | $D42F
       .byte $60 ; | XX     | $D430
       .byte $30 ; |  XX    | $D431
       .byte $70 ; | XXX    | $D432
       .byte $70 ; | XXX    | $D433
       .byte $70 ; | XXX    | $D434
       .byte $70 ; | XXX    | $D435
       .byte $70 ; | XXX    | $D436
       .byte $20 ; |  X     | $D437
       .byte $00 ; |        | $D438
       .byte $00 ; |        | $D439
       .byte $00 ; |        | $D43A
       .byte $00 ; |        | $D43B
       .byte $00 ; |        | $D43C
       .byte $00 ; |        | $D43D
LD43E:
       .byte $00 ; |        | $D43E shared
       .byte $08 ; |    X   | $D43F
       .byte $4C ; | X  XX  | $D440
       .byte $88 ; |X   X   | $D441
       .byte $88 ; |X   X   | $D442
       .byte $D8 ; |XX XX   | $D443
       .byte $D0 ; |XX X    | $D444
       .byte $70 ; | XXX    | $D445
       .byte $70 ; | XXX    | $D446
       .byte $78 ; | XXXX   | $D447
       .byte $B8 ; |X XXX   | $D448
       .byte $B8 ; |X XXX   | $D449
       .byte $F0 ; |XXXX    | $D44A
       .byte $F0 ; |XXXX    | $D44B
       .byte $F0 ; |XXXX    | $D44C
       .byte $F0 ; |XXXX    | $D44D
       .byte $60 ; | XX     | $D44E
       .byte $30 ; |  XX    | $D44F
       .byte $70 ; | XXX    | $D450
       .byte $70 ; | XXX    | $D451
       .byte $70 ; | XXX    | $D452
       .byte $70 ; | XXX    | $D453
       .byte $70 ; | XXX    | $D454
       .byte $20 ; |  X     | $D455
       .byte $00 ; |        | $D456
       .byte $00 ; |        | $D457
       .byte $00 ; |        | $D458
       .byte $00 ; |        | $D459
       .byte $00 ; |        | $D45A
       .byte $00 ; |        | $D45B
       .byte $00 ; |        | $D45C
LD45D:
       .byte $00 ; |        | $D45D shared
       .byte $18 ; |   XX   | $D45E
       .byte $10 ; |   X    | $D45F
       .byte $10 ; |   X    | $D460
       .byte $50 ; | X X    | $D461
       .byte $70 ; | XXX    | $D462
       .byte $70 ; | XXX    | $D463
       .byte $70 ; | XXX    | $D464
       .byte $30 ; |  XX    | $D465
       .byte $70 ; | XXX    | $D466
       .byte $70 ; | XXX    | $D467
       .byte $70 ; | XXX    | $D468
       .byte $B8 ; |X XXX   | $D469
       .byte $B8 ; |X XXX   | $D46A
       .byte $F0 ; |XXXX    | $D46B
       .byte $F0 ; |XXXX    | $D46C
       .byte $F0 ; |XXXX    | $D46D
       .byte $60 ; | XX     | $D46E
       .byte $30 ; |  XX    | $D46F
       .byte $70 ; | XXX    | $D470
       .byte $70 ; | XXX    | $D471
       .byte $70 ; | XXX    | $D472
       .byte $70 ; | XXX    | $D473
       .byte $70 ; | XXX    | $D474
       .byte $20 ; |  X     | $D475
       .byte $00 ; |        | $D476
       .byte $00 ; |        | $D477
       .byte $00 ; |        | $D478
       .byte $00 ; |        | $D479
       .byte $00 ; |        | $D47A
       .byte $00 ; |        | $D47B
LD47C:
       .byte $00 ; |        | $D47C shared
       .byte $00 ; |        | $D47D
       .byte $20 ; |  X     | $D47E
       .byte $20 ; |  X     | $D47F
       .byte $20 ; |  X     | $D480
       .byte $20 ; |  X     | $D481
       .byte $60 ; | XX     | $D482
       .byte $40 ; | X      | $D483
       .byte $40 ; | X      | $D484
       .byte $60 ; | XX     | $D485
       .byte $20 ; |  X     | $D486
       .byte $F0 ; |XXXX    | $D487
       .byte $B8 ; |X XXX   | $D488
       .byte $EC ; |XXX XX  | $D489
       .byte $F6 ; |XXXX XX | $D48A
       .byte $D3 ; |XX X  XX| $D48B
       .byte $50 ; | X X    | $D48C
       .byte $D0 ; |XX X    | $D48D
       .byte $E0 ; |XXX     | $D48E
       .byte $E0 ; |XXX     | $D48F
       .byte $E0 ; |XXX     | $D490
       .byte $E0 ; |XXX     | $D491
       .byte $E0 ; |XXX     | $D492
       .byte $40 ; | X      | $D493
       .byte $00 ; |        | $D494
       .byte $00 ; |        | $D495
       .byte $00 ; |        | $D496
       .byte $00 ; |        | $D497
       .byte $00 ; |        | $D498
       .byte $00 ; |        | $D499
       .byte $00 ; |        | $D49A
LD49B:
       .byte $00 ; |        | $D49B shared
       .byte $90 ; |X  X    | $D49C
       .byte $98 ; |X  XX   | $D49D
       .byte $90 ; |X  X    | $D49E
       .byte $90 ; |X  X    | $D49F
       .byte $D0 ; |XX X    | $D4A0
       .byte $50 ; | X X    | $D4A1
       .byte $70 ; | XXX    | $D4A2
       .byte $70 ; | XXX    | $D4A3
       .byte $20 ; |  X     | $D4A4
       .byte $20 ; |  X     | $D4A5
       .byte $70 ; | XXX    | $D4A6
       .byte $F0 ; |XXXX    | $D4A7
       .byte $B0 ; |X XX    | $D4A8
       .byte $F8 ; |XXXXX   | $D4A9
       .byte $7E ; | XXXXXX | $D4AA
       .byte $26 ; |  X  XX | $D4AB
       .byte $19 ; |   XX  X| $D4AC
       .byte $39 ; |  XXX  X| $D4AD
       .byte $38 ; |  XXX   | $D4AE
       .byte $38 ; |  XXX   | $D4AF
       .byte $38 ; |  XXX   | $D4B0
       .byte $38 ; |  XXX   | $D4B1
       .byte $10 ; |   X    | $D4B2
       .byte $00 ; |        | $D4B3
       .byte $00 ; |        | $D4B4
       .byte $00 ; |        | $D4B5
       .byte $00 ; |        | $D4B6
       .byte $00 ; |        | $D4B7
       .byte $00 ; |        | $D4B8
       .byte $00 ; |        | $D4B9
LD4BA:
       .byte $00 ; |        | $D4BA shared
       .byte $04 ; |     X  | $D4BB
       .byte $44 ; | X   X  | $D4BC
       .byte $76 ; | XXX XX | $D4BD
       .byte $7B ; | XXXX XX| $D4BE
       .byte $0B ; |    X XX| $D4BF
       .byte $1E ; |   XXXX | $D4C0
       .byte $1C ; |   XXX  | $D4C1
       .byte $18 ; |   XX   | $D4C2
       .byte $18 ; |   XX   | $D4C3
       .byte $38 ; |  XXX   | $D4C4
       .byte $B8 ; |X XXX   | $D4C5
       .byte $F0 ; |XXXX    | $D4C6
       .byte $F0 ; |XXXX    | $D4C7
       .byte $78 ; | XXXX   | $D4C8
       .byte $6C ; | XX XX  | $D4C9
       .byte $34 ; |  XX X  | $D4CA
       .byte $70 ; | XXX    | $D4CB
       .byte $70 ; | XXX    | $D4CC
       .byte $70 ; | XXX    | $D4CD
       .byte $70 ; | XXX    | $D4CE
       .byte $70 ; | XXX    | $D4CF
       .byte $20 ; |  X     | $D4D0
       .byte $00 ; |        | $D4D1
       .byte $00 ; |        | $D4D2
       .byte $00 ; |        | $D4D3
       .byte $00 ; |        | $D4D4
       .byte $00 ; |        | $D4D5
       .byte $00 ; |        | $D4D6
       .byte $00 ; |        | $D4D7
       .byte $00 ; |        | $D4D8
LD4D9:
       .byte $00 ; |        | $D4D9 shared
       .byte $20 ; |  X     | $D4DA
       .byte $30 ; |  XX    | $D4DB
       .byte $60 ; | XX     | $D4DC
       .byte $60 ; | XX     | $D4DD
       .byte $60 ; | XX     | $D4DE
       .byte $20 ; |  X     | $D4DF
       .byte $20 ; |  X     | $D4E0
       .byte $60 ; | XX     | $D4E1
       .byte $60 ; | XX     | $D4E2
       .byte $70 ; | XXX    | $D4E3
       .byte $30 ; |  XX    | $D4E4
       .byte $70 ; | XXX    | $D4E5
       .byte $70 ; | XXX    | $D4E6
       .byte $78 ; | XXXX   | $D4E7
       .byte $7C ; | XXXXX  | $D4E8
       .byte $24 ; |  X  X  | $D4E9
       .byte $32 ; |  XX  X | $D4EA
       .byte $72 ; | XXX  X | $D4EB
       .byte $70 ; | XXX    | $D4EC
       .byte $70 ; | XXX    | $D4ED
       .byte $70 ; | XXX    | $D4EE
       .byte $70 ; | XXX    | $D4EF
       .byte $20 ; |  X     | $D4F0
       .byte $00 ; |        | $D4F1
       .byte $00 ; |        | $D4F2
       .byte $00 ; |        | $D4F3
       .byte $00 ; |        | $D4F4
       .byte $00 ; |        | $D4F5
       .byte $00 ; |        | $D4F6
       .byte $00 ; |        | $D4F7
       .byte $00 ; |        | $D4F8

LD4F9: ;5 bytes
       .byte $08 ; |    X   | $D4F9
       .byte $09 ; |    X  X| $D4FA
       .byte $0B ; |    X XX| $D4FB
       .byte $0A ; |    X X | $D4FC
       .byte $00 ; |        | $D4FD

;free
       .byte $00 ; |        | $D4FE
       .byte $00 ; |        | $D4FF

       ORG  $3500
       RORG $D500

LD500:
       .byte COLORC+6 ; |XX   XX | $D500
       .byte COLORC+6 ; |XX   XX | $D501
       .byte COLORC+4 ; |XX   X  | $D502
       .byte COLORC+4 ; |XX   X  | $D503
       .byte COLORC+4 ; |XX   X  | $D504
       .byte COLORC+4 ; |XX   X  | $D505
       .byte COLORC+6 ; |XX   XX | $D506
       .byte COLORC+6 ; |XX   XX | $D507
       .byte COLORC+6 ; |XX   XX | $D508
       .byte COLOR0+2 ; |      X | $D509
       .byte COLOR0+2 ; |      X | $D50A
       .byte COLOR0+2 ; |      X | $D50B
       .byte COLORC+4 ; |XX   X  | $D50C
       .byte COLORC+4 ; |XX   X  | $D50D
       .byte COLORC+4 ; |XX   X  | $D50E
       .byte COLORC+4 ; |XX   X  | $D50F
LD510:
       .byte COLORC+4 ; |XX   X  | $D510
LD511:
       .byte COLORC+6 ; |XX   XX | $D511
       .byte COLORC+6 ; |XX   XX | $D512
       .byte COLORC+4 ; |XX   X  | $D513
       .byte COLORC+4 ; |XX   X  | $D514
       .byte COLORC+4 ; |XX   X  | $D515
       .byte COLORC+4 ; |XX   X  | $D516
       .byte COLORC+6 ; |XX   XX | $D517
       .byte COLOR0+2 ; |      X | $D518
       .byte COLOR0+2 ; |      X | $D519
       .byte COLOR0+2 ; |      X | $D51A
       .byte COLOR0+2 ; |      X | $D51B
       .byte COLOR0+2 ; |      X | $D51C
       .byte COLOR0+2 ; |      X | $D51D
       .byte COLORC+4 ; |XX   X  | $D51E
       .byte COLORC+4 ; |XX   X  | $D51F
       .byte COLORC+4 ; |XX   X  | $D520
       .byte COLORC+4 ; |XX   X  | $D521
       .byte COLORC+6 ; |XX   XX | $D522
       .byte COLORC+4 ; |XX   X  | $D523
       .byte COLORC+4 ; |XX   X  | $D524
       .byte COLORC+6 ; |XX   XX | $D525
       .byte COLORC+4 ; |XX   X  | $D526
       .byte COLORC+4 ; |XX   X  | $D527
       .byte COLORC+4 ; |XX   X  | $D528
       .byte COLORC+4 ; |XX   X  | $D529
       .byte COLORC+4 ; |XX   X  | $D52A
       .byte COLORC+6 ; |XX   XX | $D52B
       .byte COLORC+4 ; |XX   X  | $D52C
       .byte COLORC+4 ; |XX   X  | $D52D
       .byte COLORC+6 ; |XX   XX | $D52E
LD52F:
       .byte COLORC+6 ; |XX   XX | $D52F
LD530:
       .byte COLOR2+2 ; |  X   X | $D530
LD531:
       .byte COLOR2+2 ; |  X   X | $D531
       .byte COLOR2+2 ; |  X   X | $D532
       .byte COLOR2+2 ; |  X   X | $D533
       .byte COLOR2+0 ; |  X     | $D534
       .byte COLOR2+0 ; |  X     | $D535
       .byte COLOR2+0 ; |  X     | $D536
       .byte COLOR2+0 ; |  X     | $D537
       .byte COLOR2+0 ; |  X     | $D538
       .byte COLOR2+0 ; |  X     | $D539
       .byte COLOR2+2 ; |  X   X | $D53A
       .byte COLOR2+2 ; |  X   X | $D53B
       .byte COLOR2+2 ; |  X   X | $D53C
       .byte COLOR2+2 ; |  X   X | $D53D
       .byte COLOR2+2 ; |  X   X | $D53E
       .byte COLOR2+2 ; |  X   X | $D53F
       .byte COLOR2+2 ; |  X   X | $D540
       .byte COLOR2+4 ; |  X  X  | $D541
       .byte COLOR2+4 ; |  X  X  | $D542
       .byte COLOR2+4 ; |  X  X  | $D543
       .byte COLOR2+4 ; |  X  X  | $D544
       .byte COLOR2+2 ; |  X   X | $D545
       .byte COLOR2+2 ; |  X   X | $D546
       .byte COLOR2+4 ; |  X  X  | $D547
       .byte COLOR2+4 ; |  X  X  | $D548

LD549:
       .byte $00 ; |        | $D549
       .byte $08 ; |    X   | $D54A
       .byte $4C ; | X  XX  | $D54B
       .byte $88 ; |X   X   | $D54C
       .byte $88 ; |X   X   | $D54D
       .byte $D8 ; |XX XX   | $D54E
       .byte $D0 ; |XX X    | $D54F
       .byte $70 ; | XXX    | $D550
       .byte $70 ; | XXX    | $D551
       .byte $04 ; |     X  | $D552
       .byte $6C ; | XX XX  | $D553
       .byte $5C ; | X XXX  | $D554
       .byte $34 ; |  XX X  | $D555
       .byte $7C ; | XXXXX  | $D556
       .byte $78 ; | XXXX   | $D557
       .byte $78 ; | XXXX   | $D558
       .byte $20 ; |  X     | $D559
       .byte $30 ; |  XX    | $D55A
       .byte $70 ; | XXX    | $D55B
       .byte $70 ; | XXX    | $D55C
       .byte $70 ; | XXX    | $D55D
       .byte $70 ; | XXX    | $D55E
       .byte $70 ; | XXX    | $D55F
       .byte $20 ; |  X     | $D560
       .byte $00 ; |        | $D561
       .byte $00 ; |        | $D562
       .byte $00 ; |        | $D563
       .byte $00 ; |        | $D564
LD565:
       .byte $00 ; |        | $D565 shared
       .byte $00 ; |        | $D566 shared
       .byte $00 ; |        | $D567 shared
       .byte $00 ; |        | $D568 shared
       .byte $40 ; | X      | $D569
       .byte $40 ; | X      | $D56A
       .byte $20 ; |  X     | $D56B
       .byte $60 ; | XX     | $D56C
       .byte $C0 ; |XX      | $D56D
       .byte $F1 ; |XXXX   X| $D56E
       .byte $7F ; | XXXXXXX| $D56F
       .byte $7F ; | XXXXXXX| $D570
       .byte $B0 ; |X XX    | $D571
       .byte $EC ; |XXX XX  | $D572
       .byte $EC ; |XXX XX  | $D573
       .byte $78 ; | XXXX   | $D574
       .byte $30 ; |  XX    | $D575
       .byte $30 ; |  XX    | $D576
       .byte $70 ; | XXX    | $D577
       .byte $70 ; | XXX    | $D578
       .byte $70 ; | XXX    | $D579
       .byte $70 ; | XXX    | $D57A
       .byte $70 ; | XXX    | $D57B
       .byte $20 ; |  X     | $D57C
       .byte $00 ; |        | $D57D
       .byte $00 ; |        | $D57E
       .byte $00 ; |        | $D57F
       .byte $00 ; |        | $D580
       .byte $00 ; |        | $D581
       .byte $00 ; |        | $D582
       .byte $00 ; |        | $D583
LD584:
       .byte $00 ; |        | $D584 shared
       .byte $E0 ; |XXX     | $D585
       .byte $A6 ; |X X  XX | $D586
       .byte $EE ; |XXX XXX | $D587
       .byte $E8 ; |XXX X   | $D588
       .byte $48 ; | X  X   | $D589
       .byte $F8 ; |XXXXX   | $D58A
       .byte $FC ; |XXXXXX  | $D58B
       .byte $BC ; |X XXXX  | $D58C
       .byte $98 ; |X  XX   | $D58D
       .byte $8C ; |X   XX  | $D58E
       .byte $1C ; |   XXX  | $D58F
       .byte $1E ; |   XXXX | $D590
       .byte $12 ; |   X  X | $D591
       .byte $1A ; |   XX X | $D592
       .byte $18 ; |   XX   | $D593
       .byte $08 ; |    X   | $D594
       .byte $00 ; |        | $D595
       .byte $00 ; |        | $D596
       .byte $00 ; |        | $D597
       .byte $00 ; |        | $D598
       .byte $00 ; |        | $D599
       .byte $00 ; |        | $D59A
       .byte $00 ; |        | $D59B
       .byte $00 ; |        | $D59C
       .byte $00 ; |        | $D59D
       .byte $00 ; |        | $D59E
       .byte $00 ; |        | $D59F
       .byte $00 ; |        | $D5A0
       .byte $00 ; |        | $D5A1
       .byte $00 ; |        | $D5A2
LD5A3:
       .byte $00 ; |        | $D5A3 shared
       .byte $20 ; |  X     | $D5A4
       .byte $30 ; |  XX    | $D5A5
       .byte $60 ; | XX     | $D5A6
       .byte $60 ; | XX     | $D5A7
       .byte $60 ; | XX     | $D5A8
       .byte $20 ; |  X     | $D5A9
       .byte $20 ; |  X     | $D5AA
       .byte $70 ; | XXX    | $D5AB
       .byte $70 ; | XXX    | $D5AC
       .byte $60 ; | XX     | $D5AD
       .byte $B8 ; |X XXX   | $D5AE
       .byte $B8 ; |X XXX   | $D5AF
       .byte $F0 ; |XXXX    | $D5B0
       .byte $F0 ; |XXXX    | $D5B1
       .byte $C0 ; |XX      | $D5B2
       .byte $A0 ; |X X     | $D5B3
       .byte $D0 ; |XX X    | $D5B4
       .byte $70 ; | XXX    | $D5B5
       .byte $F8 ; |XXXXX   | $D5B6
       .byte $F0 ; |XXXX    | $D5B7
       .byte $E8 ; |XXX X   | $D5B8
       .byte $78 ; | XXXX   | $D5B9
       .byte $30 ; |  XX    | $D5BA
       .byte $00 ; |        | $D5BB
       .byte $00 ; |        | $D5BC
       .byte $00 ; |        | $D5BD
       .byte $00 ; |        | $D5BE
       .byte $00 ; |        | $D5BF
       .byte $00 ; |        | $D5C0
       .byte $00 ; |        | $D5C1
LD5C2:
       .byte $00 ; |        | $D5C2 shared
       .byte $40 ; | X      | $D5C3
       .byte $50 ; | X X    | $D5C4
       .byte $F0 ; |XXXX    | $D5C5
       .byte $50 ; | X X    | $D5C6
       .byte $50 ; | X X    | $D5C7
       .byte $48 ; | X  X   | $D5C8
       .byte $50 ; | X X    | $D5C9
       .byte $70 ; | XXX    | $D5CA
       .byte $70 ; | XXX    | $D5CB
       .byte $E8 ; |XXX X   | $D5CC
       .byte $B8 ; |X XXX   | $D5CD
       .byte $B0 ; |X XX    | $D5CE
       .byte $F0 ; |XXXX    | $D5CF
       .byte $70 ; | XXX    | $D5D0
       .byte $40 ; | X      | $D5D1
       .byte $40 ; | X      | $D5D2
       .byte $D0 ; |XX X    | $D5D3
       .byte $70 ; | XXX    | $D5D4
       .byte $F8 ; |XXXXX   | $D5D5
       .byte $F0 ; |XXXX    | $D5D6
       .byte $E8 ; |XXX X   | $D5D7
       .byte $78 ; | XXXX   | $D5D8
       .byte $70 ; | XXX    | $D5D9
       .byte $20 ; |  X     | $D5DA
       .byte $00 ; |        | $D5DB
       .byte $00 ; |        | $D5DC
       .byte $00 ; |        | $D5DD
       .byte $00 ; |        | $D5DE
       .byte $00 ; |        | $D5DF
LD5E0:
       .byte $00 ; |        | $D5E0 shared
       .byte $00 ; |        | $D5E1 shared
       .byte $74 ; | XXX X  | $D5E2
       .byte $78 ; | XXXX   | $D5E3
       .byte $BC ; |X XXXX  | $D5E4
       .byte $78 ; | XXXX   | $D5E5
       .byte $14 ; |   X X  | $D5E6
       .byte $FF ; |XXXXXXXX| $D5E7
       .byte $BD ; |X XXXX X| $D5E8
       .byte $99 ; |X  XX  X| $D5E9
       .byte $95 ; |X  X X X| $D5EA
       .byte $12 ; |   X  X | $D5EB
       .byte $11 ; |   X   X| $D5EC
       .byte $09 ; |    X  X| $D5ED
       .byte $08 ; |    X   | $D5EE
       .byte $00 ; |        | $D5EF
       .byte $00 ; |        | $D5F0
       .byte $00 ; |        | $D5F1
       .byte $00 ; |        | $D5F2
       .byte $00 ; |        | $D5F3
       .byte $00 ; |        | $D5F4
       .byte $00 ; |        | $D5F5
       .byte $00 ; |        | $D5F6
       .byte $00 ; |        | $D5F7
       .byte $00 ; |        | $D5F8
       .byte $00 ; |        | $D5F9
       .byte $00 ; |        | $D5FA
       .byte $00 ; |        | $D5FB
       .byte $00 ; |        | $D5FC
       .byte $00 ; |        | $D5FD
       .byte $00 ; |        | $D5FE
       .byte $00 ; |        | $D5FF

       ORG  $3600
       RORG $D600

LD600:
       .byte $00 ; |        | $D600
       .byte $88 ; |X   X   | $D601
       .byte $88 ; |X   X   | $D602
       .byte $D8 ; |XX XX   | $D603
       .byte $48 ; | X  X   | $D604
       .byte $48 ; | X  X   | $D605
       .byte $28 ; |  X X   | $D606
       .byte $28 ; |  X X   | $D607
       .byte $70 ; | XXX    | $D608
       .byte $70 ; | XXX    | $D609
       .byte $60 ; | XX     | $D60A
       .byte $B8 ; |X XXX   | $D60B
       .byte $B8 ; |X XXX   | $D60C
       .byte $F0 ; |XXXX    | $D60D
       .byte $F0 ; |XXXX    | $D60E
       .byte $C0 ; |XX      | $D60F
       .byte $A0 ; |X X     | $D610
       .byte $D0 ; |XX X    | $D611
       .byte $70 ; | XXX    | $D612
       .byte $F8 ; |XXXXX   | $D613
       .byte $F0 ; |XXXX    | $D614
       .byte $E8 ; |XXX X   | $D615
       .byte $78 ; | XXXX   | $D616
       .byte $30 ; |  XX    | $D617
       .byte $00 ; |        | $D618
       .byte $00 ; |        | $D619
       .byte $00 ; |        | $D61A
       .byte $00 ; |        | $D61B
       .byte $00 ; |        | $D61C
       .byte $00 ; |        | $D61D
       .byte $00 ; |        | $D61E
LD61F:
       .byte $00 ; |        | $D61F shared
       .byte $10 ; |   X    | $D620
       .byte $50 ; | X X    | $D621
       .byte $70 ; | XXX    | $D622
       .byte $50 ; | X X    | $D623
       .byte $50 ; | X X    | $D624
       .byte $30 ; |  XX    | $D625
       .byte $30 ; |  XX    | $D626
       .byte $70 ; | XXX    | $D627
       .byte $70 ; | XXX    | $D628
       .byte $E8 ; |XXX X   | $D629
       .byte $B8 ; |X XXX   | $D62A
       .byte $B0 ; |X XX    | $D62B
       .byte $F0 ; |XXXX    | $D62C
       .byte $70 ; | XXX    | $D62D
       .byte $40 ; | X      | $D62E
       .byte $40 ; | X      | $D62F
       .byte $D0 ; |XX X    | $D630
       .byte $70 ; | XXX    | $D631
       .byte $F8 ; |XXXXX   | $D632
       .byte $F0 ; |XXXX    | $D633
       .byte $E8 ; |XXX X   | $D634
       .byte $78 ; | XXXX   | $D635
       .byte $70 ; | XXX    | $D636
       .byte $20 ; |  X     | $D637
       .byte $00 ; |        | $D638
       .byte $00 ; |        | $D639
       .byte $00 ; |        | $D63A
       .byte $00 ; |        | $D63B
       .byte $00 ; |        | $D63C
       .byte $00 ; |        | $D63D
LD63E:
       .byte $00 ; |        | $D63E shared
       .byte $48 ; | X  X   | $D63F
       .byte $48 ; | X  X   | $D640
       .byte $D8 ; |XX XX   | $D641
       .byte $48 ; | X  X   | $D642
       .byte $48 ; | X  X   | $D643
       .byte $48 ; | X  X   | $D644
       .byte $50 ; | X X    | $D645
       .byte $70 ; | XXX    | $D646
       .byte $70 ; | XXX    | $D647
       .byte $E0 ; |XXX     | $D648
       .byte $B0 ; |X XX    | $D649
       .byte $B0 ; |X XX    | $D64A
       .byte $F0 ; |XXXX    | $D64B
       .byte $7E ; | XXXXXX | $D64C
       .byte $81 ; |X      X| $D64D
       .byte $D0 ; |XX X    | $D64E
       .byte $70 ; | XXX    | $D64F
       .byte $F8 ; |XXXXX   | $D650
       .byte $F0 ; |XXXX    | $D651
       .byte $E8 ; |XXX X   | $D652
       .byte $78 ; | XXXX   | $D653
       .byte $70 ; | XXX    | $D654
       .byte $20 ; |  X     | $D655
       .byte $00 ; |        | $D656
       .byte $00 ; |        | $D657
       .byte $00 ; |        | $D658
       .byte $00 ; |        | $D659
       .byte $00 ; |        | $D65A
       .byte $00 ; |        | $D65B
       .byte $00 ; |        | $D65C
LD65D:
       .byte $00 ; |        | $D65D shared
       .byte $09 ; |    X  X| $D65E
       .byte $09 ; |    X  X| $D65F
       .byte $1B ; |   XX XX| $D660
       .byte $09 ; |    X  X| $D661
       .byte $0A ; |    X X | $D662
       .byte $0A ; |    X X | $D663
       .byte $1C ; |   XXX  | $D664
       .byte $1C ; |   XXX  | $D665
       .byte $9C ; |X  XXX  | $D666
       .byte $B0 ; |X XX    | $D667
       .byte $B0 ; |X XX    | $D668
       .byte $F0 ; |XXXX    | $D669
       .byte $7C ; | XXXXX  | $D66A
       .byte $82 ; |X     X | $D66B
       .byte $D0 ; |XX X    | $D66C
       .byte $F8 ; |XXXXX   | $D66D
       .byte $F0 ; |XXXX    | $D66E
       .byte $78 ; | XXXX   | $D66F
       .byte $70 ; | XXX    | $D670
       .byte $20 ; |  X     | $D671
       .byte $00 ; |        | $D672
       .byte $00 ; |        | $D673
       .byte $00 ; |        | $D674
       .byte $00 ; |        | $D675
       .byte $00 ; |        | $D676
       .byte $00 ; |        | $D677
       .byte $00 ; |        | $D678
       .byte $00 ; |        | $D679
       .byte $00 ; |        | $D67A
       .byte $00 ; |        | $D67B
LD67C:
       .byte $00 ; |        | $D67C shared
       .byte $0C ; |    XX  | $D67D
       .byte $1C ; |   XXX  | $D67E
       .byte $18 ; |   XX   | $D67F
       .byte $38 ; |  XXX   | $D680
       .byte $38 ; |  XXX   | $D681
       .byte $18 ; |   XX   | $D682
       .byte $1C ; |   XXX  | $D683
       .byte $3C ; |  XXXX  | $D684
       .byte $34 ; |  XX X  | $D685
       .byte $7C ; | XXXXX  | $D686
       .byte $7C ; | XXXXX  | $D687
       .byte $7C ; | XXXXX  | $D688
       .byte $68 ; | XX X   | $D689
       .byte $6A ; | XX X X | $D68A
       .byte $5E ; | X XXXX | $D68B
       .byte $5C ; | X XXX  | $D68C
       .byte $5E ; | X XXXX | $D68D
       .byte $6E ; | XX XXX | $D68E
       .byte $6E ; | XX XXX | $D68F
       .byte $7E ; | XXXXXX | $D690
       .byte $74 ; | XXX X  | $D691
       .byte $58 ; | X XX   | $D692
       .byte $28 ; |  X X   | $D693
       .byte $34 ; |  XX X  | $D694
       .byte $7C ; | XXXXX  | $D695
       .byte $68 ; | XX X   | $D696
       .byte $74 ; | XXX X  | $D697
       .byte $68 ; | XX X   | $D698
       .byte $7C ; | XXXXX  | $D699
       .byte $38 ; |  XXX   | $D69A
LD69B:
       .byte $00 ; |        | $D69B shared
       .byte $60 ; | XX     | $D69C
       .byte $46 ; | X   XX | $D69D
       .byte $6C ; | XX XX  | $D69E
       .byte $6C ; | XX XX  | $D69F
       .byte $34 ; |  XX X  | $D6A0
       .byte $36 ; |  XX XX | $D6A1
       .byte $36 ; |  XX XX | $D6A2
       .byte $36 ; |  XX XX | $D6A3
       .byte $36 ; |  XX XX | $D6A4
       .byte $7E ; | XXXXXX | $D6A5
       .byte $7C ; | XXXXX  | $D6A6
       .byte $7C ; | XXXXX  | $D6A7
       .byte $CA ; |XX  X X | $D6A8
       .byte $DA ; |XX XX X | $D6A9
       .byte $BC ; |X XXXX  | $D6AA
       .byte $BC ; |X XXXX  | $D6AB
       .byte $BE ; |X XXXXX | $D6AC
       .byte $DE ; |XX XXXX | $D6AD
       .byte $DE ; |XX XXXX | $D6AE
       .byte $74 ; | XXX X  | $D6AF
       .byte $58 ; | X XX   | $D6B0
       .byte $28 ; |  X X   | $D6B1
       .byte $34 ; |  XX X  | $D6B2
       .byte $7C ; | XXXXX  | $D6B3
       .byte $68 ; | XX X   | $D6B4
       .byte $74 ; | XXX X  | $D6B5
       .byte $68 ; | XX X   | $D6B6
       .byte $7C ; | XXXXX  | $D6B7
       .byte $38 ; |  XXX   | $D6B8
       .byte $00 ; |        | $D6B9
LD6BA:
       .byte $00 ; |        | $D6BA shared
       .byte $87 ; |X    XXX| $D6BB
       .byte $86 ; |X    XX | $D6BC
       .byte $C4 ; |XX   X  | $D6BD
       .byte $C4 ; |XX   X  | $D6BE
       .byte $66 ; | XX  XX | $D6BF
       .byte $66 ; | XX  XX | $D6C0
       .byte $66 ; | XX  XX | $D6C1
       .byte $76 ; | XXX XX | $D6C2
       .byte $3E ; |  XXXXX | $D6C3
       .byte $3E ; |  XXXXX | $D6C4
       .byte $7E ; | XXXXXX | $D6C5
       .byte $7C ; | XXXXX  | $D6C6
       .byte $68 ; | XX X   | $D6C7
       .byte $6A ; | XX X X | $D6C8
       .byte $5E ; | X XXXX | $D6C9
       .byte $5C ; | X XXX  | $D6CA
       .byte $5E ; | X XXXX | $D6CB
       .byte $6E ; | XX XXX | $D6CC
       .byte $6E ; | XX XXX | $D6CD
       .byte $7E ; | XXXXXX | $D6CE
       .byte $74 ; | XXX X  | $D6CF
       .byte $58 ; | X XX   | $D6D0
       .byte $28 ; |  X X   | $D6D1
       .byte $34 ; |  XX X  | $D6D2
       .byte $7C ; | XXXXX  | $D6D3
       .byte $68 ; | XX X   | $D6D4
       .byte $74 ; | XXX X  | $D6D5
       .byte $68 ; | XX X   | $D6D6
       .byte $7C ; | XXXXX  | $D6D7
       .byte $38 ; |  XXX   | $D6D8
LD6D9:
       .byte $00 ; |        | $D6D9 shared
       .byte $1C ; |   XXX  | $D6DA
       .byte $18 ; |   XX   | $D6DB
       .byte $50 ; | X X    | $D6DC
       .byte $50 ; | X X    | $D6DD
       .byte $58 ; | X XX   | $D6DE
       .byte $68 ; | XX X   | $D6DF
       .byte $68 ; | XX X   | $D6E0
       .byte $78 ; | XXXX   | $D6E1
       .byte $38 ; |  XXX   | $D6E2
       .byte $78 ; | XXXX   | $D6E3
       .byte $7C ; | XXXXX  | $D6E4
       .byte $7C ; | XXXXX  | $D6E5
       .byte $CA ; |XX  X X | $D6E6
       .byte $DA ; |XX XX X | $D6E7
       .byte $BC ; |X XXXX  | $D6E8
       .byte $BC ; |X XXXX  | $D6E9
       .byte $BE ; |X XXXXX | $D6EA
       .byte $DE ; |XX XXXX | $D6EB
       .byte $DE ; |XX XXXX | $D6EC
       .byte $74 ; | XXX X  | $D6ED
       .byte $58 ; | X XX   | $D6EE
       .byte $28 ; |  X X   | $D6EF
       .byte $34 ; |  XX X  | $D6F0
       .byte $7C ; | XXXXX  | $D6F1
       .byte $68 ; | XX X   | $D6F2
       .byte $74 ; | XXX X  | $D6F3
       .byte $68 ; | XX X   | $D6F4
       .byte $7C ; | XXXXX  | $D6F5
       .byte $38 ; |  XXX   | $D6F6
       .byte $00 ; |        | $D6F7
       .byte $00 ; |        | $D6F8

;free
       .byte $00 ; |        | $D6F9

LD6FA: ;4 bytes
       .byte $07 ; |     XXX| $D6FA
       .byte $06 ; |     XX | $D6FB
       .byte $06 ; |     XX | $D6FC
       .byte $04 ; |     X  | $D6FD

;free
       .byte $00 ; |        | $D6FE
       .byte $00 ; |        | $D6FF

       ORG  $3700
       RORG $D700

LD700:
       .byte $00 ; |        | $D700
       .byte $8E ; |X   XXX | $D701
       .byte $8C ; |X   XX  | $D702
       .byte $C8 ; |XX  X   | $D703
       .byte $C8 ; |XX  X   | $D704
       .byte $6C ; | XX XX  | $D705
       .byte $6C ; | XX XX  | $D706
       .byte $6C ; | XX XX  | $D707
       .byte $6C ; | XX XX  | $D708
       .byte $7C ; | XXXXX  | $D709
       .byte $FC ; |XXXXXX  | $D70A
       .byte $F8 ; |XXXXX   | $D70B
       .byte $F0 ; |XXXX    | $D70C
       .byte $70 ; | XXX    | $D70D
       .byte $B0 ; |X XX    | $D70E
       .byte $D8 ; |XX XX   | $D70F
       .byte $E8 ; |XXX X   | $D710
       .byte $A8 ; |X X X   | $D711
       .byte $D8 ; |XX XX   | $D712
       .byte $F8 ; |XXXXX   | $D713
       .byte $7C ; | XXXXX  | $D714
       .byte $4E ; | X  XXX | $D715
       .byte $37 ; |  XX XXX| $D716
       .byte $53 ; | X X  XX| $D717
       .byte $69 ; | XX X  X| $D718
       .byte $F8 ; |XXXXX   | $D719
       .byte $D0 ; |XX X    | $D71A
       .byte $E8 ; |XXX X   | $D71B
       .byte $D0 ; |XX X    | $D71C
       .byte $F8 ; |XXXXX   | $D71D
       .byte $70 ; | XXX    | $D71E
LD71F:
       .byte $00 ; |        | $D71F shared
       .byte $70 ; | XXX    | $D720
       .byte $40 ; | X      | $D721
       .byte $60 ; | XX     | $D722
       .byte $60 ; | XX     | $D723
       .byte $30 ; |  XX    | $D724
       .byte $30 ; |  XX    | $D725
       .byte $30 ; |  XX    | $D726
       .byte $30 ; |  XX    | $D727
       .byte $50 ; | X X    | $D728
       .byte $E0 ; |XXX     | $D729
       .byte $F0 ; |XXXX    | $D72A
       .byte $F8 ; |XXXXX   | $D72B
       .byte $5C ; | X XXX  | $D72C
       .byte $AE ; |X X XXX | $D72D
       .byte $D7 ; |XX X XXX| $D72E
       .byte $E3 ; |XXX   XX| $D72F
       .byte $A9 ; |X X X  X| $D730
       .byte $DD ; |XX XXX X| $D731
       .byte $FD ; |XXXXXX X| $D732
       .byte $49 ; | X  X  X| $D733
       .byte $30 ; |  XX    | $D734
       .byte $50 ; | X X    | $D735
       .byte $68 ; | XX X   | $D736
       .byte $F8 ; |XXXXX   | $D737
       .byte $D0 ; |XX X    | $D738
       .byte $E8 ; |XXX X   | $D739
       .byte $D0 ; |XX X    | $D73A
       .byte $F8 ; |XXXXX   | $D73B
       .byte $70 ; | XXX    | $D73C
       .byte $00 ; |        | $D73D
LD73E:
       .byte $00 ; |        | $D73E shared
       .byte $8E ; |X   XXX | $D73F
       .byte $8C ; |X   XX  | $D740
       .byte $C8 ; |XX  X   | $D741
       .byte $C8 ; |XX  X   | $D742
       .byte $6C ; | XX XX  | $D743
       .byte $6C ; | XX XX  | $D744
       .byte $6C ; | XX XX  | $D745
       .byte $6C ; | XX XX  | $D746
       .byte $7C ; | XXXXX  | $D747
       .byte $FC ; |XXXXXX  | $D748
       .byte $F8 ; |XXXXX   | $D749
       .byte $F0 ; |XXXX    | $D74A
       .byte $70 ; | XXX    | $D74B
       .byte $70 ; | XXX    | $D74C
       .byte $FA ; |XXXXX X | $D74D
       .byte $FA ; |XXXXX X | $D74E
       .byte $D8 ; |XX XX   | $D74F
       .byte $E8 ; |XXX X   | $D750
       .byte $F0 ; |XXXX    | $D751
       .byte $78 ; | XXXX   | $D752
       .byte $4C ; | X  XX  | $D753
       .byte $3E ; |  XXXXX | $D754
       .byte $57 ; | X X XXX| $D755
       .byte $6B ; | XX X XX| $D756
       .byte $F9 ; |XXXXX  X| $D757
       .byte $D0 ; |XX X    | $D758
       .byte $E8 ; |XXX X   | $D759
       .byte $D0 ; |XX X    | $D75A
       .byte $F8 ; |XXXXX   | $D75B
       .byte $70 ; | XXX    | $D75C
LD75D:
       .byte $00 ; |        | $D75D shared
       .byte $04 ; |     X  | $D75E
       .byte $14 ; |   X X  | $D75F
       .byte $16 ; |   X XX | $D760
       .byte $1A ; |   XX X | $D761
       .byte $1C ; |   XXX  | $D762
       .byte $0E ; |    XXX | $D763
       .byte $06 ; |     XX | $D764
       .byte $06 ; |     XX | $D765
       .byte $06 ; |     XX | $D766
       .byte $3E ; |  XXXXX | $D767
       .byte $3E ; |  XXXXX | $D768
       .byte $7E ; | XXXXXX | $D769
       .byte $7C ; | XXXXX  | $D76A
       .byte $38 ; |  XXX   | $D76B
       .byte $3C ; |  XXXX  | $D76C
       .byte $3C ; |  XXXX  | $D76D
       .byte $5C ; | X XXX  | $D76E
       .byte $6C ; | XX XX  | $D76F
       .byte $1C ; |   XXX  | $D770
       .byte $78 ; | XXXX   | $D771
       .byte $4C ; | X  XX  | $D772
       .byte $34 ; |  XX X  | $D773
       .byte $76 ; | XXX XX | $D774
       .byte $7A ; | XXXX X | $D775
       .byte $EA ; |XXX X X | $D776
       .byte $F0 ; |XXXX    | $D777
       .byte $F8 ; |XXXXX   | $D778
       .byte $D0 ; |XX X    | $D779
       .byte $E8 ; |XXX X   | $D77A
       .byte $50 ; | X X    | $D77B
LD77C:
       .byte $00 ; |        | $D77C shared
       .byte $74 ; | XXX X  | $D77D
       .byte $FA ; |XXXXX X | $D77E
       .byte $FA ; |XXXXX X | $D77F
       .byte $FB ; |XXXXX XX| $D780
       .byte $FB ; |XXXXX XX| $D781
       .byte $77 ; | XXX XXX| $D782
       .byte $AE ; |X X XXX | $D783
       .byte $D9 ; |XX XX  X| $D784
       .byte $B3 ; |X XX  XX| $D785
       .byte $7E ; | XXXXXX | $D786
       .byte $7E ; | XXXXXX | $D787
       .byte $36 ; |  XX XX | $D788
       .byte $36 ; |  XX XX | $D789
       .byte $33 ; |  XX  XX| $D78A
       .byte $33 ; |  XX  XX| $D78B
       .byte $1A ; |   XX X | $D78C
       .byte $1A ; |   XX X | $D78D
       .byte $08 ; |    X   | $D78E
       .byte $00 ; |        | $D78F
       .byte $00 ; |        | $D790
       .byte $00 ; |        | $D791
       .byte $00 ; |        | $D792
       .byte $00 ; |        | $D793
       .byte $00 ; |        | $D794
       .byte $00 ; |        | $D795
       .byte $00 ; |        | $D796
       .byte $00 ; |        | $D797
       .byte $00 ; |        | $D798
       .byte $00 ; |        | $D799
       .byte $00 ; |        | $D79A
LD79B:
       .byte $00 ; |        | $D79B shared
       .byte $18 ; |   XX   | $D79C
       .byte $38 ; |  XXX   | $D79D
       .byte $30 ; |  XX    | $D79E
       .byte $70 ; | XXX    | $D79F
       .byte $70 ; | XXX    | $D7A0
       .byte $30 ; |  XX    | $D7A1
       .byte $38 ; |  XXX   | $D7A2
       .byte $38 ; |  XXX   | $D7A3
       .byte $68 ; | XX X   | $D7A4
       .byte $78 ; | XXXX   | $D7A5
       .byte $78 ; | XXXX   | $D7A6
       .byte $88 ; |X   X   | $D7A7
       .byte $EF ; |XXX XXXX| $D7A8
       .byte $FA ; |XXXXX X | $D7A9
       .byte $32 ; |  XX  X | $D7AA
       .byte $32 ; |  XX  X | $D7AB
       .byte $6A ; | XX X X | $D7AC
       .byte $DA ; |XX XX X | $D7AD
       .byte $BC ; |X XXXX  | $D7AE
       .byte $FC ; |XXXXXX  | $D7AF
       .byte $FE ; |XXXXXXX | $D7B0
       .byte $C6 ; |XX   XX | $D7B1
       .byte $18 ; |   XX   | $D7B2
       .byte $28 ; |  X X   | $D7B3
       .byte $74 ; | XXX X  | $D7B4
       .byte $7C ; | XXXXX  | $D7B5
       .byte $28 ; |  X X   | $D7B6
       .byte $7C ; | XXXXX  | $D7B7
       .byte $7C ; | XXXXX  | $D7B8
       .byte $38 ; |  XXX   | $D7B9
LD7BA:
       .byte $00 ; |        | $D7BA shared
       .byte $60 ; | XX     | $D7BB
       .byte $48 ; | X  X   | $D7BC
       .byte $50 ; | X X    | $D7BD
       .byte $50 ; | X X    | $D7BE
       .byte $58 ; | X XX   | $D7BF
       .byte $68 ; | XX X   | $D7C0
       .byte $6C ; | XX XX  | $D7C1
       .byte $7C ; | XXXXX  | $D7C2
       .byte $7C ; | XXXXX  | $D7C3
       .byte $78 ; | XXXX   | $D7C4
       .byte $78 ; | XXXX   | $D7C5
       .byte $00 ; |        | $D7C6
       .byte $88 ; |X   X   | $D7C7
       .byte $EF ; |XXX XXXX| $D7C8
       .byte $32 ; |  XX  X | $D7C9
       .byte $32 ; |  XX  X | $D7CA
       .byte $DA ; |XX XX X | $D7CB
       .byte $BC ; |X XXXX  | $D7CC
       .byte $FC ; |XXXXXX  | $D7CD
       .byte $FC ; |XXXXXX  | $D7CE
       .byte $E6 ; |XXX  XX | $D7CF
       .byte $58 ; | X XX   | $D7D0
       .byte $28 ; |  X X   | $D7D1
       .byte $74 ; | XXX X  | $D7D2
       .byte $7C ; | XXXXX  | $D7D3
       .byte $28 ; |  X X   | $D7D4
       .byte $7C ; | XXXXX  | $D7D5
       .byte $7C ; | XXXXX  | $D7D6
       .byte $38 ; |  XXX   | $D7D7
       .byte $00 ; |        | $D7D8
LD7D9:
       .byte $00 ; |        | $D7D9 shared
       .byte $C6 ; |XX   XX | $D7DA
       .byte $84 ; |X    X  | $D7DB
       .byte $84 ; |X    X  | $D7DC
       .byte $CC ; |XX  XX  | $D7DD
       .byte $CC ; |XX  XX  | $D7DE
       .byte $6C ; | XX XX  | $D7DF
       .byte $6C ; | XX XX  | $D7E0
       .byte $3C ; |  XXXX  | $D7E1
       .byte $78 ; | XXXX   | $D7E2
       .byte $78 ; | XXXX   | $D7E3
       .byte $78 ; | XXXX   | $D7E4
       .byte $88 ; |X   X   | $D7E5
       .byte $EF ; |XXX XXXX| $D7E6
       .byte $FA ; |XXXXX X | $D7E7
       .byte $32 ; |  XX  X | $D7E8
       .byte $32 ; |  XX  X | $D7E9
       .byte $6A ; | XX X X | $D7EA
       .byte $DA ; |XX XX X | $D7EB
       .byte $BC ; |X XXXX  | $D7EC
       .byte $FC ; |XXXXXX  | $D7ED
       .byte $FE ; |XXXXXXX | $D7EE
       .byte $C6 ; |XX   XX | $D7EF
       .byte $18 ; |   XX   | $D7F0
       .byte $28 ; |  X X   | $D7F1
       .byte $74 ; | XXX X  | $D7F2
       .byte $7C ; | XXXXX  | $D7F3
       .byte $28 ; |  X X   | $D7F4
       .byte $7C ; | XXXXX  | $D7F5
       .byte $7C ; | XXXXX  | $D7F6
       .byte $38 ; |  XXX   | $D7F7
LD7F8: ;4 bytes only?
       .byte $00 ; |        | $D7F8 shared
       .byte $80 ; |X       | $D7F9
       .byte $00 ; |        | $D7FA
       .byte $80 ; |X       | $D7FB
       .byte $00 ; |        | $D7FC
       .byte $00 ; |        | $D7FD
       .byte $00 ; |        | $D7FE
       .byte $00 ; |        | $D7FF

       ORG  $3800
       RORG $D800

LD200:
;       lda    loopCount2              ;3
;       lda    #$00                    ;2
;       sta.w  GRP0                    ;4
;       beq    LD225                   ;2 always branch
       nop                            ;2
       nop                            ;2
       lda    #$00                    ;2
       sta    GRP0                    ;3
       beq    LD225                   ;2 always branch

LD209:
;       nop                            ;2
;       nop                            ;2
;       nop                            ;2
;       lda    #$00                    ;2
;       sta.w  GRP1                    ;4
;       beq    LD237                   ;2 always branch
       dec    $2E                     ;5 waste 5 cycles
       sec                            ;2 waste 2 cycles
       lda    #$00                    ;2
       sta    GRP1                    ;3
       beq    LD237                   ;2 always branch

LD213:
       txa                            ;2
       tay                            ;2
       lda    (ballSpritePtr),y       ;5
       sta    ENABL                   ;3
       ldy    loopCount2              ;3
       cpy    #$20                    ;2
       bcs    LD200                   ;2
       lda    (rC7),y                 ;5
       sta    GRP0                    ;3
       lda    (rCF),y                 ;5
LD225:
       ldy    loopCount               ;3
       cpy    #$20                    ;2
       sta    HMOVE                   ;3
       sta    COLUP0                  ;3
       bcs    LD209                   ;2
       lda    (rC9),y                 ;5
       sta    GRP1                    ;3
       lda    (rD1),y                 ;5
       sta    COLUP1                  ;3
LD237:
       dec    loopCount2              ;5
       dec    loopCount               ;5
       dex                            ;2
       bpl    LD213                   ;2
       ldy    ballSpritePtr           ;3
       bne    LD246                   ;2
       lda    rD3+10                  ;3
       sta    ballSpritePtr           ;3
LD246:
       ldy    #$02                    ;2
       jmp    LDFEE                   ;3 (L93B9 destination)

LD24B:
       ldx    #$00                    ;2
       stx    GRP0                    ;3
       beq    LD25D                   ;2 always branch

LD251:
       ldy    loopCount2              ;3
       cpy    #$20                    ;2
       bcs    LD24B                   ;2
       lda    (rC3),y                 ;5
       sta    GRP0                    ;3
       lda    (rCB),y                 ;5
LD25D:
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       sta    COLUP0                  ;3
       ldx    #$00                    ;2
       stx    GRP1                    ;3
       stx    VDELP0                  ;3
       stx    COLUP1                  ;3
       lda    #$35                    ;2
       sta    CTRLPF                  ;3

       dec    $2E,x                   ;6 waste 6 cycles

       lda    rD3+7                   ;3
       and    #$0F                    ;2
       tax                            ;2
       lda    rA3                     ;3
       sta    REFP1                   ;3
;       nop                            ;2
;       nop                            ;2
;       nop                            ;2


       lda    rC0                     ;3
       sta    loopCount               ;3
       dey                            ;2
       cpy    #$20                    ;2
       bcs    LD28D                   ;2
       lda    (rC3),y                 ;5
       sta    tempGFX                 ;3
       lda    (rCB),y                 ;5
;       jmp    LD291                   ;3
       bcc    LD291                   ;2 always branch

LD28D:
       lda    #$00                    ;2
       sta    tempGFX                 ;3
LD291:
       dey                            ;2
       sta    WSYNC                   ;3
       sta    COLUP0                  ;3
       lda    tempGFX                 ;3
       sta.w  GRP0                    ;4
LD29B:
       dex                            ;2
       bpl    LD29B                   ;2
       sta    RESP1                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3

       inx                            ;2 X=0

       cpy    #$20                    ;2
       bcs    LD2B3                   ;2 @9/10
       lda    (rC3),y                 ;5
       sta    GRP0                    ;3
       lda    (rCB),y                 ;5
       sta    COLUP0                  ;3 @25
;       jmp    LD2B7                   ;3
       bcc    LD2B7                   ;2 always branch

LD2B3:
;;;;       ldx    #$00                    ;2 @10
       stx    GRP0                    ;3 @13
LD2B7: ;@26
       lda    rC3                     ;3
       sta    rC7                     ;3
       lda    rC3+1                   ;3
;       sta.w  rC7+1                   ;4
;       nop                            ;2
;       nop                            ;2
       sta    rC7+1                   ;3


       dey                            ;2
       lda    rCB                     ;3
       sta    rCF                     ;3
       lda    rCB+1                   ;3
       sta    rCF+1                     ;3
       lda    rD3+7                   ;3
       sta    HMP1                    ;3
       lda    (rC7),y                 ;5
;;;;       ldx    #$00                    ;2
       cpy    #$20                    ;2



       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       bcs    LD2F2                   ;2
       sta    GRP0                    ;3
       lda    #$35                    ;2
       sta    VDELP0                  ;3
       lda    (rCF),y                 ;5
       sta    COLUP0                  ;3
       stx    GRP1                    ;3
       nop                            ;2
LD2E8:
       dey                            ;2
LD2E9:
       sty    loopCount2              ;3
       ldx    #$24                    ;2
       sta    HMCLR                   ;3
       jmp    LD213                   ;3

LD2F2:
       stx    GRP0                    ;3
       stx    GRP1                    ;3
       jsr    LD2FC                   ;6 waste 12 cycles
;       jmp    LD2E8                   ;3
       bcs    LD2E8                   ;2 always branch

LDE97: ;moved subroutine here to reuse rts
       lda    rB8                     ;3
       cmp    #$D2                    ;2
       bcs    LDEA1                   ;2
       cmp    #$33                    ;2
       bcs    LD2FC                   ;2
LDEA1:
       lda    #$32                    ;2
       sta    rB8                     ;3
       lda    #$00                    ;2
       sta    rAD                     ;3
       clc                            ;2
LD2FC:
       rts                            ;6

;       ORG  $3904
;       RORG $D904

LD104:
;       lda.w  loopCount               ;4
;       nop                            ;2
;       nop                            ;2
;       nop                            ;2
;       nop                            ;2
;       jmp    LD129                   ;3
       dec    $2E                     ;5 waste 5 cycles
       dec    $2E                     ;5 waste 5 cycles
       sec                            ;2 waste 2 cycles
       bcs    LD129                   ;2 always branch

LD10E:
       lda    #$00                    ;2
;       sta.w  GRP1                    ;4
;       nop                            ;2
;       nop                            ;2
;       nop                            ;2
;       jmp    LD13F                   ;3
       sta    GRP1                    ;3
       dec    $2E                     ;5 waste 5 cycles
       sec                            ;2 waste 2 cycles
       bcs    LD13F                   ;2 always branch

LD119:
       ldy    loopCount2              ;3
       dec    loopCount2              ;5
       cpy    #$20                    ;2
       bcs    LD104                   ;2 @44/45
       lda    (rC3),y                 ;5
       sta    GRP0                    ;3
       lda    (rCB),y                 ;5
       sta    COLUP0                  ;3
LD129:
       txa                            ;2
       tay                            ;2
       lda    (bckgrndColorPtr),y     ;5
       ldy    loopCount               ;3
       cpy    #$20                    ;2
       sta    COLUBK                  ;3
       sta    HMOVE                   ;3
       bcs    LD10E                   ;2
       lda    (rC5),y                 ;5
       sta    GRP1                    ;3
       lda    (rCD),y                 ;5
       sta    COLUP1                  ;3
LD13F:
       dec    loopCount               ;5
       dex                            ;2
       bpl    LD119                   ;2
;       nop                            ;2
;       nop                            ;2
;       nop                            ;2
       dec    $2E+1,x                 ;6 waste 6 cycles
       ldx    rD3+8                   ;3
LD149:
       txa                            ;2
       tay                            ;2
       lda    (ballSpritePtr),y       ;5
       sta    ENABL                   ;3
       ldy    loopCount2              ;3
       cpy    #$20                    ;2
       bcs    LD176                   ;2
       lda    (rC3),y                 ;5
       sta    GRP0                    ;3
       lda    (rCB),y                 ;5
LD15B:
       ldy    loopCount               ;3
       cpy    #$20                    ;2
       sta    HMOVE                   ;3
       sta    COLUP0                  ;3
       bcs    LD17F                   ;2
       lda    (rC5),y                 ;5
       sta    GRP1                    ;3
       lda    (rCD),y                 ;5
       sta    COLUP1                  ;3
LD16D:
       dec    loopCount2              ;5
       dec    loopCount               ;5
       dex                            ;2
       bpl    LD149                   ;2
;       bmi    LD189                   ;2 always branch
;LD189:
       ldx    gameVariation           ;3
       ldy    LD0FA,x                 ;4
       bne    LD193                   ;2 @47/48
       jmp    LD251                   ;3

LD176:
;       lda    loopCount2              ;3
;       lda    #$00                    ;2
;       sta.w  GRP0                    ;4
       nop                            ;2
       nop                            ;2
       lda    #$00                    ;2
       sta    GRP0                    ;3
       beq    LD15B                   ;2 always branch

LD17F:
;       nop                            ;2
;       nop                            ;2
;       nop                            ;2
;       lda    #$00                    ;2
;       sta.w  GRP1                    ;4
;       beq    LD16D                   ;2 always branch
       dec    $2E                     ;5 waste 5 cycles
       sec                            ;2 waste 2 cycles
       lda    #$00                    ;2
       sta    GRP1                    ;3
       beq    LD16D                   ;2 always branch

LD193:
       cpy    #$01                    ;2 @50
       beq    LD19A                   ;2
       jmp    LDFEE                   ;3 (L93B9 destination)

LD19A:
;       ldx    #$00                    ;2 @55
;       lda    rD3+6                   ;3
;       and    #$0F                    ;2
;       tay                            ;2
;       sta    WSYNC                   ;3
;       stx    GRP0                    ;3
;       stx    GRP1                    ;3
;       stx.w  COLUP1                  ;4
;LD1AA:
;       dey                            ;2
;       bpl    LD1AA                   ;2
       dey                            ;2 @55 y=0
       lda    rD3+6                   ;3
       sty    COLUP1                  ;3
       sta    WSYNC                   ;3
       sty    GRP0                    ;3
       sty    GRP1                    ;3
       and    #$0F                    ;2
       tax                            ;2
LD1AA:
       dex                            ;2
       bpl    LD1AA                   ;2

       sta    RESP0                   ;3
       sta    WSYNC                   ;3
       lda    rD3+7                   ;3
       lda    rD3+7                   ;3
       and    #$0F                    ;2
;       tay                            ;2
;LD1B8:
;       dey                            ;2
       tax                            ;2
LD1B8:
       dex                            ;2


       bpl    LD1B8                   ;2
       sta    RESP1                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       lda    rA2                     ;3
       sta    REFP0                   ;3
       lda    rA3                     ;3
       sta    REFP1                   ;3
       lda    rD3+6                   ;3
       sta    HMP0                    ;3
       lda    rD3+7                   ;3
       sta    HMP1                    ;3
       lda    ballSpiteSize           ;3
       sta    CTRLPF                  ;3
;       lda    #$01                    ;2
;       sta    VDELP0                  ;3
       iny                            ;2 y=1
       sty    VDELP0                  ;3

       lda    #$30                    ;2
       sta    NUSIZ0                  ;3
       sta    NUSIZ1                  ;3
;       ldy    ballSpritePtr           ;3
;       lda    rD3+10                  ;3
;       sta    ballSpritePtr           ;3
;       sty    rD3+10                  ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
;       jsr    LD2FC                   ;6 waste 12 cycles
       ldy    ballSpritePtr           ;3
       lda    rD3+10                  ;3
       sta    ballSpritePtr           ;3
       sty    rD3+10                  ;3

;       ldy    rBF                     ;3
;       sty    loopCount2              ;3
;       ldy    rC0                     ;3
;       sty    loopCount               ;3
;       ldx    #$24                    ;2
;       sta    HMCLR                   ;3
;       nop                            ;2
;       nop                            ;2
;       jmp    LD213                   ;3
       ldy    rC0                     ;3
       sty.w  loopCount               ;4
       ldy    rBF                     ;3
       jmp    LD2E9                   ;3

;       ORG  $39E8
;       RORG $D9E8

LD004:
       ldy    rAC                     ;3
       lda    LD0E1,y                 ;4
       sta    bckgrndColorPtr         ;3
       ldx    #>LD300                 ;2
       ldy    #$00                    ;2
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       stx    bckgrndColorPtr+1       ;3
       lda    #$30                    ;2
       sta    NUSIZ0                  ;3
       sta    NUSIZ1                  ;3
       sty    COLUP1                  ;3
       ldx    rAA                     ;3
       cpx    #$20                    ;2
       bcc    LD026                   ;2
       jmp    LDFE8                   ;3 (L92D6 destination)

LD026:
       ldy    rA8                     ;3
       lda    LD8FB,y                 ;4
       sta    COLUPF                  ;3
       lda    rA0                     ;3
       sta    REFP0                   ;3
       lda    rA1                     ;3
       sta    REFP1                   ;3
       ldy    gameVariation           ;3
       lda    LD0F4,y                 ;4
       sta    rD3+8                   ;3
       ldy    #$0F                    ;2
       lda    (bckgrndColorPtr),y     ;5
       tax                            ;2
       iny                            ;2
       lda    (bckgrndColorPtr),y     ;5
       sta    WSYNC                   ;3
       sta    COLUBK                  ;3
       lda    rD3+4                   ;3
       and    #$0F                    ;2
       tay                            ;2
LD04D:
       dey                            ;2
LD04E:
       bpl    LD04D                   ;2
       sta    RESP0                   ;3
       sta    WSYNC                   ;3
       stx    COLUBK                  ;3
       lda    rD3+5                   ;3
       and    #$0F                    ;2
       tay                            ;2
LD05B:
       dey                            ;2
       bpl    LD05B                   ;2
       sta    RESP1                   ;3
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       ldy    #$0E                    ;2
       lda    (bckgrndColorPtr),y     ;5
       sta    COLUBK                  ;3
       ldy    rBD                     ;3
       sty    loopCount2              ;3
       ldy    rBE                     ;3
       sty    loopCount               ;3
       lda    rD3+4                   ;3
       sta    HMP0                    ;3
       lda    rD3+5                   ;3
       sta    HMP1                    ;3
       lda    ballSpiteSize           ;3
       sta    CTRLPF                  ;3
;       lda    #$01                    ;2
;       sta    VDELP0                  ;3
;       sta    VDELBL                  ;3
;       lda    #$30                    ;2
;       sta    NUSIZ0                  ;3
;       sta    NUSIZ1                  ;3
       ldy    #$31                    ;2
       sty    VDELP0                  ;3
       sty    VDELBL                  ;3
       dey                            ;2
       sty    NUSIZ0                  ;3
       sty    NUSIZ1                  ;3

       ldy    #$0D                    ;2
       lda    (bckgrndColorPtr),y     ;5
       sta    CXCLR                   ;3
       ldx    #$0C                    ;2
       sta    WSYNC                   ;3
       sta    HMOVE                   ;3
       sta    COLUBK                  ;3
       lda    #$10                    ;2 used by ball sprite?
       bit    r81                     ;3
       bne    LD0A4                   ;2
       ldy    #$00                    ;2
       nop                            ;2
       nop                            ;2
       beq    LD0AA                   ;2 always branch

LD0A4:
       ldy    ballSpritePtr           ;3
       lda    #$00                    ;2
       sta    ballSpritePtr           ;3
LD0AA:
       sty    rD3+10                  ;3
       sta    HMCLR                   ;3
       jmp    LD119                   ;3

;       ORG  $3A94
;       RORG $DA94











LDAC4:
       ldx    #$03                    ;2
LDAC6:
       ldy    r94,x                   ;4
       lda    r98,x                   ;4
       bne    LDACF                   ;2
       jmp    LDB9B                   ;3

LDACF:
       cmp    #$2E                    ;2
       bcs    LDAD7                   ;2
       cpy    #$05                    ;2
       bne    LDB0F                   ;2
LDAD7:
       lda    rB2,x                   ;4
       cmp    #$3F                    ;2
       bcc    LDB0B                   ;2
       cmp    #$C8                    ;2
       bcs    LDB0B                   ;2
       lda    frameCounter            ;3
       and    #$03                    ;2
       bne    LDB0B                   ;2
       lda    r98,x                   ;4
       cmp    #$2E                    ;2
       bcc    LDAFF                   ;2
       dec    r94,x                   ;6
       bmi    LDAF3                   ;2
       bne    LDAF7                   ;2
LDAF3:
       lda    #$04                    ;2
       sta    r94,x                   ;4
LDAF7:
       lda    rA0,x                   ;4
       lsr                            ;2
       eor    #$04                    ;2
       jmp    LDB01                   ;3

LDAFF:
       lda    rA0,x                   ;4
LDB01:
       and    #$04                    ;2
       beq    LDB09                   ;2
       dec    rB2,x                   ;6
       dec    rB2,x                   ;6
LDB09:
       inc    rB2,x                   ;6
LDB0B:
       lda    r98,x                   ;4
       cmp    #$17                    ;2
LDB0F:
       bne    LDB7C                   ;2
       lda    rA0,x                   ;4
       and    #$E0                    ;2
       beq    LDB43                   ;2
       lda    rF0                     ;3
       cmp    #$03                    ;2
       bne    LDB43                   ;2
       lda    rE8,x                   ;4
       and    #$01                    ;2
       beq    LDB43                   ;2
       lda    r81                     ;3
       cpx    #$02                    ;2
       bcs    LDB2F                   ;2
       and    #$10                    ;2
       bne    LDB43                   ;2
       beq    LDB33                   ;2 always branch

LDB2F:
       and    #$10                    ;2
       beq    LDB43                   ;2
LDB33:
       lda    #$04                    ;2
       sta    rA8                     ;3
       lda    #$32                    ;2
       sta    rB8                     ;3
       lda    #$00                    ;2
       sta    ballSpritePtr           ;3
       sta    rA9                     ;3
       beq    LDB64                   ;2 always branch

LDB43:
       lda    rA4,x                   ;4
       beq    LDB4D                   ;2
       lda    #$01                    ;2
       sta    r98,x                   ;4
       bne    LDB7C                   ;2 always branch

LDB4D:
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LDB60                   ;2
       lda    rE8,x                   ;4
       and    #$01                    ;2
       beq    LDB60                   ;2
       ldy    rF0                     ;3
       lda    LD8E6,y                 ;4
       bne    LDB62                   ;2 always branch

LDB60:
       lda    #$03                    ;2
LDB62:
       sta    rA4,x                   ;4
LDB64:
       lda    rA0,x                   ;4
       and    #$F7                    ;2
       sta    rA0,x                   ;4
       lda    rA0,x                   ;4
       lsr                            ;2
       and    #$08                    ;2
       ora    rA0,x                   ;4
       sta    rA0,x                   ;4
       lda    #$06                    ;2
       sta    r94,x                   ;4
       lda    #$06                    ;2
       jsr    LD8EA                   ;6
LDB7C:
       lda    r98,x                   ;4
       cmp    #$0F                    ;2
       bne    LDB97                   ;2
       ldy    r94,x                   ;4
       cpy    #$0A                    ;2
       bcc    LDB97                   ;2
       lda    LD9F2,y                 ;4
       cmp    #$FF                    ;2
       bne    LDB94                   ;2
       ldy    rA8                     ;3
       lda    LD4F9,y                 ;4
LDB94:
       jsr    LD8EA                   ;6
LDB97:
       dec    r98,x                   ;6
       bne    LDBB9                   ;2
LDB9B:
       lda    rA0,x                   ;4
       and    #$E0                    ;2
       bne    LDBB9                   ;2
       ldy    r94,x                   ;4
       cpy    #$05                    ;2
       bmi    LDBB9                   ;2
       lda    #$0F                    ;2
       cpy    #$05                    ;2
       bcc    LDBB3                   ;2
       cpy    #$08                    ;2
       bcs    LDBB3                   ;2
       lda    #$04                    ;2
LDBB3:
       sta    r98,x                   ;4
       lda    #$00                    ;2
       sta    r94,x                   ;4
LDBB9:
       dex                            ;2
       bmi    LDBBF                   ;2
       jmp    LDAC6                   ;3

LDBBF:
       lda    rA9                     ;3
       bne    LDBCC                   ;2
       lda    rB8                     ;3
       cmp    #$32                    ;2
       bne    LDBD3                   ;2
       jmp    LDC7C                   ;3

LDBCC:
       cmp    #$02                    ;2
       beq    LDBD3                   ;2
       jmp    LDC7C                   ;3

LDBD3:
       ldy    #$01                    ;2
       sty    rC5                     ;3
       lda    #$10                    ;2
       and    r81                     ;3
       beq    LDBDF                   ;2
       ldy    #$03                    ;2
LDBDF:
       ldx    rE8,y                   ;4
       lda    rA9                     ;3
       bne    LDC07                   ;2
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LDBF5                   ;2
       lda    r94,x                   ;4
       cpy    #$01                    ;2
       beq    LDBFD                   ;2
       cpy    #$03                    ;2
       beq    LDBFD                   ;2
LDBF5:
       lda    r94,x                   ;4
       cmp    #$08                    ;2
       bne    LDC74                   ;2
       beq    LDC07                   ;2 always branch

LDBFD:
       cmp    #$04                    ;2
       bcs    LDC74                   ;2
       lda    rA0,x                   ;4
       and    #$02                    ;2
       bne    LDC74                   ;2
LDC07:
       stx    rD1+1                   ;3
       txa                            ;2
       and    #$01                    ;2
       tax                            ;2
       lda    CXP0FB,x                ;4
       ldx    rD1+1                   ;3
       and    #$40                    ;2
       beq    LDC74                   ;2
       lda    rA9                     ;3
       beq    LDC63                   ;2
       tya                            ;2
       and    #$01                    ;2
       lsr                            ;2
       bit    rAE                     ;3
       bpl    LDC24                   ;2
       bcs    LDC74                   ;2
       .byte $2C                      ;4 skip next 2 bytes
LDC24:
       bcc    LDC74                   ;2
       lda    r94,x                   ;4
       cmp    #$05                    ;2
       bcc    LDC30                   ;2
       cmp    #$08                    ;2
       bcc    LDC4A                   ;2
LDC30:
       cmp    #$0A                    ;2
       bne    LDC3A                   ;2
       lda    rA8                     ;3
       and    #$01                    ;2
       bne    LDC7C                   ;2
LDC3A:
       lda    r81                     ;3
       and    #$FC                    ;2
       sta    r81                     ;3
       tya                            ;2
       and    #$01                    ;2
       clc                            ;2
       adc    #$01                    ;2
       ora    r81                     ;3
       sta    r81                     ;3
LDC4A:
       ldx    rA8                     ;3
       beq    LDC7C                   ;2
       cpx    #$02                    ;2
       beq    LDC7C                   ;2
       ldx    #$01                    ;2
       bcs    LDC5F                   ;2
       dex                            ;2
       lda    #$32                    ;2
       sta    rB8                     ;3
       lda    #$04                    ;2
       sta    rA8                     ;3
LDC5F:
       stx    rA9                     ;3
       bne    LDC7C                   ;2 always branch?
LDC63:
       lda    #$20                    ;2
       cmp    rBD,x                   ;4
       bcc    LDC6B                   ;2
       sta    rBD,x                   ;4
LDC6B:
       lda    LD7F8,y                 ;4
       sta    rAE                     ;3
       inc    rA9                     ;5
       bne    LDC7C                   ;2 always branch?
LDC74:
       dey                            ;2
       dec    rC5                     ;5
       bmi    LDC7C                   ;2
       jmp    LDBDF                   ;3

LDC7C:
       jsr    LDEAB                   ;6
       lda    rA0,x                   ;4
       and    #$08                    ;2
       sta    temp                    ;3
       ldy    rA8                     ;3
       lda    rA9                     ;3
       cmp    #$02                    ;2
       bcc    LDCB2                   ;2
       beq    LDC92                   ;2
       jmp    LDD27                   ;3

LDC92:
       tya                            ;2
       bne    LDCC1                   ;2
       lda    r94,x                   ;4
       cmp    #$0D                    ;2
       bne    LDCB5                   ;2
       lda    r98,x                   ;4
       cmp    #$0E                    ;2
       bcc    LDCB2                   ;2
       lda    ballSpritePtr           ;3
       adc    #$4B                    ;2 switch to horizontal bat
       sta    ballSpritePtr           ;3
       lda    temp                    ;3
       beq    LDCB2                   ;2
       lda    rB8                     ;3
       sec                            ;2
       sbc    #$08                    ;2
       sta    rB8                     ;3
LDCB2:
       jmp    LDD35                   ;3

LDCB5:
       lda    ballSpritePtr           ;3
       sbc    #$4A                    ;2 switch to vertical bat
       sta    ballSpritePtr           ;3
       lda    #$01                    ;2
       sta    rA9                     ;3
       bne    LDD35                   ;2 always branch

LDCC1:
       lsr    temp                    ;5
       lsr    temp                    ;5
       lsr    temp                    ;5
       lda    rAD                     ;3
       bne    LDCDB                   ;2
       lda    rA0,x                   ;4
       and    #$FE                    ;2
       ora    temp                    ;3
       sta    rA0,x                   ;4
       lda    ballSpritePtr           ;3
       sta    checkB6                 ;3
       lda    #$09                    ;2
       sta    rAD                     ;3
LDCDB:
       lda    rA0,x                   ;4
       lsr                            ;2
       bcc    LDCE3                   ;2
       dec    rB8                     ;5
       .byte $2C                      ;4 skip next 2 bytes
LDCE3:
       inc    rB8                     ;5
       jsr    LDE97                   ;6
       bcs    LDCFC                   ;2
       ldy    #$01                    ;2
       lda    rA8                     ;3
       cmp    #$03                    ;2
       beq    LDCF7                   ;2
       dey                            ;2
       lda    #$04                    ;2
       sta    rA8                     ;3
LDCF7:
       sty    rA9                     ;3
       jmp    LDD35                   ;3

LDCFC:
       lda    frameCounter            ;3
       cpy    #$02                    ;2
       beq    LDD27                   ;2
       and    #$07                    ;2
       bne    LDCB2                   ;2
       bcs    LDD35                   ;2
       ldx    rB8                     ;3
       ldy    #$00                    ;2
       lda    checkB6                 ;3
       cmp    ballSpritePtr           ;3
       bne    LDD1E                   ;2
       cpx    #$35                    ;2
       bcc    LDD18                   ;2
       dex                            ;2
       dex                            ;2
LDD18:
       ldy    #$20                    ;2
       lda    ballSpritePtr           ;3
       adc    #$48                    ;2 switch to horizontal bat
LDD1E:
       sta    ballSpritePtr           ;3
       sty    ballSpiteSize           ;3
       stx    rB8                     ;3
       jmp    LDD35                   ;3

LDD27:
       lda    frameCounter            ;3
       and    #$03                    ;2
       bne    LDD35                   ;2
       inc    ballSpritePtr           ;5
       dec    rAD                     ;5
       bne    LDD35                   ;2
       sta    rA9                     ;3
LDD35:
       ldy    rA8                     ;3
       lda    rA9                     ;3
       cmp    #$01                    ;2
       bne    LDD74                   ;2
       jsr    LDEAB                   ;6
       ldy    rA8                     ;3
       lda    rA0,x                   ;4
       and    #$08                    ;2
       beq    LDD51                   ;2
       lda    rB2,x                   ;4
       sec                            ;2
       sbc    LD100,y                 ;4
       jmp    LDD57                   ;3

LDD51:
       lda    rB2,x                   ;4
       clc                            ;2
       adc    LD6FA,y                 ;4
LDD57:
       sta    rB8                     ;3
       jsr    LDE97                   ;6
       lda    rBD,x                   ;4
       sec                            ;2
       sbc    #$18                    ;2
       ldx    gameVariation           ;3
       cpx    #$01                    ;2
       bne    LDD6E                   ;2
       clc                            ;2
       adc    LD8E2,y                 ;4
       jmp    LDD72                   ;3

LDD6E:
       clc                            ;2
       adc    LD8DE,y                 ;4
LDD72:
       sta    ballSpritePtr           ;3
LDD74:
       jsr    LDE97                   ;6
       lda    rA8                     ;3
       asl                            ;2
       asl                            ;2
       adc    rA9                     ;3
       tax                            ;2
       lda    LD3EF,x                 ;4
       bmi    LDD85                   ;2
       sta    ballSpiteSize           ;3
LDD85:
       lda    rA9                     ;3
       asl                            ;2
       asl                            ;2
       ora    ballSpiteSize           ;3
       sta    ballSpiteSize           ;3
       ldx    #$01                    ;2
       jsr    LDEBD                   ;6
       bne    LDDDE                   ;2
       ldx    rBD                     ;3
       cpx    rBE                     ;3
       bcs    LDDDE                   ;2
       ldy    rBE                     ;3
       stx    rBE                     ;3
       sty    rBD                     ;3
       ldx    r98                     ;3
       ldy    r99                     ;3
       stx    r99                     ;3
       sty    r98                     ;3
       ldx    rB2                     ;3
       ldy    rB3                     ;3
       stx    rB3                     ;3
       sty    rB2                     ;3
       ldx    r94                     ;3
       ldy    r95                     ;3
       stx    r95                     ;3
       sty    r94                     ;3
       ldx    rA0                     ;3
       ldy    rA1                     ;3
       stx    rA1                     ;3
       sty    rA0                     ;3
       ldx    r9C                     ;3
       ldy    r9D                     ;3
       stx    r9D                     ;3
       sty    r9C                     ;3
       ldx    rA4                     ;3
       ldy    rA5                     ;3
       stx    rA5                     ;3
       sty    rA4                     ;3
       lda    rAB                     ;3
       eor    #$01                    ;2
       sta    rAB                     ;3
       ldx    rE8                     ;3
       ldy    rE9                     ;3
       stx    rE9                     ;3
       sty    rE8                     ;3
LDDDE:
       ldx    #$03                    ;2
       jsr    LDEBD                   ;6
       beq    LDDE9                   ;2
       lda    gameVariation           ;3
       bne    LDE33                   ;2
LDDE9:
       ldx    rBF                     ;3
       cpx    rC0                     ;3
       bcs    LDE33                   ;2
       ldy    rC0                     ;3
       stx    rC0                     ;3
       sty    rBF                     ;3
       ldx    r9A                     ;3
       ldy    r9B                     ;3
       stx    r9B                     ;3
       sty    r9A                     ;3
       ldx    rB4                     ;3
       ldy    rB5                     ;3
       stx    rB5                     ;3
       sty    rB4                     ;3
       ldx    r96                     ;3
       ldy    r97                     ;3
       stx    r97                     ;3
       sty    r96                     ;3
       ldx    rA2                     ;3
       ldy    rA3                     ;3
       stx    rA3                     ;3
       sty    rA2                     ;3
       ldx    r9E                     ;3
       ldy    r9F                     ;3
       stx    r9F                     ;3
       sty    r9E                     ;3
       ldx    rA6                     ;3
       ldy    rA7                     ;3
       stx    rA7                     ;3
       sty    rA6                     ;3
       lda    rAB                     ;3
       eor    #$02                    ;2
       sta    rAB                     ;3
       ldx    rEA                     ;3
       ldy    rEB                     ;3
       stx    rEB                     ;3
       sty    rEA                     ;3
LDE33:
       ldx    #$03                    ;2
       stx    loopCount2              ;3
LDE37:
       ldx    loopCount2              ;3 0=p1
       lda    rE8,x                   ;4
       tax                            ;2
       asl                            ;2
       sta    rF4                     ;3

       ldy    r94,x                   ;4
       lda    rAB                     ;3
       and    #$0C                    ;2
       cmp    #$04                    ;2
       bne    LDE53                   ;2
       bit    rAB                     ;3
       bpl    LDE53                   ;2
       lda    rA0,x                   ;4
       and    #$02                    ;2
       beq    LDE6F                   ;2
LDE53:
       lda    loopCount2              ;3
       and    #$01                    ;2
       beq    LDE63                   ;2
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LDE63                   ;2
       lda    rF0                     ;3
       bne    LDE6B                   ;2
LDE63:
       ldx    LDEFA,y                 ;4 y=$0A for jumpkick
       lda    LDF08,y                 ;4
       bne    LDE89                   ;2 always branch

LDE6B:
       cmp    #$01                    ;2
       bne    LDE77                   ;2
LDE6F:
       ldx    LDF16,y                 ;4
       lda    LDF20,y                 ;4
       bne    LDE89                   ;2 always branch

LDE77:
       cmp    #$02                    ;2
       bne    LDE83                   ;2
       ldx    LDF2A,y                 ;4
       lda    LDF37,y                 ;4
       bne    LDE89                   ;2 always branch

LDE83:
       ldx    LDF44,y                 ;4
       lda    LDF52,y                 ;4
LDE89:
       ldy    rF4                     ;3
       stx    rC3,y                   ;4
       sta.wy rC3+1,y                 ;5
       dec    loopCount2              ;5
       bpl    LDE37                   ;2
       jmp    LDFC4                   ;3

LDEAB:
       ldy    #$00                    ;2
       bit    rAE                     ;3
       bpl    LDEB2                   ;2
       iny                            ;2
LDEB2:
       lda    #$10                    ;2
       bit    r81                     ;3
       beq    LDEBA                   ;2
       iny                            ;2
       iny                            ;2
LDEBA:
       ldx    rE8,y                   ;4
       rts                            ;6

LDEBD:
       lda    #$00                    ;2
       sta    rEC                     ;3
LDEC1:
       lda    r94,x                   ;4
       cmp    #$0A                    ;2
       bne    LDEF1                   ;2
       lda    r98,x                   ;4
       and    #$01                    ;2
       beq    LDEDB                   ;2
       lda    r98,x                   ;4
       cmp    #$0B                    ;2
       bcc    LDED7                   ;2
       dec    rBD,x                   ;6
       dec    rBD,x                   ;6
LDED7:
       inc    rBD,x                   ;6
       inc    rEC                     ;5
LDEDB:
       ldy    rB2,x                   ;4
       lda    rA0,x                   ;4
       and    #$08                    ;2
       bne    LDEEB                   ;2
       cpy    #$C4                    ;2
       bcs    LDEF1                   ;2
       inc    rB2,x                   ;6
       bne    LDEF1                   ;2
LDEEB:
       cpy    #$40                    ;2
       bcc    LDEF1                   ;2
       dec    rB2,x                   ;6
LDEF1:
       dex                            ;2
       txa                            ;2
       and    #$01                    ;2
       beq    LDEC1                   ;2
       lda    rEC                     ;3
       rts                            ;6


LDF60:
       ldx    gameVariation           ;3 game selection #
;;       cpx    #$02                    ;2 unknown routine...buttons not used here
;;       beq    LDF74                   ;2
;;       lda    r91                     ;3
;;       and    #$0F                    ;2
;;       bne    LDF74                   ;2
;;       bit    INPT4                   ;3
;;       bpl    LDF74                   ;2
;;       bit    INPT5                   ;3
;;       bmi    LDF74                   ;2 ??
;;LDF74:
       asl    r92                     ;5
       lsr    r92                     ;5
       sty    rA9                     ;3
       sty    rAC                     ;3
       sty    rAA                     ;3
       inx                            ;2
       txa                            ;2
       cmp    #$03                    ;2
       bcc    LDF85                   ;2
       tya                            ;2 game selection rollover
LDF85:
       sta    gameVariation           ;3
       asl                            ;2
       asl                            ;2
       sta    r81                     ;3
       lda    gameVariation           ;3 set game select...
       adc    #$A1                    ;2 space+1
       sta    r91                     ;3
       lda    #$EF                    ;2 AME
       sta    r90                     ;3
       lda    #$AD                    ;2 space+G
       sta    r8F                     ;3
       lda    rAB                     ;3
       and    #$03                    ;2
       sta    rAB                     ;3
       lda    #$C0                    ;2
       sta    rB0                     ;3
       jmp    LDFBE                   ;3

;       ORG  $3F00
;       RORG $DF00
;       .byte 0

       ORG  $3F66,0
       RORG $DF66,0

LD377: ;120
       .byte COLOR2+2 ; |  X   X | $D377
       .byte COLOR2+2 ; |  X   X | $D378
       .byte COLOR2+2 ; |  X   X | $D379
       .byte COLOR2+4 ; |  X  X  | $D37A
       .byte COLOR2+4 ; |  X  X  | $D37B
       .byte COLOR2+2 ; |  X   X | $D37C
       .byte COLOR2+2 ; |  X   X | $D37D
       .byte COLOR2+2 ; |  X   X | $D37E
       .byte COLOR2+2 ; |  X   X | $D37F
       .byte COLOR2+0 ; |  X     | $D380
       .byte COLOR2+0 ; |  X     | $D381
       .byte COLOR2+0 ; |  X     | $D382
       .byte COLOR2+0 ; |  X     | $D383
       .byte COLOR2+0 ; |  X     | $D384
       .byte COLOR2+0 ; |  X     | $D385
       .byte COLOR2+0 ; |  X     | $D386
       .byte COLOR2+2 ; |  X   X | $D387
       .byte COLOR2+0 ; |  X     | $D388
       .byte COLOR2+0 ; |  X     | $D389
       .byte COLOR2+0 ; |  X     | $D38A
       .byte COLOR2+0 ; |  X     | $D38B
       .byte COLOR2+2 ; |  X   X | $D38C
       .byte COLOR2+2 ; |  X   X | $D38D
LD38E:
       .byte COLOR2+0 ; |  X     | $D38E
LD38F:
       .byte COLOR1+8 ; |   XX   | $D38F
LD390:
       .byte COLOR1+8 ; |   XX   | $D390
       .byte COLOR1+8 ; |   XX   | $D391
       .byte COLOR1+8 ; |   XX   | $D392
       .byte COLOR1+14; |   XXXX | $D393
       .byte COLOR1+14; |   XXXX | $D394
       .byte COLOR1+14; |   XXXX | $D395
       .byte COLOR1+14; |   XXXX | $D396
       .byte COLOR1+14; |   XXXX | $D397
       .byte COLOR1+14; |   XXXX | $D398
       .byte COLOR1+8 ; |   XX   | $D399
       .byte COLOR1+8 ; |   XX   | $D39A
       .byte COLOR1+8 ; |   XX   | $D39B
       .byte COLOR1+8 ; |   XX   | $D39C
       .byte COLOR1+8 ; |   XX   | $D39D
       .byte COLOR1+8 ; |   XX   | $D39E
       .byte COLOR1+8 ; |   XX   | $D39F
       .byte COLOR1+14; |   XXXX | $D3A0
       .byte COLOR1+14; |   XXXX | $D3A1
       .byte COLOR1+14; |   XXXX | $D3A2
       .byte COLOR1+14; |   XXXX | $D3A3
       .byte COLOR1+8 ; |   XX   | $D3A4
       .byte COLOR1+8 ; |   XX   | $D3A5
       .byte COLOR1+14; |   XXXX | $D3A6
LD3A7:
       .byte COLOR1+8 ; |   XX   | $D3A7
       .byte COLOR1+8 ; |   XX   | $D3A8
       .byte COLOR1+8 ; |   XX   | $D3A9
       .byte COLOR1+14; |   XXXX | $D3AA
       .byte COLOR1+14; |   XXXX | $D3AB
       .byte COLOR1+8 ; |   XX   | $D3AC
       .byte COLOR1+8 ; |   XX   | $D3AD
       .byte COLOR1+8 ; |   XX   | $D3AE
       .byte COLOR1+8 ; |   XX   | $D3AF
       .byte COLOR1+14; |   XXXX | $D3B0
       .byte COLOR1+14; |   XXXX | $D3B1
       .byte COLOR1+14; |   XXXX | $D3B2
       .byte COLOR1+14; |   XXXX | $D3B3
       .byte COLOR1+14; |   XXXX | $D3B4
       .byte COLOR1+14; |   XXXX | $D3B5
       .byte COLOR1+14; |   XXXX | $D3B6
       .byte COLOR1+14; |   XXXX | $D3B7
       .byte COLOR1+8 ; |   XX   | $D3B8
LD3B9:
       .byte COLOR1+8 ; |   XX   | $D3B9
       .byte COLOR1+8 ; |   XX   | $D3BA
       .byte COLOR1+8 ; |   XX   | $D3BB
       .byte COLOR1+14; |   XXXX | $D3BC
       .byte COLOR1+14; |   XXXX | $D3BD
LD3BE:
       .byte COLOR1+8 ; |   XX   | $D3BE
LD3BF:
       .byte COLORC+2 ; |XX    X | $D3BF
LD3C0:
       .byte COLORC+2 ; |XX    X | $D3C0
       .byte COLORC+2 ; |XX    X | $D3C1
       .byte COLORC+2 ; |XX    X | $D3C2
       .byte COLORC+10; |XX  X X | $D3C3
       .byte COLORC+10; |XX  X X | $D3C4
       .byte COLORC+10; |XX  X X | $D3C5
       .byte COLORC+10; |XX  X X | $D3C6
       .byte COLORC+10; |XX  X X | $D3C7
       .byte COLORC+10; |XX  X X | $D3C8
       .byte COLORC+2 ; |XX    X | $D3C9
       .byte COLORC+2 ; |XX    X | $D3CA
       .byte COLORC+2 ; |XX    X | $D3CB
       .byte COLORC+2 ; |XX    X | $D3CC
       .byte COLORC+2 ; |XX    X | $D3CD
       .byte COLORC+2 ; |XX    X | $D3CE
       .byte COLORC+2 ; |XX    X | $D3CF
       .byte COLORC+10; |XX  X X | $D3D0
       .byte COLORC+10; |XX  X X | $D3D1
       .byte COLORC+10; |XX  X X | $D3D2
       .byte COLORC+10; |XX  X X | $D3D3
       .byte COLORC+2 ; |XX    X | $D3D4
       .byte COLORC+2 ; |XX    X | $D3D5
       .byte COLORC+10; |XX  X X | $D3D6
LD3D7:
       .byte COLORC+2 ; |XX    X | $D3D7
       .byte COLORC+2 ; |XX    X | $D3D8
       .byte COLORC+2 ; |XX    X | $D3D9
       .byte COLORC+10; |XX  X X | $D3DA
       .byte COLORC+10; |XX  X X | $D3DB
       .byte COLORC+2 ; |XX    X | $D3DC
       .byte COLORC+2 ; |XX    X | $D3DD
       .byte COLORC+2 ; |XX    X | $D3DE
       .byte COLORC+2 ; |XX    X | $D3DF
       .byte COLORC+10; |XX  X X | $D3E0
       .byte COLORC+10; |XX  X X | $D3E1
       .byte COLORC+10; |XX  X X | $D3E2
       .byte COLORC+10; |XX  X X | $D3E3
       .byte COLORC+2 ; |XX    X | $D3E4
       .byte COLORC+2 ; |XX    X | $D3E5
       .byte COLORC+2 ; |XX    X | $D3E6
       .byte COLORC+2 ; |XX    X | $D3E7
       .byte COLORC+10; |XX  X X | $D3E8
       .byte COLORC+10; |XX  X X | $D3E9
       .byte COLORC+10; |XX  X X | $D3EA
       .byte COLORC+10; |XX  X X | $D3EB
       .byte COLORC+2 ; |XX    X | $D3EC
       .byte COLORC+2 ; |XX    X | $D3ED
       .byte COLORC+10; |XX  X X | $D3EE

LD100:
       .byte $FD ; |XXXXXX X| $D100
       .byte $FD ; |XXXXXX X| $D101
       .byte $03 ; |      XX| $D102
       .byte $FB ; |XXXXX XX| $D103

LDFEE:
       bit    BANK1                   ;4 go to L93B9
       jmp    LD004                   ;3 from 2

LDFC4:
       bit    BANK2                   ;4 go to LBF53
       jmp    LDF60                   ;3 from 4

LDFBE:
       bit    BANK4                   ;4 go to LF06B
       jmp    LDAC4                   ;3 from 4

       ORG  $3FF4
       RORG $DFF4
LDFE8:
       jmp    L92D6                   ;3 from 3
       .word 0      ; $DFF7 - $DFF8
START3:
       jmp    START                   ;3 bankswitch to 4 and boot
       .word START3 ; $DFFC - $DFFD
       .word START3 ; $DFFE - $DFFF 






       ORG  $4000
       RORG $F000

START:
       cli                            ;2
       cld                            ;2
       ldx    #$FF                    ;2
       txs                            ;2
       inx                            ;2
       stx    rAF                     ;3
       lda    #$80                    ;2
       sta    rB0                     ;3
       lda    #$03                    ;2
       sta    gameVariation           ;3
LF013:
       lda    #$00                    ;2
LF015:
       sta    $00,x                   ;4
       inx                            ;2
       cpx    #$AF                    ;2
       bcc    LF015                   ;2
       ldx    #$02                    ;2
LF01E:
       lda    LFEEA,x                 ;4
       sta    ballSpritePtr,x         ;4
       dex                            ;2
       bpl    LF01E                   ;2
       jsr    LFCD1                   ;6
       jsr    LFA13                   ;6
       jsr    LFD06                   ;6
       ldx    #$5F                    ;2
       lda    gameVariation           ;3
       cmp    #$03                    ;2
       beq    LF03F                   ;2
       cmp    #$02                    ;2
       bne    LF03D                   ;2
       ldx    #$00                    ;2
LF03D:
       stx    rAA                     ;3
LF03F:
       lda    rAB                     ;3
       and    #$83                    ;2
       sta    rAB                     ;3
       lda    #$0C                    ;2
       and    r81                     ;3
       sta    r81                     ;3
       jmp    LF0AA                   ;3

LF04E:
       jsr    LFA13                   ;6 doesn't change X&Y
       sty    rE0                     ;3 y=0
       lda    SWCHB                   ;4
       lsr                            ;2
       bcc    LF087                   ;2
       lsr                            ;2
       bcc    LF060                   ;2
       bcs    LF09E                   ;2 always branch


LF060:
       lda    rB1                     ;3
       beq    LF068                   ;2
       dec    rB1                     ;5
       bpl    LF0AA                   ;2
LF068:
       jmp    LFFB8                   ;3

LF06B:
       bcs    LF07B                   ;2
       lda    #$AA                    ;2
       sta    r8C                     ;3
       sta    r8D                     ;3
       sta    r8E                     ;3
       jsr    LFD06                   ;6
       jsr    LFCE2                   ;6
LF07B:
       lda    #$40                    ;2
       bit    rAF                     ;3
       bvs    LF083                   ;2
       sta    rAF                     ;3
LF083:
       ldy    #$25                    ;2
       bne    LF09E                   ;2 always branch

LF087:
       bit    rAF                     ;3
       bmi    LF0AA                   ;2
       ldx    #$82                    ;2
       stx    rB0                     ;3
       lda    #$C0                    ;2
       sta    rAF                     ;3
       lda    r81                     ;3
       lsr                            ;2
       lsr                            ;2
       and    #$03                    ;2
       sta    gameVariation           ;3
       jmp    LF013                   ;3

LF09E:
       sty    rB1                     ;3
       bit    rAF                     ;3
       bpl    LF0AA                   ;2
       sty    rB0                     ;3
       lda    #$40                    ;2
       sta    rAF                     ;3
LF0AA:
       lda    #$00                    ;2
       sta    rC7                     ;3
       ldx    #$1E                    ;2
       stx    rF5                     ;3
       lda    frameCounter            ;3
       and    #$01                    ;2
       sta    rC3                     ;3
       ldx    rE8                     ;3
       ldy    rEA                     ;3
       lda    rA0,x                   ;4
       and.wy rA0,y                   ;4
       eor    #$02                    ;2
       and    #$02                    ;2
       sta    rCB                     ;3
       ldx    rE9                     ;3
       ldy    rEB                     ;3
       lda    rA0,x                   ;4
       and.wy rA0,y                   ;4
       eor    #$02                    ;2
       and    #$02                    ;2
       sta    rC9                     ;3
       ldx    rAC                     ;3
       stx    checkAC                 ;3
       cpx    #$12                    ;2
       bne    LF0EF                   ;2
       ldy    gameVariation           ;3
       cpy    #$02                    ;2
       beq    LF0EF                   ;2
       lda    rAB                     ;3
       asl                            ;2
       bpl    LF0EF                   ;2
       lda    #$03                    ;2
       sta    rF0                     ;3
       bne    LF0F7                   ;2 always branch

LF0EF:
       lda    LFF74,x                 ;4
       sta    rF0                     ;3
       lda    LFF97,x                 ;4
LF0F7:
       sta    rF0+1                   ;3
       lda    #$00                    ;2
       ldy    gameVariation           ;3
       ldx    LFF04,y                 ;4
       bne    LF108                   ;2
       lda    r92                     ;3
       rol                            ;2
       rol                            ;2
       and    #$01                    ;2
LF108:
       sta    rE7                     ;3
       lda    frameCounter            ;3
       and    #$03                    ;2
       bne    LF131                   ;2
       lda    rAB                     ;3
       and    #$30                    ;2
       beq    LF131                   ;2
       sec                            ;2
       sbc    #$10                    ;2
       sta    loopCount2              ;3
       lda    rAB                     ;3
       and    #$CF                    ;2
       ora    loopCount2              ;3
       sta    rAB                     ;3
       lda    loopCount2              ;3
       bne    LF131                   ;2
       lda    #$03                    ;2
       sta    gameVariation           ;3
       lda    #$80                    ;2
       ora    rAB                     ;3
       sta    rAB                     ;3
LF131:
       lda    gameVariation           ;3
       cmp    #$03                    ;2
       bne    LF15F                   ;2
       bit    rAB                     ;3
       bmi    LF168                   ;2
       lda    #$67                    ;2 TECHNOS JAPAN text
       ldx    #$89                    ;2
       ldy    #$AB                    ;2
       bit    frameCounter            ;3
       bmi    LF14B                   ;2
       lda    #$10                    ;2 (C) ACTIVISION text
       ldx    #$23                    ;2
       ldy    #$45                    ;2
LF14B:
       sta    r8F                     ;3
       stx    r90                     ;3
       sty    r91                     ;3
       lda    #$AB                    ;2 space + (C)
       sta    r8C                     ;3
       lda    #$19                    ;2 "19"
       sta    r8D                     ;3
       lda    #$89                    ;2 "89"
       sta    r8E                     ;3
       bne    LF168                   ;2 always branch

LF15F:
       lda    r91                     ;3
       and    #$0F                    ;2
       beq    LF168                   ;2
       jmp    LF217                   ;3

LF168:
       lda    rAB                     ;3
       and    #$0C                    ;2
       beq    LF179                   ;2
       cmp    #$04                    ;2
       beq    LF199                   ;2
       lda    #$37                    ;2
       sta    rAA                     ;3
       jmp    LF223                   ;3

LF179:
       lda    rAC                     ;3
       cmp    #$12                    ;2
       bne    LF18B                   ;2
       ldy    gameVariation           ;3
       cpy    #$02                    ;2
       beq    LF193                   ;2
       cpy    #$05                    ;2
       bne    LF1F2                   ;2
       lda    rC9                     ;3
LF18B:
       bne    LF1F2                   ;2
       lda    rCB                     ;3
       beq    LF1F2                   ;2
       bne    LF199                   ;2 always branch

LF193:
       lda    rCB                     ;3
       and    rC9                     ;3
       bne    LF1F2                   ;2
LF199:
       lda    #$01                    ;2
       sta    rE0                     ;3
       lda    rAB                     ;3
       ora    #$04                    ;2
       sta    rAB                     ;3
       lda    frameCounter            ;3
       and    #$03                    ;2
       bne    LF21D                   ;2
       jsr    LFCE2                   ;6
       ldx    #$01                    ;2
       lda    rA0                     ;3
       and    #$02                    ;2
       bne    LF1B5                   ;2
       dex                            ;2
LF1B5:
       bit    rAB                     ;3
       bmi    LF1D9                   ;2
       lda    #$80                    ;2
       cmp    rB2,x                   ;4
       bne    LF1DF                   ;2
       lda    #$0A                    ;2
       sta    rA0,x                   ;4
       ldy    rBD,x                   ;4
       txa                            ;2
       eor    #$01                    ;2
       tax                            ;2
       sty    rBD,x                   ;4
       lda    #$31                    ;2
       sta    rB2,x                   ;4
       lda    #$80                    ;2
       ora    rAB                     ;3
       sta    rAB                     ;3
       lda    #$00                    ;2
       sta    rA0,x                   ;4
LF1D9:
       lda    #$7E                    ;2
       cmp    rB2,x                   ;4
       beq    LF1E2                   ;2
LF1DF:
       jmp    LFCEB                   ;3

LF1E2:
       lda    frameCounter            ;3
       bne    LF21D                   ;2
       lda    #$03                    ;2
       sta    gameVariation           ;3
       lda    #$3C                    ;2
       ora    rAB                     ;3
       sta    rAB                     ;3
       bne    LF21D                   ;2 always branch

LF1F2:
       ldx    gameVariation           ;3
       cpx    #$03                    ;2
       beq    LF20E                   ;2
       lda    rCB                     ;3
       beq    LF204                   ;2
       cpx    #$02                    ;2
       bne    LF223                   ;2
       lda    rC9                     ;3
       bne    LF223                   ;2
LF204:
       lda    rAB                     ;3
       ora    #$38                    ;2
       sta    rAB                     ;3
       lda    #$37                    ;2
       sta    rAA                     ;3
LF20E:
       ldx    #$03                    ;2
       lda    #$02                    ;2
LF212:
       sta    rA0,x                   ;4
       dex                            ;2
       bpl    LF212                   ;2
LF217:
       jsr    LFD5D                   ;6
       jsr    LFD69                   ;6
LF21D:
       jsr    LFDC5                   ;6
       jmp    LF961                   ;3

LF223:
       ldx    #$00                    ;2
LF225:
       lda    r8F,x                   ;4
       and    #$F0                    ;2
       cmp    #$A0                    ;2
       bne    LF242                   ;2
       lda    r8F,x                   ;4
       and    #$0F                    ;2
       sta    r8F,x                   ;4
       cmp    #$0A                    ;2
       bne    LF242                   ;2
       cpx    #$02                    ;2
       beq    LF242                   ;2
       lda    #$00                    ;2
       sta    r8F,x                   ;4
       inx                            ;2
       bne    LF225                   ;2 always branch

LF242:
       lda    rC2                     ;3
       and    #$F0                    ;2
       cmp    #$A0                    ;2
       bne    LF250                   ;2
       lda    rC2                     ;3
       and    #$0F                    ;2
       sta    rC2                     ;3
LF250:
       ldy    rAA                     ;3
       beq    LF289                   ;2
       cpy    #$60                    ;2
       beq    LF268                   ;2
       cpy    #$BE                    ;2
       bne    LF26B                   ;2
       lda    frameCounter            ;3
       and    #$C0                    ;2
       sta    frameCounter            ;3
       and    #$01                    ;2
       sta    rC3                     ;3
       beq    LF26B                   ;2
LF268:
       jsr    LFA2B                   ;6
LF26B:
       lda    rAA                     ;3
       cmp    #$19                    ;2
       bcc    LF274                   ;2
       jmp    LF4D9                   ;3

LF274:
       ldx    #$FF                    ;2
       stx    temp                    ;3
       lda    frameCounter            ;3
       and    #$02                    ;2
       bne    LF29C                   ;2
       ldy    rE8                     ;3
       lda.wy rB2,y                   ;4
       cmp    #$60                    ;2
       bcc    LF29A                   ;2
       bcs    LF29C                   ;2 always branch

LF289:
       lda    rCB                     ;3
       beq    LF2A1                   ;2
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LF2A1                   ;2
       lda    rC9                     ;3
       bne    LF2A1                   ;2
       jsr    LFD69                   ;6
LF29A:
       ldx    #$77                    ;2
LF29C:
       stx    rF6                     ;3
       jmp    LF376                   ;3

LF2A1:
       lda    frameCounter            ;3
       bne    LF2F2                   ;2
       lda    rC2                     ;3
       beq    LF2F2                   ;2
       sed                            ;2
       sec                            ;2
       sbc    #$01                    ;2
       sta    rC2                     ;3
       cld                            ;2
       bne    LF2F2                   ;2
       ldx    #$03                    ;2
LF2B4:
       ora    rA0,x                   ;4
       dex                            ;2
       bpl    LF2B4                   ;2
       and    #$E0                    ;2
       beq    LF2C1                   ;2
       inc    rC2                     ;5
       bne    LF2F2                   ;2
LF2C1:
       ldx    gameVariation           ;3
       ldy    rE8                     ;3
       lda.wy rA0,y                   ;4
       ora    #$E0                    ;2
       sta.wy rA0,y                   ;5
       lda.wy r9C,y                   ;4
       and    #$F0                    ;2
       sta.wy r9C,y                   ;5
       ldy    rEA                     ;3
       cpx    #$02                    ;2
       bne    LF2DD                   ;2
       ldy    rE9                     ;3
LF2DD:
       lda.wy rA0,y                   ;4
       ora    #$E0                    ;2
       sta.wy rA0,y                   ;5
       lda.wy r9C,y                   ;4
       and    #$F0                    ;2
       sta.wy r9C,y                   ;5
       lda    #$02                    ;2
       jsr    LFEE0                   ;6
LF2F2:

  IF EVERYONE_WEAK
       lda    #$F0                    ;2
       and    r9D                     ;3
       sta    r9D                     ;3
       lda    #$F0                    ;2
       and    r9F                     ;3
       sta    r9F                     ;3
  ENDIF

  IF TWO_BUTTON
       lda    INPT4                   ;3
       and    INPT1                   ;3
  ELSE
       bit    INPT4                   ;3
  ENDIF

       bpl    LF2FA                   ;2
       asl    r81                     ;5
       lsr    r81                     ;5
LF2FA:
  IF TWO_BUTTON
       lda    INPT5                   ;3
       and    INPT3                   ;3
  ELSE
       bit    INPT5                   ;3
  ENDIF

       bpl    LF304                   ;2
       lda    #$BF                    ;2
       and    r81                     ;3
       sta    r81                     ;3
LF304:
       lda    INPT5                   ;3

  IF TWO_BUTTON
       and    INPT3                   ;3
  ENDIF

       sta    temp                    ;3
       lda    INPT4                   ;3

  IF TWO_BUTTON
       and    INPT1                   ;3
  ENDIF

       asl                            ;2
       ror    temp                    ;5
       ldx    rC3                     ;3
       lda    rE7                     ;3
       beq    LF318                   ;2
       dex                            ;2
       beq    LF318                   ;2
       inx                            ;2
       inx                            ;2
LF318:
       lda    temp                    ;3
       ora    LFF61,x                 ;4
       sta    rE4+1                   ;3
       lda    r81                     ;3
       ora    LFF61,x                 ;4
       ora    temp                    ;3
       sta    temp                    ;3
       lda    rE4+1                   ;3
       eor    #$C0                    ;2
       and    #$C0                    ;2
       ora    r81                     ;3
       sta    r81                     ;3
       lda    SWCHA                   ;4

  IF TWO_BUTTON
       bit    INPT1                   ;3
       bmi    NoJump1                 ;2
       bit    temp                    ;3
       bmi    NoJump1                 ;2
       and    #$0F                    ;2
       ora    #$E0                    ;2
NoJump1:
       bit    INPT3                   ;3
       bmi    NoJump2                 ;2
       bit    temp                    ;3
       bvs    NoJump2                 ;2
       and    #$F0                    ;2
       ora    #$0E                    ;2
NoJump2:
  ENDIF

       sta    rF6                     ;3
       ldy    gameVariation           ;3
       lda    LFCCB,y                 ;4
       sta    rEE                     ;3
       lda    rC3                     ;3
       bne    LF34F                   ;2
       ldx    LFF07,y                 ;4
       lda    rE8,x                   ;4
       sta    rCD                     ;3
       lda    rE7                     ;3
       bne    LF369                   ;2
       beq    LF387                   ;2 always branch

LF34F:
       ldx    LFF4B,y                 ;4
       cpx    #$70                    ;2
       beq    LF366                   ;2
       lda    rE8,x                   ;4
       sta    rCD                     ;3
       cpy    #$01                    ;2
       beq    LF369                   ;2
       cpy    #$02                    ;2
       bne    LF387                   ;2
       inc    rC7                     ;5
       bne    LF369                   ;2
LF366:
       jmp    LF4CC                   ;3

LF369:
       asl    temp                    ;5
       asl    rF6                     ;5
       asl    rF6                     ;5
       asl    rF6                     ;5
       asl    rF6                     ;5
       jmp    LF387                   ;3

LF376:
       lda    rC3                     ;3
       bne    LF381                   ;2
       ldy    rC7                     ;3
       ldx    rE8,y                   ;4
LF37E:
       jmp    LF385                   ;3

LF381:
       ldy    rC7                     ;3
       ldx    rEA,y                   ;4
LF385:
       stx    rCD                     ;3
LF387:
       ldx    rCD                     ;3
       lda    rA0,x                   ;4
       and    #$E2                    ;2
       beq    LF392                   ;2
LF38F:
       jmp    LF4CC                   ;3

LF392:
       lda    r94,x                   ;4
       cmp    #$05                    ;2
       bcs    LF38F                   ;2
       bit    temp                    ;3
       bmi    LF3F5                   ;2 branch if action OK now?
       lda    r98,x                   ;4
       cmp    #$06                    ;2
       bcs    LF38F                   ;2
       lda    rF6                     ;3
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       and    #$03                    ;2
       sta    rE0+1                   ;3
       ldy    gameVariation           ;3
       cpy    #$02                    ;2
       beq    LF3B6                   ;2
       ldy    rC7                     ;3
       bne    LF3BA                   ;2
LF3B6:
       cmp    #$01                    ;2
       beq    LF3E6                   ;2
LF3BA:
       jsr    LF9A6                   ;6
       bcs    LF3E6                   ;2
       lda    rF0                     ;3
       cmp    #$03                    ;2
       beq    LF3E6                   ;2
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LF3D7                   ;2
       lda    r81                     ;3
       and    #$10                    ;2
       ora    rC3                     ;3
       beq    LF3D7                   ;2
       cmp    #$11                    ;2
       bne    LF3E6                   ;2
LF3D7:
       ldy    #$01                    ;2
       cpy    rA9                     ;3
       bne    LF3E6                   ;2
       inc    rA9                     ;5
       ldy    rA8                     ;3
       lda    LFEF8,y                 ;4
       sta    rE0+1                   ;3
LF3E6:
       lda    #$0F                    ;2
       sta    r98,x                   ;4
       lda    rF6                     ;3
       cmp    #$F0                    ;2
       bcc    LF3F5                   ;2 branch if joystick moved?
       asl    rF6                     ;5
       jmp    LF403                   ;3

LF3F5:
       asl    rF6                     ;5
       bcs    LF43F                   ;2 branch if not right?
       lda    #$F7                    ;2
       and    rA0,x                   ;4
       sta    rA0,x                   ;4
       bit    temp                    ;3
       bmi    LF40C                   ;2
LF403:
       ldy    rE0+1                   ;3
       lda    LFEF2,y                 ;4
       sta    r94,x                   ;4
       bne    LF43F                   ;2 always branch

LF40C:
       inc    rB2,x                   ;6
       lda    rB2,x                   ;4
       cmp    #$C5                    ;2
       bcc    LF43C                   ;2
       dec    rB2,x                   ;6
       lda    rC9                     ;3
       bne    LF43F                   ;2
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LF43F                   ;2
       ldy    rAC                     ;3
       cpy    #$12                    ;2
       beq    LF43F                   ;2
       inc    rAC                     ;5
       lda    LFF86,y                 ;4
       sta    rAA                     ;3
       lda    #$40                    ;2
       ldx    rEA                     ;3
       sta    rB2,x                   ;4
       ldx    rE8                     ;3
       sta    rB2,x                   ;4
       jsr    LFD69                   ;6
       ldx    rCD                     ;3
LF43C:
       jsr    LFA00                   ;6
LF43F:
       asl    rF6                     ;5
       bcs    LF465                   ;2 branch if not left
       lda    #$08                    ;2
       ora    rA0,x                   ;4
       sta    rA0,x                   ;4
       bit    temp                    ;3
       bmi    LF456                   ;2
       ldy    rE0+1                   ;3
       lda    LFEF2,y                 ;4
       sta    r94,x                   ;4
       bne    LF465                   ;2 always branch

LF456:
       dec    rB2,x                   ;6
       lda    rB2,x                   ;4
       cmp    #$3F                    ;2
       bcs    LF462                   ;2
       inc    rB2,x                   ;6
       bne    LF465                   ;2
LF462:
       jsr    LFA00                   ;6
LF465:
       asl    rF6                     ;5
       bcs    LF47E                   ;2 branch if not down
       bit    temp                    ;3
       bmi    LF473                   ;2 branch if no button
       lda    #$09                    ;2
       sta    r94,x                   ;4
       bne    LF47E                   ;2 always branch

LF473:
       lda    rBD,x                   ;4
       cmp    rEE                     ;3
       bcs    LF47E                   ;2
       inc    rBD,x                   ;6
       jsr    LFA00                   ;6
LF47E:
       asl    rF6                     ;5
       bcs    LF4CC                   ;2 branch if not up
       bit    temp                    ;3
       bmi    LF4B6                   ;2 branch if no button
       lda    r94,x                   ;4
       cmp    #$0B                    ;2
       beq    LF4CC                   ;2
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LF49E                   ;2
       lda    r81                     ;3
       and    #$10                    ;2
       ora    rC3                     ;3
       beq    LF49E                   ;2
       cmp    #$11                    ;2
       bne    LF4AC                   ;2
LF49E:
       jsr    LF9A6                   ;6
       bcs    LF4AC                   ;2
       ldy    rE0+1                   ;3
       lda    LFEF2,y                 ;4
       sta    r94,x                   ;4
       bne    LF4CC                   ;2 always branch

LF4AC:
       lda    #$0A                    ;2 jumpkick sprite pointer
       sta    r94,x                   ;4
       lda    #$15                    ;2
       sta    r98,x                   ;4
       bne    LF4CC                   ;2 always branch

LF4B6:
       jsr    LF9A6                   ;6
       lda    rBD,x                   ;4
       bcs    LF4C3                   ;2
       cmp    #$21                    ;2
       bcc    LF4CC                   ;2
       bcs    LF4C7                   ;2 always branch

LF4C3:
       cmp    rF5                     ;3
       bcc    LF4CC                   ;2
LF4C7:
       dec    rBD,x                   ;6
       jsr    LFA00                   ;6
LF4CC:
       lda    rC7                     ;3
       bne    LF4D9                   ;2
       ldy    gameVariation           ;3
       cpy    #$02                    ;2
       beq    LF4D9                   ;2
       jmp    LFA86                   ;3

LF4D9:
       ldx    rAA                     ;3
       beq    LF508                   ;2
       cpx    #$60                    ;2
       bne    LF4E5                   ;2
       inc    rAC                     ;5
       bne    LF4F3                   ;2
LF4E5:
       cpx    #$BF                    ;2
       beq    LF4F1                   ;2
       lda    frameCounter            ;3
       and    #$03                    ;2
       bne    LF508                   ;2
       beq    LF4F3                   ;2 always branch

LF4F1:
       dec    rAC                     ;5
LF4F3:
       dec    rAA                     ;5
       lda    rAC                     ;3
LF4F7:
       cmp    #$0A                    ;2
       bne    LF508                   ;2
       cpx    #$91                    ;2
       bne    LF508                   ;2
       ldx    #$19                    ;2
       stx    rAA                     ;3
       inc    rAC                     ;5
       jsr    LFA2B                   ;6
LF508:
       ldy    gameVariation           ;3
       bne    LF521                   ;2
       ldx    rE8                     ;3
       lda    rBD,x                   ;4
       cmp    #$45                    ;2
       bne    LF55C                   ;2
       ldy    rEA                     ;3
       lda    #$1D                    ;2
       jsr    LF9DA                   ;6
       ldy    #$04                    ;2
       sty    gameVariation           ;3
       bne    LF55C                   ;2 always branch

LF521:
       cpy    #$04                    ;2
       bne    LF55C                   ;2
       ldx    rEA                     ;3
       lda    r94,x                   ;4
       cmp    #$0A                    ;2
       bne    LF535                   ;2
       lda    r98,x                   ;4
       cmp    #$0B                    ;2
       bcc    LF55C                   ;2
       bcs    LF545                   ;2 always branch

LF535:
       lda    SWCHA                   ;4
       ldx    rE7                     ;3
       bne    LF542                   ;2 branch if checking player 2
       and    #$10                    ;2 P1 joysick up?
       bne    LF55C                   ;2 branch if not
       beq    LF545                   ;2 always branch

LF542:
       lsr                            ;2 P2 joystick up?
       bcs    LF55C                   ;2 branch if not
LF545:
       ldx    rEA                     ;3
       lda    rBD,x                   ;4
       cmp    #$1D                    ;2
       bne    LF55C                   ;2
       ldy    rE8                     ;3
       lda    #$44                    ;2
       jsr    LF9DA                   ;6
       lda    #$99                    ;2
       sta    rBD,x                   ;4
       ldy    #$00                    ;2
       sty    gameVariation           ;3
LF55C:
       ldx    rAC                     ;3
       cpx    checkAC                 ;3
       beq    LF5BB                   ;2
       cpy    #$05                    ;2
       bne    LF588                   ;2
       ldx    rE8                     ;3
       ldy    rEA                     ;3
       lda    rBD,x                   ;4
       cmp    #$44                    ;2
       bcc    LF57F                   ;2
       sbc    #$2C                    ;2
       cmp    #$1D                    ;2
       bcs    LF578                   ;2
       lda    #$1D                    ;2
LF578:
       jsr    LF9DA                   ;6
       lda    #$04                    ;2
       bne    LF586                   ;2 always branch

LF57F:
       lda    #$45                    ;2
       sta.wy rBD,y                   ;5
       lda    #$00                    ;2
LF586:
       sta    gameVariation           ;3
LF588:
       ldx    rAC                     ;3
       lda    LFF38,x                 ;4
       ldx    rE9                     ;3
       ldy    rEB                     ;3
       sta    r9C,x                   ;4
       sta.wy r9C,y                   ;5
       ldx    rF0                     ;3
       lda    LFF6A,x                 ;4
       ldx    rE9                     ;3
       sta    rA4,x                   ;4
       sta.wy rA4,y                   ;5
       lda    #$08                    ;2
       sta    rA0,x                   ;4
       sta.wy rA0,y                   ;5
       inc    rC9                     ;5
       lda    r81                     ;3
       and    #$EF                    ;2
       sta    r81                     ;3
       lda    #$04                    ;2
       sta    rA8                     ;3
       jsr    LFCE2                   ;6
       jsr    LFCD1                   ;6
LF5BB:
       ldy    rC3                     ;3
       ldx    LFF05,y                 ;4
LF5C0:
       lda    rA0,x                   ;4
       and    #$E0                    ;2
       beq    LF5CA                   ;2
       lda    r98,x                   ;4 check energy level
       beq    LF5CD                   ;2 branch if none (dead)
LF5CA:
       jmp    LF71D                   ;3

LF5CD: ;character dead...
       lda    frameCounter            ;3 check framecounter for flash
       and    #$10                    ;2
       beq    LF5D9                   ;2
       lda    #$07                    ;2 flash off dead character
       sta    r94,x                   ;4
       bne    LF5CA                   ;2 always branch

LF5D9:
       lda    #$06                    ;2 flash on dead character
       sta    r94,x                   ;4
       lda    frameCounter            ;3
       and    #$0E                    ;2
       bne    LF5CA                   ;2
       lda    rA0,x                   ;4
       and    #$E0                    ;2
       sec                            ;2
       sbc    #$20                    ;2
       sta    rE4                     ;3
       lda    rA0,x                   ;4
       and    #$1F                    ;2
       ora    rE4                     ;3
       sta    rA0,x                   ;4
       lda    rE4                     ;3
       bne    LF5CA                   ;2
       lda    rE8,x                   ;4
       and    #$01                    ;2
       sta    rC7                     ;3
       lda    rA8                     ;3
       cmp    #$04                    ;2
       bcc    LF609                   ;2
       jsr    LFCD1                   ;6
       bcs    LF661                   ;2
LF609:
       lda    rC7                     ;3
       beq    LF661                   ;2
       lda    rB8                     ;3
       cmp    #$32                    ;2
       bne    LF661                   ;2
       lda    gameVariation           ;3
       beq    LF63C                   ;2
       cmp    #$04                    ;2
       beq    LF63C                   ;2
       cmp    #$05                    ;2
       beq    LF631                   ;2
       cmp    #$01                    ;2
       bne    LF661                   ;2
       lda    r81                     ;3
       cpx    #$02                    ;2
       bcc    LF62D                   ;2
       ora    #$10                    ;2
       bne    LF62F                   ;2 always branch

LF62D:
       and    #$EF                    ;2
LF62F:
       sta    r81                     ;3
LF631:
       lda    r9C,x                   ;4
       and    #$F0                    ;2
       beq    LF661                   ;2
       jsr    LF9CD                   ;6
       bne    LF661                   ;2 always branch

LF63C:
       ldy    rE9                     ;3
       cpx    #$02                    ;2
       bcs    LF644                   ;2
       ldy    rEB                     ;3
LF644:
       lda    r9C,x                   ;4
       and    #$F0                    ;2
       sta    rE4                     ;3
       lda.wy r9C,y                   ;4
       and    #$F0                    ;2
       clc                            ;2
       adc    rE4                     ;3
       sta    rE4                     ;3
       lda.wy r9C,y                   ;4
       and    #$0F                    ;2
       ora    rE4                     ;3
       sta.wy r9C,y                   ;5
       jmp    LF6BD                   ;3

LF661:
       lda    r9C,x                   ;4
       and    #$F0                    ;2
       bne    LF6C5                   ;2
       lda    rAC                     ;3
       cmp    #$12                    ;2
       bne    LF6BD                   ;2
       lda    rAB                     ;3
       asl                            ;2
       bmi    LF6BD                   ;2
       lda    rC7                     ;3
       beq    LF6BD                   ;2
       lda    gameVariation           ;3
       cmp    #$05                    ;2
       beq    LF6A9                   ;2
       cmp    #$01                    ;2
       bne    LF6BD                   ;2
       lda    r81                     ;3
       ldy    rEB                     ;3
       cpx    #$02                    ;2
       bcc    LF68E                   ;2
       ldy    rE9                     ;3
       ora    #$10                    ;2
       bne    LF690                   ;2 always branch

LF68E:
       and    #$EF                    ;2
LF690:
       sta    r81                     ;3
       lda.wy rA0,y                   ;4
       and    #$02                    ;2
       beq    LF6BD                   ;2
       lda.wy rA0,y                   ;4
       and    #$0D                    ;2
       sta.wy rA0,y                   ;5
       lda    #$0F                    ;2
       sta.wy r9C,y                   ;5
       sta.wy rA4,y                   ;5
LF6A9:
       lda    rAB                     ;3
       ora    #$40                    ;2
       sta    rAB                     ;3
       lda    #$03                    ;2
       jsr    LFCDA                   ;6
       jsr    LF9CD                   ;6
       lda    #$10                    ;2
       sta    r9C,x                   ;4
       bne    LF6C5                   ;2 always branch

LF6BD:
       lda    #$02                    ;2
       ora    rA0,x                   ;4
       sta    rA0,x                   ;4
       bne    LF719                   ;2 always branch

LF6C5:
       sec                            ;2
       sbc    #$10                    ;2
       sta    r9C,x                   ;4
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LF6DB                   ;2
       lda    rC7                     ;3
       beq    LF6DB                   ;2
       ldy    rF0                     ;3
       lda    LFF6A,y                 ;4
       bne    LF6DD                   ;2 always branch

LF6DB:
       lda    #$03                    ;2
LF6DD:
       sta    rA4,x                   ;4
       ldy    rAC                     ;3
       lda    rC7                     ;3
       beq    LF6EC                   ;2
       lda    LFF38,y                 ;4
       and    #$0F                    ;2
       bne    LF6F7                   ;2 always branch

LF6EC:
       lda    rC2                     ;3
       bne    LF6F5                   ;2
       lda    LFF4E,y                 ;4
       sta    rC2                     ;3
LF6F5:
       lda    #$05                    ;2
LF6F7:
       sta    rF6                     ;3
       lda    r9C,x                   ;4
       and    #$F0                    ;2
       ora    rF6                     ;3
       sta    r9C,x                   ;4
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LF70B                   ;2
       lda    rC7                     ;3
       bne    LF70F                   ;2
LF70B:
       lda    #$81                    ;2
       bne    LF71B                   ;2 always branch

LF70F:
       lda    #$24                    ;2
       sta    rBD,x                   ;4
       lda    #$D1                    ;2
       bit    frameCounter            ;3
       bpl    LF71B                   ;2
LF719:
       lda    #$31                    ;2
LF71B:
       sta    rB2,x                   ;4
LF71D:
       lda    LFF75,x                 ;4
       beq    LF726                   ;2
       dex                            ;2
       jmp    LF5C0                   ;3

LF726:
       lda    gameVariation           ;3
       cmp    #$01                    ;2
       bne    LF767                   ;2
       ldx    rE8                     ;3
       lda    rA0,x                   ;4
       and    #$02                    ;2
       bne    LF740                   ;2
       ldx    rEA                     ;3
       lda    rA0,x                   ;4
       and    #$02                    ;2
       beq    LF7A1                   ;2
       ldy    #$00                    ;2
       beq    LF746                   ;2 always branch

LF740:
       lda    #$01                    ;2
       sta    rE7                     ;3
       ldy    #$04                    ;2
LF746:
       lda    rF0                     ;3
       cmp    #$03                    ;2
       beq    LF752                   ;2
       lda    rB8                     ;3
       cmp    #$32                    ;2
       beq    LF7B3                   ;2
LF752:
       lda    LFF1A,x                 ;4
       tax                            ;2
       lda    rB2,x                   ;4
       cmp    #$D1                    ;2
       beq    LF769                   ;2
       lda    rA0,x                   ;4
       and    #$F7                    ;2
       sta    rA0,x                   ;4
       jsr    LFA00                   ;6
       inc    rB2,x                   ;6
LF767:
       bne    LF7C0                   ;2
LF769:
       lda    rA9                     ;3
       cmp    #$02                    ;2
       bcs    LF7C0                   ;2
       sty    gameVariation           ;3
       lda    #$02                    ;2
       sta    rA0,x                   ;4
       lda    r9C,x                   ;4
       and    #$F0                    ;2
       sta    rF6                     ;3
       cpy    #$04                    ;2
       bne    LF783                   ;2
       ldy    rEB                     ;3
       bne    LF785                   ;2
LF783:
       ldy    rE9                     ;3
LF785:
       lda.wy r9C,y                   ;4
       clc                            ;2
       adc    rF6                     ;3
       sta.wy r9C,y                   ;5
       lda    LFF1A,x                 ;4
       tax                            ;2
       lda    r81                     ;3
       and    #$10                    ;2
       bne    LF7B8                   ;2
       lda    ballSpritePtr           ;3
       sbc    #$28                    ;2
       sta    ballSpritePtr           ;3
       jmp    LF7B8                   ;3

LF7A1:
       lda    rC9                     ;3
       bne    LF7B0                   ;2
       ldx    rAC                     ;3
       cpx    #$12                    ;2
       bne    LF7B0                   ;2
       inc    gameVariation           ;5
       jsr    LFD80                   ;6
LF7B0:
       jmp    LF7FE                   ;3

LF7B3:
       sty    gameVariation           ;3
       jsr    LFCD1                   ;6
LF7B8:
       lda    #$99                    ;2
       sta    rBD,x                   ;4
       lda    #$02                    ;2
       sta    rA0,x                   ;4
LF7C0:
       ldy    gameVariation           ;3
       bne    LF7DB                   ;2
       ldy    rE9                     ;3
       lda.wy rA0,y                   ;4
       and    #$02                    ;2
       bne    LF7D6                   ;2
       ldy    rEB                     ;3
       lda.wy rA0,y                   ;4
       and    #$02                    ;2
       beq    LF7DB                   ;2
LF7D6:
       ldx    rEB                     ;3
       jsr    LF9B4                   ;6
LF7DB:
       ldy    gameVariation           ;3
       cpy    #$04                    ;2
       bne    LF7FE                   ;2
       ldx    rEB                     ;3
       lda    rA0,x                   ;4
       and    #$02                    ;2
       bne    LF7F7                   ;2
       ldy    rE9                     ;3
       lda.wy rA0,y                   ;4
       and    #$02                    ;2
       beq    LF7FE                   ;2
       ldx    rEB                     ;3
       jsr    LF9D5                   ;6
LF7F7:
       ldy    rE8                     ;3
       ldx    rEA                     ;3
       jsr    LF9B4                   ;6
LF7FE:
       lda    r81                     ;3
       and    #$03                    ;2
       beq    LF86A                   ;2
       tax                            ;2
       lda    #$10                    ;2
       bit    r81                     ;3
       beq    LF80D                   ;2
       inx                            ;2
       inx                            ;2
LF80D:
       dex                            ;2
       lda    rE8,x                   ;4
       tax                            ;2
       stx    rC5                     ;3
       ldy    rA8                     ;3
       lda    LFEED,y                 ;4
       sta    rCD                     ;3
       lda    rE8,x                   ;4
       and    #$01                    ;2
       beq    LF84A                   ;2
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LF84A                   ;2
       ldy    rA8                     ;3
       beq    LF84A                   ;2
       lda    #$01                    ;2
       sta    rA4,x                   ;4
       cpy    #$04                    ;2
       bne    LF838                   ;2
       lda    #$00                    ;2
       sta    rE4                     ;3
       beq    LF842                   ;2 always branch

LF838:
       lda    r9C,x                   ;4
       and    #$0F                    ;2
       sta    rE4                     ;3
       beq    LF84A                   ;2
       dec    rE4                     ;5
LF842:
       lda    r9C,x                   ;4
       and    #$F0                    ;2
       ora    rE4                     ;3
       sta    r9C,x                   ;4
LF84A:
       ldy    LFF1A,x                 ;4
       jsr    LFDE4                   ;6
       lda    r81                     ;3
       ldx    gameVariation           ;3
       cpx    #$01                    ;2
       bne    LF866                   ;2
       ldx    rA8                     ;3
       cpx    #$03                    ;2
       bne    LF866                   ;2
       ldx    rA9                     ;3
       cpx    #$01                    ;2
       bne    LF866                   ;2
       eor    #$10                    ;2
LF866:
       and    #$FC                    ;2
       sta    r81                     ;3
LF86A:
       lda    gameVariation           ;3
       beq    LF871                   ;2
LF86E:
       jmp    LF8C0                   ;3

LF871:
       lda    rC3                     ;3
       bne    LF87F                   ;2
       sta    rC5                     ;3
       ldx    rE8                     ;3
       bne    LF86E                   ;2
       ldy    rEB                     ;3
       bne    LF889                   ;2
LF87F:
       lda    #$03                    ;2
       sta    rC5                     ;3
       ldx    rEB                     ;3
       ldy    rE8                     ;3
       bne    LF86E                   ;2
LF889:
       lda.wy r94,y                   ;4
       sta    rCD                     ;3
       cmp    #$08                    ;2
       bcc    LF8C0                   ;2
       lda    r94,x                   ;4
       cmp    #$05                    ;2
       bcc    LF89C                   ;2
       cmp    #$08                    ;2
       bcc    LF8C0                   ;2
LF89C:
       clc                            ;2
       lda    rC5                     ;3
       beq    LF8AD                   ;2
       lda    rBD,x                   ;4
       adc    #$2D                    ;2
       sbc.wy rBD,y                   ;4
       cmp    #$0F                    ;2
       jmp    LF8B6                   ;3

LF8AD:
       lda.wy rBD,y                   ;4
       adc    #$2D                    ;2
       sbc    rBD,x                   ;4
       cmp    #$16                    ;2
LF8B6:
       bcs    LF8C0                   ;2
       jsr    LF964                   ;6
       bcs    LF8C0                   ;2
       jmp    LF21D                   ;3

LF8C0:
       jsr    LFDC5                   ;6
       lda    rC3                     ;3
       bne    LF8CB                   ;2
       lda    #$01                    ;2
       bne    LF8CD                   ;2 always branch

LF8CB:
       lda    #$03                    ;2
LF8CD:
       sta    rC5                     ;3
       lda    #$01                    ;2
       sta    rD1+1                   ;3
LF8D3:
       lda    rC5                     ;3
       tax                            ;2
       eor    #$01                    ;2
       tay                            ;2
       lda.wy r94,y                   ;4
       sta    rCD                     ;3
       cmp    #$08                    ;2
       bcc    LF8EC                   ;2
       lda    r94,x                   ;4
       cmp    #$05                    ;2
       bcc    LF8EF                   ;2
       cmp    #$08                    ;2
       bcs    LF8EF                   ;2
LF8EC:
       jmp    LF958                   ;3

LF8EF:
       lda    rBD,x                   ;4
       cmp.wy rBD,y                   ;4
       bcc    LF8FC                   ;2
       sbc.wy rBD,y                   ;4
       jmp    LF902                   ;3

LF8FC:
       lda.wy rBD,y                   ;4
       sec                            ;2
       sbc    rBD,x                   ;4
LF902:
       cmp    #$12                    ;2
       bcs    LF8EC                   ;2
       jsr    LF964                   ;6
       bcs    LF958                   ;2
       lda    r81                     ;3
       and    #$10                    ;2
       ora    rC5                     ;3
       and    #$12                    ;2
       beq    LF919                   ;2
       cmp    #$12                    ;2
       bne    LF961                   ;2
LF919:
       jsr    LF9A6                   ;6
       bcs    LF961                   ;2
       ldy    #$03                    ;2
       cpy    rA8                     ;3
       beq    LF961                   ;2
       cpy    rA9                     ;3
       beq    LF961                   ;2
       lda    #$0B                    ;2
       sta    rAD                     ;3
       lda    rA8                     ;3
       cmp    #$02                    ;2
       bcs    LF953                   ;2
       ldx    #$00                    ;2
       bit    rAE                     ;3
       bpl    LF939                   ;2
       inx                            ;2
LF939:
       lda    #$10                    ;2
       bit    r81                     ;3
       beq    LF941                   ;2
       inx                            ;2
       inx                            ;2
LF941:
       lda    rE8,x                   ;4
       tax                            ;2
       lda    rBD,x                   ;4
       sbc    #$17                    ;2
       clc                            ;2
       adc    #$F5                    ;2
       clc                            ;2
       ldx    gameVariation           ;3
       adc    LFF6E,x                 ;4
       sta    ballSpritePtr           ;3
LF953:
       sty    rA9                     ;3
       jmp    LF961                   ;3

LF958:
       dec    rC5                     ;5
       dec    rD1+1                   ;5
       bmi    LF961                   ;2
       jmp    LF8D3                   ;3

LF961:
       jmp    LFFCA                   ;3

LF964:
       lda.wy rB2,y                   ;4
       cmp    rB2,x                   ;4
       bcs    LF989                   ;2
       adc    #$08                    ;2
       cmp    rB2,x                   ;4
       bcc    LF9A0                   ;2
       lda    rCD                     ;3
       cmp    #$0B                    ;2
       bne    LF97F                   ;2
LF977:
       lda.wy rA0,y                   ;4
       eor    #$08                    ;2
       jmp    LF982                   ;3

LF97F:
       lda.wy rA0,y                   ;4
LF982:
       and    #$08                    ;2
       bne    LF9A0                   ;2
       jmp    LFDE4                   ;3

LF989:
       sbc    #$08                    ;2
       cmp    rB2,x                   ;4
       bcs    LF9A0                   ;2
       lda    rCD                     ;3
       cmp    #$0B                    ;2
       beq    LF97F                   ;2
       bne    LF977                   ;2 always branch

LF997:
       lda    rC7                     ;3
       lsr                            ;2
       bit    rAE                     ;3
       bpl    LF9A2                   ;2
       bcs    LF9A4                   ;2
LF9A0:
       sec                            ;2
       rts                            ;6

LF9A2:
       bcs    LF9A0                   ;2
LF9A4:
       clc                            ;2
       rts                            ;6

LF9A6:
       ldy    rA9                     ;3
       beq    LF9A0                   ;2
       cpy    #$02                    ;2
       bcc    LF997                   ;2
       ldy    rA8                     ;3
       bne    LF9A0                   ;2
       beq    LF997                   ;2 always branch

LF9B4:
       lda    #$05                    ;2
       sta    gameVariation           ;3
       jsr    LF9D5                   ;6
       sta    rA2                     ;3
       sta    rA3                     ;3
       lda    r81                     ;3
       and    #$EF                    ;2
       sta    r81                     ;3
       lda    #$03                    ;2
       cmp    rF0                     ;3
       bne    LF9D4                   ;2
       sta    rA8                     ;3
LF9CD:
       sec                            ;2
       ror    rAE                     ;5
       lda    #$01                    ;2
       sta    rA9                     ;3
LF9D4:
       rts                            ;6

LF9D5:
       lda    rBD,x                   ;4
       clc                            ;2
       adc    #$29                    ;2
LF9DA:
       sta.wy rBD,y                   ;5
       lda    rB2,x                   ;4
       sta.wy rB2,y                   ;5
       lda    r94,x                   ;4
       sta.wy r94,y                   ;5
       lda    r98,x                   ;4
       sta.wy r98,y                   ;5
       lda    rA0,x                   ;4
       sta.wy rA0,y                   ;5
       lda    r9C,x                   ;4
       sta.wy r9C,y                   ;5
       lda    rA4,x                   ;4
       sta.wy rA4,y                   ;5
       lda    #$02                    ;2
       sta    rA0,x                   ;4
       rts                            ;6

LFA00: ;walk animation...
       lda    r98,x                   ;4
       bne    LFA12                   ;2
       lda    #$06                    ;2 6 frames per sprite
       sta    r98,x                   ;4
       dec    r94,x                   ;6 get next animation frame
       bmi    LFA0E                   ;2 NOTE: could just BPL LFA12!
       bne    LFA12                   ;2
LFA0E:
       lda    #$04                    ;2
       sta    r94,x                   ;4
LFA12:
       rts                            ;6

LFA13:
       lda    rAB                     ;3
       and    #$01                    ;2
       sta    rE8                     ;3
       eor    #$01                    ;2
       sta    rE9                     ;3
       lda    rAB                     ;3
       lsr                            ;2
       and    #$01                    ;2
       ora    #$02                    ;2
       sta    rEA                     ;3
       eor    #$01                    ;2
       sta    rEB                     ;3
       rts                            ;6

LFA2B:
       jsr    LFD5D                   ;6
       jsr    LFD69                   ;6
       lda    #$08                    ;2
       sta    rA0,x                   ;4
       sta.wy rA0,y                   ;5
       ldx    rAC                     ;3
       lda    LFF4E,x                 ;4
       sta    rC2                     ;3
       sed                            ;2
       ldy    #$02                    ;2
LFA42:
       ldx    rE8,y                   ;4
       lda    rA0,x                   ;4
       and    #$02                    ;2
       bne    LFA80                   ;2
       lda    r9C,x                   ;4
       and    #$F0                    ;2
       ora    #$05                    ;2
       sta    r9C,x                   ;4
       ldx    rAC                     ;3
       lda    LFFA8,x                 ;4
       ldx    rE7                     ;3
       bne    LFA71                   ;2
       ldx    rE8,y                   ;4
       cpy    #$00                    ;2
       bne    LFA71                   ;2
       clc                            ;2
       adc    r8D                     ;3
       sta    r8D                     ;3
       bcc    LFA80                   ;2
       lda    r8C                     ;3
       adc    #$00                    ;2
       sta    r8C                     ;3
       jmp    LFA80                   ;3

LFA71:
       ldx    rE8,y                   ;4
       clc                            ;2
       adc    r90                     ;3
       sta    r90                     ;3
       bcc    LFA80                   ;2
       lda    r8F                     ;3
       adc    #$00                    ;2
       sta    r8F                     ;3
LFA80:
       dey                            ;2
       dey                            ;2
       beq    LFA42                   ;2
       cld                            ;2
       rts                            ;6

LFA86:
       lda    #$FF                    ;2
       sta    rF6                     ;3
       sta    temp                    ;3
       inc    rC7                     ;5
       lda    #$01                    ;2
       cmp    rA9                     ;3
       bne    LFAB8                   ;2
       ldy    rA8                     ;3
       beq    LFAF2                   ;2
       lda    LFF66,y                 ;4
       sta    rE4                     ;3
       asl                            ;2
       sta    rE4+1                   ;3
       ldx    rE9                     ;3
       ldy    rE8                     ;3
       lda    #$10                    ;2
       and    r81                     ;3
       ora    rC3                     ;3
       beq    LFAB4                   ;2
       cmp    #$11                    ;2
       bne    LFAB8                   ;2
       ldx    rEB                     ;3
       ldy    rEA                     ;3
LFAB4:
       lda    rA0,x                   ;4
       and    #$E2                    ;2
LFAB8:
       bne    LFB19                   ;2
       lda    r98,x                   ;4
       cmp    #$06                    ;2
       bcs    LFB19                   ;2
       lda    rB2,x                   ;4
       clc                            ;2
       adc    rE4                     ;3
       sec                            ;2
       sbc.wy rB2,y                   ;4
       cmp    rE4+1                   ;3
       bcs    LFB19                   ;2
       lda    rB2,x                   ;4
       adc    #$11                    ;2
       sbc.wy rB2,y                   ;4
       cmp    #$21                    ;2
       bcc    LFB19                   ;2
       lda    rBD,x                   ;4
       adc    #$08                    ;2
       sbc.wy rBD,y                   ;4
       cmp    #$10                    ;2
       bcs    LFB19                   ;2
       lda    rB2,x                   ;4
       cmp    #$C5                    ;2
       bcs    LFB19                   ;2
       cmp.wy rB2,y                   ;4
       lda    rA0,x                   ;4
       and    #$08                    ;2
       bcc    LFAF5                   ;2
LFAF2:
       beq    LFB19                   ;2
       .byte $2C                      ;4 skip next 2 bytes
LFAF5:
       bne    LFB19                   ;2
       bit    rAE                     ;3
       bpl    LFB19                   ;2
       lda    r94,x                   ;4
       cmp    #$05                    ;2
       bcs    LFB19                   ;2
       lda.wy r94,y                   ;4
       cmp    #$05                    ;2
       bcc    LFB0C                   ;2
       cmp    #$08                    ;2
       bcc    LFB19                   ;2
LFB0C:
       lda    frameCounter            ;3
       cmp    #$D0                    ;2
       bcs    LFB19                   ;2
       ldy    #$00                    ;2
       sty    rAD                     ;3
       jmp    LF3D7                   ;3

LFB19:
       ldx    gameVariation           ;3
       lda    LFCC8,x                 ;4
       sta    rEE                     ;3
       lda    rC3                     ;3
       beq    LFB2C                   ;2
       ldx    rEB                     ;3
       ldy    rEA                     ;3
       lda    #$00                    ;2
       beq    LFB32                   ;2 always branch

LFB2C:
       ldx    rE9                     ;3
       ldy    rE8                     ;3
       lda    #$01                    ;2
LFB32:
       sta    rC5                     ;3
       sty    rD1+1                   ;3
       stx    rD1                     ;3
       lda    r98,x                   ;4
       cmp    #$2F                    ;2
       bcc    LFB4B                   ;2
       beq    LFB47                   ;2
       cmp    #$2E                    ;2
       beq    LFB47                   ;2
       jmp    LF376                   ;3

LFB47:
       lda    #$06                    ;2
       sta    r98,x                   ;4
LFB4B:
       jsr    LF9A6                   ;6
       ldy    rD1+1                   ;3
       lda    #$1F                    ;2
       bcs    LFB56                   ;2
       lda    #$21                    ;2
LFB56:
       sta    rF5                     ;3
       lda    #$00                    ;2
       sta    rE4                     ;3
       lda    r94,x                   ;4
       cmp    #$05                    ;2
       bcc    LFB65                   ;2
       jmp    LFC9F                   ;3

LFB65:
       lda    rC5                     ;3
       beq    LFB81                   ;2
       lda    gameVariation           ;3
       bne    LFB9C                   ;2
       lda.wy rBD,y                   ;4
       sec                            ;2
       sbc    rBD,x                   ;4
       bcc    LFB9C                   ;2
       beq    LFB9C                   ;2
       cmp    #$12                    ;2
       bcc    LFB9C                   ;2
       inc    rE4                     ;5
       inc    rE4                     ;5
       bne    LFBB5                   ;2 always branch?
LFB81:
       lda    gameVariation           ;3
       bne    LFBAC                   ;2
       ldy    rE8                     ;3
       sty    rD1+1                   ;3
       lda    rBD,x                   ;4
       clc                            ;2
       adc    #$2D                    ;2
       sbc.wy rBD,y                   ;4
       cmp    #$15                    ;2
       bcc    LFB99                   ;2
       inc    rE4                     ;5
       inc    rE4                     ;5
LFB99:
       jmp    LFBBF                   ;3

LFB9C:
       lda    gameVariation           ;3
       cmp    #$04                    ;2
       bne    LFBAC                   ;2
       ldy    rEA                     ;3
       sty    rD1+1                   ;3
       inc    rE4                     ;5
       inc    rE4                     ;5
       bne    LFBB5                   ;2 always branch?
LFBAC:
       lda    rBD,x                   ;4
       cmp.wy rBD,y                   ;4
       beq    LFBCB                   ;2
       bcs    LFBBF                   ;2
LFBB5:
       lda    rBD,x                   ;4
       cmp    rEE                     ;3
       bcs    LFBCB                   ;2
       lda    #$DF                    ;2
       bne    LFBC7                   ;2 always branch

LFBBF:
       lda    rBD,x                   ;4
       cmp    rF5                     ;3
       bcc    LFBCB                   ;2
       lda    #$EF                    ;2
LFBC7:
       sta    rF6                     ;3
       inc    rE4                     ;5
LFBCB:
       ldx    rD1                     ;3
       ldy    rD1+1                   ;3
       lda.wy rB2,y                   ;4
       sec                            ;2
       sbc    #$08                    ;2
       cmp    rB2,x                   ;4
       bcs    LFBF2                   ;2
       lda.wy rB2,y                   ;4
       adc    #$07                    ;2
       cmp    rB2,x                   ;4
       bcs    LFBE5                   ;2
       jmp    LFC6F                   ;3

LFBE5:
       lda    r98,x                   ;4
       cmp    #$06                    ;2
       bcs    LFBEF                   ;2
       lda    rE4                     ;3
       beq    LFC20                   ;2
LFBEF:
       jmp    LFC9F                   ;3

LFBF2:
       sbc    #$04                    ;2
       cmp    rB2,x                   ;4
       bcs    LFC11                   ;2
       lda.wy r94,y                   ;4
       cmp    #$0B                    ;2
       bne    LFC07                   ;2
       lda.wy rA0,y                   ;4
       eor    #$08                    ;2
       jmp    LFC0A                   ;3

LFC07:
       lda.wy rA0,y                   ;4
LFC0A:
       and    #$08                    ;2
       beq    LFC11                   ;2
       jsr    LFCB0                   ;6
LFC11:
       inc    rE4                     ;5
       lda    rB2,x                   ;4
       cmp    #$B8                    ;2
       bcc    LFC1C                   ;2
       jsr    LFCBD                   ;6
LFC1C:
       lda    #$7F                    ;2
       bne    LFC9B                   ;2 always branch

LFC20:
       lda.wy r94,y                   ;4
       cmp    #$05                    ;2
       bcc    LFC2B                   ;2
       cmp    #$08                    ;2
       bcc    LFBEF                   ;2
LFC2B:
       lda    #$7F                    ;2
       sta    temp                    ;3
       ldx    rD1                     ;3
       lda    rB2,x                   ;4
       cmp.wy rB2,y                   ;4
       bcc    LFC3C                   ;2
       lda    #$BF                    ;2
       bne    LFC3E                   ;2 always branch

LFC3C:
       lda    #$7F                    ;2
LFC3E:
       sta    rE2                     ;3
       ldy    #$00                    ;2
       lda    frameCounter            ;3
       and    #$04                    ;2
       bne    LFC49                   ;2
       iny                            ;2
LFC49:
       lda    rF0                     ;3
       cmp    #$02                    ;2
       beq    LFC68                   ;2
       lsr                            ;2
       lda    #$FF                    ;2
       bcs    LFC6B                   ;2
       lda    frameCounter            ;3
       and    #$20                    ;2
       bne    LFC68                   ;2
       lda    rE2                     ;3
       eor    #$C0                    ;2
       sta    rE2                     ;3
       lda    #$EF                    ;2
       cpy    #$00                    ;2
       beq    LFC6B                   ;2
       bne    LFC9D                   ;2 always branch

LFC68:
       lda    LFF02,y                 ;4
LFC6B:
       and    rE2                     ;3
       bne    LFC9B                   ;2
LFC6F:
       adc    #$04                    ;2
       cmp    rB2,x                   ;4
       bcc    LFC8E                   ;2
       lda.wy r94,y                   ;4
       cmp    #$0B                    ;2
       bne    LFC84                   ;2
       lda.wy rA0,y                   ;4
       eor    #$08                    ;2
       jmp    LFC87                   ;3

LFC84:
       lda.wy rA0,y                   ;4
LFC87:
       and    #$08                    ;2
       bne    LFC8E                   ;2
       jsr    LFCB0                   ;6
LFC8E:
       inc    rE4                     ;5
       lda    rB2,x                   ;4
       cmp    #$4F                    ;2
       bcs    LFC99                   ;2
       jsr    LFCBD                   ;6
LFC99:
       lda    #$BF                    ;2
LFC9B:
       and    rF6                     ;3
LFC9D:
       sta    rF6                     ;3
LFC9F:
       lda    rE4                     ;3
       beq    LFCAD                   ;2
       lda    frameCounter            ;3
       and    #$0A                    ;2
       bne    LFCAD                   ;2
       lda    #$FF                    ;2
       sta    rF6                     ;3
LFCAD:
       jmp    LF376                   ;3

LFCB0:
       lda    frameCounter            ;3
       and    #$30                    ;2
       beq    LFCC7                   ;2
       lda.wy r94,y                   ;4
       cmp    #$08                    ;2
       bcc    LFCC7                   ;2
LFCBD:
       lda    rE4                     ;3
       cmp    #$02                    ;2
       bcs    LFCC7                   ;2
       lda    #$4B                    ;2
       sta    r98,x                   ;4
LFCC7:
       rts                            ;6


LFCD1:
       ldy    rAC                     ;3
       lda    LFF22,y                 ;4
       cmp    #$04                    ;2
       bcs    LFCEA                   ;2
LFCDA:
       sta    rA8                     ;3
       tay                            ;2
       lda    LFF63,y                 ;4
       sta    ballSpritePtr           ;3
LFCE2:
       lda    #$32                    ;2
       sta    rB8                     ;3
       lda    #$00                    ;2
       sta    rA9                     ;3
LFCEA:
       rts                            ;6

LFCEB:
       cmp    rB2,x                   ;4
       bcs    LFCF3                   ;2
       ldy    #$BF                    ;2
       bne    LFCF5                   ;2 always branch

LFCF3:
       ldy    #$7F                    ;2
LFCF5:
       sty    rF6                     ;3
       ldy    #$FF                    ;2
       sty    temp                    ;3
       inc    rC7                     ;5
       lda    frameCounter            ;3
       and    #$0F                    ;2
       sta    frameCounter            ;3
       jmp    LF37E                   ;3

LFD06:
       lda    #$32                    ;2
       sta    rB8                     ;3
       lda    #$00                    ;2
       sta    rAC                     ;3
       ldx    #$03                    ;2
LFD10:
       sta    rA0,x                   ;4
       dex                            ;2
       bpl    LFD10                   ;2
       jsr    LFD69                   ;6
       lda    #$70                    ;2
       sta    rC2                     ;3
       lda    #$04                    ;2
       sta    rA8                     ;3
       sta    rA4,x                   ;4
       sta.wy rA4,y                   ;5
       sta    r9C,x                   ;4
       sta.wy r9C,y                   ;5
       lda    gameVariation           ;3
       cmp    #$03                    ;2
       beq    LFD3D                   ;2
       cmp    #$02                    ;2
       beq    LFD80                   ;2
       cmp    #$01                    ;2
       bne    LFD42                   ;2
       lda    #$25                    ;2
       tay                            ;2
       bne    LFD4C                   ;2 always branch

LFD3D:
       lda    #$00                    ;2
       tay                            ;2
       beq    LFD4C                   ;2 always branch

LFD42:
       lda    #$02                    ;2
       ldx    rEA                     ;3
       sta    rA0,x                   ;4
       lda    #$25                    ;2
       ldy    #$00                    ;2
LFD4C:
       ldx    rEA                     ;3
       sty    r9C,x                   ;4
       ldx    rE8                     ;3
       sta    r9C,x                   ;4
       ldy    rEA                     ;3
       lda    #$07                    ;2
       sta    rA4,x                   ;4
       sta.wy rA4,y                   ;5
LFD5D:
       lda    #$24                    ;2
       sta    rE4+1                   ;3
       lda    #$31                    ;2
       ldx    rE8                     ;3
       ldy    rEA                     ;3
       bne    LFD73                   ;2 always branch

LFD69:
       lda    #$23                    ;2
       sta    rE4+1                   ;3
       lda    #$D1                    ;2
       ldx    rE9                     ;3
       ldy    rEB                     ;3
LFD73:
       sta    rB2,x                   ;4
       sta.wy rB2,y                   ;5
       lda    rE4+1                   ;3
       sta    rBD,x                   ;4
       sta.wy rBD,y                   ;5
       rts                            ;6

LFD80:
       lda    r81                     ;3
       and    #$EF                    ;2
       sta    r81                     ;3
       lda    #$00                    ;2
       jsr    LFCDA                   ;6
       ldx    rE8                     ;3
       ldy    rE9                     ;3
       sta    rA0,x                   ;4
       lda    #$08                    ;2
       sta.wy rA0,y                   ;5
       lda    #$26                    ;2
       sta    rBD,x                   ;4
       lda    #$25                    ;2
       sta.wy rBD,y                   ;5
       lda    #$50                    ;2
       sta    rB2,x                   ;4
       lda    #$B0                    ;2
       sta.wy rB2,y                   ;5
       lda    #$80                    ;2
       sta    rB8                     ;3
       lda    #$5B                    ;2
       sta    ballSpritePtr           ;3
       lda    #$30                    ;2
       sta    rC2                     ;3
       lda    #$02                    ;2
       sta    rA2                     ;3
       sta    rA3                     ;3
       lda    #$05                    ;2
       sta    r9C                     ;3
       sta    r9D                     ;3
       sta    rA4                     ;3
       sta    rA5                     ;3
       rts                            ;6

LFDC5:
       ldy    INTIM                   ;4
       cpy    #$04                    ;2
       bcs    LFDC5                   ;2
       lda    #$82                    ;2
       sta    WSYNC                   ;3
       sta    VSYNC                   ;3
       sta    WSYNC                   ;3
       sta    WSYNC                   ;3
       sta    WSYNC                   ;3
       lda    #$00                    ;2
       sta    VSYNC                   ;3
       lda    #TIME2                  ;2
       sta    WSYNC                   ;3
       sta    TIM64T                  ;4
       rts                            ;6

LFDE4:
       sty    rCF+1                   ;3
       lda    rE8,x                   ;4
       and    #$01                    ;2
       sta    rC7                     ;3
       lda    rE7                     ;3
       bne    LFE2A                   ;2
       lda    gameVariation           ;3
       cmp    #$01                    ;2
       beq    LFE00                   ;2
       cmp    #$02                    ;2
       bne    LFE04                   ;2
       lda    rC7                     ;3
       beq    LFE2E                   ;2
       bne    LFE04                   ;2 always branch

LFE00:
       cpx    #$02                    ;2
       bcs    LFE2A                   ;2
LFE04:
       lda    rC7                     ;3
       beq    LFE25                   ;2
       ldx    #$00                    ;2
LFE0A:
       sed                            ;2
       clc                            ;2
       lda    r8E,x                   ;4
       ldy    rCD                     ;3
       adc    LFF05,y                 ;4
       sta    r8E,x                   ;4
       lda    LFF0B,y                 ;4
       adc    r8D,x                   ;4
       sta    r8D,x                   ;4
       bcc    LFE24                   ;2
       lda    #$00                    ;2
       adc    r8C,x                   ;4
       sta    r8C,x                   ;4
LFE24:
       cld                            ;2
LFE25:
       ldx    rC5                     ;3
       jmp    LFE32                   ;3

LFE2A:
       lda    rC7                     ;3
       beq    LFE25                   ;2
LFE2E:
       ldx    #$03                    ;2
       bne    LFE0A                   ;2 always branch

LFE32:
       lda    rA4,x                   ;4
       beq    LFE96                   ;2
       ldx    rCD                     ;3
       sec                            ;2
       sbc    LFEF4,x                 ;4
       bcs    LFE40                   ;2
       lda    #$00                    ;2
LFE40:
       ldx    rC5                     ;3
       sta    rA4,x                   ;4
       cmp    #$00                    ;2
       bne    LFE96                   ;2
       lda    r9C,x                   ;4
       and    #$0F                    ;2
       sta    rF6                     ;3
       beq    LFE72                   ;2
       dec    rF6                     ;5
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LFE8E                   ;2
       lda    rC7                     ;3
       beq    LFE8E                   ;2
       lda    rF6                     ;3
       beq    LFE72                   ;2
       lda    rCD                     ;3
       cmp    #$09                    ;2
       beq    LFE6E                   ;2
       cmp    #$08                    ;2
       bne    LFE8E                   ;2
       dec    rF6                     ;5
       beq    LFE72                   ;2
LFE6E:
       dec    rF6                     ;5
       bne    LFE8E                   ;2
LFE72:
       lda    #$E0                    ;2
       ora    rA0,x                   ;4
       sta    rA0,x                   ;4
       lda    gameVariation           ;3
       cmp    #$02                    ;2
       beq    LFE82                   ;2
       lda    rC7                     ;3
       bne    LFE86                   ;2
LFE82:
       lda    #$02                    ;2
       bne    LFE8B                   ;2 always branch

LFE86:
       ldy    rF0                     ;3
       lda    LFF34,y                 ;4
LFE8B:
       jsr    LFED8                   ;6
LFE8E:
       lda    r9C,x                   ;4
       and    #$F0                    ;2
       ora    rF6                     ;3
       sta    r9C,x                   ;4
LFE96:
       lda    #$1D                    ;2
       cmp    rBD,x                   ;4
       bcc    LFE9E                   ;2
       sta    rBD,x                   ;4
LFE9E:
       ldy    rCF+1                   ;3
       lda    rA0,x                   ;4
       and    #$EB                    ;2
       sta    rA0,x                   ;4
       lda.wy rA0,y                   ;4
       lsr                            ;2
       and    #$04                    ;2
       ora    rA0,x                   ;4
       sta    rA0,x                   ;4
       asl                            ;2
       and    #$10                    ;2
       ora    rA0,x                   ;4
       sta    rA0,x                   ;4
       lda    rCD                     ;3
       cmp    #$0B                    ;2
       bne    LFEC3                   ;2
       lda    rA0,x                   ;4
       eor    #$04                    ;2
       sta    rA0,x                   ;4
LFEC3:
       lda    #$05                    ;2
       sta    r94,x                   ;4
       lda    #$2D                    ;2
       ldy    gameVariation           ;3
       cpy    #$02                    ;2
       beq    LFED4                   ;2
       ldy    rF0                     ;3
       lda    LFF1E,y                 ;4
LFED4:
       sta    r98,x                   ;4
       lda    #$07                    ;2
LFED8:
       ldy    r82                     ;3
       beq    LFEE0                   ;2
       cmp    r82                     ;3
       bcs    LFEE8                   ;2
LFEE0:
       sta    r82                     ;3
       lda    #$FF                    ;2
       sta    r84                     ;3
       sta    r83                     ;3
LFEE8:
       clc                            ;2
       rts                            ;6

;       ORG  $4EDC
;       RORG $FEDC
;       .byte 0

       ORG  $4F11,0
       RORG $FF11,0

LFCC8:
       .byte $24 ; |  X  X  | $FCC8
       .byte $24 ; |  X  X  | $FCC9
       .byte $4D ; | X  XX X| $FCCA
LFCCB:
       .byte $4D ; | X  XX X| $FCCB
       .byte $24 ; |  X  X  | $FCCC
       .byte $4D ; | X  XX X| $FCCD
       .byte $4D ; | X  XX X| $FCCE
       .byte $24 ; |  X  X  | $FCCF
       .byte $4D ; | X  XX X| $FCD0

LFEEA:
       .word LDA00  ; $FEEA - $FEEB
       .byte $32 ; |  XX  X | $FEEC
LFEED:
       .byte $0D ; |    XX X| $FEED
       .byte $0E ; |    XXX | $FEEE
       .byte $0C ; |    XX  | $FEEF
       .byte $0C ; |    XX  | $FEF0
       .byte $0E ; |    XXX | $FEF1
LFEF2:
       .byte $08 ; |    X   | $FEF2
       .byte $09 ; |    X  X| $FEF3
LFEF4:
       .byte $0B ; |    X XX| $FEF4
       .byte $08 ; |    X   | $FEF5
       .byte $0C ; |    XX  | $FEF6
       .byte $0D ; |    XX X| $FEF7
LFEF8:
       .byte $05 ; |     X X| $FEF8
       .byte $04 ; |     X  | $FEF9
       .byte $04 ; |     X  | $FEFA
       .byte $04 ; |     X  | $FEFB
       .byte $01 ; |       X| $FEFC
       .byte $02 ; |      X | $FEFD
       .byte $03 ; |      XX| $FEFE
       .byte $FF ; |XXXXXXXX| $FEFF
       .byte $FF ; |XXXXXXXX| $FF00
       .byte $FF ; |XXXXXXXX| $FF01
LFF02:
       .byte $FF ; |XXXXXXXX| $FF02
       .byte $DF ; |XX XXXXX| $FF03
LFF04:
       .byte $00 ; |        | $FF04
LFF05:
       .byte $01 ; |       X| $FF05
       .byte $03 ; |      XX| $FF06
LFF07:
       .byte $00 ; |        | $FF07
       .byte $00 ; |        | $FF08
       .byte $00 ; |        | $FF09
       .byte $00 ; |        | $FF0A
LFF0B:
       .byte $02 ; |      X | $FF0B
       .byte $00 ; |        | $FF0C
       .byte $50 ; | X X    | $FF0D
       .byte $00 ; |        | $FF0E
       .byte $00 ; |        | $FF0F
       .byte $80 ; |X       | $FF10
       .byte $00 ; |        | $FF11
       .byte $00 ; |        | $FF12
       .byte $00 ; |        | $FF13
       .byte $01 ; |       X| $FF14
       .byte $01 ; |       X| $FF15
       .byte $01 ; |       X| $FF16
       .byte $02 ; |      X | $FF17
       .byte $02 ; |      X | $FF18
       .byte $05 ; |     X X| $FF19
LFF1A:
       .byte $01 ; |       X| $FF1A
       .byte $00 ; |        | $FF1B
       .byte $03 ; |      XX| $FF1C
       .byte $02 ; |      X | $FF1D
LFF1E:
       .byte $2A ; |  X X X | $FF1E
       .byte $2D ; |  X XX X| $FF1F
       .byte $25 ; |  X  X X| $FF20
       .byte $23 ; |  X   XX| $FF21
LFF22:
       .byte $04 ; |     X  | $FF22
       .byte $00 ; |        | $FF23
       .byte $04 ; |     X  | $FF24
       .byte $01 ; |       X| $FF25
       .byte $02 ; |      X | $FF26
       .byte $01 ; |       X| $FF27
       .byte $04 ; |     X  | $FF28
       .byte $00 ; |        | $FF29
       .byte $02 ; |      X | $FF2A
       .byte $04 ; |     X  | $FF2B
       .byte $02 ; |      X | $FF2C
       .byte $00 ; |        | $FF2D
       .byte $04 ; |     X  | $FF2E
       .byte $01 ; |       X| $FF2F
       .byte $04 ; |     X  | $FF30
       .byte $04 ; |     X  | $FF31
       .byte $00 ; |        | $FF32
       .byte $04 ; |     X  | $FF33
LFF34:
       .byte $04 ; |     X  | $FF34
       .byte $05 ; |     X X| $FF35
       .byte $03 ; |      XX| $FF36
       .byte $03 ; |      XX| $FF37
LFF38:
       .byte $05 ; |     X X| $FF38
       .byte $16 ; |   X XX | $FF39
       .byte $23 ; |  X   XX| $FF3A
       .byte $15 ; |   X X X| $FF3B
       .byte $19 ; |   XX  X| $FF3C
       .byte $27 ; |  X  XXX| $FF3D
       .byte $13 ; |   X  XX| $FF3E
       .byte $25 ; |  X  X X| $FF3F
       .byte $19 ; |   XX  X| $FF40
       .byte $13 ; |   X  XX| $FF41
       .byte $19 ; |   XX  X| $FF42
       .byte $26 ; |  X  XX | $FF43
       .byte $13 ; |   X  XX| $FF44
       .byte $27 ; |  X  XXX| $FF45
       .byte $2B ; |  X X XX| $FF46
       .byte $15 ; |   X X X| $FF47
       .byte $19 ; |   XX  X| $FF48
       .byte $2B ; |  X X XX| $FF49
       .byte $2F ; |  X XXXX| $FF4A
LFF4B:
       .byte $70 ; | XXX    | $FF4B
       .byte $02 ; |      X | $FF4C
       .byte $01 ; |       X| $FF4D
LFF4E:
       .byte $70 ; | XXX    | $FF4E
       .byte $70 ; | XXX    | $FF4F
       .byte $70 ; | XXX    | $FF50
       .byte $70 ; | XXX    | $FF51
       .byte $70 ; | XXX    | $FF52
       .byte $90 ; |X  X    | $FF53
       .byte $90 ; |X  X    | $FF54
       .byte $90 ; |X  X    | $FF55
       .byte $90 ; |X  X    | $FF56
       .byte $90 ; |X  X    | $FF57
       .byte $90 ; |X  X    | $FF58
       .byte $90 ; |X  X    | $FF59
       .byte $90 ; |X  X    | $FF5A
       .byte $90 ; |X  X    | $FF5B
       .byte $90 ; |X  X    | $FF5C
       .byte $90 ; |X  X    | $FF5D
       .byte $90 ; |X  X    | $FF5E
       .byte $90 ; |X  X    | $FF5F
LFF60:
       .byte $90 ; |X  X    | $FF60
LFF61:
       .byte $7F ; | XXXXXXX| $FF61
       .byte $BF ; |X XXXXXX| $FF62
LFF63:
       .byte $0C ; |    XX  | $FF63
       .byte $56 ; | X X XX | $FF64
       .byte $0C ; |    XX  | $FF65
LFF66:
       .byte $56 ; | X X XX | $FF66
       .byte $25 ; |  X  X X| $FF67
       .byte $20 ; |  X     | $FF68
       .byte $45 ; | X   X X| $FF69
LFF6A:
       .byte $05 ; |     X X| $FF6A
       .byte $03 ; |      XX| $FF6B
       .byte $07 ; |     XXX| $FF6C
       .byte $0A ; |    X X | $FF6D
LFF6E:
       .byte $74 ; | XXX X  | $FF6E
       .byte $74 ; | XXX X  | $FF6F
       .byte $49 ; | X  X  X| $FF70
       .byte $49 ; | X  X  X| $FF71
       .byte $74 ; | XXX X  | $FF72
       .byte $49 ; | X  X  X| $FF73
LFF74:
       .byte $00 ; |        | $FF74
LFF75:
       .byte $00 ; |        | $FF75
       .byte $01 ; |       X| $FF76
       .byte $00 ; |        | $FF77
       .byte $02 ; |      X | $FF78
       .byte $00 ; |        | $FF79
       .byte $01 ; |       X| $FF7A
       .byte $00 ; |        | $FF7B
       .byte $02 ; |      X | $FF7C
       .byte $01 ; |       X| $FF7D
       .byte $02 ; |      X | $FF7E
       .byte $00 ; |        | $FF7F
       .byte $01 ; |       X| $FF80
       .byte $00 ; |        | $FF81
       .byte $02 ; |      X | $FF82
       .byte $00 ; |        | $FF83
       .byte $00 ; |        | $FF84
       .byte $02 ; |      X | $FF85
LFF86:
       .byte $00 ; |        | $FF86
       .byte $00 ; |        | $FF87
       .byte $BF ; |X XXXXXX| $FF88
       .byte $00 ; |        | $FF89
       .byte $00 ; |        | $FF8A
       .byte $BF ; |X XXXXXX| $FF8B
       .byte $00 ; |        | $FF8C
       .byte $00 ; |        | $FF8D
       .byte $00 ; |        | $FF8E
       .byte $00 ; |        | $FF8F
       .byte $BF ; |X XXXXXX| $FF90
       .byte $00 ; |        | $FF91
       .byte $00 ; |        | $FF92
       .byte $00 ; |        | $FF93
       .byte $BF ; |X XXXXXX| $FF94
       .byte $00 ; |        | $FF95
       .byte $00 ; |        | $FF96
LFF97:
       .byte $00 ; |        | $FF97
       .byte $04 ; |     X  | $FF98
       .byte $01 ; |       X| $FF99
       .byte $00 ; |        | $FF9A
       .byte $02 ; |      X | $FF9B
       .byte $05 ; |     X X| $FF9C
       .byte $01 ; |       X| $FF9D
       .byte $00 ; |        | $FF9E
       .byte $07 ; |     XXX| $FF9F
       .byte $01 ; |       X| $FFA0
       .byte $02 ; |      X | $FFA1
       .byte $04 ; |     X  | $FFA2
       .byte $01 ; |       X| $FFA3
       .byte $05 ; |     X X| $FFA4
       .byte $08 ; |    X   | $FFA5
       .byte $00 ; |        | $FFA6
       .byte $04 ; |     X  | $FFA7
LFFA8:
       .byte $07 ; |     XXX| $FFA8
       .byte $06 ; |     XX | $FFA9
       .byte $30 ; |  XX    | $FFAA
       .byte $30 ; |  XX    | $FFAB
       .byte $30 ; |  XX    | $FFAC
       .byte $50 ; | X X    | $FFAD
       .byte $50 ; | X X    | $FFAE
       .byte $50 ; | X X    | $FFAF
       .byte $50 ; | X X    | $FFB0
       .byte $50 ; | X X    | $FFB1
       .byte $50 ; | X X    | $FFB2
       .byte $00 ; |        | $FFB3
       .byte $50 ; | X X    | $FFB4
       .byte $50 ; | X X    | $FFB5
       .byte $80 ; |X       | $FFB6
       .byte $80 ; |X       | $FFB7

       ORG  $4FE8
       RORG $FFE8

LFFB8:
       bit    BANK3                   ;4 LDF60 destination
       jmp    LF04E                   ;3 from 1

LFFCA:
       bit    BANK3                   ;4 LDAC4 destination
       jmp    LF06B                   ;3 from 3

       ORG  $4FF4
       RORG $FFF4
       jmp    L92D6                   ;3 from 3
       .word 0      ; $FFF7 - $FFF8
START4:
       jmp    START                   ;3 bankswitch to 4 and boot
       .word START4 ; $FFFC - $FFFD
       .word START4 ; $FFFE - $FFFF
