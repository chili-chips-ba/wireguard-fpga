-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.4859239390657177, 0.9718478781314354]
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
entity chacha20_block_step_2CLK_25c38195 is
port(
 clk : in std_logic;
 state0 : in chacha20_state;
 return_output : out chacha20_state);
end chacha20_block_step_2CLK_25c38195;
architecture arch of chacha20_block_step_2CLK_25c38195 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 2;
-- All of the wires/regs in function
-- Stage 0
-- Stage 1
-- Each function instance gets signals
-- quarter_round[chacha20_h_l54_c29_9e30]
signal quarter_round_chacha20_h_l54_c29_9e30_s : chacha20_state;
signal quarter_round_chacha20_h_l54_c29_9e30_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_9e30_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_9e30_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_9e30_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_9e30_return_output : chacha20_state;

-- quarter_round[chacha20_h_l55_c29_f3e7]
signal quarter_round_chacha20_h_l55_c29_f3e7_s : chacha20_state;
signal quarter_round_chacha20_h_l55_c29_f3e7_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_f3e7_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_f3e7_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_f3e7_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_f3e7_return_output : chacha20_state;

-- quarter_round[chacha20_h_l56_c29_4698]
signal quarter_round_chacha20_h_l56_c29_4698_s : chacha20_state;
signal quarter_round_chacha20_h_l56_c29_4698_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_4698_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_4698_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_4698_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_4698_return_output : chacha20_state;

-- quarter_round[chacha20_h_l57_c29_4e27]
signal quarter_round_chacha20_h_l57_c29_4e27_s : chacha20_state;
signal quarter_round_chacha20_h_l57_c29_4e27_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_4e27_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_4e27_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_4e27_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_4e27_return_output : chacha20_state;

-- quarter_round[chacha20_h_l58_c29_83bc]
signal quarter_round_chacha20_h_l58_c29_83bc_s : chacha20_state;
signal quarter_round_chacha20_h_l58_c29_83bc_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_83bc_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_83bc_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_83bc_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_83bc_return_output : chacha20_state;

-- quarter_round[chacha20_h_l59_c29_001e]
signal quarter_round_chacha20_h_l59_c29_001e_s : chacha20_state;
signal quarter_round_chacha20_h_l59_c29_001e_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_001e_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_001e_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_001e_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_001e_return_output : chacha20_state;

-- quarter_round[chacha20_h_l60_c29_9903]
signal quarter_round_chacha20_h_l60_c29_9903_s : chacha20_state;
signal quarter_round_chacha20_h_l60_c29_9903_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_9903_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_9903_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_9903_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_9903_return_output : chacha20_state;

-- quarter_round[chacha20_h_l61_c29_9621]
signal quarter_round_chacha20_h_l61_c29_9621_s : chacha20_state;
signal quarter_round_chacha20_h_l61_c29_9621_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_9621_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_9621_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_9621_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_9621_return_output : chacha20_state;


begin

-- SUBMODULE INSTANCES 
-- quarter_round_chacha20_h_l54_c29_9e30 : 0 clocks latency
quarter_round_chacha20_h_l54_c29_9e30 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l54_c29_9e30_s,
quarter_round_chacha20_h_l54_c29_9e30_a,
quarter_round_chacha20_h_l54_c29_9e30_b,
quarter_round_chacha20_h_l54_c29_9e30_c,
quarter_round_chacha20_h_l54_c29_9e30_d,
quarter_round_chacha20_h_l54_c29_9e30_return_output);

-- quarter_round_chacha20_h_l55_c29_f3e7 : 0 clocks latency
quarter_round_chacha20_h_l55_c29_f3e7 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l55_c29_f3e7_s,
quarter_round_chacha20_h_l55_c29_f3e7_a,
quarter_round_chacha20_h_l55_c29_f3e7_b,
quarter_round_chacha20_h_l55_c29_f3e7_c,
quarter_round_chacha20_h_l55_c29_f3e7_d,
quarter_round_chacha20_h_l55_c29_f3e7_return_output);

-- quarter_round_chacha20_h_l56_c29_4698 : 0 clocks latency
quarter_round_chacha20_h_l56_c29_4698 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l56_c29_4698_s,
quarter_round_chacha20_h_l56_c29_4698_a,
quarter_round_chacha20_h_l56_c29_4698_b,
quarter_round_chacha20_h_l56_c29_4698_c,
quarter_round_chacha20_h_l56_c29_4698_d,
quarter_round_chacha20_h_l56_c29_4698_return_output);

-- quarter_round_chacha20_h_l57_c29_4e27 : 1 clocks latency
quarter_round_chacha20_h_l57_c29_4e27 : entity work.quarter_round_1CLK_4173c403 port map (
clk,
quarter_round_chacha20_h_l57_c29_4e27_s,
quarter_round_chacha20_h_l57_c29_4e27_a,
quarter_round_chacha20_h_l57_c29_4e27_b,
quarter_round_chacha20_h_l57_c29_4e27_c,
quarter_round_chacha20_h_l57_c29_4e27_d,
quarter_round_chacha20_h_l57_c29_4e27_return_output);

-- quarter_round_chacha20_h_l58_c29_83bc : 0 clocks latency
quarter_round_chacha20_h_l58_c29_83bc : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l58_c29_83bc_s,
quarter_round_chacha20_h_l58_c29_83bc_a,
quarter_round_chacha20_h_l58_c29_83bc_b,
quarter_round_chacha20_h_l58_c29_83bc_c,
quarter_round_chacha20_h_l58_c29_83bc_d,
quarter_round_chacha20_h_l58_c29_83bc_return_output);

-- quarter_round_chacha20_h_l59_c29_001e : 0 clocks latency
quarter_round_chacha20_h_l59_c29_001e : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l59_c29_001e_s,
quarter_round_chacha20_h_l59_c29_001e_a,
quarter_round_chacha20_h_l59_c29_001e_b,
quarter_round_chacha20_h_l59_c29_001e_c,
quarter_round_chacha20_h_l59_c29_001e_d,
quarter_round_chacha20_h_l59_c29_001e_return_output);

-- quarter_round_chacha20_h_l60_c29_9903 : 0 clocks latency
quarter_round_chacha20_h_l60_c29_9903 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l60_c29_9903_s,
quarter_round_chacha20_h_l60_c29_9903_a,
quarter_round_chacha20_h_l60_c29_9903_b,
quarter_round_chacha20_h_l60_c29_9903_c,
quarter_round_chacha20_h_l60_c29_9903_d,
quarter_round_chacha20_h_l60_c29_9903_return_output);

-- quarter_round_chacha20_h_l61_c29_9621 : 1 clocks latency
quarter_round_chacha20_h_l61_c29_9621 : entity work.quarter_round_1CLK_abaad4fa port map (
clk,
quarter_round_chacha20_h_l61_c29_9621_s,
quarter_round_chacha20_h_l61_c29_9621_a,
quarter_round_chacha20_h_l61_c29_9621_b,
quarter_round_chacha20_h_l61_c29_9621_c,
quarter_round_chacha20_h_l61_c29_9621_d,
quarter_round_chacha20_h_l61_c29_9621_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 state0,
 -- Registers
 -- Stage 0
 -- Stage 1
 -- All submodule outputs
 quarter_round_chacha20_h_l54_c29_9e30_return_output,
 quarter_round_chacha20_h_l55_c29_f3e7_return_output,
 quarter_round_chacha20_h_l56_c29_4698_return_output,
 quarter_round_chacha20_h_l57_c29_4e27_return_output,
 quarter_round_chacha20_h_l58_c29_83bc_return_output,
 quarter_round_chacha20_h_l59_c29_001e_return_output,
 quarter_round_chacha20_h_l60_c29_9903_return_output,
 quarter_round_chacha20_h_l61_c29_9621_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : chacha20_state;
 variable VAR_state0 : chacha20_state;
 variable VAR_state1 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_9e30_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_9e30_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_9e30_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_9e30_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_9e30_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_9e30_return_output : chacha20_state;
 variable VAR_state2 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_f3e7_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_f3e7_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_f3e7_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_f3e7_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_f3e7_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_f3e7_return_output : chacha20_state;
 variable VAR_state3 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_4698_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_4698_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_4698_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_4698_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_4698_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_4698_return_output : chacha20_state;
 variable VAR_state4 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_4e27_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_4e27_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_4e27_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_4e27_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_4e27_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_4e27_return_output : chacha20_state;
 variable VAR_state5 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_83bc_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_83bc_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_83bc_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_83bc_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_83bc_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_83bc_return_output : chacha20_state;
 variable VAR_state6 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_001e_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_001e_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_001e_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_001e_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_001e_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_001e_return_output : chacha20_state;
 variable VAR_state7 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_9903_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_9903_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_9903_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_9903_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_9903_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_9903_return_output : chacha20_state;
 variable VAR_state8 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_9621_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_9621_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_9621_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_9621_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_9621_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_9621_return_output : chacha20_state;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l59_c29_001e_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l58_c29_83bc_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l58_c29_83bc_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l54_c29_9e30_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l59_c29_001e_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l60_c29_9903_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l55_c29_f3e7_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l58_c29_83bc_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l60_c29_9903_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l59_c29_001e_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l54_c29_9e30_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l56_c29_4698_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l60_c29_9903_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l61_c29_9621_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l57_c29_4e27_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l58_c29_83bc_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l55_c29_f3e7_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l57_c29_4e27_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l56_c29_4698_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l61_c29_9621_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l55_c29_f3e7_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l59_c29_001e_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l61_c29_9621_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l60_c29_9903_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l57_c29_4e27_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l61_c29_9621_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l56_c29_4698_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l57_c29_4e27_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l56_c29_4698_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l55_c29_f3e7_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l54_c29_9e30_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l54_c29_9e30_a := to_unsigned(0, 4);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_state0 := state0;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l54_c29_9e30_s := VAR_state0;
     -- quarter_round[chacha20_h_l54_c29_9e30] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l54_c29_9e30_s <= VAR_quarter_round_chacha20_h_l54_c29_9e30_s;
     quarter_round_chacha20_h_l54_c29_9e30_a <= VAR_quarter_round_chacha20_h_l54_c29_9e30_a;
     quarter_round_chacha20_h_l54_c29_9e30_b <= VAR_quarter_round_chacha20_h_l54_c29_9e30_b;
     quarter_round_chacha20_h_l54_c29_9e30_c <= VAR_quarter_round_chacha20_h_l54_c29_9e30_c;
     quarter_round_chacha20_h_l54_c29_9e30_d <= VAR_quarter_round_chacha20_h_l54_c29_9e30_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l54_c29_9e30_return_output := quarter_round_chacha20_h_l54_c29_9e30_return_output;

     -- Submodule level 1
     VAR_quarter_round_chacha20_h_l55_c29_f3e7_s := VAR_quarter_round_chacha20_h_l54_c29_9e30_return_output;
     -- quarter_round[chacha20_h_l55_c29_f3e7] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l55_c29_f3e7_s <= VAR_quarter_round_chacha20_h_l55_c29_f3e7_s;
     quarter_round_chacha20_h_l55_c29_f3e7_a <= VAR_quarter_round_chacha20_h_l55_c29_f3e7_a;
     quarter_round_chacha20_h_l55_c29_f3e7_b <= VAR_quarter_round_chacha20_h_l55_c29_f3e7_b;
     quarter_round_chacha20_h_l55_c29_f3e7_c <= VAR_quarter_round_chacha20_h_l55_c29_f3e7_c;
     quarter_round_chacha20_h_l55_c29_f3e7_d <= VAR_quarter_round_chacha20_h_l55_c29_f3e7_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l55_c29_f3e7_return_output := quarter_round_chacha20_h_l55_c29_f3e7_return_output;

     -- Submodule level 2
     VAR_quarter_round_chacha20_h_l56_c29_4698_s := VAR_quarter_round_chacha20_h_l55_c29_f3e7_return_output;
     -- quarter_round[chacha20_h_l56_c29_4698] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l56_c29_4698_s <= VAR_quarter_round_chacha20_h_l56_c29_4698_s;
     quarter_round_chacha20_h_l56_c29_4698_a <= VAR_quarter_round_chacha20_h_l56_c29_4698_a;
     quarter_round_chacha20_h_l56_c29_4698_b <= VAR_quarter_round_chacha20_h_l56_c29_4698_b;
     quarter_round_chacha20_h_l56_c29_4698_c <= VAR_quarter_round_chacha20_h_l56_c29_4698_c;
     quarter_round_chacha20_h_l56_c29_4698_d <= VAR_quarter_round_chacha20_h_l56_c29_4698_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l56_c29_4698_return_output := quarter_round_chacha20_h_l56_c29_4698_return_output;

     -- Submodule level 3
     VAR_quarter_round_chacha20_h_l57_c29_4e27_s := VAR_quarter_round_chacha20_h_l56_c29_4698_return_output;
     -- quarter_round[chacha20_h_l57_c29_4e27] LATENCY=1
     -- Inputs
     quarter_round_chacha20_h_l57_c29_4e27_s <= VAR_quarter_round_chacha20_h_l57_c29_4e27_s;
     quarter_round_chacha20_h_l57_c29_4e27_a <= VAR_quarter_round_chacha20_h_l57_c29_4e27_a;
     quarter_round_chacha20_h_l57_c29_4e27_b <= VAR_quarter_round_chacha20_h_l57_c29_4e27_b;
     quarter_round_chacha20_h_l57_c29_4e27_c <= VAR_quarter_round_chacha20_h_l57_c29_4e27_c;
     quarter_round_chacha20_h_l57_c29_4e27_d <= VAR_quarter_round_chacha20_h_l57_c29_4e27_d;

     -- Write to comb signals
   elsif STAGE = 1 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_quarter_round_chacha20_h_l57_c29_4e27_return_output := quarter_round_chacha20_h_l57_c29_4e27_return_output;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l58_c29_83bc_s := VAR_quarter_round_chacha20_h_l57_c29_4e27_return_output;
     -- quarter_round[chacha20_h_l58_c29_83bc] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l58_c29_83bc_s <= VAR_quarter_round_chacha20_h_l58_c29_83bc_s;
     quarter_round_chacha20_h_l58_c29_83bc_a <= VAR_quarter_round_chacha20_h_l58_c29_83bc_a;
     quarter_round_chacha20_h_l58_c29_83bc_b <= VAR_quarter_round_chacha20_h_l58_c29_83bc_b;
     quarter_round_chacha20_h_l58_c29_83bc_c <= VAR_quarter_round_chacha20_h_l58_c29_83bc_c;
     quarter_round_chacha20_h_l58_c29_83bc_d <= VAR_quarter_round_chacha20_h_l58_c29_83bc_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l58_c29_83bc_return_output := quarter_round_chacha20_h_l58_c29_83bc_return_output;

     -- Submodule level 1
     VAR_quarter_round_chacha20_h_l59_c29_001e_s := VAR_quarter_round_chacha20_h_l58_c29_83bc_return_output;
     -- quarter_round[chacha20_h_l59_c29_001e] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l59_c29_001e_s <= VAR_quarter_round_chacha20_h_l59_c29_001e_s;
     quarter_round_chacha20_h_l59_c29_001e_a <= VAR_quarter_round_chacha20_h_l59_c29_001e_a;
     quarter_round_chacha20_h_l59_c29_001e_b <= VAR_quarter_round_chacha20_h_l59_c29_001e_b;
     quarter_round_chacha20_h_l59_c29_001e_c <= VAR_quarter_round_chacha20_h_l59_c29_001e_c;
     quarter_round_chacha20_h_l59_c29_001e_d <= VAR_quarter_round_chacha20_h_l59_c29_001e_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l59_c29_001e_return_output := quarter_round_chacha20_h_l59_c29_001e_return_output;

     -- Submodule level 2
     VAR_quarter_round_chacha20_h_l60_c29_9903_s := VAR_quarter_round_chacha20_h_l59_c29_001e_return_output;
     -- quarter_round[chacha20_h_l60_c29_9903] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l60_c29_9903_s <= VAR_quarter_round_chacha20_h_l60_c29_9903_s;
     quarter_round_chacha20_h_l60_c29_9903_a <= VAR_quarter_round_chacha20_h_l60_c29_9903_a;
     quarter_round_chacha20_h_l60_c29_9903_b <= VAR_quarter_round_chacha20_h_l60_c29_9903_b;
     quarter_round_chacha20_h_l60_c29_9903_c <= VAR_quarter_round_chacha20_h_l60_c29_9903_c;
     quarter_round_chacha20_h_l60_c29_9903_d <= VAR_quarter_round_chacha20_h_l60_c29_9903_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l60_c29_9903_return_output := quarter_round_chacha20_h_l60_c29_9903_return_output;

     -- Submodule level 3
     VAR_quarter_round_chacha20_h_l61_c29_9621_s := VAR_quarter_round_chacha20_h_l60_c29_9903_return_output;
     -- quarter_round[chacha20_h_l61_c29_9621] LATENCY=1
     -- Inputs
     quarter_round_chacha20_h_l61_c29_9621_s <= VAR_quarter_round_chacha20_h_l61_c29_9621_s;
     quarter_round_chacha20_h_l61_c29_9621_a <= VAR_quarter_round_chacha20_h_l61_c29_9621_a;
     quarter_round_chacha20_h_l61_c29_9621_b <= VAR_quarter_round_chacha20_h_l61_c29_9621_b;
     quarter_round_chacha20_h_l61_c29_9621_c <= VAR_quarter_round_chacha20_h_l61_c29_9621_c;
     quarter_round_chacha20_h_l61_c29_9621_d <= VAR_quarter_round_chacha20_h_l61_c29_9621_d;

     -- Write to comb signals
   elsif STAGE = 2 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_quarter_round_chacha20_h_l61_c29_9621_return_output := quarter_round_chacha20_h_l61_c29_9621_return_output;

     -- Submodule level 0
     VAR_return_output := VAR_quarter_round_chacha20_h_l61_c29_9621_return_output;
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
 end if;
end process;

end arch;
