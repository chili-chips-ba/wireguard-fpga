//////////////////////////////////////////////////////////////////////////////////////
//Module Name : mac_top
//Description :
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module mac_test
(
 input                rst_n  ,
 input                cmos_vsync,
 input                cmos_href,
 input                reg_conf_done,
// input                vsync_posedge,
// input  [15:0]        identify_code,
 input [15:0]         udp_send_data_length, 
 input [7:0]          fifo_data,                //FIFO中的数据	 
 input [10:0]         fifo_data_count,		  //FIFO中的数据数量
 output reg              fifo_rd_en,            //FIFO读使�? 
 
 input                gmii_tx_clk ,
 input                gmii_rx_clk , 
 input                gmii_rx_dv,
 input  [7:0]         gmii_rxd,
 output reg           gmii_tx_en,
 output reg [7:0]     gmii_txd
 
); 



reg                  gmii_rx_dv_d0 ;
reg   [7:0]          gmii_rxd_d0 ;
wire                 gmii_tx_en_tmp ;
wire   [7:0]         gmii_txd_tmp ;

reg  [9:0]           vsync_posedge_buf ;
reg  [15:0]          identify_code_d0 ;

wire                 udp_tx_req ;
wire                 arp_request_req ;
wire                 mac_send_end ;
reg                  write_end ;

wire [7:0]           udp_rec_ram_rdata ;  
reg  [10:0]          udp_rec_ram_read_addr ;
wire [15:0]          udp_rec_data_length ;
wire                 udp_rec_data_valid ;

reg [10:0]           fifo_rdusedw ;
reg  [31:0]           wait_cnt ;
                     




wire button_negedge ;

wire mac_not_exist ;
wire arp_found ;
wire fifo_rd_en_tmp ;

parameter IDLE          = 10'b0000000001 ;
parameter ARP_REQ       = 10'b0000000010 ;
parameter ARP_SEND      = 10'b0000000100 ;
parameter ARP_WAIT      = 10'b0000001000 ;
parameter GEN_REQ       = 10'b0000010000 ;
parameter CHECK_FIFO    = 10'b0000100000 ;
parameter SEND          = 10'b0001000000 ;
parameter WAIT          = 10'b0010000000 ;
parameter CHECK_ARP     = 10'b0100000000 ;
parameter WAIT_SYNC     = 10'b1000000000 ;


reg [9:0]    state  ;

always @(posedge gmii_tx_clk or negedge rst_n)
begin
  if (~rst_n)
    state  <=  IDLE  ;
  else
  begin
  case(state)
  IDLE        :  begin
                   if (wait_cnt == 32'd1250000 )  //wait for 10ms
						   state <= ARP_REQ ;
						 else
						   state <= IDLE ;
					  end
  
  ARP_REQ     :  state <= ARP_SEND ;
  ARP_SEND    :  begin
                   if (mac_send_end)
						   state <= ARP_WAIT ;
					    else
						   state <= ARP_SEND ;
					  end
  ARP_WAIT    :  begin
                   if (arp_found)
						   state <= WAIT_SYNC ; 
					    else if (wait_cnt == 32'd125_000_000)
						   state <= ARP_REQ ; 
					    else
						   state <= ARP_WAIT ;
					  end
  WAIT_SYNC    : begin
                   if (vsync_posedge_buf[9])
					      state <= CHECK_FIFO     ;
					    else
					      state <= WAIT_SYNC ;
				     end
  CHECK_FIFO   :  begin
                   if (fifo_rdusedw > 11'd1000)
					      state <= GEN_REQ     ;
					    else if (wait_cnt== 32'd125_000_000)
						   state <= WAIT_SYNC     ;
						 else
					      state <= CHECK_FIFO ;
				     end
  
  GEN_REQ     :  begin
						   state <= SEND ;
					  end     
					  
  SEND        :  begin
                   if (mac_send_end)
						   state <= CHECK_ARP ;
					    else
						   state <= SEND ;
					  end
  
  WAIT        :  begin
                   if (wait_cnt == 32'd1024)
					      state <= CHECK_ARP ;
					    else
					      state <= WAIT ;
				     end
  CHECK_ARP   :  begin 
                   if (mac_not_exist)
						   state <= ARP_REQ ;
					    else
						   state <= CHECK_FIFO ;
					  end
  default     :  state <= IDLE ;
endcase
end
end		

always@(posedge gmii_rx_clk or negedge rst_n)
begin	
  if(rst_n == 1'b0) 
  begin
    gmii_rx_dv_d0 <= 1'b0 ;
	 gmii_rxd_d0   <= 8'd0 ;
  end
  else
  begin
    gmii_rx_dv_d0 <= gmii_rx_dv ;
	 gmii_rxd_d0   <= gmii_rxd ;
  end
end

always@(posedge gmii_tx_clk or negedge rst_n)
begin	
  if(rst_n == 1'b0) 
  begin
    gmii_tx_en <= 1'b0 ;
	 gmii_txd   <= 8'd0 ;
  end
  else
  begin
    gmii_tx_en <= gmii_tx_en_tmp ;
	 gmii_txd   <= gmii_txd_tmp ;
  end
end

mac_top mac_top0
(
 .gmii_tx_clk                 (gmii_tx_clk)                  ,
 .gmii_rx_clk                 (gmii_rx_clk)                  ,
 .rst_n                       (rst_n)  ,

 .source_mac_addr             (48'h00_0a_35_01_fe_c0)   ,       //source mac address 
 .identify_code               (identify_code_d0              ), 
 .TTL                         (8'h80),
 .source_ip_addr              (32'hc0a80002),
 .destination_ip_addr         (32'hc0a80003), 
 .udp_send_source_port        (16'h1f90),
 .udp_send_destination_port   (16'h1f90),
 
 .fifo_data                      (fifo_data),         
 .fifo_rd_en                     (fifo_rd_en_tmp), 
 .ram_wr_data                 () ,
 .ram_wr_en                   (),
 .udp_ram_data_req            (),
 .udp_send_data_length        (udp_send_data_length),
 
 .udp_tx_req                  (udp_tx_req),
 .arp_request_req             (arp_request_req ),
 
 .mac_send_end                (mac_send_end),  
 .mac_data_valid              (gmii_tx_en_tmp),   
 .mac_tx_data                 (gmii_txd_tmp), 
 .rx_dv                       (gmii_rx_dv_d0   ),
 .mac_rx_datain               (gmii_rxd_d0 ),
    
 .udp_rec_ram_rdata           (udp_rec_ram_rdata),  
 .udp_rec_ram_read_addr       (udp_rec_ram_read_addr),
 .udp_rec_data_length         (udp_rec_data_length ),
    
 .udp_rec_data_valid          (udp_rec_data_valid),
 .arp_found                   (arp_found ),
 .mac_not_exist               (mac_not_exist )
) ;



	


assign udp_tx_req = (state == GEN_REQ) ;
assign arp_request_req = (state == ARP_REQ) ;



always @(posedge gmii_tx_clk or negedge rst_n)
begin
  if (!rst_n)
    fifo_rdusedw <= 11'd0 ;
  else  
    fifo_rdusedw <= fifo_data_count ;
end

reg cmos_vsync_d0 ;
reg cmos_vsync_d1 ;
reg cmos_vsync_d2 ;
wire vsync_posedge ;
reg cmos_href_d0 ;
reg cmos_href_d1 ;
reg cmos_href_d2 ;
reg [15:0] identify_code ;

always @(posedge gmii_tx_clk or negedge rst_n)
begin
  if (!rst_n)
  begin
    cmos_vsync_d0 <= 1'b0 ;
	 cmos_vsync_d1 <= 1'b0 ;
	 cmos_vsync_d2 <= 1'b0 ;
  end
  else
  begin
    cmos_vsync_d0 <= cmos_vsync ;
    cmos_vsync_d1 <= cmos_vsync_d0 ;
	 cmos_vsync_d2 <= cmos_vsync_d1 ;
  end
end

assign vsync_posedge = ~cmos_vsync_d2 & cmos_vsync_d1 ;

always @(posedge gmii_tx_clk or negedge rst_n)
begin
  if (!rst_n)
  begin
    cmos_href_d0 <= 1'b0 ;
	 cmos_href_d1 <= 1'b0 ;
	 cmos_href_d2 <= 1'b0 ;
  end
  else
  begin
    cmos_href_d0 <= cmos_href ;
    cmos_href_d1 <= cmos_href_d0 ;
	 cmos_href_d2 <= cmos_href_d1 ;
  end
end

always @(posedge gmii_tx_clk or negedge rst_n)
begin
  if (!rst_n)
    identify_code <= 16'd0 ;
  else if (vsync_posedge)
    identify_code <= 16'd0 ;
  else if (cmos_href_d1 == 1'b1 && cmos_href_d2 == 1'b0)
    identify_code <= identify_code + 1'b1 ;
end


always@(posedge gmii_tx_clk or negedge rst_n)
begin	
  if(rst_n == 1'b0) 
    wait_cnt <= 0 ;
  else if (state == IDLE ||state == CHECK_FIFO || state == WAIT || state == ARP_WAIT)
    wait_cnt <= wait_cnt + 1'b1 ;
  else
    wait_cnt <= 0 ;
end

always@(posedge gmii_tx_clk or negedge rst_n)
begin	
  if(rst_n == 1'b0) 
    vsync_posedge_buf <= 10'd0 ;
  else 
    vsync_posedge_buf <= {vsync_posedge_buf[8:0], vsync_posedge} ;
end

always@(posedge gmii_tx_clk or negedge rst_n)
begin	
  if(rst_n == 1'b0) 
    identify_code_d0 <= 10'd0 ;
  else if (state == CHECK_FIFO)
    identify_code_d0 <= identify_code ;
end

always@(posedge gmii_tx_clk or negedge rst_n)
begin	
  if(rst_n == 1'b0) 
    fifo_rd_en <= 1'b0 ;
  else
    fifo_rd_en <= fifo_rd_en_tmp ;
end

endmodule
