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

module lut_hdmi(
	input[9:0]             lut_index,   //Look-up table address
	output reg[31:0]       lut_data     //Device address (8bit I2C address), register address, register data
);

always@(*)
begin
	case(lut_index)			  
		8'd0: lut_data <= {8'h72,16'h08,8'h35};
		8'd1: lut_data <= {8'h7a,16'h2f,8'h00};
		8'd2: lut_data <= {8'h60,16'h05,8'h10};
		8'd3: lut_data <= {8'h60,16'h08,8'h05};
		8'd4: lut_data <= {8'h60,16'h09,8'h01};
		8'd5: lut_data <= {8'h60,16'h05,8'h04};
		default:lut_data <= {8'hff,16'hffff,8'hff};
	endcase
end


endmodule 