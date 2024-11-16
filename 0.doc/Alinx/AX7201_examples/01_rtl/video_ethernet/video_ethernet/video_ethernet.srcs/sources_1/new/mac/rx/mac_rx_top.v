//////////////////////////////////////////////////////////////////////////////////////
//Module Name : mac_rx_top
//Description : MAC RX Top
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module mac_rx_top
       (
         input                  clk,
         input                  rst_n,
         
         input                  rx_dv,
         input  [7:0]           mac_rx_datain,
         
         input [31:0]           local_ip_addr,
         input [47:0]           local_mac_addr,
         
         input                  arp_reply_ack,
         output                 arp_reply_req,
         output [31:0]          arp_rec_source_ip_addr,
         output [47:0]          arp_rec_source_mac_addr,
         // output [31:0]          ip_rec_source_ip_addr,
         
         
         output [7:0]           udp_rec_ram_rdata ,
         input  [10:0]          udp_rec_ram_read_addr,
         output [15:0]          udp_rec_data_length,
         output                 udp_rec_data_valid,
         
         output [7:0]           mac_rx_dataout,
         output [15:0]          upper_layer_data_length ,
         output [15:0]          ip_total_data_length,
         output                 icmp_rx_req,
         output                 icmp_rev_error,
         
         output                 arp_found
       ) ;
       
wire                    ip_rx_req ;
wire                    udp_rx_req ;
wire                    ip_rx_end ;

wire                    arp_rx_req ;
wire                    arp_rx_end  ;

wire [7:0]              net_protocol ;

wire [31:0]             ip_rec_destination_addr ;
wire [31:0]             ip_rec_source_ip_addr ;
wire                    ip_addr_check_error  ;
wire                    ip_checksum_error ;
wire                    mac_rec_error ;

wire [47:0]             mac_rx_destination_mac_addr ;
wire [47:0]             mac_rx_source_mac_addr ;

wire                    crcen ;
wire                    crcre ;
wire [7:0]              crc_din ;
wire [31:0]             crc_result ;



assign  icmp_rev_error = (mac_rec_error | ip_checksum_error | ip_addr_check_error)  ;


crc c0
    (
      .Clk                           (clk),
      .Reset                         (crcre),
      .Data_in                       (crc_din),
      .Enable                        (crcen),
      .Crc                           (crc_result),
      .CrcNext                       ()
    ) ;
    
mac_rx mac0
       (
         .clk                           (clk)   ,
         .rst_n                         (rst_n)   ,
         
         .rx_dv                         (rx_dv   ),
         .mac_rx_datain                 (mac_rx_datain ),
         
         .crc_result                    (crc_result ) ,
         .crcen                         (crcen  ),
         .crcre                         (crcre  ),
         .crc_din                       (crc_din ),
         
         .checksum_err                  (ip_checksum_error  ),
         
         .ip_rx_end                     (ip_rx_end  ),
         .arp_rx_end                    (arp_rx_end),
         
         .ip_rx_req                     (ip_rx_req ),
         .arp_rx_req                    (arp_rx_req),
         
         .mac_rx_dataout                (mac_rx_dataout ),
         .mac_rec_error                 (mac_rec_error),
         
         .mac_rx_destination_mac_addr   (mac_rx_destination_mac_addr ),
         .mac_rx_source_mac_addr        (mac_rx_source_mac_addr)
       );
       
       
ip_rx ip0
      (
        .clk                           (clk),
        .rst_n                         (rst_n) ,
        
        .ip_rx_data                    (mac_rx_dataout) ,
        .ip_rx_req                     (ip_rx_req)  ,
        .ip_rx_end                     (ip_rx_end) ,
        .icmp_rx_req                   (icmp_rx_req ),
        
        .local_ip_addr                 (local_ip_addr ),
        .local_mac_addr                (local_mac_addr),
        
        .ip_addr_check_error           (ip_addr_check_error),
        .mac_rx_destination_mac_addr   (mac_rx_destination_mac_addr),
        
        .upper_layer_data_length       (upper_layer_data_length  ),
        .ip_total_data_length          (ip_total_data_length    ),
        
        .net_protocol                  (net_protocol),
        .ip_rec_source_addr            (ip_rec_source_ip_addr),
        .ip_rec_destination_addr       (ip_rec_destination_addr),
        .udp_rx_req                    (udp_rx_req),
        .ip_checksum_error             (ip_checksum_error)
        
      ) ;
      
      
udp_rx udp0
       (
         .clk                           (clk)   ,
         .rst_n                         (rst_n) ,
         
         .udp_rx_data                   (mac_rx_dataout),
         .udp_rx_req                    (udp_rx_req),
         
         .mac_rec_error                 (mac_rec_error),
         
         .ip_addr_check_error           (ip_addr_check_error),
         
         .net_protocol                  (net_protocol),
         .ip_rec_source_addr            (ip_rec_source_ip_addr),
         .ip_rec_destination_addr       (ip_rec_destination_addr),
         .ip_checksum_error             (ip_checksum_error),
         
         .upper_layer_data_length       (upper_layer_data_length  ),
         
         .udp_rec_ram_rdata             (udp_rec_ram_rdata),
         .udp_rec_ram_read_addr         (udp_rec_ram_read_addr),
         .udp_rec_data_length           (udp_rec_data_length ),
         
         .udp_rec_data_valid            (udp_rec_data_valid)
       );
       
       
arp_rx  arp0
        (
          .clk                           (clk) ,
          .rst_n                         (rst_n),
          
          .local_ip_addr                 (local_ip_addr ),
          .local_mac_addr                (local_mac_addr),
          
          .arp_rx_data                   (mac_rx_dataout ),
          .arp_rx_req                    (arp_rx_req ),
          
          .arp_reply_ack                 (arp_reply_ack ),
          .arp_rx_end                    (arp_rx_end ),
          .arp_reply_req                 (arp_reply_req ),
          
          .arp_rec_source_ip_addr        (arp_rec_source_ip_addr ),
          .arp_rec_source_mac_addr       (arp_rec_source_mac_addr ),
          .arp_found                     (arp_found )
          
        ) ;
        
        
endmodule
