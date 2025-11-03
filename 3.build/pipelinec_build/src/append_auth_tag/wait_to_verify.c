// Append the auth tag after the ciphertext
#include "arrays.h"
#include "fifo.h"

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

// First word through as a stream() fifo
// FIFO_FWFT(name, type_t, DEPTH)
FIFO_FWFT(verify_fifo, axis128_t, 128);

#pragma MAIN wait_to_verify
void wait_to_verify()
{
  
  static wait_to_verify_state_t state = WAIT_FOR_VERIFY_BIT;
  // Reg to hold the recieved verification result (tags_match)
  static uint1_t tags_match_reg = 0;
  // Reg to track if the verify bit has been successfully recieved
  static uint1_t verify_bit_recieved = 0;

  // Control signals
  // The FIFO read 

  // Declaring the FIFO
  verify_fifo_t fifo_out = verify_fifo(
  

  // Conncet inputs to the FIFO
  // the ready for the output stream
  // (aka file read enable)
  wait_to_verify_axis_out_ready,

  // the data+valid for input stream
  // (aka fifo write data, write enable)
  wait_to_verify_axis_in.data, 
  wait_to_verify_axis_in.valid
);
  // Connect outputs from FIFO
  // the data+valid for output stream
  // (aka fifo read data, not empty signal)
  wait_to_verify_axis_out.data = fifo_out.data_out;
  wait_to_verify_axis_out.valid = fifo_out.data_out_valid;

  // the ready signal for the input stream
  // (aka the fifo not full signal)
  wait_to_verify_axis_in_ready = fifo_out.data_in_ready;

  

  // Default not ready for incoming data
  wait_to_verify_axis_in_ready = 0;
  wait_to_verify_verify_bit_ready = 0;
  
  // Default not outputting data
  stream(axis128_t) axis128_null = {0};
  wait_to_verify_axis_out = axis128_null;
  wait_to_verify_is_verified_out = 0;
  
  // Plaintext data always comes from the FIFO
  wait_to_verify_axis_out.date = fifo_out.data_out;

  if(state == WAIT_FOR_VERIFY_BIT)
  {
    // Plaintext buffering
    // Input is ready only if the FIFO is not full and
    // we haven't recieved teh bit yet
    if(!verify_bit_recieved)
    {
      // Ready signal for the plaintext input comes from FIFO
      wait_to_verify_axis_in_ready = fifo_out.data_in_ready;
    }
    else
    {
      // Stop recieving plaintext input after the verify arrives
      wait_to_verify_axis_in_ready = 0;
    }

    // Wait for verify bit
    // Be ready to accept the single bit
    wait_to_verify_verify_bit_ready = 1;

    if(wait_to_verify_verify_bit.valid)
    {
      // Capture the result and signal reception
      tags_match_reg = wait_to_verify_bit.data;
      verify_bit_recieved = 1;

      // Move to output state
      state = OUTPUT_PLAINTEXT;
    }

    // Output valid is always 0 in this state
    wait_to_verify_axis_out.valid = 0;
  }

  else //if(state == OUTPUT_PLAINTEXT)
  {
    // Plaintext output
    // Valid only if FIFO is not empty
    wait_to_verify_axis_out.valid = fifo_out.data_out_valid;

    // Verified bit output
    // Valid only when plaintext output is valid
    wait_to_verify_is_veriied_out = tags_match_reg;

    if(wait_to_verify_axis_out.valid & output_ready_combined)
    {
      // If output is consumed, check for tlast
      if (wait_to_verify_axis_out.data.tlast)
      {
        // End of buffered plaintext, reset the FSM
	state = WAIT_FOR_VERIFY_BIT;
	verify_bit_recieved = 0;
      }  
    }

    // Input ready's are disconnected in this state
    wait_to_verify_axis_in_ready = 0;
    wait_to_verify_verify_bit_ready = 0;
  }
}
