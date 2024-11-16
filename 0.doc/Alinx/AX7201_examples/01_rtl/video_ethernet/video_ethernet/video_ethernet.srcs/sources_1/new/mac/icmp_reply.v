//////////////////////////////////////////////////////////////////////////////////////
//Module Name : icmp_reply
//Description : This module is used to receive icmp and reply
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module icmp_reply
       (
         input                  clk,
         input                  rst_n,
         
         input  [7:0]           icmp_rx_data,             //received data
         input                  icmp_rx_req,              //receive request
         input                  icmp_rev_error,           //receive error from MAC or IP
         input  [15:0]          upper_layer_data_length,    //data length received from IP layer
         
         input                  icmp_data_req,            //IP layer request data
         output reg             icmp_tx_ready,            //icmp reply data ready
         output reg [7:0]       icmp_tx_data,             //icmp reply data
         output                 icmp_tx_end,              //icmp reply end
         output reg             icmp_tx_req               //icmp reply request
         
       );
       
localparam ECHO_REQUEST = 8'h08 ;
localparam ECHO_REPLY   = 8'h00 ;

reg  [15:0]             icmp_rx_cnt ;

reg                     icmp_rx_end ;
reg                     icmp_checksum_error ;     //icmp receive checksum error
reg                     icmp_type_error ;         //if icmp type is not 8'h08, do not reply
reg  [15:0]             icmp_data_length ;        //data length register
reg  [15:0]             icmp_data_length_d0 ;
reg  [10:0]             icmp_rec_ram_read_addr ;  //icmp ram read address
wire [7:0]              icmp_rec_ram_rdata ;      //icmp ram read data
reg  [7:0]              icmp_code  ;              //icmp code
reg  [15:0]             icmp_id  ;                //icmp id
reg  [15:0]             icmp_seq ;                //icmp seq
reg                     checksum_finish ;         //icmp reply checksum generated finish

reg [10:0]              ram_write_addr ;          //icmp ram write address, when receive icmp, write ram
reg                     ram_wr_en ;               //icmp ram write enable
reg                     icmp_rev_error_d0 ;

reg  [15:0]             timeout ;                 //timeout counter
reg  [7:0]              icmp_rx_data_d0 ;         //register for receive data

//receive and reply FSM
parameter IDLE             =  11'b0000_0000_001  ;
parameter REC_DATA         =  11'b0000_0000_010  ;
parameter REC_ODD_DATA     =  11'b0000_0000_100  ;
parameter VERIFY_CHECKSUM  =  11'b0000_0001_000  ;
parameter REC_ERROR        =  11'b0000_0010_000  ;
parameter REC_END_WAIT     =  11'b0000_0100_000  ;
parameter GEN_CHECKSUM     =  11'b0000_1000_000  ;
parameter SEND_WAIT        =  11'b0001_0000_000  ;
parameter SEND             =  11'b0010_0000_000  ;
parameter REC_END          =  11'b0100_0000_000  ;
parameter SEND_END         =  11'b1000_0000_000  ;



reg [10:0]     state      ;
reg [10:0]     next_state ;

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
          if (icmp_rx_req == 1'b1)
            next_state <= REC_DATA ;
          else
            next_state <= IDLE ;
        end
      REC_DATA       :
        begin
          if (icmp_rev_error_d0 || icmp_type_error)
            next_state <= REC_ERROR ;
          else if (icmp_data_length[0] == 1'b0 && icmp_rx_cnt == icmp_data_length - 1)
            next_state <= VERIFY_CHECKSUM ;
          else if (icmp_data_length[0] == 1'b1 && icmp_rx_cnt == icmp_data_length - 2)
            next_state <= REC_ODD_DATA ;
          else if (icmp_rx_cnt == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= REC_DATA ;
        end
      REC_ODD_DATA   :
        begin
          if (icmp_rev_error_d0 || icmp_type_error)
            next_state <= REC_ERROR ;
          else if (icmp_rx_cnt == icmp_data_length - 1)
            next_state <= VERIFY_CHECKSUM ;
          else
            next_state <= REC_ODD_DATA ;
        end
      VERIFY_CHECKSUM:
        begin
          if (icmp_checksum_error)
            next_state <= REC_ERROR ;
          else if (icmp_rx_end && checksum_finish)
            next_state <= REC_END_WAIT ;
          else if (icmp_rx_cnt == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= VERIFY_CHECKSUM ;
        end
      REC_ERROR      :
        next_state <= IDLE  ;
      REC_END_WAIT   :
        begin
          if (icmp_rx_cnt == 16'd63)
            next_state <= REC_END ;
          else
            next_state <= REC_END_WAIT ;
        end
      SEND_WAIT      :
        begin
          if (icmp_data_req)
            next_state <= SEND ;
          else if (timeout == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= SEND_WAIT ;
        end
      SEND           :
        begin
          if (icmp_rx_cnt == icmp_data_length)
            next_state <= SEND_END ;
          else if (icmp_rx_cnt == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= SEND ;
        end
      REC_END        :
        next_state <= SEND_WAIT  ;
      SEND_END       :
        next_state <= IDLE  ;
      default        :
        next_state <= IDLE  ;
    endcase
  end
  
  
  
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_tx_req <=  1'b0 ;
    else if (state == REC_END)
      icmp_tx_req <=  1'b1 ;
    else
      icmp_tx_req <=  1'b0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_tx_ready <=  1'b0 ;
    else if (state == SEND_WAIT)
      icmp_tx_ready <=  1'b1 ;
    else
      icmp_tx_ready <=  1'b0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ram_wr_en <=  1'b0 ;
    else if (state == REC_DATA  || state == REC_ODD_DATA)
      begin
        if (icmp_rx_cnt < icmp_data_length && icmp_rx_cnt > 16'd7)
          ram_wr_en <=  1'b1 ;
        else
          ram_wr_en <=  1'b0 ;
      end
    else
      ram_wr_en <=  1'b0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ram_write_addr <=  11'b0 ;
    else if (state == REC_DATA  || state == REC_ODD_DATA)
      ram_write_addr <=  icmp_rx_cnt - 8 ;
    else
      ram_write_addr <=  11'b0 ;
  end
  
//timeout counter
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      timeout <= 16'd0 ;
    else if (state == SEND_WAIT )
      timeout <= timeout + 1'b1 ;
    else
      timeout <= 16'd0 ;
  end
//received data register
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_rx_data_d0 <= 8'd0 ;
    else
      icmp_rx_data_d0 <= icmp_rx_data ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_rev_error_d0 <= 1'b0 ;
    else
      icmp_rev_error_d0 <= icmp_rev_error ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_data_length <= 16'd0 ;
    else if (state == IDLE)
      icmp_data_length <= upper_layer_data_length ;
  end
  
  
//icmp receive and reply counter
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_rx_cnt <= 16'd0 ;
    else if (state == REC_DATA  || state == REC_END_WAIT ||  state == SEND)
      icmp_rx_cnt <= icmp_rx_cnt + 1'b1 ;
    else
      icmp_rx_cnt <= 16'd0 ;
  end
  
  
//icmp type is not request
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_type_error <= 1'b0 ;
    else if (state == REC_DATA && icmp_rx_cnt == 16'd0 && icmp_rx_data != ECHO_REQUEST)
      icmp_type_error <= 1'b1 ;
    else
      icmp_type_error <= 1'b0 ;
  end
  
//icmp code
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_code <= 8'd0 ;
    else if (state == REC_DATA && icmp_rx_cnt == 16'd1)
      icmp_code <= icmp_rx_data ;
  end
  
//icmp id
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_id <= 16'd0 ;
    else if (state == REC_DATA && icmp_rx_cnt == 16'd4)
      icmp_id[15:8] <= icmp_rx_data ;
    else if (state == REC_DATA && icmp_rx_cnt == 16'd5)
      icmp_id[7:0] <= icmp_rx_data ;
  end
  
//icmp seq
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_seq <= 16'd0 ;
    else if (state == REC_DATA && icmp_rx_cnt == 16'd6)
      icmp_seq[15:8] <= icmp_rx_data ;
    else if (state == REC_DATA && icmp_rx_cnt == 16'd7)
      icmp_seq[7:0] <= icmp_rx_data ;
  end
  
  
//read ram address when reply
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_rec_ram_read_addr <= 11'd0 ;
    else if (state == SEND && icmp_rx_cnt > 5)
      icmp_rec_ram_read_addr <= icmp_rx_cnt - 6 ;
    else
      icmp_rec_ram_read_addr <= 11'd0 ;
  end
//received ram: depth 256 width 8
dpram
  #(
    .WIDTH(8),
    .DEPTH(8)
  )
  icmp_receive_ram
  (
    .clock      (clk                     ),
    .data       (icmp_rx_data_d0           ),
    .rdaddress  (icmp_rec_ram_read_addr  ),
    .wraddress  (ram_write_addr          ),
    .wren       (ram_wr_en               ),
    .q          (icmp_rec_ram_rdata      )
  );
  
  
//***************************************************************************//
//verify checksum 32 bit adder, in the end, add itself until high 16 bit is 0
//** ************************************************************************//
reg  [31:0] checksum_tmp ;
reg  [31:0] checksum_buf ;
reg  [31:0] check_out ;
reg  [31:0] checkout_buf ;
wire [15:0] checksum ;
reg  [2:0]  checksum_cnt ;

//checksum function
function [31:0] checksum_adder
  (
    input [31:0]  dataina,
    input [31:0]  datainb
  );
  begin
    checksum_adder = dataina + datainb;
  end
endfunction

function [31:0]  checksum_out
  (
    input [31:0]  dataina
  );
  begin
    checksum_out = dataina[15:0]+dataina[31:16];
  end
endfunction

always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      checksum_tmp <= 32'd0;
    else if (state == REC_DATA)
      begin
        if(icmp_rx_cnt[0] == 1'b1)
          checksum_tmp <= checksum_adder({icmp_rx_data_d0,icmp_rx_data},checksum_buf);
      end
    else if (state == REC_ODD_DATA)
      checksum_tmp <= checksum_adder({icmp_rx_data,8'h00},checksum_tmp);   //if udp data length is odd, fill with one byte 8'h00
    else if (state == IDLE)
      checksum_tmp <= 32'd0;
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
        if (checksum_cnt == 3'd0)
          check_out <= checksum_out(checksum_tmp) ;
        else if (checksum_cnt == 3'd1)
          check_out <= checksum_out(check_out) ;
      end
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      checksum_buf <= 32'd0 ;
    else if (state == REC_DATA)
      checksum_buf <= checksum_tmp ;
    else
      checksum_buf <= 32'd0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      checkout_buf <= 32'd0 ;
    else
      checkout_buf <= check_out ;
  end
  
assign checksum = ~checkout_buf[15:0] ;

//generate checksum error signal and rx end signal
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      begin
        icmp_checksum_error <= 1'b0 ;
        icmp_rx_end <= 1'b0 ;
      end
    else if (state == VERIFY_CHECKSUM && checksum_cnt == 3'd3)
      begin
        if (checksum == 16'd0)
          begin
            icmp_checksum_error <= 1'b0 ;
            icmp_rx_end <= 1'b1 ;
          end
        else
          begin
            icmp_checksum_error <= 1'b1 ;
            icmp_rx_end <= 1'b0 ;
          end
      end
    else
      begin
        icmp_checksum_error <= 1'b0 ;
        icmp_rx_end <= 1'b0 ;
      end
  end
  
  
  
//*******************************************************************//
//reply checksum
//*******************************************************************//
reg  [31:0] reply_checksum_tmp ;
reg  [31:0] reply_checksum_buf ;
reg  [31:0] reply_check_out ;
reg  [31:0] reply_checkout_buf ;
wire [15:0] reply_checksum ;


always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      reply_checksum_tmp <= 32'd0;
    else if (state == REC_DATA)
      begin
        if (icmp_rx_cnt == 16'd1)
          reply_checksum_tmp <= checksum_adder({8'h00,icmp_rx_data}, 16'h0000);  //source ip address
        else if (icmp_rx_cnt == 16'd3)
          reply_checksum_tmp <= reply_checksum_tmp ;  //source ip address
        else
          begin
            if(icmp_rx_cnt[0] == 1'b1)
              reply_checksum_tmp <= checksum_adder({icmp_rx_data_d0,icmp_rx_data},reply_checksum_buf);
          end
      end
    else if (state == REC_ODD_DATA)
      reply_checksum_tmp <= checksum_adder({icmp_rx_data,8'h00},reply_checksum_tmp);   //if udp data length is odd, fill with one byte 8'h00
    else if (state == IDLE)
      reply_checksum_tmp <= 32'd0;
  end
  
  
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      reply_check_out <= 32'd0;
    else if (state ==  VERIFY_CHECKSUM)
      begin
        if (checksum_cnt == 3'd0)
          reply_check_out <= checksum_out(reply_checksum_tmp) ;
        else if (checksum_cnt == 3'd1)
          reply_check_out <= checksum_out(reply_check_out) ;
      end
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      reply_checksum_buf <= 32'd0 ;
    else if (state == REC_DATA)
      reply_checksum_buf <= reply_checksum_tmp ;
    else
      reply_checksum_buf <= 32'd0 ;
  end
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      reply_checkout_buf <= 32'd0 ;
    else if (state == VERIFY_CHECKSUM)
      reply_checkout_buf <= reply_check_out ;
  end
  
assign reply_checksum = ~reply_checkout_buf[15:0] ;

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      checksum_finish <= 1'b0 ;
    else if (state == VERIFY_CHECKSUM && checksum_cnt == 3'd3)
      checksum_finish <= 1'b1 ;
    else
      checksum_finish <= 1'b0 ;
  end
  
  
//*****************************************************************************************//
//send icmp data
//*****************************************************************************************//
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      icmp_tx_data <= 8'h00  ;
    else if (state == SEND)
      begin
        case(icmp_rx_cnt)
          16'd0    : icmp_tx_data <= ECHO_REPLY ;
          16'd1    : icmp_tx_data <= icmp_code ;
          16'd2    : icmp_tx_data <= reply_checksum[15:8];
          16'd3    : icmp_tx_data <= reply_checksum[7:0] ;
          16'd4    : icmp_tx_data <= icmp_id[15:8] ;
          16'd5    : icmp_tx_data <= icmp_id[7:0] ;
          16'd6    : icmp_tx_data <= icmp_seq[15:8] ;
          16'd7    : icmp_tx_data <= icmp_seq[7:0] ;
          default  : icmp_tx_data <= icmp_rec_ram_rdata ;
        endcase
      end
    else
      icmp_tx_data <= 8'h00 ;
  end
  
endmodule
