`timescale 1 ns/1 ns
module smi_config
      #(
        parameter REF_CLK = 50000,         //reference clock frequency(KHz)
        parameter MDC_CLK = 500         //mdc clock(KHz)
       )
       (
        input                 clk,
        input                 rst_n  ,
//        input                 vio_start  ,
        
        output                mdc,      //mdc interface
        inout                 mdio,     //mdio interface
        (* MARK_DEBUG="true" *)output reg  [1:0]     speed,    //ethernet speed 00:10M 01:100M 10:1000M
        (* MARK_DEBUG="true" *)output reg            link     //ethernet link signal

		 
       );

(* MARK_DEBUG="true" *)reg  [4:0]         phy_addr      ;   //phy address 5'b0001
(* MARK_DEBUG="true" *)reg  [4:0]         reg_addr      ;   //phy register address
(* MARK_DEBUG="true" *)reg                write_req     ;   //write smi request
(* MARK_DEBUG="true" *)reg  [15:0]        write_data    ;   //write smi data
reg  [15:0]        write_reg_16    ;  
reg  [15:0]        write_reg_17    ;  
(* MARK_DEBUG="true" *)reg                read_req      ;   //read smi request
(* MARK_DEBUG="true" *)wire [15:0]        read_data     ;   //read smi data
(* MARK_DEBUG="true" *)wire               data_valid    ;   //read smi data valid
(* MARK_DEBUG="true" *)wire               done          ;	 //write or read finished
reg  [15:0]        read_data_buf ;   //read register data latch
reg  [31:0]        timer         ;	 //wait counter 


wire 			txc_in_inverse ;
wire [1:0] 		txc_dly_sel ;
wire 			rxc_out_inverse ;
wire [1:0] 		rxc_dly_sel ;
wire 			rgmii_rxc_dly_sel ;

assign txc_in_inverse = 1'b0 ;
assign txc_dly_sel = 2'b10 ;
assign rxc_out_inverse = 1'b0 ;
assign rxc_dly_sel = 2'b01 ;
assign rgmii_rxc_dly_sel = 1'b0 ;


 
localparam IDLE            = 17'b0_0000_0000_0000_0001 ;
localparam W_PAGE_0A43     = 17'b0_0000_0000_0000_0010 ;
localparam R_CHECK         = 17'b0_0000_0000_0000_0100 ;
localparam ETH_UNLINK      = 17'b0_0000_0000_0000_1000 ;
localparam ETH_1000M       = 17'b0_0000_0000_0001_0000 ;
localparam ETH_100M        = 17'b0_0000_0000_0010_0000 ;
localparam ETH_10M         = 17'b0_0000_0000_0100_0000 ;
localparam R_WAIT          = 17'b0_0000_0000_1000_0000 ;
localparam W_PAGE_171      = 17'b0_0000_0001_0000_0000 ;
localparam R_REG_16        = 17'b0_0000_0010_0000_0000 ;
localparam W_REG_16        = 17'b0_0000_0100_0000_0000 ;
localparam R_REG_17        = 17'b0_0000_1000_0000_0000 ;
localparam W_REG_17        = 17'b0_0001_0000_0000_0000 ;
localparam RW_END          = 17'b0_0010_0000_0000_0000 ;
localparam R_REG_1A        = 17'b0_0100_0000_0000_0000 ;
localparam READ_ID         = 17'b0_1000_0000_0000_0000 ;
localparam CHECK_ID        = 17'b1_0000_0000_0000_0000 ;

(* MARK_DEBUG="true" *)reg [16:0]    state  ;
reg [16:0]    next_state ;

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
//		  if (vio_start)
			next_state <= READ_ID ;
//		  else
//			next_state <= IDLE ;
        end
	  READ_ID        :                  //generate read request
        begin
          if (done)
            next_state <= CHECK_ID ;
          else
            next_state <= READ_ID ;
        end
	  CHECK_ID : 
	    begin
          if (read_data != 16'h937c)
            next_state <= READ_ID ;
          else
            next_state <= W_PAGE_0A43 ;
        end
      W_PAGE_0A43        :                  //generate read request
        begin
          if (done)
            next_state <= R_REG_1A ;
          else
            next_state <= W_PAGE_0A43 ;
        end
      R_REG_1A        :                      //read register data
        begin
          if (done)
            next_state <= R_CHECK ;
          else
            next_state <= R_REG_1A ;
        end
      R_CHECK          :
        begin
		  if (read_data != 16'h0 && read_data != 16'hffff)
		  begin
			if (~read_data[2])             //read register data bit 10 to check if ethernet link  0: unlink  1: link 
				next_state <= ETH_UNLINK ;
			else if (read_data[5:4] == 2'b11 || read_data[5:4] == 2'b10)    //register data bit[15:14] check ethernet speed 00: 10M ; 01: 100M ; 10 or 11 : 1000M
				next_state <= ETH_1000M ;
			else if (read_data[5:4] == 2'b01)
				next_state <= ETH_100M ;
			else if (read_data[5:4] == 2'b00)
				next_state <= ETH_10M ;
		  end
          else
            next_state <= ETH_UNLINK ;
        end
	  ETH_UNLINK : next_state <= R_WAIT ;
      ETH_1000M, ETH_100M, ETH_10M  :
    	  next_state <= W_PAGE_171 ;
	  R_WAIT   :
        begin
          if (timer == 32'd50_000_000)      //check every 1s
            next_state <= W_PAGE_0A43 ;
          else
            next_state <= R_WAIT ;
        end 
      W_PAGE_171   :
        begin
          if (done)
            next_state <= R_REG_16 ;
          else
            next_state <= W_PAGE_171 ;
        end
	  R_REG_16   :
        begin
          if (done)
            next_state <= W_REG_16 ;
          else
            next_state <= R_REG_16 ;
        end
	  W_REG_16   :
        begin
          if (done)
            next_state <= R_REG_17 ;
          else
            next_state <= W_REG_16 ;
        end
	  R_REG_17   :
        begin
          if (done)
            next_state <= W_REG_17 ;
          else
            next_state <= R_REG_17 ;
        end
	  W_REG_17   :
        begin
          if (done)
            next_state <= RW_END ;
          else
            next_state <= W_REG_17 ;
        end
	  RW_END : next_state <= RW_END ;
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
	  write_req <= 1'b0 ;
	else if ((state == W_PAGE_0A43 || state == W_PAGE_171 || state == W_REG_16 || state == W_REG_17) && done != 1)
	  write_req <= 1'b1 ;
	else
	  write_req <= 1'b0 ;
  end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  write_data <= 0 ;
	else if (state == W_PAGE_0A43)
	  write_data <= 16'h0a43 ;
	else if (state == W_PAGE_171)
	  write_data <= 16'd171 ;
	else if (state == W_REG_16)
	  write_data <= write_reg_16 ;
	else if (state == W_REG_17)
	  write_data <= write_reg_17 ;
	else
	  write_data <= 0 ;
  end  
  

//read smi request  
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_req <= 1'b0 ;
	else if ((state == R_REG_1A || state == R_REG_16 || state == R_REG_17 || state == READ_ID) && done != 1)
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



always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  write_reg_16 <= 16'd0 ;
	else
	  write_reg_16 <= {read_data_buf[15],txc_in_inverse,txc_dly_sel,rxc_out_inverse,rxc_dly_sel,read_data_buf[8:0]} ;
  end  

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  write_reg_17 <= 16'd0 ;
	else
	  write_reg_17 <= {read_data_buf[15:1],rgmii_rxc_dly_sel} ;
  end  

//phy address
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  phy_addr <= 5'd0 ;
	else 
	  phy_addr <= 5'h1 ;
  end

//phy register address
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  reg_addr <= 5'd0 ;
	else if (state == W_PAGE_0A43 || state == W_PAGE_171)
	  reg_addr <= 5'h1f ;
	else if (state == READ_ID)
	  reg_addr <= 5'h2 ;
	else if (state == R_REG_1A)
	  reg_addr <= 5'h1a ;
	else if (state == R_REG_16 || state == W_REG_16)
	  reg_addr <= 5'd16 ;
	else if (state == R_REG_17 || state == W_REG_17)
	  reg_addr <= 5'd17 ;
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
