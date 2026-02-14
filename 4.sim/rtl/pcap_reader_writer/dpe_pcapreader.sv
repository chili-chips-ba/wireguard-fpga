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
//   DPE wrapper for PCAP packet reader
//==========================================================================

module dpe_pcapreader#
(
   parameter PCAP_FILENAME = "none",
   parameter TUSER_BYPASS_ALL = 1'b0,
   parameter TUSER_BYPASS_STAGE = 1'b0,
   parameter TUSER_SRC = DPE_ADDR_CPU,
   parameter TUSER_DST = DPE_ADDR_ETH_1,
   parameter TID = 8'd0
) (
   dpe_if.m_axis outp,
   output logic  pcapfinished
);
   import dpe_pkg::*;

   avalon_if #(.DATA_WIDTH(128)) avalon_int(.clk(outp.clk),.rst(outp.rst));
   axis_if #(.DATA_WIDTH(128)) axis_int(.clk(outp.clk),.rst(outp.rst));

   assign outp.tdata = axis_int.data;
   assign outp.tvalid = axis_int.valid;
   assign outp.tlast = axis_int.last;
   assign outp.tkeep = axis_int.keep;
   assign axis_int.ready = outp.tready;
   assign outp.tuser_bypass_all = TUSER_BYPASS_ALL;
   assign outp.tuser_bypass_stage = TUSER_BYPASS_STAGE;
   assign outp.tuser_src = TUSER_SRC;
   assign outp.tuser_dst = TUSER_DST;
   assign outp.tid = TID;
   assign avalon_int.ready = 1'b0;

   pcapreader #(
      .PCAP_FILENAME(PCAP_FILENAME),
      .SIGNAL_TYPE("axisif"),
      .DATA_WIDTH(128)
   ) pcap (
      .clk_out(outp.clk),
      .reset(outp.rst),
      .available(),
      .pktcount(),
      .newpkt(),
      .pcapfinished(pcapfinished),

      .from_reader_avalon(avalon_int),
      .from_reader_axis(axis_int)
   );
endmodule
