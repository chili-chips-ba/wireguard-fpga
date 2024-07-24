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
//  /   /         Filename              : rank_common.v
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

// Block for logic common to all rank machines. Contains
// a clock prescaler, and arbiters for refresh and periodic
// read functions.

`timescale 1 ps / 1 ps

module mig_7series_v4_2_rank_common #
  (
   parameter TCQ = 100,
   parameter DRAM_TYPE                = "DDR3",
   parameter MAINT_PRESCALER_DIV      = 40,
   parameter nBANK_MACHS              = 4,
   parameter nCKESR                   = 4,
   parameter nCK_PER_CLK              = 2,
   parameter PERIODIC_RD_TIMER_DIV    = 20,
   parameter RANK_WIDTH               = 2,
   parameter RANKS                    = 4,
   parameter REFRESH_TIMER_DIV        = 39,
   parameter ZQ_TIMER_DIV             = 640000
  )
  (/*AUTOARG*/
  // Outputs
  maint_prescaler_tick_r, refresh_tick, maint_zq_r, maint_sre_r, maint_srx_r,
  maint_req_r, maint_rank_r, clear_periodic_rd_request, periodic_rd_r,
  periodic_rd_rank_r, app_ref_ack, app_zq_ack, app_sr_active, maint_ref_zq_wip,
  // Inputs
  clk, rst, init_calib_complete, app_ref_req, app_zq_req, app_sr_req,
  insert_maint_r1, refresh_request, maint_wip_r, slot_0_present, slot_1_present,
  periodic_rd_request, periodic_rd_ack_r
  );

  function integer clogb2 (input integer size); // ceiling logb2
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
            size = size >> 1;
    end
  endfunction // clogb2

  input clk;
  input rst;

// Maintenance and periodic read prescaler.  Nominally 200 nS.
  localparam ONE = 1;
  localparam MAINT_PRESCALER_WIDTH = clogb2(MAINT_PRESCALER_DIV + 1);
  input init_calib_complete;
  reg maint_prescaler_tick_r_lcl;
  generate
    begin : maint_prescaler
      reg [MAINT_PRESCALER_WIDTH-1:0] maint_prescaler_r;
      reg [MAINT_PRESCALER_WIDTH-1:0] maint_prescaler_ns;
      wire maint_prescaler_tick_ns =
             (maint_prescaler_r == ONE[MAINT_PRESCALER_WIDTH-1:0]);
      always @(/*AS*/init_calib_complete or maint_prescaler_r
               or maint_prescaler_tick_ns) begin
        maint_prescaler_ns = maint_prescaler_r;
        if (~init_calib_complete || maint_prescaler_tick_ns)
           maint_prescaler_ns = MAINT_PRESCALER_DIV[MAINT_PRESCALER_WIDTH-1:0];
        else if (|maint_prescaler_r)
       maint_prescaler_ns = maint_prescaler_r - ONE[MAINT_PRESCALER_WIDTH-1:0];
      end
      always @(posedge clk) maint_prescaler_r <= #TCQ maint_prescaler_ns;

      always @(posedge clk) maint_prescaler_tick_r_lcl <=
                             #TCQ maint_prescaler_tick_ns;
    end
  endgenerate
  output wire maint_prescaler_tick_r;
  assign maint_prescaler_tick_r = maint_prescaler_tick_r_lcl;

// Refresh timebase.  Nominically 7800 nS.
  localparam REFRESH_TIMER_WIDTH = clogb2(REFRESH_TIMER_DIV + /*idle*/ 1);
  wire refresh_tick_lcl;
  generate
    begin : refresh_timer
      reg [REFRESH_TIMER_WIDTH-1:0] refresh_timer_r;
      reg [REFRESH_TIMER_WIDTH-1:0] refresh_timer_ns;
      always @(/*AS*/init_calib_complete or maint_prescaler_tick_r_lcl
               or refresh_tick_lcl or refresh_timer_r) begin
        refresh_timer_ns = refresh_timer_r;
        if (~init_calib_complete || refresh_tick_lcl)
              refresh_timer_ns = REFRESH_TIMER_DIV[REFRESH_TIMER_WIDTH-1:0];
        else if (|refresh_timer_r && maint_prescaler_tick_r_lcl)
                 refresh_timer_ns =
                   refresh_timer_r - ONE[REFRESH_TIMER_WIDTH-1:0];
      end
      always @(posedge clk) refresh_timer_r <= #TCQ refresh_timer_ns;
      assign refresh_tick_lcl = (refresh_timer_r ==
                  ONE[REFRESH_TIMER_WIDTH-1:0]) && maint_prescaler_tick_r_lcl;
    end
  endgenerate
  output wire refresh_tick;
  assign refresh_tick = refresh_tick_lcl;

// ZQ timebase.  Nominally 128 mS
  localparam ZQ_TIMER_WIDTH = clogb2(ZQ_TIMER_DIV + 1);
  input app_zq_req;
  input insert_maint_r1;
  reg maint_zq_r_lcl;
  reg zq_request = 1'b0;
  generate
    if (DRAM_TYPE == "DDR3") begin : zq_cntrl
      reg zq_tick = 1'b0;
      if (ZQ_TIMER_DIV !=0) begin : zq_timer
        reg [ZQ_TIMER_WIDTH-1:0] zq_timer_r;
        reg [ZQ_TIMER_WIDTH-1:0] zq_timer_ns;
        always @(/*AS*/init_calib_complete or maint_prescaler_tick_r_lcl
                 or zq_tick or zq_timer_r) begin
          zq_timer_ns = zq_timer_r;
          if (~init_calib_complete || zq_tick)
                zq_timer_ns = ZQ_TIMER_DIV[ZQ_TIMER_WIDTH-1:0];
          else if (|zq_timer_r && maint_prescaler_tick_r_lcl)
                   zq_timer_ns = zq_timer_r - ONE[ZQ_TIMER_WIDTH-1:0];
        end
        always @(posedge clk) zq_timer_r <= #TCQ zq_timer_ns;
        always @(/*AS*/maint_prescaler_tick_r_lcl or zq_timer_r)
                  zq_tick = (zq_timer_r ==
                       ONE[ZQ_TIMER_WIDTH-1:0] && maint_prescaler_tick_r_lcl);
      end // zq_timer

// ZQ request. Set request with timer tick, and when exiting PHY init.  Never
// request if ZQ_TIMER_DIV == 0.
      begin : zq_request_logic
        wire zq_clears_zq_request = insert_maint_r1 && maint_zq_r_lcl;
        reg zq_request_r;
        wire zq_request_ns = ~rst && (DRAM_TYPE == "DDR3") &&
                           ((~init_calib_complete && (ZQ_TIMER_DIV != 0)) ||
                            (zq_request_r && ~zq_clears_zq_request) ||
                            zq_tick ||
                            (app_zq_req && init_calib_complete));
        always @(posedge clk) zq_request_r <= #TCQ zq_request_ns;
        always @(/*AS*/init_calib_complete or zq_request_r)
                  zq_request = init_calib_complete && zq_request_r;
      end // zq_request_logic
    end
  endgenerate

  // Self-refresh control
  localparam nCKESR_CLKS = (nCKESR / nCK_PER_CLK) + (nCKESR % nCK_PER_CLK ? 1 : 0);
  localparam CKESR_TIMER_WIDTH = clogb2(nCKESR_CLKS + 1);
  input app_sr_req;
  reg maint_sre_r_lcl;
  reg maint_srx_r_lcl;
  reg sre_request = 1'b0;
  wire inhbt_srx;
  
  generate begin : sr_cntrl
      
      // SRE request. Set request with user request.
      begin : sre_request_logic

        reg sre_request_r;
        wire sre_clears_sre_request = insert_maint_r1 && maint_sre_r_lcl;

        wire sre_request_ns = ~rst && ((sre_request_r && ~sre_clears_sre_request)
                              || (app_sr_req && init_calib_complete && ~maint_sre_r_lcl));
        
        always @(posedge clk) sre_request_r <= #TCQ sre_request_ns;
        
        always @(init_calib_complete or sre_request_r)
          sre_request = init_calib_complete && sre_request_r;
      
      end // sre_request_logic
      
      // CKESR timer: Self-Refresh must be maintained for a minimum of tCKESR
      begin : ckesr_timer
        
        reg [CKESR_TIMER_WIDTH-1:0] ckesr_timer_r = {CKESR_TIMER_WIDTH{1'b0}};
        reg [CKESR_TIMER_WIDTH-1:0] ckesr_timer_ns = {CKESR_TIMER_WIDTH{1'b0}};
        
        always @(insert_maint_r1 or ckesr_timer_r or maint_sre_r_lcl) begin
        
          ckesr_timer_ns = ckesr_timer_r;

          if (insert_maint_r1 && maint_sre_r_lcl)
            ckesr_timer_ns = nCKESR_CLKS[CKESR_TIMER_WIDTH-1:0];
          else if(|ckesr_timer_r)
            ckesr_timer_ns = ckesr_timer_r - ONE[CKESR_TIMER_WIDTH-1:0];
        
        end
        
        always @(posedge clk) ckesr_timer_r <= #TCQ ckesr_timer_ns;
        
        assign inhbt_srx = |ckesr_timer_r;
      
      end // ckesr_timer

    end

  endgenerate
  
// DRAM maintenance operations of refresh and ZQ calibration, and self-refresh
// DRAM maintenance operations and self-refresh have their own channel in the
// queue.  There is also a single, very simple bank machine
// dedicated to these operations.  Its assumed that the
// maintenance operations can be completed quickly enough
// to avoid any queuing.
//
// ZQ, refresh and self-refresh requests share a channel into controller.
// Self-refresh is appended to the uppermost bit of the request bus and ZQ is
// appended just below that.

  input[RANKS-1:0] refresh_request;
  input maint_wip_r;
  reg maint_req_r_lcl;
  reg [RANK_WIDTH-1:0] maint_rank_r_lcl;
  input [7:0] slot_0_present;
  input [7:0] slot_1_present;

  generate
    begin : maintenance_request

// Maintenance request pipeline.
      reg upd_last_master_r;
      reg new_maint_rank_r;
      wire maint_busy = upd_last_master_r || new_maint_rank_r ||
                        maint_req_r_lcl || maint_wip_r;
      wire [RANKS+1:0] maint_request = {sre_request, zq_request, refresh_request[RANKS-1:0]};
      //wire upd_last_master_ns = |maint_request && ~maint_busy;
      wire upd_last_master_ns = |maint_request && ~maint_wip_r;
      always @(posedge clk) upd_last_master_r <= #TCQ upd_last_master_ns;
      always @(posedge clk) new_maint_rank_r <= #TCQ upd_last_master_r;
      always @(posedge clk) maint_req_r_lcl <= #TCQ new_maint_rank_r;
      wire upd_last_master_pls = upd_last_master_r & (~new_maint_rank_r);

// Arbitrate maintenance requests.
      wire [RANKS+1:0] maint_grant_ns;
      wire [RANKS+1:0] maint_grant_r;
      mig_7series_v4_2_round_robin_arb #
     (.WIDTH                            (RANKS+2))
      maint_arb0
      (.grant_ns                        (maint_grant_ns),
       .grant_r                         (maint_grant_r),
       .upd_last_master                 (upd_last_master_pls),
       .current_master                  (maint_grant_r),
       .req                             (maint_request),
       .disable_grant                   (1'b0),
       /*AUTOINST*/
       // Inputs
       .clk                             (clk),
       .rst                             (rst));

// Look at arbitration results.  Decide if ZQ, refresh or self-refresh.
// If refresh select the maintenance rank from the winning rank controller.
// If ZQ or self-refresh, generate a sequence of rank numbers corresponding to
// slots populated maint_rank_r is not used for comparisons in the queue for ZQ
// or self-refresh requests. The bank machine will enable CS for the number of
// states equal to the the number of occupied slots.  This will produce a
// command to every occupied slot, but not in any particular order.
      wire [7:0] present = slot_0_present | slot_1_present;
      integer i;
      reg [RANK_WIDTH-1:0] maint_rank_ns;
      wire maint_zq_ns = ~rst && (upd_last_master_pls
                                    ? maint_grant_r[RANKS]
                                    : maint_zq_r_lcl);
      wire maint_srx_ns = ~rst && (maint_sre_r_lcl
                                    ? ~app_sr_req & ~inhbt_srx
                                    : maint_srx_r_lcl && upd_last_master_pls
                                    ? maint_grant_r[RANKS+1]
                                    : maint_srx_r_lcl);
      wire maint_sre_ns = ~rst && (upd_last_master_pls
                                    ? maint_grant_r[RANKS+1]
                                    : maint_sre_r_lcl && ~maint_srx_ns);
      always @(/*AS*/maint_grant_r or maint_rank_r_lcl or maint_zq_ns
               or maint_sre_ns or maint_srx_ns or present or rst
               or upd_last_master_pls) begin
        if (rst) maint_rank_ns = {RANK_WIDTH{1'b0}};
        else begin
          maint_rank_ns = maint_rank_r_lcl;
          if (maint_zq_ns || maint_sre_ns || maint_srx_ns) begin
            maint_rank_ns = maint_rank_r_lcl + ONE[RANK_WIDTH-1:0];
            for (i=0; i<8; i=i+1)
              if (~present[maint_rank_ns])
                     maint_rank_ns = maint_rank_ns + ONE[RANK_WIDTH-1:0];
          end
          else
            if (upd_last_master_pls)
              for (i=0; i<RANKS; i=i+1)
                if (maint_grant_r[i]) maint_rank_ns = i[RANK_WIDTH-1:0];
        end
      end
      always @(posedge clk) maint_rank_r_lcl <= #TCQ maint_rank_ns;
      always @(posedge clk) maint_zq_r_lcl <= #TCQ maint_zq_ns;
      always @(posedge clk) maint_sre_r_lcl <= #TCQ maint_sre_ns;
      always @(posedge clk) maint_srx_r_lcl <= #TCQ maint_srx_ns;

    end // block: maintenance_request
  endgenerate
  output wire maint_zq_r;
  assign maint_zq_r = maint_zq_r_lcl;
  output wire maint_sre_r;
  assign maint_sre_r = maint_sre_r_lcl;
  output wire maint_srx_r;
  assign maint_srx_r = maint_srx_r_lcl;
  output wire maint_req_r;
  assign maint_req_r = maint_req_r_lcl;
  output wire [RANK_WIDTH-1:0] maint_rank_r;
  assign maint_rank_r = maint_rank_r_lcl;

// Indicate whether self-refresh is active or not.

  output app_sr_active;
  reg app_sr_active_r;
  
  wire app_sr_active_ns =
    insert_maint_r1 ? maint_sre_r && ~maint_srx_r : app_sr_active_r;
  
  always @(posedge clk) app_sr_active_r <= #TCQ app_sr_active_ns;
  
  assign app_sr_active = app_sr_active_r;
  
// Acknowledge user REF and ZQ Requests

  input  app_ref_req;
  output app_ref_ack;
  wire app_ref_ack_ns;
  wire app_ref_ns;
  reg app_ref_ack_r = 1'b0;
  reg app_ref_r = 1'b0;

  assign app_ref_ns = init_calib_complete && (app_ref_req || app_ref_r && |refresh_request);
  assign app_ref_ack_ns = app_ref_r && ~|refresh_request;

  always @(posedge clk) app_ref_r <= #TCQ app_ref_ns;
  always @(posedge clk) app_ref_ack_r <= #TCQ app_ref_ack_ns;

  assign app_ref_ack = app_ref_ack_r;

  output app_zq_ack;
  wire app_zq_ack_ns;
  wire app_zq_ns;
  reg app_zq_ack_r = 1'b0;
  reg app_zq_r = 1'b0;
  
  assign app_zq_ns = init_calib_complete && (app_zq_req || app_zq_r && zq_request);
  assign app_zq_ack_ns = app_zq_r && ~zq_request;

  always @(posedge clk) app_zq_r <= #TCQ app_zq_ns;
  always @(posedge clk) app_zq_ack_r <= #TCQ app_zq_ack_ns;
  
  assign app_zq_ack = app_zq_ack_r;

// Periodic reads to maintain PHY alignment.
// Demand insertion of periodic read as soon as
// possible.  Since the is a single rank, bank compare mechanism
// must be used, periodic reads must be forced in at the
// expense of not accepting a normal request.

  input [RANKS-1:0] periodic_rd_request;
  reg periodic_rd_r_lcl;
  reg [RANK_WIDTH-1:0] periodic_rd_rank_r_lcl;
  input periodic_rd_ack_r;
  output wire [RANKS-1:0] clear_periodic_rd_request;
  output wire periodic_rd_r;
  output wire [RANK_WIDTH-1:0] periodic_rd_rank_r;

  generate
    // This is not needed in 7-Series and should remain disabled
    if ( PERIODIC_RD_TIMER_DIV != 0 ) begin : periodic_read_request

// Maintenance request pipeline.
      reg periodic_rd_r_cnt;
      wire int_periodic_rd_ack_r = (periodic_rd_ack_r && periodic_rd_r_cnt);
      reg upd_last_master_r;
      wire periodic_rd_busy = upd_last_master_r || periodic_rd_r_lcl;
      wire upd_last_master_ns =
             init_calib_complete && (|periodic_rd_request && ~periodic_rd_busy);
      always @(posedge clk) upd_last_master_r <= #TCQ upd_last_master_ns;
      wire periodic_rd_ns = init_calib_complete &&
             (upd_last_master_r || (periodic_rd_r_lcl && ~int_periodic_rd_ack_r));
      always @(posedge clk) periodic_rd_r_lcl <= #TCQ periodic_rd_ns;

      always @(posedge clk) begin
	if (rst) periodic_rd_r_cnt <= #TCQ 1'b0;
	else if (periodic_rd_r_lcl && periodic_rd_ack_r)
	   periodic_rd_r_cnt <= ~periodic_rd_r_cnt;
      end

// Arbitrate periodic read requests.
      wire [RANKS-1:0] periodic_rd_grant_ns;
      reg [RANKS-1:0] periodic_rd_grant_r;
      mig_7series_v4_2_round_robin_arb #
     (.WIDTH                            (RANKS))
      periodic_rd_arb0
      (.grant_ns                        (periodic_rd_grant_ns[RANKS-1:0]),
       .grant_r                         (),
       .upd_last_master                 (upd_last_master_r),
       .current_master                  (periodic_rd_grant_r[RANKS-1:0]),
       .req                             (periodic_rd_request[RANKS-1:0]),
       .disable_grant                   (1'b0),
       /*AUTOINST*/
       // Inputs
       .clk                             (clk),
       .rst                             (rst));

      always @(posedge clk) periodic_rd_grant_r = upd_last_master_ns
                                                   ? periodic_rd_grant_ns
                                                   : periodic_rd_grant_r;
// Encode and set periodic read rank into periodic_rd_rank_r.
      integer i;
      reg [RANK_WIDTH-1:0] periodic_rd_rank_ns;
      always @(/*AS*/periodic_rd_grant_r or periodic_rd_rank_r_lcl
               or upd_last_master_r) begin
        periodic_rd_rank_ns = periodic_rd_rank_r_lcl;
        if (upd_last_master_r)
          for (i=0; i<RANKS; i=i+1)
            if (periodic_rd_grant_r[i])
                  periodic_rd_rank_ns = i[RANK_WIDTH-1:0];
      end
      always @(posedge clk) periodic_rd_rank_r_lcl <=
                             #TCQ periodic_rd_rank_ns;

// Once the request is dropped in the queue, it might be a while before it
// emerges.  Can't clear the request based on seeing the read issued.
// Need to clear the request as soon as its made it into the queue.
      assign clear_periodic_rd_request =
               periodic_rd_grant_r & {RANKS{periodic_rd_ack_r}};

               
      assign periodic_rd_r = periodic_rd_r_lcl;
      assign periodic_rd_rank_r = periodic_rd_rank_r_lcl;
      
    end else begin
    
      // Disable periodic reads
      assign clear_periodic_rd_request = {RANKS{1'b0}};
      assign periodic_rd_r = 1'b0;
      assign periodic_rd_rank_r = {RANK_WIDTH{1'b0}};
    
    end // block: periodic_read_request
  endgenerate

// Indicate that a refresh is in progress. The PHY will use this to schedule
// tap adjustments during idle bus time

  reg maint_ref_zq_wip_r = 1'b0;
  output maint_ref_zq_wip;

  always @(posedge clk)
    if(rst)
      maint_ref_zq_wip_r <= #TCQ 1'b0;
    else if((zq_request || |refresh_request) && insert_maint_r1)
      maint_ref_zq_wip_r <= #TCQ 1'b1;
    else if(~maint_wip_r)
      maint_ref_zq_wip_r <= #TCQ 1'b0;

  assign maint_ref_zq_wip = maint_ref_zq_wip_r;

endmodule

