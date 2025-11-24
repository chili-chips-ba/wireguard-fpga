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
-- Submodules: 9
entity uint320_add_0CLK_10d8c973 is
port(
 a : in u320_t;
 b : in u320_t;
 return_output : out u320_t);
end uint320_add_0CLK_10d8c973;
architecture arch of uint320_add_0CLK_10d8c973 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- BIN_OP_PLUS[poly1305_h_l91_c25_eeb8]
signal BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_left : unsigned(319 downto 0);
signal BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_right : unsigned(319 downto 0);
signal BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_return_output : unsigned(320 downto 0);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0[poly1305_h_l94_c23_3427]
signal FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
signal FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64[poly1305_h_l94_c23_3427]
signal FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
signal FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128[poly1305_h_l94_c23_3427]
signal FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
signal FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192[poly1305_h_l94_c23_3427]
signal FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
signal FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256[poly1305_h_l94_c23_3427]
signal FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
signal FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);

function uint64_array5_le( x : uint64_t_5) return unsigned is

  --variable x : uint64_t_5;
  variable return_output : unsigned(319 downto 0);

begin
return_output := x(4)&x(3)&x(2)&x(1)&x(0);
return return_output;
end function;

function CONST_REF_RD_u320_t_u320_t_4216( ref_toks_0 : unsigned;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned;
 ref_toks_4 : unsigned) return u320_t is
 
  variable base : u320_t; 
  variable return_output : u320_t;
begin
      base.limbs(0) := ref_toks_0;
      base.limbs(1) := ref_toks_1;
      base.limbs(2) := ref_toks_2;
      base.limbs(3) := ref_toks_3;
      base.limbs(4) := ref_toks_4;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_PLUS_poly1305_h_l91_c25_eeb8 : 0 clocks latency
BIN_OP_PLUS_poly1305_h_l91_c25_eeb8 : entity work.BIN_OP_PLUS_uint320_t_uint320_t_0CLK_de264c78 port map (
BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_left,
BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_right,
BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_return_output);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427 : 0 clocks latency
FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427 : entity work.CONST_SR_0_uint320_t_0CLK_de264c78 port map (
FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_x,
FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_return_output);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427 : 0 clocks latency
FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427 : entity work.CONST_SR_64_uint320_t_0CLK_de264c78 port map (
FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_x,
FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_return_output);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427 : 0 clocks latency
FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427 : entity work.CONST_SR_128_uint320_t_0CLK_de264c78 port map (
FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_x,
FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_return_output);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427 : 0 clocks latency
FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427 : entity work.CONST_SR_192_uint320_t_0CLK_de264c78 port map (
FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_x,
FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_return_output);

-- FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427 : 0 clocks latency
FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427 : entity work.CONST_SR_256_uint320_t_0CLK_de264c78 port map (
FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_x,
FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 a,
 b,
 -- All submodule outputs
 BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_return_output,
 FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_return_output,
 FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_return_output,
 FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_return_output,
 FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_return_output,
 FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u320_t;
 variable VAR_a : u320_t;
 variable VAR_b : u320_t;
 variable VAR_a_uint : unsigned(319 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_5_u320_t_limbs_d41d_poly1305_h_l89_c41_2411_return_output : uint64_t_5;
 variable VAR_uint64_array5_le_poly1305_h_l89_c24_dcfa_return_output : unsigned(319 downto 0);
 variable VAR_b_uint : unsigned(319 downto 0);
 variable VAR_CONST_REF_RD_uint64_t_5_u320_t_limbs_d41d_poly1305_h_l90_c41_596a_return_output : uint64_t_5;
 variable VAR_uint64_array5_le_poly1305_h_l90_c24_b263_return_output : unsigned(319 downto 0);
 variable VAR_rv_uint : unsigned(319 downto 0);
 variable VAR_rv_uint_poly1305_h_l91_c15_d154_0 : unsigned(319 downto 0);
 variable VAR_BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_left : unsigned(319 downto 0);
 variable VAR_BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_right : unsigned(319 downto 0);
 variable VAR_BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_return_output : unsigned(320 downto 0);
 variable VAR_rv : u320_t;
 variable VAR_i : signed(31 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_0_rv_limbs_0_poly1305_h_l94_c9_2b89 : unsigned(63 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_1_rv_limbs_1_poly1305_h_l94_c9_2b89 : unsigned(63 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_2_rv_limbs_2_poly1305_h_l94_c9_2b89 : unsigned(63 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_3_rv_limbs_3_poly1305_h_l94_c9_2b89 : unsigned(63 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_4_rv_limbs_4_poly1305_h_l94_c9_2b89 : unsigned(63 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_return_output : unsigned(319 downto 0);
 variable VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_x : unsigned(319 downto 0);
 variable VAR_CONST_REF_RD_u320_t_u320_t_4216_poly1305_h_l96_c12_bba8_return_output : u320_t;
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_a := a;
     VAR_b := b;

     -- Submodule level 0
     -- CONST_REF_RD_uint64_t_5_u320_t_limbs_d41d[poly1305_h_l89_c41_2411] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_5_u320_t_limbs_d41d_poly1305_h_l89_c41_2411_return_output := VAR_a.limbs;

     -- CONST_REF_RD_uint64_t_5_u320_t_limbs_d41d[poly1305_h_l90_c41_596a] LATENCY=0
     VAR_CONST_REF_RD_uint64_t_5_u320_t_limbs_d41d_poly1305_h_l90_c41_596a_return_output := VAR_b.limbs;

     -- Submodule level 1
     -- uint64_array5_le[poly1305_h_l90_c24_b263] LATENCY=0
     VAR_uint64_array5_le_poly1305_h_l90_c24_b263_return_output := uint64_array5_le(
     VAR_CONST_REF_RD_uint64_t_5_u320_t_limbs_d41d_poly1305_h_l90_c41_596a_return_output);

     -- uint64_array5_le[poly1305_h_l89_c24_dcfa] LATENCY=0
     VAR_uint64_array5_le_poly1305_h_l89_c24_dcfa_return_output := uint64_array5_le(
     VAR_CONST_REF_RD_uint64_t_5_u320_t_limbs_d41d_poly1305_h_l89_c41_2411_return_output);

     -- Submodule level 2
     VAR_BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_left := VAR_uint64_array5_le_poly1305_h_l89_c24_dcfa_return_output;
     VAR_BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_right := VAR_uint64_array5_le_poly1305_h_l90_c24_b263_return_output;
     -- BIN_OP_PLUS[poly1305_h_l91_c25_eeb8] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_left <= VAR_BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_left;
     BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_right <= VAR_BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_right;
     -- Outputs
     VAR_BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_return_output := BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_return_output;

     -- Submodule level 3
     VAR_rv_uint_poly1305_h_l91_c15_d154_0 := resize(VAR_BIN_OP_PLUS_poly1305_h_l91_c25_eeb8_return_output, 320);
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_x := VAR_rv_uint_poly1305_h_l91_c15_d154_0;
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_x := VAR_rv_uint_poly1305_h_l91_c15_d154_0;
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_x := VAR_rv_uint_poly1305_h_l91_c15_d154_0;
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_x := VAR_rv_uint_poly1305_h_l91_c15_d154_0;
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_x := VAR_rv_uint_poly1305_h_l91_c15_d154_0;
     -- FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256[poly1305_h_l94_c23_3427] LATENCY=0
     -- Inputs
     FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_x <= VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_x;
     -- Outputs
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_return_output := FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_return_output;

     -- FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0[poly1305_h_l94_c23_3427] LATENCY=0
     -- Inputs
     FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_x <= VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_x;
     -- Outputs
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_return_output := FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_return_output;

     -- FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64[poly1305_h_l94_c23_3427] LATENCY=0
     -- Inputs
     FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_x <= VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_x;
     -- Outputs
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_return_output := FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_return_output;

     -- FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128[poly1305_h_l94_c23_3427] LATENCY=0
     -- Inputs
     FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_x <= VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_x;
     -- Outputs
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_return_output := FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_return_output;

     -- FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192[poly1305_h_l94_c23_3427] LATENCY=0
     -- Inputs
     FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_x <= VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_x;
     -- Outputs
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_return_output := FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_return_output;

     -- Submodule level 4
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_0_rv_limbs_0_poly1305_h_l94_c9_2b89 := resize(VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_0_CONST_SR_0_poly1305_h_l94_c23_3427_return_output, 64);
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_1_rv_limbs_1_poly1305_h_l94_c9_2b89 := resize(VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_1_CONST_SR_64_poly1305_h_l94_c23_3427_return_output, 64);
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_2_rv_limbs_2_poly1305_h_l94_c9_2b89 := resize(VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_2_CONST_SR_128_poly1305_h_l94_c23_3427_return_output, 64);
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_3_rv_limbs_3_poly1305_h_l94_c9_2b89 := resize(VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_3_CONST_SR_192_poly1305_h_l94_c23_3427_return_output, 64);
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_4_rv_limbs_4_poly1305_h_l94_c9_2b89 := resize(VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_4_CONST_SR_256_poly1305_h_l94_c23_3427_return_output, 64);
     -- CONST_REF_RD_u320_t_u320_t_4216[poly1305_h_l96_c12_bba8] LATENCY=0
     VAR_CONST_REF_RD_u320_t_u320_t_4216_poly1305_h_l96_c12_bba8_return_output := CONST_REF_RD_u320_t_u320_t_4216(
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_0_rv_limbs_0_poly1305_h_l94_c9_2b89,
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_1_rv_limbs_1_poly1305_h_l94_c9_2b89,
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_2_rv_limbs_2_poly1305_h_l94_c9_2b89,
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_3_rv_limbs_3_poly1305_h_l94_c9_2b89,
     VAR_FOR_poly1305_h_l93_c5_d5a6_ITER_4_rv_limbs_4_poly1305_h_l94_c9_2b89);

     -- Submodule level 5
     VAR_return_output := VAR_CONST_REF_RD_u320_t_u320_t_4216_poly1305_h_l96_c12_bba8_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
