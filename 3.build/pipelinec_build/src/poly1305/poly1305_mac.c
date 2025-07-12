/* Code using a poly1305_mac_loop_body pipeline to evaluate: 
for (size_t i = 0; i < blocks; i++)
{
  // 'a' feeds back into the pipeline/next iteration
  a = poly1305_mac_loop_body(block_bytes, r, a);
}
*/
#include "uintN_t.h"
#include "intN_t.h"
#include "axi/axis.h"
#include "poly1305.h"

// Declare poly1305_mac_loop_body pipeline to use (with valid bit)
// TODO can declare as harder to meet timing GLOBAL_FUNCTION that doesnt add IO regs
#include "global_func_inst.h"
GLOBAL_PIPELINE_INST_W_VALID_ID(poly1305_pipeline, u320_t, poly1305_mac_loop_body, poly1305_mac_loop_body_in_t)

// Global input and output wires for FSM
// 32-byte key (r || s) input
stream(poly1305_key_uint_t) poly1305_mac_key; // input
uint1_t poly1305_mac_key_ready; // output
// 16 byte wide AXIS port for data input
stream(axis128_t) poly1305_mac_data_in;
uint1_t poly1305_mac_data_in_ready;
// 16-byte authentication tag output as DVR handshake
stream(poly1305_auth_tag_uint_t) poly1305_mac_auth_tag; // output
uint1_t poly1305_mac_auth_tag_ready; // input

// FSM that uses pipeline iteratively to compute poly1305 MAC
typedef enum poly1305_state_t{
  // TODO can combine states for lower per block latency
  IDLE, // Wait for poly1305_key
  START_ITER, // Put data into pipeline
  FINISH_ITER, // Wait for data out of pipeline
  A_PLUS_S, // Add s to a final step before output
  OUTPUT_AUTH_TAG // Output the auth tag
} poly1305_state_t;
#pragma MAIN poly1305_mac
void poly1305_mac(){
  // Default not ready for incoming poly key
  poly1305_mac_key_ready = 0;
  // Default not ready for incoming data
  poly1305_mac_data_in_ready = 0;
  // Default not outputting an auth tag
  poly1305_mac_auth_tag.data = 0;
  poly1305_mac_auth_tag.valid = 0;
  // Default nothing into pipeline
  poly1305_mac_loop_body_in_t pipeline_null_inputs = {0};
  poly1305_pipeline_in = pipeline_null_inputs;
  poly1305_pipeline_in_valid = 0;

  // The FSM
  static poly1305_state_t state;
  static uint1_t is_last_block;
  static u320_t a;
  static u320_t r;
  static u320_t s;
  if(state == IDLE){
    // Reset state
    is_last_block = 0; // Not the last block yet
    u320_t u320_null = {0};
    a = u320_null; // Initialize accumulator to 0
    r = u320_null; // Initialize r to 0
    s = u320_null; // Initialize s to 0
    // Wait for poly1305_key
    poly1305_mac_key_ready = 1;
    if(poly1305_mac_key.valid & poly1305_mac_key_ready){
      uint8_t poly1305_mac_data_key[POLY1305_KEY_SIZE];
      UINT_TO_BYTE_ARRAY(poly1305_mac_data_key, POLY1305_KEY_SIZE, poly1305_mac_key.data)
      // Key input
      u8_16_t r_bytes; // r part of the key
      u8_16_t s_bytes; // s part of the key
      // Split key into r and s 
      for(int32_t i=0; i<(POLY1305_KEY_SIZE/2); i+=1){
        r_bytes.bytes[i] = poly1305_mac_data_key[i];
        s_bytes.bytes[i] = poly1305_mac_data_key[i+16];
      }
      // Clamp r according to the spec
      r_bytes = clamp(r_bytes);
      // Convert r and s to u320_t and save in regs
      r = bytes_to_uint320(r_bytes.bytes);
      s = bytes_to_uint320(s_bytes.bytes);
      // Then start per block iterations
      state = START_ITER; 
    }
  }else if(state == START_ITER){
    // Ready to take an input data block
    poly1305_mac_data_in_ready = 1;
    // Put 'a' and data block into pipeline
    poly1305_pipeline_in.block_bytes = poly1305_mac_data_in.data.tdata;
    poly1305_pipeline_in.a = a;
    poly1305_pipeline_in.r = r;
    poly1305_pipeline_in_valid = poly1305_mac_data_in.valid & poly1305_mac_data_in_ready;
    // Record if this is the last block
    is_last_block = poly1305_mac_data_in.data.tlast;
    // And then wait for the output once input into pipeline happens
    if(poly1305_pipeline_in_valid & poly1305_mac_data_in_ready){
      state = FINISH_ITER;
    }
  }else if(state == FINISH_ITER){
    // Wait for 'a' data out of pipeline
    if(poly1305_pipeline_out_valid){
      a = poly1305_pipeline_out;
      // print 'a' every block
      //print_u320(a);
      // if last block do final step
      if(is_last_block){
        state = A_PLUS_S;
      }else{
        // More blocks using 'a' next
        state = START_ITER;
      }
    }
  }else if(state == A_PLUS_S){
    // a += s
    a = uint320_add(a, s);
    // Output a next
    state = OUTPUT_AUTH_TAG;
  }else if(state == OUTPUT_AUTH_TAG){
    // First 16 bytes of 'a' are the output  
    u320_t_bytes_t a_bytes = u320_t_to_bytes(a);
    uint8_t auth_tag[POLY1305_AUTH_TAG_SIZE];
    ARRAY_COPY(auth_tag, a_bytes.data, POLY1305_AUTH_TAG_SIZE)
    poly1305_mac_auth_tag.data = poly1305_auth_tag_uint_from_bytes(auth_tag);
    poly1305_mac_auth_tag.valid = 1;
    if(poly1305_mac_auth_tag.valid & poly1305_mac_auth_tag_ready){
      state = IDLE;
    }
  }
}


/* Test synthesis
#include "arrays.h"
DECL_INPUT(uint256_t, key_in)
DECL_INPUT(stream(axis128_t), data_in)
DECL_OUTPUT(uint1_t, data_in_ready)
DECL_OUTPUT(uint128_t, auth_tag_out)
DECL_OUTPUT(uint1_t, auth_tag_out_valid)
#pragma PART "xc7a200tffg1156-2" // Artix 7 200T
#pragma MAIN_MHZ poly1305_mac_loop_connect 80.0
void poly1305_mac_loop_connect(){
  UINT_TO_BYTE_ARRAY(poly1305_mac_data_key, 32, key_in)
  poly1305_mac_data_in = data_in;
  data_in_ready = poly1305_mac_data_in_ready;
  auth_tag_out = uint8_array16_le(poly1305_mac_auth_tag);
  auth_tag_out_valid = poly1305_mac_auth_tag_valid;
}*/