
#include "uintN_t.h"
#include "intN_t.h"
//#include "bit_manip.h"
uint1_t BIN_OP_LT_uint16_t_uint7_t(uint16_t left, uint7_t right)
{

    // Bottom without any extra bits    
    uint7_t left_bot = left;
    uint7_t right_bot = right;
    
  uint9_t top;
  top = left >> 7;
    uint1_t rv;
  if(top==0){
    // Subtractor based compare
    int8_t sub = (int8_t)left_bot - right_bot;
    uint1_t lt_zero = sub(7,7);
    rv = lt_zero;
  }else{
    // Left is large, LT/E is false
    rv = 0;
  }

  return rv;  
}