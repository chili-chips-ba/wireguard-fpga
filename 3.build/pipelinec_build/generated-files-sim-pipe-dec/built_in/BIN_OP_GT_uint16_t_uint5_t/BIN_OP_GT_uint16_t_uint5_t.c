
#include "uintN_t.h"
#include "intN_t.h"
//#include "bit_manip.h"
uint1_t BIN_OP_GT_uint16_t_uint5_t(uint16_t left, uint5_t right)
{

    // Bottom without any extra bits    
    uint5_t left_bot = left;
    uint5_t right_bot = right;
    
  uint11_t top;
  top = left >> 5;
    uint1_t rv;
  if(top==0){
    // Subtractor based compare
    int6_t sub = (int6_t)right_bot - left_bot;
    uint1_t lt_zero = sub(5,5);
    rv = lt_zero;
  }else{
    // Left is large, GT/E is true
    rv = 1;
  }

  return rv;  
}