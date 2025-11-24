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
-- BIN_OP_EQ[prep_auth_data_c_l61_c6_d92c]
signal BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_left : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_right : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l61_c3_719c]
signal state_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l61_c3_719c_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l61_c3_719c_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l61_c3_719c_return_output : unsigned(1 downto 0);

-- prep_auth_data_axis_out_MUX[prep_auth_data_c_l61_c3_719c]
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iftrue : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iffalse : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_return_output : axis128_t_stream_t;

-- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l61_c3_719c]
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iftrue : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iffalse : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_return_output : unsigned(0 downto 0);

-- counter_MUX[prep_auth_data_c_l61_c3_719c]
signal counter_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l61_c3_719c_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l61_c3_719c_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l61_c3_719c_return_output : unsigned(15 downto 0);

-- aad_reg_MUX[prep_auth_data_c_l61_c3_719c]
signal aad_reg_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
signal aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iftrue : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iffalse : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l61_c3_719c_return_output : uint8_t_32;

-- state_MUX[prep_auth_data_c_l64_c5_acb2]
signal state_MUX_prep_auth_data_c_l64_c5_acb2_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l64_c5_acb2_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l64_c5_acb2_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l64_c5_acb2_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l64_c5_acb2]
signal counter_MUX_prep_auth_data_c_l64_c5_acb2_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l64_c5_acb2_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l64_c5_acb2_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l64_c5_acb2_return_output : unsigned(15 downto 0);

-- aad_reg_MUX[prep_auth_data_c_l64_c5_acb2]
signal aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_cond : unsigned(0 downto 0);
signal aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iftrue : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iffalse : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_return_output : uint8_t_32;

-- BIN_OP_GT[prep_auth_data_c_l68_c10_fef8]
signal BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_left : unsigned(7 downto 0);
signal BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_right : unsigned(0 downto 0);
signal BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l68_c7_1631]
signal state_MUX_prep_auth_data_c_l68_c7_1631_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l68_c7_1631_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l68_c7_1631_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l68_c7_1631_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l68_c7_1631]
signal counter_MUX_prep_auth_data_c_l68_c7_1631_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l68_c7_1631_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l68_c7_1631_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l68_c7_1631_return_output : unsigned(15 downto 0);

-- aad_reg_MUX[prep_auth_data_c_l68_c7_1631]
signal aad_reg_MUX_prep_auth_data_c_l68_c7_1631_cond : unsigned(0 downto 0);
signal aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iftrue : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iffalse : uint8_t_32;
signal aad_reg_MUX_prep_auth_data_c_l68_c7_1631_return_output : uint8_t_32;

-- BIN_OP_EQ[prep_auth_data_c_l84_c11_31bc]
signal BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_left : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_right : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l84_c8_0400]
signal state_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(1 downto 0);

-- prep_auth_data_axis_out_MUX[prep_auth_data_c_l84_c8_0400]
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iftrue : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iffalse : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_return_output : axis128_t_stream_t;

-- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l84_c8_0400]
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(0 downto 0);

-- counter_MUX[prep_auth_data_c_l84_c8_0400]
signal counter_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(15 downto 0);

-- aad_reg_5_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_2_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_8_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_11_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_14_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_0_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_3_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_6_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_12_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_9_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_15_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_1_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_4_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_10_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_7_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- aad_reg_13_MUX[prep_auth_data_c_l84_c8_0400]
signal aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT[prep_auth_data_c_l91_c10_6020]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX[prep_auth_data_c_l91_c7_9e3f]
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[prep_auth_data_c_l99_c8_3a8e]
signal BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_left : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_right : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l99_c5_e95a]
signal state_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l99_c5_e95a]
signal counter_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(15 downto 0);

-- aad_reg_5_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_2_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_8_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_11_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_14_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_0_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_3_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_6_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_12_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_9_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_15_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_1_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_4_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_10_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_7_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- aad_reg_13_MUX[prep_auth_data_c_l99_c5_e95a]
signal aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);

-- BIN_OP_GT[prep_auth_data_c_l102_c10_7a1b]
signal BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_left : unsigned(15 downto 0);
signal BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_right : unsigned(4 downto 0);
signal BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l102_c7_af69]
signal state_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l102_c7_af69]
signal counter_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(15 downto 0);

-- aad_reg_5_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_2_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_8_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_11_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_14_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_0_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_3_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_6_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_12_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_9_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_15_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_1_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_4_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_10_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_7_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- aad_reg_13_MUX[prep_auth_data_c_l102_c7_af69]
signal aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
signal aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);

-- BIN_OP_MINUS[prep_auth_data_c_l106_c9_41f2]
signal BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_left : unsigned(15 downto 0);
signal BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_return_output : unsigned(15 downto 0);

-- BIN_OP_EQ[prep_auth_data_c_l116_c11_3535]
signal BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_left : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_right : unsigned(1 downto 0);
signal BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l116_c8_dc01]
signal state_MUX_prep_auth_data_c_l116_c8_dc01_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l116_c8_dc01_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l116_c8_dc01_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l116_c8_dc01_return_output : unsigned(1 downto 0);

-- prep_auth_data_axis_out_MUX[prep_auth_data_c_l116_c8_dc01]
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iftrue : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iffalse : axis128_t_stream_t;
signal prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_return_output : axis128_t_stream_t;

-- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l116_c8_dc01]
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iftrue : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iffalse : unsigned(0 downto 0);
signal prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_return_output : unsigned(0 downto 0);

-- counter_MUX[prep_auth_data_c_l116_c8_dc01]
signal counter_MUX_prep_auth_data_c_l116_c8_dc01_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l116_c8_dc01_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l116_c8_dc01_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l116_c8_dc01_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX[prep_auth_data_c_l128_c7_3893]
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[prep_auth_data_c_l134_c8_fa3c]
signal BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_left : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_right : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l134_c5_cab9]
signal state_MUX_prep_auth_data_c_l134_c5_cab9_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l134_c5_cab9_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l134_c5_cab9_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l134_c5_cab9_return_output : unsigned(1 downto 0);

-- counter_MUX[prep_auth_data_c_l134_c5_cab9]
signal counter_MUX_prep_auth_data_c_l134_c5_cab9_cond : unsigned(0 downto 0);
signal counter_MUX_prep_auth_data_c_l134_c5_cab9_iftrue : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l134_c5_cab9_iffalse : unsigned(15 downto 0);
signal counter_MUX_prep_auth_data_c_l134_c5_cab9_return_output : unsigned(15 downto 0);

-- axis128_keep_count[prep_auth_data_c_l135_c18_6eea]
signal axis128_keep_count_prep_auth_data_c_l135_c18_6eea_axis : axis128_t;
signal axis128_keep_count_prep_auth_data_c_l135_c18_6eea_return_output : unsigned(4 downto 0);

-- BIN_OP_PLUS[prep_auth_data_c_l135_c7_3456]
signal BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_left : unsigned(15 downto 0);
signal BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_right : unsigned(4 downto 0);
signal BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_return_output : unsigned(16 downto 0);

-- state_MUX[prep_auth_data_c_l137_c7_b0cd]
signal state_MUX_prep_auth_data_c_l137_c7_b0cd_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l137_c7_b0cd_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l137_c7_b0cd_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l137_c7_b0cd_return_output : unsigned(1 downto 0);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0[prep_auth_data_c_l150_c49_9967]
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8[prep_auth_data_c_l150_c49_9967]
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16[prep_auth_data_c_l150_c49_9967]
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24[prep_auth_data_c_l150_c49_9967]
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32[prep_auth_data_c_l150_c49_9967]
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40[prep_auth_data_c_l150_c49_9967]
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48[prep_auth_data_c_l150_c49_9967]
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56[prep_auth_data_c_l150_c49_9967]
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
signal FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0[prep_auth_data_c_l157_c49_ef79]
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8[prep_auth_data_c_l157_c49_ef79]
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16[prep_auth_data_c_l157_c49_ef79]
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24[prep_auth_data_c_l157_c49_ef79]
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32[prep_auth_data_c_l157_c49_ef79]
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40[prep_auth_data_c_l157_c49_ef79]
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48[prep_auth_data_c_l157_c49_ef79]
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56[prep_auth_data_c_l157_c49_ef79]
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
signal FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);

-- BIN_OP_AND[prep_auth_data_c_l166_c8_a2a7]
signal BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_left : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_right : unsigned(0 downto 0);
signal BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_return_output : unsigned(0 downto 0);

-- state_MUX[prep_auth_data_c_l166_c5_c85e]
signal state_MUX_prep_auth_data_c_l166_c5_c85e_cond : unsigned(0 downto 0);
signal state_MUX_prep_auth_data_c_l166_c5_c85e_iftrue : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l166_c5_c85e_iffalse : unsigned(1 downto 0);
signal state_MUX_prep_auth_data_c_l166_c5_c85e_return_output : unsigned(1 downto 0);

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

function CONST_REF_RD_uint8_t_32_uint8_t_32_aea8( ref_toks_0 : uint8_t_32;
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
      base(5) := ref_toks_1;
      base(2) := ref_toks_2;
      base(8) := ref_toks_3;
      base(11) := ref_toks_4;
      base(14) := ref_toks_5;
      base(0) := ref_toks_6;
      base(3) := ref_toks_7;
      base(6) := ref_toks_8;
      base(12) := ref_toks_9;
      base(9) := ref_toks_10;
      base(15) := ref_toks_11;
      base(1) := ref_toks_12;
      base(4) := ref_toks_13;
      base(10) := ref_toks_14;
      base(7) := ref_toks_15;
      base(13) := ref_toks_16;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c : 0 clocks latency
BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c : entity work.BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78 port map (
BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_left,
BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_right,
BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output);

-- state_MUX_prep_auth_data_c_l61_c3_719c : 0 clocks latency
state_MUX_prep_auth_data_c_l61_c3_719c : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l61_c3_719c_cond,
state_MUX_prep_auth_data_c_l61_c3_719c_iftrue,
state_MUX_prep_auth_data_c_l61_c3_719c_iffalse,
state_MUX_prep_auth_data_c_l61_c3_719c_return_output);

-- prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c : 0 clocks latency
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_cond,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iftrue,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iffalse,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_return_output);

-- prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c : 0 clocks latency
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_cond,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iftrue,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iffalse,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_return_output);

-- counter_MUX_prep_auth_data_c_l61_c3_719c : 0 clocks latency
counter_MUX_prep_auth_data_c_l61_c3_719c : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l61_c3_719c_cond,
counter_MUX_prep_auth_data_c_l61_c3_719c_iftrue,
counter_MUX_prep_auth_data_c_l61_c3_719c_iffalse,
counter_MUX_prep_auth_data_c_l61_c3_719c_return_output);

-- aad_reg_MUX_prep_auth_data_c_l61_c3_719c : 0 clocks latency
aad_reg_MUX_prep_auth_data_c_l61_c3_719c : entity work.MUX_uint1_t_uint8_t_32_uint8_t_32_0CLK_de264c78 port map (
aad_reg_MUX_prep_auth_data_c_l61_c3_719c_cond,
aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iftrue,
aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iffalse,
aad_reg_MUX_prep_auth_data_c_l61_c3_719c_return_output);

-- state_MUX_prep_auth_data_c_l64_c5_acb2 : 0 clocks latency
state_MUX_prep_auth_data_c_l64_c5_acb2 : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l64_c5_acb2_cond,
state_MUX_prep_auth_data_c_l64_c5_acb2_iftrue,
state_MUX_prep_auth_data_c_l64_c5_acb2_iffalse,
state_MUX_prep_auth_data_c_l64_c5_acb2_return_output);

-- counter_MUX_prep_auth_data_c_l64_c5_acb2 : 0 clocks latency
counter_MUX_prep_auth_data_c_l64_c5_acb2 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l64_c5_acb2_cond,
counter_MUX_prep_auth_data_c_l64_c5_acb2_iftrue,
counter_MUX_prep_auth_data_c_l64_c5_acb2_iffalse,
counter_MUX_prep_auth_data_c_l64_c5_acb2_return_output);

-- aad_reg_MUX_prep_auth_data_c_l64_c5_acb2 : 0 clocks latency
aad_reg_MUX_prep_auth_data_c_l64_c5_acb2 : entity work.MUX_uint1_t_uint8_t_32_uint8_t_32_0CLK_de264c78 port map (
aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_cond,
aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iftrue,
aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iffalse,
aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_return_output);

-- BIN_OP_GT_prep_auth_data_c_l68_c10_fef8 : 0 clocks latency
BIN_OP_GT_prep_auth_data_c_l68_c10_fef8 : entity work.BIN_OP_GT_uint8_t_uint1_t_0CLK_5af1a430 port map (
BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_left,
BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_right,
BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_return_output);

-- state_MUX_prep_auth_data_c_l68_c7_1631 : 0 clocks latency
state_MUX_prep_auth_data_c_l68_c7_1631 : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l68_c7_1631_cond,
state_MUX_prep_auth_data_c_l68_c7_1631_iftrue,
state_MUX_prep_auth_data_c_l68_c7_1631_iffalse,
state_MUX_prep_auth_data_c_l68_c7_1631_return_output);

-- counter_MUX_prep_auth_data_c_l68_c7_1631 : 0 clocks latency
counter_MUX_prep_auth_data_c_l68_c7_1631 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l68_c7_1631_cond,
counter_MUX_prep_auth_data_c_l68_c7_1631_iftrue,
counter_MUX_prep_auth_data_c_l68_c7_1631_iffalse,
counter_MUX_prep_auth_data_c_l68_c7_1631_return_output);

-- aad_reg_MUX_prep_auth_data_c_l68_c7_1631 : 0 clocks latency
aad_reg_MUX_prep_auth_data_c_l68_c7_1631 : entity work.MUX_uint1_t_uint8_t_32_uint8_t_32_0CLK_de264c78 port map (
aad_reg_MUX_prep_auth_data_c_l68_c7_1631_cond,
aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iftrue,
aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iffalse,
aad_reg_MUX_prep_auth_data_c_l68_c7_1631_return_output);

-- BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc : 0 clocks latency
BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc : entity work.BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78 port map (
BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_left,
BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_right,
BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output);

-- state_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
state_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l84_c8_0400_cond,
state_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
state_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
state_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_cond,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_cond,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- counter_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
counter_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l84_c8_0400_cond,
counter_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
counter_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
counter_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400 : 0 clocks latency
aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_cond,
aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iftrue,
aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iffalse,
aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020 : entity work.BIN_OP_GT_int17_t_int32_t_0CLK_794ce60a port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output);

-- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f : 0 clocks latency
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_cond,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse,
FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_return_output);

-- BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e : 0 clocks latency
BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_left,
BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_right,
BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output);

-- state_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
state_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l99_c5_e95a_cond,
state_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
state_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
state_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- counter_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
counter_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l99_c5_e95a_cond,
counter_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
counter_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
counter_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a : 0 clocks latency
aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_cond,
aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iftrue,
aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iffalse,
aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_return_output);

-- BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b : 0 clocks latency
BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b : entity work.BIN_OP_GT_uint16_t_uint5_t_0CLK_5af1a430 port map (
BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_left,
BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_right,
BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output);

-- state_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
state_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l102_c7_af69_cond,
state_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
state_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
state_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- counter_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
counter_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l102_c7_af69_cond,
counter_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
counter_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
counter_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69 : 0 clocks latency
aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_cond,
aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iftrue,
aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iffalse,
aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_return_output);

-- BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2 : 0 clocks latency
BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2 : entity work.BIN_OP_MINUS_uint16_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_left,
BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_right,
BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_return_output);

-- BIN_OP_EQ_prep_auth_data_c_l116_c11_3535 : 0 clocks latency
BIN_OP_EQ_prep_auth_data_c_l116_c11_3535 : entity work.BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78 port map (
BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_left,
BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_right,
BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output);

-- state_MUX_prep_auth_data_c_l116_c8_dc01 : 0 clocks latency
state_MUX_prep_auth_data_c_l116_c8_dc01 : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l116_c8_dc01_cond,
state_MUX_prep_auth_data_c_l116_c8_dc01_iftrue,
state_MUX_prep_auth_data_c_l116_c8_dc01_iffalse,
state_MUX_prep_auth_data_c_l116_c8_dc01_return_output);

-- prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01 : 0 clocks latency
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01 : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_cond,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iftrue,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iffalse,
prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_return_output);

-- prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01 : 0 clocks latency
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_cond,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iftrue,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iffalse,
prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_return_output);

-- counter_MUX_prep_auth_data_c_l116_c8_dc01 : 0 clocks latency
counter_MUX_prep_auth_data_c_l116_c8_dc01 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l116_c8_dc01_cond,
counter_MUX_prep_auth_data_c_l116_c8_dc01_iftrue,
counter_MUX_prep_auth_data_c_l116_c8_dc01_iffalse,
counter_MUX_prep_auth_data_c_l116_c8_dc01_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr,
FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output);

-- FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893 : 0 clocks latency
FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893 : entity work.MUX_uint1_t_uint8_t_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_cond,
FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iftrue,
FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iffalse,
FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_return_output);

-- BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c : 0 clocks latency
BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_left,
BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_right,
BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_return_output);

-- state_MUX_prep_auth_data_c_l134_c5_cab9 : 0 clocks latency
state_MUX_prep_auth_data_c_l134_c5_cab9 : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l134_c5_cab9_cond,
state_MUX_prep_auth_data_c_l134_c5_cab9_iftrue,
state_MUX_prep_auth_data_c_l134_c5_cab9_iffalse,
state_MUX_prep_auth_data_c_l134_c5_cab9_return_output);

-- counter_MUX_prep_auth_data_c_l134_c5_cab9 : 0 clocks latency
counter_MUX_prep_auth_data_c_l134_c5_cab9 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
counter_MUX_prep_auth_data_c_l134_c5_cab9_cond,
counter_MUX_prep_auth_data_c_l134_c5_cab9_iftrue,
counter_MUX_prep_auth_data_c_l134_c5_cab9_iffalse,
counter_MUX_prep_auth_data_c_l134_c5_cab9_return_output);

-- axis128_keep_count_prep_auth_data_c_l135_c18_6eea : 0 clocks latency
axis128_keep_count_prep_auth_data_c_l135_c18_6eea : entity work.axis128_keep_count_0CLK_08de2a73 port map (
axis128_keep_count_prep_auth_data_c_l135_c18_6eea_axis,
axis128_keep_count_prep_auth_data_c_l135_c18_6eea_return_output);

-- BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456 : 0 clocks latency
BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456 : entity work.BIN_OP_PLUS_uint16_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_left,
BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_right,
BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_return_output);

-- state_MUX_prep_auth_data_c_l137_c7_b0cd : 0 clocks latency
state_MUX_prep_auth_data_c_l137_c7_b0cd : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l137_c7_b0cd_cond,
state_MUX_prep_auth_data_c_l137_c7_b0cd_iftrue,
state_MUX_prep_auth_data_c_l137_c7_b0cd_iffalse,
state_MUX_prep_auth_data_c_l137_c7_b0cd_return_output);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967 : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967 : entity work.CONST_SR_0_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_x,
FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_return_output);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967 : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967 : entity work.CONST_SR_8_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_x,
FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_return_output);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967 : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967 : entity work.CONST_SR_16_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_x,
FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_return_output);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967 : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967 : entity work.CONST_SR_24_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_x,
FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_return_output);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967 : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967 : entity work.CONST_SR_32_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_x,
FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_return_output);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967 : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967 : entity work.CONST_SR_40_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_x,
FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_return_output);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967 : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967 : entity work.CONST_SR_48_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_x,
FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_return_output);

-- FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967 : 0 clocks latency
FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967 : entity work.CONST_SR_56_uint8_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_x,
FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_return_output);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79 : entity work.CONST_SR_0_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_x,
FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_return_output);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79 : entity work.CONST_SR_8_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_x,
FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_return_output);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79 : entity work.CONST_SR_16_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_x,
FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_return_output);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79 : entity work.CONST_SR_24_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_x,
FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_return_output);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79 : entity work.CONST_SR_32_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_x,
FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_return_output);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79 : entity work.CONST_SR_40_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_x,
FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_return_output);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79 : entity work.CONST_SR_48_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_x,
FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_return_output);

-- FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79 : 0 clocks latency
FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79 : entity work.CONST_SR_56_uint16_t_0CLK_de264c78 port map (
FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_x,
FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_return_output);

-- BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7 : 0 clocks latency
BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_left,
BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_right,
BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_return_output);

-- state_MUX_prep_auth_data_c_l166_c5_c85e : 0 clocks latency
state_MUX_prep_auth_data_c_l166_c5_c85e : entity work.MUX_uint1_t_prep_auth_data_state_t_prep_auth_data_state_t_0CLK_de264c78 port map (
state_MUX_prep_auth_data_c_l166_c5_c85e_cond,
state_MUX_prep_auth_data_c_l166_c5_c85e_iftrue,
state_MUX_prep_auth_data_c_l166_c5_c85e_iffalse,
state_MUX_prep_auth_data_c_l166_c5_c85e_return_output);



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
 BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output,
 state_MUX_prep_auth_data_c_l61_c3_719c_return_output,
 prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_return_output,
 prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_return_output,
 counter_MUX_prep_auth_data_c_l61_c3_719c_return_output,
 aad_reg_MUX_prep_auth_data_c_l61_c3_719c_return_output,
 state_MUX_prep_auth_data_c_l64_c5_acb2_return_output,
 counter_MUX_prep_auth_data_c_l64_c5_acb2_return_output,
 aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_return_output,
 BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_return_output,
 state_MUX_prep_auth_data_c_l68_c7_1631_return_output,
 counter_MUX_prep_auth_data_c_l68_c7_1631_return_output,
 aad_reg_MUX_prep_auth_data_c_l68_c7_1631_return_output,
 BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output,
 state_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 counter_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output,
 FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
 BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output,
 state_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 counter_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_return_output,
 BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output,
 state_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 counter_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_return_output,
 BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_return_output,
 BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output,
 state_MUX_prep_auth_data_c_l116_c8_dc01_return_output,
 prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_return_output,
 prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_return_output,
 counter_MUX_prep_auth_data_c_l116_c8_dc01_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output,
 FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_return_output,
 BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_return_output,
 state_MUX_prep_auth_data_c_l134_c5_cab9_return_output,
 counter_MUX_prep_auth_data_c_l134_c5_cab9_return_output,
 axis128_keep_count_prep_auth_data_c_l135_c18_6eea_return_output,
 BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_return_output,
 state_MUX_prep_auth_data_c_l137_c7_b0cd_return_output,
 FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_return_output,
 FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_return_output,
 FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_return_output,
 FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_return_output,
 FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_return_output,
 FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_return_output,
 FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_return_output,
 FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_return_output,
 FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_return_output,
 FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_return_output,
 FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_return_output,
 FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_return_output,
 FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_return_output,
 FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_return_output,
 FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_return_output,
 FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_return_output,
 BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_return_output,
 state_MUX_prep_auth_data_c_l166_c5_c85e_return_output)
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
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_left : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_right : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l61_c3_719c_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l61_c3_719c_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l61_c3_719c_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iftrue : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iffalse : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iftrue : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iffalse : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iftrue : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_return_output : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iffalse : uint8_t_32;
 variable VAR_aad_reg_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_32_uint8_t_32_aea8_prep_auth_data_c_l61_c3_719c_return_output : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_return_output : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l68_c7_1631_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iftrue : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_return_output : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iffalse : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l68_c7_1631_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l68_c7_1631_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l68_c7_1631_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_iftrue : unsigned(15 downto 0);
 variable VAR_counter_prep_auth_data_c_l73_c9_a431 : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iftrue : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iffalse : uint8_t_32;
 variable VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_left : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_right : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iftrue : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432_prep_auth_data_c_l84_c8_0400_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iffalse : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_cond : unsigned(0 downto 0);
 variable VAR_i : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left : signed(16 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_return_output : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iftrue : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iffalse : unsigned(7 downto 0);
 variable VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_cond : unsigned(0 downto 0);
 variable VAR_ARRAY_SHIFT_DOWN_i : unsigned(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_8_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_9_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_10_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_11_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_12_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_13_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_14_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_15_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d_prep_auth_data_c_l105_c144_59b2_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_return_output : unsigned(15 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_left : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_right : unsigned(1 downto 0);
 variable VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iftrue : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f_prep_auth_data_c_l116_c8_dc01_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iffalse : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377_prep_auth_data_c_l116_c8_dc01_return_output : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iftrue : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iffalse : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_iftrue : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_return_output : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_0_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_1_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_2_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_3_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_4_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_5_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_6_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_7_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_8_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_9_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_10_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_11_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_12_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_13_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_14_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_15_d41d_prep_auth_data_c_l128_c11_00f9_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output : unsigned(0 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iftrue : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iffalse : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_return_output : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_iftrue : unsigned(15 downto 0);
 variable VAR_counter_prep_auth_data_c_l135_c7_8d3e : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_iffalse : unsigned(15 downto 0);
 variable VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_left : unsigned(15 downto 0);
 variable VAR_axis128_keep_count_prep_auth_data_c_l135_c18_6eea_axis : axis128_t;
 variable VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_right : unsigned(4 downto 0);
 variable VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_prep_auth_data_c_l135_c37_6655_return_output : axis128_t;
 variable VAR_axis128_keep_count_prep_auth_data_c_l135_c18_6eea_return_output : unsigned(4 downto 0);
 variable VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_return_output : unsigned(16 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_prep_auth_data_c_l137_c10_8837_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_cond : unsigned(0 downto 0);
 variable VAR_pos : signed(31 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_return_output : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_x : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_0_prep_auth_data_axis_out_data_tdata_8_prep_auth_data_c_l157_c7_0fe0 : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_1_prep_auth_data_axis_out_data_tdata_9_prep_auth_data_c_l157_c7_0fe0 : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_2_prep_auth_data_axis_out_data_tdata_10_prep_auth_data_c_l157_c7_0fe0 : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_3_prep_auth_data_axis_out_data_tdata_11_prep_auth_data_c_l157_c7_0fe0 : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_4_prep_auth_data_axis_out_data_tdata_12_prep_auth_data_c_l157_c7_0fe0 : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_5_prep_auth_data_axis_out_data_tdata_13_prep_auth_data_c_l157_c7_0fe0 : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_6_prep_auth_data_axis_out_data_tdata_14_prep_auth_data_c_l157_c7_0fe0 : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_7_prep_auth_data_axis_out_data_tdata_15_prep_auth_data_c_l157_c7_0fe0 : unsigned(7 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_return_output : unsigned(15 downto 0);
 variable VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_x : unsigned(15 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_iftrue : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_iffalse : unsigned(1 downto 0);
 variable VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l134_l64_DUPLICATE_4a23_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_c8d7_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_90fa_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d93b_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_bd1e_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_2cdc_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_21ce_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l99_l92_l102_l84_DUPLICATE_a916_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_9d26_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_e121_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0734_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_8918_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_375a_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_6c92_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cd26_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_3c64_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_ef95_return_output : unsigned(7 downto 0);
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
     VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_right := unsigned(prep_auth_data_state_t_to_slv(IDLE));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(8, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(13, 32);
     VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_right := to_unsigned(16, 5);
     VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_iftrue := unsigned(prep_auth_data_state_t_to_slv(LENGTHS));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(0, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(14, 32);
     VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_left := to_unsigned(1, 1);
     VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_left := to_unsigned(1, 1);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(1, 32);
     VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_iftrue := unsigned(prep_auth_data_state_t_to_slv(IDLE));
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iftrue := axis128_t_stream_t_NULL;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(5, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(11, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(10, 32);
     VAR_state_MUX_prep_auth_data_c_l68_c7_1631_iftrue := unsigned(prep_auth_data_state_t_to_slv(AAD));
     VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_right := to_unsigned(16, 5);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(2, 32);
     VAR_state_MUX_prep_auth_data_c_l68_c7_1631_iffalse := unsigned(prep_auth_data_state_t_to_slv(CIPHERTEXT));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(15, 32);
     VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_right := unsigned(prep_auth_data_state_t_to_slv(AAD));
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iffalse := to_unsigned(0, 1);
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iftrue := to_unsigned(0, 1);
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iftrue := to_unsigned(0, 1);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(12, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(3, 32);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iftrue := to_unsigned(0, 8);
     VAR_state_MUX_prep_auth_data_c_l102_c7_af69_iffalse := unsigned(prep_auth_data_state_t_to_slv(CIPHERTEXT));
     VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_right := unsigned(prep_auth_data_state_t_to_slv(CIPHERTEXT));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(4, 32);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(6, 32);
     VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_right := to_unsigned(0, 1);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(7, 32);
     VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_iffalse := to_unsigned(0, 16);
     VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_iffalse := to_unsigned(0, 16);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right := to_signed(9, 32);
     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(7);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(10);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(2);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(9);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(13);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(11);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(3);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(15);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(8);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(1);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(12);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(0);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(14);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(6);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(5);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l91_c7_9e3f_return_output := axis128_t_stream_t_NULL.data.tdata(4);

     -- Submodule level 1
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l91_c7_9e3f_return_output;
 -- Reads from global variables
     VAR_prep_auth_data_axis_in := global_to_module.prep_auth_data_axis_in;
     VAR_prep_auth_data_aad_len := global_to_module.prep_auth_data_aad_len;
     VAR_prep_auth_data_aad := global_to_module.prep_auth_data_aad;
     VAR_prep_auth_data_axis_out_ready := global_to_module.prep_auth_data_axis_out_ready;
     -- Submodule level 0
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_x := VAR_prep_auth_data_aad_len;
     VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_left := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_x := VAR_prep_auth_data_aad_len;
     VAR_counter_prep_auth_data_c_l73_c9_a431 := resize(VAR_prep_auth_data_aad_len, 16);
     VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_iftrue := VAR_counter_prep_auth_data_c_l73_c9_a431;
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_x := VAR_prep_auth_data_aad_len;
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_x := VAR_prep_auth_data_aad_len;
     VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iftrue := VAR_prep_auth_data_aad;
     VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_right := VAR_prep_auth_data_axis_out_ready;
     VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_right := VAR_prep_auth_data_axis_out_ready;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iftrue := VAR_prep_auth_data_axis_out_ready;
     VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_right := VAR_prep_auth_data_axis_out_ready;
     -- FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40[prep_auth_data_c_l150_c49_9967] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_x <= VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_return_output := FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_15_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_15_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_15_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(15);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(0);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(7);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_0_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_0_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(0);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(3);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_11_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_11_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_11_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(11);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_6_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_6_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_6_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(6);

     -- FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56[prep_auth_data_c_l150_c49_9967] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_x <= VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_return_output := FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(11);

     -- FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16[prep_auth_data_c_l150_c49_9967] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_x <= VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_return_output := FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_2_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_2_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(2);

     -- CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d[prep_auth_data_c_l135_c37_6655] LATENCY=0
     VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_prep_auth_data_c_l135_c37_6655_return_output := VAR_prep_auth_data_axis_in.data;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[prep_auth_data_c_l137_c10_8837] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_prep_auth_data_c_l137_c10_8837_return_output := VAR_prep_auth_data_axis_in.data.tlast;

     -- FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24[prep_auth_data_c_l150_c49_9967] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_x <= VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_return_output := FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(13);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_7_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_7_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_7_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(7);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(15);

     -- FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8[prep_auth_data_c_l150_c49_9967] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_x <= VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_return_output := FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(6);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(9);

     -- FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32[prep_auth_data_c_l150_c49_9967] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_x <= VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_return_output := FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_return_output;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l134_l64_DUPLICATE_4a23 LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l134_l64_DUPLICATE_4a23_return_output := VAR_prep_auth_data_axis_in.valid;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(2);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_3_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_3_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_3_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(3);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(10);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(1);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_4_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_4_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_4_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(4);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_8_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_8_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_8_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(8);

     -- FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48[prep_auth_data_c_l150_c49_9967] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_x <= VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_return_output := FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_9_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_9_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_9_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(9);

     -- FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0[prep_auth_data_c_l150_c49_9967] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_x <= VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_return_output := FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(14);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(8);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_1_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_1_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(1);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(12);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_14_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_14_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_14_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(14);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_12_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_12_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_12_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(12);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(4);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_13_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_13_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_13_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(13);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_5_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_5_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_5_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(5);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d[prep_auth_data_c_l128_c7_3893] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l128_c7_3893_return_output := VAR_prep_auth_data_axis_in.data.tdata(5);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_10_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_10_d41d[prep_auth_data_c_l128_c11_00f9] LATENCY=0
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_10_d41d_prep_auth_data_c_l128_c11_00f9_return_output := VAR_prep_auth_data_axis_in.data.tkeep(10);

     -- Submodule level 1
     VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_prep_auth_data_c_l137_c10_8837_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_10_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_12_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_9_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_12_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_13_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_13_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_7_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l134_l64_DUPLICATE_4a23_return_output;
     VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l134_l64_DUPLICATE_4a23_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l134_l64_DUPLICATE_4a23_return_output;
     VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_prep_auth_data_c_l134_l64_DUPLICATE_4a23_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_5_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_9_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_1_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_10_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_8_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_14_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_5_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_2_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_2_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_11_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_14_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_3_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_axis128_keep_count_prep_auth_data_c_l135_c18_6eea_axis := VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_prep_auth_data_c_l135_c37_6655_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_6_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_4_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_0_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_0_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_11_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_6_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_15_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_15_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_7_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_8_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_1_d41d_prep_auth_data_c_l128_c11_00f9_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iffalse := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_axis128_t_stream_t_data_tdata_3_d41d_prep_auth_data_c_l128_c7_3893_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tkeep_4_d41d_prep_auth_data_c_l128_c11_00f9_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iffalse := aad_reg;
     VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iffalse := aad_reg;
     VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_left := counter;
     VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_left := counter;
     VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_left := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_x := counter;
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_x := counter;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left := signed(std_logic_vector(resize(counter, 17)));
     VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_iffalse := counter;
     VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_iffalse := counter;
     VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_iffalse := counter;
     VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := counter;
     VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_left := state;
     VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_left := state;
     VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_left := state;
     VAR_state_MUX_prep_auth_data_c_l102_c7_af69_iftrue := state;
     VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_iffalse := state;
     VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_iffalse := state;
     VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_iffalse := state;
     VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_iffalse := state;
     VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := state;
     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- BIN_OP_GT[prep_auth_data_c_l102_c10_7a1b] LATENCY=0
     -- Inputs
     BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_left <= VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_left;
     BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_right <= VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_right;
     -- Outputs
     VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output := BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cd26 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cd26_return_output := aad_reg(13);

     -- CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_e121 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_e121_return_output := aad_reg(8);

     -- FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48[prep_auth_data_c_l157_c49_ef79] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_x <= VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_return_output := FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_14_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_14_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(30);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40[prep_auth_data_c_l157_c49_ef79] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_x <= VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_return_output := FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56[prep_auth_data_c_l157_c49_ef79] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_x <= VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_return_output := FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_15_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_15_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(31);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- BIN_OP_GT[prep_auth_data_c_l68_c10_fef8] LATENCY=0
     -- Inputs
     BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_left <= VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_left;
     BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_right <= VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_right;
     -- Outputs
     VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_return_output := BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_return_output;

     -- BIN_OP_MINUS[prep_auth_data_c_l106_c9_41f2] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_left <= VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_left;
     BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_right <= VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_right;
     -- Outputs
     VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_return_output := BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(16);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(19);

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(23);

     -- CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0734 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0734_return_output := aad_reg(9);

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_8_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_8_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(24);

     -- CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_ef95 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_ef95_return_output := aad_reg(15);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- BIN_OP_AND[prep_auth_data_c_l99_c8_3a8e] LATENCY=0
     -- Inputs
     BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_left <= VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_left;
     BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_right <= VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_right;
     -- Outputs
     VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output := BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_6c92 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_6c92_return_output := aad_reg(12);

     -- BIN_OP_EQ[prep_auth_data_c_l61_c6_d92c] LATENCY=0
     -- Inputs
     BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_left <= VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_left;
     BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_right <= VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_right;
     -- Outputs
     VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output := BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16[prep_auth_data_c_l157_c49_ef79] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_x <= VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_return_output := FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(17);

     -- axis128_keep_count[prep_auth_data_c_l135_c18_6eea] LATENCY=0
     -- Inputs
     axis128_keep_count_prep_auth_data_c_l135_c18_6eea_axis <= VAR_axis128_keep_count_prep_auth_data_c_l135_c18_6eea_axis;
     -- Outputs
     VAR_axis128_keep_count_prep_auth_data_c_l135_c18_6eea_return_output := axis128_keep_count_prep_auth_data_c_l135_c18_6eea_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- BIN_OP_AND[prep_auth_data_c_l134_c8_fa3c] LATENCY=0
     -- Inputs
     BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_left <= VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_left;
     BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_right <= VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_right;
     -- Outputs
     VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_return_output := BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_return_output;

     -- BIN_OP_AND[prep_auth_data_c_l166_c8_a2a7] LATENCY=0
     -- Inputs
     BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_left <= VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_left;
     BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_right <= VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_right;
     -- Outputs
     VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_return_output := BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_375a LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_375a_return_output := aad_reg(11);

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_12_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_12_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(28);

     -- CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_c8d7 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_c8d7_return_output := aad_reg(0);

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_10_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_10_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(26);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l99_l92_l102_l84_DUPLICATE_a916 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l99_l92_l102_l84_DUPLICATE_a916_return_output := aad_reg(6);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_8918 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_8918_return_output := aad_reg(10);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0[prep_auth_data_c_l157_c49_ef79] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_x <= VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_return_output := FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_2cdc LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_2cdc_return_output := aad_reg(4);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_9d26 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_9d26_return_output := aad_reg(7);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d93b LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d93b_return_output := aad_reg(2);

     -- CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_90fa LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_90fa_return_output := aad_reg(1);

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_13_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_13_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(29);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_bd1e LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_bd1e_return_output := aad_reg(3);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- BIN_OP_EQ[prep_auth_data_c_l116_c11_3535] LATENCY=0
     -- Inputs
     BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_left <= VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_left;
     BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_right <= VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_right;
     -- Outputs
     VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output := BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_21ce LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_21ce_return_output := aad_reg(5);

     -- FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32[prep_auth_data_c_l157_c49_ef79] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_x <= VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_return_output := FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_9_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_9_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(25);

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(18);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24[prep_auth_data_c_l157_c49_ef79] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_x <= VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_return_output := FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_return_output;

     -- CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_3c64 LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_3c64_return_output := aad_reg(14);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- BIN_OP_EQ[prep_auth_data_c_l84_c11_31bc] LATENCY=0
     -- Inputs
     BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_left <= VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_left;
     BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_right <= VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_right;
     -- Outputs
     VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output := BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(22);

     -- state_MUX[prep_auth_data_c_l137_c7_b0cd] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l137_c7_b0cd_cond <= VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_cond;
     state_MUX_prep_auth_data_c_l137_c7_b0cd_iftrue <= VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_iftrue;
     state_MUX_prep_auth_data_c_l137_c7_b0cd_iffalse <= VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_return_output := state_MUX_prep_auth_data_c_l137_c7_b0cd_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(20);

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(21);

     -- FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8[prep_auth_data_c_l157_c49_ef79] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_x <= VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_x;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_return_output := FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_return_output;

     -- FOR_prep_auth_data_c_l105_c38_9cbd_ITER_11_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d[prep_auth_data_c_l105_c144_59b2] LATENCY=0
     VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_11_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d_prep_auth_data_c_l105_c144_59b2_return_output := aad_reg(27);

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT[prep_auth_data_c_l91_c10_6020] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_left;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_right;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT[prep_auth_data_c_l128_c11_23ce] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_expr;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;

     -- Submodule level 1
     VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_cond := VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_return_output;
     VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_cond := VAR_BIN_OP_AND_prep_auth_data_c_l134_c8_fa3c_return_output;
     VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_cond := VAR_BIN_OP_AND_prep_auth_data_c_l166_c8_a2a7_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_cond := VAR_BIN_OP_AND_prep_auth_data_c_l99_c8_3a8e_return_output;
     VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output;
     VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l116_c11_3535_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output;
     VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output;
     VAR_state_MUX_prep_auth_data_c_l61_c3_719c_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l61_c6_d92c_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_state_MUX_prep_auth_data_c_l84_c8_0400_cond := VAR_BIN_OP_EQ_prep_auth_data_c_l84_c11_31bc_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_state_MUX_prep_auth_data_c_l102_c7_af69_cond := VAR_BIN_OP_GT_prep_auth_data_c_l102_c10_7a1b_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_cond := VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_return_output;
     VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_cond := VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_return_output;
     VAR_state_MUX_prep_auth_data_c_l68_c7_1631_cond := VAR_BIN_OP_GT_prep_auth_data_c_l68_c10_fef8_return_output;
     VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_BIN_OP_MINUS_prep_auth_data_c_l106_c9_41f2_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_c8d7_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_c8d7_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_c8d7_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_0_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_c8d7_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_8918_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_8918_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_8918_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_10_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_8918_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_375a_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_375a_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_375a_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_11_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_375a_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_6c92_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_6c92_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_6c92_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_12_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_6c92_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cd26_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cd26_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cd26_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_13_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_cd26_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_3c64_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_3c64_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_3c64_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_14_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_3c64_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_ef95_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_ef95_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_ef95_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_15_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_ef95_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_90fa_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_90fa_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_90fa_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_1_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_90fa_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d93b_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d93b_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d93b_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_2_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_d93b_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_bd1e_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_bd1e_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_bd1e_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_3_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_bd1e_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_2cdc_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_2cdc_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_2cdc_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_4_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_2cdc_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_21ce_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_21ce_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_21ce_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_5_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_21ce_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l99_l92_l102_l84_DUPLICATE_a916_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l99_l92_l102_l84_DUPLICATE_a916_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l99_l92_l102_l84_DUPLICATE_a916_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_6_d41d_prep_auth_data_c_l99_l92_l102_l84_DUPLICATE_a916_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_9d26_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_9d26_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_9d26_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_7_d41d_prep_auth_data_c_l99_l102_l84_l92_DUPLICATE_9d26_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_e121_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_e121_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_e121_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_8_d41d_prep_auth_data_c_l99_l102_l92_l84_DUPLICATE_e121_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue := VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0734_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0734_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0734_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iffalse := VAR_CONST_REF_RD_uint8_t_uint8_t_32_9_d41d_prep_auth_data_c_l92_l99_l102_l84_DUPLICATE_0734_return_output;
     VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_0_CONST_REF_RD_uint8_t_uint8_t_32_16_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_10_CONST_REF_RD_uint8_t_uint8_t_32_26_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_11_CONST_REF_RD_uint8_t_uint8_t_32_27_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_12_CONST_REF_RD_uint8_t_uint8_t_32_28_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_13_CONST_REF_RD_uint8_t_uint8_t_32_29_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_14_CONST_REF_RD_uint8_t_uint8_t_32_30_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_15_CONST_REF_RD_uint8_t_uint8_t_32_31_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_1_CONST_REF_RD_uint8_t_uint8_t_32_17_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_2_CONST_REF_RD_uint8_t_uint8_t_32_18_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_3_CONST_REF_RD_uint8_t_uint8_t_32_19_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_4_CONST_REF_RD_uint8_t_uint8_t_32_20_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_5_CONST_REF_RD_uint8_t_uint8_t_32_21_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_6_CONST_REF_RD_uint8_t_uint8_t_32_22_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_7_CONST_REF_RD_uint8_t_uint8_t_32_23_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_8_CONST_REF_RD_uint8_t_uint8_t_32_24_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iftrue := VAR_FOR_prep_auth_data_c_l105_c38_9cbd_ITER_9_CONST_REF_RD_uint8_t_uint8_t_32_25_d41d_prep_auth_data_c_l105_c144_59b2_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_cond := VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_UNARY_OP_NOT_prep_auth_data_c_l128_c11_23ce_return_output;
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_0_prep_auth_data_axis_out_data_tdata_8_prep_auth_data_c_l157_c7_0fe0 := resize(VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_0_CONST_SR_0_prep_auth_data_c_l157_c49_ef79_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_1_prep_auth_data_axis_out_data_tdata_9_prep_auth_data_c_l157_c7_0fe0 := resize(VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_1_CONST_SR_8_prep_auth_data_c_l157_c49_ef79_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_2_prep_auth_data_axis_out_data_tdata_10_prep_auth_data_c_l157_c7_0fe0 := resize(VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_2_CONST_SR_16_prep_auth_data_c_l157_c49_ef79_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_3_prep_auth_data_axis_out_data_tdata_11_prep_auth_data_c_l157_c7_0fe0 := resize(VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_3_CONST_SR_24_prep_auth_data_c_l157_c49_ef79_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_4_prep_auth_data_axis_out_data_tdata_12_prep_auth_data_c_l157_c7_0fe0 := resize(VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_4_CONST_SR_32_prep_auth_data_c_l157_c49_ef79_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_5_prep_auth_data_axis_out_data_tdata_13_prep_auth_data_c_l157_c7_0fe0 := resize(VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_5_CONST_SR_40_prep_auth_data_c_l157_c49_ef79_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_6_prep_auth_data_axis_out_data_tdata_14_prep_auth_data_c_l157_c7_0fe0 := resize(VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_6_CONST_SR_48_prep_auth_data_c_l157_c49_ef79_return_output, 8);
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_7_prep_auth_data_axis_out_data_tdata_15_prep_auth_data_c_l157_c7_0fe0 := resize(VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_7_CONST_SR_56_prep_auth_data_c_l157_c49_ef79_return_output, 8);
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_cond := VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_BIN_OP_GT_prep_auth_data_c_l91_c10_6020_return_output;
     VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_right := VAR_axis128_keep_count_prep_auth_data_c_l135_c18_6eea_return_output;
     VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_iftrue := VAR_state_MUX_prep_auth_data_c_l137_c7_b0cd_return_output;
     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- state_MUX[prep_auth_data_c_l134_c5_cab9] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l134_c5_cab9_cond <= VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_cond;
     state_MUX_prep_auth_data_c_l134_c5_cab9_iftrue <= VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_iftrue;
     state_MUX_prep_auth_data_c_l134_c5_cab9_iffalse <= VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_return_output := state_MUX_prep_auth_data_c_l134_c5_cab9_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- aad_reg_11_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- state_MUX[prep_auth_data_c_l68_c7_1631] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l68_c7_1631_cond <= VAR_state_MUX_prep_auth_data_c_l68_c7_1631_cond;
     state_MUX_prep_auth_data_c_l68_c7_1631_iftrue <= VAR_state_MUX_prep_auth_data_c_l68_c7_1631_iftrue;
     state_MUX_prep_auth_data_c_l68_c7_1631_iffalse <= VAR_state_MUX_prep_auth_data_c_l68_c7_1631_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l68_c7_1631_return_output := state_MUX_prep_auth_data_c_l68_c7_1631_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- state_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_state_MUX_prep_auth_data_c_l102_c7_af69_cond;
     state_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_state_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     state_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_state_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l102_c7_af69_return_output := state_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- aad_reg_2_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- BIN_OP_PLUS[prep_auth_data_c_l135_c7_3456] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_left <= VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_left;
     BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_right <= VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_right;
     -- Outputs
     VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_return_output := BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- aad_reg_9_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- aad_reg_7_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- aad_reg_6_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- aad_reg_MUX[prep_auth_data_c_l68_c7_1631] LATENCY=0
     -- Inputs
     aad_reg_MUX_prep_auth_data_c_l68_c7_1631_cond <= VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_cond;
     aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iftrue <= VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iftrue;
     aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iffalse <= VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_iffalse;
     -- Outputs
     VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_return_output := aad_reg_MUX_prep_auth_data_c_l68_c7_1631_return_output;

     -- aad_reg_15_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- aad_reg_4_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l116_c8_dc01] LATENCY=0
     -- Inputs
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_cond <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_cond;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iftrue <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iftrue;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iffalse <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_return_output := prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- aad_reg_8_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- aad_reg_10_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- aad_reg_13_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- aad_reg_12_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- aad_reg_5_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- counter_MUX[prep_auth_data_c_l68_c7_1631] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l68_c7_1631_cond <= VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_cond;
     counter_MUX_prep_auth_data_c_l68_c7_1631_iftrue <= VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_iftrue;
     counter_MUX_prep_auth_data_c_l68_c7_1631_iffalse <= VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_return_output := counter_MUX_prep_auth_data_c_l68_c7_1631_return_output;

     -- aad_reg_0_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- aad_reg_1_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- prep_auth_data_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377[prep_auth_data_c_l116_c8_dc01] LATENCY=0
     VAR_prep_auth_data_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377_prep_auth_data_c_l116_c8_dc01_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377(
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_0_CONST_SR_0_prep_auth_data_c_l150_c49_9967_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_1_CONST_SR_8_prep_auth_data_c_l150_c49_9967_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_2_CONST_SR_16_prep_auth_data_c_l150_c49_9967_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_3_CONST_SR_24_prep_auth_data_c_l150_c49_9967_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_4_CONST_SR_32_prep_auth_data_c_l150_c49_9967_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_5_CONST_SR_40_prep_auth_data_c_l150_c49_9967_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_6_CONST_SR_48_prep_auth_data_c_l150_c49_9967_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l148_c5_bacd_ITER_7_CONST_SR_56_prep_auth_data_c_l150_c49_9967_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_0_prep_auth_data_axis_out_data_tdata_8_prep_auth_data_c_l157_c7_0fe0,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_1_prep_auth_data_axis_out_data_tdata_9_prep_auth_data_c_l157_c7_0fe0,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_2_prep_auth_data_axis_out_data_tdata_10_prep_auth_data_c_l157_c7_0fe0,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_3_prep_auth_data_axis_out_data_tdata_11_prep_auth_data_c_l157_c7_0fe0,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_4_prep_auth_data_axis_out_data_tdata_12_prep_auth_data_c_l157_c7_0fe0,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_5_prep_auth_data_axis_out_data_tdata_13_prep_auth_data_c_l157_c7_0fe0,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_6_prep_auth_data_axis_out_data_tdata_14_prep_auth_data_c_l157_c7_0fe0,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l155_c5_d785_ITER_7_prep_auth_data_axis_out_data_tdata_15_prep_auth_data_c_l157_c7_0fe0,
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1));

     -- aad_reg_3_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- aad_reg_14_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_cond;
     aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_return_output := aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- counter_MUX[prep_auth_data_c_l102_c7_af69] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l102_c7_af69_cond <= VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_cond;
     counter_MUX_prep_auth_data_c_l102_c7_af69_iftrue <= VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_iftrue;
     counter_MUX_prep_auth_data_c_l102_c7_af69_iffalse <= VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_return_output := counter_MUX_prep_auth_data_c_l102_c7_af69_return_output;

     -- state_MUX[prep_auth_data_c_l166_c5_c85e] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l166_c5_c85e_cond <= VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_cond;
     state_MUX_prep_auth_data_c_l166_c5_c85e_iftrue <= VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_iftrue;
     state_MUX_prep_auth_data_c_l166_c5_c85e_iffalse <= VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_return_output := state_MUX_prep_auth_data_c_l166_c5_c85e_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX[prep_auth_data_c_l91_c7_9e3f] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_cond <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_cond;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iftrue;
     FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse <= VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_return_output := FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX[prep_auth_data_c_l128_c7_3893] LATENCY=0
     -- Inputs
     FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_cond <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_cond;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iftrue <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iftrue;
     FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iffalse <= VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_iffalse;
     -- Outputs
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_return_output := FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_return_output;

     -- Submodule level 2
     VAR_counter_prep_auth_data_c_l135_c7_8d3e := resize(VAR_BIN_OP_PLUS_prep_auth_data_c_l135_c7_3456_return_output, 16);
     VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_0_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_10_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_11_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_12_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_13_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_14_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_15_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_1_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_2_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_3_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_4_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_5_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_6_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_7_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_8_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_aad_reg_9_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iftrue := VAR_aad_reg_MUX_prep_auth_data_c_l68_c7_1631_return_output;
     VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_counter_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_iftrue := VAR_counter_MUX_prep_auth_data_c_l68_c7_1631_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l116_c8_dc01_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iffalse := VAR_prep_auth_data_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_b377_prep_auth_data_c_l116_c8_dc01_return_output;
     VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_iftrue := VAR_state_MUX_prep_auth_data_c_l102_c7_af69_return_output;
     VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_iftrue := VAR_state_MUX_prep_auth_data_c_l134_c5_cab9_return_output;
     VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_iffalse := VAR_state_MUX_prep_auth_data_c_l166_c5_c85e_return_output;
     VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_iftrue := VAR_state_MUX_prep_auth_data_c_l68_c7_1631_return_output;
     VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_iftrue := VAR_counter_prep_auth_data_c_l135_c7_8d3e;
     -- aad_reg_11_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_MUX[prep_auth_data_c_l64_c5_acb2] LATENCY=0
     -- Inputs
     aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_cond <= VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_cond;
     aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iftrue <= VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iftrue;
     aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iffalse <= VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_iffalse;
     -- Outputs
     VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_return_output := aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_return_output;

     -- aad_reg_6_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_15_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_cond;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_return_output := prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_1_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_5_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432[prep_auth_data_c_l84_c8_0400] LATENCY=0
     VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432_prep_auth_data_c_l84_c8_0400_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432(
     axis128_t_stream_t_NULL,
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l89_c5_2d1b_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l91_c7_9e3f_return_output,
     to_unsigned(1, 1),
     to_unsigned(1, 1));

     -- state_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     state_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     state_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_return_output := state_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- state_MUX[prep_auth_data_c_l116_c8_dc01] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l116_c8_dc01_cond <= VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_cond;
     state_MUX_prep_auth_data_c_l116_c8_dc01_iftrue <= VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_iftrue;
     state_MUX_prep_auth_data_c_l116_c8_dc01_iffalse <= VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_return_output := state_MUX_prep_auth_data_c_l116_c8_dc01_return_output;

     -- state_MUX[prep_auth_data_c_l64_c5_acb2] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l64_c5_acb2_cond <= VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_cond;
     state_MUX_prep_auth_data_c_l64_c5_acb2_iftrue <= VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_iftrue;
     state_MUX_prep_auth_data_c_l64_c5_acb2_iffalse <= VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_return_output := state_MUX_prep_auth_data_c_l64_c5_acb2_return_output;

     -- aad_reg_14_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_2_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_4_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_0_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f[prep_auth_data_c_l116_c8_dc01] LATENCY=0
     VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f_prep_auth_data_c_l116_c8_dc01_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f(
     VAR_prep_auth_data_axis_in,
     to_unsigned(0, 1),
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_0_prep_auth_data_axis_out_data_tdata_0_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_1_prep_auth_data_axis_out_data_tdata_1_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_2_prep_auth_data_axis_out_data_tdata_2_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_3_prep_auth_data_axis_out_data_tdata_3_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_4_prep_auth_data_axis_out_data_tdata_4_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_5_prep_auth_data_axis_out_data_tdata_5_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_6_prep_auth_data_axis_out_data_tdata_6_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_7_prep_auth_data_axis_out_data_tdata_7_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_8_prep_auth_data_axis_out_data_tdata_8_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_9_prep_auth_data_axis_out_data_tdata_9_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_10_prep_auth_data_axis_out_data_tdata_10_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_11_prep_auth_data_axis_out_data_tdata_11_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_12_prep_auth_data_axis_out_data_tdata_12_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_13_prep_auth_data_axis_out_data_tdata_13_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_14_prep_auth_data_axis_out_data_tdata_14_MUX_prep_auth_data_c_l128_c7_3893_return_output,
     to_unsigned(1, 1),
     VAR_FOR_prep_auth_data_c_l125_c5_5513_ITER_15_prep_auth_data_axis_out_data_tdata_15_MUX_prep_auth_data_c_l128_c7_3893_return_output);

     -- counter_MUX[prep_auth_data_c_l134_c5_cab9] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l134_c5_cab9_cond <= VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_cond;
     counter_MUX_prep_auth_data_c_l134_c5_cab9_iftrue <= VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_iftrue;
     counter_MUX_prep_auth_data_c_l134_c5_cab9_iffalse <= VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_return_output := counter_MUX_prep_auth_data_c_l134_c5_cab9_return_output;

     -- counter_MUX[prep_auth_data_c_l64_c5_acb2] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l64_c5_acb2_cond <= VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_cond;
     counter_MUX_prep_auth_data_c_l64_c5_acb2_iftrue <= VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_iftrue;
     counter_MUX_prep_auth_data_c_l64_c5_acb2_iffalse <= VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_return_output := counter_MUX_prep_auth_data_c_l64_c5_acb2_return_output;

     -- aad_reg_12_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_8_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_10_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_3_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_7_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- counter_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     counter_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     counter_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_return_output := counter_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_13_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- aad_reg_9_MUX[prep_auth_data_c_l99_c5_e95a] LATENCY=0
     -- Inputs
     aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_cond <= VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_cond;
     aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iftrue <= VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iftrue;
     aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iffalse <= VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_iffalse;
     -- Outputs
     VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_return_output := aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_return_output;

     -- Submodule level 3
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_0_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_10_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_11_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_12_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_13_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_14_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_15_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_1_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_2_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_3_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_4_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_5_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_6_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_7_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_8_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_aad_reg_9_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iftrue := VAR_aad_reg_MUX_prep_auth_data_c_l64_c5_acb2_return_output;
     VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_iftrue := VAR_counter_MUX_prep_auth_data_c_l134_c5_cab9_return_output;
     VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_iftrue := VAR_counter_MUX_prep_auth_data_c_l64_c5_acb2_return_output;
     VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_counter_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iffalse := VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l84_c8_0400_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iftrue := VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_175f_prep_auth_data_c_l116_c8_dc01_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_prep_auth_data_axis_out_TRUE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_4432_prep_auth_data_c_l84_c8_0400_return_output;
     VAR_state_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_state_MUX_prep_auth_data_c_l116_c8_dc01_return_output;
     VAR_state_MUX_prep_auth_data_c_l61_c3_719c_iftrue := VAR_state_MUX_prep_auth_data_c_l64_c5_acb2_return_output;
     VAR_state_MUX_prep_auth_data_c_l84_c8_0400_iftrue := VAR_state_MUX_prep_auth_data_c_l99_c5_e95a_return_output;
     -- aad_reg_8_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- prep_auth_data_axis_out_MUX[prep_auth_data_c_l116_c8_dc01] LATENCY=0
     -- Inputs
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_cond <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_cond;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iftrue <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iftrue;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iffalse <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_return_output := prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_return_output;

     -- aad_reg_4_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_15_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_5_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_13_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_10_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_2_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- prep_auth_data_axis_in_ready_MUX[prep_auth_data_c_l61_c3_719c] LATENCY=0
     -- Inputs
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_cond <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_cond;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iftrue <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iftrue;
     prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iffalse <= VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_return_output := prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_return_output;

     -- state_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_state_MUX_prep_auth_data_c_l84_c8_0400_cond;
     state_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_state_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     state_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_state_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l84_c8_0400_return_output := state_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_11_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_14_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_0_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_9_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_12_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_7_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_6_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- aad_reg_3_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- counter_MUX[prep_auth_data_c_l116_c8_dc01] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l116_c8_dc01_cond <= VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_cond;
     counter_MUX_prep_auth_data_c_l116_c8_dc01_iftrue <= VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_iftrue;
     counter_MUX_prep_auth_data_c_l116_c8_dc01_iffalse <= VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_return_output := counter_MUX_prep_auth_data_c_l116_c8_dc01_return_output;

     -- aad_reg_1_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_cond;
     aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_return_output := aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- Submodule level 4
     VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_counter_MUX_prep_auth_data_c_l116_c8_dc01_return_output;
     VAR_prep_auth_data_axis_in_ready := VAR_prep_auth_data_axis_in_ready_MUX_prep_auth_data_c_l61_c3_719c_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iffalse := VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l116_c8_dc01_return_output;
     VAR_state_MUX_prep_auth_data_c_l61_c3_719c_iffalse := VAR_state_MUX_prep_auth_data_c_l84_c8_0400_return_output;
     -- state_MUX[prep_auth_data_c_l61_c3_719c] LATENCY=0
     -- Inputs
     state_MUX_prep_auth_data_c_l61_c3_719c_cond <= VAR_state_MUX_prep_auth_data_c_l61_c3_719c_cond;
     state_MUX_prep_auth_data_c_l61_c3_719c_iftrue <= VAR_state_MUX_prep_auth_data_c_l61_c3_719c_iftrue;
     state_MUX_prep_auth_data_c_l61_c3_719c_iffalse <= VAR_state_MUX_prep_auth_data_c_l61_c3_719c_iffalse;
     -- Outputs
     VAR_state_MUX_prep_auth_data_c_l61_c3_719c_return_output := state_MUX_prep_auth_data_c_l61_c3_719c_return_output;

     -- aad_reg_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_32_uint8_t_32_aea8[prep_auth_data_c_l61_c3_719c] LATENCY=0
     VAR_aad_reg_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_32_uint8_t_32_aea8_prep_auth_data_c_l61_c3_719c_return_output := CONST_REF_RD_uint8_t_32_uint8_t_32_aea8(
     aad_reg,
     VAR_aad_reg_5_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_2_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_8_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_11_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_14_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_0_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_3_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_6_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_12_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_9_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_15_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_1_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_4_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_10_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_7_MUX_prep_auth_data_c_l84_c8_0400_return_output,
     VAR_aad_reg_13_MUX_prep_auth_data_c_l84_c8_0400_return_output);

     -- prep_auth_data_axis_out_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_cond;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_return_output := prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- counter_MUX[prep_auth_data_c_l84_c8_0400] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l84_c8_0400_cond <= VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_cond;
     counter_MUX_prep_auth_data_c_l84_c8_0400_iftrue <= VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_iftrue;
     counter_MUX_prep_auth_data_c_l84_c8_0400_iffalse <= VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_return_output := counter_MUX_prep_auth_data_c_l84_c8_0400_return_output;

     -- Submodule level 5
     VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iffalse := VAR_aad_reg_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_32_uint8_t_32_aea8_prep_auth_data_c_l61_c3_719c_return_output;
     VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_iffalse := VAR_counter_MUX_prep_auth_data_c_l84_c8_0400_return_output;
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iffalse := VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l84_c8_0400_return_output;
     REG_VAR_state := VAR_state_MUX_prep_auth_data_c_l61_c3_719c_return_output;
     -- counter_MUX[prep_auth_data_c_l61_c3_719c] LATENCY=0
     -- Inputs
     counter_MUX_prep_auth_data_c_l61_c3_719c_cond <= VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_cond;
     counter_MUX_prep_auth_data_c_l61_c3_719c_iftrue <= VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_iftrue;
     counter_MUX_prep_auth_data_c_l61_c3_719c_iffalse <= VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_iffalse;
     -- Outputs
     VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_return_output := counter_MUX_prep_auth_data_c_l61_c3_719c_return_output;

     -- aad_reg_MUX[prep_auth_data_c_l61_c3_719c] LATENCY=0
     -- Inputs
     aad_reg_MUX_prep_auth_data_c_l61_c3_719c_cond <= VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_cond;
     aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iftrue <= VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iftrue;
     aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iffalse <= VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_iffalse;
     -- Outputs
     VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_return_output := aad_reg_MUX_prep_auth_data_c_l61_c3_719c_return_output;

     -- prep_auth_data_axis_out_MUX[prep_auth_data_c_l61_c3_719c] LATENCY=0
     -- Inputs
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_cond <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_cond;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iftrue <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iftrue;
     prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iffalse <= VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_return_output := prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_return_output;

     -- Submodule level 6
     REG_VAR_aad_reg := VAR_aad_reg_MUX_prep_auth_data_c_l61_c3_719c_return_output;
     REG_VAR_counter := VAR_counter_MUX_prep_auth_data_c_l61_c3_719c_return_output;
     VAR_prep_auth_data_axis_out := VAR_prep_auth_data_axis_out_MUX_prep_auth_data_c_l61_c3_719c_return_output;
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
