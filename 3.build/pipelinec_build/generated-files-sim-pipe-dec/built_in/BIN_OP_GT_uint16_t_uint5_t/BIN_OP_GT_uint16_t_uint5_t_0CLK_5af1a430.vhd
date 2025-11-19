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
entity BIN_OP_GT_uint16_t_uint5_t_0CLK_5af1a430 is
port(
 left : in unsigned(15 downto 0);
 right : in unsigned(4 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_GT_uint16_t_uint5_t_0CLK_5af1a430;
architecture arch of BIN_OP_GT_uint16_t_uint5_t_0CLK_5af1a430 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- CONST_SR_5[BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860]
signal CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_x : unsigned(15 downto 0);
signal CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_return_output : unsigned(15 downto 0);

-- BIN_OP_EQ[BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000]
signal BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_left : unsigned(10 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_right : unsigned(0 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_return_output : unsigned(0 downto 0);

-- rv_MUX[BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b]
signal rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_cond : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iftrue : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iffalse : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69]
signal BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_left : signed(5 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_right : signed(5 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_return_output : signed(6 downto 0);

function CAST_TO_int6_t_uint5_t( rhs : unsigned) return signed is

  --variable rhs : unsigned(4 downto 0);
  variable return_output : signed(5 downto 0);

begin

      return_output := signed(std_logic_vector(resize(rhs,6)));
    return return_output;
end function;

function int6_5_5( x : signed) return unsigned is
--variable x : signed(5 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(5- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860 : 0 clocks latency
CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860 : entity work.CONST_SR_5_uint16_t_0CLK_de264c78 port map (
CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_x,
CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_return_output);

-- BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000 : 0 clocks latency
BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000 : entity work.BIN_OP_EQ_uint11_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_left,
BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_right,
BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_return_output);

-- rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b : 0 clocks latency
rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_cond,
rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iftrue,
rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iffalse,
rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_return_output);

-- BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69 : entity work.BIN_OP_MINUS_int6_t_int6_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_left,
BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_right,
BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_return_output,
 BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_return_output,
 rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_return_output,
 BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(15 downto 0);
 variable VAR_right : unsigned(4 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_left_bot : unsigned(4 downto 0);
 variable VAR_left_bot_BIN_OP_GT_uint16_t_uint5_t_c_l9_c13_b03a_0 : unsigned(4 downto 0);
 variable VAR_right_bot : unsigned(4 downto 0);
 variable VAR_top : unsigned(10 downto 0);
 variable VAR_top_BIN_OP_GT_uint16_t_uint5_t_c_l13_c3_fda3 : unsigned(10 downto 0);
 variable VAR_CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_return_output : unsigned(15 downto 0);
 variable VAR_CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_x : unsigned(15 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_left : unsigned(10 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iftrue : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iffalse : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_cond : unsigned(0 downto 0);
 variable VAR_sub : signed(5 downto 0);
 variable VAR_sub_BIN_OP_GT_uint16_t_uint5_t_c_l17_c12_0b03_0 : signed(5 downto 0);
 variable VAR_CAST_TO_int6_t_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_d64a_return_output : signed(5 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_left : signed(5 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_right : signed(5 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_return_output : signed(6 downto 0);
 variable VAR_lt_zero : unsigned(0 downto 0);
 variable VAR_int6_5_5_BIN_OP_GT_uint16_t_uint5_t_c_l18_c23_7f4a_return_output : unsigned(0 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_right := to_unsigned(0, 1);
     VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iffalse := to_unsigned(1, 1);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_x := VAR_left;
     VAR_left_bot_BIN_OP_GT_uint16_t_uint5_t_c_l9_c13_b03a_0 := resize(VAR_left, 5);
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_right := signed(std_logic_vector(resize(VAR_left_bot_BIN_OP_GT_uint16_t_uint5_t_c_l9_c13_b03a_0, 6)));
     -- CAST_TO_int6_t[BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_d64a] LATENCY=0
     VAR_CAST_TO_int6_t_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_d64a_return_output := CAST_TO_int6_t_uint5_t(
     VAR_right);

     -- CONST_SR_5[BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860] LATENCY=0
     -- Inputs
     CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_x <= VAR_CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_x;
     -- Outputs
     VAR_CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_return_output := CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_return_output;

     -- Submodule level 1
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_left := VAR_CAST_TO_int6_t_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_d64a_return_output;
     VAR_top_BIN_OP_GT_uint16_t_uint5_t_c_l13_c3_fda3 := resize(VAR_CONST_SR_5_BIN_OP_GT_uint16_t_uint5_t_c_l13_c9_6860_return_output, 11);
     VAR_BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_left := VAR_top_BIN_OP_GT_uint16_t_uint5_t_c_l13_c3_fda3;
     -- BIN_OP_EQ[BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000] LATENCY=0
     -- Inputs
     BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_left <= VAR_BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_left;
     BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_right <= VAR_BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_right;
     -- Outputs
     VAR_BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_return_output := BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_return_output;

     -- BIN_OP_MINUS[BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_left <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_left;
     BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_right <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_return_output := BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_return_output;

     -- Submodule level 2
     VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_cond := VAR_BIN_OP_EQ_BIN_OP_GT_uint16_t_uint5_t_c_l15_c6_2000_return_output;
     VAR_sub_BIN_OP_GT_uint16_t_uint5_t_c_l17_c12_0b03_0 := resize(VAR_BIN_OP_MINUS_BIN_OP_GT_uint16_t_uint5_t_c_l17_c18_9c69_return_output, 6);
     -- int6_5_5[BIN_OP_GT_uint16_t_uint5_t_c_l18_c23_7f4a] LATENCY=0
     VAR_int6_5_5_BIN_OP_GT_uint16_t_uint5_t_c_l18_c23_7f4a_return_output := int6_5_5(
     VAR_sub_BIN_OP_GT_uint16_t_uint5_t_c_l17_c12_0b03_0);

     -- Submodule level 3
     VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iftrue := VAR_int6_5_5_BIN_OP_GT_uint16_t_uint5_t_c_l18_c23_7f4a_return_output;
     -- rv_MUX[BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b] LATENCY=0
     -- Inputs
     rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_cond <= VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_cond;
     rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iftrue <= VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iftrue;
     rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iffalse <= VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_iffalse;
     -- Outputs
     VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_return_output := rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_return_output;

     -- Submodule level 4
     VAR_return_output := VAR_rv_MUX_BIN_OP_GT_uint16_t_uint5_t_c_l15_c3_2f7b_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
