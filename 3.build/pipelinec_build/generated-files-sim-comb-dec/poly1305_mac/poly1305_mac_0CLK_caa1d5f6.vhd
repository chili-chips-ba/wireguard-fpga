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
-- BIN_OP_EQ[poly1305_mac_c_l58_c6_5246]
signal BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output : unsigned(0 downto 0);

-- poly1305_mac_data_in_ready_MUX[poly1305_mac_c_l58_c3_28d7]
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(0 downto 0);

-- poly1305_mac_key_ready_MUX[poly1305_mac_c_l58_c3_28d7]
signal poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(0 downto 0);
signal poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(0 downto 0);
signal poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(0 downto 0);

-- s_MUX[poly1305_mac_c_l58_c3_28d7]
signal s_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal s_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : u320_t;
signal s_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : u320_t;
signal s_MUX_poly1305_mac_c_l58_c3_28d7_return_output : u320_t;

-- a_MUX[poly1305_mac_c_l58_c3_28d7]
signal a_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l58_c3_28d7_return_output : u320_t;

-- poly1305_pipeline_in_valid_MUX[poly1305_mac_c_l58_c3_28d7]
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(0 downto 0);

-- state_MUX[poly1305_mac_c_l58_c3_28d7]
signal state_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(2 downto 0);

-- r_MUX[poly1305_mac_c_l58_c3_28d7]
signal r_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal r_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : u320_t;
signal r_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : u320_t;
signal r_MUX_poly1305_mac_c_l58_c3_28d7_return_output : u320_t;

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l58_c3_28d7]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_return_output : uint128_t_stream_t;

-- poly1305_pipeline_in_MUX[poly1305_mac_c_l58_c3_28d7]
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_return_output : poly1305_mac_loop_body_in_t;

-- is_last_block_MUX[poly1305_mac_c_l58_c3_28d7]
signal is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_mac_c_l67_c8_983d]
signal BIN_OP_AND_poly1305_mac_c_l67_c8_983d_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l67_c8_983d_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l67_c8_983d_return_output : unsigned(0 downto 0);

-- s_MUX[poly1305_mac_c_l67_c5_4603]
signal s_MUX_poly1305_mac_c_l67_c5_4603_cond : unsigned(0 downto 0);
signal s_MUX_poly1305_mac_c_l67_c5_4603_iftrue : u320_t;
signal s_MUX_poly1305_mac_c_l67_c5_4603_iffalse : u320_t;
signal s_MUX_poly1305_mac_c_l67_c5_4603_return_output : u320_t;

-- state_MUX[poly1305_mac_c_l67_c5_4603]
signal state_MUX_poly1305_mac_c_l67_c5_4603_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l67_c5_4603_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l67_c5_4603_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l67_c5_4603_return_output : unsigned(2 downto 0);

-- r_MUX[poly1305_mac_c_l67_c5_4603]
signal r_MUX_poly1305_mac_c_l67_c5_4603_cond : unsigned(0 downto 0);
signal r_MUX_poly1305_mac_c_l67_c5_4603_iftrue : u320_t;
signal r_MUX_poly1305_mac_c_l67_c5_4603_iffalse : u320_t;
signal r_MUX_poly1305_mac_c_l67_c5_4603_return_output : u320_t;

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248[poly1305_mac_c_l69_c162_578f]
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
signal FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);

-- clamp[poly1305_mac_c_l79_c17_f339]
signal clamp_poly1305_mac_c_l79_c17_f339_r : u8_16_t;
signal clamp_poly1305_mac_c_l79_c17_f339_return_output : u8_16_t;

-- bytes_to_uint320[poly1305_mac_c_l81_c11_909c]
signal bytes_to_uint320_poly1305_mac_c_l81_c11_909c_src : uint8_t_40;
signal bytes_to_uint320_poly1305_mac_c_l81_c11_909c_return_output : u320_t;

-- bytes_to_uint320[poly1305_mac_c_l82_c11_4b80]
signal bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_src : uint8_t_40;
signal bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_return_output : u320_t;

-- BIN_OP_EQ[poly1305_mac_c_l86_c12_31f3]
signal BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output : unsigned(0 downto 0);

-- poly1305_mac_data_in_ready_MUX[poly1305_mac_c_l86_c9_6a2a]
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : unsigned(0 downto 0);
signal poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_mac_c_l86_c9_6a2a]
signal a_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : u320_t;

-- poly1305_pipeline_in_valid_MUX[poly1305_mac_c_l86_c9_6a2a]
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : unsigned(0 downto 0);
signal poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : unsigned(0 downto 0);

-- state_MUX[poly1305_mac_c_l86_c9_6a2a]
signal state_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : unsigned(2 downto 0);

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l86_c9_6a2a]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : uint128_t_stream_t;

-- poly1305_pipeline_in_MUX[poly1305_mac_c_l86_c9_6a2a]
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : poly1305_mac_loop_body_in_t;

-- is_last_block_MUX[poly1305_mac_c_l86_c9_6a2a]
signal is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : unsigned(0 downto 0);
signal is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_mac_c_l93_c34_4fb3]
signal BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[poly1305_mac_c_l97_c8_7ffa]
signal BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_return_output : unsigned(0 downto 0);

-- state_MUX[poly1305_mac_c_l97_c5_a5dd]
signal state_MUX_poly1305_mac_c_l97_c5_a5dd_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l97_c5_a5dd_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l97_c5_a5dd_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l97_c5_a5dd_return_output : unsigned(2 downto 0);

-- BIN_OP_EQ[poly1305_mac_c_l100_c12_12fc]
signal BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_mac_c_l100_c9_aeca]
signal a_MUX_poly1305_mac_c_l100_c9_aeca_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l100_c9_aeca_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l100_c9_aeca_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l100_c9_aeca_return_output : u320_t;

-- state_MUX[poly1305_mac_c_l100_c9_aeca]
signal state_MUX_poly1305_mac_c_l100_c9_aeca_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l100_c9_aeca_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l100_c9_aeca_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l100_c9_aeca_return_output : unsigned(2 downto 0);

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l100_c9_aeca]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_return_output : uint128_t_stream_t;

-- a_MUX[poly1305_mac_c_l102_c5_8010]
signal a_MUX_poly1305_mac_c_l102_c5_8010_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l102_c5_8010_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l102_c5_8010_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l102_c5_8010_return_output : u320_t;

-- state_MUX[poly1305_mac_c_l102_c5_8010]
signal state_MUX_poly1305_mac_c_l102_c5_8010_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l102_c5_8010_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l102_c5_8010_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l102_c5_8010_return_output : unsigned(2 downto 0);

-- state_MUX[poly1305_mac_c_l107_c7_fe8d]
signal state_MUX_poly1305_mac_c_l107_c7_fe8d_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l107_c7_fe8d_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l107_c7_fe8d_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l107_c7_fe8d_return_output : unsigned(2 downto 0);

-- BIN_OP_EQ[poly1305_mac_c_l114_c12_0aed]
signal BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_return_output : unsigned(0 downto 0);

-- a_MUX[poly1305_mac_c_l114_c9_98a8]
signal a_MUX_poly1305_mac_c_l114_c9_98a8_cond : unsigned(0 downto 0);
signal a_MUX_poly1305_mac_c_l114_c9_98a8_iftrue : u320_t;
signal a_MUX_poly1305_mac_c_l114_c9_98a8_iffalse : u320_t;
signal a_MUX_poly1305_mac_c_l114_c9_98a8_return_output : u320_t;

-- state_MUX[poly1305_mac_c_l114_c9_98a8]
signal state_MUX_poly1305_mac_c_l114_c9_98a8_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l114_c9_98a8_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l114_c9_98a8_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l114_c9_98a8_return_output : unsigned(2 downto 0);

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l114_c9_98a8]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_return_output : uint128_t_stream_t;

-- uint320_add[poly1305_mac_c_l116_c9_8996]
signal uint320_add_poly1305_mac_c_l116_c9_8996_a : u320_t;
signal uint320_add_poly1305_mac_c_l116_c9_8996_b : u320_t;
signal uint320_add_poly1305_mac_c_l116_c9_8996_return_output : u320_t;

-- BIN_OP_EQ[poly1305_mac_c_l119_c12_b049]
signal BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_left : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_right : unsigned(2 downto 0);
signal BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_return_output : unsigned(0 downto 0);

-- state_MUX[poly1305_mac_c_l119_c9_2a97]
signal state_MUX_poly1305_mac_c_l119_c9_2a97_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l119_c9_2a97_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l119_c9_2a97_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l119_c9_2a97_return_output : unsigned(2 downto 0);

-- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l119_c9_2a97]
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_cond : unsigned(0 downto 0);
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iftrue : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iffalse : uint128_t_stream_t;
signal poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_return_output : uint128_t_stream_t;

-- u320_t_to_bytes[poly1305_mac_c_l121_c34_8d7b]
signal u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_x : u320_t;
signal u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output : uint8_t_array_40_t;

-- BIN_OP_AND[poly1305_mac_c_l126_c8_0ca6]
signal BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_left : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_right : unsigned(0 downto 0);
signal BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_return_output : unsigned(0 downto 0);

-- state_MUX[poly1305_mac_c_l126_c5_0dfb]
signal state_MUX_poly1305_mac_c_l126_c5_0dfb_cond : unsigned(0 downto 0);
signal state_MUX_poly1305_mac_c_l126_c5_0dfb_iftrue : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l126_c5_0dfb_iffalse : unsigned(2 downto 0);
signal state_MUX_poly1305_mac_c_l126_c5_0dfb_return_output : unsigned(2 downto 0);

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
-- BIN_OP_EQ_poly1305_mac_c_l58_c6_5246 : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l58_c6_5246 : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_left,
BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_right,
BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output);

-- poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond,
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- s_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
s_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
s_MUX_poly1305_mac_c_l58_c3_28d7_cond,
s_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
s_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
s_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- a_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
a_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l58_c3_28d7_cond,
a_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
a_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
a_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_cond,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- state_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
state_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l58_c3_28d7_cond,
state_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
state_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
state_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- r_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
r_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
r_MUX_poly1305_mac_c_l58_c3_28d7_cond,
r_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
r_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
r_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_0CLK_de264c78 port map (
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_cond,
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- is_last_block_MUX_poly1305_mac_c_l58_c3_28d7 : 0 clocks latency
is_last_block_MUX_poly1305_mac_c_l58_c3_28d7 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_cond,
is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iftrue,
is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iffalse,
is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_return_output);

-- BIN_OP_AND_poly1305_mac_c_l67_c8_983d : 0 clocks latency
BIN_OP_AND_poly1305_mac_c_l67_c8_983d : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_mac_c_l67_c8_983d_left,
BIN_OP_AND_poly1305_mac_c_l67_c8_983d_right,
BIN_OP_AND_poly1305_mac_c_l67_c8_983d_return_output);

-- s_MUX_poly1305_mac_c_l67_c5_4603 : 0 clocks latency
s_MUX_poly1305_mac_c_l67_c5_4603 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
s_MUX_poly1305_mac_c_l67_c5_4603_cond,
s_MUX_poly1305_mac_c_l67_c5_4603_iftrue,
s_MUX_poly1305_mac_c_l67_c5_4603_iffalse,
s_MUX_poly1305_mac_c_l67_c5_4603_return_output);

-- state_MUX_poly1305_mac_c_l67_c5_4603 : 0 clocks latency
state_MUX_poly1305_mac_c_l67_c5_4603 : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l67_c5_4603_cond,
state_MUX_poly1305_mac_c_l67_c5_4603_iftrue,
state_MUX_poly1305_mac_c_l67_c5_4603_iffalse,
state_MUX_poly1305_mac_c_l67_c5_4603_return_output);

-- r_MUX_poly1305_mac_c_l67_c5_4603 : 0 clocks latency
r_MUX_poly1305_mac_c_l67_c5_4603 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
r_MUX_poly1305_mac_c_l67_c5_4603_cond,
r_MUX_poly1305_mac_c_l67_c5_4603_iftrue,
r_MUX_poly1305_mac_c_l67_c5_4603_iffalse,
r_MUX_poly1305_mac_c_l67_c5_4603_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_0_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_8_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_16_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_24_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_32_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_40_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_48_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_56_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_64_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_72_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_80_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_88_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_96_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_104_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_112_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_120_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_128_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_136_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_144_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_152_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_160_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_168_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_176_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_184_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_192_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_200_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_208_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_216_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_224_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_232_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_240_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_return_output);

-- FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f : 0 clocks latency
FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f : entity work.CONST_SR_248_uint256_t_0CLK_de264c78 port map (
FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_x,
FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_return_output);

-- clamp_poly1305_mac_c_l79_c17_f339 : 0 clocks latency
clamp_poly1305_mac_c_l79_c17_f339 : entity work.clamp_0CLK_295015b8 port map (
clamp_poly1305_mac_c_l79_c17_f339_r,
clamp_poly1305_mac_c_l79_c17_f339_return_output);

-- bytes_to_uint320_poly1305_mac_c_l81_c11_909c : 0 clocks latency
bytes_to_uint320_poly1305_mac_c_l81_c11_909c : entity work.bytes_to_uint320_0CLK_b3848d7a port map (
bytes_to_uint320_poly1305_mac_c_l81_c11_909c_src,
bytes_to_uint320_poly1305_mac_c_l81_c11_909c_return_output);

-- bytes_to_uint320_poly1305_mac_c_l82_c11_4b80 : 0 clocks latency
bytes_to_uint320_poly1305_mac_c_l82_c11_4b80 : entity work.bytes_to_uint320_0CLK_b3848d7a port map (
bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_src,
bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_return_output);

-- BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3 : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3 : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_left,
BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_right,
BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output);

-- poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a : 0 clocks latency
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_cond,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse,
poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_return_output);

-- a_MUX_poly1305_mac_c_l86_c9_6a2a : 0 clocks latency
a_MUX_poly1305_mac_c_l86_c9_6a2a : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l86_c9_6a2a_cond,
a_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue,
a_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse,
a_MUX_poly1305_mac_c_l86_c9_6a2a_return_output);

-- poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a : 0 clocks latency
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_cond,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse,
poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_return_output);

-- state_MUX_poly1305_mac_c_l86_c9_6a2a : 0 clocks latency
state_MUX_poly1305_mac_c_l86_c9_6a2a : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l86_c9_6a2a_cond,
state_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue,
state_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse,
state_MUX_poly1305_mac_c_l86_c9_6a2a_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_return_output);

-- poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a : 0 clocks latency
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a : entity work.MUX_uint1_t_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_0CLK_de264c78 port map (
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_cond,
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue,
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse,
poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_return_output);

-- is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a : 0 clocks latency
is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_cond,
is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue,
is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse,
is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_return_output);

-- BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3 : 0 clocks latency
BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_left,
BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_right,
BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_return_output);

-- BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa : 0 clocks latency
BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_left,
BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_right,
BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_return_output);

-- state_MUX_poly1305_mac_c_l97_c5_a5dd : 0 clocks latency
state_MUX_poly1305_mac_c_l97_c5_a5dd : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l97_c5_a5dd_cond,
state_MUX_poly1305_mac_c_l97_c5_a5dd_iftrue,
state_MUX_poly1305_mac_c_l97_c5_a5dd_iffalse,
state_MUX_poly1305_mac_c_l97_c5_a5dd_return_output);

-- BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_left,
BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_right,
BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_return_output);

-- a_MUX_poly1305_mac_c_l100_c9_aeca : 0 clocks latency
a_MUX_poly1305_mac_c_l100_c9_aeca : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l100_c9_aeca_cond,
a_MUX_poly1305_mac_c_l100_c9_aeca_iftrue,
a_MUX_poly1305_mac_c_l100_c9_aeca_iffalse,
a_MUX_poly1305_mac_c_l100_c9_aeca_return_output);

-- state_MUX_poly1305_mac_c_l100_c9_aeca : 0 clocks latency
state_MUX_poly1305_mac_c_l100_c9_aeca : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l100_c9_aeca_cond,
state_MUX_poly1305_mac_c_l100_c9_aeca_iftrue,
state_MUX_poly1305_mac_c_l100_c9_aeca_iffalse,
state_MUX_poly1305_mac_c_l100_c9_aeca_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_return_output);

-- a_MUX_poly1305_mac_c_l102_c5_8010 : 0 clocks latency
a_MUX_poly1305_mac_c_l102_c5_8010 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l102_c5_8010_cond,
a_MUX_poly1305_mac_c_l102_c5_8010_iftrue,
a_MUX_poly1305_mac_c_l102_c5_8010_iffalse,
a_MUX_poly1305_mac_c_l102_c5_8010_return_output);

-- state_MUX_poly1305_mac_c_l102_c5_8010 : 0 clocks latency
state_MUX_poly1305_mac_c_l102_c5_8010 : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l102_c5_8010_cond,
state_MUX_poly1305_mac_c_l102_c5_8010_iftrue,
state_MUX_poly1305_mac_c_l102_c5_8010_iffalse,
state_MUX_poly1305_mac_c_l102_c5_8010_return_output);

-- state_MUX_poly1305_mac_c_l107_c7_fe8d : 0 clocks latency
state_MUX_poly1305_mac_c_l107_c7_fe8d : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l107_c7_fe8d_cond,
state_MUX_poly1305_mac_c_l107_c7_fe8d_iftrue,
state_MUX_poly1305_mac_c_l107_c7_fe8d_iffalse,
state_MUX_poly1305_mac_c_l107_c7_fe8d_return_output);

-- BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_left,
BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_right,
BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_return_output);

-- a_MUX_poly1305_mac_c_l114_c9_98a8 : 0 clocks latency
a_MUX_poly1305_mac_c_l114_c9_98a8 : entity work.MUX_uint1_t_u320_t_u320_t_0CLK_de264c78 port map (
a_MUX_poly1305_mac_c_l114_c9_98a8_cond,
a_MUX_poly1305_mac_c_l114_c9_98a8_iftrue,
a_MUX_poly1305_mac_c_l114_c9_98a8_iffalse,
a_MUX_poly1305_mac_c_l114_c9_98a8_return_output);

-- state_MUX_poly1305_mac_c_l114_c9_98a8 : 0 clocks latency
state_MUX_poly1305_mac_c_l114_c9_98a8 : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l114_c9_98a8_cond,
state_MUX_poly1305_mac_c_l114_c9_98a8_iftrue,
state_MUX_poly1305_mac_c_l114_c9_98a8_iffalse,
state_MUX_poly1305_mac_c_l114_c9_98a8_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8 : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8 : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_return_output);

-- uint320_add_poly1305_mac_c_l116_c9_8996 : 0 clocks latency
uint320_add_poly1305_mac_c_l116_c9_8996 : entity work.uint320_add_0CLK_10d8c973 port map (
uint320_add_poly1305_mac_c_l116_c9_8996_a,
uint320_add_poly1305_mac_c_l116_c9_8996_b,
uint320_add_poly1305_mac_c_l116_c9_8996_return_output);

-- BIN_OP_EQ_poly1305_mac_c_l119_c12_b049 : 0 clocks latency
BIN_OP_EQ_poly1305_mac_c_l119_c12_b049 : entity work.BIN_OP_EQ_uint3_t_uint3_t_0CLK_de264c78 port map (
BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_left,
BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_right,
BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_return_output);

-- state_MUX_poly1305_mac_c_l119_c9_2a97 : 0 clocks latency
state_MUX_poly1305_mac_c_l119_c9_2a97 : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l119_c9_2a97_cond,
state_MUX_poly1305_mac_c_l119_c9_2a97_iftrue,
state_MUX_poly1305_mac_c_l119_c9_2a97_iffalse,
state_MUX_poly1305_mac_c_l119_c9_2a97_return_output);

-- poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97 : 0 clocks latency
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97 : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_cond,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iftrue,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iffalse,
poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_return_output);

-- u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b : 0 clocks latency
u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b : entity work.u320_t_to_bytes_0CLK_801a240b port map (
u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_x,
u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output);

-- BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6 : 0 clocks latency
BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_left,
BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_right,
BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_return_output);

-- state_MUX_poly1305_mac_c_l126_c5_0dfb : 0 clocks latency
state_MUX_poly1305_mac_c_l126_c5_0dfb : entity work.MUX_uint1_t_poly1305_state_t_poly1305_state_t_0CLK_de264c78 port map (
state_MUX_poly1305_mac_c_l126_c5_0dfb_cond,
state_MUX_poly1305_mac_c_l126_c5_0dfb_iftrue,
state_MUX_poly1305_mac_c_l126_c5_0dfb_iffalse,
state_MUX_poly1305_mac_c_l126_c5_0dfb_return_output);



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
 BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output,
 poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 s_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 a_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 state_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 r_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_return_output,
 BIN_OP_AND_poly1305_mac_c_l67_c8_983d_return_output,
 s_MUX_poly1305_mac_c_l67_c5_4603_return_output,
 state_MUX_poly1305_mac_c_l67_c5_4603_return_output,
 r_MUX_poly1305_mac_c_l67_c5_4603_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_return_output,
 FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_return_output,
 clamp_poly1305_mac_c_l79_c17_f339_return_output,
 bytes_to_uint320_poly1305_mac_c_l81_c11_909c_return_output,
 bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_return_output,
 BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output,
 poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_return_output,
 a_MUX_poly1305_mac_c_l86_c9_6a2a_return_output,
 poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_return_output,
 state_MUX_poly1305_mac_c_l86_c9_6a2a_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_return_output,
 poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_return_output,
 is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_return_output,
 BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_return_output,
 BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_return_output,
 state_MUX_poly1305_mac_c_l97_c5_a5dd_return_output,
 BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_return_output,
 a_MUX_poly1305_mac_c_l100_c9_aeca_return_output,
 state_MUX_poly1305_mac_c_l100_c9_aeca_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_return_output,
 a_MUX_poly1305_mac_c_l102_c5_8010_return_output,
 state_MUX_poly1305_mac_c_l102_c5_8010_return_output,
 state_MUX_poly1305_mac_c_l107_c7_fe8d_return_output,
 BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_return_output,
 a_MUX_poly1305_mac_c_l114_c9_98a8_return_output,
 state_MUX_poly1305_mac_c_l114_c9_98a8_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_return_output,
 uint320_add_poly1305_mac_c_l116_c9_8996_return_output,
 BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_return_output,
 state_MUX_poly1305_mac_c_l119_c9_2a97_return_output,
 poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_return_output,
 u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output,
 BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_return_output,
 state_MUX_poly1305_mac_c_l126_c5_0dfb_return_output)
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
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l67_c5_4603_return_output : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_return_output : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l67_c5_4603_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l67_c5_4603_return_output : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_return_output : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_return_output : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iftrue : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iffalse : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_return_output : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_return_output : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_cond : unsigned(0 downto 0);
 variable VAR_u320_null : u320_t;
 variable VAR_CONST_REF_RD_uint1_t_uint256_t_stream_t_valid_d41d_poly1305_mac_c_l67_c8_1732_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_return_output : unsigned(0 downto 0);
 variable VAR_s_MUX_poly1305_mac_c_l67_c5_4603_iftrue : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l67_c5_4603_iffalse : u320_t;
 variable VAR_s_MUX_poly1305_mac_c_l67_c5_4603_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l67_c5_4603_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l67_c5_4603_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l67_c5_4603_cond : unsigned(0 downto 0);
 variable VAR_r_MUX_poly1305_mac_c_l67_c5_4603_iftrue : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l67_c5_4603_iffalse : u320_t;
 variable VAR_r_MUX_poly1305_mac_c_l67_c5_4603_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_key : uint8_t_32;
 variable VAR_UINT_TO_BYTE_ARRAY_i : unsigned(31 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_poly1305_mac_data_key_0_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_poly1305_mac_data_key_1_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_poly1305_mac_data_key_2_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_poly1305_mac_data_key_3_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_poly1305_mac_data_key_4_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_poly1305_mac_data_key_5_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_poly1305_mac_data_key_6_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_poly1305_mac_data_key_7_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_poly1305_mac_data_key_8_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_poly1305_mac_data_key_9_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_poly1305_mac_data_key_10_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_poly1305_mac_data_key_11_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_poly1305_mac_data_key_12_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_poly1305_mac_data_key_13_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_poly1305_mac_data_key_14_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_poly1305_mac_data_key_15_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_poly1305_mac_data_key_16_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_poly1305_mac_data_key_17_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_poly1305_mac_data_key_18_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_poly1305_mac_data_key_19_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_poly1305_mac_data_key_20_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_poly1305_mac_data_key_21_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_poly1305_mac_data_key_22_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_poly1305_mac_data_key_23_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_poly1305_mac_data_key_24_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_poly1305_mac_data_key_25_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_poly1305_mac_data_key_26_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_poly1305_mac_data_key_27_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_poly1305_mac_data_key_28_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_poly1305_mac_data_key_29_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_poly1305_mac_data_key_30_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_poly1305_mac_data_key_31_poly1305_mac_c_l69_c116_83d2 : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_return_output : unsigned(255 downto 0);
 variable VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_x : unsigned(255 downto 0);
 variable VAR_r_bytes : u8_16_t;
 variable VAR_s_bytes : u8_16_t;
 variable VAR_i : signed(31 downto 0);
 variable VAR_clamp_poly1305_mac_c_l79_c17_f339_r : u8_16_t;
 variable VAR_CONST_REF_RD_u8_16_t_u8_16_t_7cf3_poly1305_mac_c_l79_c23_7cfd_return_output : u8_16_t;
 variable VAR_clamp_poly1305_mac_c_l79_c17_f339_return_output : u8_16_t;
 variable VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_909c_src : uint8_t_40;
 variable VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_d41d_poly1305_mac_c_l81_c28_e13d_return_output : uint8_t_16;
 variable VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_909c_return_output : u320_t;
 variable VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_src : uint8_t_40;
 variable VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3_poly1305_mac_c_l82_c28_27ed_return_output : uint8_t_16;
 variable VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_return_output : u320_t;
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_TRUE_INPUT_MUX_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55_poly1305_mac_c_l86_c9_6a2a_return_output : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse : unsigned(0 downto 0);
 variable VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d_poly1305_mac_c_l90_c40_7dd6_return_output : uint8_t_16;
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_poly1305_mac_c_l93_c34_83e6_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_poly1305_mac_c_l95_c21_8909_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_return_output : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l102_c5_8010_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_return_output : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l102_c5_8010_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_cond : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l102_c5_8010_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l102_c5_8010_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l102_c5_8010_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l102_c5_8010_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l102_c5_8010_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l102_c5_8010_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_return_output : unsigned(0 downto 0);
 variable VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_iftrue : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_iffalse : u320_t;
 variable VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_cond : unsigned(0 downto 0);
 variable VAR_uint320_add_poly1305_mac_c_l116_c9_8996_a : u320_t;
 variable VAR_uint320_add_poly1305_mac_c_l116_c9_8996_b : u320_t;
 variable VAR_uint320_add_poly1305_mac_c_l116_c9_8996_return_output : u320_t;
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_left : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_right : unsigned(2 downto 0);
 variable VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_return_output : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_cond : unsigned(0 downto 0);
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iftrue : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_c9_2a97_return_output : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iffalse : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_cond : unsigned(0 downto 0);
 variable VAR_a_bytes : uint8_t_array_40_t;
 variable VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_x : u320_t;
 variable VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output : uint8_t_array_40_t;
 variable VAR_auth_tag : uint8_t_16;
 variable VAR_ARRAY_COPY_i : unsigned(31 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_0_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_0_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_1_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_1_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_2_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_2_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_3_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_3_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_4_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_4_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_5_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_5_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_6_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_6_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_7_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_7_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_8_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_8_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_9_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_9_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_10_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_10_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_11_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_11_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_12_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_12_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_13_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_13_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_14_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_14_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_15_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_15_d41d_poly1305_mac_c_l123_c107_ff74_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_16_uint8_t_16_7a60_poly1305_mac_c_l124_c51_44ce_return_output : uint8_t_16;
 variable VAR_uint8_array16_le_poly1305_mac_c_l124_c34_dec3_return_output : unsigned(127 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_iftrue : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_iffalse : unsigned(2 downto 0);
 variable VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output : unsigned(255 downto 0);
 variable VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_l100_l58_l114_l86_DUPLICATE_83f6_return_output : uint128_t_stream_t;
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
     VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_right := unsigned(poly1305_state_t_to_slv(START_ITER));
     VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_iftrue := unsigned(poly1305_state_t_to_slv(FINISH_ITER));
     VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_right := to_unsigned(1, 1);
     VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := to_unsigned(1, 1);
     VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := to_unsigned(0, 1);
     VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_right := unsigned(poly1305_state_t_to_slv(OUTPUT_AUTH_TAG));
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse := poly1305_mac_loop_body_in_t_NULL;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := poly1305_mac_loop_body_in_t_NULL;
     VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_iftrue := unsigned(poly1305_state_t_to_slv(A_PLUS_S));
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse := to_unsigned(0, 1);
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := to_unsigned(0, 1);
     VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_right := unsigned(poly1305_state_t_to_slv(FINISH_ITER));
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse := to_unsigned(0, 1);
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := to_unsigned(0, 1);
     VAR_s_MUX_poly1305_mac_c_l67_c5_4603_iffalse := u320_t_NULL;
     VAR_r_MUX_poly1305_mac_c_l67_c5_4603_iffalse := u320_t_NULL;
     VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := u320_t_NULL;
     VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_left := to_unsigned(1, 1);
     VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_right := unsigned(poly1305_state_t_to_slv(IDLE));
     VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := to_unsigned(0, 1);
     VAR_state_MUX_poly1305_mac_c_l67_c5_4603_iftrue := unsigned(poly1305_state_t_to_slv(START_ITER));
     VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_iffalse := unsigned(poly1305_state_t_to_slv(START_ITER));
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue := to_unsigned(1, 1);
     VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_right := to_unsigned(1, 1);
     VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_right := to_unsigned(1, 1);
     VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_iftrue := unsigned(poly1305_state_t_to_slv(OUTPUT_AUTH_TAG));
     VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_right := unsigned(poly1305_state_t_to_slv(A_PLUS_S));
     VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_iftrue := unsigned(poly1305_state_t_to_slv(IDLE));
     -- CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_l100_l58_l114_l86_DUPLICATE_83f6 LATENCY=0
     VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_l100_l58_l114_l86_DUPLICATE_83f6_return_output := CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0(
     to_unsigned(0, 128),
     to_unsigned(0, 1));

     -- Submodule level 1
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iffalse := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_l100_l58_l114_l86_DUPLICATE_83f6_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_l100_l58_l114_l86_DUPLICATE_83f6_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_l100_l58_l114_l86_DUPLICATE_83f6_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iftrue := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_l100_l58_l114_l86_DUPLICATE_83f6_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iftrue := VAR_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_l100_l58_l114_l86_DUPLICATE_83f6_return_output;
 -- Reads from global variables
     VAR_poly1305_mac_key := global_to_module.poly1305_mac_key;
     VAR_poly1305_mac_data_in := global_to_module.poly1305_mac_data_in;
     VAR_poly1305_pipeline_out_valid := global_to_module.poly1305_pipeline_out_valid;
     VAR_poly1305_pipeline_out := global_to_module.poly1305_pipeline_out;
     VAR_poly1305_mac_auth_tag_ready := global_to_module.poly1305_mac_auth_tag_ready;
     -- Submodule level 0
     VAR_a_MUX_poly1305_mac_c_l102_c5_8010_iftrue := VAR_poly1305_pipeline_out;
     VAR_a_MUX_poly1305_mac_c_l102_c5_8010_cond := VAR_poly1305_pipeline_out_valid;
     VAR_state_MUX_poly1305_mac_c_l102_c5_8010_cond := VAR_poly1305_pipeline_out_valid;
     VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_right := VAR_poly1305_mac_auth_tag_ready;
     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d[poly1305_mac_c_l93_c34_83e6] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_poly1305_mac_c_l93_c34_83e6_return_output := VAR_poly1305_mac_data_in.valid;

     -- CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d[poly1305_mac_c_l69_c162_8d86]_DUPLICATE_c06e LATENCY=0
     VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output := VAR_poly1305_mac_key.data;

     -- CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d[poly1305_mac_c_l90_c40_7dd6] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d_poly1305_mac_c_l90_c40_7dd6_return_output := VAR_poly1305_mac_data_in.data.tdata;

     -- CONST_REF_RD_uint1_t_uint256_t_stream_t_valid_d41d[poly1305_mac_c_l67_c8_1732] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_uint256_t_stream_t_valid_d41d_poly1305_mac_c_l67_c8_1732_return_output := VAR_poly1305_mac_key.valid;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[poly1305_mac_c_l95_c21_8909] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_poly1305_mac_c_l95_c21_8909_return_output := VAR_poly1305_mac_data_in.data.tlast;

     -- Submodule level 1
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_x := VAR_CONST_REF_RD_uint256_t_uint256_t_stream_t_data_d41d_poly1305_mac_c_l69_c162_8d86_DUPLICATE_c06e_return_output;
     VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_poly1305_mac_c_l93_c34_83e6_return_output;
     VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_left := VAR_CONST_REF_RD_uint1_t_uint256_t_stream_t_valid_d41d_poly1305_mac_c_l67_c8_1732_return_output;
     VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_poly1305_mac_c_l95_c21_8909_return_output;
     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_return_output;

     -- FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56[poly1305_mac_c_l69_c162_578f] LATENCY=0
     -- Inputs
     FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_x <= VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_x;
     -- Outputs
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_return_output := FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_return_output;

     -- Submodule level 2
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_poly1305_mac_data_key_29_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_CONST_SR_232_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_poly1305_mac_data_key_6_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_CONST_SR_48_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_poly1305_mac_data_key_15_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_CONST_SR_120_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_poly1305_mac_data_key_16_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_CONST_SR_128_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_poly1305_mac_data_key_30_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_CONST_SR_240_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_poly1305_mac_data_key_22_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_CONST_SR_176_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_poly1305_mac_data_key_11_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_CONST_SR_88_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_poly1305_mac_data_key_10_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_CONST_SR_80_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_poly1305_mac_data_key_14_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_CONST_SR_112_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_poly1305_mac_data_key_21_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_CONST_SR_168_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_poly1305_mac_data_key_26_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_CONST_SR_208_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_poly1305_mac_data_key_0_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_CONST_SR_0_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_poly1305_mac_data_key_20_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_CONST_SR_160_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_poly1305_mac_data_key_4_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_CONST_SR_32_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_poly1305_mac_data_key_31_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_CONST_SR_248_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_poly1305_mac_data_key_8_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_CONST_SR_64_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_poly1305_mac_data_key_7_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_CONST_SR_56_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_poly1305_mac_data_key_25_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_CONST_SR_200_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_poly1305_mac_data_key_1_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_CONST_SR_8_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_poly1305_mac_data_key_28_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_CONST_SR_224_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_poly1305_mac_data_key_5_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_CONST_SR_40_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_poly1305_mac_data_key_3_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_CONST_SR_24_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_poly1305_mac_data_key_9_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_CONST_SR_72_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_poly1305_mac_data_key_13_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_CONST_SR_104_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_poly1305_mac_data_key_24_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_CONST_SR_192_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_poly1305_mac_data_key_12_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_CONST_SR_96_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_poly1305_mac_data_key_19_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_CONST_SR_152_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_poly1305_mac_data_key_2_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_CONST_SR_16_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_poly1305_mac_data_key_17_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_CONST_SR_136_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_poly1305_mac_data_key_27_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_CONST_SR_216_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_poly1305_mac_data_key_18_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_CONST_SR_144_poly1305_mac_c_l69_c162_578f_return_output, 8);
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_poly1305_mac_data_key_23_poly1305_mac_c_l69_c116_83d2 := resize(VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_CONST_SR_184_poly1305_mac_c_l69_c162_578f_return_output, 8);
     -- CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3[poly1305_mac_c_l82_c28_27ed] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3_poly1305_mac_c_l82_c28_27ed_return_output := CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3(
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_16_poly1305_mac_data_key_16_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_17_poly1305_mac_data_key_17_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_18_poly1305_mac_data_key_18_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_19_poly1305_mac_data_key_19_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_20_poly1305_mac_data_key_20_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_21_poly1305_mac_data_key_21_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_22_poly1305_mac_data_key_22_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_23_poly1305_mac_data_key_23_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_24_poly1305_mac_data_key_24_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_25_poly1305_mac_data_key_25_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_26_poly1305_mac_data_key_26_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_27_poly1305_mac_data_key_27_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_28_poly1305_mac_data_key_28_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_29_poly1305_mac_data_key_29_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_30_poly1305_mac_data_key_30_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_31_poly1305_mac_data_key_31_poly1305_mac_c_l69_c116_83d2);

     -- CONST_REF_RD_u8_16_t_u8_16_t_7cf3[poly1305_mac_c_l79_c23_7cfd] LATENCY=0
     VAR_CONST_REF_RD_u8_16_t_u8_16_t_7cf3_poly1305_mac_c_l79_c23_7cfd_return_output := CONST_REF_RD_u8_16_t_u8_16_t_7cf3(
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_0_poly1305_mac_data_key_0_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_1_poly1305_mac_data_key_1_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_2_poly1305_mac_data_key_2_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_3_poly1305_mac_data_key_3_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_4_poly1305_mac_data_key_4_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_5_poly1305_mac_data_key_5_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_6_poly1305_mac_data_key_6_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_7_poly1305_mac_data_key_7_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_8_poly1305_mac_data_key_8_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_9_poly1305_mac_data_key_9_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_10_poly1305_mac_data_key_10_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_11_poly1305_mac_data_key_11_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_12_poly1305_mac_data_key_12_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_13_poly1305_mac_data_key_13_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_14_poly1305_mac_data_key_14_poly1305_mac_c_l69_c116_83d2,
     VAR_FOR_poly1305_mac_c_l69_c38_ea92_ITER_15_poly1305_mac_data_key_15_poly1305_mac_c_l69_c116_83d2);

     -- Submodule level 3
     VAR_clamp_poly1305_mac_c_l79_c17_f339_r := VAR_CONST_REF_RD_u8_16_t_u8_16_t_7cf3_poly1305_mac_c_l79_c23_7cfd_return_output;
     VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_src := (0 to 15 => VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_7cf3_poly1305_mac_c_l82_c28_27ed_return_output, others => to_unsigned(0, 8));

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_a_MUX_poly1305_mac_c_l102_c5_8010_iffalse := a;
     VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_iffalse := a;
     VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue := a;
     VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_x := a;
     VAR_uint320_add_poly1305_mac_c_l116_c9_8996_a := a;
     VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse := is_last_block;
     VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_cond := is_last_block;
     VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := r;
     VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := s;
     VAR_uint320_add_poly1305_mac_c_l116_c9_8996_b := s;
     VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_left := state;
     VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_left := state;
     VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_left := state;
     VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_left := state;
     VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_left := state;
     VAR_state_MUX_poly1305_mac_c_l102_c5_8010_iffalse := state;
     VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_iffalse := state;
     VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_iffalse := state;
     VAR_state_MUX_poly1305_mac_c_l67_c5_4603_iffalse := state;
     VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_iffalse := state;
     -- BIN_OP_AND[poly1305_mac_c_l93_c34_4fb3] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_left <= VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_left;
     BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_right <= VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_return_output := BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_return_output;

     -- state_MUX[poly1305_mac_c_l107_c7_fe8d] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l107_c7_fe8d_cond <= VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_cond;
     state_MUX_poly1305_mac_c_l107_c7_fe8d_iftrue <= VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_iftrue;
     state_MUX_poly1305_mac_c_l107_c7_fe8d_iffalse <= VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_return_output := state_MUX_poly1305_mac_c_l107_c7_fe8d_return_output;

     -- clamp[poly1305_mac_c_l79_c17_f339] LATENCY=0
     -- Inputs
     clamp_poly1305_mac_c_l79_c17_f339_r <= VAR_clamp_poly1305_mac_c_l79_c17_f339_r;
     -- Outputs
     VAR_clamp_poly1305_mac_c_l79_c17_f339_return_output := clamp_poly1305_mac_c_l79_c17_f339_return_output;

     -- u320_t_to_bytes[poly1305_mac_c_l121_c34_8d7b] LATENCY=0
     -- Inputs
     u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_x <= VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_x;
     -- Outputs
     VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output := u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output;

     -- BIN_OP_EQ[poly1305_mac_c_l119_c12_b049] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_left;
     BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_return_output := BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_return_output;

     -- a_MUX[poly1305_mac_c_l102_c5_8010] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l102_c5_8010_cond <= VAR_a_MUX_poly1305_mac_c_l102_c5_8010_cond;
     a_MUX_poly1305_mac_c_l102_c5_8010_iftrue <= VAR_a_MUX_poly1305_mac_c_l102_c5_8010_iftrue;
     a_MUX_poly1305_mac_c_l102_c5_8010_iffalse <= VAR_a_MUX_poly1305_mac_c_l102_c5_8010_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l102_c5_8010_return_output := a_MUX_poly1305_mac_c_l102_c5_8010_return_output;

     -- BIN_OP_EQ[poly1305_mac_c_l58_c6_5246] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_left;
     BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output := BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;

     -- uint320_add[poly1305_mac_c_l116_c9_8996] LATENCY=0
     -- Inputs
     uint320_add_poly1305_mac_c_l116_c9_8996_a <= VAR_uint320_add_poly1305_mac_c_l116_c9_8996_a;
     uint320_add_poly1305_mac_c_l116_c9_8996_b <= VAR_uint320_add_poly1305_mac_c_l116_c9_8996_b;
     -- Outputs
     VAR_uint320_add_poly1305_mac_c_l116_c9_8996_return_output := uint320_add_poly1305_mac_c_l116_c9_8996_return_output;

     -- BIN_OP_EQ[poly1305_mac_c_l100_c12_12fc] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_left;
     BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_return_output := BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_return_output;

     -- poly1305_pipeline_in_TRUE_INPUT_MUX_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55[poly1305_mac_c_l86_c9_6a2a] LATENCY=0
     VAR_poly1305_pipeline_in_TRUE_INPUT_MUX_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55_poly1305_mac_c_l86_c9_6a2a_return_output := CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55(
     VAR_CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d_poly1305_mac_c_l90_c40_7dd6_return_output,
     a,
     r);

     -- BIN_OP_EQ[poly1305_mac_c_l86_c12_31f3] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_left;
     BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output := BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output;

     -- BIN_OP_EQ[poly1305_mac_c_l114_c12_0aed] LATENCY=0
     -- Inputs
     BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_left <= VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_left;
     BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_right <= VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_right;
     -- Outputs
     VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_return_output := BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_return_output;

     -- BIN_OP_AND[poly1305_mac_c_l126_c8_0ca6] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_left <= VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_left;
     BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_right <= VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_return_output := BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_return_output;

     -- BIN_OP_AND[poly1305_mac_c_l67_c8_983d] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_mac_c_l67_c8_983d_left <= VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_left;
     BIN_OP_AND_poly1305_mac_c_l67_c8_983d_right <= VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_return_output := BIN_OP_AND_poly1305_mac_c_l67_c8_983d_return_output;

     -- bytes_to_uint320[poly1305_mac_c_l82_c11_4b80] LATENCY=0
     -- Inputs
     bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_src <= VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_src;
     -- Outputs
     VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_return_output := bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_return_output;

     -- Submodule level 1
     VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_cond := VAR_BIN_OP_AND_poly1305_mac_c_l126_c8_0ca6_return_output;
     VAR_r_MUX_poly1305_mac_c_l67_c5_4603_cond := VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_return_output;
     VAR_s_MUX_poly1305_mac_c_l67_c5_4603_cond := VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_return_output;
     VAR_state_MUX_poly1305_mac_c_l67_c5_4603_cond := VAR_BIN_OP_AND_poly1305_mac_c_l67_c8_983d_return_output;
     VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_left := VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_return_output;
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue := VAR_BIN_OP_AND_poly1305_mac_c_l93_c34_4fb3_return_output;
     VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_return_output;
     VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l100_c12_12fc_return_output;
     VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_return_output;
     VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l114_c12_0aed_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_return_output;
     VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l119_c12_b049_return_output;
     VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l58_c6_5246_return_output;
     VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output;
     VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output;
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output;
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output;
     VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_cond := VAR_BIN_OP_EQ_poly1305_mac_c_l86_c12_31f3_return_output;
     VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_iftrue := VAR_a_MUX_poly1305_mac_c_l102_c5_8010_return_output;
     VAR_s_MUX_poly1305_mac_c_l67_c5_4603_iftrue := VAR_bytes_to_uint320_poly1305_mac_c_l82_c11_4b80_return_output;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue := VAR_poly1305_pipeline_in_TRUE_INPUT_MUX_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_mac_loop_body_in_t_bc55_poly1305_mac_c_l86_c9_6a2a_return_output;
     VAR_state_MUX_poly1305_mac_c_l102_c5_8010_iftrue := VAR_state_MUX_poly1305_mac_c_l107_c7_fe8d_return_output;
     VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_iftrue := VAR_uint320_add_poly1305_mac_c_l116_c9_8996_return_output;
     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_3_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_3_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_3_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_3_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(3);

     -- a_MUX[poly1305_mac_c_l114_c9_98a8] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l114_c9_98a8_cond <= VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_cond;
     a_MUX_poly1305_mac_c_l114_c9_98a8_iftrue <= VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_iftrue;
     a_MUX_poly1305_mac_c_l114_c9_98a8_iffalse <= VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_return_output := a_MUX_poly1305_mac_c_l114_c9_98a8_return_output;

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_2_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_2_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_2_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_2_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(2);

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_15_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_15_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_15_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_15_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(15);

     -- CONST_REF_RD_uint8_t_16_u8_16_t_bytes_d41d[poly1305_mac_c_l81_c28_e13d] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_d41d_poly1305_mac_c_l81_c28_e13d_return_output := VAR_clamp_poly1305_mac_c_l79_c17_f339_return_output.bytes;

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_7_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_7_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_7_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_7_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(7);

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_14_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_14_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_14_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_14_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(14);

     -- s_MUX[poly1305_mac_c_l67_c5_4603] LATENCY=0
     -- Inputs
     s_MUX_poly1305_mac_c_l67_c5_4603_cond <= VAR_s_MUX_poly1305_mac_c_l67_c5_4603_cond;
     s_MUX_poly1305_mac_c_l67_c5_4603_iftrue <= VAR_s_MUX_poly1305_mac_c_l67_c5_4603_iftrue;
     s_MUX_poly1305_mac_c_l67_c5_4603_iffalse <= VAR_s_MUX_poly1305_mac_c_l67_c5_4603_iffalse;
     -- Outputs
     VAR_s_MUX_poly1305_mac_c_l67_c5_4603_return_output := s_MUX_poly1305_mac_c_l67_c5_4603_return_output;

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_6_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_6_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_6_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_6_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(6);

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_1_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_1_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_1_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_1_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(1);

     -- is_last_block_MUX[poly1305_mac_c_l86_c9_6a2a] LATENCY=0
     -- Inputs
     is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_cond <= VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_cond;
     is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue <= VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue;
     is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse <= VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse;
     -- Outputs
     VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_return_output := is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_10_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_10_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_10_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_10_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(10);

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_4_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_4_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_4_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_4_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(4);

     -- state_MUX[poly1305_mac_c_l102_c5_8010] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l102_c5_8010_cond <= VAR_state_MUX_poly1305_mac_c_l102_c5_8010_cond;
     state_MUX_poly1305_mac_c_l102_c5_8010_iftrue <= VAR_state_MUX_poly1305_mac_c_l102_c5_8010_iftrue;
     state_MUX_poly1305_mac_c_l102_c5_8010_iffalse <= VAR_state_MUX_poly1305_mac_c_l102_c5_8010_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l102_c5_8010_return_output := state_MUX_poly1305_mac_c_l102_c5_8010_return_output;

     -- poly1305_pipeline_in_MUX[poly1305_mac_c_l86_c9_6a2a] LATENCY=0
     -- Inputs
     poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_cond <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_cond;
     poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue;
     poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse;
     -- Outputs
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_return_output := poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_11_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_11_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_11_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_11_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(11);

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_0_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_0_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_0_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_0_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(0);

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_13_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_13_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_13_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_13_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(13);

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_5_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_5_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_5_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_5_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(5);

     -- poly1305_pipeline_in_valid_MUX[poly1305_mac_c_l86_c9_6a2a] LATENCY=0
     -- Inputs
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_cond <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_cond;
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue;
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse;
     -- Outputs
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_return_output := poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_12_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_12_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_12_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_12_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(12);

     -- poly1305_mac_key_ready_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output := poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- poly1305_mac_data_in_ready_MUX[poly1305_mac_c_l86_c9_6a2a] LATENCY=0
     -- Inputs
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_cond <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_cond;
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue;
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse;
     -- Outputs
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_return_output := poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;

     -- BIN_OP_AND[poly1305_mac_c_l97_c8_7ffa] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_left <= VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_left;
     BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_right <= VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_return_output := BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_return_output;

     -- state_MUX[poly1305_mac_c_l126_c5_0dfb] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l126_c5_0dfb_cond <= VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_cond;
     state_MUX_poly1305_mac_c_l126_c5_0dfb_iftrue <= VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_iftrue;
     state_MUX_poly1305_mac_c_l126_c5_0dfb_iffalse <= VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_return_output := state_MUX_poly1305_mac_c_l126_c5_0dfb_return_output;

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_9_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_9_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_9_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_9_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(9);

     -- FOR_poly1305_mac_c_l123_c28_b7c1_ITER_8_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_8_d41d[poly1305_mac_c_l123_c107_ff74] LATENCY=0
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_8_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_8_d41d_poly1305_mac_c_l123_c107_ff74_return_output := VAR_u320_t_to_bytes_poly1305_mac_c_l121_c34_8d7b_return_output.data(8);

     -- state_MUX[poly1305_mac_c_l67_c5_4603] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l67_c5_4603_cond <= VAR_state_MUX_poly1305_mac_c_l67_c5_4603_cond;
     state_MUX_poly1305_mac_c_l67_c5_4603_iftrue <= VAR_state_MUX_poly1305_mac_c_l67_c5_4603_iftrue;
     state_MUX_poly1305_mac_c_l67_c5_4603_iffalse <= VAR_state_MUX_poly1305_mac_c_l67_c5_4603_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l67_c5_4603_return_output := state_MUX_poly1305_mac_c_l67_c5_4603_return_output;

     -- Submodule level 2
     VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_cond := VAR_BIN_OP_AND_poly1305_mac_c_l97_c8_7ffa_return_output;
     VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_909c_src := (0 to 15 => VAR_CONST_REF_RD_uint8_t_16_u8_16_t_bytes_d41d_poly1305_mac_c_l81_c28_e13d_return_output, others => to_unsigned(0, 8));
     VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_iffalse := VAR_a_MUX_poly1305_mac_c_l114_c9_98a8_return_output;
     VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := VAR_is_last_block_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;
     VAR_poly1305_mac_key_ready := VAR_poly1305_mac_key_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;
     VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := VAR_s_MUX_poly1305_mac_c_l67_c5_4603_return_output;
     VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_iftrue := VAR_state_MUX_poly1305_mac_c_l102_c5_8010_return_output;
     VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_iftrue := VAR_state_MUX_poly1305_mac_c_l126_c5_0dfb_return_output;
     VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := VAR_state_MUX_poly1305_mac_c_l67_c5_4603_return_output;
     -- bytes_to_uint320[poly1305_mac_c_l81_c11_909c] LATENCY=0
     -- Inputs
     bytes_to_uint320_poly1305_mac_c_l81_c11_909c_src <= VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_909c_src;
     -- Outputs
     VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_909c_return_output := bytes_to_uint320_poly1305_mac_c_l81_c11_909c_return_output;

     -- poly1305_pipeline_in_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_return_output := poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- is_last_block_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_return_output := is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- a_MUX[poly1305_mac_c_l100_c9_aeca] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l100_c9_aeca_cond <= VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_cond;
     a_MUX_poly1305_mac_c_l100_c9_aeca_iftrue <= VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_iftrue;
     a_MUX_poly1305_mac_c_l100_c9_aeca_iffalse <= VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_return_output := a_MUX_poly1305_mac_c_l100_c9_aeca_return_output;

     -- state_MUX[poly1305_mac_c_l119_c9_2a97] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l119_c9_2a97_cond <= VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_cond;
     state_MUX_poly1305_mac_c_l119_c9_2a97_iftrue <= VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_iftrue;
     state_MUX_poly1305_mac_c_l119_c9_2a97_iffalse <= VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_return_output := state_MUX_poly1305_mac_c_l119_c9_2a97_return_output;

     -- poly1305_mac_data_in_ready_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output := poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- CONST_REF_RD_uint8_t_16_uint8_t_16_7a60[poly1305_mac_c_l124_c51_44ce] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_uint8_t_16_7a60_poly1305_mac_c_l124_c51_44ce_return_output := CONST_REF_RD_uint8_t_16_uint8_t_16_7a60(
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_0_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_0_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_1_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_1_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_2_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_2_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_3_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_3_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_4_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_4_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_5_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_5_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_6_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_6_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_7_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_7_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_8_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_8_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_9_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_9_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_10_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_10_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_11_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_11_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_12_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_12_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_13_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_13_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_14_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_14_d41d_poly1305_mac_c_l123_c107_ff74_return_output,
     VAR_FOR_poly1305_mac_c_l123_c28_b7c1_ITER_15_CONST_REF_RD_uint8_t_uint8_t_array_40_t_data_15_d41d_poly1305_mac_c_l123_c107_ff74_return_output);

     -- poly1305_pipeline_in_valid_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_return_output := poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- state_MUX[poly1305_mac_c_l97_c5_a5dd] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l97_c5_a5dd_cond <= VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_cond;
     state_MUX_poly1305_mac_c_l97_c5_a5dd_iftrue <= VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_iftrue;
     state_MUX_poly1305_mac_c_l97_c5_a5dd_iffalse <= VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_return_output := state_MUX_poly1305_mac_c_l97_c5_a5dd_return_output;

     -- s_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     s_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     s_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     s_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_return_output := s_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- Submodule level 3
     VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse := VAR_a_MUX_poly1305_mac_c_l100_c9_aeca_return_output;
     VAR_r_MUX_poly1305_mac_c_l67_c5_4603_iftrue := VAR_bytes_to_uint320_poly1305_mac_c_l81_c11_909c_return_output;
     REG_VAR_is_last_block := VAR_is_last_block_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
     VAR_poly1305_mac_data_in_ready := VAR_poly1305_mac_data_in_ready_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
     VAR_poly1305_pipeline_in := VAR_poly1305_pipeline_in_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
     VAR_poly1305_pipeline_in_valid := VAR_poly1305_pipeline_in_valid_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
     REG_VAR_s := VAR_s_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
     VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_iffalse := VAR_state_MUX_poly1305_mac_c_l119_c9_2a97_return_output;
     VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue := VAR_state_MUX_poly1305_mac_c_l97_c5_a5dd_return_output;
     -- r_MUX[poly1305_mac_c_l67_c5_4603] LATENCY=0
     -- Inputs
     r_MUX_poly1305_mac_c_l67_c5_4603_cond <= VAR_r_MUX_poly1305_mac_c_l67_c5_4603_cond;
     r_MUX_poly1305_mac_c_l67_c5_4603_iftrue <= VAR_r_MUX_poly1305_mac_c_l67_c5_4603_iftrue;
     r_MUX_poly1305_mac_c_l67_c5_4603_iffalse <= VAR_r_MUX_poly1305_mac_c_l67_c5_4603_iffalse;
     -- Outputs
     VAR_r_MUX_poly1305_mac_c_l67_c5_4603_return_output := r_MUX_poly1305_mac_c_l67_c5_4603_return_output;

     -- a_MUX[poly1305_mac_c_l86_c9_6a2a] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l86_c9_6a2a_cond <= VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_cond;
     a_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue <= VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue;
     a_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse <= VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_return_output := a_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;

     -- state_MUX[poly1305_mac_c_l114_c9_98a8] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l114_c9_98a8_cond <= VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_cond;
     state_MUX_poly1305_mac_c_l114_c9_98a8_iftrue <= VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_iftrue;
     state_MUX_poly1305_mac_c_l114_c9_98a8_iffalse <= VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_return_output := state_MUX_poly1305_mac_c_l114_c9_98a8_return_output;

     -- uint8_array16_le[poly1305_mac_c_l124_c34_dec3] LATENCY=0
     VAR_uint8_array16_le_poly1305_mac_c_l124_c34_dec3_return_output := uint8_array16_le(
     VAR_CONST_REF_RD_uint8_t_16_uint8_t_16_7a60_poly1305_mac_c_l124_c51_44ce_return_output);

     -- Submodule level 4
     VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := VAR_a_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;
     VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_iftrue := VAR_r_MUX_poly1305_mac_c_l67_c5_4603_return_output;
     VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_iffalse := VAR_state_MUX_poly1305_mac_c_l114_c9_98a8_return_output;
     -- a_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     a_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     a_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     a_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_return_output := a_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- poly1305_mac_auth_tag_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0[poly1305_mac_c_l119_c9_2a97] LATENCY=0
     VAR_poly1305_mac_auth_tag_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_c9_2a97_return_output := CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0(
     VAR_uint8_array16_le_poly1305_mac_c_l124_c34_dec3_return_output,
     to_unsigned(1, 1));

     -- r_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     r_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     r_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     r_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_return_output := r_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- state_MUX[poly1305_mac_c_l100_c9_aeca] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l100_c9_aeca_cond <= VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_cond;
     state_MUX_poly1305_mac_c_l100_c9_aeca_iftrue <= VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_iftrue;
     state_MUX_poly1305_mac_c_l100_c9_aeca_iffalse <= VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_return_output := state_MUX_poly1305_mac_c_l100_c9_aeca_return_output;

     -- Submodule level 5
     REG_VAR_a := VAR_a_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iftrue := VAR_poly1305_mac_auth_tag_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_poly1305_mac_c_l119_c9_2a97_return_output;
     REG_VAR_r := VAR_r_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
     VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse := VAR_state_MUX_poly1305_mac_c_l100_c9_aeca_return_output;
     -- state_MUX[poly1305_mac_c_l86_c9_6a2a] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l86_c9_6a2a_cond <= VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_cond;
     state_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue <= VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue;
     state_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse <= VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_return_output := state_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;

     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l119_c9_2a97] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_return_output;

     -- Submodule level 6
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iffalse := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l119_c9_2a97_return_output;
     VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := VAR_state_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;
     -- state_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     state_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     state_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     state_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_return_output := state_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l114_c9_98a8] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_return_output;

     -- Submodule level 7
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iffalse := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l114_c9_98a8_return_output;
     REG_VAR_state := VAR_state_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l100_c9_aeca] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_return_output;

     -- Submodule level 8
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l100_c9_aeca_return_output;
     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l86_c9_6a2a] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;

     -- Submodule level 9
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iffalse := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l86_c9_6a2a_return_output;
     -- poly1305_mac_auth_tag_MUX[poly1305_mac_c_l58_c3_28d7] LATENCY=0
     -- Inputs
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_cond <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_cond;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iftrue <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iftrue;
     poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iffalse <= VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_iffalse;
     -- Outputs
     VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_return_output := poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_return_output;

     -- Submodule level 10
     VAR_poly1305_mac_auth_tag := VAR_poly1305_mac_auth_tag_MUX_poly1305_mac_c_l58_c3_28d7_return_output;
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
