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
-- BIN_OP_AND[poly1305_h_l164_c26_6843]
signal BIN_OP_AND_poly1305_h_l164_c26_6843_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_6843_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_6843_return_output : unsigned(63 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c9_21d7]
signal BIN_OP_NEQ_poly1305_h_l165_c9_21d7_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_21d7_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_21d7_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c22_f68d]
signal BIN_OP_NEQ_poly1305_h_l165_c22_f68d_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_f68d_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_f68d_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_f3ce]
signal BIN_OP_OR_poly1305_h_l165_c9_f3ce_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_f3ce_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_f3ce_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c36_ee97]
signal BIN_OP_NEQ_poly1305_h_l165_c36_ee97_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_ee97_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_ee97_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_7e2b]
signal BIN_OP_OR_poly1305_h_l165_c9_7e2b_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_7e2b_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_7e2b_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_h_l165_c5_0f81]
signal a_MUX_poly1305_h_l165_c5_0f81_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_h_l165_c5_0f81_iftrue : u320_t;
signal a_MUX_poly1305_h_l165_c5_0f81_iffalse : u320_t;
signal a_MUX_poly1305_h_l165_c5_0f81_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l170_c9_405d]
signal BIN_OP_AND_poly1305_h_l170_c9_405d_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_405d_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_405d_return_output : unsigned(63 downto 0);

-- CONST_SR_2[poly1305_h_l178_c26_45b7]
signal CONST_SR_2_poly1305_h_l178_c26_45b7_x : unsigned(63 downto 0);
signal CONST_SR_2_poly1305_h_l178_c26_45b7_return_output : unsigned(63 downto 0);

-- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_c837]
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_left : unsigned(63 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_right : unsigned(2 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_return_output : unsigned(66 downto 0);

-- uint320_add[poly1305_h_l181_c13_6e5c]
signal uint320_add_poly1305_h_l181_c13_6e5c_a : u320_t;
signal uint320_add_poly1305_h_l181_c13_6e5c_b : u320_t;
signal uint320_add_poly1305_h_l181_c13_6e5c_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l185_c10_cd6c]
signal BIN_OP_AND_poly1305_h_l185_c10_cd6c_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_cd6c_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_cd6c_return_output : unsigned(63 downto 0);

-- BIN_OP_EQ[poly1305_h_l185_c10_06e9]
signal BIN_OP_EQ_poly1305_h_l185_c10_06e9_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_06e9_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_06e9_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l186_c9_6d44]
signal BIN_OP_EQ_poly1305_h_l186_c9_6d44_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_6d44_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_6d44_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_32c8]
signal BIN_OP_AND_poly1305_h_l185_c10_32c8_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_32c8_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_32c8_return_output : unsigned(0 downto 0);

-- BIN_OP_GTE[poly1305_h_l187_c9_8ac9]
signal BIN_OP_GTE_poly1305_h_l187_c9_8ac9_left : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_8ac9_right : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_8ac9_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_fd13]
signal BIN_OP_AND_poly1305_h_l185_c10_fd13_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_fd13_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_fd13_return_output : unsigned(0 downto 0);

-- a_limbs_2_MUX[poly1305_h_l185_c5_2392]
signal a_limbs_2_MUX_poly1305_h_l185_c5_2392_cond : unsigned(0 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_2392_iftrue : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_2392_iffalse : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_2392_return_output : unsigned(63 downto 0);

-- a_limbs_0_MUX[poly1305_h_l185_c5_2392]
signal a_limbs_0_MUX_poly1305_h_l185_c5_2392_cond : unsigned(0 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_2392_iftrue : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_2392_iffalse : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_2392_return_output : unsigned(63 downto 0);

-- a_limbs_1_MUX[poly1305_h_l185_c5_2392]
signal a_limbs_1_MUX_poly1305_h_l185_c5_2392_cond : unsigned(0 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_2392_iftrue : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_2392_iffalse : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_2392_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l194_c16_f3ea]
signal BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l195_c19_a1d6]
signal BIN_OP_GT_poly1305_h_l195_c19_a1d6_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_a1d6_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_a1d6_return_output : unsigned(0 downto 0);

-- MUX[poly1305_h_l195_c19_0cb8]
signal MUX_poly1305_h_l195_c19_0cb8_cond : unsigned(0 downto 0);
signal MUX_poly1305_h_l195_c19_0cb8_iftrue : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_0cb8_iffalse : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_0cb8_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_0175]
signal BIN_OP_MINUS_poly1305_h_l198_c16_0175_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_0175_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_0175_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_d1ad]
signal BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l199_c19_7af5]
signal BIN_OP_GT_poly1305_h_l199_c19_7af5_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_7af5_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_7af5_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l199_c42_0272]
signal BIN_OP_EQ_poly1305_h_l199_c42_0272_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_0272_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_0272_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l199_c64_71f8]
signal BIN_OP_NEQ_poly1305_h_l199_c64_71f8_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_71f8_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_71f8_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l199_c42_1702]
signal BIN_OP_AND_poly1305_h_l199_c42_1702_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_1702_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_1702_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l199_c19_b1f7]
signal BIN_OP_OR_poly1305_h_l199_c19_b1f7_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_b1f7_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_b1f7_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[poly1305_h_l202_c9_a486]
signal BIN_OP_MINUS_poly1305_h_l202_c9_a486_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_a486_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_a486_return_output : unsigned(63 downto 0);

-- BIN_OP_AND[poly1305_h_l203_c9_1538]
signal BIN_OP_AND_poly1305_h_l203_c9_1538_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_1538_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_1538_return_output : unsigned(63 downto 0);

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

function CONST_REF_RD_u320_t_u320_t_6a3b( ref_toks_0 : u320_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned) return u320_t is
 
  variable base : u320_t; 
  variable return_output : u320_t;
begin
      base := ref_toks_0;
      base.limbs(2) := ref_toks_1;
      base.limbs(0) := ref_toks_2;
      base.limbs(1) := ref_toks_3;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_AND_poly1305_h_l164_c26_6843 : 0 clocks latency
BIN_OP_AND_poly1305_h_l164_c26_6843 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l164_c26_6843_left,
BIN_OP_AND_poly1305_h_l164_c26_6843_right,
BIN_OP_AND_poly1305_h_l164_c26_6843_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c9_21d7 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c9_21d7 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c9_21d7_left,
BIN_OP_NEQ_poly1305_h_l165_c9_21d7_right,
BIN_OP_NEQ_poly1305_h_l165_c9_21d7_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c22_f68d : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c22_f68d : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c22_f68d_left,
BIN_OP_NEQ_poly1305_h_l165_c22_f68d_right,
BIN_OP_NEQ_poly1305_h_l165_c22_f68d_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_f3ce : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_f3ce : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_f3ce_left,
BIN_OP_OR_poly1305_h_l165_c9_f3ce_right,
BIN_OP_OR_poly1305_h_l165_c9_f3ce_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c36_ee97 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c36_ee97 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c36_ee97_left,
BIN_OP_NEQ_poly1305_h_l165_c36_ee97_right,
BIN_OP_NEQ_poly1305_h_l165_c36_ee97_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_7e2b : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_7e2b : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_7e2b_left,
BIN_OP_OR_poly1305_h_l165_c9_7e2b_right,
BIN_OP_OR_poly1305_h_l165_c9_7e2b_return_output);

-- a_MUX_poly1305_h_l165_c5_0f81 : 0 clocks latency
a_MUX_poly1305_h_l165_c5_0f81 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_h_l165_c5_0f81_cond,
a_MUX_poly1305_h_l165_c5_0f81_iftrue,
a_MUX_poly1305_h_l165_c5_0f81_iffalse,
a_MUX_poly1305_h_l165_c5_0f81_return_output);

-- BIN_OP_AND_poly1305_h_l170_c9_405d : 0 clocks latency
BIN_OP_AND_poly1305_h_l170_c9_405d : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l170_c9_405d_left,
BIN_OP_AND_poly1305_h_l170_c9_405d_right,
BIN_OP_AND_poly1305_h_l170_c9_405d_return_output);

-- CONST_SR_2_poly1305_h_l178_c26_45b7 : 0 clocks latency
CONST_SR_2_poly1305_h_l178_c26_45b7 : entity work.CONST_SR_2_uint64_t_0CLK_de264c78 port map (
CONST_SR_2_poly1305_h_l178_c26_45b7_x,
CONST_SR_2_poly1305_h_l178_c26_45b7_return_output);

-- BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837 : 0 clocks latency
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837 : entity work.BIN_OP_INFERRED_MULT_uint64_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_left,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_right,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_return_output);

-- uint320_add_poly1305_h_l181_c13_6e5c : 0 clocks latency
uint320_add_poly1305_h_l181_c13_6e5c : entity work.uint320_add_0CLK_10d8c973 port map (
uint320_add_poly1305_h_l181_c13_6e5c_a,
uint320_add_poly1305_h_l181_c13_6e5c_b,
uint320_add_poly1305_h_l181_c13_6e5c_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_cd6c : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_cd6c : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_cd6c_left,
BIN_OP_AND_poly1305_h_l185_c10_cd6c_right,
BIN_OP_AND_poly1305_h_l185_c10_cd6c_return_output);

-- BIN_OP_EQ_poly1305_h_l185_c10_06e9 : 0 clocks latency
BIN_OP_EQ_poly1305_h_l185_c10_06e9 : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l185_c10_06e9_left,
BIN_OP_EQ_poly1305_h_l185_c10_06e9_right,
BIN_OP_EQ_poly1305_h_l185_c10_06e9_return_output);

-- BIN_OP_EQ_poly1305_h_l186_c9_6d44 : 0 clocks latency
BIN_OP_EQ_poly1305_h_l186_c9_6d44 : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l186_c9_6d44_left,
BIN_OP_EQ_poly1305_h_l186_c9_6d44_right,
BIN_OP_EQ_poly1305_h_l186_c9_6d44_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_32c8 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_32c8 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_32c8_left,
BIN_OP_AND_poly1305_h_l185_c10_32c8_right,
BIN_OP_AND_poly1305_h_l185_c10_32c8_return_output);

-- BIN_OP_GTE_poly1305_h_l187_c9_8ac9 : 0 clocks latency
BIN_OP_GTE_poly1305_h_l187_c9_8ac9 : entity work.BIN_OP_GTE_uint64_t_uint64_t_0CLK_6f2c5aad port map (
BIN_OP_GTE_poly1305_h_l187_c9_8ac9_left,
BIN_OP_GTE_poly1305_h_l187_c9_8ac9_right,
BIN_OP_GTE_poly1305_h_l187_c9_8ac9_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_fd13 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_fd13 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_fd13_left,
BIN_OP_AND_poly1305_h_l185_c10_fd13_right,
BIN_OP_AND_poly1305_h_l185_c10_fd13_return_output);

-- a_limbs_2_MUX_poly1305_h_l185_c5_2392 : 0 clocks latency
a_limbs_2_MUX_poly1305_h_l185_c5_2392 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_2_MUX_poly1305_h_l185_c5_2392_cond,
a_limbs_2_MUX_poly1305_h_l185_c5_2392_iftrue,
a_limbs_2_MUX_poly1305_h_l185_c5_2392_iffalse,
a_limbs_2_MUX_poly1305_h_l185_c5_2392_return_output);

-- a_limbs_0_MUX_poly1305_h_l185_c5_2392 : 0 clocks latency
a_limbs_0_MUX_poly1305_h_l185_c5_2392 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_0_MUX_poly1305_h_l185_c5_2392_cond,
a_limbs_0_MUX_poly1305_h_l185_c5_2392_iftrue,
a_limbs_0_MUX_poly1305_h_l185_c5_2392_iffalse,
a_limbs_0_MUX_poly1305_h_l185_c5_2392_return_output);

-- a_limbs_1_MUX_poly1305_h_l185_c5_2392 : 0 clocks latency
a_limbs_1_MUX_poly1305_h_l185_c5_2392 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_1_MUX_poly1305_h_l185_c5_2392_cond,
a_limbs_1_MUX_poly1305_h_l185_c5_2392_iftrue,
a_limbs_1_MUX_poly1305_h_l185_c5_2392_iffalse,
a_limbs_1_MUX_poly1305_h_l185_c5_2392_return_output);

-- BIN_OP_MINUS_poly1305_h_l194_c16_f3ea : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l194_c16_f3ea : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_left,
BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_right,
BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_return_output);

-- BIN_OP_GT_poly1305_h_l195_c19_a1d6 : 0 clocks latency
BIN_OP_GT_poly1305_h_l195_c19_a1d6 : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l195_c19_a1d6_left,
BIN_OP_GT_poly1305_h_l195_c19_a1d6_right,
BIN_OP_GT_poly1305_h_l195_c19_a1d6_return_output);

-- MUX_poly1305_h_l195_c19_0cb8 : 0 clocks latency
MUX_poly1305_h_l195_c19_0cb8 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
MUX_poly1305_h_l195_c19_0cb8_cond,
MUX_poly1305_h_l195_c19_0cb8_iftrue,
MUX_poly1305_h_l195_c19_0cb8_iffalse,
MUX_poly1305_h_l195_c19_0cb8_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_0175 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_0175 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_0175_left,
BIN_OP_MINUS_poly1305_h_l198_c16_0175_right,
BIN_OP_MINUS_poly1305_h_l198_c16_0175_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_d1ad : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_d1ad : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_left,
BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_right,
BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_return_output);

-- BIN_OP_GT_poly1305_h_l199_c19_7af5 : 0 clocks latency
BIN_OP_GT_poly1305_h_l199_c19_7af5 : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l199_c19_7af5_left,
BIN_OP_GT_poly1305_h_l199_c19_7af5_right,
BIN_OP_GT_poly1305_h_l199_c19_7af5_return_output);

-- BIN_OP_EQ_poly1305_h_l199_c42_0272 : 0 clocks latency
BIN_OP_EQ_poly1305_h_l199_c42_0272 : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l199_c42_0272_left,
BIN_OP_EQ_poly1305_h_l199_c42_0272_right,
BIN_OP_EQ_poly1305_h_l199_c42_0272_return_output);

-- BIN_OP_NEQ_poly1305_h_l199_c64_71f8 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l199_c64_71f8 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l199_c64_71f8_left,
BIN_OP_NEQ_poly1305_h_l199_c64_71f8_right,
BIN_OP_NEQ_poly1305_h_l199_c64_71f8_return_output);

-- BIN_OP_AND_poly1305_h_l199_c42_1702 : 0 clocks latency
BIN_OP_AND_poly1305_h_l199_c42_1702 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l199_c42_1702_left,
BIN_OP_AND_poly1305_h_l199_c42_1702_right,
BIN_OP_AND_poly1305_h_l199_c42_1702_return_output);

-- BIN_OP_OR_poly1305_h_l199_c19_b1f7 : 0 clocks latency
BIN_OP_OR_poly1305_h_l199_c19_b1f7 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l199_c19_b1f7_left,
BIN_OP_OR_poly1305_h_l199_c19_b1f7_right,
BIN_OP_OR_poly1305_h_l199_c19_b1f7_return_output);

-- BIN_OP_MINUS_poly1305_h_l202_c9_a486 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l202_c9_a486 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l202_c9_a486_left,
BIN_OP_MINUS_poly1305_h_l202_c9_a486_right,
BIN_OP_MINUS_poly1305_h_l202_c9_a486_return_output);

-- BIN_OP_AND_poly1305_h_l203_c9_1538 : 0 clocks latency
BIN_OP_AND_poly1305_h_l203_c9_1538 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l203_c9_1538_left,
BIN_OP_AND_poly1305_h_l203_c9_1538_right,
BIN_OP_AND_poly1305_h_l203_c9_1538_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 a,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l164_c26_6843_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c9_21d7_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c22_f68d_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_f3ce_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c36_ee97_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_7e2b_return_output,
 a_MUX_poly1305_h_l165_c5_0f81_return_output,
 BIN_OP_AND_poly1305_h_l170_c9_405d_return_output,
 CONST_SR_2_poly1305_h_l178_c26_45b7_return_output,
 BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_return_output,
 uint320_add_poly1305_h_l181_c13_6e5c_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_cd6c_return_output,
 BIN_OP_EQ_poly1305_h_l185_c10_06e9_return_output,
 BIN_OP_EQ_poly1305_h_l186_c9_6d44_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_32c8_return_output,
 BIN_OP_GTE_poly1305_h_l187_c9_8ac9_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_fd13_return_output,
 a_limbs_2_MUX_poly1305_h_l185_c5_2392_return_output,
 a_limbs_0_MUX_poly1305_h_l185_c5_2392_return_output,
 a_limbs_1_MUX_poly1305_h_l185_c5_2392_return_output,
 BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_return_output,
 BIN_OP_GT_poly1305_h_l195_c19_a1d6_return_output,
 MUX_poly1305_h_l195_c19_0cb8_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_0175_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_return_output,
 BIN_OP_GT_poly1305_h_l199_c19_7af5_return_output,
 BIN_OP_EQ_poly1305_h_l199_c42_0272_return_output,
 BIN_OP_NEQ_poly1305_h_l199_c64_71f8_return_output,
 BIN_OP_AND_poly1305_h_l199_c42_1702_return_output,
 BIN_OP_OR_poly1305_h_l199_c19_b1f7_return_output,
 BIN_OP_MINUS_poly1305_h_l202_c9_a486_return_output,
 BIN_OP_AND_poly1305_h_l203_c9_1538_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u320_t;
 variable VAR_a : u320_t;
 variable VAR_mask : unsigned(63 downto 0);
 variable VAR_high_bits : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_21d7_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_21d7_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_21d7_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_f3ce_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_13c8_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f68d_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f68d_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f68d_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_f3ce_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_f3ce_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_7e2b_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_1060_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ee97_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ee97_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ee97_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_7e2b_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_7e2b_return_output : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_h_l165_c5_0f81_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_0f81_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_0f81_return_output : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_0f81_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_405d_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_405d_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_405d_return_output : unsigned(63 downto 0);
 variable VAR_mul5 : u320_t;
 variable VAR_mul5_limbs_0_poly1305_h_l178_c9_1fea : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_45b7_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_left : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_45b7_x : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_return_output : unsigned(66 downto 0);
 variable VAR_uint320_add_poly1305_h_l181_c13_6e5c_a : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_6e5c_b : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_0b79_return_output : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_3bdf_return_output : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_6e5c_return_output : u320_t;
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_cd6c_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_cd6c_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_cd6c_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_06e9_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_06e9_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_06e9_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_32c8_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_6d44_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_6d44_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_6d44_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_32c8_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_32c8_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_8ac9_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_8ac9_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_8ac9_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_return_output : unsigned(0 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_cond : unsigned(0 downto 0);
 variable VAR_borrow : unsigned(63 downto 0);
 variable VAR_diff : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_return_output : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_0cb8_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_a1d6_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_a1d6_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_a1d6_return_output : unsigned(0 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_0cb8_iftrue : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_0cb8_iffalse : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_0cb8_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0175_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0175_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0175_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_return_output : unsigned(63 downto 0);
 variable VAR_borrow_poly1305_h_l199_c9_8b4b : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_7af5_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_7af5_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_7af5_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_b1f7_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_0272_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_0272_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_0272_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_1702_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_71f8_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_71f8_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_71f8_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_1702_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_1702_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_b1f7_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_b1f7_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_a486_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_a486_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_a486_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_1538_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_1538_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_1538_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_u320_t_u320_t_6a3b_poly1305_h_l205_c12_439e_return_output : u320_t;
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_a1c8_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_88d7_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_c56f_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_f4e5_return_output : unsigned(63 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_MUX_poly1305_h_l195_c19_0cb8_iffalse := to_unsigned(0, 64);
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_right := to_unsigned(5, 3);
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_6d44_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ee97_right := to_unsigned(0, 1);
     VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_right := unsigned'(X"fffffc0000000000");
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_21d7_right := to_unsigned(0, 1);
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_8ac9_right := unsigned'(X"fffffffffffffffb");
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f68d_right := to_unsigned(0, 1);
     VAR_BIN_OP_AND_poly1305_h_l185_c10_cd6c_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l203_c9_1538_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l170_c9_405d_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_06e9_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_right := unsigned'(X"fffffffffffffffb");
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_71f8_right := to_unsigned(0, 1);
     VAR_MUX_poly1305_h_l195_c19_0cb8_iftrue := to_unsigned(1, 64);
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0175_right := unsigned'(X"ffffffffffffffff");

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_a := a;

     -- Submodule level 0
     VAR_a_MUX_poly1305_h_l165_c5_0f81_iffalse := VAR_a;
     -- CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d[poly1305_h_l165_c36_1060] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_1060_return_output := VAR_a.limbs(4);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_a1c8 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_a1c8_return_output := VAR_a.limbs(2);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d[poly1305_h_l165_c22_13c8] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_13c8_return_output := VAR_a.limbs(3);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_a1c8_return_output;
     VAR_BIN_OP_AND_poly1305_h_l170_c9_405d_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_a1c8_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f68d_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_13c8_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ee97_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_1060_return_output;
     -- BIN_OP_AND[poly1305_h_l164_c26_6843] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l164_c26_6843_left <= VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_left;
     BIN_OP_AND_poly1305_h_l164_c26_6843_right <= VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_return_output := BIN_OP_AND_poly1305_h_l164_c26_6843_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c36_ee97] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c36_ee97_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ee97_left;
     BIN_OP_NEQ_poly1305_h_l165_c36_ee97_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ee97_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ee97_return_output := BIN_OP_NEQ_poly1305_h_l165_c36_ee97_return_output;

     -- BIN_OP_AND[poly1305_h_l170_c9_405d] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l170_c9_405d_left <= VAR_BIN_OP_AND_poly1305_h_l170_c9_405d_left;
     BIN_OP_AND_poly1305_h_l170_c9_405d_right <= VAR_BIN_OP_AND_poly1305_h_l170_c9_405d_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l170_c9_405d_return_output := BIN_OP_AND_poly1305_h_l170_c9_405d_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c22_f68d] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c22_f68d_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f68d_left;
     BIN_OP_NEQ_poly1305_h_l165_c22_f68d_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f68d_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f68d_return_output := BIN_OP_NEQ_poly1305_h_l165_c22_f68d_return_output;

     -- Submodule level 2
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_21d7_left := VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_return_output;
     VAR_CONST_SR_2_poly1305_h_l178_c26_45b7_x := VAR_BIN_OP_AND_poly1305_h_l164_c26_6843_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_f3ce_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c22_f68d_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_7e2b_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ee97_return_output;
     -- CONST_REF_RD_u320_t_u320_t_57df[poly1305_h_l181_c25_0b79] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_0b79_return_output := CONST_REF_RD_u320_t_u320_t_57df(
     VAR_a,
     VAR_BIN_OP_AND_poly1305_h_l170_c9_405d_return_output,
     to_unsigned(0, 64),
     to_unsigned(0, 64));

     -- BIN_OP_NEQ[poly1305_h_l165_c9_21d7] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c9_21d7_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_21d7_left;
     BIN_OP_NEQ_poly1305_h_l165_c9_21d7_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_21d7_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_21d7_return_output := BIN_OP_NEQ_poly1305_h_l165_c9_21d7_return_output;

     -- CONST_SR_2[poly1305_h_l178_c26_45b7] LATENCY=0
     -- Inputs
     CONST_SR_2_poly1305_h_l178_c26_45b7_x <= VAR_CONST_SR_2_poly1305_h_l178_c26_45b7_x;
     -- Outputs
     VAR_CONST_SR_2_poly1305_h_l178_c26_45b7_return_output := CONST_SR_2_poly1305_h_l178_c26_45b7_return_output;

     -- Submodule level 3
     VAR_BIN_OP_OR_poly1305_h_l165_c9_f3ce_left := VAR_BIN_OP_NEQ_poly1305_h_l165_c9_21d7_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_6e5c_a := VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_0b79_return_output;
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_left := VAR_CONST_SR_2_poly1305_h_l178_c26_45b7_return_output;
     -- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_c837] LATENCY=0
     -- Inputs
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_left <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_left;
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_right <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_right;
     -- Outputs
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_return_output := BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_return_output;

     -- BIN_OP_OR[poly1305_h_l165_c9_f3ce] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_f3ce_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_f3ce_left;
     BIN_OP_OR_poly1305_h_l165_c9_f3ce_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_f3ce_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_f3ce_return_output := BIN_OP_OR_poly1305_h_l165_c9_f3ce_return_output;

     -- Submodule level 4
     VAR_mul5_limbs_0_poly1305_h_l178_c9_1fea := resize(VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_c837_return_output, 64);
     VAR_BIN_OP_OR_poly1305_h_l165_c9_7e2b_left := VAR_BIN_OP_OR_poly1305_h_l165_c9_f3ce_return_output;
     -- CONST_REF_RD_u320_t_u320_t_853a[poly1305_h_l181_c28_3bdf] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_3bdf_return_output := CONST_REF_RD_u320_t_u320_t_853a(
     u320_t_NULL,
     VAR_mul5_limbs_0_poly1305_h_l178_c9_1fea);

     -- BIN_OP_OR[poly1305_h_l165_c9_7e2b] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_7e2b_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_7e2b_left;
     BIN_OP_OR_poly1305_h_l165_c9_7e2b_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_7e2b_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_7e2b_return_output := BIN_OP_OR_poly1305_h_l165_c9_7e2b_return_output;

     -- Submodule level 5
     VAR_a_MUX_poly1305_h_l165_c5_0f81_cond := VAR_BIN_OP_OR_poly1305_h_l165_c9_7e2b_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_6e5c_b := VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_3bdf_return_output;
     -- uint320_add[poly1305_h_l181_c13_6e5c] LATENCY=0
     -- Inputs
     uint320_add_poly1305_h_l181_c13_6e5c_a <= VAR_uint320_add_poly1305_h_l181_c13_6e5c_a;
     uint320_add_poly1305_h_l181_c13_6e5c_b <= VAR_uint320_add_poly1305_h_l181_c13_6e5c_b;
     -- Outputs
     VAR_uint320_add_poly1305_h_l181_c13_6e5c_return_output := uint320_add_poly1305_h_l181_c13_6e5c_return_output;

     -- Submodule level 6
     VAR_a_MUX_poly1305_h_l165_c5_0f81_iftrue := VAR_uint320_add_poly1305_h_l181_c13_6e5c_return_output;
     -- a_MUX[poly1305_h_l165_c5_0f81] LATENCY=0
     -- Inputs
     a_MUX_poly1305_h_l165_c5_0f81_cond <= VAR_a_MUX_poly1305_h_l165_c5_0f81_cond;
     a_MUX_poly1305_h_l165_c5_0f81_iftrue <= VAR_a_MUX_poly1305_h_l165_c5_0f81_iftrue;
     a_MUX_poly1305_h_l165_c5_0f81_iffalse <= VAR_a_MUX_poly1305_h_l165_c5_0f81_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_h_l165_c5_0f81_return_output := a_MUX_poly1305_h_l165_c5_0f81_return_output;

     -- Submodule level 7
     -- CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_f4e5 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_f4e5_return_output := VAR_a_MUX_poly1305_h_l165_c5_0f81_return_output.limbs(0);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_88d7 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_88d7_return_output := VAR_a_MUX_poly1305_h_l165_c5_0f81_return_output.limbs(2);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_c56f LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_c56f_return_output := VAR_a_MUX_poly1305_h_l165_c5_0f81_return_output.limbs(1);

     -- Submodule level 8
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_8ac9_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_f4e5_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_a1d6_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_f4e5_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_f4e5_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_f4e5_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_6d44_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_c56f_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_0272_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_c56f_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_7af5_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_c56f_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0175_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_c56f_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_c56f_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_cd6c_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_88d7_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_a486_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_88d7_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_88d7_return_output;
     -- BIN_OP_GTE[poly1305_h_l187_c9_8ac9] LATENCY=0
     -- Inputs
     BIN_OP_GTE_poly1305_h_l187_c9_8ac9_left <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_8ac9_left;
     BIN_OP_GTE_poly1305_h_l187_c9_8ac9_right <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_8ac9_right;
     -- Outputs
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_8ac9_return_output := BIN_OP_GTE_poly1305_h_l187_c9_8ac9_return_output;

     -- BIN_OP_MINUS[poly1305_h_l198_c16_0175] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_0175_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0175_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_0175_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0175_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0175_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_0175_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_cd6c] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_cd6c_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_cd6c_left;
     BIN_OP_AND_poly1305_h_l185_c10_cd6c_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_cd6c_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_cd6c_return_output := BIN_OP_AND_poly1305_h_l185_c10_cd6c_return_output;

     -- BIN_OP_MINUS[poly1305_h_l194_c16_f3ea] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_left <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_left;
     BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_right <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_return_output := BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_return_output;

     -- BIN_OP_EQ[poly1305_h_l186_c9_6d44] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l186_c9_6d44_left <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_6d44_left;
     BIN_OP_EQ_poly1305_h_l186_c9_6d44_right <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_6d44_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_6d44_return_output := BIN_OP_EQ_poly1305_h_l186_c9_6d44_return_output;

     -- Submodule level 9
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_06e9_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_cd6c_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_32c8_right := VAR_BIN_OP_EQ_poly1305_h_l186_c9_6d44_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_right := VAR_BIN_OP_GTE_poly1305_h_l187_c9_8ac9_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_a1d6_left := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_f3ea_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0175_return_output;
     -- BIN_OP_EQ[poly1305_h_l185_c10_06e9] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l185_c10_06e9_left <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_06e9_left;
     BIN_OP_EQ_poly1305_h_l185_c10_06e9_right <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_06e9_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_06e9_return_output := BIN_OP_EQ_poly1305_h_l185_c10_06e9_return_output;

     -- BIN_OP_GT[poly1305_h_l195_c19_a1d6] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l195_c19_a1d6_left <= VAR_BIN_OP_GT_poly1305_h_l195_c19_a1d6_left;
     BIN_OP_GT_poly1305_h_l195_c19_a1d6_right <= VAR_BIN_OP_GT_poly1305_h_l195_c19_a1d6_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l195_c19_a1d6_return_output := BIN_OP_GT_poly1305_h_l195_c19_a1d6_return_output;

     -- Submodule level 10
     VAR_BIN_OP_AND_poly1305_h_l185_c10_32c8_left := VAR_BIN_OP_EQ_poly1305_h_l185_c10_06e9_return_output;
     VAR_MUX_poly1305_h_l195_c19_0cb8_cond := VAR_BIN_OP_GT_poly1305_h_l195_c19_a1d6_return_output;
     -- MUX[poly1305_h_l195_c19_0cb8] LATENCY=0
     -- Inputs
     MUX_poly1305_h_l195_c19_0cb8_cond <= VAR_MUX_poly1305_h_l195_c19_0cb8_cond;
     MUX_poly1305_h_l195_c19_0cb8_iftrue <= VAR_MUX_poly1305_h_l195_c19_0cb8_iftrue;
     MUX_poly1305_h_l195_c19_0cb8_iffalse <= VAR_MUX_poly1305_h_l195_c19_0cb8_iffalse;
     -- Outputs
     VAR_MUX_poly1305_h_l195_c19_0cb8_return_output := MUX_poly1305_h_l195_c19_0cb8_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_32c8] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_32c8_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_32c8_left;
     BIN_OP_AND_poly1305_h_l185_c10_32c8_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_32c8_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_32c8_return_output := BIN_OP_AND_poly1305_h_l185_c10_32c8_return_output;

     -- Submodule level 11
     VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_32c8_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_right := VAR_MUX_poly1305_h_l195_c19_0cb8_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_71f8_left := VAR_MUX_poly1305_h_l195_c19_0cb8_return_output;
     -- BIN_OP_MINUS[poly1305_h_l198_c16_d1ad] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_return_output;

     -- BIN_OP_NEQ[poly1305_h_l199_c64_71f8] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l199_c64_71f8_left <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_71f8_left;
     BIN_OP_NEQ_poly1305_h_l199_c64_71f8_right <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_71f8_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_71f8_return_output := BIN_OP_NEQ_poly1305_h_l199_c64_71f8_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_fd13] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_fd13_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_left;
     BIN_OP_AND_poly1305_h_l185_c10_fd13_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_return_output := BIN_OP_AND_poly1305_h_l185_c10_fd13_return_output;

     -- Submodule level 12
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_fd13_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_0272_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_7af5_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_d1ad_return_output;
     VAR_BIN_OP_AND_poly1305_h_l199_c42_1702_right := VAR_BIN_OP_NEQ_poly1305_h_l199_c64_71f8_return_output;
     -- a_limbs_0_MUX[poly1305_h_l185_c5_2392] LATENCY=0
     -- Inputs
     a_limbs_0_MUX_poly1305_h_l185_c5_2392_cond <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_cond;
     a_limbs_0_MUX_poly1305_h_l185_c5_2392_iftrue <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_iftrue;
     a_limbs_0_MUX_poly1305_h_l185_c5_2392_iffalse <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_iffalse;
     -- Outputs
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_return_output := a_limbs_0_MUX_poly1305_h_l185_c5_2392_return_output;

     -- a_limbs_1_MUX[poly1305_h_l185_c5_2392] LATENCY=0
     -- Inputs
     a_limbs_1_MUX_poly1305_h_l185_c5_2392_cond <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_cond;
     a_limbs_1_MUX_poly1305_h_l185_c5_2392_iftrue <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_iftrue;
     a_limbs_1_MUX_poly1305_h_l185_c5_2392_iffalse <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_iffalse;
     -- Outputs
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_return_output := a_limbs_1_MUX_poly1305_h_l185_c5_2392_return_output;

     -- BIN_OP_EQ[poly1305_h_l199_c42_0272] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l199_c42_0272_left <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_0272_left;
     BIN_OP_EQ_poly1305_h_l199_c42_0272_right <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_0272_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_0272_return_output := BIN_OP_EQ_poly1305_h_l199_c42_0272_return_output;

     -- BIN_OP_GT[poly1305_h_l199_c19_7af5] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l199_c19_7af5_left <= VAR_BIN_OP_GT_poly1305_h_l199_c19_7af5_left;
     BIN_OP_GT_poly1305_h_l199_c19_7af5_right <= VAR_BIN_OP_GT_poly1305_h_l199_c19_7af5_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l199_c19_7af5_return_output := BIN_OP_GT_poly1305_h_l199_c19_7af5_return_output;

     -- Submodule level 13
     VAR_BIN_OP_AND_poly1305_h_l199_c42_1702_left := VAR_BIN_OP_EQ_poly1305_h_l199_c42_0272_return_output;
     VAR_BIN_OP_OR_poly1305_h_l199_c19_b1f7_left := VAR_BIN_OP_GT_poly1305_h_l199_c19_7af5_return_output;
     -- BIN_OP_AND[poly1305_h_l199_c42_1702] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l199_c42_1702_left <= VAR_BIN_OP_AND_poly1305_h_l199_c42_1702_left;
     BIN_OP_AND_poly1305_h_l199_c42_1702_right <= VAR_BIN_OP_AND_poly1305_h_l199_c42_1702_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l199_c42_1702_return_output := BIN_OP_AND_poly1305_h_l199_c42_1702_return_output;

     -- Submodule level 14
     VAR_BIN_OP_OR_poly1305_h_l199_c19_b1f7_right := VAR_BIN_OP_AND_poly1305_h_l199_c42_1702_return_output;
     -- BIN_OP_OR[poly1305_h_l199_c19_b1f7] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l199_c19_b1f7_left <= VAR_BIN_OP_OR_poly1305_h_l199_c19_b1f7_left;
     BIN_OP_OR_poly1305_h_l199_c19_b1f7_right <= VAR_BIN_OP_OR_poly1305_h_l199_c19_b1f7_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l199_c19_b1f7_return_output := BIN_OP_OR_poly1305_h_l199_c19_b1f7_return_output;

     -- Submodule level 15
     VAR_borrow_poly1305_h_l199_c9_8b4b := resize(VAR_BIN_OP_OR_poly1305_h_l199_c19_b1f7_return_output, 64);
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_a486_right := VAR_borrow_poly1305_h_l199_c9_8b4b;
     -- BIN_OP_MINUS[poly1305_h_l202_c9_a486] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l202_c9_a486_left <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_a486_left;
     BIN_OP_MINUS_poly1305_h_l202_c9_a486_right <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_a486_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_a486_return_output := BIN_OP_MINUS_poly1305_h_l202_c9_a486_return_output;

     -- Submodule level 16
     VAR_BIN_OP_AND_poly1305_h_l203_c9_1538_left := VAR_BIN_OP_MINUS_poly1305_h_l202_c9_a486_return_output;
     -- BIN_OP_AND[poly1305_h_l203_c9_1538] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l203_c9_1538_left <= VAR_BIN_OP_AND_poly1305_h_l203_c9_1538_left;
     BIN_OP_AND_poly1305_h_l203_c9_1538_right <= VAR_BIN_OP_AND_poly1305_h_l203_c9_1538_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l203_c9_1538_return_output := BIN_OP_AND_poly1305_h_l203_c9_1538_return_output;

     -- Submodule level 17
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_iftrue := VAR_BIN_OP_AND_poly1305_h_l203_c9_1538_return_output;
     -- a_limbs_2_MUX[poly1305_h_l185_c5_2392] LATENCY=0
     -- Inputs
     a_limbs_2_MUX_poly1305_h_l185_c5_2392_cond <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_cond;
     a_limbs_2_MUX_poly1305_h_l185_c5_2392_iftrue <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_iftrue;
     a_limbs_2_MUX_poly1305_h_l185_c5_2392_iffalse <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_iffalse;
     -- Outputs
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_return_output := a_limbs_2_MUX_poly1305_h_l185_c5_2392_return_output;

     -- Submodule level 18
     -- CONST_REF_RD_u320_t_u320_t_6a3b[poly1305_h_l205_c12_439e] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_6a3b_poly1305_h_l205_c12_439e_return_output := CONST_REF_RD_u320_t_u320_t_6a3b(
     VAR_a_MUX_poly1305_h_l165_c5_0f81_return_output,
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_2392_return_output,
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_2392_return_output,
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_2392_return_output);

     -- Submodule level 19
     VAR_return_output := VAR_CONST_REF_RD_u320_t_u320_t_6a3b_poly1305_h_l205_c12_439e_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
