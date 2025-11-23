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
-- Submodules: 1
entity poly1305_pipeline_in_reg_func_0CLK_b45f1687 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 data : in poly1305_mac_loop_body_in_t;
 id : in unsigned(7 downto 0);
 valid : in unsigned(0 downto 0);
 return_output : out poly1305_pipeline_in_reg_t);
end poly1305_pipeline_in_reg_func_0CLK_b45f1687;
architecture arch of poly1305_pipeline_in_reg_func_0CLK_b45f1687 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal the_reg : poly1305_pipeline_in_reg_t := poly1305_pipeline_in_reg_t_NULL;
signal REG_COMB_the_reg : poly1305_pipeline_in_reg_t;

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
function CONST_REF_RD_poly1305_pipeline_in_reg_t_poly1305_pipeline_in_reg_t_30d4( ref_toks_0 : poly1305_mac_loop_body_in_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned) return poly1305_pipeline_in_reg_t is
 
  variable base : poly1305_pipeline_in_reg_t; 
  variable return_output : poly1305_pipeline_in_reg_t;
begin
      base.data := ref_toks_0;
      base.id := ref_toks_1;
      base.valid := ref_toks_2;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 


-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Inputs
 data,
 id,
 valid,
 -- Registers
 the_reg)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : poly1305_pipeline_in_reg_t;
 variable VAR_data : poly1305_mac_loop_body_in_t;
 variable VAR_id : unsigned(7 downto 0);
 variable VAR_valid : unsigned(0 downto 0);
 variable VAR_rv : poly1305_pipeline_in_reg_t;
 variable VAR_the_reg_CONST_REF_RD_poly1305_pipeline_in_reg_t_poly1305_pipeline_in_reg_t_30d4_poly1305_mac_c_l16_c28_5370_return_output : poly1305_pipeline_in_reg_t;
 -- State registers comb logic variables
variable REG_VAR_the_reg : poly1305_pipeline_in_reg_t;
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_the_reg := the_reg;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;
     -- Mux in inputs
     VAR_data := data;
     VAR_id := id;
     VAR_valid := valid;

     -- Submodule level 0
     VAR_return_output := the_reg;
     -- the_reg_CONST_REF_RD_poly1305_pipeline_in_reg_t_poly1305_pipeline_in_reg_t_30d4[poly1305_mac_c_l16_c28_5370] LATENCY=0
     VAR_the_reg_CONST_REF_RD_poly1305_pipeline_in_reg_t_poly1305_pipeline_in_reg_t_30d4_poly1305_mac_c_l16_c28_5370_return_output := CONST_REF_RD_poly1305_pipeline_in_reg_t_poly1305_pipeline_in_reg_t_30d4(
     VAR_data,
     VAR_id,
     VAR_valid);

     -- Submodule level 1
     REG_VAR_the_reg := VAR_the_reg_CONST_REF_RD_poly1305_pipeline_in_reg_t_poly1305_pipeline_in_reg_t_30d4_poly1305_mac_c_l16_c28_5370_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_the_reg <= REG_VAR_the_reg;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     the_reg <= REG_COMB_the_reg;
 end if;
 end if;
end process;

end arch;
