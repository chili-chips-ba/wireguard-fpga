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
entity VAR_REF_RD_char_128_char_2_128_VAR_90b8_0CLK_b45a16e1 is
port(
 ref_toks_0 : in char_128;
 ref_toks_1 : in char_128;
 var_dim_0 : in unsigned(0 downto 0);
 return_output : out char_array_128_t);
end VAR_REF_RD_char_128_char_2_128_VAR_90b8_0CLK_b45a16e1;
architecture arch of VAR_REF_RD_char_128_char_2_128_VAR_90b8_0CLK_b45a16e1 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- char_array_128_t_mux2[VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd]
signal char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_sel : unsigned(0 downto 0);
signal char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in0 : char_array_128_t;
signal char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in1 : char_array_128_t;
signal char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_return_output : char_array_128_t;

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

function CONST_REF_RD_char_array_128_t_char_array_128_t_c961( ref_toks_0 : char_128) return char_array_128_t is
 
  variable base : char_array_128_t; 
  variable return_output : char_array_128_t;
begin
      base.data := ref_toks_0;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd : 0 clocks latency
char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd : entity work.char_array_128_t_mux2_0CLK_23f04728 port map (
char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_sel,
char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in0,
char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in1,
char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 ref_toks_0,
 ref_toks_1,
 var_dim_0,
 -- All submodule outputs
 char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_ref_toks_0 : char_128;
 variable VAR_ref_toks_1 : char_128;
 variable VAR_var_dim_0 : unsigned(0 downto 0);
 variable VAR_return_output : char_array_128_t;
 variable VAR_base : char_2_128;
 variable VAR_ref_0 : char_array_128_t;
 variable VAR_ref_1 : char_array_128_t;
 variable VAR_sel : unsigned(0 downto 0);
 variable VAR_uint1_uint1_0_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l22_c8_f398_return_output : unsigned(0 downto 0);
 variable VAR_rv : char_array_128_t;
 variable VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_sel : unsigned(0 downto 0);
 variable VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in0 : char_array_128_t;
 variable VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in1 : char_array_128_t;
 variable VAR_CONST_REF_RD_char_array_128_t_char_array_128_t_c961_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l26_c6_8465_return_output : char_array_128_t;
 variable VAR_CONST_REF_RD_char_array_128_t_char_array_128_t_c961_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l27_c6_37c5_return_output : char_array_128_t;
 variable VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_return_output : char_array_128_t;
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
     -- CONST_REF_RD_char_array_128_t_char_array_128_t_c961[VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l26_c6_8465] LATENCY=0
     VAR_CONST_REF_RD_char_array_128_t_char_array_128_t_c961_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l26_c6_8465_return_output := CONST_REF_RD_char_array_128_t_char_array_128_t_c961(
     VAR_ref_toks_0);

     -- CONST_REF_RD_char_array_128_t_char_array_128_t_c961[VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l27_c6_37c5] LATENCY=0
     VAR_CONST_REF_RD_char_array_128_t_char_array_128_t_c961_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l27_c6_37c5_return_output := CONST_REF_RD_char_array_128_t_char_array_128_t_c961(
     VAR_ref_toks_1);

     -- uint1_uint1_0[VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l22_c8_f398] LATENCY=0
     VAR_uint1_uint1_0_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l22_c8_f398_return_output := uint1_uint1_0(
     to_unsigned(0, 1),
     VAR_var_dim_0);

     -- Submodule level 1
     VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in0 := VAR_CONST_REF_RD_char_array_128_t_char_array_128_t_c961_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l26_c6_8465_return_output;
     VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in1 := VAR_CONST_REF_RD_char_array_128_t_char_array_128_t_c961_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l27_c6_37c5_return_output;
     VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_sel := VAR_uint1_uint1_0_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l22_c8_f398_return_output;
     -- char_array_128_t_mux2[VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd] LATENCY=0
     -- Inputs
     char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_sel <= VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_sel;
     char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in0 <= VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in0;
     char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in1 <= VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_in1;
     -- Outputs
     VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_return_output := char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_return_output;

     -- Submodule level 2
     VAR_return_output := VAR_char_array_128_t_mux2_VAR_REF_RD_char_128_char_2_128_VAR_90b8_c_l25_c7_31cd_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
