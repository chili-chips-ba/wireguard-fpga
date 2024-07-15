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
// Technology-specific GoWin ODDR
///////////////////////////////////////////////////////////////////////////////

module fpga_oddr (
   input  logic       clk,
   input  logic [1:0] d,
   output logic       q
);

   ODDR #(
     .INIT      (1'b0),
     .TXCLK_POL (1'b0)  // clock polarity to drive Q1 with
   )
   u_oddr (
     .Q0        (q),
     .Q1        ( ),    // used for IOBUF OE_N 
     .D0        (d[0]), // goes out on rising  edge Q0
     .D1        (d[1]), // goes out on falling edge Q0
     .TX        (1'b0),
     .CLK       (clk)
   );
    
endmodule: fpga_oddr

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2022/10/9 JI: initial creation    
*/
