-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.6855351865602201]
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
entity quarter_round_1CLK_5eed1056 is
port(
 clk : in std_logic;
 s : in chacha20_state;
 a : in unsigned(3 downto 0);
 b : in unsigned(3 downto 0);
 c : in unsigned(3 downto 0);
 d : in unsigned(3 downto 0);
 return_output : out chacha20_state);
end quarter_round_1CLK_5eed1056;
architecture arch of quarter_round_1CLK_5eed1056 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 1;
-- All of the wires/regs in function
-- Stage 0
signal REG_STAGE0_BIN_OP_XOR_chacha20_h_l41_c28_a625_left : unsigned(31 downto 0);
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0 : chacha20_state;
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0 : unsigned(3 downto 0);
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0 : unsigned(3 downto 0);
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val : unsigned(31 downto 0);
signal REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0 : unsigned(3 downto 0);
signal COMB_STAGE0_BIN_OP_XOR_chacha20_h_l41_c28_a625_left : unsigned(31 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0 : chacha20_state;
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0 : unsigned(3 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0 : unsigned(3 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val : unsigned(31 downto 0);
signal COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0 : unsigned(3 downto 0);
-- Each function instance gets signals
-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l34_c19_c8aa]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l34_c19_acec]
signal BIN_OP_PLUS_chacha20_h_l34_c19_acec_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l34_c19_acec_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l34_c19_acec_return_output : unsigned(32 downto 0);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l35_c29_fb7d]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_return_output : unsigned(31 downto 0);

-- BIN_OP_XOR[chacha20_h_l35_c29_a882]
signal BIN_OP_XOR_chacha20_h_l35_c29_a882_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l35_c29_a882_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l35_c29_a882_return_output : unsigned(31 downto 0);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l36_c19_feff]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l36_c19_b6d4]
signal BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l37_c29_f23b]
signal BIN_OP_XOR_chacha20_h_l37_c29_f23b_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l37_c29_f23b_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l37_c29_f23b_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l38_c19_cf06]
signal BIN_OP_PLUS_chacha20_h_l38_c19_cf06_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l38_c19_cf06_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l38_c19_cf06_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l39_c28_521d]
signal BIN_OP_XOR_chacha20_h_l39_c28_521d_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l39_c28_521d_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l39_c28_521d_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l40_c19_1476]
signal BIN_OP_PLUS_chacha20_h_l40_c19_1476_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l40_c19_1476_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l40_c19_1476_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l41_c28_a625]
signal BIN_OP_XOR_chacha20_h_l41_c28_a625_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l41_c28_a625_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l41_c28_a625_return_output : unsigned(31 downto 0);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l44_c5_39f2]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l45_c5_01d8]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l46_c5_a716]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l47_c5_779b]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_return_output : uint32_t_array_16_t;

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_return_output : unsigned(31 downto 0);

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
      base.state(2) := ref_toks_0.data(2);
      base.state(5) := ref_toks_0.data(5);
      base.state(11) := ref_toks_0.data(11);
      base.state(8) := ref_toks_0.data(8);
      base.state(14) := ref_toks_0.data(14);

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_return_output);

-- BIN_OP_PLUS_chacha20_h_l34_c19_acec : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l34_c19_acec : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l34_c19_acec_left,
BIN_OP_PLUS_chacha20_h_l34_c19_acec_right,
BIN_OP_PLUS_chacha20_h_l34_c19_acec_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_return_output);

-- BIN_OP_XOR_chacha20_h_l35_c29_a882 : 0 clocks latency
BIN_OP_XOR_chacha20_h_l35_c29_a882 : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l35_c29_a882_left,
BIN_OP_XOR_chacha20_h_l35_c29_a882_right,
BIN_OP_XOR_chacha20_h_l35_c29_a882_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_return_output);

-- BIN_OP_PLUS_chacha20_h_l36_c19_b6d4 : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l36_c19_b6d4 : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_left,
BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_right,
BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_return_output);

-- BIN_OP_XOR_chacha20_h_l37_c29_f23b : 0 clocks latency
BIN_OP_XOR_chacha20_h_l37_c29_f23b : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l37_c29_f23b_left,
BIN_OP_XOR_chacha20_h_l37_c29_f23b_right,
BIN_OP_XOR_chacha20_h_l37_c29_f23b_return_output);

-- BIN_OP_PLUS_chacha20_h_l38_c19_cf06 : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l38_c19_cf06 : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l38_c19_cf06_left,
BIN_OP_PLUS_chacha20_h_l38_c19_cf06_right,
BIN_OP_PLUS_chacha20_h_l38_c19_cf06_return_output);

-- BIN_OP_XOR_chacha20_h_l39_c28_521d : 0 clocks latency
BIN_OP_XOR_chacha20_h_l39_c28_521d : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l39_c28_521d_left,
BIN_OP_XOR_chacha20_h_l39_c28_521d_right,
BIN_OP_XOR_chacha20_h_l39_c28_521d_return_output);

-- BIN_OP_PLUS_chacha20_h_l40_c19_1476 : 1 clocks latency
BIN_OP_PLUS_chacha20_h_l40_c19_1476 : entity work.BIN_OP_PLUS_uint32_t_uint32_t_1CLK_a32e178e port map (
clk,
BIN_OP_PLUS_chacha20_h_l40_c19_1476_left,
BIN_OP_PLUS_chacha20_h_l40_c19_1476_right,
BIN_OP_PLUS_chacha20_h_l40_c19_1476_return_output);

-- BIN_OP_XOR_chacha20_h_l41_c28_a625 : 0 clocks latency
BIN_OP_XOR_chacha20_h_l41_c28_a625 : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l41_c28_a625_left,
BIN_OP_XOR_chacha20_h_l41_c28_a625_right,
BIN_OP_XOR_chacha20_h_l41_c28_a625_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2 : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2 : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_return_output);



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
 REG_STAGE0_BIN_OP_XOR_chacha20_h_l41_c28_a625_left,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val,
 REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0,
 -- All submodule outputs
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_return_output,
 BIN_OP_PLUS_chacha20_h_l34_c19_acec_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_return_output,
 BIN_OP_XOR_chacha20_h_l35_c29_a882_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_return_output,
 BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_return_output,
 BIN_OP_XOR_chacha20_h_l37_c29_f23b_return_output,
 BIN_OP_PLUS_chacha20_h_l38_c19_cf06_return_output,
 BIN_OP_XOR_chacha20_h_l39_c28_521d_return_output,
 BIN_OP_PLUS_chacha20_h_l40_c19_1476_return_output,
 BIN_OP_XOR_chacha20_h_l41_c28_a625_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_return_output)
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
 variable VAR_a1_chacha20_h_l34_c14_c12d_0 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_acec_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_acec_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_acec_return_output : unsigned(32 downto 0);
 variable VAR_d1 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_a882_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_a882_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_a882_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_16_chacha20_h_l35_c19_f3d0_return_output : unsigned(31 downto 0);
 variable VAR_c1 : unsigned(31 downto 0);
 variable VAR_c1_chacha20_h_l36_c14_2057_0 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_return_output : unsigned(32 downto 0);
 variable VAR_b1 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_f23b_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_f23b_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_f23b_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_12_chacha20_h_l37_c19_ba0e_return_output : unsigned(31 downto 0);
 variable VAR_a2 : unsigned(31 downto 0);
 variable VAR_a2_chacha20_h_l38_c14_b1cc_0 : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_cf06_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_cf06_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_cf06_return_output : unsigned(32 downto 0);
 variable VAR_d2 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_521d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_521d_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_521d_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_8_chacha20_h_l39_c19_d620_return_output : unsigned(31 downto 0);
 variable VAR_c2 : unsigned(31 downto 0);
 variable VAR_c2_chacha20_h_l40_c14_6774_0 : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1476_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1476_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1476_return_output : unsigned(32 downto 0);
 variable VAR_b2 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_7_chacha20_h_l41_c19_6f40_return_output : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_01d8_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_a716_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_779b_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0 : unsigned(3 downto 0);
 variable VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_7c19_return_output : chacha20_state;
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_return_output : unsigned(31 downto 0);
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
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_var_dim_0 := VAR_a;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_var_dim_0 := VAR_a;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0 := VAR_b;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_var_dim_0 := VAR_b;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0 := VAR_c;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_var_dim_0 := VAR_c;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0 := VAR_d;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_var_dim_0 := VAR_d;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_ref_toks_0 := VAR_s;
     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2 LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l34_c19_c8aa] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l36_c19_feff] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l35_c29_fb7d] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_return_output;

     -- Submodule level 1
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_acec_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_c8aa_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_a882_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_fb7d_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_feff_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_acec_right := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_f23b_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l37_l34_DUPLICATE_fdd2_return_output;
     -- BIN_OP_PLUS[chacha20_h_l34_c19_acec] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l34_c19_acec_left <= VAR_BIN_OP_PLUS_chacha20_h_l34_c19_acec_left;
     BIN_OP_PLUS_chacha20_h_l34_c19_acec_right <= VAR_BIN_OP_PLUS_chacha20_h_l34_c19_acec_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_acec_return_output := BIN_OP_PLUS_chacha20_h_l34_c19_acec_return_output;

     -- Submodule level 2
     VAR_a1_chacha20_h_l34_c14_c12d_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l34_c19_acec_return_output, 32);
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_cf06_left := VAR_a1_chacha20_h_l34_c14_c12d_0;
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_a882_right := VAR_a1_chacha20_h_l34_c14_c12d_0;
     -- BIN_OP_XOR[chacha20_h_l35_c29_a882] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l35_c29_a882_left <= VAR_BIN_OP_XOR_chacha20_h_l35_c29_a882_left;
     BIN_OP_XOR_chacha20_h_l35_c29_a882_right <= VAR_BIN_OP_XOR_chacha20_h_l35_c29_a882_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_a882_return_output := BIN_OP_XOR_chacha20_h_l35_c29_a882_return_output;

     -- Submodule level 3
     -- rotl32_16[chacha20_h_l35_c19_f3d0] LATENCY=0
     VAR_rotl32_16_chacha20_h_l35_c19_f3d0_return_output := rotl32_16(
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_a882_return_output);

     -- Submodule level 4
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_right := VAR_rotl32_16_chacha20_h_l35_c19_f3d0_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_521d_left := VAR_rotl32_16_chacha20_h_l35_c19_f3d0_return_output;
     -- BIN_OP_PLUS[chacha20_h_l36_c19_b6d4] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_left <= VAR_BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_left;
     BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_right <= VAR_BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_return_output := BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_return_output;

     -- Submodule level 5
     VAR_c1_chacha20_h_l36_c14_2057_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l36_c19_b6d4_return_output, 32);
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1476_left := VAR_c1_chacha20_h_l36_c14_2057_0;
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_f23b_right := VAR_c1_chacha20_h_l36_c14_2057_0;
     -- BIN_OP_XOR[chacha20_h_l37_c29_f23b] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l37_c29_f23b_left <= VAR_BIN_OP_XOR_chacha20_h_l37_c29_f23b_left;
     BIN_OP_XOR_chacha20_h_l37_c29_f23b_right <= VAR_BIN_OP_XOR_chacha20_h_l37_c29_f23b_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_f23b_return_output := BIN_OP_XOR_chacha20_h_l37_c29_f23b_return_output;

     -- Submodule level 6
     -- rotl32_12[chacha20_h_l37_c19_ba0e] LATENCY=0
     VAR_rotl32_12_chacha20_h_l37_c19_ba0e_return_output := rotl32_12(
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_f23b_return_output);

     -- Submodule level 7
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_cf06_right := VAR_rotl32_12_chacha20_h_l37_c19_ba0e_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_left := VAR_rotl32_12_chacha20_h_l37_c19_ba0e_return_output;
     -- BIN_OP_PLUS[chacha20_h_l38_c19_cf06] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l38_c19_cf06_left <= VAR_BIN_OP_PLUS_chacha20_h_l38_c19_cf06_left;
     BIN_OP_PLUS_chacha20_h_l38_c19_cf06_right <= VAR_BIN_OP_PLUS_chacha20_h_l38_c19_cf06_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_cf06_return_output := BIN_OP_PLUS_chacha20_h_l38_c19_cf06_return_output;

     -- Submodule level 8
     VAR_a2_chacha20_h_l38_c14_b1cc_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l38_c19_cf06_return_output, 32);
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_521d_right := VAR_a2_chacha20_h_l38_c14_b1cc_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_elem_val := VAR_a2_chacha20_h_l38_c14_b1cc_0;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l44_c5_39f2] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_return_output;

     -- BIN_OP_XOR[chacha20_h_l39_c28_521d] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l39_c28_521d_left <= VAR_BIN_OP_XOR_chacha20_h_l39_c28_521d_left;
     BIN_OP_XOR_chacha20_h_l39_c28_521d_right <= VAR_BIN_OP_XOR_chacha20_h_l39_c28_521d_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_521d_return_output := BIN_OP_XOR_chacha20_h_l39_c28_521d_return_output;

     -- Submodule level 9
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l45_c5_01d8] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_01d8_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_39f2_return_output);

     -- rotl32_8[chacha20_h_l39_c19_d620] LATENCY=0
     VAR_rotl32_8_chacha20_h_l39_c19_d620_return_output := rotl32_8(
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_521d_return_output);

     -- Submodule level 10
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_01d8_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1476_right := VAR_rotl32_8_chacha20_h_l39_c19_d620_return_output;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val := VAR_rotl32_8_chacha20_h_l39_c19_d620_return_output;
     -- BIN_OP_PLUS[chacha20_h_l40_c19_1476] LATENCY=1
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l40_c19_1476_left <= VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1476_left;
     BIN_OP_PLUS_chacha20_h_l40_c19_1476_right <= VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1476_right;

     -- Write to comb signals
     COMB_STAGE0_BIN_OP_XOR_chacha20_h_l41_c28_a625_left <= VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_left;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val;
     COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0;
   elsif STAGE = 1 then
     -- Read from prev stage
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_left := REG_STAGE0_BIN_OP_XOR_chacha20_h_l41_c28_a625_left;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0 := REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0;
     -- Submodule outputs
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1476_return_output := BIN_OP_PLUS_chacha20_h_l40_c19_1476_return_output;

     -- Submodule level 0
     VAR_c2_chacha20_h_l40_c14_6774_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1476_return_output, 32);
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_right := VAR_c2_chacha20_h_l40_c14_6774_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_elem_val := VAR_c2_chacha20_h_l40_c14_6774_0;
     -- BIN_OP_XOR[chacha20_h_l41_c28_a625] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l41_c28_a625_left <= VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_left;
     BIN_OP_XOR_chacha20_h_l41_c28_a625_right <= VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_return_output := BIN_OP_XOR_chacha20_h_l41_c28_a625_return_output;

     -- Submodule level 1
     -- rotl32_7[chacha20_h_l41_c19_6f40] LATENCY=0
     VAR_rotl32_7_chacha20_h_l41_c19_6f40_return_output := rotl32_7(
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_a625_return_output);

     -- Submodule level 2
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_elem_val := VAR_rotl32_7_chacha20_h_l41_c19_6f40_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l45_c5_01d8] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_return_output;

     -- Submodule level 3
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l46_c5_a716] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_a716_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_return_output);

     -- Submodule level 4
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_a716_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l46_c5_a716] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_return_output;

     -- Submodule level 5
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l47_c5_779b] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_779b_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_return_output);

     -- Submodule level 6
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_779b_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l47_c5_779b] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_return_output;

     -- Submodule level 7
     -- CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l49_c12_7c19] LATENCY=0
     VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_7c19_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_return_output);

     -- Submodule level 8
     VAR_return_output := VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_7c19_return_output;
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
     REG_STAGE0_BIN_OP_XOR_chacha20_h_l41_c28_a625_left <= COMB_STAGE0_BIN_OP_XOR_chacha20_h_l41_c28_a625_left;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_ref_toks_0;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_01d8_var_dim_0;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_a716_var_dim_0;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_elem_val;
     REG_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0 <= COMB_STAGE0_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_779b_var_dim_0;
 end if;
end process;

end arch;
