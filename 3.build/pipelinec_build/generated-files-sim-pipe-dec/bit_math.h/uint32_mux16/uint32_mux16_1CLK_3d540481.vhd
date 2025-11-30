-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.17525288563831437]
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
entity uint32_mux16_1CLK_3d540481 is
port(
 clk : in std_logic;
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
end uint32_mux16_1CLK_3d540481;
architecture arch of uint32_mux16_1CLK_3d540481 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 1;
-- All of the wires/regs in function
-- Stage 0
signal REG_STAGE0_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond : unsigned(0 downto 0);
signal REG_STAGE0_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond : unsigned(0 downto 0);
signal REG_STAGE0_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond : unsigned(0 downto 0);
signal REG_STAGE0_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond : unsigned(0 downto 0);
signal REG_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond : unsigned(0 downto 0);
signal REG_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond : unsigned(0 downto 0);
signal REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond : unsigned(0 downto 0);
-- Each function instance gets signals
-- layer0_node0_MUX[bit_math_h_l18_c3_0e65]
signal layer0_node0_MUX_bit_math_h_l18_c3_0e65_cond : unsigned(0 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_0e65_iftrue : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_0e65_iffalse : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_0e65_return_output : unsigned(31 downto 0);

-- layer0_node1_MUX[bit_math_h_l29_c3_32c3]
signal layer0_node1_MUX_bit_math_h_l29_c3_32c3_cond : unsigned(0 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_32c3_iftrue : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_32c3_iffalse : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_32c3_return_output : unsigned(31 downto 0);

-- layer0_node2_MUX[bit_math_h_l40_c3_d7ba]
signal layer0_node2_MUX_bit_math_h_l40_c3_d7ba_cond : unsigned(0 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iftrue : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iffalse : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_d7ba_return_output : unsigned(31 downto 0);

-- layer0_node3_MUX[bit_math_h_l51_c3_b953]
signal layer0_node3_MUX_bit_math_h_l51_c3_b953_cond : unsigned(0 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_b953_iftrue : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_b953_iffalse : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_b953_return_output : unsigned(31 downto 0);

-- layer0_node4_MUX[bit_math_h_l62_c3_25ff]
signal layer0_node4_MUX_bit_math_h_l62_c3_25ff_cond : unsigned(0 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_25ff_iftrue : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_25ff_iffalse : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_25ff_return_output : unsigned(31 downto 0);

-- layer0_node5_MUX[bit_math_h_l73_c3_2de6]
signal layer0_node5_MUX_bit_math_h_l73_c3_2de6_cond : unsigned(0 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_2de6_iftrue : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_2de6_iffalse : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_2de6_return_output : unsigned(31 downto 0);

-- layer0_node6_MUX[bit_math_h_l84_c3_451d]
signal layer0_node6_MUX_bit_math_h_l84_c3_451d_cond : unsigned(0 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_451d_iftrue : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_451d_iffalse : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_451d_return_output : unsigned(31 downto 0);

-- layer0_node7_MUX[bit_math_h_l95_c3_2a5c]
signal layer0_node7_MUX_bit_math_h_l95_c3_2a5c_cond : unsigned(0 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iftrue : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iffalse : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_2a5c_return_output : unsigned(31 downto 0);

-- layer1_node0_MUX[bit_math_h_l112_c3_d6f6]
signal layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond : unsigned(0 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iftrue : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iffalse : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_d6f6_return_output : unsigned(31 downto 0);

-- layer1_node1_MUX[bit_math_h_l123_c3_0eeb]
signal layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond : unsigned(0 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iftrue : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iffalse : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_0eeb_return_output : unsigned(31 downto 0);

-- layer1_node2_MUX[bit_math_h_l134_c3_4355]
signal layer1_node2_MUX_bit_math_h_l134_c3_4355_cond : unsigned(0 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_4355_iftrue : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_4355_iffalse : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_4355_return_output : unsigned(31 downto 0);

-- layer1_node3_MUX[bit_math_h_l145_c3_2afd]
signal layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond : unsigned(0 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_2afd_iftrue : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_2afd_iffalse : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_2afd_return_output : unsigned(31 downto 0);

-- layer2_node0_MUX[bit_math_h_l162_c3_60c0]
signal layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond : unsigned(0 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_60c0_iftrue : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_60c0_iffalse : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_60c0_return_output : unsigned(31 downto 0);

-- layer2_node1_MUX[bit_math_h_l173_c3_d43c]
signal layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond : unsigned(0 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_d43c_iftrue : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_d43c_iffalse : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_d43c_return_output : unsigned(31 downto 0);

-- layer3_node0_MUX[bit_math_h_l190_c3_9d48]
signal layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond : unsigned(0 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_9d48_iftrue : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_9d48_iffalse : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_9d48_return_output : unsigned(31 downto 0);

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
-- layer0_node0_MUX_bit_math_h_l18_c3_0e65 : 1 clocks latency
layer0_node0_MUX_bit_math_h_l18_c3_0e65 : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_6d47d7d9 port map (
clk,
layer0_node0_MUX_bit_math_h_l18_c3_0e65_cond,
layer0_node0_MUX_bit_math_h_l18_c3_0e65_iftrue,
layer0_node0_MUX_bit_math_h_l18_c3_0e65_iffalse,
layer0_node0_MUX_bit_math_h_l18_c3_0e65_return_output);

-- layer0_node1_MUX_bit_math_h_l29_c3_32c3 : 1 clocks latency
layer0_node1_MUX_bit_math_h_l29_c3_32c3 : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_6d47d7d9 port map (
clk,
layer0_node1_MUX_bit_math_h_l29_c3_32c3_cond,
layer0_node1_MUX_bit_math_h_l29_c3_32c3_iftrue,
layer0_node1_MUX_bit_math_h_l29_c3_32c3_iffalse,
layer0_node1_MUX_bit_math_h_l29_c3_32c3_return_output);

-- layer0_node2_MUX_bit_math_h_l40_c3_d7ba : 1 clocks latency
layer0_node2_MUX_bit_math_h_l40_c3_d7ba : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_6d47d7d9 port map (
clk,
layer0_node2_MUX_bit_math_h_l40_c3_d7ba_cond,
layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iftrue,
layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iffalse,
layer0_node2_MUX_bit_math_h_l40_c3_d7ba_return_output);

-- layer0_node3_MUX_bit_math_h_l51_c3_b953 : 1 clocks latency
layer0_node3_MUX_bit_math_h_l51_c3_b953 : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_6d47d7d9 port map (
clk,
layer0_node3_MUX_bit_math_h_l51_c3_b953_cond,
layer0_node3_MUX_bit_math_h_l51_c3_b953_iftrue,
layer0_node3_MUX_bit_math_h_l51_c3_b953_iffalse,
layer0_node3_MUX_bit_math_h_l51_c3_b953_return_output);

-- layer0_node4_MUX_bit_math_h_l62_c3_25ff : 1 clocks latency
layer0_node4_MUX_bit_math_h_l62_c3_25ff : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_6d47d7d9 port map (
clk,
layer0_node4_MUX_bit_math_h_l62_c3_25ff_cond,
layer0_node4_MUX_bit_math_h_l62_c3_25ff_iftrue,
layer0_node4_MUX_bit_math_h_l62_c3_25ff_iffalse,
layer0_node4_MUX_bit_math_h_l62_c3_25ff_return_output);

-- layer0_node5_MUX_bit_math_h_l73_c3_2de6 : 1 clocks latency
layer0_node5_MUX_bit_math_h_l73_c3_2de6 : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_6d47d7d9 port map (
clk,
layer0_node5_MUX_bit_math_h_l73_c3_2de6_cond,
layer0_node5_MUX_bit_math_h_l73_c3_2de6_iftrue,
layer0_node5_MUX_bit_math_h_l73_c3_2de6_iffalse,
layer0_node5_MUX_bit_math_h_l73_c3_2de6_return_output);

-- layer0_node6_MUX_bit_math_h_l84_c3_451d : 1 clocks latency
layer0_node6_MUX_bit_math_h_l84_c3_451d : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_6d47d7d9 port map (
clk,
layer0_node6_MUX_bit_math_h_l84_c3_451d_cond,
layer0_node6_MUX_bit_math_h_l84_c3_451d_iftrue,
layer0_node6_MUX_bit_math_h_l84_c3_451d_iffalse,
layer0_node6_MUX_bit_math_h_l84_c3_451d_return_output);

-- layer0_node7_MUX_bit_math_h_l95_c3_2a5c : 1 clocks latency
layer0_node7_MUX_bit_math_h_l95_c3_2a5c : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_6d47d7d9 port map (
clk,
layer0_node7_MUX_bit_math_h_l95_c3_2a5c_cond,
layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iftrue,
layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iffalse,
layer0_node7_MUX_bit_math_h_l95_c3_2a5c_return_output);

-- layer1_node0_MUX_bit_math_h_l112_c3_d6f6 : 0 clocks latency
layer1_node0_MUX_bit_math_h_l112_c3_d6f6 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond,
layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iftrue,
layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iffalse,
layer1_node0_MUX_bit_math_h_l112_c3_d6f6_return_output);

-- layer1_node1_MUX_bit_math_h_l123_c3_0eeb : 0 clocks latency
layer1_node1_MUX_bit_math_h_l123_c3_0eeb : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond,
layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iftrue,
layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iffalse,
layer1_node1_MUX_bit_math_h_l123_c3_0eeb_return_output);

-- layer1_node2_MUX_bit_math_h_l134_c3_4355 : 0 clocks latency
layer1_node2_MUX_bit_math_h_l134_c3_4355 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node2_MUX_bit_math_h_l134_c3_4355_cond,
layer1_node2_MUX_bit_math_h_l134_c3_4355_iftrue,
layer1_node2_MUX_bit_math_h_l134_c3_4355_iffalse,
layer1_node2_MUX_bit_math_h_l134_c3_4355_return_output);

-- layer1_node3_MUX_bit_math_h_l145_c3_2afd : 0 clocks latency
layer1_node3_MUX_bit_math_h_l145_c3_2afd : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond,
layer1_node3_MUX_bit_math_h_l145_c3_2afd_iftrue,
layer1_node3_MUX_bit_math_h_l145_c3_2afd_iffalse,
layer1_node3_MUX_bit_math_h_l145_c3_2afd_return_output);

-- layer2_node0_MUX_bit_math_h_l162_c3_60c0 : 0 clocks latency
layer2_node0_MUX_bit_math_h_l162_c3_60c0 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond,
layer2_node0_MUX_bit_math_h_l162_c3_60c0_iftrue,
layer2_node0_MUX_bit_math_h_l162_c3_60c0_iffalse,
layer2_node0_MUX_bit_math_h_l162_c3_60c0_return_output);

-- layer2_node1_MUX_bit_math_h_l173_c3_d43c : 0 clocks latency
layer2_node1_MUX_bit_math_h_l173_c3_d43c : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond,
layer2_node1_MUX_bit_math_h_l173_c3_d43c_iftrue,
layer2_node1_MUX_bit_math_h_l173_c3_d43c_iffalse,
layer2_node1_MUX_bit_math_h_l173_c3_d43c_return_output);

-- layer3_node0_MUX_bit_math_h_l190_c3_9d48 : 0 clocks latency
layer3_node0_MUX_bit_math_h_l190_c3_9d48 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond,
layer3_node0_MUX_bit_math_h_l190_c3_9d48_iftrue,
layer3_node0_MUX_bit_math_h_l190_c3_9d48_iffalse,
layer3_node0_MUX_bit_math_h_l190_c3_9d48_return_output);



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
 -- Registers
 -- Stage 0
 REG_STAGE0_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond,
 REG_STAGE0_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond,
 REG_STAGE0_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond,
 REG_STAGE0_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond,
 REG_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond,
 REG_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond,
 REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond,
 -- All submodule outputs
 layer0_node0_MUX_bit_math_h_l18_c3_0e65_return_output,
 layer0_node1_MUX_bit_math_h_l29_c3_32c3_return_output,
 layer0_node2_MUX_bit_math_h_l40_c3_d7ba_return_output,
 layer0_node3_MUX_bit_math_h_l51_c3_b953_return_output,
 layer0_node4_MUX_bit_math_h_l62_c3_25ff_return_output,
 layer0_node5_MUX_bit_math_h_l73_c3_2de6_return_output,
 layer0_node6_MUX_bit_math_h_l84_c3_451d_return_output,
 layer0_node7_MUX_bit_math_h_l95_c3_2a5c_return_output,
 layer1_node0_MUX_bit_math_h_l112_c3_d6f6_return_output,
 layer1_node1_MUX_bit_math_h_l123_c3_0eeb_return_output,
 layer1_node2_MUX_bit_math_h_l134_c3_4355_return_output,
 layer1_node3_MUX_bit_math_h_l145_c3_2afd_return_output,
 layer2_node0_MUX_bit_math_h_l162_c3_60c0_return_output,
 layer2_node1_MUX_bit_math_h_l173_c3_d43c_return_output,
 layer3_node0_MUX_bit_math_h_l190_c3_9d48_return_output)
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
 variable VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output : unsigned(0 downto 0);
 variable VAR_layer0_node0 : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_cond : unsigned(0 downto 0);
 variable VAR_layer0_node1 : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_cond : unsigned(0 downto 0);
 variable VAR_layer0_node2 : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_cond : unsigned(0 downto 0);
 variable VAR_layer0_node3 : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_cond : unsigned(0 downto 0);
 variable VAR_layer0_node4 : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_cond : unsigned(0 downto 0);
 variable VAR_layer0_node5 : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_cond : unsigned(0 downto 0);
 variable VAR_layer0_node6 : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_cond : unsigned(0 downto 0);
 variable VAR_layer0_node7 : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_cond : unsigned(0 downto 0);
 variable VAR_sel1 : unsigned(0 downto 0);
 variable VAR_uint4_1_1_bit_math_h_l108_c10_b5a8_return_output : unsigned(0 downto 0);
 variable VAR_layer1_node0 : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond : unsigned(0 downto 0);
 variable VAR_layer1_node1 : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond : unsigned(0 downto 0);
 variable VAR_layer1_node2 : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond : unsigned(0 downto 0);
 variable VAR_layer1_node3 : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond : unsigned(0 downto 0);
 variable VAR_sel2 : unsigned(0 downto 0);
 variable VAR_uint4_2_2_bit_math_h_l158_c10_7822_return_output : unsigned(0 downto 0);
 variable VAR_layer2_node0 : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond : unsigned(0 downto 0);
 variable VAR_layer2_node1 : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond : unsigned(0 downto 0);
 variable VAR_sel3 : unsigned(0 downto 0);
 variable VAR_uint4_3_3_bit_math_h_l186_c10_0c88_return_output : unsigned(0 downto 0);
 variable VAR_layer3_node0 : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_iftrue : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_iffalse : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_return_output : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond : unsigned(0 downto 0);
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
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_iffalse := VAR_in0;
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_iftrue := VAR_in1;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_iffalse := VAR_in10;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_iftrue := VAR_in11;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_iffalse := VAR_in12;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_iftrue := VAR_in13;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iffalse := VAR_in14;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iftrue := VAR_in15;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_iffalse := VAR_in2;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_iftrue := VAR_in3;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iffalse := VAR_in4;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iftrue := VAR_in5;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_iffalse := VAR_in6;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_iftrue := VAR_in7;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_iffalse := VAR_in8;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_iftrue := VAR_in9;
     -- uint4_0_0[bit_math_h_l14_c10_fcad] LATENCY=0
     VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output := uint4_0_0(
     VAR_sel);

     -- uint4_3_3[bit_math_h_l186_c10_0c88] LATENCY=0
     VAR_uint4_3_3_bit_math_h_l186_c10_0c88_return_output := uint4_3_3(
     VAR_sel);

     -- uint4_1_1[bit_math_h_l108_c10_b5a8] LATENCY=0
     VAR_uint4_1_1_bit_math_h_l108_c10_b5a8_return_output := uint4_1_1(
     VAR_sel);

     -- uint4_2_2[bit_math_h_l158_c10_7822] LATENCY=0
     VAR_uint4_2_2_bit_math_h_l158_c10_7822_return_output := uint4_2_2(
     VAR_sel);

     -- Submodule level 1
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_cond := VAR_uint4_0_0_bit_math_h_l14_c10_fcad_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond := VAR_uint4_1_1_bit_math_h_l108_c10_b5a8_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond := VAR_uint4_1_1_bit_math_h_l108_c10_b5a8_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond := VAR_uint4_1_1_bit_math_h_l108_c10_b5a8_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond := VAR_uint4_1_1_bit_math_h_l108_c10_b5a8_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond := VAR_uint4_2_2_bit_math_h_l158_c10_7822_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond := VAR_uint4_2_2_bit_math_h_l158_c10_7822_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond := VAR_uint4_3_3_bit_math_h_l186_c10_0c88_return_output;
     -- layer0_node3_MUX[bit_math_h_l51_c3_b953] LATENCY=1
     -- Inputs
     layer0_node3_MUX_bit_math_h_l51_c3_b953_cond <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_cond;
     layer0_node3_MUX_bit_math_h_l51_c3_b953_iftrue <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_iftrue;
     layer0_node3_MUX_bit_math_h_l51_c3_b953_iffalse <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_iffalse;

     -- layer0_node4_MUX[bit_math_h_l62_c3_25ff] LATENCY=1
     -- Inputs
     layer0_node4_MUX_bit_math_h_l62_c3_25ff_cond <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_cond;
     layer0_node4_MUX_bit_math_h_l62_c3_25ff_iftrue <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_iftrue;
     layer0_node4_MUX_bit_math_h_l62_c3_25ff_iffalse <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_iffalse;

     -- layer0_node0_MUX[bit_math_h_l18_c3_0e65] LATENCY=1
     -- Inputs
     layer0_node0_MUX_bit_math_h_l18_c3_0e65_cond <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_cond;
     layer0_node0_MUX_bit_math_h_l18_c3_0e65_iftrue <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_iftrue;
     layer0_node0_MUX_bit_math_h_l18_c3_0e65_iffalse <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_iffalse;

     -- layer0_node7_MUX[bit_math_h_l95_c3_2a5c] LATENCY=1
     -- Inputs
     layer0_node7_MUX_bit_math_h_l95_c3_2a5c_cond <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_cond;
     layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iftrue <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iftrue;
     layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iffalse <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_iffalse;

     -- layer0_node5_MUX[bit_math_h_l73_c3_2de6] LATENCY=1
     -- Inputs
     layer0_node5_MUX_bit_math_h_l73_c3_2de6_cond <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_cond;
     layer0_node5_MUX_bit_math_h_l73_c3_2de6_iftrue <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_iftrue;
     layer0_node5_MUX_bit_math_h_l73_c3_2de6_iffalse <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_iffalse;

     -- layer0_node1_MUX[bit_math_h_l29_c3_32c3] LATENCY=1
     -- Inputs
     layer0_node1_MUX_bit_math_h_l29_c3_32c3_cond <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_cond;
     layer0_node1_MUX_bit_math_h_l29_c3_32c3_iftrue <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_iftrue;
     layer0_node1_MUX_bit_math_h_l29_c3_32c3_iffalse <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_iffalse;

     -- layer0_node6_MUX[bit_math_h_l84_c3_451d] LATENCY=1
     -- Inputs
     layer0_node6_MUX_bit_math_h_l84_c3_451d_cond <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_cond;
     layer0_node6_MUX_bit_math_h_l84_c3_451d_iftrue <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_iftrue;
     layer0_node6_MUX_bit_math_h_l84_c3_451d_iffalse <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_iffalse;

     -- layer0_node2_MUX[bit_math_h_l40_c3_d7ba] LATENCY=1
     -- Inputs
     layer0_node2_MUX_bit_math_h_l40_c3_d7ba_cond <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_cond;
     layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iftrue <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iftrue;
     layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iffalse <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_iffalse;

     -- Write to comb signals
     COMB_STAGE0_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond;
     COMB_STAGE0_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond;
     COMB_STAGE0_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond;
     COMB_STAGE0_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond;
     COMB_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond;
     COMB_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond;
     COMB_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond;
   elsif STAGE = 1 then
     -- Read from prev stage
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond := REG_STAGE0_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond := REG_STAGE0_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond := REG_STAGE0_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond := REG_STAGE0_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond := REG_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond := REG_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond := REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond;
     -- Submodule outputs
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_return_output := layer0_node0_MUX_bit_math_h_l18_c3_0e65_return_output;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_return_output := layer0_node1_MUX_bit_math_h_l29_c3_32c3_return_output;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_return_output := layer0_node2_MUX_bit_math_h_l40_c3_d7ba_return_output;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_return_output := layer0_node3_MUX_bit_math_h_l51_c3_b953_return_output;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_return_output := layer0_node4_MUX_bit_math_h_l62_c3_25ff_return_output;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_return_output := layer0_node5_MUX_bit_math_h_l73_c3_2de6_return_output;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_return_output := layer0_node6_MUX_bit_math_h_l84_c3_451d_return_output;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_return_output := layer0_node7_MUX_bit_math_h_l95_c3_2a5c_return_output;

     -- Submodule level 0
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iffalse := VAR_layer0_node0_MUX_bit_math_h_l18_c3_0e65_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iftrue := VAR_layer0_node1_MUX_bit_math_h_l29_c3_32c3_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iffalse := VAR_layer0_node2_MUX_bit_math_h_l40_c3_d7ba_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iftrue := VAR_layer0_node3_MUX_bit_math_h_l51_c3_b953_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_iffalse := VAR_layer0_node4_MUX_bit_math_h_l62_c3_25ff_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_iftrue := VAR_layer0_node5_MUX_bit_math_h_l73_c3_2de6_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_iffalse := VAR_layer0_node6_MUX_bit_math_h_l84_c3_451d_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_iftrue := VAR_layer0_node7_MUX_bit_math_h_l95_c3_2a5c_return_output;
     -- layer1_node1_MUX[bit_math_h_l123_c3_0eeb] LATENCY=0
     -- Inputs
     layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond;
     layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iftrue <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iftrue;
     layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iffalse <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_iffalse;
     -- Outputs
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_return_output := layer1_node1_MUX_bit_math_h_l123_c3_0eeb_return_output;

     -- layer1_node2_MUX[bit_math_h_l134_c3_4355] LATENCY=0
     -- Inputs
     layer1_node2_MUX_bit_math_h_l134_c3_4355_cond <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond;
     layer1_node2_MUX_bit_math_h_l134_c3_4355_iftrue <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_iftrue;
     layer1_node2_MUX_bit_math_h_l134_c3_4355_iffalse <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_iffalse;
     -- Outputs
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_return_output := layer1_node2_MUX_bit_math_h_l134_c3_4355_return_output;

     -- layer1_node0_MUX[bit_math_h_l112_c3_d6f6] LATENCY=0
     -- Inputs
     layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond;
     layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iftrue <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iftrue;
     layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iffalse <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_iffalse;
     -- Outputs
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_return_output := layer1_node0_MUX_bit_math_h_l112_c3_d6f6_return_output;

     -- layer1_node3_MUX[bit_math_h_l145_c3_2afd] LATENCY=0
     -- Inputs
     layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond;
     layer1_node3_MUX_bit_math_h_l145_c3_2afd_iftrue <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_iftrue;
     layer1_node3_MUX_bit_math_h_l145_c3_2afd_iffalse <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_iffalse;
     -- Outputs
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_return_output := layer1_node3_MUX_bit_math_h_l145_c3_2afd_return_output;

     -- Submodule level 1
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_iffalse := VAR_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_iftrue := VAR_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_iffalse := VAR_layer1_node2_MUX_bit_math_h_l134_c3_4355_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_iftrue := VAR_layer1_node3_MUX_bit_math_h_l145_c3_2afd_return_output;
     -- layer2_node1_MUX[bit_math_h_l173_c3_d43c] LATENCY=0
     -- Inputs
     layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond;
     layer2_node1_MUX_bit_math_h_l173_c3_d43c_iftrue <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_iftrue;
     layer2_node1_MUX_bit_math_h_l173_c3_d43c_iffalse <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_iffalse;
     -- Outputs
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_return_output := layer2_node1_MUX_bit_math_h_l173_c3_d43c_return_output;

     -- layer2_node0_MUX[bit_math_h_l162_c3_60c0] LATENCY=0
     -- Inputs
     layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond;
     layer2_node0_MUX_bit_math_h_l162_c3_60c0_iftrue <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_iftrue;
     layer2_node0_MUX_bit_math_h_l162_c3_60c0_iffalse <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_iffalse;
     -- Outputs
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_return_output := layer2_node0_MUX_bit_math_h_l162_c3_60c0_return_output;

     -- Submodule level 2
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_iffalse := VAR_layer2_node0_MUX_bit_math_h_l162_c3_60c0_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_iftrue := VAR_layer2_node1_MUX_bit_math_h_l173_c3_d43c_return_output;
     -- layer3_node0_MUX[bit_math_h_l190_c3_9d48] LATENCY=0
     -- Inputs
     layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond;
     layer3_node0_MUX_bit_math_h_l190_c3_9d48_iftrue <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_iftrue;
     layer3_node0_MUX_bit_math_h_l190_c3_9d48_iffalse <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_iffalse;
     -- Outputs
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_return_output := layer3_node0_MUX_bit_math_h_l190_c3_9d48_return_output;

     -- Submodule level 3
     VAR_return_output := VAR_layer3_node0_MUX_bit_math_h_l190_c3_9d48_return_output;
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
     REG_STAGE0_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond <= COMB_STAGE0_layer1_node0_MUX_bit_math_h_l112_c3_d6f6_cond;
     REG_STAGE0_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond <= COMB_STAGE0_layer1_node1_MUX_bit_math_h_l123_c3_0eeb_cond;
     REG_STAGE0_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond <= COMB_STAGE0_layer1_node2_MUX_bit_math_h_l134_c3_4355_cond;
     REG_STAGE0_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond <= COMB_STAGE0_layer1_node3_MUX_bit_math_h_l145_c3_2afd_cond;
     REG_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond <= COMB_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_60c0_cond;
     REG_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond <= COMB_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_d43c_cond;
     REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond <= COMB_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_9d48_cond;
 end if;
end process;

end arch;
