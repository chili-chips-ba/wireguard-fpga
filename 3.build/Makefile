#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#=============================================================

BLD_DIR := $(CURDIR)

HW_SRC  := $(BLD_DIR)/../1.hw
SW_SRC  := $(BLD_DIR)/../2.sw
SW_APP  := $(SW_SRC)/app
SW_TEST := $(SW_SRC)/tests
USER_COUNTER := 2
MACHINE_COUNTER := 41

SW_BLD  := $(BLD_DIR)/sw_build
HW_BLD  := $(BLD_DIR)/hw_build.TCL

#------------------------
# Execute the entire build flow: First SW, then HW
.PHONY: all
all:    sw_all hw_all


#=============================================================
# SW Build
#-------------------------------------------------------------
# You must have gcc installed to build software:
#   sudo apt install gcc-riscv64-unknown-elf
#   For more, see: 0.doc/1.README.Tool-Installs.txt
#=============================================================
CROSS  = riscv64-unknown-elf-

#Use this to test DMEM
#CFLAGS = -DTCM=0 -DHARVARD=1

#Use this to test SDRAM
#CFLAGS = -DTCM=1 -DHARVARD=1

#Use this for standard programs
CFLAGS = -DTCM=1  -DHARVARD=1

# Uncomment to bring in optional tests, as needed
#CFLAGS += -DRISCV_TEST
#CFLAGS += -DMEMTEST
#CFLAGS += -DUART_TEST
#CFLAGS += -DDAC_TEST
#CFLAGS += -DADC_TEST
#CFLAGS += -DADC_SDRAM2UART_BINARY


#------------------------
.PHONY: sw_all
sw_all: sw_clean sw_out

#------------------------
# Remove all output files created from SW build process
sw_clean:
	rm -rf imem.INIT.vh
	rm -rf $(SW_BLD)/main.lds
	rm -rf $(SW_BLD)/main.map
	rm -rf $(SW_BLD)/main.elf
	rm -rf $(SW_BLD)/main.bin
	rm -rf $(SW_BLD)/main.hex
	rm -rf $(SW_BLD)/main.dump
	rm -rf $(SW_BLD)/tests/*

#------------------------
# Compile the Linker/MemoryMapper script
sw_map: $(SW_SRC)/link_map.lds
	$(CROSS)cpp \
	$(CFLAGS) \
	-P -o $(SW_BLD)/main.lds $<

#------------------------
# Compile and link Boot and App code
sw_elf: sw_map $(SW_SRC)/boot_crt.S \
$(SW_APP)/soc.h     $(SW_APP)/soc.c \
$(SW_APP)/memtest.h $(SW_APP)/memtest.c \
$(SW_APP)/uart.h    $(SW_APP)/uart.c \
$(SW_APP)/dac.h     $(SW_APP)/dac.c \
$(SW_APP)/adc.h     $(SW_APP)/adc.c \
$(SW_APP)/main.c
	$(CROSS)gcc \
	$(CFLAGS) \
	-march=rv32i \
	-mabi=ilp32 \
	-mstrict-align \
	-mcmodel=medlow \
	-Wl,--relax,-Bstatic,-T,$(SW_BLD)/main.lds,-Map,$(SW_BLD)/main.map \
	\
	-ffreestanding \
	-fno-builtin \
	-mrelax \
	-fno-pic \
	-nostdlib \
	-static \
	-Winline \
	-g \
	-fverbose-asm \
	-o $(SW_BLD)/main.elf \
	-O0 \
	\
	$(SW_SRC)/boot_crt.S \
	$(SW_APP)/soc.c \
	$(SW_APP)/memtest.c \
	$(SW_APP)/uart.c \
	$(SW_APP)/dac.c \
	$(SW_APP)/adc.c \
	$(SW_APP)/main.c

#---
# Other options:
#	-march=rv32e \
#	-march=rv32ic \
#---
#	-mabi=ilp32e    <ilp32 ilp32d ilp32e ilp32f lp64 lp64d lp64f>
#---
#       -mcmodel=medlow (or: medany) Code model
#---
#       -mdiv           Use hw instructions for integer division
#       -mfdiv          Use hw floating-point divide and square root instructions
#       -mrelax         Use linker relaxations to reduce the number of instructions
#       -mstrict-align  Do not generate unaligned memory accesses
#       -nostartfiles
#	-fno-builtin
#       -mbig-endian    Generate big-endian code. This is the default when GCC is
#                       configured for a ‘riscv64be-*-*’ or ‘riscv32be-*-*’ target.
#       -mlittle-endian Generate little-endian code. This is the default when GCC is
#                       configured for a ‘riscv64-*-*’ or ‘riscv32-*-*’, but not a
#                       ‘riscv64be-*-*’ or ‘riscv32be-*-*’ target.
#---
#       --strip-debug
#---
#       -freestanding   Indicates to the compiler that it is bare-metal,
#                       disabling some built-in functions like memcpy
#       -nostdlib       Indicates that no libraries and no start up
#                       files should be linked by default.
#---
#       -fomit-frame-pointer
#       -fno-omit-frame-pointer
#---
#       -O0     do no optimize at all. This is the default if no optimization level is specified
#	-O1     optimize minimally
#	-O2     optimize more
#	-O3     optimize even more
#       -Ofast  optimize aggressively for SPEED, even if that breaks standard compliance
#       -Og     optimize for debugging experience: Enables optimizations that do not interfere
#               with debugging. It should be the optimization level of choice for the standard
#               edit-compile-debug cycle, offering a reasonable level of optimization while
#               maintaining fast compilation and a good debugging experience
#       -Os     Optimize for code SIZE. -Os enables all -O2 optimizations that do not typically
#               increase code size. It also performs further optimizations designed to reduce
#               code size. It disables the following optimization flags: -falign-functions
#               -falign-jumps -falign-loops -falign-labels -freorder-blocks
#               -freorder-blocks-and-partition -fprefetch-loop-arrays -ftree-vect-loop-version
#
#---
# For more, see:
#    https://gcc.gnu.org/onlinedocs/gcc/RISC-V-Options.html
#    https://gcc.gnu.org/onlinedocs/gcc
#---

#------------------------
# Create all necessary other file format from the compiled ELF
sw_out: sw_elf
	$(CROSS)objcopy -O verilog $(SW_BLD)/main.elf   $(SW_BLD)/main.hex
	$(CROSS)objcopy -O binary  $(SW_BLD)/main.elf   $(SW_BLD)/main.bin
	$(CROSS)objdump -drwC -S   $(SW_BLD)/main.elf > $(SW_BLD)/main.dump
	python3 imem.INIT.py


#=============================================================
# SW Test Build, use to test our RISC-V micro-controller
#=============================================================

# Test dirs, User and Machine mode

$(SW_BLD)/tests:
	mkdir ./sw_build/tests

$(SW_BLD)/tests/rv32ui: $(SW_BLD)/tests
	mkdir ./sw_build/tests/rv32ui

$(SW_BLD)/tests/rv32mi: $(SW_BLD)/tests
	mkdir ./sw_build/tests/rv32mi

#------------------------
# Compile one user test
$(SW_BLD)/tests/rv32ui/%.elf: $(SW_TEST)/rv32ui/%.S $(SW_BLD)/tests/rv32ui sw_map
	@echo $(USER_COUNTER)
	$(eval USER_COUNTER=$(shell expr $(USER_COUNTER) + 1))
	$(CROSS)gcc \
	$(CFLAGS) \
	-DTESTCODE=$(USER_COUNTER) \
	-march=rv32i \
	-mabi=ilp32 \
	-mstrict-align \
	-mcmodel=medlow \
	-Wl,--relax,-Bstatic,-T,$(SW_BLD)/main.lds,-Map,$(SW_BLD)/main.map \
	\
	-ffreestanding \
	-fno-builtin \
	-mrelax \
	-fno-pic \
	-nostdlib \
	-static \
	-g \
	-fverbose-asm \
	-o $@ \
	-Os \
	$(SW_SRC)/boot_crt.S \
	$(SW_APP)/soc.c \
	$(SW_APP)/uart.c \
	$<

#---------------------------------
# Compile all tests TESTCODE 2-end
USER_SRC_FILES  := $(wildcard $(SW_TEST)/rv32ui/*.S)

USER_ELF_FILES  := $(patsubst $(SW_TEST)/rv32ui/%.S,$(SW_BLD)/tests/rv32ui/%.elf,$(USER_SRC_FILES))
USER_HEX_FILES  := $(patsubst $(SW_TEST)/rv32ui/%.S,$(SW_BLD)/tests/rv32ui/%.hex,$(USER_SRC_FILES))
USER_BIN_FILES  := $(patsubst $(SW_TEST)/rv32ui/%.S,$(SW_BLD)/tests/rv32ui/%.bin,$(USER_SRC_FILES))
USER_DUMP_FILES := $(patsubst $(SW_TEST)/rv32ui/%.S,$(SW_BLD)/tests/rv32ui/%.dump,$(USER_SRC_FILES))

#---------------------------------
# SW hexes, dumps and bins
$(SW_BLD)/tests/rv32ui/%.hex: $(SW_BLD)/tests/rv32ui/%.elf
	$(CROSS)objcopy -O verilog $< $@

$(SW_BLD)/tests/rv32ui/%.bin: $(SW_BLD)/tests/rv32ui/%.elf
	$(CROSS)objcopy -O binary $< $@

$(SW_BLD)/tests/rv32ui/%.dump: $(SW_BLD)/tests/rv32ui/%.elf
	$(CROSS)objdump -drwC $< > $@

utests: $(USER_ELF_FILES) $(USER_HEX_FILES) $(USER_BIN_FILES) $(USER_DUMP_FILES)





#-------------------------------------------------
# Machine-mode + Zicsr tests, needed for FreeRTOS

$(SW_BLD)/tests/rv32mi/%.elf: $(SW_TEST)/rv32mi/%.S $(SW_BLD)/tests/rv32mi sw_map
	@echo $(MACHINE_COUNTER)
	$(eval MACHINE_COUNTER=$(shell expr $(MACHINE_COUNTER) + 1))
	$(CROSS)gcc \
	$(CFLAGS) \
	-DTESTCODE=$(MACHINE_COUNTER) \
	-march=rv32im \
	-mabi=ilp32 \
	-mcmodel=medlow \
	-Wl,--relax,-Bstatic,-T,$(SW_BLD)/main.lds,-Map,$(SW_BLD)/main.map \
	\
	-ffreestanding \
	-fno-builtin \
	-mrelax \
	-fno-pic \
	-nostdlib \
	-static \
	-g \
	-fverbose-asm \
	-o $@ \
	-Os \
	$(SW_SRC)/boot_crt.S \
	$(SW_APP)/soc.c \
	$(SW_APP)/uart.c \
	$<

MACHINE_SRC_FILES  := $(wildcard $(SW_TEST)/rv32mi/*.S)

MACHINE_ELF_FILES  := $(patsubst $(SW_TEST)/rv32mi/%.S,$(SW_BLD)/tests/rv32mi/%.elf,$(MACHINE_SRC_FILES))
MACHINE_HEX_FILES  := $(patsubst $(SW_TEST)/rv32mi/%.S,$(SW_BLD)/tests/rv32mi/%.hex,$(MACHINE_SRC_FILES))
MACHINE_BIN_FILES  := $(patsubst $(SW_TEST)/rv32mi/%.S,$(SW_BLD)/tests/rv32mi/%.bin,$(MACHINE_SRC_FILES))
MACHINE_DUMP_FILES := $(patsubst $(SW_TEST)/rv32mi/%.S,$(SW_BLD)/tests/rv32mi/%.dump,$(MACHINE_SRC_FILES))

#---------------------------------
# SW hexes, dumps and bins
$(SW_BLD)/tests/rv32mi/%.hex: $(SW_BLD)/tests/rv32mi/%.elf
	$(CROSS)objcopy -O verilog $< $@

$(SW_BLD)/tests/rv32mi/%.bin: $(SW_BLD)/tests/rv32mi/%.elf
	$(CROSS)objcopy -O binary $< $@

$(SW_BLD)/tests/rv32mi/%.dump: $(SW_BLD)/tests/rv32mi/%.elf
	$(CROSS)objdump -drwC $< > $@

mtests: $(MACHINE_ELF_FILES) $(MACHINE_HEX_FILES) $(MACHINE_BIN_FILES) $(MACHINE_DUMP_FILES)

#=============================================================
# HW Build
#-------------------------------------------------------------
# This step must be run after SW build, as we first need to
# have SW program to then store it into RTL for IMEM
#-------------------------------------------------------------
# You must have GowinEDA package installed for this.
#
#  1) Download 'Gowin_V1.9.9.01_x64_win.zip' fajl from our WebDisk:
#     https://www.chili-chips.xyz:2078/Gowin_V1.9.9.01_x64_win.zip
#       UserID: student@chili-chips.xyz
#       Pass  : fpga123
#
#  2) Unzip and install. The license is free, but you have to register on:
#       https://www.gowinsemi.com/en/support/license
#
#  3) Add Gowin Windows install to your Linux $PATH, such as (for 'tcsh'):
#       setenv GOWIN_ROOT '/mnt/c/Gowin/Gowin_V1.9.9.01_x64/IDE/bin'
#       setenv PATH       "${WIN_ROOT}:${PATH}"
#
#   For more, see: 0.doc/1.README.Tool-Installs.txt
#=============================================================

#------------------------
.PHONY: hw_all
hw_all: hw_clean hw_build hw_prog

#------------------------
# Remove all output files created from HW build process
hw_clean:
	rm -rf $(HW_BLD)

#------------------------
# Execute HW Build using Gowin Synth->PNR->Bitgen flow
hw_build:
	gw_sh.exe run-hwbuild.tcl

#------------------------
# Program the compiled bitimage into FPGA hardware
# For more, see eduSOC\0.doc\Gowin\Tools\SUG502-1.5E_Gowin Programmer User Guide.pdf (Section 4)
#
#  programer.exe hw_build.TCL/impl/pnr/eduSOC.fs
#  TODO programmer_cli.exe
hw_prog:
	@echo "\n\n======================================================================================================"
	@echo "Unless it is already open, manually open Gowin Programmer, then load 'hw_build.TCL/impl/pnr/eduSOC.fs'\n"


#=============================================================
# End-of-File
#=============================================================
