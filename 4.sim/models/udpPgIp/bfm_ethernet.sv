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
  parameter                            MDIO_BUFF_ADDR = 32'h50000000)
(
  input                                clk,
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

wire [NUM_PORTS-1:0]                   halt;

assign halt_req                     = |halt;

genvar UDP;
generate

  for (UDP = 0; UDP < NUM_PORTS; UDP++)
  begin
  
    // UDP/IPv4 ethernet BFM
    udp_ip_pg #(
      .NODE(START_NODE+UDP)
    ) udpIpPg
    (
      .clk                              (clk),

      .txd                              (gmii[UDP].rxd),
      .txen                             (gmii[UDP].rxdv),
      .txer                             (gmii[UDP].rxer),

      .rxd                              (gmii[UDP].txd),
      .rxdv                             (gmii[UDP].txen),
      .rxer                             (gmii[UDP].txer),

      .halt                             (halt[UDP])
    );


    // PHY MDIO slave BFM
    bfm_phy_mdio #(
      .MDIO_BUFF_ADDR                    (MDIO_BUFF_ADDR),
      .NODE                              (START_NODE+UDP)
    ) phymdio
    (
      .clk                               (mdioclk),
      .arst_n,

`ifdef VERILATOR
      .mdio_en                           (mdio_en[UDP]),
      .mdio_out                          (mdio_out[UDP]),
`endif

      .mdio                              (mdio[UDP])
    );

  end

endgenerate

endmodule