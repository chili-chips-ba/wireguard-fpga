//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
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
//   Clock and reset generation. It includes standard and SOC-specific elements.
//   Customized for Sipeed TangNano20K board and Elreg nextgen Sonar+Doppler
//==========================================================================

module clk_rst_gen 
   import soc_pkg::*;
(
   input  logic        clk_27,    // 27MHz clock oscillator on TangNano20K
   input  logic [2:0]  clk_fpll,  // clock from onboard FractionalPLL (MS5351)
   input  logic        force_rst, // 1 to forcible reset everything 
                        
   output logic        clk_54,    // clk_27 x 2
   output logic        srst54_n,  // reset synchronized to clk_54

   output logic        strobe_27, // 27Mhz strobe for clk_54
   output logic        tick_1us   // pulse1 tick every 1us
);

   fpga_pll u_pll (
      .clk_27    (clk_27),       //i
      .force_rst (force_rst),    //i            

      .srst_n    (srst54_n),     //o
      .clk_54    (clk_54),       //o
      .clk_108   ()              //o
   );


//-----------------------------------------------------
// Clock strobes, markers and ticks
//-----------------------------------------------------
   cnt_1us_t  cnt_1us;

   always_ff @(negedge srst54_n or posedge clk_54) begin
      if (srst54_n == 1'b0) begin
         strobe_27 <= 1'b0;

         tick_1us  <= 1'b0;
         cnt_1us   <= '0;
      end
      else begin
         strobe_27 <= ~strobe_27;

         // number of clocks for 1us time-tick pulse depends 
         //   on board, i.e. the period of available clocks
         tick_1us  <= (cnt_1us == cnt_1us_t'(NUM_1US_CLKS-1));

         if (tick_1us == 1'b1) begin
            cnt_1us <= '0;
         end         
         else begin
            cnt_1us <= cnt_1us_t'(cnt_1us + cnt_1us_t'(1));
         end
      end
   end
   
endmodule: clk_rst_gen

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/4/7 JI: initial creation    
*/
