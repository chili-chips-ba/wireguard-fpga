`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module ethernet_test
(  
input                   sys_clk,                     //clock
input                   rst_n,                       //reset ,low active
output [3:0]            led,                         //display network rate status
output                  e_reset,                     //phy reset
output                  e_mdc,                       //phy emdio clock
inout                   e_mdio,                      //phy emdio data
input	                e_rxc,                       //125Mhz ethernet gmii rx clock
input                   e_rxdv,                      //GMII recieving data valid
input                   e_rxer,                      //GMII recieving data error                    
input [7:0]             e_rxd,                       //GMII recieving data          

input                   e_txc,                       //25Mhz ethernet mii tx clock         
output                  e_gtxc,                      //125Mhz ethernet gmii tx clock  
output                  e_txen,                      //GMII sending data valid    
output                  e_txer,                      //GMII sending data error                   
output[7:0]             e_txd                        //GMII sending data 
);
wire  [31:0]            pack_total_len ;            //package length
wire [1:0]              speed      ;                //net speed select
wire                    link       ;                //link status
wire                    erxdv    ;
wire [7:0]              erxd      ;
wire                    e_tx_en    ;
wire [7:0]              etxd      ;
wire                    e_rst_n    ;
assign e_gtxc            =e_rxc;	 
assign e_reset           = 1'b1; 
/*************************************************************************
Mac layer protocol test
****************************************************************************/
mac_test mac_test0
(
.gmii_tx_clk            (e_gtxc                 ),
.gmii_rx_clk            (e_rxc                  ) ,
.rst_n                  (e_rst_n                ),
.pack_total_len         (pack_total_len         ),
.gmii_rx_dv             (erxdv                  ),
.gmii_rxd               (erxd                   ),
.gmii_tx_en             (e_tx_en                ),
.gmii_txd               (etxd                   )
); 
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
.clk                    (sys_clk                ),
.rst_n                  (rst_n                  ),         
.mdc                    (e_mdc                  ),
.mdio                   (e_mdio                 ),
.speed                  (speed                  ),
.link                   (link                   ),
.led                    (led                    )    
);  
/*************************************************************************
Different conversion of GMII data according to different network speeds
****************************************************************************/
gmii_arbi arbi_inst
(
.clk                    (e_gtxc                 ),
.rst_n                  (rst_n                  ),
.speed                  (speed                  ),  
.link                   (link                   ), 
.pack_total_len         (pack_total_len         ), 
.e_rst_n                (e_rst_n                ),
.gmii_rx_dv             (e_rxdv                 ),
.gmii_rxd               (e_rxd                  ),
.gmii_tx_en             (e_tx_en                ),
.gmii_txd               (etxd                   ), 
.e_rx_dv                (erxdv                  ),
.e_rxd                  (erxd                   ),
.e_tx_en                (e_txen                 ),
.e_txd                  (e_txd                  ) 
);
endmodule
