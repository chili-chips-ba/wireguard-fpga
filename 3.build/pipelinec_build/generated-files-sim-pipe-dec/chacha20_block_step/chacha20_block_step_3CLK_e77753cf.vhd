-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.04705346392893189, 0.42499430542448874, 0.8029351469200463]
--   Input regs?: False
--   Output regs?: False
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.c_structs_pkg.all;
-- Submodules: 8
entity chacha20_block_step_3CLK_e77753cf is
port(
 clk : in std_logic;
 state0 : in chacha20_state;
 return_output : out chacha20_state);
end chacha20_block_step_3CLK_e77753cf;
architecture arch of chacha20_block_step_3CLK_e77753cf is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 3;
-- All of the wires/regs in function
-- Stage 0
-- Stage 1
-- Stage 2
-- Each function instance gets signals
-- quarter_round[chacha20_h_l54_c29_86e0]
signal quarter_round_chacha20_h_l54_c29_86e0_s : chacha20_state;
signal quarter_round_chacha20_h_l54_c29_86e0_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_86e0_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_86e0_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_86e0_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_86e0_return_output : chacha20_state;

-- quarter_round[chacha20_h_l55_c29_7841]
signal quarter_round_chacha20_h_l55_c29_7841_s : chacha20_state;
signal quarter_round_chacha20_h_l55_c29_7841_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_7841_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_7841_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_7841_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_7841_return_output : chacha20_state;

-- quarter_round[chacha20_h_l56_c29_a9cd]
signal quarter_round_chacha20_h_l56_c29_a9cd_s : chacha20_state;
signal quarter_round_chacha20_h_l56_c29_a9cd_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_a9cd_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_a9cd_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_a9cd_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_a9cd_return_output : chacha20_state;

-- quarter_round[chacha20_h_l57_c29_8af7]
signal quarter_round_chacha20_h_l57_c29_8af7_s : chacha20_state;
signal quarter_round_chacha20_h_l57_c29_8af7_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_8af7_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_8af7_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_8af7_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_8af7_return_output : chacha20_state;

-- quarter_round[chacha20_h_l58_c29_15e7]
signal quarter_round_chacha20_h_l58_c29_15e7_s : chacha20_state;
signal quarter_round_chacha20_h_l58_c29_15e7_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_15e7_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_15e7_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_15e7_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_15e7_return_output : chacha20_state;

-- quarter_round[chacha20_h_l59_c29_2c11]
signal quarter_round_chacha20_h_l59_c29_2c11_s : chacha20_state;
signal quarter_round_chacha20_h_l59_c29_2c11_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_2c11_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_2c11_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_2c11_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_2c11_return_output : chacha20_state;

-- quarter_round[chacha20_h_l60_c29_2934]
signal quarter_round_chacha20_h_l60_c29_2934_s : chacha20_state;
signal quarter_round_chacha20_h_l60_c29_2934_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_2934_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_2934_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_2934_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_2934_return_output : chacha20_state;

-- quarter_round[chacha20_h_l61_c29_0bba]
signal quarter_round_chacha20_h_l61_c29_0bba_s : chacha20_state;
signal quarter_round_chacha20_h_l61_c29_0bba_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_0bba_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_0bba_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_0bba_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_0bba_return_output : chacha20_state;


begin

-- SUBMODULE INSTANCES 
-- quarter_round_chacha20_h_l54_c29_86e0 : 1 clocks latency
quarter_round_chacha20_h_l54_c29_86e0 : entity work.quarter_round_1CLK_5d6a76b1 port map (
clk,
quarter_round_chacha20_h_l54_c29_86e0_s,
quarter_round_chacha20_h_l54_c29_86e0_a,
quarter_round_chacha20_h_l54_c29_86e0_b,
quarter_round_chacha20_h_l54_c29_86e0_c,
quarter_round_chacha20_h_l54_c29_86e0_d,
quarter_round_chacha20_h_l54_c29_86e0_return_output);

-- quarter_round_chacha20_h_l55_c29_7841 : 0 clocks latency
quarter_round_chacha20_h_l55_c29_7841 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l55_c29_7841_s,
quarter_round_chacha20_h_l55_c29_7841_a,
quarter_round_chacha20_h_l55_c29_7841_b,
quarter_round_chacha20_h_l55_c29_7841_c,
quarter_round_chacha20_h_l55_c29_7841_d,
quarter_round_chacha20_h_l55_c29_7841_return_output);

-- quarter_round_chacha20_h_l56_c29_a9cd : 0 clocks latency
quarter_round_chacha20_h_l56_c29_a9cd : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l56_c29_a9cd_s,
quarter_round_chacha20_h_l56_c29_a9cd_a,
quarter_round_chacha20_h_l56_c29_a9cd_b,
quarter_round_chacha20_h_l56_c29_a9cd_c,
quarter_round_chacha20_h_l56_c29_a9cd_d,
quarter_round_chacha20_h_l56_c29_a9cd_return_output);

-- quarter_round_chacha20_h_l57_c29_8af7 : 1 clocks latency
quarter_round_chacha20_h_l57_c29_8af7 : entity work.quarter_round_1CLK_2b619eed port map (
clk,
quarter_round_chacha20_h_l57_c29_8af7_s,
quarter_round_chacha20_h_l57_c29_8af7_a,
quarter_round_chacha20_h_l57_c29_8af7_b,
quarter_round_chacha20_h_l57_c29_8af7_c,
quarter_round_chacha20_h_l57_c29_8af7_d,
quarter_round_chacha20_h_l57_c29_8af7_return_output);

-- quarter_round_chacha20_h_l58_c29_15e7 : 0 clocks latency
quarter_round_chacha20_h_l58_c29_15e7 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l58_c29_15e7_s,
quarter_round_chacha20_h_l58_c29_15e7_a,
quarter_round_chacha20_h_l58_c29_15e7_b,
quarter_round_chacha20_h_l58_c29_15e7_c,
quarter_round_chacha20_h_l58_c29_15e7_d,
quarter_round_chacha20_h_l58_c29_15e7_return_output);

-- quarter_round_chacha20_h_l59_c29_2c11 : 0 clocks latency
quarter_round_chacha20_h_l59_c29_2c11 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l59_c29_2c11_s,
quarter_round_chacha20_h_l59_c29_2c11_a,
quarter_round_chacha20_h_l59_c29_2c11_b,
quarter_round_chacha20_h_l59_c29_2c11_c,
quarter_round_chacha20_h_l59_c29_2c11_d,
quarter_round_chacha20_h_l59_c29_2c11_return_output);

-- quarter_round_chacha20_h_l60_c29_2934 : 1 clocks latency
quarter_round_chacha20_h_l60_c29_2934 : entity work.quarter_round_1CLK_f0d269bc port map (
clk,
quarter_round_chacha20_h_l60_c29_2934_s,
quarter_round_chacha20_h_l60_c29_2934_a,
quarter_round_chacha20_h_l60_c29_2934_b,
quarter_round_chacha20_h_l60_c29_2934_c,
quarter_round_chacha20_h_l60_c29_2934_d,
quarter_round_chacha20_h_l60_c29_2934_return_output);

-- quarter_round_chacha20_h_l61_c29_0bba : 0 clocks latency
quarter_round_chacha20_h_l61_c29_0bba : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l61_c29_0bba_s,
quarter_round_chacha20_h_l61_c29_0bba_a,
quarter_round_chacha20_h_l61_c29_0bba_b,
quarter_round_chacha20_h_l61_c29_0bba_c,
quarter_round_chacha20_h_l61_c29_0bba_d,
quarter_round_chacha20_h_l61_c29_0bba_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 state0,
 -- Registers
 -- Stage 0
 -- Stage 1
 -- Stage 2
 -- All submodule outputs
 quarter_round_chacha20_h_l54_c29_86e0_return_output,
 quarter_round_chacha20_h_l55_c29_7841_return_output,
 quarter_round_chacha20_h_l56_c29_a9cd_return_output,
 quarter_round_chacha20_h_l57_c29_8af7_return_output,
 quarter_round_chacha20_h_l58_c29_15e7_return_output,
 quarter_round_chacha20_h_l59_c29_2c11_return_output,
 quarter_round_chacha20_h_l60_c29_2934_return_output,
 quarter_round_chacha20_h_l61_c29_0bba_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : chacha20_state;
 variable VAR_state0 : chacha20_state;
 variable VAR_state1 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_86e0_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_86e0_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_86e0_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_86e0_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_86e0_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_86e0_return_output : chacha20_state;
 variable VAR_state2 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_7841_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_7841_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_7841_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_7841_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_7841_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_7841_return_output : chacha20_state;
 variable VAR_state3 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_a9cd_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_a9cd_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_a9cd_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_a9cd_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_a9cd_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_a9cd_return_output : chacha20_state;
 variable VAR_state4 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_8af7_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_8af7_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_8af7_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_8af7_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_8af7_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_8af7_return_output : chacha20_state;
 variable VAR_state5 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_15e7_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_15e7_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_15e7_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_15e7_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_15e7_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_15e7_return_output : chacha20_state;
 variable VAR_state6 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_2c11_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_2c11_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_2c11_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_2c11_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_2c11_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_2c11_return_output : chacha20_state;
 variable VAR_state7 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_2934_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_2934_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_2934_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_2934_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_2934_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_2934_return_output : chacha20_state;
 variable VAR_state8 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_0bba_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_0bba_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_0bba_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_0bba_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_0bba_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_0bba_return_output : chacha20_state;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l59_c29_2c11_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l54_c29_86e0_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l57_c29_8af7_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l61_c29_0bba_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l55_c29_7841_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l55_c29_7841_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l60_c29_2934_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l54_c29_86e0_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l55_c29_7841_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l58_c29_15e7_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l59_c29_2c11_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l60_c29_2934_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l55_c29_7841_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l57_c29_8af7_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l56_c29_a9cd_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l56_c29_a9cd_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l57_c29_8af7_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l54_c29_86e0_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l57_c29_8af7_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l56_c29_a9cd_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l56_c29_a9cd_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l61_c29_0bba_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l58_c29_15e7_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l54_c29_86e0_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l59_c29_2c11_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l60_c29_2934_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l58_c29_15e7_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l61_c29_0bba_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l58_c29_15e7_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l61_c29_0bba_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l59_c29_2c11_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l60_c29_2934_c := to_unsigned(8, 4);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_state0 := state0;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l54_c29_86e0_s := VAR_state0;
     -- quarter_round[chacha20_h_l54_c29_86e0] LATENCY=1
     -- Inputs
     quarter_round_chacha20_h_l54_c29_86e0_s <= VAR_quarter_round_chacha20_h_l54_c29_86e0_s;
     quarter_round_chacha20_h_l54_c29_86e0_a <= VAR_quarter_round_chacha20_h_l54_c29_86e0_a;
     quarter_round_chacha20_h_l54_c29_86e0_b <= VAR_quarter_round_chacha20_h_l54_c29_86e0_b;
     quarter_round_chacha20_h_l54_c29_86e0_c <= VAR_quarter_round_chacha20_h_l54_c29_86e0_c;
     quarter_round_chacha20_h_l54_c29_86e0_d <= VAR_quarter_round_chacha20_h_l54_c29_86e0_d;

     -- Write to comb signals
   elsif STAGE = 1 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_quarter_round_chacha20_h_l54_c29_86e0_return_output := quarter_round_chacha20_h_l54_c29_86e0_return_output;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l55_c29_7841_s := VAR_quarter_round_chacha20_h_l54_c29_86e0_return_output;
     -- quarter_round[chacha20_h_l55_c29_7841] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l55_c29_7841_s <= VAR_quarter_round_chacha20_h_l55_c29_7841_s;
     quarter_round_chacha20_h_l55_c29_7841_a <= VAR_quarter_round_chacha20_h_l55_c29_7841_a;
     quarter_round_chacha20_h_l55_c29_7841_b <= VAR_quarter_round_chacha20_h_l55_c29_7841_b;
     quarter_round_chacha20_h_l55_c29_7841_c <= VAR_quarter_round_chacha20_h_l55_c29_7841_c;
     quarter_round_chacha20_h_l55_c29_7841_d <= VAR_quarter_round_chacha20_h_l55_c29_7841_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l55_c29_7841_return_output := quarter_round_chacha20_h_l55_c29_7841_return_output;

     -- Submodule level 1
     VAR_quarter_round_chacha20_h_l56_c29_a9cd_s := VAR_quarter_round_chacha20_h_l55_c29_7841_return_output;
     -- quarter_round[chacha20_h_l56_c29_a9cd] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l56_c29_a9cd_s <= VAR_quarter_round_chacha20_h_l56_c29_a9cd_s;
     quarter_round_chacha20_h_l56_c29_a9cd_a <= VAR_quarter_round_chacha20_h_l56_c29_a9cd_a;
     quarter_round_chacha20_h_l56_c29_a9cd_b <= VAR_quarter_round_chacha20_h_l56_c29_a9cd_b;
     quarter_round_chacha20_h_l56_c29_a9cd_c <= VAR_quarter_round_chacha20_h_l56_c29_a9cd_c;
     quarter_round_chacha20_h_l56_c29_a9cd_d <= VAR_quarter_round_chacha20_h_l56_c29_a9cd_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l56_c29_a9cd_return_output := quarter_round_chacha20_h_l56_c29_a9cd_return_output;

     -- Submodule level 2
     VAR_quarter_round_chacha20_h_l57_c29_8af7_s := VAR_quarter_round_chacha20_h_l56_c29_a9cd_return_output;
     -- quarter_round[chacha20_h_l57_c29_8af7] LATENCY=1
     -- Inputs
     quarter_round_chacha20_h_l57_c29_8af7_s <= VAR_quarter_round_chacha20_h_l57_c29_8af7_s;
     quarter_round_chacha20_h_l57_c29_8af7_a <= VAR_quarter_round_chacha20_h_l57_c29_8af7_a;
     quarter_round_chacha20_h_l57_c29_8af7_b <= VAR_quarter_round_chacha20_h_l57_c29_8af7_b;
     quarter_round_chacha20_h_l57_c29_8af7_c <= VAR_quarter_round_chacha20_h_l57_c29_8af7_c;
     quarter_round_chacha20_h_l57_c29_8af7_d <= VAR_quarter_round_chacha20_h_l57_c29_8af7_d;

     -- Write to comb signals
   elsif STAGE = 2 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_quarter_round_chacha20_h_l57_c29_8af7_return_output := quarter_round_chacha20_h_l57_c29_8af7_return_output;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l58_c29_15e7_s := VAR_quarter_round_chacha20_h_l57_c29_8af7_return_output;
     -- quarter_round[chacha20_h_l58_c29_15e7] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l58_c29_15e7_s <= VAR_quarter_round_chacha20_h_l58_c29_15e7_s;
     quarter_round_chacha20_h_l58_c29_15e7_a <= VAR_quarter_round_chacha20_h_l58_c29_15e7_a;
     quarter_round_chacha20_h_l58_c29_15e7_b <= VAR_quarter_round_chacha20_h_l58_c29_15e7_b;
     quarter_round_chacha20_h_l58_c29_15e7_c <= VAR_quarter_round_chacha20_h_l58_c29_15e7_c;
     quarter_round_chacha20_h_l58_c29_15e7_d <= VAR_quarter_round_chacha20_h_l58_c29_15e7_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l58_c29_15e7_return_output := quarter_round_chacha20_h_l58_c29_15e7_return_output;

     -- Submodule level 1
     VAR_quarter_round_chacha20_h_l59_c29_2c11_s := VAR_quarter_round_chacha20_h_l58_c29_15e7_return_output;
     -- quarter_round[chacha20_h_l59_c29_2c11] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l59_c29_2c11_s <= VAR_quarter_round_chacha20_h_l59_c29_2c11_s;
     quarter_round_chacha20_h_l59_c29_2c11_a <= VAR_quarter_round_chacha20_h_l59_c29_2c11_a;
     quarter_round_chacha20_h_l59_c29_2c11_b <= VAR_quarter_round_chacha20_h_l59_c29_2c11_b;
     quarter_round_chacha20_h_l59_c29_2c11_c <= VAR_quarter_round_chacha20_h_l59_c29_2c11_c;
     quarter_round_chacha20_h_l59_c29_2c11_d <= VAR_quarter_round_chacha20_h_l59_c29_2c11_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l59_c29_2c11_return_output := quarter_round_chacha20_h_l59_c29_2c11_return_output;

     -- Submodule level 2
     VAR_quarter_round_chacha20_h_l60_c29_2934_s := VAR_quarter_round_chacha20_h_l59_c29_2c11_return_output;
     -- quarter_round[chacha20_h_l60_c29_2934] LATENCY=1
     -- Inputs
     quarter_round_chacha20_h_l60_c29_2934_s <= VAR_quarter_round_chacha20_h_l60_c29_2934_s;
     quarter_round_chacha20_h_l60_c29_2934_a <= VAR_quarter_round_chacha20_h_l60_c29_2934_a;
     quarter_round_chacha20_h_l60_c29_2934_b <= VAR_quarter_round_chacha20_h_l60_c29_2934_b;
     quarter_round_chacha20_h_l60_c29_2934_c <= VAR_quarter_round_chacha20_h_l60_c29_2934_c;
     quarter_round_chacha20_h_l60_c29_2934_d <= VAR_quarter_round_chacha20_h_l60_c29_2934_d;

     -- Write to comb signals
   elsif STAGE = 3 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_quarter_round_chacha20_h_l60_c29_2934_return_output := quarter_round_chacha20_h_l60_c29_2934_return_output;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l61_c29_0bba_s := VAR_quarter_round_chacha20_h_l60_c29_2934_return_output;
     -- quarter_round[chacha20_h_l61_c29_0bba] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l61_c29_0bba_s <= VAR_quarter_round_chacha20_h_l61_c29_0bba_s;
     quarter_round_chacha20_h_l61_c29_0bba_a <= VAR_quarter_round_chacha20_h_l61_c29_0bba_a;
     quarter_round_chacha20_h_l61_c29_0bba_b <= VAR_quarter_round_chacha20_h_l61_c29_0bba_b;
     quarter_round_chacha20_h_l61_c29_0bba_c <= VAR_quarter_round_chacha20_h_l61_c29_0bba_c;
     quarter_round_chacha20_h_l61_c29_0bba_d <= VAR_quarter_round_chacha20_h_l61_c29_0bba_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l61_c29_0bba_return_output := quarter_round_chacha20_h_l61_c29_0bba_return_output;

     -- Submodule level 1
     VAR_return_output := VAR_quarter_round_chacha20_h_l61_c29_0bba_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
     -- Stage 0
     -- Stage 1
     -- Stage 2
 end if;
end process;

end arch;
