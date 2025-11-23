
#include "uintN_t.h"
#include "intN_t.h"
//#include "bit_manip.h"
uint1_t BIN_OP_LT_uint32_t_uint2_t(uint32_t left, uint2_t right)
{

    // Bottom without any extra bits    
    uint2_t left_bot = left;
    uint2_t right_bot = right;
    
  uint30_t top;
  top = left >> 2;
    uint1_t rv;
  if(top==0){
    // Subtractor based compare
    int3_t sub = (int3_t)left_bot - right_bot;
    uint1_t lt_zero = sub(2,2);
    rv = lt_zero;
  }else{
    // Left is large, LT/E is false
    rv = 0;
  }

  return rv;  
}