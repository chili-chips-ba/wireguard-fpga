`timescale 1 ns/1 ns
module smi_config
#(
parameter REF_CLK = 50,         //reference clock frequency(MHz)
parameter MDC_CLK = 500         //mdc clock(KHz)
)
(
input                 clk,
input                 rst_n  ,

output                mdc,      //mdc interface
inout                 mdio,     //mdio interface
output reg  [1:0]     speed,    //ethernet speed 00:10M 01:100M 10:1000M
output reg            link,     //ethernet link signal
output reg  [3:0]     led       //led 1110: 10M  1100: 100M 1000:1000M  1111: not link
 
);

reg  [4:0]         phy_addr      ;   //phy address 5'b0001
reg  [4:0]         reg_addr      ;   //phy register address
(* MARK_DEBUG="true" *)reg                write_req     ;   //write smi request
reg  [15:0]        write_data    ;   //write smi data
(* MARK_DEBUG="true" *)reg                read_req      ;   //read smi request
(* MARK_DEBUG="true" *)wire [15:0]        read_data     ;   //read smi data
wire               data_valid    ;   //read smi data valid
wire               done          ;	 //write or read finished
reg  [15:0]        read_data_buf ;   //read register data latch
reg  [31:0]        timer         ;	 //wait counter 
 
localparam IDLE            = 4'd0 ;
localparam R_GEN_REQ       = 4'd1 ;
localparam R_REG           = 4'd2 ;
localparam R_CHECK         = 4'd3 ;
localparam ETH_UNLINK      = 4'd4 ;
localparam ETH_1000M       = 4'd5 ;
localparam ETH_100M        = 4'd6 ;
localparam ETH_10M         = 4'd7 ;
localparam R_WAIT          = 4'd8 ;
localparam W_GEN_REQ       = 4'd9 ;
localparam W_REG           = 4'd10 ;
(* MARK_DEBUG="true" *)reg [3:0]    state  ;
reg [3:0]    next_state ;

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
          next_state <= R_GEN_REQ;
        end
     W_GEN_REQ   :
          next_state <= W_REG ;
     W_REG        :
       begin
         if (done)
           next_state <= R_GEN_REQ ;
         else
           next_state <= W_REG ;
       end    
        
      R_GEN_REQ        :                  //generate read request
          next_state <= R_REG ;
      R_REG        :                      //read register data
        begin
          if (done)
            next_state <= R_CHECK ;
          else
            next_state <= R_REG ;
        end
      R_CHECK          :
        begin
          if (~read_data[10])             //read register data bit 10 to check if ethernet link  0: unlink  1: link 
            next_state <= ETH_UNLINK ;
          else if (read_data[15:14] == 2'b11 || read_data[15:14] == 2'b10)    //register data bit[15:14] check ethernet speed 00: 10M ; 01: 100M ; 10 or 11 : 1000M
            next_state <= ETH_1000M ;
          else if (read_data[15:14] == 2'b01)
            next_state <= ETH_100M ;
          else if (read_data[15:14] == 2'b00)
            next_state <= ETH_10M ;
          else
            next_state <= R_CHECK ;
        end
      ETH_UNLINK, ETH_1000M, ETH_100M, ETH_10M  :
    	  next_state <= R_WAIT ;
      R_WAIT   :
        begin
          if (timer == 32'd50_000_000)      //check every 1s
            next_state <= R_GEN_REQ;
          else
            next_state <= R_WAIT ;
        end 
      default     :
        next_state <= IDLE ;
    endcase
  end


//ethernet speed  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  speed <= 2'b11 ;
	else if (state == ETH_10M)
	  speed <= 2'b00 ;
	else if (state == ETH_100M)
	  speed <= 2'b01 ;
	else if (state == ETH_1000M)
	  speed <= 2'b10 ;
  end
always @(posedge clk or negedge rst_n)
    begin
      if (~rst_n)
        write_req <= 1'b0 ;
      else if (state == W_GEN_REQ)
        write_req <= 1'b1 ;
      else
        write_req <= 1'b0 ;
    end  
//ethernet link signal
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  link <= 1'b0 ;
	else if (state == ETH_UNLINK)
	  link <= 1'b0 ;
	else if (state == ETH_10M || state == ETH_100M || state == ETH_1000M)
	  link <= 1'b1 ;
  end

//led signal
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  led <= 4'd0 ;
	else if (link)
	begin
	  if (speed == 2'b00)//10M
	    led <= 4'b1110 ;
	  else if (speed == 2'b01)//100M
	    led <= 4'b1100 ;
	  else if (speed == 2'b10)//1G
	    led <= 4'b1000 ;
	  else 
	    led <= 4'b1111 ;
	end
	else 
	  led <= 4'b1111 ;
  end  
always @(posedge clk or negedge rst_n)
    begin
      if (~rst_n)
        write_data <= 16'd0 ;
      else 
        write_data <= 16'h1340 ;//restart
    end  
//wait counter  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  timer <= 32'd0 ;
	else if (state == R_WAIT)
	  timer <= timer + 1'b1 ;
	else
	  timer <= 32'd0 ;
  end

//read smi request  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_req <= 1'b0 ;
	else if (state == R_GEN_REQ)
	  read_req <= 1'b1 ;
	else
	  read_req <= 1'b0 ;
  end

//read data latch
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_data_buf <= 16'd0 ;
	else if (data_valid)
	  read_data_buf <= read_data ;
  end

//phy address
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  phy_addr <= 5'd0 ;
	else 
	  phy_addr <= 5'b00001 ;
  end

//phy register address
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  reg_addr <= 5'd0 ;
	else if (state == R_REG)
	  reg_addr <= 5'b10001 ;
	 else if (state == W_REG)
      reg_addr <= 5'b00000 ;
  end
 

smi_read_write 
      #(
        .REF_CLK(REF_CLK),
        .MDC_CLK(MDC_CLK)
	   )
	   smi_inst
       (
        .clk              (clk         ),
        .rst_n            (rst_n       ),
        .mdc              (mdc         ),
        .mdio             (mdio        ),         
        .phy_addr         (phy_addr    ),
        .reg_addr         (reg_addr    ),		 
        .write_req        (write_req   ),
        .write_data       (write_data  ),
        .read_req         (read_req    ),
        .read_data        (read_data   ),
        .data_valid       (data_valid  ),
        .done             (done        )
       );

 
endmodule
