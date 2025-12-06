// Instance of chacha20_loop_body
// requires data width converters to-from 512b wide blocks 128b bus
// use axis128/512 stream types
#include "axi/axis.h"
#include "global_func_inst.h"
#include "chacha20.h"
#include "../poly1305/poly1305.h"

// Globally visible ports
// CSR inputs
uint8_t chacha20_encrypt_key[CHACHA20_KEY_SIZE]; // input
uint8_t chacha20_encrypt_nonce[CHACHA20_NONCE_SIZE]; // input
// Input plaintext
stream(axis128_t) chacha20_encrypt_axis_in; // input
uint1_t chacha20_encrypt_axis_in_ready; // output
// Output poly1305_key
stream(poly1305_key_uint_t) chacha20_encrypt_poly_key; // output
uint1_t chacha20_encrypt_poly_key_ready; // input
// Output ciphertext
stream(axis128_t) chacha20_encrypt_axis_out; // output
uint1_t chacha20_encrypt_axis_out_ready; // input

// Global instance of the chacha20_loop_body pipeline
GLOBAL_VALID_READY_PIPELINE_INST(chacha20_encrypt_pipeline, axis512_t, chacha20_loop_body, chacha20_loop_body_in_t, 64)

// Instance of FSM to control pipeline
#pragma MAIN chacha20_encrypt
void chacha20_encrypt(){
  chacha20_fsm_t fsm_out = chacha20_fsm(
    chacha20_encrypt_key,
    chacha20_encrypt_nonce,
    chacha20_encrypt_axis_in,
    chacha20_encrypt_poly_key_ready,
    chacha20_encrypt_axis_out_ready,
    chacha20_encrypt_pipeline_in_ready,
    chacha20_encrypt_pipeline_out
  );
  chacha20_encrypt_axis_in_ready = fsm_out.ready_for_axis_in;
  chacha20_encrypt_poly_key = fsm_out.poly_key;
  chacha20_encrypt_axis_out = fsm_out.axis;
  chacha20_encrypt_pipeline_in = fsm_out.to_pipeline;
  chacha20_encrypt_pipeline_out_ready = fsm_out.ready_for_from_pipeline;
}
