; Rough disassembly of Plaque Attack
;
;
; Sega Genesis control conversion
; By Omegamatrix
;
; last update Nov 30, 2013
;
;
;  Sega Genesis Controls:
; Press button B to fire upwards
; Press button C to fire downwards
;   ** At the very top or bottom the toothpaste will flip,
;      and face inward no matter what button is pressed.
;
; This game uses a second controller for the second player.
; Pressing buttons B or C on either Sega Genesis controller will start the game.
; Pressing reset will also start the game.
;
;
;
; PA.cfg contents:
;
;      ORG F000
;      CODE F000 FBF9
;      GFX FBFA FDD2
;      CODE FDD3 FDFF
;      GFX FE00 FEAE
;      CODE FEAF FED1
;      GFX FED2 FFDD
;      CODE FFDE FFEA
;      GFX FFEB FFFF

      processor 6502
      include VCS.h

SEGA_GENESIS      = 1




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      RIOT RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       SEG.U RIOT_RAM
       ORG $80

ram_80             ds 1  ; x10
ram_81             ds 1  ; x13
ram_82             ds 1  ; x7
ram_83             ds 1  ; x3
ram_84             ds 1  ; x11
ram_85             ds 1  ; x2
ram_86             ds 1  ; x1
ram_87             ds 1  ; x2
ram_88             ds 1  ; x1
ram_89             ds 1  ; x7
ram_8A             ds 1  ; x1
ram_8B             ds 2  ; x9
ram_8D             ds 2  ; x3
ram_8F             ds 2  ; x1
ram_91             ds 2  ; x1
ram_93             ds 2  ; x1
ram_95             ds 2  ; x1
ram_97             ds 1  ; x5
ram_98             ds 1  ; x13
ram_99             ds 1  ; x9
ram_9A             ds 1  ; x6
ram_9B             ds 1  ; x2
ram_9C             ds 1  ; x1
ram_9D             ds 1  ; x1
ram_9E             ds 1  ; x1
ram_9F             ds 1  ; x2
ram_A0             ds 1  ; x1
ram_A1             ds 1  ; x1
ram_A2             ds 1  ; x1
ram_A3             ds 1  ; x20
ram_A4             ds 1  ; x6
ram_A5             ds 1  ; x2
ram_A6             ds 1  ; x1
ram_A7             ds 1  ; x3
ram_A8             ds 1  ; x1
ram_A9             ds 1  ; x2
ram_AA             ds 1  ; x11
ram_AB             ds 1  ; x7
ram_AC             ds 1  ; x2
ram_AD             ds 1  ; x20
ram_AE             ds 1  ; x5
ram_AF             ds 5  ; x2
ram_B4             ds 1  ; x4
ram_B5             ds 1  ; x12
ram_B6             ds 1  ; x13
ram_B7             ds 1  ; x9
ram_B8             ds 1  ; x5
ram_B9             ds 1  ; x5
ram_BA             ds 1  ; x5
ram_BB             ds 1  ; x11
ram_BC             ds 1  ; x11
ram_BD             ds 1  ; x6
ram_BE             ds 5  ; x4
ram_C3             ds 1  ; x3
ram_C4             ds 1  ; x3
ram_C5             ds 1  ; x19
ram_C6             ds 1  ; x2
ram_C7             ds 5  ; x1
ram_CC             ds 1  ; x4
ram_CD             ds 1  ; x15
ram_CE             ds 1  ; x8
ram_CF             ds 1  ; x3
ram_D0             ds 1  ; x4
ram_D1             ds 1  ; x3
ram_D2             ds 1  ; x4
ram_D3             ds 1  ; x2
ram_D4             ds 1  ; x2
ram_D5             ds 3  ; x2
ram_D8             ds 1  ; x24
ram_D9             ds 2  ; x9
ram_DB             ds 1  ; x1
ram_DC             ds 8  ; x2
ram_E4             ds 1  ; x12
ram_E5             ds 1  ; x5
ram_E6             ds 1  ; x2
ram_E7             ds 1  ; x1
ram_E8             ds 1  ; x2
ram_E9             ds 2  ; x1
ram_EB             ds 1  ; x5
ram_EC             ds 1  ; x4
ram_ED             ds 1  ; x4
ram_EE             ds 1  ; x4
ram_EF             ds 1  ; x6
ram_F0             ds 1  ; x3
ram_F1             ds 1  ; x9
ram_F2             ds 1  ; x7
ram_F3             ds 1  ; x39
ram_F4             ds 1  ; x20
ram_F5             ds 1  ; x6
ram_F6             ds 1  ; x2
ram_F7             ds 1  ; x4
ram_F8             ds 1  ; x5
ram_F9             ds 1  ; x2
ram_FA             ds 1  ; x3
ram_FB             ds 5  ; x1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      MAIN PROGRAM
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       SEG CODE
       ORG $F000

START:
  IF !SEGA_GENESIS
    sei                          ; 2
  ENDIF
    cld                          ; 2
    ldx    #$00                  ; 2
LF004:
    lda    #$00                  ; 2
LF006:
    sta    VSYNC,X               ; 4
    txs                          ; 2
    inx                          ; 2
    stx    CTRLPF                ; 3
    bne    LF006                 ; 2³
    jsr    LF9F1                 ; 6
    ldx    ram_82                ; 3
    bne    LF01B                 ; 2³
    inx                          ; 2
    stx    ram_82                ; 3
    jmp    LF6BC                 ; 3

LF01B:
    lda    ram_B4                ; 3
    ldx    #$08                  ; 2
    cmp    #$80                  ; 2
    bcc    LF029                 ; 2³
    sbc    #$80                  ; 2
    jsr    LFECD                 ; 6
    tax                          ; 2
LF029:
    lda    ram_CC                ; 3
    and    LFDC8,X               ; 4
    sta    ram_F8                ; 3
    beq    LF044                 ; 2³
    tax                          ; 2
    lda    LFFF0,X               ; 4
    sta    ram_F8                ; 3
    lda    LFFEB,X               ; 4
    clc                          ; 2
    adc    ram_B4                ; 3
    cmp    #$A0                  ; 2
    bcc    LF044                 ; 2³
    sbc    #$60                  ; 2
LF044:
    sta    ram_F7                ; 3
    ldx    #$01                  ; 2
LF048:
    ldy    #$1E                  ; 2
    lda    ram_E4,X              ; 4
    beq    LF062                 ; 2³
    lda    ram_81                ; 3
    and    #$03                  ; 2
    bne    LF067                 ; 2³
    dec    ram_E4,X              ; 6
    beq    LF062                 ; 2³
    lda    ram_81                ; 3
    and    #$07                  ; 2
    bne    LF067                 ; 2³
    ldy    #$0C                  ; 2
    bpl    LF067                 ; 3   always branch

LF062:
    sta    ram_A7,X              ; 4
    sta    ram_FA,X              ; 4
    tay                          ; 2
LF067:
    sty    ram_A5,X              ; 4
    dex                          ; 2
    bpl    LF048                 ; 2³
    ldx    ram_F1                ; 3
    cpx    #$0B                  ; 2
    bcc    LF074                 ; 2³
    ldx    #$0B                  ; 2
LF074:
    lda    LFE97,X               ; 4
    bit    ram_F2                ; 3
    bpl    LF07E                 ; 2³
    lda    LFEA3,X               ; 4
LF07E:
    sta    ram_89                ; 3
    ldx    ram_E5                ; 3
    jsr    LF288                 ; 6
    sta    ram_E6                ; 3
    ldx    ram_E4                ; 3
    jsr    LF288                 ; 6
    sta    ram_E8                ; 3
    ldx    ram_9A                ; 3
    lda    LFDD1,X               ; 4
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
LF097:
    lda    INTIM                 ; 4
    bne    LF097                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    ram_97                ; 3
    rol                          ; 2
    rol                          ; 2
    rol                          ; 2
    and    #$02                  ; 2
    sta    VBLANK                ; 3
    jsr    LFB88                 ; 6
    lda    #$50                  ; 2
    ldx    #$0A                  ; 2
LF0B0:
    sta    ram_8B,X              ; 4
    dex                          ; 2
    dex                          ; 2
    bpl    LF0B0                 ; 2³
    ldy    #$CE                  ; 2
    sta    HMCLR                 ; 3
    ldx    ram_B7                ; 3
    dex                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    bmi    LF0CA                 ; 2³
    txa                          ; 2
    asl                          ; 2
    tax                          ; 2
LF0C4:
    sty    ram_8B,X              ; 4
    dex                          ; 2
    dex                          ; 2
    bpl    LF0C4                 ; 2³
LF0CA:
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$0C                  ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    jsr    LFB88                 ; 6
    ldx    ram_FB                ; 3
    lda    LFFF0,X               ; 4
    sta    NUSIZ0                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    ldy    #$FF                  ; 2
    sty    PF1                   ; 3
    sty    PF2                   ; 3
    sty    PF2                   ; 3
    lda    ram_A8                ; 3
    sec                          ; 2
LF0E9:
    sbc    #$0F                  ; 2
    bcs    LF0E9                 ; 2³
    sta    RESP0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    eor    #$70                  ; 2
    sta    HMP0                  ; 3
    lda    ram_B6                ; 3
    sec                          ; 2
    sbc    #$67                  ; 2
    cmp    #$08                  ; 2
    bcs    LF106                 ; 2³
    lda    #$02                  ; 2
    sta    ENABL                 ; 3
LF106:
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$44                  ; 2
    sta    COLUPF                ; 3
    sta    VDELP0                ; 3
    sta    VDELP1                ; 3
    lda    ram_AC                ; 3
    sec                          ; 2
LF113:
    sbc    #$0F                  ; 2
    bcs    LF113                 ; 2³
    sta    RESBL                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    eor    #$70                  ; 2
    sta    HMBL                  ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    ram_A6                ; 3
    sta    COLUP0                ; 3
    jsr    LFECD                 ; 6
    jsr    LFECD                 ; 6
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    sta    HMCLR                 ; 3
    sta    HMCLR                 ; 3
    tay                          ; 2
LF139:
    lda    LFE72,Y               ; 4
    ldx    LFE62,Y               ; 4
    sta    PF2                   ; 3
    stx    PF1                   ; 3
    lda    LFD90,Y               ; 4
    sta    GRP1                  ; 3
    lda    (ram_E6),Y            ; 5
    sta    GRP0                  ; 3
    lda    ram_9F                ; 3
    sta    RESP1                 ; 3
    sta    NUSIZ1                ; 3
    nop                          ; 2
    lda    ram_A0                ; 3
    sta    RESP1                 ; 3
    sta    NUSIZ1                ; 3
    nop                          ; 2
    lda    ram_A1                ; 3
    sta    RESP1                 ; 3
    sta    NUSIZ1                ; 3
    lda    ram_A2                ; 3
    iny                          ; 2
    sta    RESP1                 ; 3
    sta    NUSIZ1                ; 3
    cpy    #$0E                  ; 2
    bcc    LF139                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$00                  ; 2
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    sta    NUSIZ1                ; 3
    lda    ram_AB                ; 3
    sec                          ; 2
LF178:
    sbc    #$0F                  ; 2
    bcs    LF178                 ; 2³
    sta    RESP0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    eor    #$70                  ; 2
    sta    HMP0                  ; 3
    ldx    ram_9A                ; 3
    lda    LFDD1,X               ; 4
    sta    COLUP0                ; 3
    ldy    #$07                  ; 2
    sty    ram_F4                ; 3
    lda    #$00                  ; 2
    sta    CXCLR                 ; 3
    sta    NUSIZ0                ; 3
    ldx    #$68                  ; 2
  IF SEGA_GENESIS
    BNE    LF1FB
  ELSE
    jmp    LF1FB                 ; 3
  ENDIF

LF19E:
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    GRP0                  ; 3
    dex                          ; 2
    beq    LF1EC                 ; 2³
    lda.wy ram_AD,Y              ; 4
    stx    ram_F3                ; 3
    ldx    #$08                  ; 2
    cmp    #$80                  ; 2
    bcc    LF1B7                 ; 2³
    sbc    #$80                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
LF1B7:
    lda.wy ram_C5,Y              ; 4
    and    LFDC8,X               ; 4
    bne    LF1C5                 ; 2³
    sta    ram_F8                ; 3
    ldx    ram_F3                ; 3
    bpl    LF1DA                 ; 2³
LF1C5:
    tax                          ; 2
    lda    LFFF0,X               ; 4
    sta    ram_F8                ; 3
    lda    LFFEB,X               ; 4
    clc                          ; 2
    adc.wy ram_AD,Y              ; 4
    cmp    #$A0                  ; 2
    ldx    ram_F3                ; 3
    bcc    LF1DA                 ; 2³
    sbc    #$60                  ; 2
LF1DA:
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    ram_F7                ; 3
    txa                          ; 2
    sec                          ; 2
    sbc    ram_B5                ; 3
    tay                          ; 2
    cpy    #$17                  ; 2
    bcs    LF1EB                 ; 2³
    lda    (ram_89),Y            ; 5
    sta    GRP0                  ; 3
LF1EB:
    dex                          ; 2
LF1EC:
    beq    LF224                 ; 2³+1
    txa                          ; 2
    sec                          ; 2
    sbc    ram_B5                ; 3
    tay                          ; 2
    lda    #$00                  ; 2
    cpy    #$17                  ; 2
    bcs    LF1FB                 ; 2³
    lda    (ram_89),Y            ; 5
LF1FB:
    ldy    ram_F8                ; 3
    sty    NUSIZ1                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    GRP0                  ; 3
    dex                          ; 2
    beq    LF224                 ; 2³
    lda    ram_F7                ; 3

  IF SEGA_GENESIS
    NOP
    NOP
    SEC
LF20B:
    SBC    #$0F
    BCS    LF20B
    STA    RESP1

  ELSE
    lda    ram_F7                ; 3
    sec                          ; 2
LF20B:
    sbc    #$0F                  ; 2
    bcs    LF20B                 ; 2³
    sta.w  RESP1                 ; 4
  ENDIF

    sta    WSYNC                 ; 3
;---------------------------------------
    sta    ram_F3                ; 3
    txa                          ; 2
    sec                          ; 2
    sbc    ram_B5                ; 3
    tay                          ; 2
    cpy    #$17                  ; 2
    bcs    LF223                 ; 2³
    lda    (ram_89),Y            ; 5
    sta    GRP0                  ; 3
LF223:
    dex                          ; 2
LF224:
    beq    LF297                 ; 2³
    lda    ram_F3                ; 3
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    eor    #$70                  ; 2
    sta    HMP1                  ; 3
    ldy    ram_F4                ; 3
    lda    CXP1FB                ; 3
    sta.wy ram_DC,Y              ; 5
    txa                          ; 2
    sec                          ; 2
    sbc    ram_B5                ; 3
    tay                          ; 2
    cpy    #$17                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    bcs    LF248                 ; 2³
    lda    (ram_89),Y            ; 5
    sta    GRP0                  ; 3
LF248:
    lda    ram_F4                ; 3
    ldy    ram_AA                ; 3
    cmp    #$07                  ; 2
    bcs    LF252                 ; 2³
    ldy    #$0D                  ; 2
LF252:
    dec    ram_F4                ; 5
    bpl    LF292                 ; 2³
LF256:
    bit    ram_98                ; 3
    bmi    LF286                 ; 2³
    sed                          ; 2
    clc                          ; 2
    adc    ram_BA                ; 3
    sta    ram_BA                ; 3
    bcc    LF286                 ; 2³
    lda    ram_B9                ; 3
    adc    #$00                  ; 2
    sta    ram_B9                ; 3
    lda    ram_B8                ; 3
    adc    #$00                  ; 2
    bcc    LF276                 ; 2³
    lda    #$99                  ; 2
    sta    ram_B9                ; 3
    sta    ram_BA                ; 3
    inc    ram_99                ; 5
LF276:
    sta    ram_B8                ; 3
    lda    ram_B9                ; 3
    and    #$1F                  ; 2
    bne    LF286                 ; 2³
    lda    ram_B7                ; 3
    cmp    #$06                  ; 2
    bcs    LF286                 ; 2³
    inc    ram_B7                ; 5
LF286:
    cld                          ; 2
    rts                          ; 6

LF288:
    cpx    #$04                  ; 2
    bcc    LF28E                 ; 2³
    ldx    #$04                  ; 2
LF28E:
    lda    LFE82,X               ; 4
    rts                          ; 6

LF292:
    sta    CXCLR                 ; 3
    sta    HMCLR                 ; 3
LF296:
    dex                          ; 2
LF297:
    beq    LF2DC                 ; 2³
    sty    ram_F3                ; 3
    txa                          ; 2
    sec                          ; 2
    sbc    ram_B5                ; 3
    tay                          ; 2
    cpy    #$17                  ; 2
    lda    #$00                  ; 2
    bcs    LF2A8                 ; 2³
    lda    (ram_89),Y            ; 5
LF2A8:
    ldy    ram_F3                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    sta    GRP0                  ; 3
    lda    (ram_85),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_87),Y            ; 5
    sta    COLUP1                ; 3
    txa                          ; 2
    sec                          ; 2
    sbc    ram_B6                ; 3
    and    #$F8                  ; 2
    bne    LF2C2                 ; 2³
    lda    #$02                  ; 2
LF2C2:
    sta    ENABL                 ; 3
    dey                          ; 2
    bpl    LF296                 ; 2³
    dex                          ; 2
    beq    LF2DC                 ; 2³
    txa                          ; 2
    sec                          ; 2
    sbc    ram_B5                ; 3
    tay                          ; 2
    lda    #$00                  ; 2
    cpy    #$17                  ; 2
    bcs    LF2D7                 ; 2³
    lda    (ram_89),Y            ; 5
LF2D7:
    ldy    ram_F4                ; 3
    jmp    LF19E                 ; 3

LF2DC:
    sta    WSYNC                 ; 3
;---------------------------------------
    stx    GRP0                  ; 3
    stx    GRP1                  ; 3
    lda    #$0C                  ; 2
    sta    COLUP1                ; 3
    lda    ram_A7                ; 3
    sec                          ; 2
LF2E9:
    sbc    #$0F                  ; 2
    bcs    LF2E9                 ; 2³
    sta    RESP0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    eor    #$70                  ; 2
    sta    HMP0                  ; 3
    ldx    ram_F4                ; 3
    lda    CXP1FB                ; 3
    sta    ram_DC,X              ; 4
    jsr    LFECD                 ; 6
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    jsr    LFECE                 ; 6
    jsr    LFECF                 ; 6
    lda    ram_A5                ; 3
    sta    COLUP0                ; 3
    sta    CXCLR                 ; 3
    ldx    ram_FA                ; 3
    lda    LFFF0,X               ; 4
    sta    NUSIZ0                ; 3
    sta    HMCLR                 ; 3
    ldy    #$0D                  ; 2
LF31F:
    lda    LFE72,Y               ; 4
    ldx    LFE62,Y               ; 4
    nop                          ; 2
    sta    PF2                   ; 3
    stx    PF1                   ; 3
    lda    LFD90,Y               ; 4
    sta    GRP1                  ; 3
    lda    (ram_E8),Y            ; 5
    sta    GRP0                  ; 3
    lda    ram_9B                ; 3
    sta    RESP1                 ; 3
    sta    NUSIZ1                ; 3
    nop                          ; 2
    lda    ram_9C                ; 3
    sta    RESP1                 ; 3
    sta    NUSIZ1                ; 3
    nop                          ; 2
    lda    ram_9D                ; 3
    sta    RESP1                 ; 3
    sta    NUSIZ1                ; 3
    lda    ram_9E                ; 3
    dey                          ; 2
    sta    RESP1                 ; 3
    sta    NUSIZ1                ; 3
    bpl    LF31F                 ; 2³
    iny                          ; 2
    sty    ENABL                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sty    PF1                   ; 3
    sty    PF2                   ; 3
    sty    COLUPF                ; 3
    lda    #$0C                  ; 2
    sta    COLUP0                ; 3
    ldy    #$07                  ; 2
    lda    ram_99                ; 3
    and    #$1F                  ; 2
    cmp    #$14                  ; 2
    bcs    LF376                 ; 2³
    ldy    #$00                  ; 2
    cmp    #$0C                  ; 2
    bcc    LF376                 ; 2³
    sbc    #$0C                  ; 2
    tay                          ; 2
LF376:
    sty    ram_F4                ; 3
    tya                          ; 2
    eor    #$07                  ; 2
    sta    ram_F5                ; 3
    lda    #$A8                  ; 2
    ldx    #$08                  ; 2
    sec                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
LF386:
    sta    ram_8D,X              ; 4
    sbc    #$08                  ; 2
    sta    ram_8B,X              ; 4
    sbc    #$08                  ; 2
    dex                          ; 2
    dex                          ; 2
    dex                          ; 2
    dex                          ; 2
    bpl    LF386                 ; 2³
    jsr    LFB8C                 ; 6
    lda    #$78                  ; 2
    sta    PF1                   ; 3
    lda    #$31                  ; 2
    sta    CTRLPF                ; 3
    sta    NUSIZ1                ; 3
    sta    HMCLR                 ; 3
    lda    #$10                  ; 2
    sta    HMBL                  ; 3
    ldy    #$07                  ; 2
    sty    ENABL                 ; 3
LF3AB:
    lda    LFF78,Y               ; 4
    tax                          ; 2
    lda    LFF58,Y               ; 4
    sta    GRP0                  ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    LFFB0,Y               ; 4
    sta    COLUPF                ; 3
    lda    LFF60,Y               ; 4
    sta    GRP1                  ; 3
    lda    LFF68,Y               ; 4
    sta    GRP0                  ; 3
    lda    ram_F3                ; 3

  IF SEGA_GENESIS
    LDA    LFF70,Y
    DEY
    STA    GRP1
    STX    GRP0
    STA    GRP1
    LDA    #$00
    STA    COLUPF
    LDX    #$02  ; <-- don't dump inputs
    DEC    ram_F5
    BPL    LF3AB
    LDY    #$23

  ELSE
    nop                          ; 2
    lda    LFF70,Y               ; 4
    sta    GRP1                  ; 3
    stx    GRP0                  ; 3
    sta    GRP1                  ; 3
    lda    #$00                  ; 2
    sta    COLUPF                ; 3
    dey                          ; 2
    dec    ram_F5                ; 5
    bpl    LF3AB                 ; 2³
    ldy    #$23                  ; 2
    ldx    #$82                  ; 2
  ENDIF

    sta    WSYNC                 ; 3
;---------------------------------------
    sty    TIM64T                ; 4
    stx    VBLANK                ; 3
    sta    VDELP0                ; 3
    sta    VDELP1                ; 3
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    sta    GRP0                  ; 3
    sta    PF1                   ; 3
    sta    ENABL                 ; 3
    lda    ram_99                ; 3
    beq    LF415                 ; 2³+1
    bit    ram_98                ; 3
    bmi    LF415                 ; 2³+1
    lda    ram_BA                ; 3
    and    #$0F                  ; 2
    beq    LF407                 ; 2³
    cmp    #$05                  ; 2
    bne    LF415                 ; 2³
LF407:
    lda    ram_81                ; 3
    and    #$7F                  ; 2
    bne    LF415                 ; 2³
    lda    ram_80                ; 3
    lsr                          ; 2
    bcc    LF415                 ; 2³
    jsr    LFB49                 ; 6
LF415:
    bit    ram_98                ; 3
    bmi    LF433                 ; 2³
    lda    ram_E4                ; 3
    ora    ram_E5                ; 3
    beq    LF43D                 ; 2³
    tay                          ; 2
    eor    #$1F                  ; 2
    sta    AUDF0                 ; 3
    lda    #$08                  ; 2
    sta    AUDV0                 ; 3
    lda    #$01                  ; 2
    sta    AUDC0                 ; 3
    tya                          ; 2
    bne    LF433                 ; 2³
    sta    AUDV0                 ; 3
    beq    LF43D                 ; 3  always branch

LF433:
    lda    #$00                  ; 2
    sta    ram_ED                ; 3
    sta    ram_EE                ; 3
    sta    ram_EF                ; 3
    beq    LF47F                 ; 3  always branch

LF43D:
    lda    ram_ED                ; 3
    beq    LF455                 ; 2³
    dec    ram_ED                ; 5
    lsr                          ; 2
    sta    AUDV0                 ; 3
    sta    AUDV1                 ; 3
    lda    #$0C                  ; 2
    sta    AUDC0                 ; 3
    sta    AUDC1                 ; 3
    sta    AUDF0                 ; 3
    clc                          ; 2
    adc    #$03                  ; 2
    sta    AUDF1                 ; 3
LF455:
    lda    ram_EE                ; 3
    beq    LF462                 ; 2³
    lsr                          ; 2
    sta    ram_EE                ; 3
    sta    AUDV0                 ; 3
    sta    AUDV1                 ; 3
  IF SEGA_GENESIS
    .byte $0C
  ELSE
    bpl    LF464                 ; 3  always branch
  ENDIF

LF462:
    sta    ram_EB                ; 3
LF464:
    lda    ram_EF                ; 3
    bmi    LF47F                 ; 2³
    sta    AUDV0                 ; 3
    eor    #$1F                  ; 2
    sta    AUDF0                 ; 3
    lda    #$0C                  ; 2
    sta    AUDC0                 ; 3
    lda    ram_D8                ; 3
    and    #$0F                  ; 2
    bne    LF47D                 ; 2³
    lda    ram_81                ; 3
    lsr                          ; 2
    bcs    LF47F                 ; 2³
LF47D:
    dec    ram_EF                ; 5
LF47F:
    lda    ram_F0                ; 3
    bmi    LF49E                 ; 2³
    bit    ram_98                ; 3
    bmi    LF49C                 ; 2³
    sta    AUDV1                 ; 3
    sta    AUDF1                 ; 3
    lda    #$08                  ; 2
    sta    AUDC1                 ; 3
    lda    ram_81                ; 3
    and    #$03                  ; 2
    bne    LF497                 ; 2³
    sta    AUDV1                 ; 3
LF497:
    lda    ram_81                ; 3
    lsr                          ; 2
    bcc    LF49E                 ; 2³
LF49C:
    dec    ram_F0                ; 5
LF49E:
    lda    ram_A3                ; 3
    sta    ram_F3                ; 3
    lda    ram_A4                ; 3
    sta    ram_F4                ; 3
    ldx    #$03                  ; 2
LF4A8:
    lda    ram_F3                ; 3
    and    #$03                  ; 2
    tay                          ; 2
    lda    LFCFC,Y               ; 4
    sta    ram_9B,X              ; 4
    lda    ram_F4                ; 3
    and    #$03                  ; 2
    tay                          ; 2
    lda    LFCFC,Y               ; 4
    sta    ram_9F,X              ; 4
    lsr    ram_F3                ; 5
    lsr    ram_F3                ; 5
    lsr    ram_F4                ; 5
    lsr    ram_F4                ; 5
    dex                          ; 2
    bpl    LF4A8                 ; 2³
    ldx    #$07                  ; 2
LF4C9:
    lda    ram_DB,X              ; 4
    asl                          ; 2
    asl                          ; 2
    bcc    LF508                 ; 2³+1
    lda    ram_EC                ; 3
    jsr    LF256                 ; 6
    lda    #$0F                  ; 2
    sta    ram_F0                ; 3
    lda    ram_AB                ; 3
    clc                          ; 2
    adc    #$08                  ; 2
    sec                          ; 2
    sbc    ram_AD,X              ; 4
    jsr    LFECD                 ; 6
    tay                          ; 2
    lda    ram_C5,X              ; 4
    and    #$0F                  ; 2
    and    LFED2,Y               ; 4
    sta    ram_F3                ; 3
    lda    ram_C5,X              ; 4
    and    #$F0                  ; 2
    ora    ram_F3                ; 3
    sta    ram_C5,X              ; 4
    and    #$0F                  ; 2
    bne    LF504                 ; 2³+1
    lda    #$C0                  ; 2
    sta    ram_AD,X              ; 4
    lda    ram_CD                ; 3
    and    LFFB8,X               ; 4
    sta    ram_CD                ; 3
LF504:
    lda    #$E0                  ; 2
    sta    ram_B6                ; 3
LF508:
    dex                          ; 2
    bpl    LF4C9                 ; 2³+1
    lda    ram_D8                ; 3
    and    #$0F                  ; 2
    ora    ram_E4                ; 3
    ora    ram_E5                ; 3
    bne    LF564                 ; 2³
    ldx    #$07                  ; 2
LF517:
    lda    ram_C5,X              ; 4
    and    #$0F                  ; 2
    bne    LF564                 ; 2³
    dex                          ; 2
    bpl    LF517                 ; 2³
    ldx    #$07                  ; 2
LF522:
    lda    ram_C5,X              ; 4
    ora    #$07                  ; 2
    sta    ram_C5,X              ; 4
    cpx    #$02                  ; 2
    bcc    LF530                 ; 2³
    lda    #$C0                  ; 2
    sta    ram_AD,X              ; 4
LF530:
    dex                          ; 2
    bpl    LF522                 ; 2³
    lda    #$02                  ; 2
    sta    ram_D8                ; 3
    lda    #$E0                  ; 2
    sta    ram_B6                ; 3
    lda    #$20                  ; 2
    sta    ram_D9                ; 3
    lda    ram_A3                ; 3
    sta    ram_BC                ; 3
    lda    ram_A4                ; 3
    sta    ram_BD                ; 3
    inc    ram_BB                ; 5
    bit    ram_98                ; 3
    bpl    LF55B                 ; 2³
    lda    #$03                  ; 2
    sta    ram_B7                ; 3
    stx    ram_BC                ; 3
    stx    ram_BD                ; 3
    lda    ram_BB                ; 3
    and    #$0F                  ; 2
    sta    ram_BB                ; 3
LF55B:
    lsr    ram_F9                ; 5
    bcc    LF564                 ; 2³
    inx                          ; 2
    stx    ram_A3                ; 3
    stx    ram_A4                ; 3
LF564:
    lda    ram_BB                ; 3
    ldy    ram_80                ; 3
    cpy    #$02                  ; 2
    bcc    LF56D                 ; 2³
    lsr                          ; 2
LF56D:
    tay                          ; 2
    lda    #$00                  ; 2
    cpy    #$03                  ; 2
    bcc    LF578                 ; 2³
    tya                          ; 2
  IF SEGA_GENESIS
    ADC    #6-1
  ELSE
    clc                          ; 2
    adc    #$06                  ; 2
  ENDIF
LF578:
    sta    ram_CF                ; 3
    tya                          ; 2
    clc                          ; 2
    adc    #$02                  ; 2
    cmp    #$10                  ; 2
    bcc    LF584                 ; 2³
    lda    #$10                  ; 2
LF584:
    sta    ram_D0                ; 3
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    ram_D1                ; 3
    lda    ram_81                ; 3
    and    #$40                  ; 2
    bne    LF5A0                 ; 2³
    tax                          ; 2
    lda    ram_BB                ; 3
    and    #$06                  ; 2
    bne    LF59A                 ; 2³
    stx    ram_CF                ; 3
LF59A:
    cmp    #$06                  ; 2
    bne    LF5A0                 ; 2³
    stx    ram_D0                ; 3
LF5A0:
    lda    ram_E4                ; 3
    ora    ram_E5                ; 3
    beq    LF5AA                 ; 2³
    lda    #$00                  ; 2
    sta    ram_D0                ; 3
LF5AA:
    lda    ram_BB                ; 3
    and    #$07                  ; 2
    tax                          ; 2
    lda    LFE87,X               ; 4
    sta    ram_85                ; 3
    lda    LFE8F,X               ; 4
    sta    ram_87                ; 3
    lda    ram_D8                ; 3
    and    #$0F                  ; 2
    bne    LF5DA                 ; 2³
    lda    ram_F1                ; 3
    bne    LF5DA                 ; 2³
    lda    ram_B6                ; 3
    cmp    #$E0                  ; 2
    bne    LF5DA                 ; 2³
    ldx    #$01                  ; 2
    stx    ram_F9                ; 3
LF5CD:
    lda    ram_C5,X              ; 4
    and    #$F0                  ; 2
    sta    ram_C5,X              ; 4
    dex                          ; 2
    bpl    LF5CD                 ; 2³
    asl    ram_D0                ; 5
    asl    ram_D1                ; 5
LF5DA:
    ldx    #$02                  ; 2
LF5DC:
    lda    ram_CF,X              ; 4
    sta    ram_F3                ; 3
    jsr    LFECD                 ; 6
    sta    ram_D2,X              ; 4
    lda    ram_F3                ; 3
    and    #$0F                  ; 2
    clc                          ; 2
    adc    ram_D5,X              ; 4
    cmp    #$10                  ; 2
    bcc    LF5F2                 ; 2³
    inc    ram_D2,X              ; 6
LF5F2:
    and    #$0F                  ; 2
    sta    ram_D5,X              ; 4
    dex                          ; 2
    bpl    LF5DC                 ; 2³
    ldx    #$02                  ; 2
LF5FB:
    txa                          ; 2
    asl                          ; 2
    asl                          ; 2
    tay                          ; 2
    lda    ram_B8,X              ; 4
    and    #$F0                  ; 2
    lsr                          ; 2
    sta.wy ram_8B,Y              ; 5
    lda    ram_B8,X              ; 4
    and    #$0F                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta.wy ram_8D,Y              ; 5
    dex                          ; 2
    bpl    LF5FB                 ; 2³+1
    ldx    #$00                  ; 2
    ldy    #$50                  ; 2
LF618:
    lda    ram_8B,X              ; 4
    bne    LF624                 ; 2³
    sty    ram_8B,X              ; 4
    inx                          ; 2
    inx                          ; 2
    cpx    #$0A                  ; 2
    bcc    LF618                 ; 2³
LF624:
    lda    INTIM                 ; 4
    bne    LF624                 ; 2³

  IF SEGA_GENESIS
    LDA    #$0E
.loopVSYNC:
    STA    WSYNC
    STA    VSYNC
    LSR
    BNE    .loopVSYNC

  ELSE
    ldy    #$82                  ; 2
    sty    WSYNC                 ; 3
;---------------------------------------
    sty    VSYNC                 ; 3
    sty    WSYNC                 ; 3
    sty    WSYNC                 ; 3
    sty    WSYNC                 ; 3
;---------------------------------------
    sta    VSYNC                 ; 3
  ENDIF

    inc    ram_81                ; 5
    bne    LF64E                 ; 2³
    inc    ram_98                ; 5
    lda    ram_98                ; 3
    and    #$C7                  ; 2
    sta    ram_98                ; 3
    and    #$07                  ; 2
    bne    LF64E                 ; 2³
    inc    ram_97                ; 5
    bne    LF64E                 ; 2³
    sec                          ; 2
    ror    ram_97                ; 5
LF64E:
    lda    #$35                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    TIM64T                ; 4
    ldy    SWCHA                 ; 4
    lda    ram_81                ; 3
    and    #$07                  ; 2
    bne    LF676                 ; 2³
    lda    ram_99                ; 3
    beq    LF676                 ; 2³
    ldy    #$FF                  ; 2
    dec    ram_99                ; 5
    bne    LF676                 ; 2³
    dec    ram_99                ; 5
    lda    ram_98                ; 3
    bmi    LF676                 ; 2³
    ora    #$80                  ; 2
    sta    ram_98                ; 3
    ldx    #$F3                  ; 2
    bne    LF6AA                 ; 3   always branch

LF676:
    lda    ram_9A                ; 3
    lsr                          ; 2
    tya                          ; 2
    bcs    LF67F                 ; 2³
    jsr    LFECD                 ; 6
LF67F:
    and    #$0F                  ; 2
    sta    ram_84                ; 3

  IF SEGA_GENESIS
    LDA    INPT1
    LDX    ram_9A
    BEQ    .skip1
    LDA    INPT3
.skip1:
    AND    INPT4,X

  ELSE
    ldx    ram_9A                ; 3
    lda    INPT4,X               ; 4
  ENDIF

    and    #$80                  ; 2
    ora    ram_84                ; 3
    sta    ram_84                ; 3
    lda    SWCHB                 ; 4
    cpx    #$00                  ; 2
    beq    LF695                 ; 2³
    lsr                          ; 2
LF695:
    and    #$40                  ; 2
    ora    ram_84                ; 3
    sta    ram_84                ; 3
    iny                          ; 2
    beq    LF6A2                 ; 2³
  IF SEGA_GENESIS
    LDY    #0
    STY    ram_97
  ELSE
    lda    #$00                  ; 2
    sta    ram_97                ; 3
  ENDIF
LF6A2:

  IF SEGA_GENESIS
    LDA    ram_99
    BEQ    .gamePlaying
    LDA    INPT1
    AND    INPT3
    AND    INPT4
    AND    INPT5
    BPL    .gameReset
.gamePlaying:
  ENDIF

    lda    SWCHB                 ; 4
    lsr                          ; 2
    bcs    LF6AD                 ; 2³
.gameReset:
    ldx    #$97                  ; 2
LF6AA:
  IF SEGA_GENESIS
    BRK
  ELSE
    jmp    LF004                 ; 3
  ENDIF

LF6AD:
  IF !SEGA_GENESIS
    ldy    #$00                  ; 2
  ENDIF
    lsr                          ; 2
    bcs    LF6D8                 ; 2³
    lda    ram_83                ; 3
    beq    LF6BA                 ; 2³
    dec    ram_83                ; 5
    bpl    LF6DA                 ; 2³
LF6BA:
    inc    ram_80                ; 5
LF6BC:
    lda    ram_80                ; 3
    and    #$03                  ; 2
    sta    ram_80                ; 3
    sta    ram_97                ; 3
    sta    ram_98                ; 3
    ora    #$A0                  ; 2
    tay                          ; 2
    iny                          ; 2
    sty    ram_BA                ; 3
    lda    #$AA                  ; 2
    sta    ram_B8                ; 3
    sta    ram_B9                ; 3
    lda    #$FF                  ; 2
    sta    ram_99                ; 3
    ldy    #$1E                  ; 2
LF6D8:
    sty    ram_83                ; 3
LF6DA:
    lda    ram_98                ; 3
    bpl    LF6F6                 ; 2³
    lda    #$07                  ; 2
    bit    ram_81                ; 3
    bpl    LF6E6                 ; 2³
    lda    #$0B                  ; 2
LF6E6:
    sta    ram_84                ; 3
    lda    #$0E                  ; 2
    bit    ram_82                ; 3
    bvc    LF6F0                 ; 2³
    lda    #$0D                  ; 2
LF6F0:
    and    ram_84                ; 3
    sta    ram_84                ; 3
    bpl    LF6FA                 ; 3  always branch

LF6F6:
    lda    ram_99                ; 3
    bne    LF704                 ; 2³+1
LF6FA:
    ldx    ram_D9                ; 3
    beq    LF707                 ; 2³+1
    dex                          ; 2
  IF SEGA_GENESIS
    BMI    LF704
  ELSE
    bpl    LF702                 ; 2³
    inx                          ; 2
LF702:
  ENDIF
    stx    ram_D9                ; 3
LF704:
    jmp    LF9EE                 ; 3

LF707:
    lda    ram_D8                ; 3
    and    #$02                  ; 2
  IF SEGA_GENESIS
    BEQ    LF778
  ELSE
    bne    LF710                 ; 2³
    jmp    LF778                 ; 3
  ENDIF

LF710:
    lda    ram_81                ; 3
    and    #$07                  ; 2
  IF SEGA_GENESIS
    BNE    LF776
  ELSE
    beq    LF719                 ; 2³
    jmp    LF776                 ; 3
  ENDIF

LF719:
    lda    ram_F1                ; 3
    beq    LF72D                 ; 2³
    lda    #$0F                  ; 2
    dec    ram_F1                ; 5
    bne    LF723                 ; 2³
LF723:
    sta    ram_EF                ; 3
    lda    ram_EC                ; 3
    jsr    LF256                 ; 6
LF72A:
    jmp    LF9EE                 ; 3

LF72D:
    ldy    #$01                  ; 2
LF72F:
    ldx    #$07                  ; 2
LF731:
    stx    ram_F3                ; 3
    lda.wy ram_A3,Y              ; 4
    and    LFFC0,X               ; 4
    beq    LF75B                 ; 2³
    eor.wy ram_A3,Y              ; 4
    sta.wy ram_A3,Y              ; 5
    sta.wy ram_A3,Y              ; 5
    ldx    ram_BB                ; 3
    dex                          ; 2
    cpx    #$04                  ; 2
    bcc    LF74D                 ; 2³
    ldx    #$04                  ; 2
LF74D:
    lda    ram_EC                ; 3
    jsr    LF256                 ; 6
    dex                          ; 2
    bpl    LF74D                 ; 2³
    lda    #$10                  ; 2
    sta    ram_ED                ; 3
    bpl    LF72A                 ; 3   always branch

LF75B:
    ldx    ram_F3                ; 3
    dex                          ; 2
    bpl    LF731                 ; 2³
    dey                          ; 2
    bpl    LF72F                 ; 2³
    ldy    #$30                  ; 2
    ldx    #$01                  ; 2
    lda    ram_80                ; 3
    lsr                          ; 2
    bcc    LF76E                 ; 2³
    ldx    #$05                  ; 2
LF76E:
    sty    ram_D9                ; 3
    stx    ram_D8                ; 3
    lda    #$0F                  ; 2
    sta    ram_EB                ; 3
LF776:
    bpl    LF72A                 ; 2³
LF778:
    lda    ram_D8                ; 3
    and    #$04                  ; 2
    beq    LF78D                 ; 2³
    lda    ram_BE                ; 3
    ora    ram_C3                ; 3
    ora    ram_C4                ; 3
    beq    LF789                 ; 2³
    jsr    LFB49                 ; 6
LF789:
    lda    #$01                  ; 2
    sta    ram_D8                ; 3
LF78D:
    lda    ram_D8                ; 3
    lsr                          ; 2
    bcs    LF795                 ; 2³
    jmp    LF853                 ; 3

LF795:
    lda    ram_B7                ; 3
    ora    ram_BC                ; 3
    ora    ram_BD                ; 3
    ora    ram_E4                ; 3
    ora    ram_E5                ; 3
    ora    ram_F1                ; 3
    bne    LF7BC                 ; 2³
    lda    ram_BE                ; 3
    ora    ram_C3                ; 3
    ora    ram_C4                ; 3
    bne    LF7B1                 ; 2³
    dec    ram_99                ; 5
    lda    #$E0                  ; 2
    sta    ram_B6                ; 3
LF7B1:
    lda    #$50                  ; 2
    sta    ram_D9                ; 3
    lda    #$05                  ; 2
    sta    ram_D8                ; 3
LF7B9:
    jmp    LF9EE                 ; 3

LF7BC:
    lda    #$21                  ; 2
    ldx    ram_80                ; 3
    cpx    #$02                  ; 2
    bcc    LF7C6                 ; 2³
    lda    #$30                  ; 2
LF7C6:
    sta    ram_F1                ; 3
    lda    #$4F                  ; 2
    sta    ram_AB                ; 3
    lda    ram_BB                ; 3
    lsr                          ; 2
    lda    #$00                  ; 2
    ldx    #$07                  ; 2
    sta    ram_AA                ; 3
    bcc    LF7DF                 ; 2³
    ldx    #$12                  ; 2
    stx    ram_AA                ; 3
    ldx    #$4A                  ; 2
    lda    #$80                  ; 2  ror here
LF7DF:
    sta    ram_F2                ; 3
    ora    ram_D8                ; 3
    sta    ram_D8                ; 3
    stx    ram_B5                ; 3
    lda    ram_81                ; 3
    and    #$03                  ; 2
    bne    LF7B9                 ; 2³
    lda    ram_BC                ; 3
    ora    ram_BD                ; 3
    beq    LF812                 ; 2³+1
    ldx    #$01                  ; 2
LF7F5:
    ldy    #$07                  ; 2
LF7F7:
    lda    ram_BC,X              ; 4
    and    LFFC0,Y               ; 4
    beq    LF80C                 ; 2³+1
    ora    ram_A3,X              ; 4
    sta    ram_A3,X              ; 4
    lda    ram_BC,X              ; 4
    and    LFFB8,Y               ; 4
    sta    ram_BC,X              ; 4
    jmp    LFDD3                 ; 3

LF80C:
    dey                          ; 2
    bpl    LF7F7                 ; 2³+1
    dex                          ; 2
    bpl    LF7F5                 ; 2³+1
LF812:
    ldx    #$0F                  ; 2
LF814:
    stx    ram_F3                ; 3
    lda    ram_B7                ; 3
    beq    LF83E                 ; 2³
    lda    ram_F3                ; 3
    lsr                          ; 2
    tax                          ; 2
    ldy    LFEDD,X               ; 4
    lda    ram_F3                ; 3
    and    #$01                  ; 2
    tax                          ; 2
    lda    ram_A3,X              ; 4
    and    LFFC0,Y               ; 4
    bne    LF839                 ; 2³
    lda    ram_A3,X              ; 4
    ora    LFFC0,Y               ; 4
    sta    ram_A3,X              ; 4
    dec    ram_B7                ; 5
    jmp    LFDD3                 ; 3

LF839:
    ldx    ram_F3                ; 3
    dex                          ; 2
    bpl    LF814                 ; 2³
LF83E:
    lda    ram_D8                ; 3
    and    #$80                  ; 2
    sta    ram_D8                ; 3
    ldx    #$AA                  ; 2
    stx    ram_CE                ; 3
    lda    #$30                  ; 2
    sta    ram_D9                ; 3
    ldx    #$00                  ; 2
    stx    ram_CD                ; 3
    jmp    LF9EE                 ; 3

LF853:
    ldy    ram_80                ; 3
    lda    ram_BB                ; 3
    cmp    #$07                  ; 2
    bcc    LF85D                 ; 2³
    lda    #$07                  ; 2
LF85D:
    cpy    #$02                  ; 2
    bcc    LF863                 ; 2³
    lsr                          ; 2
    lsr                          ; 2
LF863:
    tax                          ; 2
    lda    LFEE5,X               ; 4
    sta    ram_EC                ; 3
    ldx    #$3F                  ; 2
    lda    ram_A3                ; 3
    ora    ram_A4                ; 3
    bne    LF873                 ; 2³
    ldx    #$1F                  ; 2
LF873:
    txa                          ; 2
    and    ram_81                ; 3
    bne    LF87E                 ; 2³
    lda    ram_F1                ; 3
    beq    LF87E                 ; 2³
    dec    ram_F1                ; 5
LF87E:
    lda    ram_84                ; 3
    sta    ram_F3                ; 3
    lda    ram_B5                ; 3

UP_FLAG        = $80
DOWN_FLAG      = $00
UPPER_LIMIT    = $4A
LOWER_LIMIT    = $08
DOWN_P0        = $20
UP_P0          = $10
DOWN_P1        = $02
UP_P1          = $01


  IF SEGA_GENESIS
    LSR    ram_F3
    BCS    .checkDown
    CMP    #UPPER_LIMIT
    BCS    .checkDown
    INC    ram_B5
.checkDown:
    LSR    ram_F3
    BCS    .finishDirection
    CMP    #LOWER_LIMIT
    BCC    .finishDirection
    DEC    ram_B5
.finishDirection:

    LDX    #DOWN_FLAG
    LDY    #UP_FLAG
    LDA    ram_9A
    LSR
    LDA    INPT4
    BCC    .useP1UpDir
    LDA    INPT5
.useP1UpDir:
    BMI    .checkDownDir
    LDA    ram_B5
    CMP    #UPPER_LIMIT
    BCS    .checkDownDir
    STX    ram_F2
.checkDownDir:
    LDA    ram_9A
    LSR
    LDA    INPT1
    BCC    .useP1DownDir
    LDA    INPT3
.useP1DownDir:
    BMI    .finishButtons
    LDA    ram_B5
    CMP    #LOWER_LIMIT
    BCC    .finishButtons
    STY    ram_F2
.finishButtons:

  ELSE
    ldx    #$00                  ; 2  down
    ldy    #$80                  ; 2  up
    lsr    ram_F3                ; 5  check up
    bcs    LF894                 ; 2³ up not pressed, goto down
    cmp    #$4A                  ; 2  upper limit
    bcs    LF894                 ; 2³ goto down
    inc    ram_B5                ; 5
    stx    ram_F2                ; 3
LF894:
    lsr    ram_F3                ; 5
    bcs    LF8A0                 ; 2³
    cmp    #$08                  ; 2
    bcc    LF8A0                 ; 2³
    dec    ram_B5                ; 5
    sty    ram_F2                ; 3
LF8A0:
  ENDIF


    lda    ram_AB                ; 3
    lsr    ram_F3                ; 5
    bcs    LF8AC                 ; 2³
    cmp    #$0F                  ; 2
    bcc    LF8AC                 ; 2³
    dec    ram_AB                ; 5
LF8AC:
    lsr    ram_F3                ; 5
    bcs    LF8B6                 ; 2³
    cmp    #$8D                  ; 2
    bcs    LF8B6                 ; 2³
    inc    ram_AB                ; 5
LF8B6:
    lda    ram_B5                ; 3
    cmp    #$4A                  ; 2
    bne    LF8BE                 ; 2³
    sty    ram_F2                ; 3
LF8BE:
    cmp    #$07                  ; 2
    bne    LF8C4                 ; 2³
    stx    ram_F2                ; 3
LF8C4:
    lda    ram_AB                ; 3
    clc                          ; 2
    adc    #$03                  ; 2
    sta    ram_AC                ; 3
    lda    ram_EF                ; 3
    bmi    LF8D3                 ; 2³
    cmp    #$08                  ; 2
    bcs    LF8FF                 ; 2³
LF8D3:
    lda    ram_84                ; 3
    bmi    LF8FF                 ; 2³
    lda    ram_B6                ; 3
    cmp    #$E0                  ; 2
    bne    LF8FF                 ; 2³
    lda    ram_F1                ; 3
    beq    LF906                 ; 2³+1
    ldx    #$06                  ; 2
    bit    ram_84                ; 3
    bvc    LF8E9                 ; 2³
    dex                          ; 2
    dex                          ; 2
LF8E9:
    txa                          ; 2
    bit    ram_F2                ; 3
    bpl    LF8F3                 ; 2³
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #$01                  ; 2
LF8F3:
    sta    ram_A9                ; 3
    lda    #$0F                  ; 2
    sta    ram_EF                ; 3
    lda    ram_B5                ; 3
    adc    #$08                  ; 2
    sta    ram_B6                ; 3
LF8FF:
    lda    ram_B6                ; 3
    clc                          ; 2
    adc    ram_A9                ; 3
    sta    ram_B6                ; 3
LF906:
    lda    ram_B6                ; 3
    sec                          ; 2
    sbc    #$80                  ; 2
    cmp    #$70                  ; 2
    bcs    LF913                 ; 2³
    lda    #$E0                  ; 2
    sta    ram_B6                ; 3
LF913:
    bit    ram_D8                ; 3
  IF SEGA_GENESIS
    BMI    LF984
  ELSE
    bpl    LF91A                 ; 2³
    jmp    LF984                 ; 3
  ENDIF

LF91A:
    lda    ram_AA                ; 3
    clc                          ; 2
    adc    ram_D3                ; 3
    sta    ram_AA                ; 3
    cmp    #$13                  ; 2
    bcc    LF955                 ; 2³
    jsr    LFFDE                 ; 6
    ldx    #$00                  ; 2
    stx    ram_AA                ; 3
  IF !SEGA_GENESIS
    lda    ram_C5                ; 3
    sta    ram_F3                ; 3
  ENDIF
LF930:
    cpx    #$02                  ; 2
    bcc    LF938                 ; 2³
    lda    ram_AE,X              ; 4
    sta    ram_AD,X              ; 4
LF938:
    lda    ram_C6,X              ; 4
    sta    ram_C5,X              ; 4
    inx                          ; 2
    cpx    #$07                  ; 2
    bcc    LF930                 ; 2³
    lda    ram_F3                ; 3
    sta    ram_CC                ; 3
    lda    #$C0                  ; 2
    sta    ram_B4                ; 3

  IF SEGA_GENESIS
    LSR    ram_CD
    LSR    ram_CD
    ASL    ram_CD
  ELSE
    lda    ram_CD                ; 3
    lsr                          ; 2
    and    #$FC                  ; 2
    sta    ram_CD                ; 3
  ENDIF

    lda    ram_CE                ; 3
    lsr                          ; 2
    ror    ram_CE                ; 5
LF955:
    lda    ram_AA                ; 3
    sec                          ; 2
    sbc    #$06                  ; 2
    bne    LF974                 ; 2³
    tay                          ; 2
    lda    ram_AF                ; 3
    sta    ram_F3                ; 3
    lda    ram_C7                ; 3
    and    #$07                  ; 2
    jsr    LFABB                 ; 6
    lda    ram_CD                ; 3
    and    #$FC                  ; 2
    ora    #$02                  ; 2
    sta    ram_CD                ; 3
    bit    ram_D8                ; 3
    bmi    LF981                 ; 2³
LF974:
    ldx    #$07                  ; 2
    jsr    LFA35                 ; 6
LF979:
    jsr    LFA83                 ; 6
    dex                          ; 2
    cpx    #$03                  ; 2
    bcs    LF979                 ; 2³
LF981:
    jmp    LF9EE                 ; 3

LF984:
    lda    ram_AA                ; 3
    sec                          ; 2
    sbc    ram_D3                ; 3
    sta    ram_AA                ; 3
    bpl    LF9BD                 ; 2³
    lda    #$12                  ; 2
    sta    ram_AA                ; 3
    jsr    LFFDE                 ; 6
    ldx    #$06                  ; 2
  IF !SEGA_GENESIS
    lda    ram_CC                ; 3
    sta    ram_F3                ; 3
  ENDIF
LF99A:
    cpx    #$02                  ; 2
    bcc    LF9A2                 ; 2³
    lda    ram_AD,X              ; 4
    sta    ram_AE,X              ; 4
LF9A2:
    lda    ram_C5,X              ; 4
    sta    ram_C6,X              ; 4
    dex                          ; 2
    bpl    LF99A                 ; 2³
    lda    ram_F3                ; 3
    sta    ram_C5                ; 3
    lda    #$C0                  ; 2
    sta    ram_AF                ; 3
    lda    ram_CD                ; 3
    and    #$FE                  ; 2
    asl                          ; 2
    sta    ram_CD                ; 3
    lda    ram_CE                ; 3
    asl                          ; 2
    rol    ram_CE                ; 5
LF9BD:
    lda    ram_BB                ; 3
    and    #$07                  ; 2
    tax                          ; 2
    lda    ram_AA                ; 3
    sec                          ; 2
    sbc    LFFD6,X               ; 4
    bne    LF9E1                 ; 2³
    ldy    #$01                  ; 2
    lda    ram_B4                ; 3
    sta    ram_F3                ; 3
    lda    ram_CC                ; 3
    and    #$07                  ; 2
    jsr    LFABB                 ; 6
    lda    ram_CD                ; 3
    ora    #$80                  ; 2
    sta    ram_CD                ; 3
    bit    ram_D8                ; 3
    bpl    LF9EE                 ; 2³
LF9E1:
    ldx    #$02                  ; 2
    jsr    LFA35                 ; 6
LF9E6:
    jsr    LFA83                 ; 6
    inx                          ; 2
    cpx    #$07                  ; 2
    bcc    LF9E6                 ; 2³
LF9EE:
    jmp    LF01B                 ; 3

LF9F1:
    ldx    #$0B                  ; 2
    ldy    #$FF                  ; 2
LF9F5:
    sty    ram_8B,X              ; 4
  IF SEGA_GENESIS
    STX    ram_D8                ; stores 1 on last pass
  ENDIF
    dex                          ; 2
    dex                          ; 2
    bpl    LF9F5                 ; 2³
    dey                          ; 2  #$FE
    sty    ram_88                ; 3
    dey                          ; 2  #$FD
    sty    ram_86                ; 3
    sty    ram_E7                ; 3
    sty    ram_E9                ; 3
    dey                          ; 2  #$FC

  IF SEGA_GENESIS
    JMP    SaveBytes
RejoinCode:
  ELSE
    sty    ram_8A                ; 3
    lda    #$20                  ; 2
    sta    ram_D9                ; 3
    lda    #$E0                  ; 2
    sta    ram_B6                ; 3
    lda    #$0F                  ; 2
    sta    ram_EB                ; 3
    ldx    #$3C                  ; 2
  ENDIF

    stx    ram_BC                ; 3
    stx    ram_BD                ; 3
    lda    ram_80                ; 3
    lsr                          ; 2
    bcc    LFA23                 ; 2³
    stx    ram_C3                ; 3
    stx    ram_C4                ; 3
LFA23:
  IF !SEGA_GENESIS
    lda    #$01                  ; 2
    sta    ram_D8                ; 3
  ENDIF
    ldx    #$07                  ; 2
LFA29:
    lda    #$77                  ; 2
    sta    ram_C5,X              ; 4
    lda    #$C0                  ; 2
    sta    ram_AD,X              ; 4
    dex                          ; 2
    bpl    LFA29                 ; 2³
    rts                          ; 6

LFA35:
    lda    ram_D1                ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    clc                          ; 2
    adc    #$01                  ; 2
    sta    ram_F5                ; 3
    lda    ram_C5,X              ; 4
    and    #$0F                  ; 2
    beq    LFA82                 ; 2³
    lda    ram_CD                ; 3
    and    LFFC0,X               ; 4
    bne    LFA82                 ; 2³
    lda    ram_82                ; 3
    and    #$3F                  ; 2
    adc    #$30                  ; 2
    cmp    #$50                  ; 2
    bcs    LFA5A                 ; 2³
    sec                          ; 2
    sbc    #$1F                  ; 2
LFA5A:
    sta    ram_F4                ; 3
    cmp    #$50                  ; 2
    lda    ram_AD,X              ; 4
    bcs    LFA6E                 ; 2³
    adc    ram_D4                ; 3
    sta    ram_AD,X              ; 4
    sec                          ; 2
    sbc    ram_F4                ; 3
    cmp    ram_F5                ; 3
    bcc    LFA7B                 ; 2³
    rts                          ; 6

LFA6E:
    sbc    ram_D4                ; 3
    sta    ram_AD,X              ; 4
    lda    ram_F4                ; 3
    sec                          ; 2
    sbc    ram_AD,X              ; 4
    cmp    ram_F5                ; 3
    bcs    LFA82                 ; 2³
LFA7B:
    lda    ram_CD                ; 3
    ora    LFFC0,X               ; 4
    sta    ram_CD                ; 3
LFA82:
    rts                          ; 6

LFA83:
    lda    ram_CD                ; 3
    and    LFFC0,X               ; 4
    beq    LFABA                 ; 2³
    lda    ram_C5,X              ; 4
    and    #$07                  ; 2
    bne    LFA95                 ; 2³
    lda    #$C0                  ; 2
    sta    ram_AD,X              ; 4
    rts                          ; 6

LFA95:
    lda    ram_CE                ; 3
    and    LFFC0,X               ; 4
    beq    LFAA8                 ; 2³
    lda    ram_AD,X              ; 4
    clc                          ; 2
    adc    ram_D2                ; 3
    sta    ram_AD,X              ; 4
    cmp    #$6E                  ; 2
    bcs    LFAB3                 ; 2³
    rts                          ; 6

LFAA8:
    lda    ram_AD,X              ; 4
    sec                          ; 2
    sbc    ram_D2                ; 3
    sta    ram_AD,X              ; 4
    cmp    #$0B                  ; 2
    bcs    LFABA                 ; 2³
LFAB3:
    lda    ram_CE                ; 3
    eor    LFFC0,X               ; 4
    sta    ram_CE                ; 3
LFABA:
    rts                          ; 6

LFABB:
    sta    ram_F4                ; 3
    sta    ram_F5                ; 3
    ldx    $E4,Y                 ; 4
    dex                          ; 2
    cpx    #$03                  ; 2
    bcc    LFB3D                 ; 2³+1
    ldx    #$05                  ; 2
LFAC8:
    lda    ram_F3                ; 3
    sec                          ; 2
    sbc    LFFC8,X               ; 4
    cmp    #$0E                  ; 2
    bcc    LFADB                 ; 2³
    asl    ram_F4                ; 5
    dex                          ; 2
    bpl    LFAC8                 ; 2³
    inx                          ; 2
    stx    $E4,Y                 ; 4
    rts                          ; 6

LFADB:
    stx    ram_AE                ; 3
    lda    ram_F4                ; 3
    and.wy ram_A3,Y              ; 4
    sta    ram_AD                ; 3
    bne    LFAEA                 ; 2³
    sta.wy ram_E4,Y              ; 5
    rts                          ; 6

LFAEA:
    lda.wy ram_E4,Y              ; 4
    bne    LFB1E                 ; 2³+1
    sty    ram_F6                ; 3
    tay                          ; 2
    lda    ram_D8                ; 3
    ora    #$40                  ; 2
    sta    ram_D8                ; 3
    lda    ram_A3                ; 3
    sta    ram_BC                ; 3
    lda    ram_A4                ; 3
    ldx    #$0F                  ; 2
LFB00:
    lsr    ram_BC                ; 5
    ror                          ; 2
    bcc    LFB06                 ; 2³
    iny                          ; 2
LFB06:
    dex                          ; 2
    bpl    LFB00                 ; 2³
    cpy    #$05                  ; 2
    bcc    LFB14                 ; 2³
    lda    #$16                  ; 2
    sec                          ; 2
    sbc    ram_BB                ; 3
    bcs    LFB16                 ; 2³
LFB14:
    lda    #$00                  ; 2
LFB16:
    clc                          ; 2
    adc    #$07                  ; 2
    ldy    ram_F6                ; 3
    sta.wy ram_E4,Y              ; 5
LFB1E:
    ldx    ram_AE                ; 3
    lda    ram_AD                ; 3
LFB22:
    cpx    #$05                  ; 2
    bcs    LFB2A                 ; 2³
    lsr                          ; 2
    inx                          ; 2
    bpl    LFB22                 ; 2³
LFB2A:
    sta.wy ram_FA,Y              ; 5
    tax                          ; 2
    lda    LFFEB,X               ; 4
    ldx    ram_AE                ; 3
    clc                          ; 2
    adc    LFFC8,X               ; 4
    adc    #$08                  ; 2
    sta.wy ram_A7,Y              ; 5
    rts                          ; 6

LFB3D:
    lda    ram_AD                ; 3
    and.wy ram_A3,Y              ; 4
    eor.wy ram_A3,Y              ; 4
    sta.wy ram_A3,Y              ; 5
    rts                          ; 6

LFB49:
    ldx    #$06                  ; 2
LFB4B:
    lda    ram_B7,X              ; 4
    ldy    ram_BE,X              ; 4
    sty    ram_B7,X              ; 4
    sta    ram_BE,X              ; 4
    dex                          ; 2
    bpl    LFB4B                 ; 2³
    ldx    #$07                  ; 2
LFB58:
    lda    ram_C5,X              ; 4
    jsr    LFECD                 ; 6
    sta    ram_F3                ; 3
    lda    ram_C5,X              ; 4
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    ora    ram_F3                ; 3
    sta    ram_C5,X              ; 4
    dex                          ; 2
    bpl    LFB58                 ; 2³
    lda    ram_80                ; 3
    lsr                          ; 2
    bcc    LFB77                 ; 2³
    lda    ram_9A                ; 3
    eor    #$01                  ; 2
    sta    ram_9A                ; 3
LFB77:
    lda    #$10                  ; 2
    sta    ram_D9                ; 3
    rts                          ; 6

    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    ldx    #$0B                  ; 2
LFB82:
    sta    ram_8B,X              ; 4
    dex                          ; 2
    dex                          ; 2
    bpl    LFB82                 ; 2³
LFB88:
    lda    #$07                  ; 2
    sta    ram_F4                ; 3
LFB8C:
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    ldx    #$F3                  ; 2
    stx    NUSIZ0                ; 3
    stx    NUSIZ1                ; 3
    ldy    #$01                  ; 2
    lda    #$40                  ; 2
    nop                          ; 2
    sta    RESP0                 ; 3
    sta    RESP1                 ; 3
    sta    RESBL                 ; 3
    sty    CTRLPF                ; 3
    sta    HMBL                  ; 3
    stx    HMP0                  ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    sty    VDELP0                ; 3
    sty    VDELP1                ; 3
    dey                          ; 2
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    sty    GRP0                  ; 3
    sta    ram_F3                ; 3
    sta    HMCLR                 ; 3
LFBBE:
    ldy    ram_F4                ; 3
    lda    (ram_95),Y            ; 5
    sta    ram_F3                ; 3
  IF SEGA_GENESIS
    LAX    (ram_93),Y
  ELSE
    lda    (ram_93),Y            ; 5
    tax                          ; 2
  ENDIF
    lda    (ram_8B),Y            ; 5
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    sta    GRP0                  ; 3
    lda    (ram_8D),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_8F),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_91),Y            ; 5
    ldy    ram_F3                ; 3
    sta    GRP1                  ; 3
    stx    GRP0                  ; 3
    sty    GRP1                  ; 3
    sta    GRP0                  ; 3
    dec    ram_F4                ; 5
    bpl    LFBBE                 ; 2³
    lda    #$80                  ; 2
    sta    HMP0                  ; 3
    sta    HMP1                  ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
  IF SEGA_GENESIS
    ASL
  ELSE
    lda    #$00                  ; 2
  ENDIF
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    sta    GRP0                  ; 3
    rts                          ; 6

  IF !SEGA_GENESIS
    NOP
    NOP  ; free bytes
    NOP
  ENDIF

    NOP
    NOP  ; free bytes
    NOP


       ORG $FC00

    .byte $00 ; |        | $FC00
    .byte $20 ; |  X     | $FC01
    .byte $20 ; |  X     | $FC02
    .byte $20 ; |  X     | $FC03
    .byte $70 ; | XXX    | $FC04
    .byte $F8 ; |XXXXX   | $FC05
    .byte $70 ; | XXX    | $FC06
    .byte $88 ; |X   X   | $FC07
    .byte $F8 ; |XXXXX   | $FC08
    .byte $F8 ; |XXXXX   | $FC09
    .byte $F8 ; |XXXXX   | $FC0A
    .byte $F8 ; |XXXXX   | $FC0B
    .byte $F8 ; |XXXXX   | $FC0C
    .byte $70 ; | XXX    | $FC0D
    .byte $F8 ; |XXXXX   | $FC0E
    .byte $7C ; | XXXXX  | $FC0F
    .byte $00 ; |        | $FC10
    .byte $00 ; |        | $FC11
    .byte $00 ; |        | $FC12
    .byte $00 ; |        | $FC13
    .byte $00 ; |        | $FC14
    .byte $00 ; |        | $FC15
    .byte $00 ; |        | $FC16
    .byte $00 ; |        | $FC17
    .byte $7C ; | XXXXX  | $FC18
    .byte $F8 ; |XXXXX   | $FC19
    .byte $70 ; | XXX    | $FC1A
    .byte $F8 ; |XXXXX   | $FC1B
    .byte $F8 ; |XXXXX   | $FC1C
    .byte $F8 ; |XXXXX   | $FC1D
    .byte $F8 ; |XXXXX   | $FC1E
    .byte $F8 ; |XXXXX   | $FC1F
    .byte $88 ; |X   X   | $FC20
    .byte $70 ; | XXX    | $FC21
    .byte $F8 ; |XXXXX   | $FC22
    .byte $70 ; | XXX    | $FC23
    .byte $20 ; |  X     | $FC24
    .byte $20 ; |  X     | $FC25
    .byte $20 ; |  X     | $FC26
    .byte $00 ; |        | $FC27
    .byte $20 ; |  X     | $FC28
    .byte $20 ; |  X     | $FC29
    .byte $20 ; |  X     | $FC2A
    .byte $70 ; | XXX    | $FC2B
    .byte $F8 ; |XXXXX   | $FC2C
    .byte $70 ; | XXX    | $FC2D
    .byte $88 ; |X   X   | $FC2E
    .byte $F8 ; |XXXXX   | $FC2F
    .byte $F8 ; |XXXXX   | $FC30
    .byte $F8 ; |XXXXX   | $FC31
    .byte $F8 ; |XXXXX   | $FC32
    .byte $F8 ; |XXXXX   | $FC33
    .byte $F8 ; |XXXXX   | $FC34
    .byte $F8 ; |XXXXX   | $FC35
    .byte $70 ; | XXX    | $FC36
    .byte $F8 ; |XXXXX   | $FC37
    .byte $7C ; | XXXXX  | $FC38
    .byte $00 ; |        | $FC39
    .byte $00 ; |        | $FC3A
    .byte $00 ; |        | $FC3B
    .byte $00 ; |        | $FC3C
    .byte $00 ; |        | $FC3D
    .byte $00 ; |        | $FC3E
    .byte $7C ; | XXXXX  | $FC3F
    .byte $F8 ; |XXXXX   | $FC40
    .byte $70 ; | XXX    | $FC41
    .byte $F8 ; |XXXXX   | $FC42
    .byte $F8 ; |XXXXX   | $FC43
    .byte $F8 ; |XXXXX   | $FC44
    .byte $F8 ; |XXXXX   | $FC45
    .byte $F8 ; |XXXXX   | $FC46
    .byte $F8 ; |XXXXX   | $FC47
    .byte $F8 ; |XXXXX   | $FC48
    .byte $88 ; |X   X   | $FC49
    .byte $70 ; | XXX    | $FC4A
    .byte $F8 ; |XXXXX   | $FC4B
    .byte $70 ; | XXX    | $FC4C
    .byte $20 ; |  X     | $FC4D
    .byte $20 ; |  X     | $FC4E
    .byte $20 ; |  X     | $FC4F
    .byte $00 ; |        | $FC50
    .byte $20 ; |  X     | $FC51
    .byte $20 ; |  X     | $FC52
    .byte $20 ; |  X     | $FC53
    .byte $70 ; | XXX    | $FC54
    .byte $F8 ; |XXXXX   | $FC55
    .byte $70 ; | XXX    | $FC56
    .byte $88 ; |X   X   | $FC57
    .byte $F8 ; |XXXXX   | $FC58
    .byte $F8 ; |XXXXX   | $FC59
    .byte $F8 ; |XXXXX   | $FC5A
    .byte $70 ; | XXX    | $FC5B
    .byte $F8 ; |XXXXX   | $FC5C
    .byte $7C ; | XXXXX  | $FC5D
    .byte $00 ; |        | $FC5E
    .byte $00 ; |        | $FC5F
    .byte $00 ; |        | $FC60
    .byte $00 ; |        | $FC61
    .byte $00 ; |        | $FC62
    .byte $00 ; |        | $FC63
    .byte $00 ; |        | $FC64
    .byte $00 ; |        | $FC65
    .byte $00 ; |        | $FC66
    .byte $00 ; |        | $FC67
    .byte $7C ; | XXXXX  | $FC68
    .byte $F8 ; |XXXXX   | $FC69
    .byte $70 ; | XXX    | $FC6A
    .byte $F8 ; |XXXXX   | $FC6B
    .byte $F8 ; |XXXXX   | $FC6C
    .byte $F8 ; |XXXXX   | $FC6D
    .byte $88 ; |X   X   | $FC6E
    .byte $70 ; | XXX    | $FC6F
    .byte $F8 ; |XXXXX   | $FC70
    .byte $70 ; | XXX    | $FC71
    .byte $20 ; |  X     | $FC72
    .byte $20 ; |  X     | $FC73
    .byte $20 ; |  X     | $FC74
    .byte $00 ; |        | $FC75
    .byte $20 ; |  X     | $FC76
    .byte $20 ; |  X     | $FC77
    .byte $20 ; |  X     | $FC78
    .byte $70 ; | XXX    | $FC79
    .byte $F8 ; |XXXXX   | $FC7A
    .byte $70 ; | XXX    | $FC7B
    .byte $88 ; |X   X   | $FC7C
    .byte $F8 ; |XXXXX   | $FC7D
    .byte $70 ; | XXX    | $FC7E
    .byte $F8 ; |XXXXX   | $FC7F
    .byte $7C ; | XXXXX  | $FC80
    .byte $00 ; |        | $FC81
    .byte $00 ; |        | $FC82
    .byte $00 ; |        | $FC83
    .byte $00 ; |        | $FC84
    .byte $00 ; |        | $FC85
    .byte $00 ; |        | $FC86
    .byte $00 ; |        | $FC87
    .byte $00 ; |        | $FC88
    .byte $00 ; |        | $FC89
    .byte $00 ; |        | $FC8A
    .byte $00 ; |        | $FC8B
    .byte $00 ; |        | $FC8C
    .byte $00 ; |        | $FC8D
    .byte $00 ; |        | $FC8E
    .byte $00 ; |        | $FC8F
    .byte $00 ; |        | $FC90
    .byte $00 ; |        | $FC91
    .byte $00 ; |        | $FC92
    .byte $00 ; |        | $FC93
    .byte $00 ; |        | $FC94
    .byte $00 ; |        | $FC95
    .byte $00 ; |        | $FC96
    .byte $00 ; |        | $FC97
    .byte $7C ; | XXXXX  | $FC98
    .byte $F8 ; |XXXXX   | $FC99
    .byte $70 ; | XXX    | $FC9A
    .byte $F8 ; |XXXXX   | $FC9B
    .byte $88 ; |X   X   | $FC9C
    .byte $70 ; | XXX    | $FC9D
    .byte $F8 ; |XXXXX   | $FC9E
    .byte $70 ; | XXX    | $FC9F
    .byte $20 ; |  X     | $FCA0
    .byte $20 ; |  X     | $FCA1
    .byte $20 ; |  X     | $FCA2
    .byte $00 ; |        | $FCA3
    .byte $20 ; |  X     | $FCA4
    .byte $20 ; |  X     | $FCA5
    .byte $20 ; |  X     | $FCA6
    .byte $70 ; | XXX    | $FCA7
    .byte $F8 ; |XXXXX   | $FCA8
    .byte $70 ; | XXX    | $FCA9
    .byte $88 ; |X   X   | $FCAA
    .byte $F8 ; |XXXXX   | $FCAB
    .byte $F8 ; |XXXXX   | $FCAC
    .byte $F8 ; |XXXXX   | $FCAD
    .byte $F8 ; |XXXXX   | $FCAE
    .byte $F8 ; |XXXXX   | $FCAF
    .byte $F8 ; |XXXXX   | $FCB0
    .byte $F8 ; |XXXXX   | $FCB1
    .byte $F8 ; |XXXXX   | $FCB2
    .byte $F8 ; |XXXXX   | $FCB3
    .byte $70 ; | XXX    | $FCB4
    .byte $F8 ; |XXXXX   | $FCB5
    .byte $7C ; | XXXXX  | $FCB6
    .byte $00 ; |        | $FCB7
    .byte $00 ; |        | $FCB8
    .byte $00 ; |        | $FCB9
    .byte $00 ; |        | $FCBA
    .byte $7C ; | XXXXX  | $FCBB
    .byte $F8 ; |XXXXX   | $FCBC
    .byte $70 ; | XXX    | $FCBD
    .byte $F8 ; |XXXXX   | $FCBE
    .byte $F8 ; |XXXXX   | $FCBF
    .byte $F8 ; |XXXXX   | $FCC0
    .byte $F8 ; |XXXXX   | $FCC1
    .byte $F8 ; |XXXXX   | $FCC2
    .byte $F8 ; |XXXXX   | $FCC3
    .byte $F8 ; |XXXXX   | $FCC4
    .byte $F8 ; |XXXXX   | $FCC5
    .byte $F8 ; |XXXXX   | $FCC6
    .byte $88 ; |X   X   | $FCC7
    .byte $70 ; | XXX    | $FCC8
    .byte $F8 ; |XXXXX   | $FCC9
    .byte $70 ; | XXX    | $FCCA
    .byte $20 ; |  X     | $FCCB
    .byte $20 ; |  X     | $FCCC
    .byte $20 ; |  X     | $FCCD
    .byte $00 ; |        | $FCCE
    .byte $7C ; | XXXXX  | $FCCF
    .byte $F8 ; |XXXXX   | $FCD0
    .byte $70 ; | XXX    | $FCD1
    .byte $F8 ; |XXXXX   | $FCD2
    .byte $F8 ; |XXXXX   | $FCD3
    .byte $F8 ; |XXXXX   | $FCD4
    .byte $F8 ; |XXXXX   | $FCD5
    .byte $F8 ; |XXXXX   | $FCD6
    .byte $F8 ; |XXXXX   | $FCD7
    .byte $F8 ; |XXXXX   | $FCD8
    .byte $F8 ; |XXXXX   | $FCD9
    .byte $F8 ; |XXXXX   | $FCDA
    .byte $F8 ; |XXXXX   | $FCDB
    .byte $F8 ; |XXXXX   | $FCDC
    .byte $F8 ; |XXXXX   | $FCDD
    .byte $88 ; |X   X   | $FCDE
    .byte $70 ; | XXX    | $FCDF
    .byte $F8 ; |XXXXX   | $FCE0
    .byte $70 ; | XXX    | $FCE1
    .byte $20 ; |  X     | $FCE2
    .byte $20 ; |  X     | $FCE3
    .byte $20 ; |  X     | $FCE4
    .byte $00 ; |        | $FCE5
    .byte $20 ; |  X     | $FCE6
    .byte $20 ; |  X     | $FCE7
    .byte $20 ; |  X     | $FCE8
    .byte $70 ; | XXX    | $FCE9
    .byte $F8 ; |XXXXX   | $FCEA
    .byte $70 ; | XXX    | $FCEB
    .byte $88 ; |X   X   | $FCEC
    .byte $F8 ; |XXXXX   | $FCED
    .byte $F8 ; |XXXXX   | $FCEE
    .byte $F8 ; |XXXXX   | $FCEF
    .byte $F8 ; |XXXXX   | $FCF0
    .byte $F8 ; |XXXXX   | $FCF1
    .byte $F8 ; |XXXXX   | $FCF2
    .byte $F8 ; |XXXXX   | $FCF3
    .byte $F8 ; |XXXXX   | $FCF4
    .byte $F8 ; |XXXXX   | $FCF5
    .byte $F8 ; |XXXXX   | $FCF6
    .byte $F8 ; |XXXXX   | $FCF7
    .byte $F8 ; |XXXXX   | $FCF8
    .byte $70 ; | XXX    | $FCF9
    .byte $F8 ; |XXXXX   | $FCFA
    .byte $7C ; | XXXXX  | $FCFB
LFCFC:
    .byte $00 ; |        | $FCFC
    .byte $02 ; |      X | $FCFD
    .byte $01 ; |       X| $FCFE
    .byte $03 ; |      XX| $FCFF
    .byte $00 ; |        | $FD00
    .byte $FF ; |XXXXXXXX| $FD01
    .byte $FF ; |XXXXXXXX| $FD02
    .byte $7E ; | XXXXXX | $FD03
    .byte $FF ; |XXXXXXXX| $FD04
    .byte $7E ; | XXXXXX | $FD05
    .byte $FF ; |XXXXXXXX| $FD06
    .byte $7E ; | XXXXXX | $FD07
    .byte $FF ; |XXXXXXXX| $FD08
    .byte $FF ; |XXXXXXXX| $FD09
    .byte $7E ; | XXXXXX | $FD0A
    .byte $00 ; |        | $FD0B
    .byte $00 ; |        | $FD0C
    .byte $00 ; |        | $FD0D
    .byte $00 ; |        | $FD0E
    .byte $00 ; |        | $FD0F
    .byte $00 ; |        | $FD10
    .byte $00 ; |        | $FD11
    .byte $00 ; |        | $FD12
    .byte $3C ; |  XXXX  | $FD13
    .byte $3C ; |  XXXX  | $FD14
    .byte $5E ; | X XXXX | $FD15
    .byte $76 ; | XXX XX | $FD16
    .byte $5E ; | X XXXX | $FD17
    .byte $FB ; |XXXXX XX| $FD18
    .byte $BF ; |X XXXXXX| $FD19
    .byte $FF ; |XXXXXXXX| $FD1A
    .byte $7E ; | XXXXXX | $FD1B
    .byte $7E ; | XXXXXX | $FD1C
    .byte $18 ; |   XX   | $FD1D
    .byte $3C ; |  XXXX  | $FD1E
    .byte $14 ; |   X X  | $FD1F
    .byte $00 ; |        | $FD20
    .byte $00 ; |        | $FD21
    .byte $00 ; |        | $FD22
    .byte $00 ; |        | $FD23
    .byte $00 ; |        | $FD24
    .byte $3C ; |  XXXX  | $FD25
    .byte $7E ; | XXXXXX | $FD26
    .byte $7E ; | XXXXXX | $FD27
    .byte $FF ; |XXXXXXXX| $FD28
    .byte $FF ; |XXXXXXXX| $FD29
    .byte $7E ; | XXXXXX | $FD2A
    .byte $3C ; |  XXXX  | $FD2B
    .byte $00 ; |        | $FD2C
    .byte $00 ; |        | $FD2D
    .byte $00 ; |        | $FD2E
    .byte $00 ; |        | $FD2F
    .byte $00 ; |        | $FD30
    .byte $00 ; |        | $FD31
    .byte $00 ; |        | $FD32
    .byte $00 ; |        | $FD33
    .byte $00 ; |        | $FD34
    .byte $00 ; |        | $FD35
    .byte $00 ; |        | $FD36
    .byte $3C ; |  XXXX  | $FD37
    .byte $3C ; |  XXXX  | $FD38
    .byte $7E ; | XXXXXX | $FD39
    .byte $7E ; | XXXXXX | $FD3A
    .byte $7E ; | XXXXXX | $FD3B
    .byte $7E ; | XXXXXX | $FD3C
    .byte $3C ; |  XXXX  | $FD3D
    .byte $08 ; |    X   | $FD3E
    .byte $08 ; |    X   | $FD3F
    .byte $04 ; |     X  | $FD40
    .byte $04 ; |     X  | $FD41
    .byte $02 ; |      X | $FD42
    .byte $03 ; |      XX| $FD43
    .byte $00 ; |        | $FD44
    .byte $00 ; |        | $FD45
    .byte $00 ; |        | $FD46
    .byte $00 ; |        | $FD47
    .byte $00 ; |        | $FD48
    .byte $7F ; | XXXXXXX| $FD49
    .byte $6B ; | XX X XX| $FD4A
    .byte $55 ; | X X X X| $FD4B
    .byte $55 ; | X X X X| $FD4C
    .byte $6B ; | XX X XX| $FD4D
    .byte $7F ; | XXXXXXX| $FD4E
    .byte $7F ; | XXXXXXX| $FD4F
    .byte $3E ; |  XXXXX | $FD50
    .byte $EE ; |XXX XXX | $FD51
    .byte $AF ; |X X XXXX| $FD52
    .byte $25 ; |  X  X X| $FD53
    .byte $24 ; |  X  X  | $FD54
    .byte $00 ; |        | $FD55
    .byte $00 ; |        | $FD56
    .byte $00 ; |        | $FD57
    .byte $00 ; |        | $FD58
    .byte $00 ; |        | $FD59
    .byte $00 ; |        | $FD5A
    .byte $3C ; |  XXXX  | $FD5B
    .byte $7E ; | XXXXXX | $FD5C
    .byte $FF ; |XXXXXXXX| $FD5D
    .byte $FF ; |XXXXXXXX| $FD5E
    .byte $E7 ; |XXX  XXX| $FD5F
    .byte $C3 ; |XX    XX| $FD60
    .byte $7E ; | XXXXXX | $FD61
    .byte $3C ; |  XXXX  | $FD62
    .byte $00 ; |        | $FD63
    .byte $00 ; |        | $FD64
    .byte $00 ; |        | $FD65
    .byte $00 ; |        | $FD66
    .byte $00 ; |        | $FD67
    .byte $00 ; |        | $FD68
    .byte $00 ; |        | $FD69
    .byte $00 ; |        | $FD6A
    .byte $00 ; |        | $FD6B
    .byte $00 ; |        | $FD6C
    .byte $30 ; |  XX    | $FD6D
    .byte $30 ; |  XX    | $FD6E
    .byte $30 ; |  XX    | $FD6F
    .byte $30 ; |  XX    | $FD70
    .byte $30 ; |  XX    | $FD71
    .byte $30 ; |  XX    | $FD72
    .byte $30 ; |  XX    | $FD73
    .byte $30 ; |  XX    | $FD74
    .byte $33 ; |  XX  XX| $FD75
    .byte $33 ; |  XX  XX| $FD76
    .byte $3F ; |  XXXXXX| $FD77
    .byte $1E ; |   XXXX | $FD78
    .byte $0C ; |    XX  | $FD79
    .byte $00 ; |        | $FD7A
    .byte $00 ; |        | $FD7B
    .byte $00 ; |        | $FD7C
    .byte $00 ; |        | $FD7D
    .byte $00 ; |        | $FD7E
    .byte $1C ; |   XXX  | $FD7F
    .byte $1C ; |   XXX  | $FD80
    .byte $1C ; |   XXX  | $FD81
    .byte $1C ; |   XXX  | $FD82
    .byte $3E ; |  XXXXX | $FD83
    .byte $3E ; |  XXXXX | $FD84
    .byte $1C ; |   XXX  | $FD85
    .byte $3E ; |  XXXXX | $FD86
    .byte $1C ; |   XXX  | $FD87
    .byte $3E ; |  XXXXX | $FD88
    .byte $1C ; |   XXX  | $FD89
    .byte $3E ; |  XXXXX | $FD8A
    .byte $1C ; |   XXX  | $FD8B
    .byte $00 ; |        | $FD8C
    .byte $00 ; |        | $FD8D
    .byte $00 ; |        | $FD8E
    .byte $00 ; |        | $FD8F
LFD90:
    .byte $00 ; |        | $FD90
    .byte $42 ; | X    X | $FD91
    .byte $42 ; | X    X | $FD92
    .byte $E7 ; |XXX  XXX| $FD93
    .byte $E7 ; |XXX  XXX| $FD94
    .byte $FF ; |XXXXXXXX| $FD95
    .byte $FF ; |XXXXXXXX| $FD96
    .byte $FF ; |XXXXXXXX| $FD97
    .byte $FF ; |XXXXXXXX| $FD98
    .byte $FF ; |XXXXXXXX| $FD99
    .byte $FF ; |XXXXXXXX| $FD9A
    .byte $FF ; |XXXXXXXX| $FD9B
    .byte $FF ; |XXXXXXXX| $FD9C
    .byte $C3 ; |XX    XX| $FD9D
    .byte $00 ; |        | $FD9E
    .byte $42 ; | X    X | $FD9F
    .byte $42 ; | X    X | $FDA0
    .byte $E7 ; |XXX  XXX| $FDA1
    .byte $E7 ; |XXX  XXX| $FDA2
    .byte $C3 ; |XX    XX| $FDA3
    .byte $C3 ; |XX    XX| $FDA4
    .byte $00 ; |        | $FDA5
    .byte $00 ; |        | $FDA6
    .byte $00 ; |        | $FDA7
    .byte $00 ; |        | $FDA8
    .byte $00 ; |        | $FDA9
    .byte $00 ; |        | $FDAA
    .byte $00 ; |        | $FDAB
    .byte $00 ; |        | $FDAC
    .byte $42 ; | X    X | $FDAD
    .byte $42 ; | X    X | $FDAE
    .byte $E7 ; |XXX  XXX| $FDAF
    .byte $E7 ; |XXX  XXX| $FDB0
    .byte $FF ; |XXXXXXXX| $FDB1
    .byte $E7 ; |XXX  XXX| $FDB2
    .byte $E7 ; |XXX  XXX| $FDB3
    .byte $C3 ; |XX    XX| $FDB4
    .byte $C3 ; |XX    XX| $FDB5
    .byte $00 ; |        | $FDB6
    .byte $00 ; |        | $FDB7
    .byte $00 ; |        | $FDB8
    .byte $00 ; |        | $FDB9
    .byte $00 ; |        | $FDBA
    .byte $42 ; | X    X | $FDBB
    .byte $42 ; | X    X | $FDBC
    .byte $E7 ; |XXX  XXX| $FDBD
    .byte $E7 ; |XXX  XXX| $FDBE
    .byte $FF ; |XXXXXXXX| $FDBF
    .byte $FF ; |XXXXXXXX| $FDC0
    .byte $FF ; |XXXXXXXX| $FDC1
    .byte $E7 ; |XXX  XXX| $FDC2
    .byte $E7 ; |XXX  XXX| $FDC3
    .byte $C3 ; |XX    XX| $FDC4
    .byte $C3 ; |XX    XX| $FDC5
    .byte $00 ; |        | $FDC6
    .byte $00 ; |        | $FDC7
LFDC8:
    .byte $06 ; |     XX | $FDC8
    .byte $04 ; |     X  | $FDC9
    .byte $00 ; |        | $FDCA
    .byte $00 ; |        | $FDCB
    .byte $00 ; |        | $FDCC
    .byte $00 ; |        | $FDCD
    .byte $01 ; |       X| $FDCE
    .byte $03 ; |      XX| $FDCF
    .byte $07 ; |     XXX| $FDD0
LFDD1:
    .byte $9A ; |X  XX X | $FDD1
    .byte $D6 ; |XX X XX | $FDD2

LFDD3:
    bit    ram_98                ; 3
    bmi    LFDFD                 ; 2³
    lda    #$1F                  ; 2
    sta    ram_EE                ; 3
    sta    AUDV0                 ; 3
    sta    AUDV1                 ; 3
    lda    #$0C                  ; 2
    sta    AUDC0                 ; 3
    sta    AUDC1                 ; 3
    inc    ram_EB                ; 5
    lda    ram_EB                ; 3
    clc                          ; 2
    adc    #$02                  ; 2
    eor    #$1F                  ; 2
    sta    AUDF0                 ; 3
    lsr                          ; 2
    sta    AUDF1                 ; 3
    lda    ram_BC                ; 3
    ora    ram_BD                ; 3
    bne    LFDFD                 ; 2³
    lda    #$10                  ; 2
    sta    ram_D9                ; 3
LFDFD:
    jmp    LF01B                 ; 3

    .byte $00 ; |        | $FE00
    .byte $28 ; |  X X   | $FE01
    .byte $28 ; |  X X   | $FE02
    .byte $12 ; |   X  X | $FE03
    .byte $C4 ; |XX   X  | $FE04
    .byte $42 ; | X    X | $FE05
    .byte $1A ; |   XX X | $FE06
    .byte $12 ; |   X  X | $FE07
    .byte $28 ; |  X X   | $FE08
    .byte $26 ; |  X  XX | $FE09
    .byte $24 ; |  X  X  | $FE0A
    .byte $00 ; |        | $FE0B
    .byte $42 ; | X    X | $FE0C
    .byte $42 ; | X    X | $FE0D
    .byte $44 ; | X   X  | $FE0E
    .byte $44 ; | X   X  | $FE0F
    .byte $44 ; | X   X  | $FE10
    .byte $44 ; | X   X  | $FE11
    .byte $44 ; | X   X  | $FE12
    .byte $42 ; | X    X | $FE13
    .byte $42 ; | X    X | $FE14
    .byte $C6 ; |XX   XX | $FE15
    .byte $C6 ; |XX   XX | $FE16
    .byte $C6 ; |XX   XX | $FE17
    .byte $C6 ; |XX   XX | $FE18
    .byte $00 ; |        | $FE19
    .byte $14 ; |   X X  | $FE1A
    .byte $16 ; |   X XX | $FE1B
    .byte $18 ; |   XX   | $FE1C
    .byte $32 ; |  XX  X | $FE1D
    .byte $32 ; |  XX  X | $FE1E
    .byte $18 ; |   XX   | $FE1F
    .byte $14 ; |   X X  | $FE20
    .byte $00 ; |        | $FE21
    .byte $00 ; |        | $FE22
    .byte $42 ; | X    X | $FE23
    .byte $44 ; | X   X  | $FE24
    .byte $44 ; | X   X  | $FE25
    .byte $44 ; | X   X  | $FE26
    .byte $44 ; | X   X  | $FE27
    .byte $44 ; | X   X  | $FE28
    .byte $42 ; | X    X | $FE29
    .byte $C6 ; |XX   XX | $FE2A
    .byte $C6 ; |XX   XX | $FE2B
    .byte $C6 ; |XX   XX | $FE2C
    .byte $C6 ; |XX   XX | $FE2D
    .byte $C6 ; |XX   XX | $FE2E
    .byte $C6 ; |XX   XX | $FE2F
    .byte $00 ; |        | $FE30
    .byte $0C ; |    XX  | $FE31
    .byte $0C ; |    XX  | $FE32
    .byte $0C ; |    XX  | $FE33
    .byte $0C ; |    XX  | $FE34
    .byte $0C ; |    XX  | $FE35
    .byte $0C ; |    XX  | $FE36
    .byte $14 ; |   X X  | $FE37
    .byte $18 ; |   XX   | $FE38
    .byte $18 ; |   XX   | $FE39
    .byte $18 ; |   XX   | $FE3A
    .byte $18 ; |   XX   | $FE3B
    .byte $18 ; |   XX   | $FE3C
    .byte $00 ; |        | $FE3D
    .byte $24 ; |  X  X  | $FE3E
    .byte $24 ; |  X  X  | $FE3F
    .byte $24 ; |  X  X  | $FE40
    .byte $4A ; | X  X X | $FE41
    .byte $4A ; | X  X X | $FE42
    .byte $4A ; | X  X X | $FE43
    .byte $4A ; | X  X X | $FE44
    .byte $4A ; | X  X X | $FE45
    .byte $00 ; |        | $FE46
    .byte $0C ; |    XX  | $FE47
    .byte $0C ; |    XX  | $FE48
    .byte $44 ; | X   X  | $FE49
    .byte $44 ; | X   X  | $FE4A
    .byte $0C ; |    XX  | $FE4B
    .byte $0C ; |    XX  | $FE4C
    .byte $44 ; | X   X  | $FE4D
    .byte $44 ; | X   X  | $FE4E
    .byte $0C ; |    XX  | $FE4F
    .byte $0C ; |    XX  | $FE50
    .byte $44 ; | X   X  | $FE51
    .byte $44 ; | X   X  | $FE52
    .byte $0C ; |    XX  | $FE53
    .byte $00 ; |        | $FE54
    .byte $28 ; |  X X   | $FE55
    .byte $28 ; |  X X   | $FE56
    .byte $28 ; |  X X   | $FE57
    .byte $28 ; |  X X   | $FE58
    .byte $28 ; |  X X   | $FE59
    .byte $28 ; |  X X   | $FE5A
    .byte $C6 ; |XX   XX | $FE5B
    .byte $C6 ; |XX   XX | $FE5C
    .byte $C6 ; |XX   XX | $FE5D
    .byte $0C ; |    XX  | $FE5E
    .byte $44 ; | X   X  | $FE5F
    .byte $44 ; | X   X  | $FE60
    .byte $44 ; | X   X  | $FE61
LFE62:
    .byte $FF ; |XXXXXXXX| $FE62
    .byte $FF ; |XXXXXXXX| $FE63
    .byte $FF ; |XXXXXXXX| $FE64
    .byte $FF ; |XXXXXXXX| $FE65
    .byte $FF ; |XXXXXXXX| $FE66
    .byte $FF ; |XXXXXXXX| $FE67
    .byte $FF ; |XXXXXXXX| $FE68
    .byte $FF ; |XXXXXXXX| $FE69
    .byte $FF ; |XXXXXXXX| $FE6A
    .byte $FF ; |XXXXXXXX| $FE6B
    .byte $F8 ; |XXXXX   | $FE6C
    .byte $F0 ; |XXXX    | $FE6D
    .byte $00 ; |        | $FE6E
    .byte $00 ; |        | $FE6F
    .byte $00 ; |        | $FE70
    .byte $00 ; |        | $FE71
LFE72:
    .byte $FF ; |XXXXXXXX| $FE72
    .byte $FF ; |XXXXXXXX| $FE73
    .byte $FF ; |XXXXXXXX| $FE74
    .byte $FF ; |XXXXXXXX| $FE75
    .byte $7F ; | XXXXXXX| $FE76
    .byte $3F ; |  XXXXXX| $FE77
    .byte $0F ; |    XXXX| $FE78
    .byte $03 ; |      XX| $FE79
    .byte $01 ; |       X| $FE7A
    .byte $00 ; |        | $FE7B
    .byte $00 ; |        | $FE7C
    .byte $00 ; |        | $FE7D
    .byte $00 ; |        | $FE7E
    .byte $00 ; |        | $FE7F
    .byte $00 ; |        | $FE80
    .byte $00 ; |        | $FE81
LFE82:
    .byte $90 ; |X  X    | $FE82
    .byte $9E ; |X  XXXX | $FE83
    .byte $AC ; |X X XX  | $FE84
    .byte $BA ; |X XXX X | $FE85
    .byte $90 ; |X  X    | $FE86
LFE87:
    .byte $00 ; |        | $FE87
    .byte $24 ; |  X  X  | $FE88
    .byte $48 ; | X  X   | $FE89
    .byte $12 ; |   X  X | $FE8A
    .byte $36 ; |  XX XX | $FE8B
    .byte $5A ; | X XX X | $FE8C
    .byte $6C ; | XX XX  | $FE8D
    .byte $7E ; | XXXXXX | $FE8E
LFE8F:
    .byte $00 ; |        | $FE8F
    .byte $19 ; |   XX  X| $FE90
    .byte $30 ; |  XX    | $FE91
    .byte $0B ; |    X XX| $FE92
    .byte $22 ; |  X   X | $FE93
    .byte $3D ; |  XXXX X| $FE94
    .byte $46 ; | X   XX | $FE95
    .byte $54 ; | X X X  | $FE96
LFE97:
    .byte $81 ; |X      X| $FE97
    .byte $8C ; |X   XX  | $FE98
    .byte $8C ; |X   XX  | $FE99
    .byte $5E ; | X XXXX | $FE9A
    .byte $5E ; | X XXXX | $FE9B
    .byte $10 ; |   X    | $FE9C
    .byte $10 ; |   X    | $FE9D
    .byte $39 ; |  XXX  X| $FE9E
    .byte $39 ; |  XXX  X| $FE9F
    .byte $B7 ; |X XX XXX| $FEA0
    .byte $B7 ; |X XX XXX| $FEA1
    .byte $CE ; |XX  XXX | $FEA2
LFEA3:
    .byte $81 ; |X      X| $FEA3
    .byte $75 ; | XXX X X| $FEA4
    .byte $75 ; | XXX X X| $FEA5
    .byte $50 ; | X X    | $FEA6
    .byte $50 ; | X X    | $FEA7
    .byte $00 ; |        | $FEA8
    .byte $00 ; |        | $FEA9
    .byte $27 ; |  X  XXX| $FEAA
    .byte $27 ; |  X  XXX| $FEAB
    .byte $A3 ; |X X   XX| $FEAC
    .byte $A3 ; |X X   XX| $FEAD
    .byte $E5 ; |XXX  X X| $FEAE

LFEAF:
    lda    ram_A3                ; 3
    ora    ram_A4                ; 3
    beq    LFECC                 ; 2³
    bit    ram_D8                ; 3
    bvc    LFEC1                 ; 2³
LFEB9:
    lda    ram_D8                ; 3
    and    #$80                  ; 2
    eor    #$80                  ; 2
    sta    ram_D8                ; 3
LFEC1:
    lda    ram_D8                ; 3
    asl                          ; 2
    rol                          ; 2
    and    #$01                  ; 2
    tax                          ; 2
    lda    ram_A3,X              ; 4
    beq    LFEB9                 ; 2³
LFECC:
    rts                          ; 6

LFECD:
    lsr                          ; 2
LFECE:
    lsr                          ; 2
LFECF:
    lsr                          ; 2
    lsr                          ; 2
    rts                          ; 6

LFED2:
    .byte $03 ; |      XX| $FED2
    .byte $05 ; |     X X| $FED3
    .byte $06 ; |     XX | $FED4
    .byte $03 ; |      XX| $FED5
    .byte $03 ; |      XX| $FED6
    .byte $01 ; |       X| $FED7
    .byte $05 ; |     X X| $FED8
    .byte $04 ; |     X  | $FED9
    .byte $06 ; |     XX | $FEDA
    .byte $06 ; |     XX | $FEDB
    .byte $04 ; |     X  | $FEDC
LFEDD:
    .byte $00 ; |        | $FEDD
    .byte $07 ; |     XXX| $FEDE
    .byte $01 ; |       X| $FEDF
    .byte $06 ; |     XX | $FEE0
    .byte $02 ; |      X | $FEE1
    .byte $05 ; |     X X| $FEE2
    .byte $03 ; |      XX| $FEE3
    .byte $04 ; |     X  | $FEE4
LFEE5:
    .byte $05 ; |     X X| $FEE5
    .byte $10 ; |   X    | $FEE6
    .byte $15 ; |   X X X| $FEE7
    .byte $20 ; |  X     | $FEE8
    .byte $25 ; |  X  X X| $FEE9
    .byte $30 ; |  XX    | $FEEA
    .byte $35 ; |  XX X X| $FEEB
    .byte $40 ; | X      | $FEEC

  IF SEGA_GENESIS
SaveBytes:
    STY    ram_8A
    LDA    #$20
    STA    ram_D9
    LDA    #$E0
    STA    ram_B6
    LDA    #$0F
    STA    ram_EB
    LDX    #$3C
    JMP    RejoinCode

  ELSE
    .byte $EA ; |XXX X X | $FEED
    .byte $EA ; |XXX X X | $FEEE
    .byte $EA ; |XXX X X | $FEEF
    .byte $EA ; |XXX X X | $FEF0
    .byte $EA ; |XXX X X | $FEF1
    .byte $EA ; |XXX X X | $FEF2
    .byte $EA ; |XXX X X | $FEF3
    .byte $EA ; |XXX X X | $FEF4
    .byte $EA ; |XXX X X | $FEF5
    .byte $EA ; |XXX X X | $FEF6
    .byte $EA ; |XXX X X | $FEF7
    .byte $EA ; |XXX X X | $FEF8
    .byte $EA ; |XXX X X | $FEF9
    .byte $EA ; |XXX X X | $FEFA
    .byte $EA ; |XXX X X | $FEFB
    .byte $EA ; |XXX X X | $FEFC
    .byte $EA ; |XXX X X | $FEFD
    .byte $EA ; |XXX X X | $FEFE
    .byte $EA ; |XXX X X | $FEFF
  ENDIF

       ORG $FF00

    .byte $3C ; |  XXXX  | $FF00
    .byte $66 ; | XX  XX | $FF01
    .byte $66 ; | XX  XX | $FF02
    .byte $66 ; | XX  XX | $FF03
    .byte $66 ; | XX  XX | $FF04
    .byte $66 ; | XX  XX | $FF05
    .byte $66 ; | XX  XX | $FF06
    .byte $3C ; |  XXXX  | $FF07
    .byte $3C ; |  XXXX  | $FF08
    .byte $18 ; |   XX   | $FF09
    .byte $18 ; |   XX   | $FF0A
    .byte $18 ; |   XX   | $FF0B
    .byte $18 ; |   XX   | $FF0C
    .byte $18 ; |   XX   | $FF0D
    .byte $38 ; |  XXX   | $FF0E
    .byte $18 ; |   XX   | $FF0F
    .byte $7E ; | XXXXXX | $FF10
    .byte $60 ; | XX     | $FF11
    .byte $60 ; | XX     | $FF12
    .byte $3C ; |  XXXX  | $FF13
    .byte $06 ; |     XX | $FF14
    .byte $06 ; |     XX | $FF15
    .byte $46 ; | X   XX | $FF16
    .byte $3C ; |  XXXX  | $FF17
    .byte $3C ; |  XXXX  | $FF18
    .byte $46 ; | X   XX | $FF19
    .byte $06 ; |     XX | $FF1A
    .byte $0C ; |    XX  | $FF1B
    .byte $0C ; |    XX  | $FF1C
    .byte $06 ; |     XX | $FF1D
    .byte $46 ; | X   XX | $FF1E
    .byte $3C ; |  XXXX  | $FF1F
    .byte $0C ; |    XX  | $FF20
    .byte $0C ; |    XX  | $FF21
    .byte $0C ; |    XX  | $FF22
    .byte $7E ; | XXXXXX | $FF23
    .byte $4C ; | X  XX  | $FF24
    .byte $2C ; |  X XX  | $FF25
    .byte $1C ; |   XXX  | $FF26
    .byte $0C ; |    XX  | $FF27
    .byte $7C ; | XXXXX  | $FF28
    .byte $46 ; | X   XX | $FF29
    .byte $06 ; |     XX | $FF2A
    .byte $06 ; |     XX | $FF2B
    .byte $7C ; | XXXXX  | $FF2C
    .byte $60 ; | XX     | $FF2D
    .byte $60 ; | XX     | $FF2E
    .byte $7E ; | XXXXXX | $FF2F
    .byte $3C ; |  XXXX  | $FF30
    .byte $66 ; | XX  XX | $FF31
    .byte $66 ; | XX  XX | $FF32
    .byte $66 ; | XX  XX | $FF33
    .byte $7C ; | XXXXX  | $FF34
    .byte $60 ; | XX     | $FF35
    .byte $62 ; | XX   X | $FF36
    .byte $3C ; |  XXXX  | $FF37
    .byte $18 ; |   XX   | $FF38
    .byte $18 ; |   XX   | $FF39
    .byte $18 ; |   XX   | $FF3A
    .byte $18 ; |   XX   | $FF3B
    .byte $0C ; |    XX  | $FF3C
    .byte $06 ; |     XX | $FF3D
    .byte $42 ; | X    X | $FF3E
    .byte $7E ; | XXXXXX | $FF3F
    .byte $3C ; |  XXXX  | $FF40
    .byte $66 ; | XX  XX | $FF41
    .byte $66 ; | XX  XX | $FF42
    .byte $3C ; |  XXXX  | $FF43
    .byte $3C ; |  XXXX  | $FF44
    .byte $66 ; | XX  XX | $FF45
    .byte $66 ; | XX  XX | $FF46
    .byte $3C ; |  XXXX  | $FF47
    .byte $3C ; |  XXXX  | $FF48
    .byte $46 ; | X   XX | $FF49
    .byte $06 ; |     XX | $FF4A
    .byte $3E ; |  XXXXX | $FF4B
    .byte $66 ; | XX  XX | $FF4C
    .byte $66 ; | XX  XX | $FF4D
    .byte $66 ; | XX  XX | $FF4E
    .byte $3C ; |  XXXX  | $FF4F
    .byte $00 ; |        | $FF50
    .byte $00 ; |        | $FF51
    .byte $00 ; |        | $FF52
    .byte $00 ; |        | $FF53
    .byte $00 ; |        | $FF54
    .byte $00 ; |        | $FF55
    .byte $00 ; |        | $FF56
    .byte $00 ; |        | $FF57
LFF58:
    .byte $0C ; |    XX  | $FF58
    .byte $06 ; |     XX | $FF59
    .byte $03 ; |      XX| $FF5A
    .byte $01 ; |       X| $FF5B
    .byte $00 ; |        | $FF5C
    .byte $00 ; |        | $FF5D
    .byte $00 ; |        | $FF5E
    .byte $00 ; |        | $FF5F
LFF60:
    .byte $2D ; |  X XX X| $FF60
    .byte $29 ; |  X X  X| $FF61
    .byte $E9 ; |XXX X  X| $FF62
    .byte $A9 ; |X X X  X| $FF63
    .byte $ED ; |XXX XX X| $FF64
    .byte $61 ; | XX    X| $FF65
    .byte $2F ; |  X XXXX| $FF66
    .byte $00 ; |        | $FF67
LFF68:
    .byte $50 ; | X X    | $FF68
    .byte $58 ; | X XX   | $FF69
    .byte $5C ; | X XXX  | $FF6A
    .byte $56 ; | X X XX | $FF6B
    .byte $53 ; | X X  XX| $FF6C
    .byte $11 ; |   X   X| $FF6D
    .byte $F0 ; |XXXX    | $FF6E
    .byte $00 ; |        | $FF6F
LFF70:
    .byte $BA ; |X XXX X | $FF70
    .byte $8A ; |X   X X | $FF71
    .byte $BA ; |X XXX X | $FF72
    .byte $A2 ; |X X   X | $FF73
    .byte $3A ; |  XXX X | $FF74
    .byte $80 ; |X       | $FF75
    .byte $FE ; |XXXXXXX | $FF76
    .byte $00 ; |        | $FF77
LFF78:
    .byte $E9 ; |XXX X  X| $FF78
    .byte $AB ; |X X X XX| $FF79
    .byte $AF ; |X X XXXX| $FF7A
    .byte $AD ; |X X XX X| $FF7B
    .byte $E9 ; |XXX X  X| $FF7C
    .byte $00 ; |        | $FF7D
    .byte $00 ; |        | $FF7E
    .byte $00 ; |        | $FF7F
    .byte $00 ; |        | $FF80
    .byte $00 ; |        | $FF81
    .byte $00 ; |        | $FF82
    .byte $F7 ; |XXXX XXX| $FF83
    .byte $95 ; |X  X X X| $FF84
    .byte $87 ; |X    XXX| $FF85
    .byte $90 ; |X  X    | $FF86
    .byte $F0 ; |XXXX    | $FF87
    .byte $00 ; |        | $FF88
    .byte $47 ; | X   XXX| $FF89
    .byte $41 ; | X     X| $FF8A
    .byte $77 ; | XXX XXX| $FF8B
    .byte $55 ; | X X X X| $FF8C
    .byte $75 ; | XXX X X| $FF8D
    .byte $00 ; |        | $FF8E
    .byte $00 ; |        | $FF8F
    .byte $00 ; |        | $FF90
    .byte $03 ; |      XX| $FF91
    .byte $00 ; |        | $FF92
    .byte $4B ; | X  X XX| $FF93
    .byte $4A ; | X  X X | $FF94
    .byte $6B ; | XX X XX| $FF95
    .byte $00 ; |        | $FF96
    .byte $08 ; |    X   | $FF97
    .byte $00 ; |        | $FF98
    .byte $80 ; |X       | $FF99
    .byte $80 ; |X       | $FF9A
    .byte $AA ; |X X X X | $FF9B
    .byte $AA ; |X X X X | $FF9C
    .byte $BA ; |X XXX X | $FF9D
    .byte $27 ; |  X  XXX| $FF9E
    .byte $22 ; |  X   X | $FF9F
    .byte $00 ; |        | $FFA0
    .byte $00 ; |        | $FFA1
    .byte $00 ; |        | $FFA2
    .byte $11 ; |   X   X| $FFA3
    .byte $11 ; |   X   X| $FFA4
    .byte $17 ; |   X XXX| $FFA5
    .byte $15 ; |   X X X| $FFA6
    .byte $17 ; |   X XXX| $FFA7
    .byte $00 ; |        | $FFA8
    .byte $00 ; |        | $FFA9
    .byte $00 ; |        | $FFAA
    .byte $77 ; | XXX XXX| $FFAB
    .byte $51 ; | X X   X| $FFAC
    .byte $73 ; | XXX  XX| $FFAD
    .byte $51 ; | X X   X| $FFAE
    .byte $77 ; | XXX XXX| $FFAF
LFFB0:
    .byte $84 ; |X    X  | $FFB0
    .byte $D6 ; |XX X XX | $FFB1
    .byte $D6 ; |XX X XX | $FFB2
    .byte $1A ; |   XX X | $FFB3
    .byte $26 ; |  X  XX | $FFB4
    .byte $26 ; |  X  XX | $FFB5
    .byte $44 ; | X   X  | $FFB6
    .byte $00 ; |        | $FFB7
LFFB8:
    .byte $FE ; |XXXXXXX | $FFB8
    .byte $FD ; |XXXXXX X| $FFB9
    .byte $FB ; |XXXXX XX| $FFBA
    .byte $F7 ; |XXXX XXX| $FFBB
    .byte $EF ; |XXX XXXX| $FFBC
    .byte $DF ; |XX XXXXX| $FFBD
    .byte $BF ; |X XXXXXX| $FFBE
    .byte $7F ; | XXXXXXX| $FFBF
LFFC0:
    .byte $01 ; |       X| $FFC0
    .byte $02 ; |      X | $FFC1
    .byte $04 ; |     X  | $FFC2
    .byte $08 ; |    X   | $FFC3
    .byte $10 ; |   X    | $FFC4
    .byte $20 ; |  X     | $FFC5
    .byte $40 ; | X      | $FFC6
    .byte $80 ; |X       | $FFC7
LFFC8:
    .byte $0B ; |    X XX| $FFC8
    .byte $1C ; |   XXX  | $FFC9
    .byte $2C ; |  X XX  | $FFCA
    .byte $3D ; |  XXXX X| $FFCB
    .byte $4D ; | X  XX X| $FFCC
    .byte $5E ; | X XXXX | $FFCD
    .byte $24 ; |  X  X  | $FFCE
    .byte $24 ; |  X  X  | $FFCF
    .byte $3C ; |  XXXX  | $FFD0
    .byte $7E ; | XXXXXX | $FFD1
    .byte $7E ; | XXXXXX | $FFD2
    .byte $7E ; | XXXXXX | $FFD3
    .byte $7E ; | XXXXXX | $FFD4
    .byte $66 ; | XX  XX | $FFD5
LFFD6:
    .byte $0A ; |    X X | $FFD6
    .byte $07 ; |     XXX| $FFD7
    .byte $0C ; |    XX  | $FFD8
    .byte $0D ; |    XX X| $FFD9
    .byte $0D ; |    XX X| $FFDA
    .byte $08 ; |    X   | $FFDB
    .byte $0D ; |    XX X| $FFDC
    .byte $0D ; |    XX X| $FFDD

LFFDE:
    lda    ram_82                ; 3
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    eor    ram_82                ; 3
    asl                          ; 2
    rol    ram_82                ; 5

  IF SEGA_GENESIS
    LDA    ram_C5
    STA    ram_F3
  ENDIF

    jmp    LFEAF                 ; 3

LFFEB:
    .byte $00 ; |        | $FFEB
    .byte $20 ; |  X     | $FFEC
    .byte $10 ; |   X    | $FFED
    .byte $10 ; |   X    | $FFEE
    .byte $00 ; |        | $FFEF
LFFF0:
    .byte $00 ; |        | $FFF0
    .byte $00 ; |        | $FFF1
    .byte $00 ; |        | $FFF2
    .byte $01 ; |       X| $FFF3
    .byte $00 ; |        | $FFF4
    .byte $02 ; |      X | $FFF5
    .byte $01 ; |       X| $FFF6
    .byte $03 ; |      XX| $FFF7

  IF !SEGA_GENESIS
    .byte $EA ; |XXX X X | $FFF8
    .byte $EA ; |XXX X X | $FFF9
    .byte $EA ; |XXX X X | $FFFA
    .byte $EA ; |XXX X X | $FFFB
  ENDIF

      ORG $FFFC
    .byte $00 ; |        | $FFFC
    .byte $F0 ; |XXXX    | $FFFD
  IF SEGA_GENESIS
    .word LF004
  ELSE
    .byte $00 ; |        | $FFFE
    .byte $F0 ; |XXXX    | $FFFF
  ENDIF
