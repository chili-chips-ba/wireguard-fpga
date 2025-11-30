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
-- Submodules: 13
entity axis128_early_tlast_0CLK_4e6656cf is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 axis_in : in axis128_t_stream_t;
 ready_for_axis_out : in unsigned(0 downto 0);
 return_output : out axis128_early_tlast_t);
end axis128_early_tlast_0CLK_4e6656cf;
architecture arch of axis128_early_tlast_0CLK_4e6656cf is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal buffer_reg : axis128_t_stream_t := axis128_t_stream_t_NULL;
signal REG_COMB_buffer_reg : axis128_t_stream_t;

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- BIN_OP_AND[strip_auth_tag_c_l35_c7_c96e]
signal BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_left : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_right : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[strip_auth_tag_c_l39_c7_42f0]
signal BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_left : unsigned(0 downto 0);
signal BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_right : unsigned(0 downto 0);
signal BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_return_output : unsigned(0 downto 0);

-- o_axis_out_MUX[strip_auth_tag_c_l43_c5_b942]
signal o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_cond : unsigned(0 downto 0);
signal o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iftrue : axis128_t_stream_t;
signal o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iffalse : axis128_t_stream_t;
signal o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_return_output : axis128_t_stream_t;

-- o_next_axis_out_is_tlast_MUX[strip_auth_tag_c_l43_c5_b942]
signal o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_cond : unsigned(0 downto 0);
signal o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iftrue : unsigned(0 downto 0);
signal o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iffalse : unsigned(0 downto 0);
signal o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[strip_auth_tag_c_l45_c34_30cd]
signal BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_left : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_right : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[strip_auth_tag_c_l49_c8_b34c]
signal BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_left : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_right : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_return_output : unsigned(0 downto 0);

-- buffer_reg_valid_MUX[strip_auth_tag_c_l49_c5_2ff5]
signal buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_cond : unsigned(0 downto 0);
signal buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iftrue : unsigned(0 downto 0);
signal buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iffalse : unsigned(0 downto 0);
signal buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_return_output : unsigned(0 downto 0);

-- UNARY_OP_NOT[strip_auth_tag_c_l54_c28_12fa]
signal UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_expr : unsigned(0 downto 0);
signal UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_return_output : unsigned(0 downto 0);

-- BIN_OP_AND[strip_auth_tag_c_l56_c8_6747]
signal BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_left : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_right : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_return_output : unsigned(0 downto 0);

-- buffer_reg_MUX[strip_auth_tag_c_l56_c5_3e0b]
signal buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_cond : unsigned(0 downto 0);
signal buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iftrue : axis128_t_stream_t;
signal buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iffalse : axis128_t_stream_t;
signal buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_return_output : axis128_t_stream_t;

function CONST_REF_RD_uint1_t_axis128_early_tlast_t_axis_out_valid_01c3( ref_toks_0 : axis128_t_stream_t) return unsigned is
 
  variable base : axis128_early_tlast_t; 
  variable return_output : unsigned(0 downto 0);
begin
      base.axis_out := ref_toks_0;

      return_output := base.axis_out.valid;
      return return_output; 
end function;

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

function CONST_REF_RD_axis128_early_tlast_t_axis128_early_tlast_t_233a( ref_toks_0 : axis128_t_stream_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned) return axis128_early_tlast_t is
 
  variable base : axis128_early_tlast_t; 
  variable return_output : axis128_early_tlast_t;
begin
      base.axis_out := ref_toks_0;
      base.next_axis_out_is_tlast := ref_toks_1;
      base.ready_for_axis_in := ref_toks_2;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e : 0 clocks latency
BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_left,
BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_right,
BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_return_output);

-- BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0 : 0 clocks latency
BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_left,
BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_right,
BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_return_output);

-- o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942 : 0 clocks latency
o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942 : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_cond,
o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iftrue,
o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iffalse,
o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_return_output);

-- o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942 : 0 clocks latency
o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_cond,
o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iftrue,
o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iffalse,
o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_return_output);

-- BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd : 0 clocks latency
BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_left,
BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_right,
BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_return_output);

-- BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c : 0 clocks latency
BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_left,
BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_right,
BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_return_output);

-- buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5 : 0 clocks latency
buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_cond,
buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iftrue,
buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iffalse,
buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_return_output);

-- UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa : 0 clocks latency
UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_expr,
UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_return_output);

-- BIN_OP_AND_strip_auth_tag_c_l56_c8_6747 : 0 clocks latency
BIN_OP_AND_strip_auth_tag_c_l56_c8_6747 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_left,
BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_right,
BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_return_output);

-- buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b : 0 clocks latency
buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_cond,
buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iftrue,
buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iffalse,
buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Inputs
 axis_in,
 ready_for_axis_out,
 -- Registers
 buffer_reg,
 -- All submodule outputs
 BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_return_output,
 BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_return_output,
 o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_return_output,
 o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_return_output,
 BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_return_output,
 BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_return_output,
 buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_return_output,
 UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_return_output,
 BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_return_output,
 buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : axis128_early_tlast_t;
 variable VAR_axis_in : axis128_t_stream_t;
 variable VAR_ready_for_axis_out : unsigned(0 downto 0);
 variable VAR_o : axis128_early_tlast_t;
 variable VAR_buffer_is_tlast : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l35_c26_d962_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_return_output : unsigned(0 downto 0);
 variable VAR_buff_to_out_connected : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_return_output : unsigned(0 downto 0);
 variable VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iftrue : axis128_t_stream_t;
 variable VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iffalse : axis128_t_stream_t;
 variable VAR_o_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d_strip_auth_tag_c_l43_c5_b942_return_output : axis128_t_stream_t;
 variable VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_return_output : axis128_t_stream_t;
 variable VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_cond : unsigned(0 downto 0);
 variable VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iftrue : unsigned(0 downto 0);
 variable VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iffalse : unsigned(0 downto 0);
 variable VAR_o_next_axis_out_is_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis128_early_tlast_t_next_axis_out_is_tlast_d41d_strip_auth_tag_c_l43_c5_b942_return_output : unsigned(0 downto 0);
 variable VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_return_output : unsigned(0 downto 0);
 variable VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l45_c50_1f9a_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_early_tlast_t_axis_out_valid_01c3_strip_auth_tag_c_l49_c8_77b3_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_return_output : unsigned(0 downto 0);
 variable VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iftrue : unsigned(0 downto 0);
 variable VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iffalse : unsigned(0 downto 0);
 variable VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_return_output : unsigned(0 downto 0);
 variable VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_cond : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_expr : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_return_output : unsigned(0 downto 0);
 variable VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iftrue : axis128_t_stream_t;
 variable VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iffalse : axis128_t_stream_t;
 variable VAR_buffer_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee_strip_auth_tag_c_l56_c5_3e0b_return_output : axis128_t_stream_t;
 variable VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_return_output : axis128_t_stream_t;
 variable VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_axis128_early_tlast_t_axis128_early_tlast_t_233a_strip_auth_tag_c_l60_c12_d2c9_return_output : axis128_early_tlast_t;
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l35_l49_DUPLICATE_d495_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l56_l42_l45_DUPLICATE_4540_return_output : unsigned(0 downto 0);
 -- State registers comb logic variables
variable REG_VAR_buffer_reg : axis128_t_stream_t;
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_buffer_reg := buffer_reg;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iftrue := to_unsigned(0, 1);
     -- o_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d[strip_auth_tag_c_l43_c5_b942] LATENCY=0
     VAR_o_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d_strip_auth_tag_c_l43_c5_b942_return_output := axis128_early_tlast_t_NULL.axis_out;

     -- o_next_axis_out_is_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis128_early_tlast_t_next_axis_out_is_tlast_d41d[strip_auth_tag_c_l43_c5_b942] LATENCY=0
     VAR_o_next_axis_out_is_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis128_early_tlast_t_next_axis_out_is_tlast_d41d_strip_auth_tag_c_l43_c5_b942_return_output := axis128_early_tlast_t_NULL.next_axis_out_is_tlast;

     -- Submodule level 1
     VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iffalse := VAR_o_axis_out_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d_strip_auth_tag_c_l43_c5_b942_return_output;
     VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iffalse := VAR_o_next_axis_out_is_tlast_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_axis128_early_tlast_t_next_axis_out_is_tlast_d41d_strip_auth_tag_c_l43_c5_b942_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;
     -- Mux in inputs
     VAR_axis_in := axis_in;
     VAR_ready_for_axis_out := ready_for_axis_out;

     -- Submodule level 0
     VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iftrue := VAR_axis_in;
     VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iftrue := buffer_reg;
     VAR_BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_right := VAR_ready_for_axis_out;
     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[strip_auth_tag_c_l45_c50_1f9a] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l45_c50_1f9a_return_output := VAR_axis_in.data.tlast;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l35_l49_DUPLICATE_d495 LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l35_l49_DUPLICATE_d495_return_output := buffer_reg.valid;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[strip_auth_tag_c_l35_c26_d962] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l35_c26_d962_return_output := buffer_reg.data.tlast;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l56_l42_l45_DUPLICATE_4540 LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l56_l42_l45_DUPLICATE_4540_return_output := VAR_axis_in.valid;

     -- Submodule level 1
     VAR_BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_right := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l35_c26_d962_return_output;
     VAR_BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_right := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l45_c50_1f9a_return_output;
     VAR_BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l35_l49_DUPLICATE_d495_return_output;
     VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iffalse := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l35_l49_DUPLICATE_d495_return_output;
     VAR_BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l56_l42_l45_DUPLICATE_4540_return_output;
     VAR_BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l56_l42_l45_DUPLICATE_4540_return_output;
     VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_right := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l56_l42_l45_DUPLICATE_4540_return_output;
     -- BIN_OP_AND[strip_auth_tag_c_l35_c7_c96e] LATENCY=0
     -- Inputs
     BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_left <= VAR_BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_left;
     BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_right <= VAR_BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_right;
     -- Outputs
     VAR_BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_return_output := BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_return_output;

     -- BIN_OP_AND[strip_auth_tag_c_l45_c34_30cd] LATENCY=0
     -- Inputs
     BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_left <= VAR_BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_left;
     BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_right <= VAR_BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_right;
     -- Outputs
     VAR_BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_return_output := BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_return_output;

     -- Submodule level 2
     VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_left := VAR_BIN_OP_AND_strip_auth_tag_c_l35_c7_c96e_return_output;
     VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iftrue := VAR_BIN_OP_AND_strip_auth_tag_c_l45_c34_30cd_return_output;
     -- BIN_OP_OR[strip_auth_tag_c_l39_c7_42f0] LATENCY=0
     -- Inputs
     BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_left <= VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_left;
     BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_right <= VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_right;
     -- Outputs
     VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_return_output := BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_return_output;

     -- Submodule level 3
     VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_cond := VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_return_output;
     VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_cond := VAR_BIN_OP_OR_strip_auth_tag_c_l39_c7_42f0_return_output;
     -- o_axis_out_MUX[strip_auth_tag_c_l43_c5_b942] LATENCY=0
     -- Inputs
     o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_cond <= VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_cond;
     o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iftrue <= VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iftrue;
     o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iffalse <= VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_iffalse;
     -- Outputs
     VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_return_output := o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_return_output;

     -- o_next_axis_out_is_tlast_MUX[strip_auth_tag_c_l43_c5_b942] LATENCY=0
     -- Inputs
     o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_cond <= VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_cond;
     o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iftrue <= VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iftrue;
     o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iffalse <= VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_iffalse;
     -- Outputs
     VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_return_output := o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_return_output;

     -- Submodule level 4
     -- CONST_REF_RD_uint1_t_axis128_early_tlast_t_axis_out_valid_01c3[strip_auth_tag_c_l49_c8_77b3] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_early_tlast_t_axis_out_valid_01c3_strip_auth_tag_c_l49_c8_77b3_return_output := CONST_REF_RD_uint1_t_axis128_early_tlast_t_axis_out_valid_01c3(
     VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_return_output);

     -- Submodule level 5
     VAR_BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_left := VAR_CONST_REF_RD_uint1_t_axis128_early_tlast_t_axis_out_valid_01c3_strip_auth_tag_c_l49_c8_77b3_return_output;
     -- BIN_OP_AND[strip_auth_tag_c_l49_c8_b34c] LATENCY=0
     -- Inputs
     BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_left <= VAR_BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_left;
     BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_right <= VAR_BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_right;
     -- Outputs
     VAR_BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_return_output := BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_return_output;

     -- Submodule level 6
     VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l49_c8_b34c_return_output;
     -- buffer_reg_valid_MUX[strip_auth_tag_c_l49_c5_2ff5] LATENCY=0
     -- Inputs
     buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_cond <= VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_cond;
     buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iftrue <= VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iftrue;
     buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iffalse <= VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_iffalse;
     -- Outputs
     VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_return_output := buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_return_output;

     -- Submodule level 7
     VAR_UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_expr := VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_return_output;
     -- buffer_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee[strip_auth_tag_c_l56_c5_3e0b] LATENCY=0
     VAR_buffer_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee_strip_auth_tag_c_l56_c5_3e0b_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee(
     buffer_reg,
     VAR_buffer_reg_valid_MUX_strip_auth_tag_c_l49_c5_2ff5_return_output);

     -- UNARY_OP_NOT[strip_auth_tag_c_l54_c28_12fa] LATENCY=0
     -- Inputs
     UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_expr <= VAR_UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_expr;
     -- Outputs
     VAR_UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_return_output := UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_return_output;

     -- Submodule level 8
     VAR_BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_right := VAR_UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_return_output;
     VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iffalse := VAR_buffer_reg_FALSE_INPUT_MUX_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_2dee_strip_auth_tag_c_l56_c5_3e0b_return_output;
     -- CONST_REF_RD_axis128_early_tlast_t_axis128_early_tlast_t_233a[strip_auth_tag_c_l60_c12_d2c9] LATENCY=0
     VAR_CONST_REF_RD_axis128_early_tlast_t_axis128_early_tlast_t_233a_strip_auth_tag_c_l60_c12_d2c9_return_output := CONST_REF_RD_axis128_early_tlast_t_axis128_early_tlast_t_233a(
     VAR_o_axis_out_MUX_strip_auth_tag_c_l43_c5_b942_return_output,
     VAR_o_next_axis_out_is_tlast_MUX_strip_auth_tag_c_l43_c5_b942_return_output,
     VAR_UNARY_OP_NOT_strip_auth_tag_c_l54_c28_12fa_return_output);

     -- BIN_OP_AND[strip_auth_tag_c_l56_c8_6747] LATENCY=0
     -- Inputs
     BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_left <= VAR_BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_left;
     BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_right <= VAR_BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_right;
     -- Outputs
     VAR_BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_return_output := BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_return_output;

     -- Submodule level 9
     VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l56_c8_6747_return_output;
     VAR_return_output := VAR_CONST_REF_RD_axis128_early_tlast_t_axis128_early_tlast_t_233a_strip_auth_tag_c_l60_c12_d2c9_return_output;
     -- buffer_reg_MUX[strip_auth_tag_c_l56_c5_3e0b] LATENCY=0
     -- Inputs
     buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_cond <= VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_cond;
     buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iftrue <= VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iftrue;
     buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iffalse <= VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_iffalse;
     -- Outputs
     VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_return_output := buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_return_output;

     -- Submodule level 10
     REG_VAR_buffer_reg := VAR_buffer_reg_MUX_strip_auth_tag_c_l56_c5_3e0b_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_buffer_reg <= REG_VAR_buffer_reg;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     buffer_reg <= REG_COMB_buffer_reg;
 end if;
 end if;
end process;

end arch;
