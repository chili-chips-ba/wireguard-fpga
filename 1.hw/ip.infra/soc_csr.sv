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
//   CSR wrapper for PeakRDL-generated CSR
//==========================================================================

module soc_csr
   import soc_pkg::*;
   import csr_pkg::*;
(
   soc_if.SLV                 bus,
   input csr_pkg::csr__in_t   hwif_in,
   output csr_pkg::csr__out_t hwif_out
);
   logic [31:0]               s_cpuif_wr_biten;
   logic                      s_cpuif_rd_ack;
   logic                      s_cpuif_wr_ack;

   assign s_cpuif_wr_biten[31:24] = bus.we[3] ? '1 : '0;
   assign s_cpuif_wr_biten[23:16] = bus.we[2] ? '1 : '0;
   assign s_cpuif_wr_biten[15:8]  = bus.we[1] ? '1 : '0;
   assign s_cpuif_wr_biten[7:0]   = bus.we[0] ? '1 : '0;

   //assign bus.rdy = 1'b1;
   assign bus.rdy = s_cpuif_rd_ack | s_cpuif_wr_ack;

   csr csr_inst (
      .clk                  (bus.clk),
      .rst                  (~bus.arst_n),

      .s_cpuif_req          (bus.vld),
      .s_cpuif_req_is_wr    (|bus.we),
      .s_cpuif_addr         ({bus.addr[CSR_MIN_ADDR_WIDTH-1:2],2'b00}),
      .s_cpuif_wr_data      (bus.wdat),
      .s_cpuif_wr_biten     (s_cpuif_wr_biten),
      .s_cpuif_req_stall_wr (),
      .s_cpuif_req_stall_rd (),
      .s_cpuif_rd_ack       (s_cpuif_rd_ack),
      .s_cpuif_rd_err       (),
      .s_cpuif_rd_data      (bus.rdat),
      .s_cpuif_wr_ack       (s_cpuif_wr_ack),
      .s_cpuif_wr_err       (),

      .hwif_in              (hwif_in),
      .hwif_out             (hwif_out)
   );

//=========================================
// Sim-only
//=========================================
`ifdef SIM_ONLY
`ifdef CSR_DEBUG

   always @(posedge bus.clk) begin
      if ({bus.vld, bus.rdy} == 2'b11) begin
         if (|bus.we == 1) begin
            $display("%t %m WRITE [%08x]<=%08x", $time,
                     {bus.addr, 2'd0}, bus.wdat);
         end
         if (|bus.we == 0) begin
            $display("%t %m READ [%08x]=>%08x", $time,
                     {bus.addr, 2'd0}, bus.rdat);
         end
      end
   end

`endif
`endif

endmodule: soc_csr
