# Copyright (C) 2024 - 2025 Chili.CHIPS*ba
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba, 2024-2025
#
# SPDX-License-Identifier: BSD-3-Clause

# --------------------------------------------
# Command line modifiable variables
# --------------------------------------------

USER_C           =              # user sources for libuser (UDP nodes)
USRCODEDIR       = $(CURDIR)/usercode
OPTFLAG          = -g
TIMINGOPT        = --timing
TRACEOPTS        = --trace-fst --trace-structs
TOPFILELIST      = top.filelist
SOCCPUMATCH      = ip.cpu
USRSIMOPTS       =
USRCFLAGS        =
WAVESAVEFILE     = wave.CSR_ETHERNET_TEST.gtkw
BUILD            = DEFAULT
TIMEOUTUS        = 10000
DISABLE_SIM_CTRL = 1

# --------------------------------------------
# Global exported environment variables
# --------------------------------------------

HW_SRC          := $(CURDIR)/../1.hw
BLD_DIR         := $(CURDIR)/../3.build
SIM_DIR         := $(CURDIR)/../4.sim
TB_NAME         := tb

export BLD_DIR HW_SRC SIM_DIR TB_NAME

# --------------------------------------------
# VProc C/C++ variables
# --------------------------------------------

# Location of VProc and memory model libraries
COSIMDIR       = $(CURDIR)/models/cosim
UDPDIR         = $(CURDIR)/models/udpIpPg
UDP_C          = VUserMainUdp.cpp
UDPCODEDIR     = $(CURDIR)/usercode

# VProc external dependency (for VerilatorSimCtrl)
VPROC_REPO     = https://github.com/wyvernSemi/vproc.git
VLIB           = $(CURDIR)/libvproc.a
VPROCDIR       = $(CURDIR)/../../vproc
VPROCMKFILE    = makefile.verilator
VPROCVERSION   = VERSION_1_12_2
AUX_C          = VerilatorSimCtrl.cpp
AUXDIR         = $(VPROCDIR)/verilator/src

# Memory model (required by VProc build)
MEMMODEL_REPO  = https://github.com/wyvernSemi/mem_model.git
MEMMODELDIR    = $(CURDIR)/../../mem_model
MEM_C          = mem.c mem_model.c
MEMVERSION     = VERSION_1_0_0

# VProc user code (rv32 ISS + VSC) lives in models/rv32/usercode
VPROC_USRCDIR  = $(CURDIR)/models/rv32/usercode
VPROC_USER_C   = VUserMain0.cpp VUserMainVSC.cpp mem_vproc_api.cpp uart.cpp rv32_cache.cpp vuserutils.cpp

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

  # VProc ISS build: rv32 user code for node0 + VSC (node15) built into libvproc
  VPROC_USER_C   := $(VPROC_USER_C) $(RV32WINFILES)

  # UDP BFMs (nodes 1-4) stay in libuser from usercode/
  UDP_C          = VUserMainUdp.cpp

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
INCLPATHS        = -I$(USRCODEDIR) -I$(UDPCODEDIR) -I$(COSIMDIR)/include -I$(UDPDIR)/include -I$(VPROCDIR)/code -I$(VPROCDIR)/verilator/src -I$(MEMMODELDIR)/src -I$(VPROC_USRCDIR) $(RV32INCLOPTS)
DEFS             = -DVERILATOR -DVPROC_SV -DVPROC

VOBJDIR          = $(CURDIR)/obj

# Separate C and C++ source files
USER_CPP_BASE    = $(notdir $(filter %cpp, $(USER_C) $(UDP_C)))
USER_C_BASE      = $(notdir $(filter %c,   $(USER_C) $(UDP_C)))

# Create list of object files (excluding any veriuser object)
VOBJS            = $(addprefix $(VOBJDIR)/,                   \
                    $(USER_C_BASE:%.c=%.o)                    \
                    $(USER_CPP_BASE:%.cpp=%.o))

USERLIB          = libuser.a

# Rule to build object file temporary directory
$(VOBJDIR):
	@mkdir $(VOBJDIR)

# Rule to build user C sources
$(VOBJDIR)/%.o: $(USRCODEDIR)/%.c
	@$(CC) -c -fPIC $(OPTFLAG) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# Rule to build user C++ sources
$(VOBJDIR)/%.o: $(USRCODEDIR)/%.cpp
	@$(C++) -c -fPIC $(OPTFLAG) $(CPPSTD) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# Rule to build UDP user C sources
$(VOBJDIR)/%.o: $(UDPCODEDIR)/%.c
	@$(CC) -c -fPIC $(OPTFLAG) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# Rule to build UDP user C++ sources
$(VOBJDIR)/%.o: $(UDPCODEDIR)/%.cpp
	@$(C++) -c -fPIC $(OPTFLAG) $(CPPSTD) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# Rule to build library of user code
# Note: delete existing archive first to avoid stale objects (e.g. switching UDP_C)
$(USERLIB): $(VOBJDIR) $(VOBJS)
	@rm -f $(USERLIB)
	@ar crs $(USERLIB) $(VOBJS)

ifeq ("$(OSTYPE)", "Linux")
  COSIMLDOPT     = -lcosimlnx
  UDPLDOPT       = -ludplnx
else
  COSIMLDOPT     = -lcosimwin
  UDPLDOPT       = -ludpwin
endif

WARNOPTS       = -Wall models/config.vlt
USRCDEFS      = -DMEM_MODEL_DEFAULT_ENDIAN=1

# --------------------------------------------
# Simulation variables
# --------------------------------------------

TBFILELIST    = $(TB_NAME).filelist

WORKDIR          = output

SIMOPTS       = --cc                                          \
                --timescale-override 1ps/1ps                  \
                --exe versimSV.cpp                            \
                -sv                                           \
                $(TRACEOPTS) $(TIMINGOPT) $(USRSIMOPTS)       \
                -GRUN_SIM_US=$(TIMEOUTUS)                     \
                -GDISABLE_SIM_CTRL=$(DISABLE_SIM_CTRL)        \
                $(VPROCDIR)/verilator/verilator_sim_ctrl.sv   \
                -Mdir $(WORKDIR)                              \
                -Wno-WIDTH

SIMDEFS          = +define+VPROC_BYTE_ENABLE                  \
                   +define+SIM_ONLY                           \
#                                                             \
#                   +define+SDRAM_DEBUG                       \
#                   +define+UART_BFM_DEBUG

SIMINCLPATHS     = -I$(CURDIR) -I$(COSIMDIR) -I$(UDPDIR)/verilator -I$(VPROCDIR) -I$(VPROCDIR)/verilator -I$(MEMMODELDIR)
SIMCFLAGS        = -std=c++20 -Wno-attributes $(USRCFLAGS)

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

#
# Call VProc's Verilator test makefile to compile library into
# this directory, including the memory model code and user code.
#
$(VLIB): $(VPROCDIR) $(MEMMODELDIR) $(addprefix $(VPROC_USRCDIR)/,$(VPROC_USER_C))
	@make --no-print-directory -C $(VPROCDIR)/test        \
              -f $(VPROCMKFILE) ARCHFLAG=$(OPTFLAG)           \
              USRFLAGS="$(INCLPATHS) $(USRCDEFS) $(USRFLAGS)" \
              USRCDIR=$(VPROC_USRCDIR)                        \
              USER_C="$(VPROC_USER_C)"                        \
              MEMMODELDIR=$(MEMMODELDIR)/src                  \
              MEM_C="$(MEM_C)"                                \
              AUXDIR=$(AUXDIR)                                \
              AUX_C="$(AUX_C)"                                \
              TESTDIR=$(CURDIR)                               \
              $(VLIB)

#
# Compile simulation C++ code
#
compile: $(USERLIB) $(VLIB)
	@verilator     $(WARNOPTS)                            \
	               -F $(TOPFILELIST)                      \
                   -F $(TBFILELIST)                       \
	               $(SIMOPTS)                             \
	               $(SIMDEFS) $(SIMINCLPATHS)             \
	               $(ARE_TESTS)                           \
	   --top       $(TB_NAME)                             \
	   -MAKEFLAGS "$(SIMMAKEFLAGS)"                       \
	   -CFLAGS    "$(SIMCFLAGS)"                          \
	   -LDFLAGS   "$(SIMLDFLAGS)                          \
	               -Wl,-whole-archive                     \
	               -L$(CURDIR) -lvproc                    \
	               -L$(CURDIR) -luser                     \
	               -L$(UDPDIR)/lib $(UDPLDOPT)            \
	               -Wl,-no-whole-archive                  \
	               -ldl $(RV32LDOPTS)"

#
# Generate Verilator test bench executable
#
$(SIMEXE): compile
	@+make --no-print-directory $(SIMMAKEFLAGS) -C$(WORKDIR) -f V$(TB_NAME).mk V$(TB_NAME)

# Create local file list for top, with PicoRv32 files removed
# So soc_cpu.VPROC can be used instead
$(TOPFILELIST): $(HW_SRC)/$(TOPFILELIST)
	@sed -e "/$(SOCCPUMATCH)/d" $< > $@

# Check out VProc repo if not at expected location
$(VPROCDIR):
	@git clone --depth 1 --branch $(VPROCVERSION) $(VPROC_REPO) $(VPROCDIR) --recursive

# Check out memory model repo if not at expected location
$(MEMMODELDIR):
	@git clone --depth 1 --branch $(MEMVERSION) $(MEMMODEL_REPO) $(MEMMODELDIR) --recursive

xml2stems: $(TOPFILELIST)
	@verilator                                            \
            $(WARNOPTS)                                   \
	        --timing                                      \
	        -xml-only                                     \
	        -xml-output tb.xml                            \
	        --timescale 1ps/1ps                           \
	        $(SIMINCLPATHS) $(SIMDEFS)                    \
	        -F $(TOPFILELIST)                             \
	        -F $(TBFILELIST)                              \
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
	@$(info $(SPC) $(SPC) USER_C:           list of user source code files (default VUserMain0.cpp))
	@$(info $(SPC) $(SPC) USRCODEDIR:       directory containing user source code (default $$(CURDIR)/usercode))
	@$(info $(SPC) $(SPC) OPTFLAG:          Optimisation flag for VProc code (default -g))
	@$(info $(SPC) $(SPC) TIMINGOPT:        Verilator timing flags (default --timing))
	@$(info $(SPC) $(SPC) TRACEOPTS:        Verilator trace flags (default --trace-fst --trace-structs))
	@$(info $(SPC) $(SPC) TOPFILELIST:      RTL file list name (default top.filelist))
	@$(info $(SPC) $(SPC) SOCCPUMATCH:      string to match for soc_cpu filtering in h/w file list (default ip.cpu))
	@$(info $(SPC) $(SPC) USRSIMOPTS:       additional Verilator flags, such as setting generics (default blank))
	@$(info $(SPC) $(SPC) WAVESAVEFILE:     name of .gtkw file to use when displaying waveforms (default waves.gtkw))
	@$(info $(SPC) $(SPC) BUILD:            Select build type from DEFAULT or ISS (default DEFAULT))
	@$(info $(SPC) $(SPC) TIMEOUTUS:        Test bench timeout period in microseconds (default 15000))
	@$(info $(SPC) $(SPC) DISABLE_SIM_CTRL: Disable/enable Verilator simulation control (default disabled))
	@$(info )

#======================================================
# CLEANING RULES
#======================================================

clean:
	@rm -rf $(WORKDIR) $(WAVEFILE) $(TOPFILELIST) $(VOBJDIR) $(USERLIB) obj_dir
