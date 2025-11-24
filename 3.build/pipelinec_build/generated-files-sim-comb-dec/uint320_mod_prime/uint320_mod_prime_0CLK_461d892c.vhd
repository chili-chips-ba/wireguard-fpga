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
entity uint320_mod_prime_0CLK_461d892c is
port(
 a : in u320_t;
 return_output : out u320_t);
end uint320_mod_prime_0CLK_461d892c;
architecture arch of uint320_mod_prime_0CLK_461d892c is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- BIN_OP_AND[poly1305_h_l164_c26_cc3e]
signal BIN_OP_AND_poly1305_h_l164_c26_cc3e_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_cc3e_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_cc3e_return_output : unsigned(63 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c9_e810]
signal BIN_OP_NEQ_poly1305_h_l165_c9_e810_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_e810_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_e810_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c22_f360]
signal BIN_OP_NEQ_poly1305_h_l165_c22_f360_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_f360_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_f360_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_1119]
signal BIN_OP_OR_poly1305_h_l165_c9_1119_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_1119_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_1119_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c36_8296]
signal BIN_OP_NEQ_poly1305_h_l165_c36_8296_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_8296_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_8296_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_429a]
signal BIN_OP_OR_poly1305_h_l165_c9_429a_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_429a_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_429a_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_h_l165_c5_82ac]
signal a_MUX_poly1305_h_l165_c5_82ac_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_h_l165_c5_82ac_iftrue : u320_t;
signal a_MUX_poly1305_h_l165_c5_82ac_iffalse : u320_t;
signal a_MUX_poly1305_h_l165_c5_82ac_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l170_c9_88e6]
signal BIN_OP_AND_poly1305_h_l170_c9_88e6_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_88e6_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_88e6_return_output : unsigned(63 downto 0);

-- CONST_SR_2[poly1305_h_l178_c26_1282]
signal CONST_SR_2_poly1305_h_l178_c26_1282_x : unsigned(63 downto 0);
signal CONST_SR_2_poly1305_h_l178_c26_1282_return_output : unsigned(63 downto 0);

-- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_80e9]
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_left : unsigned(63 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_right : unsigned(2 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_return_output : unsigned(66 downto 0);

-- uint320_add[poly1305_h_l181_c13_d2b6]
signal uint320_add_poly1305_h_l181_c13_d2b6_a : u320_t;
signal uint320_add_poly1305_h_l181_c13_d2b6_b : u320_t;
signal uint320_add_poly1305_h_l181_c13_d2b6_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l185_c10_b384]
signal BIN_OP_AND_poly1305_h_l185_c10_b384_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_b384_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_b384_return_output : unsigned(63 downto 0);

-- BIN_OP_EQ[poly1305_h_l185_c10_6a0f]
signal BIN_OP_EQ_poly1305_h_l185_c10_6a0f_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_6a0f_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_6a0f_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l186_c9_faf6]
signal BIN_OP_EQ_poly1305_h_l186_c9_faf6_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_faf6_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_faf6_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_ac71]
signal BIN_OP_AND_poly1305_h_l185_c10_ac71_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_ac71_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_ac71_return_output : unsigned(0 downto 0);

-- BIN_OP_GTE[poly1305_h_l187_c9_66d6]
signal BIN_OP_GTE_poly1305_h_l187_c9_66d6_left : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_66d6_right : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_66d6_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_6ba2]
signal BIN_OP_AND_poly1305_h_l185_c10_6ba2_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_6ba2_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_6ba2_return_output : unsigned(0 downto 0);

-- a_limbs_0_MUX[poly1305_h_l185_c5_cb02]
signal a_limbs_0_MUX_poly1305_h_l185_c5_cb02_cond : unsigned(0 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iftrue : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iffalse : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_cb02_return_output : unsigned(63 downto 0);

-- a_limbs_1_MUX[poly1305_h_l185_c5_cb02]
signal a_limbs_1_MUX_poly1305_h_l185_c5_cb02_cond : unsigned(0 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iftrue : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iffalse : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_cb02_return_output : unsigned(63 downto 0);

-- a_limbs_2_MUX[poly1305_h_l185_c5_cb02]
signal a_limbs_2_MUX_poly1305_h_l185_c5_cb02_cond : unsigned(0 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iftrue : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iffalse : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_cb02_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l194_c16_8828]
signal BIN_OP_MINUS_poly1305_h_l194_c16_8828_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_8828_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_8828_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l195_c19_09cd]
signal BIN_OP_GT_poly1305_h_l195_c19_09cd_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_09cd_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_09cd_return_output : unsigned(0 downto 0);

-- MUX[poly1305_h_l195_c19_fb61]
signal MUX_poly1305_h_l195_c19_fb61_cond : unsigned(0 downto 0);
signal MUX_poly1305_h_l195_c19_fb61_iftrue : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_fb61_iffalse : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_fb61_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_8456]
signal BIN_OP_MINUS_poly1305_h_l198_c16_8456_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_8456_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_8456_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_6902]
signal BIN_OP_MINUS_poly1305_h_l198_c16_6902_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_6902_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_6902_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l199_c19_bef0]
signal BIN_OP_GT_poly1305_h_l199_c19_bef0_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_bef0_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_bef0_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l199_c42_6a5e]
signal BIN_OP_EQ_poly1305_h_l199_c42_6a5e_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_6a5e_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_6a5e_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l199_c64_86dd]
signal BIN_OP_NEQ_poly1305_h_l199_c64_86dd_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_86dd_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_86dd_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l199_c42_870f]
signal BIN_OP_AND_poly1305_h_l199_c42_870f_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_870f_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_870f_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l199_c19_9c6f]
signal BIN_OP_OR_poly1305_h_l199_c19_9c6f_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_9c6f_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_9c6f_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[poly1305_h_l202_c9_9c9f]
signal BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_return_output : unsigned(63 downto 0);

-- BIN_OP_AND[poly1305_h_l203_c9_6307]
signal BIN_OP_AND_poly1305_h_l203_c9_6307_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_6307_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_6307_return_output : unsigned(63 downto 0);

function CONST_REF_RD_u320_t_u320_t_57df( ref_toks_0 : u320_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned) return u320_t is
 
  variable base : u320_t; 
  variable return_output : u320_t;
begin
      base := ref_toks_0;
      base.limbs(2) := ref_toks_1;
      base.limbs(3) := ref_toks_2;
      base.limbs(4) := ref_toks_3;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_u320_t_u320_t_853a( ref_toks_0 : u320_t;
 ref_toks_1 : unsigned) return u320_t is
 
  variable base : u320_t; 
  variable return_output : u320_t;
begin
      base := ref_toks_0;
      base.limbs(0) := ref_toks_1;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_u320_t_u320_t_b8ef( ref_toks_0 : u320_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned) return u320_t is
 
  variable base : u320_t; 
  variable return_output : u320_t;
begin
      base := ref_toks_0;
      base.limbs(0) := ref_toks_1;
      base.limbs(1) := ref_toks_2;
      base.limbs(2) := ref_toks_3;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_AND_poly1305_h_l164_c26_cc3e : 0 clocks latency
BIN_OP_AND_poly1305_h_l164_c26_cc3e : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l164_c26_cc3e_left,
BIN_OP_AND_poly1305_h_l164_c26_cc3e_right,
BIN_OP_AND_poly1305_h_l164_c26_cc3e_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c9_e810 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c9_e810 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c9_e810_left,
BIN_OP_NEQ_poly1305_h_l165_c9_e810_right,
BIN_OP_NEQ_poly1305_h_l165_c9_e810_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c22_f360 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c22_f360 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c22_f360_left,
BIN_OP_NEQ_poly1305_h_l165_c22_f360_right,
BIN_OP_NEQ_poly1305_h_l165_c22_f360_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_1119 : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_1119 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_1119_left,
BIN_OP_OR_poly1305_h_l165_c9_1119_right,
BIN_OP_OR_poly1305_h_l165_c9_1119_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c36_8296 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c36_8296 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c36_8296_left,
BIN_OP_NEQ_poly1305_h_l165_c36_8296_right,
BIN_OP_NEQ_poly1305_h_l165_c36_8296_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_429a : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_429a : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_429a_left,
BIN_OP_OR_poly1305_h_l165_c9_429a_right,
BIN_OP_OR_poly1305_h_l165_c9_429a_return_output);

-- a_MUX_poly1305_h_l165_c5_82ac : 0 clocks latency
a_MUX_poly1305_h_l165_c5_82ac : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_h_l165_c5_82ac_cond,
a_MUX_poly1305_h_l165_c5_82ac_iftrue,
a_MUX_poly1305_h_l165_c5_82ac_iffalse,
a_MUX_poly1305_h_l165_c5_82ac_return_output);

-- BIN_OP_AND_poly1305_h_l170_c9_88e6 : 0 clocks latency
BIN_OP_AND_poly1305_h_l170_c9_88e6 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l170_c9_88e6_left,
BIN_OP_AND_poly1305_h_l170_c9_88e6_right,
BIN_OP_AND_poly1305_h_l170_c9_88e6_return_output);

-- CONST_SR_2_poly1305_h_l178_c26_1282 : 0 clocks latency
CONST_SR_2_poly1305_h_l178_c26_1282 : entity work.CONST_SR_2_uint64_t_0CLK_de264c78 port map (
CONST_SR_2_poly1305_h_l178_c26_1282_x,
CONST_SR_2_poly1305_h_l178_c26_1282_return_output);

-- BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9 : 0 clocks latency
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9 : entity work.BIN_OP_INFERRED_MULT_uint64_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_left,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_right,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_return_output);

-- uint320_add_poly1305_h_l181_c13_d2b6 : 0 clocks latency
uint320_add_poly1305_h_l181_c13_d2b6 : entity work.uint320_add_0CLK_10d8c973 port map (
uint320_add_poly1305_h_l181_c13_d2b6_a,
uint320_add_poly1305_h_l181_c13_d2b6_b,
uint320_add_poly1305_h_l181_c13_d2b6_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_b384 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_b384 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_b384_left,
BIN_OP_AND_poly1305_h_l185_c10_b384_right,
BIN_OP_AND_poly1305_h_l185_c10_b384_return_output);

-- BIN_OP_EQ_poly1305_h_l185_c10_6a0f : 0 clocks latency
BIN_OP_EQ_poly1305_h_l185_c10_6a0f : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l185_c10_6a0f_left,
BIN_OP_EQ_poly1305_h_l185_c10_6a0f_right,
BIN_OP_EQ_poly1305_h_l185_c10_6a0f_return_output);

-- BIN_OP_EQ_poly1305_h_l186_c9_faf6 : 0 clocks latency
BIN_OP_EQ_poly1305_h_l186_c9_faf6 : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l186_c9_faf6_left,
BIN_OP_EQ_poly1305_h_l186_c9_faf6_right,
BIN_OP_EQ_poly1305_h_l186_c9_faf6_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_ac71 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_ac71 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_ac71_left,
BIN_OP_AND_poly1305_h_l185_c10_ac71_right,
BIN_OP_AND_poly1305_h_l185_c10_ac71_return_output);

-- BIN_OP_GTE_poly1305_h_l187_c9_66d6 : 0 clocks latency
BIN_OP_GTE_poly1305_h_l187_c9_66d6 : entity work.BIN_OP_GTE_uint64_t_uint64_t_0CLK_6f2c5aad port map (
BIN_OP_GTE_poly1305_h_l187_c9_66d6_left,
BIN_OP_GTE_poly1305_h_l187_c9_66d6_right,
BIN_OP_GTE_poly1305_h_l187_c9_66d6_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_6ba2 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_6ba2 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_6ba2_left,
BIN_OP_AND_poly1305_h_l185_c10_6ba2_right,
BIN_OP_AND_poly1305_h_l185_c10_6ba2_return_output);

-- a_limbs_0_MUX_poly1305_h_l185_c5_cb02 : 0 clocks latency
a_limbs_0_MUX_poly1305_h_l185_c5_cb02 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_0_MUX_poly1305_h_l185_c5_cb02_cond,
a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iftrue,
a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iffalse,
a_limbs_0_MUX_poly1305_h_l185_c5_cb02_return_output);

-- a_limbs_1_MUX_poly1305_h_l185_c5_cb02 : 0 clocks latency
a_limbs_1_MUX_poly1305_h_l185_c5_cb02 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_1_MUX_poly1305_h_l185_c5_cb02_cond,
a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iftrue,
a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iffalse,
a_limbs_1_MUX_poly1305_h_l185_c5_cb02_return_output);

-- a_limbs_2_MUX_poly1305_h_l185_c5_cb02 : 0 clocks latency
a_limbs_2_MUX_poly1305_h_l185_c5_cb02 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_2_MUX_poly1305_h_l185_c5_cb02_cond,
a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iftrue,
a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iffalse,
a_limbs_2_MUX_poly1305_h_l185_c5_cb02_return_output);

-- BIN_OP_MINUS_poly1305_h_l194_c16_8828 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l194_c16_8828 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l194_c16_8828_left,
BIN_OP_MINUS_poly1305_h_l194_c16_8828_right,
BIN_OP_MINUS_poly1305_h_l194_c16_8828_return_output);

-- BIN_OP_GT_poly1305_h_l195_c19_09cd : 0 clocks latency
BIN_OP_GT_poly1305_h_l195_c19_09cd : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l195_c19_09cd_left,
BIN_OP_GT_poly1305_h_l195_c19_09cd_right,
BIN_OP_GT_poly1305_h_l195_c19_09cd_return_output);

-- MUX_poly1305_h_l195_c19_fb61 : 0 clocks latency
MUX_poly1305_h_l195_c19_fb61 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
MUX_poly1305_h_l195_c19_fb61_cond,
MUX_poly1305_h_l195_c19_fb61_iftrue,
MUX_poly1305_h_l195_c19_fb61_iffalse,
MUX_poly1305_h_l195_c19_fb61_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_8456 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_8456 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_8456_left,
BIN_OP_MINUS_poly1305_h_l198_c16_8456_right,
BIN_OP_MINUS_poly1305_h_l198_c16_8456_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_6902 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_6902 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_6902_left,
BIN_OP_MINUS_poly1305_h_l198_c16_6902_right,
BIN_OP_MINUS_poly1305_h_l198_c16_6902_return_output);

-- BIN_OP_GT_poly1305_h_l199_c19_bef0 : 0 clocks latency
BIN_OP_GT_poly1305_h_l199_c19_bef0 : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l199_c19_bef0_left,
BIN_OP_GT_poly1305_h_l199_c19_bef0_right,
BIN_OP_GT_poly1305_h_l199_c19_bef0_return_output);

-- BIN_OP_EQ_poly1305_h_l199_c42_6a5e : 0 clocks latency
BIN_OP_EQ_poly1305_h_l199_c42_6a5e : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l199_c42_6a5e_left,
BIN_OP_EQ_poly1305_h_l199_c42_6a5e_right,
BIN_OP_EQ_poly1305_h_l199_c42_6a5e_return_output);

-- BIN_OP_NEQ_poly1305_h_l199_c64_86dd : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l199_c64_86dd : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l199_c64_86dd_left,
BIN_OP_NEQ_poly1305_h_l199_c64_86dd_right,
BIN_OP_NEQ_poly1305_h_l199_c64_86dd_return_output);

-- BIN_OP_AND_poly1305_h_l199_c42_870f : 0 clocks latency
BIN_OP_AND_poly1305_h_l199_c42_870f : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l199_c42_870f_left,
BIN_OP_AND_poly1305_h_l199_c42_870f_right,
BIN_OP_AND_poly1305_h_l199_c42_870f_return_output);

-- BIN_OP_OR_poly1305_h_l199_c19_9c6f : 0 clocks latency
BIN_OP_OR_poly1305_h_l199_c19_9c6f : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l199_c19_9c6f_left,
BIN_OP_OR_poly1305_h_l199_c19_9c6f_right,
BIN_OP_OR_poly1305_h_l199_c19_9c6f_return_output);

-- BIN_OP_MINUS_poly1305_h_l202_c9_9c9f : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l202_c9_9c9f : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_left,
BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_right,
BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_return_output);

-- BIN_OP_AND_poly1305_h_l203_c9_6307 : 0 clocks latency
BIN_OP_AND_poly1305_h_l203_c9_6307 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l203_c9_6307_left,
BIN_OP_AND_poly1305_h_l203_c9_6307_right,
BIN_OP_AND_poly1305_h_l203_c9_6307_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 a,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l164_c26_cc3e_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c9_e810_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c22_f360_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_1119_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c36_8296_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_429a_return_output,
 a_MUX_poly1305_h_l165_c5_82ac_return_output,
 BIN_OP_AND_poly1305_h_l170_c9_88e6_return_output,
 CONST_SR_2_poly1305_h_l178_c26_1282_return_output,
 BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_return_output,
 uint320_add_poly1305_h_l181_c13_d2b6_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_b384_return_output,
 BIN_OP_EQ_poly1305_h_l185_c10_6a0f_return_output,
 BIN_OP_EQ_poly1305_h_l186_c9_faf6_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_ac71_return_output,
 BIN_OP_GTE_poly1305_h_l187_c9_66d6_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_6ba2_return_output,
 a_limbs_0_MUX_poly1305_h_l185_c5_cb02_return_output,
 a_limbs_1_MUX_poly1305_h_l185_c5_cb02_return_output,
 a_limbs_2_MUX_poly1305_h_l185_c5_cb02_return_output,
 BIN_OP_MINUS_poly1305_h_l194_c16_8828_return_output,
 BIN_OP_GT_poly1305_h_l195_c19_09cd_return_output,
 MUX_poly1305_h_l195_c19_fb61_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_8456_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_6902_return_output,
 BIN_OP_GT_poly1305_h_l199_c19_bef0_return_output,
 BIN_OP_EQ_poly1305_h_l199_c42_6a5e_return_output,
 BIN_OP_NEQ_poly1305_h_l199_c64_86dd_return_output,
 BIN_OP_AND_poly1305_h_l199_c42_870f_return_output,
 BIN_OP_OR_poly1305_h_l199_c19_9c6f_return_output,
 BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_return_output,
 BIN_OP_AND_poly1305_h_l203_c9_6307_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u320_t;
 variable VAR_a : u320_t;
 variable VAR_mask : unsigned(63 downto 0);
 variable VAR_high_bits : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_e810_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_e810_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_e810_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_1119_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_ada6_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f360_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f360_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f360_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_1119_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_1119_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_429a_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_edb4_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_8296_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_8296_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_8296_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_429a_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_429a_return_output : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_h_l165_c5_82ac_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_82ac_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_82ac_return_output : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_82ac_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_88e6_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_88e6_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_88e6_return_output : unsigned(63 downto 0);
 variable VAR_mul5 : u320_t;
 variable VAR_mul5_limbs_0_poly1305_h_l178_c9_66a5 : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_1282_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_left : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_1282_x : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_return_output : unsigned(66 downto 0);
 variable VAR_uint320_add_poly1305_h_l181_c13_d2b6_a : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_d2b6_b : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_05c1_return_output : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_37bb_return_output : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_d2b6_return_output : u320_t;
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_b384_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_b384_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_b384_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_6a0f_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_6a0f_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_6a0f_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_ac71_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_faf6_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_faf6_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_faf6_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_ac71_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_ac71_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_66d6_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_66d6_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_66d6_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_return_output : unsigned(0 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_cond : unsigned(0 downto 0);
 variable VAR_borrow : unsigned(63 downto 0);
 variable VAR_diff : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_return_output : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_fb61_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_09cd_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_09cd_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_09cd_return_output : unsigned(0 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_fb61_iftrue : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_fb61_iffalse : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_fb61_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_8456_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_8456_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_8456_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_return_output : unsigned(63 downto 0);
 variable VAR_borrow_poly1305_h_l199_c9_d6ab : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_bef0_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_bef0_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_bef0_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_9c6f_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_6a5e_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_6a5e_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_6a5e_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_870f_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_86dd_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_86dd_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_86dd_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_870f_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_870f_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_9c6f_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_9c6f_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_6307_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_6307_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_6307_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_6261_return_output : u320_t;
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l170_l164_DUPLICATE_a8e6_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l202_l185_DUPLICATE_3718_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l186_l199_l185_l198_DUPLICATE_b249_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l194_l185_l195_DUPLICATE_2864_return_output : unsigned(63 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_86dd_right := to_unsigned(0, 1);
     VAR_MUX_poly1305_h_l195_c19_fb61_iftrue := to_unsigned(1, 64);
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_e810_right := to_unsigned(0, 1);
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_faf6_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_AND_poly1305_h_l203_c9_6307_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l185_c10_b384_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l170_c9_88e6_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_6a0f_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f360_right := to_unsigned(0, 1);
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_right := to_unsigned(5, 3);
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_8456_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_right := unsigned'(X"fffffc0000000000");
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_66d6_right := unsigned'(X"fffffffffffffffb");
     VAR_MUX_poly1305_h_l195_c19_fb61_iffalse := to_unsigned(0, 64);
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_right := unsigned'(X"fffffffffffffffb");
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_8296_right := to_unsigned(0, 1);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_a := a;

     -- Submodule level 0
     VAR_a_MUX_poly1305_h_l165_c5_82ac_iffalse := VAR_a;
     -- CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d[poly1305_h_l165_c22_ada6] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_ada6_return_output := VAR_a.limbs(3);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d[poly1305_h_l165_c36_edb4] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_edb4_return_output := VAR_a.limbs(4);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l170_l164_DUPLICATE_a8e6 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l170_l164_DUPLICATE_a8e6_return_output := VAR_a.limbs(2);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l170_l164_DUPLICATE_a8e6_return_output;
     VAR_BIN_OP_AND_poly1305_h_l170_c9_88e6_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l170_l164_DUPLICATE_a8e6_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f360_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_ada6_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_8296_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_edb4_return_output;
     -- BIN_OP_AND[poly1305_h_l170_c9_88e6] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l170_c9_88e6_left <= VAR_BIN_OP_AND_poly1305_h_l170_c9_88e6_left;
     BIN_OP_AND_poly1305_h_l170_c9_88e6_right <= VAR_BIN_OP_AND_poly1305_h_l170_c9_88e6_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l170_c9_88e6_return_output := BIN_OP_AND_poly1305_h_l170_c9_88e6_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c36_8296] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c36_8296_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_8296_left;
     BIN_OP_NEQ_poly1305_h_l165_c36_8296_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_8296_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_8296_return_output := BIN_OP_NEQ_poly1305_h_l165_c36_8296_return_output;

     -- BIN_OP_AND[poly1305_h_l164_c26_cc3e] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l164_c26_cc3e_left <= VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_left;
     BIN_OP_AND_poly1305_h_l164_c26_cc3e_right <= VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_return_output := BIN_OP_AND_poly1305_h_l164_c26_cc3e_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c22_f360] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c22_f360_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f360_left;
     BIN_OP_NEQ_poly1305_h_l165_c22_f360_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f360_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f360_return_output := BIN_OP_NEQ_poly1305_h_l165_c22_f360_return_output;

     -- Submodule level 2
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_e810_left := VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_return_output;
     VAR_CONST_SR_2_poly1305_h_l178_c26_1282_x := VAR_BIN_OP_AND_poly1305_h_l164_c26_cc3e_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_1119_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f360_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_429a_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c36_8296_return_output;
     -- CONST_SR_2[poly1305_h_l178_c26_1282] LATENCY=0
     -- Inputs
     CONST_SR_2_poly1305_h_l178_c26_1282_x <= VAR_CONST_SR_2_poly1305_h_l178_c26_1282_x;
     -- Outputs
     VAR_CONST_SR_2_poly1305_h_l178_c26_1282_return_output := CONST_SR_2_poly1305_h_l178_c26_1282_return_output;

     -- CONST_REF_RD_u320_t_u320_t_57df[poly1305_h_l181_c25_05c1] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_05c1_return_output := CONST_REF_RD_u320_t_u320_t_57df(
     VAR_a,
     VAR_BIN_OP_AND_poly1305_h_l170_c9_88e6_return_output,
     to_unsigned(0, 64),
     to_unsigned(0, 64));

     -- BIN_OP_NEQ[poly1305_h_l165_c9_e810] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c9_e810_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_e810_left;
     BIN_OP_NEQ_poly1305_h_l165_c9_e810_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_e810_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_e810_return_output := BIN_OP_NEQ_poly1305_h_l165_c9_e810_return_output;

     -- Submodule level 3
     VAR_BIN_OP_OR_poly1305_h_l165_c9_1119_left := VAR_BIN_OP_NEQ_poly1305_h_l165_c9_e810_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_d2b6_a := VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_05c1_return_output;
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_left := VAR_CONST_SR_2_poly1305_h_l178_c26_1282_return_output;
     -- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_80e9] LATENCY=0
     -- Inputs
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_left <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_left;
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_right <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_right;
     -- Outputs
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_return_output := BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_return_output;

     -- BIN_OP_OR[poly1305_h_l165_c9_1119] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_1119_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_1119_left;
     BIN_OP_OR_poly1305_h_l165_c9_1119_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_1119_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_1119_return_output := BIN_OP_OR_poly1305_h_l165_c9_1119_return_output;

     -- Submodule level 4
     VAR_mul5_limbs_0_poly1305_h_l178_c9_66a5 := resize(VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_80e9_return_output, 64);
     VAR_BIN_OP_OR_poly1305_h_l165_c9_429a_left := VAR_BIN_OP_OR_poly1305_h_l165_c9_1119_return_output;
     -- CONST_REF_RD_u320_t_u320_t_853a[poly1305_h_l181_c28_37bb] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_37bb_return_output := CONST_REF_RD_u320_t_u320_t_853a(
     u320_t_NULL,
     VAR_mul5_limbs_0_poly1305_h_l178_c9_66a5);

     -- BIN_OP_OR[poly1305_h_l165_c9_429a] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_429a_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_429a_left;
     BIN_OP_OR_poly1305_h_l165_c9_429a_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_429a_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_429a_return_output := BIN_OP_OR_poly1305_h_l165_c9_429a_return_output;

     -- Submodule level 5
     VAR_a_MUX_poly1305_h_l165_c5_82ac_cond := VAR_BIN_OP_OR_poly1305_h_l165_c9_429a_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_d2b6_b := VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_37bb_return_output;
     -- uint320_add[poly1305_h_l181_c13_d2b6] LATENCY=0
     -- Inputs
     uint320_add_poly1305_h_l181_c13_d2b6_a <= VAR_uint320_add_poly1305_h_l181_c13_d2b6_a;
     uint320_add_poly1305_h_l181_c13_d2b6_b <= VAR_uint320_add_poly1305_h_l181_c13_d2b6_b;
     -- Outputs
     VAR_uint320_add_poly1305_h_l181_c13_d2b6_return_output := uint320_add_poly1305_h_l181_c13_d2b6_return_output;

     -- Submodule level 6
     VAR_a_MUX_poly1305_h_l165_c5_82ac_iftrue := VAR_uint320_add_poly1305_h_l181_c13_d2b6_return_output;
     -- a_MUX[poly1305_h_l165_c5_82ac] LATENCY=0
     -- Inputs
     a_MUX_poly1305_h_l165_c5_82ac_cond <= VAR_a_MUX_poly1305_h_l165_c5_82ac_cond;
     a_MUX_poly1305_h_l165_c5_82ac_iftrue <= VAR_a_MUX_poly1305_h_l165_c5_82ac_iftrue;
     a_MUX_poly1305_h_l165_c5_82ac_iffalse <= VAR_a_MUX_poly1305_h_l165_c5_82ac_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_h_l165_c5_82ac_return_output := a_MUX_poly1305_h_l165_c5_82ac_return_output;

     -- Submodule level 7
     -- CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l194_l185_l195_DUPLICATE_2864 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l194_l185_l195_DUPLICATE_2864_return_output := VAR_a_MUX_poly1305_h_l165_c5_82ac_return_output.limbs(0);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l186_l199_l185_l198_DUPLICATE_b249 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l186_l199_l185_l198_DUPLICATE_b249_return_output := VAR_a_MUX_poly1305_h_l165_c5_82ac_return_output.limbs(1);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l202_l185_DUPLICATE_3718 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l202_l185_DUPLICATE_3718_return_output := VAR_a_MUX_poly1305_h_l165_c5_82ac_return_output.limbs(2);

     -- Submodule level 8
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_66d6_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l194_l185_l195_DUPLICATE_2864_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_09cd_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l194_l185_l195_DUPLICATE_2864_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l194_l185_l195_DUPLICATE_2864_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l194_l185_l195_DUPLICATE_2864_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_faf6_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l186_l199_l185_l198_DUPLICATE_b249_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_6a5e_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l186_l199_l185_l198_DUPLICATE_b249_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_bef0_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l186_l199_l185_l198_DUPLICATE_b249_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_8456_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l186_l199_l185_l198_DUPLICATE_b249_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l186_l199_l185_l198_DUPLICATE_b249_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_b384_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l202_l185_DUPLICATE_3718_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l202_l185_DUPLICATE_3718_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l202_l185_DUPLICATE_3718_return_output;
     -- BIN_OP_GTE[poly1305_h_l187_c9_66d6] LATENCY=0
     -- Inputs
     BIN_OP_GTE_poly1305_h_l187_c9_66d6_left <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_66d6_left;
     BIN_OP_GTE_poly1305_h_l187_c9_66d6_right <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_66d6_right;
     -- Outputs
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_66d6_return_output := BIN_OP_GTE_poly1305_h_l187_c9_66d6_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_b384] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_b384_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_b384_left;
     BIN_OP_AND_poly1305_h_l185_c10_b384_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_b384_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_b384_return_output := BIN_OP_AND_poly1305_h_l185_c10_b384_return_output;

     -- BIN_OP_MINUS[poly1305_h_l194_c16_8828] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l194_c16_8828_left <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_left;
     BIN_OP_MINUS_poly1305_h_l194_c16_8828_right <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_return_output := BIN_OP_MINUS_poly1305_h_l194_c16_8828_return_output;

     -- BIN_OP_MINUS[poly1305_h_l198_c16_8456] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_8456_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_8456_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_8456_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_8456_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_8456_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_8456_return_output;

     -- BIN_OP_EQ[poly1305_h_l186_c9_faf6] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l186_c9_faf6_left <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_faf6_left;
     BIN_OP_EQ_poly1305_h_l186_c9_faf6_right <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_faf6_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_faf6_return_output := BIN_OP_EQ_poly1305_h_l186_c9_faf6_return_output;

     -- Submodule level 9
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_6a0f_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_b384_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_ac71_right := VAR_BIN_OP_EQ_poly1305_h_l186_c9_faf6_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_right := VAR_BIN_OP_GTE_poly1305_h_l187_c9_66d6_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_09cd_left := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_8828_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_8456_return_output;
     -- BIN_OP_GT[poly1305_h_l195_c19_09cd] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l195_c19_09cd_left <= VAR_BIN_OP_GT_poly1305_h_l195_c19_09cd_left;
     BIN_OP_GT_poly1305_h_l195_c19_09cd_right <= VAR_BIN_OP_GT_poly1305_h_l195_c19_09cd_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l195_c19_09cd_return_output := BIN_OP_GT_poly1305_h_l195_c19_09cd_return_output;

     -- BIN_OP_EQ[poly1305_h_l185_c10_6a0f] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l185_c10_6a0f_left <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_6a0f_left;
     BIN_OP_EQ_poly1305_h_l185_c10_6a0f_right <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_6a0f_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_6a0f_return_output := BIN_OP_EQ_poly1305_h_l185_c10_6a0f_return_output;

     -- Submodule level 10
     VAR_BIN_OP_AND_poly1305_h_l185_c10_ac71_left := VAR_BIN_OP_EQ_poly1305_h_l185_c10_6a0f_return_output;
     VAR_MUX_poly1305_h_l195_c19_fb61_cond := VAR_BIN_OP_GT_poly1305_h_l195_c19_09cd_return_output;
     -- BIN_OP_AND[poly1305_h_l185_c10_ac71] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_ac71_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_ac71_left;
     BIN_OP_AND_poly1305_h_l185_c10_ac71_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_ac71_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_ac71_return_output := BIN_OP_AND_poly1305_h_l185_c10_ac71_return_output;

     -- MUX[poly1305_h_l195_c19_fb61] LATENCY=0
     -- Inputs
     MUX_poly1305_h_l195_c19_fb61_cond <= VAR_MUX_poly1305_h_l195_c19_fb61_cond;
     MUX_poly1305_h_l195_c19_fb61_iftrue <= VAR_MUX_poly1305_h_l195_c19_fb61_iftrue;
     MUX_poly1305_h_l195_c19_fb61_iffalse <= VAR_MUX_poly1305_h_l195_c19_fb61_iffalse;
     -- Outputs
     VAR_MUX_poly1305_h_l195_c19_fb61_return_output := MUX_poly1305_h_l195_c19_fb61_return_output;

     -- Submodule level 11
     VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_ac71_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_right := VAR_MUX_poly1305_h_l195_c19_fb61_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_86dd_left := VAR_MUX_poly1305_h_l195_c19_fb61_return_output;
     -- BIN_OP_AND[poly1305_h_l185_c10_6ba2] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_6ba2_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_left;
     BIN_OP_AND_poly1305_h_l185_c10_6ba2_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_return_output := BIN_OP_AND_poly1305_h_l185_c10_6ba2_return_output;

     -- BIN_OP_NEQ[poly1305_h_l199_c64_86dd] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l199_c64_86dd_left <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_86dd_left;
     BIN_OP_NEQ_poly1305_h_l199_c64_86dd_right <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_86dd_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_86dd_return_output := BIN_OP_NEQ_poly1305_h_l199_c64_86dd_return_output;

     -- BIN_OP_MINUS[poly1305_h_l198_c16_6902] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_6902_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_6902_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_6902_return_output;

     -- Submodule level 12
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_6ba2_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_6a5e_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_bef0_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_6902_return_output;
     VAR_BIN_OP_AND_poly1305_h_l199_c42_870f_right := VAR_BIN_OP_NEQ_poly1305_h_l199_c64_86dd_return_output;
     -- BIN_OP_GT[poly1305_h_l199_c19_bef0] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l199_c19_bef0_left <= VAR_BIN_OP_GT_poly1305_h_l199_c19_bef0_left;
     BIN_OP_GT_poly1305_h_l199_c19_bef0_right <= VAR_BIN_OP_GT_poly1305_h_l199_c19_bef0_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l199_c19_bef0_return_output := BIN_OP_GT_poly1305_h_l199_c19_bef0_return_output;

     -- BIN_OP_EQ[poly1305_h_l199_c42_6a5e] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l199_c42_6a5e_left <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_6a5e_left;
     BIN_OP_EQ_poly1305_h_l199_c42_6a5e_right <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_6a5e_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_6a5e_return_output := BIN_OP_EQ_poly1305_h_l199_c42_6a5e_return_output;

     -- a_limbs_1_MUX[poly1305_h_l185_c5_cb02] LATENCY=0
     -- Inputs
     a_limbs_1_MUX_poly1305_h_l185_c5_cb02_cond <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_cond;
     a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iftrue <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iftrue;
     a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iffalse <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_iffalse;
     -- Outputs
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_return_output := a_limbs_1_MUX_poly1305_h_l185_c5_cb02_return_output;

     -- a_limbs_0_MUX[poly1305_h_l185_c5_cb02] LATENCY=0
     -- Inputs
     a_limbs_0_MUX_poly1305_h_l185_c5_cb02_cond <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_cond;
     a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iftrue <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iftrue;
     a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iffalse <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_iffalse;
     -- Outputs
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_return_output := a_limbs_0_MUX_poly1305_h_l185_c5_cb02_return_output;

     -- Submodule level 13
     VAR_BIN_OP_AND_poly1305_h_l199_c42_870f_left := VAR_BIN_OP_EQ_poly1305_h_l199_c42_6a5e_return_output;
     VAR_BIN_OP_OR_poly1305_h_l199_c19_9c6f_left := VAR_BIN_OP_GT_poly1305_h_l199_c19_bef0_return_output;
     -- BIN_OP_AND[poly1305_h_l199_c42_870f] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l199_c42_870f_left <= VAR_BIN_OP_AND_poly1305_h_l199_c42_870f_left;
     BIN_OP_AND_poly1305_h_l199_c42_870f_right <= VAR_BIN_OP_AND_poly1305_h_l199_c42_870f_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l199_c42_870f_return_output := BIN_OP_AND_poly1305_h_l199_c42_870f_return_output;

     -- Submodule level 14
     VAR_BIN_OP_OR_poly1305_h_l199_c19_9c6f_right := VAR_BIN_OP_AND_poly1305_h_l199_c42_870f_return_output;
     -- BIN_OP_OR[poly1305_h_l199_c19_9c6f] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l199_c19_9c6f_left <= VAR_BIN_OP_OR_poly1305_h_l199_c19_9c6f_left;
     BIN_OP_OR_poly1305_h_l199_c19_9c6f_right <= VAR_BIN_OP_OR_poly1305_h_l199_c19_9c6f_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l199_c19_9c6f_return_output := BIN_OP_OR_poly1305_h_l199_c19_9c6f_return_output;

     -- Submodule level 15
     VAR_borrow_poly1305_h_l199_c9_d6ab := resize(VAR_BIN_OP_OR_poly1305_h_l199_c19_9c6f_return_output, 64);
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_right := VAR_borrow_poly1305_h_l199_c9_d6ab;
     -- BIN_OP_MINUS[poly1305_h_l202_c9_9c9f] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_left <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_left;
     BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_right <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_return_output := BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_return_output;

     -- Submodule level 16
     VAR_BIN_OP_AND_poly1305_h_l203_c9_6307_left := VAR_BIN_OP_MINUS_poly1305_h_l202_c9_9c9f_return_output;
     -- BIN_OP_AND[poly1305_h_l203_c9_6307] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l203_c9_6307_left <= VAR_BIN_OP_AND_poly1305_h_l203_c9_6307_left;
     BIN_OP_AND_poly1305_h_l203_c9_6307_right <= VAR_BIN_OP_AND_poly1305_h_l203_c9_6307_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l203_c9_6307_return_output := BIN_OP_AND_poly1305_h_l203_c9_6307_return_output;

     -- Submodule level 17
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iftrue := VAR_BIN_OP_AND_poly1305_h_l203_c9_6307_return_output;
     -- a_limbs_2_MUX[poly1305_h_l185_c5_cb02] LATENCY=0
     -- Inputs
     a_limbs_2_MUX_poly1305_h_l185_c5_cb02_cond <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_cond;
     a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iftrue <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iftrue;
     a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iffalse <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_iffalse;
     -- Outputs
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_return_output := a_limbs_2_MUX_poly1305_h_l185_c5_cb02_return_output;

     -- Submodule level 18
     -- CONST_REF_RD_u320_t_u320_t_b8ef[poly1305_h_l205_c12_6261] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_6261_return_output := CONST_REF_RD_u320_t_u320_t_b8ef(
     VAR_a_MUX_poly1305_h_l165_c5_82ac_return_output,
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_cb02_return_output,
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_cb02_return_output,
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_cb02_return_output);

     -- Submodule level 19
     VAR_return_output := VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_6261_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
