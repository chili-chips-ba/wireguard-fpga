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
-- Submodules: 13
entity wait_to_verify_0CLK_9d359dd9 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in wait_to_verify_global_to_module_t;
 module_to_global : out wait_to_verify_module_to_global_t);
end wait_to_verify_0CLK_9d359dd9;
architecture arch of wait_to_verify_0CLK_9d359dd9 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal state : unsigned(0 downto 0) := unsigned(wait_to_verify_state_t_to_slv(WAIT_TO_VERIFY_BIT));
signal tags_match_reg : unsigned(0 downto 0) := to_unsigned(0, 1);
signal REG_COMB_state : unsigned(0 downto 0);
signal REG_COMB_tags_match_reg : unsigned(0 downto 0);

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- BIN_OP_EQ[wait_to_verify_c_l54_c6_3438]
signal BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_left : unsigned(0 downto 0);
signal BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_right : unsigned(0 downto 0);
signal BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output : unsigned(0 downto 0);

-- wait_to_verify_axis_out_valid_MUX[wait_to_verify_c_l54_c3_8c60]
signal wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
signal wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
signal wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
signal wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);

-- verify_fifo_out_ready_MUX[wait_to_verify_c_l54_c3_8c60]
signal verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
signal verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
signal verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
signal verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);

-- state_MUX[wait_to_verify_c_l54_c3_8c60]
signal state_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);

-- wait_to_verify_is_verified_out_MUX[wait_to_verify_c_l54_c3_8c60]
signal wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
signal wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
signal wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
signal wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);

-- wait_to_verify_verify_bit_ready_MUX[wait_to_verify_c_l54_c3_8c60]
signal wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
signal wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
signal wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
signal wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);

-- tags_match_reg_MUX[wait_to_verify_c_l54_c3_8c60]
signal tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
signal tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
signal tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
signal tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);

-- state_MUX[wait_to_verify_c_l66_c5_9e1e]
signal state_MUX_wait_to_verify_c_l66_c5_9e1e_cond : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l66_c5_9e1e_return_output : unsigned(0 downto 0);

-- tags_match_reg_MUX[wait_to_verify_c_l66_c5_9e1e]
signal tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_cond : unsigned(0 downto 0);
signal tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue : unsigned(0 downto 0);
signal tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse : unsigned(0 downto 0);
signal tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[wait_to_verify_c_l88_c8_b76e]
signal BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_left : unsigned(0 downto 0);
signal BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_right : unsigned(0 downto 0);
signal BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_return_output : unsigned(0 downto 0);

-- state_MUX[wait_to_verify_c_l88_c5_6262]
signal state_MUX_wait_to_verify_c_l88_c5_6262_cond : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l88_c5_6262_iftrue : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l88_c5_6262_iffalse : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l88_c5_6262_return_output : unsigned(0 downto 0);

-- state_MUX[wait_to_verify_c_l91_c7_bd57]
signal state_MUX_wait_to_verify_c_l91_c7_bd57_cond : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l91_c7_bd57_iftrue : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l91_c7_bd57_iffalse : unsigned(0 downto 0);
signal state_MUX_wait_to_verify_c_l91_c7_bd57_return_output : unsigned(0 downto 0);

function CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee( ref_toks_0 : axis128_t_stream_t;
 ref_toks_1 : unsigned) return axis128_t_stream_t is
 
  variable base : axis128_t_stream_t; 
  variable return_output : axis128_t_stream_t;
begin
      base := ref_toks_0;
      base.valid := ref_toks_1;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_EQ_wait_to_verify_c_l54_c6_3438 : 0 clocks latency
BIN_OP_EQ_wait_to_verify_c_l54_c6_3438 : entity work.BIN_OP_EQ_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_left,
BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_right,
BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output);

-- wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60 : 0 clocks latency
wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_cond,
wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iftrue,
wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iffalse,
wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_return_output);

-- verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60 : 0 clocks latency
verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond,
verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue,
verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse,
verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output);

-- state_MUX_wait_to_verify_c_l54_c3_8c60 : 0 clocks latency
state_MUX_wait_to_verify_c_l54_c3_8c60 : entity work.MUX_uint1_t_wait_to_verify_state_t_wait_to_verify_state_t_0CLK_de264c78 port map (
state_MUX_wait_to_verify_c_l54_c3_8c60_cond,
state_MUX_wait_to_verify_c_l54_c3_8c60_iftrue,
state_MUX_wait_to_verify_c_l54_c3_8c60_iffalse,
state_MUX_wait_to_verify_c_l54_c3_8c60_return_output);

-- wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60 : 0 clocks latency
wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_cond,
wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iftrue,
wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iffalse,
wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_return_output);

-- wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60 : 0 clocks latency
wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond,
wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue,
wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse,
wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output);

-- tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60 : 0 clocks latency
tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_cond,
tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iftrue,
tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iffalse,
tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_return_output);

-- state_MUX_wait_to_verify_c_l66_c5_9e1e : 0 clocks latency
state_MUX_wait_to_verify_c_l66_c5_9e1e : entity work.MUX_uint1_t_wait_to_verify_state_t_wait_to_verify_state_t_0CLK_de264c78 port map (
state_MUX_wait_to_verify_c_l66_c5_9e1e_cond,
state_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue,
state_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse,
state_MUX_wait_to_verify_c_l66_c5_9e1e_return_output);

-- tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e : 0 clocks latency
tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_cond,
tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue,
tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse,
tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_return_output);

-- BIN_OP_AND_wait_to_verify_c_l88_c8_b76e : 0 clocks latency
BIN_OP_AND_wait_to_verify_c_l88_c8_b76e : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_left,
BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_right,
BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_return_output);

-- state_MUX_wait_to_verify_c_l88_c5_6262 : 0 clocks latency
state_MUX_wait_to_verify_c_l88_c5_6262 : entity work.MUX_uint1_t_wait_to_verify_state_t_wait_to_verify_state_t_0CLK_de264c78 port map (
state_MUX_wait_to_verify_c_l88_c5_6262_cond,
state_MUX_wait_to_verify_c_l88_c5_6262_iftrue,
state_MUX_wait_to_verify_c_l88_c5_6262_iffalse,
state_MUX_wait_to_verify_c_l88_c5_6262_return_output);

-- state_MUX_wait_to_verify_c_l91_c7_bd57 : 0 clocks latency
state_MUX_wait_to_verify_c_l91_c7_bd57 : entity work.MUX_uint1_t_wait_to_verify_state_t_wait_to_verify_state_t_0CLK_de264c78 port map (
state_MUX_wait_to_verify_c_l91_c7_bd57_cond,
state_MUX_wait_to_verify_c_l91_c7_bd57_iftrue,
state_MUX_wait_to_verify_c_l91_c7_bd57_iffalse,
state_MUX_wait_to_verify_c_l91_c7_bd57_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Registers
 state,
 tags_match_reg,
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output,
 wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_return_output,
 verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output,
 state_MUX_wait_to_verify_c_l54_c3_8c60_return_output,
 wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_return_output,
 wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output,
 tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_return_output,
 state_MUX_wait_to_verify_c_l66_c5_9e1e_return_output,
 tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_return_output,
 BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_return_output,
 state_MUX_wait_to_verify_c_l88_c5_6262_return_output,
 state_MUX_wait_to_verify_c_l91_c7_bd57_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_verify_fifo_in : axis128_t_stream_t;
 variable VAR_wait_to_verify_axis_in : axis128_t_stream_t;
 variable VAR_wait_to_verify_axis_in_ready : unsigned(0 downto 0);
 variable VAR_verify_fifo_in_ready : unsigned(0 downto 0);
 variable VAR_wait_to_verify_axis_out : axis128_t_stream_t;
 variable VAR_verify_fifo_out : axis128_t_stream_t;
 variable VAR_wait_to_verify_verify_bit_ready : unsigned(0 downto 0);
 variable VAR_verify_fifo_out_ready : unsigned(0 downto 0);
 variable VAR_wait_to_verify_is_verified_out : unsigned(0 downto 0);
 variable VAR_wait_to_verify_verify_bit : uint1_t_stream_t;
 variable VAR_wait_to_verify_axis_out_ready : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output : unsigned(0 downto 0);
 variable VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
 variable VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
 variable VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);
 variable VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
 variable VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
 variable VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
 variable VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);
 variable VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l88_c5_6262_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
 variable VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
 variable VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
 variable VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);
 variable VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
 variable VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
 variable VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
 variable VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);
 variable VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
 variable VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iftrue : unsigned(0 downto 0);
 variable VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_return_output : unsigned(0 downto 0);
 variable VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iffalse : unsigned(0 downto 0);
 variable VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_return_output : unsigned(0 downto 0);
 variable VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_uint1_t_stream_t_valid_d41d_wait_to_verify_c_l66_c8_975a_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_cond : unsigned(0 downto 0);
 variable VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue : unsigned(0 downto 0);
 variable VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse : unsigned(0 downto 0);
 variable VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_uint1_t_stream_t_data_d41d_wait_to_verify_c_l69_c24_932a_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_wait_to_verify_c_l81_c37_66f7_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l88_c5_6262_iftrue : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l88_c5_6262_iffalse : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l88_c5_6262_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_wait_to_verify_c_l91_c11_3fd6_return_output : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_iftrue : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_iffalse : unsigned(0 downto 0);
 variable VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_cond : unsigned(0 downto 0);
 variable VAR_wait_to_verify_axis_out_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee_wait_to_verify_c_l26_c6_1f77_return_output : axis128_t_stream_t;
 -- State registers comb logic variables
variable REG_VAR_state : unsigned(0 downto 0);
variable REG_VAR_tags_match_reg : unsigned(0 downto 0);
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_state := state;
  REG_VAR_tags_match_reg := tags_match_reg;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue := to_unsigned(0, 1);
     VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_right := unsigned(wait_to_verify_state_t_to_slv(WAIT_TO_VERIFY_BIT));
     VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue := unsigned(wait_to_verify_state_t_to_slv(OUTPUT_PLAINTEXT));
     VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iftrue := to_unsigned(0, 1);
     VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue := to_unsigned(1, 1);
     VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_iftrue := unsigned(wait_to_verify_state_t_to_slv(WAIT_TO_VERIFY_BIT));
     VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse := to_unsigned(0, 1);
     VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iftrue := to_unsigned(0, 1);
 -- Reads from global variables
     VAR_wait_to_verify_axis_in := global_to_module.wait_to_verify_axis_in;
     VAR_verify_fifo_in_ready := global_to_module.verify_fifo_in_ready;
     VAR_verify_fifo_out := global_to_module.verify_fifo_out;
     VAR_wait_to_verify_verify_bit := global_to_module.wait_to_verify_verify_bit;
     VAR_wait_to_verify_axis_out_ready := global_to_module.wait_to_verify_axis_out_ready;
     -- Submodule level 0
     VAR_verify_fifo_in := VAR_wait_to_verify_axis_in;
     VAR_wait_to_verify_axis_in_ready := VAR_verify_fifo_in_ready;
     VAR_BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_right := VAR_wait_to_verify_axis_out_ready;
     VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse := VAR_wait_to_verify_axis_out_ready;
     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d[wait_to_verify_c_l81_c37_66f7] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_wait_to_verify_c_l81_c37_66f7_return_output := VAR_verify_fifo_out.valid;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[wait_to_verify_c_l91_c11_3fd6] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_wait_to_verify_c_l91_c11_3fd6_return_output := VAR_verify_fifo_out.data.tlast;

     -- CONST_REF_RD_uint1_t_uint1_t_stream_t_valid_d41d[wait_to_verify_c_l66_c8_975a] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_uint1_t_stream_t_valid_d41d_wait_to_verify_c_l66_c8_975a_return_output := VAR_wait_to_verify_verify_bit.valid;

     -- CONST_REF_RD_uint1_t_uint1_t_stream_t_data_d41d[wait_to_verify_c_l69_c24_932a] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_uint1_t_stream_t_data_d41d_wait_to_verify_c_l69_c24_932a_return_output := VAR_wait_to_verify_verify_bit.data;

     -- Submodule level 1
     VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue := VAR_CONST_REF_RD_uint1_t_uint1_t_stream_t_data_d41d_wait_to_verify_c_l69_c24_932a_return_output;
     VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_wait_to_verify_c_l91_c11_3fd6_return_output;
     VAR_BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_wait_to_verify_c_l81_c37_66f7_return_output;
     VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iffalse := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_wait_to_verify_c_l81_c37_66f7_return_output;
     VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_cond := VAR_CONST_REF_RD_uint1_t_uint1_t_stream_t_valid_d41d_wait_to_verify_c_l66_c8_975a_return_output;
     VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_cond := VAR_CONST_REF_RD_uint1_t_uint1_t_stream_t_valid_d41d_wait_to_verify_c_l66_c8_975a_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_left := state;
     VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse := state;
     VAR_state_MUX_wait_to_verify_c_l88_c5_6262_iffalse := state;
     VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_iffalse := state;
     VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iffalse := tags_match_reg;
     VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse := tags_match_reg;
     VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iffalse := tags_match_reg;
     -- state_MUX[wait_to_verify_c_l91_c7_bd57] LATENCY=0
     -- Inputs
     state_MUX_wait_to_verify_c_l91_c7_bd57_cond <= VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_cond;
     state_MUX_wait_to_verify_c_l91_c7_bd57_iftrue <= VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_iftrue;
     state_MUX_wait_to_verify_c_l91_c7_bd57_iffalse <= VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_iffalse;
     -- Outputs
     VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_return_output := state_MUX_wait_to_verify_c_l91_c7_bd57_return_output;

     -- state_MUX[wait_to_verify_c_l66_c5_9e1e] LATENCY=0
     -- Inputs
     state_MUX_wait_to_verify_c_l66_c5_9e1e_cond <= VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_cond;
     state_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue <= VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue;
     state_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse <= VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse;
     -- Outputs
     VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_return_output := state_MUX_wait_to_verify_c_l66_c5_9e1e_return_output;

     -- BIN_OP_AND[wait_to_verify_c_l88_c8_b76e] LATENCY=0
     -- Inputs
     BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_left <= VAR_BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_left;
     BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_right <= VAR_BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_right;
     -- Outputs
     VAR_BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_return_output := BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_return_output;

     -- BIN_OP_EQ[wait_to_verify_c_l54_c6_3438] LATENCY=0
     -- Inputs
     BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_left <= VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_left;
     BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_right <= VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_right;
     -- Outputs
     VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output := BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output;

     -- tags_match_reg_MUX[wait_to_verify_c_l66_c5_9e1e] LATENCY=0
     -- Inputs
     tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_cond <= VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_cond;
     tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue <= VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iftrue;
     tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse <= VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_iffalse;
     -- Outputs
     VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_return_output := tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_return_output;

     -- Submodule level 1
     VAR_state_MUX_wait_to_verify_c_l88_c5_6262_cond := VAR_BIN_OP_AND_wait_to_verify_c_l88_c8_b76e_return_output;
     VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_cond := VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output;
     VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_cond := VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output;
     VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond := VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output;
     VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_cond := VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output;
     VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_cond := VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output;
     VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond := VAR_BIN_OP_EQ_wait_to_verify_c_l54_c6_3438_return_output;
     VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_iftrue := VAR_state_MUX_wait_to_verify_c_l66_c5_9e1e_return_output;
     VAR_state_MUX_wait_to_verify_c_l88_c5_6262_iftrue := VAR_state_MUX_wait_to_verify_c_l91_c7_bd57_return_output;
     VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iftrue := VAR_tags_match_reg_MUX_wait_to_verify_c_l66_c5_9e1e_return_output;
     -- verify_fifo_out_ready_MUX[wait_to_verify_c_l54_c3_8c60] LATENCY=0
     -- Inputs
     verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond <= VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond;
     verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue <= VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue;
     verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse <= VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse;
     -- Outputs
     VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output := verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output;

     -- wait_to_verify_verify_bit_ready_MUX[wait_to_verify_c_l54_c3_8c60] LATENCY=0
     -- Inputs
     wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond <= VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_cond;
     wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue <= VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iftrue;
     wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse <= VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_iffalse;
     -- Outputs
     VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output := wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output;

     -- wait_to_verify_is_verified_out_MUX[wait_to_verify_c_l54_c3_8c60] LATENCY=0
     -- Inputs
     wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_cond <= VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_cond;
     wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iftrue <= VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iftrue;
     wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iffalse <= VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_iffalse;
     -- Outputs
     VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_return_output := wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_return_output;

     -- wait_to_verify_axis_out_valid_MUX[wait_to_verify_c_l54_c3_8c60] LATENCY=0
     -- Inputs
     wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_cond <= VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_cond;
     wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iftrue <= VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iftrue;
     wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iffalse <= VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_iffalse;
     -- Outputs
     VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_return_output := wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_return_output;

     -- tags_match_reg_MUX[wait_to_verify_c_l54_c3_8c60] LATENCY=0
     -- Inputs
     tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_cond <= VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_cond;
     tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iftrue <= VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iftrue;
     tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iffalse <= VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_iffalse;
     -- Outputs
     VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_return_output := tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_return_output;

     -- state_MUX[wait_to_verify_c_l88_c5_6262] LATENCY=0
     -- Inputs
     state_MUX_wait_to_verify_c_l88_c5_6262_cond <= VAR_state_MUX_wait_to_verify_c_l88_c5_6262_cond;
     state_MUX_wait_to_verify_c_l88_c5_6262_iftrue <= VAR_state_MUX_wait_to_verify_c_l88_c5_6262_iftrue;
     state_MUX_wait_to_verify_c_l88_c5_6262_iffalse <= VAR_state_MUX_wait_to_verify_c_l88_c5_6262_iffalse;
     -- Outputs
     VAR_state_MUX_wait_to_verify_c_l88_c5_6262_return_output := state_MUX_wait_to_verify_c_l88_c5_6262_return_output;

     -- Submodule level 2
     VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_iffalse := VAR_state_MUX_wait_to_verify_c_l88_c5_6262_return_output;
     REG_VAR_tags_match_reg := VAR_tags_match_reg_MUX_wait_to_verify_c_l54_c3_8c60_return_output;
     VAR_verify_fifo_out_ready := VAR_verify_fifo_out_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output;
     VAR_wait_to_verify_is_verified_out := VAR_wait_to_verify_is_verified_out_MUX_wait_to_verify_c_l54_c3_8c60_return_output;
     VAR_wait_to_verify_verify_bit_ready := VAR_wait_to_verify_verify_bit_ready_MUX_wait_to_verify_c_l54_c3_8c60_return_output;
     -- state_MUX[wait_to_verify_c_l54_c3_8c60] LATENCY=0
     -- Inputs
     state_MUX_wait_to_verify_c_l54_c3_8c60_cond <= VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_cond;
     state_MUX_wait_to_verify_c_l54_c3_8c60_iftrue <= VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_iftrue;
     state_MUX_wait_to_verify_c_l54_c3_8c60_iffalse <= VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_iffalse;
     -- Outputs
     VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_return_output := state_MUX_wait_to_verify_c_l54_c3_8c60_return_output;

     -- wait_to_verify_axis_out_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee[wait_to_verify_c_l26_c6_1f77] LATENCY=0
     VAR_wait_to_verify_axis_out_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee_wait_to_verify_c_l26_c6_1f77_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee(
     VAR_verify_fifo_out,
     VAR_wait_to_verify_axis_out_valid_MUX_wait_to_verify_c_l54_c3_8c60_return_output);

     -- Submodule level 3
     REG_VAR_state := VAR_state_MUX_wait_to_verify_c_l54_c3_8c60_return_output;
     VAR_wait_to_verify_axis_out := VAR_wait_to_verify_axis_out_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee_wait_to_verify_c_l26_c6_1f77_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_state <= REG_VAR_state;
REG_COMB_tags_match_reg <= REG_VAR_tags_match_reg;
-- Global wires driven various places in pipeline
if clk_en_internal='1' then
  module_to_global.verify_fifo_in <= VAR_verify_fifo_in;
else
  module_to_global.verify_fifo_in <= axis128_t_stream_t_NULL;
end if;
if clk_en_internal='1' then
  module_to_global.wait_to_verify_axis_in_ready <= VAR_wait_to_verify_axis_in_ready;
else
  module_to_global.wait_to_verify_axis_in_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.wait_to_verify_axis_out <= VAR_wait_to_verify_axis_out;
else
  module_to_global.wait_to_verify_axis_out <= axis128_t_stream_t_NULL;
end if;
if clk_en_internal='1' then
  module_to_global.wait_to_verify_verify_bit_ready <= VAR_wait_to_verify_verify_bit_ready;
else
  module_to_global.wait_to_verify_verify_bit_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.verify_fifo_out_ready <= VAR_verify_fifo_out_ready;
else
  module_to_global.verify_fifo_out_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.wait_to_verify_is_verified_out <= VAR_wait_to_verify_is_verified_out;
else
  module_to_global.wait_to_verify_is_verified_out <= to_unsigned(0, 1);
end if;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     state <= REG_COMB_state;
     tags_match_reg <= REG_COMB_tags_match_reg;
 end if;
 end if;
end process;

end arch;
