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
//  2019/08/19   
//*******************************************************************************/
module ethernet_test
(
input               sys_clk,                         //system clock 50Mhz on board
input               rst_n,                           //reset ,low active
output [3:0]        led,                             //display network rate status
output              e_reset,                         //phy reset
output              e_mdc,                           //phy emdio clock
inout               e_mdio,                          //phy emdio data
output[3:0]         rgmii_txd,                       //phy data send
output              rgmii_txctl,                     //phy data send control
output              rgmii_txc,                       //Clock for sending data
input[3:0]          rgmii_rxd,                       //recieve data
input               rgmii_rxctl,                     //Control signal for receiving data
input               rgmii_rxc                        //Clock for recieving data
);
wire   [ 7:0]       gmii_txd;                       //gmii data                
wire                gmii_tx_en;                     //gmii send enable
wire                gmii_tx_er;
wire                gmii_tx_clk;                    //gmii send clock
wire                gmii_crs;
wire                gmii_col;
wire   [ 7:0]       gmii_rxd;                       //gmii recieving data                    
wire                gmii_rx_dv;                     //gmii recieving data valid
wire                gmii_rx_er;
wire                gmii_rx_clk;                    //gmii recieve clock
wire  [ 1:0]        speed_selection;                // 1x gigabit, 01 100Mbps, 00 10mbps
wire                duplex_mode;                    // 1 full, 0 half
wire                rgmii_rxcpll;

wire  [31:0]        pack_total_len ;                //package length

wire [1:0]          speed      ;                    //net speed select
wire                link       ;                    //link status
wire                e_rx_dv    ;
wire [7:0]          e_rxd      ;
wire                e_tx_en    ;
wire [7:0]          e_txd      ;
wire                e_rst_n    ; 
assign duplex_mode = 1'b1;
/*************************************************************************
MDIO register configuration
****************************************************************************/
smi_config 
 #(
.REF_CLK                 (200                   ),        
.MDC_CLK                 (500                   )
)
 smi_config_inst
(
.clk                (sys_clk                ),
.rst_n              (e_reset                ),         
.mdc                (e_mdc                  ),
.mdio               (e_mdio                 ),
.speed              (speed                  ),
.link               (link                   ),
.led                (led                    )    
);    
/*************************************************************************
GMII and RGMII data conversion
****************************************************************************/
util_gmii_to_rgmii util_gmii_to_rgmii_m0
(
.reset              (1'b0                   ),
.rgmii_td           (rgmii_txd              ),
.rgmii_tx_ctl       (rgmii_txctl            ),
.rgmii_txc          (rgmii_txc              ),
.rgmii_rd           (rgmii_rxd              ),
.rgmii_rx_ctl       (rgmii_rxctl            ),
.gmii_rx_clk        (gmii_rx_clk            ),
.gmii_txd           (e_txd                  ),
.gmii_tx_en         (e_tx_en                ),
.gmii_tx_er         (1'b0                   ),
.gmii_tx_clk        (gmii_tx_clk            ),
.gmii_crs           (gmii_crs               ),
.gmii_col           (gmii_col               ),
.gmii_rxd           (gmii_rxd               ),
.rgmii_rxc          (rgmii_rxc              ),//add
.gmii_rx_dv         (gmii_rx_dv             ),
.gmii_rx_er         (gmii_rx_er             ),
.speed_selection    (speed                  ),
.duplex_mode        (duplex_mode            )
);
/*************************************************************************
Different conversion of GMII data according to different network speeds
****************************************************************************/
gmii_arbi arbi_inst
(
.clk                (gmii_tx_clk            ),
.rst_n              (rst_n                  ),
.speed              (speed                  ),  
.link               (link                   ), 
.pack_total_len     (pack_total_len         ), 
.e_rst_n            (e_rst_n                ),
.gmii_rx_dv         (gmii_rx_dv             ),
.gmii_rxd           (gmii_rxd               ),
.gmii_tx_en         (gmii_tx_en             ),
.gmii_txd           (gmii_txd               ), 
.e_rx_dv            (e_rx_dv                ),
.e_rxd              (e_rxd                  ),
.e_tx_en            (e_tx_en                ),
.e_txd              (e_txd                  ) 
);
/*************************************************************************
Mac layer protocol test
****************************************************************************/
mac_test mac_test0
(
.gmii_tx_clk        (gmii_tx_clk            ),
.gmii_rx_clk        (gmii_rx_clk            ) ,
.rst_n              (e_rst_n                ),
.pack_total_len     (pack_total_len         ),
.gmii_rx_dv         (e_rx_dv                ),
.gmii_rxd           (e_rxd                  ),
.gmii_tx_en         (gmii_tx_en             ),
.gmii_txd           (gmii_txd               )
); 
/*************************************************************************
Generate PHY reset signal
****************************************************************************/
reset reset_m0
(
.clk                (sys_clk                ),
.key1               (rst_n                  ),
.rst_n              (e_reset                )
);
endmodule
