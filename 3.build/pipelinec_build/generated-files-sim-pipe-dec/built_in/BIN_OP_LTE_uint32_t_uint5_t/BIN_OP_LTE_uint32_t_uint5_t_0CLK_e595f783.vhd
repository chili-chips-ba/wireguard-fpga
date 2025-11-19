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
-- Submodules: 7
entity BIN_OP_LTE_uint32_t_uint5_t_0CLK_e595f783 is
port(
 left : in unsigned(31 downto 0);
 right : in unsigned(4 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_LTE_uint32_t_uint5_t_0CLK_e595f783;
architecture arch of BIN_OP_LTE_uint32_t_uint5_t_0CLK_e595f783 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- CONST_SR_5[BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892]
signal CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_x : unsigned(31 downto 0);
signal CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_return_output : unsigned(31 downto 0);

-- BIN_OP_EQ[BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0]
signal BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_left : unsigned(26 downto 0);
signal BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_right : unsigned(0 downto 0);
signal BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_return_output : unsigned(0 downto 0);

-- rv_MUX[BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264]
signal rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_cond : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iftrue : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iffalse : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb]
signal BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_left : signed(5 downto 0);
signal BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_right : signed(5 downto 0);
signal BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_return_output : signed(6 downto 0);

-- UNARY_OP_NOT[BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9]
signal UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_expr : unsigned(0 downto 0);
signal UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_return_output : unsigned(0 downto 0);

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
-- CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892 : 0 clocks latency
CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892 : entity work.CONST_SR_5_uint32_t_0CLK_de264c78 port map (
CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_x,
CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_return_output);

-- BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0 : 0 clocks latency
BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0 : entity work.BIN_OP_EQ_uint27_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_left,
BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_right,
BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_return_output);

-- rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264 : 0 clocks latency
rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_cond,
rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iftrue,
rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iffalse,
rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_return_output);

-- BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb : 0 clocks latency
BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb : entity work.BIN_OP_MINUS_int6_t_int6_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_left,
BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_right,
BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_return_output);

-- UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9 : 0 clocks latency
UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9 : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_expr,
UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_return_output,
 BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_return_output,
 rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_return_output,
 BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_return_output,
 UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(31 downto 0);
 variable VAR_right : unsigned(4 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_left_bot : unsigned(4 downto 0);
 variable VAR_left_bot_BIN_OP_LTE_uint32_t_uint5_t_c_l9_c13_0597_0 : unsigned(4 downto 0);
 variable VAR_right_bot : unsigned(4 downto 0);
 variable VAR_top : unsigned(26 downto 0);
 variable VAR_top_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c3_e5e2 : unsigned(26 downto 0);
 variable VAR_CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_return_output : unsigned(31 downto 0);
 variable VAR_CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_x : unsigned(31 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_left : unsigned(26 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iftrue : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iffalse : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_cond : unsigned(0 downto 0);
 variable VAR_sub : signed(5 downto 0);
 variable VAR_sub_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c12_f1e0_0 : signed(5 downto 0);
 variable VAR_CAST_TO_int6_t_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_c448_return_output : signed(5 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_left : signed(5 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_right : signed(5 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_return_output : signed(6 downto 0);
 variable VAR_lt_zero : unsigned(0 downto 0);
 variable VAR_int6_5_5_BIN_OP_LTE_uint32_t_uint5_t_c_l18_c23_8b58_return_output : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_expr : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_return_output : unsigned(0 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_right := to_unsigned(0, 1);
     VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iffalse := to_unsigned(0, 1);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_x := VAR_left;
     VAR_left_bot_BIN_OP_LTE_uint32_t_uint5_t_c_l9_c13_0597_0 := resize(VAR_left, 5);
     VAR_BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_right := signed(std_logic_vector(resize(VAR_left_bot_BIN_OP_LTE_uint32_t_uint5_t_c_l9_c13_0597_0, 6)));
     -- CONST_SR_5[BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892] LATENCY=0
     -- Inputs
     CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_x <= VAR_CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_x;
     -- Outputs
     VAR_CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_return_output := CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_return_output;

     -- CAST_TO_int6_t[BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_c448] LATENCY=0
     VAR_CAST_TO_int6_t_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_c448_return_output := CAST_TO_int6_t_uint5_t(
     VAR_right);

     -- Submodule level 1
     VAR_BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_left := VAR_CAST_TO_int6_t_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_c448_return_output;
     VAR_top_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c3_e5e2 := resize(VAR_CONST_SR_5_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c9_4892_return_output, 27);
     VAR_BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_left := VAR_top_BIN_OP_LTE_uint32_t_uint5_t_c_l13_c3_e5e2;
     -- BIN_OP_MINUS[BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_left <= VAR_BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_left;
     BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_right <= VAR_BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_return_output := BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_return_output;

     -- BIN_OP_EQ[BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0] LATENCY=0
     -- Inputs
     BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_left <= VAR_BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_left;
     BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_right <= VAR_BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_right;
     -- Outputs
     VAR_BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_return_output := BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_return_output;

     -- Submodule level 2
     VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_cond := VAR_BIN_OP_EQ_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c6_add0_return_output;
     VAR_sub_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c12_f1e0_0 := resize(VAR_BIN_OP_MINUS_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c18_72bb_return_output, 6);
     -- int6_5_5[BIN_OP_LTE_uint32_t_uint5_t_c_l18_c23_8b58] LATENCY=0
     VAR_int6_5_5_BIN_OP_LTE_uint32_t_uint5_t_c_l18_c23_8b58_return_output := int6_5_5(
     VAR_sub_BIN_OP_LTE_uint32_t_uint5_t_c_l17_c12_f1e0_0);

     -- Submodule level 3
     VAR_UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_expr := VAR_int6_5_5_BIN_OP_LTE_uint32_t_uint5_t_c_l18_c23_8b58_return_output;
     -- UNARY_OP_NOT[BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9] LATENCY=0
     -- Inputs
     UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_expr <= VAR_UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_expr;
     -- Outputs
     VAR_UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_return_output := UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_return_output;

     -- Submodule level 4
     VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iftrue := VAR_UNARY_OP_NOT_BIN_OP_LTE_uint32_t_uint5_t_c_l19_c11_daf9_return_output;
     -- rv_MUX[BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264] LATENCY=0
     -- Inputs
     rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_cond <= VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_cond;
     rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iftrue <= VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iftrue;
     rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iffalse <= VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_iffalse;
     -- Outputs
     VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_return_output := rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_return_output;

     -- Submodule level 5
     VAR_return_output := VAR_rv_MUX_BIN_OP_LTE_uint32_t_uint5_t_c_l15_c3_6264_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
