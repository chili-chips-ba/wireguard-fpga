############## NET - IOSTANDARD ################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
#############SPI Configurate Setting############
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design] 
set_property CONFIG_MODE SPIx4 [current_design] 
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design] 
############## clock define#####################
create_clock -period 5 [get_ports sys_clk_p]
set_property PACKAGE_PIN R4 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
############## key define########################


set_property PACKAGE_PIN E13 [get_ports key0]
set_property IOSTANDARD LVCMOS33 [get_ports key0]
##############LED define##########################
set_property PACKAGE_PIN B13 [get_ports {led_key[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_key[0]}]

set_property PACKAGE_PIN C13 [get_ports {led_key[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_key[1]}]

set_property PACKAGE_PIN D14 [get_ports {led_key[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_key[2]}]

set_property PACKAGE_PIN D15 [get_ports led_eth]
set_property IOSTANDARD LVCMOS33 [get_ports led_eth]
############## SD card define#####################
set_property IOSTANDARD LVCMOS33 [get_ports sd_dclk]
 set_property PACKAGE_PIN AB12 [get_ports sd_dclk]

set_property IOSTANDARD LVCMOS33 [get_ports sd_ncs]
set_property PACKAGE_PIN AA14 [get_ports sd_ncs]

set_property IOSTANDARD LVCMOS33 [get_ports sd_mosi]
set_property PACKAGE_PIN AB11 [get_ports sd_mosi]

set_property IOSTANDARD LVCMOS33 [get_ports sd_miso]
set_property PACKAGE_PIN AA13 [get_ports sd_miso]
