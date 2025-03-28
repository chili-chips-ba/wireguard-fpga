//==========================================================================
// Copyright (C) 2024-2025 Chili.CHIPS*ba
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
//   Ethernet PHY Controller (placeholder)
//==========================================================================

module ethernet_phy (
   output logic  e1_reset,
   output logic  e1_mdc,
   inout  logic  e1_mdio,
   output logic  e2_reset,
   output logic  e2_mdc,
   inout  logic  e2_mdio,
   output logic  e3_reset,
   output logic  e3_mdc,
   inout  logic  e3_mdio,
   output logic  e4_reset,
   output logic  e4_mdc,
   inout  logic  e4_mdio
);
   assign e1_reset = 1'b1;
   assign e2_reset = 1'b1;
   assign e3_reset = 1'b1;
   assign e4_reset = 1'b1;
endmodule