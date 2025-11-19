#include "intN_t.h"
#include "uintN_t.h"
#include "bit_math.h"
typedef uint8_t chacha20_state; // FUCK
typedef uint8_t chacha20_state; // FUCK


// Var ref read
uint32_t VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d(chacha20_state ref_toks_0, uint4_t var_dim_0)
{
  chacha20_state base;
 // Assign ref toks to base
 base = ref_toks_0;
 // Make multiple constant references into base
 uint32_t ref_0;
 ref_0 = base.state[0];
 uint32_t ref_1;
 ref_1 = base.state[1];
 uint32_t ref_2;
 ref_2 = base.state[2];
 uint32_t ref_3;
 ref_3 = base.state[3];
 uint32_t ref_4;
 ref_4 = base.state[4];
 uint32_t ref_5;
 ref_5 = base.state[5];
 uint32_t ref_6;
 ref_6 = base.state[6];
 uint32_t ref_7;
 ref_7 = base.state[7];
 uint32_t ref_8;
 ref_8 = base.state[8];
 uint32_t ref_9;
 ref_9 = base.state[9];
 uint32_t ref_10;
 ref_10 = base.state[10];
 uint32_t ref_11;
 ref_11 = base.state[11];
 uint32_t ref_12;
 ref_12 = base.state[12];
 uint32_t ref_13;
 ref_13 = base.state[13];
 uint32_t ref_14;
 ref_14 = base.state[14];
 uint32_t ref_15;
 ref_15 = base.state[15];
 // Form select value
 uint4_t sel;
 sel = 0;
 sel = uint4_uint4_0( sel, var_dim_0);
 // Do nmux
 uint32_t rv;
 rv = uint32_mux16(sel,
     ref_0,
     ref_1,
     ref_2,
     ref_3,
     ref_4,
     ref_5,
     ref_6,
     ref_7,
     ref_8,
     ref_9,
     ref_10,
     ref_11,
     ref_12,
     ref_13,
     ref_14,
     ref_15
 );

  return rv;
}