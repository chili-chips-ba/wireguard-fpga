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
-- quarter_round[chacha20_h_l54_c29_090f]
signal quarter_round_chacha20_h_l54_c29_090f_s : chacha20_state;
signal quarter_round_chacha20_h_l54_c29_090f_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_090f_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_090f_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_090f_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_090f_return_output : chacha20_state;

-- quarter_round[chacha20_h_l55_c29_f3ae]
signal quarter_round_chacha20_h_l55_c29_f3ae_s : chacha20_state;
signal quarter_round_chacha20_h_l55_c29_f3ae_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_f3ae_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_f3ae_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_f3ae_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_f3ae_return_output : chacha20_state;

-- quarter_round[chacha20_h_l56_c29_7d7e]
signal quarter_round_chacha20_h_l56_c29_7d7e_s : chacha20_state;
signal quarter_round_chacha20_h_l56_c29_7d7e_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_7d7e_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_7d7e_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_7d7e_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_7d7e_return_output : chacha20_state;

-- quarter_round[chacha20_h_l57_c29_bb06]
signal quarter_round_chacha20_h_l57_c29_bb06_s : chacha20_state;
signal quarter_round_chacha20_h_l57_c29_bb06_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_bb06_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_bb06_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_bb06_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_bb06_return_output : chacha20_state;

-- quarter_round[chacha20_h_l58_c29_789b]
signal quarter_round_chacha20_h_l58_c29_789b_s : chacha20_state;
signal quarter_round_chacha20_h_l58_c29_789b_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_789b_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_789b_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_789b_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_789b_return_output : chacha20_state;

-- quarter_round[chacha20_h_l59_c29_e7dc]
signal quarter_round_chacha20_h_l59_c29_e7dc_s : chacha20_state;
signal quarter_round_chacha20_h_l59_c29_e7dc_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_e7dc_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_e7dc_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_e7dc_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_e7dc_return_output : chacha20_state;

-- quarter_round[chacha20_h_l60_c29_1dba]
signal quarter_round_chacha20_h_l60_c29_1dba_s : chacha20_state;
signal quarter_round_chacha20_h_l60_c29_1dba_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_1dba_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_1dba_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_1dba_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_1dba_return_output : chacha20_state;

-- quarter_round[chacha20_h_l61_c29_8b79]
signal quarter_round_chacha20_h_l61_c29_8b79_s : chacha20_state;
signal quarter_round_chacha20_h_l61_c29_8b79_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_8b79_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_8b79_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_8b79_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_8b79_return_output : chacha20_state;


begin

-- SUBMODULE INSTANCES 
-- quarter_round_chacha20_h_l54_c29_090f : 0 clocks latency
quarter_round_chacha20_h_l54_c29_090f : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l54_c29_090f_s,
quarter_round_chacha20_h_l54_c29_090f_a,
quarter_round_chacha20_h_l54_c29_090f_b,
quarter_round_chacha20_h_l54_c29_090f_c,
quarter_round_chacha20_h_l54_c29_090f_d,
quarter_round_chacha20_h_l54_c29_090f_return_output);

-- quarter_round_chacha20_h_l55_c29_f3ae : 0 clocks latency
quarter_round_chacha20_h_l55_c29_f3ae : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l55_c29_f3ae_s,
quarter_round_chacha20_h_l55_c29_f3ae_a,
quarter_round_chacha20_h_l55_c29_f3ae_b,
quarter_round_chacha20_h_l55_c29_f3ae_c,
quarter_round_chacha20_h_l55_c29_f3ae_d,
quarter_round_chacha20_h_l55_c29_f3ae_return_output);

-- quarter_round_chacha20_h_l56_c29_7d7e : 0 clocks latency
quarter_round_chacha20_h_l56_c29_7d7e : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l56_c29_7d7e_s,
quarter_round_chacha20_h_l56_c29_7d7e_a,
quarter_round_chacha20_h_l56_c29_7d7e_b,
quarter_round_chacha20_h_l56_c29_7d7e_c,
quarter_round_chacha20_h_l56_c29_7d7e_d,
quarter_round_chacha20_h_l56_c29_7d7e_return_output);

-- quarter_round_chacha20_h_l57_c29_bb06 : 0 clocks latency
quarter_round_chacha20_h_l57_c29_bb06 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l57_c29_bb06_s,
quarter_round_chacha20_h_l57_c29_bb06_a,
quarter_round_chacha20_h_l57_c29_bb06_b,
quarter_round_chacha20_h_l57_c29_bb06_c,
quarter_round_chacha20_h_l57_c29_bb06_d,
quarter_round_chacha20_h_l57_c29_bb06_return_output);

-- quarter_round_chacha20_h_l58_c29_789b : 0 clocks latency
quarter_round_chacha20_h_l58_c29_789b : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l58_c29_789b_s,
quarter_round_chacha20_h_l58_c29_789b_a,
quarter_round_chacha20_h_l58_c29_789b_b,
quarter_round_chacha20_h_l58_c29_789b_c,
quarter_round_chacha20_h_l58_c29_789b_d,
quarter_round_chacha20_h_l58_c29_789b_return_output);

-- quarter_round_chacha20_h_l59_c29_e7dc : 0 clocks latency
quarter_round_chacha20_h_l59_c29_e7dc : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l59_c29_e7dc_s,
quarter_round_chacha20_h_l59_c29_e7dc_a,
quarter_round_chacha20_h_l59_c29_e7dc_b,
quarter_round_chacha20_h_l59_c29_e7dc_c,
quarter_round_chacha20_h_l59_c29_e7dc_d,
quarter_round_chacha20_h_l59_c29_e7dc_return_output);

-- quarter_round_chacha20_h_l60_c29_1dba : 0 clocks latency
quarter_round_chacha20_h_l60_c29_1dba : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l60_c29_1dba_s,
quarter_round_chacha20_h_l60_c29_1dba_a,
quarter_round_chacha20_h_l60_c29_1dba_b,
quarter_round_chacha20_h_l60_c29_1dba_c,
quarter_round_chacha20_h_l60_c29_1dba_d,
quarter_round_chacha20_h_l60_c29_1dba_return_output);

-- quarter_round_chacha20_h_l61_c29_8b79 : 0 clocks latency
quarter_round_chacha20_h_l61_c29_8b79 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l61_c29_8b79_s,
quarter_round_chacha20_h_l61_c29_8b79_a,
quarter_round_chacha20_h_l61_c29_8b79_b,
quarter_round_chacha20_h_l61_c29_8b79_c,
quarter_round_chacha20_h_l61_c29_8b79_d,
quarter_round_chacha20_h_l61_c29_8b79_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 state0,
 -- All submodule outputs
 quarter_round_chacha20_h_l54_c29_090f_return_output,
 quarter_round_chacha20_h_l55_c29_f3ae_return_output,
 quarter_round_chacha20_h_l56_c29_7d7e_return_output,
 quarter_round_chacha20_h_l57_c29_bb06_return_output,
 quarter_round_chacha20_h_l58_c29_789b_return_output,
 quarter_round_chacha20_h_l59_c29_e7dc_return_output,
 quarter_round_chacha20_h_l60_c29_1dba_return_output,
 quarter_round_chacha20_h_l61_c29_8b79_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : chacha20_state;
 variable VAR_state0 : chacha20_state;
 variable VAR_state1 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_090f_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_090f_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_090f_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_090f_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_090f_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_090f_return_output : chacha20_state;
 variable VAR_state2 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_f3ae_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_f3ae_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_f3ae_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_f3ae_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_f3ae_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_f3ae_return_output : chacha20_state;
 variable VAR_state3 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_7d7e_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_7d7e_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_7d7e_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_7d7e_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_7d7e_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_7d7e_return_output : chacha20_state;
 variable VAR_state4 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_bb06_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_bb06_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_bb06_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_bb06_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_bb06_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_bb06_return_output : chacha20_state;
 variable VAR_state5 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_789b_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_789b_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_789b_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_789b_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_789b_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_789b_return_output : chacha20_state;
 variable VAR_state6 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_e7dc_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_e7dc_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_e7dc_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_e7dc_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_e7dc_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_e7dc_return_output : chacha20_state;
 variable VAR_state7 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_1dba_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_1dba_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_1dba_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_1dba_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_1dba_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_1dba_return_output : chacha20_state;
 variable VAR_state8 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_8b79_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_8b79_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_8b79_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_8b79_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_8b79_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_8b79_return_output : chacha20_state;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l58_c29_789b_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l59_c29_e7dc_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l54_c29_090f_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l59_c29_e7dc_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l61_c29_8b79_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l57_c29_bb06_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l54_c29_090f_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l58_c29_789b_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l60_c29_1dba_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l54_c29_090f_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l59_c29_e7dc_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l59_c29_e7dc_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l56_c29_7d7e_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l55_c29_f3ae_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l54_c29_090f_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l56_c29_7d7e_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l56_c29_7d7e_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l56_c29_7d7e_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l57_c29_bb06_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l60_c29_1dba_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l60_c29_1dba_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l55_c29_f3ae_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l60_c29_1dba_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l61_c29_8b79_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l57_c29_bb06_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l58_c29_789b_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l55_c29_f3ae_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l58_c29_789b_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l57_c29_bb06_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l55_c29_f3ae_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l61_c29_8b79_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l61_c29_8b79_d := to_unsigned(14, 4);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_state0 := state0;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l54_c29_090f_s := VAR_state0;
     -- quarter_round[chacha20_h_l54_c29_090f] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l54_c29_090f_s <= VAR_quarter_round_chacha20_h_l54_c29_090f_s;
     quarter_round_chacha20_h_l54_c29_090f_a <= VAR_quarter_round_chacha20_h_l54_c29_090f_a;
     quarter_round_chacha20_h_l54_c29_090f_b <= VAR_quarter_round_chacha20_h_l54_c29_090f_b;
     quarter_round_chacha20_h_l54_c29_090f_c <= VAR_quarter_round_chacha20_h_l54_c29_090f_c;
     quarter_round_chacha20_h_l54_c29_090f_d <= VAR_quarter_round_chacha20_h_l54_c29_090f_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l54_c29_090f_return_output := quarter_round_chacha20_h_l54_c29_090f_return_output;

     -- Submodule level 1
     VAR_quarter_round_chacha20_h_l55_c29_f3ae_s := VAR_quarter_round_chacha20_h_l54_c29_090f_return_output;
     -- quarter_round[chacha20_h_l55_c29_f3ae] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l55_c29_f3ae_s <= VAR_quarter_round_chacha20_h_l55_c29_f3ae_s;
     quarter_round_chacha20_h_l55_c29_f3ae_a <= VAR_quarter_round_chacha20_h_l55_c29_f3ae_a;
     quarter_round_chacha20_h_l55_c29_f3ae_b <= VAR_quarter_round_chacha20_h_l55_c29_f3ae_b;
     quarter_round_chacha20_h_l55_c29_f3ae_c <= VAR_quarter_round_chacha20_h_l55_c29_f3ae_c;
     quarter_round_chacha20_h_l55_c29_f3ae_d <= VAR_quarter_round_chacha20_h_l55_c29_f3ae_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l55_c29_f3ae_return_output := quarter_round_chacha20_h_l55_c29_f3ae_return_output;

     -- Submodule level 2
     VAR_quarter_round_chacha20_h_l56_c29_7d7e_s := VAR_quarter_round_chacha20_h_l55_c29_f3ae_return_output;
     -- quarter_round[chacha20_h_l56_c29_7d7e] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l56_c29_7d7e_s <= VAR_quarter_round_chacha20_h_l56_c29_7d7e_s;
     quarter_round_chacha20_h_l56_c29_7d7e_a <= VAR_quarter_round_chacha20_h_l56_c29_7d7e_a;
     quarter_round_chacha20_h_l56_c29_7d7e_b <= VAR_quarter_round_chacha20_h_l56_c29_7d7e_b;
     quarter_round_chacha20_h_l56_c29_7d7e_c <= VAR_quarter_round_chacha20_h_l56_c29_7d7e_c;
     quarter_round_chacha20_h_l56_c29_7d7e_d <= VAR_quarter_round_chacha20_h_l56_c29_7d7e_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l56_c29_7d7e_return_output := quarter_round_chacha20_h_l56_c29_7d7e_return_output;

     -- Submodule level 3
     VAR_quarter_round_chacha20_h_l57_c29_bb06_s := VAR_quarter_round_chacha20_h_l56_c29_7d7e_return_output;
     -- quarter_round[chacha20_h_l57_c29_bb06] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l57_c29_bb06_s <= VAR_quarter_round_chacha20_h_l57_c29_bb06_s;
     quarter_round_chacha20_h_l57_c29_bb06_a <= VAR_quarter_round_chacha20_h_l57_c29_bb06_a;
     quarter_round_chacha20_h_l57_c29_bb06_b <= VAR_quarter_round_chacha20_h_l57_c29_bb06_b;
     quarter_round_chacha20_h_l57_c29_bb06_c <= VAR_quarter_round_chacha20_h_l57_c29_bb06_c;
     quarter_round_chacha20_h_l57_c29_bb06_d <= VAR_quarter_round_chacha20_h_l57_c29_bb06_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l57_c29_bb06_return_output := quarter_round_chacha20_h_l57_c29_bb06_return_output;

     -- Submodule level 4
     VAR_quarter_round_chacha20_h_l58_c29_789b_s := VAR_quarter_round_chacha20_h_l57_c29_bb06_return_output;
     -- quarter_round[chacha20_h_l58_c29_789b] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l58_c29_789b_s <= VAR_quarter_round_chacha20_h_l58_c29_789b_s;
     quarter_round_chacha20_h_l58_c29_789b_a <= VAR_quarter_round_chacha20_h_l58_c29_789b_a;
     quarter_round_chacha20_h_l58_c29_789b_b <= VAR_quarter_round_chacha20_h_l58_c29_789b_b;
     quarter_round_chacha20_h_l58_c29_789b_c <= VAR_quarter_round_chacha20_h_l58_c29_789b_c;
     quarter_round_chacha20_h_l58_c29_789b_d <= VAR_quarter_round_chacha20_h_l58_c29_789b_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l58_c29_789b_return_output := quarter_round_chacha20_h_l58_c29_789b_return_output;

     -- Submodule level 5
     VAR_quarter_round_chacha20_h_l59_c29_e7dc_s := VAR_quarter_round_chacha20_h_l58_c29_789b_return_output;
     -- quarter_round[chacha20_h_l59_c29_e7dc] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l59_c29_e7dc_s <= VAR_quarter_round_chacha20_h_l59_c29_e7dc_s;
     quarter_round_chacha20_h_l59_c29_e7dc_a <= VAR_quarter_round_chacha20_h_l59_c29_e7dc_a;
     quarter_round_chacha20_h_l59_c29_e7dc_b <= VAR_quarter_round_chacha20_h_l59_c29_e7dc_b;
     quarter_round_chacha20_h_l59_c29_e7dc_c <= VAR_quarter_round_chacha20_h_l59_c29_e7dc_c;
     quarter_round_chacha20_h_l59_c29_e7dc_d <= VAR_quarter_round_chacha20_h_l59_c29_e7dc_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l59_c29_e7dc_return_output := quarter_round_chacha20_h_l59_c29_e7dc_return_output;

     -- Submodule level 6
     VAR_quarter_round_chacha20_h_l60_c29_1dba_s := VAR_quarter_round_chacha20_h_l59_c29_e7dc_return_output;
     -- quarter_round[chacha20_h_l60_c29_1dba] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l60_c29_1dba_s <= VAR_quarter_round_chacha20_h_l60_c29_1dba_s;
     quarter_round_chacha20_h_l60_c29_1dba_a <= VAR_quarter_round_chacha20_h_l60_c29_1dba_a;
     quarter_round_chacha20_h_l60_c29_1dba_b <= VAR_quarter_round_chacha20_h_l60_c29_1dba_b;
     quarter_round_chacha20_h_l60_c29_1dba_c <= VAR_quarter_round_chacha20_h_l60_c29_1dba_c;
     quarter_round_chacha20_h_l60_c29_1dba_d <= VAR_quarter_round_chacha20_h_l60_c29_1dba_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l60_c29_1dba_return_output := quarter_round_chacha20_h_l60_c29_1dba_return_output;

     -- Submodule level 7
     VAR_quarter_round_chacha20_h_l61_c29_8b79_s := VAR_quarter_round_chacha20_h_l60_c29_1dba_return_output;
     -- quarter_round[chacha20_h_l61_c29_8b79] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l61_c29_8b79_s <= VAR_quarter_round_chacha20_h_l61_c29_8b79_s;
     quarter_round_chacha20_h_l61_c29_8b79_a <= VAR_quarter_round_chacha20_h_l61_c29_8b79_a;
     quarter_round_chacha20_h_l61_c29_8b79_b <= VAR_quarter_round_chacha20_h_l61_c29_8b79_b;
     quarter_round_chacha20_h_l61_c29_8b79_c <= VAR_quarter_round_chacha20_h_l61_c29_8b79_c;
     quarter_round_chacha20_h_l61_c29_8b79_d <= VAR_quarter_round_chacha20_h_l61_c29_8b79_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l61_c29_8b79_return_output := quarter_round_chacha20_h_l61_c29_8b79_return_output;

     -- Submodule level 8
     VAR_return_output := VAR_quarter_round_chacha20_h_l61_c29_8b79_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
