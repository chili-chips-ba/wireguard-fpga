# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Makefile for wireguard-fpga openXC7 build
# Using sv2v batch conversion with post-extraction
#
# This Makefile implements a two-stage conversion process:
# 1. Batch sv2v conversion (all files together for dependency resolution)
# 2. Module extraction (split all_converted.v into individual files)

# =============================================================================
# CONFIGURATION - Adjust these values for your installation
# =============================================================================

# Local openXC7 installation path
PREFIX ?= /opt/openxc7

# Check if environment is setup
ifndef PRJXRAY_DB_DIR
$(error Please run: source $(PREFIX)/setup_env.sh)
endif

# Paths to databases and tools
DB_DIR = $(PREFIX)/share/prjxray-db
CHIPDB = chipdb

# FPGA Part specification (from .xpr: xc7a200tfbg484-2)
PART = xc7a200tfbg484-2

# Project directories (Makefile is in 3.build/hw_build.openXC7/)
CURR_DIR := $(CURDIR)
HW_DIR = ../../1.hw
BUILD_DIR_ROOT = ..

# Conversion output directories
CONV_DIR = converted
EXTRACTED_DIR = $(CONV_DIR)/extracted
BUILD_ARTIFACTS = build_artifacts

# =============================================================================
# SOURCE FILES (extracted from wireguard.xpr)
# =============================================================================

# External libraries - Ethernet (Pure Verilog - no conversion needed)
ETHERNET_SRC = \
    $(HW_DIR)/external_lib/ethernet/axis_gmii_rx.v \
    $(HW_DIR)/external_lib/ethernet/axis_gmii_tx.v \
    $(HW_DIR)/external_lib/ethernet/mac_ctrl_rx.v \
    $(HW_DIR)/external_lib/ethernet/mac_ctrl_tx.v \
    $(HW_DIR)/external_lib/ethernet/mac_pause_ctrl_rx.v \
    $(HW_DIR)/external_lib/ethernet/mac_pause_ctrl_tx.v \
    $(HW_DIR)/external_lib/ethernet/eth_mac_1g.v \
    $(HW_DIR)/external_lib/ethernet/eth_mac_1g_gmii.v \
    $(HW_DIR)/external_lib/ethernet/eth_mac_1g_gmii_fifo.v \
    $(HW_DIR)/external_lib/ethernet/gmii_phy_if.v \
    $(HW_DIR)/external_lib/ethernet/lfsr.v \
    $(HW_DIR)/external_lib/ethernet/oddr.v \
    $(HW_DIR)/external_lib/ethernet/ssio_sdr_in.v \
    $(HW_DIR)/external_lib/ethernet/ssio_sdr_out.v

# External libraries - AXIS (Pure Verilog - no conversion needed)
AXIS_SRC = \
    $(HW_DIR)/external_lib/axis/axis_adapter.v \
    $(HW_DIR)/external_lib/axis/axis_async_fifo.v \
    $(HW_DIR)/external_lib/axis/axis_async_fifo_adapter.v \
    $(HW_DIR)/external_lib/axis/axis_fifo.v \
    $(HW_DIR)/external_lib/axis/axis_register.v \
    $(HW_DIR)/external_lib/axis/sync_reset.v

PURE_V_FILES = $(ETHERNET_SRC) $(AXIS_SRC)

# =============================================================================
# SYSTEMVERILOG FILES - DEPENDENCY ORDERED
# =============================================================================
# CRITICAL: Files must be in dependency order for sv2v to resolve references
# Order: packages -> interfaces -> modules that use them -> top

SV_ORDERED = \
    $(BUILD_DIR_ROOT)/csr_build/generated-files/csr_pkg.sv \
    $(HW_DIR)/ip.infra/dpe_pkg.sv \
    $(HW_DIR)/ip.infra/soc_pkg.sv \
    $(HW_DIR)/ip.infra/dpe_if.sv \
    $(HW_DIR)/ip.infra/soc_if.sv \
    $(HW_DIR)/ip.infra/dpe_if_skid_buffer.sv \
    $(HW_DIR)/ip.infra/ethernet_mac.sv \
    $(HW_DIR)/ip.infra/ethernet_phy.sv \
    $(HW_DIR)/ip.infra/cpu_fifo.sv \
    $(HW_DIR)/ip.infra/soc_fabric.sv \
    $(HW_DIR)/ip.infra/soc_ram.sv \
    $(HW_DIR)/ip.infra/soc_csr.sv \
    $(HW_DIR)/ip.infra/uart.sv \
    $(HW_DIR)/ip.infra/sync_fifo_ram.sv \
    $(HW_DIR)/ip.infra/clk_rst_gen.sv \
    $(HW_DIR)/ip.dpe/dpe_demultiplexer.sv \
    $(HW_DIR)/ip.dpe/dpe_multiplexer.sv \
    $(HW_DIR)/ip.dpe/dpe_dummy_switch.sv \
    $(HW_DIR)/ip.dpe/dpe.sv \
    $(HW_DIR)/ip.cpu/cpu.PICORV32/picorv32.CHILI.sv \
    $(HW_DIR)/ip.cpu/cpu.PICORV32/picorv32_pcpi_mul.sv \
    $(HW_DIR)/ip.cpu/cpu.PICORV32/picorv32_pcpi_fast_mul.sv \
    $(HW_DIR)/ip.cpu/cpu.PICORV32/picorv32_pcpi_div.sv \
    $(HW_DIR)/ip.cpu/imem.sv \
    $(HW_DIR)/ip.cpu/soc_cpu.PICORV32.sv \
    $(HW_DIR)/fpgatech_lib/XILINX/fpga_pll_125M.sv \
    $(HW_DIR)/fpgatech_lib/XILINX/fpga_pll_80M.sv \
    $(BUILD_DIR_ROOT)/csr_build/generated-files/csr.sv \
    $(HW_DIR)/top.sv

# Software initialization file (required for imem module)
IMEM_INIT = $(BUILD_DIR_ROOT)/sw_build/imem.INIT.vh

# Constraint file
XDC_FILE = $(HW_DIR)/constraints/top.xdc

# Timestamps for incremental builds
CONV_TIMESTAMP = $(CONV_DIR)/.conversion_timestamp
EXTRACT_TIMESTAMP = $(EXTRACTED_DIR)/.extraction_timestamp

# =============================================================================
# SV2V INSTALLATION CHECK AND GUIDANCE
# =============================================================================

# Check if sv2v is available
SV2V := $(shell which sv2v 2>/dev/null)
STACK := $(shell which stack 2>/dev/null)

# =============================================================================
# PHONY TARGETS
# =============================================================================

.PHONY: all convert extract check-env check-sv2v install-sv2v check-sources \
        clean clean-converted clean-all info help show-converted show-expected

# =============================================================================
# MAIN TARGETS
# =============================================================================

all: top.bit

# Convert SV to V (includes conversion and extraction)
convert: $(EXTRACT_TIMESTAMP)
	@echo ""
	@echo "================================================================"
	@echo "✓ Conversion complete!"
	@echo "================================================================"
	@echo "Extracted modules in: $(EXTRACTED_DIR)/"
	@ls -1 $(EXTRACTED_DIR)/*.v 2>/dev/null | wc -l | xargs echo "Total .v files:"

# Just run extraction (assumes all_converted.v exists)
extract: $(EXTRACT_TIMESTAMP)

# =============================================================================
# SV2V INSTALLATION AND CHECKS
# =============================================================================

check-sv2v:
ifndef SV2V
	@echo "================================================================"
	@echo "ERROR: sv2v not found!"
	@echo "================================================================"
	@echo "sv2v is required to convert SystemVerilog to Verilog."
	@echo ""
	@echo "RECOMMENDED METHOD - Build from source with Stack:"
	@echo "================================================================"
	@echo ""
	@echo "Quick install:"
	@echo "  make install-sv2v"
	@echo ""
	@echo "Manual installation steps:"
	@echo "1. Install Stack (Haskell build tool):"
	@echo "   curl -sSL https://get.haskellstack.org/ | sh"
	@echo ""
	@echo "2. Clone and build sv2v:"
	@echo "   git clone https://github.com/zachjs/sv2v.git"
	@echo "   cd sv2v"
	@echo "   make"
	@echo ""
	@echo "3. Install to ~/.local/bin:"
	@echo "   stack install"
	@echo ""
	@echo "4. Ensure ~/.local/bin is in PATH:"
	@echo "   export PATH=\"\$$HOME/.local/bin:\$$PATH\""
	@echo "   echo 'export PATH=\"\$$HOME/.local/bin:\$$PATH\"' >> ~/.bashrc"
	@echo ""
	@echo "================================================================"
	@echo "ALTERNATIVE METHODS:"
	@echo "================================================================"
	@echo ""
	@echo "Method 2 - Using Cargo (Rust):"
	@echo "   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
	@echo "   source \$$HOME/.cargo/env"
	@echo "   cargo install sv2v"
	@echo ""
	@echo "Method 3 - Using apt (Ubuntu/Debian, if available):"
	@echo "   sudo apt update"
	@echo "   sudo apt install sv2v"
	@echo ""
	@echo "================================================================"
	@echo "After installation, verify with:"
	@echo "  sv2v --version"
	@echo "================================================================"
	@exit 1
else
	@echo "✓ sv2v found: $(SV2V)"
	@sv2v --version 2>/dev/null || echo "  (version info not available)"
endif

# Automated sv2v installation using Stack
install-sv2v:
	@echo "================================================================"
	@echo "Installing sv2v from source using Stack"
	@echo "================================================================"
	@echo ""
ifndef STACK
	@echo "Step 1: Installing Stack (Haskell build tool)..."
	@echo "----------------------------------------------------------------"
	@curl -sSL https://get.haskellstack.org/ | sh
	@echo ""
	@echo "✓ Stack installed. Reloading environment..."
	@export PATH="$$HOME/.local/bin:$$PATH"
else
	@echo "✓ Stack already installed: $(STACK)"
	@$(STACK) --version
	@echo ""
endif
	@echo "Step 2: Cloning sv2v repository..."
	@echo "----------------------------------------------------------------"
	@if [ ! -d "sv2v-build" ]; then \
		git clone https://github.com/zachjs/sv2v.git sv2v-build; \
	else \
		echo "sv2v-build directory already exists, using existing clone..."; \
	fi
	@echo ""
	@echo "Step 3: Building sv2v (this may take 10-20 minutes)..."
	@echo "----------------------------------------------------------------"
	@echo "Stack will download and compile GHC and all dependencies."
	@echo "Please be patient..."
	@echo ""
	@cd sv2v-build && make
	@echo ""
	@echo "Step 4: Installing sv2v to ~/.local/bin..."
	@echo "----------------------------------------------------------------"
	@cd sv2v-build && stack install
	@echo ""
	@echo "Step 5: Configuring PATH..."
	@echo "----------------------------------------------------------------"
	@if ! grep -q 'export PATH="$$HOME/.local/bin:$$PATH"' ~/.bashrc; then \
		echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> ~/.bashrc; \
		echo "✓ Added ~/.local/bin to PATH in ~/.bashrc"; \
	else \
		echo "✓ ~/.local/bin already in PATH"; \
	fi
	@echo ""
	@echo "================================================================"
	@echo "✓ sv2v installation complete!"
	@echo "================================================================"
	@echo ""
	@echo "Installation details:"
	@echo "  Binary location: ~/.local/bin/sv2v"
	@echo "  Source code:     $(CURDIR)/sv2v-build/"
	@echo ""
	@echo "Verify installation:"
	@echo "  source ~/.bashrc"
	@echo "  sv2v --version"
	@echo ""
	@echo "Or use immediately:"
	@echo "  export PATH=\"\$$HOME/.local/bin:\$$PATH\""
	@echo "  sv2v --version"
	@echo ""
	@echo "To uninstall sv2v:"
	@echo "  rm -f ~/.local/bin/sv2v"
	@echo "  rm -rf $(CURDIR)/sv2v-build/"
	@echo "================================================================"
	@echo ""
	@echo "You can now run: make convert"
	@echo "================================================================"

# =============================================================================
# ENVIRONMENT CHECKS
# =============================================================================

check-env:
	@echo "Checking environment..."
	@echo "PREFIX: $(PREFIX)"
	@echo "DB_DIR: $(DB_DIR)"
	@echo "PRJXRAY_DB_DIR: $(PRJXRAY_DB_DIR)"
	@which yosys > /dev/null || (echo "ERROR: yosys not found!" && exit 1)
	@which nextpnr-xilinx > /dev/null || (echo "ERROR: nextpnr-xilinx not found!" && exit 1)
	@which fasm2frames > /dev/null || (echo "ERROR: fasm2frames not found!" && exit 1)
	@which xc7frames2bit > /dev/null || (echo "ERROR: xc7frames2bit not found!" && exit 1)
	@which python3 > /dev/null || (echo "ERROR: python3 not found!" && exit 1)
	@echo "✓ Environment OK!"

check-sources:
	@echo "Checking source files..."
	@missing=0; \
	for file in $(PURE_V_FILES) $(XDC_FILE); do \
		if [ ! -f "$$file" ]; then \
			echo "MISSING: $$file"; \
			missing=$$((missing + 1)); \
		fi \
	done; \
	for file in $(SV_ORDERED); do \
		if [ ! -f "$$file" ]; then \
			echo "MISSING: $$file"; \
			missing=$$((missing + 1)); \
		fi \
	done; \
	if [ $$missing -gt 0 ]; then \
		echo "ERROR: $$missing source files are missing!"; \
		exit 1; \
	else \
		echo "✓ All $(words $(PURE_V_FILES)) pure Verilog files found"; \
		echo "✓ All $(words $(SV_ORDERED)) SystemVerilog files found"; \
	fi

# =============================================================================
# SV2V CONVERSION (BATCH MODE)
# =============================================================================

$(CONV_TIMESTAMP): $(SV_ORDERED) $(IMEM_INIT) | check-sv2v
	@echo "================================================================"
	@echo "Converting SystemVerilog to Verilog (BATCH MODE)"
	@echo "================================================================"
	@echo "Processing $(words $(SV_ORDERED)) SystemVerilog files..."
	@echo ""
	@mkdir -p $(CONV_DIR)
	@# Run sv2v in batch mode - all files together for dependency resolution
	@if sv2v \
		-I$(BUILD_DIR_ROOT)/sw_build \
		-I$(HW_DIR) \
		-I$(HW_DIR)/external_lib/ethernet \
		-I$(HW_DIR)/external_lib/axis \
		$(SV_ORDERED) \
		> $(CONV_DIR)/all_converted.v 2>$(CONV_DIR)/sv2v.log; then \
		lines=$$(wc -l < $(CONV_DIR)/all_converted.v); \
		modules=$$(grep -c "^module " $(CONV_DIR)/all_converted.v || echo 0); \
		echo "✓ Batch conversion successful!"; \
		echo "  Output: $(CONV_DIR)/all_converted.v"; \
		echo "  Lines: $$lines"; \
		echo "  Top-level modules: $$modules"; \
	else \
		echo "================================================================"; \
		echo "ERROR: sv2v conversion failed!"; \
		echo "================================================================"; \
		echo "Error log:"; \
		cat $(CONV_DIR)/sv2v.log; \
		echo ""; \
		echo "Common issues:"; \
		echo "  - Missing package: Check SV_ORDERED dependency order"; \
		echo "  - Unknown binding: Check source code"; \
		echo "  - Missing include: Check IMEM_INIT path"; \
		echo "================================================================"; \
		exit 1; \
	fi
	@touch $@

# =============================================================================
# MODULE EXTRACTION
# =============================================================================

$(EXTRACT_TIMESTAMP): $(CONV_TIMESTAMP)
	@echo ""
	@echo "================================================================"
	@echo "Extracting modules from converted output"
	@echo "================================================================"
	@mkdir -p $(EXTRACTED_DIR)
	@if [ -f "extract_modules.py" ]; then \
		python3 extract_modules.py $(CONV_DIR)/all_converted.v $(EXTRACTED_DIR); \
	else \
		echo "extract_modules.py not found, using simple AWK extraction..."; \
		echo "Splitting modules..."; \
		awk 'BEGIN { out = ""; in_module = 0; } \
		     /^module / { \
		         module_name = $$2; \
		         gsub(/[(;#].*/, "", module_name); \
		         out = "$(EXTRACTED_DIR)/" module_name ".v"; \
		         in_module = 1; \
		         print "  -> " module_name ".v"; \
		     } \
		     in_module { print >> out; } \
		     /^endmodule/ { \
		         if (in_module) { close(out); in_module = 0; } \
		     }' $(CONV_DIR)/all_converted.v; \
		echo ""; \
		echo "Creating stubs for packages/interfaces..."; \
		for pkg in dpe_pkg soc_pkg csr_pkg; do \
		    if [ ! -f "$(EXTRACTED_DIR)/$$pkg.v" ]; then \
		        echo "module $$pkg (); endmodule" > "$(EXTRACTED_DIR)/$$pkg.v"; \
		        echo "  -> $$pkg.v (stub)"; \
		    fi \
		done; \
		for iface in dpe_if soc_if gmii_if; do \
		    if [ ! -f "$(EXTRACTED_DIR)/$$iface.v" ]; then \
		        echo "module $$iface (); endmodule" > "$(EXTRACTED_DIR)/$$iface.v"; \
		        echo "  -> $$iface.v (stub)"; \
		    fi \
		done; \
	fi
	@touch $@

# =============================================================================
# SYNTHESIS
# =============================================================================

$(BUILD_ARTIFACTS)/top.json: $(EXTRACT_TIMESTAMP) $(IMEM_INIT)
	@echo "================================================================"
	@echo "Synthesis stage (Yosys)"
	@echo "================================================================"
	@mkdir -p $(BUILD_ARTIFACTS)
	@echo "Reading converted modules from: $(EXTRACTED_DIR)/"
	@echo "Reading pure Verilog from: external_lib/"
	@echo ""
	@# List all extracted .v files
	$(eval EXTRACTED_V := $(wildcard $(EXTRACTED_DIR)/*.v))
	yosys -p "proc; opt; clean; delete t:\$scopeinfo; synth_xilinx -arch xc7 -top top; write_json $(BUILD_ARTIFACTS)/top.json" \
		$(EXTRACTED_V) $(PURE_V_FILES)
	@echo ""
	@echo "✓ Synthesis complete: $@"

# =============================================================================
# CHIPDB GENERATION
# =============================================================================

$(CHIPDB)/$(PART).bin:
	@echo "================================================================"
	@echo "Generating chipdb for $(PART)..."
	@echo "================================================================"
	@echo "This may take several minutes..."
	@mkdir -p $(CHIPDB)
	python3 $(PREFIX)/share/nextpnr-xilinx/python/bbaexport.py \
		--device $(PART) \
		--bba $(PART).bba
	bbasm -l $(PART).bba $(CHIPDB)/$(PART).bin
	rm -f $(PART).bba
	@echo "✓ Chipdb generated: $@"

# =============================================================================
# PLACE AND ROUTE
# =============================================================================

$(BUILD_ARTIFACTS)/top.fasm: $(BUILD_ARTIFACTS)/top.json $(CHIPDB)/$(PART).bin
	@echo "================================================================"
	@echo "Place and Route stage (nextpnr-xilinx)"
	@echo "================================================================"
	nextpnr-xilinx --chipdb $(CHIPDB)/$(PART).bin \
		--xdc $(XDC_FILE) \
		--json $< \
		--fasm $@ \
		--verbose --debug \
		2>&1 | tee $(BUILD_ARTIFACTS)/nextpnr.log
	@echo ""
	@echo "✓ Place and Route complete: $@"

# =============================================================================
# BITSTREAM GENERATION
# =============================================================================

$(BUILD_ARTIFACTS)/top.frames: $(BUILD_ARTIFACTS)/top.fasm
	@echo "================================================================"
	@echo "FASM to frames conversion"
	@echo "================================================================"
	fasm2frames --part $(PART) --db-root $(DB_DIR)/artix7 $< > $@
	@echo "✓ Frames file created: $@"

top.bit: $(BUILD_ARTIFACTS)/top.frames
	@echo "================================================================"
	@echo "Bitstream generation"
	@echo "================================================================"
	xc7frames2bit --part_file $(DB_DIR)/artix7/$(PART)/part.yaml \
		--part_name $(PART) \
		--frm_file $< \
		--output_file $(BUILD_ARTIFACTS)/top.bit
	@echo "================================================================"
	@echo "SUCCESS! Bitstream created: $(BUILD_ARTIFACTS)/top.bit"
	@echo "================================================================"
	@ls -lh $(BUILD_ARTIFACTS)/top.bit

# =============================================================================
# UTILITY TARGETS
# =============================================================================

clean:
	@echo "Cleaning build artifacts..."
	@rm -f *.bit *.bba
	@rm -rf $(BUILD_ARTIFACTS)
	@echo "✓ Build artifacts cleaned"

clean-converted:
	@echo "Cleaning converted files..."
	@rm -rf $(CONV_DIR)
	@echo "✓ Converted files cleaned"

clean-all: clean clean-converted
	@echo "Cleaning chipdb..."
	@rm -rf $(CHIPDB)
	@echo "Cleaning sv2v build directory..."
	@rm -rf sv2v-build
	@echo "✓ All cleaned!"

show-converted:
	@echo "================================================================"
	@echo "Converted Verilog files:"
	@echo "================================================================"
	@if [ -d "$(EXTRACTED_DIR)" ]; then \
		ls -lh $(EXTRACTED_DIR)/*.v 2>/dev/null | awk '{print $$9, "(" $$5 ")"}' || echo "No files found"; \
	else \
		echo "Extraction directory does not exist yet."; \
		echo "Run: make convert"; \
	fi

show-expected:
	@echo "================================================================"
	@echo "Expected modules from source files:"
	@echo "================================================================"
	@echo "Packages (3):"
	@echo "  - csr_pkg, dpe_pkg, soc_pkg"
	@echo ""
	@echo "Interfaces (3):"
	@echo "  - dpe_if, soc_if, gmii_if"
	@echo ""
	@echo "Modules (~24):"
	@echo "  Infrastructure: ethernet_mac, ethernet_phy, cpu_fifo, soc_fabric,"
	@echo "                  soc_ram, soc_csr, uart, dpe_if_skid_buffer,"
	@echo "                  sync_fifo_ram, clk_rst_gen"
	@echo "  DPE:           dpe, dpe_demultiplexer, dpe_multiplexer, dpe_dummy_switch"
	@echo "  CPU:           picorv32, picorv32_pcpi_mul, picorv32_pcpi_fast_mul,"
	@echo "                 picorv32_pcpi_div, imem, soc_cpu"
	@echo "  PLL:           fpga_pll_125M, fpga_pll_80M"
	@echo "  Top:           csr, top"
	@echo ""
	@echo "NOTE: Packages and interfaces are inlined by sv2v (expected behavior)"

info:
	@echo "================================================================"
	@echo "WireGuard FPGA - openXC7 Build System"
	@echo "================================================================"
	@echo ""
	@echo "Configuration:"
	@echo "  Install Prefix:  $(PREFIX)"
	@echo "  Database Dir:    $(DB_DIR)"
	@echo "  FPGA Part:       $(PART)"
	@echo "  Top Module:      top"
	@echo ""
	@echo "Source files:"
	@echo "  Pure Verilog:    $(words $(PURE_V_FILES)) files (external_lib)"
	@echo "  SystemVerilog:   $(words $(SV_ORDERED)) files (ip.*)"
	@echo ""
	@echo "Build process:"
	@echo "  1. sv2v batch    - Convert all SV files together"
	@echo "  2. extract       - Split into individual modules"
	@echo "  3. yosys         - Synthesis"
	@echo "  4. nextpnr       - Place and route"
	@echo "  5. bitstream     - Generate .bit file"
	@echo ""
	@echo "Available targets:"
	@echo "  all              - Build complete bitstream (top.bit)"
	@echo "  convert          - Convert SV to V only"
	@echo "  install-sv2v     - Install sv2v from source (requires internet)"
	@echo "  check-env        - Verify openXC7 environment"
	@echo "  check-sources    - Verify all source files exist"
	@echo "  check-sv2v       - Verify sv2v installation"
	@echo "  show-converted   - List converted files"
	@echo "  show-expected    - List expected modules"
	@echo "  clean            - Remove build artifacts"
	@echo "  clean-converted  - Remove converted files"
	@echo "  clean-all        - Remove everything (incl. chipdb & sv2v)"
	@echo "  info             - Show this information"
	@echo "================================================================"

help: info

# =============================================================================
# DEPENDENCIES
# =============================================================================

# Ensure chipdb exists before PnR
$(BUILD_ARTIFACTS)/top.fasm: | $(CHIPDB)/$(PART).bin

# Ensure extraction happens before synthesis
$(BUILD_ARTIFACTS)/top.json: $(EXTRACT_TIMESTAMP)

# Ensure conversion happens before extraction
$(EXTRACT_TIMESTAMP): $(CONV_TIMESTAMP)
