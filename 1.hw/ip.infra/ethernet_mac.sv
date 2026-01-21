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
//   Triple-Speed Ethernet Wrapper
//==========================================================================

module ethernet_mac (
   input  logic       gtx_clk,
   input  logic       gtx_rst,
   input  logic       gmii_rx_clk,
   input  logic [7:0] gmii_rxd,
   input  logic       gmii_rx_dv,
   input  logic       gmii_rx_er,
   input  logic       mii_tx_clk,
   output logic       gmii_tx_clk,
   output logic [7:0] gmii_txd,
   output logic       gmii_tx_en,
   output logic       gmii_tx_er,
   output logic [1:0] speed,
   dpe_if.s_axis      tx_fifo,
   dpe_if.m_axis      rx_fifo
);
   eth_mac_1g_gmii_fifo #(
      .TARGET("XILINX"),
      .IODDR_STYLE("IODDR"),
      .CLOCK_INPUT_STYLE("BUFG"),
      .AXIS_DATA_WIDTH(128),
      .AXIS_KEEP_ENABLE(1),
      .AXIS_KEEP_WIDTH(16),
      .ENABLE_PADDING(1),
      .MIN_FRAME_LENGTH(64),
      .TX_FIFO_DEPTH(4096),
      .TX_FRAME_FIFO(1),
      .RX_FIFO_DEPTH(4096),
      .RX_FRAME_FIFO(1)
   ) eth (
      .gtx_clk(gtx_clk),
      .gtx_rst(gtx_rst),
      .logic_clk(tx_fifo.clk),
      .logic_rst(tx_fifo.rst),

      .tx_axis_tdata(tx_fifo.tdata),
      .tx_axis_tkeep(tx_fifo.tkeep),
      .tx_axis_tvalid(tx_fifo.tvalid),
      .tx_axis_tready(tx_fifo.tready),
      .tx_axis_tlast(tx_fifo.tlast),
      .tx_axis_tuser('0),

      .rx_axis_tdata(rx_fifo.tdata),
      .rx_axis_tkeep(rx_fifo.tkeep),
      .rx_axis_tvalid(rx_fifo.tvalid),
      .rx_axis_tready(rx_fifo.tready),
      .rx_axis_tlast(rx_fifo.tlast),
      .rx_axis_tuser(),

      .gmii_rx_clk(gmii_rx_clk),
      .gmii_rxd(gmii_rxd),
      .gmii_rx_dv(gmii_rx_dv),
      .gmii_rx_er(gmii_rx_er),
      .mii_tx_clk(mii_tx_clk),
      .gmii_tx_clk(gmii_tx_clk),
      .gmii_txd(gmii_txd),
      .gmii_tx_en(gmii_tx_en),
      .gmii_tx_er(gmii_tx_er),

      .tx_fifo_overflow(),
      .tx_fifo_bad_frame(),
      .tx_fifo_good_frame(),
      .rx_error_bad_frame(),
      .rx_error_bad_fcs(),
      .rx_fifo_overflow(),
      .rx_fifo_bad_frame(),
      .rx_fifo_good_frame(),
      .tx_error_underflow(),
      .speed(speed),

      .cfg_ifg(8'd12),
      .cfg_tx_enable(1'b1),
      .cfg_rx_enable(1'b1)
   );
endmodule
