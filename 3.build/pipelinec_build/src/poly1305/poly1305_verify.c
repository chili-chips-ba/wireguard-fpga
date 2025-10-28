//Chech if auth_tag and calculated_tag are the same

#include "arrays.h"

// Input auth_tag
stream(axis128_t) poly1305_verify_auth_tag; //input
uint1_t poly1305_verify_auth_tag_ready; //output

// Input calc_tag
stream(axis128_t) poly1305_verify_calc_tag; //input
uint1_t poly1305_verify_calc_tag_ready; //output

// Output stream is_verified/tags_match bit
stream(uint1_t) poly1305_verify_tags_match; //output
uint1_t poly1305_verify_tags_match_ready; //input

typedef enum poly1305_verify_state_t{
  TAKE_AUTH_TAG, //take auth_tag and place it into a register
  TAKE_CALC_TAG, //take calculated tag and plae it into a reg
  COMPARE_TAGS,  //take the two tags and compare them if equal ("==") and place res in reg
  OUTPUT_COMPARE_RESULT //output the compare value 
};

#pragma MAIN poly1305_verify
void poly1305_verify(){

  // Define static variables
  static poly1305_verify_state_t state = TAKE_AUTH_TAG;
  
  // Default not ready for tag recieve
  poly1305_verify_auth_tag_ready = 0;
  poly1305_verify_calc_tag_ready = 0;

  // Default not outputting data
  stream(uint1_t) uint1_t_null = {0};
  poly1305_verify_tags_match_ready = uint1_t_null; 

  if (state == TAKE_AUTH_TAG){}
  else if (state == TAKE_CALC_TAG){}
  else if (state == COMPARE_TAGS){}
  else { //(state == OUTPUT_COMPARE_RESULT)
 

  }

}



