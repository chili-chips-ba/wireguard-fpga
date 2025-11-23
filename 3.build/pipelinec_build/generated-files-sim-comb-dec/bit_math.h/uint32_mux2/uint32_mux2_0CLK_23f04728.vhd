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
entity uint32_mux2_0CLK_23f04728 is
port(
 sel : in unsigned(0 downto 0);
 in0 : in unsigned(31 downto 0);
 in1 : in unsigned(31 downto 0);
 return_output : out unsigned(31 downto 0));
end uint32_mux2_0CLK_23f04728;
architecture arch of uint32_mux2_0CLK_23f04728 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- layer0_node0_MUX[bit_math_h_l18_c3_8356]
signal layer0_node0_MUX_bit_math_h_l18_c3_8356_cond : unsigned(0 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_8356_iftrue : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_8356_iffalse : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_8356_return_output : unsigned(31 downto 0);

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
-- layer0_node0_MUX_bit_math_h_l18_c3_8356 : 0 clocks latency
layer0_node0_MUX_bit_math_h_l18_c3_8356 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node0_MUX_bit_math_h_l18_c3_8356_cond,
layer0_node0_MUX_bit_math_h_l18_c3_8356_iftrue,
layer0_node0_MUX_bit_math_h_l18_c3_8356_iffalse,
layer0_node0_MUX_bit_math_h_l18_c3_8356_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 sel,
 in0,
 in1,
 -- All submodule outputs
 layer0_node0_MUX_bit_math_h_l18_c3_8356_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : unsigned(31 downto 0);
 variable VAR_sel : unsigned(0 downto 0);
 variable VAR_in0 : unsigned(31 downto 0);
 variable VAR_in1 : unsigned(31 downto 0);
 variable VAR_sel0 : unsigned(0 downto 0);
 variable VAR_uint1_0_0_bit_math_h_l14_c10_d9e2_return_output : unsigned(0 downto 0);
 variable VAR_layer0_node0 : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_cond : unsigned(0 downto 0);
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
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_iffalse := VAR_in0;
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_iftrue := VAR_in1;
     -- uint1_0_0[bit_math_h_l14_c10_d9e2] LATENCY=0
     VAR_uint1_0_0_bit_math_h_l14_c10_d9e2_return_output := uint1_0_0(
     VAR_sel);

     -- Submodule level 1
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_cond := VAR_uint1_0_0_bit_math_h_l14_c10_d9e2_return_output;
     -- layer0_node0_MUX[bit_math_h_l18_c3_8356] LATENCY=0
     -- Inputs
     layer0_node0_MUX_bit_math_h_l18_c3_8356_cond <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_cond;
     layer0_node0_MUX_bit_math_h_l18_c3_8356_iftrue <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_iftrue;
     layer0_node0_MUX_bit_math_h_l18_c3_8356_iffalse <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_iffalse;
     -- Outputs
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_return_output := layer0_node0_MUX_bit_math_h_l18_c3_8356_return_output;

     -- Submodule level 2
     VAR_return_output := VAR_layer0_node0_MUX_bit_math_h_l18_c3_8356_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
