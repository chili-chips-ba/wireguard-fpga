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
//   Synchronous FIFO made with technology-specific dual-ported RAM, which
//   should be <block> or <distributed>. This design makes use of the entire 
//   available storage capacity, i.e. it assumes that the storage element is
//   OK with concurrent reading and writing of the same location.
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// For Gowin storage, other than expensive <registers>, we have the 
//  following options:
//
//    1) BSRAM, comes with four configuration modes: 
//       - single-port
//       - semi-dual-port
//       - read-only
//       - dual-port
//
//       BSRAM READ_MODE  can be: PIPELINE and BYPASS
//       BSRAM WRITE_MODE can be: NORMAL, WRITE-THROUGH and READ-BEFORE-WRITE
//
//    2) SSRAM, comes with only first three configuration modes, i.e. it
//       does not offer <dual-port>.
//
// Memory inference is governed by 'syn_ramstyle' attribute which can be 
// attached to: <module name, instance name, register> and can have one of 
// these values: <block_ram, distributed_ram, registers, rw_check, no_rw_check>
//==========================================================================

module sync_fifo_ram #(
   parameter                 DWIDTH = 16,
   parameter                 AWIDTH =  4
)(
   input  logic              arst_n,
   input  logic              clk,
                                         
                                        //-------------------------------------------------
   input  logic [DWIDTH-1:0] din,       // input data into FIFO
   input  logic              we,        // FIFO write enable 
   input  logic              re,        // FIFO read enable
                                         
                                        //----------------------------------------------
   output logic [AWIDTH:0]   dcount,    // fullness (occupancy) of FIFO in DWIDTH words
   output logic              empty,     // 1 when FIFO is empty
   output logic              full,      // 1 when FIFO is full
                                        //
   output logic [DWIDTH-1:0] dout_comb, // "look-ahead" output data from FIFO
   output logic [DWIDTH-1:0] dout       // standard, one clock latency output from FIFO
);
   
   logic we_protected, re_protected;

   typedef logic [AWIDTH-1:0] addr_t;
   typedef logic [AWIDTH  :0] dcount_t;

   addr_t   wr_addr, rd_addr;

   assign full = dcount[AWIDTH];

   // this is a bit more gate-efficient, but results in combo 'empty' output
   // assign {empty, dcount_dec} = dcount - dcount_t'(1);

   assign we_protected = we & ~full;  //-\ logic for prevention of overflow
   assign re_protected = re & ~empty; //-/  and underflow

   
   always_ff @(negedge arst_n or posedge clk) begin: _fifo_ctrl

      if (arst_n == 1'b0) begin   
         dcount  <= '0;
         wr_addr <= '0;
         rd_addr <= '0;

         empty   <= 1'b1;
      end
      else begin 

         if (we_protected == 1'b1) wr_addr <= addr_t'(wr_addr + addr_t'(1));
         if (re_protected == 1'b1) rd_addr <= addr_t'(rd_addr + addr_t'(1));
         
         unique case ({we_protected, re_protected})

            // reading without writing: Decrement data occupancy count
            //  (*) we can to this only when 'empty=0'
            2'b01: begin 
               dcount <= dcount_t'(dcount - dcount_t'(1));
               //dcount <= dcount_dec;
               empty  <= ~|dcount[AWIDTH:1]; // dcount less than of equal 1
            end
             
            // writing without reading: Increment data occupancy count
            //  (*) we can to this only when 'full=0'
            2'b10: begin
               dcount <= dcount_t'(dcount + dcount_t'(1));
               empty  <= 1'b0;
            end
             
            // leave alone if (neither reading nor writing) 
            //  or (simultaneously reading and writing)
            default: begin end
         endcase

      end 
   end: _fifo_ctrl


//------------------------------------------------------------
// storage element
//------------------------------------------------------------
//`ifdef YOSYS
//  generate if (AWIDTH < 8) begin: _dist_ram
//    (* ram_style = "block" *) logic [DWIDTH-1:0] mem [2**AWIDTH];
//  end
//  else begin: _bram
//    (* ram_style = "block" *) logic [DWIDTH-1:0] mem [2**AWIDTH];
//  end
//  endgenerate
//   
//`else // Gowin
//  generate if (AWIDTH < 8) begin: _dist_ram
//    logic [DWIDTH-1:0] mem [2**AWIDTH] /* synthesis syn_ramstyle = "distributed_ram" */;
//  end
//  else begin: _bram
//    logic [DWIDTH-1:0] mem [2**AWIDTH] /* synthesis syn_ramstyle = "block_ram" */; 
//  end 
//  endgenerate
//`endif

   logic [DWIDTH-1:0] mem [2**AWIDTH] /* synthesis syn_ramstyle = "distributed_ram" */;

   always_comb begin
      dout_comb = mem[rd_addr];
   end 

   always_ff @(posedge clk) begin
      if (re_protected == 1'b1) begin
         dout <= dout_comb;
      end

      if (we_protected == 1'b1) begin
         mem[wr_addr] <= din;
      end
   end

endmodule: sync_fifo_ram

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2023/1/2 JI: original creation
*/
