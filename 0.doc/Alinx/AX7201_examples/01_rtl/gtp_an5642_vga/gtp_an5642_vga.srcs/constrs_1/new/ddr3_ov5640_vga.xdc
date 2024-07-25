############## NET - IOSTANDARD ######################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
############## clock define###########################
create_clock -period 5.000 [get_ports sys_clk_p]
set_property PACKAGE_PIN R4 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
############## key define#############################
set_property PACKAGE_PIN T6 [get_ports rst_n]
set_property IOSTANDARD LVCMOS15 [get_ports rst_n]
set_property PACKAGE_PIN E16 [get_ports key]
set_property IOSTANDARD LVCMOS33 [get_ports key]
############## VGA define#############################
set_property IOSTANDARD LVCMOS33 [get_ports vga_out_hs]
set_property PACKAGE_PIN C13 [get_ports vga_out_hs]

set_property IOSTANDARD LVCMOS33 [get_ports vga_out_vs]
set_property PACKAGE_PIN B13 [get_ports vga_out_vs]


set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_r[0]}]
set_property PACKAGE_PIN AB16 [get_ports {vga_out_r[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_r[1]}]
set_property PACKAGE_PIN Y16 [get_ports {vga_out_r[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_r[2]}]
set_property PACKAGE_PIN AA16 [get_ports {vga_out_r[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_r[3]}]
set_property PACKAGE_PIN Y13 [get_ports {vga_out_r[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_r[4]}]
set_property PACKAGE_PIN AB17 [get_ports {vga_out_r[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_g[0]}]
set_property PACKAGE_PIN D15 [get_ports {vga_out_g[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_g[1]}]
set_property PACKAGE_PIN AB13 [get_ports {vga_out_g[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_g[2]}]
set_property PACKAGE_PIN W14 [get_ports {vga_out_g[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_g[3]}]
set_property PACKAGE_PIN AA14 [get_ports {vga_out_g[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_g[4]}]
set_property PACKAGE_PIN AA13 [get_ports {vga_out_g[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_g[5]}]
set_property PACKAGE_PIN AB12 [get_ports {vga_out_g[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_b[0]}]
set_property PACKAGE_PIN D14 [get_ports {vga_out_b[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_b[1]}]
set_property PACKAGE_PIN E14 [get_ports {vga_out_b[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_b[2]}]
set_property PACKAGE_PIN E13 [get_ports {vga_out_b[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_b[3]}]
set_property PACKAGE_PIN F13 [get_ports {vga_out_b[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_out_b[4]}]
set_property PACKAGE_PIN F14 [get_ports {vga_out_b[4]}]
##################AN5642 on ax7101 J11######################
set_property PACKAGE_PIN J19 [get_ports cmos1_sda]
set_property PACKAGE_PIN G16 [get_ports {cmos1_db[9]}]
set_property PACKAGE_PIN G15 [get_ports {cmos1_db[8]}]
set_property PACKAGE_PIN D19 [get_ports cmos1_scl]
set_property PACKAGE_PIN E19 [get_ports {cmos1_db[5]}]
set_property PACKAGE_PIN C20 [get_ports {cmos1_db[3]}]
set_property PACKAGE_PIN D20 [get_ports {cmos1_db[4]}]
set_property PACKAGE_PIN A19 [get_ports {cmos1_db[6]}]
set_property PACKAGE_PIN E18 [get_ports {cmos1_db[7]}]
set_property PACKAGE_PIN C19 [get_ports {cmos1_db[2]}]
set_property PACKAGE_PIN C18 [get_ports cmos1_pclk]
set_property PACKAGE_PIN B18 [get_ports cmos1_href]
set_property PACKAGE_PIN B17 [get_ports cmos1_vsync]
set_property PACKAGE_PIN C17 [get_ports cmos1_rst_n]
set_property PACKAGE_PIN F18 [get_ports {cmos1_db[1]}]
set_property PACKAGE_PIN A18 [get_ports {cmos1_db[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports cmos1_sda]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_scl]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_pclk]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_href]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_vsync]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[0]}]

set_property PACKAGE_PIN B22 [get_ports {cmos2_db[9]}]
set_property PACKAGE_PIN C22 [get_ports cmos2_sda]
set_property PACKAGE_PIN A20 [get_ports {cmos2_db[6]}]
set_property PACKAGE_PIN B20 [get_ports cmos2_scl]
set_property PACKAGE_PIN F20 [get_ports {cmos2_db[7]}]
set_property PACKAGE_PIN F19 [get_ports {cmos2_db[2]}]
set_property PACKAGE_PIN J16 [get_ports cmos2_href]
set_property PACKAGE_PIN F15 [get_ports {cmos2_db[8]}]
set_property PACKAGE_PIN F21 [get_ports {cmos2_db[3]}]
set_property PACKAGE_PIN M17 [get_ports cmos2_rst_n]
set_property PACKAGE_PIN A21 [get_ports {cmos2_db[4]}]
set_property PACKAGE_PIN B21 [get_ports {cmos2_db[5]}]
set_property PACKAGE_PIN G18 [get_ports cmos2_vsync]
set_property PACKAGE_PIN G17 [get_ports cmos2_pclk]
set_property PACKAGE_PIN D21 [get_ports {cmos2_db[1]}]
set_property PACKAGE_PIN E21 [get_ports {cmos2_db[0]}]


set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports cmos2_sda]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports cmos2_scl]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports cmos2_href]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports cmos2_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports cmos2_vsync]
set_property IOSTANDARD LVCMOS33 [get_ports cmos2_pclk]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[0]}]

create_clock -period 11.904 [get_ports cmos1_pclk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cmos1_pclk_IBUF]

create_clock -period 11.904 [get_ports cmos2_pclk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cmos2_pclk_IBUF]
set_false_path -from [get_clocks clk_pll_i] -to [get_clocks clk_out1_video_pll]
set_false_path -from [get_clocks clk_out1_video_pll] -to [get_clocks clk_pll_i]
####################### GT reference clock constraints #########################


create_clock -period 6.734 [get_ports Q0_CLK0_GTREFCLK_PAD_P_IN]





#create_clock -period 5.000 -name drpclk_in_i [get_ports DRP_CLK_IN_P]





# User Clock Constraints





#set_false_path -to [get_pins -hierarchical -filter {NAME =~ *_txfsmresetdone_r*/CLR}]
#set_false_path -to [get_pins -hierarchical -filter {NAME =~ *_txfsmresetdone_r*/D}]
#set_false_path -to [get_pins -hierarchical -filter {NAME =~ *reset_on_error_in_r*/D}]
################################# RefClk Location constraints #####################
set_property PACKAGE_PIN F6 [get_ports Q0_CLK0_GTREFCLK_PAD_P_IN]
set_property PACKAGE_PIN E6 [get_ports Q0_CLK0_GTREFCLK_PAD_N_IN]

## LOC constrain for DRP_CLK_P/N
#set_property IOSTANDARD DIFF_SSTL15 [get_ports DRP_CLK_IN_P]
#set_property IOSTANDARD DIFF_SSTL15 [get_ports DRP_CLK_IN_N]
#set_property PACKAGE_PIN R4 [get_ports DRP_CLK_IN_P]
#set_property PACKAGE_PIN T4 [get_ports DRP_CLK_IN_N]

set_property IOSTANDARD LVCMOS33 [get_ports {tx_disable[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tx_disable[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tx_disable[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tx_disable[0]}]
set_property PACKAGE_PIN A15 [get_ports {tx_disable[0]}]
set_property PACKAGE_PIN A16 [get_ports {tx_disable[1]}]
set_property PACKAGE_PIN A13 [get_ports {tx_disable[2]}]
set_property PACKAGE_PIN A14 [get_ports {tx_disable[3]}]


################################# mgt wrapper constraints #####################

##---------- Set placement for gt0_gtp_wrapper_i/GTPE2_CHANNEL ------
set_property LOC GTPE2_CHANNEL_X0Y4 [get_cells gtp_exdes_m0/gtp_support_i/gtp_init_i/inst/gtp_i/gt0_gtp_i/gtpe2_i]
##---------- Set placement for gt1_gtp_wrapper_i/GTPE2_CHANNEL ------
set_property LOC GTPE2_CHANNEL_X0Y5 [get_cells gtp_exdes_m0/gtp_support_i/gtp_init_i/inst/gtp_i/gt1_gtp_i/gtpe2_i]
##---------- Set placement for gt2_gtp_wrapper_i/GTPE2_CHANNEL ------
set_property LOC GTPE2_CHANNEL_X0Y6 [get_cells gtp_exdes_m0/gtp_support_i/gtp_init_i/inst/gtp_i/gt2_gtp_i/gtpe2_i]
##---------- Set placement for gt3_gtp_wrapper_i/GTPE2_CHANNEL ------
set_property LOC GTPE2_CHANNEL_X0Y7 [get_cells gtp_exdes_m0/gtp_support_i/gtp_init_i/inst/gtp_i/gt3_gtp_i/gtpe2_i]

set_false_path -reset_path -from [get_clocks -of_objects [get_pins u_ddr3/u_ddr3_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]] -to [get_clocks -of_objects [get_pins gtp_exdes_m0/gtp_support_i/gt_usrclk_source/txoutclk_mmcm0_i/mmcm_adv_inst/CLKOUT0]]
set_false_path -reset_path -from [get_clocks -of_objects [get_pins gtp_exdes_m0/gtp_support_i/gt_usrclk_source/txoutclk_mmcm0_i/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins u_ddr3/u_ddr3_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]]
set_false_path -reset_path -from [get_clocks -of_objects [get_pins gtp_exdes_m0/gtp_support_i/gt_usrclk_source/txoutclk_mmcm0_i/mmcm_adv_inst/CLKOUT0]] -to [get_clocks sys_clk_p]
set_false_path -reset_path -from [get_clocks sys_clk_p] -to [get_clocks -of_objects [get_pins gtp_exdes_m0/gtp_support_i/gt_usrclk_source/txoutclk_mmcm0_i/mmcm_adv_inst/CLKOUT0]]
