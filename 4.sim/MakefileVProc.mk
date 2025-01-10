###################################################################
# Makefile for virtual processor WireGuard top level test bench
# code in Verilator
#
# Copyright (C) 2024 - 2025 Chili.CHIPS*ba
#
###################################################################

# --------------------------------------------
# Command line modifiable variables
# --------------------------------------------

USER_C           = VUserMain0.cpp
USRCODEDIR       = $(CURDIR)/usercode
OPTFLAG          = -g
TIMINGOPT        = --timing
TRACEOPTS        = --trace-fst --trace-structs
TOPFILELIST      = top.filelist
SOCCPUMATCH      = ip.cpu
USRSIMOPTS       =
WAVESAVEFILE     = waves.gtkw
BUILD            = DEFAULT
TIMEOUTUS        = 15000

# --------------------------------------------
# Global exported environment variables
# --------------------------------------------

HW_SRC          := $(CURDIR)/../1.hw
BLD_DIR         := $(CURDIR)/../3.build
TB_NAME         := tb

export BLD_DIR HW_SRC TB_NAME

# --------------------------------------------
# VProc C/C++ variables
# --------------------------------------------

# Location of VProc and memory model libraries
COSIMDIR         = $(CURDIR)/models/cosim
UDPDIR           = $(CURDIR)/models/udpPgIp

# --------------------------------------------
# RV32 ISS variables
# --------------------------------------------
# Get OS type
OSTYPE           = $(shell uname)

#
# If BUILD is ISS, then override user source code list and directory
# and define extra flags
#
ifeq ("$(BUILD)", "ISS")

  ifeq ("$(OSTYPE)", "Linux")
    RV32LIB      = rv32lnx
  else
    RV32LIB      = rv32win
    RV32WINOPTS  = -lWs2_32
    RV32WINFILES = getopt.c
  endif

  USER_C         = VUserMain0.cpp mem_vproc_api.cpp uart.cpp rv32_cache.cpp vuserutils.cpp $(RV32WINFILES)
  USRCODEDIR     = $(CURDIR)/models/rv32/usercode

  RV32DIR        = $(CURDIR)/models/rv32
  RV32INCLOPTS   = -I$(RV32DIR)/include
  RV32LDOPTS     = -L$(RV32DIR)/lib -l$(RV32LIB) $(RV32WINOPTS)
endif

# --------------------------------------------
# VProc user code build variables
# --------------------------------------------

# Compiler executables and standard flags
CC               = gcc
C++              = g++
CPPSTD           = -std=c++20

# C/C++ include paths for VProc, memory model and user code
INCLPATHS        = -I$(USRCODEDIR) -I$(COSIMDIR)/include -I$(UDPDIR) $(RV32INCLOPTS)
DEFS             = -DVERILATOR -DVPROC_SV -DVPROC

VOBJDIR          = $(CURDIR)/obj

# Separate C and C++ source files
USER_CPP_BASE    = $(notdir $(filter %cpp, $(USER_C)))
USER_C_BASE      = $(notdir $(filter %c,   $(USER_C)))

# Create list of object files (excluding any veriuser object)
VOBJS            = $(addprefix $(VOBJDIR)/,                   \
                    $(USER_C_BASE:%.c=%.o)                    \
                    $(USER_CPP_BASE:%.cpp=%.o))

USERLIB          = libuser.a

ifneq ("$(OSTYPE)", "Linux")
  COSIMLDOPT     = -lcosimwin
  UDPLDOPT       = -ludpwin
else
  COSIMLDOPT     = -lcosimlnx
  UDPLDOPT       = -ludplnx
endif

# --------------------------------------------
# Simulation variables
# --------------------------------------------

TBFILELIST       = $(COSIMDIR)/mem_model.sv                   \
                   $(COSIMDIR)/f_VProc.sv                     \
                   $(UDPDIR)/udp_ip_pg.v                      \
                                                              \
                   models/soc_cpu.VPROC.sv                    \
                   models/bfm_uart.sv                         \
                   models/bfm_adc.sv                          \
                   models/gowin.prim_sim.CHILI.v              \
                                                              \
                   $(TB_NAME).sv

WORKDIR          = output

SIMOPTS          = --cc                                       \
                   --timescale-override 1ps/1ps               \
                   --exe versimSV.cpp                         \
                   -sv                                        \
                   $(TRACEOPTS) $(TIMINGOPT) $(USRSIMOPTS)    \
                   -GRUN_SIM_US=$(TIMEOUTUS)                  \
                   -Mdir $(WORKDIR)                           \
                   -Wno-WIDTH

SIMDEFS          = +define+VPROC_BYTE_ENABLE                  \
                   +define+SIM_ONLY                           \
#                                                             \
#                   +define+SDRAM_DEBUG                        \
#                   +define+DAC_DEBUG                          \
#                   +define+UART_BFM_DEBUG                     \
#                   +define+ADC_DEBUG+ADC_BFM_DEBUG

SIMINCLPATHS     = -I$(CURDIR) -I$(COSIMDIR) -I$(UDPDIR)
SIMCFLAGS        = -std=c++20 -Wno-attributes

# Get OS type
OSTYPE          := $(shell uname)

ifneq ($(OSTYPE), Linux)
  SIMLDFLAGS     = -Wl,-export-all-symbols
else
  SIMLDFLAGS     = -Wl,-E
endif

SIMMAKEFLAGS     = --quiet
SIMEXE           = $(WORKDIR)/V$(TB_NAME)

#
# GTKWave variables
#
GTKWAVEOPTS    = --saveonexit                                 \
                 --stems   ./tb.stems                         \
                 --logfile sim.log                            \
                 --dump    $(WAVEFILE)

WAVEFILE         = wave.fst

#
# Formatting
#

SPC =

#======================================================
# BUILD RULES
#======================================================

.PHONY: all, compile, run, rungui, gui, help, clean

all: $(TOPFILELIST) $(SIMEXE)

# Rule to build object file temporary directory
$(VOBJDIR):
	@mkdir $(VOBJDIR)

# Rule to build user C sources
$(VOBJDIR)/%.o: $(USRCODEDIR)/%.c
	@$(CC) -c -fPIC $(OPTFLAG) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# Rule to build user C++ sources
$(VOBJDIR)/%.o: $(USRCODEDIR)/%.cpp
	@$(C++) -c -fPIC $(OPTFLAGS) $(CPPSTD) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# Rule to build library of user code
$(USERLIB): $(VOBJDIR) $(VOBJS)
	@ar cr $(USERLIB) $(VOBJS)

#
# Compile simulation C++ code
#
compile: $(USERLIB)
	@verilator  -F $(TOPFILELIST) $(TBFILELIST)           \
                       $(SIMOPTS)                             \
                       $(SIMDEFS) $(SIMINCLPATHS)             \
                       $(ARE_TESTS)                           \
           --top       $(TB_NAME)                             \
           -MAKEFLAGS "$(SIMMAKEFLAGS)"                       \
           -CFLAGS    "$(SIMCFLAGS)"                          \
           -LDFLAGS   "$(SIMLDFLAGS)                          \
                       -Wl,-whole-archive                     \
                       -L$(COSIMDIR)/lib $(COSIMLDOPT)        \
                       -L$(UDPDIR)/lib $(UDPLDOPT)            \
                       -L$(CURDIR) -luser                     \
                       -Wl,-no-whole-archive                  \
                       -ldl $(RV32LDOPTS)"

#
# Generate Verilator test bench executable
#
$(SIMEXE): compile
	@make --no-print-directory $(SIMMAKEFLAGS) -C$(WORKDIR) -f V$(TB_NAME).mk V$(TB_NAME)

# Create local file list for top, with PicoRv32 files removed
# So soc_cpu.VPROC can be used instead
$(TOPFILELIST): $(HW_SRC)/$(TOPFILELIST)
	@sed -e "/$(SOCCPUMATCH)/d" $< > $@

xml2stems:
	@verilator                                            \
                --timing                                      \
                -xml-only                                     \
                -xml-output tb.xml                            \
                --timescale 1ps/1ps                           \
                $(SIMINCLPATHS) $(SIMDEFS)                    \
                -f $(TOPFILELIST)                             \
                $(TBFILELIST)                                 \
                -MAKEFLAGS "$(SIMMAKEFLAGS)"                  \
                -Wno-WIDTH                                    \
                --top-module $(TB_NAME)
	@xml2stems tb.xml tb.stems

#======================================================
# EXECUTION RULES
#======================================================

run: all
	@$(SIMEXE)

rungui: all xml2stems
	@$(SIMEXE) | tee sim.log
	@if [ -e $(WAVESAVEFILE) ]; then                      \
            gtkwave -a $(WAVESAVEFILE) $(GTKWAVEOPTS);        \
        else                                                  \
            gtkwave $(GTKWAVEOPTS);                           \
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
	@$(info $(SPC) $(SPC) OPTFLAG:      Optimisation flag for user VProc code (default -g))
	@$(info $(SPC) $(SPC) TIMINGOPT:    Verilator timing flags (default --timing))
	@$(info $(SPC) $(SPC) TRACEOPTS:    Verilator trace flags (default --trace-fst --trace-structs))
	@$(info $(SPC) $(SPC) TOPFILELIST:  RTL file list name (default top.filelist))
	@$(info $(SPC) $(SPC) SOCCPUMATCH:  string to match for soc_cpu filtering in h/w file list (default ip.cpu))
	@$(info $(SPC) $(SPC) USRSIMOPTS:   additional Verilator flags, such as setting generics (default blank))
	@$(info $(SPC) $(SPC) WAVESAVEFILE: name of .gtkw file to use when displaying waveforms (default waves.gtkw))
	@$(info $(SPC) $(SPC) BUILD:        Select build type from DEFAULT or ISS (default DEFAULT))
	@$(info $(SPC) $(SPC) TIMEOUTUS:    Test bench timeout period in microseconds (default 15000))
	@$(info )

#======================================================
# CLEANING RULES
#======================================================

clean:
	@rm -rf $(WORKDIR) $(WAVEFILE) $(TOPFILELIST) $(VOBJDIR) $(USERLIB) obj_dir
