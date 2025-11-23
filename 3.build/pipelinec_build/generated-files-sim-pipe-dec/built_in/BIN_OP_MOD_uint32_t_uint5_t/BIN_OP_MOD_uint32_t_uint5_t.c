
#include "uintN_t.h"
#include "bit_manip.h"

// 32b % 5b mod
uint5_t BIN_OP_MOD_uint32_t_uint5_t(uint32_t left, uint5_t right)
{
  // Resize
  uint32_t left_resized;
  left_resized = left;
  uint32_t right_resized;
  right_resized = right;
  
  // Output
  uint32_t output;
  output = 0;
  // Remainder
  uint32_t remainder;
  remainder = 0;
  uint1_t new_remainder0; 
  

  /*
  UNROLL THIS
  remainder := 0
  -- Where n is number of bits in left           
  for i := n - 1 .. 0 do     
    -- Left-shift remainder by 1 bit     
    remainder := remainder << 1
    -- Set the least-significant bit of remainder
    -- equal to bit i of the numerator
    remainder(0) := left(i)       
    if remainder >= right then
      remainder := remainder - right
      output(i) := 1
    end
  end 
  */
  
  // Bit 31
  new_remainder0 = uint32_31_31(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_31(output, 1);
  }
  // Bit 30
  new_remainder0 = uint32_30_30(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_30(output, 1);
  }
  // Bit 29
  new_remainder0 = uint32_29_29(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_29(output, 1);
  }
  // Bit 28
  new_remainder0 = uint32_28_28(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_28(output, 1);
  }
  // Bit 27
  new_remainder0 = uint32_27_27(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_27(output, 1);
  }
  // Bit 26
  new_remainder0 = uint32_26_26(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_26(output, 1);
  }
  // Bit 25
  new_remainder0 = uint32_25_25(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_25(output, 1);
  }
  // Bit 24
  new_remainder0 = uint32_24_24(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_24(output, 1);
  }
  // Bit 23
  new_remainder0 = uint32_23_23(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_23(output, 1);
  }
  // Bit 22
  new_remainder0 = uint32_22_22(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_22(output, 1);
  }
  // Bit 21
  new_remainder0 = uint32_21_21(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_21(output, 1);
  }
  // Bit 20
  new_remainder0 = uint32_20_20(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_20(output, 1);
  }
  // Bit 19
  new_remainder0 = uint32_19_19(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_19(output, 1);
  }
  // Bit 18
  new_remainder0 = uint32_18_18(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_18(output, 1);
  }
  // Bit 17
  new_remainder0 = uint32_17_17(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_17(output, 1);
  }
  // Bit 16
  new_remainder0 = uint32_16_16(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_16(output, 1);
  }
  // Bit 15
  new_remainder0 = uint32_15_15(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_15(output, 1);
  }
  // Bit 14
  new_remainder0 = uint32_14_14(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_14(output, 1);
  }
  // Bit 13
  new_remainder0 = uint32_13_13(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_13(output, 1);
  }
  // Bit 12
  new_remainder0 = uint32_12_12(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_12(output, 1);
  }
  // Bit 11
  new_remainder0 = uint32_11_11(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_11(output, 1);
  }
  // Bit 10
  new_remainder0 = uint32_10_10(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_10(output, 1);
  }
  // Bit 9
  new_remainder0 = uint32_9_9(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_9(output, 1);
  }
  // Bit 8
  new_remainder0 = uint32_8_8(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_8(output, 1);
  }
  // Bit 7
  new_remainder0 = uint32_7_7(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_7(output, 1);
  }
  // Bit 6
  new_remainder0 = uint32_6_6(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_6(output, 1);
  }
  // Bit 5
  new_remainder0 = uint32_5_5(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_5(output, 1);
  }
  // Bit 4
  new_remainder0 = uint32_4_4(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_4(output, 1);
  }
  // Bit 3
  new_remainder0 = uint32_3_3(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_3(output, 1);
  }
  // Bit 2
  new_remainder0 = uint32_2_2(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_2(output, 1);
  }
  // Bit 1
  new_remainder0 = uint32_1_1(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_1(output, 1);
  }
  // Bit 0
  new_remainder0 = uint32_0_0(left);
  remainder = uint32_uint1(remainder, new_remainder0);       
  if(remainder >= right)
  {
    remainder = remainder - right;
    // Set output(i)=1
    output = uint5_uint1_0(output, 1);
  }
  return remainder;
}