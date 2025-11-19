#pragma once
#include "uint32_t_bytes_t.h"
#include "uint8_t_array_N_t.h"
#define chacha20_state_bytes_t uint8_t_array_64_t
#define chacha20_state_SIZE 64
#define chacha20_state_size_t uint7_t

#pragma FUNC_WIRES chacha20_state_to_bytes
chacha20_state_bytes_t chacha20_state_to_bytes(chacha20_state x)
{
chacha20_state_bytes_t rv;
uint7_t pos = 0;
uint7_t field_pos = 0;
// state
uint5_t state_dim_0;
for(state_dim_0=0;state_dim_0<16;state_dim_0=state_dim_0+1){
 uint32_t_bytes_t state_elem_bytes = uint32_t_to_bytes(x.state[state_dim_0]);
 for(field_pos=0;field_pos<sizeof(uint32_t);field_pos = field_pos + 1)
  {
    rv.data[pos] = state_elem_bytes.data[field_pos];
    pos = pos + 1;
  }
}

    return rv;
}

#define CHACHA20_STATE_TO_BYTES(dst_byte_array, chacha20_state_x)\
chacha20_state_bytes_t chacha20_state_to_bytes_WIRE = chacha20_state_to_bytes(chacha20_state_x);\
uint32_t chacha20_state_to_bytes_i;\
for(chacha20_state_to_bytes_i=0;chacha20_state_to_bytes_i<chacha20_state_SIZE;chacha20_state_to_bytes_i+=1)\
{\
  dst_byte_array[chacha20_state_to_bytes_i] = chacha20_state_to_bytes_WIRE.data[chacha20_state_to_bytes_i];\
}

#pragma FUNC_WIRES bytes_to_chacha20_state
chacha20_state bytes_to_chacha20_state(uint8_t bytes[chacha20_state_SIZE])
{
chacha20_state rv;
uint7_t pos = 0;
uint7_t field_pos = 0;
// state
uint5_t state_dim_0;
for(state_dim_0=0;state_dim_0<16;state_dim_0=state_dim_0+1){
 uint32_t_bytes_t state_elem_bytes;
 for(field_pos=0;field_pos<sizeof(uint32_t);field_pos = field_pos + 1)
  {
    state_elem_bytes.data[field_pos] = bytes[pos];
    pos = pos + 1;
  }
 rv.state[state_dim_0] = bytes_to_uint32_t(state_elem_bytes);
}

    return rv;
}