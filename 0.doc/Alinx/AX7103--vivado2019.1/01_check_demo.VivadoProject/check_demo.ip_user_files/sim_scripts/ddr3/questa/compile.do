vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/mig_7series_v4_2_clk_ibuf.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/mig_7series_v4_2_infrastructure.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/mig_7series_v4_2_iodelay_ctrl.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/mig_7series_v4_2_tempmon.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_arb_mux.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_arb_row_col.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_arb_select.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_bank_cntrl.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_bank_common.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_bank_compare.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_bank_mach.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_bank_queue.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_bank_state.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_col_mach.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_mc.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_rank_cntrl.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_rank_common.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_rank_mach.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v4_2_round_robin_arb.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v4_2_ecc_buf.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v4_2_ecc_dec_fix.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v4_2_ecc_gen.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v4_2_ecc_merge_enc.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v4_2_fi_xor.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ip_top/mig_7series_v4_2_memc_ui_top_std.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ip_top/mig_7series_v4_2_mem_intfc.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_group_io.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_lane.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_calib_top.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_if_post_fifo.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy_wrapper.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_of_pre_fifo.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_4lanes.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal_hr.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_init.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_cntlr.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_data.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_edge.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_lim.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_mux.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_samp.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_oclkdelay_cal.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_prbs_rdlvl.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_rdlvl.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_tempmon.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_top.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrcal.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl_off_delay.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_prbs_gen.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_ddr_skip_calib_tap.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_poc_cc.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_poc_edge_store.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_poc_meta.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_poc_pd.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_poc_tap_base.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v4_2_poc_top.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/mig_7series_v4_2_ui_cmd.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/mig_7series_v4_2_ui_rd_data.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/mig_7series_v4_2_ui_top.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/mig_7series_v4_2_ui_wr_data.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ddr3_mig_sim.v" \
"../../../../src/ddr/ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ddr3.v" \


vlog -work xil_defaultlib \
"glbl.v"

