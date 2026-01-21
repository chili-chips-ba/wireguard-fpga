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
//   Data Plane Engine
//==========================================================================

module dpe
   import csr_pkg::*;
(
   input  csr_pkg::csr__out_t from_csr,
   output csr_pkg::csr__in_t  to_csr,
   dpe_if.s_axis              from_cpu,
   dpe_if.s_axis              from_eth_1,
   dpe_if.s_axis              from_eth_2,
   dpe_if.s_axis              from_eth_3,
   dpe_if.s_axis              from_eth_4,
   dpe_if.m_axis              to_cpu,
   dpe_if.m_axis              to_eth_1,
   dpe_if.m_axis              to_eth_2,
   dpe_if.m_axis              to_eth_3,
   dpe_if.m_axis              to_eth_4
);
   import dpe_pkg::*;

   localparam int ENTRY_COUNT = 64; 
   
   dpe_if                     muxed_1 (.clk(from_cpu.clk), .rst(from_cpu.rst));
   dpe_if                     muxed_2 (.clk(from_cpu.clk), .rst(from_cpu.rst));

// DPE multiplexer
   dpe_multiplexer u_dpe_multiplexer (
      .pause                  (from_csr.dpe.fcr.pause.value),
      .is_idle                (to_csr.dpe.fcr.idle.next),
      .from_cpu               (from_cpu),
      .from_eth_1             (from_eth_1),
      .from_eth_2             (from_eth_2),
      .from_eth_3             (from_eth_3),
      .from_eth_4             (from_eth_4),
      .to_dpe                 (muxed_1)
   );

// DPE dummy switch
   dpe_dummy_switch u_dpe_dummy_switch (
      .inp                    (muxed_1),
      .outp                   (muxed_2)
   );

// DPE demultiplexer
   dpe_demultiplexer u_dpe_demultiplexer (
      .from_dpe               (muxed_2),
      .to_cpu                 (to_cpu),
      .to_eth_1               (to_eth_1),
      .to_eth_2               (to_eth_2),
      .to_eth_3               (to_eth_3),
      .to_eth_4               (to_eth_4)
   );

// DPE egress Engine
//   dpe_egress_ip_lookup #(
//      .ENTRY_COUNT(ENTRY_COUNT)
//   ) u_egress (
//      .s_axis               (muxed_1),
//      .m_axis               (muxed_2),

//      .hwif_out             (from_csr.dpe.routing_table),
//      .hwif_in              (to_csr.dpe.routing_table)
//   );

   tdp_ram #(
      .ADDR_WIDTH             (8)
   ) u_routing_table (
      .clk                    (from_cpu.clk),
      .we_a                   (from_csr.routing_table.req & from_csr.routing_table.req_is_wr),
      .addr_a                 (from_csr.routing_table.addr >> 2),
      .din_a                  (from_csr.routing_table.wr_data),
      .dout_a                 (to_csr.routing_table.rd_data),
      .we_b                   (1'b0),
      .addr_b                 ('0),
      .din_b                  ('0),
      .dout_b                 ()
   );
   always_ff @(posedge from_cpu.clk) begin
      to_csr.routing_table.rd_ack <= from_csr.routing_table.req & ~from_csr.routing_table.req_is_wr;
   end
   assign to_csr.routing_table.wr_ack = from_csr.routing_table.req & from_csr.routing_table.req_is_wr;

   tdp_ram #(
      .ADDR_WIDTH             (11)
   ) u_cryptokey_table (
      .clk                    (from_cpu.clk),
      .we_a                   (from_csr.cryptokey_table.req & from_csr.cryptokey_table.req_is_wr),
      .addr_a                 (from_csr.cryptokey_table.addr >> 2),
      .din_a                  (from_csr.cryptokey_table.wr_data),
      .dout_a                 (to_csr.cryptokey_table.rd_data),
      .we_b                   (1'b0),
      .addr_b                 ('0),
      .din_b                  ('0),
      .dout_b                 ()
   );
   always_ff @(posedge from_cpu.clk) begin
      to_csr.cryptokey_table.rd_ack <= from_csr.cryptokey_table.req & ~from_csr.cryptokey_table.req_is_wr;
   end
   assign to_csr.cryptokey_table.wr_ack = from_csr.cryptokey_table.req & from_csr.cryptokey_table.req_is_wr;
endmodule
