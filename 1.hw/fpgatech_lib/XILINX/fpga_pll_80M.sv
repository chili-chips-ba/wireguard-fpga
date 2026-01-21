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
//   System clock domain PLL (f_in = 200 MHz, f_out = 80 MHz)
//     • Synthesizable variant:
//         - Xilinx PLLE2_BASE
//     • Simulation-only variant (`SIM_ONLY`):
//         - Simple behavioural 80 MHz model
//==========================================================================

`ifdef SIM_ONLY
   `timescale 1ps/1ps
`endif

module fpga_pll_80M
(
   input  logic clk,
   input  logic rst_n,
   output logic sys_pll_clk,
   output logic sys_pll_locked
);

`ifdef SIM_ONLY
   initial begin
      sys_pll_clk    = 1'b0;
      sys_pll_locked = 1'b0;
      #40_000;
      sys_pll_locked = 1'b1;
   end

   always begin
      #6_250 sys_pll_clk = ~sys_pll_clk;
   end

`else
   wire sys_pll_rst = ~rst_n;
   wire sys_pll_clkfb;
   wire sys_pll_out;

   PLLE2_BASE #(
      .CLKFBOUT_MULT(4),
      .CLKFBOUT_PHASE(0.0),
      .CLKIN1_PERIOD(5.0),

      .CLKOUT0_DIVIDE(10),
      .CLKOUT1_DIVIDE(1),
      .CLKOUT2_DIVIDE(1),
      .CLKOUT3_DIVIDE(1),
      .CLKOUT4_DIVIDE(1),
      .CLKOUT5_DIVIDE(1),

      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),

      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),

      .DIVCLK_DIVIDE(1)
   ) sys_pll (
      .CLKOUT0(sys_pll_out),
      .CLKOUT1(),
      .CLKOUT2(),
      .CLKOUT3(),
      .CLKOUT4(),
      .CLKOUT5(),

      .CLKFBOUT(sys_pll_clkfb),
      .CLKFBIN(sys_pll_clkfb),

      .LOCKED(sys_pll_locked),
      .CLKIN1(clk),

      .PWRDWN(0),
      .RST(sys_pll_rst)
   );

   BUFG
   sys_clk_bufg_inst (
      .I(sys_pll_out),
      .O(sys_pll_clk)
   );

`endif  // SIM_ONLY
endmodule
