vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 \
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

