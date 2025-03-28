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
//   Package with declaration commonly used across the entire DPE
//==========================================================================

`ifndef _DPE_PKG
`define _DPE_PKG
package dpe_pkg;
    localparam DPE_ADDR_CPU   = 3'h0;
    localparam DPE_ADDR_ETH_1 = 3'h1;
    localparam DPE_ADDR_ETH_2 = 3'h2;
    localparam DPE_ADDR_ETH_3 = 3'h3;
    localparam DPE_ADDR_ETH_4 = 3'h4;
    localparam DPE_ADDR_BCAST = 3'h7;
endpackage: dpe_pkg
`endif
