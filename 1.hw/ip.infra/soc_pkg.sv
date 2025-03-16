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
//   - Package with declaration commonly used across the entire SOC
//==========================================================================

package soc_pkg;

//-----------------------------------------
// parameters that can be customized to your SOC
//-----------------------------------------
   localparam SOC_ADDRW = 32;
   localparam SOC_DATAW = 32;

//--------------------------------------
// Timebase Generator
//--------------------------------------
// Clock period in full pico-seconds. Round down to the nearest integer
   localparam PERIOD_PS = 12_500; // 80 MHz clock
                                      
// number of clocks needed for 1usec period (-1 because we count from 0)
   localparam NUM_1US_CLKS  = (1_000_000 / PERIOD_PS) - 1; 
   localparam CNT_1US_WIDTH = $clog2(NUM_1US_CLKS);
   
   typedef logic [CNT_1US_WIDTH-1:0] cnt_1us_t;

   
//-----------------------------------------
// derived values. Don't touch anything in this section
//-----------------------------------------
`ifdef USE_OWN_CLOG2
   function int clog2 (
      input int value
   );
      int temp;
      temp = value - 1;
 
      for (clog2 = 0; temp > 0; clog2++) begin
         temp = temp >> 1;
      end
   endfunction: clog2
`endif

   
//- - - - - - - - - - - - - - - - - - - - -
   localparam SOC_BYTES = SOC_DATAW / 8;     // 4 for 32-bit data bus
   localparam SOC_ADDRL = $clog2(SOC_BYTES); // 2 for 32-bit data bus
   
   typedef logic [SOC_ADDRW-1:SOC_ADDRL] soc_addr_t; // address is in the full data words
   typedef logic [SOC_BYTES-1:0]         soc_we_t;   // per-byte Write Enables. They serve as decoded addr LSBs
   typedef logic [SOC_DATAW-1:0]         soc_data_t; // Write Data

   typedef enum logic {LO = 1'b0, HI = 1'b1} soc_boolean_t;

   typedef struct packed {
      logic p; // [1]
      logic n; // [0]
   } diff_t; // differential data type

//   //instruction opcode with corresponding decode
//   typedef enum logic [6:0] {
//      ALUREG = 7'b0110011,    //-\ ALU Data
//      ALUIMM = 7'b0010011,    //-/ instructions 
//                               
//      BRNCH  = 7'b1100011,    //-\ 
//      JALR   = 7'b1100111,    // | Code flow 
//      JAL    = 7'b1101111,    // | instructions
//      AUIPC  = 7'b0010111,    //-/ 
//                               
//      LUI    = 7'b0110111,    //-\ Load/Store 
//      LOAD   = 7'b0000011,    // | instructions
//      STORE  = 7'b0100011,    //-/ 
//                               
//      SYSTEM = 7'b1110011     //- special
//   } opcode_t;

//   typedef struct packed {
//      logic         imm20;    // [31]
//      logic [10:1]  imm10_1;  // [30:21]
//      logic         imm11;    // [20]
//      logic [19:12] imm19_12; // [19:12]
//      logic [4:0]   rd;       // [11:7]
//   } grp_jump_t;
// 
//   //union declaration for variable parts of instruction, [31:7]
//   typedef union packed {
//      grp_reg2reg_t reg2reg;  //[31:7]-InstrGroup#1
//      grp_imm_t     imm;      //[31:7]-InstrGroup#2
//      grp_uimm_t    uimm;     //[31:7]-InstrGroup#3
//      grp_store_t   store;    //[31:7]-InstrGroup#4
//      grp_brnch_t   brnch;    //[31:7]-InstrGroup#5
//      grp_jump_t    jump;     //[31:7]-InstrGroup#6
//   } grp_t;
   
endpackage: soc_pkg

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2023/12/10 JI: initial creation    
*/
