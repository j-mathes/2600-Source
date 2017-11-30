; Rough disassembly of Quest for Quintana Roo
;
; Sega Genesis control conversion
; By Omegamatrix
;
; last update Nov 30, 2013
;
;  Sega Genesis Controls:
;    - Press button C to choose a tool or weapon (Sam changes color)
;    - Press button C (or RESET) to drop a stone (Sam changes from orange to white)
;
;  For more instructions on how to play the game:
;  http://atariage.com/forums/topic/169397-quest-for-quintana-roo-walkthrough/
;
;  Also, the instructions for the Telegames version are more clear than the Sunrise,
;  and in particular leaving all 5 stones in the chamber room before trying them is a good idea:
;
;  http://www.atarimania.com/2600/boxes/hi_res/quest_for_quintana_roo_telegames_pal_i.jpg
;
;
;
; qqr1.cfg contents:
;
;      ORG 1000
;      CODE 1000 118F
;      GFX 1190 1193
;      CODE 1194 11D6
;      GFX 11D7 11F3
;      CODE 11F4 12C0
;      GFX 12C1 1334
;      CODE 1335 1401
;      GFX 1402 1419
;      CODE 141A 1513
;      GFX 1514 1516
;      CODE 1517 1548
;      GFX 1549 1557
;      CODE 1558 178B
;      GFX 178C 1790
;      CODE 1791 1850
;      GFX 1851 185B
;      CODE 185C 18EB
;      GFX 18EC 18F0
;      CODE 18F1 19AF
;      GFX 19B0 19CD
;      CODE 19CE 1A46
;      GFX 1A47 1A4E
;      CODE 1A4F 1B9B
;      GFX 1B9C 1BA7
;      CODE 1BA8 1CFA
;      GFX 1CFB 1CFF
;      CODE 1D00 1DA0
;      GFX 1DA1 1DA3
;      CODE 1DA4 1E22
;      GFX 1E23 1F65
;      CODE 1F66 1F77
;      GFX 1F78 1FC4
;      CODE 1FC5 1FF4
;      GFX 1FF5 1FFF
;
;
; qqr2.cfg contents:
;
;      ORG 3000
;      CODE 3000 30FD
;      GFX 30FE 3111
;      CODE 3112 3256
;      GFX 3257 3268
;      CODE 3269 3448
;      GFX 3449 344C
;      CODE 344D 34AD
;      GFX 34AE 34BB
;      CODE 34BC 3A7D
;      GFX 3A7E 3FC5
;      CODE 3FC6 3FD4
;      GFX 3FD5 3FFF

SEGA_GENESIS   = 1
BANK_0         = $1FF8

      processor 6502
      include vcs.h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      RIOT RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       SEG.U RIOT_RAM
       ORG $80

ram_80             ds 36 ; x42
ram_A4             ds 1  ; x11
ram_A5             ds 1  ; x5
ram_A6             ds 1  ; x4
ram_A7             ds 1  ; x3
ram_A8             ds 1  ; x4
ram_A9             ds 1  ; x9
ram_AA             ds 1  ; x8
ram_AB             ds 1  ; x23
ram_AC             ds 1  ; x8
ram_AD             ds 1  ; x12
ram_AE             ds 1  ; x4
ram_AF             ds 1  ; x14
ram_B0             ds 1  ; x4
ram_B1             ds 1  ; x2
ram_B2             ds 1  ; x7
ram_B3             ds 1  ; x5
ram_B4             ds 1  ; x5
ram_B5             ds 5  ; x3
ram_BA             ds 1  ; x63
ram_BB             ds 1  ; x6
ram_BC             ds 1  ; x27
ram_BD             ds 1  ; x6
ram_BE             ds 1  ; x11
ram_BF             ds 1  ; x16
ram_C0             ds 1  ; x1
ram_C1             ds 1  ; x1
ram_C2             ds 1  ; x1
ram_C3             ds 1  ; x1
ram_C4             ds 1  ; x7
ram_C5             ds 1  ; x19
ram_C6             ds 1  ; x10
ram_C7             ds 1  ; x7
ram_C8             ds 1  ; x23
ram_C9             ds 1  ; x26
ram_CA             ds 1  ; x10
ram_CB             ds 1  ; x16
ram_CC             ds 1  ; x16
ram_CD             ds 1  ; x7
ram_CE             ds 1  ; x4
ram_CF             ds 1  ; x34
ram_D0             ds 1  ; x3
ram_D1             ds 1  ; x3
ram_D2             ds 1  ; x18
ram_D3             ds 1  ; x5
ram_D4             ds 1  ; x5
ram_D5             ds 4  ; x4
ram_D9             ds 1  ; x15
ram_DA             ds 1  ; x39
ram_DB             ds 1  ; x8
ram_DC             ds 1  ; x5
ram_DD             ds 1  ; x5
ram_DE             ds 1  ; x3
ram_DF             ds 1  ; x4
ram_E0             ds 1  ; x5
ram_E1             ds 1  ; x5
ram_E2             ds 1  ; x20
ram_E3             ds 1  ; x23
ram_E4             ds 1  ; x8
ram_E5             ds 1  ; x8
ram_E6             ds 1  ; x9
ram_E7             ds 1  ; x6
ram_E8             ds 1  ; x6
ram_E9             ds 1  ; x8
ram_EA             ds 1  ; x7
ram_EB             ds 1  ; x4
ram_EC             ds 1  ; x89
ram_ED             ds 1  ; x56
ram_EE             ds 1  ; x32
ram_EF             ds 1  ; x21
ram_F0             ds 1  ; x25
ram_F1             ds 1  ; x12
ram_F2             ds 1  ; x6
ram_F3             ds 1  ; x3
ram_F4             ds 2  ; x3
ram_F6             ds 1  ; x3
ram_F7             ds 1  ; x1
ram_F8             ds 1  ; x7
ram_F9             ds 1  ; x4
ram_FA             ds 1  ; x2
ram_FB             ds 5  ; x2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      BANK 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       SEG CODE
       ORG $0000
      RORG $1000

L1000:
    lda    #$03                  ; 2
    sta    BANK_0,Y              ; 5
    jmp.ind (ram_EC)             ; 5

START_0:
    lda    #<START_1             ; 2
    sta    ram_EC                ; 3
    lda    #>START_1             ; 2
    sta    ram_ED                ; 3
    ldy    #$01                  ; 2
    jmp    L1000                 ; 3

L1015:  ; indirect jump also
    lda    #$2A                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    VBLANK                ; 3
    sta    VSYNC                 ; 3
    sta    TIM8T                 ; 4
    inc    ram_D2                ; 5
    jsr    L1D50                 ; 6
L1025:
    lda    INTIM                 ; 4
    bne    L1025                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    VSYNC                 ; 3
    lda    #$2D                  ; 2
    sta    TIM64T                ; 4
    bit    ram_BC                ; 3
    bvs    L1065                 ; 2³
    lda    ram_BA                ; 3
    lsr                          ; 2
    bcs    L104B                 ; 2³
    jsr    L1204                 ; 6
    jsr    L1335                 ; 6
    jsr    L109B                 ; 6
    jsr    L1517                 ; 6
    jmp    L1065                 ; 3

L104B:
    lda    ram_D2                ; 3
    lsr                          ; 2
    bcs    L1056                 ; 2³
    jsr    L15BB                 ; 6
    jmp    L1065                 ; 3

L1056:
    jsr    L1558                 ; 6
    jsr    L19CE                 ; 6
    jsr    L1BA8                 ; 6
    jsr    L1C1A                 ; 6
    jsr    L185C                 ; 6
L1065:
    jsr    L1DC9                 ; 6
    lda    #<L302A               ; 2
    sta    ram_EC                ; 3
    lda    #>L302A               ; 2
    sta    ram_ED                ; 3
    ldy    #$01                  ; 2
    jmp    L1000                 ; 3

L1075:  ; indirect jump
    bit    ram_BC                ; 3
    bvs    L1093                 ; 2³
    lda    ram_BA                ; 3
    lsr                          ; 2
    bcc    L108D                 ; 2³
    jsr    L1ACE                 ; 6
    jsr    L10E2                 ; 6
    jsr    L1C8C                 ; 6
    jsr    L1A4F                 ; 6
    jmp    L1093                 ; 3

L108D:
    jsr    L141A                 ; 6
    jsr    L149A                 ; 6
L1093:
    lda    INTIM                 ; 4
    bne    L1093                 ; 2³
    jmp    L1015                 ; 3

L109B:
    lda    ram_D2                ; 3
    lsr                          ; 2
    bcs    L10E1                 ; 2³
    lda    SWCHA                 ; 4
    and    #$10                  ; 2
    bne    L10CC                 ; 2³
    lda    ram_C9                ; 3
    cmp    #$42                  ; 2
    bne    L10CC                 ; 2³
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    cmp    #$25                  ; 2
    bcc    L10CC                 ; 2³
    cmp    #$29                  ; 2
    bcc    L10C2                 ; 2³
    cmp    #$C1                  ; 2
    bcc    L10CC                 ; 2³
    cmp    #$C5                  ; 2
    bcs    L10CC                 ; 2³
L10C2:
    lda    ram_BA                ; 3
    ora    #$02                  ; 2
    sta    ram_BA                ; 3
    lda    #$00                  ; 2
    sta    ram_E2                ; 3
L10CC:
    lda    ram_BA                ; 3
    and    #$04                  ; 2
    beq    L10D8                 ; 2³
    jsr    L115D                 ; 6
    jmp    L10E1                 ; 3

L10D8:
    lda    ram_BA                ; 3
    and    #$02                  ; 2
    bne    L10E1                 ; 2³
    jsr    L1113                 ; 6
L10E1:
    rts                          ; 6

L10E2:
    lda    ram_D9                ; 3
    bne    L1112                 ; 2³+1
    lda    ram_D2                ; 3
    lsr                          ; 2
    bcs    L1112                 ; 2³+1
    lda    SWCHA                 ; 4
    and    #$20                  ; 2
    bne    L10FD                 ; 2³
    ldx    ram_C9                ; 3
    inx                          ; 2
    cpx    #$42                  ; 2
    bcc    L10FB                 ; 2³
    ldx    #$42                  ; 2
L10FB:
    stx    ram_C9                ; 3
L10FD:
    lda    SWCHA                 ; 4
    and    #$10                  ; 2
    bne    L110F                 ; 2³
    ldx    ram_C9                ; 3
    dex                          ; 2
    cpx    #$23                  ; 2
    bcs    L110D                 ; 2³
    ldx    #$23                  ; 2
L110D:
    stx    ram_C9                ; 3
L110F:
    jsr    L1113                 ; 6
L1112:
    rts                          ; 6

L1113:
    ldy    #$00                  ; 2
    bit    SWCHA                 ; 4
    bvs    L1125                 ; 2³
    jsr    L1FC5                 ; 6
    lda    ram_BA                ; 3
    ora    #$08                  ; 2
    sta    ram_BA                ; 3
    ldy    #$10                  ; 2
L1125:
    lda    SWCHA                 ; 4
    bmi    L1135                 ; 2³
    jsr    L1FC5                 ; 6
    lda    ram_BA                ; 3
    and    #$F7                  ; 2
    sta    ram_BA                ; 3
    ldy    #$F0                  ; 2
L1135:
    lda    ram_C8                ; 3
    jsr    L1D00                 ; 6
    sta    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    cmp    #$C5                  ; 2
    bcc    L1147                 ; 2³
    lda    #$1C                  ; 2
    sta    ram_C8                ; 3
L1147:
    lda    ram_C7                ; 3
    clc                          ; 2
    adc    #$01                  ; 2
    and    #$0F                  ; 2
    sta    ram_C7                ; 3
    lda    SWCHA                 ; 4
    eor    #$F0                  ; 2
    and    #$F0                  ; 2
    bne    L117C                 ; 2³
    sta    ram_C7                ; 3
    beq    L117C                 ; 3   always branch

L115D:
    ldx    ram_C9                ; 3
    inx                          ; 2
    inx                          ; 2
    cpx    #$42                  ; 2
    bcc    L1171                 ; 2³
    lda    ram_BA                ; 3
    and    #$FB                  ; 2
    sta    ram_BA                ; 3
    lda    #$FF                  ; 2
    sta    ram_C7                ; 3
    ldx    #$42                  ; 2
L1171:
    stx    ram_C9                ; 3
    lda    ram_C7                ; 3
    clc                          ; 2
    adc    #$01                  ; 2
    and    #$0F                  ; 2
    sta    ram_C7                ; 3
L117C:
    lda    ram_C7                ; 3
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    L1190,X               ; 4
    clc                          ; 2
    adc    ram_C9                ; 3
    sta    ram_C5                ; 3
    lda    #$3C                  ; 2
    adc    #$00                  ; 2
    sta    ram_C6                ; 3
    rts                          ; 6

L1190:
    .byte $1E ; |   XXXX | $1190
    .byte $50 ; | X X    | $1191
    .byte $1E ; |   XXXX | $1192
    .byte $82 ; |X     X | $1193

L1194:
    lda    ram_E1                ; 3
    bne    L11D6                 ; 2³
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    tax                          ; 2
    and    #$80                  ; 2
    beq    L11AA                 ; 2³
    txa                          ; 2
    and    #$07                  ; 2
    cmp    #$07                  ; 2
    bne    L11AA                 ; 2³
    lda    #$00                  ; 2
L11AA:
    tay                          ; 2
    asl                          ; 2
    tax                          ; 2
    lda    L11D7,X               ; 4
    sta    ram_DB                ; 3
    lda    L11D8,X               ; 4
    sta    ram_DC                ; 3
    lda    #$0A                  ; 2
    sta    ram_DE                ; 3
    lda    L11E7,Y               ; 4
    sta    ram_DD                ; 3
    cpy    #$06                  ; 2
    bne    L11D6                 ; 2³
    ldx    #$04                  ; 2
L11C6:
    lda    ram_CF                ; 3
    ora    #$80                  ; 2
    cmp    ram_BF,X              ; 4
    bne    L11D3                 ; 2³
    lda    L11EF,X               ; 4
    sta    ram_DD                ; 3
L11D3:
    dex                          ; 2
    bpl    L11C6                 ; 2³
L11D6:
    rts                          ; 6

L11D7:
    .byte $FE ; |XXXXXXX | $11D7
L11D8:
    .byte $3B ; |  XXX XX| $11D8
    .byte $71 ; | XXX   X| $11D9
    .byte $3B ; |  XXX XX| $11DA
    .byte $81 ; |X      X| $11DB
    .byte $3B ; |  XXX XX| $11DC
    .byte $91 ; |X  X   X| $11DD
    .byte $3B ; |  XXX XX| $11DE
    .byte $A1 ; |X X    X| $11DF
    .byte $3B ; |  XXX XX| $11E0
    .byte $B1 ; |X XX   X| $11E1
    .byte $3B ; |  XXX XX| $11E2
    .byte $C1 ; |XX     X| $11E3
    .byte $3B ; |  XXX XX| $11E4
    .byte $FE ; |XXXXXXX | $11E5
    .byte $3B ; |  XXX XX| $11E6
L11E7:
    .byte $00 ; |        | $11E7
    .byte $9C ; |X  XXX  | $11E8
    .byte $86 ; |X    XX | $11E9
    .byte $2A ; |  X X X | $11EA
    .byte $46 ; | X   XX | $11EB
    .byte $44 ; | X   X  | $11EC
    .byte $00 ; |        | $11ED
    .byte $00 ; |        | $11EE
L11EF:
    .byte $44 ; | X   X  | $11EF
    .byte $84 ; |X    X  | $11F0
    .byte $CA ; |XX  X X | $11F1
    .byte $26 ; |  X  XX | $11F2
    .byte $56 ; | X X XX | $11F3

L11F4:
    lda    ram_EC                ; 3
    sed                          ; 2
    clc                          ; 2
    adc    ram_D0                ; 3
    sta    ram_D0                ; 3
    lda    #$00                  ; 2
    adc    ram_D1                ; 3
    sta    ram_D1                ; 3
    cld                          ; 2
    rts                          ; 6

L1204:
  IF SEGA_GENESIS
;     LSR    SWCHB
;     BCS    .noReset
;     BRK
    NOP    $EA
    NOP    $EA
    NOP    $EA
.noReset:
  ENDIF
    lda    ram_D2                ; 3
    and    #$07                  ; 2
    bne    L1210                 ; 2³
    lda    ram_BA                ; 3
    and    #$02                  ; 2
    bne    L1211                 ; 2³
L1210:
    rts                          ; 6

L1211:
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    sta    ram_ED                ; 3
    ldx    SWCHA                 ; 4
    lda    ram_E2                ; 3
    lsr                          ; 2
    bcc    L1227                 ; 2³
    ldx    #$20                  ; 2
    asl                          ; 2
    bpl    L1227                 ; 2³
    ldx    #$10                  ; 2
L1227:
    stx    ram_EC                ; 3
    lda    ram_E2                ; 3
    and    #$7F                  ; 2
    sta    ram_E2                ; 3
    lda    ram_EC                ; 3
    and    #$10                  ; 2
    bne    L124B                 ; 2³
    jsr    L1FC5                 ; 6
    ldx    ram_E2                ; 3
    inx                          ; 2
    cpx    #$1C                  ; 2
    bcc    L1241                 ; 2³
    ldx    #$1C                  ; 2
L1241:
    stx    ram_E2                ; 3
    lda    ram_ED                ; 3
    cmp    #$6D                  ; 2
    bcc    L1274                 ; 2³
    bcs    L126C                 ; 3   always branch

L124B:
    lda    ram_EC                ; 3
    and    #$20                  ; 2
    bne    L127A                 ; 2³
    jsr    L1FC5                 ; 6
    dec    ram_E2                ; 5
    bpl    L1260                 ; 2³
    inc    ram_E2                ; 5
    lda    ram_BA                ; 3
    and    #$FD                  ; 2
    sta    ram_BA                ; 3
L1260:
    lda    ram_E2                ; 3
    ora    #$80                  ; 2
    sta    ram_E2                ; 3
    lda    ram_ED                ; 3
    cmp    #$6D                  ; 2
    bcs    L1274                 ; 2³
L126C:
    lda    ram_BA                ; 3
    ora    #$08                  ; 2
  IF SEGA_GENESIS
    BNE    M127A
  ELSE
    sta    ram_BA                ; 3
    bne    L127A                 ; 3   always branch
  ENDIF

L1274:
    lda    ram_BA                ; 3
    and    #$F7                  ; 2
M127A:
    sta    ram_BA                ; 3
L127A:
    ldx    #<L12C1               ; 2
    ldy    #>L12C1               ; 2
    lda    ram_ED                ; 3
    cmp    #$6D                  ; 2
    bcs    L1288                 ; 2³
    ldx    #<L12DE               ; 2
    ldy    #>L12DE               ; 2
L1288:
    stx    ram_EC                ; 3
    sty    ram_ED                ; 3
    lda    ram_E2                ; 3
    and    #$7F                  ; 2
    tay                          ; 2
    lda    (ram_EC),Y            ; 5
    sta    ram_C8                ; 3
    lda    L12FB,Y               ; 4
    sta    ram_C9                ; 3
    lda    L1318,Y               ; 4
    sta    ram_C5                ; 3
    lda    #$3C                  ; 2
    sta    ram_C6                ; 3
    cmp    #$B4                  ; 2
    bne    L12B3                 ; 2³
    lda    ram_E2                ; 3
    bpl    L12B3                 ; 2³
    lda    #$E6                  ; 2
    sta    ram_C5                ; 3
  IF !SEGA_GENESIS
    lda    #$3C                  ; 2
    sta    ram_C6                ; 3
  ENDIF
L12B3:
    lda    ram_C5                ; 3
    clc                          ; 2
    adc    ram_C9                ; 3
    sta    ram_C5                ; 3
    lda    #$00                  ; 2
    adc    ram_C6                ; 3
    sta    ram_C6                ; 3
    rts                          ; 6

L12C1:
    .byte $2C ; |  X XX  | $12C1
    .byte $4C ; | X  XX  | $12C2
    .byte $6C ; | XX XX  | $12C3
    .byte $9B ; |X  XX XX| $12C4
    .byte $BB ; |X XXX XX| $12C5
    .byte $DB ; |XX XX XX| $12C6
    .byte $FB ; |XXXXX XX| $12C7
    .byte $1B ; |   XX XX| $12C8
    .byte $3B ; |  XXX XX| $12C9
    .byte $5B ; | X XX XX| $12CA
    .byte $8A ; |X   X X | $12CB
    .byte $AA ; |X X X X | $12CC
    .byte $CA ; |XX  X X | $12CD
    .byte $EA ; |XXX X X | $12CE
    .byte $0A ; |    X X | $12CF
    .byte $2A ; |  X X X | $12D0
    .byte $4A ; | X  X X | $12D1
    .byte $6A ; | XX X X | $12D2
    .byte $99 ; |X  XX  X| $12D3
    .byte $B9 ; |X XXX  X| $12D4
    .byte $D9 ; |XX XX  X| $12D5
    .byte $F9 ; |XXXXX  X| $12D6
    .byte $19 ; |   XX  X| $12D7
    .byte $39 ; |  XXX  X| $12D8
    .byte $59 ; | X XX  X| $12D9
    .byte $88 ; |X   X   | $12DA
    .byte $A8 ; |X X X   | $12DB
    .byte $C8 ; |XX  X   | $12DC
    .byte $E8 ; |XXX X   | $12DD
L12DE:
    .byte $02 ; |      X | $12DE
    .byte $E2 ; |XXX   X | $12DF
    .byte $C2 ; |XX    X | $12E0
    .byte $A2 ; |X X   X | $12E1
    .byte $82 ; |X     X | $12E2
    .byte $53 ; | X X  XX| $12E3
    .byte $33 ; |  XX  XX| $12E4
    .byte $13 ; |   X  XX| $12E5
    .byte $F3 ; |XXXX  XX| $12E6
    .byte $D3 ; |XX X  XX| $12E7
    .byte $B3 ; |X XX  XX| $12E8
    .byte $93 ; |X  X  XX| $12E9
    .byte $64 ; | XX  X  | $12EA
    .byte $44 ; | X   X  | $12EB
    .byte $24 ; |  X  X  | $12EC
    .byte $04 ; |     X  | $12ED
    .byte $E4 ; |XXX  X  | $12EE
    .byte $C4 ; |XX   X  | $12EF
    .byte $A4 ; |X X  X  | $12F0
    .byte $84 ; |X    X  | $12F1
    .byte $55 ; | X X X X| $12F2
    .byte $35 ; |  XX X X| $12F3
    .byte $15 ; |   X X X| $12F4
    .byte $F5 ; |XXXX X X| $12F5
    .byte $D5 ; |XX X X X| $12F6
    .byte $B5 ; |X XX X X| $12F7
    .byte $95 ; |X  X X X| $12F8
    .byte $66 ; | XX  XX | $12F9
    .byte $46 ; | X   XX | $12FA
L12FB:
    .byte $42 ; | X    X | $12FB
    .byte $40 ; | X      | $12FC
    .byte $3E ; |  XXXXX | $12FD
    .byte $3E ; |  XXXXX | $12FE
    .byte $3E ; |  XXXXX | $12FF
    .byte $3C ; |  XXXX  | $1300
    .byte $3A ; |  XXX X | $1301
    .byte $38 ; |  XXX   | $1302
    .byte $36 ; |  XX XX | $1303
    .byte $36 ; |  XX XX | $1304
    .byte $36 ; |  XX XX | $1305
    .byte $34 ; |  XX X  | $1306
    .byte $32 ; |  XX  X | $1307
    .byte $30 ; |  XX    | $1308
    .byte $2E ; |  X XXX | $1309
    .byte $2E ; |  X XXX | $130A
    .byte $2E ; |  X XXX | $130B
    .byte $2C ; |  X XX  | $130C
    .byte $2A ; |  X X X | $130D
    .byte $28 ; |  X X   | $130E
    .byte $26 ; |  X  XX | $130F
    .byte $26 ; |  X  XX | $1310
    .byte $26 ; |  X  XX | $1311
    .byte $24 ; |  X  X  | $1312
    .byte $22 ; |  X   X | $1313
    .byte $20 ; |  X     | $1314
    .byte $1E ; |   XXXX | $1315
    .byte $1E ; |   XXXX | $1316
    .byte $1E ; |   XXXX | $1317
L1318:
    .byte $1E ; |   XXXX | $1318
    .byte $B4 ; |X XX X  | $1319
    .byte $1E ; |   XXXX | $131A
    .byte $50 ; | X X    | $131B
    .byte $1E ; |   XXXX | $131C
    .byte $B4 ; |X XX X  | $131D
    .byte $1E ; |   XXXX | $131E
    .byte $B4 ; |X XX X  | $131F
    .byte $1E ; |   XXXX | $1320
    .byte $50 ; | X X    | $1321
    .byte $1E ; |   XXXX | $1322
    .byte $B4 ; |X XX X  | $1323
    .byte $1E ; |   XXXX | $1324
    .byte $B4 ; |X XX X  | $1325
    .byte $1E ; |   XXXX | $1326
    .byte $50 ; | X X    | $1327
    .byte $1E ; |   XXXX | $1328
    .byte $B4 ; |X XX X  | $1329
    .byte $1E ; |   XXXX | $132A
    .byte $B4 ; |X XX X  | $132B
    .byte $1E ; |   XXXX | $132C
    .byte $50 ; | X X    | $132D
    .byte $1E ; |   XXXX | $132E
    .byte $B4 ; |X XX X  | $132F
    .byte $1E ; |   XXXX | $1330
    .byte $B4 ; |X XX X  | $1331
    .byte $1E ; |   XXXX | $1332
    .byte $50 ; | X X    | $1333
    .byte $1E ; |   XXXX | $1334

L1335:
    ldx    ram_BE                ; 3
    lda    ram_D2                ; 3
    and    L1403,X               ; 4
    beq    L133F                 ; 2³
    rts                          ; 6

L133F:
    ldx    #$02                  ; 2
L1341:
    lda    ram_E3,X              ; 4
    and    #$10                  ; 2
    beq    L1350                 ; 2³
    lda    ram_E3,X              ; 4
    and    #$EF                  ; 2
    sta    ram_E3,X              ; 4
    jmp    L1363                 ; 3

L1350:
    lda    #$00                  ; 2
    sta    ram_CC                ; 3
    jsr    L1FC5                 ; 6
    lda    ram_CB                ; 3
    cmp    #$03                  ; 2
    bcs    L1363                 ; 2³
    lda    ram_E3,X              ; 4
    eor    #$90                  ; 2
    sta    ram_E3,X              ; 4
L1363:
    lda    ram_E3,X              ; 4
    and    #$60                  ; 2
    bne    L137F                 ; 2³
    jsr    L1FC5                 ; 6
    lda    ram_CB                ; 3
    cmp    #$04                  ; 2
    bcs    L137F                 ; 2³
    lsr                          ; 2
    and    #$01                  ; 2
    tay                          ; 2
    lda    ram_E3,X              ; 4
    and    #$9F                  ; 2
    ora    L1418,Y               ; 4
    sta    ram_E3,X              ; 4
L137F:
    ldy    #$10                  ; 2
    lda    ram_E3,X              ; 4
    bmi    L1387                 ; 2³
    ldy    #$F0                  ; 2
L1387:
    lda    ram_E6,X              ; 4
    jsr    L1D00                 ; 6
    sta    ram_E6,X              ; 4
    jsr    L1D3A                 ; 6
    cmp    L1412,X               ; 4
    bcs    L139B                 ; 2³
    cmp    L140F,X               ; 4
    bcs    L13A1                 ; 2³
L139B:
    lda    ram_E3,X              ; 4
    eor    #$90                  ; 2
    sta    ram_E3,X              ; 4
L13A1:
    lda    ram_E3,X              ; 4
    tay                          ; 2
    and    #$0F                  ; 2
    sta    ram_EC                ; 3
    tya                          ; 2
    and    #$60                  ; 2
    cmp    #$20                  ; 2
    bne    L13BF                 ; 2³
    inc    ram_EC                ; 5
    lda    ram_EC                ; 3
    cmp    L1415,X               ; 4
    bcc    L13CF                 ; 2³
    lda    L1415,X               ; 4
    sta    ram_EC                ; 3
    bne    L13C9                 ; 3   always branch?

L13BF:
    cmp    #$40                  ; 2
    bne    L13D6                 ; 2³
    dec    ram_EC                ; 5
    bpl    L13CF                 ; 2³
    inc    ram_EC                ; 5
L13C9:
    tya                          ; 2
    and    #$90                  ; 2
    jmp    L13D2                 ; 3

L13CF:
    tya                          ; 2
    and    #$E0                  ; 2
L13D2:
    ora    ram_EC                ; 3
    sta    ram_E3,X              ; 4
L13D6:
    dex                          ; 2
    bmi    L13DC                 ; 2³
    jmp    L1341                 ; 3

L13DC:
    ldx    ram_BE                ; 3
    lda    ram_D2                ; 3
    and    L1406,X               ; 4
    bne    L1401                 ; 2³+1
    ldy    #$02                  ; 2
    ldx    #$04                  ; 2
    lda    ram_E9                ; 3
    cmp    #$76                  ; 2
    bcs    L13F0                 ; 2³
    inx                          ; 2
L13F0:
    lda.wy ram_E3,Y              ; 4
    and    #$0F                  ; 2
    clc                          ; 2
    adc    L1409,X               ; 4
    sta.wy ram_E9,Y              ; 5
    dex                          ; 2
    dex                          ; 2
    dey                          ; 2
    bpl    L13F0                 ; 2³+1
L1401:
    rts                          ; 6

L1402:
    .byte $0F ; |    XXXX| $1402
L1403:
    .byte $07 ; |     XXX| $1403
    .byte $03 ; |      XX| $1404
    .byte $01 ; |       X| $1405
L1406:
    .byte $0F ; |    XXXX| $1406
    .byte $07 ; |     XXX| $1407
    .byte $03 ; |      XX| $1408
L1409:
    .byte $66 ; | XX  XX | $1409
    .byte $8F ; |X   XXXX| $140A
    .byte $9F ; |X  XXXXX| $140B
    .byte $76 ; | XXX XX | $140C
    .byte $86 ; |X    XX | $140D
    .byte $AF ; |X X XXXX| $140E
L140F:
    .byte $56 ; | X X XX | $140F
    .byte $40 ; | X      | $1410
    .byte $2C ; |  X XX  | $1411
L1412:
    .byte $88 ; |X   X   | $1412
    .byte $A0 ; |X X     | $1413
    .byte $B4 ; |X XX X  | $1414
L1415:
    .byte $08 ; |    X   | $1415
    .byte $08 ; |    X   | $1416
    .byte $04 ; |     X  | $1417
L1418:
    .byte $40 ; | X      | $1418
    .byte $20 ; |  X     | $1419

L141A:
    lda    ram_AA                ; 3
    bpl    L1434                 ; 2³
    lda    ram_D2                ; 3
    and    #$7F                  ; 2
    bne    L1499                 ; 2³
    dec    ram_AA                ; 5
    bmi    L1499                 ; 2³
    lda    #$7F                  ; 2
    sta    ram_AA                ; 3
    lda    #$E7                  ; 2
    sta    ram_AD                ; 3
    lda    #$0C                  ; 2
    sta    ram_AF                ; 3
L1434:
    dec    ram_AA                ; 5
    bne    L1449                 ; 2³
    lda    #$06                  ; 2
    sta    ram_CC                ; 3
    jsr    L1FC5                 ; 6
    ldx    ram_CB                ; 3
    inx                          ; 2
    txa                          ; 2
    ora    #$80                  ; 2
    sta    ram_AA                ; 3
    bne    L1454                 ; 2³
L1449:
    lda    ram_AA                ; 3
    tax                          ; 2
    cmp    #$0F                  ; 2
    bcc    L1464                 ; 2³
    and    #$04                  ; 2
    beq    L1464                 ; 2³
L1454:
    lda    #$FF                  ; 2
    sta    ram_AB                ; 3
    lda    #$3D                  ; 2
    sta    ram_AC                ; 3
    lda    #$01                  ; 2
    jsr    L1DA4                 ; 6
    jmp    L1499                 ; 3

L1464:
    cpx    #$0F                  ; 2
    bcs    L148C                 ; 2³
    cpx    #$0E                  ; 2
    bne    L1471                 ; 2³
    lda    #$02                  ; 2
    jsr    L1DA4                 ; 6
L1471:
    ldy    #$50                  ; 2
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    cmp    #$6D                  ; 2
    bcc    L147E                 ; 2³
    ldy    #$B0                  ; 2
L147E:
    lda    ram_AD                ; 3
    jsr    L1D00                 ; 6
    sta    ram_AD                ; 3
    lda    ram_AF                ; 3
    clc                          ; 2
    adc    #$03                  ; 2
    sta    ram_AF                ; 3
L148C:
    lda    #$FF                  ; 2
    clc                          ; 2
    adc    ram_AF                ; 3
    sta    ram_AB                ; 3
    lda    #$00                  ; 2
    adc    #$3D                  ; 2
    sta    ram_AC                ; 3
L1499:
    rts                          ; 6

L149A:
    bit    CXM0P | $30           ; 3
    bvc    L14AC                 ; 2³
    lda    ram_BA                ; 3
    and    #$02                  ; 2
    beq    L14AC                 ; 2³
    lda    ram_BA                ; 3
    and    #$FD                  ; 2
    ora    #$04                  ; 2
    sta    ram_BA                ; 3
L14AC:
    lda    ram_BA                ; 3
    and    #$04                  ; 2
    bne    L1513                 ; 2³+1
    lda    CXPPMM | $30          ; 3
    bpl    L1513                 ; 2³+1
    ldx    #$00                  ; 2
    lda    ram_C9                ; 3
    cmp    #$2A                  ; 2
    bcc    L14C4                 ; 2³
    inx                          ; 2
    cmp    #$32                  ; 2
    bcc    L14C4                 ; 2³
    inx                          ; 2
L14C4:
    lda    ram_E3,X              ; 4
    and    #$0F                  ; 2
    clc                          ; 2
    adc    L1514,X               ; 4
    sec                          ; 2
    sbc    ram_C9                ; 3
    beq    L14DC                 ; 2³
    bpl    L14D8                 ; 2³
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #$01                  ; 2
L14D8:
    cmp    #$02                  ; 2
    bcs    L1513                 ; 2³+1
L14DC:
    lda    ram_E6,X              ; 4
    jsr    L1D3A                 ; 6
    sta    ram_EE                ; 3
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    sec                          ; 2
    sbc    ram_EE                ; 3
    beq    L14F8                 ; 2³
    bpl    L14F4                 ; 2³
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #$01                  ; 2
L14F4:
    cmp    #$10                  ; 2
    bcs    L1513                 ; 2³+1
L14F8:
    lda    ram_BA                ; 3
    and    #$02                  ; 2
    beq    L1506                 ; 2³+1
    lda    ram_BA                ; 3
    and    #$FD                  ; 2
    ora    #$04                  ; 2
    sta    ram_BA                ; 3
L1506:
    lda    ram_CA                ; 3
    bne    L1513                 ; 2³
    lda    #$60                  ; 2
    sta    ram_CA                ; 3
    lda    #$03                  ; 2
    jsr    L1DA4                 ; 6
L1513:
    rts                          ; 6

L1514:
    .byte $1E ; |   XXXX | $1514
    .byte $2E ; |  X XXX | $1515
    .byte $3E ; |  XXXXX | $1516

L1517:
    lda    ram_BA                ; 3
    and    #$02                  ; 2
    beq    L1548                 ; 2³
    lda    INPT4 | $30           ; 3
    bmi    L1548                 ; 2³
    ldx    #$04                  ; 2
L1523:
    lda    ram_E2                ; 3
    cmp    L1549,X               ; 4
    beq    L152F                 ; 2³
    dex                          ; 2
    bpl    L1523                 ; 2³
    bmi    L1548                 ; 3   always branch

L152F:
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    cmp    #$6D                  ; 2
    txa                          ; 2
    bcs    L153C                 ; 2³
    clc                          ; 2
    adc    #$05                  ; 2
L153C:
    tax                          ; 2
    lda    L154E,X               ; 4
    sta    ram_CF                ; 3
    lda    ram_BA                ; 3
    ora    #$20                  ; 2
    sta    ram_BA                ; 3
L1548:
    rts                          ; 6

L1549:
    .byte $04 ; |     X  | $1549
    .byte $0A ; |    X X | $154A
    .byte $10 ; |   X    | $154B
    .byte $16 ; |   X XX | $154C
    .byte $1C ; |   XXX  | $154D
L154E:
    .byte $01 ; |       X| $154E
    .byte $03 ; |      XX| $154F
    .byte $06 ; |     XX | $1550
    .byte $0A ; |    X X | $1551
    .byte $0E ; |    XXX | $1552
    .byte $13 ; |   X  XX| $1553
    .byte $15 ; |   X X X| $1554
    .byte $18 ; |   XX   | $1555
    .byte $1C ; |   XXX  | $1556
    .byte $20 ; |  X     | $1557

L1558:
    bit    ram_DA                ; 3
    bvs    L15A4                 ; 2³

  IF SEGA_GENESIS
    LDA    INPT1
    AND    #$80
    NOP
  ELSE
    lda    SWCHB                 ; 4
    and    #$02                  ; 2
  ENDIF

    bne    L1582                 ; 2³
    ldx    ram_DA                ; 3
    bmi    L1588                 ; 2³
    cpx    #$04                  ; 2
    bne    L156E                 ; 2³
    jsr    L15A5                 ; 6
L156E:
    inx                          ; 2
    cpx    #$04                  ; 2
    bcc    L1575                 ; 2³
    ldx    #$00                  ; 2
L1575:
    txa                          ; 2
    ora    #$80                  ; 2
    sta    ram_DA                ; 3
    lda    #$05                  ; 2
    jsr    L1DA4                 ; 6
    jmp    L1588                 ; 3

L1582:
    lda    ram_DA                ; 3
    and    #$7F                  ; 2
    sta    ram_DA                ; 3
L1588:
;   IF SEGA_GENESIS
; ;     LSR    SWCHB
; ;     BCS    L15A4
; ;     BRK
;     JMP   L15A4
;     NOP
;     NOP
;     NOP
;     
;   ELSE
    lda    SWCHB                 ; 4
    lsr                          ; 2  here
    bcs    L15A4                 ; 2³
;   ENDIF
  
    lda    ram_DA                ; 3
    beq    L15A4                 ; 2³
    lda    ram_DA                ; 3
    cmp    #$04                  ; 2
    bne    L159B                 ; 2³
    jsr    L15A5                 ; 6
L159B:
    lda    #$00                  ; 2
    sta    ram_DA                ; 3
    lda    #$06                  ; 2
    jsr    L1DA4                 ; 6
L15A4:
    rts                          ; 6

L15A5:
    ldy    #$04                  ; 2
L15A7:
    lda.wy ram_BF,Y              ; 4
    cmp    #$FF                  ; 2
    bne    L15B7                 ; 2³
    lda    ram_CF                ; 3
    bne    L15B4                 ; 2³
    lda    #$FE                  ; 2
L15B4:
    sta.wy ram_BF,Y              ; 5
L15B7:
    dey                          ; 2
    bpl    L15A7                 ; 2³
    rts                          ; 6

L15BB:
    bit    ram_DA                ; 3
    bvs    L15CF                 ; 2³
    lda    INPT4 | $30           ; 3
    bmi    L1608                 ; 2³+1
    lda    ram_DA                ; 3
    and    #$07                  ; 2
    beq    L1608                 ; 2³+1
    lda    ram_DA                ; 3
    ora    #$40                  ; 2
    sta    ram_DA                ; 3
L15CF:
    lda    ram_DA                ; 3
    and    #$07                  ; 2
    cmp    #$01                  ; 2
    bne    L15DD                 ; 2³
    jsr    L1609                 ; 6
    jmp    L1608                 ; 3

L15DD:
    cmp    #$02                  ; 2
    bne    L15E7                 ; 2³
    jsr    L166E                 ; 6
    jmp    L1608                 ; 3

L15E7:
    tax                          ; 2
    lda    SWCHA                 ; 4
    and    #$F0                  ; 2
    eor    #$F0                  ; 2
    beq    L15F7                 ; 2³
    jsr    L171A                 ; 6
    jmp    L1608                 ; 3

L15F7:
    cpx    #$03                  ; 2
    bne    L1601                 ; 2³+1
    jsr    L16EC                 ; 6
    jmp    L1608                 ; 3

L1601:
    cpx    #$04                  ; 2
    bne    L1608                 ; 2³
    jsr    L1727                 ; 6
L1608:
    rts                          ; 6

L1609:
    lda    ram_DA                ; 3
    and    #$20                  ; 2
    bne    L1647                 ; 2³
    lda    ram_B0                ; 3
    beq    L165B                 ; 2³
    lda    #$00                  ; 2
    jsr    L1DA4                 ; 6
    lda    ram_DA                ; 3
    ora    #$20                  ; 2
    sta    ram_DA                ; 3
    dec    ram_B0                ; 5
    lda    ram_C9                ; 3
    sec                          ; 2
    sbc    #$05                  ; 2
    sta    ram_AF                ; 3
    clc                          ; 2
    adc    #$FF                  ; 2
    sta    ram_AB                ; 3
    lda    #$3D                  ; 2
    adc    #$00                  ; 2
    sta    ram_AC                ; 3
    lda    ram_C8                ; 3
    ldy    #$C0                  ; 2
    jsr    L1D00                 ; 6
    sta    ram_AD                ; 3
    ldx    #$D0                  ; 2
    lda    ram_BA                ; 3
    and    #$08                  ; 2
    beq    L1645                 ; 2³
    ldx    #$30                  ; 2
L1645:
    stx    ram_AE                ; 3
L1647:
    ldy    ram_AE                ; 3
    lda    ram_AD                ; 3
    jsr    L1D00                 ; 6
    sta    ram_AD                ; 3
    jsr    L1D3A                 ; 6
    cmp    #$24                  ; 2
    bcc    L165B                 ; 2³
    cmp    #$CC                  ; 2
    bcc    L165E                 ; 2³
L165B:
    jsr    L165F                 ; 6
L165E:
    rts                          ; 6

L165F:
    lda    #$FF                  ; 2
    sta    ram_AB                ; 3
    lda    #$3D                  ; 2
    sta    ram_AC                ; 3
    lda    ram_DA                ; 3
    and    #$9F                  ; 2
    sta    ram_DA                ; 3
    rts                          ; 6

L166E:
    lda    ram_DA                ; 3
    and    #$20                  ; 2
    bne    L16A5                 ; 2³
    lda    ram_BB                ; 3
    beq    L16D5                 ; 2³
    lda    ram_DA                ; 3
    ora    #$20                  ; 2
    sta    ram_DA                ; 3
    dec    ram_BB                ; 5
    lda    #$07                  ; 2
    jsr    L1DA4                 ; 6
    lda    ram_C9                ; 3
    sec                          ; 2
    sbc    #$05                  ; 2
    sta    ram_AF                ; 3
    lda    #$20                  ; 2
    sta    ram_D9                ; 3
    lda    ram_C8                ; 3
    ldy    #$C0                  ; 2
    jsr    L1D00                 ; 6
    sta    ram_AD                ; 3
    ldx    #$F0                  ; 2
    lda    ram_BA                ; 3
    and    #$08                  ; 2
    beq    L16A3                 ; 2³
    ldx    #$10                  ; 2
L16A3:
    stx    ram_AE                ; 3
L16A5:
    lda    ram_D2                ; 3
    lsr                          ; 2
    bcs    L16D8                 ; 2³
    ldy    ram_AE                ; 3
    lda    ram_AD                ; 3
    jsr    L1D00                 ; 6
    sta    ram_AD                ; 3
    lda    ram_D9                ; 3
    lsr                          ; 2
    bcs    L16C4                 ; 2³
    dec    ram_AF                ; 5
    lda    ram_D9                ; 3
    cmp    #$16                  ; 2
    bcs    L16C4                 ; 2³
    inc    ram_AF                ; 5
    inc    ram_AF                ; 5
L16C4:
    lda    #$FF                  ; 2
    clc                          ; 2
    adc    ram_AF                ; 3
    sta    ram_AB                ; 3
    lda    #$00                  ; 2
    adc    #$3D                  ; 2
    sta    ram_AC                ; 3
    dec    ram_D9                ; 5
    bne    L16D8                 ; 2³
L16D5:
    jsr    L16D9                 ; 6
L16D8:
    rts                          ; 6

L16D9:
    lda    #$FF                  ; 2
    sta    ram_AB                ; 3
    lda    #$3D                  ; 2
    sta    ram_AC                ; 3
    lda    ram_C9                ; 3
    sta    ram_AF                ; 3
    lda    #$00                  ; 2
    sta    ram_D9                ; 3
    sta    ram_DA                ; 3
    rts                          ; 6

L16EC:
    lda    ram_D9                ; 3
    bne    L16F9                 ; 2³
    lda    #$04                  ; 2
    sta    ram_D9                ; 3
    lda    #$0C                  ; 2
    jsr    L1DA4                 ; 6
L16F9:
    lda    ram_D9                ; 3
    and    #$01                  ; 2
    tax                          ; 2
    lda    L1725,X               ; 4
    clc                          ; 2
    adc    ram_C9                ; 3
    sta    ram_C5                ; 3
    lda    #$00                  ; 2
    adc    #$3D                  ; 2
    sta    ram_C6                ; 3
    lda    ram_D2                ; 3
    and    #$07                  ; 2
    bne    L1719                 ; 2³
    dec    ram_D9                ; 5
    bne    L1719                 ; 2³
    jsr    L171A                 ; 6
L1719:
    rts                          ; 6

L171A:
    lda    #$00                  ; 2
    sta    ram_D9                ; 3
    lda    ram_DA                ; 3
    and    #$07                  ; 2
    sta    ram_DA                ; 3
    rts                          ; 6

L1725:
    clc                          ; 2
    lsr                          ; 2
L1727:
    lda    ram_C9                ; 3
    cmp    #$23                  ; 2
    bne    L1741                 ; 2³
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    cmp    #$37                  ; 2
    bcc    L1741                 ; 2³
    cmp    #$4D                  ; 2
    bcs    L1741                 ; 2³
    lda    ram_DA                ; 3
    and    #$BF                  ; 2
    sta    ram_DA                ; 3
    rts                          ; 6

L1741:
    jsr    L16EC                 ; 6
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    and    #$87                  ; 2
    cmp    #$87                  ; 2
    bne    L178B                 ; 2³
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    sta    ram_EC                ; 3
    ldx    #$07                  ; 2
    lda    ram_BA                ; 3
    and    #$08                  ; 2
    beq    L175F                 ; 2³
    ldx    #$00                  ; 2
L175F:
    txa                          ; 2
    clc                          ; 2
    adc    ram_EC                ; 3
    sta    ram_EC                ; 3
    ldx    #$04                  ; 2
L1767:
    lda    L178C,X               ; 4
    sec                          ; 2
    sbc    ram_EC                ; 3
    bcc    L1773                 ; 2³
    cmp    #$04                  ; 2
    bcc    L1778                 ; 2³
L1773:
    dex                          ; 2
    bpl    L1767                 ; 2³
    bmi    L178B                 ; 3   always branch

L1778:
    txa                          ; 2
    tay                          ; 2
    lda    #$80                  ; 2
L177C:
    lsr                          ; 2
    dex                          ; 2
    bpl    L177C                 ; 2³
    sta    ram_EC                ; 3
    lda    ram_BD                ; 3
    and    ram_EC                ; 3
    beq    L178B                 ; 2³
    jsr    L1791                 ; 6
L178B:
    rts                          ; 6

L178C:
    .byte $B4 ; |X XX X  | $178C
    .byte $B0 ; |X XX    | $178D
    .byte $AB ; |X X X XX| $178E
    .byte $A7 ; |X X  XXX| $178F
    .byte $A3 ; |X X   XX| $1790

L1791:
    jsr    L171A                 ; 6
    tya                          ; 2
    tax                          ; 2
    php                          ; 3
    lda    #$00                  ; 2
    sta    ram_DA                ; 3
    lda    ram_B3                ; 3
    sta    ram_EC                ; 3
    lda    ram_B2                ; 3
    plp                          ; 4
    beq    L17B0                 ; 2³
L17A4:
    lsr    ram_EC                ; 5
    ror                          ; 2
    lsr    ram_EC                ; 5
    ror                          ; 2
    lsr    ram_EC                ; 5
    ror                          ; 2
    dex                          ; 2
    bne    L17A4                 ; 2³
L17B0:
    and    #$07                  ; 2
    sta    ram_EC                ; 3
    ldx    #$04                  ; 2
L17B6:
    lda    ram_BF,X              ; 4
    cmp    #$FF                  ; 2
    bne    L17C2                 ; 2³
    stx    ram_ED                ; 3
    cpx    ram_EC                ; 3
    beq    L17F1                 ; 2³
L17C2:
    dex                          ; 2
    bpl    L17B6                 ; 2³
    ldy    ram_ED                ; 3
    lda    #$FE                  ; 2
    sta.wy ram_BF,Y              ; 5
    ldx    #$03                  ; 2
L17CE:
    lda    #$24                  ; 2
    sta    ram_CC                ; 3
    jsr    L1FC5                 ; 6
    ldy    ram_CB                ; 3
    lda.wy ram_80-1,Y            ; 4
    and    #$07                  ; 2
    cmp    #$07                  ; 2
    beq    L17E8                 ; 2³
    lda.wy ram_80-1,Y            ; 4
    and    #$7F                  ; 2
    sta.wy ram_80-1,Y            ; 5
L17E8:
    dex                          ; 2
    bpl    L17CE                 ; 2³
    lda    #$0E                  ; 2
    jsr    L1DA4                 ; 6
    rts                          ; 6

L17F1:
    lda    #$FD                  ; 2
    sta    ram_BF,X              ; 4
    lda    #$10                  ; 2
    sta    ram_EC                ; 3
    jsr    L11F4                 ; 6
    lda    #$0D                  ; 2
    jsr    L1DA4                 ; 6
    lda    ram_BD                ; 3
    and    L1851,Y               ; 4
    sta    ram_BD                ; 3
    and    #$7E                  ; 2
    bne    L1850                 ; 2³
    lda    #$50                  ; 2
    sta    ram_EC                ; 3
    jsr    L11F4                 ; 6
    ldx    ram_C4                ; 3
    cpx    #$03                  ; 2
    beq    L181B                 ; 2³
    inc    ram_C4                ; 5
L181B:
    lda    #$78                  ; 2
    sta    ram_E0                ; 3
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    and    #$D8                  ; 2
    sta    ram_80-1,X            ; 4
    lda    ram_BE                ; 3
    asl                          ; 2
    tax                          ; 2
    lda    L1856,X               ; 4
    sta    ram_DB                ; 3
    lda    L1857,X               ; 4
    sta    ram_DC                ; 3
    lda    #$2E                  ; 2
    sta    ram_E2                ; 3
    sta    ram_E7                ; 3
    lda    #$3C                  ; 2
    sta    ram_E3                ; 3
    sta    ram_E8                ; 3
    lda    #$0F                  ; 2
    sta    ram_DD                ; 3
    lda    #$0B                  ; 2
    jsr    L1DA4                 ; 6
    lda    ram_BC                ; 3
    ora    #$10                  ; 2
    sta    ram_BC                ; 3
L1850:
    rts                          ; 6

L1851:
    .byte $BF ; |X XXXXXX| $1851
    .byte $DF ; |XX XXXXX| $1852
    .byte $EF ; |XXX XXXX| $1853
    .byte $F7 ; |XXXX XXX| $1854
    .byte $FB ; |XXXXX XX| $1855
L1856:
    .byte $D1 ; |XX X   X| $1856
L1857:
    .byte $3B ; |  XXX XX| $1857
    .byte $E1 ; |XXX    X| $1858
    .byte $3B ; |  XXX XX| $1859
    .byte $F1 ; |XXXX   X| $185A
    .byte $3B ; |  XXX XX| $185B

L185C:
    lda    ram_DA                ; 3
    cmp    #$04                  ; 2
    beq    L1865                 ; 2³
    tax                          ; 2
    bne    L18BF                 ; 2³
L1865:
    lda    INPT4 | $30           ; 3
    bmi    L18BF                 ; 2³
    lda    ram_C9                ; 3
    cmp    #$23                  ; 2
    bne    L1896                 ; 2³
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    cmp    #$37                  ; 2
    bcc    L1882                 ; 2³
    cmp    #$4D                  ; 2
    bcs    L1882                 ; 2³
    jsr    L1987                 ; 6
    jmp    L18EB                 ; 3

L1882:
    ldx    ram_DA                ; 3
    cpx    #$04                  ; 2
    beq    L18BF                 ; 2³
    cmp    #$A4                  ; 2
    bcc    L1896                 ; 2³
    cmp    #$AC                  ; 2
    bcs    L1896                 ; 2³
    jsr    L191A                 ; 6
    jmp    L18EB                 ; 3

L1896:
    ldx    ram_DA                ; 3
    cpx    #$04                  ; 2
    beq    L18BF                 ; 2³
    lda    #$90                  ; 2
    sta    ram_EC                ; 3
    lda    #$3A                  ; 2
    sta    ram_ED                ; 3
    jsr    L18F1                 ; 6
    bne    L18C2                 ; 2³
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    asl                          ; 2
    bpl    L18BF                 ; 2³
    lda    ram_80-1,X            ; 4
    and    #$BF                  ; 2
    sta    ram_80-1,X            ; 4
    lda    #$00                  ; 2
    sta    ram_CA                ; 3
    lda    #$0F                  ; 2
    jsr    L1DA4                 ; 6
L18BF:
    jmp    L18EB                 ; 3

L18C2:
    ldx    #$04                  ; 2
L18C4:
    lda    #$76                  ; 2
    sta    ram_EC                ; 3
    lda    L18EC,X               ; 4
    sta    ram_ED                ; 3
    jsr    L18F1                 ; 6
    bne    L18E8                 ; 2³
    lda    ram_CF                ; 3
    cmp    ram_BF,X              ; 4
    bne    L18E8                 ; 2³
    lda    #$FF                  ; 2
    sta    ram_BF,X              ; 4
    lda    #$04                  ; 2
    sta    ram_DA                ; 3
    lda    #$0F                  ; 2
    jsr    L1DA4                 ; 6
    jmp    L18EB                 ; 3

L18E8:
    dex                          ; 2
    bpl    L18C4                 ; 2³
L18EB:
    rts                          ; 6

L18EC:
    .byte $28 ; |  X X   | $18EC
    .byte $2E ; |  X XXX | $18ED
    .byte $34 ; |  XX X  | $18EE
    .byte $3A ; |  XXX X | $18EF
    .byte $40 ; | X      | $18F0

L18F1:
    ldy    #$00                  ; 2
    lda    ram_C9                ; 3
    sec                          ; 2
    sbc    ram_ED                ; 3
    bcs    L18FC                 ; 2³
    eor    #$FF                  ; 2
L18FC:
    cmp    #$02                  ; 2
    bcc    L1901                 ; 2³
    iny                          ; 2
L1901:
    lda    ram_EC                ; 3
    pha                          ; 3
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    sta    ram_EC                ; 3
    pla                          ; 4
    sec                          ; 2
    sbc    ram_EC                ; 3
    bcs    L1913                 ; 2³
    eor    #$FF                  ; 2
L1913:
    cmp    #$02                  ; 2
    bcc    L1918                 ; 2³
    iny                          ; 2
L1918:
    tya                          ; 2
    rts                          ; 6

L191A:
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    bpl    L1986                 ; 2³
    and    #$07                  ; 2
    beq    L1986                 ; 2³
    cmp    #$07                  ; 2
    beq    L1986                 ; 2³
    cmp    #$06                  ; 2
    bne    L194F                 ; 2³
    lda    ram_DA                ; 3
    and    #$07                  ; 2
    cmp    #$04                  ; 2
    beq    L1986                 ; 2³
    ldy    #$04                  ; 2
L1936:
    lda.wy ram_BF,Y              ; 4
    bpl    L194A                 ; 2³
    and    #$7F                  ; 2
    cmp    ram_CF                ; 3
    bne    L194A                 ; 2³
    lda    #$FF                  ; 2
    sta.wy ram_BF,Y              ; 5
    lda    #$04                  ; 2
    sta    ram_DA                ; 3
L194A:
    dey                          ; 2
    bpl    L1936                 ; 2³
    bmi    L1973                 ; 3   always branch

L194F:
    cmp    #$05                  ; 2
    bne    L1957                 ; 2³
    lda    #$05                  ; 2
    sta    ram_BB                ; 3
L1957:
    lda    #$10                  ; 2
    sta    ram_EC                ; 3
    jsr    L11F4                 ; 6
    ldy    ram_DF                ; 3
    iny                          ; 2
    sty    ram_DF                ; 3
    cpy    #$14                  ; 2
    bne    L1973                 ; 2³
    lda    #$00                  ; 2
    sta    ram_DF                ; 3
    lda    ram_C4                ; 3
    cmp    #$03                  ; 2
    beq    L1973                 ; 2³
    inc    ram_C4                ; 5
L1973:
    lda    #$09                  ; 2
    jsr    L1DA4                 ; 6
    lda    ram_80-1,X            ; 4
    and    #$F8                  ; 2
    sta    ram_80-1,X            ; 4
    lda    #$FE                  ; 2
    sta    ram_DB                ; 3
    lda    #$3B                  ; 2
    sta    ram_DC                ; 3
L1986:
    rts                          ; 6

L1987:
    inc    ram_CF                ; 5
    lda    #$00                  ; 2
    ldx    ram_BE                ; 3
    beq    L1995                 ; 2³
L198F:
    clc                          ; 2
    adc    #$0A                  ; 2
    dex                          ; 2
    bne    L198F                 ; 2³
L1995:
    tax                          ; 2
    ldy    #$09                  ; 2
    lda    ram_CF                ; 3
L199A:
    cmp    L19B0,X               ; 4
    beq    L19A5                 ; 2³
    inx                          ; 2
    dey                          ; 2
    bpl    L199A                 ; 2³
    bmi    L19A9                 ; 3   always branch

L19A5:
    lda    #$00                  ; 2
    sta    ram_CF                ; 3
L19A9:
    lda    ram_BA                ; 3
    ora    #$20                  ; 2
    sta    ram_BA                ; 3
    rts                          ; 6

L19B0:
    .byte $02 ; |      X | $19B0
    .byte $05 ; |     X X| $19B1
    .byte $08 ; |    X   | $19B2
    .byte $0D ; |    XX X| $19B3
    .byte $12 ; |   X  X | $19B4
    .byte $14 ; |   X X  | $19B5
    .byte $17 ; |   X XXX| $19B6
    .byte $1A ; |   XX X | $19B7
    .byte $1F ; |   XXXXX| $19B8
    .byte $24 ; |  X  X  | $19B9
    .byte $02 ; |      X | $19BA
    .byte $05 ; |     X X| $19BB
    .byte $09 ; |    X  X| $19BC
    .byte $0E ; |    XXX | $19BD
    .byte $13 ; |   X  XX| $19BE
    .byte $14 ; |   X X  | $19BF
    .byte $17 ; |   X XXX| $19C0
    .byte $1B ; |   XX XX| $19C1
    .byte $20 ; |  X     | $19C2
    .byte $25 ; |  X  X X| $19C3
    .byte $03 ; |      XX| $19C4
    .byte $06 ; |     XX | $19C5
    .byte $0A ; |    X X | $19C6
    .byte $0E ; |    XXX | $19C7
    .byte $13 ; |   X  XX| $19C8
    .byte $15 ; |   X X X| $19C9
    .byte $18 ; |   XX   | $19CA
    .byte $1C ; |   XXX  | $19CB
    .byte $20 ; |  X     | $19CC
    .byte $25 ; |  X  X X| $19CD

L19CE:
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    bmi    L1A13                 ; 2³+1
    lda    ram_DA                ; 3
    and    #$43                  ; 2
    cmp    #$43                  ; 2
    bne    L19F2                 ; 2³
    lda    ram_C9                ; 3
    cmp    #$23                  ; 2
    bne    L19F2                 ; 2³
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    sec                          ; 2
    sbc    ram_B1                ; 3
    bpl    L19EE                 ; 2³
    eor    #$FF                  ; 2
L19EE:
    cmp    #$05                  ; 2
    bcc    L19FB                 ; 2³
L19F2:
    lda    ram_AF                ; 3
    cmp    #$18                  ; 2
    bne    L1A13                 ; 2³+1
    jsr    L16D9                 ; 6
L19FB:
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    ora    #$80                  ; 2
    sta    ram_80-1,X            ; 4
    lda    #$01                  ; 2
    sta    ram_EC                ; 3
    jsr    L11F4                 ; 6
    lda    #$05                  ; 2
    sta    ram_E1                ; 3
    lda    #$08                  ; 2
    jsr    L1DA4                 ; 6
L1A13:
    lda    ram_E1                ; 3
    beq    L1A46                 ; 2³
    lda    ram_D2                ; 3
    and    #$0E                  ; 2
    bne    L1A46                 ; 2³
    dec    ram_E1                ; 5
    bne    L1A3F                 ; 2³
    lda    ram_BA                ; 3
    ora    #$40                  ; 2
    sta    ram_BA                ; 3
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    and    #$07                  ; 2
    cmp    #$07                  ; 2
    bne    L1A3F                 ; 2³
    lda    #$94                  ; 2
    sta    ram_E0                ; 3
    ldx    ram_BE                ; 3
    lda    L1A4C,X               ; 4
    sta    ram_BD                ; 3
    jmp    L1A46                 ; 3

L1A3F:
    ldx    ram_E1                ; 3
    lda    L1A47,X               ; 4
    sta    ram_E0                ; 3
L1A46:
    rts                          ; 6

L1A47:
    .byte $78 ; | XXXX   | $1A47
    .byte $7B ; | XXXX XX| $1A48
    .byte $7E ; | XXXXXX | $1A49
    .byte $82 ; |X     X | $1A4A
    .byte $86 ; |X    XX | $1A4B
L1A4C:
    .byte $9D ; |X  XXX X| $1A4C
    .byte $BD ; |X XXXX X| $1A4D
    .byte $FD ; |XXXXXX X| $1A4E

L1A4F:
    jsr    L1194                 ; 6
    lda    #$00                  ; 2
    sta    ram_ED                ; 3
    ldx    ram_E2                ; 3
    ldy    ram_E3                ; 3
    cpx    #$2E                  ; 2
    bne    L1A62                 ; 2³
    cpy    #$3C                  ; 2
    beq    L1A7A                 ; 2³
L1A62:
    stx    ram_A4                ; 3
    sty    ram_A5                ; 3
    lda    ram_E4                ; 3
    sta    ram_A7                ; 3
    sta    ram_ED                ; 3
    lda    ram_E6                ; 3
    jsr    L1AC1                 ; 6
    lda    #$C6                  ; 2
    sta    ram_A6                ; 3
    lda    ram_D2                ; 3
    lsr                          ; 2
    bcc    L1AB4                 ; 2³
L1A7A:
    ldx    ram_E7                ; 3
    ldy    ram_E8                ; 3
    cpx    #$2E                  ; 2
    bne    L1A86                 ; 2³
    cpy    #$3C                  ; 2
    beq    L1AB4                 ; 2³
L1A86:
    stx    ram_A4                ; 3
    sty    ram_A5                ; 3
    lda    ram_E9                ; 3
    sta    ram_A7                ; 3
    sta    ram_ED                ; 3
    lda    ram_EB                ; 3
    jsr    L1AC1                 ; 6
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    and    #$20                  ; 2
    beq    L1AB4                 ; 2³
    lda    ram_D2                ; 3
    lsr                          ; 2
    bcc    L1AB8                 ; 2³
    lda    #$54                  ; 2
    sta    ram_DD                ; 3
    sta    ram_A6                ; 3
    lda    ram_E9                ; 3
    sta    ram_DE                ; 3
    lda    ram_A4                ; 3
    sta    ram_DB                ; 3
    lda    ram_A5                ; 3
    sta    ram_DC                ; 3
L1AB4:
    lda    ram_ED                ; 3
    bne    L1AC0                 ; 2³
L1AB8:
    lda    #$2E                  ; 2
    sta    ram_A4                ; 3
    lda    #$3C                  ; 2
    sta    ram_A5                ; 3
L1AC0:
    rts                          ; 6

L1AC1:
    and    #$08                  ; 2
    sta    ram_EC                ; 3
    lda    ram_BC                ; 3
    and    #$F7                  ; 2
    ora    ram_EC                ; 3
    sta    ram_BC                ; 3
    rts                          ; 6

L1ACE:
    ldx    ram_BE                ; 3
    lda    ram_D2                ; 3
    and    L1402,X               ; 4
    bne    L1B0B                 ; 2³+1
    ldx    #$00                  ; 2
    jsr    L1B0C                 ; 6
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    and    #$20                  ; 2
    bne    L1B0B                 ; 2³+1
    ldx    #$00                  ; 2
    jsr    L1C81                 ; 6
    beq    L1B06                 ; 2³+1
    lda    ram_E9                ; 3
    jsr    L1D3A                 ; 6
    sbc    ram_EF                ; 3
    bpl    L1AF6                 ; 2³
    eor    #$FF                  ; 2
L1AF6:
    cmp    #$05                  ; 2
    bcs    L1B06                 ; 2³+1
    lda    ram_E5                ; 3
    sbc    ram_EA                ; 3
    bpl    L1B02                 ; 2³
    eor    #$FF                  ; 2
L1B02:
    cmp    #$03                  ; 2
    bcc    L1B0B                 ; 2³
L1B06:
    ldx    #$05                  ; 2
    jsr    L1B0C                 ; 6
L1B0B:
    rts                          ; 6

L1B0C:
    jsr    L1C81                 ; 6
    bne    L1B31                 ; 2³
    lda    ram_D2                ; 3
    and    #$0F                  ; 2
    bne    L1B68                 ; 2³
    lda    #$00                  ; 2
    sta    ram_CC                ; 3
    jsr    L1FC5                 ; 6
    lda    ram_CB                ; 3
    cmp    #$04                  ; 2
    bcs    L1B68                 ; 2³
    and    #$03                  ; 2
    tay                          ; 2
    lda    L1B9C,Y               ; 4
    sta    ram_E4,X              ; 4
    lda    L1BA0,Y               ; 4
    sta    ram_E5,X              ; 4
L1B31:
    ldy    #$FF                  ; 2
    lda    ram_C9                ; 3
    sec                          ; 2
    sbc    ram_E5,X              ; 4
    bmi    L1B40                 ; 2³
    php                          ; 3
    iny                          ; 2
    plp                          ; 4
    beq    L1B40                 ; 2³
    iny                          ; 2
L1B40:
    tya                          ; 2
    clc                          ; 2
    adc    ram_E5,X              ; 4
    cmp    #$28                  ; 2
    bcs    L1B4A                 ; 2³
    lda    #$28                  ; 2
L1B4A:
    sta    ram_E5,X              ; 4
    lda    ram_E6,X              ; 4
    eor    #$01                  ; 2
    sta    ram_E6,X              ; 4
    and    #$01                  ; 2
    asl                          ; 2
    tay                          ; 2
    lda    L1BA4,Y               ; 4
    clc                          ; 2
    adc    ram_E5,X              ; 4
    sta    ram_E2,X              ; 4
    lda    L1BA5,Y               ; 4
    adc    #$00                  ; 2
    sta    ram_E3,X              ; 4
    jsr    L1B69                 ; 6
L1B68:
    rts                          ; 6

L1B69:
    ldy    #$00                  ; 2
    lda    ram_C8                ; 3
    jsr    L1D3A                 ; 6
    sta    ram_EE                ; 3
    lda    ram_E4,X              ; 4
    jsr    L1D3A                 ; 6
    sta    ram_EF                ; 3
    cmp    ram_EE                ; 3
    beq    L1B85                 ; 2³
    php                          ; 3
    ldy    #$F0                  ; 2
    plp                          ; 4
    bcc    L1B85                 ; 2³
    ldy    #$10                  ; 2
L1B85:
    tya                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    and    #$08                  ; 2
    sta    ram_EC                ; 3
    lda    ram_E6,X              ; 4
    and    #$F7                  ; 2
    ora    ram_EC                ; 3
    sta    ram_E6,X              ; 4
    lda    ram_E4,X              ; 4
    jsr    L1D00                 ; 6
    sta    ram_E4,X              ; 4
    rts                          ; 6

L1B9C:
    .byte $32 ; |  XX  X | $1B9C
    .byte $07 ; |     XXX| $1B9D
    .byte $32 ; |  XX  X | $1B9E
    .byte $1C ; |   XXX  | $1B9F
L1BA0:
    .byte $42 ; | X    X | $1BA0
    .byte $42 ; | X    X | $1BA1
    .byte $28 ; |  X X   | $1BA2
    .byte $28 ; |  X X   | $1BA3
L1BA4:
    .byte $47 ; | X   XXX| $1BA4
L1BA5:
    .byte $3E ; |  XXXXX | $1BA5
    .byte $70 ; | XXX    | $1BA6
    .byte $3E ; |  XXXXX | $1BA7

L1BA8:
    ldx    #$00                  ; 2
    jsr    L1BBB                 ; 6
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    and    #$20                  ; 2
    bne    L1BBA                 ; 2³
    ldx    #$05                  ; 2
    jsr    L1BBB                 ; 6
L1BBA:
    rts                          ; 6

L1BBB:
    jsr    L1C81                 ; 6
    beq    L1C19                 ; 2³+1
    lda    ram_DA                ; 3
    and    #$27                  ; 2
    cmp    #$21                  ; 2
    bne    L1BF1                 ; 2³
    lda    ram_AD                ; 3
    jsr    L1C67                 ; 6
    cmp    #$06                  ; 2
    bcs    L1BF1                 ; 2³
    lda    ram_AF                ; 3
    jsr    L1C79                 ; 6
    cmp    #$03                  ; 2
    bcs    L1BF1                 ; 2³
    lda    #$2E                  ; 2
    sta    ram_E2,X              ; 4
    lda    #$3C                  ; 2
    sta    ram_E3,X              ; 4
    jsr    L165F                 ; 6
    lda    #$01                  ; 2
    sta    ram_EC                ; 3
    jsr    L11F4                 ; 6
    lda    #$04                  ; 2
    jsr    L1DA4                 ; 6
L1BF1:
    lda    ram_CA                ; 3
    bne    L1C19                 ; 2³+1
    lda    ram_BA                ; 3
    and    #$10                  ; 2
    bne    L1C19                 ; 2³+1
    lda    ram_C8                ; 3
    jsr    L1C67                 ; 6
    cmp    #$06                  ; 2
    bcs    L1C19                 ; 2³
    lda    ram_C9                ; 3
    clc                          ; 2
    adc    #$01                  ; 2
    jsr    L1C79                 ; 6
    cmp    #$04                  ; 2
    bcs    L1C19                 ; 2³
    lda    #$60                  ; 2
    sta    ram_CA                ; 3
    lda    #$03                  ; 2
    jsr    L1DA4                 ; 6
L1C19:
    rts                          ; 6

L1C1A:
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    and    #$20                  ; 2
    beq    L1C66                 ; 2³
    lda    ram_DA                ; 3
    and    #$67                  ; 2
    cmp    #$62                  ; 2
    bne    L1C4C                 ; 2³
    lda    ram_D9                ; 3
    cmp    #$01                  ; 2
    bne    L1C4C                 ; 2³
    lda    ram_80-1,X            ; 4
    and    #$DF                  ; 2
    sta    ram_80-1,X            ; 4
    lda    #$01                  ; 2
    sta    ram_EC                ; 3
    jsr    L11F4                 ; 6
    lda    #$04                  ; 2
    jsr    L1DA4                 ; 6
    lda    #$2E                  ; 2
    sta    ram_E7                ; 3
    lda    #$3C                  ; 2
    sta    ram_E8                ; 3
    bne    L1C66                 ; 3   always branch

L1C4C:
    ldx    #$05                  ; 2
    lda    ram_C9                ; 3
    jsr    L1C79                 ; 6
    cmp    #$05                  ; 2
    bcs    L1C66                 ; 2³
    lda    ram_C8                ; 3
    jsr    L1C67                 ; 6
    cmp    #$07                  ; 2
    bcs    L1C66                 ; 2³
    lda    ram_BA                ; 3
    ora    #$10                  ; 2
    sta    ram_BA                ; 3
L1C66:
    rts                          ; 6

L1C67:
    jsr    L1D3A                 ; 6
    sta    ram_EE                ; 3
    lda    ram_E4,X              ; 4
    jsr    L1D3A                 ; 6
    sec                          ; 2
    sbc    ram_EE                ; 3
    bpl    L1C78                 ; 2³
    eor    #$FF                  ; 2
L1C78:
    rts                          ; 6

L1C79:
    sec                          ; 2
    sbc    ram_E5,X              ; 4
    bpl    L1C80                 ; 2³
    eor    #$FF                  ; 2
L1C80:
    rts                          ; 6

L1C81:
    lda    ram_E2,X              ; 4
    cmp    #$2E                  ; 2
    bne    L1C8B                 ; 2³
    lda    ram_E3,X              ; 4
    cmp    #$3C                  ; 2
L1C8B:
    rts                          ; 6

L1C8C:
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    and    #$20                  ; 2
    bne    L1CC4                 ; 2³
    bit    ram_BA                ; 3
    bvc    L1CFA                 ; 2³
    lda    ram_BA                ; 3
    and    #$BF                  ; 2
    sta    ram_BA                ; 3
    ldx    #$05                  ; 2
    jsr    L1C81                 ; 6
    bne    L1CFA                 ; 2³
    lda    #$00                  ; 2
    sta    ram_CC                ; 3
    jsr    L1FC5                 ; 6
    lda    ram_CB                ; 3
    cmp    #$40                  ; 2
    bcs    L1CFA                 ; 2³
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    ora    #$20                  ; 2
    sta    ram_80-1,X            ; 4
    lda    #$0A                  ; 2
    sta    ram_E9                ; 3
    lda    #$23                  ; 2
    sta    ram_EA                ; 3
    bne    L1CCD                 ; 3   always branch

L1CC4:
    ldx    ram_BE                ; 3
    lda    ram_D2                ; 3
    and    L1CFB,X               ; 4
    bne    L1CFA                 ; 2³
L1CCD:
    ldx    #$05                  ; 2
    jsr    L1B69                 ; 6
    ldy    ram_EA                ; 3
    tya                          ; 2
    iny                          ; 2
    sec                          ; 2
    sbc    ram_C9                ; 3
    bmi    L1CE1                 ; 2³
    php                          ; 3
    dey                          ; 2
    plp                          ; 4
    beq    L1CE1                 ; 2³
    dey                          ; 2
L1CE1:
    sty    ram_EA                ; 3
    lda    ram_EB                ; 3
    eor    #$01                  ; 2
    sta    ram_EB                ; 3
    and    #$01                  ; 2
    tax                          ; 2
    lda    L1CFE,X               ; 4
    clc                          ; 2
    adc    ram_EA                ; 3
    sta    ram_E7                ; 3
    lda    #$3D                  ; 2
    adc    #$00                  ; 2
    sta    ram_E8                ; 3
L1CFA:
    rts                          ; 6

L1CFB:
    .byte $1F ; |   XXXXX| $1CFB
    .byte $0F ; |    XXXX| $1CFC
    .byte $07 ; |     XXX| $1CFD
L1CFE:
    .byte $7C ; | XXXXX  | $1CFE
    .byte $AE ; |X X XXX | $1CFF

L1D00:
    sty    ram_ED                ; 3
    sta    ram_EC                ; 3
    clc                          ; 2
    adc    ram_ED                ; 3
    ldy    ram_ED                ; 3
    bpl    L1D17                 ; 2³
    ldy    ram_EC                ; 3
    bpl    L1D26                 ; 2³
    tay                          ; 2
    bmi    L1D26                 ; 2³
    clc                          ; 2
    adc    #$F1                  ; 2
    bne    L1D26                 ; 2³
L1D17:
    ldy    ram_EC                ; 3
    bmi    L1D26                 ; 2³
    tay                          ; 2
    and    #$F0                  ; 2
    cmp    #$70                  ; 2
    tya                          ; 2
    bcc    L1D26                 ; 2³
    clc                          ; 2
    adc    #$0F                  ; 2
L1D26:
    tay                          ; 2
    jsr    L1D3A                 ; 6
    cmp    #$23                  ; 2
    bcc    L1D34                 ; 2³
    cmp    #$CD                  ; 2
    bcs    L1D37                 ; 2³
    tya                          ; 2
    rts                          ; 6

L1D34:
    lda    #$32                  ; 2
    rts                          ; 6

L1D37:
    lda    #$9C                  ; 2
    rts                          ; 6

L1D3A:
    sta    ram_EC                ; 3
    eor    #$F0                  ; 2
    clc                          ; 2
    adc    #$70                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    ram_ED                ; 3
    lda    ram_EC                ; 3
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    ora    ram_ED                ; 3
    rts                          ; 6

L1D50:
    lda    #$00                  ; 2
    sta    ram_EE                ; 3
    lda    ram_D0                ; 3
    sta    ram_ED                ; 3
    lda    ram_D1                ; 3
    sta    ram_EC                ; 3
    ldx    #$02                  ; 2
L1D5E:
    txa                          ; 2
    asl                          ; 2
    tay                          ; 2
    lda    ram_EC,X              ; 4
    and    #$0F                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta.wy ram_B5,Y              ; 5
    lda    ram_EC,X              ; 4
    and    #$F0                  ; 2
    lsr                          ; 2
    sta.wy ram_B4,Y              ; 5
    dex                          ; 2
    bpl    L1D5E                 ; 2³
    ldy    #$50                  ; 2
    inx                          ; 2
L1D79:
    lda    ram_B4,X              ; 4
    bne    L1D8D                 ; 2³
    sty    ram_B4,X              ; 4
    cpx    #$04                  ; 2
    beq    L1D8D                 ; 2³
    lda    ram_B5,X              ; 4
    bne    L1D8D                 ; 2³
    sty    ram_B5,X              ; 4
    inx                          ; 2
    inx                          ; 2
    bpl    L1D79                 ; 2³
L1D8D:
    lda    ram_BC                ; 3
    and    #$80                  ; 2
    bne    L1D9D                 ; 2³
    ldx    #$05                  ; 2
L1D95:
    lda    L1D9E,X               ; 4
    sta    ram_B4,X              ; 4
    dex                          ; 2
    bpl    L1D95                 ; 2³
L1D9D:
    rts                          ; 6

L1D9E:
    bvc    L1DF8                 ; 2³
    rts                          ; 6

    .byte $68 ; | XX X   | $1DA1
    .byte $70 ; | XXX    | $1DA2
    .byte $50 ; | X X    | $1DA3

L1DA4:
    sta    ram_EC                ; 3
    txa                          ; 2
    pha                          ; 3
    tya                          ; 2
    pha                          ; 3
    lda    ram_EC                ; 3
    asl                          ; 2
    asl                          ; 2
    tax                          ; 2
    lda    L1E25,X               ; 4
    tay                          ; 2
    lda    L1E23,X               ; 4
    sta.wy ram_D3,Y              ; 5
    lda    L1E24,X               ; 4
    sta.wy ram_D4,Y              ; 5
    lda    #$01                  ; 2
    sta.wy ram_D5,Y              ; 5
    pla                          ; 4
    tay                          ; 2
    pla                          ; 4
    tax                          ; 2
    rts                          ; 6

L1DC9:
    ldx    #$03                  ; 2
L1DCB:
    lda    ram_D3,X              ; 4
    sta    ram_EC                ; 3
    lda    ram_D4,X              ; 4
    sta    ram_ED                ; 3
    ora    ram_EC                ; 3
    beq    L1E1D                 ; 2³+1
    dec    ram_D5,X              ; 6
    bne    L1E1D                 ; 2³+1
    ldy    #$00                  ; 2
    lda    (ram_EC),Y            ; 5
    cmp    #$FF                  ; 2
    bne    L1DF5                 ; 2³
    lda    #$00                  ; 2
    sta    ram_D3,X              ; 4
    sta    ram_D4,X              ; 4
    sta    ram_D5,X              ; 4
    txa                          ; 2
    and    #$01                  ; 2
    tax                          ; 2
    lda    #$00                  ; 2
    sta    AUDV0,X               ; 4
    beq    L1E1D                 ; 3+1   always branch

L1DF5:
    stx    ram_EE                ; 3
    txa                          ; 2
L1DF8:
    and    #$01                  ; 2
    tax                          ; 2
    lda    (ram_EC),Y            ; 5
    sta    AUDC0,X               ; 4
    iny                          ; 2
    lda    (ram_EC),Y            ; 5
    sta    AUDF0,X               ; 4
    iny                          ; 2
    lda    (ram_EC),Y            ; 5
    sta    AUDV0,X               ; 4
    iny                          ; 2
    ldx    ram_EE                ; 3
    lda    (ram_EC),Y            ; 5
    sta    ram_D5,X              ; 4
    lda    ram_D3,X              ; 4
    clc                          ; 2
    adc    #$04                  ; 2
    sta    ram_D3,X              ; 4
    lda    #$00                  ; 2
    adc    ram_D4,X              ; 4
    sta    ram_D4,X              ; 4
L1E1D:
    dex                          ; 2
    dex                          ; 2
    dex                          ; 2
    bpl    L1DCB                 ; 2³+1
    rts                          ; 6

L1E23:
    .byte $63 ; | XX   XX| $1E23
L1E24:
    .byte $1E ; |   XXXX | $1E24
L1E25:
    .byte $00 ; |        | $1E25
    .byte $00 ; |        | $1E26
    .byte $84 ; |X    X  | $1E27
    .byte $1E ; |   XXXX | $1E28
    .byte $00 ; |        | $1E29
    .byte $00 ; |        | $1E2A
    .byte $89 ; |X   X  X| $1E2B
    .byte $1E ; |   XXXX | $1E2C
    .byte $00 ; |        | $1E2D
    .byte $00 ; |        | $1E2E
    .byte $BE ; |X XXXXX | $1E2F
    .byte $1E ; |   XXXX | $1E30
    .byte $03 ; |      XX| $1E31
    .byte $00 ; |        | $1E32
    .byte $CB ; |XX  X XX| $1E33
    .byte $1E ; |   XXXX | $1E34
    .byte $03 ; |      XX| $1E35
    .byte $00 ; |        | $1E36
    .byte $D8 ; |XX XX   | $1E37
    .byte $1E ; |   XXXX | $1E38
    .byte $00 ; |        | $1E39
    .byte $00 ; |        | $1E3A
    .byte $E1 ; |XXX    X| $1E3B
    .byte $1E ; |   XXXX | $1E3C
    .byte $00 ; |        | $1E3D
    .byte $00 ; |        | $1E3E
    .byte $EA ; |XXX X X | $1E3F
    .byte $1E ; |   XXXX | $1E40
    .byte $00 ; |        | $1E41
    .byte $00 ; |        | $1E42
    .byte $07 ; |     XXX| $1E43
    .byte $1F ; |   XXXXX| $1E44
    .byte $03 ; |      XX| $1E45
    .byte $00 ; |        | $1E46
    .byte $20 ; |  X     | $1E47
    .byte $1F ; |   XXXXX| $1E48
    .byte $03 ; |      XX| $1E49
    .byte $00 ; |        | $1E4A
    .byte $2D ; |  X XX X| $1E4B
    .byte $1F ; |   XXXXX| $1E4C
    .byte $03 ; |      XX| $1E4D
    .byte $00 ; |        | $1E4E
    .byte $78 ; | XXXX   | $1E4F
    .byte $1F ; |   XXXXX| $1E50
    .byte $03 ; |      XX| $1E51
    .byte $00 ; |        | $1E52
    .byte $95 ; |X  X X X| $1E53
    .byte $1F ; |   XXXXX| $1E54
    .byte $00 ; |        | $1E55
    .byte $00 ; |        | $1E56
    .byte $A6 ; |X X  XX | $1E57
    .byte $1F ; |   XXXXX| $1E58
    .byte $03 ; |      XX| $1E59
    .byte $00 ; |        | $1E5A
    .byte $AF ; |X X XXXX| $1E5B
    .byte $1F ; |   XXXXX| $1E5C
    .byte $03 ; |      XX| $1E5D
    .byte $00 ; |        | $1E5E
    .byte $B8 ; |X XXX   | $1E5F
    .byte $1F ; |   XXXXX| $1E60
    .byte $03 ; |      XX| $1E61
    .byte $00 ; |        | $1E62
    .byte $08 ; |    X   | $1E63
    .byte $1F ; |   XXXXX| $1E64
    .byte $0F ; |    XXXX| $1E65
    .byte $01 ; |       X| $1E66
    .byte $08 ; |    X   | $1E67
    .byte $1F ; |   XXXXX| $1E68
    .byte $0E ; |    XXX | $1E69
    .byte $01 ; |       X| $1E6A
    .byte $08 ; |    X   | $1E6B
    .byte $1F ; |   XXXXX| $1E6C
    .byte $0D ; |    XX X| $1E6D
    .byte $01 ; |       X| $1E6E
    .byte $08 ; |    X   | $1E6F
    .byte $1F ; |   XXXXX| $1E70
    .byte $0B ; |    X XX| $1E71
    .byte $01 ; |       X| $1E72
    .byte $08 ; |    X   | $1E73
    .byte $1F ; |   XXXXX| $1E74
    .byte $09 ; |    X  X| $1E75
    .byte $01 ; |       X| $1E76
    .byte $08 ; |    X   | $1E77
    .byte $1F ; |   XXXXX| $1E78
    .byte $07 ; |     XXX| $1E79
    .byte $01 ; |       X| $1E7A
    .byte $08 ; |    X   | $1E7B
    .byte $1F ; |   XXXXX| $1E7C
    .byte $05 ; |     X X| $1E7D
    .byte $01 ; |       X| $1E7E
    .byte $08 ; |    X   | $1E7F
    .byte $1F ; |   XXXXX| $1E80
    .byte $03 ; |      XX| $1E81
    .byte $01 ; |       X| $1E82
    .byte $FF ; |XXXXXXXX| $1E83
    .byte $08 ; |    X   | $1E84
    .byte $08 ; |    X   | $1E85
    .byte $04 ; |     X  | $1E86
    .byte $01 ; |       X| $1E87
    .byte $FF ; |XXXXXXXX| $1E88
    .byte $08 ; |    X   | $1E89
    .byte $05 ; |     X X| $1E8A
    .byte $0F ; |    XXXX| $1E8B
    .byte $03 ; |      XX| $1E8C
    .byte $08 ; |    X   | $1E8D
    .byte $07 ; |     XXX| $1E8E
    .byte $0E ; |    XXX | $1E8F
    .byte $03 ; |      XX| $1E90
    .byte $08 ; |    X   | $1E91
    .byte $09 ; |    X  X| $1E92
    .byte $0D ; |    XX X| $1E93
    .byte $03 ; |      XX| $1E94
    .byte $08 ; |    X   | $1E95
    .byte $0B ; |    X XX| $1E96
    .byte $0C ; |    XX  | $1E97
    .byte $03 ; |      XX| $1E98
    .byte $08 ; |    X   | $1E99
    .byte $0D ; |    XX X| $1E9A
    .byte $0B ; |    X XX| $1E9B
    .byte $03 ; |      XX| $1E9C
    .byte $08 ; |    X   | $1E9D
    .byte $0F ; |    XXXX| $1E9E
    .byte $0A ; |    X X | $1E9F
    .byte $03 ; |      XX| $1EA0
    .byte $08 ; |    X   | $1EA1
    .byte $11 ; |   X   X| $1EA2
    .byte $09 ; |    X  X| $1EA3
    .byte $03 ; |      XX| $1EA4
    .byte $08 ; |    X   | $1EA5
    .byte $13 ; |   X  XX| $1EA6
    .byte $08 ; |    X   | $1EA7
    .byte $03 ; |      XX| $1EA8
    .byte $08 ; |    X   | $1EA9
    .byte $15 ; |   X X X| $1EAA
    .byte $07 ; |     XXX| $1EAB
    .byte $03 ; |      XX| $1EAC
    .byte $08 ; |    X   | $1EAD
    .byte $17 ; |   X XXX| $1EAE
    .byte $06 ; |     XX | $1EAF
    .byte $03 ; |      XX| $1EB0
    .byte $08 ; |    X   | $1EB1
    .byte $19 ; |   XX  X| $1EB2
    .byte $05 ; |     X X| $1EB3
    .byte $03 ; |      XX| $1EB4
    .byte $08 ; |    X   | $1EB5
    .byte $1B ; |   XX XX| $1EB6
    .byte $04 ; |     X  | $1EB7
    .byte $03 ; |      XX| $1EB8
    .byte $08 ; |    X   | $1EB9
    .byte $1D ; |   XXX X| $1EBA
    .byte $03 ; |      XX| $1EBB
    .byte $03 ; |      XX| $1EBC
    .byte $FF ; |XXXXXXXX| $1EBD
    .byte $09 ; |    X  X| $1EBE
    .byte $08 ; |    X   | $1EBF
    .byte $08 ; |    X   | $1EC0
    .byte $06 ; |     XX | $1EC1
    .byte $09 ; |    X  X| $1EC2
    .byte $08 ; |    X   | $1EC3
    .byte $00 ; |        | $1EC4
    .byte $04 ; |     X  | $1EC5
    .byte $09 ; |    X  X| $1EC6
    .byte $08 ; |    X   | $1EC7
    .byte $08 ; |    X   | $1EC8
    .byte $05 ; |     X X| $1EC9
    .byte $FF ; |XXXXXXXX| $1ECA
    .byte $0C ; |    XX  | $1ECB
    .byte $13 ; |   X  XX| $1ECC
    .byte $08 ; |    X   | $1ECD
    .byte $02 ; |      X | $1ECE
    .byte $0C ; |    XX  | $1ECF
    .byte $0C ; |    XX  | $1ED0
    .byte $08 ; |    X   | $1ED1
    .byte $02 ; |      X | $1ED2
    .byte $0C ; |    XX  | $1ED3
    .byte $09 ; |    X  X| $1ED4
    .byte $08 ; |    X   | $1ED5
    .byte $02 ; |      X | $1ED6
    .byte $FF ; |XXXXXXXX| $1ED7
    .byte $0C ; |    XX  | $1ED8
    .byte $19 ; |   XX  X| $1ED9
    .byte $08 ; |    X   | $1EDA
    .byte $04 ; |     X  | $1EDB
    .byte $0C ; |    XX  | $1EDC
    .byte $0C ; |    XX  | $1EDD
    .byte $08 ; |    X   | $1EDE
    .byte $02 ; |      X | $1EDF
    .byte $FF ; |XXXXXXXX| $1EE0
    .byte $0C ; |    XX  | $1EE1
    .byte $0C ; |    XX  | $1EE2
    .byte $08 ; |    X   | $1EE3
    .byte $04 ; |     X  | $1EE4
    .byte $0C ; |    XX  | $1EE5
    .byte $19 ; |   XX  X| $1EE6
    .byte $08 ; |    X   | $1EE7
    .byte $02 ; |      X | $1EE8
    .byte $FF ; |XXXXXXXX| $1EE9
    .byte $0C ; |    XX  | $1EEA
    .byte $1F ; |   XXXXX| $1EEB
    .byte $04 ; |     X  | $1EEC
    .byte $09 ; |    X  X| $1EED
    .byte $0C ; |    XX  | $1EEE
    .byte $1C ; |   XXX  | $1EEF
    .byte $04 ; |     X  | $1EF0
    .byte $09 ; |    X  X| $1EF1
    .byte $0C ; |    XX  | $1EF2
    .byte $19 ; |   XX  X| $1EF3
    .byte $04 ; |     X  | $1EF4
    .byte $09 ; |    X  X| $1EF5
    .byte $0C ; |    XX  | $1EF6
    .byte $15 ; |   X X X| $1EF7
    .byte $04 ; |     X  | $1EF8
    .byte $09 ; |    X  X| $1EF9
    .byte $0C ; |    XX  | $1EFA
    .byte $16 ; |   X XX | $1EFB
    .byte $04 ; |     X  | $1EFC
    .byte $09 ; |    X  X| $1EFD
    .byte $0C ; |    XX  | $1EFE
    .byte $1C ; |   XXX  | $1EFF
    .byte $04 ; |     X  | $1F00
    .byte $09 ; |    X  X| $1F01
    .byte $0C ; |    XX  | $1F02
    .byte $1F ; |   XXXXX| $1F03
    .byte $04 ; |     X  | $1F04
    .byte $09 ; |    X  X| $1F05
    .byte $FF ; |XXXXXXXX| $1F06
    .byte $08 ; |    X   | $1F07
    .byte $1C ; |   XXX  | $1F08
    .byte $00 ; |        | $1F09
    .byte $0F ; |    XXXX| $1F0A
    .byte $08 ; |    X   | $1F0B
    .byte $1C ; |   XXX  | $1F0C
    .byte $06 ; |     XX | $1F0D
    .byte $0C ; |    XX  | $1F0E
    .byte $08 ; |    X   | $1F0F
    .byte $1A ; |   XX X | $1F10
    .byte $06 ; |     XX | $1F11
    .byte $0C ; |    XX  | $1F12
    .byte $08 ; |    X   | $1F13
    .byte $18 ; |   XX   | $1F14
    .byte $06 ; |     XX | $1F15
    .byte $0C ; |    XX  | $1F16
    .byte $08 ; |    X   | $1F17
    .byte $16 ; |   X XX | $1F18
    .byte $06 ; |     XX | $1F19
    .byte $0C ; |    XX  | $1F1A
    .byte $08 ; |    X   | $1F1B
    .byte $14 ; |   X X  | $1F1C
    .byte $06 ; |     XX | $1F1D
    .byte $0C ; |    XX  | $1F1E
    .byte $FF ; |XXXXXXXX| $1F1F
    .byte $0C ; |    XX  | $1F20
    .byte $07 ; |     XXX| $1F21
    .byte $08 ; |    X   | $1F22
    .byte $02 ; |      X | $1F23
    .byte $0C ; |    XX  | $1F24
    .byte $03 ; |      XX| $1F25
    .byte $08 ; |    X   | $1F26
    .byte $02 ; |      X | $1F27
    .byte $0C ; |    XX  | $1F28
    .byte $07 ; |     XXX| $1F29
    .byte $08 ; |    X   | $1F2A
    .byte $02 ; |      X | $1F2B
    .byte $FF ; |XXXXXXXX| $1F2C
    .byte $0C ; |    XX  | $1F2D
    .byte $14 ; |   X X  | $1F2E
    .byte $08 ; |    X   | $1F2F
    .byte $1C ; |   XXX  | $1F30
    .byte $0C ; |    XX  | $1F31
    .byte $14 ; |   X X  | $1F32
    .byte $00 ; |        | $1F33
    .byte $01 ; |       X| $1F34
    .byte $0C ; |    XX  | $1F35
    .byte $14 ; |   X X  | $1F36
    .byte $08 ; |    X   | $1F37
    .byte $1C ; |   XXX  | $1F38
    .byte $0C ; |    XX  | $1F39
    .byte $14 ; |   X X  | $1F3A
    .byte $00 ; |        | $1F3B
    .byte $01 ; |       X| $1F3C
    .byte $0C ; |    XX  | $1F3D
    .byte $14 ; |   X X  | $1F3E
    .byte $08 ; |    X   | $1F3F
    .byte $1C ; |   XXX  | $1F40
    .byte $0C ; |    XX  | $1F41
    .byte $11 ; |   X   X| $1F42
    .byte $08 ; |    X   | $1F43
    .byte $1C ; |   XXX  | $1F44
    .byte $0C ; |    XX  | $1F45
    .byte $12 ; |   X  X | $1F46
    .byte $08 ; |    X   | $1F47
    .byte $09 ; |    X  X| $1F48
    .byte $0C ; |    XX  | $1F49
    .byte $12 ; |   X  X | $1F4A
    .byte $00 ; |        | $1F4B
    .byte $01 ; |       X| $1F4C
    .byte $0C ; |    XX  | $1F4D
    .byte $12 ; |   X  X | $1F4E
    .byte $08 ; |    X   | $1F4F
    .byte $13 ; |   X  XX| $1F50
    .byte $0C ; |    XX  | $1F51
    .byte $14 ; |   X X  | $1F52
    .byte $08 ; |    X   | $1F53
    .byte $09 ; |    X  X| $1F54
    .byte $0C ; |    XX  | $1F55
    .byte $14 ; |   X X  | $1F56
    .byte $00 ; |        | $1F57
    .byte $01 ; |       X| $1F58
    .byte $0C ; |    XX  | $1F59
    .byte $14 ; |   X X  | $1F5A
    .byte $08 ; |    X   | $1F5B
    .byte $13 ; |   X  XX| $1F5C
    .byte $0C ; |    XX  | $1F5D
    .byte $15 ; |   X X X| $1F5E
    .byte $08 ; |    X   | $1F5F
    .byte $0A ; |    X X | $1F60
    .byte $0C ; |    XX  | $1F61
    .byte $14 ; |   X X  | $1F62
    .byte $08 ; |    X   | $1F63
    .byte $14 ; |   X X  | $1F64
    .byte $FF ; |XXXXXXXX| $1F65

L1F66:  ; indirect jump
    lda    #$0A                  ; 2
    jsr    L1DA4                 ; 6
    lda    #<L3300               ; 2
    sta    ram_EC                ; 3
    lda    #>L3300               ; 2
    sta    ram_ED                ; 3
    ldy    #$01                  ; 2
    jmp    L1000                 ; 3

    .byte $0C ; |    XX  | $1F78
    .byte $1F ; |   XXXXX| $1F79
    .byte $08 ; |    X   | $1F7A
    .byte $10 ; |   X    | $1F7B
    .byte $0C ; |    XX  | $1F7C
    .byte $17 ; |   X XXX| $1F7D
    .byte $08 ; |    X   | $1F7E
    .byte $10 ; |   X    | $1F7F
    .byte $0C ; |    XX  | $1F80
    .byte $12 ; |   X  X | $1F81
    .byte $08 ; |    X   | $1F82
    .byte $10 ; |   X    | $1F83
    .byte $0C ; |    XX  | $1F84
    .byte $0F ; |    XXXX| $1F85
    .byte $08 ; |    X   | $1F86
    .byte $0E ; |    XXX | $1F87
    .byte $0C ; |    XX  | $1F88
    .byte $12 ; |   X  X | $1F89
    .byte $00 ; |        | $1F8A
    .byte $02 ; |      X | $1F8B
    .byte $0C ; |    XX  | $1F8C
    .byte $12 ; |   X  X | $1F8D
    .byte $08 ; |    X   | $1F8E
    .byte $08 ; |    X   | $1F8F
    .byte $0C ; |    XX  | $1F90
    .byte $0F ; |    XXXX| $1F91
    .byte $08 ; |    X   | $1F92
    .byte $14 ; |   X X  | $1F93
    .byte $FF ; |XXXXXXXX| $1F94
    .byte $08 ; |    X   | $1F95
    .byte $08 ; |    X   | $1F96
    .byte $00 ; |        | $1F97
    .byte $04 ; |     X  | $1F98
    .byte $08 ; |    X   | $1F99
    .byte $08 ; |    X   | $1F9A
    .byte $06 ; |     XX | $1F9B
    .byte $02 ; |      X | $1F9C
    .byte $08 ; |    X   | $1F9D
    .byte $08 ; |    X   | $1F9E
    .byte $00 ; |        | $1F9F
    .byte $06 ; |     XX | $1FA0
    .byte $08 ; |    X   | $1FA1
    .byte $08 ; |    X   | $1FA2
    .byte $06 ; |     XX | $1FA3
    .byte $02 ; |      X | $1FA4
    .byte $FF ; |XXXXXXXX| $1FA5
    .byte $0C ; |    XX  | $1FA6
    .byte $11 ; |   X   X| $1FA7
    .byte $08 ; |    X   | $1FA8
    .byte $04 ; |     X  | $1FA9
    .byte $0C ; |    XX  | $1FAA
    .byte $0B ; |    X XX| $1FAB
    .byte $08 ; |    X   | $1FAC
    .byte $0C ; |    XX  | $1FAD
    .byte $FF ; |XXXXXXXX| $1FAE
    .byte $0C ; |    XX  | $1FAF
    .byte $11 ; |   X   X| $1FB0
    .byte $08 ; |    X   | $1FB1
    .byte $04 ; |     X  | $1FB2
    .byte $0C ; |    XX  | $1FB3
    .byte $16 ; |   X XX | $1FB4
    .byte $08 ; |    X   | $1FB5
    .byte $0C ; |    XX  | $1FB6
    .byte $FF ; |XXXXXXXX| $1FB7
    .byte $0C ; |    XX  | $1FB8
    .byte $1F ; |   XXXXX| $1FB9
    .byte $08 ; |    X   | $1FBA
    .byte $02 ; |      X | $1FBB
    .byte $0C ; |    XX  | $1FBC
    .byte $18 ; |   XX   | $1FBD
    .byte $08 ; |    X   | $1FBE
    .byte $02 ; |      X | $1FBF
    .byte $0C ; |    XX  | $1FC0
    .byte $14 ; |   X X  | $1FC1
    .byte $08 ; |    X   | $1FC2
    .byte $02 ; |      X | $1FC3
    .byte $FF ; |XXXXXXXX| $1FC4

L1FC5:
    lda    ram_CB                ; 3
    bne    L1FCB                 ; 2³
    lda    #$01                  ; 2
L1FCB:
    clc                          ; 2
    adc    ram_CD                ; 3
    sta    ram_CD                ; 3
    lda    #$00                  ; 2
    adc    ram_CE                ; 3
    cmp    #$30                  ; 2
    bcc    L1FDC                 ; 2³
    cmp    #$3A                  ; 2
    bcc    L1FDE                 ; 2³
L1FDC:
    lda    #$30                  ; 2
L1FDE:
    sta    ram_CE                ; 3
    ldy    #$00                  ; 2
    lda    (ram_CD),Y            ; 5
    ldy    ram_CC                ; 3
    beq    L1FF2                 ; 2³
L1FE8:
    cmp    ram_CC                ; 3
    bcc    L1FF2                 ; 2³
    sec                          ; 2
    sbc    ram_CC                ; 3
    jmp    L1FE8                 ; 3

L1FF2:
    sta    ram_CB                ; 3
    rts                          ; 6

    .byte $00 ; |        | $1FF5
    .byte $00 ; |        | $1FF6
    .byte $00 ; |        | $1FF7

    .byte $00 ; |        | $1FF8
    .byte $00 ; |        | $1FF9
    .byte $00 ; |        | $1FFA
    .byte $00 ; |        | $1FFB

       ORG $0FFC
      RORG $1FFC

    .word START_0
  IF SEGA_GENESIS
    .word START_0
  ELSE
    .word 0
  ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      BANK 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       ORG $1000
      RORG $3000

L3000:
    lda    #$03                  ; 2
    sta    BANK_0,Y              ; 5
    jmp.ind (ram_EC)             ; 5

START_1:  ; indirect jump also
    cld                          ; 2
    sei                          ; 2
    ldx    #$FF                  ; 2
    txs                          ; 2
    inx                          ; 2
    txa                          ; 2
L300F:
    sta    VSYNC,X               ; 4
    dex                          ; 2
    bne    L300F                 ; 2³
    jsr    L3FC6                 ; 6
L3017:
    jsr    L306E                 ; 6
    jsr    L3112                 ; 6
    lda    #<L1015               ; 2
    sta    ram_EC                ; 3
    lda    #>L1015               ; 2
    sta    ram_ED                ; 3
    ldy    #$00                  ; 2
    jmp    L3000                 ; 3

L302A:  ; indirect jump
    jsr    L340D                 ; 6
    jsr    L3398                 ; 6
L3030:
    lda    INTIM                 ; 4
    bne    L3030                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_BC                ; 3
    and    #$02                  ; 2
    sta    VBLANK                ; 3
    jsr    L34BC                 ; 6
    lda    #$FF                  ; 2
    ldx    #$1F                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    VBLANK                ; 3
    stx    TIM64T                ; 4
    jsr    L3153                 ; 6
    jsr    L30D7                 ; 6
    jsr    L32DE                 ; 6
    jsr    L3192                 ; 6
    jsr    L3269                 ; 6
    bit    ram_BC                ; 3
    bvs    L3061                 ; 2³
    jsr    L32B2                 ; 6
L3061:
    lda    #<L1075               ; 2
    sta    ram_EC                ; 3
    lda    #>L1075               ; 2
    sta    ram_ED                ; 3
    ldy    #$00                  ; 2
    jmp    L3000                 ; 3

L306E:
    ldx    #$23                  ; 2
    lda    #$00                  ; 2
L3072:
    sta    ram_80,X              ; 4
    dex                          ; 2
    bpl    L3072                 ; 2³
    ldx    ram_BE                ; 3
    lda    L30FE,X               ; 4
    sta    ram_CC                ; 3
    jsr    L3368                 ; 6
    ldx    ram_CB                ; 3
    lda    L3101,X               ; 4
    tax                          ; 2
    lda    #$07                  ; 2
    sta    ram_80-1,X            ; 4
    lda    #$05                  ; 2
    sta    ram_CC                ; 3
    ldx    #$23                  ; 2
L3091:
    lda    ram_80,X              ; 4
    cmp    #$07                  ; 2
    beq    L309F                 ; 2³
    jsr    L3368                 ; 6
    ldy    ram_CB                ; 3
    iny                          ; 2
    sty    ram_80,X              ; 4
L309F:
    dex                          ; 2
    bpl    L3091                 ; 2³
    ldy    #$04                  ; 2
    lda    #$FE                  ; 2
L30A6:
    sta.wy ram_BF,Y              ; 5
    dey                          ; 2
    bpl    L30A6                 ; 2³
    ldy    #$0C                  ; 2
L30AE:
    jsr    L30C1                 ; 6
    lda    ram_80,X              ; 4
    and    #$40                  ; 2
    bne    L30AE                 ; 2³
    lda    ram_80,X              ; 4
    ora    #$40                  ; 2
    sta    ram_80,X              ; 4
    dey                          ; 2
    bpl    L30AE                 ; 2³
    rts                          ; 6

L30C1:
    sty    ram_EC                ; 3
    ldx    ram_BE                ; 3
    lda    L310F,X               ; 4
    sta    ram_CC                ; 3
    jsr    L3368                 ; 6
    ldx    ram_CB                ; 3
    lda    L3FA2,X               ; 4
    tax                          ; 2
    dex                          ; 2
    ldy    ram_EC                ; 3
    rts                          ; 6

L30D7:
    ldy    #$04                  ; 2
L30D9:
    lda.wy ram_BF,Y              ; 4
    cmp    #$FE                  ; 2
    bne    L30FA                 ; 2³
    jsr    L30C1                 ; 6
    lda    ram_80,X              ; 4
    and    #$07                  ; 2
    cmp    #$06                  ; 2
    bcs    L30FA                 ; 2³
    lda    ram_80,X              ; 4
    and    #$78                  ; 2
    ora    #$06                  ; 2
    sta    ram_80,X              ; 4
    inx                          ; 2
    txa                          ; 2
    ora    #$80                  ; 2
    sta.wy ram_BF,Y              ; 5
L30FA:
    dey                          ; 2
    bpl    L30D9                 ; 2³
    rts                          ; 6

L30FE:
    .byte $05 ; |     X X| $30FE
    .byte $09 ; |    X  X| $30FF
    .byte $0D ; |    XX X| $3100
L3101:
    .byte $0C ; |    XX  | $3101
    .byte $10 ; |   X    | $3102
    .byte $11 ; |   X   X| $3103
    .byte $1E ; |   XXXX | $3104
    .byte $22 ; |  X   X | $3105
    .byte $23 ; |  X   XX| $3106
    .byte $0D ; |    XX X| $3107
    .byte $12 ; |   X  X | $3108
    .byte $1F ; |   XXXXX| $3109
    .byte $24 ; |  X  X  | $310A
    .byte $08 ; |    X   | $310B
    .byte $09 ; |    X  X| $310C
    .byte $1A ; |   XX X | $310D
    .byte $1B ; |   XX XX| $310E
L310F:
    .byte $18 ; |   XX   | $310F
    .byte $1E ; |   XXXX | $3110
    .byte $24 ; |  X  X  | $3111

L3112:
    ldx    #$04                  ; 2
    lda    #$FF                  ; 2
L3116:
    sta    ram_EC,X              ; 4
    dex                          ; 2
    bpl    L3116                 ; 2³
    ldx    #$05                  ; 2
    stx    ram_CC                ; 3
    dex                          ; 2
L3120:
    jsr    L3368                 ; 6
    ldy    #$04                  ; 2
L3125:
    lda.wy ram_EC,Y              ; 4
    cmp    ram_CB                ; 3
    beq    L3120                 ; 2³
    dey                          ; 2
    bpl    L3125                 ; 2³
    lda    ram_CB                ; 3
    sta    ram_EC,X              ; 4
    dex                          ; 2
    bpl    L3120                 ; 2³
    inx                          ; 2
    stx    ram_B2                ; 3
    stx    ram_B3                ; 3
    ldx    #$04                  ; 2
L313D:
    asl    ram_B2                ; 5
    rol    ram_B3                ; 5
    asl    ram_B2                ; 5
    rol    ram_B3                ; 5
    asl    ram_B2                ; 5
    rol    ram_B3                ; 5
    lda    ram_B2                ; 3
    ora    ram_EC,X              ; 4
    sta    ram_B2                ; 3
    dex                          ; 2
    bpl    L313D                 ; 2³
    rts                          ; 6

L3153:
    lda    ram_BC                ; 3
    bmi    L3172                 ; 2³
    inc    ram_CD                ; 5
    lda    INPT4 | $30           ; 3  Start Game with firebuttons

  IF SEGA_GENESIS
    AND    INPT1
    BPL    L3163
    LSR    SWCHB

  ELSE
    bpl    L3163                 ; 2³
    lda    SWCHB                 ; 4
    lsr                          ; 2
  ENDIF

    bcs    L318B                 ; 2³
L3163:
    lda    ram_BC                ; 3
    ora    #$80                  ; 2
    sta    ram_BC                ; 3
    lda    #$01                  ; 2
    sta    VBLANK                ; 3
    pla                          ; 4
    pla                          ; 4
    jmp    L3017                 ; 3

L3172:
    lda    ram_BC                ; 3
    and    #$12                  ; 2
    bne    L318B                 ; 2³
    lda    ram_BA                ; 3
    and    #$30                  ; 2
    bne    L318B                 ; 2³
    lda    ram_BC                ; 3
    and    #$BF                  ; 2
    sta    ram_BC                ; 3
    lda    SWCHB                 ; 4
    and    #$08                  ; 2

  IF SEGA_GENESIS
    BNE    L31A6
L318B:
    LDA    ram_BC
    ORA    #$40
    BNE    M31A4  ; always branch

  ELSE
    bne    L3191                 ; 2³
L318B:
    lda    ram_BC                ; 3
    ora    #$40                  ; 2
    sta    ram_BC                ; 3
L3191:
    rts                          ; 6
  ENDIF

L3192:
    lda    ram_BA                ; 3
    and    #$20                  ; 2
    beq    L31A6                 ; 2³
    ldx    ram_A9                ; 3
    bne    L31A7                 ; 2³
    lda    #$27                  ; 2
    sta    ram_A9                ; 3
    lda    ram_BC                ; 3
    ora    #$42                  ; 2
M31A4:
    sta    ram_BC                ; 3
L31A6:
    rts                          ; 6

L31A7:
    dex                          ; 2
    stx    ram_A9                ; 3
    bne    L31A6                 ; 2³
    lda    ram_CF                ; 3
    bne    L31DE                 ; 2³
    ldx    #$08                  ; 2
L31B2:
    lda    L3260,X               ; 4
    sta    ram_E3,X              ; 4
    dex                          ; 2
    bpl    L31B2                 ; 2³
    inx                          ; 2
    stx    ram_E2                ; 3
    lda    #$90                  ; 2
    sta    ram_A8                ; 3
    lda    #$06                  ; 2
    sta    ram_B0                ; 3
    lda    #$E7                  ; 2
    sta    ram_AD                ; 3
    lda    #$37                  ; 2
    sta    ram_C8                ; 3
    lda    ram_AA                ; 3
    bmi    L31D5                 ; 2³
    lda    #$81                  ; 2
    sta    ram_AA                ; 3
L31D5:
    lda    ram_BA                ; 3
    and    #$D8                  ; 2
    sta    ram_BA                ; 3
    jmp    L3244                 ; 3

L31DE:
    lda    #$42                  ; 2
    sta    ram_AF                ; 3
    lda    #$BC                  ; 2
    sta    ram_C8                ; 3
    lda    #$FE                  ; 2
    sta    ram_DB                ; 3
    lda    #$3B                  ; 2
    sta    ram_DC                ; 3
    ldy    #$86                  ; 2
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    bpl    L3202                 ; 2³+1
    ldy    #$94                  ; 2
    lda    ram_80-1,X            ; 4
    and    #$07                  ; 2
    cmp    #$07                  ; 2
    beq    L3202                 ; 2³
    ldy    #$78                  ; 2
L3202:
    sty    ram_E0                ; 3
    lda    #$09                  ; 2
    sta    ram_CC                ; 3
    jsr    L3368                 ; 6
    ldx    ram_CB                ; 3
    lda    L3257,X               ; 4
    sta    ram_B1                ; 3
    lda    #$2E                  ; 2
    sta    ram_A4                ; 3
    sta    ram_E2                ; 3
    sta    ram_E7                ; 3
    lda    #$3C                  ; 2
    sta    ram_A5                ; 3
    sta    ram_E3                ; 3
    sta    ram_E8                ; 3
    lda    #$0A                  ; 2
    sta    ram_E4                ; 3
    lda    #$C6                  ; 2
    sta    ram_A6                ; 3
    ldx    ram_CF                ; 3
    lda    ram_80-1,X            ; 4
    and    #$20                  ; 2
    beq    L323A                 ; 2³
    lda    #$08                  ; 2
    sta    ram_E9                ; 3
    lda    #$28                  ; 2
    sta    ram_EA                ; 3
L323A:
    lda    ram_BA                ; 3
    and    #$D8                  ; 2
    ora    #$01                  ; 2
    ora    #$08                  ; 2
    sta    ram_BA                ; 3
L3244:
    lda    #$42                  ; 2
    sta    ram_C9                ; 3
    lda    #$FF                  ; 2
    sta    ram_AB                ; 3
    lda    #$3D                  ; 2
    sta    ram_AC                ; 3
    lda    ram_BC                ; 3
    and    #$BD                  ; 2
    sta    ram_BC                ; 3
    rts                          ; 6

L3257:
    .byte $2B ; |  X X XX| $3257
    .byte $5B ; | X XX XX| $3258
    .byte $63 ; | XX   XX| $3259
    .byte $6B ; | XX X XX| $325A
    .byte $73 ; | XXX  XX| $325B
    .byte $7B ; | XXXX XX| $325C
    .byte $83 ; |X     XX| $325D
    .byte $8B ; |X   X XX| $325E
    .byte $B7 ; |X XX XXX| $325F
L3260:
    .byte $00 ; |        | $3260
    .byte $00 ; |        | $3261
    .byte $00 ; |        | $3262
    .byte $37 ; |  XX XXX| $3263
    .byte $09 ; |    X  X| $3264
    .byte $C7 ; |XX   XXX| $3265
    .byte $66 ; | XX  XX | $3266
    .byte $9F ; |X  XXXXX| $3267
    .byte $86 ; |X    XX | $3268

L3269:
    lda    ram_BC                ; 3
    and    #$10                  ; 2
    beq    L329F                 ; 2³
    ldx    ram_A9                ; 3
    bne    L327F                 ; 2³
    dex                          ; 2
    stx    ram_A9                ; 3
    lda    #$2E                  ; 2
    sta    ram_C5                ; 3
    lda    #$3C                  ; 2
    sta    ram_C6                ; 3
    rts                          ; 6

L327F:
    dex                          ; 2
    stx    ram_A9                ; 3
    bne    L329F                 ; 2³
    lda    ram_BC                ; 3
    and    #$EF                  ; 2
    sta    ram_BC                ; 3
    lda    #$00                  ; 2
    sta    ram_CA                ; 3
    lda    #$05                  ; 2
    sta    ram_BB                ; 3
    ldx    ram_BE                ; 3
    inx                          ; 2
    cpx    #$03                  ; 2
    stx    ram_BE                ; 3
    bcc    L32A0                 ; 2³
    and    #$7F                  ; 2
    sta    ram_BC                ; 3
L329F:
    rts                          ; 6

L32A0:
    ldx    #$00                  ; 2
    stx    ram_CF                ; 3
    inx                          ; 2
    stx    VBLANK                ; 3
    lda    ram_BA                ; 3
    ora    #$20                  ; 2
    sta    ram_BA                ; 3
    pla                          ; 4
    pla                          ; 4
    jmp    L3017                 ; 3

L32B2:
    lda    ram_D2                ; 3
    and    #$3F                  ; 2
    bne    L32DD                 ; 2³
    lda    ram_CA                ; 3
    beq    L32C5                 ; 2³
    sed                          ; 2
    sec                          ; 2
    sbc    #$01                  ; 2
    cld                          ; 2
    sta    ram_CA                ; 3
    beq    L32D7                 ; 2³
L32C5:
    lda    ram_BA                ; 3
    lsr                          ; 2
    bcc    L32DD                 ; 2³
    lda    ram_A8                ; 3
    beq    L32DD                 ; 2³
    sed                          ; 2
    sec                          ; 2
    sbc    #$01                  ; 2
    cld                          ; 2
    sta    ram_A8                ; 3
    bne    L32DD                 ; 2³
L32D7:
    lda    ram_BA                ; 3
    ora    #$10                  ; 2
    sta    ram_BA                ; 3
L32DD:
    rts                          ; 6

L32DE:
    lda    ram_BA                ; 3
    and    #$10                  ; 2
    beq    L330C                 ; 2³+1
    ldx    ram_A9                ; 3
    bne    L3300                 ; 2³+1
    inx                          ; 2
    stx    ram_D9                ; 3
    lda    #$FF                  ; 2
    sta    ram_AB                ; 3
    lda    #$3D                  ; 2
    sta    ram_AC                ; 3
    lda    #<L1F66               ; 2
    sta    ram_EC                ; 3
    lda    #>L1F66               ; 2
    sta    ram_ED                ; 3
    ldy    #$00                  ; 2
    jmp    L3000                 ; 3

L3300:  ; indirect jump also
    dec    ram_D9                ; 5
    beq    L330D                 ; 2³
    lda    #$2E                  ; 2
    sta    ram_C5                ; 3
    lda    #$3C                  ; 2
    sta    ram_C6                ; 3
L330C:
    rts                          ; 6

L330D:
    ldx    ram_A9                ; 3
    inx                          ; 2
    cpx    #$20                  ; 2
    bcs    L332B                 ; 2³
    stx    ram_A9                ; 3
    txa                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    inx                          ; 2
    stx    ram_D9                ; 3
    lda    #$1E                  ; 2
    clc                          ; 2
    adc    ram_C9                ; 3
    sta    ram_C5                ; 3
    lda    #$00                  ; 2
    adc    #$3C                  ; 2
    sta    ram_C6                ; 3
    rts                          ; 6

L332B:
    dec    ram_C4                ; 5
    bmi    L335F                 ; 2³
    lda    #$00                  ; 2
    sta    ram_DF                ; 3
    lda    ram_DA                ; 3
    cmp    #$04                  ; 2
    bne    L334A                 ; 2³
    ldy    #$04                  ; 2
L333B:
    lda.wy ram_BF,Y              ; 4
    cmp    #$FF                  ; 2
    bne    L3347                 ; 2³
    lda    #$FE                  ; 2
    sta.wy ram_BF,Y              ; 5
L3347:
    dey                          ; 2
    bpl    L333B                 ; 2³
L334A:
    lda    #$00                  ; 2
    sta    ram_DA                ; 3
    sta    ram_CA                ; 3
    sta    ram_CF                ; 3
    lda    #$05                  ; 2
    sta    ram_BB                ; 3
    lda    ram_BA                ; 3
    and    #$EF                  ; 2
    ora    #$20                  ; 2
    sta    ram_BA                ; 3
    rts                          ; 6

L335F:
    inc    ram_C4                ; 5
    lda    ram_BA                ; 3
    and    #$7F                  ; 2
    sta    ram_BA                ; 3
    rts                          ; 6

L3368:
    lda    ram_CB                ; 3
    bne    L336E                 ; 2³
    lda    #$01                  ; 2
L336E:
    clc                          ; 2
    adc    ram_CD                ; 3
    sta    ram_CD                ; 3
    lda    #$00                  ; 2
    adc    ram_CE                ; 3
    cmp    #$30                  ; 2
    bcc    L337F                 ; 2³
    cmp    #$3A                  ; 2
    bcc    L3381                 ; 2³
L337F:
    lda    #$30                  ; 2
L3381:
    sta    ram_CE                ; 3
    ldy    #$00                  ; 2
    lda    (ram_CD),Y            ; 5
    ldy    ram_CC                ; 3
    beq    L3395                 ; 2³
L338B:
    cmp    ram_CC                ; 3
    bcc    L3395                 ; 2³
    sec                          ; 2
    sbc    ram_CC                ; 3
    jmp    L338B                 ; 3

L3395:
    sta    ram_CB                ; 3
    rts                          ; 6

L3398:
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$A7                  ; 2
    sta    HMBL                  ; 3
    and    #$0F                  ; 2
    tax                          ; 2
L33A1:
    dex                          ; 2
    bne    L33A1                 ; 2³
    sta    RESBL                 ; 3
    ldy    #$84                  ; 2
    ldx    #$8C                  ; 2
    lda    ram_BA                ; 3
    and    #$01                  ; 2
    cmp    #$01                  ; 2
    bne    L33B6                 ; 2³
    ldy    #$0F                  ; 2
    ldx    #$00                  ; 2
L33B6:
    stx    COLUBK                ; 3
    sty    ram_F8                ; 3
    sty    COLUP0                ; 3
    sty    COLUP1                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$09                  ; 2
    sta    HMM1                  ; 3
    and    #$0F                  ; 2
    tax                          ; 2
L33C7:
    dex                          ; 2
    bne    L33C7                 ; 2³
    sta    RESM1                 ; 3
    lda    #$2C                  ; 2
    sta    COLUPF                ; 3
    ldx    #$04                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
L33D4:
    dex                          ; 2
    bne    L33D4                 ; 2³
    nop                          ; 2
    sta    RESP0                 ; 3
    sta    RESP1                 ; 3
    lda    #$10                  ; 2
    sta    HMP1                  ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_AD                ; 3
    sta    HMM0                  ; 3
    and    #$0F                  ; 2
    tax                          ; 2
L33E9:
    dex                          ; 2
    bne    L33E9                 ; 2³
    sta    RESM0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    stx    GRP0                  ; 3
    stx    GRP1                  ; 3
    stx    PF0                   ; 3
    stx    PF1                   ; 3
    stx    PF2                   ; 3
    stx    REFP0                 ; 3
    stx    REFP1                 ; 3
    lda    #$21                  ; 2
    sta    CTRLPF                ; 3
    ldx    #$04                  ; 2
    stx    NUSIZ0                ; 3
    stx    NUSIZ1                ; 3
    sta    CXCLR                 ; 3
    rts                          ; 6

L340D:
    ldx    #$06                  ; 2
    lda    #$3F                  ; 2
L3411:
    sta    ram_EF,X              ; 4
    dex                          ; 2
    dex                          ; 2
    bpl    L3411                 ; 2³
    lda    ram_A8                ; 3
    ldx    #$00                  ; 2
    jsr    L343A                 ; 6
    lda    #$50                  ; 2
    sta    ram_F2                ; 3
    sta    ram_F4                ; 3
    lda    ram_CA                ; 3
    beq    L342D                 ; 2³
    ldx    #$04                  ; 2
    jsr    L343A                 ; 6
L342D:
    lda    ram_C4                ; 3
    tax                          ; 2
    lda    L3449,X               ; 4
    sta    ram_F6                ; 3
    lda    #$3B                  ; 2
    sta    ram_F7                ; 3
    rts                          ; 6

L343A:
    tay                          ; 2
    and    #$0F                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    ram_F0,X              ; 4
    tya                          ; 2
    and    #$F0                  ; 2
    lsr                          ; 2
    sta    ram_EE,X              ; 4
    rts                          ; 6

L3449:
    .byte $07 ; |     XXX| $3449
    .byte $0F ; |    XXXX| $344A
    .byte $17 ; |   X XXX| $344B
    .byte $1F ; |   XXXXX| $344C

L344D:
    ldx    #$0A                  ; 2
    ldy    #$05                  ; 2
L3451:
    lda.wy ram_B4,Y              ; 4
    sta    ram_EC,X              ; 4
    lda    #$3F                  ; 2
    sta    ram_ED,X              ; 4
    dey                          ; 2
    dex                          ; 2
    dex                          ; 2
    bpl    L3451                 ; 2³
    sta    HMCLR                 ; 3
    ldx    #$07                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
L3465:
    dex                          ; 2
    bne    L3465                 ; 2³
    nop                          ; 2
    sta    RESP0                 ; 3
    sta    RESP1                 ; 3
    lda    #$10                  ; 2
    sta    HMP1                  ; 3
    ldx    ram_B0                ; 3
    lda    L34AE,X               ; 4
    sta    ram_F8                ; 3
    lda    L34B5,X               ; 4
    sta    ram_F9                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    ldx    #$CA                  ; 2
    lda    ram_BA                ; 3
    and    #$01                  ; 2
    cmp    #$01                  ; 2
    bne    L348D                 ; 2³
    ldx    #$00                  ; 2
L348D:
    stx    COLUBK                ; 3
    lda    #$01                  ; 2
    sta    VDELP0                ; 3
    sta    VDELP1                ; 3
    lda    #$03                  ; 2
    sta    NUSIZ0                ; 3
    sta    NUSIZ1                ; 3
    lda    #$0F                  ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    ldx    ram_BB                ; 3
    lda    L34AE,X               ; 4
    sta    ram_FA                ; 3
    lda    L34B5,X               ; 4
    sta    ram_FB                ; 3
    rts                          ; 6

L34AE:
    .byte $00 ; |        | $34AE
    .byte $10 ; |   X    | $34AF
    .byte $50 ; | X X    | $34B0
    .byte $50 ; | X X    | $34B1
    .byte $50 ; | X X    | $34B2
    .byte $50 ; | X X    | $34B3
    .byte $50 ; | X X    | $34B4
L34B5:
    .byte $00 ; |        | $34B5
    .byte $00 ; |        | $34B6
    .byte $00 ; |        | $34B7
    .byte $80 ; |X       | $34B8
    .byte $A0 ; |X X     | $34B9
    .byte $A8 ; |X X X   | $34BA
    .byte $AA ; |X X X X | $34BB

L34BC:
    ldy    #$07                  ; 2
L34BE:
    lda    (ram_EE),Y            ; 5
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    GRP0                  ; 3
    lda    (ram_F0),Y            ; 5
    sta    GRP1                  ; 3
    lda    #$00                  ; 2
    sta    PF1                   ; 3
    lda    (ram_F2),Y            ; 5
    nop                          ; 2
    nop                          ; 2
    sta    GRP0                  ; 3
    lda    #$44                  ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    lda    (ram_F4),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_F6),Y            ; 5
    sta    PF1                   ; 3
    lda    ram_F8                ; 3
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    dey                          ; 2
    bpl    L34BE                 ; 2³
    iny                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    sty    PF1                   ; 3
    ldy    #$10                  ; 2
    sty    NUSIZ0                ; 3
    sty    NUSIZ1                ; 3
    lda    ram_BA                ; 3
    and    #$01                  ; 2
    cmp    #$01                  ; 2
    beq    L3506                 ; 2³
    jsr    L3578                 ; 6
    jmp    L3509                 ; 3

L3506:
    jsr    L3774                 ; 6
L3509:
    jsr    L344D                 ; 6
    ldx    #$03                  ; 2
L350E:
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_F8                ; 3
    sta    PF0                   ; 3
    lda    #$84                  ; 2
    sta    COLUPF                ; 3
    lda    ram_F9                ; 3
    sta    PF1                   ; 3
    pha                          ; 3
    pla                          ; 4
    nop                          ; 2
    lda    #$00                  ; 2
    sta    REFP0                 ; 3
    sta    REFP1                 ; 3
    lda    #$44                  ; 2
    sta    COLUPF                ; 3
    lda    ram_FA                ; 3
    sta    PF0                   ; 3
    lda    ram_FB                ; 3
    sta    PF1                   ; 3
    dex                          ; 2
    bpl    L350E                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    inx                          ; 2
    stx    PF0                   ; 3
    stx    PF1                   ; 3
    ldy    #$07                  ; 2
    sty    ram_F8                ; 3
L353F:
    ldy    ram_F8                ; 3
    lda    (ram_EC),Y            ; 5
    sta    GRP0                  ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_EE),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_F0),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_F2),Y            ; 5
    sta    ram_F9                ; 3
    lda    (ram_F4),Y            ; 5
    tax                          ; 2
    lda    (ram_F6),Y            ; 5
    tay                          ; 2
    lda    ram_F9                ; 3
    sta    GRP1                  ; 3
    stx    GRP0                  ; 3
    sty    GRP1                  ; 3
    sty    GRP0                  ; 3
    dec    ram_F8                ; 5
    bpl    L353F                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$00                  ; 2
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    sta    VDELP0                ; 3
    sta    VDELP1                ; 3
    sta    NUSIZ0                ; 3
    sta    NUSIZ1                ; 3
    rts                          ; 6

L3578:
    ldx    #$07                  ; 2
    lda    L3B3F,X               ; 4
    tay                          ; 2
    lda    L3B37,X               ; 4
    sta    WSYNC                 ; 3
;---------------------------------------
    sty    PF0                   ; 3
    sta    COLUBK                ; 3
    lda    #$26                  ; 2
    sta    COLUPF                ; 3
    lda    L3B27,X               ; 4
    sta    PF1                   ; 3
    lda    L3B2F,X               ; 4
    sta    PF2                   ; 3
    sta    HMCLR                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_C8                ; 3
    sta    HMP0                  ; 3
    and    #$0F                  ; 2
    tax                          ; 2
L35A0:
    dex                          ; 2
    bne    L35A0                 ; 2³
    sta    RESP0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_E6                ; 3
    sta    HMP1                  ; 3
    and    #$0F                  ; 2
    tax                          ; 2
L35AE:
    dex                          ; 2
    bne    L35AE                 ; 2³
    sta    RESP1                 ; 3
    ldx    #$06                  ; 2
L35B5:
    lda    L3B3F,X               ; 4
    tay                          ; 2
    lda    L3B37,X               ; 4
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    sty    PF0                   ; 3
    sta    COLUBK                ; 3
    lda    L3B27,X               ; 4
    sta    PF1                   ; 3
    lda    L3B2F,X               ; 4
    sta    PF2                   ; 3
    sta    HMCLR                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    dex                          ; 2
    bpl    L35B5                 ; 2³
    lda    #$00                  ; 2
    sta    COLUBK                ; 3
    lda    #$0F                  ; 2
    sta    COLUP0                ; 3
    lda    ram_BA                ; 3
    and    #$08                  ; 2
    sta    REFP0                 ; 3
    lda    #$3C                  ; 2
    sta    ram_EC                ; 3
    sta    ram_F0                ; 3
    lda    #$3C                  ; 2
    sta    ram_ED                ; 3
    sta    ram_F1                ; 3
    lda    #$42                  ; 2
    sta    ram_EF                ; 3
    lda    #$20                  ; 2
    sta    ram_EE                ; 3
    ldx    #$07                  ; 2
    jsr    L3730                 ; 6
    ldy    ram_EE                ; 3
    lda    L3A83,Y               ; 4
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    COLUPF                ; 3
    lda    L3AC5,Y               ; 4
    sta    PF1                   ; 3
    lda    L3AE6,Y               ; 4
    sta    PF2                   ; 3
    lda    ram_C5                ; 3
    sta    ram_F0                ; 3
    lda    ram_C6                ; 3
    sta    ram_F1                ; 3
    ldy    ram_EF                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    lda    (ram_F0),Y            ; 5
    sta    GRP0                  ; 3
    dec    ram_EF                ; 5
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$C8                  ; 2
    sta    COLUP1                ; 3
    lda    #$05                  ; 2
    sta    NUSIZ1                ; 3
    ldx    #$00                  ; 2
    lda    ram_E3                ; 3
    bmi    L363B                 ; 2³
    ldx    #$08                  ; 2
L363B:
    stx    REFP1                 ; 3
    lda    #$3E                  ; 2
    sta    ram_ED                ; 3
    lda    ram_E9                ; 3
    sta    ram_EC                ; 3
    ldy    ram_EF                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    lda    (ram_F0),Y            ; 5
    sta    GRP0                  ; 3
    dec    ram_EE                ; 5
    dec    ram_EF                ; 5
    ldx    #$0A                  ; 2
    jsr    L3730                 ; 6
    ldy    ram_EE                ; 3
    lda    L3A83,Y               ; 4
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    COLUPF                ; 3
    lda    L3AC5,Y               ; 4
    sta    PF1                   ; 3
    lda    L3AE6,Y               ; 4
    sta    PF2                   ; 3
    ldx    #$00                  ; 2
    lda    ram_E4                ; 3
    bmi    L3675                 ; 2³
    ldx    #$08                  ; 2
L3675:
    stx    REFP1                 ; 3
    ldy    ram_EF                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_F0),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    lda    ram_EA                ; 3
    sta    ram_EC                ; 3
    dec    ram_EF                ; 5
    sta    HMCLR                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_E7                ; 3
    sta    HMP1                  ; 3
    and    #$0F                  ; 2
    tax                          ; 2
L3694:
    dex                          ; 2
    bne    L3694                 ; 2³
    sta    RESP1                 ; 3
    ldy    ram_EF                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    (ram_F0),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_EC),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    dec    ram_EE                ; 5
    dec    ram_EF                ; 5
    ldx    #$06                  ; 2
    jsr    L3730                 ; 6
    ldy    ram_EE                ; 3
    lda    L3A83,Y               ; 4
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    COLUPF                ; 3
    lda    L3AA4,Y               ; 4
    sta    PF0                   ; 3
    lda    L3AC5,Y               ; 4
    sta    PF1                   ; 3
    lda    L3AE6,Y               ; 4
    sta    PF2                   ; 3
    lda    ram_EB                ; 3
    sta    ram_EC                ; 3
    ldy    ram_EF                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_F0),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_EC),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    dec    ram_EF                ; 5
    sta    HMCLR                 ; 3
    ldx    #$00                  ; 2
    lda    ram_E5                ; 3
    bmi    L36EC                 ; 2³
    ldx    #$08                  ; 2
L36EC:
    stx    REFP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_E8                ; 3
    sta    HMP1                  ; 3
    and    #$0F                  ; 2
    tax                          ; 2
L36F7:
    dex                          ; 2
    bne    L36F7                 ; 2³
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    (ram_F0),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_EC),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    dec    ram_EE                ; 5
    dec    ram_EF                ; 5
    ldx    #$03                  ; 2
    jsr    L3730                 ; 6
    lda    #$CA                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    COLUPF                ; 3
    sta    COLUBK                ; 3
    lda    #$00                  ; 2
    sta    PF0                   ; 3
    sta    PF1                   ; 3
    sta    PF2                   ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    sta    GRP0                  ; 3
    sta    ENAM0                 ; 3
    rts                          ; 6

L3730:
    ldy    ram_EE                ; 3
    lda    L3A83,Y               ; 4
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    COLUPF                ; 3
    lda    L3AA4,Y               ; 4
    sta    PF0                   ; 3
    lda    L3AC5,Y               ; 4
    sta    PF1                   ; 3
    lda    L3AE6,Y               ; 4
    sta    PF2                   ; 3
    ldy    ram_EF                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_F0),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_EC),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    dec    ram_EF                ; 5
    sta    WSYNC                 ; 3
;---------------------------------------
    ldy    ram_EF                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_F0),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_EC),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    dec    ram_EF                ; 5
    dec    ram_EE                ; 5
    dex                          ; 2
    bpl    L3730                 ; 2³
    rts                          ; 6

L3774:
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$06                  ; 2
    sta    COLUBK                ; 3
    lda    #$00                  ; 2
    sta    COLUPF                ; 3
    ldx    #$06                  ; 2
L378E:
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    L3B3F,X               ; 4
    sta    PF0                   ; 3
    lda    L3B47,X               ; 4
    sta    PF1                   ; 3
    lda    L3B4E,X               ; 4
    sta    PF2                   ; 3
    lda    ram_BA                ; 3
    and    #$08                  ; 2
    sta    REFP0                 ; 3
    ldy    ram_CF                ; 3
    lda.wy ram_80-1,Y            ; 4
    and    #$20                  ; 2
    tay                          ; 2
    beq    L37B8                 ; 2³
    ldy    #$00                  ; 2
    lda    ram_D2                ; 3
    lsr                          ; 2
    bcs    L37B8                 ; 2³
    ldy    ram_BC                ; 3
L37B8:
    sty    REFP1                 ; 3
    sta    HMCLR                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_C8                ; 3
    sta    HMP0                  ; 3
    and    #$0F                  ; 2
    tay                          ; 2
L37C5:
    dey                          ; 2
    bne    L37C5                 ; 2³
    sta    RESP0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_DE                ; 3
    sta    HMP1                  ; 3
    and    #$0F                  ; 2
    tay                          ; 2
L37D3:
    dey                          ; 2
    bne    L37D3                 ; 2³
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_DA                ; 3
    and    #$07                  ; 2
    tay                          ; 2
    lda    L3A7E,Y               ; 4
    sta    COLUP0                ; 3
    lda    ram_DD                ; 3
    sta    COLUP1                ; 3
    dex                          ; 2
    bpl    L378E                 ; 2³
    lda    #$3F                  ; 2
    sta    ram_EF                ; 3
    lda    ram_E0                ; 3
    sta    ram_EE                ; 3
    lda    #$0D                  ; 2
    sta    ram_EC                ; 3
    lda    #$06                  ; 2
    sta    ram_ED                ; 3
L37FB:
    ldy    ram_EC                ; 3
    ldx    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    L3B55,X               ; 4
    sta    PF0                   ; 3
    lda    L3B5C,X               ; 4
    sta    PF1                   ; 3
    sta    ram_F0                ; 3
    lda    L3B63,X               ; 4
    sta    PF2                   ; 3
    pha                          ; 3
    pla                          ; 4
    lda    (ram_EE),Y            ; 5
    sta    PF1                   ; 3
    dec    ram_EC                ; 5
    sta    ram_F1                ; 3
    ldx    #$02                  ; 2
L381E:
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_F0                ; 3
    sta    PF1                   ; 3
    ldy    ram_CF                ; 3
    lda.wy ram_80-1,Y            ; 4
    and    #$87                  ; 2
    cmp    #$87                  ; 2
    beq    L3841                 ; 2³
    ldy    #$06                  ; 2
    lda    (ram_EE),Y            ; 5
    sta    ram_F2                ; 3
    dey                          ; 2
    lda    (ram_EE),Y            ; 5
    sta    ram_F3                ; 3
    lda    ram_F1                ; 3
    sta    PF1                   ; 3
    jmp    L3851                 ; 3

L3841:
    lda    ram_BD                ; 3
    and    #$A9                  ; 2
    sta    ram_F2                ; 3
    lda    ram_BD                ; 3
    and    #$D5                  ; 2
    sta    ram_F3                ; 3
    lda    ram_F1                ; 3
    sta    PF1                   ; 3
L3851:
    dex                          ; 2
    bpl    L381E                 ; 2³
    dec    ram_ED                ; 5
    bpl    L37FB                 ; 2³+1
    lda    #$2D                  ; 2
    sta    ram_ED                ; 3
    ldx    #$01                  ; 2
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    L3B6A,X               ; 4
    sta    PF0                   ; 3
    lda    L3B6C,X               ; 4
    sta    PF1                   ; 3
    sta    ram_F0                ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    lda    L3B6E,X               ; 4
    sta    PF2                   ; 3
    nop                          ; 2
    lda    ram_F2                ; 3
    sta    PF1                   ; 3
    sta    ram_F1                ; 3
    jsr    L3A0D                 ; 6
    dec    ram_EC                ; 5
    ldx    #$00                  ; 2
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    L3B6A,X               ; 4
    sta    PF0                   ; 3
    lda    L3B6C,X               ; 4
    sta    PF1                   ; 3
    sta    ram_F0                ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    lda    L3B6E,X               ; 4
    sta    PF2                   ; 3
    nop                          ; 2
    lda    ram_F3                ; 3
    sta    PF1                   ; 3
    sta    ram_F1                ; 3
    jsr    L3A0D                 ; 6
    dec    ram_EC                ; 5
    ldx    #$04                  ; 2
L38AE:
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    L3B70,X               ; 4
    sta    PF0                   ; 3
    lda    L3B75,X               ; 4
    sta    PF1                   ; 3
    sta    ram_F0                ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    lda    L3B7A,X               ; 4
    sta    PF2                   ; 3
    ldy    ram_EC                ; 3
    lda    (ram_EE),Y            ; 5
    sta    PF1                   ; 3
    sta    ram_F1                ; 3
    dec    ram_EC                ; 5
    ldy    ram_ED                ; 3
    jsr    L3A0D                 ; 6
    dex                          ; 2
    bpl    L38AE                 ; 2³
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    lda    #$08                  ; 2
    sta    COLUBK                ; 3
    lda    #$00                  ; 2
    sta    PF0                   ; 3
    sta    PF1                   ; 3
    sta    PF2                   ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_C5),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_DB),Y            ; 5
    sta    GRP1                  ; 3
    dec    ram_ED                ; 5
    lda    ram_BC                ; 3
    sta    REFP1                 ; 3
    lda    ram_A6                ; 3
    sta    COLUP1                ; 3
    sta    HMCLR                 ; 3
    pha                          ; 3
    pla                          ; 4
    lda    #$3B                  ; 2
    sta    ram_F1                ; 3
    lda    #$7F                  ; 2
    sta    ram_F0                ; 3
    ldy    ram_ED                ; 3
    nop                          ; 2
    lda    #$00                  ; 2
    sta    GRP1                  ; 3
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_A7                ; 3
    sta    HMP1                  ; 3
    and    #$0F                  ; 2
    tax                          ; 2
L3921:
    dex                          ; 2
    bne    L3921                 ; 2³
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    (ram_C5),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_A4),Y            ; 5
    sta    GRP1                  ; 3
    dec    ram_ED                ; 5
    ldx    #$3B                  ; 2
    ldy    #$7F                  ; 2
    lda    ram_BF                ; 3
    bmi    L3942                 ; 2³
    cmp    ram_CF                ; 3
    bne    L3942                 ; 2³
    ldy    #$8B                  ; 2
L3942:
    stx    ram_EF                ; 3
    sty    ram_EE                ; 3
    lda    #$44                  ; 2
    sta    COLUPF                ; 3
    jsr    L3A55                 ; 6
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_C5),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_A4),Y            ; 5
    sta    GRP1                  ; 3
    dec    ram_ED                ; 5
    ldy    #$7F                  ; 2
    lda    ram_C0                ; 3
    bmi    L3967                 ; 2³
    cmp    ram_CF                ; 3
    bne    L3967                 ; 2³
    ldy    #$8B                  ; 2
L3967:
    sty    ram_EE                ; 3
    lda    #$84                  ; 2
    sta    COLUPF                ; 3
    jsr    L3A55                 ; 6
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_C5),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_A4),Y            ; 5
    sta    GRP1                  ; 3
    dec    ram_ED                ; 5
    ldy    #$7F                  ; 2
    lda    ram_C1                ; 3
    bmi    L398A                 ; 2³
    cmp    ram_CF                ; 3
    bne    L398A                 ; 2³
    ldy    #$8B                  ; 2
L398A:
    sty    ram_EE                ; 3
    lda    #$C8                  ; 2
    sta    COLUPF                ; 3
    jsr    L3A55                 ; 6
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_C5),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_A4),Y            ; 5
    sta    GRP1                  ; 3
    dec    ram_ED                ; 5
    lda    #$7F                  ; 2
    ldy    ram_CF                ; 3
    bmi    L39AD                 ; 2³
    cpy    ram_C2                ; 3
    bne    L39AD                 ; 2³
    lda    #$8B                  ; 2
L39AD:
    sta    ram_EE                ; 3
    lda    #$26                  ; 2
    sta    COLUPF                ; 3
    lda.wy ram_80-1,Y            ; 4
    and    #$40                  ; 2
    beq    L39BE                 ; 2³
    lda    #$85                  ; 2
    sta    ram_F0                ; 3
L39BE:
    jsr    L3A55                 ; 6
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_C5),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_A4),Y            ; 5
    sta    GRP1                  ; 3
    dec    ram_ED                ; 5
    ldy    #$7F                  ; 2
    sty    ram_F0                ; 3
    lda    ram_C3                ; 3
    bmi    L39DD                 ; 2³
    cmp    ram_CF                ; 3
    bne    L39DD                 ; 2³
    ldy    #$8B                  ; 2
L39DD:
    sty    ram_EE                ; 3
    lda    #$56                  ; 2
    sta    COLUPF                ; 3
    jsr    L3A55                 ; 6
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$00                  ; 2
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    sta    GRP0                  ; 3
    sta    ENAM0                 ; 3
    sta    ENAM1                 ; 3
    sta    ENABL                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    COLUBK                ; 3
    sta    COLUPF                ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    rts                          ; 6

L3A0D:
    lda    (ram_C5),Y            ; 5
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    GRP0                  ; 3
    lda    (ram_DB),Y            ; 5
    sta    GRP1                  ; 3
    lda    ram_F0                ; 3
    sta    PF1                   ; 3
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    lda    ram_F1                ; 3
    sta    PF1                   ; 3
    dec    ram_ED                ; 5
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    lda    ram_F0                ; 3
    sta    PF1                   ; 3
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    lda    ram_F1                ; 3
    sta    PF1                   ; 3
    ldy    ram_ED                ; 3
    lda    (ram_C5),Y            ; 5
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    GRP0                  ; 3
    lda    (ram_DB),Y            ; 5
    sta    GRP1                  ; 3
    lda    ram_F0                ; 3
    sta    PF1                   ; 3
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    nop                          ; 2
    lda    ram_F1                ; 3
    sta    PF1                   ; 3
    dec    ram_ED                ; 5
    rts                          ; 6

L3A55:
    ldx    #$05                  ; 2
L3A57:
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_AB),Y            ; 5
    sta    ENAM0                 ; 3
    txa                          ; 2
    tay                          ; 2
    lda    (ram_EE),Y            ; 5
    sta    ENABL                 ; 3
    lda    (ram_F0),Y            ; 5
    sta    ENAM1                 ; 3
    dex                          ; 2
    bmi    L3A7D                 ; 2³
    ldy    ram_ED                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_C5),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_A4),Y            ; 5
    sta    GRP1                  ; 3
    dec    ram_ED                ; 5
    jmp    L3A57                 ; 3

L3A7D:
    rts                          ; 6

L3A7E:
    .byte $0F ; |    XXXX| $3A7E
    .byte $84 ; |X    X  | $3A7F
    .byte $44 ; | X   X  | $3A80
    .byte $C8 ; |XX  X   | $3A81
    .byte $2C ; |  X XX  | $3A82
L3A83:
    .byte $2C ; |  X XX  | $3A83
    .byte $28 ; |  X X   | $3A84
    .byte $2C ; |  X XX  | $3A85
    .byte $2C ; |  X XX  | $3A86
    .byte $2C ; |  X XX  | $3A87
    .byte $28 ; |  X X   | $3A88
    .byte $2C ; |  X XX  | $3A89
    .byte $2C ; |  X XX  | $3A8A
    .byte $2C ; |  X XX  | $3A8B
    .byte $28 ; |  X X   | $3A8C
    .byte $2C ; |  X XX  | $3A8D
    .byte $2C ; |  X XX  | $3A8E
    .byte $2C ; |  X XX  | $3A8F
    .byte $28 ; |  X X   | $3A90
    .byte $2C ; |  X XX  | $3A91
    .byte $2C ; |  X XX  | $3A92
    .byte $2C ; |  X XX  | $3A93
    .byte $28 ; |  X X   | $3A94
    .byte $2C ; |  X XX  | $3A95
    .byte $2C ; |  X XX  | $3A96
    .byte $2C ; |  X XX  | $3A97
    .byte $2C ; |  X XX  | $3A98
    .byte $2C ; |  X XX  | $3A99
    .byte $28 ; |  X X   | $3A9A
    .byte $2C ; |  X XX  | $3A9B
    .byte $2C ; |  X XX  | $3A9C
    .byte $28 ; |  X X   | $3A9D
    .byte $2C ; |  X XX  | $3A9E
    .byte $2C ; |  X XX  | $3A9F
    .byte $26 ; |  X  XX | $3AA0
    .byte $26 ; |  X  XX | $3AA1
    .byte $26 ; |  X  XX | $3AA2
    .byte $26 ; |  X  XX | $3AA3
L3AA4:
    .byte $C0 ; |XX      | $3AA4
    .byte $C0 ; |XX      | $3AA5
    .byte $00 ; |        | $3AA6
    .byte $00 ; |        | $3AA7
    .byte $00 ; |        | $3AA8
    .byte $00 ; |        | $3AA9
    .byte $00 ; |        | $3AAA
    .byte $00 ; |        | $3AAB
    .byte $00 ; |        | $3AAC
    .byte $00 ; |        | $3AAD
    .byte $00 ; |        | $3AAE
    .byte $00 ; |        | $3AAF
    .byte $00 ; |        | $3AB0
    .byte $00 ; |        | $3AB1
    .byte $00 ; |        | $3AB2
    .byte $00 ; |        | $3AB3
    .byte $00 ; |        | $3AB4
    .byte $00 ; |        | $3AB5
    .byte $00 ; |        | $3AB6
    .byte $00 ; |        | $3AB7
    .byte $00 ; |        | $3AB8
    .byte $00 ; |        | $3AB9
    .byte $00 ; |        | $3ABA
    .byte $00 ; |        | $3ABB
    .byte $00 ; |        | $3ABC
    .byte $00 ; |        | $3ABD
    .byte $00 ; |        | $3ABE
    .byte $00 ; |        | $3ABF
    .byte $00 ; |        | $3AC0
    .byte $00 ; |        | $3AC1
    .byte $00 ; |        | $3AC2
    .byte $80 ; |X       | $3AC3
    .byte $00 ; |        | $3AC4
L3AC5:
    .byte $AA ; |X X X X | $3AC5
    .byte $FF ; |XXXXXXXX| $3AC6
    .byte $FF ; |XXXXXXXX| $3AC7
    .byte $FB ; |XXXXX XX| $3AC8
    .byte $6F ; | XX XXXX| $3AC9
    .byte $7F ; | XXXXXXX| $3ACA
    .byte $1B ; |   XX XX| $3ACB
    .byte $1F ; |   XXXXX| $3ACC
    .byte $0F ; |    XXXX| $3ACD
    .byte $0F ; |    XXXX| $3ACE
    .byte $02 ; |      X | $3ACF
    .byte $03 ; |      XX| $3AD0
    .byte $01 ; |       X| $3AD1
    .byte $01 ; |       X| $3AD2
    .byte $00 ; |        | $3AD3
    .byte $00 ; |        | $3AD4
    .byte $00 ; |        | $3AD5
    .byte $00 ; |        | $3AD6
    .byte $00 ; |        | $3AD7
    .byte $00 ; |        | $3AD8
    .byte $00 ; |        | $3AD9
    .byte $00 ; |        | $3ADA
    .byte $00 ; |        | $3ADB
    .byte $00 ; |        | $3ADC
    .byte $00 ; |        | $3ADD
    .byte $00 ; |        | $3ADE
    .byte $00 ; |        | $3ADF
    .byte $00 ; |        | $3AE0
    .byte $00 ; |        | $3AE1
    .byte $00 ; |        | $3AE2
    .byte $00 ; |        | $3AE3
    .byte $FF ; |XXXXXXXX| $3AE4
    .byte $FF ; |XXXXXXXX| $3AE5
L3AE6:
    .byte $FD ; |XXXXXX X| $3AE6
    .byte $FF ; |XXXXXXXX| $3AE7
    .byte $FF ; |XXXXXXXX| $3AE8
    .byte $03 ; |      XX| $3AE9
    .byte $FE ; |XXXXXXX | $3AEA
    .byte $FF ; |XXXXXXXX| $3AEB
    .byte $FF ; |XXXXXXXX| $3AEC
    .byte $06 ; |     XX | $3AED
    .byte $FF ; |XXXXXXXX| $3AEE
    .byte $FF ; |XXXXXXXX| $3AEF
    .byte $FF ; |XXXXXXXX| $3AF0
    .byte $0D ; |    XX X| $3AF1
    .byte $FF ; |XXXXXXXX| $3AF2
    .byte $FF ; |XXXXXXXX| $3AF3
    .byte $FA ; |XXXXX X | $3AF4
    .byte $16 ; |   X XX | $3AF5
    .byte $FC ; |XXXXXX  | $3AF6
    .byte $FC ; |XXXXXX  | $3AF7
    .byte $F0 ; |XXXX    | $3AF8
    .byte $30 ; |  XX    | $3AF9
    .byte $F0 ; |XXXX    | $3AFA
    .byte $10 ; |   X    | $3AFB
    .byte $F0 ; |XXXX    | $3AFC
    .byte $F0 ; |XXXX    | $3AFD
    .byte $20 ; |  X     | $3AFE
    .byte $60 ; | XX     | $3AFF
    .byte $E0 ; |XXX     | $3B00
    .byte $40 ; | X      | $3B01
    .byte $C0 ; |XX      | $3B02
    .byte $00 ; |        | $3B03
    .byte $00 ; |        | $3B04
    .byte $1F ; |   XXXXX| $3B05
    .byte $0F ; |    XXXX| $3B06
    .byte $00 ; |        | $3B07
    .byte $00 ; |        | $3B08
    .byte $00 ; |        | $3B09
    .byte $00 ; |        | $3B0A
    .byte $00 ; |        | $3B0B
    .byte $00 ; |        | $3B0C
    .byte $00 ; |        | $3B0D
    .byte $00 ; |        | $3B0E
    .byte $00 ; |        | $3B0F
    .byte $00 ; |        | $3B10
    .byte $80 ; |X       | $3B11
    .byte $80 ; |X       | $3B12
    .byte $80 ; |X       | $3B13
    .byte $80 ; |X       | $3B14
    .byte $00 ; |        | $3B15
    .byte $00 ; |        | $3B16
    .byte $00 ; |        | $3B17
    .byte $00 ; |        | $3B18
    .byte $A0 ; |X X     | $3B19
    .byte $A0 ; |X X     | $3B1A
    .byte $A0 ; |X X     | $3B1B
    .byte $A0 ; |X X     | $3B1C
    .byte $00 ; |        | $3B1D
    .byte $00 ; |        | $3B1E
    .byte $00 ; |        | $3B1F
    .byte $00 ; |        | $3B20
    .byte $A8 ; |X X X   | $3B21
    .byte $A8 ; |X X X   | $3B22
    .byte $A8 ; |X X X   | $3B23
    .byte $A8 ; |X X X   | $3B24
    .byte $00 ; |        | $3B25
    .byte $00 ; |        | $3B26
L3B27:
    .byte $7F ; | XXXXXXX| $3B27
    .byte $3F ; |  XXXXXX| $3B28
    .byte $1F ; |   XXXXX| $3B29
    .byte $0F ; |    XXXX| $3B2A
    .byte $06 ; |     XX | $3B2B
    .byte $00 ; |        | $3B2C
    .byte $00 ; |        | $3B2D
    .byte $00 ; |        | $3B2E
L3B2F:
    .byte $07 ; |     XXX| $3B2F
    .byte $03 ; |      XX| $3B30
    .byte $01 ; |       X| $3B31
    .byte $00 ; |        | $3B32
    .byte $00 ; |        | $3B33
    .byte $00 ; |        | $3B34
    .byte $00 ; |        | $3B35
    .byte $00 ; |        | $3B36
L3B37:
    .byte $80 ; |X       | $3B37
    .byte $80 ; |X       | $3B38
    .byte $82 ; |X     X | $3B39
    .byte $84 ; |X    X  | $3B3A
    .byte $86 ; |X    XX | $3B3B
    .byte $88 ; |X   X   | $3B3C
    .byte $8A ; |X   X X | $3B3D
    .byte $8C ; |X   XX  | $3B3E
L3B3F:
    .byte $00 ; |        | $3B3F
    .byte $00 ; |        | $3B40
    .byte $00 ; |        | $3B41
    .byte $00 ; |        | $3B42
    .byte $00 ; |        | $3B43
    .byte $00 ; |        | $3B44
    .byte $00 ; |        | $3B45
    .byte $00 ; |        | $3B46
L3B47:
    .byte $42 ; | X    X | $3B47
    .byte $42 ; | X    X | $3B48
    .byte $42 ; | X    X | $3B49
    .byte $42 ; | X    X | $3B4A
    .byte $7F ; | XXXXXXX| $3B4B
    .byte $40 ; | X      | $3B4C
    .byte $40 ; | X      | $3B4D
L3B4E:
    .byte $40 ; | X      | $3B4E
    .byte $40 ; | X      | $3B4F
    .byte $40 ; | X      | $3B50
    .byte $40 ; | X      | $3B51
    .byte $41 ; | X     X| $3B52
    .byte $7F ; | XXXXXXX| $3B53
    .byte $41 ; | X     X| $3B54
L3B55:
    .byte $20 ; |  X     | $3B55
    .byte $20 ; |  X     | $3B56
    .byte $20 ; |  X     | $3B57
    .byte $20 ; |  X     | $3B58
    .byte $20 ; |  X     | $3B59
    .byte $20 ; |  X     | $3B5A
    .byte $F0 ; |XXXX    | $3B5B
L3B5C:
    .byte $FF ; |XXXXXXXX| $3B5C
    .byte $FF ; |XXXXXXXX| $3B5D
    .byte $FF ; |XXXXXXXX| $3B5E
    .byte $FF ; |XXXXXXXX| $3B5F
    .byte $7E ; | XXXXXX | $3B60
    .byte $3C ; |  XXXX  | $3B61
    .byte $DB ; |XX XX XX| $3B62
L3B63:
    .byte $08 ; |    X   | $3B63
    .byte $08 ; |    X   | $3B64
    .byte $08 ; |    X   | $3B65
    .byte $08 ; |    X   | $3B66
    .byte $08 ; |    X   | $3B67
    .byte $08 ; |    X   | $3B68
    .byte $FF ; |XXXXXXXX| $3B69
L3B6A:
    .byte $00 ; |        | $3B6A
    .byte $F0 ; |XXXX    | $3B6B
L3B6C:
    .byte $FF ; |XXXXXXXX| $3B6C
    .byte $FF ; |XXXXXXXX| $3B6D
L3B6E:
    .byte $20 ; |  X     | $3B6E
    .byte $FF ; |XXXXXXXX| $3B6F
L3B70:
    .byte $00 ; |        | $3B70
    .byte $00 ; |        | $3B71
    .byte $00 ; |        | $3B72
    .byte $00 ; |        | $3B73
    .byte $00 ; |        | $3B74
L3B75:
    .byte $FF ; |XXXXXXXX| $3B75
    .byte $FF ; |XXXXXXXX| $3B76
    .byte $FF ; |XXXXXXXX| $3B77
    .byte $FF ; |XXXXXXXX| $3B78
    .byte $FF ; |XXXXXXXX| $3B79
L3B7A:
    .byte $20 ; |  X     | $3B7A
    .byte $20 ; |  X     | $3B7B
    .byte $20 ; |  X     | $3B7C
    .byte $20 ; |  X     | $3B7D
    .byte $20 ; |  X     | $3B7E
    .byte $00 ; |        | $3B7F
    .byte $00 ; |        | $3B80
    .byte $00 ; |        | $3B81
    .byte $00 ; |        | $3B82
    .byte $00 ; |        | $3B83
    .byte $00 ; |        | $3B84
    .byte $00 ; |        | $3B85
    .byte $02 ; |      X | $3B86
    .byte $02 ; |      X | $3B87
    .byte $02 ; |      X | $3B88
    .byte $02 ; |      X | $3B89
    .byte $00 ; |        | $3B8A
    .byte $00 ; |        | $3B8B
    .byte $00 ; |        | $3B8C
    .byte $02 ; |      X | $3B8D
    .byte $02 ; |      X | $3B8E
    .byte $00 ; |        | $3B8F
    .byte $00 ; |        | $3B90
    .byte $00 ; |        | $3B91
    .byte $08 ; |    X   | $3B92
    .byte $14 ; |   X X  | $3B93
    .byte $2A ; |  X X X | $3B94
    .byte $5D ; | X XXX X| $3B95
    .byte $41 ; | X     X| $3B96
    .byte $3E ; |  XXXXX | $3B97
    .byte $00 ; |        | $3B98
    .byte $00 ; |        | $3B99
    .byte $00 ; |        | $3B9A
    .byte $00 ; |        | $3B9B
    .byte $00 ; |        | $3B9C
    .byte $00 ; |        | $3B9D
    .byte $00 ; |        | $3B9E
    .byte $00 ; |        | $3B9F
    .byte $00 ; |        | $3BA0
    .byte $00 ; |        | $3BA1
    .byte $3C ; |  XXXX  | $3BA2
    .byte $66 ; | XX  XX | $3BA3
    .byte $5A ; | X XX X | $3BA4
    .byte $5A ; | X XX X | $3BA5
    .byte $5A ; | X XX X | $3BA6
    .byte $66 ; | XX  XX | $3BA7
    .byte $3C ; |  XXXX  | $3BA8
    .byte $00 ; |        | $3BA9
    .byte $00 ; |        | $3BAA
    .byte $00 ; |        | $3BAB
    .byte $00 ; |        | $3BAC
    .byte $00 ; |        | $3BAD
    .byte $00 ; |        | $3BAE
    .byte $00 ; |        | $3BAF
    .byte $00 ; |        | $3BB0
    .byte $00 ; |        | $3BB1
    .byte $70 ; | XXX    | $3BB2
    .byte $58 ; | X XX   | $3BB3
    .byte $5C ; | X XXX  | $3BB4
    .byte $56 ; | X X XX | $3BB5
    .byte $57 ; | X X XXX| $3BB6
    .byte $55 ; | X X X X| $3BB7
    .byte $7D ; | XXXXX X| $3BB8
    .byte $C7 ; |XX   XXX| $3BB9
    .byte $00 ; |        | $3BBA
    .byte $00 ; |        | $3BBB
    .byte $00 ; |        | $3BBC
    .byte $00 ; |        | $3BBD
    .byte $00 ; |        | $3BBE
    .byte $00 ; |        | $3BBF
    .byte $00 ; |        | $3BC0
    .byte $00 ; |        | $3BC1
    .byte $08 ; |    X   | $3BC2
    .byte $14 ; |   X X  | $3BC3
    .byte $2A ; |  X X X | $3BC4
    .byte $5D ; | X XXX X| $3BC5
    .byte $5D ; | X XXX X| $3BC6
    .byte $2A ; |  X X X | $3BC7
    .byte $14 ; |   X X  | $3BC8
    .byte $08 ; |    X   | $3BC9
    .byte $00 ; |        | $3BCA
    .byte $00 ; |        | $3BCB
    .byte $00 ; |        | $3BCC
    .byte $00 ; |        | $3BCD
    .byte $00 ; |        | $3BCE
    .byte $00 ; |        | $3BCF
    .byte $00 ; |        | $3BD0
    .byte $00 ; |        | $3BD1
    .byte $77 ; | XXX XXX| $3BD2
    .byte $77 ; | XXX XXX| $3BD3
    .byte $22 ; |  X   X | $3BD4
    .byte $77 ; | XXX XXX| $3BD5
    .byte $1C ; |   XXX  | $3BD6
    .byte $1C ; |   XXX  | $3BD7
    .byte $08 ; |    X   | $3BD8
    .byte $1C ; |   XXX  | $3BD9
    .byte $00 ; |        | $3BDA
    .byte $00 ; |        | $3BDB
    .byte $00 ; |        | $3BDC
    .byte $00 ; |        | $3BDD
    .byte $00 ; |        | $3BDE
    .byte $00 ; |        | $3BDF
    .byte $00 ; |        | $3BE0
    .byte $00 ; |        | $3BE1
    .byte $18 ; |   XX   | $3BE2
    .byte $18 ; |   XX   | $3BE3
    .byte $00 ; |        | $3BE4
    .byte $00 ; |        | $3BE5
    .byte $00 ; |        | $3BE6
    .byte $00 ; |        | $3BE7
    .byte $00 ; |        | $3BE8
    .byte $00 ; |        | $3BE9
    .byte $00 ; |        | $3BEA
    .byte $00 ; |        | $3BEB
    .byte $00 ; |        | $3BEC
    .byte $00 ; |        | $3BED
    .byte $00 ; |        | $3BEE
    .byte $00 ; |        | $3BEF
    .byte $00 ; |        | $3BF0
    .byte $00 ; |        | $3BF1
    .byte $EE ; |XXX XXX | $3BF2
    .byte $2A ; |  X X X | $3BF3
    .byte $6A ; | XX X X | $3BF4
    .byte $2A ; |  X X X | $3BF5
    .byte $EE ; |XXX XXX | $3BF6
    .byte $00 ; |        | $3BF7
    .byte $EE ; |XXX XXX | $3BF8
    .byte $4A ; | X  X X | $3BF9
    .byte $4E ; | X  XXX | $3BFA
    .byte $CA ; |XX  X X | $3BFB
    .byte $4E ; | X  XXX | $3BFC
    .byte $00 ; |        | $3BFD
    .byte $00 ; |        | $3BFE
    .byte $00 ; |        | $3BFF
    .byte $00 ; |        | $3C00
    .byte $00 ; |        | $3C01
    .byte $E4 ; |XXX  X  | $3C02
    .byte $44 ; | X   X  | $3C03
    .byte $42 ; | X    X | $3C04
    .byte $C2 ; |XX    X | $3C05
    .byte $4E ; | X  XXX | $3C06
    .byte $00 ; |        | $3C07
    .byte $EE ; |XXX XXX | $3C08
    .byte $AA ; |X X X X | $3C09
    .byte $EE ; |XXX XXX | $3C0A
    .byte $AA ; |X X X X | $3C0B
    .byte $EE ; |XXX XXX | $3C0C
    .byte $00 ; |        | $3C0D
    .byte $00 ; |        | $3C0E
    .byte $00 ; |        | $3C0F
    .byte $00 ; |        | $3C10
    .byte $00 ; |        | $3C11
    .byte $7C ; | XXXXX  | $3C12
    .byte $54 ; | X X X  | $3C13
    .byte $54 ; | X X X  | $3C14
    .byte $44 ; | X   X  | $3C15
    .byte $44 ; | X   X  | $3C16
    .byte $00 ; |        | $3C17
    .byte $E4 ; |XXX  X  | $3C18
    .byte $24 ; |  X  X  | $3C19
    .byte $62 ; | XX   X | $3C1A
    .byte $22 ; |  X   X | $3C1B
    .byte $EE ; |XXX XXX | $3C1C
    .byte $00 ; |        | $3C1D
    .byte $00 ; |        | $3C1E
    .byte $00 ; |        | $3C1F
    .byte $00 ; |        | $3C20
    .byte $00 ; |        | $3C21
    .byte $00 ; |        | $3C22
    .byte $00 ; |        | $3C23
    .byte $00 ; |        | $3C24
    .byte $00 ; |        | $3C25
    .byte $00 ; |        | $3C26
    .byte $00 ; |        | $3C27
    .byte $00 ; |        | $3C28
    .byte $00 ; |        | $3C29
    .byte $00 ; |        | $3C2A
    .byte $00 ; |        | $3C2B
    .byte $00 ; |        | $3C2C
    .byte $00 ; |        | $3C2D
    .byte $00 ; |        | $3C2E
    .byte $00 ; |        | $3C2F
    .byte $00 ; |        | $3C30
    .byte $00 ; |        | $3C31
    .byte $00 ; |        | $3C32
    .byte $00 ; |        | $3C33
    .byte $00 ; |        | $3C34
    .byte $00 ; |        | $3C35
    .byte $00 ; |        | $3C36
    .byte $00 ; |        | $3C37
    .byte $00 ; |        | $3C38
    .byte $00 ; |        | $3C39
    .byte $00 ; |        | $3C3A
    .byte $00 ; |        | $3C3B
    .byte $00 ; |        | $3C3C
    .byte $00 ; |        | $3C3D
    .byte $00 ; |        | $3C3E
    .byte $00 ; |        | $3C3F
    .byte $00 ; |        | $3C40
    .byte $00 ; |        | $3C41
    .byte $00 ; |        | $3C42
    .byte $00 ; |        | $3C43
    .byte $00 ; |        | $3C44
    .byte $00 ; |        | $3C45
    .byte $00 ; |        | $3C46
    .byte $00 ; |        | $3C47
    .byte $00 ; |        | $3C48
    .byte $00 ; |        | $3C49
    .byte $00 ; |        | $3C4A
    .byte $00 ; |        | $3C4B
    .byte $00 ; |        | $3C4C
    .byte $00 ; |        | $3C4D
    .byte $00 ; |        | $3C4E
    .byte $00 ; |        | $3C4F
    .byte $00 ; |        | $3C50
    .byte $00 ; |        | $3C51
    .byte $00 ; |        | $3C52
    .byte $00 ; |        | $3C53
    .byte $00 ; |        | $3C54
    .byte $00 ; |        | $3C55
    .byte $00 ; |        | $3C56
    .byte $00 ; |        | $3C57
    .byte $00 ; |        | $3C58
    .byte $00 ; |        | $3C59
    .byte $00 ; |        | $3C5A
    .byte $00 ; |        | $3C5B
    .byte $00 ; |        | $3C5C
    .byte $00 ; |        | $3C5D
    .byte $00 ; |        | $3C5E
    .byte $00 ; |        | $3C5F
    .byte $00 ; |        | $3C60
    .byte $1C ; |   XXX  | $3C61
    .byte $18 ; |   XX   | $3C62
    .byte $18 ; |   XX   | $3C63
    .byte $3C ; |  XXXX  | $3C64
    .byte $34 ; |  XX X  | $3C65
    .byte $2C ; |  X XX  | $3C66
    .byte $2C ; |  X XX  | $3C67
    .byte $2C ; |  X XX  | $3C68
    .byte $3C ; |  XXXX  | $3C69
    .byte $18 ; |   XX   | $3C6A
    .byte $3C ; |  XXXX  | $3C6B
    .byte $3E ; |  XXXXX | $3C6C
    .byte $34 ; |  XX X  | $3C6D
    .byte $3C ; |  XXXX  | $3C6E
    .byte $00 ; |        | $3C6F
    .byte $00 ; |        | $3C70
    .byte $00 ; |        | $3C71
    .byte $00 ; |        | $3C72
    .byte $00 ; |        | $3C73
    .byte $00 ; |        | $3C74
    .byte $00 ; |        | $3C75
    .byte $00 ; |        | $3C76
    .byte $00 ; |        | $3C77
    .byte $00 ; |        | $3C78
    .byte $00 ; |        | $3C79
    .byte $00 ; |        | $3C7A
    .byte $00 ; |        | $3C7B
    .byte $00 ; |        | $3C7C
    .byte $00 ; |        | $3C7D
    .byte $00 ; |        | $3C7E
    .byte $00 ; |        | $3C7F
    .byte $00 ; |        | $3C80
    .byte $00 ; |        | $3C81
    .byte $00 ; |        | $3C82
    .byte $00 ; |        | $3C83
    .byte $00 ; |        | $3C84
    .byte $00 ; |        | $3C85
    .byte $00 ; |        | $3C86
    .byte $00 ; |        | $3C87
    .byte $00 ; |        | $3C88
    .byte $00 ; |        | $3C89
    .byte $00 ; |        | $3C8A
    .byte $00 ; |        | $3C8B
    .byte $00 ; |        | $3C8C
    .byte $00 ; |        | $3C8D
    .byte $00 ; |        | $3C8E
    .byte $00 ; |        | $3C8F
    .byte $00 ; |        | $3C90
    .byte $00 ; |        | $3C91
    .byte $00 ; |        | $3C92
    .byte $34 ; |  XX X  | $3C93
    .byte $66 ; | XX  XX | $3C94
    .byte $19 ; |   XX  X| $3C95
    .byte $3C ; |  XXXX  | $3C96
    .byte $3C ; |  XXXX  | $3C97
    .byte $38 ; |  XXX   | $3C98
    .byte $34 ; |  XX X  | $3C99
    .byte $2C ; |  X XX  | $3C9A
    .byte $3C ; |  XXXX  | $3C9B
    .byte $18 ; |   XX   | $3C9C
    .byte $3C ; |  XXXX  | $3C9D
    .byte $3E ; |  XXXXX | $3C9E
    .byte $34 ; |  XX X  | $3C9F
    .byte $3C ; |  XXXX  | $3CA0
    .byte $00 ; |        | $3CA1
    .byte $00 ; |        | $3CA2
    .byte $00 ; |        | $3CA3
    .byte $00 ; |        | $3CA4
    .byte $00 ; |        | $3CA5
    .byte $00 ; |        | $3CA6
    .byte $00 ; |        | $3CA7
    .byte $00 ; |        | $3CA8
    .byte $00 ; |        | $3CA9
    .byte $00 ; |        | $3CAA
    .byte $00 ; |        | $3CAB
    .byte $00 ; |        | $3CAC
    .byte $00 ; |        | $3CAD
    .byte $00 ; |        | $3CAE
    .byte $00 ; |        | $3CAF
    .byte $00 ; |        | $3CB0
    .byte $00 ; |        | $3CB1
    .byte $00 ; |        | $3CB2
    .byte $00 ; |        | $3CB3
    .byte $00 ; |        | $3CB4
    .byte $00 ; |        | $3CB5
    .byte $00 ; |        | $3CB6
    .byte $00 ; |        | $3CB7
    .byte $00 ; |        | $3CB8
    .byte $00 ; |        | $3CB9
    .byte $00 ; |        | $3CBA
    .byte $00 ; |        | $3CBB
    .byte $00 ; |        | $3CBC
    .byte $00 ; |        | $3CBD
    .byte $00 ; |        | $3CBE
    .byte $00 ; |        | $3CBF
    .byte $00 ; |        | $3CC0
    .byte $00 ; |        | $3CC1
    .byte $00 ; |        | $3CC2
    .byte $00 ; |        | $3CC3
    .byte $00 ; |        | $3CC4
    .byte $34 ; |  XX X  | $3CC5
    .byte $66 ; | XX  XX | $3CC6
    .byte $19 ; |   XX  X| $3CC7
    .byte $3C ; |  XXXX  | $3CC8
    .byte $2C ; |  X XX  | $3CC9
    .byte $1C ; |   XXX  | $3CCA
    .byte $2C ; |  X XX  | $3CCB
    .byte $2C ; |  X XX  | $3CCC
    .byte $3C ; |  XXXX  | $3CCD
    .byte $18 ; |   XX   | $3CCE
    .byte $3C ; |  XXXX  | $3CCF
    .byte $3E ; |  XXXXX | $3CD0
    .byte $34 ; |  XX X  | $3CD1
    .byte $3C ; |  XXXX  | $3CD2
    .byte $00 ; |        | $3CD3
    .byte $00 ; |        | $3CD4
    .byte $00 ; |        | $3CD5
    .byte $00 ; |        | $3CD6
    .byte $00 ; |        | $3CD7
    .byte $00 ; |        | $3CD8
    .byte $00 ; |        | $3CD9
    .byte $00 ; |        | $3CDA
    .byte $00 ; |        | $3CDB
    .byte $00 ; |        | $3CDC
    .byte $00 ; |        | $3CDD
    .byte $00 ; |        | $3CDE
    .byte $00 ; |        | $3CDF
    .byte $00 ; |        | $3CE0
    .byte $00 ; |        | $3CE1
    .byte $00 ; |        | $3CE2
    .byte $00 ; |        | $3CE3
    .byte $00 ; |        | $3CE4
    .byte $00 ; |        | $3CE5
    .byte $00 ; |        | $3CE6
    .byte $00 ; |        | $3CE7
    .byte $00 ; |        | $3CE8
    .byte $00 ; |        | $3CE9
    .byte $00 ; |        | $3CEA
    .byte $00 ; |        | $3CEB
    .byte $00 ; |        | $3CEC
    .byte $00 ; |        | $3CED
    .byte $00 ; |        | $3CEE
    .byte $00 ; |        | $3CEF
    .byte $00 ; |        | $3CF0
    .byte $00 ; |        | $3CF1
    .byte $00 ; |        | $3CF2
    .byte $00 ; |        | $3CF3
    .byte $00 ; |        | $3CF4
    .byte $00 ; |        | $3CF5
    .byte $00 ; |        | $3CF6
    .byte $18 ; |   XX   | $3CF7
    .byte $30 ; |  XX    | $3CF8
    .byte $12 ; |   X  X | $3CF9
    .byte $1F ; |   XXXXX| $3CFA
    .byte $3D ; |  XXXX X| $3CFB
    .byte $3C ; |  XXXX  | $3CFC
    .byte $32 ; |  XX  X | $3CFD
    .byte $2C ; |  X XX  | $3CFE
    .byte $3C ; |  XXXX  | $3CFF
    .byte $18 ; |   XX   | $3D00
    .byte $3C ; |  XXXX  | $3D01
    .byte $3E ; |  XXXXX | $3D02
    .byte $34 ; |  XX X  | $3D03
    .byte $3C ; |  XXXX  | $3D04
    .byte $00 ; |        | $3D05
    .byte $00 ; |        | $3D06
    .byte $00 ; |        | $3D07
    .byte $00 ; |        | $3D08
    .byte $00 ; |        | $3D09
    .byte $00 ; |        | $3D0A
    .byte $00 ; |        | $3D0B
    .byte $00 ; |        | $3D0C
    .byte $00 ; |        | $3D0D
    .byte $00 ; |        | $3D0E
    .byte $00 ; |        | $3D0F
    .byte $00 ; |        | $3D10
    .byte $00 ; |        | $3D11
    .byte $00 ; |        | $3D12
    .byte $00 ; |        | $3D13
    .byte $00 ; |        | $3D14
    .byte $00 ; |        | $3D15
    .byte $00 ; |        | $3D16
    .byte $00 ; |        | $3D17
    .byte $00 ; |        | $3D18
    .byte $00 ; |        | $3D19
    .byte $00 ; |        | $3D1A
    .byte $00 ; |        | $3D1B
    .byte $00 ; |        | $3D1C
    .byte $00 ; |        | $3D1D
    .byte $00 ; |        | $3D1E
    .byte $00 ; |        | $3D1F
    .byte $00 ; |        | $3D20
    .byte $00 ; |        | $3D21
    .byte $00 ; |        | $3D22
    .byte $00 ; |        | $3D23
    .byte $00 ; |        | $3D24
    .byte $00 ; |        | $3D25
    .byte $00 ; |        | $3D26
    .byte $00 ; |        | $3D27
    .byte $00 ; |        | $3D28
    .byte $04 ; |     X  | $3D29
    .byte $46 ; | X   XX | $3D2A
    .byte $79 ; | XXXX  X| $3D2B
    .byte $1C ; |   XXX  | $3D2C
    .byte $3C ; |  XXXX  | $3D2D
    .byte $3C ; |  XXXX  | $3D2E
    .byte $30 ; |  XX    | $3D2F
    .byte $2C ; |  X XX  | $3D30
    .byte $3C ; |  XXXX  | $3D31
    .byte $18 ; |   XX   | $3D32
    .byte $3C ; |  XXXX  | $3D33
    .byte $3E ; |  XXXXX | $3D34
    .byte $34 ; |  XX X  | $3D35
    .byte $3C ; |  XXXX  | $3D36
    .byte $00 ; |        | $3D37
    .byte $00 ; |        | $3D38
    .byte $00 ; |        | $3D39
    .byte $00 ; |        | $3D3A
    .byte $00 ; |        | $3D3B
    .byte $00 ; |        | $3D3C
    .byte $00 ; |        | $3D3D
    .byte $00 ; |        | $3D3E
    .byte $00 ; |        | $3D3F
    .byte $00 ; |        | $3D40
    .byte $00 ; |        | $3D41
    .byte $00 ; |        | $3D42
    .byte $00 ; |        | $3D43
    .byte $00 ; |        | $3D44
    .byte $00 ; |        | $3D45
    .byte $00 ; |        | $3D46
    .byte $00 ; |        | $3D47
    .byte $00 ; |        | $3D48
    .byte $00 ; |        | $3D49
    .byte $00 ; |        | $3D4A
    .byte $00 ; |        | $3D4B
    .byte $00 ; |        | $3D4C
    .byte $00 ; |        | $3D4D
    .byte $00 ; |        | $3D4E
    .byte $00 ; |        | $3D4F
    .byte $00 ; |        | $3D50
    .byte $00 ; |        | $3D51
    .byte $00 ; |        | $3D52
    .byte $00 ; |        | $3D53
    .byte $00 ; |        | $3D54
    .byte $00 ; |        | $3D55
    .byte $00 ; |        | $3D56
    .byte $00 ; |        | $3D57
    .byte $00 ; |        | $3D58
    .byte $00 ; |        | $3D59
    .byte $00 ; |        | $3D5A
    .byte $3C ; |  XXXX  | $3D5B
    .byte $18 ; |   XX   | $3D5C
    .byte $18 ; |   XX   | $3D5D
    .byte $3C ; |  XXXX  | $3D5E
    .byte $3C ; |  XXXX  | $3D5F
    .byte $7C ; | XXXXX  | $3D60
    .byte $7C ; | XXXXX  | $3D61
    .byte $7C ; | XXXXX  | $3D62
    .byte $3F ; |  XXXXXX| $3D63
    .byte $19 ; |   XX  X| $3D64
    .byte $3D ; |  XXXX X| $3D65
    .byte $3D ; |  XXXX X| $3D66
    .byte $3C ; |  XXXX  | $3D67
    .byte $3C ; |  XXXX  | $3D68
    .byte $00 ; |        | $3D69
    .byte $00 ; |        | $3D6A
    .byte $00 ; |        | $3D6B
    .byte $00 ; |        | $3D6C
    .byte $00 ; |        | $3D6D
    .byte $00 ; |        | $3D6E
    .byte $00 ; |        | $3D6F
    .byte $00 ; |        | $3D70
    .byte $00 ; |        | $3D71
    .byte $00 ; |        | $3D72
    .byte $00 ; |        | $3D73
    .byte $00 ; |        | $3D74
    .byte $00 ; |        | $3D75
    .byte $00 ; |        | $3D76
    .byte $00 ; |        | $3D77
    .byte $00 ; |        | $3D78
    .byte $00 ; |        | $3D79
    .byte $00 ; |        | $3D7A
    .byte $00 ; |        | $3D7B
    .byte $00 ; |        | $3D7C
    .byte $00 ; |        | $3D7D
    .byte $00 ; |        | $3D7E
    .byte $00 ; |        | $3D7F
    .byte $00 ; |        | $3D80
    .byte $00 ; |        | $3D81
    .byte $00 ; |        | $3D82
    .byte $00 ; |        | $3D83
    .byte $00 ; |        | $3D84
    .byte $00 ; |        | $3D85
    .byte $00 ; |        | $3D86
    .byte $00 ; |        | $3D87
    .byte $00 ; |        | $3D88
    .byte $00 ; |        | $3D89
    .byte $00 ; |        | $3D8A
    .byte $00 ; |        | $3D8B
    .byte $00 ; |        | $3D8C
    .byte $3C ; |  XXXX  | $3D8D
    .byte $18 ; |   XX   | $3D8E
    .byte $18 ; |   XX   | $3D8F
    .byte $3C ; |  XXXX  | $3D90
    .byte $3C ; |  XXXX  | $3D91
    .byte $7C ; | XXXXX  | $3D92
    .byte $7C ; | XXXXX  | $3D93
    .byte $7C ; | XXXXX  | $3D94
    .byte $3F ; |  XXXXXX| $3D95
    .byte $19 ; |   XX  X| $3D96
    .byte $3C ; |  XXXX  | $3D97
    .byte $3C ; |  XXXX  | $3D98
    .byte $3C ; |  XXXX  | $3D99
    .byte $3C ; |  XXXX  | $3D9A
    .byte $00 ; |        | $3D9B
    .byte $00 ; |        | $3D9C
    .byte $00 ; |        | $3D9D
    .byte $00 ; |        | $3D9E
    .byte $00 ; |        | $3D9F
    .byte $00 ; |        | $3DA0
    .byte $00 ; |        | $3DA1
    .byte $00 ; |        | $3DA2
    .byte $00 ; |        | $3DA3
    .byte $00 ; |        | $3DA4
    .byte $00 ; |        | $3DA5
    .byte $00 ; |        | $3DA6
    .byte $00 ; |        | $3DA7
    .byte $00 ; |        | $3DA8
    .byte $00 ; |        | $3DA9
    .byte $00 ; |        | $3DAA
    .byte $00 ; |        | $3DAB
    .byte $00 ; |        | $3DAC
    .byte $00 ; |        | $3DAD
    .byte $00 ; |        | $3DAE
    .byte $00 ; |        | $3DAF
    .byte $00 ; |        | $3DB0
    .byte $00 ; |        | $3DB1
    .byte $00 ; |        | $3DB2
    .byte $00 ; |        | $3DB3
    .byte $00 ; |        | $3DB4
    .byte $00 ; |        | $3DB5
    .byte $00 ; |        | $3DB6
    .byte $00 ; |        | $3DB7
    .byte $00 ; |        | $3DB8
    .byte $00 ; |        | $3DB9
    .byte $00 ; |        | $3DBA
    .byte $00 ; |        | $3DBB
    .byte $00 ; |        | $3DBC
    .byte $00 ; |        | $3DBD
    .byte $00 ; |        | $3DBE
    .byte $2C ; |  X XX  | $3DBF
    .byte $66 ; | XX  XX | $3DC0
    .byte $98 ; |X  XX   | $3DC1
    .byte $3C ; |  XXXX  | $3DC2
    .byte $7E ; | XXXXXX | $3DC3
    .byte $0E ; |    XXX | $3DC4
    .byte $66 ; | XX  XX | $3DC5
    .byte $72 ; | XXX  X | $3DC6
    .byte $7C ; | XXXXX  | $3DC7
    .byte $38 ; |  XXX   | $3DC8
    .byte $7C ; | XXXXX  | $3DC9
    .byte $FC ; |XXXXXX  | $3DCA
    .byte $5C ; | X XXX  | $3DCB
    .byte $7C ; | XXXXX  | $3DCC
    .byte $00 ; |        | $3DCD
    .byte $00 ; |        | $3DCE
    .byte $00 ; |        | $3DCF
    .byte $00 ; |        | $3DD0
    .byte $00 ; |        | $3DD1
    .byte $00 ; |        | $3DD2
    .byte $00 ; |        | $3DD3
    .byte $00 ; |        | $3DD4
    .byte $00 ; |        | $3DD5
    .byte $00 ; |        | $3DD6
    .byte $00 ; |        | $3DD7
    .byte $00 ; |        | $3DD8
    .byte $00 ; |        | $3DD9
    .byte $00 ; |        | $3DDA
    .byte $00 ; |        | $3DDB
    .byte $00 ; |        | $3DDC
    .byte $00 ; |        | $3DDD
    .byte $00 ; |        | $3DDE
    .byte $00 ; |        | $3DDF
    .byte $00 ; |        | $3DE0
    .byte $00 ; |        | $3DE1
    .byte $00 ; |        | $3DE2
    .byte $00 ; |        | $3DE3
    .byte $00 ; |        | $3DE4
    .byte $00 ; |        | $3DE5
    .byte $00 ; |        | $3DE6
    .byte $00 ; |        | $3DE7
    .byte $00 ; |        | $3DE8
    .byte $00 ; |        | $3DE9
    .byte $00 ; |        | $3DEA
    .byte $00 ; |        | $3DEB
    .byte $00 ; |        | $3DEC
    .byte $00 ; |        | $3DED
    .byte $00 ; |        | $3DEE
    .byte $00 ; |        | $3DEF
    .byte $00 ; |        | $3DF0
    .byte $38 ; |  XXX   | $3DF1
    .byte $38 ; |  XXX   | $3DF2
    .byte $18 ; |   XX   | $3DF3
    .byte $3C ; |  XXXX  | $3DF4
    .byte $7E ; | XXXXXX | $3DF5
    .byte $7E ; | XXXXXX | $3DF6
    .byte $06 ; |     XX | $3DF7
    .byte $72 ; | XXX  X | $3DF8
    .byte $7C ; | XXXXX  | $3DF9
    .byte $38 ; |  XXX   | $3DFA
    .byte $7C ; | XXXXX  | $3DFB
    .byte $FC ; |XXXXXX  | $3DFC
    .byte $5C ; | X XXX  | $3DFD
    .byte $7C ; | XXXXX  | $3DFE
    .byte $00 ; |        | $3DFF
    .byte $00 ; |        | $3E00
    .byte $00 ; |        | $3E01
    .byte $00 ; |        | $3E02
    .byte $00 ; |        | $3E03
    .byte $00 ; |        | $3E04
    .byte $00 ; |        | $3E05
    .byte $00 ; |        | $3E06
    .byte $00 ; |        | $3E07
    .byte $00 ; |        | $3E08
    .byte $00 ; |        | $3E09
    .byte $00 ; |        | $3E0A
    .byte $00 ; |        | $3E0B
    .byte $00 ; |        | $3E0C
    .byte $00 ; |        | $3E0D
    .byte $00 ; |        | $3E0E
    .byte $00 ; |        | $3E0F
    .byte $00 ; |        | $3E10
    .byte $00 ; |        | $3E11
    .byte $00 ; |        | $3E12
    .byte $00 ; |        | $3E13
    .byte $00 ; |        | $3E14
    .byte $00 ; |        | $3E15
    .byte $00 ; |        | $3E16
    .byte $00 ; |        | $3E17
    .byte $00 ; |        | $3E18
    .byte $00 ; |        | $3E19
    .byte $00 ; |        | $3E1A
    .byte $00 ; |        | $3E1B
    .byte $00 ; |        | $3E1C
    .byte $00 ; |        | $3E1D
    .byte $00 ; |        | $3E1E
    .byte $00 ; |        | $3E1F
    .byte $00 ; |        | $3E20
    .byte $00 ; |        | $3E21
    .byte $00 ; |        | $3E22
    .byte $00 ; |        | $3E23
    .byte $00 ; |        | $3E24
    .byte $00 ; |        | $3E25
    .byte $00 ; |        | $3E26
    .byte $00 ; |        | $3E27
    .byte $00 ; |        | $3E28
    .byte $00 ; |        | $3E29
    .byte $00 ; |        | $3E2A
    .byte $00 ; |        | $3E2B
    .byte $00 ; |        | $3E2C
    .byte $00 ; |        | $3E2D
    .byte $00 ; |        | $3E2E
    .byte $00 ; |        | $3E2F
    .byte $00 ; |        | $3E30
    .byte $00 ; |        | $3E31
    .byte $00 ; |        | $3E32
    .byte $00 ; |        | $3E33
    .byte $00 ; |        | $3E34
    .byte $00 ; |        | $3E35
    .byte $00 ; |        | $3E36
    .byte $00 ; |        | $3E37
    .byte $00 ; |        | $3E38
    .byte $00 ; |        | $3E39
    .byte $00 ; |        | $3E3A
    .byte $00 ; |        | $3E3B
    .byte $00 ; |        | $3E3C
    .byte $00 ; |        | $3E3D
    .byte $00 ; |        | $3E3E
    .byte $00 ; |        | $3E3F
    .byte $00 ; |        | $3E40
    .byte $00 ; |        | $3E41
    .byte $FF ; |XXXXXXXX| $3E42
    .byte $FF ; |XXXXXXXX| $3E43
    .byte $00 ; |        | $3E44
    .byte $00 ; |        | $3E45
    .byte $00 ; |        | $3E46
    .byte $00 ; |        | $3E47
    .byte $00 ; |        | $3E48
    .byte $00 ; |        | $3E49
    .byte $00 ; |        | $3E4A
    .byte $00 ; |        | $3E4B
    .byte $00 ; |        | $3E4C
    .byte $00 ; |        | $3E4D
    .byte $00 ; |        | $3E4E
    .byte $00 ; |        | $3E4F
    .byte $00 ; |        | $3E50
    .byte $00 ; |        | $3E51
    .byte $00 ; |        | $3E52
    .byte $00 ; |        | $3E53
    .byte $00 ; |        | $3E54
    .byte $00 ; |        | $3E55
    .byte $00 ; |        | $3E56
    .byte $00 ; |        | $3E57
    .byte $00 ; |        | $3E58
    .byte $00 ; |        | $3E59
    .byte $00 ; |        | $3E5A
    .byte $00 ; |        | $3E5B
    .byte $00 ; |        | $3E5C
    .byte $00 ; |        | $3E5D
    .byte $00 ; |        | $3E5E
    .byte $00 ; |        | $3E5F
    .byte $00 ; |        | $3E60
    .byte $00 ; |        | $3E61
    .byte $00 ; |        | $3E62
    .byte $00 ; |        | $3E63
    .byte $00 ; |        | $3E64
    .byte $00 ; |        | $3E65
    .byte $00 ; |        | $3E66
    .byte $00 ; |        | $3E67
    .byte $00 ; |        | $3E68
    .byte $00 ; |        | $3E69
    .byte $00 ; |        | $3E6A
    .byte $00 ; |        | $3E6B
    .byte $00 ; |        | $3E6C
    .byte $00 ; |        | $3E6D
    .byte $00 ; |        | $3E6E
    .byte $00 ; |        | $3E6F
    .byte $00 ; |        | $3E70
    .byte $00 ; |        | $3E71
    .byte $00 ; |        | $3E72
    .byte $00 ; |        | $3E73
    .byte $00 ; |        | $3E74
    .byte $00 ; |        | $3E75
    .byte $00 ; |        | $3E76
    .byte $00 ; |        | $3E77
    .byte $00 ; |        | $3E78
    .byte $00 ; |        | $3E79
    .byte $00 ; |        | $3E7A
    .byte $00 ; |        | $3E7B
    .byte $00 ; |        | $3E7C
    .byte $00 ; |        | $3E7D
    .byte $00 ; |        | $3E7E
    .byte $00 ; |        | $3E7F
    .byte $00 ; |        | $3E80
    .byte $00 ; |        | $3E81
    .byte $00 ; |        | $3E82
    .byte $00 ; |        | $3E83
    .byte $00 ; |        | $3E84
    .byte $00 ; |        | $3E85
    .byte $00 ; |        | $3E86
    .byte $00 ; |        | $3E87
    .byte $00 ; |        | $3E88
    .byte $00 ; |        | $3E89
    .byte $00 ; |        | $3E8A
    .byte $1D ; |   XXX X| $3E8B
    .byte $32 ; |  XX  X | $3E8C
    .byte $E0 ; |XXX     | $3E8D
    .byte $40 ; | X      | $3E8E
    .byte $00 ; |        | $3E8F
    .byte $00 ; |        | $3E90
    .byte $00 ; |        | $3E91
    .byte $00 ; |        | $3E92
    .byte $00 ; |        | $3E93
    .byte $00 ; |        | $3E94
    .byte $00 ; |        | $3E95
    .byte $00 ; |        | $3E96
    .byte $00 ; |        | $3E97
    .byte $00 ; |        | $3E98
    .byte $00 ; |        | $3E99
    .byte $00 ; |        | $3E9A
    .byte $00 ; |        | $3E9B
    .byte $00 ; |        | $3E9C
    .byte $00 ; |        | $3E9D
    .byte $00 ; |        | $3E9E
    .byte $00 ; |        | $3E9F
    .byte $00 ; |        | $3EA0
    .byte $00 ; |        | $3EA1
    .byte $00 ; |        | $3EA2
    .byte $00 ; |        | $3EA3
    .byte $00 ; |        | $3EA4
    .byte $00 ; |        | $3EA5
    .byte $00 ; |        | $3EA6
    .byte $00 ; |        | $3EA7
    .byte $00 ; |        | $3EA8
    .byte $00 ; |        | $3EA9
    .byte $00 ; |        | $3EAA
    .byte $00 ; |        | $3EAB
    .byte $00 ; |        | $3EAC
    .byte $00 ; |        | $3EAD
    .byte $00 ; |        | $3EAE
    .byte $00 ; |        | $3EAF
    .byte $00 ; |        | $3EB0
    .byte $00 ; |        | $3EB1
    .byte $00 ; |        | $3EB2
    .byte $00 ; |        | $3EB3
    .byte $0F ; |    XXXX| $3EB4
    .byte $10 ; |   X    | $3EB5
    .byte $10 ; |   X    | $3EB6
    .byte $70 ; | XXX    | $3EB7
    .byte $20 ; |  X     | $3EB8
    .byte $00 ; |        | $3EB9
    .byte $00 ; |        | $3EBA
    .byte $00 ; |        | $3EBB
    .byte $00 ; |        | $3EBC
    .byte $00 ; |        | $3EBD
    .byte $00 ; |        | $3EBE
    .byte $00 ; |        | $3EBF
    .byte $00 ; |        | $3EC0
    .byte $00 ; |        | $3EC1
    .byte $00 ; |        | $3EC2
    .byte $00 ; |        | $3EC3
    .byte $00 ; |        | $3EC4
    .byte $00 ; |        | $3EC5
    .byte $00 ; |        | $3EC6
    .byte $00 ; |        | $3EC7
    .byte $00 ; |        | $3EC8
    .byte $00 ; |        | $3EC9
    .byte $00 ; |        | $3ECA
    .byte $00 ; |        | $3ECB
    .byte $00 ; |        | $3ECC
    .byte $00 ; |        | $3ECD
    .byte $00 ; |        | $3ECE
    .byte $00 ; |        | $3ECF
    .byte $00 ; |        | $3ED0
    .byte $00 ; |        | $3ED1
    .byte $00 ; |        | $3ED2
    .byte $00 ; |        | $3ED3
    .byte $00 ; |        | $3ED4
    .byte $00 ; |        | $3ED5
    .byte $00 ; |        | $3ED6
    .byte $00 ; |        | $3ED7
    .byte $00 ; |        | $3ED8
    .byte $00 ; |        | $3ED9
    .byte $00 ; |        | $3EDA
    .byte $00 ; |        | $3EDB
    .byte $00 ; |        | $3EDC
    .byte $00 ; |        | $3EDD
    .byte $00 ; |        | $3EDE
    .byte $00 ; |        | $3EDF
    .byte $00 ; |        | $3EE0
    .byte $00 ; |        | $3EE1
    .byte $00 ; |        | $3EE2
    .byte $00 ; |        | $3EE3
    .byte $00 ; |        | $3EE4
    .byte $00 ; |        | $3EE5
    .byte $00 ; |        | $3EE6
    .byte $00 ; |        | $3EE7
    .byte $00 ; |        | $3EE8
    .byte $00 ; |        | $3EE9
    .byte $00 ; |        | $3EEA
    .byte $00 ; |        | $3EEB
    .byte $00 ; |        | $3EEC
    .byte $00 ; |        | $3EED
    .byte $00 ; |        | $3EEE
    .byte $00 ; |        | $3EEF
    .byte $00 ; |        | $3EF0
    .byte $00 ; |        | $3EF1
    .byte $00 ; |        | $3EF2
    .byte $00 ; |        | $3EF3
    .byte $00 ; |        | $3EF4
    .byte $00 ; |        | $3EF5
    .byte $00 ; |        | $3EF6
    .byte $00 ; |        | $3EF7
    .byte $00 ; |        | $3EF8
    .byte $00 ; |        | $3EF9
    .byte $00 ; |        | $3EFA
    .byte $00 ; |        | $3EFB
    .byte $00 ; |        | $3EFC
    .byte $00 ; |        | $3EFD
    .byte $00 ; |        | $3EFE
    .byte $00 ; |        | $3EFF
    .byte $3C ; |  XXXX  | $3F00
    .byte $7E ; | XXXXXX | $3F01
    .byte $66 ; | XX  XX | $3F02
    .byte $66 ; | XX  XX | $3F03
    .byte $66 ; | XX  XX | $3F04
    .byte $66 ; | XX  XX | $3F05
    .byte $7E ; | XXXXXX | $3F06
    .byte $3C ; |  XXXX  | $3F07
    .byte $3C ; |  XXXX  | $3F08
    .byte $3C ; |  XXXX  | $3F09
    .byte $18 ; |   XX   | $3F0A
    .byte $18 ; |   XX   | $3F0B
    .byte $18 ; |   XX   | $3F0C
    .byte $18 ; |   XX   | $3F0D
    .byte $38 ; |  XXX   | $3F0E
    .byte $18 ; |   XX   | $3F0F
    .byte $7E ; | XXXXXX | $3F10
    .byte $7E ; | XXXXXX | $3F11
    .byte $60 ; | XX     | $3F12
    .byte $7C ; | XXXXX  | $3F13
    .byte $3E ; |  XXXXX | $3F14
    .byte $06 ; |     XX | $3F15
    .byte $7E ; | XXXXXX | $3F16
    .byte $3C ; |  XXXX  | $3F17
    .byte $3C ; |  XXXX  | $3F18
    .byte $7E ; | XXXXXX | $3F19
    .byte $06 ; |     XX | $3F1A
    .byte $0C ; |    XX  | $3F1B
    .byte $0C ; |    XX  | $3F1C
    .byte $06 ; |     XX | $3F1D
    .byte $7E ; | XXXXXX | $3F1E
    .byte $3C ; |  XXXX  | $3F1F
    .byte $0C ; |    XX  | $3F20
    .byte $0C ; |    XX  | $3F21
    .byte $7E ; | XXXXXX | $3F22
    .byte $7E ; | XXXXXX | $3F23
    .byte $6C ; | XX XX  | $3F24
    .byte $6C ; | XX XX  | $3F25
    .byte $3C ; |  XXXX  | $3F26
    .byte $1C ; |   XXX  | $3F27
    .byte $3C ; |  XXXX  | $3F28
    .byte $7E ; | XXXXXX | $3F29
    .byte $06 ; |     XX | $3F2A
    .byte $7E ; | XXXXXX | $3F2B
    .byte $7C ; | XXXXX  | $3F2C
    .byte $60 ; | XX     | $3F2D
    .byte $7E ; | XXXXXX | $3F2E
    .byte $7E ; | XXXXXX | $3F2F
    .byte $3C ; |  XXXX  | $3F30
    .byte $7E ; | XXXXXX | $3F31
    .byte $66 ; | XX  XX | $3F32
    .byte $7E ; | XXXXXX | $3F33
    .byte $7C ; | XXXXX  | $3F34
    .byte $60 ; | XX     | $3F35
    .byte $7E ; | XXXXXX | $3F36
    .byte $3C ; |  XXXX  | $3F37
    .byte $60 ; | XX     | $3F38
    .byte $30 ; |  XX    | $3F39
    .byte $18 ; |   XX   | $3F3A
    .byte $0C ; |    XX  | $3F3B
    .byte $06 ; |     XX | $3F3C
    .byte $06 ; |     XX | $3F3D
    .byte $7E ; | XXXXXX | $3F3E
    .byte $7E ; | XXXXXX | $3F3F
    .byte $3C ; |  XXXX  | $3F40
    .byte $7E ; | XXXXXX | $3F41
    .byte $66 ; | XX  XX | $3F42
    .byte $3C ; |  XXXX  | $3F43
    .byte $3C ; |  XXXX  | $3F44
    .byte $66 ; | XX  XX | $3F45
    .byte $7E ; | XXXXXX | $3F46
    .byte $3C ; |  XXXX  | $3F47
    .byte $3C ; |  XXXX  | $3F48
    .byte $7E ; | XXXXXX | $3F49
    .byte $06 ; |     XX | $3F4A
    .byte $3E ; |  XXXXX | $3F4B
    .byte $7E ; | XXXXXX | $3F4C
    .byte $66 ; | XX  XX | $3F4D
    .byte $7E ; | XXXXXX | $3F4E
    .byte $3C ; |  XXXX  | $3F4F
    .byte $00 ; |        | $3F50
    .byte $00 ; |        | $3F51
    .byte $00 ; |        | $3F52
    .byte $00 ; |        | $3F53
    .byte $00 ; |        | $3F54
    .byte $00 ; |        | $3F55
    .byte $00 ; |        | $3F56
    .byte $00 ; |        | $3F57
    .byte $07 ; |     XXX| $3F58
    .byte $3E ; |  XXXXX | $3F59
    .byte $7D ; | XXXXX X| $3F5A
    .byte $6D ; | XX XX X| $3F5B
    .byte $6D ; | XX XX X| $3F5C
    .byte $6D ; | XX XX X| $3F5D
    .byte $7D ; | XXXXX X| $3F5E
    .byte $39 ; |  XXX  X| $3F5F
    .byte $00 ; |        | $3F60
    .byte $E7 ; |XXX  XXX| $3F61
    .byte $F7 ; |XXXX XXX| $3F62
    .byte $B6 ; |X XX XX | $3F63
    .byte $B7 ; |X XX XXX| $3F64
    .byte $B6 ; |X XX XX | $3F65
    .byte $B7 ; |X XX XXX| $3F66
    .byte $B7 ; |X XX XXX| $3F67
    .byte $00 ; |        | $3F68
    .byte $DE ; |XX XXXX | $3F69
    .byte $DF ; |XX XXXXX| $3F6A
    .byte $03 ; |      XX| $3F6B
    .byte $CE ; |XX  XXX | $3F6C
    .byte $18 ; |   XX   | $3F6D
    .byte $DF ; |XX XXXXX| $3F6E
    .byte $CF ; |XX  XXXX| $3F6F
    .byte $00 ; |        | $3F70
    .byte $18 ; |   XX   | $3F71
    .byte $18 ; |   XX   | $3F72
    .byte $18 ; |   XX   | $3F73
    .byte $18 ; |   XX   | $3F74
    .byte $18 ; |   XX   | $3F75
    .byte $7E ; | XXXXXX | $3F76
    .byte $7E ; | XXXXXX | $3F77
    .byte $FF ; |XXXXXXXX| $3F78
    .byte $FF ; |XXXXXXXX| $3F79
    .byte $FF ; |XXXXXXXX| $3F7A
    .byte $FF ; |XXXXXXXX| $3F7B
    .byte $FF ; |XXXXXXXX| $3F7C
    .byte $FF ; |XXXXXXXX| $3F7D
    .byte $FF ; |XXXXXXXX| $3F7E
    .byte $FF ; |XXXXXXXX| $3F7F
    .byte $FF ; |XXXXXXXX| $3F80
    .byte $FF ; |XXXXXXXX| $3F81
    .byte $FF ; |XXXXXXXX| $3F82
    .byte $FF ; |XXXXXXXX| $3F83
    .byte $FF ; |XXXXXXXX| $3F84
    .byte $FF ; |XXXXXXXX| $3F85
    .byte $42 ; | X    X | $3F86
    .byte $42 ; | X    X | $3F87
    .byte $42 ; | X    X | $3F88
    .byte $42 ; | X    X | $3F89
    .byte $42 ; | X    X | $3F8A
    .byte $42 ; | X    X | $3F8B
    .byte $FF ; |XXXXXXXX| $3F8C
    .byte $10 ; |   X    | $3F8D
    .byte $10 ; |   X    | $3F8E
    .byte $10 ; |   X    | $3F8F
    .byte $10 ; |   X    | $3F90
    .byte $FE ; |XXXXXXX | $3F91
    .byte $82 ; |X     X | $3F92
    .byte $C3 ; |XX    XX| $3F93
    .byte $FF ; |XXXXXXXX| $3F94
    .byte $FF ; |XXXXXXXX| $3F95
    .byte $E7 ; |XXX  XXX| $3F96
    .byte $C3 ; |XX    XX| $3F97
    .byte $81 ; |X      X| $3F98
    .byte $81 ; |X      X| $3F99
    .byte $81 ; |X      X| $3F9A
    .byte $81 ; |X      X| $3F9B
    .byte $C3 ; |XX    XX| $3F9C
    .byte $E7 ; |XXX  XXX| $3F9D
    .byte $FF ; |XXXXXXXX| $3F9E
    .byte $FF ; |XXXXXXXX| $3F9F
    .byte $FF ; |XXXXXXXX| $3FA0
    .byte $FF ; |XXXXXXXX| $3FA1
L3FA2:
    .byte $01 ; |       X| $3FA2
    .byte $03 ; |      XX| $3FA3
    .byte $04 ; |     X  | $3FA4
    .byte $06 ; |     XX | $3FA5
    .byte $07 ; |     XXX| $3FA6
    .byte $0A ; |    X X | $3FA7
    .byte $0B ; |    X XX| $3FA8
    .byte $0C ; |    XX  | $3FA9
    .byte $0E ; |    XXX | $3FAA
    .byte $0F ; |    XXXX| $3FAB
    .byte $10 ; |   X    | $3FAC
    .byte $11 ; |   X   X| $3FAD
    .byte $13 ; |   X  XX| $3FAE
    .byte $15 ; |   X X X| $3FAF
    .byte $16 ; |   X XX | $3FB0
    .byte $18 ; |   XX   | $3FB1
    .byte $19 ; |   XX  X| $3FB2
    .byte $1C ; |   XXX  | $3FB3
    .byte $1D ; |   XXX X| $3FB4
    .byte $1E ; |   XXXX | $3FB5
    .byte $20 ; |  X     | $3FB6
    .byte $21 ; |  X    X| $3FB7
    .byte $22 ; |  X   X | $3FB8
    .byte $23 ; |  X   XX| $3FB9
    .byte $08 ; |    X   | $3FBA
    .byte $0D ; |    XX X| $3FBB
    .byte $12 ; |   X  X | $3FBC
    .byte $1A ; |   XX X | $3FBD
    .byte $1F ; |   XXXXX| $3FBE
    .byte $24 ; |  X  X  | $3FBF
    .byte $02 ; |      X | $3FC0
    .byte $05 ; |     X X| $3FC1
    .byte $09 ; |    X  X| $3FC2
    .byte $14 ; |   X X  | $3FC3
    .byte $17 ; |   X XXX| $3FC4
    .byte $1B ; |   XX XX| $3FC5

L3FC6:
    ldx    #$10                  ; 2
L3FC8:
    ldy    L3FE6,X               ; 4
    lda    L3FD5,X               ; 4
    sta.wy 0,Y                   ; 5
    dex                          ; 2
    bpl    L3FC8                 ; 2³
    rts                          ; 6

L3FD5:
    .byte $20 ; |  X     | $3FD5
    .byte $02 ; |      X | $3FD6
    .byte $2E ; |  X XXX | $3FD7
    .byte $3C ; |  XXXX  | $3FD8
    .byte $03 ; |      XX| $3FD9
    .byte $05 ; |     X X| $3FDA
    .byte $0A ; |    X X | $3FDB
    .byte $0A ; |    X X | $3FDC
    .byte $0A ; |    X X | $3FDD
    .byte $0A ; |    X X | $3FDE
    .byte $0A ; |    X X | $3FDF
    .byte $0A ; |    X X | $3FE0
    .byte $0A ; |    X X | $3FE1
    .byte $0A ; |    X X | $3FE2
    .byte $0A ; |    X X | $3FE3
    .byte $CA ; |XX  X X | $3FE4
    .byte $82 ; |X     X | $3FE5
L3FE6:
    .byte $BA ; |X XXX X | $3FE6
    .byte $BC ; |X XXXX  | $3FE7
    .byte $C5 ; |XX   X X| $3FE8
    .byte $C6 ; |XX   XX | $3FE9
    .byte $C4 ; |XX   X  | $3FEA
    .byte $BB ; |X XXX XX| $3FEB
    .byte $DE ; |XX XXXX | $3FEC
    .byte $A7 ; |X X  XXX| $3FED
    .byte $C8 ; |XX  X   | $3FEE
    .byte $E4 ; |XXX  X  | $3FEF
    .byte $E9 ; |XXX X  X| $3FF0
    .byte $AD ; |X X XX X| $3FF1
    .byte $E6 ; |XXX  XX | $3FF2
    .byte $E7 ; |XXX  XXX| $3FF3
    .byte $E8 ; |XXX X   | $3FF4
    .byte $A6 ; |X X  XX | $3FF5
    .byte $AA ; |X X X X | $3FF6
    .byte $00 ; |        | $3FF7

    .byte $00 ; |        | $3FF8
    .byte $00 ; |        | $3FF9
    .byte $00 ; |        | $3FFA
    .byte $00 ; |        | $3FFB

       ORG $1FFC
      RORG $3FFC

    .word START_1
    .word 0


