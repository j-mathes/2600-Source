; Rough disassembly of Tapper
; by Omegamatrix
; Using DiStella v3.0
;
;  Includes PAL-60 conversion
;
; tap1.cfg contents:
;
;      ORG D000
;      CODE D000 D8FE
;      GFX D8FF D8FF
;      CODE D900 D9F6
;      GFX D9F7 DBC5
;      CODE DBC6 DBDC
;      GFX DBDD DFFF
;
; tap2.cfg contents:
;
;      ORG F000
;      CODE F000 F7EB
;      GFX F7EC F7FC
;      CODE F7FD FC63
;      GFX FC64 FFFF

      processor 6502

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
HMM1    =  $23
HMBL    =  $24
VDELP0  =  $25
VDELP1  =  $26
HMOVE   =  $2A
HMCLR   =  $2B
INPT4   =  $3C
INPT5   =  $3D
SWCHA   =  $0280
SWCHB   =  $0282
TIMINT  =  $0285
TIM64T  =  $0296



NTSC          = 1
SCANLINE_FIX  = 0



  IF NTSC
BLACK         = $00
GREY          = $02
WHITE         = $0E
DIRTY_YELLOW  = $10
YELLOW        = $1A
ORANGE        = $20
ORANGE_RED    = $30
RED           = $40
PURPLE_RED    = $50
PURPLE        = $60
PURPLE_BLUE   = $70
BLUE          = $80
BLUE_CYAN     = $90
CYAN          = $A0
GREEN_CYAN    = $B0
GREEN         = $C0
YELLOW_GREEN  = $D0
ORANGE_GREEN  = $E0
BROWN         = $F0

  ELSE PAL

BLACK         = $00
GREY          = $02
WHITE         = $0E
DIRTY_YELLOW  = $10+$20
YELLOW        = $1A+$10
ORANGE        = $20
ORANGE_RED    = $30+$10
RED           = $40+$20
PURPLE_RED    = $50+$30
PURPLE        = $60+$40
PURPLE_BLUE   = $70+$50
BLUE          = $80+$50
BLUE_CYAN     = $90+$20
CYAN          = $A0-$10
GREEN_CYAN    = $B0-$40
GREEN         = $C0-$70
YELLOW_GREEN  = $D0-$A0
ORANGE_GREEN  = $E0-$B0
BROWN         = $F0-$D0

  ENDIF

;NTSC $0x = PAL $0x   no change
;NTSC $1x = PAL $2x <-- ($10to$18  PAL $30to$38)  ($1Ato$1F  PAL $2Ato$2F)
;NTSC $2x = PAL $2x   no change
;NTSC $3x = PAL $4x   +$10
;NTSC $4x = PAL $6x   +$20
;NTSC $5x = PAL $8x   +$30
;NTSC $6x = PAL $Ax   +$40
;NTSC $7x = PAL $Cx   +$50
;NTSC $8x = PAL $Dx   +$50
;NTSC $9x = PAL $Bx   +$20
;NTSC $Ax = PAL $9x   -$10
;NTSC $Bx = PAL $7x   -$40
;NTSC $Cx = PAL $5x   -$70
;NTSC $Dx = PAL $3x   -$A0
;NTSC $Ex = PAL $3x <--  -$B0
;NTSC $Fx = PAL $2x <--  -$D0
;
;BLACK         = $00
;GREY          = $02
;WHITE         = $0E
;DIRTY_YELLOW  = $10
;YELLOW        = $1A
;ORANGE        = $20
;ORANGE_RED    = $30
;RED           = $40
;PURPLE_RED    = $50
;PURPLE        = $60
;PURPLE_BLUE   = $70
;BLUE          = $80
;BLUE_CYAN     = $90
;CYAN          = $A0
;GREEN_CYAN    = $B0
;GREEN         = $C0
;YELLOW_GREEN  = $D0
;ORANGE_GREEN  = $E0
;BROWN         = $F0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      FIRST BANK
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       ORG $0000
      RORG $D000

LD000:
    lda    #$DA                  ; 2  high nibble LDAB4, LDAA8
    sta    $EB                   ; 3
    sta    $ED                   ; 3
    ldx    #$30                  ; 2
LD008:
    txs                          ; 2
    lda    $96,X                 ; 4
    sta    COLUP0                ; 3
    ldy    $D0                   ; 3
    lda    $92,X                 ; 4
    cmp    #$59                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    bcc    LD041                 ; 2�
    sbc    #$10                  ; 2
    cmp    #$59                  ; 2
    bcc    LD034                 ; 2�
    sbc    #$10                  ; 2
    cmp    #$59                  ; 2
    bcc    LD02B                 ; 2�
    lda    #$58                  ; 2
    sta    $E3                   ; 3
    tya                          ; 2
    jmp    LD02F                 ; 3

LD02B:
    sta    $E3                   ; 3
    lda    $93,X                 ; 4
LD02F:
    sty    $E1                   ; 3
    jmp    LD03C                 ; 3

LD034:
    sta    $E3                   ; 3
    lda    $93,X                 ; 4
    sta    $E1                   ; 3
    lda    $94,X                 ; 4
LD03C:
    sty    $E0                   ; 3
    jmp    LD04D                 ; 3

LD041:
    sta    $E3                   ; 3
    lda    $93,X                 ; 4
    sta    $E0                   ; 3
    lda    $94,X                 ; 4
    sta    $E1                   ; 3
    lda    $95,X                 ; 4
LD04D:
    sta    $E2                   ; 3
    lda    $91,X                 ; 4
    bpl    LD055                 ; 2�
    eor    #$FF                  ; 2
LD055:
    tay                          ; 2
    lsr                          ; 2
    lda    $9C,X                 ; 4
    bpl    LD05D                 ; 2�
    eor    #$FF                  ; 2
LD05D:
    bcs    LD065                 ; 2�
    sta    $E4                   ; 3
    sty    $FB                   ; 3
    bcc    LD06F                 ; 3   always branch

LD065:
    sty    $E4                   ; 3
    lsr                          ; 2
    bcc    LD06C                 ; 2�
    inc    $9C,X                 ; 6
LD06C:
    asl                          ; 2
    sta    $FB                   ; 3
LD06F:
    beq    LD073                 ; 2�
    lda    #6                    ; 2
LD073:
    sta    $E5                   ; 3
    lda    #0                    ; 2
    sta    $9E                   ; 3
    ldy    $CE                   ; 3
    sty    $E8                   ; 3
    cpx    $D6                   ; 3
    beq    LD08F                 ; 2�
    ldy    #$A8                  ; 2
    cpx    $AF                   ; 3
    bne    LD09E                 ; 2�
    ldy    $D4                   ; 3
    lda    $D5                   ; 3
    beq    LD09C                 ; 2�
    bne    LD09E                 ; 3   always branch

LD08F:
    cpy    #$78                  ; 2
    bne    LD097                 ; 2�
    lda    #$52                  ; 2
    sta    $9E                   ; 3
LD097:
    lda    $CD                   ; 3
    bne    LD09E                 ; 2�
    sec                          ; 2
LD09C:
    ror    $E5                   ; 5
LD09E:
    sty    $EC                   ; 3
    tya                          ; 2
    clc                          ; 2
    adc    #$0C                  ; 2
    sta    $EA                   ; 3
    lda    #$20                  ; 2
    sta    ENAM0                 ; 3
    sta    ENABL                 ; 3
    sta    CTRLPF                ; 3
    clc                          ; 2
    tsx                          ; 2
    lda    $D1                   ; 3
    bmi    LD0BA                 ; 2�
    sec                          ; 2
    and    LDF50,X               ; 4
    bne    LD0E9                 ; 2�
LD0BA:
    ldy    $FB                   ; 3
    ldx    LDF08,Y               ; 4
    tya                          ; 2
    beq    LD0C9                 ; 2�
    lda    LDF09,Y               ; 4
    ora    $DA,X                 ; 4
    sta    $DA,X                 ; 4
LD0C9:
    bcs    LD0DD                 ; 2�
    bit    $D1                   ; 3
    bvc    LD0D6                 ; 2�
    lda    LDFCC,X               ; 4   indirect Lo
    ldy    #$D9                  ; 2   indirect Hi
    bvs    LD0E2                 ; 3   always branch

LD0D6:
    lda    LDFC7,X               ; 4   indirect Lo
    ldy    #$D6                  ; 2   indirect Hi
    bcc    LD0E2                 ; 3   always branch

LD0DD:
    lda    LDFBC,X               ; 4   indirect Lo
    ldy    #$D8                  ; 2   indirect Hi
LD0E2:
    sta    $FE                   ; 3
    sty    $FF                   ; 3
    jmp    LD729                 ; 3

LD0E9:
    lda    #4                    ; 2
    sta    REFP1                 ; 3
    asl                          ; 2
    sta    REFP0                 ; 3
    lda    $99,X                 ; 4
    sta    $E7                   ; 3
    lda    $FB                   ; 3
    tax                          ; 2
    beq    LD109                 ; 2�+1
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #$49                  ; 2
    tay                          ; 2
    ldx    LDF00,Y               ; 4
    lda    LDF01,Y               ; 4
    ora    $DA,X                 ; 4
    sta    $DA,X                 ; 4
LD109:
    lda    LDFC1,X               ; 4   indirect Lo
    sta    $FE                   ; 3
    lda    #$D2                  ; 2   indirect Hi
    sta    $FF                   ; 3
    ldx    #ORANGE+4             ; 2   color
    stx    COLUPF                ; 3   done
    stx    WSYNC                 ; 3
;---------------------------------------
    sec                          ; 2
    lda    #$47                  ; 2
    sbc    $E4                   ; 3
    asl                          ; 2
LD11E:
    sbc    #$0F                  ; 2
    bcs    LD11E                 ; 2�
    tax                          ; 2
    ldy    LDA00,X               ; 4
    lda    #$8F                  ; 2
    sta    RESBL                 ; 3
    sty    HMBL                  ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    tsx                          ; 2
    sbc    $97,X                 ; 4
LD131:
    sbc    #$0F                  ; 2
    bcs    LD131                 ; 2�
    tay                          ; 2
    lda    LDA00,Y               ; 4
    ldy    $98,X                 ; 4
    sta    RESP0                 ; 3
    sta    HMP0                  ; 3
    lda    #$59                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    sty    $E6                   ; 3
    sbc    $E3                   ; 3
    tay                          ; 2
LD148:
    sbc    #$0F                  ; 2
    bcs    LD148                 ; 2�
    tax                          ; 2
    lda    LDA00,X               ; 4
    sta    HMP1                  ; 3
    sta    RESP1                 ; 3
    tya                          ; 2
    ldy    #$0C                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
LD15B:
    sbc    #$0F                  ; 2
    bcs    LD15B                 ; 2�
    tax                          ; 2
    lda    LDB00,X               ; 4
    asl                          ; 2
    bcs    LD166                 ; 2�  add a cycle?
LD166:
    beq    LD19D                 ; 2�
    bmi    LD19D                 ; 2�
    bpl    LD19D                 ; 3   always branch

LD16C:
    sta    COLUP1                ; 3
    tsx                          ; 2
    txa                          ; 2
    and    #$10                  ; 2
    adc    #$75                  ; 2
    cpx    #$15                  ; 2
    lda    ($9E),Y               ; 5
    txa                          ; 2
    eor    $BF                   ; 3
    bne    LD186                 ; 2�
    lda    LDE3A,Y               ; 4
    sta    COLUP0                ; 3
    lda    #$DA                  ; 2
    bne    LD18D                 ; 3   always branch

LD186:
    lda    $9A,X                 ; 4
    sta.w  $E8                   ; 4
    lda    $E7                   ; 3
LD18D:
    sta    $E9                   ; 3
    lda    ($E8),Y               ; 5
    sta    GRP0                  ; 3
    lda    ($E6),Y               ; 5
    sta    GRP1                  ; 3
    ldx    $E1                   ; 3
    lda    $E2                   ; 3
    sta    COLUP1                ; 3
LD19D:
    lda    $E0                   ; 3
    dey                          ; 2
    stx    COLUP1                ; 3
    bpl    LD16C                 ; 2�
    sta    COLUP1                ; 3
    ldx    #ORANGE+4             ; 2   color
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    COLUP1                ; 3   done
    stx    COLUBK                ; 3   done
    lda    #0                    ; 2
    sta    GRP0                  ; 3
    sty    GRP1                  ; 3
    nop                          ; 2
    nop                          ; 2
    ldy    #$0B                  ; 2
    lda    $D7                   ; 3
    sta    REFP0                 ; 3
    nop                          ; 2
    lda    #1                    ; 2
    sta    NUSIZ1                ; 3
    ldx    #GREY+4               ; 2   color
    bvs    LD1C9                 ; 2�
    bvc    LD1C9                 ; 3   always branch

LD1C7:
    bcc    LD1CB                 ; 3   always branch

LD1C9:
    bcc    LD1C7                 ; 2�
LD1CB:
    nop                          ; 2
    nop                          ; 2
    lda    $E5                   ; 3
    sta    ENABL                 ; 3
    stx    RESP1                 ; 3
    sec                          ; 2
    bpl    LD1DC                 ; 2�
    stx    COLUBK                ; 3   done
    stx    RESP0                 ; 3
    bmi    LD1E0                 ; 3   always branch

LD1DC:
    stx    COLUBK                ; 3   done
    lda    ($EA),Y               ; 5
LD1E0:
    lda    LDE3A,Y               ; 4
    sta    COLUP0                ; 3
    lda    #ORANGE+4             ; 2   color
    sta    COLUBK                ; 3   done
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    ldx    #7                    ; 2
LD1EF:
    dex                          ; 2
    bne    LD1EF                 ; 2�
    nop                          ; 2
    clc                          ; 2
    ldx    #GREY+4               ; 2   color
    lda    ($9E),Y               ; 5
    stx    RESP1                 ; 3
    stx    COLUBK                ; 3   done
    sta    GRP1                  ; 3
    dey                          ; 2
    jmp.ind ($00FE)              ; 5

    nop                          ; 2   unused code?
    nop                          ; 2
LD204:
    lda    #ORANGE+4             ; 2   color
    sta    COLUP1                ; 3   done
    sta    COLUBK                ; 3   done
    lda    $DA                   ; 3
    sta    PF1                   ; 3
    lda    LDE3A-1,Y             ; 4
    sta    COLUP0                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    ldx    LDCA8-1,Y             ; 4
    lda    $DC                   ; 3
    sta    PF1                   ; 3
    stx    COLUPF                ; 3
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    lda    LDC30,Y               ; 4
    sta    GRP1                  ; 3
    lda    ($9E),Y               ; 5
    ldx    #GREY+4               ; 2   color
    stx    COLUBK                ; 3   done
    sta    GRP1                  ; 3
    sta    COLUP1                ; 3
    dey                          ; 2
    bne    LD204                 ; 2�
    ldy    #$0C                  ; 2
    bne    LD2AA                 ; 3   always branch

LD239:
    lda    #ORANGE+4             ; 2   color
    sta    COLUP1                ; 3   done
    sta    COLUBK                ; 3   done
    lda    $DB                   ; 3
    sta    PF2                   ; 3
    lda    LDE3A-1,Y             ; 4
    sta    COLUP0                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    lda    LDCA8-1,Y             ; 4
    sta    COLUPF                ; 3
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    lda    LDC30,Y               ; 4
    sta    GRP1                  ; 3
    lda    $DD                   ; 3
    sta    PF2                   ; 3
    lda    ($9E),Y               ; 5
    ldx    #GREY+4               ; 2   color
    stx    COLUBK                ; 3   done
    sta    GRP1                  ; 3
    sta    COLUP1                ; 3
    dey                          ; 2
    bne    LD239                 ; 2�
    ldy    #$0C                  ; 2
    bne    LD2AA                 ; 3   always branch

LD26E:
    lda    #ORANGE+4             ; 2   color
    sta    COLUP1                ; 3   done
    sta    COLUBK                ; 3   done
    lda    $DF                   ; 3
    sta    PF0                   ; 3
    lda    LDE3A-1,Y             ; 4
    sta    COLUP0                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    lda    $DE                   ; 3
    sta    PF0                   ; 3
    lda    LDCA8-1,Y             ; 4
    sta    COLUPF                ; 3
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    lda    LDC30,Y               ; 4
    sta    GRP1                  ; 3
    lda    ($9E),Y               ; 5
    ldx    #GREY+4               ; 2   color
    stx    COLUBK                ; 3   done
    sta    GRP1                  ; 3
    sta    COLUP1                ; 3
    dey                          ; 2
    bne    LD26E                 ; 2�
    ldy    #$0C                  ; 2
    bne    LD2AA                 ; 3   always branch

LD2A3:
    lda    LDDE4,Y               ; 4
    sta    COLUP0                ; 3
    stx    ENABL                 ; 3
LD2AA:
    lda    LDC6C-1,Y             ; 4
    sta    COLUBK                ; 3
    lda    LDD30-1,Y             ; 4
    sta    COLUPF                ; 3
    lda    ($EC),Y               ; 5
    sta    GRP0                  ; 3
    lda    #$AA                  ; 2
    sta    PF1                   ; 3
    lda    #$55                  ; 2
    sta    ENABL                 ; 3
    sta    PF2                   ; 3
    sta    PF0                   ; 3
    ldx    #0                    ; 2
    stx    GRP1                  ; 3
    stx    $D9,Y                 ; 4
    tsx                          ; 2
    lda    LDF51,X               ; 4
    sta    PF2                   ; 3
    lda    #GREY+4               ; 2   color
    dey                          ; 2
    sta    COLUBK                ; 3   done
    bne    LD2A3                 ; 2�
    jmp    LD6F6                 ; 3

LD2DA:
    lda    #ORANGE_RED+4         ; 2   color
    sta    COLUPF                ; 3   done
LD2DE:
    stx    WSYNC                 ; 3
;---------------------------------------
    dex                          ; 2
    bne    LD2DE                 ; 2�
    ldx    #$18                  ; 2
LD2E5:
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    #0                    ; 2
    sta.w  PF0                   ; 4
    lda    MountainDewOne,X      ; 4
    sta    GRP0                  ; 3
    lda    MountainDewTwo,X      ; 4
    sta    GRP1                  ; 3
    lda    MountainDewThree,X    ; 4
    sta    GRP0                  ; 3
    lda    LDECE,X               ; 4
    sta    PF0                   ; 3
    lda    MountainDewFour,X     ; 4
    ldy    #YELLOW_GREEN+6       ; 2   color
    sty    COLUBK                ; 3   done
    stx    RESP1                 ; 3
    sta    GRP1                  ; 3
    sta    GRP0                  ; 3
    ldy    #PURPLE_RED+2         ; 2   color
    sty    COLUBK                ; 3   done
    dex                          ; 2
    bpl    LD2E5                 ; 2�+1
    lda    #$30                  ; 2
    sta    NUSIZ1                ; 3
    sta    NUSIZ0                ; 3
    sta    CTRLPF                ; 3
    sta    VDELP0                ; 3
    sta    VDELP1                ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    $92                   ; 3
    ldy    #$1F                  ; 2
    sec                          ; 2
LD327:
    sbc    #$0F                  ; 2
    bcs    LD327                 ; 2�
    tax                          ; 2
    lda    LDA00,X               ; 4
    sta    HMP1                  ; 3
    adc    #$10                  ; 2
    sta    HMP0                  ; 3
    sta    RESP1                 ; 3
    sta    RESP0                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    sty    REFP0                 ; 3
    lda    $92                   ; 3
    nop                          ; 2
    clc                          ; 2
    adc    #6                    ; 2
LD343:
    sbc    #$0F                  ; 2
    bcs    LD343                 ; 2�
    tax                          ; 2
    lda    LDA00,X               ; 4
    sta    HMBL                  ; 3
    sta    RESBL                 ; 3
    lda    #0                    ; 2
    bit    $90                   ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    beq    LD361                 ; 2�
LD359:
    tax                          ; 2
    lda    ($B2),Y               ; 5
    stx    HMCLR                 ; 3
    sta    COLUPF                ; 3
    txa                          ; 2
LD361:
    bvs    LD366                 ; 2�
    nop                          ; 2
    bvc    LD369                 ; 3   always branch

LD366:
    eor    LDE0C,Y               ; 4
LD369:
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    lda    ($B4),Y               ; 5
    sta    COLUP1                ; 3
    sta    COLUP0                ; 3
    ldx    #PURPLE_BLUE+2        ; 2   color
    stx    COLUBK                ; 3
    dec    $9C                   ; 5
    bvs    LD38B                 ; 2�
    nop                          ; 2
    bpl    LD384                 ; 2�
    lda    ($B0),Y               ; 5
    stx    ENABL                 ; 3
    bvc    LD394                 ; 3   always branch

LD384:
    nop                          ; 2
LD385:
    lda    #0                    ; 2
    stx    $FB                   ; 3
    beq    LD394                 ; 3   always branch

LD38B:
    stx    ENABL                 ; 3
    bmi    LD385                 ; 2�
    lda    ($A4),Y               ; 5
    and    LDBA6,Y               ; 4
LD394:
    ldx    #PURPLE_RED+2         ; 2   color
    dey                          ; 2
    stx    COLUBK                ; 3   done
    bpl    LD359                 ; 2�
    ldy    #8                    ; 2
    lda    #ORANGE+8             ; 2   color
    sty    ENABL                 ; 3
    sta    COLUBK                ; 3   done
    lda    #YELLOW_GREEN+6       ; 2   color
    sta    COLUPF                ; 3   done
    bvs    LD3E2                 ; 2�
    ldx    #0                    ; 2
    stx    GRP0                  ; 3
    lda    $9A                   ; 3
    bpl    LD3E2                 ; 2�
    lda    $9B                   ; 3
    adc    #2                    ; 2
LD3B5:
    sbc    #$0F                  ; 2
    bcs    LD3B5                 ; 2�
    tay                          ; 2
    lda    LDA00,Y               ; 4
    sta    RESBL                 ; 3
    sta    HMBL                  ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    $9B                   ; 3
    sec                          ; 2
LD3C6:
    sbc    #$0F                  ; 2
    bcs    LD3C6                 ; 2�
    tay                          ; 2
    lda    LDA00,Y               ; 4
    sta    HMP0                  ; 3
    lda    $9A                   ; 3
    sec                          ; 2
    ldy    #6                    ; 2
    lda    #PURPLE+10            ; 2   color
    sta    COLUP0                ; 3   done
    nop                          ; 2
    sta    RESP0                 ; 3
    bit    $90                   ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
LD3E2:
    lda    ($A0),Y               ; 5
    sta    GRP1                  ; 3
    lda    ($A2),Y               ; 5
    sta    COLUP1                ; 3
    bvs    LD3F9                 ; 2�
    bcc    LD403                 ; 2�+1
    lda    LDE2C,Y               ; 4
    sta    GRP0                  ; 3
    bpl    LD403                 ; 2�+1
    sta    ENABL                 ; 3
    bcs    LD403                 ; 3+1   always branch

LD3F9:
    lda    LDB70,Y               ; 4
    sta    GRP0                  ; 3
    lda    LDB82,Y               ; 4
    sta    COLUP0                ; 3
LD403:
    dey                          ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMCLR                 ; 3
    bpl    LD3E2                 ; 2�+1
    nop                          ; 2
    ldy    $9A                   ; 3
    ldx    $97                   ; 3
    inx                          ; 2
    txa                          ; 2
    sec                          ; 2
LD412:
    sbc    #$0F                  ; 2
    bcs    LD412                 ; 2�
    tax                          ; 2
    lda    LDA00,X               ; 4
    sta    HMM1                  ; 3
    sta    RESM1                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    sty    NUSIZ0                ; 3
    nop                          ; 2
    lda    #0                    ; 2
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    ldx    #$F0                  ; 2
    ldy    #$10                  ; 2
    lda    $98                   ; 3
    sta    NUSIZ1                ; 3
    asl                          ; 2
    bmi    LD44E                 ; 2�
    bcc    LD43A                 ; 2�
    stx    HMP1                  ; 3
    sty    HMP0                  ; 3
LD43A:
    stx    RESP1                 ; 3
    bcs    LD442                 ; 2�
    sty    HMP0                  ; 3
    sty    HMP0                  ; 3
LD442:
    stx    RESP0                 ; 3
    cmp    #$68                  ; 2
    bcs    LD45D                 ; 2�
    stx    HMP0                  ; 3
    stx    RESP0                 ; 3
    bcc    LD45D                 ; 3   always branch

LD44E:
    lda    #$10                  ; 2
    stx    RESP0                 ; 3
    bcc    LD458                 ; 2�
    nop                          ; 2
    nop                          ; 2
    lda    #0                    ; 2
LD458:
    sta    HMP1                  ; 3
    nop                          ; 2
    stx    RESP1                 ; 3
LD45D:
    lda    #PURPLE+10            ; 2   color
    sta    COLUP0                ; 3   done
    sta    COLUP1                ; 3   done
    lda    #0                    ; 2
    ldy    #6                    ; 2
    bit    $9A                   ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
LD46D:
    lda    LDE2C,Y               ; 4
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    dey                          ; 2
    cpy    #4                    ; 2
LD477:
    stx    WSYNC                 ; 3
;---------------------------------------
    sta    HMCLR                 ; 3
    bcs    LD46D                 ; 2�
    lda    $D8                   ; 3
    sta    PF1                   ; 3
    lda    LDE2C,Y               ; 4
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    nop                          ; 2
    stx    $FB                   ; 3
    lda    $D9                   ; 3
    sta    PF2                   ; 3
    lda    $DA                   ; 3
    sta    PF0                   ; 3
    lda    $DB                   ; 3
    sta    PF1                   ; 3
    lda    #0                    ; 2
    sta    PF2                   ; 3
    sta    PF0                   ; 3
    dey                          ; 2
    bpl    LD477                 ; 2�
    bvs    LD4A8                 ; 2�
    lda    $98                   ; 3
    sta    NUSIZ0                ; 3
    bvc    LD4AE                 ; 3   always branch

LD4A8:
    lda    #YELLOW_GREEN+6       ; 2   color
    sta    COLUP0                ; 3   done
    stx    $FB                   ; 3
LD4AE:
    lda    $D8                   ; 3
    sta    PF1                   ; 3
    lda    $D9                   ; 3
    sta    PF2                   ; 3
    lda    $97                   ; 3
    ldy    $DA                   ; 3
    nop                          ; 2
    sec                          ; 2
LD4BC:
    sbc    #$0F                  ; 2
    bcs    LD4BC                 ; 2�
    tax                          ; 2
    lda    LDA00,X               ; 4
    ldx    $DB                   ; 3
    sty    PF0                   ; 3
    sta    HMP0                  ; 3
    sta    RESP0                 ; 3
    stx    PF1                   ; 3
    ldx    #0                    ; 2
    lda    $D8                   ; 3
    ldy    #6                    ; 2
    stx    PF2                   ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    bne    LD4E2                 ; 3   always branch

LD4DC:
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMCLR                 ; 3
    lda    $D8                   ; 3
LD4E2:
    sta    PF0                   ; 3
    sta    PF1                   ; 3
    lda    LDE2C,Y               ; 4
    sta    GRP0                  ; 3
    lda    #YELLOW_GREEN+6       ; 2   color
    sta    COLUP1                ; 3   done
    lda    $D9                   ; 3
    sta    PF2                   ; 3
    lda    $DA                   ; 3
    sta    PF0                   ; 3
    lda    $DB                   ; 3
    sta    PF1                   ; 3
    bit    $9A                   ; 3
    cpy    #4                    ; 2
    stx    PF2                   ; 3
    bne    LD50D                 ; 2�
    bvc    LD509                 ; 2�
    sty    ENABL                 ; 3
    bvs    LD50D                 ; 3   always branch

LD509:
    lda    #2                    ; 2
    sta    ENAM1                 ; 3
LD50D:
    dey                          ; 2
    bpl    LD4DC                 ; 2�+1
    ldy    #$10                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    $D8                   ; 3
    sta    PF0                   ; 3
    sta    PF1                   ; 3
    lda    $D9                   ; 3
    sta    PF2                   ; 3
    ldx    $DA                   ; 3
    lda    $C0                   ; 3
    asl                          ; 2
    stx.w  PF0                   ; 4
    bmi    LD539                 ; 2�
    sty    HMP0                  ; 3
    lda    $DB                   ; 3
    sta    PF1                   ; 3
    bcs    LD539                 ; 2�
    lda    #$F0                  ; 2
    sta.w  HMP0                  ; 4
    lda    #0                    ; 2
    sta    PF2                   ; 3
LD539:
    stx    RESP0                 ; 3
    lda    $DB                   ; 3
    sta    PF1                   ; 3
    nop                          ; 2
    ldx    #0                    ; 2
    ldy    #4                    ; 2
    stx    PF2                   ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    bne    LD54E                 ; 3   always branch

LD54C:
    stx    WSYNC                 ; 3
;---------------------------------------
LD54E:
    stx    PF0                   ; 3
    stx    PF1                   ; 3
    lda    $9A                   ; 3
    sta    NUSIZ0                ; 3
    lda    #YELLOW_GREEN+6       ; 2   color
    sta    COLUP0                ; 3   done
    lda    LDE2C,Y               ; 4
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    dey                          ; 2
    bpl    LD54C                 ; 2�
    sec                          ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMCLR                 ; 3
    lda    $97                   ; 3
    jsr    LDBC9                 ; 6
LD56E:
    sbc    #$0F                  ; 2
    bcs    LD56E                 ; 2�
    tax                          ; 2
    lda    LDA00,X               ; 4
    sta.w  HMP0                  ; 4
    sta    RESP0                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    ldy    #4                    ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
LD583:
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    $9A                   ; 3
    cmp    #1                    ; 2
    bne    LD598                 ; 2�
    lda    #0                    ; 2
    sta    ENAM1                 ; 3
    lda    $98                   ; 3
    sta    NUSIZ0                ; 3
    lda    LDE2C,Y               ; 4
    sta    GRP0                  ; 3
LD598:
    dey                          ; 2
    bpl    LD583                 ; 2�
    stx    WSYNC                 ; 3
    stx    WSYNC                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    #ORANGE+6             ; 2   color
    sta    COLUBK                ; 3   done
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    #6                    ; 2
    sta    NUSIZ0                ; 3
    sta    NUSIZ1                ; 3
    jsr    LDBC9                 ; 6
    stx    RESP0                 ; 3
    jsr    LDBC9                 ; 6
    jsr    LDBC9                 ; 6
    lda    #$E0                  ; 2
    sta    HMP0                  ; 3
    stx    RESP1                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    sta    HMP1                  ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    lda    #ORANGE               ; 2   color
    sta    COLUBK                ; 3   done
    stx    WSYNC                 ; 3
;---------------------------------------
    ldy    #$0C                  ; 2
LD5CE:
    stx    WSYNC                 ; 3
;---------------------------------------
    ldx    LDF8B,Y               ; 4
    stx    COLUPF                ; 3
    stx    COLUP0                ; 3
    stx    COLUP1                ; 3
    inx                          ; 2
    stx    COLUBK                ; 3
    lda    #$33                  ; 2
    sta    PF0                   ; 3
    sta    PF2                   ; 3
    lda    #$CC                  ; 2
    sta    PF1                   ; 3
    lda    LDF83,Y               ; 4
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    dey                          ; 2
    bpl    LD5CE                 ; 2�
    ldy    #$27                  ; 2
LD5F2:
    stx    WSYNC                 ; 3
;---------------------------------------
    dey                          ; 2
    bpl    LD5F2                 ; 2�
    lda    #0                    ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    sta    COLUBK                ; 3
    ldx    #$8B                  ; 2
    ldy    #$F0                  ; 2
    jmp    LD71E                 ; 3

LD604:
    lda    #YELLOW_GREEN+6       ; 2   color
LD606:   ;indirect jump
    ldx    $DA                   ; 3
    stx    PF1                   ; 3
    ldx    LDE3A,Y               ; 4
    sta    COLUBK                ; 3   done
    stx.w  COLUP0                ; 4
    lda    ($9E),Y               ; 5
    sta    GRP1                  ; 3
    lda    LDCE4,Y               ; 4
    ldx    LDF54,Y               ; 4
    stx    COLUP1                ; 3
    sta    GRP1                  ; 3
    stx    COLUBK                ; 3
    lda    $DC                   ; 3
    sta    PF1                   ; 3
    lda    LDE6A,Y               ; 4
    sta    COLUPF                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    lda    #ORANGE+6             ; 2   color
    sta.w  COLUP1                ; 4   done
    dey                          ; 2
    bpl    LD604                 ; 2�
    nop                          ; 2
    bmi    LD6A5                 ; 3   always branch

LD63A:
    ldx    LDE3A,Y               ; 4
    stx.w  COLUP0                ; 4
    sta    COLUBK                ; 3
    lda    $DB                   ; 3
    sta    PF2                   ; 3
    lda    ($9E),Y               ; 5
    sta    GRP1                  ; 3
    lda    LDCE4,Y               ; 4
    ldx    LDF54,Y               ; 4
    stx    COLUP1                ; 3
    sta    GRP1                  ; 3
    stx    COLUBK                ; 3
    ldx    #ORANGE+6             ; 2   color
    lda    LDE6A,Y               ; 4
    sta    COLUPF                ; 3
    lda    ($EA),Y               ; 5
    sta.w  GRP0                  ; 4
    lda    $DD                   ; 3
    sta    PF2                   ; 3
    lda    #YELLOW_GREEN+6       ; 2   color
    dey                          ; 2
    stx    COLUP1                ; 3   done
    bpl    LD63A                 ; 2�
    bmi    LD6A5                 ; 3   always branch

LD66F:
    sty    PF0                   ; 3
LD671:   ;indirect jump
    nop                          ; 2
    sta    COLUP1                ; 3
    lda    #YELLOW_GREEN+6       ; 2   color
    sta    COLUBK                ; 3   done
    lda    LDE3A,Y               ; 4
    sta    COLUP0                ; 3
    lda    ($9E),Y               ; 5
    sta    GRP1                  ; 3
    lda    LDCE4,Y               ; 4
    ldx    LDF54,Y               ; 4
    stx    COLUP1                ; 3
    sta    GRP1                  ; 3
    stx    COLUBK                ; 3
    lda    $DE                   ; 3
    sta    PF0                   ; 3
    lda    LDE6A,Y               ; 4
    sta    COLUPF                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    lda    $FB                   ; 3
    lda    #$26                  ; 2
    dey                          ; 2
    bpl    LD66F                 ; 2�
    sta    $FB                   ; 3
    bmi    LD6A5                 ; 3   always branch

LD6A5:
    lda    #0                    ; 2
    ldx    #YELLOW_GREEN+6       ; 2   color
    stx    COLUP1                ; 3   done
    sta    ENABL                 ; 3
    sta    PF0                   ; 3
    stx    COLUBK                ; 3   done
    sta    PF1                   ; 3
    sta    PF2                   ; 3
    sty    GRP1                  ; 3
    ldy    #$0B                  ; 2
    stx    RESBL                 ; 3
    ldx    #ORANGE+2             ; 2   color
    stx    COLUP1                ; 3   done
    stx    RESP1                 ; 3
LD6C1:
    stx    COLUBK                ; 3
    lda    ($EC),Y               ; 5
    sta    GRP0                  ; 3
    lda    LDDE4,Y               ; 4
    sta    COLUP0                ; 3
    ldx    #0                    ; 2
    stx    $DA,Y                 ; 4
    lda    #$30                  ; 2
    sta    CTRLPF                ; 3
    lda    #BLUE_CYAN+6          ; 2   color
    sta    COLUPF                ; 3   done
    sta    ENABL                 ; 3
    sta    $FB                   ; 3
    lda    #DIRTY_YELLOW         ; 2   color
    sta    COLUP1                ; 3   done
    ldx    #YELLOW_GREEN+6       ; 2   color
    lda    #6                    ; 2
    sta    NUSIZ1                ; 3
    stx    COLUBK                ; 3   done
    lda    LDD6C,Y               ; 4
    ldx    LDDA8,Y               ; 4
    sta    $FB                   ; 3
    nop                          ; 2
    dey                          ; 2
    sta    GRP1                  ; 3
    bpl    LD6C1                 ; 2�
LD6F6:
    ldx    $D0                   ; 3
    stx    COLUBK                ; 3
    lda    #0                    ; 2
LD6FC:
    sta    GRP1                  ; 3
    sta    GRP0                  ; 3
    sta    PF1                   ; 3
    sta    VDELP0                ; 3
    sta    PF0                   ; 3
    sta    PF2                   ; 3
    lda    #3                    ; 2
    sta    NUSIZ1                ; 3
    tsx                          ; 2
    txa                          ; 2
    sec                          ; 2
    sbc    #$10                  ; 2
    bmi    LD717                 ; 2�
    tax                          ; 2
    jmp    LD008                 ; 3

LD717:
    ldx    #$FF                  ; 2
    txs                          ; 2
    ldx    #<LF09D               ; 2
    ldy    #>LF09D               ; 2
LD71E:
    stx    $FE                   ; 3
    sty    $FF                   ; 3
    lda    #$F9                  ; 2
    sta    $FB                   ; 3
    jmp.w  $FA                   ; 3

LD729:
    lda    #8                    ; 2
    sta    REFP1                 ; 3
    asl                          ; 2
    sta    REFP0                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    $E4                   ; 3
    ldx    #ORANGE+4             ; 2   color
    stx    COLUPF                ; 3   done
    asl                          ; 2
    adc    #3                    ; 2
LD73B:
    sbc    #$0F                  ; 2
    bcs    LD73B                 ; 2�
    tax                          ; 2
    lda    LDA00,X               ; 4
    sta    HMBL                  ; 3
    sta    RESBL                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    $FB                   ; 3
    tsx                          ; 2
    lda    $97,X                 ; 4
LD74E:
    sbc    #$0F                  ; 2
    bcs    LD74E                 ; 2�
    tay                          ; 2
    lda    LDA00,Y               ; 4
    sta    HMP0                  ; 3
    lda    $E3                   ; 3
    sta    RESP0                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    ldy    $98,X                 ; 4
    sty    $E6                   ; 3
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
LD765:
    sbc    #$0F                  ; 2
    bcs    LD765                 ; 2�
    tay                          ; 2
    lda    LDA00,Y               ; 4
    sta    HMP1                  ; 3
    lda    $99,X                 ; 4
    stx.w  RESP1                 ; 4
    sta    $E7                   ; 3
    ldy    #$0C                  ; 2
    lda    $E3                   ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
LD77E:
    sbc    #$0F                  ; 2
    bcs    LD77E                 ; 2�
    tax                          ; 2
    lda    LDB00,X               ; 4
    asl                          ; 2
    bcs    LD789                 ; 2�   add a cycle?
LD789:
    beq    LD7BC                 ; 2�
    bmi    LD7BC                 ; 2�
    bpl    LD7BC                 ; 3   always branch

LD78F:
    sta    COLUP1                ; 3
    lda    #1                    ; 2
    sta    VDELP0                ; 3
    tsx                          ; 2
    txa                          ; 2
    and    #$10                  ; 2
    adc    #$75                  ; 2
    cpx    #$15                  ; 2
    txa                          ; 2
    eor    $BF                   ; 3
    bne    LD7AB                 ; 2�
    lda    LDE3A,Y               ; 4
    sta    COLUP0                ; 3
    lda    #$DA                  ; 2
    bne    LD7B2                 ; 3   always branch

LD7AB:
    lda    $9A,X                 ; 4
    sta.w  $E8                   ; 4
    lda    $E7                   ; 3
LD7B2:
    sta    $E9                   ; 3
    lda    ($E8),Y               ; 5
    sta    GRP0                  ; 3
    lda    ($E6),Y               ; 5
    sta    GRP1                  ; 3
LD7BC:
    ldx    $E1                   ; 3
    lda    $E0                   ; 3
    sta    COLUP1                ; 3
    lda    $E2                   ; 3
    dey                          ; 2
    stx    COLUP1                ; 3
    bpl    LD78F                 ; 2�
    sta    COLUP1                ; 3
    ldx    #$24                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    bvc    LD7D5                 ; 2�
    bvs    LD7D5                 ; 3   always branch

LD7D3:
    bcs    LD7D7                 ; 3   always branch

LD7D5:
    bcs    LD7D3                 ; 2�
LD7D7:
    ldy    #0                    ; 2
    sty    GRP0                  ; 3
    sty    GRP1                  ; 3
    lda    $E5                   ; 3
    bpl    LD7E8                 ; 2�
    nop                          ; 2
    stx    RESP1                 ; 3
    stx    RESP0                 ; 3
    bne    LD7EF                 ; 2�
LD7E8:
    stx.w  RESP1                 ; 4
    stx    COLUP1                ; 3
    sty    GRP1                  ; 3
LD7EF:
    stx    COLUBK                ; 3
    sta    ENABL                 ; 3
    ldy    #$0B                  ; 2
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    dey                          ; 2
    lda    $D7                   ; 3
    sta    REFP0                 ; 3
    lda    #1                    ; 2
    sta    NUSIZ1                ; 3
    lda    $D0                   ; 3
    jmp.ind ($00FE)              ; 5   LD807, LD83B, or LD86E

LD807:
    lda    $DA                   ; 3
    sta    PF1                   ; 3
    lda    #GREY+4               ; 2   color
    sta    COLUBK                ; 3   done
    lda    $FB                   ; 3
    lda    LDE3A,Y               ; 4
    sta    COLUP0                ; 3
    lda    ($9E),Y               ; 5
    sta    GRP1                  ; 3
    lda    LDE5E,Y               ; 4
    stx    COLUP1                ; 3
    sta    GRP1                  ; 3
    stx    COLUBK                ; 3
    lda    $DC                   ; 3
    sta    PF1                   ; 3
    lda    LDCA8,Y               ; 4
    sta    COLUPF                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    stx    $FB                   ; 3
    lda    #CYAN+2               ; 2   color
    sta    COLUP1                ; 3   done
    dey                          ; 2
    bpl    LD807                 ; 2�
    bne    LD8A2                 ; 3   always branch

LD83B:
    sta    COLUP1                ; 3
    lda    LDE3A,Y               ; 4
    sta    COLUP0                ; 3
    lda    #GREY+4               ; 2   color
    sta    COLUBK                ; 3   done
    lda    $DB                   ; 3
    sta    PF2                   ; 3
    lda    ($9E),Y               ; 5
    sta    GRP1                  ; 3
    lda    LDE5E,Y               ; 4
    stx    COLUP1                ; 3
    sta    GRP1                  ; 3
    stx    COLUBK                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    lda    LDCA8,Y               ; 4
    sta    COLUPF                ; 3
    lda    $DD                   ; 3
    sta    PF2                   ; 3
    nop                          ; 2
    nop                          ; 2
    nop                          ; 2
    lda    #$A2                  ; 2
    dey                          ; 2
    bpl    LD83B                 ; 2�
    bne    LD8A2                 ; 3   always branch

LD86E:
    sty    PF0                   ; 3
    sta    COLUP1                ; 3
    lda    #GREY+4               ; 2   color
    sta    COLUBK                ; 3   done
    lda    $FB                   ; 3
    lda    LDE3A,Y               ; 4
    sta    COLUP0                ; 3
    lda    ($9E),Y               ; 5
    sta    GRP1                  ; 3
    lda    LDE5E,Y               ; 4
    stx    COLUP1                ; 3
    sta    GRP1                  ; 3
    stx    COLUBK                ; 3
    lda    $DE                   ; 3
    sta    PF0                   ; 3
    lda    LDCA8,Y               ; 4
    sta    COLUPF                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    lda    $FB                   ; 3
    lda    $FB                   ; 3
    lda    #$A2                  ; 2
    dey                          ; 2
    bpl    LD86E                 ; 2�
    bne    LD8A2                 ; 3   always branch

LD8A2:
    ldy    #$0B                  ; 2
    tsx                          ; 2
    lda    LDF52,X               ; 4
    tax                          ; 2
LD8A9:
    lda    #0                    ; 2
    sta.w  GRP1                  ; 4
    stx    PF1                   ; 3
    lda    #GREY+4               ; 2   color
    sta    COLUBK                ; 3   done
    lda    LDD30,Y               ; 4
    sta    COLUPF                ; 3
    lda    LDC6C,Y               ; 4
    sta    COLUBK                ; 3
    lda    #$55                  ; 2
    sta    ENABL                 ; 3
    sta    PF2                   ; 3
    sta    PF0                   ; 3
    lda    #$AA                  ; 2
    sta    PF1                   ; 3
    lda    ($EC),Y               ; 5
    sta    GRP0                  ; 3
    lda    #0                    ; 2
    sta.wy $DA,Y                 ; 5
    nop                          ; 2
    lda    LDDE4,Y               ; 4
    sty    PF0                   ; 3
    dey                          ; 2
    sta    COLUP0                ; 3
    bpl    LD8A9                 ; 2�
    jmp    LD6F6                 ; 3

LD8E1:   ;indirect jump
    ldy    #$51                  ; 2   color
    sty    HMP0                  ; 3
    sty    NUSIZ0                ; 3
    sty    NUSIZ1                ; 3
  IF NTSC
    iny                          ; 2
  ELSE
    LDY    #PURPLE_RED+2         ; 2    color    PURPLE_RED+2 = $82
  ENDIF
    ldx    #$16                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    sty    COLUBK                ; 3
    lda    #7                    ; 2
    sta    COLUP0                ; 3
    sta    COLUP1                ; 3
    sta    VDELP0                ; 3
    sta    VDELP1                ; 3
    jmp    LD2DA                 ; 3

;    .byte $FF ; |XXXXXXXX| $D8FF

       ORG $0900
      RORG $D900

LD900:
    ldx    $DA                   ; 3
    stx    PF1                   ; 3
    ldx    LDE46,Y               ; 4
    sta    COLUBK                ; 3
    stx.w  COLUP0                ; 4
    lda    ($9E),Y               ; 5
    sta    GRP1                  ; 3
    lda    LDF98,Y               ; 4
    ldx    LDFA4,Y               ; 4
    stx    COLUP1                ; 3
    sta    GRP1                  ; 3
    stx    COLUBK                ; 3
    lda    $DC                   ; 3
    sta    PF1                   ; 3
    lda    LDF64,Y               ; 4
    sta    COLUPF                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    lda    #ORANGE+6             ; 2   color
    sta    COLUP1                ; 3   done
    lda    $D0                   ; 3
    dey                          ; 2
    bpl    LD900                 ; 2�
    bmi    LD99D                 ; 3   always branch

LD934:
    ldx    LDE46,Y               ; 4
    stx.w  COLUP0                ; 4
    ldx    $DB                   ; 3
    sta    COLUBK                ; 3
    stx    PF2                   ; 3
    lda    ($9E),Y               ; 5
    sta    GRP1                  ; 3
    lda    LDF98,Y               ; 4
    ldx    LDFA4,Y               ; 4
    stx    COLUP1                ; 3
    sta    GRP1                  ; 3
    stx    COLUBK                ; 3
    ldx    #ORANGE+6             ; 2   color
    lda    LDF64,Y               ; 4
    sta    COLUPF                ; 3
    lda    ($EA),Y               ; 5
    sta.w  GRP0                  ; 4
    lda    $DD                   ; 3
    sta    PF2                   ; 3
    lda    #0                    ; 2
    dey                          ; 2
    stx    COLUP1                ; 3   done
    bpl    LD934                 ; 2�
    bmi    LD99D                 ; 3   always branch

LD969:
    sty    PF0                   ; 3
    stx    COLUP1                ; 3
    sta    COLUBK                ; 3
    ldx    LDE46,Y               ; 4
    stx.w  COLUP0                ; 4
    lda    ($9E),Y               ; 5
    sta    GRP1                  ; 3
    lda    LDF98,Y               ; 4
    ldx    LDFA4,Y               ; 4
    stx    COLUP1                ; 3
    sta    GRP1                  ; 3
    stx    COLUBK                ; 3
    lda    $DE                   ; 3
    sta    PF0                   ; 3
    lda    LDF64,Y               ; 4
    sta    COLUPF                ; 3
    lda    ($EA),Y               ; 5
    sta    GRP0                  ; 3
    stx    $FB                   ; 3
    lda    $D0                   ; 3
    ldx    #ORANGE+6             ; 2   color
    dey                          ; 2
    bpl    LD969                 ; 2�
    bmi    LD99D                 ; 3   always branch

LD99D:
    stx    $FB                   ; 3
    lda    #0                    ; 2
    ldx    #$E0                  ; 2
    sta    COLUP1                ; 3
    sta    PF0                   ; 3
    sta    COLUBK                ; 3
    sta    PF1                   ; 3
    sta    PF2                   ; 3
    stx    GRP1                  ; 3
    ldy    #$0B                  ; 2
    stx    RESBL                 ; 3
    ldx    #BLUE_CYAN            ; 2   color
    stx    COLUP1                ; 3   done
    stx    RESP1                 ; 3
    stx    COLUBK                ; 3   done
LD9BB:
    lda    ($EC),Y               ; 5
    sta    GRP0                  ; 3
    tya                          ; 2
    asl                          ; 2
    sbc    $8C                   ; 3
    lsr                          ; 2
    sta    ENABL                 ; 3
    lda    LDAE4,Y               ; 4
    sta    COLUP0                ; 3
    lda    #$30                  ; 2
    sta    CTRLPF                ; 3
    lda    #PURPLE+6             ; 2   color
    sta    COLUPF                ; 3   done
    sta    NUSIZ1                ; 3   ..XX .XX.  NUSIZx
                                 ;     .11. .11.  #$66 NTSC
                                 ;     1.1. .11.  #$A6 PAL (same effect for NUSIZx)

    lda    #ORANGE_RED+4         ; 2   color
    sta    COLUP1                ; 3   done
    ldx    #0                    ; 2
    stx    $DA,Y                 ; 4
    stx    COLUBK                ; 3
    lda    $8C                   ; 3
    and    LDF74,Y               ; 4
    ldx    #$B0                  ; 2
    stx    GRP1                  ; 3
    sta    COLUBK                ; 3
    nop                          ; 2
    dey                          ; 2
    bpl    LD9BB                 ; 2�
    lda    #BLACK                ; 2   color
    sta    COLUBK                ; 3   done
    sty    ENABL                 ; 3
    jmp    LD6FC                 ; 3

    .byte $FF ; |XXXXXXXX| $D9F7   free bytes
    .byte $FF ; |XXXXXXXX| $D9F8
    .byte $FF ; |XXXXXXXX| $D9F9
    .byte $FF ; |XXXXXXXX| $D9FA
    .byte $FF ; |XXXXXXXX| $D9FB
    .byte $FF ; |XXXXXXXX| $D9FC
    .byte $FF ; |XXXXXXXX| $D9FD
    .byte $FF ; |XXXXXXXX| $D9FE
    .byte $FF ; |XXXXXXXX| $D9FF

       ORG $0A00
      RORG $DA00

LDA00:
    .byte $00 ; |        | $DA00
    .byte $6E ; | XX XXX | $DA01
    .byte $6C ; | XX XX  | $DA02
    .byte $00 ; |        | $DA03
    .byte $6C ; | XX XX  | $DA04
    .byte $6C ; | XX XX  | $DA05
    .byte $6C ; | XX XX  | $DA06
    .byte $7C ; | XXXXX  | $DA07
    .byte $7C ; | XXXXX  | $DA08
    .byte $78 ; | XXXX   | $DA09
    .byte $38 ; |  XXX   | $DA0A
    .byte $BC ; |X XXXX  | $DA0B
    .byte $BF ; |X XXXXXX| $DA0C
    .byte $FC ; |XXXXXX  | $DA0D
    .byte $FC ; |XXXXXX  | $DA0E
    .byte $7C ; | XXXXX  | $DA0F
    .byte $18 ; |   XX   | $DA10
    .byte $3C ; |  XXXX  | $DA11
    .byte $38 ; |  XXX   | $DA12
    .byte $7E ; | XXXXXX | $DA13
    .byte $5A ; | X XX X | $DA14
    .byte $1E ; |   XXXX | $DA15
    .byte $FE ; |XXXXXXX | $DA16
    .byte $7C ; | XXXXX  | $DA17

    .byte $00 ; |        | $DA18
    .byte $1C ; |   XXX  | $DA19
    .byte $18 ; |   XX   | $DA1A
    .byte $00 ; |        | $DA1B
    .byte $98 ; |X  XX   | $DA1C
    .byte $DC ; |XX XXX  | $DA1D
    .byte $2C ; |  X XX  | $DA1E
    .byte $FC ; |XXXXXX  | $DA1F
    .byte $7C ; | XXXXX  | $DA20
    .byte $38 ; |  XXX   | $DA21
    .byte $78 ; | XXXX   | $DA22
    .byte $F8 ; |XXXXX   | $DA23
    .byte $7F ; | XXXXXXX| $DA24
    .byte $78 ; | XXXX   | $DA25
    .byte $7E ; | XXXXXX | $DA26
    .byte $38 ; |  XXX   | $DA27
    .byte $38 ; |  XXX   | $DA28
    .byte $1C ; |   XXX  | $DA29
    .byte $38 ; |  XXX   | $DA2A
    .byte $7E ; | XXXXXX | $DA2B
    .byte $5A ; | X XX X | $DA2C
    .byte $1C ; |   XXX  | $DA2D
    .byte $7E ; | XXXXXX | $DA2E
    .byte $3C ; |  XXXX  | $DA2F

    .byte $00 ; |        | $DA30
    .byte $38 ; |  XXX   | $DA31
    .byte $70 ; | XXX    | $DA32
    .byte $40 ; | X      | $DA33
    .byte $30 ; |  XX    | $DA34
    .byte $38 ; |  XXX   | $DA35
    .byte $38 ; |  XXX   | $DA36
    .byte $38 ; |  XXX   | $DA37
    .byte $78 ; | XXXX   | $DA38
    .byte $78 ; | XXXX   | $DA39
    .byte $F8 ; |XXXXX   | $DA3A
    .byte $F0 ; |XXXX    | $DA3B
    .byte $7F ; | XXXXXXX| $DA3C
    .byte $78 ; | XXXX   | $DA3D
    .byte $7E ; | XXXXXX | $DA3E
    .byte $78 ; | XXXX   | $DA3F
    .byte $38 ; |  XXX   | $DA40
    .byte $1C ; |   XXX  | $DA41
    .byte $38 ; |  XXX   | $DA42
    .byte $7E ; | XXXXXX | $DA43
    .byte $5A ; | X XX X | $DA44
    .byte $1C ; |   XXX  | $DA45
    .byte $7E ; | XXXXXX | $DA46
    .byte $3C ; |  XXXX  | $DA47

    .byte $00 ; |        | $DA48
    .byte $00 ; |        | $DA49
    .byte $64 ; | XX  X  | $DA4A
    .byte $E6 ; |XXX  XX | $DA4B
    .byte $02 ; |      X | $DA4C
    .byte $E4 ; |XXX  X  | $DA4D
    .byte $E6 ; |XXX  XX | $DA4E
    .byte $66 ; | XX  XX | $DA4F
    .byte $6E ; | XX XXX | $DA50
    .byte $7C ; | XXXXX  | $DA51
    .byte $7C ; | XXXXX  | $DA52
    .byte $F8 ; |XXXXX   | $DA53
    .byte $78 ; | XXXX   | $DA54
    .byte $7F ; | XXXXXXX| $DA55
    .byte $78 ; | XXXX   | $DA56
    .byte $7F ; | XXXXXXX| $DA57
    .byte $38 ; |  XXX   | $DA58
    .byte $1C ; |   XXX  | $DA59
    .byte $3C ; |  XXXX  | $DA5A
    .byte $7E ; | XXXXXX | $DA5B
    .byte $7A ; | XXXX X | $DA5C
    .byte $5C ; | X XXX  | $DA5D
    .byte $7E ; | XXXXXX | $DA5E
    .byte $78 ; | XXXX   | $DA5F

    .byte $00 ; |        | $DA60
    .byte $77 ; | XXX XXX| $DA61
    .byte $66 ; | XX  XX | $DA62
    .byte $00 ; |        | $DA63
    .byte $77 ; | XXX XXX| $DA64
    .byte $37 ; |  XX XXX| $DA65
    .byte $36 ; |  XX XX | $DA66
    .byte $3E ; |  XXXXX | $DA67
    .byte $3E ; |  XXXXX | $DA68
    .byte $7C ; | XXXXX  | $DA69
    .byte $78 ; | XXXX   | $DA6A
    .byte $F8 ; |XXXXX   | $DA6B
    .byte $7B ; | XXXX XX| $DA6C
    .byte $3E ; |  XXXXX | $DA6D
    .byte $FE ; |XXXXXXX | $DA6E
    .byte $BC ; |X XXXX  | $DA6F
    .byte $98 ; |X  XX   | $DA70
    .byte $BC ; |X XXXX  | $DA71
    .byte $38 ; |  XXX   | $DA72
    .byte $7E ; | XXXXXX | $DA73
    .byte $5A ; | X XX X | $DA74
    .byte $1E ; |   XXXX | $DA75
    .byte $7F ; | XXXXXXX| $DA76
    .byte $3E ; |  XXXXX | $DA77

    .byte $00 ; |        | $DA78
    .byte $7E ; | XXXXXX | $DA79
    .byte $36 ; |  XX XX | $DA7A
    .byte $00 ; |        | $DA7B
    .byte $36 ; |  XX XX | $DA7C
    .byte $36 ; |  XX XX | $DA7D
    .byte $36 ; |  XX XX | $DA7E
    .byte $3E ; |  XXXXX | $DA7F
    .byte $3E ; |  XXXXX | $DA80
    .byte $1E ; |   XXXX | $DA81
    .byte $1E ; |   XXXX | $DA82
    .byte $7E ; | XXXXXX | $DA83
    .byte $1E ; |   XXXX | $DA84
    .byte $1E ; |   XXXX | $DA85
    .byte $7E ; | XXXXXX | $DA86
    .byte $5E ; | X XXXX | $DA87
    .byte $4C ; | X  XX  | $DA88
    .byte $DE ; |XX XXXX | $DA89
    .byte $8E ; |X   XXX | $DA8A
    .byte $BF ; |X XXXXXX| $DA8B
    .byte $2D ; |  X XX X| $DA8C
    .byte $3C ; |  XXXX  | $DA8D
    .byte $7F ; | XXXXXXX| $DA8E
    .byte $3E ; |  XXXXX | $DA8F

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
    .byte $0F ; |    XXXX| $DA9E
    .byte $0F ; |    XXXX| $DA9F
    .byte $0F ; |    XXXX| $DAA0
    .byte $0F ; |    XXXX| $DAA1
    .byte $0F ; |    XXXX| $DAA2
    .byte $0F ; |    XXXX| $DAA3
    .byte $0F ; |    XXXX| $DAA4
    .byte $0F ; |    XXXX| $DAA5
    .byte $00 ; |        | $DAA6
    .byte $00 ; |        | $DAA7
LDAA8:
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
LDAB4:
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
    .byte $C0 ; |XX      | $DAC1
    .byte $90 ; |X  X    | $DAC2
    .byte $88 ; |X   X   | $DAC3
    .byte $40 ; | X      | $DAC4
    .byte $3F ; |  XXXXXX| $DAC5
    .byte $00 ; |        | $DAC6
    .byte $3F ; |  XXXXXX| $DAC7
    .byte $40 ; | X      | $DAC8
    .byte $88 ; |X   X   | $DAC9
    .byte $90 ; |X  X    | $DACA
    .byte $C0 ; |XX      | $DACB
MugBreaking:
    .byte $00 ; |        | $DACC
    .byte $DB ; |XX XX XX| $DACD
    .byte $DB ; |XX XX XX| $DACE
    .byte $CB ; |XX  X XX| $DACF
    .byte $89 ; |X   X  X| $DAD0
    .byte $09 ; |    X  X| $DAD1
    .byte $00 ; |        | $DAD2
    .byte $00 ; |        | $DAD3
    .byte $00 ; |        | $DAD4
    .byte $00 ; |        | $DAD5
    .byte $00 ; |        | $DAD6
    .byte $00 ; |        | $DAD7
    .byte $00 ; |        | $DAD8
    .byte $00 ; |        | $DAD9
    .byte $00 ; |        | $DADA
    .byte $00 ; |        | $DADB
    .byte $00 ; |        | $DADC
    .byte $00 ; |        | $DADD
    .byte $00 ; |        | $DADE
    .byte $00 ; |        | $DADF
    .byte $00 ; |        | $DAE0
    .byte $00 ; |        | $DAE1
    .byte $00 ; |        | $DAE2
    .byte $00 ; |        | $DAE3

LDAE4:
    .byte ORANGE+6       ; $DAE4   Alien bar table legs
    .byte ORANGE+6       ; $DAE5
    .byte ORANGE+6       ; $DAE6
    .byte RED+4          ; $DAE7
    .byte RED+4          ; $DAE8
    .byte RED+4          ; $DAE9
    .byte RED+4          ; $DAEA
    .byte RED+4          ; $DAEB
    .byte RED+4          ; $DAEC
    .byte RED+4          ; $DAED
    .byte GREY+10        ; $DAEE
    .byte GREY+10        ; $DAEF

    .byte $70 ; | XXX    | $DAF0  HMMx
    .byte $60 ; | XX     | $DAF1
    .byte $50 ; | X X    | $DAF2
    .byte $40 ; | X      | $DAF3
    .byte $30 ; |  XX    | $DAF4
    .byte $20 ; |  X     | $DAF5
    .byte $10 ; |   X    | $DAF6
    .byte $00 ; |        | $DAF7
    .byte $F0 ; |XXXX    | $DAF8
    .byte $E0 ; |XXX     | $DAF9
    .byte $D0 ; |XX X    | $DAFA
    .byte $C0 ; |XX      | $DAFB
    .byte $B0 ; |X XX    | $DAFC
    .byte $A0 ; |X X     | $DAFD
    .byte $90 ; |X  X    | $DAFE
    .byte $80 ; |X       | $DAFF
LDB00:
    .byte $00 ; |        | $DB00    Soda bandit GFX
    .byte $FC ; |XXXXXX  | $DB01
    .byte $FE ; |XXXXXXX | $DB02
    .byte $7E ; | XXXXXX | $DB03
    .byte $38 ; |  XXX   | $DB04
    .byte $03 ; |      XX| $DB05
    .byte $07 ; |     XXX| $DB06
    .byte $01 ; |       X| $DB07
    .byte $17 ; |   X XXX| $DB08
    .byte $39 ; |  XXX  X| $DB09
    .byte $71 ; | XXX   X| $DB0A
    .byte $FF ; |XXXXXXXX| $DB0B
    .byte $F0 ; |XXXX    | $DB0C
    .byte $C0 ; |XX      | $DB0D
    .byte $03 ; |      XX| $DB0E
    .byte $01 ; |       X| $DB0F



    .byte PURPLE+6       ; $DB10
    .byte PURPLE+6       ; $DB11
    .byte ORANGE+4       ; $DB12
    .byte ORANGE+6       ; $DB13
    .byte ORANGE+6       ; $DB14
    .byte ORANGE+8       ; $DB15
    .byte ORANGE+8       ; $DB16
    .byte ORANGE+6       ; $DB17
    .byte BLUE_CYAN+4    ; $DB18
    .byte BLUE_CYAN+6    ; $DB19
    .byte BLACK          ; $DB1A
    .byte GREY+2         ; $DB1B
    .byte GREY+2         ; $DB1C
    .byte GREY+2         ; $DB1D
    .byte GREY+2         ; $DB1E
    .byte GREY+2         ; $DB1F
    .byte GREY           ; $DB20
    .byte GREY           ; $DB21
    .byte GREY           ; $DB22
    .byte GREY           ; $DB23
    .byte ORANGE_RED+2   ; $DB24
    .byte ORANGE_RED+4   ; $DB25
    .byte DIRTY_YELLOW+2 ; $DB26
    .byte BLACK          ; $DB27
    .byte BLACK          ; $DB28
    .byte BLACK          ; $DB29
    .byte BLACK          ; $DB2A
    .byte BLACK          ; $DB2B
    .byte BLACK          ; $DB2C
    .byte GREEN+8        ; $DB2D
    .byte GREEN+8        ; $DB2E
    .byte GREEN+8        ; $DB2F
    .byte GREY+8         ; $DB30
    .byte GREY+8         ; $DB31
    .byte GREY+8         ; $DB32
    .byte GREY+8         ; $DB33
    .byte GREY+8         ; $DB34
    .byte GREY+8         ; $DB35
    .byte GREY+8         ; $DB36
    .byte GREY+8         ; $DB37
    .byte GREY+8         ; $DB38
    .byte GREY+8         ; $DB39
    .byte GREY+8         ; $DB3A
    .byte GREY+8         ; $DB3B
    .byte GREY+8         ; $DB3C
    .byte GREY+8         ; $DB3D
    .byte GREY+8         ; $DB3E
    .byte GREY+8         ; $DB3F
    .byte ORANGE_RED+6   ; $DB40
    .byte ORANGE_RED+6   ; $DB41
    .byte ORANGE_RED+6   ; $DB42
    .byte ORANGE_RED+8   ; $DB43
    .byte ORANGE_RED+8   ; $DB44
    .byte ORANGE_RED+8   ; $DB45
    .byte ORANGE_RED+10  ; $DB46
    .byte ORANGE_RED+10  ; $DB47
    .byte ORANGE_RED+8   ; $DB48
    .byte ORANGE_RED+8   ; $DB49
    .byte ORANGE_RED+6   ; $DB4A
    .byte ORANGE_RED+6   ; $DB4B
    .byte GREY+4         ; $DB4C
    .byte GREY+2         ; $DB4D
    .byte GREY+2         ; $DB4E
    .byte GREY+2         ; $DB4F
    .byte BLUE_CYAN+2    ; $DB50
    .byte BLUE_CYAN+2    ; $DB51
    .byte BLUE_CYAN+2    ; $DB52
    .byte BLUE_CYAN+2    ; $DB53
    .byte BLUE_CYAN+2    ; $DB54
    .byte BLUE_CYAN+2    ; $DB55
    .byte BLUE_CYAN+2    ; $DB56
    .byte BLUE_CYAN+2    ; $DB57
    .byte BLUE_CYAN+2    ; $DB58
    .byte BLUE_CYAN+2    ; $DB59
    .byte BLUE_CYAN+2    ; $DB5A
    .byte BLUE_CYAN+2    ; $DB5B
    .byte BLUE_CYAN+2    ; $DB5C
    .byte BLUE_CYAN+2    ; $DB5D
    .byte BLUE_CYAN+2    ; $DB5E
    .byte BLUE_CYAN+2    ; $DB5F
    .byte BLUE_CYAN+2    ; $DB60
    .byte ORANGE+4       ; $DB61
    .byte ORANGE+6       ; $DB62
    .byte ORANGE+8       ; $DB63
    .byte RED+4          ; $DB64
    .byte BLACK          ; $DB65
    .byte DIRTY_YELLOW+2 ; $DB66
    .byte DIRTY_YELLOW+4 ; $DB67
    .byte DIRTY_YELLOW+6 ; $DB68
    .byte BLUE+4         ; $DB69
    .byte BLUE+8         ; $DB6A
    .byte BLACK          ; $DB6B
    .byte ORANGE_RED+6   ; $DB6C
    .byte ORANGE_RED+6   ; $DB6D
    .byte BLACK          ; $DB6E
    .byte BLACK          ; $DB6F
LDB70:
    .byte $0E ; |    XXX | $DB70
    .byte $0E ; |    XXX | $DB71
    .byte $0E ; |    XXX | $DB72
    .byte $1C ; |   XXX  | $DB73
    .byte $1C ; |   XXX  | $DB74
    .byte $38 ; |  XXX   | $DB75
    .byte $38 ; |  XXX   | $DB76
    .byte $70 ; | XXX    | $DB77
    .byte $70 ; | XXX    | $DB78
    .byte $00 ; |        | $DB79
    .byte $00 ; |        | $DB7A
    .byte $0E ; |    XXX | $DB7B
    .byte $0E ; |    XXX | $DB7C
    .byte $0E ; |    XXX | $DB7D
    .byte $1C ; |   XXX  | $DB7E
    .byte $1C ; |   XXX  | $DB7F
    .byte $38 ; |  XXX   | $DB80
    .byte $70 ; | XXX    | $DB81

LDB82:
    .byte ORANGE+4       ; $DB82
    .byte ORANGE+4       ; $DB83
    .byte ORANGE+4       ; $DB84
    .byte BLUE+2         ; $DB85
    .byte GREY+8         ; $DB86
    .byte BLUE+2         ; $DB87
    .byte GREY+8         ; $DB88
    .byte GREY+8         ; $DB89
    .byte GREY+8         ; $DB8A
    .byte ORANGE+4       ; $DB8B
    .byte ORANGE+4       ; $DB8C
    .byte ORANGE+4       ; $DB8D
    .byte ORANGE+4       ; $DB8E
    .byte ORANGE+4       ; $DB8F

    .byte $82; BLUE+2         ; $DB90   GFX
    .byte $0A; GREY+8         ; $DB91
    .byte $0A; GREY+8         ; $DB92
    .byte $0A; GREY+8         ; $DB93

    .byte $00 ; |        | $DB94
    .byte $00 ; |        | $DB95
    .byte $00 ; |        | $DB96
    .byte $00 ; |        | $DB97
    .byte $00 ; |        | $DB98
    .byte $00 ; |        | $DB99
    .byte $00 ; |        | $DB9A
    .byte $00 ; |        | $DB9B
    .byte $00 ; |        | $DB9C
    .byte $24 ; |  X  X  | $DB9D
    .byte $24 ; |  X  X  | $DB9E
    .byte $24 ; |  X  X  | $DB9F
    .byte $02 ; |      X | $DBA0
    .byte $02 ; |      X | $DBA1
    .byte $02 ; |      X | $DBA2
    .byte $02 ; |      X | $DBA3
    .byte $02 ; |      X | $DBA4
    .byte $02 ; |      X | $DBA5
LDBA6:
    .byte $01 ; |       X| $DBA6
    .byte $01 ; |       X| $DBA7
    .byte $01 ; |       X| $DBA8
    .byte $03 ; |      XX| $DBA9
    .byte $03 ; |      XX| $DBAA
    .byte $03 ; |      XX| $DBAB
    .byte $03 ; |      XX| $DBAC
    .byte $0F ; |    XXXX| $DBAD
    .byte $0F ; |    XXXX| $DBAE
    .byte $0F ; |    XXXX| $DBAF
    .byte $0F ; |    XXXX| $DBB0
    .byte $0F ; |    XXXX| $DBB1
    .byte $1F ; |   XXXXX| $DBB2
    .byte $1F ; |   XXXXX| $DBB3
    .byte $1F ; |   XXXXX| $DBB4
    .byte $1F ; |   XXXXX| $DBB5
    .byte $1F ; |   XXXXX| $DBB6
    .byte $1F ; |   XXXXX| $DBB7
    .byte $3F ; |  XXXXXX| $DBB8
    .byte $3F ; |  XXXXXX| $DBB9
    .byte $3F ; |  XXXXXX| $DBBA
    .byte $3F ; |  XXXXXX| $DBBB
    .byte $3F ; |  XXXXXX| $DBBC
    .byte $3F ; |  XXXXXX| $DBBD
    .byte $3F ; |  XXXXXX| $DBBE
    .byte $7F ; | XXXXXXX| $DBBF
    .byte $7F ; | XXXXXXX| $DBC0
    .byte $7F ; | XXXXXXX| $DBC1
    .byte $7F ; | XXXXXXX| $DBC2
    .byte $FF ; |XXXXXXXX| $DBC3
    .byte $FF ; |XXXXXXXX| $DBC4
    .byte $FF ; |XXXXXXXX| $DBC5

    jsr    LDBC9                 ; 6   re-check
LDBC9 SUBROUTINE
    rts                          ; 6


START:
    lda    #$2C                  ; 2   BIT opcode
    sta    $FA                   ; 3
    lda    #>LFFF9               ; 2
    sta    $FC                   ; 3
    ldx    #<LF000               ; 2
    ldy    #>LF000               ; 2
    lda    #$4C                  ; 2   JMP opcode
    sta    $FD                   ; 3
    jmp    LD71E                 ; 3

    .byte $FF ; |XXXXXXXX| $DBDD
    .byte $FF ; |XXXXXXXX| $DBDE
    .byte $FF ; |XXXXXXXX| $DBDF
    .byte $FF ; |XXXXXXXX| $DBE0
    .byte $FF ; |XXXXXXXX| $DBE1
    .byte $FF ; |XXXXXXXX| $DBE2
    .byte $FF ; |XXXXXXXX| $DBE3
    .byte $FF ; |XXXXXXXX| $DBE4
    .byte $FF ; |XXXXXXXX| $DBE5
    .byte $FF ; |XXXXXXXX| $DBE6
    .byte $FF ; |XXXXXXXX| $DBE7
    .byte $FF ; |XXXXXXXX| $DBE8
    .byte $FF ; |XXXXXXXX| $DBE9
    .byte $FF ; |XXXXXXXX| $DBEA
    .byte $FF ; |XXXXXXXX| $DBEB
    .byte $FF ; |XXXXXXXX| $DBEC
    .byte $FF ; |XXXXXXXX| $DBED
    .byte $FF ; |XXXXXXXX| $DBEE
    .byte $FF ; |XXXXXXXX| $DBEF
    .byte $00 ; |        | $DBF0
    .byte $00 ; |        | $DBF1
    .byte $00 ; |        | $DBF2
    .byte $00 ; |        | $DBF3
    .byte $80 ; |X       | $DBF4   not colors
    .byte $80 ; |X       | $DBF5
    .byte $80 ; |X       | $DBF6
    .byte $40 ; | X      | $DBF7
    .byte $40 ; | X      | $DBF8
    .byte $40 ; | X      | $DBF9
    .byte $C0 ; |XX      | $DBFA
    .byte $C0 ; |XX      | $DBFB
    .byte $C0 ; |XX      | $DBFC
    .byte $20 ; |  X     | $DBFD
    .byte $20 ; |  X     | $DBFE
    .byte $20 ; |  X     | $DBFF

       ORG $0C00
      RORG $DC00

CowboyGfx1:
    .byte $7E ; | XXXXXX | $DC00
    .byte $7E ; | XXXXXX | $DC01
    .byte $3C ; |  XXXX  | $DC02
    .byte $18 ; |   XX   | $DC03
    .byte $1C ; |   XXX  | $DC04
    .byte $3A ; |  XXX X | $DC05
    .byte $3E ; |  XXXXX | $DC06
    .byte $34 ; |  XX X  | $DC07
    .byte $7E ; | XXXXXX | $DC08
    .byte $7F ; | XXXXXXX| $DC09
    .byte $5D ; | X XXX X| $DC0A
    .byte $1C ; |   XXX  | $DC0B
JockGfx1:
    .byte $FC ; |XXXXXX  | $DC0C
    .byte $FC ; |XXXXXX  | $DC0D
    .byte $78 ; | XXXX   | $DC0E
    .byte $38 ; |  XXX   | $DC0F
    .byte $30 ; |  XX    | $DC10
    .byte $7C ; | XXXXX  | $DC11
    .byte $7C ; | XXXXX  | $DC12
    .byte $EA ; |XXX X X | $DC13
    .byte $FE ; |XXXXXXX | $DC14
    .byte $FF ; |XXXXXXXX| $DC15
    .byte $FF ; |XXXXXXXX| $DC16
    .byte $78 ; | XXXX   | $DC17
PunkGfx1:
    .byte $7E ; | XXXXXX | $DC18
    .byte $7E ; | XXXXXX | $DC19
    .byte $3C ; |  XXXX  | $DC1A
    .byte $18 ; |   XX   | $DC1B
    .byte $3C ; |  XXXX  | $DC1C
    .byte $34 ; |  XX X  | $DC1D
    .byte $3C ; |  XXXX  | $DC1E
    .byte $7E ; | XXXXXX | $DC1F
    .byte $6A ; | XX X X | $DC20
    .byte $7E ; | XXXXXX | $DC21
    .byte $FE ; |XXXXXXX | $DC22
    .byte $E7 ; |XXX  XXX| $DC23
AlienGfx1:
    .byte $FC ; |XXXXXX  | $DC24
    .byte $FC ; |XXXXXX  | $DC25
    .byte $78 ; | XXXX   | $DC26
    .byte $38 ; |  XXX   | $DC27
    .byte $7C ; | XXXXX  | $DC28
    .byte $7C ; | XXXXX  | $DC29
    .byte $C6 ; |XX   XX | $DC2A
    .byte $FE ; |XXXXXXX | $DC2B
    .byte $6C ; | XX XX  | $DC2C
    .byte $FE ; |XXXXXXX | $DC2D
    .byte $BA ; |X XXX X | $DC2E
    .byte $EE ; |XXX XXX | $DC2F

LDC30:
    .byte $00 ; |        | $DC30   end of the bar table
    .byte $FE ; |XXXXXXX | $DC31
    .byte $FE ; |XXXXXXX | $DC32
    .byte $FC ; |XXXXXX  | $DC33
    .byte $FC ; |XXXXXX  | $DC34
    .byte $FC ; |XXXXXX  | $DC35
    .byte $F8 ; |XXXXX   | $DC36
    .byte $F8 ; |XXXXX   | $DC37
    .byte $F8 ; |XXXXX   | $DC38
    .byte $F0 ; |XXXX    | $DC39
    .byte $F0 ; |XXXX    | $DC3A
    .byte $F0 ; |XXXX    | $DC3B
CowboyGfx2:
    .byte $3E ; |  XXXXX | $DC3C
    .byte $3E ; |  XXXXX | $DC3D
    .byte $1E ; |   XXXX | $DC3E
    .byte $0C ; |    XX  | $DC3F
    .byte $1E ; |   XXXX | $DC40
    .byte $1A ; |   XX X | $DC41
    .byte $3A ; |  XXX X | $DC42
    .byte $7E ; | XXXXXX | $DC43
    .byte $F5 ; |XXXX X X| $DC44
    .byte $FF ; |XXXXXXXX| $DC45
    .byte $38 ; |  XXX   | $DC46
    .byte $38 ; |  XXX   | $DC47
JockGfx2:
    .byte $7D ; | XXXXX X| $DC48
    .byte $7D ; | XXXXX X| $DC49
    .byte $3B ; |  XXX XX| $DC4A
    .byte $3B ; |  XXX XX| $DC4B
    .byte $71 ; | XXX   X| $DC4C
    .byte $7D ; | XXXXX X| $DC4D
    .byte $FC ; |XXXXXX  | $DC4E
    .byte $EA ; |XXX X X | $DC4F
    .byte $FE ; |XXXXXXX | $DC50
    .byte $FF ; |XXXXXXXX| $DC51
    .byte $FF ; |XXXXXXXX| $DC52
    .byte $78 ; | XXXX   | $DC53
PunkGfx2:
    .byte $BD ; |X XXXX X| $DC54
    .byte $BD ; |X XXXX X| $DC55
    .byte $DB ; |XX XX XX| $DC56
    .byte $DB ; |XX XX XX| $DC57
    .byte $BD ; |X XXXX X| $DC58
    .byte $34 ; |  XX X  | $DC59
    .byte $34 ; |  XX X  | $DC5A
    .byte $3E ; |  XXXXX | $DC5B
    .byte $FF ; |XXXXXXXX| $DC5C
    .byte $EB ; |XXX X XX| $DC5D
    .byte $7E ; | XXXXXX | $DC5E
    .byte $3C ; |  XXXX  | $DC5F
AlienGfx2:
    .byte $FE ; |XXXXXXX | $DC60
    .byte $7C ; | XXXXX  | $DC61
    .byte $38 ; |  XXX   | $DC62
    .byte $7C ; | XXXXX  | $DC63
    .byte $FE ; |XXXXXXX | $DC64
    .byte $C6 ; |XX   XX | $DC65
    .byte $92 ; |X  X  X | $DC66
    .byte $FE ; |XXXXXXX | $DC67
    .byte $6C ; | XX XX  | $DC68
    .byte $FE ; |XXXXXXX | $DC69
    .byte $BA ; |X XXX X | $DC6A
    .byte $FE ; |XXXXXXX | $DC6B

LDC6C:
    .byte ORANGE+4       ; $DC6C
    .byte DIRTY_YELLOW+4 ; $DC6D
    .byte DIRTY_YELLOW+6 ; $DC6E
    .byte ORANGE+4       ; $DC6F
    .byte ORANGE+4       ; $DC70
    .byte ORANGE+4       ; $DC71
    .byte ORANGE+4       ; $DC72
    .byte ORANGE+4       ; $DC73
    .byte ORANGE+2       ; $DC74
    .byte ORANGE         ; $DC75
    .byte ORANGE+6       ; $DC76
    .byte ORANGE+6       ; $DC77

CowboyGfx3:
    .byte $3F ; |  XXXXXX| $DC78
    .byte $3F ; |  XXXXXX| $DC79
    .byte $3A ; |  XXX X | $DC7A
    .byte $1C ; |   XXX  | $DC7B
    .byte $1C ; |   XXX  | $DC7C
    .byte $3A ; |  XXX X | $DC7D
    .byte $3E ; |  XXXXX | $DC7E
    .byte $34 ; |  XX X  | $DC7F
    .byte $7E ; | XXXXXX | $DC80
    .byte $7F ; | XXXXXXX| $DC81
    .byte $5D ; | X XXX X| $DC82
    .byte $1C ; |   XXX  | $DC83
JockGfx3:
    .byte $7F ; | XXXXXXX| $DC84
    .byte $7F ; | XXXXXXX| $DC85
    .byte $72 ; | XXX  X | $DC86
    .byte $3A ; |  XXX X | $DC87
    .byte $38 ; |  XXX   | $DC88
    .byte $70 ; | XXX    | $DC89
    .byte $7C ; | XXXXX  | $DC8A
    .byte $EA ; |XXX X X | $DC8B
    .byte $FE ; |XXXXXXX | $DC8C
    .byte $FF ; |XXXXXXXX| $DC8D
    .byte $FF ; |XXXXXXXX| $DC8E
    .byte $78 ; | XXXX   | $DC8F
PunkGfx3:
    .byte $7F ; | XXXXXXX| $DC90
    .byte $7F ; | XXXXXXX| $DC91
    .byte $3A ; |  XXX X | $DC92
    .byte $18 ; |   XX   | $DC93
    .byte $3C ; |  XXXX  | $DC94
    .byte $34 ; |  XX X  | $DC95
    .byte $3C ; |  XXXX  | $DC96
    .byte $7E ; | XXXXXX | $DC97
    .byte $6A ; | XX X X | $DC98
    .byte $7E ; | XXXXXX | $DC99
    .byte $FE ; |XXXXXXX | $DC9A
    .byte $E7 ; |XXX  XXX| $DC9B
AlienGfx3:
    .byte $7F ; | XXXXXXX| $DC9C
    .byte $7F ; | XXXXXXX| $DC9D
    .byte $7A ; | XXXX X | $DC9E
    .byte $38 ; |  XXX   | $DC9F
    .byte $7C ; | XXXXX  | $DCA0
    .byte $6C ; | XX XX  | $DCA1
    .byte $FE ; |XXXXXXX | $DCA2
    .byte $FE ; |XXXXXXX | $DCA3
    .byte $6C ; | XX XX  | $DCA4
    .byte $FE ; |XXXXXXX | $DCA5
    .byte $BA ; |X XXX X | $DCA6
    .byte $EE ; |XXX XXX | $DCA7

LDCA8:
    .byte ORANGE+4       ; $DCA8
    .byte ORANGE+4       ; $DCA9
    .byte ORANGE+4       ; $DCAA
    .byte BLUE_CYAN+6    ; $DCAB
    .byte BLUE_CYAN+6    ; $DCAC
    .byte BLUE_CYAN+6    ; $DCAD
    .byte BLUE_CYAN+6    ; $DCAE
    .byte BLUE_CYAN+6    ; $DCAF
    .byte BLUE_CYAN+10   ; $DCB0
    .byte BLUE_CYAN+10   ; $DCB1
    .byte ORANGE+4       ; $DCB2
    .byte ORANGE+4       ; $DCB3

CowboyGfx4:
    .byte $3C ; |  XXXX  | $DCB4
    .byte $3F ; |  XXXXXX| $DCB5
    .byte $1B ; |   XX XX| $DCB6
    .byte $1C ; |   XXX  | $DCB7
    .byte $1C ; |   XXX  | $DCB8
    .byte $36 ; |  XX XX | $DCB9
    .byte $3E ; |  XXXXX | $DCBA
    .byte $6B ; | XX X XX| $DCBB
    .byte $7F ; | XXXXXXX| $DCBC
    .byte $7F ; | XXXXXXX| $DCBD
    .byte $1C ; |   XXX  | $DCBE
    .byte $1C ; |   XXX  | $DCBF
JockGfx4:
    .byte $7C ; | XXXXX  | $DCC0
    .byte $7E ; | XXXXXX | $DCC1
    .byte $3C ; |  XXXX  | $DCC2
    .byte $38 ; |  XXX   | $DCC3
    .byte $28 ; |  X X   | $DCC4
    .byte $7C ; | XXXXX  | $DCC5
    .byte $7C ; | XXXXX  | $DCC6
    .byte $D4 ; |XX X X  | $DCC7
    .byte $FC ; |XXXXXX  | $DCC8
    .byte $FE ; |XXXXXXX | $DCC9
    .byte $7E ; | XXXXXX | $DCCA
    .byte $38 ; |  XXX   | $DCCB
PunkGfx4:
    .byte $7F ; | XXXXXXX| $DCCC
    .byte $7F ; | XXXXXXX| $DCCD
    .byte $3A ; |  XXX X | $DCCE
    .byte $18 ; |   XX   | $DCCF
    .byte $30 ; |  XX    | $DCD0
    .byte $3C ; |  XXXX  | $DCD1
    .byte $3E ; |  XXXXX | $DCD2
    .byte $FE ; |XXXXXXX | $DCD3
    .byte $F4 ; |XXXX X  | $DCD4
    .byte $7F ; | XXXXXXX| $DCD5
    .byte $7F ; | XXXXXXX| $DCD6
    .byte $36 ; |  XX XX | $DCD7
AlienGfx4:
    .byte $FE ; |XXXXXXX | $DCD8
    .byte $FE ; |XXXXXXX | $DCD9
    .byte $7C ; | XXXXX  | $DCDA
    .byte $38 ; |  XXX   | $DCDB
    .byte $6C ; | XX XX  | $DCDC
    .byte $44 ; | X   X  | $DCDD
    .byte $FE ; |XXXXXXX | $DCDE
    .byte $EE ; |XXX XXX | $DCDF
    .byte $FE ; |XXXXXXX | $DCE0
    .byte $BA ; |X XXX X | $DCE1
    .byte $EE ; |XXX XXX | $DCE2
    .byte $00 ; |        | $DCE3

LDCE4:
    .byte $FF ; |XXXXXXXX| $DCE4
    .byte $FF ; |XXXXXXXX| $DCE5
    .byte $FE ; |XXXXXXX | $DCE6
    .byte $FC ; |XXXXXX  | $DCE7
    .byte $FC ; |XXXXXX  | $DCE8
    .byte $FC ; |XXXXXX  | $DCE9
    .byte $F8 ; |XXXXX   | $DCEA
    .byte $F0 ; |XXXX    | $DCEB
    .byte $F0 ; |XXXX    | $DCEC
    .byte $F0 ; |XXXX    | $DCED
    .byte $E0 ; |XXX     | $DCEE
    .byte $C0 ; |XX      | $DCEF

    .byte $00 ; |        | $DCF0   free bytes
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

       ORG $0D00
      RORG $DD00

CowboyGfx5:
    .byte $7C ; | XXXXX  | $DD00
    .byte $7C ; | XXXXX  | $DD01
    .byte $7C ; | XXXXX  | $DD02
    .byte $38 ; |  XXX   | $DD03
    .byte $18 ; |   XX   | $DD04
    .byte $F4 ; |XXXX X  | $DD05
    .byte $7C ; | XXXXX  | $DD06
    .byte $7C ; | XXXXX  | $DD07
    .byte $6A ; | XX X X | $DD08
    .byte $FE ; |XXXXXXX | $DD09
    .byte $FE ; |XXXXXXX | $DD0A
    .byte $38 ; |  XXX   | $DD0B
JockGfx5:
    .byte $7C ; | XXXXX  | $DD0C   wearing a bandana
    .byte $7C ; | XXXXX  | $DD0D
    .byte $38 ; |  XXX   | $DD0E
    .byte $30 ; |  XX    | $DD0F
    .byte $1C ; |   XXX  | $DD10
    .byte $BE ; |X XXXXX | $DD11
    .byte $BE ; |X XXXXX | $DD12
    .byte $FA ; |XXXXX X | $DD13
    .byte $CE ; |XX  XXX | $DD14
    .byte $70 ; | XXX    | $DD15
    .byte $3E ; |  XXXXX | $DD16
    .byte $1C ; |   XXX  | $DD17
PunkGfx5:
    .byte $7E ; | XXXXXX | $DD18
    .byte $7C ; | XXXXX  | $DD19
    .byte $3C ; |  XXXX  | $DD1A
    .byte $18 ; |   XX   | $DD1B
    .byte $38 ; |  XXX   | $DD1C
    .byte $7C ; | XXXXX  | $DD1D
    .byte $74 ; | XXX X  | $DD1E
    .byte $7E ; | XXXXXX | $DD1F
    .byte $6A ; | XX X X | $DD20
    .byte $7E ; | XXXXXX | $DD21
    .byte $7E ; | XXXXXX | $DD22
    .byte $54 ; | X X X  | $DD23
AlienGfx5:
    .byte $3C ; |  XXXX  | $DD24
    .byte $3C ; |  XXXX  | $DD25
    .byte $18 ; |   XX   | $DD26
    .byte $3C ; |  XXXX  | $DD27
    .byte $24 ; |  X  X  | $DD28
    .byte $3C ; |  XXXX  | $DD29
    .byte $18 ; |   XX   | $DD2A
    .byte $1C ; |   XXX  | $DD2B
    .byte $3E ; |  XXXXX | $DD2C
    .byte $6A ; | XX X X | $DD2D
    .byte $7E ; | XXXXXX | $DD2E
    .byte $36 ; |  XX XX | $DD2F
LDD30:
    .byte ORANGE+2       ; $DD30
    .byte DIRTY_YELLOW+4 ; $DD31
    .byte DIRTY_YELLOW+6 ; $DD32
    .byte ORANGE+2       ; $DD33
    .byte ORANGE+2       ; $DD34
    .byte ORANGE+2       ; $DD35
    .byte ORANGE+2       ; $DD36
    .byte ORANGE+2       ; $DD37
    .byte ORANGE+2       ; $DD38
    .byte ORANGE         ; $DD39
    .byte ORANGE+6       ; $DD3A
    .byte ORANGE+6       ; $DD3B

CowboyGfx6:
    .byte $7F ; | XXXXXXX| $DD3C
    .byte $7F ; | XXXXXXX| $DD3D
    .byte $3D ; |  XXXX X| $DD3E
    .byte $1B ; |   XX XX| $DD3F
    .byte $3B ; |  XXX XX| $DD40
    .byte $2D ; |  X XX X| $DD41
    .byte $6E ; | XX XXX | $DD42
    .byte $7E ; | XXXXXX | $DD43
    .byte $D4 ; |XX X X  | $DD44
    .byte $FE ; |XXXXXXX | $DD45
    .byte $7E ; | XXXXXX | $DD46
    .byte $78 ; | XXXX   | $DD47
JockGfx6:
    .byte $7C ; | XXXXX  | $DD48   wearing a bandana
    .byte $3C ; |  XXXX  | $DD49
    .byte $36 ; |  XX XX | $DD4A
    .byte $1E ; |   XXXX | $DD4B
    .byte $9C ; |X  XXX  | $DD4C
    .byte $B8 ; |X XXX   | $DD4D
    .byte $BE ; |X XXXXX | $DD4E
    .byte $FE ; |XXXXXXX | $DD4F
    .byte $5A ; | X XX X | $DD50
    .byte $6E ; | XX XXX | $DD51
    .byte $70 ; | XXX    | $DD52
    .byte $3C ; |  XXXX  | $DD53
PunkGfx6:
    .byte $FE ; |XXXXXXX | $DD54
    .byte $BE ; |X XXXXX | $DD55
    .byte $DC ; |XX XXX  | $DD56
    .byte $D8 ; |XX XX   | $DD57
    .byte $BC ; |X XXXX  | $DD58
    .byte $2C ; |  X XX  | $DD59
    .byte $2C ; |  X XX  | $DD5A
    .byte $7C ; | XXXXX  | $DD5B
    .byte $56 ; | X X XX | $DD5C
    .byte $7E ; | XXXXXX | $DD5D
    .byte $7E ; | XXXXXX | $DD5E
    .byte $2A ; |  X X X | $DD5F
AlienGfx6:
    .byte $BD ; |X XXXX X| $DD60
    .byte $BD ; |X XXXX X| $DD61
    .byte $DB ; |XX XX XX| $DD62
    .byte $BD ; |X XXXX X| $DD63
    .byte $B5 ; |X XX X X| $DD64
    .byte $35 ; |  XX X X| $DD65
    .byte $3C ; |  XXXX  | $DD66
    .byte $18 ; |   XX   | $DD67
    .byte $3C ; |  XXXX  | $DD68
    .byte $7E ; | XXXXXX | $DD69
    .byte $6A ; | XX X X | $DD6A
    .byte $3E ; |  XXXXX | $DD6B
LDD6C:
    .byte $07 ; |     XXX| $DD6C   GFX
    .byte $07 ; |     XXX| $DD6D
    .byte $0F ; |    XXXX| $DD6E
    .byte $0F ; |    XXXX| $DD6F
    .byte $1F ; |   XXXXX| $DD70
    .byte $1F ; |   XXXXX| $DD71
    .byte $3F ; |  XXXXXX| $DD72
    .byte $37 ; |  XX XXX| $DD73
    .byte $77 ; | XXX XXX| $DD74
    .byte $77 ; | XXX XXX| $DD75
    .byte $E7 ; |XXX  XXX| $DD76
    .byte $E7 ; |XXX  XXX| $DD77

CowboyGfx7:
    .byte $7F ; | XXXXXXX| $DD78
    .byte $7F ; | XXXXXXX| $DD79
    .byte $7A ; | XXXX X | $DD7A
    .byte $38 ; |  XXX   | $DD7B
    .byte $18 ; |   XX   | $DD7C
    .byte $F0 ; |XXXX    | $DD7D
    .byte $7C ; | XXXXX  | $DD7E
    .byte $7C ; | XXXXX  | $DD7F
    .byte $6A ; | XX X X | $DD80
    .byte $FE ; |XXXXXXX | $DD81
    .byte $FE ; |XXXXXXX | $DD82
    .byte $38 ; |  XXX   | $DD83
JockGfx7:
    .byte $7E ; | XXXXXX | $DD84   wearing a bandana
    .byte $3E ; |  XXXXX | $DD85
    .byte $18 ; |   XX   | $DD86
    .byte $1C ; |   XXX  | $DD87
    .byte $9E ; |X  XXXX | $DD88
    .byte $BA ; |X XXX X | $DD89
    .byte $FE ; |XXXXXXX | $DD8A
    .byte $FE ; |XXXXXXX | $DD8B
    .byte $74 ; | XXX X  | $DD8C
    .byte $5E ; | X XXXX | $DD8D
    .byte $60 ; | XX     | $DD8E
    .byte $3E ; |  XXXXX | $DD8F
PunkGfx7:
    .byte $3F ; |  XXXXXX| $DD90
    .byte $3F ; |  XXXXXX| $DD91
    .byte $3A ; |  XXX X | $DD92
    .byte $18 ; |   XX   | $DD93
    .byte $3C ; |  XXXX  | $DD94
    .byte $3C ; |  XXXX  | $DD95
    .byte $76 ; | XXX XX | $DD96
    .byte $7E ; | XXXXXX | $DD97
    .byte $6A ; | XX X X | $DD98
    .byte $7E ; | XXXXXX | $DD99
    .byte $7E ; | XXXXXX | $DD9A
    .byte $54 ; | X X X  | $DD9B
AlienGfx7:
    .byte $3F ; |  XXXXXX| $DD9C
    .byte $3F ; |  XXXXXX| $DD9D
    .byte $1A ; |   XX X | $DD9E
    .byte $3C ; |  XXXX  | $DD9F
    .byte $34 ; |  XX X  | $DDA0
    .byte $3C ; |  XXXX  | $DDA1
    .byte $18 ; |   XX   | $DDA2
    .byte $1C ; |   XXX  | $DDA3
    .byte $3E ; |  XXXXX | $DDA4
    .byte $6A ; | XX X X | $DDA5
    .byte $7E ; | XXXXXX | $DDA6
    .byte $36 ; |  XX XX | $DDA7

LDDA8:
    .byte YELLOW_GREEN+6 ; $DDA8
    .byte YELLOW_GREEN+6 ; $DDA9
    .byte YELLOW_GREEN+6 ; $DDAA
    .byte YELLOW_GREEN+4 ; $DDAB
    .byte YELLOW_GREEN+2 ; $DDAC
    .byte YELLOW_GREEN+2 ; $DDAD
    .byte YELLOW_GREEN+2 ; $DDAE
    .byte YELLOW_GREEN+2 ; $DDAF
    .byte YELLOW_GREEN+2 ; $DDB0
    .byte YELLOW_GREEN+2 ; $DDB1
    .byte YELLOW_GREEN+2 ; $DDB2
    .byte YELLOW_GREEN+2 ; $DDB3

CowboyGfx8:
    .byte $FE ; |XXXXXXX | $DDB4
    .byte $FE ; |XXXXXXX | $DDB5
    .byte $3E ; |  XXXXX | $DDB6
    .byte $3C ; |  XXXX  | $DDB7
    .byte $18 ; |   XX   | $DDB8
    .byte $3E ; |  XXXXX | $DDB9
    .byte $6E ; | XX XXX | $DDBA
    .byte $7C ; | XXXXX  | $DDBB
    .byte $56 ; | X X XX | $DDBC
    .byte $7E ; | XXXXXX | $DDBD
    .byte $FE ; |XXXXXXX | $DDBE
    .byte $3C ; |  XXXX  | $DDBF
JockGfx8:
    .byte $7F ; | XXXXXXX| $DDC0   wearing a bandana
    .byte $7F ; | XXXXXXX| $DDC1
    .byte $3A ; |  XXX X | $DDC2
    .byte $30 ; |  XX    | $DDC3
    .byte $1C ; |   XXX  | $DDC4
    .byte $BE ; |X XXXXX | $DDC5
    .byte $BE ; |X XXXXX | $DDC6
    .byte $FA ; |XXXXX X | $DDC7
    .byte $CE ; |XX  XXX | $DDC8
    .byte $70 ; | XXX    | $DDC9
    .byte $3E ; |  XXXXX | $DDCA
    .byte $1C ; |   XXX  | $DDCB
PunkGfx8:
    .byte $3C ; |  XXXX  | $DDCC
    .byte $3F ; |  XXXXXX| $DDCD
    .byte $3F ; |  XXXXXX| $DDCE
    .byte $1B ; |   XX XX| $DDCF
    .byte $18 ; |   XX   | $DDD0
    .byte $3C ; |  XXXX  | $DDD1
    .byte $3C ; |  XXXX  | $DDD2
    .byte $36 ; |  XX XX | $DDD3
    .byte $7E ; | XXXXXX | $DDD4
    .byte $6A ; | XX X X | $DDD5
    .byte $7E ; | XXXXXX | $DDD6
    .byte $3C ; |  XXXX  | $DDD7
AlienGfx8:
    .byte $3C ; |  XXXX  | $DDD8
    .byte $3C ; |  XXXX  | $DDD9
    .byte $18 ; |   XX   | $DDDA
    .byte $3C ; |  XXXX  | $DDDB
    .byte $2C ; |  X XX  | $DDDC
    .byte $2C ; |  X XX  | $DDDD
    .byte $3C ; |  XXXX  | $DDDE
    .byte $18 ; |   XX   | $DDDF
    .byte $3C ; |  XXXX  | $DDE0
    .byte $7E ; | XXXXXX | $DDE1
    .byte $56 ; | X X XX | $DDE2
    .byte $3C ; |  XXXX  | $DDE3
LDDE4:
    .byte BLACK          ; $DDE4
    .byte BLACK          ; $DDE5
    .byte BLACK          ; $DDE6
    .byte BLUE_CYAN      ; $DDE7
    .byte BLUE_CYAN      ; $DDE8
    .byte BLUE_CYAN      ; $DDE9
    .byte BLUE_CYAN      ; $DDEA
    .byte BLUE_CYAN      ; $DDEB
    .byte BLUE_CYAN      ; $DDEC
    .byte BLUE_CYAN      ; $DDED
    .byte WHITE          ; $DDEE
    .byte WHITE          ; $DDEF

    .byte $00 ; |        | $DDF0   free bytes
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

       ORG $0E00
      RORG $DE00

    .byte $0E ; |    XXX | $DE00  GFX, and color!
    .byte $1F ; |   XXXXX| $DE01
    .byte $1F ; |   XXXXX| $DE02
    .byte $1B ; |   XX XX| $DE03
    .byte $17 ; |   X XXX| $DE04
    .byte $0F ; |    XXXX| $DE05
    .byte $3F ; |  XXXXXX| $DE06
    .byte $4E ; | X  XXX | $DE07
    .byte $8E ; |X   XXX | $DE08
    .byte $0E ; |    XXX | $DE09
    .byte $0E ; |    XXX | $DE0A
    .byte $0E ; |    XXX | $DE0B
LDE0C:
    .byte $E0 ; |XXX     | $DE0C
    .byte $E0 ; |XXX     | $DE0D
    .byte $E1 ; |XXX    X| $DE0E
    .byte $E0 ; |XXX     | $DE0F
    .byte $E0 ; |XXX     | $DE10
    .byte $E1 ; |XXX    X| $DE11
    .byte $E0 ; |XXX     | $DE12
    .byte $E0 ; |XXX     | $DE13
    .byte $E1 ; |XXX    X| $DE14
    .byte $E0 ; |XXX     | $DE15
    .byte $F0 ; |XXXX    | $DE16
    .byte $F1 ; |XXXX   X| $DE17
    .byte $F0 ; |XXXX    | $DE18
    .byte $76 ; | XXX XX | $DE19
    .byte $37 ; |  XX XXX| $DE1A
    .byte $16 ; |   X XX | $DE1B
    .byte $07 ; |     XXX| $DE1C
    .byte $0C ; |    XX  | $DE1D
    .byte $18 ; |   XX   | $DE1E
    .byte $17 ; |   X XXX| $DE1F
    .byte $1C ; |   XXX  | $DE20
    .byte $11 ; |   X   X| $DE21
    .byte $1E ; |   XXXX | $DE22
    .byte $3C ; |  XXXX  | $DE23
    .byte $3E ; |  XXXXX | $DE24
    .byte $33 ; |  XX  XX| $DE25
    .byte $31 ; |  XX   X| $DE26
    .byte $1F ; |   XXXXX| $DE27
    .byte $11 ; |   X   X| $DE28
    .byte $1B ; |   XX XX| $DE29
    .byte $0F ; |    XXXX| $DE2A
    .byte $07 ; |     XXX| $DE2B
LDE2C:
    .byte $00 ; |        | $DE2C
    .byte $3C ; |  XXXX  | $DE2D
    .byte $7E ; | XXXXXX | $DE2E
    .byte $FF ; |XXXXXXXX| $DE2F
    .byte $FF ; |XXXXXXXX| $DE30
    .byte $7E ; | XXXXXX | $DE31
    .byte $3C ; |  XXXX  | $DE32
    .byte $D5 ; |XX X X X| $DE33
    .byte $D5 ; |XX X X X| $DE34
    .byte $D5 ; |XX X X X| $DE35
    .byte $38 ; |  XXX   | $DE36
    .byte $38 ; |  XXX   | $DE37
    .byte $38 ; |  XXX   | $DE38
    .byte $38 ; |  XXX   | $DE39

LDE3A:
    .byte WHITE          ; $DE3A
    .byte WHITE          ; $DE3B
    .byte WHITE          ; $DE3C
    .byte WHITE          ; $DE3D
    .byte ORANGE_RED+10  ; $DE3E
    .byte ORANGE_RED+10  ; $DE3F
    .byte ORANGE_RED+10  ; $DE40
    .byte ORANGE_RED+10  ; $DE41
    .byte ORANGE_RED+10  ; $DE42
    .byte ORANGE_RED+2   ; $DE43
    .byte ORANGE_RED+2   ; $DE44
    .byte ORANGE_RED+2   ; $DE45
LDE46:
    .byte GREY+10        ; $DE46
    .byte GREY+10        ; $DE47
    .byte GREY+10        ; $DE48
    .byte GREY+10        ; $DE49
    .byte ORANGE_RED+6   ; $DE4A
    .byte ORANGE_RED+6   ; $DE4B
    .byte ORANGE_RED+6   ; $DE4C
    .byte ORANGE_RED+6   ; $DE4D
    .byte ORANGE_RED+6   ; $DE4E
    .byte ORANGE+2       ; $DE4F
    .byte ORANGE+2       ; $DE50
    .byte ORANGE+2       ; $DE51

    .byte $0E ; |    XXX | $DE52
    .byte $1F ; |   XXXXX| $DE53
    .byte $1F ; |   XXXXX| $DE54
    .byte $1B ; |   XX XX| $DE55
    .byte $77 ; | XXX XXX| $DE56
    .byte $4F ; | X  XXXX| $DE57
    .byte $BF ; |X XXXXXX| $DE58
    .byte $0E ; |    XXX | $DE59
    .byte $0E ; |    XXX | $DE5A
    .byte $0E ; |    XXX | $DE5B
    .byte $0E ; |    XXX | $DE5C
    .byte $0E ; |    XXX | $DE5D
LDE5E:
    .byte $FF ; |XXXXXXXX| $DE5E
    .byte $FF ; |XXXXXXXX| $DE5F
    .byte $FE ; |XXXXXXX | $DE60
    .byte $FC ; |XXXXXX  | $DE61
    .byte $FC ; |XXXXXX  | $DE62
    .byte $F8 ; |XXXXX   | $DE63
    .byte $F0 ; |XXXX    | $DE64
    .byte $F0 ; |XXXX    | $DE65
    .byte $E0 ; |XXX     | $DE66
    .byte $E0 ; |XXX     | $DE67
    .byte $C0 ; |XX      | $DE68
    .byte $C0 ; |XX      | $DE69
LDE6A:
    .byte ORANGE+2       ; $DE6A
    .byte ORANGE+2       ; $DE6B
    .byte ORANGE+4       ; $DE6C
    .byte PURPLE+6       ; $DE6D
    .byte PURPLE+6       ; $DE6E
    .byte PURPLE+6       ; $DE6F
    .byte PURPLE+6       ; $DE70
    .byte PURPLE+6       ; $DE71
    .byte PURPLE+10      ; $DE72
    .byte PURPLE+10      ; $DE73
    .byte ORANGE+4       ; $DE74
    .byte ORANGE+4       ; $DE75

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                 normal                                   inverted
;     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     ;
;     X XXX XXXXXXXXXXX       X X   XX     ;      X   X           XXXXXXX X XXX
;     X  XX X   X XXXXXXX XXXXXXX X XX     ;      XX  X XXX X       X       X X
;     X  X  X X X X X   X X   X X X XX     ;      XX XX X X X X XXX X XXX X X X
;     X  X  X X X X X X X XXX X X X XX     ;      XX XX X X X X X X X   X X X X
;     X     X X X X X X X X   X X X XX     ;      XXXXX X X X X X X X XXX X X X
;     X   X X X X X X X X X X X X X XX     ;      XXX X X X X X X X X X X X X X
;     X X X X X X X X X X X X X X X XX     ;      X X X X X X X X X X X X X X X
;     X X X X X X X X X X X   XXXXXXXX     ;      X X X X X X X X X X XXX
;     X X X X X X X X X X XXXXXXXXXXXX     ;      X X X X X X X X X X
;     X X X X X X X X XXXXXXXXXXXX XXX     ;      X X X X X X X X            X
;     X X X X X X   XXXXXXXXXXXXXX XXX     ;      X X X X X XXX              X
;     X X X X   XXXXXXXXXXXXXXXX X XXX     ;      X X X XXX                X X
;     X X X XXXXXXX   XXX   X XX X XXX     ;      X X X       XXX   XXX X  X X
;     X X X XXXXXXX XX X XX X XX X XXX     ;      X X X       X  X X  X X  X X
;     X X X XXXXXXX XX X    X XX X XXX     ;      X X X       X  X XXXX X  X X
;     X XXX XXXXXXX XX X XXXX XX X XXX     ;      X   X       X  X X    X  X X
;     XXXXXXXXXXXXX    X    X   X  XXX     ;                  XXXX XXXX XXX XX
;     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MountainDewOne:
    .byte $00 ; |        | $DE76
    .byte $00 ; |        | $DE77
    .byte $00 ; |        | $DE78
    .byte $FF ; |XXXXXXXX| $DE79
    .byte $FF ; |XXXXXXXX| $DE7A
    .byte $BB ; |X XXX XX| $DE7B
    .byte $AB ; |X X X XX| $DE7C
    .byte $AB ; |X X X XX| $DE7D
    .byte $AB ; |X X X XX| $DE7E
    .byte $AA ; |X X X X | $DE7F
    .byte $AA ; |X X X X | $DE80
    .byte $AA ; |X X X X | $DE81
    .byte $AA ; |X X X X | $DE82
    .byte $AA ; |X X X X | $DE83
    .byte $AA ; |X X X X | $DE84
    .byte $8A ; |X   X X | $DE85
    .byte $82 ; |X     X | $DE86
    .byte $92 ; |X  X  X | $DE87
    .byte $92 ; |X  X  X | $DE88
    .byte $9A ; |X  XX X | $DE89
    .byte $BB ; |X XXX XX| $DE8A
    .byte $FF ; |XXXXXXXX| $DE8B
MountainDewTwo:
    .byte $00 ; |        | $DE8C
    .byte $00 ; |        | $DE8D
    .byte $00 ; |        | $DE8E
    .byte $FF ; |XXXXXXXX| $DE8F
    .byte $F8 ; |XXXXX   | $DE90
    .byte $FB ; |XXXXX XX| $DE91
    .byte $FB ; |XXXXX XX| $DE92
    .byte $FB ; |XXXXX XX| $DE93
    .byte $F8 ; |XXXXX   | $DE94
    .byte $3F ; |  XXXXXX| $DE95
    .byte $A3 ; |X X   XX| $DE96
    .byte $AA ; |X X X X | $DE97
    .byte $AA ; |X X X X | $DE98
    .byte $AA ; |X X X X | $DE99
    .byte $AA ; |X X X X | $DE9A
    .byte $AA ; |X X X X | $DE9B
    .byte $AA ; |X X X X | $DE9C
    .byte $AA ; |X X X X | $DE9D
    .byte $AA ; |X X X X | $DE9E
    .byte $2F ; |  X XXXX| $DE9F
    .byte $FF ; |XXXXXXXX| $DEA0
    .byte $FF ; |XXXXXXXX| $DEA1
MountainDewThree:
    .byte $00 ; |        | $DEA2
    .byte $00 ; |        | $DEA3
    .byte $00 ; |        | $DEA4
    .byte $FF ; |XXXXXXXX| $DEA5
    .byte $42 ; | X    X | $DEA6
    .byte $5E ; | X XXXX | $DEA7
    .byte $42 ; | X    X | $DEA8
    .byte $5A ; | X XX X | $DEA9
    .byte $E2 ; |XXX   X | $DEAA
    .byte $FF ; |XXXXXXXX| $DEAB
    .byte $FF ; |XXXXXXXX| $DEAC
    .byte $FF ; |XXXXXXXX| $DEAD
    .byte $AF ; |X X XXXX| $DEAE
    .byte $A8 ; |X X X   | $DEAF
    .byte $AA ; |X X X X | $DEB0
    .byte $AA ; |X X X X | $DEB1
    .byte $A8 ; |X X X   | $DEB2
    .byte $AE ; |X X XXX | $DEB3
    .byte $28 ; |  X X   | $DEB4
    .byte $EF ; |XXX XXXX| $DEB5
    .byte $80 ; |X       | $DEB6
    .byte $FF ; |XXXXXXXX| $DEB7
MountainDewFour:
    .byte $00 ; |        | $DEB8
    .byte $00 ; |        | $DEB9
    .byte $00 ; |        | $DEBA
    .byte $FF ; |XXXXXXXX| $DEBB
    .byte $27 ; |  X  XXX| $DEBC
    .byte $D7 ; |XX X XXX| $DEBD
    .byte $D7 ; |XX X XXX| $DEBE
    .byte $D7 ; |XX X XXX| $DEBF
    .byte $D7 ; |XX X XXX| $DEC0
    .byte $D7 ; |XX X XXX| $DEC1
    .byte $F7 ; |XXXX XXX| $DEC2
    .byte $F7 ; |XXXX XXX| $DEC3
    .byte $FF ; |XXXXXXXX| $DEC4
    .byte $FF ; |XXXXXXXX| $DEC5
    .byte $AB ; |X X X XX| $DEC6
    .byte $AB ; |X X X XX| $DEC7
    .byte $AB ; |X X X XX| $DEC8
    .byte $AB ; |X X X XX| $DEC9
    .byte $AB ; |X X X XX| $DECA
    .byte $EB ; |XXX X XX| $DECB
    .byte $A3 ; |X X   XX| $DECC
    .byte $FF ; |XXXXXXXX| $DECD

LDECE:
    .byte $00 ; |        | $DECE
    .byte $00 ; |        | $DECF
    .byte $00 ; |        | $DED0
    .byte $FF ; |XXXXXXXX| $DED1
    .byte $FF ; |XXXXXXXX| $DED2
    .byte $FF ; |XXXXXXXX| $DED3
    .byte $FF ; |XXXXXXXX| $DED4
    .byte $FF ; |XXXXXXXX| $DED5
    .byte $FF ; |XXXXXXXX| $DED6
    .byte $FF ; |XXXXXXXX| $DED7
    .byte $FF ; |XXXXXXXX| $DED8
    .byte $C0 ; |XX      | $DED9
    .byte $80 ; |X       | $DEDA
    .byte $80 ; |X       | $DEDB
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
    .byte $FF ; |XXXXXXXX| $DEE7
    .byte $FF ; |XXXXXXXX| $DEE8
    .byte $FF ; |XXXXXXXX| $DEE9
    .byte $FF ; |XXXXXXXX| $DEEA
    .byte $FF ; |XXXXXXXX| $DEEB
    .byte $FF ; |XXXXXXXX| $DEEC
    .byte $FF ; |XXXXXXXX| $DEED
    .byte $FF ; |XXXXXXXX| $DEEE
    .byte $FF ; |XXXXXXXX| $DEEF
    .byte $FF ; |XXXXXXXX| $DEF0
    .byte $FF ; |XXXXXXXX| $DEF1
    .byte $FF ; |XXXXXXXX| $DEF2
    .byte $FF ; |XXXXXXXX| $DEF3
    .byte $FF ; |XXXXXXXX| $DEF4
    .byte $FF ; |XXXXXXXX| $DEF5
    .byte $FF ; |XXXXXXXX| $DEF6
    .byte $FF ; |XXXXXXXX| $DEF7
    .byte $FF ; |XXXXXXXX| $DEF8
    .byte $FF ; |XXXXXXXX| $DEF9
    .byte $FF ; |XXXXXXXX| $DEFA
    .byte $FF ; |XXXXXXXX| $DEFB
    .byte $FF ; |XXXXXXXX| $DEFC
    .byte $FF ; |XXXXXXXX| $DEFD
    .byte $FF ; |XXXXXXXX| $DEFE
    .byte $FF ; |XXXXXXXX| $DEFF

       ORG $0F00
      RORG $DF00

LDF00:
    .byte $05 ; |     X X| $DF00
LDF01:
    .byte $10 ; |   X    | $DF01
    .byte $05 ; |     X X| $DF02
    .byte $20 ; |  X     | $DF03
    .byte $05 ; |     X X| $DF04
    .byte $40 ; | X      | $DF05
    .byte $05 ; |     X X| $DF06
    .byte $80 ; |X       | $DF07
LDF08:
    .byte $00 ; |        | $DF08
LDF09:
    .byte $00 ; |        | $DF09
    .byte $00 ; |        | $DF0A
    .byte $40 ; | X      | $DF0B
    .byte $00 ; |        | $DF0C
    .byte $20 ; |  X     | $DF0D
    .byte $00 ; |        | $DF0E
    .byte $10 ; |   X    | $DF0F
    .byte $00 ; |        | $DF10
    .byte $08 ; |    X   | $DF11
    .byte $00 ; |        | $DF12
    .byte $04 ; |     X  | $DF13
    .byte $00 ; |        | $DF14
    .byte $02 ; |      X | $DF15
    .byte $00 ; |        | $DF16
    .byte $01 ; |       X| $DF17
    .byte $01 ; |       X| $DF18
    .byte $01 ; |       X| $DF19
    .byte $01 ; |       X| $DF1A
    .byte $02 ; |      X | $DF1B
    .byte $01 ; |       X| $DF1C
    .byte $04 ; |     X  | $DF1D
    .byte $01 ; |       X| $DF1E
    .byte $08 ; |    X   | $DF1F
    .byte $01 ; |       X| $DF20
    .byte $10 ; |   X    | $DF21
    .byte $01 ; |       X| $DF22
    .byte $20 ; |  X     | $DF23
    .byte $01 ; |       X| $DF24
    .byte $40 ; | X      | $DF25
    .byte $01 ; |       X| $DF26
    .byte $80 ; |X       | $DF27
    .byte $04 ; |     X  | $DF28
    .byte $10 ; |   X    | $DF29
    .byte $04 ; |     X  | $DF2A
    .byte $20 ; |  X     | $DF2B
    .byte $04 ; |     X  | $DF2C
    .byte $40 ; | X      | $DF2D
    .byte $04 ; |     X  | $DF2E
    .byte $80 ; |X       | $DF2F
    .byte $02 ; |      X | $DF30
    .byte $80 ; |X       | $DF31
    .byte $02 ; |      X | $DF32
    .byte $40 ; | X      | $DF33
    .byte $02 ; |      X | $DF34
    .byte $20 ; |  X     | $DF35
    .byte $02 ; |      X | $DF36
    .byte $10 ; |   X    | $DF37
    .byte $02 ; |      X | $DF38
    .byte $08 ; |    X   | $DF39
    .byte $02 ; |      X | $DF3A
    .byte $04 ; |     X  | $DF3B
    .byte $02 ; |      X | $DF3C
    .byte $02 ; |      X | $DF3D
    .byte $02 ; |      X | $DF3E
    .byte $01 ; |       X| $DF3F
    .byte $03 ; |      XX| $DF40
    .byte $01 ; |       X| $DF41
    .byte $03 ; |      XX| $DF42
    .byte $02 ; |      X | $DF43
    .byte $03 ; |      XX| $DF44
    .byte $04 ; |     X  | $DF45
    .byte $03 ; |      XX| $DF46
    .byte $08 ; |    X   | $DF47
    .byte $03 ; |      XX| $DF48
    .byte $10 ; |   X    | $DF49
    .byte $03 ; |      XX| $DF4A
    .byte $20 ; |  X     | $DF4B
    .byte $03 ; |      XX| $DF4C
    .byte $40 ; | X      | $DF4D
    .byte $03 ; |      XX| $DF4E
    .byte $80 ; |X       | $DF4F

LDF50:
    .byte $AB ; |X X X XX| $DF50
LDF51:
    .byte $05 ; |     X X| $DF51 << PF GFX

LDF52:
    .byte $2A ; |  X X X | $DF52
    .byte $00 ; |        | $DF53

LDF54:
    .byte ORANGE+2       ; $DF54
    .byte ORANGE+2       ; $DF55
    .byte ORANGE+4       ; $DF56
    .byte ORANGE+4       ; $DF57
    .byte ORANGE+2       ; $DF58
    .byte ORANGE+2       ; $DF59
    .byte ORANGE+4       ; $DF5A
    .byte ORANGE+4       ; $DF5B
    .byte ORANGE+2       ; $DF5C
    .byte ORANGE+2       ; $DF5D
    .byte ORANGE+4       ; $DF5E
    .byte ORANGE+4       ; $DF5F

    .byte $5B ; | X XX XX| $DF60
    .byte $01 ; |       X| $DF61 << PF GFX

    .byte $0A ; |    X X | $DF62
    .byte $00 ; |        | $DF63
LDF64:
    .byte $92 ; |X  X  X | $DF64
    .byte $92 ; |X  X  X | $DF65
    .byte $90 ; |X  X    | $DF66
    .byte $16 ; |   X XX | $DF67
    .byte $16 ; |   X XX | $DF68
    .byte $16 ; |   X XX | $DF69
    .byte $16 ; |   X XX | $DF6A
    .byte $0A ; |    X X | $DF6B
    .byte $0A ; |    X X | $DF6C
    .byte $0A ; |    X X | $DF6D
    .byte $96 ; |X  X XX | $DF6E
    .byte $96 ; |X  X XX | $DF6F
    .byte $67 ; | XX  XXX| $DF70
    .byte $00 ; |        | $DF71
    .byte $02 ; |      X | $DF72
    .byte $FF ; |XXXXXXXX| $DF73
LDF74:
    .byte $72 ; | XXX  X | $DF74
    .byte $74 ; | XXX X  | $DF75
    .byte $76 ; | XXX XX | $DF76
    .byte $00 ; |        | $DF77
    .byte $00 ; |        | $DF78
    .byte $00 ; |        | $DF79
    .byte $00 ; |        | $DF7A
    .byte $00 ; |        | $DF7B
    .byte $00 ; |        | $DF7C
    .byte $00 ; |        | $DF7D
    .byte $00 ; |        | $DF7E
    .byte $00 ; |        | $DF7F
    .byte $97 ; |X  X XXX| $DF80
    .byte $00 ; |        | $DF81 << GFX
    .byte $02 ; |      X | $DF82
LDF83:
    .byte $00 ; |        | $DF83
    .byte $81 ; |X      X| $DF84
    .byte $81 ; |X      X| $DF85
    .byte $81 ; |X      X| $DF86
    .byte $C3 ; |XX    XX| $DF87
    .byte $C3 ; |XX    XX| $DF88
    .byte $E7 ; |XXX  XXX| $DF89
    .byte $FF ; |XXXXXXXX| $DF8A

LDF8B:
    .byte ORANGE+3       ; $DF8B
    .byte ORANGE+3       ; $DF8C
    .byte ORANGE+3       ; $DF8D
    .byte ORANGE+3       ; $DF8E
    .byte ORANGE+3       ; $DF8F
    .byte ORANGE+3       ; $DF90
    .byte ORANGE+3       ; $DF91
    .byte ORANGE+2       ; $DF92
    .byte ORANGE+2       ; $DF93
    .byte ORANGE+2       ; $DF94
    .byte ORANGE+2       ; $DF95
    .byte ORANGE+2       ; $DF96
    .byte ORANGE         ; $DF97
LDF98:
    .byte $E0 ; |XXX     | $DF98
    .byte $F0 ; |XXXX    | $DF99
    .byte $F8 ; |XXXXX   | $DF9A
    .byte $FC ; |XXXXXX  | $DF9B
    .byte $FE ; |XXXXXXX | $DF9C
    .byte $FE ; |XXXXXXX | $DF9D
    .byte $FE ; |XXXXXXX | $DF9E
    .byte $FE ; |XXXXXXX | $DF9F
    .byte $FC ; |XXXXXX  | $DFA0
    .byte $F8 ; |XXXXX   | $DFA1
    .byte $F0 ; |XXXX    | $DFA2
    .byte $E0 ; |XXX     | $DFA3

LDFA4:
    .byte BLUE_CYAN+2    ; $DFA4
    .byte BLUE_CYAN+2    ; $DFA5
    .byte BLUE_CYAN+2    ; $DFA6
    .byte BLUE_CYAN+2    ; $DFA7
    .byte BLUE_CYAN+4    ; $DFA8
    .byte BLUE_CYAN+4    ; $DFA9
    .byte BLUE_CYAN+4    ; $DFAA
    .byte BLUE_CYAN+4    ; $DFAB
    .byte BLUE_CYAN+6    ; $DFAC
    .byte BLUE_CYAN+6    ; $DFAD
    .byte BLUE_CYAN+6    ; $DFAE
    .byte BLUE_CYAN+6    ; $DFAF

    .byte $07 ; |     XXX| $DFB0
    .byte $07 ; |     XXX| $DFB1
    .byte $0F ; |    XXXX| $DFB2
    .byte $0F ; |    XXXX| $DFB3
    .byte $1F ; |   XXXXX| $DFB4
    .byte $1F ; |   XXXXX| $DFB5
    .byte $3F ; |  XXXXXX| $DFB6
    .byte $37 ; |  XX XXX| $DFB7
    .byte $77 ; | XXX XXX| $DFB8
    .byte $77 ; | XXX XXX| $DFB9
    .byte $E7 ; |XXX  XXX| $DFBA
    .byte $E7 ; |XXX  XXX| $DFBB

;indirect jumps
LDFBC:
    .byte  <LD807        ; $DFBC   $D8
    .byte  <LD83B        ; $DFBD
    .byte  <LD807        ; $DFBE
    .byte  <LD83B        ; $DFBF
    .byte  <LD86E        ; $DFC0
LDFC1:
    .byte  <LD204        ; $DFC1   $D2
    .byte  <LD239        ; $DFC2
    .byte  <LD204        ; $DFC3
    .byte  <LD239        ; $DFC4
    .byte  <LD26E        ; $DFC5
    .byte  <LD26E        ; $DFC6
LDFC7:
    .byte  <LD606        ; $DFC7   $D6
    .byte  <LD63A        ; $DFC8
    .byte  <LD606        ; $DFC9
    .byte  <LD63A        ; $DFCA
    .byte  <LD671        ; $DFCB
LDFCC:
    .byte  <LD900        ; $DFCC   $D9
    .byte  <LD934        ; $DFCD
    .byte  <LD900        ; $DFCE
    .byte  <LD934        ; $DFCF
    .byte  <LD969        ; $DFD0

    .byte $FF ; |XXXXXXXX| $DFD1
    .byte $FF ; |XXXXXXXX| $DFD2
    .byte $FF ; |XXXXXXXX| $DFD3
    .byte $FF ; |XXXXXXXX| $DFD4
    .byte $FF ; |XXXXXXXX| $DFD5
    .byte $FF ; |XXXXXXXX| $DFD6
    .byte $FF ; |XXXXXXXX| $DFD7
    .byte $FF ; |XXXXXXXX| $DFD8
    .byte $FF ; |XXXXXXXX| $DFD9
    .byte $FF ; |XXXXXXXX| $DFDA
    .byte $FF ; |XXXXXXXX| $DFDB
    .byte $FF ; |XXXXXXXX| $DFDC
    .byte $FF ; |XXXXXXXX| $DFDD
    .byte $FF ; |XXXXXXXX| $DFDE
    .byte $FF ; |XXXXXXXX| $DFDF
    .byte $FF ; |XXXXXXXX| $DFE0
    .byte $FF ; |XXXXXXXX| $DFE1
    .byte $FF ; |XXXXXXXX| $DFE2
    .byte $FF ; |XXXXXXXX| $DFE3
    .byte $FF ; |XXXXXXXX| $DFE4
    .byte $FF ; |XXXXXXXX| $DFE5
    .byte $FF ; |XXXXXXXX| $DFE6
    .byte $FF ; |XXXXXXXX| $DFE7
    .byte $FF ; |XXXXXXXX| $DFE8
    .byte $FF ; |XXXXXXXX| $DFE9
    .byte $FF ; |XXXXXXXX| $DFEA
    .byte $FF ; |XXXXXXXX| $DFEB
    .byte $FF ; |XXXXXXXX| $DFEC
    .byte $FF ; |XXXXXXXX| $DFED
    .byte $FF ; |XXXXXXXX| $DFEE
    .byte $FF ; |XXXXXXXX| $DFEF
    .byte $FF ; |XXXXXXXX| $DFF0
    .byte $FF ; |XXXXXXXX| $DFF1
    .byte $FF ; |XXXXXXXX| $DFF2
    .byte $FF ; |XXXXXXXX| $DFF3
    .byte $FF ; |XXXXXXXX| $DFF4
    .byte $FF ; |XXXXXXXX| $DFF5
    .byte $FF ; |XXXXXXXX| $DFF6
    .byte $FF ; |XXXXXXXX| $DFF7

       ORG $0FF8
      RORG $DFF8

    .byte $FF ; |XXXXXXXX| $DFF8
    .byte $FF ; |XXXXXXXX| $DFF9

    .word START,START,START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      SECOND BANK
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ORG $1000
       RORG $F000

LF000:
    ldx    #0                    ; 2
    cld                          ; 2
    sei                          ; 2
    txa                          ; 2
.loopClear:
    sta    0,X                   ; 4
    inx                          ; 2
    bne    .loopClear            ; 2�

    dec    $82                   ; 5
LF00C:
    lda    $85                   ; 3
    and    #$1F                  ; 2
    asl                          ; 2
    sta    $8D                   ; 3
    lda    #$10                  ; 2
    sta    $D6                   ; 3
    and    $8E                   ; 3
    adc    #$10                  ; 2
    adc    $8D                   ; 3
    sta    $8D                   ; 3
    ldx    #$FF                  ; 2
    txs                          ; 2
    lda    $85                   ; 3
    and    #$0F                  ; 2
    tay                          ; 2
    lda    LFDB1,Y               ; 4
    sta    $D1                   ; 3
    beq    LF07D                 ; 2�
    inx                          ; 2
    lsr                          ; 2
    bcs    LF03B                 ; 2�
    inx                          ; 2
    bit    $D1                   ; 3
    bpl    LF03B                 ; 2�
    inx                          ; 2
    bvc    LF03B                 ; 2�
    inx                          ; 2
LF03B:
    stx    $D2                   ; 3
    ldy    LFD50,X               ; 4
    sty    $D0                   ; 3
    ldy    LFDD0,X               ; 4
    ldx    #$0E                  ; 2
    stx    $F8                   ; 3
    lda    #$B4                  ; 2
    sta    $D4                   ; 3
    ldx    #$DC                  ; 2
    stx    $99                   ; 3
    stx    $B9                   ; 3
    inx                          ; 2
    stx    $A9                   ; 3
    stx    $C9                   ; 3
    lda    #$30                  ; 2
    sec                          ; 2
LF05B:
    tax                          ; 2
    sty    $98,X                 ; 4
    lda    #0                    ; 2
    sta    $9C,X                 ; 4
    sta    $91,X                 ; 4
    sta    $90,X                 ; 4
    sta    $9D,X                 ; 4
    sta    $9E,X                 ; 4
    lda    #$DE                  ; 2
    sta    $9F,X                 ; 4
    lda    #$BD                  ; 2
    sta    $92,X                 ; 4
    txa                          ; 2
    sbc    #$10                  ; 2
    bpl    LF05B                 ; 2�
    lda    #$7E                  ; 2
    sta    $8F                   ; 3
    bne    LF0A6                 ; 3   always branch

LF07D:
    ldy    #9                    ; 2
    sty    $F8                   ; 3
    asl    $8D                   ; 5
    lda    #0                    ; 2
    sta    $90                   ; 3
    sta    $91                   ; 3
    beq    LF091                 ; 3   always branch

    jsr    LFB53                 ; 6   unused code?
    jsr    LF7FD                 ; 6
LF091:
    jsr    LF549                 ; 6
    jsr    LF9C1                 ; 6
    ldx    #<LD8E1               ; 2
    ldy    #>LD8E1               ; 2
    bne    LF0BB                 ; 3   always branch

LF09D:
    jsr    LFB53                 ; 6
    jsr    LF7FD                 ; 6
    jsr    LF127                 ; 6
LF0A6:
    jsr    LF9C1                 ; 6
    lda    #$20                  ; 2
    sta    CTRLPF                ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMCLR                 ; 3
    ldx    #0                    ; 2
    stx    NUSIZ0                ; 3
    lda    $D0                   ; 3
    sta    COLUBK                ; 3
    ldy    #>LD000               ; 2
LF0BB:
    stx    $FE                   ; 3
    sty    $FF                   ; 3
    lda    #$2C                  ; 2   BIT opcode
    sta    $FA                   ; 3
    lda    #<LFFF8               ; 2
    sta    $FB                   ; 3
    ldx    #>LFFF8               ; 2
    txs                          ; 2
    stx    $FC                   ; 3
    lda    #$4C                  ; 2   JMP opcode
    sta    $FD                   ; 3
    jmp.w  $FA                   ; 3

LF0D3:
    ldy    #$0F                  ; 2
    sty    $F8                   ; 3
    ldy    $92,X                 ; 4
    cpy    #$28                  ; 2
    bcs    LF0E4                 ; 2�
    iny                          ; 2
    asl                          ; 2
    beq    LF0E2                 ; 2�
    iny                          ; 2
LF0E2:
    sty    $92,X                 ; 4
LF0E4:
    asl                          ; 2
    beq    LF0FB                 ; 2�
    lda    $CE                   ; 3
    sbc    #$17                  ; 2
    bcs    LF0F9                 ; 2�
    lda    $98,X                 ; 4
    sbc    #$3B                  ; 2
    bcs    LF0F5                 ; 2�
    sbc    #$0F                  ; 2
LF0F5:
    sta    $98,X                 ; 4
    lda    #$84                  ; 2
LF0F9:
    sta    $CE                   ; 3
LF0FB:
    lda    #$FF                  ; 2
    sta    $AF                   ; 3
    rts                          ; 6

LF100:
    lda    $85                   ; 3
    sec                          ; 2
    ora    $89                   ; 3
    ldy    $8E                   ; 3
    bpl    LF10F                 ; 2�
    cmp    #$20                  ; 2
    bcs    LF10F                 ; 2�
    inx                          ; 2
    inx                          ; 2
LF10F:
    dex                          ; 2
    stx    $AE                   ; 3
    bne    LF123                 ; 2�
    bcs    LF124                 ; 2�
    lda    $8E                   ; 3
    and    #$7F                  ; 2
    sta    $8E                   ; 3
    ldx    #8                    ; 2
LF11E:
    dex                          ; 2
    stx    $BE                   ; 3
    beq    LF124                 ; 2�
LF123:
    rts                          ; 6

LF124:
    jmp    LF00C                 ; 3

LF127:
    lda    $8F                   ; 3
    bne    LF0FB                 ; 2�+1
    ldx    $AE                   ; 3
    bne    LF100                 ; 2�
    ldx    $BE                   ; 3
    beq    LF138                 ; 2�
    lda    $8C                   ; 3
    beq    LF11E                 ; 2�
    rts                          ; 6

LF138:
    ldy    $D4                   ; 3
    cpy    #$B4                  ; 2
    beq    LF156                 ; 2�
    cpy    #$A0                  ; 2
    bcc    LF148                 ; 2�
    ldy    #$0C                  ; 2
    sty    $F8                   ; 3
    ldy    #<MugBreaking-1       ; 2
LF148:
    iny                          ; 2
    sty    $D4                   ; 3
    dec    $CF                   ; 5
    lda    $CF                   ; 3
    beq    LF188                 ; 2�
    cmp    #$20                  ; 2
    bcc    LF0FB                 ; 2�+1
    rts                          ; 6

LF156:
    ldx    $BF                   ; 3
    bmi    LF1A8                 ; 2�
    inc    $CF                   ; 5
    bpl    LF170                 ; 2�
    lda    $CF                   ; 3
    and    #$03                  ; 2
    bne    LF0FB                 ; 2�+1
    lda    $D6                   ; 3
    eor    #$01                  ; 2
    sta    $D6                   ; 3
    lda    #6                    ; 2
    sta    $EF                   ; 3
    bpl    LF0FB                 ; 3+1   always branch

LF170:
    bne    LF175                 ; 2�
    dec    $BF                   ; 5
    dex                          ; 2
LF175:
    ldy    $97,X                 ; 4
    iny                          ; 2
    lda    $8C                   ; 3
    and    #$01                  ; 2
    beq    LF17F                 ; 2�
    iny                          ; 2
LF17F:
    sty    $97,X                 ; 4
    cpy    #$88                  ; 2
    bcs    LF188                 ; 2�
    jmp    LF0D3                 ; 3

LF188:
    ldx    $89                   ; 3
    lda    $85                   ; 3
    sec                          ; 2
    sbc    #$20                  ; 2
    bcs    LF19A                 ; 2�
    adc    #$21                  ; 2
    sta    $85                   ; 3
    lda    $8E                   ; 3
    lsr                          ; 2
    bpl    LF19E                 ; 3   always branch

LF19A:
    sta    $85                   ; 3
    cpx    #$20                  ; 2
LF19E:
    bcc    LF1A3                 ; 2�
    jsr    LFACA                 ; 6
LF1A3:
    lda    #8                    ; 2
    sta    $AE                   ; 3
    rts                          ; 6

LF1A8:
    lda    #2                    ; 2
    ldx    $D0                   ; 3
    bne    LF1AF                 ; 2�
    asl                          ; 2
LF1AF:
    sta    $EC                   ; 3
    lda    $85                   ; 3
    and    #$1F                  ; 2
    cmp    #9                    ; 2
    ldy    #$FF                  ; 2
    bcs    LF1BF                 ; 2�
    tax                          ; 2
    ldy    LFF10,X               ; 4
LF1BF:
    sty    $FA                   ; 3
    ldx    $D6                   ; 3
    lda    LFF19,X               ; 4
    and    $D1                   ; 3
    beq    LF1CC                 ; 2�
    lda    #$FF                  ; 2
LF1CC:
    sta    $D7                   ; 3
    dec    $CF                   ; 5
    beq    LF1D6                 ; 2�
    ldy    $81                   ; 3
    bne    LF1F7                 ; 2�
LF1D6:
    lda    $80                   ; 3
    ldy    #$78                  ; 2
    lsr                          ; 2
    bcs    LF1F1                 ; 2�
    cpy    $CE                   ; 3
    beq    LF1E9                 ; 2�
    ldy    #0                    ; 2
    cmp    #$78                  ; 2
    bcs    LF1F5                 ; 2�
    bcc    LF1F7                 ; 3   always branch

LF1E9:
    ldy    #$20                  ; 2
    sty    $CF                   ; 3
    sty    $BD                   ; 3
    ldy    #$60                  ; 2
LF1F1:
    lda    #0                    ; 2
    sta    $CD                   ; 3
LF1F5:
    sty    $CE                   ; 3
LF1F7:
    ldy    $CD                   ; 3
    bne    LF200                 ; 2�+1
    lda    $96,X                 ; 4
    lsr                          ; 2
    bcs    LF240                 ; 2�
LF200:
    lda    $90,X                 ; 4
    bmi    LF240                 ; 2�
    lda    $D7                   ; 3
    beq    LF212                 ; 2�
    bit    $80                   ; 3
    bvc    LF220                 ; 2�
    bmi    LF240                 ; 2�
    inc    $D7                   ; 5
    bpl    LF21A                 ; 2�
LF212:
    bit    $80                   ; 3
    bpl    LF220                 ; 2�
    bvs    LF240                 ; 2�
    dec    $D7                   ; 5
LF21A:
    tya                          ; 2
    beq    LF26C                 ; 2�
    dey                          ; 2
    bpl    LF225                 ; 2�
LF220:
    cpy    #$70                  ; 2
    bcs    LF26C                 ; 2�
    iny                          ; 2
LF225:
    lda    $8C                   ; 3
    and    #$07                  ; 2
    bne    LF26C                 ; 2�
    lda    #3                    ; 2
    sta    $EF                   ; 3
    lda    $CE                   ; 3
    clc                          ; 2
    adc    #$18                  ; 2
    cmp    #$49                  ; 2
    bcc    LF23C                 ; 2�
    inc    $EF                   ; 5
    lda    #$18                  ; 2
LF23C:
    sta    $CE                   ; 3
    bne    LF26C                 ; 2�
LF240:
    lda    $81                   ; 3
    bne    LF270                 ; 2�
    lda    $80                   ; 3
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    bpl    LF251                 ; 2�
    bcs    LF270                 ; 2�
    lda    #$F8                  ; 2
    bne    LF253                 ; 3   always branch

LF251:
    lda    #$18                  ; 2
LF253:
    adc    $D6                   ; 3
    and    #$30                  ; 2
    sta    $D6                   ; 3
    stx    $AF                   ; 3
    sty    $D5                   ; 3
    inc    $EF                   ; 5
    ldx    $D6                   ; 3
    ldy    #0                    ; 2
    sty    $CE                   ; 3
    lda    #$18                  ; 2
    sta    $81                   ; 3
    lsr                          ; 2
    sta    $CF                   ; 3
LF26C:
    lda    #0                    ; 2
    sta    $BD                   ; 3
LF270:
    sty    $CD                   ; 3
    tya                          ; 2
    beq    LF27B                 ; 2�
    clc                          ; 2
    adc    LFF1A,X               ; 4
    sta    $97,X                 ; 4
LF27B:
    lda    $9C,X                 ; 4
    beq    LF286                 ; 2�
    lsr                          ; 2
    bcs    LF2A2                 ; 2�
    cmp    #$0C                  ; 2
    bcc    LF2A2                 ; 2�
LF286:
    lda    $BD                   ; 3
    beq    LF2A2                 ; 2�
    lda    $96,X                 ; 4
    lsr                          ; 2
    bcs    LF2A2                 ; 2�
    lda    $91,X                 ; 4
    bne    LF2A2                 ; 2�
    sta    $CD                   ; 3
    sta    $BD                   ; 3
    lda    LFF1C,X               ; 4
    ora    #$01                  ; 2
    sta    $91,X                 ; 4
    lda    #2                    ; 2
    sta    $EF                   ; 3
LF2A2:
    ldx    #$30                  ; 2
LF2A4:
    ldy    $9C,X                 ; 4
    bne    LF2AF                 ; 2�
    tya                          ; 2
    ldy    $91,X                 ; 4
    sta    $91,X                 ; 4
    beq    LF320                 ; 2�+1
LF2AF:
    bpl    LF2B9                 ; 2�
    lda    $8C                   ; 3
    jsr    LF7B0                 ; 6
    jmp    LF2E1                 ; 3

LF2B9:
    lda    $90,X                 ; 4
    bmi    LF2E1                 ; 2�
    tya                          ; 2
    asl                          ; 2
    sbc    #$10                  ; 2
    bcc    LF2E1                 ; 2�
    sbc    $92,X                 ; 4
    bcc    LF2E1                 ; 2�
    cpx    $D6                   ; 3
    bne    LF2DF                 ; 2�
    lda    $CD                   ; 3
    beq    LF2DF                 ; 2�
    inc    $92,X                 ; 6
    inc    $92,X                 ; 6
    lda    $92,X                 ; 4
    cmp    #$40                  ; 2
    bcc    LF2E1                 ; 2�
    tya                          ; 2
    eor    #$FF                  ; 2
    tay                          ; 2
    bne    LF2E1                 ; 3   always branch

LF2DF:
    inc    $90,X                 ; 6
LF2E1:
    iny                          ; 2
    cpy    #$47                  ; 2
    bne    LF320                 ; 2�+1
    ldy    #0                    ; 2
    lda    $90,X                 ; 4
    bne    LF2F8                 ; 2�
    cpx    $D6                   ; 3
    beq    LF2F5                 ; 2�
    sty    $9C,X                 ; 4
    lda    #$8A                  ; 2
    clc                          ; 2
LF2F5:
    jmp    LF7D5                 ; 3

LF2F8:
    dec    $9D                   ; 5
    lda    #0                    ; 2
    sta    $90,X                 ; 4
    sta    $9B,X                 ; 4
    lda    $92                   ; 3
    and    $A2                   ; 3
    and    $B2                   ; 3
    and    $C2                   ; 3
    bpl    LF320                 ; 2�
    lda    $90                   ; 3
    ora    $A0                   ; 3
    ora    $B0                   ; 3
    ora    $C0                   ; 3
    bne    LF320                 ; 2�
    inc    $85                   ; 5
    lda    #$10                  ; 2
    sta    $AD                   ; 3
    dec    $8F                   ; 5
    lsr                          ; 2
    sta    $F8                   ; 3
    rts                          ; 6

LF320:
    sty    $9C,X                 ; 4
    tya                          ; 2
    asl                          ; 2
    lda    $91,X                 ; 4
    beq    LF34F                 ; 2�
    bmi    LF346                 ; 2�
    inc    $91,X                 ; 6
    bmi    LF34F                 ; 2�
    bcc    LF335                 ; 2�
    sta    $9C,X                 ; 4
    sty    $91,X                 ; 4
    tya                          ; 2
LF335:
    asl                          ; 2
    sec                          ; 2
    sbc    #$10                  ; 2
    bcc    LF34F                 ; 2�
    cmp    $92,X                 ; 4
    bcc    LF34F                 ; 2�
    inc    $92,X                 ; 6
    inc    $92,X                 ; 6
LF343:
    jmp    LF40A                 ; 3

LF346:
    tya                          ; 2
    ldy    $91,X                 ; 4
    jsr    LF7B0                 ; 6
    iny                          ; 2
    sty    $91,X                 ; 4
LF34F:
    ldy    $92,X                 ; 4
    bmi    LF388                 ; 2�
    lda    $90,X                 ; 4
    bne    LF343                 ; 2�
    txa                          ; 2
    adc    $8A                   ; 3
    cmp    $8D                   ; 3
    bne    LF360                 ; 2�
    inc    $8D                   ; 5
LF360:
    bcs    LF343                 ; 2�
    tya                          ; 2
    cmp    LFF1B,X               ; 4
    beq    LF36C                 ; 2�
    dey                          ; 2
LF369:
    jmp    LF3F7                 ; 3

LF36C:
    lda    $96,X                 ; 4
    lsr                          ; 2
    bcs    LF369                 ; 2�
    lda    LFF1A,X               ; 4
    adc    #$10                  ; 2
    sta    $97,X                 ; 4
    lda    #$D0                  ; 2
    sta    $CF                   ; 3
    lda    #$F0                  ; 2
    sta    $9A,X                 ; 4
    inx                          ; 2
    stx    $BF                   ; 3
    lda    #$0A                  ; 2
    sta    $F8                   ; 3
    rts                          ; 6

LF388:
    lda    $D0                   ; 3
    sta    $93,X                 ; 4
    sta    $94,X                 ; 4
    sta    $95,X                 ; 4
    txa                          ; 2
    adc    $8A                   ; 3
    asl                          ; 2
    asl                          ; 2
    and    #$F0                  ; 2
    ora    $EC                   ; 3
    sta    $93,X                 ; 4
    bit    $FA                   ; 3
    bpl    LF3A7                 ; 2�
    adc    $8A                   ; 3
    and    #$F0                  ; 2
    ora    $EC                   ; 3
    sta    $94,X                 ; 4
LF3A7:
    bit    $FA                   ; 3
    bvc    LF3B4                 ; 2�
    txa                          ; 2
    adc    $8A                   ; 3
    and    #$F0                  ; 2
    ora    $EC                   ; 3
    sta    $95,X                 ; 4
LF3B4:
    lda    $90,X                 ; 4
    bne    LF3BE                 ; 2�
    lda    $99,X                 ; 4
    eor    #$01                  ; 2
    sta    $99,X                 ; 4
LF3BE:
    cpy    #$BD                  ; 2
    beq    LF3CA                 ; 2�
    bit    $D3                   ; 3
    bmi    LF3D6                 ; 2�
    inc    $9B,X                 ; 6
    bne    LF3D6                 ; 2�
LF3CA:
    lda    $9C,X                 ; 4
    beq    LF3D2                 ; 2�
    cmp    #$20                  ; 2
    bcc    LF3F7                 ; 2�
LF3D2:
    lda    #$0E                  ; 2
    bcs    LF3DC                 ; 2�
LF3D6:
    cpx    $8C                   ; 3
    bne    LF3F5                 ; 2�
    lda    #$8E                  ; 2
LF3DC:
    and    $8A                   ; 3
    adc    #$59                  ; 2
    tay                          ; 2
    bmi    LF3E7                 ; 2�
    lda    #6                    ; 2
    sta    $EF                   ; 3
LF3E7:
    cpx    $D6                   ; 3
    bne    LF3EF                 ; 2�
    lda    $BD                   ; 3
    bne    LF3F5                 ; 2�
LF3EF:
    lda    $91,X                 ; 4
    beq    LF3F7                 ; 2�
    bmi    LF3F7                 ; 2�
LF3F5:
    ldy    #$FF                  ; 2
LF3F7:
    sty    $92,X                 ; 4
    lda    $90,X                 ; 4
    bmi    LF40A                 ; 2�+1
    lda    $98,X                 ; 4
    sta    $9A,X                 ; 4
    sec                          ; 2
    sbc    #$3C                  ; 2   finding next gfx ptr, skip over 4 sets of gfx and 1 table of colors (12 bytes x5) = 60 or $3C
    bcs    LF408                 ; 2�
    sbc    #$0F                  ; 2   adjust for wrap around
LF408:
    sta    $98,X                 ; 4
LF40A:
    cpx    $D6                   ; 3
    beq    LF41C                 ; 2�
    cpx    $AF                   ; 3
    bne    LF426                 ; 2�
    lda    $CF                   ; 3
    bpl    LF418                 ; 2�
    inc    $AF                   ; 5
LF418:
    lda    $D5                   ; 3
    bcs    LF41E                 ; 2�
LF41C:
    lda    $CD                   ; 3
LF41E:
    beq    LF426                 ; 2�
    lda    #$F0                  ; 2
    sta    $9A,X                 ; 4
    bne    LF498                 ; 3   always branch

LF426:
    lda    $90,X                 ; 4
    bmi    LF467                 ; 2�
    beq    LF4A7                 ; 2�
    lda    #5                    ; 2
    sta    $EF                   ; 3
    lda    #$80                  ; 2
    sta    $90,X                 ; 4
    lda    $93,X                 ; 4
    sta    $96,X                 ; 4
    lda    $98,X                 ; 4
    sta    $9A,X                 ; 4
    lda    $94,X                 ; 4
    cmp    $D0                   ; 3
    beq    LF44C                 ; 2�
    sta    $93,X                 ; 4
    lda    $95,X                 ; 4
    sta    $94,X                 ; 4
    lda    #$10                  ; 2
    bne    LF45E                 ; 3   always branch

LF44C:
    lda    $95,X                 ; 4
    cmp    $D0                   ; 3
    bne    LF45A                 ; 2�
    lda    #0                    ; 2
    sta    $9B,X                 ; 4
    lda    #$C0                  ; 2
    bne    LF461                 ; 3   always branch

LF45A:
    sta    $93,X                 ; 4
    lda    #$20                  ; 2
LF45E:
    clc                          ; 2
    adc    $92,X                 ; 4
LF461:
    sta    $92,X                 ; 4
    lda    $D0                   ; 3
    sta    $95,X                 ; 4
LF467:
    lda    $91,X                 ; 4
    bmi    LF487                 ; 2�
    lda    $92,X                 ; 4
    cmp    #$4E                  ; 2
    bcs    LF487                 ; 2�
    adc    #$30                  ; 2
    lsr                          ; 2
    sec                          ; 2
    sbc    $9C,X                 ; 4
    bne    LF487                 ; 2�
    sta    $90,X                 ; 4
    lda    $9C,X                 ; 4
    eor    #$FF                  ; 2
    sta    $9C,X                 ; 4
    lda    $96,X                 ; 4
    sta    $95,X                 ; 4
    bcs    LF490                 ; 2�
LF487:
    lda    $9C,X                 ; 4
    asl                          ; 2
    adc    #3                    ; 2
    cmp    #$8E                  ; 2
    bcc    LF496                 ; 2�
LF490:
    lda    $D0                   ; 3
    sta    $96,X                 ; 4
    lda    #0                    ; 2
LF496:
    sta    $97,X                 ; 4
LF498:
    txa                          ; 2
    sec                          ; 2
    sbc    #$10                  ; 2
    tax                          ; 2
    bmi    LF4A6                 ; 2�
    asl    $FA                   ; 5
    asl    $FA                   ; 5
    jmp    LF2A4                 ; 3

LF4A6:
    rts                          ; 6

LF4A7:
    lda    #$FF                  ; 2
    cpx    $D6                   ; 3
    beq    LF4B1                 ; 2�
    lda    $9C,X                 ; 4
    ora    $91,X                 ; 4
LF4B1:
    sta    $FD                   ; 3
    lda    $92,X                 ; 4
    bmi    LF490                 ; 2�
    inc    $9B,X                 ; 6
    cmp    #$59                  ; 2
    bcs    LF4CE                 ; 2�
    cmp    #$54                  ; 2
    lda    #$FF                  ; 2
    bcc    LF4C5                 ; 2�
    lda    #$DF                  ; 2
LF4C5:
    and    $9B,X                 ; 4
    sta    $9B,X                 ; 4
    and    #$20                  ; 2
    jmp    LF4F5                 ; 3

LF4CE:
    tay                          ; 2
    lda    $95,X                 ; 4
    cmp    $D0                   ; 3
    beq    LF490                 ; 2�
    sta    $96,X                 ; 4
    lda    $9B,X                 ; 4
    and    #$1E                  ; 2
    bne    LF4E6                 ; 2�
    ldy    $FD                   ; 3
    beq    LF4E6                 ; 2�
    dec    $9B,X                 ; 6
    jmp    LF490                 ; 3

LF4E6:
    cmp    #$10                  ; 2
    bcc    LF4EC                 ; 2�
    eor    #$1E                  ; 2
LF4EC:
    lsr                          ; 2
    lsr                          ; 2
    eor    #$FF                  ; 2
    clc                          ; 2
    adc    #$8C                  ; 2
    bne    LF546                 ; 2�+1
LF4F5:
    lsr                          ; 2
    sta    $FC                   ; 3
    beq    LF4FB                 ; 2�
    sec                          ; 2
LF4FB:
    txa                          ; 2
    adc    #0                    ; 2
    tay                          ; 2
    lda    $96,X                 ; 4
    lsr                          ; 2
    lda    $9B,X                 ; 4
    and    #$1F                  ; 2
    bne    LF523                 ; 2�
    lda    $FD                   ; 3
    beq    LF50F                 ; 2�
LF50C:
    jmp    LF490                 ; 3

LF50F:
    lda.wy $94,Y                 ; 4
    cmp    $D0                   ; 3
    beq    LF50C                 ; 2�
    ora    #$01                  ; 2
    sta    $96,X                 ; 4
    lda    $D0                   ; 3
    sta.wy $94,Y                 ; 5
    lda    #0                    ; 2
    beq    LF53E                 ; 3   always branch

LF523:
    bcc    LF50C                 ; 2�
    cmp    #$10                  ; 2
    bcc    LF53E                 ; 2�
    eor    #$1F                  ; 2
    bne    LF53E                 ; 2�
    lda    $96,X                 ; 4
    lsr                          ; 2
    bcc    LF50C                 ; 2�
    asl                          ; 2
    sta.wy $94,Y                 ; 5
    lda    $8A                   ; 3
    ora    #$1F                  ; 2
    sta    $9B,X                 ; 4
    bcc    LF50C                 ; 3   always branch

LF53E:
    lsr                          ; 2
    clc                          ; 2
    adc    #$23                  ; 2
    adc    $FC                   ; 3
    adc    $92,X                 ; 4
LF546:
    jmp    LF496                 ; 3

LF549:
    lda    #$DB                  ; 2
    sta    $B1                   ; 3
    sta    $B3                   ; 3
    sta    $B5                   ; 3
    sta    $A1                   ; 3
    sta    $A3                   ; 3
    lda    #$F0                  ; 2
    sta    $A5                   ; 3
    lda    $D3                   ; 3
    lsr                          ; 2
    sta    $A4                   ; 3
    lda    #6                    ; 2
    sta    $D8                   ; 3
    lda    #$66                  ; 2
    sta    $D9                   ; 3
    sta    $DA                   ; 3
    sta    $DB                   ; 3
    lda    #$C3                  ; 2
    sta    $98                   ; 3
    lda    #$43                  ; 2
    sta    $9A                   ; 3
    lda    #$40                  ; 2
    sta    $C0                   ; 3
    lda    #0                    ; 2
    sta    $97                   ; 3
    sta    $9C                   ; 3
    lda    $90                   ; 3
    and    #$3F                  ; 2
    tax                          ; 2
    ldy    $91                   ; 3
    bne    LF5AE                 ; 2�
    inc    $90                   ; 5
    inx                          ; 2
    lda    $8A                   ; 3
LF58A:
    sbc    #$60                  ; 2
    bcs    LF58A                 ; 2�
    adc    #$60                  ; 2
    and    #$70                  ; 2
    sta    $96                   ; 3
    cpx    #$0F                  ; 2
    bcc    LF5AB                 ; 2�
    lda    $85                   ; 3
    tax                          ; 2
    eor    #$1F                  ; 2
    and    #$1F                  ; 2
    bne    LF5A5                 ; 2�
    txa                          ; 2
    and    #$EF                  ; 2
    tax                          ; 2
LF5A5:
    inx                          ; 2
    stx    $85                   ; 3
    jmp    LF00C                 ; 3

LF5AB:
    ldy    LFF9F,X               ; 4
LF5AE:
    dey                          ; 2
    sty    $91                   ; 3
    bit    $90                   ; 3
    bvc    LF5B8                 ; 2�
    jmp    LF652                 ; 3

LF5B8:
    lda    #$94                  ; 2
    sta    $A0                   ; 3
    lda    #$9D                  ; 2
    sta    $A2                   ; 3
    lda    $93                   ; 3
    sta    $B0                   ; 3
    clc                          ; 2
    adc    #$10                  ; 2
    sta    $B2                   ; 3
    sta    $9C                   ; 3
    adc    #$10                  ; 2
    sta    $B4                   ; 3
    lda    LFF65,X               ; 4
    asl                          ; 2
    bcc    LF5DF                 ; 2�
    bmi    LF5DD                 ; 2�
    inc    $93                   ; 5
    bmi    LF5DD                 ; 2�
    inc    $93                   ; 5
LF5DD:
    dec    $93                   ; 5
LF5DF:
    asl                          ; 2
    bpl    LF5E6                 ; 2�
    ldy    #$70                  ; 2
    sty    $A0                   ; 3
LF5E6:
    asl                          ; 2
    beq    LF611                 ; 2�+1
    bpl    LF5EE                 ; 2�
    jmp    LF755                 ; 3

LF5EE:
    lda    $91                   ; 3
    cpx    #2                    ; 2
    beq    LF609                 ; 2�+1
    bcs    LF612                 ; 2�+1
    lda    #4                    ; 2
    sta    $94                   ; 3
    lda    #0                    ; 2
    sta    $93                   ; 3
    sta    $92                   ; 3
    lda    #$70                  ; 2
    sta    $A0                   ; 3
    lda    #$3F                  ; 2
    sta    $95                   ; 3
    rts                          ; 6

LF609:
    tay                          ; 2
    bne    LF611                 ; 2�
    jsr    LF798                 ; 6
    sta    $92                   ; 3
LF611:
    rts                          ; 6

LF612:
    cpx    #6                    ; 2
    beq    LF621                 ; 2�
    bcs    LF629                 ; 2�
    ldy    #1                    ; 2
LF61A:
    dec    $94                   ; 5
    bmi    LF620                 ; 2�
    sty    $90                   ; 3
LF620:
    rts                          ; 6

LF621:
    ldy    $92                   ; 3
    dey                          ; 2
    sty    $92                   ; 3
    sty    $91                   ; 3
    rts                          ; 6

LF629:
    cpx    #8                    ; 2
    beq    LF63E                 ; 2�
    bcs    LF645                 ; 2�
    ldx    #$0C                  ; 2
    and    #$10                  ; 2
    beq    LF63B                 ; 2�
    ldx    #$0A                  ; 2
    ldy    #$79                  ; 2
    sty    $A0                   ; 3
LF63B:
    stx    $F8                   ; 3
    rts                          ; 6

LF63E:
    lda    #7                    ; 2
    sta    $94                   ; 3
    jmp    LF705                 ; 3

LF645:
    txa                          ; 2
    ora    #$40                  ; 2
    sta    $90                   ; 3
    lda    #$50                  ; 2
    sta    $B2                   ; 3
    lda    #$30                  ; 2
    sta    $B4                   ; 3
LF652:
    lda    #$70                  ; 2
    sta    $A0                   ; 3
    lda    #$82                  ; 2
    sta    $A2                   ; 3
    lda    #$0A                  ; 2
    sta    $F8                   ; 3
    lda    $91                   ; 3
    ldy    #$48                  ; 2
    cpx    #$0A                  ; 2
    beq    LF61A                 ; 2�
    bcs    LF67B                 ; 2�
    cmp    #8                    ; 2
    bcc    LF674                 ; 2�
    ldx    #$79                  ; 2
    ldy    #$8B                  ; 2
    stx    $A0                   ; 3
    sty    $A2                   ; 3
LF674:
    lda    #$7F                  ; 2
    sta    $92                   ; 3
    jmp    LF705                 ; 3

LF67B:
    cpx    #$0C                  ; 2
    beq    LF688                 ; 2�
    bcs    LF6C4                 ; 2�
    dec    $92                   ; 5
    lda    #4                    ; 2
    sta    $94                   ; 3
    rts                          ; 6

LF688:
    stx    $91                   ; 3
    ldy    $92                   ; 3
    tya                          ; 2
    and    #$0F                  ; 2
    bne    LF695                 ; 2�
    lda    $80                   ; 3
    sta    $C1                   ; 3
LF695:
    bit    $C1                   ; 3
    bvc    LF69D                 ; 2�
    bmi    LF6AD                 ; 2�
    iny                          ; 2
    iny                          ; 2
LF69D:
    dey                          ; 2
    cpy    #$68                  ; 2
    bcc    LF6A4                 ; 2�
    ldy    #8                    ; 2
LF6A4:
    cpy    #8                    ; 2
    bcs    LF6AA                 ; 2�
    ldy    #$68                  ; 2
LF6AA:
    sty    $92                   ; 3
    rts                          ; 6

LF6AD:
    lda    $80                   ; 3
    lsr                          ; 2
    bcs    LF6BA                 ; 2�
    lda    $8C                   ; 3
    bne    LF6C3                 ; 2�
    dec    $94                   ; 5
    bne    LF6C3                 ; 2�
LF6BA:
    lda    #0                    ; 2
    sta    $91                   ; 3
    jsr    LF798                 ; 6
    sta    $95                   ; 3
LF6C3:
    rts                          ; 6

LF6C4:
    lda    $95                   ; 3
    cpx    #$0D                  ; 2
    bne    LF6EF                 ; 2�
    ldy    #$79                  ; 2
    sty    $A0                   ; 3
    ldy    #$8B                  ; 2
    sty    $A2                   ; 3
    cmp    $92                   ; 3
    beq    LF6E2                 ; 2�
    lda    #$0B                  ; 2
    sta    $F8                   ; 3
    lda    $91                   ; 3
    asl                          ; 2
    adc    #$20                  ; 2
    sta    $9C                   ; 3
    rts                          ; 6

LF6E2:
    lda    $91                   ; 3
    bne    LF6EA                 ; 2�
    lda    #$30                  ; 2
    sta    $AD                   ; 3
LF6EA:
    lda    #8                    ; 2
    sta    $F8                   ; 3
    rts                          ; 6

LF6EF:
    jsr    LF757                 ; 6
    lda    $95                   ; 3
    cmp    $92                   ; 3
    beq    LF6EA                 ; 2�
    asl    $EF                   ; 5
    ldx    #$60                  ; 2
    cpx    $91                   ; 3
    lda    #$FF                  ; 2
    adc    #$50                  ; 2
    sta    $B2                   ; 3
LF704:
    rts                          ; 6

LF705:
    lda    $91                   ; 3
    cmp    #$10                  ; 2
    bcs    LF704                 ; 2�
    eor    #$0F                  ; 2
    ora    $96                   ; 3
    and    #$3F                  ; 2
    tax                          ; 2
    cmp    #$30                  ; 2
    bcc    LF718                 ; 2�
    and    #$0F                  ; 2
LF718:
    sta    $97                   ; 3
    txa                          ; 2
    and    #$38                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tay                          ; 2
    lsr                          ; 2
    tax                          ; 2
    lda    $91                   ; 3
    beq    LF731                 ; 2�
    lda    $D3                   ; 3
    cmp    $8D                   ; 3
    bcs    LF745                 ; 2�
    dec    $91                   ; 5
    bne    LF745                 ; 2�
LF731:
    lda    $95                   ; 3
    and    LFF2D,X               ; 4
    beq    LF73B                 ; 2�
    lsr                          ; 2
    bne    LF743                 ; 2�
LF73B:
    lda    $95                   ; 3
    and    LFDF5,X               ; 4
    beq    LF745                 ; 2�
    asl                          ; 2
LF743:
    sta    $95                   ; 3
LF745:
    lda    LFF98,Y               ; 4
    ldx    LFF6E,Y               ; 4
    sta    $D8,X                 ; 4
    lda    #$0D                  ; 2
    sta    $F8                   ; 3
    lda    #1                    ; 2
    bne    LF77C                 ; 3   always branch

LF755:
    lda    $92                   ; 3
LF757:
    sec                          ; 2
    sbc    #$10                  ; 2
    tax                          ; 2
    lda    $91                   ; 3
    and    #$04                  ; 2
    bne    LF797                 ; 2�
    stx    $9B                   ; 3
    inc    $EF                   ; 5
    txa                          ; 2
    cpx    #$31                  ; 2
    bcc    LF76C                 ; 2�
    ldx    #$30                  ; 2
LF76C:
    stx    $97                   ; 3
    ldx    #$79                  ; 2
    stx    $A0                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    adc    #8                    ; 2
    tay                          ; 2
    lda    LFF6E,Y               ; 4
LF77C:
    sta    $9A                   ; 3
    lda    LFF8A,Y               ; 4
    ldx    LFF57,Y               ; 4
    sta    $D8,X                 ; 4
    lda    LFF7C,Y               ; 4
    sta    $98                   ; 3
    and    #$44                  ; 2
    sta    $C0                   ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    ror                          ; 2
    ora    $C0                   ; 3
    sta    $C0                   ; 3
LF797:
    rts                          ; 6

LF798:
    ldy    $8A                   ; 3
LF79A:
    tya                          ; 2
    and    #$07                  ; 2
    tay                          ; 2
    lda    LFF31,Y               ; 4
    iny                          ; 2
    bit    $95                   ; 3
    beq    LF79A                 ; 2�
    eor    $95                   ; 3
    sta    $95                   ; 3
    tya                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    rts                          ; 6

LF7B0:
    and    #$06                  ; 2
    beq    LF7B5                 ; 2�
    dey                          ; 2
LF7B5:
    tya                          ; 2
    clc                          ; 2
    adc    LFF1C,X               ; 4
    cpx    $D6                   ; 3
    bne    LF7CC                 ; 2�
    adc    #3                    ; 2
    eor    #$FF                  ; 2
    asl                          ; 2
    sbc    $CD                   ; 3
    bcs    LF7CB                 ; 2�
    inc    $AD                   ; 5
    ldy    #$FF                  ; 2
LF7CB:
    rts                          ; 6

LF7CC:
    adc    #4                    ; 2
    bcc    LF7CB                 ; 2�
    lda    LFF1A,X               ; 4
    adc    #8                    ; 2
LF7D5:
    bcs    LF7D9                 ; 2�
    sta    $97,X                 ; 4
LF7D9:
    stx    $AF                   ; 3
    lda    #$7F                  ; 2
    sta    $D5                   ; 3
    sta    $CF                   ; 3
    lda    #$0A                  ; 2
    sta    $F8                   ; 3
    lda    #$90                  ; 2
    sta    $D4                   ; 3
    ldy    #$FF                  ; 2
    rts                          ; 6

    .byte $FF ; |XXXXXXXX| $F7EC
    .byte $FF ; |XXXXXXXX| $F7ED
    .byte $FF ; |XXXXXXXX| $F7EE
    .byte $FF ; |XXXXXXXX| $F7EF
    .byte $FF ; |XXXXXXXX| $F7F0
    .byte $FF ; |XXXXXXXX| $F7F1
    .byte $FF ; |XXXXXXXX| $F7F2
    .byte $FF ; |XXXXXXXX| $F7F3
    .byte $FF ; |XXXXXXXX| $F7F4
    .byte $FF ; |XXXXXXXX| $F7F5
    .byte $FF ; |XXXXXXXX| $F7F6
    .byte $FF ; |XXXXXXXX| $F7F7
    .byte $FF ; |XXXXXXXX| $F7F8
    .byte $FF ; |XXXXXXXX| $F7F9
    .byte $FF ; |XXXXXXXX| $F7FA
    .byte $FF ; |XXXXXXXX| $F7FB
    .byte $FF ; |XXXXXXXX| $F7FC

LF7FD SUBROUTINE
    lda    SWCHB                 ; 4
    lsr                          ; 2
    ldx    #0                    ; 2
    stx    $FB                   ; 3
    bcc    LF816                 ; 2�
    bit    $8E                   ; 3
    bmi    LF866                 ; 2�
    lsr                          ; 2
    bcs    LF81E                 ; 2�
    lda    $8F                   ; 3
    cmp    #$4E                  ; 2
    bcs    LF81E                 ; 2�
    inc    $8E                   ; 5
LF816:
    stx    $85                   ; 3
    stx    $89                   ; 3
    stx    $AE                   ; 3
    inc    $FB                   ; 5
LF81E:
    stx    $81                   ; 3
    ldy    #$F0                  ; 2
    bit    $8C                   ; 3
    bvc    LF827                 ; 2�
    iny                          ; 2
LF827:
    sty    $80                   ; 3
    lda    $8E                   ; 3
    and    #$41                  ; 2
    sta    $8E                   ; 3
    lda    SWCHB                 ; 4
    and    #$C0                  ; 2
    eor    #$80                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    bit    INPT5                 ; 3
    bmi    LF83E                 ; 2�
    ora    #$01                  ; 2
LF83E:
    ora    $8E                   ; 3
    sta    $8E                   ; 3
    ldy    #$A0                  ; 2
    lsr                          ; 2
    and    #$10                  ; 2
    bne    LF84B                 ; 2�
    ldy    #$60                  ; 2
LF84B:
    lda    INPT5                 ; 3
    and    INPT4                 ; 3
    bmi    LF863                 ; 2�
    sty    $85                   ; 3
    bcc    LF857                 ; 2�
    sty    $89                   ; 3
LF857:
    lda    $8E                   ; 3
    ora    #$80                  ; 2
    sta    $FB                   ; 3
    and    #$BF                  ; 2
    sta    $8E                   ; 3
    stx    $BE                   ; 3
LF863:
    jmp    LF8CC                 ; 3

LF866:
    lda    SWCHA                 ; 4
    bvs    LF872                 ; 2�
    and    #$F0                  ; 2
    bit    INPT4                 ; 3
    jmp    LF878                 ; 3

LF872:
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    bit    INPT5                 ; 3
LF878:
    bmi    LF87C                 ; 2�
    ora    #$01                  ; 2
LF87C:
    ldx    $81                   ; 3
    cmp    $80                   ; 3
    beq    LF888                 ; 2�
    sta    $80                   ; 3
    ldx    #5                    ; 2
    stx    $81                   ; 3
LF888:
    dex                          ; 2
    bne    LF88D                 ; 2�
    inc    $8B                   ; 5
LF88D:
    stx    $81                   ; 3
    ldx    $AD                   ; 3
    clc                          ; 2
    lda    $9D                   ; 3
    bpl    LF8A0                 ; 2�
    ldy    $D2                   ; 3
    lda    LFFE2,Y               ; 4
    bpl    LF8A0                 ; 2�
    and    #$7F                  ; 2
    inx                          ; 2
LF8A0:
    sed                          ; 2
    adc    $84                   ; 3
    sta    $84                   ; 3
    txa                          ; 2
    adc    $83                   ; 3
    sta    $83                   ; 3
    lda    #0                    ; 2
    sta    $9D                   ; 3
    sta    $AD                   ; 3
    bcc    LF8CB                 ; 2�
    adc    $82                   ; 3
    sta    $82                   ; 3
    cld                          ; 2
    and    #$0F                  ; 2
    cmp    #2                    ; 2
    beq    LF8C1                 ; 2�
    cmp    #7                    ; 2
    bne    LF8CB                 ; 2�
LF8C1:
    lda    $85                   ; 3
    cmp    #$A0                  ; 2
    bcs    LF8CB                 ; 2�
    adc    #$20                  ; 2
    sta    $85                   ; 3
LF8CB:
    cld                          ; 2
LF8CC:
    bit    TIMINT                ; 4
    bpl    LF8CC                 ; 2�
    ldx    #2                    ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    VBLANK                ; 3
    stx    WSYNC                 ; 3
    stx    WSYNC                 ; 3
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMCLR                 ; 3
    inc    $8C                   ; 5
    lda    #$FD                  ; 2
    sta    $E1                   ; 3
    sta    $E3                   ; 3
    sta    $E5                   ; 3
    sta    $E7                   ; 3
    sta    $E9                   ; 3
    sta    $EB                   ; 3
    lda    $8C                   ; 3
    lsr                          ; 2
    lda    #2                    ; 2
  IF SCANLINE_FIX
    NOP
    NOP
  ELSE
    bcc    LF8F8                 ; 2�
  ENDIF
    stx    WSYNC                 ; 3
;---------------------------------------
LF8F8:
    sta    VSYNC                 ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    $8A                   ; 3
    rol    $8A                   ; 5
    eor    $8A                   ; 3
    ror    $8A                   ; 5
    inc    $8B                   ; 5
    adc    $8B                   ; 3
    bvc    LF90C                 ; 2�
    inc    $8B                   ; 5
LF90C:
    sta    $8A                   ; 3
    sta    WSYNC                 ; 3
;---------------------------------------
    lda    $8C                   ; 3
    lsr                          ; 2
    bcc    LF91D                 ; 2�
    lda    #0                    ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    sta    VSYNC                 ; 3
    beq    LF92C                 ; 3   always branch

LF91D:
    stx    WSYNC                 ; 3
;---------------------------------------
    jsr    LFAF0                 ; 6
    jsr    LFAF0                 ; 6
    jsr    LFAF0                 ; 6
    lda    #0                    ; 2
    sta    VSYNC                 ; 3
LF92C:
    sta    WSYNC                 ; 3
;---------------------------------------
    jsr    LF959                 ; 6
    stx    WSYNC                 ; 3
;---------------------------------------

    lda    #0                    ; 2
    ldx    #$20                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------

    sta    VBLANK                ; 3
    stx    TIM64T                ; 4
    ldy    $FB                   ; 3
    beq    LF96E                 ; 2�
    sta    $83                   ; 3
    sta    $84                   ; 3
    sta    $87                   ; 3
    sta    $88                   ; 3
    lda    $8E                   ; 3
    and    #$10                  ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    sta    $82                   ; 3
    sta    $86                   ; 3
    jmp    LF00C                 ; 3

LF959:
    ldy    #$53                  ; 2
    lda    $82                   ; 3
    cmp    #$A0                  ; 2
    bcc    LF96F                 ; 2�
    lda    #$79                  ; 2
    clc                          ; 2
    ldx    #$0A                  ; 2
LF966:
    sta    $E0,X                 ; 4
    adc    #8                    ; 2
    dex                          ; 2
    dex                          ; 2
    bpl    LF966                 ; 2�
LF96E:
    rts                          ; 6

LF96F:
    and    #$F0                  ; 2
    bne    LF976                 ; 2�
    tya                          ; 2
    bpl    LF979                 ; 2�
LF976:
    ldy    #0                    ; 2
    lsr                          ; 2
LF979:
    sta    $E8                   ; 3
    lda    $82                   ; 3
    and    #$0F                  ; 2
    bne    LF984                 ; 2�
    tya                          ; 2
    bpl    LF989                 ; 3   always branch

LF984:
    ldy    #0                    ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
LF989:
    sta    $E6                   ; 3
    lda    $83                   ; 3
    and    #$F0                  ; 2
    bne    LF994                 ; 2�
    tya                          ; 2
    bpl    LF997                 ; 3   always branch

LF994:
    ldy    #0                    ; 2
    lsr                          ; 2
LF997:
    sta    $E4                   ; 3
    lda    $83                   ; 3
    and    #$0F                  ; 2
    bne    LF9A2                 ; 2�
    tya                          ; 2
    bpl    LF9A7                 ; 3   always branch

LF9A2:
    ldy    #0                    ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
LF9A7:
    sta    $E2                   ; 3
    lda    $84                   ; 3
    and    #$F0                  ; 2
    bne    LF9B2                 ; 2�
    tya                          ; 2
    bpl    LF9B5                 ; 3   always branch

LF9B2:
    ldy    #0                    ; 2
    lsr                          ; 2
LF9B5:
    sta    $E0                   ; 3
    lda    $84                   ; 3
    and    #$0F                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    $EA                   ; 3
    rts                          ; 6

LF9C1:
    bit    TIMINT                ; 4
    bpl    LF9C1                 ; 2�
    lda    #$FF                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    sta    TIM64T                ; 4
    ldy    #$13                  ; 2
LF9CF:
    sty    NUSIZ0                ; 3
    sty    NUSIZ1                ; 3
    ldx    $8F                   ; 3
    nop                          ; 2
    bpl    LF9DB                 ; 2�
    jmp    LFAF1                 ; 3

LF9DB:
    sty    HMP1                  ; 3
    stx    RESP0                 ; 3
    stx    RESP1                 ; 3
    sty    VDELP0                ; 3
    sty    VDELP1                ; 3
    lda    #$E0                  ; 2
    and    $85                   ; 3
    bne    LF9F5                 ; 2�
    lda    $8E                   ; 3
    and    #$20                  ; 2
    ora    #$18                  ; 2
    and    $8C                   ; 3
    asl                          ; 2
    asl                          ; 2

LF9F5:
    ldy    #BLUE_CYAN+2          ; 2   color
    bit    $8E                   ; 3
    bvc    LF9FD                 ; 2�
    ldy    #ORANGE_RED+2         ; 2   color
LF9FD:
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMOVE                 ; 3
    sty    COLUP0                ; 3   done
    sty    COLUP1                ; 3   done
    ldx    #GREEN+8              ; 2   color
    stx    COLUBK                ; 3   done
    stx    COLUPF                ; 3   done
    asl                          ; 2
    rol                          ; 2
    rol                          ; 2
    rol                          ; 2
    tax                          ; 2
    lda    LFD71,X               ; 4
    sta    PF0                   ; 3
    lda    LFDA9,X               ; 4
    sta    PF1                   ; 3
    lda    LFD6D,X               ; 4
    sta    PF2                   ; 3
    ldy    #7                    ; 2
LFA21:
    nop                          ; 2
    nop                          ; 2
    sty    $EC                   ; 3
    lda    ($E8),Y               ; 5
    sta    GRP0                  ; 3
    lda    ($E6),Y               ; 5
    sta    GRP1                  ; 3
    lda    ($E4),Y               ; 5
    sta    GRP0                  ; 3
    lda    ($E2),Y               ; 5
    sta    $FB                   ; 3
    lda    ($EA),Y               ; 5
    tax                          ; 2
    lda    ($E0),Y               ; 5
    ldy    $FB                   ; 3
    sty    GRP1                  ; 3
    sta    GRP0                  ; 3
    stx    GRP1                  ; 3
    stx    GRP0                  ; 3
    ldy    $EC                   ; 3
    nop                          ; 2
    dey                          ; 2
    bpl    LFA21                 ; 2�
    ldy    #$10                  ; 2
    lda    $85                   ; 3
    cmp    #$80                  ; 2
    bcs    LFA5A                 ; 2�
    lda    $8E                   ; 3
    and    #$20                  ; 2
    bne    LFA5A                 ; 2�
    sta    NUSIZ1                ; 3
LFA5A:
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    #GREEN+8              ; 2   color
    sta    COLUPF                ; 3   done
    sta    VDELP0                ; 3
    sta    VDELP1                ; 3
    bvs    LFA6B                 ; 2�
    lda    LFDC0,Y               ; 4
    bvc    LFA6F                 ; 3   always branch

LFA6B:
    nop                          ; 2
    lda    LFF00,Y               ; 4
LFA6F:
    sta    GRP0                  ; 3
    ldx    NumOfLivesBeerMug,Y   ; 4
    stx    GRP1                  ; 3
    lda    #BLUE+2               ; 2   outline color for beer mug (lives display), and the tap
    sta    COLUP0                ; 3   done
    sta    COLUP1                ; 3   done
    lda    LFDD4,Y               ; 4
    stx    RESP0                 ; 3
    nop                          ; 2
    stx    GRP0                  ; 3
    sta    COLUPF                ; 3
    stx    $FB                   ; 3
    dey                          ; 2
    stx    RESP1                 ; 3
    bpl    LFA5A                 ; 2�
    lda    #3                    ; 2
    sta    NUSIZ1                ; 3
    lda    #0                    ; 2
    sta    PF0                   ; 3
    sta    PF1                   ; 3
    sta    PF2                   ; 3
    lda    $8F                   ; 3
    beq    LFAF0                 ; 2�
    cmp    #4                    ; 2
    bcs    LFAA5                 ; 2�
    lda    $D2                   ; 3
    sta    $F8                   ; 3
LFAA5:
    dec    $8F                   ; 5
    lda    #1                    ; 2
    bit    $8E                   ; 3
    bne    LFAB5                 ; 2�
    dec    $8F                   ; 5
LFAAF:
    ldx    #$FF                  ; 2
    txs                          ; 2
    jmp    LF09D                 ; 3

LFAB5:
    jsr    LFACA                 ; 6
    bvs    LFAAF                 ; 2�
    lda    $8F                   ; 3
    beq    LFAF0                 ; 2�
    jsr    LF959                 ; 6
    ldy    #$13                  ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    $FB                   ; 3
    jmp    LF9CF                 ; 3

LFACA:
    ldx    $86                   ; 3
    lda    $82                   ; 3
    stx    $82                   ; 3
    sta    $86                   ; 3
    ldx    $89                   ; 3
    lda    $85                   ; 3
    stx    $85                   ; 3
    sta    $89                   ; 3
    ldx    $87                   ; 3
    lda    $83                   ; 3
    stx    $83                   ; 3
    sta    $87                   ; 3
    ldx    $88                   ; 3
    lda    $84                   ; 3
    stx    $84                   ; 3
    sta    $88                   ; 3
    lda    $8E                   ; 3
    eor    #$40                  ; 2
    sta    $8E                   ; 3
LFAF0:
    rts                          ; 6

LFAF1:
    ldy    #$19                  ; 2   height of dancing girl
    lda    $F9                   ; 3
    asl                          ; 2
    clc                          ; 2
    sta    REFP0                 ; 3
    sta    REFP1                 ; 3
    stx.w  RESP0                 ; 4
    and    #$04                  ; 2
    beq    LFB04                 ; 2�
    lda    #$34                  ; 2
LFB04:
    adc    #$64                  ; 2
    tax                          ; 2
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    #GREEN+8              ; 2   color
    sta    COLUBK                ; 3   done
    lda    #$FC                  ; 2
    sta    $E1                   ; 3
    sta    $E3                   ; 3
    lda    $F9                   ; 3
    and    #$1E                  ; 2
    beq    LFB1D                 ; 2�
    eor    #$14                  ; 2
    bne    LFB1F                 ; 2�
LFB1D:
    ldx    #$CC                  ; 2
LFB1F:
    stx    $E0                   ; 3
    txa                          ; 2
    clc                          ; 2
    adc    #$1A                  ; 2
    sta    $E2                   ; 3
    lda    $F1                   ; 3
    cmp    #$ED                  ; 2
    bcc    LFB33                 ; 2�
    inc    $8F                   ; 5
    lda    #$18                  ; 2
    sta    $AE                   ; 3
LFB33:
    stx    WSYNC                 ; 3
;---------------------------------------
    lda    ($E0),Y               ; 5
    sta    GRP0                  ; 3
    lda    ($E2),Y               ; 5
    sta    GRP1                  ; 3
    lda    LFFC8,Y               ; 4
    sta    COLUP1                ; 3
    lda    LFFAE,Y               ; 4
    sta    COLUP0                ; 3
    nop                          ; 2
    nop                          ; 2
    lda    #0                    ; 2
    dey                          ; 2
    stx    RESP1                 ; 3
    bpl    LFB33                 ; 2�
    sta    REFP1                 ; 3
    rts                          ; 6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LFB53 SUBROUTINE
    stx    WSYNC                 ; 3
;---------------------------------------
    stx    HMCLR                 ; 3
    lda    $D0                   ; 3
    sta    COLUBK                ; 3
    lda    #0                    ; 2
    sta    NUSIZ0                ; 3
    sta    GRP0                  ; 3
    sta    GRP1                  ; 3
    sta    ENAM1                 ; 3
    sta    PF0                   ; 3
    sta    PF1                   ; 3
    sta    PF2                   ; 3
    sta    ENABL                 ; 3
    sta    ENAM0                 ; 3
    sta    REFP0                 ; 3
    sta    REFP1                 ; 3
    ldx    #8                    ; 2
    lda    $8C                   ; 3
LFB77:
    asl                          ; 2
    ror    $D3                   ; 5
    dex                          ; 2
    bne    LFB77                 ; 2�
LFB7D:
    bit    TIMINT                ; 4
    bpl    LFB7D                 ; 2�
    lda    #9                    ; 2
    sta    TIM64T                ; 4
    ldy    $F8                   ; 3
    cpy    $F0                   ; 3
    beq    LFB9E                 ; 2�
    sty    $F0                   ; 3
    ldx    LFFE6,Y               ; 4
    dex                          ; 2
    stx    $F1                   ; 3
    ldx    #$FF                  ; 2
    stx    $F9                   ; 3
    inx                          ; 2
    stx    $F7                   ; 3
    stx    $F2                   ; 3
LFB9E:
    cpy    #4                    ; 2
    bcs    LFBA7                 ; 2�
    lda    $F5                   ; 3
    and    #$07                  ; 2
    tay                          ; 2
LFBA7:
    sty    $EC                   ; 3
    lda    LFDE5,Y               ; 4
    sta    AUDC0                 ; 3
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    tax                          ; 2
    and    #$03                  ; 2
    sta    $F4                   ; 3
    txa                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    and    #$03                  ; 2
    tax                          ; 2
    dec    $F7                   ; 5
    bpl    LFC16                 ; 2�+1
    lda    LFF3D,X               ; 4
    sta    $F7                   ; 3
    inc    $F9                   ; 5
    ldy    $F1                   ; 3
    iny                          ; 2
    dec    $F2                   ; 5
    bmi    LFBFD                 ; 2�
    lda    $F3                   ; 3
    jmp    LFC21                 ; 3

LFBD4:
    tax                          ; 2
    iny                          ; 2
    asl                          ; 2
    bmi    LFBDB                 ; 2�
    dec    $F5                   ; 5
LFBDB:
    asl                          ; 2
    bpl    LFBE6                 ; 2�
    lda    $F9                   ; 3
    and    #$18                  ; 2
    eor    #$18                  ; 2
    beq    LFBFD                 ; 2�
LFBE6:
    txa                          ; 2
    and    #$1F                  ; 2
    tax                          ; 2
    bne    LFBFA                 ; 2�
    lda    $F9                   ; 3
    cmp    #$B8                  ; 2
    beq    LFBFD                 ; 2�
    ldy    #0                    ; 2
    and    #$20                  ; 2
    beq    LFBFD                 ; 2�
    ldx    #7                    ; 2
LFBFA:
    ldy    LFFE6,X               ; 4
LFBFD:
    lda    LFE00,Y               ; 4
    bmi    LFBD4                 ; 2�+1
    sty    $F1                   ; 3
    tax                          ; 2
    rol                          ; 2
    rol                          ; 2
    rol                          ; 2
    rol                          ; 2
    and    #$07                  ; 2
    sta    $F2                   ; 3
    txa                          ; 2
    and    #$1F                  ; 2
    beq    LFC21                 ; 2�
    lda    #$1F                  ; 2
    bne    LFC21                 ; 3   always branch

LFC16:
    lda    $F3                   ; 3
    beq    LFC21                 ; 2�
    sec                          ; 2
    sbc    $F4                   ; 3
    bpl    LFC21                 ; 2�
    lda    #0                    ; 2
LFC21:
    sta    $F3                   ; 3
    lsr                          ; 2
    sta    AUDV0                 ; 3
    ldx    $F1                   ; 3
    ldy    LFE00,X               ; 4
    ldx    $EF                   ; 3
    beq    LFC43                 ; 2�
    lda    LFF22,X               ; 4
    sta    AUDF1                 ; 3
    sta    AUDF0                 ; 3
    lda    LFF1C,X               ; 4
    sta    AUDC0                 ; 3
    sta    AUDC1                 ; 3
    lda    #$1F                  ; 2
    sta    AUDV0                 ; 3
    bne    LFC5D                 ; 3   always branch

LFC43:
    sty    AUDF0                 ; 3
    ldy    $EC                   ; 3
    lda    LFF4D,Y               ; 4
    bpl    LFC58                 ; 2�
    sta    AUDC1                 ; 3
    lda    $F9                   ; 3
    and    #$07                  ; 2
    tax                          ; 2
    lda    LFF41,X               ; 4
    sta    AUDF1                 ; 3
LFC58:
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
    lsr                          ; 2
LFC5D:
    sta    AUDV1                 ; 3
    lda    #0                    ; 2
    sta    $EF                   ; 3
    rts                          ; 6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;low kick
DancingGirlOne:
    .byte $00 ; |        | $FC64   P0 gfx
    .byte $0C ; |    XX  | $FC65
    .byte $40 ; | X      | $FC66
    .byte $80 ; |X       | $FC67
    .byte $00 ; |        | $FC68
    .byte $00 ; |        | $FC69
    .byte $00 ; |        | $FC6A
    .byte $00 ; |        | $FC6B
    .byte $18 ; |   XX   | $FC6C
    .byte $0E ; |    XXX | $FC6D
    .byte $0F ; |    XXXX| $FC6E
    .byte $07 ; |     XXX| $FC6F
    .byte $60 ; | XX     | $FC70
    .byte $3C ; |  XXXX  | $FC71
    .byte $1C ; |   XXX  | $FC72
    .byte $78 ; | XXXX   | $FC73
    .byte $38 ; |  XXX   | $FC74
    .byte $10 ; |   X    | $FC75
    .byte $00 ; |        | $FC76
    .byte $00 ; |        | $FC77
    .byte $03 ; |      XX| $FC78
    .byte $07 ; |     XXX| $FC79
    .byte $04 ; |     X  | $FC7A
    .byte $06 ; |     XX | $FC7B
    .byte $0E ; |    XXX | $FC7C
    .byte $79 ; | XXXX  X| $FC7D
DancingGirlTwo:
    .byte $00 ; |        | $FC7E   P1 gfx
    .byte $00 ; |        | $FC7F
    .byte $08 ; |    X   | $FC80
    .byte $48 ; | X  X   | $FC81
    .byte $44 ; | X   X  | $FC82
    .byte $24 ; |  X  X  | $FC83
    .byte $24 ; |  X  X  | $FC84
    .byte $16 ; |   X XX | $FC85
    .byte $02 ; |      X | $FC86
    .byte $00 ; |        | $FC87
    .byte $00 ; |        | $FC88
    .byte $00 ; |        | $FC89
    .byte $06 ; |     XX | $FC8A
    .byte $00 ; |        | $FC8B
    .byte $00 ; |        | $FC8C
    .byte $00 ; |        | $FC8D
    .byte $00 ; |        | $FC8E
    .byte $00 ; |        | $FC8F
    .byte $00 ; |        | $FC90
    .byte $30 ; |  XX    | $FC91
    .byte $58 ; | X XX   | $FC92
    .byte $78 ; | XXXX   | $FC93
    .byte $28 ; |  X X   | $FC94
    .byte $20 ; |  X     | $FC95
    .byte $50 ; | X X    | $FC96
    .byte $00 ; |        | $FC97

;front view
DancingGirlThree:
    .byte $00 ; |        | $FC98   P0 gfx
    .byte $6C ; | XX XX  | $FC99
    .byte $00 ; |        | $FC9A
    .byte $00 ; |        | $FC9B
    .byte $00 ; |        | $FC9C
    .byte $00 ; |        | $FC9D
    .byte $00 ; |        | $FC9E
    .byte $38 ; |  XXX   | $FC9F
    .byte $7C ; | XXXXX  | $FCA0
    .byte $7C ; | XXXXX  | $FCA1
    .byte $38 ; |  XXX   | $FCA2
    .byte $00 ; |        | $FCA3
    .byte $00 ; |        | $FCA4
    .byte $7C ; | XXXXX  | $FCA5
    .byte $BA ; |X XXX X | $FCA6
    .byte $38 ; |  XXX   | $FCA7
    .byte $10 ; |   X    | $FCA8
    .byte $00 ; |        | $FCA9
    .byte $83 ; |X     XX| $FCAA
    .byte $C6 ; |XX   XX | $FCAB
    .byte $C6 ; |XX   XX | $FCAC
    .byte $00 ; |        | $FCAD
    .byte $00 ; |        | $FCAE
    .byte $00 ; |        | $FCAF
    .byte $7C ; | XXXXX  | $FCB0
    .byte $38 ; |  XXX   | $FCB1
DancingGirlFour:
    .byte $00 ; |        | $FCB2   P1 gfx
    .byte $00 ; |        | $FCB3
    .byte $28 ; |  X X   | $FCB4
    .byte $28 ; |  X X   | $FCB5
    .byte $28 ; |  X X   | $FCB6
    .byte $28 ; |  X X   | $FCB7
    .byte $28 ; |  X X   | $FCB8
    .byte $00 ; |        | $FCB9
    .byte $00 ; |        | $FCBA
    .byte $00 ; |        | $FCBB
    .byte $00 ; |        | $FCBC
    .byte $30 ; |  XX    | $FCBD
    .byte $30 ; |  XX    | $FCBE
    .byte $00 ; |        | $FCBF
    .byte $00 ; |        | $FCC0
    .byte $00 ; |        | $FCC1
    .byte $00 ; |        | $FCC2
    .byte $00 ; |        | $FCC3
    .byte $38 ; |  XXX   | $FCC4
    .byte $28 ; |  X X   | $FCC5
    .byte $38 ; |  XXX   | $FCC6
    .byte $54 ; | X X X  | $FCC7
    .byte $10 ; |   X    | $FCC8
    .byte $7C ; | XXXXX  | $FCC9
    .byte $00 ; |        | $FCCA
    .byte $00 ; |        | $FCCB

;high kick
DancingGirlFive:
    .byte $00 ; |        | $FCCC   P0 gfx
    .byte $0C ; |    XX  | $FCCD
    .byte $00 ; |        | $FCCE
    .byte $00 ; |        | $FCCF
    .byte $00 ; |        | $FCD0
    .byte $00 ; |        | $FCD1
    .byte $00 ; |        | $FCD2
    .byte $00 ; |        | $FCD3
    .byte $00 ; |        | $FCD4
    .byte $0C ; |    XX  | $FCD5
    .byte $1F ; |   XXXXX| $FCD6
    .byte $1E ; |   XXXX | $FCD7
    .byte $0C ; |    XX  | $FCD8
    .byte $00 ; |        | $FCD9
    .byte $0C ; |    XX  | $FCDA
    .byte $1C ; |   XXX  | $FCDB
    .byte $3E ; |  XXXXX | $FCDC
    .byte $2E ; |  X XXX | $FCDD
    .byte $00 ; |        | $FCDE
    .byte $00 ; |        | $FCDF
    .byte $01 ; |       X| $FCE0
    .byte $03 ; |      XX| $FCE1
    .byte $03 ; |      XX| $FCE2
    .byte $02 ; |      X | $FCE3
    .byte $02 ; |      X | $FCE4
    .byte $3C ; |  XXXX  | $FCE5
DancingGirlSix:
    .byte $00 ; |        | $FCE6   P1 gfx
    .byte $00 ; |        | $FCE7
    .byte $04 ; |     X  | $FCE8
    .byte $04 ; |     X  | $FCE9
    .byte $04 ; |     X  | $FCEA
    .byte $04 ; |     X  | $FCEB
    .byte $0C ; |    XX  | $FCEC
    .byte $0C ; |    XX  | $FCED
    .byte $0C ; |    XX  | $FCEE
    .byte $00 ; |        | $FCEF
    .byte $00 ; |        | $FCF0
    .byte $20 ; |  X     | $FCF1
    .byte $20 ; |  X     | $FCF2
    .byte $6C ; | XX XX  | $FCF3
    .byte $40 ; | X      | $FCF4
    .byte $40 ; | X      | $FCF5
    .byte $80 ; |X       | $FCF6
    .byte $80 ; |X       | $FCF7
    .byte $4A ; | X  X X | $FCF8
    .byte $18 ; |   XX   | $FCF9
    .byte $28 ; |  X X   | $FCFA
    .byte $2C ; |  X XX  | $FCFB
    .byte $3C ; |  XXXX  | $FCFC
    .byte $14 ; |   X X  | $FCFD
    .byte $10 ; |   X    | $FCFE
    .byte $00 ; |        | $FCFF

        ORG $1D00
       RORG $FD00

Zero:
    .byte $00 ; |        | $FD00
    .byte $1C ; |   XXX  | $FD01
    .byte $22 ; |  X   X | $FD02
    .byte $22 ; |  X   X | $FD03
    .byte $22 ; |  X   X | $FD04
    .byte $22 ; |  X   X | $FD05
    .byte $22 ; |  X   X | $FD06
    .byte $1C ; |   XXX  | $FD07
One:
    .byte $00 ; |        | $FD08
    .byte $1C ; |   XXX  | $FD09
    .byte $08 ; |    X   | $FD0A
    .byte $08 ; |    X   | $FD0B
    .byte $08 ; |    X   | $FD0C
    .byte $08 ; |    X   | $FD0D
    .byte $18 ; |   XX   | $FD0E
    .byte $08 ; |    X   | $FD0F
Two:
    .byte $00 ; |        | $FD10
    .byte $3E ; |  XXXXX | $FD11
    .byte $20 ; |  X     | $FD12
    .byte $10 ; |   X    | $FD13
    .byte $0C ; |    XX  | $FD14
    .byte $02 ; |      X | $FD15
    .byte $22 ; |  X   X | $FD16
    .byte $1C ; |   XXX  | $FD17
Three:
    .byte $00 ; |        | $FD18
    .byte $1C ; |   XXX  | $FD19
    .byte $22 ; |  X   X | $FD1A
    .byte $02 ; |      X | $FD1B
    .byte $0C ; |    XX  | $FD1C
    .byte $08 ; |    X   | $FD1D
    .byte $04 ; |     X  | $FD1E
    .byte $3E ; |  XXXXX | $FD1F
Four:
    .byte $00 ; |        | $FD20
    .byte $04 ; |     X  | $FD21
    .byte $04 ; |     X  | $FD22
    .byte $3E ; |  XXXXX | $FD23
    .byte $24 ; |  X  X  | $FD24
    .byte $14 ; |   X X  | $FD25
    .byte $0C ; |    XX  | $FD26
    .byte $04 ; |     X  | $FD27
Five:
    .byte $00 ; |        | $FD28
    .byte $1C ; |   XXX  | $FD29
    .byte $22 ; |  X   X | $FD2A
    .byte $02 ; |      X | $FD2B
    .byte $02 ; |      X | $FD2C
    .byte $3C ; |  XXXX  | $FD2D
    .byte $20 ; |  X     | $FD2E
    .byte $3E ; |  XXXXX | $FD2F
Six:
    .byte $00 ; |        | $FD30
    .byte $1C ; |   XXX  | $FD31
    .byte $22 ; |  X   X | $FD32
    .byte $22 ; |  X   X | $FD33
    .byte $3C ; |  XXXX  | $FD34
    .byte $20 ; |  X     | $FD35
    .byte $10 ; |   X    | $FD36
    .byte $0E ; |    XXX | $FD37
Seven:
    .byte $00 ; |        | $FD38
    .byte $20 ; |  X     | $FD39
    .byte $20 ; |  X     | $FD3A
    .byte $10 ; |   X    | $FD3B
    .byte $08 ; |    X   | $FD3C
    .byte $04 ; |     X  | $FD3D
    .byte $02 ; |      X | $FD3E
    .byte $3E ; |  XXXXX | $FD3F
Eight:
    .byte $00 ; |        | $FD40
    .byte $1C ; |   XXX  | $FD41
    .byte $22 ; |  X   X | $FD42
    .byte $22 ; |  X   X | $FD43
    .byte $1C ; |   XXX  | $FD44
    .byte $22 ; |  X   X | $FD45
    .byte $22 ; |  X   X | $FD46
    .byte $1C ; |   XXX  | $FD47
Nine:
    .byte $00 ; |        | $FD48
    .byte $38 ; |  XXX   | $FD49
    .byte $04 ; |     X  | $FD4A
    .byte $02 ; |      X | $FD4B
    .byte $1E ; |   XXXX | $FD4C
    .byte $22 ; |  X   X | $FD4D
    .byte $22 ; |  X   X | $FD4E
    .byte $1C ; |   XXX  | $FD4F

LFD50:
    .byte GREY+4         ; $FD50
    .byte GREY+4         ; $FD51
    .byte YELLOW_GREEN+6 ; $FD52
    .byte BLACK          ; $FD53
    .byte BLACK          ; $FD54
    .byte BLACK          ; $FD55
    .byte BLACK          ; $FD56
    .byte BLACK          ; $FD57
    .byte BLACK          ; $FD58
    .byte BLACK          ; $FD59
    .byte BLACK          ; $FD5A
    .byte BLACK          ; $FD5B
    .byte BLACK          ; $FD5C
    .byte BLACK          ; $FD5D
    .byte BLACK          ; $FD5E
NumOfLivesBeerMug:
    .byte $00 ; |        | $FD5F
    .byte $00 ; |        | $FD60
    .byte $00 ; |        | $FD61
    .byte $00 ; |        | $FD62
    .byte $0E ; |    XXX | $FD63
    .byte $15 ; |   X X X| $FD64
    .byte $31 ; |  XX   X| $FD65
    .byte $51 ; | X X   X| $FD66
    .byte $51 ; | X X   X| $FD67
    .byte $51 ; | X X   X| $FD68
    .byte $51 ; | X X   X| $FD69
    .byte $51 ; | X X   X| $FD6A
    .byte $31 ; |  XX   X| $FD6B
    .byte $1F ; |   XXXXX| $FD6C
LFD6D:
    .byte $00 ; |        | $FD6D   PF2
    .byte $00 ; |        | $FD6E
    .byte $00 ; |        | $FD6F
    .byte $00 ; |        | $FD70
LFD71:
    .byte $08 ; |    X   | $FD71   PF0
    .byte $88 ; |X   X   | $FD72
    .byte $88 ; |X   X   | $FD73
    .byte $88 ; |X   X   | $FD74
    .byte $88 ; |X   X   | $FD75
    .byte $88 ; |X   X   | $FD76
    .byte $88 ; |X   X   | $FD77
    .byte $88 ; |X   X   | $FD78

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       XX  XX X   X   X X            XX
;      X X X X X   X   XXX           XXXX X XXX XXX XXX
;      XXX XXX X   X    X            X  X X X X X X   X
;      X X X X XXX XXX  X            X XX X XXX XXX XXX
;      X X                    XX X X X XX X   X X X   X
;      XXX XXXXX X XXX X X X X X XXX X  X X   X X X   X
;          X X X X X X X X X XXX  X  XXXX X   X XXX XXX
;          X X X X XXX XXXXX X X  X   XX
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LogoOne:
    .byte $00 ; |        | $FD79
    .byte $77 ; | XXX XXX| $FD7A
    .byte $51 ; | X X   X| $FD7B
    .byte $51 ; | X X   X| $FD7C
    .byte $77 ; | XXX XXX| $FD7D
    .byte $51 ; | X X   X| $FD7E
    .byte $77 ; | XXX XXX| $FD7F
    .byte $00 ; |        | $FD80
LogoTwo:
    .byte $0A ; |    X X | $FD81
    .byte $0A ; |    X X | $FD82
    .byte $EF ; |XXX XXXX| $FD83
    .byte $A0 ; |X X     | $FD84
    .byte $AA ; |X X X X | $FD85
    .byte $EE ; |XXX XXX | $FD86
    .byte $AA ; |X X X X | $FD87
    .byte $66 ; | XX  XX | $FD88
LogoThree:
    .byte $AE ; |X X XXX | $FD89
    .byte $AA ; |X X X X | $FD8A
    .byte $AE ; |X X XXX | $FD8B
    .byte $00 ; |        | $FD8C
    .byte $EE ; |XXX XXX | $FD8D
    .byte $88 ; |X   X   | $FD8E
    .byte $88 ; |X   X   | $FD8F
    .byte $88 ; |X   X   | $FD90
LogoFour:
    .byte $FA ; |XXXXX X | $FD91
    .byte $AB ; |X X X XX| $FD92
    .byte $AA ; |X X X X | $FD93
    .byte $01 ; |       X| $FD94
    .byte $40 ; | X      | $FD95
    .byte $40 ; | X      | $FD96
    .byte $E0 ; |XXX     | $FD97
    .byte $A0 ; |X X     | $FD98
LogoFive:
    .byte $91 ; |X  X   X| $FD99
    .byte $93 ; |X  X  XX| $FD9A
    .byte $BA ; |X XXX X | $FD9B
    .byte $AA ; |X X X X | $FD9C
    .byte $02 ; |      X | $FD9D
    .byte $02 ; |      X | $FD9E
    .byte $03 ; |      XX| $FD9F
    .byte $01 ; |       X| $FDA0
LogoSix:
    .byte $80 ; |X       | $FDA1
    .byte $D1 ; |XX X   X| $FDA2
    .byte $51 ; | X X   X| $FDA3
    .byte $D1 ; |XX X   X| $FDA4
    .byte $D7 ; |XX X XXX| $FDA5
    .byte $55 ; | X X X X| $FDA6
    .byte $D7 ; |XX X XXX| $FDA7
    .byte $80 ; |X       | $FDA8

LFDA9:
    .byte $00 ; |        | $FDA9   PF1
    .byte $00 ; |        | $FDAA
    .byte $10 ; |   X    | $FDAB
    .byte $11 ; |   X   X| $FDAC
    .byte $11 ; |   X   X| $FDAD
    .byte $11 ; |   X   X| $FDAE
    .byte $11 ; |   X   X| $FDAF
    .byte $11 ; |   X   X| $FDB0

LFDB1:
    .byte $01 ; |       X| $FDB1
    .byte $01 ; |       X| $FDB2
    .byte $00 ; |        | $FDB3
    .byte $80 ; |X       | $FDB4
    .byte $80 ; |X       | $FDB5
    .byte $80 ; |X       | $FDB6
    .byte $00 ; |        | $FDB7
    .byte $08 ; |    X   | $FDB8
    .byte $04 ; |     X  | $FDB9
    .byte $10 ; |   X    | $FDBA
    .byte $00 ; |        | $FDBB
    .byte $C0 ; |XX      | $FDBC
    .byte $C0 ; |XX      | $FDBD
    .byte $C0 ; |XX      | $FDBE
    .byte $C0 ; |XX      | $FDBF
LFDC0:
    .byte $00 ; |        | $FDC0
    .byte $78 ; | XXXX   | $FDC1
    .byte $7C ; | XXXXX  | $FDC2
    .byte $FE ; |XXXXXXX | $FDC3
    .byte $FE ; |XXXXXXX | $FDC4
    .byte $FE ; |XXXXXXX | $FDC5
    .byte $FE ; |XXXXXXX | $FDC6
    .byte $FE ; |XXXXXXX | $FDC7
    .byte $FC ; |XXXXXX  | $FDC8
    .byte $F0 ; |XXXX    | $FDC9
    .byte $60 ; | XX     | $FDCA
    .byte $60 ; | XX     | $FDCB
    .byte $60 ; | XX     | $FDCC
    .byte $60 ; | XX     | $FDCD
    .byte $60 ; | XX     | $FDCE
    .byte $60 ; | XX     | $FDCF
LFDD0:
    .byte $00 ; |        | $FDD0
    .byte $18 ; |   XX   | $FDD1
    .byte $0C ; |    XX  | $FDD2
    .byte $24 ; |  X  X  | $FDD3

LFDD4:
    .byte GREEN+8        ; $FDD4
    .byte GREEN+8        ; $FDD5
    .byte GREEN+8        ; $FDD6
    .byte GREEN+8        ; $FDD7
    .byte DIRTY_YELLOW+4 ; $FDD8
    .byte DIRTY_YELLOW+4 ; $FDD9
    .byte DIRTY_YELLOW+4 ; $FDDA
    .byte DIRTY_YELLOW+4 ; $FDDB
    .byte DIRTY_YELLOW+4 ; $FDDC
    .byte DIRTY_YELLOW+4 ; $FDDD
    .byte DIRTY_YELLOW+4 ; $FDDE
    .byte DIRTY_YELLOW+8 ; $FDDF
    .byte DIRTY_YELLOW+8 ; $FDE0
    .byte DIRTY_YELLOW+8 ; $FDE1
    .byte YELLOW+2       ; $FDE2
    .byte GREEN+8        ; $FDE3
    .byte GREEN+8        ; $FDE4
LFDE5:
    .byte $94 ; |X  X X  | $FDE5
    .byte $A4 ; |X X  X  | $FDE6
    .byte $AC ; |X X XX  | $FDE7
    .byte $A4 ; |X X  X  | $FDE8
    .byte $A4 ; |X X  X  | $FDE9
    .byte $AC ; |X X XX  | $FDEA
    .byte $AC ; |X X XX  | $FDEB
    .byte $B1 ; |X XX   X| $FDEC
    .byte $A4 ; |X X  X  | $FDED
    .byte $BC ; |X XXXX  | $FDEE
    .byte $AC ; |X X XX  | $FDEF
    .byte $C8 ; |XX  X   | $FDF0
    .byte $B8 ; |X XXX   | $FDF1
    .byte $08 ; |    X   | $FDF2
    .byte $BC ; |X XXXX  | $FDF3
    .byte $04 ; |     X  | $FDF4
LFDF5:
    .byte $05 ; |     X X| $FDF5
    .byte $0A ; |    X X | $FDF6
    .byte $14 ; |   X X  | $FDF7
    .byte $11 ; |   X   X| $FDF8

    .byte $FF ; |XXXXXXXX| $FDF9
    .byte $FF ; |XXXXXXXX| $FDFA
    .byte $FF ; |XXXXXXXX| $FDFB
    .byte $FF ; |XXXXXXXX| $FDFC
    .byte $FF ; |XXXXXXXX| $FDFD
    .byte $FF ; |XXXXXXXX| $FDFE
    .byte $FF ; |XXXXXXXX| $FDFF
LFE00:
    .byte $3D ; |  XXXX X| $FE00
    .byte $7A ; | XXXX X | $FE01
    .byte $20 ; |  X     | $FE02
    .byte $1D ; |   XXX X| $FE03
    .byte $1A ; |   XX X | $FE04
    .byte $37 ; |  XX XXX| $FE05
    .byte $33 ; |  XX  XX| $FE06
    .byte $33 ; |  XX  XX| $FE07
    .byte $00 ; |        | $FE08
    .byte $11 ; |   X   X| $FE09
    .byte $33 ; |  XX  XX| $FE0A
    .byte $37 ; |  XX XXX| $FE0B
    .byte $3D ; |  XXXX X| $FE0C
    .byte $00 ; |        | $FE0D
    .byte $1A ; |   XX X | $FE0E
    .byte $37 ; |  XX XXX| $FE0F
    .byte $37 ; |  XX XXX| $FE10
    .byte $3A ; |  XXX X | $FE11
    .byte $C0 ; |XX      | $FE12
    .byte $3A ; |  XXX X | $FE13
    .byte $7D ; | XXXXX X| $FE14
    .byte $20 ; |  X     | $FE15
    .byte $20 ; |  X     | $FE16
    .byte $31 ; |  XX   X| $FE17
    .byte $20 ; |  X     | $FE18
    .byte $31 ; |  XX   X| $FE19
    .byte $2E ; |  X XXX | $FE1A
    .byte $6E ; | XX XXX | $FE1B
    .byte $20 ; |  X     | $FE1C
    .byte $33 ; |  XX  XX| $FE1D
    .byte $33 ; |  XX  XX| $FE1E
    .byte $37 ; |  XX XXX| $FE1F
    .byte $3D ; |  XXXX X| $FE20
    .byte $7A ; | XXXX X | $FE21
    .byte $60 ; | XX     | $FE22
    .byte $C4 ; |XX   X  | $FE23
    .byte $3A ; |  XXX X | $FE24
    .byte $7D ; | XXXXX X| $FE25
    .byte $20 ; |  X     | $FE26
    .byte $84 ; |X    X  | $FE27
    .byte $3D ; |  XXXX X| $FE28
    .byte $00 ; |        | $FE29
    .byte $0E ; |    XXX | $FE2A
    .byte $11 ; |   X   X| $FE2B
    .byte $13 ; |   X  XX| $FE2C
    .byte $37 ; |  XX XXX| $FE2D
    .byte $33 ; |  XX  XX| $FE2E
    .byte $15 ; |   X X X| $FE2F
    .byte $3A ; |  XXX X | $FE30
    .byte $17 ; |   X XXX| $FE31
    .byte $35 ; |  XX X X| $FE32
    .byte $31 ; |  XX   X| $FE33
    .byte $13 ; |   X  XX| $FE34
    .byte $37 ; |  XX XXX| $FE35
    .byte $15 ; |   X X X| $FE36
    .byte $33 ; |  XX  XX| $FE37
    .byte $31 ; |  XX   X| $FE38
    .byte $13 ; |   X  XX| $FE39
    .byte $77 ; | XXX XXX| $FE3A
    .byte $00 ; |        | $FE3B
    .byte $3D ; |  XXXX X| $FE3C
    .byte $0E ; |    XXX | $FE3D
    .byte $37 ; |  XX XXX| $FE3E
    .byte $15 ; |   X X X| $FE3F
    .byte $33 ; |  XX  XX| $FE40
    .byte $31 ; |  XX   X| $FE41
    .byte $13 ; |   X  XX| $FE42
    .byte $37 ; |  XX XXX| $FE43
    .byte $15 ; |   X X X| $FE44
    .byte $33 ; |  XX  XX| $FE45
    .byte $31 ; |  XX   X| $FE46
    .byte $1A ; |   XX X | $FE47
    .byte $35 ; |  XX X X| $FE48
    .byte $17 ; |   X XXX| $FE49
    .byte $3A ; |  XXX X | $FE4A
    .byte $3D ; |  XXXX X| $FE4B
    .byte $0E ; |    XXX | $FE4C
    .byte $70 ; | XXX    | $FE4D
    .byte $00 ; |        | $FE4E
    .byte $82 ; |X     X | $FE4F
    .byte $3D ; |  XXXX X| $FE50
    .byte $20 ; |  X     | $FE51
    .byte $0E ; |    XXX | $FE52
    .byte $1D ; |   XXX X| $FE53
    .byte $1D ; |   XXX X| $FE54
    .byte $0E ; |    XXX | $FE55
    .byte $3D ; |  XXXX X| $FE56
    .byte $1D ; |   XXX X| $FE57
    .byte $0E ; |    XXX | $FE58
    .byte $1D ; |   XXX X| $FE59
    .byte $1D ; |   XXX X| $FE5A
    .byte $2E ; |  X XXX | $FE5B
    .byte $35 ; |  XX X X| $FE5C
    .byte $20 ; |  X     | $FE5D
    .byte $0A ; |    X X | $FE5E
    .byte $15 ; |   X X X| $FE5F
    .byte $15 ; |   X X X| $FE60
    .byte $0A ; |    X X | $FE61
    .byte $35 ; |  XX X X| $FE62
    .byte $15 ; |   X X X| $FE63
    .byte $0A ; |    X X | $FE64
    .byte $15 ; |   X X X| $FE65
    .byte $15 ; |   X X X| $FE66
    .byte $2A ; |  X X X | $FE67
    .byte $33 ; |  XX  XX| $FE68
    .byte $20 ; |  X     | $FE69
    .byte $09 ; |    X  X| $FE6A
    .byte $13 ; |   X  XX| $FE6B
    .byte $13 ; |   X  XX| $FE6C
    .byte $09 ; |    X  X| $FE6D
    .byte $33 ; |  XX  XX| $FE6E
    .byte $13 ; |   X  XX| $FE6F
    .byte $09 ; |    X  X| $FE70
    .byte $13 ; |   X  XX| $FE71
    .byte $09 ; |    X  X| $FE72
    .byte $33 ; |  XX  XX| $FE73
    .byte $35 ; |  XX X X| $FE74
    .byte $20 ; |  X     | $FE75
    .byte $0A ; |    X X | $FE76
    .byte $15 ; |   X X X| $FE77
    .byte $15 ; |   X X X| $FE78
    .byte $0A ; |    X X | $FE79
    .byte $35 ; |  XX X X| $FE7A
    .byte $15 ; |   X X X| $FE7B
    .byte $0A ; |    X X | $FE7C
    .byte $15 ; |   X X X| $FE7D
    .byte $15 ; |   X X X| $FE7E
    .byte $2A ; |  X X X | $FE7F
    .byte $81 ; |X      X| $FE80
    .byte $17 ; |   X XXX| $FE81
    .byte $1A ; |   XX X | $FE82
    .byte $17 ; |   X XXX| $FE83
    .byte $35 ; |  XX X X| $FE84
    .byte $17 ; |   X XXX| $FE85
    .byte $1D ; |   XXX X| $FE86
    .byte $1A ; |   XX X | $FE87
    .byte $E3 ; |XXX   XX| $FE88
    .byte $37 ; |  XX XXX| $FE89
    .byte $13 ; |   X  XX| $FE8A
    .byte $11 ; |   X   X| $FE8B
    .byte $1F ; |   XXXXX| $FE8C
    .byte $11 ; |   X   X| $FE8D
    .byte $13 ; |   X  XX| $FE8E
    .byte $00 ; |        | $FE8F
    .byte $1A ; |   XX X | $FE90
    .byte $1D ; |   XXX X| $FE91
    .byte $1A ; |   XX X | $FE92
    .byte $37 ; |  XX XXX| $FE93
    .byte $1A ; |   XX X | $FE94
    .byte $1F ; |   XXXXX| $FE95
    .byte $1D ; |   XXX X| $FE96
    .byte $E6 ; |XXX  XX | $FE97
    .byte $3D ; |  XXXX X| $FE98
    .byte $20 ; |  X     | $FE99
    .byte $13 ; |   X  XX| $FE9A
    .byte $11 ; |   X   X| $FE9B
    .byte $1F ; |   XXXXX| $FE9C
    .byte $00 ; |        | $FE9D
    .byte $83 ; |X     XX| $FE9E
    .byte $1D ; |   XXX X| $FE9F
    .byte $1A ; |   XX X | $FEA0
    .byte $37 ; |  XX XXX| $FEA1
    .byte $1D ; |   XXX X| $FEA2
    .byte $1A ; |   XX X | $FEA3
    .byte $17 ; |   X XXX| $FEA4
    .byte $15 ; |   X X X| $FEA5
    .byte $00 ; |        | $FEA6
    .byte $17 ; |   X XXX| $FEA7
    .byte $7A ; | XXXX X | $FEA8
    .byte $00 ; |        | $FEA9
    .byte $1D ; |   XXX X| $FEAA
    .byte $1F ; |   XXXXX| $FEAB
    .byte $1D ; |   XXX X| $FEAC
    .byte $3A ; |  XXX X | $FEAD
    .byte $00 ; |        | $FEAE
    .byte $1D ; |   XXX X| $FEAF
    .byte $1A ; |   XX X | $FEB0
    .byte $17 ; |   X XXX| $FEB1
    .byte $73 ; | XXX  XX| $FEB2
    .byte $60 ; | XX     | $FEB3
    .byte $11 ; |   X   X| $FEB4
    .byte $13 ; |   X  XX| $FEB5
    .byte $35 ; |  XX X X| $FEB6
    .byte $00 ; |        | $FEB7
    .byte $11 ; |   X   X| $FEB8
    .byte $13 ; |   X  XX| $FEB9
    .byte $15 ; |   X X X| $FEBA
    .byte $13 ; |   X  XX| $FEBB
    .byte $00 ; |        | $FEBC
    .byte $15 ; |   X X X| $FEBD
    .byte $37 ; |  XX XXX| $FEBE
    .byte $13 ; |   X  XX| $FEBF
    .byte $15 ; |   X X X| $FEC0
    .byte $17 ; |   X XXX| $FEC1
    .byte $1A ; |   XX X | $FEC2
    .byte $17 ; |   X XXX| $FEC3
    .byte $15 ; |   X X X| $FEC4
    .byte $13 ; |   X  XX| $FEC5
    .byte $11 ; |   X   X| $FEC6
    .byte $20 ; |  X     | $FEC7
    .byte $1F ; |   XXXXX| $FEC8
    .byte $3D ; |  XXXX X| $FEC9
    .byte $20 ; |  X     | $FECA
    .byte $60 ; | XX     | $FECB
    .byte $89 ; |X   X  X| $FECC
    .byte $3D ; |  XXXX X| $FECD
    .byte $20 ; |  X     | $FECE
    .byte $1A ; |   XX X | $FECF
    .byte $15 ; |   X X X| $FED0
    .byte $17 ; |   X XXX| $FED1
    .byte $1A ; |   XX X | $FED2
    .byte $33 ; |  XX  XX| $FED3
    .byte $33 ; |  XX  XX| $FED4
    .byte $13 ; |   X  XX| $FED5
    .byte $11 ; |   X   X| $FED6
    .byte $17 ; |   X XXX| $FED7
    .byte $15 ; |   X X X| $FED8
    .byte $3A ; |  XXX X | $FED9
    .byte $3A ; |  XXX X | $FEDA
    .byte $1A ; |   XX X | $FEDB
    .byte $15 ; |   X X X| $FEDC
    .byte $17 ; |   X XXX| $FEDD
    .byte $1A ; |   XX X | $FEDE
    .byte $1D ; |   XXX X| $FEDF
    .byte $0E ; |    XXX | $FEE0
    .byte $0F ; |    XXXX| $FEE1
    .byte $11 ; |   X   X| $FEE2
    .byte $13 ; |   X  XX| $FEE3
    .byte $85 ; |X    X X| $FEE4
    .byte $13 ; |   X  XX| $FEE5
    .byte $1A ; |   XX X | $FEE6
    .byte $15 ; |   X X X| $FEE7
    .byte $17 ; |   X XXX| $FEE8
    .byte $1A ; |   XX X | $FEE9
    .byte $1D ; |   XXX X| $FEEA
    .byte $8A ; |X   X X | $FEEB
    .byte $08 ; |    X   | $FEEC
    .byte $60 ; | XX     | $FEED
    .byte $8A ; |X   X X | $FEEE
    .byte $0A ; |    X X | $FEEF
    .byte $8A ; |X   X X | $FEF0
    .byte $06 ; |     XX | $FEF1
    .byte $8A ; |X   X X | $FEF2
    .byte $14 ; |   X X  | $FEF3
    .byte $13 ; |   X  XX| $FEF4
    .byte $12 ; |   X  X | $FEF5
    .byte $11 ; |   X   X| $FEF6
    .byte $10 ; |   X    | $FEF7
    .byte $0F ; |    XXXX| $FEF8
    .byte $0E ; |    XXX | $FEF9
    .byte $0D ; |    XX X| $FEFA
    .byte $0C ; |    XX  | $FEFB
    .byte $0B ; |    X XX| $FEFC
    .byte $0A ; |    X X | $FEFD
    .byte $09 ; |    X  X| $FEFE
    .byte $8A ; |X   X X | $FEFF
LFF00:
    .byte $00 ; |        | $FF00
    .byte $78 ; | XXXX   | $FF01
    .byte $7C ; | XXXXX  | $FF02
    .byte $FE ; |XXXXXXX | $FF03
    .byte $FE ; |XXXXXXX | $FF04
    .byte $FE ; |XXXXXXX | $FF05
    .byte $FE ; |XXXXXXX | $FF06
    .byte $FE ; |XXXXXXX | $FF07
    .byte $DC ; |XX XXX  | $FF08
    .byte $D8 ; |XX XX   | $FF09
    .byte $D8 ; |XX XX   | $FF0A
    .byte $D8 ; |XX XX   | $FF0B
    .byte $D8 ; |XX XX   | $FF0C
    .byte $D8 ; |XX XX   | $FF0D
    .byte $D8 ; |XX XX   | $FF0E
    .byte $C0 ; |XX      | $FF0F
LFF10:
    .byte $00 ; |        | $FF10
    .byte $AA ; |X X X X | $FF11
    .byte $FF ; |XXXXXXXX| $FF12
    .byte $BF ; |X XXXXXX| $FF13
    .byte $BF ; |X XXXXXX| $FF14
    .byte $FF ; |XXXXXXXX| $FF15
    .byte $FF ; |XXXXXXXX| $FF16
    .byte $BF ; |X XXXXXX| $FF17
    .byte $FF ; |XXXXXXXX| $FF18
LFF19:
    .byte $2B ; |  X X XX| $FF19
LFF1A:
    .byte $00 ; |        | $FF1A
LFF1B:
    .byte $00 ; |        | $FF1B
LFF1C:
    .byte $03 ; |      XX| $FF1C   AUDC0, AUDC1
    .byte $08 ; |    X   | $FF1D
    .byte $04 ; |     X  | $FF1E
    .byte $06 ; |     XX | $FF1F
    .byte $01 ; |       X| $FF20
    .byte $0C ; |    XX  | $FF21
LFF22:
    .byte $0C ; |    XX  | $FF22   AUDF0, AUDF1
    .byte $04 ; |     X  | $FF23
    .byte $06 ; |     XX | $FF24
    .byte $08 ; |    X   | $FF25
    .byte $08 ; |    X   | $FF26
    .byte $0E ; |    XXX | $FF27
    .byte $03 ; |      XX| $FF28
    .byte $1B ; |   XX XX| $FF29
    .byte $06 ; |     XX | $FF2A
    .byte $00 ; |        | $FF2B
    .byte $06 ; |     XX | $FF2C
LFF2D:
    .byte $0A ; |    X X | $FF2D
    .byte $14 ; |   X X  | $FF2E
    .byte $28 ; |  X X   | $FF2F
    .byte $22 ; |  X   X | $FF30
LFF31:
    .byte $01 ; |       X| $FF31
    .byte $02 ; |      X | $FF32
    .byte $04 ; |     X  | $FF33
    .byte $08 ; |    X   | $FF34
    .byte $10 ; |   X    | $FF35
    .byte $20 ; |  X     | $FF36
    .byte $40 ; | X      | $FF37
    .byte $80 ; |X       | $FF38
    .byte $27 ; |  X  XXX| $FF39
    .byte $0C ; |    XX  | $FF3A
    .byte $05 ; |     X X| $FF3B
    .byte $09 ; |    X  X| $FF3C
LFF3D:
    .byte $03 ; |      XX| $FF3D
    .byte $05 ; |     X X| $FF3E
    .byte $07 ; |     XXX| $FF3F
    .byte $27 ; |  X  XXX| $FF40
LFF41:
    .byte $F3 ; |XXXX  XX| $FF41   AUDV1 | AUDF1
    .byte $B3 ; |X XX  XX| $FF42
    .byte $4C ; | X  XX  | $FF43
    .byte $2C ; |  X XX  | $FF44
    .byte $7A ; | XXXX X | $FF45
    .byte $7A ; | XXXX X | $FF46
    .byte $4C ; | X  XX  | $FF47
    .byte $2C ; |  X XX  | $FF48
    .byte $17 ; |   X XXX| $FF49
    .byte $12 ; |   X  X | $FF4A
    .byte $0B ; |    X XX| $FF4B
    .byte $0C ; |    XX  | $FF4C
LFF4D:
    .byte $EC ; |XXX XX  | $FF4D   AUDC1
    .byte $EC ; |XXX XX  | $FF4E
    .byte $EC ; |XXX XX  | $FF4F
    .byte $E4 ; |XXX  X  | $FF50
    .byte $EC ; |XXX XX  | $FF51
    .byte $EC ; |XXX XX  | $FF52
    .byte $EC ; |XXX XX  | $FF53
    .byte $E8 ; |XXX X   | $FF54
    .byte $EC ; |XXX XX  | $FF55
    .byte $EC ; |XXX XX  | $FF56
LFF57:
    .byte $00 ; |        | $FF57
    .byte $01 ; |       X| $FF58
    .byte $01 ; |       X| $FF59
    .byte $01 ; |       X| $FF5A
    .byte $01 ; |       X| $FF5B
    .byte $02 ; |      X | $FF5C
    .byte $00 ; |        | $FF5D
    .byte $01 ; |       X| $FF5E
    .byte $00 ; |        | $FF5F
    .byte $01 ; |       X| $FF60
    .byte $01 ; |       X| $FF61
    .byte $02 ; |      X | $FF62
    .byte $03 ; |      XX| $FF63
    .byte $03 ; |      XX| $FF64
LFF65:
    .byte $01 ; |       X| $FF65
    .byte $01 ; |       X| $FF66
    .byte $81 ; |X      X| $FF67
    .byte $C0 ; |XX      | $FF68
    .byte $30 ; |  XX    | $FF69
    .byte $01 ; |       X| $FF6A
    .byte $21 ; |  X    X| $FF6B
    .byte $21 ; |  X    X| $FF6C
    .byte $81 ; |X      X| $FF6D
LFF6E:
    .byte $01 ; |       X| $FF6E
    .byte $02 ; |      X | $FF6F
    .byte $02 ; |      X | $FF70
    .byte $03 ; |      XX| $FF71
    .byte $03 ; |      XX| $FF72
    .byte $03 ; |      XX| $FF73
    .byte $03 ; |      XX| $FF74
    .byte $03 ; |      XX| $FF75
    .byte $C1 ; |XX     X| $FF76
    .byte $C2 ; |XX    X | $FF77
    .byte $C1 ; |XX     X| $FF78
    .byte $C1 ; |XX     X| $FF79
    .byte $C3 ; |XX    XX| $FF7A
    .byte $C3 ; |XX    XX| $FF7B
LFF7C:
    .byte $B2 ; |X XX  X | $FF7C
    .byte $32 ; |  XX  X | $FF7D
    .byte $32 ; |  XX  X | $FF7E
    .byte $F2 ; |XXXX  X | $FF7F
    .byte $F2 ; |XXXX  X | $FF80
    .byte $72 ; | XXX  X | $FF81
    .byte $B4 ; |X XX X  | $FF82
    .byte $34 ; |  XX X  | $FF83
    .byte $B3 ; |X XX  XX| $FF84
    .byte $F3 ; |XXXX  XX| $FF85
    .byte $F3 ; |XXXX  XX| $FF86
    .byte $33 ; |  XX  XX| $FF87
    .byte $F2 ; |XXXX  X | $FF88
    .byte $F1 ; |XXXX   X| $FF89
LFF8A:
    .byte $00 ; |        | $FF8A
    .byte $60 ; | XX     | $FF8B
    .byte $60 ; | XX     | $FF8C
    .byte $06 ; |     XX | $FF8D
    .byte $06 ; |     XX | $FF8E
    .byte $00 ; |        | $FF8F
    .byte $00 ; |        | $FF90
    .byte $60 ; | XX     | $FF91
    .byte $00 ; |        | $FF92
    .byte $60 ; | XX     | $FF93
    .byte $06 ; |     XX | $FF94
    .byte $00 ; |        | $FF95
    .byte $06 ; |     XX | $FF96
    .byte $60 ; | XX     | $FF97
LFF98:
    .byte $06 ; |     XX | $FF98
    .byte $00 ; |        | $FF99
    .byte $00 ; |        | $FF9A
    .byte $06 ; |     XX | $FF9B
    .byte $06 ; |     XX | $FF9C
    .byte $60 ; | XX     | $FF9D
    .byte $06 ; |     XX | $FF9E
LFF9F:
    .byte $60 ; | XX     | $FF9F
    .byte $41 ; | X     X| $FFA0
    .byte $18 ; |   XX   | $FFA1
    .byte $18 ; |   XX   | $FFA2
    .byte $20 ; |  X     | $FFA3
    .byte $01 ; |       X| $FFA4
    .byte $11 ; |   X   X| $FFA5
    .byte $61 ; | XX    X| $FFA6
    .byte $19 ; |   XX  X| $FFA7
    .byte $19 ; |   XX  X| $FFA8
    .byte $01 ; |       X| $FFA9
    .byte $1F ; |   XXXXX| $FFAA
    .byte $09 ; |    X  X| $FFAB
    .byte $41 ; | X     X| $FFAC
    .byte $CF ; |XX  XXXX| $FFAD
LFFAE:
    .byte BLACK          ; $FFAE   color dancing girl P0
    .byte BLUE_CYAN      ; $FFAF
    .byte BLUE_CYAN      ; $FFB0
    .byte BLUE_CYAN      ; $FFB1
    .byte BLACK          ; $FFB2
    .byte BLACK          ; $FFB3
    .byte BLACK          ; $FFB4
    .byte BLACK          ; $FFB5
    .byte PURPLE+2       ; $FFB6
    .byte PURPLE+2       ; $FFB7
    .byte PURPLE+2       ; $FFB8
    .byte PURPLE+2       ; $FFB9
    .byte PURPLE+2       ; $FFBA
    .byte PURPLE+2       ; $FFBB
    .byte PURPLE+2       ; $FFBC
    .byte PURPLE+2       ; $FFBD
    .byte PURPLE+2       ; $FFBE
    .byte PURPLE+2       ; $FFBF
    .byte BLACK+1        ; $FFC0
    .byte BLACK+1        ; $FFC1
    .byte BLACK+1        ; $FFC2
    .byte BLACK+1        ; $FFC3
    .byte BLACK+1        ; $FFC4
    .byte BLACK+1        ; $FFC5
    .byte BLACK+1        ; $FFC6
    .byte BLACK+1        ; $FFC7
LFFC8:
    .byte ORANGE+4       ; $FFC8   color dancing girl P1
    .byte ORANGE+4       ; $FFC9
    .byte ORANGE+4       ; $FFCA
    .byte ORANGE+4       ; $FFCB
    .byte ORANGE+4       ; $FFCC
    .byte ORANGE+4       ; $FFCD
    .byte ORANGE+4       ; $FFCE
    .byte ORANGE+4       ; $FFCF
    .byte ORANGE+4       ; $FFD0
    .byte ORANGE+4       ; $FFD1
    .byte ORANGE+4       ; $FFD2
    .byte ORANGE+4       ; $FFD3
    .byte ORANGE+4       ; $FFD4
    .byte ORANGE+4       ; $FFD5
    .byte ORANGE+4       ; $FFD6
    .byte ORANGE+4       ; $FFD7
    .byte BLUE_CYAN      ; $FFD8
    .byte BLUE_CYAN      ; $FFD9
    .byte ORANGE+4       ; $FFDA
    .byte ORANGE+4       ; $FFDB
    .byte ORANGE+4       ; $FFDC
    .byte ORANGE+4       ; $FFDD
    .byte ORANGE+4       ; $FFDE
    .byte ORANGE+4       ; $FFDF
    .byte ORANGE+4       ; $FFE0
    .byte ORANGE+4       ; $FFE1

LFFE2:
    .byte $50 ; | X X    | $FFE2
    .byte $80 ; |X       | $FFE3
    .byte $75 ; | XXX X X| $FFE4
    .byte $D0 ; |XX X    | $FFE5
LFFE6:
    .byte $03 ; |      XX| $FFE6
    .byte $50 ; | X X    | $FFE7
    .byte $28 ; |  X X   | $FFE8
    .byte $81 ; |X      X| $FFE9
    .byte $03 ; |      XX| $FFEA
    .byte $E7 ; |XXX  XXX| $FFEB
    .byte $90 ; |X  X    | $FFEC
    .byte $24 ; |  X  X  | $FFED
    .byte $CD ; |XX  XX X| $FFEE
    .byte $9F ; |X  XXXXX| $FFEF
    .byte $ED ; |XXX XX X| $FFF0
    .byte $EC ; |XXX XX  | $FFF1
    .byte $EF ; |XXX XXXX| $FFF2
    .byte $F1 ; |XXXX   X| $FFF3
    .byte $E5 ; |XXX  X X| $FFF4
    .byte $F3 ; |XXXX  XX| $FFF5
    .byte $FF ; |XXXXXXXX| $FFF6
    .byte $FF ; |XXXXXXXX| $FFF7

        ORG $1FF8
       RORG $FFF8

LFFF8:
    .byte $FF ; |XXXXXXXX| $FFF8
LFFF9:
    .byte $FF ; |XXXXXXXX| $FFF9

    .word LF000,LF000,LF000
