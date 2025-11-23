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
-- Submodules: 8
entity chacha20_block_step_0CLK_1e73dead is
port(
 state0 : in chacha20_state;
 return_output : out chacha20_state);
end chacha20_block_step_0CLK_1e73dead;
architecture arch of chacha20_block_step_0CLK_1e73dead is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- quarter_round[chacha20_h_l54_c29_680a]
signal quarter_round_chacha20_h_l54_c29_680a_s : chacha20_state;
signal quarter_round_chacha20_h_l54_c29_680a_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_680a_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_680a_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_680a_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_680a_return_output : chacha20_state;

-- quarter_round[chacha20_h_l55_c29_3f06]
signal quarter_round_chacha20_h_l55_c29_3f06_s : chacha20_state;
signal quarter_round_chacha20_h_l55_c29_3f06_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_3f06_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_3f06_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_3f06_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_3f06_return_output : chacha20_state;

-- quarter_round[chacha20_h_l56_c29_6ea7]
signal quarter_round_chacha20_h_l56_c29_6ea7_s : chacha20_state;
signal quarter_round_chacha20_h_l56_c29_6ea7_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_6ea7_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_6ea7_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_6ea7_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_6ea7_return_output : chacha20_state;

-- quarter_round[chacha20_h_l57_c29_344e]
signal quarter_round_chacha20_h_l57_c29_344e_s : chacha20_state;
signal quarter_round_chacha20_h_l57_c29_344e_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_344e_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_344e_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_344e_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_344e_return_output : chacha20_state;

-- quarter_round[chacha20_h_l58_c29_3b8b]
signal quarter_round_chacha20_h_l58_c29_3b8b_s : chacha20_state;
signal quarter_round_chacha20_h_l58_c29_3b8b_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_3b8b_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_3b8b_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_3b8b_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_3b8b_return_output : chacha20_state;

-- quarter_round[chacha20_h_l59_c29_3a31]
signal quarter_round_chacha20_h_l59_c29_3a31_s : chacha20_state;
signal quarter_round_chacha20_h_l59_c29_3a31_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_3a31_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_3a31_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_3a31_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_3a31_return_output : chacha20_state;

-- quarter_round[chacha20_h_l60_c29_5cfe]
signal quarter_round_chacha20_h_l60_c29_5cfe_s : chacha20_state;
signal quarter_round_chacha20_h_l60_c29_5cfe_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_5cfe_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_5cfe_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_5cfe_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_5cfe_return_output : chacha20_state;

-- quarter_round[chacha20_h_l61_c29_5507]
signal quarter_round_chacha20_h_l61_c29_5507_s : chacha20_state;
signal quarter_round_chacha20_h_l61_c29_5507_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_5507_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_5507_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_5507_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_5507_return_output : chacha20_state;


begin

-- SUBMODULE INSTANCES 
-- quarter_round_chacha20_h_l54_c29_680a : 0 clocks latency
quarter_round_chacha20_h_l54_c29_680a : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l54_c29_680a_s,
quarter_round_chacha20_h_l54_c29_680a_a,
quarter_round_chacha20_h_l54_c29_680a_b,
quarter_round_chacha20_h_l54_c29_680a_c,
quarter_round_chacha20_h_l54_c29_680a_d,
quarter_round_chacha20_h_l54_c29_680a_return_output);

-- quarter_round_chacha20_h_l55_c29_3f06 : 0 clocks latency
quarter_round_chacha20_h_l55_c29_3f06 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l55_c29_3f06_s,
quarter_round_chacha20_h_l55_c29_3f06_a,
quarter_round_chacha20_h_l55_c29_3f06_b,
quarter_round_chacha20_h_l55_c29_3f06_c,
quarter_round_chacha20_h_l55_c29_3f06_d,
quarter_round_chacha20_h_l55_c29_3f06_return_output);

-- quarter_round_chacha20_h_l56_c29_6ea7 : 0 clocks latency
quarter_round_chacha20_h_l56_c29_6ea7 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l56_c29_6ea7_s,
quarter_round_chacha20_h_l56_c29_6ea7_a,
quarter_round_chacha20_h_l56_c29_6ea7_b,
quarter_round_chacha20_h_l56_c29_6ea7_c,
quarter_round_chacha20_h_l56_c29_6ea7_d,
quarter_round_chacha20_h_l56_c29_6ea7_return_output);

-- quarter_round_chacha20_h_l57_c29_344e : 0 clocks latency
quarter_round_chacha20_h_l57_c29_344e : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l57_c29_344e_s,
quarter_round_chacha20_h_l57_c29_344e_a,
quarter_round_chacha20_h_l57_c29_344e_b,
quarter_round_chacha20_h_l57_c29_344e_c,
quarter_round_chacha20_h_l57_c29_344e_d,
quarter_round_chacha20_h_l57_c29_344e_return_output);

-- quarter_round_chacha20_h_l58_c29_3b8b : 0 clocks latency
quarter_round_chacha20_h_l58_c29_3b8b : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l58_c29_3b8b_s,
quarter_round_chacha20_h_l58_c29_3b8b_a,
quarter_round_chacha20_h_l58_c29_3b8b_b,
quarter_round_chacha20_h_l58_c29_3b8b_c,
quarter_round_chacha20_h_l58_c29_3b8b_d,
quarter_round_chacha20_h_l58_c29_3b8b_return_output);

-- quarter_round_chacha20_h_l59_c29_3a31 : 0 clocks latency
quarter_round_chacha20_h_l59_c29_3a31 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l59_c29_3a31_s,
quarter_round_chacha20_h_l59_c29_3a31_a,
quarter_round_chacha20_h_l59_c29_3a31_b,
quarter_round_chacha20_h_l59_c29_3a31_c,
quarter_round_chacha20_h_l59_c29_3a31_d,
quarter_round_chacha20_h_l59_c29_3a31_return_output);

-- quarter_round_chacha20_h_l60_c29_5cfe : 0 clocks latency
quarter_round_chacha20_h_l60_c29_5cfe : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l60_c29_5cfe_s,
quarter_round_chacha20_h_l60_c29_5cfe_a,
quarter_round_chacha20_h_l60_c29_5cfe_b,
quarter_round_chacha20_h_l60_c29_5cfe_c,
quarter_round_chacha20_h_l60_c29_5cfe_d,
quarter_round_chacha20_h_l60_c29_5cfe_return_output);

-- quarter_round_chacha20_h_l61_c29_5507 : 0 clocks latency
quarter_round_chacha20_h_l61_c29_5507 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l61_c29_5507_s,
quarter_round_chacha20_h_l61_c29_5507_a,
quarter_round_chacha20_h_l61_c29_5507_b,
quarter_round_chacha20_h_l61_c29_5507_c,
quarter_round_chacha20_h_l61_c29_5507_d,
quarter_round_chacha20_h_l61_c29_5507_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 state0,
 -- All submodule outputs
 quarter_round_chacha20_h_l54_c29_680a_return_output,
 quarter_round_chacha20_h_l55_c29_3f06_return_output,
 quarter_round_chacha20_h_l56_c29_6ea7_return_output,
 quarter_round_chacha20_h_l57_c29_344e_return_output,
 quarter_round_chacha20_h_l58_c29_3b8b_return_output,
 quarter_round_chacha20_h_l59_c29_3a31_return_output,
 quarter_round_chacha20_h_l60_c29_5cfe_return_output,
 quarter_round_chacha20_h_l61_c29_5507_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : chacha20_state;
 variable VAR_state0 : chacha20_state;
 variable VAR_state1 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_680a_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_680a_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_680a_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_680a_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_680a_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_680a_return_output : chacha20_state;
 variable VAR_state2 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_3f06_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_3f06_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_3f06_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_3f06_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_3f06_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_3f06_return_output : chacha20_state;
 variable VAR_state3 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_6ea7_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_6ea7_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_6ea7_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_6ea7_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_6ea7_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_6ea7_return_output : chacha20_state;
 variable VAR_state4 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_344e_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_344e_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_344e_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_344e_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_344e_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_344e_return_output : chacha20_state;
 variable VAR_state5 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_3b8b_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_3b8b_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_3b8b_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_3b8b_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_3b8b_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_3b8b_return_output : chacha20_state;
 variable VAR_state6 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_3a31_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_3a31_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_3a31_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_3a31_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_3a31_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_3a31_return_output : chacha20_state;
 variable VAR_state7 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_5cfe_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_5cfe_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_5cfe_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_5cfe_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_5cfe_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_5cfe_return_output : chacha20_state;
 variable VAR_state8 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_5507_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_5507_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_5507_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_5507_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_5507_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_5507_return_output : chacha20_state;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l61_c29_5507_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l55_c29_3f06_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l56_c29_6ea7_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l57_c29_344e_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l59_c29_3a31_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l59_c29_3a31_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l60_c29_5cfe_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l54_c29_680a_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l54_c29_680a_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l55_c29_3f06_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l61_c29_5507_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l57_c29_344e_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l60_c29_5cfe_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l59_c29_3a31_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l55_c29_3f06_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l61_c29_5507_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l55_c29_3f06_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l57_c29_344e_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l60_c29_5cfe_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l59_c29_3a31_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l58_c29_3b8b_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l54_c29_680a_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l58_c29_3b8b_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l58_c29_3b8b_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l56_c29_6ea7_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l56_c29_6ea7_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l57_c29_344e_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l56_c29_6ea7_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l54_c29_680a_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l61_c29_5507_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l60_c29_5cfe_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l58_c29_3b8b_b := to_unsigned(5, 4);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_state0 := state0;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l54_c29_680a_s := VAR_state0;
     -- quarter_round[chacha20_h_l54_c29_680a] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l54_c29_680a_s <= VAR_quarter_round_chacha20_h_l54_c29_680a_s;
     quarter_round_chacha20_h_l54_c29_680a_a <= VAR_quarter_round_chacha20_h_l54_c29_680a_a;
     quarter_round_chacha20_h_l54_c29_680a_b <= VAR_quarter_round_chacha20_h_l54_c29_680a_b;
     quarter_round_chacha20_h_l54_c29_680a_c <= VAR_quarter_round_chacha20_h_l54_c29_680a_c;
     quarter_round_chacha20_h_l54_c29_680a_d <= VAR_quarter_round_chacha20_h_l54_c29_680a_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l54_c29_680a_return_output := quarter_round_chacha20_h_l54_c29_680a_return_output;

     -- Submodule level 1
     VAR_quarter_round_chacha20_h_l55_c29_3f06_s := VAR_quarter_round_chacha20_h_l54_c29_680a_return_output;
     -- quarter_round[chacha20_h_l55_c29_3f06] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l55_c29_3f06_s <= VAR_quarter_round_chacha20_h_l55_c29_3f06_s;
     quarter_round_chacha20_h_l55_c29_3f06_a <= VAR_quarter_round_chacha20_h_l55_c29_3f06_a;
     quarter_round_chacha20_h_l55_c29_3f06_b <= VAR_quarter_round_chacha20_h_l55_c29_3f06_b;
     quarter_round_chacha20_h_l55_c29_3f06_c <= VAR_quarter_round_chacha20_h_l55_c29_3f06_c;
     quarter_round_chacha20_h_l55_c29_3f06_d <= VAR_quarter_round_chacha20_h_l55_c29_3f06_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l55_c29_3f06_return_output := quarter_round_chacha20_h_l55_c29_3f06_return_output;

     -- Submodule level 2
     VAR_quarter_round_chacha20_h_l56_c29_6ea7_s := VAR_quarter_round_chacha20_h_l55_c29_3f06_return_output;
     -- quarter_round[chacha20_h_l56_c29_6ea7] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l56_c29_6ea7_s <= VAR_quarter_round_chacha20_h_l56_c29_6ea7_s;
     quarter_round_chacha20_h_l56_c29_6ea7_a <= VAR_quarter_round_chacha20_h_l56_c29_6ea7_a;
     quarter_round_chacha20_h_l56_c29_6ea7_b <= VAR_quarter_round_chacha20_h_l56_c29_6ea7_b;
     quarter_round_chacha20_h_l56_c29_6ea7_c <= VAR_quarter_round_chacha20_h_l56_c29_6ea7_c;
     quarter_round_chacha20_h_l56_c29_6ea7_d <= VAR_quarter_round_chacha20_h_l56_c29_6ea7_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l56_c29_6ea7_return_output := quarter_round_chacha20_h_l56_c29_6ea7_return_output;

     -- Submodule level 3
     VAR_quarter_round_chacha20_h_l57_c29_344e_s := VAR_quarter_round_chacha20_h_l56_c29_6ea7_return_output;
     -- quarter_round[chacha20_h_l57_c29_344e] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l57_c29_344e_s <= VAR_quarter_round_chacha20_h_l57_c29_344e_s;
     quarter_round_chacha20_h_l57_c29_344e_a <= VAR_quarter_round_chacha20_h_l57_c29_344e_a;
     quarter_round_chacha20_h_l57_c29_344e_b <= VAR_quarter_round_chacha20_h_l57_c29_344e_b;
     quarter_round_chacha20_h_l57_c29_344e_c <= VAR_quarter_round_chacha20_h_l57_c29_344e_c;
     quarter_round_chacha20_h_l57_c29_344e_d <= VAR_quarter_round_chacha20_h_l57_c29_344e_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l57_c29_344e_return_output := quarter_round_chacha20_h_l57_c29_344e_return_output;

     -- Submodule level 4
     VAR_quarter_round_chacha20_h_l58_c29_3b8b_s := VAR_quarter_round_chacha20_h_l57_c29_344e_return_output;
     -- quarter_round[chacha20_h_l58_c29_3b8b] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l58_c29_3b8b_s <= VAR_quarter_round_chacha20_h_l58_c29_3b8b_s;
     quarter_round_chacha20_h_l58_c29_3b8b_a <= VAR_quarter_round_chacha20_h_l58_c29_3b8b_a;
     quarter_round_chacha20_h_l58_c29_3b8b_b <= VAR_quarter_round_chacha20_h_l58_c29_3b8b_b;
     quarter_round_chacha20_h_l58_c29_3b8b_c <= VAR_quarter_round_chacha20_h_l58_c29_3b8b_c;
     quarter_round_chacha20_h_l58_c29_3b8b_d <= VAR_quarter_round_chacha20_h_l58_c29_3b8b_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l58_c29_3b8b_return_output := quarter_round_chacha20_h_l58_c29_3b8b_return_output;

     -- Submodule level 5
     VAR_quarter_round_chacha20_h_l59_c29_3a31_s := VAR_quarter_round_chacha20_h_l58_c29_3b8b_return_output;
     -- quarter_round[chacha20_h_l59_c29_3a31] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l59_c29_3a31_s <= VAR_quarter_round_chacha20_h_l59_c29_3a31_s;
     quarter_round_chacha20_h_l59_c29_3a31_a <= VAR_quarter_round_chacha20_h_l59_c29_3a31_a;
     quarter_round_chacha20_h_l59_c29_3a31_b <= VAR_quarter_round_chacha20_h_l59_c29_3a31_b;
     quarter_round_chacha20_h_l59_c29_3a31_c <= VAR_quarter_round_chacha20_h_l59_c29_3a31_c;
     quarter_round_chacha20_h_l59_c29_3a31_d <= VAR_quarter_round_chacha20_h_l59_c29_3a31_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l59_c29_3a31_return_output := quarter_round_chacha20_h_l59_c29_3a31_return_output;

     -- Submodule level 6
     VAR_quarter_round_chacha20_h_l60_c29_5cfe_s := VAR_quarter_round_chacha20_h_l59_c29_3a31_return_output;
     -- quarter_round[chacha20_h_l60_c29_5cfe] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l60_c29_5cfe_s <= VAR_quarter_round_chacha20_h_l60_c29_5cfe_s;
     quarter_round_chacha20_h_l60_c29_5cfe_a <= VAR_quarter_round_chacha20_h_l60_c29_5cfe_a;
     quarter_round_chacha20_h_l60_c29_5cfe_b <= VAR_quarter_round_chacha20_h_l60_c29_5cfe_b;
     quarter_round_chacha20_h_l60_c29_5cfe_c <= VAR_quarter_round_chacha20_h_l60_c29_5cfe_c;
     quarter_round_chacha20_h_l60_c29_5cfe_d <= VAR_quarter_round_chacha20_h_l60_c29_5cfe_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l60_c29_5cfe_return_output := quarter_round_chacha20_h_l60_c29_5cfe_return_output;

     -- Submodule level 7
     VAR_quarter_round_chacha20_h_l61_c29_5507_s := VAR_quarter_round_chacha20_h_l60_c29_5cfe_return_output;
     -- quarter_round[chacha20_h_l61_c29_5507] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l61_c29_5507_s <= VAR_quarter_round_chacha20_h_l61_c29_5507_s;
     quarter_round_chacha20_h_l61_c29_5507_a <= VAR_quarter_round_chacha20_h_l61_c29_5507_a;
     quarter_round_chacha20_h_l61_c29_5507_b <= VAR_quarter_round_chacha20_h_l61_c29_5507_b;
     quarter_round_chacha20_h_l61_c29_5507_c <= VAR_quarter_round_chacha20_h_l61_c29_5507_c;
     quarter_round_chacha20_h_l61_c29_5507_d <= VAR_quarter_round_chacha20_h_l61_c29_5507_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l61_c29_5507_return_output := quarter_round_chacha20_h_l61_c29_5507_return_output;

     -- Submodule level 8
     VAR_return_output := VAR_quarter_round_chacha20_h_l61_c29_5507_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
