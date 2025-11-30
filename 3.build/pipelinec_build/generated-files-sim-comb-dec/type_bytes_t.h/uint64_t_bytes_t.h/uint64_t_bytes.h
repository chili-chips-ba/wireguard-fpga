#pragma once
#define uint64_t_SIZE 8

void uint64_t_to_bytes(uint64_t* x, uint8_t* bytes)
{
bytes[0] = (uint8_t)(*x>>0);
bytes[1] = (uint8_t)(*x>>8);
bytes[2] = (uint8_t)(*x>>16);
bytes[3] = (uint8_t)(*x>>24);
bytes[4] = (uint8_t)(*x>>32);
bytes[5] = (uint8_t)(*x>>40);
bytes[6] = (uint8_t)(*x>>48);
bytes[7] = (uint8_t)(*x>>56);

}

void bytes_to_uint64_t(uint8_t* bytes, uint64_t* x)
{
*x = 0;
*x |= (((uint64_t)bytes[0])<<0);
*x |= (((uint64_t)bytes[1])<<8);
*x |= (((uint64_t)bytes[2])<<16);
*x |= (((uint64_t)bytes[3])<<24);
*x |= (((uint64_t)bytes[4])<<32);
*x |= (((uint64_t)bytes[5])<<40);
*x |= (((uint64_t)bytes[6])<<48);
*x |= (((uint64_t)bytes[7])<<56);

}
