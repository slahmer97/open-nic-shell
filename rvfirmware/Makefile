CROSS ?= riscv64-unknown-elf-
MARCH ?= rv32im_zicsr                       # ISA (i = base, m = mul/div)
MABI  ?= ilp32                        # int/long/pointer = 32 bit
OPT   ?= -Os                          # size‑optimised


AS        = $(CROSS)gcc
CC        = $(CROSS)gcc
OBJDUMP   = $(CROSS)objdump
OBJCOPY   = $(CROSS)objcopy
SIZE      = $(CROSS)size

CFLAGS    = $(OPT) -march=$(MARCH) -mabi=$(MABI) -Wall -ffreestanding -nostdlib
ASFLAGS   = $(CFLAGS)
LDFLAGS   = -T link.ld -nostdlib -Wl,--gc-sections -march=$(MARCH) -mabi=$(MABI)

SRC_S     := startup.S
SRC_C     := isr.c main.c
HDR       := snic.h fw_memmap.h
OBJS      := $(SRC_S:.S=.o) $(SRC_C:.c=.o)

# Default target ---------------------------------------------------------
all: firmware.bin firmware.dis

# Build rules ------------------------------------------------------------
%.o: %.S $(HDR)
	$(AS) $(ASFLAGS) -c $< -o $@

%.o: %.c $(HDR)
	$(CC) $(CFLAGS) -c $< -o $@

firmware.elf: $(OBJS) link.ld
	$(CC) $(LDFLAGS) $(OBJS) -o $@
	$(SIZE) $@

firmware.bin: firmware.elf
	$(OBJCOPY) -O binary $< $@

firmware.dis: firmware.elf
	$(OBJDUMP) -d $< > $@

# Convenience targets ----------------------------------------------------
clean:
	rm -f *.o firmware.elf firmware.bin firmware.dis

.PHONY: all clean
