//////////////////////////////////////////////////////////////////////////////////////
//Module Name : mac_tx_top
//Description : MAC TX Top module
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module mac_tx_top
       (
         input                clk                    ,
         input                rst_n                  ,
         input  [15:0]        identify_code,
         input  [47:0]        destination_mac_addr   , //destination mac address
         input  [47:0]        source_mac_addr        ,       //source mac address
         input  [7:0]         TTL,
         input  [31:0]        source_ip_addr,
         input  [31:0]        destination_ip_addr,
         input  [15:0]        udp_send_source_port,
         input  [15:0]        udp_send_destination_port,
         
         output               arp_reply_ack,
         input                arp_reply_req,
         input  [31:0]        arp_rec_source_ip_addr,
         input  [47:0]        arp_rec_source_mac_addr,
         input                arp_request_req,
         
         input [7:0]          fifo_data,                //FIFO中的数据
         output               fifo_rd_en,            //FIFO读使�?
         
         input  [7:0]         ram_wr_data,
         input                ram_wr_en,
         input                udp_tx_req,
         output               udp_ram_data_req,
         input  [15:0]        udp_send_data_length,
         
         output               upper_data_req,
         input                icmp_tx_ready,
         input  [7:0]         icmp_tx_data,
         input                icmp_tx_end,
         input                icmp_tx_req,
         input  [15:0]        icmp_send_data_length,
         
         output               mac_data_valid,
         output               mac_send_end,
         output [7:0]         mac_tx_data
       ) ;
       
       
wire                  crcen ;
wire                  crcre ;
wire [7:0]            crc_din ;
wire [31:0]           crc_result ;

wire                  mac_data_req ;
wire [7:0]            mac_frame_data ;
wire                  mac_tx_ready ;
wire                  mac_tx_end ;

wire                  ip_tx_ready ;
wire [7:0]            ip_tx_data ;
wire                  ip_tx_end ;

wire                  arp_tx_ready ;
wire [7:0]            arp_tx_data ;
wire                  arp_tx_end ;


wire [15:0]           ip_send_data_length ;


wire [7:0]            udp_tx_data ;
wire                  udp_data_req ;
wire                  udp_tx_ready ;

wire                  upper_tx_ready ;
wire [7:0]            upper_layer_data ;
wire                  ip_tx_req ;



wire [7:0]            ip_send_type ;


assign ip_tx_req = (icmp_tx_req | udp_tx_req) ;

mac_tx mac0
       (
         .clk                        (clk             ),
         .rst_n                      (rst_n           ),
         
         .crc_result                 (crc_result      ),
         .crcen                      (crcen           ),
         .crcre                      (crcre           ),
         .crc_din                    (crc_din         ),
         
         .mac_frame_data             (mac_frame_data  ),
         .mac_tx_ready               (mac_tx_ready    ),
         .mac_tx_end                 (mac_tx_end      ) ,
         
         .mac_tx_data                (mac_tx_data     ),
         .mac_send_end               (mac_send_end    ),
         .mac_data_valid             (mac_data_valid  ),
         .mac_data_req               (mac_data_req    )
         
       ) ;
       
mac_tx_mode mode0
            (
              .clk                        (clk               ),
              .rst_n                      (rst_n             ),
              .arp_tx_ready               (arp_tx_ready      ),
              .arp_tx_data                (arp_tx_data       ),
              .arp_tx_end                 (arp_tx_end        ),
              
              
              .ip_tx_ready                (ip_tx_ready       ),
              .ip_tx_data                 (ip_tx_data        ),
              .ip_tx_end                  (ip_tx_end         ),
              
              
              .mac_tx_ready               (mac_tx_ready      ),
              .mac_tx_data                (mac_frame_data    ),
              .mac_tx_end                 (mac_tx_end        )
            );
            
crc c0
    (
      .Clk                        (clk         ),
      .Reset                      (crcre       ),
      .Data_in                    (crc_din     ),
      .Enable                     (crcen       ),
      .Crc                        (crc_result  ),
      .CrcNext                    (            )
    ) ;
    
arp_tx arp_tx0
       (
         .clk                        (clk                  ) ,
         .rst_n                      (rst_n                ) ,
         
         .destination_mac_addr       (destination_mac_addr ) , //destination mac address
         .source_mac_addr            (source_mac_addr      ) , //source mac address
         .source_ip_addr             (source_ip_addr       ) , //source ip address
         .destination_ip_addr        (destination_ip_addr  ) , //destination ip address
         
         .mac_data_req               (mac_data_req         ) ,
         
         .arp_request_req            (arp_request_req         ) ,         //arp request
         .arp_reply_ack              (arp_reply_ack ),
         .arp_reply_req              (arp_reply_req ),
         .arp_rec_source_ip_addr     (arp_rec_source_ip_addr ),
         .arp_rec_source_mac_addr    (arp_rec_source_mac_addr ),
         .arp_tx_ready               (arp_tx_ready         ) ,
         .arp_tx_data                (arp_tx_data          ) ,
         .arp_tx_end                 (arp_tx_end           ) 
       ) ;
       
       
ip_tx ip0
      (
        .clk                          (clk                        ),
        .rst_n                        (rst_n                      ),
        .destination_mac_addr         (destination_mac_addr       ), //destination mac address
        .source_mac_addr              (source_mac_addr            ),       //source mac address
        .ip_send_data_length          (ip_send_data_length        ),
        .TTL                          (TTL                        ),
        .ip_send_type                 (ip_send_type               ),
        .source_ip_addr               (source_ip_addr             ),
        .destination_ip_addr          (destination_ip_addr        ),
        .upper_layer_data             (upper_layer_data           ),
        .upper_data_req               (upper_data_req             ),
        .upper_tx_ready               (upper_tx_ready             ),
        .ip_tx_req                    (ip_tx_req                   ),
        .mac_data_req                 (mac_data_req               ),
        .identify_code                (identify_code       ),
        
        .ip_tx_ready                  (ip_tx_ready                ),
        .ip_tx_data                   (ip_tx_data                 ),
        .ip_tx_end                    (ip_tx_end                  )
      ) ;
      
ip_tx_mode ipmode
           (
             .clk                          (clk                        ),
             .rst_n                        (rst_n                      ),
             .mac_tx_end                   (mac_tx_end                 ),
             
             .udp_tx_ready                 (udp_tx_ready               ),
             .udp_tx_data                  (udp_tx_data                ),
             .udp_send_data_length         (udp_send_data_length       ),
             
             
             .icmp_tx_ready                (icmp_tx_ready              ),
             .icmp_tx_data                 (icmp_tx_data               ),
             .icmp_send_data_length        (icmp_send_data_length      ),
             
             
             .ip_tx_ready                  (upper_tx_ready             ),
             .ip_tx_data                   (upper_layer_data           ),
             .ip_send_type                 (ip_send_type               ),
             .ip_send_data_length          (ip_send_data_length        )
             
             
           );
           
udp_tx udp0
       (
         .clk                            (clk                        ),
         .rst_n                          (rst_n                      ),
         .source_ip_addr                 (source_ip_addr             ),
         .destination_ip_addr            (destination_ip_addr        ),
         .udp_send_source_port           (udp_send_source_port       ),
         .udp_send_destination_port      (udp_send_destination_port  ),
         .udp_send_data_length           (udp_send_data_length       ),
         .udp_ram_data_req               (udp_ram_data_req           ),
         
         .fifo_data                      (fifo_data),
         .fifo_rd_en                     (fifo_rd_en),
         
         .ram_wr_data                    (ram_wr_data                ),
         .ram_wr_en                      (ram_wr_en                  ),
         .udp_tx_req                     (udp_tx_req                 ),
         .udp_data_req                   (upper_data_req             ),
         .udp_tx_ready                   (udp_tx_ready               ),
         .udp_tx_data                    (udp_tx_data                ),
         .udp_tx_end                     (                           )
       ) ;
       
endmodule

