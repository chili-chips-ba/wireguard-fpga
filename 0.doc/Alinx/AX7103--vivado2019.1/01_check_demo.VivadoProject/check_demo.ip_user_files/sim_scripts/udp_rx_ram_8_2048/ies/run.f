-makelib ies_lib/xil_defaultlib -sv \
  "E:/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "E:/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_3 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../src/eth/sources_1/ip/udp_rx_ram_8_2048/sim/udp_rx_ram_8_2048.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

