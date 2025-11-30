#include "intN_t.h"
#include "uintN_t.h"
#include "bit_math.h"


// Var ref read
uint32_t VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8(uint32_t ref_toks_0, uint32_t ref_toks_1, uint1_t var_dim_0)
{
  uint32_t base[2];
 // Assign ref toks to base
 base[0] = ref_toks_0;
 base[1] = ref_toks_1;
 // Make multiple constant references into base
 uint32_t ref_0;
 ref_0 = base[0];
 uint32_t ref_1;
 ref_1 = base[1];
 // Form select value
 uint1_t sel;
 sel = 0;
 sel = uint1_uint1_0( sel, var_dim_0);
 // Do nmux
 uint32_t rv;
 rv = uint32_mux2(sel,
     ref_0,
     ref_1
 );

  return rv;
}