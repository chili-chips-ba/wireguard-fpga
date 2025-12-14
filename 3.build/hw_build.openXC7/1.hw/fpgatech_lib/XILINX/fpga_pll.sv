// SPDX-FileCopyrightText: 2024 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================
// openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
//------------------------------------------------------------------------
//                   Copyright (C) 2024 Chili.CHIPS*ba
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
//------------------------------------------------------------------------
// Description: Top-level PLL.
//   It produces 200MHz from 100MHz input clock
//========================================================================

module fpga_pll_top (
   input  logic areset,  // active-1 async reset
   input  logic clk_in,  // 100MHz

   output logic srst,
   output logic clk_out0,
   output logic clk_out1 // ~200MHz
);

   logic pll_lock;
   logic clkfb;
   logic uclk_out0;
   logic uclk_out1;


`ifdef COCOTB_SIM
   // PLL outputs driven from cocotb
   initial begin
      pll_lock  = 1'b0;
      uclk_out0 = 'x;
      uclk_out1 = 'x;
   end

`else
   MMCME2_BASE #(
      .BANDWIDTH   ("OPTIMIZED"), // Jitter programming (OPTIMIZED, HIGH, LOW)
      .DIVCLK_DIVIDE   (5),       // Master division value (1-106)
      .CLKFBOUT_MULT_F (45.0),  // Multiply value for all CLKOUT (2.000-64.000)
      .CLKFBOUT_PHASE  (0.0),     // Phase offset in degrees of CLKFB (-360.000-360.000)
      .CLKIN1_PERIOD   (10.000),  // Input clock period in ns to ps resolution
                                  //   (i.e. 33.333 is 30 MHz)
                                  //   VCO range(400MHz to 1080MHz) =
                                  //     CLKFBOUT_MULT_F/(CLKIN1_PERIOD*DIVCLK_DIVIDE)

     //CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT0_DIVIDE_F(4.5),   // Divide amount for CLKOUT0 (1.000-128.000)

      .CLKOUT1_DIVIDE(1),
      .CLKOUT2_DIVIDE(5), //5=180, 8=112,5
      .CLKOUT3_DIVIDE(1),
      .CLKOUT4_DIVIDE(1),
      .CLKOUT5_DIVIDE(1),
      .CLKOUT6_DIVIDE(1),

     //CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE:
     //Duty cycle for each CLKOUT (0.01-0.99)
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),
      .CLKOUT6_DUTY_CYCLE(0.5),

     //CLKOUT0_PHASE - CLKOUT6_PHASE:
     //Phase offset for each CLKOUT (-360.000-360.000)
      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),
      .CLKOUT6_PHASE(0.0),

      .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      .REF_JITTER1(0.0),         // Reference input jitter in UI (0.000-0.999)
      .STARTUP_WAIT("FALSE")     // Delays DONE until MMCM is locked (FALSE, TRUE)
   )
   uMMCME2_BASE (
      .CLKOUT0   (uclk_out0),    //o: CLKOUT0
      .CLKOUT0B  (),             //o

      .CLKOUT1   (),             //o
      .CLKOUT1B  (),             //o

      .CLKOUT2   (uclk_out1),    //o: CLKOUT2
      .CLKOUT2B  (),             //o

      .CLKOUT3   (),             //o
      .CLKOUT3B  (),             //o

      .CLKOUT4   (),             //o
      .CLKOUT5   (),             //o
      .CLKOUT6   (),             //o

      .CLKFBOUT  (clkfb),        //o: Feedback clock
      .LOCKED    (pll_lock),     //o: LOCK

      .CLKIN1    (clk_in),       //i: Clock
      .CLKFBIN   (clkfb),        //i: Feedback clock
      .CLKFBOUTB (),             //o

      .PWRDWN    (1'b0),         //i
      .RST       (1'b0)          //i
   );
`endif //COCOTB_SIM

//----------------------------------------------
// Clock buffers
//----------------------------------------------
   BUFG u_BUFG_clk_out0 (
      .I(uclk_out0),
      .O(clk_out0)
   );

   BUFG u_BUFG_clk_out2 (
      .I(uclk_out1),
      .O(clk_out1)
   );

//----------------------------------------------
// Reset synchronizer
//----------------------------------------------
   logic  arst_n;
   assign arst_n = ~areset & pll_lock;

   logic [2:0] srst_pipe;

   always_ff @(negedge arst_n or posedge clk_out0) begin
      if (arst_n == 1'b0) begin
         srst_pipe <= '1;
         srst      <= 1'b1;
      end
      else begin
         srst_pipe <= {srst_pipe[1:0], 1'b0};
         srst      <= srst_pipe[2];
      end
   end

endmodule: fpga_pll_top

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/10 AnelH: Initial creation
*/
