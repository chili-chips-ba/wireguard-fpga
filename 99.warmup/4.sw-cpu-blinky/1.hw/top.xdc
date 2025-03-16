############# LED Setting ###########################
set_property PACKAGE_PIN E17 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN F16 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

############## NET - IOSTANDARD ######################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

############# SPI Configurate Setting ##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

############## clock define###########################
create_clock -period 5.000 [get_ports clk_p]
set_property PACKAGE_PIN R4 [get_ports clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]

create_clock -period 5.000 [get_ports clk_n]
set_property PACKAGE_PIN T4 [get_ports clk_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_n]

#################reset setting########################
set_property IOSTANDARD LVCMOS15 [get_ports rst_n]
set_property PACKAGE_PIN T6 [get_ports rst_n]
