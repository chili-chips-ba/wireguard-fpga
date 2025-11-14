//Chech if auth_tag and calculated_tag are the same

#include "arrays.h"
#include "poly1305.h"

DECL_STREAM_TYPE(uint1_t)

// Input auth_tag
stream(poly1305_auth_tag_uint_t) poly1305_verify_auth_tag; //input
uint1_t poly1305_verify_auth_tag_ready; //output

// Input calc_tag
stream(poly1305_auth_tag_uint_t) poly1305_verify_calc_tag; //input
uint1_t poly1305_verify_calc_tag_ready; //output

// Output stream is_verified/tags_match bit
stream(uint1_t) poly1305_verify_tags_match; //output
uint1_t poly1305_verify_tags_match_ready; //input

typedef enum poly1305_verify_state_t{
  TAKE_AUTH_TAG, //take auth_tag and place it into a register
  TAKE_CALC_TAG, //take calculated tag and plae it into a reg
  COMPARE_TAGS,  //take the two tags and compare them if equal ("==") and place res in reg
  OUTPUT_COMPARE_RESULT //output the compare value 
}poly1305_verify_state_t; 

#pragma MAIN poly1305_verify
void poly1305_verify(){

  // Define static variables
  static poly1305_verify_state_t state = TAKE_AUTH_TAG;
  
  // Regs to hold the tag value
  static poly1305_auth_tag_uint_t auth_tag_reg;
  static poly1305_auth_tag_uint_t calc_tag_reg;

  // Reg to hold compare result
  static uint1_t tags_match_reg;

  poly1305_verify_auth_tag_ready = 0; 
  poly1305_verify_calc_tag_ready = 0; 
  poly1305_verify_tags_match.valid = 0; 
  poly1305_verify_tags_match.data = 0; 
  
  if (state == TAKE_AUTH_TAG)
  {
    // Ready to take the input tag
    poly1305_verify_auth_tag_ready = 1;

    if (poly1305_verify_auth_tag.valid & poly1305_verify_auth_tag_ready)
    {
      // Copy data to the register
      auth_tag_reg = poly1305_verify_auth_tag.data;
      state = TAKE_CALC_TAG;
    }
  }
  else if (state == TAKE_CALC_TAG)
  {
    // Ready to take the calculated tag
    poly1305_verify_calc_tag_ready = 1;

    if (poly1305_verify_calc_tag.valid & poly1305_verify_calc_tag_ready)
    {
      calc_tag_reg = poly1305_verify_calc_tag.data;
      state = COMPARE_TAGS;
    }
  }
  else if (state == COMPARE_TAGS)
  {
    // Perform comparison logic
    tags_match_reg = (auth_tag_reg == calc_tag_reg);

    // Output the result
    state = OUTPUT_COMPARE_RESULT;
  }
  else //(state == OUTPUT_COMPARE_RESULT)
  {
    // Output result stored in register via local stream 
    poly1305_verify_tags_match.data = tags_match_reg;
    poly1305_verify_tags_match.valid = 1;

    if (poly1305_verify_tags_match_ready & poly1305_verify_tags_match.valid)
    {
      // Successful output transfer
      // Reset the FSM for the next verification
      state = TAKE_AUTH_TAG;
    }
  }
}



