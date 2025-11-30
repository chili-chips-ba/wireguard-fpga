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
-- BIN_OP_AND[poly1305_h_l164_c26_3676]
signal BIN_OP_AND_poly1305_h_l164_c26_3676_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_3676_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_3676_return_output : unsigned(63 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c9_48d5]
signal BIN_OP_NEQ_poly1305_h_l165_c9_48d5_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_48d5_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_48d5_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c22_2793]
signal BIN_OP_NEQ_poly1305_h_l165_c22_2793_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_2793_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_2793_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_47f5]
signal BIN_OP_OR_poly1305_h_l165_c9_47f5_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_47f5_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_47f5_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c36_ce75]
signal BIN_OP_NEQ_poly1305_h_l165_c36_ce75_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_ce75_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_ce75_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_6092]
signal BIN_OP_OR_poly1305_h_l165_c9_6092_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_6092_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_6092_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_h_l165_c5_e122]
signal a_MUX_poly1305_h_l165_c5_e122_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_h_l165_c5_e122_iftrue : u320_t;
signal a_MUX_poly1305_h_l165_c5_e122_iffalse : u320_t;
signal a_MUX_poly1305_h_l165_c5_e122_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l170_c9_c640]
signal BIN_OP_AND_poly1305_h_l170_c9_c640_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_c640_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_c640_return_output : unsigned(63 downto 0);

-- CONST_SR_2[poly1305_h_l178_c26_14ee]
signal CONST_SR_2_poly1305_h_l178_c26_14ee_x : unsigned(63 downto 0);
signal CONST_SR_2_poly1305_h_l178_c26_14ee_return_output : unsigned(63 downto 0);

-- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_fbe3]
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_left : unsigned(63 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_right : unsigned(2 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_return_output : unsigned(66 downto 0);

-- uint320_add[poly1305_h_l181_c13_dcab]
signal uint320_add_poly1305_h_l181_c13_dcab_a : u320_t;
signal uint320_add_poly1305_h_l181_c13_dcab_b : u320_t;
signal uint320_add_poly1305_h_l181_c13_dcab_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l185_c10_a486]
signal BIN_OP_AND_poly1305_h_l185_c10_a486_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_a486_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_a486_return_output : unsigned(63 downto 0);

-- BIN_OP_EQ[poly1305_h_l185_c10_9f3e]
signal BIN_OP_EQ_poly1305_h_l185_c10_9f3e_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_9f3e_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_9f3e_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l186_c9_1def]
signal BIN_OP_EQ_poly1305_h_l186_c9_1def_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_1def_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_1def_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_05aa]
signal BIN_OP_AND_poly1305_h_l185_c10_05aa_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_05aa_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_05aa_return_output : unsigned(0 downto 0);

-- BIN_OP_GTE[poly1305_h_l187_c9_113c]
signal BIN_OP_GTE_poly1305_h_l187_c9_113c_left : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_113c_right : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_113c_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_11e0]
signal BIN_OP_AND_poly1305_h_l185_c10_11e0_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_11e0_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_11e0_return_output : unsigned(0 downto 0);

-- a_limbs_1_MUX[poly1305_h_l185_c5_dc28]
signal a_limbs_1_MUX_poly1305_h_l185_c5_dc28_cond : unsigned(0 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iftrue : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iffalse : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_dc28_return_output : unsigned(63 downto 0);

-- a_limbs_2_MUX[poly1305_h_l185_c5_dc28]
signal a_limbs_2_MUX_poly1305_h_l185_c5_dc28_cond : unsigned(0 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iftrue : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iffalse : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_dc28_return_output : unsigned(63 downto 0);

-- a_limbs_0_MUX[poly1305_h_l185_c5_dc28]
signal a_limbs_0_MUX_poly1305_h_l185_c5_dc28_cond : unsigned(0 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iftrue : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iffalse : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_dc28_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l194_c16_b166]
signal BIN_OP_MINUS_poly1305_h_l194_c16_b166_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_b166_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_b166_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l195_c19_6265]
signal BIN_OP_GT_poly1305_h_l195_c19_6265_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_6265_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_6265_return_output : unsigned(0 downto 0);

-- MUX[poly1305_h_l195_c19_1387]
signal MUX_poly1305_h_l195_c19_1387_cond : unsigned(0 downto 0);
signal MUX_poly1305_h_l195_c19_1387_iftrue : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_1387_iffalse : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_1387_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_4732]
signal BIN_OP_MINUS_poly1305_h_l198_c16_4732_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_4732_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_4732_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_0c7c]
signal BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l199_c19_e013]
signal BIN_OP_GT_poly1305_h_l199_c19_e013_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_e013_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_e013_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l199_c42_bead]
signal BIN_OP_EQ_poly1305_h_l199_c42_bead_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_bead_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_bead_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l199_c64_abb1]
signal BIN_OP_NEQ_poly1305_h_l199_c64_abb1_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_abb1_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_abb1_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l199_c42_9f3a]
signal BIN_OP_AND_poly1305_h_l199_c42_9f3a_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_9f3a_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_9f3a_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l199_c19_d605]
signal BIN_OP_OR_poly1305_h_l199_c19_d605_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_d605_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_d605_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[poly1305_h_l202_c9_f8f8]
signal BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_return_output : unsigned(63 downto 0);

-- BIN_OP_AND[poly1305_h_l203_c9_0ec2]
signal BIN_OP_AND_poly1305_h_l203_c9_0ec2_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_0ec2_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_0ec2_return_output : unsigned(63 downto 0);

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

function CONST_REF_RD_u320_t_u320_t_94d4( ref_toks_0 : u320_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned) return u320_t is
 
  variable base : u320_t; 
  variable return_output : u320_t;
begin
      base := ref_toks_0;
      base.limbs(1) := ref_toks_1;
      base.limbs(2) := ref_toks_2;
      base.limbs(0) := ref_toks_3;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_AND_poly1305_h_l164_c26_3676 : 0 clocks latency
BIN_OP_AND_poly1305_h_l164_c26_3676 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l164_c26_3676_left,
BIN_OP_AND_poly1305_h_l164_c26_3676_right,
BIN_OP_AND_poly1305_h_l164_c26_3676_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c9_48d5 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c9_48d5 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c9_48d5_left,
BIN_OP_NEQ_poly1305_h_l165_c9_48d5_right,
BIN_OP_NEQ_poly1305_h_l165_c9_48d5_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c22_2793 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c22_2793 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c22_2793_left,
BIN_OP_NEQ_poly1305_h_l165_c22_2793_right,
BIN_OP_NEQ_poly1305_h_l165_c22_2793_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_47f5 : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_47f5 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_47f5_left,
BIN_OP_OR_poly1305_h_l165_c9_47f5_right,
BIN_OP_OR_poly1305_h_l165_c9_47f5_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c36_ce75 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c36_ce75 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c36_ce75_left,
BIN_OP_NEQ_poly1305_h_l165_c36_ce75_right,
BIN_OP_NEQ_poly1305_h_l165_c36_ce75_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_6092 : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_6092 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_6092_left,
BIN_OP_OR_poly1305_h_l165_c9_6092_right,
BIN_OP_OR_poly1305_h_l165_c9_6092_return_output);

-- a_MUX_poly1305_h_l165_c5_e122 : 0 clocks latency
a_MUX_poly1305_h_l165_c5_e122 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_h_l165_c5_e122_cond,
a_MUX_poly1305_h_l165_c5_e122_iftrue,
a_MUX_poly1305_h_l165_c5_e122_iffalse,
a_MUX_poly1305_h_l165_c5_e122_return_output);

-- BIN_OP_AND_poly1305_h_l170_c9_c640 : 0 clocks latency
BIN_OP_AND_poly1305_h_l170_c9_c640 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l170_c9_c640_left,
BIN_OP_AND_poly1305_h_l170_c9_c640_right,
BIN_OP_AND_poly1305_h_l170_c9_c640_return_output);

-- CONST_SR_2_poly1305_h_l178_c26_14ee : 0 clocks latency
CONST_SR_2_poly1305_h_l178_c26_14ee : entity work.CONST_SR_2_uint64_t_0CLK_de264c78 port map (
CONST_SR_2_poly1305_h_l178_c26_14ee_x,
CONST_SR_2_poly1305_h_l178_c26_14ee_return_output);

-- BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3 : 0 clocks latency
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3 : entity work.BIN_OP_INFERRED_MULT_uint64_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_left,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_right,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_return_output);

-- uint320_add_poly1305_h_l181_c13_dcab : 0 clocks latency
uint320_add_poly1305_h_l181_c13_dcab : entity work.uint320_add_0CLK_10d8c973 port map (
uint320_add_poly1305_h_l181_c13_dcab_a,
uint320_add_poly1305_h_l181_c13_dcab_b,
uint320_add_poly1305_h_l181_c13_dcab_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_a486 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_a486 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_a486_left,
BIN_OP_AND_poly1305_h_l185_c10_a486_right,
BIN_OP_AND_poly1305_h_l185_c10_a486_return_output);

-- BIN_OP_EQ_poly1305_h_l185_c10_9f3e : 0 clocks latency
BIN_OP_EQ_poly1305_h_l185_c10_9f3e : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l185_c10_9f3e_left,
BIN_OP_EQ_poly1305_h_l185_c10_9f3e_right,
BIN_OP_EQ_poly1305_h_l185_c10_9f3e_return_output);

-- BIN_OP_EQ_poly1305_h_l186_c9_1def : 0 clocks latency
BIN_OP_EQ_poly1305_h_l186_c9_1def : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l186_c9_1def_left,
BIN_OP_EQ_poly1305_h_l186_c9_1def_right,
BIN_OP_EQ_poly1305_h_l186_c9_1def_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_05aa : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_05aa : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_05aa_left,
BIN_OP_AND_poly1305_h_l185_c10_05aa_right,
BIN_OP_AND_poly1305_h_l185_c10_05aa_return_output);

-- BIN_OP_GTE_poly1305_h_l187_c9_113c : 0 clocks latency
BIN_OP_GTE_poly1305_h_l187_c9_113c : entity work.BIN_OP_GTE_uint64_t_uint64_t_0CLK_6f2c5aad port map (
BIN_OP_GTE_poly1305_h_l187_c9_113c_left,
BIN_OP_GTE_poly1305_h_l187_c9_113c_right,
BIN_OP_GTE_poly1305_h_l187_c9_113c_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_11e0 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_11e0 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_11e0_left,
BIN_OP_AND_poly1305_h_l185_c10_11e0_right,
BIN_OP_AND_poly1305_h_l185_c10_11e0_return_output);

-- a_limbs_1_MUX_poly1305_h_l185_c5_dc28 : 0 clocks latency
a_limbs_1_MUX_poly1305_h_l185_c5_dc28 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_1_MUX_poly1305_h_l185_c5_dc28_cond,
a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iftrue,
a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iffalse,
a_limbs_1_MUX_poly1305_h_l185_c5_dc28_return_output);

-- a_limbs_2_MUX_poly1305_h_l185_c5_dc28 : 0 clocks latency
a_limbs_2_MUX_poly1305_h_l185_c5_dc28 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_2_MUX_poly1305_h_l185_c5_dc28_cond,
a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iftrue,
a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iffalse,
a_limbs_2_MUX_poly1305_h_l185_c5_dc28_return_output);

-- a_limbs_0_MUX_poly1305_h_l185_c5_dc28 : 0 clocks latency
a_limbs_0_MUX_poly1305_h_l185_c5_dc28 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_0_MUX_poly1305_h_l185_c5_dc28_cond,
a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iftrue,
a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iffalse,
a_limbs_0_MUX_poly1305_h_l185_c5_dc28_return_output);

-- BIN_OP_MINUS_poly1305_h_l194_c16_b166 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l194_c16_b166 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l194_c16_b166_left,
BIN_OP_MINUS_poly1305_h_l194_c16_b166_right,
BIN_OP_MINUS_poly1305_h_l194_c16_b166_return_output);

-- BIN_OP_GT_poly1305_h_l195_c19_6265 : 0 clocks latency
BIN_OP_GT_poly1305_h_l195_c19_6265 : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l195_c19_6265_left,
BIN_OP_GT_poly1305_h_l195_c19_6265_right,
BIN_OP_GT_poly1305_h_l195_c19_6265_return_output);

-- MUX_poly1305_h_l195_c19_1387 : 0 clocks latency
MUX_poly1305_h_l195_c19_1387 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
MUX_poly1305_h_l195_c19_1387_cond,
MUX_poly1305_h_l195_c19_1387_iftrue,
MUX_poly1305_h_l195_c19_1387_iffalse,
MUX_poly1305_h_l195_c19_1387_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_4732 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_4732 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_4732_left,
BIN_OP_MINUS_poly1305_h_l198_c16_4732_right,
BIN_OP_MINUS_poly1305_h_l198_c16_4732_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_0c7c : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_0c7c : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_left,
BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_right,
BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_return_output);

-- BIN_OP_GT_poly1305_h_l199_c19_e013 : 0 clocks latency
BIN_OP_GT_poly1305_h_l199_c19_e013 : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l199_c19_e013_left,
BIN_OP_GT_poly1305_h_l199_c19_e013_right,
BIN_OP_GT_poly1305_h_l199_c19_e013_return_output);

-- BIN_OP_EQ_poly1305_h_l199_c42_bead : 0 clocks latency
BIN_OP_EQ_poly1305_h_l199_c42_bead : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l199_c42_bead_left,
BIN_OP_EQ_poly1305_h_l199_c42_bead_right,
BIN_OP_EQ_poly1305_h_l199_c42_bead_return_output);

-- BIN_OP_NEQ_poly1305_h_l199_c64_abb1 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l199_c64_abb1 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l199_c64_abb1_left,
BIN_OP_NEQ_poly1305_h_l199_c64_abb1_right,
BIN_OP_NEQ_poly1305_h_l199_c64_abb1_return_output);

-- BIN_OP_AND_poly1305_h_l199_c42_9f3a : 0 clocks latency
BIN_OP_AND_poly1305_h_l199_c42_9f3a : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l199_c42_9f3a_left,
BIN_OP_AND_poly1305_h_l199_c42_9f3a_right,
BIN_OP_AND_poly1305_h_l199_c42_9f3a_return_output);

-- BIN_OP_OR_poly1305_h_l199_c19_d605 : 0 clocks latency
BIN_OP_OR_poly1305_h_l199_c19_d605 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l199_c19_d605_left,
BIN_OP_OR_poly1305_h_l199_c19_d605_right,
BIN_OP_OR_poly1305_h_l199_c19_d605_return_output);

-- BIN_OP_MINUS_poly1305_h_l202_c9_f8f8 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l202_c9_f8f8 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_left,
BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_right,
BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_return_output);

-- BIN_OP_AND_poly1305_h_l203_c9_0ec2 : 0 clocks latency
BIN_OP_AND_poly1305_h_l203_c9_0ec2 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l203_c9_0ec2_left,
BIN_OP_AND_poly1305_h_l203_c9_0ec2_right,
BIN_OP_AND_poly1305_h_l203_c9_0ec2_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 a,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l164_c26_3676_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c9_48d5_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c22_2793_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_47f5_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c36_ce75_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_6092_return_output,
 a_MUX_poly1305_h_l165_c5_e122_return_output,
 BIN_OP_AND_poly1305_h_l170_c9_c640_return_output,
 CONST_SR_2_poly1305_h_l178_c26_14ee_return_output,
 BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_return_output,
 uint320_add_poly1305_h_l181_c13_dcab_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_a486_return_output,
 BIN_OP_EQ_poly1305_h_l185_c10_9f3e_return_output,
 BIN_OP_EQ_poly1305_h_l186_c9_1def_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_05aa_return_output,
 BIN_OP_GTE_poly1305_h_l187_c9_113c_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_11e0_return_output,
 a_limbs_1_MUX_poly1305_h_l185_c5_dc28_return_output,
 a_limbs_2_MUX_poly1305_h_l185_c5_dc28_return_output,
 a_limbs_0_MUX_poly1305_h_l185_c5_dc28_return_output,
 BIN_OP_MINUS_poly1305_h_l194_c16_b166_return_output,
 BIN_OP_GT_poly1305_h_l195_c19_6265_return_output,
 MUX_poly1305_h_l195_c19_1387_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_4732_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_return_output,
 BIN_OP_GT_poly1305_h_l199_c19_e013_return_output,
 BIN_OP_EQ_poly1305_h_l199_c42_bead_return_output,
 BIN_OP_NEQ_poly1305_h_l199_c64_abb1_return_output,
 BIN_OP_AND_poly1305_h_l199_c42_9f3a_return_output,
 BIN_OP_OR_poly1305_h_l199_c19_d605_return_output,
 BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_return_output,
 BIN_OP_AND_poly1305_h_l203_c9_0ec2_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u320_t;
 variable VAR_a : u320_t;
 variable VAR_mask : unsigned(63 downto 0);
 variable VAR_high_bits : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_48d5_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_48d5_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_48d5_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_47f5_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_fc83_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_2793_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_2793_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_2793_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_47f5_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_47f5_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_6092_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_3f32_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ce75_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ce75_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ce75_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_6092_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_6092_return_output : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_h_l165_c5_e122_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_e122_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_e122_return_output : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_e122_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_c640_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_c640_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_c640_return_output : unsigned(63 downto 0);
 variable VAR_mul5 : u320_t;
 variable VAR_mul5_limbs_0_poly1305_h_l178_c9_18c5 : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_14ee_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_left : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_14ee_x : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_return_output : unsigned(66 downto 0);
 variable VAR_uint320_add_poly1305_h_l181_c13_dcab_a : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_dcab_b : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_4627_return_output : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_9839_return_output : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_dcab_return_output : u320_t;
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_a486_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_a486_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_a486_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_9f3e_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_9f3e_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_9f3e_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_05aa_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_1def_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_1def_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_1def_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_05aa_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_05aa_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_113c_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_113c_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_113c_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_return_output : unsigned(0 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_cond : unsigned(0 downto 0);
 variable VAR_borrow : unsigned(63 downto 0);
 variable VAR_diff : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_return_output : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_1387_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_6265_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_6265_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_6265_return_output : unsigned(0 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_1387_iftrue : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_1387_iffalse : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_1387_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4732_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4732_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4732_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_return_output : unsigned(63 downto 0);
 variable VAR_borrow_poly1305_h_l199_c9_f14c : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_e013_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_e013_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_e013_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_d605_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_bead_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_bead_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_bead_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_9f3a_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_abb1_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_abb1_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_abb1_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_9f3a_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_9f3a_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_d605_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_d605_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_0ec2_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_0ec2_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_0ec2_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_u320_t_u320_t_94d4_poly1305_h_l205_c12_01d6_return_output : u320_t;
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_4920_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_2d29_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_31a1_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_684f_return_output : unsigned(63 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_1def_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_113c_right := unsigned'(X"fffffffffffffffb");
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_right := unsigned'(X"fffffffffffffffb");
     VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_right := unsigned'(X"fffffc0000000000");
     VAR_BIN_OP_AND_poly1305_h_l203_c9_0ec2_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l185_c10_a486_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l170_c9_c640_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_9f3e_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_48d5_right := to_unsigned(0, 1);
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_right := to_unsigned(5, 3);
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4732_right := unsigned'(X"ffffffffffffffff");
     VAR_MUX_poly1305_h_l195_c19_1387_iftrue := to_unsigned(1, 64);
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ce75_right := to_unsigned(0, 1);
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_2793_right := to_unsigned(0, 1);
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_abb1_right := to_unsigned(0, 1);
     VAR_MUX_poly1305_h_l195_c19_1387_iffalse := to_unsigned(0, 64);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_a := a;

     -- Submodule level 0
     VAR_a_MUX_poly1305_h_l165_c5_e122_iffalse := VAR_a;
     -- CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d[poly1305_h_l165_c36_3f32] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_3f32_return_output := VAR_a.limbs(4);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_4920 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_4920_return_output := VAR_a.limbs(2);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d[poly1305_h_l165_c22_fc83] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_fc83_return_output := VAR_a.limbs(3);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_4920_return_output;
     VAR_BIN_OP_AND_poly1305_h_l170_c9_c640_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_4920_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_2793_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_fc83_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ce75_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_3f32_return_output;
     -- BIN_OP_AND[poly1305_h_l164_c26_3676] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l164_c26_3676_left <= VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_left;
     BIN_OP_AND_poly1305_h_l164_c26_3676_right <= VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_return_output := BIN_OP_AND_poly1305_h_l164_c26_3676_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c22_2793] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c22_2793_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_2793_left;
     BIN_OP_NEQ_poly1305_h_l165_c22_2793_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_2793_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_2793_return_output := BIN_OP_NEQ_poly1305_h_l165_c22_2793_return_output;

     -- BIN_OP_AND[poly1305_h_l170_c9_c640] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l170_c9_c640_left <= VAR_BIN_OP_AND_poly1305_h_l170_c9_c640_left;
     BIN_OP_AND_poly1305_h_l170_c9_c640_right <= VAR_BIN_OP_AND_poly1305_h_l170_c9_c640_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l170_c9_c640_return_output := BIN_OP_AND_poly1305_h_l170_c9_c640_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c36_ce75] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c36_ce75_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ce75_left;
     BIN_OP_NEQ_poly1305_h_l165_c36_ce75_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ce75_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ce75_return_output := BIN_OP_NEQ_poly1305_h_l165_c36_ce75_return_output;

     -- Submodule level 2
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_48d5_left := VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_return_output;
     VAR_CONST_SR_2_poly1305_h_l178_c26_14ee_x := VAR_BIN_OP_AND_poly1305_h_l164_c26_3676_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_47f5_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c22_2793_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_6092_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c36_ce75_return_output;
     -- CONST_SR_2[poly1305_h_l178_c26_14ee] LATENCY=0
     -- Inputs
     CONST_SR_2_poly1305_h_l178_c26_14ee_x <= VAR_CONST_SR_2_poly1305_h_l178_c26_14ee_x;
     -- Outputs
     VAR_CONST_SR_2_poly1305_h_l178_c26_14ee_return_output := CONST_SR_2_poly1305_h_l178_c26_14ee_return_output;

     -- CONST_REF_RD_u320_t_u320_t_57df[poly1305_h_l181_c25_4627] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_4627_return_output := CONST_REF_RD_u320_t_u320_t_57df(
     VAR_a,
     VAR_BIN_OP_AND_poly1305_h_l170_c9_c640_return_output,
     to_unsigned(0, 64),
     to_unsigned(0, 64));

     -- BIN_OP_NEQ[poly1305_h_l165_c9_48d5] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c9_48d5_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_48d5_left;
     BIN_OP_NEQ_poly1305_h_l165_c9_48d5_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_48d5_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_48d5_return_output := BIN_OP_NEQ_poly1305_h_l165_c9_48d5_return_output;

     -- Submodule level 3
     VAR_BIN_OP_OR_poly1305_h_l165_c9_47f5_left := VAR_BIN_OP_NEQ_poly1305_h_l165_c9_48d5_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_dcab_a := VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_4627_return_output;
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_left := VAR_CONST_SR_2_poly1305_h_l178_c26_14ee_return_output;
     -- BIN_OP_OR[poly1305_h_l165_c9_47f5] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_47f5_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_47f5_left;
     BIN_OP_OR_poly1305_h_l165_c9_47f5_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_47f5_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_47f5_return_output := BIN_OP_OR_poly1305_h_l165_c9_47f5_return_output;

     -- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_fbe3] LATENCY=0
     -- Inputs
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_left <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_left;
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_right <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_right;
     -- Outputs
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_return_output := BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_return_output;

     -- Submodule level 4
     VAR_mul5_limbs_0_poly1305_h_l178_c9_18c5 := resize(VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fbe3_return_output, 64);
     VAR_BIN_OP_OR_poly1305_h_l165_c9_6092_left := VAR_BIN_OP_OR_poly1305_h_l165_c9_47f5_return_output;
     -- BIN_OP_OR[poly1305_h_l165_c9_6092] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_6092_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_6092_left;
     BIN_OP_OR_poly1305_h_l165_c9_6092_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_6092_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_6092_return_output := BIN_OP_OR_poly1305_h_l165_c9_6092_return_output;

     -- CONST_REF_RD_u320_t_u320_t_853a[poly1305_h_l181_c28_9839] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_9839_return_output := CONST_REF_RD_u320_t_u320_t_853a(
     u320_t_NULL,
     VAR_mul5_limbs_0_poly1305_h_l178_c9_18c5);

     -- Submodule level 5
     VAR_a_MUX_poly1305_h_l165_c5_e122_cond := VAR_BIN_OP_OR_poly1305_h_l165_c9_6092_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_dcab_b := VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_9839_return_output;
     -- uint320_add[poly1305_h_l181_c13_dcab] LATENCY=0
     -- Inputs
     uint320_add_poly1305_h_l181_c13_dcab_a <= VAR_uint320_add_poly1305_h_l181_c13_dcab_a;
     uint320_add_poly1305_h_l181_c13_dcab_b <= VAR_uint320_add_poly1305_h_l181_c13_dcab_b;
     -- Outputs
     VAR_uint320_add_poly1305_h_l181_c13_dcab_return_output := uint320_add_poly1305_h_l181_c13_dcab_return_output;

     -- Submodule level 6
     VAR_a_MUX_poly1305_h_l165_c5_e122_iftrue := VAR_uint320_add_poly1305_h_l181_c13_dcab_return_output;
     -- a_MUX[poly1305_h_l165_c5_e122] LATENCY=0
     -- Inputs
     a_MUX_poly1305_h_l165_c5_e122_cond <= VAR_a_MUX_poly1305_h_l165_c5_e122_cond;
     a_MUX_poly1305_h_l165_c5_e122_iftrue <= VAR_a_MUX_poly1305_h_l165_c5_e122_iftrue;
     a_MUX_poly1305_h_l165_c5_e122_iffalse <= VAR_a_MUX_poly1305_h_l165_c5_e122_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_h_l165_c5_e122_return_output := a_MUX_poly1305_h_l165_c5_e122_return_output;

     -- Submodule level 7
     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_2d29 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_2d29_return_output := VAR_a_MUX_poly1305_h_l165_c5_e122_return_output.limbs(2);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_31a1 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_31a1_return_output := VAR_a_MUX_poly1305_h_l165_c5_e122_return_output.limbs(1);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_684f LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_684f_return_output := VAR_a_MUX_poly1305_h_l165_c5_e122_return_output.limbs(0);

     -- Submodule level 8
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_113c_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_684f_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_6265_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_684f_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_684f_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l187_l195_l194_l185_DUPLICATE_684f_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_1def_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_31a1_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_bead_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_31a1_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_e013_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_31a1_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4732_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_31a1_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l199_l185_l186_l198_DUPLICATE_31a1_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_a486_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_2d29_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_2d29_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_2d29_return_output;
     -- BIN_OP_EQ[poly1305_h_l186_c9_1def] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l186_c9_1def_left <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_1def_left;
     BIN_OP_EQ_poly1305_h_l186_c9_1def_right <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_1def_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_1def_return_output := BIN_OP_EQ_poly1305_h_l186_c9_1def_return_output;

     -- BIN_OP_GTE[poly1305_h_l187_c9_113c] LATENCY=0
     -- Inputs
     BIN_OP_GTE_poly1305_h_l187_c9_113c_left <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_113c_left;
     BIN_OP_GTE_poly1305_h_l187_c9_113c_right <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_113c_right;
     -- Outputs
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_113c_return_output := BIN_OP_GTE_poly1305_h_l187_c9_113c_return_output;

     -- BIN_OP_MINUS[poly1305_h_l198_c16_4732] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_4732_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4732_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_4732_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4732_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4732_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_4732_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_a486] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_a486_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_a486_left;
     BIN_OP_AND_poly1305_h_l185_c10_a486_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_a486_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_a486_return_output := BIN_OP_AND_poly1305_h_l185_c10_a486_return_output;

     -- BIN_OP_MINUS[poly1305_h_l194_c16_b166] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l194_c16_b166_left <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_left;
     BIN_OP_MINUS_poly1305_h_l194_c16_b166_right <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_return_output := BIN_OP_MINUS_poly1305_h_l194_c16_b166_return_output;

     -- Submodule level 9
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_9f3e_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_a486_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_05aa_right := VAR_BIN_OP_EQ_poly1305_h_l186_c9_1def_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_right := VAR_BIN_OP_GTE_poly1305_h_l187_c9_113c_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_6265_left := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_b166_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4732_return_output;
     -- BIN_OP_GT[poly1305_h_l195_c19_6265] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l195_c19_6265_left <= VAR_BIN_OP_GT_poly1305_h_l195_c19_6265_left;
     BIN_OP_GT_poly1305_h_l195_c19_6265_right <= VAR_BIN_OP_GT_poly1305_h_l195_c19_6265_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l195_c19_6265_return_output := BIN_OP_GT_poly1305_h_l195_c19_6265_return_output;

     -- BIN_OP_EQ[poly1305_h_l185_c10_9f3e] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l185_c10_9f3e_left <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_9f3e_left;
     BIN_OP_EQ_poly1305_h_l185_c10_9f3e_right <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_9f3e_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_9f3e_return_output := BIN_OP_EQ_poly1305_h_l185_c10_9f3e_return_output;

     -- Submodule level 10
     VAR_BIN_OP_AND_poly1305_h_l185_c10_05aa_left := VAR_BIN_OP_EQ_poly1305_h_l185_c10_9f3e_return_output;
     VAR_MUX_poly1305_h_l195_c19_1387_cond := VAR_BIN_OP_GT_poly1305_h_l195_c19_6265_return_output;
     -- BIN_OP_AND[poly1305_h_l185_c10_05aa] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_05aa_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_05aa_left;
     BIN_OP_AND_poly1305_h_l185_c10_05aa_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_05aa_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_05aa_return_output := BIN_OP_AND_poly1305_h_l185_c10_05aa_return_output;

     -- MUX[poly1305_h_l195_c19_1387] LATENCY=0
     -- Inputs
     MUX_poly1305_h_l195_c19_1387_cond <= VAR_MUX_poly1305_h_l195_c19_1387_cond;
     MUX_poly1305_h_l195_c19_1387_iftrue <= VAR_MUX_poly1305_h_l195_c19_1387_iftrue;
     MUX_poly1305_h_l195_c19_1387_iffalse <= VAR_MUX_poly1305_h_l195_c19_1387_iffalse;
     -- Outputs
     VAR_MUX_poly1305_h_l195_c19_1387_return_output := MUX_poly1305_h_l195_c19_1387_return_output;

     -- Submodule level 11
     VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_05aa_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_right := VAR_MUX_poly1305_h_l195_c19_1387_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_abb1_left := VAR_MUX_poly1305_h_l195_c19_1387_return_output;
     -- BIN_OP_AND[poly1305_h_l185_c10_11e0] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_11e0_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_left;
     BIN_OP_AND_poly1305_h_l185_c10_11e0_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_return_output := BIN_OP_AND_poly1305_h_l185_c10_11e0_return_output;

     -- BIN_OP_NEQ[poly1305_h_l199_c64_abb1] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l199_c64_abb1_left <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_abb1_left;
     BIN_OP_NEQ_poly1305_h_l199_c64_abb1_right <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_abb1_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_abb1_return_output := BIN_OP_NEQ_poly1305_h_l199_c64_abb1_return_output;

     -- BIN_OP_MINUS[poly1305_h_l198_c16_0c7c] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_return_output;

     -- Submodule level 12
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_11e0_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_bead_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_e013_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_0c7c_return_output;
     VAR_BIN_OP_AND_poly1305_h_l199_c42_9f3a_right := VAR_BIN_OP_NEQ_poly1305_h_l199_c64_abb1_return_output;
     -- a_limbs_0_MUX[poly1305_h_l185_c5_dc28] LATENCY=0
     -- Inputs
     a_limbs_0_MUX_poly1305_h_l185_c5_dc28_cond <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_cond;
     a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iftrue <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iftrue;
     a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iffalse <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_iffalse;
     -- Outputs
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_return_output := a_limbs_0_MUX_poly1305_h_l185_c5_dc28_return_output;

     -- BIN_OP_GT[poly1305_h_l199_c19_e013] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l199_c19_e013_left <= VAR_BIN_OP_GT_poly1305_h_l199_c19_e013_left;
     BIN_OP_GT_poly1305_h_l199_c19_e013_right <= VAR_BIN_OP_GT_poly1305_h_l199_c19_e013_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l199_c19_e013_return_output := BIN_OP_GT_poly1305_h_l199_c19_e013_return_output;

     -- BIN_OP_EQ[poly1305_h_l199_c42_bead] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l199_c42_bead_left <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_bead_left;
     BIN_OP_EQ_poly1305_h_l199_c42_bead_right <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_bead_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_bead_return_output := BIN_OP_EQ_poly1305_h_l199_c42_bead_return_output;

     -- a_limbs_1_MUX[poly1305_h_l185_c5_dc28] LATENCY=0
     -- Inputs
     a_limbs_1_MUX_poly1305_h_l185_c5_dc28_cond <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_cond;
     a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iftrue <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iftrue;
     a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iffalse <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_iffalse;
     -- Outputs
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_return_output := a_limbs_1_MUX_poly1305_h_l185_c5_dc28_return_output;

     -- Submodule level 13
     VAR_BIN_OP_AND_poly1305_h_l199_c42_9f3a_left := VAR_BIN_OP_EQ_poly1305_h_l199_c42_bead_return_output;
     VAR_BIN_OP_OR_poly1305_h_l199_c19_d605_left := VAR_BIN_OP_GT_poly1305_h_l199_c19_e013_return_output;
     -- BIN_OP_AND[poly1305_h_l199_c42_9f3a] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l199_c42_9f3a_left <= VAR_BIN_OP_AND_poly1305_h_l199_c42_9f3a_left;
     BIN_OP_AND_poly1305_h_l199_c42_9f3a_right <= VAR_BIN_OP_AND_poly1305_h_l199_c42_9f3a_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l199_c42_9f3a_return_output := BIN_OP_AND_poly1305_h_l199_c42_9f3a_return_output;

     -- Submodule level 14
     VAR_BIN_OP_OR_poly1305_h_l199_c19_d605_right := VAR_BIN_OP_AND_poly1305_h_l199_c42_9f3a_return_output;
     -- BIN_OP_OR[poly1305_h_l199_c19_d605] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l199_c19_d605_left <= VAR_BIN_OP_OR_poly1305_h_l199_c19_d605_left;
     BIN_OP_OR_poly1305_h_l199_c19_d605_right <= VAR_BIN_OP_OR_poly1305_h_l199_c19_d605_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l199_c19_d605_return_output := BIN_OP_OR_poly1305_h_l199_c19_d605_return_output;

     -- Submodule level 15
     VAR_borrow_poly1305_h_l199_c9_f14c := resize(VAR_BIN_OP_OR_poly1305_h_l199_c19_d605_return_output, 64);
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_right := VAR_borrow_poly1305_h_l199_c9_f14c;
     -- BIN_OP_MINUS[poly1305_h_l202_c9_f8f8] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_left <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_left;
     BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_right <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_return_output := BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_return_output;

     -- Submodule level 16
     VAR_BIN_OP_AND_poly1305_h_l203_c9_0ec2_left := VAR_BIN_OP_MINUS_poly1305_h_l202_c9_f8f8_return_output;
     -- BIN_OP_AND[poly1305_h_l203_c9_0ec2] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l203_c9_0ec2_left <= VAR_BIN_OP_AND_poly1305_h_l203_c9_0ec2_left;
     BIN_OP_AND_poly1305_h_l203_c9_0ec2_right <= VAR_BIN_OP_AND_poly1305_h_l203_c9_0ec2_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l203_c9_0ec2_return_output := BIN_OP_AND_poly1305_h_l203_c9_0ec2_return_output;

     -- Submodule level 17
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iftrue := VAR_BIN_OP_AND_poly1305_h_l203_c9_0ec2_return_output;
     -- a_limbs_2_MUX[poly1305_h_l185_c5_dc28] LATENCY=0
     -- Inputs
     a_limbs_2_MUX_poly1305_h_l185_c5_dc28_cond <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_cond;
     a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iftrue <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iftrue;
     a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iffalse <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_iffalse;
     -- Outputs
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_return_output := a_limbs_2_MUX_poly1305_h_l185_c5_dc28_return_output;

     -- Submodule level 18
     -- CONST_REF_RD_u320_t_u320_t_94d4[poly1305_h_l205_c12_01d6] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_94d4_poly1305_h_l205_c12_01d6_return_output := CONST_REF_RD_u320_t_u320_t_94d4(
     VAR_a_MUX_poly1305_h_l165_c5_e122_return_output,
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_dc28_return_output,
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_dc28_return_output,
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_dc28_return_output);

     -- Submodule level 19
     VAR_return_output := VAR_CONST_REF_RD_u320_t_u320_t_94d4_poly1305_h_l205_c12_01d6_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
