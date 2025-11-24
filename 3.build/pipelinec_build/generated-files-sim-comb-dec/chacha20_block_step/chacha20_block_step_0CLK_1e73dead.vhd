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
-- quarter_round[chacha20_h_l54_c29_0abc]
signal quarter_round_chacha20_h_l54_c29_0abc_s : chacha20_state;
signal quarter_round_chacha20_h_l54_c29_0abc_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_0abc_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_0abc_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_0abc_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_0abc_return_output : chacha20_state;

-- quarter_round[chacha20_h_l55_c29_622d]
signal quarter_round_chacha20_h_l55_c29_622d_s : chacha20_state;
signal quarter_round_chacha20_h_l55_c29_622d_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_622d_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_622d_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_622d_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_622d_return_output : chacha20_state;

-- quarter_round[chacha20_h_l56_c29_1991]
signal quarter_round_chacha20_h_l56_c29_1991_s : chacha20_state;
signal quarter_round_chacha20_h_l56_c29_1991_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_1991_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_1991_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_1991_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_1991_return_output : chacha20_state;

-- quarter_round[chacha20_h_l57_c29_c0fb]
signal quarter_round_chacha20_h_l57_c29_c0fb_s : chacha20_state;
signal quarter_round_chacha20_h_l57_c29_c0fb_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_c0fb_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_c0fb_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_c0fb_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_c0fb_return_output : chacha20_state;

-- quarter_round[chacha20_h_l58_c29_c9e5]
signal quarter_round_chacha20_h_l58_c29_c9e5_s : chacha20_state;
signal quarter_round_chacha20_h_l58_c29_c9e5_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_c9e5_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_c9e5_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_c9e5_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_c9e5_return_output : chacha20_state;

-- quarter_round[chacha20_h_l59_c29_7f0c]
signal quarter_round_chacha20_h_l59_c29_7f0c_s : chacha20_state;
signal quarter_round_chacha20_h_l59_c29_7f0c_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_7f0c_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_7f0c_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_7f0c_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_7f0c_return_output : chacha20_state;

-- quarter_round[chacha20_h_l60_c29_ee6f]
signal quarter_round_chacha20_h_l60_c29_ee6f_s : chacha20_state;
signal quarter_round_chacha20_h_l60_c29_ee6f_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_ee6f_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_ee6f_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_ee6f_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_ee6f_return_output : chacha20_state;

-- quarter_round[chacha20_h_l61_c29_a1d4]
signal quarter_round_chacha20_h_l61_c29_a1d4_s : chacha20_state;
signal quarter_round_chacha20_h_l61_c29_a1d4_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_a1d4_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_a1d4_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_a1d4_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_a1d4_return_output : chacha20_state;


begin

-- SUBMODULE INSTANCES 
-- quarter_round_chacha20_h_l54_c29_0abc : 0 clocks latency
quarter_round_chacha20_h_l54_c29_0abc : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l54_c29_0abc_s,
quarter_round_chacha20_h_l54_c29_0abc_a,
quarter_round_chacha20_h_l54_c29_0abc_b,
quarter_round_chacha20_h_l54_c29_0abc_c,
quarter_round_chacha20_h_l54_c29_0abc_d,
quarter_round_chacha20_h_l54_c29_0abc_return_output);

-- quarter_round_chacha20_h_l55_c29_622d : 0 clocks latency
quarter_round_chacha20_h_l55_c29_622d : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l55_c29_622d_s,
quarter_round_chacha20_h_l55_c29_622d_a,
quarter_round_chacha20_h_l55_c29_622d_b,
quarter_round_chacha20_h_l55_c29_622d_c,
quarter_round_chacha20_h_l55_c29_622d_d,
quarter_round_chacha20_h_l55_c29_622d_return_output);

-- quarter_round_chacha20_h_l56_c29_1991 : 0 clocks latency
quarter_round_chacha20_h_l56_c29_1991 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l56_c29_1991_s,
quarter_round_chacha20_h_l56_c29_1991_a,
quarter_round_chacha20_h_l56_c29_1991_b,
quarter_round_chacha20_h_l56_c29_1991_c,
quarter_round_chacha20_h_l56_c29_1991_d,
quarter_round_chacha20_h_l56_c29_1991_return_output);

-- quarter_round_chacha20_h_l57_c29_c0fb : 0 clocks latency
quarter_round_chacha20_h_l57_c29_c0fb : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l57_c29_c0fb_s,
quarter_round_chacha20_h_l57_c29_c0fb_a,
quarter_round_chacha20_h_l57_c29_c0fb_b,
quarter_round_chacha20_h_l57_c29_c0fb_c,
quarter_round_chacha20_h_l57_c29_c0fb_d,
quarter_round_chacha20_h_l57_c29_c0fb_return_output);

-- quarter_round_chacha20_h_l58_c29_c9e5 : 0 clocks latency
quarter_round_chacha20_h_l58_c29_c9e5 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l58_c29_c9e5_s,
quarter_round_chacha20_h_l58_c29_c9e5_a,
quarter_round_chacha20_h_l58_c29_c9e5_b,
quarter_round_chacha20_h_l58_c29_c9e5_c,
quarter_round_chacha20_h_l58_c29_c9e5_d,
quarter_round_chacha20_h_l58_c29_c9e5_return_output);

-- quarter_round_chacha20_h_l59_c29_7f0c : 0 clocks latency
quarter_round_chacha20_h_l59_c29_7f0c : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l59_c29_7f0c_s,
quarter_round_chacha20_h_l59_c29_7f0c_a,
quarter_round_chacha20_h_l59_c29_7f0c_b,
quarter_round_chacha20_h_l59_c29_7f0c_c,
quarter_round_chacha20_h_l59_c29_7f0c_d,
quarter_round_chacha20_h_l59_c29_7f0c_return_output);

-- quarter_round_chacha20_h_l60_c29_ee6f : 0 clocks latency
quarter_round_chacha20_h_l60_c29_ee6f : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l60_c29_ee6f_s,
quarter_round_chacha20_h_l60_c29_ee6f_a,
quarter_round_chacha20_h_l60_c29_ee6f_b,
quarter_round_chacha20_h_l60_c29_ee6f_c,
quarter_round_chacha20_h_l60_c29_ee6f_d,
quarter_round_chacha20_h_l60_c29_ee6f_return_output);

-- quarter_round_chacha20_h_l61_c29_a1d4 : 0 clocks latency
quarter_round_chacha20_h_l61_c29_a1d4 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l61_c29_a1d4_s,
quarter_round_chacha20_h_l61_c29_a1d4_a,
quarter_round_chacha20_h_l61_c29_a1d4_b,
quarter_round_chacha20_h_l61_c29_a1d4_c,
quarter_round_chacha20_h_l61_c29_a1d4_d,
quarter_round_chacha20_h_l61_c29_a1d4_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 state0,
 -- All submodule outputs
 quarter_round_chacha20_h_l54_c29_0abc_return_output,
 quarter_round_chacha20_h_l55_c29_622d_return_output,
 quarter_round_chacha20_h_l56_c29_1991_return_output,
 quarter_round_chacha20_h_l57_c29_c0fb_return_output,
 quarter_round_chacha20_h_l58_c29_c9e5_return_output,
 quarter_round_chacha20_h_l59_c29_7f0c_return_output,
 quarter_round_chacha20_h_l60_c29_ee6f_return_output,
 quarter_round_chacha20_h_l61_c29_a1d4_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : chacha20_state;
 variable VAR_state0 : chacha20_state;
 variable VAR_state1 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_0abc_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_0abc_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_0abc_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_0abc_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_0abc_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_0abc_return_output : chacha20_state;
 variable VAR_state2 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_622d_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_622d_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_622d_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_622d_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_622d_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_622d_return_output : chacha20_state;
 variable VAR_state3 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_1991_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_1991_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_1991_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_1991_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_1991_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_1991_return_output : chacha20_state;
 variable VAR_state4 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_c0fb_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_c0fb_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_c0fb_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_c0fb_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_c0fb_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_c0fb_return_output : chacha20_state;
 variable VAR_state5 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_c9e5_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_c9e5_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_c9e5_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_c9e5_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_c9e5_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_c9e5_return_output : chacha20_state;
 variable VAR_state6 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_7f0c_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_7f0c_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_7f0c_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_7f0c_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_7f0c_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_7f0c_return_output : chacha20_state;
 variable VAR_state7 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_ee6f_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_ee6f_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_ee6f_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_ee6f_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_ee6f_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_ee6f_return_output : chacha20_state;
 variable VAR_state8 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_a1d4_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_a1d4_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_a1d4_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_a1d4_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_a1d4_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_a1d4_return_output : chacha20_state;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l58_c29_c9e5_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l55_c29_622d_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l57_c29_c0fb_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l59_c29_7f0c_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l58_c29_c9e5_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l60_c29_ee6f_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l58_c29_c9e5_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l60_c29_ee6f_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l59_c29_7f0c_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l58_c29_c9e5_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l56_c29_1991_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l56_c29_1991_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l59_c29_7f0c_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l54_c29_0abc_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l61_c29_a1d4_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l59_c29_7f0c_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l55_c29_622d_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l61_c29_a1d4_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l57_c29_c0fb_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l55_c29_622d_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l54_c29_0abc_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l60_c29_ee6f_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l54_c29_0abc_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l57_c29_c0fb_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l55_c29_622d_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l56_c29_1991_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l61_c29_a1d4_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l60_c29_ee6f_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l61_c29_a1d4_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l56_c29_1991_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l54_c29_0abc_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l57_c29_c0fb_a := to_unsigned(3, 4);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_state0 := state0;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l54_c29_0abc_s := VAR_state0;
     -- quarter_round[chacha20_h_l54_c29_0abc] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l54_c29_0abc_s <= VAR_quarter_round_chacha20_h_l54_c29_0abc_s;
     quarter_round_chacha20_h_l54_c29_0abc_a <= VAR_quarter_round_chacha20_h_l54_c29_0abc_a;
     quarter_round_chacha20_h_l54_c29_0abc_b <= VAR_quarter_round_chacha20_h_l54_c29_0abc_b;
     quarter_round_chacha20_h_l54_c29_0abc_c <= VAR_quarter_round_chacha20_h_l54_c29_0abc_c;
     quarter_round_chacha20_h_l54_c29_0abc_d <= VAR_quarter_round_chacha20_h_l54_c29_0abc_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l54_c29_0abc_return_output := quarter_round_chacha20_h_l54_c29_0abc_return_output;

     -- Submodule level 1
     VAR_quarter_round_chacha20_h_l55_c29_622d_s := VAR_quarter_round_chacha20_h_l54_c29_0abc_return_output;
     -- quarter_round[chacha20_h_l55_c29_622d] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l55_c29_622d_s <= VAR_quarter_round_chacha20_h_l55_c29_622d_s;
     quarter_round_chacha20_h_l55_c29_622d_a <= VAR_quarter_round_chacha20_h_l55_c29_622d_a;
     quarter_round_chacha20_h_l55_c29_622d_b <= VAR_quarter_round_chacha20_h_l55_c29_622d_b;
     quarter_round_chacha20_h_l55_c29_622d_c <= VAR_quarter_round_chacha20_h_l55_c29_622d_c;
     quarter_round_chacha20_h_l55_c29_622d_d <= VAR_quarter_round_chacha20_h_l55_c29_622d_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l55_c29_622d_return_output := quarter_round_chacha20_h_l55_c29_622d_return_output;

     -- Submodule level 2
     VAR_quarter_round_chacha20_h_l56_c29_1991_s := VAR_quarter_round_chacha20_h_l55_c29_622d_return_output;
     -- quarter_round[chacha20_h_l56_c29_1991] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l56_c29_1991_s <= VAR_quarter_round_chacha20_h_l56_c29_1991_s;
     quarter_round_chacha20_h_l56_c29_1991_a <= VAR_quarter_round_chacha20_h_l56_c29_1991_a;
     quarter_round_chacha20_h_l56_c29_1991_b <= VAR_quarter_round_chacha20_h_l56_c29_1991_b;
     quarter_round_chacha20_h_l56_c29_1991_c <= VAR_quarter_round_chacha20_h_l56_c29_1991_c;
     quarter_round_chacha20_h_l56_c29_1991_d <= VAR_quarter_round_chacha20_h_l56_c29_1991_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l56_c29_1991_return_output := quarter_round_chacha20_h_l56_c29_1991_return_output;

     -- Submodule level 3
     VAR_quarter_round_chacha20_h_l57_c29_c0fb_s := VAR_quarter_round_chacha20_h_l56_c29_1991_return_output;
     -- quarter_round[chacha20_h_l57_c29_c0fb] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l57_c29_c0fb_s <= VAR_quarter_round_chacha20_h_l57_c29_c0fb_s;
     quarter_round_chacha20_h_l57_c29_c0fb_a <= VAR_quarter_round_chacha20_h_l57_c29_c0fb_a;
     quarter_round_chacha20_h_l57_c29_c0fb_b <= VAR_quarter_round_chacha20_h_l57_c29_c0fb_b;
     quarter_round_chacha20_h_l57_c29_c0fb_c <= VAR_quarter_round_chacha20_h_l57_c29_c0fb_c;
     quarter_round_chacha20_h_l57_c29_c0fb_d <= VAR_quarter_round_chacha20_h_l57_c29_c0fb_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l57_c29_c0fb_return_output := quarter_round_chacha20_h_l57_c29_c0fb_return_output;

     -- Submodule level 4
     VAR_quarter_round_chacha20_h_l58_c29_c9e5_s := VAR_quarter_round_chacha20_h_l57_c29_c0fb_return_output;
     -- quarter_round[chacha20_h_l58_c29_c9e5] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l58_c29_c9e5_s <= VAR_quarter_round_chacha20_h_l58_c29_c9e5_s;
     quarter_round_chacha20_h_l58_c29_c9e5_a <= VAR_quarter_round_chacha20_h_l58_c29_c9e5_a;
     quarter_round_chacha20_h_l58_c29_c9e5_b <= VAR_quarter_round_chacha20_h_l58_c29_c9e5_b;
     quarter_round_chacha20_h_l58_c29_c9e5_c <= VAR_quarter_round_chacha20_h_l58_c29_c9e5_c;
     quarter_round_chacha20_h_l58_c29_c9e5_d <= VAR_quarter_round_chacha20_h_l58_c29_c9e5_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l58_c29_c9e5_return_output := quarter_round_chacha20_h_l58_c29_c9e5_return_output;

     -- Submodule level 5
     VAR_quarter_round_chacha20_h_l59_c29_7f0c_s := VAR_quarter_round_chacha20_h_l58_c29_c9e5_return_output;
     -- quarter_round[chacha20_h_l59_c29_7f0c] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l59_c29_7f0c_s <= VAR_quarter_round_chacha20_h_l59_c29_7f0c_s;
     quarter_round_chacha20_h_l59_c29_7f0c_a <= VAR_quarter_round_chacha20_h_l59_c29_7f0c_a;
     quarter_round_chacha20_h_l59_c29_7f0c_b <= VAR_quarter_round_chacha20_h_l59_c29_7f0c_b;
     quarter_round_chacha20_h_l59_c29_7f0c_c <= VAR_quarter_round_chacha20_h_l59_c29_7f0c_c;
     quarter_round_chacha20_h_l59_c29_7f0c_d <= VAR_quarter_round_chacha20_h_l59_c29_7f0c_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l59_c29_7f0c_return_output := quarter_round_chacha20_h_l59_c29_7f0c_return_output;

     -- Submodule level 6
     VAR_quarter_round_chacha20_h_l60_c29_ee6f_s := VAR_quarter_round_chacha20_h_l59_c29_7f0c_return_output;
     -- quarter_round[chacha20_h_l60_c29_ee6f] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l60_c29_ee6f_s <= VAR_quarter_round_chacha20_h_l60_c29_ee6f_s;
     quarter_round_chacha20_h_l60_c29_ee6f_a <= VAR_quarter_round_chacha20_h_l60_c29_ee6f_a;
     quarter_round_chacha20_h_l60_c29_ee6f_b <= VAR_quarter_round_chacha20_h_l60_c29_ee6f_b;
     quarter_round_chacha20_h_l60_c29_ee6f_c <= VAR_quarter_round_chacha20_h_l60_c29_ee6f_c;
     quarter_round_chacha20_h_l60_c29_ee6f_d <= VAR_quarter_round_chacha20_h_l60_c29_ee6f_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l60_c29_ee6f_return_output := quarter_round_chacha20_h_l60_c29_ee6f_return_output;

     -- Submodule level 7
     VAR_quarter_round_chacha20_h_l61_c29_a1d4_s := VAR_quarter_round_chacha20_h_l60_c29_ee6f_return_output;
     -- quarter_round[chacha20_h_l61_c29_a1d4] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l61_c29_a1d4_s <= VAR_quarter_round_chacha20_h_l61_c29_a1d4_s;
     quarter_round_chacha20_h_l61_c29_a1d4_a <= VAR_quarter_round_chacha20_h_l61_c29_a1d4_a;
     quarter_round_chacha20_h_l61_c29_a1d4_b <= VAR_quarter_round_chacha20_h_l61_c29_a1d4_b;
     quarter_round_chacha20_h_l61_c29_a1d4_c <= VAR_quarter_round_chacha20_h_l61_c29_a1d4_c;
     quarter_round_chacha20_h_l61_c29_a1d4_d <= VAR_quarter_round_chacha20_h_l61_c29_a1d4_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l61_c29_a1d4_return_output := quarter_round_chacha20_h_l61_c29_a1d4_return_output;

     -- Submodule level 8
     VAR_return_output := VAR_quarter_round_chacha20_h_l61_c29_a1d4_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
