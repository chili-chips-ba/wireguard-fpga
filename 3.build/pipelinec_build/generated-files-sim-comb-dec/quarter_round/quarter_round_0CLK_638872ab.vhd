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
-- Submodules: 24
entity quarter_round_0CLK_638872ab is
port(
 s : in chacha20_state;
 a : in unsigned(3 downto 0);
 b : in unsigned(3 downto 0);
 c : in unsigned(3 downto 0);
 d : in unsigned(3 downto 0);
 return_output : out chacha20_state);
end quarter_round_0CLK_638872ab;
architecture arch of quarter_round_0CLK_638872ab is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l34_c19_23dd]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l34_c19_cf2d]
signal BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_return_output : unsigned(32 downto 0);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l35_c29_8a3f]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_return_output : unsigned(31 downto 0);

-- BIN_OP_XOR[chacha20_h_l35_c29_e68a]
signal BIN_OP_XOR_chacha20_h_l35_c29_e68a_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l35_c29_e68a_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l35_c29_e68a_return_output : unsigned(31 downto 0);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l36_c19_c231]
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l36_c19_ca7f]
signal BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l37_c29_2e02]
signal BIN_OP_XOR_chacha20_h_l37_c29_2e02_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l37_c29_2e02_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l37_c29_2e02_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l38_c19_4217]
signal BIN_OP_PLUS_chacha20_h_l38_c19_4217_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l38_c19_4217_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l38_c19_4217_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l39_c28_26dc]
signal BIN_OP_XOR_chacha20_h_l39_c28_26dc_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l39_c28_26dc_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l39_c28_26dc_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_h_l40_c19_1925]
signal BIN_OP_PLUS_chacha20_h_l40_c19_1925_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l40_c19_1925_right : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_h_l40_c19_1925_return_output : unsigned(32 downto 0);

-- BIN_OP_XOR[chacha20_h_l41_c28_49b5]
signal BIN_OP_XOR_chacha20_h_l41_c28_49b5_left : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l41_c28_49b5_right : unsigned(31 downto 0);
signal BIN_OP_XOR_chacha20_h_l41_c28_49b5_return_output : unsigned(31 downto 0);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l44_c5_80f4]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l45_c5_efcc]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l46_c5_6a10]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_return_output : uint32_t_array_16_t;

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l47_c5_7763]
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_elem_val : unsigned(31 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_ref_toks_0 : chacha20_state;
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_return_output : uint32_t_array_16_t;

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_ref_toks_0 : chacha20_state;
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_var_dim_0 : unsigned(3 downto 0);
signal VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_return_output : unsigned(31 downto 0);

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
      base.state(1) := ref_toks_0.data(1);
      base.state(4) := ref_toks_0.data(4);
      base.state(7) := ref_toks_0.data(7);
      base.state(13) := ref_toks_0.data(13);
      base.state(10) := ref_toks_0.data(10);
      base.state(2) := ref_toks_0.data(2);
      base.state(8) := ref_toks_0.data(8);
      base.state(5) := ref_toks_0.data(5);
      base.state(11) := ref_toks_0.data(11);
      base.state(14) := ref_toks_0.data(14);
      base.state(0) := ref_toks_0.data(0);
      base.state(6) := ref_toks_0.data(6);
      base.state(3) := ref_toks_0.data(3);
      base.state(9) := ref_toks_0.data(9);
      base.state(12) := ref_toks_0.data(12);
      base.state(15) := ref_toks_0.data(15);

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_return_output);

-- BIN_OP_PLUS_chacha20_h_l34_c19_cf2d : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l34_c19_cf2d : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_left,
BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_right,
BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_return_output);

-- BIN_OP_XOR_chacha20_h_l35_c29_e68a : 0 clocks latency
BIN_OP_XOR_chacha20_h_l35_c29_e68a : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l35_c29_e68a_left,
BIN_OP_XOR_chacha20_h_l35_c29_e68a_right,
BIN_OP_XOR_chacha20_h_l35_c29_e68a_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231 : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231 : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_return_output);

-- BIN_OP_PLUS_chacha20_h_l36_c19_ca7f : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l36_c19_ca7f : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_left,
BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_right,
BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_return_output);

-- BIN_OP_XOR_chacha20_h_l37_c29_2e02 : 0 clocks latency
BIN_OP_XOR_chacha20_h_l37_c29_2e02 : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l37_c29_2e02_left,
BIN_OP_XOR_chacha20_h_l37_c29_2e02_right,
BIN_OP_XOR_chacha20_h_l37_c29_2e02_return_output);

-- BIN_OP_PLUS_chacha20_h_l38_c19_4217 : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l38_c19_4217 : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l38_c19_4217_left,
BIN_OP_PLUS_chacha20_h_l38_c19_4217_right,
BIN_OP_PLUS_chacha20_h_l38_c19_4217_return_output);

-- BIN_OP_XOR_chacha20_h_l39_c28_26dc : 0 clocks latency
BIN_OP_XOR_chacha20_h_l39_c28_26dc : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l39_c28_26dc_left,
BIN_OP_XOR_chacha20_h_l39_c28_26dc_right,
BIN_OP_XOR_chacha20_h_l39_c28_26dc_return_output);

-- BIN_OP_PLUS_chacha20_h_l40_c19_1925 : 0 clocks latency
BIN_OP_PLUS_chacha20_h_l40_c19_1925 : entity work.BIN_OP_PLUS_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_h_l40_c19_1925_left,
BIN_OP_PLUS_chacha20_h_l40_c19_1925_right,
BIN_OP_PLUS_chacha20_h_l40_c19_1925_return_output);

-- BIN_OP_XOR_chacha20_h_l41_c28_49b5 : 0 clocks latency
BIN_OP_XOR_chacha20_h_l41_c28_49b5 : entity work.BIN_OP_XOR_uint32_t_uint32_t_0CLK_de264c78 port map (
BIN_OP_XOR_chacha20_h_l41_c28_49b5_left,
BIN_OP_XOR_chacha20_h_l41_c28_49b5_right,
BIN_OP_XOR_chacha20_h_l41_c28_49b5_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_return_output);

-- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763 : 0 clocks latency
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_elem_val,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_ref_toks_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_var_dim_0,
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_return_output);

-- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72 : 0 clocks latency
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72 : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_ref_toks_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_var_dim_0,
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 s,
 a,
 b,
 c,
 d,
 -- All submodule outputs
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_return_output,
 BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_return_output,
 BIN_OP_XOR_chacha20_h_l35_c29_e68a_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_return_output,
 BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_return_output,
 BIN_OP_XOR_chacha20_h_l37_c29_2e02_return_output,
 BIN_OP_PLUS_chacha20_h_l38_c19_4217_return_output,
 BIN_OP_XOR_chacha20_h_l39_c28_26dc_return_output,
 BIN_OP_PLUS_chacha20_h_l40_c19_1925_return_output,
 BIN_OP_XOR_chacha20_h_l41_c28_49b5_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_return_output,
 VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_return_output,
 VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_return_output)
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
 variable VAR_a1_chacha20_h_l34_c14_16f1_0 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_return_output : unsigned(32 downto 0);
 variable VAR_d1 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_e68a_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_e68a_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l35_c29_e68a_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_16_chacha20_h_l35_c19_8513_return_output : unsigned(31 downto 0);
 variable VAR_c1 : unsigned(31 downto 0);
 variable VAR_c1_chacha20_h_l36_c14_8a54_0 : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_return_output : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_left : unsigned(31 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_ref_toks_0 : chacha20_state;
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_return_output : unsigned(32 downto 0);
 variable VAR_b1 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_2e02_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_2e02_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l37_c29_2e02_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_12_chacha20_h_l37_c19_0579_return_output : unsigned(31 downto 0);
 variable VAR_a2 : unsigned(31 downto 0);
 variable VAR_a2_chacha20_h_l38_c14_838d_0 : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_4217_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_4217_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l38_c19_4217_return_output : unsigned(32 downto 0);
 variable VAR_d2 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_26dc_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_26dc_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l39_c28_26dc_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_8_chacha20_h_l39_c19_8892_return_output : unsigned(31 downto 0);
 variable VAR_c2 : unsigned(31 downto 0);
 variable VAR_c2_chacha20_h_l40_c14_02d7_0 : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1925_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1925_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1925_return_output : unsigned(32 downto 0);
 variable VAR_b2 : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_49b5_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_49b5_right : unsigned(31 downto 0);
 variable VAR_BIN_OP_XOR_chacha20_h_l41_c28_49b5_return_output : unsigned(31 downto 0);
 variable VAR_rotl32_7_chacha20_h_l41_c19_2d88_return_output : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_efcc_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_6a10_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_return_output : uint32_t_array_16_t;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_elem_val : unsigned(31 downto 0);
 variable VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_7763_return_output : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_var_dim_0 : unsigned(3 downto 0);
 variable VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_7a79_return_output : chacha20_state;
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_ref_toks_0 : chacha20_state;
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_var_dim_0 : unsigned(3 downto 0);
 variable VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_return_output : unsigned(31 downto 0);
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
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_var_dim_0 := VAR_a;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_var_dim_0 := VAR_a;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_var_dim_0 := VAR_b;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_var_dim_0 := VAR_b;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_var_dim_0 := VAR_c;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_var_dim_0 := VAR_c;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_var_dim_0 := VAR_d;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_var_dim_0 := VAR_d;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_ref_toks_0 := VAR_s;
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_ref_toks_0 := VAR_s;
     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l36_c19_c231] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72 LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l35_c29_8a3f] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_return_output;

     -- VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d[chacha20_h_l34_c19_23dd] LATENCY=0
     -- Inputs
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_ref_toks_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_ref_toks_0;
     VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_var_dim_0 <= VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_var_dim_0;
     -- Outputs
     VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_return_output := VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_return_output;

     -- Submodule level 1
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_c19_23dd_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_e68a_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l35_c29_8a3f_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l36_c19_c231_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_right := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_2e02_left := VAR_VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_chacha20_h_l34_l37_DUPLICATE_2a72_return_output;
     -- BIN_OP_PLUS[chacha20_h_l34_c19_cf2d] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_left <= VAR_BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_left;
     BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_right <= VAR_BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_return_output := BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_return_output;

     -- Submodule level 2
     VAR_a1_chacha20_h_l34_c14_16f1_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l34_c19_cf2d_return_output, 32);
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_4217_left := VAR_a1_chacha20_h_l34_c14_16f1_0;
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_e68a_right := VAR_a1_chacha20_h_l34_c14_16f1_0;
     -- BIN_OP_XOR[chacha20_h_l35_c29_e68a] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l35_c29_e68a_left <= VAR_BIN_OP_XOR_chacha20_h_l35_c29_e68a_left;
     BIN_OP_XOR_chacha20_h_l35_c29_e68a_right <= VAR_BIN_OP_XOR_chacha20_h_l35_c29_e68a_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_e68a_return_output := BIN_OP_XOR_chacha20_h_l35_c29_e68a_return_output;

     -- Submodule level 3
     -- rotl32_16[chacha20_h_l35_c19_8513] LATENCY=0
     VAR_rotl32_16_chacha20_h_l35_c19_8513_return_output := rotl32_16(
     VAR_BIN_OP_XOR_chacha20_h_l35_c29_e68a_return_output);

     -- Submodule level 4
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_right := VAR_rotl32_16_chacha20_h_l35_c19_8513_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_26dc_left := VAR_rotl32_16_chacha20_h_l35_c19_8513_return_output;
     -- BIN_OP_PLUS[chacha20_h_l36_c19_ca7f] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_left <= VAR_BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_left;
     BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_right <= VAR_BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_return_output := BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_return_output;

     -- Submodule level 5
     VAR_c1_chacha20_h_l36_c14_8a54_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l36_c19_ca7f_return_output, 32);
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1925_left := VAR_c1_chacha20_h_l36_c14_8a54_0;
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_2e02_right := VAR_c1_chacha20_h_l36_c14_8a54_0;
     -- BIN_OP_XOR[chacha20_h_l37_c29_2e02] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l37_c29_2e02_left <= VAR_BIN_OP_XOR_chacha20_h_l37_c29_2e02_left;
     BIN_OP_XOR_chacha20_h_l37_c29_2e02_right <= VAR_BIN_OP_XOR_chacha20_h_l37_c29_2e02_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_2e02_return_output := BIN_OP_XOR_chacha20_h_l37_c29_2e02_return_output;

     -- Submodule level 6
     -- rotl32_12[chacha20_h_l37_c19_0579] LATENCY=0
     VAR_rotl32_12_chacha20_h_l37_c19_0579_return_output := rotl32_12(
     VAR_BIN_OP_XOR_chacha20_h_l37_c29_2e02_return_output);

     -- Submodule level 7
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_4217_right := VAR_rotl32_12_chacha20_h_l37_c19_0579_return_output;
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_49b5_left := VAR_rotl32_12_chacha20_h_l37_c19_0579_return_output;
     -- BIN_OP_PLUS[chacha20_h_l38_c19_4217] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l38_c19_4217_left <= VAR_BIN_OP_PLUS_chacha20_h_l38_c19_4217_left;
     BIN_OP_PLUS_chacha20_h_l38_c19_4217_right <= VAR_BIN_OP_PLUS_chacha20_h_l38_c19_4217_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l38_c19_4217_return_output := BIN_OP_PLUS_chacha20_h_l38_c19_4217_return_output;

     -- Submodule level 8
     VAR_a2_chacha20_h_l38_c14_838d_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l38_c19_4217_return_output, 32);
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_26dc_right := VAR_a2_chacha20_h_l38_c14_838d_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_elem_val := VAR_a2_chacha20_h_l38_c14_838d_0;
     -- BIN_OP_XOR[chacha20_h_l39_c28_26dc] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l39_c28_26dc_left <= VAR_BIN_OP_XOR_chacha20_h_l39_c28_26dc_left;
     BIN_OP_XOR_chacha20_h_l39_c28_26dc_right <= VAR_BIN_OP_XOR_chacha20_h_l39_c28_26dc_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_26dc_return_output := BIN_OP_XOR_chacha20_h_l39_c28_26dc_return_output;

     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l44_c5_80f4] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_return_output;

     -- Submodule level 9
     -- rotl32_8[chacha20_h_l39_c19_8892] LATENCY=0
     VAR_rotl32_8_chacha20_h_l39_c19_8892_return_output := rotl32_8(
     VAR_BIN_OP_XOR_chacha20_h_l39_c28_26dc_return_output);

     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l45_c5_efcc] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_efcc_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l44_c5_80f4_return_output);

     -- Submodule level 10
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l45_c5_efcc_return_output;
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1925_right := VAR_rotl32_8_chacha20_h_l39_c19_8892_return_output;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_elem_val := VAR_rotl32_8_chacha20_h_l39_c19_8892_return_output;
     -- BIN_OP_PLUS[chacha20_h_l40_c19_1925] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_h_l40_c19_1925_left <= VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1925_left;
     BIN_OP_PLUS_chacha20_h_l40_c19_1925_right <= VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1925_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1925_return_output := BIN_OP_PLUS_chacha20_h_l40_c19_1925_return_output;

     -- Submodule level 11
     VAR_c2_chacha20_h_l40_c14_02d7_0 := resize(VAR_BIN_OP_PLUS_chacha20_h_l40_c19_1925_return_output, 32);
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_49b5_right := VAR_c2_chacha20_h_l40_c14_02d7_0;
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_elem_val := VAR_c2_chacha20_h_l40_c14_02d7_0;
     -- BIN_OP_XOR[chacha20_h_l41_c28_49b5] LATENCY=0
     -- Inputs
     BIN_OP_XOR_chacha20_h_l41_c28_49b5_left <= VAR_BIN_OP_XOR_chacha20_h_l41_c28_49b5_left;
     BIN_OP_XOR_chacha20_h_l41_c28_49b5_right <= VAR_BIN_OP_XOR_chacha20_h_l41_c28_49b5_right;
     -- Outputs
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_49b5_return_output := BIN_OP_XOR_chacha20_h_l41_c28_49b5_return_output;

     -- Submodule level 12
     -- rotl32_7[chacha20_h_l41_c19_2d88] LATENCY=0
     VAR_rotl32_7_chacha20_h_l41_c19_2d88_return_output := rotl32_7(
     VAR_BIN_OP_XOR_chacha20_h_l41_c28_49b5_return_output);

     -- Submodule level 13
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_elem_val := VAR_rotl32_7_chacha20_h_l41_c19_2d88_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l45_c5_efcc] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_return_output;

     -- Submodule level 14
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l46_c5_6a10] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_6a10_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l45_c5_efcc_return_output);

     -- Submodule level 15
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l46_c5_6a10_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l46_c5_6a10] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_return_output;

     -- Submodule level 16
     -- VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l47_c5_7763] LATENCY=0
     VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_7763_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l46_c5_6a10_return_output);

     -- Submodule level 17
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_ref_toks_0 := VAR_VAR_REF_ASSIGN_INPUT_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l47_c5_7763_return_output;
     -- VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da[chacha20_h_l47_c5_7763] LATENCY=0
     -- Inputs
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_elem_val <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_elem_val;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_ref_toks_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_ref_toks_0;
     VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_var_dim_0 <= VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_var_dim_0;
     -- Outputs
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_return_output := VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_return_output;

     -- Submodule level 18
     -- CONST_REF_RD_chacha20_state_chacha20_state_aa26[chacha20_h_l49_c12_7a79] LATENCY=0
     VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_7a79_return_output := CONST_REF_RD_chacha20_state_chacha20_state_aa26(
     VAR_VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_chacha20_h_l47_c5_7763_return_output);

     -- Submodule level 19
     VAR_return_output := VAR_CONST_REF_RD_chacha20_state_chacha20_state_aa26_chacha20_h_l49_c12_7a79_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
