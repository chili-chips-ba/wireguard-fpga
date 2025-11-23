#pragma once
#define uint32_t_SIZE 4

void uint32_t_to_bytes(uint32_t* x, uint8_t* bytes)
{
bytes[0] = (uint8_t)(*x>>0);
bytes[1] = (uint8_t)(*x>>8);
bytes[2] = (uint8_t)(*x>>16);
bytes[3] = (uint8_t)(*x>>24);

}

void bytes_to_uint32_t(uint8_t* bytes, uint32_t* x)
{
*x = 0;
*x |= (((uint32_t)bytes[0])<<0);
*x |= (((uint32_t)bytes[1])<<8);
*x |= (((uint32_t)bytes[2])<<16);
*x |= (((uint32_t)bytes[3])<<24);

}
