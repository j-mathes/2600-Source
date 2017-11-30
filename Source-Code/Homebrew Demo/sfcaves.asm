; http://www.biglist.com/lists/stella/archives/200010/msg00002.html
;
;Well, after much talk about it not being possible, I think I've gotten
;past the hardest part.  Well, mostly ;-)
;
;I've got the 4 line kernal to draw the cave.(4 line like in Thrust)
;However, I need some more cycle time to do the ribbon.  
;
;For reference, SFCaves is a game where you are a ribbon moving through a
;cave horizontally as it shrinks.  The cave I am doing is generated
;(psuedo)randomly, so all the cave data must be stored in ram.  Add to this
;the fact that it is a horizontal scroller, and suddenly the kernal became
;a mess.  (Such a mess that I don't even use WSYNC; not enough time)
;
;As I see it, currently I only have 4 cycles left, but I'm pretty sure that
;I'm going to need at least 7, probably more to make it work well.(I need
;to load and store the player object graphics register.)  These 4 come from
;the fact that I think there is 1 cycle left, and I can get rid of the last
;remaining WSYNC if I time out the last line right.
;
;Side note: can someone clarify for me, is a BEQ that is not taken 3 or 4
;cycles?
;
;Anyway, here is the 4-line kernal section.  If anyone could take a look at
;it and see if there are any way's to save some more cycles, and/or check
;that my cycle counts are correct, I would much appreciated it.
;
;
;Explaination of code: 
;
;-I use 2 lines to do the computations for the cave top, then the next two
;lines to do the computations for the bottom of the caves.  This way I
;don't have to deal with a complex line where on the same line is the top
;of the cave and the bottom of the cave(which would happen when the cave
;goes down or up sharply.).
;
;-leftcave and rightcave are the ram tables holding the state of the cave
;on screen.
;
;-cavedataxy are rom tables holding screen data
;
;-pfdatax are memory locations
;
;-height is a memory location indicating the number of lines between the
;cave top and bottom.  Yes I know that in the cave bottom where I use this,
;I am indexing off the end of the cave data in memory, I have a solution
;for this that will be implemented later.(it doesn't take any extra cycles)
;
;-I really don't like those CLC and SEC, but havn't found a way to get rid
;of some of them yet.
;
;-I think my method of clearing PF0-2 for the odd lines is clumsy, but I
;can't come up with a better method.  Ideas?
;
;-I'm going to need to copy the kernal at least 4 times in the code, so I'd
;like to get it solid before I copy it so that I don't have to try to
;maintain 4 copies of code seperately.
;
;
;So, what do people think?
;
;When I get the kernal copied, and get the cave generation routine going, I
;will post a bin showing what I'm talking about.
;
;Mark De Smet
;


	LDX #40		;number of 'lines' where a line is 4 lines.
			;  (ie. 4 line kernal)


	LDA #00		;2

			;this section is for the downward or down then up cave type.
loopcave1
	STA WSYNC	;3


	STA PF0		;3
	STA PF1		;3
	STA PF2		;3

	LDA currleftcol	;3 ;load the column from last line.

	CLC		;2

	ADC leftcave,X	;45 ;add on the shift.
	STA currleftcol	;3 ;save the result for next line.
	TAY		;2 ;put result into Y for indexing.
	LDA cavedata1a,Y;45;load the first byte.
	STA pfdata1	;3 ;store for playfield data 1
	LDA cavedata1b,Y;45;load the second byte.
	STA pfdata2	;3 ;store for playfield data 2
	LDA cavedata1c,Y;45;load the third byte.
	STA pfdata3	;3 ;store for playfield data 3
			;44
	LDA cavedata1d,Y;45;load the forth byte.
	STA pfdata4	;3 ;store for playfield data 4
	LDA cavedata1e,Y;45 ;load the fifth byte.
	STA pfdata5	;3 ;store for playfield data 5
	LDA cavedata1f,Y;45 ;load the sixth byte.
	STA pfdata6	;3 ;store for playfield data 6
			;65
	LDA currrightcol;3 ;load the column from last line.

	SEC		;2

	SBC rightcave,X	;45 ;add on the shift.
			;74
	TAY		;2 ;put result into Y for indexing.
			;76!!!
;	STA WSYNC	;3

	STA currrightcol;3 ;save the result for next line.
	LDA cavedata2a,Y;45;load the first byte.
	AND pfdata1	;3 ;and the halves togather, and load!
	STA PF0		;3
	LDA cavedata2b,Y;45;load second byte.
	AND pfdata2	;3 ;and the halves togather, and load!
	STA PF1		;3
	LDA cavedata2c,Y;45;load third byte.
	AND pfdata3	;3 ;and the halves togather, and load!
	STA PF2		;3
			;33
	LDA cavedata2d,Y;45;load the first byte.
	AND pfdata4	;3 ;and the halves togather, and load!
	STA PF0		;3
	LDA cavedata2e,Y;45;load second byte.
	AND pfdata5	;3 ;and the halves togather, and load!
	STA PF1		;3
	LDA cavedata2f,Y;45;load third byte.
	AND pfdata6	;3 ;and the halves togather, and load!
	STA PF2		;3
			;63

	TXA		;2
	ADC height	;3
	TAY		;2

	LDA #00		;2

	SEC		;2
			;74
;	STA WSYNC	;3


			;74
	STA PF0		;3
			;1
	STA PF1		;3
	STA PF2		;3


	LDA currrightcolb;3 ;load the column from last line.
	SBC rightcave,Y	 ;45 ;add on the shift.
	STA currrightcolb;3 ;save the result for next line.

	LDA currleftcolb ;3 ;load the column from last line.

	CLC		;2

	ADC leftcave,Y	;45 ;add on the shift.
	STA currleftcolb;3 ;save the result for next line.
	TAY		;2 ;put result into Y for indexing.
	LDA cavedata2a,Y;45;load the first byte.
	STA pfdata1	;3 ;store for playfield data 1
	LDA cavedata2b,Y;45;load the second byte.
	STA pfdata2	;3 ;store for playfield data 2
	LDA cavedata2c,Y;45;load the third byte.
	STA pfdata3	;3 ;store for playfield data 3
			;52
	LDA cavedata2d,Y;45;load the forth byte.
	STA pfdata4	;3 ;store for playfield data 4
	LDA cavedata2e,Y;45 ;load the fifth byte.
	STA pfdata5	;3 ;store for playfield data 5
	LDA cavedata2f,Y;45 ;load the sixth byte.
	STA pfdata6	;3 ;store for playfield data 6
			;73


;	STA WSYNC	;3
			;73
	LDY currrightcolb;3 ;load column for this line(already computed)
			;76!!!!

	LDA cavedata1a,Y;45;load the first byte.
	ORA pfdata1	;3 ;and the halves togather, and load!
	STA PF0		;3
	LDA cavedata1b,Y;45;load second byte.
	ORA pfdata2	;3 ;and the halves togather, and load!
	STA PF1		;3
	LDA cavedata1c,Y;45;load third byte.
	ORA pfdata3	;3 ;and the halves togather, and load!
	STA PF2		;3
			;30
	LDA cavedata1d,Y;45;load the first byte.
	ORA pfdata4	;3 ;and the halves togather, and load!
	STA PF0		;3
	LDA cavedata1e,Y;45;load second byte.
	ORA pfdata5	;3 ;and the halves togather, and load!
	STA PF1		;3
	LDA cavedata1f,Y;45;load third byte.
	ORA pfdata6	;3 ;and the halves togather, and load!
	STA PF2		;3
			;60



	LDA #00		;2
	DEX		;2 ;move counter
			;64
;	BNE loopcave1	;check if done, otherwise, loop.
	BEQ noloopcave1	;34;check if done, otherwise, loop.
	JMP loopcave1	;3
noloopcave1

	STA WSYNC	;3



