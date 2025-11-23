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
-- Submodules: 9
entity chacha20_decrypt_pipeline_handshake_0CLK_61d00b9b is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in chacha20_decrypt_pipeline_handshake_global_to_module_t;
 module_to_global : out chacha20_decrypt_pipeline_handshake_module_to_global_t);
end chacha20_decrypt_pipeline_handshake_0CLK_61d00b9b;
architecture arch of chacha20_decrypt_pipeline_handshake_0CLK_61d00b9b is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal fifo_count : unsigned(15 downto 0) := to_unsigned(0, 16);
signal REG_COMB_fifo_count : unsigned(15 downto 0);

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- BIN_OP_LT[chacha20_decrypt_c_l24_c111_6bcf]
signal BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_left : unsigned(15 downto 0);
signal BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_right : unsigned(6 downto 0);
signal BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_return_output : unsigned(0 downto 0);

-- chacha20_decrypt_pipeline_FIFO[chacha20_decrypt_c_l24_c571_3e56]
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_CLOCK_ENABLE : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_ready_for_data_out : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in : axis512_t;
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in_valid : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_return_output : chacha20_decrypt_pipeline_FIFO_t;

-- fifo_count_MUX[chacha20_decrypt_c_l24_c756_c08e]
signal fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_cond : unsigned(0 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iftrue : unsigned(15 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iffalse : unsigned(15 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_return_output : unsigned(15 downto 0);

-- BIN_OP_PLUS[chacha20_decrypt_c_l24_c833_f114]
signal BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_left : unsigned(15 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_right : unsigned(0 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_return_output : unsigned(16 downto 0);

-- BIN_OP_AND[chacha20_decrypt_c_l24_c855_cc53]
signal BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_left : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_right : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_return_output : unsigned(0 downto 0);

-- fifo_count_MUX[chacha20_decrypt_c_l24_c852_8b47]
signal fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_cond : unsigned(0 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iftrue : unsigned(15 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iffalse : unsigned(15 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_return_output : unsigned(15 downto 0);

-- BIN_OP_MINUS[chacha20_decrypt_c_l24_c931_ceef]
signal BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_left : unsigned(15 downto 0);
signal BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_right : unsigned(0 downto 0);
signal BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_return_output : unsigned(15 downto 0);

-- BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10
signal BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_left : unsigned(0 downto 0);
signal BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_right : unsigned(0 downto 0);
signal BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_return_output : unsigned(0 downto 0);

function CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095( ref_toks_0 : unsigned;
 ref_toks_1 : axis512_t) return axis512_t_stream_t is
 
  variable base : axis512_t_stream_t; 
  variable return_output : axis512_t_stream_t;
begin
      base.valid := ref_toks_0;
      base.data := ref_toks_1;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf : 0 clocks latency
BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf : entity work.BIN_OP_LT_uint16_t_uint7_t_0CLK_5af1a430 port map (
BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_left,
BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_right,
BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_return_output);

-- chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56 : 0 clocks latency
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56 : entity work.chacha20_decrypt_pipeline_FIFO_0CLK_b45f1687 port map (
clk,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_CLOCK_ENABLE,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_ready_for_data_out,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in_valid,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_return_output);

-- fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e : 0 clocks latency
fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_cond,
fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iftrue,
fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iffalse,
fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_return_output);

-- BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114 : 0 clocks latency
BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114 : entity work.BIN_OP_PLUS_uint16_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_left,
BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_right,
BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_return_output);

-- BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53 : 0 clocks latency
BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_left,
BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_right,
BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_return_output);

-- fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47 : 0 clocks latency
fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_cond,
fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iftrue,
fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iffalse,
fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_return_output);

-- BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef : 0 clocks latency
BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef : entity work.BIN_OP_MINUS_uint16_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_left,
BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_right,
BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_return_output);

-- BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10 : 0 clocks latency
BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_left,
BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_right,
BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Registers
 fifo_count,
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_return_output,
 chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_return_output,
 fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_return_output,
 BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_return_output,
 BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_return_output,
 fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_return_output,
 BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_return_output,
 BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in_ready : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_no_handshake_in_valid : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_in : chacha20_decrypt_loop_body_in_t_stream_t;
 variable VAR_chacha20_decrypt_pipeline_no_handshake_in : chacha20_decrypt_loop_body_in_t;
 variable VAR_chacha20_decrypt_pipeline_no_handshake_out_valid : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_no_handshake_out : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_out_ready : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_out : axis512_t_stream_t;
 variable VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_right : unsigned(6 downto 0);
 variable VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_chacha20_decrypt_loop_body_in_t_stream_t_data_d41d_chacha20_decrypt_c_l24_c296_6c6c_return_output : chacha20_decrypt_loop_body_in_t;
 variable VAR_fifo_wr_en : unsigned(0 downto 0);
 variable VAR_fifo_wr_data : axis512_t;
 variable VAR_fifo_rd_en : unsigned(0 downto 0);
 variable VAR_fifo_o : chacha20_decrypt_pipeline_FIFO_t;
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_ready_for_data_out : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in_valid : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_return_output : chacha20_decrypt_pipeline_FIFO_t;
 variable VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d_chacha20_decrypt_c_l24_c679_0bd4_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_axis512_t_chacha20_decrypt_pipeline_FIFO_t_data_out_d41d_chacha20_decrypt_c_l24_c739_4c7b_return_output : axis512_t;
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iftrue : unsigned(15 downto 0);
 variable VAR_fifo_count_chacha20_decrypt_c_l24_c833_c22c : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iffalse : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_return_output : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_return_output : unsigned(16 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_return_output : unsigned(0 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iftrue : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iffalse : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_return_output : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_return_output : unsigned(15 downto 0);
 variable VAR_chacha20_decrypt_pipeline_out_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095_chacha20_decrypt_c_l24_c6_d542_return_output : axis512_t_stream_t;
 variable VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l24_DUPLICATE_a3a3_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_return_output : unsigned(0 downto 0);
 -- State registers comb logic variables
variable REG_VAR_fifo_count : unsigned(15 downto 0);
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_fifo_count := fifo_count;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_right := to_unsigned(1, 1);
     VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_right := to_unsigned(64, 7);
     VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_right := to_unsigned(1, 1);
 -- Reads from global variables
     VAR_chacha20_decrypt_pipeline_in := global_to_module.chacha20_decrypt_pipeline_in;
     VAR_chacha20_decrypt_pipeline_no_handshake_out_valid := global_to_module.chacha20_decrypt_pipeline_no_handshake_out_valid;
     VAR_chacha20_decrypt_pipeline_no_handshake_out := global_to_module.chacha20_decrypt_pipeline_no_handshake_out;
     VAR_chacha20_decrypt_pipeline_out_ready := global_to_module.chacha20_decrypt_pipeline_out_ready;
     -- Submodule level 0
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in_valid := VAR_chacha20_decrypt_pipeline_no_handshake_out_valid;
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in := VAR_chacha20_decrypt_pipeline_no_handshake_out;
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_ready_for_data_out := VAR_chacha20_decrypt_pipeline_out_ready;
     VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_right := VAR_chacha20_decrypt_pipeline_out_ready;
     -- CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l24_DUPLICATE_a3a3 LATENCY=0
     VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l24_DUPLICATE_a3a3_return_output := VAR_chacha20_decrypt_pipeline_in.valid;

     -- CONST_REF_RD_chacha20_decrypt_loop_body_in_t_chacha20_decrypt_loop_body_in_t_stream_t_data_d41d[chacha20_decrypt_c_l24_c296_6c6c] LATENCY=0
     VAR_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_chacha20_decrypt_loop_body_in_t_stream_t_data_d41d_chacha20_decrypt_c_l24_c296_6c6c_return_output := VAR_chacha20_decrypt_pipeline_in.data;

     -- Submodule level 1
     VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_left := VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l24_DUPLICATE_a3a3_return_output;
     VAR_chacha20_decrypt_pipeline_no_handshake_in := VAR_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_chacha20_decrypt_loop_body_in_t_stream_t_data_d41d_chacha20_decrypt_c_l24_c296_6c6c_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_left := fifo_count;
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_left := fifo_count;
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iffalse := fifo_count;
     -- chacha20_decrypt_pipeline_FIFO[chacha20_decrypt_c_l24_c571_3e56] LATENCY=0
     -- Clock enable
     chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_CLOCK_ENABLE <= VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_CLOCK_ENABLE;
     -- Inputs
     chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_ready_for_data_out <= VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_ready_for_data_out;
     chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in <= VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in;
     chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in_valid <= VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_data_in_valid;
     -- Outputs
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_return_output := chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_return_output;

     -- BIN_OP_PLUS[chacha20_decrypt_c_l24_c833_f114] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_left <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_left;
     BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_right <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_return_output := BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_return_output;

     -- BIN_OP_LT[chacha20_decrypt_c_l24_c111_6bcf] LATENCY=0
     -- Inputs
     BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_left <= VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_left;
     BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_right <= VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_right;
     -- Outputs
     VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_return_output := BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_return_output;

     -- Submodule level 1
     VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_right := VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_return_output;
     VAR_chacha20_decrypt_pipeline_in_ready := VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_6bcf_return_output;
     VAR_fifo_count_chacha20_decrypt_c_l24_c833_c22c := resize(VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_f114_return_output, 16);
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iftrue := VAR_fifo_count_chacha20_decrypt_c_l24_c833_c22c;
     -- CONST_REF_RD_axis512_t_chacha20_decrypt_pipeline_FIFO_t_data_out_d41d[chacha20_decrypt_c_l24_c739_4c7b] LATENCY=0
     VAR_CONST_REF_RD_axis512_t_chacha20_decrypt_pipeline_FIFO_t_data_out_d41d_chacha20_decrypt_c_l24_c739_4c7b_return_output := VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_return_output.data_out;

     -- BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10 LATENCY=0
     -- Inputs
     BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_left <= VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_left;
     BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_right <= VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_right;
     -- Outputs
     VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_return_output := BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_return_output;

     -- CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d[chacha20_decrypt_c_l24_c679_0bd4] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d_chacha20_decrypt_c_l24_c679_0bd4_return_output := VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_3e56_return_output.data_out_valid;

     -- Submodule level 2
     VAR_chacha20_decrypt_pipeline_no_handshake_in_valid := VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_return_output;
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_cond := VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_2c10_return_output;
     VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_left := VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d_chacha20_decrypt_c_l24_c679_0bd4_return_output;
     -- fifo_count_MUX[chacha20_decrypt_c_l24_c756_c08e] LATENCY=0
     -- Inputs
     fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_cond <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_cond;
     fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iftrue <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iftrue;
     fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iffalse <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_iffalse;
     -- Outputs
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_return_output := fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_return_output;

     -- BIN_OP_AND[chacha20_decrypt_c_l24_c855_cc53] LATENCY=0
     -- Inputs
     BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_left <= VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_left;
     BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_right <= VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_right;
     -- Outputs
     VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_return_output := BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_return_output;

     -- chacha20_decrypt_pipeline_out_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095[chacha20_decrypt_c_l24_c6_d542] LATENCY=0
     VAR_chacha20_decrypt_pipeline_out_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095_chacha20_decrypt_c_l24_c6_d542_return_output := CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095(
     VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d_chacha20_decrypt_c_l24_c679_0bd4_return_output,
     VAR_CONST_REF_RD_axis512_t_chacha20_decrypt_pipeline_FIFO_t_data_out_d41d_chacha20_decrypt_c_l24_c739_4c7b_return_output);

     -- Submodule level 3
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_cond := VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_cc53_return_output;
     VAR_chacha20_decrypt_pipeline_out := VAR_chacha20_decrypt_pipeline_out_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095_chacha20_decrypt_c_l24_c6_d542_return_output;
     VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_left := VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_return_output;
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iffalse := VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_c08e_return_output;
     -- BIN_OP_MINUS[chacha20_decrypt_c_l24_c931_ceef] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_left <= VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_left;
     BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_right <= VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_right;
     -- Outputs
     VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_return_output := BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_return_output;

     -- Submodule level 4
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iftrue := VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_ceef_return_output;
     -- fifo_count_MUX[chacha20_decrypt_c_l24_c852_8b47] LATENCY=0
     -- Inputs
     fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_cond <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_cond;
     fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iftrue <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iftrue;
     fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iffalse <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_iffalse;
     -- Outputs
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_return_output := fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_return_output;

     -- Submodule level 5
     REG_VAR_fifo_count := VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_8b47_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_fifo_count <= REG_VAR_fifo_count;
-- Global wires driven various places in pipeline
if clk_en_internal='1' then
  module_to_global.chacha20_decrypt_pipeline_in_ready <= VAR_chacha20_decrypt_pipeline_in_ready;
else
  module_to_global.chacha20_decrypt_pipeline_in_ready <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.chacha20_decrypt_pipeline_no_handshake_in_valid <= VAR_chacha20_decrypt_pipeline_no_handshake_in_valid;
else
  module_to_global.chacha20_decrypt_pipeline_no_handshake_in_valid <= to_unsigned(0, 1);
end if;
if clk_en_internal='1' then
  module_to_global.chacha20_decrypt_pipeline_no_handshake_in <= VAR_chacha20_decrypt_pipeline_no_handshake_in;
else
  module_to_global.chacha20_decrypt_pipeline_no_handshake_in <= chacha20_decrypt_loop_body_in_t_NULL;
end if;
if clk_en_internal='1' then
  module_to_global.chacha20_decrypt_pipeline_out <= VAR_chacha20_decrypt_pipeline_out;
else
  module_to_global.chacha20_decrypt_pipeline_out <= axis512_t_stream_t_NULL;
end if;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     fifo_count <= REG_COMB_fifo_count;
 end if;
 end if;
end process;

end arch;
