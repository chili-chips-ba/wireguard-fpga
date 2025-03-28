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
//
//   See 'csr_pkg.sv for register map detail...
//==========================================================================

module soc_csr
   import soc_pkg::*;
   import csr_pkg::*;
(
   soc_if.SLV  bus,
   csr_if.MST  csr
);

//-----------------------------------------
// Access and address decoder
//-----------------------------------------
   logic  any_write, write, read;
   sel_t  sel;

   always_comb begin

      // write of any of 4 bytes is treated as the full 32-bit access
      any_write = |bus.we;

      write = bus.vld &  any_write;
      read  = bus.vld & ~any_write;

      sel = '0;

      unique case (bus.addr[CSR_ADDR_MSB:2])
         ADDR_UART_TX :  sel.uart_tx = HI;
         ADDR_UART_RX :  sel.uart_rx = HI;

         ADDR_ADC1_TX :  sel.adc1_tx = HI;
         ADDR_ADC1_RX :  sel.adc1_rx = HI;

         ADDR_ADC2_TX :  sel.adc2_tx = HI;
         ADDR_ADC2_RX :  sel.adc2_rx = HI;

         ADDR_GPO     :  sel.gpo     = HI;
         ADDR_GPI     :  sel.gpi     = HI;

         ADDR_DAC1    :  sel.dac1    = HI;
         ADDR_DAC2    :  sel.dac2    = HI;

         ADDR_MISC    :  sel.misc    = HI;

         default: begin end
      endcase
   end

//-----------------------------------------
// WRITE register(s):
//-----------------------------------------
   always_ff @(negedge bus.arst_n or posedge bus.clk) begin: wr_reg
      if (bus.arst_n == LO) begin
         csr.gpo.led_off    <= INIT_GPO.led_off;

         csr.dac1_hann_step <= INIT_DAC.hann_step;
         csr.dac1_sin_tune  <= INIT_DAC.sin_tune;

         csr.dac2_hann_step <= INIT_DAC.hann_step;
         csr.dac2_sin_tune  <= INIT_DAC.sin_tune;

         csr.misc.error     <= INIT_MISC.error;
      end

     // Only full 32-bit writes are accepted
      else if (write == HI) begin
         unique case (HI)
            sel.gpo : begin
                      csr.gpo.led_off    <= bus.wdat[1:0];
                      end

                      // ignore DAC write for an active session
            sel.dac1: if (csr.dac1_busy == 1'b0) begin
                      csr.dac1_hann_step <= bus.wdat[25:16];
                      csr.dac1_sin_tune  <= bus.wdat[14:0];
                      end

                      // ignore DAC write for an active session
            sel.dac2: if (csr.dac2_busy == 1'b0) begin
                      csr.dac2_hann_step <= bus.wdat[25:16];
                      csr.dac2_sin_tune  <= bus.wdat[14:0];
                      end

            sel.misc: begin
                      csr.misc.error     <= bus.wdat[3:0];
                      end

            default: begin end
         endcase // unique case (HI)
      end
   end: wr_reg


//-----------------------------------------
// WR/RD Triggers
//  (*) not directly visible to SW, internally used by HW
//-----------------------------------------
   always_comb begin: trig
      csr.uart_tx_write   = write & sel.uart_tx;
      csr.uart_rx_read    = read  & sel.uart_rx;

      csr.adc1_tx_write   = write & sel.adc1_tx;
      csr.adc2_tx_write   = write & sel.adc2_tx;

      csr.dac1_write      = write & sel.dac1;
      csr.dac2_write      = write & sel.dac2;

    // remap write data (this code does not consume logic)
      csr.uart_tx_data    = bus.wdat[7:0];

      csr.adc1_tx_test    = bus.wdat[15];
      csr.adc1_tx_time_us = bus.wdat[14:0];

      csr.adc2_tx_test    = bus.wdat[15];
      csr.adc2_tx_time_us = bus.wdat[14:0];
   end: trig


//-----------------------------------------
// READ Mux
//-----------------------------------------
   always_comb begin: rd_mux
      bus.rdat = '0;

      unique case (HI)

        //___UART
         sel.uart_tx   : bus.rdat[31]   = csr.uart_tx_busy;

         sel.uart_rx   : begin
                         bus.rdat[31]   = csr.uart_rx.valid;
                         bus.rdat[30]   = csr.uart_rx.oflow;
                         bus.rdat[7:0]  = csr.uart_rx.data;
                         end

        //___ADC1
         sel.adc1_tx   : bus.rdat[31]   = csr.adc1_tx_busy ;
         sel.adc1_rx   : bus.rdat[16:0] = csr.adc1_rx.sample_cnt;

        //___ADC2
         sel.adc2_tx   : bus.rdat[31]   = csr.adc2_tx_busy ;
         sel.adc2_rx   : bus.rdat[16:0] = csr.adc2_rx.sample_cnt;

        //___GPI
         sel.gpi       : bus.rdat[0]    = csr.gpi.key_on;

        //___DAC1/2
         sel.dac1      : bus.rdat[31]   = csr.dac1_busy;
         sel.dac2      : bus.rdat[31]   = csr.dac2_busy;

         default: begin end
      endcase // unique case (HI)
   end: rd_mux


//-----------------------------------------
// Handshake
//-----------------------------------------
// all transactions are completed in one cycle
  assign bus.rdy = HI;


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

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/1/2  JI: initial creation
 2024/3/1  JI: added ADC1/2_RX, GPO and GPI registers
 2024/3/28 JI: added DAC1/2
 2024/4/88 JI: adapted for ADC DMA scheme
*/
