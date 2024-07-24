// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module blk_mem_gen_0(clka, wea, addra, dina, clkb, addrb, doutb);
  input clka;
  input [0:0]wea;
  input [8:0]addra;
  input [31:0]dina;
  input clkb;
  input [8:0]addrb;
  output [31:0]doutb;
endmodule
