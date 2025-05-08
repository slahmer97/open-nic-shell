#ifndef FW_MEMMAP_H_
#define FW_MEMMAP_H_

#define IMEM_BASE 0x00000000UL
#define IMEM_SIZE (64u * 1024u)

#define DMEM_BASE 0x00800000UL
#define DMEM_SIZE (32u * 1024u)

#define PMEM_BASE 0x10000000UL
#define PMEM_SIZE (64u * 1024u)

/* DMEM test array */
#define TEST_WORDS 16u
#define TEST_PTR ((volatile uint32_t *)DMEM_BASE)

#define PMEM_PTR ((volatile uint32_t *)PMEM_BASE)
/* last IMEM word is the BOOT flag */
#define IMEM_BOOT_FLAG (*(volatile uint32_t *)(IMEM_BASE + IMEM_SIZE - 4))

#endif
