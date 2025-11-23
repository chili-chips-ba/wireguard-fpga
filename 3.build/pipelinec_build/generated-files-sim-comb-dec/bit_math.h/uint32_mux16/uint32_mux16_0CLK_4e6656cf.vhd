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
-- layer0_node0_MUX[bit_math_h_l18_c3_e105]
signal layer0_node0_MUX_bit_math_h_l18_c3_e105_cond : unsigned(0 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_e105_iftrue : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_e105_iffalse : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_e105_return_output : unsigned(31 downto 0);

-- layer0_node1_MUX[bit_math_h_l29_c3_e447]
signal layer0_node1_MUX_bit_math_h_l29_c3_e447_cond : unsigned(0 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_e447_iftrue : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_e447_iffalse : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_e447_return_output : unsigned(31 downto 0);

-- layer0_node2_MUX[bit_math_h_l40_c3_b9de]
signal layer0_node2_MUX_bit_math_h_l40_c3_b9de_cond : unsigned(0 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_b9de_iftrue : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_b9de_iffalse : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_b9de_return_output : unsigned(31 downto 0);

-- layer0_node3_MUX[bit_math_h_l51_c3_ecfd]
signal layer0_node3_MUX_bit_math_h_l51_c3_ecfd_cond : unsigned(0 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iftrue : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iffalse : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_ecfd_return_output : unsigned(31 downto 0);

-- layer0_node4_MUX[bit_math_h_l62_c3_e8a3]
signal layer0_node4_MUX_bit_math_h_l62_c3_e8a3_cond : unsigned(0 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iftrue : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iffalse : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_e8a3_return_output : unsigned(31 downto 0);

-- layer0_node5_MUX[bit_math_h_l73_c3_dc5a]
signal layer0_node5_MUX_bit_math_h_l73_c3_dc5a_cond : unsigned(0 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iftrue : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iffalse : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_dc5a_return_output : unsigned(31 downto 0);

-- layer0_node6_MUX[bit_math_h_l84_c3_fb39]
signal layer0_node6_MUX_bit_math_h_l84_c3_fb39_cond : unsigned(0 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_fb39_iftrue : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_fb39_iffalse : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_fb39_return_output : unsigned(31 downto 0);

-- layer0_node7_MUX[bit_math_h_l95_c3_ab50]
signal layer0_node7_MUX_bit_math_h_l95_c3_ab50_cond : unsigned(0 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_ab50_iftrue : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_ab50_iffalse : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_ab50_return_output : unsigned(31 downto 0);

-- layer1_node0_MUX[bit_math_h_l112_c3_cb34]
signal layer1_node0_MUX_bit_math_h_l112_c3_cb34_cond : unsigned(0 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_cb34_iftrue : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_cb34_iffalse : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_cb34_return_output : unsigned(31 downto 0);

-- layer1_node1_MUX[bit_math_h_l123_c3_7968]
signal layer1_node1_MUX_bit_math_h_l123_c3_7968_cond : unsigned(0 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_7968_iftrue : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_7968_iffalse : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_7968_return_output : unsigned(31 downto 0);

-- layer1_node2_MUX[bit_math_h_l134_c3_ea80]
signal layer1_node2_MUX_bit_math_h_l134_c3_ea80_cond : unsigned(0 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_ea80_iftrue : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_ea80_iffalse : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_ea80_return_output : unsigned(31 downto 0);

-- layer1_node3_MUX[bit_math_h_l145_c3_735e]
signal layer1_node3_MUX_bit_math_h_l145_c3_735e_cond : unsigned(0 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_735e_iftrue : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_735e_iffalse : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_735e_return_output : unsigned(31 downto 0);

-- layer2_node0_MUX[bit_math_h_l162_c3_a284]
signal layer2_node0_MUX_bit_math_h_l162_c3_a284_cond : unsigned(0 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_a284_iftrue : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_a284_iffalse : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_a284_return_output : unsigned(31 downto 0);

-- layer2_node1_MUX[bit_math_h_l173_c3_d086]
signal layer2_node1_MUX_bit_math_h_l173_c3_d086_cond : unsigned(0 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_d086_iftrue : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_d086_iffalse : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_d086_return_output : unsigned(31 downto 0);

-- layer3_node0_MUX[bit_math_h_l190_c3_c2c5]
signal layer3_node0_MUX_bit_math_h_l190_c3_c2c5_cond : unsigned(0 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iftrue : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iffalse : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_c2c5_return_output : unsigned(31 downto 0);

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
-- layer0_node0_MUX_bit_math_h_l18_c3_e105 : 0 clocks latency
layer0_node0_MUX_bit_math_h_l18_c3_e105 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node0_MUX_bit_math_h_l18_c3_e105_cond,
layer0_node0_MUX_bit_math_h_l18_c3_e105_iftrue,
layer0_node0_MUX_bit_math_h_l18_c3_e105_iffalse,
layer0_node0_MUX_bit_math_h_l18_c3_e105_return_output);

-- layer0_node1_MUX_bit_math_h_l29_c3_e447 : 0 clocks latency
layer0_node1_MUX_bit_math_h_l29_c3_e447 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node1_MUX_bit_math_h_l29_c3_e447_cond,
layer0_node1_MUX_bit_math_h_l29_c3_e447_iftrue,
layer0_node1_MUX_bit_math_h_l29_c3_e447_iffalse,
layer0_node1_MUX_bit_math_h_l29_c3_e447_return_output);

-- layer0_node2_MUX_bit_math_h_l40_c3_b9de : 0 clocks latency
layer0_node2_MUX_bit_math_h_l40_c3_b9de : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node2_MUX_bit_math_h_l40_c3_b9de_cond,
layer0_node2_MUX_bit_math_h_l40_c3_b9de_iftrue,
layer0_node2_MUX_bit_math_h_l40_c3_b9de_iffalse,
layer0_node2_MUX_bit_math_h_l40_c3_b9de_return_output);

-- layer0_node3_MUX_bit_math_h_l51_c3_ecfd : 0 clocks latency
layer0_node3_MUX_bit_math_h_l51_c3_ecfd : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node3_MUX_bit_math_h_l51_c3_ecfd_cond,
layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iftrue,
layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iffalse,
layer0_node3_MUX_bit_math_h_l51_c3_ecfd_return_output);

-- layer0_node4_MUX_bit_math_h_l62_c3_e8a3 : 0 clocks latency
layer0_node4_MUX_bit_math_h_l62_c3_e8a3 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node4_MUX_bit_math_h_l62_c3_e8a3_cond,
layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iftrue,
layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iffalse,
layer0_node4_MUX_bit_math_h_l62_c3_e8a3_return_output);

-- layer0_node5_MUX_bit_math_h_l73_c3_dc5a : 0 clocks latency
layer0_node5_MUX_bit_math_h_l73_c3_dc5a : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node5_MUX_bit_math_h_l73_c3_dc5a_cond,
layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iftrue,
layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iffalse,
layer0_node5_MUX_bit_math_h_l73_c3_dc5a_return_output);

-- layer0_node6_MUX_bit_math_h_l84_c3_fb39 : 0 clocks latency
layer0_node6_MUX_bit_math_h_l84_c3_fb39 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node6_MUX_bit_math_h_l84_c3_fb39_cond,
layer0_node6_MUX_bit_math_h_l84_c3_fb39_iftrue,
layer0_node6_MUX_bit_math_h_l84_c3_fb39_iffalse,
layer0_node6_MUX_bit_math_h_l84_c3_fb39_return_output);

-- layer0_node7_MUX_bit_math_h_l95_c3_ab50 : 0 clocks latency
layer0_node7_MUX_bit_math_h_l95_c3_ab50 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node7_MUX_bit_math_h_l95_c3_ab50_cond,
layer0_node7_MUX_bit_math_h_l95_c3_ab50_iftrue,
layer0_node7_MUX_bit_math_h_l95_c3_ab50_iffalse,
layer0_node7_MUX_bit_math_h_l95_c3_ab50_return_output);

-- layer1_node0_MUX_bit_math_h_l112_c3_cb34 : 0 clocks latency
layer1_node0_MUX_bit_math_h_l112_c3_cb34 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node0_MUX_bit_math_h_l112_c3_cb34_cond,
layer1_node0_MUX_bit_math_h_l112_c3_cb34_iftrue,
layer1_node0_MUX_bit_math_h_l112_c3_cb34_iffalse,
layer1_node0_MUX_bit_math_h_l112_c3_cb34_return_output);

-- layer1_node1_MUX_bit_math_h_l123_c3_7968 : 0 clocks latency
layer1_node1_MUX_bit_math_h_l123_c3_7968 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node1_MUX_bit_math_h_l123_c3_7968_cond,
layer1_node1_MUX_bit_math_h_l123_c3_7968_iftrue,
layer1_node1_MUX_bit_math_h_l123_c3_7968_iffalse,
layer1_node1_MUX_bit_math_h_l123_c3_7968_return_output);

-- layer1_node2_MUX_bit_math_h_l134_c3_ea80 : 0 clocks latency
layer1_node2_MUX_bit_math_h_l134_c3_ea80 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node2_MUX_bit_math_h_l134_c3_ea80_cond,
layer1_node2_MUX_bit_math_h_l134_c3_ea80_iftrue,
layer1_node2_MUX_bit_math_h_l134_c3_ea80_iffalse,
layer1_node2_MUX_bit_math_h_l134_c3_ea80_return_output);

-- layer1_node3_MUX_bit_math_h_l145_c3_735e : 0 clocks latency
layer1_node3_MUX_bit_math_h_l145_c3_735e : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node3_MUX_bit_math_h_l145_c3_735e_cond,
layer1_node3_MUX_bit_math_h_l145_c3_735e_iftrue,
layer1_node3_MUX_bit_math_h_l145_c3_735e_iffalse,
layer1_node3_MUX_bit_math_h_l145_c3_735e_return_output);

-- layer2_node0_MUX_bit_math_h_l162_c3_a284 : 0 clocks latency
layer2_node0_MUX_bit_math_h_l162_c3_a284 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node0_MUX_bit_math_h_l162_c3_a284_cond,
layer2_node0_MUX_bit_math_h_l162_c3_a284_iftrue,
layer2_node0_MUX_bit_math_h_l162_c3_a284_iffalse,
layer2_node0_MUX_bit_math_h_l162_c3_a284_return_output);

-- layer2_node1_MUX_bit_math_h_l173_c3_d086 : 0 clocks latency
layer2_node1_MUX_bit_math_h_l173_c3_d086 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node1_MUX_bit_math_h_l173_c3_d086_cond,
layer2_node1_MUX_bit_math_h_l173_c3_d086_iftrue,
layer2_node1_MUX_bit_math_h_l173_c3_d086_iffalse,
layer2_node1_MUX_bit_math_h_l173_c3_d086_return_output);

-- layer3_node0_MUX_bit_math_h_l190_c3_c2c5 : 0 clocks latency
layer3_node0_MUX_bit_math_h_l190_c3_c2c5 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer3_node0_MUX_bit_math_h_l190_c3_c2c5_cond,
layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iftrue,
layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iffalse,
layer3_node0_MUX_bit_math_h_l190_c3_c2c5_return_output);



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
 layer0_node0_MUX_bit_math_h_l18_c3_e105_return_output,
 layer0_node1_MUX_bit_math_h_l29_c3_e447_return_output,
 layer0_node2_MUX_bit_math_h_l40_c3_b9de_return_output,
 layer0_node3_MUX_bit_math_h_l51_c3_ecfd_return_output,
 layer0_node4_MUX_bit_math_h_l62_c3_e8a3_return_output,
 layer0_node5_MUX_bit_math_h_l73_c3_dc5a_return_output,
 layer0_node6_MUX_bit_math_h_l84_c3_fb39_return_output,
 layer0_node7_MUX_bit_math_h_l95_c3_ab50_return_output,
 layer1_node0_MUX_bit_math_h_l112_c3_cb34_return_output,
 layer1_node1_MUX_bit_math_h_l123_c3_7968_return_output,
 layer1_node2_MUX_bit_math_h_l134_c3_ea80_return_output,
 layer1_node3_MUX_bit_math_h_l145_c3_735e_return_output,
 layer2_node0_MUX_bit_math_h_l162_c3_a284_return_output,
 layer2_node1_MUX_bit_math_h_l173_c3_d086_return_output,
 layer3_node0_MUX_bit_math_h_l190_c3_c2c5_return_output)
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
 variable VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output : unsigned(0 downto 0);
 variable VAR_layer0_node0 : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_cond : unsigned(0 downto 0);
 variable VAR_layer0_node1 : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_cond : unsigned(0 downto 0);
 variable VAR_layer0_node2 : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_cond : unsigned(0 downto 0);
 variable VAR_layer0_node3 : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_cond : unsigned(0 downto 0);
 variable VAR_layer0_node4 : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_cond : unsigned(0 downto 0);
 variable VAR_layer0_node5 : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_cond : unsigned(0 downto 0);
 variable VAR_layer0_node6 : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_cond : unsigned(0 downto 0);
 variable VAR_layer0_node7 : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_cond : unsigned(0 downto 0);
 variable VAR_sel1 : unsigned(0 downto 0);
 variable VAR_uint4_1_1_bit_math_h_l108_c10_3c10_return_output : unsigned(0 downto 0);
 variable VAR_layer1_node0 : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_cond : unsigned(0 downto 0);
 variable VAR_layer1_node1 : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_cond : unsigned(0 downto 0);
 variable VAR_layer1_node2 : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_cond : unsigned(0 downto 0);
 variable VAR_layer1_node3 : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_cond : unsigned(0 downto 0);
 variable VAR_sel2 : unsigned(0 downto 0);
 variable VAR_uint4_2_2_bit_math_h_l158_c10_9acc_return_output : unsigned(0 downto 0);
 variable VAR_layer2_node0 : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_cond : unsigned(0 downto 0);
 variable VAR_layer2_node1 : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_cond : unsigned(0 downto 0);
 variable VAR_sel3 : unsigned(0 downto 0);
 variable VAR_uint4_3_3_bit_math_h_l186_c10_0c6e_return_output : unsigned(0 downto 0);
 variable VAR_layer3_node0 : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iftrue : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iffalse : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_return_output : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_cond : unsigned(0 downto 0);
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
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_iffalse := VAR_in0;
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_iftrue := VAR_in1;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iffalse := VAR_in10;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iftrue := VAR_in11;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_iffalse := VAR_in12;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_iftrue := VAR_in13;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_iffalse := VAR_in14;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_iftrue := VAR_in15;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_iffalse := VAR_in2;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_iftrue := VAR_in3;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_iffalse := VAR_in4;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_iftrue := VAR_in5;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iffalse := VAR_in6;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iftrue := VAR_in7;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iffalse := VAR_in8;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iftrue := VAR_in9;
     -- uint4_0_0[bit_math_h_l14_c10_fb05] LATENCY=0
     VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output := uint4_0_0(
     VAR_sel);

     -- uint4_2_2[bit_math_h_l158_c10_9acc] LATENCY=0
     VAR_uint4_2_2_bit_math_h_l158_c10_9acc_return_output := uint4_2_2(
     VAR_sel);

     -- uint4_3_3[bit_math_h_l186_c10_0c6e] LATENCY=0
     VAR_uint4_3_3_bit_math_h_l186_c10_0c6e_return_output := uint4_3_3(
     VAR_sel);

     -- uint4_1_1[bit_math_h_l108_c10_3c10] LATENCY=0
     VAR_uint4_1_1_bit_math_h_l108_c10_3c10_return_output := uint4_1_1(
     VAR_sel);

     -- Submodule level 1
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fb05_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_cond := VAR_uint4_1_1_bit_math_h_l108_c10_3c10_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_cond := VAR_uint4_1_1_bit_math_h_l108_c10_3c10_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_cond := VAR_uint4_1_1_bit_math_h_l108_c10_3c10_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_cond := VAR_uint4_1_1_bit_math_h_l108_c10_3c10_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_cond := VAR_uint4_2_2_bit_math_h_l158_c10_9acc_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_cond := VAR_uint4_2_2_bit_math_h_l158_c10_9acc_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_cond := VAR_uint4_3_3_bit_math_h_l186_c10_0c6e_return_output;
     -- layer0_node5_MUX[bit_math_h_l73_c3_dc5a] LATENCY=0
     -- Inputs
     layer0_node5_MUX_bit_math_h_l73_c3_dc5a_cond <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_cond;
     layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iftrue <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iftrue;
     layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iffalse <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_iffalse;
     -- Outputs
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_return_output := layer0_node5_MUX_bit_math_h_l73_c3_dc5a_return_output;

     -- layer0_node1_MUX[bit_math_h_l29_c3_e447] LATENCY=0
     -- Inputs
     layer0_node1_MUX_bit_math_h_l29_c3_e447_cond <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_cond;
     layer0_node1_MUX_bit_math_h_l29_c3_e447_iftrue <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_iftrue;
     layer0_node1_MUX_bit_math_h_l29_c3_e447_iffalse <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_iffalse;
     -- Outputs
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_return_output := layer0_node1_MUX_bit_math_h_l29_c3_e447_return_output;

     -- layer0_node2_MUX[bit_math_h_l40_c3_b9de] LATENCY=0
     -- Inputs
     layer0_node2_MUX_bit_math_h_l40_c3_b9de_cond <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_cond;
     layer0_node2_MUX_bit_math_h_l40_c3_b9de_iftrue <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_iftrue;
     layer0_node2_MUX_bit_math_h_l40_c3_b9de_iffalse <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_iffalse;
     -- Outputs
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_return_output := layer0_node2_MUX_bit_math_h_l40_c3_b9de_return_output;

     -- layer0_node0_MUX[bit_math_h_l18_c3_e105] LATENCY=0
     -- Inputs
     layer0_node0_MUX_bit_math_h_l18_c3_e105_cond <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_cond;
     layer0_node0_MUX_bit_math_h_l18_c3_e105_iftrue <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_iftrue;
     layer0_node0_MUX_bit_math_h_l18_c3_e105_iffalse <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_iffalse;
     -- Outputs
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_return_output := layer0_node0_MUX_bit_math_h_l18_c3_e105_return_output;

     -- layer0_node3_MUX[bit_math_h_l51_c3_ecfd] LATENCY=0
     -- Inputs
     layer0_node3_MUX_bit_math_h_l51_c3_ecfd_cond <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_cond;
     layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iftrue <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iftrue;
     layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iffalse <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_iffalse;
     -- Outputs
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_return_output := layer0_node3_MUX_bit_math_h_l51_c3_ecfd_return_output;

     -- layer0_node4_MUX[bit_math_h_l62_c3_e8a3] LATENCY=0
     -- Inputs
     layer0_node4_MUX_bit_math_h_l62_c3_e8a3_cond <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_cond;
     layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iftrue <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iftrue;
     layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iffalse <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_iffalse;
     -- Outputs
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_return_output := layer0_node4_MUX_bit_math_h_l62_c3_e8a3_return_output;

     -- layer0_node6_MUX[bit_math_h_l84_c3_fb39] LATENCY=0
     -- Inputs
     layer0_node6_MUX_bit_math_h_l84_c3_fb39_cond <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_cond;
     layer0_node6_MUX_bit_math_h_l84_c3_fb39_iftrue <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_iftrue;
     layer0_node6_MUX_bit_math_h_l84_c3_fb39_iffalse <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_iffalse;
     -- Outputs
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_return_output := layer0_node6_MUX_bit_math_h_l84_c3_fb39_return_output;

     -- layer0_node7_MUX[bit_math_h_l95_c3_ab50] LATENCY=0
     -- Inputs
     layer0_node7_MUX_bit_math_h_l95_c3_ab50_cond <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_cond;
     layer0_node7_MUX_bit_math_h_l95_c3_ab50_iftrue <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_iftrue;
     layer0_node7_MUX_bit_math_h_l95_c3_ab50_iffalse <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_iffalse;
     -- Outputs
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_return_output := layer0_node7_MUX_bit_math_h_l95_c3_ab50_return_output;

     -- Submodule level 2
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_iffalse := VAR_layer0_node0_MUX_bit_math_h_l18_c3_e105_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_iftrue := VAR_layer0_node1_MUX_bit_math_h_l29_c3_e447_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_iffalse := VAR_layer0_node2_MUX_bit_math_h_l40_c3_b9de_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_iftrue := VAR_layer0_node3_MUX_bit_math_h_l51_c3_ecfd_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_iffalse := VAR_layer0_node4_MUX_bit_math_h_l62_c3_e8a3_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_iftrue := VAR_layer0_node5_MUX_bit_math_h_l73_c3_dc5a_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_iffalse := VAR_layer0_node6_MUX_bit_math_h_l84_c3_fb39_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_iftrue := VAR_layer0_node7_MUX_bit_math_h_l95_c3_ab50_return_output;
     -- layer1_node3_MUX[bit_math_h_l145_c3_735e] LATENCY=0
     -- Inputs
     layer1_node3_MUX_bit_math_h_l145_c3_735e_cond <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_cond;
     layer1_node3_MUX_bit_math_h_l145_c3_735e_iftrue <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_iftrue;
     layer1_node3_MUX_bit_math_h_l145_c3_735e_iffalse <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_iffalse;
     -- Outputs
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_return_output := layer1_node3_MUX_bit_math_h_l145_c3_735e_return_output;

     -- layer1_node1_MUX[bit_math_h_l123_c3_7968] LATENCY=0
     -- Inputs
     layer1_node1_MUX_bit_math_h_l123_c3_7968_cond <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_cond;
     layer1_node1_MUX_bit_math_h_l123_c3_7968_iftrue <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_iftrue;
     layer1_node1_MUX_bit_math_h_l123_c3_7968_iffalse <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_iffalse;
     -- Outputs
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_return_output := layer1_node1_MUX_bit_math_h_l123_c3_7968_return_output;

     -- layer1_node0_MUX[bit_math_h_l112_c3_cb34] LATENCY=0
     -- Inputs
     layer1_node0_MUX_bit_math_h_l112_c3_cb34_cond <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_cond;
     layer1_node0_MUX_bit_math_h_l112_c3_cb34_iftrue <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_iftrue;
     layer1_node0_MUX_bit_math_h_l112_c3_cb34_iffalse <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_iffalse;
     -- Outputs
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_return_output := layer1_node0_MUX_bit_math_h_l112_c3_cb34_return_output;

     -- layer1_node2_MUX[bit_math_h_l134_c3_ea80] LATENCY=0
     -- Inputs
     layer1_node2_MUX_bit_math_h_l134_c3_ea80_cond <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_cond;
     layer1_node2_MUX_bit_math_h_l134_c3_ea80_iftrue <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_iftrue;
     layer1_node2_MUX_bit_math_h_l134_c3_ea80_iffalse <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_iffalse;
     -- Outputs
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_return_output := layer1_node2_MUX_bit_math_h_l134_c3_ea80_return_output;

     -- Submodule level 3
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_iffalse := VAR_layer1_node0_MUX_bit_math_h_l112_c3_cb34_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_iftrue := VAR_layer1_node1_MUX_bit_math_h_l123_c3_7968_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_iffalse := VAR_layer1_node2_MUX_bit_math_h_l134_c3_ea80_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_iftrue := VAR_layer1_node3_MUX_bit_math_h_l145_c3_735e_return_output;
     -- layer2_node0_MUX[bit_math_h_l162_c3_a284] LATENCY=0
     -- Inputs
     layer2_node0_MUX_bit_math_h_l162_c3_a284_cond <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_cond;
     layer2_node0_MUX_bit_math_h_l162_c3_a284_iftrue <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_iftrue;
     layer2_node0_MUX_bit_math_h_l162_c3_a284_iffalse <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_iffalse;
     -- Outputs
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_return_output := layer2_node0_MUX_bit_math_h_l162_c3_a284_return_output;

     -- layer2_node1_MUX[bit_math_h_l173_c3_d086] LATENCY=0
     -- Inputs
     layer2_node1_MUX_bit_math_h_l173_c3_d086_cond <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_cond;
     layer2_node1_MUX_bit_math_h_l173_c3_d086_iftrue <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_iftrue;
     layer2_node1_MUX_bit_math_h_l173_c3_d086_iffalse <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_iffalse;
     -- Outputs
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_return_output := layer2_node1_MUX_bit_math_h_l173_c3_d086_return_output;

     -- Submodule level 4
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iffalse := VAR_layer2_node0_MUX_bit_math_h_l162_c3_a284_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iftrue := VAR_layer2_node1_MUX_bit_math_h_l173_c3_d086_return_output;
     -- layer3_node0_MUX[bit_math_h_l190_c3_c2c5] LATENCY=0
     -- Inputs
     layer3_node0_MUX_bit_math_h_l190_c3_c2c5_cond <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_cond;
     layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iftrue <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iftrue;
     layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iffalse <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_iffalse;
     -- Outputs
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_return_output := layer3_node0_MUX_bit_math_h_l190_c3_c2c5_return_output;

     -- Submodule level 5
     VAR_return_output := VAR_layer3_node0_MUX_bit_math_h_l190_c3_c2c5_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
