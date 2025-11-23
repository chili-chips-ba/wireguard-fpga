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
-- BIN_OP_AND[poly1305_h_l164_c26_2883]
signal BIN_OP_AND_poly1305_h_l164_c26_2883_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_2883_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l164_c26_2883_return_output : unsigned(63 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c9_509b]
signal BIN_OP_NEQ_poly1305_h_l165_c9_509b_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_509b_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c9_509b_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c22_927f]
signal BIN_OP_NEQ_poly1305_h_l165_c22_927f_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_927f_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c22_927f_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_e4a3]
signal BIN_OP_OR_poly1305_h_l165_c9_e4a3_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_e4a3_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_e4a3_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l165_c36_a3d4]
signal BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l165_c9_4038]
signal BIN_OP_OR_poly1305_h_l165_c9_4038_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_4038_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l165_c9_4038_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_h_l165_c5_81e0]
signal a_MUX_poly1305_h_l165_c5_81e0_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_h_l165_c5_81e0_iftrue : u320_t;
signal a_MUX_poly1305_h_l165_c5_81e0_iffalse : u320_t;
signal a_MUX_poly1305_h_l165_c5_81e0_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l170_c9_61f6]
signal BIN_OP_AND_poly1305_h_l170_c9_61f6_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_61f6_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l170_c9_61f6_return_output : unsigned(63 downto 0);

-- CONST_SR_2[poly1305_h_l178_c26_1dd8]
signal CONST_SR_2_poly1305_h_l178_c26_1dd8_x : unsigned(63 downto 0);
signal CONST_SR_2_poly1305_h_l178_c26_1dd8_return_output : unsigned(63 downto 0);

-- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_fd45]
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_left : unsigned(63 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_right : unsigned(2 downto 0);
signal BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_return_output : unsigned(66 downto 0);

-- uint320_add[poly1305_h_l181_c13_740d]
signal uint320_add_poly1305_h_l181_c13_740d_a : u320_t;
signal uint320_add_poly1305_h_l181_c13_740d_b : u320_t;
signal uint320_add_poly1305_h_l181_c13_740d_return_output : u320_t;

-- BIN_OP_AND[poly1305_h_l185_c10_f226]
signal BIN_OP_AND_poly1305_h_l185_c10_f226_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_f226_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_f226_return_output : unsigned(63 downto 0);

-- BIN_OP_EQ[poly1305_h_l185_c10_2909]
signal BIN_OP_EQ_poly1305_h_l185_c10_2909_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_2909_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l185_c10_2909_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l186_c9_6235]
signal BIN_OP_EQ_poly1305_h_l186_c9_6235_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_6235_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l186_c9_6235_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_bc61]
signal BIN_OP_AND_poly1305_h_l185_c10_bc61_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_bc61_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_bc61_return_output : unsigned(0 downto 0);

-- BIN_OP_GTE[poly1305_h_l187_c9_c714]
signal BIN_OP_GTE_poly1305_h_l187_c9_c714_left : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_c714_right : unsigned(63 downto 0);
signal BIN_OP_GTE_poly1305_h_l187_c9_c714_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l185_c10_a8b1]
signal BIN_OP_AND_poly1305_h_l185_c10_a8b1_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_a8b1_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l185_c10_a8b1_return_output : unsigned(0 downto 0);

-- a_limbs_0_MUX[poly1305_h_l185_c5_4a4f]
signal a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_cond : unsigned(0 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iftrue : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iffalse : unsigned(63 downto 0);
signal a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_return_output : unsigned(63 downto 0);

-- a_limbs_1_MUX[poly1305_h_l185_c5_4a4f]
signal a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_cond : unsigned(0 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iftrue : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iffalse : unsigned(63 downto 0);
signal a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_return_output : unsigned(63 downto 0);

-- a_limbs_2_MUX[poly1305_h_l185_c5_4a4f]
signal a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_cond : unsigned(0 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iftrue : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iffalse : unsigned(63 downto 0);
signal a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l194_c16_34ef]
signal BIN_OP_MINUS_poly1305_h_l194_c16_34ef_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_34ef_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l194_c16_34ef_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l195_c19_366c]
signal BIN_OP_GT_poly1305_h_l195_c19_366c_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_366c_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l195_c19_366c_return_output : unsigned(0 downto 0);

-- MUX[poly1305_h_l195_c19_8911]
signal MUX_poly1305_h_l195_c19_8911_cond : unsigned(0 downto 0);
signal MUX_poly1305_h_l195_c19_8911_iftrue : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_8911_iffalse : unsigned(63 downto 0);
signal MUX_poly1305_h_l195_c19_8911_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_4449]
signal BIN_OP_MINUS_poly1305_h_l198_c16_4449_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_4449_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_4449_return_output : unsigned(63 downto 0);

-- BIN_OP_MINUS[poly1305_h_l198_c16_b406]
signal BIN_OP_MINUS_poly1305_h_l198_c16_b406_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_b406_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l198_c16_b406_return_output : unsigned(63 downto 0);

-- BIN_OP_GT[poly1305_h_l199_c19_0a02]
signal BIN_OP_GT_poly1305_h_l199_c19_0a02_left : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_0a02_right : unsigned(63 downto 0);
signal BIN_OP_GT_poly1305_h_l199_c19_0a02_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[poly1305_h_l199_c42_eded]
signal BIN_OP_EQ_poly1305_h_l199_c42_eded_left : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_eded_right : unsigned(63 downto 0);
signal BIN_OP_EQ_poly1305_h_l199_c42_eded_return_output : unsigned(0 downto 0);

-- BIN_OP_NEQ[poly1305_h_l199_c64_bedf]
signal BIN_OP_NEQ_poly1305_h_l199_c64_bedf_left : unsigned(63 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_bedf_right : unsigned(0 downto 0);
signal BIN_OP_NEQ_poly1305_h_l199_c64_bedf_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_h_l199_c42_7332]
signal BIN_OP_AND_poly1305_h_l199_c42_7332_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_7332_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_h_l199_c42_7332_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[poly1305_h_l199_c19_427c]
signal BIN_OP_OR_poly1305_h_l199_c19_427c_left : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_427c_right : unsigned(0 downto 0);
signal BIN_OP_OR_poly1305_h_l199_c19_427c_return_output : unsigned(0 downto 0);

-- BIN_OP_MINUS[poly1305_h_l202_c9_2474]
signal BIN_OP_MINUS_poly1305_h_l202_c9_2474_left : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_2474_right : unsigned(63 downto 0);
signal BIN_OP_MINUS_poly1305_h_l202_c9_2474_return_output : unsigned(63 downto 0);

-- BIN_OP_AND[poly1305_h_l203_c9_1ee6]
signal BIN_OP_AND_poly1305_h_l203_c9_1ee6_left : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_1ee6_right : unsigned(63 downto 0);
signal BIN_OP_AND_poly1305_h_l203_c9_1ee6_return_output : unsigned(63 downto 0);

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
-- BIN_OP_AND_poly1305_h_l164_c26_2883 : 0 clocks latency
BIN_OP_AND_poly1305_h_l164_c26_2883 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l164_c26_2883_left,
BIN_OP_AND_poly1305_h_l164_c26_2883_right,
BIN_OP_AND_poly1305_h_l164_c26_2883_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c9_509b : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c9_509b : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c9_509b_left,
BIN_OP_NEQ_poly1305_h_l165_c9_509b_right,
BIN_OP_NEQ_poly1305_h_l165_c9_509b_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c22_927f : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c22_927f : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c22_927f_left,
BIN_OP_NEQ_poly1305_h_l165_c22_927f_right,
BIN_OP_NEQ_poly1305_h_l165_c22_927f_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_e4a3 : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_e4a3 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_e4a3_left,
BIN_OP_OR_poly1305_h_l165_c9_e4a3_right,
BIN_OP_OR_poly1305_h_l165_c9_e4a3_return_output);

-- BIN_OP_NEQ_poly1305_h_l165_c36_a3d4 : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l165_c36_a3d4 : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_left,
BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_right,
BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_return_output);

-- BIN_OP_OR_poly1305_h_l165_c9_4038 : 0 clocks latency
BIN_OP_OR_poly1305_h_l165_c9_4038 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l165_c9_4038_left,
BIN_OP_OR_poly1305_h_l165_c9_4038_right,
BIN_OP_OR_poly1305_h_l165_c9_4038_return_output);

-- a_MUX_poly1305_h_l165_c5_81e0 : 0 clocks latency
a_MUX_poly1305_h_l165_c5_81e0 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_h_l165_c5_81e0_cond,
a_MUX_poly1305_h_l165_c5_81e0_iftrue,
a_MUX_poly1305_h_l165_c5_81e0_iffalse,
a_MUX_poly1305_h_l165_c5_81e0_return_output);

-- BIN_OP_AND_poly1305_h_l170_c9_61f6 : 0 clocks latency
BIN_OP_AND_poly1305_h_l170_c9_61f6 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l170_c9_61f6_left,
BIN_OP_AND_poly1305_h_l170_c9_61f6_right,
BIN_OP_AND_poly1305_h_l170_c9_61f6_return_output);

-- CONST_SR_2_poly1305_h_l178_c26_1dd8 : 0 clocks latency
CONST_SR_2_poly1305_h_l178_c26_1dd8 : entity work.CONST_SR_2_uint64_t_0CLK_de264c78 port map (
CONST_SR_2_poly1305_h_l178_c26_1dd8_x,
CONST_SR_2_poly1305_h_l178_c26_1dd8_return_output);

-- BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45 : 0 clocks latency
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45 : entity work.BIN_OP_INFERRED_MULT_uint64_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_left,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_right,
BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_return_output);

-- uint320_add_poly1305_h_l181_c13_740d : 0 clocks latency
uint320_add_poly1305_h_l181_c13_740d : entity work.uint320_add_0CLK_10d8c973 port map (
uint320_add_poly1305_h_l181_c13_740d_a,
uint320_add_poly1305_h_l181_c13_740d_b,
uint320_add_poly1305_h_l181_c13_740d_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_f226 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_f226 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_f226_left,
BIN_OP_AND_poly1305_h_l185_c10_f226_right,
BIN_OP_AND_poly1305_h_l185_c10_f226_return_output);

-- BIN_OP_EQ_poly1305_h_l185_c10_2909 : 0 clocks latency
BIN_OP_EQ_poly1305_h_l185_c10_2909 : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l185_c10_2909_left,
BIN_OP_EQ_poly1305_h_l185_c10_2909_right,
BIN_OP_EQ_poly1305_h_l185_c10_2909_return_output);

-- BIN_OP_EQ_poly1305_h_l186_c9_6235 : 0 clocks latency
BIN_OP_EQ_poly1305_h_l186_c9_6235 : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l186_c9_6235_left,
BIN_OP_EQ_poly1305_h_l186_c9_6235_right,
BIN_OP_EQ_poly1305_h_l186_c9_6235_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_bc61 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_bc61 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_bc61_left,
BIN_OP_AND_poly1305_h_l185_c10_bc61_right,
BIN_OP_AND_poly1305_h_l185_c10_bc61_return_output);

-- BIN_OP_GTE_poly1305_h_l187_c9_c714 : 0 clocks latency
BIN_OP_GTE_poly1305_h_l187_c9_c714 : entity work.BIN_OP_GTE_uint64_t_uint64_t_0CLK_6f2c5aad port map (
BIN_OP_GTE_poly1305_h_l187_c9_c714_left,
BIN_OP_GTE_poly1305_h_l187_c9_c714_right,
BIN_OP_GTE_poly1305_h_l187_c9_c714_return_output);

-- BIN_OP_AND_poly1305_h_l185_c10_a8b1 : 0 clocks latency
BIN_OP_AND_poly1305_h_l185_c10_a8b1 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l185_c10_a8b1_left,
BIN_OP_AND_poly1305_h_l185_c10_a8b1_right,
BIN_OP_AND_poly1305_h_l185_c10_a8b1_return_output);

-- a_limbs_0_MUX_poly1305_h_l185_c5_4a4f : 0 clocks latency
a_limbs_0_MUX_poly1305_h_l185_c5_4a4f : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_cond,
a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iftrue,
a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iffalse,
a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_return_output);

-- a_limbs_1_MUX_poly1305_h_l185_c5_4a4f : 0 clocks latency
a_limbs_1_MUX_poly1305_h_l185_c5_4a4f : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_cond,
a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iftrue,
a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iffalse,
a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_return_output);

-- a_limbs_2_MUX_poly1305_h_l185_c5_4a4f : 0 clocks latency
a_limbs_2_MUX_poly1305_h_l185_c5_4a4f : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_cond,
a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iftrue,
a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iffalse,
a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_return_output);

-- BIN_OP_MINUS_poly1305_h_l194_c16_34ef : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l194_c16_34ef : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l194_c16_34ef_left,
BIN_OP_MINUS_poly1305_h_l194_c16_34ef_right,
BIN_OP_MINUS_poly1305_h_l194_c16_34ef_return_output);

-- BIN_OP_GT_poly1305_h_l195_c19_366c : 0 clocks latency
BIN_OP_GT_poly1305_h_l195_c19_366c : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l195_c19_366c_left,
BIN_OP_GT_poly1305_h_l195_c19_366c_right,
BIN_OP_GT_poly1305_h_l195_c19_366c_return_output);

-- MUX_poly1305_h_l195_c19_8911 : 0 clocks latency
MUX_poly1305_h_l195_c19_8911 : entity work.MUX_uint1_t_uint64_t_uint64_t_0CLK_de264c78 port map (
MUX_poly1305_h_l195_c19_8911_cond,
MUX_poly1305_h_l195_c19_8911_iftrue,
MUX_poly1305_h_l195_c19_8911_iffalse,
MUX_poly1305_h_l195_c19_8911_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_4449 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_4449 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_4449_left,
BIN_OP_MINUS_poly1305_h_l198_c16_4449_right,
BIN_OP_MINUS_poly1305_h_l198_c16_4449_return_output);

-- BIN_OP_MINUS_poly1305_h_l198_c16_b406 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l198_c16_b406 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l198_c16_b406_left,
BIN_OP_MINUS_poly1305_h_l198_c16_b406_right,
BIN_OP_MINUS_poly1305_h_l198_c16_b406_return_output);

-- BIN_OP_GT_poly1305_h_l199_c19_0a02 : 0 clocks latency
BIN_OP_GT_poly1305_h_l199_c19_0a02 : entity work.BIN_OP_GT_uint64_t_uint64_t_0CLK_380ecc95 port map (
BIN_OP_GT_poly1305_h_l199_c19_0a02_left,
BIN_OP_GT_poly1305_h_l199_c19_0a02_right,
BIN_OP_GT_poly1305_h_l199_c19_0a02_return_output);

-- BIN_OP_EQ_poly1305_h_l199_c42_eded : 0 clocks latency
BIN_OP_EQ_poly1305_h_l199_c42_eded : entity work.BIN_OP_EQ_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_h_l199_c42_eded_left,
BIN_OP_EQ_poly1305_h_l199_c42_eded_right,
BIN_OP_EQ_poly1305_h_l199_c42_eded_return_output);

-- BIN_OP_NEQ_poly1305_h_l199_c64_bedf : 0 clocks latency
BIN_OP_NEQ_poly1305_h_l199_c64_bedf : entity work.BIN_OP_NEQ_uint64_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_NEQ_poly1305_h_l199_c64_bedf_left,
BIN_OP_NEQ_poly1305_h_l199_c64_bedf_right,
BIN_OP_NEQ_poly1305_h_l199_c64_bedf_return_output);

-- BIN_OP_AND_poly1305_h_l199_c42_7332 : 0 clocks latency
BIN_OP_AND_poly1305_h_l199_c42_7332 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l199_c42_7332_left,
BIN_OP_AND_poly1305_h_l199_c42_7332_right,
BIN_OP_AND_poly1305_h_l199_c42_7332_return_output);

-- BIN_OP_OR_poly1305_h_l199_c19_427c : 0 clocks latency
BIN_OP_OR_poly1305_h_l199_c19_427c : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l199_c19_427c_left,
BIN_OP_OR_poly1305_h_l199_c19_427c_right,
BIN_OP_OR_poly1305_h_l199_c19_427c_return_output);

-- BIN_OP_MINUS_poly1305_h_l202_c9_2474 : 0 clocks latency
BIN_OP_MINUS_poly1305_h_l202_c9_2474 : entity work.BIN_OP_MINUS_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_MINUS_poly1305_h_l202_c9_2474_left,
BIN_OP_MINUS_poly1305_h_l202_c9_2474_right,
BIN_OP_MINUS_poly1305_h_l202_c9_2474_return_output);

-- BIN_OP_AND_poly1305_h_l203_c9_1ee6 : 0 clocks latency
BIN_OP_AND_poly1305_h_l203_c9_1ee6 : entity work.BIN_OP_AND_uint64_t_uint64_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l203_c9_1ee6_left,
BIN_OP_AND_poly1305_h_l203_c9_1ee6_right,
BIN_OP_AND_poly1305_h_l203_c9_1ee6_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 a,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l164_c26_2883_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c9_509b_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c22_927f_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_e4a3_return_output,
 BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_return_output,
 BIN_OP_OR_poly1305_h_l165_c9_4038_return_output,
 a_MUX_poly1305_h_l165_c5_81e0_return_output,
 BIN_OP_AND_poly1305_h_l170_c9_61f6_return_output,
 CONST_SR_2_poly1305_h_l178_c26_1dd8_return_output,
 BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_return_output,
 uint320_add_poly1305_h_l181_c13_740d_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_f226_return_output,
 BIN_OP_EQ_poly1305_h_l185_c10_2909_return_output,
 BIN_OP_EQ_poly1305_h_l186_c9_6235_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_bc61_return_output,
 BIN_OP_GTE_poly1305_h_l187_c9_c714_return_output,
 BIN_OP_AND_poly1305_h_l185_c10_a8b1_return_output,
 a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_return_output,
 a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_return_output,
 a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_return_output,
 BIN_OP_MINUS_poly1305_h_l194_c16_34ef_return_output,
 BIN_OP_GT_poly1305_h_l195_c19_366c_return_output,
 MUX_poly1305_h_l195_c19_8911_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_4449_return_output,
 BIN_OP_MINUS_poly1305_h_l198_c16_b406_return_output,
 BIN_OP_GT_poly1305_h_l199_c19_0a02_return_output,
 BIN_OP_EQ_poly1305_h_l199_c42_eded_return_output,
 BIN_OP_NEQ_poly1305_h_l199_c64_bedf_return_output,
 BIN_OP_AND_poly1305_h_l199_c42_7332_return_output,
 BIN_OP_OR_poly1305_h_l199_c19_427c_return_output,
 BIN_OP_MINUS_poly1305_h_l202_c9_2474_return_output,
 BIN_OP_AND_poly1305_h_l203_c9_1ee6_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u320_t;
 variable VAR_a : u320_t;
 variable VAR_mask : unsigned(63 downto 0);
 variable VAR_high_bits : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_509b_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_509b_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c9_509b_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_e4a3_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_206f_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_927f_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_927f_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c22_927f_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_e4a3_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_e4a3_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_4038_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_4403_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_4038_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l165_c9_4038_return_output : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_h_l165_c5_81e0_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_81e0_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_81e0_return_output : u320_t;
 variable VAR_a_MUX_poly1305_h_l165_c5_81e0_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_61f6_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_61f6_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l170_c9_61f6_return_output : unsigned(63 downto 0);
 variable VAR_mul5 : u320_t;
 variable VAR_mul5_limbs_0_poly1305_h_l178_c9_1f38 : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_1dd8_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_left : unsigned(63 downto 0);
 variable VAR_CONST_SR_2_poly1305_h_l178_c26_1dd8_x : unsigned(63 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_return_output : unsigned(66 downto 0);
 variable VAR_uint320_add_poly1305_h_l181_c13_740d_a : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_740d_b : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_b3d8_return_output : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_ba1e_return_output : u320_t;
 variable VAR_uint320_add_poly1305_h_l181_c13_740d_return_output : u320_t;
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_f226_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_f226_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_f226_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_2909_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_2909_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l185_c10_2909_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_bc61_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_6235_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_6235_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l186_c9_6235_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_bc61_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_bc61_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_c714_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_c714_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GTE_poly1305_h_l187_c9_c714_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_return_output : unsigned(0 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_cond : unsigned(0 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iftrue : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iffalse : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_return_output : unsigned(63 downto 0);
 variable VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_cond : unsigned(0 downto 0);
 variable VAR_borrow : unsigned(63 downto 0);
 variable VAR_diff : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_return_output : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_8911_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_366c_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_366c_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l195_c19_366c_return_output : unsigned(0 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_8911_iftrue : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_8911_iffalse : unsigned(63 downto 0);
 variable VAR_MUX_poly1305_h_l195_c19_8911_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4449_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4449_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4449_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_return_output : unsigned(63 downto 0);
 variable VAR_borrow_poly1305_h_l199_c9_bff7 : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_0a02_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_0a02_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_GT_poly1305_h_l199_c19_0a02_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_427c_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_eded_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_eded_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_h_l199_c42_eded_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_7332_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_bedf_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_bedf_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_NEQ_poly1305_h_l199_c64_bedf_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_7332_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l199_c42_7332_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_427c_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l199_c19_427c_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_2474_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_2474_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_MINUS_poly1305_h_l202_c9_2474_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_1ee6_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_1ee6_right : unsigned(63 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l203_c9_1ee6_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_06be_return_output : u320_t;
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_40cb_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_e351_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l198_l186_l199_l185_DUPLICATE_baf7_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l194_l185_l195_l187_DUPLICATE_ef5b_return_output : unsigned(63 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_right := to_unsigned(5, 3);
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_509b_right := to_unsigned(0, 1);
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_927f_right := to_unsigned(0, 1);
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_bedf_right := to_unsigned(0, 1);
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4449_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_right := unsigned'(X"fffffc0000000000");
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_c714_right := unsigned'(X"fffffffffffffffb");
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_right := to_unsigned(0, 1);
     VAR_MUX_poly1305_h_l195_c19_8911_iftrue := to_unsigned(1, 64);
     VAR_MUX_poly1305_h_l195_c19_8911_iffalse := to_unsigned(0, 64);
     VAR_BIN_OP_AND_poly1305_h_l185_c10_f226_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_2909_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l203_c9_1ee6_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_AND_poly1305_h_l170_c9_61f6_right := resize(unsigned'(X"3ffffffffff"), 64);
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_6235_right := unsigned'(X"ffffffffffffffff");
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_right := unsigned'(X"fffffffffffffffb");

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_a := a;

     -- Submodule level 0
     VAR_a_MUX_poly1305_h_l165_c5_81e0_iffalse := VAR_a;
     -- CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d[poly1305_h_l165_c22_206f] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_206f_return_output := VAR_a.limbs(3);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d[poly1305_h_l165_c36_4403] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_4403_return_output := VAR_a.limbs(4);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_40cb LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_40cb_return_output := VAR_a.limbs(2);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_40cb_return_output;
     VAR_BIN_OP_AND_poly1305_h_l170_c9_61f6_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l164_l170_DUPLICATE_40cb_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_927f_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_3_d41d_poly1305_h_l165_c22_206f_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_4_d41d_poly1305_h_l165_c36_4403_return_output;
     -- BIN_OP_AND[poly1305_h_l170_c9_61f6] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l170_c9_61f6_left <= VAR_BIN_OP_AND_poly1305_h_l170_c9_61f6_left;
     BIN_OP_AND_poly1305_h_l170_c9_61f6_right <= VAR_BIN_OP_AND_poly1305_h_l170_c9_61f6_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l170_c9_61f6_return_output := BIN_OP_AND_poly1305_h_l170_c9_61f6_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c36_a3d4] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_left;
     BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_return_output := BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_return_output;

     -- BIN_OP_AND[poly1305_h_l164_c26_2883] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l164_c26_2883_left <= VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_left;
     BIN_OP_AND_poly1305_h_l164_c26_2883_right <= VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_return_output := BIN_OP_AND_poly1305_h_l164_c26_2883_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c22_927f] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c22_927f_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_927f_left;
     BIN_OP_NEQ_poly1305_h_l165_c22_927f_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c22_927f_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c22_927f_return_output := BIN_OP_NEQ_poly1305_h_l165_c22_927f_return_output;

     -- Submodule level 2
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_509b_left := VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_return_output;
     VAR_CONST_SR_2_poly1305_h_l178_c26_1dd8_x := VAR_BIN_OP_AND_poly1305_h_l164_c26_2883_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_e4a3_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c22_927f_return_output;
     VAR_BIN_OP_OR_poly1305_h_l165_c9_4038_right := VAR_BIN_OP_NEQ_poly1305_h_l165_c36_a3d4_return_output;
     -- CONST_REF_RD_u320_t_u320_t_57df[poly1305_h_l181_c25_b3d8] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_b3d8_return_output := CONST_REF_RD_u320_t_u320_t_57df(
     VAR_a,
     VAR_BIN_OP_AND_poly1305_h_l170_c9_61f6_return_output,
     to_unsigned(0, 64),
     to_unsigned(0, 64));

     -- CONST_SR_2[poly1305_h_l178_c26_1dd8] LATENCY=0
     -- Inputs
     CONST_SR_2_poly1305_h_l178_c26_1dd8_x <= VAR_CONST_SR_2_poly1305_h_l178_c26_1dd8_x;
     -- Outputs
     VAR_CONST_SR_2_poly1305_h_l178_c26_1dd8_return_output := CONST_SR_2_poly1305_h_l178_c26_1dd8_return_output;

     -- BIN_OP_NEQ[poly1305_h_l165_c9_509b] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l165_c9_509b_left <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_509b_left;
     BIN_OP_NEQ_poly1305_h_l165_c9_509b_right <= VAR_BIN_OP_NEQ_poly1305_h_l165_c9_509b_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l165_c9_509b_return_output := BIN_OP_NEQ_poly1305_h_l165_c9_509b_return_output;

     -- Submodule level 3
     VAR_BIN_OP_OR_poly1305_h_l165_c9_e4a3_left := VAR_BIN_OP_NEQ_poly1305_h_l165_c9_509b_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_740d_a := VAR_CONST_REF_RD_u320_t_u320_t_57df_poly1305_h_l181_c25_b3d8_return_output;
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_left := VAR_CONST_SR_2_poly1305_h_l178_c26_1dd8_return_output;
     -- BIN_OP_INFERRED_MULT[poly1305_h_l178_c26_fd45] LATENCY=0
     -- Inputs
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_left <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_left;
     BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_right <= VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_right;
     -- Outputs
     VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_return_output := BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_return_output;

     -- BIN_OP_OR[poly1305_h_l165_c9_e4a3] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_e4a3_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_e4a3_left;
     BIN_OP_OR_poly1305_h_l165_c9_e4a3_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_e4a3_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_e4a3_return_output := BIN_OP_OR_poly1305_h_l165_c9_e4a3_return_output;

     -- Submodule level 4
     VAR_mul5_limbs_0_poly1305_h_l178_c9_1f38 := resize(VAR_BIN_OP_INFERRED_MULT_poly1305_h_l178_c26_fd45_return_output, 64);
     VAR_BIN_OP_OR_poly1305_h_l165_c9_4038_left := VAR_BIN_OP_OR_poly1305_h_l165_c9_e4a3_return_output;
     -- BIN_OP_OR[poly1305_h_l165_c9_4038] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l165_c9_4038_left <= VAR_BIN_OP_OR_poly1305_h_l165_c9_4038_left;
     BIN_OP_OR_poly1305_h_l165_c9_4038_right <= VAR_BIN_OP_OR_poly1305_h_l165_c9_4038_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l165_c9_4038_return_output := BIN_OP_OR_poly1305_h_l165_c9_4038_return_output;

     -- CONST_REF_RD_u320_t_u320_t_853a[poly1305_h_l181_c28_ba1e] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_ba1e_return_output := CONST_REF_RD_u320_t_u320_t_853a(
     u320_t_NULL,
     VAR_mul5_limbs_0_poly1305_h_l178_c9_1f38);

     -- Submodule level 5
     VAR_a_MUX_poly1305_h_l165_c5_81e0_cond := VAR_BIN_OP_OR_poly1305_h_l165_c9_4038_return_output;
     VAR_uint320_add_poly1305_h_l181_c13_740d_b := VAR_CONST_REF_RD_u320_t_u320_t_853a_poly1305_h_l181_c28_ba1e_return_output;
     -- uint320_add[poly1305_h_l181_c13_740d] LATENCY=0
     -- Inputs
     uint320_add_poly1305_h_l181_c13_740d_a <= VAR_uint320_add_poly1305_h_l181_c13_740d_a;
     uint320_add_poly1305_h_l181_c13_740d_b <= VAR_uint320_add_poly1305_h_l181_c13_740d_b;
     -- Outputs
     VAR_uint320_add_poly1305_h_l181_c13_740d_return_output := uint320_add_poly1305_h_l181_c13_740d_return_output;

     -- Submodule level 6
     VAR_a_MUX_poly1305_h_l165_c5_81e0_iftrue := VAR_uint320_add_poly1305_h_l181_c13_740d_return_output;
     -- a_MUX[poly1305_h_l165_c5_81e0] LATENCY=0
     -- Inputs
     a_MUX_poly1305_h_l165_c5_81e0_cond <= VAR_a_MUX_poly1305_h_l165_c5_81e0_cond;
     a_MUX_poly1305_h_l165_c5_81e0_iftrue <= VAR_a_MUX_poly1305_h_l165_c5_81e0_iftrue;
     a_MUX_poly1305_h_l165_c5_81e0_iffalse <= VAR_a_MUX_poly1305_h_l165_c5_81e0_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_h_l165_c5_81e0_return_output := a_MUX_poly1305_h_l165_c5_81e0_return_output;

     -- Submodule level 7
     -- CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l198_l186_l199_l185_DUPLICATE_baf7 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l198_l186_l199_l185_DUPLICATE_baf7_return_output := VAR_a_MUX_poly1305_h_l165_c5_81e0_return_output.limbs(1);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_e351 LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_e351_return_output := VAR_a_MUX_poly1305_h_l165_c5_81e0_return_output.limbs(2);

     -- CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l194_l185_l195_l187_DUPLICATE_ef5b LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l194_l185_l195_l187_DUPLICATE_ef5b_return_output := VAR_a_MUX_poly1305_h_l165_c5_81e0_return_output.limbs(0);

     -- Submodule level 8
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_c714_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l194_l185_l195_l187_DUPLICATE_ef5b_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_366c_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l194_l185_l195_l187_DUPLICATE_ef5b_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l194_l185_l195_l187_DUPLICATE_ef5b_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_0_d41d_poly1305_h_l194_l185_l195_l187_DUPLICATE_ef5b_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_6235_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l198_l186_l199_l185_DUPLICATE_baf7_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_eded_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l198_l186_l199_l185_DUPLICATE_baf7_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_0a02_right := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l198_l186_l199_l185_DUPLICATE_baf7_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4449_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l198_l186_l199_l185_DUPLICATE_baf7_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_1_d41d_poly1305_h_l198_l186_l199_l185_DUPLICATE_baf7_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_f226_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_e351_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_2474_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_e351_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iffalse := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l185_l202_DUPLICATE_e351_return_output;
     -- BIN_OP_EQ[poly1305_h_l186_c9_6235] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l186_c9_6235_left <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_6235_left;
     BIN_OP_EQ_poly1305_h_l186_c9_6235_right <= VAR_BIN_OP_EQ_poly1305_h_l186_c9_6235_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l186_c9_6235_return_output := BIN_OP_EQ_poly1305_h_l186_c9_6235_return_output;

     -- BIN_OP_GTE[poly1305_h_l187_c9_c714] LATENCY=0
     -- Inputs
     BIN_OP_GTE_poly1305_h_l187_c9_c714_left <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_c714_left;
     BIN_OP_GTE_poly1305_h_l187_c9_c714_right <= VAR_BIN_OP_GTE_poly1305_h_l187_c9_c714_right;
     -- Outputs
     VAR_BIN_OP_GTE_poly1305_h_l187_c9_c714_return_output := BIN_OP_GTE_poly1305_h_l187_c9_c714_return_output;

     -- BIN_OP_MINUS[poly1305_h_l194_c16_34ef] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l194_c16_34ef_left <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_left;
     BIN_OP_MINUS_poly1305_h_l194_c16_34ef_right <= VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_return_output := BIN_OP_MINUS_poly1305_h_l194_c16_34ef_return_output;

     -- BIN_OP_MINUS[poly1305_h_l198_c16_4449] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_4449_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4449_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_4449_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4449_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4449_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_4449_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_f226] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_f226_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_f226_left;
     BIN_OP_AND_poly1305_h_l185_c10_f226_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_f226_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_f226_return_output := BIN_OP_AND_poly1305_h_l185_c10_f226_return_output;

     -- Submodule level 9
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_2909_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_f226_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_bc61_right := VAR_BIN_OP_EQ_poly1305_h_l186_c9_6235_return_output;
     VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_right := VAR_BIN_OP_GTE_poly1305_h_l187_c9_c714_return_output;
     VAR_BIN_OP_GT_poly1305_h_l195_c19_366c_left := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_return_output;
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l194_c16_34ef_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_4449_return_output;
     -- BIN_OP_GT[poly1305_h_l195_c19_366c] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l195_c19_366c_left <= VAR_BIN_OP_GT_poly1305_h_l195_c19_366c_left;
     BIN_OP_GT_poly1305_h_l195_c19_366c_right <= VAR_BIN_OP_GT_poly1305_h_l195_c19_366c_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l195_c19_366c_return_output := BIN_OP_GT_poly1305_h_l195_c19_366c_return_output;

     -- BIN_OP_EQ[poly1305_h_l185_c10_2909] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l185_c10_2909_left <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_2909_left;
     BIN_OP_EQ_poly1305_h_l185_c10_2909_right <= VAR_BIN_OP_EQ_poly1305_h_l185_c10_2909_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l185_c10_2909_return_output := BIN_OP_EQ_poly1305_h_l185_c10_2909_return_output;

     -- Submodule level 10
     VAR_BIN_OP_AND_poly1305_h_l185_c10_bc61_left := VAR_BIN_OP_EQ_poly1305_h_l185_c10_2909_return_output;
     VAR_MUX_poly1305_h_l195_c19_8911_cond := VAR_BIN_OP_GT_poly1305_h_l195_c19_366c_return_output;
     -- BIN_OP_AND[poly1305_h_l185_c10_bc61] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_bc61_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_bc61_left;
     BIN_OP_AND_poly1305_h_l185_c10_bc61_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_bc61_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_bc61_return_output := BIN_OP_AND_poly1305_h_l185_c10_bc61_return_output;

     -- MUX[poly1305_h_l195_c19_8911] LATENCY=0
     -- Inputs
     MUX_poly1305_h_l195_c19_8911_cond <= VAR_MUX_poly1305_h_l195_c19_8911_cond;
     MUX_poly1305_h_l195_c19_8911_iftrue <= VAR_MUX_poly1305_h_l195_c19_8911_iftrue;
     MUX_poly1305_h_l195_c19_8911_iffalse <= VAR_MUX_poly1305_h_l195_c19_8911_iffalse;
     -- Outputs
     VAR_MUX_poly1305_h_l195_c19_8911_return_output := MUX_poly1305_h_l195_c19_8911_return_output;

     -- Submodule level 11
     VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_left := VAR_BIN_OP_AND_poly1305_h_l185_c10_bc61_return_output;
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_right := VAR_MUX_poly1305_h_l195_c19_8911_return_output;
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_bedf_left := VAR_MUX_poly1305_h_l195_c19_8911_return_output;
     -- BIN_OP_NEQ[poly1305_h_l199_c64_bedf] LATENCY=0
     -- Inputs
     BIN_OP_NEQ_poly1305_h_l199_c64_bedf_left <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_bedf_left;
     BIN_OP_NEQ_poly1305_h_l199_c64_bedf_right <= VAR_BIN_OP_NEQ_poly1305_h_l199_c64_bedf_right;
     -- Outputs
     VAR_BIN_OP_NEQ_poly1305_h_l199_c64_bedf_return_output := BIN_OP_NEQ_poly1305_h_l199_c64_bedf_return_output;

     -- BIN_OP_MINUS[poly1305_h_l198_c16_b406] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l198_c16_b406_left <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_left;
     BIN_OP_MINUS_poly1305_h_l198_c16_b406_right <= VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_return_output := BIN_OP_MINUS_poly1305_h_l198_c16_b406_return_output;

     -- BIN_OP_AND[poly1305_h_l185_c10_a8b1] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l185_c10_a8b1_left <= VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_left;
     BIN_OP_AND_poly1305_h_l185_c10_a8b1_right <= VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_return_output := BIN_OP_AND_poly1305_h_l185_c10_a8b1_return_output;

     -- Submodule level 12
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_return_output;
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_cond := VAR_BIN_OP_AND_poly1305_h_l185_c10_a8b1_return_output;
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_eded_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_return_output;
     VAR_BIN_OP_GT_poly1305_h_l199_c19_0a02_left := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_return_output;
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iftrue := VAR_BIN_OP_MINUS_poly1305_h_l198_c16_b406_return_output;
     VAR_BIN_OP_AND_poly1305_h_l199_c42_7332_right := VAR_BIN_OP_NEQ_poly1305_h_l199_c64_bedf_return_output;
     -- a_limbs_0_MUX[poly1305_h_l185_c5_4a4f] LATENCY=0
     -- Inputs
     a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_cond <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_cond;
     a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iftrue <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iftrue;
     a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iffalse <= VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_iffalse;
     -- Outputs
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_return_output := a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_return_output;

     -- BIN_OP_GT[poly1305_h_l199_c19_0a02] LATENCY=0
     -- Inputs
     BIN_OP_GT_poly1305_h_l199_c19_0a02_left <= VAR_BIN_OP_GT_poly1305_h_l199_c19_0a02_left;
     BIN_OP_GT_poly1305_h_l199_c19_0a02_right <= VAR_BIN_OP_GT_poly1305_h_l199_c19_0a02_right;
     -- Outputs
     VAR_BIN_OP_GT_poly1305_h_l199_c19_0a02_return_output := BIN_OP_GT_poly1305_h_l199_c19_0a02_return_output;

     -- BIN_OP_EQ[poly1305_h_l199_c42_eded] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_h_l199_c42_eded_left <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_eded_left;
     BIN_OP_EQ_poly1305_h_l199_c42_eded_right <= VAR_BIN_OP_EQ_poly1305_h_l199_c42_eded_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_h_l199_c42_eded_return_output := BIN_OP_EQ_poly1305_h_l199_c42_eded_return_output;

     -- a_limbs_1_MUX[poly1305_h_l185_c5_4a4f] LATENCY=0
     -- Inputs
     a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_cond <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_cond;
     a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iftrue <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iftrue;
     a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iffalse <= VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_iffalse;
     -- Outputs
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_return_output := a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_return_output;

     -- Submodule level 13
     VAR_BIN_OP_AND_poly1305_h_l199_c42_7332_left := VAR_BIN_OP_EQ_poly1305_h_l199_c42_eded_return_output;
     VAR_BIN_OP_OR_poly1305_h_l199_c19_427c_left := VAR_BIN_OP_GT_poly1305_h_l199_c19_0a02_return_output;
     -- BIN_OP_AND[poly1305_h_l199_c42_7332] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l199_c42_7332_left <= VAR_BIN_OP_AND_poly1305_h_l199_c42_7332_left;
     BIN_OP_AND_poly1305_h_l199_c42_7332_right <= VAR_BIN_OP_AND_poly1305_h_l199_c42_7332_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l199_c42_7332_return_output := BIN_OP_AND_poly1305_h_l199_c42_7332_return_output;

     -- Submodule level 14
     VAR_BIN_OP_OR_poly1305_h_l199_c19_427c_right := VAR_BIN_OP_AND_poly1305_h_l199_c42_7332_return_output;
     -- BIN_OP_OR[poly1305_h_l199_c19_427c] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l199_c19_427c_left <= VAR_BIN_OP_OR_poly1305_h_l199_c19_427c_left;
     BIN_OP_OR_poly1305_h_l199_c19_427c_right <= VAR_BIN_OP_OR_poly1305_h_l199_c19_427c_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l199_c19_427c_return_output := BIN_OP_OR_poly1305_h_l199_c19_427c_return_output;

     -- Submodule level 15
     VAR_borrow_poly1305_h_l199_c9_bff7 := resize(VAR_BIN_OP_OR_poly1305_h_l199_c19_427c_return_output, 64);
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_2474_right := VAR_borrow_poly1305_h_l199_c9_bff7;
     -- BIN_OP_MINUS[poly1305_h_l202_c9_2474] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_poly1305_h_l202_c9_2474_left <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_2474_left;
     BIN_OP_MINUS_poly1305_h_l202_c9_2474_right <= VAR_BIN_OP_MINUS_poly1305_h_l202_c9_2474_right;
     -- Outputs
     VAR_BIN_OP_MINUS_poly1305_h_l202_c9_2474_return_output := BIN_OP_MINUS_poly1305_h_l202_c9_2474_return_output;

     -- Submodule level 16
     VAR_BIN_OP_AND_poly1305_h_l203_c9_1ee6_left := VAR_BIN_OP_MINUS_poly1305_h_l202_c9_2474_return_output;
     -- BIN_OP_AND[poly1305_h_l203_c9_1ee6] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l203_c9_1ee6_left <= VAR_BIN_OP_AND_poly1305_h_l203_c9_1ee6_left;
     BIN_OP_AND_poly1305_h_l203_c9_1ee6_right <= VAR_BIN_OP_AND_poly1305_h_l203_c9_1ee6_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l203_c9_1ee6_return_output := BIN_OP_AND_poly1305_h_l203_c9_1ee6_return_output;

     -- Submodule level 17
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iftrue := VAR_BIN_OP_AND_poly1305_h_l203_c9_1ee6_return_output;
     -- a_limbs_2_MUX[poly1305_h_l185_c5_4a4f] LATENCY=0
     -- Inputs
     a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_cond <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_cond;
     a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iftrue <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iftrue;
     a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iffalse <= VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_iffalse;
     -- Outputs
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_return_output := a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_return_output;

     -- Submodule level 18
     -- CONST_REF_RD_u320_t_u320_t_b8ef[poly1305_h_l205_c12_06be] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_06be_return_output := CONST_REF_RD_u320_t_u320_t_b8ef(
     VAR_a_MUX_poly1305_h_l165_c5_81e0_return_output,
     VAR_a_limbs_0_MUX_poly1305_h_l185_c5_4a4f_return_output,
     VAR_a_limbs_1_MUX_poly1305_h_l185_c5_4a4f_return_output,
     VAR_a_limbs_2_MUX_poly1305_h_l185_c5_4a4f_return_output);

     -- Submodule level 19
     VAR_return_output := VAR_CONST_REF_RD_u320_t_u320_t_b8ef_poly1305_h_l205_c12_06be_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
