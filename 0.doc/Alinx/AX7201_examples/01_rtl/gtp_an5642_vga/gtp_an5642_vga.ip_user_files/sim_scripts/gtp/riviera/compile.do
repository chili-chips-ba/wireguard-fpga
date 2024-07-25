vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp/example_design/gtp_tx_startup_fsm.v" \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp/example_design/gtp_rx_startup_fsm.v" \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp_init.v" \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp_gt.v" \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp_multi_gt.v" \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp/example_design/gtp_gtrxreset_seq.v" \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp/example_design/gtp_rxpmarst_seq.v" \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp/example_design/gtp_rxrate_seq.v" \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp/example_design/gtp_sync_block.v" \
"../../../../gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp.v" \

vlog -work xil_defaultlib \
"glbl.v"

