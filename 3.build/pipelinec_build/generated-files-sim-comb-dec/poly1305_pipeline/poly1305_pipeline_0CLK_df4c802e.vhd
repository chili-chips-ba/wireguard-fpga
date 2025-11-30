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
-- Submodules: 3
entity poly1305_pipeline_0CLK_df4c802e is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 global_to_module : in poly1305_pipeline_global_to_module_t;
 module_to_global : out poly1305_pipeline_module_to_global_t);
end poly1305_pipeline_0CLK_df4c802e;
architecture arch of poly1305_pipeline_0CLK_df4c802e is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- poly1305_pipeline_in_reg_func[poly1305_mac_c_l16_c60_a0e1]
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_CLOCK_ENABLE : unsigned(0 downto 0);
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_data : poly1305_mac_loop_body_in_t;
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_id : unsigned(7 downto 0);
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_valid : unsigned(0 downto 0);
signal poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_return_output : poly1305_pipeline_in_reg_t;

-- poly1305_mac_loop_body[poly1305_mac_c_l16_c179_41e1]
signal poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_inputs : poly1305_mac_loop_body_in_t;
signal poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_return_output : u320_t;

-- poly1305_pipeline_out_reg_func[poly1305_mac_c_l16_c243_a134]
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_CLOCK_ENABLE : unsigned(0 downto 0);
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_data : u320_t;
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_id : unsigned(7 downto 0);
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_valid : unsigned(0 downto 0);
signal poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_return_output : poly1305_pipeline_out_reg_t;


begin

-- SUBMODULE INSTANCES 
-- poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1 : 0 clocks latency
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1 : entity work.poly1305_pipeline_in_reg_func_0CLK_b45f1687 port map (
clk,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_CLOCK_ENABLE,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_data,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_id,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_valid,
poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_return_output);

-- poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1 : 0 clocks latency
poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1 : entity work.poly1305_mac_loop_body_0CLK_eea59ee4 port map (
poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_inputs,
poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_return_output);

-- poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134 : 0 clocks latency
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134 : entity work.poly1305_pipeline_out_reg_func_0CLK_b45f1687 port map (
clk,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_CLOCK_ENABLE,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_data,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_id,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_valid,
poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Clock cross input
 global_to_module,
 -- All submodule outputs
 poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_return_output,
 poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_return_output,
 poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_return_output)
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
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_data : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_id : unsigned(7 downto 0);
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_valid : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_return_output : poly1305_pipeline_in_reg_t;
 variable VAR_d : u320_t;
 variable VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_inputs : poly1305_mac_loop_body_in_t;
 variable VAR_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_pipeline_in_reg_t_data_d41d_poly1305_mac_c_l16_c202_385b_return_output : poly1305_mac_loop_body_in_t;
 variable VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_return_output : u320_t;
 variable VAR_o : poly1305_pipeline_out_reg_t;
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_data : u320_t;
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_id : unsigned(7 downto 0);
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_valid : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_in_reg_t_id_d41d_poly1305_mac_c_l16_c278_b984_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_in_reg_t_valid_d41d_poly1305_mac_c_l16_c284_b003_return_output : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_return_output : poly1305_pipeline_out_reg_t;
 variable VAR_CONST_REF_RD_u320_t_poly1305_pipeline_out_reg_t_data_d41d_poly1305_mac_c_l16_c319_63c0_return_output : u320_t;
 variable VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_out_reg_t_id_d41d_poly1305_mac_c_l16_c354_b7ce_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_out_reg_t_valid_d41d_poly1305_mac_c_l16_c390_2639_return_output : unsigned(0 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_id := to_unsigned(0, 8);
 -- Reads from global variables
     VAR_poly1305_pipeline_in := global_to_module.poly1305_pipeline_in;
     VAR_poly1305_pipeline_in_valid := global_to_module.poly1305_pipeline_in_valid;
     -- Submodule level 0
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_data := VAR_poly1305_pipeline_in;
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_valid := VAR_poly1305_pipeline_in_valid;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     -- poly1305_pipeline_in_reg_func[poly1305_mac_c_l16_c60_a0e1] LATENCY=0
     -- Clock enable
     poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_CLOCK_ENABLE <= VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_CLOCK_ENABLE;
     -- Inputs
     poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_data <= VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_data;
     poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_id <= VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_id;
     poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_valid <= VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_valid;
     -- Outputs
     VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_return_output := poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_return_output;

     -- Submodule level 1
     -- CONST_REF_RD_uint8_t_poly1305_pipeline_in_reg_t_id_d41d[poly1305_mac_c_l16_c278_b984] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_in_reg_t_id_d41d_poly1305_mac_c_l16_c278_b984_return_output := VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_return_output.id;

     -- CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_pipeline_in_reg_t_data_d41d[poly1305_mac_c_l16_c202_385b] LATENCY=0
     VAR_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_pipeline_in_reg_t_data_d41d_poly1305_mac_c_l16_c202_385b_return_output := VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_return_output.data;

     -- CONST_REF_RD_uint1_t_poly1305_pipeline_in_reg_t_valid_d41d[poly1305_mac_c_l16_c284_b003] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_in_reg_t_valid_d41d_poly1305_mac_c_l16_c284_b003_return_output := VAR_poly1305_pipeline_in_reg_func_poly1305_mac_c_l16_c60_a0e1_return_output.valid;

     -- Submodule level 2
     VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_inputs := VAR_CONST_REF_RD_poly1305_mac_loop_body_in_t_poly1305_pipeline_in_reg_t_data_d41d_poly1305_mac_c_l16_c202_385b_return_output;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_valid := VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_in_reg_t_valid_d41d_poly1305_mac_c_l16_c284_b003_return_output;
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_id := VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_in_reg_t_id_d41d_poly1305_mac_c_l16_c278_b984_return_output;
     -- poly1305_mac_loop_body[poly1305_mac_c_l16_c179_41e1] LATENCY=0
     -- Inputs
     poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_inputs <= VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_inputs;
     -- Outputs
     VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_return_output := poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_return_output;

     -- Submodule level 3
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_data := VAR_poly1305_mac_loop_body_poly1305_mac_c_l16_c179_41e1_return_output;
     -- poly1305_pipeline_out_reg_func[poly1305_mac_c_l16_c243_a134] LATENCY=0
     -- Clock enable
     poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_CLOCK_ENABLE <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_CLOCK_ENABLE;
     -- Inputs
     poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_data <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_data;
     poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_id <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_id;
     poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_valid <= VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_valid;
     -- Outputs
     VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_return_output := poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_return_output;

     -- Submodule level 4
     -- CONST_REF_RD_uint8_t_poly1305_pipeline_out_reg_t_id_d41d[poly1305_mac_c_l16_c354_b7ce] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_out_reg_t_id_d41d_poly1305_mac_c_l16_c354_b7ce_return_output := VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_return_output.id;

     -- CONST_REF_RD_u320_t_poly1305_pipeline_out_reg_t_data_d41d[poly1305_mac_c_l16_c319_63c0] LATENCY=0
     VAR_CONST_REF_RD_u320_t_poly1305_pipeline_out_reg_t_data_d41d_poly1305_mac_c_l16_c319_63c0_return_output := VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_return_output.data;

     -- CONST_REF_RD_uint1_t_poly1305_pipeline_out_reg_t_valid_d41d[poly1305_mac_c_l16_c390_2639] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_out_reg_t_valid_d41d_poly1305_mac_c_l16_c390_2639_return_output := VAR_poly1305_pipeline_out_reg_func_poly1305_mac_c_l16_c243_a134_return_output.valid;

     -- Submodule level 5
     VAR_poly1305_pipeline_out := VAR_CONST_REF_RD_u320_t_poly1305_pipeline_out_reg_t_data_d41d_poly1305_mac_c_l16_c319_63c0_return_output;
     VAR_poly1305_pipeline_out_valid := VAR_CONST_REF_RD_uint1_t_poly1305_pipeline_out_reg_t_valid_d41d_poly1305_mac_c_l16_c390_2639_return_output;
     VAR_poly1305_pipeline_out_id := VAR_CONST_REF_RD_uint8_t_poly1305_pipeline_out_reg_t_id_d41d_poly1305_mac_c_l16_c354_b7ce_return_output;
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

end arch;
