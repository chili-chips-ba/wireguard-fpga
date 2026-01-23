# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba, 2024-2025
#
# SPDX-License-Identifier: BSD-3-Clause

###################################################################
# Makefile for picoRV32 RTL simulation with Verilator
###################################################################

SHELL    := /bin/bash

# --------------------------------------------
# Directory layout
# --------------------------------------------
HW_SRC  := $(CURDIR)/../1.hw
BLD_DIR := $(CURDIR)/../3.build
SIM_DIR := $(CURDIR)/../4.sim
TB_NAME := tb
WORKDIR := output

export HW_SRC BLD_DIR SIM_DIR TB_NAME

# --------------------------------------------
# Co-simulation libraries
# --------------------------------------------
COSIMDIR := $(SIM_DIR)/models/cosim
UDPDIR   := $(SIM_DIR)/models/udpIpPg

COSIM_LDFLAGS := -L$(COSIMDIR)/lib -lcosimlnx
UDP_LDFLAGS   := -L$(UDPDIR)/lib   -ludplnx

# --------------------------------------------
# User code
# --------------------------------------------
UDPCODEDIR   := $(SIM_DIR)/usercode
USER_SOURCES := $(wildcard $(UDPCODEDIR)/*.cpp)

# --------------------------------------------
# File lists for Verilator
# --------------------------------------------
TOP_FILELIST := $(HW_SRC)/top.filelist
TB_FILELIST  := $(SIM_DIR)/simple_tb.filelist

# -----------------------------------------------------------------------------
.PHONY: all clean compile sim wave
# -----------------------------------------------------------------------------

all: clean sim wave

clean:
	@rm -rf $(WORKDIR) tb.xml tb.stems

# -----------------------------------------------------------------------------
# Generate C++ simulation sources and build into $(WORKDIR)
# -----------------------------------------------------------------------------
compile:
	verilator \
		--cc \
		-sv \
		--timing \
		--trace-fst \
		--trace-structs \
		--timescale-override 1ps/1ps \
		-Wall models/config.vlt \
		+incdir+$(COSIMDIR) \
		+define+SIM_ONLY \
		+define+VPROC_SV \
		-f $(TOP_FILELIST) \
		-f $(TB_FILELIST) \
		--top-module $(TB_NAME) \
		--exe versimSV.cpp usercode/VUserMainUdp.cpp $(USER_SOURCES) \
		-CFLAGS "-I$(COSIMDIR)/include -I$(UDPCODEDIR) -I$(UDPDIR)/include -DVERILATOR -DVPROC_SV -DVPROC" \
		-LDFLAGS "\
			-rdynamic \
			$(COSIM_LDFLAGS) \
			$(UDP_LDFLAGS)" \
		-Mdir $(WORKDIR)

# -----------------------------------------------------------------------------
# Build & run simulation
# -----------------------------------------------------------------------------
sim: compile
	$(MAKE) -C $(WORKDIR) -f V$(TB_NAME).mk V$(TB_NAME)
	@echo "==== START SIMULATION ===="
	./$(WORKDIR)/V$(TB_NAME) | tee sim.log

# -----------------------------------------------------------------------------
# View waveform (GTKWave)
# -----------------------------------------------------------------------------
wave:
	@echo "==== LAUNCHING GTKWave ===="
	cd $(SIM_DIR) && gtkwave wave.fst

