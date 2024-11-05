###################################################################
# Makefile for virtual processor WireGuardtop level  test bench
# code in Verilator
#
# Copyright (C) 2024 Chili.CHIPS*ba
#
###################################################################

# --------------------------------------------
# Command line modifiable variables
# --------------------------------------------

USER_C        = VUserMain0.cpp
USRCODEDIR    = $(CURDIR)/usercode
OPTFLAG       = -g
TIMINGOPT     = --timing
TRACEOPTS     = --trace-fst --trace-structs
TOPFILELIST   = top.filelist
SOCCPUMATCH   = ip.cpu
USRSIMOPTS    =
WAVESAVEFILE  = waves.gtkw

# --------------------------------------------
# Global exported environment variables
# --------------------------------------------

HW_SRC       := $(CURDIR)/../1.hw
BLD_DIR      := $(CURDIR)/../3.build
TB_NAME      := tb

export BLD_DIR HW_SRC TB_NAME

# --------------------------------------------
# VProc C/C++ variables
# --------------------------------------------

VPROC_REPO    = https://github.com/wyvernSemi/vproc.git
VLIB          = $(CURDIR)/libvproc.a
VPROCDIR      = $(CURDIR)/../../vproc
VPROCMKFILE   = makefile.verilator

# --------------------------------------------
# Memory model variables
# --------------------------------------------

MEMMODEL_REPO = https://github.com/wyvernSemi/mem_model.git
MEMMODELDIR   = $(CURDIR)/../../mem_model
MEM_C         = mem.c mem_model.c

# C/C++ include paths for VProc, memory model and user code
INCLPATHS     = -I$(USRCODEDIR) -I$(VPROCDIR)/code -I$(MEMMODELDIR)/src

# --------------------------------------------
# Simulation variables
# --------------------------------------------

TBFILELIST    = $(MEMMODELDIR)/mem_model.sv                \
                $(VPROCDIR)/f_VProc.sv                     \
                                                           \
                models/soc_cpu.VPROC.sv                    \
                models/bfm_uart.sv                         \
                models/bfm_adc.sv                          \
                models/gowin.prim_sim.CHILI.v              \
                                                           \
                $(TB_NAME).sv

WORKDIR       = output

SIMOPTS       = --cc                                       \
                --timescale-override 1ps/1ps               \
                --exe versimSV.cpp                         \
                -sv                                        \
                $(TRACEOPTS) $(TIMINGOPT) $(USRSIMOPTS)    \
                -Mdir $(WORKDIR)                           \
                -Wno-WIDTH

SIMDEFS       = +define+VPROC_BYTE_ENABLE                  \
                +define+SIM_ONLY                           \
#                                                          \
#                +define+SDRAM_DEBUG                        \
#                +define+DAC_DEBUG                          \
#                +define+UART_BFM_DEBUG                     \
#                +define+ADC_DEBUG+ADC_BFM_DEBUG

SIMINCLPATHS  = -I$(CURDIR) -I$(VPROCDIR) -I$(MEMMODELDIR)
SIMCFLAGS     = -std=c++20 -Wno-attributes

# Get OS type
OSTYPE       := $(shell uname)

ifneq ($(OSTYPE), Linux)
  SIMLDFLAGS  = -Wl,-export-all-symbols
else
  SIMLDFLAGS  = -Wl,-E
endif

SIMMAKEFLAGS  = --quiet
SIMEXE        = $(WORKDIR)/V$(TB_NAME)

#
# GTKWave variables
#
GTKWAVEOPTS = --saveonexit                                 \
              --stems   ./tb.stems                         \
              --logfile sim.log                            \
              --dump    $(WAVEFILE)

WAVEFILE      = wave.fst

#
# Formatting
#

SPC =

#======================================================
# BUILD RULES
#======================================================

.PHONY: all, compile, run, rungui, gui, help, clean

all: $(TOPFILELIST) $(SIMEXE)

#
# Call VProc's Verilator test makefile to compile library into
# this directory, including the memory model code and user code.
#
$(VLIB): $(VPROCDIR) $(MEMMODELDIR)
	@make --no-print-directory -C $(VPROCDIR)/test     \
              -f $(VPROCMKFILE) ARCHFLAG=$(OPTFLAG)        \
              USRFLAGS="$(INCLPATHS) $(USRFLAGS)"          \
              USRCDIR=$(USRCODEDIR)                        \
              USER_C="$(USER_C)"                           \
              MEMMODELDIR=$(MEMMODELDIR)/src               \
              MEM_C="$(MEM_C)"                             \
              TESTDIR=$(CURDIR)                            \
              $(VLIB)

#
# Compile simulation C++ code
#
compile:
	@verilator  -F $(TOPFILELIST) $(TBFILELIST)        \
                       $(SIMOPTS)                          \
                       $(SIMDEFS) $(SIMINCLPATHS)          \
                       $(ARE_TESTS)                        \
           --top       $(TB_NAME)                          \
           -MAKEFLAGS "$(SIMMAKEFLAGS)"                    \
           -CFLAGS    "$(SIMCFLAGS)"                       \
           -LDFLAGS   "$(SIMLDFLAGS)                       \
           -Wl,-whole-archive -L../ -lvproc -Wl,-no-whole-archive -ldl"

#
# Generate Verilator test bench executable
#
$(SIMEXE): $(VLIB) compile
	@make --no-print-directory $(SIMMAKEFLAGS) -C$(WORKDIR) -f V$(TB_NAME).mk V$(TB_NAME)

# Create local file list for top, with PicoRv32 files removed
# So soc_cpu.VPROC can be used instead
$(TOPFILELIST): $(HW_SRC)/$(TOPFILELIST)
	@sed -e "/$(SOCCPUMATCH)/d" $< > $@

#
# Check out VProc repo if not at expected location
#
$(VPROCDIR):
	@git clone $(VPROC_REPO) $(VPROCDIR) --recursive

#
# Check out memory model repo if not at expected location
#
$(MEMMODELDIR):
	@git clone $(MEMMODEL_REPO) $(MEMMODELDIR) --recursive

xml2stems:
	@verilator                                         \
                --timing                                   \
                -xml-only                                  \
                -xml-output tb.xml                         \
                --timescale 1ps/1ps                        \
                $(SIMINCLPATHS) $(SIMDEFS)                 \
                -f $(TOPFILELIST)                          \
                $(TBFILELIST)                              \
                -MAKEFLAGS "$(SIMMAKEFLAGS)"               \
                -Wno-WIDTH                                 \
                --top-module $(TB_NAME)
	@xml2stems tb.xml tb.stems

#======================================================
# EXECUTION RULES
#======================================================

run: all
	@$(SIMEXE)

rungui: all xml2stems
	@$(SIMEXE) | tee sim.log
	@if [ -e $(WAVESAVEFILE) ]; then                   \
            gtkwave -a $(WAVESAVEFILE) $(GTKWAVEOPTS);     \
        else                                               \
            gtkwave $(GTKWAVEOPTS);                        \
        fi

gui: rungui

help:
	@$(info make -f MakefileVProc.mk help          Display this message)
	@$(info make -f MakefileVProc.mk               Build C/C++ and HDL code without running simulation)
	@$(info make -f MakefileVProc.mk run           Build and run batch simulation)
	@$(info make -f MakefileVProc.mk rungui/gui    Build and run GUI simulation)
	@$(info make -f MakefileVProc.mk clean         clean previous build artefacts)
	@$(info )
	@$(info Command line configurable variables:)
	@$(info $(SPC) $(SPC) USER_C:       list of user source code files (default VUserMain0.cpp))
	@$(info $(SPC) $(SPC) USRCODEDIR:   directory containing user source code (default $$(CURDIR)/usercode))
	@$(info $(SPC) $(SPC) OPTFLAG:      Optimisation flag for VProc code (default -g))
	@$(info $(SPC) $(SPC) TIMINGOPT:    Verilator timing flags (default --timing))
	@$(info $(SPC) $(SPC) TRACEOPTS:    Verilator trace flags (default --trace-fst --trace-structs))
	@$(info $(SPC) $(SPC) TOPFILELIST:  RTL file list name (default top.filelist))
	@$(info $(SPC) $(SPC) SOCCPUMATCH:  string to match for soc_cpu filtering in h/w file list (default ip.cpu))
	@$(info $(SPC) $(SPC) USRSIMOPTS:   additional Verilator flags, such as setting generics (default blank))
	@$(info $(SPC) $(SPC) WAVESAVEFILE: name of .gtkw file to use when displaying waveforms (default waves.gtkw))
	@$(info )

#======================================================
# CLEANING RULES
#======================================================

clean:
	@make --no-print-directory -C $(VPROCDIR)/test -f $(VPROCMKFILE) TESTDIR=$(CURDIR) clean
	@rm -rf $(WORKDIR) $(WAVEFILE) $(TOPFILELIST) obj_dir