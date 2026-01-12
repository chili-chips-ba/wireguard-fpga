##==========================================================================
## Copyright (C) 2024-2025 Chili.CHIPS*ba
##--------------------------------------------------------------------------
##                      PROPRIETARY INFORMATION
##
## The information contained in this file is the property of CHILI CHIPS LLC.
## Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
## of this file: (1) shall keep all information contained herein confidential;
## and (2) shall protect the same in whole or in part from disclosure and
## dissemination to all third parties; and (3) shall use the same for operation
## and maintenance purposes only.
##--------------------------------------------------------------------------
## Description:
##   Constraints
##==========================================================================

############## NET - IOSTANDARD ######################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.CCLK_TRISTATE TRUE [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

############## clock define###########################
create_clock -period 5.000 [get_ports clk_p]
set_property PACKAGE_PIN R4 [get_ports clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]

#################reset setting########################
set_property IOSTANDARD LVCMOS15 [get_ports rst_n]
set_property PACKAGE_PIN T6 [get_ports rst_n]

###################MDIO##############################
set_property PACKAGE_PIN L16 [get_ports e1_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports e1_mdio]
set_property PACKAGE_PIN AB22 [get_ports e2_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports e2_mdio]
set_property PACKAGE_PIN V19 [get_ports e3_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports e3_mdio]
set_property PACKAGE_PIN U20 [get_ports e4_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports e4_mdio]
set_property PULLTYPE PULLUP [get_ports e1_mdc]
set_property SLEW SLOW [get_ports e1_mdio]
set_property PULLTYPE PULLUP [get_ports e1_mdio]
set_property PULLTYPE PULLUP [get_ports e2_mdc]
set_property SLEW SLOW [get_ports e2_mdio]
set_property PULLTYPE PULLUP [get_ports e2_mdio]
set_property PULLTYPE PULLUP [get_ports e3_mdc]
set_property SLEW SLOW [get_ports e3_mdio]
set_property PULLTYPE PULLUP [get_ports e3_mdio]
set_property PULLTYPE PULLUP [get_ports e4_mdc]
set_property SLEW SLOW [get_ports e4_mdio]
set_property PULLTYPE PULLUP [get_ports e4_mdio]

#############LED Setting###########################
set_property PACKAGE_PIN E17 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN F16 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

############## key define############################
set_property PACKAGE_PIN D16 [get_ports {key_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_in[0]}]

set_property PACKAGE_PIN E16 [get_ports {key_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_in[1]}]

############## usb uart define########################
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]
set_property PACKAGE_PIN AA15 [get_ports uart_rx]

set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property PACKAGE_PIN AB15 [get_ports uart_tx]

############## ethernet PORT1 RX define############
create_clock -period 8.000 -name e1_rx_clk [get_ports e1_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports e1_rxc]
set_property PACKAGE_PIN K18 [get_ports e1_rxc]

set_property PACKAGE_PIN J17 [get_ports e1_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports e1_mdc]

set_property IOSTANDARD LVCMOS33 [get_ports e1_rxdv]
set_property PACKAGE_PIN M22 [get_ports e1_rxdv]

set_property IOSTANDARD LVCMOS33 [get_ports e1_rxer]
set_property PACKAGE_PIN N18 [get_ports e1_rxer]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_rxd[0]}]
set_property PACKAGE_PIN N22 [get_ports {e1_rxd[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_rxd[1]}]
set_property PACKAGE_PIN H18 [get_ports {e1_rxd[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_rxd[2]}]
set_property PACKAGE_PIN H17 [get_ports {e1_rxd[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_rxd[3]}]
set_property PACKAGE_PIN M21 [get_ports {e1_rxd[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_rxd[4]}]
set_property PACKAGE_PIN L21 [get_ports {e1_rxd[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_rxd[5]}]
set_property PACKAGE_PIN N20 [get_ports {e1_rxd[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_rxd[6]}]
set_property PACKAGE_PIN M20 [get_ports {e1_rxd[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_rxd[7]}]
set_property PACKAGE_PIN N19 [get_ports {e1_rxd[7]}]
############## ethernet PORT1 TX define##############
set_property IOSTANDARD LVCMOS33 [get_ports e1_txc]
set_property PACKAGE_PIN K21 [get_ports e1_txc]

create_clock -period 8.000 -name e1_gtx_clk [get_ports e1_gtxc]
set_property IOSTANDARD LVCMOS33 [get_ports e1_gtxc]
set_property PACKAGE_PIN G21 [get_ports e1_gtxc]

set_property IOSTANDARD LVCMOS33 [get_ports e1_txen]
set_property PACKAGE_PIN G22 [get_ports e1_txen]

set_property IOSTANDARD LVCMOS33 [get_ports e1_txer]
set_property PACKAGE_PIN K17 [get_ports e1_txer]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_txd[0]}]
set_property PACKAGE_PIN D22 [get_ports {e1_txd[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_txd[1]}]
set_property PACKAGE_PIN H20 [get_ports {e1_txd[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_txd[2]}]
set_property PACKAGE_PIN H22 [get_ports {e1_txd[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_txd[3]}]
set_property PACKAGE_PIN J22 [get_ports {e1_txd[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_txd[4]}]
set_property PACKAGE_PIN K22 [get_ports {e1_txd[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_txd[5]}]
set_property PACKAGE_PIN L19 [get_ports {e1_txd[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_txd[6]}]
set_property PACKAGE_PIN K19 [get_ports {e1_txd[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e1_txd[7]}]
set_property PACKAGE_PIN L20 [get_ports {e1_txd[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports e1_reset]
set_property PACKAGE_PIN G20 [get_ports e1_reset]

############## ethernet PORT2 RX define#################
create_clock -period 8.000 -name e2_rx_clk [get_ports e2_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports e2_rxc]
set_property PACKAGE_PIN J20 [get_ports e2_rxc]

set_property PACKAGE_PIN AB21 [get_ports e2_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports e2_mdc]

set_property IOSTANDARD LVCMOS33 [get_ports e2_rxdv]
set_property PACKAGE_PIN L13 [get_ports e2_rxdv]

set_property IOSTANDARD LVCMOS33 [get_ports e2_rxer]
set_property PACKAGE_PIN G13 [get_ports e2_rxer]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_rxd[0]}]
set_property PACKAGE_PIN M13 [get_ports {e2_rxd[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_rxd[1]}]
set_property PACKAGE_PIN K14 [get_ports {e2_rxd[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_rxd[2]}]
set_property PACKAGE_PIN K13 [get_ports {e2_rxd[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_rxd[3]}]
set_property PACKAGE_PIN J14 [get_ports {e2_rxd[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_rxd[4]}]
set_property PACKAGE_PIN H14 [get_ports {e2_rxd[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_rxd[5]}]
set_property PACKAGE_PIN H15 [get_ports {e2_rxd[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_rxd[6]}]
set_property PACKAGE_PIN J15 [get_ports {e2_rxd[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_rxd[7]}]
set_property PACKAGE_PIN H13 [get_ports {e2_rxd[7]}]
############## ethernet PORT2 TX define##################
set_property IOSTANDARD LVCMOS33 [get_ports e2_txc]
set_property PACKAGE_PIN T14 [get_ports e2_txc]

create_clock -period 8.000 -name e2_gtx_clk [get_ports e2_gtxc]
set_property IOSTANDARD LVCMOS33 [get_ports e2_gtxc]
set_property PACKAGE_PIN M16 [get_ports e2_gtxc]

set_property IOSTANDARD LVCMOS33 [get_ports e2_txen]
set_property PACKAGE_PIN M15 [get_ports e2_txen]

set_property IOSTANDARD LVCMOS33 [get_ports e2_txer]
set_property PACKAGE_PIN T15 [get_ports e2_txer]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_txd[0]}]
set_property PACKAGE_PIN L15 [get_ports {e2_txd[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_txd[1]}]
set_property PACKAGE_PIN K16 [get_ports {e2_txd[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_txd[2]}]
set_property PACKAGE_PIN W15 [get_ports {e2_txd[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_txd[3]}]
set_property PACKAGE_PIN W16 [get_ports {e2_txd[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_txd[4]}]
set_property PACKAGE_PIN V17 [get_ports {e2_txd[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_txd[5]}]
set_property PACKAGE_PIN W17 [get_ports {e2_txd[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_txd[6]}]
set_property PACKAGE_PIN U15 [get_ports {e2_txd[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e2_txd[7]}]
set_property PACKAGE_PIN V15 [get_ports {e2_txd[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports e2_reset]
set_property PACKAGE_PIN L14 [get_ports e2_reset]

############## ethernet PORT3 RX define##################
create_clock -period 8.000 -name e3_rx_clk [get_ports e3_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports e3_rxc]
set_property PACKAGE_PIN V13 [get_ports e3_rxc]

set_property PACKAGE_PIN V20 [get_ports e3_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports e3_mdc]

set_property IOSTANDARD LVCMOS33 [get_ports e3_rxdv]
set_property PACKAGE_PIN AA20 [get_ports e3_rxdv]

set_property IOSTANDARD LVCMOS33 [get_ports e3_rxer]
set_property PACKAGE_PIN U21 [get_ports e3_rxer]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_rxd[0]}]
set_property PACKAGE_PIN AB20 [get_ports {e3_rxd[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_rxd[1]}]
set_property PACKAGE_PIN AA19 [get_ports {e3_rxd[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_rxd[2]}]
set_property PACKAGE_PIN AA18 [get_ports {e3_rxd[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_rxd[3]}]
set_property PACKAGE_PIN AB18 [get_ports {e3_rxd[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_rxd[4]}]
set_property PACKAGE_PIN Y17 [get_ports {e3_rxd[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_rxd[5]}]
set_property PACKAGE_PIN W22 [get_ports {e3_rxd[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_rxd[6]}]
set_property PACKAGE_PIN W21 [get_ports {e3_rxd[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_rxd[7]}]
set_property PACKAGE_PIN T21 [get_ports {e3_rxd[7]}]
############## ethernet PORT3 TX define##################
set_property IOSTANDARD LVCMOS33 [get_ports e3_txc]
set_property PACKAGE_PIN V10 [get_ports e3_txc]

create_clock -period 8.000 -name e3_gtx_clk [get_ports e3_gtxc]
set_property IOSTANDARD LVCMOS33 [get_ports e3_gtxc]
set_property PACKAGE_PIN AA21 [get_ports e3_gtxc]

set_property IOSTANDARD LVCMOS33 [get_ports e3_txen]
set_property PACKAGE_PIN V14 [get_ports e3_txen]

set_property IOSTANDARD LVCMOS33 [get_ports e3_txer]
set_property PACKAGE_PIN AA9 [get_ports e3_txer]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_txd[0]}]
set_property PACKAGE_PIN W11 [get_ports {e3_txd[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_txd[1]}]
set_property PACKAGE_PIN W12 [get_ports {e3_txd[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_txd[2]}]
set_property PACKAGE_PIN Y11 [get_ports {e3_txd[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_txd[3]}]
set_property PACKAGE_PIN Y12 [get_ports {e3_txd[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_txd[4]}]
set_property PACKAGE_PIN W10 [get_ports {e3_txd[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_txd[5]}]
set_property PACKAGE_PIN AA11 [get_ports {e3_txd[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_txd[6]}]
set_property PACKAGE_PIN AA10 [get_ports {e3_txd[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e3_txd[7]}]
set_property PACKAGE_PIN AB10 [get_ports {e3_txd[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports e3_reset]
set_property PACKAGE_PIN T20 [get_ports e3_reset]

############## ethernet PORT4 RX define##################
create_clock -period 8.000 -name e4_rx_clk [get_ports e4_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports e4_rxc]
set_property PACKAGE_PIN Y18 [get_ports e4_rxc]

set_property PACKAGE_PIN V18 [get_ports e4_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports e4_mdc]

set_property IOSTANDARD LVCMOS33 [get_ports e4_rxdv]
set_property PACKAGE_PIN W20 [get_ports e4_rxdv]

set_property IOSTANDARD LVCMOS33 [get_ports e4_rxer]
set_property PACKAGE_PIN N13 [get_ports e4_rxer]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_rxd[0]}]
set_property PACKAGE_PIN W19 [get_ports {e4_rxd[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_rxd[1]}]
set_property PACKAGE_PIN Y19 [get_ports {e4_rxd[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_rxd[2]}]
set_property PACKAGE_PIN V22 [get_ports {e4_rxd[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_rxd[3]}]
set_property PACKAGE_PIN U22 [get_ports {e4_rxd[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_rxd[4]}]
set_property PACKAGE_PIN T18 [get_ports {e4_rxd[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_rxd[5]}]
set_property PACKAGE_PIN R18 [get_ports {e4_rxd[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_rxd[6]}]
set_property PACKAGE_PIN R14 [get_ports {e4_rxd[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_rxd[7]}]
set_property PACKAGE_PIN P14 [get_ports {e4_rxd[7]}]
############## ethernet PORT4 TX define##################
set_property IOSTANDARD LVCMOS33 [get_ports e4_txc]
set_property PACKAGE_PIN U16 [get_ports e4_txc]

create_clock -period 8.000 -name e4_gtx_clk [get_ports e4_gtxc]
set_property IOSTANDARD LVCMOS33 [get_ports e4_gtxc]
set_property PACKAGE_PIN P20 [get_ports e4_gtxc]

set_property IOSTANDARD LVCMOS33 [get_ports e4_txen]
set_property PACKAGE_PIN P16 [get_ports e4_txen]

set_property IOSTANDARD LVCMOS33 [get_ports e4_txer]
set_property PACKAGE_PIN R19 [get_ports e4_txer]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_txd[0]}]
set_property PACKAGE_PIN R17 [get_ports {e4_txd[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_txd[1]}]
set_property PACKAGE_PIN P15 [get_ports {e4_txd[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_txd[2]}]
set_property PACKAGE_PIN N17 [get_ports {e4_txd[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_txd[3]}]
set_property PACKAGE_PIN P17 [get_ports {e4_txd[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_txd[4]}]
set_property PACKAGE_PIN T16 [get_ports {e4_txd[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_txd[5]}]
set_property PACKAGE_PIN U17 [get_ports {e4_txd[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_txd[6]}]
set_property PACKAGE_PIN U18 [get_ports {e4_txd[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {e4_txd[7]}]
set_property PACKAGE_PIN P19 [get_ports {e4_txd[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports e4_reset]
set_property PACKAGE_PIN R16 [get_ports e4_reset]

### Clocks Routing ###
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets e1_txc_IBUF]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets e2_txc_IBUF]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets e3_txc_IBUF]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets e4_txc_IBUF]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets e1_rxc_IBUF]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets e2_rxc_IBUF]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets e3_rxc_IBUF]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets e4_rxc_IBUF]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets u_clk_rst_gen/u_eth_pll/eth_pll_clk]

set_false_path -from [get_clocks sys_pll_out] -to [get_clocks e1_rx_clk]
set_false_path -from [get_clocks e1_rx_clk] -to [get_clocks sys_pll_out]
set_false_path -from [get_clocks sys_pll_out] -to [get_clocks e2_rx_clk]
set_false_path -from [get_clocks e2_rx_clk] -to [get_clocks sys_pll_out]
set_false_path -from [get_clocks sys_pll_out] -to [get_clocks e3_rx_clk]
set_false_path -from [get_clocks e3_rx_clk] -to [get_clocks sys_pll_out]
set_false_path -from [get_clocks sys_pll_out] -to [get_clocks e4_rx_clk]
set_false_path -from [get_clocks e4_rx_clk] -to [get_clocks sys_pll_out]
set_false_path -from [get_clocks sys_pll_out] -to [get_clocks eth_pll_out]
set_false_path -from [get_clocks eth_pll_out] -to [get_clocks sys_pll_out]

### Input/Output Delay ###
#set_input_delay -clock e1_rx_clk -max 2.5 [get_ports e1_rxdv]
#set_input_delay -clock e1_rx_clk -min 0.5 [get_ports e1_rxdv]
#set_input_delay -clock e1_rx_clk -max 2.5 [get_ports e1_rxer]
#set_input_delay -clock e1_rx_clk -min 0.5 [get_ports e1_rxer]
#set_input_delay -clock e1_rx_clk -max 2.5 [get_ports {e1_rxd[*]}]
#set_input_delay -clock e1_rx_clk -min 0.5 [get_ports {e1_rxd[*]}]
#set_output_delay -clock e1_gtx_clk -max -4 [get_ports e1_txen]
#set_output_delay -clock e1_gtx_clk -min 0 [get_ports e1_txen]
#set_output_delay -clock e1_gtx_clk -max -4 [get_ports e1_txer]
#set_output_delay -clock e1_gtx_clk -min 0 [get_ports e1_txer]
#set_output_delay -clock e1_gtx_clk -max -4 [get_ports {e1_txd[*]}]
#set_output_delay -clock e1_gtx_clk -min 0 [get_ports {e1_txd[*]}]

#set_input_delay -clock e2_rx_clk -max 2.5 [get_ports e2_rxdv]
#set_input_delay -clock e2_rx_clk -min 0.5 [get_ports e2_rxdv]
#set_input_delay -clock e2_rx_clk -max 2.5 [get_ports e2_rxer]
#set_input_delay -clock e2_rx_clk -min 0.5 [get_ports e2_rxer]
#set_input_delay -clock e2_rx_clk -max 2.5 [get_ports {e2_rxd[*]}]
#set_input_delay -clock e2_rx_clk -min 0.5 [get_ports {e2_rxd[*]}]
#set_output_delay -clock e2_gtx_clk -max -4 [get_ports e2_txen]
#set_output_delay -clock e2_gtx_clk -min 0 [get_ports e2_txen]
#set_output_delay -clock e2_gtx_clk -max -4 [get_ports e2_txer]
#set_output_delay -clock e2_gtx_clk -min 0 [get_ports e2_txer]
#set_output_delay -clock e2_gtx_clk -max -4 [get_ports {e2_txd[*]}]
#set_output_delay -clock e2_gtx_clk -min 0 [get_ports {e2_txd[*]}]

#set_input_delay -clock e3_rx_clk -max 2.5 [get_ports e3_rxdv]
#set_input_delay -clock e3_rx_clk -min 0.5 [get_ports e3_rxdv]
#set_input_delay -clock e3_rx_clk -max 2.5 [get_ports e3_rxer]
#set_input_delay -clock e3_rx_clk -min 0.5 [get_ports e3_rxer]
#set_input_delay -clock e3_rx_clk -max 2.5 [get_ports {e3_rxd[*]}]
#set_input_delay -clock e3_rx_clk -min 0.5 [get_ports {e3_rxd[*]}]
#set_output_delay -clock e3_gtx_clk -max -4 [get_ports e3_txen]
#set_output_delay -clock e3_gtx_clk -min 0 [get_ports e3_txen]
#set_output_delay -clock e3_gtx_clk -max -4 [get_ports e3_txer]
#set_output_delay -clock e3_gtx_clk -min 0 [get_ports e3_txer]
#set_output_delay -clock e3_gtx_clk -max -4 [get_ports {e3_txd[*]}]
#set_output_delay -clock e3_gtx_clk -min 0 [get_ports {e3_txd[*]}]

#set_input_delay -clock e4_rx_clk -max 2.5 [get_ports e4_rxdv]
#set_input_delay -clock e4_rx_clk -min 0.5 [get_ports e4_rxdv]
#set_input_delay -clock e4_rx_clk -max 2.5 [get_ports e4_rxer]
#set_input_delay -clock e4_rx_clk -min 0.5 [get_ports e4_rxer]
#set_input_delay -clock e4_rx_clk -max 2.5 [get_ports {e4_rxd[*]}]
#set_input_delay -clock e4_rx_clk -min 0.5 [get_ports {e4_rxd[*]}]
#set_output_delay -clock e4_gtx_clk -max -4 [get_ports e4_txen]
#set_output_delay -clock e4_gtx_clk -min 0 [get_ports e4_txen]
#set_output_delay -clock e4_gtx_clk -max -4 [get_ports e4_txer]
#set_output_delay -clock e4_gtx_clk -min 0 [get_ports e4_txer]
#set_output_delay -clock e4_gtx_clk -max -4 [get_ports {e4_txd[*]}]
#set_output_delay -clock e4_gtx_clk -min 0 [get_ports {e4_txd[*]}]

set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][6]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][0]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][29]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][30]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][1]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][2]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][12]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][26]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][23]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][25]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][17]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][19]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][27]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][18]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][13]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][15]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][21]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][16]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][22]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][3]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][4]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][14]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][5]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][20]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][7]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][24]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][8]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][28]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][11]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][9]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][31]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_data][10]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][req]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[4]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[2]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[3]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[5]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[13]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[6]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[7]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[8]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[9]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[10]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[11]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.addr[12]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[31]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[1]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[0]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[25]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[26]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[27]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[2]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[15]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[14]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[12]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[13]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[29]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[3]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[4]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[5]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[16]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[19]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[22]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[17]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[23]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[20]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[21]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[18]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[6]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[7]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[8]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[11]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[28]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[30]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[24]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[9]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdat[10]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[1]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[0]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[2]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[3]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[4]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[5]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[6]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[7]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[8]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[9]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[14]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[11]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[12]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[13]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[31]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[10]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[16]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[15]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[17]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[27]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[18]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[19]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[20]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[21]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[24]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[30]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[28]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[29]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[25]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[26]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[22]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.wdat[23]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.we[0]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.we[1]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.we[2]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.we[3]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.vld}]
connect_debug_port u_ila_0/probe2 [get_nets [list {u_soc_csr/hwif_in[routing_table][rd_data][0]} {u_soc_csr/hwif_in[routing_table][rd_data][1]} {u_soc_csr/hwif_in[routing_table][rd_data][2]} {u_soc_csr/hwif_in[routing_table][rd_data][3]} {u_soc_csr/hwif_in[routing_table][rd_data][4]} {u_soc_csr/hwif_in[routing_table][rd_data][5]} {u_soc_csr/hwif_in[routing_table][rd_data][6]} {u_soc_csr/hwif_in[routing_table][rd_data][7]} {u_soc_csr/hwif_in[routing_table][rd_data][8]} {u_soc_csr/hwif_in[routing_table][rd_data][9]} {u_soc_csr/hwif_in[routing_table][rd_data][10]} {u_soc_csr/hwif_in[routing_table][rd_data][11]} {u_soc_csr/hwif_in[routing_table][rd_data][12]} {u_soc_csr/hwif_in[routing_table][rd_data][13]} {u_soc_csr/hwif_in[routing_table][rd_data][14]} {u_soc_csr/hwif_in[routing_table][rd_data][15]} {u_soc_csr/hwif_in[routing_table][rd_data][16]} {u_soc_csr/hwif_in[routing_table][rd_data][17]} {u_soc_csr/hwif_in[routing_table][rd_data][18]} {u_soc_csr/hwif_in[routing_table][rd_data][19]} {u_soc_csr/hwif_in[routing_table][rd_data][20]} {u_soc_csr/hwif_in[routing_table][rd_data][21]} {u_soc_csr/hwif_in[routing_table][rd_data][22]} {u_soc_csr/hwif_in[routing_table][rd_data][23]} {u_soc_csr/hwif_in[routing_table][rd_data][24]} {u_soc_csr/hwif_in[routing_table][rd_data][25]} {u_soc_csr/hwif_in[routing_table][rd_data][26]} {u_soc_csr/hwif_in[routing_table][rd_data][27]} {u_soc_csr/hwif_in[routing_table][rd_data][28]} {u_soc_csr/hwif_in[routing_table][rd_data][29]} {u_soc_csr/hwif_in[routing_table][rd_data][30]} {u_soc_csr/hwif_in[routing_table][rd_data][31]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {u_soc_csr/hwif_out[routing_table][req]}]]

set_property MARK_DEBUG true [get_nets {u_soc_csr/bus\\.rdy}]
set_property MARK_DEBUG false [get_nets u_soc_csr/hwif_out]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[4]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[0]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[1]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[26]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[20]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[21]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[2]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[3]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[16]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[22]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[17]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[18]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[23]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[31]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[24]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[25]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[30]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[27]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[28]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[29]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[19]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[5]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[6]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[15]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[7]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[8]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[9]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[10]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[11]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[12]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[13]}]
set_property MARK_DEBUG false [get_nets {u_soc_csr/hwif_in[14]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/addr_a[0]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/addr_a[1]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/addr_a[2]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/addr_a[3]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/addr_a[4]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/addr_a[5]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/addr_a[6]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/addr_a[7]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[5]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[0]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[1]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[2]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[3]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[4]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[11]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[6]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[7]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[8]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[9]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[10]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[14]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[12]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[23]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[28]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[24]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[30]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[29]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[13]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[31]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[15]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[16]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[17]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[18]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[19]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[26]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[21]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[22]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[25]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[27]}]
set_property MARK_DEBUG false [get_nets {u_dpe/u_routing_table/din_a[20]}]

set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][8]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][6]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][7]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][8]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][13]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][11]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][28]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][16]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][27]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][31]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][9]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][22]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][14]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][18]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][17]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][29]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][15]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][25]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][19]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][24]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][23]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][21]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][12]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][0]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][1]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][2]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][20]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][6]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][10]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][7]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][3]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][9]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][26]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][30]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][4]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][wr_data][5]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][1]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][0]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][2]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][3]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][4]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][addr][5]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][rd_ack]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_in[routing_table][wr_ack]}]
set_property MARK_DEBUG true [get_nets {u_soc_csr/hwif_out[routing_table][req_is_wr]}]

