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
-- Submodules: 170
entity prep_auth_data_0CLK_41669ea5 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in prep_auth_data_global_to_module_t;
 module_to_global : out prep_auth_data_module_to_global_t);
end prep_auth_data_0CLK_41669ea5;
architecture arch of prep_auth_data_0CLK_41669ea5 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal state : unsigned(1 downto 0) := unsigned(prep_auth_data_state_t_to_slv(prep_auth_data_state_t'left));
signal aad_reg : uint8_t_32 := (others => to_unsigned(0, 8));
signal counter : unsigned(15 downto 0) := to_unsigned(0, 16);
signal REG_COMB_state : unsigned(1 downto 0);
signal REG_COMB_aad_reg : uint8_t_32;
signal REG_COMB_counter : unsigned(15 downto 0);

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- BIN_OP_EQ[prep_auth_data_c_l61_c6_fe8e]
signal BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_left : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_right : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output : unsigned(0 downto 0);

-- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l61_c3_9f2c]
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l61_c3_9f2c]
signal state_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : unsigned(1 downto 0);

-- prep_auth_data_axis_out_MUX[prep_auth_data_c_l61_c3_9f2c]
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : axis128_t_stream_t;

-- counter_MUX[prep_auth_data_c_l61_c3_9f2c]
signal counter_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : unsigned(15 downto 0);

-- aad_reg_MUX[prep_auth_data_c_l61_c3_9f2c]
signal aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
signal aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : uint8_t_32;

-- state_MUX[prep_auth_data_c_l64_c5_aa3b]
signal state_MUX_prep_auth_data_c_l64_c5_aa3b_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l64_c5_aa3b_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l64_c5_aa3b]
signal counter_MUX_prep_auth_data_c_l64_c5_aa3b_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l64_c5_aa3b_return_output : unsigned(15 downto 0);

-- aad_reg_MUX[prep_auth_data_c_l64_c5_aa3b]
signal aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_cond : unsigned(0 downto 0);
signal aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_return_output : uint8_t_32;

-- BIN_OP_GT[prep_auth_data_c_l68_c10_c6be]
signal BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_left : unsigned(7 downto 0);
signal BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_right : unsigned(0 downto 0);
signal BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l68_c7_b525]
signal state_MUX_prep_auth_data_c_l68_c7_b525_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l68_c7_b525_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l68_c7_b525_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l68_c7_b525_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l68_c7_b525]
signal counter_MUX_prep_auth_data_c_l68_c7_b525_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l68_c7_b525_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l68_c7_b525_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l68_c7_b525_return_output : unsigned(15 downto 0);

-- aad_reg_MUX[prep_auth_data_c_l68_c7_b525]
signal aad_reg_MUX_prep_auth_data_c_l68_c7_b525_cond : unsigned(0 downto 0);
signal aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iftrue : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iffalse : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l68_c7_b525_return_output : uint8_t_32;

-- BIN_OP_EQ[prep_auth_data_c_l84_c11_9aef]
signal BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_left : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_right : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output : unsigned(0 downto 0);

-- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l84_c8_f9f8]
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l84_c8_f9f8]
signal state_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(1 downto 0);

-- prep_auth_data_axis_out_MUX[prep_auth_data_c_l84_c8_f9f8]
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : axis128_t_stream_t;

-- counter_MUX[prep_auth_data_c_l84_c8_f9f8]
signal counter_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(15 downto 0);

-- aad_reg_4_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_7_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_13_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_10_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_2_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_8_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_5_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_11_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_14_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_0_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_6_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_3_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_9_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_12_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_15_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- aad_reg_1_MUX[prep_auth_data_c_l84_c8_f9f8]
signal aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX[prep_auth_data_c_l91_c7_2781]
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[prep_auth_data_c_l99_c8_df5e]
signal BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_left : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_right : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l99_c5_624a]
signal state_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l99_c5_624a]
signal counter_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(15 downto 0);

-- aad_reg_4_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_7_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_13_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_10_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_2_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_8_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_5_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_11_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_14_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_0_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_6_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_3_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_9_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_12_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_15_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- aad_reg_1_MUX[prep_auth_data_c_l99_c5_624a]
signal aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);

-- BIN_OP_GT[prep_auth_data_c_l102_c10_9d43]
signal BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_left : unsigned(15 downto 0);
signal BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_right : unsigned(4 downto 0);
signal BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l102_c7_c29f]
signal state_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l102_c7_c29f]
signal counter_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(15 downto 0);

-- aad_reg_4_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_7_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_13_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_10_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_2_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_8_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_5_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_11_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_14_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_0_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_6_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_3_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_9_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_12_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_15_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- aad_reg_1_MUX[prep_auth_data_c_l102_c7_c29f]
signal aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);

-- BIN_OP_MINUS[prep_auth_data_c_l106_c9_a62d]
signal BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_left : unsigned(15 downto 0);
signal BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_return_output : unsigned(15 downto 0);

-- BIN_OP_EQ[prep_auth_data_c_l116_c11_3f55]
signal BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_left : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_right : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output : unsigned(0 downto 0);

-- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l116_c8_2dd3]
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l116_c8_2dd3]
signal state_MUX_prep_auth_data_c_l116_c8_2dd3_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l116_c8_2dd3_return_output : unsigned(1 downto 0);

-- prep_auth_data_axis_out_MUX[prep_auth_data_c_l116_c8_2dd3]
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_return_output : axis128_t_stream_t;

-- counter_MUX[prep_auth_data_c_l116_c8_2dd3]
signal counter_MUX_prep_auth_data_c_l116_c8_2dd3_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l116_c8_2dd3_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX[prep_auth_data_c_l128_c7_7299]
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[prep_auth_data_c_l134_c8_8de4]
signal BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_left : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_right : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l134_c5_88dd]
signal state_MUX_prep_auth_data_c_l134_c5_88dd_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l134_c5_88dd_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l134_c5_88dd_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l134_c5_88dd_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l134_c5_88dd]
signal counter_MUX_prep_auth_data_c_l134_c5_88dd_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l134_c5_88dd_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l134_c5_88dd_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l134_c5_88dd_return_output : unsigned(15 downto 0);

-- axis128_keep_count[prep_auth_data_c_l135_c18_f4cb]
signal axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_axis : axis128_t;
signal axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_return_output : unsigned(4 downto 0);

-- BIN_OP_PLUS[prep_auth_data_c_l135_c7_b1cb]
signal BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_left : unsigned(15 downto 0);
signal BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_right : unsigned(4 downto 0);
signal BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_return_output : unsigned(16 downto 0);

-- state_MUX[prep_auth_data_c_l137_c7_bc3d]
signal state_MUX_prep_auth_data_c_l137_c7_bc3d_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l137_c7_bc3d_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l137_c7_bc3d_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l137_c7_bc3d_return_output : unsigned(1 downto 0);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0[prep_auth_data_c_l150_c49_71ae]
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8[prep_auth_data_c_l150_c49_71ae]
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16[prep_auth_data_c_l150_c49_71ae]
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24[prep_auth_data_c_l150_c49_71ae]
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32[prep_auth_data_c_l150_c49_71ae]
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40[prep_auth_data_c_l150_c49_71ae]
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48[prep_auth_data_c_l150_c49_71ae]
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56[prep_auth_data_c_l150_c49_71ae]
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0[prep_auth_data_c_l157_c49_a1b6]
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8[prep_auth_data_c_l157_c49_a1b6]
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16[prep_auth_data_c_l157_c49_a1b6]
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24[prep_auth_data_c_l157_c49_a1b6]
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32[prep_auth_data_c_l157_c49_a1b6]
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40[prep_auth_data_c_l157_c49_a1b6]
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48[prep_auth_data_c_l157_c49_a1b6]
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56[prep_auth_data_c_l157_c49_a1b6]
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);

-- BIN_OP_AND[prep_auth_data_c_l166_c8_1cf3]
signal BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_left : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_right : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l166_c5_81fd]
signal state_MUX_prep_auth_data_c_l166_c5_81fd_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l166_c5_81fd_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l166_c5_81fd_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l166_c5_81fd_return_output : unsigned(1 downto 0);

function CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432( ref_toks_0 : axis128_t_stream_t;
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
 ref_toks_33 : unsigned) return axis128_t_stream_t is
 
  variable base : axis128_t_stream_t; 
  variable return_output : axis128_t_stream_t;
begin
      base := ref_toks_0;
      base.data.tdata(0) := ref_toks_1;
      base.data.tkeep(0) := ref_toks_2;
      base.data.tdata(1) := ref_toks_3;
      base.data.tkeep(1) := ref_toks_4;
      base.data.tdata(2) := ref_toks_5;
      base.data.tkeep(2) := ref_toks_6;
      base.data.tdata(3) := ref_toks_7;
      base.data.tkeep(3) := ref_toks_8;
      base.data.tdata(4) := ref_toks_9;
      base.data.tkeep(4) := ref_toks_10;
      base.data.tdata(5) := ref_toks_11;
      base.data.tkeep(5) := ref_toks_12;
      base.data.tdata(6) := ref_toks_13;
      base.data.tkeep(6) := ref_toks_14;
      base.data.tdata(7) := ref_toks_15;
      base.data.tkeep(7) := ref_toks_16;
      base.data.tdata(8) := ref_toks_17;
      base.data.tkeep(8) := ref_toks_18;
      base.data.tdata(9) := ref_toks_19;
      base.data.tkeep(9) := ref_toks_20;
      base.data.tdata(10) := ref_toks_21;
      base.data.tkeep(10) := ref_toks_22;
      base.data.tdata(11) := ref_toks_23;
      base.data.tkeep(11) := ref_toks_24;
      base.data.tdata(12) := ref_toks_25;
      base.data.tkeep(12) := ref_toks_26;
      base.data.tdata(13) := ref_toks_27;
      base.data.tkeep(13) := ref_toks_28;
      base.data.tdata(14) := ref_toks_29;
      base.data.tkeep(14) := ref_toks_30;
      base.data.tdata(15) := ref_toks_31;
      base.data.tkeep(15) := ref_toks_32;
      base.valid := ref_toks_33;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f( ref_toks_0 : axis128_t_stream_t;
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
 ref_toks_33 : unsigned) return axis128_t_stream_t is
 
  variable base : axis128_t_stream_t; 
  variable return_output : axis128_t_stream_t;
begin
      base := ref_toks_0;
      base.data.tlast := ref_toks_1;
      base.data.tkeep(0) := ref_toks_2;
      base.data.tdata(0) := ref_toks_3;
      base.data.tkeep(1) := ref_toks_4;
      base.data.tdata(1) := ref_toks_5;
      base.data.tkeep(2) := ref_toks_6;
      base.data.tdata(2) := ref_toks_7;
      base.data.tkeep(3) := ref_toks_8;
      base.data.tdata(3) := ref_toks_9;
      base.data.tkeep(4) := ref_toks_10;
      base.data.tdata(4) := ref_toks_11;
      base.data.tkeep(5) := ref_toks_12;
      base.data.tdata(5) := ref_toks_13;
      base.data.tkeep(6) := ref_toks_14;
      base.data.tdata(6) := ref_toks_15;
      base.data.tkeep(7) := ref_toks_16;
      base.data.tdata(7) := ref_toks_17;
      base.data.tkeep(8) := ref_toks_18;
      base.data.tdata(8) := ref_toks_19;
      base.data.tkeep(9) := ref_toks_20;
      base.data.tdata(9) := ref_toks_21;
      base.data.tkeep(10) := ref_toks_22;
      base.data.tdata(10) := ref_toks_23;
      base.data.tkeep(11) := ref_toks_24;
      base.data.tdata(11) := ref_toks_25;
      base.data.tkeep(12) := ref_toks_26;
      base.data.tdata(12) := ref_toks_27;
      base.data.tkeep(13) := ref_toks_28;
      base.data.tdata(13) := ref_toks_29;
      base.data.tkeep(14) := ref_toks_30;
      base.data.tdata(14) := ref_toks_31;
      base.data.tkeep(15) := ref_toks_32;
      base.data.tdata(15) := ref_toks_33;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377( ref_toks_0 : unsigned;
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
 ref_toks_33 : unsigned) return axis128_t_stream_t is
 
  variable base : axis128_t_stream_t; 
  variable return_output : axis128_t_stream_t;
begin
      base.data.tdata(0) := ref_toks_0;
      base.data.tkeep(0) := ref_toks_1;
      base.data.tdata(1) := ref_toks_2;
      base.data.tkeep(1) := ref_toks_3;
      base.data.tdata(2) := ref_toks_4;
      base.data.tkeep(2) := ref_toks_5;
      base.data.tdata(3) := ref_toks_6;
      base.data.tkeep(3) := ref_toks_7;
      base.data.tdata(4) := ref_toks_8;
      base.data.tkeep(4) := ref_toks_9;
      base.data.tdata(5) := ref_toks_10;
      base.data.tkeep(5) := ref_toks_11;
      base.data.tdata(6) := ref_toks_12;
      base.data.tkeep(6) := ref_toks_13;
      base.data.tdata(7) := ref_toks_14;
      base.data.tkeep(7) := ref_toks_15;
      base.data.tdata(8) := ref_toks_16;
      base.data.tkeep(8) := ref_toks_17;
      base.data.tdata(9) := ref_toks_18;
      base.data.tkeep(9) := ref_toks_19;
      base.data.tdata(10) := ref_toks_20;
      base.data.tkeep(10) := ref_toks_21;
      base.data.tdata(11) := ref_toks_22;
      base.data.tkeep(11) := ref_toks_23;
      base.data.tdata(12) := ref_toks_24;
      base.data.tkeep(12) := ref_toks_25;
      base.data.tdata(13) := ref_toks_26;
      base.data.tkeep(13) := ref_toks_27;
      base.data.tdata(14) := ref_toks_28;
      base.data.tkeep(14) := ref_toks_29;
      base.data.tdata(15) := ref_toks_30;
      base.data.tkeep(15) := ref_toks_31;
      base.data.tlast := ref_toks_32;
      base.valid := ref_toks_33;

      return_output := base;
      return return_output; 
end function;

function CONST_REF_RD_uint8_t_32_uint8_t_32_0d89( ref_toks_0 : uint8_t_32;
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
 ref_toks_16 : unsigned) return uint8_t_32 is
 
  variable base : uint8_t_32; 
  variable return_output : uint8_t_32;
begin
      base := ref_toks_0;
      base(4) := ref_toks_1;
      base(7) := ref_toks_2;
      base(13) := ref_toks_3;
      base(10) := ref_toks_4;
      base(2) := ref_toks_5;
      base(8) := ref_toks_6;
      base(5) := ref_toks_7;
      base(11) := ref_toks_8;
      base(14) := ref_toks_9;
      base(0) := ref_toks_10;
      base(6) := ref_toks_11;
      base(3) := ref_toks_12;
      base(9) := ref_toks_13;
      base(12) := ref_toks_14;
      base(15) := ref_toks_15;
      base(1) := ref_toks_16;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e : 0 clocks latency
BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e : entity work.BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78 port map (
BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_left,
BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_right,
BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output);

-- prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c : 0 clocks latency
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_cond,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_return_output);

-- state_MUX_prep_auth_data_c_l61_c3_9f2c : 0 clocks latency
state_MUX_prep_auth_data_c_l61_c3_9f2c : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l61_c3_9f2c_cond,
state_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue,
state_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse,
state_MUX_prep_auth_data_c_l61_c3_9f2c_return_output);

-- prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c : 0 clocks latency
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_cond,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_return_output);

-- counter_MUX_prep_auth_data_c_l61_c3_9f2c : 0 clocks latency
counter_MUX_prep_auth_data_c_l61_c3_9f2c : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l61_c3_9f2c_cond,
counter_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue,
counter_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse,
counter_MUX_prep_auth_data_c_l61_c3_9f2c_return_output);

-- aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c : 0 clocks latency
aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c : entity work.MUX_uint1_t_uint8_t_32_uint8_t_32_0CLK_de264c78 port map (
aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_cond,
aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue,
aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse,
aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_return_output);

-- state_MUX_prep_auth_data_c_l64_c5_aa3b : 0 clocks latency
state_MUX_prep_auth_data_c_l64_c5_aa3b : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l64_c5_aa3b_cond,
state_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue,
state_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse,
state_MUX_prep_auth_data_c_l64_c5_aa3b_return_output);

-- counter_MUX_prep_auth_data_c_l64_c5_aa3b : 0 clocks latency
counter_MUX_prep_auth_data_c_l64_c5_aa3b : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l64_c5_aa3b_cond,
counter_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue,
counter_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse,
counter_MUX_prep_auth_data_c_l64_c5_aa3b_return_output);

-- aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b : 0 clocks latency
aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b : entity work.MUX_uint1_t_uint8_t_32_uint8_t_32_0CLK_de264c78 port map (
aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_cond,
aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue,
aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse,
aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_return_output);

-- BIN_OP_GT_prep_auth_data_c_l68_c10_c6be : 0 clocks latency
BIN_OP_GT_prep_auth_data_c_l68_c10_c6be : entity work.BIN_OP_GT_uint8_t_uint1_t_0CLK_5af1a430 port map (
BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_left,
BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_right,
BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_return_output);

-- state_MUX_prep_auth_data_c_l68_c7_b525 : 0 clocks latency
state_MUX_prep_auth_data_c_l68_c7_b525 : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l68_c7_b525_cond,
state_MUX_prep_auth_data_c_l68_c7_b525_iftrue,
state_MUX_prep_auth_data_c_l68_c7_b525_iffalse,
state_MUX_prep_auth_data_c_l68_c7_b525_return_output);

-- counter_MUX_prep_auth_data_c_l68_c7_b525 : 0 clocks latency
counter_MUX_prep_auth_data_c_l68_c7_b525 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l68_c7_b525_cond,
counter_MUX_prep_auth_data_c_l68_c7_b525_iftrue,
counter_MUX_prep_auth_data_c_l68_c7_b525_iffalse,
counter_MUX_prep_auth_data_c_l68_c7_b525_return_output);

-- aad_reg_MUX_prep_auth_data_c_l68_c7_b525 : 0 clocks latency
aad_reg_MUX_prep_auth_data_c_l68_c7_b525 : entity work.MUX_uint1_t_uint8_t_32_uint8_t_32_0CLK_de264c78 port map (
aad_reg_MUX_prep_auth_data_c_l68_c7_b525_cond,
aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iftrue,
aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iffalse,
aad_reg_MUX_prep_auth_data_c_l68_c7_b525_return_output);

-- BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef : 0 clocks latency
BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef : entity work.BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78 port map (
BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_left,
BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_right,
BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output);

-- prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- state_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
state_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
state_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
state_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
state_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- counter_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
counter_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
counter_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
counter_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
counter_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8 : 0 clocks latency
aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_cond,
aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue,
aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse,
aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output);

-- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_cond,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iftrue,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iffalse,
FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_return_output);

-- BIN_OP_AND_prep_auth_data_c_l99_c8_df5e : 0 clocks latency
BIN_OP_AND_prep_auth_data_c_l99_c8_df5e : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_left,
BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_right,
BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output);

-- state_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
state_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l99_c5_624a_cond,
state_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
state_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
state_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- counter_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
counter_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l99_c5_624a_cond,
counter_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
counter_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
counter_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a : 0 clocks latency
aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_cond,
aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iftrue,
aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iffalse,
aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_return_output);

-- BIN_OP_GT_prep_auth_data_c_l102_c10_9d43 : 0 clocks latency
BIN_OP_GT_prep_auth_data_c_l102_c10_9d43 : entity work.BIN_OP_GT_uint16_t_uint5_t_0CLK_5af1a430 port map (
BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_left,
BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_right,
BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output);

-- state_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
state_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l102_c7_c29f_cond,
state_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
state_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
state_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- counter_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
counter_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l102_c7_c29f_cond,
counter_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
counter_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
counter_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f : 0 clocks latency
aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_cond,
aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iftrue,
aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iffalse,
aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_return_output);

-- BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d : 0 clocks latency
BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d : entity work.BIN_OP_MINUS_uint16_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_left,
BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_right,
BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_return_output);

-- BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55 : 0 clocks latency
BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55 : entity work.BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78 port map (
BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_left,
BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_right,
BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output);

-- prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3 : 0 clocks latency
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_cond,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_return_output);

-- state_MUX_prep_auth_data_c_l116_c8_2dd3 : 0 clocks latency
state_MUX_prep_auth_data_c_l116_c8_2dd3 : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l116_c8_2dd3_cond,
state_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue,
state_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse,
state_MUX_prep_auth_data_c_l116_c8_2dd3_return_output);

-- prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3 : 0 clocks latency
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3 : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_cond,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_return_output);

-- counter_MUX_prep_auth_data_c_l116_c8_2dd3 : 0 clocks latency
counter_MUX_prep_auth_data_c_l116_c8_2dd3 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l116_c8_2dd3_cond,
counter_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue,
counter_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse,
counter_MUX_prep_auth_data_c_l116_c8_2dd3_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr,
FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output);

-- FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_cond,
FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iftrue,
FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iffalse,
FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_return_output);

-- BIN_OP_AND_prep_auth_data_c_l134_c8_8de4 : 0 clocks latency
BIN_OP_AND_prep_auth_data_c_l134_c8_8de4 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_left,
BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_right,
BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_return_output);

-- state_MUX_prep_auth_data_c_l134_c5_88dd : 0 clocks latency
state_MUX_prep_auth_data_c_l134_c5_88dd : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l134_c5_88dd_cond,
state_MUX_prep_auth_data_c_l134_c5_88dd_iftrue,
state_MUX_prep_auth_data_c_l134_c5_88dd_iffalse,
state_MUX_prep_auth_data_c_l134_c5_88dd_return_output);

-- counter_MUX_prep_auth_data_c_l134_c5_88dd : 0 clocks latency
counter_MUX_prep_auth_data_c_l134_c5_88dd : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l134_c5_88dd_cond,
counter_MUX_prep_auth_data_c_l134_c5_88dd_iftrue,
counter_MUX_prep_auth_data_c_l134_c5_88dd_iffalse,
counter_MUX_prep_auth_data_c_l134_c5_88dd_return_output);

-- axis128_keep_count_prep_auth_data_c_l135_c18_f4cb : 0 clocks latency
axis128_keep_count_prep_auth_data_c_l135_c18_f4cb : entity work.axis128_keep_count_0CLK_08de2a73 port map (
axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_axis,
axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_return_output);

-- BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb : 0 clocks latency
BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb : entity work.BIN_OP_PLUS_uint16_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_left,
BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_right,
BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_return_output);

-- state_MUX_prep_auth_data_c_l137_c7_bc3d : 0 clocks latency
state_MUX_prep_auth_data_c_l137_c7_bc3d : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l137_c7_bc3d_cond,
state_MUX_prep_auth_data_c_l137_c7_bc3d_iftrue,
state_MUX_prep_auth_data_c_l137_c7_bc3d_iffalse,
state_MUX_prep_auth_data_c_l137_c7_bc3d_return_output);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae : entity work.CONST_SR_0_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_x,
FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_return_output);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae : entity work.CONST_SR_8_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_x,
FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_return_output);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae : entity work.CONST_SR_16_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_x,
FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_return_output);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae : entity work.CONST_SR_24_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_x,
FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_return_output);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae : entity work.CONST_SR_32_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_x,
FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_return_output);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae : entity work.CONST_SR_40_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_x,
FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_return_output);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae : entity work.CONST_SR_48_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_x,
FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_return_output);

-- FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae : entity work.CONST_SR_56_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_x,
FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_return_output);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6 : entity work.CONST_SR_0_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_x,
FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_return_output);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6 : entity work.CONST_SR_8_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_x,
FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_return_output);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6 : entity work.CONST_SR_16_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_x,
FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_return_output);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6 : entity work.CONST_SR_24_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_x,
FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_return_output);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6 : entity work.CONST_SR_32_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_x,
FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_return_output);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6 : entity work.CONST_SR_40_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_x,
FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_return_output);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6 : entity work.CONST_SR_48_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_x,
FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_return_output);

-- FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6 : entity work.CONST_SR_56_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_x,
FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_return_output);

-- BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3 : 0 clocks latency
BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_left,
BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_right,
BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_return_output);

-- state_MUX_prep_auth_data_c_l166_c5_81fd : 0 clocks latency
state_MUX_prep_auth_data_c_l166_c5_81fd : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l166_c5_81fd_cond,
state_MUX_prep_auth_data_c_l166_c5_81fd_iftrue,
state_MUX_prep_auth_data_c_l166_c5_81fd_iffalse,
state_MUX_prep_auth_data_c_l166_c5_81fd_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Registers
 state,
 aad_reg,
 counter,
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output,
 prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_return_output,
 state_MUX_prep_auth_data_c_l61_c3_9f2c_return_output,
 prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_return_output,
 counter_MUX_prep_auth_data_c_l61_c3_9f2c_return_output,
 aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_return_output,
 state_MUX_prep_auth_data_c_l64_c5_aa3b_return_output,
 counter_MUX_prep_auth_data_c_l64_c5_aa3b_return_output,
 aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_return_output,
 BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_return_output,
 state_MUX_prep_auth_data_c_l68_c7_b525_return_output,
 counter_MUX_prep_auth_data_c_l68_c7_b525_return_output,
 aad_reg_MUX_prep_auth_data_c_l68_c7_b525_return_output,
 BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output,
 prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 state_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 counter_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output,
 FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_return_output,
 BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output,
 state_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 counter_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_return_output,
 BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output,
 state_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 counter_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_return_output,
 BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_return_output,
 BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output,
 prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_return_output,
 state_MUX_prep_auth_data_c_l116_c8_2dd3_return_output,
 prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_return_output,
 counter_MUX_prep_auth_data_c_l116_c8_2dd3_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output,
 FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_return_output,
 BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_return_output,
 state_MUX_prep_auth_data_c_l134_c5_88dd_return_output,
 counter_MUX_prep_auth_data_c_l134_c5_88dd_return_output,
 axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_return_output,
 BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_return_output,
 state_MUX_prep_auth_data_c_l137_c7_bc3d_return_output,
 FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_return_output,
 FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_return_output,
 FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_return_output,
 FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_return_output,
 FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_return_output,
 FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_return_output,
 FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_return_output,
 FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_return_output,
 FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_return_output,
 FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_return_output,
 FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_return_output,
 FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_return_output,
 FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_return_output,
 FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_return_output,
 FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_return_output,
 FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_return_output,
 BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_return_output,
 state_MUX_prep_auth_data_c_l166_c5_81fd_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_out : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_in : axis128_t_stream_t;
 variable VAR_prep_auth_data_aad_len : unsigned(7 downto 0);
 variable VAR_prep_auth_data_aad : uint8_t_32;
 variable VAR_prep_auth_data_axis_out_ready : unsigned(0 downto 0);
 variable VAR_axis128_null : axis128_t_stream_t;
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_left : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_right : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_return_output : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse : uint8_t_32;
 variable VAR_aad_reg_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_32_uint8_t_32_0d89_prep_auth_data_c_l61_c3_9f2c_return_output : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_return_output : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l68_c7_b525_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_return_output : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l68_c7_b525_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l68_c7_b525_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l68_c7_b525_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_iftrue : unsigned(15 downto 0);
 variable VAR_counter_prep_auth_data_c_l73_c9_9f8e : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iftrue : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iffalse : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_left : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_right : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432_prep_auth_data_c_l84_c8_f9f8_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_cond : unsigned(0 downto 0);
 variable VAR_i : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_cond : unsigned(0 downto 0);
 variable VAR_ARRAY_SHIFT_DOWN_i : unsigned(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_8_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_9_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_10_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_11_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_12_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_13_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_14_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_15_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d_prep_auth_data_c_l105_c144_8cc5_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_return_output : unsigned(15 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_left : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_right : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f_prep_auth_data_c_l116_c8_2dd3_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377_prep_auth_data_c_l116_c8_2dd3_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_0_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_1_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_2_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_3_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_4_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_5_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_6_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_7_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_8_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_9_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_10_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_11_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_12_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_13_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_14_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_15_d41d_prep_auth_data_c_l128_c11_e33b_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_iftrue : unsigned(15 downto 0);
 variable VAR_counter_prep_auth_data_c_l135_c7_ce0a : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_left : unsigned(15 downto 0);
 variable VAR_axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_axis : axis128_t;
 variable VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_right : unsigned(4 downto 0);
 variable VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_prep_auth_data_c_l135_c37_d7ce_return_output : axis128_t;
 variable VAR_axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_return_output : unsigned(4 downto 0);
 variable VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_return_output : unsigned(16 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_prep_auth_data_c_l137_c10_5443_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_cond : unsigned(0 downto 0);
 variable VAR_pos : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_prep_auth_data_axis_out_data_tdata_8_prep_auth_data_c_l157_c7_254e : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_prep_auth_data_axis_out_data_tdata_9_prep_auth_data_c_l157_c7_254e : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_prep_auth_data_axis_out_data_tdata_10_prep_auth_data_c_l157_c7_254e : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_prep_auth_data_axis_out_data_tdata_11_prep_auth_data_c_l157_c7_254e : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_prep_auth_data_axis_out_data_tdata_12_prep_auth_data_c_l157_c7_254e : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_prep_auth_data_axis_out_data_tdata_13_prep_auth_data_c_l157_c7_254e : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_prep_auth_data_axis_out_data_tdata_14_prep_auth_data_c_l157_c7_254e : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_prep_auth_data_axis_out_data_tdata_15_prep_auth_data_c_l157_c7_254e : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_x : unsigned(15 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l64_l134_DUPLICATE_8d72_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cac0_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_86a9_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d233_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_c012_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_72cf_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_81ee_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_4d98_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b77f_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_164f_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b80f_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_24a9_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_0760_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l92_l102_l99_l84_DUPLICATE_a808_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_3a9e_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0ce4_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_fbfd_return_output : unsigned(7 downto 0);
 -- State registers comb logic variables
variable REG_VAR_state : unsigned(1 downto 0);
variable REG_VAR_aad_reg : uint8_t_32;
variable REG_VAR_counter : unsigned(15 downto 0);
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_state := state;
  REG_VAR_aad_reg := aad_reg;
  REG_VAR_counter := counter;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(15, 32);
     VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := to_unsigned(0, 16);
     VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_left := to_unsigned(1, 1);
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse := to_unsigned(0, 1);
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue := to_unsigned(0, 1);
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := to_unsigned(0, 1);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(6, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(14, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(5, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(3, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(2, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(10, 32);
     VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_right := to_unsigned(0, 1);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iftrue := to_unsigned(0, 8);
     VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := unsigned(prep_auth_data_state_t_to_slv(CIPHERTEXT));
     VAR_state_MUX_prep_auth_data_c_l68_c7_b525_iftrue := unsigned(prep_auth_data_state_t_to_slv(AAD));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(4, 32);
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue := axis128_t_stream_t_NULL;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(11, 32);
     VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_right := unsigned(prep_auth_data_state_t_to_slv(AAD));
     VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_iffalse := to_unsigned(0, 16);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(1, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(9, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(0, 32);
     VAR_state_MUX_prep_auth_data_c_l68_c7_b525_iffalse := unsigned(prep_auth_data_state_t_to_slv(CIPHERTEXT));
     VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_right := unsigned(prep_auth_data_state_t_to_slv(CIPHERTEXT));
     VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_iftrue := unsigned(prep_auth_data_state_t_to_slv(IDLE));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(13, 32);
     VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_right := unsigned(prep_auth_data_state_t_to_slv(IDLE));
     VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_right := to_unsigned(16, 5);
     VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_left := to_unsigned(1, 1);
     VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_iftrue := unsigned(prep_auth_data_state_t_to_slv(LENGTHS));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(7, 32);
     VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_right := to_unsigned(16, 5);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(8, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right := to_signed(12, 32);
     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(0);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(1);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(10);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(7);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(2);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(9);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(14);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(8);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(5);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(15);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(11);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(4);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(12);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(3);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(13);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d[prep_auth_data_c_l91_c7_2781] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l91_c7_2781_return_output := axis128_t_stream_t_NULL.data.tdata(6);

     -- Submodule level 1
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l91_c7_2781_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l91_c7_2781_return_output;
 -- Reads from global variables
     VAR_prep_auth_data_axis_in := global_to_module.prep_auth_data_axis_in;
     VAR_prep_auth_data_aad_len := global_to_module.prep_auth_data_aad_len;
     VAR_prep_auth_data_aad := global_to_module.prep_auth_data_aad;
     VAR_prep_auth_data_axis_out_ready := global_to_module.prep_auth_data_axis_out_ready;
     -- Submodule level 0
     VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_right := VAR_prep_auth_data_axis_out_ready;
     VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_right := VAR_prep_auth_data_axis_out_ready;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue := VAR_prep_auth_data_axis_out_ready;
     VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_right := VAR_prep_auth_data_axis_out_ready;
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_x := VAR_prep_auth_data_aad_len;
     VAR_counter_prep_auth_data_c_l73_c9_9f8e := resize(VAR_prep_auth_data_aad_len, 16);
     VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_iftrue := VAR_counter_prep_auth_data_c_l73_c9_9f8e;
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_x := VAR_prep_auth_data_aad_len;
     VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_left := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_x := VAR_prep_auth_data_aad_len;
     VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iftrue := VAR_prep_auth_data_aad;
     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_15_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_15_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_15_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(15);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(10);

     -- FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24[prep_auth_data_c_l150_c49_71ae] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_x <= VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_return_output := FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_return_output;

     -- FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40[prep_auth_data_c_l150_c49_71ae] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_x <= VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_return_output := FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_2_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_2_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(2);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_6_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_6_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_6_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(6);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(7);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_3_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_3_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_3_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(3);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_1_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_1_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(1);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(4);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(15);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(1);

     -- CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d[prep_auth_data_c_l135_c37_d7ce] LATENCY=0
     VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_prep_auth_data_c_l135_c37_d7ce_return_output := VAR_prep_auth_data_axis_in.data;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_12_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_12_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_12_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(12);

     -- FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16[prep_auth_data_c_l150_c49_71ae] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_x <= VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_return_output := FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_4_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_4_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_4_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(4);

     -- FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56[prep_auth_data_c_l150_c49_71ae] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_x <= VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_return_output := FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_14_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_14_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_14_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(14);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(0);

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l64_l134_DUPLICATE_8d72 LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l64_l134_DUPLICATE_8d72_return_output := VAR_prep_auth_data_axis_in.valid;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_10_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_10_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_10_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(10);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_13_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_13_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_13_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(13);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_7_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_7_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_7_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(7);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(9);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_11_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_11_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_11_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(11);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(14);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_0_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_0_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(0);

     -- FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32[prep_auth_data_c_l150_c49_71ae] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_x <= VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_return_output := FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_return_output;

     -- FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8[prep_auth_data_c_l150_c49_71ae] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_x <= VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_return_output := FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(2);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_8_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_8_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_8_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(8);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(11);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(13);

     -- FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0[prep_auth_data_c_l150_c49_71ae] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_x <= VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_return_output := FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_5_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_5_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_5_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(5);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(12);

     -- FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48[prep_auth_data_c_l150_c49_71ae] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_x <= VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_return_output := FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(6);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_9_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_9_d41d[prep_auth_data_c_l128_c11_e33b] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_9_d41d_prep_auth_data_c_l128_c11_e33b_return_output := VAR_prep_auth_data_axis_in.data.tkeep(9);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(3);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(5);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d[prep_auth_data_c_l128_c7_7299] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l128_c7_7299_return_output := VAR_prep_auth_data_axis_in.data.tdata(8);

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[prep_auth_data_c_l137_c10_5443] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_prep_auth_data_c_l137_c10_5443_return_output := VAR_prep_auth_data_axis_in.data.tlast;

     -- Submodule level 1
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_7_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_prep_auth_data_c_l137_c10_5443_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l64_l134_DUPLICATE_8d72_return_output;
     VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l64_l134_DUPLICATE_8d72_return_output;
     VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l64_l134_DUPLICATE_8d72_return_output;
     VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l64_l134_DUPLICATE_8d72_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_3_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_1_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_15_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_11_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_4_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_9_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_axis := VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_prep_auth_data_c_l135_c37_d7ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_6_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_13_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_10_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_12_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_8_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_5_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l128_c7_7299_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_0_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_2_d41d_prep_auth_data_c_l128_c11_e33b_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_14_d41d_prep_auth_data_c_l128_c11_e33b_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse := aad_reg;
     VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iffalse := aad_reg;
     VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_left := counter;
     VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_left := counter;
     VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_left := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_x := counter;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse := counter;
     VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_iffalse := counter;
     VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse := counter;
     VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_iffalse := counter;
     VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_left := state;
     VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_left := state;
     VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_left := state;
     VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := state;
     VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_iffalse := state;
     VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_iffalse := state;
     VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_iffalse := state;
     VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse := state;
     VAR_state_MUX_prep_auth_data_c_l99_c5_624a_iffalse := state;
     -- BIN_OP_AND[prep_auth_data_c_l166_c8_1cf3] LATENCY=0
     -- Inputs
     BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_left <= VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_left;
     BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_right <= VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_right;
     -- Outputs
     VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_return_output := BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_0760 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_0760_return_output := aad_reg(11);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_86a9 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_86a9_return_output := aad_reg(1);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_fbfd LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_fbfd_return_output := aad_reg(15);

     -- BIN_OP_EQ[prep_auth_data_c_l84_c11_9aef] LATENCY=0
     -- Inputs
     BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_left <= VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_left;
     BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_right <= VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_right;
     -- Outputs
     VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output := BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32[prep_auth_data_c_l157_c49_a1b6] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_x <= VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_return_output := FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_15_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_15_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(31);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- BIN_OP_EQ[prep_auth_data_c_l116_c11_3f55] LATENCY=0
     -- Inputs
     BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_left <= VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_left;
     BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_right <= VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_right;
     -- Outputs
     VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output := BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output;

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_9_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_9_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(25);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0ce4 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0ce4_return_output := aad_reg(14);

     -- BIN_OP_AND[prep_auth_data_c_l99_c8_df5e] LATENCY=0
     -- Inputs
     BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_left <= VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_left;
     BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_right <= VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_right;
     -- Outputs
     VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output := BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(18);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_81ee LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_81ee_return_output := aad_reg(5);

     -- BIN_OP_MINUS[prep_auth_data_c_l106_c9_a62d] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_left <= VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_left;
     BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_right <= VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_right;
     -- Outputs
     VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_return_output := BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cac0 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cac0_return_output := aad_reg(0);

     -- BIN_OP_AND[prep_auth_data_c_l134_c8_8de4] LATENCY=0
     -- Inputs
     BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_left <= VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_left;
     BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_right <= VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_right;
     -- Outputs
     VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_return_output := BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_return_output;

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(17);

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_14_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_14_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(30);

     -- CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d233 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d233_return_output := aad_reg(2);

     -- FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24[prep_auth_data_c_l157_c49_a1b6] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_x <= VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_return_output := FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l92_l102_l99_l84_DUPLICATE_a808 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l92_l102_l99_l84_DUPLICATE_a808_return_output := aad_reg(12);

     -- CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b80f LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b80f_return_output := aad_reg(9);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- axis128_keep_count[prep_auth_data_c_l135_c18_f4cb] LATENCY=0
     -- Inputs
     axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_axis <= VAR_axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_axis;
     -- Outputs
     VAR_axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_return_output := axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_24a9 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_24a9_return_output := aad_reg(10);

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_13_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_13_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(29);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_72cf LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_72cf_return_output := aad_reg(4);

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(16);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_4d98 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_4d98_return_output := aad_reg(6);

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_11_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_11_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(27);

     -- BIN_OP_GT[prep_auth_data_c_l102_c10_9d43] LATENCY=0
     -- Inputs
     BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_left <= VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_left;
     BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_right <= VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_right;
     -- Outputs
     VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output := BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- state_MUX[prep_auth_data_c_l137_c7_bc3d] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l137_c7_bc3d_cond <= VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_cond;
     state_MUX_prep_auth_data_c_l137_c7_bc3d_iftrue <= VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_iftrue;
     state_MUX_prep_auth_data_c_l137_c7_bc3d_iffalse <= VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_return_output := state_MUX_prep_auth_data_c_l137_c7_bc3d_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40[prep_auth_data_c_l157_c49_a1b6] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_x <= VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_return_output := FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- BIN_OP_EQ[prep_auth_data_c_l61_c6_fe8e] LATENCY=0
     -- Inputs
     BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_left <= VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_left;
     BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_right <= VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_right;
     -- Outputs
     VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output := BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_10_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_10_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(26);

     -- FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16[prep_auth_data_c_l157_c49_a1b6] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_x <= VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_return_output := FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_return_output;

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_8_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_8_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(24);

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_12_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_12_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(28);

     -- FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8[prep_auth_data_c_l157_c49_a1b6] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_x <= VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_return_output := FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_return_output;

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(20);

     -- BIN_OP_GT[prep_auth_data_c_l68_c10_c6be] LATENCY=0
     -- Inputs
     BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_left <= VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_left;
     BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_right <= VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_right;
     -- Outputs
     VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_return_output := BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56[prep_auth_data_c_l157_c49_a1b6] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_x <= VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_return_output := FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_3a9e LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_3a9e_return_output := aad_reg(13);

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(23);

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(19);

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT[prep_auth_data_c_l91_c10_08b5] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_left;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48[prep_auth_data_c_l157_c49_a1b6] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_x <= VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_return_output := FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_return_output;

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(21);

     -- FOR_prep_auth_data_c_l105_c38_7a16_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d[prep_auth_data_c_l105_c144_8cc5] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d_prep_auth_data_c_l105_c144_8cc5_return_output := aad_reg(22);

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT[prep_auth_data_c_l128_c11_537c] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0[prep_auth_data_c_l157_c49_a1b6] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_x <= VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_return_output := FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_164f LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_164f_return_output := aad_reg(8);

     -- CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_c012 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_c012_return_output := aad_reg(3);

     -- CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b77f LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b77f_return_output := aad_reg(7);

     -- Submodule level 1
     VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_cond := VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_return_output;
     VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_cond := VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_8de4_return_output;
     VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_cond := VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_1cf3_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_state_MUX_prep_auth_data_c_l99_c5_624a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_df5e_return_output;
     VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output;
     VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3f55_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output;
     VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output;
     VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_fe8e_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_9aef_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_9d43_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_cond := VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_return_output;
     VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_cond := VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_return_output;
     VAR_state_MUX_prep_auth_data_c_l68_c7_b525_cond := VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_c6be_return_output;
     VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_a62d_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cac0_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cac0_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cac0_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cac0_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_24a9_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_24a9_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_24a9_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_24a9_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_0760_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_0760_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_0760_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_0760_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l92_l102_l99_l84_DUPLICATE_a808_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l92_l102_l99_l84_DUPLICATE_a808_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l92_l102_l99_l84_DUPLICATE_a808_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l92_l102_l99_l84_DUPLICATE_a808_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_3a9e_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_3a9e_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_3a9e_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_3a9e_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0ce4_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0ce4_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0ce4_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0ce4_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_fbfd_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_fbfd_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_fbfd_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_fbfd_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_86a9_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_86a9_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_86a9_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_86a9_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d233_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d233_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d233_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d233_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_c012_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_c012_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_c012_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_c012_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_72cf_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_72cf_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_72cf_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_72cf_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_81ee_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_81ee_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_81ee_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_81ee_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_4d98_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_4d98_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_4d98_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_4d98_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b77f_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b77f_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b77f_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b77f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_164f_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_164f_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_164f_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_164f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b80f_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b80f_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b80f_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l102_l99_l92_l84_DUPLICATE_b80f_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_10_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_11_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_12_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_13_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_14_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_15_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_8_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_7a16_ITER_9_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d_prep_auth_data_c_l105_c144_8cc5_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_cond := VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_537c_return_output;
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_prep_auth_data_axis_out_data_tdata_8_prep_auth_data_c_l157_c7_254e := resize(VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_a1b6_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_prep_auth_data_axis_out_data_tdata_9_prep_auth_data_c_l157_c7_254e := resize(VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_a1b6_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_prep_auth_data_axis_out_data_tdata_10_prep_auth_data_c_l157_c7_254e := resize(VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_a1b6_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_prep_auth_data_axis_out_data_tdata_11_prep_auth_data_c_l157_c7_254e := resize(VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_a1b6_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_prep_auth_data_axis_out_data_tdata_12_prep_auth_data_c_l157_c7_254e := resize(VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_a1b6_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_prep_auth_data_axis_out_data_tdata_13_prep_auth_data_c_l157_c7_254e := resize(VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_a1b6_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_prep_auth_data_axis_out_data_tdata_14_prep_auth_data_c_l157_c7_254e := resize(VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_a1b6_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_prep_auth_data_axis_out_data_tdata_15_prep_auth_data_c_l157_c7_254e := resize(VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_a1b6_return_output, 8);
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_cond := VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_08b5_return_output;
     VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_right := VAR_axis128_keep_count_prep_auth_data_c_l135_c18_f4cb_return_output;
     VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_iftrue := VAR_state_MUX_prep_auth_data_c_l137_c7_bc3d_return_output;
     -- aad_reg_0_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- aad_reg_14_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- aad_reg_1_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- aad_reg_3_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- aad_reg_11_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l116_c8_2dd3] LATENCY=0
     -- Inputs
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_cond <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_cond;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_return_output := prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_return_output;

     -- state_MUX[prep_auth_data_c_l134_c5_88dd] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l134_c5_88dd_cond <= VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_cond;
     state_MUX_prep_auth_data_c_l134_c5_88dd_iftrue <= VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_iftrue;
     state_MUX_prep_auth_data_c_l134_c5_88dd_iffalse <= VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_return_output := state_MUX_prep_auth_data_c_l134_c5_88dd_return_output;

     -- aad_reg_10_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- aad_reg_5_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- aad_reg_9_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- aad_reg_2_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- aad_reg_15_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- aad_reg_MUX[prep_auth_data_c_l68_c7_b525] LATENCY=0
     -- Inputs
     aad_reg_MUX_prep_auth_data_c_l68_c7_b525_cond <= VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_cond;
     aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iftrue <= VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iftrue;
     aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iffalse <= VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_iffalse;
     -- Outputs
     VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_return_output := aad_reg_MUX_prep_auth_data_c_l68_c7_b525_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- state_MUX[prep_auth_data_c_l68_c7_b525] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l68_c7_b525_cond <= VAR_state_MUX_prep_auth_data_c_l68_c7_b525_cond;
     state_MUX_prep_auth_data_c_l68_c7_b525_iftrue <= VAR_state_MUX_prep_auth_data_c_l68_c7_b525_iftrue;
     state_MUX_prep_auth_data_c_l68_c7_b525_iffalse <= VAR_state_MUX_prep_auth_data_c_l68_c7_b525_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l68_c7_b525_return_output := state_MUX_prep_auth_data_c_l68_c7_b525_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- state_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     state_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     state_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_return_output := state_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- aad_reg_13_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- counter_MUX[prep_auth_data_c_l68_c7_b525] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l68_c7_b525_cond <= VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_cond;
     counter_MUX_prep_auth_data_c_l68_c7_b525_iftrue <= VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_iftrue;
     counter_MUX_prep_auth_data_c_l68_c7_b525_iffalse <= VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_return_output := counter_MUX_prep_auth_data_c_l68_c7_b525_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- state_MUX[prep_auth_data_c_l166_c5_81fd] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l166_c5_81fd_cond <= VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_cond;
     state_MUX_prep_auth_data_c_l166_c5_81fd_iftrue <= VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_iftrue;
     state_MUX_prep_auth_data_c_l166_c5_81fd_iffalse <= VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_return_output := state_MUX_prep_auth_data_c_l166_c5_81fd_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- aad_reg_6_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX[prep_auth_data_c_l128_c7_7299] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_cond <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_cond;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iftrue;
     FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_return_output := FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_return_output;

     -- aad_reg_8_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- BIN_OP_PLUS[prep_auth_data_c_l135_c7_b1cb] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_left <= VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_left;
     BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_right <= VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_right;
     -- Outputs
     VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_return_output := BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_return_output;

     -- aad_reg_12_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- prep_auth_data_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377[prep_auth_data_c_l116_c8_2dd3] LATENCY=0
     VAR_prep_auth_data_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377_prep_auth_data_c_l116_c8_2dd3_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377(
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_71ae_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_71ae_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_71ae_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_71ae_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_71ae_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_71ae_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_71ae_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_b226_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_71ae_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_0_prep_auth_data_axis_out_data_tdata_8_prep_auth_data_c_l157_c7_254e,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_1_prep_auth_data_axis_out_data_tdata_9_prep_auth_data_c_l157_c7_254e,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_2_prep_auth_data_axis_out_data_tdata_10_prep_auth_data_c_l157_c7_254e,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_3_prep_auth_data_axis_out_data_tdata_11_prep_auth_data_c_l157_c7_254e,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_4_prep_auth_data_axis_out_data_tdata_12_prep_auth_data_c_l157_c7_254e,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_5_prep_auth_data_axis_out_data_tdata_13_prep_auth_data_c_l157_c7_254e,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_6_prep_auth_data_axis_out_data_tdata_14_prep_auth_data_c_l157_c7_254e,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d59d_ITER_7_prep_auth_data_axis_out_data_tdata_15_prep_auth_data_c_l157_c7_254e,
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1));

     -- FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX[prep_auth_data_c_l91_c7_2781] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_cond <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_cond;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iftrue;
     FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_return_output := FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_return_output;

     -- aad_reg_4_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- aad_reg_7_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_return_output := aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- counter_MUX[prep_auth_data_c_l102_c7_c29f] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l102_c7_c29f_cond <= VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_cond;
     counter_MUX_prep_auth_data_c_l102_c7_c29f_iftrue <= VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_iftrue;
     counter_MUX_prep_auth_data_c_l102_c7_c29f_iffalse <= VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_return_output := counter_MUX_prep_auth_data_c_l102_c7_c29f_return_output;

     -- Submodule level 2
     VAR_counter_prep_auth_data_c_l135_c7_ce0a := resize(VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_b1cb_return_output, 16);
     VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue := VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_b525_return_output;
     VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_counter_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue := VAR_counter_MUX_prep_auth_data_c_l68_c7_b525_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_2dd3_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse := VAR_prep_auth_data_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377_prep_auth_data_c_l116_c8_2dd3_return_output;
     VAR_state_MUX_prep_auth_data_c_l99_c5_624a_iftrue := VAR_state_MUX_prep_auth_data_c_l102_c7_c29f_return_output;
     VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue := VAR_state_MUX_prep_auth_data_c_l134_c5_88dd_return_output;
     VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse := VAR_state_MUX_prep_auth_data_c_l166_c5_81fd_return_output;
     VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue := VAR_state_MUX_prep_auth_data_c_l68_c7_b525_return_output;
     VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_iftrue := VAR_counter_prep_auth_data_c_l135_c7_ce0a;
     -- aad_reg_MUX[prep_auth_data_c_l64_c5_aa3b] LATENCY=0
     -- Inputs
     aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_cond <= VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_cond;
     aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue <= VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue;
     aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse <= VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse;
     -- Outputs
     VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_return_output := aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_return_output;

     -- counter_MUX[prep_auth_data_c_l64_c5_aa3b] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l64_c5_aa3b_cond <= VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_cond;
     counter_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue <= VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue;
     counter_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse <= VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_return_output := counter_MUX_prep_auth_data_c_l64_c5_aa3b_return_output;

     -- aad_reg_10_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_14_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_8_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_9_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- counter_MUX[prep_auth_data_c_l134_c5_88dd] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l134_c5_88dd_cond <= VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_cond;
     counter_MUX_prep_auth_data_c_l134_c5_88dd_iftrue <= VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_iftrue;
     counter_MUX_prep_auth_data_c_l134_c5_88dd_iffalse <= VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_return_output := counter_MUX_prep_auth_data_c_l134_c5_88dd_return_output;

     -- aad_reg_5_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_15_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- state_MUX[prep_auth_data_c_l116_c8_2dd3] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l116_c8_2dd3_cond <= VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_cond;
     state_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue <= VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue;
     state_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse <= VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_return_output := state_MUX_prep_auth_data_c_l116_c8_2dd3_return_output;

     -- aad_reg_3_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_11_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_7_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_2_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f[prep_auth_data_c_l116_c8_2dd3] LATENCY=0
     VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f_prep_auth_data_c_l116_c8_2dd3_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f(
     VAR_prep_auth_data_axis_in,
     to_unsigned(0, 1),
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_7299_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_d820_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_7299_return_output);

     -- state_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_state_MUX_prep_auth_data_c_l99_c5_624a_cond;
     state_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_state_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     state_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_state_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l99_c5_624a_return_output := state_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_13_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_0_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_12_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_6_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- counter_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_cond;
     counter_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     counter_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_return_output := counter_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- aad_reg_1_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- state_MUX[prep_auth_data_c_l64_c5_aa3b] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l64_c5_aa3b_cond <= VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_cond;
     state_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue <= VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_iftrue;
     state_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse <= VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_return_output := state_MUX_prep_auth_data_c_l64_c5_aa3b_return_output;

     -- prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432_prep_auth_data_c_l84_c8_f9f8_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432(
     axis128_t_stream_t_NULL,
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_f4b7_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_2781_return_output,
     to_unsigned(1, 1),
     to_unsigned(1, 1));

     -- aad_reg_4_MUX[prep_auth_data_c_l99_c5_624a] LATENCY=0
     -- Inputs
     aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_cond <= VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_cond;
     aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iftrue <= VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iftrue;
     aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iffalse <= VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_iffalse;
     -- Outputs
     VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_return_output := aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_return_output;

     -- Submodule level 3
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue := VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_aa3b_return_output;
     VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue := VAR_counter_MUX_prep_auth_data_c_l134_c5_88dd_return_output;
     VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue := VAR_counter_MUX_prep_auth_data_c_l64_c5_aa3b_return_output;
     VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_counter_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse := VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue := VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f_prep_auth_data_c_l116_c8_2dd3_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432_prep_auth_data_c_l84_c8_f9f8_return_output;
     VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_state_MUX_prep_auth_data_c_l116_c8_2dd3_return_output;
     VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue := VAR_state_MUX_prep_auth_data_c_l64_c5_aa3b_return_output;
     VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue := VAR_state_MUX_prep_auth_data_c_l99_c5_624a_return_output;
     -- aad_reg_11_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_8_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l61_c3_9f2c] LATENCY=0
     -- Inputs
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_cond <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_cond;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_return_output := prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;

     -- aad_reg_7_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_15_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- prep_auth_data_axis_out_MUX[prep_auth_data_c_l116_c8_2dd3] LATENCY=0
     -- Inputs
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_cond <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_cond;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_return_output := prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_return_output;

     -- aad_reg_2_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_5_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_14_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_6_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_13_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_3_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- counter_MUX[prep_auth_data_c_l116_c8_2dd3] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l116_c8_2dd3_cond <= VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_cond;
     counter_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue <= VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_iftrue;
     counter_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse <= VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_return_output := counter_MUX_prep_auth_data_c_l116_c8_2dd3_return_output;

     -- aad_reg_9_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_4_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_1_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_0_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- state_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     state_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     state_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := state_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_12_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_10_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- Submodule level 4
     VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_counter_MUX_prep_auth_data_c_l116_c8_2dd3_return_output;
     VAR_prep_auth_data_axis_in_ready := VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse := VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_2dd3_return_output;
     VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse := VAR_state_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;
     -- prep_auth_data_axis_out_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- counter_MUX[prep_auth_data_c_l84_c8_f9f8] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l84_c8_f9f8_cond <= VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_cond;
     counter_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue <= VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_iftrue;
     counter_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse <= VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_return_output := counter_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;

     -- aad_reg_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_32_uint8_t_32_0d89[prep_auth_data_c_l61_c3_9f2c] LATENCY=0
     VAR_aad_reg_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_32_uint8_t_32_0d89_prep_auth_data_c_l61_c3_9f2c_return_output := CONST_REF_RD_uint8_t_32_uint8_t_32_0d89(
     aad_reg,
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_f9f8_return_output,
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_f9f8_return_output);

     -- state_MUX[prep_auth_data_c_l61_c3_9f2c] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l61_c3_9f2c_cond <= VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_cond;
     state_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue <= VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue;
     state_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse <= VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_return_output := state_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;

     -- Submodule level 5
     VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse := VAR_aad_reg_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_32_uint8_t_32_0d89_prep_auth_data_c_l61_c3_9f2c_return_output;
     VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse := VAR_counter_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse := VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_f9f8_return_output;
     REG_VAR_state := VAR_state_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;
     -- prep_auth_data_axis_out_MUX[prep_auth_data_c_l61_c3_9f2c] LATENCY=0
     -- Inputs
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_cond <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_cond;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_return_output := prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;

     -- counter_MUX[prep_auth_data_c_l61_c3_9f2c] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l61_c3_9f2c_cond <= VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_cond;
     counter_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue <= VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue;
     counter_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse <= VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_return_output := counter_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;

     -- aad_reg_MUX[prep_auth_data_c_l61_c3_9f2c] LATENCY=0
     -- Inputs
     aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_cond <= VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_cond;
     aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue <= VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iftrue;
     aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse <= VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_iffalse;
     -- Outputs
     VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_return_output := aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;

     -- Submodule level 6
     REG_VAR_aad_reg := VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;
     REG_VAR_counter := VAR_counter_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;
     VAR_prep_auth_data_axis_out := VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_9f2c_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_state <= REG_VAR_state;
REG_COMB_aad_reg <= REG_VAR_aad_reg;
REG_COMB_counter <= REG_VAR_counter;
-- Global wires driven various places in pipeline
if clk_en_internal='1' then
  module_to_global.prep_auth_data_axis_in_ready <= VAR_prep_auth_data_axis_in_ready;
else
  module_to_global.prep_auth_data_axis_in_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.prep_auth_data_axis_out <= VAR_prep_auth_data_axis_out;
else
  module_to_global.prep_auth_data_axis_out <= axis128_t_stream_t_NULL;
end if;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     state <= REG_COMB_state;
     aad_reg <= REG_COMB_aad_reg;
     counter <= REG_COMB_counter;
 end if;
 end if;
end process;

end arch;
