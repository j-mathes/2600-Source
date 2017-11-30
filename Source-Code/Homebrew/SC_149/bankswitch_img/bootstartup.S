/******************************************************************************
File: bootstartup.S
Description: Melody Startup Code
(C) Copyright 2012 - Chris Walton
******************************************************************************/

.set  MODE_SYS,   0x1F            /* System Mode */
.set  I_BIT,      0x80            /* IRQ bit */
.set  F_BIT,      0x40            /* FIQ bit */

.set  FIOBASE,    0x3FFFC000      /* Fast IO (FIO) base address */
.set  GPIOBASE,   0xE0028000      /* General-purpose IO (GPIO) base address */
.set  SPI0BASE,   0xE0020000      /* SPI0 base address */
.set  TIMERBASE,  0xE0004000      /* Timer base */
.set  PINSEL,     0xE002C000      /* Pin select address */
.set  MAMBASE,    0xE01FC000      /* Memory Accelerator Module (MAM) address */
.set  PLLBASE,    0xE01FC080      /* Phase-Locked-Loop (PLL) Address */
.set  APBDIV,     0xE01FC100      /* Advanced Peripheral Bus (APB) Address */
.set  SCS,        0xE01FC1A0      /* SCS Address */

/* Start in ARM mode (vectors cannot be THUMB) */
.arm

/* Put code in boot section */
.section  .boot,"ax",%progbits

/*****************************************************************************/

/* Entry Point (begin by executing the reset handler) */
.global   _startup
.func     _startup
_startup:

/* Exception Vector Table */
ResetVector:
  ldr     pc, =ResetHandler
UndefVector:
  ldr     pc, =SafeStop
SWIVector:
  ldr     pc, =SafeStop
PFABVector:
  ldr     pc, =SafeStop
DABVector:
  ldr     pc, =SafeStop
ISPVector:
  nop     /* ISP Checksum */
IRQVector:
  ldr     pc, [pc, #-0xFF0]
FIQVector:

/* Safe Stop:
   If the system fails (and raises an exception), we put things into a safe 
   state to avoid damaging the Atari or writing junk to the SPI peripherals.
   (Damage is theoretical and almost certainly wont actually happen!)     */
SafeStop:
  /* Configure Slow IO Mode */
  mov     r1, #0x00
  ldr     r0, =SCS
  str     r1, [r0]
  
  /* Set IO pins to Inputs (except CS/WP/HOLD lines) */
  ldr     r0, =GPIOBASE
  ldr     r1, =0xE0000080
  str     r1, [r0, #+0x08]
  
  /* Stop any SPI accesses (by raising CS lines) */
  ldr     r1, =0x20000080
  str     r1, [r0, #+0x00]

  /* Loop forever */
HaltLoop:
  b HaltLoop

/*****************************************************************************/

  /* Reset handler (called at start-up and system reset) */
ResetHandler:

  /* Set system mode and disable interrupts */
  msr     cpsr_c, #MODE_SYS|I_BIT|F_BIT

  /* Initialise stack pointer */
  ldr     sp, =_stack_end

  /* Load PLL feed values */
  mov     r3, #0xAA
  mov     r4, #0x55

  /* Set PLL multiplier and divider values for 70MHz */
  ldr     r0, =PLLBASE
  mov     r1, #0x26
  str     r1, [r0, #+0x04]

  /* Enable PLL */
  mov     r5, #0x01
  str     r5, [r0]
  str     r3, [r0, #+0x0C]  /* Feed */
  str     r4, [r0, #+0x0C]

  /* Wait for PLL to lock frequency */
  ldr     r2, =0x00000400
PLLWait:
  ldr     r1, [r0, #+0x08]
  tst     r1, r2
  bne     PLLWait
  
  /* Connect PLL as the clock source */
  mov     r1, #0x03
  str     r1, [r0]
  str     r3, [r0, #+0x0C]  /* Feed */
  str     r4, [r0, #+0x0C]

  /* Set peripheral clock divider to 1 (APB is 70MHz) and enable fast GPIO */
  ldr     r0, =APBDIV
  /* mov     r5, #0x01 */
  strb    r5, [r0]
  ldr     r0, =SCS
  str     r5, [r0]

  /* Enable memory accelerator and set timings for 70MHz */
  ldr     r0, =MAMBASE
  mov     r1, #0x04
  str     r1, [r0, #+0x04]
  mov     r1, #0x02
  str     r1, [r0]

  /* Enable SPI pins (and set all other pins to GPIO) */
  ldr     r0, =PINSEL
  ldr     r1, =0x00001500
  str     r1, [r0]
  
  /* Set Atari address/data pins to inputs (P8-P28) */
  /* Set CS pins (P7/P29) as outputs and HOLD/WP lines (P30-31) as outputs */
  ldr     r0, =FIOBASE
  ldr     r1, =0xE0000080
  str     r1, [r0]
  
  /* Unmask output pins so that the initial values can be set */
  mvn     r2, r1
  str     r2, [r0, #+0x10]
  
  /* Deselect EEPROM and SD card peripherals (P7 and P29 high) */
  /* Also set WP (P30 low) and deselect HOLD (P31 high) */
  ldr     r1, =0xA0000080
  str     r1, [r0, #+0x14]

  /* Mask GPIO pins except data and address lines */
  ldr     r1, =0xE00000FF
  str     r1, [r0, #+0x10]

  /* Set SPI speed to approx 7MHz (value must be even and >= 8) */
  ldr     r0, =SPI0BASE
  mov     r1, #0x0A           /* Use 0xB0 (400KHz) if there are issues */
  str     r1, [r0, #+0x0C]
  
  /* Set to SPI master, 8bit transfers, and disable interrupts */
  ldr     r1, =0x00000820
  str     r1, [r0]

  /* Copy bankswitching from FLASH to SRAM */
  ldr     r1, =0x00001000
  ldr     r2, =_sreloc0
  ldr     r3, =_ereloc0
CopyLoopA:
  cmp     r2, r3
  ldrcc   r4, [r1], #4
  strcc   r4, [r2], #4
  bcc     CopyLoopA

  /* Copy driver code from FLASH to SRAM */
  ldr     r1, =0x00002000
  ldr     r2, =_sreloc1
  ldr     r3, =_ereloc1
CopyLoopB:
  cmp     r2, r3
  ldrcc   r4, [r1], #4
  strcc   r4, [r2], #4
  bcc     CopyLoopB

  /* Jump to bankswitching code */
  ldr     r0, =_main
  bx      r0

