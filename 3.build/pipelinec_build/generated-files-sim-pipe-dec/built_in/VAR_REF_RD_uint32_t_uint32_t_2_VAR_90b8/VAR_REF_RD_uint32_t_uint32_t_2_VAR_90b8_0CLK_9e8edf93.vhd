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
entity VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_0CLK_9e8edf93 is
port(
 ref_toks_0 : in unsigned(31 downto 0);
 ref_toks_1 : in unsigned(31 downto 0);
 var_dim_0 : in unsigned(0 downto 0);
 return_output : out unsigned(31 downto 0));
end VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_0CLK_9e8edf93;
architecture arch of VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_0CLK_9e8edf93 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- uint32_mux2[VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113]
signal uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_sel : unsigned(0 downto 0);
signal uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in0 : unsigned(31 downto 0);
signal uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in1 : unsigned(31 downto 0);
signal uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_return_output : unsigned(31 downto 0);

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


begin

-- SUBMODULE INSTANCES 
-- uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113 : 0 clocks latency
uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113 : entity work.uint32_mux2_0CLK_23f04728 port map (
uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_sel,
uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in0,
uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in1,
uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 ref_toks_0,
 ref_toks_1,
 var_dim_0,
 -- All submodule outputs
 uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_ref_toks_0 : unsigned(31 downto 0);
 variable VAR_ref_toks_1 : unsigned(31 downto 0);
 variable VAR_var_dim_0 : unsigned(0 downto 0);
 variable VAR_return_output : unsigned(31 downto 0);
 variable VAR_base : uint32_t_2;
 variable VAR_ref_0 : unsigned(31 downto 0);
 variable VAR_ref_1 : unsigned(31 downto 0);
 variable VAR_sel : unsigned(0 downto 0);
 variable VAR_uint1_uint1_0_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l21_c8_57bc_return_output : unsigned(0 downto 0);
 variable VAR_rv : unsigned(31 downto 0);
 variable VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_sel : unsigned(0 downto 0);
 variable VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in0 : unsigned(31 downto 0);
 variable VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in1 : unsigned(31 downto 0);
 variable VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_return_output : unsigned(31 downto 0);
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
     VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in0 := VAR_ref_toks_0;
     VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in1 := VAR_ref_toks_1;
     -- uint1_uint1_0[VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l21_c8_57bc] LATENCY=0
     VAR_uint1_uint1_0_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l21_c8_57bc_return_output := uint1_uint1_0(
     to_unsigned(0, 1),
     VAR_var_dim_0);

     -- Submodule level 1
     VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_sel := VAR_uint1_uint1_0_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l21_c8_57bc_return_output;
     -- uint32_mux2[VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113] LATENCY=0
     -- Inputs
     uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_sel <= VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_sel;
     uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in0 <= VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in0;
     uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in1 <= VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_in1;
     -- Outputs
     VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_return_output := uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_return_output;

     -- Submodule level 2
     VAR_return_output := VAR_uint32_mux2_VAR_REF_RD_uint32_t_uint32_t_2_VAR_90b8_c_l24_c7_c113_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
