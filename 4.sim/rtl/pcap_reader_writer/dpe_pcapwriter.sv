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
//   DPE wrapper for PCAP packet writer
//==========================================================================

module dpe_pcapwriter#
(
   parameter PCAP_FILENAME = "none"
) (
   dpe_if.s_axis inp
);
   avalon_if #(.DATA_WIDTH(128)) avalon_int(.clk(inp.clk),.rst(inp.rst));
   axis_if #(.DATA_WIDTH(128)) axis_int(.clk(inp.clk),.rst(inp.rst));

   assign axis_int.data = inp.tdata;
   assign axis_int.valid = inp.tvalid;
   assign axis_int.last = inp.tlast;
   assign axis_int.keep = inp.tkeep;
   assign inp.tready = axis_int.ready;

   pcapwriter #(
      .PCAP_FILENAME(PCAP_FILENAME),
      .SIGNAL_TYPE("axisif"),
      .DATA_WIDTH(128)
   ) pcap (
      .clk_in(inp.clk),
      .reset(inp.rst),

      .to_writer_avalon(avalon_int),
      .to_writer_axis(axis_int),

      .pktcount()
   );
endmodule
