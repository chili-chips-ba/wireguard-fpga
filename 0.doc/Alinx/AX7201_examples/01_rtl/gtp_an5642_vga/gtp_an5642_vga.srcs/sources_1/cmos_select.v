/*-------------------------------------------------------------------------
Filename			:		cmos_select.v
Description		:		
Modification History	:
Data			By			Version			Change Description
===========================================================================
15/02/1
--------------------------------------------------------------------------*/
module	cmos_select
(
     input                                        clk,
     input                                        reset_n, 
     input                                        key1, 
     
     output                                      cmos_vsync,       //cmos vsync
     output                                      cmos_href,        //cmos hsync refrence
     output                                      cmos_pclk,        //cmos pxiel clock
     output  [7:0]                               cmos_d,          //cmos data

     input                                        cmos1_vsync,       //cmos vsync
     input                                        cmos1_href,        //cmos hsync refrence
     input                                        cmos1_pclk,        //cmos pxiel clock
     input   [7:0]                                cmos1_d,          //cmos data

     input                                        cmos2_vsync,       //cmos vsync
     input                                        cmos2_href,        //cmos hsync refrence
     input                                        cmos2_pclk,        //cmos pxiel clock
     input   [7:0]                                cmos2_d          //cmos data

);

reg key_sig;
reg [15:0] key_counter;
/*reg cmos1_vsync_r0,cmos2_vsync_r0;
reg cmos1_vsync_r1,cmos2_vsync_r1;*/
/*wire cmos_pclk_w;
wire cmos_href_w;
wire cmos_vsync_w;
wire cmos_d_w;*/
/*always @(posedge clk)
    begin
	  cmos1_vsync_r1<=cmos1_vsync_r0;
	  cmos1_vsync_r0<=cmos1_vsync;
	
    end
  always @(posedge clk)
        begin
        
          cmos2_vsync_r1<=cmos2_vsync_r0;
          cmos2_vsync_r0<=cmos2_vsync;
       end*/
assign cmos_pclk = key_sig ? cmos1_pclk : cmos2_pclk;
assign cmos_href = key_sig ? cmos1_href : cmos2_href;
assign cmos_vsync = key_sig ? cmos1_vsync : cmos2_vsync;
//assign cmos_vsync = key_sig ? cmos1_vsync_r1 : cmos2_vsync_r1;
assign cmos_d = key_sig ? cmos1_d : cmos2_d;  
    /* always @(posedge clk)
      begin
      
        cmos_pclk<=cmos_pclk_w;
     end    
      always @(posedge clk)
      begin
      
        cmos_href<=cmos_href_w;
     end  
     always @(posedge clk)
      begin
      
        cmos_vsync<=cmos_vsync_w;
     end    
      always @(posedge clk)
      begin
      
        cmos_d<=cmos_d_w;
     end  */
//按钮处理程序
always @(posedge clk or negedge reset_n)
   if (!reset_n) begin
	    key_counter<=0;
	    key_sig<=1'b0;
    end
	else begin
	    if (key1==1'b1)                               //如果按钮没有按下，按下寄存器为0
	       key_counter<=0;
	    else if ((key1==1'b0)& (key_counter<16'hffff))        //如果按钮按下并按下时间少于10ms,计数      
           key_counter<=key_counter+1'b1;
  	  
        if (key_counter==16'hfffe)                 //检测到按键按下 
			   key_sig<=~key_sig;                        
		else
			   key_sig<=key_sig;
				
     end 
     
 endmodule
 
     