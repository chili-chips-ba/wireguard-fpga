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
//   Dual-Port register file of 32 entries, each 32-bit wide.
//
//   This is behavioral description. The idea is replace it with technology
//   specific DistributedRAM, or ShadowSRAM, so mimimizing area and maximizing
//   performance
//==========================================================================

module dprf_32x32bit (
   input  logic        clk,

// One WRITE port: Synchronous
   input  logic        wen,
   input  logic [6:2]  waddr,
   input  logic [31:0] wdata,

// Two READ ports: Asynchronous
   input  logic [6:2]  raddr1,
   output logic [31:0] rdata1,

   input  logic [6:2]  raddr2,
   output logic [31:0] rdata2
);

`ifdef YOSYS
   (* ram_style = "distributed" *) logic [31:0] rf[32];

`else // Gowin
   logic [31:0] rf [32] /* synthesis syn_ramstyle = "distributed_ram" */;
`endif

   always_ff @(posedge clk) begin
      if (wen == 1'b1) rf[waddr] <= wdata;
   end

   assign rdata1 = rf[raddr1];
   assign rdata2 = rf[raddr2];

endmodule: dprf_32x32bit

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/1/4 JI: initial creation
*/
