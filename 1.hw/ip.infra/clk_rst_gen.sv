// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
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

