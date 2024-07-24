//////////////////////////////////////////////////////////////////////////////////
//   hdmi color bar test                                                         //
//                                                                              //
//  Author: lhj                                                                 //
//                                                                              //
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
//2019/08/30                    1.0          Original
//*******************************************************************************/
`timescale 1ns/1ps
module hdmi_loop
(
input                       sys_clk,          //system clock positive

input                       rst_n,              //reset ,low active
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
output[23:0]                vout_data           //data for 9134
);

wire[9:0]                  lut_index;           //look table index
wire[31:0]                 lut_data;            //look table data  
assign vout_clk             = vin_clk;
assign vout_hs              = vin_hs;
assign vout_vs              = vin_vs;
assign vout_de              = vin_de;
assign vout_data            = vin_data;
assign hdmi_nreset          = rst_n;
assign hdmi_in_nreset       = rst_n;
/*************************************************************************
generate single end clock
**************************************************************************/

/*************************************************************************
Configure the register of 9011 and 9134
****************************************************************************/
i2c_config i2c_config_m0(
.rst                        (~rst_n                   ),
.clk                        (sys_clk                  ),
.clk_div_cnt                (16'd500                  ),
.i2c_addr_2byte             (1'b0                     ),
.lut_index                  (lut_index                ),
.lut_dev_addr               (lut_data[31:24]          ),
.lut_reg_addr               (lut_data[23:8]           ),
.lut_reg_data               (lut_data[7:0]            ),
.error                      (                         ),
.done                       (                         ),
.i2c_scl                    (hdmi_scl                 ),
.i2c_sda                    (hdmi_sda                 )
);
//configure look-up table
lut_hdmi lut_hdmi_m0(
.lut_index                  (lut_index                ),
.lut_data                   (lut_data                 )
);
endmodule 