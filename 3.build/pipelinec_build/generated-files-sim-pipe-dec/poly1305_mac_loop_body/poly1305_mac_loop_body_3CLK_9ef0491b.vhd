-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.25, 0.5, 0.75]
--   Input regs?: False
--   Output regs?: False
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.c_structs_pkg.all;
-- Submodules: 7
entity poly1305_mac_loop_body_3CLK_9ef0491b is
port(
 clk : in std_logic;
 inputs : in poly1305_mac_loop_body_in_t;
 return_output : out u320_t);
end poly1305_mac_loop_body_3CLK_9ef0491b;
architecture arch of poly1305_mac_loop_body_3CLK_9ef0491b is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 3;
-- All of the wires/regs in function
-- Stage 0
-- Stage 1
-- Stage 2
-- Each function instance gets signals
-- bytes_to_uint320[poly1305_h_l309_c16_3648]
signal bytes_to_uint320_poly1305_h_l309_c16_3648_src : uint8_t_40;
signal bytes_to_uint320_poly1305_h_l309_c16_3648_return_output : u320_t;

-- BIN_OP_OR[poly1305_h_l312_c5_d919]
signal BIN_OP_OR_poly1305_h_l312_c5_d919_left : unsigned(63 downto 0);
signal BIN_OP_OR_poly1305_h_l312_c5_d919_right : unsigned(3 downto 0);
signal BIN_OP_OR_poly1305_h_l312_c5_d919_return_output : unsigned(63 downto 0);

-- uint320_add[poly1305_h_l315_c9_2493]
signal uint320_add_poly1305_h_l315_c9_2493_a : u320_t;
signal uint320_add_poly1305_h_l315_c9_2493_b : u320_t;
signal uint320_add_poly1305_h_l315_c9_2493_return_output : u320_t;

-- uint320_mul[poly1305_h_l319_c9_9dc4]
signal uint320_mul_poly1305_h_l319_c9_9dc4_a : u320_t;
signal uint320_mul_poly1305_h_l319_c9_9dc4_b : u320_t;
signal uint320_mul_poly1305_h_l319_c9_9dc4_return_output : u320_t;

-- uint320_mod_prime[poly1305_h_l322_c9_282e]
signal uint320_mod_prime_poly1305_h_l322_c9_282e_a : u320_t;
signal uint320_mod_prime_poly1305_h_l322_c9_282e_return_output : u320_t;

function CONST_REF_RD_uint8_t_40_uint8_t_40_7a60( ref_toks_0 : uint8_t_40;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned;
 ref_toks_4 : unsigned;
 ref_toks_5 : unsigned;
 ref_toks_6 : unsigned;
 ref_toks_7 : unsigned;
 ref_toks_8 : unsigned;
 ref_toks_9 : unsigned;
 ref_toks_10 : unsigned;
 ref_toks_11 : unsigned;
 ref_toks_12 : unsigned;
 ref_toks_13 : unsigned;
 ref_toks_14 : unsigned;
 ref_toks_15 : unsigned;
 ref_toks_16 : unsigned) return uint8_t_40 is
 
  variable base : uint8_t_40; 
  variable return_output : uint8_t_40;
begin
      base := ref_toks_0;
      base(0) := ref_toks_1;
      base(1) := ref_toks_2;
      base(2) := ref_toks_3;
      base(3) := ref_toks_4;
      base(4) := ref_toks_5;
      base(5) := ref_toks_6;
      base(6) := ref_toks_7;
      base(7) := ref_toks_8;
      base(8) := ref_toks_9;
      base(9) := ref_toks_10;
      base(10) := ref_toks_11;
      base(11) := ref_toks_12;
      base(12) := ref_toks_13;
      base(13) := ref_toks_14;
      base(14) := ref_toks_15;
      base(15) := ref_toks_16;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_u320_t_u320_t_7c3b( ref_toks_0 : u320_t;
 ref_toks_1 : unsigned) return u320_t is
 
  variable base : u320_t; 
  variable return_output : u320_t;
begin
      base := ref_toks_0;
      base.limbs(2) := ref_toks_1;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- bytes_to_uint320_poly1305_h_l309_c16_3648 : 0 clocks latency
bytes_to_uint320_poly1305_h_l309_c16_3648 : entity work.bytes_to_uint320_0CLK_b3848d7a port map (
bytes_to_uint320_poly1305_h_l309_c16_3648_src,
bytes_to_uint320_poly1305_h_l309_c16_3648_return_output);

-- BIN_OP_OR_poly1305_h_l312_c5_d919 : 0 clocks latency
BIN_OP_OR_poly1305_h_l312_c5_d919 : entity work.BIN_OP_OR_uint64_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_OR_poly1305_h_l312_c5_d919_left,
BIN_OP_OR_poly1305_h_l312_c5_d919_right,
BIN_OP_OR_poly1305_h_l312_c5_d919_return_output);

-- uint320_add_poly1305_h_l315_c9_2493 : 0 clocks latency
uint320_add_poly1305_h_l315_c9_2493 : entity work.uint320_add_0CLK_10d8c973 port map (
uint320_add_poly1305_h_l315_c9_2493_a,
uint320_add_poly1305_h_l315_c9_2493_b,
uint320_add_poly1305_h_l315_c9_2493_return_output);

-- uint320_mul_poly1305_h_l319_c9_9dc4 : 3 clocks latency
uint320_mul_poly1305_h_l319_c9_9dc4 : entity work.uint320_mul_3CLK_087b5579 port map (
clk,
uint320_mul_poly1305_h_l319_c9_9dc4_a,
uint320_mul_poly1305_h_l319_c9_9dc4_b,
uint320_mul_poly1305_h_l319_c9_9dc4_return_output);

-- uint320_mod_prime_poly1305_h_l322_c9_282e : 0 clocks latency
uint320_mod_prime_poly1305_h_l322_c9_282e : entity work.uint320_mod_prime_0CLK_461d892c port map (
uint320_mod_prime_poly1305_h_l322_c9_282e_a,
uint320_mod_prime_poly1305_h_l322_c9_282e_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 inputs,
 -- Registers
 -- Stage 0
 -- Stage 1
 -- Stage 2
 -- All submodule outputs
 bytes_to_uint320_poly1305_h_l309_c16_3648_return_output,
 BIN_OP_OR_poly1305_h_l312_c5_d919_return_output,
 uint320_add_poly1305_h_l315_c9_2493_return_output,
 uint320_mul_poly1305_h_l319_c9_9dc4_return_output,
 uint320_mod_prime_poly1305_h_l322_c9_282e_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u320_t;
 variable VAR_inputs : poly1305_mac_loop_body_in_t;
 variable VAR_block_bytes : uint8_t_16;
 variable VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output : uint8_t_16;
 variable VAR_r : u320_t;
 variable VAR_CONST_REF_RD_u320_t_poly1305_mac_loop_body_in_t_r_d41d_poly1305_h_l302_c16_b8ad_return_output : u320_t;
 variable VAR_a : u320_t;
 variable VAR_CONST_REF_RD_u320_t_poly1305_mac_loop_body_in_t_a_d41d_poly1305_h_l303_c16_d7ba_return_output : u320_t;
 variable VAR_n_bytes : uint8_t_40;
 variable VAR_i : unsigned(31 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_0_CONST_REF_RD_uint8_t_uint8_t_16_0_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_1_CONST_REF_RD_uint8_t_uint8_t_16_1_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_2_CONST_REF_RD_uint8_t_uint8_t_16_2_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_3_CONST_REF_RD_uint8_t_uint8_t_16_3_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_4_CONST_REF_RD_uint8_t_uint8_t_16_4_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_5_CONST_REF_RD_uint8_t_uint8_t_16_5_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_6_CONST_REF_RD_uint8_t_uint8_t_16_6_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_7_CONST_REF_RD_uint8_t_uint8_t_16_7_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_8_CONST_REF_RD_uint8_t_uint8_t_16_8_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_9_CONST_REF_RD_uint8_t_uint8_t_16_9_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_10_CONST_REF_RD_uint8_t_uint8_t_16_10_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_11_CONST_REF_RD_uint8_t_uint8_t_16_11_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_12_CONST_REF_RD_uint8_t_uint8_t_16_12_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_13_CONST_REF_RD_uint8_t_uint8_t_16_13_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_14_CONST_REF_RD_uint8_t_uint8_t_16_14_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_h_l306_c5_a97a_ITER_15_CONST_REF_RD_uint8_t_uint8_t_16_15_d41d_poly1305_h_l307_c22_92e8_return_output : unsigned(7 downto 0);
 variable VAR_n : u320_t;
 variable VAR_bytes_to_uint320_poly1305_h_l309_c16_3648_src : uint8_t_40;
 variable VAR_CONST_REF_RD_uint8_t_40_uint8_t_40_7a60_poly1305_h_l309_c33_21b1_return_output : uint8_t_40;
 variable VAR_bytes_to_uint320_poly1305_h_l309_c16_3648_return_output : u320_t;
 variable VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l312_c5_4186_return_output : unsigned(63 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l312_c5_d919_left : unsigned(63 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l312_c5_d919_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_OR_poly1305_h_l312_c5_d919_return_output : unsigned(63 downto 0);
 variable VAR_uint320_add_poly1305_h_l315_c9_2493_a : u320_t;
 variable VAR_uint320_add_poly1305_h_l315_c9_2493_b : u320_t;
 variable VAR_CONST_REF_RD_u320_t_u320_t_7c3b_poly1305_h_l315_c24_51f9_return_output : u320_t;
 variable VAR_uint320_add_poly1305_h_l315_c9_2493_return_output : u320_t;
 variable VAR_temp : u320_t;
 variable VAR_uint320_mul_poly1305_h_l319_c9_9dc4_a : u320_t;
 variable VAR_uint320_mul_poly1305_h_l319_c9_9dc4_b : u320_t;
 variable VAR_uint320_mul_poly1305_h_l319_c9_9dc4_return_output : u320_t;
 variable VAR_uint320_mod_prime_poly1305_h_l322_c9_282e_a : u320_t;
 variable VAR_uint320_mod_prime_poly1305_h_l322_c9_282e_return_output : u320_t;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_OR_poly1305_h_l312_c5_d919_right := to_unsigned(1, 4);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_inputs := inputs;

     -- Submodule level 0
     -- CONST_REF_RD_u320_t_poly1305_mac_loop_body_in_t_r_d41d[poly1305_h_l302_c16_b8ad] LATENCY=0
     VAR_CONST_REF_RD_u320_t_poly1305_mac_loop_body_in_t_r_d41d_poly1305_h_l302_c16_b8ad_return_output := VAR_inputs.r;

     -- CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d[poly1305_h_l301_c31_ed87] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output := VAR_inputs.block_bytes;

     -- CONST_REF_RD_u320_t_poly1305_mac_loop_body_in_t_a_d41d[poly1305_h_l303_c16_d7ba] LATENCY=0
     VAR_CONST_REF_RD_u320_t_poly1305_mac_loop_body_in_t_a_d41d_poly1305_h_l303_c16_d7ba_return_output := VAR_inputs.a;

     -- Submodule level 1
     VAR_uint320_add_poly1305_h_l315_c9_2493_a := VAR_CONST_REF_RD_u320_t_poly1305_mac_loop_body_in_t_a_d41d_poly1305_h_l303_c16_d7ba_return_output;
     VAR_uint320_mul_poly1305_h_l319_c9_9dc4_b := VAR_CONST_REF_RD_u320_t_poly1305_mac_loop_body_in_t_r_d41d_poly1305_h_l302_c16_b8ad_return_output;
     -- FOR_poly1305_h_l306_c5_a97a_ITER_14_CONST_REF_RD_uint8_t_uint8_t_16_14_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_14_CONST_REF_RD_uint8_t_uint8_t_16_14_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(14);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_6_CONST_REF_RD_uint8_t_uint8_t_16_6_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_6_CONST_REF_RD_uint8_t_uint8_t_16_6_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(6);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_10_CONST_REF_RD_uint8_t_uint8_t_16_10_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_10_CONST_REF_RD_uint8_t_uint8_t_16_10_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(10);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_15_CONST_REF_RD_uint8_t_uint8_t_16_15_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_15_CONST_REF_RD_uint8_t_uint8_t_16_15_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(15);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_9_CONST_REF_RD_uint8_t_uint8_t_16_9_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_9_CONST_REF_RD_uint8_t_uint8_t_16_9_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(9);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_5_CONST_REF_RD_uint8_t_uint8_t_16_5_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_5_CONST_REF_RD_uint8_t_uint8_t_16_5_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(5);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_2_CONST_REF_RD_uint8_t_uint8_t_16_2_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_2_CONST_REF_RD_uint8_t_uint8_t_16_2_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(2);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_3_CONST_REF_RD_uint8_t_uint8_t_16_3_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_3_CONST_REF_RD_uint8_t_uint8_t_16_3_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(3);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_7_CONST_REF_RD_uint8_t_uint8_t_16_7_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_7_CONST_REF_RD_uint8_t_uint8_t_16_7_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(7);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_12_CONST_REF_RD_uint8_t_uint8_t_16_12_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_12_CONST_REF_RD_uint8_t_uint8_t_16_12_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(12);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_11_CONST_REF_RD_uint8_t_uint8_t_16_11_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_11_CONST_REF_RD_uint8_t_uint8_t_16_11_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(11);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_8_CONST_REF_RD_uint8_t_uint8_t_16_8_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_8_CONST_REF_RD_uint8_t_uint8_t_16_8_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(8);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_0_CONST_REF_RD_uint8_t_uint8_t_16_0_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_0_CONST_REF_RD_uint8_t_uint8_t_16_0_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(0);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_13_CONST_REF_RD_uint8_t_uint8_t_16_13_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_13_CONST_REF_RD_uint8_t_uint8_t_16_13_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(13);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_4_CONST_REF_RD_uint8_t_uint8_t_16_4_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_4_CONST_REF_RD_uint8_t_uint8_t_16_4_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(4);

     -- FOR_poly1305_h_l306_c5_a97a_ITER_1_CONST_REF_RD_uint8_t_uint8_t_16_1_d41d[poly1305_h_l307_c22_92e8] LATENCY=0
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_1_CONST_REF_RD_uint8_t_uint8_t_16_1_d41d_poly1305_h_l307_c22_92e8_return_output := VAR_CONST_REF_RD_uint8_t_16_poly1305_mac_loop_body_in_t_block_bytes_d41d_poly1305_h_l301_c31_ed87_return_output(1);

     -- Submodule level 2
     -- CONST_REF_RD_uint8_t_40_uint8_t_40_7a60[poly1305_h_l309_c33_21b1] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_40_uint8_t_40_7a60_poly1305_h_l309_c33_21b1_return_output := CONST_REF_RD_uint8_t_40_uint8_t_40_7a60(
     (others => to_unsigned(0, 8)),
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_0_CONST_REF_RD_uint8_t_uint8_t_16_0_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_1_CONST_REF_RD_uint8_t_uint8_t_16_1_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_2_CONST_REF_RD_uint8_t_uint8_t_16_2_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_3_CONST_REF_RD_uint8_t_uint8_t_16_3_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_4_CONST_REF_RD_uint8_t_uint8_t_16_4_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_5_CONST_REF_RD_uint8_t_uint8_t_16_5_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_6_CONST_REF_RD_uint8_t_uint8_t_16_6_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_7_CONST_REF_RD_uint8_t_uint8_t_16_7_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_8_CONST_REF_RD_uint8_t_uint8_t_16_8_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_9_CONST_REF_RD_uint8_t_uint8_t_16_9_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_10_CONST_REF_RD_uint8_t_uint8_t_16_10_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_11_CONST_REF_RD_uint8_t_uint8_t_16_11_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_12_CONST_REF_RD_uint8_t_uint8_t_16_12_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_13_CONST_REF_RD_uint8_t_uint8_t_16_13_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_14_CONST_REF_RD_uint8_t_uint8_t_16_14_d41d_poly1305_h_l307_c22_92e8_return_output,
     VAR_FOR_poly1305_h_l306_c5_a97a_ITER_15_CONST_REF_RD_uint8_t_uint8_t_16_15_d41d_poly1305_h_l307_c22_92e8_return_output);

     -- Submodule level 3
     VAR_bytes_to_uint320_poly1305_h_l309_c16_3648_src := VAR_CONST_REF_RD_uint8_t_40_uint8_t_40_7a60_poly1305_h_l309_c33_21b1_return_output;
     -- bytes_to_uint320[poly1305_h_l309_c16_3648] LATENCY=0
     -- Inputs
     bytes_to_uint320_poly1305_h_l309_c16_3648_src <= VAR_bytes_to_uint320_poly1305_h_l309_c16_3648_src;
     -- Outputs
     VAR_bytes_to_uint320_poly1305_h_l309_c16_3648_return_output := bytes_to_uint320_poly1305_h_l309_c16_3648_return_output;

     -- Submodule level 4
     -- CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d[poly1305_h_l312_c5_4186] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l312_c5_4186_return_output := VAR_bytes_to_uint320_poly1305_h_l309_c16_3648_return_output.limbs(2);

     -- Submodule level 5
     VAR_BIN_OP_OR_poly1305_h_l312_c5_d919_left := VAR_CONST_REF_RD_uint64_t_u320_t_limbs_2_d41d_poly1305_h_l312_c5_4186_return_output;
     -- BIN_OP_OR[poly1305_h_l312_c5_d919] LATENCY=0
     -- Inputs
     BIN_OP_OR_poly1305_h_l312_c5_d919_left <= VAR_BIN_OP_OR_poly1305_h_l312_c5_d919_left;
     BIN_OP_OR_poly1305_h_l312_c5_d919_right <= VAR_BIN_OP_OR_poly1305_h_l312_c5_d919_right;
     -- Outputs
     VAR_BIN_OP_OR_poly1305_h_l312_c5_d919_return_output := BIN_OP_OR_poly1305_h_l312_c5_d919_return_output;

     -- Submodule level 6
     -- CONST_REF_RD_u320_t_u320_t_7c3b[poly1305_h_l315_c24_51f9] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_7c3b_poly1305_h_l315_c24_51f9_return_output := CONST_REF_RD_u320_t_u320_t_7c3b(
     VAR_bytes_to_uint320_poly1305_h_l309_c16_3648_return_output,
     VAR_BIN_OP_OR_poly1305_h_l312_c5_d919_return_output);

     -- Submodule level 7
     VAR_uint320_add_poly1305_h_l315_c9_2493_b := VAR_CONST_REF_RD_u320_t_u320_t_7c3b_poly1305_h_l315_c24_51f9_return_output;
     -- uint320_add[poly1305_h_l315_c9_2493] LATENCY=0
     -- Inputs
     uint320_add_poly1305_h_l315_c9_2493_a <= VAR_uint320_add_poly1305_h_l315_c9_2493_a;
     uint320_add_poly1305_h_l315_c9_2493_b <= VAR_uint320_add_poly1305_h_l315_c9_2493_b;
     -- Outputs
     VAR_uint320_add_poly1305_h_l315_c9_2493_return_output := uint320_add_poly1305_h_l315_c9_2493_return_output;

     -- Submodule level 8
     VAR_uint320_mul_poly1305_h_l319_c9_9dc4_a := VAR_uint320_add_poly1305_h_l315_c9_2493_return_output;
     -- uint320_mul[poly1305_h_l319_c9_9dc4] LATENCY=3
     -- Inputs
     uint320_mul_poly1305_h_l319_c9_9dc4_a <= VAR_uint320_mul_poly1305_h_l319_c9_9dc4_a;
     uint320_mul_poly1305_h_l319_c9_9dc4_b <= VAR_uint320_mul_poly1305_h_l319_c9_9dc4_b;

     -- Write to comb signals
   elsif STAGE = 1 then
     -- Read from prev stage

     -- Write to comb signals
   elsif STAGE = 2 then
     -- Read from prev stage

     -- Write to comb signals
   elsif STAGE = 3 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_uint320_mul_poly1305_h_l319_c9_9dc4_return_output := uint320_mul_poly1305_h_l319_c9_9dc4_return_output;

     -- Submodule level 0
     VAR_uint320_mod_prime_poly1305_h_l322_c9_282e_a := VAR_uint320_mul_poly1305_h_l319_c9_9dc4_return_output;
     -- uint320_mod_prime[poly1305_h_l322_c9_282e] LATENCY=0
     -- Inputs
     uint320_mod_prime_poly1305_h_l322_c9_282e_a <= VAR_uint320_mod_prime_poly1305_h_l322_c9_282e_a;
     -- Outputs
     VAR_uint320_mod_prime_poly1305_h_l322_c9_282e_return_output := uint320_mod_prime_poly1305_h_l322_c9_282e_return_output;

     -- Submodule level 1
     VAR_return_output := VAR_uint320_mod_prime_poly1305_h_l322_c9_282e_return_output;
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
     -- Stage 1
     -- Stage 2
 end if;
end process;

end arch;
