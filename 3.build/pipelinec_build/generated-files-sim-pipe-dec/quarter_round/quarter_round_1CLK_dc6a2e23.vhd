-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.868364116833756]
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
entity quarter_round_1CLK_dc6a2e23 is
port(
 clk : in std_logic;
 s : in chacha20_state;
 a : in unsigned(3 downto 0);
 b : in unsigned(3 downto 0);
 c : in unsigned(3 downto 0);
 d : in unsigned(3 downto 0);
 return_output : out chacha20_state);
end quarter_round_1CLK_dc6a2e23;
architecture arch of quarter_round_1CLK_dc6a2e23 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 1;
-- All of the wires/regs in function
-- Stage 0
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val : unsigned(31 downto 0);
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0 : unsigned(3 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val : unsigned(31 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0 : unsigned(3 downto 0);
-- Each function instance gets signals
-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l34_c19_ea71]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l34_c19_b3cc]
signal BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_return_output : unsigned(32 downto 0);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l35_c29_a0c0]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_return_output : unsigned(31 downto 0);

-- BIN_OP_XOR[chacha20_h_l35_c29_aa87]
signal BIN_OP_XOR_chacha20_h_l35_c29_aa87_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l35_c29_aa87_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l35_c29_aa87_return_output : unsigned(31 downto 0);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l36_c19_8ef7]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l36_c19_c64c]
signal BIN_OP_PLUS_chacha20_h_l36_c19_c64c_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l36_c19_c64c_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l36_c19_c64c_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l37_c29_0243]
signal BIN_OP_XOR_chacha20_h_l37_c29_0243_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l37_c29_0243_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l37_c29_0243_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l38_c19_993c]
signal BIN_OP_PLUS_chacha20_h_l38_c19_993c_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l38_c19_993c_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l38_c19_993c_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l39_c28_6339]
signal BIN_OP_XOR_chacha20_h_l39_c28_6339_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l39_c28_6339_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l39_c28_6339_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l40_c19_e46b]
signal BIN_OP_PLUS_chacha20_h_l40_c19_e46b_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l40_c19_e46b_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l40_c19_e46b_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l41_c28_32a6]
signal BIN_OP_XOR_chacha20_h_l41_c28_32a6_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l41_c28_32a6_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l41_c28_32a6_return_output : unsigned(31 downto 0);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l44_c5_250f]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l45_c5_9948]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l46_c5_6661]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l47_c5_aa92]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_return_output : uint32_t_array_16_t;

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_return_output : unsigned(31 downto 0);

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
      base.state(2) := ref_toks_0.data(2);
      base.state(5) := ref_toks_0.data(5);
      base.state(11) := ref_toks_0.data(11);
      base.state(8) := ref_toks_0.data(8);
      base.state(14) := ref_toks_0.data(14);
      base.state(0) := ref_toks_0.data(0);
      base.state(3) := ref_toks_0.data(3);
      base.state(9) := ref_toks_0.data(9);
      base.state(6) := ref_toks_0.data(6);
      base.state(12) := ref_toks_0.data(12);
      base.state(15) := ref_toks_0.data(15);
      base.state(4) := ref_toks_0.data(4);
      base.state(1) := ref_toks_0.data(1);
      base.state(7) := ref_toks_0.data(7);
      base.state(10) := ref_toks_0.data(10);
      base.state(13) := ref_toks_0.data(13);

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71 : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71 : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_return_output);

-- BIN_OP_PLUS_chacha20_h_l34_c19_b3cc : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l34_c19_b3cc : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_left,
BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_right,
BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0 : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0 : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_return_output);

-- BIN_OP_XOR_chacha20_h_l35_c29_aa87 : 0 clocks latency
BIN_OP_XOR_chacha20_h_l35_c29_aa87 : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l35_c29_aa87_left,
BIN_OP_XOR_chacha20_h_l35_c29_aa87_right,
BIN_OP_XOR_chacha20_h_l35_c29_aa87_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7 : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7 : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_return_output);

-- BIN_OP_PLUS_chacha20_h_l36_c19_c64c : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l36_c19_c64c : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l36_c19_c64c_left,
BIN_OP_PLUS_chacha20_h_l36_c19_c64c_right,
BIN_OP_PLUS_chacha20_h_l36_c19_c64c_return_output);

-- BIN_OP_XOR_chacha20_h_l37_c29_0243 : 0 clocks latency
BIN_OP_XOR_chacha20_h_l37_c29_0243 : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l37_c29_0243_left,
BIN_OP_XOR_chacha20_h_l37_c29_0243_right,
BIN_OP_XOR_chacha20_h_l37_c29_0243_return_output);

-- BIN_OP_PLUS_chacha20_h_l38_c19_993c : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l38_c19_993c : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l38_c19_993c_left,
BIN_OP_PLUS_chacha20_h_l38_c19_993c_right,
BIN_OP_PLUS_chacha20_h_l38_c19_993c_return_output);

-- BIN_OP_XOR_chacha20_h_l39_c28_6339 : 0 clocks latency
BIN_OP_XOR_chacha20_h_l39_c28_6339 : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l39_c28_6339_left,
BIN_OP_XOR_chacha20_h_l39_c28_6339_right,
BIN_OP_XOR_chacha20_h_l39_c28_6339_return_output);

-- BIN_OP_PLUS_chacha20_h_l40_c19_e46b : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l40_c19_e46b : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l40_c19_e46b_left,
BIN_OP_PLUS_chacha20_h_l40_c19_e46b_right,
BIN_OP_PLUS_chacha20_h_l40_c19_e46b_return_output);

-- BIN_OP_XOR_chacha20_h_l41_c28_32a6 : 0 clocks latency
BIN_OP_XOR_chacha20_h_l41_c28_32a6 : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l41_c28_32a6_left,
BIN_OP_XOR_chacha20_h_l41_c28_32a6_right,
BIN_OP_XOR_chacha20_h_l41_c28_32a6_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661 : 1 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_1CLK_52f34dbc port map (
clk,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_return_output);



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
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0,
 -- All submodule outputs
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_return_output,
 BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_return_output,
 BIN_OP_XOR_chacha20_h_l35_c29_aa87_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_return_output,
 BIN_OP_PLUS_chacha20_h_l36_c19_c64c_return_output,
 BIN_OP_XOR_chacha20_h_l37_c29_0243_return_output,
 BIN_OP_PLUS_chacha20_h_l38_c19_993c_return_output,
 BIN_OP_XOR_chacha20_h_l39_c28_6339_return_output,
 BIN_OP_PLUS_chacha20_h_l40_c19_e46b_return_output,
 BIN_OP_XOR_chacha20_h_l41_c28_32a6_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_return_output)
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
 variable VAR_a1_chacha20_h_l34_c14_a64c_0 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_return_output : unsigned(32 downto 0);
 variable VAR_d1 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_aa87_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_aa87_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_aa87_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_16_chacha20_h_l35_c19_02ff_return_output : unsigned(31 downto 0);
 variable VAR_c1 : unsigned(31 downto 0);
 variable VAR_c1_chacha20_h_l36_c14_c749_0 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_c64c_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_c64c_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_c64c_return_output : unsigned(32 downto 0);
 variable VAR_b1 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_0243_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_0243_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_0243_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_12_chacha20_h_l37_c19_f1fb_return_output : unsigned(31 downto 0);
 variable VAR_a2 : unsigned(31 downto 0);
 variable VAR_a2_chacha20_h_l38_c14_966a_0 : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_993c_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_993c_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_993c_return_output : unsigned(32 downto 0);
 variable VAR_d2 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_6339_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_6339_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_6339_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_8_chacha20_h_l39_c19_1fa8_return_output : unsigned(31 downto 0);
 variable VAR_c2 : unsigned(31 downto 0);
 variable VAR_c2_chacha20_h_l40_c14_0ec3_0 : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_e46b_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_e46b_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_e46b_return_output : unsigned(32 downto 0);
 variable VAR_b2 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_32a6_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_32a6_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_32a6_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_7_chacha20_h_l41_c19_a46e_return_output : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_9948_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_6661_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_aa92_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0 : unsigned(3 downto 0);
 variable VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_f4fc_return_output : chacha20_state;
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_return_output : unsigned(31 downto 0);
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
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_var_dim_0 := VAR_a;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_var_dim_0 := VAR_a;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_var_dim_0 := VAR_b;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_var_dim_0 := VAR_b;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_var_dim_0 := VAR_c;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_var_dim_0 := VAR_c;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0 := VAR_d;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_var_dim_0 := VAR_d;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_ref_toks_0 := VAR_s;
     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l34_c19_ea71] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l36_c19_8ef7] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l35_c29_a0c0] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_return_output;

     -- Submodule level 1
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_ea71_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_aa87_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_a0c0_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_c64c_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_8ef7_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_right := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_0243_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_5a0a_return_output;
     -- BIN_OP_PLUS[chacha20_h_l34_c19_b3cc] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_left <= VAR_BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_left;
     BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_right <= VAR_BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_return_output := BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_return_output;

     -- Submodule level 2
     VAR_a1_chacha20_h_l34_c14_a64c_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l34_c19_b3cc_return_output, 32);
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_993c_left := VAR_a1_chacha20_h_l34_c14_a64c_0;
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_aa87_right := VAR_a1_chacha20_h_l34_c14_a64c_0;
     -- BIN_OP_XOR[chacha20_h_l35_c29_aa87] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l35_c29_aa87_left <= VAR_BIN_OP_XOR_chacha20_h_l35_c29_aa87_left;
     BIN_OP_XOR_chacha20_h_l35_c29_aa87_right <= VAR_BIN_OP_XOR_chacha20_h_l35_c29_aa87_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_aa87_return_output := BIN_OP_XOR_chacha20_h_l35_c29_aa87_return_output;

     -- Submodule level 3
     -- rotl32_16[chacha20_h_l35_c19_02ff] LATENCY=0
     VAR_rotl32_16_chacha20_h_l35_c19_02ff_return_output := rotl32_16(
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_aa87_return_output);

     -- Submodule level 4
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_c64c_right := VAR_rotl32_16_chacha20_h_l35_c19_02ff_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_6339_left := VAR_rotl32_16_chacha20_h_l35_c19_02ff_return_output;
     -- BIN_OP_PLUS[chacha20_h_l36_c19_c64c] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l36_c19_c64c_left <= VAR_BIN_OP_PLUS_chacha20_h_l36_c19_c64c_left;
     BIN_OP_PLUS_chacha20_h_l36_c19_c64c_right <= VAR_BIN_OP_PLUS_chacha20_h_l36_c19_c64c_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_c64c_return_output := BIN_OP_PLUS_chacha20_h_l36_c19_c64c_return_output;

     -- Submodule level 5
     VAR_c1_chacha20_h_l36_c14_c749_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l36_c19_c64c_return_output, 32);
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_e46b_left := VAR_c1_chacha20_h_l36_c14_c749_0;
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_0243_right := VAR_c1_chacha20_h_l36_c14_c749_0;
     -- BIN_OP_XOR[chacha20_h_l37_c29_0243] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l37_c29_0243_left <= VAR_BIN_OP_XOR_chacha20_h_l37_c29_0243_left;
     BIN_OP_XOR_chacha20_h_l37_c29_0243_right <= VAR_BIN_OP_XOR_chacha20_h_l37_c29_0243_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_0243_return_output := BIN_OP_XOR_chacha20_h_l37_c29_0243_return_output;

     -- Submodule level 6
     -- rotl32_12[chacha20_h_l37_c19_f1fb] LATENCY=0
     VAR_rotl32_12_chacha20_h_l37_c19_f1fb_return_output := rotl32_12(
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_0243_return_output);

     -- Submodule level 7
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_993c_right := VAR_rotl32_12_chacha20_h_l37_c19_f1fb_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_32a6_left := VAR_rotl32_12_chacha20_h_l37_c19_f1fb_return_output;
     -- BIN_OP_PLUS[chacha20_h_l38_c19_993c] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l38_c19_993c_left <= VAR_BIN_OP_PLUS_chacha20_h_l38_c19_993c_left;
     BIN_OP_PLUS_chacha20_h_l38_c19_993c_right <= VAR_BIN_OP_PLUS_chacha20_h_l38_c19_993c_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_993c_return_output := BIN_OP_PLUS_chacha20_h_l38_c19_993c_return_output;

     -- Submodule level 8
     VAR_a2_chacha20_h_l38_c14_966a_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l38_c19_993c_return_output, 32);
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_6339_right := VAR_a2_chacha20_h_l38_c14_966a_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_elem_val := VAR_a2_chacha20_h_l38_c14_966a_0;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l44_c5_250f] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_return_output;

     -- BIN_OP_XOR[chacha20_h_l39_c28_6339] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l39_c28_6339_left <= VAR_BIN_OP_XOR_chacha20_h_l39_c28_6339_left;
     BIN_OP_XOR_chacha20_h_l39_c28_6339_right <= VAR_BIN_OP_XOR_chacha20_h_l39_c28_6339_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_6339_return_output := BIN_OP_XOR_chacha20_h_l39_c28_6339_return_output;

     -- Submodule level 9
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l45_c5_9948] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_9948_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_250f_return_output);

     -- rotl32_8[chacha20_h_l39_c19_1fa8] LATENCY=0
     VAR_rotl32_8_chacha20_h_l39_c19_1fa8_return_output := rotl32_8(
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_6339_return_output);

     -- Submodule level 10
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_9948_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_e46b_right := VAR_rotl32_8_chacha20_h_l39_c19_1fa8_return_output;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val := VAR_rotl32_8_chacha20_h_l39_c19_1fa8_return_output;
     -- BIN_OP_PLUS[chacha20_h_l40_c19_e46b] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l40_c19_e46b_left <= VAR_BIN_OP_PLUS_chacha20_h_l40_c19_e46b_left;
     BIN_OP_PLUS_chacha20_h_l40_c19_e46b_right <= VAR_BIN_OP_PLUS_chacha20_h_l40_c19_e46b_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_e46b_return_output := BIN_OP_PLUS_chacha20_h_l40_c19_e46b_return_output;

     -- Submodule level 11
     VAR_c2_chacha20_h_l40_c14_0ec3_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l40_c19_e46b_return_output, 32);
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_32a6_right := VAR_c2_chacha20_h_l40_c14_0ec3_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_elem_val := VAR_c2_chacha20_h_l40_c14_0ec3_0;
     -- BIN_OP_XOR[chacha20_h_l41_c28_32a6] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l41_c28_32a6_left <= VAR_BIN_OP_XOR_chacha20_h_l41_c28_32a6_left;
     BIN_OP_XOR_chacha20_h_l41_c28_32a6_right <= VAR_BIN_OP_XOR_chacha20_h_l41_c28_32a6_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_32a6_return_output := BIN_OP_XOR_chacha20_h_l41_c28_32a6_return_output;

     -- Submodule level 12
     -- rotl32_7[chacha20_h_l41_c19_a46e] LATENCY=0
     VAR_rotl32_7_chacha20_h_l41_c19_a46e_return_output := rotl32_7(
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_32a6_return_output);

     -- Submodule level 13
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_elem_val := VAR_rotl32_7_chacha20_h_l41_c19_a46e_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l45_c5_9948] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_return_output;

     -- Submodule level 14
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l46_c5_6661] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_6661_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_9948_return_output);

     -- Submodule level 15
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_6661_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l46_c5_6661] LATENCY=1
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_var_dim_0;

     -- Write to comb signals
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0;
   elsif STAGE = 1 then
     -- Read from prev stage
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0;
     -- Submodule outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_return_output;

     -- Submodule level 0
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l47_c5_aa92] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_aa92_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6661_return_output);

     -- Submodule level 1
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_aa92_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l47_c5_aa92] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_return_output;

     -- Submodule level 2
     -- CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l49_c12_f4fc] LATENCY=0
     VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_f4fc_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_return_output);

     -- Submodule level 3
     VAR_return_output := VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_f4fc_return_output;
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
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_elem_val;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_aa92_var_dim_0;
 end if;
end process;

end arch;
