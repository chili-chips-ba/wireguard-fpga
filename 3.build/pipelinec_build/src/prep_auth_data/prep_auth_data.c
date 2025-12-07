/*  
// 3. Prepare the authenticated data for Poly1305
// Allocate memory for AAD || padding || ciphertext || padding || AAD length || ciphertext length
size_t aad_padding = (16 - (aad_len % 16)) % 16;
size_t ciphertext_padding = (16 - (plaintext_len % 16)) % 16;
size_t auth_data_len = aad_len + aad_padding + plaintext_len + ciphertext_padding + 16;

uint8_t *auth_data = (uint8_t *)calloc(auth_data_len, 1);
if (!auth_data)
  return -1; // Memory allocation failure

// Copy AAD
if (aad_reg && aad_len > 0)
  memcpy(auth_data, aad_reg, aad_len);

// Copy ciphertext after AAD (and padding)
memcpy(auth_data + aad_len + aad_padding, ciphertext, plaintext_len);

// Append AAD and ciphertext lengths as little-endian 64-bit integers
uint8_t *lengths = auth_data + aad_len + aad_padding + plaintext_len + ciphertext_padding;
encode_le64(lengths, aad_len);
encode_le64(lengths + 8, plaintext_len);
*/
#include "arrays.h"
#include "prep_auth_data.h"

#ifndef PREP_AUTH_DATA_INST
#define PREP_AUTH_DATA_INST prep_auth_data
#endif

// Additional authenticated data input wires
// TODO AAD is unused, could be removed
uint8_t PPCAT(PREP_AUTH_DATA_INST,_aad)[AAD_MAX_LEN];
uint8_t PPCAT(PREP_AUTH_DATA_INST,_aad_len);
// Input stream of ciphertext
stream(axis128_t) PPCAT(PREP_AUTH_DATA_INST,_axis_in); // input
uint1_t PPCAT(PREP_AUTH_DATA_INST,_axis_in_ready); // output
// Output stream of authenticated data
stream(axis128_t) PPCAT(PREP_AUTH_DATA_INST,_axis_out); // output
uint1_t PPCAT(PREP_AUTH_DATA_INST,_axis_out_ready); // input

MAIN(PREP_AUTH_DATA_INST)
void PREP_AUTH_DATA_INST()
{
  prep_auth_data_fsm_t fsm_out = prep_auth_data_fsm(
    PPCAT(PREP_AUTH_DATA_INST,_aad),
    PPCAT(PREP_AUTH_DATA_INST,_aad_len),
    PPCAT(PREP_AUTH_DATA_INST,_axis_in),
    PPCAT(PREP_AUTH_DATA_INST,_axis_out_ready)
  );
  PPCAT(PREP_AUTH_DATA_INST,_axis_in_ready) = fsm_out.ready_for_axis_in;
  PPCAT(PREP_AUTH_DATA_INST,_axis_out) = fsm_out.axis;
}

#undef PREP_AUTH_DATA_INST