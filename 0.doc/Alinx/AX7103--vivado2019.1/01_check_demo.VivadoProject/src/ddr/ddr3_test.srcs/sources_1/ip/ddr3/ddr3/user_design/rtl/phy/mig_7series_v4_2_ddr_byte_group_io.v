/*****************************************************************
-- (c) Copyright 2011 - 2014 Xilinx, Inc. All rights reserved.
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
//  Revision:     $Id: //depot/icm/proj/common/head/rtl/v32_cmt/rtl/phy/byte_group_io.v#4 $
//                $Author: $
//                $DateTime: $
//                $Change: $
//  Description:
//    This verilog file is a paramertizable I/O termination for 
//    the single byte lane. 
//    to create a N byte-lane wide phy. 
//
//  History:
//  Date        Engineer    Description
//  04/01/2010  G. Martin   Initial Checkin.
//
//////////////////////////////////////////////////////////////////
*****************************************************************/

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_byte_group_io #(
// bit lane existance
    parameter  BITLANES                      =  12'b1111_1111_1111,
    parameter  BITLANES_OUTONLY              =  12'b0000_0000_0000,
    parameter  PO_DATA_CTL                   = "FALSE",
    parameter  OSERDES_DATA_RATE             = "DDR",
    parameter  OSERDES_DATA_WIDTH            = 4,
    parameter  IDELAYE2_IDELAY_TYPE          = "VARIABLE",
    parameter  IDELAYE2_IDELAY_VALUE         = 00,
    parameter  IODELAY_GRP                   = "IODELAY_MIG",
    parameter  FPGA_SPEED_GRADE              = 1,
    parameter  real TCK                      = 2500.0,
// local usage only, don't pass down
    parameter  BUS_WIDTH                     = 12,
    parameter  SYNTHESIS                     = "FALSE"
   )
   (
   input  [9:0]                    mem_dq_in,
   output [BUS_WIDTH-1:0]          mem_dq_out,
   output [BUS_WIDTH-1:0]          mem_dq_ts,
   input                           mem_dqs_in,
   output                          mem_dqs_out,
   output                          mem_dqs_ts,
   output [(4*10)-1:0]             iserdes_dout, // 2 extra 12-bit lanes not used
   output                          dqs_to_phaser,
   input                           iserdes_clk,
   input                           iserdes_clkb,
   input                           iserdes_clkdiv,
   input                           phy_clk,
   input                           rst,
   input                           oserdes_rst,
   input                           iserdes_rst,
   input [1:0]                     oserdes_dqs,
   input [1:0]                     oserdes_dqsts,
   input [(4*BUS_WIDTH)-1:0]       oserdes_dq,
   input [1:0]                     oserdes_dqts,
   input                           oserdes_clk,
   input                           oserdes_clk_delayed,
   input                           oserdes_clkdiv,
   input                           idelay_inc,
   input                           idelay_ce,
   input                           idelay_ld,
   input                           idelayctrl_refclk,
   input [29:0]                    fine_delay ,
   input                           fine_delay_sel
   );



/// INSTANCES


localparam    ISERDES_DQ_DATA_RATE          = "DDR";
localparam    ISERDES_DQ_DATA_WIDTH         = 4;
localparam    ISERDES_DQ_DYN_CLKDIV_INV_EN  = "FALSE";
localparam    ISERDES_DQ_DYN_CLK_INV_EN     = "FALSE";
localparam    ISERDES_DQ_INIT_Q1            = 1'b0;
localparam    ISERDES_DQ_INIT_Q2            = 1'b0;
localparam    ISERDES_DQ_INIT_Q3            = 1'b0;
localparam    ISERDES_DQ_INIT_Q4            = 1'b0;
localparam    ISERDES_DQ_INTERFACE_TYPE     = "MEMORY_DDR3";
localparam    ISERDES_NUM_CE                = 2;
localparam    ISERDES_DQ_IOBDELAY           = "IFD";
localparam    ISERDES_DQ_OFB_USED           = "FALSE";
localparam    ISERDES_DQ_SERDES_MODE        = "MASTER";
localparam    ISERDES_DQ_SRVAL_Q1           = 1'b0;
localparam    ISERDES_DQ_SRVAL_Q2           = 1'b0;
localparam    ISERDES_DQ_SRVAL_Q3           = 1'b0;
localparam    ISERDES_DQ_SRVAL_Q4           = 1'b0;

localparam    IDELAY_FINEDELAY_USE          = (TCK > 1500) ? "FALSE" : "TRUE";

wire [BUS_WIDTH-1:0]                    data_in_dly;
wire [BUS_WIDTH-1:0]                    oserdes_dq_buf;
wire [BUS_WIDTH-1:0]                    oserdes_dqts_buf;
wire                                    oserdes_dqs_buf;
wire                                    oserdes_dqsts_buf;
wire [9:0]                              data_in;
wire                                    tbyte_out;
reg [29:0]                              fine_delay_r;

assign mem_dq_out  = oserdes_dq_buf;
assign mem_dq_ts   = oserdes_dqts_buf;
assign data_in = mem_dq_in;

assign mem_dqs_out = oserdes_dqs_buf;
assign mem_dqs_ts  = oserdes_dqsts_buf;
assign dqs_to_phaser = mem_dqs_in;

reg iserdes_clk_d;

always @(*) 
   iserdes_clk_d = iserdes_clk;

reg  idelay_ld_rst;
reg  rst_r1;
reg  rst_r2;
reg  rst_r3;
reg  rst_r4;

always @(posedge phy_clk) begin
  rst_r1 <= #1 rst;
  rst_r2 <= #1 rst_r1;
  rst_r3 <= #1 rst_r2;
  rst_r4 <= #1 rst_r3;
end

always @(posedge phy_clk) begin
  if (rst)
    idelay_ld_rst <= #1 1'b1;
  else if (rst_r4)
    idelay_ld_rst <= #1 1'b0;
end    

always @ (posedge phy_clk) begin
 if(rst)
   fine_delay_r <= #1 1'b0;
 else if(fine_delay_sel)
   fine_delay_r <= #1 fine_delay;
end


genvar i;

generate

for ( i = 0; i != 10 && PO_DATA_CTL == "TRUE" ; i=i+1) begin : input_
  if ( BITLANES[i] && !BITLANES_OUTONLY[i]) begin  : iserdes_dq_

     ISERDESE2 #(
         .DATA_RATE                  ( ISERDES_DQ_DATA_RATE),
         .DATA_WIDTH                 ( ISERDES_DQ_DATA_WIDTH),
         .DYN_CLKDIV_INV_EN          ( ISERDES_DQ_DYN_CLKDIV_INV_EN),
         .DYN_CLK_INV_EN             ( ISERDES_DQ_DYN_CLK_INV_EN),
         .INIT_Q1                    ( ISERDES_DQ_INIT_Q1),
         .INIT_Q2                    ( ISERDES_DQ_INIT_Q2),
         .INIT_Q3                    ( ISERDES_DQ_INIT_Q3),
         .INIT_Q4                    ( ISERDES_DQ_INIT_Q4),
         .INTERFACE_TYPE             ( ISERDES_DQ_INTERFACE_TYPE),
         .NUM_CE                     ( ISERDES_NUM_CE),
         .IOBDELAY                   ( ISERDES_DQ_IOBDELAY),
         .OFB_USED                   ( ISERDES_DQ_OFB_USED),
         .SERDES_MODE                ( ISERDES_DQ_SERDES_MODE),
         .SRVAL_Q1                   ( ISERDES_DQ_SRVAL_Q1),
         .SRVAL_Q2                   ( ISERDES_DQ_SRVAL_Q2),
         .SRVAL_Q3                   ( ISERDES_DQ_SRVAL_Q3),
         .SRVAL_Q4                   ( ISERDES_DQ_SRVAL_Q4)
         )
         iserdesdq
         (
         .O                          (),
         .Q1                         (iserdes_dout[4*i + 3]),
         .Q2                         (iserdes_dout[4*i + 2]),
         .Q3                         (iserdes_dout[4*i + 1]),
         .Q4                         (iserdes_dout[4*i + 0]),
         .Q5                         (),
         .Q6                         (),
         .Q7                         (),
         .Q8                         (),
         .SHIFTOUT1                  (),
         .SHIFTOUT2                  (),
     
         .BITSLIP                    (1'b0),
         .CE1                        (1'b1),
         .CE2                        (1'b1),
         .CLK                        (iserdes_clk_d),
         .CLKB                       (!iserdes_clk_d),
         .CLKDIVP                    (iserdes_clkdiv),
         .CLKDIV                     (),
         .DDLY                       (data_in_dly[i]),
         .D                          (data_in[i]), // dedicated route to iob for debugging
	                                           // or as needed, select with IOBDELAY
         .DYNCLKDIVSEL               (1'b0),
         .DYNCLKSEL                  (1'b0),
// NOTE: OCLK is not used in this design, but is required to meet 
// a design rule check in map and bitgen. Do not disconnect it.
         .OCLK                       (oserdes_clk),
         .OCLKB                      (),
         .OFB                        (),
         .RST                        (1'b0),
//         .RST                        (iserdes_rst),
         .SHIFTIN1                   (1'b0),
         .SHIFTIN2                   (1'b0)
         );

localparam IDELAYE2_CINVCTRL_SEL          = "FALSE";
localparam IDELAYE2_DELAY_SRC             = "IDATAIN";
localparam IDELAYE2_HIGH_PERFORMANCE_MODE = "TRUE";
localparam IDELAYE2_PIPE_SEL              = "FALSE";
localparam IDELAYE2_ODELAY_TYPE           = "FIXED";
localparam IDELAYE2_REFCLK_FREQUENCY      = ((FPGA_SPEED_GRADE == 2 || FPGA_SPEED_GRADE == 3) && TCK <= 1500) ? 400.0 : 
                                             (FPGA_SPEED_GRADE == 1 && TCK <= 1500) ?  300.0 : 200.0;
localparam IDELAYE2_SIGNAL_PATTERN        = "DATA";
localparam IDELAYE2_FINEDELAY_IN          = "ADD_DLY";

    if(IDELAY_FINEDELAY_USE == "TRUE") begin: idelay_finedelay_dq
      (* IODELAY_GROUP = IODELAY_GRP *)
        IDELAYE2_FINEDELAY #(   
         .CINVCTRL_SEL             ( IDELAYE2_CINVCTRL_SEL),
         .DELAY_SRC                ( IDELAYE2_DELAY_SRC),
         .HIGH_PERFORMANCE_MODE    ( IDELAYE2_HIGH_PERFORMANCE_MODE),
         .IDELAY_TYPE              ( IDELAYE2_IDELAY_TYPE),
         .IDELAY_VALUE             ( IDELAYE2_IDELAY_VALUE),
         .PIPE_SEL                 ( IDELAYE2_PIPE_SEL),
         .FINEDELAY                ( IDELAYE2_FINEDELAY_IN),
         .REFCLK_FREQUENCY         ( IDELAYE2_REFCLK_FREQUENCY ),
         .SIGNAL_PATTERN           ( IDELAYE2_SIGNAL_PATTERN)
         )
         idelaye2
         (
         .CNTVALUEOUT              (),
         .DATAOUT                  (data_in_dly[i]),
         .C                        (phy_clk), // automatically wired by ISE
         .CE                       (idelay_ce),
         .CINVCTRL                 (),
         .CNTVALUEIN               (5'b00000), 
         .DATAIN                   (1'b0),
         .IDATAIN                  (data_in[i]),
         .IFDLY                    (fine_delay_r[i*3+:3]),
         .INC                      (idelay_inc),
         .LD                       (idelay_ld | idelay_ld_rst),
         .LDPIPEEN                 (1'b0),
         .REGRST                   (rst) 
     );
    end else begin : idelay_dq
      (* IODELAY_GROUP = IODELAY_GRP *)
        IDELAYE2 #(
         .CINVCTRL_SEL             ( IDELAYE2_CINVCTRL_SEL),
         .DELAY_SRC                ( IDELAYE2_DELAY_SRC),
         .HIGH_PERFORMANCE_MODE    ( IDELAYE2_HIGH_PERFORMANCE_MODE),
         .IDELAY_TYPE              ( IDELAYE2_IDELAY_TYPE),
         .IDELAY_VALUE             ( IDELAYE2_IDELAY_VALUE),
         .PIPE_SEL                 ( IDELAYE2_PIPE_SEL),
         .REFCLK_FREQUENCY         ( IDELAYE2_REFCLK_FREQUENCY ),
         .SIGNAL_PATTERN           ( IDELAYE2_SIGNAL_PATTERN)
         )
         idelaye2
         (
         .CNTVALUEOUT              (),
         .DATAOUT                  (data_in_dly[i]),
         .C                        (phy_clk), // automatically wired by ISE
         .CE                       (idelay_ce),
         .CINVCTRL                 (),
         .CNTVALUEIN               (5'b00000), 
         .DATAIN                   (1'b0),
         .IDATAIN                  (data_in[i]),
         .INC                      (idelay_inc),
         .LD                       (idelay_ld | idelay_ld_rst),
         .LDPIPEEN                 (1'b0),
         .REGRST                   (rst) 
     );

     end
    end // iserdes_dq
    else begin 
        assign iserdes_dout[4*i + 3] = 0;
        assign iserdes_dout[4*i + 2] = 0;
        assign iserdes_dout[4*i + 1] = 0;
        assign iserdes_dout[4*i + 0] = 0;
    end
end // input_
endgenerate			// iserdes_dq_

localparam OSERDES_DQ_DATA_RATE_OQ    = OSERDES_DATA_RATE;
localparam OSERDES_DQ_DATA_RATE_TQ    = OSERDES_DQ_DATA_RATE_OQ;
localparam OSERDES_DQ_DATA_WIDTH      = OSERDES_DATA_WIDTH;
localparam OSERDES_DQ_INIT_OQ         = 1'b1;
localparam OSERDES_DQ_INIT_TQ         = 1'b1;
localparam OSERDES_DQ_INTERFACE_TYPE  = "DEFAULT";
localparam OSERDES_DQ_ODELAY_USED     = 0;
localparam OSERDES_DQ_SERDES_MODE     = "MASTER";
localparam OSERDES_DQ_SRVAL_OQ        = 1'b1;
localparam OSERDES_DQ_SRVAL_TQ        = 1'b1;
// note: obuf used in control path case, no ts input so width irrelevant
localparam OSERDES_DQ_TRISTATE_WIDTH  = (OSERDES_DQ_DATA_RATE_OQ == "DDR") ? 4 : 1;

localparam OSERDES_DQS_DATA_RATE_OQ   = "DDR";
localparam OSERDES_DQS_DATA_RATE_TQ   = "DDR";
localparam OSERDES_DQS_TRISTATE_WIDTH = 4;	// this is always ddr
localparam OSERDES_DQS_DATA_WIDTH     = 4;
localparam ODDR_CLK_EDGE              = "SAME_EDGE";
localparam OSERDES_TBYTE_CTL          = "TRUE";


generate 

localparam NUM_BITLANES = PO_DATA_CTL == "TRUE" ? 10 : BUS_WIDTH;

     if ( PO_DATA_CTL == "TRUE" ) begin  : slave_ts
           OSERDESE2 #(
               .DATA_RATE_OQ         (OSERDES_DQ_DATA_RATE_OQ),
               .DATA_RATE_TQ         (OSERDES_DQ_DATA_RATE_TQ),
               .DATA_WIDTH           (OSERDES_DQ_DATA_WIDTH),
               .INIT_OQ              (OSERDES_DQ_INIT_OQ),
               .INIT_TQ              (OSERDES_DQ_INIT_TQ),
               .SERDES_MODE          (OSERDES_DQ_SERDES_MODE),
               .SRVAL_OQ             (OSERDES_DQ_SRVAL_OQ),
               .SRVAL_TQ             (OSERDES_DQ_SRVAL_TQ),
               .TRISTATE_WIDTH       (OSERDES_DQ_TRISTATE_WIDTH),
               .TBYTE_CTL            ("TRUE"),
               .TBYTE_SRC            ("TRUE")
            )
            oserdes_slave_ts
            (
                .OFB                 (),
                .OQ                  (),
                .SHIFTOUT1           (),	// not extended
                .SHIFTOUT2           (),	// not extended
                .TFB                 (),
                .TQ                  (),
                .CLK                 (oserdes_clk),
                .CLKDIV              (oserdes_clkdiv),
                .D1                  (),
                .D2                  (),
                .D3                  (),
                .D4                  (),
                .D5                  (),
                .D6                  (),
                .D7                  (),
                .D8                  (),
               .OCE                  (1'b1),
               .RST                  (oserdes_rst),
               .SHIFTIN1             (),     // not extended
               .SHIFTIN2             (),     // not extended
               .T1                   (oserdes_dqts[0]),
               .T2                   (oserdes_dqts[0]),
               .T3                   (oserdes_dqts[1]),
               .T4                   (oserdes_dqts[1]),
               .TCE                  (1'b1),
               .TBYTEOUT             (tbyte_out),
               .TBYTEIN              (tbyte_out)
             );
     end // slave_ts

  for (i = 0; i != NUM_BITLANES; i=i+1) begin : output_
     if ( BITLANES[i]) begin  : oserdes_dq_

        if ( PO_DATA_CTL == "TRUE" ) begin  : ddr

           OSERDESE2 #(
               .DATA_RATE_OQ         (OSERDES_DQ_DATA_RATE_OQ),
               .DATA_RATE_TQ         (OSERDES_DQ_DATA_RATE_TQ),
               .DATA_WIDTH           (OSERDES_DQ_DATA_WIDTH),
               .INIT_OQ              (OSERDES_DQ_INIT_OQ),
               .INIT_TQ              (OSERDES_DQ_INIT_TQ),
               .SERDES_MODE          (OSERDES_DQ_SERDES_MODE),
               .SRVAL_OQ             (OSERDES_DQ_SRVAL_OQ),
               .SRVAL_TQ             (OSERDES_DQ_SRVAL_TQ),
               .TRISTATE_WIDTH       (OSERDES_DQ_TRISTATE_WIDTH),
               .TBYTE_CTL            (OSERDES_TBYTE_CTL),
               .TBYTE_SRC            ("FALSE")
             )
              oserdes_dq_i 
              (
                .OFB               (),
                .OQ                (oserdes_dq_buf[i]),
                .SHIFTOUT1         (),	// not extended
                .SHIFTOUT2         (),	// not extended
                .TBYTEOUT          (),
                .TFB               (),
                .TQ                (oserdes_dqts_buf[i]),
                .CLK               (oserdes_clk),
                .CLKDIV            (oserdes_clkdiv),
                .D1                (oserdes_dq[4 * i + 0]),
                .D2                (oserdes_dq[4 * i + 1]),
                .D3                (oserdes_dq[4 * i + 2]),
                .D4                (oserdes_dq[4 * i + 3]),
                .D5                (),
                .D6                (),
                .D7                (),
                .D8                (),
               .OCE                (1'b1),
               .RST                (oserdes_rst),
               .SHIFTIN1           (),     // not extended
               .SHIFTIN2           (),     // not extended
               .T1                 (/*oserdes_dqts[0]*/),
               .T2                 (/*oserdes_dqts[0]*/),
               .T3                 (/*oserdes_dqts[1]*/),
               .T4                 (/*oserdes_dqts[1]*/),
               .TCE                (1'b1),
               .TBYTEIN            (tbyte_out)
              );
           end
           else begin :  sdr 
           OSERDESE2 #(
               .DATA_RATE_OQ         (OSERDES_DQ_DATA_RATE_OQ),
               .DATA_RATE_TQ         (OSERDES_DQ_DATA_RATE_TQ),
               .DATA_WIDTH           (OSERDES_DQ_DATA_WIDTH),
               .INIT_OQ              (1'b0 /*OSERDES_DQ_INIT_OQ*/),
               .INIT_TQ              (OSERDES_DQ_INIT_TQ),
               .SERDES_MODE          (OSERDES_DQ_SERDES_MODE),
               .SRVAL_OQ             (1'b0 /*OSERDES_DQ_SRVAL_OQ*/),
               .SRVAL_TQ             (OSERDES_DQ_SRVAL_TQ),
               .TRISTATE_WIDTH       (OSERDES_DQ_TRISTATE_WIDTH) 
              )
              oserdes_dq_i 
              (
                .OFB               (),
                .OQ                (oserdes_dq_buf[i]),
                .SHIFTOUT1         (),	// not extended
                .SHIFTOUT2         (),	// not extended
                .TBYTEOUT          (),
                .TFB               (),
                .TQ                (),
                .CLK               (oserdes_clk),
                .CLKDIV            (oserdes_clkdiv),
                .D1                (oserdes_dq[4 * i + 0]),
                .D2                (oserdes_dq[4 * i + 1]),
                .D3                (oserdes_dq[4 * i + 2]),
                .D4                (oserdes_dq[4 * i + 3]),
                .D5                (),
                .D6                (),
                .D7                (),
                .D8                (),
               .OCE                (1'b1),
               .RST                (oserdes_rst),
               .SHIFTIN1           (),     // not extended
               .SHIFTIN2           (),     // not extended
               .T1                 (),
               .T2                 (),
               .T3                 (),
               .T4                 (),
               .TCE                (1'b1),
               .TBYTEIN            ()
              );
           end // ddr
     end // oserdes_dq_
  end // output_
  
endgenerate

generate

 if ( PO_DATA_CTL == "TRUE" )  begin : dqs_gen

   ODDR  
      #(.DDR_CLK_EDGE  (ODDR_CLK_EDGE))
      oddr_dqs 
   (
       .Q   (oserdes_dqs_buf),
       .D1  (oserdes_dqs[0]),
       .D2  (oserdes_dqs[1]),
       .C   (oserdes_clk_delayed),
       .R   (1'b0),
       .S   (),
       .CE  (1'b1)
   );

   ODDR
     #(.DDR_CLK_EDGE  (ODDR_CLK_EDGE))
     oddr_dqsts 
   (    .Q  (oserdes_dqsts_buf),
        .D1 (oserdes_dqsts[0]),
        .D2 (oserdes_dqsts[0]),
        .C  (oserdes_clk_delayed),
        .R  (),
        .S  (1'b0),
        .CE (1'b1)
   );

 end // sdr rate
 else begin:null_dqs 
 end 
endgenerate

endmodule			// byte_group_io

