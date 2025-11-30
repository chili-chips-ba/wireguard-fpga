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
entity BIN_OP_GT_uint32_t_uint5_t_0CLK_5af1a430 is
port(
 left : in unsigned(31 downto 0);
 right : in unsigned(4 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_GT_uint32_t_uint5_t_0CLK_5af1a430;
architecture arch of BIN_OP_GT_uint32_t_uint5_t_0CLK_5af1a430 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- CONST_SR_5[BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535]
signal CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_x : unsigned(31 downto 0);
signal CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_return_output : unsigned(31 downto 0);

-- BIN_OP_EQ[BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055]
signal BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_left : unsigned(26 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_right : unsigned(0 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_return_output : unsigned(0 downto 0);

-- rv_MUX[BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69]
signal rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_cond : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iftrue : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iffalse : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829]
signal BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_left : signed(5 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_right : signed(5 downto 0);
signal BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_return_output : signed(6 downto 0);

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
-- CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535 : 0 clocks latency
CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535 : entity work.CONST_SR_5_uint32_t_0CLK_de264c78 port map (
CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_x,
CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_return_output);

-- BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055 : 0 clocks latency
BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055 : entity work.BIN_OP_EQ_uint27_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_left,
BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_right,
BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_return_output);

-- rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69 : 0 clocks latency
rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_cond,
rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iftrue,
rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iffalse,
rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_return_output);

-- BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829 : entity work.BIN_OP_MINUS_int6_t_int6_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_left,
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_right,
BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_return_output,
 BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_return_output,
 rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_return_output,
 BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(31 downto 0);
 variable VAR_right : unsigned(4 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_left_bot : unsigned(4 downto 0);
 variable VAR_left_bot_BIN_OP_GT_uint32_t_uint5_t_c_l9_c13_b245_0 : unsigned(4 downto 0);
 variable VAR_right_bot : unsigned(4 downto 0);
 variable VAR_top : unsigned(26 downto 0);
 variable VAR_top_BIN_OP_GT_uint32_t_uint5_t_c_l13_c3_f83c : unsigned(26 downto 0);
 variable VAR_CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_return_output : unsigned(31 downto 0);
 variable VAR_CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_x : unsigned(31 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_left : unsigned(26 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iftrue : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iffalse : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_cond : unsigned(0 downto 0);
 variable VAR_sub : signed(5 downto 0);
 variable VAR_sub_BIN_OP_GT_uint32_t_uint5_t_c_l17_c12_0c77_0 : signed(5 downto 0);
 variable VAR_CAST_TO_int6_t_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_a7d0_return_output : signed(5 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_left : signed(5 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_right : signed(5 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_return_output : signed(6 downto 0);
 variable VAR_lt_zero : unsigned(0 downto 0);
 variable VAR_int6_5_5_BIN_OP_GT_uint32_t_uint5_t_c_l18_c23_17d8_return_output : unsigned(0 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_right := to_unsigned(0, 1);
     VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iffalse := to_unsigned(1, 1);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_x := VAR_left;
     VAR_left_bot_BIN_OP_GT_uint32_t_uint5_t_c_l9_c13_b245_0 := resize(VAR_left, 5);
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_right := signed(std_logic_vector(resize(VAR_left_bot_BIN_OP_GT_uint32_t_uint5_t_c_l9_c13_b245_0, 6)));
     -- CONST_SR_5[BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535] LATENCY=0
     -- Inputs
     CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_x <= VAR_CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_x;
     -- Outputs
     VAR_CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_return_output := CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_return_output;

     -- CAST_TO_int6_t[BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_a7d0] LATENCY=0
     VAR_CAST_TO_int6_t_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_a7d0_return_output := CAST_TO_int6_t_uint5_t(
     VAR_right);

     -- Submodule level 1
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_left := VAR_CAST_TO_int6_t_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_a7d0_return_output;
     VAR_top_BIN_OP_GT_uint32_t_uint5_t_c_l13_c3_f83c := resize(VAR_CONST_SR_5_BIN_OP_GT_uint32_t_uint5_t_c_l13_c9_5535_return_output, 27);
     VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_left := VAR_top_BIN_OP_GT_uint32_t_uint5_t_c_l13_c3_f83c;
     -- BIN_OP_MINUS[BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_left <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_left;
     BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_right <= VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_return_output := BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_return_output;

     -- BIN_OP_EQ[BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055] LATENCY=0
     -- Inputs
     BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_left <= VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_left;
     BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_right <= VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_right;
     -- Outputs
     VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_return_output := BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_return_output;

     -- Submodule level 2
     VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_cond := VAR_BIN_OP_EQ_BIN_OP_GT_uint32_t_uint5_t_c_l15_c6_e055_return_output;
     VAR_sub_BIN_OP_GT_uint32_t_uint5_t_c_l17_c12_0c77_0 := resize(VAR_BIN_OP_MINUS_BIN_OP_GT_uint32_t_uint5_t_c_l17_c18_e829_return_output, 6);
     -- int6_5_5[BIN_OP_GT_uint32_t_uint5_t_c_l18_c23_17d8] LATENCY=0
     VAR_int6_5_5_BIN_OP_GT_uint32_t_uint5_t_c_l18_c23_17d8_return_output := int6_5_5(
     VAR_sub_BIN_OP_GT_uint32_t_uint5_t_c_l17_c12_0c77_0);

     -- Submodule level 3
     VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iftrue := VAR_int6_5_5_BIN_OP_GT_uint32_t_uint5_t_c_l18_c23_17d8_return_output;
     -- rv_MUX[BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69] LATENCY=0
     -- Inputs
     rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_cond <= VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_cond;
     rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iftrue <= VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iftrue;
     rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iffalse <= VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_iffalse;
     -- Outputs
     VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_return_output := rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_return_output;

     -- Submodule level 4
     VAR_return_output := VAR_rv_MUX_BIN_OP_GT_uint32_t_uint5_t_c_l15_c3_de69_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
