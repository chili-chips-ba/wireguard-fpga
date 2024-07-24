// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Thu Mar 30 18:05:45 2023
// Host        : DESKTOP-C3F5G4E running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/ax/AX7103_2019_1/check_demo/check_demo.srcs/sources_1/ip/ila_1/ila_1_stub.v
// Design      : ila_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2019.1" *)
module ila_1(clk, probe0, probe1, probe2, probe3)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[7:0],probe2[0:0],probe3[7:0]" */;
  input clk;
  input [0:0]probe0;
  input [7:0]probe1;
  input [0:0]probe2;
  input [7:0]probe3;
endmodule
