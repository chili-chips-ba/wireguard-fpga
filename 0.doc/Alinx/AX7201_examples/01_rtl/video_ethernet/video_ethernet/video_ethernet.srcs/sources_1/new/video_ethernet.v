//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
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
//  2017/7/19     meisq          1.0         Original
//  2019/10/11                    1.1    
//*******************************************************************************/
module video_ethernet
(
input                           sys_clk_p,                    //system clock positive
input                           sys_clk_n,                    //system clock negative 
input                           rst_n,                        //reset ,low active
input                           key2,                         //video switch another
//COMS1
inout                           cmos1_scl,                    //cmos i2c clock
inout                           cmos1_sda,                    //cmos i2c data
input                           cmos1_vsync,                  //cmos vsync
input                           cmos1_href,                   //cmos hsync refrence,data valid
input                           cmos1_pclk,                   //cmos pxiel clock
input   [9:0]                   cmos1_db,                     //cmos data
output                          cmos1_rst_n,                  //cmos reset
//COMS2      
inout                           cmos2_scl,                    //cmos i2c clock
inout                           cmos2_sda,                    //cmos i2c data
input                           cmos2_vsync,                  //cmos vsync
input                           cmos2_href,                   //cmos hsync refrence,data valid
input                           cmos2_pclk,                   //cmos pxiel clock
input   [9:0]                   cmos2_db,                     //cmos data
output                          cmos2_rst_n,                  //cmos reset
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
wire                            sys_clk;          //single end clock 
wire[9:0]                       cmos1_lut_index;
wire[31:0]                      cmos1_lut_data;
wire[9:0]                       cmos2_lut_index;
wire[31:0]                      cmos2_lut_data; 
wire                            reg_conf_done;        
assign cmos1_rst_n               = 1'b1;
assign cmos2_rst_n               = 1'b1;
/*************************************************************************
generate single end clock
**************************************************************************/
IBUFGDS sys_clk_ibufgds
(
.O                          (sys_clk                 ),
.I                          (sys_clk_p               ),
.IB                         (sys_clk_n               )
);
/*************************************************************************
Configure the register of camera coms1
****************************************************************************/
i2c_config i2c_config_m0
(
.rst                        (~rst_n                   ),
.clk                        (sys_clk                  ),
.clk_div_cnt                (16'd500                  ),
.i2c_addr_2byte             (1'b1                     ),
.lut_index                  (cmos1_lut_index          ),
.lut_dev_addr               (cmos1_lut_data[31:24]    ),
.lut_reg_addr               (cmos1_lut_data[23:8]     ),
.lut_reg_data               (cmos1_lut_data[7:0]      ),
.error                      (                         ),
.done                       (                         ),
.i2c_scl                    (cmos1_scl                ),
.i2c_sda                    (cmos1_sda                )
);
/*************************************************************************
look-up table of camera coms1
****************************************************************************/
lut_ov5640_rgb565_800_600 lut_ov5640_rgb565_800_600_m0
(
.lut_index                  (cmos1_lut_index          ),
.lut_data                   (cmos1_lut_data           )
);
/*************************************************************************
Configure the register of camera coms2
****************************************************************************/
i2c_config i2c_config_m1
( 
.rst                        (~rst_n                   ),
.clk                        (sys_clk                  ),
.clk_div_cnt                (16'd500                  ),
.i2c_addr_2byte             (1'b1                     ),
.lut_index                  (cmos2_lut_index          ),
.lut_dev_addr               (cmos2_lut_data[31:24]    ),
.lut_reg_addr               (cmos2_lut_data[23:8]     ),
.lut_reg_data               (cmos2_lut_data[7:0]      ),
.error                      (                         ),
.done                       (                         ),
.i2c_scl                    (cmos2_scl                ),
.i2c_sda                    (cmos2_sda                )
);
/*************************************************************************
look-up table of camera coms2
****************************************************************************/
lut_ov5640_rgb565_800_600 lut_ov5640_rgb565_800_600_m1
(
.lut_index                  (cmos2_lut_index           ),
.lut_data                   (cmos2_lut_data            )
);
wire                        cmos_pclk;
wire                        cmos_vsync;
wire                        cmos_href;
wire [7:0]                  cmos_db;
/*************************************************************************
Select cmos1 or cmos2 with key2
****************************************************************************/
cmos_select	cmos_select_inst
(
.clk                        (sys_clk                   ),
.reset_n                    (rst_n                     ),	
.key1                       (key2                      ),

.cmos_pclk                  (cmos_pclk                 ),
.cmos_vsync                 (cmos_vsync                ),        
.cmos_href                  (cmos_href                 ),
.cmos_d                     (cmos_db                   ),	

.cmos1_pclk                 (cmos1_pclk                ),
.cmos1_vsync                (cmos1_vsync               ),        
.cmos1_href                 (cmos1_href                ),
.cmos1_d                    (cmos1_db[9:2]             ),
    
.cmos2_pclk                 (cmos2_pclk                ),
.cmos2_vsync                (cmos2_vsync               ),		
.cmos2_href                 (cmos2_href                ),
.cmos2_d                    (cmos2_db[9:2]             )
);

wire                        cmos_vsync_delay;
wire                        cmos_href_delay;
wire [7:0]                  cmos_data_delay;

camera_delay camera_delay_inst
(
.cmos_pclk                  (cmos_pclk                  ),              //cmos pxiel clock
.cmos_href                  (cmos_href                  ),              //cmos hsync refrence
.cmos_vsync                 (cmos_vsync                 ),              //cmos vsync
.cmos_data                  (cmos_db                    ),              //cmos data

.cmos_href_delay            (cmos_href_delay            ),              //cmos hsync refrence
.cmos_vsync_delay           (cmos_vsync_delay           ),              //cmos vsync
.cmos_data_delay            (cmos_data_delay            )               //cmos data
) ;
//NO 1 ethernet
assign e1_gtxc                   =e1_rxc;	 
assign e1_reset                  = 1'b1; 

assign  e1_mdc                   =1'bz;
assign  e1_mdio                  =1'bz;
wire [10 : 0]               fifo_data_count1;
wire [7:0]                  fifo_data1;
wire                        fifo_rd_en1;
camera_fifo camera_fifo_inst1 (
.rst                        (cmos_vsync                 ),              // input rst
.wr_clk                     (cmos_pclk                  ),              // input wr_clk
.din                        (cmos_data_delay            ),              // input [7 : 0] din
.wr_en                      (cmos_href_delay            ),              // input wr_en

.rd_clk                     (e1_rxc                     ),               // input rd_clk
.rd_en                      (fifo_rd_en1                ),               // input rd_en
.dout                       (fifo_data1                 ),               // output [7 : 0] dout
.full                       (                           ),               // output full
.empty                      (                           ),               // output empty
.rd_data_count              (fifo_data_count1           )                // output [10 : 0] rd_data_count
);

mac_test mac_test1
(
.gmii_tx_clk                (e1_gtxc                    ),
.gmii_rx_clk                (e1_rxc                     ) ,
.rst_n                      (rst_n                      ),

.cmos_vsync                 (cmos_vsync                 ),
.cmos_href                  (cmos_href                  ),
.reg_conf_done              (1'b1                       ),
.fifo_data                  (fifo_data1                 ),           
.fifo_data_count            (fifo_data_count1           ),    
.fifo_rd_en                 (fifo_rd_en1                ),       

.udp_send_data_length       (16'd1024                   ), 
.gmii_rx_dv                 (e1_rxdv                    ),
.gmii_rxd                   (e1_rxd                     ),
.gmii_tx_en                 (e1_txen                    ),
.gmii_txd                   (e1_txd                     )
);
//NO 2 ethernet
assign e2_gtxc                   =e2_rxc;	 
assign e2_reset                  = 1'b1; 

assign  e2_mdc                   =1'bz;
assign  e2_mdio                  =1'bz;
wire [10 : 0]               fifo_data_count2;
wire [7:0]                  fifo_data2;
wire                        fifo_rd_en2;
camera_fifo camera_fifo_inst2 (
.rst                        (cmos_vsync                 ),              // input rst
.wr_clk                     (cmos_pclk                  ),              // input wr_clk
.din                        (cmos_data_delay            ),              // input [7 : 0] din
.wr_en                      (cmos_href_delay            ),              // input wr_en

.rd_clk                     (e2_rxc                     ),               // input rd_clk
.rd_en                      (fifo_rd_en2                ),               // input rd_en
.dout                       (fifo_data2                 ),               // output [7 : 0] dout
.full                       (                           ),               // output full
.empty                      (                           ),               // output empty
.rd_data_count              (fifo_data_count2           )                // output [10 : 0] rd_data_count
);

mac_test mac_test2
(
.gmii_tx_clk                (e2_gtxc                    ),
.gmii_rx_clk                (e2_rxc                     ) ,
.rst_n                      (rst_n                      ),

.cmos_vsync                 (cmos_vsync                 ),
.cmos_href                  (cmos_href                  ),
.reg_conf_done              (1'b1                       ),
.fifo_data                  (fifo_data2                 ),           
.fifo_data_count            (fifo_data_count2           ),    
.fifo_rd_en                 (fifo_rd_en2                ),       

.udp_send_data_length       (16'd1024                   ), 
.gmii_rx_dv                 (e2_rxdv                    ),
.gmii_rxd                   (e2_rxd                     ),
.gmii_tx_en                 (e2_txen                    ),
.gmii_txd                   (e2_txd                     )
);
//NO 3 ethernet
assign e3_gtxc                   =e3_rxc;	 
assign e3_reset                  = 1'b1; 

assign  e3_mdc                   =1'bz;
assign  e3_mdio                  =1'bz;
wire [10 : 0]               fifo_data_count3;
wire [7:0]                  fifo_data3;
wire                        fifo_rd_en3;
camera_fifo camera_fifo_inst3 (
.rst                        (cmos_vsync                 ),              // input rst
.wr_clk                     (cmos_pclk                  ),              // input wr_clk
.din                        (cmos_data_delay            ),              // input [7 : 0] din
.wr_en                      (cmos_href_delay            ),              // input wr_en

.rd_clk                     (e3_rxc                     ),               // input rd_clk
.rd_en                      (fifo_rd_en3                ),               // input rd_en
.dout                       (fifo_data3                 ),               // output [7 : 0] dout
.full                       (                           ),               // output full
.empty                      (                           ),               // output empty
.rd_data_count              (fifo_data_count3           )                // output [10 : 0] rd_data_count
);

mac_test mac_test3
(
.gmii_tx_clk                (e3_gtxc                    ),
.gmii_rx_clk                (e3_rxc                     ) ,
.rst_n                      (rst_n                      ),

.cmos_vsync                 (cmos_vsync                 ),
.cmos_href                  (cmos_href                  ),
.reg_conf_done              (1'b1                       ),
.fifo_data                  (fifo_data3                 ),           
.fifo_data_count            (fifo_data_count3           ),    
.fifo_rd_en                 (fifo_rd_en3                ),       

.udp_send_data_length       (16'd1024                   ), 
.gmii_rx_dv                 (e3_rxdv                    ),
.gmii_rxd                   (e3_rxd                     ),
.gmii_tx_en                 (e3_txen                    ),
.gmii_txd                   (e3_txd                     )
);
//NO 4 ethernet
assign e4_gtxc                   =e4_rxc;	 
assign e4_reset                  = 1'b1; 

assign  e4_mdc                   =1'bz;
assign  e4_mdio                  =1'bz;
wire [10 : 0]               fifo_data_count4;
wire [7:0]                  fifo_data4;
wire                        fifo_rd_en4;
camera_fifo camera_fifo_inst4 (
.rst                        (cmos_vsync                 ),              // input rst
.wr_clk                     (cmos_pclk                  ),              // input wr_clk
.din                        (cmos_data_delay            ),              // input [7 : 0] din
.wr_en                      (cmos_href_delay            ),              // input wr_en

.rd_clk                     (e4_rxc                     ),               // input rd_clk
.rd_en                      (fifo_rd_en4                ),               // input rd_en
.dout                       (fifo_data4                 ),               // output [7 : 0] dout
.full                       (                           ),               // output full
.empty                      (                           ),               // output empty
.rd_data_count              (fifo_data_count4           )                // output [10 : 0] rd_data_count
);

mac_test mac_test4
(
.gmii_tx_clk                (e4_gtxc                    ),
.gmii_rx_clk                (e4_rxc                     ) ,
.rst_n                      (rst_n                      ),

.cmos_vsync                 (cmos_vsync                 ),
.cmos_href                  (cmos_href                  ),
.reg_conf_done              (1'b1                       ),
.fifo_data                  (fifo_data4                 ),           
.fifo_data_count            (fifo_data_count4           ),    
.fifo_rd_en                 (fifo_rd_en4                ),       

.udp_send_data_length       (16'd1024                   ), 
.gmii_rx_dv                 (e4_rxdv                    ),
.gmii_rxd                   (e4_rxd                     ),
.gmii_tx_en                 (e4_txen                    ),
.gmii_txd                   (e4_txd                     )
);
endmodule
