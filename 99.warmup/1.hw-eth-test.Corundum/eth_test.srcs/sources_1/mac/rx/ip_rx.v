//////////////////////////////////////////////////////////////////////////////////////
//Module Name : ip_rx
//Description : This module is used to receive IP data and verify IP header checksum
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module ip_rx
//#
//(
// parameter local_mac_addr = 48'h00_0a_35_01_fe_c0,
// parameter local_ip_addr  = 32'hc0a80002
//)
(
 input                  clk,   
 input                  rst_n,  
 
 input	[31:0]					local_ip_addr,
 input	[47:0]					local_mac_addr,
 
 input  [7:0]           ip_rx_data,
 input                  ip_rx_req,  
 input  [47:0]          mac_rx_destination_mac_addr, 

 output reg             udp_rx_req,                   //udp rx request
 output reg             icmp_rx_req,                  //icmp rx request  
 output reg             ip_addr_check_error,          //ip address is not equal to local address
 
 output reg [15:0]      upper_layer_data_length,      //udp or icmp data length = ip data length - ip header length
 output reg [15:0]      ip_total_data_length,         //send data length
 
 output reg [7:0]       net_protocol,                 //network layer protocol: 8'h11 udp  8'h01 icmp
 output reg [31:0]      ip_rec_source_addr,           //received source ip address
 output reg [31:0]      ip_rec_destination_addr,      //received destination ip address
 
 output reg             ip_rx_end,
 output reg             ip_checksum_error
 
) ;

reg  [15:0]             ip_rx_cnt ;
reg  [15:0]             ip_rec_data_length ;
          
reg  [7:0]              ip_rx_data_d0 ;
reg  [7:0]              ip_rx_data_d1 ;
          
reg  [15:0]             ip_rec_checksum ;

reg  [3:0]              header_length_buf ;
wire [5:0]              header_length ;

parameter IDLE             =  5'b00001  ;
parameter REC_HEADER0      =  5'b00010  ;
parameter REC_HEADER1      =  5'b00100  ;
parameter REC_DATA         =  5'b01000  ;
parameter REC_END          =  5'b10000  ;

reg [4:0]     state      ;
reg [4:0]     next_state ;

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    state <= IDLE ;
  else 
    state <= next_state ;
end

always @(*)
begin
    case(state)
	 IDLE            :  begin
	                      if (ip_rx_req == 1'b1)
													next_state <= REC_HEADER0 ;
												else
													next_state <= IDLE ;
											end
	 REC_HEADER0    :	  begin
                        if (ip_rx_cnt == 16'd3)
													next_state <= REC_HEADER1 ;
												else
	                        next_state <= REC_HEADER0 ;
											end
	 REC_HEADER1    :  	begin
                        if (ip_rx_cnt == header_length - 1)
													next_state <= REC_DATA ;
												else
	                        next_state <= REC_HEADER1 ;
											end
	 REC_DATA       :   begin
                        if (ip_checksum_error || ip_rx_end)
													next_state <= REC_END ;		
												else if (ip_rx_cnt == 16'hffff)
													next_state <= REC_END ; 						
												else
	                        next_state <= REC_DATA ;
											end	
	 REC_END        : 			next_state <= IDLE  ;
	 default        : 			next_state <= IDLE  ;
	 endcase
end

assign header_length       = 4*header_length_buf ;

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    ip_rx_end <= 1'b0 ;
  else if (state == REC_DATA && ip_rx_cnt == ip_total_data_length - 2)
    ip_rx_end <= 1'b1 ;
  else
    ip_rx_end <= 1'b0 ;
end
//mac addr and ip addr is not equal to local addr, assert error
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    ip_addr_check_error <= 1'b0 ;
  else if (state == REC_DATA)
  begin
    if (mac_rx_destination_mac_addr == local_mac_addr && ip_rec_destination_addr == local_ip_addr)						
      ip_addr_check_error <= 1'b0 ;
    else
      ip_addr_check_error <= 1'b1 ;
  end
  else
    ip_addr_check_error <= 1'b0 ;
end
//generate udp rx request signal
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    udp_rx_req <= 1'b0 ;
  else if (state == REC_HEADER1 && net_protocol == 8'h11 && ip_rx_cnt == header_length - 2)
    udp_rx_req <= 1'b1 ;
  else
    udp_rx_req <= 1'b0 ;
end
//generate icmp rx request signal
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    icmp_rx_req <= 1'b0 ;
  else if (state == REC_HEADER1 && net_protocol == 8'h01 && ip_rx_cnt == header_length - 2)
    icmp_rx_req <= 1'b1 ;
  else
    icmp_rx_req <= 1'b0 ;
end


//icmp or udp data length										
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
  begin
    upper_layer_data_length <= 16'd0 ;
  end
  else
  begin
    upper_layer_data_length <= ip_rec_data_length - header_length  ;
  end
end 
										
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
  begin
    ip_rx_data_d0 <= 8'd0 ;
		ip_rx_data_d1 <= 8'd0 ;
  end
  else
  begin
    ip_rx_data_d0 <= ip_rx_data ;
		ip_rx_data_d1 <= ip_rx_data_d0 ;
  end
end  

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    ip_rx_cnt <= 16'd0 ;
  else if (state == REC_HEADER0 || state == REC_HEADER1 || state == REC_DATA)
    ip_rx_cnt <= ip_rx_cnt + 1'b1 ;
  else
    ip_rx_cnt <= 16'd0 ;
end
//total length
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    ip_total_data_length <= 16'd0 ;
  else if (state == REC_HEADER1)
  begin
    if (ip_rec_data_length < 16'd46)
			ip_total_data_length <= 16'd46 ;
    else
      ip_total_data_length <= ip_rec_data_length ;
  end
end


//ip header length
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    header_length_buf <= 4'd0 ;
  else if (state == REC_HEADER0 && ip_rx_cnt == 16'd0)
    header_length_buf <= ip_rx_data[3:0] ;
end
//ip data total length
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    ip_rec_data_length <= 16'd0 ;
  else if (state == REC_HEADER0 && ip_rx_cnt == 16'd2)
    ip_rec_data_length[15:8] <= ip_rx_data  ;
  else if (state == REC_HEADER0 && ip_rx_cnt == 16'd3)
    ip_rec_data_length[7:0] <= ip_rx_data  ;
end
//network layer protocol
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    net_protocol <= 8'd0 ;
  else if (state == REC_HEADER1 && ip_rx_cnt == 16'd9)
    net_protocol <= ip_rx_data ;
end

//ip source address
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    ip_rec_source_addr <= 32'd0 ;
  else if (state == REC_HEADER1 && ip_rx_cnt == 16'd12)
    ip_rec_source_addr[31:24] <= ip_rx_data ;
  else if (state == REC_HEADER1 && ip_rx_cnt == 16'd13)
    ip_rec_source_addr[23:16] <= ip_rx_data ;
  else if (state == REC_HEADER1 && ip_rx_cnt == 16'd14)
    ip_rec_source_addr[15:8] <= ip_rx_data ;
  else if (state == REC_HEADER1 && ip_rx_cnt == 16'd15)
    ip_rec_source_addr[7:0] <= ip_rx_data ;
end
//ip source address
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    ip_rec_destination_addr <= 32'd0 ;
  else if (state == REC_HEADER1 && ip_rx_cnt == 16'd16)
    ip_rec_destination_addr[31:24] <= ip_rx_data ;
  else if (state == REC_HEADER1 && ip_rx_cnt == 16'd17)
    ip_rec_destination_addr[23:16] <= ip_rx_data ;
  else if (state == REC_HEADER1 && ip_rx_cnt == 16'd18)
    ip_rec_destination_addr[15:8] <= ip_rx_data ;
  else if (state == REC_HEADER1 && ip_rx_cnt == 16'd19)
    ip_rec_destination_addr[7:0] <= ip_rx_data ;
end


//****************************************************************//
//verify checksum
//****************************************************************//
reg  [31:0] checksum_tmp ;
reg  [31:0] checksum_buf ;
reg  [31:0] check_out ;
reg  [31:0] checkout_buf ;
wire [15:0] checksum ;
reg  [2:0]  checksum_cnt ;

//checksum function 
function    [31:0]  checksum_adder
(
 input       [31:0]  dataina,
 input       [31:0]  datainb
);

begin
    checksum_adder = dataina + datainb;
end   
endfunction 

function    [31:0]  checksum_out
(
 input      [31:0]  dataina
);

begin
    checksum_out = dataina[15:0]+dataina[31:16];
end  
 
endfunction 

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
     checksum_tmp <= 32'd0; 
  else if (state == REC_HEADER0 || state == REC_HEADER1)
  begin
    if (ip_rx_cnt[0] == 1'b1)
      checksum_tmp <= checksum_adder({ip_rx_data_d0, ip_rx_data},checksum_buf);
  end
  else if (state == IDLE)
    checksum_tmp <= 32'd0; 
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
     check_out <= 32'd0; 
  else if (state == REC_DATA)   
	  check_out <= checksum_out(checksum_tmp) ;
end

always @(posedge clk or negedge rst_n)
begin
  if(rst_n == 1'b0)
      checksum_cnt <= 3'd0 ; 
  else if (state == 	REC_DATA)
  begin
    if (checksum_cnt == 3'd7)
	   checksum_cnt <= checksum_cnt ;	
    else	
	   checksum_cnt <= checksum_cnt + 1'b1 ;
  end
  else
	   checksum_cnt <= 3'd0 ;	
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    checksum_buf <= 32'd0 ;
  else
    checksum_buf <= checksum_tmp ;
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    checkout_buf <= 32'd0 ;
  else
    checkout_buf <= check_out ;
end

assign checksum = ~checkout_buf[15:0] ;

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    ip_checksum_error <= 1'b0 ;
  else if (state == REC_DATA && checksum_cnt == 3'd2)
  begin
    if (checksum == 16'd0)	 
      ip_checksum_error <= 1'b0 ;
    else
      ip_checksum_error <= 1'b1 ;
    end
  else
      ip_checksum_error <= 1'b0 ;
end 

endmodule
