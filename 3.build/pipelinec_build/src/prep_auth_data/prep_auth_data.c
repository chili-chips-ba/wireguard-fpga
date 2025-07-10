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

// Additional authenticated data input wires
// TODO AAD is unused, could be removed
uint8_t prep_auth_data_aad[AAD_MAX_LEN];
uint8_t prep_auth_data_aad_len;
// Input stream of ciphertext
stream(axis128_t) prep_auth_data_axis_in; // input
uint1_t prep_auth_data_axis_in_ready; // output
// Output stream of authenticated data
stream(axis128_t) prep_auth_data_axis_out; // output
uint1_t prep_auth_data_axis_out_ready; // input

typedef enum prep_auth_data_state_t{
  IDLE,
  AAD,
  CIPHERTEXT,
  LENGTHS
}prep_auth_data_state_t;

#pragma MAIN prep_auth_data
void prep_auth_data()
{
  // FSM that adds leading and trailing bytes around the ciphertext stream
  // to prepare the stream to be authenticated by Poly1305
  // AAD || padding || ciphertext || padding || AAD length || ciphertext length
  static prep_auth_data_state_t state;
  static uint8_t aad_reg[AAD_MAX_LEN];
  static uint16_t counter;

  // Default not ready for incoming data
  prep_auth_data_axis_in_ready = 0;
  // Default not outputting data
  stream(axis128_t) axis128_null = {0};
  prep_auth_data_axis_out = axis128_null;
  
  if(state == IDLE)
  {
    // Wait for incoming ciphertext
    if(prep_auth_data_axis_in.valid)
    {
      // Not yet ready for data until CIPHERTEXT 
      // If have AAD, then output it first
      if(prep_auth_data_aad_len > 0)
      {
        // AAD is first, save input into reg for shifting out
        aad_reg = prep_auth_data_aad;
        // and init counter with AAD length
        counter = prep_auth_data_aad_len;
        state = AAD;
      }
      else
      {
        // No AAD, so ciphertext is first
        state = CIPHERTEXT;
        counter = 0;
      }
    }
  }
  else if(state == AAD)
  {
    // Output up to 128b|16 bytes of AAD this cycle
    // AAD is conveiniently padded to multiple of 16 bytes
    // so always full tkeep, tdata=0 for padding
    for(int32_t i=0; i<16; i+=1)
    {
      if(counter > i){
        prep_auth_data_axis_out.data.tdata[i] = aad_reg[i];
      }
      prep_auth_data_axis_out.data.tkeep[i] = 1;
    }
    prep_auth_data_axis_out.valid = 1;

    // Count AAD bytes as xfer happens
    if(prep_auth_data_axis_out.valid & prep_auth_data_axis_out_ready)
    {
      // More AAD bytes?
      if(counter > 16)
      {
        // Prepare next AAD bytes to be at bottom of the array
        ARRAY_SHIFT_DOWN(aad_reg, AAD_MAX_LEN, 16)
        counter -= 16;  
      }
      else
      {
        // No more AAD bytes, CIPHERTEXT is next
        state = CIPHERTEXT;
        counter = 0;
      }
    }
  }
  else if(state == CIPHERTEXT)
  {
    // Pass through ciphertext
    prep_auth_data_axis_out = prep_auth_data_axis_in;
    prep_auth_data_axis_in_ready = prep_auth_data_axis_out_ready;
    // last cycle of ciphertext is not the last cycle of output stream
    prep_auth_data_axis_out.data.tlast = 0;
    // Data needs to be padded to 16 bytes with zeros
    // during cycles with partial tkeep
    for(int32_t i=0; i<16; i+=1)
    {
      prep_auth_data_axis_out.data.tkeep[i] = 1;
      if(~prep_auth_data_axis_in.data.tkeep[i]){
        prep_auth_data_axis_out.data.tdata[i] = 0;
      }
    }

    // Count ciphertext length as xfer happens
    if(prep_auth_data_axis_in.valid & prep_auth_data_axis_in_ready){
      counter += axis128_keep_count(prep_auth_data_axis_in.data);
      // As last cycle on input ciphertest passes, move to next state
      if(prep_auth_data_axis_in.data.tlast){
        state = LENGTHS;
      }
    }
  }
  else //if(state == LENGTHS)
  {
    // Two 64b lengths of AAD and ciphertext
    // fit into one 128b AXIS cycle
    int32_t pos = 0;
    // AAD length
    for(int32_t i=0; i<8; i+=1)
    {
      prep_auth_data_axis_out.data.tdata[pos] = prep_auth_data_aad_len >> (i*8);
      prep_auth_data_axis_out.data.tkeep[pos] = 1;
      pos += 1;
    }
    // Ciphertext length
    for(int32_t i=0; i<8; i+=1)
    {
      prep_auth_data_axis_out.data.tdata[pos] = counter >> (i*8);
      prep_auth_data_axis_out.data.tkeep[pos] = 1;
      pos += 1;
    }
    // Last cycle of output stream
    prep_auth_data_axis_out.data.tlast = 1;
    prep_auth_data_axis_out.valid = 1;

    // As xfer happens, go back to idle
    if(prep_auth_data_axis_out.valid & prep_auth_data_axis_out_ready)
    {
      state = IDLE;
    }
  }
}