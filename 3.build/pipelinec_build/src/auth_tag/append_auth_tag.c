// Append the auth tag after the ciphertext
#include "arrays.h"
//#include "append_auth_tag.h"

// Input stream of ciphertext
stream(axis128_t) append_auth_tag_axis_in; // input
uint1_t append_auth_tag_axis_in_ready; // output
// Input of auth tag output from poly1305_mac
stream(poly1305_auth_tag_uint_t) append_auth_tag_auth_tag_in; // input
uint1_t append_auth_tag_auth_tag_in_ready; // output
// Output stream of ciphertext followed by appended auth tag
stream(axis128_t) append_auth_tag_axis_out; // output
uint1_t append_auth_tag_axis_out_ready; // input

typedef enum append_auth_tag_state_t{
  CIPHERTEXT,
  AUTH_TAG
}append_auth_tag_state_t;

#pragma MAIN append_auth_tag
void append_auth_tag()
{
  static append_auth_tag_state_t state;

  // Default not ready for incoming data
  append_auth_tag_axis_in_ready = 0;
  append_auth_tag_auth_tag_in_ready = 0;
  // Default not outputting data
  stream(axis128_t) axis128_null = {0};
  append_auth_tag_axis_out = axis128_null;
  
  if(state == CIPHERTEXT)
  {
    // Pass through ciphertext
    append_auth_tag_axis_out = append_auth_tag_axis_in;
    append_auth_tag_axis_in_ready = append_auth_tag_axis_out_ready;
    // Except for tlast since adding extra actual last auth tag cycle next
    append_auth_tag_axis_out.data.tlast = 0;
    if(append_auth_tag_axis_in.data.tlast & 
       append_auth_tag_axis_in.valid & append_auth_tag_axis_in_ready
    ){
      state = AUTH_TAG;
    }
  }
  else //if(state == AUTH_TAG)
  {
    // Insert auth tag as new last cycle
    UINT_TO_BYTE_ARRAY(append_auth_tag_axis_out.data.tdata, POLY1305_AUTH_TAG_SIZE, append_auth_tag_auth_tag_in.data)
    ARRAY_SET(append_auth_tag_axis_out.data.tkeep, 1, POLY1305_AUTH_TAG_SIZE)
    append_auth_tag_axis_out.data.tlast = 1;
    append_auth_tag_axis_out.valid = append_auth_tag_auth_tag_in.valid;
    append_auth_tag_auth_tag_in_ready = append_auth_tag_axis_out_ready;
    if(append_auth_tag_axis_out.valid & append_auth_tag_axis_out_ready){
      state = CIPHERTEXT;
    }
  }
}