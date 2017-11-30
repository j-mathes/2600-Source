OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

/* Entry Point  */
ENTRY(_startup)

/* LPC2103 memory areas  */
MEMORY 
{
  boot (RX)       : ORIGIN = 0           LENGTH = 512   /* Bootloader */
  flash (RX)      : ORIGIN = 4096,       LENGTH = 28K   /* FLASH ROM  */

  ramdata         : ORIGIN = 0x40001000, LENGTH = 256   /* Atari RAM */
  ram             : ORIGIN = 0x40000000, LENGTH = 4096  /* RAM area */
  ram_iar         : ORIGIN = 0x40001FE0, LENGTH = 32    /* IAR */
}

/* Global symbol _stack_end (with space for IAR routines) */
_stack_end = 0x40001FDC;

/* Output sections  */
SECTIONS
{
  .bootcode : AT (0x00000000)
  {
    . = 0;
    _sboot = .;
    *(.boot)
    . = ALIGN(4);
    _eboot = .;
  } > boot

  .reloc0 : AT (0x00001000)
  {
    . = ALIGN(4);
    _sreloc0 = .;
    *(.bankcode)
    *(.rodata*)
    . = ALIGN(4);
    _ereloc0 = .;
  } >ram

  .reloc1 : AT (0x00002000)
  {
    . = ALIGN(4);
    _sreloc1 = .;
    *(.text*)
    *(.data)
    . = ALIGN(4);
    _ereloc1 = .;
  } >ram

  .bss (NOLOAD) :
  {
    _szero = .;
    *(.bss)
    . = ALIGN(4);
    _ezero = .;
  } >ram
}
end = .;


