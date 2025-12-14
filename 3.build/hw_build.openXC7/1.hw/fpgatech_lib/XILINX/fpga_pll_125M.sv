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
//   Ethernet clock domain PLL (f_in = 200 MHz, f_out = 125 MHz)
//     • Synthesizable variant:
//         - Xilinx PLLE2_BASE
//     • Simulation-only variant (`SIM_ONLY`):
//         - Simple behavioural 125 MHz model
//==========================================================================

`ifdef SIM_ONLY
   `timescale 1ps/1ps
`endif

module fpga_pll_125M
(
   input  logic clk,
   input  logic rst_n,
   output logic eth_pll_clk,
   output logic eth_pll_locked
);

`ifdef SIM_ONLY
   initial begin
      eth_pll_clk    = 1'b0;
      eth_pll_locked = 1'b0;
      #25_000;
      eth_pll_locked = 1'b1;
   end

   always begin
      #4_000 eth_pll_clk = ~eth_pll_clk;
   end

`else
   wire eth_pll_rst = ~rst_n;
   wire eth_pll_clkfb;
   wire eth_pll_out;

   PLLE2_BASE #(
      .CLKFBOUT_MULT(5),
      .CLKFBOUT_PHASE(0.0),
      .CLKIN1_PERIOD(5.0),

      .CLKOUT0_DIVIDE(8),
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
   ) eth_pll (
      .CLKOUT0(eth_pll_out),
      .CLKOUT1(),
      .CLKOUT2(),
      .CLKOUT3(),
      .CLKOUT4(),
      .CLKOUT5(),

      .CLKFBOUT(eth_pll_clkfb),
      .CLKFBIN(eth_pll_clkfb),

      .LOCKED(eth_pll_locked),
      .CLKIN1(clk),

      .PWRDWN(0),
      .RST(eth_pll_rst)
   );

   BUFG
   eth_gtx_bufg_inst (
      .I(eth_pll_out),
      .O(eth_pll_clk)
   );

`endif  // SIM_ONLY
endmodule
