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
-- Submodules: 4
entity VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_0CLK_e56a0f0b is
port(
 ref_toks_0 : in uint8_t_144;
 ref_toks_1 : in uint8_t_144;
 var_dim_0 : in unsigned(0 downto 0);
 return_output : out uint8_t_array_144_t);
end VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_0CLK_e56a0f0b;
architecture arch of VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_0CLK_e56a0f0b is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- uint8_t_array_144_t_mux2[VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04]
signal uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_sel : unsigned(0 downto 0);
signal uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in0 : uint8_t_array_144_t;
signal uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in1 : uint8_t_array_144_t;
signal uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_return_output : uint8_t_array_144_t;

function uint1_uint1_0( inp : unsigned;
 x : unsigned) return unsigned is

  --variable inp : unsigned(0 downto 0);
  --variable x : unsigned(0 downto 0);
  variable intermediate : unsigned(0 downto 0);
  variable return_output : unsigned(0 downto 0);

begin

    intermediate := (others => '0');
    intermediate(0 downto 0) := unsigned(inp);
    intermediate(0 downto 0) := x;
    
    return_output := intermediate(0 downto 0) ;
    
    return return_output;

end function;

function CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961( ref_toks_0 : uint8_t_144) return uint8_t_array_144_t is
 
  variable base : uint8_t_array_144_t; 
  variable return_output : uint8_t_array_144_t;
begin
      base.data := ref_toks_0;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04 : 0 clocks latency
uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04 : entity work.uint8_t_array_144_t_mux2_0CLK_23f04728 port map (
uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_sel,
uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in0,
uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in1,
uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 ref_toks_0,
 ref_toks_1,
 var_dim_0,
 -- All submodule outputs
 uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_ref_toks_0 : uint8_t_144;
 variable VAR_ref_toks_1 : uint8_t_144;
 variable VAR_var_dim_0 : unsigned(0 downto 0);
 variable VAR_return_output : uint8_t_array_144_t;
 variable VAR_base : uint8_t_2_144;
 variable VAR_ref_0 : uint8_t_array_144_t;
 variable VAR_ref_1 : uint8_t_array_144_t;
 variable VAR_sel : unsigned(0 downto 0);
 variable VAR_uint1_uint1_0_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l22_c8_0aeb_return_output : unsigned(0 downto 0);
 variable VAR_rv : uint8_t_array_144_t;
 variable VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_sel : unsigned(0 downto 0);
 variable VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in0 : uint8_t_array_144_t;
 variable VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in1 : uint8_t_array_144_t;
 variable VAR_CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l26_c6_432d_return_output : uint8_t_array_144_t;
 variable VAR_CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l27_c6_3e7c_return_output : uint8_t_array_144_t;
 variable VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_return_output : uint8_t_array_144_t;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_ref_toks_0 := ref_toks_0;
     VAR_ref_toks_1 := ref_toks_1;
     VAR_var_dim_0 := var_dim_0;

     -- Submodule level 0
     -- CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961[VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l27_c6_3e7c] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l27_c6_3e7c_return_output := CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961(
     VAR_ref_toks_1);

     -- uint1_uint1_0[VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l22_c8_0aeb] LATENCY=0
     VAR_uint1_uint1_0_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l22_c8_0aeb_return_output := uint1_uint1_0(
     to_unsigned(0, 1),
     VAR_var_dim_0);

     -- CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961[VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l26_c6_432d] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l26_c6_432d_return_output := CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961(
     VAR_ref_toks_0);

     -- Submodule level 1
     VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in0 := VAR_CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l26_c6_432d_return_output;
     VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in1 := VAR_CONST_REF_RD_uint8_t_array_144_t_uint8_t_array_144_t_c961_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l27_c6_3e7c_return_output;
     VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_sel := VAR_uint1_uint1_0_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l22_c8_0aeb_return_output;
     -- uint8_t_array_144_t_mux2[VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04] LATENCY=0
     -- Inputs
     uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_sel <= VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_sel;
     uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in0 <= VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in0;
     uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in1 <= VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_in1;
     -- Outputs
     VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_return_output := uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_return_output;

     -- Submodule level 2
     VAR_return_output := VAR_uint8_t_array_144_t_mux2_VAR_REF_RD_uint8_t_144_uint8_t_2_144_VAR_90b8_c_l25_c7_1f04_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
