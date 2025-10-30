// Append the auth tag after the ciphertext
#include "arrays.h"


// Input stream of ciphertext followed by appended auth tag
stream(axis128_t) strip_auth_tag_axis_in; // input
uint1_t strip_auth_tag_axis_in_ready; // output
// Output stream of ciphertext
stream(axis128_t) strip_auth_tag_axis_out; // output
uint1_t strip_auth_tag_axis_out_ready; // input
// Output auth tag output
stream(poly1305_auth_tag_uint_t) strip_auth_tag_auth_tag_out; // output
uint1_t strip_auth_tag_auth_tag_out_ready; // input

typedef enum strip_auth_tag_state_t{
  CIPHERTEXT_PASS,    //Pass through input to ciphertext
  AUTH_TAG_EXTRACTION //detect tlast, extract the tag and reset
}strip_auth_tag_state_t;

#pragma MAIN strip_auth_tag
void strip_auth_tag()
{
  static strip_auth_tag_state_t state = CIPHERTEXT_PASS;
  
  static stream(axis128_t) ciphertext_reg = {0};
  static axis128_t tag_capture_reg = {0};

  // Default not ready for incoming data
  strip_auth_tag_axis_in_ready = 0;
  
  // Default not outputting data
  stream(axis128_t) axis128_null = {0};
  strip_auth_tag_axis_out = axis128_null;
  stream(poly1305_auth_tag_uint_t) auth_tag_null = {0};
  strip_auth_tag_auth_tag_out = auth_tag_null;
  
  // The output register is consumed if it's valid and the consumer is ready
  uint1_t output_consumed = ciphertext_reg.valid & strip_auth_tag_axis_out_ready;

  if(state == CIPHERTEXT_PASS)
  {
    //the FSM is ready for new input if the currennt output register is consumed
    strip_auth_tag_axis_in_ready = output_consumed;

    //load the register and check for lookahead on a successful input transfer
    if(strip_auth_tag_axis_in.valid & strip_auth_tag_axis_in_ready)
    {
      if(strip_auth_tag_axis_in.data.tlast)
      {
        //Next block is the tag
	//this block is the one outputting in the next cycle
	cyphertext_reg.data.tlast = 1;

	// Capture the tag data
	tag_capture_reg = strip_auth_tag_axis_in.data;

	// Stop feeding the ciphertext pipeline
	// We clear the valid bit of the register to ensure the 
	// tag block is not output as ciphertext
	ciphertext_reg.valid = 0;

	// Transition to AUTH_TAG_EXTRACTION
	state = AUTH_TAG_EXTRACTION;
      }
    }

    else
    {
      //Cipertext block
      //Load the new block into the register
      ciphertext_reg = strip_auth_tag_axis_in;
      ciphertext_reg.data.tlast = 0;
      ciphertext_reg.valid = 1;
    }
  }

  else //if(state == AUTH_TAG_EXTRACTION)
  {
    if (output_consumed){
      // Disable the ciphertext output
      ciphertext_reg.valid = 0;

      // Output the auth tag
      strip_auth_tag_auth_tag_out.data = uint8_array16_le(tag_capture_reg.tdata)
      strip_auth_tag_auth_tag_out.valid = 1;

      if (strip_auth_tag_auth_tag_out_ready)
      {
	// Tag was successfully sent
	tag_capture_reg.tlast = 0;
	state = CIPHERTEXT;
      }
    }
  }
  }
}
