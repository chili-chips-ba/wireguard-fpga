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
entity BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a is
port(
 left : in signed(16 downto 0);
 right : in signed(31 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a;
architecture arch of BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- CONST_SR_16[BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929]
signal CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_x : signed(31 downto 0);
signal CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_return_output : signed(31 downto 0);

-- CONST_SR_16[BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f]
signal CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_x : signed(31 downto 0);
signal CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_return_output : signed(31 downto 0);

-- BIN_OP_EQ[BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6]
signal BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_left : unsigned(15 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_right : unsigned(15 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_return_output : unsigned(0 downto 0);

-- rv_MUX[BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718]
signal rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_cond : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iftrue : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iffalse : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_return_output : unsigned(0 downto 0);

-- BIN_OP_GT[BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45]
signal BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_left : unsigned(15 downto 0);
signal BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_right : unsigned(15 downto 0);
signal BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_return_output : unsigned(0 downto 0);

function int32_31_31( x : signed) return unsigned is
--variable x : signed(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(31- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929 : 0 clocks latency
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929 : entity work.CONST_SR_16_int32_t_0CLK_de264c78 port map (
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_x,
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_return_output);

-- CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f : 0 clocks latency
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f : entity work.CONST_SR_16_int32_t_0CLK_de264c78 port map (
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_x,
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_return_output);

-- BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6 : 0 clocks latency
BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6 : entity work.BIN_OP_EQ_uint16_t_uint16_t_0CLK_de264c78 port map (
BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_left,
BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_right,
BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_return_output);

-- rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718 : 0 clocks latency
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_cond,
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iftrue,
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iffalse,
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_return_output);

-- BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45 : 0 clocks latency
BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45 : entity work.BIN_OP_GT_uint16_t_uint16_t_0CLK_380ecc95 port map (
BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_left,
BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_right,
BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_return_output,
 CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_return_output,
 BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_return_output,
 rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_return_output,
 BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : signed(16 downto 0);
 variable VAR_right : signed(31 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_lsign : unsigned(0 downto 0);
 variable VAR_rsign : unsigned(0 downto 0);
 variable VAR_int32_31_31_BIN_OP_GT_int17_t_int32_t_c_l8_c21_e912_return_output : unsigned(0 downto 0);
 variable VAR_lsigned : signed(31 downto 0);
 variable VAR_lsigned_BIN_OP_GT_int17_t_int32_t_c_l9_c13_4e61_0 : signed(31 downto 0);
 variable VAR_rsigned : signed(31 downto 0);
 variable VAR_extra_sign_bits : unsigned(15 downto 0);
 variable VAR_extra_sign_bits_BIN_OP_GT_int17_t_int32_t_c_l12_c14_5019_0 : unsigned(15 downto 0);
 variable VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_return_output : signed(31 downto 0);
 variable VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_x : signed(31 downto 0);
 variable VAR_sign_ext_like_zero : unsigned(15 downto 0);
 variable VAR_sign_ext_like_zero_BIN_OP_GT_int17_t_int32_t_c_l13_c14_a59a_0 : unsigned(15 downto 0);
 variable VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_return_output : signed(31 downto 0);
 variable VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_x : signed(31 downto 0);
 variable VAR_lunsigned : unsigned(15 downto 0);
 variable VAR_lunsigned_BIN_OP_GT_int17_t_int32_t_c_l16_c14_457c_0 : unsigned(15 downto 0);
 variable VAR_runsigned : unsigned(15 downto 0);
 variable VAR_runsigned_BIN_OP_GT_int17_t_int32_t_c_l17_c14_fa9e_0 : unsigned(15 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_right : unsigned(15 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iftrue : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iffalse : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_right : unsigned(15 downto 0);
 variable VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_return_output : unsigned(0 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_lsigned_BIN_OP_GT_int17_t_int32_t_c_l9_c13_4e61_0 := resize(VAR_left, 32);
     VAR_lunsigned_BIN_OP_GT_int17_t_int32_t_c_l16_c14_457c_0 := resize(unsigned(std_logic_vector(VAR_left)),16);
     VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_x := VAR_right;
     VAR_runsigned_BIN_OP_GT_int17_t_int32_t_c_l17_c14_fa9e_0 := resize(unsigned(std_logic_vector(VAR_right)),16);
     VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_x := VAR_lsigned_BIN_OP_GT_int17_t_int32_t_c_l9_c13_4e61_0;
     VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_left := VAR_lunsigned_BIN_OP_GT_int17_t_int32_t_c_l16_c14_457c_0;
     VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_right := VAR_runsigned_BIN_OP_GT_int17_t_int32_t_c_l17_c14_fa9e_0;
     -- int32_31_31[BIN_OP_GT_int17_t_int32_t_c_l8_c21_e912] LATENCY=0
     VAR_int32_31_31_BIN_OP_GT_int17_t_int32_t_c_l8_c21_e912_return_output := int32_31_31(
     VAR_right);

     -- CONST_SR_16[BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f] LATENCY=0
     -- Inputs
     CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_x <= VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_x;
     -- Outputs
     VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_return_output := CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_return_output;

     -- CONST_SR_16[BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929] LATENCY=0
     -- Inputs
     CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_x <= VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_x;
     -- Outputs
     VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_return_output := CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_return_output;

     -- BIN_OP_GT[BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45] LATENCY=0
     -- Inputs
     BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_left <= VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_left;
     BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_right <= VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_right;
     -- Outputs
     VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_return_output := BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_return_output;

     -- Submodule level 1
     VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iftrue := VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_8d45_return_output;
     VAR_extra_sign_bits_BIN_OP_GT_int17_t_int32_t_c_l12_c14_5019_0 := resize(unsigned(std_logic_vector(VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_1929_return_output)),16);
     VAR_sign_ext_like_zero_BIN_OP_GT_int17_t_int32_t_c_l13_c14_a59a_0 := resize(unsigned(std_logic_vector(VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_0a7f_return_output)),16);
     VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iffalse := VAR_int32_31_31_BIN_OP_GT_int17_t_int32_t_c_l8_c21_e912_return_output;
     VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_left := VAR_extra_sign_bits_BIN_OP_GT_int17_t_int32_t_c_l12_c14_5019_0;
     VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_right := VAR_sign_ext_like_zero_BIN_OP_GT_int17_t_int32_t_c_l13_c14_a59a_0;
     -- BIN_OP_EQ[BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6] LATENCY=0
     -- Inputs
     BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_left <= VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_left;
     BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_right <= VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_right;
     -- Outputs
     VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_return_output := BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_return_output;

     -- Submodule level 2
     VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_cond := VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_55b6_return_output;
     -- rv_MUX[BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718] LATENCY=0
     -- Inputs
     rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_cond <= VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_cond;
     rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iftrue <= VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iftrue;
     rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iffalse <= VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_iffalse;
     -- Outputs
     VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_return_output := rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_return_output;

     -- Submodule level 3
     VAR_return_output := VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_1718_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
