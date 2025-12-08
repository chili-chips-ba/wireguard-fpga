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

#ifndef POLY_MAC_INST
#define POLY_MAC_INST poly1305_mac
#endif

// Declare poly1305_mac_loop_body pipeline to use (with valid bit)
// TODO can declare as harder to meet timing GLOBAL_FUNCTION that doesnt add IO regs
#include "global_func_inst.h"
GLOBAL_PIPELINE_INST_W_VALID_ID(PPCAT(POLY_MAC_INST,_pipeline), u320_t, poly1305_mac_loop_body, poly1305_mac_loop_body_in_t)

// Global input and output wires for FSM
// 32-byte key (r || s) input
stream(poly1305_key_uint_t) PPCAT(POLY_MAC_INST,_key); // input
uint1_t PPCAT(POLY_MAC_INST,_key_ready); // output
// 16 byte wide AXIS port for data input
stream(axis128_t) PPCAT(POLY_MAC_INST,_data_in);
uint1_t PPCAT(POLY_MAC_INST,_data_in_ready);
// 16-byte authentication tag output as DVR handshake
stream(poly1305_auth_tag_uint_t) PPCAT(POLY_MAC_INST,_auth_tag); // output
uint1_t PPCAT(POLY_MAC_INST,_auth_tag_ready); // input

// FSM that uses pipeline iteratively to compute poly1305 MAC
MAIN(POLY_MAC_INST)
void POLY_MAC_INST(){
  poly1305_mac_fsm_t fsm_out = poly1305_mac_fsm(
    PPCAT(POLY_MAC_INST,_key),
    PPCAT(POLY_MAC_INST,_data_in),
    PPCAT(POLY_MAC_INST,_auth_tag_ready),
    PPCAT(POLY_MAC_INST,_pipeline_out),
    PPCAT(POLY_MAC_INST,_pipeline_out_valid)
  );
  PPCAT(POLY_MAC_INST,_key_ready) = fsm_out.ready_for_key;
  PPCAT(POLY_MAC_INST,_data_in_ready) = fsm_out.ready_for_data_in;
  PPCAT(POLY_MAC_INST,_auth_tag) = fsm_out.auth_tag;
  PPCAT(POLY_MAC_INST,_pipeline_in) = fsm_out.to_pipeline;
  PPCAT(POLY_MAC_INST,_pipeline_in_valid) = fsm_out.to_pipeline_valid;
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
  PPCAT(POLY_MAC_INST,_data_in) = data_in;
  data_in_ready = PPCAT(POLY_MAC_INST,_data_in_ready);
  auth_tag_out = uint8_array16_le(PPCAT(POLY_MAC_INST,_auth_tag));
  auth_tag_out_valid = poly1305_mac_auth_tag_valid;
}*/

#undef POLY_MAC_INST