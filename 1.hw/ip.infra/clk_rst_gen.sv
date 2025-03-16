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
//   Clock and reset generation
//==========================================================================

module clk_rst_gen 
(
   input  clk_p,
   input  clk_n,
   input  rst_n,
   output sys_clk,
   output sys_rst,
   output sys_rst_n,
   output eth_gtx_clk,
   output eth_gtx_rst
);

//==========================================================================
// Generate single end clock from differential input clock
//==========================================================================
   wire clk; 
   
   IBUFGDS sys_clk_ibufgds
   (
      .O(clk),
      .I(clk_p),
      .IB(clk_n)
   );

//==========================================================================
// PLL for system clock domain
//==========================================================================
   wire sys_pll_locked;
   wire sys_pll_clk;
   wire sys_reset;
   
   fpga_pll_80M u_sys_pll (
      .clk(clk),
      .rst_n(rst_n),
      .sys_pll_clk(sys_pll_clk),
      .sys_pll_locked(sys_pll_locked)
   );
   
   sync_reset #(
      .N(4)
   ) sys_sync_reset_inst (
      .clk(sys_pll_clk),
      .rst(~sys_pll_locked),
      .out(sys_reset)
   );
   
   assign sys_rst = sys_reset;
   assign sys_rst_n = ~sys_reset;
   assign sys_clk = sys_pll_clk;

//==========================================================================
// PLL for Ethernet clock domain
//==========================================================================
   wire eth_pll_locked;
   wire eth_pll_clk;
   
   fpga_pll_125M u_eth_pll (
      .clk(clk),
      .rst_n(rst_n),
      .eth_pll_clk(eth_pll_clk),
      .eth_pll_locked(eth_pll_locked)
   );
   
   sync_reset #(
      .N(4)
   ) eth_sync_reset_inst (
      .clk(eth_pll_clk),
      .rst(~eth_pll_locked),
      .out(eth_gtx_rst)
   );
   
   assign eth_gtx_clk = eth_pll_clk;
   
endmodule: clk_rst_gen

