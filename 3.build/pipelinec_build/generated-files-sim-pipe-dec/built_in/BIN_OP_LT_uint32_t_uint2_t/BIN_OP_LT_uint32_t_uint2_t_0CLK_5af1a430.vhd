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
-- Submodules: 6
entity BIN_OP_LT_uint32_t_uint2_t_0CLK_5af1a430 is
port(
 left : in unsigned(31 downto 0);
 right : in unsigned(1 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_LT_uint32_t_uint2_t_0CLK_5af1a430;
architecture arch of BIN_OP_LT_uint32_t_uint2_t_0CLK_5af1a430 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- CONST_SR_2[BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00]
signal CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_x : unsigned(31 downto 0);
signal CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_return_output : unsigned(31 downto 0);

-- BIN_OP_EQ[BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990]
signal BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_left : unsigned(29 downto 0);
signal BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_right : unsigned(0 downto 0);
signal BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_return_output : unsigned(0 downto 0);

-- rv_MUX[BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c]
signal rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_cond : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iftrue : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iffalse : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d]
signal BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_left : signed(2 downto 0);
signal BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_right : signed(2 downto 0);
signal BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_return_output : signed(3 downto 0);

function CAST_TO_int3_t_uint2_t( rhs : unsigned) return signed is

  --variable rhs : unsigned(1 downto 0);
  variable return_output : signed(2 downto 0);

begin

      return_output := signed(std_logic_vector(resize(rhs,3)));
    return return_output;
end function;

function int3_2_2( x : signed) return unsigned is
--variable x : signed(2 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(2- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00 : 0 clocks latency
CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00 : entity work.CONST_SR_2_uint32_t_0CLK_de264c78 port map (
CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_x,
CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_return_output);

-- BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990 : 0 clocks latency
BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990 : entity work.BIN_OP_EQ_uint30_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_left,
BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_right,
BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_return_output);

-- rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c : 0 clocks latency
rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_cond,
rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iftrue,
rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iffalse,
rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_return_output);

-- BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d : 0 clocks latency
BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d : entity work.BIN_OP_MINUS_int3_t_int3_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_left,
BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_right,
BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_return_output,
 BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_return_output,
 rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_return_output,
 BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(31 downto 0);
 variable VAR_right : unsigned(1 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_left_bot : unsigned(1 downto 0);
 variable VAR_left_bot_BIN_OP_LT_uint32_t_uint2_t_c_l9_c13_5002_0 : unsigned(1 downto 0);
 variable VAR_right_bot : unsigned(1 downto 0);
 variable VAR_right_bot_BIN_OP_LT_uint32_t_uint2_t_c_l10_c13_e4e5_0 : unsigned(1 downto 0);
 variable VAR_top : unsigned(29 downto 0);
 variable VAR_top_BIN_OP_LT_uint32_t_uint2_t_c_l13_c3_2c31 : unsigned(29 downto 0);
 variable VAR_CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_return_output : unsigned(31 downto 0);
 variable VAR_CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_x : unsigned(31 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_left : unsigned(29 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iftrue : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iffalse : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_cond : unsigned(0 downto 0);
 variable VAR_sub : signed(2 downto 0);
 variable VAR_sub_BIN_OP_LT_uint32_t_uint2_t_c_l17_c12_8c5d_0 : signed(2 downto 0);
 variable VAR_CAST_TO_int3_t_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_aefb_return_output : signed(2 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_left : signed(2 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_right : signed(2 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_return_output : signed(3 downto 0);
 variable VAR_lt_zero : unsigned(0 downto 0);
 variable VAR_int3_2_2_BIN_OP_LT_uint32_t_uint2_t_c_l18_c23_42c9_return_output : unsigned(0 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_right := to_unsigned(0, 1);
     VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iffalse := to_unsigned(0, 1);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_x := VAR_left;
     VAR_left_bot_BIN_OP_LT_uint32_t_uint2_t_c_l9_c13_5002_0 := resize(VAR_left, 2);
     VAR_right_bot_BIN_OP_LT_uint32_t_uint2_t_c_l10_c13_e4e5_0 := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_right := signed(std_logic_vector(resize(VAR_right_bot_BIN_OP_LT_uint32_t_uint2_t_c_l10_c13_e4e5_0, 3)));
     -- CONST_SR_2[BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00] LATENCY=0
     -- Inputs
     CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_x <= VAR_CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_x;
     -- Outputs
     VAR_CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_return_output := CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_return_output;

     -- CAST_TO_int3_t[BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_aefb] LATENCY=0
     VAR_CAST_TO_int3_t_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_aefb_return_output := CAST_TO_int3_t_uint2_t(
     VAR_left_bot_BIN_OP_LT_uint32_t_uint2_t_c_l9_c13_5002_0);

     -- Submodule level 1
     VAR_BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_left := VAR_CAST_TO_int3_t_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_aefb_return_output;
     VAR_top_BIN_OP_LT_uint32_t_uint2_t_c_l13_c3_2c31 := resize(VAR_CONST_SR_2_BIN_OP_LT_uint32_t_uint2_t_c_l13_c9_1e00_return_output, 30);
     VAR_BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_left := VAR_top_BIN_OP_LT_uint32_t_uint2_t_c_l13_c3_2c31;
     -- BIN_OP_EQ[BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990] LATENCY=0
     -- Inputs
     BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_left <= VAR_BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_left;
     BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_right <= VAR_BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_right;
     -- Outputs
     VAR_BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_return_output := BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_return_output;

     -- BIN_OP_MINUS[BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_left <= VAR_BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_left;
     BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_right <= VAR_BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_return_output := BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_return_output;

     -- Submodule level 2
     VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_cond := VAR_BIN_OP_EQ_BIN_OP_LT_uint32_t_uint2_t_c_l15_c6_f990_return_output;
     VAR_sub_BIN_OP_LT_uint32_t_uint2_t_c_l17_c12_8c5d_0 := resize(VAR_BIN_OP_MINUS_BIN_OP_LT_uint32_t_uint2_t_c_l17_c18_096d_return_output, 3);
     -- int3_2_2[BIN_OP_LT_uint32_t_uint2_t_c_l18_c23_42c9] LATENCY=0
     VAR_int3_2_2_BIN_OP_LT_uint32_t_uint2_t_c_l18_c23_42c9_return_output := int3_2_2(
     VAR_sub_BIN_OP_LT_uint32_t_uint2_t_c_l17_c12_8c5d_0);

     -- Submodule level 3
     VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iftrue := VAR_int3_2_2_BIN_OP_LT_uint32_t_uint2_t_c_l18_c23_42c9_return_output;
     -- rv_MUX[BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c] LATENCY=0
     -- Inputs
     rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_cond <= VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_cond;
     rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iftrue <= VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iftrue;
     rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iffalse <= VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_iffalse;
     -- Outputs
     VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_return_output := rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_return_output;

     -- Submodule level 4
     VAR_return_output := VAR_rv_MUX_BIN_OP_LT_uint32_t_uint2_t_c_l15_c3_fa3c_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
