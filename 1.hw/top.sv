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
//   WireGuard FPGA top-level module
//==========================================================================

module top (
   input        clk_p,        //board clock positive
   input        clk_n,        //board clock negative
   input        rst_n,        //reset, low active

// Ethernet 1
   output       e1_reset,     //phy reset
   output       e1_mdc,       //phy emdio clock
   inout        e1_mdio,      //phy emdio data
   input        e1_rxc,       //125Mhz ethernet gmii rx clock
   input        e1_rxdv,      //GMII recieving data valid
   input        e1_rxer,      //GMII recieving data error
   input  [7:0] e1_rxd,       //GMII recieving data
   input        e1_txc,       //25Mhz ethernet mii tx clock
   output       e1_gtxc,      //125Mhz ethernet gmii tx clock
   output       e1_txen,      //GMII sending data valid
   output       e1_txer,      //GMII sending data error
   output [7:0] e1_txd,       //GMII sending data

// Ethernet 2
   output       e2_reset,     //phy reset
   output       e2_mdc,       //phy emdio clock
   inout        e2_mdio,      //phy emdio data
   input        e2_rxc,       //125Mhz ethernet gmii rx clock
   input        e2_rxdv,      //GMII recieving data valid
   input        e2_rxer,      //GMII recieving data error
   input  [7:0] e2_rxd,       //GMII recieving data
   input        e2_txc,       //25Mhz ethernet mii tx clock
   output       e2_gtxc,      //125Mhz ethernet gmii tx clock
   output       e2_txen,      //GMII sending data valid
   output       e2_txer,      //GMII sending data error
   output [7:0] e2_txd,       //GMII sending data

// Ethernet 3
   output       e3_reset,     //phy reset
   output       e3_mdc,       //phy emdio clock
   inout        e3_mdio,      //phy emdio data
   input        e3_rxc,       //125Mhz ethernet gmii rx clock
   input        e3_rxdv,      //GMII recieving data valid
   input        e3_rxer,      //GMII recieving data error
   input  [7:0] e3_rxd,       //GMII recieving data
   input        e3_txc,       //25Mhz ethernet mii tx clock
   output       e3_gtxc,      //125Mhz ethernet gmii tx clock
   output       e3_txen,      //GMII sending data valid
   output       e3_txer,      //GMII sending data error
   output [7:0] e3_txd,       //GMII sending data

// Ethernet 4
   output       e4_reset,     //phy reset
   output       e4_mdc,       //phy emdio clock
   inout        e4_mdio,      //phy emdio data
   input        e4_rxc,       //125Mhz ethernet gmii rx clock
   input        e4_rxdv,      //GMII recieving data valid
   input        e4_rxer,      //GMII recieving data error
   input  [7:0] e4_rxd,       //GMII recieving data
   input        e4_txc,       //25Mhz ethernet mii tx clock
   output       e4_gtxc,      //125Mhz ethernet gmii tx clock
   output       e4_txen,      //GMII sending data valid
   output       e4_txer,      //GMII sending data error
   output [7:0] e4_txd,       //GMII sending data

// UART
   input        uart_rx,
   output       uart_tx,

// Keys
   input [1:0]  key_in,

// LEDs
   output [1:0] led
);
   import csr_pkg::*;
   import soc_pkg::*;

//==========================================================================
// Clock and reset generation
//==========================================================================
   logic               sys_clk;
   logic               sys_rst;
   logic               sys_rst_n;
   logic               eth_gtx_clk;
   logic               eth_gtx_rst;

   clk_rst_gen u_clk_rst_gen (
      .clk_p           (clk_p),
      .clk_n           (clk_n),
      .rst_n           (rst_n),
      .sys_clk         (sys_clk),
      .sys_rst         (sys_rst),
      .sys_rst_n       (sys_rst_n),
      .eth_gtx_clk     (eth_gtx_clk),
      .eth_gtx_rst     (eth_gtx_rst)
   );

//==========================================================================
// CPU<->DPE<->Ethernet Interconnect
//==========================================================================
   dpe_if              from_cpu      (.clk(sys_clk), .rst(sys_rst));
   dpe_if              from_eth_1    (.clk(sys_clk), .rst(sys_rst));
   dpe_if              from_eth_2    (.clk(sys_clk), .rst(sys_rst));
   dpe_if              from_eth_3    (.clk(sys_clk), .rst(sys_rst));
   dpe_if              from_eth_4    (.clk(sys_clk), .rst(sys_rst));
   dpe_if              to_cpu        (.clk(sys_clk), .rst(sys_rst));
   dpe_if              to_eth_1      (.clk(sys_clk), .rst(sys_rst));
   dpe_if              to_eth_2      (.clk(sys_clk), .rst(sys_rst));
   dpe_if              to_eth_3      (.clk(sys_clk), .rst(sys_rst));
   dpe_if              to_eth_4      (.clk(sys_clk), .rst(sys_rst));
   csr_pkg::csr__in_t  to_csr;
   csr_pkg::csr__out_t from_csr;

//=================================
// CPU Subsystem
//=================================
   localparam          NUM_WORDS_IMEM = 8192; //=> 32kB InstructionRAM
   localparam          NUM_WORDS_DMEM = 8192; //=> 32kB DataRAM

   soc_if              bus_cpu       (.arst_n(sys_rst_n), .clk(sys_clk));
   soc_if              bus_uart      (.arst_n(sys_rst_n), .clk(sys_clk));
   soc_if              bus_dmem      (.arst_n(sys_rst_n), .clk(sys_clk));
   soc_if              bus_csr       (.arst_n(sys_rst_n), .clk(sys_clk));

   logic               imem_cpu_rstn;
   logic               imem_we;
   logic [31:2]        imem_waddr;
   logic [31:0]        imem_wdat;

//---------------------------------
   soc_cpu #(
      .ADDR_RESET      (32'h 0000_0000),
      .NUM_WORDS_IMEM  (NUM_WORDS_IMEM)
   ) u_cpu (
      .bus             (bus_cpu),       //MST

      .imem_cpu_rstn   (imem_cpu_rstn), //-\ access point
      .imem_we         (imem_we),       //-| for
      .imem_waddr      (imem_waddr),    // | reloading CPU
      .imem_wdat       (imem_wdat)      //-/ program memory
   );

//---------------------------------
   soc_fabric u_fabric (
      .cpu             (bus_cpu),       //SLV
      .uart            (bus_uart),      //SLV

      .dmem            (bus_dmem),      //MST
      .csr             (bus_csr)        //MST
   );

//---------------------------------
   soc_ram #(
      .NUM_WORDS       (NUM_WORDS_DMEM)
   ) u_dmem (
      .bus             (bus_dmem)       //SLV
   );

//---------------------------------
   soc_csr u_soc_csr (
      .bus             (bus_csr),       //SLV
      .hwif_in         (to_csr),        //i
      .hwif_out        (from_csr)       //o
   );

//---------------------------------
   uart u_uart (
      .arst_n          (sys_rst_n),     //i
      .clk             (sys_clk),       //i

      .uart_rx         (uart_rx),   //i
      .uart_tx         (uart_tx),       //o

      .from_csr        (from_csr),      //i
      .to_csr          (to_csr),        //o

      .imem_cpu_rstn   (imem_cpu_rstn), //o
      .imem_we         (imem_we),       //o
      .imem_waddr      (imem_waddr),    //o[31:2]
      .imem_wdat       (imem_wdat),     //o[31:0]
      
      .bus             (bus_uart)       //MST
   );

//---------------------------------
   cpu_fifo u_cpu_fifo (
      .from_csr        (from_csr),      //i
      .to_csr          (to_csr),        //o
      .to_cpu          (to_cpu),        //SLV
      .from_cpu        (from_cpu)       //MST
   );

//==========================================================================
// GPIO
//==========================================================================
   assign led[1] = ~from_csr.gpio.led2.value;
   assign led[0] = ~from_csr.gpio.led1.value;
   assign to_csr.gpio.key2.next = ~key_in[1];  //TODO: Add debounce
   assign to_csr.gpio.key1.next = ~key_in[0];  //TODO: Add debounce

//==========================================================================
// DPE
//==========================================================================
   dpe u_dpe (
      .from_csr        (from_csr),      //i
      .to_csr          (to_csr),        //o
      .from_cpu        (from_cpu),      //SLV
      .from_eth_1      (from_eth_1),    //SLV
      .from_eth_2      (from_eth_2),    //SLV
      .from_eth_3      (from_eth_3),    //SLV
      .from_eth_4      (from_eth_4),    //SLV
      .to_cpu          (to_cpu),        //MST
      .to_eth_1        (to_eth_1),      //MST
      .to_eth_2        (to_eth_2),      //MST
      .to_eth_3        (to_eth_3),      //MST
      .to_eth_4        (to_eth_4)       //MST
   );

//==========================================================================
// Ethernet subsystems
//==========================================================================
   ethernet_mac u_eth_1 (
      .gtx_clk         (eth_gtx_clk),
      .gtx_rst         (eth_gtx_rst),
      .gmii_rx_clk     (e1_rxc),
      .gmii_rxd        (e1_rxd),
      .gmii_rx_dv      (e1_rxdv),
      .gmii_rx_er      (e1_rxer),
      .mii_tx_clk      (e1_txc),
      .gmii_tx_clk     (e1_gtxc),
      .gmii_txd        (e1_txd),
      .gmii_tx_en      (e1_txen),
      .gmii_tx_er      (e1_txer),
      .speed           (to_csr.ethernet[0].status.speed.next),
      .rx_fifo         (from_eth_1),
      .tx_fifo         (to_eth_1)
   );

//--------------------------------------------------------------------------
   ethernet_mac u_eth_2 (
      .gtx_clk         (eth_gtx_clk),
      .gtx_rst         (eth_gtx_rst),
      .gmii_rx_clk     (e2_rxc),
      .gmii_rxd        (e2_rxd),
      .gmii_rx_dv      (e2_rxdv),
      .gmii_rx_er      (e2_rxer),
      .mii_tx_clk      (e2_txc),
      .gmii_tx_clk     (e2_gtxc),
      .gmii_txd        (e2_txd),
      .gmii_tx_en      (e2_txen),
      .gmii_tx_er      (e2_txer),
      .speed           (to_csr.ethernet[1].status.speed.next),
      .rx_fifo         (from_eth_2),
      .tx_fifo         (to_eth_2)
   );

//--------------------------------------------------------------------------
   ethernet_mac u_eth_3 (
      .gtx_clk         (eth_gtx_clk),
      .gtx_rst         (eth_gtx_rst),
      .gmii_rx_clk     (e3_rxc),
      .gmii_rxd        (e3_rxd),
      .gmii_rx_dv      (e3_rxdv),
      .gmii_rx_er      (e3_rxer),
      .mii_tx_clk      (e3_txc),
      .gmii_tx_clk     (e3_gtxc),
      .gmii_txd        (e3_txd),
      .gmii_tx_en      (e3_txen),
      .gmii_tx_er      (e3_txer),
      .speed           (to_csr.ethernet[2].status.speed.next),
      .rx_fifo         (from_eth_3),
      .tx_fifo         (to_eth_3)
   );

//--------------------------------------------------------------------------
   ethernet_mac u_eth_4 (
      .gtx_clk         (eth_gtx_clk),
      .gtx_rst         (eth_gtx_rst),
      .gmii_rx_clk     (e4_rxc),
      .gmii_rxd        (e4_rxd),
      .gmii_rx_dv      (e4_rxdv),
      .gmii_rx_er      (e4_rxer),
      .mii_tx_clk      (e4_txc),
      .gmii_tx_clk     (e4_gtxc),
      .gmii_txd        (e4_txd),
      .gmii_tx_en      (e4_txen),
      .gmii_tx_er      (e4_txer),
      .speed           (to_csr.ethernet[3].status.speed.next),
      .rx_fifo         (from_eth_4),
      .tx_fifo         (to_eth_4)
   );

//--------------------------------------------------------------------------
   ethernet_phy u_phy (
      .e1_reset        (e1_reset),
      .e1_mdc          (e1_mdc),
      .e1_mdio         (e1_mdio),
      .e2_reset        (e2_reset),
      .e2_mdc          (e2_mdc),
      .e2_mdio         (e2_mdio),
      .e3_reset        (e3_reset),
      .e3_mdc          (e3_mdc),
      .e3_mdio         (e3_mdio),
      .e4_reset        (e4_reset),
      .e4_mdc          (e4_mdc),
      .e4_mdio         (e4_mdio)
   );
endmodule
