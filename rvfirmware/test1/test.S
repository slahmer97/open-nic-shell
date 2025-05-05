    .option norvc
    .section .text
    .globl _start
_start:
    /* One shot: write 0xDEAD_BEEF into DMEM[0] */
    la   a0, 0x00800000      /* DMEM_BASE */
    li   t0, 0xDEADBEEF
    sw   t0, 0(a0)

    /* Now loop forever at PC=8 */
1:  j    1b

