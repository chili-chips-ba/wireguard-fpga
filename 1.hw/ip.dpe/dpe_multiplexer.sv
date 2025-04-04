//==========================================================================
// Copyright (C) 2024-2025 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description:
//   DPE multiplexer
//==========================================================================

module dpe_multiplexer (
   input  logic  pause,
   output logic  is_idle,

   dpe_if.s_axis from_cpu,
   dpe_if.s_axis from_eth_1,
   dpe_if.s_axis from_eth_2,
   dpe_if.s_axis from_eth_3,
   dpe_if.s_axis from_eth_4,
   dpe_if.m_axis to_dpe
);
   import dpe_pkg::*;

   typedef enum logic [3:0] {
      IDLE,
      R0, S0,
      R1, S1,
      R2, S2,
      R3, S3,
      R4, S4
   } state_t;

   state_t state, next_state;

   dpe_if to_dpe_sbuff(.clk(from_cpu.clk), .rst(from_cpu.rst));

// FSM registers
   always_ff @(posedge from_cpu.clk) begin
      if (from_cpu.rst) begin
         state <= IDLE;
      end else begin
         state <= next_state;
      end
   end

// FSM transition logic
   always_comb begin
      next_state = state;

      unique case (state)
         IDLE: begin
            if (!pause) next_state = R0;
         end

         R0: begin
            if (from_cpu.tvalid && to_dpe_sbuff.tready)       next_state = S0;
            else if (pause)                                   next_state = IDLE;
            else if (!from_cpu.tvalid && to_dpe_sbuff.tready) next_state = R1;
         end

         S0: begin
            if (from_cpu.tlast && from_cpu.tvalid && to_dpe_sbuff.tready) begin
               next_state = pause ? IDLE : R1;
            end
         end

         R1: begin
            if (from_eth_1.tvalid && to_dpe_sbuff.tready)       next_state = S1;
            else if (pause)                                     next_state = IDLE;
            else if (!from_eth_1.tvalid && to_dpe_sbuff.tready) next_state = R2;
         end

         S1: begin
            if (from_eth_1.tlast && from_eth_1.tvalid && to_dpe_sbuff.tready) begin
               next_state = pause ? IDLE : R2;
            end
         end

         R2: begin
            if (from_eth_2.tvalid && to_dpe_sbuff.tready)       next_state = S2;
            else if (pause)                                     next_state = IDLE;
            else if (!from_eth_2.tvalid && to_dpe_sbuff.tready) next_state = R3;
         end

         S2: begin
            if (from_eth_2.tlast && from_eth_2.tvalid && to_dpe_sbuff.tready) begin
               next_state = pause ? IDLE : R3;
            end
         end

         R3: begin
            if (from_eth_3.tvalid && to_dpe_sbuff.tready)       next_state = S3;
            else if (pause)                                     next_state = IDLE;
            else if (!from_eth_3.tvalid && to_dpe_sbuff.tready) next_state = R4;
         end

         S3: begin
            if (from_eth_3.tlast && from_eth_3.tvalid && to_dpe_sbuff.tready) begin
               next_state = pause ? IDLE : R4;
            end
         end

         R4: begin
            if (from_eth_4.tvalid && to_dpe_sbuff.tready)       next_state = S4;
            else if (pause)                                     next_state = IDLE;
            else if (!from_eth_4.tvalid && to_dpe_sbuff.tready) next_state = R0;
         end

         S4: begin
            if (from_eth_4.tlast && from_eth_4.tvalid && to_dpe_sbuff.tready) begin
               next_state = pause ? IDLE : R0;
            end
         end

         default:
            next_state = state;
      endcase
   end

// Outputs logic
   always_comb begin
      // Default assignments
      is_idle = 1'b0;
      to_dpe_sbuff.tvalid = 1'b0;
      to_dpe_sbuff.tdata = '0;
      to_dpe_sbuff.tlast = 1'b0;
      to_dpe_sbuff.tkeep = '0;
      to_dpe_sbuff.tuser_bypass_all = 1'b0;
      to_dpe_sbuff.tuser_bypass_stage = 1'b0;
      to_dpe_sbuff.tuser_src = '0;
      to_dpe_sbuff.tuser_dst = '0;
      from_cpu.tready = 1'b0;
      from_eth_1.tready = 1'b0;
      from_eth_2.tready = 1'b0;
      from_eth_3.tready = 1'b0;
      from_eth_4.tready = 1'b0;

      unique case (state)
         IDLE: begin
            is_idle = !to_dpe.tvalid;
         end

         R0, S0: begin
            is_idle = 1'b0;
            to_dpe_sbuff.tvalid = from_cpu.tvalid;
            to_dpe_sbuff.tdata = from_cpu.tdata;
            to_dpe_sbuff.tlast = from_cpu.tlast;
            to_dpe_sbuff.tkeep = from_cpu.tkeep;
            to_dpe_sbuff.tuser_bypass_all = from_cpu.tuser_bypass_all;
            to_dpe_sbuff.tuser_bypass_stage = from_cpu.tuser_bypass_stage;
            to_dpe_sbuff.tuser_src = DPE_ADDR_CPU;
            to_dpe_sbuff.tuser_dst = from_cpu.tuser_dst;
            from_cpu.tready = to_dpe_sbuff.tready;
         end

         R1, S1: begin
            is_idle = 1'b0;
            to_dpe_sbuff.tvalid = from_eth_1.tvalid;
            to_dpe_sbuff.tdata = from_eth_1.tdata;
            to_dpe_sbuff.tlast = from_eth_1.tlast;
            to_dpe_sbuff.tkeep = from_eth_1.tkeep;
            to_dpe_sbuff.tuser_bypass_all = from_eth_1.tuser_bypass_all;
            to_dpe_sbuff.tuser_bypass_stage = from_eth_1.tuser_bypass_stage;
            to_dpe_sbuff.tuser_src = DPE_ADDR_ETH_1;
            to_dpe_sbuff.tuser_dst = from_eth_1.tuser_dst;
            from_eth_1.tready = to_dpe_sbuff.tready;
         end

         R2, S2: begin
            is_idle = 1'b0;
            to_dpe_sbuff.tvalid = from_eth_2.tvalid;
            to_dpe_sbuff.tdata = from_eth_2.tdata;
            to_dpe_sbuff.tlast = from_eth_2.tlast;
            to_dpe_sbuff.tkeep = from_eth_2.tkeep;
            to_dpe_sbuff.tuser_bypass_all = from_eth_2.tuser_bypass_all;
            to_dpe_sbuff.tuser_bypass_stage = from_eth_2.tuser_bypass_stage;
            to_dpe_sbuff.tuser_src = DPE_ADDR_ETH_2;
            to_dpe_sbuff.tuser_dst = from_eth_2.tuser_dst;
            from_eth_2.tready = to_dpe_sbuff.tready;
         end

         R3, S3: begin
            is_idle = 1'b0;
            to_dpe_sbuff.tvalid = from_eth_3.tvalid;
            to_dpe_sbuff.tdata = from_eth_3.tdata;
            to_dpe_sbuff.tlast = from_eth_3.tlast;
            to_dpe_sbuff.tkeep = from_eth_3.tkeep;
            to_dpe_sbuff.tuser_bypass_all = from_eth_3.tuser_bypass_all;
            to_dpe_sbuff.tuser_bypass_stage = from_eth_3.tuser_bypass_stage;
            to_dpe_sbuff.tuser_src = DPE_ADDR_ETH_3;
            to_dpe_sbuff.tuser_dst = from_eth_3.tuser_dst;
            from_eth_3.tready = to_dpe_sbuff.tready;
         end

         R4, S4: begin
            is_idle = 1'b0;
            to_dpe_sbuff.tvalid = from_eth_4.tvalid;
            to_dpe_sbuff.tdata = from_eth_4.tdata;
            to_dpe_sbuff.tlast = from_eth_4.tlast;
            to_dpe_sbuff.tkeep = from_eth_4.tkeep;
            to_dpe_sbuff.tuser_bypass_all = from_eth_4.tuser_bypass_all;
            to_dpe_sbuff.tuser_bypass_stage = from_eth_4.tuser_bypass_stage;
            to_dpe_sbuff.tuser_src = DPE_ADDR_ETH_4;
            to_dpe_sbuff.tuser_dst = from_eth_4.tuser_dst;
            from_eth_4.tready = to_dpe_sbuff.tready;
         end

         default:
            is_idle = !to_dpe.tvalid;
      endcase
   end

// Skid buffers
   dpe_if_skid_buffer skid_buffer_to_dpe (
      .inp(to_dpe_sbuff),
      .outp(to_dpe)
   );
endmodule
