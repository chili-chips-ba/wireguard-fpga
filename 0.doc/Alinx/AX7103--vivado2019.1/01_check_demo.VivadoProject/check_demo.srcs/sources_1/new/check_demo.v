`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/30 18:05:09
// Design Name: 
// Module Name: check_demo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module check_demo(


input            sys_clk_p,   //system clock positive
input            sys_clk_n,   //system clock negative 

input            key0,         //user key on board
output           sd_ncs,      //chip select
output           sd_dclk,     //sd card clock
output           sd_mosi,     //sd card CMD
input            sd_miso,     //sd card  data

inout [31:0]                       ddr3_dq,                     //ddr3 data
inout [3:0]                        ddr3_dqs_n,                  //ddr3 dqs negative
inout [3:0]                        ddr3_dqs_p,                  //ddr3 dqs positive
// Outputs
output [14:0]                     ddr3_addr,                    //ddr3 address
output [2:0]                      ddr3_ba,                      //ddr3 bank
output                            ddr3_ras_n,                   //ddr3 ras_n
output                            ddr3_cas_n,                   //ddr3 cas_n
output                            ddr3_we_n,                    //ddr3 write enable 
output                            ddr3_reset_n,                 //ddr3 reset,
output [0:0]                      ddr3_ck_p,                    //ddr3 clock negative
output [0:0]                      ddr3_ck_n,                    //ddr3 clock positive
output [0:0]                      ddr3_cke,                     //ddr3_cke,
output [0:0]                      ddr3_cs_n,                    //ddr3 chip select,
output [3:0]                      ddr3_dm,                      //ddr3_dm
output [0:0]                      ddr3_odt ,                    //ddr3_odt


output                          led_eth,
output                          e1_reset,                         //phy reset
output                          e1_mdc,                           //phy emdio clock
inout                           e1_mdio,                          //phy emdio data
output[3:0]                     rgmii1_txd,                       //phy data send
output                          rgmii1_txctl,                     //phy data send control
output                          rgmii1_txc,                       //Clock for sending data
input[3:0]                      rgmii1_rxd,                       //recieve data
input                           rgmii1_rxctl,                     //Control signal for receiving data
input                           rgmii1_rxc,                        //Clock for recieving data	
output                          e2_reset,                         //phy reset
output                          e2_mdc,                           //phy emdio clock
inout                           e2_mdio,                          //phy emdio data
output[3:0]                     rgmii2_txd,                       //phy data send
output                          rgmii2_txctl,                     //phy data send control
output                          rgmii2_txc,                       //Clock for sending data
input[3:0]                      rgmii2_rxd,                       //recieve data
input                           rgmii2_rxctl,                     //Control signal for receiving data
input                           rgmii2_rxc ,                        //Clock for recieving data	

output                      hdmi_in_nreset,     //9011/9013 reset
input                       vin_clk,            //clock for 9111/9013
input                       vin_hs,             //horizontal synchronization for 9011/9013
input                       vin_vs,             //vertical synchronization for 9011/9013
input                       vin_de,             //data valid for 9011/9013
input[23:0]                 vin_data,           //data for 9011/9013   
inout                       hdmi_scl,           //HDMI I2C clock
inout                       hdmi_sda,           //HDMI I2C data
output                      hdmi_nreset,        //9134 reset
output                      vout_hs,            //horizontal synchronization for 9134
output                      vout_vs,            //vertical synchronization for 9134
output                      vout_de,            //data valid for 9134
output                      vout_clk,           //clock for 9134
output[23:0]                vout_data,           //data for 9134

input                           uart_rx,           //fpga receive data
output                          uart_tx,            //fpga send data

input                  key_led,             //input two key signal,when the keydown,the value is 0
output[2:0]            led_key                 //LED display ,when the siganl high,LED lighten

       
);

wire sys_clk;
wire clk_50Mhz;
wire locked;

   IBUFDS #(
      .DIFF_TERM("FALSE"),       // Differential Termination
      .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
   ) IBUFDS_inst (
      .O(sys_clk),  // Buffer output
      .I(sys_clk_p),  // Diff_p buffer input (connect directly to top-level port)
      .IB(sys_clk_n) // Diff_n buffer input (connect directly to top-level port)
   );

sd_card_test  u0
(
.            sys_clk(sys_clk),   //system clock positive
.            clk_50Mhz(clk_50Mhz),
.            rst_n(locked),       //reset ,low active
.            key(key0),         //user key on board
.           sd_ncs(sd_ncs),      //chip select
.           sd_dclk(sd_dclk),     //sd card clock
.           sd_mosi(sd_mosi),     //sd card CMD
.            sd_miso(sd_miso)     //sd card  data

);
uart_test u1
(
.                           sys_clk(sys_clk),         //system clock positive

.                           rst_n(locked),             //reset ,low active
.                           uart_rx(uart_rx),           //fpga receive data
.                          uart_tx(uart_tx)            //fpga send data
);   

top u2
(
// Inouts
.                     ddr3_dq(ddr3_dq),                     //ddr3 data
.                     ddr3_dqs_n(ddr3_dqs_n),                  //ddr3 dqs negative
.                     ddr3_dqs_p(ddr3_dqs_p),                  //ddr3 dqs positive
// Outputs
.                      ddr3_addr(ddr3_addr),                    //ddr3 address
.                      ddr3_ba(ddr3_ba),                      //ddr3 bank
.                      ddr3_ras_n(ddr3_ras_n),                   //ddr3 ras_n
.                      ddr3_cas_n(ddr3_cas_n),                   //ddr3 cas_n
.                      ddr3_we_n(ddr3_we_n),                    //ddr3 write enable 
.                      ddr3_reset_n(ddr3_reset_n),                 //ddr3 reset,
.                      ddr3_ck_p(ddr3_ck_p),                    //ddr3 clock negative
.                      ddr3_ck_n(ddr3_ck_n),                    //ddr3 clock positive
.                      ddr3_cke(ddr3_cke),                     //ddr3_cke,
.                      ddr3_cs_n(ddr3_cs_n),                    //ddr3 chip select,
.                      ddr3_dm(ddr3_dm),                      //ddr3_dm
.                      ddr3_odt(ddr3_odt),                     //ddr3_odt
.                      sys_clk(sys_clk),                    //system clock positive on board

.                      error(),                        //ddr3 test error high is active
.                      rst_n(locked)                         //reset ,low active
);

ethernet_2port u3
(
.                           sys_clk(sys_clk),                       //system clock positive

.                           rst_n(locked),                           //reset ,low active
.                          led(led_eth),
.                          e1_reset(e1_reset),                         //phy reset
.                          e1_mdc(e1_mdc),                           //phy emdio clock
.                           e1_mdio(e1_mdio),                          //phy emdio data
.                          rgmii1_txd(rgmii1_txd),                       //phy data send
.                          rgmii1_txctl(rgmii1_txctl),                     //phy data send control
.                          rgmii1_txc(rgmii1_txc),                       //Clock for sending data
.                          rgmii1_rxd(rgmii1_rxd),                       //recieve data
.                           rgmii1_rxctl(rgmii1_rxctl),                     //Control signal for receiving data
.                           rgmii1_rxc(rgmii1_rxc),                        //Clock for recieving data	
.                          e2_reset(e2_reset),                         //phy reset
.                          e2_mdc(e2_mdc),                           //phy emdio clock
.                           e2_mdio(e2_mdio),                          //phy emdio data
.                          rgmii2_txd(rgmii2_txd),                       //phy data send
.                          rgmii2_txctl(rgmii2_txctl),                     //phy data send control
.                          rgmii2_txc(rgmii2_txc),                       //Clock for sending data
.                          rgmii2_rxd(rgmii2_rxd),                       //recieve data
.                          rgmii2_rxctl(rgmii2_rxctl),                     //Control signal for receiving data
.                           rgmii2_rxc(rgmii2_rxc)                         //Clock for recieving data	
); 

hdmi_loop u4
(
.                       sys_clk(sys_clk),          //system clock positive

.                       rst_n(locked),              //reset ,low active
.                      hdmi_in_nreset(hdmi_in_nreset),     //9011/9013 reset
.                       vin_clk(vin_clk),            //clock for 9111/9013
.                       vin_hs(vin_hs),             //horizontal synchronization for 9011/9013
.                       vin_vs(vin_vs),             //vertical synchronization for 9011/9013
.                       vin_de(vin_de),             //data valid for 9011/9013
.                      vin_data(vin_data),           //data for 9011/9013   
.                      hdmi_scl(hdmi_scl),           //HDMI I2C clock
.                      hdmi_sda(hdmi_sda),           //HDMI I2C data
.                     hdmi_nreset(hdmi_nreset),        //9134 reset
.                     vout_hs(vout_hs),            //horizontal synchronization for 9134
.                     vout_vs(vout_vs),            //vertical synchronization for 9134
.                      vout_de(vout_de),            //data valid for 9134
.                     vout_clk(vout_clk),           //clock for 9134
.                     vout_data(vout_data)           //data for 9134
);

key_test u5
(
.                  sys_clk(sys_clk),          //system clock positive


.                  key(key_led),             //input two key signal,when the keydown,the value is 0
.                  led(led_key)                 //LED display ,when the siganl high,LED lighten
);
       

  clk_wiz_0 clk_0
   (
    // Clock out ports
    .clk_out1(clk_50Mhz),     // output clk_out1
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk));    
endmodule
