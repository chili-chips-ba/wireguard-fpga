//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: lhj                                                                 //
//                                                                              //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.com/                                               //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2019/09/28   
//*******************************************************************************/
module ethernet_2port
(
input                           sys_clk,                       //system clock positive

input                           rst_n,                           //reset ,low active
output                          led,
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
input                           rgmii2_rxc                         //Clock for recieving data	
); 

wire[3:0]                       led_r1;                       //ethernet 1 speed status
wire[3:0]                       led_r2;                       //ethernet 2 speed status
assign led                       =led_r1&led_r2;
/*************************************************************************
generate single end clock
**************************************************************************/

 /*************************************************************************
ehternet 1 test
**************************************************************************/         
ethernet_test u1
(
.sys_clk                        (sys_clk                ),
.rst_n                          (rst_n                  ),
.led                            (led_r1                 ),
.e_reset                        (e1_reset               ),          
.e_mdc                          (e1_mdc                 ),
.e_mdio                         (e1_mdio                ),               
.rgmii_txd                      (rgmii1_txd             ),
.rgmii_txctl                    (rgmii1_txctl           ),     
.rgmii_txc                      (rgmii1_txc             ),
.rgmii_rxd                      (rgmii1_rxd             ),     
.rgmii_rxctl                    (rgmii1_rxctl           ),
.rgmii_rxc                      (rgmii1_rxc             )       
);
 /*************************************************************************
ehternet 2 test
**************************************************************************/              
ethernet_test u2
(
.sys_clk                        (sys_clk                ),
.rst_n                          (rst_n                  ),
.led                            (led_r2                 ),
.e_reset                        (e2_reset               ),          
.e_mdc                          (e2_mdc                 ),
.e_mdio                         (e2_mdio                ),               
.rgmii_txd                      (rgmii2_txd             ),
.rgmii_txctl                    (rgmii2_txctl           ),     
.rgmii_txc                      (rgmii2_txc             ),
.rgmii_rxd                      (rgmii2_rxd             ),     
.rgmii_rxctl                    (rgmii2_rxctl           ),
.rgmii_rxc                      (rgmii2_rxc             )     
);           
endmodule                      
