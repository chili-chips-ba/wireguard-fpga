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
//  2017/7/14    meisq         1.0         Original
//********************************************************************************/
module timing_gen_xy
#(
	parameter DATA_WIDTH = 24                       // Video data one clock data width
)(
	input                   rst_n,   
	input                   clk,
	input                   i_hs,    
	input                   i_vs,    
	input                   i_de,    
	input[DATA_WIDTH - 1:0] i_data,  
	output                  o_hs,    
	output                  o_vs,    
	output                  o_de,    
	output[DATA_WIDTH - 1:0]o_data,  
	output[11:0]            x,        // video position X
	output[11:0]            y         // video position y
);
reg de_d0;
reg de_d1;
reg vs_d0;
reg vs_d1;
reg hs_d0;
reg hs_d1;
reg[DATA_WIDTH - 1:0] i_data_d0;
reg[DATA_WIDTH - 1:0] i_data_d1;
reg[11:0] x_cnt = 12'd0;
reg[11:0] y_cnt = 12'd0;
wire vs_edge;
wire de_falling;
assign vs_edge = vs_d0 & ~vs_d1;  
assign de_falling = ~de_d0 & de_d1;
assign o_de = de_d1;
assign o_vs = vs_d1;
assign o_hs = hs_d1;
assign o_data = i_data_d1;
always@(posedge clk)
begin
	de_d0 <= i_de;
	de_d1 <= de_d0;
	vs_d0 <= i_vs;
	vs_d1 <= vs_d0;
	hs_d0 <= i_hs;
	hs_d1 <= hs_d0;
	i_data_d0 <= i_data;
	i_data_d1 <= i_data_d0;
end
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		x_cnt <= 12'd0;
	else if(de_d1 == 1'b1)
		x_cnt <= x_cnt + 12'd1;
	else
		x_cnt <= 12'd0;
end
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		y_cnt <= 12'd0;
	else if(vs_edge == 1'b1)
		y_cnt <= 12'd0;
	else if(de_falling == 1'b1)
		y_cnt <= y_cnt + 12'd1;
	else
		y_cnt <= y_cnt;
end
assign x = x_cnt;
assign y = y_cnt;
endmodule 