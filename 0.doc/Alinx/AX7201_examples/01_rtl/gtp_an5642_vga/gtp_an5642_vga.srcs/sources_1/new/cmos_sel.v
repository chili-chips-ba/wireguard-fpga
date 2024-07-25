`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/06 09:40:40
// Design Name: 
// Module Name: cmos_sel
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


module cmos_sel(
input               sys_clk,
input               key_negedge,
output reg[31:0]    gt_tx_data,
output reg[3:0]     gt_tx_ctrl,

input[31:0]         gt_tx_data0,
input[3:0]          gt_tx_ctrl0,
input[31:0]         gt_tx_data1,
input[3:0]          gt_tx_ctrl1
    );
 reg cmos_sel;
always@(posedge sys_clk)
    begin
        if(key_negedge)
           cmos_sel <= ~cmos_sel;
    end    
    always@(posedge sys_clk)
    begin
        if(cmos_sel)
        begin
            gt_tx_data  <= gt_tx_data1;
            gt_tx_ctrl <= gt_tx_ctrl1;       
        end
        else
        begin
            gt_tx_data  <= gt_tx_data0;
            gt_tx_ctrl <= gt_tx_ctrl0;       
        end    
    end
endmodule
