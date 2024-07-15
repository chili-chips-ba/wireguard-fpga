//==========================================================================
// (c) Copyright 2022 -- CHILI CHIPS LLC, All rights reserved.
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//-----------------------------------------------------------------------------
// Gowin ALU54D primitive wrapper: ADDER A-B
// 1 cycle to output - outputs are flopped 
//==========================================================================

module Gowin_ALU54minus (dout, caso, a, b, ce, clk, reset);

output [32:0] dout;
output [54:0] caso;
input [31:0] a;
input [31:0] b;
input ce;
input clk;
input reset;

wire [20:0] dout_w;
wire gw_vcc;
wire gw_gnd;

assign gw_vcc = 1'b1;
assign gw_gnd = 1'b0;

ALU54D alu54d_inst (
    .DOUT({dout_w[20:0],dout[32:0]}),
    .CASO(caso),
    .A({a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],a[31],gw_gnd,a[31:0]}),
    .B({b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],b[31],gw_gnd,b[31:0]}),
    .ASIGN(gw_vcc),
    .BSIGN(gw_vcc),
    .CASI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .ACCLOAD(gw_gnd),
    .CE(ce),
    .CLK(clk),
    .RESET(reset)
);

defparam alu54d_inst.AREG = 1'b0;
defparam alu54d_inst.BREG = 1'b0;
defparam alu54d_inst.ASIGN_REG = 1'b0;
defparam alu54d_inst.BSIGN_REG = 1'b0;
defparam alu54d_inst.ACCLOAD_REG = 1'b0;
defparam alu54d_inst.OUT_REG = 1'b1;
defparam alu54d_inst.B_ADD_SUB = 1'b1;
defparam alu54d_inst.C_ADD_SUB = 1'b0;
defparam alu54d_inst.ALUD_MODE = 0;
defparam alu54d_inst.ALU_RESET_MODE = "SYNC";

endmodule //Gowin_ALU54minus
/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/05/07 TI: initial creation    
*/
