`timescale 1 ns/1 ns
module smi_read_write
      #(
        parameter REF_CLK = 50000,             //reference clock frequency(KHz)
        parameter MDC_CLK = 100             //mdc_r clock(KHz)
       )
       (
        input                clk,
        input                rst_n  ,
        output            	 mdc,           //mdc_r interface
        inout                mdio,          //mdio interface
        
        input  [4:0]         phy_addr,      //phy address
        input  [4:0]         reg_addr,      //phy register address
		       
        input                write_req ,    //write smi request
        output reg           write_req_ack ,   //write smi request ack
        input  [15:0]        write_data,    //write smi data
        input                read_req,      //read smi request
        output reg           read_req_ack,      //read smi request ack
        output reg [15:0]    read_data,     //read smi data
        output               data_valid,    //read smi data valid
        output reg           done           //write or read finished
       );

localparam HALF_CYCLE = REF_CLK/(MDC_CLK*2);
localparam CYCLE = REF_CLK/MDC_CLK;

localparam ST      = 2'b01 ;     //mdio start code
localparam W_OP    = 2'b01 ;     //mdio write op code
localparam R_OP    = 2'b10 ;     //mdio read op code
localparam W_TA    = 2'b10 ;     //mdio write turn around code
 
(* MARK_DEBUG="true" *)reg					 mdc_r ;
(* MARK_DEBUG="true" *)reg  [31:0]           mdc_cnt     ;         //mdc_r counter
reg                   mdc_d0      ;
reg                   mdc_posedge ;         //mdc_r posedge
reg                   mdc_negedge ;         //mdc_r negedge
(* MARK_DEBUG="true" *)reg                   mdio_en     ;         //mdio direction select
(* MARK_DEBUG="true" *)reg                   mdio_out    ;         //mdio output data
(* MARK_DEBUG="true" *)wire                   mdio_in    ;         //mdio input data
(* MARK_DEBUG="true" *)reg  [5:0]            write_cnt   ;         //write bit counter
(* MARK_DEBUG="true" *)reg  [4:0]            read_cnt    ;         //read bit counter
reg  [3:0]            mdio_datain     ;         //mdio input data

reg						read_write ;

wire [1:0]				  start_op ;
wire [1:0]				  write_op ;
wire [1:0]				  read_op ;
	  
reg [3:0]		wait_cnt ;	  

assign start_op = ST ;
assign write_op = W_OP ;
assign read_op = R_OP ;

   IOBUF IOBUF_inst (
      .O(mdio_in),   // 1-bit output: Buffer output
      .I(mdio_out),   // 1-bit input: Buffer input
      .IO(mdio), // 1-bit inout: Buffer inout (connect directly to top-level port)
      .T(mdio_en)    // 1-bit input: 3-state enable input
   );


   ODDR #(
       .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
       .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
       .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   )
   ODDR_inst (
      .Q(mdc),   // 1-bit output: Data output to IOB
      .C(mdc_r),   // 1-bit input: High-speed clock input
      .CE(1'b1),
      .D1(1), // 1-bit input: Parallel data input 1
      .D2(0), // 1-bit input: Parallel data input 2
      .R(0),
      .S(0)  // 1-bit input: Active-High Async Reset
   );


 
localparam IDLE    		= 10'b00_0000_0001 ;
localparam WAIT_REQ    	= 10'b00_0000_0010 ;
localparam W_MDIO  		= 10'b00_0000_0100 ;
localparam R_MDIO  		= 10'b00_0000_1000 ;
localparam R_TA_Z    	= 10'b00_0001_0000 ;
localparam R_DATA  		= 10'b00_0010_0000 ;
localparam W_END   		= 10'b00_0100_0000 ;
localparam R_END   		= 10'b00_1000_0000 ;
localparam R_TA_0    	= 10'b01_0000_0000 ;
localparam END_WAIT    	= 10'b10_0000_0000 ;

(* MARK_DEBUG="true" *)reg [9:0]    state  ;
reg [9:0]    next_state ;

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
	  IDLE    :
	    begin
          if (write_req | read_req)               //write request
            next_state <= WAIT_REQ ;
          else
            next_state <= IDLE ;
        end
      WAIT_REQ        :
        begin
          if (write_cnt == 6'd40)  
		  begin
		    if (read_write)
				next_state <= W_MDIO ;
			else
				next_state <= R_MDIO ;
		  end
          else
            next_state <= WAIT_REQ ;
        end
	  
      W_MDIO        :                  //write smi
        begin
          if (write_cnt == 6'd33)      
            next_state <= W_END ;
          else
            next_state <= W_MDIO ;
        end
	  R_MDIO        :                  //send read smi code
        begin
          if (write_cnt == 6'd15)
            next_state <= R_TA_Z ;
          else
            next_state <= R_MDIO ;
        end
	  R_TA_Z          :                  //read turn around
	    begin
          if (write_cnt == 6'd16)
            next_state <= R_TA_0 ;
          else
            next_state <= R_TA_Z ;
        end
	  R_TA_0          :                  //read turn around
	    begin
          if (write_cnt == 6'd17)
            next_state <= R_DATA ;
          else
            next_state <= R_TA_0 ;
        end
	  R_DATA        :                  //read data
        begin
          if (read_cnt == 5'd16 && mdc_negedge)
            next_state <= R_END ;
          else
            next_state <= R_DATA ;
        end
	  W_END,R_END :
	    next_state <= END_WAIT ;
	  END_WAIT : begin
          if (wait_cnt >= 4'd5)
            next_state <= IDLE ;
          else
            next_state <= END_WAIT ;
        end
      default     :
        next_state <= IDLE ;
    endcase
  end
  
assign data_valid = (state == R_END) ;


always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  wait_cnt <= 32'd0 ;
	else if (state == END_WAIT)     
	  wait_cnt <= wait_cnt + 1'b1 ;
	else
	  wait_cnt <= 32'd0 ;
end

//write or read finished
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  done <= 1'b0 ;
	else if (state == W_END || state == R_END)
	  done <= 1'b1 ;
	else
	  done <= 1'b0 ;
end


always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_write <= 1'b0 ;
	else if (state == IDLE && write_req == 1'b1)
	  read_write <= 1'b1 ;
	else if (state == IDLE && read_req == 1'b1)
	  read_write <= 1'b0 ;
end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  write_req_ack <= 1'b0 ;
	else if (state == IDLE && write_req == 1'b1)
	  write_req_ack <= 1'b1 ;
	else 
	  write_req_ack <= 1'b0 ;
end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_req_ack <= 1'b0 ;
	else if (state == IDLE && read_req == 1'b1)
	  read_req_ack <= 1'b1 ;
	else 
	  read_req_ack <= 1'b0 ;
end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  mdc_cnt <= 32'd0 ;
	else if (mdc_cnt >= CYCLE - 1)     
	  mdc_cnt <= 32'd0;
	else
	  mdc_cnt <= mdc_cnt + 1'b1 ;
end




always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  mdc_r <= 1'b0 ;
	else if (mdc_cnt < HALF_CYCLE)  
	  mdc_r <= 1'b0 ;
	else
	  mdc_r <= 1'b1 ;
end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	begin
	  mdc_d0      <= 1'b0 ;
	  mdc_posedge <= 1'b0 ;
	  mdc_negedge <= 1'b0 ;
	end
	else
	begin
	  mdc_d0      <= mdc_r ;
	  mdc_posedge <= ~mdc_d0 & mdc_r ;
	  mdc_negedge <= ~mdc_r & mdc_d0 ;
	end
end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  mdio_en <= 1'b1 ;
	else if (state == WAIT_REQ || state == W_MDIO ||  state == R_MDIO)
	  mdio_en <= 1'b0 ;
	else 
	  mdio_en <= 1'b1 ;
end 

// always @(posedge clk or negedge rst_n)
  // begin
    // if (~rst_n)
	  // mdio_en <= 1'b0 ;
	// else if (state == R_TA_Z || state == R_TA_0 ||  state == R_DATA)
	  // mdio_en <= 1'b1 ;
	// else 
	  // mdio_en <= 1'b0 ;
// end  

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  write_cnt <= 6'd0 ;
	else if (state == W_MDIO || state == R_MDIO || state == R_TA_Z || state == R_TA_0 || (state == WAIT_REQ && state == next_state))
	begin
	  if (mdc_negedge)                  //bit counter when mdc_r negedge and send data
	    write_cnt <= write_cnt + 1'b1 ;
	end
	else 
	  write_cnt <= 6'd0 ;
end  

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_cnt <= 5'd0 ;
	else if (state == R_DATA)
	begin
	  if (mdc_posedge)
	    read_cnt <= read_cnt + 1'b1 ;
	end
	else 
	  read_cnt <= 5'd0 ;
end  



always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  mdio_out <= 1'b1 ;
	else
	begin
	  if (state == W_MDIO)
	  begin
	    case(write_cnt)
		  6'd1    : mdio_out <= start_op[1] ;
		  6'd2    : mdio_out <= start_op[0] ;
		  6'd3    : mdio_out <= write_op[1] ;
		  6'd4    : mdio_out <= write_op[0] ;
		  6'd5    : mdio_out <= phy_addr[4] ;
		  6'd6    : mdio_out <= phy_addr[3] ;
		  6'd7    : mdio_out <= phy_addr[2] ;
		  6'd8    : mdio_out <= phy_addr[1] ;
		  6'd9    : mdio_out <= phy_addr[0] ;
		  6'd10   : mdio_out <= reg_addr[4] ;
		  6'd11   : mdio_out <= reg_addr[3] ;
		  6'd12   : mdio_out <= reg_addr[2] ;
		  6'd13   : mdio_out <= reg_addr[1] ;
		  6'd14   : mdio_out <= reg_addr[0] ;
		  6'd15   : mdio_out <= W_TA[1] ;
		  6'd16   : mdio_out <= W_TA[0] ;
		  6'd17   : mdio_out <= write_data[15] ;
		  6'd18   : mdio_out <= write_data[14] ;
		  6'd19   : mdio_out <= write_data[13] ;
		  6'd20   : mdio_out <= write_data[12] ;
		  6'd21   : mdio_out <= write_data[11] ;
		  6'd22   : mdio_out <= write_data[10] ;
		  6'd23   : mdio_out <= write_data[9] ;
		  6'd24   : mdio_out <= write_data[8] ;
		  6'd25   : mdio_out <= write_data[7] ;
		  6'd26   : mdio_out <= write_data[6] ;
		  6'd27   : mdio_out <= write_data[5] ;
		  6'd28   : mdio_out <= write_data[4] ;
		  6'd29   : mdio_out <= write_data[3] ;
		  6'd30   : mdio_out <= write_data[2] ;
		  6'd31   : mdio_out <= write_data[1] ;
		  6'd32   : mdio_out <= write_data[0] ;
		  default : mdio_out <= 1'b1 ;
        endcase		  
	  end
	  else if (state == R_MDIO)
	  begin
	    case(write_cnt)
		  6'd1    : mdio_out <= start_op[1] ;
		  6'd2    : mdio_out <= start_op[0] ;
		  6'd3    : mdio_out <= read_op[1] ;
		  6'd4    : mdio_out <= read_op[0] ;
		  6'd5    : mdio_out <= phy_addr[4] ;
		  6'd6    : mdio_out <= phy_addr[3] ;
		  6'd7    : mdio_out <= phy_addr[2] ;
		  6'd8    : mdio_out <= phy_addr[1] ;
		  6'd9    : mdio_out <= phy_addr[0] ;
		  6'd10   : mdio_out <= reg_addr[4] ;
		  6'd11   : mdio_out <= reg_addr[3] ;
		  6'd12   : mdio_out <= reg_addr[2] ;
		  6'd13   : mdio_out <= reg_addr[1] ;
		  6'd14   : mdio_out <= reg_addr[0] ;
		  default : mdio_out <= 1'b1 ;
		endcase
      end	
	  // else if (state == R_TA_0)
		// mdio_out <= 1'b0 ;
	  else
	    mdio_out <= 1'b1 ;
	end
end

//mdio delay some clock for latch
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  mdio_datain <= 4'd0 ;
	else 
	  mdio_datain <= {mdio_datain[2:0], mdio_in} ;
end

//read phy data
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_data <= 16'd0 ;
	else if (state == R_DATA)
	begin
	  if (mdc_posedge)
	    read_data <= {read_data[14:0], mdio_datain[3]} ;		 
	end
	else if (state == R_MDIO)
	    read_data <= 16'd0 ;
end


endmodule
