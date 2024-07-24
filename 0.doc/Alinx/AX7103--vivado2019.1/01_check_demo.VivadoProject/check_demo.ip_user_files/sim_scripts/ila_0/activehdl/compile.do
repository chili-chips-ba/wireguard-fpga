vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ila_0/hdl/verilog" \
"E:/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"E:/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ila_0/hdl/verilog" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ila_0/ila_0_sim_netlist.v" \

vlog -work xil_defaultlib \
"glbl.v"

