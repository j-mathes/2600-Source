; Pole Position Sega Genesis Controller
; By Omegamatrix
;
; last update Nov 30, 2013
;
;  Sega Genesis Controls:
;    - Pressing Button B, Button C, or Reset will start the game.
;
;    Down = brakes
;    Left = move left
;    Right = move right
;
;    Left difficulty switch in postion 'A' (Pro)
;        Button B = Lo gear
;        Button C = Hi gear
;
;    Left difficulty switch in postion 'B' (Amateur)
;        Button B = Hi gear
;        Button C = Lo gear
;


      processor 6502
      include vcs.h

BANK_0  =  $FFF8
BANK_1  =  $FFF9

ALTERNATE       = 0  ; alternate rom, this appears to be differences in garbage data
SEGA_GENESIS    = 1







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      BANK 0
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       ORG $1000
      RORG $D000

START_BANK0:
    sta    BANK_1                ; 4
LD003:
    beq    LD00A                 ; 2³
    stx    COLUBK                ; 3
    jmp    LD9E1                 ; 3

LD00A:
    lda    $DF,X                 ; 4
    and    #$07                  ; 2
    sta    $F9                   ; 3
    bpl    LD026                 ; 2³
LD012:
    lda    $DF,X                 ; 4
    and    #$0F                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    adc    $F9                   ; 3
    sta.wy $ED,Y                 ; 5
    cmp    #$48                  ; 2
    bcs    LD026                 ; 2³
    lda    #0                    ; 2
    sta    $F9                   ; 3
LD026:
    iny                          ; 2
    iny                          ; 2
    lda    $DF,X                 ; 4
    and    #$F0                  ; 2
    lsr                          ; 2
    adc    $F9                   ; 3
    sta.wy $ED,Y                 ; 5
    cmp    #$48                  ; 2
    bcs    LD03A                 ; 2³
    lda    #0                    ; 2
    sta    $F9                   ; 3
LD03A:
    iny                          ; 2
    iny                          ; 2
    inx                          ; 2
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    cpx    #3                    ; 2
    bne    LD012                 ; 2³
    stx    NUSIZ0                ; 3
    stx    NUSIZ1                ; 3
    stx    VDELP0                ; 3
    stx    VDELP1                ; 3
    ldx    #$0F                  ; 2
    stx    COLUP0                ; 3
    stx    COLUP1                ; 3
    inx                          ; 2
    stx    HMP1                  ; 3
    lda    $DC                   ; 3
    and    #$01                  ; 2
    sta    RESP0                 ; 3
    sta    RESP1                 ; 3
    beq    LD076                 ; 2³
    ldy    $86                   ; 3
    cpy    #$A0                  ; 2
    bcc    LD076                 ; 2³
    lda    $87                   ; 3
    and    #$03                  ; 2
    sbc    #3                    ; 2
    bne    LD076                 ; 2³
    lda    #$5E                  ; 2
    sta    $ED                   ; 3
    sta    $F7                   ; 3
    bne    LD088                 ; 2³
LD076:
    lda    $FF                   ; 3
    and    #$20                  ; 2
    beq    LD088                 ; 2³
    lda    $EF                   ; 3
    sta    $ED                   ; 3
    lda    $F1                   ; 3
    sta    $EF                   ; 3
    lda    #$57                  ; 2
    sta    $F1                   ; 3
LD088:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    ldy    #1                    ; 2
    sty    CTRLPF                ; 3
    dey                          ; 2
    sty    COLUPF                ; 3
    lda    #$FC                  ; 2
    sta    PF2                   ; 3
    ldy    #6                    ; 2
    sty    $FA                   ; 3
    ldx    #$DC                  ; 2
    stx    $EE                   ; 3
    stx    $F0                   ; 3
    stx    $F2                   ; 3
    stx    $F4                   ; 3
    stx    $F6                   ; 3
    stx    $F8                   ; 3
    nop                          ; 2
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    sta    HMCLR                 ; 3
LD0B0:
    ldy    $FA                   ; 3
    lda    ($F7),Y               ; 5
    sta    $011B                 ; 4
    sta    HMOVE                 ; 3
    lda    ($F5),Y               ; 5
    sta    GRP1                  ; 3
    lda    ($F3),Y               ; 5
    sta    GRP0                  ; 3
    lda    ($F1),Y               ; 5
    sta    $F9                   ; 3
    lda    ($EF),Y               ; 5
    tax                          ; 2
    lda    ($ED),Y               ; 5
    tay                          ; 2
    lda    $F9                   ; 3
    sta    GRP1                  ; 3
    stx    GRP0                  ; 3
    sty    GRP1                  ; 3
    sta    GRP0                  ; 3
    dec    $FA                   ; 5
    bpl    LD0B0                 ; 2³
    ldx    #0                    ; 2
    stx    GRP0                  ; 3
    stx    GRP1                  ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    stx    GRP0                  ; 3
    stx    VDELP0                ; 3
    stx    VDELP1                ; 3
    lda    $DC                   ; 3
    and    #$0F                  ; 2
    sta    $F9                   ; 3
    asl                          ; 2
    asl                          ; 2
    adc    $F9                   ; 3
    tay                          ; 2
    lda    $DC                   ; 3
    and    #$F0                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    $F9                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    adc    $F9                   ; 3
    tax                          ; 2
    lda    LDACB,Y               ; 4
    ora    LDF37,X               ; 4
    sta    $ED                   ; 3
    lda    LDACC,Y               ; 4
    ora    LDF38,X               ; 4
    sta    $EE                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    #0                    ; 2
    sta    PF2                   ; 3
    lda    LDACD,Y               ; 4
    ora    LDF39,X               ; 4
    sta    $EF                   ; 3
    lda    LDACE,Y               ; 4
    ora    LDF3A,X               ; 4
    sta    $F0                   ; 3
    lda    LDACF,Y               ; 4
    ora    LDF3B,X               ; 4
    sta    $F1                   ; 3
    lda    $DD                   ; 3
    and    #$0F                  ; 2
    sta    $F9                   ; 3
    asl                          ; 2
    asl                          ; 2
    adc    $F9                   ; 3
    tay                          ; 2
    lda    $DD                   ; 3
    and    #$F0                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    $F9                   ; 3
    lsr                          ; 2
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lsr                          ; 2
    adc    $F9                   ; 3
    tax                          ; 2
    lda    LDACB,Y               ; 4
    ora    LDF37,X               ; 4
    sta    $F2                   ; 3
    lda    LDACC,Y               ; 4
    ora    LDF38,X               ; 4
    sta    $F3                   ; 3
    lda    LDACD,Y               ; 4
    ora    LDF39,X               ; 4
    sta    $F4                   ; 3
    lda    LDACE,Y               ; 4
    ora    LDF3A,X               ; 4
    sta    $F5                   ; 3
    lda    LDACF,Y               ; 4
    ora    LDF3B,X               ; 4
    sta    $F6                   ; 3
    lda    $DE                   ; 3
    and    #$0F                  ; 2
    sta    $F9                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    asl                          ; 2
    asl                          ; 2
    adc    $F9                   ; 3
    tay                          ; 2
    lda    $DE                   ; 3
    and    #$F0                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    $F9                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    adc    $F9                   ; 3
    tax                          ; 2
    lda    LDACB,Y               ; 4
    ora    LDF37,X               ; 4
    sta    $F7                   ; 3
    lda    LDACC,Y               ; 4
    ora    LDF38,X               ; 4
    sta    $F8                   ; 3
    lda    LDACD,Y               ; 4
    ora    LDF39,X               ; 4
    sta    $F9                   ; 3
    lda    LDACE,Y               ; 4
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    ora    LDF3A,X               ; 4
    sta    $FA                   ; 3
    lda    #4                    ; 2
    sta    NUSIZ0                ; 3
    lda    #1                    ; 2
    sta    NUSIZ1                ; 3
    nop                          ; 2
    sta    RESP0                 ; 3
    lda    #0                    ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    lda    LDACF,Y               ; 4
    ora    LDF3B,X               ; 4
    sta    $FB                   ; 3
    pla                          ; 4
    pha                          ; 3
    lda    #$60                  ; 2
    sta    HMM0                  ; 3
    lda    #$F0                  ; 2
    sta    HMBL                  ; 3
    sta    RESP1                 ; 3
    sta    RESBL                 ; 3
    sta    RESM0                 ; 3
    ldy    #$0A                  ; 2
LD1E0:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    LDBA6,Y               ; 4
    sta    GRP0                  ; 3
    lda    LDAA0,Y               ; 4
    sta    GRP1                  ; 3
    pla                          ; 4
    pha                          ; 3
    nop                          ; 2
    lda    LDAC0,Y               ; 4
    sta    $011B                 ; 4
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    lda    #0                    ; 2
    sta    HMM0                  ; 3
    sta    HMBL                  ; 3
    dey                          ; 2
    sta    GRP1                  ; 3
    bpl    LD1E0                 ; 2³+1
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    sta    CTRLPF                ; 3
    ldx    #$0F                  ; 2
    stx    COLUP0                ; 3
    stx    COLUP1                ; 3
    stx    COLUPF                ; 3
    ldy    #4                    ; 2
    sta    HMM0                  ; 3
LD21E:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    bit    $85                   ; 3
    bmi    LD22B                 ; 2³
    lda    LDBB6,Y               ; 4
    bne    LD22F                 ; 2³
LD22B:
    lda    LDBB1,Y               ; 4
    nop                          ; 2
LD22F:
    sta    GRP0                  ; 3
    lda.wy $F2,Y                 ; 4
    sta    GRP1                  ; 3
    lda    #0                    ; 2
    sta    ENAM0                 ; 3
    lda.wy $ED,Y                 ; 4
    sta    GRP0                  ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    lda    LDB7C,Y               ; 4
    sta    ENABL                 ; 3
    sta    ENAM0                 ; 3
    lda.wy $F7,Y                 ; 4
    dey                          ; 2
    sta    GRP1                  ; 3
    bpl    LD21E                 ; 2³
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    iny                          ; 2
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    iny                          ; 2
LD25C:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    dey                          ; 2
    bpl    LD25C                 ; 2³
    iny                          ; 2
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    sty    $0104                 ; 4
    dey                          ; 2
    sty    $F9                   ; 3
    sty    RESM0                 ; 3
    sty    RESM1                 ; 3
    sty    $F4                   ; 3
    lda    #$D0                  ; 2
    sta    HMM1                  ; 3
    sty    $F3                   ; 3
    lda    #7                    ; 2
    sta    $FA                   ; 3
    lda    #1                    ; 2
    sta    NUSIZ1                ; 3
    lda    #$3F                  ; 2
    sta    CTRLPF                ; 3
    lda    #$0F                  ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    nop                          ; 2
    lda    #$E0                  ; 2
    sty    HMP1                  ; 3
    sta    RESP0                 ; 3
    sta    RESP1                 ; 3
    sta    HMP0                  ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    #$44                  ; 2
    sta    COLUPF                ; 3
    lda    $88                   ; 3
    lsr                          ; 2
    tay                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    LDB23,X               ; 4
    sta    $FA                   ; 3
    sta    HMCLR                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    tya                          ; 2
    sec                          ; 2
LD2B7:
    sbc    #$0F                  ; 2
    bcs    LD2B7                 ; 2³
    eor    #$07                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    nop                          ; 2
    nop                          ; 2
    sta    HMBL                  ; 3
    sta    RESBL                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    LDFCB,X               ; 4
    sta    $F9                   ; 3
    lda    LDA8B,X               ; 4
    sta    $F4                   ; 3
    lda    LDAAB,X               ; 4
    sta    $F3                   ; 3
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    lda    #$F0                  ; 2
    sta    HMBL                  ; 3
    lda    #2                    ; 2
    sta    ENAM0                 ; 3
    sta    ENAM1                 ; 3
    sta    ENABL                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    ldy    #4                    ; 2
LD2F2:
    lda    $F9                   ; 3
    sta    PF1                   ; 3
    lda    $F4                   ; 3
    sta    PF2                   ; 3
    ldx    LDDF6,Y               ; 4
    stx    NUSIZ0                ; 3
    lda    LDBA1,Y               ; 4
    stx    COLUBK                ; 3
    sta    GRP0                  ; 3
    lda    $FA                   ; 3
    sta    PF1                   ; 3
    lda    $F3                   ; 3
    ldx    #$86                  ; 2
    sta    PF2                   ; 3
    lda    LDDFB,Y               ; 4
    sta    GRP1                  ; 3
    lda    LDC98,Y               ; 4
    stx    COLUBK                ; 3
    ldx    LDB8C,Y               ; 4
    sta    GRP0                  ; 3
    stx    GRP1                  ; 3
    sta    HMOVE                 ; 3
    dey                          ; 2
    bpl    LD2F2                 ; 2³+1
    iny                          ; 2
    sty    ENAM0                 ; 3
    sty    ENAM1                 ; 3
    sty    ENABL                 ; 3
    sty    PF1                   ; 3
    sty    PF2                   ; 3
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    sta    CXCLR                 ; 3
    lda    $87                   ; 3
    cmp    #$14                  ; 2
    lda    $EB                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    bpl    LD397                 ; 2³
    bcs    LD397                 ; 2³
    lda    $DC                   ; 3
    beq    LD397                 ; 2³
    sed                          ; 2
    lda    $85                   ; 3
    and    #$04                  ; 2
    beq    LD36F                 ; 2³
    lda    $E3                   ; 3
    bne    LD362                 ; 2³
    lda    $85                   ; 3
    and    #$FB                  ; 2
    sta    $85                   ; 3
    lda    #4                    ; 2
    sta    $DD                   ; 3
    sta    $DE                   ; 3
    bne    LD396                 ; 2³
LD362:
    and    #$3F                  ; 2
    bne    LD396                 ; 2³
    lda    $DC                   ; 3
    sbc    #0                    ; 2
    sta    $DC                   ; 3
    jmp    LD396                 ; 3

LD36F:
    ldx    #2                    ; 2
    lda    $E3                   ; 3
    and    #$0F                  ; 2
    cmp    #5                    ; 2
    bcs    LD37A                 ; 2³
    inx                          ; 2
LD37A:
    txa                          ; 2
    clc                          ; 2
    adc    $DE                   ; 3
    sta    $DE                   ; 3
    bcc    LD396                 ; 2³
    lda    $DD                   ; 3
    adc    #0                    ; 2
    sta    $DD                   ; 3
    lda    $DC                   ; 3
    sbc    #0                    ; 2
    sta    $DC                   ; 3
    bne    LD396                 ; 2³
    lda    $DF                   ; 3
    and    #$F0                  ; 2
    sta    $DF                   ; 3
LD396:
    cld                          ; 2
LD397:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    $BE                   ; 3
    cmp    #$11                  ; 2
    bcs    LD3A7                 ; 2³
    sbc    #4                    ; 2
    bcs    LD3A7                 ; 2³
    adc    #$A5                  ; 2
LD3A7:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
LD3AB:
    sbc    #$0F                  ; 2
    bcs    LD3AB                 ; 2³
    eor    #$07                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    HMP0                  ; 3
    sta    RESP0                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    $BE                   ; 3
    adc    #$0F                  ; 2
    cmp    #$A0                  ; 2
    bcc    LD3C7                 ; 2³
    sbc    #$A0                  ; 2
LD3C7:
    cmp    #$11                  ; 2
    bcs    LD3D1                 ; 2³
    sbc    #4                    ; 2
    bcs    LD3D1                 ; 2³
    adc    #$A5                  ; 2
LD3D1:
    nop                          ; 2
    sta    $012B                 ; 4
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
LD3D9:
    sbc    #$0F                  ; 2
    bcs    LD3D9                 ; 2³
    eor    #$07                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    HMP1                  ; 3
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    #$0F                  ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    lda    #5                    ; 2
    sta    NUSIZ0                ; 3
    sta    NUSIZ1                ; 3
    ldy    #$0A                  ; 2
LD3F9:
    sta    HMCLR                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    LDFE1,Y               ; 4
    sta    GRP0                  ; 3
    lda    LDBF5,Y               ; 4
    sta    GRP1                  ; 3
    dey                          ; 2
    bpl    LD3F9                 ; 2³+1
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    iny                          ; 2
    sty    ENABL                 ; 3
    sty    ENAM1                 ; 3
    sty    CTRLPF                ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    sty    REFP0                 ; 3
    sty    REFP1                 ; 3
    lda    #$24                  ; 2
    sta    COLUPF                ; 3
    sta    COLUP1                ; 3
    lda    #$D2                  ; 2
    sta    COLUP0                ; 3
    lda    #$35                  ; 2
    sta    NUSIZ0                ; 3
    sta    NUSIZ1                ; 3
    ldy    #$0B                  ; 2
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    $BE                   ; 3
    adc    #$32                  ; 2
    cmp    #$A0                  ; 2
    bcc    LD443                 ; 2³
    sbc    #$A0                  ; 2
LD443:
    clc                          ; 2
    adc    #$33                  ; 2
    cmp    #$A0                  ; 2
    bcc    LD44C                 ; 2³
    sbc    #$A0                  ; 2
LD44C:
    cmp    #$11                  ; 2
    bcs    LD456                 ; 2³
    sbc    #4                    ; 2
    bcs    LD456                 ; 2³
    adc    #$A5                  ; 2
LD456:
    sta    $F9                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
LD45C:
    sbc    #$0F                  ; 2
    bcs    LD45C                 ; 2³
    eor    #$07                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    HMM1                  ; 3
    sta    RESM1                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    $F9                   ; 3
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    nop                          ; 2
    sta    HMCLR                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
LD47B:
    sbc    #$0F                  ; 2
    bcs    LD47B                 ; 2³
    eor    #$07                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    HMM0                  ; 3
    sta    RESM0                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    pha                          ; 3
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    pla                          ; 4
    sta    HMCLR                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    #2                    ; 2
    sta    ENAM0                 ; 3
LD49C:
    lda    LDAF4,Y               ; 4
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    lda    LDB78,Y               ; 4
    sta    NUSIZ0                ; 3
    sta    HMM0                  ; 3
    dey                          ; 2
    cpy    #8                    ; 2
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    bne    LD49C                 ; 2³
    lda    #$FF                  ; 2
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    sta    ENAM1                 ; 3
    lda    #$B0                  ; 2
    sta    HMP1                  ; 3
    lda    #$40                  ; 2
    sta    HMP0                  ; 3
    lda    #$20                  ; 2
    sta    HMM0                  ; 3
    lda    #$E0                  ; 2
    sta    HMM1                  ; 3
    ldx    #$BF                  ; 2
    txs                          ; 2
    dey                          ; 2
LD4CF:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    pla                          ; 4
    sta    PF0                   ; 3
    pla                          ; 4
    sta    PF1                   ; 3
    pla                          ; 4
    sta    PF2                   ; 3
    pla                          ; 4
    sta    PF0                   ; 3
    pla                          ; 4
    dey                          ; 2
    sta    PF1                   ; 3
    pla                          ; 4
    txs                          ; 2
    sta    PF2                   ; 3
    sta    WSYNC                 ; 3
    sta    $012A                 ; 4
    nop                          ; 2
    pla                          ; 4
    pha                          ; 3
    pla                          ; 4
    sta    PF0                   ; 3
    pla                          ; 4
    sta    PF1                   ; 3
    pla                          ; 4
    sta    PF2                   ; 3
    pla                          ; 4
    sta    PF0                   ; 3
    pla                          ; 4
    sta    PF1                   ; 3
    pla                          ; 4
    tsx                          ; 2
    sta    PF2                   ; 3
    dey                          ; 2
    bpl    LD4CF                 ; 2³+1
    iny                          ; 2
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    sty    ENAM0                 ; 3
    sty    ENAM1                 ; 3
    ldx    #$24                  ; 2
    stx    COLUBK                ; 3
    sty    PF0                   ; 3
    sty    PF1                   ; 3
    sty    PF2                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    sta    HMCLR                 ; 3
    lda    #$21                  ; 2
    sta    CTRLPF                ; 3
    lda    #$27                  ; 2
    sta    NUSIZ0                ; 3
    lda    $E5                   ; 3
    sta    NUSIZ1                ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    pla                          ; 4
    pha                          ; 3
    nop                          ; 2
    nop                          ; 2
    lda    #$2C                  ; 2
    sta    COLUP1                ; 3
    ldx    #$14                  ; 2
    txs                          ; 2
    lda    $82                   ; 3
    and    #$0F                  ; 2
    sta    $01F9                 ; 4
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    sta    $0110                 ; 4
    beq    LD564                 ; 2³
    ldx    #$D0                  ; 2
    bit    $8A                   ; 3
    bmi    LD55B                 ; 2³
    lda    #$30                  ; 2
    sta    HMM0                  ; 3
    lda    #$80                  ; 2
    jmp    LD579                 ; 3

LD55B:
    lda    #$E0                  ; 2
    sta    HMM0                  ; 3
    lda    #$D0                  ; 2
    jmp    LD579                 ; 3

LD564:
    ldx    #$10                  ; 2
    bit    $8A                   ; 3
    bmi    LD573                 ; 2³
    lda    #$30                  ; 2
    sta    HMM0                  ; 3
    lda    #0                    ; 2
    jmp    LD579                 ; 3

LD573:
    lda    #0                    ; 2
    sta    HMM0                  ; 3
    lda    #$20                  ; 2
LD579:
    sta    HMBL                  ; 3
    stx    HMM1                  ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    #$DF                  ; 2
    sta    $EE                   ; 3
    lda    #$DC                  ; 2
    sta    $F0                   ; 3
    lda    #$DB                  ; 2
    sta    $F2                   ; 3
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    lda    $D9                   ; 3
    sta    HMP1                  ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    and    #$0F                  ; 2
    tax                          ; 2
LD5A0:
    dex                          ; 2
    bpl    LD5A0                 ; 2³
    sta    RESP1                 ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    $DB                   ; 3
    cmp    #$0E                  ; 2
    bcc    LD5B1                 ; 2³
    sbc    #$0E                  ; 2
LD5B1:
    cmp    #7                    ; 2
    bcc    LD5B7                 ; 2³
    adc    #$29                  ; 2
LD5B7:
    tax                          ; 2
    adc    #$5E                  ; 2
    sta    $ED                   ; 3
    txa                          ; 2
    adc    #$90                  ; 2
    sta    $EF                   ; 3
    ldy    #$69                  ; 2
    lda    $88                   ; 3
    beq    LD5D4                 ; 2³
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    LDB84,X               ; 4
    and    $E3                   ; 3
    beq    LD5D6                 ; 2³
LD5D4:
    ldy    #$15                  ; 2
LD5D6:
    sty    $F1                   ; 3
    lda    #0                    ; 2
    sta    HMP1                  ; 3
    lda    #$DB                  ; 2
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    sta    $F4                   ; 3
    sta    $F6                   ; 3
    bit    $85                   ; 3
    bvc    LD606                 ; 2³+1
    lda    $E3                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    and    #$01                  ; 2
    clc                          ; 2
    adc    $85                   ; 3
    and    #$03                  ; 2
    tay                          ; 2
    lda    #$43                  ; 2
    sta    $F1                   ; 3
    lda    LDD00,Y               ; 4
    sta    $F5                   ; 3
    sta    $F3                   ; 3
    ldy    $F9                   ; 3
    jmp    LD639                 ; 3

LD606:
    lda    #0                    ; 2
    ldx    $FD                   ; 3
    bmi    LD615                 ; 2³
    cpx    #5                    ; 2
    bcc    LD61B                 ; 2³
    lda    #$39                  ; 2
    jmp    LD61B                 ; 3

LD615:
    cpx    #$FC                  ; 2
    bcs    LD61B                 ; 2³
    lda    #$0B                  ; 2
LD61B:
    ldx    #$4D                  ; 2
    stx    $F5                   ; 3
    sta    $F3                   ; 3
    ldy    $F9                   ; 3
    lda    $85                   ; 3
    and    #$04                  ; 2
    beq    LD639                 ; 2³
    lda    $E3                   ; 3
    cmp    #$40                  ; 2
    bcs    LD639                 ; 2³
    and    #$08                  ; 2
    beq    LD639                 ; 2³
    lda    #$27                  ; 2
    sta    $F3                   ; 3
    sta    $F5                   ; 3
LD639:
    cpy    #$0A                  ; 2
    beq    LD644                 ; 2³
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    nop                          ; 2
    bne    LD669                 ; 2³
LD644:
    bit    $8A                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    bpl    LD654                 ; 2³
    lda    #0                    ; 2
    sta    HMBL                  ; 3
    lda    #0                    ; 2
    beq    LD65B                 ; 2³
LD654:
    lda    #$80                  ; 2
    sta    HMBL                  ; 3
    lda    #$A0                  ; 2
    nop                          ; 2
LD65B:
    sta    HMM1                  ; 3
    lda    #0                    ; 2
    sta    HMM0                  ; 3
    dey                          ; 2
    dey                          ; 2
    dey                          ; 2
    dey                          ; 2
LD665:
    dey                          ; 2
    bpl    LD665                 ; 2³
    brk                          ; 7
LD669:
    cpy    #0                    ; 2
    beq    LD670                 ; 2³
LD66D:
    dey                          ; 2
    bpl    LD66D                 ; 2³
LD670:
    brk                          ; 7
BRK_ROUTINE:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    ldy    #$31                  ; 2
    lda    #4                    ; 2
    sta    COLUBK                ; 3
    sta    COLUP0                ; 3
    sta    COLUPF                ; 3
    sta    HMP1                  ; 3
    lda    #2                    ; 2
    sta    ENAM0                 ; 3
    sta    ENABL                 ; 3
    lda    $82                   ; 3
    sta    HMM0                  ; 3
    sta    HMM1                  ; 3
    sta    HMBL                  ; 3
    bit    $8A                   ; 3
    bpl    LD696                 ; 2³
    jmp    LD7AB                 ; 3

LD696:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    ($80),Y               ; 5
    and    $DA                   ; 3
    sta    GRP1                  ; 3
    lda    ($ED),Y               ; 5
    sta    COLUP0                ; 3
    sta    COLUPF                ; 3
    lda.wy $8C,Y                 ; 4
    and    #$F0                  ; 2
    adc    #$10                  ; 2
    sta    HMM0                  ; 3
    sbc    #$0F                  ; 2
    sta    HMM1                  ; 3
    sbc    #$0E                  ; 2
    sta    HMBL                  ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    LDB91,X               ; 4
    ldx    #3                    ; 2
    clc                          ; 2
    adc    $83                   ; 3
    sta    $83                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    bmi    LD6D0                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD6D1                 ; 2³
LD6D0:
    inx                          ; 2
LD6D1:
    stx    ENAM0                 ; 3
    stx    ENABL                 ; 3
    ldx    #3                    ; 2
    adc    LDBBB,Y               ; 4
    bmi    LD6E0                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD6E1                 ; 2³
LD6E0:
    inx                          ; 2
LD6E1:
    txa                          ; 2
    and    ($EF),Y               ; 5
    sta    ENAM1                 ; 3
    dey                          ; 2
    cpy    #$2D                  ; 2
    bne    LD696                 ; 2³
LD6EB:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    ($80),Y               ; 5
    and    $DA                   ; 3
    sta    GRP1                  ; 3
    lda    ($ED),Y               ; 5
    sta    COLUP0                ; 3
    sta    COLUPF                ; 3
    lda.wy $8C,Y                 ; 4
    and    #$F0                  ; 2
    adc    #$10                  ; 2
    sta    HMM0                  ; 3
    sbc    #$0F                  ; 2
    sta    HMM1                  ; 3
    sbc    #$0E                  ; 2
    sta    HMBL                  ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    LDB91,X               ; 4
    ldx    #3                    ; 2
    clc                          ; 2
    adc    $83                   ; 3
    sta    $83                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    bmi    LD725                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD726                 ; 2³
LD725:
    inx                          ; 2
LD726:
    stx    ENAM0                 ; 3
    ldx    #3                    ; 2
    adc    LDBBB,Y               ; 4
    bmi    LD733                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD734                 ; 2³
LD733:
    inx                          ; 2
LD734:
    stx    $F9                   ; 3
    ldx    #3                    ; 2
    adc    LDBBB,Y               ; 4
    bmi    LD741                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD742                 ; 2³
LD741:
    inx                          ; 2
LD742:
    stx    ENABL                 ; 3
    lda    $F9                   ; 3
    and    ($EF),Y               ; 5
    sta    ENAM1                 ; 3
    dey                          ; 2
    cpy    #$0A                  ; 2
    bne    LD6EB                 ; 2³+1
    lda    #0                    ; 2
    sta    ENAM1                 ; 3
LD753:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    ($80),Y               ; 5
    and    $DA                   ; 3
    sta    GRP1                  ; 3
    lda    ($F3),Y               ; 5
    sta    GRP0                  ; 3
    lda    ($F5),Y               ; 5
    and    #$E0                  ; 2
    sta    PF2                   ; 3
    lda    ($F1),Y               ; 5
    sta    COLUP0                ; 3
    sta    $F9                   ; 3
    lda.wy $8C,Y                 ; 4
    and    #$F0                  ; 2
    adc    #$10                  ; 2
    sta    HMM0                  ; 3
    sbc    #$1E                  ; 2
    sta    HMBL                  ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    LDB91,X               ; 4
    ldx    #3                    ; 2
    clc                          ; 2
    sta    HMOVE                 ; 3
    adc    $83                   ; 3
    sta    $83                   ; 3
    bmi    LD791                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD792                 ; 2³
LD791:
    inx                          ; 2
LD792:
    stx    ENAM0                 ; 3
    ldx    #3                    ; 2
    adc    LDBBB,Y               ; 4
    adc    LDBBB,Y               ; 4
    bmi    LD7A2                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD7A3                 ; 2³
LD7A2:
    inx                          ; 2
LD7A3:
    stx    ENABL                 ; 3
    dey                          ; 2
    bpl    LD753                 ; 2³
    jmp    LD8BD                 ; 3

LD7AB:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    ($80),Y               ; 5
    and    $DA                   ; 3
    sta    GRP1                  ; 3
    lda    ($ED),Y               ; 5
    sta    COLUP0                ; 3
    sta    COLUPF                ; 3
    lda.wy $8C,Y                 ; 4
    and    #$F0                  ; 2
    adc    #$10                  ; 2
    sta    HMBL                  ; 3
    sbc    #$0F                  ; 2
    sta    HMM1                  ; 3
    sbc    #$0E                  ; 2
    sta    HMM0                  ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    LDB91,X               ; 4
    ldx    #3                    ; 2
    clc                          ; 2
    adc    $83                   ; 3
    sta    $83                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    bmi    LD7E5                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD7E6                 ; 2³
LD7E5:
    inx                          ; 2
LD7E6:
    stx    ENAM0                 ; 3
    stx    ENABL                 ; 3
    ldx    #3                    ; 2
    adc    LDBBB,Y               ; 4
    bmi    LD7F5                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD7F6                 ; 2³
LD7F5:
    inx                          ; 2
LD7F6:
    txa                          ; 2
    and    ($EF),Y               ; 5
    sta    ENAM1                 ; 3
    dey                          ; 2
    cpy    #$2D                  ; 2
    bne    LD7AB                 ; 2³
LD800:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    ($80),Y               ; 5
    and    $DA                   ; 3
    sta    GRP1                  ; 3
    lda    ($ED),Y               ; 5
    sta    COLUP0                ; 3
    sta    COLUPF                ; 3
    lda.wy $8C,Y                 ; 4
    and    #$F0                  ; 2
    adc    #$10                  ; 2
    sta    HMBL                  ; 3
    sbc    #$0F                  ; 2
    sta    HMM1                  ; 3
    sbc    #$0E                  ; 2
    sta    HMM0                  ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    LDB91,X               ; 4
    ldx    #3                    ; 2
    clc                          ; 2
    adc    $83                   ; 3
    sta    $83                   ; 3
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    bmi    LD83A                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD83B                 ; 2³
LD83A:
    inx                          ; 2
LD83B:
    stx    ENABL                 ; 3
    ldx    #3                    ; 2
    adc    LDBBB,Y               ; 4
    bmi    LD848                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD849                 ; 2³
LD848:
    inx                          ; 2
LD849:
    stx    $F9                   ; 3
    ldx    #3                    ; 2
    adc    LDBBB,Y               ; 4
    bmi    LD856                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD857                 ; 2³
LD856:
    inx                          ; 2
LD857:
    stx    ENAM0                 ; 3
    lda    $F9                   ; 3
    and    ($EF),Y               ; 5
    sta    ENAM1                 ; 3
    dey                          ; 2
    cpy    #$0A                  ; 2
    bne    LD800                 ; 2³
    lda    #0                    ; 2
    sta    ENAM1                 ; 3
LD868:
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    lda    ($80),Y               ; 5
    and    $DA                   ; 3
    sta    GRP1                  ; 3
    lda    ($F3),Y               ; 5
    sta    GRP0                  ; 3
    lda    ($F5),Y               ; 5
    and    #$E0                  ; 2
    sta    PF2                   ; 3
    lda    ($F1),Y               ; 5
    sta    COLUP0                ; 3
    sta    $F9                   ; 3
    lda.wy $8C,Y                 ; 4
    and    #$F0                  ; 2
    adc    #$10                  ; 2
    sta    HMBL                  ; 3
    sbc    #$1E                  ; 2
    sta    HMM0                  ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    LDB91,X               ; 4
    ldx    #3                    ; 2
    clc                          ; 2
    sta    HMOVE                 ; 3
    adc    $83                   ; 3
    sta    $83                   ; 3
    bmi    LD8A6                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD8A7                 ; 2³
LD8A6:
    inx                          ; 2
LD8A7:
    stx    ENABL                 ; 3
    ldx    #3                    ; 2
    adc    LDBBB,Y               ; 4
    adc    LDBBB,Y               ; 4
    bmi    LD8B7                 ; 2³
    cmp    #$50                  ; 2
    bcc    LD8B8                 ; 2³
LD8B7:
    inx                          ; 2
LD8B8:
    stx    ENAM0                 ; 3
    dey                          ; 2
    bpl    LD868                 ; 2³
LD8BD:
    jmp    LDFF2                 ; 3

LD8C0:
    lda    $87                   ; 3
    cmp    #$14                  ; 2
    bcc    LD8C9                 ; 2³
LD8C6:
    jmp    LD983                 ; 3

LD8C9:
    lda    $DC                   ; 3
    bne    LD8D1                 ; 2³
    lda    $88                   ; 3
    beq    LD8C6                 ; 2³
LD8D1:
    lda    $88                   ; 3
    beq    LD8E9                 ; 2³
    lsr                          ; 2
    sta    $F9                   ; 3
    lsr                          ; 2
    clc                          ; 2
    adc    $F9                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    $F9                   ; 3
    lda    $E3                   ; 3
    and    #$02                  ; 2
    lsr                          ; 2
    ora    $F9                   ; 3
LD8E9:
    sta    $F4                   ; 3
    clc                          ; 2
    adc    $DF                   ; 3
    sta    $DF                   ; 3
    and    #$0F                  ; 2
    cmp    #8                    ; 2
    bmi    LD970                 ; 2³+1
    inc    $86                   ; 5
    bne    LD963                 ; 2³+1
    inc    $87                   ; 5
    lda    $87                   ; 3
    tay                          ; 2
    cmp    #4                    ; 2
    beq    LD935                 ; 2³
    and    #$03                  ; 2
    bne    LD963                 ; 2³
    cpy    #$14                  ; 2
    bcc    LD914                 ; 2³
    lda    $DF                   ; 3
    and    #$F0                  ; 2
    sta    $DF                   ; 3
    jmp    LD963                 ; 3

LD914:
    lda    $87                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    tay                          ; 2
    lda    $DC                   ; 3
    clc                          ; 2
    sed                          ; 2
    adc    LDC93,Y               ; 4
    cld                          ; 2
    sta    $DC                   ; 3
    lda    #$88                  ; 2
    sta    $EB                   ; 3
    lda    $85                   ; 3
    ora    #$04                  ; 2
    sta    $85                   ; 3
    lda    #2                    ; 2
    sta    $EC                   ; 3
    sta    $E3                   ; 3
    bpl    LD963                 ; 2³
LD935:
    lda    $DD                   ; 3
    cmp    #$73                  ; 2
    bcs    LD963                 ; 2³
    lda    $85                   ; 3
    and    #$BF                  ; 2
    sta    $85                   ; 3
    lda    #$6B                  ; 2
    sta    $EB                   ; 3
    lda    #2                    ; 2
    sta    $EC                   ; 3
    lda    $DF                   ; 3
    and    #$F0                  ; 2
    sta    $DF                   ; 3
    lda    #0                    ; 2
    sta    $88                   ; 3
    sta    $E2                   ; 3
    sta    $FD                   ; 3
    sta    $E8                   ; 3
    lda    #$35                  ; 2
    sta    $89                   ; 3
    lda    $FF                   ; 3
    ora    #$80                  ; 2
    sta    $FF                   ; 3
LD963:
    lda    $DF                   ; 3
    and    #$F7                  ; 2
    sta    $DF                   ; 3
    lda    #$10                  ; 2
    ldx    #0                    ; 2
    jsr    LD9CF                 ; 6
LD970:
    cld                          ; 2
    lda    $F4                   ; 3
    clc                          ; 2
    adc    $DB                   ; 3
    cmp    #$1C                  ; 2
    sta    $DB                   ; 3
    bcc    LD9CC                 ; 2³
    sbc    #$1C                  ; 2
    sta    $DB                   ; 3
    jmp    LD9CC                 ; 3

LD983:
    lda    $EB                   ; 3
    bpl    LD9CC                 ; 2³
    lda    $88                   ; 3
    bne    LD9CC                 ; 2³
    lda    $E3                   ; 3
    and    #$07                  ; 2
    bne    LD9CC                 ; 2³
    ldy    $DC                   ; 3
    bne    LD9BD                 ; 2³
    lda    $E2                   ; 3
    beq    LD9CC                 ; 2³
    lda    $FF                   ; 3
    bmi    LD9A3                 ; 2³
    lda    #0                    ; 2
    sta    $E2                   ; 3
    beq    LD9CC                 ; 2³
LD9A3:
    lda    #$50                  ; 2
    ldx    #0                    ; 2
    jsr    LD9CF                 ; 6
    cld                          ; 2
    dec    $E2                   ; 5
    bne    LD9B3                 ; 2³
    lda    #2                    ; 2
    sta    $E9                   ; 3
LD9B3:
    lda    #$0D                  ; 2
    sta    AUDV1                 ; 3
    sta    AUDC1                 ; 3
    sta    AUDF1                 ; 3
    bpl    LD9CC                 ; 2³
LD9BD:
    lda    #0                    ; 2
    ldx    #2                    ; 2
    jsr    LD9CF                 ; 6
    tya                          ; 2
    sbc    #0                    ; 2
    sta    $DC                   ; 3
    cld                          ; 2
    bpl    LD9B3                 ; 2³
LD9CC:
    jmp    LDFEC                 ; 3

LD9CF:
    sed                          ; 2
    clc                          ; 2
    adc    $DF                   ; 3
    sta    $DF                   ; 3
    txa                          ; 2
    adc    $E0                   ; 3
    sta    $E0                   ; 3
    lda    #0                    ; 2
    adc    $E1                   ; 3
    sta    $E1                   ; 3
    rts                          ; 6

LD9E1:
    sta    WSYNC                 ; 3
    lda    #3                    ; 2
    sta    NUSIZ0                ; 3
    sta    NUSIZ1                ; 3
    sta    VDELP0                ; 3
    sta    VDELP1                ; 3
    lda    #$44                  ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    ldy    #$10                  ; 2
    sty    HMP1                  ; 3
    dey                          ; 2
    sty    COLUPF                ; 3
    lda    #$81                  ; 2
    sta    CTRLPF                ; 3
    sta    RESP0                 ; 3
    sta    RESP1                 ; 3
    ldy    #$1E                  ; 2
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
LDA08:
    sta    WSYNC                 ; 3
    sta    COLUBK                ; 3
    dey                          ; 2
    bpl    LDA08                 ; 2³
    ldy    #$28                  ; 2
    sty    $FA                   ; 3
LDA13:
    sta    WSYNC                 ; 3
    lda    LDC67,Y               ; 4
    sta    PF1                   ; 3
    lda    LDC6B,Y               ; 4
    ora    #$80                  ; 2
    sta    PF2                   ; 3
    dey                          ; 2
    bne    LDA13                 ; 2³
    dey                          ; 2
    sty    PF2                   ; 3
LDA27:
    ldy    $FA                   ; 3
    lda    LDD04,Y               ; 4
    ldx    LDC67,Y               ; 4
    sta    WSYNC                 ; 3
    stx    PF1                   ; 3
    sta    GRP0                  ; 3
    lda    LDD7D,Y               ; 4
    sta    GRP1                  ; 3
    lda    LDD2D,Y               ; 4
    sta    GRP0                  ; 3
    lda    LDD56,Y               ; 4
    sta    $F9                   ; 3
    ldx    LDDA4,Y               ; 4
    lda    LDDCD,Y               ; 4
    tay                          ; 2
    lda    $F9                   ; 3
    nop                          ; 2
    sta    GRP1                  ; 3
    stx    GRP0                  ; 3
    sty    GRP1                  ; 3
    sta    GRP0                  ; 3
    dec    $FA                   ; 5
    bpl    LDA27                 ; 2³
    ldx    #0                    ; 2
    stx    GRP0                  ; 3
    stx    GRP1                  ; 3
    sta    WSYNC                 ; 3
    stx    GRP0                  ; 3
    stx    VDELP0                ; 3
    stx    VDELP1                ; 3
    ldy    #$27                  ; 2
LDA6A:
    sta    WSYNC                 ; 3
    lda    LDC65,Y               ; 4
    sta    PF1                   ; 3
    lda    LDC69,Y               ; 4
    ora    #$80                  ; 2
    sta    PF2                   ; 3
    dey                          ; 2
    bne    LDA6A                 ; 2³
    ldx    #$25                  ; 2
LDA7D:
    sta    WSYNC                 ; 3
    sty    PF1                   ; 3
    sty    PF2                   ; 3
    dex                          ; 2
    bne    LDA7D                 ; 2³
    stx    COLUBK                ; 3
    jmp    LDFF2                 ; 3

LDA8B:
    .byte $00 ; |        | $DA8B
    .byte $00 ; |        | $DA8C
    .byte $00 ; |        | $DA8D
    .byte $00 ; |        | $DA8E
    .byte $00 ; |        | $DA8F
    .byte $01 ; |       X| $DA90
    .byte $03 ; |      XX| $DA91
    .byte $07 ; |     XXX| $DA92
    .byte $0F ; |    XXXX| $DA93
    .byte $1F ; |   XXXXX| $DA94
    .byte $3F ; |  XXXXXX| $DA95
    .byte $7F ; | XXXXXXX| $DA96
    .byte $FF ; |XXXXXXXX| $DA97
    .byte $FF ; |XXXXXXXX| $DA98
    .byte $FF ; |XXXXXXXX| $DA99
    .byte $FF ; |XXXXXXXX| $DA9A
    .byte $FF ; |XXXXXXXX| $DA9B
    .byte $FF ; |XXXXXXXX| $DA9C
    .byte $FF ; |XXXXXXXX| $DA9D
    .byte $FF ; |XXXXXXXX| $DA9E
    .byte $FF ; |XXXXXXXX| $DA9F
LDAA0:
    .byte $FF ; |XXXXXXXX| $DAA0
    .byte $00 ; |        | $DAA1
    .byte $7E ; | XXXXXX | $DAA2
    .byte $7E ; | XXXXXX | $DAA3
    .byte $60 ; | XX     | $DAA4
    .byte $60 ; | XX     | $DAA5
    .byte $60 ; | XX     | $DAA6
    .byte $60 ; | XX     | $DAA7
    .byte $60 ; | XX     | $DAA8
    .byte $60 ; | XX     | $DAA9
    .byte $60 ; | XX     | $DAAA
LDAAB:
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
    .byte $80 ; |X       | $DAB8
    .byte $C0 ; |XX      | $DAB9
    .byte $E0 ; |XXX     | $DABA
    .byte $F0 ; |XXXX    | $DABB
    .byte $F8 ; |XXXXX   | $DABC
    .byte $FC ; |XXXXXX  | $DABD
    .byte $FE ; |XXXXXXX | $DABE
    .byte $FF ; |XXXXXXXX| $DABF
LDAC0:
    .byte $FF ; |XXXXXXXX| $DAC0
    .byte $00 ; |        | $DAC1
    .byte $18 ; |   XX   | $DAC2
    .byte $18 ; |   XX   | $DAC3
    .byte $18 ; |   XX   | $DAC4
    .byte $18 ; |   XX   | $DAC5
    .byte $18 ; |   XX   | $DAC6
    .byte $18 ; |   XX   | $DAC7
    .byte $18 ; |   XX   | $DAC8
    .byte $FF ; |XXXXXXXX| $DAC9
    .byte $FF ; |XXXXXXXX| $DACA
LDACB:
    .byte $0E ; |    XXX | $DACB
LDACC:
    .byte $0A ; |    X X | $DACC
LDACD:
    .byte $0A ; |    X X | $DACD
LDACE:
    .byte $0A ; |    X X | $DACE
LDACF:
    .byte $0E ; |    XXX | $DACF
    .byte $0E ; |    XXX | $DAD0
    .byte $04 ; |     X  | $DAD1
    .byte $04 ; |     X  | $DAD2
    .byte $04 ; |     X  | $DAD3
    .byte $0C ; |    XX  | $DAD4
    .byte $0E ; |    XXX | $DAD5
    .byte $08 ; |    X   | $DAD6
    .byte $0E ; |    XXX | $DAD7
    .byte $02 ; |      X | $DAD8
    .byte $0E ; |    XXX | $DAD9
    .byte $0E ; |    XXX | $DADA
    .byte $02 ; |      X | $DADB
    .byte $06 ; |     XX | $DADC
    .byte $02 ; |      X | $DADD
    .byte $0E ; |    XXX | $DADE
    .byte $02 ; |      X | $DADF
    .byte $02 ; |      X | $DAE0
    .byte $0E ; |    XXX | $DAE1
    .byte $0A ; |    X X | $DAE2
    .byte $0A ; |    X X | $DAE3
    .byte $0E ; |    XXX | $DAE4
    .byte $02 ; |      X | $DAE5
    .byte $0E ; |    XXX | $DAE6
    .byte $08 ; |    X   | $DAE7
    .byte $0E ; |    XXX | $DAE8
    .byte $0E ; |    XXX | $DAE9
    .byte $0A ; |    X X | $DAEA
    .byte $0E ; |    XXX | $DAEB
    .byte $08 ; |    X   | $DAEC
    .byte $0E ; |    XXX | $DAED
    .byte $04 ; |     X  | $DAEE
    .byte $04 ; |     X  | $DAEF
    .byte $02 ; |      X | $DAF0
    .byte $02 ; |      X | $DAF1
    .byte $0E ; |    XXX | $DAF2
    .byte $0E ; |    XXX | $DAF3
LDAF4:
    .byte $0A ; |    X X | $DAF4
    .byte $0E ; |    XXX | $DAF5
    .byte $0A ; |    X X | $DAF6
    .byte $0E ; |    XXX | $DAF7
    .byte $0E ; |    XXX | $DAF8
    .byte $02 ; |      X | $DAF9
    .byte $0E ; |    XXX | $DAFA
    .byte $0A ; |    X X | $DAFB
    .byte $0E ; |    XXX | $DAFC
    .byte $7E ; | XXXXXX | $DAFD
    .byte $3C ; |  XXXX  | $DAFE
    .byte $18 ; |   XX   | $DAFF
    .byte $C3 ; |XX    XX| $DB00
    .byte $DB ; |XX XX XX| $DB01
    .byte $C3 ; |XX    XX| $DB02
    .byte $DB ; |XX XX XX| $DB03
    .byte $C3 ; |XX    XX| $DB04
    .byte $C3 ; |XX    XX| $DB05
    .byte $7E ; | XXXXXX | $DB06
    .byte $66 ; | XX  XX | $DB07
    .byte $66 ; | XX  XX | $DB08
    .byte $66 ; | XX  XX | $DB09
    .byte $00 ; |        | $DB0A
    .byte $C3 ; |XX    XX| $DB0B
    .byte $CF ; |XX  XXXX| $DB0C
    .byte $C3 ; |XX    XX| $DB0D
    .byte $DB ; |XX XX XX| $DB0E
    .byte $C3 ; |XX    XX| $DB0F
    .byte $C3 ; |XX    XX| $DB10
    .byte $3E ; |  XXXXX | $DB11
    .byte $C4 ; |XX   X  | $DB12
    .byte $C4 ; |XX   X  | $DB13
    .byte $C4 ; |XX   X  | $DB14
    .byte $00 ; |        | $DB15
    .byte $00 ; |        | $DB16
    .byte $00 ; |        | $DB17
    .byte $00 ; |        | $DB18
    .byte $00 ; |        | $DB19
    .byte $00 ; |        | $DB1A
    .byte $28 ; |  X X   | $DB1B
    .byte $00 ; |        | $DB1C
    .byte $00 ; |        | $DB1D
    .byte $00 ; |        | $DB1E
    .byte $00 ; |        | $DB1F
    .byte $18 ; |   XX   | $DB20
    .byte $3C ; |  XXXX  | $DB21
    .byte $18 ; |   XX   | $DB22
LDB23:
    .byte $00 ; |        | $DB23
    .byte $00 ; |        | $DB24
    .byte $00 ; |        | $DB25
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
    .byte $01 ; |       X| $DB38
    .byte $C3 ; |XX    XX| $DB39
    .byte $F3 ; |XXXX  XX| $DB3A
    .byte $C3 ; |XX    XX| $DB3B
    .byte $DB ; |XX XX XX| $DB3C
    .byte $C3 ; |XX    XX| $DB3D
    .byte $C3 ; |XX    XX| $DB3E
    .byte $7C ; | XXXXX  | $DB3F
    .byte $23 ; |  X   XX| $DB40
    .byte $23 ; |  X   XX| $DB41
    .byte $23 ; |  X   XX| $DB42
    .byte $00 ; |        | $DB43
    .byte $46 ; | X   XX | $DB44
    .byte $FF ; |XXXXXXXX| $DB45
    .byte $00 ; |        | $DB46
    .byte $46 ; | X   XX | $DB47
    .byte $FF ; |XXXXXXXX| $DB48
    .byte $FF ; |XXXXXXXX| $DB49
    .byte $46 ; | X   XX | $DB4A
    .byte $00 ; |        | $DB4B
    .byte $46 ; | X   XX | $DB4C
    .byte $00 ; |        | $DB4D
    .byte $C0 ; |XX      | $DB4E
    .byte $C0 ; |XX      | $DB4F
    .byte $40 ; | X      | $DB50
    .byte $C0 ; |XX      | $DB51
    .byte $C0 ; |XX      | $DB52
    .byte $00 ; |        | $DB53
    .byte $80 ; |X       | $DB54
    .byte $C0 ; |XX      | $DB55
    .byte $C0 ; |XX      | $DB56
    .byte $00 ; |        | $DB57
    .byte $00 ; |        | $DB58
    .byte $3C ; |  XXXX  | $DB59
    .byte $66 ; | XX  XX | $DB5A
    .byte $42 ; | X    X | $DB5B
    .byte $42 ; | X    X | $DB5C
    .byte $66 ; | XX  XX | $DB5D
    .byte $24 ; |  X  X  | $DB5E
    .byte $18 ; |   XX   | $DB5F
    .byte $00 ; |        | $DB60
    .byte $00 ; |        | $DB61
    .byte $24 ; |  X  X  | $DB62
    .byte $42 ; | X    X | $DB63
    .byte $81 ; |X      X| $DB64
    .byte $42 ; | X    X | $DB65
    .byte $00 ; |        | $DB66
    .byte $24 ; |  X  X  | $DB67
    .byte $18 ; |   XX   | $DB68
    .byte $00 ; |        | $DB69
    .byte $00 ; |        | $DB6A
    .byte $00 ; |        | $DB6B
    .byte $00 ; |        | $DB6C
    .byte $08 ; |    X   | $DB6D
    .byte $00 ; |        | $DB6E
    .byte $28 ; |  X X   | $DB6F
    .byte $00 ; |        | $DB70
    .byte $00 ; |        | $DB71
    .byte $08 ; |    X   | $DB72
    .byte $00 ; |        | $DB73
    .byte $DB ; |XX XX XX| $DB74
    .byte $5A ; | X XX X | $DB75
    .byte $18 ; |   XX   | $DB76
    .byte $66 ; | XX  XX | $DB77
LDB78:
    .byte $66 ; | XX  XX | $DB78
    .byte $5A ; | X XX X | $DB79
    .byte $53 ; | X X  XX| $DB7A
    .byte $18 ; |   XX   | $DB7B
LDB7C:
    .byte $00 ; |        | $DB7C
    .byte $00 ; |        | $DB7D
    .byte $02 ; |      X | $DB7E
    .byte $02 ; |      X | $DB7F
    .byte $02 ; |      X | $DB80
    .byte $35 ; |  XX X X| $DB81
    .byte $25 ; |  X  X X| $DB82
    .byte $15 ; |   X X X| $DB83
LDB84:
    .byte $FF ; |XXXXXXXX| $DB84
    .byte $0F ; |    XXXX| $DB85
    .byte $07 ; |     XXX| $DB86
    .byte $07 ; |     XXX| $DB87
    .byte $03 ; |      XX| $DB88
    .byte $03 ; |      XX| $DB89
    .byte $03 ; |      XX| $DB8A
    .byte $03 ; |      XX| $DB8B
LDB8C:
    .byte $12 ; |   X  X | $DB8C
    .byte $9E ; |X  XXXX | $DB8D
    .byte $52 ; | X X  X | $DB8E
    .byte $D2 ; |XX X  X | $DB8F
    .byte $00 ; |        | $DB90
LDB91:
    .byte $FE ; |XXXXXXX | $DB91
    .byte $FD ; |XXXXXX X| $DB92
    .byte $FC ; |XXXXXX  | $DB93
    .byte $FB ; |XXXXX XX| $DB94
    .byte $FA ; |XXXXX X | $DB95
    .byte $F9 ; |XXXXX  X| $DB96
    .byte $F8 ; |XXXXX   | $DB97
    .byte $07 ; |     XXX| $DB98
    .byte $06 ; |     XX | $DB99
    .byte $05 ; |     X X| $DB9A
    .byte $04 ; |     X  | $DB9B
    .byte $03 ; |      XX| $DB9C
    .byte $02 ; |      X | $DB9D
    .byte $01 ; |       X| $DB9E
    .byte $00 ; |        | $DB9F
    .byte $FF ; |XXXXXXXX| $DBA0
LDBA1:
    .byte $F7 ; |XXXX XXX| $DBA1
    .byte $84 ; |X    X  | $DBA2
    .byte $F4 ; |XXXX X  | $DBA3
    .byte $14 ; |   X X  | $DBA4
    .byte $F7 ; |XXXX XXX| $DBA5
LDBA6:
    .byte $FF ; |XXXXXXXX| $DBA6
    .byte $00 ; |        | $DBA7
    .byte $3C ; |  XXXX  | $DBA8
    .byte $7E ; | XXXXXX | $DBA9
    .byte $C3 ; |XX    XX| $DBAA
    .byte $CF ; |XX  XXXX| $DBAB
    .byte $CF ; |XX  XXXX| $DBAC
    .byte $C0 ; |XX      | $DBAD
    .byte $C3 ; |XX    XX| $DBAE
    .byte $7E ; | XXXXXX | $DBAF
    .byte $3C ; |  XXXX  | $DBB0
LDBB1:
    .byte $97 ; |X  X XXX| $DBB1
    .byte $92 ; |X  X  X | $DBB2
    .byte $F2 ; |XXXX  X | $DBB3
    .byte $92 ; |X  X  X | $DBB4
    .byte $97 ; |X  X XXX| $DBB5
LDBB6:
    .byte $E6 ; |XXX  XX | $DBB6
    .byte $89 ; |X   X  X| $DBB7
    .byte $89 ; |X   X  X| $DBB8
    .byte $89 ; |X   X  X| $DBB9
    .byte $86 ; |X    XX | $DBBA
LDBBB:
    .byte $33 ; |  XX  XX| $DBBB
    .byte $32 ; |  XX  X | $DBBC
    .byte $31 ; |  XX   X| $DBBD
    .byte $30 ; |  XX    | $DBBE
    .byte $2F ; |  X XXXX| $DBBF
    .byte $2E ; |  X XXX | $DBC0
    .byte $2D ; |  X XX X| $DBC1
    .byte $2C ; |  X XX  | $DBC2
    .byte $2B ; |  X X XX| $DBC3
    .byte $2A ; |  X X X | $DBC4
    .byte $29 ; |  X X  X| $DBC5
    .byte $28 ; |  X X   | $DBC6
    .byte $27 ; |  X  XXX| $DBC7
    .byte $26 ; |  X  XX | $DBC8
    .byte $25 ; |  X  X X| $DBC9
    .byte $24 ; |  X  X  | $DBCA
    .byte $23 ; |  X   XX| $DBCB
    .byte $22 ; |  X   X | $DBCC
    .byte $21 ; |  X    X| $DBCD
    .byte $20 ; |  X     | $DBCE
    .byte $1F ; |   XXXXX| $DBCF
    .byte $1E ; |   XXXX | $DBD0
    .byte $1D ; |   XXX X| $DBD1
    .byte $1C ; |   XXX  | $DBD2
    .byte $1B ; |   XX XX| $DBD3
    .byte $1A ; |   XX X | $DBD4
    .byte $19 ; |   XX  X| $DBD5
    .byte $18 ; |   XX   | $DBD6
    .byte $17 ; |   X XXX| $DBD7
    .byte $16 ; |   X XX | $DBD8
    .byte $15 ; |   X X X| $DBD9
    .byte $14 ; |   X X  | $DBDA
    .byte $13 ; |   X  XX| $DBDB
    .byte $12 ; |   X  X | $DBDC
    .byte $11 ; |   X   X| $DBDD
    .byte $10 ; |   X    | $DBDE
    .byte $0F ; |    XXXX| $DBDF
    .byte $0E ; |    XXX | $DBE0
    .byte $0D ; |    XX X| $DBE1
    .byte $0C ; |    XX  | $DBE2
    .byte $0B ; |    X XX| $DBE3
    .byte $0A ; |    X X | $DBE4
    .byte $09 ; |    X  X| $DBE5
    .byte $08 ; |    X   | $DBE6
    .byte $07 ; |     XXX| $DBE7
    .byte $06 ; |     XX | $DBE8
    .byte $05 ; |     X X| $DBE9
    .byte $04 ; |     X  | $DBEA
    .byte $03 ; |      XX| $DBEB
    .byte $02 ; |      X | $DBEC
    .byte $01 ; |       X| $DBED
    .byte $00 ; |        | $DBEE
    .byte $00 ; |        | $DBEF
    .byte $00 ; |        | $DBF0
    .byte $00 ; |        | $DBF1
    .byte $00 ; |        | $DBF2
    .byte $00 ; |        | $DBF3
    .byte $00 ; |        | $DBF4
LDBF5:
    .byte $00 ; |        | $DBF5
    .byte $00 ; |        | $DBF6
    .byte $7F ; | XXXXXXX| $DBF7
    .byte $FB ; |XXXXX XX| $DBF8
    .byte $BE ; |X XXXXX | $DBF9
    .byte $FC ; |XXXXXX  | $DBFA
    .byte $E8 ; |XXX X   | $DBFB
    .byte $58 ; | X XX   | $DBFC
    .byte $78 ; | XXXX   | $DBFD
    .byte $30 ; |  XX    | $DBFE
    .byte $30 ; |  XX    | $DBFF
    .byte $38 ; |  XXX   | $DC00
    .byte $6C ; | XX XX  | $DC01
    .byte $C6 ; |XX   XX | $DC02
    .byte $C6 ; |XX   XX | $DC03
    .byte $C6 ; |XX   XX | $DC04
    .byte $6C ; | XX XX  | $DC05
    .byte $38 ; |  XXX   | $DC06
    .byte $00 ; |        | $DC07
    .byte $7E ; | XXXXXX | $DC08
    .byte $18 ; |   XX   | $DC09
    .byte $18 ; |   XX   | $DC0A
    .byte $18 ; |   XX   | $DC0B
    .byte $18 ; |   XX   | $DC0C
    .byte $38 ; |  XXX   | $DC0D
    .byte $18 ; |   XX   | $DC0E
    .byte $00 ; |        | $DC0F
    .byte $FE ; |XXXXXXX | $DC10
    .byte $C0 ; |XX      | $DC11
    .byte $E0 ; |XXX     | $DC12
    .byte $3C ; |  XXXX  | $DC13
    .byte $06 ; |     XX | $DC14
    .byte $C6 ; |XX   XX | $DC15
    .byte $7C ; | XXXXX  | $DC16
    .byte $00 ; |        | $DC17
    .byte $FC ; |XXXXXX  | $DC18
    .byte $06 ; |     XX | $DC19
    .byte $06 ; |     XX | $DC1A
    .byte $7C ; | XXXXX  | $DC1B
    .byte $06 ; |     XX | $DC1C
    .byte $06 ; |     XX | $DC1D
    .byte $FC ; |XXXXXX  | $DC1E
    .byte $00 ; |        | $DC1F
    .byte $0C ; |    XX  | $DC20
    .byte $0C ; |    XX  | $DC21
    .byte $0C ; |    XX  | $DC22
    .byte $FE ; |XXXXXXX | $DC23
    .byte $CC ; |XX  XX  | $DC24
    .byte $CC ; |XX  XX  | $DC25
    .byte $CC ; |XX  XX  | $DC26
    .byte $00 ; |        | $DC27
    .byte $FC ; |XXXXXX  | $DC28
    .byte $06 ; |     XX | $DC29
    .byte $06 ; |     XX | $DC2A
    .byte $FC ; |XXXXXX  | $DC2B
    .byte $C0 ; |XX      | $DC2C
    .byte $C0 ; |XX      | $DC2D
    .byte $FC ; |XXXXXX  | $DC2E
    .byte $00 ; |        | $DC2F
    .byte $7C ; | XXXXX  | $DC30
    .byte $C6 ; |XX   XX | $DC31
    .byte $C6 ; |XX   XX | $DC32
    .byte $FC ; |XXXXXX  | $DC33
    .byte $C0 ; |XX      | $DC34
    .byte $C0 ; |XX      | $DC35
    .byte $7C ; | XXXXX  | $DC36
    .byte $00 ; |        | $DC37
    .byte $30 ; |  XX    | $DC38
    .byte $30 ; |  XX    | $DC39
    .byte $18 ; |   XX   | $DC3A
    .byte $18 ; |   XX   | $DC3B
    .byte $0C ; |    XX  | $DC3C
    .byte $06 ; |     XX | $DC3D
    .byte $FE ; |XXXXXXX | $DC3E
    .byte $00 ; |        | $DC3F
    .byte $7C ; | XXXXX  | $DC40
    .byte $C6 ; |XX   XX | $DC41
    .byte $C6 ; |XX   XX | $DC42
    .byte $7C ; | XXXXX  | $DC43
    .byte $C6 ; |XX   XX | $DC44
    .byte $C6 ; |XX   XX | $DC45
    .byte $7C ; | XXXXX  | $DC46
    .byte $00 ; |        | $DC47
    .byte $7C ; | XXXXX  | $DC48
    .byte $06 ; |     XX | $DC49
    .byte $06 ; |     XX | $DC4A
    .byte $7E ; | XXXXXX | $DC4B
    .byte $C6 ; |XX   XX | $DC4C
    .byte $C6 ; |XX   XX | $DC4D
    .byte $7C ; | XXXXX  | $DC4E
    .byte $00 ; |        | $DC4F
    .byte $38 ; |  XXX   | $DC50
    .byte $6C ; | XX XX  | $DC51
    .byte $C6 ; |XX   XX | $DC52
    .byte $C6 ; |XX   XX | $DC53
    .byte $C6 ; |XX   XX | $DC54
    .byte $6C ; | XX XX  | $DC55
    .byte $38 ; |  XXX   | $DC56
    .byte $00 ; |        | $DC57
    .byte $00 ; |        | $DC58
    .byte $00 ; |        | $DC59
    .byte $24 ; |  X  X  | $DC5A
    .byte $24 ; |  X  X  | $DC5B
    .byte $6C ; | XX XX  | $DC5C
    .byte $6C ; | XX XX  | $DC5D
    .byte $54 ; | X X X  | $DC5E
    .byte $AA ; |X X X X | $DC5F
    .byte $54 ; | X X X  | $DC60
    .byte $AA ; |X X X X | $DC61
    .byte $54 ; | X X X  | $DC62
    .byte $AA ; |X X X X | $DC63
    .byte $54 ; | X X X  | $DC64
LDC65:
    .byte $AA ; |X X X X | $DC65
    .byte $AA ; |X X X X | $DC66
LDC67:
    .byte $AA ; |X X X X | $DC67
    .byte $AA ; |X X X X | $DC68
LDC69:
    .byte $55 ; | X X X X| $DC69
    .byte $55 ; | X X X X| $DC6A
LDC6B:
    .byte $55 ; | X X X X| $DC6B
    .byte $55 ; | X X X X| $DC6C
    .byte $AA ; |X X X X | $DC6D
    .byte $AA ; |X X X X | $DC6E
    .byte $AA ; |X X X X | $DC6F
    .byte $AA ; |X X X X | $DC70
    .byte $55 ; | X X X X| $DC71
    .byte $55 ; | X X X X| $DC72
    .byte $55 ; | X X X X| $DC73
    .byte $55 ; | X X X X| $DC74
    .byte $AA ; |X X X X | $DC75
    .byte $AA ; |X X X X | $DC76
    .byte $AA ; |X X X X | $DC77
    .byte $AA ; |X X X X | $DC78
    .byte $55 ; | X X X X| $DC79
    .byte $55 ; | X X X X| $DC7A
    .byte $55 ; | X X X X| $DC7B
    .byte $55 ; | X X X X| $DC7C
    .byte $AA ; |X X X X | $DC7D
    .byte $AA ; |X X X X | $DC7E
    .byte $AA ; |X X X X | $DC7F
    .byte $AA ; |X X X X | $DC80
    .byte $55 ; | X X X X| $DC81
    .byte $55 ; | X X X X| $DC82
    .byte $55 ; | X X X X| $DC83
    .byte $55 ; | X X X X| $DC84
    .byte $AA ; |X X X X | $DC85
    .byte $AA ; |X X X X | $DC86
    .byte $AA ; |X X X X | $DC87
    .byte $AA ; |X X X X | $DC88
    .byte $55 ; | X X X X| $DC89
    .byte $55 ; | X X X X| $DC8A
    .byte $55 ; | X X X X| $DC8B
    .byte $55 ; | X X X X| $DC8C
    .byte $AA ; |X X X X | $DC8D
    .byte $AA ; |X X X X | $DC8E
    .byte $AA ; |X X X X | $DC8F
    .byte $AA ; |X X X X | $DC90
    .byte $55 ; | X X X X| $DC91
    .byte $55 ; | X X X X| $DC92
LDC93:
    .byte $55 ; | X X X X| $DC93
    .byte $55 ; | X X X X| $DC94
    .byte $53 ; | X X  XX| $DC95
    .byte $50 ; | X X    | $DC96
    .byte $48 ; | X  X   | $DC97
LDC98:
    .byte $8A ; |X   X X | $DC98
    .byte $AB ; |X X X XX| $DC99
    .byte $DA ; |XX XX X | $DC9A
    .byte $8B ; |X   X XX| $DC9B
    .byte $00 ; |        | $DC9C
    .byte $00 ; |        | $DC9D
    .byte $00 ; |        | $DC9E
    .byte $02 ; |      X | $DC9F
    .byte $02 ; |      X | $DCA0
    .byte $02 ; |      X | $DCA1
    .byte $00 ; |        | $DCA2
    .byte $00 ; |        | $DCA3
    .byte $00 ; |        | $DCA4
    .byte $00 ; |        | $DCA5
    .byte $00 ; |        | $DCA6
    .byte $00 ; |        | $DCA7
    .byte $00 ; |        | $DCA8
    .byte $00 ; |        | $DCA9
    .byte $02 ; |      X | $DCAA
    .byte $02 ; |      X | $DCAB
    .byte $00 ; |        | $DCAC
    .byte $00 ; |        | $DCAD
    .byte $00 ; |        | $DCAE
    .byte $00 ; |        | $DCAF
    .byte $00 ; |        | $DCB0
    .byte $00 ; |        | $DCB1
    .byte $02 ; |      X | $DCB2
    .byte $00 ; |        | $DCB3
    .byte $00 ; |        | $DCB4
    .byte $00 ; |        | $DCB5
    .byte $00 ; |        | $DCB6
    .byte $00 ; |        | $DCB7
    .byte $02 ; |      X | $DCB8
    .byte $00 ; |        | $DCB9
    .byte $00 ; |        | $DCBA
    .byte $00 ; |        | $DCBB
    .byte $02 ; |      X | $DCBC
    .byte $00 ; |        | $DCBD
    .byte $00 ; |        | $DCBE
    .byte $02 ; |      X | $DCBF
    .byte $00 ; |        | $DCC0
    .byte $02 ; |      X | $DCC1
    .byte $00 ; |        | $DCC2
    .byte $02 ; |      X | $DCC3
    .byte $00 ; |        | $DCC4
    .byte $02 ; |      X | $DCC5
    .byte $00 ; |        | $DCC6
    .byte $02 ; |      X | $DCC7
    .byte $00 ; |        | $DCC8
    .byte $02 ; |      X | $DCC9
    .byte $00 ; |        | $DCCA
    .byte $02 ; |      X | $DCCB
    .byte $00 ; |        | $DCCC
    .byte $00 ; |        | $DCCD
    .byte $00 ; |        | $DCCE
    .byte $00 ; |        | $DCCF
    .byte $00 ; |        | $DCD0
    .byte $00 ; |        | $DCD1
    .byte $00 ; |        | $DCD2
    .byte $00 ; |        | $DCD3
    .byte $00 ; |        | $DCD4
    .byte $02 ; |      X | $DCD5
    .byte $02 ; |      X | $DCD6
    .byte $02 ; |      X | $DCD7
    .byte $00 ; |        | $DCD8
    .byte $00 ; |        | $DCD9
    .byte $00 ; |        | $DCDA
    .byte $00 ; |        | $DCDB
    .byte $00 ; |        | $DCDC
    .byte $00 ; |        | $DCDD
    .byte $00 ; |        | $DCDE
    .byte $02 ; |      X | $DCDF
    .byte $02 ; |      X | $DCE0
    .byte $00 ; |        | $DCE1
    .byte $00 ; |        | $DCE2
    .byte $00 ; |        | $DCE3
    .byte $00 ; |        | $DCE4
    .byte $00 ; |        | $DCE5
    .byte $02 ; |      X | $DCE6
    .byte $00 ; |        | $DCE7
    .byte $00 ; |        | $DCE8
    .byte $00 ; |        | $DCE9
    .byte $00 ; |        | $DCEA
    .byte $02 ; |      X | $DCEB
    .byte $00 ; |        | $DCEC
    .byte $00 ; |        | $DCED
    .byte $02 ; |      X | $DCEE
    .byte $00 ; |        | $DCEF
    .byte $00 ; |        | $DCF0
    .byte $02 ; |      X | $DCF1
    .byte $00 ; |        | $DCF2
    .byte $02 ; |      X | $DCF3
    .byte $00 ; |        | $DCF4
    .byte $02 ; |      X | $DCF5
    .byte $00 ; |        | $DCF6
    .byte $02 ; |      X | $DCF7
    .byte $00 ; |        | $DCF8
    .byte $02 ; |      X | $DCF9
    .byte $00 ; |        | $DCFA
    .byte $02 ; |      X | $DCFB
    .byte $00 ; |        | $DCFC
    .byte $02 ; |      X | $DCFD
    .byte $63 ; | XX   XX| $DCFE
    .byte $72 ; | XXX  X | $DCFF
LDD00:
    .byte $1C ; |   XXX  | $DD00
    .byte $57 ; | X X XXX| $DD01
    .byte $60 ; | XX     | $DD02
    .byte $73 ; | XXX  XX| $DD03
LDD04:
    .byte $0F ; |    XXXX| $DD04
    .byte $1F ; |   XXXXX| $DD05
    .byte $3C ; |  XXXX  | $DD06
    .byte $30 ; |  XX    | $DD07
    .byte $70 ; | XXX    | $DD08
    .byte $60 ; | XX     | $DD09
    .byte $E0 ; |XXX     | $DD0A
    .byte $D4 ; |XX X X  | $DD0B
    .byte $D4 ; |XX X X  | $DD0C
    .byte $DC ; |XX XXX  | $DD0D
    .byte $D4 ; |XX X X  | $DD0E
    .byte $D4 ; |XX X X  | $DD0F
    .byte $C9 ; |XX  X  X| $DD10
    .byte $C0 ; |XX      | $DD11
    .byte $C0 ; |XX      | $DD12
    .byte $C0 ; |XX      | $DD13
    .byte $C0 ; |XX      | $DD14
    .byte $C0 ; |XX      | $DD15
    .byte $C0 ; |XX      | $DD16
    .byte $C0 ; |XX      | $DD17
    .byte $C0 ; |XX      | $DD18
    .byte $D1 ; |XX X   X| $DD19
    .byte $D1 ; |XX X   X| $DD1A
    .byte $D1 ; |XX X   X| $DD1B
    .byte $DD ; |XX XXX X| $DD1C
    .byte $D5 ; |XX X X X| $DD1D
    .byte $D5 ; |XX X X X| $DD1E
    .byte $DD ; |XX XXX X| $DD1F
    .byte $C0 ; |XX      | $DD20
    .byte $C0 ; |XX      | $DD21
    .byte $E0 ; |XXX     | $DD22
    .byte $E0 ; |XXX     | $DD23
    .byte $E0 ; |XXX     | $DD24
    .byte $70 ; | XXX    | $DD25
    .byte $70 ; | XXX    | $DD26
    .byte $38 ; |  XXX   | $DD27
    .byte $3C ; |  XXXX  | $DD28
    .byte $1C ; |   XXX  | $DD29
    .byte $1F ; |   XXXXX| $DD2A
    .byte $0F ; |    XXXX| $DD2B
    .byte $03 ; |      XX| $DD2C
LDD2D:
    .byte $F0 ; |XXXX    | $DD2D
    .byte $F8 ; |XXXXX   | $DD2E
    .byte $1C ; |   XXX  | $DD2F
    .byte $0C ; |    XX  | $DD30
    .byte $06 ; |     XX | $DD31
    .byte $06 ; |     XX | $DD32
    .byte $06 ; |     XX | $DD33
    .byte $56 ; | X X XX | $DD34
    .byte $56 ; | X X XX | $DD35
    .byte $97 ; |X  X XXX| $DD36
    .byte $57 ; | X X XXX| $DD37
    .byte $57 ; | X X XXX| $DD38
    .byte $93 ; |X  X  XX| $DD39
    .byte $01 ; |       X| $DD3A
    .byte $02 ; |      X | $DD3B
    .byte $05 ; |     X X| $DD3C
    .byte $05 ; |     X X| $DD3D
    .byte $05 ; |     X X| $DD3E
    .byte $02 ; |      X | $DD3F
    .byte $01 ; |       X| $DD40
    .byte $00 ; |        | $DD41
    .byte $25 ; |  X  X X| $DD42
    .byte $25 ; |  X  X X| $DD43
    .byte $25 ; |  X  X X| $DD44
    .byte $25 ; |  X  X X| $DD45
    .byte $25 ; |  X  X X| $DD46
    .byte $25 ; |  X  X X| $DD47
    .byte $75 ; | XXX X X| $DD48
    .byte $00 ; |        | $DD49
    .byte $00 ; |        | $DD4A
    .byte $BB ; |X XXX XX| $DD4B
    .byte $A2 ; |X X   X | $DD4C
    .byte $A2 ; |X X   X | $DD4D
    .byte $A3 ; |X X   XX| $DD4E
    .byte $A2 ; |X X   X | $DD4F
    .byte $A2 ; |X X   X | $DD50
    .byte $A3 ; |X X   XX| $DD51
    .byte $00 ; |        | $DD52
    .byte $00 ; |        | $DD53
    .byte $FF ; |XXXXXXXX| $DD54
    .byte $FF ; |XXXXXXXX| $DD55
LDD56:
    .byte $0F ; |    XXXX| $DD56
    .byte $1F ; |   XXXXX| $DD57
    .byte $38 ; |  XXX   | $DD58
    .byte $30 ; |  XX    | $DD59
    .byte $60 ; | XX     | $DD5A
    .byte $60 ; | XX     | $DD5B
    .byte $60 ; | XX     | $DD5C
    .byte $68 ; | XX X   | $DD5D
    .byte $68 ; | XX X   | $DD5E
    .byte $EB ; |XXX X XX| $DD5F
    .byte $EA ; |XXX X X | $DD60
    .byte $CB ; |XX  X XX| $DD61
    .byte $00 ; |        | $DD62
    .byte $80 ; |X       | $DD63
    .byte $40 ; | X      | $DD64
    .byte $A0 ; |X X     | $DD65
    .byte $20 ; |  X     | $DD66
    .byte $A0 ; |X X     | $DD67
    .byte $40 ; | X      | $DD68
    .byte $80 ; |X       | $DD69
    .byte $00 ; |        | $DD6A
    .byte $D1 ; |XX X   X| $DD6B
    .byte $53 ; | X X  XX| $DD6C
    .byte $53 ; | X X  XX| $DD6D
    .byte $55 ; | X X X X| $DD6E
    .byte $59 ; | X XX  X| $DD6F
    .byte $59 ; | X XX  X| $DD70
    .byte $D1 ; |XX X   X| $DD71
    .byte $01 ; |       X| $DD72
    .byte $01 ; |       X| $DD73
    .byte $81 ; |X      X| $DD74
    .byte $01 ; |       X| $DD75
    .byte $01 ; |       X| $DD76
    .byte $81 ; |X      X| $DD77
    .byte $01 ; |       X| $DD78
    .byte $01 ; |       X| $DD79
    .byte $81 ; |X      X| $DD7A
    .byte $01 ; |       X| $DD7B
    .byte $00 ; |        | $DD7C
LDD7D:
    .byte $FF ; |XXXXXXXX| $DD7D
    .byte $FF ; |XXXXXXXX| $DD7E
    .byte $00 ; |        | $DD7F
    .byte $00 ; |        | $DD80
    .byte $00 ; |        | $DD81
    .byte $00 ; |        | $DD82
    .byte $00 ; |        | $DD83
    .byte $95 ; |X  X X X| $DD84
    .byte $95 ; |X  X X X| $DD85
    .byte $9D ; |X  XXX X| $DD86
    .byte $95 ; |X  X X X| $DD87
    .byte $95 ; |X  X X X| $DD88
    .byte $C9 ; |XX  X  X| $DD89
    .byte $00 ; |        | $DD8A
    .byte $00 ; |        | $DD8B
    .byte $00 ; |        | $DD8C
    .byte $00 ; |        | $DD8D
    .byte $00 ; |        | $DD8E
    .byte $00 ; |        | $DD8F
    .byte $00 ; |        | $DD90
    .byte $00 ; |        | $DD91
    .byte $DD ; |XX XXX X| $DD92
    .byte $45 ; | X   X X| $DD93
    .byte $45 ; | X   X X| $DD94
    .byte $5D ; | X XXX X| $DD95
    .byte $51 ; | X X   X| $DD96
    .byte $51 ; | X X   X| $DD97
    .byte $DD ; |XX XXX X| $DD98
    .byte $00 ; |        | $DD99
    .byte $00 ; |        | $DD9A
    .byte $23 ; |  X   XX| $DD9B
    .byte $22 ; |  X   X | $DD9C
    .byte $22 ; |  X   X | $DD9D
    .byte $3A ; |  XXX X | $DD9E
    .byte $2A ; |  X X X | $DD9F
    .byte $2A ; |  X X X | $DDA0
    .byte $3B ; |  XXX XX| $DDA1
    .byte $00 ; |        | $DDA2
    .byte $80 ; |X       | $DDA3
LDDA4:
    .byte $FF ; |XXXXXXXX| $DDA4
    .byte $FF ; |XXXXXXXX| $DDA5
    .byte $01 ; |       X| $DDA6
    .byte $00 ; |        | $DDA7
    .byte $00 ; |        | $DDA8
    .byte $00 ; |        | $DDA9
    .byte $00 ; |        | $DDAA
    .byte $BB ; |X XXX XX| $DDAB
    .byte $A8 ; |X X X   | $DDAC
    .byte $BB ; |X XXX XX| $DDAD
    .byte $A8 ; |X X X   | $DDAE
    .byte $BB ; |X XXX XX| $DDAF
    .byte $00 ; |        | $DDB0
    .byte $00 ; |        | $DDB1
    .byte $01 ; |       X| $DDB2
    .byte $07 ; |     XXX| $DDB3
    .byte $1F ; |   XXXXX| $DDB4
    .byte $3C ; |  XXXX  | $DDB5
    .byte $38 ; |  XXX   | $DDB6
    .byte $30 ; |  XX    | $DDB7
    .byte $70 ; | XXX    | $DDB8
    .byte $70 ; | XXX    | $DDB9
    .byte $70 ; | XXX    | $DDBA
    .byte $71 ; | XXX   X| $DDBB
    .byte $3A ; |  XXX X | $DDBC
    .byte $3D ; |  XXXX X| $DDBD
    .byte $1A ; |   XX X | $DDBE
    .byte $15 ; |   X X X| $DDBF
    .byte $AA ; |X X X X | $DDC0
    .byte $55 ; | X X X X| $DDC1
    .byte $AA ; |X X X X | $DDC2
    .byte $55 ; | X X X X| $DDC3
    .byte $AA ; |X X X X | $DDC4
    .byte $54 ; | X X X  | $DDC5
    .byte $A8 ; |X X X   | $DDC6
    .byte $50 ; | X X    | $DDC7
    .byte $A0 ; |X X     | $DDC8
    .byte $00 ; |        | $DDC9
    .byte $01 ; |       X| $DDCA
    .byte $FF ; |XXXXXXXX| $DDCB
    .byte $FF ; |XXXXXXXX| $DDCC
LDDCD:
    .byte $00 ; |        | $DDCD
    .byte $80 ; |X       | $DDCE
    .byte $C0 ; |XX      | $DDCF
    .byte $E0 ; |XXX     | $DDD0
    .byte $60 ; | XX     | $DDD1
    .byte $70 ; | XXX    | $DDD2
    .byte $30 ; |  XX    | $DDD3
    .byte $B0 ; |X XX    | $DDD4
    .byte $B0 ; |X XX    | $DDD5
    .byte $B0 ; |X XX    | $DDD6
    .byte $B0 ; |X XX    | $DDD7
    .byte $B0 ; |X XX    | $DDD8
    .byte $70 ; | XXX    | $DDD9
    .byte $70 ; | XXX    | $DDDA
    .byte $E0 ; |XXX     | $DDDB
    .byte $C0 ; |XX      | $DDDC
    .byte $00 ; |        | $DDDD
    .byte $00 ; |        | $DDDE
    .byte $00 ; |        | $DDDF
    .byte $00 ; |        | $DDE0
    .byte $00 ; |        | $DDE1
    .byte $00 ; |        | $DDE2
    .byte $00 ; |        | $DDE3
    .byte $40 ; | X      | $DDE4
    .byte $A0 ; |X X     | $DDE5
    .byte $40 ; | X      | $DDE6
    .byte $A0 ; |X X     | $DDE7
    .byte $40 ; | X      | $DDE8
    .byte $B8 ; |X XXX   | $DDE9
    .byte $5C ; | X XXX  | $DDEA
    .byte $BE ; |X XXXXX | $DDEB
    .byte $4E ; | X  XXX | $DDEC
    .byte $07 ; |     XXX| $DDED
    .byte $03 ; |      XX| $DDEE
    .byte $03 ; |      XX| $DDEF
    .byte $07 ; |     XXX| $DDF0
    .byte $0E ; |    XXX | $DDF1
    .byte $1E ; |   XXXX | $DDF2
    .byte $FC ; |XXXXXX  | $DDF3
    .byte $F8 ; |XXXXX   | $DDF4
    .byte $E0 ; |XXX     | $DDF5
LDDF6:
    .byte $A1 ; |X X    X| $DDF6
    .byte $81 ; |X      X| $DDF7
    .byte $81 ; |X      X| $DDF8
    .byte $81 ; |X      X| $DDF9
    .byte $A1 ; |X X    X| $DDFA
LDDFB:
    .byte $BC ; |X XXXX  | $DDFB
    .byte $A4 ; |X X  X  | $DDFC
    .byte $A4 ; |X X  X  | $DDFD
    .byte $A4 ; |X X  X  | $DDFE
    .byte $BC ; |X XXXX  | $DDFF
    .byte $00 ; |        | $DE00
    .byte $00 ; |        | $DE01
    .byte $00 ; |        | $DE02
    .byte $00 ; |        | $DE03
    .byte $00 ; |        | $DE04
    .byte $00 ; |        | $DE05
    .byte $00 ; |        | $DE06
    .byte $00 ; |        | $DE07
    .byte $00 ; |        | $DE08
    .byte $00 ; |        | $DE09
    .byte $00 ; |        | $DE0A
    .byte $00 ; |        | $DE0B
    .byte $00 ; |        | $DE0C
    .byte $00 ; |        | $DE0D
    .byte $00 ; |        | $DE0E
    .byte $00 ; |        | $DE0F
    .byte $00 ; |        | $DE10
    .byte $00 ; |        | $DE11
    .byte $00 ; |        | $DE12
    .byte $00 ; |        | $DE13
    .byte $00 ; |        | $DE14
    .byte $00 ; |        | $DE15
    .byte $00 ; |        | $DE16
    .byte $00 ; |        | $DE17
    .byte $00 ; |        | $DE18
    .byte $00 ; |        | $DE19
    .byte $00 ; |        | $DE1A
    .byte $00 ; |        | $DE1B
    .byte $00 ; |        | $DE1C
    .byte $00 ; |        | $DE1D
    .byte $00 ; |        | $DE1E
    .byte $00 ; |        | $DE1F
    .byte $00 ; |        | $DE20
    .byte $00 ; |        | $DE21
    .byte $00 ; |        | $DE22
    .byte $00 ; |        | $DE23
    .byte $00 ; |        | $DE24
    .byte $00 ; |        | $DE25
    .byte $00 ; |        | $DE26
    .byte $00 ; |        | $DE27
    .byte $00 ; |        | $DE28
    .byte $00 ; |        | $DE29
    .byte $00 ; |        | $DE2A
    .byte $C6 ; |XX   XX | $DE2B
    .byte $FE ; |XXXXXXX | $DE2C
    .byte $FE ; |XXXXXXX | $DE2D
    .byte $D6 ; |XX X XX | $DE2E
    .byte $54 ; | X X X  | $DE2F
    .byte $7C ; | XXXXX  | $DE30
    .byte $54 ; | X X X  | $DE31
    .byte $00 ; |        | $DE32
    .byte $00 ; |        | $DE33
    .byte $00 ; |        | $DE34
    .byte $00 ; |        | $DE35
    .byte $00 ; |        | $DE36
    .byte $00 ; |        | $DE37
    .byte $00 ; |        | $DE38
    .byte $00 ; |        | $DE39
    .byte $00 ; |        | $DE3A
    .byte $00 ; |        | $DE3B
    .byte $00 ; |        | $DE3C
    .byte $00 ; |        | $DE3D
    .byte $00 ; |        | $DE3E
    .byte $00 ; |        | $DE3F
    .byte $00 ; |        | $DE40
    .byte $00 ; |        | $DE41
    .byte $00 ; |        | $DE42
    .byte $00 ; |        | $DE43
    .byte $00 ; |        | $DE44
    .byte $00 ; |        | $DE45
    .byte $00 ; |        | $DE46
    .byte $00 ; |        | $DE47
    .byte $00 ; |        | $DE48
    .byte $00 ; |        | $DE49
    .byte $00 ; |        | $DE4A
    .byte $00 ; |        | $DE4B
    .byte $00 ; |        | $DE4C
    .byte $00 ; |        | $DE4D
    .byte $00 ; |        | $DE4E
    .byte $00 ; |        | $DE4F
    .byte $00 ; |        | $DE50
    .byte $00 ; |        | $DE51
    .byte $00 ; |        | $DE52
    .byte $00 ; |        | $DE53
    .byte $00 ; |        | $DE54
    .byte $00 ; |        | $DE55
    .byte $00 ; |        | $DE56
    .byte $00 ; |        | $DE57
    .byte $00 ; |        | $DE58
    .byte $00 ; |        | $DE59
    .byte $00 ; |        | $DE5A
    .byte $00 ; |        | $DE5B
    .byte $00 ; |        | $DE5C
    .byte $00 ; |        | $DE5D
    .byte $00 ; |        | $DE5E
    .byte $00 ; |        | $DE5F
    .byte $00 ; |        | $DE60
    .byte $00 ; |        | $DE61
    .byte $00 ; |        | $DE62
    .byte $00 ; |        | $DE63
    .byte $00 ; |        | $DE64
    .byte $00 ; |        | $DE65
    .byte $00 ; |        | $DE66
    .byte $00 ; |        | $DE67
    .byte $00 ; |        | $DE68
    .byte $00 ; |        | $DE69
    .byte $00 ; |        | $DE6A
    .byte $00 ; |        | $DE6B
    .byte $00 ; |        | $DE6C
    .byte $00 ; |        | $DE6D
    .byte $00 ; |        | $DE6E
    .byte $00 ; |        | $DE6F
    .byte $00 ; |        | $DE70
    .byte $00 ; |        | $DE71
    .byte $00 ; |        | $DE72
    .byte $C6 ; |XX   XX | $DE73
    .byte $FE ; |XXXXXXX | $DE74
    .byte $D6 ; |XX X XX | $DE75
    .byte $7C ; | XXXXX  | $DE76
    .byte $54 ; | X X X  | $DE77
    .byte $00 ; |        | $DE78
    .byte $00 ; |        | $DE79
    .byte $00 ; |        | $DE7A
    .byte $00 ; |        | $DE7B
    .byte $00 ; |        | $DE7C
    .byte $00 ; |        | $DE7D
    .byte $00 ; |        | $DE7E
    .byte $00 ; |        | $DE7F
    .byte $00 ; |        | $DE80
    .byte $00 ; |        | $DE81
    .byte $00 ; |        | $DE82
    .byte $00 ; |        | $DE83
    .byte $00 ; |        | $DE84
    .byte $00 ; |        | $DE85
    .byte $00 ; |        | $DE86
    .byte $00 ; |        | $DE87
    .byte $00 ; |        | $DE88
    .byte $00 ; |        | $DE89
    .byte $00 ; |        | $DE8A
    .byte $00 ; |        | $DE8B
    .byte $00 ; |        | $DE8C
    .byte $00 ; |        | $DE8D
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
    .byte $7C ; | XXXXX  | $DE9E
    .byte $7C ; | XXXXX  | $DE9F
    .byte $6C ; | XX XX  | $DEA0
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
    .byte $FE ; |XXXXXXX | $DECB
    .byte $EE ; |XXX XXX | $DECC
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
    .byte $00 ; |        | $DEED
    .byte $00 ; |        | $DEEE
    .byte $00 ; |        | $DEEF
    .byte $00 ; |        | $DEF0
    .byte $00 ; |        | $DEF1
    .byte $00 ; |        | $DEF2
    .byte $00 ; |        | $DEF3
    .byte $00 ; |        | $DEF4
    .byte $00 ; |        | $DEF5
    .byte $00 ; |        | $DEF6
    .byte $00 ; |        | $DEF7
    .byte $00 ; |        | $DEF8
    .byte $00 ; |        | $DEF9
    .byte $00 ; |        | $DEFA
    .byte $38 ; |  XXX   | $DEFB
    .byte $00 ; |        | $DEFC
    .byte $00 ; |        | $DEFD
    .byte $00 ; |        | $DEFE
    .byte $00 ; |        | $DEFF
    .byte $00 ; |        | $DF00
    .byte $00 ; |        | $DF01
    .byte $00 ; |        | $DF02
    .byte $00 ; |        | $DF03
    .byte $00 ; |        | $DF04
    .byte $00 ; |        | $DF05
    .byte $00 ; |        | $DF06
    .byte $00 ; |        | $DF07
    .byte $00 ; |        | $DF08
    .byte $00 ; |        | $DF09
    .byte $00 ; |        | $DF0A
    .byte $00 ; |        | $DF0B
    .byte $00 ; |        | $DF0C
    .byte $00 ; |        | $DF0D
    .byte $00 ; |        | $DF0E
    .byte $00 ; |        | $DF0F
    .byte $00 ; |        | $DF10
    .byte $00 ; |        | $DF11
    .byte $00 ; |        | $DF12
    .byte $00 ; |        | $DF13
    .byte $00 ; |        | $DF14
    .byte $00 ; |        | $DF15
    .byte $00 ; |        | $DF16
    .byte $00 ; |        | $DF17
    .byte $00 ; |        | $DF18
    .byte $00 ; |        | $DF19
    .byte $00 ; |        | $DF1A
    .byte $00 ; |        | $DF1B
    .byte $00 ; |        | $DF1C
    .byte $00 ; |        | $DF1D
    .byte $00 ; |        | $DF1E
    .byte $00 ; |        | $DF1F
    .byte $00 ; |        | $DF20
    .byte $00 ; |        | $DF21
    .byte $00 ; |        | $DF22
    .byte $00 ; |        | $DF23
    .byte $00 ; |        | $DF24
    .byte $00 ; |        | $DF25
    .byte $00 ; |        | $DF26
    .byte $00 ; |        | $DF27
    .byte $00 ; |        | $DF28
    .byte $00 ; |        | $DF29
    .byte $00 ; |        | $DF2A
    .byte $00 ; |        | $DF2B
    .byte $00 ; |        | $DF2C
    .byte $00 ; |        | $DF2D
    .byte $00 ; |        | $DF2E
    .byte $00 ; |        | $DF2F
    .byte $00 ; |        | $DF30
    .byte $00 ; |        | $DF31
    .byte $00 ; |        | $DF32
    .byte $1C ; |   XXX  | $DF33
    .byte $00 ; |        | $DF34
    .byte $00 ; |        | $DF35
    .byte $00 ; |        | $DF36
LDF37:
    .byte $E0 ; |XXX     | $DF37
LDF38:
    .byte $A0 ; |X X     | $DF38
LDF39:
    .byte $A0 ; |X X     | $DF39
LDF3A:
    .byte $A0 ; |X X     | $DF3A
LDF3B:
    .byte $E0 ; |XXX     | $DF3B
    .byte $E0 ; |XXX     | $DF3C
    .byte $40 ; | X      | $DF3D
    .byte $40 ; | X      | $DF3E
    .byte $40 ; | X      | $DF3F
    .byte $C0 ; |XX      | $DF40
    .byte $E0 ; |XXX     | $DF41
    .byte $80 ; |X       | $DF42
    .byte $E0 ; |XXX     | $DF43
    .byte $20 ; |  X     | $DF44
    .byte $E0 ; |XXX     | $DF45
    .byte $E0 ; |XXX     | $DF46
    .byte $20 ; |  X     | $DF47
    .byte $60 ; | XX     | $DF48
    .byte $20 ; |  X     | $DF49
    .byte $E0 ; |XXX     | $DF4A
    .byte $20 ; |  X     | $DF4B
    .byte $20 ; |  X     | $DF4C
    .byte $E0 ; |XXX     | $DF4D
    .byte $A0 ; |X X     | $DF4E
    .byte $A0 ; |X X     | $DF4F
    .byte $E0 ; |XXX     | $DF50
    .byte $20 ; |  X     | $DF51
    .byte $E0 ; |XXX     | $DF52
    .byte $80 ; |X       | $DF53
    .byte $E0 ; |XXX     | $DF54
    .byte $E0 ; |XXX     | $DF55
    .byte $A0 ; |X X     | $DF56
    .byte $E0 ; |XXX     | $DF57
    .byte $80 ; |X       | $DF58
    .byte $E0 ; |XXX     | $DF59
    .byte $40 ; | X      | $DF5A
    .byte $40 ; | X      | $DF5B
    .byte $20 ; |  X     | $DF5C
    .byte $20 ; |  X     | $DF5D
    .byte $E0 ; |XXX     | $DF5E
    .byte $E0 ; |XXX     | $DF5F
    .byte $A0 ; |X X     | $DF60
    .byte $E0 ; |XXX     | $DF61
    .byte $A0 ; |X X     | $DF62
    .byte $E0 ; |XXX     | $DF63
    .byte $E0 ; |XXX     | $DF64
    .byte $20 ; |  X     | $DF65
    .byte $E0 ; |XXX     | $DF66
    .byte $A0 ; |X X     | $DF67
    .byte $E0 ; |XXX     | $DF68
    .byte $44 ; | X   X  | $DF69
    .byte $44 ; | X   X  | $DF6A
    .byte $44 ; | X   X  | $DF6B
    .byte $44 ; | X   X  | $DF6C
    .byte $44 ; | X   X  | $DF6D
    .byte $44 ; | X   X  | $DF6E
    .byte $44 ; | X   X  | $DF6F
    .byte $0E ; |    XXX | $DF70
    .byte $0E ; |    XXX | $DF71
    .byte $0E ; |    XXX | $DF72
    .byte $0E ; |    XXX | $DF73
    .byte $0E ; |    XXX | $DF74
    .byte $0E ; |    XXX | $DF75
    .byte $0E ; |    XXX | $DF76
    .byte $44 ; | X   X  | $DF77
    .byte $44 ; | X   X  | $DF78
    .byte $44 ; | X   X  | $DF79
    .byte $44 ; | X   X  | $DF7A
    .byte $44 ; | X   X  | $DF7B
    .byte $0E ; |    XXX | $DF7C
    .byte $0E ; |    XXX | $DF7D
    .byte $0E ; |    XXX | $DF7E
    .byte $0E ; |    XXX | $DF7F
    .byte $44 ; | X   X  | $DF80
    .byte $44 ; | X   X  | $DF81
    .byte $44 ; | X   X  | $DF82
    .byte $0E ; |    XXX | $DF83
    .byte $0E ; |    XXX | $DF84
    .byte $0E ; |    XXX | $DF85
    .byte $44 ; | X   X  | $DF86
    .byte $44 ; | X   X  | $DF87
    .byte $0C ; |    XX  | $DF88
    .byte $0C ; |    XX  | $DF89
    .byte $42 ; | X    X | $DF8A
    .byte $42 ; | X    X | $DF8B
    .byte $0C ; |    XX  | $DF8C
    .byte $42 ; | X    X | $DF8D
    .byte $0C ; |    XX  | $DF8E
    .byte $42 ; | X    X | $DF8F
    .byte $0A ; |    X X | $DF90
    .byte $42 ; | X    X | $DF91
    .byte $0A ; |    X X | $DF92
    .byte $42 ; | X    X | $DF93
    .byte $08 ; |    X   | $DF94
    .byte $40 ; | X      | $DF95
    .byte $06 ; |     XX | $DF96
    .byte $40 ; | X      | $DF97
    .byte $06 ; |     XX | $DF98
    .byte $88 ; |X   X   | $DF99
    .byte $44 ; | X   X  | $DF9A
    .byte $44 ; | X   X  | $DF9B
    .byte $44 ; | X   X  | $DF9C
    .byte $44 ; | X   X  | $DF9D
    .byte $44 ; | X   X  | $DF9E
    .byte $44 ; | X   X  | $DF9F
    .byte $44 ; | X   X  | $DFA0
    .byte $44 ; | X   X  | $DFA1
    .byte $44 ; | X   X  | $DFA2
    .byte $44 ; | X   X  | $DFA3
    .byte $44 ; | X   X  | $DFA4
    .byte $44 ; | X   X  | $DFA5
    .byte $44 ; | X   X  | $DFA6
    .byte $44 ; | X   X  | $DFA7
    .byte $0E ; |    XXX | $DFA8
    .byte $0E ; |    XXX | $DFA9
    .byte $0E ; |    XXX | $DFAA
    .byte $0E ; |    XXX | $DFAB
    .byte $0E ; |    XXX | $DFAC
    .byte $44 ; | X   X  | $DFAD
    .byte $44 ; | X   X  | $DFAE
    .byte $44 ; | X   X  | $DFAF
    .byte $44 ; | X   X  | $DFB0
    .byte $0E ; |    XXX | $DFB1
    .byte $0E ; |    XXX | $DFB2
    .byte $0E ; |    XXX | $DFB3
    .byte $44 ; | X   X  | $DFB4
    .byte $44 ; | X   X  | $DFB5
    .byte $44 ; | X   X  | $DFB6
    .byte $0E ; |    XXX | $DFB7
    .byte $0E ; |    XXX | $DFB8
    .byte $42 ; | X    X | $DFB9
    .byte $42 ; | X    X | $DFBA
    .byte $0C ; |    XX  | $DFBB
    .byte $0C ; |    XX  | $DFBC
    .byte $42 ; | X    X | $DFBD
    .byte $0C ; |    XX  | $DFBE
    .byte $42 ; | X    X | $DFBF
    .byte $0C ; |    XX  | $DFC0
    .byte $42 ; | X    X | $DFC1
    .byte $0A ; |    X X | $DFC2
    .byte $42 ; | X    X | $DFC3
    .byte $0A ; |    X X | $DFC4
    .byte $40 ; | X      | $DFC5
    .byte $08 ; |    X   | $DFC6
    .byte $40 ; | X      | $DFC7
    .byte $06 ; |     XX | $DFC8
    .byte $40 ; | X      | $DFC9
    .byte $88 ; |X   X   | $DFCA
LDFCB:
    .byte $70 ; | XXX    | $DFCB
    .byte $78 ; | XXXX   | $DFCC
    .byte $7C ; | XXXXX  | $DFCD
    .byte $7E ; | XXXXXX | $DFCE
    .byte $7F ; | XXXXXXX| $DFCF
    .byte $7F ; | XXXXXXX| $DFD0
    .byte $7F ; | XXXXXXX| $DFD1
    .byte $7F ; | XXXXXXX| $DFD2
    .byte $7F ; | XXXXXXX| $DFD3
    .byte $7F ; | XXXXXXX| $DFD4
    .byte $7F ; | XXXXXXX| $DFD5
    .byte $7F ; | XXXXXXX| $DFD6
    .byte $7F ; | XXXXXXX| $DFD7
    .byte $7F ; | XXXXXXX| $DFD8
    .byte $7F ; | XXXXXXX| $DFD9
    .byte $7F ; | XXXXXXX| $DFDA
    .byte $7F ; | XXXXXXX| $DFDB
    .byte $7F ; | XXXXXXX| $DFDC
    .byte $7F ; | XXXXXXX| $DFDD
    .byte $7F ; | XXXXXXX| $DFDE
    .byte $7F ; | XXXXXXX| $DFDF
    .byte $7F ; | XXXXXXX| $DFE0
LDFE1:
    .byte $00 ; |        | $DFE1
    .byte $3E ; |  XXXXX | $DFE2
    .byte $7F ; | XXXXXXX| $DFE3
    .byte $FF ; |XXXXXXXX| $DFE4
    .byte $FB ; |XXXXX XX| $DFE5
    .byte $EF ; |XXX XXXX| $DFE6
    .byte $DE ; |XX XXXX | $DFE7
    .byte $7C ; | XXXXX  | $DFE8
    .byte $74 ; | XXX X  | $DFE9
    .byte $70 ; | XXX    | $DFEA
    .byte $20 ; |  X     | $DFEB

LDFEC:
    sta    BANK_1                ; 4
    jmp    LD8C0                 ; 3

LDFF2:
    sta    BANK_1                ; 4
    jmp    LD003                 ; 3

    .byte $CB ; |XX  X XX| $DFF8

  IF ALTERNATE
    .byte $C9 ; |XX  X  X| $DFF9
    .byte $3E ; |  XXXXX | $DFFA
    .byte $23 ; |  X   XX| $DFFB
  ELSE
    .byte $3E ; |  XXXXX | $DFF9
    .byte $00 ; |        | $DFFA
    .byte $D3 ; |XX X  XX| $DFFB
  ENDIF



       ORG $1FFC
      RORG $DFFC

    .word START_BANK1
    .word BRK_ROUTINE    ; $D671


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      BANK 1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


       ORG $2000
      RORG $F000

START_BANK1:
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2

    sei                          ; 2
    cld                          ; 2
    ldx    #$F8                  ; 2
    txs                          ; 2
    lda    #0                    ; 2
    tax                          ; 2
LF00B:
    sta    WSYNC,X               ; 4
    dex                          ; 2
    bne    LF00B                 ; 2³
    dex                          ; 2
    stx    $EB                   ; 3
    jsr    LF770                 ; 6
    lda    #$40                  ; 2
    sta    $FF                   ; 3
LF01A:
    lda    #2                    ; 2
    sta    WSYNC                 ; 3
    sta    VSYNC                 ; 3
    sta    VBLANK                ; 3
    lda    $EB                   ; 3
    cmp    #$FF                  ; 2
    bne    LF040                 ; 2³
    lda    $85                   ; 3
    and    #$10                  ; 2
    beq    LF03E                 ; 2³
    lda    $E3                   ; 3
    and    #$0F                  ; 2
    tax                          ; 2
    lda    LFE8E,X               ; 4
    sta    AUDF0                 ; 3
    lda    #4                    ; 2
    sta    AUDC0                 ; 3
    lda    #8                    ; 2
LF03E:
    sta    AUDV0                 ; 3
LF040:
    sta    WSYNC                 ; 3
    sta    WSYNC                 ; 3
    lda    $E3                   ; 3
    lsr                          ; 2
    lda    #$2C                  ; 2
    ldx    #$30                  ; 2
    stx    $F9                   ; 3
    sta    WSYNC                 ; 3
    stx    VSYNC                 ; 3
    sta    TIM64T                ; 4
    bcc    LF0A5                 ; 2³
    jsr    LF625                 ; 6
    bmi    LF081                 ; 2³
    sta    $FB                   ; 3
    jsr    LF7BE                 ; 6
    lda    #$56                  ; 2
    sec                          ; 2
    sbc    $8B                   ; 3
    cmp    #$11                  ; 2
    bcc    LF06B                 ; 2³
    adc    #$10                  ; 2
LF06B:
    tay                          ; 2
    lda    LFB3D,Y               ; 4
    sta    $82                   ; 3
    lda    #$46                  ; 2
    sec                          ; 2
    sbc    $8B                   ; 3
    bpl    LF07A                 ; 2³
    lda    #0                    ; 2
LF07A:
    lsr                          ; 2
    sta    $83                   ; 3
    sta    $84                   ; 3
    bpl    LF0A2                 ; 2³
LF081:
    and    #$7F                  ; 2
    sta    $FB                   ; 3
    jsr    LF827                 ; 6
    lda    #$56                  ; 2
    clc                          ; 2
    adc    $8B                   ; 3
    cmp    #$11                  ; 2
    bcc    LF093                 ; 2³
    adc    #$10                  ; 2
LF093:
    tay                          ; 2
    lda    LFB3D,Y               ; 4
    sta    $82                   ; 3
    lda    #$4A                  ; 2
    adc    $8B                   ; 3
    lsr                          ; 2
    sta    $83                   ; 3
    sta    $84                   ; 3
LF0A2:
    jmp    LF2F4                 ; 3

LF0A5:
    lda    $84                   ; 3
    sta    $83                   ; 3
    lda    $87                   ; 3
    beq    LF0CD                 ; 2³
    cmp    #$14                  ; 2
    bcs    LF0CD                 ; 2³
    cmp    #1                    ; 2
    bne    LF0BB                 ; 2³
    lda    $86                   ; 3
    cmp    #$40                  ; 2
    bcc    LF0CD                 ; 2³
LF0BB:
    lda    $DC                   ; 3
    beq    LF0CD                 ; 2³
    cmp    #$90                  ; 2
    beq    LF0CD                 ; 2³
    lda    $86                   ; 3
    bne    LF0D3                 ; 2³
    lda    $87                   ; 3
    and    #$03                  ; 2
    bne    LF0D3                 ; 2³
LF0CD:
    lda    $89                   ; 3
    cmp    #$35                  ; 2
    beq    LF150                 ; 2³+1
LF0D3:
    dec    $E9                   ; 5
    bpl    LF150                 ; 2³+1
    lda    #1                    ; 2
    sta    $F9                   ; 3
    lda    $88                   ; 3
    sec                          ; 2
    sbc    $E8                   ; 3
    bcs    LF0E8                 ; 2³
    dec    $F9                   ; 5
    eor    #$FF                  ; 2
    adc    #1                    ; 2
LF0E8:
    sta    $F4                   ; 3
    ldx    #6                    ; 2
LF0EC:
    cmp    LF9B2,X               ; 4
    bcs    LF0F4                 ; 2³
    dex                          ; 2
    bpl    LF0EC                 ; 2³
LF0F4:
    lda    $F4                   ; 3
    beq    LF170                 ; 2³+1
    lda    LF9AC,X               ; 4
    ldy    $89                   ; 3
    cpy    #$23                  ; 2
    bcs    LF115                 ; 2³
    sta    $F4                   ; 3
    tya                          ; 2
    ldy    #7                    ; 2
LF106:
    cmp    LF97E,Y               ; 4
    bcc    LF10E                 ; 2³
    dey                          ; 2
    bne    LF106                 ; 2³
LF10E:
    sty    $F3                   ; 3
    lda    $F4                   ; 3
    clc                          ; 2
    adc    $F3                   ; 3
LF115:
    sta    $E9                   ; 3
    lda    $89                   ; 3
    ldx    #3                    ; 2
    cmp    #$32                  ; 2
    bcc    LF12D                 ; 2³
    lda    $E6                   ; 3
    and    #$3F                  ; 2
    bit    $8A                   ; 3
    bmi    LF129                 ; 2³
    ora    #$80                  ; 2
LF129:
    sta    $E6                   ; 3
    lda    $89                   ; 3
LF12D:
    cmp    LF98E,X               ; 4
    bcs    LF135                 ; 2³
    dex                          ; 2
    bpl    LF12D                 ; 2³
LF135:
    lda    $F9                   ; 3
    bne    LF153                 ; 2³
LF139:
    dec    $89                   ; 5
    dex                          ; 2
    bpl    LF139                 ; 2³
    lda    $89                   ; 3
    bpl    LF150                 ; 2³
    lda    #$35                  ; 2
    sta    $89                   ; 3
    bit    $E6                   ; 3
    bvc    LF170                 ; 2³
    lda    $E6                   ; 3
    eor    #$C0                  ; 2
    sta    $E6                   ; 3
LF150:
    jmp    LF170                 ; 3

LF153:
    inc    $89                   ; 5
    dex                          ; 2
    bpl    LF153                 ; 2³
    lda    $89                   ; 3
    cmp    #$35                  ; 2
    bcc    LF170                 ; 2³
    inc    $E2                   ; 5
    lda    $E3                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    sta    $E8                   ; 3
    lda    #0                    ; 2
    sta    $89                   ; 3
    lda    $E3                   ; 3
    and    #$80                  ; 2
    sta    $E6                   ; 3
LF170:
    lda    $89                   ; 3
    sta    $80                   ; 3
    ldx    #5                    ; 2
LF176:
    cmp    LF9A0,X               ; 4
    bcs    LF17E                 ; 2³
    dex                          ; 2
    bpl    LF176                 ; 2³
LF17E:
    clc                          ; 2
    adc    LFCFA,X               ; 4
    sta    $80                   ; 3
    lda    #$DE                  ; 2
    adc    LF9F7,X               ; 4
    sta    $81                   ; 3
    lda    LF9A6,X               ; 4
    sta    $E4                   ; 3
    lda    LF991,X               ; 4
    sta    $E5                   ; 3
    jsr    LF625                 ; 6
    bmi    LF1A9                 ; 2³
    lda    #$56                  ; 2
    sec                          ; 2
    sbc    $8B                   ; 3
    bmi    LF1A5                 ; 2³
    cmp    #8                    ; 2
    bcs    LF1AE                 ; 2³
LF1A5:
    lda    #$10                  ; 2
    bpl    LF1AE                 ; 2³
LF1A9:
    lda    #$56                  ; 2
    clc                          ; 2
    adc    $8B                   ; 3
LF1AE:
    sta    $D8                   ; 3
    lda    #0                    ; 2
    sta    $F3                   ; 3
    lda    #$32                  ; 2
    sec                          ; 2
    sbc    $89                   ; 3
    tax                          ; 2
    tay                          ; 2
    iny                          ; 2
    cmp    #$32                  ; 2
    bne    LF1C4                 ; 2³
    lda    #0                    ; 2
    beq    LF1DC                 ; 2³
LF1C4:
    lda    $8C,X                 ; 4
    sta    $F9                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    bit    $F9                   ; 3
    bpl    LF1D2                 ; 2³
    ora    #$F0                  ; 2
LF1D2:
    clc                          ; 2
    adc    $F3                   ; 3
    sta    $F3                   ; 3
    inx                          ; 2
    cpx    #$32                  ; 2
    bne    LF1C4                 ; 2³
LF1DC:
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #1                    ; 2
    asl                          ; 2
    clc                          ; 2
    adc    $D8                   ; 3
    clc                          ; 2
    adc    $E4                   ; 3
    sta    $D8                   ; 3
    bit    $E6                   ; 3
    bvs    LF21C                 ; 2³+1
    lda    $87                   ; 3
    cmp    #4                    ; 2
    bcc    LF22E                 ; 2³+1
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    $E3                   ; 3
    adc    $DF                   ; 3
    adc    $DE                   ; 3
    adc    $8A                   ; 3
    and    LF99B,X               ; 4
    bne    LF278                 ; 2³
    lda    $89                   ; 3
    cmp    #$0E                  ; 2
    bcs    LF278                 ; 2³
    lda    $E6                   ; 3
    ora    #$40                  ; 2
    sta    $E6                   ; 3
    bmi    LF218                 ; 2³
    lda    #4                    ; 2
    sta    $E7                   ; 3
    bpl    LF21C                 ; 2³
LF218:
    lda    #$FC                  ; 2
    sta    $E7                   ; 3
LF21C:
    lda    $E3                   ; 3
    and    #$07                  ; 2
    bne    LF24E                 ; 2³
    lda    $89                   ; 3
    cmp    #2                    ; 2
    bcs    LF231                 ; 2³
    lda    $E6                   ; 3
    eor    #$40                  ; 2
    sta    $E6                   ; 3
LF22E:
    jmp    LF278                 ; 3

LF231:
    bit    $E6                   ; 3
    bmi    LF246                 ; 2³
    dec    $E7                   ; 5
    lda    $E7                   ; 3
    cmp    #$FC                  ; 2
    bne    LF24E                 ; 2³
LF23D:
    lda    $E6                   ; 3
    eor    #$C0                  ; 2
    sta    $E6                   ; 3
    jmp    LF278                 ; 3

LF246:
    inc    $E7                   ; 5
    lda    $E7                   ; 3
    cmp    #4                    ; 2
    beq    LF23D                 ; 2³
LF24E:
    lda    LFCC0,Y               ; 4
    lsr                          ; 2
    lsr                          ; 2
    sta    $F4                   ; 3
    ldx    $E7                   ; 3
    bpl    LF267                 ; 2³
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #1                    ; 2
    sta    $F4                   ; 3
    txa                          ; 2
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #1                    ; 2
    tax                          ; 2
LF267:
    beq    LF273                 ; 2³
    lda    $D8                   ; 3
LF26B:
    clc                          ; 2
    adc    $F4                   ; 3
    dex                          ; 2
    bne    LF26B                 ; 2³
    sta    $D8                   ; 3
LF273:
    lda    $D8                   ; 3
    jmp    LF293                 ; 3

LF278:
    lda    #$32                  ; 2
    sec                          ; 2
    sbc    $89                   ; 3
    tay                          ; 2
    lda    $D8                   ; 3
    ldx    $E6                   ; 3
    bmi    LF28D                 ; 2³
    clc                          ; 2
    adc    LFCC0,Y               ; 4
    sta    $D8                   ; 3
    jmp    LF293                 ; 3

LF28D:
    sec                          ; 2
    sbc    LFCC0,Y               ; 4
    sta    $D8                   ; 3
LF293:
    ldx    #$FF                  ; 2
    stx    $DA                   ; 3
    ldx    $89                   ; 3
    cpx    #$33                  ; 2
    bcs    LF2E0                 ; 2³
    cmp    #0                    ; 2
    bpl    LF2E2                 ; 2³
    bit    $E6                   ; 3
    bvc    LF2C2                 ; 2³
    cmp    #$9D                  ; 2
    bcs    LF2C4                 ; 2³
LF2A9:
    cmp    #$85                  ; 2
    bcc    LF2E2                 ; 2³
    cmp    #$9C                  ; 2
    bcs    LF2DC                 ; 2³
    ldx    #5                    ; 2
LF2B3:
    cmp    LFC7C,X               ; 4
    bcs    LF2BB                 ; 2³
    dex                          ; 2
    bpl    LF2B3                 ; 2³
LF2BB:
    ldy    LFC82,X               ; 4
    sty    $DA                   ; 3
    bmi    LF2E2                 ; 2³
LF2C2:
    bpl    LF2A9                 ; 2³
LF2C4:
    sec                          ; 2
    sbc    #$61                  ; 2
    cmp    #$84                  ; 2
    bcc    LF2DC                 ; 2³
    ldx    #5                    ; 2
LF2CD:
    cmp    LFC88,X               ; 4
    bcs    LF2D5                 ; 2³
    dex                          ; 2
    bpl    LF2CD                 ; 2³
LF2D5:
    ldy    LF997,X               ; 4
    sty    $DA                   ; 3
    bpl    LF2E2                 ; 2³
LF2DC:
    lda    #0                    ; 2
    sta    $DA                   ; 3
LF2E0:
    lda    #0                    ; 2
LF2E2:
    tay                          ; 2
    lda    LFB4E,Y               ; 4
    sta    $D9                   ; 3
    and    #$0F                  ; 2
    beq    LF2F1                 ; 2³
    lda    LFB56,Y               ; 4
    sta    $D9                   ; 3
LF2F1:
    jsr    LFA4D                 ; 6
LF2F4:
    ldy    INTIM                 ; 4
    bne    LF2F4                 ; 2³
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    sty    GRP0                  ; 3
    sty    ENABL                 ; 3
    sty    $ED                   ; 3
    ldx    #0                    ; 2
    lda    #$86                  ; 2
    sta    COLUBK                ; 3
    lda    $85                   ; 3
    and    #$20                  ; 2
    sta    WSYNC                 ; 3
    sta    HMOVE                 ; 3
    sty    VBLANK                ; 3
    jmp    LFFF2                 ; 3

LF316:
    inc    $E3                   ; 5
    sta    WSYNC                 ; 3
    lda    #2                    ; 2
    sta    VBLANK                ; 3
    ldx    #$F8                  ; 2
    txs                          ; 2
    lda    #$24                  ; 2
    sta    TIM64T                ; 4
    lda    $E3                   ; 3
    lsr                          ; 2
    bcc    LF3A7                 ; 2³
    lda    $8A                   ; 3
    ldx    #$32                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tay                          ; 2
    lda    LFDA4,Y               ; 4
    and    #$F0                  ; 2
    sta    $F9                   ; 3
    lda    LFDA4,Y               ; 4
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    $F4                   ; 3
    lda    LFDC4,Y               ; 4
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    $F3                   ; 3
    lda    LFDC4,Y               ; 4
    and    #$0F                  ; 2
    sta    $FA                   ; 3
LF353:
    ldy    $F3                   ; 3
    lda    $F9                   ; 3
LF357:
    dex                          ; 2
    bmi    LF36E                 ; 2³
    sta    $8C,X                 ; 4
    dey                          ; 2
    bpl    LF357                 ; 2³
    dex                          ; 2
    bmi    LF36E                 ; 2³
    ldy    $FA                   ; 3
    lda    $F4                   ; 3
LF366:
    sta    $8C,X                 ; 4
    dey                          ; 2
    bmi    LF353                 ; 2³
    dex                          ; 2
    bpl    LF366                 ; 2³
LF36E:
    lda    $86                   ; 3
    sta    $EF                   ; 3
    lda    #$FA                  ; 2
    sta    $F0                   ; 3
    lda    #$FC                  ; 2
    sta    $EE                   ; 3
    ldy    #0                    ; 2
    sty    $F4                   ; 3
    sty    $8B                   ; 3
    sty    $F1                   ; 3
    sty    $F5                   ; 3
    ldx    #$0C                  ; 2
    stx    $F9                   ; 3
    jsr    LF625                 ; 6
    bmi    LF395                 ; 2³
    sta    $FB                   ; 3
    jsr    LF7BE                 ; 6
LF392:
    jmp    LF61D                 ; 3

LF395:
    and    #$7F                  ; 2
    sta    $FB                   ; 3
    jsr    LF827                 ; 6
    jmp    LF61D                 ; 3

LF39F:
    .byte $00 ; |        | $F39F
    .byte $CB ; |XX  X XX| $F3A0
    .byte $32 ; |  XX  X | $F3A1
    .byte $B2 ; |X XX  X | $F3A2
    .byte $4B ; | X  X XX| $F3A3
    .byte $99 ; |X  XX  X| $F3A4
    .byte $B2 ; |X XX  X | $F3A5
    .byte $99 ; |X  XX  X| $F3A6

LF3A7:
    jsr    LF756                 ; 6
    jsr    LF882                 ; 6
    jsr    LF634                 ; 6
    lda    $EB                   ; 3
    bpl    LF392                 ; 2³
    bit    $85                   ; 3
    bvc    LF3BB                 ; 2³
    jmp    LF512                 ; 3

LF3BB:
    ldx    #0                    ; 2
    stx    $F3                   ; 3
    ldy    $86                   ; 3
    lda    LF9F8,Y               ; 4
    beq    LF3C7                 ; 2³
    inx                          ; 2
LF3C7:
    lda    LFA04,Y               ; 4
    beq    LF3CD                 ; 2³
    inx                          ; 2
LF3CD:
    lda    #0                    ; 2
    dex                          ; 2
    bmi    LF3E7                 ; 2³
    stx    $F3                   ; 3
    jsr    LF625                 ; 6
    tay                          ; 2
    and    #$7F                  ; 2
    beq    LF3E7                 ; 2³
    inx                          ; 2
    cmp    #$19                  ; 2
    beq    LF3E7                 ; 2³
    inx                          ; 2
    cmp    #$32                  ; 2
    beq    LF3E7                 ; 2³
    inx                          ; 2
LF3E7:
    dex                          ; 2
    bpl    LF3EC                 ; 2³
    ldx    #0                    ; 2
LF3EC:
    stx    $F9                   ; 3
    lda    $EA                   ; 3
    beq    LF406                 ; 2³+1
    bmi    LF3FB                 ; 2³
    lsr    $EA                   ; 5
    lsr    $EA                   ; 5
    clc                          ; 2
    bpl    LF402                 ; 2³+1
LF3FB:
    sec                          ; 2
    ror    $EA                   ; 5
    sec                          ; 2
    ror    $EA                   ; 5
    sec                          ; 2
LF402:
    sbc    $EA                   ; 3
    sta    $EA                   ; 3
LF406:
    lda    $FC                   ; 3
    adc    $88                   ; 3
    and    #$F8                  ; 2
    sta    $FC                   ; 3
    lda    #0                    ; 2
    rol                          ; 2
    sta    $FA                   ; 3
    beq    LF417                 ; 2³
    asl    $F3                   ; 5
LF417:
    lda    #0                    ; 2
    bit    SWCHA                 ; 4
    bvc    LF433                 ; 2³
    bmi    LF446                 ; 2³
    lda    $FD                   ; 3
    bpl    LF426                 ; 2³
    lda    #0                    ; 2
LF426:
    clc                          ; 2
    adc    $FA                   ; 3
    cmp    #8                    ; 2
    beq    LF467                 ; 2³
    bcs    LF469                 ; 2³
    sta    $FD                   ; 3
    bne    LF45E                 ; 2³
LF433:
    lda    $FD                   ; 3
    bmi    LF439                 ; 2³
    lda    #0                    ; 2
LF439:
    sec                          ; 2
    sbc    $FA                   ; 3
    cmp    #$F8                  ; 2
    beq    LF467                 ; 2³
    bcc    LF469                 ; 2³
    sta    $FD                   ; 3
    bne    LF45E                 ; 2³
LF446:
    lda    $FD                   ; 3
    beq    LF45E                 ; 2³
    bmi    LF453                 ; 2³
    lsr    $FD                   ; 5
    lsr    $FD                   ; 5
    clc                          ; 2
    bpl    LF45A                 ; 2³
LF453:
    sec                          ; 2
    ror    $FD                   ; 5
    sec                          ; 2
    ror    $FD                   ; 5
    sec                          ; 2
LF45A:
    sbc    $FD                   ; 3
    sta    $FD                   ; 3
LF45E:
    lda    $85                   ; 3
    and    #$EF                  ; 2
    sta    $85                   ; 3
    jmp    LF49F                 ; 3

LF467:
    sta    $FD                   ; 3
LF469:
    lda    $88                   ; 3
    and    #$F0                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    ora    $F9                   ; 3
    tax                          ; 2
    lda    LF9BD,X               ; 4
    sbc    #2                    ; 2
    bmi    LF45E                 ; 2³
    sta    $F4                   ; 3
    lda    $85                   ; 3
    and    #$10                  ; 2
    bne    LF494                 ; 2³
    lda    $88                   ; 3
    cmp    LF9B9,X               ; 4
    bcc    LF45E                 ; 2³
    sbc    $F4                   ; 3
    sta    $88                   ; 3
    lda    $85                   ; 3
    ora    #$10                  ; 2
    sta    $85                   ; 3
    bne    LF49F                 ; 2³
LF494:
    lda    $88                   ; 3
    cmp    LFCF6,X               ; 4
    bcc    LF45E                 ; 2³
    sbc    $F4                   ; 3
    sta    $88                   ; 3
LF49F:
    lda    $88                   ; 3
    and    #$F0                  ; 2
    beq    LF4D3                 ; 2³
    lsr                          ; 2
    lsr                          ; 2
    ora    $F9                   ; 3
    tax                          ; 2
    lda    LF9BD,X               ; 4
    lsr                          ; 2
    sta    $F9                   ; 3
    lsr                          ; 2
    clc                          ; 2
    adc    $F9                   ; 3
    ora    $FC                   ; 3
    ora    $F3                   ; 3
    sta    $FC                   ; 3
    lda    $85                   ; 3
    and    #$10                  ; 2
    beq    LF4C5                 ; 2³
    lda    LF9BD,X               ; 4
    lsr                          ; 2
    lsr                          ; 2
LF4C5:
    clc                          ; 2
    adc    LF9BD,X               ; 4
    lsr                          ; 2
    cpy    #0                    ; 2
    bpl    LF4D3                 ; 2³
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #1                    ; 2
LF4D3:
    clc                          ; 2
    adc    $EA                   ; 3
    clc                          ; 2
    adc    $FD                   ; 3
    sta    $EA                   ; 3
    bmi    LF4E5                 ; 2³
    cmp    #$3F                  ; 2
    bcc    LF4EB                 ; 2³
    lda    #$3F                  ; 2
    bne    LF4EB                 ; 2³
LF4E5:
    cmp    #$C0                  ; 2
    bcs    LF4EB                 ; 2³
    lda    #$C0                  ; 2
LF4EB:
    sta    $EA                   ; 3
    lda    $EA                   ; 3
    bmi    LF501                 ; 2³+1
    lsr                          ; 2
    clc                          ; 2
    adc    $8A                   ; 3
    bvs    LF4FD                 ; 2³
    bmi    LF50A                 ; 2³+1
LF4F9:
    cmp    #$6F                  ; 2
    bcc    LF510                 ; 2³+1
LF4FD:
    lda    #$6F                  ; 2
    bne    LF510                 ; 2³
LF501:
    sec                          ; 2
    ror                          ; 2
    clc                          ; 2
    adc    $8A                   ; 3
    bvs    LF50E                 ; 2³
    bpl    LF4F9                 ; 2³+1
LF50A:
    cmp    #$90                  ; 2
    bcs    LF510                 ; 2³
LF50E:
    lda    #$90                  ; 2
LF510:
    sta    $8A                   ; 3
LF512:
    bit    $85                   ; 3
    bvc    LF53D                 ; 2³
    lda    $88                   ; 3
    sec                          ; 2
    sbc    #6                    ; 2
    cmp    #$F0                  ; 2
    bcs    LF52D                 ; 2³
    cmp    #$5A                  ; 2
    bcs    LF53B                 ; 2³
    tax                          ; 2
    lda    $85                   ; 3
    ora    #$02                  ; 2
    sta    $85                   ; 3
    txa                          ; 2
    bne    LF53B                 ; 2³
LF52D:
    lda    $EB                   ; 3
    cmp    #$FF                  ; 2
    bne    LF539                 ; 2³
    lda    $85                   ; 3
    and    #$BF                  ; 2
    sta    $85                   ; 3
LF539:
    lda    #0                    ; 2
LF53B:
    sta    $88                   ; 3
LF53D:
    jmp    LFFEC                 ; 3

LF540:
    lda    $E3                   ; 3
    and    #$03                  ; 2
    bne    LF549                 ; 2³
    jsr    LF916                 ; 6
LF549:
    jsr    LF625                 ; 6
    beq    LF563                 ; 2³
    lda    $FC                   ; 3
    and    #$07                  ; 2
    tax                          ; 2
    lda    $FC                   ; 3
    and    #$F8                  ; 2
    sta    $FC                   ; 3
    ldy    $86                   ; 3
    lda    LFA0C,Y               ; 4
    bne    LF565                 ; 2³
    lda    LFA05,Y               ; 4
LF563:
    beq    LF5B6                 ; 2³
LF565:
    jsr    LF625                 ; 6
    bmi    LF5B9                 ; 2³
    stx    $F9                   ; 3
    txa                          ; 2
    asl                          ; 2
    sta    $F4                   ; 3
    lda    $BE                   ; 3
    adc    $F9                   ; 3
    cmp    #$A0                  ; 2
    bcc    LF57A                 ; 2³
    sbc    #$A0                  ; 2
LF57A:
    sta    $BE                   ; 3
    lda    $BF                   ; 3
    clc                          ; 2
    adc    $F4                   ; 3
    sta    $BF                   ; 3
    cmp    #$10                  ; 2
    bcc    LF5B6                 ; 2³
LF587:
    sbc    #8                    ; 2
    sta    $BF                   ; 3
    ldx    #$12                  ; 2
LF58D:
    asl    $C0,X                 ; 6
    ror    $C1,X                 ; 6
    rol    $C2,X                 ; 6
    bcc    LF59B                 ; 2³
    lda    $C3,X                 ; 4
    ora    #$08                  ; 2
    sta    $C3,X                 ; 4
LF59B:
    asl    $C3,X                 ; 6
    ror    $C4,X                 ; 6
    rol    $C5,X                 ; 6
    bcc    LF5A9                 ; 2³
    lda    $C0,X                 ; 4
    ora    #$10                  ; 2
    sta    $C0,X                 ; 4
LF5A9:
    txa                          ; 2
    sec                          ; 2
    sbc    #6                    ; 2
    tax                          ; 2
    bpl    LF58D                 ; 2³
    lda    $BF                   ; 3
    cmp    #$10                  ; 2
    bcs    LF587                 ; 2³
LF5B6:
    jmp    LF61D                 ; 3

LF5B9:
    stx    $F9                   ; 3
    txa                          ; 2
    asl                          ; 2
    sta    $F4                   ; 3
    lda    $BE                   ; 3
    sec                          ; 2
    sbc    $F9                   ; 3
    cmp    #$A0                  ; 2
    bcc    LF5CA                 ; 2³
    adc    #$9F                  ; 2
LF5CA:
    sta    $BE                   ; 3
    lda    $BF                   ; 3
    sec                          ; 2
    sbc    $F4                   ; 3
    sta    $BF                   ; 3
    cmp    #1                    ; 2
    beq    LF5D9                 ; 2³
    bpl    LF61D                 ; 2³+1
LF5D9:
    clc                          ; 2
    adc    #8                    ; 2
    sta    $BF                   ; 3
    ldx    #$12                  ; 2
LF5E0:
    lsr    $C5,X                 ; 6
    rol    $C4,X                 ; 6
    ror    $C3,X                 ; 6
    lda    $C3,X                 ; 4
    and    #$08                  ; 2
    beq    LF5F5                 ; 2³
    sec                          ; 2
    lda    $C3,X                 ; 4
    and    #$F0                  ; 2
    sta    $C3,X                 ; 4
    bcs    LF5F6                 ; 2³
LF5F5:
    clc                          ; 2
LF5F6:
    ror    $C2,X                 ; 6
    rol    $C1,X                 ; 6
    ror    $C0,X                 ; 6
    lda    $C0,X                 ; 4
    and    #$08                  ; 2
    beq    LF60E                 ; 2³
    lda    $C5,X                 ; 4
    ora    #$80                  ; 2
    sta    $C5,X                 ; 4
    lda    $C0,X                 ; 4
    and    #$F0                  ; 2
    sta    $C0,X                 ; 4
LF60E:
    txa                          ; 2
    sec                          ; 2
    sbc    #6                    ; 2
    tax                          ; 2
    bpl    LF5E0                 ; 2³+1
    lda    $BF                   ; 3
    cmp    #1                    ; 2
    beq    LF5D9                 ; 2³+1
    bmi    LF5D9                 ; 2³+1
LF61D:
    lda    INTIM                 ; 4
    bne    LF61D                 ; 2³
    jmp    LF01A                 ; 3

LF625:
    lda    $87                   ; 3
    and    #$03                  ; 2
    asl                          ; 2
    tay                          ; 2
    bit    $86                   ; 3
    bpl    LF630                 ; 2³
    iny                          ; 2
LF630:
    lda    LF39F,Y               ; 4
LF633:
    rts                          ; 6

LF634:
    ldy    $EB                   ; 3
    cpy    #$FF                  ; 2
    bne    LF63D                 ; 2³
    jmp    LF6FC                 ; 3

LF63D:
    cpy    #$39                  ; 2
    bne    LF673                 ; 2³
    lda    $DF                   ; 3
    ora    $E0                   ; 3
    bne    LF673                 ; 2³
    lda    $E1                   ; 3
    cmp    #1                    ; 2
    bne    LF673                 ; 2³
    ldy    #5                    ; 2
    lda    $DD                   ; 3
LF651:
    cmp    LF979,Y               ; 4
    bcs    LF666                 ; 2³
    dey                          ; 2
    bpl    LF651                 ; 2³
    cmp    #$58                  ; 2
    bcc    LF665                 ; 2³
    bne    LF666                 ; 2³
    lda    $DE                   ; 3
    cmp    #$50                  ; 2
    bcs    LF666                 ; 2³
LF665:
    dey                          ; 2
LF666:
    tya                          ; 2
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #$75                  ; 2
    sta    $EB                   ; 3
    tay                          ; 2
    lda    #6                    ; 2
    sta    $EC                   ; 3
LF673:
    cpy    #$6D                  ; 2
    bne    LF68F                 ; 2³

  IF SEGA_GENESIS

    LDA    #$1E
    STA    $EC
    LDA    #0
    STA    $DD
    STA    $DE
    LDA    #$75
    STA    $DC

    LDA    #$7F
    STA    $EB
    AND    $85
    STA    $85

  ELSE
    lda    #$7F                  ; 2
    sta    $EB                   ; 3
    lda    #$1E                  ; 2
    sta    $EC                   ; 3
    lda    #0                    ; 2
    sta    $DD                   ; 3
    sta    $DE                   ; 3
    lda    #$75                  ; 2
    sta    $DC                   ; 3
    lda    $85                   ; 3
    and    #$7F                  ; 2
    sta    $85                   ; 3
  ENDIF

LF68F:
    lda    $EC                   ; 3
    and    $E3                   ; 3
    bne    LF633                 ; 2³
    dey                          ; 2
    cpy    #$6E                  ; 2
    bcc    LF6B6                 ; 2³
    cpy    #$76                  ; 2
    bcs    LF6B6                 ; 2³
    lda    PNTTAB-STALL+OPENING-2,Y ; 4
    sed                          ; 2

  IF !SEGA_GENESIS
    clc                          ; 2  already clear
  ENDIF

    adc    $E0                   ; 3
    sta    $E0                   ; 3
    lda    #0                    ; 2
    tax                          ; 2
    adc    $E1                   ; 3
    sta    $E1                   ; 3
    cld                          ; 2
    bit    $8A                   ; 3
    bpl    LF6B4                 ; 2³
    dex                          ; 2
LF6B4:
    stx    $8A                   ; 3
LF6B6:
    bit    $85                   ; 3
    bvc    LF6CE                 ; 2³
    lda    #8                    ; 2
    sta    AUDC0                 ; 3
    lda    #2                    ; 2
    sta    AUDC1                 ; 3
    lda    LFDD4,Y               ; 4
    sta    AUDV0                 ; 3
    lda    LFE8E,Y               ; 4
    sta    AUDV1                 ; 3
    bpl    LF6DC                 ; 2³
LF6CE:
    lda    #8                    ; 2
    sta    AUDV0                 ; 3
    sta    AUDV1                 ; 3

  IF SEGA_GENESIS
    LSR
  ELSE
    lda    #4                    ; 2
  ENDIF

    sta    AUDC0                 ; 3
    lda    #$0D                  ; 2
    sta    AUDC1                 ; 3
LF6DC:
    lda    OPENING,Y               ; 4
    bpl    LF6EA                 ; 2³
    ldy    #$FF                  ; 2
    sty    $EB                   ; 3
    iny                          ; 2
    sty    AUDV0                 ; 3
    beq    LF6FC                 ; 2³
LF6EA:
    bne    LF6EE                 ; 2³
    sta    AUDV0                 ; 3
LF6EE:
    sta    AUDF0                 ; 3
    sty    $EB                   ; 3
    lda    LFE9E,Y               ; 4
    bne    LF6F9                 ; 2³
    sta    AUDV1                 ; 3
LF6F9:
    sta    AUDF1                 ; 3
    rts                          ; 6

LF6FC:
    lda    $87                   ; 3
    sec                          ; 2
    sbc    #$14                  ; 2
    ora    $88                   ; 3
    beq    LF70B                 ; 2³
    lda    $DC                   ; 3
    ora    $88                   ; 3
    bne    LF710                 ; 2³
LF70B:
    sta    AUDV0                 ; 3
    sta    AUDV1                 ; 3
    rts                          ; 6

LF710:
    lda    $88                   ; 3
    adc    #$1E                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    bit    $85                   ; 3
    bmi    LF722                 ; 2³
    asl                          ; 2
    cmp    #$1F                  ; 2
    bcc    LF722                 ; 2³
    lda    #$1F                  ; 2
LF722:
    tax                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    bcc    LF72E                 ; 2³
    lda    $E3                   ; 3
    and    #$02                  ; 2
    bne    LF755                 ; 2³
LF72E:
    lda    LFCA0,X               ; 4
    sta    AUDF1                 ; 3
    lda    #$FF                  ; 2
    sta    AUDC1                 ; 3
    lda    #7                    ; 2
    sta    AUDV1                 ; 3
    lda    #$30                  ; 2
    sec                          ; 2
    sbc    $89                   ; 3
    bmi    LF755                 ; 2³
    cmp    #$14                  ; 2
    bcs    LF755                 ; 2³
    lsr                          ; 2
    tay                          ; 2
    lda    #3                    ; 2
    sta    AUDC1                 ; 3
    ldx    #6                    ; 2
    stx    AUDF1                 ; 3
    lda    LF9ED,Y               ; 4
    sta    AUDV1                 ; 3
LF755:
    rts                          ; 6

LF756:

  IF SEGA_GENESIS
    LSR    SWCHB
  ELSE
    lda    SWCHB                 ; 4
    lsr                          ; 2
  ENDIF

    bcs    LF7A7                 ; 2³
LF75C:
    lda    #$38                  ; 2
    sta    $EB                   ; 3
    lda    #2                    ; 2
    sta    $EC                   ; 3

  IF SEGA_GENESIS
    ASL
  ELSE
    lda    #4                    ; 2
  ENDIF

    sta    AUDC0                 ; 3
    lda    #$0D                  ; 2
    sta    AUDC1                 ; 3
    lda    #$90                  ; 2
    sta    $DC                   ; 3
LF770:

  IF SEGA_GENESIS
    LDA   #0
    LDX   #5
.loopSaveBytes:
    STA   $DD-1,X
    DEX
    BNE   .loopSaveBytes

  ELSE
    ldx    #0                    ; 2
    stx    $DF                   ; 3
    stx    $E0                   ; 3
    stx    $E1                   ; 3
    stx    $DD                   ; 3
    stx    $DE                   ; 3
  ENDIF

    stx    $87                   ; 3
    stx    $FD                   ; 3
    stx    $EA                   ; 3
    stx    $88                   ; 3
    stx    $85                   ; 3
    stx    $FF                   ; 3
    bit    $8A                   ; 3
    bpl    LF78D                 ; 2³
    dex                          ; 2
LF78D:
    stx    $8A                   ; 3
    ldx    #$18                  ; 2
    stx    $86                   ; 3
    lda    #$38                  ; 2
    sta    $BE                   ; 3
    lda    #$35                  ; 2
    sta    $89                   ; 3
LF79B:
    lda    LFC63,X               ; 4
    sta    $BF,X                 ; 4
    dex                          ; 2
    bne    LF79B                 ; 2³
    lda    #8                    ; 2
    sta    $BF                   ; 3
LF7A7:
    ldx    $EB                   ; 3
    inx                          ; 2
    txa                          ; 2
    ora    $DC                   ; 3
    ora    $88                   ; 3
    ora    $E2                   ; 3
    bne    LF7BD                 ; 2³
    lda    $E6                   ; 3
    and    #$20                  ; 2
    bne    LF7BD                 ; 2³

  IF SEGA_GENESIS
    LDA    INPT1
    AND    INPT4
    BPL    LF75C

  ELSE
    bit    INPT4 | $30           ; 3
    bpl    LF75C                 ; 2³
  ENDIF

LF7BD:
    rts                          ; 6

LF7BE:
    ldx    $F4                   ; 3
    bpl    LF7C6                 ; 2³
LF7C2:
    txa                          ; 2
    lsr                          ; 2
    tax                          ; 2
    inx                          ; 2
LF7C6:
    ldy    LFB24,X               ; 4
    lda    ($EF),Y               ; 5
    beq    LF7CF                 ; 2³
    lda    $FB                   ; 3
LF7CF:
    sta    $ED                   ; 3
    txa                          ; 2
    tay                          ; 2
    asl                          ; 2
    tax                          ; 2
    lda    ($ED),Y               ; 5
    adc    $F1                   ; 3
    sta    $F1                   ; 3
    lsr                          ; 2
    tay                          ; 2
    lda    $F5                   ; 3
    and    #$0F                  ; 2
    clc                          ; 2
    adc    LFD00,Y               ; 4
    sta    $F5                   ; 3
    clc                          ; 2
    adc    $8C,X                 ; 4
    sta    $8C,X                 ; 4
    lda    $F5                   ; 3
    and    #$F0                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    eor    #$1F                  ; 2
    adc    #1                    ; 2
    and    #$1F                  ; 2
    adc    $8B                   ; 3
    sta    $8B                   ; 3
    lda    $F5                   ; 3
    and    #$0F                  ; 2
    adc    LFD03,Y               ; 4
    sta    $F5                   ; 3
    clc                          ; 2
    adc    $8D,X                 ; 4
    sta    $8D,X                 ; 4
    lda    $F5                   ; 3
    and    #$F0                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    eor    #$1F                  ; 2
    adc    #1                    ; 2
    and    #$1F                  ; 2
    adc    $8B                   ; 3
    sta    $8B                   ; 3
    cpx    $F9                   ; 3
    bne    LF7C2                 ; 2³+1
FinishRoutine:
    txa                          ; 2
    lsr                          ; 2
    tax                          ; 2
    inx                          ; 2
    stx    $F4                   ; 3
    rts                          ; 6

LF827:
    ldx    $F4                   ; 3
    bpl    LF82F                 ; 2³
LF82B:
    txa                          ; 2
    lsr                          ; 2
    tax                          ; 2
    inx                          ; 2
LF82F:
    ldy    LFB24,X               ; 4
    lda    ($EF),Y               ; 5
    beq    LF838                 ; 2³
    lda    $FB                   ; 3
LF838:
    sta    $ED                   ; 3
    txa                          ; 2
    tay                          ; 2
    asl                          ; 2
    tax                          ; 2
    lda    ($ED),Y               ; 5
    adc    $F1                   ; 3
    sta    $F1                   ; 3
    lsr                          ; 2
    tay                          ; 2
    lda    $F5                   ; 3
    and    #$0F                  ; 2
    clc                          ; 2
    adc    LFF48,Y               ; 4
    sta    $F5                   ; 3
    adc    $8C,X                 ; 4
    sta    $8C,X                 ; 4
    lda    $F5                   ; 3
    and    #$F0                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    adc    $8B                   ; 3
    sta    $8B                   ; 3
    lda    $F5                   ; 3
    and    #$0F                  ; 2
    adc    LFF4B,Y               ; 4
    sta    $F5                   ; 3
    adc    $8D,X                 ; 4
    sta    $8D,X                 ; 4
    lda    $F5                   ; 3
    and    #$F0                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    adc    $8B                   ; 3
    sta    $8B                   ; 3
    cpx    $F9                   ; 3
    bne    LF82B                 ; 2³

  IF SEGA_GENESIS
    JMP    FinishRoutine
  ELSE
    txa                          ; 2
    lsr                          ; 2
    tax                          ; 2
    inx                          ; 2
    stx    $F4                   ; 3
    rts                          ; 6
  ENDIF

LF882:
    lda    $87                   ; 3
    cmp    #$14                  ; 2
    beq    LF88C                 ; 2³
    lda    $DC                   ; 3
    bne    LF8C2                 ; 2³
LF88C:
    lda    $88                   ; 3
    bne    LF89B                 ; 2³
    lda    $DF                   ; 3
    and    #$F0                  ; 2
    sta    $DF                   ; 3
    bit    $FF                   ; 3
    bvc    LF8A2                 ; 2³
    rts                          ; 6

LF89B:
    sec                          ; 2
    sbc    #3                    ; 2
    beq    LF8A2                 ; 2³
    bcs    LF8BC                 ; 2³
LF8A2:
    lda    $DC                   ; 3
    sta    $FE                   ; 3
    lda    #$6B                  ; 2
    sta    $EB                   ; 3
    lda    #2                    ; 2
    sta    $EC                   ; 3
    lda    $FF                   ; 3
    ora    #$40                  ; 2
    sta    $FF                   ; 3
    lda    $85                   ; 3
    and    #$BF                  ; 2
    sta    $85                   ; 3
    lda    #0                    ; 2
LF8BC:
    sta    $88                   ; 3
    lda    #$35                  ; 2
    sta    $89                   ; 3
LF8C2:
    ldx    #5                    ; 2
    bit    CXP0FB | $30          ; 3
    bvc    LF8D6                 ; 2³
    lda    $88                   ; 3
    cmp    #$20                  ; 2
    bcc    LF8D6                 ; 2³
    ldx    #$1C                  ; 2
    sbc    #3                    ; 2
    sta    $88                   ; 3
    stx    AUDV1                 ; 3
LF8D6:
    lda    $DC                   ; 3
    beq    LF915                 ; 2³+1
    lda    $89                   ; 3
    cmp    #$32                  ; 2
    bcs    LF915                 ; 2³+1
    cmp    #$21                  ; 2
    bcc    LF915                 ; 2³+1
    cmp    #$26                  ; 2
    bcs    LF90B                 ; 2³+1
    lda    $D8                   ; 3
    cmp    #$25                  ; 2
    bcc    LF915                 ; 2³+1
    cmp    #$58                  ; 2
    bcs    LF915                 ; 2³+1
LF8F2:
    lda    $85                   ; 3
    and    #$40                  ; 2
    bne    LF915                 ; 2³+1
    lda    $85                   ; 3
    ora    #$40                  ; 2
    sta    $85                   ; 3
    lda    #$35                  ; 2
    sta    $89                   ; 3
    lda    #$A8                  ; 2
    sta    $EB                   ; 3
    lda    #6                    ; 2
    sta    $EC                   ; 3
    rts                          ; 6

LF90B:
    lda    $D8                   ; 3
    cmp    #$21                  ; 2
    bcc    LF915                 ; 2³
    cmp    #$5C                  ; 2
    bcc    LF8F2                 ; 2³+1
LF915:
    rts                          ; 6

LF916:
    lda    $DC                   ; 3
    beq    LF968                 ; 2³
    lda    $87                   ; 3
    cmp    #$14                  ; 2
    beq    LF915                 ; 2³

  IF SEGA_GENESIS
    BIT    SWCHB
    LDA   INPT4
    ASL
    LDA   INPT1
    BVS    .reverse
    BCC    LF933
    BMI    LF939
    BPL    .cont1   ; always branch

.reverse:
    BPL    LF933
    BCS    LF939
.cont1

  ELSE
    lda    SWCHA                 ; 4
    and    #$30                  ; 2
    cmp    #$30                  ; 2
    beq    LF939                 ; 2³

    and    #$20                  ; 2
    beq    LF933                 ; 2³
  ENDIF

    lda    $85                   ; 3
    and    #$7F                  ; 2
    bpl    LF937                 ; 2³
LF933:
    lda    $85                   ; 3
    ora    #$80                  ; 2
LF937:
    sta    $85                   ; 3
LF939:
    lda    $88                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2

  IF SEGA_GENESIS
    LDA    SWCHA
    ASL
    ASL
    ASL
    LDA    #$F4
    BCC    LF951
    CLC

  ELSE
    clc                          ; 2
    lda    #$F4                  ; 2
    bit    INPT4 | $30           ; 3
    bpl    LF951                 ; 2³
  ENDIF

    bit    $85                   ; 3
    bmi    LF959                 ; 2³
    lda    LFC8E,X               ; 4
    bpl    LF95C                 ; 2³
LF951:
    adc    $88                   ; 3
    bcs    LF965                 ; 2³
    lda    #0                    ; 2
    beq    LF965                 ; 2³
LF959:
    lda    LFC95,X               ; 4
LF95C:
    clc                          ; 2
    adc    $88                   ; 3
    cmp    #$A3                  ; 2
    bcc    LF965                 ; 2³
    lda    #$A3                  ; 2
LF965:
    sta    $88                   ; 3
    rts                          ; 6

LF968:

  IF SEGA_GENESIS
    LDA    SWCHA
    ASL
    ASL
    ASL
    LDA    $E6
    BCC    BUTDOWN
    AND    #$DF
    .byte $0C  ; NOP, skip 2 bytes
BUTDOWN
    ORA    #$20
    STA    $E6

  ELSE
    bit    INPT4 | $30           ; 3
    bpl    LF973                 ; 2³
    lda    $E6                   ; 3
    and    #$DF                  ; 2
    sta    $E6                   ; 3
    rts                          ; 6

LF973:
    lda    $E6                   ; 3
    ora    #$20                  ; 2
    sta    $E6                   ; 3
  ENDIF


LF979:
    rts                          ; 6

    .byte $62 ; | XX   X | $F97A
    .byte $64 ; | XX  X  | $F97B
    .byte $66 ; | XX  XX | $F97C
    .byte $68 ; | XX X   | $F97D
LF97E:
    .byte $70 ; | XXX    | $F97E
    .byte $12 ; |   X  X | $F97F
    .byte $0E ; |    XXX | $F980
    .byte $0B ; |    X XX| $F981
    .byte $09 ; |    X  X| $F982
    .byte $06 ; |     XX | $F983
    .byte $04 ; |     X  | $F984
PNTTAB:
    .byte $02 ; |      X | $F985
    .byte $02 ; |      X | $F986
    .byte $02 ; |      X | $F987
    .byte $02 ; |      X | $F988
    .byte $02 ; |      X | $F989
    .byte $04 ; |     X  | $F98A
    .byte $06 ; |     XX | $F98B
    .byte $20 ; |  X     | $F98C
    .byte $00 ; |        | $F98D
LF98E:
    .byte $00 ; |        | $F98E
    .byte $05 ; |     X X| $F98F
    .byte $0A ; |    X X | $F990
LF991:
    .byte $10 ; |   X    | $F991
    .byte $15 ; |   X X X| $F992
    .byte $15 ; |   X X X| $F993
    .byte $17 ; |   X XXX| $F994
    .byte $17 ; |   X XXX| $F995
    .byte $17 ; |   X XXX| $F996
LF997:
    .byte $03 ; |      XX| $F997
    .byte $07 ; |     XXX| $F998
    .byte $0F ; |    XXXX| $F999
    .byte $1F ; |   XXXXX| $F99A
LF99B:
    .byte $3F ; |  XXXXXX| $F99B
    .byte $7F ; | XXXXXXX| $F99C
    .byte $3F ; |  XXXXXX| $F99D
    .byte $3F ; |  XXXXXX| $F99E
    .byte $3F ; |  XXXXXX| $F99F
LF9A0:
    .byte $00 ; |        | $F9A0
    .byte $04 ; |     X  | $F9A1
    .byte $07 ; |     XXX| $F9A2
    .byte $0A ; |    X X | $F9A3
    .byte $0F ; |    XXXX| $F9A4
    .byte $1D ; |   XXX X| $F9A5
LF9A6:
    .byte $F0 ; |XXXX    | $F9A6
    .byte $ED ; |XXX XX X| $F9A7
    .byte $ED ; |XXX XX X| $F9A8
    .byte $E6 ; |XXX  XX | $F9A9
    .byte $E6 ; |XXX  XX | $F9AA
    .byte $E6 ; |XXX  XX | $F9AB
LF9AC:
    .byte $1E ; |   XXXX | $F9AC
    .byte $0F ; |    XXXX| $F9AD
    .byte $0A ; |    X X | $F9AE
    .byte $05 ; |     X X| $F9AF
    .byte $02 ; |      X | $F9B0
    .byte $01 ; |       X| $F9B1
LF9B2:
    .byte $00 ; |        | $F9B2
    .byte $0A ; |    X X | $F9B3
    .byte $14 ; |   X X  | $F9B4
    .byte $1E ; |   XXXX | $F9B5
    .byte $32 ; |  XX  X | $F9B6
    .byte $50 ; | X X    | $F9B7
    .byte $96 ; |X  X XX | $F9B8
LF9B9:
    .byte $98 ; |X  XX   | $F9B9
    .byte $90 ; |X  X    | $F9BA
    .byte $88 ; |X   X   | $F9BB
    .byte $80 ; |X       | $F9BC
LF9BD:
    .byte $00 ; |        | $F9BD
    .byte $00 ; |        | $F9BE
    .byte $00 ; |        | $F9BF
    .byte $00 ; |        | $F9C0
    .byte $00 ; |        | $F9C1
    .byte $00 ; |        | $F9C2
    .byte $00 ; |        | $F9C3
    .byte $00 ; |        | $F9C4
    .byte $00 ; |        | $F9C5
    .byte $00 ; |        | $F9C6
    .byte $00 ; |        | $F9C7
    .byte $01 ; |       X| $F9C8
    .byte $00 ; |        | $F9C9
    .byte $00 ; |        | $F9CA
    .byte $00 ; |        | $F9CB
    .byte $02 ; |      X | $F9CC
    .byte $00 ; |        | $F9CD
    .byte $00 ; |        | $F9CE
    .byte $01 ; |       X| $F9CF
    .byte $03 ; |      XX| $F9D0
    .byte $00 ; |        | $F9D1
    .byte $00 ; |        | $F9D2
    .byte $02 ; |      X | $F9D3
    .byte $04 ; |     X  | $F9D4
    .byte $00 ; |        | $F9D5
    .byte $01 ; |       X| $F9D6
    .byte $03 ; |      XX| $F9D7
    .byte $05 ; |     X X| $F9D8
    .byte $00 ; |        | $F9D9
    .byte $02 ; |      X | $F9DA
    .byte $04 ; |     X  | $F9DB
    .byte $06 ; |     XX | $F9DC
    .byte $00 ; |        | $F9DD
    .byte $03 ; |      XX| $F9DE
    .byte $05 ; |     X X| $F9DF
    .byte $07 ; |     XXX| $F9E0
    .byte $00 ; |        | $F9E1
    .byte $04 ; |     X  | $F9E2
    .byte $06 ; |     XX | $F9E3
    .byte $08 ; |    X   | $F9E4
    .byte $00 ; |        | $F9E5
    .byte $05 ; |     X X| $F9E6
    .byte $07 ; |     XXX| $F9E7
    .byte $09 ; |    X  X| $F9E8
    .byte $00 ; |        | $F9E9
    .byte $06 ; |     XX | $F9EA
    .byte $08 ; |    X   | $F9EB
    .byte $0A ; |    X X | $F9EC
LF9ED:
    .byte $05 ; |     X X| $F9ED
    .byte $07 ; |     XXX| $F9EE
    .byte $09 ; |    X  X| $F9EF
    .byte $0B ; |    X XX| $F9F0
    .byte $0D ; |    XX X| $F9F1
    .byte $0F ; |    XXXX| $F9F2
    .byte $0D ; |    XX X| $F9F3
    .byte $0B ; |    X XX| $F9F4
    .byte $09 ; |    X  X| $F9F5
    .byte $07 ; |     XXX| $F9F6
LF9F7:
    .byte $01 ; |       X| $F9F7
LF9F8:
    .byte $00 ; |        | $F9F8
    .byte $00 ; |        | $F9F9
    .byte $00 ; |        | $F9FA
    .byte $00 ; |        | $F9FB
    .byte $00 ; |        | $F9FC
    .byte $00 ; |        | $F9FD
    .byte $00 ; |        | $F9FE
    .byte $00 ; |        | $F9FF
    .byte $00 ; |        | $FA00
    .byte $00 ; |        | $FA01
    .byte $00 ; |        | $FA02
    .byte $00 ; |        | $FA03
LFA04:
    .byte $00 ; |        | $FA04
LFA05:
    .byte $00 ; |        | $FA05
    .byte $00 ; |        | $FA06
    .byte $00 ; |        | $FA07
    .byte $00 ; |        | $FA08
    .byte $00 ; |        | $FA09
    .byte $00 ; |        | $FA0A
    .byte $00 ; |        | $FA0B
LFA0C:
    .byte $00 ; |        | $FA0C
    .byte $00 ; |        | $FA0D
    .byte $00 ; |        | $FA0E
    .byte $00 ; |        | $FA0F
    .byte $00 ; |        | $FA10
    .byte $00 ; |        | $FA11
    .byte $00 ; |        | $FA12
    .byte $00 ; |        | $FA13
    .byte $00 ; |        | $FA14
    .byte $00 ; |        | $FA15
    .byte $00 ; |        | $FA16
    .byte $00 ; |        | $FA17
    .byte $00 ; |        | $FA18
    .byte $00 ; |        | $FA19
    .byte $00 ; |        | $FA1A
    .byte $00 ; |        | $FA1B
    .byte $00 ; |        | $FA1C
    .byte $00 ; |        | $FA1D
    .byte $00 ; |        | $FA1E
    .byte $00 ; |        | $FA1F
    .byte $00 ; |        | $FA20
    .byte $00 ; |        | $FA21
    .byte $00 ; |        | $FA22
    .byte $00 ; |        | $FA23
    .byte $00 ; |        | $FA24
    .byte $00 ; |        | $FA25
    .byte $00 ; |        | $FA26
    .byte $00 ; |        | $FA27
    .byte $00 ; |        | $FA28
    .byte $00 ; |        | $FA29
    .byte $00 ; |        | $FA2A
    .byte $00 ; |        | $FA2B
    .byte $00 ; |        | $FA2C
    .byte $00 ; |        | $FA2D
    .byte $00 ; |        | $FA2E
    .byte $00 ; |        | $FA2F
    .byte $00 ; |        | $FA30
    .byte $00 ; |        | $FA31
    .byte $00 ; |        | $FA32
    .byte $00 ; |        | $FA33
    .byte $00 ; |        | $FA34
    .byte $00 ; |        | $FA35
    .byte $00 ; |        | $FA36
LFA37:
    lda    $E8                   ; 3
    sta    $E1                   ; 3
    lda    $EC                   ; 3
    sta    $E0                   ; 3
    lda    #3                    ; 2
    tay                          ; 2
LFA42:
    lsr    $E1                   ; 5
    ror    $E0                   ; 5
    ror                          ; 2
    dey                          ; 2
    bpl    LFA42                 ; 2³
    sta    $DF                   ; 3
    rts                          ; 6

LFA4D:
    lda    $DC                   ; 3
    ora    $88                   ; 3
    ora    $E2                   ; 3
    bne    LFA6E                 ; 2³
    lda    $EB                   ; 3
    cmp    #$FF                  ; 2
    bne    LFA6E                 ; 2³
    lda    $E3                   ; 3
    bne    LFAAB                 ; 2³
    lda    $FF                   ; 3
    eor    #$01                  ; 2
    sta    $FF                   ; 3
    lsr                          ; 2
    bcc    LFAAB                 ; 2³
    lda    $85                   ; 3
    eor    #$20                  ; 2
    sta    $85                   ; 3
LFA6E:
    rts                          ; 6

    .byte $00 ; |        | $FA6F
    .byte $00 ; |        | $FA70
    .byte $00 ; |        | $FA71
    .byte $00 ; |        | $FA72
    .byte $00 ; |        | $FA73
    .byte $00 ; |        | $FA74
    .byte $00 ; |        | $FA75
    .byte $00 ; |        | $FA76
    .byte $00 ; |        | $FA77
    .byte $00 ; |        | $FA78
    .byte $00 ; |        | $FA79
    .byte $00 ; |        | $FA7A
    .byte $00 ; |        | $FA7B
    .byte $00 ; |        | $FA7C
    .byte $00 ; |        | $FA7D
    .byte $00 ; |        | $FA7E
    .byte $00 ; |        | $FA7F
    .byte $00 ; |        | $FA80
    .byte $00 ; |        | $FA81
    .byte $00 ; |        | $FA82
    .byte $00 ; |        | $FA83
    .byte $00 ; |        | $FA84
    .byte $00 ; |        | $FA85
    .byte $00 ; |        | $FA86
    .byte $00 ; |        | $FA87
    .byte $00 ; |        | $FA88
    .byte $00 ; |        | $FA89
    .byte $00 ; |        | $FA8A
    .byte $00 ; |        | $FA8B
    .byte $00 ; |        | $FA8C
    .byte $00 ; |        | $FA8D
    .byte $00 ; |        | $FA8E
    .byte $00 ; |        | $FA8F
    .byte $00 ; |        | $FA90
    .byte $00 ; |        | $FA91
    .byte $00 ; |        | $FA92
    .byte $00 ; |        | $FA93
    .byte $00 ; |        | $FA94
    .byte $00 ; |        | $FA95
    .byte $00 ; |        | $FA96
    .byte $00 ; |        | $FA97
    .byte $00 ; |        | $FA98
    .byte $00 ; |        | $FA99
    .byte $00 ; |        | $FA9A
    .byte $00 ; |        | $FA9B
    .byte $00 ; |        | $FA9C
    .byte $00 ; |        | $FA9D
    .byte $00 ; |        | $FA9E
    .byte $00 ; |        | $FA9F
    .byte $00 ; |        | $FAA0
    .byte $00 ; |        | $FAA1
    .byte $00 ; |        | $FAA2
    .byte $00 ; |        | $FAA3
    .byte $00 ; |        | $FAA4
    .byte $00 ; |        | $FAA5
    .byte $00 ; |        | $FAA6
    .byte $00 ; |        | $FAA7
    .byte $00 ; |        | $FAA8
    .byte $00 ; |        | $FAA9
    .byte $00 ; |        | $FAAA

LFAAB:
    and    #$7F                  ; 2
    bne    LFAF6                 ; 2³
    lda    $87                   ; 3
    cmp    #$14                  ; 2
    bne    LFAF6                 ; 2³
    lda    $FF                   ; 3
    eor    #$20                  ; 2
    sta    $FF                   ; 3
    and    #$20                  ; 2
    bne    LFAC2                 ; 2³
    jmp    LFA37                 ; 3

LFAC2:
    ldy    #4                    ; 2
LFAC4:
    asl    $DF                   ; 5
    rol    $E0                   ; 5
    rol    $E1                   ; 5
    dey                          ; 2
    bne    LFAC4                 ; 2³
    lda    $E0                   ; 3
    sta    $EC                   ; 3
    lda    $E1                   ; 3
    sta    $E8                   ; 3
    sed                          ; 2
    lda    $DE                   ; 3
    sta    $DF                   ; 3
    lda    #$27                  ; 2
    sec                          ; 2
    sbc    $FE                   ; 3
    cld                          ; 2
    php                          ; 3
    sta    $E0                   ; 3
    ldy    #3                    ; 2
LFAE5:
    asl    $DF                   ; 5
    rol    $E0                   ; 5
    lsr                          ; 2
    dey                          ; 2
    bpl    LFAE5                 ; 2³
    ora    #$10                  ; 2
    plp                          ; 4
    bcc    LFAF4                 ; 2³
    adc    #$0F                  ; 2
LFAF4:
    sta    $E1                   ; 3
LFAF6:
    rts                          ; 6

    .byte $01 ; |       X| $FAF7
    .byte $01 ; |       X| $FAF8
    .byte $01 ; |       X| $FAF9
    .byte $01 ; |       X| $FAFA
    .byte $01 ; |       X| $FAFB
    .byte $01 ; |       X| $FAFC
    .byte $01 ; |       X| $FAFD
    .byte $01 ; |       X| $FAFE
    .byte $00 ; |        | $FAFF
    .byte $00 ; |        | $FB00
    .byte $00 ; |        | $FB01
    .byte $00 ; |        | $FB02
    .byte $00 ; |        | $FB03
    .byte $00 ; |        | $FB04
    .byte $00 ; |        | $FB05
    .byte $00 ; |        | $FB06
    .byte $00 ; |        | $FB07
    .byte $00 ; |        | $FB08
    .byte $00 ; |        | $FB09
    .byte $00 ; |        | $FB0A
    .byte $00 ; |        | $FB0B
    .byte $00 ; |        | $FB0C
    .byte $00 ; |        | $FB0D
    .byte $00 ; |        | $FB0E
    .byte $00 ; |        | $FB0F
    .byte $00 ; |        | $FB10
    .byte $00 ; |        | $FB11
    .byte $00 ; |        | $FB12
    .byte $00 ; |        | $FB13
    .byte $00 ; |        | $FB14
    .byte $00 ; |        | $FB15
    .byte $00 ; |        | $FB16
    .byte $00 ; |        | $FB17
    .byte $00 ; |        | $FB18
    .byte $00 ; |        | $FB19
    .byte $00 ; |        | $FB1A
    .byte $00 ; |        | $FB1B
    .byte $00 ; |        | $FB1C
    .byte $00 ; |        | $FB1D
    .byte $00 ; |        | $FB1E
    .byte $00 ; |        | $FB1F
    .byte $00 ; |        | $FB20
    .byte $00 ; |        | $FB21
    .byte $00 ; |        | $FB22
    .byte $00 ; |        | $FB23
LFB24:
    .byte $00 ; |        | $FB24
    .byte $00 ; |        | $FB25
    .byte $01 ; |       X| $FB26
    .byte $01 ; |       X| $FB27
    .byte $01 ; |       X| $FB28
    .byte $02 ; |      X | $FB29
    .byte $02 ; |      X | $FB2A
    .byte $03 ; |      XX| $FB2B
    .byte $03 ; |      XX| $FB2C
    .byte $04 ; |     X  | $FB2D
    .byte $04 ; |     X  | $FB2E
    .byte $05 ; |     X X| $FB2F
    .byte $05 ; |     X X| $FB30
    .byte $06 ; |     XX | $FB31
    .byte $08 ; |    X   | $FB32
    .byte $09 ; |    X  X| $FB33
    .byte $0B ; |    X XX| $FB34
    .byte $0D ; |    XX X| $FB35
    .byte $0F ; |    XXXX| $FB36
    .byte $12 ; |   X  X | $FB37
    .byte $15 ; |   X X X| $FB38
    .byte $19 ; |   XX  X| $FB39
    .byte $1D ; |   XXX X| $FB3A
    .byte $22 ; |  X   X | $FB3B
    .byte $28 ; |  X X   | $FB3C
LFB3D:
    .byte $70 ; | XXX    | $FB3D
    .byte $70 ; | XXX    | $FB3E
    .byte $70 ; | XXX    | $FB3F
    .byte $70 ; | XXX    | $FB40
    .byte $70 ; | XXX    | $FB41
    .byte $70 ; | XXX    | $FB42
    .byte $70 ; | XXX    | $FB43
    .byte $70 ; | XXX    | $FB44
    .byte $60 ; | XX     | $FB45
    .byte $50 ; | X X    | $FB46
    .byte $40 ; | X      | $FB47
    .byte $30 ; |  XX    | $FB48
    .byte $20 ; |  X     | $FB49
    .byte $10 ; |   X    | $FB4A
    .byte $00 ; |        | $FB4B
    .byte $F0 ; |XXXX    | $FB4C
    .byte $E0 ; |XXX     | $FB4D
LFB4E:
    .byte $70 ; | XXX    | $FB4E
    .byte $70 ; | XXX    | $FB4F
    .byte $60 ; | XX     | $FB50
    .byte $50 ; | X X    | $FB51
    .byte $40 ; | X      | $FB52
    .byte $30 ; |  XX    | $FB53
    .byte $20 ; |  X     | $FB54
    .byte $10 ; |   X    | $FB55
LFB56:
    .byte $00 ; |        | $FB56
    .byte $F0 ; |XXXX    | $FB57
    .byte $E0 ; |XXX     | $FB58
    .byte $D0 ; |XX X    | $FB59
    .byte $C0 ; |XX      | $FB5A
    .byte $B0 ; |X XX    | $FB5B
    .byte $A0 ; |X X     | $FB5C
    .byte $90 ; |X  X    | $FB5D
    .byte $80 ; |X       | $FB5E
    .byte $61 ; | XX    X| $FB5F
    .byte $51 ; | X X   X| $FB60
    .byte $41 ; | X     X| $FB61
    .byte $31 ; |  XX   X| $FB62
    .byte $21 ; |  X    X| $FB63
    .byte $11 ; |   X   X| $FB64
    .byte $01 ; |       X| $FB65
    .byte $F1 ; |XXXX   X| $FB66
    .byte $E1 ; |XXX    X| $FB67
    .byte $D1 ; |XX X   X| $FB68
    .byte $C1 ; |XX     X| $FB69
    .byte $B1 ; |X XX   X| $FB6A
    .byte $A1 ; |X X    X| $FB6B
    .byte $91 ; |X  X   X| $FB6C
    .byte $81 ; |X      X| $FB6D
    .byte $62 ; | XX   X | $FB6E
    .byte $52 ; | X X  X | $FB6F
    .byte $42 ; | X    X | $FB70
    .byte $32 ; |  XX  X | $FB71
    .byte $22 ; |  X   X | $FB72
    .byte $12 ; |   X  X | $FB73
    .byte $02 ; |      X | $FB74
    .byte $F2 ; |XXXX  X | $FB75
    .byte $E2 ; |XXX   X | $FB76
    .byte $D2 ; |XX X  X | $FB77
    .byte $C2 ; |XX    X | $FB78
    .byte $B2 ; |X XX  X | $FB79
    .byte $A2 ; |X X   X | $FB7A
    .byte $92 ; |X  X  X | $FB7B
    .byte $82 ; |X     X | $FB7C
    .byte $63 ; | XX   XX| $FB7D
    .byte $53 ; | X X  XX| $FB7E
    .byte $43 ; | X    XX| $FB7F
    .byte $33 ; |  XX  XX| $FB80
    .byte $23 ; |  X   XX| $FB81
    .byte $13 ; |   X  XX| $FB82
    .byte $03 ; |      XX| $FB83
    .byte $F3 ; |XXXX  XX| $FB84
    .byte $E3 ; |XXX   XX| $FB85
    .byte $D3 ; |XX X  XX| $FB86
    .byte $C3 ; |XX    XX| $FB87
    .byte $B3 ; |X XX  XX| $FB88
    .byte $A3 ; |X X   XX| $FB89
    .byte $93 ; |X  X  XX| $FB8A
    .byte $83 ; |X     XX| $FB8B
    .byte $64 ; | XX  X  | $FB8C
    .byte $54 ; | X X X  | $FB8D
    .byte $44 ; | X   X  | $FB8E
    .byte $34 ; |  XX X  | $FB8F
    .byte $24 ; |  X  X  | $FB90
    .byte $14 ; |   X X  | $FB91
    .byte $04 ; |     X  | $FB92
    .byte $F4 ; |XXXX X  | $FB93
    .byte $E4 ; |XXX  X  | $FB94
    .byte $D4 ; |XX X X  | $FB95
    .byte $C4 ; |XX   X  | $FB96
    .byte $B4 ; |X XX X  | $FB97
    .byte $A4 ; |X X  X  | $FB98
    .byte $94 ; |X  X X  | $FB99
    .byte $84 ; |X    X  | $FB9A
    .byte $65 ; | XX  X X| $FB9B
    .byte $55 ; | X X X X| $FB9C
    .byte $45 ; | X   X X| $FB9D
    .byte $35 ; |  XX X X| $FB9E
    .byte $25 ; |  X  X X| $FB9F
    .byte $15 ; |   X X X| $FBA0
    .byte $05 ; |     X X| $FBA1
    .byte $F5 ; |XXXX X X| $FBA2
    .byte $E5 ; |XXX  X X| $FBA3
    .byte $D5 ; |XX X X X| $FBA4
    .byte $C5 ; |XX   X X| $FBA5
    .byte $B5 ; |X XX X X| $FBA6
    .byte $A5 ; |X X  X X| $FBA7
    .byte $95 ; |X  X X X| $FBA8
    .byte $85 ; |X    X X| $FBA9
    .byte $66 ; | XX  XX | $FBAA
    .byte $56 ; | X X XX | $FBAB
    .byte $46 ; | X   XX | $FBAC
    .byte $36 ; |  XX XX | $FBAD
    .byte $26 ; |  X  XX | $FBAE
    .byte $16 ; |   X XX | $FBAF
    .byte $06 ; |     XX | $FBB0
    .byte $F6 ; |XXXX XX | $FBB1
    .byte $E6 ; |XXX  XX | $FBB2
    .byte $D6 ; |XX X XX | $FBB3
    .byte $C6 ; |XX   XX | $FBB4
    .byte $B6 ; |X XX XX | $FBB5
    .byte $A6 ; |X X  XX | $FBB6
    .byte $96 ; |X  X XX | $FBB7
    .byte $86 ; |X    XX | $FBB8
    .byte $67 ; | XX  XXX| $FBB9
    .byte $57 ; | X X XXX| $FBBA
    .byte $47 ; | X   XXX| $FBBB
    .byte $37 ; |  XX XXX| $FBBC
    .byte $27 ; |  X  XXX| $FBBD
    .byte $17 ; |   X XXX| $FBBE
    .byte $07 ; |     XXX| $FBBF
    .byte $F7 ; |XXXX XXX| $FBC0
    .byte $E7 ; |XXX  XXX| $FBC1
    .byte $D7 ; |XX X XXX| $FBC2
    .byte $C7 ; |XX   XXX| $FBC3
    .byte $B7 ; |X XX XXX| $FBC4
    .byte $A7 ; |X X  XXX| $FBC5
    .byte $97 ; |X  X XXX| $FBC6
    .byte $87 ; |X    XXX| $FBC7
    .byte $68 ; | XX X   | $FBC8
    .byte $58 ; | X XX   | $FBC9
    .byte $48 ; | X  X   | $FBCA
    .byte $38 ; |  XXX   | $FBCB
    .byte $28 ; |  X X   | $FBCC
    .byte $18 ; |   XX   | $FBCD
    .byte $08 ; |    X   | $FBCE
    .byte $F8 ; |XXXXX   | $FBCF
    .byte $E8 ; |XXX X   | $FBD0
    .byte $D8 ; |XX XX   | $FBD1
    .byte $C8 ; |XX  X   | $FBD2
    .byte $B8 ; |X XXX   | $FBD3
    .byte $A8 ; |X X X   | $FBD4
    .byte $98 ; |X  XX   | $FBD5
    .byte $88 ; |X   X   | $FBD6
    .byte $69 ; | XX X  X| $FBD7
    .byte $59 ; | X XX  X| $FBD8
    .byte $49 ; | X  X  X| $FBD9
    .byte $39 ; |  XXX  X| $FBDA
    .byte $29 ; |  X X  X| $FBDB
    .byte $19 ; |   XX  X| $FBDC
    .byte $09 ; |    X  X| $FBDD
    .byte $F9 ; |XXXXX  X| $FBDE
    .byte $E9 ; |XXX X  X| $FBDF
    .byte $D9 ; |XX XX  X| $FBE0
    .byte $C9 ; |XX  X  X| $FBE1
    .byte $B9 ; |X XXX  X| $FBE2
    .byte $A9 ; |X X X  X| $FBE3
    .byte $99 ; |X  XX  X| $FBE4
    .byte $89 ; |X   X  X| $FBE5
    .byte $6A ; | XX X X | $FBE6
    .byte $5A ; | X XX X | $FBE7
    .byte $4A ; | X  X X | $FBE8
    .byte $3A ; |  XXX X | $FBE9
    .byte $2A ; |  X X X | $FBEA
    .byte $1A ; |   XX X | $FBEB
    .byte $0A ; |    X X | $FBEC
    .byte $FA ; |XXXXX X | $FBED
    .byte $EA ; |XXX X X | $FBEE
    .byte $DA ; |XX XX X | $FBEF
    .byte $CA ; |XX  X X | $FBF0
    .byte $BA ; |X XXX X | $FBF1
    .byte $AA ; |X X X X | $FBF2
    .byte $9A ; |X  XX X | $FBF3
    .byte $8A ; |X   X X | $FBF4
    .byte $60 ; | XX     | $FBF5
    .byte $60 ; | XX     | $FBF6
    .byte $60 ; | XX     | $FBF7
    .byte $60 ; | XX     | $FBF8
    .byte $60 ; | XX     | $FBF9
    .byte $60 ; | XX     | $FBFA
    .byte $FE ; |XXXXXXX | $FBFB
    .byte $2E ; |  X XXX | $FBFC
    .byte $B7 ; |X XX XXX| $FBFD
    .byte $C8 ; |XX  X   | $FBFE
    .byte $AF ; |X X XXXX| $FBFF
    .byte $00 ; |        | $FC00
    .byte $00 ; |        | $FC01
    .byte $00 ; |        | $FC02
    .byte $00 ; |        | $FC03
    .byte $00 ; |        | $FC04
    .byte $00 ; |        | $FC05
    .byte $00 ; |        | $FC06
    .byte $00 ; |        | $FC07
    .byte $00 ; |        | $FC08
    .byte $00 ; |        | $FC09
    .byte $00 ; |        | $FC0A
    .byte $00 ; |        | $FC0B
    .byte $00 ; |        | $FC0C
    .byte $00 ; |        | $FC0D
    .byte $00 ; |        | $FC0E
    .byte $00 ; |        | $FC0F
    .byte $00 ; |        | $FC10
    .byte $00 ; |        | $FC11
    .byte $00 ; |        | $FC12
    .byte $00 ; |        | $FC13
    .byte $00 ; |        | $FC14
    .byte $00 ; |        | $FC15
    .byte $00 ; |        | $FC16
    .byte $00 ; |        | $FC17
    .byte $00 ; |        | $FC18
    .byte $00 ; |        | $FC19
    .byte $01 ; |       X| $FC1A
    .byte $01 ; |       X| $FC1B
    .byte $01 ; |       X| $FC1C
    .byte $01 ; |       X| $FC1D
    .byte $01 ; |       X| $FC1E
    .byte $02 ; |      X | $FC1F
    .byte $02 ; |      X | $FC20
    .byte $02 ; |      X | $FC21
    .byte $02 ; |      X | $FC22
    .byte $03 ; |      XX| $FC23
    .byte $03 ; |      XX| $FC24
    .byte $03 ; |      XX| $FC25
    .byte $04 ; |     X  | $FC26
    .byte $04 ; |     X  | $FC27
    .byte $05 ; |     X X| $FC28
    .byte $05 ; |     X X| $FC29
    .byte $06 ; |     XX | $FC2A
    .byte $07 ; |     XXX| $FC2B
    .byte $08 ; |    X   | $FC2C
    .byte $09 ; |    X  X| $FC2D
    .byte $0A ; |    X X | $FC2E
    .byte $0C ; |    XX  | $FC2F
    .byte $0E ; |    XXX | $FC30
    .byte $10 ; |   X    | $FC31
    .byte $01 ; |       X| $FC32
    .byte $01 ; |       X| $FC33
    .byte $01 ; |       X| $FC34
    .byte $01 ; |       X| $FC35
    .byte $02 ; |      X | $FC36
    .byte $02 ; |      X | $FC37
    .byte $02 ; |      X | $FC38
    .byte $03 ; |      XX| $FC39
    .byte $03 ; |      XX| $FC3A
    .byte $03 ; |      XX| $FC3B
    .byte $04 ; |     X  | $FC3C
    .byte $04 ; |     X  | $FC3D
    .byte $05 ; |     X X| $FC3E
    .byte $05 ; |     X X| $FC3F
    .byte $06 ; |     XX | $FC40
    .byte $07 ; |     XXX| $FC41
    .byte $08 ; |    X   | $FC42
    .byte $09 ; |    X  X| $FC43
    .byte $0A ; |    X X | $FC44
    .byte $0C ; |    XX  | $FC45
    .byte $0E ; |    XXX | $FC46
    .byte $10 ; |   X    | $FC47
    .byte $12 ; |   X  X | $FC48
    .byte $14 ; |   X X  | $FC49
    .byte $17 ; |   X XXX| $FC4A
    .byte $01 ; |       X| $FC4B
    .byte $01 ; |       X| $FC4C
    .byte $01 ; |       X| $FC4D
    .byte $01 ; |       X| $FC4E
    .byte $02 ; |      X | $FC4F
    .byte $02 ; |      X | $FC50
    .byte $02 ; |      X | $FC51
    .byte $03 ; |      XX| $FC52
    .byte $03 ; |      XX| $FC53
    .byte $04 ; |     X  | $FC54
    .byte $04 ; |     X  | $FC55
    .byte $05 ; |     X X| $FC56
    .byte $06 ; |     XX | $FC57
    .byte $07 ; |     XXX| $FC58
    .byte $08 ; |    X   | $FC59
    .byte $09 ; |    X  X| $FC5A
    .byte $0B ; |    X XX| $FC5B
    .byte $0D ; |    XX X| $FC5C
    .byte $0F ; |    XXXX| $FC5D
    .byte $11 ; |   X   X| $FC5E
    .byte $14 ; |   X X  | $FC5F
    .byte $17 ; |   X XXX| $FC60
    .byte $1B ; |   XX XX| $FC61
    .byte $1F ; |   XXXXX| $FC62
LFC63:
    .byte $24 ; |  X  X  | $FC63
    .byte $10 ; |   X    | $FC64
    .byte $00 ; |        | $FC65
    .byte $F8 ; |XXXXX   | $FC66
    .byte $30 ; |  XX    | $FC67
    .byte $00 ; |        | $FC68
    .byte $C0 ; |XX      | $FC69
    .byte $30 ; |  XX    | $FC6A
    .byte $00 ; |        | $FC6B
    .byte $FE ; |XXXXXXX | $FC6C
    .byte $FF ; |XXXXXXXX| $FC6D
    .byte $00 ; |        | $FC6E
    .byte $E0 ; |XXX     | $FC6F
    .byte $70 ; | XXX    | $FC70
    .byte $01 ; |       X| $FC71
    .byte $FF ; |XXXXXXXX| $FC72
    .byte $FF ; |XXXXXXXX| $FC73
    .byte $E0 ; |XXX     | $FC74
    .byte $F0 ; |XXXX    | $FC75
    .byte $F0 ; |XXXX    | $FC76
    .byte $07 ; |     XXX| $FC77
    .byte $FF ; |XXXXXXXX| $FC78
    .byte $FF ; |XXXXXXXX| $FC79
    .byte $F8 ; |XXXXX   | $FC7A
    .byte $F8 ; |XXXXX   | $FC7B
LFC7C:
    .byte $85 ; |X    X X| $FC7C
    .byte $89 ; |X   X  X| $FC7D
    .byte $8D ; |X   XX X| $FC7E
    .byte $91 ; |X  X   X| $FC7F
    .byte $95 ; |X  X X X| $FC80
    .byte $99 ; |X  XX  X| $FC81
LFC82:
    .byte $FE ; |XXXXXXX | $FC82
    .byte $FC ; |XXXXXX  | $FC83
    .byte $F8 ; |XXXXX   | $FC84
    .byte $F0 ; |XXXX    | $FC85
    .byte $E0 ; |XXX     | $FC86
    .byte $C0 ; |XX      | $FC87
LFC88:
    .byte $84 ; |X    X  | $FC88
    .byte $88 ; |X   X   | $FC89
    .byte $8C ; |X   XX  | $FC8A
    .byte $90 ; |X  X    | $FC8B
    .byte $94 ; |X  X X  | $FC8C
    .byte $98 ; |X  XX   | $FC8D
LFC8E:
    .byte $03 ; |      XX| $FC8E
    .byte $02 ; |      X | $FC8F
    .byte $01 ; |       X| $FC90
    .byte $FF ; |XXXXXXXX| $FC91
    .byte $FF ; |XXXXXXXX| $FC92
    .byte $FF ; |XXXXXXXX| $FC93
    .byte $FF ; |XXXXXXXX| $FC94
LFC95:
    .byte $01 ; |       X| $FC95
    .byte $01 ; |       X| $FC96
    .byte $01 ; |       X| $FC97
    .byte $02 ; |      X | $FC98
    .byte $02 ; |      X | $FC99
    .byte $01 ; |       X| $FC9A
    .byte $01 ; |       X| $FC9B
    .byte $FF ; |XXXXXXXX| $FC9C
    .byte $03 ; |      XX| $FC9D
    .byte $01 ; |       X| $FC9E
    .byte $00 ; |        | $FC9F
LFCA0:
    .byte $1F ; |   XXXXX| $FCA0
    .byte $1E ; |   XXXX | $FCA1
    .byte $1D ; |   XXX X| $FCA2
    .byte $1C ; |   XXX  | $FCA3
    .byte $1B ; |   XX XX| $FCA4
    .byte $1A ; |   XX X | $FCA5
    .byte $19 ; |   XX  X| $FCA6
    .byte $18 ; |   XX   | $FCA7
    .byte $17 ; |   X XXX| $FCA8
    .byte $16 ; |   X XX | $FCA9
    .byte $15 ; |   X X X| $FCAA
    .byte $14 ; |   X X  | $FCAB
    .byte $13 ; |   X  XX| $FCAC
    .byte $12 ; |   X  X | $FCAD
    .byte $11 ; |   X   X| $FCAE
    .byte $10 ; |   X    | $FCAF
    .byte $0F ; |    XXXX| $FCB0
    .byte $0E ; |    XXX | $FCB1
    .byte $0E ; |    XXX | $FCB2
    .byte $0D ; |    XX X| $FCB3
    .byte $0D ; |    XX X| $FCB4
    .byte $0C ; |    XX  | $FCB5
    .byte $0C ; |    XX  | $FCB6
    .byte $0B ; |    X XX| $FCB7
    .byte $0B ; |    X XX| $FCB8
    .byte $0A ; |    X X | $FCB9
    .byte $0A ; |    X X | $FCBA
    .byte $09 ; |    X  X| $FCBB
    .byte $09 ; |    X  X| $FCBC
    .byte $09 ; |    X  X| $FCBD
    .byte $09 ; |    X  X| $FCBE
    .byte $09 ; |    X  X| $FCBF
LFCC0:
    .byte $33 ; |  XX  XX| $FCC0
    .byte $32 ; |  XX  X | $FCC1
    .byte $31 ; |  XX   X| $FCC2
    .byte $30 ; |  XX    | $FCC3
    .byte $2F ; |  X XXXX| $FCC4
    .byte $2E ; |  X XXX | $FCC5
    .byte $2D ; |  X XX X| $FCC6
    .byte $2C ; |  X XX  | $FCC7
    .byte $2B ; |  X X XX| $FCC8
    .byte $2A ; |  X X X | $FCC9
    .byte $29 ; |  X X  X| $FCCA
    .byte $28 ; |  X X   | $FCCB
    .byte $27 ; |  X  XXX| $FCCC
    .byte $26 ; |  X  XX | $FCCD
    .byte $25 ; |  X  X X| $FCCE
    .byte $24 ; |  X  X  | $FCCF
    .byte $23 ; |  X   XX| $FCD0
    .byte $22 ; |  X   X | $FCD1
    .byte $21 ; |  X    X| $FCD2
    .byte $20 ; |  X     | $FCD3
    .byte $1F ; |   XXXXX| $FCD4
    .byte $1E ; |   XXXX | $FCD5
    .byte $1D ; |   XXX X| $FCD6
    .byte $1C ; |   XXX  | $FCD7
    .byte $1B ; |   XX XX| $FCD8
    .byte $1A ; |   XX X | $FCD9
    .byte $19 ; |   XX  X| $FCDA
    .byte $18 ; |   XX   | $FCDB
    .byte $17 ; |   X XXX| $FCDC
    .byte $16 ; |   X XX | $FCDD
    .byte $15 ; |   X X X| $FCDE
    .byte $14 ; |   X X  | $FCDF
    .byte $13 ; |   X  XX| $FCE0
    .byte $12 ; |   X  X | $FCE1
    .byte $11 ; |   X   X| $FCE2
    .byte $10 ; |   X    | $FCE3
    .byte $0F ; |    XXXX| $FCE4
    .byte $0E ; |    XXX | $FCE5
    .byte $0D ; |    XX X| $FCE6
    .byte $0C ; |    XX  | $FCE7
    .byte $0B ; |    X XX| $FCE8
    .byte $0A ; |    X X | $FCE9
    .byte $09 ; |    X  X| $FCEA
    .byte $08 ; |    X   | $FCEB
    .byte $07 ; |     XXX| $FCEC
    .byte $06 ; |     XX | $FCED
    .byte $05 ; |     X X| $FCEE
    .byte $04 ; |     X  | $FCEF
    .byte $03 ; |      XX| $FCF0
    .byte $02 ; |      X | $FCF1
    .byte $01 ; |       X| $FCF2
    .byte $00 ; |        | $FCF3
    .byte $00 ; |        | $FCF4
    .byte $00 ; |        | $FCF5
LFCF6:
    .byte $58 ; | X XX   | $FCF6
    .byte $50 ; | X X    | $FCF7
    .byte $48 ; | X  X   | $FCF8
    .byte $40 ; | X      | $FCF9
LFCFA:
    .byte $02 ; |      X | $FCFA
    .byte $CA ; |XX  X X | $FCFB
    .byte $9B ; |X  XX XX| $FCFC
    .byte $6F ; | XX XXXX| $FCFD
    .byte $46 ; | X   XX | $FCFE
    .byte $00 ; |        | $FCFF
LFD00:
    .byte $00 ; |        | $FD00
    .byte $00 ; |        | $FD01
    .byte $00 ; |        | $FD02
LFD03:
    .byte $00 ; |        | $FD03
    .byte $00 ; |        | $FD04
    .byte $00 ; |        | $FD05
    .byte $00 ; |        | $FD06
    .byte $00 ; |        | $FD07
    .byte $00 ; |        | $FD08
    .byte $00 ; |        | $FD09
    .byte $00 ; |        | $FD0A
    .byte $00 ; |        | $FD0B
    .byte $00 ; |        | $FD0C
    .byte $00 ; |        | $FD0D
    .byte $00 ; |        | $FD0E
    .byte $00 ; |        | $FD0F
    .byte $00 ; |        | $FD10
    .byte $00 ; |        | $FD11
    .byte $00 ; |        | $FD12
    .byte $00 ; |        | $FD13
    .byte $FF ; |XXXXXXXX| $FD14
    .byte $FF ; |XXXXXXXX| $FD15
    .byte $FE ; |XXXXXXX | $FD16
    .byte $FD ; |XXXXXX X| $FD17
    .byte $FD ; |XXXXXX X| $FD18
    .byte $FC ; |XXXXXX  | $FD19
    .byte $FB ; |XXXXX XX| $FD1A
    .byte $FB ; |XXXXX XX| $FD1B
    .byte $FA ; |XXXXX X | $FD1C
    .byte $F9 ; |XXXXX  X| $FD1D
    .byte $F9 ; |XXXXX  X| $FD1E
    .byte $F8 ; |XXXXX   | $FD1F
    .byte $F7 ; |XXXX XXX| $FD20
    .byte $F7 ; |XXXX XXX| $FD21
    .byte $F6 ; |XXXX XX | $FD22
    .byte $F5 ; |XXXX X X| $FD23
    .byte $F5 ; |XXXX X X| $FD24
    .byte $F4 ; |XXXX X  | $FD25
    .byte $F3 ; |XXXX  XX| $FD26
    .byte $F3 ; |XXXX  XX| $FD27
    .byte $F2 ; |XXXX  X | $FD28
    .byte $F1 ; |XXXX   X| $FD29
    .byte $F1 ; |XXXX   X| $FD2A
    .byte $F0 ; |XXXX    | $FD2B
    .byte $EF ; |XXX XXXX| $FD2C
    .byte $EF ; |XXX XXXX| $FD2D
    .byte $EE ; |XXX XXX | $FD2E
    .byte $ED ; |XXX XX X| $FD2F
    .byte $ED ; |XXX XX X| $FD30
    .byte $EC ; |XXX XX  | $FD31
    .byte $EB ; |XXX X XX| $FD32
    .byte $EB ; |XXX X XX| $FD33
    .byte $EA ; |XXX X X | $FD34
    .byte $E9 ; |XXX X  X| $FD35
    .byte $E9 ; |XXX X  X| $FD36
    .byte $E8 ; |XXX X   | $FD37
    .byte $E7 ; |XXX  XXX| $FD38
    .byte $E7 ; |XXX  XXX| $FD39
    .byte $E6 ; |XXX  XX | $FD3A
    .byte $E5 ; |XXX  X X| $FD3B
    .byte $E5 ; |XXX  X X| $FD3C
    .byte $E4 ; |XXX  X  | $FD3D
    .byte $E3 ; |XXX   XX| $FD3E
    .byte $E3 ; |XXX   XX| $FD3F
    .byte $E2 ; |XXX   X | $FD40
    .byte $E1 ; |XXX    X| $FD41
    .byte $E1 ; |XXX    X| $FD42
    .byte $E0 ; |XXX     | $FD43
    .byte $DF ; |XX XXXXX| $FD44
    .byte $DF ; |XX XXXXX| $FD45
    .byte $DE ; |XX XXXX | $FD46
    .byte $DD ; |XX XXX X| $FD47
    .byte $DD ; |XX XXX X| $FD48
    .byte $DC ; |XX XXX  | $FD49
    .byte $DB ; |XX XX XX| $FD4A
    .byte $DB ; |XX XX XX| $FD4B
    .byte $DA ; |XX XX X | $FD4C
    .byte $D9 ; |XX XX  X| $FD4D
    .byte $D9 ; |XX XX  X| $FD4E
    .byte $D8 ; |XX XX   | $FD4F
    .byte $D7 ; |XX X XXX| $FD50
    .byte $D7 ; |XX X XXX| $FD51
    .byte $D6 ; |XX X XX | $FD52
    .byte $D5 ; |XX X X X| $FD53
    .byte $D5 ; |XX X X X| $FD54
    .byte $D4 ; |XX X X  | $FD55
    .byte $D3 ; |XX X  XX| $FD56
    .byte $D3 ; |XX X  XX| $FD57
    .byte $D2 ; |XX X  X | $FD58
    .byte $D1 ; |XX X   X| $FD59
    .byte $D1 ; |XX X   X| $FD5A
    .byte $D0 ; |XX X    | $FD5B
    .byte $CF ; |XX  XXXX| $FD5C
    .byte $CF ; |XX  XXXX| $FD5D
    .byte $CE ; |XX  XXX | $FD5E
    .byte $CD ; |XX  XX X| $FD5F
    .byte $CD ; |XX  XX X| $FD60
    .byte $CC ; |XX  XX  | $FD61
    .byte $CB ; |XX  X XX| $FD62
    .byte $CB ; |XX  X XX| $FD63
    .byte $CA ; |XX  X X | $FD64
    .byte $C9 ; |XX  X  X| $FD65
    .byte $C9 ; |XX  X  X| $FD66
    .byte $C8 ; |XX  X   | $FD67
    .byte $C7 ; |XX   XXX| $FD68
    .byte $C7 ; |XX   XXX| $FD69
    .byte $C6 ; |XX   XX | $FD6A
    .byte $C5 ; |XX   X X| $FD6B
    .byte $C5 ; |XX   X X| $FD6C
    .byte $C4 ; |XX   X  | $FD6D
    .byte $C3 ; |XX    XX| $FD6E
    .byte $C3 ; |XX    XX| $FD6F
    .byte $C2 ; |XX    X | $FD70
    .byte $C1 ; |XX     X| $FD71
    .byte $C1 ; |XX     X| $FD72
    .byte $C0 ; |XX      | $FD73
    .byte $BF ; |X XXXXXX| $FD74
    .byte $BF ; |X XXXXXX| $FD75
    .byte $BE ; |X XXXXX | $FD76
    .byte $BD ; |X XXXX X| $FD77
    .byte $BD ; |X XXXX X| $FD78
    .byte $BC ; |X XXXX  | $FD79
    .byte $BB ; |X XXX XX| $FD7A
    .byte $BB ; |X XXX XX| $FD7B
    .byte $BA ; |X XXX X | $FD7C
    .byte $B9 ; |X XXX  X| $FD7D
    .byte $B9 ; |X XXX  X| $FD7E
    .byte $B8 ; |X XXX   | $FD7F
    .byte $B7 ; |X XX XXX| $FD80
    .byte $B7 ; |X XX XXX| $FD81
    .byte $B6 ; |X XX XX | $FD82
    .byte $B5 ; |X XX X X| $FD83
    .byte $B5 ; |X XX X X| $FD84
    .byte $B4 ; |X XX X  | $FD85
    .byte $B3 ; |X XX  XX| $FD86
    .byte $B3 ; |X XX  XX| $FD87
    .byte $B2 ; |X XX  X | $FD88
    .byte $B1 ; |X XX   X| $FD89
    .byte $B1 ; |X XX   X| $FD8A
    .byte $B0 ; |X XX    | $FD8B
    .byte $AF ; |X X XXXX| $FD8C
    .byte $AF ; |X X XXXX| $FD8D
    .byte $AE ; |X X XXX | $FD8E
    .byte $AD ; |X X XX X| $FD8F
    .byte $AD ; |X X XX X| $FD90
    .byte $AC ; |X X XX  | $FD91
    .byte $AB ; |X X X XX| $FD92
    .byte $AB ; |X X X XX| $FD93
    .byte $AA ; |X X X X | $FD94
    .byte $A9 ; |X X X  X| $FD95
    .byte $A9 ; |X X X  X| $FD96
    .byte $A8 ; |X X X   | $FD97
    .byte $A7 ; |X X  XXX| $FD98
    .byte $A7 ; |X X  XXX| $FD99
    .byte $A6 ; |X X  XX | $FD9A
    .byte $A5 ; |X X  X X| $FD9B
    .byte $A5 ; |X X  X X| $FD9C
    .byte $A4 ; |X X  X  | $FD9D
    .byte $A3 ; |X X   XX| $FD9E
    .byte $A3 ; |X X   XX| $FD9F
    .byte $A2 ; |X X   X | $FDA0
    .byte $A1 ; |X X    X| $FDA1
    .byte $A1 ; |X X    X| $FDA2
    .byte $A0 ; |X X     | $FDA3
LFDA4:
    .byte $00 ; |        | $FDA4
    .byte $10 ; |   X    | $FDA5
    .byte $10 ; |   X    | $FDA6
    .byte $10 ; |   X    | $FDA7
    .byte $10 ; |   X    | $FDA8
    .byte $10 ; |   X    | $FDA9
    .byte $10 ; |   X    | $FDAA
    .byte $10 ; |   X    | $FDAB
    .byte $10 ; |   X    | $FDAC
    .byte $10 ; |   X    | $FDAD
    .byte $10 ; |   X    | $FDAE
    .byte $10 ; |   X    | $FDAF
    .byte $10 ; |   X    | $FDB0
    .byte $11 ; |   X   X| $FDB1
    .byte $21 ; |  X    X| $FDB2
    .byte $21 ; |  X    X| $FDB3
    .byte $FE ; |XXXXXXX | $FDB4
    .byte $FE ; |XXXXXXX | $FDB5
    .byte $FF ; |XXXXXXXX| $FDB6
    .byte $0F ; |    XXXX| $FDB7
    .byte $0F ; |    XXXX| $FDB8
    .byte $0F ; |    XXXX| $FDB9
    .byte $0F ; |    XXXX| $FDBA
    .byte $0F ; |    XXXX| $FDBB
    .byte $0F ; |    XXXX| $FDBC
    .byte $0F ; |    XXXX| $FDBD
    .byte $0F ; |    XXXX| $FDBE
    .byte $0F ; |    XXXX| $FDBF
    .byte $0F ; |    XXXX| $FDC0
    .byte $0F ; |    XXXX| $FDC1
    .byte $0F ; |    XXXX| $FDC2
    .byte $00 ; |        | $FDC3
LFDC4:
    .byte $FF ; |XXXXXXXX| $FDC4
    .byte $0C ; |    XX  | $FDC5
    .byte $05 ; |     X X| $FDC6
    .byte $03 ; |      XX| $FDC7
    .byte $14 ; |   X X  | $FDC8
    .byte $13 ; |   X  XX| $FDC9
    .byte $12 ; |   X  X | $FDCA
    .byte $00 ; |        | $FDCB
    .byte $21 ; |  X    X| $FDCC
    .byte $10 ; |   X    | $FDCD
    .byte $20 ; |  X     | $FDCE
    .byte $30 ; |  XX    | $FDCF
    .byte $60 ; | XX     | $FDD0
    .byte $FF ; |XXXXXXXX| $FDD1
    .byte $09 ; |    X  X| $FDD2
    .byte $04 ; |     X  | $FDD3
LFDD4:
    .byte $40 ; | X      | $FDD4
    .byte $90 ; |X  X    | $FDD5
    .byte $FF ; |XXXXXXXX| $FDD6
    .byte $06 ; |     XX | $FDD7
    .byte $03 ; |      XX| $FDD8
    .byte $02 ; |      X | $FDD9
    .byte $01 ; |       X| $FDDA
    .byte $12 ; |   X  X | $FDDB
    .byte $00 ; |        | $FDDC
    .byte $21 ; |  X    X| $FDDD
    .byte $31 ; |  XX   X| $FDDE
    .byte $41 ; | X     X| $FDDF
    .byte $30 ; |  XX    | $FDE0
    .byte $50 ; | X X    | $FDE1
    .byte $C0 ; |XX      | $FDE2
    .byte $FF ; |XXXXXXXX| $FDE3
OPENING:
    .byte $FF ; |XXXXXXXX| $FDE4
    .byte $00 ; |        | $FDE5
    .byte $0D ; |    XX X| $FDE6
    .byte $0D ; |    XX X| $FDE7
    .byte $0D ; |    XX X| $FDE8
    .byte $0D ; |    XX X| $FDE9
    .byte $0D ; |    XX X| $FDEA
    .byte $0D ; |    XX X| $FDEB
    .byte $0F ; |    XXXX| $FDEC
    .byte $0F ; |    XXXX| $FDED
    .byte $11 ; |   X   X| $FDEE
    .byte $11 ; |   X   X| $FDEF
    .byte $14 ; |   X X  | $FDF0
    .byte $14 ; |   X X  | $FDF1
    .byte $17 ; |   X XXX| $FDF2
    .byte $17 ; |   X XXX| $FDF3
    .byte $1B ; |   XX XX| $FDF4
    .byte $1B ; |   XX XX| $FDF5
    .byte $1F ; |   XXXXX| $FDF6
    .byte $1F ; |   XXXXX| $FDF7
    .byte $1B ; |   XX XX| $FDF8
    .byte $1B ; |   XX XX| $FDF9
    .byte $17 ; |   X XXX| $FDFA
    .byte $17 ; |   X XXX| $FDFB
    .byte $12 ; |   X  X | $FDFC
    .byte $12 ; |   X  X | $FDFD
    .byte $00 ; |        | $FDFE
    .byte $14 ; |   X X  | $FDFF
    .byte $00 ; |        | $FE00
    .byte $14 ; |   X X  | $FE01
    .byte $14 ; |   X X  | $FE02
    .byte $14 ; |   X X  | $FE03
    .byte $17 ; |   X XXX| $FE04
    .byte $17 ; |   X XXX| $FE05
    .byte $1B ; |   XX XX| $FE06
    .byte $1B ; |   XX XX| $FE07
    .byte $1F ; |   XXXXX| $FE08
    .byte $1F ; |   XXXXX| $FE09
    .byte $1B ; |   XX XX| $FE0A
    .byte $1B ; |   XX XX| $FE0B
    .byte $17 ; |   X XXX| $FE0C
    .byte $17 ; |   X XXX| $FE0D
    .byte $12 ; |   X  X | $FE0E
    .byte $12 ; |   X  X | $FE0F
    .byte $00 ; |        | $FE10
    .byte $14 ; |   X X  | $FE11
    .byte $00 ; |        | $FE12
    .byte $14 ; |   X X  | $FE13
    .byte $00 ; |        | $FE14
    .byte $14 ; |   X X  | $FE15
    .byte $14 ; |   X X  | $FE16
    .byte $14 ; |   X X  | $FE17
    .byte $14 ; |   X X  | $FE18
    .byte $14 ; |   X X  | $FE19
    .byte $14 ; |   X X  | $FE1A
    .byte $14 ; |   X X  | $FE1B
    .byte $FF ; |XXXXXXXX| $FE1C
    .byte $00 ; |        | $FE1D
    .byte $00 ; |        | $FE1E
    .byte $00 ; |        | $FE1F
    .byte $00 ; |        | $FE20
    .byte $00 ; |        | $FE21
    .byte $00 ; |        | $FE22
    .byte $00 ; |        | $FE23
    .byte $00 ; |        | $FE24
    .byte $0B ; |    X XX| $FE25
    .byte $0B ; |    X XX| $FE26
    .byte $0B ; |    X XX| $FE27
    .byte $0B ; |    X XX| $FE28
    .byte $0B ; |    X XX| $FE29
    .byte $0B ; |    X XX| $FE2A
    .byte $0B ; |    X XX| $FE2B
    .byte $0F ; |    XXXX| $FE2C
    .byte $0F ; |    XXXX| $FE2D
    .byte $12 ; |   X  X | $FE2E
    .byte $12 ; |   X  X | $FE2F
    .byte $0F ; |    XXXX| $FE30
    .byte $0F ; |    XXXX| $FE31
    .byte $00 ; |        | $FE32
    .byte $12 ; |   X  X | $FE33
    .byte $00 ; |        | $FE34
    .byte $12 ; |   X  X | $FE35
    .byte $00 ; |        | $FE36
    .byte $12 ; |   X  X | $FE37
    .byte $12 ; |   X  X | $FE38
    .byte $12 ; |   X  X | $FE39
    .byte $12 ; |   X  X | $FE3A
    .byte $12 ; |   X  X | $FE3B
    .byte $12 ; |   X  X | $FE3C
    .byte $12 ; |   X  X | $FE3D
    .byte $14 ; |   X X  | $FE3E
    .byte $14 ; |   X X  | $FE3F
    .byte $1F ; |   XXXXX| $FE40
    .byte $1F ; |   XXXXX| $FE41
    .byte $14 ; |   X X  | $FE42
    .byte $14 ; |   X X  | $FE43
    .byte $00 ; |        | $FE44
    .byte $17 ; |   X XXX| $FE45
    .byte $00 ; |        | $FE46
    .byte $17 ; |   X XXX| $FE47
    .byte $00 ; |        | $FE48
    .byte $17 ; |   X XXX| $FE49
    .byte $17 ; |   X XXX| $FE4A
    .byte $17 ; |   X XXX| $FE4B
    .byte $17 ; |   X XXX| $FE4C
    .byte $17 ; |   X XXX| $FE4D
    .byte $17 ; |   X XXX| $FE4E
    .byte $17 ; |   X XXX| $FE4F
STALL:
    .byte $FF ; |XXXXXXXX| $FE50
    .byte $00 ; |        | $FE51
    .byte $00 ; |        | $FE52
    .byte $17 ; |   X XXX| $FE53
    .byte $00 ; |        | $FE54
    .byte $17 ; |   X XXX| $FE55
    .byte $00 ; |        | $FE56
    .byte $17 ; |   X XXX| $FE57
    .byte $00 ; |        | $FE58
    .byte $17 ; |   X XXX| $FE59
    .byte $FF ; |XXXXXXXX| $FE5A
    .byte $0F ; |    XXXX| $FE5B
    .byte $0F ; |    XXXX| $FE5C
    .byte $00 ; |        | $FE5D
    .byte $1F ; |   XXXXX| $FE5E
    .byte $00 ; |        | $FE5F
    .byte $1F ; |   XXXXX| $FE60
    .byte $00 ; |        | $FE61
    .byte $1F ; |   XXXXX| $FE62
    .byte $FF ; |XXXXXXXX| $FE63
    .byte $10 ; |   X    | $FE64
    .byte $00 ; |        | $FE65
    .byte $10 ; |   X    | $FE66
    .byte $00 ; |        | $FE67
    .byte $10 ; |   X    | $FE68
    .byte $00 ; |        | $FE69
    .byte $10 ; |   X    | $FE6A
    .byte $00 ; |        | $FE6B
    .byte $FF ; |XXXXXXXX| $FE6C
    .byte $01 ; |       X| $FE6D
    .byte $02 ; |      X | $FE6E
    .byte $03 ; |      XX| $FE6F
    .byte $04 ; |     X  | $FE70
    .byte $05 ; |     X X| $FE71
    .byte $06 ; |     XX | $FE72
    .byte $07 ; |     XXX| $FE73
    .byte $0A ; |    X X | $FE74
    .byte $0B ; |    X XX| $FE75
    .byte $0F ; |    XXXX| $FE76
    .byte $0F ; |    XXXX| $FE77
    .byte $0F ; |    XXXX| $FE78
    .byte $0F ; |    XXXX| $FE79
    .byte $0F ; |    XXXX| $FE7A
    .byte $0F ; |    XXXX| $FE7B
    .byte $0F ; |    XXXX| $FE7C
    .byte $FF ; |XXXXXXXX| $FE7D
    .byte $18 ; |   XX   | $FE7E
    .byte $18 ; |   XX   | $FE7F
    .byte $18 ; |   XX   | $FE80
    .byte $18 ; |   XX   | $FE81
    .byte $18 ; |   XX   | $FE82
    .byte $18 ; |   XX   | $FE83
    .byte $18 ; |   XX   | $FE84
    .byte $18 ; |   XX   | $FE85
    .byte $18 ; |   XX   | $FE86
    .byte $18 ; |   XX   | $FE87
    .byte $18 ; |   XX   | $FE88
    .byte $18 ; |   XX   | $FE89
    .byte $18 ; |   XX   | $FE8A
    .byte $18 ; |   XX   | $FE8B
    .byte $18 ; |   XX   | $FE8C
    .byte $18 ; |   XX   | $FE8D
LFE8E:
    .byte $19 ; |   XX  X| $FE8E
    .byte $1D ; |   XXX X| $FE8F
    .byte $1B ; |   XX XX| $FE90
    .byte $1E ; |   XXXX | $FE91
    .byte $1B ; |   XX XX| $FE92
    .byte $1D ; |   XXX X| $FE93
    .byte $1A ; |   XX X | $FE94
    .byte $1C ; |   XXX  | $FE95
    .byte $1E ; |   XXXX | $FE96
    .byte $1B ; |   XX XX| $FE97
    .byte $19 ; |   XX  X| $FE98
    .byte $1C ; |   XXX  | $FE99
    .byte $1A ; |   XX X | $FE9A
    .byte $1E ; |   XXXX | $FE9B
    .byte $1D ; |   XXX X| $FE9C
    .byte $1B ; |   XX XX| $FE9D
LFE9E:
    .byte $FF ; |XXXXXXXX| $FE9E
    .byte $00 ; |        | $FE9F
    .byte $12 ; |   X  X | $FEA0
    .byte $12 ; |   X  X | $FEA1
    .byte $12 ; |   X  X | $FEA2
    .byte $12 ; |   X  X | $FEA3
    .byte $12 ; |   X  X | $FEA4
    .byte $12 ; |   X  X | $FEA5
    .byte $14 ; |   X X  | $FEA6
    .byte $14 ; |   X X  | $FEA7
    .byte $14 ; |   X X  | $FEA8
    .byte $14 ; |   X X  | $FEA9
    .byte $14 ; |   X X  | $FEAA
    .byte $14 ; |   X X  | $FEAB
    .byte $12 ; |   X  X | $FEAC
    .byte $12 ; |   X  X | $FEAD
    .byte $12 ; |   X  X | $FEAE
    .byte $12 ; |   X  X | $FEAF
    .byte $12 ; |   X  X | $FEB0
    .byte $12 ; |   X  X | $FEB1
    .byte $0F ; |    XXXX| $FEB2
    .byte $0F ; |    XXXX| $FEB3
    .byte $0F ; |    XXXX| $FEB4
    .byte $0F ; |    XXXX| $FEB5
    .byte $0F ; |    XXXX| $FEB6
    .byte $0F ; |    XXXX| $FEB7
    .byte $0D ; |    XX X| $FEB8
    .byte $0D ; |    XX X| $FEB9
    .byte $0D ; |    XX X| $FEBA
    .byte $0D ; |    XX X| $FEBB
    .byte $0D ; |    XX X| $FEBC
    .byte $0D ; |    XX X| $FEBD
    .byte $14 ; |   X X  | $FEBE
    .byte $14 ; |   X X  | $FEBF
    .byte $14 ; |   X X  | $FEC0
    .byte $14 ; |   X X  | $FEC1
    .byte $14 ; |   X X  | $FEC2
    .byte $14 ; |   X X  | $FEC3
    .byte $12 ; |   X  X | $FEC4
    .byte $12 ; |   X  X | $FEC5
    .byte $12 ; |   X  X | $FEC6
    .byte $12 ; |   X  X | $FEC7
    .byte $12 ; |   X  X | $FEC8
    .byte $12 ; |   X  X | $FEC9
    .byte $0F ; |    XXXX| $FECA
    .byte $0F ; |    XXXX| $FECB
    .byte $0F ; |    XXXX| $FECC
    .byte $0F ; |    XXXX| $FECD
    .byte $0F ; |    XXXX| $FECE
    .byte $0F ; |    XXXX| $FECF
    .byte $0D ; |    XX X| $FED0
    .byte $0D ; |    XX X| $FED1
    .byte $0D ; |    XX X| $FED2
    .byte $0D ; |    XX X| $FED3
    .byte $0D ; |    XX X| $FED4
    .byte $0D ; |    XX X| $FED5
    .byte $FF ; |XXXXXXXX| $FED6
    .byte $00 ; |        | $FED7
    .byte $00 ; |        | $FED8
    .byte $00 ; |        | $FED9
    .byte $00 ; |        | $FEDA
    .byte $00 ; |        | $FEDB
    .byte $00 ; |        | $FEDC
    .byte $00 ; |        | $FEDD
    .byte $00 ; |        | $FEDE
    .byte $00 ; |        | $FEDF
    .byte $1F ; |   XXXXX| $FEE0
    .byte $1F ; |   XXXXX| $FEE1
    .byte $1F ; |   XXXXX| $FEE2
    .byte $1F ; |   XXXXX| $FEE3
    .byte $1F ; |   XXXXX| $FEE4
    .byte $1F ; |   XXXXX| $FEE5
    .byte $00 ; |        | $FEE6
    .byte $14 ; |   X X  | $FEE7
    .byte $00 ; |        | $FEE8
    .byte $14 ; |   X X  | $FEE9
    .byte $00 ; |        | $FEEA
    .byte $14 ; |   X X  | $FEEB
    .byte $00 ; |        | $FEEC
    .byte $0F ; |    XXXX| $FEED
    .byte $00 ; |        | $FEEE
    .byte $0F ; |    XXXX| $FEEF
    .byte $00 ; |        | $FEF0
    .byte $0F ; |    XXXX| $FEF1
    .byte $0F ; |    XXXX| $FEF2
    .byte $0F ; |    XXXX| $FEF3
    .byte $0F ; |    XXXX| $FEF4
    .byte $0F ; |    XXXX| $FEF5
    .byte $0F ; |    XXXX| $FEF6
    .byte $0F ; |    XXXX| $FEF7
    .byte $00 ; |        | $FEF8
    .byte $14 ; |   X X  | $FEF9
    .byte $00 ; |        | $FEFA
    .byte $14 ; |   X X  | $FEFB
    .byte $00 ; |        | $FEFC
    .byte $14 ; |   X X  | $FEFD
    .byte $00 ; |        | $FEFE
    .byte $0F ; |    XXXX| $FEFF
    .byte $00 ; |        | $FF00
    .byte $0F ; |    XXXX| $FF01
    .byte $00 ; |        | $FF02
    .byte $0F ; |    XXXX| $FF03
    .byte $0F ; |    XXXX| $FF04
    .byte $0F ; |    XXXX| $FF05
    .byte $0F ; |    XXXX| $FF06
    .byte $0F ; |    XXXX| $FF07
    .byte $0F ; |    XXXX| $FF08
    .byte $0F ; |    XXXX| $FF09
    .byte $FF ; |XXXXXXXX| $FF0A
    .byte $00 ; |        | $FF0B
    .byte $00 ; |        | $FF0C
    .byte $08 ; |    X   | $FF0D
    .byte $00 ; |        | $FF0E
    .byte $08 ; |    X   | $FF0F
    .byte $00 ; |        | $FF10
    .byte $08 ; |    X   | $FF11
    .byte $00 ; |        | $FF12
    .byte $08 ; |    X   | $FF13
    .byte $FF ; |XXXXXXXX| $FF14
    .byte $0F ; |    XXXX| $FF15
    .byte $0F ; |    XXXX| $FF16
    .byte $00 ; |        | $FF17
    .byte $1F ; |   XXXXX| $FF18
    .byte $00 ; |        | $FF19
    .byte $1F ; |   XXXXX| $FF1A
    .byte $00 ; |        | $FF1B
    .byte $1F ; |   XXXXX| $FF1C
    .byte $FF ; |XXXXXXXX| $FF1D
    .byte $12 ; |   X  X | $FF1E
    .byte $00 ; |        | $FF1F
    .byte $12 ; |   X  X | $FF20
    .byte $00 ; |        | $FF21
    .byte $12 ; |   X  X | $FF22
    .byte $00 ; |        | $FF23
    .byte $12 ; |   X  X | $FF24
    .byte $00 ; |        | $FF25
    .byte $FF ; |XXXXXXXX| $FF26
    .byte $01 ; |       X| $FF27
    .byte $03 ; |      XX| $FF28
    .byte $04 ; |     X  | $FF29
    .byte $05 ; |     X X| $FF2A
    .byte $0F ; |    XXXX| $FF2B
    .byte $0F ; |    XXXX| $FF2C
    .byte $0F ; |    XXXX| $FF2D
    .byte $0F ; |    XXXX| $FF2E
    .byte $0F ; |    XXXX| $FF2F
    .byte $0F ; |    XXXX| $FF30
    .byte $0F ; |    XXXX| $FF31
    .byte $0F ; |    XXXX| $FF32
    .byte $0F ; |    XXXX| $FF33
    .byte $0F ; |    XXXX| $FF34
    .byte $0F ; |    XXXX| $FF35
    .byte $0F ; |    XXXX| $FF36
    .byte $FF ; |XXXXXXXX| $FF37
    .byte $0A ; |    X X | $FF38
    .byte $0A ; |    X X | $FF39
    .byte $0A ; |    X X | $FF3A
    .byte $0A ; |    X X | $FF3B
    .byte $0A ; |    X X | $FF3C
    .byte $0A ; |    X X | $FF3D
    .byte $0A ; |    X X | $FF3E
    .byte $0A ; |    X X | $FF3F
    .byte $0A ; |    X X | $FF40
    .byte $0A ; |    X X | $FF41
    .byte $0A ; |    X X | $FF42
    .byte $0A ; |    X X | $FF43
    .byte $07 ; |     XXX| $FF44
    .byte $07 ; |     XXX| $FF45
    .byte $07 ; |     XXX| $FF46
    .byte $07 ; |     XXX| $FF47
LFF48:
    .byte $00 ; |        | $FF48
    .byte $00 ; |        | $FF49
    .byte $00 ; |        | $FF4A
LFF4B:
    .byte $00 ; |        | $FF4B
    .byte $00 ; |        | $FF4C
    .byte $00 ; |        | $FF4D
    .byte $00 ; |        | $FF4E
    .byte $00 ; |        | $FF4F
    .byte $00 ; |        | $FF50
    .byte $00 ; |        | $FF51
    .byte $00 ; |        | $FF52
    .byte $00 ; |        | $FF53
    .byte $00 ; |        | $FF54
    .byte $00 ; |        | $FF55
    .byte $00 ; |        | $FF56
    .byte $00 ; |        | $FF57
    .byte $00 ; |        | $FF58
    .byte $00 ; |        | $FF59
    .byte $00 ; |        | $FF5A
    .byte $00 ; |        | $FF5B
    .byte $01 ; |       X| $FF5C
    .byte $01 ; |       X| $FF5D
    .byte $02 ; |      X | $FF5E
    .byte $02 ; |      X | $FF5F
    .byte $03 ; |      XX| $FF60
    .byte $04 ; |     X  | $FF61
    .byte $05 ; |     X X| $FF62
    .byte $05 ; |     X X| $FF63
    .byte $06 ; |     XX | $FF64
    .byte $07 ; |     XXX| $FF65
    .byte $07 ; |     XXX| $FF66
    .byte $08 ; |    X   | $FF67
    .byte $09 ; |    X  X| $FF68
    .byte $09 ; |    X  X| $FF69
    .byte $0A ; |    X X | $FF6A
    .byte $0B ; |    X XX| $FF6B
    .byte $0B ; |    X XX| $FF6C
    .byte $0C ; |    XX  | $FF6D
    .byte $0D ; |    XX X| $FF6E
    .byte $0D ; |    XX X| $FF6F
    .byte $0E ; |    XXX | $FF70
    .byte $0F ; |    XXXX| $FF71
    .byte $0F ; |    XXXX| $FF72
    .byte $10 ; |   X    | $FF73
    .byte $11 ; |   X   X| $FF74
    .byte $11 ; |   X   X| $FF75
    .byte $12 ; |   X  X | $FF76
    .byte $12 ; |   X  X | $FF77
    .byte $13 ; |   X  XX| $FF78
    .byte $14 ; |   X X  | $FF79
    .byte $15 ; |   X X X| $FF7A
    .byte $15 ; |   X X X| $FF7B
    .byte $16 ; |   X XX | $FF7C
    .byte $17 ; |   X XXX| $FF7D
    .byte $17 ; |   X XXX| $FF7E
    .byte $18 ; |   XX   | $FF7F
    .byte $19 ; |   XX  X| $FF80
    .byte $19 ; |   XX  X| $FF81
    .byte $1A ; |   XX X | $FF82
    .byte $1B ; |   XX XX| $FF83
    .byte $1B ; |   XX XX| $FF84
    .byte $1C ; |   XXX  | $FF85
    .byte $1D ; |   XXX X| $FF86
    .byte $1D ; |   XXX X| $FF87
    .byte $1E ; |   XXXX | $FF88
    .byte $1F ; |   XXXXX| $FF89
    .byte $1F ; |   XXXXX| $FF8A
    .byte $20 ; |  X     | $FF8B
    .byte $21 ; |  X    X| $FF8C
    .byte $21 ; |  X    X| $FF8D
    .byte $22 ; |  X   X | $FF8E
    .byte $22 ; |  X   X | $FF8F
    .byte $23 ; |  X   XX| $FF90
    .byte $24 ; |  X  X  | $FF91
    .byte $25 ; |  X  X X| $FF92
    .byte $25 ; |  X  X X| $FF93
    .byte $26 ; |  X  XX | $FF94
    .byte $27 ; |  X  XXX| $FF95
    .byte $27 ; |  X  XXX| $FF96
    .byte $28 ; |  X X   | $FF97
    .byte $29 ; |  X X  X| $FF98
    .byte $29 ; |  X X  X| $FF99
    .byte $2A ; |  X X X | $FF9A
    .byte $2B ; |  X X XX| $FF9B
    .byte $2B ; |  X X XX| $FF9C
    .byte $2C ; |  X XX  | $FF9D
    .byte $2D ; |  X XX X| $FF9E
    .byte $2D ; |  X XX X| $FF9F
    .byte $2E ; |  X XXX | $FFA0
    .byte $2F ; |  X XXXX| $FFA1
    .byte $2F ; |  X XXXX| $FFA2
    .byte $30 ; |  XX    | $FFA3
    .byte $31 ; |  XX   X| $FFA4
    .byte $31 ; |  XX   X| $FFA5
    .byte $32 ; |  XX  X | $FFA6
    .byte $32 ; |  XX  X | $FFA7
    .byte $33 ; |  XX  XX| $FFA8
    .byte $34 ; |  XX X  | $FFA9
    .byte $35 ; |  XX X X| $FFAA
    .byte $35 ; |  XX X X| $FFAB
    .byte $36 ; |  XX XX | $FFAC
    .byte $37 ; |  XX XXX| $FFAD
    .byte $37 ; |  XX XXX| $FFAE
    .byte $38 ; |  XXX   | $FFAF
    .byte $39 ; |  XXX  X| $FFB0
    .byte $39 ; |  XXX  X| $FFB1
    .byte $3A ; |  XXX X | $FFB2
    .byte $3B ; |  XXX XX| $FFB3
    .byte $3B ; |  XXX XX| $FFB4
    .byte $3C ; |  XXXX  | $FFB5
    .byte $3D ; |  XXXX X| $FFB6
    .byte $3D ; |  XXXX X| $FFB7
    .byte $3E ; |  XXXXX | $FFB8
    .byte $3F ; |  XXXXXX| $FFB9
    .byte $3F ; |  XXXXXX| $FFBA
    .byte $40 ; | X      | $FFBB
    .byte $41 ; | X     X| $FFBC
    .byte $41 ; | X     X| $FFBD
    .byte $42 ; | X    X | $FFBE
    .byte $42 ; | X    X | $FFBF
    .byte $43 ; | X    XX| $FFC0
    .byte $44 ; | X   X  | $FFC1
    .byte $45 ; | X   X X| $FFC2
    .byte $45 ; | X   X X| $FFC3
    .byte $46 ; | X   XX | $FFC4
    .byte $47 ; | X   XXX| $FFC5
    .byte $47 ; | X   XXX| $FFC6
    .byte $48 ; | X  X   | $FFC7
    .byte $49 ; | X  X  X| $FFC8
    .byte $49 ; | X  X  X| $FFC9
    .byte $4A ; | X  X X | $FFCA
    .byte $4B ; | X  X XX| $FFCB
    .byte $4B ; | X  X XX| $FFCC
    .byte $4C ; | X  XX  | $FFCD
    .byte $4D ; | X  XX X| $FFCE
    .byte $4D ; | X  XX X| $FFCF
    .byte $4E ; | X  XXX | $FFD0
    .byte $4F ; | X  XXXX| $FFD1
    .byte $4F ; | X  XXXX| $FFD2
    .byte $50 ; | X X    | $FFD3
    .byte $51 ; | X X   X| $FFD4
    .byte $51 ; | X X   X| $FFD5
    .byte $52 ; | X X  X | $FFD6
    .byte $52 ; | X X  X | $FFD7
    .byte $53 ; | X X  XX| $FFD8
    .byte $54 ; | X X X  | $FFD9
    .byte $55 ; | X X X X| $FFDA
    .byte $55 ; | X X X X| $FFDB
    .byte $56 ; | X X XX | $FFDC
    .byte $57 ; | X X XXX| $FFDD
    .byte $57 ; | X X XXX| $FFDE
    .byte $58 ; | X XX   | $FFDF
    .byte $59 ; | X XX  X| $FFE0
    .byte $59 ; | X XX  X| $FFE1
    .byte $5A ; | X XX X | $FFE2
    .byte $5B ; | X XX XX| $FFE3
    .byte $5B ; | X XX XX| $FFE4
    .byte $5C ; | X XXX  | $FFE5
    .byte $5D ; | X XXX X| $FFE6
    .byte $5D ; | X XXX X| $FFE7
    .byte $5E ; | X XXXX | $FFE8
    .byte $5F ; | X XXXXX| $FFE9
    .byte $5D ; | X XXX X| $FFEA
    .byte $60 ; | XX     | $FFEB

LFFEC:
    sta    BANK_0                ; 4
    jmp    LF540                 ; 3

LFFF2:
    sta    BANK_0                ; 4
    jmp    LF316                 ; 3

  IF ALTERNATE
    .byte $CB ; |XX  X XX| $FFF8
  ELSE
    .byte $BA ; |X XXX X | $FFF8
  ENDIF

    .byte $C9 ; |XX  X  X| $FFF9

    .byte $3E ; |  XXXXX | $FFFA
    .byte $23 ; |  X   XX| $FFFB

       ORG $2FFC
      RORG $FFFC

    .word START_BANK1
    .byte $71 ; | XXX   X| $FFFE
    .byte $00 ; |        | $FFFF
