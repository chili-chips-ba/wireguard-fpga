`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/06 09:11:27
// Design Name: 
// Module Name: dly_coms
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


module dly_cmos(
input                   clk1,
input                   clk2,
input[7:0]              cmos1_db,
input[7:0]              cmos2_db,
input                   cmos1_href,
input                   cmos2_href,
output reg[7:0]         cmos1_d_d0,
output reg[7:0]         cmos2_d_d0,
output reg              cmos1_href_d0,
output reg              cmos2_href_d0
    );
    
always@(posedge clk1)
begin
    cmos1_d_d0 <= cmos1_db;
    cmos1_href_d0 <= cmos1_href;
end  

always@(posedge clk2)
begin
    cmos2_d_d0 <= cmos2_db;
    cmos2_href_d0 <= cmos2_href;
end  
endmodule
