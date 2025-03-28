//==========================================================================
// Copyright (C) 2023 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description:
//   Dual-Port register file of 32 entries, each 32-bit wide.
//
//   This is behavioral description. The idea is replace it with technology
//   specific DistributedRAM, or ShadowSRAM, so mimimizing area and maximizing
//   performance
//==========================================================================

module dprf_32x32bit (
   input  logic        clk,

// One WRITE port: Synchronous
   input  logic        wen,
   input  logic [6:2]  waddr,
   input  logic [31:0] wdata,

// Two READ ports: Asynchronous
   input  logic [6:2]  raddr1,
   output logic [31:0] rdata1,

   input  logic [6:2]  raddr2,
   output logic [31:0] rdata2
);

`ifdef YOSYS
   (* ram_style = "distributed" *) logic [31:0] rf[32];

`else // Gowin
   logic [31:0] rf [32] /* synthesis syn_ramstyle = "distributed_ram" */;
`endif

   always_ff @(posedge clk) begin
      if (wen == 1'b1) rf[waddr] <= wdata;
   end

   assign rdata1 = rf[raddr1];
   assign rdata2 = rf[raddr2];

endmodule: dprf_32x32bit

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/1/4 JI: initial creation
*/
