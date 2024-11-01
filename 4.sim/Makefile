#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#=============================================================
SHELL   := /bin/bash

BLD_DIR := $(CURDIR)/../3.build
HW_SRC	:= $(CURDIR)/../1.hw
TB_NAME := tb

USER_TEST_BLD    := $(BLD_DIR)/sw_build/tests/rv32ui
MACHINE_TEST_BLD := $(BLD_DIR)/sw_build/tests/rv32mi
ARE_TESTS := 
USER_TEST_HEX_FILES := $(wildcard $(USER_TEST_BLD)/*.hex)
MACHINE_TEST_HEX_FILES := $(wildcard $(MACHINE_TEST_BLD)/*.hex)

COLOR_YELLOW=\033[1;33m
COLOR_RESET=\033[0m


export BLD_DIR HW_SRC TB_NAME


#------------------------
.PHONY: all
all: clean sim wave

#------------------------
clean:
	rm -rf output

#-------------------------------------------------------------
#___Global macro___
#   +define+SIM_ONLY \    to speed-up things for sim
#
#___PicoRV32 macros___
#   +define+CPU_DEBUG \
#   +define+CPU_DEBUGFSM \
#   +define+CPU_DEBUG+CPU_DEBUGFSM \
#
#   +define+CPU_DEBUGTRACE \
#   +define+CPU_DEBUGNETS \
#
#   +define+CPU_FORMAL+CPU_DEBUG \
#   +define+RISCV_FORMAL+RISCV_FORMAL_BLACKBOX_ALU \
#   +define+RISCV_FORMAL_BLACKBOX_REGS+RISCV_FORMAL_ALTOPS \
#    
#   +define+PICORV32_REGS \
#
#___SDRAM macros___
#   +define+SDRAM_DEBUG \
#   +define+SDRAM_TIMINGCHK \  Verilator is not accurate for sub-cycle timing
#   +define+SDRAM_DEBUG+SDRAM_DEBUGNOTE \
#
#___Other BFM macros___
#   +define+RAM_DEBUG \
#   +define+CSR_DEBUG \
#   +define+UART_DEBUG+UART_BFM_DEBUG \
#   +define+DAC_DEBUG+DAC_BFM_DEBUG+DAC_REVISED \
#   +define+ADC_DEBUG+ADC_BFM_DEBUG \
#-------------------------------------------------------------
compile: 
	verilator \
		--cc \
		--timing \
		--trace-fst \
		--trace-structs \
		--timescale-override 1ps/1ps \
		--exe versimSV.cpp \
		--Mdir ./output \
		\
		+define+SIM_ONLY \
		+define+SDRAM_DEBUG \
		+define+DAC_DEBUG \
		+define+UART_BFM_DEBUG \
		+define+ADC_DEBUG+ADC_BFM_DEBUG \
		$(ARE_TESTS) \
		\
		-f ${HW_SRC}/top.filelist \
		\
		models/gowin.prim_sim.CHILI.v \
		models/bfm_uart.sv \
		models/bfm_adc.sv \
		${TB_NAME}.sv \
		--top-module ${TB_NAME}

#		models/sdr_sdram/sdr.CHILI.sv \
#		models/bfm_dac.sv \
                
#		-O1 \
#		-O3 \
#		-Wno-fatal \
#		--debug \
#		--trace-threads 1 \
#
#		--x-assign fast \
#		--x-initial fast \
#		--noassert \
#		--no-timing \
#		--trace-depth 10 \
#		--trace-max-array 1024 \    Maximum array depth for tracing
#		--trace-max-width 32 \      Maximum bit width for tracing
#
#		--assert \  read //synopsys full_case or //synopsys parallel_case
#		     //ambit synthesis, //cadence or //pragma directives
#		     Also asserts any "unique" or "priority" SV keywords on
#		     case statements, as well as "unique" on if statements.
#		     However, "priority if" is currently ignored.


#------------------------
sim: compile
	cd output; \
	make -f V${TB_NAME}.mk  V${TB_NAME}; \
	./V${TB_NAME} | tee sim.log

#------------------------
wave: xml2stems
	cd output; \
	gtkwave --saveonexit \
		--slider-zoom \
		--stems   ../tb.stems \
		--logfile sim.log \
		-rc       ../.gtkwaverc \
		--dump    wave.fst &

#		--wish \
#		--save ../wave.gtkw 

#------------------------
wave-alt: 
	cd output; \
	surfer.exe -s ../wave.surfer.ron wave.fst &

#------------------------
xml2stems: 
	verilator \
		--timing \
		-xml-only \
		-xml-output tb.xml \
		--timescale 1ps/1ps \
		-f ${HW_SRC}/top.filelist \
		models/gowin.prim_sim.CHILI.v \
		models/bfm_uart.sv \
		models/bfm_dac.sv \
		models/bfm_adc.sv \
		${TB_NAME}.sv \
		--top-module ${TB_NAME}
	xml2stems tb.xml tb.stems

#		models/sdr_sdram/sdr.CHILI.sv \

#------------------------
rtlbrowse: xml2stems
	rtlbrowse tb.stems   
#------------------------
utests: $(USER_TEST_HEX_FILES)
	@for hex_file in $^; do \
        export ARE_TESTS; \
        python3 $(BLD_DIR)/imem.INIThex.py $$hex_file; \
		echo -e "==========================================================="; \
		echo -e "Running test for file: $(COLOR_YELLOW)$$hex_file$(COLOR_RESET)"; \
		echo -e "==========================================================="; \
        $(MAKE) -s clean; \
        $(MAKE) ARE_TESTS=$$ARE_TESTS -s sim; \
    done
mtests: $(MACHINE_TEST_HEX_FILES)
	@for hex_file in $^; do \
        export ARE_TESTS; \
        python3 $(BLD_DIR)/imem.INIThex.py $$hex_file; \
		echo -e "==========================================================="; \
		echo -e "Running test for file: $(COLOR_YELLOW)$$hex_file$(COLOR_RESET)"; \
		echo -e "==========================================================="; \
        $(MAKE) -s clean; \
        $(MAKE) ARE_TESTS=$$ARE_TESTS -s sim; \
    done


#=============================================================
# End-of-File
#=============================================================
