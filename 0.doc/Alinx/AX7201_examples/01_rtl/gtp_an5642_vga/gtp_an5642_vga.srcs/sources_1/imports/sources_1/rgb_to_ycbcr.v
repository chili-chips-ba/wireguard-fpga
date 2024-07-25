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
//    Y  =  0.183R + 0.614G + 0.062B + 16
//    CB = -0.101R - 0.338G + 0.439B + 128
//    CR =  0.439R - 0.399G - 0.040B + 128
//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2017/7/19     meisq          1.0         Original
//*******************************************************************************/
`timescale 1ns/1ps
module  rgb_to_ycbcr(
	input                       clk,
	input                       rst,	
	input[7:0]                  rgb_r,
	input[7:0]                  rgb_g,
	input[7:0]                  rgb_b,
	input                       rgb_hs,
	input                       rgb_vs,
	input                       rgb_de,
	output[7:0]                 ycbcr_y,
	output[7:0]                 ycbcr_cb,
	output[7:0]                 ycbcr_cr,
	output reg                  ycbcr_hs,
	output reg                  ycbcr_vs,
	output reg                  ycbcr_de
);

//multiply 256
parameter para_0183_10b = 10'd47;
parameter para_0614_10b = 10'd157;
parameter para_0062_10b = 10'd16;
parameter para_0101_10b = 10'd26;
parameter para_0338_10b = 10'd86;
parameter para_0439_10b = 10'd112;
parameter para_0399_10b = 10'd102;
parameter para_0040_10b = 10'd10;
parameter para_16_18b   = 18'd4096;
parameter para_128_18b  = 18'd32768;

wire                           sign_cb;
wire                           sign_cr;
reg[17:0]                      mult_r_for_y_18b;
reg[17:0]                      mult_r_for_cb_18b;
reg[17:0]                      mult_r_for_cr_18b;
reg[17:0]                      mult_g_for_y_18b;
reg[17:0]                      mult_g_for_cb_18b;
reg[17:0]                      mult_g_for_cr_18b;
reg[17:0]                      mult_b_for_y_18b;
reg[17:0]                      mult_b_for_cb_18b;
reg[17:0]                      mult_b_for_cr_18b;
reg[17:0]                      add_y_0_18b;
reg[17:0]                      add_cb_0_18b;
reg[17:0]                      add_cr_0_18b;
reg[17:0]                      add_y_1_18b;
reg[17:0]                      add_cb_1_18b;
reg[17:0]                      add_cr_1_18b;
reg[17:0]                      result_y_18b;
reg[17:0]                      result_cb_18b;
reg[17:0]                      result_cr_18b;
reg[9:0]                       y_tmp;
reg[9:0]                       cb_tmp;
reg[9:0]                       cr_tmp;
reg                            i_h_sync_delay_1;
reg                            i_v_sync_delay_1;
reg                            i_data_en_delay_1;
reg                            i_h_sync_delay_2;
reg                            i_v_sync_delay_2;
reg                            i_data_en_delay_2;
reg                            i_h_sync_delay_3;
reg                            i_v_sync_delay_3;
reg                            i_data_en_delay_3;
//LV1 pipeline : mult
always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		mult_r_for_y_18b <= 18'd0;
		mult_r_for_cb_18b <= 18'd0;
		mult_r_for_cr_18b <= 18'd0;
	end
	else
	begin
		mult_r_for_y_18b <= rgb_r * para_0183_10b;
		mult_r_for_cb_18b <= rgb_r * para_0101_10b;
		mult_r_for_cr_18b <= rgb_r * para_0439_10b;
	end
end

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		mult_g_for_y_18b <= 18'd0;
		mult_g_for_cb_18b <= 18'd0;
		mult_g_for_cr_18b <= 18'd0;
	end
	else
	begin
		mult_g_for_y_18b <= rgb_g * para_0614_10b;
		mult_g_for_cb_18b <= rgb_g * para_0338_10b;
		mult_g_for_cr_18b <= rgb_g * para_0399_10b;
	end
end

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		mult_b_for_y_18b <= 18'd0;
		mult_b_for_cb_18b <= 18'd0;
		mult_b_for_cr_18b <= 18'd0;
	end
	else
	begin
		mult_b_for_y_18b <= rgb_b * para_0062_10b;
		mult_b_for_cb_18b <= rgb_b * para_0439_10b;
		mult_b_for_cr_18b <= rgb_b * para_0040_10b;
	end
end
//LV2 pipeline : add
always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		add_y_0_18b <= 18'd0;
		add_cb_0_18b <= 18'd0;
		add_cr_0_18b <= 18'd0;
		add_y_1_18b <= 18'd0;
		add_cb_1_18b <= 18'd0;
		add_cr_1_18b <= 18'd0;
	end
	else
	begin
		add_y_0_18b <= mult_r_for_y_18b + mult_g_for_y_18b;
		add_y_1_18b <= mult_b_for_y_18b + para_16_18b;
		add_cb_0_18b <= mult_b_for_cb_18b + para_128_18b;
		add_cb_1_18b <= mult_r_for_cb_18b + mult_g_for_cb_18b;
		add_cr_0_18b <= mult_r_for_cr_18b + para_128_18b;
		add_cr_1_18b <= mult_g_for_cr_18b + mult_b_for_cr_18b;
	end
end
//LV3 pipeline : y + cb + cr

assign  sign_cb = (add_cb_0_18b >= add_cb_1_18b);
assign  sign_cr = (add_cr_0_18b >= add_cr_1_18b);
always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		result_y_18b <= 18'd0;
		result_cb_18b <= 18'd0;
		result_cr_18b <= 18'd0;
	end
	else
	begin
		result_y_18b <= add_y_0_18b + add_y_1_18b;
		result_cb_18b <= sign_cb ? (add_cb_0_18b - add_cb_1_18b) : 18'd0;
		result_cr_18b <= sign_cr ? (add_cr_0_18b - add_cr_1_18b) : 18'd0;
	end
end

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		y_tmp <= 10'd0;
		cb_tmp <= 10'd0;
		cr_tmp <= 10'd0;
	end
	else
	begin
		y_tmp <= result_y_18b[17:8] + {9'd0,result_y_18b[7]};
		cb_tmp <= result_cb_18b[17:8] + {9'd0,result_cb_18b[7]};
		cr_tmp <= result_cr_18b[17:8] + {9'd0,result_cr_18b[7]};
	end
end

//output
assign  ycbcr_y      = (y_tmp[9:8] == 2'b00) ? y_tmp[7 : 0] : 8'hFF;
assign  ycbcr_cb     = (cb_tmp[9:8] == 2'b00) ? cb_tmp[7 : 0] : 8'hFF;
assign  ycbcr_cr     = (cr_tmp[9:8] == 2'b00) ? cr_tmp[7 : 0] : 8'hFF;

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		i_h_sync_delay_1 <= 1'b0;
		i_v_sync_delay_1 <= 1'b0;
		i_data_en_delay_1 <= 1'b0;
		i_h_sync_delay_2 <= 1'b0;
		i_v_sync_delay_2 <= 1'b0;
		i_data_en_delay_2 <= 1'b0;
		i_h_sync_delay_3 <= 1'b0;
		i_v_sync_delay_3 <= 1'b0;
		i_data_en_delay_3 <= 1'b0;
		ycbcr_hs <= 1'b0;
		ycbcr_vs <= 1'b0;
		ycbcr_de <= 1'b0;
	end
	else
	begin
		i_h_sync_delay_1 <= rgb_hs;
		i_v_sync_delay_1 <= rgb_vs;
		i_data_en_delay_1 <= rgb_de;
		i_h_sync_delay_2 <= i_h_sync_delay_1;
		i_v_sync_delay_2 <= i_v_sync_delay_1;
		i_data_en_delay_2 <= i_data_en_delay_1;
		i_h_sync_delay_3 <= i_h_sync_delay_2;
		i_v_sync_delay_3 <= i_v_sync_delay_2;
		i_data_en_delay_3 <= i_data_en_delay_2;
		ycbcr_hs <= i_h_sync_delay_3;
		ycbcr_vs <= i_v_sync_delay_3;
		ycbcr_de <= i_data_en_delay_3;
	end
	
end
/********************************************************************************************/
endmodule