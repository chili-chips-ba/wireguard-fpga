`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module gmii_arbi
(
 input                 clk,
 input                 rst_n,
 input  [1:0]          speed,  
 input                 link,                                            
(* MARK_DEBUG="true" *)input                 gmii_rx_dv,
(* MARK_DEBUG="true" *)input  [7:0]          gmii_rxd,
(* MARK_DEBUG="true" *)input                 gmii_tx_en,
(* MARK_DEBUG="true" *)input  [7:0]          gmii_txd,                       
output reg [31:0]     pack_total_len,     //delay time
output                e_rst_n,
(* MARK_DEBUG="true" *)output reg            e_rx_dv,
(* MARK_DEBUG="true" *)output reg [7:0]      e_rxd,
(* MARK_DEBUG="true" *)output reg            e_tx_en,
(* MARK_DEBUG="true" *)output reg [7:0]      e_txd
);

reg                    eth_1000m_en    ;
wire                   eth_10_100m_en  ;
reg                    eth_100m_en     ;
reg                    eth_10m_en      ;
reg [1:0]              speed_d0        ;
reg [1:0]              speed_d1        ;
reg [1:0]              speed_d2        ;
reg                    link_d0         ;
reg                    link_d1         ;
reg                    link_d2         ;
                       
wire                   e10_100_tx_en   ;
wire [7:0]             e10_100_txd     ;
wire                   e10_100_rx_dv   ;
wire [7:0]             e10_100_rxd     ;

reg                    e_rst_en        ;
reg [7:0]              e_rst_cnt       ;

assign e_rst_n = link_d2 & e_rst_en ;

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	begin
	  speed_d0 <= 2'b00 ;
	  speed_d1 <= 2'b00 ;
	  speed_d2 <= 2'b00 ;
	  link_d0  <= 1'b0 ;
	  link_d1  <= 1'b0 ;
	  link_d2  <= 1'b0 ;
	end
	else
	begin
	  speed_d0 <= speed    ;
	  speed_d1 <= speed_d0 ;
	  speed_d2 <= speed_d1 ;
	  link_d0  <= link     ;
	  link_d1  <= link_d0  ;
	  link_d2  <= link_d1  ;
	end
  end



always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	begin
	  eth_1000m_en   <= 1'b0  ;
	  eth_100m_en    <= 1'b0 ;
	  eth_10m_en     <= 1'b0 ;
	  pack_total_len <= 32'd2500000 ;
	end
	else if (speed_d2 == 2'b10)           //1000M
	begin
	  eth_1000m_en   <= 1'b1 ;
	  eth_100m_en    <= 1'b0 ;
	  eth_10m_en     <= 1'b0 ;
	  pack_total_len <= 32'd125000000 ;   //1s
	end
	else if (speed_d2 == 2'b01)           //100M
	begin
	  eth_1000m_en   <= 1'b0  ;
	  eth_100m_en    <= 1'b1  ;
	  eth_10m_en     <= 1'b0  ;
	  pack_total_len <= 32'd25000000 ;    //1s
	end 
	else if (speed_d2 == 2'b00)           //10M
	begin
	  eth_1000m_en   <= 1'b0  ;
	  eth_100m_en    <= 1'b0  ;
	  eth_10m_en     <= 1'b1  ;
	  pack_total_len <= 32'd2500000 ;     //1s
	end
	 
  end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	begin
	  e_rx_dv   <= 1'b0 ;
	  e_rxd     <= 8'd0 ;
	  e_tx_en   <= 1'b0 ;
	  e_txd     <= 8'd0 ;
	end
	else if (eth_1000m_en)
	begin
	  e_rx_dv   <= gmii_rx_dv  ;
	  e_rxd     <= gmii_rxd    ;
	  e_tx_en   <= gmii_tx_en  ;
	  e_txd     <= gmii_txd    ;
	end
	else if (eth_100m_en | eth_10m_en)
	begin
	  e_rx_dv   <= e10_100_rx_dv ;
	  e_rxd     <= e10_100_rxd   ;
	  e_tx_en   <= e10_100_tx_en ;
	  e_txd     <= e10_100_txd   ;
	end
  end  


 
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      e_rst_en <= 1'b1 ;
    else if (speed_d2 != speed_d1)
      e_rst_en <= 1'b0 ;
    else if (e_rst_cnt == 8'd200)
	   e_rst_en <= 1'b1 ;
  end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      e_rst_cnt <= 8'd0 ;
    else if (~e_rst_en)
      e_rst_cnt <= e_rst_cnt + 1'b1 ;	  
    else 
	  e_rst_cnt <= 8'd0 ;
  end  

assign eth_10_100m_en = eth_100m_en | eth_10m_en ;

gmii_tx_buffer tx_buffer_inst
(
 .clk                    (clk                 ),
 .rst_n                  (e_rst_n             ), 
 .eth_10_100m_en         (eth_10_100m_en      ),
 .link                   (e_rst_n             ),
 .gmii_tx_en             (gmii_tx_en          ),
 .gmii_txd               (gmii_txd            ), 
 .e10_100_tx_en          (e10_100_tx_en       ),
 .e10_100_txd            (e10_100_txd         ) 
);
	

gmii_rx_buffer  rx_buffer_inst
(
 .clk                    (clk                 ),
 .rst_n                  (e_rst_n             ),
 .link                   (e_rst_n             ),
 .eth_100m_en            (eth_100m_en         ),
 .eth_10m_en             (eth_10m_en          ),
 .gmii_rx_dv             (gmii_rx_dv          ),
 .gmii_rxd               (gmii_rxd            ), 
 .e10_100_rx_dv          (e10_100_rx_dv       ),
 .e10_100_rxd            (e10_100_rxd         )
 
);
    
endmodule
