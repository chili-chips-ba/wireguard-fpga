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
   parameter int RUN_SIM_US     = 10,
   parameter int ETH_START_NODE = 1,
   parameter int MDIO_BUFF_ADDR = 32'h50000000
)();
   glbl glbl();

   //localparam DLY_PCB_PAD_PS    = 1_000;
   localparam NUM_ETH_PORTS     = 4;

//--------------------------------------------------------------
// Generate clocks and run sim for the specified amount of time
   localparam  HALF_CLK_P_PERIOD_PS      =   2_500; // 200MHz
   localparam  HALF_GMII_PERIOD_PS       =   4_000; // 125MHz
   localparam  HALF_PERIOD_ETH_TX_PS     =  20_000; // 25 MHz
   localparam  HALF_PERIOD_OTHER_BFMS_PS =   6_250; // 80 MHz

   localparam  RST_CYLES      = 10;
   localparam  GMII_RST_CYLES = 10;

   logic       clk_p, clk_n;
   logic       rst_n;
   logic       gmiiclk, gmiiclkx2;
   logic       gmiiarst_n;
   logic       eth_txc;
   logic       clk_80;
   logic [2:1] key;

   initial begin
      clk_p      = 1'b0;
      clk_n      = 1'b0;
      rst_n      = 1'b0;
      gmiiclk    = 1'b0;
      gmiiclkx2  = 1'b0;
      gmiiarst_n = 1'b0;
      eth_txc    = 1'b0;
      clk_80     = 1'b0;
      key        = 2'b0;

      fork
         begin : board_rst_n
            #(HALF_CLK_P_PERIOD_PS*RST_CYLES * 1ps)
               rst_n = 1'b1;
         end

         forever begin: clk_p_gen
            #(HALF_CLK_P_PERIOD_PS * 1ps)
               clk_p  = ~clk_p;
         end

         forever begin: gmii_clock_gen
            #(HALF_GMII_PERIOD_PS * 1ps)
               gmiiclk = ~gmiiclk;
         end

         forever begin: gmii_clockx2_gen
            #(HALF_GMII_PERIOD_PS/2 * 1ps)
               gmiiclkx2 = ~gmiiclkx2;
         end

         forever begin: eth_txc_gen
            #(HALF_PERIOD_ETH_TX_PS * 1ps)
               eth_txc = ~eth_txc;
         end

         forever begin: clk_80_gen
            #(HALF_PERIOD_OTHER_BFMS_PS * 1ps)
               clk_80 = ~clk_80;
         end

         begin : gmii_arst_n
            #(HALF_GMII_PERIOD_PS*2*GMII_RST_CYLES * 1ps)
               gmiiarst_n = 1'b1;
         end

         begin: run_sim
            #(RUN_SIM_US * 1us);
               $finish(2);
         end
      join
   end

   assign clk_n = ~clk_p;

//--------------------------------------------------------------

   logic e1_rxc, e2_rxc, e3_rxc, e4_rxc;
   logic e1_txc, e2_txc, e3_txc, e4_txc;

   assign e1_rxc = gmiiclk;
   assign e2_rxc = gmiiclk;
   assign e3_rxc = gmiiclk;
   assign e4_rxc = gmiiclk;

   assign e1_txc = eth_txc;
   assign e2_txc = eth_txc;
   assign e3_txc = eth_txc;
   assign e4_txc = eth_txc;

//--------------------------------------------------------------

   logic e1_rxdv, e1_rxer;
   logic [7:0] e1_rxd;
   logic e1_reset, e1_mdc;
   wire  e1_mdio;
   logic e1_gtxc, e1_txen, e1_txer;
   logic [7:0] e1_txd;

   logic e2_rxdv, e2_rxer;
   logic [7:0] e2_rxd;
   logic e2_reset, e2_mdc;
   wire  e2_mdio;
   logic e2_gtxc, e2_txen, e2_txer;
   logic [7:0] e2_txd;

   logic e3_rxdv, e3_rxer;
   logic [7:0] e3_rxd;
   logic e3_reset, e3_mdc;
   wire  e3_mdio;
   logic e3_gtxc, e3_txen, e3_txer;
   logic [7:0] e3_txd;

   logic e4_rxdv, e4_rxer;
   logic [7:0] e4_rxd;
   logic e4_reset, e4_mdc;
   wire  e4_mdio;
   logic e4_gtxc, e4_txen, e4_txer;
   logic [7:0] e4_txd;

   assign e1_rxdv = 1'b0;
   assign e1_rxer = 1'b0;
   assign e1_rxd  = 8'd0;

   assign e2_rxdv = 1'b0;
   assign e2_rxer = 1'b0;
   assign e2_rxd  = 8'd0;

   assign e3_rxdv = 1'b0;
   assign e3_rxer = 1'b0;
   assign e3_rxd  = 8'd0;

   assign e4_rxdv = 1'b0;
   assign e4_rxer = 1'b0;
   assign e4_rxd  = 8'd0;

//--------------------------------------------------------------

   logic        uart_rx, uart_tx;
// verilator lint_off UNUSEDSIGNAL
   logic [3:2]  led_n;
// verilator lint_off UNUSEDSIGNAL

   top dut (
      .clk_p   (clk_p),
      .clk_n   (clk_n),
      .rst_n   (rst_n),

      // Ethernet 1
      .e1_reset(e1_reset),
      .e1_mdc  (e1_mdc),
      .e1_mdio (e1_mdio),
      .e1_rxc  (e1_rxc),
      .e1_rxdv (e1_rxdv),
      .e1_rxer (e1_rxer),
      .e1_rxd  (e1_rxd),
      .e1_txc  (e1_txc),
      .e1_gtxc (e1_gtxc),
      .e1_txen (e1_txen),
      .e1_txer (e1_txer),
      .e1_txd  (e1_txd),

      // Ethernet 2
      .e2_reset(e2_reset),
      .e2_mdc  (e2_mdc),
      .e2_mdio (e2_mdio),
      .e2_rxc  (e2_rxc),
      .e2_rxdv (e2_rxdv),
      .e2_rxer (e2_rxer),
      .e2_rxd  (e2_rxd),
      .e2_txc  (e2_txc),
      .e2_gtxc (e2_gtxc),
      .e2_txen (e2_txen),
      .e2_txer (e2_txer),
      .e2_txd  (e2_txd),

      // Ethernet 3
      .e3_reset(e3_reset),
      .e3_mdc  (e3_mdc),
      .e3_mdio (e3_mdio),
      .e3_rxc  (e3_rxc),
      .e3_rxdv (e3_rxdv),
      .e3_rxer (e3_rxer),
      .e3_rxd  (e3_rxd),
      .e3_txc  (e3_txc),
      .e3_gtxc (e3_gtxc),
      .e3_txen (e3_txen),
      .e3_txer (e3_txer),
      .e3_txd  (e3_txd),

      // Ethernet 4
      .e4_reset(e4_reset),
      .e4_mdc  (e4_mdc),
      .e4_mdio (e4_mdio),
      .e4_rxc  (e4_rxc),
      .e4_rxdv (e4_rxdv),
      .e4_rxer (e4_rxer),
      .e4_rxd  (e4_rxd),
      .e4_txc  (e4_txc),
      .e4_gtxc (e4_gtxc),
      .e4_txen (e4_txen),
      .e4_txer (e4_txer),
      .e4_txd  (e4_txd),

      // UART
      .uart_rx (uart_rx),
      .uart_tx (uart_tx),

      // Keys
      .key_in  (key),

      // LEDs
      .led     (led)
   );

//--------------------------------------------------------------
// Ethernet UDP/IPv4 BFM
//--------------------------------------------------------------

gmii_if                                   gmii [NUM_ETH_PORTS] (gmiiclk, gmiiarst_n) ;
wire    [NUM_ETH_PORTS-1:0]               mdio;
wire    [NUM_ETH_PORTS-1:0]               mdio_en;
wire    [NUM_ETH_PORTS-1:0]               mdio_out;


// Pullup on MDIO lines
assign (pull1, pull0) mdio = {NUM_ETH_PORTS{1'b1}};

genvar PORT;
generate
  for (PORT = 0; PORT < NUM_ETH_PORTS; PORT++)
  begin
`ifdef VERILATOR
    assign mdio[PORT]      =  mdio_en[PORT] ? mdio_out[PORT] : 1'bz;
`endif

    // Tie off GMII inputs
    assign gmii[PORT].txen = 1'b0;
    assign gmii[PORT].txer = 1'b0;
    assign gmii[PORT].txd  = '0;
  end
endgenerate

// verilator lint_off PINCONNECTEMPTY
 bfm_ethernet
   #(.START_NODE                          (ETH_START_NODE),
     .NUM_PORTS                           (NUM_ETH_PORTS),
     .MDIO_BUFF_ADDR                      (MDIO_BUFF_ADDR)
   ) bfm_udp
   (
     .clk                                 (gmiiclk),
     .clkx2                               (gmiiclkx2),
     .arst_n                              (gmiiarst_n),

     // GMII interface
     .gmii                                (gmii),

     // MDIO interface
     .mdioclk                             (mdioclk),
     .mdio                                (mdio),

`ifdef VERILATOR
     .mdio_en                             (mdio_en),
     .mdio_out                            (mdio_out),
`endif

     // Simulation halt request
     .halt_req                            ()
   );
// verilator lint_on PINCONNECTEMPTY

//--------------------------------------------------------------
// model of external UART
//--------------------------------------------------------------
   bfm_uart bfm_uart (
      .uart_rx  (uart_tx), //i
      .uart_tx  (uart_rx)  //o
   );

//--------------------------------------------------------------
// Error monitor
//--------------------------------------------------------------
/*    always @(dut.csr.misc.error) begin: error_mon
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
*/

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
 2024/10/31 SS: Made compatible with current dut ports and commented out
                non-compiling test components
*/
