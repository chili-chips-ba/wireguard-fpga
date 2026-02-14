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
//  - Multi-port UDP/IPv4 GMII ethernet interface driver with MDIO
//
//==========================================================================

module bfm_ethernet
#(parameter                            START_NODE     = 1,
  parameter                            NUM_PORTS      = 4,
  parameter                            MDIO_BUFF_ADDR = 32'h50000000,
  parameter                            RGMII          = 1)
(
  input                                clk,
  input                                clkx2,
  input                                arst_n,

  // GMII interface
  gmii_if.SLV                          gmii [0:NUM_PORTS-1],

  // MDIO interface
  input                                mdioclk,
  inout       [NUM_PORTS-1:0]          mdio,

`ifdef VERILATOR
  output      [NUM_PORTS-1:0]          mdio_en,
  output      [NUM_PORTS-1:0]          mdio_out,
`endif

  // Simulation halt request
  output                               halt_req
);

wire [7:0] udp_gmii_rxd  [NUM_PORTS-1:0];
wire       udp_gmii_rxdv [NUM_PORTS-1:0];
wire       udp_gmii_rxer [NUM_PORTS-1:0];
wire [7:0] udp_gmii_txd  [NUM_PORTS-1:0];
wire       udp_gmii_txen [NUM_PORTS-1:0];
wire       udp_gmii_txer [NUM_PORTS-1:0];

wire [NUM_PORTS-1:0] halt;

//--------------------------------------------------------------------------
// Combinatorial logic
//--------------------------------------------------------------------------

assign halt_req                        = |halt;

//--------------------------------------------------------------------------
// BFM instantiations
//--------------------------------------------------------------------------

genvar UDP;
generate

  for (UDP = 0; UDP < NUM_PORTS; UDP++)
  begin

    if (RGMII)
    begin:gen_rgmii
      // When RGMII, instantiate convertor and use gmii_if.tx[3:0], gmii_if.rdx[3:0], gmii_if.txen and
      // gmii_if.rxdv for the RGMI signalling.
      gmii_rgmii_conv conv
      (
        .clk                           (clk),
        .clkx2                         (clkx2),

        // GMII to RGMII
        .gmiitxd                       (udp_gmii_txd[UDP]),
        .gmiitxen                      (udp_gmii_txen[UDP]),
        .gmiitxer                      (udp_gmii_txer[UDP]),

        .rgmiitxd                      (gmii[UDP].rxd[3:0]),
        .rgmiitxctl                    (gmii[UDP].rxdv),

        // RGMII to GMII
        .rgmiirxd                      (gmii[UDP].txd[3:0]),
        .rgmiirxctl                    (gmii[UDP].txen),

        .gmiirxd                       (udp_gmii_rxd[UDP]),
        .gmiirxdv                      (udp_gmii_rxdv[UDP]),
        .gmiirxer                      (udp_gmii_rxer[UDP])
      );

      // Tie off unused outputs
      assign gmii[UDP].rxd[7:4]        = '0;
      assign gmii[UDP].rxer            = '0;
    end
    else
    begin:gen_gmii
       // When in GMII mode, wire interface straight through to udpIpPg
       assign gmii[UDP].rxd            = udp_gmii_txd[UDP];
       assign gmii[UDP].rxdv           = udp_gmii_txen[UDP];
       assign gmii[UDP].rxer           = udp_gmii_txer[UDP];

       assign udp_gmii_rxd[UDP]        = gmii[UDP].txd;
       assign udp_gmii_rxdv[UDP]       = gmii[UDP].txen;
       assign udp_gmii_rxer[UDP]       = gmii[UDP].txer;
    end

    // UDP/IPv4 ethernet BFM
    udp_ip_pg #(
      .NODE(START_NODE+UDP)
    ) udpIpPg
    (
      .clk                             (clk),

      .txd                             (udp_gmii_txd[UDP]),
      .txen                            (udp_gmii_txen[UDP]),
      .txer                            (udp_gmii_txer[UDP]),

      .rxd                             (udp_gmii_rxd[UDP]),
      .rxdv                            (udp_gmii_rxdv[UDP]),
      .rxer                            (udp_gmii_rxer[UDP]),

      .halt                            (halt[UDP])
    );

    // PHY MDIO slave BFM
    bfm_phy_mdio #(
      .MDIO_BUFF_ADDR                  (MDIO_BUFF_ADDR + UDP*256),
      .NODE                            (START_NODE+UDP)
    ) phymdio
    (
      .clk                             (mdioclk),
      .arst_n,

`ifdef VERILATOR
      .mdio_en                         (mdio_en[UDP]),
      .mdio_out                        (mdio_out[UDP]),
`endif

      .mdio                            (mdio[UDP])
    );

  end

endgenerate

endmodule
