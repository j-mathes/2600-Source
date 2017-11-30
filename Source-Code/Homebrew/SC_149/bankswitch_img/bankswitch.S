/******************************************************************************
File: bankswitch.S
Description: Custom (FA2) Bankswitching Scheme For Star Castle
(C) Copyright 2012 - Chris Walton & Fred Quimby
******************************************************************************/

.set  FIOBASE,    0x3FFFC000      /* Fast IO (FIO) base address */
.set  RAMDATA,    0x40001000      /* Atari Data (256 bytes) */
.set  A12MASK,    0x00001000      /* A12 address mask */
.set  STARTADDR,  0x00001FF4      /* Atari start/stall address */
.set  ENDRAM,     0x00001200      /* End of RAM region (256 bytes) */
.set  WRITEBIT,   0x00000100      /* End of writeable region */

/* Use ARM mode for speed */
.arm

/* Put code in RAM section */
.section  .bankcode,"ax",%progbits

/*****************************************************************************/

/* Bankswitching entry point */
.global   _main
.func     _main
_main:
  /* GPIO base address */
  ldr     r0, =FIOBASE
  /* RAM data start (adjusted for A12) */
  ldr     r4, =(RAMDATA - 0x1000)
  /* Data output bits */
  mov     r5, #0xFF
  /* Data input bits */
  mov     r6, #0x00
  /* Bankswitching bank offset */
  mov     r8, #0x00
  /* Atari start/stall/bankswitch address */
  ldr     r9, =STARTADDR
  /* Bankswitch table */
  ldr     r10, =_BankTable

/*****************************************************************************/

WaitA12:
  /* Float data bus */
  strb    r6, [r0, #+0x01]

  /* Test A12 */
  ldrh    r1, [r0, #+0x16]
  tst     r1, #A12MASK
  bne     NewAddress

  /* Wait for address change */
PollChange:
  ldrh    r2, [r0, #+0x16]
  cmp     r1, r2
  beq     PollChange

/*****************************************************************************/

NewAddress:
  /* Reload address (glitch filter) */
  ldrh    r1, [r0, #+0x16]
  tst     r1, #A12MASK
  beq     WaitA12

AddressHandle:
  /* Jumptable for RAM addresses */
  cmp     r1, #ENDRAM
  bcc     ReadWriteRAM

  /* Check for stall and bankswitching (0x1FF4-0x1FFB) */
  subs    r2, r1, r9
  beq     Stalled
  cmp     r2, #8
  
  /* Store bank in r8 */
  ldrcc   r8, [r10, r2, asl #2]

  /* Fetch ROM data from flash */
  ldrb    r2, [r1, +r8]

  /* Set output data and enable output pins */
  strb    r2, [r0, #+0x15]
  strb    r5, [r0, #+0x01]
  b       PollChange

/*****************************************************************************/

ReadWriteRAM:
  /* Check for Read */
  tst     r1, #WRITEBIT
  bne     ReadData

WriteData:
  /* Float data bus */
  strb    r6, [r0, #+0x01]
  
  /* Read data until address changes */
  ldrb    r3, [r0, #+0x15]
ReadPollChange:
  mov     r12, r3
  ldrb    r3, [r0, #+0x15]
  ldrh    r2, [r0, #+0x16]
  cmp     r1, r2
  beq     ReadPollChange
  
  /* Store data from previous poll in RAM */
  strb    r12, [r1, +r4]
  b       NewAddress

ReadData:
  /* Fetch data from RAM */
  sub     r3, r1, #0x100
  ldrb    r2, [r3, +r4]

  /* Output data */
  strb    r2, [r0, #+0x15]
  strb    r5, [r0, #+0x01]
  b       PollChange

/*****************************************************************************/

Stalled:
  /* Float data bus */
  strb    r6, [r0, #+0x15]
  strb    r6, [r0, #+0x01]

  /* Reset stack pointer */
  ldr     sp, =_stack_end

  /* Handle operation */
  push    {r0-r12}
  bl      FLASH_Main
  pop     {r0-r12}
  
  /* Mask GPIO except data and address pins */
  ldr     r1, =0xE00000FF
  str     r1, [r0, #+0x10]
  
  /* Set data and address pins to inputs */
  sub     r1, r1, #0x7F
  str     r1, [r0]

  /* Check for start address */
PollStart:
  ldrh    r1, [r0, #+0x16]
  cmp     r1, r9
  bne     PollStart

  /* Check for start address again (glitch filter) */
  ldrh    r1, [r0, #+0x16]
  cmp     r1, r9
  bne     PollStart

  /* Output zero to pull out of stall */
  strb    r6, [r0, #+0x15]
  strb    r5, [r0, #+0x01]
  b       PollChange

/*****************************************************************************/

.section  .rodata,"a",%progbits

/* Bank Start - 0x1000 */
_BankTable:
  .long 0               /* $FFF4 (unused) */
  .long 0-0x00001000    /* $FFF5 */
  .long 0               /* $FFF6 */
  .long 0x00001000      /* $FFF7 */
  .long 0x00002000      /* $FFF8 */
  .long 0x00003000      /* $FFF9 */
  .long 0x00004000      /* $FFFA */
  .long 0x00005000      /* $FFFB */

/*****************************************************************************/

