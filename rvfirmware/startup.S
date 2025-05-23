/*  startup.S  – minimal RV32I+M reset for Rosebud core
 *  ---------------------------------------------------
 *  • IMEM = 0x0000_0000 .. +64 KiB (code)
 *  • DMEM = 0x0080_0000 .. +32 KiB (data + stack)
 *  • Interrupts serviced by machine_isr() in C.
 */

    .option norvc            /* generate 32‑bit insts only */
    .section .vectors,"ax"
    .align 4
/* ------------------------------------------------------------------
 * Reset vector (at address 0)
 * ----------------------------------------------------------------*/
reset_vector:
    j   _start               /* jump into C runtime startup */

/* You may add more stubs for vectored mode later */

/* ------------------------------------------------------------------
 * Code section
 * ----------------------------------------------------------------*/
    .section .text
    .globl _start
_start:
    /* ---- 1. set up initial stack pointer ------------------------ */
    la   sp, _stack_top      /* defined by linker (DMEM_BASE+SIZE) */

    /* ---- 2. clear .bss ------------------------------------------ */
    call main

halt:
    wfi                      /* main returned: idle forever    */
    j   halt

/* ------------------------------------------------------------------
 * Linker symbols
 * ----------------------------------------------------------------*/
    .section .rodata
_stack_top = 0x00800000 + 0x8000   /* DMEM_BASE + DMEM_SIZE = 32 KiB */

    .section .text
    .size _start, . - _start

