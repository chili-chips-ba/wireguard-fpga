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
use work.global_wires_pkg.all;
-- Submodules: 27
entity strip_auth_tag_0CLK_62591bf8 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in strip_auth_tag_global_to_module_t;
 module_to_global : out strip_auth_tag_module_to_global_t);
end strip_auth_tag_0CLK_62591bf8;
architecture arch of strip_auth_tag_0CLK_62591bf8 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal state : unsigned(0 downto 0) := unsigned(strip_auth_tag_state_t_to_slv(CIPHERTEXT_PASS));
signal cyphertext_reg : axis128_t_stream_t := axis128_t_stream_t_NULL;
signal tag_capture_reg : axis128_t := axis128_t_NULL;
signal REG_COMB_state : unsigned(0 downto 0);
signal REG_COMB_cyphertext_reg : axis128_t_stream_t;
signal REG_COMB_tag_capture_reg : axis128_t;

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- BIN_OP_AND[strip_auth_tag_c_l38_c29_2902]
signal BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_left : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_right : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[strip_auth_tag_c_l40_c6_53a2]
signal BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_left : unsigned(0 downto 0);
signal BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_right : unsigned(0 downto 0);
signal BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output : unsigned(0 downto 0);

-- tag_capture_reg_MUX[strip_auth_tag_c_l40_c3_8eaf]
signal tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
signal tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : axis128_t;
signal tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : axis128_t;
signal tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : axis128_t;

-- state_MUX[strip_auth_tag_c_l40_c3_8eaf]
signal state_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : unsigned(0 downto 0);

-- strip_auth_tag_auth_tag_out_MUX[strip_auth_tag_c_l40_c3_8eaf]
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : uint128_t_stream_t;
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : uint128_t_stream_t;
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : uint128_t_stream_t;

-- cyphertext_reg_MUX[strip_auth_tag_c_l40_c3_8eaf]
signal cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
signal cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : axis128_t_stream_t;
signal cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : axis128_t_stream_t;
signal cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : axis128_t_stream_t;

-- strip_auth_tag_axis_in_ready_MUX[strip_auth_tag_c_l40_c3_8eaf]
signal strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
signal strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : unsigned(0 downto 0);
signal strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : unsigned(0 downto 0);
signal strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[strip_auth_tag_c_l46_c8_07f8]
signal BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_left : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_right : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_return_output : unsigned(0 downto 0);

-- tag_capture_reg_MUX[strip_auth_tag_c_l46_c5_0288]
signal tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond : unsigned(0 downto 0);
signal tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue : axis128_t;
signal tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse : axis128_t;
signal tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output : axis128_t;

-- state_MUX[strip_auth_tag_c_l46_c5_0288]
signal state_MUX_strip_auth_tag_c_l46_c5_0288_cond : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l46_c5_0288_iftrue : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l46_c5_0288_iffalse : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l46_c5_0288_return_output : unsigned(0 downto 0);

-- cyphertext_reg_MUX[strip_auth_tag_c_l46_c5_0288]
signal cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond : unsigned(0 downto 0);
signal cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue : axis128_t_stream_t;
signal cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse : axis128_t_stream_t;
signal cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output : axis128_t_stream_t;

-- tag_capture_reg_MUX[strip_auth_tag_c_l48_c7_be9d]
signal tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_cond : unsigned(0 downto 0);
signal tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue : axis128_t;
signal tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse : axis128_t;
signal tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_return_output : axis128_t;

-- state_MUX[strip_auth_tag_c_l48_c7_be9d]
signal state_MUX_strip_auth_tag_c_l48_c7_be9d_cond : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l48_c7_be9d_return_output : unsigned(0 downto 0);

-- cyphertext_reg_data_tlast_MUX[strip_auth_tag_c_l48_c7_be9d]
signal cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_cond : unsigned(0 downto 0);
signal cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue : unsigned(0 downto 0);
signal cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse : unsigned(0 downto 0);
signal cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_return_output : unsigned(0 downto 0);

-- cyphertext_reg_valid_MUX[strip_auth_tag_c_l48_c7_be9d]
signal cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_cond : unsigned(0 downto 0);
signal cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue : unsigned(0 downto 0);
signal cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse : unsigned(0 downto 0);
signal cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_return_output : unsigned(0 downto 0);

-- tag_capture_reg_tlast_MUX[strip_auth_tag_c_l79_c5_a208]
signal tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_cond : unsigned(0 downto 0);
signal tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iftrue : unsigned(0 downto 0);
signal tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iffalse : unsigned(0 downto 0);
signal tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_return_output : unsigned(0 downto 0);

-- state_MUX[strip_auth_tag_c_l79_c5_a208]
signal state_MUX_strip_auth_tag_c_l79_c5_a208_cond : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l79_c5_a208_iftrue : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l79_c5_a208_iffalse : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l79_c5_a208_return_output : unsigned(0 downto 0);

-- strip_auth_tag_auth_tag_out_MUX[strip_auth_tag_c_l79_c5_a208]
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_cond : unsigned(0 downto 0);
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iftrue : uint128_t_stream_t;
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iffalse : uint128_t_stream_t;
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_return_output : uint128_t_stream_t;

-- cyphertext_reg_valid_MUX[strip_auth_tag_c_l79_c5_a208]
signal cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_cond : unsigned(0 downto 0);
signal cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iftrue : unsigned(0 downto 0);
signal cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iffalse : unsigned(0 downto 0);
signal cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_return_output : unsigned(0 downto 0);

-- tag_capture_reg_tlast_MUX[strip_auth_tag_c_l88_c7_d49c]
signal tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_cond : unsigned(0 downto 0);
signal tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue : unsigned(0 downto 0);
signal tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse : unsigned(0 downto 0);
signal tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_return_output : unsigned(0 downto 0);

-- state_MUX[strip_auth_tag_c_l88_c7_d49c]
signal state_MUX_strip_auth_tag_c_l88_c7_d49c_cond : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse : unsigned(0 downto 0);
signal state_MUX_strip_auth_tag_c_l88_c7_d49c_return_output : unsigned(0 downto 0);

function CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1( ref_toks_0 : axis128_t_stream_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned) return axis128_t_stream_t is
 
  variable base : axis128_t_stream_t; 
  variable return_output : axis128_t_stream_t;
begin
      base := ref_toks_0;
      base.data.tlast := ref_toks_1;
      base.valid := ref_toks_2;

      return_output := base;
      return return_output; 
end function;

function uint8_array16_le( x : uint8_t_16) return unsigned is

  --variable x : uint8_t_16;
  variable return_output : unsigned(127 downto 0);

begin
return_output := x(15)&x(14)&x(13)&x(12)&x(11)&x(10)&x(9)&x(8)&x(7)&x(6)&x(5)&x(4)&x(3)&x(2)&x(1)&x(0);
return return_output;
end function;

function CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0( ref_toks_0 : unsigned;
 ref_toks_1 : unsigned) return uint128_t_stream_t is
 
  variable base : uint128_t_stream_t; 
  variable return_output : uint128_t_stream_t;
begin
      base.data := ref_toks_0;
      base.valid := ref_toks_1;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_axis128_t_axis128_t_aeac( ref_toks_0 : axis128_t;
 ref_toks_1 : unsigned) return axis128_t is
 
  variable base : axis128_t; 
  variable return_output : axis128_t;
begin
      base := ref_toks_0;
      base.tlast := ref_toks_1;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee( ref_toks_0 : axis128_t_stream_t;
 ref_toks_1 : unsigned) return axis128_t_stream_t is
 
  variable base : axis128_t_stream_t; 
  variable return_output : axis128_t_stream_t;
begin
      base := ref_toks_0;
      base.valid := ref_toks_1;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_AND_strip_auth_tag_c_l38_c29_2902 : 0 clocks latency
BIN_OP_AND_strip_auth_tag_c_l38_c29_2902 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_left,
BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_right,
BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output);

-- BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2 : 0 clocks latency
BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2 : entity work.BIN_OP_EQ_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_left,
BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_right,
BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output);

-- tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf : 0 clocks latency
tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf : entity work.MUX_uint1_t_axis128_t_axis128_t_0CLK_de264c78 port map (
tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond,
tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue,
tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse,
tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output);

-- state_MUX_strip_auth_tag_c_l40_c3_8eaf : 0 clocks latency
state_MUX_strip_auth_tag_c_l40_c3_8eaf : entity work.MUX_uint1_t_strip_auth_tag_state_t_strip_auth_tag_state_t_0CLK_de264c78 port map (
state_MUX_strip_auth_tag_c_l40_c3_8eaf_cond,
state_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue,
state_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse,
state_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output);

-- strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf : 0 clocks latency
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_cond,
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue,
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse,
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output);

-- cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf : 0 clocks latency
cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond,
cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue,
cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse,
cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output);

-- strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf : 0 clocks latency
strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_cond,
strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue,
strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse,
strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output);

-- BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8 : 0 clocks latency
BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_left,
BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_right,
BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_return_output);

-- tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288 : 0 clocks latency
tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288 : entity work.MUX_uint1_t_axis128_t_axis128_t_0CLK_de264c78 port map (
tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond,
tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue,
tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse,
tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output);

-- state_MUX_strip_auth_tag_c_l46_c5_0288 : 0 clocks latency
state_MUX_strip_auth_tag_c_l46_c5_0288 : entity work.MUX_uint1_t_strip_auth_tag_state_t_strip_auth_tag_state_t_0CLK_de264c78 port map (
state_MUX_strip_auth_tag_c_l46_c5_0288_cond,
state_MUX_strip_auth_tag_c_l46_c5_0288_iftrue,
state_MUX_strip_auth_tag_c_l46_c5_0288_iffalse,
state_MUX_strip_auth_tag_c_l46_c5_0288_return_output);

-- cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288 : 0 clocks latency
cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288 : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond,
cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue,
cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse,
cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output);

-- tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d : 0 clocks latency
tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d : entity work.MUX_uint1_t_axis128_t_axis128_t_0CLK_de264c78 port map (
tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_cond,
tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue,
tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse,
tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_return_output);

-- state_MUX_strip_auth_tag_c_l48_c7_be9d : 0 clocks latency
state_MUX_strip_auth_tag_c_l48_c7_be9d : entity work.MUX_uint1_t_strip_auth_tag_state_t_strip_auth_tag_state_t_0CLK_de264c78 port map (
state_MUX_strip_auth_tag_c_l48_c7_be9d_cond,
state_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue,
state_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse,
state_MUX_strip_auth_tag_c_l48_c7_be9d_return_output);

-- cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d : 0 clocks latency
cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_cond,
cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue,
cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse,
cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_return_output);

-- cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d : 0 clocks latency
cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_cond,
cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue,
cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse,
cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_return_output);

-- tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208 : 0 clocks latency
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_cond,
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iftrue,
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iffalse,
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_return_output);

-- state_MUX_strip_auth_tag_c_l79_c5_a208 : 0 clocks latency
state_MUX_strip_auth_tag_c_l79_c5_a208 : entity work.MUX_uint1_t_strip_auth_tag_state_t_strip_auth_tag_state_t_0CLK_de264c78 port map (
state_MUX_strip_auth_tag_c_l79_c5_a208_cond,
state_MUX_strip_auth_tag_c_l79_c5_a208_iftrue,
state_MUX_strip_auth_tag_c_l79_c5_a208_iffalse,
state_MUX_strip_auth_tag_c_l79_c5_a208_return_output);

-- strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208 : 0 clocks latency
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208 : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_cond,
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iftrue,
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iffalse,
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_return_output);

-- cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208 : 0 clocks latency
cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_cond,
cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iftrue,
cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iffalse,
cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_return_output);

-- tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c : 0 clocks latency
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_cond,
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue,
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse,
tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_return_output);

-- state_MUX_strip_auth_tag_c_l88_c7_d49c : 0 clocks latency
state_MUX_strip_auth_tag_c_l88_c7_d49c : entity work.MUX_uint1_t_strip_auth_tag_state_t_strip_auth_tag_state_t_0CLK_de264c78 port map (
state_MUX_strip_auth_tag_c_l88_c7_d49c_cond,
state_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue,
state_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse,
state_MUX_strip_auth_tag_c_l88_c7_d49c_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Registers
 state,
 cyphertext_reg,
 tag_capture_reg,
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output,
 BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output,
 tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output,
 state_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output,
 strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output,
 cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output,
 strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output,
 BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_return_output,
 tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output,
 state_MUX_strip_auth_tag_c_l46_c5_0288_return_output,
 cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output,
 tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_return_output,
 state_MUX_strip_auth_tag_c_l48_c7_be9d_return_output,
 cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_return_output,
 cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_return_output,
 tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_return_output,
 state_MUX_strip_auth_tag_c_l79_c5_a208_return_output,
 strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_return_output,
 cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_return_output,
 tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_return_output,
 state_MUX_strip_auth_tag_c_l88_c7_d49c_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_in_ready : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_out : axis128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out : uint128_t_stream_t;
 variable VAR_strip_auth_tag_axis_out_ready : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_in : axis128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_ready : unsigned(0 downto 0);
 variable VAR_axis_null : axis128_t_stream_t;
 variable VAR_auth_tag_null : uint128_t_stream_t;
 variable VAR_output_consumed : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output : unsigned(0 downto 0);
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : axis128_t;
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output : axis128_t;
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : axis128_t;
 variable VAR_tag_capture_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_axis128_t_aeac_strip_auth_tag_c_l40_c3_8eaf_return_output : axis128_t;
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : axis128_t;
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_return_output : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : axis128_t_stream_t;
 variable VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output : axis128_t_stream_t;
 variable VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : axis128_t_stream_t;
 variable VAR_cyphertext_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee_strip_auth_tag_c_l40_c3_8eaf_return_output : axis128_t_stream_t;
 variable VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : axis128_t_stream_t;
 variable VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l46_c8_c653_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_return_output : unsigned(0 downto 0);
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue : axis128_t;
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_return_output : axis128_t;
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse : axis128_t;
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_iftrue : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_iffalse : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_cond : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue : axis128_t_stream_t;
 variable VAR_cyphertext_reg_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1_strip_auth_tag_c_l46_c5_0288_return_output : axis128_t_stream_t;
 variable VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse : axis128_t_stream_t;
 variable VAR_cyphertext_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1_strip_auth_tag_c_l46_c5_0288_return_output : axis128_t_stream_t;
 variable VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l48_c10_ad23_return_output : unsigned(0 downto 0);
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue : axis128_t;
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse : axis128_t;
 variable VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_cond : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_data_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l48_c7_be9d_return_output : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_return_output : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_cond : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_return_output : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_strip_auth_tag_c_l55_c27_be03_return_output : axis128_t;
 variable VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iftrue : unsigned(0 downto 0);
 variable VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_return_output : unsigned(0 downto 0);
 variable VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iffalse : unsigned(0 downto 0);
 variable VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_return_output : unsigned(0 downto 0);
 variable VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_iftrue : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_iffalse : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_cond : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iftrue : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_strip_auth_tag_c_l79_c5_a208_return_output : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iffalse : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_cond : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iftrue : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iffalse : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_return_output : unsigned(0 downto 0);
 variable VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_16_axis128_t_tdata_d41d_strip_auth_tag_c_l85_c59_827f_return_output : uint8_t_16;
 variable VAR_uint8_array16_le_strip_auth_tag_c_l85_c42_3a42_return_output : unsigned(127 downto 0);
 variable VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue : unsigned(0 downto 0);
 variable VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse : unsigned(0 downto 0);
 variable VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue : unsigned(0 downto 0);
 variable VAR_state_strip_auth_tag_c_l92_c9_fdc9 : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse : unsigned(0 downto 0);
 variable VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l38_l48_l79_DUPLICATE_381b_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_tlast_d41d_strip_auth_tag_c_l79_l88_DUPLICATE_a81f_return_output : unsigned(0 downto 0);
 -- State registers comb logic variables
variable REG_VAR_state : unsigned(0 downto 0);
variable REG_VAR_cyphertext_reg : axis128_t_stream_t;
variable REG_VAR_tag_capture_reg : axis128_t;
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_state := state;
  REG_VAR_cyphertext_reg := cyphertext_reg;
  REG_VAR_tag_capture_reg := tag_capture_reg;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue := to_unsigned(0, 1);
     VAR_strip_auth_tag_axis_out := axis128_t_stream_t_NULL;
     VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_right := unsigned(strip_auth_tag_state_t_to_slv(CIPHERTEXT_PASS));
     VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue := to_unsigned(1, 1);
     VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue := unsigned(strip_auth_tag_state_t_to_slv(AUTH_TAG_EXTRACTION));
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue := uint128_t_stream_t_NULL;
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iffalse := uint128_t_stream_t_NULL;
     VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse := to_unsigned(0, 1);
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iftrue := to_unsigned(0, 1);
     VAR_state_strip_auth_tag_c_l92_c9_fdc9 := resize(unsigned(prep_auth_data_state_t_to_slv(CIPHERTEXT)), 1);
     VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue := VAR_state_strip_auth_tag_c_l92_c9_fdc9;
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue := to_unsigned(0, 1);
 -- Reads from global variables
     VAR_strip_auth_tag_axis_out_ready := global_to_module.strip_auth_tag_axis_out_ready;
     VAR_strip_auth_tag_axis_in := global_to_module.strip_auth_tag_axis_in;
     VAR_strip_auth_tag_auth_tag_out_ready := global_to_module.strip_auth_tag_auth_tag_out_ready;
     -- Submodule level 0
     VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_right := VAR_strip_auth_tag_axis_out_ready;
     VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_cond := VAR_strip_auth_tag_auth_tag_out_ready;
     VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_cond := VAR_strip_auth_tag_auth_tag_out_ready;
     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[strip_auth_tag_c_l48_c10_ad23] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l48_c10_ad23_return_output := VAR_strip_auth_tag_axis_in.data.tlast;

     -- cyphertext_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1[strip_auth_tag_c_l46_c5_0288] LATENCY=0
     VAR_cyphertext_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1_strip_auth_tag_c_l46_c5_0288_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1(
     VAR_strip_auth_tag_axis_in,
     to_unsigned(0, 1),
     to_unsigned(1, 1));

     -- CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d[strip_auth_tag_c_l55_c27_be03] LATENCY=0
     VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_strip_auth_tag_c_l55_c27_be03_return_output := VAR_strip_auth_tag_axis_in.data;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d[strip_auth_tag_c_l46_c8_c653] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l46_c8_c653_return_output := VAR_strip_auth_tag_axis_in.valid;

     -- Submodule level 1
     VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l48_c10_ad23_return_output;
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l48_c10_ad23_return_output;
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l48_c10_ad23_return_output;
     VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l48_c10_ad23_return_output;
     VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l46_c8_c653_return_output;
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue := VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_strip_auth_tag_c_l55_c27_be03_return_output;
     VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse := VAR_cyphertext_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1_strip_auth_tag_c_l46_c5_0288_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_left := state;
     VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_iffalse := state;
     VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse := state;
     VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_iffalse := state;
     VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse := state;
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse := tag_capture_reg;
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse := tag_capture_reg;
     -- CONST_REF_RD_uint1_t_axis128_t_tlast_d41d_strip_auth_tag_c_l79_l88_DUPLICATE_a81f LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_tlast_d41d_strip_auth_tag_c_l79_l88_DUPLICATE_a81f_return_output := tag_capture_reg.tlast;

     -- state_MUX[strip_auth_tag_c_l88_c7_d49c] LATENCY=0
     -- Inputs
     state_MUX_strip_auth_tag_c_l88_c7_d49c_cond <= VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_cond;
     state_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue <= VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue;
     state_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse <= VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse;
     -- Outputs
     VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_return_output := state_MUX_strip_auth_tag_c_l88_c7_d49c_return_output;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l38_l48_l79_DUPLICATE_381b LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l38_l48_l79_DUPLICATE_381b_return_output := cyphertext_reg.valid;

     -- tag_capture_reg_MUX[strip_auth_tag_c_l48_c7_be9d] LATENCY=0
     -- Inputs
     tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_cond <= VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_cond;
     tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue <= VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue;
     tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse <= VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse;
     -- Outputs
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_return_output := tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_return_output;

     -- BIN_OP_EQ[strip_auth_tag_c_l40_c6_53a2] LATENCY=0
     -- Inputs
     BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_left <= VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_left;
     BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_right <= VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_right;
     -- Outputs
     VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output := BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output;

     -- state_MUX[strip_auth_tag_c_l48_c7_be9d] LATENCY=0
     -- Inputs
     state_MUX_strip_auth_tag_c_l48_c7_be9d_cond <= VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_cond;
     state_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue <= VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue;
     state_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse <= VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse;
     -- Outputs
     VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_return_output := state_MUX_strip_auth_tag_c_l48_c7_be9d_return_output;

     -- cyphertext_reg_data_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[strip_auth_tag_c_l48_c7_be9d] LATENCY=0
     VAR_cyphertext_reg_data_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l48_c7_be9d_return_output := cyphertext_reg.data.tlast;

     -- CONST_REF_RD_uint8_t_16_axis128_t_tdata_d41d[strip_auth_tag_c_l85_c59_827f] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_axis128_t_tdata_d41d_strip_auth_tag_c_l85_c59_827f_return_output := tag_capture_reg.tdata;

     -- Submodule level 1
     VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond := VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output;
     VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_cond := VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output;
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_cond := VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output;
     VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_cond := VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output;
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond := VAR_BIN_OP_EQ_strip_auth_tag_c_l40_c6_53a2_return_output;
     VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l38_l48_l79_DUPLICATE_381b_return_output;
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l38_l48_l79_DUPLICATE_381b_return_output;
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iffalse := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l38_l48_l79_DUPLICATE_381b_return_output;
     VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iffalse := VAR_CONST_REF_RD_uint1_t_axis128_t_tlast_d41d_strip_auth_tag_c_l79_l88_DUPLICATE_a81f_return_output;
     VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse := VAR_CONST_REF_RD_uint1_t_axis128_t_tlast_d41d_strip_auth_tag_c_l79_l88_DUPLICATE_a81f_return_output;
     VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse := VAR_cyphertext_reg_data_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l48_c7_be9d_return_output;
     VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_iftrue := VAR_state_MUX_strip_auth_tag_c_l48_c7_be9d_return_output;
     VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_iftrue := VAR_state_MUX_strip_auth_tag_c_l88_c7_d49c_return_output;
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue := VAR_tag_capture_reg_MUX_strip_auth_tag_c_l48_c7_be9d_return_output;
     -- BIN_OP_AND[strip_auth_tag_c_l38_c29_2902] LATENCY=0
     -- Inputs
     BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_left <= VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_left;
     BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_right <= VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_right;
     -- Outputs
     VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output := BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output;

     -- tag_capture_reg_tlast_MUX[strip_auth_tag_c_l88_c7_d49c] LATENCY=0
     -- Inputs
     tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_cond <= VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_cond;
     tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue <= VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iftrue;
     tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse <= VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_iffalse;
     -- Outputs
     VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_return_output := tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_return_output;

     -- cyphertext_reg_data_tlast_MUX[strip_auth_tag_c_l48_c7_be9d] LATENCY=0
     -- Inputs
     cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_cond <= VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_cond;
     cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue <= VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue;
     cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse <= VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse;
     -- Outputs
     VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_return_output := cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_return_output;

     -- uint8_array16_le[strip_auth_tag_c_l85_c42_3a42] LATENCY=0
     VAR_uint8_array16_le_strip_auth_tag_c_l85_c42_3a42_return_output := uint8_array16_le(
     VAR_CONST_REF_RD_uint8_t_16_axis128_t_tdata_d41d_strip_auth_tag_c_l85_c59_827f_return_output);

     -- cyphertext_reg_valid_MUX[strip_auth_tag_c_l48_c7_be9d] LATENCY=0
     -- Inputs
     cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_cond <= VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_cond;
     cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue <= VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iftrue;
     cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse <= VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_iffalse;
     -- Outputs
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_return_output := cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_return_output;

     -- Submodule level 2
     VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_right := VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output;
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output;
     VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output;
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output;
     VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue := VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output;
     VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l38_c29_2902_return_output;
     VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iftrue := VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l88_c7_d49c_return_output;
     -- strip_auth_tag_auth_tag_out_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0[strip_auth_tag_c_l79_c5_a208] LATENCY=0
     VAR_strip_auth_tag_auth_tag_out_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_strip_auth_tag_c_l79_c5_a208_return_output := CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0(
     VAR_uint8_array16_le_strip_auth_tag_c_l85_c42_3a42_return_output,
     to_unsigned(1, 1));

     -- cyphertext_reg_valid_MUX[strip_auth_tag_c_l79_c5_a208] LATENCY=0
     -- Inputs
     cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_cond <= VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_cond;
     cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iftrue <= VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iftrue;
     cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iffalse <= VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_iffalse;
     -- Outputs
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_return_output := cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_return_output;

     -- tag_capture_reg_tlast_MUX[strip_auth_tag_c_l79_c5_a208] LATENCY=0
     -- Inputs
     tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_cond <= VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_cond;
     tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iftrue <= VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iftrue;
     tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iffalse <= VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_iffalse;
     -- Outputs
     VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_return_output := tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_return_output;

     -- BIN_OP_AND[strip_auth_tag_c_l46_c8_07f8] LATENCY=0
     -- Inputs
     BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_left <= VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_left;
     BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_right <= VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_right;
     -- Outputs
     VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_return_output := BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_return_output;

     -- state_MUX[strip_auth_tag_c_l79_c5_a208] LATENCY=0
     -- Inputs
     state_MUX_strip_auth_tag_c_l79_c5_a208_cond <= VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_cond;
     state_MUX_strip_auth_tag_c_l79_c5_a208_iftrue <= VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_iftrue;
     state_MUX_strip_auth_tag_c_l79_c5_a208_iffalse <= VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_iffalse;
     -- Outputs
     VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_return_output := state_MUX_strip_auth_tag_c_l79_c5_a208_return_output;

     -- strip_auth_tag_axis_in_ready_MUX[strip_auth_tag_c_l40_c3_8eaf] LATENCY=0
     -- Inputs
     strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_cond <= VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_cond;
     strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue <= VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue;
     strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse <= VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse;
     -- Outputs
     VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output := strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;

     -- cyphertext_reg_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1[strip_auth_tag_c_l46_c5_0288] LATENCY=0
     VAR_cyphertext_reg_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1_strip_auth_tag_c_l46_c5_0288_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1(
     cyphertext_reg,
     VAR_cyphertext_reg_data_tlast_MUX_strip_auth_tag_c_l48_c7_be9d_return_output,
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l48_c7_be9d_return_output);

     -- Submodule level 3
     VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_return_output;
     VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_return_output;
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l46_c8_07f8_return_output;
     VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue := VAR_cyphertext_reg_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1_strip_auth_tag_c_l46_c5_0288_return_output;
     VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse := VAR_state_MUX_strip_auth_tag_c_l79_c5_a208_return_output;
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iftrue := VAR_strip_auth_tag_auth_tag_out_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_strip_auth_tag_c_l79_c5_a208_return_output;
     VAR_strip_auth_tag_axis_in_ready := VAR_strip_auth_tag_axis_in_ready_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;
     -- tag_capture_reg_MUX[strip_auth_tag_c_l46_c5_0288] LATENCY=0
     -- Inputs
     tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond <= VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond;
     tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue <= VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue;
     tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse <= VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse;
     -- Outputs
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output := tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output;

     -- cyphertext_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee[strip_auth_tag_c_l40_c3_8eaf] LATENCY=0
     VAR_cyphertext_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee_strip_auth_tag_c_l40_c3_8eaf_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee(
     cyphertext_reg,
     VAR_cyphertext_reg_valid_MUX_strip_auth_tag_c_l79_c5_a208_return_output);

     -- cyphertext_reg_MUX[strip_auth_tag_c_l46_c5_0288] LATENCY=0
     -- Inputs
     cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond <= VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_cond;
     cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue <= VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iftrue;
     cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse <= VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_iffalse;
     -- Outputs
     VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output := cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output;

     -- tag_capture_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_axis128_t_aeac[strip_auth_tag_c_l40_c3_8eaf] LATENCY=0
     VAR_tag_capture_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_axis128_t_aeac_strip_auth_tag_c_l40_c3_8eaf_return_output := CONST_REF_RD_axis128_t_axis128_t_aeac(
     tag_capture_reg,
     VAR_tag_capture_reg_tlast_MUX_strip_auth_tag_c_l79_c5_a208_return_output);

     -- strip_auth_tag_auth_tag_out_MUX[strip_auth_tag_c_l79_c5_a208] LATENCY=0
     -- Inputs
     strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_cond <= VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_cond;
     strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iftrue <= VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iftrue;
     strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iffalse <= VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_iffalse;
     -- Outputs
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_return_output := strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_return_output;

     -- state_MUX[strip_auth_tag_c_l46_c5_0288] LATENCY=0
     -- Inputs
     state_MUX_strip_auth_tag_c_l46_c5_0288_cond <= VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_cond;
     state_MUX_strip_auth_tag_c_l46_c5_0288_iftrue <= VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_iftrue;
     state_MUX_strip_auth_tag_c_l46_c5_0288_iffalse <= VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_iffalse;
     -- Outputs
     VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_return_output := state_MUX_strip_auth_tag_c_l46_c5_0288_return_output;

     -- Submodule level 4
     VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse := VAR_cyphertext_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee_strip_auth_tag_c_l40_c3_8eaf_return_output;
     VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue := VAR_cyphertext_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output;
     VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue := VAR_state_MUX_strip_auth_tag_c_l46_c5_0288_return_output;
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse := VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l79_c5_a208_return_output;
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse := VAR_tag_capture_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_axis128_t_aeac_strip_auth_tag_c_l40_c3_8eaf_return_output;
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue := VAR_tag_capture_reg_MUX_strip_auth_tag_c_l46_c5_0288_return_output;
     -- cyphertext_reg_MUX[strip_auth_tag_c_l40_c3_8eaf] LATENCY=0
     -- Inputs
     cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond <= VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond;
     cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue <= VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue;
     cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse <= VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse;
     -- Outputs
     VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output := cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;

     -- state_MUX[strip_auth_tag_c_l40_c3_8eaf] LATENCY=0
     -- Inputs
     state_MUX_strip_auth_tag_c_l40_c3_8eaf_cond <= VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_cond;
     state_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue <= VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue;
     state_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse <= VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse;
     -- Outputs
     VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output := state_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;

     -- strip_auth_tag_auth_tag_out_MUX[strip_auth_tag_c_l40_c3_8eaf] LATENCY=0
     -- Inputs
     strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_cond <= VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_cond;
     strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue <= VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue;
     strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse <= VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse;
     -- Outputs
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output := strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;

     -- tag_capture_reg_MUX[strip_auth_tag_c_l40_c3_8eaf] LATENCY=0
     -- Inputs
     tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond <= VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_cond;
     tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue <= VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iftrue;
     tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse <= VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_iffalse;
     -- Outputs
     VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output := tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;

     -- Submodule level 5
     REG_VAR_cyphertext_reg := VAR_cyphertext_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;
     REG_VAR_state := VAR_state_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;
     VAR_strip_auth_tag_auth_tag_out := VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;
     REG_VAR_tag_capture_reg := VAR_tag_capture_reg_MUX_strip_auth_tag_c_l40_c3_8eaf_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_state <= REG_VAR_state;
REG_COMB_cyphertext_reg <= REG_VAR_cyphertext_reg;
REG_COMB_tag_capture_reg <= REG_VAR_tag_capture_reg;
-- Global wires driven various places in pipeline
if clk_en_internal='1' then
  module_to_global.strip_auth_tag_axis_in_ready <= VAR_strip_auth_tag_axis_in_ready;
else
  module_to_global.strip_auth_tag_axis_in_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.strip_auth_tag_axis_out <= VAR_strip_auth_tag_axis_out;
else
  module_to_global.strip_auth_tag_axis_out <= axis128_t_stream_t_NULL;
end if;
if clk_en_internal='1' then
  module_to_global.strip_auth_tag_auth_tag_out <= VAR_strip_auth_tag_auth_tag_out;
else
  module_to_global.strip_auth_tag_auth_tag_out <= uint128_t_stream_t_NULL;
end if;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     state <= REG_COMB_state;
     cyphertext_reg <= REG_COMB_cyphertext_reg;
     tag_capture_reg <= REG_COMB_tag_capture_reg;
 end if;
 end if;
end process;

end arch;
