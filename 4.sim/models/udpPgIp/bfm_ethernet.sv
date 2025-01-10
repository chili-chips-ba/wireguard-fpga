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
#(parameter                            START_NODE    = 1,
  parameter                            NUM_PORTS     = 4)
(
  input                                clk,

  // GMII interface
  gmii_if.SLV                          gmii [0:NUM_PORTS-1],

  // MDIO interface
  inout       [NUM_PORTS-1:0]          mdio,
  
  // Simulation halt request
  output                               halt_req
);

wire [7:0]                             halt;

assign mdio                         = {NUM_PORTS{1'bz}};
assign halt_req                     = |halt;

genvar UDP;
generate

  for (UDP = 0; UDP < NUM_PORTS; UDP++)
  begin
    udp_ip_pg #(.NODE(START_NODE+UDP)) udpIpPg
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

  end

endgenerate

endmodule