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
//   DPE dummy switch
//--------------------------------------------------------------------------
// Default configuration
// (can be overridden by assertion of tuser_bypass_all or tuser_bypass_stage)
//
//   .----------.                             .----------.
//   | From CPU |                 .---------->|  To CPU  |
//   |   FIFO   |------------.   /  .-------->|   FIFO   |
//   '----------'             \ /  /          '----------'
//                             X  /
//   .----------.             / \/            .----------.
//   |From ETH_1|------------'  /\            | To ETH_1 |
//   |   FIFO   |              /  '---------->|   FIFO   |
//   '----------'             /               '----------'
//                           /
//   .----------.           /                 .----------.
//   |From ETH_2|----------'             0--->| To ETH_2 |
//   |   FIFO   |                             |   FIFO   |
//   '----------'                             '----------'
//
//   .----------.                             .----------.
//   |From ETH_3|                             | To ETH_3 |
//   |   FIFO   |------------.   .----------->|   FIFO   |
//   '----------'             \ /             '----------'
//                             X
//   .----------.             / \             .----------.
//   |From ETH_4|------------'   '----------->| To ETH_4 |
//   |   FIFO   |                             |   FIFO   |
//   '----------'                             '----------'
//
//==========================================================================

module dpe_dummy_switch (
   dpe_if.s_axis inp,
   dpe_if.m_axis outp
);
   import dpe_pkg::*;

   dpe_if outp_sbuff (.clk(inp.clk), .rst(inp.rst));

// Backpressure
   assign inp.tready = outp_sbuff.tready;

// Switch
   always_comb begin
      outp_sbuff.tvalid = inp.tvalid;
      outp_sbuff.tdata = inp.tdata;
      outp_sbuff.tkeep = inp.tkeep;
      outp_sbuff.tlast = inp.tlast;
      outp_sbuff.tuser_bypass_all = inp.tuser_bypass_all;
      outp_sbuff.tuser_bypass_stage = 1'b0;
      outp_sbuff.tuser_src = inp.tuser_src;
      if (inp.tuser_bypass_all == 1'b0 && inp.tuser_bypass_stage == 1'b0) begin
         unique case (inp.tuser_src)
            DPE_ADDR_CPU: begin
               outp_sbuff.tuser_dst = DPE_ADDR_ETH_1;
            end
            DPE_ADDR_ETH_1: begin
               outp_sbuff.tuser_dst = DPE_ADDR_CPU;
            end
            DPE_ADDR_ETH_2: begin
               outp_sbuff.tuser_dst = DPE_ADDR_CPU;
            end
            DPE_ADDR_ETH_3: begin
               outp_sbuff.tuser_dst = DPE_ADDR_ETH_4;
            end
            DPE_ADDR_ETH_4: begin
               outp_sbuff.tuser_dst = DPE_ADDR_ETH_3;
            end
            default: begin
               outp_sbuff.tuser_dst = inp.tuser_dst;
            end
         endcase
      end else begin
         outp_sbuff.tuser_dst = inp.tuser_dst;
      end
   end

// Skid buffers
   dpe_if_skid_buffer skid_buffer_outp (
      .inp(outp_sbuff),
      .outp(outp)
   );
endmodule
