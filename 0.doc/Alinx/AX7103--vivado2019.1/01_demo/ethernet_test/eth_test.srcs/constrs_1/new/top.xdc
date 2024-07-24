################################################################

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
############## clock define##################
create_clock -period 5.000 [get_ports sys_clk_p]
set_property PACKAGE_PIN R4 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
##############reset key define##################
set_property PACKAGE_PIN T6 [get_ports rst_n]
set_property IOSTANDARD LVCMOS15 [get_ports rst_n]
##############reset key define##################
set_property PACKAGE_PIN E13 [get_ports key]
set_property IOSTANDARD LVCMOS33 [get_ports key]
##############LED define##################
set_property PACKAGE_PIN B13 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN C13 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN D14 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN D15 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
#########################ethernet######################
create_clock -period 8.000 [get_ports rgmii1_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii1_rxd[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii1_txd[*]}]
set_property SLEW FAST [get_ports {rgmii1_txd[*]}]

set_property IOSTANDARD LVCMOS33 [get_ports e1_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports e1_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports e1_reset]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii1_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii1_rxctl]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii1_txc]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii1_txctl]
set_property SLEW FAST [get_ports rgmii1_txc]
set_property SLEW FAST [get_ports rgmii1_txctl]

set_property PACKAGE_PIN C19 [get_ports {rgmii1_rxd[3]}]
set_property PACKAGE_PIN C18 [get_ports {rgmii1_rxd[2]}]
set_property PACKAGE_PIN B18 [get_ports {rgmii1_rxd[1]}]
set_property PACKAGE_PIN A16 [get_ports {rgmii1_rxd[0]}]
set_property PACKAGE_PIN A18 [get_ports {rgmii1_txd[3]}]
set_property PACKAGE_PIN A19 [get_ports {rgmii1_txd[2]}]
set_property PACKAGE_PIN D20 [get_ports {rgmii1_txd[1]}]
set_property PACKAGE_PIN C20 [get_ports {rgmii1_txd[0]}]
set_property PACKAGE_PIN B16 [get_ports e1_mdc]
set_property PACKAGE_PIN B15 [get_ports e1_mdio]
set_property PACKAGE_PIN D16 [get_ports e1_reset]
set_property PACKAGE_PIN B17 [get_ports rgmii1_rxc]
set_property PACKAGE_PIN A15 [get_ports rgmii1_rxctl]
set_property PACKAGE_PIN E18 [get_ports rgmii1_txc]
set_property PACKAGE_PIN F18 [get_ports rgmii1_txctl]

create_clock -period 8.000 [get_ports rgmii2_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii2_rxd[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii2_txd[*]}]
set_property SLEW FAST [get_ports {rgmii2_txd[*]}]

set_property IOSTANDARD LVCMOS33 [get_ports e2_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports e2_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports e2_reset]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii2_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii2_rxctl]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii2_txc]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii2_txctl]
set_property SLEW FAST [get_ports rgmii2_txc]
set_property SLEW FAST [get_ports rgmii2_txctl]

set_property PACKAGE_PIN C17 [get_ports {rgmii2_rxd[3]}]
set_property PACKAGE_PIN D19 [get_ports {rgmii2_rxd[2]}]
set_property PACKAGE_PIN B20 [get_ports {rgmii2_rxd[1]}]
set_property PACKAGE_PIN A20 [get_ports {rgmii2_rxd[0]}]
set_property PACKAGE_PIN A13 [get_ports {rgmii2_txd[3]}]
set_property PACKAGE_PIN C15 [get_ports {rgmii2_txd[2]}]
set_property PACKAGE_PIN C14 [get_ports {rgmii2_txd[1]}]
set_property PACKAGE_PIN E17 [get_ports {rgmii2_txd[0]}]
set_property PACKAGE_PIN F20 [get_ports e2_mdc]
set_property PACKAGE_PIN C22 [get_ports e2_mdio]
set_property PACKAGE_PIN B22 [get_ports e2_reset]
set_property PACKAGE_PIN E19 [get_ports rgmii2_rxc]
set_property PACKAGE_PIN F19 [get_ports rgmii2_rxctl]
set_property PACKAGE_PIN A14 [get_ports rgmii2_txc]
set_property PACKAGE_PIN D17 [get_ports rgmii2_txctl]

#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]


set_false_path -reset_path -from [get_clocks -of_objects [get_pins refclk/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks rgmii1_rxc]
set_false_path -reset_path -from [get_clocks -of_objects [get_pins refclk/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks rgmii2_rxc]
