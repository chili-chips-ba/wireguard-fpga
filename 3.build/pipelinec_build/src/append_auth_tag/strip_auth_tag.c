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
  CIPHERTEXT,
  AUTH_TAG
}strip_auth_tag_state_t;

#pragma MAIN strip_auth_tag
void strip_auth_tag()
{
  static strip_auth_tag_state_t state;

  // Default not ready for incoming data
  strip_auth_tag_axis_in_ready = 0;
  strip_auth_tag_auth_tag_in_ready = 0;
  // Default not outputting data
  stream(axis128_t) axis128_null = {0};
  strip_auth_tag_axis_out = axis128_null;
  
  if(state == CIPHERTEXT)
  {
    // Pass through ciphertext
    strip_auth_tag_axis_out = strip_auth_tag_axis_in;
    strip_auth_tag_axis_in_ready = strip_auth_tag_axis_out_ready;
    // Except for tlast since adding extra actual last auth tag cycle next
    strip_auth_tag_axis_out.data.tlast = 0;
    if(strip_auth_tag_axis_in.data.tlast & 
       strip_auth_tag_axis_in.valid & strip_auth_tag_axis_in_ready
    ){
      state = AUTH_TAG;
    }
  }
  else //if(state == AUTH_TAG)
  {
    // Insert auth tag as new last cycle
    UINT_TO_BYTE_ARRAY(strip_auth_tag_axis_out.data.tdata, POLY1305_AUTH_TAG_SIZE, strip_auth_tag_auth_tag_in.data)
    ARRAY_SET(strip_auth_tag_axis_out.data.tkeep, 1, POLY1305_AUTH_TAG_SIZE)
    strip_auth_tag_axis_out.data.tlast = 1;
    strip_auth_tag_axis_out.valid = strip_auth_tag_auth_tag_in.valid;
    strip_auth_tag_auth_tag_in_ready = strip_auth_tag_axis_out_ready;
    if(strip_auth_tag_axis_out.valid & strip_auth_tag_axis_out_ready){
      state = CIPHERTEXT;
    }
  }
}
