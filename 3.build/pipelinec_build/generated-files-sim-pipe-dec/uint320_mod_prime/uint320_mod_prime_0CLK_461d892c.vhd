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
-- BIN_OP_AND[poly1305_h_l164_c26_e00e]
signal BIN_OP_AND_poly1305_h_l164_c26_e00e_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_e00e_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_e00e_return_output : unsigned(63 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c9_4b8b]
signal BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c22_5d4e]
signal BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_e567]
signal BIN_OP_OR_poly1305_h_l165_c9_e567_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_e567_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_e567_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c36_237a]
signal BIN_OP_NEQ_poly1305_h_l165_c36_237a_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_237a_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_237a_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_e7b3]
signal BIN_OP_OR_poly1305_h_l165_c9_e7b3_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_e7b3_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_e7b3_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_h_l165_c5_a25a]
signal a_MUX_poly1305_h_l165_c5_a25a_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_h_l165_c5_a25a_iftrue : u320_t;
signal a_MUX_poly1305_h_l165_c5_a25a_iffalse : u320_t;
signal a_MUX_poly1305_h_l165_c5_a25a_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l170_c9_720c]
signal BIN_OP_AND_poly1305_h_l170_c9_720c_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_720c_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_720c_return_output : unsigned(63 downto 0);

-- CONST_SR_2[poly1305_h_l178_c26_f05a]
signal CONST_SR_2_poly1305_h_l178_c26_f05a_x : unsigned(63 downto 0);
signal CONST_SR_2_poly1305_h_l178_c26_f05a_return_output : unsigned(63 downto 0);

-- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_3469]
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_left : unsigned(63 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_right : unsigned(2 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_return_output : unsigned(66 downto 0);

-- uint320_add[poly1305_h_l181_c13_901d]
signal uint320_add_poly1305_h_l181_c13_901d_a : u320_t;
signal uint320_add_poly1305_h_l181_c13_901d_b : u320_t;
signal uint320_add_poly1305_h_l181_c13_901d_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l185_c10_6c38]
signal BIN_OP_AND_poly1305_h_l185_c10_6c38_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_6c38_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_6c38_return_output : unsigned(63 downto 0);

-- BIN_OP_EQ[poly1305_h_l185_c10_2e7c]
signal BIN_OP_EQ_poly1305_h_l185_c10_2e7c_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_2e7c_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_2e7c_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l186_c9_71f4]
signal BIN_OP_EQ_poly1305_h_l186_c9_71f4_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_71f4_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_71f4_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_5f08]
signal BIN_OP_AND_poly1305_h_l185_c10_5f08_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_5f08_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_5f08_return_output : unsigned(0 downto 0);

-- BIN_OP_GTE[poly1305_h_l187_c9_de1d]
signal BIN_OP_GTE_poly1305_h_l187_c9_de1d_left : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_de1d_right : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_de1d_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_2dec]
signal BIN_OP_AND_poly1305_h_l185_c10_2dec_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_2dec_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_2dec_return_output : unsigned(0 downto 0);

-- a_limbs_0_MUX[poly1305_h_l185_c5_dfd1]
signal a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_cond : unsigned(0 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iftrue : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iffalse : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_return_output : unsigned(63 downto 0);

-- a_limbs_1_MUX[poly1305_h_l185_c5_dfd1]
signal a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_cond : unsigned(0 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iftrue : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iffalse : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_return_output : unsigned(63 downto 0);

-- a_limbs_2_MUX[poly1305_h_l185_c5_dfd1]
signal a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_cond : unsigned(0 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iftrue : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iffalse : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l194_c16_a09d]
signal BIN_OP_MINUS_poly1305_h_l194_c16_a09d_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_a09d_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_a09d_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l195_c19_2ae2]
signal BIN_OP_GT_poly1305_h_l195_c19_2ae2_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_2ae2_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_2ae2_return_output : unsigned(0 downto 0);

-- MUX[poly1305_h_l195_c19_e815]
signal MUX_poly1305_h_l195_c19_e815_cond : unsigned(0 downto 0);
signal MUX_poly1305_h_l195_c19_e815_iftrue : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_e815_iffalse : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_e815_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_4807]
signal BIN_OP_MINUS_poly1305_h_l198_c16_4807_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_4807_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_4807_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_760a]
signal BIN_OP_MINUS_poly1305_h_l198_c16_760a_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_760a_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_760a_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l199_c19_e4de]
signal BIN_OP_GT_poly1305_h_l199_c19_e4de_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_e4de_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_e4de_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l199_c42_979c]
signal BIN_OP_EQ_poly1305_h_l199_c42_979c_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_979c_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_979c_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l199_c64_d19a]
signal BIN_OP_NEQ_poly1305_h_l199_c64_d19a_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_d19a_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_d19a_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l199_c42_ba87]
signal BIN_OP_AND_poly1305_h_l199_c42_ba87_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_ba87_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_ba87_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l199_c19_ebf5]
signal BIN_OP_OR_poly1305_h_l199_c19_ebf5_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_ebf5_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_ebf5_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[poly1305_h_l202_c9_bf85]
signal BIN_OP_MINUS_poly1305_h_l202_c9_bf85_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_bf85_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_bf85_return_output : unsigned(63 downto 0);

-- BIN_OP_AND[poly1305_h_l203_c9_5c26]
signal BIN_OP_AND_poly1305_h_l203_c9_5c26_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_5c26_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_5c26_return_output : unsigned(63 downto 0);

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
-- BIN_OP_AND_poly1305_h_l164_c26_e00e : 0 clocks latency
BIN_OP_AND_poly1305_h_l164_c26_e00e : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l164_c26_e00e_left,
BIN_OP_AND_poly1305_h_l164_c26_e00e_right,
BIN_OP_AND_poly1305_h_l164_c26_e00e_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c9_4b8b : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c9_4b8b : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_left,
BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_right,
BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c22_5d4e : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c22_5d4e : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_left,
BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_right,
BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_e567 : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_e567 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_e567_left,
BIN_OP_OR_poly1305_h_l165_c9_e567_right,
BIN_OP_OR_poly1305_h_l165_c9_e567_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c36_237a : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c36_237a : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c36_237a_left,
BIN_OP_NEQ_poly1305_h_l165_c36_237a_right,
BIN_OP_NEQ_poly1305_h_l165_c36_237a_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_e7b3 : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_e7b3 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_e7b3_left,
BIN_OP_OR_poly1305_h_l165_c9_e7b3_right,
BIN_OP_OR_poly1305_h_l165_c9_e7b3_return_output);

-- a_MUX_poly1305_h_l165_c5_a25a : 0 clocks latency
a_MUX_poly1305_h_l165_c5_a25a : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_h_l165_c5_a25a_cond,
a_MUX_poly1305_h_l165_c5_a25a_iftrue,
a_MUX_poly1305_h_l165_c5_a25a_iffalse,
a_MUX_poly1305_h_l165_c5_a25a_return_output);

-- BIN_OP_AND_poly1305_h_l170_c9_720c : 0 clocks latency
BIN_OP_AND_poly1305_h_l170_c9_720c : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l170_c9_720c_left,
BIN_OP_AND_poly1305_h_l170_c9_720c_right,
BIN_OP_AND_poly1305_h_l170_c9_720c_return_output);

-- CONST_SR_2_poly1305_h_l178_c26_f05a : 0 clocks latency
CONST_SR_2_poly1305_h_l178_c26_f05a : entity work.CONST_SR_2_uint64_t_0CLK_de264c78 port map (
CONST_SR_2_poly1305_h_l178_c26_f05a_x,
CONST_SR_2_poly1305_h_l178_c26_f05a_return_output);

-- BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469 : 0 clocks latency
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469 : entity work.BIN_OP_INFERRED_MULT_uint64_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_left,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_right,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_return_output);

-- uint320_add_poly1305_h_l181_c13_901d : 0 clocks latency
uint320_add_poly1305_h_l181_c13_901d : entity work.uint320_add_0CLK_10d8c973 port map (
uint320_add_poly1305_h_l181_c13_901d_a,
uint320_add_poly1305_h_l181_c13_901d_b,
uint320_add_poly1305_h_l181_c13_901d_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_6c38 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_6c38 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_6c38_left,
BIN_OP_AND_poly1305_h_l185_c10_6c38_right,
BIN_OP_AND_poly1305_h_l185_c10_6c38_return_output);

-- BIN_OP_EQ_poly1305_h_l185_c10_2e7c : 0 clocks latency
BIN_OP_EQ_poly1305_h_l185_c10_2e7c : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l185_c10_2e7c_left,
BIN_OP_EQ_poly1305_h_l185_c10_2e7c_right,
BIN_OP_EQ_poly1305_h_l185_c10_2e7c_return_output);

-- BIN_OP_EQ_poly1305_h_l186_c9_71f4 : 0 clocks latency
BIN_OP_EQ_poly1305_h_l186_c9_71f4 : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l186_c9_71f4_left,
BIN_OP_EQ_poly1305_h_l186_c9_71f4_right,
BIN_OP_EQ_poly1305_h_l186_c9_71f4_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_5f08 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_5f08 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_5f08_left,
BIN_OP_AND_poly1305_h_l185_c10_5f08_right,
BIN_OP_AND_poly1305_h_l185_c10_5f08_return_output);

-- BIN_OP_GTE_poly1305_h_l187_c9_de1d : 0 clocks latency
BIN_OP_GTE_poly1305_h_l187_c9_de1d : entity work.BIN_OP_GTE_uint64_t_uint64_t_0CLK_6f2c5aad port map (
BIN_OP_GTE_poly1305_h_l187_c9_de1d_left,
BIN_OP_GTE_poly1305_h_l187_c9_de1d_right,
BIN_OP_GTE_poly1305_h_l187_c9_de1d_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_2dec : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_2dec : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_2dec_left,
BIN_OP_AND_poly1305_h_l185_c10_2dec_right,
BIN_OP_AND_poly1305_h_l185_c10_2dec_return_output);

-- a_limbs_0_MUX_poly1305_h_l185_c5_dfd1 : 0 clocks latency
a_limbs_0_MUX_poly1305_h_l185_c5_dfd1 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_cond,
a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iftrue,
a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iffalse,
a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_return_output);

-- a_limbs_1_MUX_poly1305_h_l185_c5_dfd1 : 0 clocks latency
a_limbs_1_MUX_poly1305_h_l185_c5_dfd1 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_cond,
a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iftrue,
a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iffalse,
a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_return_output);

-- a_limbs_2_MUX_poly1305_h_l185_c5_dfd1 : 0 clocks latency
a_limbs_2_MUX_poly1305_h_l185_c5_dfd1 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_cond,
a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iftrue,
a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iffalse,
a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_return_output);

-- BIN_OP_MINUS_poly1305_h_l194_c16_a09d : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l194_c16_a09d : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l194_c16_a09d_left,
BIN_OP_MINUS_poly1305_h_l194_c16_a09d_right,
BIN_OP_MINUS_poly1305_h_l194_c16_a09d_return_output);

-- BIN_OP_GT_poly1305_h_l195_c19_2ae2 : 0 clocks latency
BIN_OP_GT_poly1305_h_l195_c19_2ae2 : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l195_c19_2ae2_left,
BIN_OP_GT_poly1305_h_l195_c19_2ae2_right,
BIN_OP_GT_poly1305_h_l195_c19_2ae2_return_output);

-- MUX_poly1305_h_l195_c19_e815 : 0 clocks latency
MUX_poly1305_h_l195_c19_e815 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
MUX_poly1305_h_l195_c19_e815_cond,
MUX_poly1305_h_l195_c19_e815_iftrue,
MUX_poly1305_h_l195_c19_e815_iffalse,
MUX_poly1305_h_l195_c19_e815_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_4807 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_4807 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_4807_left,
BIN_OP_MINUS_poly1305_h_l198_c16_4807_right,
BIN_OP_MINUS_poly1305_h_l198_c16_4807_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_760a : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_760a : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_760a_left,
BIN_OP_MINUS_poly1305_h_l198_c16_760a_right,
BIN_OP_MINUS_poly1305_h_l198_c16_760a_return_output);

-- BIN_OP_GT_poly1305_h_l199_c19_e4de : 0 clocks latency
BIN_OP_GT_poly1305_h_l199_c19_e4de : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l199_c19_e4de_left,
BIN_OP_GT_poly1305_h_l199_c19_e4de_right,
BIN_OP_GT_poly1305_h_l199_c19_e4de_return_output);

-- BIN_OP_EQ_poly1305_h_l199_c42_979c : 0 clocks latency
BIN_OP_EQ_poly1305_h_l199_c42_979c : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l199_c42_979c_left,
BIN_OP_EQ_poly1305_h_l199_c42_979c_right,
BIN_OP_EQ_poly1305_h_l199_c42_979c_return_output);

-- BIN_OP_NEQ_poly1305_h_l199_c64_d19a : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l199_c64_d19a : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l199_c64_d19a_left,
BIN_OP_NEQ_poly1305_h_l199_c64_d19a_right,
BIN_OP_NEQ_poly1305_h_l199_c64_d19a_return_output);

-- BIN_OP_AND_poly1305_h_l199_c42_ba87 : 0 clocks latency
BIN_OP_AND_poly1305_h_l199_c42_ba87 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l199_c42_ba87_left,
BIN_OP_AND_poly1305_h_l199_c42_ba87_right,
BIN_OP_AND_poly1305_h_l199_c42_ba87_return_output);

-- BIN_OP_OR_poly1305_h_l199_c19_ebf5 : 0 clocks latency
BIN_OP_OR_poly1305_h_l199_c19_ebf5 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l199_c19_ebf5_left,
BIN_OP_OR_poly1305_h_l199_c19_ebf5_right,
BIN_OP_OR_poly1305_h_l199_c19_ebf5_return_output);

-- BIN_OP_MINUS_poly1305_h_l202_c9_bf85 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l202_c9_bf85 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l202_c9_bf85_left,
BIN_OP_MINUS_poly1305_h_l202_c9_bf85_right,
BIN_OP_MINUS_poly1305_h_l202_c9_bf85_return_output);

-- BIN_OP_AND_poly1305_h_l203_c9_5c26 : 0 clocks latency
BIN_OP_AND_poly1305_h_l203_c9_5c26 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l203_c9_5c26_left,
BIN_OP_AND_poly1305_h_l203_c9_5c26_right,
BIN_OP_AND_poly1305_h_l203_c9_5c26_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 a,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l164_c26_e00e_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_e567_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c36_237a_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_e7b3_return_output,
 a_MUX_poly1305_h_l165_c5_a25a_return_output,
 BIN_OP_AND_poly1305_h_l170_c9_720c_return_output,
 CONST_SR_2_poly1305_h_l178_c26_f05a_return_output,
 BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_return_output,
 uint320_add_poly1305_h_l181_c13_901d_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_6c38_return_output,
 BIN_OP_EQ_poly1305_h_l185_c10_2e7c_return_output,
 BIN_OP_EQ_poly1305_h_l186_c9_71f4_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_5f08_return_output,
 BIN_OP_GTE_poly1305_h_l187_c9_de1d_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_2dec_return_output,
 a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_return_output,
 a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_return_output,
 a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_return_output,
 BIN_OP_MINUS_poly1305_h_l194_c16_a09d_return_output,
 BIN_OP_GT_poly1305_h_l195_c19_2ae2_return_output,
 MUX_poly1305_h_l195_c19_e815_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_4807_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_760a_return_output,
 BIN_OP_GT_poly1305_h_l199_c19_e4de_return_output,
 BIN_OP_EQ_poly1305_h_l199_c42_979c_return_output,
 BIN_OP_NEQ_poly1305_h_l199_c64_d19a_return_output,
 BIN_OP_AND_poly1305_h_l199_c42_ba87_return_output,
 BIN_OP_OR_poly1305_h_l199_c19_ebf5_return_output,
 BIN_OP_MINUS_poly1305_h_l202_c9_bf85_return_output,
 BIN_OP_AND_poly1305_h_l203_c9_5c26_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u320_t;
 variable VAR_a : u320_t;
 variable VAR_mask : unsigned(63 downto 0);
 variable VAR_high_bits : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_e567_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_d933_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_e567_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_e567_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_e7b3_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_4c76_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_237a_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_237a_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_237a_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_e7b3_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_e7b3_return_output : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_h_l165_c5_a25a_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_a25a_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_a25a_return_output : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_a25a_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_720c_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_720c_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_720c_return_output : unsigned(63 downto 0);
 variable VAR_mul5 : u320_t;
 variable VAR_mul5_limbs_0_poly1305_h_l178_c9_803c : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_f05a_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_left : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_f05a_x : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_return_output : unsigned(66 downto 0);
 variable VAR_uint320_add_poly1305_h_l181_c13_901d_a : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_901d_b : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_f84b_return_output : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_0829_return_output : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_901d_return_output : u320_t;
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_6c38_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_6c38_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_6c38_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_2e7c_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_2e7c_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_2e7c_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_5f08_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_71f4_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_71f4_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_71f4_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_5f08_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_5f08_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_de1d_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_de1d_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_de1d_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_return_output : unsigned(0 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_cond : unsigned(0 downto 0);
 variable VAR_borrow : unsigned(63 downto 0);
 variable VAR_diff : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_return_output : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_e815_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_2ae2_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_2ae2_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_2ae2_return_output : unsigned(0 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_e815_iftrue : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_e815_iffalse : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_e815_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4807_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4807_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4807_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_return_output : unsigned(63 downto 0);
 variable VAR_borrow_poly1305_h_l199_c9_4348 : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_e4de_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_e4de_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_e4de_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_ebf5_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_979c_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_979c_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_979c_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_ba87_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_d19a_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_d19a_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_d19a_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_ba87_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_ba87_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_ebf5_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_ebf5_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_bf85_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_bf85_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_bf85_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_5c26_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_5c26_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_5c26_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_1535_return_output : u320_t;
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_2dc1_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_3850_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l198_l186_DUPLICATE_f687_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l185_l194_l187_DUPLICATE_91f4_return_output : unsigned(63 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_right := unsigned'(X"fffffffffffffffb");
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_237a_right := to_unsigned(0, 1);
     VAR_MUX_poly1305_h_l195_c19_e815_iffalse := to_unsigned(0, 64);
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_right := to_unsigned(5, 3);
     VAR_MUX_poly1305_h_l195_c19_e815_iftrue := to_unsigned(1, 64);
     VAR_BIN_OP_AND_poly1305_h_l203_c9_5c26_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l170_c9_720c_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_2e7c_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l185_c10_6c38_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_de1d_right := unsigned'(X"fffffffffffffffb");
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_right := to_unsigned(0, 1);
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_d19a_right := to_unsigned(0, 1);
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_71f4_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4807_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_right := to_unsigned(0, 1);
     VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_right := unsigned'(X"fffffc0000000000");

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_a := a;

     -- Submodule level 0
     VAR_a_MUX_poly1305_h_l165_c5_a25a_iffalse := VAR_a;
     -- CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d[poly1305_h_l165_c22_d933] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_d933_return_output := VAR_a.limbs(3);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d[poly1305_h_l165_c36_4c76] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_4c76_return_output := VAR_a.limbs(4);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_2dc1 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_2dc1_return_output := VAR_a.limbs(2);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_2dc1_return_output;
     VAR_BIN_OP_AND_poly1305_h_l170_c9_720c_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_2dc1_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_d933_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_237a_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_4c76_return_output;
     -- BIN_OP_NEQ[poly1305_h_l165_c36_237a] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c36_237a_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_237a_left;
     BIN_OP_NEQ_poly1305_h_l165_c36_237a_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_237a_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_237a_return_output := BIN_OP_NEQ_poly1305_h_l165_c36_237a_return_output;

     -- BIN_OP_AND[poly1305_h_l170_c9_720c] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l170_c9_720c_left <= VAR_BIN_OP_AND_poly1305_h_l170_c9_720c_left;
     BIN_OP_AND_poly1305_h_l170_c9_720c_right <= VAR_BIN_OP_AND_poly1305_h_l170_c9_720c_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l170_c9_720c_return_output := BIN_OP_AND_poly1305_h_l170_c9_720c_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c22_5d4e] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_left;
     BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_return_output := BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_return_output;

     -- BIN_OP_AND[poly1305_h_l164_c26_e00e] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l164_c26_e00e_left <= VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_left;
     BIN_OP_AND_poly1305_h_l164_c26_e00e_right <= VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_return_output := BIN_OP_AND_poly1305_h_l164_c26_e00e_return_output;

     -- Submodule level 2
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_left := VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_return_output;
     VAR_CONST_SR_2_poly1305_h_l178_c26_f05a_x := VAR_BIN_OP_AND_poly1305_h_l164_c26_e00e_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_e567_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c22_5d4e_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_e7b3_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c36_237a_return_output;
     -- BIN_OP_NEQ[poly1305_h_l165_c9_4b8b] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_left;
     BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_return_output := BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_return_output;

     -- CONST_REF_RD_u320_t_u320_t_57df[poly1305_h_l181_c25_f84b] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_f84b_return_output := CONST_REF_RD_u320_t_u320_t_57df(
     VAR_a,
     VAR_BIN_OP_AND_poly1305_h_l170_c9_720c_return_output,
     to_unsigned(0, 64),
     to_unsigned(0, 64));

     -- CONST_SR_2[poly1305_h_l178_c26_f05a] LATENCY=0
     -- Inputs
     CONST_SR_2_poly1305_h_l178_c26_f05a_x <= VAR_CONST_SR_2_poly1305_h_l178_c26_f05a_x;
     -- Outputs
     VAR_CONST_SR_2_poly1305_h_l178_c26_f05a_return_output := CONST_SR_2_poly1305_h_l178_c26_f05a_return_output;

     -- Submodule level 3
     VAR_BIN_OP_OR_poly1305_h_l165_c9_e567_left := VAR_BIN_OP_NEQ_poly1305_h_l165_c9_4b8b_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_901d_a := VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_f84b_return_output;
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_left := VAR_CONST_SR_2_poly1305_h_l178_c26_f05a_return_output;
     -- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_3469] LATENCY=0
     -- Inputs
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_left <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_left;
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_right <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_right;
     -- Outputs
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_return_output := BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_return_output;

     -- BIN_OP_OR[poly1305_h_l165_c9_e567] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_e567_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_e567_left;
     BIN_OP_OR_poly1305_h_l165_c9_e567_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_e567_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_e567_return_output := BIN_OP_OR_poly1305_h_l165_c9_e567_return_output;

     -- Submodule level 4
     VAR_mul5_limbs_0_poly1305_h_l178_c9_803c := resize(VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_3469_return_output, 64);
     VAR_BIN_OP_OR_poly1305_h_l165_c9_e7b3_left := VAR_BIN_OP_OR_poly1305_h_l165_c9_e567_return_output;
     -- CONST_REF_RD_u320_t_u320_t_853a[poly1305_h_l181_c28_0829] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_0829_return_output := CONST_REF_RD_u320_t_u320_t_853a(
     u320_t_NULL,
     VAR_mul5_limbs_0_poly1305_h_l178_c9_803c);

     -- BIN_OP_OR[poly1305_h_l165_c9_e7b3] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_e7b3_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_e7b3_left;
     BIN_OP_OR_poly1305_h_l165_c9_e7b3_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_e7b3_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_e7b3_return_output := BIN_OP_OR_poly1305_h_l165_c9_e7b3_return_output;

     -- Submodule level 5
     VAR_a_MUX_poly1305_h_l165_c5_a25a_cond := VAR_BIN_OP_OR_poly1305_h_l165_c9_e7b3_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_901d_b := VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_0829_return_output;
     -- uint320_add[poly1305_h_l181_c13_901d] LATENCY=0
     -- Inputs
     uint320_add_poly1305_h_l181_c13_901d_a <= VAR_uint320_add_poly1305_h_l181_c13_901d_a;
     uint320_add_poly1305_h_l181_c13_901d_b <= VAR_uint320_add_poly1305_h_l181_c13_901d_b;
     -- Outputs
     VAR_uint320_add_poly1305_h_l181_c13_901d_return_output := uint320_add_poly1305_h_l181_c13_901d_return_output;

     -- Submodule level 6
     VAR_a_MUX_poly1305_h_l165_c5_a25a_iftrue := VAR_uint320_add_poly1305_h_l181_c13_901d_return_output;
     -- a_MUX[poly1305_h_l165_c5_a25a] LATENCY=0
     -- Inputs
     a_MUX_poly1305_h_l165_c5_a25a_cond <= VAR_a_MUX_poly1305_h_l165_c5_a25a_cond;
     a_MUX_poly1305_h_l165_c5_a25a_iftrue <= VAR_a_MUX_poly1305_h_l165_c5_a25a_iftrue;
     a_MUX_poly1305_h_l165_c5_a25a_iffalse <= VAR_a_MUX_poly1305_h_l165_c5_a25a_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_h_l165_c5_a25a_return_output := a_MUX_poly1305_h_l165_c5_a25a_return_output;

     -- Submodule level 7
     -- CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l198_l186_DUPLICATE_f687 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l198_l186_DUPLICATE_f687_return_output := VAR_a_MUX_poly1305_h_l165_c5_a25a_return_output.limbs(1);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_3850 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_3850_return_output := VAR_a_MUX_poly1305_h_l165_c5_a25a_return_output.limbs(2);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l185_l194_l187_DUPLICATE_91f4 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l185_l194_l187_DUPLICATE_91f4_return_output := VAR_a_MUX_poly1305_h_l165_c5_a25a_return_output.limbs(0);

     -- Submodule level 8
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_de1d_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l185_l194_l187_DUPLICATE_91f4_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_2ae2_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l185_l194_l187_DUPLICATE_91f4_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l185_l194_l187_DUPLICATE_91f4_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l195_l185_l194_l187_DUPLICATE_91f4_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_71f4_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l198_l186_DUPLICATE_f687_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_979c_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l198_l186_DUPLICATE_f687_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_e4de_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l198_l186_DUPLICATE_f687_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4807_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l198_l186_DUPLICATE_f687_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l198_l186_DUPLICATE_f687_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_6c38_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_3850_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_bf85_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_3850_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_3850_return_output;
     -- BIN_OP_MINUS[poly1305_h_l194_c16_a09d] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l194_c16_a09d_left <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_left;
     BIN_OP_MINUS_poly1305_h_l194_c16_a09d_right <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_return_output := BIN_OP_MINUS_poly1305_h_l194_c16_a09d_return_output;

     -- BIN_OP_GTE[poly1305_h_l187_c9_de1d] LATENCY=0
     -- Inputs
     BIN_OP_GTE_poly1305_h_l187_c9_de1d_left <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_de1d_left;
     BIN_OP_GTE_poly1305_h_l187_c9_de1d_right <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_de1d_right;
     -- Outputs
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_de1d_return_output := BIN_OP_GTE_poly1305_h_l187_c9_de1d_return_output;

     -- BIN_OP_MINUS[poly1305_h_l198_c16_4807] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_4807_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4807_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_4807_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4807_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4807_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_4807_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_6c38] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_6c38_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_6c38_left;
     BIN_OP_AND_poly1305_h_l185_c10_6c38_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_6c38_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_6c38_return_output := BIN_OP_AND_poly1305_h_l185_c10_6c38_return_output;

     -- BIN_OP_EQ[poly1305_h_l186_c9_71f4] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l186_c9_71f4_left <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_71f4_left;
     BIN_OP_EQ_poly1305_h_l186_c9_71f4_right <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_71f4_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_71f4_return_output := BIN_OP_EQ_poly1305_h_l186_c9_71f4_return_output;

     -- Submodule level 9
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_2e7c_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_6c38_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_5f08_right := VAR_BIN_OP_EQ_poly1305_h_l186_c9_71f4_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_right := VAR_BIN_OP_GTE_poly1305_h_l187_c9_de1d_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_2ae2_left := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_a09d_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4807_return_output;
     -- BIN_OP_EQ[poly1305_h_l185_c10_2e7c] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l185_c10_2e7c_left <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_2e7c_left;
     BIN_OP_EQ_poly1305_h_l185_c10_2e7c_right <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_2e7c_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_2e7c_return_output := BIN_OP_EQ_poly1305_h_l185_c10_2e7c_return_output;

     -- BIN_OP_GT[poly1305_h_l195_c19_2ae2] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l195_c19_2ae2_left <= VAR_BIN_OP_GT_poly1305_h_l195_c19_2ae2_left;
     BIN_OP_GT_poly1305_h_l195_c19_2ae2_right <= VAR_BIN_OP_GT_poly1305_h_l195_c19_2ae2_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l195_c19_2ae2_return_output := BIN_OP_GT_poly1305_h_l195_c19_2ae2_return_output;

     -- Submodule level 10
     VAR_BIN_OP_AND_poly1305_h_l185_c10_5f08_left := VAR_BIN_OP_EQ_poly1305_h_l185_c10_2e7c_return_output;
     VAR_MUX_poly1305_h_l195_c19_e815_cond := VAR_BIN_OP_GT_poly1305_h_l195_c19_2ae2_return_output;
     -- MUX[poly1305_h_l195_c19_e815] LATENCY=0
     -- Inputs
     MUX_poly1305_h_l195_c19_e815_cond <= VAR_MUX_poly1305_h_l195_c19_e815_cond;
     MUX_poly1305_h_l195_c19_e815_iftrue <= VAR_MUX_poly1305_h_l195_c19_e815_iftrue;
     MUX_poly1305_h_l195_c19_e815_iffalse <= VAR_MUX_poly1305_h_l195_c19_e815_iffalse;
     -- Outputs
     VAR_MUX_poly1305_h_l195_c19_e815_return_output := MUX_poly1305_h_l195_c19_e815_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_5f08] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_5f08_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_5f08_left;
     BIN_OP_AND_poly1305_h_l185_c10_5f08_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_5f08_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_5f08_return_output := BIN_OP_AND_poly1305_h_l185_c10_5f08_return_output;

     -- Submodule level 11
     VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_5f08_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_right := VAR_MUX_poly1305_h_l195_c19_e815_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_d19a_left := VAR_MUX_poly1305_h_l195_c19_e815_return_output;
     -- BIN_OP_MINUS[poly1305_h_l198_c16_760a] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_760a_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_760a_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_760a_return_output;

     -- BIN_OP_NEQ[poly1305_h_l199_c64_d19a] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l199_c64_d19a_left <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_d19a_left;
     BIN_OP_NEQ_poly1305_h_l199_c64_d19a_right <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_d19a_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_d19a_return_output := BIN_OP_NEQ_poly1305_h_l199_c64_d19a_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_2dec] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_2dec_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_left;
     BIN_OP_AND_poly1305_h_l185_c10_2dec_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_return_output := BIN_OP_AND_poly1305_h_l185_c10_2dec_return_output;

     -- Submodule level 12
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_2dec_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_979c_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_e4de_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_760a_return_output;
     VAR_BIN_OP_AND_poly1305_h_l199_c42_ba87_right := VAR_BIN_OP_NEQ_poly1305_h_l199_c64_d19a_return_output;
     -- a_limbs_0_MUX[poly1305_h_l185_c5_dfd1] LATENCY=0
     -- Inputs
     a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_cond <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_cond;
     a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iftrue <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iftrue;
     a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iffalse <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_iffalse;
     -- Outputs
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_return_output := a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_return_output;

     -- BIN_OP_EQ[poly1305_h_l199_c42_979c] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l199_c42_979c_left <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_979c_left;
     BIN_OP_EQ_poly1305_h_l199_c42_979c_right <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_979c_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_979c_return_output := BIN_OP_EQ_poly1305_h_l199_c42_979c_return_output;

     -- BIN_OP_GT[poly1305_h_l199_c19_e4de] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l199_c19_e4de_left <= VAR_BIN_OP_GT_poly1305_h_l199_c19_e4de_left;
     BIN_OP_GT_poly1305_h_l199_c19_e4de_right <= VAR_BIN_OP_GT_poly1305_h_l199_c19_e4de_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l199_c19_e4de_return_output := BIN_OP_GT_poly1305_h_l199_c19_e4de_return_output;

     -- a_limbs_1_MUX[poly1305_h_l185_c5_dfd1] LATENCY=0
     -- Inputs
     a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_cond <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_cond;
     a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iftrue <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iftrue;
     a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iffalse <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_iffalse;
     -- Outputs
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_return_output := a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_return_output;

     -- Submodule level 13
     VAR_BIN_OP_AND_poly1305_h_l199_c42_ba87_left := VAR_BIN_OP_EQ_poly1305_h_l199_c42_979c_return_output;
     VAR_BIN_OP_OR_poly1305_h_l199_c19_ebf5_left := VAR_BIN_OP_GT_poly1305_h_l199_c19_e4de_return_output;
     -- BIN_OP_AND[poly1305_h_l199_c42_ba87] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l199_c42_ba87_left <= VAR_BIN_OP_AND_poly1305_h_l199_c42_ba87_left;
     BIN_OP_AND_poly1305_h_l199_c42_ba87_right <= VAR_BIN_OP_AND_poly1305_h_l199_c42_ba87_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l199_c42_ba87_return_output := BIN_OP_AND_poly1305_h_l199_c42_ba87_return_output;

     -- Submodule level 14
     VAR_BIN_OP_OR_poly1305_h_l199_c19_ebf5_right := VAR_BIN_OP_AND_poly1305_h_l199_c42_ba87_return_output;
     -- BIN_OP_OR[poly1305_h_l199_c19_ebf5] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l199_c19_ebf5_left <= VAR_BIN_OP_OR_poly1305_h_l199_c19_ebf5_left;
     BIN_OP_OR_poly1305_h_l199_c19_ebf5_right <= VAR_BIN_OP_OR_poly1305_h_l199_c19_ebf5_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l199_c19_ebf5_return_output := BIN_OP_OR_poly1305_h_l199_c19_ebf5_return_output;

     -- Submodule level 15
     VAR_borrow_poly1305_h_l199_c9_4348 := resize(VAR_BIN_OP_OR_poly1305_h_l199_c19_ebf5_return_output, 64);
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_bf85_right := VAR_borrow_poly1305_h_l199_c9_4348;
     -- BIN_OP_MINUS[poly1305_h_l202_c9_bf85] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l202_c9_bf85_left <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_bf85_left;
     BIN_OP_MINUS_poly1305_h_l202_c9_bf85_right <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_bf85_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_bf85_return_output := BIN_OP_MINUS_poly1305_h_l202_c9_bf85_return_output;

     -- Submodule level 16
     VAR_BIN_OP_AND_poly1305_h_l203_c9_5c26_left := VAR_BIN_OP_MINUS_poly1305_h_l202_c9_bf85_return_output;
     -- BIN_OP_AND[poly1305_h_l203_c9_5c26] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l203_c9_5c26_left <= VAR_BIN_OP_AND_poly1305_h_l203_c9_5c26_left;
     BIN_OP_AND_poly1305_h_l203_c9_5c26_right <= VAR_BIN_OP_AND_poly1305_h_l203_c9_5c26_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l203_c9_5c26_return_output := BIN_OP_AND_poly1305_h_l203_c9_5c26_return_output;

     -- Submodule level 17
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iftrue := VAR_BIN_OP_AND_poly1305_h_l203_c9_5c26_return_output;
     -- a_limbs_2_MUX[poly1305_h_l185_c5_dfd1] LATENCY=0
     -- Inputs
     a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_cond <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_cond;
     a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iftrue <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iftrue;
     a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iffalse <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_iffalse;
     -- Outputs
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_return_output := a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_return_output;

     -- Submodule level 18
     -- CONST_REF_RD_u320_t_u320_t_b8ef[poly1305_h_l205_c12_1535] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_1535_return_output := CONST_REF_RD_u320_t_u320_t_b8ef(
     VAR_a_MUX_poly1305_h_l165_c5_a25a_return_output,
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dfd1_return_output,
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dfd1_return_output,
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dfd1_return_output);

     -- Submodule level 19
     VAR_return_output := VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_1535_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
