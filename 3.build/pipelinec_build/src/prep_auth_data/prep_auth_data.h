#pragma once
#define AAD_MAX_LEN 32
#define aad_uint_t uint256_t

typedef enum prep_auth_data_state_t{
  IDLE,
  AAD_STATE,
  CIPHERTEXT,
  LENGTHS
}prep_auth_data_state_t;

typedef struct prep_auth_data_fsm_t{
  // Outputs
  uint1_t ready_for_axis_in;
  stream(axis128_t) axis;
}prep_auth_data_fsm_t;
prep_auth_data_fsm_t prep_auth_data_fsm(
  // Inputs
  uint8_t aad[AAD_MAX_LEN],
  uint8_t aad_len,
  stream(axis128_t) axis_in,
  uint1_t ready_for_axis_out
){
  prep_auth_data_fsm_t o;
  // FSM that adds leading and trailing bytes around the ciphertext stream
  // to prepare the stream to be authenticated by Poly1305
  // AAD || padding || ciphertext || padding || AAD length || ciphertext length
  static prep_auth_data_state_t state;
  static uint8_t aad_reg[AAD_MAX_LEN];
  static uint16_t counter;

  // Default not ready for incoming data
  o.ready_for_axis_in = 0;
  // Default not outputting data
  stream(axis128_t) axis128_null = {0};
  o.axis = axis128_null;
  
  if(state == IDLE)
  {
    // Wait for incoming ciphertext
    if(axis_in.valid)
    {
      // Not yet ready for data until CIPHERTEXT 
      // If have AAD, then output it first
      if(aad_len > 0)
      {
        // AAD is first, save input into reg for shifting out
        aad_reg = aad;
        // and init counter with AAD length
        counter = aad_len;
        state = AAD_STATE;
      }
      else
      {
        // No AAD, so ciphertext is first
        state = CIPHERTEXT;
        counter = 0;
      }
    }
  }
  else if(state == AAD_STATE)
  {
    // Output up to 128b|16 bytes of AAD this cycle
    // AAD is conveiniently padded to multiple of 16 bytes
    // so always full tkeep, tdata=0 for padding
    for(int32_t i=0; i<16; i+=1)
    {
      if(counter > i){
        o.axis.data.tdata[i] = aad_reg[i];
      }
      o.axis.data.tkeep[i] = 1;
    }
    o.axis.valid = 1;

    // Count AAD bytes as xfer happens
    if(o.axis.valid & ready_for_axis_out)
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
    o.axis = axis_in;
    o.ready_for_axis_in = ready_for_axis_out;
    // last cycle of ciphertext is not the last cycle of output stream
    o.axis.data.tlast = 0;
    // Data needs to be padded to 16 bytes with zeros
    // during cycles with partial tkeep
    for(int32_t i=0; i<16; i+=1)
    {
      o.axis.data.tkeep[i] = 1;
      if(~axis_in.data.tkeep[i]){
        o.axis.data.tdata[i] = 0;
      }
    }

    // Count ciphertext length as xfer happens
    if(axis_in.valid & o.ready_for_axis_in){
      counter += axis128_keep_count(axis_in.data);
      // As last cycle on input ciphertest passes, move to next state
      if(axis_in.data.tlast){
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
      o.axis.data.tdata[pos] = aad_len >> (i*8);
      o.axis.data.tkeep[pos] = 1;
      pos += 1;
    }
    // Ciphertext length
    for(int32_t i=0; i<8; i+=1)
    {
      o.axis.data.tdata[pos] = counter >> (i*8);
      o.axis.data.tkeep[pos] = 1;
      pos += 1;
    }
    // Last cycle of output stream
    o.axis.data.tlast = 1;
    o.axis.valid = 1;

    // As xfer happens, go back to idle
    if(o.axis.valid & ready_for_axis_out)
    {
      state = IDLE;
    }
  }
  return o;
}