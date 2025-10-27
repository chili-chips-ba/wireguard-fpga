// Append the auth tag after the ciphertext
#include "arrays.h"



// Input stream of ciphertext followed by appended auth tag
stream(axis128_t) strip_auth_tag_axis_in; // input
uint1_t strip_auth_tag_axis_in_ready; // output
// Output stream of ciphertext
stream(axis128_t) strip_auth_tag_axis_out; // input
uint1_t strip_auth_tag_axis_out_ready; // output
// Output auth tag output
stream(poly1305_auth_tag_uint_t) strip_auth_tag_auth_tag_out; // input
uint1_t strip_auth_tag_auth_tag_out_ready; // output

typedef enum strip_auth_tag_state_t{
  CIPHERTEXT_PASS,    //Pass through input to ciphertext
  AUTH_TAG_EXTRACTION //detect tlast, extract the tag and reset
}strip_auth_tag_state_t;

#pragma MAIN strip_auth_tag
void strip_auth_tag()
{
  static strip_auth_tag_state_t state = CIPHERTEXT_PASS;

  // Default not ready for incoming data
  strip_auth_tag_axis_in_ready = 0;
  
  // Default not outputting data
  stream(axis128_t) axis128_null = {0};
  strip_auth_tag_axis_out = axis128_null;
  stream(poly1305_auth_tag_uint_t) auth_tag_null = {0};
  strip_auth_tag_auth_tag_out = auth_tag_null;
  
  if(state == CIPHERTEXT)
  {
    //Try to recieve input: Ready if output is ready
    strip_auth_tag_axis_in_ready = strip_auth_tag_axis_out_ready;

    //Pass data to ciphertext output
    strip_auth_tag_axis_out = strip_auth_tag_axis_in;

    //Check tlast for final block, which is the tag
    if (strip_auth_tag_axis_in.data.tlast & strip_auth_tag_axis_in.valid & strip_auth_tag_axis_in_ready){
       //move to tag block
       //don't output on the ciphertext stream
       strip_auth_tag_axis_out.valid = 0;
       state = AUTH_TAG_EXTRACTION;
    }
   }
  else //if(state == AUTH_TAG_EXTRACTION)
  {
    strip_auth_tag_axis_in_ready = 0;

    //extract the tag data from the input register and set it on the
    //dedicated auth tag output stream
    BYTE_ARRAY_TO_UINT(strip_auth_tag_axis_in.data.tdata, POLY1305_AUTH_TAG_SIZE, &strip_auth_tag_auth_tag_out.data)
    strip_auth_tag_auth_tag_out.valid = 1; //always valid in this state
    
    //set the ready signal for the auth tag output
    uint1_t tag_transfer_successful = strip_auth_tag_auth_tag_out.valid & strip_auth_tag_auth_tag_out_ready;

    if (tag_transfer_successful){
       state = CIPHERTEXT_PASS;
    }

  }
}
