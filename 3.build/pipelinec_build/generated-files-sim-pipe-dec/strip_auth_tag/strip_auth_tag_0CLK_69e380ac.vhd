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
-- Submodules: 8
entity strip_auth_tag_0CLK_69e380ac is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in strip_auth_tag_global_to_module_t;
 module_to_global : out strip_auth_tag_module_to_global_t);
end strip_auth_tag_0CLK_69e380ac;
architecture arch of strip_auth_tag_0CLK_69e380ac is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- Type holding all locally declared (feedback) wires of the func 
type feedback_vars_t is record
  -- Feedback vars
 ready_for_axis_in : unsigned(0 downto 0);
end record;
-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Feedback vars in the func
signal feedback_vars : feedback_vars_t;
-- Each function instance gets signals
-- axis128_early_tlast[strip_auth_tag_c_l72_c39_9d50]
signal axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_CLOCK_ENABLE : unsigned(0 downto 0);
signal axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_axis_in : axis128_t_stream_t;
signal axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_ready_for_axis_out : unsigned(0 downto 0);
signal axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_return_output : axis128_early_tlast_t;

-- BIN_OP_AND[strip_auth_tag_c_l91_c7_b43d]
signal BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_left : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_right : unsigned(0 downto 0);
signal BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_return_output : unsigned(0 downto 0);

-- ready_for_axis_in_MUX[strip_auth_tag_c_l91_c3_d8e0]
signal ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_cond : unsigned(0 downto 0);
signal ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue : unsigned(0 downto 0);
signal ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse : unsigned(0 downto 0);
signal ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output : unsigned(0 downto 0);

-- strip_auth_tag_axis_out_valid_MUX[strip_auth_tag_c_l91_c3_d8e0]
signal strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_cond : unsigned(0 downto 0);
signal strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue : unsigned(0 downto 0);
signal strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse : unsigned(0 downto 0);
signal strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output : unsigned(0 downto 0);

-- strip_auth_tag_auth_tag_out_MUX[strip_auth_tag_c_l91_c3_d8e0]
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_cond : unsigned(0 downto 0);
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue : uint128_t_stream_t;
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse : uint128_t_stream_t;
signal strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output : uint128_t_stream_t;

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

function CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1( ref_toks_0 : axis128_t_stream_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned) return axis128_t_stream_t is
 
  variable base : axis128_t_stream_t; 
  variable return_output : axis128_t_stream_t;
begin
      base := ref_toks_0;
      base.data.tlast := ref_toks_1;
      base.valid := ref_toks_2;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50 : 0 clocks latency
axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50 : entity work.axis128_early_tlast_0CLK_4e6656cf port map (
clk,
axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_CLOCK_ENABLE,
axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_axis_in,
axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_ready_for_axis_out,
axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_return_output);

-- BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d : 0 clocks latency
BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_left,
BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_right,
BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_return_output);

-- ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0 : 0 clocks latency
ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_cond,
ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue,
ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse,
ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output);

-- strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0 : 0 clocks latency
strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_cond,
strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue,
strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse,
strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output);

-- strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0 : 0 clocks latency
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0 : entity work.MUX_uint1_t_uint128_t_stream_t_uint128_t_stream_t_0CLK_de264c78 port map (
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_cond,
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue,
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse,
strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Feedback vars
 feedback_vars,
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_return_output,
 BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_return_output,
 ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output,
 strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output,
 strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_in : axis128_t_stream_t;
 variable VAR_strip_auth_tag_axis_in_ready : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_out : axis128_t_stream_t;
 variable VAR_strip_auth_tag_axis_out_ready : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_auth_tag_out : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_ready : unsigned(0 downto 0);
 variable VAR_ready_for_axis_in : unsigned(0 downto 0);
 variable VAR_early_tlast : axis128_early_tlast_t;
 variable VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_axis_in : axis128_t_stream_t;
 variable VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_ready_for_axis_out : unsigned(0 downto 0);
 variable VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_return_output : axis128_early_tlast_t;
 variable VAR_CONST_REF_RD_uint1_t_axis128_early_tlast_t_ready_for_axis_in_d41d_strip_auth_tag_c_l75_c34_fe1f_return_output : unsigned(0 downto 0);
 variable VAR_axis_in : axis128_t_stream_t;
 variable VAR_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d_strip_auth_tag_c_l77_c32_c987_return_output : axis128_t_stream_t;
 variable VAR_CONST_REF_RD_uint1_t_axis128_early_tlast_t_next_axis_out_is_tlast_d41d_strip_auth_tag_c_l85_c40_81bc_return_output : unsigned(0 downto 0);
 variable VAR_auth_tag_null : uint128_t_stream_t;
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_left : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l91_c23_ad02_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_return_output : unsigned(0 downto 0);
 variable VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue : unsigned(0 downto 0);
 variable VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse : unsigned(0 downto 0);
 variable VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output : unsigned(0 downto 0);
 variable VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_cond : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_cond : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_strip_auth_tag_c_l91_c3_d8e0_return_output : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d_strip_auth_tag_c_l96_c58_892b_return_output : uint8_t_16;
 variable VAR_uint8_array16_le_strip_auth_tag_c_l96_c41_2bae_return_output : unsigned(127 downto 0);
 variable VAR_strip_auth_tag_axis_out_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1_strip_auth_tag_c_l66_c6_7a2c_return_output : axis128_t_stream_t;
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l91_l97_DUPLICATE_88f6_return_output : unsigned(0 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse := uint128_t_stream_t_NULL;
     VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue := to_unsigned(0, 1);
 -- Reads from global variables
     VAR_strip_auth_tag_axis_in := global_to_module.strip_auth_tag_axis_in;
     VAR_strip_auth_tag_axis_out_ready := global_to_module.strip_auth_tag_axis_out_ready;
     VAR_strip_auth_tag_auth_tag_out_ready := global_to_module.strip_auth_tag_auth_tag_out_ready;
     -- Submodule level 0
     VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue := VAR_strip_auth_tag_auth_tag_out_ready;
     VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse := VAR_strip_auth_tag_axis_out_ready;
     VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_axis_in := VAR_strip_auth_tag_axis_in;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_ready_for_axis_out := feedback_vars.ready_for_axis_in;
     -- axis128_early_tlast[strip_auth_tag_c_l72_c39_9d50] LATENCY=0
     -- Clock enable
     axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_CLOCK_ENABLE <= VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_CLOCK_ENABLE;
     -- Inputs
     axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_axis_in <= VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_axis_in;
     axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_ready_for_axis_out <= VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_ready_for_axis_out;
     -- Outputs
     VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_return_output := axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_return_output;

     -- Submodule level 1
     -- CONST_REF_RD_uint1_t_axis128_early_tlast_t_ready_for_axis_in_d41d[strip_auth_tag_c_l75_c34_fe1f] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_early_tlast_t_ready_for_axis_in_d41d_strip_auth_tag_c_l75_c34_fe1f_return_output := VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_return_output.ready_for_axis_in;

     -- CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d[strip_auth_tag_c_l77_c32_c987] LATENCY=0
     VAR_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d_strip_auth_tag_c_l77_c32_c987_return_output := VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_return_output.axis_out;

     -- CONST_REF_RD_uint1_t_axis128_early_tlast_t_next_axis_out_is_tlast_d41d[strip_auth_tag_c_l85_c40_81bc] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_early_tlast_t_next_axis_out_is_tlast_d41d_strip_auth_tag_c_l85_c40_81bc_return_output := VAR_axis128_early_tlast_strip_auth_tag_c_l72_c39_9d50_return_output.next_axis_out_is_tlast;

     -- Submodule level 2
     VAR_strip_auth_tag_axis_in_ready := VAR_CONST_REF_RD_uint1_t_axis128_early_tlast_t_ready_for_axis_in_d41d_strip_auth_tag_c_l75_c34_fe1f_return_output;
     -- CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d[strip_auth_tag_c_l96_c58_892b] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d_strip_auth_tag_c_l96_c58_892b_return_output := VAR_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d_strip_auth_tag_c_l77_c32_c987_return_output.data.tdata;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d[strip_auth_tag_c_l91_c23_ad02] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l91_c23_ad02_return_output := VAR_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d_strip_auth_tag_c_l77_c32_c987_return_output.data.tlast;

     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l91_l97_DUPLICATE_88f6 LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l91_l97_DUPLICATE_88f6_return_output := VAR_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d_strip_auth_tag_c_l77_c32_c987_return_output.valid;

     -- Submodule level 3
     VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_right := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_data_tlast_d41d_strip_auth_tag_c_l91_c23_ad02_return_output;
     VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l91_l97_DUPLICATE_88f6_return_output;
     VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l91_l97_DUPLICATE_88f6_return_output;
     -- BIN_OP_AND[strip_auth_tag_c_l91_c7_b43d] LATENCY=0
     -- Inputs
     BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_left <= VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_left;
     BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_right <= VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_right;
     -- Outputs
     VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_return_output := BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_return_output;

     -- uint8_array16_le[strip_auth_tag_c_l96_c41_2bae] LATENCY=0
     VAR_uint8_array16_le_strip_auth_tag_c_l96_c41_2bae_return_output := uint8_array16_le(
     VAR_CONST_REF_RD_uint8_t_16_axis128_t_stream_t_data_tdata_d41d_strip_auth_tag_c_l96_c58_892b_return_output);

     -- Submodule level 4
     VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_return_output;
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_return_output;
     VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_cond := VAR_BIN_OP_AND_strip_auth_tag_c_l91_c7_b43d_return_output;
     -- strip_auth_tag_axis_out_valid_MUX[strip_auth_tag_c_l91_c3_d8e0] LATENCY=0
     -- Inputs
     strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_cond <= VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_cond;
     strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue <= VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue;
     strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse <= VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse;
     -- Outputs
     VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output := strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output;

     -- ready_for_axis_in_MUX[strip_auth_tag_c_l91_c3_d8e0] LATENCY=0
     -- Inputs
     ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_cond <= VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_cond;
     ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue <= VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue;
     ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse <= VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse;
     -- Outputs
     VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output := ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output;

     -- strip_auth_tag_auth_tag_out_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0[strip_auth_tag_c_l91_c3_d8e0] LATENCY=0
     VAR_strip_auth_tag_auth_tag_out_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_strip_auth_tag_c_l91_c3_d8e0_return_output := CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0(
     VAR_uint8_array16_le_strip_auth_tag_c_l96_c41_2bae_return_output,
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_strip_auth_tag_c_l91_l97_DUPLICATE_88f6_return_output);

     -- Submodule level 5
     feedback_vars.ready_for_axis_in <= VAR_ready_for_axis_in_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output;
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue := VAR_strip_auth_tag_auth_tag_out_TRUE_INPUT_MUX_CONST_REF_RD_uint128_t_stream_t_uint128_t_stream_t_42b0_strip_auth_tag_c_l91_c3_d8e0_return_output;
     -- strip_auth_tag_axis_out_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1[strip_auth_tag_c_l66_c6_7a2c] LATENCY=0
     VAR_strip_auth_tag_axis_out_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1_strip_auth_tag_c_l66_c6_7a2c_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1(
     VAR_CONST_REF_RD_axis128_t_stream_t_axis128_early_tlast_t_axis_out_d41d_strip_auth_tag_c_l77_c32_c987_return_output,
     VAR_CONST_REF_RD_uint1_t_axis128_early_tlast_t_next_axis_out_is_tlast_d41d_strip_auth_tag_c_l85_c40_81bc_return_output,
     VAR_strip_auth_tag_axis_out_valid_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output);

     -- strip_auth_tag_auth_tag_out_MUX[strip_auth_tag_c_l91_c3_d8e0] LATENCY=0
     -- Inputs
     strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_cond <= VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_cond;
     strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue <= VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iftrue;
     strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse <= VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_iffalse;
     -- Outputs
     VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output := strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output;

     -- Submodule level 6
     VAR_strip_auth_tag_auth_tag_out := VAR_strip_auth_tag_auth_tag_out_MUX_strip_auth_tag_c_l91_c3_d8e0_return_output;
     VAR_strip_auth_tag_axis_out := VAR_strip_auth_tag_axis_out_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_60c1_strip_auth_tag_c_l66_c6_7a2c_return_output;
   end if;
 end loop;

-- Global wires driven various places in pipeline
if clk_en_internal='1' then
  module_to_global.strip_auth_tag_axis_in_ready <= VAR_strip_auth_tag_axis_in_ready;
else
  module_to_global.strip_auth_tag_axis_in_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.strip_auth_tag_axis_out <= VAR_strip_auth_tag_axis_out;
else
  module_to_global.strip_auth_tag_axis_out <= axis128_t_stream_t_NULL;
end if;
if clk_en_internal='1' then
  module_to_global.strip_auth_tag_auth_tag_out <= VAR_strip_auth_tag_auth_tag_out;
else
  module_to_global.strip_auth_tag_auth_tag_out <= uint128_t_stream_t_NULL;
end if;
end process;

end arch;
