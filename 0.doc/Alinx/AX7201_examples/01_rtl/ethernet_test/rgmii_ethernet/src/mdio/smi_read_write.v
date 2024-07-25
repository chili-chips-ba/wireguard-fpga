`timescale 1 ns/1 ns
module smi_read_write
  #(
    parameter REF_CLK = 50,             //reference clock frequency(MHz)
    parameter MDC_CLK = 100             //mdc clock(KHz)
   )
   (
    input                clk,
    input                rst_n  ,
    output reg           mdc,           //mdc interface
    inout                mdio,          //mdio interface
    
    input  [4:0]         phy_addr,      //phy address
    input  [4:0]         reg_addr,      //phy register address
    
    input                write_req ,    //write smi request
    input  [15:0]        write_data,    //write smi data
    input                read_req,      //read smi request
    output reg [15:0]    read_data,     //read smi data
    output               data_valid,    //read smi data valid
    output reg           done           //write or read finished
   );
 
wire [15:0]           cycle       ;         //REF_CLK*1000/MDC_CLK
reg  [15:0]           mdc_cnt     ;         //mdc counter
reg                   mdc_d0      ;
reg                   mdc_posedge ;         //mdc posedge
reg                   mdc_negedge ;         //mdc negedge
reg                   mdio_en     ;         //mdio direction select
reg                   mdio_out    ;         //mdio output data
reg  [5:0]            write_cnt   ;         //write bit counter
reg  [4:0]            read_cnt    ;         //read bit counter
reg  [3:0]            mdio_in     ;         //mdio input data

assign mdio  = mdio_en? mdio_out : 1'bz ;

assign cycle = REF_CLK*1000/MDC_CLK ;

localparam ST      = 2'b01 ;     //mdio start code
localparam W_OP    = 2'b01 ;     //mdio write op code
localparam R_OP    = 2'b10 ;     //mdio read op code
localparam W_TA    = 2'b10 ;     //mdio write turn around code

 
localparam IDLE    = 3'd0 ;
localparam W_MDIO  = 3'd1 ;
localparam R_MDIO  = 3'd2 ;
localparam R_TA    = 3'd3 ;
localparam R_DATA  = 3'd4 ;
localparam W_END   = 3'd5 ;
localparam R_END   = 3'd6 ;


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
          mdio_en <= 1'b1;
          if (write_req)               //write request
            next_state <= W_MDIO ;
		  else if (read_req)           //read request
		    next_state <= R_MDIO ;
          else
            next_state <= IDLE ;
        end
      W_MDIO        :                  //write smi
        begin
         mdio_en <= 1'b1;
          if (write_cnt == 6'd33)      
            next_state <= W_END ;
          else
            next_state <= W_MDIO ;
        end
	  R_MDIO        :                  //send read smi code
        begin
          if (write_cnt == 6'd15)
          begin
            next_state <= R_TA ;
             mdio_en <= 1'b0;
             end
          else
            begin
            next_state <= R_MDIO ;
             mdio_en <= 1'b1;
             end
        end
	  R_TA          :                  //read turn around
	    begin
	      mdio_en <= 1'b0;
          if (write_cnt == 6'd17)
            next_state <= R_DATA ;
          else
            next_state <= R_TA ;
        end
	  R_DATA        :                  //read data
        begin
          mdio_en <= 1'b0;
          if (read_cnt == 5'd16 && mdc_negedge)
            next_state <= R_END ;
          else
            next_state <= R_DATA ;
        end
	  W_END,R_END :
	    next_state <= IDLE ;
      default     :
        next_state <= IDLE ;
    endcase
  end
  
assign data_valid = (state == R_END) ;

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
	  mdc_cnt <= 16'd0 ;
	else if (mdc_cnt == cycle/2 - 1)     
	  mdc_cnt <= 16'd0;
	else
	  mdc_cnt <= mdc_cnt + 1'b1 ;
end

always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  mdc <= 1'b0 ;
	else if (mdc_cnt == cycle/2 - 1)             //generate mdc clock
	  mdc <= ~mdc ;
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
	  mdc_d0      <= mdc ;
	  mdc_posedge <= ~mdc_d0 & mdc ;
	  mdc_negedge <= ~mdc & mdc_d0 ;
	end
end



/*always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	 // mdio_en <= 1'b0 ;
	  mdio_en <= 1'b1 ;
	else if (state == W_MDIO || state == R_MDIO)
	  mdio_en <= 1'b1 ;
	else 
	  mdio_en <= 1'b0 ;
end  
*/
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  write_cnt <= 6'd0 ;
	else if (state == W_MDIO || state == R_MDIO || state == R_TA)
	begin
	  if (mdc_negedge)                  //bit counter when mdc negedge and send data
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
	//  mdio_out <= 1'bz ;
	 mdio_out <= 1'b1 ;
	else
	begin
	  if (state == W_MDIO)
	  begin
	    case(write_cnt)
		  6'd1    : mdio_out <= ST[1] ;
		  6'd2    : mdio_out <= ST[0] ;
		  6'd3    : mdio_out <= W_OP[1] ;
		  6'd4    : mdio_out <= W_OP[0] ;
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
		  6'd1    : mdio_out <= ST[1] ;
		  6'd2    : mdio_out <= ST[0] ;
		  6'd3    : mdio_out <= R_OP[1] ;
		  6'd4    : mdio_out <= R_OP[0] ;
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
		 // default : mdio_out <= 1'bz ;
		   default : mdio_out <= mdio_out ;
		endcase
      end		  
	  else
	    mdio_out <= 1'b1 ;
	   // mdio_out <= 1'bz; 
	end
end

//mdio delay some clock for latch
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  mdio_in <= 4'd0 ;
	else 
	  mdio_in <= {mdio_in[2:0], mdio} ;
end

//read phy data
always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_data <= 16'd0 ;
	else if (state == R_DATA)
	begin
	  if (mdc_posedge)
	    read_data <= {read_data[14:0], mdio_in[3]} ;		 
	end
	else if (state == R_MDIO)
	    read_data <= 16'd0 ;
end


endmodule
