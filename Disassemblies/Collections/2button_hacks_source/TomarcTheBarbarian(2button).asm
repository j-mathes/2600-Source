; Tomarc the Barbarian
; With Sega Genesis controls added by Omegamatrix
; Last update Nov 30, 2013
;
;
;  Sega Genesis Controls:
;    - Pressing Button B, Button C, or Reset will start the game.
;    - Press Button C to switch between Tomarc and Senta playing screens.
;
;
;
; Tomarc1.cfg contents:
;
;      ORG F000
;      CODE F000 F922
;      GFX F923 FFE9
;      CODE FFEA FFF6
;      GFX FFF7 FFFF
;
;
; Tomarc2.cfg contents:
;
;      ORG F000
;      CODE F000 F01E
;      GFX F01F F024
;      CODE F025 FEA3
;      GFX FEA4 FFF2
;      CODE FFF3 FFF6
;      GFX FFF7 FFFF


      processor 6502
      include vcs.h

COLOR_NTSC           = 0  ; 1 = NTSC colors, 0 = PAL colors
      include colors.h

CORRECT_SCANLINES    = 1
SEGA_GENESIS         = 1

  IF SEGA_GENESIS
TITLE_TO_PLAY_RESET  = 19 ; blank scanlines for correction
  ELSE
TITLE_TO_PLAY_RESET  = 20 ; blank scanlines for correction
  ENDIF
PLAY_TO_TITLE_RESET  = 18  ; blank scanlines for correction
DEATH_TO_TITLE_RESET  = 255
VICTORY_TO_GAME_START = 255

  IF CORRECT_SCANLINES
TIM_1          = 15  ; common Vblank Tomarc and Senta playing screen
TIM_2          = 23  ; Tomarc (playing screen) Overscan line
TIM_3          = 23  ; Senta (playing screen) Overscan 
TIM_4          = 24  ; overscan title with score
TIM_4A         = 24  ; overscan title
TIM_5          = 22  ; vblank title
  ELSE
TIM_1          = $34  ; common Vblank Tomarc and Senta playing screen
TIM_2          = $F8  ; Tomarc (playing screen) Overscan
TIM_3          = $DF  ; Senta (playing screen) Overscan
TIM_4          = $B9
TIM_4A         = TIM_4
TIM_5          = $C2
  ENDIF

BANK_0         = $FFF8
BANK_1         = $FFF9




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      RIOT RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       SEG.U RIOT_RAM
       ORG $80

ram_80             ds 1  ; x36
ram_81             ds 1  ; x6
ram_82             ds 1  ; x4
ram_83             ds 1  ; x3
ram_84             ds 1  ; x4
ram_85             ds 1  ; x1
ram_86             ds 1  ; x2
ram_87             ds 1  ; x1
ram_88             ds 2  ; x1
ram_8A             ds 2  ; x1
ram_8C             ds 2  ; x1
ram_8E             ds 2  ; x1
ram_90             ds 1  ; x6
ram_91             ds 1  ; x1
ram_92             ds 1  ; x1
ram_93             ds 1  ; x38
ram_94             ds 2  ; x9
ram_96             ds 2  ; x5
ram_98             ds 2  ; x2
ram_9A             ds 2  ; x2
ram_9C             ds 2  ; x3
ram_9E             ds 1  ; x7
ram_9F             ds 1  ; x28
ram_A0             ds 1  ; x12
ram_A1             ds 1  ; x16
ram_A2             ds 2  ; x5
ram_A4             ds 1  ; x4
ram_A5             ds 1  ; x33
ram_A6             ds 1  ; x7
ram_A7             ds 1  ; x3
ram_A8             ds 1  ; x4
ram_A9             ds 1  ; x12
ram_AA             ds 1  ; x8
ram_AB             ds 1  ; x5
ram_AC             ds 1  ; x7
ram_AD             ds 1  ; x39
ram_AE             ds 1  ; x4
ram_AF             ds 1  ; x3
ram_B0             ds 1  ; x1
ram_B1             ds 1  ; x16
ram_B2             ds 1  ; x7
ram_B3             ds 1  ; x38
ram_B4             ds 1  ; x6
ram_B5             ds 1  ; x14
ram_B6             ds 1  ; x14
ram_B7             ds 1  ; x10
ram_B8             ds 1  ; x5
ram_B9             ds 1  ; x42
ram_BA             ds 1  ; x7
ram_BB             ds 1  ; x12
ram_BC             ds 1  ; x5
ram_BD             ds 1  ; x1
ram_BE             ds 1  ; x10
ram_BF             ds 1  ; x6
ram_C0             ds 1  ; x31
ram_C1             ds 1  ; x10
ram_C2             ds 1  ; x5
ram_C3             ds 1  ; x2
ram_C4             ds 1  ; x5
ram_C5             ds 1  ; x2
ram_C6             ds 1  ; x4
ram_C7             ds 1  ; x1
ram_C8             ds 1  ; x7
ram_C9             ds 1  ; x1
ram_CA             ds 1  ; x11
ram_CB             ds 1  ; x9
ram_CC             ds 1  ; x9
ram_CD             ds 1  ; x6
ram_CE             ds 1  ; x4
ram_CF             ds 1  ; x4
ram_D0             ds 1  ; x4
ram_D1             ds 1  ; x4
ram_D2             ds 1  ; x11
ram_D3             ds 1  ; x4
ram_D4             ds 1  ; x4
ram_D5             ds 1  ; x3
ram_D6             ds 1  ; x11
ram_D7             ds 1  ; x5
ram_D8             ds 1  ; x5
ram_D9             ds 1  ; x5
ram_DA             ds 1  ; x5
ram_DB             ds 1  ; x3
ram_DC             ds 1  ; x24
ram_DD             ds 1  ; x14
ram_DE             ds 1  ; x11
ram_DF             ds 1  ; x9
ram_E0             ds 1  ; x16
ram_E1             ds 1  ; x8
ram_E2             ds 1  ; x7
ram_E3             ds 1  ; x8
ram_E4             ds 1  ; x6
ram_E5             ds 1  ; x2
ram_E6             ds 1  ; x7
ram_E7             ds 1  ; x6
ram_E8             ds 1  ; x7
ram_E9             ds 1  ; x5
ram_EA             ds 1  ; x2
ram_EB             ds 1  ; x6
ram_EC             ds 1  ; x5
ram_ED             ds 1  ; x45
ram_EE             ds 1  ; x8
ram_EF             ds 1  ; x5
ram_F0             ds 1  ; x4
ram_F1             ds 1  ; x4
ram_F2             ds 1  ; x7
ram_F3             ds 1  ; x2

freeRam            ds 6 ; $F4-$F9
tempIndex          equ freeRam
dontUse            ds 6 ; $FA-$FF used for stack pushes and jsr



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      BANK 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       SEG CODE
       ORG $0000
      RORG $F000

LF000:  ; indirect jump
    jsr    LF78A                 ; 6
    stx    WSYNC                 ; 3
    ldx    #$02                  ; 2
LF007:
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    ram_81,X              ; 4
    sta    ram_90,X              ; 4
    dex                          ; 2
    bpl    LF007                 ; 2³
    jsr    LF78A                 ; 6
LF013:  ; indirect jump
    lda    #$80                  ; 2
    sta    HMP1                  ; 3
    ldx    #$01                  ; 2
LF019:
    sta    WSYNC                 ; 3
;---------------------------------------
  IF COLOR_NTSC
    jsr    LF76A                 ; 6
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
  ELSE
    JSR    Waste22
  ENDIF
    sta    RESP0,X               ; 4
    dex                          ; 2
    bpl    LF019                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMP0                  ; 3
    ldx    #$12                  ; 2
    lda    #COL_00               ; 2
    sta    COLUBK                ; 3
    ldy    #$A5                  ; 2
LF038:
    sty    WSYNC                 ; 3
;---------------------------------------
    lda    LF99F,Y               ; 4
    sta    GRP0                  ; 3
    lda    LFA45,Y               ; 4
    sta    GRP1                  ; 3
    lda    ram_D2                ; 3
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3

  IF COLOR_NTSC
    clc                          ; 2
    adc    #$10                  ; 2
    sta    ram_D2                ; 3
  ELSE
    JSR    ConvertPalColorScroll
  ENDIF

    dey                          ; 2
    beq    LF06B                 ; 2³
    dex                          ; 2
    bne    LF038                 ; 2³
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    GRP0                  ; 3
    stx    GRP1                  ; 3
    dey                          ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    dey                          ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    dey                          ; 2
    ldx    #$12                  ; 2
  IF !COLOR_NTSC
    BNE    LF038
  ELSE
    jmp    LF038                 ; 3
  ENDIF

  IF !COLOR_NTSC
ConvertPalColorScroll:
    STY    tempIndex
    LSR
    LSR
    LSR
    LSR
    TAY
    LDA    ColTabPal-2,Y ; color is now PAL
    LDY    tempIndex
    STA    ram_D2
    RTS

ColTabPal:
    .byte $42  ;2
    .byte $22  ;3
    .byte $62  ;4
    .byte $32  ;5
    .byte $82  ;6
    .byte $52  ;7
    .byte $A2  ;8
    .byte $72  ;9
    .byte $C2  ;A
    .byte $92  ;B
    .byte $D2  ;C
    .byte $B2  ;D

    NOP  ; free byte
    NOP
  ENDIF


LF06B:
    sty    WSYNC                 ; 3
;---------------------------------------
  IF CORRECT_SCANLINES
    INX
    STX    VBLANK  ; VBLANK starts
  ENDIF


    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    sty    REFP0                 ; 3
    sty    REFP1                 ; 3
    sty    COLUBK                ; 3
    sty    HMCLR                 ; 3
    lda    ram_D2                ; 3

  IF COLOR_NTSC
    clc                          ; 2
    adc    #$10                  ; 2
    sta    ram_D2                ; 3
  ELSE
     JSR    ConvertPalColorScroll
  ENDIF

    stx    WSYNC                 ; 3
;---------------------------------------
    jmp    LFFF3                 ; 3

LF085:  ; indirect jump
    lda    ram_80                ; 3
    asl                          ; 2
    tax                          ; 2
    ldy    #$01                  ; 2
    inx                          ; 2
LF08C:
    lda    LFBE2,X               ; 4
    sta.wy ram_94,Y              ; 5
    lda    LFBE4,X               ; 4
    sta.wy ram_96,Y              ; 5
    lda    LFC74,X               ; 4
    sta.wy ram_98,Y              ; 5
    lda    LFC86,X               ; 4
    sta.wy ram_9A,Y              ; 5
    lda    LFCAA,X               ; 4
    sta.wy ram_9C,Y              ; 5
    lda    LFC98,X               ; 4
    sta.wy ram_A2,Y              ; 5
    dex                          ; 2
    dey                          ; 2
    bpl    LF08C                 ; 2³
    ldx    ram_80                ; 3
    lda    LFCBC,X               ; 4  playfield colors
    sta    ram_9E                ; 3
    lda    LFBBE,X               ; 4  background colors
    sta    ram_F3                ; 3
    ldx    #$B0                  ; 2
    ldy    #$FE                  ; 2
    stx    ram_AA                ; 3
    sty    ram_AB                ; 3
    lda    ram_ED                ; 3
    and    #$10                  ; 2
    bne    LF0DA                 ; 2³
    stx    ram_DE                ; 3
    sty    ram_DF                ; 3
    stx    ram_E3                ; 3
    sty    ram_E4                ; 3
    stx    ram_E8                ; 3
    sty    ram_E9                ; 3
LF0DA:
    lda    ram_AD                ; 3
    and    #$08                  ; 2
    bne    LF111                 ; 2³+1
    lda    #$FF                  ; 2
    sta    ram_E0                ; 3
    sta    ram_E5                ; 3
    sta    ram_EA                ; 3
    lda    ram_ED                ; 3
    and    #$10                  ; 2
    bne    LF0FC                 ; 2³
    lda    #$05                  ; 2
    sta    ram_E1                ; 3
    sta    ram_E2                ; 3
    sta    ram_E6                ; 3
    sta    ram_E7                ; 3
    sta    ram_EB                ; 3
    sta    ram_EC                ; 3
LF0FC:
    lda    #$B4                  ; 2
    sta    ram_A8                ; 3
    lda    #$F0                  ; 2
    sta    ram_A9                ; 3

  IF CORRECT_SCANLINES
    LDA    ram_C0
    AND    #$BF
    STA    ram_C0
    LDA    #$00
    STA    ram_B6
    BEQ    LF11D  ; always branch

  ELSE
    lda    #$00                  ; 2
    sta    ram_B6                ; 3
    lda    ram_C0                ; 3
    and    #$BF                  ; 2
    sta    ram_C0                ; 3
    jmp    LF11D                 ; 3
  ENDIF

LF111:
    lda    ram_AD                ; 3
    and    #$04                  ; 2
    beq    LF11D                 ; 2³
    lda    ram_AD                ; 3
    and    #$F3                  ; 2
    sta    ram_AD                ; 3
LF11D:
    lda    #$80                  ; 2
    sta    ram_B2                ; 3
    jmp    LFFF3                 ; 3

LF124:  ; indirect jump
    lda    #COL_52               ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    ldy    #$00                  ; 2
    sty    REFP0                 ; 3
    sty    REFP1                 ; 3
    ldx    #TIM_1                ; 2
    lda    ram_ED                ; 3
    and    #$20                  ; 2
    bne    LF13B                 ; 2³
    jmp    LF4D7                 ; 3

LF13B:
    stx    WSYNC                 ; 3
;---------------------------------------
  IF CORRECT_SCANLINES
    STX    TIM64T
  ELSE
    stx    TIM8T                 ; 4
  ENDIF
    ldy    #$09                  ; 2
    lda    (ram_B7),Y            ; 5
    sta    ram_CA                ; 3
    lda    (ram_BC),Y            ; 5
    sta    ram_CD                ; 3
    lda    (ram_C2),Y            ; 5
    sta    ram_CE                ; 3
    lda    (ram_C6),Y            ; 5
    sta    ram_CF                ; 3
    lda    (ram_C4),Y            ; 5
    sta    ram_D0                ; 3
    lda    (ram_C8),Y            ; 5
    sta    ram_D1                ; 3
    jsr    LF850                 ; 6
LF15D:
  IF CORRECT_SCANLINES
    BIT    TIMINT
    BPL    LF15D
  ELSE
    ldx    INTIM                 ; 4
    bne    LF15D                 ; 2³
  ENDIF
    stx    WSYNC                 ; 3
    ldx    #$02                  ; 2
LF166:
    lda    ram_81,X              ; 4
    sta    ram_90,X              ; 4
    dex                          ; 2
    bpl    LF166                 ; 2³
    jsr    LF78A                 ; 6
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_9E                ; 3
    and    #$F2                  ; 2
    sta    ram_84                ; 3
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    jsr    LF815                 ; 6
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    jsr    LF76B                 ; 6
    stx    HMP0                  ; 3
    tay                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
LF18D:
    dey                          ; 2
    bne    LF18D                 ; 2³
    sta    RESP0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    ram_B3                ; 3
    and    #$80                  ; 2
    beq    LF19E                 ; 2³
    lda    #$08                  ; 2
LF19E:
    sta    REFP0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sty    HMP0                  ; 3
    lda    ram_AD                ; 3
    and    #$08                  ; 2
    bne    LF1B0                 ; 2³
    lda    ram_A9                ; 3
    cmp    #$F0                  ; 2
    bmi    LF1EE                 ; 2³
LF1B0:
    lda    ram_B1                ; 3
    and    #$0F                  ; 2
    cmp    ram_80                ; 3
    bne    LF1EE                 ; 2³
    lda    ram_93                ; 3
    and    #$20                  ; 2
    bne    LF1EE                 ; 2³
    lda    #COL_16               ; 2
    sta    COLUP1                ; 3
    lda    #$D0                  ; 2
    sta    HMP1                  ; 3
    ldy    #$09                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
LF1CA:
    dey                          ; 2
    bne    LF1CA                 ; 2³
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    ldx    ram_80                ; 3
    lda    LFF7B,X               ; 4
    sta    ram_D6                ; 3
    lda    #$BD                  ; 2
    sec                          ; 2
    sbc    ram_D6                ; 3
    sta    ram_AA                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
    sta    ram_AB                ; 3
    sty    REFP1                 ; 3
    ldx    #$05                  ; 2
  IF CORRECT_SCANLINES
    BNE    LF233  ; always branch
  ELSE
    jmp    LF233                 ; 3
  ENDIF

LF1EE:
    lda    #COL_08               ; 2
    sta    COLUP1                ; 3
    lda    ram_D3                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    jsr    LF76B                 ; 6
    stx    HMP1                  ; 3
    tay                          ; 2
  IF COLOR_NTSC
    nop                          ; 2
    nop                          ; 2
  ENDIF
    sta    WSYNC                 ; 3
;---------------------------------------
LF200:
    dey                          ; 2
    bne    LF200                 ; 2³
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    ram_D6                ; 3
    beq    LF231                 ; 2³
    lda    ram_B1                ; 3
    bmi    LF21E                 ; 2³
    lda    ram_DC                ; 3
    and    #$01                  ; 2
    beq    LF219                 ; 2³
    lda    #$08                  ; 2
LF219:
    sta    REFP1                 ; 3
  IF CORRECT_SCANLINES
    BPL    LF231  ; always branch
  ELSE
    jmp    LF231                 ; 3
  ENDIF

LF21E:
    ldx    ram_80                ; 3
    lda    LFFBE,X               ; 4
    tax                          ; 2
    lda    ram_E0,X              ; 4
    bmi    LF22D                 ; 2³
    lda    #$00                  ; 2
  IF !COLOR_NTSC
    .byte $0C  ; NOP, skip 2 bytes
  ELSE
    jmp    LF22F                 ; 3
  ENDIF

LF22D:
    lda    #$08                  ; 2
LF22F:
    sta    REFP1                 ; 3
LF231:
    ldx    #$04                  ; 2
LF233:
    sta    WSYNC                 ; 3
;---------------------------------------
    dex                          ; 2
    bne    LF233                 ; 2³
    ldy    #$0E                  ; 2
    lda    ram_9E                ; 3
    and    #$F2                  ; 2
    tax                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_F3                ; 3  done
    sta    COLUBK                ; 3
    lda    #$F0                  ; 2
    sta    PF0                   ; 3
LF249:
    stx    COLUPF                ; 3  done
    lda    (ram_98),Y            ; 5
    sta    PF1                   ; 3
    lda    (ram_9C),Y            ; 5
    sta    PF2                   ; 3
    lda    ram_9E                ; 3
    and    LF92D,Y               ; 4
    tax                          ; 2
    lda    (ram_9A),Y            ; 5
    nop                          ; 2
    nop                          ; 2
    sta    PF1                   ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    dey                          ; 2
    bne    LF249                 ; 2³
    stx    COLUPF                ; 3  done
    sty    PF1                   ; 3
    lda    (ram_9C),Y            ; 5
    sta    PF2                   ; 3
    ldy    #$7E                  ; 2
    cpy    ram_B9                ; 3
    bne    LF277                 ; 2³
    lda    (ram_94),Y            ; 5
    jmp    LF306                 ; 3

LF277:
    sta    WSYNC                 ; 3
;---------------------------------------
LF279:
    lda    (ram_94),Y            ; 5
    sta    PF0                   ; 3
    lda    (ram_A2),Y            ; 5
    sta    PF2                   ; 3
    jsr    LF76A                 ; 6
    lda    (ram_96),Y            ; 5
    sta    PF0                   ; 3
    dey                          ; 2
    cpy    ram_D6                ; 3
    bne    LF290                 ; 2³
  IF !COLOR_NTSC
    BEQ    LF2A2  ; always branch
  ELSE
    jmp    LF2A2                 ; 3
  ENDIF

LF290:
    cpy    ram_B9                ; 3
    bne    LF299                 ; 2³
  IF !COLOR_NTSC
    JMP    LF304
  ELSE
    lda    (ram_94),Y            ; 5
    jmp    LF306                 ; 3
  ENDIF

LF299:
    sta    WSYNC                 ; 3
;---------------------------------------
    cpy    #$00                  ; 2
    bne    LF279                 ; 2³
LF29F:
    jmp    LF340                 ; 3

LF2A2:
    cpy    ram_B9                ; 3
    bne    LF2A9                 ; 2³
  IF !COLOR_NTSC
    BEQ    LF2D6
  ELSE
    jmp    LF2D6                 ; 3
  ENDIF

LF2A9:
    sta    WSYNC                 ; 3
;---------------------------------------
    cpy    #$00                  ; 2
    beq    LF29F                 ; 2³
    lda    (ram_94),Y            ; 5
    sta    PF0                   ; 3
    lda    (ram_A2),Y            ; 5
    sta    PF2                   ; 3
    lda    (ram_AA),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_96),Y            ; 5
    sta    PF0                   ; 3
    dey                          ; 2
    dec    ram_D7                ; 5
    cpy    ram_B9                ; 3
    bne    LF2CF                 ; 2³
    lda    ram_D7                ; 3
    bne    LF2D6                 ; 2³
  IF !COLOR_NTSC
    JMP    LF304
  ELSE
    lda    (ram_94),Y            ; 5
    jmp    LF306                 ; 3
  ENDIF

LF2CF:
    lda    ram_D7                ; 3
    bne    LF2A9                 ; 2³
    jmp    LF299                 ; 3

LF2D6:
    lda    (ram_A2),Y            ; 5
    tax                          ; 2
    lda    (ram_94),Y            ; 5
    sta    WSYNC                 ; 3
;---------------------------------------
    cpy    #$00                  ; 2
    beq    LF29F                 ; 2³
    sta    PF0                   ; 3
    stx    PF2                   ; 3
    lda    (ram_A6),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_AF),Y            ; 5
    sta    COLUP0                ; 3
    lda    (ram_AA),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_96),Y            ; 5
    sta    PF0                   ; 3
    dey                          ; 2
    dec    ram_D9                ; 5
    bne    LF2D6                 ; 2³
    lda    ram_DA                ; 3
  IF !COLOR_NTSC
    BEQ    LF334
  ELSE
    beq    LF32C                 ; 2³+1
  ENDIF
    ldx    ram_DB                ; 3
    bne    LF32F                 ; 2³
    sta    ram_D8                ; 3
LF304:
    lda    (ram_94),Y            ; 5
LF306:
    sta    WSYNC                 ; 3
;---------------------------------------
    cpy    #$00                  ;2  @2
    beq    LF29F                 ;2³+1  @4
    sta    PF0                   ;3  @7
    lda    (ram_A6),Y            ;5  @12
    sta    GRP0                  ;3  @15
    lda    (ram_AF),Y            ;5  @20
    sta    COLUP0                ;3  @23
    lda    (ram_A2),Y            ;5  @28
    sta    PF2                   ;3  @31
    lda    (ram_96),Y            ;5  @36
    sta    PF0                   ;3  @39
    dey                          ;2  @41
    dec    ram_D8                ;5  @46
    cpy    ram_D6                ;3  @49
    bne    LF337                 ;2³ @51
    lda    ram_D8                ;3  @54
    bne    LF2D6                 ;2³+1  @56


  IF !COLOR_NTSC
    .byte $0C  ; NOP, skip 2 bytes
  ELSE
    jmp    LF2A9                 ; 3
  ENDIF

  IF COLOR_NTSC
LF32C:
    jmp    LF299                 ; 3
  ENDIF

LF32F:
    sta    ram_D7                ; 3
    jmp    LF2A9                 ; 3

LF334:
    jmp    LF299                 ; 3

LF337:
    lda    ram_D8                ; 3
    beq    LF334                 ; 2³
    lda    (ram_94),Y            ; 5
    jmp    LF306                 ; 3

LF340:
    lda    ram_CA                ; 3
    sta    GRP0                  ; 3
    lda    ram_CD                ; 3
    sta    COLUP0                ; 3
    ldy    #$08                  ; 2
    lda    (ram_B7),Y            ; 5
    sta    ram_CA                ; 3
    lda    (ram_BC),Y            ; 5
    sta    ram_CD                ; 3
    dey                          ; 2
    lda    (ram_B7),Y            ; 5
    sta    ram_CB                ; 3
    lda    (ram_BC),Y            ; 5
    sta    ram_CC                ; 3
    lda    ram_E2                ; 3
    sta    HMP1                  ; 3
    ldy    ram_E1                ; 3
    lda    ram_CA                ; 3
    ldx    ram_84                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    GRP0                  ; 3
    stx    COLUPF                ; 3
    lda    #$FF                  ; 2
    sta    PF1                   ; 3
    sta    PF2                   ; 3
    lda    ram_CD                ; 3
    sta    COLUP0                ; 3
LF375:
    dey                          ; 2
    bne    LF375                 ; 2³
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    ram_CB                ; 3
    sta    GRP0                  ; 3
    lda    ram_CC                ; 3
    sta    COLUP0                ; 3
    lda    ram_E0                ; 3
    and    #$80                  ; 2
    beq    LF38E                 ; 2³
    lda    #$08                  ; 2
LF38E:
    sta    REFP1                 ; 3
    lda    #COL_08               ; 2
    sta    COLUP1                ; 3
    ldy    #$07                  ; 2
LF396:
    dey                          ; 2
    beq    LF3BE                 ; 2³
    lda    (ram_B7),Y            ; 5
    sta    ram_CA                ; 3
    lda    (ram_BC),Y            ; 5
    sta    ram_CD                ; 3
    lda    (ram_DE),Y            ; 5
    sta    ram_D2                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    stx    COLUPF                ; 3
    lda    ram_CA                ; 3
    sta    GRP0                  ; 3
    lda    ram_CD                ; 3
    sta    COLUP0                ; 3
    lda    ram_D2                ; 3
    sta    GRP1                  ; 3
    cpy    #$05                  ; 2
    bne    LF396                 ; 2³
    inx                          ; 2
    inx                          ; 2
    jmp    LF396                 ; 3

LF3BE:
    lda    ram_E7                ; 3
    sta    HMP1                  ; 3
    ldy    #$08                  ; 2
    lda    (ram_C2),Y            ; 5
    sta    ram_CB                ; 3
    lda    (ram_C6),Y            ; 5
    sta    ram_CC                ; 3
    ldy    ram_E6                ; 3
    inx                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_9E                ; 3
    inx                          ; 2
    stx    COLUPF                ; 3
    lda    ram_CE                ; 3
    sta    GRP0                  ; 3
    lda    ram_CF                ; 3
    sta    COLUP0                ; 3
LF3DE:
    dey                          ; 2
    bne    LF3DE                 ; 2³
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    ram_CB                ; 3
    sta    GRP0                  ; 3
    lda    ram_CC                ; 3
    sta    COLUP0                ; 3
    ldy    #$08                  ; 2
    lda    ram_E5                ; 3
    and    #$80                  ; 2
    beq    LF3F9                 ; 2³
    lda    #$08                  ; 2
LF3F9:
    sta    REFP1                 ; 3
    lda    #COL_F2               ; 2
    sta    COLUP1                ; 3
LF3FF:
    dey                          ; 2
    beq    LF427                 ; 2³
    lda    (ram_C2),Y            ; 5
    sta    ram_CE                ; 3
    lda    (ram_C6),Y            ; 5
    sta    ram_CF                ; 3
    lda    (ram_E3),Y            ; 5
    sta    ram_D2                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    stx    COLUPF                ; 3
    lda    ram_CE                ; 3
    sta    GRP0                  ; 3
    lda    ram_CF                ; 3
    sta    COLUP0                ; 3
    lda    ram_D2                ; 3
    sta    GRP1                  ; 3
    cpy    #$06                  ; 2
    bne    LF3FF                 ; 2³+1
    inx                          ; 2
    inx                          ; 2
    jmp    LF3FF                 ; 3

LF427:
    lda    ram_EC                ; 3
    sta    HMP1                  ; 3
    ldy    #$08                  ; 2
    lda    (ram_C4),Y            ; 5
    sta    ram_CB                ; 3
    lda    (ram_C8),Y            ; 5
    sta    ram_CC                ; 3
    ldy    ram_EB                ; 3
    inx                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_9E                ; 3
    inx                          ; 2
    stx    COLUPF                ; 3
    lda    ram_D0                ; 3
    sta    GRP0                  ; 3
    lda    ram_D1                ; 3
    sta    COLUP0                ; 3
LF447:
    dey                          ; 2
    bne    LF447                 ; 2³
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    lda    ram_CB                ; 3
    sta    GRP0                  ; 3
    lda    ram_CC                ; 3
    sta    COLUP0                ; 3
    ldy    #$08                  ; 2
    lda    ram_EA                ; 3
    and    #$80                  ; 2
    beq    LF462                 ; 2³
    lda    #$08                  ; 2
LF462:
    sta    REFP1                 ; 3
LF464:
    dey                          ; 2
    beq    LF48C                 ; 2³
    lda    (ram_C4),Y            ; 5
    sta    ram_D0                ; 3
    lda    (ram_C8),Y            ; 5
    sta    ram_D1                ; 3
    lda    (ram_E8),Y            ; 5
    sta    ram_D2                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    stx    COLUPF                ; 3
    lda    ram_D0                ; 3
    sta    GRP0                  ; 3
    lda    ram_D1                ; 3
    sta    COLUP0                ; 3
    lda    ram_D2                ; 3
    sta    GRP1                  ; 3
    cpy    #$05                  ; 2
    bne    LF464                 ; 2³
    inx                          ; 2
    inx                          ; 2
    jmp    LF464                 ; 3

LF48C:
    sty    COLUBK                ; 3
    lda    ram_9E                ; 3
    and    #$F2                  ; 2
    tax                          ; 2
    ldy    ram_80                ; 3
    lda    LFBD9,Y               ; 4
  IF COLOR_NTSC
    jsr    LF76A                 ; 6
    jsr    LF76A                 ; 6
  ELSE
    JSR    Waste24
  ENDIF
    sta    PF2                   ; 3
    ldy    #$04                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    stx    COLUPF                ; 3
    ldx    ram_80                ; 3
LF4A8:
    lda    LFBC7,X               ; 4
    sta    PF1                   ; 3
    lda    LFBD0,X               ; 4
  IF COLOR_NTSC
    jsr    LF76A                 ; 6
    jsr    LF76A                 ; 6
  ELSE
    JSR    Waste24
  ENDIF

  IF CORRECT_SCANLINES
    DEY
    STA    PF1
    BEQ    LF4C1
    STA    WSYNC
;---------------------------------------
    JMP    LF4A8

  ELSE
    nop                          ; 2
    sta    PF1                   ; 3
    dey                          ; 2
    beq    LF4C1                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    jmp    LF4A8                 ; 3
  ENDIF


LF4C1:
    sta    WSYNC                 ; 3
;---------------------------------------
  IF CORRECT_SCANLINES
    LDX    #2
    STX    VBLANK
  ENDIF
    sty    PF0                   ; 3   WRITE TO VBLANK here for Tomarc screen
    sty    PF1                   ; 3
    sty    PF2                   ; 3
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    sty    WSYNC                 ; 3
;---------------------------------------
    ldx    #TIM_2                ; 2
  IF CORRECT_SCANLINES
    STX    TIM64T
  ELSE
    stx    TIM8T                 ; 4
  ENDIF
    jmp    LFFF3                 ; 3

LF4D7:
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
  IF CORRECT_SCANLINES
    STX    TIM64T
  ELSE
    stx    TIM8T                 ; 4
  ENDIF
    jsr    LF850                 ; 6
    ldx    #$02                  ; 2
LF4E5:
    lda    ram_81,X              ; 4
    sta    ram_90,X              ; 4
    dex                          ; 2
    bpl    LF4E5                 ; 2³
    lda    ram_ED                ; 3
    and    #$05                  ; 2
    cmp    #$05                  ; 2
    bne    LF504                 ; 2³+1
    lda    ram_CA                ; 3
    ldx    ram_CB                ; 3
    cmp    LFFD2,X               ; 4
    bne    LF504                 ; 2³+1
    lda    LFFD8,X               ; 4
    sta    AUDF0                 ; 3
    inc    ram_CB                ; 5
LF504:
  IF CORRECT_SCANLINES
    BIT    TIMINT
    BPL    LF504
  ELSE
    ldx    INTIM                 ; 4
    bne    LF504                 ; 2³
  ENDIF
    stx    WSYNC                 ; 3
;---------------------------------------
    jsr    LF78A                 ; 6
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    ram_ED                ; 3
    and    #$02                  ; 2
    beq    LF555                 ; 2³
    lda    ram_DD                ; 3
    and    #$07                  ; 2
    bne    LF56A                 ; 2³
    lda    ram_ED                ; 3
    and    #$04                  ; 2
    bne    LF56F                 ; 2³
LF522:

  IF !COLOR_NTSC
    CLC
    LDA    ram_B3
    BPL    LF530
    AND    #$7F
    SEC
    SBC    #$02
    ORA    #$80
    .byte $0C  ; NOP, skip 2 bytes
LF530:
    ADC    #$02

  ELSE
    lda    ram_B3                ; 3
    bpl    LF530                 ; 2³
    and    #$7F                  ; 2
    sec                          ; 2
    sbc    #$02                  ; 2
    ora    #$80                  ; 2
    jmp    LF533                 ; 3

LF530:
    clc                          ; 2
    adc    #$02                  ; 2
  ENDIF

LF533:
    sta    ram_B3                ; 3
    lda    ram_DC                ; 3
    eor    #$80                  ; 2
    sta    ram_DC                ; 3
LF53B:
    bmi    LF548                 ; 2³
    lda    #$38                  ; 2
  IF CORRECT_SCANLINES
    BNE    LF54A  ; always branch
  ELSE
    sta    ram_A6                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$FC                  ; 2
    jmp    LF550                 ; 3
  ENDIF

LF548:
    lda    #$1B                  ; 2
LF54A:
    sta    ram_A6                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    #$FC                  ; 2
LF550:
    sta    ram_A7                ; 3
  IF !COLOR_NTSC
    BNE    LF57A
  ELSE
    jmp    LF57A                 ; 3
  ENDIF

LF555:
    lda    #$F4                  ; 2
    sta    ram_B7                ; 3
    lda    #$FA                  ; 2
    sta    ram_B8                ; 3
    lda    #$97                  ; 2
    sta    ram_A6                ; 3
    lda    #$FE                  ; 2
    sta    ram_A7                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    jmp    LF5D5                 ; 3

LF56A:
    lda    ram_DC                ; 3
    jmp    LF53B                 ; 3

LF56F:
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    cmp    #$3C                  ; 2
    bne    LF522                 ; 2³
  IF !COLOR_NTSC
    BEQ    LF56A
  ELSE
    jmp    LF56A                 ; 3
  ENDIF

LF57A:
    lda    ram_ED                ; 3
    and    #$04                  ; 2
    beq    LF5AC                 ; 2³
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    cmp    #$3C                  ; 2
    bne    LF5A1                 ; 2³
    lda    #$B0                  ; 2
    sta    ram_B7                ; 3
    lda    #$FE                  ; 2
    sta    ram_B8                ; 3
    dec    ram_CA                ; 5
    lda    #$17                  ; 2
    sta    ram_ED                ; 3
    sta    AUDV0                 ; 3

FLASH_SCREEN_TIME      = $B4

    lda    ram_CA                ; 3
  IF COLOR_NTSC
    and    #$F6                  ; 2
    sta    ram_C8                ; 3  HERE, background flashes, Y and X available
    jmp    LF5D5                 ; 3

  ELSE
    AND    #$F6
    STA    freeRam+1
    LDA    ram_CA
    LSR
    LSR
    LSR
    LSR
    TAY
    LDA    ConvertToPalTab,Y
    ORA    freeRam+1
    STA    ram_C8
    JMP    LF5D7;LF5D5

ConvertToPalTab:
    .byte $00
    .byte $30
    .byte $20
    .byte $40
    .byte $60
    .byte $80
    .byte $A0
    .byte $C0
    .byte $D0
    .byte $B0
    .byte $90
    .byte $70

    NOP  ; free byte
    NOP  ;2
    NOP
    NOP  ;4
;     NOP
;     NOP  ;6
;     NOP
;     NOP  ;8
;     NOP
;     NOP  ;10
;     NOP
;     NOP  ;12
;     NOP
;     NOP  ;14
;     NOP
;     NOP  ;16
;     NOP
;     NOP  ;18
;     NOP
;     NOP  ;20
;     NOP
;     NOP  ;22
;     NOP
;     NOP  ;24
;     NOP
;     NOP  ;26
;     NOP
;     NOP  ;28
;     NOP
;     NOP
  ENDIF

  IF CORRECT_SCANLINES
    NOP                             ; used to align page for LF5F8
  ENDIF

LF5A1:
    lda    #$F4                  ; 2
    sta    ram_B7                ; 3
    lda    #$FA                  ; 2
    sta    ram_B8                ; 3
  IF !COLOR_NTSC
    BNE    LF5D5
  ELSE
    jmp    LF5D5                 ; 3
  ENDIF

LF5AC:
    lda    ram_B3                ; 3
    bpl    LF5B9                 ; 2³
    and    #$7F                  ; 2
    cmp    #$08                  ; 2
  IF !COLOR_NTSC
    .byte $0C  ; NOP, skip 2 bytes
  ELSE
    bne    LF5A1                 ; 2³
    jmp    LF5BD                 ; 3
  ENDIF

LF5B9:
    cmp    #$68                  ; 2
    bne    LF5A1                 ; 2³
LF5BD:
    lda    #$20                  ; 2
    sta    ram_ED                ; 3
    lda    #$7E                  ; 2
    sta    ram_B9                ; 3
    sta    ram_B2                ; 3
    sta    ram_BE                ; 3
    lda    ram_AD                ; 3
    ora    #$20                  ; 2
    sta    ram_AD                ; 3
    lda    ram_93                ; 3
    and    #$BF                  ; 2
    sta    ram_93                ; 3
LF5D5:
    sta    WSYNC                 ; 3
;---------------------------------------
LF5D7:
    jsr    LF815                 ; 6
    lda    ram_AC                ; 3
    bmi    LF5E3                 ; 2³
    stx    REFP0                 ; 3
  IF !COLOR_NTSC
    BPL    LF5E9  ; always branch
  ELSE
    jmp    LF5E9                 ; 3
  ENDIF

LF5E3:
    ldx    #$08                  ; 2
    stx    REFP0                 ; 3
    and    #$7F                  ; 2
LF5E9:
    ldx    #$06                  ; 2
LF5EB:
    stx    WSYNC                 ; 3
;---------------------------------------
    dex                          ; 2
    bne    LF5EB                 ; 2³
    jsr    LF76B                 ; 6
    stx    HMP0                  ; 3
    tax                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
LF5F8:
    dex                          ; 2
    bne    LF5F8                 ; 2³
    stx    RESP0                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    lda    #COL_02               ; 2
    sta    COLUPF                ; 3
    ldy    #$1A                  ; 2
    ldx    #$80                  ; 2
    lda    ram_DC                ; 3
    and    #$20                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    stx    PF0                   ; 3
    ldx    ram_C8                ; 3
    stx    COLUBK                ; 3
    tax                          ; 2
LF616:
    txa                          ; 2
    beq    LF61F                 ; 2³
    lda    LFB2E,Y               ; 4
    jmp    LF622                 ; 3

LF61F:
    lda    LFB13,Y               ; 4
LF622:
    sta    GRP0                  ; 3
    lda    LFB49,Y               ; 4
    sta    COLUP0                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    dey                          ; 2
    bne    LF616                 ; 2³
    sty    GRP0                  ; 3
    lda    #$FF                  ; 2
    sta    PF1                   ; 3
    sta    PF2                   ; 3
    lda    #COL_00               ; 2
    sta    COLUP1                ; 3
    lda    ram_BB                ; 3
    and    #$0F                  ; 2
    ora    #COL_30               ; 2
    sta    COLUP0                ; 3
    sty    REFP1                 ; 3
    lda    ram_C0                ; 3
    and    #$08                  ; 2
    sta    REFP0                 ; 3
    lda    ram_BA                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    jsr    LF76B                 ; 6
    stx    HMP0                  ; 3
    tax                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
LF656:
    dex                          ; 2
    bne    LF656                 ; 2³
    stx    RESP0                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    ram_B4                ; 3
    jsr    LF76B                 ; 6
    stx    HMP1                  ; 3
    tax                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
LF667:
    dex                          ; 2
    bne    LF667                 ; 2³
    stx    RESP1                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    PF1                   ; 3
    stx    PF2                   ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    ldy    #$0C                  ; 2
LF67A:
    sta    WSYNC                 ; 3
;---------------------------------------
    stx    PF0                   ; 3
    lda    (ram_E1),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_DE),Y            ; 5
    sta    GRP1                  ; 3
    dey                          ; 2
    bne    LF67A                 ; 2³
    ldx    #$80                  ; 2
    ldy    #$22                  ; 2
LF68D:
    sta    WSYNC                 ; 3
;---------------------------------------
    stx    PF0                   ; 3
    lda    (ram_E6),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_E3),Y            ; 5
    sta    GRP1                  ; 3
    dey                          ; 2
    bne    LF68D                 ; 2³
    ldx    #$C0                  ; 2

  IF COLOR_NTSC
    ldy    #$20                  ; 2
LF6A0:
    sta    WSYNC                 ; 3
;---------------------------------------
    stx    PF0                   ; 3
    lda    (ram_EB),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_E8),Y            ; 5
    sta    GRP1                  ; 3
    dey                          ; 2
    bne    LF6A0                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    ldx    #$E0                  ; 2
    stx    HMP0                  ; 3
    ldx    #$20                  ; 2
    stx    HMP1                  ; 3

  ELSE
    LDY    #$20
    STY    HMP1
LF6A0:
    STA    WSYNC
;---------------------------------------
    STX    PF0
    LDA    (ram_EB),Y
    STA    GRP0
    LDA    (ram_E8),Y
    STA    GRP1
    DEY
    BNE    LF6A0
    STA    WSYNC
;---------------------------------------
    STY    GRP0
    STY    GRP1
    LDX    #$E0
    STX    HMP0
  ENDIF


  IF COLOR_NTSC
    ldx    #$08                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
LF6C1:
    dex                          ; 2
    bne    LF6C1                 ; 2³
    nop                          ; 2

  ELSE
    STA    WSYNC
;---------------------------------------
    LDX    #$08
LF6C1:
    DEX
    BNE    LF6C1
  ENDIF

    sta    RESP0                 ; 3
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    ldx    #$05                  ; 2
    stx    NUSIZ0                ; 3
    ldx    #COL_6A               ; 2
    stx    COLUP0                ; 3
    lda    ram_93                ; 3
    and    #$10                  ; 2
    lsr                          ; 2
    sta    REFP1                 ; 3
    lda    #$E0                  ; 2
    ldy    #$1E                  ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    PF0                   ; 3
LF6E4:
    lda    (ram_B7),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_D4),Y            ; 5
    sta    GRP1                  ; 3
    lda    LFBA0,Y               ; 4
    sta    COLUP1                ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    dey                          ; 2
    bne    LF6E4                 ; 2³
    sty    GRP0                  ; 3
    sty    NUSIZ0                ; 3
    lda    #$F0                  ; 2
    sta    PF0                   ; 3
    lda    #$C0                  ; 2
    sta    PF2                   ; 3
    lda    ram_B3                ; 3
    bpl    LF70A                 ; 2³
    and    #$7F                  ; 2
    ldy    #$08                  ; 2
LF70A:
    sty    REFP0                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    jsr    LF76B                 ; 6
    stx    HMP0                  ; 3
    tax                          ; 2
    sta    WSYNC                 ; 3
;---------------------------------------
LF716:
    dex                          ; 2
    bne    LF716                 ; 2³
    stx    RESP0                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    ldy    #$19                  ; 2
LF721:
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    (ram_A6),Y            ; 5
    sta    GRP0                  ; 3
    lda    LFC5A,Y               ; 4
    sta    COLUP0                ; 3
    cpy    #$15                  ; 2
    bne    LF735                 ; 2³
    lda    #$E0                  ; 2
  IF !COLOR_NTSC
    BNE    LF744  ; always branch
  ELSE
    jmp    LF744                 ; 3
  ENDIF

LF735:
    cpy    #$0E                  ; 2
    bne    LF73E                 ; 2³
    lda    #$F0                  ; 2
  IF CORRECT_SCANLINES
    BNE    LF744
  ELSE
    jmp    LF744                 ; 3
  ENDIF

LF73E:
    cpy    #$07                  ; 2
    bne    LF746                 ; 2³
    lda    #$F8                  ; 2
LF744:
    sta    PF2                   ; 3
LF746:
    dey                          ; 2
    bne    LF721                 ; 2³
    sta    WSYNC                 ; 3
;---------------------------------------
    sty    COLUBK                ; 3
    lda    #$C3                  ; 2
    sta    PF1                   ; 3
  IF COLOR_NTSC
    lda    #$FF                  ; 2
    sta    PF2                   ; 3
  ELSE
    DEY
    STY    PF2
  ENDIF
    ldy    #$03                  ; 2
LF757:

    sta    WSYNC                 ; 3
;---------------------------------------
    dey                          ; 2
    bne    LF757                 ; 2³  WRITE TO VBLANK here for SENTA screen
    ldx    #TIM_3                ; 2
  IF CORRECT_SCANLINES
    STX    TIM64T
  ELSE
    stx    TIM8T                 ; 4
  ENDIF

  IF CORRECT_SCANLINES
    LDX    #2
    STX    VBLANK
  ENDIF

    sty    PF0                   ; 3
    sty    PF1                   ; 3
    sty    PF2                   ; 3
    jmp    LFFF3                 ; 3

  IF !COLOR_NTSC
Waste24:
    NOP
Waste22:
    NOP
Waste20:
    NOP
Waste18:
    NOP
Waste16:
    NOP
Waste14:
    NOP
  ENDIF

LF76A:
    rts                          ; 6

LF76B:
    clc                          ; 2
    adc    #$50                  ; 2

  IF COLOR_NTSC
    jmp    LF774                 ; 3

    clc                          ; 2
    adc    #$14                  ; 2
  ENDIF
LF774:
    tax                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    ram_A5                ; 3
    txa                          ; 2
    adc    ram_A5                ; 3
    eor    #$07                  ; 2
    ror                          ; 2
    ror                          ; 2
    ror                          ; 2
    ror                          ; 2
    ror                          ; 2
    tax                          ; 2
    rol                          ; 2
    and    #$0F                  ; 2
    rts                          ; 6

LF78A:
    ldy    #$02                  ; 2
LF78C:
    tya                          ; 2
    asl                          ; 2
    asl                          ; 2
    tax                          ; 2
    lda.wy ram_90,Y              ; 4
    and    #$F0                  ; 2
    lsr                          ; 2
    sta    ram_A5                ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    adc    ram_A5                ; 3
    adc    #$3C                  ; 2
    sta    ram_84,X              ; 4
    lda.wy ram_90,Y              ; 4
    and    #$0F                  ; 2
    sta    ram_A5                ; 3
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    adc    ram_A5                ; 3
    adc    #$3C                  ; 2
    sta    ram_86,X              ; 4
    lda    #$F9                  ; 2
    sta    ram_85,X              ; 4
    sta    ram_87,X              ; 4
    dey                          ; 2
    bpl    LF78C                 ; 2³
    lda    #$13                  ; 2
    sta    HMCLR                 ; 3

  IF CORRECT_SCANLINES
    STA    WSYNC
;---------------------------------------
    STA    HMP1
    STA    NUSIZ0
    STA    NUSIZ1
    LDY    #$07
    STY    VDELP0
    STY    VDELP1

  ELSE
    sta    HMP1                  ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    NUSIZ0                ; 3
    sta    NUSIZ1                ; 3
    ldy    #$07                  ; 2
    sty    VDELP0                ; 3
    sty    VDELP1                ; 3
    sty    VDELP1                ; 3
  ENDIF

  IF COLOR_NTSC
    jsr    LF76A                 ; 6
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
  ELSE
    JSR    Waste20
  ENDIF
    sta    RESP0                 ; 3
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    iny                          ; 2
  IF CORRECT_SCANLINES
    STY    VBLANK  ; vblank ends
  ENDIF

LF7DE:
    sty    ram_A4                ; 3
    lda    (ram_8E),Y            ; 5
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    ram_A5                ; 3
    lda    (ram_84),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_86),Y            ; 5
    sta    GRP1                  ; 3
    lda    (ram_88),Y            ; 5
    sta    GRP0                  ; 3
    lda    (ram_8C),Y            ; 5
    tax                          ; 2
    lda    (ram_8A),Y            ; 5
    ldy    ram_A5                ; 3
    sta    GRP1                  ; 3
    stx    GRP0                  ; 3
    sty    GRP1                  ; 3
    sta    GRP0                  ; 3
    ldy    ram_A4                ; 3
    dey                          ; 2
    bpl    LF7DE                 ; 2³+1
    ldx    #$01                  ; 2
    iny                          ; 2
    sty    GRP0                  ; 3
LF80B:
    sty    GRP0,X                ; 4
    sty    NUSIZ0,X              ; 4
    sty    VDELP0,X              ; 4
    dex                          ; 2
    beq    LF80B                 ; 2³
    rts                          ; 6

LF815:
    ldx    #COL_32               ; 2
    lda    ram_93                ; 3
    and    #$20                  ; 2
    beq    LF81F                 ; 2³
    ldx    #COL_D2               ; 2
LF81F:
    stx    COLUPF                ; 3
    lda    ram_93                ; 3
    and    #$0F                  ; 2
    tax                          ; 2
    cpx    #$05                  ; 2
    bpl    LF832                 ; 2³
    ldy    LFAEB,X               ; 4
    lda    #$00                  ; 2
  IF COLOR_NTSC
    jmp    LF837                 ; 3
  ELSE
    BEQ    LF837  ; always branch
  ENDIF

LF832:
    ldy    #$55                  ; 2
    lda    LFAEB,X               ; 4
LF837:
    sta    WSYNC                 ; 3
;---------------------------------------
    ldx    #$04                  ; 2
LF83B:
    sty    PF1                   ; 3
  IF COLOR_NTSC
    jsr    LF76A                 ; 6
    jsr    LF76A                 ; 6
  ELSE
    JSR    Waste24
  ENDIF
    jsr    LF76A                 ; 6
    sta    PF1                   ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    dex                          ; 2
    bne    LF83B                 ; 2³
    stx    PF1                   ; 3
    rts                          ; 6

LF850:
    lda    ram_DD                ; 3
    bne    LF888                 ; 2³
    lda    ram_C0                ; 3
    and    #$07                  ; 2
    beq    LF862                 ; 2³
    sec                          ; 2
    sbc    #$01                  ; 2
  IF COLOR_NTSC
    sta    ram_A5                ; 3
    jmp    LF880                 ; 3
  ELSE
    JMP    LF87E
  ENDIF

LF862:
    sed                          ; 2
    lda    ram_F0                ; 3
    beq    LF86C                 ; 2³
    sec                          ; 2
    sbc    #$01                  ; 2
    sta    ram_F0                ; 3
LF86C:
    lda    ram_F1                ; 3
    beq    LF875                 ; 2³
    sec                          ; 2
    sbc    #$01                  ; 2
    sta    ram_F1                ; 3
LF875:
    cld                          ; 2
    lda    ram_AD                ; 3
    and    #$03                  ; 2
    tax                          ; 2
    lda    LFFC8,X               ; 4
LF87E:
    sta    ram_A5                ; 3
LF880:
    lda    ram_C0                ; 3
    and    #$F8                  ; 2
    ora    ram_A5                ; 3
    sta    ram_C0                ; 3
LF888:
    lda    ram_ED                ; 3
    and    #$0C                  ; 2
    bne    LF8C8                 ; 2³
    lda    ram_A8                ; 3
    bne    LF8C8                 ; 2³
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    sta    ram_9F                ; 3
    ldy    ram_80                ; 3
    lda    ram_BE                ; 3
    bne    LF8C8                 ; 2³
    ldx    LFFBE,Y               ; 4
    lda    ram_B9                ; 3
    beq    LF8AD                 ; 2³
    lda    ram_B1                ; 3
  IF COLOR_NTSC
    bpl    LF8C8                 ; 2³
    jsr    LF8C9                 ; 6
    rts                          ; 6
  ELSE
    BMI    LF8C5
    RTS
   ENDIF

LF8AD:
    jsr    LF8C9                 ; 6
    bpl    LF8C8                 ; 2³
    cpx    #$0A                  ; 2
    beq    LF8C8                 ; 2³
    ldx    LFFC1,Y               ; 4
    jsr    LF8C9                 ; 6
    bpl    LF8C8                 ; 2³
    cpx    #$0A                  ; 2
    beq    LF8C8                 ; 2³
    ldx    LFFC4,Y               ; 4
LF8C5:
    jsr    LF8C9                 ; 6
LF8C8:
    rts                          ; 6

LF8C9:
    lda    ram_E0,X              ; 4
    and    #$7F                  ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    bpl    LF8D4                 ; 2³
    eor    #$FF                  ; 2
LF8D4:
    cmp    #$05                  ; 2
    bpl    LF90E                 ; 2³+1
    lda    LFFC7,X               ; 4
    and    ram_B1                ; 3
    bne    LF917                 ; 2³+1
    lda    ram_B1                ; 3
    ora    LFFC7,X               ; 4
    sta    ram_B1                ; 3
    lda    ram_93                ; 3
    and    #$0F                  ; 2
    sec                          ; 2
    sbc    #$01                  ; 2
    sta    ram_9F                ; 3
    lda    ram_93                ; 3
    and    #$F0                  ; 2
    ora    ram_9F                ; 3
    sta    ram_93                ; 3
    lda    ram_9F                ; 3
    beq    LF91A                 ; 2³+1
    lda    #$07                  ; 2
    sta    AUDC0                 ; 3
    lda    #$02                  ; 2
    sta    AUDF0                 ; 3
    lda    #$05                  ; 2
    sta    AUDV0                 ; 3
    lda    #$3C                  ; 2
    sta    ram_EE                ; 3
    lda    #$00                  ; 2
    rts                          ; 6

LF90E:
    lda    LFFC7,X               ; 4
    eor    #$FF                  ; 2
    and    ram_B1                ; 3
    sta    ram_B1                ; 3
LF917:
    lda    #$80                  ; 2
    rts                          ; 6

LF91A:
    lda    ram_ED                ; 3
    ora    #$08                  ; 2
    sta    ram_ED                ; 3
    lda    #$01                  ; 2
    rts                          ; 6

    .byte $00 ; |        | $F923
    .byte $01 ; |       X| $F924
    .byte $01 ; |       X| $F925
    .byte $00 ; |        | $F926
    .byte $00 ; |        | $F927
    .byte $01 ; |       X| $F928
    .byte $01 ; |       X| $F929
    .byte $00 ; |        | $F92A
    .byte $00 ; |        | $F92B
    .byte $01 ; |       X| $F92C
LF92D:
    .byte $F2 ; |XXXX  X | $F92D  AND table
    .byte $F4 ; |XXXX X  | $F92E
    .byte $F2 ; |XXXX  X | $F92F
    .byte $F4 ; |XXXX X  | $F930
    .byte $F6 ; |XXXX XX | $F931
    .byte $F4 ; |XXXX X  | $F932
    .byte $F6 ; |XXXX XX | $F933
    .byte $F4 ; |XXXX X  | $F934
    .byte $F2 ; |XXXX  X | $F935
    .byte $F4 ; |XXXX X  | $F936
    .byte $F8 ; |XXXXX   | $F937
    .byte $F6 ; |XXXX XX | $F938
    .byte $F4 ; |XXXX X  | $F939
    .byte $F6 ; |XXXX XX | $F93A
    .byte $F4 ; |XXXX X  | $F93B

    .byte $3C ; |  XXXX  | $F93C
    .byte $66 ; | XX  XX | $F93D
    .byte $66 ; | XX  XX | $F93E
    .byte $66 ; | XX  XX | $F93F
    .byte $66 ; | XX  XX | $F940
    .byte $66 ; | XX  XX | $F941
    .byte $66 ; | XX  XX | $F942
    .byte $66 ; | XX  XX | $F943
    .byte $3C ; |  XXXX  | $F944
    .byte $7E ; | XXXXXX | $F945
    .byte $18 ; |   XX   | $F946
    .byte $18 ; |   XX   | $F947
    .byte $18 ; |   XX   | $F948
    .byte $18 ; |   XX   | $F949
    .byte $18 ; |   XX   | $F94A
    .byte $18 ; |   XX   | $F94B
    .byte $38 ; |  XXX   | $F94C
    .byte $18 ; |   XX   | $F94D
    .byte $7E ; | XXXXXX | $F94E
    .byte $60 ; | XX     | $F94F
    .byte $60 ; | XX     | $F950
    .byte $38 ; |  XXX   | $F951
    .byte $0C ; |    XX  | $F952
    .byte $06 ; |     XX | $F953
    .byte $46 ; | X   XX | $F954
    .byte $66 ; | XX  XX | $F955
    .byte $3C ; |  XXXX  | $F956
    .byte $3C ; |  XXXX  | $F957
    .byte $46 ; | X   XX | $F958
    .byte $06 ; |     XX | $F959
    .byte $06 ; |     XX | $F95A
    .byte $1C ; |   XXX  | $F95B
    .byte $06 ; |     XX | $F95C
    .byte $06 ; |     XX | $F95D
    .byte $46 ; | X   XX | $F95E
    .byte $3C ; |  XXXX  | $F95F
    .byte $06 ; |     XX | $F960
    .byte $06 ; |     XX | $F961
    .byte $7E ; | XXXXXX | $F962
    .byte $46 ; | X   XX | $F963
    .byte $26 ; |  X  XX | $F964
    .byte $26 ; |  X  XX | $F965
    .byte $16 ; |   X XX | $F966
    .byte $16 ; |   X XX | $F967
    .byte $0E ; |    XXX | $F968
    .byte $7C ; | XXXXX  | $F969
    .byte $46 ; | X   XX | $F96A
    .byte $06 ; |     XX | $F96B
    .byte $06 ; |     XX | $F96C
    .byte $3C ; |  XXXX  | $F96D
    .byte $60 ; | XX     | $F96E
    .byte $60 ; | XX     | $F96F
    .byte $60 ; | XX     | $F970
    .byte $7E ; | XXXXXX | $F971
    .byte $3C ; |  XXXX  | $F972
    .byte $66 ; | XX  XX | $F973
    .byte $66 ; | XX  XX | $F974
    .byte $66 ; | XX  XX | $F975
    .byte $7C ; | XXXXX  | $F976
    .byte $60 ; | XX     | $F977
    .byte $60 ; | XX     | $F978
    .byte $62 ; | XX   X | $F979
    .byte $3C ; |  XXXX  | $F97A
    .byte $18 ; |   XX   | $F97B
    .byte $18 ; |   XX   | $F97C
    .byte $18 ; |   XX   | $F97D
    .byte $18 ; |   XX   | $F97E
    .byte $0C ; |    XX  | $F97F
    .byte $0C ; |    XX  | $F980
    .byte $06 ; |     XX | $F981
    .byte $46 ; | X   XX | $F982
    .byte $7E ; | XXXXXX | $F983
    .byte $3C ; |  XXXX  | $F984
    .byte $66 ; | XX  XX | $F985
    .byte $66 ; | XX  XX | $F986
    .byte $66 ; | XX  XX | $F987
    .byte $3C ; |  XXXX  | $F988
    .byte $66 ; | XX  XX | $F989
    .byte $66 ; | XX  XX | $F98A
    .byte $66 ; | XX  XX | $F98B
    .byte $3C ; |  XXXX  | $F98C
    .byte $3C ; |  XXXX  | $F98D
    .byte $46 ; | X   XX | $F98E
    .byte $06 ; |     XX | $F98F
    .byte $06 ; |     XX | $F990
    .byte $3E ; |  XXXXX | $F991
    .byte $66 ; | XX  XX | $F992
    .byte $66 ; | XX  XX | $F993
    .byte $66 ; | XX  XX | $F994
    .byte $3C ; |  XXXX  | $F995
    .byte $00 ; |        | $F996
    .byte $00 ; |        | $F997
    .byte $00 ; |        | $F998
    .byte $00 ; |        | $F999
    .byte $00 ; |        | $F99A
    .byte $00 ; |        | $F99B
    .byte $00 ; |        | $F99C
    .byte $00 ; |        | $F99D
    .byte $00 ; |        | $F99E
LF99F:
    .byte $00 ; |        | $F99F
    .byte $00 ; |        | $F9A0
    .byte $00 ; |        | $F9A1
    .byte $00 ; |        | $F9A2
    .byte $00 ; |        | $F9A3
    .byte $00 ; |        | $F9A4
    .byte $00 ; |        | $F9A5
    .byte $00 ; |        | $F9A6
    .byte $00 ; |        | $F9A7
    .byte $00 ; |        | $F9A8
    .byte $00 ; |        | $F9A9
    .byte $00 ; |        | $F9AA
    .byte $00 ; |        | $F9AB
    .byte $00 ; |        | $F9AC
    .byte $00 ; |        | $F9AD
    .byte $00 ; |        | $F9AE
    .byte $00 ; |        | $F9AF
    .byte $00 ; |        | $F9B0
    .byte $00 ; |        | $F9B1
    .byte $00 ; |        | $F9B2
    .byte $00 ; |        | $F9B3
    .byte $00 ; |        | $F9B4
    .byte $03 ; |      XX| $F9B5
    .byte $0F ; |    XXXX| $F9B6
    .byte $1F ; |   XXXXX| $F9B7
    .byte $3F ; |  XXXXXX| $F9B8
    .byte $3E ; |  XXXXX | $F9B9
    .byte $7C ; | XXXXX  | $F9BA
    .byte $78 ; | XXXX   | $F9BB
    .byte $78 ; | XXXX   | $F9BC
    .byte $78 ; | XXXX   | $F9BD
    .byte $78 ; | XXXX   | $F9BE
    .byte $78 ; | XXXX   | $F9BF
    .byte $78 ; | XXXX   | $F9C0
    .byte $7C ; | XXXXX  | $F9C1
    .byte $3E ; |  XXXXX | $F9C2
    .byte $3F ; |  XXXXXX| $F9C3
    .byte $1F ; |   XXXXX| $F9C4
    .byte $0F ; |    XXXX| $F9C5
    .byte $03 ; |      XX| $F9C6
    .byte $00 ; |        | $F9C7
    .byte $00 ; |        | $F9C8
    .byte $00 ; |        | $F9C9
    .byte $F0 ; |XXXX    | $F9CA
    .byte $F0 ; |XXXX    | $F9CB
    .byte $F0 ; |XXXX    | $F9CC
    .byte $F0 ; |XXXX    | $F9CD
    .byte $F1 ; |XXXX   X| $F9CE
    .byte $F3 ; |XXXX  XX| $F9CF
    .byte $F7 ; |XXXX XXX| $F9D0
    .byte $FF ; |XXXXXXXX| $F9D1
    .byte $FF ; |XXXXXXXX| $F9D2
    .byte $FF ; |XXXXXXXX| $F9D3
    .byte $FF ; |XXXXXXXX| $F9D4
    .byte $F0 ; |XXXX    | $F9D5
    .byte $F0 ; |XXXX    | $F9D6
    .byte $F0 ; |XXXX    | $F9D7
    .byte $FF ; |XXXXXXXX| $F9D8
    .byte $FF ; |XXXXXXXX| $F9D9
    .byte $FF ; |XXXXXXXX| $F9DA
    .byte $FF ; |XXXXXXXX| $F9DB
    .byte $00 ; |        | $F9DC
    .byte $00 ; |        | $F9DD
    .byte $00 ; |        | $F9DE
    .byte $F0 ; |XXXX    | $F9DF
    .byte $F0 ; |XXXX    | $F9E0
    .byte $F0 ; |XXXX    | $F9E1
    .byte $F0 ; |XXXX    | $F9E2
    .byte $FF ; |XXXXXXXX| $F9E3
    .byte $FF ; |XXXXXXXX| $F9E4
    .byte $FF ; |XXXXXXXX| $F9E5
    .byte $FF ; |XXXXXXXX| $F9E6
    .byte $FF ; |XXXXXXXX| $F9E7
    .byte $F0 ; |XXXX    | $F9E8
    .byte $F0 ; |XXXX    | $F9E9
    .byte $78 ; | XXXX   | $F9EA
    .byte $7C ; | XXXXX  | $F9EB
    .byte $3E ; |  XXXXX | $F9EC
    .byte $3F ; |  XXXXXX| $F9ED
    .byte $1F ; |   XXXXX| $F9EE
    .byte $0F ; |    XXXX| $F9EF
    .byte $03 ; |      XX| $F9F0
    .byte $00 ; |        | $F9F1
    .byte $00 ; |        | $F9F2
    .byte $00 ; |        | $F9F3
    .byte $F0 ; |XXXX    | $F9F4
    .byte $F0 ; |XXXX    | $F9F5
    .byte $F0 ; |XXXX    | $F9F6
    .byte $F0 ; |XXXX    | $F9F7
    .byte $F0 ; |XXXX    | $F9F8
    .byte $F0 ; |XXXX    | $F9F9
    .byte $F0 ; |XXXX    | $F9FA
    .byte $F0 ; |XXXX    | $F9FB
    .byte $F1 ; |XXXX   X| $F9FC
    .byte $F3 ; |XXXX  XX| $F9FD
    .byte $F7 ; |XXXX XXX| $F9FE
    .byte $FF ; |XXXXXXXX| $F9FF
    .byte $FF ; |XXXXXXXX| $FA00
    .byte $FE ; |XXXXXXX | $FA01
    .byte $FC ; |XXXXXX  | $FA02
    .byte $F8 ; |XXXXX   | $FA03
    .byte $F0 ; |XXXX    | $FA04
    .byte $E0 ; |XXX     | $FA05
    .byte $00 ; |        | $FA06
    .byte $00 ; |        | $FA07
    .byte $00 ; |        | $FA08
    .byte $03 ; |      XX| $FA09
    .byte $0F ; |    XXXX| $FA0A
    .byte $1F ; |   XXXXX| $FA0B
    .byte $3F ; |  XXXXXX| $FA0C
    .byte $3E ; |  XXXXX | $FA0D
    .byte $7C ; | XXXXX  | $FA0E
    .byte $78 ; | XXXX   | $FA0F
    .byte $78 ; | XXXX   | $FA10
    .byte $78 ; | XXXX   | $FA11
    .byte $78 ; | XXXX   | $FA12
    .byte $78 ; | XXXX   | $FA13
    .byte $78 ; | XXXX   | $FA14
    .byte $7C ; | XXXXX  | $FA15
    .byte $3E ; |  XXXXX | $FA16
    .byte $3F ; |  XXXXXX| $FA17
    .byte $1F ; |   XXXXX| $FA18
    .byte $0F ; |    XXXX| $FA19
    .byte $03 ; |      XX| $FA1A
    .byte $00 ; |        | $FA1B
    .byte $00 ; |        | $FA1C
    .byte $00 ; |        | $FA1D
    .byte $03 ; |      XX| $FA1E
    .byte $03 ; |      XX| $FA1F
    .byte $03 ; |      XX| $FA20
    .byte $03 ; |      XX| $FA21
    .byte $03 ; |      XX| $FA22
    .byte $03 ; |      XX| $FA23
    .byte $03 ; |      XX| $FA24
    .byte $03 ; |      XX| $FA25
    .byte $03 ; |      XX| $FA26
    .byte $03 ; |      XX| $FA27
    .byte $03 ; |      XX| $FA28
    .byte $03 ; |      XX| $FA29
    .byte $03 ; |      XX| $FA2A
    .byte $FF ; |XXXXXXXX| $FA2B
    .byte $FF ; |XXXXXXXX| $FA2C
    .byte $FF ; |XXXXXXXX| $FA2D
    .byte $FF ; |XXXXXXXX| $FA2E
    .byte $FF ; |XXXXXXXX| $FA2F
    .byte $00 ; |        | $FA30
    .byte $00 ; |        | $FA31
    .byte $00 ; |        | $FA32
    .byte $00 ; |        | $FA33
    .byte $00 ; |        | $FA34
    .byte $00 ; |        | $FA35
    .byte $00 ; |        | $FA36
    .byte $00 ; |        | $FA37
    .byte $00 ; |        | $FA38
    .byte $00 ; |        | $FA39
    .byte $00 ; |        | $FA3A
    .byte $00 ; |        | $FA3B
    .byte $00 ; |        | $FA3C
    .byte $00 ; |        | $FA3D
    .byte $00 ; |        | $FA3E
    .byte $00 ; |        | $FA3F
    .byte $00 ; |        | $FA40
    .byte $00 ; |        | $FA41
    .byte $00 ; |        | $FA42
    .byte $00 ; |        | $FA43
    .byte $00 ; |        | $FA44
LFA45:
    .byte $00 ; |        | $FA45
    .byte $00 ; |        | $FA46
    .byte $00 ; |        | $FA47
    .byte $00 ; |        | $FA48
    .byte $00 ; |        | $FA49
    .byte $00 ; |        | $FA4A
    .byte $00 ; |        | $FA4B
    .byte $00 ; |        | $FA4C
    .byte $00 ; |        | $FA4D
    .byte $00 ; |        | $FA4E
    .byte $00 ; |        | $FA4F
    .byte $00 ; |        | $FA50
    .byte $00 ; |        | $FA51
    .byte $00 ; |        | $FA52
    .byte $00 ; |        | $FA53
    .byte $00 ; |        | $FA54
    .byte $00 ; |        | $FA55
    .byte $00 ; |        | $FA56
    .byte $00 ; |        | $FA57
    .byte $00 ; |        | $FA58
    .byte $00 ; |        | $FA59
    .byte $00 ; |        | $FA5A
    .byte $C0 ; |XX      | $FA5B
    .byte $E0 ; |XXX     | $FA5C
    .byte $F0 ; |XXXX    | $FA5D
    .byte $F0 ; |XXXX    | $FA5E
    .byte $70 ; | XXX    | $FA5F
    .byte $30 ; |  XX    | $FA60
    .byte $00 ; |        | $FA61
    .byte $00 ; |        | $FA62
    .byte $00 ; |        | $FA63
    .byte $00 ; |        | $FA64
    .byte $00 ; |        | $FA65
    .byte $00 ; |        | $FA66
    .byte $30 ; |  XX    | $FA67
    .byte $70 ; | XXX    | $FA68
    .byte $F0 ; |XXXX    | $FA69
    .byte $F0 ; |XXXX    | $FA6A
    .byte $E0 ; |XXX     | $FA6B
    .byte $C0 ; |XX      | $FA6C
    .byte $00 ; |        | $FA6D
    .byte $00 ; |        | $FA6E
    .byte $00 ; |        | $FA6F
    .byte $1F ; |   XXXXX| $FA70
    .byte $3F ; |  XXXXXX| $FA71
    .byte $7E ; | XXXXXX | $FA72
    .byte $FC ; |XXXXXX  | $FA73
    .byte $F8 ; |XXXXX   | $FA74
    .byte $F0 ; |XXXX    | $FA75
    .byte $E0 ; |XXX     | $FA76
    .byte $F8 ; |XXXXX   | $FA77
    .byte $FC ; |XXXXXX  | $FA78
    .byte $FE ; |XXXXXXX | $FA79
    .byte $FF ; |XXXXXXXX| $FA7A
    .byte $0F ; |    XXXX| $FA7B
    .byte $07 ; |     XXX| $FA7C
    .byte $0F ; |    XXXX| $FA7D
    .byte $FF ; |XXXXXXXX| $FA7E
    .byte $FE ; |XXXXXXX | $FA7F
    .byte $FC ; |XXXXXX  | $FA80
    .byte $F8 ; |XXXXX   | $FA81
    .byte $00 ; |        | $FA82
    .byte $00 ; |        | $FA83
    .byte $00 ; |        | $FA84
    .byte $0F ; |    XXXX| $FA85
    .byte $0F ; |    XXXX| $FA86
    .byte $0F ; |    XXXX| $FA87
    .byte $0F ; |    XXXX| $FA88
    .byte $FF ; |XXXXXXXX| $FA89
    .byte $FF ; |XXXXXXXX| $FA8A
    .byte $FF ; |XXXXXXXX| $FA8B
    .byte $FF ; |XXXXXXXX| $FA8C
    .byte $FF ; |XXXXXXXX| $FA8D
    .byte $0F ; |    XXXX| $FA8E
    .byte $0F ; |    XXXX| $FA8F
    .byte $1E ; |   XXXX | $FA90
    .byte $3E ; |  XXXXX | $FA91
    .byte $7C ; | XXXXX  | $FA92
    .byte $FC ; |XXXXXX  | $FA93
    .byte $F8 ; |XXXXX   | $FA94
    .byte $F0 ; |XXXX    | $FA95
    .byte $C0 ; |XX      | $FA96
    .byte $00 ; |        | $FA97
    .byte $00 ; |        | $FA98
    .byte $00 ; |        | $FA99
    .byte $0F ; |    XXXX| $FA9A
    .byte $0F ; |    XXXX| $FA9B
    .byte $0F ; |    XXXX| $FA9C
    .byte $0F ; |    XXXX| $FA9D
    .byte $0F ; |    XXXX| $FA9E
    .byte $0F ; |    XXXX| $FA9F
    .byte $0F ; |    XXXX| $FAA0
    .byte $0F ; |    XXXX| $FAA1
    .byte $8F ; |X   XXXX| $FAA2
    .byte $CF ; |XX  XXXX| $FAA3
    .byte $EF ; |XXX XXXX| $FAA4
    .byte $FF ; |XXXXXXXX| $FAA5
    .byte $FF ; |XXXXXXXX| $FAA6
    .byte $7F ; | XXXXXXX| $FAA7
    .byte $3F ; |  XXXXXX| $FAA8
    .byte $1F ; |   XXXXX| $FAA9
    .byte $0F ; |    XXXX| $FAAA
    .byte $07 ; |     XXX| $FAAB
    .byte $00 ; |        | $FAAC
    .byte $00 ; |        | $FAAD
    .byte $00 ; |        | $FAAE
    .byte $C0 ; |XX      | $FAAF
    .byte $F0 ; |XXXX    | $FAB0
    .byte $F8 ; |XXXXX   | $FAB1
    .byte $FC ; |XXXXXX  | $FAB2
    .byte $7C ; | XXXXX  | $FAB3
    .byte $3E ; |  XXXXX | $FAB4
    .byte $1E ; |   XXXX | $FAB5
    .byte $1E ; |   XXXX | $FAB6
    .byte $1E ; |   XXXX | $FAB7
    .byte $1E ; |   XXXX | $FAB8
    .byte $1E ; |   XXXX | $FAB9
    .byte $1E ; |   XXXX | $FABA
    .byte $3E ; |  XXXXX | $FABB
    .byte $7C ; | XXXXX  | $FABC
    .byte $FC ; |XXXXXX  | $FABD
    .byte $F8 ; |XXXXX   | $FABE
    .byte $F0 ; |XXXX    | $FABF
    .byte $C0 ; |XX      | $FAC0
    .byte $00 ; |        | $FAC1
    .byte $00 ; |        | $FAC2
    .byte $00 ; |        | $FAC3
    .byte $C0 ; |XX      | $FAC4
    .byte $C0 ; |XX      | $FAC5
    .byte $C0 ; |XX      | $FAC6
    .byte $C0 ; |XX      | $FAC7
    .byte $C0 ; |XX      | $FAC8
    .byte $C0 ; |XX      | $FAC9
    .byte $C0 ; |XX      | $FACA
    .byte $C0 ; |XX      | $FACB
    .byte $C0 ; |XX      | $FACC
    .byte $C0 ; |XX      | $FACD
    .byte $C0 ; |XX      | $FACE
    .byte $C0 ; |XX      | $FACF
    .byte $C0 ; |XX      | $FAD0
    .byte $FF ; |XXXXXXXX| $FAD1
    .byte $FF ; |XXXXXXXX| $FAD2
    .byte $FF ; |XXXXXXXX| $FAD3
    .byte $FF ; |XXXXXXXX| $FAD4
    .byte $FF ; |XXXXXXXX| $FAD5
    .byte $00 ; |        | $FAD6
    .byte $00 ; |        | $FAD7
    .byte $00 ; |        | $FAD8
    .byte $00 ; |        | $FAD9
    .byte $00 ; |        | $FADA
    .byte $00 ; |        | $FADB
    .byte $00 ; |        | $FADC
    .byte $00 ; |        | $FADD
    .byte $00 ; |        | $FADE
    .byte $00 ; |        | $FADF
    .byte $00 ; |        | $FAE0
    .byte $00 ; |        | $FAE1
    .byte $00 ; |        | $FAE2
    .byte $00 ; |        | $FAE3
    .byte $00 ; |        | $FAE4
    .byte $00 ; |        | $FAE5
    .byte $00 ; |        | $FAE6
    .byte $00 ; |        | $FAE7
    .byte $00 ; |        | $FAE8
    .byte $00 ; |        | $FAE9
    .byte $00 ; |        | $FAEA
LFAEB:
    .byte $00 ; |        | $FAEB
    .byte $40 ; | X      | $FAEC
    .byte $50 ; | X X    | $FAED
    .byte $54 ; | X X X  | $FAEE
    .byte $55 ; | X X X X| $FAEF
    .byte $01 ; |       X| $FAF0
    .byte $05 ; |     X X| $FAF1
    .byte $15 ; |   X X X| $FAF2
    .byte $55 ; | X X X X| $FAF3
    .byte $00 ; |        | $FAF4
    .byte $7E ; | XXXXXX | $FAF5
    .byte $FF ; |XXXXXXXX| $FAF6
    .byte $E7 ; |XXX  XXX| $FAF7
    .byte $81 ; |X      X| $FAF8
    .byte $81 ; |X      X| $FAF9
    .byte $81 ; |X      X| $FAFA
    .byte $81 ; |X      X| $FAFB
    .byte $99 ; |X  XX  X| $FAFC
    .byte $E7 ; |XXX  XXX| $FAFD
    .byte $81 ; |X      X| $FAFE
    .byte $81 ; |X      X| $FAFF
    .byte $81 ; |X      X| $FB00
    .byte $81 ; |X      X| $FB01
    .byte $81 ; |X      X| $FB02
    .byte $99 ; |X  XX  X| $FB03
    .byte $E7 ; |XXX  XXX| $FB04
    .byte $81 ; |X      X| $FB05
    .byte $81 ; |X      X| $FB06
    .byte $81 ; |X      X| $FB07
    .byte $81 ; |X      X| $FB08
    .byte $81 ; |X      X| $FB09
    .byte $81 ; |X      X| $FB0A
    .byte $81 ; |X      X| $FB0B
    .byte $81 ; |X      X| $FB0C
    .byte $C3 ; |XX    XX| $FB0D
    .byte $42 ; | X    X | $FB0E
    .byte $66 ; | XX  XX | $FB0F
    .byte $3C ; |  XXXX  | $FB10
    .byte $18 ; |   XX   | $FB11
    .byte $18 ; |   XX   | $FB12
LFB13:
    .byte $00 ; |        | $FB13
    .byte $3C ; |  XXXX  | $FB14
    .byte $3C ; |  XXXX  | $FB15
    .byte $3C ; |  XXXX  | $FB16
    .byte $38 ; |  XXX   | $FB17
    .byte $38 ; |  XXX   | $FB18
    .byte $38 ; |  XXX   | $FB19
    .byte $78 ; | XXXX   | $FB1A
    .byte $7C ; | XXXXX  | $FB1B
    .byte $FE ; |XXXXXXX | $FB1C
    .byte $F2 ; |XXXX  X | $FB1D
    .byte $E2 ; |XXX   X | $FB1E
    .byte $E2 ; |XXX   X | $FB1F
    .byte $C6 ; |XX   XX | $FB20
    .byte $CE ; |XX  XXX | $FB21
    .byte $CE ; |XX  XXX | $FB22
    .byte $4E ; | X  XXX | $FB23
    .byte $7C ; | XXXXX  | $FB24
    .byte $38 ; |  XXX   | $FB25
    .byte $38 ; |  XXX   | $FB26
    .byte $7C ; | XXXXX  | $FB27
    .byte $7C ; | XXXXX  | $FB28
    .byte $74 ; | XXX X  | $FB29
    .byte $7C ; | XXXXX  | $FB2A
    .byte $38 ; |  XXX   | $FB2B
    .byte $00 ; |        | $FB2C
    .byte $00 ; |        | $FB2D
LFB2E:
    .byte $00 ; |        | $FB2E
    .byte $E7 ; |XXX  XXX| $FB2F
    .byte $E7 ; |XXX  XXX| $FB30
    .byte $E7 ; |XXX  XXX| $FB31
    .byte $C6 ; |XX   XX | $FB32
    .byte $E6 ; |XXX  XX | $FB33
    .byte $6E ; | XX XXX | $FB34
    .byte $EC ; |XXX XX  | $FB35
    .byte $F8 ; |XXXXX   | $FB36
    .byte $FC ; |XXXXXX  | $FB37
    .byte $FC ; |XXXXXX  | $FB38
    .byte $F3 ; |XXXX  XX| $FB39
    .byte $E3 ; |XXX   XX| $FB3A
    .byte $E3 ; |XXX   XX| $FB3B
    .byte $C4 ; |XX   X  | $FB3C
    .byte $CC ; |XX  XX  | $FB3D
    .byte $4C ; | X  XX  | $FB3E
    .byte $7C ; | XXXXX  | $FB3F
    .byte $38 ; |  XXX   | $FB40
    .byte $38 ; |  XXX   | $FB41
    .byte $7C ; | XXXXX  | $FB42
    .byte $7C ; | XXXXX  | $FB43
    .byte $74 ; | XXX X  | $FB44
    .byte $7C ; | XXXXX  | $FB45
    .byte $38 ; |  XXX   | $FB46
    .byte $00 ; |        | $FB47
    .byte $00 ; |        | $FB48
LFB49:
    .byte COL_00 ; |        | $FB49
    .byte COL_F4 ; |XXXX X  | $FB4A
    .byte COL_F4 ; |XXXX X  | $FB4B
    .byte COL_F4 ; |XXXX X  | $FB4C
    .byte COL_F4 ; |XXXX X  | $FB4D
    .byte COL_F8 ; |XXXXX   | $FB4E
    .byte COL_F8 ; |XXXXX   | $FB4F
    .byte COL_F8 ; |XXXXX   | $FB50
    .byte COL_F8 ; |XXXXX   | $FB51
    .byte COL_F8 ; |XXXXX   | $FB52
    .byte COL_F8 ; |XXXXX   | $FB53
    .byte COL_F8 ; |XXXXX   | $FB54
    .byte COL_F8 ; |XXXXX   | $FB55
    .byte COL_F8 ; |XXXXX   | $FB56
    .byte COL_F8 ; |XXXXX   | $FB57
    .byte COL_F8 ; |XXXXX   | $FB58
    .byte COL_F8 ; |XXXXX   | $FB59
    .byte COL_F8 ; |XXXXX   | $FB5A
    .byte COL_F8 ; |XXXXX   | $FB5B
    .byte COL_F8 ; |XXXXX   | $FB5C
    .byte COL_F8 ; |XXXXX   | $FB5D
    .byte COL_F8 ; |XXXXX   | $FB5E
    .byte COL_F8 ; |XXXXX   | $FB5F
    .byte COL_F8 ; |XXXXX   | $FB60
    .byte COL_F8 ; |XXXXX   | $FB61
    .byte COL_00 ; |        | $FB62
    .byte COL_00 ; |        | $FB63

    .byte $00 ; |        | $FB64
    .byte $00 ; |        | $FB65
    .byte $44 ; | X   X  | $FB66
    .byte $44 ; | X   X  | $FB67
    .byte $44 ; | X   X  | $FB68
    .byte $44 ; | X   X  | $FB69
    .byte $44 ; | X   X  | $FB6A
    .byte $44 ; | X   X  | $FB6B
    .byte $6C ; | XX XX  | $FB6C
    .byte $6C ; | XX XX  | $FB6D
    .byte $7C ; | XXXXX  | $FB6E
    .byte $7C ; | XXXXX  | $FB6F
    .byte $38 ; |  XXX   | $FB70
    .byte $38 ; |  XXX   | $FB71
    .byte $38 ; |  XXX   | $FB72
    .byte $7C ; | XXXXX  | $FB73
    .byte $7C ; | XXXXX  | $FB74
    .byte $7C ; | XXXXX  | $FB75
    .byte $FE ; |XXXXXXX | $FB76
    .byte $92 ; |X  X  X | $FB77
    .byte $92 ; |X  X  X | $FB78
    .byte $BA ; |X XXX X | $FB79
    .byte $BA ; |X XXX X | $FB7A
    .byte $38 ; |  XXX   | $FB7B
    .byte $00 ; |        | $FB7C
    .byte $00 ; |        | $FB7D
    .byte $00 ; |        | $FB7E
    .byte $00 ; |        | $FB7F
    .byte $00 ; |        | $FB80
    .byte $00 ; |        | $FB81
    .byte $00 ; |        | $FB82
    .byte $00 ; |        | $FB83
    .byte $60 ; | XX     | $FB84
    .byte $40 ; | X      | $FB85
    .byte $58 ; | X XX   | $FB86
    .byte $50 ; | X X    | $FB87
    .byte $50 ; | X X    | $FB88
    .byte $50 ; | X X    | $FB89
    .byte $50 ; | X X    | $FB8A
    .byte $50 ; | X X    | $FB8B
    .byte $70 ; | XXX    | $FB8C
    .byte $70 ; | XXX    | $FB8D
    .byte $60 ; | XX     | $FB8E
    .byte $60 ; | XX     | $FB8F
    .byte $60 ; | XX     | $FB90
    .byte $70 ; | XXX    | $FB91
    .byte $78 ; | XXXX   | $FB92
    .byte $70 ; | XXX    | $FB93
    .byte $78 ; | XXXX   | $FB94
    .byte $4C ; | X  XX  | $FB95
    .byte $46 ; | X   XX | $FB96
    .byte $62 ; | XX   X | $FB97
    .byte $60 ; | XX     | $FB98
    .byte $60 ; | XX     | $FB99
    .byte $00 ; |        | $FB9A
    .byte $00 ; |        | $FB9B
    .byte $00 ; |        | $FB9C
    .byte $00 ; |        | $FB9D
    .byte $00 ; |        | $FB9E
    .byte $00 ; |        | $FB9F
LFBA0:
    .byte COL_00 ; |        | $FBA0  SENTA colors
    .byte COL_00 ; |        | $FBA1
    .byte COL_3A ; |  XXX X | $FBA2
    .byte COL_3A ; |  XXX X | $FBA3
    .byte COL_3A ; |  XXX X | $FBA4
    .byte COL_3A ; |  XXX X | $FBA5
    .byte COL_3A ; |  XXX X | $FBA6
    .byte COL_3A ; |  XXX X | $FBA7
    .byte COL_3A ; |  XXX X | $FBA8
    .byte COL_64 ; | XX  X  | $FBA9
    .byte COL_64 ; | XX  X  | $FBAA
    .byte COL_64 ; | XX  X  | $FBAB
    .byte COL_64 ; | XX  X  | $FBAC
    .byte COL_3A ; |  XXX X | $FBAD
    .byte COL_3A ; |  XXX X | $FBAE
    .byte COL_64 ; | XX  X  | $FBAF
    .byte COL_64 ; | XX  X  | $FBB0
    .byte COL_64 ; | XX  X  | $FBB1
    .byte COL_64 ; | XX  X  | $FBB2
    .byte COL_3A ; |  XXX X | $FBB3
    .byte COL_3A ; |  XXX X | $FBB4
    .byte COL_3A ; |  XXX X | $FBB5
    .byte COL_3A ; |  XXX X | $FBB6
    .byte COL_3A ; |  XXX X | $FBB7
    .byte COL_00 ; |        | $FBB8
    .byte COL_00 ; |        | $FBB9
    .byte COL_00 ; |        | $FBBA
    .byte COL_00 ; |        | $FBBB
    .byte COL_00 ; |        | $FBBC
    .byte COL_00 ; |        | $FBBD
LFBBE:
    .byte COL_E0 ; |XXX     | $FBBE  background colors
    .byte COL_E0 ; |XXX     | $FBBF
    .byte COL_E0 ; |XXX     | $FBC0
    .byte COL_C2 ; |XX    X | $FBC1
    .byte COL_C2 ; |XX    X | $FBC2
    .byte COL_C2 ; |XX    X | $FBC3
    .byte COL_70 ; | XXX    | $FBC4
    .byte COL_70 ; | XXX    | $FBC5
    .byte COL_70 ; | XXX    | $FBC6
LFBC7:
    .byte $C3 ; |XX    XX| $FBC7  PF1
    .byte $FF ; |XXXXXXXX| $FBC8
    .byte $FF ; |XXXXXXXX| $FBC9
    .byte $C3 ; |XX    XX| $FBCA
    .byte $FF ; |XXXXXXXX| $FBCB
    .byte $C3 ; |XX    XX| $FBCC
    .byte $FF ; |XXXXXXXX| $FBCD
    .byte $FF ; |XXXXXXXX| $FBCE
    .byte $FF ; |XXXXXXXX| $FBCF
LFBD0:
    .byte $FF ; |XXXXXXXX| $FBD0  PF1 right side
    .byte $C3 ; |XX    XX| $FBD1
    .byte $FF ; |XXXXXXXX| $FBD2
    .byte $FF ; |XXXXXXXX| $FBD3
    .byte $C3 ; |XX    XX| $FBD4
    .byte $FF ; |XXXXXXXX| $FBD5
    .byte $FF ; |XXXXXXXX| $FBD6
    .byte $FF ; |XXXXXXXX| $FBD7
    .byte $FF ; |XXXXXXXX| $FBD8
LFBD9:
    .byte $FF ; |XXXXXXXX| $FBD9  PF2
    .byte $FF ; |XXXXXXXX| $FBDA
    .byte $3F ; |  XXXXXX| $FBDB
    .byte $FF ; |XXXXXXXX| $FBDC
    .byte $FF ; |XXXXXXXX| $FBDD
    .byte $FF ; |XXXXXXXX| $FBDE
    .byte $FF ; |XXXXXXXX| $FBDF
    .byte $FF ; |XXXXXXXX| $FBE0
    .byte $FF ; |XXXXXXXX| $FBE1
LFBE2:
    .word LFD35          ; $FBE2
LFBE4:
    .word LFCC5          ; $FBE4
    .word LFCDF          ; $FBE6
    .word LFD35          ; $FBE8
    .word LFCDF          ; $FBEA
    .word LFCC5          ; $FBEC
    .word LFD35          ; $FBEE
    .word LFCDF          ; $FBF0
    .word LFD11          ; $FBF2
    .word LFD35          ; $FBF4

    .byte $00 ; |        | $FBF6
    .byte $00 ; |        | $FBF7
    .byte $00 ; |        | $FBF8
    .byte $00 ; |        | $FBF9
    .byte $00 ; |        | $FBFA
    .byte $00 ; |        | $FBFB
    .byte $00 ; |        | $FBFC
    .byte $00 ; |        | $FBFD
    .byte $00 ; |        | $FBFE
    .byte $00 ; |        | $FBFF
    .byte $00 ; |        | $FC00
    .byte $00 ; |        | $FC01
    .byte $00 ; |        | $FC02
    .byte $70 ; | XXX    | $FC03
    .byte $60 ; | XX     | $FC04
    .byte $78 ; | XXXX   | $FC05
    .byte $3C ; |  XXXX  | $FC06
    .byte $0C ; |    XX  | $FC07
    .byte $7E ; | XXXXXX | $FC08
    .byte $7E ; | XXXXXX | $FC09
    .byte $78 ; | XXXX   | $FC0A
    .byte $66 ; | XX  XX | $FC0B
    .byte $27 ; |  X  XXX| $FC0C
    .byte $2D ; |  X XX X| $FC0D
    .byte $2C ; |  X XX  | $FC0E
    .byte $2C ; |  X XX  | $FC0F
    .byte $3E ; |  XXXXX | $FC10
    .byte $1E ; |   XXXX | $FC11
    .byte $0C ; |    XX  | $FC12
    .byte $1E ; |   XXXX | $FC13
    .byte $1E ; |   XXXX | $FC14
    .byte $1A ; |   XX X | $FC15
    .byte $1E ; |   XXXX | $FC16
    .byte $0C ; |    XX  | $FC17
    .byte $00 ; |        | $FC18
    .byte $00 ; |        | $FC19
    .byte $00 ; |        | $FC1A
    .byte $00 ; |        | $FC1B
    .byte $00 ; |        | $FC1C
    .byte $E7 ; |XXX  XXX| $FC1D
    .byte $E7 ; |XXX  XXX| $FC1E
    .byte $E7 ; |XXX  XXX| $FC1F
    .byte $C6 ; |XX   XX | $FC20
    .byte $66 ; | XX  XX | $FC21
    .byte $66 ; | XX  XX | $FC22
    .byte $6C ; | XX XX  | $FC23
    .byte $3C ; |  XXXX  | $FC24
    .byte $3C ; |  XXXX  | $FC25
    .byte $3C ; |  XXXX  | $FC26
    .byte $33 ; |  XX  XX| $FC27
    .byte $33 ; |  XX  XX| $FC28
    .byte $34 ; |  XX X  | $FC29
    .byte $24 ; |  X  X  | $FC2A
    .byte $24 ; |  X  X  | $FC2B
    .byte $2C ; |  X XX  | $FC2C
    .byte $3C ; |  XXXX  | $FC2D
    .byte $18 ; |   XX   | $FC2E
    .byte $18 ; |   XX   | $FC2F
    .byte $3C ; |  XXXX  | $FC30
    .byte $3C ; |  XXXX  | $FC31
    .byte $34 ; |  XX X  | $FC32
    .byte $3C ; |  XXXX  | $FC33
    .byte $18 ; |   XX   | $FC34
    .byte $00 ; |        | $FC35
    .byte $00 ; |        | $FC36
    .byte $00 ; |        | $FC37
    .byte $00 ; |        | $FC38
    .byte $00 ; |        | $FC39
    .byte $1C ; |   XXX  | $FC3A
    .byte $1C ; |   XXX  | $FC3B
    .byte $1C ; |   XXX  | $FC3C
    .byte $18 ; |   XX   | $FC3D
    .byte $18 ; |   XX   | $FC3E
    .byte $18 ; |   XX   | $FC3F
    .byte $18 ; |   XX   | $FC40
    .byte $18 ; |   XX   | $FC41
    .byte $3C ; |  XXXX  | $FC42
    .byte $3D ; |  XXXX X| $FC43
    .byte $3B ; |  XXX XX| $FC44
    .byte $3A ; |  XXX X | $FC45
    .byte $34 ; |  XX X  | $FC46
    .byte $34 ; |  XX X  | $FC47
    .byte $34 ; |  XX X  | $FC48
    .byte $34 ; |  XX X  | $FC49
    .byte $3C ; |  XXXX  | $FC4A
    .byte $18 ; |   XX   | $FC4B
    .byte $18 ; |   XX   | $FC4C
    .byte $3C ; |  XXXX  | $FC4D
    .byte $3C ; |  XXXX  | $FC4E
    .byte $34 ; |  XX X  | $FC4F
    .byte $3C ; |  XXXX  | $FC50
    .byte $18 ; |   XX   | $FC51
    .byte $00 ; |        | $FC52
    .byte $00 ; |        | $FC53
    .byte $00 ; |        | $FC54
    .byte $00 ; |        | $FC55
    .byte $00 ; |        | $FC56
    .byte $00 ; |        | $FC57
    .byte $00 ; |        | $FC58
    .byte $00 ; |        | $FC59
LFC5A:
    .byte COL_00 ; |        | $FC5A  TOMARC Colors
    .byte COL_00 ; |        | $FC5B
    .byte COL_F4 ; |XXXX X  | $FC5C
    .byte COL_F4 ; |XXXX X  | $FC5D
    .byte COL_F4 ; |XXXX X  | $FC5E
    .byte COL_F4 ; |XXXX X  | $FC5F
    .byte COL_F4 ; |XXXX X  | $FC60
    .byte COL_3A ; |  XXX X | $FC61
    .byte COL_3A ; |  XXX X | $FC62
    .byte COL_3A ; |  XXX X | $FC63
    .byte COL_F4 ; |XXXX X  | $FC64
    .byte COL_F4 ; |XXXX X  | $FC65
    .byte COL_F4 ; |XXXX X  | $FC66
    .byte COL_3A ; |  XXX X | $FC67
    .byte COL_3A ; |  XXX X | $FC68
    .byte COL_3A ; |  XXX X | $FC69
    .byte COL_3A ; |  XXX X | $FC6A
    .byte COL_3A ; |  XXX X | $FC6B
    .byte COL_3A ; |  XXX X | $FC6C
    .byte COL_3A ; |  XXX X | $FC6D
    .byte COL_3A ; |  XXX X | $FC6E
    .byte COL_3A ; |  XXX X | $FC6F
    .byte COL_3A ; |  XXX X | $FC70
    .byte COL_3A ; |  XXX X | $FC71
    .byte COL_F4 ; |XXXX X  | $FC72
    .byte COL_F4 ; |XXXX X  | $FC73
LFC74:
    .word LFDB5          ; $FC74
    .word LFDD3          ; $FC76
    .word LFDC4          ; $FC78
    .word LFDE2          ; $FC7A
    .word LFDC4          ; $FC7C
    .word LFDB5          ; $FC7E
    .word LFDD3          ; $FC80
    .word LFDB5          ; $FC82
    .word LFDE2          ; $FC84
LFC86:
    .word LFDC4          ; $FC86
    .word LFDE2          ; $FC88
    .word LFDB5          ; $FC8A
    .word LFDB5          ; $FC8C
    .word LFDD3          ; $FC8E
    .word LFDC4          ; $FC90
    .word LFDC4          ; $FC92
    .word LFDE2          ; $FC94
    .word LFDC4          ; $FC96
LFC98:
    .word LFE43          ; $FC98
    .word LFE30          ; $FC9A
    .word LFE1E          ; $FC9C
    .word LFE1E          ; $FC9E
    .word LFE2F          ; $FCA0
    .word LFE43          ; $FCA2
    .word LFE30          ; $FCA4
    .word LFE78          ; $FCA6
    .word LFE43          ; $FCA8
LFCAA:
    .word LFDF1          ; $FCAA
    .word LFE00          ; $FCAC
    .word LFDF1          ; $FCAE
    .word LFE00          ; $FCB0
    .word LFDF1          ; $FCB2
    .word LFE0F          ; $FCB4
    .word LFDF1          ; $FCB6
    .word LFE00          ; $FCB8
    .word LFDF1          ; $FCBA
LFCBC:
    .byte COL_3F ; |  XXXXXX| $FCBC  playfield colors
    .byte COL_3F ; |  XXXXXX| $FCBD
    .byte COL_3F ; |  XXXXXX| $FCBE
    .byte COL_DF ; |XX XXXXX| $FCBF
    .byte COL_DF ; |XX XXXXX| $FCC0
    .byte COL_DF ; |XX XXXXX| $FCC1
    .byte COL_8F ; |X   XXXX| $FCC2
    .byte COL_8F ; |X   XXXX| $FCC3
    .byte COL_8F ; |X   XXXX| $FCC4
LFCC5:
    .byte $F0 ; |XXXX    | $FCC5
    .byte $F0 ; |XXXX    | $FCC6
    .byte $F0 ; |XXXX    | $FCC7
    .byte $F0 ; |XXXX    | $FCC8
    .byte $F0 ; |XXXX    | $FCC9
    .byte $F0 ; |XXXX    | $FCCA
    .byte $F0 ; |XXXX    | $FCCB
    .byte $F0 ; |XXXX    | $FCCC
    .byte $F0 ; |XXXX    | $FCCD
    .byte $F0 ; |XXXX    | $FCCE
    .byte $F0 ; |XXXX    | $FCCF
    .byte $F0 ; |XXXX    | $FCD0
    .byte $F0 ; |XXXX    | $FCD1
    .byte $F0 ; |XXXX    | $FCD2
    .byte $F0 ; |XXXX    | $FCD3
    .byte $F0 ; |XXXX    | $FCD4
    .byte $F0 ; |XXXX    | $FCD5
    .byte $F0 ; |XXXX    | $FCD6
    .byte $F0 ; |XXXX    | $FCD7
    .byte $F0 ; |XXXX    | $FCD8
    .byte $F0 ; |XXXX    | $FCD9
    .byte $F0 ; |XXXX    | $FCDA
    .byte $F0 ; |XXXX    | $FCDB
    .byte $F0 ; |XXXX    | $FCDC
    .byte $F0 ; |XXXX    | $FCDD
    .byte $F0 ; |XXXX    | $FCDE
LFCDF:
    .byte $F0 ; |XXXX    | $FCDF
    .byte $F0 ; |XXXX    | $FCE0
    .byte $F0 ; |XXXX    | $FCE1
    .byte $F0 ; |XXXX    | $FCE2
    .byte $F0 ; |XXXX    | $FCE3
    .byte $F0 ; |XXXX    | $FCE4
    .byte $F0 ; |XXXX    | $FCE5
    .byte $F0 ; |XXXX    | $FCE6
    .byte $F0 ; |XXXX    | $FCE7
    .byte $F0 ; |XXXX    | $FCE8
    .byte $F0 ; |XXXX    | $FCE9
    .byte $F0 ; |XXXX    | $FCEA
    .byte $F0 ; |XXXX    | $FCEB
    .byte $F0 ; |XXXX    | $FCEC
    .byte $F0 ; |XXXX    | $FCED
    .byte $F0 ; |XXXX    | $FCEE
    .byte $F0 ; |XXXX    | $FCEF
    .byte $F0 ; |XXXX    | $FCF0
    .byte $F0 ; |XXXX    | $FCF1
    .byte $F0 ; |XXXX    | $FCF2
    .byte $F0 ; |XXXX    | $FCF3
    .byte $F0 ; |XXXX    | $FCF4
    .byte $F0 ; |XXXX    | $FCF5
    .byte $F0 ; |XXXX    | $FCF6
    .byte $F0 ; |XXXX    | $FCF7
    .byte $F0 ; |XXXX    | $FCF8
    .byte $F0 ; |XXXX    | $FCF9
    .byte $F0 ; |XXXX    | $FCFA
    .byte $F0 ; |XXXX    | $FCFB
    .byte $F0 ; |XXXX    | $FCFC
    .byte $F0 ; |XXXX    | $FCFD
    .byte $F0 ; |XXXX    | $FCFE
    .byte $F0 ; |XXXX    | $FCFF
    .byte $F0 ; |XXXX    | $FD00
    .byte $F0 ; |XXXX    | $FD01
    .byte $F0 ; |XXXX    | $FD02
    .byte $F0 ; |XXXX    | $FD03
    .byte $F0 ; |XXXX    | $FD04
    .byte $F0 ; |XXXX    | $FD05
    .byte $F0 ; |XXXX    | $FD06
    .byte $F0 ; |XXXX    | $FD07
    .byte $F0 ; |XXXX    | $FD08
    .byte $F0 ; |XXXX    | $FD09
    .byte $F0 ; |XXXX    | $FD0A
    .byte $F0 ; |XXXX    | $FD0B
    .byte $F0 ; |XXXX    | $FD0C
    .byte $F0 ; |XXXX    | $FD0D
    .byte $F0 ; |XXXX    | $FD0E
    .byte $F0 ; |XXXX    | $FD0F
    .byte $F0 ; |XXXX    | $FD10
LFD11:
    .byte $F0 ; |XXXX    | $FD11
    .byte $F0 ; |XXXX    | $FD12
    .byte $F0 ; |XXXX    | $FD13
    .byte $00 ; |        | $FD14
    .byte $00 ; |        | $FD15
    .byte $00 ; |        | $FD16
    .byte $00 ; |        | $FD17
    .byte $00 ; |        | $FD18
    .byte $00 ; |        | $FD19
    .byte $00 ; |        | $FD1A
    .byte $00 ; |        | $FD1B
    .byte $00 ; |        | $FD1C
    .byte $00 ; |        | $FD1D
    .byte $00 ; |        | $FD1E
    .byte $00 ; |        | $FD1F
    .byte $00 ; |        | $FD20
    .byte $00 ; |        | $FD21
    .byte $00 ; |        | $FD22
    .byte $00 ; |        | $FD23
    .byte $00 ; |        | $FD24
    .byte $00 ; |        | $FD25
    .byte $00 ; |        | $FD26
    .byte $00 ; |        | $FD27
    .byte $00 ; |        | $FD28
    .byte $00 ; |        | $FD29
    .byte $00 ; |        | $FD2A
    .byte $00 ; |        | $FD2B
    .byte $00 ; |        | $FD2C
    .byte $00 ; |        | $FD2D
    .byte $00 ; |        | $FD2E
    .byte $00 ; |        | $FD2F
    .byte $00 ; |        | $FD30
    .byte $00 ; |        | $FD31
    .byte $00 ; |        | $FD32
    .byte $00 ; |        | $FD33
    .byte $00 ; |        | $FD34
LFD35:
    .byte $F0 ; |XXXX    | $FD35
    .byte $F0 ; |XXXX    | $FD36
    .byte $F0 ; |XXXX    | $FD37
    .byte $F0 ; |XXXX    | $FD38
    .byte $F0 ; |XXXX    | $FD39
    .byte $F0 ; |XXXX    | $FD3A
    .byte $F0 ; |XXXX    | $FD3B
    .byte $F0 ; |XXXX    | $FD3C
    .byte $F0 ; |XXXX    | $FD3D
    .byte $F0 ; |XXXX    | $FD3E
    .byte $F0 ; |XXXX    | $FD3F
    .byte $F0 ; |XXXX    | $FD40
    .byte $F0 ; |XXXX    | $FD41
    .byte $F0 ; |XXXX    | $FD42
    .byte $F0 ; |XXXX    | $FD43
    .byte $F0 ; |XXXX    | $FD44
    .byte $F0 ; |XXXX    | $FD45
    .byte $F0 ; |XXXX    | $FD46
    .byte $F0 ; |XXXX    | $FD47
    .byte $F0 ; |XXXX    | $FD48
    .byte $F0 ; |XXXX    | $FD49
    .byte $F0 ; |XXXX    | $FD4A
    .byte $F0 ; |XXXX    | $FD4B
    .byte $F0 ; |XXXX    | $FD4C
    .byte $F0 ; |XXXX    | $FD4D
    .byte $F0 ; |XXXX    | $FD4E
    .byte $F0 ; |XXXX    | $FD4F
    .byte $F0 ; |XXXX    | $FD50
    .byte $F0 ; |XXXX    | $FD51
    .byte $F0 ; |XXXX    | $FD52
    .byte $F0 ; |XXXX    | $FD53
    .byte $F0 ; |XXXX    | $FD54
    .byte $F0 ; |XXXX    | $FD55
    .byte $F0 ; |XXXX    | $FD56
    .byte $F0 ; |XXXX    | $FD57
    .byte $F0 ; |XXXX    | $FD58
    .byte $F0 ; |XXXX    | $FD59
    .byte $F0 ; |XXXX    | $FD5A
    .byte $F0 ; |XXXX    | $FD5B
    .byte $F0 ; |XXXX    | $FD5C
    .byte $F0 ; |XXXX    | $FD5D
    .byte $F0 ; |XXXX    | $FD5E
    .byte $F0 ; |XXXX    | $FD5F
    .byte $F0 ; |XXXX    | $FD60
    .byte $F0 ; |XXXX    | $FD61
    .byte $F0 ; |XXXX    | $FD62
    .byte $F0 ; |XXXX    | $FD63
    .byte $F0 ; |XXXX    | $FD64
    .byte $F0 ; |XXXX    | $FD65
    .byte $F0 ; |XXXX    | $FD66
    .byte $F0 ; |XXXX    | $FD67
    .byte $F0 ; |XXXX    | $FD68
    .byte $F0 ; |XXXX    | $FD69
    .byte $F0 ; |XXXX    | $FD6A
    .byte $F0 ; |XXXX    | $FD6B
    .byte $F0 ; |XXXX    | $FD6C
    .byte $F0 ; |XXXX    | $FD6D
    .byte $F0 ; |XXXX    | $FD6E
    .byte $F0 ; |XXXX    | $FD6F
    .byte $F0 ; |XXXX    | $FD70
    .byte $F0 ; |XXXX    | $FD71
    .byte $F0 ; |XXXX    | $FD72
    .byte $F0 ; |XXXX    | $FD73
    .byte $F0 ; |XXXX    | $FD74
    .byte $F0 ; |XXXX    | $FD75
    .byte $F0 ; |XXXX    | $FD76
    .byte $F0 ; |XXXX    | $FD77
    .byte $F0 ; |XXXX    | $FD78
    .byte $F0 ; |XXXX    | $FD79
    .byte $F0 ; |XXXX    | $FD7A
    .byte $F0 ; |XXXX    | $FD7B
    .byte $F0 ; |XXXX    | $FD7C
    .byte $F0 ; |XXXX    | $FD7D
    .byte $F0 ; |XXXX    | $FD7E
    .byte $F0 ; |XXXX    | $FD7F
    .byte $F0 ; |XXXX    | $FD80
    .byte $F0 ; |XXXX    | $FD81
    .byte $F0 ; |XXXX    | $FD82
    .byte $F0 ; |XXXX    | $FD83
    .byte $F0 ; |XXXX    | $FD84
    .byte $F0 ; |XXXX    | $FD85
    .byte $F0 ; |XXXX    | $FD86
    .byte $F0 ; |XXXX    | $FD87
    .byte $F0 ; |XXXX    | $FD88
    .byte $F0 ; |XXXX    | $FD89
    .byte $F0 ; |XXXX    | $FD8A
    .byte $F0 ; |XXXX    | $FD8B
    .byte $F0 ; |XXXX    | $FD8C
    .byte $F0 ; |XXXX    | $FD8D
    .byte $F0 ; |XXXX    | $FD8E
    .byte $F0 ; |XXXX    | $FD8F
    .byte $F0 ; |XXXX    | $FD90
    .byte $F0 ; |XXXX    | $FD91
    .byte $F0 ; |XXXX    | $FD92
    .byte $F0 ; |XXXX    | $FD93
    .byte $F0 ; |XXXX    | $FD94
    .byte $F0 ; |XXXX    | $FD95
    .byte $F0 ; |XXXX    | $FD96
    .byte $F0 ; |XXXX    | $FD97
    .byte $F0 ; |XXXX    | $FD98
    .byte $F0 ; |XXXX    | $FD99
    .byte $F0 ; |XXXX    | $FD9A
    .byte $F0 ; |XXXX    | $FD9B
    .byte $F0 ; |XXXX    | $FD9C
    .byte $F0 ; |XXXX    | $FD9D
    .byte $F0 ; |XXXX    | $FD9E
    .byte $F0 ; |XXXX    | $FD9F
    .byte $F0 ; |XXXX    | $FDA0
    .byte $F0 ; |XXXX    | $FDA1
    .byte $F0 ; |XXXX    | $FDA2
    .byte $F0 ; |XXXX    | $FDA3
    .byte $F0 ; |XXXX    | $FDA4
    .byte $F0 ; |XXXX    | $FDA5
    .byte $F0 ; |XXXX    | $FDA6
    .byte $F0 ; |XXXX    | $FDA7
    .byte $F0 ; |XXXX    | $FDA8
    .byte $F0 ; |XXXX    | $FDA9
    .byte $F0 ; |XXXX    | $FDAA
    .byte $F0 ; |XXXX    | $FDAB
    .byte $F0 ; |XXXX    | $FDAC
    .byte $F0 ; |XXXX    | $FDAD
    .byte $F0 ; |XXXX    | $FDAE
    .byte $F0 ; |XXXX    | $FDAF
    .byte $F0 ; |XXXX    | $FDB0
    .byte $F0 ; |XXXX    | $FDB1
    .byte $F0 ; |XXXX    | $FDB2
    .byte $F0 ; |XXXX    | $FDB3
    .byte $F0 ; |XXXX    | $FDB4
LFDB5:
    .byte $00 ; |        | $FDB5
    .byte $20 ; |  X     | $FDB6
    .byte $20 ; |  X     | $FDB7
    .byte $32 ; |  XX  X | $FDB8
    .byte $32 ; |  XX  X | $FDB9
    .byte $BA ; |X XXX X | $FDBA
    .byte $BB ; |X XXX XX| $FDBB
    .byte $BB ; |X XXX XX| $FDBC
    .byte $FB ; |XXXXX XX| $FDBD
    .byte $FB ; |XXXXX XX| $FDBE
    .byte $FF ; |XXXXXXXX| $FDBF
    .byte $FF ; |XXXXXXXX| $FDC0
    .byte $FF ; |XXXXXXXX| $FDC1
    .byte $FF ; |XXXXXXXX| $FDC2
    .byte $FF ; |XXXXXXXX| $FDC3
LFDC4:
    .byte $00 ; |        | $FDC4
    .byte $28 ; |  X X   | $FDC5
    .byte $28 ; |  X X   | $FDC6
    .byte $38 ; |  XXX   | $FDC7
    .byte $38 ; |  XXX   | $FDC8
    .byte $38 ; |  XXX   | $FDC9
    .byte $3A ; |  XXX X | $FDCA
    .byte $7A ; | XXXX X | $FDCB
    .byte $7E ; | XXXXXX | $FDCC
    .byte $7E ; | XXXXXX | $FDCD
    .byte $FF ; |XXXXXXXX| $FDCE
    .byte $FF ; |XXXXXXXX| $FDCF
    .byte $FF ; |XXXXXXXX| $FDD0
    .byte $FF ; |XXXXXXXX| $FDD1
    .byte $FF ; |XXXXXXXX| $FDD2
LFDD3:
    .byte $00 ; |        | $FDD3
    .byte $01 ; |       X| $FDD4
    .byte $01 ; |       X| $FDD5
    .byte $01 ; |       X| $FDD6
    .byte $01 ; |       X| $FDD7
    .byte $01 ; |       X| $FDD8
    .byte $01 ; |       X| $FDD9
    .byte $01 ; |       X| $FDDA
    .byte $41 ; | X     X| $FDDB
    .byte $41 ; | X     X| $FDDC
    .byte $C3 ; |XX    XX| $FDDD
    .byte $C3 ; |XX    XX| $FDDE
    .byte $C3 ; |XX    XX| $FDDF
    .byte $C3 ; |XX    XX| $FDE0
    .byte $C3 ; |XX    XX| $FDE1
LFDE2:
    .byte $00 ; |        | $FDE2
    .byte $40 ; | X      | $FDE3
    .byte $40 ; | X      | $FDE4
    .byte $40 ; | X      | $FDE5
    .byte $41 ; | X     X| $FDE6
    .byte $41 ; | X     X| $FDE7
    .byte $C1 ; |XX     X| $FDE8
    .byte $C3 ; |XX    XX| $FDE9
    .byte $C3 ; |XX    XX| $FDEA
    .byte $C3 ; |XX    XX| $FDEB
    .byte $C3 ; |XX    XX| $FDEC
    .byte $C3 ; |XX    XX| $FDED
    .byte $C3 ; |XX    XX| $FDEE
    .byte $C3 ; |XX    XX| $FDEF
    .byte $C3 ; |XX    XX| $FDF0
LFDF1:
    .byte $80 ; |X       | $FDF1
    .byte $80 ; |X       | $FDF2
    .byte $82 ; |X     X | $FDF3
    .byte $82 ; |X     X | $FDF4
    .byte $96 ; |X  X XX | $FDF5
    .byte $96 ; |X  X XX | $FDF6
    .byte $96 ; |X  X XX | $FDF7
    .byte $96 ; |X  X XX | $FDF8
    .byte $DF ; |XX XXXXX| $FDF9
    .byte $DF ; |XX XXXXX| $FDFA
    .byte $FF ; |XXXXXXXX| $FDFB
    .byte $FF ; |XXXXXXXX| $FDFC
    .byte $FF ; |XXXXXXXX| $FDFD
    .byte $FF ; |XXXXXXXX| $FDFE
    .byte $FF ; |XXXXXXXX| $FDFF
LFE00:
    .byte $00 ; |        | $FE00
    .byte $00 ; |        | $FE01
    .byte $09 ; |    X  X| $FE02
    .byte $09 ; |    X  X| $FE03
    .byte $09 ; |    X  X| $FE04
    .byte $29 ; |  X X  X| $FE05
    .byte $2D ; |  X XX X| $FE06
    .byte $6D ; | XX XX X| $FE07
    .byte $6D ; | XX XX X| $FE08
    .byte $7F ; | XXXXXXX| $FE09
    .byte $FF ; |XXXXXXXX| $FE0A
    .byte $FF ; |XXXXXXXX| $FE0B
    .byte $FF ; |XXXXXXXX| $FE0C
    .byte $FF ; |XXXXXXXX| $FE0D
    .byte $FF ; |XXXXXXXX| $FE0E
LFE0F:
    .byte $10 ; |   X    | $FE0F
    .byte $10 ; |   X    | $FE10
    .byte $12 ; |   X  X | $FE11
    .byte $12 ; |   X  X | $FE12
    .byte $12 ; |   X  X | $FE13
    .byte $13 ; |   X  XX| $FE14
    .byte $1B ; |   XX XX| $FE15
    .byte $1B ; |   XX XX| $FE16
    .byte $3F ; |  XXXXXX| $FE17
    .byte $3F ; |  XXXXXX| $FE18
    .byte $3F ; |  XXXXXX| $FE19
    .byte $3F ; |  XXXXXX| $FE1A
    .byte $3F ; |  XXXXXX| $FE1B
    .byte $3F ; |  XXXXXX| $FE1C
    .byte $3F ; |  XXXXXX| $FE1D
LFE1E:
    .byte $00 ; |        | $FE1E
    .byte $00 ; |        | $FE1F
    .byte $00 ; |        | $FE20
    .byte $00 ; |        | $FE21
    .byte $00 ; |        | $FE22
    .byte $00 ; |        | $FE23
    .byte $00 ; |        | $FE24
    .byte $00 ; |        | $FE25
    .byte $00 ; |        | $FE26
    .byte $00 ; |        | $FE27
    .byte $00 ; |        | $FE28
    .byte $00 ; |        | $FE29
    .byte $00 ; |        | $FE2A
    .byte $00 ; |        | $FE2B
    .byte $00 ; |        | $FE2C
    .byte $00 ; |        | $FE2D
    .byte $00 ; |        | $FE2E
LFE2F:
    .byte $00 ; |        | $FE2F
LFE30:
    .byte $00 ; |        | $FE30
    .byte $00 ; |        | $FE31
    .byte $00 ; |        | $FE32
    .byte $00 ; |        | $FE33
    .byte $00 ; |        | $FE34
    .byte $00 ; |        | $FE35
    .byte $00 ; |        | $FE36
    .byte $00 ; |        | $FE37
    .byte $00 ; |        | $FE38
    .byte $00 ; |        | $FE39
    .byte $00 ; |        | $FE3A
    .byte $00 ; |        | $FE3B
    .byte $00 ; |        | $FE3C
    .byte $00 ; |        | $FE3D
    .byte $00 ; |        | $FE3E
    .byte $00 ; |        | $FE3F
    .byte $00 ; |        | $FE40
    .byte $00 ; |        | $FE41
    .byte $00 ; |        | $FE42
LFE43:
    .byte $00 ; |        | $FE43
    .byte $00 ; |        | $FE44
    .byte $00 ; |        | $FE45
    .byte $00 ; |        | $FE46
    .byte $00 ; |        | $FE47
    .byte $00 ; |        | $FE48
    .byte $00 ; |        | $FE49
    .byte $00 ; |        | $FE4A
    .byte $00 ; |        | $FE4B
    .byte $00 ; |        | $FE4C
    .byte $00 ; |        | $FE4D
    .byte $00 ; |        | $FE4E
    .byte $00 ; |        | $FE4F
    .byte $00 ; |        | $FE50
    .byte $00 ; |        | $FE51
    .byte $00 ; |        | $FE52
    .byte $00 ; |        | $FE53
    .byte $00 ; |        | $FE54
    .byte $00 ; |        | $FE55
    .byte $00 ; |        | $FE56
    .byte $00 ; |        | $FE57
    .byte $00 ; |        | $FE58
    .byte $00 ; |        | $FE59
    .byte $00 ; |        | $FE5A
    .byte $00 ; |        | $FE5B
    .byte $00 ; |        | $FE5C
    .byte $00 ; |        | $FE5D
    .byte $00 ; |        | $FE5E
    .byte $00 ; |        | $FE5F
    .byte $00 ; |        | $FE60
    .byte $00 ; |        | $FE61
    .byte $00 ; |        | $FE62
    .byte $00 ; |        | $FE63
    .byte $00 ; |        | $FE64
    .byte $00 ; |        | $FE65
    .byte $00 ; |        | $FE66
    .byte $00 ; |        | $FE67
    .byte $00 ; |        | $FE68
    .byte $00 ; |        | $FE69
    .byte $00 ; |        | $FE6A
    .byte $00 ; |        | $FE6B
    .byte $00 ; |        | $FE6C
    .byte $00 ; |        | $FE6D
    .byte $00 ; |        | $FE6E
    .byte $00 ; |        | $FE6F
    .byte $00 ; |        | $FE70
    .byte $00 ; |        | $FE71
    .byte $F0 ; |XXXX    | $FE72
    .byte $F0 ; |XXXX    | $FE73
    .byte $F0 ; |XXXX    | $FE74
    .byte $F0 ; |XXXX    | $FE75
    .byte $F0 ; |XXXX    | $FE76
    .byte $F0 ; |XXXX    | $FE77
LFE78:
    .byte $00 ; |        | $FE78
    .byte $00 ; |        | $FE79
    .byte $00 ; |        | $FE7A
    .byte $00 ; |        | $FE7B
    .byte $00 ; |        | $FE7C
    .byte $00 ; |        | $FE7D
    .byte $00 ; |        | $FE7E
    .byte $00 ; |        | $FE7F
    .byte $00 ; |        | $FE80
    .byte $00 ; |        | $FE81
    .byte $00 ; |        | $FE82
    .byte $00 ; |        | $FE83
    .byte $00 ; |        | $FE84
    .byte $00 ; |        | $FE85
    .byte $00 ; |        | $FE86
    .byte $00 ; |        | $FE87
    .byte $00 ; |        | $FE88
    .byte $00 ; |        | $FE89
    .byte $00 ; |        | $FE8A
    .byte $00 ; |        | $FE8B
    .byte $00 ; |        | $FE8C
    .byte $00 ; |        | $FE8D
    .byte $00 ; |        | $FE8E
    .byte $00 ; |        | $FE8F
    .byte $00 ; |        | $FE90
    .byte $00 ; |        | $FE91
    .byte $00 ; |        | $FE92
    .byte $00 ; |        | $FE93
    .byte $00 ; |        | $FE94
    .byte $00 ; |        | $FE95
    .byte $00 ; |        | $FE96
    .byte $00 ; |        | $FE97
    .byte $00 ; |        | $FE98
    .byte $00 ; |        | $FE99
    .byte $00 ; |        | $FE9A
    .byte $00 ; |        | $FE9B
    .byte $00 ; |        | $FE9C
    .byte $00 ; |        | $FE9D
    .byte $00 ; |        | $FE9E
    .byte $00 ; |        | $FE9F
    .byte $00 ; |        | $FEA0
    .byte $00 ; |        | $FEA1
    .byte $00 ; |        | $FEA2
    .byte $00 ; |        | $FEA3
    .byte $00 ; |        | $FEA4
    .byte $00 ; |        | $FEA5
    .byte $00 ; |        | $FEA6
    .byte $00 ; |        | $FEA7
    .byte $00 ; |        | $FEA8
    .byte $00 ; |        | $FEA9
    .byte $00 ; |        | $FEAA
    .byte $00 ; |        | $FEAB
    .byte $00 ; |        | $FEAC
    .byte $00 ; |        | $FEAD
    .byte $00 ; |        | $FEAE
    .byte $00 ; |        | $FEAF
    .byte $00 ; |        | $FEB0
    .byte $00 ; |        | $FEB1
    .byte $00 ; |        | $FEB2
    .byte $00 ; |        | $FEB3
    .byte $00 ; |        | $FEB4
    .byte $00 ; |        | $FEB5
    .byte $00 ; |        | $FEB6
    .byte $00 ; |        | $FEB7
    .byte $00 ; |        | $FEB8
    .byte $00 ; |        | $FEB9
    .byte $00 ; |        | $FEBA
    .byte $00 ; |        | $FEBB
    .byte $00 ; |        | $FEBC
    .byte $00 ; |        | $FEBD
    .byte $00 ; |        | $FEBE
    .byte $00 ; |        | $FEBF
    .byte $00 ; |        | $FEC0
    .byte $00 ; |        | $FEC1
    .byte $00 ; |        | $FEC2
    .byte $00 ; |        | $FEC3
    .byte $00 ; |        | $FEC4
    .byte $00 ; |        | $FEC5
    .byte $00 ; |        | $FEC6
    .byte $00 ; |        | $FEC7
    .byte $00 ; |        | $FEC8
    .byte $00 ; |        | $FEC9
    .byte $00 ; |        | $FECA
    .byte $00 ; |        | $FECB
    .byte $00 ; |        | $FECC
    .byte $00 ; |        | $FECD
    .byte $00 ; |        | $FECE
    .byte $00 ; |        | $FECF
    .byte $00 ; |        | $FED0
    .byte $00 ; |        | $FED1
    .byte $00 ; |        | $FED2
    .byte $00 ; |        | $FED3
    .byte $00 ; |        | $FED4
    .byte $00 ; |        | $FED5
    .byte $00 ; |        | $FED6
    .byte $00 ; |        | $FED7
    .byte $00 ; |        | $FED8
    .byte $00 ; |        | $FED9
    .byte $00 ; |        | $FEDA
    .byte $00 ; |        | $FEDB
    .byte $00 ; |        | $FEDC
    .byte $00 ; |        | $FEDD
    .byte $00 ; |        | $FEDE
    .byte $00 ; |        | $FEDF
    .byte $00 ; |        | $FEE0
    .byte $00 ; |        | $FEE1
    .byte $00 ; |        | $FEE2
    .byte $00 ; |        | $FEE3
    .byte $00 ; |        | $FEE4
    .byte $00 ; |        | $FEE5
    .byte $00 ; |        | $FEE6
    .byte $00 ; |        | $FEE7
    .byte $00 ; |        | $FEE8
    .byte $00 ; |        | $FEE9
    .byte $00 ; |        | $FEEA
    .byte $00 ; |        | $FEEB
    .byte $00 ; |        | $FEEC
    .byte $00 ; |        | $FEED
    .byte $00 ; |        | $FEEE
    .byte $00 ; |        | $FEEF
    .byte $00 ; |        | $FEF0
    .byte $00 ; |        | $FEF1
    .byte $00 ; |        | $FEF2
    .byte $00 ; |        | $FEF3
    .byte $00 ; |        | $FEF4
    .byte $00 ; |        | $FEF5
    .byte $00 ; |        | $FEF6
    .byte $00 ; |        | $FEF7
    .byte $00 ; |        | $FEF8
    .byte $00 ; |        | $FEF9
    .byte $10 ; |   X    | $FEFA
    .byte $1C ; |   XXX  | $FEFB
    .byte $38 ; |  XXX   | $FEFC
    .byte $08 ; |    X   | $FEFD
    .byte $00 ; |        | $FEFE
    .byte $00 ; |        | $FEFF
    .byte $00 ; |        | $FF00
    .byte $00 ; |        | $FF01
    .byte $00 ; |        | $FF02
    .byte $00 ; |        | $FF03
    .byte $00 ; |        | $FF04
    .byte $00 ; |        | $FF05
    .byte $00 ; |        | $FF06
    .byte $00 ; |        | $FF07
    .byte $00 ; |        | $FF08
    .byte $00 ; |        | $FF09
    .byte $00 ; |        | $FF0A
    .byte $00 ; |        | $FF0B
    .byte $00 ; |        | $FF0C
    .byte $00 ; |        | $FF0D
    .byte $00 ; |        | $FF0E
    .byte $00 ; |        | $FF0F
    .byte $00 ; |        | $FF10
    .byte $00 ; |        | $FF11
    .byte $00 ; |        | $FF12
    .byte $00 ; |        | $FF13
    .byte $00 ; |        | $FF14
    .byte $00 ; |        | $FF15
    .byte $00 ; |        | $FF16
    .byte $00 ; |        | $FF17
    .byte $00 ; |        | $FF18
    .byte $00 ; |        | $FF19
    .byte $00 ; |        | $FF1A
    .byte $00 ; |        | $FF1B
    .byte $00 ; |        | $FF1C
    .byte $00 ; |        | $FF1D
    .byte $00 ; |        | $FF1E
    .byte $00 ; |        | $FF1F
    .byte $00 ; |        | $FF20
    .byte $81 ; |X      X| $FF21
    .byte $81 ; |X      X| $FF22
    .byte $A5 ; |X X  X X| $FF23
    .byte $A5 ; |X X  X X| $FF24
    .byte $EF ; |XXX XXXX| $FF25
    .byte $EF ; |XXX XXXX| $FF26
    .byte $FE ; |XXXXXXX | $FF27
    .byte $7E ; | XXXXXX | $FF28
    .byte $54 ; | X X X  | $FF29
    .byte $7C ; | XXXXX  | $FF2A
    .byte $28 ; |  X X   | $FF2B
    .byte $28 ; |  X X   | $FF2C
    .byte $00 ; |        | $FF2D
    .byte $00 ; |        | $FF2E
    .byte $00 ; |        | $FF2F
    .byte $00 ; |        | $FF30
    .byte $00 ; |        | $FF31
    .byte $00 ; |        | $FF32
    .byte $00 ; |        | $FF33
    .byte $00 ; |        | $FF34
    .byte $00 ; |        | $FF35
    .byte $00 ; |        | $FF36
    .byte $00 ; |        | $FF37
    .byte $00 ; |        | $FF38
    .byte $00 ; |        | $FF39
    .byte $00 ; |        | $FF3A
    .byte $00 ; |        | $FF3B
    .byte $00 ; |        | $FF3C
    .byte $00 ; |        | $FF3D
    .byte $00 ; |        | $FF3E
    .byte $00 ; |        | $FF3F
    .byte $00 ; |        | $FF40
    .byte $00 ; |        | $FF41
    .byte $00 ; |        | $FF42
    .byte $00 ; |        | $FF43
    .byte $00 ; |        | $FF44
    .byte $00 ; |        | $FF45
    .byte $00 ; |        | $FF46
    .byte $00 ; |        | $FF47
    .byte $00 ; |        | $FF48
    .byte $00 ; |        | $FF49
    .byte $00 ; |        | $FF4A
    .byte $00 ; |        | $FF4B
    .byte $00 ; |        | $FF4C
    .byte $00 ; |        | $FF4D
    .byte $00 ; |        | $FF4E
    .byte $00 ; |        | $FF4F
    .byte $00 ; |        | $FF50
    .byte $81 ; |X      X| $FF51
    .byte $81 ; |X      X| $FF52
    .byte $A3 ; |X X   XX| $FF53
    .byte $E7 ; |XXX  XXX| $FF54
    .byte $FF ; |XXXXXXXX| $FF55
    .byte $D7 ; |XX X XXX| $FF56
    .byte $BD ; |X XXXX X| $FF57
    .byte $A8 ; |X X X   | $FF58
    .byte $28 ; |  X X   | $FF59
    .byte $00 ; |        | $FF5A
    .byte $00 ; |        | $FF5B
    .byte $00 ; |        | $FF5C
    .byte $00 ; |        | $FF5D
    .byte $00 ; |        | $FF5E
    .byte $00 ; |        | $FF5F
    .byte $00 ; |        | $FF60
    .byte $00 ; |        | $FF61
    .byte $00 ; |        | $FF62
    .byte $00 ; |        | $FF63
    .byte $00 ; |        | $FF64
    .byte $00 ; |        | $FF65
    .byte $00 ; |        | $FF66
    .byte $00 ; |        | $FF67
    .byte $00 ; |        | $FF68
    .byte $00 ; |        | $FF69
    .byte $00 ; |        | $FF6A
    .byte $00 ; |        | $FF6B
    .byte $00 ; |        | $FF6C
    .byte $00 ; |        | $FF6D
    .byte $00 ; |        | $FF6E
    .byte $00 ; |        | $FF6F
    .byte $00 ; |        | $FF70
    .byte $00 ; |        | $FF71
    .byte $00 ; |        | $FF72
    .byte $00 ; |        | $FF73
    .byte $00 ; |        | $FF74
    .byte $00 ; |        | $FF75
    .byte $00 ; |        | $FF76
    .byte $00 ; |        | $FF77
    .byte $00 ; |        | $FF78
    .byte $00 ; |        | $FF79
    .byte $00 ; |        | $FF7A
LFF7B:
    .byte $40 ; | X      | $FF7B
    .byte $53 ; | X X  XX| $FF7C
    .byte $65 ; | XX  X X| $FF7D
    .byte $65 ; | XX  X X| $FF7E
    .byte $53 ; | X X  XX| $FF7F
    .byte $40 ; | X      | $FF80
    .byte $53 ; | X X  XX| $FF81
    .byte $00 ; |        | $FF82
    .byte $40 ; | X      | $FF83
    .byte $00 ; |        | $FF84
    .byte $00 ; |        | $FF85
    .byte $00 ; |        | $FF86
    .byte $10 ; |   X    | $FF87
    .byte $08 ; |    X   | $FF88
    .byte $10 ; |   X    | $FF89
    .byte $08 ; |    X   | $FF8A
    .byte $28 ; |  X X   | $FF8B
    .byte $3C ; |  XXXX  | $FF8C
    .byte $38 ; |  XXX   | $FF8D
    .byte $1C ; |   XXX  | $FF8E
    .byte $3C ; |  XXXX  | $FF8F
    .byte $1C ; |   XXX  | $FF90
    .byte $18 ; |   XX   | $FF91
    .byte $00 ; |        | $FF92
    .byte $00 ; |        | $FF93
    .byte $00 ; |        | $FF94
    .byte $14 ; |   X X  | $FF95
    .byte $5C ; | X XXX  | $FF96
    .byte $BF ; |X XXXXXX| $FF97
    .byte $1E ; |   XXXX | $FF98
    .byte $00 ; |        | $FF99
    .byte $00 ; |        | $FF9A
    .byte $00 ; |        | $FF9B
    .byte $00 ; |        | $FF9C
    .byte $00 ; |        | $FF9D
    .byte $00 ; |        | $FF9E
    .byte $00 ; |        | $FF9F
    .byte $00 ; |        | $FFA0
    .byte $00 ; |        | $FFA1
    .byte $00 ; |        | $FFA2
    .byte $00 ; |        | $FFA3
    .byte $0A ; |    X X | $FFA4
    .byte $1C ; |   XXX  | $FFA5
    .byte $BF ; |X XXXXXX| $FFA6
    .byte $AE ; |X X XXX | $FFA7
    .byte $00 ; |        | $FFA8
    .byte $00 ; |        | $FFA9
    .byte $00 ; |        | $FFAA
    .byte $00 ; |        | $FFAB
    .byte $00 ; |        | $FFAC
    .byte $00 ; |        | $FFAD
    .byte $00 ; |        | $FFAE
    .byte $00 ; |        | $FFAF
    .byte $00 ; |        | $FFB0
    .byte $00 ; |        | $FFB1
    .byte $80 ; |X       | $FFB2
    .byte $50 ; | X X    | $FFB3
    .byte $20 ; |  X     | $FFB4
    .byte $50 ; | X X    | $FFB5
    .byte $08 ; |    X   | $FFB6
    .byte $04 ; |     X  | $FFB7
    .byte $02 ; |      X | $FFB8
    .byte $01 ; |       X| $FFB9
    .byte $00 ; |        | $FFBA
    .byte $00 ; |        | $FFBB
    .byte $00 ; |        | $FFBC
    .byte $00 ; |        | $FFBD
LFFBE:
    .byte $00 ; |        | $FFBE
    .byte $00 ; |        | $FFBF
    .byte $00 ; |        | $FFC0
LFFC1:
    .byte $05 ; |     X X| $FFC1
    .byte $05 ; |     X X| $FFC2
    .byte $05 ; |     X X| $FFC3
LFFC4:
    .byte $0A ; |    X X | $FFC4
    .byte $0A ; |    X X | $FFC5
    .byte $0A ; |    X X | $FFC6
LFFC7:
    .byte $10 ; |   X    | $FFC7
LFFC8:
    .byte $00 ; |        | $FFC8
    .byte $07 ; |     XXX| $FFC9
    .byte $05 ; |     X X| $FFCA
    .byte $03 ; |      XX| $FFCB
    .byte $20 ; |  X     | $FFCC
    .byte $00 ; |        | $FFCD
    .byte $00 ; |        | $FFCE
    .byte $00 ; |        | $FFCF
    .byte $00 ; |        | $FFD0
    .byte $40 ; | X      | $FFD1
LFFD2:
    .byte $A6 ; |X X  XX | $FFD2
    .byte $98 ; |X  XX   | $FFD3
    .byte $8A ; |X   X X | $FFD4
    .byte $74 ; | XXX X  | $FFD5
    .byte $6A ; | XX X X | $FFD6
    .byte $00 ; |        | $FFD7
LFFD8:
    .byte $05 ; |     X X| $FFD8  AUDF0
    .byte $04 ; |     X  | $FFD9
    .byte $03 ; |      XX| $FFDA
    .byte $04 ; |     X  | $FFDB
    .byte $03 ; |      XX| $FFDC
    .byte $FF ; |XXXXXXXX| $FFDD
    .byte $F4 ; |XXXX X  | $FFDE
    .byte $FE ; |XXXXXXX | $FFDF
    .byte $FF ; |XXXXXXXX| $FFE0
    .byte $FF ; |XXXXXXXX| $FFE1
    .byte $FE ; |XXXXXXX | $FFE2
    .byte $FE ; |XXXXXXX | $FFE3
    .byte $FF ; |XXXXXXXX| $FFE4
    .byte $FF ; |XXXXXXXX| $FFE5
    .byte $FE ; |XXXXXXX | $FFE6
    .byte $FE ; |XXXXXXX | $FFE7
    .byte $FF ; |XXXXXXXX| $FFE8
    .byte $FF ; |XXXXXXXX| $FFE9


START_0:
    ldx    #$FF                  ; 2
    txs                          ; 2
    lda    #>(LF000-1)           ; 2
    pha                          ; 3
    lda    #<(LF000-1)           ; 2
    pha                          ; 3
LFFF3:
    lda    BANK_1                ; 4
    rts                          ; 6

    .byte $FE ; |XXXXXXX | $FFF7
    .byte $FF ; |XXXXXXXX| $FFF8
    .byte $FF ; |XXXXXXXX| $FFF9
    .byte $FE ; |XXXXXXX | $FFFA
    .byte $FE ; |XXXXXXX | $FFFB

       ORG $0FFC
      RORG $FFFC

    .word START_0
    .word 0




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      BANK 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       ORG $1000
      RORG $F000

START_1:
  IF COLOR_NTSC
    sei                          ; 2
  ENDIF
    cld                          ; 2
    ldx    #$FF                  ; 2
    txs                          ; 2
    inx                          ; 2
    txa                          ; 2
MF007:
    sta    0,X                   ; 4
    inx                          ; 2
    bne    MF007                 ; 2³
    lda    #$01                  ; 2
    sta    CTRLPF                ; 3
    sta    ram_AD                ; 3
    lda    #$80                  ; 2
MF014:
    sta    ram_ED                ; 3

  IF !COLOR_NTSC
    LDA    #$42
    STA    ram_A1
    LDA    #COL_42
    STA    ram_D2
    BNE    MF025  ; always branch

  ELSE
    lda    #$42                  ; 2
    sta    ram_A1                ; 3   time
    sta    ram_D2                ; 3   color
    jmp    MF025                 ; 3
  ENDIF

    .byte $00 ; |        | $F01F
    .byte $21 ; |  X    X| $F020
    .byte $21 ; |  X    X| $F021
    .byte $01 ; |       X| $F022
    .byte $00 ; |        | $F023
    .byte $01 ; |       X| $F024

MF025:
    jsr    MFAE1                 ; 6
    ldx    #$00                  ; 2
    stx    GRP0                  ; 3
    stx    GRP1                  ; 3
    lda    ram_80                ; 3
    clc                          ; 2
    adc    #$01                  ; 2
    cmp    #$18                  ; 2
    bne    MF038                 ; 2³
    txa                          ; 2
MF038:
    sta    ram_80                ; 3
    lda    ram_ED                ; 3
    bpl    MF047                 ; 2³
    lda    #COL_06               ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    jmp    MF047                 ; 3

MF047:
  IF CORRECT_SCANLINES
    BIT    TIMINT
    BPL    MF047
    LDX    #0
  ELSE
    ldx    INTIM                 ; 4
    bne    MF047                 ; 2³
  ENDIF
    stx    WSYNC                 ; 3
;---------------------------------------
  IF !CORRECT_SCANLINES
    stx    VBLANK                ; 3  ; VBLANK ends title screen line 15
  ENDIF
    lda    ram_ED                ; 3
    bmi    MF057                 ; 2³
    jmp    MF0CF                 ; 3

MF057:
    ldx    #$16                  ; 2
MF059:
    stx    WSYNC                 ; 3
;---------------------------------------
    dex                          ; 2
    bne    MF059                 ; 2³
    lda    #$13                  ; 2
    sta    HMCLR                 ; 3
    sta    HMP1                  ; 3

  IF CORRECT_SCANLINES
    STA    NUSIZ0
    STA    WSYNC
;---------------------------------------
    STX    VBLANK  ; vblank ends
    STA    NUSIZ1
    LDY    #$07
  ELSE
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    NUSIZ0                ; 3
    sta    NUSIZ1                ; 3
    ldy    #$07                  ; 2
  ENDIF


    sty    VDELP0                ; 3
    sty    VDELP1                ; 3
    jsr    MFAE0                 ; 6
    jsr    MFAE0                 ; 6
    sta    RESP0                 ; 3
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    HMOVE                 ; 3
    ldy    #$18                  ; 2
MF080:
    sty    ram_A4                ; 3
    lda    MFFC9,Y               ; 4
    sta    WSYNC                 ; 3
;---------------------------------------
    sta    ram_A5                ; 3
    lda    MFF4C,Y               ; 4
    lda    MFF4C,Y               ; 4
    sta    GRP0                  ; 3
    lda    MFF65,Y               ; 4
    sta    GRP1                  ; 3
    lda    MFF7E,Y               ; 4
    sta    GRP0                  ; 3
    lda    MFFB0,Y               ; 4
    tax                          ; 2
    lda    MFF97,Y               ; 4
    ldy    ram_A5                ; 3
    nop                          ; 2
    sta    GRP1                  ; 3
    stx    GRP0                  ; 3
    sty    GRP1                  ; 3
    sta    GRP0                  ; 3
    ldy    ram_A4                ; 3
    dey                          ; 2
    bpl    MF080                 ; 2³
    ldx    #$01                  ; 2
    iny                          ; 2
MF0B5:
    sty    GRP0,X                ; 4
    sty    NUSIZ0,X              ; 4
    sty    VDELP0,X              ; 4
    dex                          ; 2
    beq    MF0B5                 ; 2³
  IF !CORRECT_SCANLINES
    stx    WSYNC                 ; 3
  ENDIF
;---------------------------------------
    lda    #>(MF0F7-1)           ; 2
    pha                          ; 3
    lda    #<(MF0F7-1)           ; 2
    pha                          ; 3
    lda    #>(LF013-1)           ; 2
    pha                          ; 3
    lda    #<(LF013-1)           ; 2
  IF SEGA_GENESIS
    JMP    MFFF2
  ELSE
    pha                          ; 3
    jmp    MFFF3                 ; 3
  ENDIF



MF0CF:
    lda    #COL_52               ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    ldx    #$10                  ; 2
MF0D7:
    stx    WSYNC                 ; 3
;---------------------------------------
    dex                          ; 2
    bne    MF0D7                 ; 2³
    lda    #$AA                  ; 2
    sta    ram_90                ; 3
    sta    ram_92                ; 3
    lda    ram_AD                ; 3
    and    #$03                  ; 2
    sta    ram_91                ; 3
    lda    #>(MF0F7_CORRECT-1)           ; 2
    pha                          ; 3
    lda    #<(MF0F7_CORRECT-1)           ; 2
    pha                          ; 3
    lda    #>(LF000-1)           ; 2
    pha                          ; 3
    lda    #<(LF000-1)           ; 2
  IF SEGA_GENESIS
    JMP    MFFF2
  ELSE
    pha                          ; 3
    jmp    MFFF3                 ; 3
  ENDIF

MF0F7_CORRECT:
  IF CORRECT_SCANLINES
    LDX   #TIM_4A
    .byte $0C  ; NOP, skip 2 bytes
  ENDIF

MF0F7:  ; indirect jump
    ldx    #TIM_4                ; 2
  IF CORRECT_SCANLINES
    STX    TIM64T
  ELSE
    stx    TIM8T                 ; 4
  ENDIF
    ldx    ram_A1                ; 3
    beq    MF105                 ; 2³
    dec    ram_A1                ; 5
    jmp    MF164                 ; 3

MF105:
    lda    ram_ED                ; 3
    bpl    MF12C                 ; 2³
    lda    INPT4                 ; 3
    bpl    MF11F                 ; 2³

  IF SEGA_GENESIS  ; +5
    LDA    INPT1
    ASL
    LDA    SWCHA
    AND    #$D0
    ADC    #0
    EOR    #$D1

  ELSE
    lda    SWCHA                 ; 4
    and    #$F0                  ; 2
    eor    #$F0                  ; 2
  ENDIF

    bne    MF11F                 ; 2³
    lda    SWCHB                 ; 4
    and    #$03                  ; 2
    eor    #$03                  ; 2
    beq    MF164                 ; 2³
MF11F:
    lda    ram_ED                ; 3
    eor    #$C0                  ; 2
    sta    ram_ED                ; 3
    lda    #$3C                  ; 2
    sta    ram_A1                ; 3
  IF SEGA_GENESIS
    BNE    MF164  ; always branch
  ELSE
    jmp    MF164                 ; 3
  ENDIF

MF12C:

  IF SEGA_GENESIS  ; +8
    LDA    SWCHA
    AND    #~$20
    BIT    INPT1
    BPL    .storeA0_a
    ORA    #$20
.storeA0_a:
    STA    ram_A0

  ELSE
    lda    SWCHA                 ; 4
    sta    ram_A0                ; 3
  ENDIF

    and    #$10                  ; 2
    beq    MF149                 ; 2³
    lda    SWCHB                 ; 4
    tax                          ; 2
    and    #$02                  ; 2
    beq    MF149                 ; 2³
    txa                          ; 2
    and    #$01                  ; 2  titlescreen with score
    beq    MF16E                 ; 2³
    lda    INPT4                 ; 3

  IF SEGA_GENESIS
    AND    INPT1
  ENDIF

    bpl    MF16E                 ; 2³
  IF SEGA_GENESIS
    BMI    MF164  ; always branch
  ELSE
    jmp    MF164                 ; 3
  ENDIF

MF149:
    lda    ram_AD                ; 3
    and    #$03                  ; 2
    cmp    #$03                  ; 2
    bne    MF153                 ; 2³
    lda    #$00                  ; 2
MF153:
    clc                          ; 2
    adc    #$01                  ; 2
    sta    ram_A5                ; 3
    lda    #$FC                  ; 2
    and    ram_AD                ; 3
    ora    ram_A5                ; 3
    sta    ram_AD                ; 3
    lda    #$14                  ; 2
    sta    ram_A1                ; 3
MF164:
  IF CORRECT_SCANLINES
    BIT    TIMINT
    BPL    MF164
  ELSE
    ldx    INTIM                 ; 4
    bne    MF164                 ; 2³
  ENDIF

    stx    WSYNC                 ; 3
;---------------------------------------
    jmp    MF025                 ; 3  title screen line 240, need to write to turn VBLANK on


  IF SEGA_GENESIS
    NOP  ; free bytes
    NOP
  ENDIF

MF16E:

  IF CORRECT_SCANLINES
    LDY    #TITLE_TO_PLAY_RESET
.loopTitleToPlayscreen
    STA    WSYNC
;---------------------------------------
    DEY
    BNE   .loopTitleToPlayscreen
    LDA    #$08
    STA    ram_93

  ELSE
    lda    #$08                  ; 2
    sta    ram_93                ; 3
    ldy    #$00                  ; 2
  ENDIF
    sty    ram_81                ; 3
    sty    ram_82                ; 3
    sty    ram_83                ; 3
MF17A:
    lda    ram_93                ; 3
    and    #$0F                  ; 2
    sta    ram_93                ; 3
    lda    ram_AD                ; 3
    and    #$03                  ; 2
    sta    ram_AD                ; 3
    tax                          ; 2
    lda    MFEF3,X               ; 4
    sta    ram_C0                ; 3
    lda    #$30                  ; 2
    sta    ram_F0                ; 3

  IF SEGA_GENESIS
    LDY    #$00
    STY    ram_B9
    STY    ram_AC
    STY    ram_DC
    STY    AUDV0
    STY    AUDV1
    STY    COLUBK
    STY    ram_F2
    LDA    #$20
    STA    ram_A1
    STA    ram_AE
    STA    ram_ED
    STA    ram_F1

  ELSE
    lda    #$20                  ; 2
    sta    ram_F1                ; 3
    ldy    #$00                  ; 2
    sty    ram_B9                ; 3
    sty    ram_AC                ; 3
    sty    ram_DC                ; 3
    sty    AUDV0                 ; 3
    sty    AUDV1                 ; 3
    sty    COLUBK                ; 3
    sty    ram_F2                ; 3
    lda    #$20                  ; 2
    sta    ram_A1                ; 3
    sta    ram_AE                ; 3
    sta    ram_ED                ; 3
  ENDIF

    lda    #$3C                  ; 2
    sta    ram_B3                ; 3
    lda    #$64                  ; 2
    sta    ram_D4                ; 3
    lda    #$FB                  ; 2
    sta    ram_D5                ; 3
    lda    ram_80                ; 3
    and    #$07                  ; 2
    cmp    #$07                  ; 2
    bne    MF1C2                 ; 2³
    lda    #$08                  ; 2
MF1C2:
    sta    ram_B1                ; 3
    lda    ram_80                ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    clc                          ; 2
    adc    #$06                  ; 2
    sta    ram_80                ; 3
    sta    ram_B2                ; 3
MF1D0:
    jsr    MFAE1                 ; 6
    ldx    #$01                  ; 2
MF1D5:
    lda    ram_EE,X              ; 4
    bmi    MF1E2                 ; 2³
    bne    MF1E0                 ; 2³
    sta    AUDV0,X               ; 4
  IF SEGA_GENESIS
    .byte $0C  ; NOP, skip 2 bytes
  ELSE
    jmp    MF1E2                 ; 3
  ENDIF

MF1E0:
    dec    ram_EE,X              ; 6
MF1E2:
    dex                          ; 2
    bpl    MF1D5                 ; 2³
    ldx    ram_ED                ; 3
    txa                          ; 2
    and    #$01                  ; 2
    bne    MF1FF                 ; 2³
    lda    ram_B2                ; 3
    bmi    MF243                 ; 2³+1
    lda    #>(MF243-1)           ; 2
    pha                          ; 3
    lda    #<(MF243-1)           ; 2
    pha                          ; 3
    lda    #>(LF085-1)           ; 2
    pha                          ; 3
    lda    #<(LF085-1)           ; 2
  IF SEGA_GENESIS
    JMP    MFFF2
  ELSE
    pha                          ; 3
    jmp    MFFF3                 ; 3
  ENDIF

MF1FF:
    txa                          ; 2
    and    #$04                  ; 2
    beq    MF20B                 ; 2³
    lda    ram_CA                ; 3
    
  IF CORRECT_SCANLINES
    BEQ    MF220
  ELSE
    beq    MF226                 ; 2³
  ENDIF
    jmp    MF293                 ; 3
    
MF20B:
    dec    ram_A1                ; 5
    lda    ram_A1                ; 3
    cmp    #$30                  ; 2
    beq    MF21D                 ; 2³  RESET automatically after death
    eor    #$FF                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    AUDF0                 ; 3
    jmp    MF243                 ; 3

MF21D:
    lda    #$00                  ; 2
    sta    AUDV0                 ; 3


  IF CORRECT_SCANLINES

    STA    WSYNC
;---------------------------------------
    LDY    #DEATH_TO_TITLE_RESET
DelayScanlines:
    STA    REFP0
    STA    REFP1
.loopPlayToTitlescreen
    STA    WSYNC
;---------------------------------------
    DEY
    BNE   .loopPlayToTitlescreen

  ENDIF


MF221:
    lda    #$40                  ; 2
    jmp    MF014                 ; 3
    
  IF CORRECT_SCANLINES
    NOP  ; free byte
  ENDIF
    
MF220:

  IF CORRECT_SCANLINES
    LDY    #VICTORY_TO_GAME_START
.loopVictoryToGame:
    STA    WSYNC
;---------------------------------------
    DEY
    BNE   .loopVictoryToGame
  ENDIF

MF226:
    lda    ram_AD                ; 3  here1
    and    #$03                  ; 2
    cmp    #$03                  ; 2
    beq    MF233                 ; 2³
    clc                          ; 2
    adc    #$01                  ; 2
    sta    ram_AD                ; 3
MF233:
    lda    ram_80                ; 3
    and    #$1F                  ; 2
    cmp    #$18                  ; 2
    bmi    MF23E                 ; 2³
    sec                          ; 2
    sbc    #$18                  ; 2
MF23E:
    sta    ram_80                ; 3
    jmp    MF17A                 ; 3

MF243:  ; inidrect jump also
    lda    ram_ED                ; 3
    and    #$10                  ; 2
    bne    MF276                 ; 2³
    sta    REFP0                 ; 3
    sta    REFP1                 ; 3
    lda    ram_B9                ; 3
    cmp    #$18                  ; 2
    bmi    MF255                 ; 2³
    lda    #$19                  ; 2
MF255:
    sta    ram_D8                ; 3
    lda    #$0D                  ; 2
    sta    ram_D7                ; 3
    ldx    ram_80                ; 3
    lda    ram_B1                ; 3
    and    #$0F                  ; 2
    cmp    ram_80                ; 3
    bne    MF270                 ; 2³
    lda    ram_93                ; 3
    and    #$20                  ; 2
    bne    MF270                 ; 2³
    lda    MFF02,X               ; 4
    sta    ram_D6                ; 3
MF270:
    jsr    MFBBF                 ; 6
    jmp    MF293                 ; 3

MF276:
    lda    #$06                  ; 2
    sta    ram_C8                ; 3
    lda    ram_ED                ; 3
    and    #$05                  ; 2
    cmp    #$04                  ; 2
    bne    MF293                 ; 2³
    lda    ram_DD                ; 3
    and    #$0F                  ; 2
    bne    MF293                 ; 2³
    lda    ram_CC                ; 3
    beq    MF293                 ; 2³
    lda    ram_F1                ; 3
    jsr    MFDE1                 ; 6
    dec    ram_CC                ; 5
MF293:
  IF CORRECT_SCANLINES
    BIT    TIMINT
    BPL    MF293
    LDX    #0
  ELSE
    ldx    INTIM                 ; 4
    bne    MF293                 ; 2³
  ENDIF
    stx    WSYNC                 ; 3
;---------------------------------------
  IF !CORRECT_SCANLINES
    stx    VBLANK                ; 3  line 15 Tomarc Playing screen, Senta playing screen
  ENDIF
    lda    #>(MF2AB-1)           ; 2
    pha                          ; 3
    lda    #<(MF2AB-1)           ; 2
    pha                          ; 3
    lda    #>(LF124-1)           ; 2
    pha                          ; 3
    lda    #<(LF124-1)           ; 2
  IF SEGA_GENESIS
    JMP    MFFF2
  ELSE
    pha                          ; 3
    jmp    MFFF3                 ; 3
  ENDIF

MF2AB:  ; indirect jump

  IF SEGA_GENESIS  ; +8
    LDA    SWCHA
    AND    #~$20
    BIT    INPT1
    BPL    .storeA0_b
    ORA    #$20
.storeA0_b:
    STA    ram_A0

  ELSE
    lda    SWCHA                 ; 4
    sta    ram_A0                ; 3
  ENDIF

    lda    ram_ED                ; 3
    tax                          ; 2
    and    #$02                  ; 2
    beq    MF2BA                 ; 2³
    jmp    MF73E                 ; 3



MF2BA:
    txa                          ; 2
    and    #$01                  ; 2
    beq    MF2CE                 ; 2³
    lda    #$F0                  ; 2
    sta    ram_A0                ; 3
    txa                          ; 2
    and    #$10                  ; 2
    beq    MF2CB                 ; 2³
    jmp    MF94E                 ; 3

MF2CB:
    jmp    MFAD6                 ; 3

MF2CE:
    lda    ram_A1                ; 3
    bne    MF2DC                 ; 2³
    lda    SWCHB                 ; 4
    and    #$01                  ; 2  during game
    bne    MF2DC                 ; 2³

  IF CORRECT_SCANLINES
    STA    WSYNC
;---------------------------------------
    LDY    #PLAY_TO_TITLE_RESET
    JMP    DelayScanlines
  ELSE
    jmp    MF221                 ; 3
  ENDIF
    


MF2DC:
    lda    ram_ED                ; 3
    and    #$08                  ; 2
    beq    MF2E5                 ; 2³
    jmp    MFABE                 ; 3

MF2E5:
    ldx    ram_AE                ; 3
    beq    MF2EE                 ; 2³
    dec    ram_AE                ; 5
    jmp    MF300                 ; 3

MF2EE:
    lda    ram_A0                ; 3
    and    #$20                  ; 2
    bne    MF300                 ; 2³+1
    lda    #$30                  ; 2
    sta    ram_AE                ; 3
    eor    ram_ED                ; 3
    sta    ram_ED                ; 3
    lda    #$F0                  ; 2
    sta    ram_A0                ; 3
MF300:
    lda    ram_A1                ; 3
    beq    MF30D                 ; 2³
    dec    ram_A1                ; 5
    lda    ram_BE                ; 3
    beq    MF333                 ; 2³
  IF SEGA_GENESIS
    BNE    MF327  ; always branch
  ELSE
    jmp    MF3CA                 ; 3
  ENDIF

MF30D:
    lda    #$20                  ; 2
    and    ram_ED                ; 3
    beq    MF320                 ; 2³
    lda    INPT4                 ; 3
    bmi    MF320                 ; 2³
    lda    #$20                  ; 2
    and    ram_AD                ; 3
    beq    MF340                 ; 2³
  IF SEGA_GENESIS
    BNE    MF327  ; always branch
  ELSE
    jmp    MF3CA                 ; 3
  ENDIF

MF320:
    lda    ram_BE                ; 3
    beq    MF32A                 ; 2³
    jsr    MFE1D                 ; 6
MF327:
    jmp    MF3CA                 ; 3

MF32A:
    lda    #$20                  ; 2
    and    ram_ED                ; 3
    beq    MF333                 ; 2³
    jmp    MF607                 ; 3

MF333:
    lda    ram_B9                ; 3
    beq    MF33D                 ; 2³
    lda    ram_A9                ; 3
    beq    MF33D                 ; 2³
    dec    ram_A9                ; 5
MF33D:
    jmp    MF674                 ; 3

MF340:
    ldx    ram_BE                ; 3
    beq    MF364                 ; 2³
    lda    ram_F2                ; 3
    bmi    MF34D                 ; 2³
    lda    ram_B9                ; 3
    jsr    MFE7D                 ; 6
MF34D:
    cpx    #$28                  ; 2
    bmi    MF357                 ; 2³
    jsr    MFE1D                 ; 6
    jmp    MF3F0                 ; 3

MF357:
    inx                          ; 2
    stx    ram_BE                ; 3
    clc                          ; 2
    lda    ram_BF                ; 3
    adc    #$05                  ; 2
    sta    ram_BF                ; 3
    jmp    MF3F0                 ; 3

MF364:
    lda    ram_B9                ; 3
    clc                          ; 2
    adc    #$0A                  ; 2
    sta    ram_BF                ; 3

  IF SEGA_GENESIS
    INC    ram_B9
    INC    ram_B9
    INC    ram_B9
  ELSE
    clc                          ; 2
    lda    ram_B9                ; 3
    adc    #$03                  ; 2
    sta    ram_B9                ; 3
  ENDIF

    lda    ram_F2                ; 3
    bmi    MF37E                 ; 2³
    lda    ram_B9                ; 3
    jsr    MFE7D                 ; 6
    jsr    MFE86                 ; 6
MF37E:
    lda    #$01                  ; 2
    sta    ram_BE                ; 3
    lda    ram_93                ; 3
    ora    #$80                  ; 2
    sta    ram_93                ; 3
    lda    ram_A0                ; 3
    and    #$40                  ; 2
    beq    MF398                 ; 2³
    lda    ram_A0                ; 3
    bpl    MF3AC                 ; 2³
MF392:
    jsr    MFE0A                 ; 6
    jmp    MF674                 ; 3

MF398:
    lda    ram_B3                ; 3
    bmi    MF3A3                 ; 2³
    ora    #$80                  ; 2
    sta    ram_B3                ; 3
  IF SEGA_GENESIS
    BMI    MF392  ; always branch
  ELSE
    jmp    MF392                 ; 3
  ENDIF

MF3A3:
    jsr    MFE16                 ; 6
MF3A6:
    jsr    MFDD1                 ; 6
    jmp    MF674                 ; 3

MF3AC:
    lda    ram_B3                ; 3
    bpl    MF3B7                 ; 2³
    and    #$7F                  ; 2
    sta    ram_B3                ; 3
  IF SEGA_GENESIS
    BPL    MF392  ; always branch
  ELSE
    jmp    MF392                 ; 3
  ENDIF

MF3B7:
    jsr    MFE16                 ; 6
MF3BA:
    lda    ram_B3                ; 3
    clc                          ; 2
    adc    #$01                  ; 2
    cmp    #$77                  ; 2
    bmi    MF3C5                 ; 2³
    lda    #$77                  ; 2
MF3C5:
    sta    ram_B3                ; 3
    jmp    MF674                 ; 3

MF3CA:
    lda    ram_F2                ; 3
    bmi    MF3DD                 ; 2³
    lda    ram_B9                ; 3
    jsr    MFE7D                 ; 6
    lda    ram_A9                ; 3
    beq    MF3DD                 ; 2³
    cmp    #$F0                  ; 2
    beq    MF3DD                 ; 2³
    dec    ram_A9                ; 5
MF3DD:
    lda    ram_93                ; 3
    bmi    MF3E4                 ; 2³
  IF SEGA_GENESIS
    BPL    MF3ED  ; always branch
  ELSE
    jmp    MF54F                 ; 3
  ENDIF

MF3E4:
    lda    ram_B9                ; 3
    cmp    ram_BF                ; 3
    bmi    MF3F0                 ; 2³
    jsr    MFE0F                 ; 6
MF3ED:
    jmp    MF54F                 ; 3

MF3F0:
    lda    ram_B9                ; 3
    cmp    #$7E                  ; 2
    bmi    MF3F9                 ; 2³
    jmp    MF49C                 ; 3

MF3F9:
    lda    ram_93                ; 3
    and    #$40                  ; 2
    beq    MF40F                 ; 2³+1
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    bne    MF408                 ; 2³
  IF CORRECT_SCANLINES
    BEQ    MF484  ; always branch
  ELSE
    jmp    MF484                 ; 3
  ENDIF

MF408:
    cmp    #$77                  ; 2
    bmi    MF40F                 ; 2³
  IF SEGA_GENESIS
    BPL    MF45B  ; always branch
  ELSE
    jmp    MF45B                 ; 3
  ENDIF

MF40F:
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    cmp    #$2C                  ; 2
    bmi    MF42B                 ; 2³
    cmp    #$4C                  ; 2
    bpl    MF42B                 ; 2³
    lda    ram_B9                ; 3
    ldx    ram_80                ; 3
    cmp    MFECD,X               ; 4
    bmi    MF42B                 ; 2³
    cmp    MFEC4,X               ; 4
    beq    MF42E                 ; 2³
    bmi    MF42E                 ; 2³
MF42B:
    jmp    MF43B                 ; 3

MF42E:
    lda    #$7F                  ; 2
    sta    ram_A1                ; 3
    jsr    MFE0A                 ; 6
    jsr    MFE0F                 ; 6
    jmp    MF588                 ; 3

MF43B:
    lda    ram_B9                ; 3
    clc                          ; 2
    adc    #$03                  ; 2
    cmp    #$7E                  ; 2
    bmi    MF446                 ; 2³
    lda    #$7E                  ; 2
MF446:
    sta    ram_B9                ; 3
MF448:
    lda    ram_93                ; 3
    and    #$40                  ; 2
    bne    MF451                 ; 2³
    jmp    MF674                 ; 3

MF451:
    lda    ram_B3                ; 3
    bmi    MF458                 ; 2³
    jmp    MF3BA                 ; 3

MF458:
    jmp    MF3A6                 ; 3

MF45B:
    lda    ram_B3                ; 3
    bpl    MF466                 ; 2³
MF45F:
    lda    ram_93                ; 3
    bmi    MF43B                 ; 2³
    jmp    MF588                 ; 3

MF466:
    ldx    ram_80                ; 3
    lda    MFEEA,X               ; 4
    jsr    MFE24                 ; 6
    beq    MF473                 ; 2³
MF470:
  IF SEGA_GENESIS
    BNE    MF42E  ;always branch
  ELSE
    jmp    MF42E                 ; 3
  ENDIF

MF473:
    sta    ram_B3                ; 3
    ldx    ram_80                ; 3
    inx                          ; 2
MF478:
    stx    ram_80                ; 3
    stx    ram_B2                ; 3
    lda    #$40                  ; 2
    jsr    MFDE8                 ; 6
    jmp    MF45F                 ; 3

MF484:
    lda    ram_B3                ; 3
    bpl    MF45F                 ; 2³
    ldx    ram_80                ; 3
    lda    MFEE9,X               ; 4
    jsr    MFE24                 ; 6
    bne    MF470                 ; 2³
  IF SEGA_GENESIS
    LDX    ram_80
    DEX
    LDA    #$F7
    STA    ram_B3
    BNE    MF478  ; always branch
  ELSE
    lda    #$F7                  ; 2
    sta    ram_B3                ; 3
    ldx    ram_80                ; 3
    dex                          ; 2
    jmp    MF478                 ; 3
  ENDIF

MF49C:
    ldx    ram_80                ; 3
    cpx    #$01                  ; 2
    bne    MF519                 ; 2³+1
    ldx    #$09                  ; 2
    lda    MFEDF,X               ; 4
    jsr    MFE3C                 ; 6
    beq    MF4B9                 ; 2³
    ldx    #$01                  ; 2
    lda    MFEDF,X               ; 4
    jsr    MFE3C                 ; 6
    beq    MF4B9                 ; 2³
    jmp    MF42E                 ; 3

MF4B9:
    lda    ram_93                ; 3
    and    #$40                  ; 2
    bne    MF4C5                 ; 2³
    jsr    MFE0F                 ; 6
    jmp    MF588                 ; 3

MF4C5:
    lda    #$00                  ; 2
    sta    AUDV0                 ; 3
    lda    ram_93                ; 3
    and    #$20                  ; 2
    bne    MF4D2                 ; 2³
  IF SEGA_GENESIS
    BEQ    MF501  ; always branch
  ELSE
    jmp    MF501                 ; 3
  ENDIF

MF4D2:
    lda    ram_DD                ; 3
    sta    ram_80                ; 3
    lda    #$16                  ; 2
    sta    ram_ED                ; 3
  IF SEGA_GENESIS
    LDA    #FLASH_SCREEN_TIME  ; #$B4
    STA    ram_CA
    STA    ram_EE
    LDA    #$06
    STA    AUDC0
    LDA    #$07
    STA    AUDF0
    AND    ram_C0
    STA    ram_C0

  ELSE
    lda    #$07                  ; 2
    and    ram_C0                ; 3
    sta    ram_C0                ; 3
    lda    #FLASH_SCREEN_TIME  ; #$B4
    sta    ram_CA                ; 3
    sta    ram_EE                ; 3
    lda    #$06                  ; 2
    sta    AUDC0                 ; 3
    lda    #$07                  ; 2
    sta    AUDF0                 ; 3
  ENDIF
    lda    ram_93                ; 3
    and    #$0F                  ; 2
    sta    ram_CC                ; 3
    cmp    #$08                  ; 2
    bpl    MF4FA                 ; 2³
    inc    ram_93                ; 5
MF4FA:
    lda    #$00                  ; 2
    sta    ram_CB                ; 3
  IF SEGA_GENESIS
    BEQ    MF505  ; always branch
  ELSE
    jmp    MF505                 ; 3
  ENDIF

MF501:
    lda    #$12                  ; 2
    sta    ram_ED                ; 3
MF505:
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    cmp    #$3C                  ; 2
    bpl    MF512                 ; 2³
    lda    #$08                  ; 2
  IF SEGA_GENESIS
    .byte $0C  ; NOP, skip 2 bytes
  ELSE
    jmp    MF514                 ; 3
  ENDIF

MF512:
    lda    #$E8                  ; 2
MF514:
    sta    ram_B3                ; 3
    jmp    MF73E                 ; 3

MF519:
    lda    MFEDF,X               ; 4
    jsr    MFE3C                 ; 6
    beq    MF524                 ; 2³
    jmp    MF42E                 ; 3

MF524:
    lda    ram_93                ; 3
    and    #$40                  ; 2
    bne    MF533                 ; 2³
    lda    ram_AD                ; 3
    ora    #$08                  ; 2
    sta    ram_AD                ; 3
  IF CORRECT_SCANLINES
    BNE    MF538  ; always branch
  ELSE
    jmp    MF538                 ; 3
  ENDIF

MF533:
    lda    #$40                  ; 2
    jsr    MFDE8                 ; 6
MF538:
    lda    ram_80                ; 3
    sec                          ; 2
    sbc    #$03                  ; 2
    sta    ram_80                ; 3
    sta    ram_B2                ; 3
    lda    #$00                  ; 2
    sta    ram_B9                ; 3
    lda    ram_BF                ; 3
    sec                          ; 2
    sbc    #$7E                  ; 2
    sta    ram_BF                ; 3
    jmp    MF448                 ; 3

MF54F:
    lda    ram_B9                ; 3
    bne    MF556                 ; 2³
    jmp    MF5D8                 ; 3

MF556:
    lda    ram_93                ; 3
    and    #$40                  ; 2
    beq    MF56C                 ; 2³
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    bne    MF565                 ; 2³
    jmp    MF484                 ; 3

MF565:
    cmp    #$77                  ; 2
    bmi    MF56C                 ; 2³
    jmp    MF45B                 ; 3

MF56C:
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    cmp    #$2C                  ; 2
    bmi    MF588                 ; 2³
    cmp    #$4C                  ; 2
    bpl    MF588                 ; 2³
    ldx    ram_80                ; 3
    lda    MFEC4,X               ; 4
    cmp    ram_B9                ; 3
    bmi    MF588                 ; 2³
    sec                          ; 2
    sbc    #$03                  ; 2
    cmp    ram_B9                ; 3
    bmi    MF596                 ; 2³
MF588:
    lda    ram_B9                ; 3
    sec                          ; 2
    sbc    #$03                  ; 2
    bpl    MF591                 ; 2³
    lda    #$00                  ; 2
MF591:
  IF CORRECT_SCANLINES
    JMP    MF602
  ELSE
    sta    ram_B9                ; 3
    jmp    MF448                 ; 3
  ENDIF

MF596:
    ldx    ram_80                ; 3
    lda    MFEC4,X               ; 4
    clc                          ; 2
    adc    #$04                  ; 2
    sta    ram_B9                ; 3
    jsr    MFE5F                 ; 6
    lda    ram_B1                ; 3
    and    #$0F                  ; 2
    cmp    ram_80                ; 3
    bne    MF5BC                 ; 2³
    lda    ram_93                ; 3
    and    #$20                  ; 2
    bne    MF5BC                 ; 2³
    lda    ram_93                ; 3
    ora    #$20                  ; 2
    sta    ram_93                ; 3
    lda    ram_F0                ; 3
    jsr    MFDE1                 ; 6
MF5BC:
    lda    ram_C0                ; 3
    and    #$40                  ; 2
    bne    MF5CD                 ; 2³
    lda    #$40                  ; 2
    jsr    MFDE8                 ; 6
    lda    ram_C0                ; 3
    ora    #$40                  ; 2
    sta    ram_C0                ; 3
MF5CD:
    lda    #$F0                  ; 2
    cmp    ram_A9                ; 3
    bne    MF5D5                 ; 2³
    dec    ram_A9                ; 5
MF5D5:
    jmp    MF674                 ; 3

MF5D8:
    ldx    ram_80                ; 3
    lda    MFED6,X               ; 4
    jsr    MFE3C                 ; 6
    beq    MF5EB                 ; 2³
    jsr    MFE5F                 ; 6
    jsr    MFE93                 ; 6
    jmp    MF674                 ; 3

MF5EB:
    lda    ram_AD                ; 3
    and    #$08                  ; 2
    beq    MF5F7                 ; 2³
    lda    ram_AD                ; 3
    ora    #$04                  ; 2
    sta    ram_AD                ; 3
MF5F7:
    lda    ram_80                ; 3
    clc                          ; 2
    adc    #$03                  ; 2
    sta    ram_80                ; 3
    sta    ram_B2                ; 3
    lda    #$7E                  ; 2
MF602:
    sta    ram_B9                ; 3
    jmp    MF448                 ; 3

MF607:
    lda    ram_A0                ; 3
    bpl    MF642                 ; 2³
    and    #$40                  ; 2
    beq    MF612                 ; 2³
    jmp    MF333                 ; 3

MF612:
    lda    ram_B3                ; 3
    bmi    MF61D                 ; 2³
    ora    #$80                  ; 2
    sta    ram_B3                ; 3
    jmp    MF333                 ; 3

MF61D:
    jsr    MFDD1                 ; 6
    lda    ram_B9                ; 3
    beq    MF662                 ; 2³
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    cmp    #$2C                  ; 2
    bpl    MF662                 ; 2³
MF62C:
    jsr    MFE93                 ; 6
    jsr    MFE16                 ; 6
    lda    #$01                  ; 2
    sta    ram_BE                ; 3
    jsr    MFE1D                 ; 6
    jsr    MFE0F                 ; 6
    jsr    MFE86                 ; 6
    jmp    MF588                 ; 3

MF642:
    lda    ram_B3                ; 3
    bpl    MF64D                 ; 2³
    and    #$7F                  ; 2
    sta    ram_B3                ; 3
    jmp    MF333                 ; 3

MF64D:
    clc                          ; 2
    adc    #$01                  ; 2
    cmp    #$77                  ; 2
    bmi    MF656                 ; 2³
    lda    #$77                  ; 2
MF656:
    sta    ram_B3                ; 3
    lda    ram_B9                ; 3
    beq    MF662                 ; 2³
    lda    #$4C                  ; 2
    cmp    ram_B3                ; 3
    bmi    MF62C                 ; 2³
MF662:
    jsr    MFE16                 ; 6
    lda    ram_DD                ; 3
    and    #$03                  ; 2
    bne    MF671                 ; 2³
    lda    ram_DC                ; 3
    eor    #$80                  ; 2
    sta    ram_DC                ; 3
MF671:
    jmp    MF333                 ; 3

MF674:
    lda    ram_ED                ; 3
    and    #$20                  ; 2
    beq    MF6B8                 ; 2³
    lda    ram_BE                ; 3
    beq    MF68B                 ; 2³
MF67E:
    ldx    #$17                  ; 2
    ldy    #$FC                  ; 2
MF682:
    jsr    MFB20                 ; 6
MF685:
    jsr    MFB39                 ; 6
    jmp    MF6B8                 ; 3

MF68B:
    lda    ram_A1                ; 3
    bne    MF6A6                 ; 2³
    lda    ram_B9                ; 3
    bne    MF6A0                 ; 2³
    ldx    #$B0                  ; 2
    ldy    #$FE                  ; 2
    jsr    MFB20                 ; 6
    jsr    MFDFC                 ; 6
    jmp    MF685                 ; 3

MF6A0:
    jsr    MFDFC                 ; 6
    jmp    MF682                 ; 3

MF6A6:
    lda    ram_B9                ; 3
    bne    MF67E                 ; 2³
    ldx    #$B0                  ; 2
    ldy    #$FE                  ; 2
    jsr    MFB20                 ; 6
    ldx    #$17                  ; 2
    ldy    #$FC                  ; 2
    jmp    MF685                 ; 3

MF6B8:
    lda    ram_A8                ; 3
    beq    MF6D0                 ; 2³
    dec    ram_A8                ; 5
    ldx    #$00                  ; 2
    jsr    MFCB1                 ; 6
    ldx    #$05                  ; 2
    jsr    MFCB1                 ; 6
    ldx    #$0A                  ; 2
    jsr    MFCB1                 ; 6
    jmp    MF73A                 ; 3

MF6D0:
    ldx    #$00                  ; 2
    lda    ram_80                ; 3
    cmp    #$03                  ; 2
    bpl    MF6FB                 ; 2³
    lda    ram_A9                ; 3
    bne    MF6E2                 ; 2³
    jsr    MFCE0                 ; 6
    jmp    MF6E8                 ; 3

MF6E2:
    jsr    MFCC0                 ; 6
    jsr    MFC18                 ; 6
MF6E8:
    lda    ram_E0,X              ; 4
    and    #$7F                  ; 2
    sta    ram_D3                ; 3
    ldx    #$05                  ; 2
    jsr    MFC18                 ; 6
MF6F3:
    ldx    #$0A                  ; 2
    jsr    MFC18                 ; 6
    jmp    MF73A                 ; 3

MF6FB:
    jsr    MFCAB                 ; 6
    ldx    #$05                  ; 2
    lda    ram_80                ; 3
    cmp    #$06                  ; 2
    bpl    MF71F                 ; 2³
    lda    ram_A9                ; 3
    bne    MF710                 ; 2³
    jsr    MFCE0                 ; 6
    jmp    MF716                 ; 3

MF710:
    jsr    MFCC0                 ; 6
    jsr    MFC18                 ; 6
MF716:
    lda    ram_E0,X              ; 4
    and    #$7F                  ; 2
    sta    ram_D3                ; 3
    jmp    MF6F3                 ; 3

MF71F:
    jsr    MFCAB                 ; 6
    ldx    #$0A                  ; 2
    lda    ram_A9                ; 3
    bne    MF72E                 ; 2³
    jsr    MFCE0                 ; 6
    jmp    MF734                 ; 3

MF72E:
    jsr    MFCC0                 ; 6
    jsr    MFC18                 ; 6
MF734:
    lda    ram_E0,X              ; 4
    and    #$7F                  ; 2
    sta    ram_D3                ; 3
MF73A:
    lda    ram_B6                ; 3
    sta    ram_D6                ; 3
MF73E:
    lda    ram_ED                ; 3
    and    #$01                  ; 2
    beq    MF747                 ; 2³
    jmp    MF945                 ; 3

MF747:
    ldx    ram_DD                ; 3
    beq    MF74F                 ; 2³
    cpx    #$C8                  ; 2
    bne    MF755                 ; 2³
MF74F:
    lda    ram_AC                ; 3
    eor    #$80                  ; 2
    sta    ram_AC                ; 3
MF755:
    txa                          ; 2
    and    #$07                  ; 2
    bne    MF779                 ; 2³
    lda    ram_AC                ; 3
    bmi    MF768                 ; 2³
    clc                          ; 2
    adc    #$02                  ; 2
    cmp    #$77                  ; 2
    bmi    MF771                 ; 2³
    jmp    MF76F                 ; 3

MF768:
    and    #$7F                  ; 2
    sec                          ; 2
    sbc    #$02                  ; 2
    beq    MF771                 ; 2³
MF76F:
    eor    #$80                  ; 2
MF771:
    sta    ram_AC                ; 3
    lda    ram_DC                ; 3
    eor    #$20                  ; 2
    sta    ram_DC                ; 3
MF779:
    lda    #$20                  ; 2
    and    ram_C0                ; 3
    bne    MF7C9                 ; 2³
    lda    ram_DD                ; 3
    beq    MF786                 ; 2³
    jmp    MF800                 ; 3

MF786:
    lda    ram_C0                ; 3
    and    #$07                  ; 2
    cmp    #$01                  ; 2
    beq    MF791                 ; 2³
    jmp    MF800                 ; 3

MF791:
    lda    #$20                  ; 2
    ora    ram_C0                ; 3
    sta    ram_C0                ; 3
    lda    #$03                  ; 2
    sta    AUDC1                 ; 3
    lda    #$0D                  ; 2
    sta    AUDF1                 ; 3
    lda    #$08                  ; 2
    sta    AUDV1                 ; 3
    lda    #$3C                  ; 2
    sta    ram_EF                ; 3
    lda    #$46                  ; 2
    sta    ram_B5                ; 3
    lda    ram_AC                ; 3
    bmi    MF7B8                 ; 2³
    lda    #$78                  ; 2
    sta    ram_B4                ; 3
    lda    #$05                  ; 2
  IF CORRECT_SCANLINES
    BNE    MF7BC
  ELSE
    jmp    MF7BC                 ; 3
  ENDIF

MF7B8:
    lda    #$00                  ; 2
    sta    ram_B4                ; 3
MF7BC:
    sta    ram_A5                ; 3
  IF CORRECT_SCANLINES
    JMP    MF7F8
  ELSE
    lda    #$F0                  ; 2
    and    ram_C1                ; 3
    ora    ram_A5                ; 3
    sta    ram_C1                ; 3
    jmp    MF800                 ; 3
  ENDIF

MF7C9:
    lda    #$07                  ; 2
    and    ram_DD                ; 3
    bne    MF7D5                 ; 2³
    lda    #$40                  ; 2
    eor    ram_DC                ; 3
    sta    ram_DC                ; 3
MF7D5:
    lda    #$03                  ; 2
    and    ram_DD                ; 3
    bne    MF800                 ; 2³+1
    lda    #$0F                  ; 2
    and    ram_C1                ; 3
    tax                          ; 2
    clc                          ; 2
    lda    ram_B5                ; 3
    adc    MFF38,X               ; 4
    sta    ram_B5                ; 3
    clc                          ; 2
    lda    ram_B4                ; 3
    adc    MFF2E,X               ; 4
    sta    ram_B4                ; 3
    cmp    MFF42,X               ; 4
    bne    MF800                 ; 2³+1
    inx                          ; 2
    stx    ram_A5                ; 3
MF7F8:
    lda    #$F0                  ; 2
    and    ram_C1                ; 3
    ora    ram_A5                ; 3
    sta    ram_C1                ; 3
MF800:
    lda    #$10                  ; 2
    and    ram_C0                ; 3
    bne    MF809                 ; 2³
    jmp    MF886                 ; 3

MF809:
    lda    #$03                  ; 2
    and    ram_DD                ; 3
    bne    MF815                 ; 2³
    lda    ram_C0                ; 3
    eor    #$08                  ; 2
    sta    ram_C0                ; 3
MF815:
    lda    #$70                  ; 2
    and    ram_C1                ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    clc                          ; 2
    lda    ram_BB                ; 3
    adc    #$01                  ; 2
    sta    ram_BB                ; 3
    clc                          ; 2
    lda    ram_BA                ; 3
    adc    MFFE2,X               ; 4
    sta    ram_BA                ; 3
    cmp    MFFE9,X               ; 4
    bne    MF842                 ; 2³
    inx                          ; 2
    txa                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    ram_A5                ; 3
    lda    #$8F                  ; 2
    and    ram_C1                ; 3
    ora    ram_A5                ; 3
    sta    ram_C1                ; 3
MF842:
    lda    #$20                  ; 2
    and    ram_C0                ; 3
    bne    MF84B                 ; 2³
    jmp    MF933                 ; 3

MF84B:
    sec                          ; 2
    lda    ram_B4                ; 3
    sbc    ram_BA                ; 3
    bpl    MF854                 ; 2³
    eor    #$FF                  ; 2
MF854:
    cmp    #$07                  ; 2
    bmi    MF85B                 ; 2³
MF858:
    jmp    MF933                 ; 3

MF85B:
    sec                          ; 2
    lda    ram_B5                ; 3
    sbc    ram_BB                ; 3
    bpl    MF864                 ; 2³
    eor    #$FF                  ; 2
MF864:
    cmp    #$07                  ; 2
    bpl    MF858                 ; 2³
    lda    #$01                  ; 2
    jsr    MFDE1                 ; 6
    lda    #$CF                  ; 2
    and    ram_C0                ; 3
    sta    ram_C0                ; 3
    lda    #$03                  ; 2
    sta    AUDC1                 ; 3
    lda    #$03                  ; 2
    sta    AUDF1                 ; 3
    lda    #$05                  ; 2
    sta    AUDV1                 ; 3
    lda    #$3C                  ; 2
    sta    ram_EF                ; 3
    jmp    MF945                 ; 3

MF886:
    lda    #$10                  ; 2
    and    ram_ED                ; 3
    bne    MF88F                 ; 2³
MF88C:
    jmp    MF8F0                 ; 3

MF88F:
    lda    ram_ED                ; 3
    and    #$04                  ; 2
    bne    MF88C                 ; 2³
    lda    INPT4                 ; 3
    bpl    MF89C                 ; 2³
    jmp    MF8F0                 ; 3

MF89C:
    lda    #$10                  ; 2
    ora    ram_C0                ; 3
    sta    ram_C0                ; 3
    lda    #$08                  ; 2
    sta    AUDC1                 ; 3
    lda    #$1F                  ; 2
    sta    AUDF1                 ; 3
    lda    #$04                  ; 2
    sta    AUDV1                 ; 3
    lda    #$46                  ; 2
    sta    ram_EF                ; 3
    bit    ram_A0                ; 3
    bpl    MF8D3                 ; 2³
    bvc    MF8CA                 ; 2³
    lda    #$10                  ; 2
    and    ram_A0                ; 3
    beq    MF8DC                 ; 2³
    lda    #$10                  ; 2
    and    ram_AD                ; 3
    beq    MF8DC                 ; 2³
    lda    #$10                  ; 2
    and    ram_93                ; 3
    beq    MF8D3                 ; 2³
MF8CA:
    lda    #$2D                  ; 2
    sta    ram_BA                ; 3
    lda    #$40                  ; 2
    jmp    MF8E2                 ; 3

MF8D3:
    lda    #$4E                  ; 2
    sta    ram_BA                ; 3
    lda    #$10                  ; 2
    jmp    MF8E2                 ; 3

MF8DC:
    lda    #$3C                  ; 2
    sta    ram_BA                ; 3
    lda    #$00                  ; 2
MF8E2:
    sta    ram_A5                ; 3
    lda    #$8F                  ; 2
    and    ram_C1                ; 3
    ora    ram_A5                ; 3
    sta    ram_C1                ; 3
    lda    #$00                  ; 2
    sta    ram_BB                ; 3
MF8F0:
    lda    #$20                  ; 2
    and    ram_C0                ; 3
    bne    MF8F9                 ; 2³
    jmp    MF945                 ; 3

MF8F9:
    ldx    ram_B5                ; 3
    cpx    #$04                  ; 2
    beq    MF902                 ; 2³+1
    jmp    MF945                 ; 3

MF902:
    lda    #$0F                  ; 2
    and    ram_93                ; 3
    sec                          ; 2
    sbc    #$01                  ; 2
    sta    ram_A5                ; 3
    lda    #$F0                  ; 2
    and    ram_93                ; 3
    ora    ram_A5                ; 3
    sta    ram_93                ; 3
    lda    ram_A5                ; 3
    bne    MF91A                 ; 2³
    jmp    MFABE                 ; 3

MF91A:
    lda    #$DF                  ; 2
    and    ram_C0                ; 3
    sta    ram_C0                ; 3
    lda    #$07                  ; 2
    sta    AUDC1                 ; 3
    lda    #$02                  ; 2
    sta    AUDF1                 ; 3
    lda    #$05                  ; 2
    sta    AUDV1                 ; 3
    lda    #$3C                  ; 2
    sta    ram_EF                ; 3
    jmp    MF945                 ; 3

MF933:
    ldx    ram_BB                ; 3
    cpx    #$46                  ; 2
    beq    MF93C                 ; 2³
    jmp    MF8F0                 ; 3

MF93C:
    lda    #$EF                  ; 2
    and    ram_C0                ; 3
    sta    ram_C0                ; 3
    jmp    MF8F0                 ; 3

MF945:
    lda    #$10                  ; 2
    and    ram_ED                ; 3
    bne    MF94E                 ; 2³
    jmp    MFABB                 ; 3

MF94E:
    lda    #$20                  ; 2
    and    ram_C0                ; 3
    bne    MF967                 ; 2³
    ldx    #$B0                  ; 2
    ldy    #$FE                  ; 2
    stx    ram_DE                ; 3
    sty    ram_DF                ; 3
    stx    ram_E3                ; 3
    sty    ram_E4                ; 3
    stx    ram_E8                ; 3
    sty    ram_E9                ; 3
    jmp    MFA0B                 ; 3

MF967:
    lda    #$40                  ; 2
    and    ram_DC                ; 3
    tax                          ; 2
    lda    ram_B5                ; 3
    cmp    #$3B                  ; 2
    bpl    MF9DA                 ; 2³
    ldy    #$B0                  ; 2
    sty    ram_DE                ; 3
    ldy    #$FE                  ; 2
    sty    ram_DF                ; 3
    cmp    #$19                  ; 2
    bpl    MF9A9                 ; 2³
    ldy    #$B0                  ; 2
    sty    ram_E3                ; 3
    ldy    #$FE                  ; 2
    sty    ram_E4                ; 3
MF986:
    sec                          ; 2
    cpx    #$00                  ; 2
    beq    MF99A                 ; 2³
    lda    #$51                  ; 2


  IF CORRECT_SCANLINES
    .byte $0C  ; NOP, skip 2 bytes
  ELSE
    sbc    ram_B5                ; 3
    sta    ram_E8                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
    sta    ram_E9                ; 3
    jmp    MFA0B                 ; 3
  ENDIF

MF99A:
    lda    #$24                  ; 2
    sbc    ram_B5                ; 3
    sta    ram_E8                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
    sta    ram_E9                ; 3
    jmp    MFA0B                 ; 3

MF9A9:
    sec                          ; 2
    cpx    #$00                  ; 2
    beq    MF9BD                 ; 2³
    lda    #$71                  ; 2
    sbc    ram_B5                ; 3
    sta    ram_E3                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
    sta    ram_E4                ; 3
    jmp    MF9C9                 ; 3

MF9BD:
    lda    #$44                  ; 2
    sbc    ram_B5                ; 3
    sta    ram_E3                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
    sta    ram_E4                ; 3
MF9C9:
    lda    ram_B5                ; 3
    cmp    #$23                  ; 2
    bmi    MF986                 ; 2³
MF9CF:
    ldy    #$B0                  ; 2
    sty    ram_E8                ; 3
    ldy    #$FE                  ; 2
    sty    ram_E9                ; 3
    jmp    MFA0B                 ; 3

MF9DA:
    sec                          ; 2
    cpx    #$00                  ; 2
    beq    MF9EE                 ; 2³
    lda    #$93                  ; 2
    sbc    ram_B5                ; 3
    sta    ram_DE                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
    sta    ram_DF                ; 3
    jmp    MF9FA                 ; 3

MF9EE:
    lda    #$66                  ; 2
    sbc    ram_B5                ; 3
    sta    ram_DE                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
    sta    ram_DF                ; 3
MF9FA:
    lda    ram_B5                ; 3
    cmp    #$46                  ; 2
    bmi    MF9A9                 ; 2³+1
    ldy    #$B0                  ; 2
    sty    ram_E3                ; 3
    ldy    #$FE                  ; 2
    sty    ram_E4                ; 3
    jmp    MF9CF                 ; 3

MFA0B:
    ldx    #$B0                  ; 2
    ldy    #$FE                  ; 2
    lda    #$10                  ; 2
    and    ram_C0                ; 3
    bne    MFA24                 ; 2³
    stx    ram_E1                ; 3
    sty    ram_E2                ; 3
    stx    ram_E6                ; 3
    sty    ram_E7                ; 3
    stx    ram_EB                ; 3
    sty    ram_EC                ; 3
    jmp    MFA7A                 ; 3

MFA24:
    lda    ram_BB                ; 3
    cmp    #$3B                  ; 2
    bpl    MFA60                 ; 2³
    stx    ram_E1                ; 3
    sty    ram_E2                ; 3
    cmp    #$19                  ; 2
    bpl    MFA46                 ; 2³
    stx    ram_E6                ; 3
    sty    ram_E7                ; 3
MFA36:
    sec                          ; 2
    lda    #$F7                  ; 2
    sbc    ram_BB                ; 3
    sta    ram_EB                ; 3
    lda    #$FE                  ; 2
    sbc    #$00                  ; 2
    sta    ram_EC                ; 3
    jmp    MFA7A                 ; 3

MFA46:
    sec                          ; 2
    lda    #$17                  ; 2
    sbc    ram_BB                ; 3
    sta    ram_E6                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
    sta    ram_E7                ; 3
    lda    ram_BB                ; 3
    cmp    #$1F                  ; 2
    bmi    MFA36                 ; 2³
MFA59:
    stx    ram_EB                ; 3
    sty    ram_EC                ; 3
    jmp    MFA7A                 ; 3

MFA60:
    sec                          ; 2
    lda    #$39                  ; 2
    sbc    ram_BB                ; 3
    sta    ram_E1                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
    sta    ram_E2                ; 3
    lda    ram_BB                ; 3
    cmp    #$42                  ; 2
    bmi    MFA46                 ; 2³
    stx    ram_E6                ; 3
    sty    ram_E7                ; 3
    jmp    MFA59                 ; 3

MFA7A:
    bit    ram_A0                ; 3
    bvc    MFA8F                 ; 2³
    bpl    MFA96                 ; 2³
    lda    #$10                  ; 2
    and    ram_A0                ; 3
    beq    MFAAD                 ; 2³
    lda    #$10                  ; 2
    and    ram_AD                ; 3
    beq    MFAAD                 ; 2³
    jmp    MFA9C                 ; 3

MFA8F:
    lda    #$10                  ; 2
    ora    ram_93                ; 3
    jmp    MFA9A                 ; 3

MFA96:
    lda    #$EF                  ; 2
    and    ram_93                ; 3
MFA9A:
    sta    ram_93                ; 3
MFA9C:
    lda    #$82                  ; 2
    sta    ram_D4                ; 3
    lda    #$FB                  ; 2
    sta    ram_D5                ; 3
    lda    #$10                  ; 2
    ora    ram_AD                ; 3
    sta    ram_AD                ; 3
    jmp    MFABB                 ; 3

MFAAD:
    lda    #$64                  ; 2
    sta    ram_D4                ; 3
    lda    #$FB                  ; 2
    sta    ram_D5                ; 3
    lda    #$EF                  ; 2
    and    ram_AD                ; 3
    sta    ram_AD                ; 3
MFABB:
    jmp    MFAD6                 ; 3

MFABE:
    lda    ram_ED                ; 3
    ora    #$09                  ; 2
    sta    ram_ED                ; 3
    lda    #$00                  ; 2
    sta    ram_EF                ; 3
    lda    #$01                  ; 2
    sta    AUDC0                 ; 3
    lda    #$06                  ; 2
    sta    AUDV0                 ; 3
    lda    #$FF                  ; 2
    sta    ram_A1                ; 3
    sta    ram_EE                ; 3
MFAD6:
  IF CORRECT_SCANLINES
    BIT    TIMINT
    BPL    MFAD6
  ELSE
    ldx    INTIM                 ; 4
    bne    MFAD6                 ; 2³
    stx    WSYNC                 ; 3
  ENDIF
;---------------------------------------
    jmp    MF1D0                 ; 3

  ;@240 on Tomarc playing screen, and Senta screen





MFAE0:
    rts                          ; 6

MFAE1:
    ldx    #TIM_5                ; 2
  IF CORRECT_SCANLINES
    LDA    #2
    STX    WSYNC
;---------------------------------------
    STA    VBLANK                ;@ line 241 title screen with score, need to start VBLANK here

  ELSE
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    VBLANK                ; 3   @ line 241 title screen with score, need to start VBLANK here
  ENDIF
  IF CORRECT_SCANLINES
    STX    TIM64T
  ELSE
    stx    TIM8T                 ; 4
  ENDIF
    inc    ram_DD                ; 5
    
  IF CORRECT_SCANLINES
    NOP  ; free bytes
    NOP
    NOP  ; free bytes
    NOP
  ELSE
    stx    WSYNC                 ; 3
    stx    WSYNC                 ; 3
  ENDIF
  
    ldx    #$02                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    VSYNC                 ; 3
    stx    WSYNC                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    ldx    #$00                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    VSYNC                 ; 3
    rts                          ; 6

    clc                          ; 2
    adc    #$50                  ; 2
    jmp    MFB0A                 ; 3

MFB07:
    clc                          ; 2
    adc    #$14                  ; 2
MFB0A:
    tax                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    ram_A5                ; 3
    txa                          ; 2
    adc    ram_A5                ; 3
    eor    #$07                  ; 2
    ror                          ; 2
    ror                          ; 2
    ror                          ; 2
    ror                          ; 2
    ror                          ; 2
    tax                          ; 2
    rol                          ; 2
    and    #$0F                  ; 2
    rts                          ; 6

MFB20:
    txa                          ; 2
    sec                          ; 2
    sbc    ram_B9                ; 3
    sta    ram_A6                ; 3
    tya                          ; 2
    sbc    #$00                  ; 2
    sta    ram_A7                ; 3
    lda    #$73                  ; 2
    sec                          ; 2
    sbc    ram_B9                ; 3
    sta    ram_AF                ; 3
    lda    #$FC                  ; 2
    sbc    #$00                  ; 2
    sta    ram_B0                ; 3
    rts                          ; 6

MFB39:
    lda    ram_B9                ; 3
    cmp    #$19                  ; 2
    bmi    MFB42                 ; 2³
    jmp    MFBA6                 ; 3

MFB42:
    clc                          ; 2
    adc    #$09                  ; 2
    sta    ram_9F                ; 3
    txa                          ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    sta    ram_B7                ; 3
    tya                          ; 2
    sbc    #$00                  ; 2
    sta    ram_B8                ; 3
    lda    #$73                  ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    sta    ram_BC                ; 3
    lda    #$FC                  ; 2
    sbc    #$00                  ; 2
    sta    ram_BD                ; 3
    lda    ram_B9                ; 3
    cmp    #$10                  ; 2
    bpl    MFBAE                 ; 2³


    clc                          ; 2
    adc    #$12                  ; 2
    sta    ram_9F                ; 3
    txa                          ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    sta    ram_C2                ; 3
    tya                          ; 2
    sbc    #$00                  ; 2
    sta    ram_C3                ; 3
    lda    #$73                  ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    sta    ram_C6                ; 3
    lda    #$FC                  ; 2
    sbc    #$00                  ; 2
    sta    ram_C7                ; 3
    lda    ram_B9                ; 3
    cmp    #$07                  ; 2
    bpl    MFBB6                 ; 2³

    clc                          ; 2
    adc    #$1B                  ; 2
    sta    ram_9F                ; 3
    txa                          ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    sta    ram_C4                ; 3
    tya                          ; 2
    sbc    #$00                  ; 2
    sta    ram_C5                ; 3
    lda    #$73                  ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    sta    ram_C8                ; 3
    lda    #$FC                  ; 2
    sbc    #$00                  ; 2
    sta    ram_C9                ; 3
    rts                          ; 6

MFBA6:
    lda    #$B0                  ; 2
    sta    ram_B7                ; 3
    lda    #$FE                  ; 2
    sta    ram_B8                ; 3
MFBAE:
    lda    #$B0                  ; 2
    sta    ram_C2                ; 3
    lda    #$FE                  ; 2
    sta    ram_C3                ; 3
MFBB6:
    lda    #$B0                  ; 2
    sta    ram_C4                ; 3
    lda    #$FE                  ; 2
    sta    ram_C5                ; 3
    rts                          ; 6

MFBBF:
    ldx    #$00                  ; 2
    stx    ram_DB                ; 3
    lda    ram_D6                ; 3
    beq    MFC13                 ; 2³+1
    lda    ram_B9                ; 3
    beq    MFC13                 ; 2³+1
    cmp    ram_D6                ; 3
    bmi    MFBF9                 ; 2³
    sec                          ; 2
    sbc    ram_D6                ; 3
    sta    ram_9F                ; 3
    cmp    #$19                  ; 2
    bpl    MFC13                 ; 2³+1
    cmp    #$0D                  ; 2
    bpl    MFBE8                 ; 2³
    lda    #$0D                  ; 2
    sta    ram_D9                ; 3
    lda    #$0C                  ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    sta    ram_DA                ; 3
    rts                          ; 6

MFBE8:
    inc    ram_DB                ; 5
    lda    #$19                  ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    sta    ram_D9                ; 3
    lda    ram_9F                ; 3
    sec                          ; 2
    sbc    #$0C                  ; 2
    sta    ram_DA                ; 3
    rts                          ; 6

MFBF9:
    lda    ram_D6                ; 3
    sec                          ; 2
    sbc    ram_B9                ; 3
    cmp    #$0D                  ; 2
    bpl    MFC13                 ; 2³
    sta    ram_9F                ; 3
    lda    #$0D                  ; 2
    sec                          ; 2
    sbc    ram_9F                ; 3
    sta    ram_D9                ; 3
    lda    #$0C                  ; 2
    clc                          ; 2
    adc    ram_9F                ; 3
    sta    ram_DA                ; 3
    rts                          ; 6

MFC13:
    stx    ram_D9                ; 3
    stx    ram_DA                ; 3
    rts                          ; 6

MFC18:
    lda    ram_E0,X              ; 4
    cmp    #$FF                  ; 2
    bne    MFC29                 ; 2³
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    cmp    #$3C                  ; 2
    bpl    MFC52                 ; 2³
    jmp    MFC63                 ; 3

MFC29:
    clc                          ; 2
    lda    ram_ED                ; 3
    and    #$01                  ; 2
    bne    MFC67                 ; 2³
    stx    ram_9F                ; 3
    lda    ram_AD                ; 3
    and    #$03                  ; 2
    adc    ram_9F                ; 3
    tay                          ; 2
    lda    ram_DD                ; 3
    and    MFF0B,Y               ; 4
    bne    MFC67                 ; 2³
    lda    ram_DC                ; 3
    eor    MFF1B,X               ; 4
    sta    ram_DC                ; 3
    lda    ram_E0,X              ; 4
    bpl    MFC5C                 ; 2³
    and    #$7F                  ; 2
    adc    MFF1A,X               ; 4
    bpl    MFC57                 ; 2³
MFC52:
    lda    #$00                  ; 2
    jmp    MFC65                 ; 3

MFC57:
    ora    #$80                  ; 2
    jmp    MFC65                 ; 3

MFC5C:
    adc    MFF19,X               ; 4
    cmp    #$77                  ; 2
    bmi    MFC65                 ; 2³
MFC63:
    lda    #$F7                  ; 2
MFC65:
    sta    ram_E0,X              ; 4
MFC67:
    lda    ram_ED                ; 3
    and    #$20                  ; 2
    beq    MFCAA                 ; 2³
    lda    #$08                  ; 2
    and    ram_AD                ; 3
    beq    MFC7E                 ; 2³
    lda    #$B0                  ; 2
    sta    ram_DE,X              ; 4
    lda    #$FE                  ; 2
    sta    ram_DF,X              ; 4
    jmp    MFC98                 ; 3

MFC7E:
    lda    ram_DC                ; 3
    and    MFF1B,X               ; 4
    bne    MFC90                 ; 2³
    lda    #$92                  ; 2
    sta    ram_DE,X              ; 4
    lda    #$FF                  ; 2
    sta    ram_DF,X              ; 4
    jmp    MFC98                 ; 3

MFC90:
    lda    #$A1                  ; 2
    sta    ram_DE,X              ; 4
    lda    #$FF                  ; 2
    sta    ram_DF,X              ; 4
MFC98:
    stx    ram_9F                ; 3
    ldy    ram_9F                ; 3
    lda    ram_E0,X              ; 4
    and    #$7F                  ; 2
    jsr    MFB07                 ; 6
    stx    $E2,Y                 ; 4
    sta.wy ram_E1,Y              ; 5
    ldx    ram_9F                ; 3
MFCAA:
    rts                          ; 6

MFCAB:
    lda    #$20                  ; 2
    and    ram_ED                ; 3
    beq    MFCBF                 ; 2³
MFCB1:
    lda    #$B0                  ; 2
    sta    ram_DE,X              ; 4
    lda    #$FE                  ; 2
    sta    ram_DF,X              ; 4
    lda    #$05                  ; 2
    sta    ram_E1,X              ; 4
    sta    ram_E2,X              ; 4
MFCBF:
    rts                          ; 6

MFCC0:
    lda    ram_AD                ; 3
    and    #$08                  ; 2
    bne    MFCCB                 ; 2³
    lda    #$00                  ; 2
    sta    ram_B6                ; 3
    rts                          ; 6

MFCCB:
    lda    ram_ED                ; 3
    and    #$20                  ; 2
    bne    MFCD2                 ; 2³
    rts                          ; 6

MFCD2:
    sec                          ; 2
    lda    #$B0                  ; 2
    sbc    ram_B6                ; 3
    sta    ram_AA                ; 3
    lda    #$FE                  ; 2
    sbc    #$00                  ; 2
    sta    ram_AB                ; 3
    rts                          ; 6

MFCE0:
    lda    #$08                  ; 2
    and    ram_AD                ; 3
    beq    MFCED                 ; 2³
    jsr    MFCC0                 ; 6
MFCE9:
    jsr    MFC18                 ; 6
    rts                          ; 6

MFCED:
    lda    ram_B1                ; 3
    bmi    MFD63                 ; 2³+1
    lda    ram_B6                ; 3
    beq    MFD27                 ; 2³+1
    ldy    ram_80                ; 3
    lda    MFEC4,Y               ; 4
    sec                          ; 2
    sbc    #$10                  ; 2
    cmp    ram_B6                ; 3
    beq    MFD51                 ; 2³
    bmi    MFD51                 ; 2³
    lda    ram_ED                ; 3
    and    #$01                  ; 2
    bne    MFD46                 ; 2³
    lda    ram_DD                ; 3
    and    #$07                  ; 2
    bne    MFD46                 ; 2³
    lda    ram_DC                ; 3
    eor    #$01                  ; 2
    sta    ram_DC                ; 3
    clc                          ; 2
    lda    #$02                  ; 2
    adc    ram_B6                ; 3
    sta    ram_B6                ; 3
    lda    #$07                  ; 2
    sta    AUDV0                 ; 3
    lda    #$03                  ; 2
    sta    ram_EE                ; 3
    jmp    MFD46                 ; 3

MFD27:
    lda    ram_E0,X              ; 4
    and    #$7F                  ; 2
    cmp    #$4D                  ; 2
    bmi    MFCE9                 ; 2³+1
    sec                          ; 2
    sbc    #$4C                  ; 2
    cmp    #$04                  ; 2
    bpl    MFCE9                 ; 2³+1
    lda    #$0D                  ; 2
    sta    ram_B6                ; 3
    lda    #$4F                  ; 2
    sta    ram_E0,X              ; 4
    lda    #$08                  ; 2
    sta    AUDC0                 ; 3
    lda    #$0E                  ; 2
    sta    AUDF0                 ; 3
MFD46:
    lda    #$80                  ; 2
    sta    ram_F2                ; 3
    lda    ram_ED                ; 3
    and    #$20                  ; 2
    bne    MFD80                 ; 2³
    rts                          ; 6

MFD51:
    lda    #$C8                  ; 2
    sta    ram_E0,X              ; 4
    lda    ram_B1                ; 3
    ora    #$80                  ; 2
    sta    ram_B1                ; 3
    lda    MFF02,Y               ; 4
    sta    ram_B6                ; 3
    jmp    MFDA4                 ; 3

MFD63:
    lda    ram_ED                ; 3
    and    #$01                  ; 2
    bne    MFDA4                 ; 2³
    lda    ram_DD                ; 3
    and    #$07                  ; 2
    bne    MFDA4                 ; 2³
    lda    ram_E0,X              ; 4
    bmi    MFD90                 ; 2³
    clc                          ; 2
    adc    MFF19,X               ; 4
    cmp    #$4A                  ; 2
    bmi    MFD9C                 ; 2³
    lda    #$C8                  ; 2
    jmp    MFD9C                 ; 3

MFD80:
    sec                          ; 2
    lda    #$91                  ; 2
    sbc    ram_B6                ; 3
    sta    ram_AA                ; 3
    lda    #$FF                  ; 2
    sbc    #$00                  ; 2
  IF CORRECT_SCANLINES
    JMP    MFDCB
  ELSE
    sta    ram_AB                ; 3
    jmp    MFDCD                 ; 3
  ENDIF

MFD90:
    and    #$7F                  ; 2
    clc                          ; 2
    adc    MFF1A,X               ; 4
    cmp    #$31                  ; 2
    bmi    MFD9C                 ; 2³
    ora    #$80                  ; 2
MFD9C:
    sta    ram_E0,X              ; 4
    lda    ram_DC                ; 3
    eor    #$10                  ; 2
    sta    ram_DC                ; 3
MFDA4:
    lda    #$00                  ; 2
    sta    ram_F2                ; 3
    lda    ram_ED                ; 3
    and    #$20                  ; 2
    bne    MFDAF                 ; 2³
    rts                          ; 6

MFDAF:
    sec                          ; 2
    lda    ram_DC                ; 3
    and    #$10                  ; 2
    beq    MFDC1                 ; 2³
    lda    #$AF                  ; 2
    sbc    ram_B6                ; 3
    sta    ram_AA                ; 3
    lda    #$FF                  ; 2
    jmp    MFDC9                 ; 3

MFDC1:
    lda    #$A0                  ; 2
    sbc    ram_B6                ; 3
    sta    ram_AA                ; 3
    lda    #$FF                  ; 2
MFDC9:
    sbc    #$00                  ; 2
MFDCB:
    sta    ram_AB                ; 3
MFDCD:
    jsr    MFCAB                 ; 6
    rts                          ; 6

MFDD1:
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    sec                          ; 2
    sbc    #$01                  ; 2
    bpl    MFDDC                 ; 2³
    lda    #$00                  ; 2
MFDDC:
    ora    #$80                  ; 2
    sta    ram_B3                ; 3
    rts                          ; 6

MFDE1:
    sed                          ; 2
    clc                          ; 2
    adc    ram_82                ; 3
    jmp    MFDF2                 ; 3

MFDE8:
    sed                          ; 2
    clc                          ; 2
    adc    ram_83                ; 3
    sta    ram_83                ; 3
    lda    ram_82                ; 3
    adc    #$00                  ; 2
MFDF2:
    sta    ram_82                ; 3
    lda    ram_81                ; 3
    adc    #$00                  ; 2
    sta    ram_81                ; 3
    cld                          ; 2
    rts                          ; 6

MFDFC:
  IF CORRECT_SCANLINES
    LDX    #$51
    LDA    ram_DC
    BMI    MFE05
    LDX    #$34
MFE05:
    LDY    #$FC
    RTS

  ELSE
    lda    ram_DC                ; 3
    bmi    MFE05                 ; 2³
    ldx    #$51                  ; 2
    ldy    #$FC                  ; 2
    rts                          ; 6

MFE05:
    ldx    #$34                  ; 2
    ldy    #$FC                  ; 2
    rts                          ; 6
  ENDIF



MFE0A:
    lda    #$BF                  ; 2
    jmp    MFE11                 ; 3

MFE0F:
    lda    #$7F                  ; 2
MFE11:
    and    ram_93                ; 3
MFE13:
    sta    ram_93                ; 3
    rts                          ; 6

MFE16:
    lda    #$40                  ; 2
    ora    ram_93                ; 3
  IF CORRECT_SCANLINES
    BNE    MFE13  ; always branch
  ELSE
    jmp    MFE13                 ; 3
  ENDIF

MFE1D:
    lda    #$20                  ; 2
    ora    ram_AD                ; 3
    sta    ram_AD                ; 3
    rts                          ; 6

MFE24:
    sta    ram_A5                ; 3
    lda    ram_AD                ; 3
    and    #$03                  ; 2
    tay                          ; 2
    lda    ram_A5                ; 3
    cmp    ram_B9                ; 3
    bmi    MFE5C                 ; 2³
    sec                          ; 2
    sbc    ram_B9                ; 3
    cmp    MFF27,Y               ; 4
  IF CORRECT_SCANLINES
    JMP    MFE57
  ELSE
    bpl    MFE5C                 ; 2³
    jmp    MFE59                 ; 3
  ENDIF

MFE3C:
    sta    ram_9F                ; 3
    lda    ram_AD                ; 3
    and    #$03                  ; 2
    tay                          ; 2
    lda    ram_B3                ; 3
    and    #$7F                  ; 2
    sta    ram_A5                ; 3
    lda    ram_9F                ; 3
    cmp    ram_A5                ; 3
    bpl    MFE5C                 ; 2³
    sec                          ; 2
    sbc    ram_A5                ; 3
    eor    #$FF                  ; 2
    cmp    MFF2A,Y               ; 4
MFE57:
    bpl    MFE5C                 ; 2³
MFE59:
    lda    #$00                  ; 2
    rts                          ; 6

MFE5C:
    lda    #$01                  ; 2
    rts                          ; 6

MFE5F:
    jsr    MFE0A                 ; 6
    lda    #$00                  ; 2
    sta    ram_BE                ; 3
    sta    ram_EE                ; 3
    lda    ram_DC                ; 3
    and    #$7F                  ; 2
    sta    ram_DC                ; 3
    lda    ram_AD                ; 3
    and    #$DF                  ; 2
    sta    ram_AD                ; 3
    lda    ram_A1                ; 3
    beq    MFE7C                 ; 2³
    lda    #$1E                  ; 2
    sta    ram_A1                ; 3
MFE7C:
    rts                          ; 6

MFE7D:
    lsr                          ; 2
    lsr                          ; 2
    eor    #$1F                  ; 2
    sta    AUDF0                 ; 3
    lda    ram_B9                ; 3
    rts                          ; 6

MFE86:
    lda    #$0C                  ; 2
    sta    AUDC0                 ; 3
    lda    #$04                  ; 2
    sta    AUDV0                 ; 3
    lda    #$FF                  ; 2
    sta    ram_EE                ; 3
    rts                          ; 6

MFE93:
    lda    #$F0                  ; 2
    sta    ram_A9                ; 3
    lda    ram_B1                ; 3
    and    #$7F                  ; 2
    sta    ram_B1                ; 3
    lda    #$00                  ; 2
    sta    ram_B6                ; 3
    sta    ram_F2                ; 3
    rts                          ; 6

    .byte $FF ; |XXXXXXXX| $FEA4
    .byte $FF ; |XXXXXXXX| $FEA5
    .byte $FE ; |XXXXXXX | $FEA6
    .byte $FE ; |XXXXXXX | $FEA7
    .byte $FF ; |XXXXXXXX| $FEA8
    .byte $FF ; |XXXXXXXX| $FEA9
    .byte $FE ; |XXXXXXX | $FEAA
    .byte $FE ; |XXXXXXX | $FEAB
    .byte $FF ; |XXXXXXXX| $FEAC
    .byte $FF ; |XXXXXXXX| $FEAD
    .byte $FE ; |XXXXXXX | $FEAE
    .byte $DE ; |XX XXXX | $FEAF
    .byte $FF ; |XXXXXXXX| $FEB0
    .byte $FF ; |XXXXXXXX| $FEB1
    .byte $FE ; |XXXXXXX | $FEB2
    .byte $FE ; |XXXXXXX | $FEB3
    .byte $FF ; |XXXXXXXX| $FEB4
    .byte $FF ; |XXXXXXXX| $FEB5
    .byte $FE ; |XXXXXXX | $FEB6
    .byte $FE ; |XXXXXXX | $FEB7
    .byte $FF ; |XXXXXXXX| $FEB8
    .byte $FF ; |XXXXXXXX| $FEB9
    .byte $FE ; |XXXXXXX | $FEBA
    .byte $FE ; |XXXXXXX | $FEBB
    .byte $FF ; |XXXXXXXX| $FEBC
    .byte $FF ; |XXXXXXXX| $FEBD
    .byte $FE ; |XXXXXXX | $FEBE
    .byte $DE ; |XX XXXX | $FEBF
    .byte $FF ; |XXXXXXXX| $FEC0
    .byte $FF ; |XXXXXXXX| $FEC1
    .byte $FE ; |XXXXXXX | $FEC2
    .byte $FE ; |XXXXXXX | $FEC3
MFEC4:
    .byte $48 ; | X  X   | $FEC4
    .byte $5B ; | X XX XX| $FEC5
    .byte $6D ; | XX XX X| $FEC6
    .byte $6D ; | XX XX X| $FEC7
    .byte $5B ; | X XX XX| $FEC8
    .byte $48 ; | X  X   | $FEC9
    .byte $5B ; | X XX XX| $FECA
    .byte $8C ; |X   XX  | $FECB
    .byte $48 ; | X  X   | $FECC
MFECD:
    .byte $2E ; |  X XXX | $FECD
    .byte $41 ; | X     X| $FECE
    .byte $53 ; | X X  XX| $FECF
    .byte $53 ; | X X  XX| $FED0
    .byte $41 ; | X     X| $FED1
    .byte $2E ; |  X XXX | $FED2
    .byte $41 ; | X     X| $FED3
    .byte $8C ; |X   XX  | $FED4
    .byte $2E ; |  X XXX | $FED5
MFED6:
    .byte $05 ; |     X X| $FED6
    .byte $65 ; | XX  X X| $FED7
    .byte $35 ; |  XX X X| $FED8
    .byte $05 ; |     X X| $FED9
    .byte $65 ; | XX  X X| $FEDA
    .byte $05 ; |     X X| $FEDB
    .byte $7F ; | XXXXXXX| $FEDC
    .byte $7F ; | XXXXXXX| $FEDD
    .byte $7F ; | XXXXXXX| $FEDE
MFEDF:
    .byte $7F ; | XXXXXXX| $FEDF
    .byte $05 ; |     X X| $FEE0
    .byte $7F ; | XXXXXXX| $FEE1
    .byte $05 ; |     X X| $FEE2
    .byte $65 ; | XX  X X| $FEE3
    .byte $35 ; |  XX X X| $FEE4
    .byte $05 ; |     X X| $FEE5
    .byte $65 ; | XX  X X| $FEE6
    .byte $05 ; |     X X| $FEE7
    .byte $65 ; | XX  X X| $FEE8
MFEE9:
    .byte $00 ; |        | $FEE9
MFEEA:
    .byte $73 ; | XXX  XX| $FEEA
    .byte $59 ; | X XX  X| $FEEB
    .byte $00 ; |        | $FEEC
    .byte $59 ; | X XX  X| $FEED
    .byte $73 ; | XXX  XX| $FEEE
    .byte $00 ; |        | $FEEF
    .byte $59 ; | X XX  X| $FEF0
    .byte $27 ; |  X  XXX| $FEF1
    .byte $00 ; |        | $FEF2
MFEF3:
    .byte $00 ; |        | $FEF3  ram_C0
    .byte $07 ; |     XXX| $FEF4
    .byte $05 ; |     X X| $FEF5
    .byte $03 ; |      XX| $FEF6
    .byte $00 ; |        | $FEF7
    .byte $00 ; |        | $FEF8
    .byte $3F ; |  XXXXXX| $FEF9
    .byte $3F ; |  XXXXXX| $FEFA
    .byte $3F ; |  XXXXXX| $FEFB
    .byte $DF ; |XX XXXXX| $FEFC
    .byte $DF ; |XX XXXXX| $FEFD
    .byte $DF ; |XX XXXXX| $FEFE
    .byte $8F ; |X   XXXX| $FEFF
    .byte $8F ; |X   XXXX| $FF00
    .byte $8F ; |X   XXXX| $FF01
MFF02:
    .byte $40 ; | X      | $FF02  ram_B6 and ram_D6
    .byte $53 ; | X X  XX| $FF03
    .byte $65 ; | XX  X X| $FF04
    .byte $65 ; | XX  X X| $FF05
    .byte $53 ; | X X  XX| $FF06
    .byte $40 ; | X      | $FF07
    .byte $53 ; | X X  XX| $FF08
    .byte $00 ; |        | $FF09
    .byte $40 ; | X      | $FF0A
MFF0B:
    .byte $00 ; |        | $FF0B
    .byte $07 ; |     XXX| $FF0C
    .byte $03 ; |      XX| $FF0D
    .byte $01 ; |       X| $FF0E
    .byte $00 ; |        | $FF0F
    .byte $00 ; |        | $FF10
    .byte $07 ; |     XXX| $FF11
    .byte $03 ; |      XX| $FF12
    .byte $01 ; |       X| $FF13
    .byte $00 ; |        | $FF14
    .byte $00 ; |        | $FF15
    .byte $0F ; |    XXXX| $FF16
    .byte $07 ; |     XXX| $FF17
    .byte $03 ; |      XX| $FF18
MFF19:
    .byte $02 ; |      X | $FF19
MFF1A:
    .byte $FE ; |XXXXXXX | $FF1A
MFF1B:
    .byte $02 ; |      X | $FF1B
    .byte $10 ; |   X    | $FF1C
    .byte $00 ; |        | $FF1D
    .byte $01 ; |       X| $FF1E
    .byte $FF ; |XXXXXXXX| $FF1F
    .byte $04 ; |     X  | $FF20
    .byte $20 ; |  X     | $FF21
    .byte $00 ; |        | $FF22
    .byte $01 ; |       X| $FF23
    .byte $FF ; |XXXXXXXX| $FF24
    .byte $08 ; |    X   | $FF25
    .byte $40 ; | X      | $FF26
MFF27:
    .byte $00 ; |        | $FF27
    .byte $18 ; |   XX   | $FF28
    .byte $10 ; |   X    | $FF29
MFF2A:
    .byte $0C ; |    XX  | $FF2A
    .byte $10 ; |   X    | $FF2B
    .byte $0C ; |    XX  | $FF2C
    .byte $0A ; |    X X | $FF2D
MFF2E:
    .byte  2  ; $FF2E
    .byte  2  ; $FF2F
    .byte -1  ; $FF30
    .byte -3  ; $FF31
    .byte  1  ; $FF32
    .byte -2  ; $FF33
    .byte -2  ; $FF34
    .byte  1  ; $FF35
    .byte  3  ; $FF36
    .byte -1  ; $FF37
MFF38:
    .byte -1  ; $FF38
    .byte  1  ; $FF39
    .byte -3  ; $FF3A
    .byte  1  ; $FF3B
    .byte -2  ; $FF3C
    .byte -1  ; $FF3D
    .byte  1  ; $FF3E
    .byte -3  ; $FF3F
    .byte  1  ; $FF40
    .byte -2  ; $FF41
MFF42:
    .byte $3C ; |  XXXX  | $FF42  CMP ram_B4
    .byte $78 ; | XXXX   | $FF43
    .byte $64 ; | XX  X  | $FF44
    .byte $28 ; |  X X   | $FF45
    .byte $35 ; |  XX X X| $FF46
    .byte $3C ; |  XXXX  | $FF47
    .byte $00 ; |        | $FF48
    .byte $14 ; |   X X  | $FF49
    .byte $50 ; | X X    | $FF4A
    .byte $43 ; | X    XX| $FF4B

MFF4C:
    .byte $02 ; |      X | $FF4C
    .byte $02 ; |      X | $FF4D
    .byte $01 ; |       X| $FF4E
    .byte $01 ; |       X| $FF4F
    .byte $00 ; |        | $FF50
    .byte $00 ; |        | $FF51
    .byte $00 ; |        | $FF52
    .byte $00 ; |        | $FF53
    .byte $00 ; |        | $FF54
    .byte $00 ; |        | $FF55
    .byte $01 ; |       X| $FF56
    .byte $01 ; |       X| $FF57
    .byte $02 ; |      X | $FF58
    .byte $02 ; |      X | $FF59
    .byte $00 ; |        | $FF5A
    .byte $00 ; |        | $FF5B
    .byte $00 ; |        | $FF5C
    .byte $01 ; |       X| $FF5D
    .byte $02 ; |      X | $FF5E
    .byte $02 ; |      X | $FF5F
    .byte $02 ; |      X | $FF60
    .byte $02 ; |      X | $FF61
    .byte $02 ; |      X | $FF62
    .byte $02 ; |      X | $FF63
    .byte $01 ; |       X| $FF64
MFF65:
    .byte $0C ; |    XX  | $FF65
    .byte $0D ; |    XX X| $FF66
    .byte $12 ; |   X  X | $FF67
    .byte $16 ; |   X XX | $FF68
    .byte $A5 ; |X X  X X| $FF69
    .byte $A5 ; |X X  X X| $FF6A
    .byte $44 ; | X   X  | $FF6B
    .byte $44 ; | X   X  | $FF6C
    .byte $A4 ; |X X  X  | $FF6D
    .byte $A4 ; |X X  X  | $FF6E
    .byte $14 ; |   X X  | $FF6F
    .byte $12 ; |   X  X | $FF70
    .byte $09 ; |    X  X| $FF71
    .byte $08 ; |    X   | $FF72
    .byte $00 ; |        | $FF73
    .byte $00 ; |        | $FF74
    .byte $00 ; |        | $FF75
    .byte $F0 ; |XXXX    | $FF76
    .byte $08 ; |    X   | $FF77
    .byte $E8 ; |XXX X   | $FF78
    .byte $88 ; |X   X   | $FF79
    .byte $88 ; |X   X   | $FF7A
    .byte $E8 ; |XXX X   | $FF7B
    .byte $08 ; |    X   | $FF7C
    .byte $F0 ; |XXXX    | $FF7D
MFF7E:
    .byte $84 ; |X    X  | $FF7E
    .byte $44 ; | X   X  | $FF7F
    .byte $24 ; |  X  X  | $FF80
    .byte $14 ; |   X X  | $FF81
    .byte $14 ; |   X X  | $FF82
    .byte $14 ; |   X X  | $FF83
    .byte $94 ; |X  X X  | $FF84
    .byte $94 ; |X  X X  | $FF85
    .byte $55 ; | X X X X| $FF86
    .byte $55 ; | X X X X| $FF87
    .byte $36 ; |  XX XX | $FF88
    .byte $26 ; |  X  XX | $FF89
    .byte $54 ; | X X X  | $FF8A
    .byte $8C ; |X   XX  | $FF8B
    .byte $00 ; |        | $FF8C
    .byte $00 ; |        | $FF8D
    .byte $00 ; |        | $FF8E
    .byte $7C ; | XXXXX  | $FF8F
    .byte $A2 ; |X X   X | $FF90
    .byte $A2 ; |X X   X | $FF91
    .byte $BA ; |X XXX X | $FF92
    .byte $AA ; |X X X X | $FF93
    .byte $BA ; |X XXX X | $FF94
    .byte $82 ; |X     X | $FF95
    .byte $7C ; | XXXXX  | $FF96
MFF97:
    .byte $18 ; |   XX   | $FF97
    .byte $15 ; |   X X X| $FF98
    .byte $32 ; |  XX  X | $FF99
    .byte $36 ; |  XX XX | $FF9A
    .byte $55 ; | X X X X| $FF9B
    .byte $55 ; | X X X X| $FF9C
    .byte $94 ; |X  X X  | $FF9D
    .byte $94 ; |X  X X  | $FF9E
    .byte $14 ; |   X X  | $FF9F
    .byte $14 ; |   X X  | $FFA0
    .byte $14 ; |   X X  | $FFA1
    .byte $12 ; |   X  X | $FFA2
    .byte $11 ; |   X   X| $FFA3
    .byte $10 ; |   X    | $FFA4
    .byte $00 ; |        | $FFA5
    .byte $00 ; |        | $FFA6
    .byte $00 ; |        | $FFA7
    .byte $1C ; |   XXX  | $FFA8
    .byte $08 ; |    X   | $FFA9
    .byte $08 ; |    X   | $FFAA
    .byte $08 ; |    X   | $FFAB
    .byte $09 ; |    X  X| $FFAC
    .byte $0A ; |    X X | $FFAD
    .byte $1A ; |   XX X | $FFAE
    .byte $09 ; |    X  X| $FFAF
MFFB0:
    .byte $88 ; |X   X   | $FFB0
    .byte $48 ; | X  X   | $FFB1
    .byte $24 ; |  X  X  | $FFB2
    .byte $14 ; |   X X  | $FFB3
    .byte $12 ; |   X  X | $FFB4
    .byte $12 ; |   X  X | $FFB5
    .byte $91 ; |X  X   X| $FFB6
    .byte $91 ; |X  X   X| $FFB7
    .byte $52 ; | X X  X | $FFB8
    .byte $52 ; | X X  X | $FFB9
    .byte $34 ; |  XX X  | $FFBA
    .byte $24 ; |  X  X  | $FFBB
    .byte $58 ; | X XX   | $FFBC
    .byte $98 ; |X  XX   | $FFBD
    .byte $00 ; |        | $FFBE
    .byte $00 ; |        | $FFBF
    .byte $00 ; |        | $FFC0
    .byte $4C ; | X  XX  | $FFC1
    .byte $52 ; | X X  X | $FFC2
    .byte $52 ; | X X  X | $FFC3
    .byte $52 ; | X X  X | $FFC4
    .byte $CC ; |XX  XX  | $FFC5
    .byte $52 ; | X X  X | $FFC6
    .byte $52 ; | X X  X | $FFC7
    .byte $CC ; |XX  XX  | $FFC8
MFFC9:
    .byte $20 ; |  X     | $FFC9
    .byte $20 ; |  X     | $FFCA
    .byte $40 ; | X      | $FFCB
    .byte $40 ; | X      | $FFCC
    .byte $80 ; |X       | $FFCD
    .byte $80 ; |X       | $FFCE
    .byte $00 ; |        | $FFCF
    .byte $00 ; |        | $FFD0
    .byte $80 ; |X       | $FFD1
    .byte $80 ; |X       | $FFD2
    .byte $40 ; | X      | $FFD3
    .byte $40 ; | X      | $FFD4
    .byte $20 ; |  X     | $FFD5
    .byte $20 ; |  X     | $FFD6
    .byte $00 ; |        | $FFD7
    .byte $00 ; |        | $FFD8
    .byte $00 ; |        | $FFD9
    .byte $C0 ; |XX      | $FFDA
    .byte $20 ; |  X     | $FFDB
    .byte $20 ; |  X     | $FFDC
    .byte $20 ; |  X     | $FFDD
    .byte $40 ; | X      | $FFDE
    .byte $20 ; |  X     | $FFDF
    .byte $20 ; |  X     | $FFE0
    .byte $C0 ; |XX      | $FFE1

MFFE2:
    .byte  0  ; $FFE2
    .byte  3  ; $FFE3
    .byte -3  ; $FFE4
    .byte  3  ; $FFE5
    .byte -3  ; $FFE6
    .byte  3  ; $FFE7
    .byte -3  ; $FFE8
MFFE9:
    .byte $40 ; | X      | $FFE9  CMP ram_BA
    .byte $7B ; | XXXX XX| $FFEA
    .byte $00 ; |        | $FFEB
    .byte $2A ; |  X X X | $FFEC
    .byte $00 ; |        | $FFED
    .byte $7B ; | XXXX XX| $FFEE
    .byte $51 ; | X X   X| $FFEF
    .byte $FF ; |XXXXXXXX| $FFF0  <--- probably not used...

    .byte $FF ; |XXXXXXXX| $FFF1
MFFF2:
  IF SEGA_GENESIS
    PHA
  ELSE
    .byte $FE ; |XXXXXXX | $FFF2
  ENDIF

MFFF3:
    sta    BANK_0                ; 4
    rts                          ; 6

    .byte $FE ; |XXXXXXX | $FFF7
    .byte $FF ; |XXXXXXXX| $FFF8
    .byte $FF ; |XXXXXXXX| $FFF9
    .byte $FE ; |XXXXXXX | $FFFA
    .byte $FE ; |XXXXXXX | $FFFB

       ORG $1FFC
      RORG $FFFC

    .word START_1
    .word 0
