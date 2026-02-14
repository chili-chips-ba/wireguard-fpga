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
//   DPE AXIS pipeline register
//==========================================================================

module dpe_if_pipeline #(
   parameter LENGTH = 1
) (
   dpe_if.s_axis inp,
   dpe_if.m_axis outp
);
   axis_pipeline_register #(
      .DATA_WIDTH(128),
      .USER_WIDTH(8),
      .ID_WIDTH(8),
      .LENGTH(LENGTH),
      .REG_TYPE(2)
   ) pipeline (
      .clk(inp.clk),
      .rst(inp.rst),
      .s_axis_tvalid(inp.tvalid),
      .s_axis_tready(inp.tready),
      .s_axis_tdata(inp.tdata),
      .s_axis_tkeep(inp.tkeep),
      .s_axis_tlast(inp.tlast),
      .s_axis_tuser({inp.tuser_bypass_all,
                     inp.tuser_bypass_stage,
                     inp.tuser_src,
                     inp.tuser_dst}),
      .s_axis_tid(inp.tid),
      .s_axis_tdest('0),
      .m_axis_tvalid(outp.tvalid),
      .m_axis_tready(outp.tready),
      .m_axis_tdata(outp.tdata),
      .m_axis_tkeep(outp.tkeep),
      .m_axis_tlast(outp.tlast),
      .m_axis_tuser({outp.tuser_bypass_all,
                     outp.tuser_bypass_stage,
                     outp.tuser_src,
                     outp.tuser_dst}),
      .m_axis_tid(outp.tid),
      .m_axis_tdest()
   );
endmodule
