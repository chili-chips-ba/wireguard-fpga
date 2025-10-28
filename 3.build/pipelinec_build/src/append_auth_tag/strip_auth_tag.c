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

  // Default not ready for incoming data
  strip_auth_tag_axis_in_ready = 0;
  
  // Default not outputting data
  stream(axis128_t) axis128_null = {0};
  strip_auth_tag_axis_out = axis128_null;
  stream(poly1305_auth_tag_uint_t) auth_tag_null = {0};
  strip_auth_tag_auth_tag_out = auth_tag_null;
  
  if(state == CIPHERTEXT)
  {
    // Pass input data to output (connect valid+ready)
    strip_auth_tag_axis_out = strip_auth_tag_axis_in;
    strip_auth_tag_axis_in_ready = strip_auth_tag_axis_out_ready;

    //Check tlast for final block, which is the tag
    //don't need to check strip_auth_tag_axis_out_ready
    //since we're not trying to output this last cycle
    if (strip_auth_tag_axis_in.data.tlast & strip_auth_tag_axis_in.valid){
       //move to tag block
       //don't pass input data to output 
       //(disconnect valid+ready)
       strip_auth_tag_axis_out.valid = 0;
       strip_auth_tag_axis_in_ready = 0;
       state = AUTH_TAG_EXTRACTION;
    }
   }
  else //if(state == AUTH_TAG_EXTRACTION)
  {
    //Connect AXIS input to auth tag output
    //(know AXIS is last cycle from peeking last cycle)
    strip_auth_tag_auth_tag_out.data = uint8_array16_le(strip_auth_tag_axis_in.data.tdata);
    strip_auth_tag_auth_tag_out.valid = strip_auth_tag_axis_in.valid;
    strip_auth_tag_axis_in_ready = strip_auth_tag_auth_tag_out_ready;

    //set the ready signal for the auth tag output
    if (strip_auth_tag_auth_tag_out.valid & strip_auth_tag_auth_tag_out_ready){
       state = CIPHERTEXT_PASS;
    }
  }
}
