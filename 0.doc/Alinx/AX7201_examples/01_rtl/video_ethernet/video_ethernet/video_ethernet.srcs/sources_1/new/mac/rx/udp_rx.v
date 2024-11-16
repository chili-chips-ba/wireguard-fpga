//////////////////////////////////////////////////////////////////////////////////////
//Module Name : udp_rx
//Description : This module is used to receive UDP data and verify UDP checksum
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module udp_rx
       (
         input                  clk,
         input                  rst_n,
         
         input      [7:0]       udp_rx_data,
         input                  udp_rx_req,
         
         input                  mac_rec_error,
         input      [7:0]       net_protocol,
         input      [31:0]      ip_rec_source_addr,
         input      [31:0]      ip_rec_destination_addr,
         input                  ip_checksum_error,
         input                  ip_addr_check_error,
         
         input      [15:0]      upper_layer_data_length,
         output     [7:0]       udp_rec_ram_rdata ,      //udp ram read data
         input      [10:0]      udp_rec_ram_read_addr,   //udp ram read address
         output reg [15:0]      udp_rec_data_length,     //udp data length
         output reg             udp_rec_data_valid       //udp data valid
       );
       
reg  [15:0]             udp_rx_cnt ;
reg                     verify_end ;
reg                     udp_checksum_error ;

reg  [10:0]             ram_write_addr ;
reg                     ram_wr_en ;
reg  [15:0]             udp_data_length ;
reg                     ip_addr_check_error_d0 ;
reg  [7:0]              udp_rx_data_d0 ;         //udp data resigster

parameter IDLE             =  8'b0000_0001  ;
parameter REC_HEAD         =  8'b0000_0010  ;
parameter REC_DATA         =  8'b0000_0100  ;
parameter REC_ODD_DATA     =  8'b0000_1000  ;
parameter VERIFY_CHECKSUM  =  8'b0001_0000  ;
parameter REC_ERROR        =  8'b0010_0000  ;
parameter REC_END_WAIT     =  8'b0100_0000  ;
parameter REC_END          =  8'b1000_0000  ;

reg [7:0]     state      ;
reg [7:0]     next_state ;

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
      IDLE            :
        begin
          if (udp_rx_req == 1'b1)
            next_state <= REC_HEAD ;
          else
            next_state <= IDLE ;
        end
      REC_HEAD       :
        begin
          if (ip_checksum_error)
            next_state <= REC_ERROR ;
          else if (udp_rx_cnt == 16'd7)
            begin
              if (udp_data_length == 16'd9)
                next_state <= REC_ODD_DATA ;
              else
                next_state <= REC_DATA ;
            end
          else if (ip_addr_check_error_d0)
            next_state <= REC_ERROR ;
          else
            next_state <= REC_HEAD ;
        end
      REC_DATA       :
        begin
          if (ip_checksum_error)
            next_state <= REC_ERROR ;
          else if (udp_data_length[0] == 1'b1 && udp_rx_cnt == udp_data_length - 2)
            next_state <= REC_ODD_DATA ;
          else if (udp_data_length[0] == 1'b0 && udp_rx_cnt == udp_data_length - 1)
            next_state <= VERIFY_CHECKSUM ;
          else
            next_state <= REC_DATA ;
        end
      REC_ODD_DATA   :
        begin
          if (ip_checksum_error)
            next_state <= REC_ERROR ;
          else if (udp_rx_cnt == udp_data_length - 1)
            next_state <= VERIFY_CHECKSUM ;
          else
            next_state <= REC_ODD_DATA ;
        end
      VERIFY_CHECKSUM :
        begin
          if (udp_checksum_error)
            next_state <= REC_ERROR ;
          else if (verify_end)
            next_state <= REC_END_WAIT ;
          else if (udp_rx_cnt == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= VERIFY_CHECKSUM ;
        end
      REC_ERROR      :
        next_state <= IDLE  ;
      REC_END_WAIT   :
        begin
          if (udp_rx_cnt == 16'd63)
            next_state <= REC_END ;
          else
            next_state <= REC_END_WAIT ;
        end
      REC_END        :
        next_state <= IDLE  ;
      default        :
        next_state <= IDLE  ;
    endcase
  end
  
  
  
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ram_wr_en <= 1'b0 ;
    else if ((state == REC_DATA || state == REC_ODD_DATA) && udp_rx_cnt < udp_data_length)
      ram_wr_en <= 1'b1 ;
    else
      ram_wr_en <= 1'b0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ram_write_addr <= 11'd0 ;
    else if (state == REC_DATA || state == REC_ODD_DATA)
      ram_write_addr <= udp_rx_cnt - 8 ;
    else
      ram_write_addr <= 11'd0 ;
  end
//ip address check
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ip_addr_check_error_d0 <= 1'b0 ;
    else
      ip_addr_check_error_d0 <= ip_addr_check_error ;
  end
//udp data length
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      udp_data_length <= 16'd0 ;
    else if (state == IDLE)
      udp_data_length <= upper_layer_data_length ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      udp_rec_data_length <= 16'd0 ;
    else if (state == REC_END)
      udp_rec_data_length <= udp_data_length ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      udp_rx_cnt <= 16'd0 ;
    else if (state == REC_HEAD || state == REC_DATA  || state == REC_END_WAIT)
      udp_rx_cnt <= udp_rx_cnt + 1'b1 ;
    else
      udp_rx_cnt <= 16'd0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      udp_rx_data_d0 <= 8'd0 ;
    else
      udp_rx_data_d0 <= udp_rx_data ;
  end
  
dpram
  #(
    .WIDTH(8),
    .DEPTH(11)
  )
  udp_receive_ram
  (
    .clock      (clk             ),
    .data       (udp_rx_data_d0     ),
    .rdaddress  (udp_rec_ram_read_addr  ),
    .wraddress  (ram_write_addr  ),
    .wren       (ram_wr_en       ),
    .q          (udp_rec_ram_rdata     )
  );
  
  
//****************************************************************//
//verify checksum
//****************************************************************//
reg  [16:0] checksum_tmp0 ;
reg  [16:0] checksum_tmp1 ;
reg  [16:0] checksum_tmp2 ;
reg  [17:0] checksum_tmp3 ;
reg  [18:0] checksum_tmp4 ;
reg  [31:0] checksum_tmp5 ;
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
    input       [31:0]  dataina
  );
  
  begin
    checksum_out = dataina[15:0]+dataina[31:16];
  end
  
endfunction

always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      begin
        checksum_tmp0 <= 17'd0 ;
        checksum_tmp1 <= 17'd0 ;
        checksum_tmp2 <= 17'd0 ;
        checksum_tmp3 <= 18'd0 ;
        checksum_tmp4 <= 19'd0 ;
      end
    else if (state == REC_HEAD)
      begin
        checksum_tmp0 <= checksum_adder(ip_rec_source_addr[31:16],ip_rec_source_addr[15:0]);  //source ip address
        checksum_tmp1 <= checksum_adder(ip_rec_destination_addr[31:16],ip_rec_destination_addr[15:0]);     //destination ip address
        checksum_tmp2 <= checksum_adder({8'd0,net_protocol},udp_data_length);                   //protocol type
        checksum_tmp3 <= checksum_adder(checksum_tmp0,checksum_tmp1);                   //protocol type
        checksum_tmp4 <= checksum_adder(checksum_tmp2,checksum_tmp3);
      end
    else if (state == IDLE)
      begin
        checksum_tmp0 <= 17'd0 ;
        checksum_tmp1 <= 17'd0 ;
        checksum_tmp2 <= 17'd0 ;
        checksum_tmp3 <= 18'd0 ;
        checksum_tmp4 <= 19'd0 ;
      end
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      checksum_tmp5 <= 32'd0;
    else if (state == REC_HEAD || state == REC_DATA)
      begin
        if (udp_rx_cnt[0] == 1'b1)
          checksum_tmp5 <= checksum_adder({udp_rx_data_d0,udp_rx_data},checksum_buf);
      end
    else if (state == REC_ODD_DATA)
      checksum_tmp5 <= checksum_adder({udp_rx_data,8'h00},checksum_tmp5);   //if udp data length is odd, fill with one byte 8'h00
    else if (state == IDLE)
      checksum_tmp5 <= 32'd0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      checksum_cnt <= 3'd0 ;
    else if (state ==  VERIFY_CHECKSUM)
      checksum_cnt <= checksum_cnt + 1'b1 ;
    else
      checksum_cnt <= 3'd0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      check_out <= 32'd0;
    else if (state ==  VERIFY_CHECKSUM)
      begin
        if(checksum_cnt == 3'd0)
          check_out <= checksum_adder(checksum_tmp4, checksum_tmp5);
        else if (checksum_cnt == 3'd1)
          check_out <= checksum_out(check_out) ;
        else if (checksum_cnt == 3'd2)
          check_out <= checksum_out(check_out) ;
      end
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      checksum_buf <= 32'd0 ;
    else if (state == REC_HEAD || state == REC_DATA)
      checksum_buf <= checksum_tmp5 ;
    else
      checksum_buf <= 32'd0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      checkout_buf <= 32'd0 ;
    else if (state ==  VERIFY_CHECKSUM)
      checkout_buf <= check_out ;
    else
      checkout_buf <= 32'd0 ;
  end
  
assign checksum = ~checkout_buf[15:0] ;
//**************************************************//
//generate udp rx end
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      begin
        udp_checksum_error <= 1'b0 ;
        verify_end <= 1'b0 ;
      end
    else if (state == VERIFY_CHECKSUM && checksum_cnt == 3'd4)
      begin
        if (checksum == 16'd0)
          begin
            udp_checksum_error <= 1'b0 ;
            verify_end <= 1'b1 ;
          end
        else
          begin
            udp_checksum_error <= 1'b1 ;
            verify_end <= 1'b0 ;
          end
      end
    else
      begin
        udp_checksum_error <= 1'b0 ;
        verify_end <= 1'b0 ;
      end
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      udp_rec_data_valid <= 1'b0 ;
    else if (state == REC_END_WAIT)
      udp_rec_data_valid <= 1'b0 ;
    else if (state == REC_END)
      begin
        if (mac_rec_error)
          udp_rec_data_valid <= 1'b0 ;
        else
          udp_rec_data_valid <= 1'b1 ;
      end
  end
  
  
endmodule
