`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module ethernet_2port(
input sys_clk_p,      // 开发板上差分输入时钟200Mhz， 正极
input sys_clk_n,      // 开发板上差分输入时钟200Mhz， 负极  
input key,
output [3:0] led,
input rst_n,
output e1_reset,
output e1_mdc,
inout  e1_mdio,
output[3:0] rgmii1_txd,
output rgmii1_txctl,
output rgmii1_txc,
input[3:0] rgmii1_rxd,
input rgmii1_rxctl,
input rgmii1_rxc,
output e2_reset,
output e2_mdc,
inout  e2_mdio,
output[3:0] rgmii2_txd,
output rgmii2_txctl,
output rgmii2_txc,
input[3:0] rgmii2_rxd,
input rgmii2_rxctl,
input rgmii2_rxc	
); 
 
  wire sys_clk_200m;
  wire sys_clk;
  wire[3:0] led_r1;
  wire[3:0] led_r2;
  assign led=led_r1&led_r2;
  //clock generate 200M and 50M
clk_ref refclk
(
// Clock out ports
.clk_out1(sys_clk_200m),     // output clk_out1
.clk_out2(sys_clk),     // output clk_out2
// Status and control signals
.reset(1'b0), // input reset
.locked(),       // output locked
// Clock in ports
.clk_in1_p(sys_clk_p),    // input clk_in1_p
.clk_in1_n(sys_clk_n));    // input clk_in1_n   

(* IODELAY_GROUP = "rgmii_rx_delay" *) 
IDELAYCTRL  IDELAYCTRL_inst (
    .RDY(),                      // 1-bit output: Ready output
    .REFCLK(sys_clk_200m),         // 1-bit input: Reference clock input
    .RST(1'b0)                   // 1-bit input: Active high reset input
);
ethernet_test #(
    .IDELAY_VALUE(0)
)u1(
.sys_clk_50m(sys_clk),
.sys_clk(sys_clk_200m),
.key_in(key),
.rst_n(rst_n),
.led(led_r1),
.e_reset(e1_reset),          
.e_mdc(e1_mdc),
.e_mdio(e1_mdio),               

.rgmii_txd(rgmii1_txd),
.rgmii_txctl(rgmii1_txctl),     
.rgmii_txc(rgmii1_txc),
.rgmii_rxd(rgmii1_rxd),     
.rgmii_rxctl(rgmii1_rxctl),
.rgmii_rxc(rgmii1_rxc) 
      
);
          
ethernet_test #(
    .IDELAY_VALUE(3)
) u2(
.sys_clk_50m(sys_clk),
.sys_clk(sys_clk_200m),
.key_in(key),
.rst_n(rst_n),
.led(led_r2),
.e_reset(e2_reset),          
.e_mdc(e2_mdc),
.e_mdio(e2_mdio),               

.rgmii_txd(rgmii2_txd),
.rgmii_txctl(rgmii2_txctl),     
.rgmii_txc(rgmii2_txc),
.rgmii_rxd(rgmii2_rxd),     
.rgmii_rxctl(rgmii2_rxctl),
.rgmii_rxc(rgmii2_rxc) 
    
);           
endmodule                      
