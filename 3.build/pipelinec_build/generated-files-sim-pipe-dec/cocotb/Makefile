
SIM ?= ghdl
EXTRA_ARGS += --std=08
SIM_ARGS += --vcd=top.vcd --ieee-asserts=disable-at-0

TOPLEVEL_LANG ?= vhdl

#VERILOG_SOURCES += $(PWD)/my_design.sv
# use VHDL_SOURCES for VHDL files
VHDL_SOURCES += $(shell cat "/home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/vhdl_files.txt")

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = top

# MODULE is the basename of the Python test file
MODULE = test_top

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
      