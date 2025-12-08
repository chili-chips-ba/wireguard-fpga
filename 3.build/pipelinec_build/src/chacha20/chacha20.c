// Instance of chacha20_loop_body
// requires data width converters to-from 512b wide blocks 128b bus
// use axis128/512 stream types
#include "axi/axis.h"
#include "global_func_inst.h"
#include "chacha20.h"
#include "../poly1305/poly1305.h"

#ifndef CHACHA_INST
#define CHACHA_INST chacha20
#endif

// Globally visible ports
// CSR inputs
uint8_t PPCAT(CHACHA_INST,_key)[CHACHA20_KEY_SIZE]; // input
uint8_t PPCAT(CHACHA_INST,_nonce)[CHACHA20_NONCE_SIZE]; // input
// Input plaintext
stream(axis128_t) PPCAT(CHACHA_INST,_axis_in); // input
uint1_t PPCAT(CHACHA_INST,_axis_in_ready); // output
// Output poly1305_key
stream(poly1305_key_uint_t) PPCAT(CHACHA_INST,_poly_key); // output
uint1_t PPCAT(CHACHA_INST,_poly_key_ready); // input
// Output ciphertext
stream(axis128_t) PPCAT(CHACHA_INST,_axis_out); // output
uint1_t PPCAT(CHACHA_INST,_axis_out_ready); // input

// Global instance of the chacha20_loop_body pipeline
GLOBAL_VALID_READY_PIPELINE_INST(PPCAT(CHACHA_INST,_pipeline), axis512_t, chacha20_loop_body, chacha20_loop_body_in_t, 64)

// Instance of FSM to control pipeline
MAIN(CHACHA_INST)
void CHACHA_INST(){
  chacha20_fsm_t fsm_out = chacha20_fsm(
    PPCAT(CHACHA_INST,_key),
    PPCAT(CHACHA_INST,_nonce),
    PPCAT(CHACHA_INST,_axis_in),
    PPCAT(CHACHA_INST,_poly_key_ready),
    PPCAT(CHACHA_INST,_axis_out_ready),
    PPCAT(CHACHA_INST,_pipeline_in_ready),
    PPCAT(CHACHA_INST,_pipeline_out)
  );
  PPCAT(CHACHA_INST,_axis_in_ready) = fsm_out.ready_for_axis_in;
  PPCAT(CHACHA_INST,_poly_key) = fsm_out.poly_key;
  PPCAT(CHACHA_INST,_axis_out) = fsm_out.axis;
  PPCAT(CHACHA_INST,_pipeline_in) = fsm_out.to_pipeline;
  PPCAT(CHACHA_INST,_pipeline_out_ready) = fsm_out.ready_for_from_pipeline;
}

#undef CHACHA_INST