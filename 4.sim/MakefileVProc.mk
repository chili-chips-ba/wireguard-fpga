###################################################################
# Makefile for Virtual USB code in Verilator
#
# Copyright (c) 2024 Simon Southwell.
#
# Make file for building VProc Video controller test bench
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this code. If not, see <http://www.gnu.org/licenses/>.
#
###################################################################

# Modifiable variables
USER_C        = VUserMain0.cpp
USRCODEDIR    = $(CURDIR)/usercode
TIMINGOPT     = --timing
TRACEOPTS     = --trace-fst --trace-structs
TOPFILELIST   = top.filelist
SOCCPUMATCH   = ip.cpu
WAVESAVEFILE  = waves.gtkw

# Global exported environment variables
HW_SRC       := $(CURDIR)/../1.hw
BLD_DIR      := $(CURDIR)/../3.build
TB_NAME      := tb

export BLD_DIR HW_SRC TB_NAME

# VProc C/C++ variables
VPROC_REPO    = https://github.com/wyvernSemi/vproc.git
VLIB          = $(CURDIR)/libvproc.a
VPROCDIR      = $(CURDIR)/../../vproc

# Memory model variables
MEMMODEL_REPO = https://github.com/wyvernSemi/mem_model.git
MEMMODELDIR   = $(CURDIR)/../../mem_model
MEM_C         = mem.c mem_model.c
INCLPATHS     = -I$(USRCODEDIR) -I$(VPROCDIR)/code -I$(MEMMODELDIR)/src
VPROCMKFILE   = makefile.verilator

# Simulation variables
TBFILELIST    = $(MEMMODELDIR)/mem_model.sv                \
                $(VPROCDIR)/f_VProc.sv                     \
                models/soc_cpu.VPROC.sv                    \
                models/bfm_uart.sv                         \
                models/bfm_adc.sv                          \
                models/gowin.prim_sim.CHILI.v              \
                $(TB_NAME).sv

WORKDIR       = output

SIMOPTS       = --cc                                       \
                --timescale-override 1ps/1ps               \
                --exe versimSV.cpp                         \
                -sv                                        \
                $(TRACEOPTS) $(TIMINGOPT)                  \
                -Mdir $(WORKDIR)                           \
                -Wno-TIMESCALEMOD -Wno-INITIALDLY -Wno-WIDTH

SIMDEFS       = +define+VPROC_BYTE_ENABLE                  \
                +define+SIM_ONLY                           \
                +define+SDRAM_DEBUG                        \
                +define+DAC_DEBUG                          \
                +define+UART_BFM_DEBUG                     \
                +define+ADC_DEBUG+ADC_BFM_DEBUG

SIMINCLPATHS  = -I$(CURDIR) -I$(VPROCDIR) -I$(MEMMODELDIR)
SIMCFLAGS     = -std=c++20 -Wno-attributes

# Get OS type
OSTYPE       := $(shell uname)

ifneq ($(OSTYPE), Linux)
  SIMLDFLAGS  = -Wl,-export-all-symbols
else
  SIMLDFLAGS  = -Wl,-E -lrt -rdynamic
endif

SIMMAKEFLAGS  = --quiet
SIMEXE        = $(WORKDIR)/V$(TB_NAME)

#
# GTKWave variables
#
WAVEFILE      = wave.fst

#------------------------------------------------------
# BUILD RULES
#------------------------------------------------------

.PHONY: all, run, rungui, gui, help, clean

all: $(TOPFILELIST) $(SIMEXE)

#
# Call VProc's Verilator test makefile to compile library into
# this directory, including the memory model code and user code.
#
$(VLIB): $(VPROCDIR) $(MEMMODELDIR)
	@make --no-print-directory -C $(VPROCDIR)/test     \
              -f $(VPROCMKFILE)                            \
              USRFLAGS="$(INCLPATHS) $(USRFLAGS)"          \
              USRCDIR=$(USRCODEDIR)                        \
              USER_C="$(USER_C)"                           \
              MEMMODELDIR=$(MEMMODELDIR)/src               \
              MEM_C="$(MEM_C)"                             \
              TESTDIR=$(CURDIR)                            \
              $(VLIB)

#
# Compile simulation executable
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

$(SIMEXE): $(VLIB) compile
	@make --no-print-directory $(SIMMAKEFLAGS) -C$(WORKDIR) -f V$(TB_NAME).mk V$(TB_NAME)

# Create local file list for top, with PicoRv32 file removed
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

#------------------------------------------------------
# EXECUTION RULES
#------------------------------------------------------

run: all
	@$(SIMEXE)

rungui: all
	@$(SIMEXE)
	@if [ -e $(WAVESAVEFILE) ]; then                   \
            gtkwave -a $(WAVESAVEFILE) $(WAVEFILE);        \
        else                                               \
            gtkwave $(WAVEFILE);                           \
        fi

gui: rungui

help:
	@$(info make help          Display this message)
	@$(info make               Build C/C++ and HDL code without running simulation)
	@$(info make run           Build and run batch simulation)
	@$(info make rungui/gui    Build and run GUI simulation)
	@$(info make clean         clean previous build artefacts)

#------------------------------------------------------
# CLEANING RULES
#------------------------------------------------------

clean:
	@make --no-print-directory -C $(VPROCDIR)/test -f $(VPROCMKFILE) TESTDIR=$(CURDIR) clean
	@rm -rf $(WORKDIR) $(WAVEFILE) $(TOPFILELIST) obj_dir