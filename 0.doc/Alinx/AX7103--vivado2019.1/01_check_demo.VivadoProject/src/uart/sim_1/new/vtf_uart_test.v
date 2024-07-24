`timescale 100ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/10 11:08:12
// Design Name: 
// Module Name: vtf_uart_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module vtf_uart_test;
	// Inputs
	reg sys_clk_p;
    wire sys_clk_n;
	reg rst_n;
	reg uart_rx;

	// Outputs
    wire uart_tx;

	// Instantiate the Unit Under Test (UUT)
    uart_test uut (
        .sys_clk_p                  (sys_clk_p          ), 
        .sys_clk_n                  (sys_clk_n          ), 
        .rst_n                      (rst_n              ),
        .uart_rx                    (uart_rx            ),
        .uart_tx                    (uart_tx            )

    );

	initial begin
		// Initialize Inputs
		sys_clk_p = 0;
		rst_n = 0;

		// Wait 1000 ns for global reset to finish
		#1000;
          rst_n = 1;        
		// Add stimulus here
		#2000000;
      //  $stop;
	 end
   
     always #25 sys_clk_p = ~ sys_clk_p;   //5ns一个周期，产生200MHz时钟源
     assign sys_clk_n=~sys_clk_p;
   
    parameter                        BPS_115200 = 86800;//每个比特的时间
    parameter                        SEND_DATA = 8'b1010_0011;//      
    
    integer i = 0;
       
      initial begin
        uart_rx = 1'b1;    //bus idle
        #10000 uart_rx = 1'b0;     //stranmit start bit
        
        for (i=0;i<8;i=i+1)
        #BPS_115200 uart_rx = SEND_DATA[i];     //stranmit data bit
      
        #BPS_115200 uart_rx = 1'b0;     //stranmit stop bit
        #BPS_115200 uart_rx = 1'b1;     //bus idle
        
       end   
   	  
   	      
endmodule
