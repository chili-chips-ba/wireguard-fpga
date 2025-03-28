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
// Technology-specific GoWin output buffer
///////////////////////////////////////////////////////////////////////////////

module fpga_obuf (
   input  logic  i, // core input,  to be sent to OUT
   output logic  o  // core output, as received from INP
);

   OBUF u_obuf (.O(o), .I(i));

endmodule: fpga_obuf

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/02/14 TI: initial creation
*/
