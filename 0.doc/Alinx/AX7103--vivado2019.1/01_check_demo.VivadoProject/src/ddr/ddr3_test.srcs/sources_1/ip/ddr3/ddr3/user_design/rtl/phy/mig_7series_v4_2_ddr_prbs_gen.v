//*****************************************************************************
// (c) Copyright 2009 - 2014 Xilinx, Inc. All rights reserved.
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
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: %version
//  \   \         Application: MIG
//  /   /         Filename: ddr_prbs_gen.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:35:10 $
// \   \  /  \    Date Created: 05/12/10
//  \___\/\___\
//
//Device: 7 Series
//Design Name: ddr_prbs_gen
// Overview:
//  Implements a "pseudo-PRBS" generator. Basically this is a standard
//  PRBS generator (using an linear feedback shift register) along with
//  logic to force the repetition of the sequence after 2^PRBS_WIDTH
//  samples (instead of 2^PRBS_WIDTH - 1). The LFSR is based on the design
//  from Table 1 of XAPP 210. Note that only 8- and 10-tap long LFSR chains
//  are supported in this code
// Parameter Requirements:
//  1. PRBS_WIDTH = 8 or 10
//  2. PRBS_WIDTH >= 2*nCK_PER_CLK
// Output notes:
//  The output of this module consists of 2*nCK_PER_CLK bits, these contain
//  the value of the LFSR output for the next 2*CK_PER_CLK bit times. Note
//  that prbs_o[0] contains the bit value for the "earliest" bit time. 
//
//Reference:
//Revision History:
// 
//*****************************************************************************

/******************************************************************************
**$Id: ddr_prbs_gen.v,v 1.1 2011/06/02 08:35:10 mishra Exp $
**$Date: 2011/06/02 08:35:10 $
**$Author: mishra $
**$Revision: 1.1 $
**$Source: /devl/xcs/repo/env/Databases/ip/src2/O/mig_7series_v1_3/data/dlib/7series/ddr3_sdram/verilog/rtl/phy/ddr_prbs_gen.v,v $
******************************************************************************/


`timescale 1ps/1ps

module mig_7series_v4_2_ddr_prbs_gen #
  (
   parameter TCQ           = 100,        // clk->out delay (sim only)
   parameter PRBS_WIDTH    = 64,         // LFSR shift register length
   parameter DQS_CNT_WIDTH = 5,
   parameter DQ_WIDTH      = 72,
   parameter VCCO_PAT_EN   = 1,
   parameter VCCAUX_PAT_EN = 1,
   parameter ISI_PAT_EN    = 1,
   parameter FIXED_VICTIM  = "TRUE"
   )
  (
   input                      clk_i,          // input clock
   input                      clk_en_i,       // clock enable 
   input                      rst_i,          // synchronous reset
   input [PRBS_WIDTH-1:0]     prbs_seed_i,    // initial LFSR seed
   input                      phy_if_empty,   // IN_FIFO empty flag
   input                      prbs_rdlvl_start, // PRBS read lveling start
   input                      prbs_rdlvl_done,
   input                      complex_wr_done,
   input [2:0]                victim_sel,
   input [DQS_CNT_WIDTH:0]    byte_cnt,
   //output [PRBS_WIDTH-1:0]    prbs_o // generated pseudo random data
   output [8*DQ_WIDTH-1:0]    prbs_o,
   output [9:0]               dbg_prbs_gen,
   input                      reset_rd_addr,
   output                     prbs_ignore_first_byte,
   output                     prbs_ignore_last_bytes
  );

  //***************************************************************************

  function integer clogb2 (input integer size);
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
        size = size >> 1;
    end
  endfunction
  
  // Number of internal clock cycles before the PRBS sequence will repeat
  localparam PRBS_SEQ_LEN_CYCLES = 128;
  localparam PRBS_SEQ_LEN_CYCLES_BITS = clogb2(PRBS_SEQ_LEN_CYCLES);
  
  reg                                 phy_if_empty_r;
  reg                                 reseed_prbs_r;
  reg [PRBS_SEQ_LEN_CYCLES_BITS-1:0]  sample_cnt_r;
  reg [PRBS_WIDTH - 1 :0]             prbs;  
  reg [PRBS_WIDTH :1]                 lfsr_q;
 

  //***************************************************************************
  always @(posedge clk_i) begin
    phy_if_empty_r <= #TCQ phy_if_empty;
  end

  //***************************************************************************
  // Generate PRBS reset signal to ensure that PRBS sequence repeats after
  // every 2**PRBS_WIDTH samples. Basically what happens is that we let the
  // LFSR run for an extra cycle after "truly PRBS" 2**PRBS_WIDTH - 1
  // samples have past. Once that extra cycle is finished, we reseed the LFSR
  always @(posedge clk_i)
  begin
    if (rst_i || ~clk_en_i) begin
      sample_cnt_r    <= #TCQ 'b0;
      reseed_prbs_r   <= #TCQ 1'b0;
    end else if (clk_en_i && (~phy_if_empty_r || ~prbs_rdlvl_start)) begin
      // The rollver count should always be [(power of 2) - 1]
      sample_cnt_r    <= #TCQ sample_cnt_r + 1;
      // Assert PRBS reset signal so that it is simultaneously with the
      // last sample of the sequence
      if (sample_cnt_r == PRBS_SEQ_LEN_CYCLES - 2)
        reseed_prbs_r <= #TCQ 1'b1;
      else
        reseed_prbs_r <= #TCQ 1'b0;
    end
  end

  always @ (posedge clk_i)
  begin
//reset it to a known good state to prevent it locks up
    if ((reseed_prbs_r && clk_en_i) || rst_i || ~clk_en_i) begin
      lfsr_q[4:1]          <= #TCQ prbs_seed_i[3:0] | 4'h5;
      lfsr_q[PRBS_WIDTH:5] <= #TCQ prbs_seed_i[PRBS_WIDTH-1:4];
    end
    else if (clk_en_i && (~phy_if_empty_r || ~prbs_rdlvl_start)) begin
      lfsr_q[PRBS_WIDTH:31] <= #TCQ lfsr_q[PRBS_WIDTH-1:30];
      lfsr_q[30]            <= #TCQ lfsr_q[16] ^ lfsr_q[13] ^ lfsr_q[5]  ^ lfsr_q[1];
      lfsr_q[29:9]          <= #TCQ lfsr_q[28:8];
      lfsr_q[8]             <= #TCQ lfsr_q[32] ^ lfsr_q[7];
      lfsr_q[7]             <= #TCQ lfsr_q[32] ^ lfsr_q[6];
      lfsr_q[6:4]           <= #TCQ lfsr_q[5:3];
      lfsr_q[3]             <= #TCQ lfsr_q[32] ^ lfsr_q[2];
      lfsr_q[2]             <= #TCQ lfsr_q[1] ;
      lfsr_q[1]             <= #TCQ lfsr_q[32];
    end
  end
 
  always @ (lfsr_q[PRBS_WIDTH:1]) begin
    prbs = lfsr_q[PRBS_WIDTH:1];
  end
  
//******************************************************************************
// Complex pattern BRAM
//******************************************************************************

localparam BRAM_ADDR_WIDTH = 8;
localparam BRAM_DATA_WIDTH = 18;
localparam BRAM_DEPTH      = 256;

integer i,j;
(* RAM_STYLE = "distributed" *) reg [BRAM_ADDR_WIDTH - 1:0]  rd_addr;
//reg [BRAM_DATA_WIDTH - 1:0]  mem[0:BRAM_DEPTH - 1]; 
(* RAM_STYLE = "distributed" *) reg [BRAM_DATA_WIDTH - 1:0]  mem_out;
reg [BRAM_DATA_WIDTH - 3:0]  dout_o;
reg [DQ_WIDTH-1:0]           sel;
reg [DQ_WIDTH-1:0]           dout_rise0;
reg [DQ_WIDTH-1:0]           dout_fall0;
reg [DQ_WIDTH-1:0]           dout_rise1;
reg [DQ_WIDTH-1:0]           dout_fall1;
reg [DQ_WIDTH-1:0]           dout_rise2;
reg [DQ_WIDTH-1:0]           dout_fall2;
reg [DQ_WIDTH-1:0]           dout_rise3;
reg [DQ_WIDTH-1:0]           dout_fall3;

// VCCO noise injection pattern with matching victim (reads with gaps)
// content format
//        {aggressor pattern, victim pattern}
always @ (rd_addr) begin
  case (rd_addr)
    8'd0    :   mem_out = {2'b11, 8'b10101010,8'b10101010}; //1 read
    8'd1    :   mem_out = {2'b01, 8'b11001100,8'b11001100}; //2 reads
    8'd2    :   mem_out = {2'b10, 8'b11001100,8'b11001100}; //2 reads
    8'd3    :   mem_out = {2'b01, 8'b11100011,8'b11100011}; //3 reads
    8'd4    :   mem_out = {2'b00, 8'b10001110,8'b10001110}; //3 reads
    8'd5    :   mem_out = {2'b10, 8'b00111000,8'b00111000}; //3 reads
    8'd6    :   mem_out = {2'b01, 8'b11110000,8'b11110000}; //4 reads
    8'd7    :   mem_out = {2'b00, 8'b11110000,8'b11110000}; //4 reads
    8'd8    :   mem_out = {2'b00, 8'b11110000,8'b11110000}; //4 reads
    8'd9    :   mem_out = {2'b10, 8'b11110000,8'b11110000}; //4 reads
    8'd10   :   mem_out = {2'b01, 8'b11111000,8'b11111000}; //5 reads
    8'd11   :   mem_out = {2'b00, 8'b00111110,8'b00111110}; //5 reads
    8'd12   :   mem_out = {2'b00, 8'b00001111,8'b00001111}; //5 reads
    8'd13   :   mem_out = {2'b00, 8'b10000011,8'b10000011}; //5 reads
    8'd14   :   mem_out = {2'b10, 8'b11100000,8'b11100000}; //5 reads
    8'd15   :   mem_out = {2'b01, 8'b11111100,8'b11111100}; //6 reads
    8'd16   :   mem_out = {2'b00, 8'b00001111,8'b00001111}; //6 reads
    8'd17   :   mem_out = {2'b00, 8'b11000000,8'b11000000}; //6 reads
    8'd18   :   mem_out = {2'b00, 8'b11111100,8'b11111100}; //6 reads
    8'd19   :   mem_out = {2'b00, 8'b00001111,8'b00001111}; //6 reads
    8'd20   :   mem_out = {2'b10, 8'b11000000,8'b11000000}; //6 reads
     // VCCO noise injection pattern with non-matching victim (reads with gaps)
     // content format
     //        {aggressor pattern, victim pattern}
    8'd21   :   mem_out = {2'b11, 8'b10101010,8'b01010101}; //1 read
    8'd22   :   mem_out = {2'b01, 8'b11001100,8'b00110011}; //2 reads
    8'd23   :   mem_out = {2'b10, 8'b11001100,8'b00110011}; //2 reads
    8'd24   :   mem_out = {2'b01, 8'b11100011,8'b00011100}; //3 reads
    8'd25   :   mem_out = {2'b00, 8'b10001110,8'b01110001}; //3 reads
    8'd26   :   mem_out = {2'b10, 8'b00111000,8'b11000111}; //3 reads
    8'd27   :   mem_out = {2'b01, 8'b11110000,8'b00001111}; //4 reads
    8'd28   :   mem_out = {2'b00, 8'b11110000,8'b00001111}; //4 reads
    8'd29   :   mem_out = {2'b00, 8'b11110000,8'b00001111}; //4 reads
    8'd30   :   mem_out = {2'b10, 8'b11110000,8'b00001111}; //4 reads
    8'd31   :   mem_out = {2'b01, 8'b11111000,8'b00000111}; //5 reads
    8'd32   :   mem_out = {2'b00, 8'b00111110,8'b11000001}; //5 reads
    8'd33   :   mem_out = {2'b00, 8'b00001111,8'b11110000}; //5 reads
    8'd34   :   mem_out = {2'b00, 8'b10000011,8'b01111100}; //5 reads
    8'd35   :   mem_out = {2'b10, 8'b11100000,8'b00011111}; //5 reads
    8'd36   :   mem_out = {2'b01, 8'b11111100,8'b00000011}; //6 reads
    8'd37   :   mem_out = {2'b00, 8'b00001111,8'b11110000}; //6 reads
    8'd38   :   mem_out = {2'b00, 8'b11000000,8'b00111111}; //6 reads
    8'd39   :   mem_out = {2'b00, 8'b11111100,8'b00000011}; //6 reads
    8'd40   :   mem_out = {2'b00, 8'b00001111,8'b11110000}; //6 reads
    8'd41   :   mem_out = {2'b10, 8'b11000000,8'b00111111}; //6 reads
    // VCCAUX noise injection pattern with ISI pattern on victim (reads with gaps)
    // content format
    //        {aggressor pattern, victim pattern}
    8'd42   :   mem_out = {2'b01, 8'b10110100,8'b01010111}; //3 reads
    8'd43   :   mem_out = {2'b00, 8'b10110100,8'b01101111}; //3 reads
    8'd44   :   mem_out = {2'b10, 8'b10110100,8'b11000000}; //3 reads
    8'd45   :   mem_out = {2'b01, 8'b10100010,8'b10000100}; //4 reads
    8'd46   :   mem_out = {2'b00, 8'b10001010,8'b00110001}; //4 reads
    8'd47   :   mem_out = {2'b00, 8'b00101000,8'b01000111}; //4 reads
    8'd48   :   mem_out = {2'b10, 8'b10100010,8'b00100101}; //4 reads
    8'd49   :   mem_out = {2'b01, 8'b10101111,8'b10011010}; //5 reads
    8'd50   :   mem_out = {2'b00, 8'b01010000,8'b01111010}; //5 reads
    8'd51   :   mem_out = {2'b00, 8'b10101111,8'b10010101}; //5 reads
    8'd52   :   mem_out = {2'b00, 8'b01010000,8'b11011011}; //5 reads
    8'd53   :   mem_out = {2'b10, 8'b10101111,8'b11110000}; //5 reads
    8'd54   :   mem_out = {2'b01, 8'b10101000,8'b00100001}; //7 reads
    8'd55   :   mem_out = {2'b00, 8'b00101010,8'b10001010}; //7 reads
    8'd56   :   mem_out = {2'b00, 8'b00001010,8'b00100101}; //7 reads
    8'd57   :   mem_out = {2'b00, 8'b10000010,8'b10011010}; //7 reads
    8'd58   :   mem_out = {2'b00, 8'b10100000,8'b01111010}; //7 reads
    8'd59   :   mem_out = {2'b00, 8'b10101000,8'b10111111}; //7 reads
    8'd60   :   mem_out = {2'b10, 8'b00101010,8'b01010111}; //7 reads
    8'd61   :   mem_out = {2'b01, 8'b10101011,8'b01101111}; //8 reads
    8'd62   :   mem_out = {2'b00, 8'b11110101,8'b11000000}; //8 reads
    8'd63   :   mem_out = {2'b00, 8'b01000000,8'b10000100}; //8 reads
    8'd64   :   mem_out = {2'b00, 8'b10101011,8'b00110001}; //8 reads
    8'd65   :   mem_out = {2'b00, 8'b11110101,8'b01000111}; //8 reads
    8'd66   :   mem_out = {2'b00, 8'b01000000,8'b00100101}; //8 reads
    8'd67   :   mem_out = {2'b00, 8'b10101011,8'b10011010}; //8 reads
    8'd68   :   mem_out = {2'b10, 8'b11110101,8'b01111010}; //8 reads
    8'd69   :   mem_out = {2'b01, 8'b10101010,8'b10010101}; //9 reads
    8'd70   :   mem_out = {2'b00, 8'b00000010,8'b11011011}; //9 reads
    8'd71   :   mem_out = {2'b00, 8'b10101000,8'b11110000}; //9 reads
    8'd72   :   mem_out = {2'b00, 8'b00001010,8'b00100001}; //9 reads
    8'd73   :   mem_out = {2'b00, 8'b10100000,8'b10001010}; //9 reads
    8'd74   :   mem_out = {2'b00, 8'b00101010,8'b00100101}; //9 reads
    8'd75   :   mem_out = {2'b00, 8'b10000000,8'b10011010}; //9 reads
    8'd76   :   mem_out = {2'b00, 8'b10101010,8'b01111010}; //9 reads
    8'd77   :   mem_out = {2'b10, 8'b00000010,8'b10111111}; //9 reads
    8'd78   :   mem_out = {2'b01, 8'b10101010,8'b01010111}; //10 reads
    8'd79   :   mem_out = {2'b00, 8'b11111111,8'b01101111}; //10 reads
    8'd80   :   mem_out = {2'b00, 8'b01010101,8'b11000000}; //10 reads
    8'd81   :   mem_out = {2'b00, 8'b00000000,8'b10000100}; //10 reads
    8'd82   :   mem_out = {2'b00, 8'b10101010,8'b00110001}; //10 reads
    8'd83   :   mem_out = {2'b00, 8'b11111111,8'b01000111}; //10 reads
    8'd84   :   mem_out = {2'b00, 8'b01010101,8'b00100101}; //10 reads
    8'd85   :   mem_out = {2'b00, 8'b00000000,8'b10011010}; //10 reads
    8'd86   :   mem_out = {2'b00, 8'b10101010,8'b01111010}; //10 reads
    8'd87   :   mem_out = {2'b10, 8'b11111111,8'b10010101}; //10 reads
    8'd88   :   mem_out = {2'b01, 8'b10101010,8'b11011011}; //12 reads
    8'd89   :   mem_out = {2'b00, 8'b10000000,8'b11110000}; //12 reads
    8'd90   :   mem_out = {2'b00, 8'b00101010,8'b00100001}; //12 reads
    8'd91   :   mem_out = {2'b00, 8'b10100000,8'b10001010}; //12 reads
    8'd92   :   mem_out = {2'b00, 8'b00001010,8'b00100101}; //12 reads
    8'd93   :   mem_out = {2'b00, 8'b10101000,8'b10011010}; //12 reads
    8'd94   :   mem_out = {2'b00, 8'b00000010,8'b01111010}; //12 reads
    8'd95   :   mem_out = {2'b00, 8'b10101010,8'b10111111}; //12 reads
    8'd96   :   mem_out = {2'b00, 8'b00000000,8'b01010111}; //12 reads
    8'd97   :   mem_out = {2'b00, 8'b10101010,8'b01101111}; //12 reads
    8'd98   :   mem_out = {2'b00, 8'b10000000,8'b11000000}; //12 reads
    8'd99   :   mem_out = {2'b10, 8'b00101010,8'b10000100}; //12 reads
    8'd100  :   mem_out = {2'b01, 8'b10101010,8'b00110001}; //13 reads
    8'd101  :   mem_out = {2'b00, 8'b10111111,8'b01000111}; //13 reads
    8'd102  :   mem_out = {2'b00, 8'b11110101,8'b00100101}; //13 reads
    8'd103  :   mem_out = {2'b00, 8'b01010100,8'b10011010}; //13 reads
    8'd104  :   mem_out = {2'b00, 8'b00000000,8'b01111010}; //13 reads
    8'd105  :   mem_out = {2'b00, 8'b10101010,8'b10010101}; //13 reads
    8'd106  :   mem_out = {2'b00, 8'b10111111,8'b11011011}; //13 reads
    8'd107  :   mem_out = {2'b00, 8'b11110101,8'b11110000}; //13 reads
    8'd108  :   mem_out = {2'b00, 8'b01010100,8'b00100001}; //13 reads
    8'd109  :   mem_out = {2'b00, 8'b00000000,8'b10001010}; //13 reads
    8'd110  :   mem_out = {2'b00, 8'b10101010,8'b00100101}; //13 reads
    8'd111  :   mem_out = {2'b00, 8'b10111111,8'b10011010}; //13 reads
    8'd112  :   mem_out = {2'b10, 8'b11110101,8'b01111010}; //13 reads
    8'd113  :   mem_out = {2'b01, 8'b10101010,8'b10111111}; //14 reads
    8'd114  :   mem_out = {2'b00, 8'b10100000,8'b01010111}; //14 reads
    8'd115  :   mem_out = {2'b00, 8'b00000010,8'b01101111}; //14 reads
    8'd116  :   mem_out = {2'b00, 8'b10101010,8'b11000000}; //14 reads
    8'd117  :   mem_out = {2'b00, 8'b10000000,8'b10000100}; //14 reads
    8'd118  :   mem_out = {2'b00, 8'b00001010,8'b00110001}; //14 reads
    8'd119  :   mem_out = {2'b00, 8'b10101010,8'b01000111}; //14 reads
    8'd120  :   mem_out = {2'b00, 8'b00000000,8'b00100101}; //14 reads
    8'd121  :   mem_out = {2'b00, 8'b00101010,8'b10011010}; //14 reads
    8'd122  :   mem_out = {2'b00, 8'b10101000,8'b01111010}; //14 reads
    8'd123  :   mem_out = {2'b00, 8'b00000000,8'b10010101}; //14 reads
    8'd124  :   mem_out = {2'b00, 8'b10101010,8'b11011011}; //14 reads
    8'd125  :   mem_out = {2'b00, 8'b10100000,8'b11110000}; //14 reads
    8'd126  :   mem_out = {2'b10, 8'b00000010,8'b00100001}; //14 reads
    // ISI pattern (Back-to-back reads)
    // content format
    //        {aggressor pattern, victim pattern}
    8'd127  :   mem_out = {2'b01, 8'b01010111,8'b01010111};
    8'd128  :   mem_out = {2'b00, 8'b01101111,8'b01101111};
    8'd129  :   mem_out = {2'b00, 8'b11000000,8'b11000000};
    8'd130  :   mem_out = {2'b00, 8'b10000110,8'b10000100};
    8'd131  :   mem_out = {2'b00, 8'b00101000,8'b00110001};
    8'd132  :   mem_out = {2'b00, 8'b11100100,8'b01000111};
    8'd133  :   mem_out = {2'b00, 8'b10110011,8'b00100101};
    8'd134  :   mem_out = {2'b00, 8'b01001111,8'b10011011};
    8'd135  :   mem_out = {2'b00, 8'b10110101,8'b01010101};
    8'd136  :   mem_out = {2'b00, 8'b10110101,8'b01010101};
    8'd137  :   mem_out = {2'b00, 8'b10000111,8'b10011000};
    8'd138  :   mem_out = {2'b00, 8'b11100011,8'b00011100};
    8'd139  :   mem_out = {2'b00, 8'b00001010,8'b11110101};
    8'd140  :   mem_out = {2'b00, 8'b11010100,8'b00101011};
    8'd141  :   mem_out = {2'b00, 8'b01001000,8'b10110111};
    8'd142  :   mem_out = {2'b00, 8'b00011111,8'b11100000};
    8'd143  :   mem_out = {2'b00, 8'b10111100,8'b01000011};
    8'd144  :   mem_out = {2'b00, 8'b10001111,8'b00010100};
    8'd145  :   mem_out = {2'b00, 8'b10110100,8'b01001011};
    8'd146  :   mem_out = {2'b00, 8'b11001011,8'b00110100};
    8'd147  :   mem_out = {2'b00, 8'b00001010,8'b11110101};
    8'd148  :   mem_out = {2'b00, 8'b10000000,8'b00000000};
    //Additional for ISI 
    8'd149  :   mem_out = {2'b00, 8'b00000000,8'b00000000};
    8'd150  :   mem_out = {2'b00, 8'b01010101,8'b01010101};
    8'd151  :   mem_out = {2'b00, 8'b01010101,8'b01010101};
    8'd152  :   mem_out = {2'b00, 8'b00000000,8'b00000000};
    8'd153  :   mem_out = {2'b00, 8'b00000000,8'b00000000};
    8'd154  :   mem_out = {2'b00, 8'b01010101,8'b00101010};
    8'd155  :   mem_out = {2'b00, 8'b01010101,8'b10101010};
    8'd156  :   mem_out = {2'b10, 8'b00000000,8'b10000000};
    //Available
    8'd157  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd158  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd159  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd160  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd161  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd162  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd163  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd164  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd165  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd166  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd167  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd168  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd169  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd170  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd171  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd172  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd173  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd174  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd175  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd176  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd177  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd178  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd179  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd180  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd181  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd182  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd183  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd184  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd185  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd186  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd187  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd188  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd189  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd190  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd191  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd192  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd193  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd194  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd195  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd196  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd197  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd198  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd199  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd200  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd201  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd202  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd203  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd204  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd205  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd206  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd207  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd208  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd209  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd210  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd211  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd212  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd213  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd214  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd215  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd216  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd217  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd218  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd219  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd220  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd221  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd222  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd223  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd224  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd225  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd226  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd227  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd228  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd229  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd230  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd231  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd232  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd233  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd234  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd235  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd236  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd237  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd238  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd239  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd240  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd241  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd242  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd243  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd244  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd245  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd246  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd247  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd248  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd249  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd250  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd251  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd252  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd253  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd254  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
    8'd255  :   mem_out = {2'b00, 8'b00000001,8'b00000001};
  endcase
end



always @ (posedge clk_i) begin
  if (rst_i | reset_rd_addr)
    rd_addr <= #TCQ 'b0;
  //rd_addr for complex oclkdelay calib
  else if (clk_en_i && prbs_rdlvl_done && (~phy_if_empty_r || ~complex_wr_done)) begin
    if (rd_addr == 'd156) rd_addr <= #TCQ 'b0;
    else rd_addr <= #TCQ rd_addr + 1;
  end
  //rd_addr for complex rdlvl
  else  if (clk_en_i && (~phy_if_empty_r || (~prbs_rdlvl_start && ~complex_wr_done))) begin
    if (rd_addr == 'd148) rd_addr <= #TCQ 'b0;
    else rd_addr <= #TCQ rd_addr+1;    
  end

end

// Each pattern can be disabled independently
// When disabled zeros are written to and read from the DRAM 
always @ (posedge clk_i) begin
  if ((rd_addr < 42) && VCCO_PAT_EN)
    dout_o <= #TCQ mem_out[BRAM_DATA_WIDTH-3:0];
  else if ((rd_addr < 127) && VCCAUX_PAT_EN)
    dout_o <= #TCQ mem_out[BRAM_DATA_WIDTH-3:0];
  else if (ISI_PAT_EN && (rd_addr > 126))
    dout_o <= #TCQ mem_out[BRAM_DATA_WIDTH-3:0];
  else
    dout_o <= #TCQ 'd0;
end

reg prbs_ignore_first_byte_r;
always @(posedge clk_i) prbs_ignore_first_byte_r <= #TCQ mem_out[16];
assign prbs_ignore_first_byte = prbs_ignore_first_byte_r;

reg prbs_ignore_last_bytes_r;
always @(posedge clk_i) prbs_ignore_last_bytes_r <= #TCQ mem_out[17];
assign prbs_ignore_last_bytes = prbs_ignore_last_bytes_r;
   
   

generate
  if (FIXED_VICTIM == "TRUE") begin: victim_sel_fixed
    // Fixed victim bit 3
    always @(posedge clk_i)
      sel   <= #TCQ {DQ_WIDTH/8{8'h08}};
  end else begin: victim_sel_rotate
    // One-hot victim select
    always @(posedge clk_i)
      if (rst_i)
        sel   <= #TCQ 'd0;
      else begin  
	    for (i = 0; i < DQ_WIDTH/8; i = i+1) begin
	      for (j=0; j <8 ; j = j+1) begin
	        if (j == victim_sel)
		      sel[i*8+j] <= #TCQ 1'b1;
		    else 
		      sel[i*8+j] <= #TCQ 1'b0;
		    end   	
	     end
      end
  end
endgenerate
  


// construct 8 X DATA_WIDTH output bus
always @(*)
  for (i = 0; i < DQ_WIDTH; i = i+1) begin
    dout_rise0[i] = (dout_o[7]&&sel[i] || dout_o[15]&&~sel[i]);
    dout_fall0[i] = (dout_o[6]&&sel[i] || dout_o[14]&&~sel[i]);
    dout_rise1[i] = (dout_o[5]&&sel[i] || dout_o[13]&&~sel[i]);
    dout_fall1[i] = (dout_o[4]&&sel[i] || dout_o[12]&&~sel[i]);
    dout_rise2[i] = (dout_o[3]&&sel[i] || dout_o[11]&&~sel[i]);
    dout_fall2[i] = (dout_o[2]&&sel[i] || dout_o[10]&&~sel[i]);
    dout_rise3[i] = (dout_o[1]&&sel[i] || dout_o[9]&&~sel[i]);
    dout_fall3[i] = (dout_o[0]&&sel[i] || dout_o[8]&&~sel[i]);
  end


  assign prbs_o = {dout_fall3, dout_rise3, dout_fall2, dout_rise2, dout_fall1, dout_rise1, dout_fall0, dout_rise0};
  
  assign dbg_prbs_gen[9] = phy_if_empty_r;
  assign dbg_prbs_gen[8] = clk_en_i;
  assign dbg_prbs_gen[7:0] = rd_addr[7:0];

endmodule
   
         

