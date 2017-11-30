;graphics
MW_CLASSIC = 0
;snake head graphics
snake_heads
no_head
	dc	%00000000
	dc	%00000000
	dc	%00000000
snake_left
	dc	%00011100
	dc	%00111100
	dc	%00011100
snake_up
	dc	%00011000
	dc	%00111100
	dc	%00111100
snake_right
	dc	%00111000
	dc	%00111100
	dc	%00111000
snake_down
	dc	%00111100
	dc	%00111100
	dc	%00011000


score_digits
digit_0
	dc	%01111110
	dc	%11111111
	dc	%11100111
	dc	%11000011
	dc	%11000011
	dc	%11100111
	dc	%11111111
	dc	%01111110
digit_1
	dc	%00011100
	dc	%00111100
	dc	%01111100
	dc	%00011100
	dc	%00011100
	dc	%00011100
	dc	%01111111
	dc	%01111111
digit_2
	dc	%11111111
	dc	%11111111
	dc	%00001111
	dc	%00001111
	dc	%11111111
	dc	%11100000
	dc	%11100000
	dc	%11111111
digit_3
	dc	%11111111
	dc	%11111111
	dc	%00000111
	dc	%00000111
	dc	%11111111
	dc	%00000111
	dc	%00000111
	dc	%11111111
digit_4
	dc	%11100111
	dc	%11100111
	dc	%11100111
	dc	%11100111
	dc	%11111111
	dc	%00000111
	dc	%00000111
	dc	%00000111
digit_5
	dc	%11111111
	dc	%11111111
	dc	%11110000
	dc	%11110000
	dc	%11111111
	dc	%00000111
	dc	%00000111
	dc	%11111111
digit_6
	dc	%11111111
	dc	%11000000
	dc	%11000000
	dc	%11111111
	dc	%11111111
	dc	%11000111
	dc	%11000111
	dc	%11111111
digit_7
	dc	%11111111
	dc	%11111111
	dc	%11001111
	dc	%00001111
	dc	%00001111
	dc	%00001111
	dc	%00001111
	dc	%00001111
digit_8
	dc	%11111111
	dc	%11000111
	dc	%11000111
	dc	%11111111
	dc	%11111111
	dc	%11000111
	dc	%11000111
	dc	%11111111
digit_9
	dc	%11111111
	dc	%11000111
	dc	%11000111
	dc	%11111111
	dc	%11111111
	dc	%00000111
	dc	%00000111
	dc	%11111111
	
	;org $fd00
baroque_gaming_table ; address table for "Baroque Gaming"
	.byte	<gaming1
	.byte	>gaming1
	.byte	<gaming2
	.byte	>gaming2
	.byte	<gaming3
	.byte	>gaming3
	.byte	<gaming4
	.byte	>gaming4
	.byte	<gaming5
	.byte	>gaming5
	.byte	<gaming6
	.byte	>gaming6
		
	IF	MW_CLASSIC = 1	

;midwest_classic_table ; address table for "midwest classic"
;	.byte	<midwest1
;	.byte	>midwest1
;	.byte	<midwest2
;	.byte	>midwest2
;	.byte	<midwest3
;	.byte	>midwest3
;	.byte	<midwest4
;	.byte	>midwest4
;	.byte	<midwest5
;	.byte	>midwest5
;	.byte	<midwest6
;	.byte	>midwest6

;gaming1	.byte	$01,$02,$02,$02,$02,$02,$01,$00,$00
;		.byte	$04,$04,$04,$04,$05,$06,$04,$00,$00
		
;gaming2	.byte	$E4,$15,$05,$05,$04,$14,$E4,$00,$00
;		.byte	$14,$15,$95,$95,$54,$30,$14,$00,$00
		
;gaming3	.byte	$EB,$10,$11,$12,$F1,$00,$00,$00,$00
;		.byte	$E3,$15,$15,$15,$F4,$10,$10,$00,$00
		
;gaming4	.byte	$CF,$20,$C7,$08,$E7,$00,$00,$00,$00
;		.byte	$8F,$50,$5F,$51,$4E,$00,$00,$00,$00
		
;gaming5	.byte	$27,$A8,$28,$28,$A7,$00,$20,$00,$00
;		.byte	$78,$04,$38,$40,$3D,$00,$00,$00,$00
		
;gaming6	.byte	$00,$80,$00,$80,$00,$00,$00,$00,$00
;		.byte	$80,$80,$80,$80,$C0,$80,$00,$00,$00
		
	ELSE


;graphics for Baroque and Gaming, interleaved so I can display them 
;seperately or in one load
gaming1		.byte	$00,$00,$0f,$18,$10,$11,$10,$18,$0f
baroque1	.byte	$00,$00,$fc,$42,$42,$7c,$44,$44,$f8
gaming2		.byte	$00,$00,$8e,$d1,$51,$d1,$0f,$c0,$80
baroque2	.byte	$00,$00,$75,$89,$89,$89,$79,$00,$00
gaming3		.byte	$00,$00,$a2,$22,$22,$32,$2d,$00,$00
baroque3	.byte	$00,$00,$03,$04,$14,$94,$63,$00,$00
gaming4		.byte	$00,$00,$25,$29,$29,$69,$81,$08,$00
baroque4	.byte	$00,$01,$8f,$51,$51,$51,$8e,$00,$00
gaming5		.byte	$03,$04,$13,$14,$14,$94,$63,$00,$00
baroque5	.byte	$80,$40,$5d,$22,$22,$22,$22,$00,$00
gaming6		.byte	$80,$40,$c0,$40,$40,$40,$80,$00,$00
baroque6	.byte	$00,$00,$3c,$40,$7c,$44,$38,$00,$00

	EIF







;baroque_table	; address table for "Baroque"
;	.byte	<baroque1
;	.byte	>baroque1
;	.byte	<baroque2
;	.byte	>baroque2
;	.byte	<baroque3
;	.byte	>baroque3
;	.byte	<baroque4
;	.byte	>baroque4
;	.byte	<baroque5
;	.byte	>baroque5
;	.byte	<baroque6
;	.byte	>baroque6

;gaming_table
;	.byte	<gaming1
;	.byte	>gaming1
;	.byte	<gaming2
;	.byte	>gaming2
;	.byte	<gaming3
;	.byte	>gaming3
;	.byte	<gaming4
;	.byte	>gaming4
;	.byte	<gaming5
;	.byte	>gaming5
;	.byte	<gaming6
;	.byte	>gaming6
	IF	MW_CLASSIC = 1
presents1
	.byte	$00,$00,$00,$00,$00,$00,$00
presents2
	.byte	$F9,$82,$82,$F2,$81,$80,$F8
presents3
	.byte	$C9,$29,$29,$29,$EB,$21,$28
presents4
	.byte	$27,$28,$28,$28,$A7,$00,$20
presents5
	.byte	$22,$A2,$A2,$B2,$2C,$00,$00
presents6
	.byte	$00,$00,$00,$00,$00,$00,$00

	ELSE
presents1
	.byte	$e1,$41,$41,$79,$45,$44,$F8
presents2
	.byte	$03,$04,$17,$94,$63,$00,$00
presents3
	.byte	$de,$01,$ce,$50,$8f,$00,$00
presents4
	.byte	$3d,$41,$7d,$45,$39,$00,$00
presents5
	.byte	$11,$12,$12,$92,$67,$02,$00
presents6
	.byte	$78,$04,$38,$40,$3c,$00,$00
	EIF
	
presents_table
	.byte	<presents1
	.byte	>presents1
	.byte	<presents2
	.byte	>presents2
	.byte	<presents3
	.byte	>presents3
	.byte	<presents4
	.byte	>presents4
	.byte	<presents5
	.byte	>presents5
	.byte	<presents6
	.byte	>presents6
	
	
copyright1
	.byte	$00,$00,$00,$00,$00,$00,$00
copyright2
	.byte	$07,$08,$17,$14,$17,$08,$07
copyright3
	.byte	$1e,$90,$48,$44,$42,$92,$0c
copyright4
	.byte	$63,$94,$94,$94,$94,$94,$63
copyright5
	.byte	$3c,$A0,$90,$88,$84,$A4,$18
copyright6
	.byte	$00,$00,$00,$00,$00,$00,$00

copyright_table
	.byte	<copyright1
	.byte	>copyright1
	.byte	<copyright2
	.byte	>copyright2
	.byte	<copyright3
	.byte	>copyright3
	.byte	<copyright4
	.byte	>copyright4
	.byte	<copyright5
	.byte	>copyright5
	.byte	<copyright6
	.byte	>copyright6

;electronic1
;	.byte	$00,$f4,$85,$85,$e5,$84,$84,$f4
;electronic2
;	.byte	$00,$f3,$04,$f4,$14,$e3,$00,$00
;electronic3
;	.byte	$00,$89,$49,$09,$49,$9d,$08,$00
;electronic4
;	.byte	$00,$03,$04,$14,$94,$63,$00,$00
;electronic5
;	.byte	$00,$91,$51,$51,$59,$96,$00,$00
;electronic6
;	.byte	$00,$4e,$51,$50,$51,$4e,$00,$40
	
;electronic_table
;	.byte	<electronic1
;	.byte	>electronic1
;	.byte	<electronic2
;	.byte	>electronic2
;	.byte	<electronic3
;	.byte	>electronic3
;	.byte	<electronic4
;	.byte	>electronic4
;	.byte	<electronic5
;	.byte	>electronic5
;	.byte	<electronic6
;	.byte	>electronic6
	
;games1
;	.byte	$00,$00,$01,$01,$01,$01,$01,$00
;games2
;	.byte	$00,$f3,$14,$14,$34,$03,$10,$e0
;games3
;	.byte	$00,$a8,$48,$48,$4c,$cb,$00,$00
;games4
;	.byte	$00,$93,$94,$97,$94,$63,$00,$00
;games5
;	.byte	$00,$de,$01,$ce,$50,$8f,$00,$00
;games6
;	.byte	$00,$00,$00,$00,$00,$00,$00,$00

;games_table
;	.byte	<games1
;	.byte	>games1
;	.byte	<games2
;	.byte	>games2
;	.byte	<games3
;	.byte	>games3
;	.byte	<games4
;	.byte	>games4
;	.byte	<games5
;	.byte	>games5
;	.byte	<games6
;	.byte	>games6
	
;expo1
;	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00
;expo2
;	.byte	$00,$00,$07,$04,$04,$07,$04,$04,$07
;expo3
;	.byte	$00,$00,$a2,$14,$08,$14,$22,$00,$00
;expo4
;	.byte	$80,$80,$f1,$8a,$8a,$8a,$71,$00,$00
;expo5
;	.byte	$00,$00,$c0,$20,$20,$20,$c0,$00,$00
;expo6
;	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00

;expo_table
;	.byte	<expo1
;	.byte	>expo1
;	.byte	<expo2
;	.byte	>expo2
;	.byte	<expo3
;	.byte	>expo3
;	.byte	<expo4
;	.byte	>expo4
;	.byte	<expo5
;	.byte	>expo5
;	.byte	<expo6
;	.byte	>expo6
	

;play field looks like this
;  |leftpf1 |leftpf2 |rightpf2|rightpf1| 
;--+--------+--------+--------+--------+
;  |76543210|01233457|76543210|01234567|
;--+--------+--------+--------+--------+
;\X|        |  111111|11112222|22222233|
;Y\|01234567|89012345|67890123|45678901|
;--+--------+--------+--------+--------+
;22| 
; ||
; 0|

Wormy_Blast
WBlpf1
	;.byte	$78,$46,$42,$7e,$44,$64,$1c
	.byte	$78,$4e,$4a,$4a,$4a,$42,$02
	.byte	$00,$3a,$ea,$ab,$aa,$aa,$89,$81
	;.byte	$00,$78,$4e,$4a,$4a,$4a,$42,$02

WBlpf2
	;.byte	$58,$47,$c1,$81,$81,$81,$01
	.byte	$47,$59,$d1,$51,$51,$53,$dc
	.byte	$00,$40,$4a,$4a,$7b,$2a,$2a,$39
	;.byte	$00,$47,$59,$d1,$51,$51,$53,$dc
WBrpf2
	;.byte	$00,$17,$90,$77,$34,$a4,$e7
	.byte	$08,$28,$28,$e9,$49,$49,$cf
	.byte	$00,$85,$95,$95,$f5,$a5,$a5,$e4
	;.byte	$00,$08,$28,$28,$e9,$49,$49,$cf
WBrpf1
	;.byte	$27,$24,$24,$27,$20,$3b,$e0
	.byte	$1a,$62,$42,$7a,$0a,$1b,$60
	.byte	$00,$e0,$b4,$94,$d6,$15,$94,$74
	;.byte	$00,$22,$22,$3a,$ca,$8a,$8b,$80

	;!!!!!!!!!!!!!!!!!!!!!!!!!
;!!!!!!!!!!!!!!!!!!!!!!!!!
;missile_enables cannot pass a page boundary or it will
;mess up the fieldraw routine
;	org $fc10
missile_enables
	ds	66
	dc	$02
	ds	69

Play0
	ds	23
Play1
	ds	4
	ds	4,$3c
	ds	7
	ds	4,$3c
	ds	4
Play2
	ds	2
	ds	7,$18
	ds  5
	ds	7,$18
	ds	2
Play3
	ds  1
	ds	2,$18
	ds  4
	ds	2,$18
	ds  5
	ds	2,$18
	ds  4
	ds	2,$18
	ds  1 
Play4
	ds	4
	ds	6,$7e
	ds	3	
	ds	6,$7e
	ds	4


Playfields
Playfield0
	.byte	<Play0
	.byte	>Play0
	.byte	<Play0
	.byte	>Play0
Playfield1
	.byte	<Play0
	.byte	>Play0
	.byte	<Play4
	.byte	>Play4
Playfield2
	.byte	<Play2
	.byte	>Play2
	.byte	<Play1
	.byte	>Play1
Playfield3
	.byte	<Play1
	.byte	>Play1
	.byte	<Play2
	.byte	>Play2
Playfield4
	.byte	<Play3
	.byte	>Play3
	.byte	<Play1
	.byte	>Play1
Playfield5
	.byte	<Play1
	.byte	>Play1
	.byte	<Play3
	.byte	>Play3
Playfield6
	.byte	<Play2
	.byte	>Play2
	.byte	<Play0
	.byte	>Play0
Playfield7
	.byte	<Play1
	.byte	>Play1
	.byte	<Play0
	.byte	>Play0
