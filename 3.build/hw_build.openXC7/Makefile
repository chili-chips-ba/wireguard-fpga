# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

#==========================================================================
# wireguard-fpga openXC7 build, as on openPCIE (4.build/hw_build.openXC7)
#
#   TOOLCHAIN=new (default): openXC7 v1.0.0 -- Yosys 0.69 + nextpnr-himbaechel
#     (through the nextpnr-xilinx shim), chipdb from xilinx_gen.py, bitstream
#     with fpga-as. FRONTEND=slang (default) reads the SystemVerilog with
#     read_slang; FRONTEND=sv2v converts it with sv2v first.
#   TOOLCHAIN=old: the pre-v1.0.0 flow -- nextpnr-xilinx, chipdb from
#     bbaexport.py, fasm2frames + xc7frames2bit; sv2v only. PREFIX points to
#     that installation.
#
# Sources: 1.hw/top.filelist (sources.sh), the list Vivado, 4.sim and
# run-lint.sh use. The CPU is the one top.filelist lists (PicoRV32 by default).
# The firmware (3.build/sw_build/imem.INIT.vh) must be built first.
#
#   make                  full build -> build_artifacts.<sfx>/top.bit
#   make check-env        verify the tools are present
#   make FRONTEND=sv2v    sv2v instead of read_slang
#   make TOOLCHAIN=old    legacy flow
#==========================================================================

TOOLCHAIN ?= new
FRONTEND  ?= $(if $(filter old,$(TOOLCHAIN)),sv2v,slang)

ifeq ($(TOOLCHAIN),new)
    # openXC7 v1.0.0 prefix: NEXTPNR_XILINX_DIR (set-env), else where yosys is
    OPENXC7_ROOT   ?= $(or $(NEXTPNR_XILINX_DIR),$(abspath $(dir $(shell command -v yosys))..))
    PRJXRAY_DB_DIR ?= $(OPENXC7_ROOT)/share/nextpnr/prjxray-db
    XILINX_GEN      = $(OPENXC7_ROOT)/share/nextpnr/himbaechel/uarch/xilinx/gen/xilinx_gen.py
    TC_SFX          = $(if $(filter sv2v,$(FRONTEND)),.new,.slang)
    ifeq ($(filter sv2v slang,$(FRONTEND)),)
        $(error FRONTEND must be "sv2v" or "slang", got "$(FRONTEND)")
    endif
else ifeq ($(TOOLCHAIN),old)
    ifneq ($(FRONTEND),sv2v)
        $(error FRONTEND=$(FRONTEND) needs TOOLCHAIN=new -- the old Yosys has no read_slang)
    endif
    PREFIX         ?= /opt/openxc7
    PRJXRAY_DB_DIR ?= $(PREFIX)/share/prjxray-db
    BBAEXPORT       = $(PREFIX)/share/nextpnr-xilinx/python/bbaexport.py
    TC_SFX          =
else
    $(error TOOLCHAIN must be "old" or "new", got "$(TOOLCHAIN)")
endif

SV2V               ?= sv2v
YOSYS              ?= yosys
YOSYS_CONFIG       ?= yosys-config
NEXTPNR_XILINX     ?= nextpnr-xilinx
NEXTPNR_HIMBAECHEL ?= nextpnr-himbaechel
BBASM              ?= bbasm
FPGA_AS            ?= fpga-as
FASM2FRAMES        ?= fasm2frames
XC7FRAMES2BIT      ?= xc7frames2bit
OPENXC7_PYTHON     ?= python3

# the nextpnr-xilinx shim calls this nextpnr-himbaechel
export NEXTPNR_HIMBAECHEL_BIN := $(NEXTPNR_HIMBAECHEL)

DB_DIR = $(PRJXRAY_DB_DIR)
CHIPDB = chipdb$(if $(filter new,$(TOOLCHAIN)),.new)

# ALINX AX7201: Artix-7 200T, FBG484, speed grade -2
PART = xc7a200tfbg484-2
TOP  = top

HW_DIR         = ../../1.hw
BUILD_DIR_ROOT = ..
XDC_FILE       = $(HW_DIR)/constraints/top.xdc
IMEM_INIT      = $(BUILD_DIR_ROOT)/sw_build/imem.INIT.vh

CONV_DIR          = converted$(TC_SFX)
EXTRACTED_DIR     = $(CONV_DIR)/extracted
BUILD_ARTIFACTS   = build_artifacts$(TC_SFX)
CONV_TIMESTAMP    = $(CONV_DIR)/.conversion_timestamp
EXTRACT_TIMESTAMP = $(EXTRACTED_DIR)/.extraction_timestamp

# =============================================================================
# SOURCE FILES: 1.hw/top.filelist, the list Vivado, 4.sim and run-lint.sh use
# (sources.sh). The CPU is the one top.filelist lists (PicoRV32 by default).
# =============================================================================

DESIGN_RTL := $(shell bash -c '. ./sources.sh && design_rtl $(HW_DIR) $(BUILD_DIR_ROOT)')

# eth_mac_1g instantiates the MAC control blocks in a generate branch
# (MAC_CTRL_ENABLE = 0): not in top.filelist, but Yosys reads every module
MAC_CTRL_SRC = \
    $(HW_DIR)/external_lib/ethernet/mac_ctrl_rx.v \
    $(HW_DIR)/external_lib/ethernet/mac_ctrl_tx.v \
    $(HW_DIR)/external_lib/ethernet/mac_pause_ctrl_rx.v \
    $(HW_DIR)/external_lib/ethernet/mac_pause_ctrl_tx.v

# Pure Verilog (external_lib): read by Yosys as is, no conversion needed
PURE_V_FILES = $(filter %.v,$(DESIGN_RTL)) $(MAC_CTRL_SRC)

# SystemVerilog, in top.filelist order
SV_ORDERED = $(filter %.sv,$(DESIGN_RTL))

# Xilinx primitives the RTL instantiates (stubs for read_slang)
XILINX_PRIMS = PLLE2_BASE BUFG IBUFGDS BUFGMUX BUFIO BUFIO2 BUFR ODDR ODDR2

.PHONY: all convert check-env check-sources clean clean-converted clean-all help info
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:

all: $(BUILD_ARTIFACTS)/top.bit

help info:
	@echo "openXC7 build, TOOLCHAIN=$(TOOLCHAIN) FRONTEND=$(FRONTEND), part $(PART)"
	@echo "  make                full build -> $(BUILD_ARTIFACTS)/top.bit"
	@echo "  make FRONTEND=sv2v  sv2v instead of read_slang"
	@echo "  make TOOLCHAIN=old  pre-v1.0.0 flow (nextpnr-xilinx, PREFIX=<install>)"
	@echo "  make check-env      verify the tools are present"
	@echo "  make check-sources  verify the source files are present"
	@echo "  make clean          remove $(BUILD_ARTIFACTS)/"
	@echo "  make clean-all      also the conversion and the chipdb"
	@echo "  make check-sv2v | install-sv2v | show-converted   sv2v helpers"

check-env:
	@for t in $(YOSYS) $(YOSYS_CONFIG) $(NEXTPNR_XILINX) $(BBASM) $(OPENXC7_PYTHON) \
	          $(if $(filter sv2v,$(FRONTEND)),$(SV2V)) \
	          $(if $(filter new,$(TOOLCHAIN)),$(NEXTPNR_HIMBAECHEL) $(FPGA_AS),$(FASM2FRAMES) $(XC7FRAMES2BIT)); do \
	    command -v $$t > /dev/null || { echo "ERROR: $$t not found"; exit 1; }; \
	done
	@test -d "$(DB_DIR)/artix7" || { echo "ERROR: no prjxray-db for artix7 in $(DB_DIR)"; exit 1; }
	@$(if $(filter new,$(TOOLCHAIN)),test -f "$(XILINX_GEN)" || { echo "ERROR: chipdb generator not found: $(XILINX_GEN)"; exit 1; })
	@$(if $(filter slang,$(FRONTEND)),$(YOSYS) -p help 2>/dev/null | grep -q read_slang || { echo "ERROR: this yosys has no read_slang"; exit 1; })
	@echo "OK -- TOOLCHAIN=$(TOOLCHAIN), FRONTEND=$(FRONTEND), prjxray-db $(DB_DIR)"

check-sources:
	@missing=0; \
	for f in $(SV_ORDERED) $(PURE_V_FILES) $(XDC_FILE) $(IMEM_INIT); do \
	    [ -f "$$f" ] || { echo "MISSING: $$f"; missing=$$((missing + 1)); }; \
	done; \
	[ $$missing -eq 0 ] || { echo "ERROR: $$missing file(s) missing (imem.INIT.vh: build the firmware first)"; exit 1; }; \
	echo "OK -- $(words $(SV_ORDERED)) SV + $(words $(PURE_V_FILES)) V + xdc + imem.INIT.vh"

# =============================================================================
# FRONTEND=sv2v: batch conversion, then one file per module
# =============================================================================
convert: $(EXTRACT_TIMESTAMP)

$(CONV_TIMESTAMP): $(SV_ORDERED) $(IMEM_INIT)
	@command -v $(SV2V) > /dev/null || { echo "ERROR: $(SV2V) not found"; exit 1; }
	@mkdir -p $(CONV_DIR)
	@if $(SV2V) -DSYNTHESIS -I$(BUILD_DIR_ROOT)/sw_build -I$(HW_DIR) $(SV_ORDERED) \
	        > $(CONV_DIR)/all_converted.v 2> $(CONV_DIR)/sv2v.log; then \
	    echo "OK -> $(CONV_DIR)/all_converted.v ($$(grep -c '^module ' $(CONV_DIR)/all_converted.v) modules)"; \
	else \
	    echo "ERROR: sv2v conversion failed:"; cat $(CONV_DIR)/sv2v.log; exit 1; \
	fi
	@touch $@

$(EXTRACT_TIMESTAMP): $(CONV_TIMESTAMP)
	@rm -rf $(EXTRACTED_DIR)
	@mkdir -p $(EXTRACTED_DIR)
	$(OPENXC7_PYTHON) extract_modules.py $(CONV_DIR)/all_converted.v $(EXTRACTED_DIR)
	@touch $@

# =============================================================================
# SYNTHESIS (Yosys)
# =============================================================================
# TOOLCHAIN=new: nextpnr-himbaechel has no BEL for BUFGMUX; bufgmux_map.v
# builds it from a BUFGCTRL after synthesis
BUFGMUX_MAP = $(if $(filter new,$(TOOLCHAIN)),techmap -map bufgmux_map.v;)

ifeq ($(FRONTEND),slang)
$(BUILD_ARTIFACTS)/top.json: $(SV_ORDERED) $(PURE_V_FILES) $(IMEM_INIT) gen_xilinx_bb.py bufgmux_map.v
	@mkdir -p $(BUILD_ARTIFACTS)
	$(OPENXC7_PYTHON) gen_xilinx_bb.py "$$($(YOSYS_CONFIG) --datdir)/xilinx" \
	    $(BUILD_ARTIFACTS)/xilinx_bb.sv $(XILINX_PRIMS)
	$(YOSYS) -q -l $(BUILD_ARTIFACTS)/yosys.log \
	    -p "read_slang -D SYNTHESIS -D SYN_YOSYS_BUG --top $(TOP) -I $(BUILD_DIR_ROOT)/sw_build \
	                   $(BUILD_ARTIFACTS)/xilinx_bb.sv $(SV_ORDERED) $(PURE_V_FILES); \
	        proc; opt; clean; delete t:\$$scopeinfo; \
	        synth_xilinx -flatten -abc9 -arch xc7 -top $(TOP); \
	        $(BUFGMUX_MAP) \
	        write_json $@"
else
$(BUILD_ARTIFACTS)/top.json: $(EXTRACT_TIMESTAMP) $(PURE_V_FILES) $(IMEM_INIT) bufgmux_map.v
	@mkdir -p $(BUILD_ARTIFACTS)
	$(YOSYS) -q -l $(BUILD_ARTIFACTS)/yosys.log \
	    -p "read_verilog $(wildcard $(EXTRACTED_DIR)/*.v) $(PURE_V_FILES); \
	        proc; opt; clean; delete t:\$$scopeinfo; \
	        synth_xilinx -flatten $(if $(filter new,$(TOOLCHAIN)),-abc9) -arch xc7 -top $(TOP); \
	        $(BUFGMUX_MAP) \
	        write_json $@"
endif

# =============================================================================
# CHIPDB: per die; the file name keeps the part, which the shim passes on
# =============================================================================
ifeq ($(TOOLCHAIN),new)
$(CHIPDB)/$(PART).bin:
	@mkdir -p $(CHIPDB)
	$(OPENXC7_PYTHON) $(XILINX_GEN) --xray $(DB_DIR)/artix7 --device xc7a200t --bba $(PART).bba
	$(BBASM) -l $(PART).bba $@
	@rm -f $(PART).bba
else
$(CHIPDB)/$(PART).bin:
	@mkdir -p $(CHIPDB)
	$(OPENXC7_PYTHON) $(BBAEXPORT) --device $(PART) --bba $(PART).bba
	$(BBASM) -l $(PART).bba $@
	@rm -f $(PART).bba
endif

# =============================================================================
# PLACE AND ROUTE. The exit status is taken directly, not through tee: make
# uses /bin/sh (dash), which has no pipefail.
# =============================================================================
SEED ?= 3  # PicoRV32 meets timing at seed 3, eduBOS5 at seed 1 (#48)

# TOOLCHAIN=new: timing-driven ripup and a heavier placer timing weight. The
# Ethernet RX clocks (verilog-ethernet's axis_async_fifo write-pointer logic)
# sit near 125 MHz: with the defaults, seeds 1-4 each missed 1-3 RX clocks
# (102-128 MHz); with these, seed 1 meets all (RX 127-137, sys_clk 83 MHz).
NEXTPNR_OPTS ?= $(if $(filter new,$(TOOLCHAIN)),--tmg-ripup --placer-heap-timingweight 30)

# nextpnr reads XDC constraints on ports only (get_ports). top.xdc is shared
# with Vivado and also holds its ILA debug core, MARK_DEBUG, false paths
# between clocks, CLOCK_DEDICATED_ROUTE and [current_design] bitstream
# options; nextpnr gets the port lines: pins, I/O standards, clocks.
# top.openxc7.xdc adds what nextpnr needs and Vivado infers (clk_n's pin).
NEXTPNR_XDC = $(BUILD_ARTIFACTS)/top.nextpnr.xdc

$(NEXTPNR_XDC): $(XDC_FILE) top.openxc7.xdc
	@mkdir -p $(BUILD_ARTIFACTS)
	grep -E 'get_ports' $< | grep -v -E '^\s*#|get_(nets|clocks|pins|cells|debug)' > $@
	grep -v -E '^\s*#|^\s*$$' top.openxc7.xdc >> $@
	@echo "OK -> $@ ($$(wc -l < $@) port constraints)"

$(BUILD_ARTIFACTS)/top.fasm: $(BUILD_ARTIFACTS)/top.json $(CHIPDB)/$(PART).bin $(NEXTPNR_XDC)
	@$(NEXTPNR_XILINX) \
	    --chipdb $(CHIPDB)/$(PART).bin \
	    --xdc $(NEXTPNR_XDC) \
	    --json $< \
	    --fasm $@ \
	    --seed $(SEED) $(NEXTPNR_OPTS) \
	    --verbose \
	    > $(BUILD_ARTIFACTS)/nextpnr.log 2>&1; \
	rc=$$?; \
	tail -3 $(BUILD_ARTIFACTS)/nextpnr.log; \
	[ $$rc -eq 0 ] || { echo "ERROR: nextpnr failed (rc=$$rc), see $(BUILD_ARTIFACTS)/nextpnr.log"; exit 1; }
	@test -s $@ || { echo "ERROR: $@ is empty or missing"; exit 1; }
	@grep -E "Max frequency" $(BUILD_ARTIFACTS)/nextpnr.log | tail -6

# =============================================================================
# BITSTREAM
# =============================================================================
ifeq ($(TOOLCHAIN),new)
$(BUILD_ARTIFACTS)/top.bit: $(BUILD_ARTIFACTS)/top.fasm
	$(FPGA_AS) --prjxray_db_path=$(DB_DIR)/artix7 --part $(PART) < $< > $@
	@test -s $@ || { echo "ERROR: $@ is empty"; exit 1; }
	@ls -lh $@
else
$(BUILD_ARTIFACTS)/top.frames: $(BUILD_ARTIFACTS)/top.fasm
	$(FASM2FRAMES) --part $(PART) --db-root $(DB_DIR)/artix7 $< > $@

$(BUILD_ARTIFACTS)/top.bit: $(BUILD_ARTIFACTS)/top.frames
	$(XC7FRAMES2BIT) --part_file $(DB_DIR)/artix7/$(PART)/part.yaml --part_name $(PART) \
	    --frm_file $< --output_file $@
	@ls -lh $@
endif

# =============================================================================
# sv2v helpers (FRONTEND=sv2v, TOOLCHAIN=old; see 3.build/README.md)
# =============================================================================
.PHONY: check-sv2v install-sv2v show-converted

check-sv2v:
	@command -v $(SV2V) > /dev/null && $(SV2V) --version || \
	    { echo "ERROR: sv2v not found -- run: make install-sv2v"; exit 1; }

# sv2v from source with Stack, into ~/.local/bin
install-sv2v:
	@command -v stack > /dev/null || curl -sSL https://get.haskellstack.org/ | sh
	@[ -d sv2v-build ] || git clone https://github.com/zachjs/sv2v.git sv2v-build
	cd sv2v-build && stack install
	@echo "OK -- sv2v in ~/.local/bin; make sure it is on PATH"

show-converted:
	@ls -lh $(EXTRACTED_DIR)/*.v 2>/dev/null || echo "Nothing converted yet: make FRONTEND=sv2v convert"

clean:
	rm -rf $(BUILD_ARTIFACTS)

clean-converted:
	rm -rf $(CONV_DIR)

clean-all: clean clean-converted
	rm -rf $(CHIPDB)
