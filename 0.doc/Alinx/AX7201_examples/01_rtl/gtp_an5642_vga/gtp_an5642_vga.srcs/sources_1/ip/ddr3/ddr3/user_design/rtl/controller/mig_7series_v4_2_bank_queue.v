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
//  /   /         Filename              : bank_queue.v
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

// Bank machine queue controller.
//
// Bank machines are always associated with a queue.  When the system is
// idle, all bank machines are in the idle queue.  As requests are
// received, the bank machine at the head of the idle queue accepts
// the request, removes itself from the idle queue and places itself
// in a queue associated with the rank-bank of the new request.
//
// If the new request is to an idle rank-bank, a new queue is created
// for that rank-bank.  If the rank-bank is not idle, then the new
// request is added to the end of the existing rank-bank queue.
//
// When the head of the idle queue accepts a new request, all other
// bank machines move down one in the idle queue.  When the idle queue
// is empty, the memory interface deasserts its accept signal.
//
// When new requests are received, the first step is to classify them
// as to whether the request targets an already open rank-bank, and if
// so, does the new request also hit on the already open page?  As mentioned
// above, a new request places itself in the existing queue for a
// rank-bank hit.  If it is also detected that the last entry in the
// existing rank-bank queue has the same page, then the current tail
// sets a bit telling itself to pass the open row when the column
// command is issued.  The "passee" knows its in the head minus one
// position and hence takes control of the rank-bank.
//
// Requests are retired out of order to optimize DRAM array resources.
// However it is required that the user cannot "observe" this out of
// order processing as a data corruption.  An ordering queue is
// used to enforce some ordering rules.  As controlled by a paramter,
// there can be no ordering (RELAXED), ordering of writes only (NORM), and
// strict (STRICT) ordering whereby input request ordering is
// strictly adhered to.
//
// Note that ordering applies only to column commands.  Row commands
// such as activate and precharge are allowed to proceed in any order
// with the proviso that within a rank-bank row commands are processed in
// the request order.
//
// When a bank machine accepts a new request, it looks at the ordering
// mode.  If no ordering, nothing is done.  If strict ordering, then
// it always places itself at the end of the ordering queue.  If "normal"
// or write ordering, the row machine places itself in the ordering
// queue only if the new request is a write.  The bank state machine
// looks at the ordering queue, and will only issue a column
// command when it sees itself at the head of the ordering queue.
//
// When a bank machine has completed its request, it must re-enter the
// idle queue.  This is done by setting the idle_r bit, and setting q_entry_r
// to the idle count.
//
// There are several situations where more than one bank machine
// will enter the idle queue simultaneously.  If two or more
// simply use the idle count to place themselves in the idle queue, multiple
// bank machines will end up at the same location in the idle queue, which
// is illegal.
//
// Based on the bank machine instance numbers, a count is made of
// the number of bank machines entering idle "below" this instance.  This
// number is added to the idle count to compute the location in
// idle queue.
//
// There is also a single bit computed that says there were bank machines
// entering the idle queue "above" this instance.  This is used to
// compute the tail bit.
//
// The word "queue" is used frequently to describe the behavior of the
// bank_queue block.  In reality, there are no queues in the ordinary sense.
// As instantiated in this block, each bank machine has a q_entry_r number.
// This number represents the position of the bank machine in its current
// queue.  At any given time, a bank machine may be in the idle queue,
// one of the dynamic rank-bank queues, or a single entry manitenance queue.
// A complete description of which queue a bank machine is currently in is
// given by idle_r, its rank-bank, mainteance status and its q_entry_r number.
//
// DRAM refresh and ZQ have a private single entry queue/channel.  However,
// when a refresh request is made, it must be injected into the main queue
// properly.  At the time of injection, the refresh rank is compared against
// all entryies in the queue.  For those that match, if timing allows, and
// they are the tail of the rank-bank queue, then the auto_pre bit is set.
// Otherwise precharge is in progress.  This results in a fully precharged
// rank.
//
//  At the time of injection, the refresh channel builds a bit
// vector of queue entries that hit on the refresh rank.  Once all
// of these entries finish, the refresh is forced in at the row arbiter.
//
// New requests that come after the refresh request will notice that
// a refresh is in progress for their rank and wait for the refresh
// to finish before attempting to arbitrate to send an activate.
//
// Injection of a refresh sets the q_has_rd bit for all queues hitting
// on the refresh rank.  This insures a starved write request will not
// indefinitely hold off a refresh.
//
// Periodic reads are required to compare themselves against requests
// that are in progress.  Adding a unique compare channel for this
// is not worthwhile.  Periodic read requests inhibit the accept
// signal and override any new request that might be trying to
// enter the queue.
//
// Once a periodic read has entered the queue it is nearly indistinguishable
// from a normal read request.  The req_periodic_rd_r bit is set for
// queue entry.  This signal is used to inhibit the rd_data_en signal.

`timescale 1ps/1ps
`define BM_SHARED_BV (ID+nBANK_MACHS-1):(ID+1)

module mig_7series_v4_2_bank_queue #
  (
   parameter TCQ = 100,
   parameter BM_CNT_WIDTH             = 2,
   parameter nBANK_MACHS              = 4,
   parameter ORDERING                 = "NORM",
   parameter ID                       = 0
  )
  (/*AUTOARG*/
  // Outputs
  head_r, tail_r, idle_ns, idle_r, pass_open_bank_ns,
  pass_open_bank_r, auto_pre_r, bm_end, passing_open_bank,
  ordered_issued, ordered_r, order_q_zero, rcv_open_bank,
  rb_hit_busies_r, q_has_rd, q_has_priority, wait_for_maint_r,
  // Inputs
  clk, rst, accept_internal_r, use_addr, periodic_rd_ack_r, bm_end_in,
  idle_cnt, rb_hit_busy_cnt, accept_req, rb_hit_busy_r, maint_idle,
  maint_hit, row_hit_r, pre_wait_r, allow_auto_pre, sending_col,
  bank_wait_in_progress, precharge_bm_end, req_wr_r, rd_wr_r,
  adv_order_q, order_cnt, rb_hit_busy_ns_in, passing_open_bank_in,
  was_wr, maint_req_r, was_priority
  );

  localparam ZERO = 0;
  localparam ONE = 1;
  localparam [BM_CNT_WIDTH-1:0] BM_CNT_ZERO = ZERO[0+:BM_CNT_WIDTH];
  localparam [BM_CNT_WIDTH-1:0] BM_CNT_ONE = ONE[0+:BM_CNT_WIDTH];

  input clk;
  input rst;

// Decide if this bank machine should accept a new request.
  reg idle_r_lcl;
  reg head_r_lcl;
  input accept_internal_r;
  wire bm_ready = idle_r_lcl && head_r_lcl && accept_internal_r;

// Accept request in this bank machine.  Could be maintenance or
// regular request.
  input use_addr;
  input periodic_rd_ack_r;
  wire accept_this_bm = bm_ready && (use_addr || periodic_rd_ack_r);

// Multiple machines may enter the idle queue in a single state.
// Based on bank machine instance number, compute how many
// bank machines with lower instance numbers are entering
// the idle queue.

  input [(nBANK_MACHS*2)-1:0] bm_end_in;

  reg [BM_CNT_WIDTH-1:0] idlers_below;
  integer i;
  always @(/*AS*/bm_end_in) begin
    idlers_below = BM_CNT_ZERO;
    for (i=0; i<ID; i=i+1)
      idlers_below = idlers_below + bm_end_in[i];
   end

  reg idlers_above;
  always @(/*AS*/bm_end_in) begin
    idlers_above = 1'b0;
    for (i=ID+1; i<ID+nBANK_MACHS; i=i+1)
      idlers_above = idlers_above || bm_end_in[i];
  end

`ifdef MC_SVA
  bm_end_and_idlers_above: cover property (@(posedge clk)
         (~rst && bm_end && idlers_above));
  bm_end_and_idlers_below: cover property (@(posedge clk)
         (~rst && bm_end && |idlers_below));
`endif

// Compute the q_entry number.
  input [BM_CNT_WIDTH-1:0] idle_cnt;
  input [BM_CNT_WIDTH-1:0] rb_hit_busy_cnt;
  input accept_req;
  wire bm_end_lcl;
  reg adv_queue = 1'b0;

  reg [BM_CNT_WIDTH-1:0] q_entry_r;
  reg [BM_CNT_WIDTH-1:0] q_entry_ns;
  wire [BM_CNT_WIDTH-1:0] temp;
//  always @(/*AS*/accept_req or accept_this_bm or adv_queue
//           or bm_end_lcl or idle_cnt or idle_r_lcl or idlers_below
//           or q_entry_r or rb_hit_busy_cnt /*or rst*/) begin
////    if (rst) q_entry_ns = ID[BM_CNT_WIDTH-1:0];
////    else begin
//      q_entry_ns = q_entry_r;
//      if ((~idle_r_lcl && adv_queue) ||
//          (idle_r_lcl && accept_req && ~accept_this_bm))
//        q_entry_ns = q_entry_r - BM_CNT_ONE;
//      if (accept_this_bm)
////        q_entry_ns = rb_hit_busy_cnt - (adv_queue ? BM_CNT_ONE : BM_CNT_ZERO);
//        q_entry_ns = adv_queue ? (rb_hit_busy_cnt - BM_CNT_ONE) :  (rb_hit_busy_cnt -BM_CNT_ZERO);
//      if (bm_end_lcl) begin
//        q_entry_ns = idle_cnt + idlers_below;
//        if (accept_req) q_entry_ns = q_entry_ns - BM_CNT_ONE;
////      end
//    end
//  end
assign temp = idle_cnt + idlers_below;
always @ (*)
begin
  if (accept_req & bm_end_lcl)
    q_entry_ns  = temp - BM_CNT_ONE;
  else if (bm_end_lcl)
    q_entry_ns = temp;
  else if (accept_this_bm) 
    q_entry_ns = adv_queue ? (rb_hit_busy_cnt - BM_CNT_ONE) :  (rb_hit_busy_cnt -BM_CNT_ZERO);
  else if ((!idle_r_lcl & adv_queue) |
          (idle_r_lcl & accept_req & !accept_this_bm))
    q_entry_ns = q_entry_r - BM_CNT_ONE;
  else
  q_entry_ns = q_entry_r;
end


  always @(posedge clk)
  if (rst)
    q_entry_r <= #TCQ ID[BM_CNT_WIDTH-1:0];
  else
    q_entry_r <= #TCQ q_entry_ns;

// Determine if this entry is the head of its queue.
  reg head_ns;
  always @(/*AS*/accept_req or accept_this_bm or adv_queue
           or bm_end_lcl or head_r_lcl or idle_cnt or idle_r_lcl
           or idlers_below or q_entry_r or rb_hit_busy_cnt or rst) begin
    if (rst) head_ns = ~|ID[BM_CNT_WIDTH-1:0];
    else begin
      head_ns = head_r_lcl;
      if (accept_this_bm)
        head_ns = ~|(rb_hit_busy_cnt - (adv_queue ? BM_CNT_ONE : BM_CNT_ZERO));
      if ((~idle_r_lcl && adv_queue) ||
           (idle_r_lcl && accept_req && ~accept_this_bm))
        head_ns = ~|(q_entry_r - BM_CNT_ONE);
      if (bm_end_lcl) begin
        head_ns = ~|(idle_cnt - (accept_req ? BM_CNT_ONE : BM_CNT_ZERO)) &&
                   ~|idlers_below;
      end
    end
  end
  always @(posedge clk) head_r_lcl <= #TCQ head_ns;
  output wire head_r;
  assign head_r = head_r_lcl;

// Determine if this entry is the tail of its queue.  Note that
// an entry can be both head and tail.
  input rb_hit_busy_r;
  reg tail_r_lcl = 1'b1;
  generate
    if (nBANK_MACHS > 1) begin : compute_tail
      reg tail_ns;
      always @(accept_req or accept_this_bm
               or bm_end_in or bm_end_lcl or idle_r_lcl
               or idlers_above or rb_hit_busy_r or rst or tail_r_lcl) begin
        if (rst) tail_ns = (ID == nBANK_MACHS);
// The order of the statements below is important in the case where
// another bank machine is retiring and this bank machine is accepting.
        else begin
          tail_ns = tail_r_lcl;
          if ((accept_req && rb_hit_busy_r) ||
               (|bm_end_in[`BM_SHARED_BV] && idle_r_lcl))
            tail_ns = 1'b0;
          if (accept_this_bm || (bm_end_lcl && ~idlers_above)) tail_ns = 1'b1;
         end
       end
       always @(posedge clk) tail_r_lcl <= #TCQ tail_ns;
    end // if (nBANK_MACHS > 1)
  endgenerate
  output wire tail_r;
  assign tail_r = tail_r_lcl;

  wire clear_req = bm_end_lcl || rst;

// Is this entry in the idle queue?
  reg idle_ns_lcl;
  always @(/*AS*/accept_this_bm or clear_req or idle_r_lcl) begin
    idle_ns_lcl = idle_r_lcl;
    if (accept_this_bm) idle_ns_lcl = 1'b0;
    if (clear_req) idle_ns_lcl = 1'b1;
  end
  always @(posedge clk) idle_r_lcl <= #TCQ idle_ns_lcl;
  output wire idle_ns;
  assign idle_ns = idle_ns_lcl;
  output wire idle_r;
  assign idle_r = idle_r_lcl;

// Maintenance hitting on this active bank machine is in progress.
  input maint_idle;
  input maint_hit;
  wire maint_hit_this_bm = ~maint_idle && maint_hit;

// Does new request hit on this bank machine while it is able to pass the
// open bank?
  input row_hit_r;
  input pre_wait_r;
  wire pass_open_bank_eligible =
         tail_r_lcl && rb_hit_busy_r && row_hit_r && ~pre_wait_r;

// Set pass open bank bit, but not if request preceded active maintenance.
  reg wait_for_maint_r_lcl;
  reg pass_open_bank_r_lcl;
  wire pass_open_bank_ns_lcl = ~clear_req &&
          (pass_open_bank_r_lcl ||
           (accept_req && pass_open_bank_eligible &&
             (~maint_hit_this_bm || wait_for_maint_r_lcl)));
  always @(posedge clk) pass_open_bank_r_lcl <= #TCQ pass_open_bank_ns_lcl;
  output wire pass_open_bank_ns;
  assign pass_open_bank_ns = pass_open_bank_ns_lcl;
  output wire pass_open_bank_r;
  assign pass_open_bank_r = pass_open_bank_r_lcl;

`ifdef MC_SVA
  pass_open_bank: cover property (@(posedge clk) (~rst && pass_open_bank_ns));
  pass_open_bank_killed_by_maint: cover property (@(posedge clk)
     (~rst && accept_req && pass_open_bank_eligible &&
       maint_hit_this_bm && ~wait_for_maint_r_lcl));
  pass_open_bank_following_maint: cover property (@(posedge clk)
     (~rst && accept_req && pass_open_bank_eligible &&
        maint_hit_this_bm && wait_for_maint_r_lcl));
`endif

// Should the column command be sent with the auto precharge bit set?  This
// will happen when it is detected that next request is to a different row,
// or the next reqest is the next request is refresh to this rank.
  reg auto_pre_r_lcl;
  reg auto_pre_ns;
  input allow_auto_pre;
  always @(/*AS*/accept_req or allow_auto_pre or auto_pre_r_lcl
           or clear_req or maint_hit_this_bm or rb_hit_busy_r
           or row_hit_r or tail_r_lcl or wait_for_maint_r_lcl) begin
    auto_pre_ns = auto_pre_r_lcl;
    if (clear_req) auto_pre_ns = 1'b0;
    else
      if (accept_req && tail_r_lcl && allow_auto_pre && rb_hit_busy_r &&
          (~row_hit_r || (maint_hit_this_bm && ~wait_for_maint_r_lcl)))
        auto_pre_ns = 1'b1;
  end
  always @(posedge clk) auto_pre_r_lcl <= #TCQ auto_pre_ns;
  output wire auto_pre_r;
  assign auto_pre_r = auto_pre_r_lcl;

`ifdef MC_SVA
  auto_precharge: cover property (@(posedge clk) (~rst && auto_pre_ns));
  maint_triggers_auto_precharge: cover property (@(posedge clk)
    (~rst && auto_pre_ns && ~auto_pre_r && row_hit_r));
`endif

// Determine when the current request is finished.
  input sending_col;
  input req_wr_r;
  input rd_wr_r;
  wire sending_col_not_rmw_rd = sending_col && !(req_wr_r && rd_wr_r);
  input bank_wait_in_progress;
  input precharge_bm_end;
  reg pre_bm_end_r;
  wire pre_bm_end_ns = precharge_bm_end ||
                       (bank_wait_in_progress && pass_open_bank_ns_lcl);
  always @(posedge clk) pre_bm_end_r <= #TCQ pre_bm_end_ns;
  assign bm_end_lcl = 
          pre_bm_end_r || (sending_col_not_rmw_rd && pass_open_bank_r_lcl);
  output wire bm_end;
  assign bm_end = bm_end_lcl;

// Determine that the open bank should be passed to the successor bank machine.
  reg pre_passing_open_bank_r;
  wire pre_passing_open_bank_ns =
            bank_wait_in_progress && pass_open_bank_ns_lcl;
  always @(posedge clk) pre_passing_open_bank_r <= #TCQ
                         pre_passing_open_bank_ns;
  output wire passing_open_bank;
  assign passing_open_bank =
  pre_passing_open_bank_r || (sending_col_not_rmw_rd && pass_open_bank_r_lcl);

  reg ordered_ns;
  wire set_order_q = ((ORDERING == "STRICT") || ((ORDERING == "NORM") &&
                       req_wr_r)) && accept_this_bm;

  wire ordered_issued_lcl = 
            sending_col_not_rmw_rd && !(req_wr_r && rd_wr_r) &&
            ((ORDERING == "STRICT") || ((ORDERING == "NORM") && req_wr_r));
  output wire ordered_issued;
  assign ordered_issued = ordered_issued_lcl;

  reg ordered_r_lcl;
  always @(/*AS*/ordered_issued_lcl or ordered_r_lcl or rst
           or set_order_q) begin
    if (rst) ordered_ns = 1'b0;
    else begin
      ordered_ns = ordered_r_lcl;
// Should never see accept_this_bm and adv_order_q at the same time.
      if (set_order_q) ordered_ns = 1'b1;
      if (ordered_issued_lcl) ordered_ns = 1'b0;
    end
  end
  always @(posedge clk) ordered_r_lcl <= #TCQ ordered_ns;
  output wire ordered_r;
  assign ordered_r = ordered_r_lcl;

// Figure out when to advance the ordering queue.
  input adv_order_q;
  input [BM_CNT_WIDTH-1:0] order_cnt;
  reg [BM_CNT_WIDTH-1:0] order_q_r;
  reg [BM_CNT_WIDTH-1:0] order_q_ns;
  always @(/*AS*/adv_order_q or order_cnt or order_q_r or rst
           or set_order_q) begin
    order_q_ns = order_q_r;
    if (rst) order_q_ns = BM_CNT_ZERO;
    if (set_order_q)
      if (adv_order_q) order_q_ns = order_cnt - BM_CNT_ONE;
      else order_q_ns = order_cnt;
    if (adv_order_q && |order_q_r) order_q_ns = order_q_r - BM_CNT_ONE;
  end
  always @(posedge clk) order_q_r <= #TCQ order_q_ns;

  output wire order_q_zero;
  assign order_q_zero = ~|order_q_r ||
                        (adv_order_q && (order_q_r == BM_CNT_ONE)) ||
                        ((ORDERING == "NORM") && rd_wr_r);

// Keep track of which other bank machine are ahead of this one in a
// rank-bank queue.  This is necessary to know when to advance this bank
// machine in the queue, and when to update bank state machine counter upon
// passing a bank.
  input [(nBANK_MACHS*2)-1:0] rb_hit_busy_ns_in;
  reg [(nBANK_MACHS*2)-1:0] rb_hit_busies_r_lcl = {nBANK_MACHS*2{1'b0}};
  input [(nBANK_MACHS*2)-1:0] passing_open_bank_in;
  output reg rcv_open_bank = 1'b0;

  generate
    if (nBANK_MACHS > 1) begin : rb_hit_busies

// The clear_vector resets bits in the rb_hit_busies vector as bank machines
// completes requests.  rst also resets all the bits.
      wire [nBANK_MACHS-2:0] clear_vector =
                ({nBANK_MACHS-1{rst}} | bm_end_in[`BM_SHARED_BV]);

// As this bank machine takes on a new request, capture the vector of
// which other bank machines are in the same queue.
      wire [`BM_SHARED_BV] rb_hit_busies_ns =
                ~clear_vector &
                (idle_ns_lcl
                   ? rb_hit_busy_ns_in[`BM_SHARED_BV]
                   : rb_hit_busies_r_lcl[`BM_SHARED_BV]);
      always @(posedge clk) rb_hit_busies_r_lcl[`BM_SHARED_BV] <=
                             #TCQ rb_hit_busies_ns;

// Compute when to advance this queue entry based on seeing other bank machines
// in the same queue finish.
      always @(bm_end_in or rb_hit_busies_r_lcl)
        adv_queue =
            |(bm_end_in[`BM_SHARED_BV] & rb_hit_busies_r_lcl[`BM_SHARED_BV]);

// Decide when to receive an open bank based on knowing this bank machine is
// one entry from the head, and a passing_open_bank hits on the
// rb_hit_busies vector.
      always @(idle_r_lcl
               or passing_open_bank_in or q_entry_r
               or rb_hit_busies_r_lcl) rcv_open_bank =
    |(rb_hit_busies_r_lcl[`BM_SHARED_BV] & passing_open_bank_in[`BM_SHARED_BV])
      && (q_entry_r == BM_CNT_ONE) && ~idle_r_lcl;
    end
  endgenerate
  output wire [nBANK_MACHS*2-1:0] rb_hit_busies_r;
  assign rb_hit_busies_r = rb_hit_busies_r_lcl;


// Keep track if the queue this entry is in has priority content.
  input was_wr;
  input maint_req_r;
  reg q_has_rd_r;
  wire q_has_rd_ns = ~clear_req &&
              (q_has_rd_r || (accept_req && rb_hit_busy_r && ~was_wr) ||
               (maint_req_r && maint_hit && ~idle_r_lcl));
  always @(posedge clk) q_has_rd_r <= #TCQ q_has_rd_ns;
  output wire q_has_rd;
  assign q_has_rd = q_has_rd_r;

  input was_priority;
  reg q_has_priority_r;
  wire q_has_priority_ns = ~clear_req &&
          (q_has_priority_r || (accept_req && rb_hit_busy_r && was_priority));
  always @(posedge clk) q_has_priority_r <= #TCQ q_has_priority_ns;
  output wire q_has_priority;
  assign q_has_priority = q_has_priority_r;

// Figure out if this entry should wait for maintenance to end.
  wire wait_for_maint_ns = ~rst && ~maint_idle &&
                      (wait_for_maint_r_lcl || (maint_hit && accept_this_bm));
  always @(posedge clk) wait_for_maint_r_lcl <= #TCQ wait_for_maint_ns;
  output wire wait_for_maint_r;
  assign wait_for_maint_r = wait_for_maint_r_lcl;

endmodule // bank_queue

