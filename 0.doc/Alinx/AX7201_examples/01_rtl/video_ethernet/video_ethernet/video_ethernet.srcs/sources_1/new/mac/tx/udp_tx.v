//////////////////////////////////////////////////////////////////////////////////////
//Module Name : udp_tx
//Description : This module is used to send UDP data and generate UDP checksum
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module udp_tx
       (
         input                    clk,
         input                    rst_n,
         
         input      [31:0]        source_ip_addr,
         input      [31:0]        destination_ip_addr,
         
         input      [15:0]        udp_send_source_port,
         input      [15:0]        udp_send_destination_port,
         input      [15:0]        udp_send_data_length,
         
         
         input      [7:0]         fifo_data,                //FIFO中的数据
         output reg               fifo_rd_en,               //FIFO读使能
         input      [7:0]         ram_wr_data,
         input                    ram_wr_en,
         output reg               udp_ram_data_req,
         
         input                    udp_tx_req,
         input                    udp_data_req,
         output reg               udp_tx_ready,
         output reg [7:0]         udp_tx_data,
         output                   udp_tx_end
         
       ) ;
       
reg  [3:0]                header_checksum_cnt ;
reg                       checksum_finish ;
reg  [10:0]               ram_write_addr  ;
reg  [10:0]               ram_read_addr   ;
reg  [7:0]                ram_rdata_d0  ;
reg  [7:0]                ram_rdata_d1  ;
reg  [7:0]                ram_wr_data_d0 ;
reg  [7:0]                ram_wr_data_d1 ;

wire [7:0]                ram_rdata ;
reg  [5:0]                ram_data_length ;

reg  [15:0]               udp_send_cnt  ;
reg  [15:0]               udp_data_length ;      //valid data length
reg  [15:0]               udp_total_data_length ;//data length when transfer

reg [15:0]                timeout ;




parameter IDLE              = 7'b000_0001 ;
parameter HEADER_CHECKSUM   = 7'b000_0010 ;
parameter GEN_CHECKSUM      = 7'b000_0100 ;
parameter GEN_ODD_CHECKSUM  = 7'b000_1000 ;
parameter GEN_CHECKSUM_END  = 7'b001_0000 ;
parameter SEND_WAIT         = 7'b010_0000 ;
parameter UDP_SEND          = 7'b100_0000 ;


reg [6:0]    state  ;
reg [6:0]    next_state ;


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
          if (udp_tx_req)
            next_state <= SEND_WAIT ;
          else
            next_state <= IDLE ;
        end
        
      SEND_WAIT   :
        begin
          if (udp_data_req)
            next_state <= UDP_SEND ;
          else if (timeout == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= SEND_WAIT ;
        end
        
      UDP_SEND    :
        begin
          if (udp_send_cnt == udp_total_data_length)
            next_state <= IDLE ;
          else
            next_state <= UDP_SEND ;
        end
      default     :
        next_state <= IDLE ;
    endcase
  end  
  

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      udp_tx_ready <= 1'b0 ;
    else if (state == SEND_WAIT)
      udp_tx_ready <= 1'b1 ;
    else
      udp_tx_ready <= 1'b0 ;
  end
  
  
//timeout counter
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ram_write_addr <= 11'd0 ;
    else if (ram_wr_en)
      ram_write_addr <= ram_write_addr + 1'b1 ;
    else
      ram_write_addr <= 11'd0 ;
  end
  
  
//timeout counter
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      timeout <= 16'd0 ;
    else if (state == SEND_WAIT)
      timeout <= timeout + 1'b1 ;
    else
      timeout <= 16'd0 ;
  end
  

  
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      begin
        ram_wr_data_d0 <= 8'd0 ;
        ram_wr_data_d1 <= 8'd0 ;
      end
    else
      begin
        ram_wr_data_d0 <= ram_wr_data ;
        ram_wr_data_d1 <= ram_wr_data_d0 ;
      end
  end
//ram signal

always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      begin
        ram_rdata_d0 <= 8'd0 ;
        ram_rdata_d1 <= 8'd0 ;
      end
    else
      begin
        ram_rdata_d0 <= fifo_data ;
        ram_rdata_d1 <= ram_rdata_d0 ;
      end
  end

  
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      fifo_rd_en <= 1'b0 ;
    else if (state == UDP_SEND && udp_send_cnt > 3 && udp_send_cnt < udp_total_data_length - 3)
      fifo_rd_en <= 1'b1 ;
    else
      fifo_rd_en <= 1'b0 ;
  end
  
//checksum counter
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      udp_send_cnt  <= 16'd0 ;
    else if (state == UDP_SEND)
      udp_send_cnt <= udp_send_cnt + 1'b1 ;
    else
      udp_send_cnt <= 16'd0 ;
  end
  
  
//generate udp and ip data length
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      begin
        udp_total_data_length <= 16'd0 ;
        udp_data_length <= 16'd0 ;
      end
    else
      begin
        udp_data_length <= udp_send_data_length + 8;
        if (udp_send_data_length < 18)
          udp_total_data_length <= 26 ;
        else
          udp_total_data_length <= udp_send_data_length + 8 ;
      end
  end

  
//*****************************************************************************************//
//send udp data
//*****************************************************************************************//
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      udp_tx_data <= 8'h00  ;
    else if (state == UDP_SEND)
      begin
        case(udp_send_cnt)
          16'd0   :   udp_tx_data <= udp_send_source_port[15:8] ;
          16'd1   :   udp_tx_data <= udp_send_source_port[7:0] ;
          16'd2   :   udp_tx_data <= udp_send_destination_port[15:8] ;
          16'd3   :   udp_tx_data <= udp_send_destination_port[7:0] ;
          16'd4   :   udp_tx_data <= udp_data_length[15:8] ;
          16'd5   :   udp_tx_data <= udp_data_length[7:0] ;
          16'd6   :   udp_tx_data <= 8'h00 ;//checksum[15:8] ;
          16'd7   :   udp_tx_data <= 8'h00 ;//checksum[7:0]  ;
          default :
		    begin
              if (udp_data_length < 26)
                begin
                  if (udp_send_cnt <= udp_data_length - 1)
                    udp_tx_data <= ram_rdata_d0 ;
                  else
                    udp_tx_data <= 8'h00 ;
                end
              else
                udp_tx_data <= ram_rdata_d0 ;
            end
        endcase
      end
    else
      udp_tx_data <= 8'h00 ;
  end
  
endmodule
