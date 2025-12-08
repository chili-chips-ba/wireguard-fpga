#pragma once
/**
 * based on code from
 * https://github.com/chili-chips-ba/wireguard-fpga/blob/main/2.sw/app/chacha20poly1305/chacha20.c
*/

#include "intN_t.h"
#include "uintN_t.h"
#include "compiler.h"
#include "axi/axis.h"
#include "../poly1305/poly1305.h"

#define CHACHA20_STATE_NWORDS 16
#define CHACHA20_KEY_SIZE 32
#define key_uint_t uint256_t
#define CHACHA20_NONCE_SIZE 12
#define nonce_uint_t uint96_t
#define CHACHA20_BLOCK_SIZE 64

// ChaCha20 state structure
typedef struct chacha20_state
{
    uint32_t state[CHACHA20_STATE_NWORDS]; // ChaCha20 state (16 words)
} chacha20_state;
// TODO is byte order for above struct little endian / does it match type_bytes_t.h?
#include "chacha20_state_bytes_t.h" // PipelineC byte casting funcs

// The ChaCha20 quarter round function
// TODO abcd are constants and might get better results if this function made into macro
chacha20_state quarter_round(chacha20_state s, uint4_t a, uint4_t b, uint4_t c, uint4_t d)
{
    chacha20_state o = s;

    // decompose ops
    uint32_t a1 = o.state[a] + o.state[b];
    uint32_t d1 = rotl32_16(o.state[d] ^ a1);
    uint32_t c1 = o.state[c] + d1;
    uint32_t b1 = rotl32_12(o.state[b] ^ c1);
    uint32_t a2 = a1 + b1;
    uint32_t d2 = rotl32_8(d1 ^ a2);
    uint32_t c2 = c1 + d2;
    uint32_t b2 = rotl32_7(b1 ^ c2);
    
    // join output
    o.state[a] = a2;
    o.state[b] = b2;
    o.state[c] = c2;
    o.state[d] = d2;

    return o;
}

chacha20_state chacha20_block_step(chacha20_state state0){
    // make a giant pipeline with 8 parallel ops
    chacha20_state state1 = quarter_round(state0, 0, 4, 8, 12);
    chacha20_state state2 = quarter_round(state1, 1, 5, 9, 13);
    chacha20_state state3 = quarter_round(state2, 2, 6, 10, 14);
    chacha20_state state4 = quarter_round(state3, 3, 7, 11, 15);
    chacha20_state state5 = quarter_round(state4, 0, 5, 10, 15);
    chacha20_state state6 = quarter_round(state5, 1, 6, 11, 12);
    chacha20_state state7 = quarter_round(state6, 2, 7, 8, 13);
    chacha20_state state8 = quarter_round(state7, 3, 4, 9, 14);
    return state8;
}

// ChaCha20 block function pipeline
chacha20_state chacha20_block(chacha20_state state)
{
    chacha20_state output;

    // 1. do 20 steps (2x each step) (giant pipeline)
    // TODO could be loop?
    chacha20_state step1  = chacha20_block_step(state);
    chacha20_state step2  = chacha20_block_step(step1);
    chacha20_state step3  = chacha20_block_step(step2);
    chacha20_state step4  = chacha20_block_step(step3);
    chacha20_state step5  = chacha20_block_step(step4);
    chacha20_state step6  = chacha20_block_step(step5);
    chacha20_state step7  = chacha20_block_step(step6);
    chacha20_state step8  = chacha20_block_step(step7);
    chacha20_state step9  = chacha20_block_step(step8);
    chacha20_state step10 = chacha20_block_step(step9);
    
    // 2. final parallel add
    uint4_t i;
    for (i = 0; i < CHACHA20_STATE_NWORDS; i+=1)
    {
        output.state[i] = step10.state[i] + state.state[i];
    }

    return output;
}


// ChaCha20 initialization function
chacha20_state chacha20_init(
  uint8_t key[CHACHA20_KEY_SIZE], 
  uint8_t nonce[CHACHA20_NONCE_SIZE], 
  uint32_t counter
){
    chacha20_state state;
    // Set the initial state (constants + key + nonce)
    // "expand 32-byte k"
    state.state[0] = 0x61707865; // "apxe"
    state.state[1] = 0x3320646e; // "3 dn"
    state.state[2] = 0x79622d32; // "yb-2"
    state.state[3] = 0x6b206574; // "k et"

    // Key
    uint32_t key_as_u32s[CHACHA20_KEY_SIZE/4];
    for(uint32_t i = 0; i < CHACHA20_KEY_SIZE/4; i+=1)
    {
      uint16_t lsbs = uint8_uint8(key[(i*4)+1], key[(i*4)+0]);
      uint16_t msbs = uint8_uint8(key[(i*4)+3], key[(i*4)+2]);
      key_as_u32s[i] = uint16_uint16(msbs, lsbs);
    }
    for(uint32_t i = 0; i < CHACHA20_KEY_SIZE/4; i+=1)
    {
        state.state[4 + i] = key_as_u32s[i];
    }

    // Counter
    state.state[12] = counter;

    // Nonce
    uint32_t nonce_as_u32s[CHACHA20_NONCE_SIZE/4];
    for(uint32_t i = 0; i < CHACHA20_NONCE_SIZE/4; i+=1)
    {
      uint16_t lsbs = uint8_uint8(nonce[(i*4)+1], nonce[(i*4)+0]);
      uint16_t msbs = uint8_uint8(nonce[(i*4)+3], nonce[(i*4)+2]);
      nonce_as_u32s[i] = uint16_uint16(msbs, lsbs);
    }
    for(uint32_t i = 0; i < CHACHA20_NONCE_SIZE/4; i+=1)
    {
        state.state[13 + i] = nonce_as_u32s[i];
    }

    return state;
}

/* Original software C
// ChaCha20 encryption/decryption function
void chacha20_encrypt(uint8_t *out, const uint8_t *in, size_t length, const uint8_t *key, const uint8_t *nonce, uint32_t counter)
{
    chacha20_state state;
    chacha20_state block;
    uint8_t *block_bytes = (uint8_t *)(block.state);

    while (length > 0)
    {
        chacha20_init(&state, key, nonce, counter);
        chacha20_block(&state, &block);

        size_t chunk_size = length > 64 ? 64 : length;
        for (size_t i = 0; i < chunk_size; i++)
        {
            out[i] = in[i] ^ block_bytes[i];
        }

        counter++;
        length -= chunk_size;
        out += chunk_size;
        in += chunk_size;
    }
}
// Pseudo code version of above chacha20_encrypt using fixed size arrays and no pointers
uint8_t[64] chacha20_encrypt_fixed(
  uint8_t in[64], 
  size_t length, 
  uint32_t key[32], 
  uint32_t nonce[12], 
  uint32_t counter
){
  chacha20_state state;
  chacha20_state block;
  uint8_t out[64];
  int pos = 0;
  while(length > 0){
    state = chacha20_init(key, nonce, counter);
    block = chacha20_block(state);
    uint8_t block_bytes[64] = chacha20_state_to_bytes(block);
    size_t chunk_size = length > 64 ? 64 : length;
    for (size_t i = 0; i < chunk_size; i++)
    {
      out[pos] = in[pos] ^ block_bytes[i];
      pos++;
    }
    counter++;
    length -= chunk_size;
  }
  return out;
}*/
/*
Pass by value version of body part of per-block loop:
    want in form: output_t func_name(input_t)
*/
typedef struct chacha20_loop_body_in_t
{
  axis512_t axis_in; // Stream of 64 byte blocks
  // TODO key and nonce dont change every block right? only per packet?
  // make global volatile input wire instead of function arg to prevent excess pipeline regs?
  uint8_t key[CHACHA20_KEY_SIZE]; 
  uint8_t nonce[CHACHA20_NONCE_SIZE];
  uint32_t counter;
} chacha20_loop_body_in_t;
DECL_STREAM_TYPE(chacha20_loop_body_in_t)
axis512_t chacha20_loop_body(
  chacha20_loop_body_in_t inputs
){
  uint8_t in_data[CHACHA20_BLOCK_SIZE] = inputs.axis_in.tdata; // TODO handle tkeep
  uint8_t key[CHACHA20_KEY_SIZE] = inputs.key;
  uint8_t nonce[CHACHA20_NONCE_SIZE] = inputs.nonce;
  uint32_t counter = inputs.counter;

  chacha20_state state = chacha20_init(key, nonce, counter);
  chacha20_state block = chacha20_block(state);

  // PipelineC byte casting funcs
  chacha20_state_bytes_t block_bytes_t = chacha20_state_to_bytes(block);
  uint8_t block_bytes[CHACHA20_BLOCK_SIZE] = block_bytes_t.data;

  uint8_t out_data[CHACHA20_BLOCK_SIZE];
  // TODO partial in data, i.e. partial tkeep
  //    size_t chunk_size = length > 64 ? 64 : length;
  for(uint32_t i = 0; i < CHACHA20_BLOCK_SIZE; i+=1)
  {
    out_data[i] = in_data[i] ^ block_bytes[i];
  }
  // Output pass though AXIS tlast,tkeep,tvalid
  axis512_t axis_out = inputs.axis_in;
  // Data bytes are encrypted output of chacha20
  axis_out.tdata = out_data;
  return axis_out;
}

// FSM for the two parts of chacha20 decrypt
// Is actually two independent FSMs
// one handling inputs to the pipeline
// and another handling output from the pipeline

// Two uses of the chacha20_pipeline
typedef enum chacha20_state_t{
  POLY_KEY,
  PLAINTEXT
} chacha20_state_t;

typedef struct chacha20_fsm_t{
  // Outputs
  uint1_t ready_for_axis_in;
  stream(poly1305_key_uint_t) poly_key;
  stream(axis128_t) axis;
  stream(chacha20_loop_body_in_t) to_pipeline;
  uint1_t ready_for_from_pipeline;
}chacha20_fsm_t;
chacha20_fsm_t chacha20_fsm(
  // Inputs
  uint8_t key[CHACHA20_KEY_SIZE],
  uint8_t nonce[CHACHA20_NONCE_SIZE],
  stream(axis128_t) axis_in,
  uint1_t ready_for_poly_key_out,
  uint1_t ready_for_axis_out,
  uint1_t to_pipeline_ready,
  stream(axis512_t) from_pipeline
){
  chacha20_fsm_t o;

  // INPUT SIDE FSM
  // Puts poly1305_key_gen blocks=0,count=0 followed by plaintext into pipeline 
  
  // Pipeline input muxing FSM
  static chacha20_state_t input_side_state;
  static uint32_t block_count = 0;
  // Default no input into width conversion
  stream(axis128_t) dwidth_conv_data_in = {0};
  o.ready_for_axis_in = 0;
  // Default no input into pipeline
  stream(chacha20_loop_body_in_t) NULL_PIPELINE_IN = {0};
  o.to_pipeline = NULL_PIPELINE_IN;
  //  other than CSR inputs and such
  o.to_pipeline.data.key = key;
  o.to_pipeline.data.nonce = nonce;
  o.to_pipeline.data.counter = block_count;
  
  // Convert input axis to 512b
  // Input axis into dwidth conv default gated until in plaintext state
  if(input_side_state == PLAINTEXT){
    dwidth_conv_data_in = axis_in;
  }
  uint1_t block_in_ready;
  #pragma FEEDBACK block_in_ready
  axis128_to_axis512_t in_to_block = axis128_to_axis512(dwidth_conv_data_in, block_in_ready);
  stream(axis512_t) block_in_stream = in_to_block.axis_out;
  // Default not ready for incoming blocks
  block_in_ready = 0;
  // Input axis into dwidth conv default gated until in plaintext state
  if(input_side_state == PLAINTEXT){
    o.ready_for_axis_in = in_to_block.axis_in_ready;
  }
  
  if(input_side_state == POLY_KEY){
    // Wait for incoming plaintext
    if(axis_in.valid | block_in_stream.valid){
      // Do poly1305_key_gen, use counter 0 and generate a block
      // Start by putting zero data and block_count=0 into chacha pipeline
      ARRAY_SET(o.to_pipeline.data.axis_in.tdata, 0, CHACHA20_BLOCK_SIZE)
      ARRAY_SET(o.to_pipeline.data.axis_in.tkeep, 1, CHACHA20_BLOCK_SIZE)
      o.to_pipeline.valid = 1;
      // Wait until data accepted into pipeline
      if(to_pipeline_ready){
        block_count += 1;
        // then allow a packet of plaintext to flow into the pipeline
        input_side_state = PLAINTEXT;
      }
    }
  }else{ //if(input_side_state == PLAINTEXT){
    o.to_pipeline.data.axis_in = block_in_stream.data;
    o.to_pipeline.valid = block_in_stream.valid;
    block_in_ready = to_pipeline_ready; // FEEDBACK
    if(o.to_pipeline.valid & to_pipeline_ready){
      block_count += 1;
      // if this was last block into pipeline then reset counter and poly key next
      if(o.to_pipeline.data.axis_in.tlast){
        block_count = 0;
        input_side_state = POLY_KEY;
      }
    }
  }

  // Output side FSM
  // Get poly1305_key_gen data or ciphertext out of pipeline

  // Pipeline output demuxing FSM
  static chacha20_state_t output_side_state;
  // Default not ready for pipeline output
  o.ready_for_from_pipeline = 0;
  // Default no block going out
  stream(axis512_t) block_to_out_axis_in = {0};
  uint1_t block_to_out_axis_in_ready;
  #pragma FEEDBACK block_to_out_axis_in_ready
  if(output_side_state == POLY_KEY){
    // Wait for the poly key cycle of data to come out of the pipeline
    // it goes out the poly1305_key output stream
    // First 32 bytes of the block become the Poly1305 key
    uint8_t poly_key[POLY1305_KEY_SIZE];
    ARRAY_COPY(poly_key, from_pipeline.data.tdata, POLY1305_KEY_SIZE)
    o.poly_key.data = poly1305_key_uint_from_bytes(poly_key);
    o.poly_key.valid = from_pipeline.valid;
    o.ready_for_from_pipeline = ready_for_poly_key_out;
    // When output of key happens move on to plaintext
    if(o.poly_key.valid & ready_for_poly_key_out){
      output_side_state = PLAINTEXT;
    }
  }else{ //if(output_side_state == PLAINTEXT)
    // Wait for the last cycle of ciphertext data to come out of the pipeline
    block_to_out_axis_in = from_pipeline;
    o.ready_for_from_pipeline = block_to_out_axis_in_ready;
    if(from_pipeline.valid & o.ready_for_from_pipeline){
      // If this was last block then reset state
      if(from_pipeline.data.tlast){
        output_side_state = POLY_KEY;
      }
    }
  }

  // Convert pipeline output 512b block stream to 128b
  axis512_to_axis128_t block_to_out = axis512_to_axis128(block_to_out_axis_in, ready_for_axis_out);
  o.axis = block_to_out.axis_out;
  block_to_out_axis_in_ready = block_to_out.axis_in_ready; // FEEDBACK

  return o;
}