-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.5071687732706477]
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
entity uint32_mux16_1CLK_3b917fdd is
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
end uint32_mux16_1CLK_3b917fdd;
architecture arch of uint32_mux16_1CLK_3b917fdd is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 1;
-- All of the wires/regs in function
-- Stage 0
signal REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond : unsigned(0 downto 0);
-- Each function instance gets signals
-- layer0_node0_MUX[bit_math_h_l18_c3_df28]
signal layer0_node0_MUX_bit_math_h_l18_c3_df28_cond : unsigned(0 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_df28_iftrue : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_df28_iffalse : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_df28_return_output : unsigned(31 downto 0);

-- layer0_node1_MUX[bit_math_h_l29_c3_aaed]
signal layer0_node1_MUX_bit_math_h_l29_c3_aaed_cond : unsigned(0 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_aaed_iftrue : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_aaed_iffalse : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_aaed_return_output : unsigned(31 downto 0);

-- layer0_node2_MUX[bit_math_h_l40_c3_3c11]
signal layer0_node2_MUX_bit_math_h_l40_c3_3c11_cond : unsigned(0 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_3c11_iftrue : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_3c11_iffalse : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_3c11_return_output : unsigned(31 downto 0);

-- layer0_node3_MUX[bit_math_h_l51_c3_c1ee]
signal layer0_node3_MUX_bit_math_h_l51_c3_c1ee_cond : unsigned(0 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iftrue : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iffalse : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_c1ee_return_output : unsigned(31 downto 0);

-- layer0_node4_MUX[bit_math_h_l62_c3_bae1]
signal layer0_node4_MUX_bit_math_h_l62_c3_bae1_cond : unsigned(0 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_bae1_iftrue : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_bae1_iffalse : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_bae1_return_output : unsigned(31 downto 0);

-- layer0_node5_MUX[bit_math_h_l73_c3_1e6e]
signal layer0_node5_MUX_bit_math_h_l73_c3_1e6e_cond : unsigned(0 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iftrue : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iffalse : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_1e6e_return_output : unsigned(31 downto 0);

-- layer0_node6_MUX[bit_math_h_l84_c3_29ad]
signal layer0_node6_MUX_bit_math_h_l84_c3_29ad_cond : unsigned(0 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_29ad_iftrue : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_29ad_iffalse : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_29ad_return_output : unsigned(31 downto 0);

-- layer0_node7_MUX[bit_math_h_l95_c3_8db1]
signal layer0_node7_MUX_bit_math_h_l95_c3_8db1_cond : unsigned(0 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_8db1_iftrue : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_8db1_iffalse : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_8db1_return_output : unsigned(31 downto 0);

-- layer1_node0_MUX[bit_math_h_l112_c3_0a46]
signal layer1_node0_MUX_bit_math_h_l112_c3_0a46_cond : unsigned(0 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_0a46_iftrue : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_0a46_iffalse : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_0a46_return_output : unsigned(31 downto 0);

-- layer1_node1_MUX[bit_math_h_l123_c3_0030]
signal layer1_node1_MUX_bit_math_h_l123_c3_0030_cond : unsigned(0 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_0030_iftrue : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_0030_iffalse : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_0030_return_output : unsigned(31 downto 0);

-- layer1_node2_MUX[bit_math_h_l134_c3_e529]
signal layer1_node2_MUX_bit_math_h_l134_c3_e529_cond : unsigned(0 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_e529_iftrue : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_e529_iffalse : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_e529_return_output : unsigned(31 downto 0);

-- layer1_node3_MUX[bit_math_h_l145_c3_6321]
signal layer1_node3_MUX_bit_math_h_l145_c3_6321_cond : unsigned(0 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_6321_iftrue : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_6321_iffalse : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_6321_return_output : unsigned(31 downto 0);

-- layer2_node0_MUX[bit_math_h_l162_c3_7135]
signal layer2_node0_MUX_bit_math_h_l162_c3_7135_cond : unsigned(0 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_7135_iftrue : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_7135_iffalse : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_7135_return_output : unsigned(31 downto 0);

-- layer2_node1_MUX[bit_math_h_l173_c3_152d]
signal layer2_node1_MUX_bit_math_h_l173_c3_152d_cond : unsigned(0 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_152d_iftrue : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_152d_iffalse : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_152d_return_output : unsigned(31 downto 0);

-- layer3_node0_MUX[bit_math_h_l190_c3_38c8]
signal layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond : unsigned(0 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_38c8_iftrue : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_38c8_iffalse : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_38c8_return_output : unsigned(31 downto 0);

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
-- layer0_node0_MUX_bit_math_h_l18_c3_df28 : 0 clocks latency
layer0_node0_MUX_bit_math_h_l18_c3_df28 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node0_MUX_bit_math_h_l18_c3_df28_cond,
layer0_node0_MUX_bit_math_h_l18_c3_df28_iftrue,
layer0_node0_MUX_bit_math_h_l18_c3_df28_iffalse,
layer0_node0_MUX_bit_math_h_l18_c3_df28_return_output);

-- layer0_node1_MUX_bit_math_h_l29_c3_aaed : 0 clocks latency
layer0_node1_MUX_bit_math_h_l29_c3_aaed : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node1_MUX_bit_math_h_l29_c3_aaed_cond,
layer0_node1_MUX_bit_math_h_l29_c3_aaed_iftrue,
layer0_node1_MUX_bit_math_h_l29_c3_aaed_iffalse,
layer0_node1_MUX_bit_math_h_l29_c3_aaed_return_output);

-- layer0_node2_MUX_bit_math_h_l40_c3_3c11 : 0 clocks latency
layer0_node2_MUX_bit_math_h_l40_c3_3c11 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node2_MUX_bit_math_h_l40_c3_3c11_cond,
layer0_node2_MUX_bit_math_h_l40_c3_3c11_iftrue,
layer0_node2_MUX_bit_math_h_l40_c3_3c11_iffalse,
layer0_node2_MUX_bit_math_h_l40_c3_3c11_return_output);

-- layer0_node3_MUX_bit_math_h_l51_c3_c1ee : 0 clocks latency
layer0_node3_MUX_bit_math_h_l51_c3_c1ee : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node3_MUX_bit_math_h_l51_c3_c1ee_cond,
layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iftrue,
layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iffalse,
layer0_node3_MUX_bit_math_h_l51_c3_c1ee_return_output);

-- layer0_node4_MUX_bit_math_h_l62_c3_bae1 : 0 clocks latency
layer0_node4_MUX_bit_math_h_l62_c3_bae1 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node4_MUX_bit_math_h_l62_c3_bae1_cond,
layer0_node4_MUX_bit_math_h_l62_c3_bae1_iftrue,
layer0_node4_MUX_bit_math_h_l62_c3_bae1_iffalse,
layer0_node4_MUX_bit_math_h_l62_c3_bae1_return_output);

-- layer0_node5_MUX_bit_math_h_l73_c3_1e6e : 0 clocks latency
layer0_node5_MUX_bit_math_h_l73_c3_1e6e : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node5_MUX_bit_math_h_l73_c3_1e6e_cond,
layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iftrue,
layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iffalse,
layer0_node5_MUX_bit_math_h_l73_c3_1e6e_return_output);

-- layer0_node6_MUX_bit_math_h_l84_c3_29ad : 0 clocks latency
layer0_node6_MUX_bit_math_h_l84_c3_29ad : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node6_MUX_bit_math_h_l84_c3_29ad_cond,
layer0_node6_MUX_bit_math_h_l84_c3_29ad_iftrue,
layer0_node6_MUX_bit_math_h_l84_c3_29ad_iffalse,
layer0_node6_MUX_bit_math_h_l84_c3_29ad_return_output);

-- layer0_node7_MUX_bit_math_h_l95_c3_8db1 : 0 clocks latency
layer0_node7_MUX_bit_math_h_l95_c3_8db1 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node7_MUX_bit_math_h_l95_c3_8db1_cond,
layer0_node7_MUX_bit_math_h_l95_c3_8db1_iftrue,
layer0_node7_MUX_bit_math_h_l95_c3_8db1_iffalse,
layer0_node7_MUX_bit_math_h_l95_c3_8db1_return_output);

-- layer1_node0_MUX_bit_math_h_l112_c3_0a46 : 0 clocks latency
layer1_node0_MUX_bit_math_h_l112_c3_0a46 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node0_MUX_bit_math_h_l112_c3_0a46_cond,
layer1_node0_MUX_bit_math_h_l112_c3_0a46_iftrue,
layer1_node0_MUX_bit_math_h_l112_c3_0a46_iffalse,
layer1_node0_MUX_bit_math_h_l112_c3_0a46_return_output);

-- layer1_node1_MUX_bit_math_h_l123_c3_0030 : 0 clocks latency
layer1_node1_MUX_bit_math_h_l123_c3_0030 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node1_MUX_bit_math_h_l123_c3_0030_cond,
layer1_node1_MUX_bit_math_h_l123_c3_0030_iftrue,
layer1_node1_MUX_bit_math_h_l123_c3_0030_iffalse,
layer1_node1_MUX_bit_math_h_l123_c3_0030_return_output);

-- layer1_node2_MUX_bit_math_h_l134_c3_e529 : 0 clocks latency
layer1_node2_MUX_bit_math_h_l134_c3_e529 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node2_MUX_bit_math_h_l134_c3_e529_cond,
layer1_node2_MUX_bit_math_h_l134_c3_e529_iftrue,
layer1_node2_MUX_bit_math_h_l134_c3_e529_iffalse,
layer1_node2_MUX_bit_math_h_l134_c3_e529_return_output);

-- layer1_node3_MUX_bit_math_h_l145_c3_6321 : 0 clocks latency
layer1_node3_MUX_bit_math_h_l145_c3_6321 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node3_MUX_bit_math_h_l145_c3_6321_cond,
layer1_node3_MUX_bit_math_h_l145_c3_6321_iftrue,
layer1_node3_MUX_bit_math_h_l145_c3_6321_iffalse,
layer1_node3_MUX_bit_math_h_l145_c3_6321_return_output);

-- layer2_node0_MUX_bit_math_h_l162_c3_7135 : 1 clocks latency
layer2_node0_MUX_bit_math_h_l162_c3_7135 : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_16321e9e port map (
clk,
layer2_node0_MUX_bit_math_h_l162_c3_7135_cond,
layer2_node0_MUX_bit_math_h_l162_c3_7135_iftrue,
layer2_node0_MUX_bit_math_h_l162_c3_7135_iffalse,
layer2_node0_MUX_bit_math_h_l162_c3_7135_return_output);

-- layer2_node1_MUX_bit_math_h_l173_c3_152d : 1 clocks latency
layer2_node1_MUX_bit_math_h_l173_c3_152d : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_16321e9e port map (
clk,
layer2_node1_MUX_bit_math_h_l173_c3_152d_cond,
layer2_node1_MUX_bit_math_h_l173_c3_152d_iftrue,
layer2_node1_MUX_bit_math_h_l173_c3_152d_iffalse,
layer2_node1_MUX_bit_math_h_l173_c3_152d_return_output);

-- layer3_node0_MUX_bit_math_h_l190_c3_38c8 : 0 clocks latency
layer3_node0_MUX_bit_math_h_l190_c3_38c8 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond,
layer3_node0_MUX_bit_math_h_l190_c3_38c8_iftrue,
layer3_node0_MUX_bit_math_h_l190_c3_38c8_iffalse,
layer3_node0_MUX_bit_math_h_l190_c3_38c8_return_output);



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
 REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond,
 -- All submodule outputs
 layer0_node0_MUX_bit_math_h_l18_c3_df28_return_output,
 layer0_node1_MUX_bit_math_h_l29_c3_aaed_return_output,
 layer0_node2_MUX_bit_math_h_l40_c3_3c11_return_output,
 layer0_node3_MUX_bit_math_h_l51_c3_c1ee_return_output,
 layer0_node4_MUX_bit_math_h_l62_c3_bae1_return_output,
 layer0_node5_MUX_bit_math_h_l73_c3_1e6e_return_output,
 layer0_node6_MUX_bit_math_h_l84_c3_29ad_return_output,
 layer0_node7_MUX_bit_math_h_l95_c3_8db1_return_output,
 layer1_node0_MUX_bit_math_h_l112_c3_0a46_return_output,
 layer1_node1_MUX_bit_math_h_l123_c3_0030_return_output,
 layer1_node2_MUX_bit_math_h_l134_c3_e529_return_output,
 layer1_node3_MUX_bit_math_h_l145_c3_6321_return_output,
 layer2_node0_MUX_bit_math_h_l162_c3_7135_return_output,
 layer2_node1_MUX_bit_math_h_l173_c3_152d_return_output,
 layer3_node0_MUX_bit_math_h_l190_c3_38c8_return_output)
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
 variable VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output : unsigned(0 downto 0);
 variable VAR_layer0_node0 : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_cond : unsigned(0 downto 0);
 variable VAR_layer0_node1 : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_cond : unsigned(0 downto 0);
 variable VAR_layer0_node2 : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_cond : unsigned(0 downto 0);
 variable VAR_layer0_node3 : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_cond : unsigned(0 downto 0);
 variable VAR_layer0_node4 : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_cond : unsigned(0 downto 0);
 variable VAR_layer0_node5 : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_cond : unsigned(0 downto 0);
 variable VAR_layer0_node6 : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_cond : unsigned(0 downto 0);
 variable VAR_layer0_node7 : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_cond : unsigned(0 downto 0);
 variable VAR_sel1 : unsigned(0 downto 0);
 variable VAR_uint4_1_1_bit_math_h_l108_c10_3742_return_output : unsigned(0 downto 0);
 variable VAR_layer1_node0 : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_cond : unsigned(0 downto 0);
 variable VAR_layer1_node1 : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_cond : unsigned(0 downto 0);
 variable VAR_layer1_node2 : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_cond : unsigned(0 downto 0);
 variable VAR_layer1_node3 : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_cond : unsigned(0 downto 0);
 variable VAR_sel2 : unsigned(0 downto 0);
 variable VAR_uint4_2_2_bit_math_h_l158_c10_eb25_return_output : unsigned(0 downto 0);
 variable VAR_layer2_node0 : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_cond : unsigned(0 downto 0);
 variable VAR_layer2_node1 : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_cond : unsigned(0 downto 0);
 variable VAR_sel3 : unsigned(0 downto 0);
 variable VAR_uint4_3_3_bit_math_h_l186_c10_4b27_return_output : unsigned(0 downto 0);
 variable VAR_layer3_node0 : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_iftrue : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_iffalse : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_return_output : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond : unsigned(0 downto 0);
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
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_iffalse := VAR_in0;
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_iftrue := VAR_in1;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iffalse := VAR_in10;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iftrue := VAR_in11;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_iffalse := VAR_in12;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_iftrue := VAR_in13;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_iffalse := VAR_in14;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_iftrue := VAR_in15;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_iffalse := VAR_in2;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_iftrue := VAR_in3;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_iffalse := VAR_in4;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_iftrue := VAR_in5;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iffalse := VAR_in6;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iftrue := VAR_in7;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_iffalse := VAR_in8;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_iftrue := VAR_in9;
     -- uint4_2_2[bit_math_h_l158_c10_eb25] LATENCY=0
     VAR_uint4_2_2_bit_math_h_l158_c10_eb25_return_output := uint4_2_2(
     VAR_sel);

     -- uint4_3_3[bit_math_h_l186_c10_4b27] LATENCY=0
     VAR_uint4_3_3_bit_math_h_l186_c10_4b27_return_output := uint4_3_3(
     VAR_sel);

     -- uint4_0_0[bit_math_h_l14_c10_d3fe] LATENCY=0
     VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output := uint4_0_0(
     VAR_sel);

     -- uint4_1_1[bit_math_h_l108_c10_3742] LATENCY=0
     VAR_uint4_1_1_bit_math_h_l108_c10_3742_return_output := uint4_1_1(
     VAR_sel);

     -- Submodule level 1
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_cond := VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_cond := VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_cond := VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_cond := VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_cond := VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_cond := VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_cond := VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_cond := VAR_uint4_0_0_bit_math_h_l14_c10_d3fe_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_cond := VAR_uint4_1_1_bit_math_h_l108_c10_3742_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_cond := VAR_uint4_1_1_bit_math_h_l108_c10_3742_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_cond := VAR_uint4_1_1_bit_math_h_l108_c10_3742_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_cond := VAR_uint4_1_1_bit_math_h_l108_c10_3742_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_cond := VAR_uint4_2_2_bit_math_h_l158_c10_eb25_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_cond := VAR_uint4_2_2_bit_math_h_l158_c10_eb25_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond := VAR_uint4_3_3_bit_math_h_l186_c10_4b27_return_output;
     -- layer0_node4_MUX[bit_math_h_l62_c3_bae1] LATENCY=0
     -- Inputs
     layer0_node4_MUX_bit_math_h_l62_c3_bae1_cond <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_cond;
     layer0_node4_MUX_bit_math_h_l62_c3_bae1_iftrue <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_iftrue;
     layer0_node4_MUX_bit_math_h_l62_c3_bae1_iffalse <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_iffalse;
     -- Outputs
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_return_output := layer0_node4_MUX_bit_math_h_l62_c3_bae1_return_output;

     -- layer0_node1_MUX[bit_math_h_l29_c3_aaed] LATENCY=0
     -- Inputs
     layer0_node1_MUX_bit_math_h_l29_c3_aaed_cond <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_cond;
     layer0_node1_MUX_bit_math_h_l29_c3_aaed_iftrue <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_iftrue;
     layer0_node1_MUX_bit_math_h_l29_c3_aaed_iffalse <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_iffalse;
     -- Outputs
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_return_output := layer0_node1_MUX_bit_math_h_l29_c3_aaed_return_output;

     -- layer0_node5_MUX[bit_math_h_l73_c3_1e6e] LATENCY=0
     -- Inputs
     layer0_node5_MUX_bit_math_h_l73_c3_1e6e_cond <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_cond;
     layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iftrue <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iftrue;
     layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iffalse <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_iffalse;
     -- Outputs
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_return_output := layer0_node5_MUX_bit_math_h_l73_c3_1e6e_return_output;

     -- layer0_node6_MUX[bit_math_h_l84_c3_29ad] LATENCY=0
     -- Inputs
     layer0_node6_MUX_bit_math_h_l84_c3_29ad_cond <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_cond;
     layer0_node6_MUX_bit_math_h_l84_c3_29ad_iftrue <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_iftrue;
     layer0_node6_MUX_bit_math_h_l84_c3_29ad_iffalse <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_iffalse;
     -- Outputs
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_return_output := layer0_node6_MUX_bit_math_h_l84_c3_29ad_return_output;

     -- layer0_node0_MUX[bit_math_h_l18_c3_df28] LATENCY=0
     -- Inputs
     layer0_node0_MUX_bit_math_h_l18_c3_df28_cond <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_cond;
     layer0_node0_MUX_bit_math_h_l18_c3_df28_iftrue <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_iftrue;
     layer0_node0_MUX_bit_math_h_l18_c3_df28_iffalse <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_iffalse;
     -- Outputs
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_return_output := layer0_node0_MUX_bit_math_h_l18_c3_df28_return_output;

     -- layer0_node7_MUX[bit_math_h_l95_c3_8db1] LATENCY=0
     -- Inputs
     layer0_node7_MUX_bit_math_h_l95_c3_8db1_cond <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_cond;
     layer0_node7_MUX_bit_math_h_l95_c3_8db1_iftrue <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_iftrue;
     layer0_node7_MUX_bit_math_h_l95_c3_8db1_iffalse <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_iffalse;
     -- Outputs
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_return_output := layer0_node7_MUX_bit_math_h_l95_c3_8db1_return_output;

     -- layer0_node2_MUX[bit_math_h_l40_c3_3c11] LATENCY=0
     -- Inputs
     layer0_node2_MUX_bit_math_h_l40_c3_3c11_cond <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_cond;
     layer0_node2_MUX_bit_math_h_l40_c3_3c11_iftrue <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_iftrue;
     layer0_node2_MUX_bit_math_h_l40_c3_3c11_iffalse <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_iffalse;
     -- Outputs
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_return_output := layer0_node2_MUX_bit_math_h_l40_c3_3c11_return_output;

     -- layer0_node3_MUX[bit_math_h_l51_c3_c1ee] LATENCY=0
     -- Inputs
     layer0_node3_MUX_bit_math_h_l51_c3_c1ee_cond <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_cond;
     layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iftrue <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iftrue;
     layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iffalse <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_iffalse;
     -- Outputs
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_return_output := layer0_node3_MUX_bit_math_h_l51_c3_c1ee_return_output;

     -- Submodule level 2
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_iffalse := VAR_layer0_node0_MUX_bit_math_h_l18_c3_df28_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_iftrue := VAR_layer0_node1_MUX_bit_math_h_l29_c3_aaed_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_iffalse := VAR_layer0_node2_MUX_bit_math_h_l40_c3_3c11_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_iftrue := VAR_layer0_node3_MUX_bit_math_h_l51_c3_c1ee_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_iffalse := VAR_layer0_node4_MUX_bit_math_h_l62_c3_bae1_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_iftrue := VAR_layer0_node5_MUX_bit_math_h_l73_c3_1e6e_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_iffalse := VAR_layer0_node6_MUX_bit_math_h_l84_c3_29ad_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_iftrue := VAR_layer0_node7_MUX_bit_math_h_l95_c3_8db1_return_output;
     -- layer1_node2_MUX[bit_math_h_l134_c3_e529] LATENCY=0
     -- Inputs
     layer1_node2_MUX_bit_math_h_l134_c3_e529_cond <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_cond;
     layer1_node2_MUX_bit_math_h_l134_c3_e529_iftrue <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_iftrue;
     layer1_node2_MUX_bit_math_h_l134_c3_e529_iffalse <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_iffalse;
     -- Outputs
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_return_output := layer1_node2_MUX_bit_math_h_l134_c3_e529_return_output;

     -- layer1_node3_MUX[bit_math_h_l145_c3_6321] LATENCY=0
     -- Inputs
     layer1_node3_MUX_bit_math_h_l145_c3_6321_cond <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_cond;
     layer1_node3_MUX_bit_math_h_l145_c3_6321_iftrue <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_iftrue;
     layer1_node3_MUX_bit_math_h_l145_c3_6321_iffalse <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_iffalse;
     -- Outputs
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_return_output := layer1_node3_MUX_bit_math_h_l145_c3_6321_return_output;

     -- layer1_node0_MUX[bit_math_h_l112_c3_0a46] LATENCY=0
     -- Inputs
     layer1_node0_MUX_bit_math_h_l112_c3_0a46_cond <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_cond;
     layer1_node0_MUX_bit_math_h_l112_c3_0a46_iftrue <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_iftrue;
     layer1_node0_MUX_bit_math_h_l112_c3_0a46_iffalse <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_iffalse;
     -- Outputs
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_return_output := layer1_node0_MUX_bit_math_h_l112_c3_0a46_return_output;

     -- layer1_node1_MUX[bit_math_h_l123_c3_0030] LATENCY=0
     -- Inputs
     layer1_node1_MUX_bit_math_h_l123_c3_0030_cond <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_cond;
     layer1_node1_MUX_bit_math_h_l123_c3_0030_iftrue <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_iftrue;
     layer1_node1_MUX_bit_math_h_l123_c3_0030_iffalse <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_iffalse;
     -- Outputs
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_return_output := layer1_node1_MUX_bit_math_h_l123_c3_0030_return_output;

     -- Submodule level 3
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_iffalse := VAR_layer1_node0_MUX_bit_math_h_l112_c3_0a46_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_iftrue := VAR_layer1_node1_MUX_bit_math_h_l123_c3_0030_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_iffalse := VAR_layer1_node2_MUX_bit_math_h_l134_c3_e529_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_iftrue := VAR_layer1_node3_MUX_bit_math_h_l145_c3_6321_return_output;
     -- layer2_node0_MUX[bit_math_h_l162_c3_7135] LATENCY=1
     -- Inputs
     layer2_node0_MUX_bit_math_h_l162_c3_7135_cond <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_cond;
     layer2_node0_MUX_bit_math_h_l162_c3_7135_iftrue <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_iftrue;
     layer2_node0_MUX_bit_math_h_l162_c3_7135_iffalse <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_iffalse;

     -- layer2_node1_MUX[bit_math_h_l173_c3_152d] LATENCY=1
     -- Inputs
     layer2_node1_MUX_bit_math_h_l173_c3_152d_cond <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_cond;
     layer2_node1_MUX_bit_math_h_l173_c3_152d_iftrue <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_iftrue;
     layer2_node1_MUX_bit_math_h_l173_c3_152d_iffalse <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_iffalse;

     -- Write to comb signals
     COMB_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond;
   elsif STAGE = 1 then
     -- Read from prev stage
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond := REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond;
     -- Submodule outputs
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_return_output := layer2_node0_MUX_bit_math_h_l162_c3_7135_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_return_output := layer2_node1_MUX_bit_math_h_l173_c3_152d_return_output;

     -- Submodule level 0
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_iffalse := VAR_layer2_node0_MUX_bit_math_h_l162_c3_7135_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_iftrue := VAR_layer2_node1_MUX_bit_math_h_l173_c3_152d_return_output;
     -- layer3_node0_MUX[bit_math_h_l190_c3_38c8] LATENCY=0
     -- Inputs
     layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond;
     layer3_node0_MUX_bit_math_h_l190_c3_38c8_iftrue <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_iftrue;
     layer3_node0_MUX_bit_math_h_l190_c3_38c8_iffalse <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_iffalse;
     -- Outputs
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_return_output := layer3_node0_MUX_bit_math_h_l190_c3_38c8_return_output;

     -- Submodule level 1
     VAR_return_output := VAR_layer3_node0_MUX_bit_math_h_l190_c3_38c8_return_output;
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
     REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond <= COMB_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_38c8_cond;
 end if;
end process;

end arch;
