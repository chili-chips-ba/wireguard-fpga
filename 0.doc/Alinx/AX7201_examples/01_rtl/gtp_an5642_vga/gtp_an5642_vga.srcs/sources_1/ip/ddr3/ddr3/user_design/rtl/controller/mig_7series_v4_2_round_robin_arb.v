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
//  /   /         Filename              : round_robin_arb.v
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

// A simple round robin arbiter implemented in a not so simple
// way.  Two things make this special.  First, it takes width as
// a parameter and secondly it's constructed in a way to work with
// restrictions synthesis programs.
//
// Consider each req/grant pair to be a
// "channel".  The arbiter computes a grant response to a request
// on a channel by channel basis.
//
// The arbiter implementes a "round robin" algorithm.  Ie, the granting
// process is totally fair and symmetric.  Each requester is given
// equal priority.  If all requests are asserted, the arbiter will
// work sequentially around the list of requesters, giving each a grant.
//
// Grant priority is based on the "last_master".  The last_master
// vector stores the channel receiving the most recent grant.  The
// next higher numbered channel (wrapping around to zero) has highest
// priority in subsequent cycles.  Relative priority wraps around
// the request vector with the last_master channel having lowest priority.
//
// At the highest implementation level, a per channel inhibit signal is computed.
// This inhibit is bit-wise AND'ed with the incoming requests to
// generate the grant.
//
// There will be at most a single grant per state.  The logic
// of the arbiter depends on this.
//
// Once a grant is given, it is stored as the last_master.  The
// last_master vector is initialized at reset to the zero'th channel.
// Although the particular channel doesn't matter, it does matter
// that the last_master contains a valid grant pattern.
//
// The heavy lifting is in computing the per channel inhibit signals.
// This is accomplished in the generate statement.
//
// The first "for" loop in the generate statement steps through the channels.
//
// The second "for" loop steps through the last mast_master vector
// for each channel.  For each last_master bit, an inh_group is generated.
// Following the end of the second "for" loop, the inh_group signals are OR'ed
// together to generate the overall inhibit bit for the channel.
//
// For a four bit wide arbiter, this is what's generated for channel zero:
//
//  inh_group[1] = last_master[0] && |req[3:1];  // any other req inhibits
//  inh_group[2] = last_master[1] && |req[3:2];  // req[3], or req[2] inhibit
//  inh_group[3] = last_master[2] && |req[3:3];  // only req[3] inhibits
//
// For req[0], last_master[3] is ignored because channel zero is highest priority
// if last_master[3] is true.
//


`timescale 1ps/1ps

module mig_7series_v4_2_round_robin_arb
  #(
    parameter TCQ = 100,
    parameter WIDTH = 3
   )
   (
    /*AUTOARG*/
  // Outputs
  grant_ns, grant_r,
  // Inputs
  clk, rst, req, disable_grant, current_master, upd_last_master
  );

  input clk;
  input rst;

  input [WIDTH-1:0] req;

  wire [WIDTH-1:0] last_master_ns;

  reg [WIDTH*2-1:0] dbl_last_master_ns;
  always @(/*AS*/last_master_ns)
    dbl_last_master_ns = {last_master_ns, last_master_ns};
  reg [WIDTH*2-1:0] dbl_req;
  always @(/*AS*/req) dbl_req = {req, req};

  reg [WIDTH-1:0] inhibit = {WIDTH{1'b0}};

  genvar i;
  genvar j;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : channel
      wire [WIDTH-1:1] inh_group;
      for (j = 0; j < (WIDTH-1); j = j + 1) begin : last_master
          assign inh_group[j+1] =
                  dbl_last_master_ns[i+j] && |dbl_req[i+WIDTH-1:i+j+1];
      end
      always @(/*AS*/inh_group) inhibit[i] = |inh_group;
    end
  endgenerate

  input disable_grant;
  output wire [WIDTH-1:0] grant_ns;
  assign grant_ns = req & ~inhibit & {WIDTH{~disable_grant}};

  output reg [WIDTH-1:0] grant_r;
  always @(posedge clk) grant_r <= #TCQ grant_ns;

  input [WIDTH-1:0] current_master;
  input upd_last_master;
  reg [WIDTH-1:0] last_master_r;
  localparam ONE = 1 << (WIDTH - 1); //Changed form '1' to fix the CR #544024
                                     //A '1' in the LSB of the last_master_r 
                                     //signal gives a low priority to req[0]
                                     //after reset. To avoid this made MSB as
                                     //'1' at reset.
  assign last_master_ns = rst
                            ? ONE[0+:WIDTH]
                            : upd_last_master
                                ? current_master
                                : last_master_r;
  always @(posedge clk) last_master_r <= #TCQ last_master_ns;

`ifdef MC_SVA
  grant_is_one_hot_zero:
    assert property (@(posedge clk) (rst || $onehot0(grant_ns)));
  last_master_r_is_one_hot:
    assert property (@(posedge clk) (rst || $onehot(last_master_r)));
`endif

endmodule

