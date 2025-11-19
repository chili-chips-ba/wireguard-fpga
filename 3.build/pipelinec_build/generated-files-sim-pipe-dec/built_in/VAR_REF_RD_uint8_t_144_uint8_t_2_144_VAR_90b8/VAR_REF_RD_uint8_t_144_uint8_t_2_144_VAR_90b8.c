#include "intN_t.h"
#include "uintN_t.h"
#include "bit_math.h"
typedef uint8_t uint8_t_array_144_t; // FUCK


// Var ref read
uint8_t_array_144_t VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8(uint8_t ref_toks_0[144], uint8_t ref_toks_1[144], uint1_t var_dim_0)
{
  uint8_t base[2][144];
 // Assign ref toks to base
 base[0] = ref_toks_0;
 base[1] = ref_toks_1;
 // Make multiple constant references into base
 uint8_t_array_144_t ref_0;
 ref_0.data = base[0];
 uint8_t_array_144_t ref_1;
 ref_1.data = base[1];
 // Form select value
 uint1_t sel;
 sel = 0;
 sel = uint1_uint1_0( sel, var_dim_0);
 // Do nmux
 uint8_t_array_144_t rv;
 rv = uint8_t_array_144_t_mux2(sel,
     ref_0,
     ref_1
 );

  return rv;
}