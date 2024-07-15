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
// Description: Simulation testbench for FPGA. It provides models of 
//              external resources, as connected on the actual board
//==========================================================================

`timescale 1ps/1ps

module tb #(
   parameter int RUN_SIM_US = 15_000
)();

   localparam DLY_PCB_PAD_PS = 1_000;
   
//--------------------------------------------------------------
// Generate clock and run sim for the specified amount of time
   localparam  HALF_PERIOD_PS = 18_518; // 27MHz
   logic       clk_27;
   logic [2:0] clk_fpll;
   logic [2:1] key;

   initial begin
      key      = 2'b0;
      clk_27   = 1'b0;
      clk_fpll = '0; // FIXME, add corresponding generators if used in future
      
      fork 
         forever begin: clock_gen
            #(HALF_PERIOD_PS * 1ps) clk_27 = ~clk_27;
         end

         begin: run_sim
            #(RUN_SIM_US * 1us);
            $finish(2);
         end
      join
   end

//--------------------------------------------------------------
   logic        uart_rx, uart_tx;
   logic [3:2]  led_n;
    
   logic        O_sdram_clk,
                O_sdram_cke,
                O_sdram_cs_n,
                                       
                O_sdram_ras_n,
                O_sdram_cas_n,
                O_sdram_wen_n;
   logic [1:0]  O_sdram_ba;
   logic [10:0] O_sdram_addr;
   logic [3:0]  O_sdram_dqm;
   wire  [31:0] IO_sdram_dq;

   logic [2:1]  adc_ssr;
   logic [2:1]  adc_inject;
   logic [2:1]  adc_pwdn_n;
   logic [2:1]  adc_start;
   logic [2:1]  adc_clk,    adc_clk_dly;
   logic [2:1]  adc_dout_p, adc_dout_p_dly;
   logic [2:1]  adc_dout_n, adc_dout_n_dly ;

   logic        dac_clk_out;
   logic        dac_pwd;
   logic [9:0]  dac_data;

   always @(adc_clk)    #(DLY_PCB_PAD_PS * 1ps) adc_clk_dly    = adc_clk;
   always @(adc_dout_p) #(DLY_PCB_PAD_PS * 1ps) adc_dout_p_dly = adc_dout_p;
   always @(adc_dout_n) #(DLY_PCB_PAD_PS * 1ps) adc_dout_n_dly = adc_dout_n;
   
      
   top dut (
      .clk_27        (clk_27),            
      .clk_fpll      (clk_fpll),
      .key           (key),     // active-HI, S1:UserFunction S2:Reset 2:1
      .led_n         (led_n),   // active-LO onboard LEDs              5:0
                             
      .uart_rx       (uart_rx), //i -\ UART towards BL616
      .uart_tx       (uart_tx), //o -/ 
    
    // Embedded SDRAM
      .O_sdram_clk   (O_sdram_clk),
      .O_sdram_cke   (O_sdram_cke),
      .O_sdram_cs_n  (O_sdram_cs_n),
                               
      .O_sdram_ras_n (O_sdram_ras_n),
      .O_sdram_cas_n (O_sdram_cas_n),
      .O_sdram_wen_n (O_sdram_wen_n),
                                     
      .O_sdram_ba    (O_sdram_ba),  
      .O_sdram_addr  (O_sdram_addr),
      .O_sdram_dqm   (O_sdram_dqm),
                      
      .IO_sdram_dq   (IO_sdram_dq),
                      
    // ADC            
      .adc_ssr       (adc_ssr   ),
      .adc_inject    (adc_inject),
      .adc_pwdn_n    (adc_pwdn_n),
      .adc_start     (adc_start ),
      .adc_clk       (adc_clk   ),
      .adc_dout_p    (adc_dout_p_dly),
      .adc_dout_n    (adc_dout_n_dly),

    // DAC
      .dac_clk_out   (dac_clk_out),
      .dac_pwd       (dac_pwd),
      .dac_data      (dac_data)
   );

//--------------------------------------------------------------
// model of external SDRAM
//--------------------------------------------------------------
   import sdram_pkg::sdram_data_t;

   sdram_data_t  Dq_in, Dq_out;
   logic         Data_in_enable, Data_out_enable;

   sdr bfm_sdram (
      .Clk             (O_sdram_clk),    //i 
      .Cke             (O_sdram_cke),    //i 
      .Cs_n            (O_sdram_cs_n),   //i 
                                          
      .Ras_n           (O_sdram_ras_n),  //i 
      .Cas_n           (O_sdram_cas_n),  //i 
      .We_n            (O_sdram_wen_n),  //i 
                                          
      .Ba              (O_sdram_ba),     //i'sdram_ba_t 
      .Addr            (O_sdram_addr),   //i'sdram_row_t 
      .Dqm             (O_sdram_dqm),    //i'sdram_dqm_t 
                                          
    //.Dq              (),               //io[DATA_WIDTH-1:0] 
      .Dq_in           (IO_sdram_dq),    //i'sdram_data_t
      .Dq_out          (IO_sdram_dq)     //o'sdram_data_t
   );


//--------------------------------------------------------------
// model of external UART
//--------------------------------------------------------------
   bfm_uart bfm_uart (
      .uart_rx  (uart_tx), //i 
      .uart_tx  (uart_rx)  //o
   );


//--------------------------------------------------------------
// model of external DAC
//--------------------------------------------------------------
   bfm_dac #(
      .BASE_TOLERANCE (0.05), // Tolerance for comparison dac data: 0.05 gives errors
      .SIN_TOLERANCE  (0.3),  // Tolerance for comparison sin data
      .HANN_TOLERANCE (0.35), // Tolerance for comparison hann data
      .SCALE_FACTOR   (1024),
    
      .SIN_AMPL       (512),
      .SIN_LUT_SIZE   (1024),
      .HANN_AMPL      (1024),
      .HANN_LUT_SIZE  (64)    // Half of the actual size
   )
   bfm_dac (
      .dac_clk_out    (dac_clk_out), //i 
      .dac_data       (dac_data)     //i
   );


//--------------------------------------------------------------
// model of external ADC
//--------------------------------------------------------------
   bfm_adc bfm_adc[2:1] (    
     .adc_pwdn_n (adc_pwdn_n),
                  
     .adc_clk    (adc_clk_dly),
     .adc_start  (adc_start),
                  
     .adc_dout_p (adc_dout_p),
     .adc_dout_n (adc_dout_n)
  );


//--------------------------------------------------------------
// Error monitor
//--------------------------------------------------------------
    always @(dut.csr.misc.error) begin: error_mon
       $write("%t %m (%0d) - ", $time, dut.csr.misc.error);

       case (dut.csr.misc.error)
         4'd0   : $display("ERROR_CLEARED");
                 
         4'd1   : $display("UART_RX_OVERFLOW");
         4'd2   : $display("ANOTHER_CMD_PENDING (drop new Cmd)");
         4'd3   : $display("ANOTHER_CMD_IN_RX (interrupt it and start new Cmd)");
         4'd4   : $display("UNEXPECTED_CHAR");
         4'd5   : $display("ILLEGAL_CMD_CHAR");
         4'd6   : $display("INVALID_ANUM (Cmd dropped)");
         4'd7   : $display("ADC1_CMD_DROPPED");
         4'd8   : $display("ADC2_CMD_DROPPED");
         4'd9   : $display("DAC1_CMD_DROPPED");
         4'd10  : $display("DAC2_CMD_DROPPED");
         4'd11  : $display("INVALID_CMD_ID");

         default: $display("UNKNOWN");
       endcase
    end


//--------------------------------------------------------------
/* Assertions have to be done like this

    always_ff @(posedge clk) begin

       $display("a = %b, b = %b, c = %b, y = %b",a,b,c,y);

       if ($past(b) > 2'b0) begin
          if (y !== 1'b1) $fatal("Assertion failed for Test Case: b > 2'b0");
       end 
       else begin
          if (y !== 1'b0) $fatal("Assertion failed for Test Case: b <= 2'b0");
       end
    end
*/

endmodule: tb

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/02/14 TI: initial creation    
 2024/02/25 JI: adapted to Verilation limitations in handling HiZ and INOUT ports
 2024/03/28 JI: added DAC
*/
