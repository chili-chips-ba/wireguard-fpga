//*****************************************************************************
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor                : Xilinx
// \   \   \/     Version               : %version
//  \   \         Application           : MIG
//  /   /         Filename              : bank_cntrl.v
// /___/   /\     Date Last Modified    : $date$
// \   \  /  \    Date Created          : Tue Jun 30 2009
//  \___\/\___\
//
//Device            : 7-Series
//Design Name       : DDR3 SDRAM
//Purpose           :
//Reference         :
//Revision History  :
//*****************************************************************************

// Structural block instantiating the three sub blocks that make up
// a bank machine.
`timescale 1ps/1ps

module mig_7series_v4_2_bank_cntrl #
  (
   parameter TCQ = 100,
   parameter ADDR_CMD_MODE            = "1T",
   parameter BANK_WIDTH               = 3,
   parameter BM_CNT_WIDTH             = 2,
   parameter BURST_MODE               = "8",
   parameter COL_WIDTH                = 12,
   parameter CWL                      = 5,
   parameter DATA_BUF_ADDR_WIDTH      = 8,
   parameter DRAM_TYPE                = "DDR3",
   parameter ECC                      = "OFF",
   parameter ID                       = 4,
   parameter nBANK_MACHS              = 4,
   parameter nCK_PER_CLK              = 2,
   parameter nOP_WAIT                 = 0,
   parameter nRAS_CLKS                = 10,
   parameter nRCD                     = 5,
   parameter nRTP                     = 4,
   parameter nRP                      = 10,
   parameter nWTP_CLKS                = 5,
   parameter ORDERING                 = "NORM",
   parameter RANK_WIDTH               = 2,
   parameter RANKS                    = 4,
   parameter RAS_TIMER_WIDTH          = 5,
   parameter ROW_WIDTH                = 16,
   parameter STARVE_LIMIT             = 2
  )
  (/*AUTOARG*/
  // Outputs
  wr_this_rank_r, start_rcd, start_pre_wait, rts_row, rts_col, rts_pre, rtc,
  row_cmd_wr, row_addr, req_size_r, req_row_r, req_ras,
  req_periodic_rd_r, req_cas, req_bank_r, rd_this_rank_r,
  rb_hit_busy_ns, ras_timer_ns, rank_busy_r, ordered_r,
  ordered_issued, op_exit_req, end_rtp, demand_priority,
  demand_act_priority, col_rdy_wr, col_addr, act_this_rank_r, idle_ns,
  req_wr_r, rd_wr_r, bm_end, idle_r, head_r, req_rank_r,
  rb_hit_busy_r, passing_open_bank, maint_hit, req_data_buf_addr_r,
  // Inputs
  was_wr, was_priority, use_addr, start_rcd_in,
  size, sent_row, sent_col, sending_row, sending_pre, sending_col, rst, row,
  req_rank_r_in, rd_rmw, rd_data_addr, rb_hit_busy_ns_in,
  rb_hit_busy_cnt, ras_timer_ns_in, rank, periodic_rd_rank_r,
  periodic_rd_insert, periodic_rd_ack_r, passing_open_bank_in,
  order_cnt, op_exit_grant, maint_zq_r, maint_sre_r, maint_req_r, maint_rank_r,
  maint_idle, low_idle_cnt_r, rnk_config_valid_r, inhbt_rd, inhbt_wr,
  rnk_config_strobe, rnk_config, inhbt_act_faw_r, idle_cnt, hi_priority,
  dq_busy_data, phy_rddata_valid, demand_priority_in, demand_act_priority_in,
  data_buf_addr, col, cmd, clk, bm_end_in, bank, adv_order_q,
  accept_req, accept_internal_r, rnk_config_kill_rts_col, phy_mc_ctl_full,
  phy_mc_cmd_full, phy_mc_data_full
  );

  /*AUTOINPUT*/
  // Beginning of automatic inputs (from unused autoinst inputs)
  input                 accept_internal_r;      // To bank_queue0 of bank_queue.v
  input                 accept_req;             // To bank_queue0 of bank_queue.v
  input                 adv_order_q;            // To bank_queue0 of bank_queue.v
  input [BANK_WIDTH-1:0] bank;                  // To bank_compare0 of bank_compare.v
  input [(nBANK_MACHS*2)-1:0] bm_end_in;        // To bank_queue0 of bank_queue.v
  input                 clk;                    // To bank_compare0 of bank_compare.v, ...
  input [2:0]           cmd;                    // To bank_compare0 of bank_compare.v
  input [COL_WIDTH-1:0] col;                    // To bank_compare0 of bank_compare.v
  input [DATA_BUF_ADDR_WIDTH-1:0] data_buf_addr;// To bank_compare0 of bank_compare.v
  input [(nBANK_MACHS*2)-1:0] demand_act_priority_in;// To bank_state0 of bank_state.v
  input [(nBANK_MACHS*2)-1:0] demand_priority_in;// To bank_state0 of bank_state.v
  input                 phy_rddata_valid;       // To bank_state0 of bank_state.v
  input                 dq_busy_data;           // To bank_state0 of bank_state.v
  input                 hi_priority;            // To bank_compare0 of bank_compare.v
  input [BM_CNT_WIDTH-1:0] idle_cnt;            // To bank_queue0 of bank_queue.v
  input [RANKS-1:0]     inhbt_act_faw_r;        // To bank_state0 of bank_state.v
  input [RANKS-1:0]     inhbt_rd;               // To bank_state0 of bank_state.v
  input [RANKS-1:0]     inhbt_wr;               // To bank_state0 of bank_state.v
  input [RANK_WIDTH-1:0]rnk_config;             // To bank_state0 of bank_state.v
  input                 rnk_config_strobe;      // To bank_state0 of bank_state.v
  input                 rnk_config_kill_rts_col;// To bank_state0 of bank_state.v
  input                 rnk_config_valid_r;     // To bank_state0 of bank_state.v
  input                 low_idle_cnt_r;         // To bank_state0 of bank_state.v
  input                 maint_idle;             // To bank_queue0 of bank_queue.v
  input [RANK_WIDTH-1:0] maint_rank_r;          // To bank_compare0 of bank_compare.v
  input                 maint_req_r;            // To bank_queue0 of bank_queue.v
  input                 maint_zq_r;             // To bank_compare0 of bank_compare.v
  input                 maint_sre_r;            // To bank_compare0 of bank_compare.v
  input                 op_exit_grant;          // To bank_state0 of bank_state.v
  input [BM_CNT_WIDTH-1:0] order_cnt;           // To bank_queue0 of bank_queue.v
  input [(nBANK_MACHS*2)-1:0] passing_open_bank_in;// To bank_queue0 of bank_queue.v
  input                 periodic_rd_ack_r;      // To bank_queue0 of bank_queue.v
  input                 periodic_rd_insert;     // To bank_compare0 of bank_compare.v
  input [RANK_WIDTH-1:0] periodic_rd_rank_r;    // To bank_compare0 of bank_compare.v
  input                 phy_mc_ctl_full;
  input                 phy_mc_cmd_full;
  input                 phy_mc_data_full;
  input [RANK_WIDTH-1:0] rank;                  // To bank_compare0 of bank_compare.v
  input [(2*(RAS_TIMER_WIDTH*nBANK_MACHS))-1:0] ras_timer_ns_in;// To bank_state0 of bank_state.v
  input [BM_CNT_WIDTH-1:0] rb_hit_busy_cnt;     // To bank_queue0 of bank_queue.v
  input [(nBANK_MACHS*2)-1:0] rb_hit_busy_ns_in;// To bank_queue0 of bank_queue.v
  input [DATA_BUF_ADDR_WIDTH-1:0] rd_data_addr; // To bank_state0 of bank_state.v
  input                 rd_rmw;                 // To bank_state0 of bank_state.v
  input [(RANK_WIDTH*nBANK_MACHS*2)-1:0] req_rank_r_in;// To bank_state0 of bank_state.v
  input [ROW_WIDTH-1:0] row;                    // To bank_compare0 of bank_compare.v
  input                 rst;                    // To bank_state0 of bank_state.v, ...
  input                 sending_col;            // To bank_compare0 of bank_compare.v, ...
  input                 sending_row;            // To bank_state0 of bank_state.v
  input                 sending_pre;
  input                 sent_col;               // To bank_state0 of bank_state.v
  input                 sent_row;               // To bank_state0 of bank_state.v
  input                 size;                   // To bank_compare0 of bank_compare.v
  input [(nBANK_MACHS*2)-1:0] start_rcd_in;     // To bank_state0 of bank_state.v
  input                 use_addr;               // To bank_queue0 of bank_queue.v
  input                 was_priority;           // To bank_queue0 of bank_queue.v
  input                 was_wr;                 // To bank_queue0 of bank_queue.v
  // End of automatics

   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output [RANKS-1:0]   act_this_rank_r;        // From bank_state0 of bank_state.v
   output [ROW_WIDTH-1:0] col_addr;             // From bank_compare0 of bank_compare.v
   output               col_rdy_wr;             // From bank_state0 of bank_state.v
   output               demand_act_priority;    // From bank_state0 of bank_state.v
   output               demand_priority;        // From bank_state0 of bank_state.v
   output               end_rtp;                // From bank_state0 of bank_state.v
   output               op_exit_req;            // From bank_state0 of bank_state.v
   output               ordered_issued;         // From bank_queue0 of bank_queue.v
   output               ordered_r;              // From bank_queue0 of bank_queue.v
   output [RANKS-1:0]   rank_busy_r;            // From bank_compare0 of bank_compare.v
   output [RAS_TIMER_WIDTH-1:0] ras_timer_ns;   // From bank_state0 of bank_state.v
   output               rb_hit_busy_ns;         // From bank_compare0 of bank_compare.v
   output [RANKS-1:0]   rd_this_rank_r;         // From bank_state0 of bank_state.v
   output [BANK_WIDTH-1:0] req_bank_r;          // From bank_compare0 of bank_compare.v
   output               req_cas;                // From bank_compare0 of bank_compare.v
   output               req_periodic_rd_r;      // From bank_compare0 of bank_compare.v
   output               req_ras;                // From bank_compare0 of bank_compare.v
   output [ROW_WIDTH-1:0] req_row_r;            // From bank_compare0 of bank_compare.v
   output               req_size_r;             // From bank_compare0 of bank_compare.v
   output [ROW_WIDTH-1:0] row_addr;             // From bank_compare0 of bank_compare.v
   output               row_cmd_wr;             // From bank_compare0 of bank_compare.v
   output               rtc;                    // From bank_state0 of bank_state.v
   output               rts_col;                // From bank_state0 of bank_state.v
   output               rts_row;                // From bank_state0 of bank_state.v
   output               rts_pre;
   output               start_pre_wait;         // From bank_state0 of bank_state.v
   output               start_rcd;              // From bank_state0 of bank_state.v
   output [RANKS-1:0]   wr_this_rank_r;         // From bank_state0 of bank_state.v
   // End of automatics

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 act_wait_r;             // From bank_state0 of bank_state.v
   wire                 allow_auto_pre;         // From bank_state0 of bank_state.v
   wire                 auto_pre_r;             // From bank_queue0 of bank_queue.v
   wire                 bank_wait_in_progress;  // From bank_state0 of bank_state.v
   wire                 order_q_zero;           // From bank_queue0 of bank_queue.v
   wire                 pass_open_bank_ns;      // From bank_queue0 of bank_queue.v
   wire                 pass_open_bank_r;       // From bank_queue0 of bank_queue.v
   wire                 pre_wait_r;             // From bank_state0 of bank_state.v
   wire                 precharge_bm_end;       // From bank_state0 of bank_state.v
   wire                 q_has_priority;         // From bank_queue0 of bank_queue.v
   wire                 q_has_rd;               // From bank_queue0 of bank_queue.v
   wire [nBANK_MACHS*2-1:0] rb_hit_busies_r;    // From bank_queue0 of bank_queue.v
   wire                 rcv_open_bank;          // From bank_queue0 of bank_queue.v
   wire                 rd_half_rmw;            // From bank_state0 of bank_state.v
   wire                 req_priority_r;         // From bank_compare0 of bank_compare.v
   wire                 row_hit_r;              // From bank_compare0 of bank_compare.v
   wire                 tail_r;                 // From bank_queue0 of bank_queue.v
   wire                 wait_for_maint_r;       // From bank_queue0 of bank_queue.v
   // End of automatics

  output idle_ns;
  output req_wr_r;
  output rd_wr_r;
  output bm_end;
  output idle_r;
  output head_r;
  output [RANK_WIDTH-1:0] req_rank_r;
  output rb_hit_busy_r;
  output passing_open_bank;
  output maint_hit;
  output [DATA_BUF_ADDR_WIDTH-1:0] req_data_buf_addr_r;

  mig_7series_v4_2_bank_compare #
    (/*AUTOINSTPARAM*/
     // Parameters
     .BANK_WIDTH                        (BANK_WIDTH),
     .TCQ                               (TCQ),
     .BURST_MODE                        (BURST_MODE),
     .COL_WIDTH                         (COL_WIDTH),
     .DATA_BUF_ADDR_WIDTH               (DATA_BUF_ADDR_WIDTH),
     .ECC                               (ECC),
     .RANK_WIDTH                        (RANK_WIDTH),
     .RANKS                             (RANKS),
     .ROW_WIDTH                         (ROW_WIDTH))
    bank_compare0
      (/*AUTOINST*/
       // Outputs
       .req_data_buf_addr_r             (req_data_buf_addr_r[DATA_BUF_ADDR_WIDTH-1:0]),
       .req_periodic_rd_r               (req_periodic_rd_r),
       .req_size_r                      (req_size_r),
       .rd_wr_r                         (rd_wr_r),
       .req_rank_r                      (req_rank_r[RANK_WIDTH-1:0]),
       .req_bank_r                      (req_bank_r[BANK_WIDTH-1:0]),
       .req_row_r                       (req_row_r[ROW_WIDTH-1:0]),
       .req_wr_r                        (req_wr_r),
       .req_priority_r                  (req_priority_r),
       .rb_hit_busy_r                   (rb_hit_busy_r),
       .rb_hit_busy_ns                  (rb_hit_busy_ns),
       .row_hit_r                       (row_hit_r),
       .maint_hit                       (maint_hit),
       .col_addr                        (col_addr[ROW_WIDTH-1:0]),
       .req_ras                         (req_ras),
       .req_cas                         (req_cas),
       .row_cmd_wr                      (row_cmd_wr),
       .row_addr                        (row_addr[ROW_WIDTH-1:0]),
       .rank_busy_r                     (rank_busy_r[RANKS-1:0]),
       // Inputs
       .clk                             (clk),
       .idle_ns                         (idle_ns),
       .idle_r                          (idle_r),
       .data_buf_addr                   (data_buf_addr[DATA_BUF_ADDR_WIDTH-1:0]),
       .periodic_rd_insert              (periodic_rd_insert),
       .size                            (size),
       .cmd                             (cmd[2:0]),
       .sending_col                     (sending_col),
       .rank                            (rank[RANK_WIDTH-1:0]),
       .periodic_rd_rank_r              (periodic_rd_rank_r[RANK_WIDTH-1:0]),
       .bank                            (bank[BANK_WIDTH-1:0]),
       .row                             (row[ROW_WIDTH-1:0]),
       .col                             (col[COL_WIDTH-1:0]),
       .hi_priority                     (hi_priority),
       .maint_rank_r                    (maint_rank_r[RANK_WIDTH-1:0]),
       .maint_zq_r                      (maint_zq_r),
       .maint_sre_r                     (maint_sre_r),
       .auto_pre_r                      (auto_pre_r),
       .rd_half_rmw                     (rd_half_rmw),
       .act_wait_r                      (act_wait_r));

  mig_7series_v4_2_bank_state #
    (/*AUTOINSTPARAM*/
     // Parameters
     .TCQ                               (TCQ),
     .ADDR_CMD_MODE                     (ADDR_CMD_MODE),
     .BM_CNT_WIDTH                      (BM_CNT_WIDTH),
     .BURST_MODE                        (BURST_MODE),
     .CWL                               (CWL),
     .DATA_BUF_ADDR_WIDTH               (DATA_BUF_ADDR_WIDTH),
     .DRAM_TYPE                         (DRAM_TYPE),
     .ECC                               (ECC),
     .ID                                (ID),
     .nBANK_MACHS                       (nBANK_MACHS),
     .nCK_PER_CLK                       (nCK_PER_CLK),
     .nOP_WAIT                          (nOP_WAIT),
     .nRAS_CLKS                         (nRAS_CLKS),
     .nRP                               (nRP),
     .nRTP                              (nRTP),
     .nRCD                              (nRCD),
     .nWTP_CLKS                         (nWTP_CLKS),
     .ORDERING                          (ORDERING),
     .RANKS                             (RANKS),
     .RANK_WIDTH                        (RANK_WIDTH),
     .RAS_TIMER_WIDTH                   (RAS_TIMER_WIDTH),
     .STARVE_LIMIT                      (STARVE_LIMIT))
    bank_state0
      (/*AUTOINST*/
       // Outputs
       .start_rcd                       (start_rcd),
       .act_wait_r                      (act_wait_r),
       .rd_half_rmw                     (rd_half_rmw),
       .ras_timer_ns                    (ras_timer_ns[RAS_TIMER_WIDTH-1:0]),
       .end_rtp                         (end_rtp),
       .bank_wait_in_progress           (bank_wait_in_progress),
       .start_pre_wait                  (start_pre_wait),
       .op_exit_req                     (op_exit_req),
       .pre_wait_r                      (pre_wait_r),
       .allow_auto_pre                  (allow_auto_pre),
       .precharge_bm_end                (precharge_bm_end),
       .demand_act_priority             (demand_act_priority),
       .rts_row                         (rts_row),
       .rts_pre                         (rts_pre),
       .act_this_rank_r                 (act_this_rank_r[RANKS-1:0]),
       .demand_priority                 (demand_priority),
       .col_rdy_wr                      (col_rdy_wr),
       .rts_col                         (rts_col),
       .wr_this_rank_r                  (wr_this_rank_r[RANKS-1:0]),
       .rd_this_rank_r                  (rd_this_rank_r[RANKS-1:0]),
       // Inputs
       .clk                             (clk),
       .rst                             (rst),
       .bm_end                          (bm_end),
       .pass_open_bank_r                (pass_open_bank_r),
       .sending_row                     (sending_row),
       .sending_pre                     (sending_pre),
       .rcv_open_bank                   (rcv_open_bank),
       .sending_col                     (sending_col),
       .rd_wr_r                         (rd_wr_r),
       .req_wr_r                        (req_wr_r),
       .rd_data_addr                    (rd_data_addr[DATA_BUF_ADDR_WIDTH-1:0]),
       .req_data_buf_addr_r             (req_data_buf_addr_r[DATA_BUF_ADDR_WIDTH-1:0]),
       .phy_rddata_valid                (phy_rddata_valid),
       .rd_rmw                          (rd_rmw),
       .ras_timer_ns_in                 (ras_timer_ns_in[(2*(RAS_TIMER_WIDTH*nBANK_MACHS))-1:0]),
       .rb_hit_busies_r                 (rb_hit_busies_r[(nBANK_MACHS*2)-1:0]),
       .idle_r                          (idle_r),
       .passing_open_bank               (passing_open_bank),
       .low_idle_cnt_r                  (low_idle_cnt_r),
       .op_exit_grant                   (op_exit_grant),
       .tail_r                          (tail_r),
       .auto_pre_r                      (auto_pre_r),
       .pass_open_bank_ns               (pass_open_bank_ns),
       .phy_mc_cmd_full                 (phy_mc_cmd_full),
       .phy_mc_ctl_full                 (phy_mc_ctl_full),
       .phy_mc_data_full                (phy_mc_data_full),
       .rnk_config                      (rnk_config[RANK_WIDTH-1:0]),
       .rnk_config_strobe               (rnk_config_strobe),
       .rnk_config_kill_rts_col         (rnk_config_kill_rts_col),
       .rnk_config_valid_r              (rnk_config_valid_r),
       .rtc                             (rtc),
       .req_rank_r                      (req_rank_r[RANK_WIDTH-1:0]),
       .req_rank_r_in                   (req_rank_r_in[(RANK_WIDTH*nBANK_MACHS*2)-1:0]),
       .start_rcd_in                    (start_rcd_in[(nBANK_MACHS*2)-1:0]),
       .inhbt_act_faw_r                 (inhbt_act_faw_r[RANKS-1:0]),
       .wait_for_maint_r                (wait_for_maint_r),
       .head_r                          (head_r),
       .sent_row                        (sent_row),
       .demand_act_priority_in          (demand_act_priority_in[(nBANK_MACHS*2)-1:0]),
       .order_q_zero                    (order_q_zero),
       .sent_col                        (sent_col),
       .q_has_rd                        (q_has_rd),
       .q_has_priority                  (q_has_priority),
       .req_priority_r                  (req_priority_r),
       .idle_ns                         (idle_ns),
       .demand_priority_in              (demand_priority_in[(nBANK_MACHS*2)-1:0]),
       .inhbt_rd                        (inhbt_rd[RANKS-1:0]),
       .inhbt_wr                        (inhbt_wr[RANKS-1:0]),
       .dq_busy_data                    (dq_busy_data));

  mig_7series_v4_2_bank_queue #
    (/*AUTOINSTPARAM*/
     // Parameters
     .TCQ                               (TCQ),
     .BM_CNT_WIDTH                      (BM_CNT_WIDTH),
     .nBANK_MACHS                       (nBANK_MACHS),
     .ORDERING                          (ORDERING),
     .ID                                (ID))
    bank_queue0
      (/*AUTOINST*/
       // Outputs
       .head_r                          (head_r),
       .tail_r                          (tail_r),
       .idle_ns                         (idle_ns),
       .idle_r                          (idle_r),
       .pass_open_bank_ns               (pass_open_bank_ns),
       .pass_open_bank_r                (pass_open_bank_r),
       .auto_pre_r                      (auto_pre_r),
       .bm_end                          (bm_end),
       .passing_open_bank               (passing_open_bank),
       .ordered_issued                  (ordered_issued),
       .ordered_r                       (ordered_r),
       .order_q_zero                    (order_q_zero),
       .rcv_open_bank                   (rcv_open_bank),
       .rb_hit_busies_r                 (rb_hit_busies_r[nBANK_MACHS*2-1:0]),
       .q_has_rd                        (q_has_rd),
       .q_has_priority                  (q_has_priority),
       .wait_for_maint_r                (wait_for_maint_r),
       // Inputs
       .clk                             (clk),
       .rst                             (rst),
       .accept_internal_r               (accept_internal_r),
       .use_addr                        (use_addr),
       .periodic_rd_ack_r               (periodic_rd_ack_r),
       .bm_end_in                       (bm_end_in[(nBANK_MACHS*2)-1:0]),
       .idle_cnt                        (idle_cnt[BM_CNT_WIDTH-1:0]),
       .rb_hit_busy_cnt                 (rb_hit_busy_cnt[BM_CNT_WIDTH-1:0]),
       .accept_req                      (accept_req),
       .rb_hit_busy_r                   (rb_hit_busy_r),
       .maint_idle                      (maint_idle),
       .maint_hit                       (maint_hit),
       .row_hit_r                       (row_hit_r),
       .pre_wait_r                      (pre_wait_r),
       .allow_auto_pre                  (allow_auto_pre),
       .sending_col                     (sending_col),
       .req_wr_r                        (req_wr_r),
       .rd_wr_r                         (rd_wr_r),
       .bank_wait_in_progress           (bank_wait_in_progress),
       .precharge_bm_end                (precharge_bm_end),
       .adv_order_q                     (adv_order_q),
       .order_cnt                       (order_cnt[BM_CNT_WIDTH-1:0]),
       .rb_hit_busy_ns_in               (rb_hit_busy_ns_in[(nBANK_MACHS*2)-1:0]),
       .passing_open_bank_in            (passing_open_bank_in[(nBANK_MACHS*2)-1:0]),
       .was_wr                          (was_wr),
       .maint_req_r                     (maint_req_r),
       .was_priority                    (was_priority));

endmodule // bank_cntrl

