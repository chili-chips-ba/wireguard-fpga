`timescale 1 ns/1 ns
module smi_config_test
      #(
	    parameter REF_CLK = 50,
		parameter MDC_CLK = 100
	   )
       (
        input                 sys_clk,
        input                 rst_n  ,
        

        output                e_mdc,
        inout                 e_mdio,
     //   output reg            error,
     //   output reg  [1:0]     speed,
      //  output reg            link,
      (* MARK_DEBUG="true" *)output reg [3:0]     led 	
       // (* MARK_DEBUG="true" *)output reg  [3:0]     led 		 
		 
       );
(* MARK_DEBUG="true" *)reg                error;
(* MARK_DEBUG="true" *)reg  [1:0]         speed;
(* MARK_DEBUG="true" *)reg                link;
(* MARK_DEBUG="true" *)reg  [4:0]         phy_addr   ;
(* MARK_DEBUG="true" *)reg  [4:0]         reg_addr   ;
(* MARK_DEBUG="true" *)reg                write_req  ;
(* MARK_DEBUG="true" *)reg  [15:0]        write_data ;
(* MARK_DEBUG="true" *)reg                read_req   ;
(* MARK_DEBUG="true" *)wire [15:0]        read_data  ;
(* MARK_DEBUG="true" *)wire               data_valid ;
(* MARK_DEBUG="true" *)wire               done       ;	
// reg  [1:0]         speed   ;
// reg                link    ;
reg  [15:0]        read_data_buf ;
   
 
localparam IDLE            = 4'd0 ;
localparam R_GEN_REQ       = 4'd1 ;
localparam R_REG           = 4'd2 ;
localparam W_GEN_REQ       = 4'd3 ;
localparam W_REG           = 4'd4 ;
localparam R_GEN_REQ_1     = 4'd5 ;
localparam R_REG_1         = 4'd6 ;
localparam SMI_END         = 4'd7 ;
(* MARK_DEBUG="true" *)wire[15:0] phy_reg;
(* MARK_DEBUG="true" *)wire phy_rst_n;
(* MARK_DEBUG="true" *)wire phy_init;
//wire[3:0] led;	 
//assign led[1:0]=phy_reg[15:14];
reg [3:0]    state  ;
/*phy_reg_config phy_reg_config_inst( 
 	 .clock_50m(sys_clk),
 	 .reset_n(rst_n),
	 .phy_mdc(e_mdc),
	 .phy_mdio(e_mdio),
	 .phy_reg(phy_reg),
	 .phy_rst_n(phy_rst_n),
	 .phy_init(phy_init)
					);	*/
reg [3:0]    next_state ;
always @(posedge sys_clk or negedge rst_n)
  begin
    if (~rst_n)
      state  <=  IDLE  ;
    else
      state  <= next_state ;  
  end
(* MARK_DEBUG="true" *)reg phy_init_end;
reg[25:0] tm_cnt;
always @(posedge sys_clk or negedge rst_n)
begin
if (~rst_n)
begin
  tm_cnt  <=  26'd0 ;
  end
else
begin
if(!phy_init_end)
  tm_cnt<=tm_cnt+1'b1;
  else  tm_cnt<=tm_cnt;    
  end
end
  
always @(posedge sys_clk or negedge rst_n)
begin
  if (~rst_n)
  begin
    phy_init_end<=1'b0;
    end
  else
  begin
  if(tm_cnt>=26'd3000000)
  phy_init_end<=1'b1;  
    end
end  
  
always @(*)
 begin 
 if(phy_init_end)
  begin
    case(state)
      IDLE        :
        begin          
            next_state <= R_GEN_REQ_1 ;
        end
      R_GEN_REQ        :
           next_state <= R_REG ;
      R_REG        :
        begin
          if (done)
            next_state <= W_GEN_REQ ;
          else
            next_state <= R_REG ;
        end
	  W_GEN_REQ   :
           next_state <= W_REG ;
      W_REG        :
        begin
          if (done)
            next_state <= R_GEN_REQ_1 ;
          else
            next_state <= W_REG ;
        end
	  R_GEN_REQ_1        :
           next_state <= R_REG_1 ;
      R_REG_1        :
        begin
          if (done)
            next_state <= SMI_END ;
          else
            next_state <= R_REG_1 ;
        end
      SMI_END  : next_state <= SMI_END ;
      default     :
        next_state <= IDLE ;
    endcase
  end
  else next_state<=state;
 end
  

 
always @(posedge sys_clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_req <= 1'b0 ;
	else if (state == R_GEN_REQ || state == R_GEN_REQ_1)
	  read_req <= 1'b1 ;
	else
	  read_req <= 1'b0 ;
  end

always @(posedge sys_clk or negedge rst_n)
  begin
    if (~rst_n)
	  write_req <= 1'b0 ;
	else if (state == W_GEN_REQ)
	  write_req <= 1'b1 ;
	else
	  write_req <= 1'b0 ;
  end  
  
  
always @(posedge sys_clk or negedge rst_n)
  begin
    if (~rst_n)
	  read_data_buf <= 16'd0 ;
	else if (data_valid)
	  read_data_buf <= read_data ;
  end

always @(posedge sys_clk or negedge rst_n)
  begin
    if (~rst_n)
	  phy_addr <= 5'd0 ;
	else 
	  phy_addr <= 5'b00001 ;
  end

always @(posedge sys_clk or negedge rst_n)
  begin
    if (~rst_n)
	  reg_addr <= 5'd0 ;
	else
	  reg_addr <= 5'b10001 ;
  end
 
always @(posedge sys_clk or negedge rst_n)
  begin
    if (~rst_n)
	  write_data <= 16'd0 ;
	else 
	  write_data <= 16'h5555 ;
  end  
 always @(posedge sys_clk or negedge rst_n)
  begin
    if (~rst_n)
	  error <= 1'b0 ;
	else if (state == SMI_END)
	begin
	  if (read_data_buf != write_data)
	    error <= 1'b1 ;
	  else 
	    error <= 1'b0 ;
	end
  end

smi_read_write 
      #(
        .REF_CLK(50),
        .MDC_CLK(500)
	   )
	   smi_inst
       (
        .clk              (sys_clk       ),
        .rst_n            (phy_init_end  ),
        .mdc              (e_mdc       ),
        .mdio             (e_mdio      ),         
        .phy_addr         (phy_addr  ),
        .reg_addr         (reg_addr  ),		 
        .write_req        (write_req ),
        .write_data       (write_data),
        .read_req         (read_req  ),
        .read_data        (read_data ),
        .data_valid       (data_valid),
        .done             (done      )
       );
endmodule
