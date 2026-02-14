// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
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
