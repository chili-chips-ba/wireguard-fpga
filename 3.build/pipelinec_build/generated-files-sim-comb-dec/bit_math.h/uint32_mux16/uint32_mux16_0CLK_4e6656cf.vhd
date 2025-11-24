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
-- Submodules: 19
entity uint32_mux16_0CLK_4e6656cf is
port(
 sel : in unsigned(3 downto 0);
 in0 : in unsigned(31 downto 0);
 in1 : in unsigned(31 downto 0);
 in2 : in unsigned(31 downto 0);
 in3 : in unsigned(31 downto 0);
 in4 : in unsigned(31 downto 0);
 in5 : in unsigned(31 downto 0);
 in6 : in unsigned(31 downto 0);
 in7 : in unsigned(31 downto 0);
 in8 : in unsigned(31 downto 0);
 in9 : in unsigned(31 downto 0);
 in10 : in unsigned(31 downto 0);
 in11 : in unsigned(31 downto 0);
 in12 : in unsigned(31 downto 0);
 in13 : in unsigned(31 downto 0);
 in14 : in unsigned(31 downto 0);
 in15 : in unsigned(31 downto 0);
 return_output : out unsigned(31 downto 0));
end uint32_mux16_0CLK_4e6656cf;
architecture arch of uint32_mux16_0CLK_4e6656cf is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- layer0_node0_MUX[bit_math_h_l18_c3_01f6]
signal layer0_node0_MUX_bit_math_h_l18_c3_01f6_cond : unsigned(0 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_01f6_iftrue : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_01f6_iffalse : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_01f6_return_output : unsigned(31 downto 0);

-- layer0_node1_MUX[bit_math_h_l29_c3_3dc5]
signal layer0_node1_MUX_bit_math_h_l29_c3_3dc5_cond : unsigned(0 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iftrue : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iffalse : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_3dc5_return_output : unsigned(31 downto 0);

-- layer0_node2_MUX[bit_math_h_l40_c3_178b]
signal layer0_node2_MUX_bit_math_h_l40_c3_178b_cond : unsigned(0 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_178b_iftrue : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_178b_iffalse : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_178b_return_output : unsigned(31 downto 0);

-- layer0_node3_MUX[bit_math_h_l51_c3_3840]
signal layer0_node3_MUX_bit_math_h_l51_c3_3840_cond : unsigned(0 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_3840_iftrue : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_3840_iffalse : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_3840_return_output : unsigned(31 downto 0);

-- layer0_node4_MUX[bit_math_h_l62_c3_dd87]
signal layer0_node4_MUX_bit_math_h_l62_c3_dd87_cond : unsigned(0 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_dd87_iftrue : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_dd87_iffalse : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_dd87_return_output : unsigned(31 downto 0);

-- layer0_node5_MUX[bit_math_h_l73_c3_cc39]
signal layer0_node5_MUX_bit_math_h_l73_c3_cc39_cond : unsigned(0 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_cc39_iftrue : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_cc39_iffalse : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_cc39_return_output : unsigned(31 downto 0);

-- layer0_node6_MUX[bit_math_h_l84_c3_f23b]
signal layer0_node6_MUX_bit_math_h_l84_c3_f23b_cond : unsigned(0 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_f23b_iftrue : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_f23b_iffalse : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_f23b_return_output : unsigned(31 downto 0);

-- layer0_node7_MUX[bit_math_h_l95_c3_6708]
signal layer0_node7_MUX_bit_math_h_l95_c3_6708_cond : unsigned(0 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_6708_iftrue : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_6708_iffalse : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_6708_return_output : unsigned(31 downto 0);

-- layer1_node0_MUX[bit_math_h_l112_c3_d4eb]
signal layer1_node0_MUX_bit_math_h_l112_c3_d4eb_cond : unsigned(0 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iftrue : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iffalse : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_d4eb_return_output : unsigned(31 downto 0);

-- layer1_node1_MUX[bit_math_h_l123_c3_bace]
signal layer1_node1_MUX_bit_math_h_l123_c3_bace_cond : unsigned(0 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_bace_iftrue : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_bace_iffalse : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_bace_return_output : unsigned(31 downto 0);

-- layer1_node2_MUX[bit_math_h_l134_c3_02cb]
signal layer1_node2_MUX_bit_math_h_l134_c3_02cb_cond : unsigned(0 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_02cb_iftrue : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_02cb_iffalse : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_02cb_return_output : unsigned(31 downto 0);

-- layer1_node3_MUX[bit_math_h_l145_c3_eb4d]
signal layer1_node3_MUX_bit_math_h_l145_c3_eb4d_cond : unsigned(0 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iftrue : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iffalse : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_eb4d_return_output : unsigned(31 downto 0);

-- layer2_node0_MUX[bit_math_h_l162_c3_ea59]
signal layer2_node0_MUX_bit_math_h_l162_c3_ea59_cond : unsigned(0 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_ea59_iftrue : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_ea59_iffalse : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_ea59_return_output : unsigned(31 downto 0);

-- layer2_node1_MUX[bit_math_h_l173_c3_f3bf]
signal layer2_node1_MUX_bit_math_h_l173_c3_f3bf_cond : unsigned(0 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iftrue : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iffalse : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_f3bf_return_output : unsigned(31 downto 0);

-- layer3_node0_MUX[bit_math_h_l190_c3_f830]
signal layer3_node0_MUX_bit_math_h_l190_c3_f830_cond : unsigned(0 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_f830_iftrue : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_f830_iffalse : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_f830_return_output : unsigned(31 downto 0);

function uint4_0_0( x : unsigned) return unsigned is
--variable x : unsigned(3 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(0- i);
      end loop;
return return_output;
end function;

function uint4_1_1( x : unsigned) return unsigned is
--variable x : unsigned(3 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(1- i);
      end loop;
return return_output;
end function;

function uint4_2_2( x : unsigned) return unsigned is
--variable x : unsigned(3 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(2- i);
      end loop;
return return_output;
end function;

function uint4_3_3( x : unsigned) return unsigned is
--variable x : unsigned(3 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(3- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- layer0_node0_MUX_bit_math_h_l18_c3_01f6 : 0 clocks latency
layer0_node0_MUX_bit_math_h_l18_c3_01f6 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node0_MUX_bit_math_h_l18_c3_01f6_cond,
layer0_node0_MUX_bit_math_h_l18_c3_01f6_iftrue,
layer0_node0_MUX_bit_math_h_l18_c3_01f6_iffalse,
layer0_node0_MUX_bit_math_h_l18_c3_01f6_return_output);

-- layer0_node1_MUX_bit_math_h_l29_c3_3dc5 : 0 clocks latency
layer0_node1_MUX_bit_math_h_l29_c3_3dc5 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node1_MUX_bit_math_h_l29_c3_3dc5_cond,
layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iftrue,
layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iffalse,
layer0_node1_MUX_bit_math_h_l29_c3_3dc5_return_output);

-- layer0_node2_MUX_bit_math_h_l40_c3_178b : 0 clocks latency
layer0_node2_MUX_bit_math_h_l40_c3_178b : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node2_MUX_bit_math_h_l40_c3_178b_cond,
layer0_node2_MUX_bit_math_h_l40_c3_178b_iftrue,
layer0_node2_MUX_bit_math_h_l40_c3_178b_iffalse,
layer0_node2_MUX_bit_math_h_l40_c3_178b_return_output);

-- layer0_node3_MUX_bit_math_h_l51_c3_3840 : 0 clocks latency
layer0_node3_MUX_bit_math_h_l51_c3_3840 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node3_MUX_bit_math_h_l51_c3_3840_cond,
layer0_node3_MUX_bit_math_h_l51_c3_3840_iftrue,
layer0_node3_MUX_bit_math_h_l51_c3_3840_iffalse,
layer0_node3_MUX_bit_math_h_l51_c3_3840_return_output);

-- layer0_node4_MUX_bit_math_h_l62_c3_dd87 : 0 clocks latency
layer0_node4_MUX_bit_math_h_l62_c3_dd87 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node4_MUX_bit_math_h_l62_c3_dd87_cond,
layer0_node4_MUX_bit_math_h_l62_c3_dd87_iftrue,
layer0_node4_MUX_bit_math_h_l62_c3_dd87_iffalse,
layer0_node4_MUX_bit_math_h_l62_c3_dd87_return_output);

-- layer0_node5_MUX_bit_math_h_l73_c3_cc39 : 0 clocks latency
layer0_node5_MUX_bit_math_h_l73_c3_cc39 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node5_MUX_bit_math_h_l73_c3_cc39_cond,
layer0_node5_MUX_bit_math_h_l73_c3_cc39_iftrue,
layer0_node5_MUX_bit_math_h_l73_c3_cc39_iffalse,
layer0_node5_MUX_bit_math_h_l73_c3_cc39_return_output);

-- layer0_node6_MUX_bit_math_h_l84_c3_f23b : 0 clocks latency
layer0_node6_MUX_bit_math_h_l84_c3_f23b : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node6_MUX_bit_math_h_l84_c3_f23b_cond,
layer0_node6_MUX_bit_math_h_l84_c3_f23b_iftrue,
layer0_node6_MUX_bit_math_h_l84_c3_f23b_iffalse,
layer0_node6_MUX_bit_math_h_l84_c3_f23b_return_output);

-- layer0_node7_MUX_bit_math_h_l95_c3_6708 : 0 clocks latency
layer0_node7_MUX_bit_math_h_l95_c3_6708 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node7_MUX_bit_math_h_l95_c3_6708_cond,
layer0_node7_MUX_bit_math_h_l95_c3_6708_iftrue,
layer0_node7_MUX_bit_math_h_l95_c3_6708_iffalse,
layer0_node7_MUX_bit_math_h_l95_c3_6708_return_output);

-- layer1_node0_MUX_bit_math_h_l112_c3_d4eb : 0 clocks latency
layer1_node0_MUX_bit_math_h_l112_c3_d4eb : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node0_MUX_bit_math_h_l112_c3_d4eb_cond,
layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iftrue,
layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iffalse,
layer1_node0_MUX_bit_math_h_l112_c3_d4eb_return_output);

-- layer1_node1_MUX_bit_math_h_l123_c3_bace : 0 clocks latency
layer1_node1_MUX_bit_math_h_l123_c3_bace : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node1_MUX_bit_math_h_l123_c3_bace_cond,
layer1_node1_MUX_bit_math_h_l123_c3_bace_iftrue,
layer1_node1_MUX_bit_math_h_l123_c3_bace_iffalse,
layer1_node1_MUX_bit_math_h_l123_c3_bace_return_output);

-- layer1_node2_MUX_bit_math_h_l134_c3_02cb : 0 clocks latency
layer1_node2_MUX_bit_math_h_l134_c3_02cb : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node2_MUX_bit_math_h_l134_c3_02cb_cond,
layer1_node2_MUX_bit_math_h_l134_c3_02cb_iftrue,
layer1_node2_MUX_bit_math_h_l134_c3_02cb_iffalse,
layer1_node2_MUX_bit_math_h_l134_c3_02cb_return_output);

-- layer1_node3_MUX_bit_math_h_l145_c3_eb4d : 0 clocks latency
layer1_node3_MUX_bit_math_h_l145_c3_eb4d : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node3_MUX_bit_math_h_l145_c3_eb4d_cond,
layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iftrue,
layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iffalse,
layer1_node3_MUX_bit_math_h_l145_c3_eb4d_return_output);

-- layer2_node0_MUX_bit_math_h_l162_c3_ea59 : 0 clocks latency
layer2_node0_MUX_bit_math_h_l162_c3_ea59 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node0_MUX_bit_math_h_l162_c3_ea59_cond,
layer2_node0_MUX_bit_math_h_l162_c3_ea59_iftrue,
layer2_node0_MUX_bit_math_h_l162_c3_ea59_iffalse,
layer2_node0_MUX_bit_math_h_l162_c3_ea59_return_output);

-- layer2_node1_MUX_bit_math_h_l173_c3_f3bf : 0 clocks latency
layer2_node1_MUX_bit_math_h_l173_c3_f3bf : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node1_MUX_bit_math_h_l173_c3_f3bf_cond,
layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iftrue,
layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iffalse,
layer2_node1_MUX_bit_math_h_l173_c3_f3bf_return_output);

-- layer3_node0_MUX_bit_math_h_l190_c3_f830 : 0 clocks latency
layer3_node0_MUX_bit_math_h_l190_c3_f830 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer3_node0_MUX_bit_math_h_l190_c3_f830_cond,
layer3_node0_MUX_bit_math_h_l190_c3_f830_iftrue,
layer3_node0_MUX_bit_math_h_l190_c3_f830_iffalse,
layer3_node0_MUX_bit_math_h_l190_c3_f830_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 sel,
 in0,
 in1,
 in2,
 in3,
 in4,
 in5,
 in6,
 in7,
 in8,
 in9,
 in10,
 in11,
 in12,
 in13,
 in14,
 in15,
 -- All submodule outputs
 layer0_node0_MUX_bit_math_h_l18_c3_01f6_return_output,
 layer0_node1_MUX_bit_math_h_l29_c3_3dc5_return_output,
 layer0_node2_MUX_bit_math_h_l40_c3_178b_return_output,
 layer0_node3_MUX_bit_math_h_l51_c3_3840_return_output,
 layer0_node4_MUX_bit_math_h_l62_c3_dd87_return_output,
 layer0_node5_MUX_bit_math_h_l73_c3_cc39_return_output,
 layer0_node6_MUX_bit_math_h_l84_c3_f23b_return_output,
 layer0_node7_MUX_bit_math_h_l95_c3_6708_return_output,
 layer1_node0_MUX_bit_math_h_l112_c3_d4eb_return_output,
 layer1_node1_MUX_bit_math_h_l123_c3_bace_return_output,
 layer1_node2_MUX_bit_math_h_l134_c3_02cb_return_output,
 layer1_node3_MUX_bit_math_h_l145_c3_eb4d_return_output,
 layer2_node0_MUX_bit_math_h_l162_c3_ea59_return_output,
 layer2_node1_MUX_bit_math_h_l173_c3_f3bf_return_output,
 layer3_node0_MUX_bit_math_h_l190_c3_f830_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : unsigned(31 downto 0);
 variable VAR_sel : unsigned(3 downto 0);
 variable VAR_in0 : unsigned(31 downto 0);
 variable VAR_in1 : unsigned(31 downto 0);
 variable VAR_in2 : unsigned(31 downto 0);
 variable VAR_in3 : unsigned(31 downto 0);
 variable VAR_in4 : unsigned(31 downto 0);
 variable VAR_in5 : unsigned(31 downto 0);
 variable VAR_in6 : unsigned(31 downto 0);
 variable VAR_in7 : unsigned(31 downto 0);
 variable VAR_in8 : unsigned(31 downto 0);
 variable VAR_in9 : unsigned(31 downto 0);
 variable VAR_in10 : unsigned(31 downto 0);
 variable VAR_in11 : unsigned(31 downto 0);
 variable VAR_in12 : unsigned(31 downto 0);
 variable VAR_in13 : unsigned(31 downto 0);
 variable VAR_in14 : unsigned(31 downto 0);
 variable VAR_in15 : unsigned(31 downto 0);
 variable VAR_sel0 : unsigned(0 downto 0);
 variable VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output : unsigned(0 downto 0);
 variable VAR_layer0_node0 : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_cond : unsigned(0 downto 0);
 variable VAR_layer0_node1 : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_cond : unsigned(0 downto 0);
 variable VAR_layer0_node2 : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_cond : unsigned(0 downto 0);
 variable VAR_layer0_node3 : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_cond : unsigned(0 downto 0);
 variable VAR_layer0_node4 : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_cond : unsigned(0 downto 0);
 variable VAR_layer0_node5 : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_cond : unsigned(0 downto 0);
 variable VAR_layer0_node6 : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_cond : unsigned(0 downto 0);
 variable VAR_layer0_node7 : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_cond : unsigned(0 downto 0);
 variable VAR_sel1 : unsigned(0 downto 0);
 variable VAR_uint4_1_1_bit_math_h_l108_c10_0e20_return_output : unsigned(0 downto 0);
 variable VAR_layer1_node0 : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_cond : unsigned(0 downto 0);
 variable VAR_layer1_node1 : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_cond : unsigned(0 downto 0);
 variable VAR_layer1_node2 : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_cond : unsigned(0 downto 0);
 variable VAR_layer1_node3 : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_cond : unsigned(0 downto 0);
 variable VAR_sel2 : unsigned(0 downto 0);
 variable VAR_uint4_2_2_bit_math_h_l158_c10_b8da_return_output : unsigned(0 downto 0);
 variable VAR_layer2_node0 : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_cond : unsigned(0 downto 0);
 variable VAR_layer2_node1 : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_cond : unsigned(0 downto 0);
 variable VAR_sel3 : unsigned(0 downto 0);
 variable VAR_uint4_3_3_bit_math_h_l186_c10_caa0_return_output : unsigned(0 downto 0);
 variable VAR_layer3_node0 : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_iftrue : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_iffalse : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_return_output : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_cond : unsigned(0 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_sel := sel;
     VAR_in0 := in0;
     VAR_in1 := in1;
     VAR_in2 := in2;
     VAR_in3 := in3;
     VAR_in4 := in4;
     VAR_in5 := in5;
     VAR_in6 := in6;
     VAR_in7 := in7;
     VAR_in8 := in8;
     VAR_in9 := in9;
     VAR_in10 := in10;
     VAR_in11 := in11;
     VAR_in12 := in12;
     VAR_in13 := in13;
     VAR_in14 := in14;
     VAR_in15 := in15;

     -- Submodule level 0
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_iffalse := VAR_in0;
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_iftrue := VAR_in1;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_iffalse := VAR_in10;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_iftrue := VAR_in11;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_iffalse := VAR_in12;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_iftrue := VAR_in13;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_iffalse := VAR_in14;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_iftrue := VAR_in15;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iffalse := VAR_in2;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iftrue := VAR_in3;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_iffalse := VAR_in4;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_iftrue := VAR_in5;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_iffalse := VAR_in6;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_iftrue := VAR_in7;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_iffalse := VAR_in8;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_iftrue := VAR_in9;
     -- uint4_3_3[bit_math_h_l186_c10_caa0] LATENCY=0
     VAR_uint4_3_3_bit_math_h_l186_c10_caa0_return_output := uint4_3_3(
     VAR_sel);

     -- uint4_1_1[bit_math_h_l108_c10_0e20] LATENCY=0
     VAR_uint4_1_1_bit_math_h_l108_c10_0e20_return_output := uint4_1_1(
     VAR_sel);

     -- uint4_0_0[bit_math_h_l14_c10_e74d] LATENCY=0
     VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output := uint4_0_0(
     VAR_sel);

     -- uint4_2_2[bit_math_h_l158_c10_b8da] LATENCY=0
     VAR_uint4_2_2_bit_math_h_l158_c10_b8da_return_output := uint4_2_2(
     VAR_sel);

     -- Submodule level 1
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_cond := VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_cond := VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_cond := VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_cond := VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_cond := VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_cond := VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_cond := VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_cond := VAR_uint4_0_0_bit_math_h_l14_c10_e74d_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_cond := VAR_uint4_1_1_bit_math_h_l108_c10_0e20_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_cond := VAR_uint4_1_1_bit_math_h_l108_c10_0e20_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_cond := VAR_uint4_1_1_bit_math_h_l108_c10_0e20_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_cond := VAR_uint4_1_1_bit_math_h_l108_c10_0e20_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_cond := VAR_uint4_2_2_bit_math_h_l158_c10_b8da_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_cond := VAR_uint4_2_2_bit_math_h_l158_c10_b8da_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_cond := VAR_uint4_3_3_bit_math_h_l186_c10_caa0_return_output;
     -- layer0_node7_MUX[bit_math_h_l95_c3_6708] LATENCY=0
     -- Inputs
     layer0_node7_MUX_bit_math_h_l95_c3_6708_cond <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_cond;
     layer0_node7_MUX_bit_math_h_l95_c3_6708_iftrue <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_iftrue;
     layer0_node7_MUX_bit_math_h_l95_c3_6708_iffalse <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_iffalse;
     -- Outputs
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_return_output := layer0_node7_MUX_bit_math_h_l95_c3_6708_return_output;

     -- layer0_node3_MUX[bit_math_h_l51_c3_3840] LATENCY=0
     -- Inputs
     layer0_node3_MUX_bit_math_h_l51_c3_3840_cond <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_cond;
     layer0_node3_MUX_bit_math_h_l51_c3_3840_iftrue <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_iftrue;
     layer0_node3_MUX_bit_math_h_l51_c3_3840_iffalse <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_iffalse;
     -- Outputs
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_return_output := layer0_node3_MUX_bit_math_h_l51_c3_3840_return_output;

     -- layer0_node5_MUX[bit_math_h_l73_c3_cc39] LATENCY=0
     -- Inputs
     layer0_node5_MUX_bit_math_h_l73_c3_cc39_cond <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_cond;
     layer0_node5_MUX_bit_math_h_l73_c3_cc39_iftrue <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_iftrue;
     layer0_node5_MUX_bit_math_h_l73_c3_cc39_iffalse <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_iffalse;
     -- Outputs
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_return_output := layer0_node5_MUX_bit_math_h_l73_c3_cc39_return_output;

     -- layer0_node4_MUX[bit_math_h_l62_c3_dd87] LATENCY=0
     -- Inputs
     layer0_node4_MUX_bit_math_h_l62_c3_dd87_cond <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_cond;
     layer0_node4_MUX_bit_math_h_l62_c3_dd87_iftrue <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_iftrue;
     layer0_node4_MUX_bit_math_h_l62_c3_dd87_iffalse <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_iffalse;
     -- Outputs
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_return_output := layer0_node4_MUX_bit_math_h_l62_c3_dd87_return_output;

     -- layer0_node1_MUX[bit_math_h_l29_c3_3dc5] LATENCY=0
     -- Inputs
     layer0_node1_MUX_bit_math_h_l29_c3_3dc5_cond <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_cond;
     layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iftrue <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iftrue;
     layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iffalse <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_iffalse;
     -- Outputs
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_return_output := layer0_node1_MUX_bit_math_h_l29_c3_3dc5_return_output;

     -- layer0_node2_MUX[bit_math_h_l40_c3_178b] LATENCY=0
     -- Inputs
     layer0_node2_MUX_bit_math_h_l40_c3_178b_cond <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_cond;
     layer0_node2_MUX_bit_math_h_l40_c3_178b_iftrue <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_iftrue;
     layer0_node2_MUX_bit_math_h_l40_c3_178b_iffalse <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_iffalse;
     -- Outputs
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_return_output := layer0_node2_MUX_bit_math_h_l40_c3_178b_return_output;

     -- layer0_node6_MUX[bit_math_h_l84_c3_f23b] LATENCY=0
     -- Inputs
     layer0_node6_MUX_bit_math_h_l84_c3_f23b_cond <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_cond;
     layer0_node6_MUX_bit_math_h_l84_c3_f23b_iftrue <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_iftrue;
     layer0_node6_MUX_bit_math_h_l84_c3_f23b_iffalse <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_iffalse;
     -- Outputs
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_return_output := layer0_node6_MUX_bit_math_h_l84_c3_f23b_return_output;

     -- layer0_node0_MUX[bit_math_h_l18_c3_01f6] LATENCY=0
     -- Inputs
     layer0_node0_MUX_bit_math_h_l18_c3_01f6_cond <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_cond;
     layer0_node0_MUX_bit_math_h_l18_c3_01f6_iftrue <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_iftrue;
     layer0_node0_MUX_bit_math_h_l18_c3_01f6_iffalse <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_iffalse;
     -- Outputs
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_return_output := layer0_node0_MUX_bit_math_h_l18_c3_01f6_return_output;

     -- Submodule level 2
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iffalse := VAR_layer0_node0_MUX_bit_math_h_l18_c3_01f6_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iftrue := VAR_layer0_node1_MUX_bit_math_h_l29_c3_3dc5_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_iffalse := VAR_layer0_node2_MUX_bit_math_h_l40_c3_178b_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_iftrue := VAR_layer0_node3_MUX_bit_math_h_l51_c3_3840_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_iffalse := VAR_layer0_node4_MUX_bit_math_h_l62_c3_dd87_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_iftrue := VAR_layer0_node5_MUX_bit_math_h_l73_c3_cc39_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iffalse := VAR_layer0_node6_MUX_bit_math_h_l84_c3_f23b_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iftrue := VAR_layer0_node7_MUX_bit_math_h_l95_c3_6708_return_output;
     -- layer1_node3_MUX[bit_math_h_l145_c3_eb4d] LATENCY=0
     -- Inputs
     layer1_node3_MUX_bit_math_h_l145_c3_eb4d_cond <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_cond;
     layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iftrue <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iftrue;
     layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iffalse <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_iffalse;
     -- Outputs
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_return_output := layer1_node3_MUX_bit_math_h_l145_c3_eb4d_return_output;

     -- layer1_node0_MUX[bit_math_h_l112_c3_d4eb] LATENCY=0
     -- Inputs
     layer1_node0_MUX_bit_math_h_l112_c3_d4eb_cond <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_cond;
     layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iftrue <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iftrue;
     layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iffalse <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_iffalse;
     -- Outputs
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_return_output := layer1_node0_MUX_bit_math_h_l112_c3_d4eb_return_output;

     -- layer1_node1_MUX[bit_math_h_l123_c3_bace] LATENCY=0
     -- Inputs
     layer1_node1_MUX_bit_math_h_l123_c3_bace_cond <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_cond;
     layer1_node1_MUX_bit_math_h_l123_c3_bace_iftrue <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_iftrue;
     layer1_node1_MUX_bit_math_h_l123_c3_bace_iffalse <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_iffalse;
     -- Outputs
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_return_output := layer1_node1_MUX_bit_math_h_l123_c3_bace_return_output;

     -- layer1_node2_MUX[bit_math_h_l134_c3_02cb] LATENCY=0
     -- Inputs
     layer1_node2_MUX_bit_math_h_l134_c3_02cb_cond <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_cond;
     layer1_node2_MUX_bit_math_h_l134_c3_02cb_iftrue <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_iftrue;
     layer1_node2_MUX_bit_math_h_l134_c3_02cb_iffalse <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_iffalse;
     -- Outputs
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_return_output := layer1_node2_MUX_bit_math_h_l134_c3_02cb_return_output;

     -- Submodule level 3
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_iffalse := VAR_layer1_node0_MUX_bit_math_h_l112_c3_d4eb_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_iftrue := VAR_layer1_node1_MUX_bit_math_h_l123_c3_bace_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iffalse := VAR_layer1_node2_MUX_bit_math_h_l134_c3_02cb_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iftrue := VAR_layer1_node3_MUX_bit_math_h_l145_c3_eb4d_return_output;
     -- layer2_node0_MUX[bit_math_h_l162_c3_ea59] LATENCY=0
     -- Inputs
     layer2_node0_MUX_bit_math_h_l162_c3_ea59_cond <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_cond;
     layer2_node0_MUX_bit_math_h_l162_c3_ea59_iftrue <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_iftrue;
     layer2_node0_MUX_bit_math_h_l162_c3_ea59_iffalse <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_iffalse;
     -- Outputs
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_return_output := layer2_node0_MUX_bit_math_h_l162_c3_ea59_return_output;

     -- layer2_node1_MUX[bit_math_h_l173_c3_f3bf] LATENCY=0
     -- Inputs
     layer2_node1_MUX_bit_math_h_l173_c3_f3bf_cond <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_cond;
     layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iftrue <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iftrue;
     layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iffalse <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_iffalse;
     -- Outputs
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_return_output := layer2_node1_MUX_bit_math_h_l173_c3_f3bf_return_output;

     -- Submodule level 4
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_iffalse := VAR_layer2_node0_MUX_bit_math_h_l162_c3_ea59_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_iftrue := VAR_layer2_node1_MUX_bit_math_h_l173_c3_f3bf_return_output;
     -- layer3_node0_MUX[bit_math_h_l190_c3_f830] LATENCY=0
     -- Inputs
     layer3_node0_MUX_bit_math_h_l190_c3_f830_cond <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_cond;
     layer3_node0_MUX_bit_math_h_l190_c3_f830_iftrue <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_iftrue;
     layer3_node0_MUX_bit_math_h_l190_c3_f830_iffalse <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_iffalse;
     -- Outputs
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_return_output := layer3_node0_MUX_bit_math_h_l190_c3_f830_return_output;

     -- Submodule level 5
     VAR_return_output := VAR_layer3_node0_MUX_bit_math_h_l190_c3_f830_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
