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
-- Submodules: 11
entity main_0CLK_fc74e538 is
port(
 global_to_module : in main_global_to_module_t;
 module_to_global : out main_module_to_global_t);
end main_0CLK_fc74e538;
architecture arch of main_0CLK_fc74e538 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- BIN_OP_AND[chacha20poly1305_decrypt_c_l53_c37_5303]
signal BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_left : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_right : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_return_output : unsigned(0 downto 0);

-- chacha20_decrypt_axis_in_valid_MUX[chacha20poly1305_decrypt_c_l55_c5_ce10]
signal chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond : unsigned(0 downto 0);
signal chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue : unsigned(0 downto 0);
signal chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse : unsigned(0 downto 0);
signal chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output : unsigned(0 downto 0);

-- prep_auth_data_axis_in_valid_MUX[chacha20poly1305_decrypt_c_l55_c5_ce10]
signal prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue : unsigned(0 downto 0);
signal prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse : unsigned(0 downto 0);
signal prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output : unsigned(0 downto 0);

-- UNARY_OP_NOT[chacha20poly1305_decrypt_c_l56_c44_31e9]
signal UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_expr : unsigned(0 downto 0);
signal UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[chacha20poly1305_decrypt_c_l56_c11_0fb8]
signal BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_left : unsigned(0 downto 0);
signal BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_right : unsigned(0 downto 0);
signal BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_return_output : unsigned(0 downto 0);

-- prep_auth_data_axis_in_valid_MUX[chacha20poly1305_decrypt_c_l56_c7_a76f]
signal prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_cond : unsigned(0 downto 0);
signal prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iftrue : unsigned(0 downto 0);
signal prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iffalse : unsigned(0 downto 0);
signal prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_return_output : unsigned(0 downto 0);

-- UNARY_OP_NOT[chacha20poly1305_decrypt_c_l59_c44_e59c]
signal UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_expr : unsigned(0 downto 0);
signal UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_return_output : unsigned(0 downto 0);

-- BIN_OP_OR[chacha20poly1305_decrypt_c_l59_c11_cf79]
signal BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_left : unsigned(0 downto 0);
signal BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_right : unsigned(0 downto 0);
signal BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_return_output : unsigned(0 downto 0);

-- chacha20_decrypt_axis_in_valid_MUX[chacha20poly1305_decrypt_c_l59_c7_2263]
signal chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_cond : unsigned(0 downto 0);
signal chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iftrue : unsigned(0 downto 0);
signal chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iffalse : unsigned(0 downto 0);
signal chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_return_output : unsigned(0 downto 0);

function CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095( ref_toks_0 : unsigned;
 ref_toks_1 : axis128_t) return axis128_t_stream_t is
 
  variable base : axis128_t_stream_t; 
  variable return_output : axis128_t_stream_t;
begin
      base.valid := ref_toks_0;
      base.data := ref_toks_1;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303 : 0 clocks latency
BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_left,
BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_right,
BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_return_output);

-- chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10 : 0 clocks latency
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond,
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue,
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse,
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output);

-- prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10 : 0 clocks latency
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond,
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue,
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse,
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output);

-- UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9 : 0 clocks latency
UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9 : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_expr,
UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_return_output);

-- BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8 : 0 clocks latency
BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_left,
BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_right,
BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_return_output);

-- prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f : 0 clocks latency
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_cond,
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iftrue,
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iffalse,
prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_return_output);

-- UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c : 0 clocks latency
UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_expr,
UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_return_output);

-- BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79 : 0 clocks latency
BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79 : entity work.BIN_OP_OR_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_left,
BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_right,
BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_return_output);

-- chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263 : 0 clocks latency
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_cond,
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iftrue,
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iffalse,
chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_return_output,
 chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output,
 prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output,
 UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_return_output,
 BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_return_output,
 prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_return_output,
 UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_return_output,
 BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_return_output,
 chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_in : axis128_t_stream_t;
 variable VAR_chacha20poly1305_decrypt_axis_in : axis128_t_stream_t;
 variable VAR_chacha20poly1305_decrypt_axis_in_ready : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_in_ready : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_key : uint8_t_32;
 variable VAR_chacha20poly1305_decrypt_key : uint8_t_32;
 variable VAR_chacha20_decrypt_nonce : uint8_t_12;
 variable VAR_chacha20poly1305_decrypt_nonce : uint8_t_12;
 variable VAR_poly1305_mac_key : uint256_t_stream_t;
 variable VAR_chacha20_decrypt_poly_key : uint256_t_stream_t;
 variable VAR_chacha20_decrypt_poly_key_ready : unsigned(0 downto 0);
 variable VAR_poly1305_mac_key_ready : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in : axis128_t_stream_t;
 variable VAR_chacha20_decrypt_axis_in : axis128_t_stream_t;
 variable VAR_strip_auth_tag_axis_out_ready : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_ready : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_ready : unsigned(0 downto 0);
 variable VAR_strip_auth_tag_axis_out : axis128_t_stream_t;
 variable VAR_prep_auth_data_aad : uint8_t_32;
 variable VAR_chacha20poly1305_decrypt_aad : uint8_t_32;
 variable VAR_prep_auth_data_aad_len : unsigned(7 downto 0);
 variable VAR_chacha20poly1305_decrypt_aad_len : unsigned(7 downto 0);
 variable VAR_poly1305_mac_data_in : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out : axis128_t_stream_t;
 variable VAR_prep_auth_data_axis_out_ready : unsigned(0 downto 0);
 variable VAR_poly1305_mac_data_in_ready : unsigned(0 downto 0);
 variable VAR_poly1305_verify_auth_tag : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out : uint128_t_stream_t;
 variable VAR_strip_auth_tag_auth_tag_out_ready : unsigned(0 downto 0);
 variable VAR_poly1305_verify_auth_tag_ready : unsigned(0 downto 0);
 variable VAR_poly1305_verify_calc_tag : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag : uint128_t_stream_t;
 variable VAR_poly1305_mac_auth_tag_ready : unsigned(0 downto 0);
 variable VAR_poly1305_verify_calc_tag_ready : unsigned(0 downto 0);
 variable VAR_wait_to_verify_axis_in : axis128_t_stream_t;
 variable VAR_chacha20_decrypt_axis_out : axis128_t_stream_t;
 variable VAR_chacha20_decrypt_axis_out_ready : unsigned(0 downto 0);
 variable VAR_wait_to_verify_axis_in_ready : unsigned(0 downto 0);
 variable VAR_wait_to_verify_verify_bit : uint1_t_stream_t;
 variable VAR_poly1305_verify_tags_match : uint1_t_stream_t;
 variable VAR_poly1305_verify_tags_match_ready : unsigned(0 downto 0);
 variable VAR_wait_to_verify_verify_bit_ready : unsigned(0 downto 0);
 variable VAR_chacha20poly1305_decrypt_axis_out : axis128_t_stream_t;
 variable VAR_wait_to_verify_axis_out : axis128_t_stream_t;
 variable VAR_wait_to_verify_axis_out_ready : unsigned(0 downto 0);
 variable VAR_chacha20poly1305_decrypt_axis_out_ready : unsigned(0 downto 0);
 variable VAR_chacha20poly1305_decrypt_is_verified_out : unsigned(0 downto 0);
 variable VAR_wait_to_verify_is_verified_out : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_chacha20poly1305_decrypt_c_l55_c9_4c53_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_left : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_expr : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_return_output : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iftrue : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iffalse : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_left : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_expr : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_return_output : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iftrue : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iffalse : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_cond : unsigned(0 downto 0);
 variable VAR_prep_auth_data_axis_in_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095_chacha20poly1305_decrypt_c_l24_c6_b877_return_output : axis128_t_stream_t;
 variable VAR_chacha20_decrypt_axis_in_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095_chacha20poly1305_decrypt_c_l24_c6_b877_return_output : axis128_t_stream_t;
 variable VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_chacha20poly1305_decrypt_c_l66_l65_DUPLICATE_57e0_return_output : axis128_t;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iftrue := to_unsigned(1, 1);
     VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse := to_unsigned(0, 1);
     VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iffalse := to_unsigned(0, 1);
     VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iffalse := to_unsigned(0, 1);
     VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse := to_unsigned(0, 1);
     VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iftrue := to_unsigned(1, 1);
 -- Reads from global variables
     VAR_chacha20poly1305_decrypt_axis_in := global_to_module.chacha20poly1305_decrypt_axis_in;
     VAR_strip_auth_tag_axis_in_ready := global_to_module.strip_auth_tag_axis_in_ready;
     VAR_chacha20poly1305_decrypt_key := global_to_module.chacha20poly1305_decrypt_key;
     VAR_chacha20poly1305_decrypt_nonce := global_to_module.chacha20poly1305_decrypt_nonce;
     VAR_chacha20_decrypt_poly_key := global_to_module.chacha20_decrypt_poly_key;
     VAR_poly1305_mac_key_ready := global_to_module.poly1305_mac_key_ready;
     VAR_prep_auth_data_axis_in_ready := global_to_module.prep_auth_data_axis_in_ready;
     VAR_chacha20_decrypt_axis_in_ready := global_to_module.chacha20_decrypt_axis_in_ready;
     VAR_strip_auth_tag_axis_out := global_to_module.strip_auth_tag_axis_out;
     VAR_chacha20poly1305_decrypt_aad := global_to_module.chacha20poly1305_decrypt_aad;
     VAR_chacha20poly1305_decrypt_aad_len := global_to_module.chacha20poly1305_decrypt_aad_len;
     VAR_prep_auth_data_axis_out := global_to_module.prep_auth_data_axis_out;
     VAR_poly1305_mac_data_in_ready := global_to_module.poly1305_mac_data_in_ready;
     VAR_strip_auth_tag_auth_tag_out := global_to_module.strip_auth_tag_auth_tag_out;
     VAR_poly1305_verify_auth_tag_ready := global_to_module.poly1305_verify_auth_tag_ready;
     VAR_poly1305_mac_auth_tag := global_to_module.poly1305_mac_auth_tag;
     VAR_poly1305_verify_calc_tag_ready := global_to_module.poly1305_verify_calc_tag_ready;
     VAR_chacha20_decrypt_axis_out := global_to_module.chacha20_decrypt_axis_out;
     VAR_wait_to_verify_axis_in_ready := global_to_module.wait_to_verify_axis_in_ready;
     VAR_poly1305_verify_tags_match := global_to_module.poly1305_verify_tags_match;
     VAR_wait_to_verify_verify_bit_ready := global_to_module.wait_to_verify_verify_bit_ready;
     VAR_wait_to_verify_axis_out := global_to_module.wait_to_verify_axis_out;
     VAR_chacha20poly1305_decrypt_axis_out_ready := global_to_module.chacha20poly1305_decrypt_axis_out_ready;
     VAR_wait_to_verify_is_verified_out := global_to_module.wait_to_verify_is_verified_out;
     -- Submodule level 0
     VAR_chacha20_decrypt_nonce := VAR_chacha20poly1305_decrypt_nonce;
     VAR_poly1305_mac_data_in := VAR_prep_auth_data_axis_out;
     VAR_chacha20_decrypt_poly_key_ready := VAR_poly1305_mac_key_ready;
     VAR_strip_auth_tag_auth_tag_out_ready := VAR_poly1305_verify_auth_tag_ready;
     VAR_wait_to_verify_verify_bit := VAR_poly1305_verify_tags_match;
     VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_expr := VAR_chacha20_decrypt_axis_in_ready;
     VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_right := VAR_chacha20_decrypt_axis_in_ready;
     VAR_chacha20_decrypt_key := VAR_chacha20poly1305_decrypt_key;
     VAR_chacha20poly1305_decrypt_is_verified_out := VAR_wait_to_verify_is_verified_out;
     VAR_wait_to_verify_axis_in := VAR_chacha20_decrypt_axis_out;
     VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_expr := VAR_prep_auth_data_axis_in_ready;
     VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_left := VAR_prep_auth_data_axis_in_ready;
     VAR_strip_auth_tag_axis_in := VAR_chacha20poly1305_decrypt_axis_in;
     VAR_poly1305_verify_auth_tag := VAR_strip_auth_tag_auth_tag_out;
     VAR_chacha20_decrypt_axis_out_ready := VAR_wait_to_verify_axis_in_ready;
     VAR_poly1305_mac_auth_tag_ready := VAR_poly1305_verify_calc_tag_ready;
     VAR_prep_auth_data_aad := VAR_chacha20poly1305_decrypt_aad;
     VAR_chacha20poly1305_decrypt_axis_in_ready := VAR_strip_auth_tag_axis_in_ready;
     VAR_wait_to_verify_axis_out_ready := VAR_chacha20poly1305_decrypt_axis_out_ready;
     VAR_chacha20poly1305_decrypt_axis_out := VAR_wait_to_verify_axis_out;
     VAR_poly1305_verify_tags_match_ready := VAR_wait_to_verify_verify_bit_ready;
     VAR_poly1305_verify_calc_tag := VAR_poly1305_mac_auth_tag;
     VAR_poly1305_mac_key := VAR_chacha20_decrypt_poly_key;
     VAR_prep_auth_data_axis_out_ready := VAR_poly1305_mac_data_in_ready;
     VAR_prep_auth_data_aad_len := VAR_chacha20poly1305_decrypt_aad_len;
     -- CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d[chacha20poly1305_decrypt_c_l55_c9_4c53] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_chacha20poly1305_decrypt_c_l55_c9_4c53_return_output := VAR_strip_auth_tag_axis_out.valid;

     -- CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_chacha20poly1305_decrypt_c_l66_l65_DUPLICATE_57e0 LATENCY=0
     VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_chacha20poly1305_decrypt_c_l66_l65_DUPLICATE_57e0_return_output := VAR_strip_auth_tag_axis_out.data;

     -- Submodule level 1
     VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_chacha20poly1305_decrypt_c_l55_c9_4c53_return_output;
     VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond := VAR_CONST_REF_RD_uint1_t_axis128_t_stream_t_valid_d41d_chacha20poly1305_decrypt_c_l55_c9_4c53_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then

     -- Submodule level 0
     -- UNARY_OP_NOT[chacha20poly1305_decrypt_c_l59_c44_e59c] LATENCY=0
     -- Inputs
     UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_expr <= VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_expr;
     -- Outputs
     VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_return_output := UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_return_output;

     -- BIN_OP_AND[chacha20poly1305_decrypt_c_l53_c37_5303] LATENCY=0
     -- Inputs
     BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_left <= VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_left;
     BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_right <= VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_right;
     -- Outputs
     VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_return_output := BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_return_output;

     -- UNARY_OP_NOT[chacha20poly1305_decrypt_c_l56_c44_31e9] LATENCY=0
     -- Inputs
     UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_expr <= VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_expr;
     -- Outputs
     VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_return_output := UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_return_output;

     -- Submodule level 1
     VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_left := VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_return_output;
     VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_left := VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_return_output;
     VAR_strip_auth_tag_axis_out_ready := VAR_BIN_OP_AND_chacha20poly1305_decrypt_c_l53_c37_5303_return_output;
     VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_right := VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l56_c44_31e9_return_output;
     VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_right := VAR_UNARY_OP_NOT_chacha20poly1305_decrypt_c_l59_c44_e59c_return_output;
     -- BIN_OP_OR[chacha20poly1305_decrypt_c_l56_c11_0fb8] LATENCY=0
     -- Inputs
     BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_left <= VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_left;
     BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_right <= VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_right;
     -- Outputs
     VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_return_output := BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_return_output;

     -- BIN_OP_OR[chacha20poly1305_decrypt_c_l59_c11_cf79] LATENCY=0
     -- Inputs
     BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_left <= VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_left;
     BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_right <= VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_right;
     -- Outputs
     VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_return_output := BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_return_output;

     -- Submodule level 2
     VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_cond := VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l56_c11_0fb8_return_output;
     VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_cond := VAR_BIN_OP_OR_chacha20poly1305_decrypt_c_l59_c11_cf79_return_output;
     -- chacha20_decrypt_axis_in_valid_MUX[chacha20poly1305_decrypt_c_l59_c7_2263] LATENCY=0
     -- Inputs
     chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_cond <= VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_cond;
     chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iftrue <= VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iftrue;
     chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iffalse <= VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_return_output := chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_return_output;

     -- prep_auth_data_axis_in_valid_MUX[chacha20poly1305_decrypt_c_l56_c7_a76f] LATENCY=0
     -- Inputs
     prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_cond <= VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_cond;
     prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iftrue <= VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iftrue;
     prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iffalse <= VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_return_output := prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_return_output;

     -- Submodule level 3
     VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue := VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l59_c7_2263_return_output;
     VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue := VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l56_c7_a76f_return_output;
     -- chacha20_decrypt_axis_in_valid_MUX[chacha20poly1305_decrypt_c_l55_c5_ce10] LATENCY=0
     -- Inputs
     chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond <= VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond;
     chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue <= VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue;
     chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse <= VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse;
     -- Outputs
     VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output := chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output;

     -- prep_auth_data_axis_in_valid_MUX[chacha20poly1305_decrypt_c_l55_c5_ce10] LATENCY=0
     -- Inputs
     prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond <= VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_cond;
     prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue <= VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iftrue;
     prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse <= VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_iffalse;
     -- Outputs
     VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output := prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output;

     -- Submodule level 4
     -- chacha20_decrypt_axis_in_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095[chacha20poly1305_decrypt_c_l24_c6_b877] LATENCY=0
     VAR_chacha20_decrypt_axis_in_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095_chacha20poly1305_decrypt_c_l24_c6_b877_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095(
     VAR_chacha20_decrypt_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output,
     VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_chacha20poly1305_decrypt_c_l66_l65_DUPLICATE_57e0_return_output);

     -- prep_auth_data_axis_in_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095[chacha20poly1305_decrypt_c_l24_c6_b877] LATENCY=0
     VAR_prep_auth_data_axis_in_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095_chacha20poly1305_decrypt_c_l24_c6_b877_return_output := CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095(
     VAR_prep_auth_data_axis_in_valid_MUX_chacha20poly1305_decrypt_c_l55_c5_ce10_return_output,
     VAR_CONST_REF_RD_axis128_t_axis128_t_stream_t_data_d41d_chacha20poly1305_decrypt_c_l66_l65_DUPLICATE_57e0_return_output);

     -- Submodule level 5
     VAR_chacha20_decrypt_axis_in := VAR_chacha20_decrypt_axis_in_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095_chacha20poly1305_decrypt_c_l24_c6_b877_return_output;
     VAR_prep_auth_data_axis_in := VAR_prep_auth_data_axis_in_CONST_REF_RD_axis128_t_stream_t_axis128_t_stream_t_1095_chacha20poly1305_decrypt_c_l24_c6_b877_return_output;
   end if;
 end loop;

-- Global wires driven various places in pipeline
module_to_global.strip_auth_tag_axis_in <= VAR_strip_auth_tag_axis_in;
module_to_global.chacha20poly1305_decrypt_axis_in_ready <= VAR_chacha20poly1305_decrypt_axis_in_ready;
module_to_global.chacha20_decrypt_key <= VAR_chacha20_decrypt_key;
module_to_global.chacha20_decrypt_nonce <= VAR_chacha20_decrypt_nonce;
module_to_global.poly1305_mac_key <= VAR_poly1305_mac_key;
module_to_global.chacha20_decrypt_poly_key_ready <= VAR_chacha20_decrypt_poly_key_ready;
module_to_global.prep_auth_data_axis_in <= VAR_prep_auth_data_axis_in;
module_to_global.chacha20_decrypt_axis_in <= VAR_chacha20_decrypt_axis_in;
module_to_global.strip_auth_tag_axis_out_ready <= VAR_strip_auth_tag_axis_out_ready;
module_to_global.prep_auth_data_aad <= VAR_prep_auth_data_aad;
module_to_global.prep_auth_data_aad_len <= VAR_prep_auth_data_aad_len;
module_to_global.poly1305_mac_data_in <= VAR_poly1305_mac_data_in;
module_to_global.prep_auth_data_axis_out_ready <= VAR_prep_auth_data_axis_out_ready;
module_to_global.poly1305_verify_auth_tag <= VAR_poly1305_verify_auth_tag;
module_to_global.strip_auth_tag_auth_tag_out_ready <= VAR_strip_auth_tag_auth_tag_out_ready;
module_to_global.poly1305_verify_calc_tag <= VAR_poly1305_verify_calc_tag;
module_to_global.poly1305_mac_auth_tag_ready <= VAR_poly1305_mac_auth_tag_ready;
module_to_global.wait_to_verify_axis_in <= VAR_wait_to_verify_axis_in;
module_to_global.chacha20_decrypt_axis_out_ready <= VAR_chacha20_decrypt_axis_out_ready;
module_to_global.wait_to_verify_verify_bit <= VAR_wait_to_verify_verify_bit;
module_to_global.poly1305_verify_tags_match_ready <= VAR_poly1305_verify_tags_match_ready;
module_to_global.chacha20poly1305_decrypt_axis_out <= VAR_chacha20poly1305_decrypt_axis_out;
module_to_global.wait_to_verify_axis_out_ready <= VAR_wait_to_verify_axis_out_ready;
end process;

end arch;
