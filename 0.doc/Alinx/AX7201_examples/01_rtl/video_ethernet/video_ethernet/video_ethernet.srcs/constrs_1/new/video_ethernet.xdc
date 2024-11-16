############## NET - IOSTANDARD ######################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design] 
set_property CONFIG_MODE SPIx4 [current_design] 
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design] 
############## clock define###########################
create_clock -period 5 [get_ports sys_clk_p]
set_property PACKAGE_PIN R4 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
############## key define#############################
set_property PACKAGE_PIN T6 [get_ports rst_n]
set_property IOSTANDARD LVCMOS15 [get_ports rst_n]
set_property PACKAGE_PIN E16 [get_ports key2]
set_property IOSTANDARD LVCMOS33 [get_ports key2]
##################AN5642 on ax7101 J11###############
set_property PACKAGE_PIN J19 [get_ports {cmos1_sda}]
set_property PACKAGE_PIN G16 [get_ports {cmos1_db[9]}]
set_property PACKAGE_PIN G15 [get_ports {cmos1_db[8]}]
set_property PACKAGE_PIN D19 [get_ports {cmos1_scl}]
set_property PACKAGE_PIN E19 [get_ports {cmos1_db[5]}]
set_property PACKAGE_PIN C20 [get_ports {cmos1_db[3]}]
set_property PACKAGE_PIN D20 [get_ports {cmos1_db[4]}]
set_property PACKAGE_PIN A19 [get_ports {cmos1_db[6]}]
set_property PACKAGE_PIN E18 [get_ports {cmos1_db[7]}]
set_property PACKAGE_PIN C19 [get_ports {cmos1_db[2]}]
set_property PACKAGE_PIN C18 [get_ports {cmos1_pclk}]
set_property PACKAGE_PIN B18 [get_ports {cmos1_href}]
set_property PACKAGE_PIN B17 [get_ports {cmos1_vsync}]
set_property PACKAGE_PIN C17 [get_ports {cmos1_rst_n}]
set_property PACKAGE_PIN F18 [get_ports {cmos1_db[1]}]
set_property PACKAGE_PIN A18 [get_ports {cmos1_db[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_sda}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_scl}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_pclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_href}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_vsync}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_rst_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_db[0]}]

set_property PACKAGE_PIN B22 [get_ports {cmos2_db[9]}]
set_property PACKAGE_PIN C22 [get_ports {cmos2_sda}]
set_property PACKAGE_PIN A20 [get_ports {cmos2_db[6]}]
set_property PACKAGE_PIN B20 [get_ports {cmos2_scl}]
set_property PACKAGE_PIN F20 [get_ports {cmos2_db[7]}]
set_property PACKAGE_PIN F19 [get_ports {cmos2_db[2]}]
set_property PACKAGE_PIN J16 [get_ports {cmos2_href}]
set_property PACKAGE_PIN F15 [get_ports {cmos2_db[8]}]
set_property PACKAGE_PIN F21 [get_ports {cmos2_db[3]}]
set_property PACKAGE_PIN M17 [get_ports {cmos2_rst_n}]
set_property PACKAGE_PIN A21 [get_ports {cmos2_db[4]}]
set_property PACKAGE_PIN B21 [get_ports {cmos2_db[5]}]
set_property PACKAGE_PIN G18 [get_ports {cmos2_vsync}]
set_property PACKAGE_PIN G17 [get_ports {cmos2_pclk}]
set_property PACKAGE_PIN D21 [get_ports {cmos2_db[1]}]
set_property PACKAGE_PIN E21 [get_ports {cmos2_db[0]}]


set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_sda}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_scl}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_href}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_rst_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_vsync}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_pclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos2_db[0]}]

create_clock -period 11.904 [get_ports cmos1_pclk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cmos1_pclk_IBUF]

create_clock -period 11.904 [get_ports cmos2_pclk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cmos2_pclk_IBUF]
############## ethernet PORT1 RX define##################
create_clock -name e1_rx_clk -period 8 [get_ports e1_rxc]
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
############## ethernet PORT1 TX define##################
set_property IOSTANDARD LVCMOS33 [get_ports e1_txc]
set_property PACKAGE_PIN K21 [get_ports e1_txc]

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

create_clock -name e1_tx_clk -period 8 [get_ports e1_gtxc]
############## ethernet PORT2 RX define##################
create_clock -name e2_rx_clk -period 8 [get_ports e2_rxc]
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

create_clock -name e2_tx_clk -period 8 [get_ports e2_gtxc]
############## ethernet PORT3 RX define##################
create_clock -name e3_rx_clk -period 8 [get_ports e3_rxc]
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

create_clock -name e3_tx_clk -period 8 [get_ports e3_gtxc]
############## ethernet PORT4 RX define##################
create_clock -name e4_rx_clk -period 8 [get_ports e4_rxc]
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

create_clock -name e4_tx_clk -period 8 [get_ports e4_gtxc]

