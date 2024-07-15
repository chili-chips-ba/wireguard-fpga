//==========================================================================
// Copyright (C) 2023 Chili.CHIPS*ba
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
//  This is our standard SOC bus interface.
//    - Synchronous bus interface based on Valid/Ready handshake
//    - It supports single-cycle and multi-cycle transactions
//    - ... as well as Single(atomic) and Burst trasactions
//    - Multi-cycle (with wait) transactions don't have a TimeOut (TO) mechanism
//
//  Transaction Examples:
//    IDLE->WRITE->IDLE
//    IDLE->WRITE->WAIT->WAIT->IDLE
//    IDLE->READ ->IDLE
//    IDLE->READ ->WAIT->IDLE
//    IDLE->WRITE->WRITE->READ->READ->WRITE->IDLE
//==========================================================================

interface soc_if (
   input  logic arst_n, // asynchronous, active-low reset  
   input  logic clk     // bus clock
);

   import soc_pkg::*;
   
   logic        vld;    // 1 for access REQuest     -\ transacion is performed
   logic        rdy;    // 1 for access ACKnowledge -/ when both vld&rdy are 1

   soc_addr_t   addr; 
   soc_we_t     we;     // access is WRITE for (vld & |we). READ for (vld & ~|we)
   soc_data_t   wdat;
   soc_data_t   rdat;

  //---------------------------------------- 
  // master/CPU side
  //---------------------------------------- 
   modport MST (
     output vld,
            addr,
            we, wdat,

     input  arst_n, clk,
            rdy,
            rdat
   );

  //---------------------------------------- 
  // Slave/Peripheral side
  //---------------------------------------- 
   modport SLV (
     input  arst_n, clk,
            vld,
            addr,
            we, wdat,

     output rdy,
            rdat
   );

endinterface: soc_if

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2023/12/20 JI: initial creation    
*/
