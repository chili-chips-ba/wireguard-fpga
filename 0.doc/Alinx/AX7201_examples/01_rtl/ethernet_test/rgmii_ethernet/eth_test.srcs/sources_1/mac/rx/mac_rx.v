//////////////////////////////////////////////////////////////////////////////////////
//Module Name : mac_rx
//Description : This module is used to receive MAC layer data and verify CRC
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module mac_rx
(
 input                  clk,   
 input                  rst_n,    
 
 input                  rx_dv,
 input      [7:0]       mac_rx_datain,
 
 input      [31:0]      crc_result ,       
 output reg                crcen,          
 output reg                crcre, 
 output reg    [7:0]       crc_din,
 
 input                  checksum_err,     //checksum error from IP layer
 
 input                  ip_rx_end,        //ip receive end
 input                  arp_rx_end,       //arp receive end 
 output reg             ip_rx_req,        //ip rx request
 output reg             arp_rx_req,       //arp rx request
 
 output     [7:0]       mac_rx_dataout,
 output reg             mac_rec_error ,
 
 output reg [47:0]      mac_rx_destination_mac_addr,
 output reg [47:0]      mac_rx_source_mac_addr
);

reg [4:0]               mac_rx_cnt       ;
reg [15:0]              mac_crc_cnt      ;

reg [63:0]              preamble         ;           
reg [3:0]               preamble_cnt     ;
           
reg [15:0]              frame_type       ;   //type 16'h0800 IP; 16'h0806 ARP

           
wire                    rx_dv_posedge    ;
reg                     rx_dv_d0         ;
reg                     rx_dv_d1         ;
       
reg [7:0]               mac_rx_data_d0   ;
reg [7:0]               mac_rx_data_d1   ;
reg [7:0]               mac_rx_data_d2   ;
       
wire                    mac_rx_head_end  ;
       
reg  [15:0]             timeout          ;
       
reg  [31:0]             crc              ;
reg  [31:0]             crc_check        ;
reg                     crc_error        ;
reg  [31:0]             crc_rec          ;
reg	 [31:0]			    crc_result_d0   ;

//MAC receive FSM
parameter IDLE                =  8'b0000_0001 ;
parameter REC_PREAMBLE        =  8'b0000_0010 ;
parameter REC_MAC_HEAD        =  8'b0000_0100 ;
parameter REC_IDENTIFY        =  8'b0000_1000 ;
parameter REC_DATA            =  8'b0001_0000 ;
parameter REC_CRC             =  8'b0010_0000 ;
parameter REC_ERROR           =  8'b0100_0000 ;
parameter REC_END             =  8'b1000_0000 ;

reg [7:0]     rec_state      ;
reg [7:0]     rec_next_state ;

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    rec_state <= IDLE ;
  else 
    rec_state <= rec_next_state ;
end

always @(*)
begin
    case(rec_state)
	 IDLE            :  begin
	                      if (rx_dv_posedge == 1'b1)
													rec_next_state <= REC_PREAMBLE ;
											else
													rec_next_state <= IDLE ;
	                    end
	 REC_PREAMBLE    :  begin
												if (mac_rx_cnt == 7)
													rec_next_state <=  REC_MAC_HEAD  ;
												else
													rec_next_state <=  REC_PREAMBLE    ;
											end

	 REC_MAC_HEAD    : begin
												if (preamble != 64'h55_55_55_55_55_55_55_d5)
												  rec_next_state <= REC_ERROR ;
												else if ( mac_rx_cnt == 16'd21)
													rec_next_state <= REC_IDENTIFY ;
												else
													rec_next_state <= REC_MAC_HEAD ; 
										 end
	 REC_IDENTIFY    : begin
	                      if (frame_type == 16'h0800 || frame_type == 16'h0806)
													rec_next_state <= REC_DATA ;
												else
													rec_next_state <= REC_ERROR ;
										 end
	 REC_DATA        : begin
	                      if (checksum_err)
													rec_next_state <= REC_ERROR ;
												else if (ip_rx_end|arp_rx_end)
													rec_next_state <= REC_CRC ;
												else if (timeout == 16'hffff)
													rec_next_state <= REC_ERROR ;
												else
	                       rec_next_state <= REC_DATA ;
										 end	  						 
	 REC_CRC         : begin
												if (crc_error)
													rec_next_state <= REC_ERROR ;
												else if (mac_rx_cnt == 7)
													rec_next_state <= REC_END ;
												else
													rec_next_state <= REC_CRC ;
											end
	 REC_ERROR      : 			rec_next_state <= IDLE  ;
	 REC_END        : 			rec_next_state <= IDLE  ;
	 default        : 			rec_next_state <= IDLE  ;
	 endcase
end




assign mac_rx_dataout  = mac_rx_data_d2 ;
assign rx_dv_posedge   = ~rx_dv_d0 & rx_dv ;

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
  begin
    crcen <= 	1'b0 ;
		crcre <= 1'b1 ;
		crc_din <= 8'd0 ;
  end
  else if (rec_state == REC_MAC_HEAD || rec_state == REC_IDENTIFY || rec_state == REC_DATA)
  begin
    crcen <= 	1'b1 ;
		crcre <= 	1'b0 ;
		crc_din <= mac_rx_data_d0 ;
  end
  else
  begin
    crcen <= 	1'b0 ;
		crcre <= 1'b1 ;
		crc_din <= 8'd0 ;
  end
end


always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    ip_rx_req <= 	1'b0 ;
  else if (rec_state == REC_IDENTIFY &&  frame_type == 16'h0800)
    ip_rx_req <=  1'b1 ;
  else
    ip_rx_req <=  1'b0 ;
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    arp_rx_req <= 	1'b0 ;
  else if (rec_state == REC_IDENTIFY &&  frame_type == 16'h0806)
    arp_rx_req <=  	1'b1 ;
  else
    arp_rx_req <=  	1'b0 ;
end

//rx dv and rx data resigster
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
  begin
    rx_dv_d0       <= 1'b0 ;
		rx_dv_d1       <= 1'b0 ;
    mac_rx_data_d0 <= 8'd0 ;
		mac_rx_data_d1 <= 8'd0 ;
		mac_rx_data_d2 <= 8'd0 ;
  end
  else
  begin
		rx_dv_d0       		<= rx_dv ;
		rx_dv_d1      	  <= rx_dv_d0 ;
		mac_rx_data_d0 		<= mac_rx_datain ;
		mac_rx_data_d1	 	<= mac_rx_data_d0 ;
		mac_rx_data_d2 		<= mac_rx_data_d1 ;
  end
end
//timeout
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    timeout <= 16'd0 ;
  else if (rec_state == REC_DATA)
    timeout <= timeout + 1'b1 ;
  else
    timeout <= 16'd0 ;
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    mac_rx_cnt <= 5'd0 ;
  else if (rec_state == REC_PREAMBLE || rec_state == REC_MAC_HEAD || rec_state == REC_CRC)
    mac_rx_cnt <= mac_rx_cnt + 1'b1 ;
  else
    mac_rx_cnt <= 5'd0 ;
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    mac_crc_cnt <= 16'd0 ;
  else if (rx_dv_d1)
    mac_crc_cnt <= mac_crc_cnt + 1'b1 ;
  else
    mac_crc_cnt <= 16'd0 ;
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    mac_rec_error <= 1'b0 ;
  else if (rx_dv_posedge)
    mac_rec_error <= 1'b0 ;
  else if (rec_state == REC_ERROR)
    mac_rec_error <= 1'b1 ;
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    crc <= 32'd0 ;
  else if (crcen)
    crc <= crc_result_d0 ;
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    crc_result_d0 <= 32'd0 ;
  else 
    crc_result_d0 <= crc_result ;
end


always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    crc_check <= 32'd0 ;
  else if (rec_state == REC_CRC)
  begin
    case(mac_rx_cnt)
      5'd1  :  crc_check[31:24] <= {~crc[24], ~crc[25], ~crc[26], ~crc[27], ~crc[28], ~crc[29], ~crc[30], ~crc[31]} ;
      5'd2  :  crc_check[23:16] <= {~crc[16], ~crc[17], ~crc[18], ~crc[19], ~crc[20], ~crc[21], ~crc[22], ~crc[23]} ;
      5'd3  :  crc_check[15:8]  <= {~crc[8], ~crc[9], ~crc[10], ~crc[11], ~crc[12], ~crc[13], ~crc[14], ~crc[15]}   ;
      5'd4  :  crc_check[7:0]   <= {~crc[0], ~crc[1], ~crc[2], ~crc[3], ~crc[4], ~crc[5], ~crc[6], ~crc[7]}   ;
    default :  crc_check <= crc_check ;
    endcase
  end
  else 
    crc_check <= 32'd0 ;
end
//received crc data
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    crc_rec  <= 48'd0 ;
  else if (rec_state == REC_CRC)
  begin
    case(mac_rx_cnt)
			5'd0   : crc_rec[31:24]      <= mac_rx_data_d2 ;
      5'd1   : crc_rec[23:16]      <= mac_rx_data_d2 ;
      5'd2   : crc_rec[15:8]       <= mac_rx_data_d2 ;
      5'd3   : crc_rec[7:0]        <= mac_rx_data_d2 ;
      default : crc_rec             <= crc_rec     ;
    endcase
  end
  else
    crc_rec <= crc_rec ;
end 
//check crc
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    crc_error <= 1'b0 ;
  else if (rec_state == REC_CRC && mac_rx_cnt == 5)
  begin
    if (crc_check == crc_rec)
       crc_error <= 1'b0 ;
	 else
	    crc_error <= 1'b1 ;
  end
  else
    crc_error <= 1'b0 ;
end


always @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    preamble_cnt  <= 4'd0 ;
  else if (rx_dv)
  begin
    if (preamble_cnt < 8)
      preamble_cnt <= preamble_cnt + 1'b1 ;
  end
  else
    preamble_cnt <= 4'd0 ;
end


always @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    preamble  <= 64'd0 ;
  else if (rx_dv)
  begin
    if (preamble_cnt == 4'd0)
      preamble[63:56] <= mac_rx_datain ;
    if (preamble_cnt == 4'd1)
      preamble[55:48] <= mac_rx_datain ;
    if (preamble_cnt == 4'd2)
      preamble[47:40] <= mac_rx_datain ;
    if (preamble_cnt == 4'd3)
      preamble[39:32] <= mac_rx_datain ;
    if (preamble_cnt == 4'd4)
      preamble[31:24] <= mac_rx_datain ;
    if (preamble_cnt == 4'd5)
      preamble[23:16] <= mac_rx_datain ; 
    if (preamble_cnt == 4'd6)
      preamble[15:8] <= mac_rx_datain ;
    if (preamble_cnt == 4'd7)
      preamble[7:0] <= mac_rx_datain ; 
  end
  else
    preamble <= 64'd0 ;
end   

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    mac_rx_destination_mac_addr  <= 48'd0 ;
  else if (rec_state == REC_MAC_HEAD)
  begin
    case(mac_rx_cnt)
      5'd8 	  : mac_rx_destination_mac_addr[47:40] <= mac_rx_data_d0 ;
      5'd9    : mac_rx_destination_mac_addr[39:32] <= mac_rx_data_d0 ;
      5'd10   : mac_rx_destination_mac_addr[31:24] <= mac_rx_data_d0 ;
      5'd11   : mac_rx_destination_mac_addr[23:16] <= mac_rx_data_d0 ;
      5'd12   : mac_rx_destination_mac_addr[15:8]  <= mac_rx_data_d0 ;
      5'd13	  : mac_rx_destination_mac_addr[7:0]   <= mac_rx_data_d0 ;
      default : mac_rx_destination_mac_addr <= mac_rx_destination_mac_addr ;
	 endcase
  end
  else
    mac_rx_destination_mac_addr <= mac_rx_destination_mac_addr ;
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    mac_rx_source_mac_addr  <= 48'd0 ;
  else if (rec_state == REC_MAC_HEAD)
  begin
    case(mac_rx_cnt)
      5'd14   : mac_rx_source_mac_addr[47:40]      <= mac_rx_data_d0 ;
      5'd15   : mac_rx_source_mac_addr[39:32]      <= mac_rx_data_d0 ;
      5'd16   : mac_rx_source_mac_addr[31:24]      <= mac_rx_data_d0 ;
      5'd17   : mac_rx_source_mac_addr[23:16]      <= mac_rx_data_d0 ;
      5'd18  : mac_rx_source_mac_addr[15:8]       <= mac_rx_data_d0 ;
      5'd19  : mac_rx_source_mac_addr[7:0]        <= mac_rx_data_d0 ;
		default : mac_rx_source_mac_addr             <= mac_rx_source_mac_addr ;
	 endcase
  end
  else
    mac_rx_source_mac_addr <= mac_rx_source_mac_addr ;
end

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    frame_type  <= 16'd0 ;
  else if (rec_state == REC_MAC_HEAD)
  begin
    case(mac_rx_cnt)
			5'd20  : frame_type[15:8]                   <= mac_rx_data_d0 ;
      5'd21  : frame_type[7:0]                    <= mac_rx_data_d0 ;
      default : frame_type                         <= frame_type     ;
    endcase
  end
  else
    frame_type <= frame_type ;
end 
 


 
endmodule


