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
// Technology-specific GoWin ISERDES8. It provides 8-1 demuxing within input pad
///////////////////////////////////////////////////////////////////////////////

module fpga_iser8 (
   input  logic       arst,    // active-high async reset
   input  logic       clk_par, // slower/parallel clock
   input  logic       clk_ser, // faster/serial clock
   input  logic       d,

   output logic [7:0] q
);

//   ISER8 #(
//     .GSREN ("false"), // Disable Global Reset
//     .LSREN ("true")   // Enable Local Reset
//   )
//   u_iser8 (
//     .D     (d),
//
//     .Q0    (q[0]),
//     .Q1    (q[1]),
//     .Q2    (q[2]),
//     .Q3    (q[3]),
//     .Q4    (q[4]),
//     .Q5    (q[5]),
//     .Q6    (q[6]),
//     .Q7    (q[7]),
//
//     .PCLK  (clk_par),
//     .FCLK  (clk_ser),
//     .CALIB (1'b0),
//     .RESET (arst)
//  );

endmodule: fpga_iser8

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2022/10/9 JI: initial creation
*/
