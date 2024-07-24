vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm

vlog -work xil_defaultlib -64 -incr -sv "+incdir+../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ila_0/hdl/verilog" \
"E:/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"E:/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ila_0/hdl/verilog" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ila_0/ila_0_sim_netlist.v" \

vlog -work xil_defaultlib \
"glbl.v"

