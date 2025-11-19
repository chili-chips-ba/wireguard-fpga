
#include "uintN_t.h"
#include "intN_t.h"
//#include "bit_manip.h"
uint1_t BIN_OP_GT_uint32_t_uint32_t(uint32_t left, uint32_t right)
{

    // Bottom without any extra bits    
    uint32_t left_bot = left;
    uint32_t right_bot = right;
    uint1_t rv;

    // Subtractor based compare
    int33_t sub = (int33_t)right_bot - left_bot;
    uint1_t lt_zero = sub(32,32);
    rv = lt_zero;

  return rv;  
}