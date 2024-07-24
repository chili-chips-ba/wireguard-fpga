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
//  /   /         Filename              : rank_cntrl.v
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

//*****************************************************************************
// This block is responsible for managing various rank level timing
// parameters.  For now, only Four Activate Window (FAW) and Write
// To Read delay are implemented here.
//
// Each rank machine generates its own inhbt_act_faw_r and inhbt_rd.
// These per rank machines are driven into the bank machines.  Each
// bank machines selects the correct inhibits based on the rank
// of its current request.
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_rank_cntrl #
  (
    parameter TCQ                      = 100, // clk->out delay (sim only)
    parameter BURST_MODE               = "8", // Burst length
    parameter DQRD2DQWR_DLY            = 2,   // RD->WR DQ Bus Delay
    parameter CL                       = 5,   // Read CAS latency
    parameter CWL                      = 5,   // Write CAS latency
    parameter ID                       = 0,   // Unique ID for each instance
    parameter nBANK_MACHS              = 4,   // # bank machines in MC
    parameter nCK_PER_CLK              = 2,   // DRAM clock : MC clock
    parameter nFAW                     = 30,  // four activate window (CKs)
    parameter nREFRESH_BANK            = 8,   // # REF commands to pull-in
    parameter nRRD                     = 4,   // ACT->ACT period (CKs)
    parameter nWTR                     = 4,   // Internal write->read 
                                              // delay (CKs)
    parameter PERIODIC_RD_TIMER_DIV    = 20,  // Maintenance prescaler divisor
                                              // for periodic read timer
    parameter RANK_BM_BV_WIDTH         = 16,  // Width required to broadcast a
                                              // single bit rank signal among
                                              // all the bank machines
    parameter RANK_WIDTH               = 2,   // # of bits to count ranks
    parameter RANKS                    = 4,   // # of ranks of DRAM
    parameter REFRESH_TIMER_DIV        = 39   // Maintenance prescaler divivor
                                              // for refresh timer
  )
  (

    // Maintenance requests

    output                            periodic_rd_request,
    output  wire                      refresh_request,
    
    // Inhibit signals
    
    output  reg                       inhbt_act_faw_r,
    output  reg                       inhbt_rd,
    output  reg                       inhbt_wr,
    
    // System Inputs
    
    input                             clk,
    input                             rst,

    // User maintenance requests
    
    input                             app_periodic_rd_req,
    input                             app_ref_req,
    
    // Inputs
    
    input   [RANK_BM_BV_WIDTH-1:0]    act_this_rank_r,
    input                             clear_periodic_rd_request,
    input                             col_rd_wr,
    input                             init_calib_complete,
    input                             insert_maint_r1,
    input                             maint_prescaler_tick_r,
    input   [RANK_WIDTH-1:0]          maint_rank_r,
    input                             maint_zq_r,
    input                             maint_sre_r,
    input                             maint_srx_r,
    input   [(RANKS*nBANK_MACHS)-1:0] rank_busy_r,
    input                             refresh_tick,  
    input   [nBANK_MACHS-1:0]         sending_col,
    input   [nBANK_MACHS-1:0]         sending_row,
    input   [RANK_BM_BV_WIDTH-1:0]    rd_this_rank_r,
    input   [RANK_BM_BV_WIDTH-1:0]    wr_this_rank_r

  );

  //***************************************************************************
  // RRD configuration.  The bank machines have a mechanism to prevent RAS to
  // RAS on adjacent fabric CLK states to the same rank.  When
  // nCK_PER_CLK == 1, this translates to a minimum of 2 for nRRD, 4 for nRRD
  // when nCK_PER_CLK == 2 and 8 for nRRD when nCK_PER_CLK == 4. Some of the
  // higher clock rate DDR3 DRAMs have nRRD > 4.  The additional RRD inhibit
  // is worked into the inhbt_faw signal.
  //***************************************************************************

  localparam nADD_RRD = nRRD -
    (
      (nCK_PER_CLK == 1) ?  2 :
      (nCK_PER_CLK == 2) ?  4 :
    /*(nCK_PER_CLK == 4)*/  8
    );

  // divide by nCK_PER_CLK and add a cycle if there's a remainder
  localparam nRRD_CLKS = 
    (nCK_PER_CLK == 1) ?  nADD_RRD                    :
    (nCK_PER_CLK == 2) ?  ((nADD_RRD/2)+(nADD_RRD%2)) :
  /*(nCK_PER_CLK == 4)*/  ((nADD_RRD/4)+((nADD_RRD%4) ? 1 : 0));

  // take binary log to obtain counter width and add a tick for the idle cycle
  localparam ADD_RRD_CNTR_WIDTH = clogb2(nRRD_CLKS + /* idle state */ 1);

  //***************************************************************************
  // Internal signals
  //***************************************************************************
  reg                                 act_this_rank;
  integer                             i;  // loop invariant
  
  //***************************************************************************
  // Function clogb2
  //  Description:
  //    This function performs binary logarithm and rounds up
  //  Inputs:
  //    size: integer to perform binary log upon
  // Outputs:
  //    clogb2: result of binary logarithm, rounded up
  //***************************************************************************
  
  function integer clogb2 (input integer size);
    begin
    
    size = size - 1;

    // increment clogb2 from 1 for each bit in size
    for (clogb2 = 1; size > 1; clogb2 = clogb2 + 1)
      size = size >> 1;

    end
  endfunction // clogb2

  //***************************************************************************
  // Determine if this rank has been activated.  act_this_rank_r is a
  // registered bit vector from individual bank machines indicating the
  // corresponding bank machine is sending
  // an activate.  Timing is improved with this method.
  //***************************************************************************
  
  always @(/*AS*/act_this_rank_r or sending_row) begin
    
    act_this_rank = 1'b0;
    
    for (i = 0; i < nBANK_MACHS; i = i + 1)
      act_this_rank =
         act_this_rank || (sending_row[i] && act_this_rank_r[(i*RANKS)+ID]);
  
  end



  reg add_rrd_inhbt = 1'b0;
  generate
    if (nADD_RRD > 0 && ADD_RRD_CNTR_WIDTH > 1) begin :add_rdd1
      reg[ADD_RRD_CNTR_WIDTH-1:0] add_rrd_ns;
      reg[ADD_RRD_CNTR_WIDTH-1:0] add_rrd_r;
      always @(/*AS*/act_this_rank or add_rrd_r or rst) begin
        add_rrd_ns = add_rrd_r;
        if (rst) add_rrd_ns = {ADD_RRD_CNTR_WIDTH{1'b0}};
        else
          if (act_this_rank)
            add_rrd_ns = nRRD_CLKS[0+:ADD_RRD_CNTR_WIDTH];
          else if (|add_rrd_r) add_rrd_ns =
                            add_rrd_r - {{ADD_RRD_CNTR_WIDTH-1{1'b0}}, 1'b1};
      end
      always @(posedge clk) add_rrd_r <= #TCQ add_rrd_ns;
      always @(/*AS*/add_rrd_ns) add_rrd_inhbt = |add_rrd_ns;
    end // add_rdd1
    else if (nADD_RRD > 0) begin :add_rdd0
      reg[ADD_RRD_CNTR_WIDTH-1:0] add_rrd_ns;
      reg[ADD_RRD_CNTR_WIDTH-1:0] add_rrd_r;
      always @(/*AS*/act_this_rank or add_rrd_r or rst) begin
        add_rrd_ns = add_rrd_r;
        if (rst) add_rrd_ns = {ADD_RRD_CNTR_WIDTH{1'b0}};
        else
          if (act_this_rank)
            add_rrd_ns = nRRD_CLKS[0+:ADD_RRD_CNTR_WIDTH];
          else if (|add_rrd_r) add_rrd_ns =
                            add_rrd_r - {1'b1};
      end
      always @(posedge clk) add_rrd_r <= #TCQ add_rrd_ns;
      always @(/*AS*/add_rrd_ns) add_rrd_inhbt = |add_rrd_ns;
    end // add_rdd0
  endgenerate


// Compute inhbt_act_faw_r.  Only allow a limited number of activates
// in a window.  Both the number of activates and the window are
// configurable.  This depends on the RRD mechanism to prevent
// two consecutive activates to the same rank.
//
// Subtract three from the specified nFAW.  Subtract three because:
// -Zero for the delay into the SRL is really one state.
// -Sending_row is used to trigger the delay.  Sending_row is one
//  state delayed from the arb.
// -inhbt_act_faw_r is registered to make timing work, hence the
//  generation needs to be one state early.

  localparam nFAW_CLKS = (nCK_PER_CLK == 1)
                           ? nFAW
                           : (nCK_PER_CLK == 2) ? ((nFAW/2) + (nFAW%2)) : 
                           ((nFAW/4) + ((nFAW%4) ? 1 : 0));

  generate
    begin : inhbt_act_faw
      wire act_delayed;
      wire [4:0] shift_depth = nFAW_CLKS[4:0] - 5'd3;

      SRLC32E #(.INIT(32'h00000000) ) SRLC32E0
        (.Q(act_delayed), // SRL data output
         .Q31(), // SRL cascade output pin
         .A(shift_depth), // 5-bit shift depth select input
         .CE(1'b1), // Clock enable input
         .CLK(clk), // Clock input
         .D(act_this_rank) // SRL data input
        );

      reg [2:0] faw_cnt_ns;
      reg [2:0] faw_cnt_r;
      reg inhbt_act_faw_ns;
      always @(/*AS*/act_delayed or act_this_rank or add_rrd_inhbt
               or faw_cnt_r or rst) begin
        if (rst) faw_cnt_ns = 3'b0;
        else begin
          faw_cnt_ns = faw_cnt_r;
          if (act_this_rank) faw_cnt_ns = faw_cnt_r + 3'b1;
          if (act_delayed) faw_cnt_ns = faw_cnt_ns - 3'b1;
        end
        inhbt_act_faw_ns = (faw_cnt_ns == 3'h4) || add_rrd_inhbt;
      end
      always @(posedge clk) faw_cnt_r <= #TCQ faw_cnt_ns;
      always @(posedge clk) inhbt_act_faw_r <= #TCQ inhbt_act_faw_ns;
    end // block: inhbt_act_faw
  endgenerate


// In the DRAM spec, tWTR starts from CK following the end of the data
// burst. Since we don't directly have that spec, the wtr timer is
// based on when the CAS write command is sent to the DRAM.
//
// To compute the wtr timer value, first compute the time from the write command
// to the read command.  This is CWL + data_time + nWTR.
//
// Two is subtracted from the required wtr time since the timer
// starts two states after the arbitration cycle.

  localparam ONE = 1;
  localparam TWO = 2;

  localparam CASWR2CASRD = CWL + (BURST_MODE == "4" ? 2 : 4) + nWTR;
  localparam CASWR2CASRD_CLKS = (nCK_PER_CLK == 1)
                                    ? CASWR2CASRD :
                                 (nCK_PER_CLK == 2)
                                    ? ((CASWR2CASRD / 2) + (CASWR2CASRD % 2)) :
                                      ((CASWR2CASRD / 4) + ((CASWR2CASRD % 4) ? 1 :0));
  localparam WTR_CNT_WIDTH = clogb2(CASWR2CASRD_CLKS);

  generate
    begin : wtr_timer

      reg write_this_rank;
      always @(/*AS*/sending_col or wr_this_rank_r) begin
        write_this_rank = 1'b0;
        for (i = 0; i < nBANK_MACHS; i = i + 1)
        write_this_rank =
           write_this_rank || (sending_col[i] && wr_this_rank_r[(i*RANKS)+ID]);
      end

      reg [WTR_CNT_WIDTH-1:0] wtr_cnt_r;
      reg [WTR_CNT_WIDTH-1:0] wtr_cnt_ns;

      always @(/*AS*/rst or write_this_rank or wtr_cnt_r)
        if (rst) wtr_cnt_ns = {WTR_CNT_WIDTH{1'b0}};
        else begin
          wtr_cnt_ns = wtr_cnt_r;
          if (write_this_rank) wtr_cnt_ns =
                 CASWR2CASRD_CLKS[WTR_CNT_WIDTH-1:0] - ONE[WTR_CNT_WIDTH-1:0];
          else if (|wtr_cnt_r) wtr_cnt_ns = wtr_cnt_r - ONE[WTR_CNT_WIDTH-1:0];
        end

      wire inhbt_rd_ns = |wtr_cnt_ns;

      always @(posedge clk) wtr_cnt_r <= #TCQ wtr_cnt_ns;
      always @(inhbt_rd_ns) inhbt_rd = inhbt_rd_ns;

    end
  endgenerate

// In the DRAM spec (with AL = 0), the read-to-write command delay is implied to
// be CL + data_time + 2 tCK - CWL. The CL + data_time - CWL terms ensure the
// read and write data do not collide on the DQ bus. The 2 tCK ensures a gap
// between them. Here, we allow the user to tune this fixed term via the
// DQRD2DQWR_DLY parameter. There's a potential for optimization by relocating
// this to the rank_common module, since this is a DQ/DQS bus-level requirement,
// not a per-rank requirement.

  localparam CASRD2CASWR = CL + (BURST_MODE == "4" ? 2 : 4) + DQRD2DQWR_DLY - CWL;
  localparam CASRD2CASWR_CLKS = (nCK_PER_CLK == 1)
                                    ? CASRD2CASWR :
                                 (nCK_PER_CLK == 2)
                                    ? ((CASRD2CASWR / 2) + (CASRD2CASWR % 2)) :
                                      ((CASRD2CASWR / 4) + ((CASRD2CASWR % 4) ? 1 :0));
  localparam RTW_CNT_WIDTH = clogb2(CASRD2CASWR_CLKS);
  
  generate
    begin : rtw_timer

      reg read_this_rank;
      always @(/*AS*/sending_col or rd_this_rank_r) begin
        read_this_rank = 1'b0;
        for (i = 0; i < nBANK_MACHS; i = i + 1)
        read_this_rank =
           read_this_rank || (sending_col[i] && rd_this_rank_r[(i*RANKS)+ID]);
      end

      reg [RTW_CNT_WIDTH-1:0] rtw_cnt_r;
      reg [RTW_CNT_WIDTH-1:0] rtw_cnt_ns;

      always @(/*AS*/rst or col_rd_wr or sending_col or rtw_cnt_r)
        if (rst) rtw_cnt_ns = {RTW_CNT_WIDTH{1'b0}};
        else begin
          rtw_cnt_ns = rtw_cnt_r;
          if (col_rd_wr && |sending_col) rtw_cnt_ns =
                 CASRD2CASWR_CLKS[RTW_CNT_WIDTH-1:0] - ONE[RTW_CNT_WIDTH-1:0];
          else if (|rtw_cnt_r) rtw_cnt_ns = rtw_cnt_r - ONE[RTW_CNT_WIDTH-1:0];
        end

      wire inhbt_wr_ns = |rtw_cnt_ns;

      always @(posedge clk) rtw_cnt_r <= #TCQ rtw_cnt_ns;
      always @(inhbt_wr_ns) inhbt_wr = inhbt_wr_ns;

    end
  endgenerate

// Refresh request generation.  Implement a "refresh bank".  Referred
// to as pullin-in refresh in the JEDEC spec.
// The refresh_rank_r counter increments when a refresh to this
// rank has been decoded.  In the up direction, the count saturates
// at nREFRESH_BANK.  As specified in the JEDEC spec, nREFRESH_BANK
// is normally eight.  The counter decrements with each refresh_tick,
// saturating at zero.  A refresh will be requests when the rank is
// not busy and refresh_rank_r != nREFRESH_BANK, or refresh_rank_r
// equals zero.

  localparam REFRESH_BANK_WIDTH = clogb2(nREFRESH_BANK + 1);

  
  generate begin : refresh_generation
      reg my_rank_busy;
      always @(/*AS*/rank_busy_r) begin
        my_rank_busy = 1'b0;
        for (i=0; i < nBANK_MACHS; i=i+1)
          my_rank_busy = my_rank_busy || rank_busy_r[(i*RANKS)+ID];
      end

      wire my_refresh =
        insert_maint_r1 && ~maint_zq_r && ~maint_sre_r && ~maint_srx_r &&
        (maint_rank_r == ID[RANK_WIDTH-1:0]);

      reg [REFRESH_BANK_WIDTH-1:0] refresh_bank_r;
      reg [REFRESH_BANK_WIDTH-1:0] refresh_bank_ns;
      always @(/*AS*/app_ref_req or init_calib_complete or my_refresh
               or refresh_bank_r or refresh_tick)
        if (~init_calib_complete)
          if (REFRESH_TIMER_DIV == 0)
                refresh_bank_ns = nREFRESH_BANK[0+:REFRESH_BANK_WIDTH];
          else refresh_bank_ns = {REFRESH_BANK_WIDTH{1'b0}};
        else
          case ({my_refresh, refresh_tick, app_ref_req})
            3'b000, 3'b110, 3'b101, 3'b111 : refresh_bank_ns = refresh_bank_r;
            3'b010, 3'b001, 3'b011 : refresh_bank_ns =
                                          (|refresh_bank_r)?
                                          refresh_bank_r - ONE[0+:REFRESH_BANK_WIDTH]:
                                          refresh_bank_r;
            3'b100                 : refresh_bank_ns =
                                   refresh_bank_r + ONE[0+:REFRESH_BANK_WIDTH];
          endcase // case ({my_refresh, refresh_tick})
      always @(posedge clk) refresh_bank_r <= #TCQ refresh_bank_ns;

   `ifdef MC_SVA
      refresh_bank_overflow: assert property (@(posedge clk)
               (rst || (refresh_bank_r <= nREFRESH_BANK)));
      refresh_bank_underflow: assert property (@(posedge clk)
               (rst || ~(~|refresh_bank_r && ~my_refresh && refresh_tick)));
      refresh_hi_priority: cover property (@(posedge clk)
               (rst && ~|refresh_bank_ns && (refresh_bank_r ==
                       ONE[0+:REFRESH_BANK_WIDTH])));
      refresh_bank_full: cover property (@(posedge clk)
               (rst && (refresh_bank_r ==
                        nREFRESH_BANK[0+:REFRESH_BANK_WIDTH])));
   `endif

      assign refresh_request = init_calib_complete &&
              (~|refresh_bank_r ||
  ((refresh_bank_r != nREFRESH_BANK[0+:REFRESH_BANK_WIDTH]) && ~my_rank_busy));

    end
  endgenerate

// Periodic read request generation.

  localparam PERIODIC_RD_TIMER_WIDTH = clogb2(PERIODIC_RD_TIMER_DIV + /*idle state*/ 1);

 
  generate begin : periodic_rd_generation
    if ( PERIODIC_RD_TIMER_DIV != 0 ) begin  // enable periodic reads
      reg read_this_rank;
      always @(/*AS*/rd_this_rank_r or sending_col) begin
        read_this_rank = 1'b0;
        for (i = 0; i < nBANK_MACHS; i = i + 1)
        read_this_rank =
           read_this_rank || (sending_col[i] && rd_this_rank_r[(i*RANKS)+ID]);
      end

      reg read_this_rank_r;
      reg read_this_rank_r1;
      always @(posedge clk) read_this_rank_r  <= #TCQ read_this_rank;
      always @(posedge clk) read_this_rank_r1 <= #TCQ read_this_rank_r;
      wire int_read_this_rank = read_this_rank &&
                                (((nCK_PER_CLK == 4) && read_this_rank_r)  ||
				 ((nCK_PER_CLK != 4) && read_this_rank_r1));

      reg periodic_rd_cntr1_ns;
      reg periodic_rd_cntr1_r;
      always @(/*AS*/clear_periodic_rd_request or periodic_rd_cntr1_r) begin
        periodic_rd_cntr1_ns = periodic_rd_cntr1_r;
        if (clear_periodic_rd_request)
          periodic_rd_cntr1_ns = periodic_rd_cntr1_r + 1'b1;
      end
      always @(posedge clk) begin
        if (rst) periodic_rd_cntr1_r <= #TCQ 1'b0;
        else     periodic_rd_cntr1_r <= #TCQ periodic_rd_cntr1_ns;
      end

      reg [PERIODIC_RD_TIMER_WIDTH-1:0] periodic_rd_timer_r;
      reg [PERIODIC_RD_TIMER_WIDTH-1:0] periodic_rd_timer_ns;
      wire periodic_rd_timer_one = maint_prescaler_tick_r &&
                 (periodic_rd_timer_r == ONE[0+:PERIODIC_RD_TIMER_WIDTH]);

      always @(/*AS*/init_calib_complete or maint_prescaler_tick_r
               or periodic_rd_timer_r or int_read_this_rank) begin
        periodic_rd_timer_ns = periodic_rd_timer_r;
        if (~init_calib_complete)
          periodic_rd_timer_ns = PERIODIC_RD_TIMER_DIV[0+:PERIODIC_RD_TIMER_WIDTH];
          //periodic_rd_timer_ns = {PERIODIC_RD_TIMER_WIDTH{1'b0}};
        else if (int_read_this_rank || periodic_rd_timer_one)
                periodic_rd_timer_ns =
                   PERIODIC_RD_TIMER_DIV[0+:PERIODIC_RD_TIMER_WIDTH];
             else if (|periodic_rd_timer_r && maint_prescaler_tick_r)
                 periodic_rd_timer_ns =
                   periodic_rd_timer_r - ONE[0+:PERIODIC_RD_TIMER_WIDTH];
      end
      always @(posedge clk) periodic_rd_timer_r <= #TCQ periodic_rd_timer_ns;

      reg periodic_rd_request_r;
      wire periodic_rd_request_ns = ~rst &&
                     ((app_periodic_rd_req && init_calib_complete) ||
                      ((PERIODIC_RD_TIMER_DIV != 0) && ~init_calib_complete) ||
                      // (~(read_this_rank || clear_periodic_rd_request) &&
                      (~((int_read_this_rank) || (clear_periodic_rd_request && periodic_rd_cntr1_r)) &&
                      (periodic_rd_request_r || periodic_rd_timer_one)));
      always @(posedge clk) periodic_rd_request_r <=
                              #TCQ periodic_rd_request_ns;

   `ifdef MC_SVA
      read_clears_periodic_rd_request: cover property (@(posedge clk)
               (rst && (periodic_rd_request_r && read_this_rank)));
   `endif

      assign periodic_rd_request = init_calib_complete && periodic_rd_request_r;
    end else
      assign periodic_rd_request = 1'b0; //to disable periodic reads

  end
  endgenerate


endmodule

