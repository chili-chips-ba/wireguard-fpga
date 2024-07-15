//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba, All rights reserved.
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
//  Simple Bus Functional Model of ADS1675 ADC, assuming the following 
//  configuration:
//
//   - CS_N       = 0 => always selected
//
//   - LVDS_N     = 0 => interface is LVDS-compatible
//   - SCLK_SEL   = 0 => SCLK is internally generated (ADC PLL for 3 x CLK)
//   - DRATE[2:0] = 5 => High-Speed LVDS Data Retrieval (Figure 1 in datasheet)
//                         Board is weird: ADC is configured for high-speed 
//                         LVDS timing, yet the SCLK is not routed to FPGA!?
//                         DRDY is also not routed to FPGA!!
//
//                    => Oversampling ratio=8 (out of 8,16,32,64,128,256).
//                       Sample rate is therefore: 18MHz/8 = 2.25MSPS,
//                         and Sigma-Delta noise filtration the weakest,
//                         which is another problem with this ADC board.
//                       Also, as Sigma-Delta ADC requires a very clean
//                       Master CLK, the board should NOT have been
//                       sourcing ADC clock from FPGA
//
//   - FPATH      = 0 => WideBandwidth filter (vs LowLatency)
//   - LL_CONFIG  = 1 => LowLatency FastResponse settling (vs SingleCycle).
//                       Must be 1 for WideBandwidth mode. If 0, it overrides
//                       FPATH setting and forces ADC to LowLatency filter
//
// For our WideBandwidth configuration with DRATE=101, DRDY settling time 
// is 1324 SCLK cycles (13790ns@96MHz). See Table 6 and Figure 48 of ADC
// datasheet: ADC.ads1675.pdf
//==========================================================================

`timescale 1ps/1ps

module bfm_adc (    
   input  logic adc_pwdn_n,     // Active-0, ADC power-down control
                                 
   input  logic adc_clk,        // Master clock. Drives x3 PLL within ADC
   input  logic adc_start,      // 1 to start conversion and when measurement is running

   output logic adc_dout_p,     // -\ LVDS serial data from ADC.
   output logic adc_dout_n      // -/ Board does not provide the corresponding clock
);

   // From ADC datasheet: TIMING REQUIREMENTS for High-Speed LVDS mode, page7, Fig.1 and Fig.2
   localparam tLPLLSTL_US  = 80;    // PLL settling time
   localparam tLDRPW       = 3;     // DRDY pulse width: 2-to-4 tLSCLKs
   localparam tLSCLKDR_PS  = 2_500; // SCLK-to-DRDY delay: 2.0-to-3.0ns
   localparam tLDOPD_PS    = 2_000; // SCLK-to-DOUT delay: 1.5-to-2.5ns
   localparam tLCLKSCLK_NS = 16;    // Delay from posedge(CLK) to posedge(SCLK): 13-to-20ns

   localparam tSTART_CLK   = 0.5;   // posedge(START) to posedge(CLK) setup time: Min 0.5 CLK period
   localparam tSTART       = 2;     // START pulse width: Min 2 CLK periods

   localparam tSCLK_HALF_PERIOD_NS = 9; // 54MHz clock

 `ifdef SIM_ONLY
   localparam tSETTLE_SCLK = 9;
 `else
   localparam tSETTLE_SCLK = 1324; // Number of clock for filter to "settle" upon start
 `endif                            // of measurement. Per ADC datasheet Table6 and Fig.48
   
//----------------------
// PowerUp/Down delay
//----------------------
   bit powered_up;
   
   initial begin
      powered_up = 1'b1;

      forever @(adc_pwdn_n) begin
         // disable immediately
         if (adc_pwdn_n == 1'b0) begin
            powered_up = 1'b0;
         end
         // enable with specified delay
         else begin   
            #(tLPLLSTL_US * 1us);
            powered_up = 1'b1;
         end
      end
   end

//----------------------
// 3xPLL for SCLK
//----------------------
   //realtime     clk_posedge[2];
   //int unsigned clk_period;
   //assign clk_period = clk_posedge[0] - clk_posedge[1];

   bit sclk, sclk_dseg[4], sclk_dly;
   
   initial begin
      sclk = 1'b0;

      forever @(posedge adc_clk) begin
         //clk_posedge[0] <= $time;
         //clk_posedge[1] <= clk_posedge[0];
          
         repeat (3) if (powered_up == 1'b1) begin
            sclk = 1'b1;
            #(tSCLK_HALF_PERIOD_NS * 1ns);
            sclk = 1'b0;
            #(tSCLK_HALF_PERIOD_NS * 1ns);
         end
      end // forever @(posedge adc_clk)
   end // initial begin

   
   // since this delay is too large, close to 1 SCLK period, 
   // break it into multiple chunks
   always @(sclk)         sclk_dseg[0] = #(tLCLKSCLK_NS/4 * 1ns) sclk;
   always @(sclk_dseg[0]) sclk_dseg[1] = #(tLCLKSCLK_NS/4 * 1ns) sclk_dseg[0];
   always @(sclk_dseg[1]) sclk_dseg[2] = #(tLCLKSCLK_NS/4 * 1ns) sclk_dseg[1];
   always @(sclk_dseg[2]) sclk_dseg[3] = #(tLCLKSCLK_NS/4 * 1ns) sclk_dseg[2];

   assign sclk_dly = sclk_dseg[3];

   
//----------------------
// START and SETTLE delay
//----------------------
   logic [1:0] start;

   logic [$clog2(tSETTLE_SCLK)-1:0] settle_cnt = '1;

   logic       settled;
   assign      settled = (settle_cnt == '0);

   // START used internally is double-clocked for synchronization
   always @(posedge adc_clk) begin
      start <= {start[0], adc_start};
   end

   always @(posedge sclk) begin
      if (powered_up == 1'b0) begin
         settle_cnt <= '1;
      end   
      else if (start[1] == 1'b0) begin
         settle_cnt <= tSETTLE_SCLK-1;
      end
      else if (settled == 1'b0) begin
         settle_cnt <= settle_cnt - 1;
      end
   end


//----------------------
// Output data
//----------------------
   bit          drdy, adc_drdy;
   bit          dout;

   bit [23:0]   sample;
   int unsigned sample_cnt;
   int unsigned bit_cnt;
 
   initial begin
      drdy       = 1'b0;
      sample     = 24'($random);
      sample_cnt = 0;
      bit_cnt    = 0;

      dout       = 1'b0;
      
      forever @(posedge sclk_dly) begin
         if (start[1] == 1'b0) begin
            drdy       = 1'b0;
            sample_cnt = 0;
            bit_cnt    = 0;
             
            dout       = 1'b0;
         end
         else if (settled == 1'b1) begin
            if (bit_cnt == 0) begin
               drdy    = 1'b1;
               bit_cnt = 23;
            end
            else begin
               bit_cnt--;
            end
               
            if (bit_cnt == (23 - tLDRPW)) drdy = 1'b0;

            dout = sample[bit_cnt]; // MSB goes out first
             
            if (bit_cnt == 0) begin
               sample_cnt++;
             
            `ifdef ADC_BFM_DEBUG
               $display("%t %m Sent sample#%0d \t%0h", 
                        $time, sample_cnt, sample);
            `endif   

               sample++;
            end
         end // if ({start[1], settled} == 2'b11)
      end // forever @(posedge sclk)
   end // initial begin
                        

//----------------------
// Output delays
//----------------------
   always @(posedge sclk_dly) #(tLSCLKDR_PS * 1ps) adc_drdy   = drdy;
   always @(posedge sclk_dly) #(tLDOPD_PS   * 1ps) adc_dout_p = dout;

   assign adc_dout_n = ~adc_dout_p;

endmodule: bfm_adc

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/4/15 JI: initial creation    
*/
