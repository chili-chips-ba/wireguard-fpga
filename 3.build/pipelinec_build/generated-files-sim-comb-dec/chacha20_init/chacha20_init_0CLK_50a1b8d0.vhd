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
-- Submodules: 34
entity chacha20_init_0CLK_50a1b8d0 is
port(
 key : in uint8_t_32;
 nonce : in uint8_t_12;
 counter : in unsigned(31 downto 0);
 return_output : out chacha20_state);
end chacha20_init_0CLK_50a1b8d0;
architecture arch of chacha20_init_0CLK_50a1b8d0 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
function uint8_uint8( x : unsigned;
 y : unsigned) return unsigned is

  --variable x : unsigned(7 downto 0);
  --variable y : unsigned(7 downto 0);
  variable return_output : unsigned(15 downto 0);

begin

    return_output := unsigned(std_logic_vector(x)) & unsigned(std_logic_vector(y));
    return return_output;

end function;

function uint16_uint16( x : unsigned;
 y : unsigned) return unsigned is

  --variable x : unsigned(15 downto 0);
  --variable y : unsigned(15 downto 0);
  variable return_output : unsigned(31 downto 0);

begin

    return_output := unsigned(std_logic_vector(x)) & unsigned(std_logic_vector(y));
    return return_output;

end function;

function CONST_REF_RD_chacha20_state_chacha20_state_23da( ref_toks_0 : unsigned;
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
 ref_toks_15 : unsigned) return chacha20_state is
 
  variable base : chacha20_state; 
  variable return_output : chacha20_state;
begin
      base.state(0) := ref_toks_0;
      base.state(1) := ref_toks_1;
      base.state(2) := ref_toks_2;
      base.state(3) := ref_toks_3;
      base.state(4) := ref_toks_4;
      base.state(5) := ref_toks_5;
      base.state(6) := ref_toks_6;
      base.state(7) := ref_toks_7;
      base.state(8) := ref_toks_8;
      base.state(9) := ref_toks_9;
      base.state(10) := ref_toks_10;
      base.state(11) := ref_toks_11;
      base.state(12) := ref_toks_12;
      base.state(13) := ref_toks_13;
      base.state(14) := ref_toks_14;
      base.state(15) := ref_toks_15;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 


-- Combinatorial process for pipeline stages
process (
 -- Inputs
 key,
 nonce,
 counter)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : chacha20_state;
 variable VAR_key : uint8_t_32;
 variable VAR_nonce : uint8_t_12;
 variable VAR_counter : unsigned(31 downto 0);
 variable VAR_state : chacha20_state;
 variable VAR_key_as_u32s : uint32_t_8;
 variable VAR_i : unsigned(31 downto 0);
 variable VAR_lsbs : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_chacha20_h_l112_c35_e9ab_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_chacha20_h_l112_c49_fde3_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint8_uint8_chacha20_h_l112_c23_7943_return_output : unsigned(15 downto 0);
 variable VAR_msbs : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_chacha20_h_l113_c35_2c24_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_chacha20_h_l113_c49_a9e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint8_uint8_chacha20_h_l113_c23_4a78_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_chacha20_h_l112_c35_e9ab_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_chacha20_h_l112_c49_fde3_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint8_uint8_chacha20_h_l112_c23_7943_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_chacha20_h_l113_c35_2c24_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_chacha20_h_l113_c49_a9e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint8_uint8_chacha20_h_l113_c23_4a78_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_chacha20_h_l112_c35_e9ab_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_chacha20_h_l112_c49_fde3_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint8_uint8_chacha20_h_l112_c23_7943_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_chacha20_h_l113_c35_2c24_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_chacha20_h_l113_c49_a9e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint8_uint8_chacha20_h_l113_c23_4a78_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_chacha20_h_l112_c35_e9ab_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_chacha20_h_l112_c49_fde3_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint8_uint8_chacha20_h_l112_c23_7943_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_chacha20_h_l113_c35_2c24_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_chacha20_h_l113_c49_a9e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint8_uint8_chacha20_h_l113_c23_4a78_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d_chacha20_h_l112_c35_e9ab_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d_chacha20_h_l112_c49_fde3_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint8_uint8_chacha20_h_l112_c23_7943_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d_chacha20_h_l113_c35_2c24_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d_chacha20_h_l113_c49_a9e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint8_uint8_chacha20_h_l113_c23_4a78_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d_chacha20_h_l112_c35_e9ab_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d_chacha20_h_l112_c49_fde3_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint8_uint8_chacha20_h_l112_c23_7943_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d_chacha20_h_l113_c35_2c24_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d_chacha20_h_l113_c49_a9e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint8_uint8_chacha20_h_l113_c23_4a78_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d_chacha20_h_l112_c35_e9ab_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d_chacha20_h_l112_c49_fde3_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint8_uint8_chacha20_h_l112_c23_7943_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d_chacha20_h_l113_c35_2c24_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d_chacha20_h_l113_c49_a9e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint8_uint8_chacha20_h_l113_c23_4a78_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d_chacha20_h_l112_c35_e9ab_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d_chacha20_h_l112_c49_fde3_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint8_uint8_chacha20_h_l112_c23_7943_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d_chacha20_h_l113_c35_2c24_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d_chacha20_h_l113_c49_a9e8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint8_uint8_chacha20_h_l113_c23_4a78_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output : unsigned(31 downto 0);
 variable VAR_nonce_as_u32s : uint32_t_3;
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_1_d41d_chacha20_h_l128_c35_d820_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_0_d41d_chacha20_h_l128_c51_730f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_uint8_uint8_chacha20_h_l128_c23_9b95_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_3_d41d_chacha20_h_l129_c35_e6fa_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_2_d41d_chacha20_h_l129_c51_c727_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_uint8_uint8_chacha20_h_l129_c23_f853_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_uint16_uint16_chacha20_h_l130_c26_bc33_return_output : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_5_d41d_chacha20_h_l128_c35_d820_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_4_d41d_chacha20_h_l128_c51_730f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_uint8_uint8_chacha20_h_l128_c23_9b95_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_7_d41d_chacha20_h_l129_c35_e6fa_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_6_d41d_chacha20_h_l129_c51_c727_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_uint8_uint8_chacha20_h_l129_c23_f853_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_uint16_uint16_chacha20_h_l130_c26_bc33_return_output : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_9_d41d_chacha20_h_l128_c35_d820_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_8_d41d_chacha20_h_l128_c51_730f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_uint8_uint8_chacha20_h_l128_c23_9b95_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_11_d41d_chacha20_h_l129_c35_e6fa_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_10_d41d_chacha20_h_l129_c51_c727_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_uint8_uint8_chacha20_h_l129_c23_f853_return_output : unsigned(15 downto 0);
 variable VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_uint16_uint16_chacha20_h_l130_c26_bc33_return_output : unsigned(31 downto 0);
 variable VAR_CONST_REF_RD_chacha20_state_chacha20_state_23da_chacha20_h_l137_c12_73bc_return_output : chacha20_state;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_key := key;
     VAR_nonce := nonce;
     VAR_counter := counter;

     -- Submodule level 0
     -- FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_4_d41d[chacha20_h_l128_c51_730f] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_4_d41d_chacha20_h_l128_c51_730f_return_output := VAR_nonce(4);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d[chacha20_h_l112_c35_e9ab] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d_chacha20_h_l112_c35_e9ab_return_output := VAR_key(25);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d[chacha20_h_l112_c35_e9ab] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d_chacha20_h_l112_c35_e9ab_return_output := VAR_key(29);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d[chacha20_h_l112_c49_fde3] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_chacha20_h_l112_c49_fde3_return_output := VAR_key(0);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_8_d41d[chacha20_h_l128_c51_730f] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_8_d41d_chacha20_h_l128_c51_730f_return_output := VAR_nonce(8);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d[chacha20_h_l113_c35_2c24] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_chacha20_h_l113_c35_2c24_return_output := VAR_key(11);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d[chacha20_h_l113_c49_a9e8] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d_chacha20_h_l113_c49_a9e8_return_output := VAR_key(22);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_6_d41d[chacha20_h_l129_c51_c727] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_6_d41d_chacha20_h_l129_c51_c727_return_output := VAR_nonce(6);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d[chacha20_h_l113_c35_2c24] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d_chacha20_h_l113_c35_2c24_return_output := VAR_key(19);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d[chacha20_h_l113_c49_a9e8] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_chacha20_h_l113_c49_a9e8_return_output := VAR_key(2);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d[chacha20_h_l113_c49_a9e8] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_chacha20_h_l113_c49_a9e8_return_output := VAR_key(14);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_7_d41d[chacha20_h_l129_c35_e6fa] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_7_d41d_chacha20_h_l129_c35_e6fa_return_output := VAR_nonce(7);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d[chacha20_h_l113_c49_a9e8] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_chacha20_h_l113_c49_a9e8_return_output := VAR_key(10);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d[chacha20_h_l113_c35_2c24] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_chacha20_h_l113_c35_2c24_return_output := VAR_key(3);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d[chacha20_h_l112_c35_e9ab] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_chacha20_h_l112_c35_e9ab_return_output := VAR_key(13);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d[chacha20_h_l113_c35_2c24] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d_chacha20_h_l113_c35_2c24_return_output := VAR_key(23);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d[chacha20_h_l113_c49_a9e8] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d_chacha20_h_l113_c49_a9e8_return_output := VAR_key(18);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d[chacha20_h_l113_c49_a9e8] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d_chacha20_h_l113_c49_a9e8_return_output := VAR_key(26);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d[chacha20_h_l113_c49_a9e8] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d_chacha20_h_l113_c49_a9e8_return_output := VAR_key(30);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_5_d41d[chacha20_h_l128_c35_d820] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_5_d41d_chacha20_h_l128_c35_d820_return_output := VAR_nonce(5);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d[chacha20_h_l112_c49_fde3] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_chacha20_h_l112_c49_fde3_return_output := VAR_key(8);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_1_d41d[chacha20_h_l128_c35_d820] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_1_d41d_chacha20_h_l128_c35_d820_return_output := VAR_nonce(1);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_2_d41d[chacha20_h_l129_c51_c727] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_2_d41d_chacha20_h_l129_c51_c727_return_output := VAR_nonce(2);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_0_d41d[chacha20_h_l128_c51_730f] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_0_d41d_chacha20_h_l128_c51_730f_return_output := VAR_nonce(0);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d[chacha20_h_l113_c35_2c24] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d_chacha20_h_l113_c35_2c24_return_output := VAR_key(27);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d[chacha20_h_l112_c49_fde3] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d_chacha20_h_l112_c49_fde3_return_output := VAR_key(28);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_3_d41d[chacha20_h_l129_c35_e6fa] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_3_d41d_chacha20_h_l129_c35_e6fa_return_output := VAR_nonce(3);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d[chacha20_h_l113_c35_2c24] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_chacha20_h_l113_c35_2c24_return_output := VAR_key(15);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d[chacha20_h_l113_c49_a9e8] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_chacha20_h_l113_c49_a9e8_return_output := VAR_key(6);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d[chacha20_h_l112_c35_e9ab] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d_chacha20_h_l112_c35_e9ab_return_output := VAR_key(17);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_11_d41d[chacha20_h_l129_c35_e6fa] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_11_d41d_chacha20_h_l129_c35_e6fa_return_output := VAR_nonce(11);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d[chacha20_h_l112_c49_fde3] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d_chacha20_h_l112_c49_fde3_return_output := VAR_key(20);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d[chacha20_h_l112_c35_e9ab] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_chacha20_h_l112_c35_e9ab_return_output := VAR_key(1);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_9_d41d[chacha20_h_l128_c35_d820] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_9_d41d_chacha20_h_l128_c35_d820_return_output := VAR_nonce(9);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d[chacha20_h_l112_c49_fde3] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d_chacha20_h_l112_c49_fde3_return_output := VAR_key(16);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d[chacha20_h_l112_c49_fde3] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_chacha20_h_l112_c49_fde3_return_output := VAR_key(12);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_10_d41d[chacha20_h_l129_c51_c727] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_10_d41d_chacha20_h_l129_c51_c727_return_output := VAR_nonce(10);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d[chacha20_h_l112_c35_e9ab] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_chacha20_h_l112_c35_e9ab_return_output := VAR_key(5);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d[chacha20_h_l112_c35_e9ab] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d_chacha20_h_l112_c35_e9ab_return_output := VAR_key(21);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d[chacha20_h_l112_c49_fde3] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_chacha20_h_l112_c49_fde3_return_output := VAR_key(4);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d[chacha20_h_l113_c35_2c24] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d_chacha20_h_l113_c35_2c24_return_output := VAR_key(31);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d[chacha20_h_l112_c35_e9ab] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_chacha20_h_l112_c35_e9ab_return_output := VAR_key(9);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d[chacha20_h_l112_c49_fde3] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d_chacha20_h_l112_c49_fde3_return_output := VAR_key(24);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d[chacha20_h_l113_c35_2c24] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_chacha20_h_l113_c35_2c24_return_output := VAR_key(7);

     -- Submodule level 1
     -- FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint8_uint8[chacha20_h_l112_c23_7943] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint8_uint8_chacha20_h_l112_c23_7943_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_chacha20_h_l112_c35_e9ab_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_chacha20_h_l112_c49_fde3_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint8_uint8[chacha20_h_l113_c23_4a78] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint8_uint8_chacha20_h_l113_c23_4a78_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_chacha20_h_l113_c35_2c24_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_chacha20_h_l113_c49_a9e8_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint8_uint8[chacha20_h_l112_c23_7943] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint8_uint8_chacha20_h_l112_c23_7943_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_chacha20_h_l112_c35_e9ab_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_chacha20_h_l112_c49_fde3_return_output);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_1_uint8_uint8[chacha20_h_l129_c23_f853] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_uint8_uint8_chacha20_h_l129_c23_f853_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_7_d41d_chacha20_h_l129_c35_e6fa_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_6_d41d_chacha20_h_l129_c51_c727_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint8_uint8[chacha20_h_l113_c23_4a78] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint8_uint8_chacha20_h_l113_c23_4a78_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d_chacha20_h_l113_c35_2c24_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d_chacha20_h_l113_c49_a9e8_return_output);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_0_uint8_uint8[chacha20_h_l128_c23_9b95] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_uint8_uint8_chacha20_h_l128_c23_9b95_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_1_d41d_chacha20_h_l128_c35_d820_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_0_d41d_chacha20_h_l128_c51_730f_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint8_uint8[chacha20_h_l112_c23_7943] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint8_uint8_chacha20_h_l112_c23_7943_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d_chacha20_h_l112_c35_e9ab_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d_chacha20_h_l112_c49_fde3_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint8_uint8[chacha20_h_l112_c23_7943] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint8_uint8_chacha20_h_l112_c23_7943_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d_chacha20_h_l112_c35_e9ab_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d_chacha20_h_l112_c49_fde3_return_output);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_0_uint8_uint8[chacha20_h_l129_c23_f853] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_uint8_uint8_chacha20_h_l129_c23_f853_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_3_d41d_chacha20_h_l129_c35_e6fa_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_12_2_d41d_chacha20_h_l129_c51_c727_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint8_uint8[chacha20_h_l112_c23_7943] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint8_uint8_chacha20_h_l112_c23_7943_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_chacha20_h_l112_c35_e9ab_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_chacha20_h_l112_c49_fde3_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint8_uint8[chacha20_h_l112_c23_7943] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint8_uint8_chacha20_h_l112_c23_7943_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d_chacha20_h_l112_c35_e9ab_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d_chacha20_h_l112_c49_fde3_return_output);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_2_uint8_uint8[chacha20_h_l128_c23_9b95] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_uint8_uint8_chacha20_h_l128_c23_9b95_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_9_d41d_chacha20_h_l128_c35_d820_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_8_d41d_chacha20_h_l128_c51_730f_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint8_uint8[chacha20_h_l113_c23_4a78] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint8_uint8_chacha20_h_l113_c23_4a78_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d_chacha20_h_l113_c35_2c24_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d_chacha20_h_l113_c49_a9e8_return_output);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_1_uint8_uint8[chacha20_h_l128_c23_9b95] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_uint8_uint8_chacha20_h_l128_c23_9b95_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_5_d41d_chacha20_h_l128_c35_d820_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_CONST_REF_RD_uint8_t_uint8_t_12_4_d41d_chacha20_h_l128_c51_730f_return_output);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_2_uint8_uint8[chacha20_h_l129_c23_f853] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_uint8_uint8_chacha20_h_l129_c23_f853_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_11_d41d_chacha20_h_l129_c35_e6fa_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_12_10_d41d_chacha20_h_l129_c51_c727_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint8_uint8[chacha20_h_l113_c23_4a78] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint8_uint8_chacha20_h_l113_c23_4a78_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d_chacha20_h_l113_c35_2c24_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d_chacha20_h_l113_c49_a9e8_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint8_uint8[chacha20_h_l113_c23_4a78] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint8_uint8_chacha20_h_l113_c23_4a78_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_chacha20_h_l113_c35_2c24_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_chacha20_h_l113_c49_a9e8_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint8_uint8[chacha20_h_l112_c23_7943] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint8_uint8_chacha20_h_l112_c23_7943_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_chacha20_h_l112_c35_e9ab_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_chacha20_h_l112_c49_fde3_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint8_uint8[chacha20_h_l113_c23_4a78] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint8_uint8_chacha20_h_l113_c23_4a78_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_chacha20_h_l113_c35_2c24_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_chacha20_h_l113_c49_a9e8_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint8_uint8[chacha20_h_l113_c23_4a78] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint8_uint8_chacha20_h_l113_c23_4a78_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d_chacha20_h_l113_c35_2c24_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d_chacha20_h_l113_c49_a9e8_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint8_uint8[chacha20_h_l112_c23_7943] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint8_uint8_chacha20_h_l112_c23_7943_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d_chacha20_h_l112_c35_e9ab_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d_chacha20_h_l112_c49_fde3_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint8_uint8[chacha20_h_l113_c23_4a78] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint8_uint8_chacha20_h_l113_c23_4a78_return_output := uint8_uint8(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_chacha20_h_l113_c35_2c24_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_chacha20_h_l113_c49_a9e8_return_output);

     -- Submodule level 2
     -- FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint16_uint16[chacha20_h_l114_c24_3c0b] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint8_uint8_chacha20_h_l113_c23_4a78_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint8_uint8_chacha20_h_l112_c23_7943_return_output);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_0_uint16_uint16[chacha20_h_l130_c26_bc33] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_uint16_uint16_chacha20_h_l130_c26_bc33_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_uint8_uint8_chacha20_h_l129_c23_f853_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_uint8_uint8_chacha20_h_l128_c23_9b95_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint16_uint16[chacha20_h_l114_c24_3c0b] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint8_uint8_chacha20_h_l113_c23_4a78_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint8_uint8_chacha20_h_l112_c23_7943_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint16_uint16[chacha20_h_l114_c24_3c0b] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint8_uint8_chacha20_h_l113_c23_4a78_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint8_uint8_chacha20_h_l112_c23_7943_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint16_uint16[chacha20_h_l114_c24_3c0b] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint8_uint8_chacha20_h_l113_c23_4a78_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint8_uint8_chacha20_h_l112_c23_7943_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint16_uint16[chacha20_h_l114_c24_3c0b] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint8_uint8_chacha20_h_l113_c23_4a78_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint8_uint8_chacha20_h_l112_c23_7943_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint16_uint16[chacha20_h_l114_c24_3c0b] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint8_uint8_chacha20_h_l113_c23_4a78_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint8_uint8_chacha20_h_l112_c23_7943_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint16_uint16[chacha20_h_l114_c24_3c0b] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint8_uint8_chacha20_h_l113_c23_4a78_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint8_uint8_chacha20_h_l112_c23_7943_return_output);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_1_uint16_uint16[chacha20_h_l130_c26_bc33] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_uint16_uint16_chacha20_h_l130_c26_bc33_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_uint8_uint8_chacha20_h_l129_c23_f853_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_uint8_uint8_chacha20_h_l128_c23_9b95_return_output);

     -- FOR_chacha20_h_l126_c5_e78d_ITER_2_uint16_uint16[chacha20_h_l130_c26_bc33] LATENCY=0
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_uint16_uint16_chacha20_h_l130_c26_bc33_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_uint8_uint8_chacha20_h_l129_c23_f853_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_uint8_uint8_chacha20_h_l128_c23_9b95_return_output);

     -- FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint16_uint16[chacha20_h_l114_c24_3c0b] LATENCY=0
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output := uint16_uint16(
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint8_uint8_chacha20_h_l113_c23_4a78_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint8_uint8_chacha20_h_l112_c23_7943_return_output);

     -- Submodule level 3
     -- CONST_REF_RD_chacha20_state_chacha20_state_23da[chacha20_h_l137_c12_73bc] LATENCY=0
     VAR_CONST_REF_RD_chacha20_state_chacha20_state_23da_chacha20_h_l137_c12_73bc_return_output := CONST_REF_RD_chacha20_state_chacha20_state_23da(
     to_unsigned(1634760805, 32),
     to_unsigned(857760878, 32),
     to_unsigned(2036477234, 32),
     to_unsigned(1797285236, 32),
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_0_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_1_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_2_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_3_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_4_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_5_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_6_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output,
     VAR_FOR_chacha20_h_l110_c5_bc1d_ITER_7_uint16_uint16_chacha20_h_l114_c24_3c0b_return_output,
     VAR_counter,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_0_uint16_uint16_chacha20_h_l130_c26_bc33_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_1_uint16_uint16_chacha20_h_l130_c26_bc33_return_output,
     VAR_FOR_chacha20_h_l126_c5_e78d_ITER_2_uint16_uint16_chacha20_h_l130_c26_bc33_return_output);

     -- Submodule level 4
     VAR_return_output := VAR_CONST_REF_RD_chacha20_state_chacha20_state_23da_chacha20_h_l137_c12_73bc_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
