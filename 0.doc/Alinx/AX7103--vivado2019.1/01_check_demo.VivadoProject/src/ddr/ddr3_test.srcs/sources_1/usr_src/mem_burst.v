module mem_burst
#(
parameter                                 MEM_DATA_BITS     =   64,
parameter                                 ADDR_BITS         =   24
)
(
input                                       rst,                            //reset
input                                       mem_clk,                        //clock
input                                       rd_burst_req,                   //read burst request
input                                       wr_burst_req,                   //write burst request
input[9:0]                                  rd_burst_len,                   //read burst length
input[9:0]                                  wr_burst_len,                   //write burst length
input[ADDR_BITS - 1:0]                      rd_burst_addr,                  //read burst address
input[ADDR_BITS - 1:0]                      wr_burst_addr,                  //write burst address
output                                      rd_burst_data_valid,            //read burst data valid
output                                      wr_burst_data_req,              // write burst data request
output[MEM_DATA_BITS - 1:0]                 rd_burst_data,                  //read burst data
input[MEM_DATA_BITS - 1:0]                  wr_burst_data,                  //write burst data
output                                      rd_burst_finish,                // read burst finish flag
output                                      wr_burst_finish,                // write burst finish flag
output                                      burst_finish,                   // write burst finish flag
/*************************************************************************
// xilinx MIG IP application interface ports
****************************************************************************/
output[ADDR_BITS-1:0]                       app_addr,
output[2:0]                                 app_cmd,
output                                      app_en,
output [MEM_DATA_BITS-1:0]                  app_wdf_data,
output                                      app_wdf_end,
output [MEM_DATA_BITS/8-1:0]                app_wdf_mask,
output                                      app_wdf_wren,
input [MEM_DATA_BITS-1:0]                   app_rd_data,
input                                       app_rd_data_end,
input                                       app_rd_data_valid,
input                                       app_rdy,
input                                       app_wdf_rdy,
input                                       ui_clk_sync_rst,  
input                                       init_calib_complete
);
assign app_wdf_mask = {MEM_DATA_BITS/8{1'b0}};
/*************************************************************************
Define the state of the state machine
****************************************************************************/
localparam      IDLE                    =   3'd0;
localparam      MEM_READ                =   3'd1;
localparam      MEM_READ_WAIT           =   3'd2;
localparam      MEM_WRITE               =   3'd3;
localparam      MEM_WRITE_WAIT          =   3'd4;
localparam      READ_END                =   3'd5;
localparam      WRITE_END               =   3'd6;
localparam      MEM_WRITE_FIRST_READ    =   3'd7;

reg[2:0]                                    state;	
reg[9:0]                                    rd_addr_cnt;                    //read address count
reg[9:0]                                    rd_data_cnt;                    //read data count
reg[9:0]                                    wr_addr_cnt;                    //write address count
reg[9:0]                                    wr_data_cnt;                    //write data count

reg[2:0]                                    app_cmd_r;
reg[ADDR_BITS-1:0]                          app_addr_r;
reg                                         app_en_r;
reg                                         app_wdf_end_r;
reg                                         app_wdf_wren_r;
assign app_cmd = app_cmd_r;
assign app_addr = app_addr_r;
assign app_en = app_en_r;
assign app_wdf_end = app_wdf_end_r;
assign app_wdf_data = wr_burst_data;
assign app_wdf_wren = app_wdf_wren_r & app_wdf_rdy;
assign rd_burst_finish = (state == READ_END);
assign wr_burst_finish = (state == WRITE_END);
assign burst_finish = rd_burst_finish | wr_burst_finish;

assign rd_burst_data = app_rd_data;
assign rd_burst_data_valid = app_rd_data_valid;

assign wr_burst_data_req = (state == MEM_WRITE) & app_wdf_rdy ;

always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		app_wdf_wren_r <= 1'b0;
	end
	else if(app_wdf_rdy)
		app_wdf_wren_r <= wr_burst_data_req;
end
/*************************************************************************
Generate read and write burst state machine
****************************************************************************/
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		state <= IDLE;
		app_cmd_r <= 3'b000;
		app_addr_r <= 0;
		app_en_r <= 1'b0;
		rd_addr_cnt <= 0;
		rd_data_cnt <= 0;
		wr_addr_cnt <= 0;
		wr_data_cnt <= 0;
		app_wdf_end_r <= 1'b0;
	end
	else if(init_calib_complete ===  1'b1)//Jump to read and write state machine when ddr initialization completed
	begin
		case(state)
			IDLE:
			begin
				if(rd_burst_req)//jump to MEM_READ state when rd_burst_req is high
				begin
					state <= MEM_READ;
					app_cmd_r <= 3'b001;
					app_addr_r <= {rd_burst_addr,3'd0};
					app_en_r <= 1'b1;
				end
				else if(wr_burst_req)//jump to MEM_WRITE state when wr_burst_req is high
				begin
					state <= MEM_WRITE;
					app_cmd_r <= 3'b000;
					app_addr_r <= {wr_burst_addr,3'd0};
					app_en_r <= 1'b1;
					wr_addr_cnt <= 0;
					app_wdf_end_r <= 1'b1;
					wr_data_cnt <= 0;
				end
			end
			MEM_READ:
			begin
				if(app_rdy)
				begin
					app_addr_r <= app_addr_r + 8;
					if(rd_addr_cnt == rd_burst_len - 1)//wait after reading burst address end
					begin
						state <= MEM_READ_WAIT;
						rd_addr_cnt <= 0;
						app_en_r <= 1'b0;
					end
					else
						rd_addr_cnt <= rd_addr_cnt + 1;//read address count
				end
				
				if(app_rd_data_valid)
				begin
					if(rd_data_cnt == rd_burst_len - 1)
					begin
						rd_data_cnt <= 0;
						state <= READ_END;
					end
					else
					begin
						rd_data_cnt <= rd_data_cnt + 1;//read data count
					end
				end
			end
			MEM_READ_WAIT:
			begin
				if(app_rd_data_valid)
				begin
					if(rd_data_cnt == rd_burst_len - 1)//jump to READ_END state 
					begin
						rd_data_cnt <= 0;
						state <= READ_END;
					end
					else
					begin
						rd_data_cnt <= rd_data_cnt + 1;//data count
					end
				end
			end
			MEM_WRITE_FIRST_READ:
			begin
				app_en_r <= 1'b1;
				state <= MEM_WRITE;
				wr_addr_cnt <= 0;
			end
			MEM_WRITE:
			begin
				if(app_rdy)
				begin
					app_addr_r <= app_addr_r + 'b1000;
					if(wr_addr_cnt == wr_burst_len - 1)// write burst address end
					begin
						app_wdf_end_r <= 1'b0;
						app_en_r <= 1'b0;
					end
					else
					begin
						wr_addr_cnt <= wr_addr_cnt + 1;//write address count
					end
				end
					
				if(wr_burst_data_req)
				begin
					
					if(wr_data_cnt == wr_burst_len - 1)
					begin
						state <= MEM_WRITE_WAIT;
					end
					else
					begin
						wr_data_cnt <= wr_data_cnt + 1;//write data count
					end
				end
				
			end
			READ_END:
				state <= IDLE;
			MEM_WRITE_WAIT:
			begin
				if(app_rdy)
				begin
					app_addr_r <= app_addr_r + 'b1000;
					if(wr_addr_cnt == wr_burst_len - 1)//wait after writing burst address end
					begin
						app_wdf_end_r <= 1'b0;
						app_en_r <= 1'b0;
						if(app_wdf_rdy) 
							state <= WRITE_END;
					end
					else
					begin
						wr_addr_cnt <= wr_addr_cnt + 1;
					end
				end
				else if(~app_en_r & app_wdf_rdy)
					state <= WRITE_END;				
			end
			WRITE_END:
				state <= IDLE;
			default:
				state <= IDLE;
		endcase
	end
end
endmodule 