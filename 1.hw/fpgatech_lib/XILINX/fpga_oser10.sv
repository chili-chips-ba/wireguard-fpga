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
// Description: Technology-specific Xilinx OSERDES10. It provides 10-1 muxing
// within output pad. Leveraged from Mike Field <hamster@snap.net.nz> design.
//
// The tricky part is that reset needs to be asserted, and then CE asserted 
// after the reset. Otherwise, it will not simulate correctly (outputs show as 'X') 
//========================================================================

module fpga_oser10 (
   input  logic       arst,    // active-high async reset
   input  logic       clk_par, // slower/parallel clock
   input  logic       clk_ser, // faster/serial clock
   input  logic [9:0] d,
   output logic       q
);

`ifdef OSERDES_SIM_MODEL

// Simplified 10:1 SERDES model (functionality verified in Xsim)
logic [9:0] D, D_CDC, SHIFT;
logic [4:0] CLK_PAR_CDC;

always @(posedge clk_par) D <= d;

always @(posedge clk_ser) begin
    CLK_PAR_CDC <= {CLK_PAR_CDC, clk_par};
    if (CLK_PAR_CDC[3:2]==1)
        D_CDC <= D;
    if (CLK_PAR_CDC[4:3]==1)
        SHIFT <= D_CDC; 
    else SHIFT <= 
        SHIFT >> 2;
end
assign #(0.1) q = clk_ser ? SHIFT[0] : SHIFT[1];

`else
   logic shift1;
   logic shift2;

   OSERDESE2 #(
      .DATA_RATE_OQ("DDR"),   // DDR, SDR
      .DATA_RATE_TQ("DDR"),   // DDR, BUF, SDR
      .DATA_WIDTH(10),        // Parallel data width (2-8,10,14)
      .INIT_OQ(1'b1),         // Initial value of OQ output (1'b0,1'b1)
      .INIT_TQ(1'b1),         // Initial value of TQ output (1'b0,1'b1)
      .SERDES_MODE("MASTER"), // MASTER, SLAVE
      .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
      .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
      .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
      .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
      .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
   ) master_oserdese (
      .OFB      (),           //o:
      .SHIFTOUT1(),           //o:
      .SHIFTOUT2(),           //o:
      .TBYTEOUT (),           //o:
      .TFB      (),           //o:
      .TQ       (),           //o:

      .OQ     (q),            //o: Data path output
      .CLK    (clk_ser),      //i: High speed clock
      .CLKDIV (clk_par),      //i: Divided clock

     //D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
      .D1(d[0]),
      .D2(d[1]),
      .D3(d[2]),
      .D4(d[3]),
      .D5(d[4]),
      .D6(d[5]),
      .D7(d[6]),
      .D8(d[7]),
      .OCE(1'b1),             // 1-bit input: Output data clock enable
      .RST(arst),             // 1-bit input: Reset

     //SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
      .SHIFTIN1(shift1),
      .SHIFTIN2(shift2),

     //T1 - T4: 1-bit (each) input: Parallel 3-state inputs
      .T1(1'b0),
      .T2(1'b0),
      .T3(1'b0),
      .T4(1'b0),
      .TBYTEIN(1'b0),         // 1-bit input: Byte group tristate
      .TCE(1'b0)              // 1-bit input: 3-state clock enable
   );

   OSERDESE2 #(
      .DATA_RATE_OQ("DDR"),   // DDR, SDR
      .DATA_RATE_TQ("DDR"),   // DDR, BUF, SDR
      .DATA_WIDTH(10),        // Parallel data width (2-8,10,14)
      .INIT_OQ(1'b1),         // Initial value of OQ output (1'b0,1'b1)
      .INIT_TQ(1'b1),         // Initial value of TQ output (1'b0,1'b1)
      .SERDES_MODE("SLAVE"),  // MASTER, SLAVE
      .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
      .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
      .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
      .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
      .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
   ) slave_oserdese (
      .OFB    (),             //o:
      .OQ     (),             //o:

     //SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
      .SHIFTOUT1(shift1),     //o:
      .SHIFTOUT2(shift2),     //o:
      .TBYTEOUT (),           //o:
      .TFB      (),           //o:
      .TQ       (),           //o:
                     
      .CLK(clk_ser),          // 1-bit input: High speed clock
      .CLKDIV(clk_par),       // 1-bit input: Divided clock

     //D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
      .D1(1'b0),
      .D2(1'b0),
      .D3(d[8]),
      .D4(d[9]),
      .D5(1'b0),
      .D6(1'b0),
      .D7(1'b0),
      .D8(1'b0),
      .OCE(1'b1),             // 1-bit input: Output data clock enable
      .RST(arst),             // 1-bit input: Reset

     //SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
      .SHIFTIN1(1'b0),
      .SHIFTIN2(1'b0),

     //T1 - T4: 1-bit (each) input: Parallel 3-state inputs
      .T1(1'b0),
      .T2(1'b0),
      .T3(1'b0),
      .T4(1'b0),
      .TBYTEIN(1'b0),         // 1-bit input: Byte group tristate
      .TCE(1'b0)              // 1-bit input: 3-state clock enable
   );
`endif //OSERDES_SIM_MODEL

endmodule: fpga_oser10

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/1/4  Isam Vrce: Initial creation
 2024/1/8  Armin Zunic: Timing improvements
 2024/1/10 Isam Vrce: More timing tuning
 2024/1/17 Armin Zunic: Converting the code from VHDL to SystemVerilog
*/
