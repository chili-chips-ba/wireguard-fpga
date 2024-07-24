  //mdc, mdio数据传输时序代码
module mdio_com(
            input          mdc,          //mdc控制接口传输所需时钟，此处为20khz
				inout          mdio,
            input          reset_n,  
            input          if_read,	
            output reg [15:0]  phy_reg,				
            input [23:0]   mdio_data,          //mdio接口传输的24位数据
            input          start,              //开始传输标志
            output reg     tr_end             //传输结束标志

                );         


    reg [5:0] cyc_count;
    reg reg_mdio;
	 reg mdio_out;
    reg data_come;

    assign mdio=mdio_out?reg_mdio:1'bz;
   
   
    always@(posedge mdc or  negedge reset_n)
    begin
       if(!reset_n)
           cyc_count<=6'b111111;
       else begin
       if(start==0)
           cyc_count<=0;
       else if(cyc_count<6'b111111)
           cyc_count<=cyc_count+1;
       end
    end
	 
    always@(negedge mdc or negedge reset_n)
    begin
       if(!reset_n) begin
          tr_end<=0;
          reg_mdio<=1;
			 mdio_out<=1'b1;
			 data_come<=1'b0; 
       end
       else
        case(cyc_count)
        0:begin tr_end<=0;reg_mdio<=1;mdio_out<=1'b1;data_come<=1'b0; end
        1:reg_mdio<=1'b0;            //开始传输 Start
        2:reg_mdio<=1'b1;
        3:begin                        //OP CODE 01=write; 10=read
   		  if (if_read==1'b1) 
		        reg_mdio<=1'b1;           		  
			  else
		        reg_mdio<=1'b0;           
		  end			  
        4:begin                        //OP CODE 01=write
   		  if (if_read==1'b1) 
		        reg_mdio<=1'b0;           		  
			  else
		        reg_mdio<=1'b1;           
		  end	         
        4:reg_mdio<=1'b1;
        5:reg_mdio<=1'b0;            //PHY ADDRESS 0b00001
        6:reg_mdio<=1'b0;
        7:reg_mdio<=1'b0;
        8:reg_mdio<=1'b0;
        9:reg_mdio<=1'b1;
        10:reg_mdio<=mdio_data[20];   //reg adress 5bit 
        11:reg_mdio<=mdio_data[19];              
        12:reg_mdio<=mdio_data[18];    
        13:reg_mdio<=mdio_data[17];    
        14:reg_mdio<=mdio_data[16];    
        15:begin
		     if (if_read==1'b1) 
		        mdio_out<=1'b0;           //turn around			  
			  else begin
		        reg_mdio<=1'b1;           //turn around
				  mdio_out<=1'b1;
			  end	  
		  end		  
        16:reg_mdio<=1'b0;           //turn around
        17: begin reg_mdio<=mdio_data[15];data_come<=1'b1; end   //reg data
        18:reg_mdio<=mdio_data[14]; 
        19:reg_mdio<=mdio_data[13];
        20:reg_mdio<=mdio_data[12];
        21:reg_mdio<=mdio_data[11];
        22:reg_mdio<=mdio_data[10];
        23:reg_mdio<=mdio_data[9];		  
        24:reg_mdio<=mdio_data[8];
        25:reg_mdio<=mdio_data[7];				  
        26:reg_mdio<=mdio_data[6];
        27:reg_mdio<=mdio_data[5];
        28:reg_mdio<=mdio_data[4];
        29:reg_mdio<=mdio_data[3];
        30:reg_mdio<=mdio_data[2];
        31:reg_mdio<=mdio_data[1];
        32:reg_mdio<=mdio_data[0];
        33:begin reg_mdio<=1'b1;tr_end<=1;data_come<=1'b0;end
        endcase
       
    end

    always@(posedge mdc or negedge reset_n)
    begin
       if(!reset_n) begin
			 phy_reg<=0;
       end
		 else begin
		    if (data_come==1'b1)
			   phy_reg<={phy_reg[14:0], mdio};
			 else
 			   phy_reg<=phy_reg;  
		 end
    end		 

endmodule

