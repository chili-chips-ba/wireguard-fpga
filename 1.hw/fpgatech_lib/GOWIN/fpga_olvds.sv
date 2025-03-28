///////////////////////////////////////////////////////////////////////////////
//
// (c) Copyright 2022 -- CHILI CHIPS LLC, All rights reserved.
//
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//-----------------------------------------------------------------------------
// Technology-specific GoWin LVDS output buffer
///////////////////////////////////////////////////////////////////////////////

module fpga_olvds (
   input  logic i,
   output logic o,
   output logic ob
);

  //ELVDS_OBUF u_olvds ( // Emulated
    TLVDS_OBUF u_olvds ( // True
      .O   (o),
      .OB  (ob),

      .I   (i)
    );

endmodule: fpga_olvds

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2022/10/10 JI: initial creation
*/
