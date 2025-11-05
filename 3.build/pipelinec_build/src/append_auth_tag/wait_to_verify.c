// Append the auth tag after the ciphertext
#include "arrays.h"
#include "global_fifo.h"

// Input stream of plaintext
stream(axis128_t) wait_to_verify_axis_in; // input
uint1_t wait_to_verify_axis_in_ready; // output
// Input verify bit
stream(uint1_t) wait_to_verify_verify_bit; // input
uint1_t wait_to_verify_verify_bit_ready; // output
// Output stream of plaintext
stream(axis128_t) wait_to_verify_axis_out; // output
uint1_t wait_to_verify_axis_out_ready; // input
// Output for the verification result
uint1_t wait_to_verify_is_verified_out; // output

typedef enum wait_to_verify_state_t{
  WAIT_FOR_VERIFY_BIT,  //Place the input plaintext into fifo until verify bit arrives
  OUTPUT_PLAINTEXT //once verify bit arrives output plaintext and verify bit
}wait_to_verify_state_t;

// GLOBAL_STREAM_FIFO(data_t, name, DEPTH)
GLOBAL_STREAM_FIFO(axis128_t, verify_fifo, 128)

#pragma MAIN wait_to_verify
void wait_to_verify()
{
  static wait_to_verify_state_t state = WAIT_TO_VERIFY_BIT;
  // Reg to hold teh recieved verification result (tags_match)
  static uint1_t tags_match_reg = 0;

  // Write side of FIFO
  // the data+valid for input stream
  // (aka fifo write data, write enable)
  verify_fifo_in = wait_to_verify_axis_in;
  // the ready signal for the input stream
  // (aka fifo not full signal)
  wait_to_verify_axis_in_ready = verify_fifo_in_ready;

  // Read side of FIFO
  // the data+valid for output stream
  // (aka fifo read data, not eampty signal)
  wait_to_verify_axis_out = verify_fifo_out;
  
  // Default not ready for the single verify bit input
  wait_to_verify_bit_ready = 0;
  // Default FIFO Read Enable is set by FSM
  verify_fifo_out_ready = 0;
  // Default output valid/tlast for stream is 0
  wait_to_verify_axis_out.valid = 0;
  // Default is_verified output
  wait_to_verify_is_verified_out = 0;

  if(state == WAIT_FOR_VERIFY_BIT)
  {
    // FIFO Read Enable: Disconnected, data stays buffered
    verify_fifo_out_ready = 0;

    // Output stream: invalid
    wait_to_verify_axis_out.valid = 0;

    // Wait for verify bit
    // Be ready to accept the single bit
    wait_to_verify_verify_bit_ready = 1;

    if(wait_to_verify_verify_bit.valid)
    {
      // Capture the result and signal reception
      tags_match_reg = wait_to_verify_bit.data;

      // Move to output state
      state = OUTPUT_PLAINTEXT;
    }
  }

  else //if(state == OUTPUT_PLAINTEXT)
  {
    // Plaintext output
    verify_fifo_out_ready = wait_to_verify_axis_out_ready;
    // Valid only if FIFO is not empty
    wait_to_verify_axis_out.valid = verify_fifo_out.valid;

    // Verified bit output
    // Synchronize with stream valid
    wait_to_verify_is_verified_out = tags_match_reg;

    // Check for successful consumption of the last packet
    if(wait_to_verify_axis_out.valid && wait_to_verify_axis_out_ready)
    {
      // If output is consumed, check for tlast
      if (wait_to_verify_axis_out.data.tlast)
      {
        // End of buffered plaintext, reset the FSM
        state = WAIT_FOR_VERIFY_BIT;
      }  
    }

    // Input ready's are disconnected in this state
    wait_to_verify_verify_bit_ready = 0;
  }
}
