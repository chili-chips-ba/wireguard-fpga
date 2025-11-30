read_vhdl -vhdl2008 -library work {/home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/built_in/pipelinec_fifo_fwft.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/built_in/pipelinec_async_fifo_fwft.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/c_structs_pkg.pkg.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/global_wires_pkg.pkg.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/strip_auth_tag/strip_auth_tag_0CLK_69e380ac_top.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/strip_auth_tag/strip_auth_tag_0CLK_69e380ac.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/axis128_early_tlast/axis128_early_tlast_0CLK_4e6656cf.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/built_in/MUX_uint1_t_uint1_t_uint1_t/MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/built_in/BIN_OP_AND_uint1_t_uint1_t/BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/built_in/MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t/MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/built_in/BIN_OP_OR_uint1_t_uint1_t/BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/built_in/MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t/MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78.vhd /home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/built_in/UNARY_OP_NOT_uint1_t/UNARY_OP_NOT_uint1_t_0CLK_de264c78.vhd }
read_xdc {/home/nikola/ChiliChips/wireguard-fpga/3.build/pipelinec_build/generated-files-sim-pipe-dec/strip_auth_tag/clock.xdc}
set_msg_config -id {Synth 8-312} -new_severity ERROR
set_msg_config -id {Synth 8-614} -new_severity ERROR
set_msg_config -id {Synth 8-2489} -new_severity ERROR
set_msg_config -id {Vivado 12-584} -new_severity ERROR
set_msg_config -id {Vivado 12-507} -new_severity ERROR
set_msg_config -id {Synth 8-326} -new_severity "CRITICAL WARNING"
set_msg_config -id {Synth 8-4471} -limit 10000
set_msg_config -id {Synth 8-3332} -limit 10000
set_msg_config -id {Synth 8-3331} -limit 10000
set_msg_config -id {Synth 8-5546} -limit 10000
set_msg_config -id {Synth 8-3848} -limit 10000
set_msg_config -id {Synth 8-223} -limit 10000
set_param general.maxThreads 8
synth_design -mode out_of_context -top strip_auth_tag_0CLK_69e380ac_top -part xc7a200tffg1156-2
report_utilization
report_timing_summary -setup
