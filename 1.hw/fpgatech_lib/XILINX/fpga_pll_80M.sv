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
//   System clock domain PLL (f_in = 200 MHz, f_out = 80 MHz)
//==========================================================================

module fpga_pll_80M
(
   input  clk,
   input  rst_n,
   output sys_pll_clk,
   output sys_pll_locked
);

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
endmodule
