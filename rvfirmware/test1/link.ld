/* link.ld — place everything at 0x0 in IMEM */
ENTRY(_start)
SECTIONS {
  . = 0x00000000;
  .text : { *(.text) *(.rodata) }
  . = ALIGN(4);
  _etext = .;
  /* we don’t need data/bss for this tiny test */
}

