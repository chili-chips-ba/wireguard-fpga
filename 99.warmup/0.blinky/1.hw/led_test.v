//===========================================================================
// Module name: led_test.v
//===========================================================================
`timescale 1ns / 1ps
module led_test 
(  
sys_clk_p,          //system clock positive
sys_clk_n,          //system clock negative
rst_n,              // reset ,low active            
led                 // LED,use for control the LED signal on board
);            
//===========================================================================
// PORT declarations
//===========================================================================
input           sys_clk_p;
input           sys_clk_n;
input           rst_n;
output [1:0]    led;

//define the time counter
reg [31:0]      timer;                  
reg [1:0]       led;
wire            sys_clk;          

IBUFDS sys_clk_ibufgds
(
.O              (sys_clk                  ),
.I              (sys_clk_p                ),
.IB             (sys_clk_n                )
);
//===========================================================================
// cycle counter:from 0 to 1sec
//===========================================================================
always @(posedge sys_clk or negedge rst_n)    
begin
  if (~rst_n)                           
      timer <= 32'd0;                     // when the reset signal valid,time counter clearing
  else if (timer == 32'd199_999_999)    //4 seconds count(200M-1=199999999)
      timer <= 32'd0;                       //count done,clearing the time counter
  else
      timer <= timer + 1'b1;            //timer counter = timer counter + 1
end

//===========================================================================
// LED control
//===========================================================================
always @(posedge sys_clk or negedge rst_n)   
begin
  if (~rst_n)                      
      led <= 2'b00;                  //when the reset signal active         
  else if (timer == 32'd49_999_999)    //time counter count to 0.25 sec,LED2 lighten 
      led <= 2'b01;                 
  else if (timer == 32'd99_999_999)    //time counter count to 0.5 sec,LED1lighten
  begin
      led <= 2'b10;                  
    end
  else if (timer == 32'd149_999_999)   //time counter count to 0.75 sec,LED2 lighten
      led <= 2'b01;                                          
  else if (timer == 32'd199_999_999)   //time counter count to 1 sec,LED1 lighten
      led <= 4'b10;                         
end
endmodule