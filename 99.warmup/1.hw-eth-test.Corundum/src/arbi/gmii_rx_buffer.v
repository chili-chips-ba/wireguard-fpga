`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module gmii_rx_buffer
(
 input              clk,
 input              rst_n,
 input              eth_100m_en,   //ethernet 100M enable
 input              eth_10m_en,    //ethernet 100M enable
 input              link,          //ethernet link signal
 input              gmii_rx_dv,    //gmii rx dv
 input  [7:0]       gmii_rxd,      //gmii rxd
 
 output reg         e10_100_rx_dv, //ethernet 10/100 rx_dv
 output    [7:0]    e10_100_rxd    //ethernet 10/100 rxd
 
);


reg  [15:0]           rx_cnt        ;   //write fifo counter
reg                   rx_wren       ;   //write fifo wren
reg  [7:0]            rx_wdata      ;   //write fifo data
reg  [15:0]           rx_data_cnt   ;   //read fifo counter
reg                   rx_rden       ;   //read fifo rden
wire [7:0]            rx_rdata      ;   //read fifo data
reg  [3:0]            rxd_high      ;   //rxd high 4 bit
reg  [3:0]            rxd_low       ;   //rxd low 4 bit
                      
reg                   gmii_rx_dv_d0 ;
reg                   gmii_rx_dv_d1 ;
reg                   gmii_rx_dv_d2 ;
                      
reg  [15:0]           pack_len      ;   //package length                  
reg  [1:0]            len_cnt       ;   //length latch counter
wire [4:0]            pack_num      ;   //length fifo usedw
reg                   rx_len_wren   ;   //length wren
reg  [15:0]           rx_len_wdata  ;   //length write data
reg                   rx_len_rden   ;   //length rden
wire [15:0]           rx_len        ;   //legnth read data


localparam IDLE             = 4'd0 ;
localparam CHECK_FIFO       = 4'd1 ;
localparam LEN_LATCH        = 4'd2 ;
localparam REC_WAIT         = 4'd3 ;
localparam READ_FIFO        = 4'd4 ;
localparam REC_END          = 4'd5 ;

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
	    if (pack_num > 5'd0)                // if length fifo usedw > 0, means there is package in data fifo
		  next_state <= LEN_LATCH ;
		else 
		  next_state <= CHECK_FIFO ;		 
		end	
	LEN_LATCH:
	  begin
	    if (len_cnt == 2'd3)               // delay some clock
		  next_state <= REC_WAIT ;
		else 
		  next_state <= LEN_LATCH ;
	  end
	REC_WAIT :
	    next_state <= READ_FIFO ;	
	READ_FIFO :
      begin
	    if (rx_data_cnt == pack_len - 1)   // when reach package length read end
		  next_state <= REC_END ;
		else 
		  next_state <= READ_FIFO ;
		end	
	REC_END :
	      next_state <= IDLE ;
    default :
	   next_state <= IDLE ;
	endcase
  end  



  
/*************************************************
write length to fifo
*************************************************/
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
    begin
	  gmii_rx_dv_d0  <= 1'b0 ;
	  gmii_rx_dv_d1  <= 1'b0 ;
	  gmii_rx_dv_d2  <= 1'b0 ;
	end
	else
	begin
	  gmii_rx_dv_d0  <= gmii_rx_dv  ;
	  gmii_rx_dv_d1  <= gmii_rx_dv_d0 ;
	  gmii_rx_dv_d2  <= gmii_rx_dv_d1 ;
	end
  end
//write rx length wren to fifo when gmii_rx_dv negedge
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  rx_len_wren <=  1'b0 ;
	else if (gmii_rx_dv == 1'b0 && gmii_rx_dv_d0 == 1'b1)
	  rx_len_wren <=  eth_100m_en | eth_10m_en  ;
	else 
	  rx_len_wren <=  1'b0 ;
end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  rx_cnt   <= 16'd0  ;
	else if (eth_10m_en &  (gmii_rx_dv_d0 | gmii_rx_dv_d1))     //when 10M mode, there is one unnecessary 4 bits data need to be take out
	  rx_cnt   <= rx_cnt + 1'b1 ;
	else if (eth_100m_en & (gmii_rx_dv | gmii_rx_dv_d1))
	  rx_cnt   <= rx_cnt + 1'b1 ;
	else if (state == REC_WAIT)
	  rx_cnt   <= 16'd0  ;
  end
  
//write length to fifo 
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  rx_len_wdata <= 16'd0 ;
	else
	  rx_len_wdata <=  rx_cnt ;
end



/*************************************************
write data to fifo
*************************************************/
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
    begin
	  rxd_high   <= 4'd0 ;
	  rxd_low    <= 4'd0 ;
	end
	else if (gmii_rx_dv | gmii_rx_dv_d1)
	begin
	  if (rx_cnt[0])
	  begin
        rxd_high <= gmii_rxd[3:0] ;	
	  end
      else
	  begin
        rxd_low  <= gmii_rxd[3:0] ;
	  end
    end
    else
    begin
	  rxd_high <= 4'd0 ;
	  rxd_low  <= 4'd0 ;
    end
  end	

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
    begin
	  rx_wren  <= 1'b0 ;	
	  rx_wdata <= 8'd0 ;
	end
	else if (gmii_rx_dv_d1)
	begin
	  if (rx_cnt[0])
	  begin
        rx_wren  <= 1'b0 ;		
	  end
      else
	  begin
		rx_wdata <= {rxd_high,rxd_low} ;
        rx_wren  <= eth_100m_en | eth_10m_en ;		
	  end
    end
    else
    begin
	  rx_wren  <= 1'b0 ;	
	  rx_wdata <= 8'd0 ;
    end
  end  

/*************************************************
read length from fifo
*************************************************/
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  rx_len_rden <=  1'b0 ;
	else if (state == LEN_LATCH && len_cnt == 2'd0)
	  rx_len_rden <=  eth_100m_en | eth_10m_en  ;
	else 
	  rx_len_rden <=  1'b0 ;
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
	  pack_len <= 16'd0 ;
	else if (state == REC_WAIT)
	  pack_len <= rx_len/2 ;
end


/*************************************************
read data from fifo
*************************************************/	


//read data counter  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  rx_data_cnt   <= 16'd0  ;
	else if (state == READ_FIFO)
	  rx_data_cnt   <= rx_data_cnt + 1'b1 ;
	else
	  rx_data_cnt   <= 16'd0  ;
  end


//read enable 
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  rx_rden   <= 1'b0  ;
	else if (state == READ_FIFO)
	  rx_rden   <= eth_100m_en | eth_10m_en  ;
	else 
	  rx_rden   <= 1'b0  ;
  end 

  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  e10_100_rx_dv   <= 1'b0  ;
	else 
	  e10_100_rx_dv   <= rx_rden  ;
  end  

assign e10_100_rxd = rx_rdata ;


 eth_data_fifo rx_fifo 
 (
    .clk        (clk            ),                // input wire clk
    .rst        (~link          ),                // input wire rst
    .din        (rx_wdata       ),                // input wire [7 : 0] din
    .wr_en      (rx_wren        ),            // input wire wr_en
    .rd_en      (rx_rden        ),            // input wire rd_en
    .dout       (rx_rdata       ),              // output wire [7 : 0] dout
    .full       (               ),              // output wire full
    .empty      (               ),            // output wire empty
    .data_count (               )  // output wire [11 : 0] data_count
    );  
 
len_fifo rx_len_fifo
    (	
    .clk        (clk            ),                // input wire clk
    .rst        (~link          ),                // input wire rst
    .din        (rx_len_wdata   ),                // input wire [7 : 0] din
    .wr_en      (rx_len_wren    ),            // input wire wr_en
    .rd_en      (rx_len_rden    ),            // input wire rd_en
    .dout       (rx_len         ),              // output wire [7 : 0] dout
    .full       (               ),              // output wire full
    .empty      (               ),            // output wire empty
    .data_count (pack_num       )  // output wire [11 : 0] data_count
    );  
endmodule
