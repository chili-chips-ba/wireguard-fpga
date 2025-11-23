#pragma once
#include "type_bytes_t.h/uint64_t_bytes_t.h/uint64_t_bytes.h"
#define u320_t_SIZE 40

void u320_t_to_bytes(u320_t* x, uint8_t* bytes)
{
size_t pos = 0;
// limbs
size_t limbs_dim_0;
for(limbs_dim_0=0;limbs_dim_0<5;limbs_dim_0=limbs_dim_0+1){
 uint64_t_to_bytes(&(x->limbs[limbs_dim_0]), &(bytes[pos]));
 pos = pos + 8; // not sizeof()
}

}

void bytes_to_u320_t(uint8_t* bytes, u320_t* x)
{
size_t pos = 0;
// limbs
size_t limbs_dim_0;
for(limbs_dim_0=0;limbs_dim_0<5;limbs_dim_0=limbs_dim_0+1){
 bytes_to_uint64_t(&(bytes[pos]), &(x->limbs[limbs_dim_0]));
 pos = pos + 8; // not sizeof()
}

}
