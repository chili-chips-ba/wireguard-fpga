-- Timing params:
--   Fixed?: False
--   Pipeline Slices: []
--   Input regs?: False
--   Output regs?: False
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.c_structs_pkg.all;
-- Submodules: 2
entity char_array_128_t_mux2_0CLK_23f04728 is
port(
 sel : in unsigned(0 downto 0);
 in0 : in char_array_128_t;
 in1 : in char_array_128_t;
 return_output : out char_array_128_t);
end char_array_128_t_mux2_0CLK_23f04728;
architecture arch of char_array_128_t_mux2_0CLK_23f04728 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- layer0_node0_MUX[bit_math_h_l20_c3_e77b]
signal layer0_node0_MUX_bit_math_h_l20_c3_e77b_cond : unsigned(0 downto 0);
signal layer0_node0_MUX_bit_math_h_l20_c3_e77b_iftrue : char_array_128_t;
signal layer0_node0_MUX_bit_math_h_l20_c3_e77b_iffalse : char_array_128_t;
signal layer0_node0_MUX_bit_math_h_l20_c3_e77b_return_output : char_array_128_t;

function uint1_0_0( x : unsigned) return unsigned is
--variable x : unsigned(0 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(0- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- layer0_node0_MUX_bit_math_h_l20_c3_e77b : 0 clocks latency
layer0_node0_MUX_bit_math_h_l20_c3_e77b : entity work.MUX_uint1_t_char_array_128_t_char_array_128_t_0CLK_de264c78 port map (
layer0_node0_MUX_bit_math_h_l20_c3_e77b_cond,
layer0_node0_MUX_bit_math_h_l20_c3_e77b_iftrue,
layer0_node0_MUX_bit_math_h_l20_c3_e77b_iffalse,
layer0_node0_MUX_bit_math_h_l20_c3_e77b_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 sel,
 in0,
 in1,
 -- All submodule outputs
 layer0_node0_MUX_bit_math_h_l20_c3_e77b_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : char_array_128_t;
 variable VAR_sel : unsigned(0 downto 0);
 variable VAR_in0 : char_array_128_t;
 variable VAR_in1 : char_array_128_t;
 variable VAR_sel0 : unsigned(0 downto 0);
 variable VAR_uint1_0_0_bit_math_h_l16_c10_3495_return_output : unsigned(0 downto 0);
 variable VAR_layer0_node0 : char_array_128_t;
 variable VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_iftrue : char_array_128_t;
 variable VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_iffalse : char_array_128_t;
 variable VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_return_output : char_array_128_t;
 variable VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_cond : unsigned(0 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_sel := sel;
     VAR_in0 := in0;
     VAR_in1 := in1;

     -- Submodule level 0
     VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_iffalse := VAR_in0;
     VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_iftrue := VAR_in1;
     -- uint1_0_0[bit_math_h_l16_c10_3495] LATENCY=0
     VAR_uint1_0_0_bit_math_h_l16_c10_3495_return_output := uint1_0_0(
     VAR_sel);

     -- Submodule level 1
     VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_cond := VAR_uint1_0_0_bit_math_h_l16_c10_3495_return_output;
     -- layer0_node0_MUX[bit_math_h_l20_c3_e77b] LATENCY=0
     -- Inputs
     layer0_node0_MUX_bit_math_h_l20_c3_e77b_cond <= VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_cond;
     layer0_node0_MUX_bit_math_h_l20_c3_e77b_iftrue <= VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_iftrue;
     layer0_node0_MUX_bit_math_h_l20_c3_e77b_iffalse <= VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_iffalse;
     -- Outputs
     VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_return_output := layer0_node0_MUX_bit_math_h_l20_c3_e77b_return_output;

     -- Submodule level 2
     VAR_return_output := VAR_layer0_node0_MUX_bit_math_h_l20_c3_e77b_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
