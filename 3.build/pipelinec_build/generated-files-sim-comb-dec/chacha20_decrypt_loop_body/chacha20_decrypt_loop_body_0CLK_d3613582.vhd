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
-- Submodules: 69
entity chacha20_decrypt_loop_body_0CLK_d3613582 is
port(
 inputs : in chacha20_decrypt_loop_body_in_t;
 return_output : out axis512_t);
end chacha20_decrypt_loop_body_0CLK_d3613582;
architecture arch of chacha20_decrypt_loop_body_0CLK_d3613582 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- chacha20_init[chacha20_h_l216_c26_6626]
signal chacha20_init_chacha20_h_l216_c26_6626_key : uint8_t_32;
signal chacha20_init_chacha20_h_l216_c26_6626_nonce : uint8_t_12;
signal chacha20_init_chacha20_h_l216_c26_6626_counter : unsigned(31 downto 0);
signal chacha20_init_chacha20_h_l216_c26_6626_return_output : chacha20_state;

-- chacha20_block[chacha20_h_l217_c26_221f]
signal chacha20_block_chacha20_h_l217_c26_221f_state : chacha20_state;
signal chacha20_block_chacha20_h_l217_c26_221f_return_output : chacha20_state;

-- chacha20_state_to_bytes[chacha20_h_l220_c38_cbe5]
signal chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_x : chacha20_state;
signal chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_return_output : uint8_t_array_64_t;

-- FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

-- FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR[chacha20_h_l228_c19_b40d]
signal FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
signal FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);

function CONST_REF_RD_uint8_t_64_uint8_t_64_62ba( ref_toks_0 : unsigned;
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
 ref_toks_16 : unsigned;
 ref_toks_17 : unsigned;
 ref_toks_18 : unsigned;
 ref_toks_19 : unsigned;
 ref_toks_20 : unsigned;
 ref_toks_21 : unsigned;
 ref_toks_22 : unsigned;
 ref_toks_23 : unsigned;
 ref_toks_24 : unsigned;
 ref_toks_25 : unsigned;
 ref_toks_26 : unsigned;
 ref_toks_27 : unsigned;
 ref_toks_28 : unsigned;
 ref_toks_29 : unsigned;
 ref_toks_30 : unsigned;
 ref_toks_31 : unsigned;
 ref_toks_32 : unsigned;
 ref_toks_33 : unsigned;
 ref_toks_34 : unsigned;
 ref_toks_35 : unsigned;
 ref_toks_36 : unsigned;
 ref_toks_37 : unsigned;
 ref_toks_38 : unsigned;
 ref_toks_39 : unsigned;
 ref_toks_40 : unsigned;
 ref_toks_41 : unsigned;
 ref_toks_42 : unsigned;
 ref_toks_43 : unsigned;
 ref_toks_44 : unsigned;
 ref_toks_45 : unsigned;
 ref_toks_46 : unsigned;
 ref_toks_47 : unsigned;
 ref_toks_48 : unsigned;
 ref_toks_49 : unsigned;
 ref_toks_50 : unsigned;
 ref_toks_51 : unsigned;
 ref_toks_52 : unsigned;
 ref_toks_53 : unsigned;
 ref_toks_54 : unsigned;
 ref_toks_55 : unsigned;
 ref_toks_56 : unsigned;
 ref_toks_57 : unsigned;
 ref_toks_58 : unsigned;
 ref_toks_59 : unsigned;
 ref_toks_60 : unsigned;
 ref_toks_61 : unsigned;
 ref_toks_62 : unsigned;
 ref_toks_63 : unsigned) return uint8_t_64 is
 
  variable base : uint8_t_64; 
  variable return_output : uint8_t_64;
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
      base(16) := ref_toks_16;
      base(17) := ref_toks_17;
      base(18) := ref_toks_18;
      base(19) := ref_toks_19;
      base(20) := ref_toks_20;
      base(21) := ref_toks_21;
      base(22) := ref_toks_22;
      base(23) := ref_toks_23;
      base(24) := ref_toks_24;
      base(25) := ref_toks_25;
      base(26) := ref_toks_26;
      base(27) := ref_toks_27;
      base(28) := ref_toks_28;
      base(29) := ref_toks_29;
      base(30) := ref_toks_30;
      base(31) := ref_toks_31;
      base(32) := ref_toks_32;
      base(33) := ref_toks_33;
      base(34) := ref_toks_34;
      base(35) := ref_toks_35;
      base(36) := ref_toks_36;
      base(37) := ref_toks_37;
      base(38) := ref_toks_38;
      base(39) := ref_toks_39;
      base(40) := ref_toks_40;
      base(41) := ref_toks_41;
      base(42) := ref_toks_42;
      base(43) := ref_toks_43;
      base(44) := ref_toks_44;
      base(45) := ref_toks_45;
      base(46) := ref_toks_46;
      base(47) := ref_toks_47;
      base(48) := ref_toks_48;
      base(49) := ref_toks_49;
      base(50) := ref_toks_50;
      base(51) := ref_toks_51;
      base(52) := ref_toks_52;
      base(53) := ref_toks_53;
      base(54) := ref_toks_54;
      base(55) := ref_toks_55;
      base(56) := ref_toks_56;
      base(57) := ref_toks_57;
      base(58) := ref_toks_58;
      base(59) := ref_toks_59;
      base(60) := ref_toks_60;
      base(61) := ref_toks_61;
      base(62) := ref_toks_62;
      base(63) := ref_toks_63;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_axis512_t_axis512_t_774e( ref_toks_0 : axis512_t;
 ref_toks_1 : uint8_t_64) return axis512_t is
 
  variable base : axis512_t; 
  variable return_output : axis512_t;
begin
      base := ref_toks_0;
      base.tdata := ref_toks_1;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- chacha20_init_chacha20_h_l216_c26_6626 : 0 clocks latency
chacha20_init_chacha20_h_l216_c26_6626 : entity work.chacha20_init_0CLK_50a1b8d0 port map (
chacha20_init_chacha20_h_l216_c26_6626_key,
chacha20_init_chacha20_h_l216_c26_6626_nonce,
chacha20_init_chacha20_h_l216_c26_6626_counter,
chacha20_init_chacha20_h_l216_c26_6626_return_output);

-- chacha20_block_chacha20_h_l217_c26_221f : 0 clocks latency
chacha20_block_chacha20_h_l217_c26_221f : entity work.chacha20_block_0CLK_f1a496f6 port map (
chacha20_block_chacha20_h_l217_c26_221f_state,
chacha20_block_chacha20_h_l217_c26_221f_return_output);

-- chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5 : 0 clocks latency
chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5 : entity work.chacha20_state_to_bytes_0CLK_d3fba2d7 port map (
chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_x,
chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

-- FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d : 0 clocks latency
FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d : entity work.BIN_OP_XOR_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left,
FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right,
FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 inputs,
 -- All submodule outputs
 chacha20_init_chacha20_h_l216_c26_6626_return_output,
 chacha20_block_chacha20_h_l217_c26_221f_return_output,
 chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
 FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : axis512_t;
 variable VAR_inputs : chacha20_decrypt_loop_body_in_t;
 variable VAR_in_data : uint8_t_64;
 variable VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output : uint8_t_64;
 variable VAR_key : uint8_t_32;
 variable VAR_CONST_REF_RD_uint8_t_32_chacha20_decrypt_loop_body_in_t_key_d41d_chacha20_h_l212_c21_6dfe_return_output : uint8_t_32;
 variable VAR_nonce : uint8_t_12;
 variable VAR_CONST_REF_RD_uint8_t_12_chacha20_decrypt_loop_body_in_t_nonce_d41d_chacha20_h_l213_c23_6577_return_output : uint8_t_12;
 variable VAR_counter : unsigned(31 downto 0);
 variable VAR_CONST_REF_RD_uint32_t_chacha20_decrypt_loop_body_in_t_counter_d41d_chacha20_h_l214_c22_4a3e_return_output : unsigned(31 downto 0);
 variable VAR_state : chacha20_state;
 variable VAR_chacha20_init_chacha20_h_l216_c26_6626_key : uint8_t_32;
 variable VAR_chacha20_init_chacha20_h_l216_c26_6626_nonce : uint8_t_12;
 variable VAR_chacha20_init_chacha20_h_l216_c26_6626_counter : unsigned(31 downto 0);
 variable VAR_chacha20_init_chacha20_h_l216_c26_6626_return_output : chacha20_state;
 variable VAR_block : chacha20_state;
 variable VAR_chacha20_block_chacha20_h_l217_c26_221f_state : chacha20_state;
 variable VAR_chacha20_block_chacha20_h_l217_c26_221f_return_output : chacha20_state;
 variable VAR_block_bytes_t : uint8_t_array_64_t;
 variable VAR_chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_x : chacha20_state;
 variable VAR_chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_return_output : uint8_t_array_64_t;
 variable VAR_block_bytes : uint8_t_64;
 variable VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output : uint8_t_64;
 variable VAR_out_data : uint8_t_64;
 variable VAR_i : unsigned(31 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_CONST_REF_RD_uint8_t_uint8_t_64_0_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_CONST_REF_RD_uint8_t_uint8_t_64_0_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_CONST_REF_RD_uint8_t_uint8_t_64_1_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_CONST_REF_RD_uint8_t_uint8_t_64_1_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_CONST_REF_RD_uint8_t_uint8_t_64_2_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_CONST_REF_RD_uint8_t_uint8_t_64_2_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_CONST_REF_RD_uint8_t_uint8_t_64_3_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_CONST_REF_RD_uint8_t_uint8_t_64_3_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_CONST_REF_RD_uint8_t_uint8_t_64_4_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_CONST_REF_RD_uint8_t_uint8_t_64_4_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_CONST_REF_RD_uint8_t_uint8_t_64_5_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_CONST_REF_RD_uint8_t_uint8_t_64_5_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_CONST_REF_RD_uint8_t_uint8_t_64_6_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_CONST_REF_RD_uint8_t_uint8_t_64_6_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_CONST_REF_RD_uint8_t_uint8_t_64_7_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_CONST_REF_RD_uint8_t_uint8_t_64_7_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_CONST_REF_RD_uint8_t_uint8_t_64_8_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_CONST_REF_RD_uint8_t_uint8_t_64_8_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_CONST_REF_RD_uint8_t_uint8_t_64_9_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_CONST_REF_RD_uint8_t_uint8_t_64_9_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_CONST_REF_RD_uint8_t_uint8_t_64_10_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_CONST_REF_RD_uint8_t_uint8_t_64_10_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_CONST_REF_RD_uint8_t_uint8_t_64_11_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_CONST_REF_RD_uint8_t_uint8_t_64_11_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_CONST_REF_RD_uint8_t_uint8_t_64_12_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_CONST_REF_RD_uint8_t_uint8_t_64_12_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_CONST_REF_RD_uint8_t_uint8_t_64_13_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_CONST_REF_RD_uint8_t_uint8_t_64_13_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_CONST_REF_RD_uint8_t_uint8_t_64_14_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_CONST_REF_RD_uint8_t_uint8_t_64_14_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_CONST_REF_RD_uint8_t_uint8_t_64_15_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_CONST_REF_RD_uint8_t_uint8_t_64_15_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_CONST_REF_RD_uint8_t_uint8_t_64_16_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_CONST_REF_RD_uint8_t_uint8_t_64_16_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_CONST_REF_RD_uint8_t_uint8_t_64_17_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_CONST_REF_RD_uint8_t_uint8_t_64_17_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_CONST_REF_RD_uint8_t_uint8_t_64_18_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_CONST_REF_RD_uint8_t_uint8_t_64_18_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_CONST_REF_RD_uint8_t_uint8_t_64_19_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_CONST_REF_RD_uint8_t_uint8_t_64_19_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_CONST_REF_RD_uint8_t_uint8_t_64_20_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_CONST_REF_RD_uint8_t_uint8_t_64_20_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_CONST_REF_RD_uint8_t_uint8_t_64_21_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_CONST_REF_RD_uint8_t_uint8_t_64_21_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_CONST_REF_RD_uint8_t_uint8_t_64_22_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_CONST_REF_RD_uint8_t_uint8_t_64_22_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_CONST_REF_RD_uint8_t_uint8_t_64_23_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_CONST_REF_RD_uint8_t_uint8_t_64_23_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_CONST_REF_RD_uint8_t_uint8_t_64_24_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_CONST_REF_RD_uint8_t_uint8_t_64_24_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_CONST_REF_RD_uint8_t_uint8_t_64_25_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_CONST_REF_RD_uint8_t_uint8_t_64_25_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_CONST_REF_RD_uint8_t_uint8_t_64_26_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_CONST_REF_RD_uint8_t_uint8_t_64_26_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_CONST_REF_RD_uint8_t_uint8_t_64_27_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_CONST_REF_RD_uint8_t_uint8_t_64_27_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_CONST_REF_RD_uint8_t_uint8_t_64_28_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_CONST_REF_RD_uint8_t_uint8_t_64_28_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_CONST_REF_RD_uint8_t_uint8_t_64_29_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_CONST_REF_RD_uint8_t_uint8_t_64_29_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_CONST_REF_RD_uint8_t_uint8_t_64_30_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_CONST_REF_RD_uint8_t_uint8_t_64_30_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_CONST_REF_RD_uint8_t_uint8_t_64_31_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_CONST_REF_RD_uint8_t_uint8_t_64_31_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_CONST_REF_RD_uint8_t_uint8_t_64_32_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_CONST_REF_RD_uint8_t_uint8_t_64_32_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_CONST_REF_RD_uint8_t_uint8_t_64_33_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_CONST_REF_RD_uint8_t_uint8_t_64_33_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_CONST_REF_RD_uint8_t_uint8_t_64_34_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_CONST_REF_RD_uint8_t_uint8_t_64_34_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_CONST_REF_RD_uint8_t_uint8_t_64_35_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_CONST_REF_RD_uint8_t_uint8_t_64_35_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_CONST_REF_RD_uint8_t_uint8_t_64_36_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_CONST_REF_RD_uint8_t_uint8_t_64_36_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_CONST_REF_RD_uint8_t_uint8_t_64_37_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_CONST_REF_RD_uint8_t_uint8_t_64_37_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_CONST_REF_RD_uint8_t_uint8_t_64_38_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_CONST_REF_RD_uint8_t_uint8_t_64_38_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_CONST_REF_RD_uint8_t_uint8_t_64_39_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_CONST_REF_RD_uint8_t_uint8_t_64_39_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_CONST_REF_RD_uint8_t_uint8_t_64_40_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_CONST_REF_RD_uint8_t_uint8_t_64_40_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_CONST_REF_RD_uint8_t_uint8_t_64_41_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_CONST_REF_RD_uint8_t_uint8_t_64_41_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_CONST_REF_RD_uint8_t_uint8_t_64_42_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_CONST_REF_RD_uint8_t_uint8_t_64_42_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_CONST_REF_RD_uint8_t_uint8_t_64_43_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_CONST_REF_RD_uint8_t_uint8_t_64_43_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_CONST_REF_RD_uint8_t_uint8_t_64_44_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_CONST_REF_RD_uint8_t_uint8_t_64_44_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_CONST_REF_RD_uint8_t_uint8_t_64_45_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_CONST_REF_RD_uint8_t_uint8_t_64_45_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_CONST_REF_RD_uint8_t_uint8_t_64_46_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_CONST_REF_RD_uint8_t_uint8_t_64_46_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_CONST_REF_RD_uint8_t_uint8_t_64_47_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_CONST_REF_RD_uint8_t_uint8_t_64_47_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_CONST_REF_RD_uint8_t_uint8_t_64_48_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_CONST_REF_RD_uint8_t_uint8_t_64_48_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_CONST_REF_RD_uint8_t_uint8_t_64_49_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_CONST_REF_RD_uint8_t_uint8_t_64_49_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_CONST_REF_RD_uint8_t_uint8_t_64_50_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_CONST_REF_RD_uint8_t_uint8_t_64_50_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_CONST_REF_RD_uint8_t_uint8_t_64_51_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_CONST_REF_RD_uint8_t_uint8_t_64_51_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_CONST_REF_RD_uint8_t_uint8_t_64_52_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_CONST_REF_RD_uint8_t_uint8_t_64_52_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_CONST_REF_RD_uint8_t_uint8_t_64_53_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_CONST_REF_RD_uint8_t_uint8_t_64_53_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_CONST_REF_RD_uint8_t_uint8_t_64_54_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_CONST_REF_RD_uint8_t_uint8_t_64_54_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_CONST_REF_RD_uint8_t_uint8_t_64_55_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_CONST_REF_RD_uint8_t_uint8_t_64_55_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_CONST_REF_RD_uint8_t_uint8_t_64_56_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_CONST_REF_RD_uint8_t_uint8_t_64_56_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_CONST_REF_RD_uint8_t_uint8_t_64_57_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_CONST_REF_RD_uint8_t_uint8_t_64_57_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_CONST_REF_RD_uint8_t_uint8_t_64_58_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_CONST_REF_RD_uint8_t_uint8_t_64_58_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_CONST_REF_RD_uint8_t_uint8_t_64_59_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_CONST_REF_RD_uint8_t_uint8_t_64_59_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_CONST_REF_RD_uint8_t_uint8_t_64_60_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_CONST_REF_RD_uint8_t_uint8_t_64_60_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_CONST_REF_RD_uint8_t_uint8_t_64_61_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_CONST_REF_RD_uint8_t_uint8_t_64_61_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_CONST_REF_RD_uint8_t_uint8_t_64_62_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_CONST_REF_RD_uint8_t_uint8_t_64_62_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_CONST_REF_RD_uint8_t_uint8_t_64_63_d41d_chacha20_h_l228_c19_84d5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_CONST_REF_RD_uint8_t_uint8_t_64_63_d41d_chacha20_h_l228_c32_9778_return_output : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right : unsigned(7 downto 0);
 variable VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output : unsigned(7 downto 0);
 variable VAR_axis_out : axis512_t;
 variable VAR_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_axis_in_d41d_chacha20_h_l231_c24_06be_return_output : axis512_t;
 variable VAR_CONST_REF_RD_uint8_t_64_uint8_t_64_62ba_chacha20_h_l233_c20_6640_return_output : uint8_t_64;
 variable VAR_CONST_REF_RD_axis512_t_axis512_t_774e_chacha20_h_l234_c10_646d_return_output : axis512_t;
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_inputs := inputs;

     -- Submodule level 0
     -- CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d[chacha20_h_l211_c25_3c95] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output := VAR_inputs.axis_in.tdata;

     -- CONST_REF_RD_uint32_t_chacha20_decrypt_loop_body_in_t_counter_d41d[chacha20_h_l214_c22_4a3e] LATENCY=0
     VAR_CONST_REF_RD_uint32_t_chacha20_decrypt_loop_body_in_t_counter_d41d_chacha20_h_l214_c22_4a3e_return_output := VAR_inputs.counter;

     -- CONST_REF_RD_uint8_t_32_chacha20_decrypt_loop_body_in_t_key_d41d[chacha20_h_l212_c21_6dfe] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_32_chacha20_decrypt_loop_body_in_t_key_d41d_chacha20_h_l212_c21_6dfe_return_output := VAR_inputs.key;

     -- CONST_REF_RD_uint8_t_12_chacha20_decrypt_loop_body_in_t_nonce_d41d[chacha20_h_l213_c23_6577] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_12_chacha20_decrypt_loop_body_in_t_nonce_d41d_chacha20_h_l213_c23_6577_return_output := VAR_inputs.nonce;

     -- CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_axis_in_d41d[chacha20_h_l231_c24_06be] LATENCY=0
     VAR_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_axis_in_d41d_chacha20_h_l231_c24_06be_return_output := VAR_inputs.axis_in;

     -- Submodule level 1
     VAR_chacha20_init_chacha20_h_l216_c26_6626_counter := VAR_CONST_REF_RD_uint32_t_chacha20_decrypt_loop_body_in_t_counter_d41d_chacha20_h_l214_c22_4a3e_return_output;
     VAR_chacha20_init_chacha20_h_l216_c26_6626_nonce := VAR_CONST_REF_RD_uint8_t_12_chacha20_decrypt_loop_body_in_t_nonce_d41d_chacha20_h_l213_c23_6577_return_output;
     VAR_chacha20_init_chacha20_h_l216_c26_6626_key := VAR_CONST_REF_RD_uint8_t_32_chacha20_decrypt_loop_body_in_t_key_d41d_chacha20_h_l212_c21_6dfe_return_output;
     -- FOR_chacha20_h_l226_c3_dce4_ITER_51_CONST_REF_RD_uint8_t_uint8_t_64_51_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_CONST_REF_RD_uint8_t_uint8_t_64_51_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(51);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_8_CONST_REF_RD_uint8_t_uint8_t_64_8_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_CONST_REF_RD_uint8_t_uint8_t_64_8_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(8);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_14_CONST_REF_RD_uint8_t_uint8_t_64_14_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_CONST_REF_RD_uint8_t_uint8_t_64_14_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(14);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_36_CONST_REF_RD_uint8_t_uint8_t_64_36_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_CONST_REF_RD_uint8_t_uint8_t_64_36_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(36);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_2_CONST_REF_RD_uint8_t_uint8_t_64_2_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_CONST_REF_RD_uint8_t_uint8_t_64_2_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(2);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_10_CONST_REF_RD_uint8_t_uint8_t_64_10_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_CONST_REF_RD_uint8_t_uint8_t_64_10_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(10);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_7_CONST_REF_RD_uint8_t_uint8_t_64_7_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_CONST_REF_RD_uint8_t_uint8_t_64_7_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(7);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_26_CONST_REF_RD_uint8_t_uint8_t_64_26_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_CONST_REF_RD_uint8_t_uint8_t_64_26_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(26);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_22_CONST_REF_RD_uint8_t_uint8_t_64_22_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_CONST_REF_RD_uint8_t_uint8_t_64_22_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(22);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_0_CONST_REF_RD_uint8_t_uint8_t_64_0_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_CONST_REF_RD_uint8_t_uint8_t_64_0_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(0);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_33_CONST_REF_RD_uint8_t_uint8_t_64_33_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_CONST_REF_RD_uint8_t_uint8_t_64_33_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(33);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_48_CONST_REF_RD_uint8_t_uint8_t_64_48_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_CONST_REF_RD_uint8_t_uint8_t_64_48_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(48);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_42_CONST_REF_RD_uint8_t_uint8_t_64_42_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_CONST_REF_RD_uint8_t_uint8_t_64_42_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(42);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_9_CONST_REF_RD_uint8_t_uint8_t_64_9_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_CONST_REF_RD_uint8_t_uint8_t_64_9_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(9);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_25_CONST_REF_RD_uint8_t_uint8_t_64_25_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_CONST_REF_RD_uint8_t_uint8_t_64_25_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(25);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_55_CONST_REF_RD_uint8_t_uint8_t_64_55_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_CONST_REF_RD_uint8_t_uint8_t_64_55_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(55);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_54_CONST_REF_RD_uint8_t_uint8_t_64_54_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_CONST_REF_RD_uint8_t_uint8_t_64_54_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(54);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_4_CONST_REF_RD_uint8_t_uint8_t_64_4_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_CONST_REF_RD_uint8_t_uint8_t_64_4_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(4);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_58_CONST_REF_RD_uint8_t_uint8_t_64_58_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_CONST_REF_RD_uint8_t_uint8_t_64_58_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(58);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_46_CONST_REF_RD_uint8_t_uint8_t_64_46_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_CONST_REF_RD_uint8_t_uint8_t_64_46_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(46);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_12_CONST_REF_RD_uint8_t_uint8_t_64_12_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_CONST_REF_RD_uint8_t_uint8_t_64_12_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(12);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_47_CONST_REF_RD_uint8_t_uint8_t_64_47_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_CONST_REF_RD_uint8_t_uint8_t_64_47_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(47);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_53_CONST_REF_RD_uint8_t_uint8_t_64_53_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_CONST_REF_RD_uint8_t_uint8_t_64_53_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(53);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_52_CONST_REF_RD_uint8_t_uint8_t_64_52_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_CONST_REF_RD_uint8_t_uint8_t_64_52_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(52);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_17_CONST_REF_RD_uint8_t_uint8_t_64_17_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_CONST_REF_RD_uint8_t_uint8_t_64_17_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(17);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_41_CONST_REF_RD_uint8_t_uint8_t_64_41_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_CONST_REF_RD_uint8_t_uint8_t_64_41_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(41);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_34_CONST_REF_RD_uint8_t_uint8_t_64_34_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_CONST_REF_RD_uint8_t_uint8_t_64_34_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(34);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_44_CONST_REF_RD_uint8_t_uint8_t_64_44_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_CONST_REF_RD_uint8_t_uint8_t_64_44_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(44);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_11_CONST_REF_RD_uint8_t_uint8_t_64_11_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_CONST_REF_RD_uint8_t_uint8_t_64_11_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(11);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_32_CONST_REF_RD_uint8_t_uint8_t_64_32_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_CONST_REF_RD_uint8_t_uint8_t_64_32_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(32);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_27_CONST_REF_RD_uint8_t_uint8_t_64_27_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_CONST_REF_RD_uint8_t_uint8_t_64_27_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(27);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_31_CONST_REF_RD_uint8_t_uint8_t_64_31_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_CONST_REF_RD_uint8_t_uint8_t_64_31_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(31);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_45_CONST_REF_RD_uint8_t_uint8_t_64_45_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_CONST_REF_RD_uint8_t_uint8_t_64_45_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(45);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_37_CONST_REF_RD_uint8_t_uint8_t_64_37_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_CONST_REF_RD_uint8_t_uint8_t_64_37_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(37);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_28_CONST_REF_RD_uint8_t_uint8_t_64_28_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_CONST_REF_RD_uint8_t_uint8_t_64_28_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(28);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_24_CONST_REF_RD_uint8_t_uint8_t_64_24_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_CONST_REF_RD_uint8_t_uint8_t_64_24_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(24);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_5_CONST_REF_RD_uint8_t_uint8_t_64_5_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_CONST_REF_RD_uint8_t_uint8_t_64_5_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(5);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_50_CONST_REF_RD_uint8_t_uint8_t_64_50_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_CONST_REF_RD_uint8_t_uint8_t_64_50_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(50);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_39_CONST_REF_RD_uint8_t_uint8_t_64_39_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_CONST_REF_RD_uint8_t_uint8_t_64_39_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(39);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_61_CONST_REF_RD_uint8_t_uint8_t_64_61_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_CONST_REF_RD_uint8_t_uint8_t_64_61_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(61);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_35_CONST_REF_RD_uint8_t_uint8_t_64_35_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_CONST_REF_RD_uint8_t_uint8_t_64_35_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(35);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_16_CONST_REF_RD_uint8_t_uint8_t_64_16_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_CONST_REF_RD_uint8_t_uint8_t_64_16_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(16);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_19_CONST_REF_RD_uint8_t_uint8_t_64_19_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_CONST_REF_RD_uint8_t_uint8_t_64_19_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(19);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_38_CONST_REF_RD_uint8_t_uint8_t_64_38_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_CONST_REF_RD_uint8_t_uint8_t_64_38_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(38);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_49_CONST_REF_RD_uint8_t_uint8_t_64_49_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_CONST_REF_RD_uint8_t_uint8_t_64_49_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(49);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_30_CONST_REF_RD_uint8_t_uint8_t_64_30_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_CONST_REF_RD_uint8_t_uint8_t_64_30_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(30);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_23_CONST_REF_RD_uint8_t_uint8_t_64_23_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_CONST_REF_RD_uint8_t_uint8_t_64_23_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(23);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_57_CONST_REF_RD_uint8_t_uint8_t_64_57_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_CONST_REF_RD_uint8_t_uint8_t_64_57_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(57);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_60_CONST_REF_RD_uint8_t_uint8_t_64_60_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_CONST_REF_RD_uint8_t_uint8_t_64_60_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(60);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_1_CONST_REF_RD_uint8_t_uint8_t_64_1_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_CONST_REF_RD_uint8_t_uint8_t_64_1_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(1);

     -- chacha20_init[chacha20_h_l216_c26_6626] LATENCY=0
     -- Inputs
     chacha20_init_chacha20_h_l216_c26_6626_key <= VAR_chacha20_init_chacha20_h_l216_c26_6626_key;
     chacha20_init_chacha20_h_l216_c26_6626_nonce <= VAR_chacha20_init_chacha20_h_l216_c26_6626_nonce;
     chacha20_init_chacha20_h_l216_c26_6626_counter <= VAR_chacha20_init_chacha20_h_l216_c26_6626_counter;
     -- Outputs
     VAR_chacha20_init_chacha20_h_l216_c26_6626_return_output := chacha20_init_chacha20_h_l216_c26_6626_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_13_CONST_REF_RD_uint8_t_uint8_t_64_13_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_CONST_REF_RD_uint8_t_uint8_t_64_13_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(13);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_59_CONST_REF_RD_uint8_t_uint8_t_64_59_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_CONST_REF_RD_uint8_t_uint8_t_64_59_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(59);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_29_CONST_REF_RD_uint8_t_uint8_t_64_29_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_CONST_REF_RD_uint8_t_uint8_t_64_29_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(29);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_21_CONST_REF_RD_uint8_t_uint8_t_64_21_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_CONST_REF_RD_uint8_t_uint8_t_64_21_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(21);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_43_CONST_REF_RD_uint8_t_uint8_t_64_43_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_CONST_REF_RD_uint8_t_uint8_t_64_43_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(43);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_15_CONST_REF_RD_uint8_t_uint8_t_64_15_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_CONST_REF_RD_uint8_t_uint8_t_64_15_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(15);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_20_CONST_REF_RD_uint8_t_uint8_t_64_20_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_CONST_REF_RD_uint8_t_uint8_t_64_20_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(20);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_56_CONST_REF_RD_uint8_t_uint8_t_64_56_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_CONST_REF_RD_uint8_t_uint8_t_64_56_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(56);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_18_CONST_REF_RD_uint8_t_uint8_t_64_18_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_CONST_REF_RD_uint8_t_uint8_t_64_18_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(18);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_62_CONST_REF_RD_uint8_t_uint8_t_64_62_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_CONST_REF_RD_uint8_t_uint8_t_64_62_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(62);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_3_CONST_REF_RD_uint8_t_uint8_t_64_3_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_CONST_REF_RD_uint8_t_uint8_t_64_3_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(3);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_40_CONST_REF_RD_uint8_t_uint8_t_64_40_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_CONST_REF_RD_uint8_t_uint8_t_64_40_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(40);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_63_CONST_REF_RD_uint8_t_uint8_t_64_63_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_CONST_REF_RD_uint8_t_uint8_t_64_63_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(63);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_6_CONST_REF_RD_uint8_t_uint8_t_64_6_d41d[chacha20_h_l228_c19_84d5] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_CONST_REF_RD_uint8_t_uint8_t_64_6_d41d_chacha20_h_l228_c19_84d5_return_output := VAR_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_axis_in_tdata_d41d_chacha20_h_l211_c25_3c95_return_output(6);

     -- Submodule level 2
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_CONST_REF_RD_uint8_t_uint8_t_64_0_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_CONST_REF_RD_uint8_t_uint8_t_64_10_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_CONST_REF_RD_uint8_t_uint8_t_64_11_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_CONST_REF_RD_uint8_t_uint8_t_64_12_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_CONST_REF_RD_uint8_t_uint8_t_64_13_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_CONST_REF_RD_uint8_t_uint8_t_64_14_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_CONST_REF_RD_uint8_t_uint8_t_64_15_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_CONST_REF_RD_uint8_t_uint8_t_64_16_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_CONST_REF_RD_uint8_t_uint8_t_64_17_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_CONST_REF_RD_uint8_t_uint8_t_64_18_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_CONST_REF_RD_uint8_t_uint8_t_64_19_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_CONST_REF_RD_uint8_t_uint8_t_64_1_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_CONST_REF_RD_uint8_t_uint8_t_64_20_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_CONST_REF_RD_uint8_t_uint8_t_64_21_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_CONST_REF_RD_uint8_t_uint8_t_64_22_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_CONST_REF_RD_uint8_t_uint8_t_64_23_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_CONST_REF_RD_uint8_t_uint8_t_64_24_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_CONST_REF_RD_uint8_t_uint8_t_64_25_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_CONST_REF_RD_uint8_t_uint8_t_64_26_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_CONST_REF_RD_uint8_t_uint8_t_64_27_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_CONST_REF_RD_uint8_t_uint8_t_64_28_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_CONST_REF_RD_uint8_t_uint8_t_64_29_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_CONST_REF_RD_uint8_t_uint8_t_64_2_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_CONST_REF_RD_uint8_t_uint8_t_64_30_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_CONST_REF_RD_uint8_t_uint8_t_64_31_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_CONST_REF_RD_uint8_t_uint8_t_64_32_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_CONST_REF_RD_uint8_t_uint8_t_64_33_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_CONST_REF_RD_uint8_t_uint8_t_64_34_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_CONST_REF_RD_uint8_t_uint8_t_64_35_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_CONST_REF_RD_uint8_t_uint8_t_64_36_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_CONST_REF_RD_uint8_t_uint8_t_64_37_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_CONST_REF_RD_uint8_t_uint8_t_64_38_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_CONST_REF_RD_uint8_t_uint8_t_64_39_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_CONST_REF_RD_uint8_t_uint8_t_64_3_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_CONST_REF_RD_uint8_t_uint8_t_64_40_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_CONST_REF_RD_uint8_t_uint8_t_64_41_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_CONST_REF_RD_uint8_t_uint8_t_64_42_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_CONST_REF_RD_uint8_t_uint8_t_64_43_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_CONST_REF_RD_uint8_t_uint8_t_64_44_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_CONST_REF_RD_uint8_t_uint8_t_64_45_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_CONST_REF_RD_uint8_t_uint8_t_64_46_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_CONST_REF_RD_uint8_t_uint8_t_64_47_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_CONST_REF_RD_uint8_t_uint8_t_64_48_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_CONST_REF_RD_uint8_t_uint8_t_64_49_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_CONST_REF_RD_uint8_t_uint8_t_64_4_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_CONST_REF_RD_uint8_t_uint8_t_64_50_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_CONST_REF_RD_uint8_t_uint8_t_64_51_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_CONST_REF_RD_uint8_t_uint8_t_64_52_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_CONST_REF_RD_uint8_t_uint8_t_64_53_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_CONST_REF_RD_uint8_t_uint8_t_64_54_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_CONST_REF_RD_uint8_t_uint8_t_64_55_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_CONST_REF_RD_uint8_t_uint8_t_64_56_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_CONST_REF_RD_uint8_t_uint8_t_64_57_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_CONST_REF_RD_uint8_t_uint8_t_64_58_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_CONST_REF_RD_uint8_t_uint8_t_64_59_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_CONST_REF_RD_uint8_t_uint8_t_64_5_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_CONST_REF_RD_uint8_t_uint8_t_64_60_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_CONST_REF_RD_uint8_t_uint8_t_64_61_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_CONST_REF_RD_uint8_t_uint8_t_64_62_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_CONST_REF_RD_uint8_t_uint8_t_64_63_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_CONST_REF_RD_uint8_t_uint8_t_64_6_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_CONST_REF_RD_uint8_t_uint8_t_64_7_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_CONST_REF_RD_uint8_t_uint8_t_64_8_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_CONST_REF_RD_uint8_t_uint8_t_64_9_d41d_chacha20_h_l228_c19_84d5_return_output;
     VAR_chacha20_block_chacha20_h_l217_c26_221f_state := VAR_chacha20_init_chacha20_h_l216_c26_6626_return_output;
     -- chacha20_block[chacha20_h_l217_c26_221f] LATENCY=0
     -- Inputs
     chacha20_block_chacha20_h_l217_c26_221f_state <= VAR_chacha20_block_chacha20_h_l217_c26_221f_state;
     -- Outputs
     VAR_chacha20_block_chacha20_h_l217_c26_221f_return_output := chacha20_block_chacha20_h_l217_c26_221f_return_output;

     -- Submodule level 3
     VAR_chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_x := VAR_chacha20_block_chacha20_h_l217_c26_221f_return_output;
     -- chacha20_state_to_bytes[chacha20_h_l220_c38_cbe5] LATENCY=0
     -- Inputs
     chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_x <= VAR_chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_x;
     -- Outputs
     VAR_chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_return_output := chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_return_output;

     -- Submodule level 4
     -- CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d[chacha20_h_l221_c29_bd91] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output := VAR_chacha20_state_to_bytes_chacha20_h_l220_c38_cbe5_return_output.data;

     -- Submodule level 5
     -- FOR_chacha20_h_l226_c3_dce4_ITER_53_CONST_REF_RD_uint8_t_uint8_t_64_53_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_CONST_REF_RD_uint8_t_uint8_t_64_53_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(53);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_3_CONST_REF_RD_uint8_t_uint8_t_64_3_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_CONST_REF_RD_uint8_t_uint8_t_64_3_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(3);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_51_CONST_REF_RD_uint8_t_uint8_t_64_51_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_CONST_REF_RD_uint8_t_uint8_t_64_51_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(51);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_63_CONST_REF_RD_uint8_t_uint8_t_64_63_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_CONST_REF_RD_uint8_t_uint8_t_64_63_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(63);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_54_CONST_REF_RD_uint8_t_uint8_t_64_54_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_CONST_REF_RD_uint8_t_uint8_t_64_54_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(54);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_2_CONST_REF_RD_uint8_t_uint8_t_64_2_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_CONST_REF_RD_uint8_t_uint8_t_64_2_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(2);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_37_CONST_REF_RD_uint8_t_uint8_t_64_37_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_CONST_REF_RD_uint8_t_uint8_t_64_37_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(37);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_11_CONST_REF_RD_uint8_t_uint8_t_64_11_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_CONST_REF_RD_uint8_t_uint8_t_64_11_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(11);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_39_CONST_REF_RD_uint8_t_uint8_t_64_39_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_CONST_REF_RD_uint8_t_uint8_t_64_39_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(39);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_62_CONST_REF_RD_uint8_t_uint8_t_64_62_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_CONST_REF_RD_uint8_t_uint8_t_64_62_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(62);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_55_CONST_REF_RD_uint8_t_uint8_t_64_55_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_CONST_REF_RD_uint8_t_uint8_t_64_55_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(55);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_5_CONST_REF_RD_uint8_t_uint8_t_64_5_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_CONST_REF_RD_uint8_t_uint8_t_64_5_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(5);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_27_CONST_REF_RD_uint8_t_uint8_t_64_27_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_CONST_REF_RD_uint8_t_uint8_t_64_27_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(27);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_49_CONST_REF_RD_uint8_t_uint8_t_64_49_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_CONST_REF_RD_uint8_t_uint8_t_64_49_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(49);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_18_CONST_REF_RD_uint8_t_uint8_t_64_18_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_CONST_REF_RD_uint8_t_uint8_t_64_18_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(18);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_31_CONST_REF_RD_uint8_t_uint8_t_64_31_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_CONST_REF_RD_uint8_t_uint8_t_64_31_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(31);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_33_CONST_REF_RD_uint8_t_uint8_t_64_33_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_CONST_REF_RD_uint8_t_uint8_t_64_33_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(33);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_60_CONST_REF_RD_uint8_t_uint8_t_64_60_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_CONST_REF_RD_uint8_t_uint8_t_64_60_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(60);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_34_CONST_REF_RD_uint8_t_uint8_t_64_34_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_CONST_REF_RD_uint8_t_uint8_t_64_34_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(34);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_56_CONST_REF_RD_uint8_t_uint8_t_64_56_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_CONST_REF_RD_uint8_t_uint8_t_64_56_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(56);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_47_CONST_REF_RD_uint8_t_uint8_t_64_47_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_CONST_REF_RD_uint8_t_uint8_t_64_47_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(47);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_23_CONST_REF_RD_uint8_t_uint8_t_64_23_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_CONST_REF_RD_uint8_t_uint8_t_64_23_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(23);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_17_CONST_REF_RD_uint8_t_uint8_t_64_17_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_CONST_REF_RD_uint8_t_uint8_t_64_17_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(17);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_24_CONST_REF_RD_uint8_t_uint8_t_64_24_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_CONST_REF_RD_uint8_t_uint8_t_64_24_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(24);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_9_CONST_REF_RD_uint8_t_uint8_t_64_9_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_CONST_REF_RD_uint8_t_uint8_t_64_9_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(9);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_26_CONST_REF_RD_uint8_t_uint8_t_64_26_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_CONST_REF_RD_uint8_t_uint8_t_64_26_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(26);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_35_CONST_REF_RD_uint8_t_uint8_t_64_35_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_CONST_REF_RD_uint8_t_uint8_t_64_35_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(35);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_13_CONST_REF_RD_uint8_t_uint8_t_64_13_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_CONST_REF_RD_uint8_t_uint8_t_64_13_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(13);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_29_CONST_REF_RD_uint8_t_uint8_t_64_29_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_CONST_REF_RD_uint8_t_uint8_t_64_29_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(29);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_28_CONST_REF_RD_uint8_t_uint8_t_64_28_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_CONST_REF_RD_uint8_t_uint8_t_64_28_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(28);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_10_CONST_REF_RD_uint8_t_uint8_t_64_10_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_CONST_REF_RD_uint8_t_uint8_t_64_10_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(10);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_43_CONST_REF_RD_uint8_t_uint8_t_64_43_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_CONST_REF_RD_uint8_t_uint8_t_64_43_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(43);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_58_CONST_REF_RD_uint8_t_uint8_t_64_58_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_CONST_REF_RD_uint8_t_uint8_t_64_58_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(58);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_30_CONST_REF_RD_uint8_t_uint8_t_64_30_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_CONST_REF_RD_uint8_t_uint8_t_64_30_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(30);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_52_CONST_REF_RD_uint8_t_uint8_t_64_52_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_CONST_REF_RD_uint8_t_uint8_t_64_52_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(52);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_57_CONST_REF_RD_uint8_t_uint8_t_64_57_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_CONST_REF_RD_uint8_t_uint8_t_64_57_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(57);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_50_CONST_REF_RD_uint8_t_uint8_t_64_50_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_CONST_REF_RD_uint8_t_uint8_t_64_50_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(50);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_21_CONST_REF_RD_uint8_t_uint8_t_64_21_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_CONST_REF_RD_uint8_t_uint8_t_64_21_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(21);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_16_CONST_REF_RD_uint8_t_uint8_t_64_16_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_CONST_REF_RD_uint8_t_uint8_t_64_16_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(16);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_45_CONST_REF_RD_uint8_t_uint8_t_64_45_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_CONST_REF_RD_uint8_t_uint8_t_64_45_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(45);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_61_CONST_REF_RD_uint8_t_uint8_t_64_61_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_CONST_REF_RD_uint8_t_uint8_t_64_61_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(61);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_46_CONST_REF_RD_uint8_t_uint8_t_64_46_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_CONST_REF_RD_uint8_t_uint8_t_64_46_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(46);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_36_CONST_REF_RD_uint8_t_uint8_t_64_36_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_CONST_REF_RD_uint8_t_uint8_t_64_36_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(36);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_42_CONST_REF_RD_uint8_t_uint8_t_64_42_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_CONST_REF_RD_uint8_t_uint8_t_64_42_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(42);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_48_CONST_REF_RD_uint8_t_uint8_t_64_48_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_CONST_REF_RD_uint8_t_uint8_t_64_48_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(48);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_44_CONST_REF_RD_uint8_t_uint8_t_64_44_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_CONST_REF_RD_uint8_t_uint8_t_64_44_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(44);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_20_CONST_REF_RD_uint8_t_uint8_t_64_20_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_CONST_REF_RD_uint8_t_uint8_t_64_20_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(20);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_7_CONST_REF_RD_uint8_t_uint8_t_64_7_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_CONST_REF_RD_uint8_t_uint8_t_64_7_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(7);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_22_CONST_REF_RD_uint8_t_uint8_t_64_22_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_CONST_REF_RD_uint8_t_uint8_t_64_22_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(22);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_1_CONST_REF_RD_uint8_t_uint8_t_64_1_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_CONST_REF_RD_uint8_t_uint8_t_64_1_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(1);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_25_CONST_REF_RD_uint8_t_uint8_t_64_25_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_CONST_REF_RD_uint8_t_uint8_t_64_25_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(25);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_40_CONST_REF_RD_uint8_t_uint8_t_64_40_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_CONST_REF_RD_uint8_t_uint8_t_64_40_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(40);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_14_CONST_REF_RD_uint8_t_uint8_t_64_14_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_CONST_REF_RD_uint8_t_uint8_t_64_14_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(14);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_41_CONST_REF_RD_uint8_t_uint8_t_64_41_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_CONST_REF_RD_uint8_t_uint8_t_64_41_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(41);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_6_CONST_REF_RD_uint8_t_uint8_t_64_6_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_CONST_REF_RD_uint8_t_uint8_t_64_6_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(6);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_0_CONST_REF_RD_uint8_t_uint8_t_64_0_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_CONST_REF_RD_uint8_t_uint8_t_64_0_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(0);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_8_CONST_REF_RD_uint8_t_uint8_t_64_8_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_CONST_REF_RD_uint8_t_uint8_t_64_8_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(8);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_59_CONST_REF_RD_uint8_t_uint8_t_64_59_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_CONST_REF_RD_uint8_t_uint8_t_64_59_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(59);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_19_CONST_REF_RD_uint8_t_uint8_t_64_19_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_CONST_REF_RD_uint8_t_uint8_t_64_19_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(19);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_38_CONST_REF_RD_uint8_t_uint8_t_64_38_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_CONST_REF_RD_uint8_t_uint8_t_64_38_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(38);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_12_CONST_REF_RD_uint8_t_uint8_t_64_12_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_CONST_REF_RD_uint8_t_uint8_t_64_12_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(12);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_15_CONST_REF_RD_uint8_t_uint8_t_64_15_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_CONST_REF_RD_uint8_t_uint8_t_64_15_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(15);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_4_CONST_REF_RD_uint8_t_uint8_t_64_4_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_CONST_REF_RD_uint8_t_uint8_t_64_4_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(4);

     -- FOR_chacha20_h_l226_c3_dce4_ITER_32_CONST_REF_RD_uint8_t_uint8_t_64_32_d41d[chacha20_h_l228_c32_9778] LATENCY=0
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_CONST_REF_RD_uint8_t_uint8_t_64_32_d41d_chacha20_h_l228_c32_9778_return_output := VAR_CONST_REF_RD_uint8_t_64_uint8_t_array_64_t_data_d41d_chacha20_h_l221_c29_bd91_return_output(32);

     -- Submodule level 6
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_CONST_REF_RD_uint8_t_uint8_t_64_0_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_CONST_REF_RD_uint8_t_uint8_t_64_10_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_CONST_REF_RD_uint8_t_uint8_t_64_11_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_CONST_REF_RD_uint8_t_uint8_t_64_12_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_CONST_REF_RD_uint8_t_uint8_t_64_13_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_CONST_REF_RD_uint8_t_uint8_t_64_14_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_CONST_REF_RD_uint8_t_uint8_t_64_15_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_CONST_REF_RD_uint8_t_uint8_t_64_16_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_CONST_REF_RD_uint8_t_uint8_t_64_17_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_CONST_REF_RD_uint8_t_uint8_t_64_18_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_CONST_REF_RD_uint8_t_uint8_t_64_19_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_CONST_REF_RD_uint8_t_uint8_t_64_1_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_CONST_REF_RD_uint8_t_uint8_t_64_20_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_CONST_REF_RD_uint8_t_uint8_t_64_21_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_CONST_REF_RD_uint8_t_uint8_t_64_22_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_CONST_REF_RD_uint8_t_uint8_t_64_23_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_CONST_REF_RD_uint8_t_uint8_t_64_24_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_CONST_REF_RD_uint8_t_uint8_t_64_25_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_CONST_REF_RD_uint8_t_uint8_t_64_26_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_CONST_REF_RD_uint8_t_uint8_t_64_27_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_CONST_REF_RD_uint8_t_uint8_t_64_28_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_CONST_REF_RD_uint8_t_uint8_t_64_29_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_CONST_REF_RD_uint8_t_uint8_t_64_2_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_CONST_REF_RD_uint8_t_uint8_t_64_30_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_CONST_REF_RD_uint8_t_uint8_t_64_31_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_CONST_REF_RD_uint8_t_uint8_t_64_32_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_CONST_REF_RD_uint8_t_uint8_t_64_33_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_CONST_REF_RD_uint8_t_uint8_t_64_34_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_CONST_REF_RD_uint8_t_uint8_t_64_35_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_CONST_REF_RD_uint8_t_uint8_t_64_36_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_CONST_REF_RD_uint8_t_uint8_t_64_37_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_CONST_REF_RD_uint8_t_uint8_t_64_38_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_CONST_REF_RD_uint8_t_uint8_t_64_39_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_CONST_REF_RD_uint8_t_uint8_t_64_3_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_CONST_REF_RD_uint8_t_uint8_t_64_40_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_CONST_REF_RD_uint8_t_uint8_t_64_41_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_CONST_REF_RD_uint8_t_uint8_t_64_42_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_CONST_REF_RD_uint8_t_uint8_t_64_43_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_CONST_REF_RD_uint8_t_uint8_t_64_44_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_CONST_REF_RD_uint8_t_uint8_t_64_45_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_CONST_REF_RD_uint8_t_uint8_t_64_46_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_CONST_REF_RD_uint8_t_uint8_t_64_47_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_CONST_REF_RD_uint8_t_uint8_t_64_48_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_CONST_REF_RD_uint8_t_uint8_t_64_49_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_CONST_REF_RD_uint8_t_uint8_t_64_4_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_CONST_REF_RD_uint8_t_uint8_t_64_50_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_CONST_REF_RD_uint8_t_uint8_t_64_51_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_CONST_REF_RD_uint8_t_uint8_t_64_52_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_CONST_REF_RD_uint8_t_uint8_t_64_53_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_CONST_REF_RD_uint8_t_uint8_t_64_54_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_CONST_REF_RD_uint8_t_uint8_t_64_55_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_CONST_REF_RD_uint8_t_uint8_t_64_56_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_CONST_REF_RD_uint8_t_uint8_t_64_57_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_CONST_REF_RD_uint8_t_uint8_t_64_58_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_CONST_REF_RD_uint8_t_uint8_t_64_59_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_CONST_REF_RD_uint8_t_uint8_t_64_5_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_CONST_REF_RD_uint8_t_uint8_t_64_60_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_CONST_REF_RD_uint8_t_uint8_t_64_61_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_CONST_REF_RD_uint8_t_uint8_t_64_62_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_CONST_REF_RD_uint8_t_uint8_t_64_63_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_CONST_REF_RD_uint8_t_uint8_t_64_6_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_CONST_REF_RD_uint8_t_uint8_t_64_7_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_CONST_REF_RD_uint8_t_uint8_t_64_8_d41d_chacha20_h_l228_c32_9778_return_output;
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right := VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_CONST_REF_RD_uint8_t_uint8_t_64_9_d41d_chacha20_h_l228_c32_9778_return_output;
     -- FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR[chacha20_h_l228_c19_b40d] LATENCY=0
     -- Inputs
     FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_left;
     FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right <= VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_right;
     -- Outputs
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output := FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output;

     -- Submodule level 7
     -- CONST_REF_RD_uint8_t_64_uint8_t_64_62ba[chacha20_h_l233_c20_6640] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_64_uint8_t_64_62ba_chacha20_h_l233_c20_6640_return_output := CONST_REF_RD_uint8_t_64_uint8_t_64_62ba(
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_0_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_1_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_2_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_3_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_4_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_5_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_6_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_7_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_8_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_9_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_10_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_11_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_12_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_13_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_14_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_15_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_16_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_17_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_18_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_19_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_20_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_21_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_22_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_23_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_24_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_25_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_26_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_27_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_28_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_29_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_30_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_31_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_32_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_33_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_34_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_35_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_36_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_37_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_38_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_39_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_40_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_41_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_42_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_43_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_44_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_45_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_46_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_47_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_48_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_49_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_50_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_51_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_52_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_53_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_54_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_55_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_56_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_57_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_58_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_59_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_60_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_61_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_62_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output,
     VAR_FOR_chacha20_h_l226_c3_dce4_ITER_63_BIN_OP_XOR_chacha20_h_l228_c19_b40d_return_output);

     -- Submodule level 8
     -- CONST_REF_RD_axis512_t_axis512_t_774e[chacha20_h_l234_c10_646d] LATENCY=0
     VAR_CONST_REF_RD_axis512_t_axis512_t_774e_chacha20_h_l234_c10_646d_return_output := CONST_REF_RD_axis512_t_axis512_t_774e(
     VAR_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_axis_in_d41d_chacha20_h_l231_c24_06be_return_output,
     VAR_CONST_REF_RD_uint8_t_64_uint8_t_64_62ba_chacha20_h_l233_c20_6640_return_output);

     -- Submodule level 9
     VAR_return_output := VAR_CONST_REF_RD_axis512_t_axis512_t_774e_chacha20_h_l234_c10_646d_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
