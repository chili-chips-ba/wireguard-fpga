set_property SRC_FILE_INFO {cfile:d:/demo_AX7050/demo_ax7050/19_ethernet_1g_100M/rgmii_ethernet/eth_test.srcs/sources_1/ip/rxd_clk/rxd_clk.xdc rfile:../eth_test.srcs/sources_1/ip/rxd_clk/rxd_clk.xdc id:1 order:EARLY scoped_inst:rxd_clk_m0/inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.08
