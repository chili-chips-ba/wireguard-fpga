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
input	                        e1_rxc,                       //125Mhz ethernet gmii rx clock - 25 ili 125 input
input                           e1_rxdv,                      //GMII recieving data valid
input                           e1_rxer,                      //GMII recieving data error                    
input [7:0]                     e1_rxd,                       //GMII recieving data          

input                           e1_txc,                       //25Mhz ethernet mii tx clock   - referentni signal - uviejk 25      
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
wire [1:0]                      led_int;
/*************************************************************************
generate single end clock
**************************************************************************/
IBUFGDS sys_clk_ibufgds
(
.O                              (sys_clk                 ),
.I                              (sys_clk_p               ),
.IB                             (sys_clk_n               )
);

wire rst_int;   

wire pll_125_rst = ~rst_n;
wire pll_125_locked;
wire pll_125_clkfb;

wire clk125_pll_out;
wire clk125_int;

wire clk80_pll_out;
wire clk80_int;

wire e1_rxc_bufg;
wire e1_txc_bufg;

PLLE2_BASE #(
	.CLKFBOUT_MULT(5),
	.CLKFBOUT_PHASE(0.0),
	.CLKIN1_PERIOD(5.0),

	.CLKOUT0_DIVIDE(8),
	.CLKOUT1_DIVIDE(1),
	.CLKOUT2_DIVIDE(1),
	.CLKOUT3_DIVIDE(1),
	.CLKOUT4_DIVIDE(1),
	.CLKOUT5_DIVIDE(1),

	.CLKOUT0_DUTY_CYCLE(0.5),
	.CLKOUT1_DUTY_CYCLE(0.5),
	.CLKOUT2_DUTY_CYCLE(0.5),
	.CLKOUT3_DUTY_CYCLE(0.5),
	.CLKOUT4_DUTY_CYCLE(0.5),
	.CLKOUT5_DUTY_CYCLE(0.5),

	.CLKOUT0_PHASE(0.0),
	.CLKOUT1_PHASE(0.0),
	.CLKOUT2_PHASE(0.0),
	.CLKOUT3_PHASE(0.0),
	.CLKOUT4_PHASE(0.0),
	.CLKOUT5_PHASE(0.0),

	.DIVCLK_DIVIDE(1)
) pll_125 (
	.CLKOUT0(clk125_pll_out),
	.CLKOUT1(),
	.CLKOUT2(),
	.CLKOUT3(),
	.CLKOUT4(),
	.CLKOUT5(),

	.CLKFBOUT(pll_125_clkfb),
	.CLKFBIN(pll_125_clkfb),

	.LOCKED(pll_125_locked),
	.CLKIN1(sys_clk),

	.PWRDWN(0),
	.RST(~rst_n)
);
	
BUFG
clk_bufg_inst (
    .I(clk125_pll_out),
    .O(clk125_int)
);

/*BUFG
clk90_bufg_inst (
    .I(clk80_pll_out),
    .O(clk80_int)
);*/

sync_reset #(
    .N(4)
)
sync_reset_inst (
    .clk(clk125_int),
    .rst(~pll_125_locked),
    .out(rst_int)
);

IBUFG
e1_rxc_bufg_inst (
    .I(e1_rxc),
    .O(e1_rxc_bufg)
);

//IBUFG
//e2_rxc_bufg_inst (
//    .I(e2_rxc),
//    .O(e2_rxc_bufg)
//);

//IBUFG
//e3_rxc_bufg_inst (
//    .I(e3_rxc),
//    .O(e3_rxc_bufg)
//);

//IBUFG
//e4_rxc_bufg_inst (
//    .I(e4_rxc),
//    .O(e4_rxc_bufg)
//);

/*************************************************************************
ehternet 1 test
**************************************************************************/

// AXI between MAC and Ethernet modules
wire [7:0] rx_tx_axis_tdata_1;
wire rx_tx_axis_tvalid_1;
wire rx_tx_axis_tready_1;
wire rx_tx_axis_tlast_1;
wire rx_tx_axis_tuser_1;

assign e1_reset = 1'b1; 

/*************************************************************************
Mac layer protocol test
****************************************************************************/

eth_mac_1g_gmii_fifo #(
    .TARGET("XILINX"),
    .IODDR_STYLE("IODDR"),
    .CLOCK_INPUT_STYLE("BUFR"),
    .ENABLE_PADDING(1),
    .MIN_FRAME_LENGTH(64),
    .TX_FIFO_DEPTH(4096),
    .TX_FRAME_FIFO(1),
    .RX_FIFO_DEPTH(4096),
    .RX_FRAME_FIFO(1)
)
eth_1 (
    .gtx_clk(clk125_int),
    .gtx_rst(rst_int), 
    .logic_clk(clk125_int), 
    .logic_rst(rst_int), 

    .tx_axis_tdata(rx_tx_axis_tdata_1),
    .tx_axis_tvalid(rx_tx_axis_tvalid_1),
    .tx_axis_tready(rx_tx_axis_tready_1),
    .tx_axis_tlast(rx_tx_axis_tlast_1),
    .tx_axis_tuser(rx_tx_axis_tuser_1),

    .rx_axis_tdata(rx_tx_axis_tdata_1),
    .rx_axis_tvalid(rx_tx_axis_tvalid_1),
    .rx_axis_tready(rx_tx_axis_tready_1),
    .rx_axis_tlast(rx_tx_axis_tlast_1),
    .rx_axis_tuser(rx_tx_axis_tuser_1),

    .gmii_rx_clk(e1_rxc_bufg),
    .gmii_rxd(e1_rxd),
    .gmii_rx_dv(e1_rxdv),
    .gmii_rx_er(e1_rxer),
    .mii_tx_clk(e1_txc), 
    .gmii_tx_clk(e1_gtxc),
    .gmii_txd(e1_txd),
    .gmii_tx_en(e1_txen),
    .gmii_tx_er(e1_txer),
    
    .tx_fifo_overflow(),
    .tx_fifo_bad_frame(),
    .tx_fifo_good_frame(),
    .rx_error_bad_frame(),
    .rx_error_bad_fcs(),
    .rx_fifo_overflow(),
    .rx_fifo_bad_frame(),
    .rx_fifo_good_frame(),
    .speed(led_int),

    .cfg_ifg(8'd12),
    .cfg_tx_enable(1'b1),
    .cfg_rx_enable(1'b1)
);

assign led = ~led_int;

///*************************************************************************
//ehternet 2 test
//**************************************************************************/

//// AXI between MAC and Ethernet modules
//wire [7:0] rx_tx_axis_tdata_2;
//wire rx_tx_axis_tvalid_2;
//wire rx_tx_axis_tready_2;
//wire rx_tx_axis_tlast_2;
//wire rx_tx_axis_tuser_2;

//assign e2_reset = 1'b1; 

///*************************************************************************
//Mac layer protocol test
//****************************************************************************/

//eth_mac_1g_gmii_fifo #(
//    .TARGET("XILINX"),
//    .IODDR_STYLE("IODDR"),
//    .CLOCK_INPUT_STYLE("BUFR"),
//    .ENABLE_PADDING(1),
//    .MIN_FRAME_LENGTH(64),
//    .TX_FIFO_DEPTH(4096),
//    .TX_FRAME_FIFO(1),
//    .RX_FIFO_DEPTH(4096),
//    .RX_FRAME_FIFO(1)
//)
//eth_2 (
//    .gtx_clk(clk125_int),
//    .gtx_rst(rst_int), 
//    .logic_clk(clk125_int), 
//    .logic_rst(rst_int), 

//    .tx_axis_tdata(rx_tx_axis_tdata_2),
//    .tx_axis_tvalid(rx_tx_axis_tvalid_2),
//    .tx_axis_tready(rx_tx_axis_tready_2),
//    .tx_axis_tlast(rx_tx_axis_tlast_2),
//    .tx_axis_tuser(rx_tx_axis_tuser_2),

//    .rx_axis_tdata(rx_tx_axis_tdata_2),
//    .rx_axis_tvalid(rx_tx_axis_tvalid_2),
//    .rx_axis_tready(rx_tx_axis_tready_2),
//    .rx_axis_tlast(rx_tx_axis_tlast_2),
//    .rx_axis_tuser(rx_tx_axis_tuser_2),

//    .gmii_rx_clk(e2_rxc_bufg),
//    .gmii_rxd(e2_rxd),
//    .gmii_rx_dv(e2_rxdv),
//    .gmii_rx_er(e2_rxer),
//    .mii_tx_clk(e2_txc), 
//    .gmii_tx_clk(e2_gtxc),
//    .gmii_txd(e2_txd),
//    .gmii_tx_en(e2_txen),
//    .gmii_tx_er(e2_txer),
    
//    .tx_fifo_overflow(),
//    .tx_fifo_bad_frame(),
//    .tx_fifo_good_frame(),
//    .rx_error_bad_frame(),
//    .rx_error_bad_fcs(),
//    .rx_fifo_overflow(),
//    .rx_fifo_bad_frame(),
//    .rx_fifo_good_frame(),
//    .speed(),

//    .cfg_ifg(8'd12),
//    .cfg_tx_enable(1'b1),
//    .cfg_rx_enable(1'b1)
//);

///*************************************************************************
//ehternet 3 test
//**************************************************************************/

//// AXI between MAC and Ethernet modules
//wire [7:0] rx_tx_axis_tdata_3;
//wire rx_tx_axis_tvalid_3;
//wire rx_tx_axis_tready_3;
//wire rx_tx_axis_tlast_3;
//wire rx_tx_axis_tuser_3;

//assign e3_reset = 1'b1; 

///*************************************************************************
//Mac layer protocol test
//****************************************************************************/

//eth_mac_1g_gmii_fifo #(
//    .TARGET("XILINX"),
//    .IODDR_STYLE("IODDR"),
//    .CLOCK_INPUT_STYLE("BUFR"),
//    .ENABLE_PADDING(1),
//    .MIN_FRAME_LENGTH(64),
//    .TX_FIFO_DEPTH(4096),
//    .TX_FRAME_FIFO(1),
//    .RX_FIFO_DEPTH(4096),
//    .RX_FRAME_FIFO(1)
//)
//eth_3 (
//    .gtx_clk(clk125_int),
//    .gtx_rst(rst_int), 
//    .logic_clk(clk125_int), 
//    .logic_rst(rst_int), 

//    .tx_axis_tdata(rx_tx_axis_tdata_3),
//    .tx_axis_tvalid(rx_tx_axis_tvalid_3),
//    .tx_axis_tready(rx_tx_axis_tready_3),
//    .tx_axis_tlast(rx_tx_axis_tlast_3),
//    .tx_axis_tuser(rx_tx_axis_tuser_3),

//    .rx_axis_tdata(rx_tx_axis_tdata_3),
//    .rx_axis_tvalid(rx_tx_axis_tvalid_3),
//    .rx_axis_tready(rx_tx_axis_tready_3),
//    .rx_axis_tlast(rx_tx_axis_tlast_3),
//    .rx_axis_tuser(rx_tx_axis_tuser_3),

//    .gmii_rx_clk(e3_rxc_bufg),
//    .gmii_rxd(e3_rxd),
//    .gmii_rx_dv(e3_rxdv),
//    .gmii_rx_er(e3_rxer),
//    .mii_tx_clk(e3_txc), 
//    .gmii_tx_clk(e3_gtxc),
//    .gmii_txd(e3_txd),
//    .gmii_tx_en(e3_txen),
//    .gmii_tx_er(e3_txer),
    
//    .tx_fifo_overflow(),
//    .tx_fifo_bad_frame(),
//    .tx_fifo_good_frame(),
//    .rx_error_bad_frame(),
//    .rx_error_bad_fcs(),
//    .rx_fifo_overflow(),
//    .rx_fifo_bad_frame(),
//    .rx_fifo_good_frame(),
//    .speed(),

//    .cfg_ifg(8'd12),
//    .cfg_tx_enable(1'b1),
//    .cfg_rx_enable(1'b1)
//);

///*************************************************************************
//ehternet 4 test
//**************************************************************************/

//// AXI between MAC and Ethernet modules
//wire [7:0] rx_tx_axis_tdata_4;
//wire rx_tx_axis_tvalid_4;
//wire rx_tx_axis_tready_4;
//wire rx_tx_axis_tlast_4;
//wire rx_tx_axis_tuser_4;

//assign e4_reset = 1'b1; 

///*************************************************************************
//Mac layer protocol test
//****************************************************************************/

//eth_mac_1g_gmii_fifo #(
//    .TARGET("XILINX"),
//    .IODDR_STYLE("IODDR"),
//    .CLOCK_INPUT_STYLE("BUFR"),
//    .ENABLE_PADDING(1),
//    .MIN_FRAME_LENGTH(64),
//    .TX_FIFO_DEPTH(4096),
//    .TX_FRAME_FIFO(1),
//    .RX_FIFO_DEPTH(4096),
//    .RX_FRAME_FIFO(1)
//)
//eth_4 (
//    .gtx_clk(clk125_int),
//    .gtx_rst(rst_int), 
//    .logic_clk(clk125_int), 
//    .logic_rst(rst_int), 

//    .tx_axis_tdata(rx_tx_axis_tdata_4),
//    .tx_axis_tvalid(rx_tx_axis_tvalid_4),
//    .tx_axis_tready(rx_tx_axis_tready_4),
//    .tx_axis_tlast(rx_tx_axis_tlast_4),
//    .tx_axis_tuser(rx_tx_axis_tuser_4),

//    .rx_axis_tdata(rx_tx_axis_tdata_4),
//    .rx_axis_tvalid(rx_tx_axis_tvalid_4),
//    .rx_axis_tready(rx_tx_axis_tready_4),
//    .rx_axis_tlast(rx_tx_axis_tlast_4),
//    .rx_axis_tuser(rx_tx_axis_tuser_4),

//    .gmii_rx_clk(e4_rxc_bufg),
//    .gmii_rxd(e4_rxd),
//    .gmii_rx_dv(e4_rxdv),
//    .gmii_rx_er(e4_rxer),
//    .mii_tx_clk(e4_txc), 
//    .gmii_tx_clk(e4_gtxc),
//    .gmii_txd(e4_txd),
//    .gmii_tx_en(e4_txen),
//    .gmii_tx_er(e4_txer),
    
//    .tx_fifo_overflow(),
//    .tx_fifo_bad_frame(),
//    .tx_fifo_good_frame(),
//    .rx_error_bad_frame(),
//    .rx_error_bad_fcs(),
//    .rx_fifo_overflow(),
//    .rx_fifo_bad_frame(),
//    .rx_fifo_good_frame(),
//    .speed(),

//    .cfg_ifg(8'd12),
//    .cfg_tx_enable(1'b1),
//    .cfg_rx_enable(1'b1)
//);

endmodule