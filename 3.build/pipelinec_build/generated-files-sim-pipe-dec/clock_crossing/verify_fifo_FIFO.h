#pragma once
#include "uintN_t.h"
#define verify_fifo_FIFO_RATIO 1
typedef struct verify_fifo_FIFO_write_t
{
uint1_t ready;
}verify_fifo_FIFO_write_t;
typedef struct verify_fifo_FIFO_read_t
{
axis128_t data[1];
uint1_t valid;
}verify_fifo_FIFO_read_t;

// Clock cross write
verify_fifo_FIFO_write_t verify_fifo_FIFO_WRITE_1(axis128_t write_data[1], uint1_t write_enable)
{
  // TODO
}

// Clock cross read
verify_fifo_FIFO_read_t verify_fifo_FIFO_READ_1(uint1_t read_enable)
{
  // TODO
}
