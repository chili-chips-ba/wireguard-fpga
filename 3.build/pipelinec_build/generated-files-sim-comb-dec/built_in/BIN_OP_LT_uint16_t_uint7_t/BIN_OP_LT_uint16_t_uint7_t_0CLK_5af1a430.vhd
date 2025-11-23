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
entity BIN_OP_LT_uint16_t_uint7_t_0CLK_5af1a430 is
port(
 left : in unsigned(15 downto 0);
 right : in unsigned(6 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_LT_uint16_t_uint7_t_0CLK_5af1a430;
architecture arch of BIN_OP_LT_uint16_t_uint7_t_0CLK_5af1a430 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- CONST_SR_7[BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15]
signal CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_x : unsigned(15 downto 0);
signal CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_return_output : unsigned(15 downto 0);

-- BIN_OP_EQ[BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594]
signal BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_left : unsigned(8 downto 0);
signal BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_right : unsigned(0 downto 0);
signal BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_return_output : unsigned(0 downto 0);

-- rv_MUX[BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d]
signal rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_cond : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iftrue : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iffalse : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a]
signal BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_left : signed(7 downto 0);
signal BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_right : signed(7 downto 0);
signal BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_return_output : signed(8 downto 0);

function CAST_TO_int8_t_uint7_t( rhs : unsigned) return signed is

  --variable rhs : unsigned(6 downto 0);
  variable return_output : signed(7 downto 0);

begin

      return_output := signed(std_logic_vector(resize(rhs,8)));
    return return_output;
end function;

function int8_7_7( x : signed) return unsigned is
--variable x : signed(7 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(7- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15 : 0 clocks latency
CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15 : entity work.CONST_SR_7_uint16_t_0CLK_de264c78 port map (
CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_x,
CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_return_output);

-- BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594 : 0 clocks latency
BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594 : entity work.BIN_OP_EQ_uint9_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_left,
BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_right,
BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_return_output);

-- rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d : 0 clocks latency
rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_cond,
rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iftrue,
rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iffalse,
rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_return_output);

-- BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a : 0 clocks latency
BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a : entity work.BIN_OP_MINUS_int8_t_int8_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_left,
BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_right,
BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_return_output,
 BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_return_output,
 rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_return_output,
 BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(15 downto 0);
 variable VAR_right : unsigned(6 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_left_bot : unsigned(6 downto 0);
 variable VAR_left_bot_BIN_OP_LT_uint16_t_uint7_t_c_l9_c13_2332_0 : unsigned(6 downto 0);
 variable VAR_right_bot : unsigned(6 downto 0);
 variable VAR_right_bot_BIN_OP_LT_uint16_t_uint7_t_c_l10_c13_0101_0 : unsigned(6 downto 0);
 variable VAR_top : unsigned(8 downto 0);
 variable VAR_top_BIN_OP_LT_uint16_t_uint7_t_c_l13_c3_da0d : unsigned(8 downto 0);
 variable VAR_CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_return_output : unsigned(15 downto 0);
 variable VAR_CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_x : unsigned(15 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_left : unsigned(8 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iftrue : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iffalse : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_cond : unsigned(0 downto 0);
 variable VAR_sub : signed(7 downto 0);
 variable VAR_sub_BIN_OP_LT_uint16_t_uint7_t_c_l17_c12_7974_0 : signed(7 downto 0);
 variable VAR_CAST_TO_int8_t_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_bd4c_return_output : signed(7 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_left : signed(7 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_right : signed(7 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_return_output : signed(8 downto 0);
 variable VAR_lt_zero : unsigned(0 downto 0);
 variable VAR_int8_7_7_BIN_OP_LT_uint16_t_uint7_t_c_l18_c23_f269_return_output : unsigned(0 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_right := to_unsigned(0, 1);
     VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iffalse := to_unsigned(0, 1);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_x := VAR_left;
     VAR_left_bot_BIN_OP_LT_uint16_t_uint7_t_c_l9_c13_2332_0 := resize(VAR_left, 7);
     VAR_right_bot_BIN_OP_LT_uint16_t_uint7_t_c_l10_c13_0101_0 := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_right := signed(std_logic_vector(resize(VAR_right_bot_BIN_OP_LT_uint16_t_uint7_t_c_l10_c13_0101_0, 8)));
     -- CAST_TO_int8_t[BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_bd4c] LATENCY=0
     VAR_CAST_TO_int8_t_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_bd4c_return_output := CAST_TO_int8_t_uint7_t(
     VAR_left_bot_BIN_OP_LT_uint16_t_uint7_t_c_l9_c13_2332_0);

     -- CONST_SR_7[BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15] LATENCY=0
     -- Inputs
     CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_x <= VAR_CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_x;
     -- Outputs
     VAR_CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_return_output := CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_return_output;

     -- Submodule level 1
     VAR_BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_left := VAR_CAST_TO_int8_t_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_bd4c_return_output;
     VAR_top_BIN_OP_LT_uint16_t_uint7_t_c_l13_c3_da0d := resize(VAR_CONST_SR_7_BIN_OP_LT_uint16_t_uint7_t_c_l13_c9_5c15_return_output, 9);
     VAR_BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_left := VAR_top_BIN_OP_LT_uint16_t_uint7_t_c_l13_c3_da0d;
     -- BIN_OP_MINUS[BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_left <= VAR_BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_left;
     BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_right <= VAR_BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_return_output := BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_return_output;

     -- BIN_OP_EQ[BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594] LATENCY=0
     -- Inputs
     BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_left <= VAR_BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_left;
     BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_right <= VAR_BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_right;
     -- Outputs
     VAR_BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_return_output := BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_return_output;

     -- Submodule level 2
     VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_cond := VAR_BIN_OP_EQ_BIN_OP_LT_uint16_t_uint7_t_c_l15_c6_f594_return_output;
     VAR_sub_BIN_OP_LT_uint16_t_uint7_t_c_l17_c12_7974_0 := resize(VAR_BIN_OP_MINUS_BIN_OP_LT_uint16_t_uint7_t_c_l17_c18_d32a_return_output, 8);
     -- int8_7_7[BIN_OP_LT_uint16_t_uint7_t_c_l18_c23_f269] LATENCY=0
     VAR_int8_7_7_BIN_OP_LT_uint16_t_uint7_t_c_l18_c23_f269_return_output := int8_7_7(
     VAR_sub_BIN_OP_LT_uint16_t_uint7_t_c_l17_c12_7974_0);

     -- Submodule level 3
     VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iftrue := VAR_int8_7_7_BIN_OP_LT_uint16_t_uint7_t_c_l18_c23_f269_return_output;
     -- rv_MUX[BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d] LATENCY=0
     -- Inputs
     rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_cond <= VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_cond;
     rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iftrue <= VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iftrue;
     rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iffalse <= VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_iffalse;
     -- Outputs
     VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_return_output := rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_return_output;

     -- Submodule level 4
     VAR_return_output := VAR_rv_MUX_BIN_OP_LT_uint16_t_uint7_t_c_l15_c3_981d_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
