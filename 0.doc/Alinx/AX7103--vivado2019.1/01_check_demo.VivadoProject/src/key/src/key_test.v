//////////////////////////////////////////////////////////////////////////////////
//  key test                                                                    //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
                        
//================================================================================
//  Revision History:
 //  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2017/7/19     meisq          1.0         Original
//*******************************************************************************/
module key_test
(
input                  sys_clk,          //system clock positive


input                  key,             //input two key signal,when the keydown,the value is 0
output[2:0]            led                 //LED display ,when the siganl high,LED lighten
);
                        
 reg[2:0]              led_r;             //define the first stage register , generate two D Flip-flop 
 reg[2:0]              led_r1;            //define the second stage register ,generate two D Flip-flop

 

always@(posedge sys_clk)
 begin
    led_r <= ~{3{key}};                        //first stage latched data
 end
                        
always@(posedge sys_clk)
begin
    led_r1 <= led_r;                          //second stage latched data
end
                        
 assign led = led_r1;
endmodule 