-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.019474196689383796, 0.40944498539434915, 0.799415774099316]
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
entity chacha20_block_step_3CLK_7f7fdb6d is
port(
 clk : in std_logic;
 state0 : in chacha20_state;
 return_output : out chacha20_state);
end chacha20_block_step_3CLK_7f7fdb6d;
architecture arch of chacha20_block_step_3CLK_7f7fdb6d is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 3;
-- All of the wires/regs in function
-- Stage 0
-- Stage 1
-- Stage 2
-- Each function instance gets signals
-- quarter_round[chacha20_h_l54_c29_83dc]
signal quarter_round_chacha20_h_l54_c29_83dc_s : chacha20_state;
signal quarter_round_chacha20_h_l54_c29_83dc_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_83dc_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_83dc_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_83dc_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l54_c29_83dc_return_output : chacha20_state;

-- quarter_round[chacha20_h_l55_c29_417e]
signal quarter_round_chacha20_h_l55_c29_417e_s : chacha20_state;
signal quarter_round_chacha20_h_l55_c29_417e_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_417e_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_417e_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_417e_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l55_c29_417e_return_output : chacha20_state;

-- quarter_round[chacha20_h_l56_c29_087d]
signal quarter_round_chacha20_h_l56_c29_087d_s : chacha20_state;
signal quarter_round_chacha20_h_l56_c29_087d_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_087d_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_087d_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_087d_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l56_c29_087d_return_output : chacha20_state;

-- quarter_round[chacha20_h_l57_c29_22bb]
signal quarter_round_chacha20_h_l57_c29_22bb_s : chacha20_state;
signal quarter_round_chacha20_h_l57_c29_22bb_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_22bb_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_22bb_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_22bb_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l57_c29_22bb_return_output : chacha20_state;

-- quarter_round[chacha20_h_l58_c29_d790]
signal quarter_round_chacha20_h_l58_c29_d790_s : chacha20_state;
signal quarter_round_chacha20_h_l58_c29_d790_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_d790_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_d790_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_d790_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l58_c29_d790_return_output : chacha20_state;

-- quarter_round[chacha20_h_l59_c29_a373]
signal quarter_round_chacha20_h_l59_c29_a373_s : chacha20_state;
signal quarter_round_chacha20_h_l59_c29_a373_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_a373_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_a373_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_a373_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l59_c29_a373_return_output : chacha20_state;

-- quarter_round[chacha20_h_l60_c29_72f9]
signal quarter_round_chacha20_h_l60_c29_72f9_s : chacha20_state;
signal quarter_round_chacha20_h_l60_c29_72f9_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_72f9_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_72f9_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_72f9_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l60_c29_72f9_return_output : chacha20_state;

-- quarter_round[chacha20_h_l61_c29_46a7]
signal quarter_round_chacha20_h_l61_c29_46a7_s : chacha20_state;
signal quarter_round_chacha20_h_l61_c29_46a7_a : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_46a7_b : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_46a7_c : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_46a7_d : unsigned(3 downto 0);
signal quarter_round_chacha20_h_l61_c29_46a7_return_output : chacha20_state;


begin

-- SUBMODULE INSTANCES 
-- quarter_round_chacha20_h_l54_c29_83dc : 1 clocks latency
quarter_round_chacha20_h_l54_c29_83dc : entity work.quarter_round_1CLK_0a638d4d port map (
clk,
quarter_round_chacha20_h_l54_c29_83dc_s,
quarter_round_chacha20_h_l54_c29_83dc_a,
quarter_round_chacha20_h_l54_c29_83dc_b,
quarter_round_chacha20_h_l54_c29_83dc_c,
quarter_round_chacha20_h_l54_c29_83dc_d,
quarter_round_chacha20_h_l54_c29_83dc_return_output);

-- quarter_round_chacha20_h_l55_c29_417e : 0 clocks latency
quarter_round_chacha20_h_l55_c29_417e : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l55_c29_417e_s,
quarter_round_chacha20_h_l55_c29_417e_a,
quarter_round_chacha20_h_l55_c29_417e_b,
quarter_round_chacha20_h_l55_c29_417e_c,
quarter_round_chacha20_h_l55_c29_417e_d,
quarter_round_chacha20_h_l55_c29_417e_return_output);

-- quarter_round_chacha20_h_l56_c29_087d : 0 clocks latency
quarter_round_chacha20_h_l56_c29_087d : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l56_c29_087d_s,
quarter_round_chacha20_h_l56_c29_087d_a,
quarter_round_chacha20_h_l56_c29_087d_b,
quarter_round_chacha20_h_l56_c29_087d_c,
quarter_round_chacha20_h_l56_c29_087d_d,
quarter_round_chacha20_h_l56_c29_087d_return_output);

-- quarter_round_chacha20_h_l57_c29_22bb : 1 clocks latency
quarter_round_chacha20_h_l57_c29_22bb : entity work.quarter_round_1CLK_a43dcf72 port map (
clk,
quarter_round_chacha20_h_l57_c29_22bb_s,
quarter_round_chacha20_h_l57_c29_22bb_a,
quarter_round_chacha20_h_l57_c29_22bb_b,
quarter_round_chacha20_h_l57_c29_22bb_c,
quarter_round_chacha20_h_l57_c29_22bb_d,
quarter_round_chacha20_h_l57_c29_22bb_return_output);

-- quarter_round_chacha20_h_l58_c29_d790 : 0 clocks latency
quarter_round_chacha20_h_l58_c29_d790 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l58_c29_d790_s,
quarter_round_chacha20_h_l58_c29_d790_a,
quarter_round_chacha20_h_l58_c29_d790_b,
quarter_round_chacha20_h_l58_c29_d790_c,
quarter_round_chacha20_h_l58_c29_d790_d,
quarter_round_chacha20_h_l58_c29_d790_return_output);

-- quarter_round_chacha20_h_l59_c29_a373 : 0 clocks latency
quarter_round_chacha20_h_l59_c29_a373 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l59_c29_a373_s,
quarter_round_chacha20_h_l59_c29_a373_a,
quarter_round_chacha20_h_l59_c29_a373_b,
quarter_round_chacha20_h_l59_c29_a373_c,
quarter_round_chacha20_h_l59_c29_a373_d,
quarter_round_chacha20_h_l59_c29_a373_return_output);

-- quarter_round_chacha20_h_l60_c29_72f9 : 1 clocks latency
quarter_round_chacha20_h_l60_c29_72f9 : entity work.quarter_round_1CLK_83c50a15 port map (
clk,
quarter_round_chacha20_h_l60_c29_72f9_s,
quarter_round_chacha20_h_l60_c29_72f9_a,
quarter_round_chacha20_h_l60_c29_72f9_b,
quarter_round_chacha20_h_l60_c29_72f9_c,
quarter_round_chacha20_h_l60_c29_72f9_d,
quarter_round_chacha20_h_l60_c29_72f9_return_output);

-- quarter_round_chacha20_h_l61_c29_46a7 : 0 clocks latency
quarter_round_chacha20_h_l61_c29_46a7 : entity work.quarter_round_0CLK_638872ab port map (
quarter_round_chacha20_h_l61_c29_46a7_s,
quarter_round_chacha20_h_l61_c29_46a7_a,
quarter_round_chacha20_h_l61_c29_46a7_b,
quarter_round_chacha20_h_l61_c29_46a7_c,
quarter_round_chacha20_h_l61_c29_46a7_d,
quarter_round_chacha20_h_l61_c29_46a7_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 state0,
 -- Registers
 -- Stage 0
 -- Stage 1
 -- Stage 2
 -- All submodule outputs
 quarter_round_chacha20_h_l54_c29_83dc_return_output,
 quarter_round_chacha20_h_l55_c29_417e_return_output,
 quarter_round_chacha20_h_l56_c29_087d_return_output,
 quarter_round_chacha20_h_l57_c29_22bb_return_output,
 quarter_round_chacha20_h_l58_c29_d790_return_output,
 quarter_round_chacha20_h_l59_c29_a373_return_output,
 quarter_round_chacha20_h_l60_c29_72f9_return_output,
 quarter_round_chacha20_h_l61_c29_46a7_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : chacha20_state;
 variable VAR_state0 : chacha20_state;
 variable VAR_state1 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_83dc_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l54_c29_83dc_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_83dc_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_83dc_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_83dc_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l54_c29_83dc_return_output : chacha20_state;
 variable VAR_state2 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_417e_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l55_c29_417e_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_417e_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_417e_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_417e_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l55_c29_417e_return_output : chacha20_state;
 variable VAR_state3 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_087d_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l56_c29_087d_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_087d_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_087d_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_087d_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l56_c29_087d_return_output : chacha20_state;
 variable VAR_state4 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_22bb_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l57_c29_22bb_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_22bb_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_22bb_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_22bb_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l57_c29_22bb_return_output : chacha20_state;
 variable VAR_state5 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_d790_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l58_c29_d790_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_d790_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_d790_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_d790_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l58_c29_d790_return_output : chacha20_state;
 variable VAR_state6 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_a373_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l59_c29_a373_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_a373_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_a373_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_a373_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l59_c29_a373_return_output : chacha20_state;
 variable VAR_state7 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_72f9_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l60_c29_72f9_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_72f9_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_72f9_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_72f9_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l60_c29_72f9_return_output : chacha20_state;
 variable VAR_state8 : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_46a7_s : chacha20_state;
 variable VAR_quarter_round_chacha20_h_l61_c29_46a7_a : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_46a7_b : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_46a7_c : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_46a7_d : unsigned(3 downto 0);
 variable VAR_quarter_round_chacha20_h_l61_c29_46a7_return_output : chacha20_state;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l59_c29_a373_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l57_c29_22bb_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l60_c29_72f9_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l59_c29_a373_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l56_c29_087d_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l59_c29_a373_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l55_c29_417e_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l54_c29_83dc_d := to_unsigned(12, 4);
     VAR_quarter_round_chacha20_h_l61_c29_46a7_a := to_unsigned(3, 4);
     VAR_quarter_round_chacha20_h_l54_c29_83dc_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l60_c29_72f9_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l58_c29_d790_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l54_c29_83dc_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l55_c29_417e_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l56_c29_087d_a := to_unsigned(2, 4);
     VAR_quarter_round_chacha20_h_l54_c29_83dc_a := to_unsigned(0, 4);
     VAR_quarter_round_chacha20_h_l60_c29_72f9_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l58_c29_d790_b := to_unsigned(5, 4);
     VAR_quarter_round_chacha20_h_l58_c29_d790_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l61_c29_46a7_b := to_unsigned(4, 4);
     VAR_quarter_round_chacha20_h_l59_c29_a373_a := to_unsigned(1, 4);
     VAR_quarter_round_chacha20_h_l56_c29_087d_c := to_unsigned(10, 4);
     VAR_quarter_round_chacha20_h_l56_c29_087d_b := to_unsigned(6, 4);
     VAR_quarter_round_chacha20_h_l57_c29_22bb_c := to_unsigned(11, 4);
     VAR_quarter_round_chacha20_h_l61_c29_46a7_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l55_c29_417e_c := to_unsigned(9, 4);
     VAR_quarter_round_chacha20_h_l60_c29_72f9_c := to_unsigned(8, 4);
     VAR_quarter_round_chacha20_h_l57_c29_22bb_b := to_unsigned(7, 4);
     VAR_quarter_round_chacha20_h_l58_c29_d790_d := to_unsigned(15, 4);
     VAR_quarter_round_chacha20_h_l61_c29_46a7_d := to_unsigned(14, 4);
     VAR_quarter_round_chacha20_h_l55_c29_417e_d := to_unsigned(13, 4);
     VAR_quarter_round_chacha20_h_l57_c29_22bb_d := to_unsigned(15, 4);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_state0 := state0;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l54_c29_83dc_s := VAR_state0;
     -- quarter_round[chacha20_h_l54_c29_83dc] LATENCY=1
     -- Inputs
     quarter_round_chacha20_h_l54_c29_83dc_s <= VAR_quarter_round_chacha20_h_l54_c29_83dc_s;
     quarter_round_chacha20_h_l54_c29_83dc_a <= VAR_quarter_round_chacha20_h_l54_c29_83dc_a;
     quarter_round_chacha20_h_l54_c29_83dc_b <= VAR_quarter_round_chacha20_h_l54_c29_83dc_b;
     quarter_round_chacha20_h_l54_c29_83dc_c <= VAR_quarter_round_chacha20_h_l54_c29_83dc_c;
     quarter_round_chacha20_h_l54_c29_83dc_d <= VAR_quarter_round_chacha20_h_l54_c29_83dc_d;

     -- Write to comb signals
   elsif STAGE = 1 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_quarter_round_chacha20_h_l54_c29_83dc_return_output := quarter_round_chacha20_h_l54_c29_83dc_return_output;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l55_c29_417e_s := VAR_quarter_round_chacha20_h_l54_c29_83dc_return_output;
     -- quarter_round[chacha20_h_l55_c29_417e] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l55_c29_417e_s <= VAR_quarter_round_chacha20_h_l55_c29_417e_s;
     quarter_round_chacha20_h_l55_c29_417e_a <= VAR_quarter_round_chacha20_h_l55_c29_417e_a;
     quarter_round_chacha20_h_l55_c29_417e_b <= VAR_quarter_round_chacha20_h_l55_c29_417e_b;
     quarter_round_chacha20_h_l55_c29_417e_c <= VAR_quarter_round_chacha20_h_l55_c29_417e_c;
     quarter_round_chacha20_h_l55_c29_417e_d <= VAR_quarter_round_chacha20_h_l55_c29_417e_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l55_c29_417e_return_output := quarter_round_chacha20_h_l55_c29_417e_return_output;

     -- Submodule level 1
     VAR_quarter_round_chacha20_h_l56_c29_087d_s := VAR_quarter_round_chacha20_h_l55_c29_417e_return_output;
     -- quarter_round[chacha20_h_l56_c29_087d] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l56_c29_087d_s <= VAR_quarter_round_chacha20_h_l56_c29_087d_s;
     quarter_round_chacha20_h_l56_c29_087d_a <= VAR_quarter_round_chacha20_h_l56_c29_087d_a;
     quarter_round_chacha20_h_l56_c29_087d_b <= VAR_quarter_round_chacha20_h_l56_c29_087d_b;
     quarter_round_chacha20_h_l56_c29_087d_c <= VAR_quarter_round_chacha20_h_l56_c29_087d_c;
     quarter_round_chacha20_h_l56_c29_087d_d <= VAR_quarter_round_chacha20_h_l56_c29_087d_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l56_c29_087d_return_output := quarter_round_chacha20_h_l56_c29_087d_return_output;

     -- Submodule level 2
     VAR_quarter_round_chacha20_h_l57_c29_22bb_s := VAR_quarter_round_chacha20_h_l56_c29_087d_return_output;
     -- quarter_round[chacha20_h_l57_c29_22bb] LATENCY=1
     -- Inputs
     quarter_round_chacha20_h_l57_c29_22bb_s <= VAR_quarter_round_chacha20_h_l57_c29_22bb_s;
     quarter_round_chacha20_h_l57_c29_22bb_a <= VAR_quarter_round_chacha20_h_l57_c29_22bb_a;
     quarter_round_chacha20_h_l57_c29_22bb_b <= VAR_quarter_round_chacha20_h_l57_c29_22bb_b;
     quarter_round_chacha20_h_l57_c29_22bb_c <= VAR_quarter_round_chacha20_h_l57_c29_22bb_c;
     quarter_round_chacha20_h_l57_c29_22bb_d <= VAR_quarter_round_chacha20_h_l57_c29_22bb_d;

     -- Write to comb signals
   elsif STAGE = 2 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_quarter_round_chacha20_h_l57_c29_22bb_return_output := quarter_round_chacha20_h_l57_c29_22bb_return_output;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l58_c29_d790_s := VAR_quarter_round_chacha20_h_l57_c29_22bb_return_output;
     -- quarter_round[chacha20_h_l58_c29_d790] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l58_c29_d790_s <= VAR_quarter_round_chacha20_h_l58_c29_d790_s;
     quarter_round_chacha20_h_l58_c29_d790_a <= VAR_quarter_round_chacha20_h_l58_c29_d790_a;
     quarter_round_chacha20_h_l58_c29_d790_b <= VAR_quarter_round_chacha20_h_l58_c29_d790_b;
     quarter_round_chacha20_h_l58_c29_d790_c <= VAR_quarter_round_chacha20_h_l58_c29_d790_c;
     quarter_round_chacha20_h_l58_c29_d790_d <= VAR_quarter_round_chacha20_h_l58_c29_d790_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l58_c29_d790_return_output := quarter_round_chacha20_h_l58_c29_d790_return_output;

     -- Submodule level 1
     VAR_quarter_round_chacha20_h_l59_c29_a373_s := VAR_quarter_round_chacha20_h_l58_c29_d790_return_output;
     -- quarter_round[chacha20_h_l59_c29_a373] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l59_c29_a373_s <= VAR_quarter_round_chacha20_h_l59_c29_a373_s;
     quarter_round_chacha20_h_l59_c29_a373_a <= VAR_quarter_round_chacha20_h_l59_c29_a373_a;
     quarter_round_chacha20_h_l59_c29_a373_b <= VAR_quarter_round_chacha20_h_l59_c29_a373_b;
     quarter_round_chacha20_h_l59_c29_a373_c <= VAR_quarter_round_chacha20_h_l59_c29_a373_c;
     quarter_round_chacha20_h_l59_c29_a373_d <= VAR_quarter_round_chacha20_h_l59_c29_a373_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l59_c29_a373_return_output := quarter_round_chacha20_h_l59_c29_a373_return_output;

     -- Submodule level 2
     VAR_quarter_round_chacha20_h_l60_c29_72f9_s := VAR_quarter_round_chacha20_h_l59_c29_a373_return_output;
     -- quarter_round[chacha20_h_l60_c29_72f9] LATENCY=1
     -- Inputs
     quarter_round_chacha20_h_l60_c29_72f9_s <= VAR_quarter_round_chacha20_h_l60_c29_72f9_s;
     quarter_round_chacha20_h_l60_c29_72f9_a <= VAR_quarter_round_chacha20_h_l60_c29_72f9_a;
     quarter_round_chacha20_h_l60_c29_72f9_b <= VAR_quarter_round_chacha20_h_l60_c29_72f9_b;
     quarter_round_chacha20_h_l60_c29_72f9_c <= VAR_quarter_round_chacha20_h_l60_c29_72f9_c;
     quarter_round_chacha20_h_l60_c29_72f9_d <= VAR_quarter_round_chacha20_h_l60_c29_72f9_d;

     -- Write to comb signals
   elsif STAGE = 3 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_quarter_round_chacha20_h_l60_c29_72f9_return_output := quarter_round_chacha20_h_l60_c29_72f9_return_output;

     -- Submodule level 0
     VAR_quarter_round_chacha20_h_l61_c29_46a7_s := VAR_quarter_round_chacha20_h_l60_c29_72f9_return_output;
     -- quarter_round[chacha20_h_l61_c29_46a7] LATENCY=0
     -- Inputs
     quarter_round_chacha20_h_l61_c29_46a7_s <= VAR_quarter_round_chacha20_h_l61_c29_46a7_s;
     quarter_round_chacha20_h_l61_c29_46a7_a <= VAR_quarter_round_chacha20_h_l61_c29_46a7_a;
     quarter_round_chacha20_h_l61_c29_46a7_b <= VAR_quarter_round_chacha20_h_l61_c29_46a7_b;
     quarter_round_chacha20_h_l61_c29_46a7_c <= VAR_quarter_round_chacha20_h_l61_c29_46a7_c;
     quarter_round_chacha20_h_l61_c29_46a7_d <= VAR_quarter_round_chacha20_h_l61_c29_46a7_d;
     -- Outputs
     VAR_quarter_round_chacha20_h_l61_c29_46a7_return_output := quarter_round_chacha20_h_l61_c29_46a7_return_output;

     -- Submodule level 1
     VAR_return_output := VAR_quarter_round_chacha20_h_l61_c29_46a7_return_output;
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
