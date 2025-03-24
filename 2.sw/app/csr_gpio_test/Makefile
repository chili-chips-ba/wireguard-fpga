# ** ----------------------------------------------------------------
# ** This Makefile builds the WireGuard firmware for picoRV32
# ** ----------------------------------------------------------------

# ** Ensure the required RISC-V GCC package is installed:
# ** Command: apt install gcc-riscv64-unknown-elf
CROSS = riscv64-unknown-elf-
CFLAGS =

# ** ----------------------------------------------------------------
# ** WireGuard Firmware Build Configuration
# ** ----------------------------------------------------------------
# ** Set directory for WireGuard sources
WIREGUARD_DIR = $(CURDIR)

# ** Build target for generating Verilog hex file from the ELF binary
hex_wireguard: $(WIREGUARD_DIR)/main.elf
	$(CROSS)objcopy -O verilog $< $(WIREGUARD_DIR)/main.hex

# ** Build target for creating firmware binary and generating program memory file
firmware_wireguard: $(WIREGUARD_DIR)/main.elf
	$(CROSS)objcopy -O binary $< $(WIREGUARD_DIR)/main.bin
	python3 $(WIREGUARD_DIR)/progmem.py
	
# ** Compile and link the main ELF executable from all source files and the linker script
$(WIREGUARD_DIR)/main.elf: $(WIREGUARD_DIR)/main.lds  $(WIREGUARD_DIR)/start.s $(WIREGUARD_DIR)/main.c $(WIREGUARD_DIR)/csr.h
	$(CROSS)gcc $(CFLAGS) -march=rv32im -mabi=ilp32 -Wl,--build-id=none,-Bstatic,-T,$(WIREGUARD_DIR)/main.lds,-Map,$(WIREGUARD_DIR)/main.map,--strip-debug -ffreestanding -nostdlib -static -o $@ $(WIREGUARD_DIR)/start.s $(WIREGUARD_DIR)/main.c

# ** Preprocess the sections linker script using the C preprocessor
$(WIREGUARD_DIR)/main.lds: $(WIREGUARD_DIR)/sections.lds
	$(CROSS)cpp -P -o $@ $<

# ** Declare phony targets for cleaning build artifacts
.PHONY: clean
clean_fw_chacha:
	rm -f $(WIREGUARD_DIR)/main.elf
	rm -f $(WIREGUARD_DIR)/main.lds
	rm -f $(WIREGUARD_DIR)/main.map
	rm -f $(WIREGUARD_DIR)/main.bin
	rm -f progmem.v
	rm -f firmware.hex
	rm -f $(WIREGUARD_DIR)/main.hex
