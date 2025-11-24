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
-- BIN_OP_LT[chacha20_decrypt_c_l24_c111_1973]
signal BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_left : unsigned(15 downto 0);
signal BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_right : unsigned(6 downto 0);
signal BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_return_output : unsigned(0 downto 0);

-- chacha20_decrypt_pipeline_FIFO[chacha20_decrypt_c_l24_c571_c43e]
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_CLOCK_ENABLE : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_ready_for_data_out : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in : axis512_t;
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in_valid : unsigned(0 downto 0);
signal chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_return_output : chacha20_decrypt_pipeline_FIFO_t;

-- fifo_count_MUX[chacha20_decrypt_c_l24_c756_b0c3]
signal fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_cond : unsigned(0 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iftrue : unsigned(15 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iffalse : unsigned(15 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_return_output : unsigned(15 downto 0);

-- BIN_OP_PLUS[chacha20_decrypt_c_l24_c833_62b0]
signal BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_left : unsigned(15 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_right : unsigned(0 downto 0);
signal BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_return_output : unsigned(16 downto 0);

-- BIN_OP_AND[chacha20_decrypt_c_l24_c855_f7ce]
signal BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_left : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_right : unsigned(0 downto 0);
signal BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_return_output : unsigned(0 downto 0);

-- fifo_count_MUX[chacha20_decrypt_c_l24_c852_7013]
signal fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_cond : unsigned(0 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iftrue : unsigned(15 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iffalse : unsigned(15 downto 0);
signal fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_return_output : unsigned(15 downto 0);

-- BIN_OP_MINUS[chacha20_decrypt_c_l24_c931_253d]
signal BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_left : unsigned(15 downto 0);
signal BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_right : unsigned(0 downto 0);
signal BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_return_output : unsigned(15 downto 0);

-- BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0
signal BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_left : unsigned(0 downto 0);
signal BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_right : unsigned(0 downto 0);
signal BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_return_output : unsigned(0 downto 0);

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
-- BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973 : 0 clocks latency
BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973 : entity work.BIN_OP_LT_uint16_t_uint7_t_0CLK_5af1a430 port map (
BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_left,
BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_right,
BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_return_output);

-- chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e : 0 clocks latency
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e : entity work.chacha20_decrypt_pipeline_FIFO_0CLK_b45f1687 port map (
clk,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_CLOCK_ENABLE,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_ready_for_data_out,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in_valid,
chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_return_output);

-- fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3 : 0 clocks latency
fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_cond,
fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iftrue,
fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iffalse,
fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_return_output);

-- BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0 : 0 clocks latency
BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0 : entity work.BIN_OP_PLUS_uint16_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_left,
BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_right,
BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_return_output);

-- BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce : 0 clocks latency
BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_left,
BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_right,
BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_return_output);

-- fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013 : 0 clocks latency
fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013 : entity work.MUX_uint1_t_uint16_t_uint16_t_0CLK_de264c78 port map (
fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_cond,
fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iftrue,
fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iffalse,
fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_return_output);

-- BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d : 0 clocks latency
BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d : entity work.BIN_OP_MINUS_uint16_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_left,
BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_right,
BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_return_output);

-- BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0 : 0 clocks latency
BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0 : entity work.BIN_OP_AND_uint1_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_left,
BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_right,
BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_return_output);



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
 BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_return_output,
 chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_return_output,
 fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_return_output,
 BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_return_output,
 BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_return_output,
 fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_return_output,
 BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_return_output,
 BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_return_output)
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
 variable VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_right : unsigned(6 downto 0);
 variable VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_chacha20_decrypt_loop_body_in_t_stream_t_data_d41d_chacha20_decrypt_c_l24_c296_e7ea_return_output : chacha20_decrypt_loop_body_in_t;
 variable VAR_fifo_wr_en : unsigned(0 downto 0);
 variable VAR_fifo_wr_data : axis512_t;
 variable VAR_fifo_rd_en : unsigned(0 downto 0);
 variable VAR_fifo_o : chacha20_decrypt_pipeline_FIFO_t;
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_ready_for_data_out : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in : axis512_t;
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in_valid : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_return_output : chacha20_decrypt_pipeline_FIFO_t;
 variable VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d_chacha20_decrypt_c_l24_c679_3072_return_output : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_axis512_t_chacha20_decrypt_pipeline_FIFO_t_data_out_d41d_chacha20_decrypt_c_l24_c739_ec4f_return_output : axis512_t;
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iftrue : unsigned(15 downto 0);
 variable VAR_fifo_count_chacha20_decrypt_c_l24_c833_7752 : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iffalse : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_return_output : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_return_output : unsigned(16 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_return_output : unsigned(0 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iftrue : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iffalse : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_return_output : unsigned(15 downto 0);
 variable VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_left : unsigned(15 downto 0);
 variable VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_return_output : unsigned(15 downto 0);
 variable VAR_chacha20_decrypt_pipeline_out_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095_chacha20_decrypt_c_l24_c6_354e_return_output : axis512_t_stream_t;
 variable VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l24_DUPLICATE_ba9f_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_left : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_return_output : unsigned(0 downto 0);
 -- State registers comb logic variables
variable REG_VAR_fifo_count : unsigned(15 downto 0);
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_fifo_count := fifo_count;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_right := to_unsigned(1, 1);
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_right := to_unsigned(1, 1);
     VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_right := to_unsigned(64, 7);
 -- Reads from global variables
     VAR_chacha20_decrypt_pipeline_in := global_to_module.chacha20_decrypt_pipeline_in;
     VAR_chacha20_decrypt_pipeline_no_handshake_out_valid := global_to_module.chacha20_decrypt_pipeline_no_handshake_out_valid;
     VAR_chacha20_decrypt_pipeline_no_handshake_out := global_to_module.chacha20_decrypt_pipeline_no_handshake_out;
     VAR_chacha20_decrypt_pipeline_out_ready := global_to_module.chacha20_decrypt_pipeline_out_ready;
     -- Submodule level 0
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in := VAR_chacha20_decrypt_pipeline_no_handshake_out;
     VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_right := VAR_chacha20_decrypt_pipeline_out_ready;
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_ready_for_data_out := VAR_chacha20_decrypt_pipeline_out_ready;
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in_valid := VAR_chacha20_decrypt_pipeline_no_handshake_out_valid;
     -- CONST_REF_RD_chacha20_decrypt_loop_body_in_t_chacha20_decrypt_loop_body_in_t_stream_t_data_d41d[chacha20_decrypt_c_l24_c296_e7ea] LATENCY=0
     VAR_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_chacha20_decrypt_loop_body_in_t_stream_t_data_d41d_chacha20_decrypt_c_l24_c296_e7ea_return_output := VAR_chacha20_decrypt_pipeline_in.data;

     -- CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l24_DUPLICATE_ba9f LATENCY=0
     VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l24_DUPLICATE_ba9f_return_output := VAR_chacha20_decrypt_pipeline_in.valid;

     -- Submodule level 1
     VAR_chacha20_decrypt_pipeline_no_handshake_in := VAR_CONST_REF_RD_chacha20_decrypt_loop_body_in_t_chacha20_decrypt_loop_body_in_t_stream_t_data_d41d_chacha20_decrypt_c_l24_c296_e7ea_return_output;
     VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_left := VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_loop_body_in_t_stream_t_valid_d41d_chacha20_decrypt_c_l24_DUPLICATE_ba9f_return_output;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_left := fifo_count;
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_left := fifo_count;
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iffalse := fifo_count;
     -- BIN_OP_LT[chacha20_decrypt_c_l24_c111_1973] LATENCY=0
     -- Inputs
     BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_left <= VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_left;
     BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_right <= VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_right;
     -- Outputs
     VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_return_output := BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_return_output;

     -- chacha20_decrypt_pipeline_FIFO[chacha20_decrypt_c_l24_c571_c43e] LATENCY=0
     -- Clock enable
     chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_CLOCK_ENABLE <= VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_CLOCK_ENABLE;
     -- Inputs
     chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_ready_for_data_out <= VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_ready_for_data_out;
     chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in <= VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in;
     chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in_valid <= VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_data_in_valid;
     -- Outputs
     VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_return_output := chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_return_output;

     -- BIN_OP_PLUS[chacha20_decrypt_c_l24_c833_62b0] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_left <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_left;
     BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_right <= VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_right;
     -- Outputs
     VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_return_output := BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_return_output;

     -- Submodule level 1
     VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_right := VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_return_output;
     VAR_chacha20_decrypt_pipeline_in_ready := VAR_BIN_OP_LT_chacha20_decrypt_c_l24_c111_1973_return_output;
     VAR_fifo_count_chacha20_decrypt_c_l24_c833_7752 := resize(VAR_BIN_OP_PLUS_chacha20_decrypt_c_l24_c833_62b0_return_output, 16);
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iftrue := VAR_fifo_count_chacha20_decrypt_c_l24_c833_7752;
     -- CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d[chacha20_decrypt_c_l24_c679_3072] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d_chacha20_decrypt_c_l24_c679_3072_return_output := VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_return_output.data_out_valid;

     -- BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0 LATENCY=0
     -- Inputs
     BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_left <= VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_left;
     BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_right <= VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_right;
     -- Outputs
     VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_return_output := BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_return_output;

     -- CONST_REF_RD_axis512_t_chacha20_decrypt_pipeline_FIFO_t_data_out_d41d[chacha20_decrypt_c_l24_c739_ec4f] LATENCY=0
     VAR_CONST_REF_RD_axis512_t_chacha20_decrypt_pipeline_FIFO_t_data_out_d41d_chacha20_decrypt_c_l24_c739_ec4f_return_output := VAR_chacha20_decrypt_pipeline_FIFO_chacha20_decrypt_c_l24_c571_c43e_return_output.data_out;

     -- Submodule level 2
     VAR_chacha20_decrypt_pipeline_no_handshake_in_valid := VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_return_output;
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_cond := VAR_BIN_OP_AND_uint1_t_uint1_t_chacha20_decrypt_c_l24_DUPLICATE_bdb0_return_output;
     VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_left := VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d_chacha20_decrypt_c_l24_c679_3072_return_output;
     -- chacha20_decrypt_pipeline_out_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095[chacha20_decrypt_c_l24_c6_354e] LATENCY=0
     VAR_chacha20_decrypt_pipeline_out_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095_chacha20_decrypt_c_l24_c6_354e_return_output := CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095(
     VAR_CONST_REF_RD_uint1_t_chacha20_decrypt_pipeline_FIFO_t_data_out_valid_d41d_chacha20_decrypt_c_l24_c679_3072_return_output,
     VAR_CONST_REF_RD_axis512_t_chacha20_decrypt_pipeline_FIFO_t_data_out_d41d_chacha20_decrypt_c_l24_c739_ec4f_return_output);

     -- fifo_count_MUX[chacha20_decrypt_c_l24_c756_b0c3] LATENCY=0
     -- Inputs
     fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_cond <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_cond;
     fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iftrue <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iftrue;
     fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iffalse <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_iffalse;
     -- Outputs
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_return_output := fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_return_output;

     -- BIN_OP_AND[chacha20_decrypt_c_l24_c855_f7ce] LATENCY=0
     -- Inputs
     BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_left <= VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_left;
     BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_right <= VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_right;
     -- Outputs
     VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_return_output := BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_return_output;

     -- Submodule level 3
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_cond := VAR_BIN_OP_AND_chacha20_decrypt_c_l24_c855_f7ce_return_output;
     VAR_chacha20_decrypt_pipeline_out := VAR_chacha20_decrypt_pipeline_out_CONST_REF_RD_axis512_t_stream_t_axis512_t_stream_t_1095_chacha20_decrypt_c_l24_c6_354e_return_output;
     VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_left := VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_return_output;
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iffalse := VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c756_b0c3_return_output;
     -- BIN_OP_MINUS[chacha20_decrypt_c_l24_c931_253d] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_left <= VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_left;
     BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_right <= VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_right;
     -- Outputs
     VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_return_output := BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_return_output;

     -- Submodule level 4
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iftrue := VAR_BIN_OP_MINUS_chacha20_decrypt_c_l24_c931_253d_return_output;
     -- fifo_count_MUX[chacha20_decrypt_c_l24_c852_7013] LATENCY=0
     -- Inputs
     fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_cond <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_cond;
     fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iftrue <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iftrue;
     fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iffalse <= VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_iffalse;
     -- Outputs
     VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_return_output := fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_return_output;

     -- Submodule level 5
     REG_VAR_fifo_count := VAR_fifo_count_MUX_chacha20_decrypt_c_l24_c852_7013_return_output;
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
