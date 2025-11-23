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
entity BIN_OP_GT_uint32_t_uint1_t_0CLK_5af1a430 is
port(
 left : in unsigned(31 downto 0);
 right : in unsigned(0 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_GT_uint32_t_uint1_t_0CLK_5af1a430;
architecture arch of BIN_OP_GT_uint32_t_uint1_t_0CLK_5af1a430 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- CONST_SR_1[BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8]
signal CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_x : unsigned(31 downto 0);
signal CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_return_output : unsigned(31 downto 0);

-- BIN_OP_EQ[BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4]
signal BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_left : unsigned(30 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_right : unsigned(0 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_return_output : unsigned(0 downto 0);

-- rv_MUX[BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7]
signal rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_cond : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iftrue : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iffalse : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa]
signal BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_left : signed(1 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_right : signed(1 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_return_output : signed(2 downto 0);

function CAST_TO_int2_t_uint1_t( rhs : unsigned) return signed is

  --variable rhs : unsigned(0 downto 0);
  variable return_output : signed(1 downto 0);

begin

      return_output := signed(std_logic_vector(resize(rhs,2)));
    return return_output;
end function;

function int2_1_1( x : signed) return unsigned is
--variable x : signed(1 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(1- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8 : 0 clocks latency
CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8 : entity work.CONST_SR_1_uint32_t_0CLK_de264c78 port map (
CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_x,
CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_return_output);

-- BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4 : 0 clocks latency
BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4 : entity work.BIN_OP_EQ_uint31_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_left,
BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_right,
BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_return_output);

-- rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7 : 0 clocks latency
rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_cond,
rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iftrue,
rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iffalse,
rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_return_output);

-- BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa : 0 clocks latency
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa : entity work.BIN_OP_MINUS_int2_t_int2_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_left,
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_right,
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_return_output,
 BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_return_output,
 rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_return_output,
 BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(31 downto 0);
 variable VAR_right : unsigned(0 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_left_bot : unsigned(0 downto 0);
 variable VAR_left_bot_BIN_OP_GT_uint32_t_uint1_t_c_l9_c13_6d9a_0 : unsigned(0 downto 0);
 variable VAR_right_bot : unsigned(0 downto 0);
 variable VAR_top : unsigned(30 downto 0);
 variable VAR_top_BIN_OP_GT_uint32_t_uint1_t_c_l13_c3_45f2 : unsigned(30 downto 0);
 variable VAR_CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_return_output : unsigned(31 downto 0);
 variable VAR_CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_x : unsigned(31 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_left : unsigned(30 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iftrue : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iffalse : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_cond : unsigned(0 downto 0);
 variable VAR_sub : signed(1 downto 0);
 variable VAR_sub_BIN_OP_GT_uint32_t_uint1_t_c_l17_c12_90b3_0 : signed(1 downto 0);
 variable VAR_CAST_TO_int2_t_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_268d_return_output : signed(1 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_left : signed(1 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_right : signed(1 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_return_output : signed(2 downto 0);
 variable VAR_lt_zero : unsigned(0 downto 0);
 variable VAR_int2_1_1_BIN_OP_GT_uint32_t_uint1_t_c_l18_c23_de49_return_output : unsigned(0 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_right := to_unsigned(0, 1);
     VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iffalse := to_unsigned(1, 1);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_x := VAR_left;
     VAR_left_bot_BIN_OP_GT_uint32_t_uint1_t_c_l9_c13_6d9a_0 := resize(VAR_left, 1);
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_right := signed(std_logic_vector(resize(VAR_left_bot_BIN_OP_GT_uint32_t_uint1_t_c_l9_c13_6d9a_0, 2)));
     -- CONST_SR_1[BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8] LATENCY=0
     -- Inputs
     CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_x <= VAR_CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_x;
     -- Outputs
     VAR_CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_return_output := CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_return_output;

     -- CAST_TO_int2_t[BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_268d] LATENCY=0
     VAR_CAST_TO_int2_t_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_268d_return_output := CAST_TO_int2_t_uint1_t(
     VAR_right);

     -- Submodule level 1
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_left := VAR_CAST_TO_int2_t_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_268d_return_output;
     VAR_top_BIN_OP_GT_uint32_t_uint1_t_c_l13_c3_45f2 := resize(VAR_CONST_SR_1_BIN_OP_GT_uint32_t_uint1_t_c_l13_c9_cdc8_return_output, 31);
     VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_left := VAR_top_BIN_OP_GT_uint32_t_uint1_t_c_l13_c3_45f2;
     -- BIN_OP_EQ[BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4] LATENCY=0
     -- Inputs
     BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_left <= VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_left;
     BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_right <= VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_right;
     -- Outputs
     VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_return_output := BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_return_output;

     -- BIN_OP_MINUS[BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_left <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_left;
     BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_right <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_return_output := BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_return_output;

     -- Submodule level 2
     VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_cond := VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint1_t_c_l15_c6_93c4_return_output;
     VAR_sub_BIN_OP_GT_uint32_t_uint1_t_c_l17_c12_90b3_0 := resize(VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint1_t_c_l17_c18_eeaa_return_output, 2);
     -- int2_1_1[BIN_OP_GT_uint32_t_uint1_t_c_l18_c23_de49] LATENCY=0
     VAR_int2_1_1_BIN_OP_GT_uint32_t_uint1_t_c_l18_c23_de49_return_output := int2_1_1(
     VAR_sub_BIN_OP_GT_uint32_t_uint1_t_c_l17_c12_90b3_0);

     -- Submodule level 3
     VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iftrue := VAR_int2_1_1_BIN_OP_GT_uint32_t_uint1_t_c_l18_c23_de49_return_output;
     -- rv_MUX[BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7] LATENCY=0
     -- Inputs
     rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_cond <= VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_cond;
     rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iftrue <= VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iftrue;
     rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iffalse <= VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_iffalse;
     -- Outputs
     VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_return_output := rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_return_output;

     -- Submodule level 4
     VAR_return_output := VAR_rv_MUX_BIN_OP_GT_uint32_t_uint1_t_c_l15_c3_deb7_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
