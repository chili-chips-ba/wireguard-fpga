//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
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
module sobel (
input                       rst,
input                       pclk,
input[7:0]                  threshold,
input                       ycbcr_hs,
input                       ycbcr_vs,
input                       ycbcr_de,
input[7:0]                  data_in,
output reg[7:0]             data_out,
output                      sobel_hs,
output                      sobel_vs,
output                      sobel_de
);
reg[7:0] p11,p12,p13;
reg[7:0] p21,p22,p23;
reg[7:0] p31,p32,p33;
wire[7:0] p1,p2,p3;
reg[9:0] x1,x3;
reg[9:0] y1,y3;
reg[9:0] abs_x,abs_y;
reg[10:0] abs_g;

reg [8:0] hs_buf ;
reg [8:0] vs_buf ;
reg [8:0] de_buf ;

linebuffer_Wapper#
(
	.no_of_lines(3),
	.samples_per_line(1024),
	.data_width(8)
)
 linebuffer_Wapper_m0(
	.ce         (1'b1       ),
	.wr_clk     (pclk       ),
	.wr_en      (ycbcr_de   ),
	.wr_rst     (rst        ),
	.data_in    (data_in    ),
	.rd_en      (ycbcr_de   ),
	.rd_clk     (pclk       ),
	.rd_rst     (rst        ),
	.data_out   ({p3,p2,p1} )
   );
always@(posedge pclk)
begin
	p11 <= p1;
	p21 <= p2;
	p31 <= p3;
	
	p12 <= p11;
	p22 <= p21;
	p32 <= p31;
	
	p13 <= p12;
	p23 <= p22;
	p33 <= p32;
end

always@(posedge pclk)
begin
	x1 <= {2'b00,p11} + {2'b00,p31} + {1'b0,p21,1'b0};
	x3 <= {2'b00,p13} + {2'b00,p33} + {1'b0,p23,1'b0};
	
	y1 <= {2'b00,p11} + {2'b00,p13} + {1'b0,p12,1'b0};
	y3 <= {2'b00,p31} + {2'b00,p33} + {1'b0,p32,1'b0};
end

always@(posedge pclk)
begin
	abs_x <= (x1 > x3) ? x1 - x3 : x3 - x1;
	abs_y <= (y1 > y3) ? y1 - y3 : y3 - y1;
	abs_g <= abs_x + abs_y;
end

always@(posedge pclk)
begin
	data_out <= (abs_g > threshold) ? 8'h00 : 8'hff;
end
//hs vs de delay 9 clock
always@(posedge pclk or posedge rst)
begin
  if (rst)
  begin
    hs_buf <= 9'd0 ;
    vs_buf <= 9'd0 ;
    de_buf <= 9'd0 ;
  end
  else
  begin
    hs_buf <= {hs_buf[7:0], ycbcr_hs} ;
	 vs_buf <= {vs_buf[7:0], ycbcr_vs} ;
	 de_buf <= {de_buf[7:0], ycbcr_de} ;
  end
end

assign sobel_hs = hs_buf[8] ;
assign sobel_vs = vs_buf[8] ;
assign sobel_de = de_buf[8] ;

endmodule