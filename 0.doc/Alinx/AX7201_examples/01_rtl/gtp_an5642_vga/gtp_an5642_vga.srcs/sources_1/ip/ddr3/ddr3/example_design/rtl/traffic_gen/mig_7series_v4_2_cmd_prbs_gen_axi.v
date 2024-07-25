//*****************************************************************************
// (c) Copyright 2008-2009 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: %version
//  \   \         Application: MIG
//  /   /         Filename: cmd_prbs_gen.v
// /___/   /\     Date Last Modified:
// \   \  /  \    Date Created:
//  \___\/\___\
//
//Device: Spartan6
//Design Name: DDR/DDR2/DDR3/LPDDR
//Purpose:  This moduel use LFSR to generate random address, isntructions
//          or burst_length.
//Reference:
//Revision History:     1.1 Added condition to zero out the LSB address bits according to
//                      DWIDTH and FAMILY. 7/9/2009       
//
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_v4_2_cmd_prbs_gen_axi #
  (
   parameter TCQ                 = 100,
   parameter FAMILY              = "SPARTAN6",
   parameter ADDR_WIDTH          = 29,
   parameter DWIDTH              = 32,
   parameter PRBS_CMD            = "ADDRESS", // "INSTR", "BLEN","ADDRESS"
   parameter PRBS_WIDTH          = 64,        //   64,15,20
   parameter SEED_WIDTH          = 32,        //   32,15,4

   parameter PRBS_EADDR_MASK_POS = 32'hFFFFD000,
   parameter PRBS_SADDR_MASK_POS = 32'h00002000,
   parameter PRBS_EADDR          = 32'h00002000,
   parameter PRBS_SADDR          = 32'h00002000
   )
  (
   input                         clk_i,
   input                         prbs_seed_init,  // when high the prbs_x_seed will be loaded
   input                         clk_en,
   input [SEED_WIDTH-1:0]        prbs_seed_i,
   output[SEED_WIDTH-1:0]        prbs_o           // generated address
  );

  wire[ADDR_WIDTH - 1:0]         ZEROS;
  reg [SEED_WIDTH - 1:0]         prbs;
  reg [PRBS_WIDTH :1]            lfsr_q;

assign ZEROS = 'b0;
//
//**************************************************************
//####################################################################################################################
//                                                                                                                   #
//                                                                                                                   #
// 64 taps: [64,63,61,60]: {{8'b01011000}, {56'b0}}                                                                  #
//  upper 32 bits are loadable                                                                                       #
//                                                                                                                   #
//
//
//     ........................................................................................
//         ^                  ^                      ^             ^                          |
//         |   ____           |  ___     ___         | ___         |  ___     ___     ___     |
//         |   |   |   |---|<-  |   |   |   | |---|<- |   |  |---|<- |   |...|   |   |   |    |  The first 32 bits are parallel loadable.
//         ----|64 |<--|xor|<-- |63 |-->|62 |-|xor|<--|61 |<-|xor|<--|60 |...|33 |<--|1|<<--
//             |___|    ---     |___|   |___|  ---    |___|   ---    |___|...|___|   |___|
//
//
//                                           <<-- shifting  --
//#####################################################################################################################

// use SRLC32E for lower 32 stages and 32 registers for upper 32 stages.
// we need to provide 30 bits addres. SRLC32 has only one bit output.
// address seed will be loaded to upper 32 bits.
//
//  parallel load and serial shift out to  LFSR  during INIT time

generate
  if(PRBS_CMD == "ADDRESS" && PRBS_WIDTH == 64) begin :gen64_taps
    always @ (posedge clk_i) begin
      if(prbs_seed_init) begin//reset it to a known good state to prevent it locks up
        lfsr_q <= #TCQ {31'b0,prbs_seed_i};
      end else if(clk_en) begin
        lfsr_q[64] <= #TCQ lfsr_q[64] ^ lfsr_q[63];
        lfsr_q[63] <= #TCQ lfsr_q[62];
        lfsr_q[62] <= #TCQ lfsr_q[64] ^ lfsr_q[61];
        lfsr_q[61] <= #TCQ lfsr_q[64] ^ lfsr_q[60];
        lfsr_q[60:2] <= #TCQ lfsr_q[59:1];
        lfsr_q[1] <= #TCQ lfsr_q[64];
      end
    end

    always @(lfsr_q[32:1]) begin
      prbs = lfsr_q[32:1];
    end
  end
endgenerate

function integer logb2;
  input [31:0] in;
  integer i;
  begin
    i = in;
      for(logb2=1; i>0; logb2=logb2+1)
        i = i >> 1;
  end
endfunction

generate
  if(PRBS_CMD == "ADDRESS" && PRBS_WIDTH == 32) begin :gen32_taps
    always @ (posedge clk_i) begin
      if(prbs_seed_init) begin //reset it to a known good state to prevent it locks up
        lfsr_q <= #TCQ {prbs_seed_i};
      end else if(clk_en) begin
        lfsr_q[32:9] <= #TCQ lfsr_q[31:8];
        lfsr_q[8]    <= #TCQ lfsr_q[32] ^ lfsr_q[7];
        lfsr_q[7]    <= #TCQ lfsr_q[32] ^ lfsr_q[6];
        lfsr_q[6:4]  <= #TCQ lfsr_q[5:3];

        lfsr_q[3]    <= #TCQ lfsr_q[32] ^ lfsr_q[2];
        lfsr_q[2]    <= #TCQ lfsr_q[1] ;
        lfsr_q[1]    <= #TCQ lfsr_q[32];
      end
    end

    integer i;
    always @(lfsr_q[32:1]) begin
    
     if (FAMILY == "SPARTAN6" ) begin  // for 32 bits
    
      for(i = logb2(DWIDTH) + 1; i <= SEED_WIDTH - 1; i = i + 1)

       if(PRBS_SADDR_MASK_POS[i] == 1)
          prbs[i] = PRBS_SADDR[i] | lfsr_q[i+1];
       else if(PRBS_EADDR_MASK_POS[i] == 1)
          prbs[i] = PRBS_EADDR[i] & lfsr_q[i+1];
       else
          prbs[i] =  lfsr_q[i+1];
          
       prbs[logb2(DWIDTH )  :0] = {logb2(DWIDTH ) + 1{1'b0}};         

      end
    else begin
     for(i = logb2(DWIDTH)-4; i <= SEED_WIDTH - 1; i = i + 1)
       if(PRBS_SADDR_MASK_POS[i] == 1)
          prbs[i] = PRBS_SADDR[i] | lfsr_q[i+1];
       else if(PRBS_EADDR_MASK_POS[i] == 1)
          prbs[i] = PRBS_EADDR[i] & lfsr_q[i+1];
       else
          prbs[i] =  lfsr_q[i+1];
     prbs[logb2(DWIDTH)-5:0] = {logb2(DWIDTH) - 4{1'b0}};

    end  
 
  end  
end endgenerate

//////////////////////////////////////////////////////////////////////////
//####################################################################################################################
//                                                                                                                   #
//                                                                                                                   #
// 15 taps: [15,14]:                                                                                                 #
//                                                                                         #
//                                                                                                                   #
//
//
//         .............................................................
//         ^                  ^              .                           ^
//         |   ____           |  ___     ___     ___     ___     ___     |
//         |   |   |   |---|<-  |   |   |   |   |   |...|   |   |   |    |
//         ----|15 |<--|xor|<-- |14 |<--|13 |<--|12 |...|2  |<--|1  |<<--
//             |___|    ---     |___|   |___|   |___|...|___|   |___|
//
//
//                                           <<-- shifting  --
//#####################################################################################################################

generate
  if(PRBS_CMD == "INSTR" | PRBS_CMD == "BLEN") begin :gen20_taps
    always @(posedge clk_i) begin
      if(prbs_seed_init) begin//reset it to a known good state to prevent it locks up
        lfsr_q <= #TCQ {5'b0,prbs_seed_i[14:0]};
      end else if(clk_en) begin
        lfsr_q[20]   <= #TCQ lfsr_q[19];
        lfsr_q[19]   <= #TCQ lfsr_q[18];

        lfsr_q[18]   <= #TCQ lfsr_q[20] ^lfsr_q[17];

        lfsr_q[17:2] <= #TCQ lfsr_q[16:1];
        lfsr_q[1]    <= #TCQ lfsr_q[20];
      end
    end

    always @ (lfsr_q) begin
      prbs = lfsr_q[32:1];
    end
  end
endgenerate

assign prbs_o = prbs;

endmodule
