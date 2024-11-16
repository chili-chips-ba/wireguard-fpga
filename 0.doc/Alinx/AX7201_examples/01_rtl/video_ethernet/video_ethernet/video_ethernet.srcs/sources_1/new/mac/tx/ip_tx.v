//////////////////////////////////////////////////////////////////////////////////////
//Module Name : ip_tx
//Description : This module is used to send ip layer data, generate ip header checksum,
//              receive data from udp or icmp, then send to mac layer
//
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module ip_tx
       (
         input                clk                    ,
         input                rst_n                  ,
         input  [15:0]        identify_code,
         input  [47:0]        destination_mac_addr   ,  //destination mac address
         input  [47:0]        source_mac_addr        ,  //source mac address
         input  [7:0]         TTL,
         input  [7:0]         ip_send_type,
         input  [31:0]        source_ip_addr,
         input  [31:0]        destination_ip_addr,
         input  [7:0]         upper_layer_data,         //data from udp or icmp
         output reg           upper_data_req,        //request data from udp or icmp
         
         input                mac_data_req,
         input                upper_tx_ready,
         input                ip_tx_req,
         input  [15:0]        ip_send_data_length ,
         
         output               ip_tx_busy,
         output reg           ip_tx_ready,
         output reg [7:0]     ip_tx_data,
         output reg           ip_tx_end
       ) ;
       
localparam mac_type      = 16'h0800 ;
localparam ip_version    = 4'h4     ;  //ipv4
localparam header_len    = 4'h5     ;  //header length

reg            checksum_finish ;

reg  [15:0]    ip_send_data_length_d0 ;
reg  [15:0]    ip_send_cnt ;
reg  [15:0]    timeout ;
reg  [3:0]     wait_cnt ;

parameter IDLE             = 6'b000_001 ;
parameter WAIT_DATA_LENGTH = 6'b000_010 ;
parameter GEN_CHECKSUM     = 6'b000_100 ;
parameter SEND_WAIT        = 6'b001_000 ;
parameter WAIT_MAC         = 6'b010_000 ;
parameter IP_SEND          = 6'b100_000 ;

reg [5:0]    state  ;
reg [5:0]    next_state ;

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
          if (ip_tx_req)
            next_state <= WAIT_DATA_LENGTH ;
          else
            next_state <= IDLE ;
        end
        
      WAIT_DATA_LENGTH   :
        begin
          if (wait_cnt == 4'd7)
            next_state <= GEN_CHECKSUM ;
          else
            next_state <= WAIT_DATA_LENGTH ;
        end
      GEN_CHECKSUM     :
        begin
          if (checksum_finish)
            next_state <= SEND_WAIT ;
          else
            next_state <= GEN_CHECKSUM ;
        end
        
      SEND_WAIT       :
        begin
          if (upper_tx_ready)
            next_state <= WAIT_MAC ;
          else if (timeout == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= SEND_WAIT ;
        end
      WAIT_MAC         :
        begin
          if (mac_data_req)
            next_state <= IP_SEND ;
          else if (timeout == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= WAIT_MAC ;
        end
      IP_SEND         :
        begin
          if (ip_send_cnt == 14 + ip_send_data_length_d0)
            next_state <= IDLE ;
          else
            next_state <= IP_SEND ;
        end
      default          :
        next_state <= IDLE ;
    endcase
  end
  
  
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ip_tx_ready <= 1'b0 ;
    else if (state == WAIT_MAC)
      ip_tx_ready <= upper_tx_ready ;
    else
      ip_tx_ready <= 1'b0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ip_tx_end <= 1'b0 ;
    else if ((state == IP_SEND) && (ip_send_cnt == 13 + ip_send_data_length_d0))
      ip_tx_end <= 1'b1 ;
    else
      ip_tx_end <= 1'b0 ;
  end
  
//request data from icmp or udp
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      upper_data_req <= 1'b0 ;
    else if (state == IP_SEND && ip_send_cnt == 16'd30)
      upper_data_req <= 1'b1 ;
    else
      upper_data_req <= 1'b0 ;
  end
  
//timeout counter
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      timeout <= 16'd0 ;
    else if (upper_tx_ready)
      timeout <= 16'd0 ;
    else if (state == SEND_WAIT || state == WAIT_MAC)
      timeout <= timeout + 1'b1 ;
    else
      timeout <= 16'd0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      wait_cnt <= 4'd0 ;
    else if (state == WAIT_DATA_LENGTH)
      wait_cnt <= wait_cnt + 1'b1 ;
    else
      wait_cnt <= 4'd0 ;
  end
  
//always @(posedge clk or negedge rst_n)
//begin
//  if (~rst_n)
//    identify_code  <= 16'd0 ;
//  else if (ip_tx_end)
//    identify_code  <= identify_code + 1'b1 ;
//end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ip_send_data_length_d0  <= 16'd0 ;
    else
      begin
        if (ip_send_data_length < 46)
          ip_send_data_length_d0  <= 16'd46 ;
        else
          ip_send_data_length_d0  <= ip_send_data_length ;
      end
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ip_send_cnt  <= 16'd0 ;
    else if (state == GEN_CHECKSUM || state == IP_SEND)
      ip_send_cnt <= ip_send_cnt + 1'b1 ;
    else
      ip_send_cnt <= 16'd0 ;
  end
//checksum generation

reg  [16:0] checksum_tmp0 ;
reg  [16:0] checksum_tmp1 ;
reg  [16:0] checksum_tmp2 ;
reg  [16:0] checksum_tmp3 ;
reg  [16:0] checksum_tmp4 ;
reg  [17:0] checksum_tmp5 ;
reg  [17:0] checksum_tmp6 ;
reg  [18:0] checksum_tmp7 ;
reg  [19:0] checksum_tmp8 ;
reg  [19:0] check_out ;
reg  [19:0] checkout_buf ;
reg  [15:0] checksum ;


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
    input       [31:0]  dataina
  );
  
  begin
    checksum_out = dataina[15:0]+dataina[31:16];
  end
  
endfunction


always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      begin
        checksum_tmp0 <= 17'd0 ;
        checksum_tmp1 <= 17'd0 ;
        checksum_tmp2 <= 17'd0 ;
        checksum_tmp3 <= 17'd0 ;
        checksum_tmp4 <= 17'd0 ;
        checksum_tmp5 <= 18'd0 ;
        checksum_tmp6 <= 18'd0 ;
        checksum_tmp7 <= 19'd0 ;
        checksum_tmp8 <= 20'd0 ;
        check_out     <= 20'd0 ;
        checkout_buf  <= 20'd0 ;
      end
    else if (state == GEN_CHECKSUM)
      begin
        checksum_tmp0 <= checksum_adder(16'h4500,ip_send_data_length);
        checksum_tmp1 <= checksum_adder(identify_code, 16'h4000) ;
        checksum_tmp2 <= checksum_adder({TTL,ip_send_type}, 16'h0000) ;
        checksum_tmp3 <= checksum_adder(source_ip_addr[31:16], source_ip_addr[15:0]) ;
        checksum_tmp4 <= checksum_adder(destination_ip_addr[31:16], destination_ip_addr[15:0]) ;
        checksum_tmp5 <= checksum_adder(checksum_tmp0, checksum_tmp1) ;
        checksum_tmp6 <= checksum_adder(checksum_tmp2, checksum_tmp3) ;
        checksum_tmp7 <= checksum_adder(checksum_tmp5, checksum_tmp6) ;
        checksum_tmp8 <= checksum_adder(checksum_tmp4, checksum_tmp7) ;
        check_out     <= checksum_out(checksum_tmp8) ;
        checkout_buf  <= checksum_out(check_out) ;
      end
    else if (state == IDLE)
      begin
        checksum_tmp0 <= 17'd0 ;
        checksum_tmp1 <= 17'd0 ;
        checksum_tmp2 <= 17'd0 ;
        checksum_tmp3 <= 17'd0 ;
        checksum_tmp4 <= 17'd0 ;
        checksum_tmp5 <= 18'd0 ;
        checksum_tmp6 <= 18'd0 ;
        checksum_tmp7 <= 19'd0 ;
        checksum_tmp8 <= 20'd0 ;
        check_out     <= 20'd0 ;
        checkout_buf  <= 20'd0 ;
      end
  end
  
  
  
  
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      checksum <= 32'd0 ;
    else if (state == GEN_CHECKSUM)
      checksum <= ~checkout_buf[15:0] ;
  end
//assign checksum = ~checkout_buf[15:0] ;
//*******************************************************//

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      checksum_finish <= 1'b0 ;
    else if (state == GEN_CHECKSUM && ip_send_cnt == 16'd13)
      checksum_finish <= 1'b1 ;
    else
      checksum_finish <= 1'b0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ip_tx_data <= 8'h00 ;
    else if (state == IP_SEND)
      begin
        case(ip_send_cnt)
          16'd0   :  ip_tx_data <= destination_mac_addr[47:40]  ;
          16'd1   :  ip_tx_data <= destination_mac_addr[39:32]  ;
          16'd2   :  ip_tx_data <= destination_mac_addr[31:24]  ;
          16'd3   :  ip_tx_data <= destination_mac_addr[23:16]  ;
          16'd4   :  ip_tx_data <= destination_mac_addr[15:8]   ;
          16'd5   :  ip_tx_data <= destination_mac_addr[7:0]    ;
          16'd6   :  ip_tx_data <= source_mac_addr[47:40]       ;
          16'd7   :  ip_tx_data <= source_mac_addr[39:32]       ;
          16'd8   :  ip_tx_data <= source_mac_addr[31:24]       ;
          16'd9   :  ip_tx_data <= source_mac_addr[23:16]       ;
          16'd10  :  ip_tx_data <= source_mac_addr[15:8]        ;
          16'd11  :  ip_tx_data <= source_mac_addr[7:0]         ;
          16'd12  :  ip_tx_data <= mac_type[15:8]               ;
          16'd13  :  ip_tx_data <= mac_type[7:0]                ;
          16'd14  :  ip_tx_data <= {ip_version, header_len}     ;
          16'd15  :  ip_tx_data <= 8'h00                        ;
          16'd16  :  ip_tx_data <= ip_send_data_length[15:8]    ;
          16'd17  :  ip_tx_data <= ip_send_data_length[7:0]     ;
          16'd18  :  ip_tx_data <= identify_code[15:8]          ;
          16'd19  :  ip_tx_data <= identify_code[7:0]           ;
          16'd20  :  ip_tx_data <= 8'h40                        ;
          16'd21  :  ip_tx_data <= 8'h00                        ;
          16'd22  :  ip_tx_data <= TTL                          ;
          16'd23  :  ip_tx_data <= ip_send_type                 ;
          16'd24  :  ip_tx_data <= checksum[15:8]               ;
          16'd25  :  ip_tx_data <= checksum[7:0]                ;
          16'd26  :  ip_tx_data <= source_ip_addr[31:24]        ;
          16'd27  :  ip_tx_data <= source_ip_addr[23:16]        ;
          16'd28  :  ip_tx_data <= source_ip_addr[15:8]         ;
          16'd29  :  ip_tx_data <= source_ip_addr[7:0]          ;
          16'd30  :  ip_tx_data <= destination_ip_addr[31:24]   ;
          16'd31  :  ip_tx_data <= destination_ip_addr[23:16]   ;
          16'd32  :  ip_tx_data <= destination_ip_addr[15:8]    ;
          16'd33  :  ip_tx_data <= destination_ip_addr[7:0]     ;
          default :  ip_tx_data <= upper_layer_data             ;
        endcase
      end
    else
      ip_tx_data  <= 8'h00 ;
  end
  
  
  
endmodule
