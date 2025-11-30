
#include "uintN_t.h"
#include "intN_t.h"
//#include "bit_manip.h"
uint1_t BIN_OP_GT_uint8_t_uint1_t(uint8_t left, uint1_t right)
{

    // Bottom without any extra bits    
    uint1_t left_bot = left;
    uint1_t right_bot = right;
    
  uint7_t top;
  top = left >> 1;
    uint1_t rv;
  if(top==0){
    // Subtractor based compare
    int2_t sub = (int2_t)right_bot - left_bot;
    uint1_t lt_zero = sub(1,1);
    rv = lt_zero;
  }else{
    // Left is large, GT/E is true
    rv = 1;
  }

  return rv;  
}