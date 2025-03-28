//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
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
//   Minimal DAC BFM (Digital to Analog Converter Behavioral Model),
//   specifically designed to test and verify DAC output by comparing
//   the actual input values ('dac_data') against expected values
//   calculated through a specified formula. This BFM supports dynamic
//   adjustment of signal parameters and tolerance for flexible testing
//   of various DAC configurations and behaviors.
//
//   Use +define+DAC_BFM_DEBUG for debugging and detailed output comparison.
//==========================================================================

`timescale 1ns / 1ns

module bfm_dac #(
   parameter real BASE_TOLERANCE = 0.05, // Tolerance for comparison dac data
   parameter real SIN_TOLERANCE  = 0.3,  // Tolerance for comparison sin data
   parameter real HANN_TOLERANCE = 0.35, // Tolerance for comparison hann data
   parameter int  SCALE_FACTOR   = 1024,

   parameter int  SIN_AMPL       = 512,
   parameter int  SIN_LUT_SIZE   = 1024,
   parameter int  HANN_AMPL      = 1024,
   parameter int  HANN_LUT_SIZE  = 64    // Half of the actual size
)(
   input logic       dac_clk_out, // Clock signal for DAC data
   input logic [9:0] dac_data     // Actual DAC data input
);

   localparam real PI = 4*$atan(1);

//--------------------------------------------------------------------------------------------
// Defining parameters and variables for calculating the sin components of two DAC signals
//--------------------------------------------------------------------------------------------
   logic busy_dac1    = tb.dut.u_dac.u_ping_gen[1].busy;
   logic busy_dac2    = tb.dut.u_dac.u_ping_gen[2].busy;

   real sin_tune_dac1 = tb.dut.u_dac.u_ping_gen[1].sin_tune[14:0];
   real sin_tune_dac2 = tb.dut.u_dac.u_ping_gen[2].sin_tune[14:0];

   real sin_angle_step_dac1 = (2 * PI * sin_tune_dac1) / SCALE_FACTOR / SIN_LUT_SIZE;
   real sin_angle_step_dac2 = (2 * PI * sin_tune_dac2) / SCALE_FACTOR / SIN_LUT_SIZE;

   real sin_accumulator_dac1, sin_value_dac1;
   real sin_accumulator_dac2, sin_value_dac2;

   logic [9:0] sin_data_dac1 = tb.dut.u_dac.u_ping_gen[1].sin_data[9:0];
   logic [9:0] sin_data_dac2 = tb.dut.u_dac.u_ping_gen[2].sin_data[9:0];

//--------------------------------------------------------------------------------------------
// Defining parameters and variables for calculating the Hanning components of two DAC signals
//--------------------------------------------------------------------------------------------
   real hann_step_dac1 = tb.dut.u_dac.u_ping_gen[1].hann_step[9:0];
   real hann_step_dac2 = tb.dut.u_dac.u_ping_gen[2].hann_step[9:0];

   localparam real HANN_VALUE_STEP = PI / real'(HANN_LUT_SIZE);

   real hann_accumulator_dac1, hann_address_dac1, hann_index_dac1, hann_value_dac1;
   real hann_accumulator_dac2, hann_address_dac2, hann_index_dac2, hann_value_dac2;

   logic [9:0] hann_data_dac1 = tb.dut.u_dac.u_ping_gen[1].hann_data[9:0];
   logic [9:0] hann_data_dac2 = tb.dut.u_dac.u_ping_gen[2].hann_data[9:0];

   real expected_dac1_data;
   real expected_dac2_data;

   logic clk_54 = tb.dut.u_dac.clk_54;
   logic arst_n = tb.dut.u_dac.arst_n;

//-----------------------------------------------
// Calculating the expected value for DAC1
//-----------------------------------------------
   always_ff @(posedge clk_54 or negedge arst_n) begin
      if (arst_n == 1'b0) begin  //asynchronous reset
         sin_accumulator_dac1  = 0;
         sin_value_dac1        = 0;
         hann_accumulator_dac1 = 0;
         hann_address_dac1     = 0;
         hann_index_dac1       = 0;
         hann_value_dac1       = 0;
         expected_dac1_data    = 0;
      end
      else if (busy_dac1 == 1'b0) begin //reset after every ping
         sin_accumulator_dac1  = 0;
         sin_value_dac1        = 0;
         hann_accumulator_dac1 = 0;
         hann_address_dac1     = 0;
         hann_index_dac1       = 0;
         hann_value_dac1       = 0;
         expected_dac1_data    = 512;
      end
      else if (busy_dac1 == 1'b1 && dac_clk_out == 1'b1) begin
         sin_accumulator_dac1 += sin_angle_step_dac1;
         if (sin_accumulator_dac1 >= 2 * PI)
            sin_accumulator_dac1 -= 2 * PI;
         //Sin value DAC1
         sin_value_dac1 = $sin(sin_accumulator_dac1)*SIN_AMPL;

         hann_accumulator_dac1 += hann_step_dac1;
         if (hann_accumulator_dac1 >= SCALE_FACTOR) begin
            hann_address_dac1 = hann_address_dac1 + 1;
            if (hann_address_dac1 == 2*HANN_LUT_SIZE)
               hann_address_dac1 = 0;

            if (hann_address_dac1 >= HANN_LUT_SIZE)
               hann_index_dac1 = 2*HANN_LUT_SIZE - hann_address_dac1 - 1;
            else
               hann_index_dac1 = hann_address_dac1;

            hann_accumulator_dac1 -= SCALE_FACTOR;
         end
         //Hanning value DAC1
         hann_value_dac1 = (HANN_AMPL / 2.0) * (1.0 - $cos(hann_index_dac1*HANN_VALUE_STEP)) + 0.5;

         //Expected DAC1 value
         expected_dac1_data = (sin_value_dac1 * hann_value_dac1 / (SCALE_FACTOR - 1)) + 512;
      end
   end

   logic temp_state;

//-----------------------------------------------
// Calculating the expected value for DAC2
//-----------------------------------------------
   always_ff @(posedge clk_54 or negedge arst_n) begin
      if (arst_n == 1'b0) begin  //asynchronous reset
         sin_accumulator_dac2  = 0;
         sin_value_dac2        = 0;
         hann_accumulator_dac2 = 0;
         hann_address_dac2     = 0;
         hann_index_dac2       = 0;
         hann_value_dac2       = 0;
         expected_dac2_data    = 0;
      end
      else if (busy_dac2 == 1'b0) begin //reset after every ping
         sin_accumulator_dac2  = 0;
         sin_value_dac2        = 0;
         hann_accumulator_dac2 = 0;
         hann_address_dac2     = 0;
         hann_index_dac2       = 0;
         hann_value_dac2       = 0;
         expected_dac2_data    = 512;

         temp_state            = 1'b0;
      end
      else if (busy_dac2 == 1'b1 && temp_state == 1'b0) begin
         temp_state = 1'b1;
      end
      else if (temp_state == 1'b1 && dac_clk_out == 1'b0) begin
         sin_accumulator_dac2 += sin_angle_step_dac2;
         if (sin_accumulator_dac2 >= 2 * PI)
            sin_accumulator_dac2 -= 2 * PI;
         //Sin value DAC2
         sin_value_dac2 = $sin(sin_accumulator_dac2)*SIN_AMPL;

         hann_accumulator_dac2 += hann_step_dac2;
         if (hann_accumulator_dac2 >= SCALE_FACTOR) begin
            hann_address_dac2 = hann_address_dac2 + 1;
            if (hann_address_dac2 == 128)
               hann_address_dac2 = 0;

            if (hann_address_dac2 >= 64)
               hann_index_dac2 = 2*HANN_LUT_SIZE - hann_address_dac2 - 1;
            else
               hann_index_dac2 = hann_address_dac2;

            hann_accumulator_dac2 -= SCALE_FACTOR;
         end
         //Hanning value DAC2
         hann_value_dac2 = (HANN_AMPL / 2.0) * (1.0 - $cos(hann_index_dac2*HANN_VALUE_STEP)) + 0.5;

         //Expected DAC2 value
         expected_dac2_data = (sin_value_dac2 * hann_value_dac2 / (SCALE_FACTOR - 1)) + 512;
      end
   end

//----------------------------------------------------------------------------------------
// Checking the deviation of the expected and actual dac data, sin value and Hanning value
//----------------------------------------------------------------------------------------
   always @(dac_clk_out) begin
      if (dac_clk_out == 1'b1) begin // posedge: CH1
         check_data_with_tolerance(1, dac_data,       expected_dac1_data, BASE_TOLERANCE, 1'b0);
         check_data_with_tolerance(1, sin_data_dac2,  sin_value_dac2,     SIN_TOLERANCE,  1'b1);
         check_data_with_tolerance(1, hann_data_dac2, hann_value_dac2,    HANN_TOLERANCE, 1'b0);
      end

      if (dac_clk_out == 1'b0) begin // negedge: CH2
         check_data_with_tolerance(2, dac_data,       expected_dac2_data, BASE_TOLERANCE, 1'b0);
         check_data_with_tolerance(2, sin_data_dac1,  sin_value_dac1,     SIN_TOLERANCE,  1'b1);
         check_data_with_tolerance(2, hann_data_dac1, hann_value_dac1,    HANN_TOLERANCE, 1'b0);
      end
   end

   real data_difference;
   real dinamic_tolerance;
   real expected_data_pos;
   real actual_data_t;


//---------
   task check_data_with_tolerance(
      input int         ch_id,
      input logic [9:0] actual_data,
      input real        expected_data,
      input real        tolerance,
      input logic       sine
   );

      if({sine, actual_data[9]} == 2'b11)
         actual_data_t = -real'(~actual_data[8:0]);
      else
         actual_data_t = actual_data;

      expected_data_pos = expected_data;
      if (expected_data_pos < 0)
         expected_data_pos = -expected_data_pos;

      dinamic_tolerance = tolerance + (1.0 / (expected_data_pos + 1.0));
      data_difference = real'(actual_data_t) - expected_data;

      if (data_difference < 0)
         data_difference = -data_difference;

      if (data_difference > expected_data_pos*dinamic_tolerance) begin
         `ifdef DAC_BFM_DEBUG
            $display("[%0t] DAC_%0d Data Mismatch: Expected %0f, Received %0f",
                        $time, ch_id, expected_data, actual_data_t);
         `endif
      end else begin
         /*`ifdef DAC_BFM_DEBUG
            $display("[%0t] DAC Data Match within tolerance: %0f", $time, dinamic_tolerance);
         `endif*/
      end
   endtask

endmodule: bfm_dac

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/4/4 AZ: original creation
*/
