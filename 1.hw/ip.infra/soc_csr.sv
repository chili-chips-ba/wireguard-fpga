//==========================================================================
// Copyright (C) 2024-2025 Chili.CHIPS*ba
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
//   CSR (aka GPIO) block for our SOC bus. Standardized template, then 
//   customized to each particular SOC design. 
//
//   This is the CSR register block. While it does not need to be so, for
//   simplicity, we try to keep only one CSR block for the entire SOC.
//
//   Our CSR accepts any-size writes: Byte, HalfWord, FullWord, treating
//   them all as the full 32-bit access. That greatly simplifies register 
//   operations. With it, any variety of Store instruction that the compiler
//   may put to use will still work. Similarly, this allows free register 
//   layout, which now does not need to be aligned with any byte boundaries 
//   within 32-bit word.
//
//   The reads are always full 32-bit access anyway.
//==========================================================================

module soc_csr 
   import soc_pkg::*;
   import csr_pkg::*;
(
   soc_if.SLV          bus,
   csr_pkg::csr__in_t  hwif_in,
   csr_pkg::csr__out_t hwif_out
);
   

//=========================================
// Sim-only
//=========================================
`ifdef SIM_ONLY
`ifdef CSR_DEBUG

   always @(posedge bus.clk) begin
      if ({bus.vld, bus.rdy} == 2'b11) begin
         if (write == 1) begin  
            $display("%t %m WRITE [%08x]<=%08x", $time, 
                     {bus.addr, 2'd0}, bus.wdat);
         end
         if (read == 1) begin  
            $display("%t %m READ [%08x]=>%08x", $time, 
                     {bus.addr, 2'd0}, bus.rdat);
         end
      end
   end
   
`endif
`endif
        
endmodule: soc_csr
