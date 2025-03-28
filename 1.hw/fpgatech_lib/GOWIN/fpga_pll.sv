///////////////////////////////////////////////////////////////////////////////
//
// (c) Copyright 2024 -- CHILI CHIPS LLC, All rights reserved.
//
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//-----------------------------------------------------------------------------
// Technology-specific GoWin PLL. From external 27MHz source, creates:
//   - 54MHz and 108MHz clocks for CPU and DSP
///////////////////////////////////////////////////////////////////////////////

module fpga_pll (
   input  logic clk_27,    // 27MHz for the Sipeed GoWin board
   input  logic force_rst, // 1 to force reset

   output logic srst_n,
   output logic clk_54,   // 2x clock:  54MHz
   output logic clk_108   // 4x clock: 108MHz
);

//--------------------------------------------------
//-- Clock multiplier from 27MHz
//--------------------------------------------------
   logic pll_lock;

   rPLL #(
      //.DEVICE           ("GW1NR-9C"),
      .DEVICE           ("GW2AR-18C"),
      .FCLKIN           ("27"),
      .DYN_IDIV_SEL     ("false"),
      .IDIV_SEL         (0),
      .DYN_FBDIV_SEL    ("false"),
      .FBDIV_SEL        (3),
      .DYN_ODIV_SEL     ("false"),
      .ODIV_SEL         (8),
      .PSDA_SEL         ("0000"),
      .DYN_DA_EN        ("true"),
      .DUTYDA_SEL       ("1000"),
      .CLKOUT_FT_DIR    (1'b1),
      .CLKOUTP_FT_DIR   (1'b1),
      .CLKOUT_DLY_STEP  (0),
      .CLKOUTP_DLY_STEP (0),
      .CLKFB_SEL        ("internal"),
      .CLKOUT_BYPASS    ("false"),
      .CLKOUTP_BYPASS   ("false"),
      .CLKOUTD_BYPASS   ("false"),
      .DYN_SDIV_SEL     (2),
      .CLKOUTD_SRC      ("CLKOUT"),
      .CLKOUTD3_SRC     ("CLKOUT")
   )
   u_pll (
      .CLKOUT   (clk_108),
      .LOCK     (pll_lock),
      .CLKOUTP  (),
      .CLKOUTD  (),
      .CLKOUTD3 (),

      .RESET    (1'b0),
      .RESET_P  (1'b0),
      .CLKIN    (clk_27),
      .CLKFB    (1'b0),
      .FBDSEL   ('0),
      .IDSEL    ('0),
      .ODSEL    ('0),
      .PSDA     ('0),
      .DUTYDA   ('0),
      .FDLY     ('0)
   );

//--------------------------------------------------
// Clock divider: 108MHz -> 54MHz
//--------------------------------------------------
   CLKDIV #(
      .DIV_MODE ("2"),
      .GSREN    ("false")
   )
   u_clkdiv (
      .CLKOUT   (clk_54),
      .HCLKIN   (clk_108),
      .RESETN   (pll_lock),
      .CALIB    (1'b0)
   );

//--------------------------------------------------
// Reset synchronizer
//--------------------------------------------------
   logic  srst_n_pipe;
   logic  final_rst;
   assign final_rst = force_rst | ~pll_lock;


   always_ff @(posedge final_rst or posedge clk_54) begin
      if (final_rst == 1'b1) begin
         srst_n_pipe <= 1'b0;
         srst_n      <= 1'b0;
      end
      else begin
         srst_n_pipe <= 1'b1;
         srst_n      <= srst_n_pipe;
      end
   end

endmodule: fpga_pll

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/1/4 JI: initial creation
*/
