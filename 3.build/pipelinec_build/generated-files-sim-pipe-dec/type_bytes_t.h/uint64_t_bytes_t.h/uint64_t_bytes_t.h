#pragma once
#include "uint8_t_array_N_t.h"
#define uint64_t_bytes_t uint8_t_array_8_t
#define uint64_t_SIZE 8
#define uint64_t_size_t uint4_t

#pragma FUNC_WIRES uint64_t_to_bytes
uint64_t_bytes_t uint64_t_to_bytes(uint64_t x)
{
uint64_t_bytes_t rv;
rv.data[0] = uint64_7_0(x);
rv.data[1] = uint64_15_8(x);
rv.data[2] = uint64_23_16(x);
rv.data[3] = uint64_31_24(x);
rv.data[4] = uint64_39_32(x);
rv.data[5] = uint64_47_40(x);
rv.data[6] = uint64_55_48(x);
rv.data[7] = uint64_63_56(x);

    return rv;
}

#define UINT64_T_TO_BYTES(dst_byte_array, uint64_t_x)\
uint64_t_bytes_t uint64_t_to_bytes_WIRE = uint64_t_to_bytes(uint64_t_x);\
uint32_t uint64_t_to_bytes_i;\
for(uint64_t_to_bytes_i=0;uint64_t_to_bytes_i<uint64_t_SIZE;uint64_t_to_bytes_i+=1)\
{\
  dst_byte_array[uint64_t_to_bytes_i] = uint64_t_to_bytes_WIRE.data[uint64_t_to_bytes_i];\
}

#pragma FUNC_WIRES bytes_to_uint64_t
uint64_t bytes_to_uint64_t(uint8_t bytes[uint64_t_SIZE])
{
uint64_t rv;
rv = 0;
rv = uint64_uint8_0(rv, bytes[0]);
rv = uint64_uint8_8(rv, bytes[1]);
rv = uint64_uint8_16(rv, bytes[2]);
rv = uint64_uint8_24(rv, bytes[3]);
rv = uint64_uint8_32(rv, bytes[4]);
rv = uint64_uint8_40(rv, bytes[5]);
rv = uint64_uint8_48(rv, bytes[6]);
rv = uint64_uint8_56(rv, bytes[7]);

    return rv;
}