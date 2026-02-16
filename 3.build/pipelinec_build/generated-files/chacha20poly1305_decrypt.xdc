# Copy of pipelinec 'clocks.xdc' output file
#create_clock -add -name clk_80p0 -period 12.5 -waveform {0 6.25} [get_ports {clk_80p0}]
set_multicycle_path 4 -setup -from [get_pins poly1305_mac_decrypt_compute_0CLK_31cfddb2/poly1305_mac_loop_body_mcp4_poly1305_mac_c_l21_c72_7171/launch_reg[*]/C] -to [get_pins poly1305_mac_decrypt_compute_0CLK_31cfddb2/poly1305_mac_loop_body_mcp4_poly1305_mac_c_l21_c72_7171/capture_reg[*]/D]
set_property KEEP TRUE [get_cells poly1305_mac_decrypt_compute_0CLK_31cfddb2/poly1305_mac_loop_body_mcp4_poly1305_mac_c_l21_c72_7171/launch_reg[*]]
set_property KEEP TRUE [get_cells poly1305_mac_decrypt_compute_0CLK_31cfddb2/poly1305_mac_loop_body_mcp4_poly1305_mac_c_l21_c72_7171/capture_reg[*]]
