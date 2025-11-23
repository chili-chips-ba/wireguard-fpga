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
entity BIN_OP_GT_int33_t_int32_t_0CLK_1aac2328 is
port(
 left : in signed(32 downto 0);
 right : in signed(31 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_GT_int33_t_int32_t_0CLK_1aac2328;
architecture arch of BIN_OP_GT_int33_t_int32_t_0CLK_1aac2328 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- CONST_SR_31[BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a]
signal CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_x : signed(32 downto 0);
signal CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_return_output : signed(32 downto 0);

-- CONST_SR_31[BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432]
signal CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_x : signed(32 downto 0);
signal CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_return_output : signed(32 downto 0);

-- BIN_OP_EQ[BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990]
signal BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_left : unsigned(1 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_right : unsigned(1 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_return_output : unsigned(0 downto 0);

-- rv_MUX[BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959]
signal rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_cond : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iftrue : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iffalse : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_return_output : unsigned(0 downto 0);

-- BIN_OP_GT[BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081]
signal BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_left : unsigned(30 downto 0);
signal BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_right : unsigned(30 downto 0);
signal BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_return_output : unsigned(0 downto 0);

-- UNARY_OP_NOT[BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9]
signal UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_expr : unsigned(0 downto 0);
signal UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_return_output : unsigned(0 downto 0);

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
-- CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a : 0 clocks latency
CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a : entity work.CONST_SR_31_int33_t_0CLK_de264c78 port map (
CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_x,
CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_return_output);

-- CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432 : 0 clocks latency
CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432 : entity work.CONST_SR_31_int33_t_0CLK_de264c78 port map (
CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_x,
CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_return_output);

-- BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990 : 0 clocks latency
BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990 : entity work.BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78 port map (
BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_left,
BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_right,
BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_return_output);

-- rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959 : 0 clocks latency
rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_cond,
rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iftrue,
rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iffalse,
rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_return_output);

-- BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081 : 0 clocks latency
BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081 : entity work.BIN_OP_GT_uint31_t_uint31_t_0CLK_380ecc95 port map (
BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_left,
BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_right,
BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_return_output);

-- UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9 : 0 clocks latency
UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9 : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_expr,
UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_return_output,
 CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_return_output,
 BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_return_output,
 rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_return_output,
 BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_return_output,
 UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : signed(32 downto 0);
 variable VAR_right : signed(31 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_lsign : unsigned(0 downto 0);
 variable VAR_int33_32_32_BIN_OP_GT_int33_t_int32_t_c_l7_c21_69e1_return_output : unsigned(0 downto 0);
 variable VAR_rsign : unsigned(0 downto 0);
 variable VAR_lsigned : signed(32 downto 0);
 variable VAR_rsigned : signed(32 downto 0);
 variable VAR_rsigned_BIN_OP_GT_int33_t_int32_t_c_l10_c13_09f7_0 : signed(32 downto 0);
 variable VAR_extra_sign_bits : unsigned(1 downto 0);
 variable VAR_extra_sign_bits_BIN_OP_GT_int33_t_int32_t_c_l12_c13_f142_0 : unsigned(1 downto 0);
 variable VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_return_output : signed(32 downto 0);
 variable VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_x : signed(32 downto 0);
 variable VAR_sign_ext_like_zero : unsigned(1 downto 0);
 variable VAR_sign_ext_like_zero_BIN_OP_GT_int33_t_int32_t_c_l13_c13_8cc9_0 : unsigned(1 downto 0);
 variable VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_return_output : signed(32 downto 0);
 variable VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_x : signed(32 downto 0);
 variable VAR_lunsigned : unsigned(30 downto 0);
 variable VAR_lunsigned_BIN_OP_GT_int33_t_int32_t_c_l16_c14_763b_0 : unsigned(30 downto 0);
 variable VAR_runsigned : unsigned(30 downto 0);
 variable VAR_runsigned_BIN_OP_GT_int33_t_int32_t_c_l17_c14_987d_0 : unsigned(30 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_left : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_right : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iftrue : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iffalse : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_left : unsigned(30 downto 0);
 variable VAR_BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_right : unsigned(30 downto 0);
 variable VAR_BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_return_output : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_expr : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_return_output : unsigned(0 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_x := VAR_left;
     VAR_lunsigned_BIN_OP_GT_int33_t_int32_t_c_l16_c14_763b_0 := resize(unsigned(std_logic_vector(VAR_left)),31);
     VAR_rsigned_BIN_OP_GT_int33_t_int32_t_c_l10_c13_09f7_0 := resize(VAR_right, 33);
     VAR_runsigned_BIN_OP_GT_int33_t_int32_t_c_l17_c14_987d_0 := resize(unsigned(std_logic_vector(VAR_right)),31);
     VAR_BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_left := VAR_lunsigned_BIN_OP_GT_int33_t_int32_t_c_l16_c14_763b_0;
     VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_x := VAR_rsigned_BIN_OP_GT_int33_t_int32_t_c_l10_c13_09f7_0;
     VAR_BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_right := VAR_runsigned_BIN_OP_GT_int33_t_int32_t_c_l17_c14_987d_0;
     -- CONST_SR_31[BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432] LATENCY=0
     -- Inputs
     CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_x <= VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_x;
     -- Outputs
     VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_return_output := CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_return_output;

     -- BIN_OP_GT[BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081] LATENCY=0
     -- Inputs
     BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_left <= VAR_BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_left;
     BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_right <= VAR_BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_right;
     -- Outputs
     VAR_BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_return_output := BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_return_output;

     -- int33_32_32[BIN_OP_GT_int33_t_int32_t_c_l7_c21_69e1] LATENCY=0
     VAR_int33_32_32_BIN_OP_GT_int33_t_int32_t_c_l7_c21_69e1_return_output := int33_32_32(
     VAR_left);

     -- CONST_SR_31[BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a] LATENCY=0
     -- Inputs
     CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_x <= VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_x;
     -- Outputs
     VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_return_output := CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_return_output;

     -- Submodule level 1
     VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iftrue := VAR_BIN_OP_GT_BIN_OP_GT_int33_t_int32_t_c_l22_c14_f081_return_output;
     VAR_extra_sign_bits_BIN_OP_GT_int33_t_int32_t_c_l12_c13_f142_0 := resize(unsigned(std_logic_vector(VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l12_c31_5a5a_return_output)),2);
     VAR_sign_ext_like_zero_BIN_OP_GT_int33_t_int32_t_c_l13_c13_8cc9_0 := resize(unsigned(std_logic_vector(VAR_CONST_SR_31_BIN_OP_GT_int33_t_int32_t_c_l13_c34_5432_return_output)),2);
     VAR_UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_expr := VAR_int33_32_32_BIN_OP_GT_int33_t_int32_t_c_l7_c21_69e1_return_output;
     VAR_BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_left := VAR_extra_sign_bits_BIN_OP_GT_int33_t_int32_t_c_l12_c13_f142_0;
     VAR_BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_right := VAR_sign_ext_like_zero_BIN_OP_GT_int33_t_int32_t_c_l13_c13_8cc9_0;
     -- BIN_OP_EQ[BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990] LATENCY=0
     -- Inputs
     BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_left <= VAR_BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_left;
     BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_right <= VAR_BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_right;
     -- Outputs
     VAR_BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_return_output := BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_return_output;

     -- UNARY_OP_NOT[BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9] LATENCY=0
     -- Inputs
     UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_expr <= VAR_UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_expr;
     -- Outputs
     VAR_UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_return_output := UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_return_output;

     -- Submodule level 2
     VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_cond := VAR_BIN_OP_EQ_BIN_OP_GT_int33_t_int32_t_c_l20_c8_f990_return_output;
     VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iffalse := VAR_UNARY_OP_NOT_BIN_OP_GT_int33_t_int32_t_c_l28_c15_2fd9_return_output;
     -- rv_MUX[BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959] LATENCY=0
     -- Inputs
     rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_cond <= VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_cond;
     rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iftrue <= VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iftrue;
     rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iffalse <= VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_iffalse;
     -- Outputs
     VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_return_output := rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_return_output;

     -- Submodule level 3
     VAR_return_output := VAR_rv_MUX_BIN_OP_GT_int33_t_int32_t_c_l20_c5_9959_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
