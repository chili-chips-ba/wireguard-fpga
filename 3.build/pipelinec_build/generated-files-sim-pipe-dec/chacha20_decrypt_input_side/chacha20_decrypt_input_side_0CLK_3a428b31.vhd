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
-- Submodules: 31
entity chacha20_decrypt_input_side_0CLK_3a428b31 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in chacha20_decrypt_input_side_global_to_module_t;
 module_to_global : out chacha20_decrypt_input_side_module_to_global_t);
end chacha20_decrypt_input_side_0CLK_3a428b31;
architecture arch of chacha20_decrypt_input_side_0CLK_3a428b31 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal input_side_state : unsigned(0 downto 0) := unsigned(chacha20_decrypt_state_t_to_slv(chacha20_decrypt_state_t'left));
signal block_count : unsigned(31 downto 0) := to_unsigned(0, 32);
signal REG_COMB_input_side_state : unsigned(0 downto 0);
signal REG_COMB_block_count : unsigned(31 downto 0);


-- Type holding all locally declared (feedback) wires of the func 
type feedback_vars_t is record
  -- Feedback vars
 block_in_ready : unsigned(0 downto 0);
end record;
-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Feedback vars in the func
signal feedback_vars : feedback_vars_t;
-- Each function instance gets signals
-- BIN_OP_EQ[chacha20_decrypt_c_l58_c6_fb26]
signal BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_left : unsigned(0 downto 0);
signal BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_right : unsigned(0 downto 0);
signal BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_return_output : unsigned(0 downto 0);

-- dwidth_conv_data_in_MUX[chacha20_decrypt_c_l58_c3_2f1c]
signal dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_cond : unsigned(0 downto 0);
signal dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iftrue : axis128_t_stream_t;
signal dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iffalse : axis128_t_stream_t;
signal dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_return_output : axis128_t_stream_t;

-- axis128_to_axis512[chacha20_decrypt_c_l63_c38_8154]
signal axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_CLOCK_ENABLE : unsigned(0 downto 0);
signal axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_in : axis128_t_stream_t;
signal axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_out_ready : unsigned(0 downto 0);
signal axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_return_output : axis128_to_axis512_t;

-- BIN_OP_EQ[chacha20_decrypt_c_l68_c6_fa04]
signal BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_left : unsigned(0 downto 0);
signal BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_right : unsigned(0 downto 0);
signal BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_return_output : unsigned(0 downto 0);

-- chacha20_decrypt_axis_in_ready_MUX[chacha20_decrypt_c_l68_c3_8e7a]
signal chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_cond : unsigned(0 downto 0);
signal chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iftrue : unsigned(0 downto 0);
signal chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iffalse : unsigned(0 downto 0);
signal chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_return_output : unsigned(0 downto 0);

-- BIN_OP_EQ[chacha20_decrypt_c_l72_c6_d896]
signal BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_left : unsigned(0 downto 0);
signal BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_right : unsigned(0 downto 0);
signal BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output : unsigned(0 downto 0);

-- input_side_state_MUX[chacha20_decrypt_c_l72_c3_e425]
signal input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : unsigned(0 downto 0);

-- block_in_ready_MUX[chacha20_decrypt_c_l72_c3_e425]
signal block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
signal block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : unsigned(0 downto 0);
signal block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : unsigned(0 downto 0);
signal block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : unsigned(0 downto 0);

-- chacha20_decrypt_pipeline_in_data_axis_in_MUX[chacha20_decrypt_c_l72_c3_e425]
signal chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : axis512_t;
signal chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : axis512_t;
signal chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : axis512_t;

-- chacha20_decrypt_pipeline_in_valid_MUX[chacha20_decrypt_c_l72_c3_e425]
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : unsigned(0 downto 0);

-- block_count_MUX[chacha20_decrypt_c_l72_c3_e425]
signal block_count_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : unsigned(31 downto 0);

-- BIN_OP_OR[chacha20_decrypt_c_l74_c8_d280]
signal BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_left : unsigned(0 downto 0);
signal BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_right : unsigned(0 downto 0);
signal BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output : unsigned(0 downto 0);

-- input_side_state_MUX[chacha20_decrypt_c_l74_c5_3138]
signal input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : unsigned(0 downto 0);

-- chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX[chacha20_decrypt_c_l74_c5_3138]
signal chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : uint8_t_64;
signal chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : uint8_t_64;
signal chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : uint8_t_64;

-- chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX[chacha20_decrypt_c_l74_c5_3138]
signal chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : uint1_t_64;
signal chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : uint1_t_64;
signal chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : uint1_t_64;

-- chacha20_decrypt_pipeline_in_valid_MUX[chacha20_decrypt_c_l74_c5_3138]
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : unsigned(0 downto 0);

-- block_count_MUX[chacha20_decrypt_c_l74_c5_3138]
signal block_count_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : unsigned(31 downto 0);

-- input_side_state_MUX[chacha20_decrypt_c_l81_c7_8013]
signal input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_cond : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_return_output : unsigned(0 downto 0);

-- block_count_MUX[chacha20_decrypt_c_l81_c7_8013]
signal block_count_MUX_chacha20_decrypt_c_l81_c7_8013_cond : unsigned(0 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l81_c7_8013_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_decrypt_c_l82_c9_dc7d]
signal BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_right : unsigned(0 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_return_output : unsigned(32 downto 0);

-- BIN_OP_AND[chacha20_decrypt_c_l91_c8_1d3f]
signal BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_left : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_right : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_return_output : unsigned(0 downto 0);

-- input_side_state_MUX[chacha20_decrypt_c_l91_c5_e11c]
signal input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_cond : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output : unsigned(0 downto 0);

-- block_count_MUX[chacha20_decrypt_c_l91_c5_e11c]
signal block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_cond : unsigned(0 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output : unsigned(31 downto 0);

-- BIN_OP_PLUS[chacha20_decrypt_c_l92_c7_fed7]
signal BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_right : unsigned(0 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_return_output : unsigned(32 downto 0);

-- input_side_state_MUX[chacha20_decrypt_c_l94_c7_248b]
signal input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_cond : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_return_output : unsigned(0 downto 0);

-- block_count_MUX[chacha20_decrypt_c_l94_c7_248b]
signal block_count_MUX_chacha20_decrypt_c_l94_c7_248b_cond : unsigned(0 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l94_c7_248b_return_output : unsigned(31 downto 0);

function CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_037c( ref_toks_0 : unsigned;
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
 
  variable base : chacha20_decrypt_loop_body_in_t_stream_t; 
  variable return_output : uint8_t_64;
begin
      base.data.axis_in.tdata(0) := ref_toks_0;
      base.data.axis_in.tdata(1) := ref_toks_1;
      base.data.axis_in.tdata(2) := ref_toks_2;
      base.data.axis_in.tdata(3) := ref_toks_3;
      base.data.axis_in.tdata(4) := ref_toks_4;
      base.data.axis_in.tdata(5) := ref_toks_5;
      base.data.axis_in.tdata(6) := ref_toks_6;
      base.data.axis_in.tdata(7) := ref_toks_7;
      base.data.axis_in.tdata(8) := ref_toks_8;
      base.data.axis_in.tdata(9) := ref_toks_9;
      base.data.axis_in.tdata(10) := ref_toks_10;
      base.data.axis_in.tdata(11) := ref_toks_11;
      base.data.axis_in.tdata(12) := ref_toks_12;
      base.data.axis_in.tdata(13) := ref_toks_13;
      base.data.axis_in.tdata(14) := ref_toks_14;
      base.data.axis_in.tdata(15) := ref_toks_15;
      base.data.axis_in.tdata(16) := ref_toks_16;
      base.data.axis_in.tdata(17) := ref_toks_17;
      base.data.axis_in.tdata(18) := ref_toks_18;
      base.data.axis_in.tdata(19) := ref_toks_19;
      base.data.axis_in.tdata(20) := ref_toks_20;
      base.data.axis_in.tdata(21) := ref_toks_21;
      base.data.axis_in.tdata(22) := ref_toks_22;
      base.data.axis_in.tdata(23) := ref_toks_23;
      base.data.axis_in.tdata(24) := ref_toks_24;
      base.data.axis_in.tdata(25) := ref_toks_25;
      base.data.axis_in.tdata(26) := ref_toks_26;
      base.data.axis_in.tdata(27) := ref_toks_27;
      base.data.axis_in.tdata(28) := ref_toks_28;
      base.data.axis_in.tdata(29) := ref_toks_29;
      base.data.axis_in.tdata(30) := ref_toks_30;
      base.data.axis_in.tdata(31) := ref_toks_31;
      base.data.axis_in.tdata(32) := ref_toks_32;
      base.data.axis_in.tdata(33) := ref_toks_33;
      base.data.axis_in.tdata(34) := ref_toks_34;
      base.data.axis_in.tdata(35) := ref_toks_35;
      base.data.axis_in.tdata(36) := ref_toks_36;
      base.data.axis_in.tdata(37) := ref_toks_37;
      base.data.axis_in.tdata(38) := ref_toks_38;
      base.data.axis_in.tdata(39) := ref_toks_39;
      base.data.axis_in.tdata(40) := ref_toks_40;
      base.data.axis_in.tdata(41) := ref_toks_41;
      base.data.axis_in.tdata(42) := ref_toks_42;
      base.data.axis_in.tdata(43) := ref_toks_43;
      base.data.axis_in.tdata(44) := ref_toks_44;
      base.data.axis_in.tdata(45) := ref_toks_45;
      base.data.axis_in.tdata(46) := ref_toks_46;
      base.data.axis_in.tdata(47) := ref_toks_47;
      base.data.axis_in.tdata(48) := ref_toks_48;
      base.data.axis_in.tdata(49) := ref_toks_49;
      base.data.axis_in.tdata(50) := ref_toks_50;
      base.data.axis_in.tdata(51) := ref_toks_51;
      base.data.axis_in.tdata(52) := ref_toks_52;
      base.data.axis_in.tdata(53) := ref_toks_53;
      base.data.axis_in.tdata(54) := ref_toks_54;
      base.data.axis_in.tdata(55) := ref_toks_55;
      base.data.axis_in.tdata(56) := ref_toks_56;
      base.data.axis_in.tdata(57) := ref_toks_57;
      base.data.axis_in.tdata(58) := ref_toks_58;
      base.data.axis_in.tdata(59) := ref_toks_59;
      base.data.axis_in.tdata(60) := ref_toks_60;
      base.data.axis_in.tdata(61) := ref_toks_61;
      base.data.axis_in.tdata(62) := ref_toks_62;
      base.data.axis_in.tdata(63) := ref_toks_63;

      return_output := base.data.axis_in.tdata;
      return return_output; 
end function;

function CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_9b6c( ref_toks_0 : unsigned;
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
 ref_toks_63 : unsigned) return uint1_t_64 is
 
  variable base : chacha20_decrypt_loop_body_in_t_stream_t; 
  variable return_output : uint1_t_64;
begin
      base.data.axis_in.tkeep(0) := ref_toks_0;
      base.data.axis_in.tkeep(1) := ref_toks_1;
      base.data.axis_in.tkeep(2) := ref_toks_2;
      base.data.axis_in.tkeep(3) := ref_toks_3;
      base.data.axis_in.tkeep(4) := ref_toks_4;
      base.data.axis_in.tkeep(5) := ref_toks_5;
      base.data.axis_in.tkeep(6) := ref_toks_6;
      base.data.axis_in.tkeep(7) := ref_toks_7;
      base.data.axis_in.tkeep(8) := ref_toks_8;
      base.data.axis_in.tkeep(9) := ref_toks_9;
      base.data.axis_in.tkeep(10) := ref_toks_10;
      base.data.axis_in.tkeep(11) := ref_toks_11;
      base.data.axis_in.tkeep(12) := ref_toks_12;
      base.data.axis_in.tkeep(13) := ref_toks_13;
      base.data.axis_in.tkeep(14) := ref_toks_14;
      base.data.axis_in.tkeep(15) := ref_toks_15;
      base.data.axis_in.tkeep(16) := ref_toks_16;
      base.data.axis_in.tkeep(17) := ref_toks_17;
      base.data.axis_in.tkeep(18) := ref_toks_18;
      base.data.axis_in.tkeep(19) := ref_toks_19;
      base.data.axis_in.tkeep(20) := ref_toks_20;
      base.data.axis_in.tkeep(21) := ref_toks_21;
      base.data.axis_in.tkeep(22) := ref_toks_22;
      base.data.axis_in.tkeep(23) := ref_toks_23;
      base.data.axis_in.tkeep(24) := ref_toks_24;
      base.data.axis_in.tkeep(25) := ref_toks_25;
      base.data.axis_in.tkeep(26) := ref_toks_26;
      base.data.axis_in.tkeep(27) := ref_toks_27;
      base.data.axis_in.tkeep(28) := ref_toks_28;
      base.data.axis_in.tkeep(29) := ref_toks_29;
      base.data.axis_in.tkeep(30) := ref_toks_30;
      base.data.axis_in.tkeep(31) := ref_toks_31;
      base.data.axis_in.tkeep(32) := ref_toks_32;
      base.data.axis_in.tkeep(33) := ref_toks_33;
      base.data.axis_in.tkeep(34) := ref_toks_34;
      base.data.axis_in.tkeep(35) := ref_toks_35;
      base.data.axis_in.tkeep(36) := ref_toks_36;
      base.data.axis_in.tkeep(37) := ref_toks_37;
      base.data.axis_in.tkeep(38) := ref_toks_38;
      base.data.axis_in.tkeep(39) := ref_toks_39;
      base.data.axis_in.tkeep(40) := ref_toks_40;
      base.data.axis_in.tkeep(41) := ref_toks_41;
      base.data.axis_in.tkeep(42) := ref_toks_42;
      base.data.axis_in.tkeep(43) := ref_toks_43;
      base.data.axis_in.tkeep(44) := ref_toks_44;
      base.data.axis_in.tkeep(45) := ref_toks_45;
      base.data.axis_in.tkeep(46) := ref_toks_46;
      base.data.axis_in.tkeep(47) := ref_toks_47;
      base.data.axis_in.tkeep(48) := ref_toks_48;
      base.data.axis_in.tkeep(49) := ref_toks_49;
      base.data.axis_in.tkeep(50) := ref_toks_50;
      base.data.axis_in.tkeep(51) := ref_toks_51;
      base.data.axis_in.tkeep(52) := ref_toks_52;
      base.data.axis_in.tkeep(53) := ref_toks_53;
      base.data.axis_in.tkeep(54) := ref_toks_54;
      base.data.axis_in.tkeep(55) := ref_toks_55;
      base.data.axis_in.tkeep(56) := ref_toks_56;
      base.data.axis_in.tkeep(57) := ref_toks_57;
      base.data.axis_in.tkeep(58) := ref_toks_58;
      base.data.axis_in.tkeep(59) := ref_toks_59;
      base.data.axis_in.tkeep(60) := ref_toks_60;
      base.data.axis_in.tkeep(61) := ref_toks_61;
      base.data.axis_in.tkeep(62) := ref_toks_62;
      base.data.axis_in.tkeep(63) := ref_toks_63;

      return_output := base.data.axis_in.tkeep;
      return return_output; 
end function;

function CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_6028( ref_toks_0 : chacha20_decrypt_loop_body_in_t_stream_t;
 ref_toks_1 : uint1_t_64;
 ref_toks_2 : uint8_t_64) return axis512_t is
 
  variable base : chacha20_decrypt_loop_body_in_t_stream_t; 
  variable return_output : axis512_t;
begin
      base := ref_toks_0;
      base.data.axis_in.tkeep := ref_toks_1;
      base.data.axis_in.tdata := ref_toks_2;

      return_output := base.data.axis_in;
      return return_output; 
end function;

function CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0( ref_toks_0 : axis512_t) return unsigned is
 
  variable base : chacha20_decrypt_loop_body_in_t_stream_t; 
  variable return_output : unsigned(0 downto 0);
begin
      base.data.axis_in := ref_toks_0;

      return_output := base.data.axis_in.tlast;
      return return_output; 
end function;

function CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_9c0e( ref_toks_0 : uint8_t_32;
 ref_toks_1 : uint8_t_12;
 ref_toks_2 : unsigned;
 ref_toks_3 : axis512_t;
 ref_toks_4 : unsigned) return chacha20_decrypt_loop_body_in_t_stream_t is
 
  variable base : chacha20_decrypt_loop_body_in_t_stream_t; 
  variable return_output : chacha20_decrypt_loop_body_in_t_stream_t;
begin
      base.data.key := ref_toks_0;
      base.data.nonce := ref_toks_1;
      base.data.counter := ref_toks_2;
      base.data.axis_in := ref_toks_3;
      base.valid := ref_toks_4;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26 : 0 clocks latency
BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26 : entity work.BIN_OP_EQ_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_left,
BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_right,
BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_return_output);

-- dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c : 0 clocks latency
dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c : entity work.MUX_uint1_t_axis128_t_stream_t_axis128_t_stream_t_0CLK_de264c78 port map (
dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_cond,
dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iftrue,
dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iffalse,
dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_return_output);

-- axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154 : 0 clocks latency
axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154 : entity work.axis128_to_axis512_0CLK_c1f85885 port map (
clk,
axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_CLOCK_ENABLE,
axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_in,
axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_out_ready,
axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_return_output);

-- BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04 : 0 clocks latency
BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04 : entity work.BIN_OP_EQ_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_left,
BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_right,
BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_return_output);

-- chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a : 0 clocks latency
chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_cond,
chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iftrue,
chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iffalse,
chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_return_output);

-- BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896 : 0 clocks latency
BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896 : entity work.BIN_OP_EQ_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_left,
BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_right,
BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output);

-- input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425 : 0 clocks latency
input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425 : entity work.MUX_uint1_t_chacha20_decrypt_state_t_chacha20_decrypt_state_t_0CLK_de264c78 port map (
input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_cond,
input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue,
input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse,
input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_return_output);

-- block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425 : 0 clocks latency
block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_cond,
block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue,
block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse,
block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_return_output);

-- chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425 : 0 clocks latency
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425 : entity work.MUX_uint1_t_axis512_t_axis512_t_0CLK_de264c78 port map (
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_cond,
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue,
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse,
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_return_output);

-- chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425 : 0 clocks latency
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_cond,
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue,
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse,
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_return_output);

-- block_count_MUX_chacha20_decrypt_c_l72_c3_e425 : 0 clocks latency
block_count_MUX_chacha20_decrypt_c_l72_c3_e425 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
block_count_MUX_chacha20_decrypt_c_l72_c3_e425_cond,
block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue,
block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse,
block_count_MUX_chacha20_decrypt_c_l72_c3_e425_return_output);

-- BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280 : 0 clocks latency
BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_left,
BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_right,
BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output);

-- input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138 : 0 clocks latency
input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138 : entity work.MUX_uint1_t_chacha20_decrypt_state_t_chacha20_decrypt_state_t_0CLK_de264c78 port map (
input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_cond,
input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue,
input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse,
input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_return_output);

-- chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138 : 0 clocks latency
chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138 : entity work.MUX_uint1_t_uint8_t_64_uint8_t_64_0CLK_de264c78 port map (
chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_cond,
chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue,
chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse,
chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_return_output);

-- chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138 : 0 clocks latency
chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138 : entity work.MUX_uint1_t_uint1_t_64_uint1_t_64_0CLK_de264c78 port map (
chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_cond,
chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue,
chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse,
chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_return_output);

-- chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138 : 0 clocks latency
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_cond,
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue,
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse,
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_return_output);

-- block_count_MUX_chacha20_decrypt_c_l74_c5_3138 : 0 clocks latency
block_count_MUX_chacha20_decrypt_c_l74_c5_3138 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
block_count_MUX_chacha20_decrypt_c_l74_c5_3138_cond,
block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue,
block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse,
block_count_MUX_chacha20_decrypt_c_l74_c5_3138_return_output);

-- input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013 : 0 clocks latency
input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013 : entity work.MUX_uint1_t_chacha20_decrypt_state_t_chacha20_decrypt_state_t_0CLK_de264c78 port map (
input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_cond,
input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue,
input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse,
input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_return_output);

-- block_count_MUX_chacha20_decrypt_c_l81_c7_8013 : 0 clocks latency
block_count_MUX_chacha20_decrypt_c_l81_c7_8013 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
block_count_MUX_chacha20_decrypt_c_l81_c7_8013_cond,
block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue,
block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse,
block_count_MUX_chacha20_decrypt_c_l81_c7_8013_return_output);

-- BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d : 0 clocks latency
BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d : entity work.BIN_OP_PLUS_uint32_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_left,
BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_right,
BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_return_output);

-- BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f : 0 clocks latency
BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_left,
BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_right,
BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_return_output);

-- input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c : 0 clocks latency
input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c : entity work.MUX_uint1_t_chacha20_decrypt_state_t_chacha20_decrypt_state_t_0CLK_de264c78 port map (
input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_cond,
input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue,
input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse,
input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output);

-- block_count_MUX_chacha20_decrypt_c_l91_c5_e11c : 0 clocks latency
block_count_MUX_chacha20_decrypt_c_l91_c5_e11c : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_cond,
block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue,
block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse,
block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output);

-- BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7 : 0 clocks latency
BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7 : entity work.BIN_OP_PLUS_uint32_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_left,
BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_right,
BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_return_output);

-- input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b : 0 clocks latency
input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b : entity work.MUX_uint1_t_chacha20_decrypt_state_t_chacha20_decrypt_state_t_0CLK_de264c78 port map (
input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_cond,
input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue,
input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse,
input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_return_output);

-- block_count_MUX_chacha20_decrypt_c_l94_c7_248b : 0 clocks latency
block_count_MUX_chacha20_decrypt_c_l94_c7_248b : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
block_count_MUX_chacha20_decrypt_c_l94_c7_248b_cond,
block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue,
block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse,
block_count_MUX_chacha20_decrypt_c_l94_c7_248b_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Feedback vars
 feedback_vars,
 -- Registers
 input_side_state,
 block_count,
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_return_output,
 dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_return_output,
 axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_return_output,
 BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_return_output,
 chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_return_output,
 BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output,
 input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_return_output,
 block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_return_output,
 chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_return_output,
 chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_return_output,
 block_count_MUX_chacha20_decrypt_c_l72_c3_e425_return_output,
 BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output,
 input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_return_output,
 chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_return_output,
 chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_return_output,
 chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_return_output,
 block_count_MUX_chacha20_decrypt_c_l74_c5_3138_return_output,
 input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_return_output,
 block_count_MUX_chacha20_decrypt_c_l81_c7_8013_return_output,
 BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_return_output,
 BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_return_output,
 input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output,
 block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output,
 BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_return_output,
 input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_return_output,
 block_count_MUX_chacha20_decrypt_c_l94_c7_248b_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_ready : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in : chacha20_decrypt_loop_body_in_t_stream_t;
 variable VAR_chacha20_decrypt_key : uint8_t_32;
 variable VAR_chacha20_decrypt_nonce : uint8_t_12;
 variable VAR_chacha20_decrypt_axis_in : axis128_t_stream_t;
 variable VAR_chacha20_decrypt_pipeline_in_ready : unsigned(0 downto 0);
 variable VAR_dwidth_conv_data_in : axis128_t_stream_t;
 variable VAR_NULL_PIPELINE_IN : chacha20_decrypt_loop_body_in_t_stream_t;
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_return_output : unsigned(0 downto 0);
 variable VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iftrue : axis128_t_stream_t;
 variable VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iffalse : axis128_t_stream_t;
 variable VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_return_output : axis128_t_stream_t;
 variable VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_cond : unsigned(0 downto 0);
 variable VAR_block_in_ready : unsigned(0 downto 0);
 variable VAR_in_to_block : axis128_to_axis512_t;
 variable VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_in : axis128_t_stream_t;
 variable VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_out_ready : unsigned(0 downto 0);
 variable VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_return_output : axis128_to_axis512_t;
 variable VAR_block_in_stream : axis512_t_stream_t;
 variable VAR_CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d_chacha20_decrypt_c_l64_c40_2e0c_return_output : axis512_t_stream_t;
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iftrue : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iffalse : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_in_ready_d41d_chacha20_decrypt_c_l69_c38_709f_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
 variable VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : unsigned(0 downto 0);
 variable VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : unsigned(0 downto 0);
 variable VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : unsigned(0 downto 0);
 variable VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_6028_chacha20_decrypt_c_l72_c3_e425_return_output : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_return_output : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_cond : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_chacha20_decrypt_c_l74_c8_2843_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : uint8_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_TRUE_INPUT_MUX_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_037c_chacha20_decrypt_c_l74_c5_3138_return_output : uint8_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : uint8_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_d41d_chacha20_decrypt_c_l74_c5_3138_return_output : uint8_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : uint8_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : uint1_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_9b6c_chacha20_decrypt_c_l74_c5_3138_return_output : uint1_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : uint1_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_d41d_chacha20_decrypt_c_l74_c5_3138_return_output : uint1_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_return_output : uint1_t_64;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l74_c5_3138_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_return_output : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_cond : unsigned(0 downto 0);
 variable VAR_ARRAY_SET_i : unsigned(31 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_cond : unsigned(0 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue : unsigned(31 downto 0);
 variable VAR_block_count_chacha20_decrypt_c_l82_c9_9061 : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_return_output : unsigned(32 downto 0);
 variable VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d_chacha20_decrypt_c_l88_c49_27a1_return_output : axis512_t;
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_cond : unsigned(0 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_return_output : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_cond : unsigned(0 downto 0);
 variable VAR_block_count_chacha20_decrypt_c_l92_c7_f3fa : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_return_output : unsigned(32 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0_chacha20_decrypt_c_l94_c10_54d2_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_cond : unsigned(0 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_cond : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_9c0e_chacha20_decrypt_c_l40_c6_cee1_return_output : chacha20_decrypt_loop_body_in_t_stream_t;
 variable VAR_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l89_l74_DUPLICATE_d14a_return_output : unsigned(0 downto 0);
 -- State registers comb logic variables
variable REG_VAR_input_side_state : unsigned(0 downto 0);
variable REG_VAR_block_count : unsigned(31 downto 0);
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_input_side_state := input_side_state;
  REG_VAR_block_count := block_count;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_right := unsigned(chacha20_decrypt_state_t_to_slv(PLAINTEXT));
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_right := to_unsigned(1, 1);
     VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue := to_unsigned(0, 32);
     VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iffalse := axis128_t_stream_t_NULL;
     VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iffalse := to_unsigned(0, 1);
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_right := to_unsigned(1, 1);
     VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue := unsigned(chacha20_decrypt_state_t_to_slv(PLAINTEXT));
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue := to_unsigned(1, 1);
     VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue := to_unsigned(0, 1);
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_right := unsigned(chacha20_decrypt_state_t_to_slv(PLAINTEXT));
     VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue := unsigned(chacha20_decrypt_state_t_to_slv(POLY_KEY));
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_right := unsigned(chacha20_decrypt_state_t_to_slv(POLY_KEY));
     -- chacha20_decrypt_pipeline_in_data_axis_in_tdata_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_d41d[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_d41d_chacha20_decrypt_c_l74_c5_3138_return_output := chacha20_decrypt_loop_body_in_t_stream_t_NULL.data.axis_in.tdata;

     -- chacha20_decrypt_pipeline_in_data_axis_in_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_9b6c[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_9b6c_chacha20_decrypt_c_l74_c5_3138_return_output := CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_9b6c(
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1),
     to_unsigned(1, 1));

     -- chacha20_decrypt_pipeline_in_data_axis_in_tdata_TRUE_INPUT_MUX_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_037c[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_TRUE_INPUT_MUX_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_037c_chacha20_decrypt_c_l74_c5_3138_return_output := CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_037c(
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8),
     to_unsigned(0, 8));

     -- chacha20_decrypt_pipeline_in_data_axis_in_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_d41d[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_d41d_chacha20_decrypt_c_l74_c5_3138_return_output := chacha20_decrypt_loop_body_in_t_stream_t_NULL.data.axis_in.tkeep;

     -- chacha20_decrypt_pipeline_in_valid_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     VAR_chacha20_decrypt_pipeline_in_valid_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l74_c5_3138_return_output := chacha20_decrypt_loop_body_in_t_stream_t_NULL.valid;

     -- Submodule level 1
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse := VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_FALSE_INPUT_MUX_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_d41d_chacha20_decrypt_c_l74_c5_3138_return_output;
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse := VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_d41d_chacha20_decrypt_c_l74_c5_3138_return_output;
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue := VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_TRUE_INPUT_MUX_CONST_REF_RD_uint1_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tkeep_9b6c_chacha20_decrypt_c_l74_c5_3138_return_output;
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse := VAR_chacha20_decrypt_pipeline_in_valid_FALSE_INPUT_MUX_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l74_c5_3138_return_output;
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue := VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_TRUE_INPUT_MUX_CONST_REF_RD_uint8_t_64_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tdata_037c_chacha20_decrypt_c_l74_c5_3138_return_output;
 -- Reads from global variables
     VAR_chacha20_decrypt_key := global_to_module.chacha20_decrypt_key;
     VAR_chacha20_decrypt_nonce := global_to_module.chacha20_decrypt_nonce;
     VAR_chacha20_decrypt_axis_in := global_to_module.chacha20_decrypt_axis_in;
     VAR_chacha20_decrypt_pipeline_in_ready := global_to_module.chacha20_decrypt_pipeline_in_ready;
     -- Submodule level 0
     VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_cond := VAR_chacha20_decrypt_pipeline_in_ready;
     VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_right := VAR_chacha20_decrypt_pipeline_in_ready;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_cond := VAR_chacha20_decrypt_pipeline_in_ready;
     VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse := VAR_chacha20_decrypt_pipeline_in_ready;
     VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iftrue := VAR_chacha20_decrypt_axis_in;
     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d[chacha20_decrypt_c_l74_c8_2843] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_chacha20_decrypt_c_l74_c8_2843_return_output := VAR_chacha20_decrypt_axis_in.valid;

     -- Submodule level 1
     VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_left := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_chacha20_decrypt_c_l74_c8_2843_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_left := block_count;
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_left := block_count;
     VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse := block_count;
     VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse := block_count;
     VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse := block_count;
     VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_out_ready := feedback_vars.block_in_ready;
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_left := input_side_state;
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_left := input_side_state;
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_left := input_side_state;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse := input_side_state;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse := input_side_state;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse := input_side_state;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse := input_side_state;
     -- BIN_OP_PLUS[chacha20_decrypt_c_l82_c9_dc7d] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_left <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_left;
     BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_right <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_return_output := BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_return_output;

     -- input_side_state_MUX[chacha20_decrypt_c_l81_c7_8013] LATENCY=0
     -- Inputs
     input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_cond <= VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_cond;
     input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue <= VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue;
     input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse <= VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse;
     -- Outputs
     VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_return_output := input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_return_output;

     -- BIN_OP_EQ[chacha20_decrypt_c_l72_c6_d896] LATENCY=0
     -- Inputs
     BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_left <= VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_left;
     BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_right <= VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_right;
     -- Outputs
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output := BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output;

     -- BIN_OP_PLUS[chacha20_decrypt_c_l92_c7_fed7] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_left <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_left;
     BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_right <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_return_output := BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_return_output;

     -- BIN_OP_EQ[chacha20_decrypt_c_l58_c6_fb26] LATENCY=0
     -- Inputs
     BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_left <= VAR_BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_left;
     BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_right <= VAR_BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_right;
     -- Outputs
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_return_output := BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_return_output;

     -- BIN_OP_EQ[chacha20_decrypt_c_l68_c6_fa04] LATENCY=0
     -- Inputs
     BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_left <= VAR_BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_left;
     BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_right <= VAR_BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_right;
     -- Outputs
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_return_output := BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_return_output;

     -- Submodule level 1
     VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l58_c6_fb26_return_output;
     VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l68_c6_fa04_return_output;
     VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output;
     VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output;
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output;
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l72_c6_d896_return_output;
     VAR_block_count_chacha20_decrypt_c_l82_c9_9061 := resize(VAR_BIN_OP_PLUS_chacha20_decrypt_c_l82_c9_dc7d_return_output, 32);
     VAR_block_count_chacha20_decrypt_c_l92_c7_f3fa := resize(VAR_BIN_OP_PLUS_chacha20_decrypt_c_l92_c7_fed7_return_output, 32);
     VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue := VAR_input_side_state_MUX_chacha20_decrypt_c_l81_c7_8013_return_output;
     VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue := VAR_block_count_chacha20_decrypt_c_l82_c9_9061;
     VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse := VAR_block_count_chacha20_decrypt_c_l92_c7_f3fa;
     -- block_count_MUX[chacha20_decrypt_c_l81_c7_8013] LATENCY=0
     -- Inputs
     block_count_MUX_chacha20_decrypt_c_l81_c7_8013_cond <= VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_cond;
     block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue <= VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iftrue;
     block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse <= VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_iffalse;
     -- Outputs
     VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_return_output := block_count_MUX_chacha20_decrypt_c_l81_c7_8013_return_output;

     -- block_in_ready_MUX[chacha20_decrypt_c_l72_c3_e425] LATENCY=0
     -- Inputs
     block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_cond <= VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_cond;
     block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue <= VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue;
     block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse <= VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse;
     -- Outputs
     VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_return_output := block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_return_output;

     -- dwidth_conv_data_in_MUX[chacha20_decrypt_c_l58_c3_2f1c] LATENCY=0
     -- Inputs
     dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_cond <= VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_cond;
     dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iftrue <= VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iftrue;
     dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iffalse <= VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_iffalse;
     -- Outputs
     VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_return_output := dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_return_output;

     -- Submodule level 2
     VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue := VAR_block_count_MUX_chacha20_decrypt_c_l81_c7_8013_return_output;
     feedback_vars.block_in_ready <= VAR_block_in_ready_MUX_chacha20_decrypt_c_l72_c3_e425_return_output;
     VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_in := VAR_dwidth_conv_data_in_MUX_chacha20_decrypt_c_l58_c3_2f1c_return_output;
     -- axis128_to_axis512[chacha20_decrypt_c_l63_c38_8154] LATENCY=0
     -- Clock enable
     axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_CLOCK_ENABLE <= VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_CLOCK_ENABLE;
     -- Inputs
     axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_in <= VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_in;
     axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_out_ready <= VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_axis_out_ready;
     -- Outputs
     VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_return_output := axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_return_output;

     -- Submodule level 3
     -- CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d[chacha20_decrypt_c_l64_c40_2e0c] LATENCY=0
     VAR_CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d_chacha20_decrypt_c_l64_c40_2e0c_return_output := VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_return_output.axis_out;

     -- CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_in_ready_d41d[chacha20_decrypt_c_l69_c38_709f] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_in_ready_d41d_chacha20_decrypt_c_l69_c38_709f_return_output := VAR_axis128_to_axis512_chacha20_decrypt_c_l63_c38_8154_return_output.axis_in_ready;

     -- Submodule level 4
     VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iftrue := VAR_CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_in_ready_d41d_chacha20_decrypt_c_l69_c38_709f_return_output;
     -- chacha20_decrypt_axis_in_ready_MUX[chacha20_decrypt_c_l68_c3_8e7a] LATENCY=0
     -- Inputs
     chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_cond <= VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_cond;
     chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iftrue <= VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iftrue;
     chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iffalse <= VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_return_output := chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_return_output;

     -- CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d[chacha20_decrypt_c_l88_c49_27a1] LATENCY=0
     VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d_chacha20_decrypt_c_l88_c49_27a1_return_output := VAR_CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d_chacha20_decrypt_c_l64_c40_2e0c_return_output.data;

     -- CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l89_l74_DUPLICATE_d14a LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l89_l74_DUPLICATE_d14a_return_output := VAR_CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d_chacha20_decrypt_c_l64_c40_2e0c_return_output.valid;

     -- Submodule level 5
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse := VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d_chacha20_decrypt_c_l88_c49_27a1_return_output;
     VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_left := VAR_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l89_l74_DUPLICATE_d14a_return_output;
     VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_right := VAR_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l89_l74_DUPLICATE_d14a_return_output;
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse := VAR_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l89_l74_DUPLICATE_d14a_return_output;
     VAR_chacha20_decrypt_axis_in_ready := VAR_chacha20_decrypt_axis_in_ready_MUX_chacha20_decrypt_c_l68_c3_8e7a_return_output;
     -- BIN_OP_OR[chacha20_decrypt_c_l74_c8_d280] LATENCY=0
     -- Inputs
     BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_left <= VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_left;
     BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_right <= VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_right;
     -- Outputs
     VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output := BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output;

     -- BIN_OP_AND[chacha20_decrypt_c_l91_c8_1d3f] LATENCY=0
     -- Inputs
     BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_left <= VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_left;
     BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_right <= VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_right;
     -- Outputs
     VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_return_output := BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_return_output;

     -- CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0[chacha20_decrypt_c_l94_c10_54d2] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0_chacha20_decrypt_c_l94_c10_54d2_return_output := CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0(
     VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d_chacha20_decrypt_c_l88_c49_27a1_return_output);

     -- Submodule level 6
     VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_cond := VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_cond := VAR_BIN_OP_AND_chacha20_decrypt_c_l91_c8_1d3f_return_output;
     VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_cond := VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output;
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_cond := VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output;
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_cond := VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output;
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_cond := VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_cond := VAR_BIN_OP_OR_chacha20_decrypt_c_l74_c8_d280_return_output;
     VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_cond := VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0_chacha20_decrypt_c_l94_c10_54d2_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_cond := VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0_chacha20_decrypt_c_l94_c10_54d2_return_output;
     -- block_count_MUX[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     -- Inputs
     block_count_MUX_chacha20_decrypt_c_l74_c5_3138_cond <= VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_cond;
     block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue <= VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue;
     block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse <= VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse;
     -- Outputs
     VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_return_output := block_count_MUX_chacha20_decrypt_c_l74_c5_3138_return_output;

     -- block_count_MUX[chacha20_decrypt_c_l94_c7_248b] LATENCY=0
     -- Inputs
     block_count_MUX_chacha20_decrypt_c_l94_c7_248b_cond <= VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_cond;
     block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue <= VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue;
     block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse <= VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse;
     -- Outputs
     VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_return_output := block_count_MUX_chacha20_decrypt_c_l94_c7_248b_return_output;

     -- input_side_state_MUX[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     -- Inputs
     input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_cond <= VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_cond;
     input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue <= VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue;
     input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse <= VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse;
     -- Outputs
     VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_return_output := input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_return_output;

     -- chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     -- Inputs
     chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_cond <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_cond;
     chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue;
     chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_return_output := chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_return_output;

     -- chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     -- Inputs
     chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_cond <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_cond;
     chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue;
     chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_return_output := chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_return_output;

     -- chacha20_decrypt_pipeline_in_valid_MUX[chacha20_decrypt_c_l74_c5_3138] LATENCY=0
     -- Inputs
     chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_cond <= VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_cond;
     chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue <= VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iftrue;
     chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse <= VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_return_output := chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_return_output;

     -- input_side_state_MUX[chacha20_decrypt_c_l94_c7_248b] LATENCY=0
     -- Inputs
     input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_cond <= VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_cond;
     input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue <= VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iftrue;
     input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse <= VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_iffalse;
     -- Outputs
     VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_return_output := input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_return_output;

     -- Submodule level 7
     VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue := VAR_block_count_MUX_chacha20_decrypt_c_l74_c5_3138_return_output;
     VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue := VAR_block_count_MUX_chacha20_decrypt_c_l94_c7_248b_return_output;
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue := VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l74_c5_3138_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue := VAR_input_side_state_MUX_chacha20_decrypt_c_l74_c5_3138_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue := VAR_input_side_state_MUX_chacha20_decrypt_c_l94_c7_248b_return_output;
     -- chacha20_decrypt_pipeline_in_valid_MUX[chacha20_decrypt_c_l72_c3_e425] LATENCY=0
     -- Inputs
     chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_cond <= VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_cond;
     chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue <= VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue;
     chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse <= VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_return_output := chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_return_output;

     -- block_count_MUX[chacha20_decrypt_c_l91_c5_e11c] LATENCY=0
     -- Inputs
     block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_cond <= VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_cond;
     block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue <= VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue;
     block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse <= VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse;
     -- Outputs
     VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output := block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output;

     -- chacha20_decrypt_pipeline_in_data_axis_in_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_6028[chacha20_decrypt_c_l72_c3_e425] LATENCY=0
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_6028_chacha20_decrypt_c_l72_c3_e425_return_output := CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_6028(
     chacha20_decrypt_loop_body_in_t_stream_t_NULL,
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tkeep_MUX_chacha20_decrypt_c_l74_c5_3138_return_output,
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_tdata_MUX_chacha20_decrypt_c_l74_c5_3138_return_output);

     -- input_side_state_MUX[chacha20_decrypt_c_l91_c5_e11c] LATENCY=0
     -- Inputs
     input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_cond <= VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_cond;
     input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue <= VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iftrue;
     input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse <= VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_iffalse;
     -- Outputs
     VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output := input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output;

     -- Submodule level 8
     VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse := VAR_block_count_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output;
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue := VAR_chacha20_decrypt_pipeline_in_data_axis_in_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_6028_chacha20_decrypt_c_l72_c3_e425_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse := VAR_input_side_state_MUX_chacha20_decrypt_c_l91_c5_e11c_return_output;
     -- block_count_MUX[chacha20_decrypt_c_l72_c3_e425] LATENCY=0
     -- Inputs
     block_count_MUX_chacha20_decrypt_c_l72_c3_e425_cond <= VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_cond;
     block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue <= VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue;
     block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse <= VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse;
     -- Outputs
     VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_return_output := block_count_MUX_chacha20_decrypt_c_l72_c3_e425_return_output;

     -- chacha20_decrypt_pipeline_in_data_axis_in_MUX[chacha20_decrypt_c_l72_c3_e425] LATENCY=0
     -- Inputs
     chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_cond <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_cond;
     chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue;
     chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_return_output := chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_return_output;

     -- input_side_state_MUX[chacha20_decrypt_c_l72_c3_e425] LATENCY=0
     -- Inputs
     input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_cond <= VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_cond;
     input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue <= VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iftrue;
     input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse <= VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_iffalse;
     -- Outputs
     VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_return_output := input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_return_output;

     -- Submodule level 9
     REG_VAR_block_count := VAR_block_count_MUX_chacha20_decrypt_c_l72_c3_e425_return_output;
     REG_VAR_input_side_state := VAR_input_side_state_MUX_chacha20_decrypt_c_l72_c3_e425_return_output;
     -- chacha20_decrypt_pipeline_in_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_9c0e[chacha20_decrypt_c_l40_c6_cee1] LATENCY=0
     VAR_chacha20_decrypt_pipeline_in_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_9c0e_chacha20_decrypt_c_l40_c6_cee1_return_output := CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_9c0e(
     VAR_chacha20_decrypt_key,
     VAR_chacha20_decrypt_nonce,
     block_count,
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l72_c3_e425_return_output,
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l72_c3_e425_return_output);

     -- Submodule level 10
     VAR_chacha20_decrypt_pipeline_in := VAR_chacha20_decrypt_pipeline_in_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_9c0e_chacha20_decrypt_c_l40_c6_cee1_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_input_side_state <= REG_VAR_input_side_state;
REG_COMB_block_count <= REG_VAR_block_count;
-- Global wires driven various places in pipeline
if clk_en_internal='1' then
  module_to_global.chacha20_decrypt_axis_in_ready <= VAR_chacha20_decrypt_axis_in_ready;
else
  module_to_global.chacha20_decrypt_axis_in_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.chacha20_decrypt_pipeline_in <= VAR_chacha20_decrypt_pipeline_in;
else
  module_to_global.chacha20_decrypt_pipeline_in <= chacha20_decrypt_loop_body_in_t_stream_t_NULL;
end if;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     input_side_state <= REG_COMB_input_side_state;
     block_count <= REG_COMB_block_count;
 end if;
 end if;
end process;

end arch;
