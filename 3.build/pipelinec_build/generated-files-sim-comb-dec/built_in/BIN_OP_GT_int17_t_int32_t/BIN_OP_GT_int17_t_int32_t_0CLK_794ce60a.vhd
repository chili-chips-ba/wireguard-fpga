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
-- CONST_SR_16[BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27]
signal CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_x : signed(31 downto 0);
signal CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_return_output : signed(31 downto 0);

-- CONST_SR_16[BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da]
signal CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_x : signed(31 downto 0);
signal CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_return_output : signed(31 downto 0);

-- BIN_OP_EQ[BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66]
signal BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_left : unsigned(15 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_right : unsigned(15 downto 0);
signal BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_return_output : unsigned(0 downto 0);

-- rv_MUX[BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64]
signal rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_cond : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iftrue : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iffalse : unsigned(0 downto 0);
signal rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_return_output : unsigned(0 downto 0);

-- BIN_OP_GT[BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007]
signal BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_left : unsigned(15 downto 0);
signal BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_right : unsigned(15 downto 0);
signal BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_return_output : unsigned(0 downto 0);

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
-- CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27 : 0 clocks latency
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27 : entity work.CONST_SR_16_int32_t_0CLK_de264c78 port map (
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_x,
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_return_output);

-- CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da : 0 clocks latency
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da : entity work.CONST_SR_16_int32_t_0CLK_de264c78 port map (
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_x,
CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_return_output);

-- BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66 : 0 clocks latency
BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66 : entity work.BIN_OP_EQ_uint16_t_uint16_t_0CLK_de264c78 port map (
BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_left,
BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_right,
BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_return_output);

-- rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64 : 0 clocks latency
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_cond,
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iftrue,
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iffalse,
rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_return_output);

-- BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007 : 0 clocks latency
BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007 : entity work.BIN_OP_GT_uint16_t_uint16_t_0CLK_380ecc95 port map (
BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_left,
BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_right,
BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_return_output,
 CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_return_output,
 BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_return_output,
 rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_return_output,
 BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : signed(16 downto 0);
 variable VAR_right : signed(31 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_lsign : unsigned(0 downto 0);
 variable VAR_rsign : unsigned(0 downto 0);
 variable VAR_int32_31_31_BIN_OP_GT_int17_t_int32_t_c_l8_c21_d10e_return_output : unsigned(0 downto 0);
 variable VAR_lsigned : signed(31 downto 0);
 variable VAR_lsigned_BIN_OP_GT_int17_t_int32_t_c_l9_c13_bda6_0 : signed(31 downto 0);
 variable VAR_rsigned : signed(31 downto 0);
 variable VAR_extra_sign_bits : unsigned(15 downto 0);
 variable VAR_extra_sign_bits_BIN_OP_GT_int17_t_int32_t_c_l12_c14_b1e9_0 : unsigned(15 downto 0);
 variable VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_return_output : signed(31 downto 0);
 variable VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_x : signed(31 downto 0);
 variable VAR_sign_ext_like_zero : unsigned(15 downto 0);
 variable VAR_sign_ext_like_zero_BIN_OP_GT_int17_t_int32_t_c_l13_c14_4e0e_0 : unsigned(15 downto 0);
 variable VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_return_output : signed(31 downto 0);
 variable VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_x : signed(31 downto 0);
 variable VAR_lunsigned : unsigned(15 downto 0);
 variable VAR_lunsigned_BIN_OP_GT_int17_t_int32_t_c_l16_c14_3b07_0 : unsigned(15 downto 0);
 variable VAR_runsigned : unsigned(15 downto 0);
 variable VAR_runsigned_BIN_OP_GT_int17_t_int32_t_c_l17_c14_edfd_0 : unsigned(15 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_right : unsigned(15 downto 0);
 variable VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iftrue : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iffalse : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_return_output : unsigned(0 downto 0);
 variable VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_right : unsigned(15 downto 0);
 variable VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_return_output : unsigned(0 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_lsigned_BIN_OP_GT_int17_t_int32_t_c_l9_c13_bda6_0 := resize(VAR_left, 32);
     VAR_lunsigned_BIN_OP_GT_int17_t_int32_t_c_l16_c14_3b07_0 := resize(unsigned(std_logic_vector(VAR_left)),16);
     VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_x := VAR_right;
     VAR_runsigned_BIN_OP_GT_int17_t_int32_t_c_l17_c14_edfd_0 := resize(unsigned(std_logic_vector(VAR_right)),16);
     VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_x := VAR_lsigned_BIN_OP_GT_int17_t_int32_t_c_l9_c13_bda6_0;
     VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_left := VAR_lunsigned_BIN_OP_GT_int17_t_int32_t_c_l16_c14_3b07_0;
     VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_right := VAR_runsigned_BIN_OP_GT_int17_t_int32_t_c_l17_c14_edfd_0;
     -- CONST_SR_16[BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da] LATENCY=0
     -- Inputs
     CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_x <= VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_x;
     -- Outputs
     VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_return_output := CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_return_output;

     -- int32_31_31[BIN_OP_GT_int17_t_int32_t_c_l8_c21_d10e] LATENCY=0
     VAR_int32_31_31_BIN_OP_GT_int17_t_int32_t_c_l8_c21_d10e_return_output := int32_31_31(
     VAR_right);

     -- CONST_SR_16[BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27] LATENCY=0
     -- Inputs
     CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_x <= VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_x;
     -- Outputs
     VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_return_output := CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_return_output;

     -- BIN_OP_GT[BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007] LATENCY=0
     -- Inputs
     BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_left <= VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_left;
     BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_right <= VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_right;
     -- Outputs
     VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_return_output := BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_return_output;

     -- Submodule level 1
     VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iftrue := VAR_BIN_OP_GT_BIN_OP_GT_int17_t_int32_t_c_l22_c14_e007_return_output;
     VAR_extra_sign_bits_BIN_OP_GT_int17_t_int32_t_c_l12_c14_b1e9_0 := resize(unsigned(std_logic_vector(VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l12_c32_5e27_return_output)),16);
     VAR_sign_ext_like_zero_BIN_OP_GT_int17_t_int32_t_c_l13_c14_4e0e_0 := resize(unsigned(std_logic_vector(VAR_CONST_SR_16_BIN_OP_GT_int17_t_int32_t_c_l13_c35_90da_return_output)),16);
     VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iffalse := VAR_int32_31_31_BIN_OP_GT_int17_t_int32_t_c_l8_c21_d10e_return_output;
     VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_left := VAR_extra_sign_bits_BIN_OP_GT_int17_t_int32_t_c_l12_c14_b1e9_0;
     VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_right := VAR_sign_ext_like_zero_BIN_OP_GT_int17_t_int32_t_c_l13_c14_4e0e_0;
     -- BIN_OP_EQ[BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66] LATENCY=0
     -- Inputs
     BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_left <= VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_left;
     BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_right <= VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_right;
     -- Outputs
     VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_return_output := BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_return_output;

     -- Submodule level 2
     VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_cond := VAR_BIN_OP_EQ_BIN_OP_GT_int17_t_int32_t_c_l20_c8_6f66_return_output;
     -- rv_MUX[BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64] LATENCY=0
     -- Inputs
     rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_cond <= VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_cond;
     rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iftrue <= VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iftrue;
     rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iffalse <= VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_iffalse;
     -- Outputs
     VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_return_output := rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_return_output;

     -- Submodule level 3
     VAR_return_output := VAR_rv_MUX_BIN_OP_GT_int17_t_int32_t_c_l20_c5_df64_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
