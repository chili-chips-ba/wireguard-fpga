-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.25, 0.5, 0.75]
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
-- Submodules: 3
entity poly1305_pipeline_3CLK_a31693b0 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in poly1305_pipeline_global_to_module_t;
 module_to_global : out poly1305_pipeline_module_to_global_t);
end poly1305_pipeline_3CLK_a31693b0;
architecture arch of poly1305_pipeline_3CLK_a31693b0 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 3;
-- All of the wires/regs in function
-- Stage 0
signal REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id : unsigned(7 downto 0);
signal REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid : unsigned(0 downto 0);
signal REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE : unsigned(0 downto 0);
signal COMB_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id : unsigned(7 downto 0);
signal COMB_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid : unsigned(0 downto 0);
signal COMB_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE : unsigned(0 downto 0);
-- Stage 1
signal REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id : unsigned(7 downto 0);
signal REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid : unsigned(0 downto 0);
signal REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE : unsigned(0 downto 0);
signal COMB_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id : unsigned(7 downto 0);
signal COMB_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid : unsigned(0 downto 0);
signal COMB_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE : unsigned(0 downto 0);
-- Stage 2
signal REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id : unsigned(7 downto 0);
signal REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid : unsigned(0 downto 0);
signal REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE : unsigned(0 downto 0);
signal COMB_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id : unsigned(7 downto 0);
signal COMB_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid : unsigned(0 downto 0);
signal COMB_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE : unsigned(0 downto 0);
-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- poly1305_pipeline_in_reg_func[poly1305_mac_c_l16_c60_ea37]
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_CLOCK_ENABLE : unsigned(0 downto 0);
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_data : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_id : unsigned(7 downto 0);
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_valid : unsigned(0 downto 0);
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_return_output : poly1305_pipeline_in_reg_t;

-- poly1305_mac_loop_body[poly1305_mac_c_l16_c179_beed]
signal poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_inputs : poly1305_mac_loop_body_in_t;
signal poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_return_output : u320_t;

-- poly1305_pipeline_out_reg_func[poly1305_mac_c_l16_c243_3918]
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE : unsigned(0 downto 0);
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_data : u320_t;
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id : unsigned(7 downto 0);
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid : unsigned(0 downto 0);
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_return_output : poly1305_pipeline_out_reg_t;


begin

-- SUBMODULE INSTANCES 
-- poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37 : 0 clocks latency
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37 : entity work.poly1305_pipeline_in_reg_func_0CLK_b45f1687 port map (
clk,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_CLOCK_ENABLE,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_data,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_id,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_valid,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_return_output);

-- poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed : 3 clocks latency
poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed : entity work.poly1305_mac_loop_body_3CLK_9ef0491b port map (
clk,
poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_inputs,
poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_return_output);

-- poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918 : 0 clocks latency
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918 : entity work.poly1305_pipeline_out_reg_func_0CLK_b45f1687 port map (
clk,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_data,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Registers
 -- Stage 0
 REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id,
 REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid,
 REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE,
 -- Stage 1
 REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id,
 REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid,
 REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE,
 -- Stage 2
 REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id,
 REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid,
 REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE,
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_return_output,
 poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_return_output,
 poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_id : unsigned(7 downto 0);
 variable VAR_poly1305_pipeline_in_valid : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_out : u320_t;
 variable VAR_poly1305_pipeline_out_id : unsigned(7 downto 0);
 variable VAR_poly1305_pipeline_out_valid : unsigned(0 downto 0);
 variable VAR_i : poly1305_pipeline_in_reg_t;
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_data : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_id : unsigned(7 downto 0);
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_valid : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_return_output : poly1305_pipeline_in_reg_t;
 variable VAR_d : u320_t;
 variable VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_inputs : poly1305_mac_loop_body_in_t;
 variable VAR_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_pipeline_in_reg_t_data_d41d_poly1305_mac_c_l16_c202_b7e8_return_output : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_return_output : u320_t;
 variable VAR_o : poly1305_pipeline_out_reg_t;
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_data : u320_t;
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id : unsigned(7 downto 0);
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_in_reg_t_id_d41d_poly1305_mac_c_l16_c278_6c78_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_in_reg_t_valid_d41d_poly1305_mac_c_l16_c284_9c05_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_return_output : poly1305_pipeline_out_reg_t;
 variable VAR_CONST_REF_RD_u320_t_poly1305_pipeline_out_reg_t_data_d41d_poly1305_mac_c_l16_c319_715a_return_output : u320_t;
 variable VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_out_reg_t_id_d41d_poly1305_mac_c_l16_c354_c799_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_out_reg_t_valid_d41d_poly1305_mac_c_l16_c390_e335_return_output : unsigned(0 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_id := to_unsigned(0, 8);
 -- Reads from global variables
     VAR_poly1305_pipeline_in := global_to_module.poly1305_pipeline_in;
     VAR_poly1305_pipeline_in_valid := global_to_module.poly1305_pipeline_in_valid;
     -- Submodule level 0
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_data := VAR_poly1305_pipeline_in;
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_valid := VAR_poly1305_pipeline_in_valid;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     -- poly1305_pipeline_in_reg_func[poly1305_mac_c_l16_c60_ea37] LATENCY=0
     -- Clock enable
     poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_CLOCK_ENABLE <= VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_CLOCK_ENABLE;
     -- Inputs
     poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_data <= VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_data;
     poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_id <= VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_id;
     poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_valid <= VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_valid;
     -- Outputs
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_return_output := poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_return_output;

     -- Submodule level 1
     -- CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_pipeline_in_reg_t_data_d41d[poly1305_mac_c_l16_c202_b7e8] LATENCY=0
     VAR_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_pipeline_in_reg_t_data_d41d_poly1305_mac_c_l16_c202_b7e8_return_output := VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_return_output.data;

     -- CONST_REF_RD_uint8_t_poly1305_pipeline_in_reg_t_id_d41d[poly1305_mac_c_l16_c278_6c78] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_in_reg_t_id_d41d_poly1305_mac_c_l16_c278_6c78_return_output := VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_return_output.id;

     -- CONST_REF_RD_uint1_t_poly1305_pipeline_in_reg_t_valid_d41d[poly1305_mac_c_l16_c284_9c05] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_in_reg_t_valid_d41d_poly1305_mac_c_l16_c284_9c05_return_output := VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_ea37_return_output.valid;

     -- Submodule level 2
     VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_inputs := VAR_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_pipeline_in_reg_t_data_d41d_poly1305_mac_c_l16_c202_b7e8_return_output;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid := VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_in_reg_t_valid_d41d_poly1305_mac_c_l16_c284_9c05_return_output;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id := VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_in_reg_t_id_d41d_poly1305_mac_c_l16_c278_6c78_return_output;
     -- poly1305_mac_loop_body[poly1305_mac_c_l16_c179_beed] LATENCY=3
     -- Inputs
     poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_inputs <= VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_inputs;

     -- Write to comb signals
     COMB_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     COMB_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     COMB_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;
   elsif STAGE = 1 then
     -- Read from prev stage
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id := REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid := REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE := REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;

     -- Write to comb signals
     COMB_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     COMB_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     COMB_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;
   elsif STAGE = 2 then
     -- Read from prev stage
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id := REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid := REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE := REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;

     -- Write to comb signals
     COMB_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     COMB_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     COMB_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;
   elsif STAGE = 3 then
     -- Read from prev stage
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id := REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid := REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE := REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;
     -- Submodule outputs
     VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_return_output := poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_return_output;

     -- Submodule level 0
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_data := VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_beed_return_output;
     -- poly1305_pipeline_out_reg_func[poly1305_mac_c_l16_c243_3918] LATENCY=0
     -- Clock enable
     poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;
     -- Inputs
     poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_data <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_data;
     poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     -- Outputs
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_return_output := poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_return_output;

     -- Submodule level 1
     -- CONST_REF_RD_uint8_t_poly1305_pipeline_out_reg_t_id_d41d[poly1305_mac_c_l16_c354_c799] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_out_reg_t_id_d41d_poly1305_mac_c_l16_c354_c799_return_output := VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_return_output.id;

     -- CONST_REF_RD_u320_t_poly1305_pipeline_out_reg_t_data_d41d[poly1305_mac_c_l16_c319_715a] LATENCY=0
     VAR_CONST_REF_RD_u320_t_poly1305_pipeline_out_reg_t_data_d41d_poly1305_mac_c_l16_c319_715a_return_output := VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_return_output.data;

     -- CONST_REF_RD_uint1_t_poly1305_pipeline_out_reg_t_valid_d41d[poly1305_mac_c_l16_c390_e335] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_out_reg_t_valid_d41d_poly1305_mac_c_l16_c390_e335_return_output := VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_return_output.valid;

     -- Submodule level 2
     VAR_poly1305_pipeline_out := VAR_CONST_REF_RD_u320_t_poly1305_pipeline_out_reg_t_data_d41d_poly1305_mac_c_l16_c319_715a_return_output;
     VAR_poly1305_pipeline_out_valid := VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_out_reg_t_valid_d41d_poly1305_mac_c_l16_c390_e335_return_output;
     VAR_poly1305_pipeline_out_id := VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_out_reg_t_id_d41d_poly1305_mac_c_l16_c354_c799_return_output;
   end if;
 end loop;

-- Global wires driven various places in pipeline
if clk_en_internal='1' then
  module_to_global.poly1305_pipeline_out <= VAR_poly1305_pipeline_out;
else
  module_to_global.poly1305_pipeline_out <= u320_t_NULL;
end if;
if clk_en_internal='1' then
  module_to_global.poly1305_pipeline_out_valid <= VAR_poly1305_pipeline_out_valid;
else
  module_to_global.poly1305_pipeline_out_valid <= to_unsigned(0, 1);
end if;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     -- Stage 0
     REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id <= COMB_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid <= COMB_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     REG_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE <= COMB_STAGE0_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;
     -- Stage 1
     REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id <= COMB_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid <= COMB_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     REG_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE <= COMB_STAGE1_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;
     -- Stage 2
     REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id <= COMB_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_id;
     REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid <= COMB_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_valid;
     REG_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE <= COMB_STAGE2_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_3918_CLOCK_ENABLE;
 end if;
 end if;
end process;

end arch;
