  //mdc, mdio数据传输时序代码
module mdio_com(
            input          mdc,          //mdc控制接口传输所需时钟，此处为20khz
				inout          mdio,
            input          reset_n,     
            input [23:0]   mdio_data,          //mdio接口传输的24位数据
            input          start,              //开始传输标志
            output reg     tr_end             //传输结束标志

                );         


    reg [5:0] cyc_count;
    reg reg_mdio;


    assign mdio=reg_mdio?1'bz:0;
   
   
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
       end
       else
        case(cyc_count)
        0:begin tr_end<=0;reg_mdio<=1;end
        1:reg_mdio<=1'b0;            //开始传输 Start
        2:reg_mdio<=1'b1;
        3:reg_mdio<=1'b0;            //OP CODE 01=write
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
        15:reg_mdio<=1'b1;           //turn around
        16:reg_mdio<=1'b0;
        17:reg_mdio<=mdio_data[15];   //reg data
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
        33:begin reg_mdio<=1'b1;tr_end<=1;end
        endcase
       
end
endmodule

