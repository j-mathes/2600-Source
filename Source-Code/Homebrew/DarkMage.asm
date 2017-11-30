;;Z26.ASM
;;
;;A text adventure game/engine for the Atari 2600
;;	
;;	100% Freeware
;;	by Greg Troutman, 1997
;;	
;;	Copy Instructions: fiendishly
;;
;;Source is compatible with v2.12 of DASM.
;;
;;The compiled image, as distributed by me, runs
;;fine on the STELLA and V2600 emulators for Linux,
;;as well as on a Supercharger-equipped 2600 via
;;Bob Colbert's MAKEWAV utility.  It plays much 
;;better on TV than on an emulator...
;;------------------------------------------------

	processor 6502	
	include vcs.h	

; Zero page addresses for our RAM variables
;-------------------------------------------
frame equ $80
temp equ $81
temp2 equ $82
grfxBuffer equ $83 ;24 bytes
scanSec equ grfxBuffer + 24 ;1
currentText equ scanSec + 1 ;2
currentMenu equ currentText + 2 ;2
menuChoice equ currentMenu + 2 ;1
mapLoc equ menuChoice + 2 ;1
jmpSelect equ mapLoc + 1 ;2
saveMap equ jmpSelect + 2 ;1
takeFlags equ saveMap + 1
haveFlags equ takeFlags + 1
seenFlags equ haveFlags + 1
usedFlags equ seenFlags + 1
talkFlags equ usedFlags + 1
giveFlags equ talkFlags + 1
triggerFlags equ giveFlags + 1
whichMenu equ triggerFlags + 1
stickClr equ whichMenu + 1		
inventoryList equ stickClr + 1 ;8 x 2 = 16 bytes
menuSize equ inventoryList + 16 ;1
menuList equ menuSize + 1 ;2
menuActions equ menuList + 2 ;2
invVals equ menuActions + 2 ; 8 bytes
EOTflag equ invVals + 8 ;1 byte
introPtr equ EOTflag + 1;1
invJmps equ introPtr + 1;16

; codes for the typeByte in room block
;-------------------------------------
nothingRoom equ 128
takeRoom equ 64
giveRoom equ 32
useRoom equ 16
talkRoom equ 8
timedRoom equ 4
mustRoom equ 2

; Here are equates used to point at each byte in the data a room Room block
; The bytes control what object(s) can be used in what way there, and the words
; point at the appropriate text for a certain action.
;-------------------------------------------------------
typeByte 	equ 0	;actions can abort early if this does not match
seeByte 	equ 1	;this item will move to seenFlags upon LOOKing
takeByte 	equ 2	;this item will be TAKEn if in seenFlags
useByte 	equ 3	;this item can be USEd if in inventory
giveByte 	equ 4	;this item can be GIVEn if in intentory
talkByte 	equ 5	;must have this in usedFlags in order to talk
triggerByte	equ 6	;this item will move to triggerFlags upon GIVE/TALK
mustByte 	equ 7 	;must have this in inventory in order to enter room
entryWord 	equ 8	;main room description
lookWord 	equ 10	;text for LOOK
takeWord 	equ 12	;text for successful TAKE
useWord 	equ 14	;text for successful USE
giveWord 	equ 16	;text for successful GIVE
talkWord 	equ 18	;text for successful TALK
mustWord 	equ 20	;excuse to give for not allowing into room

;a few macros for storing text in a reasonably easy to read format
;-----------------------------------------------------------------------
sp eqm _space
dot eqm _period

	mac off
	dc.b <#{0}
	endm

	mac wordOff
	dc.b #<{1}
	dc.b #>{1}
	endm
	
	mac mapRow
	wordOff {1}
	wordOff {2}	
	wordOff {3}
	wordOff {4}
	wordOff {5}
	endm

	mac EOL
	dc.b #$FF
	endm

	mac EOT
	dc.b #$FE
	endm

	mac line
	;must supply 12 characters, though 0's will not be assembled
	;------------------------------------------------------------
	if {1} != 0
	 off {1}
	endif
	if {2} != 0
	 off {2}
	endif
	if {3} != 0
	 off {3}
	endif
	if {4} != 0
	 off {4}
	endif
	if {5} != 0
	 off {5}
	endif
	if {6} != 0
	 off {6}
	endif
	if {7} != 0
	 off {7}
	endif
	if {8} != 0
	 off {8}
	endif
	if {9} != 0
	 off {9}
	endif
	if {10} != 0
	 off {10}
	endif
	if {11} != 0
	 off {11}
	endif
	if {12} != 0
	 off {12}
	endif
	EOL
	endm
	
	mac blank
	 line #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	endm

;==============================================================
	org $F000
				
Start	   	
;-----------
;Clear memory, locate character graphics positions and such,
;initialize key memory values, start GameLoop.
;-------------------------------------------------------------

;the usual mumbo jumbo
;---------------------
	sei  	
	cld  		
	ldx #$FF
	txs  		
	lda #0
clear   
	sta 0,x
	dex
	bne clear	

;use cycle counting to get the GRP registers configured and located
;in exactly the right spot
;--------------------------------------
	sta WSYNC	;newline
	lda #$06	;triple copy sprites, spaced wide
	sta NUSIZ0	;for both player graphic registers
	sta NUSIZ1	
	lda #$31	;draw leftmost and rightmost 2 playfield bits: reflect
	sta PF0		;this turns left/right edges black
	sta CTRLPF	;this makes playfield reflective
	nop		;wait 2 cycles, we need them get our RESP0/1 right
	sta VDELP0	;turn on vertical delay for both players
	sta VDELP1
	sta RESP0	;mark our left margin here in P0
	lda #$D0	;setup to shift over 3 pixels to the right
	sta RESP1	;set P1
	sta HMP0	;prep P0 for his HMOVE
	lda #$C0	;setup to shift P1 4 pixels to the right
	sta HMP1	;prep P1 for his HMOVE
	sta WSYNC	;newline
	sta HMOVE	;anchor them down

;the entire font is limited to one page, so we can hard code that page
;value into the MSB position of our graphics buffer
;-----------------------------------------------------
	ldx #23		;graphics buffer is 24 bytes
	lda #>_space	;load up the page value for the font
grOff
	sta grfxBuffer,x	;stuff it, won't ever change
	dex		;back up two bytes
	dex
	bpl grOff	;and loop

;----
;load address of More.../Start menu and the first screen of background story
;---------------------------------------------------------------------------
	lda #<intro0	;the title screen
	sta currentText
	lda #>intro0
	sta currentText + 1

	lda #<introList	;the two choices in the first menu (MORE... and START)
	sta menuList
	lda #>introList
	sta menuList + 1

	lda #<introActions	;the branch destinations for MORE and START
	sta menuActions
	lda #>introActions
	sta menuActions + 1

	lda #<more	;the text "MORE..."
	sta currentMenu
	lda #>more
	sta currentMenu + 1
	
	lda #2		
	sta menuSize	;a 2 option menu
	sta whichMenu	;of the left-right variety

	lda #4		;five screens of background story
	sta introPtr
	
GameLoop
;-----------------
;Everything is set up, so loop through the basic game routines endlessly, 
;cutting out only when RESET is pressed.  One pass of this loop represents
;one display frame.
;-------------------------------------------------------------------------
	jsr VSync 	;start vertical retrace

	inc frame	;we count frames for alternating graphics displays

	lda SWCHB	;read switch settings
	and #%00000001	;turn off everything but bit 0
	bne noReset	;if it's bit 0 = zero, then reset has been pushed
	jmp Start	;so start over
noReset
	jsr VBlank    	;spare time during screen blank
	jsr Picture	;draw one screen
	jsr OverScan    ;spare time during over scan
	jmp GameLoop    ;back to top

GameStart
;---------
;Here is where we setup the map, text and menus for the start of
;a new game.
;----------------------------------------------	
	lda #22		;start in the Meadow
	sta mapLoc

	lda #chisel	;menu won't work with nothing in inventory...
	sta haveFlags

	lda #<meadowEntry	;LSB of offsets for our text
	sta currentText		;store to zero page variable
	lda #>meadowEntry	;MSB
	sta currentText + 1	;store
	
	lda #<look	;store the addresse of LOOK text
	sta currentMenu	; into default menu display
	lda #>look
	sta currentMenu + 1

;The menuList and menuActions zero page locations are 16 bit pointers to a list
;of text to display (menuList) and sub-routines to JMP to (menuActions) when 
;the fire button is pressed.
;--------------------------------
	lda #<goList		;goList is the directional menu
	sta menuList
	lda #>goList
	sta menuList + 1

	lda #<goActions	;list of 16 bit addresses of sub-routines
	sta menuActions
	lda #>goActions
	sta menuActions + 1

	lda #0		
	sta whichMenu	;0=directional menu, non-zero=left-right menu
	
	rts

VSync
;-------------------
	lda #2		;bit 1 needs to be 1 to start retrace
	sta VSYNC	;start retrace
	sta WSYNC 	;wait a few lines
	sta WSYNC 
	lda #44		;prepare timer to exit blank period
	sta TIM64T	;turn it on
	sta WSYNC 	;wait one more
	sta VSYNC 	;done with retrace, write 0 to bit 1
	rts 

VBlank
;-----------------
;Check the joystick and fire button, branch to sub-routine if fire pressed,
;change menu selection if joystick moved.
;--------------------------------------------------------------------------
	lda INPT4	;read P0 fire button
	bpl firePressed	;bit 7 will be 0 if pressed
noButton
	lda #0		;no button, turn off button press delay
	sta stickClr	;by clearing this memory variable
	lda frame	;get current frame counter
	and #7		;eighth frame?
	beq checkStick	;every 8th frame worry about stick
	rts		;otherwise, just exit
checkStick
	lda whichMenu	;this memory variable is a switch to tell which type of
	beq goMenu	; menu is active.  goMenu is the directional menu
	jmp lookMenu	; lookMenu is the left-right variety

firePressed
	lda stickClr	;get delay variable
	beq getButton	;if not 0, then we'll ignore
	rts		;by exiting
getButton
	lda #1		;write 1 to
	sta stickClr	; this variable to cause delay until button is released
		
	lda menuChoice	;get the current menu selection
	asl		;multiply by 2
	tay		;Y=menuChoice * 2
	lda (menuActions),y	;read LSB from table
	sta jmpSelect		;save it to zero page
	iny			;next
	lda (menuActions),y 	;read the MSB
	sta jmpSelect + 1 	;save it
	lda mapLoc		;get the current map location
	sta saveMap		;save, in case it's not passable
	jmp (jmpSelect)	;branch to subroutine...

lookMenu
	lda SWCHA	;read the joystick port
	bpl lright	;bit 7 = 0 means stick pushed to right
	asl		;next bit
	bpl lleft	;bit 6 = 0 means stick pushed to left
	lda menuChoice	;neither left nor right, just reload current value
	jmp lchCh	;and move along

lright
	inc menuChoice	;next item selected
	lda menuChoice	;read into accumulator
	cmp menuSize	;gone past last choice of current menu?
	bne lchCh	;no? process this choice
	lda #0		;yes? 
	sta menuChoice	; wrap back to beginning of list 
lchCh
	asl		;2 byte data list
	tay		;indexed mode
	lda (menuList),y	;get LSB
	sta currentMenu		;save to zero page for displaying
	iny			;point at MSB
	lda (menuList),y	;get it
	sta currentMenu + 1	;save it
	rts		;menu is done
lleft
	dec menuChoice	;same as above only backwards
	lda menuChoice
	bpl lchCh	;not wrapped below zero
	lda menuSize	;wrapped, get max size
	sbc #1		;two's complement
	sta menuChoice	;store it
	jmp lchCh	;process it

goMenu
	lda SWCHA	;read joystick port as above
	bpl gright	
	asl
	bpl gleft
	asl
	bpl gdown	;but also handle up and down stick movements
	asl
	bpl gup
	lda #0
	jmp gchCh	;no stick, use default LOOK selection
gright
	lda #2		;EAST
gchCh
	sta menuChoice	;load it
	asl		;2 byte data buffer
	tay		;indexed
	lda (menuList),y	;get address of sub-routine
	sta currentMenu
	iny
	lda (menuList),y
	sta currentMenu + 1
	rts
gleft
	lda #4		;WEST
	jmp gchCh
gdown
	lda #3		;SOUTH
	jmp gchCh
gup
	lda #1		;NORTH
	jmp gchCh
		
Picture
;----------------
;Here is where we step down the screen drawing everything
;--------------------------------------------------------
	lda INTIM	;check timer for end of VBLANK period
	bne Picture	;loop until it reaches 0
	sta WSYNC	;newline
	sta VBLANK  	;end screen blank

	lda #0		;set background to black
	sta COLUBK	;write it
	ldx #12		;setup loop to
topMargin
	sta WSYNC	;draw 12 blank lines at top of screen
	dex
	bne topMargin

	lda #$1A	;restore main text colors
	sta COLUP0
	sta COLUP1	
	lda #$42
	sta COLUBK
		
	lda #10		;setup counter for rows of text
	sta scanSec	;store in zero page memory variable

	ldy #0		;Y is used to track progress through this screen's text
	sty EOTflag
ScanLoop	
;---------------------
	lda #64		;a variable amount of text will be processed, so stay
	sta  TIM8T	; in sync by timing out after finished

	ldx #22		;write 12 spaces to text buffer to wipe out what's there
	lda #<_space	; from previous row/frame/etc.
blankLine
	sta grfxBuffer,x	;grfxBuffer is our 24 byte, 16 bit list of chars
	dex	
	dex
	bpl blankLine	;fill it
	lda EOTflag
	bne eol
	
	ldx #0		;will load from left to right
nextCol
	lda (currentText),y	;indirect/indexed - pointer to a section of text
	iny			;next char
	cmp #$FF		;FF is EOL
	beq eol			;done with a line?
	cmp #$FE
	bne noEOT
	lda #1
	sta EOTflag
	jmp eol
noEOT	
        sta grfxBuffer,x	;no, stuff this char into the buffer
	inx	
	inx
	jmp nextCol	;just keep going--a screen w/o 10 $FF's will screw this up

eol	
	lda INTIM	;we finished, but wait for timer
	bne eol		; by looping till zero
	sta WSYNC	;end current line

	tya		;need to save Y by putting into accumulator
	pha		; then onto stack
	jsr println	;print this row via subroutine
	pla		;pull Y off stack
	tay		;and put back

	dec scanSec	;next row to print
	bne ScanLoop	;loop until all 10 rows of text have been displayed

	ldx #6		;put some blank lines after row 10
gap
	sta WSYNC	;by just halting
	dex
	bpl gap

	lda #66		;need to time out on menu row load as well
	sta TIM8T

	lda #$56	;change colors for menu row
	sta COLUBK
	lda #$1D
	sta COLUP0
	sta COLUP1

	ldy #0		;Y now points at position in menu text
	ldx #0		;back to leftmost char of grfxBuffer
menuRow	
	lda (currentMenu),y	;get a char
	iny 			;next char
	cmp #$FF		;EOL?
	beq endMenu		;yes? get out
	sta grfxBuffer,x	;no? stuff it
	inx
	inx
	jmp menuRow	;need an $FF to end this loop

endMenu
	lda INTIM
	bne endMenu	;just wait for timer to reach zero
	sta WSYNC	;finish this line	

	jsr println	;print the menu option to the screen

	ldx #6		;and draw some blank lines
bottom	
	sta WSYNC			
	dex
	bpl bottom

	lda #2
	sta VBLANK	;finished a screen, blank the beam

	rts		;done

;Routines to handle menu selections
;==================================

selectMore
;---------
;show more intro text
;--------------------
	dec introPtr
	lda introPtr 	
	bne nextIntro

	lda menuList	;kludge! won't work if introList and introActions
	adc #2		; assemble across page boundary!
	sta menuList
	lda menuActions
	adc #2
	sta menuActions
	
	ldx #1
	stx menuSize
	dex
	stx menuChoice
	txa
nextIntro
	asl
	tay
	lda introWords,y
	sta currentText
	iny
	lda introWords,y
	sta currentText + 1
	rts

;-------------
;Directionals
;-------------
;We come to the next four routines whenever fire is pressed while a direction
;is displayted.  The first section simply points at the new room
;---------------------------------------------------------------

selectNorth		;just change mapLoc variable in grid fashion
	sec
	sbc #10
	jmp goTo

selectEast
	adc #2
	jmp goTo

selectSouth
	adc #10
	jmp goTo

selectWest
	sec
	sbc #2
	
goTo
;---------------------
;Then we try to go to the new room, checking certain control bits to make
;sure we end up in the right place, and the right text is displayed.
;New map location arrives in accumulator...
;---------------------------------------
	sta mapLoc	;save to memory
	jsr getRoomBlock	;get location of this room's data block
				; returned in jmpSelect zero page address

	ldx #entryWord	;get the text to display upon entry
	ldy #typeByte	;get the first byte of the room block-provides TYPE
	lda (jmpSelect),y	;read it
	beq cantPass	;zero means it's an impassable room
	and #mustRoom	;otherwise, does it have a pre-requisite for entering?
	beq retGo	;no? just display entryText
	ldy #mustByte	;otherwise, get the pre-requisite value
	lda (jmpSelect),y	;from this memory location
	and triggerFlags	;check and see if we've triggered that item
	bne retGo 	;yep, show entry text
	ldx #mustWord	;nope, load special message
	lda saveMap	;restore room we came from
	sta mapLoc	;to main variable
	jmp retGo	;and print the text

cantPass
	lda saveMap	;return us to room we came from
	sta mapLoc
	ldx #1		;point at the text (impassable rooms have no pointers)
retGo	
	txa		;move to accumulator
	tay		;then Y

	jsr loadText	;store text's address in currentText zero page location

	lda #0		;reset menu choice to LOOK
	sta menuChoice
	rts		;done	

selectLook
;------------------------
;We get here when LOOK is selected
;-----------------------------------
	jsr getRoomBlock	;point at room data block

	ldy #lookWord	;then to text for LOOK

	jsr loadText	;put pointers into currentText

	ldy #typeByte	;get the TYPE byte of this room
	lda (jmpSelect),y
	beq setLookMenu	;zero means it's impassable, just change menu
	and #nothingRoom	;nothing happens here?, just change menu
	bne setLookMenu
	
	ldy #seeByte	;point at byte that might need processing here
	lda (jmpSelect),y
	tax	
	and takeFlags	;but if we've taken what can be seen, show special message
	bne alreadyTaken
	txa
	ora seenFlags	;store the fact that we just saw something significant
	sta seenFlags

setLookMenu
;----------
;here we change the menu control values to point at the left-right menu, 
;instead of the directional menu
;------------------------------
	lda #<lookList
	sta menuList
	lda #>lookList
	sta menuList + 1

	lda #<lookActions
	sta menuActions
	lda #>lookActions
	sta menuActions + 1

	lda #6
	sta menuSize
	sta whichMenu	;change the menu type
	rts		;and leave

alreadyTaken
;------------
;we don't want to keep "seeing" something we already saw and took
;-----------------------------------------------------------
	lda #<alreadySeen	;load the message
	sta currentText
	lda #>alreadySeen
	sta currentText +1
	jmp setLookMenu		;then change the menu
		
selectGo
;----------------------
;We get here when GO is selected
;-------------------------------
	lda mapLoc	;get our map location
	jsr goTo	;and set up messaging as if we just arrived

chGo
;----
;Now flop the menu to the directional version
;---------------------------------------------	
	lda #<goList	
	sta menuList
	lda #>goList
	sta menuList + 1

	lda #<goActions
	sta menuActions
	lda #>goActions
	sta menuActions + 1

	lda #0	
	sta whichMenu
	lda #0
	sta menuChoice

	rts		;and leave
	
selectTake
;-----------------------
;We get here when TAKE is selected
;----------------------------------
	jsr getRoomBlock	;get the current room's data block address

	ldy #typeByte	;point at the TYPE flag
	lda (jmpSelect),y	;read it

	and #takeRoom	;can anything be taken from this room ever?
	beq noTake	;no? then just display dumb message
	
	ldy #takeByte	;yes?  what?
	lda (jmpSelect),y	;read the item that can be taken from here

	bit takeFlags	;have we already taken it?  
	bne noTake	;yes? dumb message

	bit seenFlags	;have we seen it yet?
	beq noTake	;no? dumb message

	bit haveFlags	;do we already have it? (huh?)
	bne noTake

	tax		;reload
	ora haveFlags	;take it
	sta haveFlags	;store the fact that we took it
	txa
	ora takeFlags	;in both these flag bytes
	sta takeFlags

	ldy #takeWord	;point at take message

	jsr loadText	;load pointer into currentText

	jmp chGo	;no reset the menu back to directional

noTake
;load the dumb message
;---------------------
	lda #<cantTake
	sta currentText
	lda #>cantTake
	sta currentText + 1
	jmp chGo	;and reset the menu	

selectTalk
;------------------
;TALK is selected
;---------------------------
	jsr getRoomBlock	;get address for room data block

	ldy #typeByte	;offset of TYPE byte
	lda (jmpSelect),y	;read it
	and #talkRoom	;is this is room we can ever talk in?
	beq noTalk	;no, just split
	ldy #talkByte	;this offset holds an item value which...
	lda (jmpSelect),y
	and usedFlags	;...must appear in the usedFlags byte for us to talk
	beq noTalk	;if not, leave
	ldy #triggerByte	;okay, so we talked, now we can see something
	lda (jmpSelect),y
	ora triggerFlags	;record the fact that something new has been seen
	sta triggerFlags
	ldy #talkWord	;point at talking text
	jsr loadText	;load pointer into currentText
	jmp chGo	;and reset menu
	
noTalk
;------
;dumb talk message
;-------------------	
	lda #<cantTalk
	sta currentText
	lda #>cantTalk
	sta currentText + 1
	jmp chGo

selectGive
;------------------
; We get here when GIVE is selected
;-----------------------------------
	jsr loadInv	;read the haveFlags and set up menu data in zero page

	lda #<giveItem	;where to go after fire pressed in give menu
	ldy #>giveItem

	jsr stuffInv	;tell the menu where to jump when fire pressed

	lda #<giveText	;little message while Give menu displays
	sta currentText
	lda #>giveText
	sta currentText + 1

	rts

giveItem
;----------------
; Come here after selecting an item to give
;------------------------------------------
	jsr getRoomBlock

	ldy #typeByte
	lda (jmpSelect),y
	and #giveRoom	;can we ever GIVE in this room?
	beq noGive	;no, just leave
	ldx menuChoice	;what inventory item was selected
	lda invVals,x	;pull it from the current haveList
	sta temp	;save it for a second

	ldy #giveByte	;point at the byte that says what we can give
	lda (jmpSelect),y	;read it
	cmp temp	;is that a match?
	bne noGive	;nah, bogus!	

	eor #$FF	;NOT the bits
	and haveFlags	;turn off this item, cuz we don't have it now
	sta haveFlags	;record that fact

	ldy #triggerByte	;point at the byte that says what to trigger
	lda (jmpSelect),y	;read it	
	ora triggerFlags	;seen it
	sta triggerFlags	;can work as a trigger	
	ldy #takeByte
	lda (jmpSelect),y
	ora seenFlags	;should also work for give/take logic
	sta seenFlags

	ldy #giveWord	;point at message for when we give this

	jsr loadText	;store in currentText

	jmp chGo	;and just get out

noGive
;-----
;Dumb message
;--------------
	lda #<cantGive
	sta currentText
	lda #>cantGive
	sta currentText + 1
	jmp chGo
		
selectUse
;------------------
; Let's USE something
;---------------------
	jsr loadInv	;get our current haveList

	lda #<useItem	;set menu to jmp down to useItem afte selection made
	ldy #>useItem

	jsr stuffInv

	lda #<useText	;prompt
	sta currentText
	lda #>useText
	sta currentText + 1

	rts

useItem
;----------------
	jsr getRoomBlock	

	ldy #typeByte
	lda (jmpSelect),y
	and #useRoom	;a USE room?
	beq noUse	;nah, scram

	ldx menuChoice	;what was selected?
	lda invVals,x	;pull out of haveList
	sta temp	;save it
	ldy #useByte
	lda (jmpSelect),y
	cmp temp	;is it a match?
	bne noUse	;nah, bogus!
	
	ora usedFlags	;we used it (only needed for use-talk logic)
	sta usedFlags	;record that fact
	
	ldy #useWord	;point at USE message and leave
	jsr loadText
	jmp chGo	

noUse
;-------
; Dumb message
;-----------------	
	lda #<cantUse
	sta currentText
	lda #>cantUse
	sta currentText + 1
	jmp chGo

selectInventory	
;----------------
	jsr loadInv	;get all the haveList items into menu format
	
	lda #<selectGo	;jump here after fire button pressed
	ldy #>selectGo

	jsr stuffInv

	lda #<invText	;helpful little message
	sta currentText
	lda #>invText
	sta currentText + 1
	rts

stuffInv
;--------------
;this weird routine isn't necessary, but saves a few bytes over just
;storing this data in ROM.  We've got some time here, so it helps.
;------------------------------------------------------------------
	ldx #15
stuffLoop
	sty invJmps,x
	dex
	sta invJmps,x
	dex
	bpl stuffLoop	
	
	lda #invJmps		;
	sta menuActions
	lda #0
	sta menuActions + 1

	rts

loadInv
;---------------------
;Check the haveFlags and create a menu list on the fly for
;every item we're carrying.
;--------------------------------------------------------
	ldx #0		;set indexes
	ldy #0	
	sty temp	;set two memory variables
	sty temp2
	inc temp2

	lda #<invList	;invList is addresses of the text for each item
	sta jmpSelect
	lda #>invList
	sta jmpSelect + 1
sILoop
	lda haveFlags	;read in the flags
	and temp2	;match on bit?
	beq chkNext	;no?  go twiddle
	inc temp	;yes? temp is a counter of matching items
	lda (jmpSelect),y	;LSB of address to this item's text
	sta inventoryList,x	;goes into zero page list	
	txa		;save our position in that list
	pha		;via the stack
	lsr		;now divide it by two for use in another list
	tax		;make it index again
	lda temp2	;get current item's bit
	sta invVals,x	;and store it in zero page
	pla		;pop
	tax		;restore inventoryList index
	iny		;next Y index
	inx		;next X index
	lda (jmpSelect),y	;get the MSB of this item's text
	sta inventoryList,x	;store
	dey		;need to move this index on a match or don't match
	inx		;this one only moves on match though
chkNext		
	lda temp2	;bit to test
	rol		;move it over
	sta temp2	;save it
	iny		;always slide this
	iny
	cpy #16		;max bytes to handle
	bne sILoop

	lda temp	;get our counter
	sta menuSize	;store it
	lda #inventoryList	;reset menu to work off the list we just built
	sta menuList
	lda #0		;MSB is zero page
	sta menuList + 1
	sta menuChoice	;default menu choice
	rts

println
;-------------------------
;Most of this subroutine is ripped from Stellar Trak.  Feel free to add
;your own comments--it's pretty straightforward ;)  and very touchy.  Won't
;work if a page boundary appears at certain places, due to excruciating
;cycle dependency, so if modifying the source, you might need an ALIGN
;pseudo-op to correct flubbery text displays.  ALIGN 256 will always work,
;but maybe ALIGN 128, ALIGN 64, etc. will also work, and not waste as many
;bytes.
;---------------------------------------------------

	;align 256

	ldx #4
	sta WSYNC
pause
	nop
	dex	
	bne pause
	lda temp
	lda temp	
		
	sta HMCLR
	ldx #$90
	ldy #6	;FONTHEIGHT
	lda frame
	and #$01
	beq oddFrame
	jmp evenFrame

print1	
	sta GRP1
	lda (grfxBuffer + $8),y
	sta GRP0
	lda (grfxBuffer + $C),y
	stx HMP0
	stx HMP1
	sta GRP1
	lda (grfxBuffer + $10),y
	sta GRP0
	lda (grfxBuffer + $14),y
	sta GRP1
	sta GRP0
evenFrame	
	dey
	bmi wrapEven
	lda (grfxBuffer + $2),y
	lsr
	sta GRP0
	lda (grfxBuffer +6),y
	lsr
	sta.w $001C
	sta HMOVE
	lda (grfxBuffer + $A),y
	lsr
	sta GRP0
	lda (grfxBuffer + $12),y
	lsr
	sta temp
	lda (grfxBuffer + $E),y
	lsr
	sta GRP1
	lda temp
	sta GRP0
	lda (grfxBuffer + $16),y
	lsr
	sta GRP1

oddFrame
	sta GRP0
	lda #$70
	sta HMP0
	sta HMP1
	dey
	bmi wrapOdd
	lda (grfxBuffer),y
	sta GRP0
	lda (grfxBuffer + $4),y
	sta HMOVE
	jmp print1

wrapEven
	stx HMP0
	stx HMP1
	sta WSYNC
	sta HMOVE
	jmp print2

wrapOdd
	sta WSYNC
	sta temp
	sta temp

print2
	lda #$00
	sta GRP0
	sta GRP1
	sta GRP0
	rts

;-------------------------------------------------
; Lists of addresses to text and actions for menus.
; The List part and the Action part must be
; synced.
;-------------------------------------------------

introList
	wordOff more
	wordOff start
introActions
	wordOff selectMore
	wordOff GameStart
introWords
	wordOff intro4
	wordOff intro3
	wordOff intro2
	wordOff intro1
	wordOff intro0

goList
; text for the directional menu choices
;--------------------------------------------------
	wordOff look	
	wordOff north
	wordOff east
	wordOff south
	wordOff west
goActions
; sub-routines for the directional menu choices
;----------------------------------------------
	wordOff selectLook
	wordOff selectNorth
	wordOff selectEast
	wordOff selectSouth
	wordOff selectWest

lookList
; text for the left-right menu choices
;-------------------------------------------------
	wordOff go
	wordOff take
	wordOff give
	wordOff use
	wordOff talk
	wordOff inventory
lookActions
; sub-routines for the left-right menu choices
;---------------------------------------------
	wordOff selectGo
	wordOff selectTake
	wordOff selectGive
	wordOff selectUse
	wordOff selectTalk
	wordOff selectInventory

;Include the font file
;-------------------------
	nop		;only need a couple of bytes to align font
	nop		; to page boundary in this position
	include z26.fon	;just change the filename to use a different font...

getRoomBlock
; return pointer to the current rooms data in jmpSelect memory variable
;----------------------------------------------------------------------
	lda #<GameMap		;LSB of map offset table
	sta jmpSelect		;get into working variable
	lda #>GameMap		;MSB of map offset table
	sta jmpSelect + 1	;into the second position of working variable
	ldy mapLoc		;current offset into table
	iny			;over to the MSB
	lda (jmpSelect),y	;get it
	sta temp		;save it
	dey			;back to the LSB
	lda (jmpSelect),y	;get it 
	sta jmpSelect		;store it to working pointer
	lda temp		;get back MSB
	sta jmpSelect + 1	;store it-now we are pointing a the room block
	rts
				
OverScan
;-----------------
;Wait around for thiry lines
;---------------------------
	ldx #30
os
	sta WSYNC
	dex
	bne os
	rts


loadText
;------------
;sub-routine to move pointers
;----------------------------
	lda (jmpSelect),y	;get LSB
	sta currentText	;store it for displaying
	iny
	lda (jmpSelect),y	;and MSB
	sta currentText + 1
	rts

; Actual text for menu and items
;-------------------------------

more
	line M,O,R,E,dot,dot,dot,0,0,0,0,0
start
	line S,T,A,R,T,0,0,0,0,0,0,0
	
look
	line L,O,O,K,0,0,0,0,0,0,0,0
north	
	line N,O,R,T,H,0,0,0,0,0,0,0
east	
	line E,A,S,T,0,0,0,0,0,0,0,0
south	
	line S,O,U,T,H,0,0,0,0,0,0,0
west	
	line W,E,S,T,0,0,0,0,0,0,0,0

take
	line T,A,K,E,0,0,0,0,0,0,0,0
give 	
	line G,I,V,E,0,0,0,0,0,0,0,0
talk
	line T,A,L,K,0,0,0,0,0,0,0,0
use
	line U,S,E,0,0,0,0,0,0,0,0,0
inventory
	line I,N,V,E,N,T,O,R,Y,0,0,0
go
	line G,O,0,0,0,0,0,0,0,0,0,0

;Miscellaneous pre-defined messages
;----------------------------------
		
cantTake
	line Y,O,U,sp,S,E,E,0,0,0,0,0
	line N,O,T,H,I,N,G,0,0,0,0,0
	line W,O,R,T,H,0,0,0,0,0,0,0
	line T,A,K,I,N,G,0,0,0,0,0,0
	EOT

invText
	line Y,O,U,sp,A,R,E,0,0,0,0,0
	line C,A,R,R,Y,I,N,G,_colon,0,0,0
	EOT

cantGive
	line C,A,N,_apostrophe,T,sp,G,I,V,E,0,0
	line T,H,A,T,0,0,0,0,0,0,0,0
	EOT

cantUse
	line C,A,N,_apostrophe,T,sp,U,S,E,0,0,0
	line T,H,A,T,0,0,0,0,0,0,0,0
	EOT

cantTalk
	line H,E,L,L,O,sp,W,O,R,L,D,_exclamation
	EOT

giveText
	line S,E,L,E,C,T,sp,I,T,E,M,0
	line T,O,sp,G,I,V,E,_colon,0,0,0,0
	EOT

useText
	line S,E,L,E,C,T,sp,I,T,E,M,0
	line T,O,sp,U,S,E,_colon,0,0,0,0,0
	EOT

alreadySeen
	line Y,O,U,_apostrophe,V,E,sp,S,E,E,N,0
	line A,L,L,sp,Y,O,U,sp,N,E,E,D
	line T,O,sp,H,E,R,E,0,0,0,0,0
	EOT

;Include the map/text file
;-------------------------
	include z26.map	;change the MAP file to make a new game ;)


;;========================

	org $FFFC
	
	dc.w Start
	dc.w Start
