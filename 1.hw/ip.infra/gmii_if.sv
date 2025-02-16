//==========================================================================
// Copyright (C) 2025 Chili.CHIPS*ba
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
//  GMII interface
//==========================================================================

interface gmii_if (
   input  logic arst_n, // asynchronous, active-low reset  
   input  logic clk     // bus clock
);

   logic [7:0]     txd;
   logic           txen;
   logic           txer;
   
   logic [7:0]     rxd;
   logic           rxdv;
   logic           rxer;

  //---------------------------------------- 
  // master side
  //---------------------------------------- 
   modport MST (
     output txd,
            txen,
            txer,

     input  arst_n, clk,
            rxd,
            rxdv,
            rxer
   );

  //---------------------------------------- 
  // Slave side
  //---------------------------------------- 
   modport SLV (
     input  arst_n, clk,
            txd,
            txen,
            txer,

     output rxd,
            rxdv,
            rxer
   );

endinterface: gmii_if
