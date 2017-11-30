;http://www.biglist.com/lists/stella/archives/199907/msg00138.html
;
;Lee was kind enough to send me a sample of the bootstrap code
;for the Supercharger demo unit. I converted it into a binary and
;had a look at the code. From what I can see, loading though the
;joystick port works like this:
;
;The 'right' line of the right joystick port is used for output
;to the demo unit. The 'left', 'up', 'down' an 'button' lines
;of this port are used for input. A state change on the output
;line triggers the demo unit to send the next halfbyte. The
;high nibble gets send before the low nibble. The demo unit seems
;to need at least 12 6507 processor cycles to prepare the next
;nibble to be send. I think that pulling the output line low and
;then setting it high again imediately triggers the demo unit to
;switch to the next 8kb ROM load.
;
;The loading code seems to load 65 bytes at a time. 64 of those bytes
;get stored back to front into SC-RAM. One bit in the 65th byte seems
;to make the loading code branch into a test routine that gets executed
;after each 64 byte load anyway. I don't know why it does this. The
;test code branches into the VSYNC routine if nessessary, since the
;loading code seems to try to make sure that no frame gets dropped
;during loading time.
;
;The bootstrap code only prepares to load one 64 bytes block which
;then has to hold data to tell the loading code where to load what
;block next. Therefore I'm not sure what happens after this block has
;been loaded, but I think that the loading code stays intact and
;gets called to load the other 8kb ROM banks too. This would mean that
;it would be possible to replace the loading code with some code that
;does normal SC tape loads. If the 8kb ROM banks can be converted
;into a SC tape format, running the demo from a tape should be possible.
;
;Note to Glenn: Would it be alright if I'd post the commented bootstrap
;code here and would anyone want to see it?
;
;Note to Kevin: With you knowledge of the hardware of the SC demo unit,
;does anything I said above make sense to you? Do you think it would
;be possible to convert the 8kb ROM banks inside the demo unit into
;the SC tape format and have you already put the binaries up on your
;webpage?
;
;
;Thanks, Eckhard Stolberg

  processor 6502
VSYNC   =  $00
VBLANK  =  $01
WSYNC   =  $02
INPT5   =  $3D
SWCHA   =  $0280
SWACNT  =  $0281
INTIM   =  $0284
$0285   =  $0285
LF000   =   $F000
LF019   =   $F019
LFFD0   =   $FFD0

       ORG $0000

       RORG $FF00

LFF00: LDX    #$FF      ;set stack pointer to end of RAM
       TXS              ;
       JSR    LFF63     ;wait for timer, do VSYNC, set timer for 19456 cycles
       LDY    #$00    
       LDX    #$36    
LFF0A: LDA    LFF83,X   ;copy 55 bytes of code from $ff83-$ffb9
       STA    $80,X     ;  to $80-$b6 (write pulse delay at $80 was saved)
       STY    $44,X     ;  and clear TIA registers from $04 to $3a
       DEX              ;
       BPL    LFF0A     ;
       STY    SWCHA     ;set output pin = LOW
       STX    SWCHA     ;set output pin = HIGH
                        ;  triggers start of the next full 6kb SC-RAM load ???
       CLD              ;clear decimal flag
LFF1B: LDY    $B6       ;pointer to load information data
                        ;  LID: SC-RAM/ROM config byte
                        ;       number of 64 byte blocks to load
                        ;       start address to store new block (highbyte)
                        ;       start address to store new block (lowbyte)
       LDA    LFF00,Y   ;load SC-RAM/ROM config byte
       BNE    LFF25     ;if not zero, continue to load data
       JMP    LFFD0     ;jump to startup code for next demo part?
                        ;  $ffd0-$ffff is the first block to be relaoded
LFF25: ORA    $80       ;incorporate write pulse delay into SC-config byte
       STA    $82       ;patch loading code in VCS-RAM with new SC-config byte
       LDX    #$03      ;copy number of 64 bytes blocks to load to $bb
LFF2B: LDA    LFF00,Y   ;  and vector for storing the block into $b9/$ba
       STA    $B9,X     ;
       INY              ;
       DEX              ;
       BPL    LFF2B     ;
       STY    $B6       ;pointer to LID has been increased by 4, save it
                        ;  initially it was #$bc, now it goes beyond
                        ;  #$d0 - $ffd0 gets replaced with new loads first
LFF36: JSR    LFF63     ;wait for timer, do VSYNC, set timer for 19456 cycles
LFF39: LDY    #$40      ;see if the demo unit is ready to send the next
       LDA    INPT5     ;  64 byte block (joystick button line = 0)
       BMI    LFF5A     ;  if not, test the timer again
       STY    SWCHA     ;set output pin = LOW
       PHA              ;waste 9 cycles
       PLA              ;
       DEY              ;
       STY    SWCHA     ;set output pin = HIGH (Y=$3f)
                        ;  triggers start of the next 64 byte block ???
       JSR.w  $0081     ;load next 64 bytes block
       LDA    $B9       ;increase loading vector lowbyte by 64 for next block
       CLC              ;
       ADC    #$40      ;
       STA    $B9       ;
       BCC    LFF56     ;if lowbyte > 256
       INC    $BA       ;  then increase highbyte
LFF56: DEC    $BB       ;decrease number of blocks to load
       BEQ    LFF1B     ;if no more blocks are left, go and see if there is
                        ;  another load information data set
LFF5A: LDA    INTIM     ;is the timer for this frame almost expired?
       CMP    #$04      ;
       BCS    LFF39     ;if not, go and load next block
       BCC    LFF36     ;if yes, first wait for the timer, sync frame
                        ;  and set timer for next frame before loading
                        ;  next block

LFF63: STA    WSYNC     ;wait for the timer to expire
       LDA    $0285     ;  $285 = read timer interrupt bit
       BPL    LFF63     ;  if timer goes from $00 to $ff D7 of $285 goes '1'
       LDY    #$13      ;value for timer and D1 turns on VSYNC
       STY    VBLANK    ;turn on vertical blanking
       STA    WSYNC     ;syncronize TV with VCS
       STA    WSYNC     ;
       STA    WSYNC     ;
       STY    VSYNC     ;
       STA    WSYNC     ;
       STA    WSYNC     ;
       STY    $029F     ;timer for 19456 cycles ($29f=T1024T with INT enabled)
       INY              ;Y=$14 (D1=0 - turns off VSYNC)
       STA    WSYNC     ;
       STY    VSYNC     ;
       RTS              ;return

LFF83: .byte $00        ;SC-RAM - buffers write pulse delay value

;
;This code gets copied into VCS-RAM from $81 to $b5.
;The Y-register is set to $3f to load 64 bytes of data through the
;joystick port. The data gets loaded from byte 63 to byte 0.

LFF84: CMP    LF000     ;set SC-config byte (lowbyte of address gets patched
                        ;  to actual control byte value)
       CMP    LFFF8     ;
LFF8A: LDA    #$7F      ;get state of right joystick button into carry bit
       CMP    INPT5     ;  (this is D4 of current data byte) 
       EOR    SWCHA     ;get D7-D5 from the joystick port
       STA    SWCHA     ;  and change state of output pin to trigger
                        ;  next 4 data bits
       ROL              ;move D4 from carry bit to current data byte
       ASL              ;make room for D3-D1
       ASL              ;
       ASL              ;
       STA    $B7       ;temporarily store upper nibble of current data byte
       LDA    #$7F      ;get D0 of current data byte into carry bit
       CMP    INPT5     ;
       EOR    SWCHA     ;get D3-D1 from the joystick port and change
       STA    SWCHA     ;  state of output pin to trigger next 4 data bits
       AND    #$07      ;isolate D3-D1
       ORA    $B7       ;combine them with upper nibble in the temp variable
       ROL              ;move D0 into current data byte, completing it
       TAX              ;write data byte to SC-RAM 
       CMP    LF000,X   ;
       CMP    ($B9),Y   ;
       DEY              ;decrease byte counter
       BPL    LFF8A     ;if not expired, load next data byte
       CMP    LF019     ;set SC-config to banks 3&2, write disabled, power off
       CMP    LFFF8     ;
       RTS              ;return to loading routine in SC-RAM

LFFB9: .byte $BC        ;pointer to load information data in $ff00 page
       .byte $00,$00    ;filler data
       .byte $1F        ;SC-Config (banks 2&3, writing enabled, ROM power off)
       .byte $01        ;number of 64 bytes blocks to load
       .byte $F7,$C0    ;start address for storing next data blocks
                        ;  (highbyte, lowbyte)

;
;Execution of code starts here. This code initializes the joystick ports
;and the Supercharger demo unit and then jumps to the loading routine.
;It gets overwritten with new data first.

START:
       LDA    #$08      ;RIGHT line on right joystick = output; rest = input
LFFC2: CMP    SWACNT    ;are the I/O lines set correctely?
       BEQ    LFFCF     ;if so, continue
       STA    SWCHA     ;set output pin = HIGH
       STA    SWACNT    ;configure I/O ports (also sends out current data) 
       BNE    LFFC2     ;if this is the first time the I/O lines are set
                        ;  do it again for a little delay
LFFCF: LDA    $80       ;load control byte as set by SC-BIOS
       AND    #$E0      ;isolate the write pulse delay
       STA    SWCHA     ;set output pin = LOW [18 cycles]
       TAX              ;store the write pulse delay in SC-RAM
       CMP    LF000,X   ;  $ff83 will be copied to VCS-RAM at $80 later
       NOP              ;
       CMP    LFF83     ;
       LDA    #$28      ;set timer for 2560 cycles
       STA    $029E     ;  $29e = TIM64T with interrupts enabled
       STA    SWCHA     ;set output pin = HIGH [20 cycles]
       JMP    LFF00     ;jump to loading routine

LFFE9: .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$00,$00

       ORG $2000
       .word  $ffc0     ;start address
       .byte  $1b       ;SC control byte - bank 3&2, write enabled, ROM off
       .byte  $01       ;one 256 bytes page to load
       .byte  $6d       ;checksum
       .byte  $00       ;multiload number
       .word  $010c     ;delay value for the load progress bars
       ORG $2010
       .byte  $1d       ;put the page into page 7 [0-7] of bank 1 [0-2]
       ORG $20ff
       .byte  $ff       ;put something here to get the BIN 8448 bytes big