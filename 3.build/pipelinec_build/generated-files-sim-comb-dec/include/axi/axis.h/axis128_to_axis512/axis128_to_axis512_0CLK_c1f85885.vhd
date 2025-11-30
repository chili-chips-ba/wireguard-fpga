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
-- Submodules: 35
entity axis128_to_axis512_0CLK_c1f85885 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 axis_in : in axis128_t_stream_t;
 axis_out_ready : in unsigned(0 downto 0);
 return_output : out axis128_to_axis512_t);
end axis128_to_axis512_0CLK_c1f85885;
architecture arch of axis128_to_axis512_0CLK_c1f85885 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal axis_in_reg : axis128_t_stream_t := axis128_t_stream_t_NULL;
signal axis_out_reg : axis512_t_stream_t := axis512_t_stream_t_NULL;
signal REG_COMB_axis_in_reg : axis128_t_stream_t;
signal REG_COMB_axis_out_reg : axis512_t_stream_t;

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- BIN_OP_AND[axis_h_l377_c6_330b]
signal BIN_OP_AND_axis_h_l377_c6_330b_left : unsigned(0 downto 0);
signal BIN_OP_AND_axis_h_l377_c6_330b_right : unsigned(0 downto 0);
signal BIN_OP_AND_axis_h_l377_c6_330b_return_output : unsigned(0 downto 0);

-- axis_out_reg_data_tlast_MUX[axis_h_l377_c3_eeff]
signal axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_cond : unsigned(0 downto 0);
signal axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iftrue : unsigned(0 downto 0);
signal axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iffalse : unsigned(0 downto 0);
signal axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_return_output : unsigned(0 downto 0);

-- axis_out_reg_valid_MUX[axis_h_l377_c3_eeff]
signal axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_cond : unsigned(0 downto 0);
signal axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iftrue : unsigned(0 downto 0);
signal axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iffalse : unsigned(0 downto 0);
signal axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_return_output : unsigned(0 downto 0);

-- axis_out_reg_data_tkeep_MUX[axis_h_l377_c3_eeff]
signal axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_cond : unsigned(0 downto 0);
signal axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iftrue : uint1_t_64;
signal axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iffalse : uint1_t_64;
signal axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_return_output : uint1_t_64;

-- UNARY_OP_NOT[axis_h_l388_c28_5299]
signal UNARY_OP_NOT_axis_h_l388_c28_5299_expr : unsigned(0 downto 0);
signal UNARY_OP_NOT_axis_h_l388_c28_5299_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[axis_h_l389_c6_78ee]
signal BIN_OP_AND_axis_h_l389_c6_78ee_left : unsigned(0 downto 0);
signal BIN_OP_AND_axis_h_l389_c6_78ee_right : unsigned(0 downto 0);
signal BIN_OP_AND_axis_h_l389_c6_78ee_return_output : unsigned(0 downto 0);

-- axis_in_reg_data_tkeep_MUX[axis_h_l389_c3_ce98]
signal axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_cond : unsigned(0 downto 0);
signal axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iftrue : uint1_t_16;
signal axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iffalse : uint1_t_16;
signal axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_return_output : uint1_t_16;

-- axis_in_reg_data_tlast_MUX[axis_h_l389_c3_ce98]
signal axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_cond : unsigned(0 downto 0);
signal axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iftrue : unsigned(0 downto 0);
signal axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iffalse : unsigned(0 downto 0);
signal axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_return_output : unsigned(0 downto 0);

-- axis_in_reg_valid_MUX[axis_h_l389_c3_ce98]
signal axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_cond : unsigned(0 downto 0);
signal axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iftrue : unsigned(0 downto 0);
signal axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iffalse : unsigned(0 downto 0);
signal axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_return_output : unsigned(0 downto 0);

-- axis_out_reg_MUX[axis_h_l389_c3_ce98]
signal axis_out_reg_MUX_axis_h_l389_c3_ce98_cond : unsigned(0 downto 0);
signal axis_out_reg_MUX_axis_h_l389_c3_ce98_iftrue : axis512_t_stream_t;
signal axis_out_reg_MUX_axis_h_l389_c3_ce98_iffalse : axis512_t_stream_t;
signal axis_out_reg_MUX_axis_h_l389_c3_ce98_return_output : axis512_t_stream_t;

-- axis512_to_axis128_array[axis_h_l393_c43_2f4f]
signal axis512_to_axis128_array_axis_h_l393_c43_2f4f_axis : axis512_t;
signal axis512_to_axis128_array_axis_h_l393_c43_2f4f_return_output : axis512_to_axis128_array_t;

-- axis_out_as_chunks_MUX[axis_h_l407_c5_9926]
signal axis_out_as_chunks_MUX_axis_h_l407_c5_9926_cond : unsigned(0 downto 0);
signal axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iftrue : axis128_t_stream_t_4;
signal axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iffalse : axis128_t_stream_t_4;
signal axis_out_as_chunks_MUX_axis_h_l407_c5_9926_return_output : axis128_t_stream_t_4;

-- FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT[axis_h_l415_c13_854b]
signal FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_expr : unsigned(0 downto 0);
signal FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output : unsigned(0 downto 0);

-- FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX[axis_h_l415_c9_5b37]
signal FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond : unsigned(0 downto 0);
signal FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue : axis128_t_stream_t_4;
signal FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse : axis128_t_stream_t_4;
signal FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output : axis128_t_stream_t_4;

-- FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT[axis_h_l415_c13_854b]
signal FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_expr : unsigned(0 downto 0);
signal FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output : unsigned(0 downto 0);

-- FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX[axis_h_l415_c9_5b37]
signal FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond : unsigned(0 downto 0);
signal FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue : axis128_t_stream_t_4;
signal FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse : axis128_t_stream_t_4;
signal FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output : axis128_t_stream_t_4;

-- FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT[axis_h_l415_c13_854b]
signal FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_expr : unsigned(0 downto 0);
signal FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output : unsigned(0 downto 0);

-- FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX[axis_h_l415_c9_5b37]
signal FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond : unsigned(0 downto 0);
signal FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue : axis128_t_stream_t_4;
signal FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse : axis128_t_stream_t_4;
signal FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output : axis128_t_stream_t_4;

-- axis128_array_to_axis512[axis_h_l424_c25_2426]
signal axis128_array_to_axis512_axis_h_l424_c25_2426_axis_chunks : axis128_t_stream_t_4;
signal axis128_array_to_axis512_axis_h_l424_c25_2426_return_output : axis512_t;

-- UNARY_OP_NOT[axis_h_l432_c22_cc00]
signal UNARY_OP_NOT_axis_h_l432_c22_cc00_expr : unsigned(0 downto 0);
signal UNARY_OP_NOT_axis_h_l432_c22_cc00_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[axis_h_l433_c6_c70f]
signal BIN_OP_AND_axis_h_l433_c6_c70f_left : unsigned(0 downto 0);
signal BIN_OP_AND_axis_h_l433_c6_c70f_right : unsigned(0 downto 0);
signal BIN_OP_AND_axis_h_l433_c6_c70f_return_output : unsigned(0 downto 0);

-- axis_in_reg_MUX[axis_h_l433_c3_9317]
signal axis_in_reg_MUX_axis_h_l433_c3_9317_cond : unsigned(0 downto 0);
signal axis_in_reg_MUX_axis_h_l433_c3_9317_iftrue : axis128_t_stream_t;
signal axis_in_reg_MUX_axis_h_l433_c3_9317_iffalse : axis128_t_stream_t;
signal axis_in_reg_MUX_axis_h_l433_c3_9317_return_output : axis128_t_stream_t;

function CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_out_valid_01c3( ref_toks_0 : axis512_t_stream_t) return unsigned is
 
  variable base : axis128_to_axis512_t; 
  variable return_output : unsigned(0 downto 0);
begin
      base.axis_out := ref_toks_0;

      return_output := base.axis_out.valid;
      return return_output; 
end function;

function CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_3b4a( ref_toks_0 : unsigned;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned;
 ref_toks_4 : unsigned;
 ref_toks_5 : unsigned;
 ref_toks_6 : unsigned;
 ref_toks_7 : unsigned;
 ref_toks_8 : unsigned;
 ref_toks_9 : unsigned;
 ref_toks_10 : unsigned;
 ref_toks_11 : unsigned;
 ref_toks_12 : unsigned;
 ref_toks_13 : unsigned;
 ref_toks_14 : unsigned;
 ref_toks_15 : unsigned;
 ref_toks_16 : unsigned;
 ref_toks_17 : unsigned;
 ref_toks_18 : unsigned;
 ref_toks_19 : unsigned;
 ref_toks_20 : unsigned;
 ref_toks_21 : unsigned;
 ref_toks_22 : unsigned;
 ref_toks_23 : unsigned;
 ref_toks_24 : unsigned;
 ref_toks_25 : unsigned;
 ref_toks_26 : unsigned;
 ref_toks_27 : unsigned;
 ref_toks_28 : unsigned;
 ref_toks_29 : unsigned;
 ref_toks_30 : unsigned;
 ref_toks_31 : unsigned;
 ref_toks_32 : unsigned;
 ref_toks_33 : unsigned;
 ref_toks_34 : unsigned;
 ref_toks_35 : unsigned;
 ref_toks_36 : unsigned;
 ref_toks_37 : unsigned;
 ref_toks_38 : unsigned;
 ref_toks_39 : unsigned;
 ref_toks_40 : unsigned;
 ref_toks_41 : unsigned;
 ref_toks_42 : unsigned;
 ref_toks_43 : unsigned;
 ref_toks_44 : unsigned;
 ref_toks_45 : unsigned;
 ref_toks_46 : unsigned;
 ref_toks_47 : unsigned;
 ref_toks_48 : unsigned;
 ref_toks_49 : unsigned;
 ref_toks_50 : unsigned;
 ref_toks_51 : unsigned;
 ref_toks_52 : unsigned;
 ref_toks_53 : unsigned;
 ref_toks_54 : unsigned;
 ref_toks_55 : unsigned;
 ref_toks_56 : unsigned;
 ref_toks_57 : unsigned;
 ref_toks_58 : unsigned;
 ref_toks_59 : unsigned;
 ref_toks_60 : unsigned;
 ref_toks_61 : unsigned;
 ref_toks_62 : unsigned;
 ref_toks_63 : unsigned) return uint1_t_64 is
 
  variable base : axis512_t_stream_t; 
  variable return_output : uint1_t_64;
begin
      base.data.tkeep(0) := ref_toks_0;
      base.data.tkeep(1) := ref_toks_1;
      base.data.tkeep(2) := ref_toks_2;
      base.data.tkeep(3) := ref_toks_3;
      base.data.tkeep(4) := ref_toks_4;
      base.data.tkeep(5) := ref_toks_5;
      base.data.tkeep(6) := ref_toks_6;
      base.data.tkeep(7) := ref_toks_7;
      base.data.tkeep(8) := ref_toks_8;
      base.data.tkeep(9) := ref_toks_9;
      base.data.tkeep(10) := ref_toks_10;
      base.data.tkeep(11) := ref_toks_11;
      base.data.tkeep(12) := ref_toks_12;
      base.data.tkeep(13) := ref_toks_13;
      base.data.tkeep(14) := ref_toks_14;
      base.data.tkeep(15) := ref_toks_15;
      base.data.tkeep(16) := ref_toks_16;
      base.data.tkeep(17) := ref_toks_17;
      base.data.tkeep(18) := ref_toks_18;
      base.data.tkeep(19) := ref_toks_19;
      base.data.tkeep(20) := ref_toks_20;
      base.data.tkeep(21) := ref_toks_21;
      base.data.tkeep(22) := ref_toks_22;
      base.data.tkeep(23) := ref_toks_23;
      base.data.tkeep(24) := ref_toks_24;
      base.data.tkeep(25) := ref_toks_25;
      base.data.tkeep(26) := ref_toks_26;
      base.data.tkeep(27) := ref_toks_27;
      base.data.tkeep(28) := ref_toks_28;
      base.data.tkeep(29) := ref_toks_29;
      base.data.tkeep(30) := ref_toks_30;
      base.data.tkeep(31) := ref_toks_31;
      base.data.tkeep(32) := ref_toks_32;
      base.data.tkeep(33) := ref_toks_33;
      base.data.tkeep(34) := ref_toks_34;
      base.data.tkeep(35) := ref_toks_35;
      base.data.tkeep(36) := ref_toks_36;
      base.data.tkeep(37) := ref_toks_37;
      base.data.tkeep(38) := ref_toks_38;
      base.data.tkeep(39) := ref_toks_39;
      base.data.tkeep(40) := ref_toks_40;
      base.data.tkeep(41) := ref_toks_41;
      base.data.tkeep(42) := ref_toks_42;
      base.data.tkeep(43) := ref_toks_43;
      base.data.tkeep(44) := ref_toks_44;
      base.data.tkeep(45) := ref_toks_45;
      base.data.tkeep(46) := ref_toks_46;
      base.data.tkeep(47) := ref_toks_47;
      base.data.tkeep(48) := ref_toks_48;
      base.data.tkeep(49) := ref_toks_49;
      base.data.tkeep(50) := ref_toks_50;
      base.data.tkeep(51) := ref_toks_51;
      base.data.tkeep(52) := ref_toks_52;
      base.data.tkeep(53) := ref_toks_53;
      base.data.tkeep(54) := ref_toks_54;
      base.data.tkeep(55) := ref_toks_55;
      base.data.tkeep(56) := ref_toks_56;
      base.data.tkeep(57) := ref_toks_57;
      base.data.tkeep(58) := ref_toks_58;
      base.data.tkeep(59) := ref_toks_59;
      base.data.tkeep(60) := ref_toks_60;
      base.data.tkeep(61) := ref_toks_61;
      base.data.tkeep(62) := ref_toks_62;
      base.data.tkeep(63) := ref_toks_63;

      return_output := base.data.tkeep;
      return return_output; 
end function;

function CONST_REF_RD_axis512_t_axis512_t_stream_t_data_699e( ref_toks_0 : axis512_t_stream_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : uint1_t_64) return axis512_t is
 
  variable base : axis512_t_stream_t; 
  variable return_output : axis512_t;
begin
      base := ref_toks_0;
      base.data.tlast := ref_toks_1;
      base.data.tkeep := ref_toks_2;

      return_output := base.data;
      return return_output; 
end function;

function CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_4e8d( ref_toks_0 : axis128_t_stream_t) return unsigned is
 
  variable base : axis128_t_stream_t_4; 
  variable return_output : unsigned(0 downto 0);
begin
      base(0) := ref_toks_0;

      return_output := base(0).valid;
      return return_output; 
end function;

function CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346( ref_toks_0 : axis128_t_stream_t;
 ref_toks_1 : axis128_t_stream_t;
 ref_toks_2 : axis128_t_stream_t;
 ref_toks_3 : axis128_t_stream_t) return axis128_t_stream_t_4 is
 
  variable base : axis128_t_stream_t_4; 
  variable return_output : axis128_t_stream_t_4;
begin
      base(0) := ref_toks_0;
      base(1) := ref_toks_1;
      base(2) := ref_toks_2;
      base(3) := ref_toks_3;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_6f11( ref_toks_0 : unsigned;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned;
 ref_toks_4 : unsigned;
 ref_toks_5 : unsigned;
 ref_toks_6 : unsigned;
 ref_toks_7 : unsigned;
 ref_toks_8 : unsigned;
 ref_toks_9 : unsigned;
 ref_toks_10 : unsigned;
 ref_toks_11 : unsigned;
 ref_toks_12 : unsigned;
 ref_toks_13 : unsigned;
 ref_toks_14 : unsigned;
 ref_toks_15 : unsigned) return uint1_t_16 is
 
  variable base : axis128_t_stream_t; 
  variable return_output : uint1_t_16;
begin
      base.data.tkeep(0) := ref_toks_0;
      base.data.tkeep(1) := ref_toks_1;
      base.data.tkeep(2) := ref_toks_2;
      base.data.tkeep(3) := ref_toks_3;
      base.data.tkeep(4) := ref_toks_4;
      base.data.tkeep(5) := ref_toks_5;
      base.data.tkeep(6) := ref_toks_6;
      base.data.tkeep(7) := ref_toks_7;
      base.data.tkeep(8) := ref_toks_8;
      base.data.tkeep(9) := ref_toks_9;
      base.data.tkeep(10) := ref_toks_10;
      base.data.tkeep(11) := ref_toks_11;
      base.data.tkeep(12) := ref_toks_12;
      base.data.tkeep(13) := ref_toks_13;
      base.data.tkeep(14) := ref_toks_14;
      base.data.tkeep(15) := ref_toks_15;

      return_output := base.data.tkeep;
      return return_output; 
end function;

function CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_42b0( ref_toks_0 : axis512_t;
 ref_toks_1 : unsigned) return axis512_t_stream_t is
 
  variable base : axis512_t_stream_t; 
  variable return_output : axis512_t_stream_t;
begin
      base.data := ref_toks_0;
      base.valid := ref_toks_1;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_ad74( ref_toks_0 : axis512_t_stream_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : uint1_t_64;
 ref_toks_3 : unsigned) return axis512_t_stream_t is
 
  variable base : axis512_t_stream_t; 
  variable return_output : axis512_t_stream_t;
begin
      base := ref_toks_0;
      base.data.tlast := ref_toks_1;
      base.data.tkeep := ref_toks_2;
      base.valid := ref_toks_3;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4a8d( ref_toks_0 : axis128_t_stream_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : uint1_t_16) return axis128_t_stream_t is
 
  variable base : axis128_t_stream_t; 
  variable return_output : axis128_t_stream_t;
begin
      base := ref_toks_0;
      base.valid := ref_toks_1;
      base.data.tlast := ref_toks_2;
      base.data.tkeep := ref_toks_3;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_axis128_to_axis512_t_axis128_to_axis512_t_c1ed( ref_toks_0 : axis512_t_stream_t;
 ref_toks_1 : unsigned) return axis128_to_axis512_t is
 
  variable base : axis128_to_axis512_t; 
  variable return_output : axis128_to_axis512_t;
begin
      base.axis_out := ref_toks_0;
      base.axis_in_ready := ref_toks_1;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_AND_axis_h_l377_c6_330b : 0 clocks latency
BIN_OP_AND_axis_h_l377_c6_330b : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_axis_h_l377_c6_330b_left,
BIN_OP_AND_axis_h_l377_c6_330b_right,
BIN_OP_AND_axis_h_l377_c6_330b_return_output);

-- axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff : 0 clocks latency
axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_cond,
axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iftrue,
axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iffalse,
axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_return_output);

-- axis_out_reg_valid_MUX_axis_h_l377_c3_eeff : 0 clocks latency
axis_out_reg_valid_MUX_axis_h_l377_c3_eeff : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_cond,
axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iftrue,
axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iffalse,
axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_return_output);

-- axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff : 0 clocks latency
axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff : entity work.MUX_uint1_t_uint1_t_64_uint1_t_64_0CLK_de264c78 port map (
axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_cond,
axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iftrue,
axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iffalse,
axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_return_output);

-- UNARY_OP_NOT_axis_h_l388_c28_5299 : 0 clocks latency
UNARY_OP_NOT_axis_h_l388_c28_5299 : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
UNARY_OP_NOT_axis_h_l388_c28_5299_expr,
UNARY_OP_NOT_axis_h_l388_c28_5299_return_output);

-- BIN_OP_AND_axis_h_l389_c6_78ee : 0 clocks latency
BIN_OP_AND_axis_h_l389_c6_78ee : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_axis_h_l389_c6_78ee_left,
BIN_OP_AND_axis_h_l389_c6_78ee_right,
BIN_OP_AND_axis_h_l389_c6_78ee_return_output);

-- axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98 : 0 clocks latency
axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98 : entity work.MUX_uint1_t_uint1_t_16_uint1_t_16_0CLK_de264c78 port map (
axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_cond,
axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iftrue,
axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iffalse,
axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_return_output);

-- axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98 : 0 clocks latency
axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_cond,
axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iftrue,
axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iffalse,
axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_return_output);

-- axis_in_reg_valid_MUX_axis_h_l389_c3_ce98 : 0 clocks latency
axis_in_reg_valid_MUX_axis_h_l389_c3_ce98 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_cond,
axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iftrue,
axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iffalse,
axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_return_output);

-- axis_out_reg_MUX_axis_h_l389_c3_ce98 : 0 clocks latency
axis_out_reg_MUX_axis_h_l389_c3_ce98 : entity work.MUX_uint1_t_axis512_t_stream_t_axis512_t_stream_t_0CLK_de264c78 port map (
axis_out_reg_MUX_axis_h_l389_c3_ce98_cond,
axis_out_reg_MUX_axis_h_l389_c3_ce98_iftrue,
axis_out_reg_MUX_axis_h_l389_c3_ce98_iffalse,
axis_out_reg_MUX_axis_h_l389_c3_ce98_return_output);

-- axis512_to_axis128_array_axis_h_l393_c43_2f4f : 0 clocks latency
axis512_to_axis128_array_axis_h_l393_c43_2f4f : entity work.axis512_to_axis128_array_0CLK_4b8d8b28 port map (
axis512_to_axis128_array_axis_h_l393_c43_2f4f_axis,
axis512_to_axis128_array_axis_h_l393_c43_2f4f_return_output);

-- axis_out_as_chunks_MUX_axis_h_l407_c5_9926 : 0 clocks latency
axis_out_as_chunks_MUX_axis_h_l407_c5_9926 : entity work.MUX_uint1_t_axis128_t_stream_t_4_axis128_t_stream_t_4_0CLK_de264c78 port map (
axis_out_as_chunks_MUX_axis_h_l407_c5_9926_cond,
axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iftrue,
axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iffalse,
axis_out_as_chunks_MUX_axis_h_l407_c5_9926_return_output);

-- FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b : 0 clocks latency
FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_expr,
FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output);

-- FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37 : 0 clocks latency
FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37 : entity work.MUX_uint1_t_axis128_t_stream_t_4_axis128_t_stream_t_4_0CLK_de264c78 port map (
FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond,
FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue,
FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse,
FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output);

-- FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b : 0 clocks latency
FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_expr,
FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output);

-- FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37 : 0 clocks latency
FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37 : entity work.MUX_uint1_t_axis128_t_stream_t_4_axis128_t_stream_t_4_0CLK_de264c78 port map (
FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond,
FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue,
FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse,
FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output);

-- FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b : 0 clocks latency
FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_expr,
FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output);

-- FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37 : 0 clocks latency
FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37 : entity work.MUX_uint1_t_axis128_t_stream_t_4_axis128_t_stream_t_4_0CLK_de264c78 port map (
FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond,
FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue,
FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse,
FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output);

-- axis128_array_to_axis512_axis_h_l424_c25_2426 : 0 clocks latency
axis128_array_to_axis512_axis_h_l424_c25_2426 : entity work.axis128_array_to_axis512_0CLK_fcdf4ca0 port map (
axis128_array_to_axis512_axis_h_l424_c25_2426_axis_chunks,
axis128_array_to_axis512_axis_h_l424_c25_2426_return_output);

-- UNARY_OP_NOT_axis_h_l432_c22_cc00 : 0 clocks latency
UNARY_OP_NOT_axis_h_l432_c22_cc00 : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
UNARY_OP_NOT_axis_h_l432_c22_cc00_expr,
UNARY_OP_NOT_axis_h_l432_c22_cc00_return_output);

-- BIN_OP_AND_axis_h_l433_c6_c70f : 0 clocks latency
BIN_OP_AND_axis_h_l433_c6_c70f : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_axis_h_l433_c6_c70f_left,
BIN_OP_AND_axis_h_l433_c6_c70f_right,
BIN_OP_AND_axis_h_l433_c6_c70f_return_output);

-- axis_in_reg_MUX_axis_h_l433_c3_9317 : 0 clocks latency
axis_in_reg_MUX_axis_h_l433_c3_9317 : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
axis_in_reg_MUX_axis_h_l433_c3_9317_cond,
axis_in_reg_MUX_axis_h_l433_c3_9317_iftrue,
axis_in_reg_MUX_axis_h_l433_c3_9317_iffalse,
axis_in_reg_MUX_axis_h_l433_c3_9317_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Inputs
 axis_in,
 axis_out_ready,
 -- Registers
 axis_in_reg,
 axis_out_reg,
 -- All submodule outputs
 BIN_OP_AND_axis_h_l377_c6_330b_return_output,
 axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_return_output,
 axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_return_output,
 axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_return_output,
 UNARY_OP_NOT_axis_h_l388_c28_5299_return_output,
 BIN_OP_AND_axis_h_l389_c6_78ee_return_output,
 axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_return_output,
 axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_return_output,
 axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_return_output,
 axis_out_reg_MUX_axis_h_l389_c3_ce98_return_output,
 axis512_to_axis128_array_axis_h_l393_c43_2f4f_return_output,
 axis_out_as_chunks_MUX_axis_h_l407_c5_9926_return_output,
 FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output,
 FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output,
 FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output,
 FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output,
 FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output,
 FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output,
 axis128_array_to_axis512_axis_h_l424_c25_2426_return_output,
 UNARY_OP_NOT_axis_h_l432_c22_cc00_return_output,
 BIN_OP_AND_axis_h_l433_c6_c70f_return_output,
 axis_in_reg_MUX_axis_h_l433_c3_9317_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : axis128_to_axis512_t;
 variable VAR_axis_in : axis128_t_stream_t;
 variable VAR_axis_out_ready : unsigned(0 downto 0);
 variable VAR_IN_SIZE : unsigned(31 downto 0);
 variable VAR_OUT_SIZE : unsigned(31 downto 0);
 variable VAR_o : axis128_to_axis512_t;
 variable VAR_CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_out_valid_01c3_axis_h_l377_c6_2d7b_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_axis_h_l377_c6_330b_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_axis_h_l377_c6_330b_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_axis_h_l377_c6_330b_return_output : unsigned(0 downto 0);
 variable VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iftrue : unsigned(0 downto 0);
 variable VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iffalse : unsigned(0 downto 0);
 variable VAR_axis_out_reg_data_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis512_t_stream_t_data_tlast_d41d_axis_h_l377_c3_eeff_return_output : unsigned(0 downto 0);
 variable VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_return_output : unsigned(0 downto 0);
 variable VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_cond : unsigned(0 downto 0);
 variable VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iftrue : unsigned(0 downto 0);
 variable VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iffalse : unsigned(0 downto 0);
 variable VAR_axis_out_reg_valid_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_axis_h_l377_c3_eeff_return_output : unsigned(0 downto 0);
 variable VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_return_output : unsigned(0 downto 0);
 variable VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_cond : unsigned(0 downto 0);
 variable VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iftrue : uint1_t_64;
 variable VAR_axis_out_reg_data_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_3b4a_axis_h_l377_c3_eeff_return_output : uint1_t_64;
 variable VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iffalse : uint1_t_64;
 variable VAR_axis_out_reg_data_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_d41d_axis_h_l377_c3_eeff_return_output : uint1_t_64;
 variable VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_return_output : uint1_t_64;
 variable VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_cond : unsigned(0 downto 0);
 variable VAR_ARRAY_SET_i : unsigned(31 downto 0);
 variable VAR_out_reg_ready : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_axis_h_l388_c28_5299_expr : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_axis_h_l388_c28_5299_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_axis_h_l389_c6_78ee_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_axis_h_l389_c6_78ee_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_axis_h_l389_c6_78ee_return_output : unsigned(0 downto 0);
 variable VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iftrue : uint1_t_16;
 variable VAR_axis_in_reg_data_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_6f11_axis_h_l389_c3_ce98_return_output : uint1_t_16;
 variable VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iffalse : uint1_t_16;
 variable VAR_axis_in_reg_data_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_d41d_axis_h_l389_c3_ce98_return_output : uint1_t_16;
 variable VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_return_output : uint1_t_16;
 variable VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_cond : unsigned(0 downto 0);
 variable VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iftrue : unsigned(0 downto 0);
 variable VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iffalse : unsigned(0 downto 0);
 variable VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_return_output : unsigned(0 downto 0);
 variable VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_cond : unsigned(0 downto 0);
 variable VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iftrue : unsigned(0 downto 0);
 variable VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iffalse : unsigned(0 downto 0);
 variable VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_return_output : unsigned(0 downto 0);
 variable VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_cond : unsigned(0 downto 0);
 variable VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_iftrue : axis512_t_stream_t;
 variable VAR_axis_out_reg_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_42b0_axis_h_l389_c3_ce98_return_output : axis512_t_stream_t;
 variable VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_iffalse : axis512_t_stream_t;
 variable VAR_axis_out_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_ad74_axis_h_l389_c3_ce98_return_output : axis512_t_stream_t;
 variable VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_return_output : axis512_t_stream_t;
 variable VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_cond : unsigned(0 downto 0);
 variable VAR_axis_out_as_chunks : axis128_t_stream_t_4;
 variable VAR_to_array : axis512_to_axis128_array_t;
 variable VAR_axis512_to_axis128_array_axis_h_l393_c43_2f4f_axis : axis512_t;
 variable VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_699e_axis_h_l393_c68_9934_return_output : axis512_t;
 variable VAR_axis512_to_axis128_array_axis_h_l393_c43_2f4f_return_output : axis512_to_axis128_array_t;
 variable VAR_CONST_REF_RD_axis128_t_stream_t_4_axis512_to_axis128_array_t_axis_chunks_d41d_axis_h_l394_c26_2c43_return_output : axis128_t_stream_t_4;
 variable VAR_ARRAY_SHIFT_DOWN_i : unsigned(31 downto 0);
 variable VAR_FOR_axis_h_l398_c34_71d8_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l398_c156_21d3_return_output : axis128_t_stream_t;
 variable VAR_FOR_axis_h_l398_c34_71d8_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l398_c156_21d3_return_output : axis128_t_stream_t;
 variable VAR_FOR_axis_h_l398_c34_71d8_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l398_c156_21d3_return_output : axis128_t_stream_t;
 variable VAR_last_cycle : unsigned(0 downto 0);
 variable VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iftrue : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output : axis128_t_stream_t_4;
 variable VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iffalse : axis128_t_stream_t_4;
 variable VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_return_output : axis128_t_stream_t_4;
 variable VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_cond : unsigned(0 downto 0);
 variable VAR_i : unsigned(31 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_4e8d_axis_h_l415_c13_3456_return_output : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_expr : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l415_c9_5b37_return_output : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond : unsigned(0 downto 0);
 variable VAR_NULL_CHUNK : axis128_t_stream_t;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d_axis_h_l415_c13_3456_return_output : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_expr : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l415_c9_5b37_return_output : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l418_c162_b935_return_output : axis128_t_stream_t;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l418_c162_b935_return_output : axis128_t_stream_t;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l418_c162_b935_return_output : axis128_t_stream_t;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d_axis_h_l415_c13_3456_return_output : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_expr : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l415_c9_5b37_return_output : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse : axis128_t_stream_t_4;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond : unsigned(0 downto 0);
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l418_c162_b935_return_output : axis128_t_stream_t;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l418_c162_b935_return_output : axis128_t_stream_t;
 variable VAR_FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l418_c162_b935_return_output : axis128_t_stream_t;
 variable VAR_axis128_array_to_axis512_axis_h_l424_c25_2426_axis_chunks : axis128_t_stream_t_4;
 variable VAR_axis128_array_to_axis512_axis_h_l424_c25_2426_return_output : axis512_t;
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d_axis_h_l427_c26_7b26_return_output : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_axis_h_l432_c22_cc00_expr : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_axis_h_l432_c22_cc00_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_axis_h_l433_c6_7351_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_axis_h_l433_c6_c70f_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_axis_h_l433_c6_c70f_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_axis_h_l433_c6_c70f_return_output : unsigned(0 downto 0);
 variable VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_iftrue : axis128_t_stream_t;
 variable VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_iffalse : axis128_t_stream_t;
 variable VAR_axis_in_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4a8d_axis_h_l433_c3_9317_return_output : axis128_t_stream_t;
 variable VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_return_output : axis128_t_stream_t;
 variable VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_axis128_to_axis512_t_axis128_to_axis512_t_c1ed_axis_h_l437_c10_b8a8_return_output : axis128_to_axis512_t;
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_axis_h_l389_DUPLICATE_e673_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_axis_h_l389_l399_DUPLICATE_62e0_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l407_l415_DUPLICATE_a15f_return_output : axis128_t_stream_t_4;
 -- State registers comb logic variables
variable REG_VAR_axis_in_reg : axis128_t_stream_t;
variable REG_VAR_axis_out_reg : axis512_t_stream_t;
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_axis_in_reg := axis_in_reg;
  REG_VAR_axis_out_reg := axis_out_reg;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iftrue := to_unsigned(0, 1);
     VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iftrue := to_unsigned(0, 1);
     VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iftrue := to_unsigned(0, 1);
     VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iftrue := to_unsigned(0, 1);
     -- axis_in_reg_data_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_6f11[axis_h_l389_c3_ce98] LATENCY=0
     VAR_axis_in_reg_data_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_6f11_axis_h_l389_c3_ce98_return_output := CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_6f11(
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1));

     -- axis_out_reg_data_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_3b4a[axis_h_l377_c3_eeff] LATENCY=0
     VAR_axis_out_reg_data_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_3b4a_axis_h_l377_c3_eeff_return_output := CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_3b4a(
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1),
     to_unsigned(0, 1));

     -- Submodule level 1
     VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iftrue := VAR_axis_out_reg_data_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_3b4a_axis_h_l377_c3_eeff_return_output;
     VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iftrue := VAR_axis_in_reg_data_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_6f11_axis_h_l389_c3_ce98_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;
     -- Mux in inputs
     VAR_axis_in := axis_in;
     VAR_axis_out_ready := axis_out_ready;

     -- Submodule level 0
     VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_iftrue := VAR_axis_in;
     VAR_BIN_OP_AND_axis_h_l377_c6_330b_right := VAR_axis_out_ready;
     -- axis_out_reg_data_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis512_t_stream_t_data_tlast_d41d[axis_h_l377_c3_eeff] LATENCY=0
     VAR_axis_out_reg_data_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis512_t_stream_t_data_tlast_d41d_axis_h_l377_c3_eeff_return_output := axis_out_reg.data.tlast;

     -- CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_out_valid_01c3[axis_h_l377_c6_2d7b] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_out_valid_01c3_axis_h_l377_c6_2d7b_return_output := CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_out_valid_01c3(
     axis_out_reg);

     -- axis_in_reg_data_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_d41d[axis_h_l389_c3_ce98] LATENCY=0
     VAR_axis_in_reg_data_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_d41d_axis_h_l389_c3_ce98_return_output := axis_in_reg.data.tkeep;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_axis_h_l389_l399_DUPLICATE_62e0 LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_axis_h_l389_l399_DUPLICATE_62e0_return_output := axis_in_reg.data.tlast;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d[axis_h_l433_c6_7351] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_axis_h_l433_c6_7351_return_output := VAR_axis_in.valid;

     -- axis_out_reg_data_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_d41d[axis_h_l377_c3_eeff] LATENCY=0
     VAR_axis_out_reg_data_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_d41d_axis_h_l377_c3_eeff_return_output := axis_out_reg.data.tkeep;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_axis_h_l389_DUPLICATE_e673 LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_axis_h_l389_DUPLICATE_e673_return_output := axis_in_reg.valid;

     -- axis_out_reg_valid_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d[axis_h_l377_c3_eeff] LATENCY=0
     VAR_axis_out_reg_valid_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_axis_h_l377_c3_eeff_return_output := axis_out_reg.valid;

     -- Submodule level 1
     VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iffalse := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_axis_h_l389_l399_DUPLICATE_62e0_return_output;
     VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_axis_h_l389_l399_DUPLICATE_62e0_return_output;
     VAR_BIN_OP_AND_axis_h_l433_c6_c70f_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_axis_h_l433_c6_7351_return_output;
     VAR_BIN_OP_AND_axis_h_l389_c6_78ee_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_axis_h_l389_DUPLICATE_e673_return_output;
     VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iffalse := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_axis_h_l389_DUPLICATE_e673_return_output;
     VAR_BIN_OP_AND_axis_h_l377_c6_330b_left := VAR_CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_out_valid_01c3_axis_h_l377_c6_2d7b_return_output;
     VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iffalse := VAR_axis_in_reg_data_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_16_axis128_t_stream_t_data_tkeep_d41d_axis_h_l389_c3_ce98_return_output;
     VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iffalse := VAR_axis_out_reg_data_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_64_axis512_t_stream_t_data_tkeep_d41d_axis_h_l377_c3_eeff_return_output;
     VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iffalse := VAR_axis_out_reg_data_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis512_t_stream_t_data_tlast_d41d_axis_h_l377_c3_eeff_return_output;
     VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iffalse := VAR_axis_out_reg_valid_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_axis_h_l377_c3_eeff_return_output;
     -- BIN_OP_AND[axis_h_l377_c6_330b] LATENCY=0
     -- Inputs
     BIN_OP_AND_axis_h_l377_c6_330b_left <= VAR_BIN_OP_AND_axis_h_l377_c6_330b_left;
     BIN_OP_AND_axis_h_l377_c6_330b_right <= VAR_BIN_OP_AND_axis_h_l377_c6_330b_right;
     -- Outputs
     VAR_BIN_OP_AND_axis_h_l377_c6_330b_return_output := BIN_OP_AND_axis_h_l377_c6_330b_return_output;

     -- Submodule level 2
     VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_cond := VAR_BIN_OP_AND_axis_h_l377_c6_330b_return_output;
     VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_cond := VAR_BIN_OP_AND_axis_h_l377_c6_330b_return_output;
     VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_cond := VAR_BIN_OP_AND_axis_h_l377_c6_330b_return_output;
     -- axis_out_reg_data_tlast_MUX[axis_h_l377_c3_eeff] LATENCY=0
     -- Inputs
     axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_cond <= VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_cond;
     axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iftrue <= VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iftrue;
     axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iffalse <= VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_iffalse;
     -- Outputs
     VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_return_output := axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_return_output;

     -- axis_out_reg_data_tkeep_MUX[axis_h_l377_c3_eeff] LATENCY=0
     -- Inputs
     axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_cond <= VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_cond;
     axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iftrue <= VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iftrue;
     axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iffalse <= VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_iffalse;
     -- Outputs
     VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_return_output := axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_return_output;

     -- axis_out_reg_valid_MUX[axis_h_l377_c3_eeff] LATENCY=0
     -- Inputs
     axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_cond <= VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_cond;
     axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iftrue <= VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iftrue;
     axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iffalse <= VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_iffalse;
     -- Outputs
     VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_return_output := axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_return_output;

     -- Submodule level 3
     VAR_UNARY_OP_NOT_axis_h_l388_c28_5299_expr := VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_return_output;
     -- CONST_REF_RD_axis512_t_axis512_t_stream_t_data_699e[axis_h_l393_c68_9934] LATENCY=0
     VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_699e_axis_h_l393_c68_9934_return_output := CONST_REF_RD_axis512_t_axis512_t_stream_t_data_699e(
     axis_out_reg,
     VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_return_output,
     VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_return_output);

     -- axis_out_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_ad74[axis_h_l389_c3_ce98] LATENCY=0
     VAR_axis_out_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_ad74_axis_h_l389_c3_ce98_return_output := CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_ad74(
     axis_out_reg,
     VAR_axis_out_reg_data_tlast_MUX_axis_h_l377_c3_eeff_return_output,
     VAR_axis_out_reg_data_tkeep_MUX_axis_h_l377_c3_eeff_return_output,
     VAR_axis_out_reg_valid_MUX_axis_h_l377_c3_eeff_return_output);

     -- UNARY_OP_NOT[axis_h_l388_c28_5299] LATENCY=0
     -- Inputs
     UNARY_OP_NOT_axis_h_l388_c28_5299_expr <= VAR_UNARY_OP_NOT_axis_h_l388_c28_5299_expr;
     -- Outputs
     VAR_UNARY_OP_NOT_axis_h_l388_c28_5299_return_output := UNARY_OP_NOT_axis_h_l388_c28_5299_return_output;

     -- Submodule level 4
     VAR_axis512_to_axis128_array_axis_h_l393_c43_2f4f_axis := VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_699e_axis_h_l393_c68_9934_return_output;
     VAR_BIN_OP_AND_axis_h_l389_c6_78ee_right := VAR_UNARY_OP_NOT_axis_h_l388_c28_5299_return_output;
     VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_iffalse := VAR_axis_out_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_ad74_axis_h_l389_c3_ce98_return_output;
     -- axis512_to_axis128_array[axis_h_l393_c43_2f4f] LATENCY=0
     -- Inputs
     axis512_to_axis128_array_axis_h_l393_c43_2f4f_axis <= VAR_axis512_to_axis128_array_axis_h_l393_c43_2f4f_axis;
     -- Outputs
     VAR_axis512_to_axis128_array_axis_h_l393_c43_2f4f_return_output := axis512_to_axis128_array_axis_h_l393_c43_2f4f_return_output;

     -- BIN_OP_AND[axis_h_l389_c6_78ee] LATENCY=0
     -- Inputs
     BIN_OP_AND_axis_h_l389_c6_78ee_left <= VAR_BIN_OP_AND_axis_h_l389_c6_78ee_left;
     BIN_OP_AND_axis_h_l389_c6_78ee_right <= VAR_BIN_OP_AND_axis_h_l389_c6_78ee_right;
     -- Outputs
     VAR_BIN_OP_AND_axis_h_l389_c6_78ee_return_output := BIN_OP_AND_axis_h_l389_c6_78ee_return_output;

     -- Submodule level 5
     VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_cond := VAR_BIN_OP_AND_axis_h_l389_c6_78ee_return_output;
     VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_cond := VAR_BIN_OP_AND_axis_h_l389_c6_78ee_return_output;
     VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_cond := VAR_BIN_OP_AND_axis_h_l389_c6_78ee_return_output;
     VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_cond := VAR_BIN_OP_AND_axis_h_l389_c6_78ee_return_output;
     -- CONST_REF_RD_axis128_t_stream_t_4_axis512_to_axis128_array_t_axis_chunks_d41d[axis_h_l394_c26_2c43] LATENCY=0
     VAR_CONST_REF_RD_axis128_t_stream_t_4_axis512_to_axis128_array_t_axis_chunks_d41d_axis_h_l394_c26_2c43_return_output := VAR_axis512_to_axis128_array_axis_h_l393_c43_2f4f_return_output.axis_chunks;

     -- axis_in_reg_data_tlast_MUX[axis_h_l389_c3_ce98] LATENCY=0
     -- Inputs
     axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_cond <= VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_cond;
     axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iftrue <= VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iftrue;
     axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iffalse <= VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_iffalse;
     -- Outputs
     VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_return_output := axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_return_output;

     -- axis_in_reg_data_tkeep_MUX[axis_h_l389_c3_ce98] LATENCY=0
     -- Inputs
     axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_cond <= VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_cond;
     axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iftrue <= VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iftrue;
     axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iffalse <= VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_iffalse;
     -- Outputs
     VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_return_output := axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_return_output;

     -- axis_in_reg_valid_MUX[axis_h_l389_c3_ce98] LATENCY=0
     -- Inputs
     axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_cond <= VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_cond;
     axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iftrue <= VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iftrue;
     axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iffalse <= VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_iffalse;
     -- Outputs
     VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_return_output := axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_return_output;

     -- Submodule level 6
     VAR_UNARY_OP_NOT_axis_h_l432_c22_cc00_expr := VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_return_output;
     -- FOR_axis_h_l398_c34_71d8_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d[axis_h_l398_c156_21d3] LATENCY=0
     VAR_FOR_axis_h_l398_c34_71d8_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l398_c156_21d3_return_output := VAR_CONST_REF_RD_axis128_t_stream_t_4_axis512_to_axis128_array_t_axis_chunks_d41d_axis_h_l394_c26_2c43_return_output(1);

     -- axis_in_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4a8d[axis_h_l433_c3_9317] LATENCY=0
     VAR_axis_in_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4a8d_axis_h_l433_c3_9317_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4a8d(
     axis_in_reg,
     VAR_axis_in_reg_valid_MUX_axis_h_l389_c3_ce98_return_output,
     VAR_axis_in_reg_data_tlast_MUX_axis_h_l389_c3_ce98_return_output,
     VAR_axis_in_reg_data_tkeep_MUX_axis_h_l389_c3_ce98_return_output);

     -- FOR_axis_h_l398_c34_71d8_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d[axis_h_l398_c156_21d3] LATENCY=0
     VAR_FOR_axis_h_l398_c34_71d8_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l398_c156_21d3_return_output := VAR_CONST_REF_RD_axis128_t_stream_t_4_axis512_to_axis128_array_t_axis_chunks_d41d_axis_h_l394_c26_2c43_return_output(3);

     -- FOR_axis_h_l398_c34_71d8_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d[axis_h_l398_c156_21d3] LATENCY=0
     VAR_FOR_axis_h_l398_c34_71d8_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l398_c156_21d3_return_output := VAR_CONST_REF_RD_axis128_t_stream_t_4_axis512_to_axis128_array_t_axis_chunks_d41d_axis_h_l394_c26_2c43_return_output(2);

     -- UNARY_OP_NOT[axis_h_l432_c22_cc00] LATENCY=0
     -- Inputs
     UNARY_OP_NOT_axis_h_l432_c22_cc00_expr <= VAR_UNARY_OP_NOT_axis_h_l432_c22_cc00_expr;
     -- Outputs
     VAR_UNARY_OP_NOT_axis_h_l432_c22_cc00_return_output := UNARY_OP_NOT_axis_h_l432_c22_cc00_return_output;

     -- Submodule level 7
     VAR_BIN_OP_AND_axis_h_l433_c6_c70f_right := VAR_UNARY_OP_NOT_axis_h_l432_c22_cc00_return_output;
     VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_iffalse := VAR_axis_in_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4a8d_axis_h_l433_c3_9317_return_output;
     -- FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346[axis_h_l415_c9_5b37] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l415_c9_5b37_return_output := CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346(
     VAR_FOR_axis_h_l398_c34_71d8_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l398_c156_21d3_return_output,
     VAR_FOR_axis_h_l398_c34_71d8_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l398_c156_21d3_return_output,
     axis_in_reg,
     axis128_t_stream_t_NULL);

     -- CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l407_l415_DUPLICATE_a15f LATENCY=0
     VAR_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l407_l415_DUPLICATE_a15f_return_output := CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346(
     VAR_FOR_axis_h_l398_c34_71d8_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l398_c156_21d3_return_output,
     VAR_FOR_axis_h_l398_c34_71d8_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l398_c156_21d3_return_output,
     VAR_FOR_axis_h_l398_c34_71d8_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l398_c156_21d3_return_output,
     axis_in_reg);

     -- FOR_axis_h_l411_c7_3468_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_4e8d[axis_h_l415_c13_3456] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_4e8d_axis_h_l415_c13_3456_return_output := CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_4e8d(
     VAR_FOR_axis_h_l398_c34_71d8_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l398_c156_21d3_return_output);

     -- CONST_REF_RD_axis128_to_axis512_t_axis128_to_axis512_t_c1ed[axis_h_l437_c10_b8a8] LATENCY=0
     VAR_CONST_REF_RD_axis128_to_axis512_t_axis128_to_axis512_t_c1ed_axis_h_l437_c10_b8a8_return_output := CONST_REF_RD_axis128_to_axis512_t_axis128_to_axis512_t_c1ed(
     axis_out_reg,
     VAR_UNARY_OP_NOT_axis_h_l432_c22_cc00_return_output);

     -- BIN_OP_AND[axis_h_l433_c6_c70f] LATENCY=0
     -- Inputs
     BIN_OP_AND_axis_h_l433_c6_c70f_left <= VAR_BIN_OP_AND_axis_h_l433_c6_c70f_left;
     BIN_OP_AND_axis_h_l433_c6_c70f_right <= VAR_BIN_OP_AND_axis_h_l433_c6_c70f_right;
     -- Outputs
     VAR_BIN_OP_AND_axis_h_l433_c6_c70f_return_output := BIN_OP_AND_axis_h_l433_c6_c70f_return_output;

     -- Submodule level 8
     VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_cond := VAR_BIN_OP_AND_axis_h_l433_c6_c70f_return_output;
     VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse := VAR_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l407_l415_DUPLICATE_a15f_return_output;
     VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iffalse := VAR_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l407_l415_DUPLICATE_a15f_return_output;
     VAR_return_output := VAR_CONST_REF_RD_axis128_to_axis512_t_axis128_to_axis512_t_c1ed_axis_h_l437_c10_b8a8_return_output;
     VAR_FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_expr := VAR_FOR_axis_h_l411_c7_3468_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_4e8d_axis_h_l415_c13_3456_return_output;
     VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue := VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l415_c9_5b37_return_output;
     -- FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT[axis_h_l415_c13_854b] LATENCY=0
     -- Inputs
     FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_expr <= VAR_FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_expr;
     -- Outputs
     VAR_FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output := FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output;

     -- axis_in_reg_MUX[axis_h_l433_c3_9317] LATENCY=0
     -- Inputs
     axis_in_reg_MUX_axis_h_l433_c3_9317_cond <= VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_cond;
     axis_in_reg_MUX_axis_h_l433_c3_9317_iftrue <= VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_iftrue;
     axis_in_reg_MUX_axis_h_l433_c3_9317_iffalse <= VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_iffalse;
     -- Outputs
     VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_return_output := axis_in_reg_MUX_axis_h_l433_c3_9317_return_output;

     -- Submodule level 9
     VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond := VAR_FOR_axis_h_l411_c7_3468_ITER_0_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output;
     REG_VAR_axis_in_reg := VAR_axis_in_reg_MUX_axis_h_l433_c3_9317_return_output;
     -- FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX[axis_h_l415_c9_5b37] LATENCY=0
     -- Inputs
     FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond <= VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond;
     FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue <= VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue;
     FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse <= VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse;
     -- Outputs
     VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output := FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output;

     -- Submodule level 10
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse := VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output;
     -- FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d[axis_h_l418_c162_b935] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l418_c162_b935_return_output := VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output(3);

     -- FOR_axis_h_l411_c7_3468_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d[axis_h_l415_c13_3456] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d_axis_h_l415_c13_3456_return_output := VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output(0).valid;

     -- FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d[axis_h_l418_c162_b935] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l418_c162_b935_return_output := VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output(1);

     -- FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d[axis_h_l418_c162_b935] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l418_c162_b935_return_output := VAR_FOR_axis_h_l411_c7_3468_ITER_0_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output(2);

     -- Submodule level 11
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_expr := VAR_FOR_axis_h_l411_c7_3468_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d_axis_h_l415_c13_3456_return_output;
     -- FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346[axis_h_l415_c9_5b37] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l415_c9_5b37_return_output := CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346(
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l418_c162_b935_return_output,
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l418_c162_b935_return_output,
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_FOR_axis_h_l418_c40_af63_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l418_c162_b935_return_output,
     axis128_t_stream_t_NULL);

     -- FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT[axis_h_l415_c13_854b] LATENCY=0
     -- Inputs
     FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_expr <= VAR_FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_expr;
     -- Outputs
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output := FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output;

     -- Submodule level 12
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond := VAR_FOR_axis_h_l411_c7_3468_ITER_1_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output;
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue := VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l415_c9_5b37_return_output;
     -- FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX[axis_h_l415_c9_5b37] LATENCY=0
     -- Inputs
     FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond <= VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond;
     FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue <= VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue;
     FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse <= VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse;
     -- Outputs
     VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output := FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output;

     -- Submodule level 13
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse := VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output;
     -- FOR_axis_h_l411_c7_3468_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d[axis_h_l415_c13_3456] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d_axis_h_l415_c13_3456_return_output := VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output(0).valid;

     -- FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d[axis_h_l418_c162_b935] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l418_c162_b935_return_output := VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output(1);

     -- FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d[axis_h_l418_c162_b935] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l418_c162_b935_return_output := VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output(3);

     -- FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d[axis_h_l418_c162_b935] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l418_c162_b935_return_output := VAR_FOR_axis_h_l411_c7_3468_ITER_1_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output(2);

     -- Submodule level 14
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_expr := VAR_FOR_axis_h_l411_c7_3468_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d_axis_h_l415_c13_3456_return_output;
     -- FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT[axis_h_l415_c13_854b] LATENCY=0
     -- Inputs
     FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_expr <= VAR_FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_expr;
     -- Outputs
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output := FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output;

     -- FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346[axis_h_l415_c9_5b37] LATENCY=0
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l415_c9_5b37_return_output := CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346(
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_0_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_1_d41d_axis_h_l418_c162_b935_return_output,
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_1_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_2_d41d_axis_h_l418_c162_b935_return_output,
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_FOR_axis_h_l418_c40_af63_ITER_2_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4_3_d41d_axis_h_l418_c162_b935_return_output,
     axis128_t_stream_t_NULL);

     -- Submodule level 15
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond := VAR_FOR_axis_h_l411_c7_3468_ITER_2_UNARY_OP_NOT_axis_h_l415_c13_854b_return_output;
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue := VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_4_axis128_t_stream_t_4_2346_axis_h_l415_c9_5b37_return_output;
     -- FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX[axis_h_l415_c9_5b37] LATENCY=0
     -- Inputs
     FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond <= VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_cond;
     FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue <= VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iftrue;
     FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse <= VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_iffalse;
     -- Outputs
     VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output := FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output;

     -- Submodule level 16
     VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iftrue := VAR_FOR_axis_h_l411_c7_3468_ITER_2_axis_out_as_chunks_MUX_axis_h_l415_c9_5b37_return_output;
     -- axis_out_as_chunks_MUX[axis_h_l407_c5_9926] LATENCY=0
     -- Inputs
     axis_out_as_chunks_MUX_axis_h_l407_c5_9926_cond <= VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_cond;
     axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iftrue <= VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iftrue;
     axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iffalse <= VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_iffalse;
     -- Outputs
     VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_return_output := axis_out_as_chunks_MUX_axis_h_l407_c5_9926_return_output;

     -- Submodule level 17
     VAR_axis128_array_to_axis512_axis_h_l424_c25_2426_axis_chunks := VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_return_output;
     -- axis128_array_to_axis512[axis_h_l424_c25_2426] LATENCY=0
     -- Inputs
     axis128_array_to_axis512_axis_h_l424_c25_2426_axis_chunks <= VAR_axis128_array_to_axis512_axis_h_l424_c25_2426_axis_chunks;
     -- Outputs
     VAR_axis128_array_to_axis512_axis_h_l424_c25_2426_return_output := axis128_array_to_axis512_axis_h_l424_c25_2426_return_output;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d[axis_h_l427_c26_7b26] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d_axis_h_l427_c26_7b26_return_output := VAR_axis_out_as_chunks_MUX_axis_h_l407_c5_9926_return_output(0).valid;

     -- Submodule level 18
     -- axis_out_reg_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_42b0[axis_h_l389_c3_ce98] LATENCY=0
     VAR_axis_out_reg_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_42b0_axis_h_l389_c3_ce98_return_output := CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_42b0(
     VAR_axis128_array_to_axis512_axis_h_l424_c25_2426_return_output,
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_4_0_valid_d41d_axis_h_l427_c26_7b26_return_output);

     -- Submodule level 19
     VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_iftrue := VAR_axis_out_reg_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_42b0_axis_h_l389_c3_ce98_return_output;
     -- axis_out_reg_MUX[axis_h_l389_c3_ce98] LATENCY=0
     -- Inputs
     axis_out_reg_MUX_axis_h_l389_c3_ce98_cond <= VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_cond;
     axis_out_reg_MUX_axis_h_l389_c3_ce98_iftrue <= VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_iftrue;
     axis_out_reg_MUX_axis_h_l389_c3_ce98_iffalse <= VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_iffalse;
     -- Outputs
     VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_return_output := axis_out_reg_MUX_axis_h_l389_c3_ce98_return_output;

     -- Submodule level 20
     REG_VAR_axis_out_reg := VAR_axis_out_reg_MUX_axis_h_l389_c3_ce98_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_axis_in_reg <= REG_VAR_axis_in_reg;
REG_COMB_axis_out_reg <= REG_VAR_axis_out_reg;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     axis_in_reg <= REG_COMB_axis_in_reg;
     axis_out_reg <= REG_COMB_axis_out_reg;
 end if;
 end if;
end process;

end arch;
