#pragma once
#include "uint8_t_array_N_t.h"
#define uint32_t_bytes_t uint8_t_array_4_t
#define uint32_t_SIZE 4
#define uint32_t_size_t uint3_t

#pragma FUNC_WIRES uint32_t_to_bytes
uint32_t_bytes_t uint32_t_to_bytes(uint32_t x)
{
uint32_t_bytes_t rv;
rv.data[0] = uint32_7_0(x);
rv.data[1] = uint32_15_8(x);
rv.data[2] = uint32_23_16(x);
rv.data[3] = uint32_31_24(x);

    return rv;
}

#define UINT32_T_TO_BYTES(dst_byte_array, uint32_t_x)\
uint32_t_bytes_t uint32_t_to_bytes_WIRE = uint32_t_to_bytes(uint32_t_x);\
uint32_t uint32_t_to_bytes_i;\
for(uint32_t_to_bytes_i=0;uint32_t_to_bytes_i<uint32_t_SIZE;uint32_t_to_bytes_i+=1)\
{\
  dst_byte_array[uint32_t_to_bytes_i] = uint32_t_to_bytes_WIRE.data[uint32_t_to_bytes_i];\
}

#pragma FUNC_WIRES bytes_to_uint32_t
uint32_t bytes_to_uint32_t(uint8_t bytes[uint32_t_SIZE])
{
uint32_t rv;
rv = 0;
rv = uint32_uint8_0(rv, bytes[0]);
rv = uint32_uint8_8(rv, bytes[1]);
rv = uint32_uint8_16(rv, bytes[2]);
rv = uint32_uint8_24(rv, bytes[3]);

    return rv;
}