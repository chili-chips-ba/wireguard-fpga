//寄存器的配置程序
 module phy_reg_config(
 input clock_50m,
 input reset_n,
 output reg phy_rst_n,
 output [15:0] phy_reg,
 output phy_mdc,
 inout phy_mdio,
 output reg phy_init
);
    
reg clock_20k;
reg [15:0]clock_20k_cnt;
reg [1:0]config_step;
reg [3:0]reg_index;
reg [23:0]mdio_data;
reg [23:0]reg_data;
reg start;
reg if_read;
wire tr_end;
assign phy_mdc =clock_20k; 

//MDIO通信程序
mdio_com u1(
   .reset_n(phy_rst_n),
   .if_read(if_read),
   .phy_reg(phy_reg),
   .mdio_data(mdio_data),
   .start(start),
   .tr_end(tr_end),
   .mdc(clock_20k),
   .mdio(phy_mdio)
   );

//产生i2c控制时钟-20khz  
always@(posedge clock_50m or negedge reset_n)   
begin
   if(!reset_n) begin
      clock_20k<=0;
      clock_20k_cnt<=0;
   end
   else if(clock_20k_cnt<1249)
      clock_20k_cnt<=clock_20k_cnt+1;
   else begin
      clock_20k<=!clock_20k;
      clock_20k_cnt<=0;
   end
end

			  
//复位延时		  
reg [15:0] phy_cnt1;  
always@(posedge clock_20k or negedge reset_n)
begin
   if (reset_n==1'b0) begin
	     phy_cnt1<=0;
		 phy_rst_n<=1'b0;		 
	end	 
   else begin
		if(phy_cnt1<16'h190) begin         //复位延时400*50us=20ms	      
			phy_cnt1<=phy_cnt1+1;
			phy_rst_n<=1'b0;
		end
		else
			phy_rst_n<=1'b1;
   end			
end
		

//复位延时	1	  
reg [15:0] phy_cnt2; 
reg phy_config_en; 

always@(posedge clock_20k or negedge phy_rst_n)
begin
   if (phy_rst_n == 1'b0) begin
	     phy_cnt2<=0;
		 phy_config_en<=1'b0;
   end		 
   else begin
		if(phy_cnt2<16'h4b0) begin         //复位延时1200*50us=60ms	      
			phy_cnt2<=phy_cnt2+1;
			phy_config_en<=1'b0;
		end
		else
			phy_config_en<=1'b1;  
   end			
end

    
//PHY寄存器配置过程控制	
reg [15:0] phy_cont; 
always@(posedge clock_20k)    
begin
   if((!phy_rst_n) | (!phy_config_en)) begin
         config_step<=0;
         start<=0;
         reg_index<=0;
		 phy_init<=1'b0;
		 phy_cont<=0;
		 if_read<=1'b0;
   end
   else begin
       if(reg_index<2) begin                    //PHY 寄存器写
		   if_read<=1'b0;		 
           case(config_step)
           0:begin
              mdio_data<=reg_data;           
              start<=1;                           //开始mdio数据传输
              config_step<=1;
            end
            1:begin
              if(tr_end) begin                    //mdio发送结束
                 config_step<=2;
                 start<=0;
              end
            end
            2:begin
              reg_index<=reg_index+1;            //配置下一个寄存器
              config_step<=0;
            end
            endcase
        end  	  
   end
end
			
//PHY的寄存器赋值	
always@(reg_index)   
begin
        case(reg_index)		  
        0:reg_data<=24'h001900;          //power down
        1:reg_data<=24'h001100; 		  //restart auto-negatiation        
       default:reg_data<=24'h001300;
      endcase
end


endmodule

