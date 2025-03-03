// file: ila_0.v
//////////////////////////////////////////////////////////////////////////////
// (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//////////////////////////////////////////////////////////// 

`timescale 1ns / 1ps

//The example module here illustrates how ila core can be instantiated in
//a user design. This helps the user on how various ports selected for the core can be used.

module example_ila_0
  (
    input         clk_p,clk_n);
  //****************************************************************************
  //  Local Parameters
  //****************************************************************************
  
  parameter C_NUM_OF_TRIGPORTS = 9;
  parameter C_TRIG0_SIZE = 1;
  parameter C_TRIG1_SIZE = 128;
  parameter C_TRIG2_SIZE = 16;
  parameter C_TRIG3_SIZE = 1;
  parameter C_TRIG4_SIZE = 1;
  parameter C_TRIG5_SIZE = 1;
  parameter C_TRIG6_SIZE = 16;
  parameter C_TRIG7_SIZE = 1;
  parameter C_TRIG8_SIZE = 1;


  
  
  
  //****************************************************************************
  //  Local Signals
  //****************************************************************************
  wire clk;
  wire clk_bufg;
  wire [C_TRIG0_SIZE-1:0] trig_0; 
  wire [C_TRIG1_SIZE-1:0] trig_1; 
  wire [C_TRIG2_SIZE-1:0] trig_2; 
  wire [C_TRIG3_SIZE-1:0] trig_3; 
  wire [C_TRIG4_SIZE-1:0] trig_4; 
  wire [C_TRIG5_SIZE-1:0] trig_5; 
  wire [C_TRIG6_SIZE-1:0] trig_6; 
  wire [C_TRIG7_SIZE-1:0] trig_7; 
  wire [C_TRIG8_SIZE-1:0] trig_8; 
 
  wire [C_NUM_OF_TRIGPORTS:0] en_out_int;
  
  
  wire clk_mmcm;
  IBUFDS bufds_inst
    (
      .O(clk_mmcm),
      .I(clk_p),
      .IB(clk_n));

  BUFG bufg_inst
    (
      .O(clk),
      .I(clk_mmcm));



  //-----------------------------------------------------------------
  //  For TRIG0
  //-----------------------------------------------------------------
  // This shift register takes enable_in and registers enable_out. Size of 
  // shift register is given as TRIG0 width. Output of shift register 
  // is mapped to TRIG0.en_out of this shift_reg instance can be used as
  // en_in for next shift_reg instance. 

  // Enabling First shift register

  assign en_out_int[0] = 1'b1;

  shift_reg
    #(.WIDTH(C_TRIG0_SIZE))
    U_SHIFT_REGISTER_0
      (
       .clk(clk),
       .en_in(en_out_int[0]),
       .en_out(en_out_int[1]),
       .shiftout(trig_0));

  

  //-----------------------------------------------------------------
  //  For TRIG1
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG1 width.
  // Output of shift register is mapped TRIG1. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG0 signals 
  // are of shorter width than those of TRIG1.

 shift_reg
    #(.WIDTH(C_TRIG1_SIZE))
    U_SHIFT_REGISTER_1
      (
       .clk(clk),
       .en_in(en_out_int[1]),
       .en_out(en_out_int[2]),
       .shiftout(trig_1));


  //-----------------------------------------------------------------
  //  For TRIG2
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG2 width.
  // Output of shift register is mapped TRIG2. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG1 signals 
  // are of shorter width than those of TRIG2.

 shift_reg
    #(.WIDTH(C_TRIG2_SIZE))
    U_SHIFT_REGISTER_2
      (
       .clk(clk),
       .en_in(en_out_int[2]),
       .en_out(en_out_int[3]),
       .shiftout(trig_2));


  //-----------------------------------------------------------------
  //  For TRIG3
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG3 width.
  // Output of shift register is mapped TRIG3. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG2 signals 
  // are of shorter width than those of TRIG3.

 shift_reg
    #(.WIDTH(C_TRIG3_SIZE))
    U_SHIFT_REGISTER_3
      (
       .clk(clk),
       .en_in(en_out_int[3]),
       .en_out(en_out_int[4]),
       .shiftout(trig_3));


  //-----------------------------------------------------------------
  //  For TRIG4
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG4 width.
  // Output of shift register is mapped TRIG4. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG3 signals 
  // are of shorter width than those of TRIG4.

 shift_reg
    #(.WIDTH(C_TRIG4_SIZE))
    U_SHIFT_REGISTER_4
      (
       .clk(clk),
       .en_in(en_out_int[4]),
       .en_out(en_out_int[5]),
       .shiftout(trig_4));


  //-----------------------------------------------------------------
  //  For TRIG5
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG5 width.
  // Output of shift register is mapped TRIG5. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG4 signals 
  // are of shorter width than those of TRIG5.

 shift_reg
    #(.WIDTH(C_TRIG5_SIZE))
    U_SHIFT_REGISTER_5
      (
       .clk(clk),
       .en_in(en_out_int[5]),
       .en_out(en_out_int[6]),
       .shiftout(trig_5));


  //-----------------------------------------------------------------
  //  For TRIG6
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG6 width.
  // Output of shift register is mapped TRIG6. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG5 signals 
  // are of shorter width than those of TRIG6.

 shift_reg
    #(.WIDTH(C_TRIG6_SIZE))
    U_SHIFT_REGISTER_6
      (
       .clk(clk),
       .en_in(en_out_int[6]),
       .en_out(en_out_int[7]),
       .shiftout(trig_6));


  //-----------------------------------------------------------------
  //  For TRIG7
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG7 width.
  // Output of shift register is mapped TRIG7. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG6 signals 
  // are of shorter width than those of TRIG7.

 shift_reg
    #(.WIDTH(C_TRIG7_SIZE))
    U_SHIFT_REGISTER_7
      (
       .clk(clk),
       .en_in(en_out_int[7]),
       .en_out(en_out_int[8]),
       .shiftout(trig_7));


  //-----------------------------------------------------------------
  //  For TRIG8
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG8 width.
  // Output of shift register is mapped TRIG8. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG7 signals 
  // are of shorter width than those of TRIG8.

 shift_reg
    #(.WIDTH(C_TRIG8_SIZE))
    U_SHIFT_REGISTER_8
      (
       .clk(clk),
       .en_in(en_out_int[8]),
       .en_out(en_out_int[9]),
       .shiftout(trig_8));



  //-----------------------------------------------------------------
  //  ILA core instance
  //-----------------------------------------------------------------
  // When this design is run on analyzer, shift operation is observed on each trigger port.
  // The pulse width is different for any two trigger ports. If Data port is selected, 
  // Johnson Counter operation can be observed on Data port. If Trig_out port is selected,
  // shift operation can be viewed on VIO core. 

ila_0 ILA_inst (
  .clk(clk),
  .probe0(trig_0), // input [0 : 0] PROBE0
  .probe1(trig_1), // input [127 : 0] PROBE1
  .probe2(trig_2), // input [15 : 0] PROBE2
  .probe3(trig_3), // input [0 : 0] PROBE3
  .probe4(trig_4), // input [0 : 0] PROBE4
  .probe5(trig_5), // input [0 : 0] PROBE5
  .probe6(trig_6), // input [15 : 0] PROBE6
  .probe7(trig_7), // input [0 : 0] PROBE7
.probe8(trig_8)
);

endmodule

//-------------------------------------------------------------------
//  Shift Register module
//-------------------------------------------------------------------
// Shift register module is a ring counter logic along with en_in and en_out. 
// This logic generates walking one pattern of given width when en_in is '1'. 
// en_out is MSB of the shiftout. Width of shift register is parameterized 
// and default width is specified as '8'. If the width is '1', toggle pattern is generated.
(* DONT_TOUCH = "true" *)
module shift_reg
#(parameter WIDTH = 8) 
  (
    input clk,
    input en_in,
    (* dont_touch = "true" *)output en_out,
    output [WIDTH-1:0] shiftout);

  reg [WIDTH-1:0] val;
  initial
  val = 'b1;
  (* dont_touch = "true" *)reg en_out_reg;
  

  assign shiftout = val;
  
  // One shot enable
  assign en_out = (val[WIDTH-1] && !(en_out_reg));

  // Ring Counter logic
  generate
    if (WIDTH > 1)
      begin : if_name
        always@(posedge clk) begin
                  if (en_in == 1'b1) begin
                    val <= {val[WIDTH-2:0],val[WIDTH-1]};
                  end
                end
      end
    else
      begin : else_name
        always@(posedge clk) begin
          if (en_in == 1'b1) begin
            val <= !val;
          end
        end
      end
  endgenerate

  // Registering enable out
  always@(posedge clk) begin
    en_out_reg <= val[WIDTH-1];
  end

endmodule
