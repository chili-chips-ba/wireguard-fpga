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
//*******************************************************************************/

module i2c_config(
	input              rst,
	input              clk,
	input[15:0]        clk_div_cnt,
	input              i2c_addr_2byte,
	output reg[9:0]    lut_index,
	input[7:0]         lut_dev_addr,
	input[15:0]        lut_reg_addr,
	input[7:0]         lut_reg_data,
	output reg         error,
	output             done,
	inout              i2c_scl,
	inout              i2c_sda
);
wire scl_pad_i;
wire scl_pad_o;
wire scl_padoen_o;

wire sda_pad_i;
wire sda_pad_o;
wire sda_padoen_o;

assign sda_pad_i = i2c_sda;
assign i2c_sda = ~sda_padoen_o ? sda_pad_o : 1'bz;
assign scl_pad_i = i2c_scl;
assign i2c_scl = ~scl_padoen_o ? scl_pad_o : 1'bz;

reg i2c_read_req;
wire i2c_read_req_ack;
reg i2c_write_req;
wire i2c_write_req_ack;
wire[7:0] i2c_slave_dev_addr;
wire[15:0] i2c_slave_reg_addr;
wire[7:0] i2c_write_data;
wire[7:0] i2c_read_data;

wire err;
reg[2:0] state;

localparam S_IDLE                =  0;
localparam S_WR_I2C_CHECK        =  1;
localparam S_WR_I2C              =  2;
localparam S_WR_I2C_DONE         =  3;


assign done = (state == S_WR_I2C_DONE);
assign i2c_slave_dev_addr  = lut_dev_addr;
assign i2c_slave_reg_addr = lut_reg_addr;
assign i2c_write_data  = lut_reg_data;


always@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		state <= S_IDLE;
		error <= 1'b0;
		lut_index <= 8'd0;
	end
	else 
		case(state)
			S_IDLE:
			begin
				state <= S_WR_I2C_CHECK;
				error <= 1'b0;
				lut_index <= 8'd0;
			end
			S_WR_I2C_CHECK:
			begin
				if(i2c_slave_dev_addr != 8'hff)
				begin
					i2c_write_req <= 1'b1;
					state <= S_WR_I2C;
				end
				else
				begin
					state <= S_WR_I2C_DONE;
				end
			end
			S_WR_I2C:
			begin
				if(i2c_write_req_ack)
				begin
					error <= err ? 1'b1 : error; 
					lut_index <= lut_index + 8'd1;
					i2c_write_req <= 1'b0;
					state <= S_WR_I2C_CHECK;
				end
			end
			S_WR_I2C_DONE:
			begin
				state <= S_WR_I2C_DONE;
			end
			default:
				state <= S_IDLE;
		endcase
end



i2c_master_top i2c_master_top_m0
(
	.rst(rst),
	.clk(clk),
	.clk_div_cnt(clk_div_cnt),
	
	// I2C signals
	// i2c clock line
	.scl_pad_i(scl_pad_i),       // SCL-line input
	.scl_pad_o(scl_pad_o),       // SCL-line output (always 1'b0)
	.scl_padoen_o(scl_padoen_o),    // SCL-line output enable (active low)

	// i2c data line
	.sda_pad_i(sda_pad_i),       // SDA-line input
	.sda_pad_o(sda_pad_o),       // SDA-line output (always 1'b0)
	.sda_padoen_o(sda_padoen_o),    // SDA-line output enable (active low)
	
	.i2c_read_req(i2c_read_req),
	.i2c_addr_2byte(i2c_addr_2byte),
	.i2c_read_req_ack(i2c_read_req_ack),
	.i2c_write_req(i2c_write_req),
	.i2c_write_req_ack(i2c_write_req_ack),
	.i2c_slave_dev_addr(i2c_slave_dev_addr),
	.i2c_slave_reg_addr(i2c_slave_reg_addr),
	.i2c_write_data(i2c_write_data),
	.i2c_read_data(i2c_read_data),
	.error(err)
);
endmodule