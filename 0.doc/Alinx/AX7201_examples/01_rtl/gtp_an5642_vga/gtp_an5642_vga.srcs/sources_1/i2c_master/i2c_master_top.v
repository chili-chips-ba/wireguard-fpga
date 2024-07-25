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

module i2c_master_top
(
	input rst,
	input clk,
	input[15:0] clk_div_cnt,
	
	// I2C signals
	// i2c clock line
	input  scl_pad_i,                           // SCL-line input
	output scl_pad_o,                           // SCL-line output (always 1'b0)
	output scl_padoen_o,                        // SCL-line output enable (active low)
	// i2c data line                            
	input  sda_pad_i,                           // SDA-line input
	output sda_pad_o,                           // SDA-line output (always 1'b0)
	output sda_padoen_o,                        // SDA-line output enable (active low)
	input i2c_addr_2byte,                       // Is the register address 16bit?
	input i2c_read_req,                         // Read register request
	output i2c_read_req_ack,                    // Read register request response
	input i2c_write_req,                        // Write register request
	output i2c_write_req_ack,                   // Write register request response
	input[7:0] i2c_slave_dev_addr,              // I2c device address
	input[15:0] i2c_slave_reg_addr,             // I2c register address
	input[7:0] i2c_write_data,                  // I2c write register data
	output reg[7:0] i2c_read_data,              // I2c read register data
	output reg error                            // The error indication, generally there is no response
);
//State machine definition
localparam S_IDLE             =  0;             // Idle state, waiting for read and write
localparam S_WR_DEV_ADDR      =  1;             // Write device address
localparam S_WR_REG_ADDR      =  2;             // Write register address 
localparam S_WR_DATA          =  3;             // Write register data
localparam S_WR_ACK           =  4;             // Write request response
localparam S_WR_ERR_NACK      =  5;             // Write error, I2C device is not responding
localparam S_RD_DEV_ADDR0     =  6;             // I2C read state, first writes the device address and the register address
localparam S_RD_REG_ADDR      =  7;             // I2C read state, read register address (8bit)
localparam S_RD_DEV_ADDR1     =  8;             // Write the device address again
localparam S_RD_DATA          =  9;             // Read data
localparam S_RD_STOP          = 10;  
localparam S_WR_STOP          = 11; 
localparam S_WAIT             = 12; 
localparam S_WR_REG_ADDR1     = 13; 
localparam S_RD_REG_ADDR1     = 14; 
localparam S_RD_ACK           = 15; 
reg start;
reg stop;
reg read;
reg write;
reg ack_in;
reg[7:0] txr;
wire[7:0] rxr;
wire i2c_busy;
wire i2c_al;
wire done;
wire irxack;
reg[3:0] state, next_state;
assign i2c_read_req_ack = (state == S_RD_ACK);
assign i2c_write_req_ack = (state == S_WR_ACK);
always@(posedge clk or posedge rst)
begin
	if(rst)
		state <= S_IDLE;
	else
		state <= next_state;    
end
always@(*)
begin
	case(state)
		S_IDLE:
			//Waiting for read and write requests
			if(i2c_write_req)
				next_state <= S_WR_DEV_ADDR;
			else if(i2c_read_req)
				next_state <= S_RD_DEV_ADDR0;
			else
				next_state <= S_IDLE;
		//Write I2C device address
		S_WR_DEV_ADDR:
			if(done && irxack)
				next_state <= S_WR_ERR_NACK;
			else if(done)
				next_state <= S_WR_REG_ADDR;
			else
				next_state <= S_WR_DEV_ADDR;
		//Write the address of the I2C register
		S_WR_REG_ADDR:
			if(done)
				//If it is the 8bit register address, it enters the write data state
				next_state <= i2c_addr_2byte ? S_WR_REG_ADDR1 : S_WR_DATA;
			else
				next_state <= S_WR_REG_ADDR;
		S_WR_REG_ADDR1:
			if(done)
				next_state <= S_WR_DATA;
			else
				next_state <= S_WR_REG_ADDR1; 
		//Write data		
		S_WR_DATA:
			if(done)
				next_state <= S_WR_STOP;
			else
				next_state <= S_WR_DATA;
		S_WR_ERR_NACK:
			next_state <= S_WR_STOP;
		S_RD_ACK,S_WR_ACK:
			next_state <= S_WAIT;
		S_WAIT:
			next_state <= S_IDLE;
		S_RD_DEV_ADDR0:
			if(done && irxack)
				next_state <= S_WR_ERR_NACK;
			else if(done)
				next_state <= S_RD_REG_ADDR;
			else
				next_state <= S_RD_DEV_ADDR0;
		S_RD_REG_ADDR:
			if(done)
				next_state <= i2c_addr_2byte ? S_RD_REG_ADDR1 : S_RD_DEV_ADDR1;
			else
				next_state <= S_RD_REG_ADDR;
		S_RD_REG_ADDR1:
			if(done)
				next_state <= S_RD_DEV_ADDR1;
			else
				next_state <= S_RD_REG_ADDR1;               
		S_RD_DEV_ADDR1:
			if(done)
				next_state <= S_RD_DATA;
			else
				next_state <= S_RD_DEV_ADDR1;   
		S_RD_DATA:
			if(done)
				next_state <= S_RD_STOP;
			else
				next_state <= S_RD_DATA;
		S_RD_STOP:
			if(done)
				next_state <= S_RD_ACK;
			else
				next_state <= S_RD_STOP;
		S_WR_STOP:
			if(done)
				next_state <= S_WR_ACK;
			else
				next_state <= S_WR_STOP;                
		default:
			next_state <= S_IDLE;
	endcase
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		error <= 1'b0;
	else if(state == S_IDLE)
		error <= 1'b0;
	else if(state == S_WR_ERR_NACK)
		error <= 1'b1;
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		start <= 1'b0;
	else if(done)
		start <= 1'b0;
	else if(state == S_WR_DEV_ADDR || state == S_RD_DEV_ADDR0 || state == S_RD_DEV_ADDR1)
		start <= 1'b1;
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		stop <= 1'b0;
	else if(done)
		stop <= 1'b0;
	else if(state == S_WR_STOP || state == S_RD_STOP)
		stop <= 1'b1;
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		ack_in <= 1'b0;
	else 
		ack_in <= 1'b1;
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		write <= 1'b0;
	else if(done)
		write <= 1'b0;
	else if(state == S_WR_DEV_ADDR || state == S_WR_REG_ADDR || state == S_WR_REG_ADDR1|| state == S_WR_DATA || state == S_RD_DEV_ADDR0 || state == S_RD_DEV_ADDR1 || state == S_RD_REG_ADDR || state == S_RD_REG_ADDR1)
		write <= 1'b1;
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		read <= 1'b0;
	else if(done)
		read <= 1'b0;
	else if(state == S_RD_DATA)
		read <= 1'b1;
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		i2c_read_data <= 8'h00;
	else if(state == S_RD_DATA && done)
		i2c_read_data <= rxr;
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		txr <= 8'd0;
	else 
		case(state)
			S_WR_DEV_ADDR,S_RD_DEV_ADDR0:
				txr <= {i2c_slave_dev_addr[7:1],1'b0};
			S_RD_DEV_ADDR1:
				txr <= {i2c_slave_dev_addr[7:1],1'b1};
			S_WR_REG_ADDR,S_RD_REG_ADDR:
				txr <= (i2c_addr_2byte == 1'b1) ? i2c_slave_reg_addr[15:8] : i2c_slave_reg_addr[7:0];
			S_WR_REG_ADDR1,S_RD_REG_ADDR1:
				txr <= i2c_slave_reg_addr[7:0];             
			S_WR_DATA:
				txr <= i2c_write_data;
			default:
				txr <= 8'hff;
		endcase
end
i2c_master_byte_ctrl byte_controller (
	.clk      ( clk          ),
	.rst      ( rst          ),
	.nReset   ( 1'b1         ),
	.ena      ( 1'b1         ),
	.clk_cnt  ( clk_div_cnt  ),
	.start    ( start        ),
	.stop     ( stop         ),
	.read     ( read         ),
	.write    ( write        ),
	.ack_in   ( ack_in       ),
	.din      ( txr          ),
	.cmd_ack  ( done         ),
	.ack_out  ( irxack       ),
	.dout     ( rxr          ),
	.i2c_busy ( i2c_busy     ),
	.i2c_al   ( i2c_al       ),
	.scl_i    ( scl_pad_i    ),
	.scl_o    ( scl_pad_o    ),
	.scl_oen  ( scl_padoen_o ),
	.sda_i    ( sda_pad_i    ),
	.sda_o    ( sda_pad_o    ),
	.sda_oen  ( sda_padoen_o )
);
endmodule 