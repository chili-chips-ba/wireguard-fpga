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
entity BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 is
port(
 left : in unsigned(63 downto 0);
 right : in unsigned(63 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95;
architecture arch of BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- BIN_OP_MINUS[BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb]
signal BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_left : signed(64 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_right : signed(64 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_return_output : signed(65 downto 0);

function CAST_TO_int65_t_uint64_t( rhs : unsigned) return signed is

  --variable rhs : unsigned(63 downto 0);
  variable return_output : signed(64 downto 0);

begin

      return_output := signed(std_logic_vector(resize(rhs,65)));
    return return_output;
end function;

function int65_64_64( x : signed) return unsigned is
--variable x : signed(64 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(64- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb : 0 clocks latency
BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb : entity work.BIN_OP_MINUS_int65_t_int65_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_left,
BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_right,
BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(63 downto 0);
 variable VAR_right : unsigned(63 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_left_bot : unsigned(63 downto 0);
 variable VAR_left_bot_BIN_OP_GT_uint64_t_uint64_t_c_l9_c14_6064_0 : unsigned(63 downto 0);
 variable VAR_right_bot : unsigned(63 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_sub : signed(64 downto 0);
 variable VAR_sub_BIN_OP_GT_uint64_t_uint64_t_c_l14_c13_85f3_0 : signed(64 downto 0);
 variable VAR_CAST_TO_int65_t_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_cdf6_return_output : signed(64 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_left : signed(64 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_right : signed(64 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_return_output : signed(65 downto 0);
 variable VAR_lt_zero : unsigned(0 downto 0);
 variable VAR_int65_64_64_BIN_OP_GT_uint64_t_uint64_t_c_l15_c23_b087_return_output : unsigned(0 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_left_bot_BIN_OP_GT_uint64_t_uint64_t_c_l9_c14_6064_0 := VAR_left;
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_right := signed(std_logic_vector(resize(VAR_left_bot_BIN_OP_GT_uint64_t_uint64_t_c_l9_c14_6064_0, 65)));
     -- CAST_TO_int65_t[BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_cdf6] LATENCY=0
     VAR_CAST_TO_int65_t_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_cdf6_return_output := CAST_TO_int65_t_uint64_t(
     VAR_right);

     -- Submodule level 1
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_left := VAR_CAST_TO_int65_t_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_cdf6_return_output;
     -- BIN_OP_MINUS[BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_left <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_left;
     BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_right <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_return_output := BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_return_output;

     -- Submodule level 2
     VAR_sub_BIN_OP_GT_uint64_t_uint64_t_c_l14_c13_85f3_0 := resize(VAR_BIN_OP_MINUS_BIN_OP_GT_uint64_t_uint64_t_c_l14_c19_20fb_return_output, 65);
     -- int65_64_64[BIN_OP_GT_uint64_t_uint64_t_c_l15_c23_b087] LATENCY=0
     VAR_int65_64_64_BIN_OP_GT_uint64_t_uint64_t_c_l15_c23_b087_return_output := int65_64_64(
     VAR_sub_BIN_OP_GT_uint64_t_uint64_t_c_l14_c13_85f3_0);

     -- Submodule level 3
     VAR_return_output := VAR_int65_64_64_BIN_OP_GT_uint64_t_uint64_t_c_l15_c23_b087_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
