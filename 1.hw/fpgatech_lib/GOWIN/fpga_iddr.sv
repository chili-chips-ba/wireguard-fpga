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
// Technology-specific GoWin IDDR
///////////////////////////////////////////////////////////////////////////////

module fpga_iddr (
  input  logic       clk,
  input  logic       d,
  output logic [1:0] q
);

  IDDR #(
    .Q0_INIT (1'b0),
    .Q1_INIT (1'b0)
  )
  u_iddr (
    .Q0      (q[0]), // D captured with posedge
    .Q1      (q[1]), // D captured with negedge
    .D       (d),
    .CLK     (clk)
  );

endmodule: fpga_iddr

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2022/10/9 JI: initial creation
*/
