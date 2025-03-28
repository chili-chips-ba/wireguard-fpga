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
// Technology-specific GoWin tri-stateable IOBUF
///////////////////////////////////////////////////////////////////////////////

module fpga_iobuf (
   input  logic  i,   // core input,  to be sent to OUT pad
   output logic  o,   // core output, as received from INP pad
   input  logic  hiz, // core 1 to tri-state OUT, turning it into INP pad

   inout  wire   pad  // IO pad for off-chip signals
);

   IOBUF u_iobuf (
     .I   (i),
     .O   (o),
     .OEN (hiz),
     .IO  (pad)
   );

endmodule: fpga_iobuf

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2023/10/9 JI: initial creation
*/
