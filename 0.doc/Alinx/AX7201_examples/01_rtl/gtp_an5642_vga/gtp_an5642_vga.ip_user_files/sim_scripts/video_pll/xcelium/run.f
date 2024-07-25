-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../gtp_an5642_vga.srcs/sources_1/ip/video_pll/video_pll_clk_wiz.v" \
  "../../../../gtp_an5642_vga.srcs/sources_1/ip/video_pll/video_pll.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

