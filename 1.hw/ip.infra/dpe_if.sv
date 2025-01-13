//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
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
//   DPE AXI-Stream Interface
//==========================================================================

interface dpe_if #(
    parameter TDATA_WIDTH = 128,
    parameter TUSER_WIDTH = 5
) ();
    logic                               tready;
    logic                               tvalid;
    logic [TDATA_WIDTH-1:0]             tdata;
    logic                               tlast;
    logic [((TDATA_WIDTH+7)/8)-1:0]     tkeep;
    logic [TUSER_WIDTH-1:0]             tuser;
    
    modport m_axis (
        input     tready,
        output    tvalid,
        output    tdata,
        output    tlast,
        output    tkeep,
        output    tuser
    );
    
    modport s_axis (
        output    tready,
        input     tvalid,
        input     tdata,
        input     tlast,
        input     tkeep,
        input     tuser
    );
endinterface
