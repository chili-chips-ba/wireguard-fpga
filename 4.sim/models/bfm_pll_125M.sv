//==========================================================================
// Copyright (C) 2024-2025 Chili.CHIPS*ba
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
//   Simple model of a system clock domain PLL (f_out = 125 MHz)
//==========================================================================

`timescale 1ps/1ps

module fpga_pll_125M (
   input  logic clk,
   input  logic rst_n,
   output logic eth_pll_clk,
   output logic eth_pll_locked
);

   initial begin
      eth_pll_clk    = 1'b0;
      eth_pll_locked = 1'b0;
      #25_000;
      eth_pll_locked = 1'b1;
   end

   always begin
      #4_000 eth_pll_clk = ~eth_pll_clk;
   end

endmodule