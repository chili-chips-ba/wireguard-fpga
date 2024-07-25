//////////////////////////////////////////////////////////////////////////////////////
//Module Name : dhcp_tx
//Description : This module is used to send UDP data and generate UDP checksum
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module dhcp_tx
       (
         input                    clk,
         input                    rst_n,   
         input      [47:0]        source_mac_addr,
		 
         output reg [15:0]        dhcp_len,         
         output reg               dhcp_wr,
		 output reg [7:0]         dhcp_tx_data ,
		 input                    dhcp_tx_req,
		 input                    udp_tx_ack,
		 input                    udp_ram_data_req,
         
       ) ;
       
reg [7:0]                 dhcp_send_cnt ;
reg                       mac_send_end_d0 ;
reg [31:0]                xid    ;
reg [31:0]                Ciaddr ;
reg [31:0]                Yiaddr ;
reg [31:0]                Siaddr ;
reg [31:0]                Giaddr ;
reg [15:0]                flags  ;

localparam DHCP_LEN = 16'd236 ; 
localparam DHCP_OP  = 8'd1 ;   //operation code 1: request 2: reply
localparam HTYPE    = 8'd1 ;   //mac type 1: ethernet
localparam HLEN     = 8'd6 ;   //mac byte length
localparam HOPS     = 8'd0 ;   //router number
localparam SECS     = 16'd0 ;   //request time
localparam BRO_FLAGS = 16'h8000 ;   //broadcast
localparam SIG_FLAGS = 16'h0000 ;   //single 


parameter IDLE              = 9'b00000_0001 ;
parameter START             = 9'b00000_0010 ;
parameter DHCP_DISCOVER     = 9'b00000_0100 ;
parameter DHCP_DIS_WAIT     = 9'b00000_1000 ;
parameter DHCP_RELEASE      = 9'b00001_0000 ;
parameter DHCP_DECLINE      = 9'b00010_0000 ;
parameter DHCP_END          = 9'b01000_0000 ;



reg [8:0]    state  ;
reg [8:0]    next_state ;


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
      IDLE            :
        begin
          if (dhcp_tx_req)
            next_state <= START ;
          else
            next_state <= IDLE ;
        end		
      START            :
        begin
          if (udp_tx_ack)
            next_state <= DHCP_DIS_WAIT ;
          else
            next_state <= START ;
        end  
	  DHCP_DIS_WAIT   :
	    begin
          if (udp_ram_data_req)
            next_state <= DHCP_DISCOVER ;
          else
            next_state <= DHCP_DIS_WAIT ;
        end  
      DHCP_DISCOVER            :
        begin
          if (dhcp_tx_cnt == DHCP_LEN - 1)
            next_state <= DHCP_END ;
          else
            next_state <= DHCP_DISCOVER ;
        end 
	  DHCP_END       :
        begin
          if (mac_send_end_d0)
            next_state <= IDLE ;
          else
            next_state <= DHCP_END ;
        end
      default        :
        next_state <= IDLE ;
    endcase
  end
 
 
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      mac_send_end_d0 <= 1'b0 ;
    else 
      mac_send_end_d0 <= mac_send_end ;
  end  
 
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      dhcp_len <= 16'd0 ;
    else 
      dhcp_len <= DHCP_LEN ;
  end 
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      dhcp_tx_cnt <= 8'd0 ;
    else if (state == DHCP_DISCOVER)
      dhcp_tx_cnt <= dhcp_tx_cnt + 1'b1 ;
	else
	  dhcp_tx_cnt <= 8'd0 ;
  end

always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
     dhcp_wr <= 1'b0 ;
   else if (state == DHCP_DISCOVER)
     dhcp_wr <= 1'b1 ;
   else
	 dhcp_wr <= 1'b0 ;
end 

always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
     xid <= 32'd0 ;
   else if (state == DHCP_DISCOVER)
     xid <= 32'he6a9712c ;
   else
	 xid <= 32'd0 ;
end 

always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
     flags <= 16'd0 ;
   else if (state == DHCP_DISCOVER)
     flags <= BRO_FLAGS ;
   else
	 flags <= 16'd0 ;
end 

always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
     Ciaddr <= 32'd0 ;
   else if (state == DHCP_DISCOVER)
     Ciaddr <= 32'd0 ;
   else
	 Ciaddr <= 32'd0 ;
end 

// always @(posedge clk or negedge rst_n)
// begin
   // if (~rst_n)
     // Yiaddr <= 32'd0 ;
   // else if (state == DHCP_DISCOVER)
     // Yiaddr <= 32'd0 ;
   // else
	 // Yiaddr <= 32'd0 ;
// end 

// always @(posedge clk or negedge rst_n)
// begin
   // if (~rst_n)
     // Siaddr <= 32'd0 ;
   // else if (state == DHCP_DISCOVER)
     // Siaddr <= 32'd0 ;
   // else
	 // Siaddr <= 32'd0 ;
// end 

// always @(posedge clk or negedge rst_n)
// begin
   // if (~rst_n)
     // Giaddr <= 32'd0 ;
   // else if (state == DHCP_DISCOVER)
     // Giaddr <= 32'd0 ;
   // else
	 // Giaddr <= 32'd0 ;
// end 
//*****************************************************************************************//
//send DHCP data
//*****************************************************************************************//
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      dhcp_tx_data <= 8'h00  ;
    else if (state == DHCP_DISCOVER)
      begin
        case(dhcp_send_cnt)
          16'd0    :  dhcp_tx_data <= DHCP_OP        ;
          16'd1    :  dhcp_tx_data <= HTYPE          ;
          16'd2    :  dhcp_tx_data <= HLEN           ;
          16'd3    :  dhcp_tx_data <= HOPS           ;
          16'd4    :  dhcp_tx_data <= xid[31:24]     ;
          16'd5    :  dhcp_tx_data <= xid[23:16]     ;
          16'd6    :  dhcp_tx_data <= xid[15:8]      ;
          16'd7    :  dhcp_tx_data <= xid[7:0]       ;
		  16'd8    :  dhcp_tx_data <= SECS[15:8]     ;
          16'd9    :  dhcp_tx_data <= SECS[7:0]      ;
		  16'd10   :  dhcp_tx_data <= flags[15:8]    ;
          16'd11   :  dhcp_tx_data <= flags[7:0]     ;
		  16'd12   :  dhcp_tx_data <= Ciaddr[31:24]  ;      //DHCP Client ip address
          16'd13   :  dhcp_tx_data <= Ciaddr[23:16]  ;
          16'd14   :  dhcp_tx_data <= Ciaddr[15:8]   ;
          16'd15   :  dhcp_tx_data <= Ciaddr[7:0]    ;
		  // 16'd16   :  dhcp_tx_data <= Yiaddr[31:24]  ;      //DHCP ALLOCATION IP
          // 16'd17   :  dhcp_tx_data <= Yiaddr[23:16]  ;
          // 16'd18   :  dhcp_tx_data <= Yiaddr[15:8]   ;
          // 16'd19   :  dhcp_tx_data <= Yiaddr[7:0]    ;
		  // 16'd20   :  dhcp_tx_data <= Siaddr[31:24]  ;      //next DHCP ALLOCATION IP
          // 16'd21   :  dhcp_tx_data <= Siaddr[23:16]  ;
          // 16'd22   :  dhcp_tx_data <= Siaddr[15:8]   ;
          // 16'd23   :  dhcp_tx_data <= Siaddr[7:0]    ;
		  // 16'd24   :  dhcp_tx_data <= Giaddr[31:24]  ;      //first Router IP
          // 16'd25   :  dhcp_tx_data <= Giaddr[23:16]  ;
          // 16'd26   :  dhcp_tx_data <= Giaddr[15:8]   ;
          // 16'd27   :  dhcp_tx_data <= Giaddr[7:0]    ;
		  // 16'd28   :  dhcp_tx_data <= 8'h00  ;
		  // 16'd29   :  dhcp_tx_data <= 8'h00  ;
          // 16'd30   :  dhcp_tx_data <= 8'h00  ;
          // 16'd31   :  dhcp_tx_data <= 8'h00  ;
		  // 16'd32   :  dhcp_tx_data <= 8'h00  ;
		  // 16'd33   :  dhcp_tx_data <= 8'h00  ;
          // 16'd34   :  dhcp_tx_data <= 8'h00  ;
          // 16'd35   :  dhcp_tx_data <= 8'h00  ;
		  // 16'd36   :  dhcp_tx_data <= 8'h00  ;
		  // 16'd37   :  dhcp_tx_data <= 8'h00  ;		  
		  16'd38   :  dhcp_tx_data <= source_mac_addr[47:40]  ;
		  16'd39   :  dhcp_tx_data <= source_mac_addr[39:32]  ;
          16'd40   :  dhcp_tx_data <= source_mac_addr[31:24]  ;
          16'd41   :  dhcp_tx_data <= source_mac_addr[23:16]  ;
		  16'd42   :  dhcp_tx_data <= source_mac_addr[15:8]   ;
		  16'd43   :  dhcp_tx_data <= source_mac_addr[7:0]    ;
		  default  :  dhcp_tx_data <= 8'h00 ;		
        endcase
      end
    else
      dhcp_tx_data <= 8'h00 ;
  end
  
endmodule
