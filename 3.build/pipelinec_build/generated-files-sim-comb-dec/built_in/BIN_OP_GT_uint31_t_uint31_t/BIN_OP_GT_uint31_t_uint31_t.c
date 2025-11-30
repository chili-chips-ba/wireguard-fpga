
#include "uintN_t.h"
#include "intN_t.h"
//#include "bit_manip.h"
uint1_t BIN_OP_GT_uint31_t_uint31_t(uint31_t left, uint31_t right)
{

    // Bottom without any extra bits    
    uint31_t left_bot = left;
    uint31_t right_bot = right;
    uint1_t rv;

    // Subtractor based compare
    int32_t sub = (int32_t)right_bot - left_bot;
    uint1_t lt_zero = sub(31,31);
    rv = lt_zero;

  return rv;  
}