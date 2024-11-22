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
//  2019/09/29   
//*******************************************************************************/
module ethernet_4port
(
input                           sys_clk_p,                    //system clock positive
input                           sys_clk_n,                    //system clock negative 
input                           rst_n,                        //reset ,low active
output[1:0]                     led,                          //display network rate status
//ethernet 1
output                          e1_reset,                     //phy reset
output                          e1_mdc,                       //phy emdio clock
inout                           e1_mdio,                      //phy emdio data
input	                        e1_rxc,                       //125Mhz ethernet gmii rx clock
input                           e1_rxdv,                      //GMII recieving data valid
input                           e1_rxer,                      //GMII recieving data error                    
input [7:0]                     e1_rxd,                       //GMII recieving data          

input                           e1_txc,                       //25Mhz ethernet mii tx clock         
output                          e1_gtxc,                      //125Mhz ethernet gmii tx clock  
output                          e1_txen,                      //GMII sending data valid    
output                          e1_txer,                      //GMII sending data error                   
output[7:0]                     e1_txd,                       //GMII sending data 
 //ethernet 2
output                          e2_reset,                     //phy reset
output                          e2_mdc,                       //phy emdio clock
inout                           e2_mdio,                      //phy emdio data
input	                        e2_rxc,                       //125Mhz ethernet gmii rx clock
input                           e2_rxdv,                      //GMII recieving data valid
input                           e2_rxer,                      //GMII recieving data error                    
input [7:0]                     e2_rxd,                       //GMII recieving data          

input                           e2_txc,                       //25Mhz ethernet mii tx clock         
output                          e2_gtxc,                      //125Mhz ethernet gmii tx clock  
output                          e2_txen,                      //GMII sending data valid    
output                          e2_txer,                      //GMII sending data error                   
output[7:0]                     e2_txd,                       //GMII sending data 
//ethernet 3
output                          e3_reset,                     //phy reset
output                          e3_mdc,                       //phy emdio clock
inout                           e3_mdio,                      //phy emdio data
input	                        e3_rxc,                       //125Mhz ethernet gmii rx clock
input                           e3_rxdv,                      //GMII recieving data valid
input                           e3_rxer,                      //GMII recieving data error                    
input [7:0]                     e3_rxd,                       //GMII recieving data          

input                           e3_txc,                       //25Mhz ethernet mii tx clock         
output                          e3_gtxc,                      //125Mhz ethernet gmii tx clock  
output                          e3_txen,                      //GMII sending data valid    
output                          e3_txer,                      //GMII sending data error                   
output[7:0]                     e3_txd,                       //GMII sending data 
//ethernet 4
output                          e4_reset,                     //phy reset
output                          e4_mdc,                       //phy emdio clock
inout                           e4_mdio,                      //phy emdio data
input	                        e4_rxc,                       //125Mhz ethernet gmii rx clock
input                           e4_rxdv,                      //GMII recieving data valid
input                           e4_rxer,                      //GMII recieving data error                    
input [7:0]                     e4_rxd,                       //GMII recieving data          

input                           e4_txc,                       //25Mhz ethernet mii tx clock         
output                          e4_gtxc,                      //125Mhz ethernet gmii tx clock  
output                          e4_txen,                      //GMII sending data valid    
output                          e4_txer,                      //GMII sending data error                   
output[7:0]                     e4_txd                        //GMII sending data 
); 
wire                            sys_clk;                      //single end clock 
wire[3:0]                       led_r1;                       //ethernet 1 speed status
wire[3:0]                       led_r2;                       //ethernet 2 speed status
wire[3:0]                       led_r3;                       //ethernet 3 speed status
wire[3:0]                       led_r4;                       //ethernet 4 speed status
assign led                       =led_r1[2:1]&led_r2[2:1]&led_r3[2:1]&led_r4[2:1];
/*************************************************************************
generate single end clock
**************************************************************************/
IBUFDS sys_clk_ibufgds
(
.O                              (sys_clk                 ),
.I                              (sys_clk_p               ),
.IB                             (sys_clk_n               )
);
/*************************************************************************
ehternet 1 test
**************************************************************************/
ethernet_test u1
(
.sys_clk                        (sys_clk                ),
.rst_n                          (rst_n                  ),
.e_reset                        (e1_reset               ), 
.e_mdc                          (e1_mdc                 ),        
.e_mdio                         (e1_mdio                ), 
.e_rxc                          (e1_rxc                 ), 
.e_rxdv                         (e1_rxdv                ), 
.e_rxer                         (e1_rxer                ), 
.e_rxd                          (e1_rxd                 ), 
.led                            (led_r1                 ),
.e_txc                          (e1_txc                 ), 
.e_gtxc                         (e1_gtxc                ), 
.e_txen                         (e1_txen                ), 
.e_txer                         (e1_txer                ),
.e_txd                          (e1_txd                 )        
);
/*************************************************************************
ehternet 2 test
**************************************************************************/
ethernet_test u2
(
.sys_clk                        (sys_clk                ),
.rst_n                          (rst_n                  ),
.e_reset                        (e2_reset               ), 
.e_mdc                          (e2_mdc                 ),        
.e_mdio                         (e2_mdio                ), 
.e_rxc                          (e2_rxc                 ), 
.e_rxdv                         (e2_rxdv                ), 
.e_rxer                         (e2_rxer                ), 
.e_rxd                          (e2_rxd                 ), 
.led                            (led_r2                 ),
.e_txc                          (e2_txc                 ), 
.e_gtxc                         (e2_gtxc                ), 
.e_txen                         (e2_txen                ), 
.e_txer                         (e2_txer                ),
.e_txd                          (e2_txd                 )        
);
/*************************************************************************
ehternet 3 test
**************************************************************************/
ethernet_test u3
(
.sys_clk                        (sys_clk                ),
.rst_n                          (rst_n                  ),
.e_reset                        (e3_reset               ), 
.e_mdc                          (e3_mdc                 ),        
.e_mdio                         (e3_mdio                ), 
.e_rxc                          (e3_rxc                 ), 
.e_rxdv                         (e3_rxdv                ), 
.e_rxer                         (e3_rxer                ), 
.e_rxd                          (e3_rxd                 ), 
.led                            (led_r3                 ),
.e_txc                          (e3_txc                 ), 
.e_gtxc                         (e3_gtxc                ), 
.e_txen                         (e3_txen                ), 
.e_txer                         (e3_txer                ),
.e_txd                          (e3_txd                 )        
);
/*************************************************************************
ehternet 4 test
**************************************************************************/
ethernet_test u4
(
.sys_clk                        (sys_clk                ),
.rst_n                          (rst_n                  ),
.e_reset                        (e4_reset               ), 
.e_mdc                          (e4_mdc                 ),        
.e_mdio                         (e4_mdio                ), 
.e_rxc                          (e4_rxc                 ), 
.e_rxdv                         (e4_rxdv                ), 
.e_rxer                         (e4_rxer                ), 
.e_rxd                          (e4_rxd                 ), 
.led                            (led_r4                 ),
.e_txc                          (e4_txc                 ), 
.e_gtxc                         (e4_gtxc                ), 
.e_txen                         (e4_txen                ), 
.e_txer                         (e4_txer                ),
.e_txd                          (e4_txd                 )        
);
endmodule