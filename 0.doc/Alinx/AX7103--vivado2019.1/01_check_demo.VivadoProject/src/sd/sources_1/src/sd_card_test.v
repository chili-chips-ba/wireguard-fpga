//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
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
//  2019/08/29     lhj         1.0         Original
//*******************************************************************************/
module sd_card_test
(
input            sys_clk,   //system clock positive
input            clk_50Mhz,
input            rst_n,       //reset ,low active
input            key,         //user key on board
output           sd_ncs,      //chip select
output           sd_dclk,     //sd card clock
output           sd_mosi,     //sd card CMD
input            sd_miso     //sd card  data

);
parameter S_IDLE         = 0;
parameter S_READ         = 1;
parameter S_WRITE        = 2;
parameter S_END          = 3;

reg[3:0]         state;
wire             sd_init_done;           //initialization flag  high level is done
reg              sd_sec_read;            //read sd sector flag
wire[31:0]       sd_sec_read_addr;       //read sd sector address
wire[7:0]        sd_sec_read_data;       //read sd sector data
wire             sd_sec_read_data_valid; // read data is valid
wire             sd_sec_read_end;        //Read data end mark
reg              sd_sec_write;           //write sd sector flag
wire[31:0]       sd_sec_write_addr;      //write sd sector address
reg [7:0]        sd_sec_write_data;      //write sd sector data
wire             sd_sec_write_data_req;  //write sd sector requet
wire             sd_sec_write_end;       //write data end mark
reg[9:0]         wr_cnt;
reg[9:0]         rd_cnt;
wire             button_negedge;
reg[7:0]         read_data;


assign  sd_sec_read_addr = 32'd0;
assign  sd_sec_write_addr = 32'd0;


/*************************************************************************
generate single end clock
**************************************************************************/

/*************************************************************************
generate the clock for sdcard reading and writing
**************************************************************************/

/*************************************************************************
Only one pulse is generated when a key is pressed to meet requirements
****************************************************************************/
ax_debounce
#(
.FREQ            (50            )
) ax_debounce_m0
(
.clk             (clk_50Mhz     ),
.rst             (~rst_n        ),
.button_in       (key           ),
.button_posedge  (              ),
.button_negedge  (button_negedge),
.button_out      (              )
);
/*************************************************************************
Generate write SD data
****************************************************************************/
always@(posedge clk_50Mhz or negedge rst_n)
begin
	if(rst_n == 1'b0)
		wr_cnt <= 10'd0;
	else if(state == S_WRITE)
	begin
		if(sd_sec_write_data_req == 1'b1)
			wr_cnt <= wr_cnt + 10'd1;
	end
	else
		wr_cnt <= 10'd0;
end

always@(posedge clk_50Mhz or negedge rst_n)
begin
	if(rst_n == 1'b0)
		rd_cnt <= 10'd0;
	else if(state == S_READ)
	begin
		if(sd_sec_read_data_valid == 1'b1)
			rd_cnt <= rd_cnt + 10'd1; //read data count
	end
	else
		rd_cnt <= 10'd0;
end
/*************************************************************************
get read data
****************************************************************************/
always@(posedge clk_50Mhz or negedge rst_n)
begin
	if(rst_n == 1'b0)
		read_data <= 8'd0;
	else if(state == S_READ)
	begin
		if(sd_sec_read_data_valid == 1'b1 && rd_cnt == 10'd0)
			read_data <= sd_sec_read_data;
	end
	else if(state == S_END && button_negedge == 1'b1)
		read_data <= read_data + 8'd1;
end
/*************************************************************************
Generating write sd card data 
****************************************************************************/ 
always@(posedge clk_50Mhz or negedge rst_n)
begin
	if(rst_n == 1'b0)
		sd_sec_write_data <= 8'd0;
	else if(sd_sec_write_data_req)
		sd_sec_write_data <= read_data + wr_cnt[7:0];
end
/*************************************************************************
Generating Write and read State Machine of sd card
****************************************************************************/ 
always@(posedge clk_50Mhz or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		state <= S_IDLE;
		sd_sec_read <= 1'b0;
		sd_sec_write <= 1'b0;
	end
	else if(sd_init_done == 1'b0)//initialization
	begin
		state <= S_IDLE;
	end
	else
		case(state)
			S_IDLE:
			begin
				state <= S_READ;
			end
			S_WRITE:
			begin
				if(sd_sec_write_end == 1'b1)//SD card write over
				begin
					sd_sec_write <= 1'b0;
					state <= S_READ;
				end
				else
					sd_sec_write <= 1'b1;
			end
			
			S_READ:
			begin
				if(sd_sec_read_end == 1'b1)//SD card read over
				begin
					state <= S_END;
					sd_sec_read <= 1'b0;
				end
				else
				begin
					sd_sec_read <= 1'b1;
				end                 
			end         
			S_END:
			begin
				if(button_negedge == 1'b1)//Detection key press
					state <= S_WRITE;
			end
			default:
				state <= S_IDLE;
		endcase
end
/*************************************************************************
Calling SD card module for reading and Writing data 
****************************************************************************/
sd_card_top  sd_card_top_m0(
.clk                       (clk_50Mhz              ),
.rst                       (~rst_n                 ),
.SD_nCS                    (sd_ncs                 ),
.SD_DCLK                   (sd_dclk                ),
.SD_MOSI                   (sd_mosi                ),
.SD_MISO                   (sd_miso                ),
.sd_init_done              (sd_init_done           ),
.sd_sec_read               (sd_sec_read            ),
.sd_sec_read_addr          (sd_sec_read_addr       ),
.sd_sec_read_data          (sd_sec_read_data       ),
.sd_sec_read_data_valid    (sd_sec_read_data_valid ),
.sd_sec_read_end           (sd_sec_read_end        ),
.sd_sec_write              (sd_sec_write           ),
.sd_sec_write_addr         (sd_sec_write_addr      ),
.sd_sec_write_data         (sd_sec_write_data      ),
.sd_sec_write_data_req     (sd_sec_write_data_req  ),
.sd_sec_write_end          (sd_sec_write_end       )
);
/*************************************************************************
Analyze data from user defined ports for the xilinx ila module
****************************************************************************/
ila_1 ila_m1(
.clk                       (sys_clk                ), // input wire clk
.probe0                    (sd_sec_read_data_valid ), // input wire [0:0]  probe0  
.probe1                    (sd_sec_read_data       ), // input wire [7:0]  probe1 
.probe2                    (sd_sec_write_data_req  ), // input wire [0:0]  probe2 
.probe3                    (sd_sec_write_data      ) // input wire [7:0]  probe3
);
endmodule 