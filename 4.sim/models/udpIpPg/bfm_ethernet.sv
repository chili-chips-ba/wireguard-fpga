//==========================================================================
// Copyright (C) 2025 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
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