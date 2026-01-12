//==========================================================================
// Copyright (C) 2026 Chili.CHIPS*ba
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
//   True Dual-Port RAM
//==========================================================================

module tdp_ram #(
   parameter DATA_WIDTH = 32,
   parameter ADDR_WIDTH = 8,
   parameter DEPTH = (1 << ADDR_WIDTH)
)(
   input  logic                    clk,

   input  logic                    we_a,
   input  logic [ADDR_WIDTH-1:0]   addr_a,
   input  logic [DATA_WIDTH-1:0]   din_a,
   output logic [DATA_WIDTH-1:0]   dout_a,

   input  logic                    we_b,
   input  logic [ADDR_WIDTH-1:0]   addr_b,
   input  logic [DATA_WIDTH-1:0]   din_b,
   output logic [DATA_WIDTH-1:0]   dout_b
);
   logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

   // Port A
   always_ff @(posedge clk) begin
      if (we_a)
         mem[addr_a] <= din_a;

      dout_a <= mem[addr_a];
   end

   // Port B
   always_ff @(posedge clk) begin
      if (we_b)
         mem[addr_b] <= din_b;

      dout_b <= mem[addr_b];
   end
endmodule

