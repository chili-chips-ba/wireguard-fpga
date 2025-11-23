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
use work.global_wires_pkg.all;
-- Submodules: 86
entity poly1305_mac_0CLK_caa1d5f6 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in poly1305_mac_global_to_module_t;
 module_to_global : out poly1305_mac_module_to_global_t);
end poly1305_mac_0CLK_caa1d5f6;
architecture arch of poly1305_mac_0CLK_caa1d5f6 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal state : unsigned(2 downto 0) := unsigned(poly1305_state_t_to_slv(poly1305_state_t'left));
signal is_last_block : unsigned(0 downto 0) := to_unsigned(0, 1);
signal a : u320_t := u320_t_NULL;
signal r : u320_t := u320_t_NULL;
signal s : u320_t := u320_t_NULL;
signal REG_COMB_state : unsigned(2 downto 0);
signal REG_COMB_is_last_block : unsigned(0 downto 0);
signal REG_COMB_a : u320_t;
signal REG_COMB_r : u320_t;
signal REG_COMB_s : u320_t;

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- BIN_OP_EQ[poly1305_mac_c_l58_c6_1a98]
signal BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output : unsigned(0 downto 0);

-- poly1305_mac_data_in_ready_MUX[poly1305_mac_c_l58_c3_115c]
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(0 downto 0);

-- r_MUX[poly1305_mac_c_l58_c3_115c]
signal r_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal r_MUX_poly1305_mac_c_l58_c3_115c_iftrue : u320_t;
signal r_MUX_poly1305_mac_c_l58_c3_115c_iffalse : u320_t;
signal r_MUX_poly1305_mac_c_l58_c3_115c_return_output : u320_t;

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l58_c3_115c]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_return_output : uint128_t_stream_t;

-- state_MUX[poly1305_mac_c_l58_c3_115c]
signal state_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(2 downto 0);

-- poly1305_pipeline_in_MUX[poly1305_mac_c_l58_c3_115c]
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iftrue : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iffalse : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_return_output : poly1305_mac_loop_body_in_t;

-- poly1305_pipeline_in_valid_MUX[poly1305_mac_c_l58_c3_115c]
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_mac_c_l58_c3_115c]
signal a_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l58_c3_115c_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l58_c3_115c_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l58_c3_115c_return_output : u320_t;

-- is_last_block_MUX[poly1305_mac_c_l58_c3_115c]
signal is_last_block_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(0 downto 0);

-- poly1305_mac_key_ready_MUX[poly1305_mac_c_l58_c3_115c]
signal poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(0 downto 0);
signal poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(0 downto 0);
signal poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(0 downto 0);

-- s_MUX[poly1305_mac_c_l58_c3_115c]
signal s_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
signal s_MUX_poly1305_mac_c_l58_c3_115c_iftrue : u320_t;
signal s_MUX_poly1305_mac_c_l58_c3_115c_iffalse : u320_t;
signal s_MUX_poly1305_mac_c_l58_c3_115c_return_output : u320_t;

-- BIN_OP_AND[poly1305_mac_c_l67_c8_063c]
signal BIN_OP_AND_poly1305_mac_c_l67_c8_063c_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l67_c8_063c_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l67_c8_063c_return_output : unsigned(0 downto 0);

-- r_MUX[poly1305_mac_c_l67_c5_6f05]
signal r_MUX_poly1305_mac_c_l67_c5_6f05_cond : unsigned(0 downto 0);
signal r_MUX_poly1305_mac_c_l67_c5_6f05_iftrue : u320_t;
signal r_MUX_poly1305_mac_c_l67_c5_6f05_iffalse : u320_t;
signal r_MUX_poly1305_mac_c_l67_c5_6f05_return_output : u320_t;

-- state_MUX[poly1305_mac_c_l67_c5_6f05]
signal state_MUX_poly1305_mac_c_l67_c5_6f05_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l67_c5_6f05_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l67_c5_6f05_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l67_c5_6f05_return_output : unsigned(2 downto 0);

-- s_MUX[poly1305_mac_c_l67_c5_6f05]
signal s_MUX_poly1305_mac_c_l67_c5_6f05_cond : unsigned(0 downto 0);
signal s_MUX_poly1305_mac_c_l67_c5_6f05_iftrue : u320_t;
signal s_MUX_poly1305_mac_c_l67_c5_6f05_iffalse : u320_t;
signal s_MUX_poly1305_mac_c_l67_c5_6f05_return_output : u320_t;

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248[poly1305_mac_c_l69_c162_b876]
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);

-- clamp[poly1305_mac_c_l79_c17_051f]
signal clamp_poly1305_mac_c_l79_c17_051f_r : u8_16_t;
signal clamp_poly1305_mac_c_l79_c17_051f_return_output : u8_16_t;

-- bytes_to_uint320[poly1305_mac_c_l81_c11_f277]
signal bytes_to_uint320_poly1305_mac_c_l81_c11_f277_src : uint8_t_40;
signal bytes_to_uint320_poly1305_mac_c_l81_c11_f277_return_output : u320_t;

-- bytes_to_uint320[poly1305_mac_c_l82_c11_09fd]
signal bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_src : uint8_t_40;
signal bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_return_output : u320_t;

-- BIN_OP_EQ[poly1305_mac_c_l86_c12_f757]
signal BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output : unsigned(0 downto 0);

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l86_c9_befd]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_return_output : uint128_t_stream_t;

-- state_MUX[poly1305_mac_c_l86_c9_befd]
signal state_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l86_c9_befd_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l86_c9_befd_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l86_c9_befd_return_output : unsigned(2 downto 0);

-- poly1305_pipeline_in_MUX[poly1305_mac_c_l86_c9_befd]
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iftrue : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iffalse : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_return_output : poly1305_mac_loop_body_in_t;

-- poly1305_pipeline_in_valid_MUX[poly1305_mac_c_l86_c9_befd]
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iftrue : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iffalse : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_mac_c_l86_c9_befd]
signal a_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l86_c9_befd_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l86_c9_befd_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l86_c9_befd_return_output : u320_t;

-- is_last_block_MUX[poly1305_mac_c_l86_c9_befd]
signal is_last_block_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iftrue : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iffalse : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l86_c9_befd_return_output : unsigned(0 downto 0);

-- poly1305_mac_data_in_ready_MUX[poly1305_mac_c_l86_c9_befd]
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iftrue : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iffalse : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_mac_c_l93_c34_d9ff]
signal BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_mac_c_l97_c8_0d0e]
signal BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_return_output : unsigned(0 downto 0);

-- state_MUX[poly1305_mac_c_l97_c5_320e]
signal state_MUX_poly1305_mac_c_l97_c5_320e_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l97_c5_320e_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l97_c5_320e_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l97_c5_320e_return_output : unsigned(2 downto 0);

-- BIN_OP_EQ[poly1305_mac_c_l100_c12_9fad]
signal BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_return_output : unsigned(0 downto 0);

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l100_c9_526a]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_return_output : uint128_t_stream_t;

-- state_MUX[poly1305_mac_c_l100_c9_526a]
signal state_MUX_poly1305_mac_c_l100_c9_526a_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l100_c9_526a_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l100_c9_526a_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l100_c9_526a_return_output : unsigned(2 downto 0);

-- a_MUX[poly1305_mac_c_l100_c9_526a]
signal a_MUX_poly1305_mac_c_l100_c9_526a_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l100_c9_526a_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l100_c9_526a_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l100_c9_526a_return_output : u320_t;

-- state_MUX[poly1305_mac_c_l102_c5_ec3c]
signal state_MUX_poly1305_mac_c_l102_c5_ec3c_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l102_c5_ec3c_return_output : unsigned(2 downto 0);

-- a_MUX[poly1305_mac_c_l102_c5_ec3c]
signal a_MUX_poly1305_mac_c_l102_c5_ec3c_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l102_c5_ec3c_return_output : u320_t;

-- state_MUX[poly1305_mac_c_l107_c7_f6dd]
signal state_MUX_poly1305_mac_c_l107_c7_f6dd_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l107_c7_f6dd_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l107_c7_f6dd_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l107_c7_f6dd_return_output : unsigned(2 downto 0);

-- BIN_OP_EQ[poly1305_mac_c_l114_c12_833a]
signal BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_return_output : unsigned(0 downto 0);

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l114_c9_a8ac]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_return_output : uint128_t_stream_t;

-- state_MUX[poly1305_mac_c_l114_c9_a8ac]
signal state_MUX_poly1305_mac_c_l114_c9_a8ac_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l114_c9_a8ac_return_output : unsigned(2 downto 0);

-- a_MUX[poly1305_mac_c_l114_c9_a8ac]
signal a_MUX_poly1305_mac_c_l114_c9_a8ac_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l114_c9_a8ac_return_output : u320_t;

-- uint320_add[poly1305_mac_c_l116_c9_4228]
signal uint320_add_poly1305_mac_c_l116_c9_4228_a : u320_t;
signal uint320_add_poly1305_mac_c_l116_c9_4228_b : u320_t;
signal uint320_add_poly1305_mac_c_l116_c9_4228_return_output : u320_t;

-- BIN_OP_EQ[poly1305_mac_c_l119_c12_5862]
signal BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_return_output : unsigned(0 downto 0);

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l119_c9_921d]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_return_output : uint128_t_stream_t;

-- state_MUX[poly1305_mac_c_l119_c9_921d]
signal state_MUX_poly1305_mac_c_l119_c9_921d_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l119_c9_921d_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l119_c9_921d_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l119_c9_921d_return_output : unsigned(2 downto 0);

-- u320_t_to_bytes[poly1305_mac_c_l121_c34_8b21]
signal u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_x : u320_t;
signal u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output : uint8_t_array_40_t;

-- BIN_OP_AND[poly1305_mac_c_l126_c8_138b]
signal BIN_OP_AND_poly1305_mac_c_l126_c8_138b_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l126_c8_138b_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l126_c8_138b_return_output : unsigned(0 downto 0);

-- state_MUX[poly1305_mac_c_l126_c5_7b4d]
signal state_MUX_poly1305_mac_c_l126_c5_7b4d_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l126_c5_7b4d_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l126_c5_7b4d_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l126_c5_7b4d_return_output : unsigned(2 downto 0);

function CONST_REF_RD_u8_16_t_u8_16_t_7cf3( ref_toks_0 : unsigned;
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
 ref_toks_15 : unsigned) return u8_16_t is
 
  variable base : u8_16_t; 
  variable return_output : u8_16_t;
begin
      base.bytes(0) := ref_toks_0;
      base.bytes(1) := ref_toks_1;
      base.bytes(2) := ref_toks_2;
      base.bytes(3) := ref_toks_3;
      base.bytes(4) := ref_toks_4;
      base.bytes(5) := ref_toks_5;
      base.bytes(6) := ref_toks_6;
      base.bytes(7) := ref_toks_7;
      base.bytes(8) := ref_toks_8;
      base.bytes(9) := ref_toks_9;
      base.bytes(10) := ref_toks_10;
      base.bytes(11) := ref_toks_11;
      base.bytes(12) := ref_toks_12;
      base.bytes(13) := ref_toks_13;
      base.bytes(14) := ref_toks_14;
      base.bytes(15) := ref_toks_15;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3( ref_toks_0 : unsigned;
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
 ref_toks_15 : unsigned) return uint8_t_16 is
 
  variable base : u8_16_t; 
  variable return_output : uint8_t_16;
begin
      base.bytes(0) := ref_toks_0;
      base.bytes(1) := ref_toks_1;
      base.bytes(2) := ref_toks_2;
      base.bytes(3) := ref_toks_3;
      base.bytes(4) := ref_toks_4;
      base.bytes(5) := ref_toks_5;
      base.bytes(6) := ref_toks_6;
      base.bytes(7) := ref_toks_7;
      base.bytes(8) := ref_toks_8;
      base.bytes(9) := ref_toks_9;
      base.bytes(10) := ref_toks_10;
      base.bytes(11) := ref_toks_11;
      base.bytes(12) := ref_toks_12;
      base.bytes(13) := ref_toks_13;
      base.bytes(14) := ref_toks_14;
      base.bytes(15) := ref_toks_15;

      return_output := base.bytes;
      return return_output; 
end function;

function CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55( ref_toks_0 : uint8_t_16;
 ref_toks_1 : u320_t;
 ref_toks_2 : u320_t) return poly1305_mac_loop_body_in_t is
 
  variable base : poly1305_mac_loop_body_in_t; 
  variable return_output : poly1305_mac_loop_body_in_t;
begin
      base.block_bytes := ref_toks_0;
      base.a := ref_toks_1;
      base.r := ref_toks_2;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_uint8_t_16_uint8_t_16_7a60( ref_toks_0 : unsigned;
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
 ref_toks_15 : unsigned) return uint8_t_16 is
 
  variable base : uint8_t_16; 
  variable return_output : uint8_t_16;
begin
      base(0) := ref_toks_0;
      base(1) := ref_toks_1;
      base(2) := ref_toks_2;
      base(3) := ref_toks_3;
      base(4) := ref_toks_4;
      base(5) := ref_toks_5;
      base(6) := ref_toks_6;
      base(7) := ref_toks_7;
      base(8) := ref_toks_8;
      base(9) := ref_toks_9;
      base(10) := ref_toks_10;
      base(11) := ref_toks_11;
      base(12) := ref_toks_12;
      base(13) := ref_toks_13;
      base(14) := ref_toks_14;
      base(15) := ref_toks_15;

      return_output := base;
      return return_output; 
end function;

function uint8_array16_le( x : uint8_t_16) return unsigned is

  --variable x : uint8_t_16;
  variable return_output : unsigned(127 downto 0);

begin
return_output := x(15)&x(14)&x(13)&x(12)&x(11)&x(10)&x(9)&x(8)&x(7)&x(6)&x(5)&x(4)&x(3)&x(2)&x(1)&x(0);
return return_output;
end function;

function CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0( ref_toks_0 : unsigned;
 ref_toks_1 : unsigned) return uint128_t_stream_t is
 
  variable base : uint128_t_stream_t; 
  variable return_output : uint128_t_stream_t;
begin
      base.data := ref_toks_0;
      base.valid := ref_toks_1;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98 : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98 : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_left,
BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_right,
BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output);

-- poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_cond,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- r_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
r_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
r_MUX_poly1305_mac_c_l58_c3_115c_cond,
r_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
r_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
r_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- state_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
state_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l58_c3_115c_cond,
state_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
state_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
state_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_0CLK_de264c78 port map (
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_cond,
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_cond,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- a_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
a_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l58_c3_115c_cond,
a_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
a_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
a_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- is_last_block_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
is_last_block_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
is_last_block_MUX_poly1305_mac_c_l58_c3_115c_cond,
is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
is_last_block_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_cond,
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- s_MUX_poly1305_mac_c_l58_c3_115c : 0 clocks latency
s_MUX_poly1305_mac_c_l58_c3_115c : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
s_MUX_poly1305_mac_c_l58_c3_115c_cond,
s_MUX_poly1305_mac_c_l58_c3_115c_iftrue,
s_MUX_poly1305_mac_c_l58_c3_115c_iffalse,
s_MUX_poly1305_mac_c_l58_c3_115c_return_output);

-- BIN_OP_AND_poly1305_mac_c_l67_c8_063c : 0 clocks latency
BIN_OP_AND_poly1305_mac_c_l67_c8_063c : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_mac_c_l67_c8_063c_left,
BIN_OP_AND_poly1305_mac_c_l67_c8_063c_right,
BIN_OP_AND_poly1305_mac_c_l67_c8_063c_return_output);

-- r_MUX_poly1305_mac_c_l67_c5_6f05 : 0 clocks latency
r_MUX_poly1305_mac_c_l67_c5_6f05 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
r_MUX_poly1305_mac_c_l67_c5_6f05_cond,
r_MUX_poly1305_mac_c_l67_c5_6f05_iftrue,
r_MUX_poly1305_mac_c_l67_c5_6f05_iffalse,
r_MUX_poly1305_mac_c_l67_c5_6f05_return_output);

-- state_MUX_poly1305_mac_c_l67_c5_6f05 : 0 clocks latency
state_MUX_poly1305_mac_c_l67_c5_6f05 : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l67_c5_6f05_cond,
state_MUX_poly1305_mac_c_l67_c5_6f05_iftrue,
state_MUX_poly1305_mac_c_l67_c5_6f05_iffalse,
state_MUX_poly1305_mac_c_l67_c5_6f05_return_output);

-- s_MUX_poly1305_mac_c_l67_c5_6f05 : 0 clocks latency
s_MUX_poly1305_mac_c_l67_c5_6f05 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
s_MUX_poly1305_mac_c_l67_c5_6f05_cond,
s_MUX_poly1305_mac_c_l67_c5_6f05_iftrue,
s_MUX_poly1305_mac_c_l67_c5_6f05_iffalse,
s_MUX_poly1305_mac_c_l67_c5_6f05_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_0_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_8_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_16_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_24_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_32_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_40_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_48_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_56_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_64_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_72_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_80_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_88_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_96_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_104_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_112_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_120_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_128_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_136_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_144_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_152_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_160_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_168_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_176_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_184_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_192_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_200_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_208_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_216_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_224_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_232_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_240_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_return_output);

-- FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876 : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876 : entity work.CONST_SR_248_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_x,
FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_return_output);

-- clamp_poly1305_mac_c_l79_c17_051f : 0 clocks latency
clamp_poly1305_mac_c_l79_c17_051f : entity work.clamp_0CLK_295015b8 port map (
clamp_poly1305_mac_c_l79_c17_051f_r,
clamp_poly1305_mac_c_l79_c17_051f_return_output);

-- bytes_to_uint320_poly1305_mac_c_l81_c11_f277 : 0 clocks latency
bytes_to_uint320_poly1305_mac_c_l81_c11_f277 : entity work.bytes_to_uint320_0CLK_b3848d7a port map (
bytes_to_uint320_poly1305_mac_c_l81_c11_f277_src,
bytes_to_uint320_poly1305_mac_c_l81_c11_f277_return_output);

-- bytes_to_uint320_poly1305_mac_c_l82_c11_09fd : 0 clocks latency
bytes_to_uint320_poly1305_mac_c_l82_c11_09fd : entity work.bytes_to_uint320_0CLK_b3848d7a port map (
bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_src,
bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_return_output);

-- BIN_OP_EQ_poly1305_mac_c_l86_c12_f757 : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l86_c12_f757 : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_left,
BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_right,
BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_return_output);

-- state_MUX_poly1305_mac_c_l86_c9_befd : 0 clocks latency
state_MUX_poly1305_mac_c_l86_c9_befd : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l86_c9_befd_cond,
state_MUX_poly1305_mac_c_l86_c9_befd_iftrue,
state_MUX_poly1305_mac_c_l86_c9_befd_iffalse,
state_MUX_poly1305_mac_c_l86_c9_befd_return_output);

-- poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd : 0 clocks latency
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd : entity work.MUX_uint1_t_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_0CLK_de264c78 port map (
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_cond,
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iftrue,
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iffalse,
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_return_output);

-- poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd : 0 clocks latency
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_cond,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iftrue,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iffalse,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_return_output);

-- a_MUX_poly1305_mac_c_l86_c9_befd : 0 clocks latency
a_MUX_poly1305_mac_c_l86_c9_befd : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l86_c9_befd_cond,
a_MUX_poly1305_mac_c_l86_c9_befd_iftrue,
a_MUX_poly1305_mac_c_l86_c9_befd_iffalse,
a_MUX_poly1305_mac_c_l86_c9_befd_return_output);

-- is_last_block_MUX_poly1305_mac_c_l86_c9_befd : 0 clocks latency
is_last_block_MUX_poly1305_mac_c_l86_c9_befd : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
is_last_block_MUX_poly1305_mac_c_l86_c9_befd_cond,
is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iftrue,
is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iffalse,
is_last_block_MUX_poly1305_mac_c_l86_c9_befd_return_output);

-- poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd : 0 clocks latency
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_cond,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iftrue,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iffalse,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_return_output);

-- BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff : 0 clocks latency
BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_left,
BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_right,
BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_return_output);

-- BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e : 0 clocks latency
BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_left,
BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_right,
BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_return_output);

-- state_MUX_poly1305_mac_c_l97_c5_320e : 0 clocks latency
state_MUX_poly1305_mac_c_l97_c5_320e : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l97_c5_320e_cond,
state_MUX_poly1305_mac_c_l97_c5_320e_iftrue,
state_MUX_poly1305_mac_c_l97_c5_320e_iffalse,
state_MUX_poly1305_mac_c_l97_c5_320e_return_output);

-- BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_left,
BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_right,
BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_return_output);

-- state_MUX_poly1305_mac_c_l100_c9_526a : 0 clocks latency
state_MUX_poly1305_mac_c_l100_c9_526a : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l100_c9_526a_cond,
state_MUX_poly1305_mac_c_l100_c9_526a_iftrue,
state_MUX_poly1305_mac_c_l100_c9_526a_iffalse,
state_MUX_poly1305_mac_c_l100_c9_526a_return_output);

-- a_MUX_poly1305_mac_c_l100_c9_526a : 0 clocks latency
a_MUX_poly1305_mac_c_l100_c9_526a : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l100_c9_526a_cond,
a_MUX_poly1305_mac_c_l100_c9_526a_iftrue,
a_MUX_poly1305_mac_c_l100_c9_526a_iffalse,
a_MUX_poly1305_mac_c_l100_c9_526a_return_output);

-- state_MUX_poly1305_mac_c_l102_c5_ec3c : 0 clocks latency
state_MUX_poly1305_mac_c_l102_c5_ec3c : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l102_c5_ec3c_cond,
state_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue,
state_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse,
state_MUX_poly1305_mac_c_l102_c5_ec3c_return_output);

-- a_MUX_poly1305_mac_c_l102_c5_ec3c : 0 clocks latency
a_MUX_poly1305_mac_c_l102_c5_ec3c : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l102_c5_ec3c_cond,
a_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue,
a_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse,
a_MUX_poly1305_mac_c_l102_c5_ec3c_return_output);

-- state_MUX_poly1305_mac_c_l107_c7_f6dd : 0 clocks latency
state_MUX_poly1305_mac_c_l107_c7_f6dd : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l107_c7_f6dd_cond,
state_MUX_poly1305_mac_c_l107_c7_f6dd_iftrue,
state_MUX_poly1305_mac_c_l107_c7_f6dd_iffalse,
state_MUX_poly1305_mac_c_l107_c7_f6dd_return_output);

-- BIN_OP_EQ_poly1305_mac_c_l114_c12_833a : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l114_c12_833a : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_left,
BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_right,
BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_return_output);

-- state_MUX_poly1305_mac_c_l114_c9_a8ac : 0 clocks latency
state_MUX_poly1305_mac_c_l114_c9_a8ac : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l114_c9_a8ac_cond,
state_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue,
state_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse,
state_MUX_poly1305_mac_c_l114_c9_a8ac_return_output);

-- a_MUX_poly1305_mac_c_l114_c9_a8ac : 0 clocks latency
a_MUX_poly1305_mac_c_l114_c9_a8ac : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l114_c9_a8ac_cond,
a_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue,
a_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse,
a_MUX_poly1305_mac_c_l114_c9_a8ac_return_output);

-- uint320_add_poly1305_mac_c_l116_c9_4228 : 0 clocks latency
uint320_add_poly1305_mac_c_l116_c9_4228 : entity work.uint320_add_0CLK_10d8c973 port map (
uint320_add_poly1305_mac_c_l116_c9_4228_a,
uint320_add_poly1305_mac_c_l116_c9_4228_b,
uint320_add_poly1305_mac_c_l116_c9_4228_return_output);

-- BIN_OP_EQ_poly1305_mac_c_l119_c12_5862 : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l119_c12_5862 : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_left,
BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_right,
BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_return_output);

-- state_MUX_poly1305_mac_c_l119_c9_921d : 0 clocks latency
state_MUX_poly1305_mac_c_l119_c9_921d : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l119_c9_921d_cond,
state_MUX_poly1305_mac_c_l119_c9_921d_iftrue,
state_MUX_poly1305_mac_c_l119_c9_921d_iffalse,
state_MUX_poly1305_mac_c_l119_c9_921d_return_output);

-- u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21 : 0 clocks latency
u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21 : entity work.u320_t_to_bytes_0CLK_801a240b port map (
u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_x,
u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output);

-- BIN_OP_AND_poly1305_mac_c_l126_c8_138b : 0 clocks latency
BIN_OP_AND_poly1305_mac_c_l126_c8_138b : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_mac_c_l126_c8_138b_left,
BIN_OP_AND_poly1305_mac_c_l126_c8_138b_right,
BIN_OP_AND_poly1305_mac_c_l126_c8_138b_return_output);

-- state_MUX_poly1305_mac_c_l126_c5_7b4d : 0 clocks latency
state_MUX_poly1305_mac_c_l126_c5_7b4d : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l126_c5_7b4d_cond,
state_MUX_poly1305_mac_c_l126_c5_7b4d_iftrue,
state_MUX_poly1305_mac_c_l126_c5_7b4d_iffalse,
state_MUX_poly1305_mac_c_l126_c5_7b4d_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Registers
 state,
 is_last_block,
 a,
 r,
 s,
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output,
 poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 r_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 state_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 a_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 is_last_block_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 s_MUX_poly1305_mac_c_l58_c3_115c_return_output,
 BIN_OP_AND_poly1305_mac_c_l67_c8_063c_return_output,
 r_MUX_poly1305_mac_c_l67_c5_6f05_return_output,
 state_MUX_poly1305_mac_c_l67_c5_6f05_return_output,
 s_MUX_poly1305_mac_c_l67_c5_6f05_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_return_output,
 FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_return_output,
 clamp_poly1305_mac_c_l79_c17_051f_return_output,
 bytes_to_uint320_poly1305_mac_c_l81_c11_f277_return_output,
 bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_return_output,
 BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_return_output,
 state_MUX_poly1305_mac_c_l86_c9_befd_return_output,
 poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_return_output,
 poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_return_output,
 a_MUX_poly1305_mac_c_l86_c9_befd_return_output,
 is_last_block_MUX_poly1305_mac_c_l86_c9_befd_return_output,
 poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_return_output,
 BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_return_output,
 BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_return_output,
 state_MUX_poly1305_mac_c_l97_c5_320e_return_output,
 BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_return_output,
 state_MUX_poly1305_mac_c_l100_c9_526a_return_output,
 a_MUX_poly1305_mac_c_l100_c9_526a_return_output,
 state_MUX_poly1305_mac_c_l102_c5_ec3c_return_output,
 a_MUX_poly1305_mac_c_l102_c5_ec3c_return_output,
 state_MUX_poly1305_mac_c_l107_c7_f6dd_return_output,
 BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_return_output,
 state_MUX_poly1305_mac_c_l114_c9_a8ac_return_output,
 a_MUX_poly1305_mac_c_l114_c9_a8ac_return_output,
 uint320_add_poly1305_mac_c_l116_c9_4228_return_output,
 BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_return_output,
 state_MUX_poly1305_mac_c_l119_c9_921d_return_output,
 u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output,
 BIN_OP_AND_poly1305_mac_c_l126_c8_138b_return_output,
 state_MUX_poly1305_mac_c_l126_c5_7b4d_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag : uint128_t_stream_t;
 variable VAR_poly1305_pipeline_in : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_valid : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key : uint256_t_stream_t;
 variable VAR_poly1305_mac_data_in : axis128_t_stream_t;
 variable VAR_poly1305_pipeline_out_valid : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_out : u320_t;
 variable VAR_poly1305_mac_auth_tag_ready : unsigned(0 downto 0);
 variable VAR_pipeline_null_inputs : poly1305_mac_loop_body_in_t;
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_r_MUX_poly1305_mac_c_l58_c3_115c_iftrue : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_return_output : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l58_c3_115c_iffalse : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l58_c3_115c_return_output : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l86_c9_befd_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iftrue : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iffalse : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_return_output : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_return_output : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l58_c3_115c_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l58_c3_115c_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l86_c9_befd_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l58_c3_115c_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_return_output : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_s_MUX_poly1305_mac_c_l58_c3_115c_iftrue : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_return_output : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l58_c3_115c_iffalse : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l58_c3_115c_return_output : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l58_c3_115c_cond : unsigned(0 downto 0);
 variable VAR_u320_null : u320_t;
 variable VAR_CONST_REF_RD_uint1_t_uint256_t_stream_t_valid_d41d_poly1305_mac_c_l67_c8_0827_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_return_output : unsigned(0 downto 0);
 variable VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_iftrue : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_iffalse : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_cond : unsigned(0 downto 0);
 variable VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_iftrue : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_iffalse : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_key : uint8_t_32;
 variable VAR_UINT_TO_BYTE_ARRAY_i : unsigned(31 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_0_poly1305_mac_data_key_0_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_1_poly1305_mac_data_key_1_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_2_poly1305_mac_data_key_2_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_3_poly1305_mac_data_key_3_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_4_poly1305_mac_data_key_4_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_5_poly1305_mac_data_key_5_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_6_poly1305_mac_data_key_6_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_7_poly1305_mac_data_key_7_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_8_poly1305_mac_data_key_8_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_9_poly1305_mac_data_key_9_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_10_poly1305_mac_data_key_10_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_11_poly1305_mac_data_key_11_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_12_poly1305_mac_data_key_12_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_13_poly1305_mac_data_key_13_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_14_poly1305_mac_data_key_14_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_15_poly1305_mac_data_key_15_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_16_poly1305_mac_data_key_16_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_17_poly1305_mac_data_key_17_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_18_poly1305_mac_data_key_18_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_19_poly1305_mac_data_key_19_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_20_poly1305_mac_data_key_20_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_21_poly1305_mac_data_key_21_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_22_poly1305_mac_data_key_22_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_23_poly1305_mac_data_key_23_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_24_poly1305_mac_data_key_24_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_25_poly1305_mac_data_key_25_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_26_poly1305_mac_data_key_26_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_27_poly1305_mac_data_key_27_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_28_poly1305_mac_data_key_28_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_29_poly1305_mac_data_key_29_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_30_poly1305_mac_data_key_30_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_31_poly1305_mac_data_key_31_poly1305_mac_c_l69_c116_b305 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_x : unsigned(255 downto 0);
 variable VAR_r_bytes : u8_16_t;
 variable VAR_s_bytes : u8_16_t;
 variable VAR_i : signed(31 downto 0);
 variable VAR_clamp_poly1305_mac_c_l79_c17_051f_r : u8_16_t;
 variable VAR_CONST_REF_RD_u8_16_t_u8_16_t_7cf3_poly1305_mac_c_l79_c23_d0cb_return_output : u8_16_t;
 variable VAR_clamp_poly1305_mac_c_l79_c17_051f_return_output : u8_16_t;
 variable VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_f277_src : uint8_t_40;
 variable VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_d41d_poly1305_mac_c_l81_c28_ae76_return_output : uint8_t_16;
 variable VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_f277_return_output : u320_t;
 variable VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_src : uint8_t_40;
 variable VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3_poly1305_mac_c_l82_c28_1a9d_return_output : uint8_t_16;
 variable VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_return_output : u320_t;
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l86_c9_befd_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l97_c5_320e_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l86_c9_befd_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l100_c9_526a_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iftrue : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_TRUE_INPUT_MUX_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55_poly1305_mac_c_l86_c9_befd_return_output : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iffalse : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l86_c9_befd_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l86_c9_befd_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l100_c9_526a_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iftrue : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iffalse : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d_poly1305_mac_c_l90_c40_3658_return_output : uint8_t_16;
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_poly1305_mac_c_l93_c34_764f_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_poly1305_mac_c_l95_c21_8978_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l97_c5_320e_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l97_c5_320e_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l97_c5_320e_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l100_c9_526a_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l100_c9_526a_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l100_c9_526a_cond : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l100_c9_526a_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l100_c9_526a_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l100_c9_526a_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_cond : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l119_c9_921d_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_cond : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_cond : unsigned(0 downto 0);
 variable VAR_uint320_add_poly1305_mac_c_l116_c9_4228_a : u320_t;
 variable VAR_uint320_add_poly1305_mac_c_l116_c9_4228_b : u320_t;
 variable VAR_uint320_add_poly1305_mac_c_l116_c9_4228_return_output : u320_t;
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_c9_921d_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l119_c9_921d_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l119_c9_921d_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l119_c9_921d_cond : unsigned(0 downto 0);
 variable VAR_a_bytes : uint8_t_array_40_t;
 variable VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_x : u320_t;
 variable VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output : uint8_t_array_40_t;
 variable VAR_auth_tag : uint8_t_16;
 variable VAR_ARRAY_COPY_i : unsigned(31 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_0_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_0_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_1_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_1_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_2_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_2_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_3_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_3_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_4_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_4_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_5_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_5_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_6_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_6_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_7_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_7_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_8_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_8_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_9_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_9_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_10_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_10_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_11_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_11_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_12_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_12_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_13_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_13_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_14_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_14_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_15_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_15_d41d_poly1305_mac_c_l123_c107_b1b8_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_16_uint8_t_16_7a60_poly1305_mac_c_l124_c51_e8d4_return_output : uint8_t_16;
 variable VAR_uint8_array16_le_poly1305_mac_c_l124_c34_b220_return_output : unsigned(127 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_138b_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_138b_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_138b_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output : unsigned(255 downto 0);
 variable VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l86_l119_l58_l114_l100_DUPLICATE_7a30_return_output : uint128_t_stream_t;
 -- State registers comb logic variables
variable REG_VAR_state : unsigned(2 downto 0);
variable REG_VAR_is_last_block : unsigned(0 downto 0);
variable REG_VAR_a : u320_t;
variable REG_VAR_r : u320_t;
variable REG_VAR_s : u320_t;
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_state := state;
  REG_VAR_is_last_block := is_last_block;
  REG_VAR_a := a;
  REG_VAR_r := r;
  REG_VAR_s := s;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_iffalse := unsigned(poly1305_state_t_to_slv(START_ITER));
     VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iftrue := to_unsigned(0, 1);
     VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_iftrue := unsigned(poly1305_state_t_to_slv(START_ITER));
     VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_right := unsigned(poly1305_state_t_to_slv(A_PLUS_S));
     VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_138b_left := to_unsigned(1, 1);
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue := to_unsigned(0, 1);
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iffalse := to_unsigned(0, 1);
     VAR_state_MUX_poly1305_mac_c_l97_c5_320e_iftrue := unsigned(poly1305_state_t_to_slv(FINISH_ITER));
     VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_iftrue := unsigned(poly1305_state_t_to_slv(A_PLUS_S));
     VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse := to_unsigned(0, 1);
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iffalse := poly1305_mac_loop_body_in_t_NULL;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iftrue := poly1305_mac_loop_body_in_t_NULL;
     VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_right := to_unsigned(1, 1);
     VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue := to_unsigned(1, 1);
     VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_right := unsigned(poly1305_state_t_to_slv(START_ITER));
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iftrue := to_unsigned(1, 1);
     VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_right := to_unsigned(1, 1);
     VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_right := to_unsigned(1, 1);
     VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_right := unsigned(poly1305_state_t_to_slv(FINISH_ITER));
     VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_right := unsigned(poly1305_state_t_to_slv(IDLE));
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iffalse := to_unsigned(0, 1);
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iftrue := to_unsigned(0, 1);
     VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue := unsigned(poly1305_state_t_to_slv(OUTPUT_AUTH_TAG));
     VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_iftrue := unsigned(poly1305_state_t_to_slv(IDLE));
     VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_right := unsigned(poly1305_state_t_to_slv(OUTPUT_AUTH_TAG));
     VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_iffalse := u320_t_NULL;
     VAR_a_MUX_poly1305_mac_c_l58_c3_115c_iftrue := u320_t_NULL;
     VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_iffalse := u320_t_NULL;
     -- CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l86_l119_l58_l114_l100_DUPLICATE_7a30 LATENCY=0
     VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l86_l119_l58_l114_l100_DUPLICATE_7a30_return_output := CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0(
     to_unsigned(0, 128),
     to_unsigned(0, 1));

     -- Submodule level 1
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iftrue := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l86_l119_l58_l114_l100_DUPLICATE_7a30_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l86_l119_l58_l114_l100_DUPLICATE_7a30_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iftrue := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l86_l119_l58_l114_l100_DUPLICATE_7a30_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iffalse := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l86_l119_l58_l114_l100_DUPLICATE_7a30_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iftrue := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l86_l119_l58_l114_l100_DUPLICATE_7a30_return_output;
 -- Reads from global variables
     VAR_poly1305_mac_key := global_to_module.poly1305_mac_key;
     VAR_poly1305_mac_data_in := global_to_module.poly1305_mac_data_in;
     VAR_poly1305_pipeline_out_valid := global_to_module.poly1305_pipeline_out_valid;
     VAR_poly1305_pipeline_out := global_to_module.poly1305_pipeline_out;
     VAR_poly1305_mac_auth_tag_ready := global_to_module.poly1305_mac_auth_tag_ready;
     -- Submodule level 0
     VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_cond := VAR_poly1305_pipeline_out_valid;
     VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_cond := VAR_poly1305_pipeline_out_valid;
     VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue := VAR_poly1305_pipeline_out;
     VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_138b_right := VAR_poly1305_mac_auth_tag_ready;
     -- CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d[poly1305_mac_c_l90_c40_3658] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d_poly1305_mac_c_l90_c40_3658_return_output := VAR_poly1305_mac_data_in.data.tdata;

     -- CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d[poly1305_mac_c_l69_c162_17e0]_DUPLICATE_01e7 LATENCY=0
     VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output := VAR_poly1305_mac_key.data;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d[poly1305_mac_c_l93_c34_764f] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_poly1305_mac_c_l93_c34_764f_return_output := VAR_poly1305_mac_data_in.valid;

     -- CONST_REF_RD_uint1_t_uint256_t_stream_t_valid_d41d[poly1305_mac_c_l67_c8_0827] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_uint256_t_stream_t_valid_d41d_poly1305_mac_c_l67_c8_0827_return_output := VAR_poly1305_mac_key.valid;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[poly1305_mac_c_l95_c21_8978] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_poly1305_mac_c_l95_c21_8978_return_output := VAR_poly1305_mac_data_in.data.tlast;

     -- Submodule level 1
     VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iftrue := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_poly1305_mac_c_l95_c21_8978_return_output;
     VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_left := VAR_CONST_REF_RD_uint1_t_uint256_t_stream_t_valid_d41d_poly1305_mac_c_l67_c8_0827_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_17e0_DUPLICATE_01e7_return_output;
     VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_poly1305_mac_c_l93_c34_764f_return_output;
     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_return_output;

     -- FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16[poly1305_mac_c_l69_c162_b876] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_x <= VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_return_output := FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_return_output;

     -- Submodule level 2
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_16_poly1305_mac_data_key_16_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_4_poly1305_mac_data_key_4_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_26_poly1305_mac_data_key_26_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_3_poly1305_mac_data_key_3_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_17_poly1305_mac_data_key_17_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_2_poly1305_mac_data_key_2_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_31_poly1305_mac_data_key_31_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_28_poly1305_mac_data_key_28_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_24_poly1305_mac_data_key_24_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_14_poly1305_mac_data_key_14_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_11_poly1305_mac_data_key_11_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_15_poly1305_mac_data_key_15_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_29_poly1305_mac_data_key_29_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_21_poly1305_mac_data_key_21_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_25_poly1305_mac_data_key_25_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_1_poly1305_mac_data_key_1_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_10_poly1305_mac_data_key_10_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_8_poly1305_mac_data_key_8_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_9_poly1305_mac_data_key_9_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_12_poly1305_mac_data_key_12_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_6_poly1305_mac_data_key_6_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_27_poly1305_mac_data_key_27_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_20_poly1305_mac_data_key_20_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_19_poly1305_mac_data_key_19_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_18_poly1305_mac_data_key_18_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_7_poly1305_mac_data_key_7_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_0_poly1305_mac_data_key_0_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_23_poly1305_mac_data_key_23_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_13_poly1305_mac_data_key_13_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_30_poly1305_mac_data_key_30_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_5_poly1305_mac_data_key_5_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_b876_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_22_poly1305_mac_data_key_22_poly1305_mac_c_l69_c116_b305 := resize(VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_b876_return_output, 8);
     -- CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3[poly1305_mac_c_l82_c28_1a9d] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3_poly1305_mac_c_l82_c28_1a9d_return_output := CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3(
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_16_poly1305_mac_data_key_16_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_17_poly1305_mac_data_key_17_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_18_poly1305_mac_data_key_18_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_19_poly1305_mac_data_key_19_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_20_poly1305_mac_data_key_20_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_21_poly1305_mac_data_key_21_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_22_poly1305_mac_data_key_22_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_23_poly1305_mac_data_key_23_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_24_poly1305_mac_data_key_24_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_25_poly1305_mac_data_key_25_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_26_poly1305_mac_data_key_26_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_27_poly1305_mac_data_key_27_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_28_poly1305_mac_data_key_28_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_29_poly1305_mac_data_key_29_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_30_poly1305_mac_data_key_30_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_31_poly1305_mac_data_key_31_poly1305_mac_c_l69_c116_b305);

     -- CONST_REF_RD_u8_16_t_u8_16_t_7cf3[poly1305_mac_c_l79_c23_d0cb] LATENCY=0
     VAR_CONST_REF_RD_u8_16_t_u8_16_t_7cf3_poly1305_mac_c_l79_c23_d0cb_return_output := CONST_REF_RD_u8_16_t_u8_16_t_7cf3(
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_0_poly1305_mac_data_key_0_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_1_poly1305_mac_data_key_1_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_2_poly1305_mac_data_key_2_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_3_poly1305_mac_data_key_3_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_4_poly1305_mac_data_key_4_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_5_poly1305_mac_data_key_5_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_6_poly1305_mac_data_key_6_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_7_poly1305_mac_data_key_7_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_8_poly1305_mac_data_key_8_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_9_poly1305_mac_data_key_9_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_10_poly1305_mac_data_key_10_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_11_poly1305_mac_data_key_11_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_12_poly1305_mac_data_key_12_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_13_poly1305_mac_data_key_13_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_14_poly1305_mac_data_key_14_poly1305_mac_c_l69_c116_b305,
     VAR_FOR_poly1305_mac_c_l69_c38_f527_ITER_15_poly1305_mac_data_key_15_poly1305_mac_c_l69_c116_b305);

     -- Submodule level 3
     VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_src := (0 to 15 => VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3_poly1305_mac_c_l82_c28_1a9d_return_output, others => to_unsigned(0, 8));
     VAR_clamp_poly1305_mac_c_l79_c17_051f_r := VAR_CONST_REF_RD_u8_16_t_u8_16_t_7cf3_poly1305_mac_c_l79_c23_d0cb_return_output;
     -- bytes_to_uint320[poly1305_mac_c_l82_c11_09fd] LATENCY=0
     -- Inputs
     bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_src <= VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_src;
     -- Outputs
     VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_return_output := bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_return_output;

     -- Submodule level 4
     VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_iftrue := VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_09fd_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse := a;
     VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse := a;
     VAR_a_MUX_poly1305_mac_c_l86_c9_befd_iftrue := a;
     VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_x := a;
     VAR_uint320_add_poly1305_mac_c_l116_c9_4228_a := a;
     VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iffalse := is_last_block;
     VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_cond := is_last_block;
     VAR_r_MUX_poly1305_mac_c_l58_c3_115c_iffalse := r;
     VAR_s_MUX_poly1305_mac_c_l58_c3_115c_iffalse := s;
     VAR_uint320_add_poly1305_mac_c_l116_c9_4228_b := s;
     VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_left := state;
     VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_left := state;
     VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_left := state;
     VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_left := state;
     VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_left := state;
     VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse := state;
     VAR_state_MUX_poly1305_mac_c_l119_c9_921d_iffalse := state;
     VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_iffalse := state;
     VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_iffalse := state;
     VAR_state_MUX_poly1305_mac_c_l97_c5_320e_iffalse := state;
     -- u320_t_to_bytes[poly1305_mac_c_l121_c34_8b21] LATENCY=0
     -- Inputs
     u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_x <= VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_x;
     -- Outputs
     VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output := u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output;

     -- a_MUX[poly1305_mac_c_l102_c5_ec3c] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l102_c5_ec3c_cond <= VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_cond;
     a_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue <= VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue;
     a_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse <= VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_return_output := a_MUX_poly1305_mac_c_l102_c5_ec3c_return_output;

     -- state_MUX[poly1305_mac_c_l107_c7_f6dd] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l107_c7_f6dd_cond <= VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_cond;
     state_MUX_poly1305_mac_c_l107_c7_f6dd_iftrue <= VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_iftrue;
     state_MUX_poly1305_mac_c_l107_c7_f6dd_iffalse <= VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_return_output := state_MUX_poly1305_mac_c_l107_c7_f6dd_return_output;

     -- BIN_OP_AND[poly1305_mac_c_l67_c8_063c] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_mac_c_l67_c8_063c_left <= VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_left;
     BIN_OP_AND_poly1305_mac_c_l67_c8_063c_right <= VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_return_output := BIN_OP_AND_poly1305_mac_c_l67_c8_063c_return_output;

     -- BIN_OP_EQ[poly1305_mac_c_l58_c6_1a98] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_left;
     BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output := BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;

     -- BIN_OP_EQ[poly1305_mac_c_l119_c12_5862] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_left;
     BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_return_output := BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_return_output;

     -- BIN_OP_AND[poly1305_mac_c_l126_c8_138b] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_mac_c_l126_c8_138b_left <= VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_138b_left;
     BIN_OP_AND_poly1305_mac_c_l126_c8_138b_right <= VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_138b_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_138b_return_output := BIN_OP_AND_poly1305_mac_c_l126_c8_138b_return_output;

     -- poly1305_pipeline_in_TRUE_INPUT_MUX_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55[poly1305_mac_c_l86_c9_befd] LATENCY=0
     VAR_poly1305_pipeline_in_TRUE_INPUT_MUX_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55_poly1305_mac_c_l86_c9_befd_return_output := CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55(
     VAR_CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d_poly1305_mac_c_l90_c40_3658_return_output,
     a,
     r);

     -- BIN_OP_EQ[poly1305_mac_c_l100_c12_9fad] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_left;
     BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_return_output := BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_return_output;

     -- BIN_OP_EQ[poly1305_mac_c_l114_c12_833a] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_left;
     BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_return_output := BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_return_output;

     -- clamp[poly1305_mac_c_l79_c17_051f] LATENCY=0
     -- Inputs
     clamp_poly1305_mac_c_l79_c17_051f_r <= VAR_clamp_poly1305_mac_c_l79_c17_051f_r;
     -- Outputs
     VAR_clamp_poly1305_mac_c_l79_c17_051f_return_output := clamp_poly1305_mac_c_l79_c17_051f_return_output;

     -- uint320_add[poly1305_mac_c_l116_c9_4228] LATENCY=0
     -- Inputs
     uint320_add_poly1305_mac_c_l116_c9_4228_a <= VAR_uint320_add_poly1305_mac_c_l116_c9_4228_a;
     uint320_add_poly1305_mac_c_l116_c9_4228_b <= VAR_uint320_add_poly1305_mac_c_l116_c9_4228_b;
     -- Outputs
     VAR_uint320_add_poly1305_mac_c_l116_c9_4228_return_output := uint320_add_poly1305_mac_c_l116_c9_4228_return_output;

     -- BIN_OP_AND[poly1305_mac_c_l93_c34_d9ff] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_left <= VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_left;
     BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_right <= VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_return_output := BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_return_output;

     -- BIN_OP_EQ[poly1305_mac_c_l86_c12_f757] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_left;
     BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output := BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output;

     -- Submodule level 1
     VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_cond := VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_138b_return_output;
     VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_cond := VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_return_output;
     VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_cond := VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_return_output;
     VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_cond := VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_063c_return_output;
     VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_left := VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_return_output;
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iftrue := VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_d9ff_return_output;
     VAR_a_MUX_poly1305_mac_c_l100_c9_526a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_return_output;
     VAR_state_MUX_poly1305_mac_c_l100_c9_526a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_9fad_return_output;
     VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_return_output;
     VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_833a_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_return_output;
     VAR_state_MUX_poly1305_mac_c_l119_c9_921d_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_5862_return_output;
     VAR_a_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_r_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_s_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_state_MUX_poly1305_mac_c_l58_c3_115c_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_1a98_return_output;
     VAR_a_MUX_poly1305_mac_c_l86_c9_befd_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output;
     VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output;
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output;
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output;
     VAR_state_MUX_poly1305_mac_c_l86_c9_befd_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_f757_return_output;
     VAR_a_MUX_poly1305_mac_c_l100_c9_526a_iftrue := VAR_a_MUX_poly1305_mac_c_l102_c5_ec3c_return_output;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iftrue := VAR_poly1305_pipeline_in_TRUE_INPUT_MUX_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55_poly1305_mac_c_l86_c9_befd_return_output;
     VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue := VAR_state_MUX_poly1305_mac_c_l107_c7_f6dd_return_output;
     VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue := VAR_uint320_add_poly1305_mac_c_l116_c9_4228_return_output;
     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_8_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_8_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_8_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_8_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(8);

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_1_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_1_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_1_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_1_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(1);

     -- BIN_OP_AND[poly1305_mac_c_l97_c8_0d0e] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_left <= VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_left;
     BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_right <= VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_return_output := BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_return_output;

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_13_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_13_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_13_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_13_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(13);

     -- poly1305_pipeline_in_MUX[poly1305_mac_c_l86_c9_befd] LATENCY=0
     -- Inputs
     poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_cond <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_cond;
     poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iftrue <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iftrue;
     poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iffalse <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_iffalse;
     -- Outputs
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_return_output := poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_return_output;

     -- poly1305_mac_key_ready_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_cond;
     poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output := poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_14_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_14_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_14_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_14_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(14);

     -- poly1305_pipeline_in_valid_MUX[poly1305_mac_c_l86_c9_befd] LATENCY=0
     -- Inputs
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_cond <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_cond;
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iftrue <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iftrue;
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iffalse <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_iffalse;
     -- Outputs
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_return_output := poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_return_output;

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_15_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_15_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_15_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_15_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(15);

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_2_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_2_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_2_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_2_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(2);

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_10_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_10_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_10_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_10_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(10);

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_12_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_12_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_12_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_12_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(12);

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_6_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_6_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_6_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_6_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(6);

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_0_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_0_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_0_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_0_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(0);

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_9_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_9_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_9_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_9_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(9);

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_11_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_11_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_11_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_11_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(11);

     -- is_last_block_MUX[poly1305_mac_c_l86_c9_befd] LATENCY=0
     -- Inputs
     is_last_block_MUX_poly1305_mac_c_l86_c9_befd_cond <= VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_cond;
     is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iftrue <= VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iftrue;
     is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iffalse <= VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_iffalse;
     -- Outputs
     VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_return_output := is_last_block_MUX_poly1305_mac_c_l86_c9_befd_return_output;

     -- s_MUX[poly1305_mac_c_l67_c5_6f05] LATENCY=0
     -- Inputs
     s_MUX_poly1305_mac_c_l67_c5_6f05_cond <= VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_cond;
     s_MUX_poly1305_mac_c_l67_c5_6f05_iftrue <= VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_iftrue;
     s_MUX_poly1305_mac_c_l67_c5_6f05_iffalse <= VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_iffalse;
     -- Outputs
     VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_return_output := s_MUX_poly1305_mac_c_l67_c5_6f05_return_output;

     -- poly1305_mac_data_in_ready_MUX[poly1305_mac_c_l86_c9_befd] LATENCY=0
     -- Inputs
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_cond <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_cond;
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iftrue <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iftrue;
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iffalse <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_iffalse;
     -- Outputs
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_return_output := poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_return_output;

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_7_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_7_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_7_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_7_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(7);

     -- CONST_REF_RD_uint8_t_16_u8_16_t_bytes_d41d[poly1305_mac_c_l81_c28_ae76] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_d41d_poly1305_mac_c_l81_c28_ae76_return_output := VAR_clamp_poly1305_mac_c_l79_c17_051f_return_output.bytes;

     -- state_MUX[poly1305_mac_c_l102_c5_ec3c] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l102_c5_ec3c_cond <= VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_cond;
     state_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue <= VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_iftrue;
     state_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse <= VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_return_output := state_MUX_poly1305_mac_c_l102_c5_ec3c_return_output;

     -- a_MUX[poly1305_mac_c_l114_c9_a8ac] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l114_c9_a8ac_cond <= VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_cond;
     a_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue <= VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue;
     a_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse <= VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_return_output := a_MUX_poly1305_mac_c_l114_c9_a8ac_return_output;

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_5_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_5_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_5_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_5_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(5);

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_4_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_4_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_4_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_4_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(4);

     -- state_MUX[poly1305_mac_c_l126_c5_7b4d] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l126_c5_7b4d_cond <= VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_cond;
     state_MUX_poly1305_mac_c_l126_c5_7b4d_iftrue <= VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_iftrue;
     state_MUX_poly1305_mac_c_l126_c5_7b4d_iffalse <= VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_return_output := state_MUX_poly1305_mac_c_l126_c5_7b4d_return_output;

     -- FOR_poly1305_mac_c_l123_c28_e076_ITER_3_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_3_d41d[poly1305_mac_c_l123_c107_b1b8] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_3_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_3_d41d_poly1305_mac_c_l123_c107_b1b8_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8b21_return_output.data(3);

     -- state_MUX[poly1305_mac_c_l67_c5_6f05] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l67_c5_6f05_cond <= VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_cond;
     state_MUX_poly1305_mac_c_l67_c5_6f05_iftrue <= VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_iftrue;
     state_MUX_poly1305_mac_c_l67_c5_6f05_iffalse <= VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_return_output := state_MUX_poly1305_mac_c_l67_c5_6f05_return_output;

     -- Submodule level 2
     VAR_state_MUX_poly1305_mac_c_l97_c5_320e_cond := VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_0d0e_return_output;
     VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_f277_src := (0 to 15 => VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_d41d_poly1305_mac_c_l81_c28_ae76_return_output, others => to_unsigned(0, 8));
     VAR_a_MUX_poly1305_mac_c_l100_c9_526a_iffalse := VAR_a_MUX_poly1305_mac_c_l114_c9_a8ac_return_output;
     VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iffalse := VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_befd_return_output;
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse := VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_befd_return_output;
     VAR_poly1305_mac_key_ready := VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iffalse := VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_befd_return_output;
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iffalse := VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_befd_return_output;
     VAR_s_MUX_poly1305_mac_c_l58_c3_115c_iftrue := VAR_s_MUX_poly1305_mac_c_l67_c5_6f05_return_output;
     VAR_state_MUX_poly1305_mac_c_l100_c9_526a_iftrue := VAR_state_MUX_poly1305_mac_c_l102_c5_ec3c_return_output;
     VAR_state_MUX_poly1305_mac_c_l119_c9_921d_iftrue := VAR_state_MUX_poly1305_mac_c_l126_c5_7b4d_return_output;
     VAR_state_MUX_poly1305_mac_c_l58_c3_115c_iftrue := VAR_state_MUX_poly1305_mac_c_l67_c5_6f05_return_output;
     -- state_MUX[poly1305_mac_c_l97_c5_320e] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l97_c5_320e_cond <= VAR_state_MUX_poly1305_mac_c_l97_c5_320e_cond;
     state_MUX_poly1305_mac_c_l97_c5_320e_iftrue <= VAR_state_MUX_poly1305_mac_c_l97_c5_320e_iftrue;
     state_MUX_poly1305_mac_c_l97_c5_320e_iffalse <= VAR_state_MUX_poly1305_mac_c_l97_c5_320e_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l97_c5_320e_return_output := state_MUX_poly1305_mac_c_l97_c5_320e_return_output;

     -- is_last_block_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     is_last_block_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_cond;
     is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_return_output := is_last_block_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- CONST_REF_RD_uint8_t_16_uint8_t_16_7a60[poly1305_mac_c_l124_c51_e8d4] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_uint8_t_16_7a60_poly1305_mac_c_l124_c51_e8d4_return_output := CONST_REF_RD_uint8_t_16_uint8_t_16_7a60(
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_0_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_0_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_1_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_1_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_2_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_2_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_3_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_3_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_4_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_4_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_5_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_5_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_6_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_6_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_7_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_7_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_8_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_8_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_9_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_9_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_10_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_10_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_11_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_11_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_12_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_12_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_13_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_13_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_14_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_14_d41d_poly1305_mac_c_l123_c107_b1b8_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_e076_ITER_15_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_15_d41d_poly1305_mac_c_l123_c107_b1b8_return_output);

     -- a_MUX[poly1305_mac_c_l100_c9_526a] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l100_c9_526a_cond <= VAR_a_MUX_poly1305_mac_c_l100_c9_526a_cond;
     a_MUX_poly1305_mac_c_l100_c9_526a_iftrue <= VAR_a_MUX_poly1305_mac_c_l100_c9_526a_iftrue;
     a_MUX_poly1305_mac_c_l100_c9_526a_iffalse <= VAR_a_MUX_poly1305_mac_c_l100_c9_526a_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l100_c9_526a_return_output := a_MUX_poly1305_mac_c_l100_c9_526a_return_output;

     -- bytes_to_uint320[poly1305_mac_c_l81_c11_f277] LATENCY=0
     -- Inputs
     bytes_to_uint320_poly1305_mac_c_l81_c11_f277_src <= VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_f277_src;
     -- Outputs
     VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_f277_return_output := bytes_to_uint320_poly1305_mac_c_l81_c11_f277_return_output;

     -- poly1305_pipeline_in_valid_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_cond;
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_return_output := poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- poly1305_pipeline_in_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_cond;
     poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_return_output := poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- state_MUX[poly1305_mac_c_l119_c9_921d] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l119_c9_921d_cond <= VAR_state_MUX_poly1305_mac_c_l119_c9_921d_cond;
     state_MUX_poly1305_mac_c_l119_c9_921d_iftrue <= VAR_state_MUX_poly1305_mac_c_l119_c9_921d_iftrue;
     state_MUX_poly1305_mac_c_l119_c9_921d_iffalse <= VAR_state_MUX_poly1305_mac_c_l119_c9_921d_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l119_c9_921d_return_output := state_MUX_poly1305_mac_c_l119_c9_921d_return_output;

     -- poly1305_mac_data_in_ready_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_cond;
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output := poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- s_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     s_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_s_MUX_poly1305_mac_c_l58_c3_115c_cond;
     s_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_s_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     s_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_s_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_s_MUX_poly1305_mac_c_l58_c3_115c_return_output := s_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- Submodule level 3
     VAR_a_MUX_poly1305_mac_c_l86_c9_befd_iffalse := VAR_a_MUX_poly1305_mac_c_l100_c9_526a_return_output;
     VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_iftrue := VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_f277_return_output;
     REG_VAR_is_last_block := VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_115c_return_output;
     VAR_poly1305_mac_data_in_ready := VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_115c_return_output;
     VAR_poly1305_pipeline_in := VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_115c_return_output;
     VAR_poly1305_pipeline_in_valid := VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_115c_return_output;
     REG_VAR_s := VAR_s_MUX_poly1305_mac_c_l58_c3_115c_return_output;
     VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse := VAR_state_MUX_poly1305_mac_c_l119_c9_921d_return_output;
     VAR_state_MUX_poly1305_mac_c_l86_c9_befd_iftrue := VAR_state_MUX_poly1305_mac_c_l97_c5_320e_return_output;
     -- state_MUX[poly1305_mac_c_l114_c9_a8ac] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l114_c9_a8ac_cond <= VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_cond;
     state_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue <= VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue;
     state_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse <= VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_return_output := state_MUX_poly1305_mac_c_l114_c9_a8ac_return_output;

     -- r_MUX[poly1305_mac_c_l67_c5_6f05] LATENCY=0
     -- Inputs
     r_MUX_poly1305_mac_c_l67_c5_6f05_cond <= VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_cond;
     r_MUX_poly1305_mac_c_l67_c5_6f05_iftrue <= VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_iftrue;
     r_MUX_poly1305_mac_c_l67_c5_6f05_iffalse <= VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_iffalse;
     -- Outputs
     VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_return_output := r_MUX_poly1305_mac_c_l67_c5_6f05_return_output;

     -- uint8_array16_le[poly1305_mac_c_l124_c34_b220] LATENCY=0
     VAR_uint8_array16_le_poly1305_mac_c_l124_c34_b220_return_output := uint8_array16_le(
     VAR_CONST_REF_RD_uint8_t_16_uint8_t_16_7a60_poly1305_mac_c_l124_c51_e8d4_return_output);

     -- a_MUX[poly1305_mac_c_l86_c9_befd] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l86_c9_befd_cond <= VAR_a_MUX_poly1305_mac_c_l86_c9_befd_cond;
     a_MUX_poly1305_mac_c_l86_c9_befd_iftrue <= VAR_a_MUX_poly1305_mac_c_l86_c9_befd_iftrue;
     a_MUX_poly1305_mac_c_l86_c9_befd_iffalse <= VAR_a_MUX_poly1305_mac_c_l86_c9_befd_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l86_c9_befd_return_output := a_MUX_poly1305_mac_c_l86_c9_befd_return_output;

     -- Submodule level 4
     VAR_a_MUX_poly1305_mac_c_l58_c3_115c_iffalse := VAR_a_MUX_poly1305_mac_c_l86_c9_befd_return_output;
     VAR_r_MUX_poly1305_mac_c_l58_c3_115c_iftrue := VAR_r_MUX_poly1305_mac_c_l67_c5_6f05_return_output;
     VAR_state_MUX_poly1305_mac_c_l100_c9_526a_iffalse := VAR_state_MUX_poly1305_mac_c_l114_c9_a8ac_return_output;
     -- poly1305_mac_auth_tag_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0[poly1305_mac_c_l119_c9_921d] LATENCY=0
     VAR_poly1305_mac_auth_tag_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_c9_921d_return_output := CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0(
     VAR_uint8_array16_le_poly1305_mac_c_l124_c34_b220_return_output,
     to_unsigned(1, 1));

     -- a_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_a_MUX_poly1305_mac_c_l58_c3_115c_cond;
     a_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_a_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     a_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_a_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l58_c3_115c_return_output := a_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- r_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     r_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_r_MUX_poly1305_mac_c_l58_c3_115c_cond;
     r_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_r_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     r_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_r_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_r_MUX_poly1305_mac_c_l58_c3_115c_return_output := r_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- state_MUX[poly1305_mac_c_l100_c9_526a] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l100_c9_526a_cond <= VAR_state_MUX_poly1305_mac_c_l100_c9_526a_cond;
     state_MUX_poly1305_mac_c_l100_c9_526a_iftrue <= VAR_state_MUX_poly1305_mac_c_l100_c9_526a_iftrue;
     state_MUX_poly1305_mac_c_l100_c9_526a_iffalse <= VAR_state_MUX_poly1305_mac_c_l100_c9_526a_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l100_c9_526a_return_output := state_MUX_poly1305_mac_c_l100_c9_526a_return_output;

     -- Submodule level 5
     REG_VAR_a := VAR_a_MUX_poly1305_mac_c_l58_c3_115c_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iftrue := VAR_poly1305_mac_auth_tag_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_c9_921d_return_output;
     REG_VAR_r := VAR_r_MUX_poly1305_mac_c_l58_c3_115c_return_output;
     VAR_state_MUX_poly1305_mac_c_l86_c9_befd_iffalse := VAR_state_MUX_poly1305_mac_c_l100_c9_526a_return_output;
     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l119_c9_921d] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_return_output;

     -- state_MUX[poly1305_mac_c_l86_c9_befd] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l86_c9_befd_cond <= VAR_state_MUX_poly1305_mac_c_l86_c9_befd_cond;
     state_MUX_poly1305_mac_c_l86_c9_befd_iftrue <= VAR_state_MUX_poly1305_mac_c_l86_c9_befd_iftrue;
     state_MUX_poly1305_mac_c_l86_c9_befd_iffalse <= VAR_state_MUX_poly1305_mac_c_l86_c9_befd_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l86_c9_befd_return_output := state_MUX_poly1305_mac_c_l86_c9_befd_return_output;

     -- Submodule level 6
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_921d_return_output;
     VAR_state_MUX_poly1305_mac_c_l58_c3_115c_iffalse := VAR_state_MUX_poly1305_mac_c_l86_c9_befd_return_output;
     -- state_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_state_MUX_poly1305_mac_c_l58_c3_115c_cond;
     state_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_state_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     state_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_state_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l58_c3_115c_return_output := state_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l114_c9_a8ac] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_return_output;

     -- Submodule level 7
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iffalse := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_a8ac_return_output;
     REG_VAR_state := VAR_state_MUX_poly1305_mac_c_l58_c3_115c_return_output;
     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l100_c9_526a] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_return_output;

     -- Submodule level 8
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iffalse := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_526a_return_output;
     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l86_c9_befd] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_return_output;

     -- Submodule level 9
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iffalse := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_befd_return_output;
     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l58_c3_115c] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_return_output;

     -- Submodule level 10
     VAR_poly1305_mac_auth_tag := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_115c_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_state <= REG_VAR_state;
REG_COMB_is_last_block <= REG_VAR_is_last_block;
REG_COMB_a <= REG_VAR_a;
REG_COMB_r <= REG_VAR_r;
REG_COMB_s <= REG_VAR_s;
-- Global wires driven various places in pipeline
if clk_en_internal='1' then
  module_to_global.poly1305_mac_key_ready <= VAR_poly1305_mac_key_ready;
else
  module_to_global.poly1305_mac_key_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.poly1305_mac_data_in_ready <= VAR_poly1305_mac_data_in_ready;
else
  module_to_global.poly1305_mac_data_in_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.poly1305_mac_auth_tag <= VAR_poly1305_mac_auth_tag;
else
  module_to_global.poly1305_mac_auth_tag <= uint128_t_stream_t_NULL;
end if;
if clk_en_internal='1' then
  module_to_global.poly1305_pipeline_in <= VAR_poly1305_pipeline_in;
else
  module_to_global.poly1305_pipeline_in <= poly1305_mac_loop_body_in_t_NULL;
end if;
if clk_en_internal='1' then
  module_to_global.poly1305_pipeline_in_valid <= VAR_poly1305_pipeline_in_valid;
else
  module_to_global.poly1305_pipeline_in_valid <= to_unsigned(0, 1);
end if;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     state <= REG_COMB_state;
     is_last_block <= REG_COMB_is_last_block;
     a <= REG_COMB_a;
     r <= REG_COMB_r;
     s <= REG_COMB_s;
 end if;
 end if;
end process;

end arch;
