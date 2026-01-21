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
//   DPE AXI-Stream Interface
//==========================================================================

interface dpe_if (
   // verilator lint_off UNUSED
   input logic   clk,
   input logic   rst
);
   logic         tready;
   logic         tvalid;
   logic [127:0] tdata;
   logic         tlast;
   logic [15:0]  tkeep;
   logic         tuser_bypass_all;
   logic         tuser_bypass_stage;
   logic [2:0]   tuser_src;
   logic [2:0]   tuser_dst;
   logic [7:0]   tid;
   // verilator lint_on UNUSED

   modport m_axis (
      input     clk,
      input     rst,
      input     tready,
      output    tvalid,
      output    tdata,
      output    tlast,
      output    tkeep,
      output    tuser_bypass_all,
      output    tuser_bypass_stage,
      output    tuser_src,
      output    tuser_dst,
      output    tid
   );

   modport s_axis (
      input     clk,
      input     rst,
      output    tready,
      input     tvalid,
      input     tdata,
      input     tlast,
      input     tkeep,
      input     tuser_bypass_all,
      input     tuser_bypass_stage,
      input     tuser_src,
      input     tuser_dst,
      input     tid
   );
endinterface
