`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module gmii_tx_buffer
(
 input              clk,
 input              rst_n, 
 input              eth_10_100m_en,      //ethernet 10M/100M enable
 input              link,                //ethernet link signal
 input              gmii_tx_en,          //gmii tx enable
 input  [7:0]       gmii_txd,            //gmii txd
 output reg         e10_100_tx_en,       //ethernet 10/100M tx enable
 output reg [7:0]   e10_100_txd          //ethernet 10/100M txd

 
);

reg  [7:0]            tx_wdata    ;      //tx data fifo write data
reg                   tx_wren     ;      //tx data fifo write enable
reg                   tx_rden     ;      //tx data fifo read enable
reg  [15:0]           tx_data_cnt ;      //tx data counter
wire [7:0]            tx_rdata    ;      //tx fifo read data
                      
                                  
reg  [16:0]           pack_len    ;      //package length
reg                   tx_en       ;      //tx enable
reg  [3:0]            txd_high    ;      //high 4 bits
reg  [3:0]            txd_low     ;      //low 4 bits
                                  
reg                   tx_en_d0    ; 
reg                   tx_en_d1    ;
                      
reg   [15:0]          tx_len_cnt    ;    //tx length counter
reg                   gmii_tx_en_d0 ;                          
reg   [1:0]           len_cnt       ;    //length latch counter
wire  [4:0]           pack_num      ;    //length fifo usedw
reg                   tx_len_wren   ;    //length fifo wren
reg                   tx_len_rden   ;    //length fifo rden
wire  [15:0]          tx_len_wdata  ;    //length fifo write data
wire  [15:0]          tx_len        ;    //length fifo read data



localparam IDLE            = 4'd0 ;
localparam CHECK_FIFO      = 4'd1 ;
localparam LEN_LATCH       = 4'd2 ;
localparam SEND_WAIT       = 4'd3 ;
localparam SEND            = 4'd4 ;
localparam SEND_WAIT_1     = 4'd5 ;
localparam SEND_END        = 4'd6 ;


reg [3:0]    state  ;
reg [3:0]    next_state ;

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      state  <=  IDLE  ;
    else
      state  <= next_state ;  
  end


  
always @(*)
  begin
    case(state)
	IDLE  :        
	  begin
		  next_state <= CHECK_FIFO ;
	  end
	CHECK_FIFO :   
      begin
	    if (pack_num > 5'd0)                  //check length fifo, if usedw > 0 ,there is a package in data fifo
		  next_state <= LEN_LATCH ;
		else 
		  next_state <= CHECK_FIFO ;		 
		end	
	LEN_LATCH:     
	  begin
	    if (len_cnt == 2'd3)                  //wait for read length fifo data
		  next_state <= SEND_WAIT ;
		else 
		  next_state <= LEN_LATCH ;
	  end
	SEND_WAIT :    
	  next_state <= SEND ;
	SEND :         
      begin
	    if (tx_data_cnt == pack_len - 1)      //read data fifo and send out
		  next_state <= SEND_WAIT_1 ;
		else 
		  next_state <= SEND ;
		end	
	SEND_WAIT_1 :   
      begin
	    if (tx_data_cnt == pack_len + 1)      //wait some clock for data latch
		  next_state <= SEND_END ;
		else 
		  next_state <= SEND_WAIT_1 ;
		end	
	SEND_END :    
	      next_state <= IDLE ;
    default :
	   next_state <= IDLE ;
	endcase
  end  
/*************************************************
write length to tx_len_fifo
*************************************************/
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  gmii_tx_en_d0 <= 1'b0 ;
	else
	  gmii_tx_en_d0 <=  gmii_tx_en  ;
end
//write tx length to fifo when gmii_tx_en negedge
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  tx_len_wren <=  1'b0 ;
	else if (gmii_tx_en == 1'b0 && gmii_tx_en_d0 == 1'b1)
	  tx_len_wren <=  eth_10_100m_en  ;
	else 
	  tx_len_wren <=  1'b0 ;
end
//calculate tx length  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  tx_len_cnt <= 16'd0 ;
	else if (gmii_tx_en)
	  tx_len_cnt <=  tx_len_cnt + 1'b1  ;
	else if (tx_len_wren)
	  tx_len_cnt <= 16'd0 ;
end

assign tx_len_wdata = tx_len_cnt ;     //write length data 

/*************************************************
read length from tx_len_fifo
*************************************************/
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  tx_len_rden <=  1'b0 ;
	else if (state == LEN_LATCH && len_cnt == 2'd0)
	  tx_len_rden <=  eth_10_100m_en  ;
	else 
	  tx_len_rden <=  1'b0 ;
end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  len_cnt <=  2'd0 ;
	else if (state == LEN_LATCH)
	  len_cnt <=  len_cnt + 1'b1 ;
	else 
	  len_cnt <=  2'd0 ;
end
//package total length  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  pack_len <= 17'd0 ;
	else if (state == SEND_WAIT)
	  pack_len <= 2*(tx_len) ;
end
//write data to tx_fifo
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	begin
	  tx_wren   <= 1'b0 ;
	  tx_wdata  <= 8'd0 ;
	end
	else
	begin
	  tx_wren   <= gmii_tx_en & eth_10_100m_en ;
	  tx_wdata  <= gmii_txd ;
	end
  end  

/*************************************************
read tx_fifo
*************************************************/	
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  tx_data_cnt   <= 16'd0  ;
	else if (state == SEND || state == SEND_WAIT_1)
	  tx_data_cnt   <= tx_data_cnt + 1'b1 ;
	else 
	  tx_data_cnt   <= 16'd0  ;
  end
//read data enable 
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  tx_rden   <= 1'b0  ;
	else if (state == SEND)
	  tx_rden   <= ~tx_data_cnt[0] & eth_10_100m_en ;
	else 
	  tx_rden   <= 1'b0  ;
  end
//gmii tx enable
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  tx_en   <= 1'b0  ;
	else if (state == SEND)
	  tx_en   <= 1'b1 ;
	else 
	  tx_en   <= 1'b0  ;
  end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	begin
	  tx_en_d0   <= 1'b0  ;
	  tx_en_d1   <= 1'b0  ;
	end
	else
	begin
	  tx_en_d0   <= tx_en ;
	  tx_en_d1   <= tx_en_d0 ;
	end
  end


always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	begin
	  txd_high <= 4'd0 ;
	  txd_low  <= 4'd0 ;
	end
	else
	begin
	  if (tx_data_cnt[0])
	    txd_high   <= tx_rdata[7:4]  ;
	  else 
	    txd_low   <= tx_rdata[3:0]  ;
	end
  end  

//ethernet 10/100M tx enable  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  e10_100_tx_en   <= 1'b0  ;
	else
	  e10_100_tx_en   <= tx_en_d1 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  e10_100_txd   <= 8'd0  ;
	else if (tx_data_cnt[0])
	  e10_100_txd   <= {txd_low[3:0],txd_low[3:0]} ;
	else
	  e10_100_txd   <= {txd_high[3:0],txd_high[3:0]} ;
  end 


 eth_data_fifo tx_fifo 
 (
    .clk        (clk            ),                // input wire clk
    .rst        (~link          ),                // input wire rst
    .din        (tx_wdata       ),                // input wire [7 : 0] din
    .wr_en      (tx_wren        ),            // input wire wr_en
    .rd_en      (tx_rden        ),            // input wire rd_en
    .dout       (tx_rdata       ),              // output wire [7 : 0] dout
    .full       (               ),              // output wire full
    .empty      (               ),            // output wire empty
    .data_count (               )  // output wire [11 : 0] data_count
    );  
 
len_fifo tx_len_fifo
    (	
    .clk        (clk            ),                // input wire clk
    .rst        (~link          ),                // input wire rst
    .din        (tx_len_wdata   ),                // input wire [7 : 0] din
    .wr_en      (tx_len_wren    ),            // input wire wr_en
    .rd_en      (tx_len_rden    ),            // input wire rd_en
    .dout       (tx_len         ),              // output wire [7 : 0] dout
    .full       (               ),              // output wire full
    .empty      (               ),            // output wire empty
    .data_count (pack_num       )  // output wire [11 : 0] data_count
    );  
    
endmodule
