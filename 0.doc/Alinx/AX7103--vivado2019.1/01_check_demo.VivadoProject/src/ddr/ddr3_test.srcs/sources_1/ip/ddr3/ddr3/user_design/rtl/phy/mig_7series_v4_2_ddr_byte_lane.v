/***********************************************************
-- (c) Copyright 2010 - 2014 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). A Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.

//
//
//  Owner:        Gary Martin
//  Revision:     $Id: //depot/icm/proj/common/head/rtl/v32_cmt/rtl/phy/byte_lane.v#4 $
//                $Author: gary $
//                $DateTime: 2010/05/11 18:05:17 $
//                $Change: 490882 $
//  Description:
//    This verilog file is a parameterizable single 10 or 12 bit byte lane.
//
//  History:
//  Date        Engineer    Description
//  04/01/2010  G. Martin   Initial Checkin.
//
////////////////////////////////////////////////////////////
***********************************************************/


`timescale 1ps/1ps

//`include "phy.vh"

module mig_7series_v4_2_ddr_byte_lane #(
// these are used to scale the index into phaser,calib,scan,mc vectors
// to access fields used in this instance
      parameter ABCD                            = "A", // A,B,C, or D
      parameter PO_DATA_CTL                     = "FALSE",
      parameter BITLANES                        = 12'b1111_1111_1111,
      parameter BITLANES_OUTONLY                = 12'b1111_1111_1111,
      parameter BYTELANES_DDR_CK                = 24'b0010_0010_0010_0010_0010_0010,
      parameter RCLK_SELECT_LANE                = "B",
      parameter PC_CLK_RATIO                    = 4,
      parameter USE_PRE_POST_FIFO               = "FALSE",
//OUT_FIFO
      parameter OF_ALMOST_EMPTY_VALUE           = 1,
      parameter OF_ALMOST_FULL_VALUE            = 1,
      parameter OF_ARRAY_MODE                   = "UNDECLARED",
      parameter OF_OUTPUT_DISABLE               = "FALSE",
      parameter OF_SYNCHRONOUS_MODE             = "TRUE",
//IN_FIFO
      parameter IF_ALMOST_EMPTY_VALUE           = 1,
      parameter IF_ALMOST_FULL_VALUE            = 1,
      parameter IF_ARRAY_MODE                   = "UNDECLARED",
      parameter IF_SYNCHRONOUS_MODE             = "TRUE",
//PHASER_IN
      parameter PI_BURST_MODE                   = "TRUE",
      parameter PI_CLKOUT_DIV                   = 2,
      parameter PI_FREQ_REF_DIV                 = "NONE",
      parameter PI_FINE_DELAY                   = 1,
      parameter PI_OUTPUT_CLK_SRC               = "DELAYED_REF" , //"DELAYED_REF",
      parameter PI_SEL_CLK_OFFSET               = 0,

      parameter PI_SYNC_IN_DIV_RST              = "FALSE",
//PHASER_OUT
      parameter PO_CLKOUT_DIV                   = (PO_DATA_CTL == "FALSE") ? 4 :  2,
      parameter PO_FINE_DELAY                   = 0,
      parameter PO_COARSE_BYPASS                = "FALSE",
      parameter PO_COARSE_DELAY                 = 0,
      parameter PO_OCLK_DELAY                   = 0,
      parameter PO_OCLKDELAY_INV                = "TRUE",
      parameter PO_OUTPUT_CLK_SRC               = "DELAYED_REF",
      parameter PO_SYNC_IN_DIV_RST              = "FALSE",
//    OSERDES
      parameter OSERDES_DATA_RATE               = "DDR",
      parameter OSERDES_DATA_WIDTH              = 4,

//IDELAY
      parameter IDELAYE2_IDELAY_TYPE            = "VARIABLE",
      parameter IDELAYE2_IDELAY_VALUE           = 00,
      parameter IODELAY_GRP                     = "IODELAY_MIG",
      parameter FPGA_SPEED_GRADE                = 1,
      parameter BANK_TYPE                       = "HP_IO", // # = "HP_IO", "HPL_IO", "HR_IO", "HRL_IO"
      parameter real   TCK                      = 0.00,
      parameter SYNTHESIS                       = "FALSE",

// local constants, do not pass in from above
      parameter BUS_WIDTH                       =  12,
      parameter MSB_BURST_PEND_PO               =  3,
      parameter MSB_BURST_PEND_PI               =  7,
      parameter MSB_RANK_SEL_I                  =  MSB_BURST_PEND_PI + 8,
      parameter PHASER_CTL_BUS_WIDTH            =  MSB_RANK_SEL_I + 1
      ,parameter CKE_ODT_AUX = "FALSE"
      ,parameter PI_DIV2_INCDEC = "FALSE"
    )(
      input                        rst,
      input                        phy_clk,
      input                        rst_pi_div2,
      input                        clk_div2,
      input                        freq_refclk,
      input                        mem_refclk,
      input                        idelayctrl_refclk,
      input                        sync_pulse,
      output [BUS_WIDTH-1:0]       mem_dq_out,
      output [BUS_WIDTH-1:0]       mem_dq_ts,
      input  [9:0]                 mem_dq_in,
      output                       mem_dqs_out,
      output                       mem_dqs_ts,
      input                        mem_dqs_in,
      output [11:0]                ddr_ck_out,
      output                       rclk,
      input                        if_empty_def,
      output                       if_a_empty,
      output                       if_empty,
      output                       if_a_full,
      output                       if_full,
      output                       of_a_empty,
      output                       of_empty,
      output                       of_a_full,
      output                       of_full,
      output                       pre_fifo_a_full,
      output [79:0]                phy_din,
      input  [79:0]                phy_dout,
      input                        phy_cmd_wr_en,
      input                        phy_data_wr_en,
      input                        phy_rd_en,
      input [PHASER_CTL_BUS_WIDTH-1:0] phaser_ctl_bus,
      input                        idelay_inc,
      input                        idelay_ce,
      input                        idelay_ld,
      input                        if_rst,
      input [2:0]                  byte_rd_en_oth_lanes,
      input [1:0]                  byte_rd_en_oth_banks,
      output                       byte_rd_en,

      output                       po_coarse_overflow,
      output                       po_fine_overflow,
      output [8:0]                 po_counter_read_val,
      input                        po_fine_enable,
      input                        po_coarse_enable,
      input  [1:0]                 po_en_calib,
      input                        po_fine_inc,
      input                        po_coarse_inc,
      input                        po_counter_load_en,
      input                        po_counter_read_en,
      input                        po_sel_fine_oclk_delay,
      input  [8:0]                 po_counter_load_val,

      input  [1:0]                 pi_en_calib,
      input                        pi_rst_dqs_find,
      input                        pi_fine_enable,
      input                        pi_fine_inc,
      input                        pi_counter_load_en,
      input                        pi_counter_read_en,
      input  [5:0]                 pi_counter_load_val,

      output wire                  pi_iserdes_rst,
      output                       pi_phase_locked,
      output                       pi_fine_overflow,
      output [5:0]                 pi_counter_read_val,
      output wire                  pi_dqs_found,
      output                       dqs_out_of_range,
      input [29:0]                 fine_delay,
      input                        fine_delay_sel
);

localparam  PHASER_INDEX =
                      (ABCD=="B" ? 1 : (ABCD == "C") ? 2 : (ABCD == "D" ? 3 : 0));
localparam   L_OF_ARRAY_MODE =
              (OF_ARRAY_MODE != "UNDECLARED") ? OF_ARRAY_MODE :
                      (PO_DATA_CTL == "FALSE" || PC_CLK_RATIO == 2) ?   "ARRAY_MODE_4_X_4" : "ARRAY_MODE_8_X_4";
localparam   L_IF_ARRAY_MODE = (IF_ARRAY_MODE != "UNDECLARED") ? IF_ARRAY_MODE :
                                 (PC_CLK_RATIO == 2) ? "ARRAY_MODE_4_X_4" : "ARRAY_MODE_4_X_8";

localparam   L_OSERDES_DATA_RATE  = (OSERDES_DATA_RATE != "UNDECLARED")  ? OSERDES_DATA_RATE :  ((PO_DATA_CTL == "FALSE" && PC_CLK_RATIO == 4)  ? "SDR" : "DDR") ;
localparam   L_OSERDES_DATA_WIDTH = (OSERDES_DATA_WIDTH != "UNDECLARED") ? OSERDES_DATA_WIDTH : 4;
localparam   real L_FREQ_REF_PERIOD_NS = (TCK >= 2500.0) ? (TCK/(PI_FREQ_REF_DIV == "DIV2" ? 2 : 1)/1000.0) : TCK/1000.0; // DIV2 change
localparam   real L_MEM_REF_PERIOD_NS = TCK/1000.0;
localparam   real L_PHASE_REF_PERIOD_NS = TCK/1000.0;
localparam   ODDR_CLK_EDGE              = "SAME_EDGE";
localparam   PO_DCD_CORRECTION    = "ON";
localparam   [2:0] PO_DCD_SETTING = (PO_DCD_CORRECTION == "ON") ? 3'b111 : 3'b000;

localparam   DQS_AUTO_RECAL = (BANK_TYPE == "HR_IO" || BANK_TYPE == "HRL_IO" || (BANK_TYPE == "HPL_IO" && TCK >= 2500)) ? 1 : 0; // DIV2 change
localparam   DQS_FIND_PATTERN = (BANK_TYPE == "HR_IO" || BANK_TYPE == "HRL_IO" || (BANK_TYPE == "HPL_IO" && TCK >= 2500)) ? "001" : "000"; // DIV2 change

wire [1:0]                         oserdes_dqs;
wire [1:0]                         oserdes_dqs_ts;
wire [1:0]                         oserdes_dq_ts;

wire [3:0]                         of_q9;
wire [3:0]                         of_q8;
wire [3:0]                         of_q7;
wire [7:0]                         of_q6;
wire [7:0]                         of_q5;
wire [3:0]                         of_q4;
wire [3:0]                         of_q3;
wire [3:0]                         of_q2;
wire [3:0]                         of_q1;
wire [3:0]                         of_q0;
wire [7:0]                         of_d9;
wire [7:0]                         of_d8;
wire [7:0]                         of_d7;
wire [7:0]                         of_d6;
wire [7:0]                         of_d5;
wire [7:0]                         of_d4;
wire [7:0]                         of_d3;
wire [7:0]                         of_d2;
wire [7:0]                         of_d1;
wire [7:0]                         of_d0;

wire [7:0]                         if_q9;
wire [7:0]                         if_q8;
wire [7:0]                         if_q7;
wire [7:0]                         if_q6;
wire [7:0]                         if_q5;
wire [7:0]                         if_q4;
wire [7:0]                         if_q3;
wire [7:0]                         if_q2;
wire [7:0]                         if_q1;
wire [7:0]                         if_q0;
wire [3:0]                         if_d9;
wire [3:0]                         if_d8;
wire [3:0]                         if_d7;
wire [3:0]                         if_d6;
wire [3:0]                         if_d5;
wire [3:0]                         if_d4;
wire [3:0]                         if_d3;
wire [3:0]                         if_d2;
wire [3:0]                         if_d1;
wire [3:0]                         if_d0;

wire [3:0]                         dummy_i5;
wire [3:0]                         dummy_i6;

wire [48-1:0]                      of_dqbus;
wire [10*4-1:0]                    iserdes_dout;

wire                               iserdes_clk;
wire                               iserdes_clkdiv;
wire                               ififo_wr_enable;
wire                               phy_rd_en_;


wire                               dqs_to_phaser;
wire                               phy_wr_en = ( PO_DATA_CTL == "FALSE" ) ? phy_cmd_wr_en  : phy_data_wr_en;
wire                               if_empty_;
wire                               if_a_empty_;
wire                               if_full_;
wire                               if_a_full_;
wire                               po_oserdes_rst;
wire                               empty_post_fifo;
reg  [3:0]    if_empty_r /* synthesis syn_maxfan = 3 */;
wire   [79:0]                      rd_data;
reg    [79:0]                      rd_data_r;

reg                                ififo_rst = 1'b1;
reg                                ofifo_rst = 1'b1;

wire                               of_wren_pre;
wire   [79:0]                      pre_fifo_dout;
wire                               pre_fifo_full;
wire                               pre_fifo_rden;
wire   [5:0]                       ddr_ck_out_q;
wire                               ififo_rd_en_in /* synthesis syn_maxfan = 10 */;
wire oserdes_clkdiv;
wire oserdes_clk_delayed;
wire po_rd_enable;

always @(posedge phy_clk)  begin
   ififo_rst <= #1  pi_rst_dqs_find | if_rst ;
// reset only data o-fifos on reset of dqs_found
   ofifo_rst <= #1 (pi_rst_dqs_find & PO_DATA_CTL == "TRUE") | rst;
end

// IN_FIFO EMPTY->RDEN TIMING FIX:
// Always read from IN_FIFO - it doesn't hurt to read from an empty FIFO
// since the IN_FIFO read pointers are not incr'ed when the FIFO is empty
assign #(25) phy_rd_en_ = 1'b1;
//assign #(25) phy_rd_en_ = phy_rd_en;

generate
if ( PO_DATA_CTL == "FALSE" ) begin : if_empty_null
    assign if_empty = 0;
    assign if_a_empty = 0;
    assign if_full = 0;
    assign if_a_full = 0;
end
else begin : if_empty_gen
    assign if_empty   = empty_post_fifo;
    assign if_a_empty = if_a_empty_;
    assign if_full    = if_full_;
    assign if_a_full  = if_a_full_;
end
endgenerate

generate
if ( PO_DATA_CTL == "FALSE" ) begin : dq_gen_48
   assign of_dqbus[48-1:0] = {of_q6[7:4], of_q5[7:4], of_q9, of_q8, of_q7, of_q6[3:0], of_q5[3:0], of_q4, of_q3, of_q2, of_q1, of_q0};
   assign phy_din =  80'h0;
   assign byte_rd_en = 1'b1;
end
else begin : dq_gen_40

  assign of_dqbus[40-1:0] = {of_q9, of_q8, of_q7, of_q6[3:0], of_q5[3:0], of_q4, of_q3, of_q2, of_q1, of_q0};
  assign ififo_rd_en_in   = !if_empty_def ? ((&byte_rd_en_oth_banks) && (&byte_rd_en_oth_lanes) && byte_rd_en) :
                                            ((|byte_rd_en_oth_banks) || (|byte_rd_en_oth_lanes) || byte_rd_en);

  if (USE_PRE_POST_FIFO == "TRUE") begin : if_post_fifo_gen

   // IN_FIFO EMPTY->RDEN TIMING FIX:
   assign rd_data =  {if_q9, if_q8, if_q7, if_q6, if_q5, if_q4, if_q3, if_q2, if_q1, if_q0};

   always @(posedge phy_clk) begin
     rd_data_r      <= #(025) rd_data;
     if_empty_r[0]  <= #(025) if_empty_;
     if_empty_r[1]  <= #(025) if_empty_;
     if_empty_r[2]  <= #(025) if_empty_;
     if_empty_r[3]  <= #(025) if_empty_;
   end


   mig_7series_v4_2_ddr_if_post_fifo #
     (
      .TCQ   (25),    // simulation CK->Q delay
      .DEPTH (4), //2     // depth - account for up to 2 cycles of skew
      .WIDTH (80)     // width
      )
     u_ddr_if_post_fifo
       (
        .clk       (phy_clk),
        .rst       (ififo_rst),
        .empty_in  (if_empty_r),
        .rd_en_in  (ififo_rd_en_in),
        .d_in      (rd_data_r),
        .empty_out (empty_post_fifo),
        .byte_rd_en (byte_rd_en),
        .d_out     (phy_din)
        );

  end
  else begin :  phy_din_gen
     assign phy_din =  {if_q9, if_q8, if_q7, if_q6, if_q5, if_q4, if_q3, if_q2, if_q1, if_q0};
     assign empty_post_fifo = if_empty_;
  end

end
endgenerate


assign { if_d9, if_d8, if_d7, if_d6, if_d5, if_d4, if_d3, if_d2, if_d1, if_d0} = iserdes_dout;


wire [1:0]  rank_sel_i  = ((phaser_ctl_bus[MSB_RANK_SEL_I :MSB_RANK_SEL_I -7] >> (PHASER_INDEX << 1)) & 2'b11);




generate

if ( USE_PRE_POST_FIFO == "TRUE" ) begin : of_pre_fifo_gen
  assign {of_d9, of_d8, of_d7, of_d6, of_d5, of_d4, of_d3, of_d2, of_d1, of_d0} = pre_fifo_dout;
  mig_7series_v4_2_ddr_of_pre_fifo #
    (
     .TCQ   (25),    // simulation CK->Q delay
     .DEPTH (9),     // depth - set to 9 to accommodate flow control
     .WIDTH (80)     // width
     )
    u_ddr_of_pre_fifo
        (
       .clk       (phy_clk),
       .rst       (ofifo_rst),
       .full_in   (of_full),
       .wr_en_in  (phy_wr_en),
       .d_in      (phy_dout),
       .wr_en_out (of_wren_pre),
       .d_out     (pre_fifo_dout),
       .afull     (pre_fifo_a_full)
       );
end
else begin
// wire direct to ofifo
  assign {of_d9, of_d8, of_d7, of_d6, of_d5, of_d4, of_d3, of_d2, of_d1, of_d0} = phy_dout;
  assign of_wren_pre = phy_wr_en;
end


endgenerate

///////////////////////////////////////////////////////////////////////////////
// Synchronize pi_phase_locked to phy_clk domain
///////////////////////////////////////////////////////////////////////////////
wire       pi_phase_locked_w;
wire       pi_dqs_found_w;
wire [5:0] pi_counter_read_val_w;
generate
  if (PI_DIV2_INCDEC == "TRUE") begin: phaser_in_div2_clk
    (* ASYNC_REG = "TRUE" *) reg  pi_phase_locked_r1;
    (* ASYNC_REG = "TRUE" *) reg  pi_phase_locked_r2;
    (* ASYNC_REG = "TRUE" *) reg  pi_phase_locked_r3;
    reg  pi_phase_locked_r4;

    (* ASYNC_REG = "TRUE" *) reg  pi_dqs_found_r1;
    (* ASYNC_REG = "TRUE" *) reg  pi_dqs_found_r2;
    (* ASYNC_REG = "TRUE" *) reg  pi_dqs_found_r3;
    reg  pi_dqs_found_r4;

    (* ASYNC_REG = "TRUE" *) reg [5:0] pi_counter_read_val_r1;
    (* ASYNC_REG = "TRUE" *) reg [5:0] pi_counter_read_val_r2;
    (* ASYNC_REG = "TRUE" *) reg [5:0] pi_counter_read_val_r3;
    reg [5:0] pi_counter_read_val_r4;

    always @ (posedge phy_clk) begin
      pi_phase_locked_r1 <= pi_phase_locked_w;
      pi_phase_locked_r2 <= pi_phase_locked_r1;
      pi_phase_locked_r3 <= pi_phase_locked_r2;
      pi_dqs_found_r1    <= pi_dqs_found_w;
      pi_dqs_found_r2    <= pi_dqs_found_r1;
      pi_dqs_found_r3    <= pi_dqs_found_r2;
      pi_counter_read_val_r1 <= pi_counter_read_val_w;
      pi_counter_read_val_r2 <= pi_counter_read_val_r1;
      pi_counter_read_val_r3 <= pi_counter_read_val_r2;
    end

    always @ (posedge phy_clk) begin
      if (rst)
        pi_phase_locked_r4 <= 1'b0;
      else if (pi_phase_locked_r2 == pi_phase_locked_r3)
        pi_phase_locked_r4 <= pi_phase_locked_r3;
    end

    always @ (posedge phy_clk) begin
      if (rst)
        pi_dqs_found_r4 <= 1'b0;
      else if (pi_dqs_found_r2 == pi_dqs_found_r3)
        pi_dqs_found_r4 <= pi_dqs_found_r3;
    end

    always @ (posedge phy_clk) begin
      if (rst)
        pi_counter_read_val_r4 <= 1'b0;
      else if (pi_counter_read_val_r2 == pi_counter_read_val_r3)
        pi_counter_read_val_r4 <= pi_counter_read_val_r3;
    end

    assign pi_phase_locked     = pi_phase_locked_r4;
    assign pi_dqs_found        = pi_dqs_found_r4;
    assign pi_counter_read_val = pi_counter_read_val_r4;

  end else begin: pahser_in_div4_clk
    assign pi_phase_locked     = pi_phase_locked_w;
    assign pi_dqs_found        = pi_dqs_found_w;
    assign pi_counter_read_val = pi_counter_read_val_w;
  end
endgenerate


generate

if ( PO_DATA_CTL == "TRUE" || ((RCLK_SELECT_LANE==ABCD) && (CKE_ODT_AUX =="TRUE")))  begin : phaser_in_gen

//if (PI_DIV2_INCDEC == "TRUE") begin: phaser_in_div2_sys_clk
if (PI_DIV2_INCDEC == "TRUE") begin

PHASER_IN_PHY #(
  .BURST_MODE                       ( PI_BURST_MODE),
  .CLKOUT_DIV                       ( PI_CLKOUT_DIV),
  .DQS_AUTO_RECAL                   ( DQS_AUTO_RECAL),
  .DQS_FIND_PATTERN                 ( DQS_FIND_PATTERN),
  .SEL_CLK_OFFSET                   ( PI_SEL_CLK_OFFSET),
  .FINE_DELAY                       ( PI_FINE_DELAY),
  .FREQ_REF_DIV                     ( PI_FREQ_REF_DIV),
  .OUTPUT_CLK_SRC                   ( PI_OUTPUT_CLK_SRC),
  .SYNC_IN_DIV_RST                  ( PI_SYNC_IN_DIV_RST),
  .REFCLK_PERIOD                    ( L_FREQ_REF_PERIOD_NS),
  .MEMREFCLK_PERIOD                 ( L_MEM_REF_PERIOD_NS),
  .PHASEREFCLK_PERIOD               ( L_PHASE_REF_PERIOD_NS)
) phaser_in (
  .DQSFOUND                         (pi_dqs_found_w),
  .DQSOUTOFRANGE                    (dqs_out_of_range),
  .FINEOVERFLOW                     (pi_fine_overflow),
  .PHASELOCKED                      (pi_phase_locked_w),
  .ISERDESRST                       (pi_iserdes_rst),
  .ICLKDIV                          (iserdes_clkdiv),
  .ICLK                             (iserdes_clk),
  .COUNTERREADVAL                   (pi_counter_read_val_w),
  .RCLK                             (rclk),
  .WRENABLE                         (ififo_wr_enable),
  .BURSTPENDINGPHY                  (phaser_ctl_bus[MSB_BURST_PEND_PI - 3 + PHASER_INDEX]),
  .ENCALIBPHY                       (pi_en_calib),
  .FINEENABLE                       (pi_fine_enable),
  .FREQREFCLK                       (freq_refclk),
  .MEMREFCLK                        (mem_refclk),
  .RANKSELPHY                       (rank_sel_i),
  .PHASEREFCLK                      (dqs_to_phaser),
  .RSTDQSFIND                       (pi_rst_dqs_find),
  .RST                              (rst_pi_div2),
  .FINEINC                          (pi_fine_inc),
  .COUNTERLOADEN                    (pi_counter_load_en),
  .COUNTERREADEN                    (pi_counter_read_en),
  .COUNTERLOADVAL                   (pi_counter_load_val),
  .SYNCIN                           (sync_pulse),
  .SYSCLK                           (clk_div2)
);
end

else begin

PHASER_IN_PHY #(
  .BURST_MODE                       ( PI_BURST_MODE),
  .CLKOUT_DIV                       ( PI_CLKOUT_DIV),
  .DQS_AUTO_RECAL                   ( DQS_AUTO_RECAL),
  .DQS_FIND_PATTERN                 ( DQS_FIND_PATTERN),
  .SEL_CLK_OFFSET                   ( PI_SEL_CLK_OFFSET),
  .FINE_DELAY                       ( PI_FINE_DELAY),
  .FREQ_REF_DIV                     ( PI_FREQ_REF_DIV),
  .OUTPUT_CLK_SRC                   ( PI_OUTPUT_CLK_SRC),
  .SYNC_IN_DIV_RST                  ( PI_SYNC_IN_DIV_RST),
  .REFCLK_PERIOD                    ( L_FREQ_REF_PERIOD_NS),
  .MEMREFCLK_PERIOD                 ( L_MEM_REF_PERIOD_NS),
  .PHASEREFCLK_PERIOD               ( L_PHASE_REF_PERIOD_NS)
) phaser_in (
  .DQSFOUND                         (pi_dqs_found_w),
  .DQSOUTOFRANGE                    (dqs_out_of_range),
  .FINEOVERFLOW                     (pi_fine_overflow),
  .PHASELOCKED                      (pi_phase_locked_w),
  .ISERDESRST                       (pi_iserdes_rst),
  .ICLKDIV                          (iserdes_clkdiv),
  .ICLK                             (iserdes_clk),
  .COUNTERREADVAL                   (pi_counter_read_val_w),
  .RCLK                             (rclk),
  .WRENABLE                         (ififo_wr_enable),
  .BURSTPENDINGPHY                  (phaser_ctl_bus[MSB_BURST_PEND_PI - 3 + PHASER_INDEX]),
  .ENCALIBPHY                       (pi_en_calib),
  .FINEENABLE                       (pi_fine_enable),
  .FREQREFCLK                       (freq_refclk),
  .MEMREFCLK                        (mem_refclk),
  .RANKSELPHY                       (rank_sel_i),
  .PHASEREFCLK                      (dqs_to_phaser),
  .RSTDQSFIND                       (pi_rst_dqs_find),
  .RST                              (rst),
  .FINEINC                          (pi_fine_inc),
  .COUNTERLOADEN                    (pi_counter_load_en),
  .COUNTERREADEN                    (pi_counter_read_en),
  .COUNTERLOADVAL                   (pi_counter_load_val),
  .SYNCIN                           (sync_pulse),
  .SYSCLK                           (phy_clk)
);

end
end
else begin
   assign pi_dqs_found_w = 1'b1;
//   assign pi_dqs_out_of_range = 1'b0;
   assign pi_phase_locked_w = 1'b1;
end

endgenerate

wire  #0 phase_ref = freq_refclk;

wire oserdes_clk;


PHASER_OUT_PHY #(
  .CLKOUT_DIV                        ( PO_CLKOUT_DIV),
  .DATA_CTL_N                        ( PO_DATA_CTL ),
  .FINE_DELAY                        ( PO_FINE_DELAY),
  .COARSE_BYPASS                     ( PO_COARSE_BYPASS ),
  .COARSE_DELAY                      ( PO_COARSE_DELAY),
  .OCLK_DELAY                        ( PO_OCLK_DELAY),
  .OCLKDELAY_INV                     ( PO_OCLKDELAY_INV),
  .OUTPUT_CLK_SRC                    ( PO_OUTPUT_CLK_SRC),
  .SYNC_IN_DIV_RST                   ( PO_SYNC_IN_DIV_RST),
  .REFCLK_PERIOD                     ( L_FREQ_REF_PERIOD_NS),
  .PHASEREFCLK_PERIOD                ( 1), // dummy, not used
  .PO                                ( PO_DCD_SETTING ),
  .MEMREFCLK_PERIOD                  ( L_MEM_REF_PERIOD_NS)
) phaser_out (
  .COARSEOVERFLOW                    (po_coarse_overflow),
  .CTSBUS                            (oserdes_dqs_ts),
  .DQSBUS                            (oserdes_dqs),
  .DTSBUS                            (oserdes_dq_ts),
  .FINEOVERFLOW                      (po_fine_overflow),
  .OCLKDIV                           (oserdes_clkdiv),
  .OCLK                              (oserdes_clk),
  .OCLKDELAYED                       (oserdes_clk_delayed),
  .COUNTERREADVAL                    (po_counter_read_val),
  .BURSTPENDINGPHY                   (phaser_ctl_bus[MSB_BURST_PEND_PO -3 + PHASER_INDEX]),
  .ENCALIBPHY                        (po_en_calib),
  .RDENABLE                          (po_rd_enable),
  .FREQREFCLK                        (freq_refclk),
  .MEMREFCLK                         (mem_refclk),
  .PHASEREFCLK                       (/*phase_ref*/),
  .RST                               (rst),
  .OSERDESRST                        (po_oserdes_rst),
  .COARSEENABLE                      (po_coarse_enable),
  .FINEENABLE                        (po_fine_enable),
  .COARSEINC                         (po_coarse_inc),
  .FINEINC                           (po_fine_inc),
  .SELFINEOCLKDELAY                  (po_sel_fine_oclk_delay),
  .COUNTERLOADEN                     (po_counter_load_en),
  .COUNTERREADEN                     (po_counter_read_en),
  .COUNTERLOADVAL                    (po_counter_load_val),
  .SYNCIN                            (sync_pulse),
  .SYSCLK                            (phy_clk)
);


generate

if (PO_DATA_CTL == "TRUE")   begin : in_fifo_gen

IN_FIFO #(
  .ALMOST_EMPTY_VALUE                ( IF_ALMOST_EMPTY_VALUE ),
  .ALMOST_FULL_VALUE                 ( IF_ALMOST_FULL_VALUE ),
  .ARRAY_MODE                        ( L_IF_ARRAY_MODE),
  .SYNCHRONOUS_MODE                  ( IF_SYNCHRONOUS_MODE)
) in_fifo  (
  .ALMOSTEMPTY                       (if_a_empty_),
  .ALMOSTFULL                        (if_a_full_),
  .EMPTY                             (if_empty_),
  .FULL                              (if_full_),
  .Q0                                (if_q0),
  .Q1                                (if_q1),
  .Q2                                (if_q2),
  .Q3                                (if_q3),
  .Q4                                (if_q4),
  .Q5                                (if_q5),
  .Q6                                (if_q6),
  .Q7                                (if_q7),
  .Q8                                (if_q8),
  .Q9                                (if_q9),
//===
  .D0                                (if_d0),
  .D1                                (if_d1),
  .D2                                (if_d2),
  .D3                                (if_d3),
  .D4                                (if_d4),
  .D5                                ({dummy_i5,if_d5}),
  .D6                                ({dummy_i6,if_d6}),
  .D7                                (if_d7),
  .D8                                (if_d8),
  .D9                                (if_d9),
  .RDCLK                             (phy_clk),
  .RDEN                              (phy_rd_en_),
  .RESET                             (ififo_rst),
  .WRCLK                             (iserdes_clkdiv),
  .WREN                              (ififo_wr_enable)
);
end

endgenerate



OUT_FIFO #(
  .ALMOST_EMPTY_VALUE             (OF_ALMOST_EMPTY_VALUE),
  .ALMOST_FULL_VALUE              (OF_ALMOST_FULL_VALUE),
  .ARRAY_MODE                     (L_OF_ARRAY_MODE),
  .OUTPUT_DISABLE                 (OF_OUTPUT_DISABLE),
  .SYNCHRONOUS_MODE               (OF_SYNCHRONOUS_MODE)
) out_fifo (
  .ALMOSTEMPTY                    (of_a_empty),
  .ALMOSTFULL                     (of_a_full),
  .EMPTY                          (of_empty),
  .FULL                           (of_full),
  .Q0                             (of_q0),
  .Q1                             (of_q1),
  .Q2                             (of_q2),
  .Q3                             (of_q3),
  .Q4                             (of_q4),
  .Q5                             (of_q5),
  .Q6                             (of_q6),
  .Q7                             (of_q7),
  .Q8                             (of_q8),
  .Q9                             (of_q9),
  .D0                             (of_d0),
  .D1                             (of_d1),
  .D2                             (of_d2),
  .D3                             (of_d3),
  .D4                             (of_d4),
  .D5                             (of_d5),
  .D6                             (of_d6),
  .D7                             (of_d7),
  .D8                             (of_d8),
  .D9                             (of_d9),
  .RDCLK                          (oserdes_clkdiv),
  .RDEN                           (po_rd_enable),
  .RESET                          (ofifo_rst),
  .WRCLK                          (phy_clk),
  .WREN                           (of_wren_pre)
);


mig_7series_v4_2_ddr_byte_group_io   #
   (
   .PO_DATA_CTL             (PO_DATA_CTL),
   .BITLANES                (BITLANES),
   .BITLANES_OUTONLY        (BITLANES_OUTONLY),
   .OSERDES_DATA_RATE       (L_OSERDES_DATA_RATE),
   .OSERDES_DATA_WIDTH      (L_OSERDES_DATA_WIDTH),
   .IODELAY_GRP             (IODELAY_GRP),
   .FPGA_SPEED_GRADE        (FPGA_SPEED_GRADE),
   .IDELAYE2_IDELAY_TYPE    (IDELAYE2_IDELAY_TYPE),
   .IDELAYE2_IDELAY_VALUE   (IDELAYE2_IDELAY_VALUE),
   .TCK                     (TCK),
   .SYNTHESIS               (SYNTHESIS)
   )
   ddr_byte_group_io
   (
   .mem_dq_out               (mem_dq_out),
   .mem_dq_ts                (mem_dq_ts),
   .mem_dq_in                (mem_dq_in),
   .mem_dqs_in               (mem_dqs_in),
   .mem_dqs_out              (mem_dqs_out),
   .mem_dqs_ts               (mem_dqs_ts),
   .rst                      (rst),
   .oserdes_rst              (po_oserdes_rst),
   .iserdes_rst              (pi_iserdes_rst ),
   .iserdes_dout             (iserdes_dout),
   .dqs_to_phaser            (dqs_to_phaser),
   .phy_clk                  (phy_clk),
   .iserdes_clk              (iserdes_clk),
   .iserdes_clkb             (!iserdes_clk),
   .iserdes_clkdiv           (iserdes_clkdiv),
   .idelay_inc               (idelay_inc),
   .idelay_ce                (idelay_ce),
   .idelay_ld                (idelay_ld),
   .idelayctrl_refclk        (idelayctrl_refclk),
   .oserdes_clk              (oserdes_clk),
   .oserdes_clk_delayed      (oserdes_clk_delayed),
   .oserdes_clkdiv           (oserdes_clkdiv),
   .oserdes_dqs              ({oserdes_dqs[1], oserdes_dqs[0]}),
   .oserdes_dqsts            ({oserdes_dqs_ts[1], oserdes_dqs_ts[0]}),
   .oserdes_dq               (of_dqbus),
   .oserdes_dqts             ({oserdes_dq_ts[1], oserdes_dq_ts[0]}),
   .fine_delay               (fine_delay),
   .fine_delay_sel           (fine_delay_sel)
    );

genvar i;
generate
  for (i = 0; i <= 5; i = i+1) begin : ddr_ck_gen_loop
    if (PO_DATA_CTL== "FALSE" && (BYTELANES_DDR_CK[i*4+PHASER_INDEX])) begin : ddr_ck_gen
      ODDR #(.DDR_CLK_EDGE  (ODDR_CLK_EDGE))
        ddr_ck (
        .C    (oserdes_clk),
        .R    (1'b0),
        .S    (),
        .D1   (1'b0),
        .D2   (1'b1),
        .CE   (1'b1),
        .Q    (ddr_ck_out_q[i])
      );
      OBUFDS ddr_ck_obuf  (.I(ddr_ck_out_q[i]), .O(ddr_ck_out[i*2]), .OB(ddr_ck_out[i*2+1]));
    end // ddr_ck_gen
    else  begin : ddr_ck_null
      assign ddr_ck_out[i*2+1:i*2] = 2'b0;
    end
  end // ddr_ck_gen_loop
endgenerate

endmodule // byte_lane

