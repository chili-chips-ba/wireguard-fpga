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
CHACHA_DIR = $(CURDIR)

# ** Build target for generating Verilog hex file from the ELF binary
hex_chacha: $(CHACHA_DIR)/main.elf
	$(CROSS)objcopy -O verilog $< $(CHACHA_DIR)/main.hex

# ** Build target for creating firmware binary and generating program memory file
firmware_chacha: $(CHACHA_DIR)/main.elf
	$(CROSS)objcopy -O binary $< $(CHACHA_DIR)/main.bin
	python $(CHACHA_DIR)/progmem.py
	
# ** Compile and link the main ELF executable from all source files and the linker script
$(CHACHA_DIR)/main.elf: $(CHACHA_DIR)/main.lds  $(CHACHA_DIR)/start.s $(CHACHA_DIR)/main.c $(CHACHA_DIR)/chacha20.c $(CHACHA_DIR)/chacha20.h $(CHACHA_DIR)/chacha20poly1305.c $(CHACHA_DIR)/chacha20poly1305.h $(CHACHA_DIR)/poly1305.c $(CHACHA_DIR)/poly1305.h $(CHACHA_DIR)/wireguard.h $(CHACHA_DIR)/string_bare.c $(CHACHA_DIR)/string_bare.h
	$(CROSS)gcc $(CFLAGS) -march=rv32im -mabi=ilp32 -Wl,--build-id=none,-Bstatic,-T,$(CHACHA_DIR)/main.lds,-Map,$(CHACHA_DIR)/main.map,--strip-debug -ffreestanding -nostdlib -o $@ $(CHACHA_DIR)/start.s $(CHACHA_DIR)/main.c $(CHACHA_DIR)/chacha20.c $(CHACHA_DIR)/chacha20poly1305.c $(CHACHA_DIR)/poly1305.c $(CHACHA_DIR)/string_bare.c

# ** Preprocess the sections linker script using the C preprocessor
$(CHACHA_DIR)/main.lds: $(CHACHA_DIR)/sections.lds
	$(CROSS)cpp -P -o $@ $<

# ** Declare phony targets for cleaning build artifacts
.PHONY: clean
clean_fw_chacha:
	rm -f $(CHACHA_DIR)/main.elf
	rm -f $(CHACHA_DIR)/main.lds
	rm -f $(CHACHA_DIR)/main.map
	rm -f $(CHACHA_DIR)/main.bin
	rm -f progmem.v
	rm -f firmware.hex
	rm -f $(CHACHA_DIR)/main.hex
