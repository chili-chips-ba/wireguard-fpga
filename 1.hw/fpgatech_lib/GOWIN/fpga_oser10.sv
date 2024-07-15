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
// Technology-specific GoWin OSERDES10. It provides 10-1 muxing within output pad
///////////////////////////////////////////////////////////////////////////////

module fpga_oser10 (
   input  logic       arst,    // active-high async reset
   input  logic       clk_par, // slower/parallel clock
   input  logic       clk_ser, // faster/serial clock
   input  logic [9:0] d,

   output logic       q
);

   OSER10 #(
     .GSREN ("false"),
     .LSREN ("true")
   )
   u_oser10 (
     .Q     (q),
    
     .D0    (d[0]),
     .D1    (d[1]),
     .D2    (d[2]),
     .D3    (d[3]),
     .D4    (d[4]),
     .D5    (d[5]),
     .D6    (d[6]),
     .D7    (d[7]),
     .D8    (d[8]),
     .D9    (d[9]),
    
     .PCLK  (clk_par),
     .FCLK  (clk_ser),
     .RESET (arst)
  );

endmodule: fpga_oser10

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2022/10/9 JI: initial creation    
*/
