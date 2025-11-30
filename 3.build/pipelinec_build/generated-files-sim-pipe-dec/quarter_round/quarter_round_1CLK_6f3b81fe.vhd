-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.38145288377943637]
--   Input regs?: False
--   Output regs?: False
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.c_structs_pkg.all;
-- Submodules: 24
entity quarter_round_1CLK_6f3b81fe is
port(
 clk : in std_logic;
 s : in chacha20_state;
 a : in unsigned(3 downto 0);
 b : in unsigned(3 downto 0);
 c : in unsigned(3 downto 0);
 d : in unsigned(3 downto 0);
 return_output : out chacha20_state);
end quarter_round_1CLK_6f3b81fe;
architecture arch of quarter_round_1CLK_6f3b81fe is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 1;
-- All of the wires/regs in function
-- Stage 0
signal REG_STAGE0_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left : unsigned(31 downto 0);
signal REG_STAGE0_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left : unsigned(31 downto 0);
signal REG_STAGE0_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left : unsigned(31 downto 0);
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0 : chacha20_state;
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0 : unsigned(3 downto 0);
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0 : unsigned(3 downto 0);
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0 : unsigned(3 downto 0);
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0 : unsigned(3 downto 0);
signal COMB_STAGE0_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left : unsigned(31 downto 0);
signal COMB_STAGE0_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left : unsigned(31 downto 0);
signal COMB_STAGE0_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left : unsigned(31 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0 : chacha20_state;
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0 : unsigned(3 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0 : unsigned(3 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0 : unsigned(3 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0 : unsigned(3 downto 0);
-- Each function instance gets signals
-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l34_c19_2b40]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l34_c19_801f]
signal BIN_OP_PLUS_chacha20_h_l34_c19_801f_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l34_c19_801f_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l34_c19_801f_return_output : unsigned(32 downto 0);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l35_c29_670c]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_return_output : unsigned(31 downto 0);

-- BIN_OP_XOR[chacha20_h_l35_c29_fbf9]
signal BIN_OP_XOR_chacha20_h_l35_c29_fbf9_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l35_c29_fbf9_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l35_c29_fbf9_return_output : unsigned(31 downto 0);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l36_c19_e782]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l36_c19_bc57]
signal BIN_OP_PLUS_chacha20_h_l36_c19_bc57_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l36_c19_bc57_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l36_c19_bc57_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l37_c29_8a8b]
signal BIN_OP_XOR_chacha20_h_l37_c29_8a8b_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l37_c29_8a8b_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l37_c29_8a8b_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l38_c19_2dd3]
signal BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l39_c28_f0bb]
signal BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l39_c28_f0bb_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l39_c28_f0bb_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l40_c19_7081]
signal BIN_OP_PLUS_chacha20_h_l40_c19_7081_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l40_c19_7081_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l40_c19_7081_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l41_c28_c51d]
signal BIN_OP_XOR_chacha20_h_l41_c28_c51d_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l41_c28_c51d_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l41_c28_c51d_return_output : unsigned(31 downto 0);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l44_c5_b36f]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l45_c5_2998]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l46_c5_b096]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l47_c5_b99d]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_return_output : uint32_t_array_16_t;

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_return_output : unsigned(31 downto 0);

function rotl32_16( x : unsigned) return unsigned is

  --variable x : unsigned(31 downto 0);
  variable return_output : unsigned(31 downto 0);

begin

    return_output := x rol 16;
    return return_output;

end function;

function rotl32_12( x : unsigned) return unsigned is

  --variable x : unsigned(31 downto 0);
  variable return_output : unsigned(31 downto 0);

begin

    return_output := x rol 12;
    return return_output;

end function;

function rotl32_8( x : unsigned) return unsigned is

  --variable x : unsigned(31 downto 0);
  variable return_output : unsigned(31 downto 0);

begin

    return_output := x rol 8;
    return return_output;

end function;

function rotl32_7( x : unsigned) return unsigned is

  --variable x : unsigned(31 downto 0);
  variable return_output : unsigned(31 downto 0);

begin

    return_output := x rol 7;
    return return_output;

end function;

function CONST_REF_RD_chacha20_state_chacha20_state_aa26( ref_toks_0 : uint32_t_array_16_t) return chacha20_state is
 
  variable base : chacha20_state; 
  variable return_output : chacha20_state;
begin
      base.state(15) := ref_toks_0.data(15);
      base.state(12) := ref_toks_0.data(12);
      base.state(1) := ref_toks_0.data(1);
      base.state(4) := ref_toks_0.data(4);
      base.state(10) := ref_toks_0.data(10);
      base.state(7) := ref_toks_0.data(7);
      base.state(13) := ref_toks_0.data(13);
      base.state(5) := ref_toks_0.data(5);
      base.state(2) := ref_toks_0.data(2);
      base.state(8) := ref_toks_0.data(8);
      base.state(11) := ref_toks_0.data(11);
      base.state(14) := ref_toks_0.data(14);
      base.state(3) := ref_toks_0.data(3);
      base.state(0) := ref_toks_0.data(0);
      base.state(6) := ref_toks_0.data(6);
      base.state(9) := ref_toks_0.data(9);

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40 : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40 : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_return_output);

-- BIN_OP_PLUS_chacha20_h_l34_c19_801f : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l34_c19_801f : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l34_c19_801f_left,
BIN_OP_PLUS_chacha20_h_l34_c19_801f_right,
BIN_OP_PLUS_chacha20_h_l34_c19_801f_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_return_output);

-- BIN_OP_XOR_chacha20_h_l35_c29_fbf9 : 0 clocks latency
BIN_OP_XOR_chacha20_h_l35_c29_fbf9 : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l35_c29_fbf9_left,
BIN_OP_XOR_chacha20_h_l35_c29_fbf9_right,
BIN_OP_XOR_chacha20_h_l35_c29_fbf9_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782 : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782 : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_return_output);

-- BIN_OP_PLUS_chacha20_h_l36_c19_bc57 : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l36_c19_bc57 : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l36_c19_bc57_left,
BIN_OP_PLUS_chacha20_h_l36_c19_bc57_right,
BIN_OP_PLUS_chacha20_h_l36_c19_bc57_return_output);

-- BIN_OP_XOR_chacha20_h_l37_c29_8a8b : 1 clocks latency
BIN_OP_XOR_chacha20_h_l37_c29_8a8b : entity work.BIN_OP_XOR_uint32_t_uint32_t_1CLK_1ce29842 port map (
clk,
BIN_OP_XOR_chacha20_h_l37_c29_8a8b_left,
BIN_OP_XOR_chacha20_h_l37_c29_8a8b_right,
BIN_OP_XOR_chacha20_h_l37_c29_8a8b_return_output);

-- BIN_OP_PLUS_chacha20_h_l38_c19_2dd3 : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l38_c19_2dd3 : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left,
BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_right,
BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_return_output);

-- BIN_OP_XOR_chacha20_h_l39_c28_f0bb : 0 clocks latency
BIN_OP_XOR_chacha20_h_l39_c28_f0bb : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left,
BIN_OP_XOR_chacha20_h_l39_c28_f0bb_right,
BIN_OP_XOR_chacha20_h_l39_c28_f0bb_return_output);

-- BIN_OP_PLUS_chacha20_h_l40_c19_7081 : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l40_c19_7081 : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l40_c19_7081_left,
BIN_OP_PLUS_chacha20_h_l40_c19_7081_right,
BIN_OP_PLUS_chacha20_h_l40_c19_7081_return_output);

-- BIN_OP_XOR_chacha20_h_l41_c28_c51d : 0 clocks latency
BIN_OP_XOR_chacha20_h_l41_c28_c51d : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l41_c28_c51d_left,
BIN_OP_XOR_chacha20_h_l41_c28_c51d_right,
BIN_OP_XOR_chacha20_h_l41_c28_c51d_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 s,
 a,
 b,
 c,
 d,
 -- Registers
 -- Stage 0
 REG_STAGE0_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left,
 REG_STAGE0_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left,
 REG_STAGE0_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0,
 -- All submodule outputs
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_return_output,
 BIN_OP_PLUS_chacha20_h_l34_c19_801f_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_return_output,
 BIN_OP_XOR_chacha20_h_l35_c29_fbf9_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_return_output,
 BIN_OP_PLUS_chacha20_h_l36_c19_bc57_return_output,
 BIN_OP_XOR_chacha20_h_l37_c29_8a8b_return_output,
 BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_return_output,
 BIN_OP_XOR_chacha20_h_l39_c28_f0bb_return_output,
 BIN_OP_PLUS_chacha20_h_l40_c19_7081_return_output,
 BIN_OP_XOR_chacha20_h_l41_c28_c51d_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : chacha20_state;
 variable VAR_s : chacha20_state;
 variable VAR_a : unsigned(3 downto 0);
 variable VAR_b : unsigned(3 downto 0);
 variable VAR_c : unsigned(3 downto 0);
 variable VAR_d : unsigned(3 downto 0);
 variable VAR_o : chacha20_state;
 variable VAR_a1 : unsigned(31 downto 0);
 variable VAR_a1_chacha20_h_l34_c14_6217_0 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_801f_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_801f_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_801f_return_output : unsigned(32 downto 0);
 variable VAR_d1 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_fbf9_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_fbf9_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_fbf9_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_16_chacha20_h_l35_c19_dc08_return_output : unsigned(31 downto 0);
 variable VAR_c1 : unsigned(31 downto 0);
 variable VAR_c1_chacha20_h_l36_c14_ccee_0 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_bc57_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_bc57_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_bc57_return_output : unsigned(32 downto 0);
 variable VAR_b1 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_8a8b_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_8a8b_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_8a8b_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_12_chacha20_h_l37_c19_06fc_return_output : unsigned(31 downto 0);
 variable VAR_a2 : unsigned(31 downto 0);
 variable VAR_a2_chacha20_h_l38_c14_fa14_0 : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_return_output : unsigned(32 downto 0);
 variable VAR_d2 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_8_chacha20_h_l39_c19_98f3_return_output : unsigned(31 downto 0);
 variable VAR_c2 : unsigned(31 downto 0);
 variable VAR_c2_chacha20_h_l40_c14_55f1_0 : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_return_output : unsigned(32 downto 0);
 variable VAR_b2 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_c51d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_c51d_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_c51d_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_7_chacha20_h_l41_c19_73cf_return_output : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_2998_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_b096_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_b99d_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0 : unsigned(3 downto 0);
 variable VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_c5cf_return_output : chacha20_state;
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_return_output : unsigned(31 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_s := s;
     VAR_a := a;
     VAR_b := b;
     VAR_c := c;
     VAR_d := d;

     -- Submodule level 0
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0 := VAR_a;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_var_dim_0 := VAR_a;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0 := VAR_b;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_var_dim_0 := VAR_b;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0 := VAR_c;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_var_dim_0 := VAR_c;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0 := VAR_d;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_var_dim_0 := VAR_d;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_ref_toks_0 := VAR_s;
     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l34_c19_2b40] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l35_c29_670c] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l36_c19_e782] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_return_output;

     -- Submodule level 1
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_801f_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_2b40_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_fbf9_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_670c_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_bc57_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_e782_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_801f_right := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_8a8b_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_02dd_return_output;
     -- BIN_OP_PLUS[chacha20_h_l34_c19_801f] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l34_c19_801f_left <= VAR_BIN_OP_PLUS_chacha20_h_l34_c19_801f_left;
     BIN_OP_PLUS_chacha20_h_l34_c19_801f_right <= VAR_BIN_OP_PLUS_chacha20_h_l34_c19_801f_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_801f_return_output := BIN_OP_PLUS_chacha20_h_l34_c19_801f_return_output;

     -- Submodule level 2
     VAR_a1_chacha20_h_l34_c14_6217_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l34_c19_801f_return_output, 32);
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left := VAR_a1_chacha20_h_l34_c14_6217_0;
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_fbf9_right := VAR_a1_chacha20_h_l34_c14_6217_0;
     -- BIN_OP_XOR[chacha20_h_l35_c29_fbf9] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l35_c29_fbf9_left <= VAR_BIN_OP_XOR_chacha20_h_l35_c29_fbf9_left;
     BIN_OP_XOR_chacha20_h_l35_c29_fbf9_right <= VAR_BIN_OP_XOR_chacha20_h_l35_c29_fbf9_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_fbf9_return_output := BIN_OP_XOR_chacha20_h_l35_c29_fbf9_return_output;

     -- Submodule level 3
     -- rotl32_16[chacha20_h_l35_c19_dc08] LATENCY=0
     VAR_rotl32_16_chacha20_h_l35_c19_dc08_return_output := rotl32_16(
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_fbf9_return_output);

     -- Submodule level 4
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_bc57_right := VAR_rotl32_16_chacha20_h_l35_c19_dc08_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left := VAR_rotl32_16_chacha20_h_l35_c19_dc08_return_output;
     -- BIN_OP_PLUS[chacha20_h_l36_c19_bc57] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l36_c19_bc57_left <= VAR_BIN_OP_PLUS_chacha20_h_l36_c19_bc57_left;
     BIN_OP_PLUS_chacha20_h_l36_c19_bc57_right <= VAR_BIN_OP_PLUS_chacha20_h_l36_c19_bc57_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_bc57_return_output := BIN_OP_PLUS_chacha20_h_l36_c19_bc57_return_output;

     -- Submodule level 5
     VAR_c1_chacha20_h_l36_c14_ccee_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l36_c19_bc57_return_output, 32);
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left := VAR_c1_chacha20_h_l36_c14_ccee_0;
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_8a8b_right := VAR_c1_chacha20_h_l36_c14_ccee_0;
     -- BIN_OP_XOR[chacha20_h_l37_c29_8a8b] LATENCY=1
     -- Inputs
     BIN_OP_XOR_chacha20_h_l37_c29_8a8b_left <= VAR_BIN_OP_XOR_chacha20_h_l37_c29_8a8b_left;
     BIN_OP_XOR_chacha20_h_l37_c29_8a8b_right <= VAR_BIN_OP_XOR_chacha20_h_l37_c29_8a8b_right;

     -- Write to comb signals
     COMB_STAGE0_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left <= VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left;
     COMB_STAGE0_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left <= VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left;
     COMB_STAGE0_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left <= VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0;
   elsif STAGE = 1 then
     -- Read from prev stage
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left := REG_STAGE0_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left;
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left := REG_STAGE0_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left;
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left := REG_STAGE0_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0;
     -- Submodule outputs
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_8a8b_return_output := BIN_OP_XOR_chacha20_h_l37_c29_8a8b_return_output;

     -- Submodule level 0
     -- rotl32_12[chacha20_h_l37_c19_06fc] LATENCY=0
     VAR_rotl32_12_chacha20_h_l37_c19_06fc_return_output := rotl32_12(
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_8a8b_return_output);

     -- Submodule level 1
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_right := VAR_rotl32_12_chacha20_h_l37_c19_06fc_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_c51d_left := VAR_rotl32_12_chacha20_h_l37_c19_06fc_return_output;
     -- BIN_OP_PLUS[chacha20_h_l38_c19_2dd3] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left <= VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left;
     BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_right <= VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_return_output := BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_return_output;

     -- Submodule level 2
     VAR_a2_chacha20_h_l38_c14_fa14_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_return_output, 32);
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_right := VAR_a2_chacha20_h_l38_c14_fa14_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_elem_val := VAR_a2_chacha20_h_l38_c14_fa14_0;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l44_c5_b36f] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_return_output;

     -- BIN_OP_XOR[chacha20_h_l39_c28_f0bb] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left <= VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left;
     BIN_OP_XOR_chacha20_h_l39_c28_f0bb_right <= VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_return_output := BIN_OP_XOR_chacha20_h_l39_c28_f0bb_return_output;

     -- Submodule level 3
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l45_c5_2998] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_2998_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_return_output);

     -- rotl32_8[chacha20_h_l39_c19_98f3] LATENCY=0
     VAR_rotl32_8_chacha20_h_l39_c19_98f3_return_output := rotl32_8(
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_return_output);

     -- Submodule level 4
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_2998_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_right := VAR_rotl32_8_chacha20_h_l39_c19_98f3_return_output;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_elem_val := VAR_rotl32_8_chacha20_h_l39_c19_98f3_return_output;
     -- BIN_OP_PLUS[chacha20_h_l40_c19_7081] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l40_c19_7081_left <= VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left;
     BIN_OP_PLUS_chacha20_h_l40_c19_7081_right <= VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_return_output := BIN_OP_PLUS_chacha20_h_l40_c19_7081_return_output;

     -- Submodule level 5
     VAR_c2_chacha20_h_l40_c14_55f1_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l40_c19_7081_return_output, 32);
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_c51d_right := VAR_c2_chacha20_h_l40_c14_55f1_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_elem_val := VAR_c2_chacha20_h_l40_c14_55f1_0;
     -- BIN_OP_XOR[chacha20_h_l41_c28_c51d] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l41_c28_c51d_left <= VAR_BIN_OP_XOR_chacha20_h_l41_c28_c51d_left;
     BIN_OP_XOR_chacha20_h_l41_c28_c51d_right <= VAR_BIN_OP_XOR_chacha20_h_l41_c28_c51d_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_c51d_return_output := BIN_OP_XOR_chacha20_h_l41_c28_c51d_return_output;

     -- Submodule level 6
     -- rotl32_7[chacha20_h_l41_c19_73cf] LATENCY=0
     VAR_rotl32_7_chacha20_h_l41_c19_73cf_return_output := rotl32_7(
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_c51d_return_output);

     -- Submodule level 7
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_elem_val := VAR_rotl32_7_chacha20_h_l41_c19_73cf_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l45_c5_2998] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_return_output;

     -- Submodule level 8
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l46_c5_b096] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_b096_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_return_output);

     -- Submodule level 9
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_b096_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l46_c5_b096] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_return_output;

     -- Submodule level 10
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l47_c5_b99d] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_b99d_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_return_output);

     -- Submodule level 11
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_b99d_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l47_c5_b99d] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_return_output;

     -- Submodule level 12
     -- CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l49_c12_c5cf] LATENCY=0
     VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_c5cf_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_return_output);

     -- Submodule level 13
     VAR_return_output := VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_c5cf_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
     -- Stage 0
     REG_STAGE0_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left <= COMB_STAGE0_BIN_OP_PLUS_chacha20_h_l38_c19_2dd3_left;
     REG_STAGE0_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left <= COMB_STAGE0_BIN_OP_XOR_chacha20_h_l39_c28_f0bb_left;
     REG_STAGE0_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left <= COMB_STAGE0_BIN_OP_PLUS_chacha20_h_l40_c19_7081_left;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_ref_toks_0;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_b36f_var_dim_0;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_2998_var_dim_0;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_b096_var_dim_0;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_b99d_var_dim_0;
 end if;
end process;

end arch;
