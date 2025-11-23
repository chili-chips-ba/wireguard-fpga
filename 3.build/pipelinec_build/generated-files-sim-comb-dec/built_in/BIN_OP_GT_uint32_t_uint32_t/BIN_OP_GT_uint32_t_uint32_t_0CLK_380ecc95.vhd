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
-- Submodules: 3
entity BIN_OP_GT_uint32_t_uint32_t_0CLK_380ecc95 is
port(
 left : in unsigned(31 downto 0);
 right : in unsigned(31 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_GT_uint32_t_uint32_t_0CLK_380ecc95;
architecture arch of BIN_OP_GT_uint32_t_uint32_t_0CLK_380ecc95 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- BIN_OP_MINUS[BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010]
signal BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_left : signed(32 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_right : signed(32 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_return_output : signed(33 downto 0);

function CAST_TO_int33_t_uint32_t( rhs : unsigned) return signed is

  --variable rhs : unsigned(31 downto 0);
  variable return_output : signed(32 downto 0);

begin

      return_output := signed(std_logic_vector(resize(rhs,33)));
    return return_output;
end function;

function int33_32_32( x : signed) return unsigned is
--variable x : signed(32 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(32- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010 : entity work.BIN_OP_MINUS_int33_t_int33_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_left,
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_right,
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(31 downto 0);
 variable VAR_right : unsigned(31 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_left_bot : unsigned(31 downto 0);
 variable VAR_left_bot_BIN_OP_GT_uint32_t_uint32_t_c_l9_c14_c9a4_0 : unsigned(31 downto 0);
 variable VAR_right_bot : unsigned(31 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_sub : signed(32 downto 0);
 variable VAR_sub_BIN_OP_GT_uint32_t_uint32_t_c_l14_c13_8ceb_0 : signed(32 downto 0);
 variable VAR_CAST_TO_int33_t_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_fa42_return_output : signed(32 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_left : signed(32 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_right : signed(32 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_return_output : signed(33 downto 0);
 variable VAR_lt_zero : unsigned(0 downto 0);
 variable VAR_int33_32_32_BIN_OP_GT_uint32_t_uint32_t_c_l15_c23_a19e_return_output : unsigned(0 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_left_bot_BIN_OP_GT_uint32_t_uint32_t_c_l9_c14_c9a4_0 := VAR_left;
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_right := signed(std_logic_vector(resize(VAR_left_bot_BIN_OP_GT_uint32_t_uint32_t_c_l9_c14_c9a4_0, 33)));
     -- CAST_TO_int33_t[BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_fa42] LATENCY=0
     VAR_CAST_TO_int33_t_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_fa42_return_output := CAST_TO_int33_t_uint32_t(
     VAR_right);

     -- Submodule level 1
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_left := VAR_CAST_TO_int33_t_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_fa42_return_output;
     -- BIN_OP_MINUS[BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_left <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_left;
     BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_right <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_return_output := BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_return_output;

     -- Submodule level 2
     VAR_sub_BIN_OP_GT_uint32_t_uint32_t_c_l14_c13_8ceb_0 := resize(VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint32_t_c_l14_c19_2010_return_output, 33);
     -- int33_32_32[BIN_OP_GT_uint32_t_uint32_t_c_l15_c23_a19e] LATENCY=0
     VAR_int33_32_32_BIN_OP_GT_uint32_t_uint32_t_c_l15_c23_a19e_return_output := int33_32_32(
     VAR_sub_BIN_OP_GT_uint32_t_uint32_t_c_l14_c13_8ceb_0);

     -- Submodule level 3
     VAR_return_output := VAR_int33_32_32_BIN_OP_GT_uint32_t_uint32_t_c_l15_c23_a19e_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
