# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

#==========================================================================
# RTL-only simulation: the real soc_cpu RTL that 1.hw/top.filelist selects
# (PicoRV32 or eduBOS5) runs 3.build/sw_build. VProc only drives the sim
# control and the UDP/IPv4 BFMs (nodes 1-4). This is MakefileVProc.mk with
# CPU=rtl; see README.md, "RTL-Only Simulation".
#
#   make sim                                  build and run
#   make sim TIMEOUTUS=7000 USRSIMOPTS="+define+UART_BUS_STRESS"
#   make wave                                 build, run, then GTKWave
#   make clean
#==========================================================================

VPROCMK := $(MAKE) --no-print-directory -f MakefileVProc.mk CPU=rtl

.PHONY: all sim compile wave clean

all: sim

sim:
	@$(VPROCMK) run

compile:
	@$(VPROCMK) all

wave:
	@$(VPROCMK) gui

clean:
	@$(VPROCMK) clean
