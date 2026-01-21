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
//   Generic inferred memory for our SOC. Syncronous RAM that's Plug-and-Play
//   compatible with our infrastructure
//==========================================================================

module soc_ram #(
   parameter NUM_WORDS = 1024 // RAM depth in SOC bus words, typically 32-bit
)(
   soc_if.SLV bus
);

   import soc_pkg::*;

   localparam ADDR_MSB = $clog2(NUM_WORDS) + 1;

//------------------------------------------------------------
// combo decode logic
//------------------------------------------------------------
   logic [ADDR_MSB:SOC_ADDRL] addr;
   soc_we_t                   we;
   logic                      write;

   always_comb begin
      addr  = bus.addr[ADDR_MSB:SOC_ADDRL];
      we    = bus.vld ? bus.we : '0; // write only when accessed

      write = |bus.we;
   end

//------------------------------------------------------------
// storage element
//------------------------------------------------------------
`ifdef YOSYS
    (* ram_style = "block" *) soc_data_t mem [NUM_WORDS];

`else // Gowin
    soc_data_t mem [NUM_WORDS] /* synthesis syn_ramstyle = "block_ram" */;
  //soc_data_t mem [NUM_WORDS] /* synthesis syn_ramstyle = "distributed_ram" */;
`endif

   always_ff @(posedge bus.clk) begin
      bus.rdat <= mem[addr];

      for (int i=0; i< SOC_BYTES; i++) begin
         if (we[i] == HI) mem[addr][i*8 +: 8] <= bus.wdat[i*8 +: 8];
      end
   end

//------------------------------------------------------------
// handshake:
//  - write is RDY right away
//  - read  is RDY one cycle after VLD (since RAM is synchronous)
//------------------------------------------------------------
   logic  rdy_rd;

   always_ff @(negedge bus.arst_n or posedge bus.clk) begin
      if (bus.arst_n == 1'b0) begin
         rdy_rd <= '0;
      end
      else begin
         rdy_rd <= bus.vld & ~write & ~bus.rdy;
      end
   end

  assign bus.rdy = write | rdy_rd;


//=========================================
// Sim-only
//=========================================
`ifdef SIM_ONLY
`ifdef RAM_DEBUG

  always @(posedge bus.clk) begin
     if ({bus.vld, bus.rdy} == 2'b11) begin
        if (write == 1) begin
           $display("%t %m WRITE [%08x]<=%08x (we=%b)", $time,
                    {bus.addr, 2'd0}, bus.wdat, bus.we);
        end
        else begin
           $display("%t %m READ  [%08x]=>%08x (we=%b)", $time,
                    {bus.addr, 2'd0}, bus.rdat, bus.we);
        end
     end
  end

`endif
`endif

endmodule: soc_ram

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/1/3  JI: initial creation
 2024/2/24 JI: improved performance so that write is single-cycle
*/
