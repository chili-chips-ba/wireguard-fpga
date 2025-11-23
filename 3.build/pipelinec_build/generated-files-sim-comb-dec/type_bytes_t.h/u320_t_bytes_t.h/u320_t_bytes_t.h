#pragma once
#include "uint64_t_bytes_t.h"
#include "uint8_t_array_N_t.h"
#define u320_t_bytes_t uint8_t_array_40_t
#define u320_t_SIZE 40
#define u320_t_size_t uint7_t

#pragma FUNC_WIRES u320_t_to_bytes
u320_t_bytes_t u320_t_to_bytes(u320_t x)
{
u320_t_bytes_t rv;
uint7_t pos = 0;
uint7_t field_pos = 0;
// limbs
uint3_t limbs_dim_0;
for(limbs_dim_0=0;limbs_dim_0<5;limbs_dim_0=limbs_dim_0+1){
 uint64_t_bytes_t limbs_elem_bytes = uint64_t_to_bytes(x.limbs[limbs_dim_0]);
 for(field_pos=0;field_pos<sizeof(uint64_t);field_pos = field_pos + 1)
  {
    rv.data[pos] = limbs_elem_bytes.data[field_pos];
    pos = pos + 1;
  }
}

    return rv;
}

#define U320_T_TO_BYTES(dst_byte_array, u320_t_x)\
u320_t_bytes_t u320_t_to_bytes_WIRE = u320_t_to_bytes(u320_t_x);\
uint32_t u320_t_to_bytes_i;\
for(u320_t_to_bytes_i=0;u320_t_to_bytes_i<u320_t_SIZE;u320_t_to_bytes_i+=1)\
{\
  dst_byte_array[u320_t_to_bytes_i] = u320_t_to_bytes_WIRE.data[u320_t_to_bytes_i];\
}

#pragma FUNC_WIRES bytes_to_u320_t
u320_t bytes_to_u320_t(uint8_t bytes[u320_t_SIZE])
{
u320_t rv;
uint7_t pos = 0;
uint7_t field_pos = 0;
// limbs
uint3_t limbs_dim_0;
for(limbs_dim_0=0;limbs_dim_0<5;limbs_dim_0=limbs_dim_0+1){
 uint64_t_bytes_t limbs_elem_bytes;
 for(field_pos=0;field_pos<sizeof(uint64_t);field_pos = field_pos + 1)
  {
    limbs_elem_bytes.data[field_pos] = bytes[pos];
    pos = pos + 1;
  }
 rv.limbs[limbs_dim_0] = bytes_to_uint64_t(limbs_elem_bytes);
}

    return rv;
}