;****************************************************************
;Macro to call the load_and_draw subroutine
;{1} = name of the table of addresses
;{2} = height of the graphic

	MAC mac_load_and_draw

	lda	#<{1}
	sta	temp0
	lda	#>{1}
	sta	temp1
	lda	#{2}-1	;one less than the actual height
	jsr load_and_draw

	ENDM

;****************************************************************