
        processor 6502


Cart_Init	equ	$F000

		org	$0000
                incbin	"boingcode.bin"
             
		org	$0400
                include "PCX\frame0.s"
                org	$0700
                include "PCX\frame1.s"
                org	$0A00
                include "PCX\frame2.s"
                org	$0D00
                include "PCX\frame3.s"
                
                org	$0ffa
		.word   Cart_Init	; NMI
		.word   Cart_Init	; Reset
		.word   Cart_Init	; IRQ

		org	$1000
                incbin	"boingcode.bin"
		org	$1400
                include "PCX\frame4.s"
                org	$1700
                include "PCX\frame5.s"
                org	$1A00
                include "PCX\frame6.s"
                org	$1D00
;                include "PCX\frame0.s"
        
                org	$1ffa
		.word   Cart_Init	; NMI
		.word   Cart_Init	; Reset
		.word   Cart_Init	; IRQ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Set up the 6502 interrupt vector table
;
		org	IntVectors
        
;		END


