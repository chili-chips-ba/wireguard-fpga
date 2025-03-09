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
//   Top-Level Module
//==========================================================================

module top #(
   // target ("SIM", "GENERIC", "XILINX")
   parameter TARGET = "XILINX"
) (
   input        clk_p,        //board clock positive
   input        clk_n,        //board clock negative 
   input        rst_n,        //reset ,low active
   output [1:0] led,          //display network rate status
   
// Ethernet 1
   output       e1_reset,     //phy reset
   output       e1_mdc,       //phy emdio clock
   inout        e1_mdio,      //phy emdio data
   input	       e1_rxc,       //125Mhz ethernet gmii rx clock
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
   input	       e2_rxc,       //125Mhz ethernet gmii rx clock
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
   input	       e3_rxc,       //125Mhz ethernet gmii rx clock
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
   input	       e4_rxc,       //125Mhz ethernet gmii rx clock
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
   input [1:0]  key_in
);
   import csr_pkg::*;
   
//==========================================================================
// Clock and reset generation
//==========================================================================
   logic [1:0]  led_int;
   logic        sys_clk;
   logic        sys_rst;
   logic        eth_gtx_clk;
   logic        eth_gtx_rst;
    
   fpga_plls fpga_plls_inst (
      .clk_p(clk_p),
      .clk_n(clk_n),
      .rst_n(rst_n),
      .sys_clk(sys_clk),
      .sys_rst(sys_rst),
      .eth_gtx_clk(eth_gtx_clk),
      .eth_gtx_rst(eth_gtx_rst)
   );
 
//==========================================================================
// Interconnect
//==========================================================================
   dpe_if from_cpu   (.clk(sys_clk), .rst(sys_rst));
   dpe_if from_eth_1 (.clk(sys_clk), .rst(sys_rst));
   dpe_if from_eth_2 (.clk(sys_clk), .rst(sys_rst));
   dpe_if from_eth_3 (.clk(sys_clk), .rst(sys_rst));
   dpe_if from_eth_4 (.clk(sys_clk), .rst(sys_rst));
   dpe_if to_cpu     (.clk(sys_clk), .rst(sys_rst));
   dpe_if to_eth_1   (.clk(sys_clk), .rst(sys_rst));
   dpe_if to_eth_2   (.clk(sys_clk), .rst(sys_rst));
   dpe_if to_eth_3   (.clk(sys_clk), .rst(sys_rst));
   dpe_if to_eth_4   (.clk(sys_clk), .rst(sys_rst));
   csr_pkg::csr__in_t  to_csr;
   csr_pkg::csr__out_t from_csr;

//==========================================================================
// CSR
//==========================================================================
   csr csr_inst (
      .clk(sys_clk),
      .rst(sys_rst),

      .s_cpuif_req(0),
      .s_cpuif_req_is_wr(0),
      .s_cpuif_addr('0),
      .s_cpuif_wr_data('0),
      .s_cpuif_wr_biten('0),
      .s_cpuif_req_stall_wr(),
      .s_cpuif_req_stall_rd(),
      .s_cpuif_rd_ack(),
      .s_cpuif_rd_err(),
      .s_cpuif_rd_data(),
      .s_cpuif_wr_ack(),
      .s_cpuif_wr_err(),

      .hwif_in(to_csr),
      .hwif_out(from_csr)
    );
   
//==========================================================================
// CPU FIFOs
//==========================================================================
   cpu_fifo cpu_fifo_inst (
      .to_cpu(to_cpu),
      .from_cpu(from_cpu),
      .from_csr(from_csr),
      .to_csr(to_csr)
   );

//==========================================================================
// DPE
//==========================================================================  
   dpe dpe_inst (
      .pause(0),
      .is_idle(),
      .from_cpu(from_cpu),
      .from_eth_1(from_eth_1),
      .from_eth_2(from_eth_2),
      .from_eth_3(from_eth_3),
      .from_eth_4(from_eth_4),
      .to_cpu(to_cpu),
      .to_eth_1(to_eth_1),
      .to_eth_2(to_eth_2),
      .to_eth_3(to_eth_3),
      .to_eth_4(to_eth_4)
   );

//==========================================================================
// ILA
//==========================================================================
   ila_0 ila_0_inst (
      .clk(sys_clk),
      .probe0(from_eth_1.tdata),
      .probe1(from_eth_1.tkeep),
      .probe2(from_eth_1.tvalid),
      .probe3(from_eth_1.tready),
      .probe4(from_eth_1.tlast),
      .probe5('0),
      .probe6(to_eth_1.tdata),
      .probe7(to_eth_1.tkeep),
      .probe8(to_eth_1.tvalid),
      .probe9(to_eth_1.tready),
      .probe10(to_eth_1.tlast),
      .probe11('0)
   );

//==========================================================================
// Ethernet subsystems
//==========================================================================
   ethernet_mac #(
      .TARGET(TARGET)
   ) eth_1 (
      .gtx_clk(eth_gtx_clk),
      .gtx_rst(eth_gtx_rst),
      .gmii_rx_clk(e1_rxc),
      .gmii_rxd(e1_rxd),
      .gmii_rx_dv(e1_rxdv),
      .gmii_rx_er(e1_rxer),
      .mii_tx_clk(e1_txc), 
      .gmii_tx_clk(e1_gtxc),
      .gmii_txd(e1_txd),
      .gmii_tx_en(e1_txen),
      .gmii_tx_er(e1_txer),
      .speed(led_int),
      .rx_fifo(from_eth_1),
      .tx_fifo(to_eth_1)
   );
    
   assign led = ~led_int;
    
//--------------------------------------------------------------------------
   ethernet_mac #(
      .TARGET(TARGET)
   ) eth_2 (
      .gtx_clk(eth_gtx_clk),
      .gtx_rst(eth_gtx_rst),
      .gmii_rx_clk(e2_rxc),
      .gmii_rxd(e2_rxd),
      .gmii_rx_dv(e2_rxdv),
      .gmii_rx_er(e2_rxer),
      .mii_tx_clk(e2_txc), 
      .gmii_tx_clk(e2_gtxc),
      .gmii_txd(e2_txd),
      .gmii_tx_en(e2_txen),
      .gmii_tx_er(e2_txer),
      .speed(),
      .rx_fifo(from_eth_2),
      .tx_fifo(to_eth_2)
   );
    
//--------------------------------------------------------------------------    
   ethernet_mac #(
      .TARGET(TARGET)
   ) eth_3 (
      .gtx_clk(eth_gtx_clk),
      .gtx_rst(eth_gtx_rst),
      .gmii_rx_clk(e3_rxc),
      .gmii_rxd(e3_rxd),
      .gmii_rx_dv(e3_rxdv),
      .gmii_rx_er(e3_rxer),
      .mii_tx_clk(e3_txc), 
      .gmii_tx_clk(e3_gtxc),
      .gmii_txd(e3_txd),
      .gmii_tx_en(e3_txen),
      .gmii_tx_er(e3_txer),
      .speed(),
      .rx_fifo(from_eth_3),
      .tx_fifo(to_eth_3)
   );
    
//--------------------------------------------------------------------------
   ethernet_mac #(
      .TARGET(TARGET)
   ) eth_4 (
      .gtx_clk(eth_gtx_clk),
      .gtx_rst(eth_gtx_rst),
      .gmii_rx_clk(e4_rxc),
      .gmii_rxd(e4_rxd),
      .gmii_rx_dv(e4_rxdv),
      .gmii_rx_er(e4_rxer),
      .mii_tx_clk(e4_txc), 
      .gmii_tx_clk(e4_gtxc),
      .gmii_txd(e4_txd),
      .gmii_tx_en(e4_txen),
      .gmii_tx_er(e4_txer),
      .speed(),
      .rx_fifo(from_eth_4),
      .tx_fifo(to_eth_4)
   );
 
 //--------------------------------------------------------------------------
   ethernet_phy phy (
      .e1_reset(e1_reset),
      .e1_mdc(e1_mdc),
      .e1_mdio(e1_mdio),
      .e2_reset(e2_reset),
      .e2_mdc(e2_mdc),
      .e2_mdio(e2_mdio),
      .e3_reset(e3_reset),
      .e3_mdc(e3_mdc),
      .e3_mdio(e3_mdio),
      .e4_reset(e4_reset),
      .e4_mdc(e4_mdc),
      .e4_mdio(e4_mdio)
   );
endmodule