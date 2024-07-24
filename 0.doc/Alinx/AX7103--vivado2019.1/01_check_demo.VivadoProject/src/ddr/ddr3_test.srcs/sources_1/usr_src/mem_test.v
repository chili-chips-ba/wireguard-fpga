module mem_test
#(
parameter                     MEM_DATA_BITS   = 64,
parameter                     ADDR_BITS       = 24
)
(
input                                rst,                   //reset
input                                mem_clk,               //input clock
output reg                          rd_burst_req,           //read burst request
output reg                          wr_burst_req,           //write burst request
output reg[9:0]                     rd_burst_len,           //read burst length
output reg[9:0]                     wr_burst_len,           //write burst length
output reg[ADDR_BITS - 1:0]         rd_burst_addr,          //read burst address
output reg[ADDR_BITS - 1:0]         wr_burst_addr,          //write burst address
input                               rd_burst_data_valid,     //read burst data valid
input                               wr_burst_data_req,       // write burst data request
input[MEM_DATA_BITS - 1:0]          rd_burst_data,           //read burst data
output[MEM_DATA_BITS - 1:0]         wr_burst_data,           //write burst data
input                               rd_burst_finish,         // read burst finish flag
input                               wr_burst_finish,         // write burst finish flag
output reg error
);
localparam                          IDLE        =   3'd0;
localparam                          MEM_READ    =   3'd1;
localparam                          MEM_WRITE   =   3'd2;

reg[2:0]                            state;
reg[7:0]                            wr_cnt;
reg[MEM_DATA_BITS - 1:0]            wr_burst_data_reg;
assign wr_burst_data = wr_burst_data_reg;
reg[7:0]                            rd_cnt;
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
		error <= 1'b0;
	else
		error <= (state == MEM_READ) && rd_burst_data_valid && (rd_burst_data != {(MEM_DATA_BITS/8){rd_cnt}});
end
/*************************************************************************
Generate write burst data  when writing burst data request is valid
****************************************************************************/
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		wr_burst_data_reg <= {MEM_DATA_BITS{1'b0}};
		wr_cnt <= 8'd0;
	end
	else if(state == MEM_WRITE)
	begin
		if(wr_burst_data_req)//Generate write burst data
			begin
				wr_burst_data_reg <= {(MEM_DATA_BITS/8){wr_cnt}};
				wr_cnt <= wr_cnt + 8'd1;
			end
		else if(wr_burst_finish)
			wr_cnt <= 8'd0;
	end
end
/*************************************************************************
reading burst data count when data is valid
****************************************************************************/
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		rd_cnt <= 8'd0;
	end
	else if(state == MEM_READ)
	begin
		if(rd_burst_data_valid)//reading burst data count
			begin
				rd_cnt <= rd_cnt + 8'd1;
			end
		else if(rd_burst_finish)
			rd_cnt <= 8'd0;
	end
	else
		rd_cnt <= 8'd0;
end
/*************************************************************************
Generate a state machine that cyclically reads and writes MIG ip
****************************************************************************/
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		state <= IDLE;
		wr_burst_req <= 1'b0;
		rd_burst_req <= 1'b0;
		rd_burst_len <= 10'd128;
		wr_burst_len <= 10'd128;
		rd_burst_addr <= 0;
		wr_burst_addr <= 0;
	end
	else
	begin
		case(state)
			IDLE:
			begin
				state <= MEM_WRITE;
				wr_burst_req <= 1'b1;
				wr_burst_len <= 10'd128;
			end
			MEM_WRITE:
			begin
				if(wr_burst_finish)//Start jumping to MEM_READ when writing burst finish
				begin
					state <= MEM_READ;
					wr_burst_req <= 1'b0;
					rd_burst_req <= 1'b1;
					rd_burst_len <= 10'd128;
					rd_burst_addr <= wr_burst_addr;
				end
			end
			MEM_READ:
			begin
				if(rd_burst_finish)//Start jumping to  MEM_WRITE when reading burst finish
				begin
					state <= MEM_WRITE;
					wr_burst_req <= 1'b1;
					wr_burst_len <= 10'd128;
					rd_burst_req <= 1'b0;
					wr_burst_addr <= wr_burst_addr + 128;
				end
			end
			default:
				state <= IDLE;
		endcase
	end
end

endmodule