
#include "uintN_t.h"
#include "intN_t.h"
//#include "bit_manip.h"
uint1_t BIN_OP_GT_uint16_t_uint16_t(uint16_t left, uint16_t right)
{

    // Bottom without any extra bits    
    uint16_t left_bot = left;
    uint16_t right_bot = right;
    uint1_t rv;

    // Subtractor based compare
    int17_t sub = (int17_t)right_bot - left_bot;
    uint1_t lt_zero = sub(16,16);
    rv = lt_zero;

  return rv;  
}