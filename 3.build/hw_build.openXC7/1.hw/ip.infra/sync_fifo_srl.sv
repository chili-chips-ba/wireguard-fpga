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
//   Shallow synchronous FIFO made with technology-specific shift registers.
//
//   Compared to implementation with standard dual-port RAM based FIFO storage,
//   this design is smaller in size, as it does not need to maintain explicit
//   WritePointer. Its ReadPointer can also serve as occupancy counter, which
//   further reduces flop and logic utilization.
//
//   This is an interesting, thought provoking approach, hence good for teaching
//==========================================================================

module sync_fifo_srl #(
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

   addr_t  rd_addr;

   assign dcount = dcount_t'({empty, rd_addr} + dcount_t'(1));
   assign full   = dcount[AWIDTH];

   assign we_protected = we & ~full;  //-\ logic for prevention of overflow
   assign re_protected = re & ~empty; //-/  and underflow


   always_ff @(negedge arst_n or posedge clk) begin: _fifo_ctrl

      if (arst_n == 1'b0) begin
         rd_addr <= '1;
         empty   <= 1'b1;
      end
      else begin
         unique case ({we_protected, re_protected})

            // reading without writing: Decrement data occupancy count
            //  (*) we can to this only when 'empty=0'
            2'b01: begin
               {empty, rd_addr} <= {empty, rd_addr} - dcount_t'(1);
            end

            // writing without reading: Increment data occupancy count
            //  (*) we can to this only when 'full=0'
            2'b10: begin
               {empty, rd_addr} <= {empty, rd_addr} + dcount_t'(1);
            end

            // leave alone if (neither reading nor writing)
            //  or (simultaneously reading and writing)
            default: begin end
         endcase

      end

      if (re_protected == 1'b1) begin
         dout <= dout_comb;
      end

   end: _fifo_ctrl


//------------------------------------------------------------
// storage element
//------------------------------------------------------------
   fpga_srl #(
      .DWIDTH     (DWIDTH),
      .AWIDTH     (AWIDTH)
   ) u_srl (
      .dout_comb  (dout_comb),

      .din        (din),
      .addr       (rd_addr),
      .we         (we_protected),
      .clk        (clk)
   );


//------------------------------------------------------------
// checkers
//------------------------------------------------------------

// synthesis translate_off
`ifdef SIM_ONLY
   initial begin
      if (AWIDTH < 4) begin
         $display ("\n%m - Minimum AWIDTH for SRL16 is 4\n");
         $stop;
      end
      else if (AWIDTH > 8) begin
         $display ("\n%m - SRL16 may not be the best choice for AWIDTH > 8. Consider using RAM!\n");
         $stop;
      end

      dout = DWIDTH'($random);
   end
`endif
// synthesis translate_on

endmodule: sync_fifo_srl

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2023/1/2 JI: original creation
*/
