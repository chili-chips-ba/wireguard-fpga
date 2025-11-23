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
-- BIN_OP_AND[poly1305_h_l164_c26_fa44]
signal BIN_OP_AND_poly1305_h_l164_c26_fa44_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_fa44_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_fa44_return_output : unsigned(63 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c9_5120]
signal BIN_OP_NEQ_poly1305_h_l165_c9_5120_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_5120_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_5120_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c22_f625]
signal BIN_OP_NEQ_poly1305_h_l165_c22_f625_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_f625_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_f625_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_ac45]
signal BIN_OP_OR_poly1305_h_l165_c9_ac45_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_ac45_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_ac45_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c36_15fd]
signal BIN_OP_NEQ_poly1305_h_l165_c36_15fd_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_15fd_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_15fd_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_b855]
signal BIN_OP_OR_poly1305_h_l165_c9_b855_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_b855_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_b855_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_h_l165_c5_9388]
signal a_MUX_poly1305_h_l165_c5_9388_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_h_l165_c5_9388_iftrue : u320_t;
signal a_MUX_poly1305_h_l165_c5_9388_iffalse : u320_t;
signal a_MUX_poly1305_h_l165_c5_9388_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l170_c9_1a21]
signal BIN_OP_AND_poly1305_h_l170_c9_1a21_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_1a21_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_1a21_return_output : unsigned(63 downto 0);

-- CONST_SR_2[poly1305_h_l178_c26_e430]
signal CONST_SR_2_poly1305_h_l178_c26_e430_x : unsigned(63 downto 0);
signal CONST_SR_2_poly1305_h_l178_c26_e430_return_output : unsigned(63 downto 0);

-- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_c807]
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_left : unsigned(63 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_right : unsigned(2 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_return_output : unsigned(66 downto 0);

-- uint320_add[poly1305_h_l181_c13_161c]
signal uint320_add_poly1305_h_l181_c13_161c_a : u320_t;
signal uint320_add_poly1305_h_l181_c13_161c_b : u320_t;
signal uint320_add_poly1305_h_l181_c13_161c_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l185_c10_a737]
signal BIN_OP_AND_poly1305_h_l185_c10_a737_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_a737_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_a737_return_output : unsigned(63 downto 0);

-- BIN_OP_EQ[poly1305_h_l185_c10_b3ac]
signal BIN_OP_EQ_poly1305_h_l185_c10_b3ac_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_b3ac_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_b3ac_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l186_c9_8e7a]
signal BIN_OP_EQ_poly1305_h_l186_c9_8e7a_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_8e7a_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_8e7a_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_6ea7]
signal BIN_OP_AND_poly1305_h_l185_c10_6ea7_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_6ea7_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_6ea7_return_output : unsigned(0 downto 0);

-- BIN_OP_GTE[poly1305_h_l187_c9_a877]
signal BIN_OP_GTE_poly1305_h_l187_c9_a877_left : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_a877_right : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_a877_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_fccb]
signal BIN_OP_AND_poly1305_h_l185_c10_fccb_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_fccb_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_fccb_return_output : unsigned(0 downto 0);

-- a_limbs_0_MUX[poly1305_h_l185_c5_4a5c]
signal a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_cond : unsigned(0 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iftrue : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iffalse : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_return_output : unsigned(63 downto 0);

-- a_limbs_1_MUX[poly1305_h_l185_c5_4a5c]
signal a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_cond : unsigned(0 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iftrue : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iffalse : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_return_output : unsigned(63 downto 0);

-- a_limbs_2_MUX[poly1305_h_l185_c5_4a5c]
signal a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_cond : unsigned(0 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iftrue : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iffalse : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l194_c16_2ab0]
signal BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l195_c19_8206]
signal BIN_OP_GT_poly1305_h_l195_c19_8206_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_8206_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_8206_return_output : unsigned(0 downto 0);

-- MUX[poly1305_h_l195_c19_0efc]
signal MUX_poly1305_h_l195_c19_0efc_cond : unsigned(0 downto 0);
signal MUX_poly1305_h_l195_c19_0efc_iftrue : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_0efc_iffalse : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_0efc_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_cd37]
signal BIN_OP_MINUS_poly1305_h_l198_c16_cd37_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_cd37_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_cd37_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_b426]
signal BIN_OP_MINUS_poly1305_h_l198_c16_b426_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_b426_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_b426_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l199_c19_133f]
signal BIN_OP_GT_poly1305_h_l199_c19_133f_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_133f_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_133f_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l199_c42_9b70]
signal BIN_OP_EQ_poly1305_h_l199_c42_9b70_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_9b70_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_9b70_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l199_c64_708f]
signal BIN_OP_NEQ_poly1305_h_l199_c64_708f_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_708f_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_708f_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l199_c42_0bfa]
signal BIN_OP_AND_poly1305_h_l199_c42_0bfa_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_0bfa_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_0bfa_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l199_c19_2fae]
signal BIN_OP_OR_poly1305_h_l199_c19_2fae_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_2fae_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_2fae_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[poly1305_h_l202_c9_06ae]
signal BIN_OP_MINUS_poly1305_h_l202_c9_06ae_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_06ae_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_06ae_return_output : unsigned(63 downto 0);

-- BIN_OP_AND[poly1305_h_l203_c9_e06b]
signal BIN_OP_AND_poly1305_h_l203_c9_e06b_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_e06b_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_e06b_return_output : unsigned(63 downto 0);

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
-- BIN_OP_AND_poly1305_h_l164_c26_fa44 : 0 clocks latency
BIN_OP_AND_poly1305_h_l164_c26_fa44 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l164_c26_fa44_left,
BIN_OP_AND_poly1305_h_l164_c26_fa44_right,
BIN_OP_AND_poly1305_h_l164_c26_fa44_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c9_5120 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c9_5120 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c9_5120_left,
BIN_OP_NEQ_poly1305_h_l165_c9_5120_right,
BIN_OP_NEQ_poly1305_h_l165_c9_5120_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c22_f625 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c22_f625 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c22_f625_left,
BIN_OP_NEQ_poly1305_h_l165_c22_f625_right,
BIN_OP_NEQ_poly1305_h_l165_c22_f625_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_ac45 : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_ac45 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_ac45_left,
BIN_OP_OR_poly1305_h_l165_c9_ac45_right,
BIN_OP_OR_poly1305_h_l165_c9_ac45_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c36_15fd : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c36_15fd : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c36_15fd_left,
BIN_OP_NEQ_poly1305_h_l165_c36_15fd_right,
BIN_OP_NEQ_poly1305_h_l165_c36_15fd_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_b855 : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_b855 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_b855_left,
BIN_OP_OR_poly1305_h_l165_c9_b855_right,
BIN_OP_OR_poly1305_h_l165_c9_b855_return_output);

-- a_MUX_poly1305_h_l165_c5_9388 : 0 clocks latency
a_MUX_poly1305_h_l165_c5_9388 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_h_l165_c5_9388_cond,
a_MUX_poly1305_h_l165_c5_9388_iftrue,
a_MUX_poly1305_h_l165_c5_9388_iffalse,
a_MUX_poly1305_h_l165_c5_9388_return_output);

-- BIN_OP_AND_poly1305_h_l170_c9_1a21 : 0 clocks latency
BIN_OP_AND_poly1305_h_l170_c9_1a21 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l170_c9_1a21_left,
BIN_OP_AND_poly1305_h_l170_c9_1a21_right,
BIN_OP_AND_poly1305_h_l170_c9_1a21_return_output);

-- CONST_SR_2_poly1305_h_l178_c26_e430 : 0 clocks latency
CONST_SR_2_poly1305_h_l178_c26_e430 : entity work.CONST_SR_2_uint64_t_0CLK_de264c78 port map (
CONST_SR_2_poly1305_h_l178_c26_e430_x,
CONST_SR_2_poly1305_h_l178_c26_e430_return_output);

-- BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807 : 0 clocks latency
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807 : entity work.BIN_OP_INFERRED_MULT_uint64_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_left,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_right,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_return_output);

-- uint320_add_poly1305_h_l181_c13_161c : 0 clocks latency
uint320_add_poly1305_h_l181_c13_161c : entity work.uint320_add_0CLK_10d8c973 port map (
uint320_add_poly1305_h_l181_c13_161c_a,
uint320_add_poly1305_h_l181_c13_161c_b,
uint320_add_poly1305_h_l181_c13_161c_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_a737 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_a737 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_a737_left,
BIN_OP_AND_poly1305_h_l185_c10_a737_right,
BIN_OP_AND_poly1305_h_l185_c10_a737_return_output);

-- BIN_OP_EQ_poly1305_h_l185_c10_b3ac : 0 clocks latency
BIN_OP_EQ_poly1305_h_l185_c10_b3ac : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l185_c10_b3ac_left,
BIN_OP_EQ_poly1305_h_l185_c10_b3ac_right,
BIN_OP_EQ_poly1305_h_l185_c10_b3ac_return_output);

-- BIN_OP_EQ_poly1305_h_l186_c9_8e7a : 0 clocks latency
BIN_OP_EQ_poly1305_h_l186_c9_8e7a : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l186_c9_8e7a_left,
BIN_OP_EQ_poly1305_h_l186_c9_8e7a_right,
BIN_OP_EQ_poly1305_h_l186_c9_8e7a_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_6ea7 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_6ea7 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_6ea7_left,
BIN_OP_AND_poly1305_h_l185_c10_6ea7_right,
BIN_OP_AND_poly1305_h_l185_c10_6ea7_return_output);

-- BIN_OP_GTE_poly1305_h_l187_c9_a877 : 0 clocks latency
BIN_OP_GTE_poly1305_h_l187_c9_a877 : entity work.BIN_OP_GTE_uint64_t_uint64_t_0CLK_6f2c5aad port map (
BIN_OP_GTE_poly1305_h_l187_c9_a877_left,
BIN_OP_GTE_poly1305_h_l187_c9_a877_right,
BIN_OP_GTE_poly1305_h_l187_c9_a877_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_fccb : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_fccb : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_fccb_left,
BIN_OP_AND_poly1305_h_l185_c10_fccb_right,
BIN_OP_AND_poly1305_h_l185_c10_fccb_return_output);

-- a_limbs_0_MUX_poly1305_h_l185_c5_4a5c : 0 clocks latency
a_limbs_0_MUX_poly1305_h_l185_c5_4a5c : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_cond,
a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iftrue,
a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iffalse,
a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_return_output);

-- a_limbs_1_MUX_poly1305_h_l185_c5_4a5c : 0 clocks latency
a_limbs_1_MUX_poly1305_h_l185_c5_4a5c : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_cond,
a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iftrue,
a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iffalse,
a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_return_output);

-- a_limbs_2_MUX_poly1305_h_l185_c5_4a5c : 0 clocks latency
a_limbs_2_MUX_poly1305_h_l185_c5_4a5c : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_cond,
a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iftrue,
a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iffalse,
a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_return_output);

-- BIN_OP_MINUS_poly1305_h_l194_c16_2ab0 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l194_c16_2ab0 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_left,
BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_right,
BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_return_output);

-- BIN_OP_GT_poly1305_h_l195_c19_8206 : 0 clocks latency
BIN_OP_GT_poly1305_h_l195_c19_8206 : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l195_c19_8206_left,
BIN_OP_GT_poly1305_h_l195_c19_8206_right,
BIN_OP_GT_poly1305_h_l195_c19_8206_return_output);

-- MUX_poly1305_h_l195_c19_0efc : 0 clocks latency
MUX_poly1305_h_l195_c19_0efc : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
MUX_poly1305_h_l195_c19_0efc_cond,
MUX_poly1305_h_l195_c19_0efc_iftrue,
MUX_poly1305_h_l195_c19_0efc_iffalse,
MUX_poly1305_h_l195_c19_0efc_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_cd37 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_cd37 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_cd37_left,
BIN_OP_MINUS_poly1305_h_l198_c16_cd37_right,
BIN_OP_MINUS_poly1305_h_l198_c16_cd37_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_b426 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_b426 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_b426_left,
BIN_OP_MINUS_poly1305_h_l198_c16_b426_right,
BIN_OP_MINUS_poly1305_h_l198_c16_b426_return_output);

-- BIN_OP_GT_poly1305_h_l199_c19_133f : 0 clocks latency
BIN_OP_GT_poly1305_h_l199_c19_133f : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l199_c19_133f_left,
BIN_OP_GT_poly1305_h_l199_c19_133f_right,
BIN_OP_GT_poly1305_h_l199_c19_133f_return_output);

-- BIN_OP_EQ_poly1305_h_l199_c42_9b70 : 0 clocks latency
BIN_OP_EQ_poly1305_h_l199_c42_9b70 : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l199_c42_9b70_left,
BIN_OP_EQ_poly1305_h_l199_c42_9b70_right,
BIN_OP_EQ_poly1305_h_l199_c42_9b70_return_output);

-- BIN_OP_NEQ_poly1305_h_l199_c64_708f : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l199_c64_708f : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l199_c64_708f_left,
BIN_OP_NEQ_poly1305_h_l199_c64_708f_right,
BIN_OP_NEQ_poly1305_h_l199_c64_708f_return_output);

-- BIN_OP_AND_poly1305_h_l199_c42_0bfa : 0 clocks latency
BIN_OP_AND_poly1305_h_l199_c42_0bfa : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l199_c42_0bfa_left,
BIN_OP_AND_poly1305_h_l199_c42_0bfa_right,
BIN_OP_AND_poly1305_h_l199_c42_0bfa_return_output);

-- BIN_OP_OR_poly1305_h_l199_c19_2fae : 0 clocks latency
BIN_OP_OR_poly1305_h_l199_c19_2fae : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l199_c19_2fae_left,
BIN_OP_OR_poly1305_h_l199_c19_2fae_right,
BIN_OP_OR_poly1305_h_l199_c19_2fae_return_output);

-- BIN_OP_MINUS_poly1305_h_l202_c9_06ae : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l202_c9_06ae : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l202_c9_06ae_left,
BIN_OP_MINUS_poly1305_h_l202_c9_06ae_right,
BIN_OP_MINUS_poly1305_h_l202_c9_06ae_return_output);

-- BIN_OP_AND_poly1305_h_l203_c9_e06b : 0 clocks latency
BIN_OP_AND_poly1305_h_l203_c9_e06b : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l203_c9_e06b_left,
BIN_OP_AND_poly1305_h_l203_c9_e06b_right,
BIN_OP_AND_poly1305_h_l203_c9_e06b_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 a,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l164_c26_fa44_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c9_5120_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c22_f625_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_ac45_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c36_15fd_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_b855_return_output,
 a_MUX_poly1305_h_l165_c5_9388_return_output,
 BIN_OP_AND_poly1305_h_l170_c9_1a21_return_output,
 CONST_SR_2_poly1305_h_l178_c26_e430_return_output,
 BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_return_output,
 uint320_add_poly1305_h_l181_c13_161c_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_a737_return_output,
 BIN_OP_EQ_poly1305_h_l185_c10_b3ac_return_output,
 BIN_OP_EQ_poly1305_h_l186_c9_8e7a_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_6ea7_return_output,
 BIN_OP_GTE_poly1305_h_l187_c9_a877_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_fccb_return_output,
 a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_return_output,
 a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_return_output,
 a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_return_output,
 BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_return_output,
 BIN_OP_GT_poly1305_h_l195_c19_8206_return_output,
 MUX_poly1305_h_l195_c19_0efc_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_cd37_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_b426_return_output,
 BIN_OP_GT_poly1305_h_l199_c19_133f_return_output,
 BIN_OP_EQ_poly1305_h_l199_c42_9b70_return_output,
 BIN_OP_NEQ_poly1305_h_l199_c64_708f_return_output,
 BIN_OP_AND_poly1305_h_l199_c42_0bfa_return_output,
 BIN_OP_OR_poly1305_h_l199_c19_2fae_return_output,
 BIN_OP_MINUS_poly1305_h_l202_c9_06ae_return_output,
 BIN_OP_AND_poly1305_h_l203_c9_e06b_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u320_t;
 variable VAR_a : u320_t;
 variable VAR_mask : unsigned(63 downto 0);
 variable VAR_high_bits : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_5120_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_5120_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_5120_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_ac45_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_1e76_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f625_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f625_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f625_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_ac45_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_ac45_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_b855_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_87e5_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_15fd_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_15fd_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_15fd_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_b855_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_b855_return_output : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_h_l165_c5_9388_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_9388_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_9388_return_output : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_9388_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_1a21_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_1a21_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_1a21_return_output : unsigned(63 downto 0);
 variable VAR_mul5 : u320_t;
 variable VAR_mul5_limbs_0_poly1305_h_l178_c9_5b10 : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_e430_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_left : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_e430_x : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_return_output : unsigned(66 downto 0);
 variable VAR_uint320_add_poly1305_h_l181_c13_161c_a : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_161c_b : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_1751_return_output : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_e158_return_output : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_161c_return_output : u320_t;
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_a737_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_a737_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_a737_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_b3ac_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_b3ac_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_b3ac_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_6ea7_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_8e7a_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_8e7a_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_8e7a_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_6ea7_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_6ea7_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_a877_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_a877_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_a877_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_return_output : unsigned(0 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_cond : unsigned(0 downto 0);
 variable VAR_borrow : unsigned(63 downto 0);
 variable VAR_diff : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_return_output : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_0efc_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_8206_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_8206_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_8206_return_output : unsigned(0 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_0efc_iftrue : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_0efc_iffalse : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_0efc_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_cd37_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_cd37_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_cd37_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_return_output : unsigned(63 downto 0);
 variable VAR_borrow_poly1305_h_l199_c9_7d8c : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_133f_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_133f_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_133f_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_2fae_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_9b70_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_9b70_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_9b70_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_0bfa_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_708f_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_708f_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_708f_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_0bfa_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_0bfa_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_2fae_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_2fae_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_06ae_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_06ae_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_06ae_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_e06b_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_e06b_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_e06b_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_7886_return_output : u320_t;
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_b398_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_b94c_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l198_l185_l186_DUPLICATE_bc74_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l187_l185_l194_DUPLICATE_8c88_return_output : unsigned(63 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_right := to_unsigned(5, 3);
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_5120_right := to_unsigned(0, 1);
     VAR_BIN_OP_AND_poly1305_h_l203_c9_e06b_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_b3ac_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l185_c10_a737_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l170_c9_1a21_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_708f_right := to_unsigned(0, 1);
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_15fd_right := to_unsigned(0, 1);
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_right := unsigned'(X"fffffffffffffffb");
     VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_right := unsigned'(X"fffffc0000000000");
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_8e7a_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f625_right := to_unsigned(0, 1);
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_cd37_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_a877_right := unsigned'(X"fffffffffffffffb");
     VAR_MUX_poly1305_h_l195_c19_0efc_iffalse := to_unsigned(0, 64);
     VAR_MUX_poly1305_h_l195_c19_0efc_iftrue := to_unsigned(1, 64);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_a := a;

     -- Submodule level 0
     VAR_a_MUX_poly1305_h_l165_c5_9388_iffalse := VAR_a;
     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_b398 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_b398_return_output := VAR_a.limbs(2);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d[poly1305_h_l165_c36_87e5] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_87e5_return_output := VAR_a.limbs(4);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d[poly1305_h_l165_c22_1e76] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_1e76_return_output := VAR_a.limbs(3);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_b398_return_output;
     VAR_BIN_OP_AND_poly1305_h_l170_c9_1a21_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_b398_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f625_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_1e76_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_15fd_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_87e5_return_output;
     -- BIN_OP_NEQ[poly1305_h_l165_c22_f625] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c22_f625_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f625_left;
     BIN_OP_NEQ_poly1305_h_l165_c22_f625_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f625_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f625_return_output := BIN_OP_NEQ_poly1305_h_l165_c22_f625_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c36_15fd] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c36_15fd_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_15fd_left;
     BIN_OP_NEQ_poly1305_h_l165_c36_15fd_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_15fd_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_15fd_return_output := BIN_OP_NEQ_poly1305_h_l165_c36_15fd_return_output;

     -- BIN_OP_AND[poly1305_h_l170_c9_1a21] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l170_c9_1a21_left <= VAR_BIN_OP_AND_poly1305_h_l170_c9_1a21_left;
     BIN_OP_AND_poly1305_h_l170_c9_1a21_right <= VAR_BIN_OP_AND_poly1305_h_l170_c9_1a21_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l170_c9_1a21_return_output := BIN_OP_AND_poly1305_h_l170_c9_1a21_return_output;

     -- BIN_OP_AND[poly1305_h_l164_c26_fa44] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l164_c26_fa44_left <= VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_left;
     BIN_OP_AND_poly1305_h_l164_c26_fa44_right <= VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_return_output := BIN_OP_AND_poly1305_h_l164_c26_fa44_return_output;

     -- Submodule level 2
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_5120_left := VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_return_output;
     VAR_CONST_SR_2_poly1305_h_l178_c26_e430_x := VAR_BIN_OP_AND_poly1305_h_l164_c26_fa44_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_ac45_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f625_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_b855_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c36_15fd_return_output;
     -- BIN_OP_NEQ[poly1305_h_l165_c9_5120] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c9_5120_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_5120_left;
     BIN_OP_NEQ_poly1305_h_l165_c9_5120_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_5120_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_5120_return_output := BIN_OP_NEQ_poly1305_h_l165_c9_5120_return_output;

     -- CONST_SR_2[poly1305_h_l178_c26_e430] LATENCY=0
     -- Inputs
     CONST_SR_2_poly1305_h_l178_c26_e430_x <= VAR_CONST_SR_2_poly1305_h_l178_c26_e430_x;
     -- Outputs
     VAR_CONST_SR_2_poly1305_h_l178_c26_e430_return_output := CONST_SR_2_poly1305_h_l178_c26_e430_return_output;

     -- CONST_REF_RD_u320_t_u320_t_57df[poly1305_h_l181_c25_1751] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_1751_return_output := CONST_REF_RD_u320_t_u320_t_57df(
     VAR_a,
     VAR_BIN_OP_AND_poly1305_h_l170_c9_1a21_return_output,
     to_unsigned(0, 64),
     to_unsigned(0, 64));

     -- Submodule level 3
     VAR_BIN_OP_OR_poly1305_h_l165_c9_ac45_left := VAR_BIN_OP_NEQ_poly1305_h_l165_c9_5120_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_161c_a := VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_1751_return_output;
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_left := VAR_CONST_SR_2_poly1305_h_l178_c26_e430_return_output;
     -- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_c807] LATENCY=0
     -- Inputs
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_left <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_left;
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_right <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_right;
     -- Outputs
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_return_output := BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_return_output;

     -- BIN_OP_OR[poly1305_h_l165_c9_ac45] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_ac45_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_ac45_left;
     BIN_OP_OR_poly1305_h_l165_c9_ac45_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_ac45_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_ac45_return_output := BIN_OP_OR_poly1305_h_l165_c9_ac45_return_output;

     -- Submodule level 4
     VAR_mul5_limbs_0_poly1305_h_l178_c9_5b10 := resize(VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c807_return_output, 64);
     VAR_BIN_OP_OR_poly1305_h_l165_c9_b855_left := VAR_BIN_OP_OR_poly1305_h_l165_c9_ac45_return_output;
     -- CONST_REF_RD_u320_t_u320_t_853a[poly1305_h_l181_c28_e158] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_e158_return_output := CONST_REF_RD_u320_t_u320_t_853a(
     u320_t_NULL,
     VAR_mul5_limbs_0_poly1305_h_l178_c9_5b10);

     -- BIN_OP_OR[poly1305_h_l165_c9_b855] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_b855_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_b855_left;
     BIN_OP_OR_poly1305_h_l165_c9_b855_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_b855_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_b855_return_output := BIN_OP_OR_poly1305_h_l165_c9_b855_return_output;

     -- Submodule level 5
     VAR_a_MUX_poly1305_h_l165_c5_9388_cond := VAR_BIN_OP_OR_poly1305_h_l165_c9_b855_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_161c_b := VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_e158_return_output;
     -- uint320_add[poly1305_h_l181_c13_161c] LATENCY=0
     -- Inputs
     uint320_add_poly1305_h_l181_c13_161c_a <= VAR_uint320_add_poly1305_h_l181_c13_161c_a;
     uint320_add_poly1305_h_l181_c13_161c_b <= VAR_uint320_add_poly1305_h_l181_c13_161c_b;
     -- Outputs
     VAR_uint320_add_poly1305_h_l181_c13_161c_return_output := uint320_add_poly1305_h_l181_c13_161c_return_output;

     -- Submodule level 6
     VAR_a_MUX_poly1305_h_l165_c5_9388_iftrue := VAR_uint320_add_poly1305_h_l181_c13_161c_return_output;
     -- a_MUX[poly1305_h_l165_c5_9388] LATENCY=0
     -- Inputs
     a_MUX_poly1305_h_l165_c5_9388_cond <= VAR_a_MUX_poly1305_h_l165_c5_9388_cond;
     a_MUX_poly1305_h_l165_c5_9388_iftrue <= VAR_a_MUX_poly1305_h_l165_c5_9388_iftrue;
     a_MUX_poly1305_h_l165_c5_9388_iffalse <= VAR_a_MUX_poly1305_h_l165_c5_9388_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_h_l165_c5_9388_return_output := a_MUX_poly1305_h_l165_c5_9388_return_output;

     -- Submodule level 7
     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_b94c LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_b94c_return_output := VAR_a_MUX_poly1305_h_l165_c5_9388_return_output.limbs(2);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l187_l185_l194_DUPLICATE_8c88 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l187_l185_l194_DUPLICATE_8c88_return_output := VAR_a_MUX_poly1305_h_l165_c5_9388_return_output.limbs(0);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l198_l185_l186_DUPLICATE_bc74 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l198_l185_l186_DUPLICATE_bc74_return_output := VAR_a_MUX_poly1305_h_l165_c5_9388_return_output.limbs(1);

     -- Submodule level 8
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_a877_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l187_l185_l194_DUPLICATE_8c88_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_8206_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l187_l185_l194_DUPLICATE_8c88_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l187_l185_l194_DUPLICATE_8c88_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l187_l185_l194_DUPLICATE_8c88_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_8e7a_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l198_l185_l186_DUPLICATE_bc74_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_9b70_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l198_l185_l186_DUPLICATE_bc74_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_133f_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l198_l185_l186_DUPLICATE_bc74_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_cd37_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l198_l185_l186_DUPLICATE_bc74_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l198_l185_l186_DUPLICATE_bc74_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_a737_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_b94c_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_06ae_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_b94c_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_b94c_return_output;
     -- BIN_OP_AND[poly1305_h_l185_c10_a737] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_a737_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_a737_left;
     BIN_OP_AND_poly1305_h_l185_c10_a737_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_a737_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_a737_return_output := BIN_OP_AND_poly1305_h_l185_c10_a737_return_output;

     -- BIN_OP_MINUS[poly1305_h_l194_c16_2ab0] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_left <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_left;
     BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_right <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_return_output := BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_return_output;

     -- BIN_OP_GTE[poly1305_h_l187_c9_a877] LATENCY=0
     -- Inputs
     BIN_OP_GTE_poly1305_h_l187_c9_a877_left <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_a877_left;
     BIN_OP_GTE_poly1305_h_l187_c9_a877_right <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_a877_right;
     -- Outputs
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_a877_return_output := BIN_OP_GTE_poly1305_h_l187_c9_a877_return_output;

     -- BIN_OP_MINUS[poly1305_h_l198_c16_cd37] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_cd37_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_cd37_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_cd37_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_cd37_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_cd37_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_cd37_return_output;

     -- BIN_OP_EQ[poly1305_h_l186_c9_8e7a] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l186_c9_8e7a_left <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_8e7a_left;
     BIN_OP_EQ_poly1305_h_l186_c9_8e7a_right <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_8e7a_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_8e7a_return_output := BIN_OP_EQ_poly1305_h_l186_c9_8e7a_return_output;

     -- Submodule level 9
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_b3ac_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_a737_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_6ea7_right := VAR_BIN_OP_EQ_poly1305_h_l186_c9_8e7a_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_right := VAR_BIN_OP_GTE_poly1305_h_l187_c9_a877_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_8206_left := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_2ab0_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_cd37_return_output;
     -- BIN_OP_EQ[poly1305_h_l185_c10_b3ac] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l185_c10_b3ac_left <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_b3ac_left;
     BIN_OP_EQ_poly1305_h_l185_c10_b3ac_right <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_b3ac_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_b3ac_return_output := BIN_OP_EQ_poly1305_h_l185_c10_b3ac_return_output;

     -- BIN_OP_GT[poly1305_h_l195_c19_8206] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l195_c19_8206_left <= VAR_BIN_OP_GT_poly1305_h_l195_c19_8206_left;
     BIN_OP_GT_poly1305_h_l195_c19_8206_right <= VAR_BIN_OP_GT_poly1305_h_l195_c19_8206_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l195_c19_8206_return_output := BIN_OP_GT_poly1305_h_l195_c19_8206_return_output;

     -- Submodule level 10
     VAR_BIN_OP_AND_poly1305_h_l185_c10_6ea7_left := VAR_BIN_OP_EQ_poly1305_h_l185_c10_b3ac_return_output;
     VAR_MUX_poly1305_h_l195_c19_0efc_cond := VAR_BIN_OP_GT_poly1305_h_l195_c19_8206_return_output;
     -- BIN_OP_AND[poly1305_h_l185_c10_6ea7] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_6ea7_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_6ea7_left;
     BIN_OP_AND_poly1305_h_l185_c10_6ea7_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_6ea7_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_6ea7_return_output := BIN_OP_AND_poly1305_h_l185_c10_6ea7_return_output;

     -- MUX[poly1305_h_l195_c19_0efc] LATENCY=0
     -- Inputs
     MUX_poly1305_h_l195_c19_0efc_cond <= VAR_MUX_poly1305_h_l195_c19_0efc_cond;
     MUX_poly1305_h_l195_c19_0efc_iftrue <= VAR_MUX_poly1305_h_l195_c19_0efc_iftrue;
     MUX_poly1305_h_l195_c19_0efc_iffalse <= VAR_MUX_poly1305_h_l195_c19_0efc_iffalse;
     -- Outputs
     VAR_MUX_poly1305_h_l195_c19_0efc_return_output := MUX_poly1305_h_l195_c19_0efc_return_output;

     -- Submodule level 11
     VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_6ea7_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_right := VAR_MUX_poly1305_h_l195_c19_0efc_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_708f_left := VAR_MUX_poly1305_h_l195_c19_0efc_return_output;
     -- BIN_OP_MINUS[poly1305_h_l198_c16_b426] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_b426_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_b426_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_b426_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_fccb] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_fccb_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_left;
     BIN_OP_AND_poly1305_h_l185_c10_fccb_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_return_output := BIN_OP_AND_poly1305_h_l185_c10_fccb_return_output;

     -- BIN_OP_NEQ[poly1305_h_l199_c64_708f] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l199_c64_708f_left <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_708f_left;
     BIN_OP_NEQ_poly1305_h_l199_c64_708f_right <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_708f_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_708f_return_output := BIN_OP_NEQ_poly1305_h_l199_c64_708f_return_output;

     -- Submodule level 12
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_fccb_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_9b70_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_133f_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b426_return_output;
     VAR_BIN_OP_AND_poly1305_h_l199_c42_0bfa_right := VAR_BIN_OP_NEQ_poly1305_h_l199_c64_708f_return_output;
     -- a_limbs_1_MUX[poly1305_h_l185_c5_4a5c] LATENCY=0
     -- Inputs
     a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_cond <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_cond;
     a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iftrue <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iftrue;
     a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iffalse <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_iffalse;
     -- Outputs
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_return_output := a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_return_output;

     -- BIN_OP_EQ[poly1305_h_l199_c42_9b70] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l199_c42_9b70_left <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_9b70_left;
     BIN_OP_EQ_poly1305_h_l199_c42_9b70_right <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_9b70_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_9b70_return_output := BIN_OP_EQ_poly1305_h_l199_c42_9b70_return_output;

     -- a_limbs_0_MUX[poly1305_h_l185_c5_4a5c] LATENCY=0
     -- Inputs
     a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_cond <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_cond;
     a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iftrue <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iftrue;
     a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iffalse <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_iffalse;
     -- Outputs
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_return_output := a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_return_output;

     -- BIN_OP_GT[poly1305_h_l199_c19_133f] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l199_c19_133f_left <= VAR_BIN_OP_GT_poly1305_h_l199_c19_133f_left;
     BIN_OP_GT_poly1305_h_l199_c19_133f_right <= VAR_BIN_OP_GT_poly1305_h_l199_c19_133f_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l199_c19_133f_return_output := BIN_OP_GT_poly1305_h_l199_c19_133f_return_output;

     -- Submodule level 13
     VAR_BIN_OP_AND_poly1305_h_l199_c42_0bfa_left := VAR_BIN_OP_EQ_poly1305_h_l199_c42_9b70_return_output;
     VAR_BIN_OP_OR_poly1305_h_l199_c19_2fae_left := VAR_BIN_OP_GT_poly1305_h_l199_c19_133f_return_output;
     -- BIN_OP_AND[poly1305_h_l199_c42_0bfa] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l199_c42_0bfa_left <= VAR_BIN_OP_AND_poly1305_h_l199_c42_0bfa_left;
     BIN_OP_AND_poly1305_h_l199_c42_0bfa_right <= VAR_BIN_OP_AND_poly1305_h_l199_c42_0bfa_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l199_c42_0bfa_return_output := BIN_OP_AND_poly1305_h_l199_c42_0bfa_return_output;

     -- Submodule level 14
     VAR_BIN_OP_OR_poly1305_h_l199_c19_2fae_right := VAR_BIN_OP_AND_poly1305_h_l199_c42_0bfa_return_output;
     -- BIN_OP_OR[poly1305_h_l199_c19_2fae] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l199_c19_2fae_left <= VAR_BIN_OP_OR_poly1305_h_l199_c19_2fae_left;
     BIN_OP_OR_poly1305_h_l199_c19_2fae_right <= VAR_BIN_OP_OR_poly1305_h_l199_c19_2fae_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l199_c19_2fae_return_output := BIN_OP_OR_poly1305_h_l199_c19_2fae_return_output;

     -- Submodule level 15
     VAR_borrow_poly1305_h_l199_c9_7d8c := resize(VAR_BIN_OP_OR_poly1305_h_l199_c19_2fae_return_output, 64);
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_06ae_right := VAR_borrow_poly1305_h_l199_c9_7d8c;
     -- BIN_OP_MINUS[poly1305_h_l202_c9_06ae] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l202_c9_06ae_left <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_06ae_left;
     BIN_OP_MINUS_poly1305_h_l202_c9_06ae_right <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_06ae_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_06ae_return_output := BIN_OP_MINUS_poly1305_h_l202_c9_06ae_return_output;

     -- Submodule level 16
     VAR_BIN_OP_AND_poly1305_h_l203_c9_e06b_left := VAR_BIN_OP_MINUS_poly1305_h_l202_c9_06ae_return_output;
     -- BIN_OP_AND[poly1305_h_l203_c9_e06b] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l203_c9_e06b_left <= VAR_BIN_OP_AND_poly1305_h_l203_c9_e06b_left;
     BIN_OP_AND_poly1305_h_l203_c9_e06b_right <= VAR_BIN_OP_AND_poly1305_h_l203_c9_e06b_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l203_c9_e06b_return_output := BIN_OP_AND_poly1305_h_l203_c9_e06b_return_output;

     -- Submodule level 17
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iftrue := VAR_BIN_OP_AND_poly1305_h_l203_c9_e06b_return_output;
     -- a_limbs_2_MUX[poly1305_h_l185_c5_4a5c] LATENCY=0
     -- Inputs
     a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_cond <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_cond;
     a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iftrue <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iftrue;
     a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iffalse <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_iffalse;
     -- Outputs
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_return_output := a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_return_output;

     -- Submodule level 18
     -- CONST_REF_RD_u320_t_u320_t_b8ef[poly1305_h_l205_c12_7886] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_7886_return_output := CONST_REF_RD_u320_t_u320_t_b8ef(
     VAR_a_MUX_poly1305_h_l165_c5_9388_return_output,
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a5c_return_output,
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a5c_return_output,
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a5c_return_output);

     -- Submodule level 19
     VAR_return_output := VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_7886_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
