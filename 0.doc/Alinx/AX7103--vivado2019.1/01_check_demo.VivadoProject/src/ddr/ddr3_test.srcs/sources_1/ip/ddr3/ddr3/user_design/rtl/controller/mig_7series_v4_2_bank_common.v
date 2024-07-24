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
//  /   /         Filename              : bank_common.v
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

// Common block for the bank machines.  Bank_common computes various
// items that cross all of the bank machines.  These values are then
// fed back to all of the bank machines.  Most of these values have
// to do with a row machine figuring out where it belongs in a queue.

`timescale 1 ps / 1 ps

module mig_7series_v4_2_bank_common #
  (
   parameter TCQ = 100,
   parameter BM_CNT_WIDTH             = 2,
   parameter LOW_IDLE_CNT             = 1,
   parameter nBANK_MACHS              = 4,
   parameter nCK_PER_CLK              = 2,
   parameter nOP_WAIT                 = 0,
   parameter nRFC                     = 44,
   parameter nXSDLL                   = 512,
   parameter RANK_WIDTH               = 2,
   parameter RANKS                    = 4,
   parameter CWL                      = 5,
   parameter tZQCS                    = 64
  )
  (/*AUTOARG*/
  // Outputs
  accept_internal_r, accept_ns, accept, periodic_rd_insert,
  periodic_rd_ack_r, accept_req, rb_hit_busy_cnt, idle, idle_cnt, order_cnt,
  adv_order_q, bank_mach_next, op_exit_grant, low_idle_cnt_r, was_wr,
  was_priority, maint_wip_r, maint_idle, insert_maint_r,
  // Inputs
  clk, rst, idle_ns, init_calib_complete, periodic_rd_r, use_addr,
  rb_hit_busy_r, idle_r, ordered_r, ordered_issued, head_r, end_rtp,
  passing_open_bank, op_exit_req, start_pre_wait, cmd, hi_priority, maint_req_r,
  maint_zq_r, maint_sre_r, maint_srx_r, maint_hit, bm_end,
  slot_0_present, slot_1_present
  );

  function integer clogb2 (input integer size); // ceiling logb2
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
            size = size >> 1;
    end
  endfunction // clogb2

  localparam ZERO = 0;
  localparam ONE = 1;
  localparam [BM_CNT_WIDTH-1:0] BM_CNT_ZERO = ZERO[0+:BM_CNT_WIDTH];
  localparam [BM_CNT_WIDTH-1:0] BM_CNT_ONE = ONE[0+:BM_CNT_WIDTH];

  input clk;
  input rst;

  input [nBANK_MACHS-1:0] idle_ns;
  input init_calib_complete;
  wire accept_internal_ns = init_calib_complete && |idle_ns;
  output reg accept_internal_r;
  always @(posedge clk) accept_internal_r <= accept_internal_ns;
  wire periodic_rd_ack_ns;
  wire accept_ns_lcl = accept_internal_ns && ~periodic_rd_ack_ns;
  output wire accept_ns;
  assign accept_ns = accept_ns_lcl;
  reg accept_r;
  always @(posedge clk) accept_r <= #TCQ accept_ns_lcl;

// Wire to user interface informing user that the request has been accepted.
  output wire accept;
  assign accept = accept_r;

`ifdef MC_SVA
  property none_idle;
    @(posedge clk) (init_calib_complete && ~|idle_r);
  endproperty

  all_bank_machines_busy: cover property (none_idle);
`endif

// periodic_rd_insert tells everyone to mux in the periodic read.
  input periodic_rd_r;
  reg periodic_rd_ack_r_lcl;
  reg periodic_rd_cntr_r ;
  always @(posedge clk) begin
    if (rst) periodic_rd_cntr_r <= #TCQ 1'b0;
    else if (periodic_rd_r && periodic_rd_ack_r_lcl)
       periodic_rd_cntr_r <= #TCQ ~periodic_rd_cntr_r;
  end

  wire internal_periodic_rd_ack_r_lcl = (periodic_rd_cntr_r && periodic_rd_ack_r_lcl);

  // wire periodic_rd_insert_lcl = periodic_rd_r && ~periodic_rd_ack_r_lcl;
  wire periodic_rd_insert_lcl = periodic_rd_r && ~internal_periodic_rd_ack_r_lcl;
  output wire periodic_rd_insert;
  assign periodic_rd_insert = periodic_rd_insert_lcl;

// periodic_rd_ack_r acknowledges that the read has been accepted
// into the queue.
  assign periodic_rd_ack_ns = periodic_rd_insert_lcl && accept_internal_ns;
  always @(posedge clk) periodic_rd_ack_r_lcl <= #TCQ periodic_rd_ack_ns;
  output wire periodic_rd_ack_r;
  assign periodic_rd_ack_r = periodic_rd_ack_r_lcl;

// accept_req tells all q entries that a request has been accepted.
  input use_addr;
  wire accept_req_lcl = periodic_rd_ack_r_lcl || (accept_r && use_addr);
  output wire accept_req;
  assign accept_req = accept_req_lcl;

// Count how many non idle bank machines hit on the rank and bank.
  input [nBANK_MACHS-1:0] rb_hit_busy_r;
  output reg [BM_CNT_WIDTH-1:0] rb_hit_busy_cnt;
  integer i;
  always @(/*AS*/rb_hit_busy_r) begin
    rb_hit_busy_cnt = BM_CNT_ZERO;
    for (i = 0; i < nBANK_MACHS; i = i + 1)
      if (rb_hit_busy_r[i]) rb_hit_busy_cnt = rb_hit_busy_cnt + BM_CNT_ONE;
  end

// Count the number of idle bank machines.
  input [nBANK_MACHS-1:0] idle_r;
  output reg [BM_CNT_WIDTH-1:0] idle_cnt;
  always @(/*AS*/idle_r) begin
    idle_cnt = BM_CNT_ZERO;
    for (i = 0; i < nBANK_MACHS; i = i + 1)
      if (idle_r[i]) idle_cnt = idle_cnt + BM_CNT_ONE;
  end

// Report an overall idle status
  output idle;
  assign idle = init_calib_complete && &idle_r;
  
// Count the number of bank machines in the ordering queue.
  input [nBANK_MACHS-1:0] ordered_r;
  output reg [BM_CNT_WIDTH-1:0] order_cnt;
  always @(/*AS*/ordered_r) begin
    order_cnt = BM_CNT_ZERO;
    for (i = 0; i < nBANK_MACHS; i = i + 1)
      if (ordered_r[i]) order_cnt = order_cnt + BM_CNT_ONE;
  end

  input [nBANK_MACHS-1:0] ordered_issued;
  output wire adv_order_q;
  assign adv_order_q = |ordered_issued;

// Figure out which bank machine is going to accept the next request.
  input [nBANK_MACHS-1:0] head_r;
  wire [nBANK_MACHS-1:0] next = idle_r & head_r;
  output reg[BM_CNT_WIDTH-1:0] bank_mach_next;
  always @(/*AS*/next) begin
     bank_mach_next = BM_CNT_ZERO;
    for (i = 0; i <= nBANK_MACHS-1; i = i + 1)
      if (next[i]) bank_mach_next = i[BM_CNT_WIDTH-1:0];
  end

  input [nBANK_MACHS-1:0] end_rtp;
  input [nBANK_MACHS-1:0] passing_open_bank;
  input [nBANK_MACHS-1:0] op_exit_req;
  output wire [nBANK_MACHS-1:0] op_exit_grant;
  output reg low_idle_cnt_r = 1'b0;
  input [nBANK_MACHS-1:0] start_pre_wait;

  generate
// In support of open page mode, the following logic
// keeps track of how many "idle" bank machines there
// are.  In this case, idle means a bank machine is on
// the idle list, or is in the process of precharging and
// will soon be idle.
    if (nOP_WAIT == 0) begin : op_mode_disabled
      assign op_exit_grant = {nBANK_MACHS{1'b0}};
    end

    else begin : op_mode_enabled
      reg [BM_CNT_WIDTH:0] idle_cnt_r;
      reg [BM_CNT_WIDTH:0] idle_cnt_ns;
      always @(/*AS*/accept_req_lcl or idle_cnt_r or passing_open_bank
               or rst or start_pre_wait)
        if (rst) idle_cnt_ns = nBANK_MACHS;
        else begin
          idle_cnt_ns = idle_cnt_r - accept_req_lcl;
          for (i = 0; i <= nBANK_MACHS-1; i = i + 1) begin
            idle_cnt_ns = idle_cnt_ns + passing_open_bank[i];
          end
          idle_cnt_ns = idle_cnt_ns + |start_pre_wait;
        end
      always @(posedge clk) idle_cnt_r <= #TCQ idle_cnt_ns;
      wire low_idle_cnt_ns = (idle_cnt_ns <= LOW_IDLE_CNT[0+:BM_CNT_WIDTH]);
      always @(posedge clk) low_idle_cnt_r <= #TCQ low_idle_cnt_ns;

// This arbiter determines which bank machine should transition
// from open page wait to precharge.  Ideally, this process
// would take the oldest waiter, but don't have any reasonable
// way to implement that.  Instead, just use simple round robin
// arb with the small enhancement that the most recent bank machine
// to enter open page wait is given lowest priority in the arbiter.

  wire upd_last_master = |end_rtp;  // should be one bit set at most
  mig_7series_v4_2_round_robin_arb #
    (.WIDTH                             (nBANK_MACHS))
    op_arb0
    (.grant_ns                          (op_exit_grant[nBANK_MACHS-1:0]),
     .grant_r                           (),
     .upd_last_master                   (upd_last_master),
     .current_master                    (end_rtp[nBANK_MACHS-1:0]),
     .clk                               (clk),
     .rst                               (rst),
     .req                               (op_exit_req[nBANK_MACHS-1:0]),
     .disable_grant                     (1'b0));

    end
  endgenerate

// Register some command information.  This information will be used
// by the bank machines to figure out if there is something behind it
// in the queue that require hi priority.

  input [2:0] cmd;
  output reg was_wr;
  always @(posedge clk) was_wr <= #TCQ
             cmd[0] && ~(periodic_rd_r && ~periodic_rd_ack_r_lcl);

  input hi_priority;
  output reg was_priority;
  always @(posedge clk) begin
     if (hi_priority)
        was_priority <= #TCQ 1'b1;
     else
        was_priority <= #TCQ 1'b0;
  end


// DRAM maintenance (refresh and ZQ) and self-refresh controller

  input maint_req_r;
  reg maint_wip_r_lcl;
  output wire maint_wip_r;
  assign maint_wip_r = maint_wip_r_lcl;
  wire maint_idle_lcl;
  output wire maint_idle;
  assign maint_idle = maint_idle_lcl;
  input maint_zq_r;
  input maint_sre_r;
  input maint_srx_r;
  input [nBANK_MACHS-1:0] maint_hit;
  input [nBANK_MACHS-1:0] bm_end;
  wire start_maint;
  wire maint_end;

  generate begin : maint_controller

// Idle when not (maintenance work in progress (wip), OR maintenance
// starting tick).
      assign maint_idle_lcl = ~(maint_req_r && ~periodic_rd_cntr_r) && ~maint_wip_r_lcl;

// Maintenance work in progress starts with maint_reg_r tick, terminated
// with maint_end tick.  maint_end tick is generated by the RFC/ZQ/XSDLL timer
// below.
      wire maint_wip_ns =
            ~rst && ~maint_end && (maint_wip_r_lcl || (maint_req_r && ~periodic_rd_cntr_r));
      always @(posedge clk) maint_wip_r_lcl <= #TCQ maint_wip_ns;

// Keep track of which bank machines hit on the maintenance request
// when the request is made.  As bank machines complete, an assertion
// of the bm_end signal clears the correspoding bit in the
// maint_hit_busies_r vector.   Eventually, all bits should clear and
// the maintenance operation will proceed.  ZQ and self-refresh hit on all
// non idle banks.  Refresh hits only on non idle banks with the same rank as
// the refresh request.
      wire [nBANK_MACHS-1:0] clear_vector = {nBANK_MACHS{rst}} | bm_end;
      wire [nBANK_MACHS-1:0] maint_zq_hits = {nBANK_MACHS{maint_idle_lcl}} &
                            (maint_hit | {nBANK_MACHS{maint_zq_r}}) & ~idle_ns;
      wire [nBANK_MACHS-1:0] maint_sre_hits = {nBANK_MACHS{maint_idle_lcl}} &
                            (maint_hit | {nBANK_MACHS{maint_sre_r}}) & ~idle_ns;
      reg [nBANK_MACHS-1:0] maint_hit_busies_r;
      wire [nBANK_MACHS-1:0] maint_hit_busies_ns =
                       ~clear_vector & (maint_hit_busies_r | maint_zq_hits | maint_sre_hits);
      always @(posedge clk) maint_hit_busies_r <= #TCQ maint_hit_busies_ns;

// Queue is clear of requests conflicting with maintenance.
      wire maint_clear = ~maint_idle_lcl && ~|maint_hit_busies_ns;

// Ready to start sending maintenance commands.
    wire maint_rdy = maint_clear;
    reg maint_rdy_r1;
    reg maint_srx_r1;
    always @(posedge clk) maint_rdy_r1 <= #TCQ maint_rdy;
    always @(posedge clk) maint_srx_r1 <= #TCQ maint_srx_r;
    assign start_maint = maint_rdy && ~maint_rdy_r1 || maint_srx_r && ~maint_srx_r1;

    end // block: maint_controller
  endgenerate


// Figure out how many maintenance commands to send, and send them.
  input [7:0] slot_0_present;
  input [7:0] slot_1_present;
  reg insert_maint_r_lcl;
  output wire insert_maint_r;
  assign insert_maint_r = insert_maint_r_lcl;

  generate begin : generate_maint_cmds

// Count up how many slots are occupied.  This tells
// us how many ZQ, SRE or SRX commands to send out.
      reg [RANK_WIDTH:0] present_count;
      wire [7:0] present = slot_0_present | slot_1_present;
      always @(/*AS*/present) begin
        present_count = {RANK_WIDTH{1'b0}};
        for (i=0; i<8; i=i+1)
          present_count = present_count + {{RANK_WIDTH{1'b0}}, present[i]};
      end

// For refresh, there is only a single command sent.  For
// ZQ, SRE and SRX, each rank present will receive a command.  The counter
// below counts down the number of ranks present.
      reg [RANK_WIDTH:0] send_cnt_ns;
      reg [RANK_WIDTH:0] send_cnt_r;
      always @(/*AS*/maint_zq_r or maint_sre_r or maint_srx_r or present_count
          or rst or send_cnt_r or start_maint)
        if (rst) send_cnt_ns = 4'b0;
        else begin
          send_cnt_ns = send_cnt_r;
          if (start_maint && (maint_zq_r || maint_sre_r || maint_srx_r)) send_cnt_ns = present_count;
          if (|send_cnt_ns)
            send_cnt_ns = send_cnt_ns - ONE[RANK_WIDTH-1:0];
        end
      always @(posedge clk) send_cnt_r <= #TCQ send_cnt_ns;

// Insert a maintenance command for start_maint, or when the sent count
// is not zero.
      wire insert_maint_ns = start_maint || |send_cnt_r;

      always @(posedge clk) insert_maint_r_lcl <= #TCQ insert_maint_ns;
    end // block: generate_maint_cmds
  endgenerate


// RFC ZQ XSDLL timer.  Generates delay from refresh, self-refresh exit or ZQ
// command until the end of the maintenance operation.

// Compute values for RFC, ZQ and XSDLL periods.
  localparam nRFC_CLKS =  (nCK_PER_CLK == 1) ?
                            nRFC :
                          (nCK_PER_CLK == 2) ?
                            ((nRFC/2) + (nRFC%2)) :
                      //  (nCK_PER_CLK == 4)
                            ((nRFC/4) + ((nRFC%4) ? 1 : 0));

  localparam nZQCS_CLKS = (nCK_PER_CLK == 1) ?
                            tZQCS :
                          (nCK_PER_CLK == 2) ?
                            ((tZQCS/2) + (tZQCS%2)) :
                      //  (nCK_PER_CLK == 4)
                            ((tZQCS/4) + ((tZQCS%4) ? 1 : 0));
                            
  localparam nXSDLL_CLKS =  (nCK_PER_CLK == 1) ?
                              nXSDLL :
                            (nCK_PER_CLK == 2) ?
                              ((nXSDLL/2) + (nXSDLL%2)) :
                        //  (nCK_PER_CLK == 4)
                              ((nXSDLL/4) + ((nXSDLL%4) ? 1 : 0));

  localparam RFC_ZQ_TIMER_WIDTH = clogb2(nXSDLL_CLKS + 1);

  localparam THREE = 3;

  generate begin : rfc_zq_xsdll_timer

      reg [RFC_ZQ_TIMER_WIDTH-1:0] rfc_zq_xsdll_timer_ns;
      reg [RFC_ZQ_TIMER_WIDTH-1:0] rfc_zq_xsdll_timer_r;

      always @(/*AS*/insert_maint_r_lcl or maint_zq_r or maint_sre_r or maint_srx_r
               or rfc_zq_xsdll_timer_r or rst) begin
        rfc_zq_xsdll_timer_ns = rfc_zq_xsdll_timer_r;
        if (rst) rfc_zq_xsdll_timer_ns = {RFC_ZQ_TIMER_WIDTH{1'b0}};
        else if (insert_maint_r_lcl) rfc_zq_xsdll_timer_ns =  maint_zq_r ?
                                                                nZQCS_CLKS :
                                                              maint_sre_r ?
                                                                {RFC_ZQ_TIMER_WIDTH{1'b0}} :
                                                              maint_srx_r ?
                                                                nXSDLL_CLKS :
                                                                nRFC_CLKS;
        else if (|rfc_zq_xsdll_timer_r) rfc_zq_xsdll_timer_ns =
                                  rfc_zq_xsdll_timer_r - ONE[RFC_ZQ_TIMER_WIDTH-1:0];
      end
      always @(posedge clk) rfc_zq_xsdll_timer_r <= #TCQ rfc_zq_xsdll_timer_ns;

// Based on rfc_zq_xsdll_timer_r, figure out when to release any bank
// machines waiting to send an activate.  Need to add two to the end count.
// One because the counter starts a state after the insert_refresh_r, and
// one more because bm_end to insert_refresh_r is one state shorter
// than bm_end to rts_row.
      assign maint_end = (rfc_zq_xsdll_timer_r == THREE[RFC_ZQ_TIMER_WIDTH-1:0]);
    end // block: rfc_zq_xsdll_timer
  endgenerate


endmodule // bank_common

