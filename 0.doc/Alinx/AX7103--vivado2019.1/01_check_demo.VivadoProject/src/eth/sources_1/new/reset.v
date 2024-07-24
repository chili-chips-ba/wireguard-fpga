
module reset(
	input clk,
	input key1,
	output rst_n
);
reg[27:0] cnt = 28'd0;
reg rst_n_reg;
assign rst_n = rst_n_reg;
always@(posedge clk)
   if(key1==1'b0)
        cnt <= 0;
    else
    	if(cnt != 28'h3ffffff)
	    	cnt <= cnt + 1'd1;
	    else
		    cnt <= cnt;
always@(posedge clk)
	rst_n_reg <= (cnt == 28'h3ffffff);
endmodule 
