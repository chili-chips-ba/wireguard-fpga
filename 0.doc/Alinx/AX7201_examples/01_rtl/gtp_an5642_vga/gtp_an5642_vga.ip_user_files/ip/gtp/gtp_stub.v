// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Fri Feb 24 12:34:21 2023
// Host        : alinx running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/extern_disk/meisq/ax7201/gtp_an5642_vga/gtp_an5642_vga/gtp_an5642_vga.srcs/sources_1/ip/gtp/gtp_stub.v
// Design      : gtp
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "gtp,gtwizard_v3_6_11,{protocol_file=aurora_8b10b_single_lane_4byte}" *)
module gtp(sysclk_in, soft_reset_tx_in, 
  soft_reset_rx_in, dont_reset_on_data_error_in, gt0_drp_busy_out, 
  gt0_tx_fsm_reset_done_out, gt0_rx_fsm_reset_done_out, gt0_data_valid_in, 
  gt0_tx_mmcm_lock_in, gt0_tx_mmcm_reset_out, gt0_rx_mmcm_lock_in, gt0_rx_mmcm_reset_out, 
  gt1_drp_busy_out, gt1_tx_fsm_reset_done_out, gt1_rx_fsm_reset_done_out, 
  gt1_data_valid_in, gt1_tx_mmcm_lock_in, gt1_tx_mmcm_reset_out, gt1_rx_mmcm_lock_in, 
  gt1_rx_mmcm_reset_out, gt2_drp_busy_out, gt2_tx_fsm_reset_done_out, 
  gt2_rx_fsm_reset_done_out, gt2_data_valid_in, gt2_tx_mmcm_lock_in, 
  gt2_tx_mmcm_reset_out, gt2_rx_mmcm_lock_in, gt2_rx_mmcm_reset_out, gt3_drp_busy_out, 
  gt3_tx_fsm_reset_done_out, gt3_rx_fsm_reset_done_out, gt3_data_valid_in, 
  gt3_tx_mmcm_lock_in, gt3_tx_mmcm_reset_out, gt3_rx_mmcm_lock_in, gt3_rx_mmcm_reset_out, 
  gt0_drpaddr_in, gt0_drpclk_in, gt0_drpdi_in, gt0_drpdo_out, gt0_drpen_in, gt0_drprdy_out, 
  gt0_drpwe_in, gt0_loopback_in, gt0_rxpd_in, gt0_txpd_in, gt0_eyescanreset_in, 
  gt0_rxuserrdy_in, gt0_eyescandataerror_out, gt0_eyescantrigger_in, gt0_rxcdrhold_in, 
  gt0_rxcdrovrden_in, gt0_rxclkcorcnt_out, gt0_rxdata_out, gt0_rxusrclk_in, 
  gt0_rxusrclk2_in, gt0_rxprbserr_out, gt0_rxprbssel_in, gt0_rxprbscntreset_in, 
  gt0_rxchariscomma_out, gt0_rxcharisk_out, gt0_rxdisperr_out, gt0_rxnotintable_out, 
  gt0_gtprxn_in, gt0_gtprxp_in, gt0_rxbufreset_in, gt0_rxbufstatus_out, 
  gt0_rxbyteisaligned_out, gt0_rxbyterealign_out, gt0_rxcommadet_out, 
  gt0_rxmcommaalignen_in, gt0_rxpcommaalignen_in, gt0_dmonitorout_out, 
  gt0_rxlpmhfhold_in, gt0_rxlpmhfovrden_in, gt0_rxlpmlfhold_in, gt0_rxoutclkfabric_out, 
  gt0_gtrxreset_in, gt0_rxlpmreset_in, gt0_rxpcsreset_in, gt0_rxpmareset_in, 
  gt0_rxpolarity_in, gt0_rxresetdone_out, gt0_txpostcursor_in, gt0_txprecursor_in, 
  gt0_gttxreset_in, gt0_txuserrdy_in, gt0_txdata_in, gt0_txusrclk_in, gt0_txusrclk2_in, 
  gt0_txprbsforceerr_in, gt0_txchardispmode_in, gt0_txchardispval_in, gt0_txcharisk_in, 
  gt0_txbufstatus_out, gt0_gtptxn_out, gt0_gtptxp_out, gt0_txdiffctrl_in, 
  gt0_txmaincursor_in, gt0_txoutclk_out, gt0_txoutclkfabric_out, gt0_txoutclkpcs_out, 
  gt0_txpcsreset_in, gt0_txpmareset_in, gt0_txresetdone_out, gt0_txpolarity_in, 
  gt0_txprbssel_in, gt1_drpaddr_in, gt1_drpclk_in, gt1_drpdi_in, gt1_drpdo_out, gt1_drpen_in, 
  gt1_drprdy_out, gt1_drpwe_in, gt1_loopback_in, gt1_rxpd_in, gt1_txpd_in, 
  gt1_eyescanreset_in, gt1_rxuserrdy_in, gt1_eyescandataerror_out, gt1_eyescantrigger_in, 
  gt1_rxcdrhold_in, gt1_rxcdrovrden_in, gt1_rxclkcorcnt_out, gt1_rxdata_out, 
  gt1_rxusrclk_in, gt1_rxusrclk2_in, gt1_rxprbserr_out, gt1_rxprbssel_in, 
  gt1_rxprbscntreset_in, gt1_rxchariscomma_out, gt1_rxcharisk_out, gt1_rxdisperr_out, 
  gt1_rxnotintable_out, gt1_gtprxn_in, gt1_gtprxp_in, gt1_rxbufreset_in, 
  gt1_rxbufstatus_out, gt1_rxbyteisaligned_out, gt1_rxbyterealign_out, 
  gt1_rxcommadet_out, gt1_rxmcommaalignen_in, gt1_rxpcommaalignen_in, 
  gt1_dmonitorout_out, gt1_rxlpmhfhold_in, gt1_rxlpmhfovrden_in, gt1_rxlpmlfhold_in, 
  gt1_rxoutclkfabric_out, gt1_gtrxreset_in, gt1_rxlpmreset_in, gt1_rxpcsreset_in, 
  gt1_rxpmareset_in, gt1_rxpolarity_in, gt1_rxresetdone_out, gt1_txpostcursor_in, 
  gt1_txprecursor_in, gt1_gttxreset_in, gt1_txuserrdy_in, gt1_txdata_in, gt1_txusrclk_in, 
  gt1_txusrclk2_in, gt1_txprbsforceerr_in, gt1_txchardispmode_in, gt1_txchardispval_in, 
  gt1_txcharisk_in, gt1_txbufstatus_out, gt1_gtptxn_out, gt1_gtptxp_out, gt1_txdiffctrl_in, 
  gt1_txmaincursor_in, gt1_txoutclk_out, gt1_txoutclkfabric_out, gt1_txoutclkpcs_out, 
  gt1_txpcsreset_in, gt1_txpmareset_in, gt1_txresetdone_out, gt1_txpolarity_in, 
  gt1_txprbssel_in, gt2_drpaddr_in, gt2_drpclk_in, gt2_drpdi_in, gt2_drpdo_out, gt2_drpen_in, 
  gt2_drprdy_out, gt2_drpwe_in, gt2_loopback_in, gt2_rxpd_in, gt2_txpd_in, 
  gt2_eyescanreset_in, gt2_rxuserrdy_in, gt2_eyescandataerror_out, gt2_eyescantrigger_in, 
  gt2_rxcdrhold_in, gt2_rxcdrovrden_in, gt2_rxclkcorcnt_out, gt2_rxdata_out, 
  gt2_rxusrclk_in, gt2_rxusrclk2_in, gt2_rxprbserr_out, gt2_rxprbssel_in, 
  gt2_rxprbscntreset_in, gt2_rxchariscomma_out, gt2_rxcharisk_out, gt2_rxdisperr_out, 
  gt2_rxnotintable_out, gt2_gtprxn_in, gt2_gtprxp_in, gt2_rxbufreset_in, 
  gt2_rxbufstatus_out, gt2_rxbyteisaligned_out, gt2_rxbyterealign_out, 
  gt2_rxcommadet_out, gt2_rxmcommaalignen_in, gt2_rxpcommaalignen_in, 
  gt2_dmonitorout_out, gt2_rxlpmhfhold_in, gt2_rxlpmhfovrden_in, gt2_rxlpmlfhold_in, 
  gt2_rxoutclkfabric_out, gt2_gtrxreset_in, gt2_rxlpmreset_in, gt2_rxpcsreset_in, 
  gt2_rxpmareset_in, gt2_rxpolarity_in, gt2_rxresetdone_out, gt2_txpostcursor_in, 
  gt2_txprecursor_in, gt2_gttxreset_in, gt2_txuserrdy_in, gt2_txdata_in, gt2_txusrclk_in, 
  gt2_txusrclk2_in, gt2_txprbsforceerr_in, gt2_txchardispmode_in, gt2_txchardispval_in, 
  gt2_txcharisk_in, gt2_txbufstatus_out, gt2_gtptxn_out, gt2_gtptxp_out, gt2_txdiffctrl_in, 
  gt2_txmaincursor_in, gt2_txoutclk_out, gt2_txoutclkfabric_out, gt2_txoutclkpcs_out, 
  gt2_txpcsreset_in, gt2_txpmareset_in, gt2_txresetdone_out, gt2_txpolarity_in, 
  gt2_txprbssel_in, gt3_drpaddr_in, gt3_drpclk_in, gt3_drpdi_in, gt3_drpdo_out, gt3_drpen_in, 
  gt3_drprdy_out, gt3_drpwe_in, gt3_loopback_in, gt3_rxpd_in, gt3_txpd_in, 
  gt3_eyescanreset_in, gt3_rxuserrdy_in, gt3_eyescandataerror_out, gt3_eyescantrigger_in, 
  gt3_rxcdrhold_in, gt3_rxcdrovrden_in, gt3_rxclkcorcnt_out, gt3_rxdata_out, 
  gt3_rxusrclk_in, gt3_rxusrclk2_in, gt3_rxprbserr_out, gt3_rxprbssel_in, 
  gt3_rxprbscntreset_in, gt3_rxchariscomma_out, gt3_rxcharisk_out, gt3_rxdisperr_out, 
  gt3_rxnotintable_out, gt3_gtprxn_in, gt3_gtprxp_in, gt3_rxbufreset_in, 
  gt3_rxbufstatus_out, gt3_rxbyteisaligned_out, gt3_rxbyterealign_out, 
  gt3_rxcommadet_out, gt3_rxmcommaalignen_in, gt3_rxpcommaalignen_in, 
  gt3_dmonitorout_out, gt3_rxlpmhfhold_in, gt3_rxlpmhfovrden_in, gt3_rxlpmlfhold_in, 
  gt3_rxoutclkfabric_out, gt3_gtrxreset_in, gt3_rxlpmreset_in, gt3_rxpcsreset_in, 
  gt3_rxpmareset_in, gt3_rxpolarity_in, gt3_rxresetdone_out, gt3_txpostcursor_in, 
  gt3_txprecursor_in, gt3_gttxreset_in, gt3_txuserrdy_in, gt3_txdata_in, gt3_txusrclk_in, 
  gt3_txusrclk2_in, gt3_txprbsforceerr_in, gt3_txchardispmode_in, gt3_txchardispval_in, 
  gt3_txcharisk_in, gt3_txbufstatus_out, gt3_gtptxn_out, gt3_gtptxp_out, gt3_txdiffctrl_in, 
  gt3_txmaincursor_in, gt3_txoutclk_out, gt3_txoutclkfabric_out, gt3_txoutclkpcs_out, 
  gt3_txpcsreset_in, gt3_txpmareset_in, gt3_txresetdone_out, gt3_txpolarity_in, 
  gt3_txprbssel_in, gt0_pll0outclk_in, gt0_pll0outrefclk_in, gt0_pll0reset_out, 
  gt0_pll0lock_in, gt0_pll0refclklost_in, gt0_pll1outclk_in, gt0_pll1outrefclk_in)
/* synthesis syn_black_box black_box_pad_pin="sysclk_in,soft_reset_tx_in,soft_reset_rx_in,dont_reset_on_data_error_in,gt0_drp_busy_out,gt0_tx_fsm_reset_done_out,gt0_rx_fsm_reset_done_out,gt0_data_valid_in,gt0_tx_mmcm_lock_in,gt0_tx_mmcm_reset_out,gt0_rx_mmcm_lock_in,gt0_rx_mmcm_reset_out,gt1_drp_busy_out,gt1_tx_fsm_reset_done_out,gt1_rx_fsm_reset_done_out,gt1_data_valid_in,gt1_tx_mmcm_lock_in,gt1_tx_mmcm_reset_out,gt1_rx_mmcm_lock_in,gt1_rx_mmcm_reset_out,gt2_drp_busy_out,gt2_tx_fsm_reset_done_out,gt2_rx_fsm_reset_done_out,gt2_data_valid_in,gt2_tx_mmcm_lock_in,gt2_tx_mmcm_reset_out,gt2_rx_mmcm_lock_in,gt2_rx_mmcm_reset_out,gt3_drp_busy_out,gt3_tx_fsm_reset_done_out,gt3_rx_fsm_reset_done_out,gt3_data_valid_in,gt3_tx_mmcm_lock_in,gt3_tx_mmcm_reset_out,gt3_rx_mmcm_lock_in,gt3_rx_mmcm_reset_out,gt0_drpaddr_in[8:0],gt0_drpclk_in,gt0_drpdi_in[15:0],gt0_drpdo_out[15:0],gt0_drpen_in,gt0_drprdy_out,gt0_drpwe_in,gt0_loopback_in[2:0],gt0_rxpd_in[1:0],gt0_txpd_in[1:0],gt0_eyescanreset_in,gt0_rxuserrdy_in,gt0_eyescandataerror_out,gt0_eyescantrigger_in,gt0_rxcdrhold_in,gt0_rxcdrovrden_in,gt0_rxclkcorcnt_out[1:0],gt0_rxdata_out[31:0],gt0_rxusrclk_in,gt0_rxusrclk2_in,gt0_rxprbserr_out,gt0_rxprbssel_in[2:0],gt0_rxprbscntreset_in,gt0_rxchariscomma_out[3:0],gt0_rxcharisk_out[3:0],gt0_rxdisperr_out[3:0],gt0_rxnotintable_out[3:0],gt0_gtprxn_in,gt0_gtprxp_in,gt0_rxbufreset_in,gt0_rxbufstatus_out[2:0],gt0_rxbyteisaligned_out,gt0_rxbyterealign_out,gt0_rxcommadet_out,gt0_rxmcommaalignen_in,gt0_rxpcommaalignen_in,gt0_dmonitorout_out[14:0],gt0_rxlpmhfhold_in,gt0_rxlpmhfovrden_in,gt0_rxlpmlfhold_in,gt0_rxoutclkfabric_out,gt0_gtrxreset_in,gt0_rxlpmreset_in,gt0_rxpcsreset_in,gt0_rxpmareset_in,gt0_rxpolarity_in,gt0_rxresetdone_out,gt0_txpostcursor_in[4:0],gt0_txprecursor_in[4:0],gt0_gttxreset_in,gt0_txuserrdy_in,gt0_txdata_in[31:0],gt0_txusrclk_in,gt0_txusrclk2_in,gt0_txprbsforceerr_in,gt0_txchardispmode_in[3:0],gt0_txchardispval_in[3:0],gt0_txcharisk_in[3:0],gt0_txbufstatus_out[1:0],gt0_gtptxn_out,gt0_gtptxp_out,gt0_txdiffctrl_in[3:0],gt0_txmaincursor_in[6:0],gt0_txoutclk_out,gt0_txoutclkfabric_out,gt0_txoutclkpcs_out,gt0_txpcsreset_in,gt0_txpmareset_in,gt0_txresetdone_out,gt0_txpolarity_in,gt0_txprbssel_in[2:0],gt1_drpaddr_in[8:0],gt1_drpclk_in,gt1_drpdi_in[15:0],gt1_drpdo_out[15:0],gt1_drpen_in,gt1_drprdy_out,gt1_drpwe_in,gt1_loopback_in[2:0],gt1_rxpd_in[1:0],gt1_txpd_in[1:0],gt1_eyescanreset_in,gt1_rxuserrdy_in,gt1_eyescandataerror_out,gt1_eyescantrigger_in,gt1_rxcdrhold_in,gt1_rxcdrovrden_in,gt1_rxclkcorcnt_out[1:0],gt1_rxdata_out[31:0],gt1_rxusrclk_in,gt1_rxusrclk2_in,gt1_rxprbserr_out,gt1_rxprbssel_in[2:0],gt1_rxprbscntreset_in,gt1_rxchariscomma_out[3:0],gt1_rxcharisk_out[3:0],gt1_rxdisperr_out[3:0],gt1_rxnotintable_out[3:0],gt1_gtprxn_in,gt1_gtprxp_in,gt1_rxbufreset_in,gt1_rxbufstatus_out[2:0],gt1_rxbyteisaligned_out,gt1_rxbyterealign_out,gt1_rxcommadet_out,gt1_rxmcommaalignen_in,gt1_rxpcommaalignen_in,gt1_dmonitorout_out[14:0],gt1_rxlpmhfhold_in,gt1_rxlpmhfovrden_in,gt1_rxlpmlfhold_in,gt1_rxoutclkfabric_out,gt1_gtrxreset_in,gt1_rxlpmreset_in,gt1_rxpcsreset_in,gt1_rxpmareset_in,gt1_rxpolarity_in,gt1_rxresetdone_out,gt1_txpostcursor_in[4:0],gt1_txprecursor_in[4:0],gt1_gttxreset_in,gt1_txuserrdy_in,gt1_txdata_in[31:0],gt1_txusrclk_in,gt1_txusrclk2_in,gt1_txprbsforceerr_in,gt1_txchardispmode_in[3:0],gt1_txchardispval_in[3:0],gt1_txcharisk_in[3:0],gt1_txbufstatus_out[1:0],gt1_gtptxn_out,gt1_gtptxp_out,gt1_txdiffctrl_in[3:0],gt1_txmaincursor_in[6:0],gt1_txoutclk_out,gt1_txoutclkfabric_out,gt1_txoutclkpcs_out,gt1_txpcsreset_in,gt1_txpmareset_in,gt1_txresetdone_out,gt1_txpolarity_in,gt1_txprbssel_in[2:0],gt2_drpaddr_in[8:0],gt2_drpclk_in,gt2_drpdi_in[15:0],gt2_drpdo_out[15:0],gt2_drpen_in,gt2_drprdy_out,gt2_drpwe_in,gt2_loopback_in[2:0],gt2_rxpd_in[1:0],gt2_txpd_in[1:0],gt2_eyescanreset_in,gt2_rxuserrdy_in,gt2_eyescandataerror_out,gt2_eyescantrigger_in,gt2_rxcdrhold_in,gt2_rxcdrovrden_in,gt2_rxclkcorcnt_out[1:0],gt2_rxdata_out[31:0],gt2_rxusrclk_in,gt2_rxusrclk2_in,gt2_rxprbserr_out,gt2_rxprbssel_in[2:0],gt2_rxprbscntreset_in,gt2_rxchariscomma_out[3:0],gt2_rxcharisk_out[3:0],gt2_rxdisperr_out[3:0],gt2_rxnotintable_out[3:0],gt2_gtprxn_in,gt2_gtprxp_in,gt2_rxbufreset_in,gt2_rxbufstatus_out[2:0],gt2_rxbyteisaligned_out,gt2_rxbyterealign_out,gt2_rxcommadet_out,gt2_rxmcommaalignen_in,gt2_rxpcommaalignen_in,gt2_dmonitorout_out[14:0],gt2_rxlpmhfhold_in,gt2_rxlpmhfovrden_in,gt2_rxlpmlfhold_in,gt2_rxoutclkfabric_out,gt2_gtrxreset_in,gt2_rxlpmreset_in,gt2_rxpcsreset_in,gt2_rxpmareset_in,gt2_rxpolarity_in,gt2_rxresetdone_out,gt2_txpostcursor_in[4:0],gt2_txprecursor_in[4:0],gt2_gttxreset_in,gt2_txuserrdy_in,gt2_txdata_in[31:0],gt2_txusrclk_in,gt2_txusrclk2_in,gt2_txprbsforceerr_in,gt2_txchardispmode_in[3:0],gt2_txchardispval_in[3:0],gt2_txcharisk_in[3:0],gt2_txbufstatus_out[1:0],gt2_gtptxn_out,gt2_gtptxp_out,gt2_txdiffctrl_in[3:0],gt2_txmaincursor_in[6:0],gt2_txoutclk_out,gt2_txoutclkfabric_out,gt2_txoutclkpcs_out,gt2_txpcsreset_in,gt2_txpmareset_in,gt2_txresetdone_out,gt2_txpolarity_in,gt2_txprbssel_in[2:0],gt3_drpaddr_in[8:0],gt3_drpclk_in,gt3_drpdi_in[15:0],gt3_drpdo_out[15:0],gt3_drpen_in,gt3_drprdy_out,gt3_drpwe_in,gt3_loopback_in[2:0],gt3_rxpd_in[1:0],gt3_txpd_in[1:0],gt3_eyescanreset_in,gt3_rxuserrdy_in,gt3_eyescandataerror_out,gt3_eyescantrigger_in,gt3_rxcdrhold_in,gt3_rxcdrovrden_in,gt3_rxclkcorcnt_out[1:0],gt3_rxdata_out[31:0],gt3_rxusrclk_in,gt3_rxusrclk2_in,gt3_rxprbserr_out,gt3_rxprbssel_in[2:0],gt3_rxprbscntreset_in,gt3_rxchariscomma_out[3:0],gt3_rxcharisk_out[3:0],gt3_rxdisperr_out[3:0],gt3_rxnotintable_out[3:0],gt3_gtprxn_in,gt3_gtprxp_in,gt3_rxbufreset_in,gt3_rxbufstatus_out[2:0],gt3_rxbyteisaligned_out,gt3_rxbyterealign_out,gt3_rxcommadet_out,gt3_rxmcommaalignen_in,gt3_rxpcommaalignen_in,gt3_dmonitorout_out[14:0],gt3_rxlpmhfhold_in,gt3_rxlpmhfovrden_in,gt3_rxlpmlfhold_in,gt3_rxoutclkfabric_out,gt3_gtrxreset_in,gt3_rxlpmreset_in,gt3_rxpcsreset_in,gt3_rxpmareset_in,gt3_rxpolarity_in,gt3_rxresetdone_out,gt3_txpostcursor_in[4:0],gt3_txprecursor_in[4:0],gt3_gttxreset_in,gt3_txuserrdy_in,gt3_txdata_in[31:0],gt3_txusrclk_in,gt3_txusrclk2_in,gt3_txprbsforceerr_in,gt3_txchardispmode_in[3:0],gt3_txchardispval_in[3:0],gt3_txcharisk_in[3:0],gt3_txbufstatus_out[1:0],gt3_gtptxn_out,gt3_gtptxp_out,gt3_txdiffctrl_in[3:0],gt3_txmaincursor_in[6:0],gt3_txoutclk_out,gt3_txoutclkfabric_out,gt3_txoutclkpcs_out,gt3_txpcsreset_in,gt3_txpmareset_in,gt3_txresetdone_out,gt3_txpolarity_in,gt3_txprbssel_in[2:0],gt0_pll0outclk_in,gt0_pll0outrefclk_in,gt0_pll0reset_out,gt0_pll0lock_in,gt0_pll0refclklost_in,gt0_pll1outclk_in,gt0_pll1outrefclk_in" */;
  input sysclk_in;
  input soft_reset_tx_in;
  input soft_reset_rx_in;
  input dont_reset_on_data_error_in;
  output gt0_drp_busy_out;
  output gt0_tx_fsm_reset_done_out;
  output gt0_rx_fsm_reset_done_out;
  input gt0_data_valid_in;
  input gt0_tx_mmcm_lock_in;
  output gt0_tx_mmcm_reset_out;
  input gt0_rx_mmcm_lock_in;
  output gt0_rx_mmcm_reset_out;
  output gt1_drp_busy_out;
  output gt1_tx_fsm_reset_done_out;
  output gt1_rx_fsm_reset_done_out;
  input gt1_data_valid_in;
  input gt1_tx_mmcm_lock_in;
  output gt1_tx_mmcm_reset_out;
  input gt1_rx_mmcm_lock_in;
  output gt1_rx_mmcm_reset_out;
  output gt2_drp_busy_out;
  output gt2_tx_fsm_reset_done_out;
  output gt2_rx_fsm_reset_done_out;
  input gt2_data_valid_in;
  input gt2_tx_mmcm_lock_in;
  output gt2_tx_mmcm_reset_out;
  input gt2_rx_mmcm_lock_in;
  output gt2_rx_mmcm_reset_out;
  output gt3_drp_busy_out;
  output gt3_tx_fsm_reset_done_out;
  output gt3_rx_fsm_reset_done_out;
  input gt3_data_valid_in;
  input gt3_tx_mmcm_lock_in;
  output gt3_tx_mmcm_reset_out;
  input gt3_rx_mmcm_lock_in;
  output gt3_rx_mmcm_reset_out;
  input [8:0]gt0_drpaddr_in;
  input gt0_drpclk_in;
  input [15:0]gt0_drpdi_in;
  output [15:0]gt0_drpdo_out;
  input gt0_drpen_in;
  output gt0_drprdy_out;
  input gt0_drpwe_in;
  input [2:0]gt0_loopback_in;
  input [1:0]gt0_rxpd_in;
  input [1:0]gt0_txpd_in;
  input gt0_eyescanreset_in;
  input gt0_rxuserrdy_in;
  output gt0_eyescandataerror_out;
  input gt0_eyescantrigger_in;
  input gt0_rxcdrhold_in;
  input gt0_rxcdrovrden_in;
  output [1:0]gt0_rxclkcorcnt_out;
  output [31:0]gt0_rxdata_out;
  input gt0_rxusrclk_in;
  input gt0_rxusrclk2_in;
  output gt0_rxprbserr_out;
  input [2:0]gt0_rxprbssel_in;
  input gt0_rxprbscntreset_in;
  output [3:0]gt0_rxchariscomma_out;
  output [3:0]gt0_rxcharisk_out;
  output [3:0]gt0_rxdisperr_out;
  output [3:0]gt0_rxnotintable_out;
  input gt0_gtprxn_in;
  input gt0_gtprxp_in;
  input gt0_rxbufreset_in;
  output [2:0]gt0_rxbufstatus_out;
  output gt0_rxbyteisaligned_out;
  output gt0_rxbyterealign_out;
  output gt0_rxcommadet_out;
  input gt0_rxmcommaalignen_in;
  input gt0_rxpcommaalignen_in;
  output [14:0]gt0_dmonitorout_out;
  input gt0_rxlpmhfhold_in;
  input gt0_rxlpmhfovrden_in;
  input gt0_rxlpmlfhold_in;
  output gt0_rxoutclkfabric_out;
  input gt0_gtrxreset_in;
  input gt0_rxlpmreset_in;
  input gt0_rxpcsreset_in;
  input gt0_rxpmareset_in;
  input gt0_rxpolarity_in;
  output gt0_rxresetdone_out;
  input [4:0]gt0_txpostcursor_in;
  input [4:0]gt0_txprecursor_in;
  input gt0_gttxreset_in;
  input gt0_txuserrdy_in;
  input [31:0]gt0_txdata_in;
  input gt0_txusrclk_in;
  input gt0_txusrclk2_in;
  input gt0_txprbsforceerr_in;
  input [3:0]gt0_txchardispmode_in;
  input [3:0]gt0_txchardispval_in;
  input [3:0]gt0_txcharisk_in;
  output [1:0]gt0_txbufstatus_out;
  output gt0_gtptxn_out;
  output gt0_gtptxp_out;
  input [3:0]gt0_txdiffctrl_in;
  input [6:0]gt0_txmaincursor_in;
  output gt0_txoutclk_out;
  output gt0_txoutclkfabric_out;
  output gt0_txoutclkpcs_out;
  input gt0_txpcsreset_in;
  input gt0_txpmareset_in;
  output gt0_txresetdone_out;
  input gt0_txpolarity_in;
  input [2:0]gt0_txprbssel_in;
  input [8:0]gt1_drpaddr_in;
  input gt1_drpclk_in;
  input [15:0]gt1_drpdi_in;
  output [15:0]gt1_drpdo_out;
  input gt1_drpen_in;
  output gt1_drprdy_out;
  input gt1_drpwe_in;
  input [2:0]gt1_loopback_in;
  input [1:0]gt1_rxpd_in;
  input [1:0]gt1_txpd_in;
  input gt1_eyescanreset_in;
  input gt1_rxuserrdy_in;
  output gt1_eyescandataerror_out;
  input gt1_eyescantrigger_in;
  input gt1_rxcdrhold_in;
  input gt1_rxcdrovrden_in;
  output [1:0]gt1_rxclkcorcnt_out;
  output [31:0]gt1_rxdata_out;
  input gt1_rxusrclk_in;
  input gt1_rxusrclk2_in;
  output gt1_rxprbserr_out;
  input [2:0]gt1_rxprbssel_in;
  input gt1_rxprbscntreset_in;
  output [3:0]gt1_rxchariscomma_out;
  output [3:0]gt1_rxcharisk_out;
  output [3:0]gt1_rxdisperr_out;
  output [3:0]gt1_rxnotintable_out;
  input gt1_gtprxn_in;
  input gt1_gtprxp_in;
  input gt1_rxbufreset_in;
  output [2:0]gt1_rxbufstatus_out;
  output gt1_rxbyteisaligned_out;
  output gt1_rxbyterealign_out;
  output gt1_rxcommadet_out;
  input gt1_rxmcommaalignen_in;
  input gt1_rxpcommaalignen_in;
  output [14:0]gt1_dmonitorout_out;
  input gt1_rxlpmhfhold_in;
  input gt1_rxlpmhfovrden_in;
  input gt1_rxlpmlfhold_in;
  output gt1_rxoutclkfabric_out;
  input gt1_gtrxreset_in;
  input gt1_rxlpmreset_in;
  input gt1_rxpcsreset_in;
  input gt1_rxpmareset_in;
  input gt1_rxpolarity_in;
  output gt1_rxresetdone_out;
  input [4:0]gt1_txpostcursor_in;
  input [4:0]gt1_txprecursor_in;
  input gt1_gttxreset_in;
  input gt1_txuserrdy_in;
  input [31:0]gt1_txdata_in;
  input gt1_txusrclk_in;
  input gt1_txusrclk2_in;
  input gt1_txprbsforceerr_in;
  input [3:0]gt1_txchardispmode_in;
  input [3:0]gt1_txchardispval_in;
  input [3:0]gt1_txcharisk_in;
  output [1:0]gt1_txbufstatus_out;
  output gt1_gtptxn_out;
  output gt1_gtptxp_out;
  input [3:0]gt1_txdiffctrl_in;
  input [6:0]gt1_txmaincursor_in;
  output gt1_txoutclk_out;
  output gt1_txoutclkfabric_out;
  output gt1_txoutclkpcs_out;
  input gt1_txpcsreset_in;
  input gt1_txpmareset_in;
  output gt1_txresetdone_out;
  input gt1_txpolarity_in;
  input [2:0]gt1_txprbssel_in;
  input [8:0]gt2_drpaddr_in;
  input gt2_drpclk_in;
  input [15:0]gt2_drpdi_in;
  output [15:0]gt2_drpdo_out;
  input gt2_drpen_in;
  output gt2_drprdy_out;
  input gt2_drpwe_in;
  input [2:0]gt2_loopback_in;
  input [1:0]gt2_rxpd_in;
  input [1:0]gt2_txpd_in;
  input gt2_eyescanreset_in;
  input gt2_rxuserrdy_in;
  output gt2_eyescandataerror_out;
  input gt2_eyescantrigger_in;
  input gt2_rxcdrhold_in;
  input gt2_rxcdrovrden_in;
  output [1:0]gt2_rxclkcorcnt_out;
  output [31:0]gt2_rxdata_out;
  input gt2_rxusrclk_in;
  input gt2_rxusrclk2_in;
  output gt2_rxprbserr_out;
  input [2:0]gt2_rxprbssel_in;
  input gt2_rxprbscntreset_in;
  output [3:0]gt2_rxchariscomma_out;
  output [3:0]gt2_rxcharisk_out;
  output [3:0]gt2_rxdisperr_out;
  output [3:0]gt2_rxnotintable_out;
  input gt2_gtprxn_in;
  input gt2_gtprxp_in;
  input gt2_rxbufreset_in;
  output [2:0]gt2_rxbufstatus_out;
  output gt2_rxbyteisaligned_out;
  output gt2_rxbyterealign_out;
  output gt2_rxcommadet_out;
  input gt2_rxmcommaalignen_in;
  input gt2_rxpcommaalignen_in;
  output [14:0]gt2_dmonitorout_out;
  input gt2_rxlpmhfhold_in;
  input gt2_rxlpmhfovrden_in;
  input gt2_rxlpmlfhold_in;
  output gt2_rxoutclkfabric_out;
  input gt2_gtrxreset_in;
  input gt2_rxlpmreset_in;
  input gt2_rxpcsreset_in;
  input gt2_rxpmareset_in;
  input gt2_rxpolarity_in;
  output gt2_rxresetdone_out;
  input [4:0]gt2_txpostcursor_in;
  input [4:0]gt2_txprecursor_in;
  input gt2_gttxreset_in;
  input gt2_txuserrdy_in;
  input [31:0]gt2_txdata_in;
  input gt2_txusrclk_in;
  input gt2_txusrclk2_in;
  input gt2_txprbsforceerr_in;
  input [3:0]gt2_txchardispmode_in;
  input [3:0]gt2_txchardispval_in;
  input [3:0]gt2_txcharisk_in;
  output [1:0]gt2_txbufstatus_out;
  output gt2_gtptxn_out;
  output gt2_gtptxp_out;
  input [3:0]gt2_txdiffctrl_in;
  input [6:0]gt2_txmaincursor_in;
  output gt2_txoutclk_out;
  output gt2_txoutclkfabric_out;
  output gt2_txoutclkpcs_out;
  input gt2_txpcsreset_in;
  input gt2_txpmareset_in;
  output gt2_txresetdone_out;
  input gt2_txpolarity_in;
  input [2:0]gt2_txprbssel_in;
  input [8:0]gt3_drpaddr_in;
  input gt3_drpclk_in;
  input [15:0]gt3_drpdi_in;
  output [15:0]gt3_drpdo_out;
  input gt3_drpen_in;
  output gt3_drprdy_out;
  input gt3_drpwe_in;
  input [2:0]gt3_loopback_in;
  input [1:0]gt3_rxpd_in;
  input [1:0]gt3_txpd_in;
  input gt3_eyescanreset_in;
  input gt3_rxuserrdy_in;
  output gt3_eyescandataerror_out;
  input gt3_eyescantrigger_in;
  input gt3_rxcdrhold_in;
  input gt3_rxcdrovrden_in;
  output [1:0]gt3_rxclkcorcnt_out;
  output [31:0]gt3_rxdata_out;
  input gt3_rxusrclk_in;
  input gt3_rxusrclk2_in;
  output gt3_rxprbserr_out;
  input [2:0]gt3_rxprbssel_in;
  input gt3_rxprbscntreset_in;
  output [3:0]gt3_rxchariscomma_out;
  output [3:0]gt3_rxcharisk_out;
  output [3:0]gt3_rxdisperr_out;
  output [3:0]gt3_rxnotintable_out;
  input gt3_gtprxn_in;
  input gt3_gtprxp_in;
  input gt3_rxbufreset_in;
  output [2:0]gt3_rxbufstatus_out;
  output gt3_rxbyteisaligned_out;
  output gt3_rxbyterealign_out;
  output gt3_rxcommadet_out;
  input gt3_rxmcommaalignen_in;
  input gt3_rxpcommaalignen_in;
  output [14:0]gt3_dmonitorout_out;
  input gt3_rxlpmhfhold_in;
  input gt3_rxlpmhfovrden_in;
  input gt3_rxlpmlfhold_in;
  output gt3_rxoutclkfabric_out;
  input gt3_gtrxreset_in;
  input gt3_rxlpmreset_in;
  input gt3_rxpcsreset_in;
  input gt3_rxpmareset_in;
  input gt3_rxpolarity_in;
  output gt3_rxresetdone_out;
  input [4:0]gt3_txpostcursor_in;
  input [4:0]gt3_txprecursor_in;
  input gt3_gttxreset_in;
  input gt3_txuserrdy_in;
  input [31:0]gt3_txdata_in;
  input gt3_txusrclk_in;
  input gt3_txusrclk2_in;
  input gt3_txprbsforceerr_in;
  input [3:0]gt3_txchardispmode_in;
  input [3:0]gt3_txchardispval_in;
  input [3:0]gt3_txcharisk_in;
  output [1:0]gt3_txbufstatus_out;
  output gt3_gtptxn_out;
  output gt3_gtptxp_out;
  input [3:0]gt3_txdiffctrl_in;
  input [6:0]gt3_txmaincursor_in;
  output gt3_txoutclk_out;
  output gt3_txoutclkfabric_out;
  output gt3_txoutclkpcs_out;
  input gt3_txpcsreset_in;
  input gt3_txpmareset_in;
  output gt3_txresetdone_out;
  input gt3_txpolarity_in;
  input [2:0]gt3_txprbssel_in;
  input gt0_pll0outclk_in;
  input gt0_pll0outrefclk_in;
  output gt0_pll0reset_out;
  input gt0_pll0lock_in;
  input gt0_pll0refclklost_in;
  input gt0_pll1outclk_in;
  input gt0_pll1outrefclk_in;
endmodule
