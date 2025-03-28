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
//   SOC top-level design.
//
//   Standardized template, then customized to each particular SOC design.
//   We hereby instantiate all Master(s) and Slave(s), and connect to form
//   the complete System On Chip.
//
//   Customized for Sipeed TangNano20K board
//==========================================================================

module top
   import soc_pkg::*;
(

//___Common infrastructure
   input  logic        clk_27,    // 27MHz clock oscillator on TangNano20K
   input  logic [2:0]  clk_fpll,  // clock from onboard FractionalPLL (MS5351)
   input  logic [2:1]  key,       // active-HI, S1:UserFunction S2:Reset
   output logic [3:2]  led_n,     // active-LO onboard LEDs

   input  logic        uart_rx,   // -\ UART towards BL616
   output logic        uart_tx    // -/

 //input  logic        ser422_rx, //-\ UART towards RS422
 //output logic        ser422_tx, //-/
);

//=================================
// Clock and reset generation
//=================================
   logic       clk_54;
   logic       srst54_n;

   logic       strobe_27;
   logic       tick_1us;
   logic       tick_cca15us;
   logic       key1_clean;

   clk_rst_gen u_clk_rst (
      .clk_27    (clk_27),       //i
      .clk_fpll  (clk_fpll),     //i
      .force_rst (key[2]),       //i

      .clk_54    (clk_54),       //o
      .srst54_n  (srst54_n),     //o

      .strobe_27 (strobe_27),    //o
      .tick_1us  (tick_1us)      //o
   );

   debounce #(.ACTIVE(1'b1)) u_debounce (
      .arst_n    (srst54_n),     //i
      .clk       (clk_54),       //i
      .tick_15us (tick_cca15us), //i
      .inp       (key[1]),       //i
      .out       (key1_clean)    //o
   );

//=================================
// CPU Subsystem
//=================================
   localparam NUM_WORDS_IMEM = 8192; //=> 32kB InstructionRAM
   localparam NUM_WORDS_DMEM = 8192; //=> 32kB DataRAM

   soc_if bus_cpu   (.arst_n(srst54_n), .clk(clk_54));
   soc_if bus_adc   (.arst_n(srst54_n), .clk(clk_54));
   soc_if bus_dmem  (.arst_n(srst54_n), .clk(clk_54));
   soc_if bus_csr   (.arst_n(srst54_n), .clk(clk_54));
   soc_if bus_sdram (.arst_n(srst54_n), .clk(clk_54));

   csr_if csr ();

   logic        imem_we;
   logic [31:2] imem_waddr;
   logic [31:0] imem_wdat;

//---------------------------------
   soc_cpu #(
     .ADDR_RESET     (32'h 0000_0000),
     .NUM_WORDS_IMEM (NUM_WORDS_IMEM)
   )
   u_cpu (
     .bus        (bus_cpu),    //MST

     .imem_we    (imem_we),    //-\ access point for
     .imem_waddr (imem_waddr), // | reloading CPU
     .imem_wdat  (imem_wdat)   //-/ program memory
   );

//---------------------------------
  soc_fabric u_fabric (
     .cpu   (bus_cpu),  //SLV
     .adc   (bus_adc),  //SLV

     .dmem  (bus_dmem), //MST
     .csr   (bus_csr),  //MST
     .sdram (bus_sdram) //MST
  );

//---------------------------------
  soc_ram #(.NUM_WORDS(NUM_WORDS_DMEM)) u_dmem (
     .bus (bus_dmem) //SLV
  );

//---------------------------------
  soc_csr u_csr (
     .bus (bus_csr), //SLV
     .csr (csr)      //MST
  );

//---------------------------------
  uart u_uart (
    .arst_n     (srst54_n),   //i
    .clk        (clk_54),     //i
    .tick_1us   (tick_1us),   //i

    .uart_rx    (uart_rx),    //i
    .uart_tx    (uart_tx),    //o

    .csr        (csr),        //SLV_UART

   // IMEM Write port, for live updates of CPU program
    .imem_we    (imem_we),    //o
    .imem_waddr (imem_waddr), //o[31:2]
    .imem_wdat  (imem_wdat)   //o[31:0]
  );

//=================================
// Misc
//=================================
   assign led_n[3:2]     = csr.gpo.led_off;
   assign csr.gpi.key_on = key1_clean;

endmodule: top

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/7/14 JI: ported and stripped-down from eduSOC
*/
