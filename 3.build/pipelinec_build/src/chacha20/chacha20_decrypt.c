// Instance of chacha20_loop_body
// requires data width converters to-from 512b wide blocks 128b bus
// use axis128/512 stream types
#include "axi/axis.h"
#include "global_func_inst.h"
#include "chacha20.h"
#include "../poly1305/poly1305.h"

// Globally visible ports
// CSR inputs
uint8_t chacha20_decrypt_key[CHACHA20_KEY_SIZE]; // input
uint8_t chacha20_decrypt_nonce[CHACHA20_NONCE_SIZE]; // input
// Input plaintext
stream(axis128_t) chacha20_decrypt_axis_in; // input
uint1_t chacha20_decrypt_axis_in_ready; // output
// Output poly1305_key
stream(poly1305_key_uint_t) chacha20_decrypt_poly_key; // output
uint1_t chacha20_decrypt_poly_key_ready; // input
// Output ciphertext
stream(axis128_t) chacha20_decrypt_axis_out; // output
uint1_t chacha20_decrypt_axis_out_ready; // input

// Global instance of the chacha20_loop_body pipeline
GLOBAL_VALID_READY_PIPELINE_INST(chacha20_decrypt_pipeline, axis512_t, chacha20_loop_body, chacha20_loop_body_in_t, 64)

// Two uses of the chacha20_decrypt_pipeline
typedef enum chacha20_decrypt_state_t{
  POLY_KEY,
  PLAINTEXT
} chacha20_decrypt_state_t;

// FSM for the two parts of chacha20 decrypt
// Is actually two independent FSMs
// one handling inputs to the pipeline
// and another handling output from the pipeline

// INPUT SIDE FSM
// Puts poly1305_key_gen blocks=0,count=0 followed by plaintext into pipeline 
#pragma MAIN chacha20_decrypt_input_side
void chacha20_decrypt_input_side()
{
  // Pipeline input muxing FSM
  static chacha20_decrypt_state_t input_side_state;
  static uint32_t block_count = 0;
  // Default no input into width conversion
  stream(axis128_t) dwidth_conv_data_in = {0};
  chacha20_decrypt_axis_in_ready = 0;
  // Default no input into pipeline
  stream(chacha20_loop_body_in_t) NULL_PIPELINE_IN = {0};
  chacha20_decrypt_pipeline_in = NULL_PIPELINE_IN;
  //  other than CSR inputs and such
  chacha20_decrypt_pipeline_in.data.key = chacha20_decrypt_key;
  chacha20_decrypt_pipeline_in.data.nonce = chacha20_decrypt_nonce;
  chacha20_decrypt_pipeline_in.data.counter = block_count;
  
  // Convert input axis to 512b
  // Input axis into dwidth conv default gated until in plaintext state
  if(input_side_state == PLAINTEXT){
    dwidth_conv_data_in = chacha20_decrypt_axis_in;
  }
  uint1_t block_in_ready;
  #pragma FEEDBACK block_in_ready
  axis128_to_axis512_t in_to_block = axis128_to_axis512(dwidth_conv_data_in, block_in_ready);
  stream(axis512_t) block_in_stream = in_to_block.axis_out;
  // Default not ready for incoming blocks
  block_in_ready = 0;
  // Input axis into dwidth conv default gated until in plaintext state
  if(input_side_state == PLAINTEXT){
    chacha20_decrypt_axis_in_ready = in_to_block.axis_in_ready;
  }
  
  if(input_side_state == POLY_KEY){
    // Wait for incoming plaintext
    if(chacha20_decrypt_axis_in.valid | block_in_stream.valid){
      // Do poly1305_key_gen, use counter 0 and generate a block
      // Start by putting zero data and block_count=0 into chacha pipeline
      ARRAY_SET(chacha20_decrypt_pipeline_in.data.axis_in.tdata, 0, CHACHA20_BLOCK_SIZE)
      ARRAY_SET(chacha20_decrypt_pipeline_in.data.axis_in.tkeep, 1, CHACHA20_BLOCK_SIZE)
      chacha20_decrypt_pipeline_in.valid = 1;
      // Wait until data accepted into pipeline
      if(chacha20_decrypt_pipeline_in_ready){
        block_count += 1;
        // then allow a packet of plaintext to flow into the pipeline
        input_side_state = PLAINTEXT;
      }
    }
  }else{ //if(input_side_state == PLAINTEXT){
    chacha20_decrypt_pipeline_in.data.axis_in = block_in_stream.data;
    chacha20_decrypt_pipeline_in.valid = block_in_stream.valid;
    block_in_ready = chacha20_decrypt_pipeline_in_ready; // FEEDBACK
    if(chacha20_decrypt_pipeline_in.valid & chacha20_decrypt_pipeline_in_ready){
      block_count += 1;
      // if this was last block into pipeline then reset counter and poly key next
      if(chacha20_decrypt_pipeline_in.data.axis_in.tlast){
        block_count = 0;
        input_side_state = POLY_KEY;
      }
    }
  }
}

// Output side FSM
// Get poly1305_key_gen data or ciphertext out of pipeline
#pragma MAIN chacha20_decrypt_output_side
void chacha20_decrypt_output_side()
{
  // Pipeline output demuxing FSM
  static chacha20_decrypt_state_t output_side_state;
  // Default not ready for pipeline output
  chacha20_decrypt_pipeline_out_ready = 0;
  // Default no block going out
  stream(axis512_t) block_to_out_axis_in = {0};
  uint1_t block_to_out_axis_in_ready;
  #pragma FEEDBACK block_to_out_axis_in_ready
  if(output_side_state == POLY_KEY){
    // Wait for the poly key cycle of data to come out of the pipeline
    // it goes out the poly1305_key output stream
    // First 32 bytes of the block become the Poly1305 key
    uint8_t poly_key[POLY1305_KEY_SIZE];
    ARRAY_COPY(poly_key, chacha20_decrypt_pipeline_out.data.tdata, POLY1305_KEY_SIZE)
    chacha20_decrypt_poly_key.data = poly1305_key_uint_from_bytes(poly_key);
    chacha20_decrypt_poly_key.valid = chacha20_decrypt_pipeline_out.valid;
    chacha20_decrypt_pipeline_out_ready = chacha20_decrypt_poly_key_ready;
    // When output of key happens move on to plaintext
    if(chacha20_decrypt_poly_key.valid & chacha20_decrypt_poly_key_ready){
      output_side_state = PLAINTEXT;
    }
  }else{ //if(output_side_state == PLAINTEXT)
    // Wait for the last cycle of ciphertext data to come out of the pipeline
    block_to_out_axis_in = chacha20_decrypt_pipeline_out;
    chacha20_decrypt_pipeline_out_ready = block_to_out_axis_in_ready;
    if(chacha20_decrypt_pipeline_out.valid & chacha20_decrypt_pipeline_out_ready){
      // If this was last block then reset state
      if(chacha20_decrypt_pipeline_out.data.tlast){
        output_side_state = POLY_KEY;
      }
    }
  }

  // Convert pipeline output 512b block stream to 128b
  axis512_to_axis128_t block_to_out = axis512_to_axis128(block_to_out_axis_in, chacha20_decrypt_axis_out_ready);
  chacha20_decrypt_axis_out = block_to_out.axis_out;
  block_to_out_axis_in_ready = block_to_out.axis_in_ready; // FEEDBACK
}