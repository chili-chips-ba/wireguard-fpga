//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//                                                                              //
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
//  2019/10/11                    1.1    
//*******************************************************************************/
module ethernet_2port(
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
input   [7:0]                   cmos1_d,                      //cmos data
output                          cmos1_rst_n,                  //cmos reset
//COMS2      
inout                           cmos2_scl,                    //cmos i2c clock
inout                           cmos2_sda,                    //cmos i2c data
input                           cmos2_vsync,                  //cmos vsync
input                           cmos2_href,                   //cmos hsync refrence,data valid
input                           cmos2_pclk,                   //cmos pxiel clock
input   [7:0]                   cmos2_d,                      //cmos data
output                          cmos2_rst_n,                  //cmos reset
output                          e1_reset,                     //phy reset
output                          e1_mdc,                       //phy emdio clock
inout                           e1_mdio,                      //phy emdio data
output[3:0]                     rgmii1_txd,                   //phy data send
output                          rgmii1_txctl,                 //phy data send control
output                          rgmii1_txc,                   //Clock for sending data
input[3:0]                      rgmii1_rxd,                   //recieve data
input                           rgmii1_rxctl,                 //Control signal for receiving data
input                           rgmii1_rxc,                   //Clock for recieving data	
output                          e2_reset,                     //phy reset
output                          e2_mdc,                       //phy emdio clock
inout                           e2_mdio,                      //phy emdio data
output[3:0]                     rgmii2_txd,                   //phy data send
output                          rgmii2_txctl,                 //phy data send control
output                          rgmii2_txc,                   //Clock for sending data
input[3:0]                      rgmii2_rxd,                   //recieve data
input                           rgmii2_rxctl,                 //Control signal for receiving data
input                           rgmii2_rxc                    //Clock for recieving data   
); 
wire                            sys_clk;          //single end clock 
wire[9:0]                       cmos1_lut_index;
wire[31:0]                      cmos1_lut_data;
wire[9:0]                       cmos2_lut_index;
wire[31:0]                      cmos2_lut_data; 
        
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
Configure the register of camera coms2
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
.cmos1_d                    (cmos1_d                   ),
    
.cmos2_pclk                 (cmos2_pclk                ),
.cmos2_vsync                (cmos2_vsync               ),		
.cmos2_href                 (cmos2_href                ),
.cmos2_d                    (cmos2_d                   )
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
     
(* IODELAY_GROUP = "rgmii_rx_delay" *) 
IDELAYCTRL  IDELAYCTRL_inst (
    .RDY(),                      // 1-bit output: Ready output
    .REFCLK(sys_clk),         // 1-bit input: Reference clock input
    .RST(1'b0)                   // 1-bit input: Active high reset input
);       
     
ethernet_test #(
    .IDELAY_VALUE(0)
) u1 (
.sys_clk                    (sys_clk                    ),
.rst_n                      (rst_n                      ),
.e_reset                    (e1_reset                   ),          
.e_mdc                      (e1_mdc                     ),
.e_mdio                     (e1_mdio                    ),               

.rgmii_txd                  (rgmii1_txd                 ),
.rgmii_txctl                (rgmii1_txctl               ),     
.rgmii_txc                  (rgmii1_txc                 ),
.rgmii_rxd                  (rgmii1_rxd                 ),     
.rgmii_rxctl                (rgmii1_rxctl               ),
.rgmii_rxc                  (rgmii1_rxc                 ),
.cmos_pclk                  (cmos_pclk                  ),
.cmos_vsync                 (cmos_vsync                 ),
.cmos_href                  (cmos_href                  ),
.cmos_href_delay            (cmos_href_delay            ),
.cmos_data_delay            (cmos_data_delay            )      
);
          
ethernet_test #(
    .IDELAY_VALUE(3)
) u2 (
.sys_clk                    (sys_clk                    ),
.rst_n                      (rst_n                      ),
.e_reset                    (e2_reset                   ),          
.e_mdc                      (e2_mdc                     ),
.e_mdio                     (e2_mdio                    ),               
.rgmii_txd                  (rgmii2_txd                 ),
.rgmii_txctl                (rgmii2_txctl               ),     
.rgmii_txc                  (rgmii2_txc                 ),
.rgmii_rxd                  (rgmii2_rxd                 ),     
.rgmii_rxctl                (rgmii2_rxctl               ),
.rgmii_rxc                  (rgmii2_rxc                 ), 
.cmos_pclk                  (cmos_pclk                  ),
.cmos_vsync                 (cmos_vsync                 ),
.cmos_href                  (cmos_href                  ),
.cmos_href_delay            (cmos_href_delay            ),
.cmos_data_delay            (cmos_data_delay            )     
);           
endmodule                      
