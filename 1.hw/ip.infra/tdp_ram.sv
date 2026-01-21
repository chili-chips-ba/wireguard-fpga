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
//   True Dual-Port RAM
//==========================================================================

module tdp_ram #(
   parameter DATA_WIDTH = 32,
   parameter ADDR_WIDTH = 8,
   parameter DEPTH = (1 << ADDR_WIDTH)
)(
   input  logic                    clk,

   input  logic                    we_a,
   input  logic [ADDR_WIDTH-1:0]   addr_a,
   input  logic [DATA_WIDTH-1:0]   din_a,
   output logic [DATA_WIDTH-1:0]   dout_a,

   input  logic                    we_b,
   input  logic [ADDR_WIDTH-1:0]   addr_b,
   input  logic [DATA_WIDTH-1:0]   din_b,
   output logic [DATA_WIDTH-1:0]   dout_b
);
   logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

   // Port A
   always_ff @(posedge clk) begin
      if (we_a)
         mem[addr_a] <= din_a;

      dout_a <= mem[addr_a];
   end

   // Port B
   always_ff @(posedge clk) begin
      if (we_b)
         mem[addr_b] <= din_b;

      dout_b <= mem[addr_b];
   end
endmodule

