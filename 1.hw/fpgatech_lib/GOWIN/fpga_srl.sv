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
// Description: Behavioral description of shift register that can be targeted
//              to Xilinx SRL comps, thus offering considerable gate savings
//              and timing performance. While Gowin also has ability to target
//              shift registers to SSRAM and BSRAM, they are not as efficient
//              as Xilinx SRL
//==========================================================================

module fpga_srl #(
   parameter DWIDTH         = 32, // width of datapath
   parameter AWIDTH         =  5, // binary depth of the shift register
   parameter DEPTH_REDUCTOR =  0  // how many locations to subtract from the binary depth.
)(                                //  E.g. 0 for ADEPTH=6 gives the full binary 0to63 range,
                                  //  while 16 reduces is to 0to47, saving one SRL16 per data
                                  //  bit. It should be specified in increments of 16 and not
                                  //  exceed the range specified by AWIDTH
   output logic [DWIDTH-1:0] dout_comb,
 
   input  logic [DWIDTH-1:0] din,
   input  logic [AWIDTH-1:0] addr,
   input  logic              we,
   input  logic              clk
);

   localparam DEPTH = 2**AWIDTH - DEPTH_REDUCTOR;
    
//`ifdef XILINX
//   (* shreg_extract="yes" *) (* srl_style = "srl" *)
//   logic [DWIDTH-1:0] shift_reg[DEPTH];
// 
//`else // Gowin
//  // BSRAM target: syn_srlstyle = "block_ram"
//  // SSRAM target: syn_srlstyle = "distributed_ram"
//  // FF    target: syn_srlstyle = "registers"
//   logic [DWIDTH-1:0] shift_reg[DEPTH] /* synthesis syn_srlstyle = "distributed_ram" */;
//`endif

   typedef logic [DWIDTH-1:0] data_t;
   data_t [DEPTH-1:0] shift_reg /* synthesis syn_srlstyle = "distributed_ram" */;
   // %Error-BLKLOOPINIT: Unsupported: Delayed assignment to array inside for loops (non-delayed is ok - see docs)

   always_ff @(posedge clk) begin: _shift_reg
      if (we == 1'b1) begin
         shift_reg[0]    <= din;
          
         for (int i=1; i<DEPTH; i++) begin
            shift_reg[i] <= shift_reg[i-1];
         end
      end
   end: _shift_reg

   always_comb begin
      dout_comb = shift_reg[addr];
   end 

   
//--------------------------------------------
// initialize SHIFT_REGISTER with random values for sim
//--------------------------------------------

/*
 // synthesis translate_off
    initial begin
      for (int i=0; i<DEPTH; i++) begin
         shift_reg[i] = DWIDTH'($random);
      end
    end
 // synthesis translate_on
*/

endmodule: fpga_srl

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2023/1/2 JI: original creation
*/
