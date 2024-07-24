//////////////////////////////////////////////////////////////////////////////////////
//Module Name : mac_tx_mode
//Description : This module is arbitration for MAC layer signal, which from IP and ARP
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns
module mac_tx_mode
       (
         input               clk ,
         input               rst_n,
         
         input               arp_tx_ready ,
         input      [7:0]    arp_tx_data,
         input               arp_tx_end,
         
         input               ip_tx_ready,
         input      [7:0]    ip_tx_data,
         input               ip_tx_end,
         
         output reg          mac_tx_ready,
         output reg [7:0]    mac_tx_data,
         output reg          mac_tx_end
       );
       
       
       
reg [15:0]    timeout ;

parameter IDLE  = 3'b001 ;
parameter ARP   = 3'b010 ;
parameter IP    = 3'b100 ;


reg [2:0]    state  ;
reg [2:0]    next_state ;

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
      IDLE        :
        begin
          if (arp_tx_ready)
            next_state <= ARP ;
          else if (ip_tx_ready)
            next_state <= IP  ;
          else
            next_state <= IDLE ;
        end
        
      ARP         :
        begin
          if (arp_tx_end)
            next_state <= IDLE ;
          else if (timeout == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= ARP ;
        end
      IP          :
        begin
          if (ip_tx_end)
            next_state <= IDLE ;
          else if (timeout == 16'hffff)
            next_state <= IDLE ;
          else
            next_state <= IP ;
        end
      default     :
        next_state <= IDLE ;
    endcase
  end
  
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      timeout <= 16'd0 ;
    else if (state == ARP || state == IP)
      timeout <= timeout + 1'b1 ;
    else
      timeout <= 16'd0 ;
  end
  
  
  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      begin
        mac_tx_ready      <= 1'b0  ;
        mac_tx_data       <= 8'h00 ;
        mac_tx_end        <= 1'b0  ;
      end
    else if (state == ARP)
      begin
        mac_tx_ready      <= arp_tx_ready ;
        mac_tx_data       <= arp_tx_data ;
        mac_tx_end        <= arp_tx_end ;
      end
    else if (state == IP)
      begin
        mac_tx_ready      <= ip_tx_ready ;
        mac_tx_data       <= ip_tx_data ;
        mac_tx_end        <= ip_tx_end ;
      end
    else
      begin
        mac_tx_ready      <= 1'b0  ;
        mac_tx_data       <= 8'h00 ;
        mac_tx_end        <= 1'b0  ;
      end
  end
  
endmodule


