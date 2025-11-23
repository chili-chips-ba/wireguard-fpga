
#include "uintN_t.h"
#include "intN_t.h"
//#include "bit_manip.h"
uint1_t BIN_OP_GTE_uint64_t_uint64_t(uint64_t left, uint64_t right)
{

    // Bottom without any extra bits    
    uint64_t left_bot = left;
    uint64_t right_bot = right;
    uint1_t rv;

    // Subtractor based compare
    int65_t sub = (int65_t)left_bot - right_bot;
    uint1_t lt_zero = sub(64,64);
    rv = ~lt_zero;

  return rv;  
}