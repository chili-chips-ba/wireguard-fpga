# ** ----------------------------------------------------------------
# ** This Makefile builds the crypto functions for picoRV32
# ** ----------------------------------------------------------------

# ** Ensure the required RISC-V GCC package is installed:
# ** Command: apt install gcc-riscv64-unknown-elf
CROSS = riscv64-unknown-elf-
CFLAGS =

# ** ----------------------------------------------------------------
# ** chacha20poly1305 Firmware Build Configuration
# ** ----------------------------------------------------------------
# ** Set directory for chacha20poly1305 sources
SOURCE_DIR = $(CURDIR)

# ** Build target for generating Verilog hex file from the ELF binary
hex: $(SOURCE_DIR)/main.elf
	$(CROSS)objcopy -O verilog $< $(SOURCE_DIR)/main.hex

# ** Build target for creating firmware binary and generating program memory file
firmware: $(SOURCE_DIR)/main.elf
	$(CROSS)objcopy -O binary $< $(SOURCE_DIR)/main.bin
	python $(SOURCE_DIR)/progmem.py

# ** Compile and link the main ELF executable from all source files and the linker script
$(SOURCE_DIR)/main.elf: $(SOURCE_DIR)/main.lds  $(SOURCE_DIR)/start.s $(SOURCE_DIR)/main.c $(SOURCE_DIR)/blake2s.c $(SOURCE_DIR)/blake2s.h $(SOURCE_DIR)/string_bare.c $(SOURCE_DIR)/string_bare.h
	$(CROSS)gcc $(CFLAGS) -march=rv32im -mabi=ilp32 -Wl,--build-id=none,-Bstatic,-T,$(SOURCE_DIR)/main.lds,-Map,$(SOURCE_DIR)/main.map,--strip-debug -ffreestanding -nostdlib -o $@ $(SOURCE_DIR)/start.s $(SOURCE_DIR)/main.c $(SOURCE_DIR)/blake2s.c $(SOURCE_DIR)/string_bare.c

# ** Preprocess the sections linker script using the C preprocessor
$(SOURCE_DIR)/main.lds: $(SOURCE_DIR)/sections.lds
	$(CROSS)cpp -P -o $@ $<

# ** Declare phony targets for cleaning build artifacts
.PHONY: clean
clean_fw:
	rm -f $(SOURCE_DIR)/main.elf
	rm -f $(SOURCE_DIR)/main.lds
	rm -f $(SOURCE_DIR)/main.map
	rm -f $(SOURCE_DIR)/main.bin
	rm -f progmem.v
	rm -f firmware.hex
	rm -f $(SOURCE_DIR)/main.hex