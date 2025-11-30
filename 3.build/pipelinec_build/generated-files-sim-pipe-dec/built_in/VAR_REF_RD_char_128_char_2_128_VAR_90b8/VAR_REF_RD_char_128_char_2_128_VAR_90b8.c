#include "intN_t.h"
#include "uintN_t.h"
#include "bit_math.h"
typedef uint8_t char_array_128_t; // FUCK


// Var ref read
char_array_128_t VAR_REF_RD_char_128_char_2_128_VAR_90b8(char ref_toks_0[128], char ref_toks_1[128], uint1_t var_dim_0)
{
  char base[2][128];
 // Assign ref toks to base
 base[0] = ref_toks_0;
 base[1] = ref_toks_1;
 // Make multiple constant references into base
 char_array_128_t ref_0;
 ref_0.data = base[0];
 char_array_128_t ref_1;
 ref_1.data = base[1];
 // Form select value
 uint1_t sel;
 sel = 0;
 sel = uint1_uint1_0( sel, var_dim_0);
 // Do nmux
 char_array_128_t rv;
 rv = char_array_128_t_mux2(sel,
     ref_0,
     ref_1
 );

  return rv;
}