
#include "intN_t.h"
#include "uintN_t.h"
#include "bit_math.h"
typedef uint8_t chacha20_state; // FUCK
typedef uint8_t uint32_t_array_16_t; // FUCK
typedef uint8_t chacha20_state; // FUCK

// Var ref assignment
uint32_t_array_16_t VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da(uint32_t elem_val, chacha20_state ref_toks_0, uint4_t var_dim_0)
{
  chacha20_state base;
 // Assign ref toks to base
 base = ref_toks_0;
 // Copy base into rv
 uint32_t_array_16_t rv;
 rv.data[3] = base.state[3];
 rv.data[6] = base.state[6];
 rv.data[12] = base.state[12];
 rv.data[9] = base.state[9];
 rv.data[15] = base.state[15];
 rv.data[1] = base.state[1];
 rv.data[7] = base.state[7];
 rv.data[4] = base.state[4];
 rv.data[10] = base.state[10];
 rv.data[13] = base.state[13];
 rv.data[5] = base.state[5];
 rv.data[2] = base.state[2];
 rv.data[8] = base.state[8];
 rv.data[14] = base.state[14];
 rv.data[11] = base.state[11];
 rv.data[0] = base.state[0];
 // Do mux for each element
 if(
   (var_dim_0 == 3) 
 )
 {
   rv.data[3] = elem_val;
 }
 if(
   (var_dim_0 == 6) 
 )
 {
   rv.data[6] = elem_val;
 }
 if(
   (var_dim_0 == 12) 
 )
 {
   rv.data[12] = elem_val;
 }
 if(
   (var_dim_0 == 9) 
 )
 {
   rv.data[9] = elem_val;
 }
 if(
   (var_dim_0 == 15) 
 )
 {
   rv.data[15] = elem_val;
 }
 if(
   (var_dim_0 == 1) 
 )
 {
   rv.data[1] = elem_val;
 }
 if(
   (var_dim_0 == 7) 
 )
 {
   rv.data[7] = elem_val;
 }
 if(
   (var_dim_0 == 4) 
 )
 {
   rv.data[4] = elem_val;
 }
 if(
   (var_dim_0 == 10) 
 )
 {
   rv.data[10] = elem_val;
 }
 if(
   (var_dim_0 == 13) 
 )
 {
   rv.data[13] = elem_val;
 }
 if(
   (var_dim_0 == 5) 
 )
 {
   rv.data[5] = elem_val;
 }
 if(
   (var_dim_0 == 2) 
 )
 {
   rv.data[2] = elem_val;
 }
 if(
   (var_dim_0 == 8) 
 )
 {
   rv.data[8] = elem_val;
 }
 if(
   (var_dim_0 == 14) 
 )
 {
   rv.data[14] = elem_val;
 }
 if(
   (var_dim_0 == 11) 
 )
 {
   rv.data[11] = elem_val;
 }
 if(
   (var_dim_0 == 0) 
 )
 {
   rv.data[0] = elem_val;
 }

  return rv;
}