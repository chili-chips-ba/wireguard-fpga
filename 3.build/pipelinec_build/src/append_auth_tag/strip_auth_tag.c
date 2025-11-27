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


typedef struct axis128_early_tlast_t{
    // Outputs
    stream(axis128_t) axis_out;
    uint1_t next_axis_out_is_tlast;
    uint1_t ready_for_axis_in;
}axis128_early_tlast_t;
axis128_early_tlast_t axis128_early_tlast(
    // Inputs
    stream(axis128_t) axis_in, 
    uint1_t ready_for_axis_out
){
    axis128_early_tlast_t o; // outputs

    // Output comes via the buffer reg
    static stream(axis128_t) buffer_reg;

    // Stop data from flowing buffer -> out 
    // until we can determine if last is next
    uint1_t buffer_is_tlast =
      buffer_reg.valid & buffer_reg.data.tlast;
    uint1_t buff_to_out_connected = 
      // Connect if the buffer itself is tlast 
      // (kinda corner case for single word packet)
      buffer_is_tlast |
      // Or if next word is incoming now
      // (so we can know if it is last)
      axis_in.valid;
    if(buff_to_out_connected){
      o.axis_out = buffer_reg;
      o.next_axis_out_is_tlast = axis_in.valid & axis_in.data.tlast;
    }

    // Outgoing transfer clears buffer valid
    if(o.axis_out.valid & ready_for_axis_out){
       buffer_reg.valid = 0;
    }

    // Ready for input data if room in buffer
    o.ready_for_axis_in = ~buffer_reg.valid;
    // Incoming transfer puts data into buffer
    if(axis_in.valid & o.ready_for_axis_in){
       buffer_reg = axis_in;
    }

    return o;
}



#pragma MAIN strip_auth_tag
void strip_auth_tag()
{
  // 
  uint1_t ready_for_axis_in;
  #pragma FEEDBACK ready_for_axis_in

  axis128_early_tlast_t early_tlast = axis128_early_tlast(strip_auth_tag_axis_in, ready_for_axis_in);

  // Ready for axis into early module
  strip_auth_tag_axis_in_ready = early_tlast.ready_for_axis_in;
  // stream coming out of early module
  stream(axis128_t) axis_in = early_tlast.axis_out;
  
  
  // Default passing input axis data to ciphertext output
  strip_auth_tag_axis_out = axis_in;
  ready_for_axis_in = strip_auth_tag_axis_out_ready;

  // With override to use for the early tlast for ciphertext tlast
  strip_auth_tag_axis_out.data.tlast = early_tlast.next_axis_out_is_tlast;
  // and not passing data to auth tag out
  stream(poly1305_auth_tag_uint_t) auth_tag_null = {0};
  strip_auth_tag_auth_tag_out = auth_tag_null;

  // If this is last input cycle then it's auth tag
  if (axis_in.data.tlast)
  {
     // not passing ciphertext output
     strip_auth_tag_axis_out.valid = 0;
     // Connect to auth tag output
     strip_auth_tag_auth_tag_out.data = poly1305_auth_tag_uint_from_bytes(axis_in.data.tdata);
     strip_auth_tag_auth_tag_out.valid = axis_in.valid;
     ready_for_axis_in = strip_auth_tag_auth_tag_out_ready;
  }  
}

  