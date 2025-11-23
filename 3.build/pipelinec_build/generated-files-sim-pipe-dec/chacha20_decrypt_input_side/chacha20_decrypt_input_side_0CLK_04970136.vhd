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
-- Submodules: 19
entity chacha20_decrypt_input_side_0CLK_04970136 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in chacha20_decrypt_input_side_global_to_module_t;
 module_to_global : out chacha20_decrypt_input_side_module_to_global_t);
end chacha20_decrypt_input_side_0CLK_04970136;
architecture arch of chacha20_decrypt_input_side_0CLK_04970136 is
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
-- axis128_to_axis512[chacha20_decrypt_c_l45_c38_1acd]
signal axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_CLOCK_ENABLE : unsigned(0 downto 0);
signal axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_in : axis128_t_stream_t;
signal axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_out_ready : unsigned(0 downto 0);
signal axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_return_output : axis128_to_axis512_t;

-- BIN_OP_EQ[chacha20_decrypt_c_l61_c6_84b7]
signal BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_left : unsigned(0 downto 0);
signal BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_right : unsigned(0 downto 0);
signal BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output : unsigned(0 downto 0);

-- block_count_MUX[chacha20_decrypt_c_l61_c3_e815]
signal block_count_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : unsigned(31 downto 0);

-- input_side_state_MUX[chacha20_decrypt_c_l61_c3_e815]
signal input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : unsigned(0 downto 0);

-- block_in_ready_MUX[chacha20_decrypt_c_l61_c3_e815]
signal block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
signal block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : unsigned(0 downto 0);
signal block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : unsigned(0 downto 0);
signal block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : unsigned(0 downto 0);

-- chacha20_decrypt_pipeline_in_data_axis_in_MUX[chacha20_decrypt_c_l61_c3_e815]
signal chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : axis512_t;
signal chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : axis512_t;
signal chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : axis512_t;

-- chacha20_decrypt_pipeline_in_valid_MUX[chacha20_decrypt_c_l61_c3_e815]
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : unsigned(0 downto 0);

-- block_count_MUX[chacha20_decrypt_c_l71_c5_2106]
signal block_count_MUX_chacha20_decrypt_c_l71_c5_2106_cond : unsigned(0 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l71_c5_2106_return_output : unsigned(31 downto 0);

-- input_side_state_MUX[chacha20_decrypt_c_l71_c5_2106]
signal input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_cond : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_return_output : unsigned(0 downto 0);

-- BIN_OP_PLUS[chacha20_decrypt_c_l72_c7_e40e]
signal BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_right : unsigned(0 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_return_output : unsigned(32 downto 0);

-- BIN_OP_AND[chacha20_decrypt_c_l80_c8_134f]
signal BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_left : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_right : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_return_output : unsigned(0 downto 0);

-- block_count_MUX[chacha20_decrypt_c_l80_c5_d206]
signal block_count_MUX_chacha20_decrypt_c_l80_c5_d206_cond : unsigned(0 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l80_c5_d206_return_output : unsigned(31 downto 0);

-- input_side_state_MUX[chacha20_decrypt_c_l80_c5_d206]
signal input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_cond : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_return_output : unsigned(0 downto 0);

-- BIN_OP_PLUS[chacha20_decrypt_c_l81_c7_ae36]
signal BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_left : unsigned(31 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_right : unsigned(0 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_return_output : unsigned(32 downto 0);

-- block_count_MUX[chacha20_decrypt_c_l83_c7_f750]
signal block_count_MUX_chacha20_decrypt_c_l83_c7_f750_cond : unsigned(0 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse : unsigned(31 downto 0);
signal block_count_MUX_chacha20_decrypt_c_l83_c7_f750_return_output : unsigned(31 downto 0);

-- input_side_state_MUX[chacha20_decrypt_c_l83_c7_f750]
signal input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_cond : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse : unsigned(0 downto 0);
signal input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_return_output : unsigned(0 downto 0);

function CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_baed( ref_toks_0 : chacha20_decrypt_loop_body_in_t_stream_t;
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
 ref_toks_63 : unsigned;
 ref_toks_64 : unsigned;
 ref_toks_65 : unsigned;
 ref_toks_66 : unsigned;
 ref_toks_67 : unsigned;
 ref_toks_68 : unsigned;
 ref_toks_69 : unsigned;
 ref_toks_70 : unsigned;
 ref_toks_71 : unsigned;
 ref_toks_72 : unsigned;
 ref_toks_73 : unsigned;
 ref_toks_74 : unsigned;
 ref_toks_75 : unsigned;
 ref_toks_76 : unsigned;
 ref_toks_77 : unsigned;
 ref_toks_78 : unsigned;
 ref_toks_79 : unsigned;
 ref_toks_80 : unsigned;
 ref_toks_81 : unsigned;
 ref_toks_82 : unsigned;
 ref_toks_83 : unsigned;
 ref_toks_84 : unsigned;
 ref_toks_85 : unsigned;
 ref_toks_86 : unsigned;
 ref_toks_87 : unsigned;
 ref_toks_88 : unsigned;
 ref_toks_89 : unsigned;
 ref_toks_90 : unsigned;
 ref_toks_91 : unsigned;
 ref_toks_92 : unsigned;
 ref_toks_93 : unsigned;
 ref_toks_94 : unsigned;
 ref_toks_95 : unsigned;
 ref_toks_96 : unsigned;
 ref_toks_97 : unsigned;
 ref_toks_98 : unsigned;
 ref_toks_99 : unsigned;
 ref_toks_100 : unsigned;
 ref_toks_101 : unsigned;
 ref_toks_102 : unsigned;
 ref_toks_103 : unsigned;
 ref_toks_104 : unsigned;
 ref_toks_105 : unsigned;
 ref_toks_106 : unsigned;
 ref_toks_107 : unsigned;
 ref_toks_108 : unsigned;
 ref_toks_109 : unsigned;
 ref_toks_110 : unsigned;
 ref_toks_111 : unsigned;
 ref_toks_112 : unsigned;
 ref_toks_113 : unsigned;
 ref_toks_114 : unsigned;
 ref_toks_115 : unsigned;
 ref_toks_116 : unsigned;
 ref_toks_117 : unsigned;
 ref_toks_118 : unsigned;
 ref_toks_119 : unsigned;
 ref_toks_120 : unsigned;
 ref_toks_121 : unsigned;
 ref_toks_122 : unsigned;
 ref_toks_123 : unsigned;
 ref_toks_124 : unsigned;
 ref_toks_125 : unsigned;
 ref_toks_126 : unsigned;
 ref_toks_127 : unsigned;
 ref_toks_128 : unsigned) return axis512_t is
 
  variable base : chacha20_decrypt_loop_body_in_t_stream_t; 
  variable return_output : axis512_t;
begin
      base := ref_toks_0;
      base.data.axis_in.tdata(0) := ref_toks_1;
      base.data.axis_in.tdata(1) := ref_toks_2;
      base.data.axis_in.tdata(2) := ref_toks_3;
      base.data.axis_in.tdata(3) := ref_toks_4;
      base.data.axis_in.tdata(4) := ref_toks_5;
      base.data.axis_in.tdata(5) := ref_toks_6;
      base.data.axis_in.tdata(6) := ref_toks_7;
      base.data.axis_in.tdata(7) := ref_toks_8;
      base.data.axis_in.tdata(8) := ref_toks_9;
      base.data.axis_in.tdata(9) := ref_toks_10;
      base.data.axis_in.tdata(10) := ref_toks_11;
      base.data.axis_in.tdata(11) := ref_toks_12;
      base.data.axis_in.tdata(12) := ref_toks_13;
      base.data.axis_in.tdata(13) := ref_toks_14;
      base.data.axis_in.tdata(14) := ref_toks_15;
      base.data.axis_in.tdata(15) := ref_toks_16;
      base.data.axis_in.tdata(16) := ref_toks_17;
      base.data.axis_in.tdata(17) := ref_toks_18;
      base.data.axis_in.tdata(18) := ref_toks_19;
      base.data.axis_in.tdata(19) := ref_toks_20;
      base.data.axis_in.tdata(20) := ref_toks_21;
      base.data.axis_in.tdata(21) := ref_toks_22;
      base.data.axis_in.tdata(22) := ref_toks_23;
      base.data.axis_in.tdata(23) := ref_toks_24;
      base.data.axis_in.tdata(24) := ref_toks_25;
      base.data.axis_in.tdata(25) := ref_toks_26;
      base.data.axis_in.tdata(26) := ref_toks_27;
      base.data.axis_in.tdata(27) := ref_toks_28;
      base.data.axis_in.tdata(28) := ref_toks_29;
      base.data.axis_in.tdata(29) := ref_toks_30;
      base.data.axis_in.tdata(30) := ref_toks_31;
      base.data.axis_in.tdata(31) := ref_toks_32;
      base.data.axis_in.tdata(32) := ref_toks_33;
      base.data.axis_in.tdata(33) := ref_toks_34;
      base.data.axis_in.tdata(34) := ref_toks_35;
      base.data.axis_in.tdata(35) := ref_toks_36;
      base.data.axis_in.tdata(36) := ref_toks_37;
      base.data.axis_in.tdata(37) := ref_toks_38;
      base.data.axis_in.tdata(38) := ref_toks_39;
      base.data.axis_in.tdata(39) := ref_toks_40;
      base.data.axis_in.tdata(40) := ref_toks_41;
      base.data.axis_in.tdata(41) := ref_toks_42;
      base.data.axis_in.tdata(42) := ref_toks_43;
      base.data.axis_in.tdata(43) := ref_toks_44;
      base.data.axis_in.tdata(44) := ref_toks_45;
      base.data.axis_in.tdata(45) := ref_toks_46;
      base.data.axis_in.tdata(46) := ref_toks_47;
      base.data.axis_in.tdata(47) := ref_toks_48;
      base.data.axis_in.tdata(48) := ref_toks_49;
      base.data.axis_in.tdata(49) := ref_toks_50;
      base.data.axis_in.tdata(50) := ref_toks_51;
      base.data.axis_in.tdata(51) := ref_toks_52;
      base.data.axis_in.tdata(52) := ref_toks_53;
      base.data.axis_in.tdata(53) := ref_toks_54;
      base.data.axis_in.tdata(54) := ref_toks_55;
      base.data.axis_in.tdata(55) := ref_toks_56;
      base.data.axis_in.tdata(56) := ref_toks_57;
      base.data.axis_in.tdata(57) := ref_toks_58;
      base.data.axis_in.tdata(58) := ref_toks_59;
      base.data.axis_in.tdata(59) := ref_toks_60;
      base.data.axis_in.tdata(60) := ref_toks_61;
      base.data.axis_in.tdata(61) := ref_toks_62;
      base.data.axis_in.tdata(62) := ref_toks_63;
      base.data.axis_in.tdata(63) := ref_toks_64;
      base.data.axis_in.tkeep(0) := ref_toks_65;
      base.data.axis_in.tkeep(1) := ref_toks_66;
      base.data.axis_in.tkeep(2) := ref_toks_67;
      base.data.axis_in.tkeep(3) := ref_toks_68;
      base.data.axis_in.tkeep(4) := ref_toks_69;
      base.data.axis_in.tkeep(5) := ref_toks_70;
      base.data.axis_in.tkeep(6) := ref_toks_71;
      base.data.axis_in.tkeep(7) := ref_toks_72;
      base.data.axis_in.tkeep(8) := ref_toks_73;
      base.data.axis_in.tkeep(9) := ref_toks_74;
      base.data.axis_in.tkeep(10) := ref_toks_75;
      base.data.axis_in.tkeep(11) := ref_toks_76;
      base.data.axis_in.tkeep(12) := ref_toks_77;
      base.data.axis_in.tkeep(13) := ref_toks_78;
      base.data.axis_in.tkeep(14) := ref_toks_79;
      base.data.axis_in.tkeep(15) := ref_toks_80;
      base.data.axis_in.tkeep(16) := ref_toks_81;
      base.data.axis_in.tkeep(17) := ref_toks_82;
      base.data.axis_in.tkeep(18) := ref_toks_83;
      base.data.axis_in.tkeep(19) := ref_toks_84;
      base.data.axis_in.tkeep(20) := ref_toks_85;
      base.data.axis_in.tkeep(21) := ref_toks_86;
      base.data.axis_in.tkeep(22) := ref_toks_87;
      base.data.axis_in.tkeep(23) := ref_toks_88;
      base.data.axis_in.tkeep(24) := ref_toks_89;
      base.data.axis_in.tkeep(25) := ref_toks_90;
      base.data.axis_in.tkeep(26) := ref_toks_91;
      base.data.axis_in.tkeep(27) := ref_toks_92;
      base.data.axis_in.tkeep(28) := ref_toks_93;
      base.data.axis_in.tkeep(29) := ref_toks_94;
      base.data.axis_in.tkeep(30) := ref_toks_95;
      base.data.axis_in.tkeep(31) := ref_toks_96;
      base.data.axis_in.tkeep(32) := ref_toks_97;
      base.data.axis_in.tkeep(33) := ref_toks_98;
      base.data.axis_in.tkeep(34) := ref_toks_99;
      base.data.axis_in.tkeep(35) := ref_toks_100;
      base.data.axis_in.tkeep(36) := ref_toks_101;
      base.data.axis_in.tkeep(37) := ref_toks_102;
      base.data.axis_in.tkeep(38) := ref_toks_103;
      base.data.axis_in.tkeep(39) := ref_toks_104;
      base.data.axis_in.tkeep(40) := ref_toks_105;
      base.data.axis_in.tkeep(41) := ref_toks_106;
      base.data.axis_in.tkeep(42) := ref_toks_107;
      base.data.axis_in.tkeep(43) := ref_toks_108;
      base.data.axis_in.tkeep(44) := ref_toks_109;
      base.data.axis_in.tkeep(45) := ref_toks_110;
      base.data.axis_in.tkeep(46) := ref_toks_111;
      base.data.axis_in.tkeep(47) := ref_toks_112;
      base.data.axis_in.tkeep(48) := ref_toks_113;
      base.data.axis_in.tkeep(49) := ref_toks_114;
      base.data.axis_in.tkeep(50) := ref_toks_115;
      base.data.axis_in.tkeep(51) := ref_toks_116;
      base.data.axis_in.tkeep(52) := ref_toks_117;
      base.data.axis_in.tkeep(53) := ref_toks_118;
      base.data.axis_in.tkeep(54) := ref_toks_119;
      base.data.axis_in.tkeep(55) := ref_toks_120;
      base.data.axis_in.tkeep(56) := ref_toks_121;
      base.data.axis_in.tkeep(57) := ref_toks_122;
      base.data.axis_in.tkeep(58) := ref_toks_123;
      base.data.axis_in.tkeep(59) := ref_toks_124;
      base.data.axis_in.tkeep(60) := ref_toks_125;
      base.data.axis_in.tkeep(61) := ref_toks_126;
      base.data.axis_in.tkeep(62) := ref_toks_127;
      base.data.axis_in.tkeep(63) := ref_toks_128;

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

function CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_8db4( ref_toks_0 : uint8_t_32;
 ref_toks_1 : uint8_t_12;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned;
 ref_toks_4 : axis512_t) return chacha20_decrypt_loop_body_in_t_stream_t is
 
  variable base : chacha20_decrypt_loop_body_in_t_stream_t; 
  variable return_output : chacha20_decrypt_loop_body_in_t_stream_t;
begin
      base.data.key := ref_toks_0;
      base.data.nonce := ref_toks_1;
      base.data.counter := ref_toks_2;
      base.valid := ref_toks_3;
      base.data.axis_in := ref_toks_4;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd : 0 clocks latency
axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd : entity work.axis128_to_axis512_0CLK_c1f85885 port map (
clk,
axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_CLOCK_ENABLE,
axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_in,
axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_out_ready,
axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_return_output);

-- BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7 : 0 clocks latency
BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7 : entity work.BIN_OP_EQ_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_left,
BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_right,
BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output);

-- block_count_MUX_chacha20_decrypt_c_l61_c3_e815 : 0 clocks latency
block_count_MUX_chacha20_decrypt_c_l61_c3_e815 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
block_count_MUX_chacha20_decrypt_c_l61_c3_e815_cond,
block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue,
block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse,
block_count_MUX_chacha20_decrypt_c_l61_c3_e815_return_output);

-- input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815 : 0 clocks latency
input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815 : entity work.MUX_uint1_t_chacha20_decrypt_state_t_chacha20_decrypt_state_t_0CLK_de264c78 port map (
input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_cond,
input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue,
input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse,
input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_return_output);

-- block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815 : 0 clocks latency
block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_cond,
block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue,
block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse,
block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_return_output);

-- chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815 : 0 clocks latency
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815 : entity work.MUX_uint1_t_axis512_t_axis512_t_0CLK_de264c78 port map (
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_cond,
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue,
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse,
chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_return_output);

-- chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815 : 0 clocks latency
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_cond,
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue,
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse,
chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_return_output);

-- block_count_MUX_chacha20_decrypt_c_l71_c5_2106 : 0 clocks latency
block_count_MUX_chacha20_decrypt_c_l71_c5_2106 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
block_count_MUX_chacha20_decrypt_c_l71_c5_2106_cond,
block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue,
block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse,
block_count_MUX_chacha20_decrypt_c_l71_c5_2106_return_output);

-- input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106 : 0 clocks latency
input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106 : entity work.MUX_uint1_t_chacha20_decrypt_state_t_chacha20_decrypt_state_t_0CLK_de264c78 port map (
input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_cond,
input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue,
input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse,
input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_return_output);

-- BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e : 0 clocks latency
BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e : entity work.BIN_OP_PLUS_uint32_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_left,
BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_right,
BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_return_output);

-- BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f : 0 clocks latency
BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_left,
BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_right,
BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_return_output);

-- block_count_MUX_chacha20_decrypt_c_l80_c5_d206 : 0 clocks latency
block_count_MUX_chacha20_decrypt_c_l80_c5_d206 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
block_count_MUX_chacha20_decrypt_c_l80_c5_d206_cond,
block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue,
block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse,
block_count_MUX_chacha20_decrypt_c_l80_c5_d206_return_output);

-- input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206 : 0 clocks latency
input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206 : entity work.MUX_uint1_t_chacha20_decrypt_state_t_chacha20_decrypt_state_t_0CLK_de264c78 port map (
input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_cond,
input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue,
input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse,
input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_return_output);

-- BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36 : 0 clocks latency
BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36 : entity work.BIN_OP_PLUS_uint32_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_left,
BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_right,
BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_return_output);

-- block_count_MUX_chacha20_decrypt_c_l83_c7_f750 : 0 clocks latency
block_count_MUX_chacha20_decrypt_c_l83_c7_f750 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
block_count_MUX_chacha20_decrypt_c_l83_c7_f750_cond,
block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue,
block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse,
block_count_MUX_chacha20_decrypt_c_l83_c7_f750_return_output);

-- input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750 : 0 clocks latency
input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750 : entity work.MUX_uint1_t_chacha20_decrypt_state_t_chacha20_decrypt_state_t_0CLK_de264c78 port map (
input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_cond,
input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue,
input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse,
input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_return_output);



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
 axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_return_output,
 BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output,
 block_count_MUX_chacha20_decrypt_c_l61_c3_e815_return_output,
 input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_return_output,
 block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_return_output,
 chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_return_output,
 chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_return_output,
 block_count_MUX_chacha20_decrypt_c_l71_c5_2106_return_output,
 input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_return_output,
 BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_return_output,
 BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_return_output,
 block_count_MUX_chacha20_decrypt_c_l80_c5_d206_return_output,
 input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_return_output,
 BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_return_output,
 block_count_MUX_chacha20_decrypt_c_l83_c7_f750_return_output,
 input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in : axis128_t_stream_t;
 variable VAR_chacha20_decrypt_axis_in_ready : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in : chacha20_decrypt_loop_body_in_t_stream_t;
 variable VAR_chacha20_decrypt_key : uint8_t_32;
 variable VAR_chacha20_decrypt_nonce : uint8_t_12;
 variable VAR_chacha20_decrypt_pipeline_in_ready : unsigned(0 downto 0);
 variable VAR_block_in_ready : unsigned(0 downto 0);
 variable VAR_in_to_block : axis128_to_axis512_t;
 variable VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_in : axis128_t_stream_t;
 variable VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_out_ready : unsigned(0 downto 0);
 variable VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_return_output : axis128_to_axis512_t;
 variable VAR_block_in_stream : axis512_t_stream_t;
 variable VAR_CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d_chacha20_decrypt_c_l46_c40_34b9_return_output : axis512_t_stream_t;
 variable VAR_CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_in_ready_d41d_chacha20_decrypt_c_l47_c36_a879_return_output : unsigned(0 downto 0);
 variable VAR_NULL_PIPELINE_IN : chacha20_decrypt_loop_body_in_t_stream_t;
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output : unsigned(0 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_return_output : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_return_output : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
 variable VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : unsigned(0 downto 0);
 variable VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : unsigned(0 downto 0);
 variable VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : unsigned(0 downto 0);
 variable VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_baed_chacha20_decrypt_c_l61_c3_e815_return_output : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_cond : unsigned(0 downto 0);
 variable VAR_ARRAY_SET_i : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue : unsigned(31 downto 0);
 variable VAR_block_count_chacha20_decrypt_c_l72_c7_ee3b : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_cond : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_return_output : unsigned(32 downto 0);
 variable VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d_chacha20_decrypt_c_l77_c49_9099_return_output : axis512_t;
 variable VAR_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l78_c42_eee6_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_return_output : unsigned(0 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_return_output : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_cond : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_return_output : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_cond : unsigned(0 downto 0);
 variable VAR_block_count_chacha20_decrypt_c_l81_c7_b6ef : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_return_output : unsigned(32 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0_chacha20_decrypt_c_l83_c10_e6e9_return_output : unsigned(0 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse : unsigned(31 downto 0);
 variable VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_cond : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse : unsigned(0 downto 0);
 variable VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_cond : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_8db4_chacha20_decrypt_c_l40_c6_f956_return_output : chacha20_decrypt_loop_body_in_t_stream_t;
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
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_right := to_unsigned(1, 1);
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_right := to_unsigned(1, 1);
     VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue := to_unsigned(0, 32);
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_right := unsigned(chacha20_decrypt_state_t_to_slv(POLY_KEY));
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue := to_unsigned(1, 1);
     VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue := to_unsigned(0, 1);
     VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue := unsigned(chacha20_decrypt_state_t_to_slv(PLAINTEXT));
     VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue := unsigned(chacha20_decrypt_state_t_to_slv(POLY_KEY));
     -- chacha20_decrypt_pipeline_in_data_axis_in_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_baed[chacha20_decrypt_c_l61_c3_e815] LATENCY=0
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_baed_chacha20_decrypt_c_l61_c3_e815_return_output := CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_baed(
     chacha20_decrypt_loop_body_in_t_stream_t_NULL,
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
     to_unsigned(0, 8),
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

     -- Submodule level 1
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue := VAR_chacha20_decrypt_pipeline_in_data_axis_in_TRUE_INPUT_MUX_CONST_REF_RD_axis512_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_baed_chacha20_decrypt_c_l61_c3_e815_return_output;
 -- Reads from global variables
     VAR_chacha20_decrypt_axis_in := global_to_module.chacha20_decrypt_axis_in;
     VAR_chacha20_decrypt_key := global_to_module.chacha20_decrypt_key;
     VAR_chacha20_decrypt_nonce := global_to_module.chacha20_decrypt_nonce;
     VAR_chacha20_decrypt_pipeline_in_ready := global_to_module.chacha20_decrypt_pipeline_in_ready;
     -- Submodule level 0
     VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_in := VAR_chacha20_decrypt_axis_in;
     VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_cond := VAR_chacha20_decrypt_pipeline_in_ready;
     VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_right := VAR_chacha20_decrypt_pipeline_in_ready;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_cond := VAR_chacha20_decrypt_pipeline_in_ready;
     VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse := VAR_chacha20_decrypt_pipeline_in_ready;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_left := block_count;
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_left := block_count;
     VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse := block_count;
     VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse := block_count;
     VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_out_ready := feedback_vars.block_in_ready;
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_left := input_side_state;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse := input_side_state;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse := input_side_state;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse := input_side_state;
     -- BIN_OP_PLUS[chacha20_decrypt_c_l81_c7_ae36] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_left <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_left;
     BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_right <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_return_output := BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_return_output;

     -- input_side_state_MUX[chacha20_decrypt_c_l71_c5_2106] LATENCY=0
     -- Inputs
     input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_cond <= VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_cond;
     input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue <= VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue;
     input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse <= VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse;
     -- Outputs
     VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_return_output := input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_return_output;

     -- BIN_OP_PLUS[chacha20_decrypt_c_l72_c7_e40e] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_left <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_left;
     BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_right <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_return_output := BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_return_output;

     -- axis128_to_axis512[chacha20_decrypt_c_l45_c38_1acd] LATENCY=0
     -- Clock enable
     axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_CLOCK_ENABLE <= VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_CLOCK_ENABLE;
     -- Inputs
     axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_in <= VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_in;
     axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_out_ready <= VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_axis_out_ready;
     -- Outputs
     VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_return_output := axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_return_output;

     -- BIN_OP_EQ[chacha20_decrypt_c_l61_c6_84b7] LATENCY=0
     -- Inputs
     BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_left <= VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_left;
     BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_right <= VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_right;
     -- Outputs
     VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output := BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output;

     -- Submodule level 1
     VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output;
     VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output;
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output;
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_cond := VAR_BIN_OP_EQ_chacha20_decrypt_c_l61_c6_84b7_return_output;
     VAR_block_count_chacha20_decrypt_c_l72_c7_ee3b := resize(VAR_BIN_OP_PLUS_chacha20_decrypt_c_l72_c7_e40e_return_output, 32);
     VAR_block_count_chacha20_decrypt_c_l81_c7_b6ef := resize(VAR_BIN_OP_PLUS_chacha20_decrypt_c_l81_c7_ae36_return_output, 32);
     VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue := VAR_input_side_state_MUX_chacha20_decrypt_c_l71_c5_2106_return_output;
     VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue := VAR_block_count_chacha20_decrypt_c_l72_c7_ee3b;
     VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse := VAR_block_count_chacha20_decrypt_c_l81_c7_b6ef;
     -- block_count_MUX[chacha20_decrypt_c_l71_c5_2106] LATENCY=0
     -- Inputs
     block_count_MUX_chacha20_decrypt_c_l71_c5_2106_cond <= VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_cond;
     block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue <= VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iftrue;
     block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse <= VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_iffalse;
     -- Outputs
     VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_return_output := block_count_MUX_chacha20_decrypt_c_l71_c5_2106_return_output;

     -- CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d[chacha20_decrypt_c_l46_c40_34b9] LATENCY=0
     VAR_CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d_chacha20_decrypt_c_l46_c40_34b9_return_output := VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_return_output.axis_out;

     -- block_in_ready_MUX[chacha20_decrypt_c_l61_c3_e815] LATENCY=0
     -- Inputs
     block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_cond <= VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_cond;
     block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue <= VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue;
     block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse <= VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse;
     -- Outputs
     VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_return_output := block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_return_output;

     -- CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_in_ready_d41d[chacha20_decrypt_c_l47_c36_a879] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_in_ready_d41d_chacha20_decrypt_c_l47_c36_a879_return_output := VAR_axis128_to_axis512_chacha20_decrypt_c_l45_c38_1acd_return_output.axis_in_ready;

     -- Submodule level 2
     VAR_chacha20_decrypt_axis_in_ready := VAR_CONST_REF_RD_uint1_t_axis128_to_axis512_t_axis_in_ready_d41d_chacha20_decrypt_c_l47_c36_a879_return_output;
     VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue := VAR_block_count_MUX_chacha20_decrypt_c_l71_c5_2106_return_output;
     feedback_vars.block_in_ready <= VAR_block_in_ready_MUX_chacha20_decrypt_c_l61_c3_e815_return_output;
     -- CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d[chacha20_decrypt_c_l78_c42_eee6] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l78_c42_eee6_return_output := VAR_CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d_chacha20_decrypt_c_l46_c40_34b9_return_output.valid;

     -- CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d[chacha20_decrypt_c_l77_c49_9099] LATENCY=0
     VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d_chacha20_decrypt_c_l77_c49_9099_return_output := VAR_CONST_REF_RD_axis512_t_stream_t_axis128_to_axis512_t_axis_out_d41d_chacha20_decrypt_c_l46_c40_34b9_return_output.data;

     -- Submodule level 3
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse := VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d_chacha20_decrypt_c_l77_c49_9099_return_output;
     VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_left := VAR_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l78_c42_eee6_return_output;
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse := VAR_CONST_REF_RD_uint1_t_axis512_t_stream_t_valid_d41d_chacha20_decrypt_c_l78_c42_eee6_return_output;
     -- chacha20_decrypt_pipeline_in_data_axis_in_MUX[chacha20_decrypt_c_l61_c3_e815] LATENCY=0
     -- Inputs
     chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_cond <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_cond;
     chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue;
     chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse <= VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_return_output := chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_return_output;

     -- BIN_OP_AND[chacha20_decrypt_c_l80_c8_134f] LATENCY=0
     -- Inputs
     BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_left <= VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_left;
     BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_right <= VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_right;
     -- Outputs
     VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_return_output := BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_return_output;

     -- CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0[chacha20_decrypt_c_l83_c10_e6e9] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0_chacha20_decrypt_c_l83_c10_e6e9_return_output := CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0(
     VAR_CONST_REF_RD_axis512_t_axis512_t_stream_t_data_d41d_chacha20_decrypt_c_l77_c49_9099_return_output);

     -- chacha20_decrypt_pipeline_in_valid_MUX[chacha20_decrypt_c_l61_c3_e815] LATENCY=0
     -- Inputs
     chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_cond <= VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_cond;
     chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue <= VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue;
     chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse <= VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_return_output := chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_return_output;

     -- Submodule level 4
     VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_cond := VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_cond := VAR_BIN_OP_AND_chacha20_decrypt_c_l80_c8_134f_return_output;
     VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_cond := VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0_chacha20_decrypt_c_l83_c10_e6e9_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_cond := VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_data_axis_in_tlast_cef0_chacha20_decrypt_c_l83_c10_e6e9_return_output;
     -- block_count_MUX[chacha20_decrypt_c_l83_c7_f750] LATENCY=0
     -- Inputs
     block_count_MUX_chacha20_decrypt_c_l83_c7_f750_cond <= VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_cond;
     block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue <= VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue;
     block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse <= VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse;
     -- Outputs
     VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_return_output := block_count_MUX_chacha20_decrypt_c_l83_c7_f750_return_output;

     -- chacha20_decrypt_pipeline_in_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_8db4[chacha20_decrypt_c_l40_c6_f956] LATENCY=0
     VAR_chacha20_decrypt_pipeline_in_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_8db4_chacha20_decrypt_c_l40_c6_f956_return_output := CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_8db4(
     VAR_chacha20_decrypt_key,
     VAR_chacha20_decrypt_nonce,
     block_count,
     VAR_chacha20_decrypt_pipeline_in_valid_MUX_chacha20_decrypt_c_l61_c3_e815_return_output,
     VAR_chacha20_decrypt_pipeline_in_data_axis_in_MUX_chacha20_decrypt_c_l61_c3_e815_return_output);

     -- input_side_state_MUX[chacha20_decrypt_c_l83_c7_f750] LATENCY=0
     -- Inputs
     input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_cond <= VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_cond;
     input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue <= VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iftrue;
     input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse <= VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_iffalse;
     -- Outputs
     VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_return_output := input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_return_output;

     -- Submodule level 5
     VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue := VAR_block_count_MUX_chacha20_decrypt_c_l83_c7_f750_return_output;
     VAR_chacha20_decrypt_pipeline_in := VAR_chacha20_decrypt_pipeline_in_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_stream_t_chacha20_decrypt_loop_body_in_t_stream_t_8db4_chacha20_decrypt_c_l40_c6_f956_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue := VAR_input_side_state_MUX_chacha20_decrypt_c_l83_c7_f750_return_output;
     -- block_count_MUX[chacha20_decrypt_c_l80_c5_d206] LATENCY=0
     -- Inputs
     block_count_MUX_chacha20_decrypt_c_l80_c5_d206_cond <= VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_cond;
     block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue <= VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue;
     block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse <= VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse;
     -- Outputs
     VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_return_output := block_count_MUX_chacha20_decrypt_c_l80_c5_d206_return_output;

     -- input_side_state_MUX[chacha20_decrypt_c_l80_c5_d206] LATENCY=0
     -- Inputs
     input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_cond <= VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_cond;
     input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue <= VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iftrue;
     input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse <= VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_iffalse;
     -- Outputs
     VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_return_output := input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_return_output;

     -- Submodule level 6
     VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse := VAR_block_count_MUX_chacha20_decrypt_c_l80_c5_d206_return_output;
     VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse := VAR_input_side_state_MUX_chacha20_decrypt_c_l80_c5_d206_return_output;
     -- input_side_state_MUX[chacha20_decrypt_c_l61_c3_e815] LATENCY=0
     -- Inputs
     input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_cond <= VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_cond;
     input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue <= VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue;
     input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse <= VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse;
     -- Outputs
     VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_return_output := input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_return_output;

     -- block_count_MUX[chacha20_decrypt_c_l61_c3_e815] LATENCY=0
     -- Inputs
     block_count_MUX_chacha20_decrypt_c_l61_c3_e815_cond <= VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_cond;
     block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue <= VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iftrue;
     block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse <= VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_iffalse;
     -- Outputs
     VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_return_output := block_count_MUX_chacha20_decrypt_c_l61_c3_e815_return_output;

     -- Submodule level 7
     REG_VAR_block_count := VAR_block_count_MUX_chacha20_decrypt_c_l61_c3_e815_return_output;
     REG_VAR_input_side_state := VAR_input_side_state_MUX_chacha20_decrypt_c_l61_c3_e815_return_output;
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
