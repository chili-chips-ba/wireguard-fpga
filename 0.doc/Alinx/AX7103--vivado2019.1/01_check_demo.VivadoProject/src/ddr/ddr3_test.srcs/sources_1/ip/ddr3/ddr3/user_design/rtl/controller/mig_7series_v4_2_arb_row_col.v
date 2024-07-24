//*****************************************************************************
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
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
// /___/  \  /    Vendor                : Xilinx
// \   \   \/     Version               : %version
//  \   \         Application           : MIG
//  /   /         Filename              : arb_row_col.v
// /___/   /\     Date Last Modified    : $date$
// \   \  /  \    Date Created          : Tue Jun 30 2009
//  \___\/\___\
//
//Device            : 7-Series
//Design Name       : DDR3 SDRAM
//Purpose           :
//Reference         :
//Revision History  :
//*****************************************************************************


// This block receives request to send row and column commands.  These requests
// come the individual bank machines.  The arbitration winner is selected
// and driven back to the bank machines.
//
// The CS enables are generated.  For 2:1 mode, row commands are sent
// in the "0" phase, and column commands are sent in the "1" phase.
//
// In 2T mode, a further arbitration is performed between the row
// and column commands.  The winner of this arbitration inhibits
// arbitration by the loser.  The winner is allowed to arbitrate, the loser is
// blocked until the next state.  The winning address command
// is repeated on both the "0" and the "1" phases and the CS
// is asserted for just the "1" phase.

`timescale 1 ps / 1 ps

module mig_7series_v4_2_arb_row_col #
  (
   parameter TCQ = 100,
   parameter ADDR_CMD_MODE            = "1T",
   parameter CWL                      = 5,
   parameter EARLY_WR_DATA_ADDR       = "OFF",
   parameter nBANK_MACHS              = 4,
   parameter nCK_PER_CLK              = 2,
   parameter nRAS                     = 37500,    // ACT->PRE cmd period (CKs)
   parameter nRCD                     = 12500,    // ACT->R/W delay (CKs)
   parameter nWR                      = 6         // Write recovery (CKs)
  )
  (/*AUTOARG*/
  // Outputs
  grant_row_r, grant_pre_r, sent_row, sending_row, sending_pre, grant_config_r,
  rnk_config_strobe, rnk_config_valid_r, grant_col_r,
  sending_col, sent_col, sent_col_r, grant_col_wr, send_cmd0_row, send_cmd0_col,
  send_cmd1_row, send_cmd1_col, send_cmd2_row, send_cmd2_col, send_cmd2_pre,
  send_cmd3_col, col_channel_offset, cs_en0, cs_en1, cs_en2, cs_en3,
  insert_maint_r1, rnk_config_kill_rts_col,
  // Inputs
  clk, rst, rts_row, rts_pre, insert_maint_r, rts_col, rtc, col_rdy_wr
  );

  // Create a delay when switching ranks
  localparam RNK2RNK_DLY = 12;
  localparam RNK2RNK_DLY_CLKS =
    (RNK2RNK_DLY / nCK_PER_CLK) + (RNK2RNK_DLY % nCK_PER_CLK ? 1 : 0);
  
  input clk;
  input rst;

  input [nBANK_MACHS-1:0] rts_row;
  input insert_maint_r;
  input [nBANK_MACHS-1:0] rts_col;
  reg [RNK2RNK_DLY_CLKS-1:0] rnk_config_strobe_r;
  wire block_grant_row;
  wire block_grant_col;
  wire rnk_config_kill_rts_col_lcl =
    RNK2RNK_DLY_CLKS > 0 ? |rnk_config_strobe_r : 1'b0;

  output rnk_config_kill_rts_col;
  assign rnk_config_kill_rts_col = rnk_config_kill_rts_col_lcl;

  wire [nBANK_MACHS-1:0] col_request;
  wire granted_col_ns = |col_request;
  wire [nBANK_MACHS-1:0] row_request =
                          rts_row & {nBANK_MACHS{~insert_maint_r}};
  wire granted_row_ns = |row_request;
  generate
    if (ADDR_CMD_MODE == "2T" && nCK_PER_CLK != 4) begin : row_col_2T_arb
      assign col_request =
        rts_col & {nBANK_MACHS{~(rnk_config_kill_rts_col_lcl || insert_maint_r)}};
// Give column command priority whenever previous state has no row request.
      wire [1:0] row_col_grant;
      wire [1:0] current_master = ~granted_row_ns ? 2'b10 : row_col_grant;
      wire upd_last_master = ~granted_row_ns || |row_col_grant;
      mig_7series_v4_2_round_robin_arb #
        (.WIDTH                       (2))
        row_col_arb0
          (.grant_ns                  (),
           .grant_r                   (row_col_grant),
           .upd_last_master           (upd_last_master),
           .current_master            (current_master),
           .clk                       (clk),
           .rst                       (rst),
           .req                       ({granted_row_ns, granted_col_ns}),
           .disable_grant             (1'b0));
      assign {block_grant_col, block_grant_row} = row_col_grant;
    end
    else begin : row_col_1T_arb
      assign col_request = rts_col & {nBANK_MACHS{~rnk_config_kill_rts_col_lcl}};
      assign block_grant_row = 1'b0;
      assign block_grant_col = 1'b0;
    end
  endgenerate

// Row address/command arbitration.
  wire[nBANK_MACHS-1:0] grant_row_r_lcl;
  output wire[nBANK_MACHS-1:0] grant_row_r;
  assign grant_row_r = grant_row_r_lcl;
  reg granted_row_r;
  always @(posedge clk) granted_row_r <= #TCQ granted_row_ns;
  wire sent_row_lcl = granted_row_r && ~block_grant_row;
  output wire sent_row;
  assign sent_row = sent_row_lcl;
  mig_7series_v4_2_round_robin_arb #
   (.WIDTH                              (nBANK_MACHS))
    row_arb0
    (.grant_ns                          (),
     .grant_r                           (grant_row_r_lcl[nBANK_MACHS-1:0]),
     .upd_last_master                   (sent_row_lcl),
     .current_master                    (grant_row_r_lcl[nBANK_MACHS-1:0]),
     .clk                               (clk),
     .rst                               (rst),
     .req                               (row_request),
     .disable_grant                     (1'b0));

  output wire [nBANK_MACHS-1:0] sending_row;
  assign sending_row = grant_row_r_lcl & {nBANK_MACHS{~block_grant_row}};

  // Precharge arbitration for 4:1 mode
  input [nBANK_MACHS-1:0] rts_pre;
  output wire[nBANK_MACHS-1:0] grant_pre_r;
  output wire [nBANK_MACHS-1:0] sending_pre;
  wire sent_pre_lcl;

  generate
  
    if((nCK_PER_CLK == 4) && (ADDR_CMD_MODE != "2T")) begin : pre_4_1_1T_arb
    
      reg granted_pre_r;
      wire[nBANK_MACHS-1:0] grant_pre_r_lcl;

      wire granted_pre_ns = |rts_pre;
      assign grant_pre_r = grant_pre_r_lcl;
      always @(posedge clk) granted_pre_r <= #TCQ granted_pre_ns;
      assign sent_pre_lcl = granted_pre_r;
      assign sending_pre = grant_pre_r_lcl;

      mig_7series_v4_2_round_robin_arb #
       (.WIDTH                              (nBANK_MACHS))
        pre_arb0
        (.grant_ns                          (),
         .grant_r                           (grant_pre_r_lcl[nBANK_MACHS-1:0]),
         .upd_last_master                   (sent_pre_lcl),
         .current_master                    (grant_pre_r_lcl[nBANK_MACHS-1:0]),
         .clk                               (clk),
         .rst                               (rst),
         .req                               (rts_pre),
         .disable_grant                     (1'b0));

    end

  endgenerate

`ifdef MC_SVA
  all_bank_machines_row_arb:
    cover property (@(posedge clk) (~rst && &rts_row));
`endif

// Rank config arbitration.
  input [nBANK_MACHS-1:0] rtc;
  wire [nBANK_MACHS-1:0] grant_config_r_lcl;
  output wire [nBANK_MACHS-1:0] grant_config_r;
  assign grant_config_r = grant_config_r_lcl;
  wire upd_rnk_config_last_master;
  mig_7series_v4_2_round_robin_arb #
   (.WIDTH                              (nBANK_MACHS))
    config_arb0
    (.grant_ns                          (),
     .grant_r                           (grant_config_r_lcl[nBANK_MACHS-1:0]),
     .upd_last_master                   (upd_rnk_config_last_master),
     .current_master                    (grant_config_r_lcl[nBANK_MACHS-1:0]),
     .clk                               (clk),
     .rst                               (rst),
     .req                               (rtc[nBANK_MACHS-1:0]),
     .disable_grant                     (1'b0));

`ifdef MC_SVA
  all_bank_machines_config_arb: cover property (@(posedge clk) (~rst && &rtc));
`endif

  wire rnk_config_strobe_ns = ~rnk_config_strobe_r[0] && |rtc && ~granted_col_ns;
  always @(posedge clk) rnk_config_strobe_r[0] <= #TCQ rnk_config_strobe_ns;
  
  genvar i;
  generate
    for(i = 1; i < RNK2RNK_DLY_CLKS; i = i + 1)
      always @(posedge clk)
        rnk_config_strobe_r[i] <= #TCQ rnk_config_strobe_r[i-1];
  endgenerate

  output wire rnk_config_strobe;
  assign rnk_config_strobe = rnk_config_strobe_r[0];
  
  assign upd_rnk_config_last_master = rnk_config_strobe_r[0];

// Generate rnk_config_valid.
  reg rnk_config_valid_r_lcl;
  wire rnk_config_valid_ns;
  assign rnk_config_valid_ns =
          ~rst && (rnk_config_valid_r_lcl || rnk_config_strobe_ns);
  always @(posedge clk) rnk_config_valid_r_lcl <= #TCQ rnk_config_valid_ns;
  output wire rnk_config_valid_r;
  assign rnk_config_valid_r = rnk_config_valid_r_lcl;

// Column address/command arbitration.
  wire [nBANK_MACHS-1:0] grant_col_r_lcl;
  output wire [nBANK_MACHS-1:0] grant_col_r;
  assign grant_col_r = grant_col_r_lcl;
  reg granted_col_r;
  always @(posedge clk) granted_col_r <= #TCQ granted_col_ns;
  wire sent_col_lcl;
  mig_7series_v4_2_round_robin_arb #
   (.WIDTH                              (nBANK_MACHS))
    col_arb0
    (.grant_ns                          (),
     .grant_r                           (grant_col_r_lcl[nBANK_MACHS-1:0]),
     .upd_last_master                   (sent_col_lcl),
     .current_master                    (grant_col_r_lcl[nBANK_MACHS-1:0]),
     .clk                               (clk),
     .rst                               (rst),
     .req                               (col_request),
     .disable_grant                     (1'b0));

`ifdef MC_SVA
  all_bank_machines_col_arb:
    cover property (@(posedge clk) (~rst && &rts_col));
`endif

  output wire [nBANK_MACHS-1:0] sending_col;
  assign sending_col = grant_col_r_lcl & {nBANK_MACHS{~block_grant_col}};
  assign sent_col_lcl = granted_col_r && ~block_grant_col;
  reg sent_col_lcl_r = 1'b0;
  always @(posedge clk) sent_col_lcl_r <= #TCQ sent_col_lcl;
  output wire sent_col;
  assign sent_col = sent_col_lcl;
  output wire sent_col_r;
  assign sent_col_r = sent_col_lcl_r;

  // If we need early wr_data_addr because ECC is on, arbitrate
  // to see which bank machine might sent the next wr_data_addr;
  input [nBANK_MACHS-1:0] col_rdy_wr;
  output wire [nBANK_MACHS-1:0] grant_col_wr;
  generate
    if (EARLY_WR_DATA_ADDR == "OFF") begin : early_wr_addr_arb_off
      assign grant_col_wr = {nBANK_MACHS{1'b0}};
    end
    else begin : early_wr_addr_arb_on
      wire [nBANK_MACHS-1:0] grant_col_wr_raw;
      mig_7series_v4_2_round_robin_arb #
        (.WIDTH                           (nBANK_MACHS))
        col_arb0
          (.grant_ns                      (grant_col_wr_raw),
           .grant_r                       (),
           .upd_last_master               (sent_col_lcl),
           .current_master                (grant_col_r_lcl[nBANK_MACHS-1:0]),
           .clk                           (clk),
           .rst                           (rst),
           .req                           (col_rdy_wr),
           .disable_grant                 (1'b0));
      reg [nBANK_MACHS-1:0] grant_col_wr_r;
      wire [nBANK_MACHS-1:0] grant_col_wr_ns = granted_col_ns
                                                 ? grant_col_wr_raw
                                                 : grant_col_wr_r;
      always @(posedge clk) grant_col_wr_r <= #TCQ grant_col_wr_ns;
      assign grant_col_wr = grant_col_wr_ns;
    end // block: early_wr_addr_arb_on
  endgenerate

  output reg send_cmd0_row = 1'b0;
  output reg send_cmd0_col = 1'b0;
  output reg send_cmd1_row = 1'b0;
  output reg send_cmd1_col = 1'b0;
  output reg send_cmd2_row = 1'b0;
  output reg send_cmd2_col = 1'b0;
  output reg send_cmd2_pre = 1'b0;
  output reg send_cmd3_col = 1'b0;

  output reg cs_en0 = 1'b0;
  output reg cs_en1 = 1'b0;
  output reg cs_en2 = 1'b0;
  output reg cs_en3 = 1'b0;
  
  output wire [5:0] col_channel_offset;

  reg insert_maint_r1_lcl;
  always @(posedge clk) insert_maint_r1_lcl <= #TCQ insert_maint_r;
  output wire insert_maint_r1;
  assign insert_maint_r1 = insert_maint_r1_lcl;

  wire sent_row_or_maint = sent_row_lcl || insert_maint_r1_lcl;
  reg sent_row_or_maint_r = 1'b0;
  always @(posedge clk) sent_row_or_maint_r <= #TCQ sent_row_or_maint;
  generate
    case ({(nCK_PER_CLK == 4), (nCK_PER_CLK == 2), (ADDR_CMD_MODE == "2T")})
      3'b000 : begin : one_one_not2T
      end
      3'b001 : begin : one_one_2T
      end
      3'b010 : begin : two_one_not2T

        if(!(CWL % 2)) begin  // Place column commands on slot 0 for even CWL

          always @(sent_col_lcl) begin
            cs_en0 = sent_col_lcl;
            send_cmd0_col = sent_col_lcl;
          end

          always @(sent_row_or_maint) begin
            cs_en1 = sent_row_or_maint;
            send_cmd1_row = sent_row_or_maint;
          end

          assign col_channel_offset = 0;

        end
        
        else begin            // Place column commands on slot 1 for odd CWL

          always @(sent_row_or_maint) begin 
            cs_en0 = sent_row_or_maint;
            send_cmd0_row = sent_row_or_maint;
          end
          
          always @(sent_col_lcl) begin 
            cs_en1 = sent_col_lcl;
            send_cmd1_col = sent_col_lcl;
          end
          
          assign col_channel_offset = 1;

        end

      end
      3'b011 : begin : two_one_2T

        if(!(CWL % 2)) begin  // Place column commands on slot 1->0 for even CWL
      
          always @(sent_row_or_maint_r or sent_col_lcl_r)
            cs_en0 = sent_row_or_maint_r || sent_col_lcl_r;

          always @(sent_row_or_maint or sent_row_or_maint_r) begin
            send_cmd0_row = sent_row_or_maint_r;
            send_cmd1_row = sent_row_or_maint;
          end
          
          always @(sent_col_lcl or sent_col_lcl_r) begin
            send_cmd0_col = sent_col_lcl_r;
            send_cmd1_col = sent_col_lcl;
          end

          assign col_channel_offset = 0;

        end
        
        else begin            // Place column commands on slot 0->1 for odd CWL
        
          always @(sent_col_lcl or sent_row_or_maint)
            cs_en1 = sent_row_or_maint || sent_col_lcl;

          always @(sent_row_or_maint) begin
            send_cmd0_row = sent_row_or_maint;
            send_cmd1_row = sent_row_or_maint;
          end
          
          always @(sent_col_lcl) begin
            send_cmd0_col = sent_col_lcl;
            send_cmd1_col = sent_col_lcl;
          end

          assign col_channel_offset = 1;
        
        end
        
      end
      3'b100 : begin : four_one_not2T

        if(!(CWL % 2)) begin  // Place column commands on slot 0 for even CWL

          always @(sent_col_lcl) begin
            cs_en0 = sent_col_lcl;
            send_cmd0_col = sent_col_lcl;
          end

          always @(sent_row_or_maint) begin
            cs_en1 = sent_row_or_maint;
            send_cmd1_row = sent_row_or_maint;
          end
          
          assign col_channel_offset = 0;
        
        end

        else begin            // Place column commands on slot 1 for odd CWL
          
          always @(sent_row_or_maint) begin
            cs_en0 = sent_row_or_maint;
            send_cmd0_row = sent_row_or_maint;
          end
          
          always @(sent_col_lcl) begin
            cs_en1 = sent_col_lcl;
            send_cmd1_col = sent_col_lcl;
          end
          
          assign col_channel_offset = 1;
          
        end

        always @(sent_pre_lcl) begin
          cs_en2 = sent_pre_lcl;
          send_cmd2_pre = sent_pre_lcl;
        end

      end
      3'b101 : begin : four_one_2T

        if(!(CWL % 2)) begin  // Place column commands on slot 3->0 for even CWL
      
          always @(sent_col_lcl or sent_col_lcl_r) begin
            cs_en0 = sent_col_lcl_r;
            send_cmd0_col = sent_col_lcl_r;
            send_cmd3_col = sent_col_lcl;
          end
          
          always @(sent_row_or_maint) begin
            cs_en2 = sent_row_or_maint;
            send_cmd1_row = sent_row_or_maint;
            send_cmd2_row = sent_row_or_maint;
          end

          assign col_channel_offset = 0;
        
        end
        
        else begin            // Place column commands on slot 2->3 for odd CWL
        
          always @(sent_row_or_maint) begin
            cs_en1 = sent_row_or_maint;
            send_cmd0_row = sent_row_or_maint;
            send_cmd1_row = sent_row_or_maint;
          end

          always @(sent_col_lcl) begin
            cs_en3 = sent_col_lcl;
            send_cmd2_col = sent_col_lcl;
            send_cmd3_col = sent_col_lcl;
          end

          assign col_channel_offset = 3;
        
        end

      end
    endcase
  endgenerate



endmodule

