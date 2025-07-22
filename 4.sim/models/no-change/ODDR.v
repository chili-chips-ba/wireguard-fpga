///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2005 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Unified Simulation Library Component
//  /   /                  Dual Data Rate Output D Flip-Flop
// /___/   /\     Filename : ODDR.v
// \   \  /  \
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    03/11/05 - Added LOC parameter, removed GSR ports and initialized outputs.
//    05/29/07 - Added wire declaration for internal signals
//    04/17/08 - CR 468871 Negative SetupHold fix
//    05/12/08 - CR 455447 add XON MSGON property to support async reg
//    12/03/08 - CR 498674 added pulldown on R/S.
//    07/28/09 - CR 527698 According to holistic, CE has to be high for both rise/fall CLK
//             - If CE is low on the rising edge, it has an effect of no change in the falling CLK.
//    06/23/10 - CR 566394 Removed extra recrem checks
//    12/13/11 - Added `celldefine and `endcelldefine (CR 524859).
//    04/13/12 - CR 591320 fixed SU/H checks in OPPOSITE edge mode.
//    10/22/14 - Added #1 to $finish (CR 808642).
// End Revision

`timescale 1 ps / 1 ps

`celldefine

module ODDR (Q, C, CE, D1, D2, R, S);

    output Q;

    input C;
    input CE;
    input D1;
    input D2;
    input R;
    input S;

    parameter DDR_CLK_EDGE = "OPPOSITE_EDGE";
    parameter INIT = 1'b0;
    parameter [0:0] IS_C_INVERTED = 1'b0;
    parameter [0:0] IS_D1_INVERTED = 1'b0;
    parameter [0:0] IS_D2_INVERTED = 1'b0;

    parameter SRTYPE = "SYNC";
`ifdef XIL_TIMING
    parameter LOC = "UNPLACED";
    parameter MSGON = "TRUE";
    parameter XON = "TRUE";
`endif

    localparam MODULE_NAME = "ODDR";

    pulldown P1 (R);
    pulldown P2 (S);

    reg q_out = INIT, qd2_posedge_int;
`ifdef XIL_TIMING
    reg notifier;
    wire notifierx;
`endif
    tri0 GSR = glbl.GSR;

    wire c_in,delay_c;
    wire ce_in,delay_ce;
    wire d1_in,delay_d1;
    wire d2_in,delay_d2;
    wire gsr_in;
    wire r_in,delay_r;
    wire s_in,delay_s;

    assign gsr_in = GSR;
    assign Q = q_out;

`ifdef XIL_TIMING

    wire nr, ns, ngsr;
    wire ce_c_enable, d_c_enable, r_c_enable, s_c_enable;
    wire ce_c_enable1, d1_c_enable1, d2_c_enable1, d2_c_enable2, r_c_enable1, s_c_enable1;

    not (nr, R);
    not (ns, S);
    not (ngsr, GSR);

    and (ce_c_enable, ngsr, nr, ns);
    and (d_c_enable, ngsr, nr, ns, CE);
    and (s_c_enable, ngsr, nr);

    assign notifierx = (XON == "FALSE") ?  1'bx : notifier;

    assign ce_c_enable1 = (MSGON =="FALSE") ? 1'b0 : ce_c_enable;
    assign d1_c_enable1 = (MSGON =="FALSE") ? 1'b0 : d_c_enable;
    assign d2_c_enable1 = ((MSGON =="FALSE") && (DDR_CLK_EDGE == "OPPOSITE_EDGE")) ? 1'b0 : d_c_enable; // SAME_EDGE case, D2 to posedge C
    assign d2_c_enable2 = ((MSGON =="FALSE") && (DDR_CLK_EDGE == "SAME_EDGE")) ? 1'b0 : d_c_enable; // OPPOSITE_EDGE case, D2 to negedge C
    assign r_c_enable1 = (MSGON =="FALSE") ? 1'b0 : ngsr;
    assign s_c_enable1 = (MSGON =="FALSE") ? 1'b0 : s_c_enable;

`endif

    initial begin

   if ((INIT != 0) && (INIT != 1)) begin
       $display("Attribute Syntax Error : The attribute INIT on %s instance %m is set to %d.  Legal values for this attribute are 0 or 1.", MODULE_NAME, INIT);
       #1 $finish;
   end

       if ((DDR_CLK_EDGE != "OPPOSITE_EDGE") && (DDR_CLK_EDGE != "SAME_EDGE")) begin
       $display("Attribute Syntax Error : The attribute DDR_CLK_EDGE on %s instance %m is set to %s.  Legal values for this attribute are OPPOSITE_EDGE or SAME_EDGE.", MODULE_NAME, DDR_CLK_EDGE);
       #1 $finish;
   end

   if ((SRTYPE != "ASYNC") && (SRTYPE != "SYNC")) begin
       $display("Attribute Syntax Error : The attribute SRTYPE on %s instance %m is set to %s.  Legal values for this attribute are ASYNC or SYNC.", MODULE_NAME, SRTYPE);
       #1 $finish;
   end

    end // initial begin

    always @(gsr_in or r_in or s_in) begin
   if (gsr_in == 1'b1) begin
       q_out <= INIT; //assign q_out = INIT;
       qd2_posedge_int <= INIT; //assign qd2_posedge_int = INIT;
   end
   else if (gsr_in == 1'b0) begin
       if (r_in == 1'b1 && SRTYPE == "ASYNC") begin
      q_out <= 1'b0; //assign q_out = 1'b0;
      qd2_posedge_int <= 1'b0; //assign qd2_posedge_int = 1'b0;
       end
       else if (r_in == 1'b0 && s_in == 1'b1 && SRTYPE == "ASYNC") begin
      q_out <= 1'b1; //assign q_out = 1'b1;
      qd2_posedge_int <= 1'b1; //assign qd2_posedge_int = 1'b1;
       end
       else if ((r_in == 1'b1 || s_in == 1'b1) && SRTYPE == "SYNC") begin
      //deassign q_out;
      //deassign qd2_posedge_int;
       end
       else if (r_in == 1'b0 && s_in == 1'b0) begin
      //deassign q_out;
      //deassign qd2_posedge_int;
       end
   end // if (gsr_in == 1'b0)
    end // always @ (gsr_in or r_in or s_in)


    always @(posedge c_in) begin
    if (r_in == 1'b1) begin
       q_out <= 1'b0;
       qd2_posedge_int <= 1'b0;
   end
   else if (r_in == 1'b0 && s_in == 1'b1) begin
       q_out <= 1'b1;
       qd2_posedge_int <= 1'b1;
   end
   else if (ce_in == 1'b1 && r_in == 1'b0 && s_in == 1'b0) begin
       q_out <= d1_in;
       qd2_posedge_int <= d2_in;
   end
// CR 527698
   else if (ce_in == 1'b0 && r_in == 1'b0 && s_in == 1'b0) begin
       qd2_posedge_int <= q_out;
   end
    end // always @ (posedge c_in)


    always @(negedge c_in) begin
   if (r_in == 1'b1)
       q_out <= 1'b0;
   else if (r_in == 1'b0 && s_in == 1'b1)
       q_out <= 1'b1;
   else if (ce_in == 1'b1 && r_in == 1'b0 && s_in == 1'b0) begin
       if (DDR_CLK_EDGE == "SAME_EDGE")
      q_out <= qd2_posedge_int;
       else if (DDR_CLK_EDGE == "OPPOSITE_EDGE")
      q_out <= d2_in;
   end
    end // always @ (negedge c_in)

`ifndef XIL_TIMING

    assign delay_c = C;
    assign delay_ce = CE;
    assign delay_d1 =  D1;
    assign delay_d2 =  D2;
    assign delay_r = R;
    assign delay_s = S;

`endif
    assign c_in = IS_C_INVERTED ^ delay_c;
    assign ce_in = delay_ce;
    assign d1_in = IS_D1_INVERTED ^ delay_d1;
    assign d2_in = IS_D2_INVERTED ^ delay_d2;
    assign r_in = delay_r;
    assign s_in = delay_s;


//*** Timing Checks Start here

`ifdef XIL_TIMING

   wire c_en_n;
   wire c_en_p;
   wire ce_c_enable1_n,d1_c_enable1_n,d2_c_enable2_n,r_c_enable1_n,s_c_enable1_n;
   wire ce_c_enable1_p,d1_c_enable1_p,d2_c_enable2_p,r_c_enable1_p,s_c_enable1_p;
   assign c_en_n = IS_C_INVERTED;
   assign c_en_p = ~IS_C_INVERTED;
   assign ce_c_enable1_n = ce_c_enable1 && c_en_n;
   assign ce_c_enable1_p = ce_c_enable1 && c_en_p;
   assign d1_c_enable1_n = d1_c_enable1 && c_en_n;
   assign d1_c_enable1_p = d1_c_enable1 && c_en_p;
   assign d2_c_enable2_n = d2_c_enable2 && c_en_n;
   assign d2_c_enable2_p = d2_c_enable2 && c_en_p;
   assign r_c_enable1_n = r_c_enable1 && c_en_n;
   assign r_c_enable1_p = r_c_enable1 && c_en_p;
   assign s_c_enable1_p = s_c_enable1 && c_en_p;
   assign s_c_enable1_n = s_c_enable1 && c_en_n;

    always @(notifierx) begin
   q_out <= 1'bx;
    end

`endif

   specify

   (C => Q) = (100:100:100, 100:100:100);
    (posedge R => (Q +: 0)) = (0:0:0, 0:0:0);
    (posedge S => (Q +: 0)) = (0:0:0, 0:0:0);

`ifdef XIL_TIMING
   (R => Q) = (0:0:0, 0:0:0);
   (S => Q) = (0:0:0, 0:0:0);

   $period (negedge C, 0:0:0, notifier);
   $period (posedge C, 0:0:0, notifier);
   $recrem (negedge R, negedge C, 0:0:0, 0:0:0, notifier,c_en_n,c_en_n);
   $recrem (negedge R, posedge C, 0:0:0, 0:0:0, notifier,c_en_p,c_en_p);
   $recrem (negedge S, negedge C, 0:0:0, 0:0:0, notifier,c_en_n,c_en_n);
   $recrem (negedge S, posedge C, 0:0:0, 0:0:0, notifier,c_en_p,c_en_p);
   $recrem ( posedge R, negedge C, 0:0:0, 0:0:0, notifier,c_en_n,c_en_n);
   $recrem ( posedge R, posedge C, 0:0:0, 0:0:0, notifier,c_en_p,c_en_p);
   $recrem ( posedge S, negedge C, 0:0:0, 0:0:0, notifier,c_en_n,c_en_n);
   $recrem ( posedge S, posedge C, 0:0:0, 0:0:0, notifier,c_en_p,c_en_p);
   $setuphold (negedge C, negedge CE &&& (ce_c_enable1_n!=0), 0:0:0, 0:0:0, notifier, , , delay_c, delay_ce);
   $setuphold (negedge C, negedge D1 &&& (d1_c_enable1_n!=0),  0:0:0, 0:0:0, notifier, , , delay_c, delay_d1);
   $setuphold (negedge C, negedge D2 &&& (d2_c_enable2_n!=0),  0:0:0, 0:0:0, notifier, , , delay_c, delay_d2);
   $setuphold (negedge C, negedge R  &&& (r_c_enable1_n!=0),  0:0:0, 0:0:0,  notifier, , , delay_c, delay_r);
   $setuphold (negedge C, negedge S  &&& (r_c_enable1_n!=0),  0:0:0, 0:0:0,  notifier, , , delay_c, delay_s);
   $setuphold (negedge C, posedge CE &&& (ce_c_enable1_n!=0), 0:0:0, 0:0:0, notifier, , , delay_c, delay_ce);
   $setuphold (negedge C, posedge D1 &&& (d1_c_enable1_n!=0),  0:0:0, 0:0:0, notifier, , , delay_c, delay_d1);
   $setuphold (negedge C, posedge D2 &&& (d2_c_enable2_n!=0),  0:0:0, 0:0:0, notifier, , , delay_c, delay_d2);
   $setuphold (negedge C, posedge R  &&& (r_c_enable1_n!=0),  0:0:0, 0:0:0,  notifier, , , delay_c, delay_r);
   $setuphold (negedge C, posedge S  &&& (r_c_enable1_n!=0),  0:0:0, 0:0:0,  notifier, , , delay_c, delay_s);
   $setuphold (posedge C, negedge CE &&& (ce_c_enable1_p!=0), 0:0:0, 0:0:0, notifier, , , delay_c, delay_ce);
   $setuphold (posedge C, negedge D1 &&& (d1_c_enable1_p!=0),  0:0:0, 0:0:0, notifier, , , delay_c, delay_d1);
   $setuphold (posedge C, negedge D2 &&& (d2_c_enable2_p!=0),  0:0:0, 0:0:0, notifier, , , delay_c, delay_d2);
   $setuphold (posedge C, negedge R  &&& (r_c_enable1_p!=0),  0:0:0, 0:0:0,  notifier, , , delay_c, delay_r);
   $setuphold (posedge C, negedge S  &&& (r_c_enable1_p!=0),  0:0:0, 0:0:0,  notifier, , , delay_c, delay_s);
   $setuphold (posedge C, posedge CE &&& (ce_c_enable1_p!=0), 0:0:0, 0:0:0, notifier, , , delay_c, delay_ce);
   $setuphold (posedge C, posedge D1 &&& (d1_c_enable1_p!=0),  0:0:0, 0:0:0, notifier, , , delay_c, delay_d1);
   $setuphold (posedge C, posedge D2 &&& (d2_c_enable2_p!=0),  0:0:0, 0:0:0, notifier, , , delay_c, delay_d2);
   $setuphold (posedge C, posedge R  &&& (r_c_enable1_p!=0),  0:0:0, 0:0:0,  notifier, , , delay_c, delay_r);
   $setuphold (posedge C, posedge S  &&& (r_c_enable1_p!=0),  0:0:0, 0:0:0,  notifier, , , delay_c, delay_s);
   $width (negedge C, 0:0:0, 0, notifier);
   $width (negedge R, 0:0:0, 0, notifier);
   $width (negedge S, 0:0:0, 0, notifier);
   $width (posedge C, 0:0:0, 0, notifier);
   $width (posedge R, 0:0:0, 0, notifier);
   $width (posedge S, 0:0:0, 0, notifier);

`endif
   //specparam PATHPULSE$ = 0;

   endspecify

endmodule // ODDR

`endcelldefine
