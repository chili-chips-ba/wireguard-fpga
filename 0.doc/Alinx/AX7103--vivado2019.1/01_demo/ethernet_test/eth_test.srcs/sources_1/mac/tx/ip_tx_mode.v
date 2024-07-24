//////////////////////////////////////////////////////////////////////////////////////
//Module Name : ip_tx_mode
//Description : This module is arbitration for ip layer signal, which from udp and icmp
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module ip_tx_mode
       (
         input                    clk ,
         input                    rst_n,
         input                    mac_send_end,
         
         
         input                    udp_tx_req,
         input                    udp_tx_ready ,
         input      [7:0]         udp_tx_data,
         input      [15:0]        udp_send_data_length,
         output reg               udp_tx_ack,
         
         input                    icmp_tx_req,
         input                    icmp_tx_ready,
         input      [7:0]         icmp_tx_data,
         input      [15:0]        icmp_send_data_length,
         output reg               icmp_tx_ack,
         
         input                    ip_tx_ack,
         output reg               ip_tx_req,
         output reg               ip_tx_ready,
         output reg [7:0]         ip_tx_data,
         output reg [7:0]         ip_send_type,
         output reg [15:0]        ip_send_data_length
         
         
       );
       
localparam ip_udp_type  = 8'h11 ;
localparam ip_icmp_type = 8'h01 ;

reg [15:0]    timeout ;

parameter IDLE      = 5'b00001 ;
parameter UDP_WAIT  = 5'b00010 ;
parameter UDP       = 5'b00100 ;
parameter ICMP_WAIT = 5'b01000 ;
parameter ICMP      = 5'b10000 ;


reg [4:0]    state  ;
reg [4:0]    next_state ;

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
      IDLE        :
        begin
          if (udp_tx_req)
            next_state <= UDP_WAIT ;
          else if (icmp_tx_req)
            next_state <= ICMP_WAIT  ;
          else
            next_state <= IDLE ;
        end
      UDP_WAIT    :
        begin
		  if (ip_tx_ack)
		    next_state <= UDP ;
		  else
		    next_state <= UDP_WAIT ;
        end		
      UDP         :
        begin
          if (mac_send_end)
            next_state <= IDLE ;
          else if (timeout == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= UDP ;
        end
	  ICMP_WAIT    :
        begin
		  if (ip_tx_ack)
		    next_state <= ICMP ;
		  else
		    next_state <= ICMP_WAIT ;
        end	
      ICMP        :
        begin
          if (mac_send_end)
            next_state <= IDLE ;
          else if (timeout == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= ICMP ;
        end
      default     :
        next_state <= IDLE ;
    endcase
  end
  
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      timeout <= 16'd0 ;
    else if (state == UDP || state == ICMP)
      timeout <= timeout + 1'b1 ;
    else
      timeout <= 16'd0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ip_send_data_length <= 16'd0 ;
    else if (state == ICMP_WAIT || state == ICMP)
      ip_send_data_length <= icmp_send_data_length ;
    else
      ip_send_data_length <= udp_send_data_length + 28 ;
  end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ip_tx_req  <= 1'b0  ;
    else if (state == UDP_WAIT || state == ICMP_WAIT)
	  ip_tx_req  <= 1'b1  ;
    else 
	  ip_tx_req  <= 1'b0  ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      udp_tx_ack  <= 1'b0  ;
    else if (state == UDP)
	  udp_tx_ack  <= 1'b1  ;
    else 
	  udp_tx_ack  <= 1'b0  ;
  end

 
 always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_tx_ack  <= 1'b0  ;
    else if (state == ICMP)
	  icmp_tx_ack  <= 1'b1  ;
    else 
	  icmp_tx_ack  <= 1'b0  ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      begin
        ip_tx_ready       <= 1'b0 ;
        ip_tx_data        <= 8'h00 ;
        ip_send_type      <= ip_udp_type ;
      end
    else if (state == UDP)
      begin
        ip_tx_ready       <= udp_tx_ready ;
        ip_tx_data        <= udp_tx_data ;
        ip_send_type      <= ip_udp_type ;
        
      end
    else if (state == ICMP)
      begin
        ip_tx_ready       <= icmp_tx_ready ;
        ip_tx_data        <= icmp_tx_data ;
        ip_send_type      <= ip_icmp_type ;
        
      end
    else
      begin
        ip_tx_ready       <= 1'b0 ;
        ip_tx_data        <= 8'h00 ;
        ip_send_type      <= ip_udp_type ;
      end
  end
  
  
  
endmodule


