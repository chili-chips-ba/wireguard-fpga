
//////////////////////////////////////////////////////////////////////////////////////
//Module Name : mac_top
//Description :
//
//////////////////////////////////////////////////////////////////////////////////////
//`define TEST_SPEED
`timescale 1 ns/1 ns
module mac_test
(
 input                rst_n  ,
 input                push_button,   
 input [31:0]         pack_total_len,     
 input                gmii_tx_clk ,
 input                gmii_rx_clk ,
 input                gmii_rx_dv,
 input  [7:0]         gmii_rxd,
 output reg           gmii_tx_en,
 output reg [7:0]     gmii_txd 
);

localparam UDP_WIDTH = 32 ;
localparam UDP_DEPTH = 5 ;


reg                  gmii_rx_dv_d0 ;
reg   [7:0]          gmii_rxd_d0 ;
wire                 gmii_tx_en_tmp ;
wire   [7:0]         gmii_txd_tmp ;

reg   [7:0]          ram_wr_data ;
reg                  ram_wr_en ;
wire                 udp_ram_data_req ;
reg   [15:0]         udp_send_data_length ;

wire  [7:0]          tx_ram_wr_data ;
wire                 tx_ram_wr_en ;
wire                 udp_tx_req ;
wire                 arp_request_req ;
wire                 mac_send_end ;
reg                  write_end ;

wire [7:0]           udp_rec_ram_rdata ;
reg  [10:0]          udp_rec_ram_read_addr ;
wire [15:0]          udp_rec_data_length ;
wire                 udp_rec_data_valid ;

wire                 udp_tx_end  ;
wire                 almost_full ;

reg                  udp_ram_wr_en ;
reg                  udp_write_end ;
wire                 write_ram_end ;
reg  [31:0]          wait_cnt ;
reg  [UDP_WIDTH-1:0]  udp_data [UDP_DEPTH-1:0];

reg  [4:0] i;
reg  [1:0] j ;

reg  write_sel ;

wire button_negedge ;

wire mac_not_exist ;
wire arp_found ;

parameter IDLE          = 9'b000_000_001 ;
parameter ARP_REQ       = 9'b000_000_010 ;
parameter ARP_SEND      = 9'b000_000_100 ;
parameter ARP_WAIT      = 9'b000_001_000 ;
parameter GEN_REQ       = 9'b000_010_000 ;
parameter WRITE_RAM     = 9'b000_100_000 ;
parameter SEND          = 9'b001_000_000 ;
parameter WAIT          = 9'b010_000_000 ;
parameter CHECK_ARP     = 9'b100_000_000 ;


reg [8:0]    state  ;
reg [8:0]    next_state ;
reg  [15:0]  ram_cnt ;
reg    almost_full_d0 ;
reg    almost_full_d1 ;
always @(posedge gmii_tx_clk or negedge rst_n)
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
        if (wait_cnt == pack_total_len)    
            next_state <= ARP_REQ ;
          else
            next_state <= IDLE ;
        end

      ARP_REQ     :
        next_state <= ARP_SEND ;
      ARP_SEND    :
        begin
          if (mac_send_end)
            next_state <= ARP_WAIT ;
          else
            next_state <= ARP_SEND ;
        end
      ARP_WAIT    :
        begin
          if (arp_found)
            next_state <= WAIT ;
          else if (wait_cnt == pack_total_len)
            next_state <= ARP_REQ ;
          else
            next_state <= ARP_WAIT ;
        end
      GEN_REQ     :
        begin
          if (udp_ram_data_req)
            next_state <= WRITE_RAM ;
          else
            next_state <= GEN_REQ ;
        end
      WRITE_RAM   :
        begin
		  `ifdef TEST_SPEED
		  if (ram_cnt == udp_send_data_length - 1)
		  `else
          if (write_ram_end) 
		  `endif
            next_state <= WAIT     ;
          else
            next_state <= WRITE_RAM ;
        end
        
      SEND        :
        begin
          if (udp_tx_end)
            next_state <= WAIT ;
          else
            next_state <= SEND ;
        end
        
      WAIT        :
        begin
		  `ifdef TEST_SPEED  
          if (wait_cnt == 32'd90)             //frame gap
		  `else
		  if (wait_cnt == pack_total_len)
		  `endif
            next_state <= CHECK_ARP ;
          else
            next_state <= WAIT ;
        end
      CHECK_ARP   :
        begin
          if (mac_not_exist)
            next_state <= ARP_REQ ;
          else if (almost_full_d1)
            next_state <= CHECK_ARP ;
          else
            next_state <= GEN_REQ ;
        end
      default     :
        next_state <= IDLE ;
    endcase
  end
  
  
assign write_ram_end        = (write_sel)? udp_write_end : write_end ;
assign tx_ram_wr_data       = (write_sel)? udp_rec_ram_rdata : ram_wr_data ;
assign tx_ram_wr_en         = (write_sel)? udp_ram_wr_en : ram_wr_en ;


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
 .TTL                         (8'h80),
 .source_ip_addr              (32'hc0a80002),
 .destination_ip_addr         (32'hc0a80003),
 .udp_send_source_port        (16'h1f90),
 .udp_send_destination_port   (16'h1f90),
 
 .ram_wr_data                 (tx_ram_wr_data) ,
 .ram_wr_en                   (tx_ram_wr_en),
 .udp_ram_data_req            (udp_ram_data_req),
 .udp_send_data_length        (udp_send_data_length),
 .udp_tx_end                  (udp_tx_end                 ),
 .almost_full                 (almost_full                ), 
 
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

        
ax_debounce ax0
(
  .clk(gmii_rx_clk),
  .rst_n(rst_n),
  .button_in(push_button),
  .button_posedge(),
  .button_negedge(button_negedge),
  .button_out()
);
            
            
always @(*)
  begin
    udp_data[0] <={"H","E","L","L"};
    udp_data[1] <={"O"," ","A","L"};
    udp_data[2] <={"I","N","X"," "};
    udp_data[3] <={"H","E","I","J"};
    udp_data[4] <={"I","N","\r","\n"};
    
  end
  
//reg    almost_full_d0 ;
//reg    almost_full_d1 ;
  
always@(posedge gmii_rx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      begin
        almost_full_d0   <= 1'b0 ;
        almost_full_d1   <= 1'b0 ;
      end
    else
      begin
        almost_full_d0   <= almost_full ;
        almost_full_d1   <= almost_full_d0 ;
      end
  end

always@(posedge gmii_rx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
	   udp_send_data_length <= 16'd0 ;
    else if (write_sel)	 
		udp_send_data_length <= udp_rec_data_length - 8  ;
	 else
	 `ifdef TEST_SPEED 
       udp_send_data_length <= 16'd1000 ;	 
	 `else	 
	   udp_send_data_length <= 4*UDP_DEPTH ;
	 `endif
  end
  
  
always@(posedge gmii_tx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      write_sel <= 1'b0 ;
    else if (state == WAIT)
      begin
        if (udp_rec_data_valid)
          write_sel <= 1'b1 ;
        else
          write_sel <= 1'b0 ;
      end
  end
  
assign udp_tx_req    = (state == GEN_REQ) ;
assign arp_request_req  = (state == ARP_REQ) ;

always@(posedge gmii_tx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      wait_cnt <= 0 ;
    else if ((state==IDLE||state == WAIT || state == ARP_WAIT) && state != next_state)
      wait_cnt <= 0 ;
    else if (state==IDLE||state == WAIT || state == ARP_WAIT)
      wait_cnt <= wait_cnt + 1'b1 ;
	 else
	   wait_cnt <= 0 ;
  end
  

`ifdef TEST_SPEED
/*************************************************************/
//Test ethernet speed
//reg  [15:0]     ram_cnt ;
always@(posedge gmii_tx_clk or negedge rst_n)
 begin
   if(rst_n == 1'b0)
     ram_cnt <= 11'd0 ;
   else if (state == WRITE_RAM)
     ram_cnt <= ram_cnt + 1'b1 ;
   else
     ram_cnt <= 11'd0 ;
 end

always@(posedge gmii_tx_clk or negedge rst_n)
 begin
   if(rst_n == 1'b0)
     ram_wr_en <= 1'b0 ;
   else if (state == WRITE_RAM)
     ram_wr_en <= 1'b1 ;
   else
     ram_wr_en <= 1'b0 ;
 end  
 

always@(posedge gmii_tx_clk or negedge rst_n)
 begin
   if(rst_n == 1'b0)
     ram_wr_data <= 8'd0 ;
   else if (state == WRITE_RAM)
     ram_wr_data <= ram_cnt[7:0] ;
   else
     ram_wr_data <= 8'd0 ;
 end  
/*************************************************************/
`else
always@(posedge gmii_tx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      begin
        write_end  <= 1'b0;
        ram_wr_data <= 0;
        ram_wr_en  <= 0 ;
        i <= 0 ;
        j <= 0 ;
      end
    else if (state == WRITE_RAM)
      begin
        if(i == 5)
          begin
            ram_wr_en <=1'b0;
            write_end <= 1'b1;
          end
        else
          begin
            ram_wr_en <= 1'b1 ;
            write_end <= 1'b0 ;
            j <= j + 1'b1 ;
            case(j)
              2'd0    :  ram_wr_data <= udp_data[i][31:24] ;
              2'd1    :  ram_wr_data <= udp_data[i][23:16] ;
              2'd2    :  ram_wr_data <= udp_data[i][15:8] ;
              2'd3    :  ram_wr_data <= udp_data[i][7:0] ;
              default :  ram_wr_data <= 8'h00 ;
            endcase
            
            if (j == 3)
              begin
                j <= 0 ;
                i <= i + 1'b1;
              end
          end
      end
    else
      begin
        write_end  <= 1'b0;
        ram_wr_data <= 0;
        ram_wr_en  <= 0 ;
        i <= 0 ;
        j <= 0 ;
      end
  end
`endif
  
//send udp received data to udp tx ram
always@(posedge gmii_tx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      udp_rec_ram_read_addr <= 11'd0 ;
    else if (state == WRITE_RAM)
      udp_rec_ram_read_addr <= udp_rec_ram_read_addr + 1'b1 ;
    else
      udp_rec_ram_read_addr <= 11'd0 ;
  end
  
always@(posedge gmii_tx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      udp_ram_wr_en <= 1'b0 ;
    else if (state == WRITE_RAM && udp_rec_ram_read_addr < udp_rec_data_length - 8)
      udp_ram_wr_en <= 1'b1 ;
    else
      udp_ram_wr_en <= 1'b0 ;
  end
  
always@(posedge gmii_tx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      udp_write_end <= 1'b0 ;
    else if (state == WRITE_RAM && udp_rec_ram_read_addr == udp_rec_data_length - 8)
      udp_write_end <= 1'b1 ;
    else
      udp_write_end <= 1'b0 ;
  end
  
  
endmodule
