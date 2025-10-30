// Append the auth tag after the ciphertext
#include "arrays.h"


// Input stream of plaintext
stream(axis128_t) wait_to_verify_axis_in; // input
uint1_t wait_to_verify_axis_in_ready; // output
// Input verify bit
uint1_t wait_to_verify_verify_bit; // input
// Output stream of plaintext
stream(axis128_t) wait_to_verify_axis_out; // output
uint1_t wait_to_verify_axis_out_ready; // input

typedef enum wait_to_verify{
  WAIT_FOR_VERIFY_BIT,    //Pass through input to ciphertext
  OUTPUT_PLAINTEXT //detect tlast, extract the tag and reset
}wait_to_verify_state_t;

#pragma MAIN wait_to_verify
void wait_to_verify()
{
  static wait_to_verify_state_t state = WAIT_FOR_VERIFY_BIT;
  
  static stream(axis128_t) plaintext_reg= {0};

  // Default not ready for incoming data
  wait_to_verify_axis_in_ready = 0;
  
  // Default not outputting data
  stream(axis128_t) axis128_null = {0};
  wait_to_verify_axis_out = axis128_null;
  
  // The output register is consumed if it's valid and the consumer is ready
  uint1_t output_consumed = ciphertext_reg.valid & wait_to_verify_axis_out_ready;

  if(state == WAIT_FOR_VERIFY_BIT)
  {
  }

  else //if(state == OUTPUT_PLAINTEXT)
  {
  }
}
