///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2015 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 2015.4
//  \   \         Description : Xilinx Formal Library Component
//  /   /                  Global Clock Mux Buffer with Output State 0
// /___/   /\     Filename : BUFGMUX.v
// \   \  /  \
//  \___\/\___\
//
///////////////////////////////////////////////////////////////////////////////
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.
//    01/11/08 - Add CLK_SEL_TYPE attribute.
//    12/13/11 - Added `celldefine and `endcelldefine (CR 524859).
// End Revision
///////////////////////////////////////////////////////////////////////////////

`timescale  1 ps / 1 ps

`celldefine

module BUFGMUX (O, I0, I1, S);

    parameter CLK_SEL_TYPE = "SYNC";
    output O;

    input  I0, I1, S;

    reg    O;
    
        always @(I0 or I1 or S) begin

            if (S)
                O <= I1;

            else
                O <= I0;

        end

endmodule

`endcelldefine
