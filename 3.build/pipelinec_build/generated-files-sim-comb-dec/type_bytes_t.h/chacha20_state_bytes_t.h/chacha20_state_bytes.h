#pragma once
#include "type_bytes_t.h/uint32_t_bytes_t.h/uint32_t_bytes.h"
#define chacha20_state_SIZE 64

void chacha20_state_to_bytes(chacha20_state* x, uint8_t* bytes)
{
size_t pos = 0;
// state
size_t state_dim_0;
for(state_dim_0=0;state_dim_0<16;state_dim_0=state_dim_0+1){
 uint32_t_to_bytes(&(x->state[state_dim_0]), &(bytes[pos]));
 pos = pos + 4; // not sizeof()
}

}

void bytes_to_chacha20_state(uint8_t* bytes, chacha20_state* x)
{
size_t pos = 0;
// state
size_t state_dim_0;
for(state_dim_0=0;state_dim_0<16;state_dim_0=state_dim_0+1){
 bytes_to_uint32_t(&(bytes[pos]), &(x->state[state_dim_0]));
 pos = pos + 4; // not sizeof()
}

}
