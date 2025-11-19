-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.3010683789313706]
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
entity uint32_mux16_1CLK_b2209071 is
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
end uint32_mux16_1CLK_b2209071;
architecture arch of uint32_mux16_1CLK_b2209071 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 1;
-- All of the wires/regs in function
-- Stage 0
signal REG_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond : unsigned(0 downto 0);
signal REG_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond : unsigned(0 downto 0);
signal REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond : unsigned(0 downto 0);
signal COMB_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond : unsigned(0 downto 0);
-- Each function instance gets signals
-- layer0_node0_MUX[bit_math_h_l18_c3_42e9]
signal layer0_node0_MUX_bit_math_h_l18_c3_42e9_cond : unsigned(0 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_42e9_iftrue : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_42e9_iffalse : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_42e9_return_output : unsigned(31 downto 0);

-- layer0_node1_MUX[bit_math_h_l29_c3_a398]
signal layer0_node1_MUX_bit_math_h_l29_c3_a398_cond : unsigned(0 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_a398_iftrue : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_a398_iffalse : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_a398_return_output : unsigned(31 downto 0);

-- layer0_node2_MUX[bit_math_h_l40_c3_2cb2]
signal layer0_node2_MUX_bit_math_h_l40_c3_2cb2_cond : unsigned(0 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iftrue : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iffalse : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_2cb2_return_output : unsigned(31 downto 0);

-- layer0_node3_MUX[bit_math_h_l51_c3_7289]
signal layer0_node3_MUX_bit_math_h_l51_c3_7289_cond : unsigned(0 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_7289_iftrue : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_7289_iffalse : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_7289_return_output : unsigned(31 downto 0);

-- layer0_node4_MUX[bit_math_h_l62_c3_2448]
signal layer0_node4_MUX_bit_math_h_l62_c3_2448_cond : unsigned(0 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_2448_iftrue : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_2448_iffalse : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_2448_return_output : unsigned(31 downto 0);

-- layer0_node5_MUX[bit_math_h_l73_c3_c562]
signal layer0_node5_MUX_bit_math_h_l73_c3_c562_cond : unsigned(0 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_c562_iftrue : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_c562_iffalse : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_c562_return_output : unsigned(31 downto 0);

-- layer0_node6_MUX[bit_math_h_l84_c3_1d30]
signal layer0_node6_MUX_bit_math_h_l84_c3_1d30_cond : unsigned(0 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_1d30_iftrue : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_1d30_iffalse : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_1d30_return_output : unsigned(31 downto 0);

-- layer0_node7_MUX[bit_math_h_l95_c3_4951]
signal layer0_node7_MUX_bit_math_h_l95_c3_4951_cond : unsigned(0 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_4951_iftrue : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_4951_iffalse : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_4951_return_output : unsigned(31 downto 0);

-- layer1_node0_MUX[bit_math_h_l112_c3_e6e2]
signal layer1_node0_MUX_bit_math_h_l112_c3_e6e2_cond : unsigned(0 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iftrue : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iffalse : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_e6e2_return_output : unsigned(31 downto 0);

-- layer1_node1_MUX[bit_math_h_l123_c3_b66c]
signal layer1_node1_MUX_bit_math_h_l123_c3_b66c_cond : unsigned(0 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_b66c_iftrue : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_b66c_iffalse : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_b66c_return_output : unsigned(31 downto 0);

-- layer1_node2_MUX[bit_math_h_l134_c3_0d62]
signal layer1_node2_MUX_bit_math_h_l134_c3_0d62_cond : unsigned(0 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_0d62_iftrue : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_0d62_iffalse : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_0d62_return_output : unsigned(31 downto 0);

-- layer1_node3_MUX[bit_math_h_l145_c3_b195]
signal layer1_node3_MUX_bit_math_h_l145_c3_b195_cond : unsigned(0 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_b195_iftrue : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_b195_iffalse : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_b195_return_output : unsigned(31 downto 0);

-- layer2_node0_MUX[bit_math_h_l162_c3_2549]
signal layer2_node0_MUX_bit_math_h_l162_c3_2549_cond : unsigned(0 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_2549_iftrue : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_2549_iffalse : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_2549_return_output : unsigned(31 downto 0);

-- layer2_node1_MUX[bit_math_h_l173_c3_ebd5]
signal layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond : unsigned(0 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iftrue : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iffalse : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_ebd5_return_output : unsigned(31 downto 0);

-- layer3_node0_MUX[bit_math_h_l190_c3_f1b6]
signal layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond : unsigned(0 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iftrue : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iffalse : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_f1b6_return_output : unsigned(31 downto 0);

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
-- layer0_node0_MUX_bit_math_h_l18_c3_42e9 : 0 clocks latency
layer0_node0_MUX_bit_math_h_l18_c3_42e9 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node0_MUX_bit_math_h_l18_c3_42e9_cond,
layer0_node0_MUX_bit_math_h_l18_c3_42e9_iftrue,
layer0_node0_MUX_bit_math_h_l18_c3_42e9_iffalse,
layer0_node0_MUX_bit_math_h_l18_c3_42e9_return_output);

-- layer0_node1_MUX_bit_math_h_l29_c3_a398 : 0 clocks latency
layer0_node1_MUX_bit_math_h_l29_c3_a398 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node1_MUX_bit_math_h_l29_c3_a398_cond,
layer0_node1_MUX_bit_math_h_l29_c3_a398_iftrue,
layer0_node1_MUX_bit_math_h_l29_c3_a398_iffalse,
layer0_node1_MUX_bit_math_h_l29_c3_a398_return_output);

-- layer0_node2_MUX_bit_math_h_l40_c3_2cb2 : 0 clocks latency
layer0_node2_MUX_bit_math_h_l40_c3_2cb2 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node2_MUX_bit_math_h_l40_c3_2cb2_cond,
layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iftrue,
layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iffalse,
layer0_node2_MUX_bit_math_h_l40_c3_2cb2_return_output);

-- layer0_node3_MUX_bit_math_h_l51_c3_7289 : 0 clocks latency
layer0_node3_MUX_bit_math_h_l51_c3_7289 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node3_MUX_bit_math_h_l51_c3_7289_cond,
layer0_node3_MUX_bit_math_h_l51_c3_7289_iftrue,
layer0_node3_MUX_bit_math_h_l51_c3_7289_iffalse,
layer0_node3_MUX_bit_math_h_l51_c3_7289_return_output);

-- layer0_node4_MUX_bit_math_h_l62_c3_2448 : 0 clocks latency
layer0_node4_MUX_bit_math_h_l62_c3_2448 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node4_MUX_bit_math_h_l62_c3_2448_cond,
layer0_node4_MUX_bit_math_h_l62_c3_2448_iftrue,
layer0_node4_MUX_bit_math_h_l62_c3_2448_iffalse,
layer0_node4_MUX_bit_math_h_l62_c3_2448_return_output);

-- layer0_node5_MUX_bit_math_h_l73_c3_c562 : 0 clocks latency
layer0_node5_MUX_bit_math_h_l73_c3_c562 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node5_MUX_bit_math_h_l73_c3_c562_cond,
layer0_node5_MUX_bit_math_h_l73_c3_c562_iftrue,
layer0_node5_MUX_bit_math_h_l73_c3_c562_iffalse,
layer0_node5_MUX_bit_math_h_l73_c3_c562_return_output);

-- layer0_node6_MUX_bit_math_h_l84_c3_1d30 : 0 clocks latency
layer0_node6_MUX_bit_math_h_l84_c3_1d30 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node6_MUX_bit_math_h_l84_c3_1d30_cond,
layer0_node6_MUX_bit_math_h_l84_c3_1d30_iftrue,
layer0_node6_MUX_bit_math_h_l84_c3_1d30_iffalse,
layer0_node6_MUX_bit_math_h_l84_c3_1d30_return_output);

-- layer0_node7_MUX_bit_math_h_l95_c3_4951 : 0 clocks latency
layer0_node7_MUX_bit_math_h_l95_c3_4951 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node7_MUX_bit_math_h_l95_c3_4951_cond,
layer0_node7_MUX_bit_math_h_l95_c3_4951_iftrue,
layer0_node7_MUX_bit_math_h_l95_c3_4951_iffalse,
layer0_node7_MUX_bit_math_h_l95_c3_4951_return_output);

-- layer1_node0_MUX_bit_math_h_l112_c3_e6e2 : 1 clocks latency
layer1_node0_MUX_bit_math_h_l112_c3_e6e2 : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_fc93fac4 port map (
clk,
layer1_node0_MUX_bit_math_h_l112_c3_e6e2_cond,
layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iftrue,
layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iffalse,
layer1_node0_MUX_bit_math_h_l112_c3_e6e2_return_output);

-- layer1_node1_MUX_bit_math_h_l123_c3_b66c : 1 clocks latency
layer1_node1_MUX_bit_math_h_l123_c3_b66c : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_fc93fac4 port map (
clk,
layer1_node1_MUX_bit_math_h_l123_c3_b66c_cond,
layer1_node1_MUX_bit_math_h_l123_c3_b66c_iftrue,
layer1_node1_MUX_bit_math_h_l123_c3_b66c_iffalse,
layer1_node1_MUX_bit_math_h_l123_c3_b66c_return_output);

-- layer1_node2_MUX_bit_math_h_l134_c3_0d62 : 1 clocks latency
layer1_node2_MUX_bit_math_h_l134_c3_0d62 : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_fc93fac4 port map (
clk,
layer1_node2_MUX_bit_math_h_l134_c3_0d62_cond,
layer1_node2_MUX_bit_math_h_l134_c3_0d62_iftrue,
layer1_node2_MUX_bit_math_h_l134_c3_0d62_iffalse,
layer1_node2_MUX_bit_math_h_l134_c3_0d62_return_output);

-- layer1_node3_MUX_bit_math_h_l145_c3_b195 : 1 clocks latency
layer1_node3_MUX_bit_math_h_l145_c3_b195 : entity work.MUX_uint1_t_uint32_t_uint32_t_1CLK_fc93fac4 port map (
clk,
layer1_node3_MUX_bit_math_h_l145_c3_b195_cond,
layer1_node3_MUX_bit_math_h_l145_c3_b195_iftrue,
layer1_node3_MUX_bit_math_h_l145_c3_b195_iffalse,
layer1_node3_MUX_bit_math_h_l145_c3_b195_return_output);

-- layer2_node0_MUX_bit_math_h_l162_c3_2549 : 0 clocks latency
layer2_node0_MUX_bit_math_h_l162_c3_2549 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node0_MUX_bit_math_h_l162_c3_2549_cond,
layer2_node0_MUX_bit_math_h_l162_c3_2549_iftrue,
layer2_node0_MUX_bit_math_h_l162_c3_2549_iffalse,
layer2_node0_MUX_bit_math_h_l162_c3_2549_return_output);

-- layer2_node1_MUX_bit_math_h_l173_c3_ebd5 : 0 clocks latency
layer2_node1_MUX_bit_math_h_l173_c3_ebd5 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond,
layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iftrue,
layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iffalse,
layer2_node1_MUX_bit_math_h_l173_c3_ebd5_return_output);

-- layer3_node0_MUX_bit_math_h_l190_c3_f1b6 : 0 clocks latency
layer3_node0_MUX_bit_math_h_l190_c3_f1b6 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond,
layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iftrue,
layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iffalse,
layer3_node0_MUX_bit_math_h_l190_c3_f1b6_return_output);



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
 REG_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond,
 REG_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond,
 REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond,
 -- All submodule outputs
 layer0_node0_MUX_bit_math_h_l18_c3_42e9_return_output,
 layer0_node1_MUX_bit_math_h_l29_c3_a398_return_output,
 layer0_node2_MUX_bit_math_h_l40_c3_2cb2_return_output,
 layer0_node3_MUX_bit_math_h_l51_c3_7289_return_output,
 layer0_node4_MUX_bit_math_h_l62_c3_2448_return_output,
 layer0_node5_MUX_bit_math_h_l73_c3_c562_return_output,
 layer0_node6_MUX_bit_math_h_l84_c3_1d30_return_output,
 layer0_node7_MUX_bit_math_h_l95_c3_4951_return_output,
 layer1_node0_MUX_bit_math_h_l112_c3_e6e2_return_output,
 layer1_node1_MUX_bit_math_h_l123_c3_b66c_return_output,
 layer1_node2_MUX_bit_math_h_l134_c3_0d62_return_output,
 layer1_node3_MUX_bit_math_h_l145_c3_b195_return_output,
 layer2_node0_MUX_bit_math_h_l162_c3_2549_return_output,
 layer2_node1_MUX_bit_math_h_l173_c3_ebd5_return_output,
 layer3_node0_MUX_bit_math_h_l190_c3_f1b6_return_output)
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
 variable VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output : unsigned(0 downto 0);
 variable VAR_layer0_node0 : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_cond : unsigned(0 downto 0);
 variable VAR_layer0_node1 : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_cond : unsigned(0 downto 0);
 variable VAR_layer0_node2 : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_cond : unsigned(0 downto 0);
 variable VAR_layer0_node3 : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_cond : unsigned(0 downto 0);
 variable VAR_layer0_node4 : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_cond : unsigned(0 downto 0);
 variable VAR_layer0_node5 : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_cond : unsigned(0 downto 0);
 variable VAR_layer0_node6 : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_cond : unsigned(0 downto 0);
 variable VAR_layer0_node7 : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_cond : unsigned(0 downto 0);
 variable VAR_sel1 : unsigned(0 downto 0);
 variable VAR_uint4_1_1_bit_math_h_l108_c10_84f9_return_output : unsigned(0 downto 0);
 variable VAR_layer1_node0 : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_cond : unsigned(0 downto 0);
 variable VAR_layer1_node1 : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_cond : unsigned(0 downto 0);
 variable VAR_layer1_node2 : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_cond : unsigned(0 downto 0);
 variable VAR_layer1_node3 : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_cond : unsigned(0 downto 0);
 variable VAR_sel2 : unsigned(0 downto 0);
 variable VAR_uint4_2_2_bit_math_h_l158_c10_c331_return_output : unsigned(0 downto 0);
 variable VAR_layer2_node0 : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond : unsigned(0 downto 0);
 variable VAR_layer2_node1 : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond : unsigned(0 downto 0);
 variable VAR_sel3 : unsigned(0 downto 0);
 variable VAR_uint4_3_3_bit_math_h_l186_c10_4d35_return_output : unsigned(0 downto 0);
 variable VAR_layer3_node0 : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iftrue : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iffalse : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_return_output : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond : unsigned(0 downto 0);
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
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_iffalse := VAR_in0;
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_iftrue := VAR_in1;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_iffalse := VAR_in10;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_iftrue := VAR_in11;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_iffalse := VAR_in12;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_iftrue := VAR_in13;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_iffalse := VAR_in14;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_iftrue := VAR_in15;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_iffalse := VAR_in2;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_iftrue := VAR_in3;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iffalse := VAR_in4;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iftrue := VAR_in5;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_iffalse := VAR_in6;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_iftrue := VAR_in7;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_iffalse := VAR_in8;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_iftrue := VAR_in9;
     -- uint4_3_3[bit_math_h_l186_c10_4d35] LATENCY=0
     VAR_uint4_3_3_bit_math_h_l186_c10_4d35_return_output := uint4_3_3(
     VAR_sel);

     -- uint4_2_2[bit_math_h_l158_c10_c331] LATENCY=0
     VAR_uint4_2_2_bit_math_h_l158_c10_c331_return_output := uint4_2_2(
     VAR_sel);

     -- uint4_0_0[bit_math_h_l14_c10_0e16] LATENCY=0
     VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output := uint4_0_0(
     VAR_sel);

     -- uint4_1_1[bit_math_h_l108_c10_84f9] LATENCY=0
     VAR_uint4_1_1_bit_math_h_l108_c10_84f9_return_output := uint4_1_1(
     VAR_sel);

     -- Submodule level 1
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_cond := VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_cond := VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_cond := VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_cond := VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_cond := VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_cond := VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_cond := VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_cond := VAR_uint4_0_0_bit_math_h_l14_c10_0e16_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_cond := VAR_uint4_1_1_bit_math_h_l108_c10_84f9_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_cond := VAR_uint4_1_1_bit_math_h_l108_c10_84f9_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_cond := VAR_uint4_1_1_bit_math_h_l108_c10_84f9_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_cond := VAR_uint4_1_1_bit_math_h_l108_c10_84f9_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond := VAR_uint4_2_2_bit_math_h_l158_c10_c331_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond := VAR_uint4_2_2_bit_math_h_l158_c10_c331_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond := VAR_uint4_3_3_bit_math_h_l186_c10_4d35_return_output;
     -- layer0_node6_MUX[bit_math_h_l84_c3_1d30] LATENCY=0
     -- Inputs
     layer0_node6_MUX_bit_math_h_l84_c3_1d30_cond <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_cond;
     layer0_node6_MUX_bit_math_h_l84_c3_1d30_iftrue <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_iftrue;
     layer0_node6_MUX_bit_math_h_l84_c3_1d30_iffalse <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_iffalse;
     -- Outputs
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_return_output := layer0_node6_MUX_bit_math_h_l84_c3_1d30_return_output;

     -- layer0_node3_MUX[bit_math_h_l51_c3_7289] LATENCY=0
     -- Inputs
     layer0_node3_MUX_bit_math_h_l51_c3_7289_cond <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_cond;
     layer0_node3_MUX_bit_math_h_l51_c3_7289_iftrue <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_iftrue;
     layer0_node3_MUX_bit_math_h_l51_c3_7289_iffalse <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_iffalse;
     -- Outputs
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_return_output := layer0_node3_MUX_bit_math_h_l51_c3_7289_return_output;

     -- layer0_node4_MUX[bit_math_h_l62_c3_2448] LATENCY=0
     -- Inputs
     layer0_node4_MUX_bit_math_h_l62_c3_2448_cond <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_cond;
     layer0_node4_MUX_bit_math_h_l62_c3_2448_iftrue <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_iftrue;
     layer0_node4_MUX_bit_math_h_l62_c3_2448_iffalse <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_iffalse;
     -- Outputs
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_return_output := layer0_node4_MUX_bit_math_h_l62_c3_2448_return_output;

     -- layer0_node7_MUX[bit_math_h_l95_c3_4951] LATENCY=0
     -- Inputs
     layer0_node7_MUX_bit_math_h_l95_c3_4951_cond <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_cond;
     layer0_node7_MUX_bit_math_h_l95_c3_4951_iftrue <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_iftrue;
     layer0_node7_MUX_bit_math_h_l95_c3_4951_iffalse <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_iffalse;
     -- Outputs
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_return_output := layer0_node7_MUX_bit_math_h_l95_c3_4951_return_output;

     -- layer0_node1_MUX[bit_math_h_l29_c3_a398] LATENCY=0
     -- Inputs
     layer0_node1_MUX_bit_math_h_l29_c3_a398_cond <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_cond;
     layer0_node1_MUX_bit_math_h_l29_c3_a398_iftrue <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_iftrue;
     layer0_node1_MUX_bit_math_h_l29_c3_a398_iffalse <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_iffalse;
     -- Outputs
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_return_output := layer0_node1_MUX_bit_math_h_l29_c3_a398_return_output;

     -- layer0_node2_MUX[bit_math_h_l40_c3_2cb2] LATENCY=0
     -- Inputs
     layer0_node2_MUX_bit_math_h_l40_c3_2cb2_cond <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_cond;
     layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iftrue <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iftrue;
     layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iffalse <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_iffalse;
     -- Outputs
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_return_output := layer0_node2_MUX_bit_math_h_l40_c3_2cb2_return_output;

     -- layer0_node0_MUX[bit_math_h_l18_c3_42e9] LATENCY=0
     -- Inputs
     layer0_node0_MUX_bit_math_h_l18_c3_42e9_cond <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_cond;
     layer0_node0_MUX_bit_math_h_l18_c3_42e9_iftrue <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_iftrue;
     layer0_node0_MUX_bit_math_h_l18_c3_42e9_iffalse <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_iffalse;
     -- Outputs
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_return_output := layer0_node0_MUX_bit_math_h_l18_c3_42e9_return_output;

     -- layer0_node5_MUX[bit_math_h_l73_c3_c562] LATENCY=0
     -- Inputs
     layer0_node5_MUX_bit_math_h_l73_c3_c562_cond <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_cond;
     layer0_node5_MUX_bit_math_h_l73_c3_c562_iftrue <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_iftrue;
     layer0_node5_MUX_bit_math_h_l73_c3_c562_iffalse <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_iffalse;
     -- Outputs
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_return_output := layer0_node5_MUX_bit_math_h_l73_c3_c562_return_output;

     -- Submodule level 2
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iffalse := VAR_layer0_node0_MUX_bit_math_h_l18_c3_42e9_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iftrue := VAR_layer0_node1_MUX_bit_math_h_l29_c3_a398_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_iffalse := VAR_layer0_node2_MUX_bit_math_h_l40_c3_2cb2_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_iftrue := VAR_layer0_node3_MUX_bit_math_h_l51_c3_7289_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_iffalse := VAR_layer0_node4_MUX_bit_math_h_l62_c3_2448_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_iftrue := VAR_layer0_node5_MUX_bit_math_h_l73_c3_c562_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_iffalse := VAR_layer0_node6_MUX_bit_math_h_l84_c3_1d30_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_iftrue := VAR_layer0_node7_MUX_bit_math_h_l95_c3_4951_return_output;
     -- layer1_node0_MUX[bit_math_h_l112_c3_e6e2] LATENCY=1
     -- Inputs
     layer1_node0_MUX_bit_math_h_l112_c3_e6e2_cond <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_cond;
     layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iftrue <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iftrue;
     layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iffalse <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_iffalse;

     -- layer1_node1_MUX[bit_math_h_l123_c3_b66c] LATENCY=1
     -- Inputs
     layer1_node1_MUX_bit_math_h_l123_c3_b66c_cond <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_cond;
     layer1_node1_MUX_bit_math_h_l123_c3_b66c_iftrue <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_iftrue;
     layer1_node1_MUX_bit_math_h_l123_c3_b66c_iffalse <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_iffalse;

     -- layer1_node2_MUX[bit_math_h_l134_c3_0d62] LATENCY=1
     -- Inputs
     layer1_node2_MUX_bit_math_h_l134_c3_0d62_cond <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_cond;
     layer1_node2_MUX_bit_math_h_l134_c3_0d62_iftrue <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_iftrue;
     layer1_node2_MUX_bit_math_h_l134_c3_0d62_iffalse <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_iffalse;

     -- layer1_node3_MUX[bit_math_h_l145_c3_b195] LATENCY=1
     -- Inputs
     layer1_node3_MUX_bit_math_h_l145_c3_b195_cond <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_cond;
     layer1_node3_MUX_bit_math_h_l145_c3_b195_iftrue <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_iftrue;
     layer1_node3_MUX_bit_math_h_l145_c3_b195_iffalse <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_iffalse;

     -- Write to comb signals
     COMB_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond;
     COMB_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond;
     COMB_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond;
   elsif STAGE = 1 then
     -- Read from prev stage
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond := REG_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond := REG_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond := REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond;
     -- Submodule outputs
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_return_output := layer1_node0_MUX_bit_math_h_l112_c3_e6e2_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_return_output := layer1_node1_MUX_bit_math_h_l123_c3_b66c_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_return_output := layer1_node2_MUX_bit_math_h_l134_c3_0d62_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_return_output := layer1_node3_MUX_bit_math_h_l145_c3_b195_return_output;

     -- Submodule level 0
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_iffalse := VAR_layer1_node0_MUX_bit_math_h_l112_c3_e6e2_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_iftrue := VAR_layer1_node1_MUX_bit_math_h_l123_c3_b66c_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iffalse := VAR_layer1_node2_MUX_bit_math_h_l134_c3_0d62_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iftrue := VAR_layer1_node3_MUX_bit_math_h_l145_c3_b195_return_output;
     -- layer2_node1_MUX[bit_math_h_l173_c3_ebd5] LATENCY=0
     -- Inputs
     layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond;
     layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iftrue <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iftrue;
     layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iffalse <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_iffalse;
     -- Outputs
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_return_output := layer2_node1_MUX_bit_math_h_l173_c3_ebd5_return_output;

     -- layer2_node0_MUX[bit_math_h_l162_c3_2549] LATENCY=0
     -- Inputs
     layer2_node0_MUX_bit_math_h_l162_c3_2549_cond <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond;
     layer2_node0_MUX_bit_math_h_l162_c3_2549_iftrue <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_iftrue;
     layer2_node0_MUX_bit_math_h_l162_c3_2549_iffalse <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_iffalse;
     -- Outputs
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_return_output := layer2_node0_MUX_bit_math_h_l162_c3_2549_return_output;

     -- Submodule level 1
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iffalse := VAR_layer2_node0_MUX_bit_math_h_l162_c3_2549_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iftrue := VAR_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_return_output;
     -- layer3_node0_MUX[bit_math_h_l190_c3_f1b6] LATENCY=0
     -- Inputs
     layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond;
     layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iftrue <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iftrue;
     layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iffalse <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_iffalse;
     -- Outputs
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_return_output := layer3_node0_MUX_bit_math_h_l190_c3_f1b6_return_output;

     -- Submodule level 2
     VAR_return_output := VAR_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_return_output;
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
     REG_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond <= COMB_STAGE0_layer2_node0_MUX_bit_math_h_l162_c3_2549_cond;
     REG_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond <= COMB_STAGE0_layer2_node1_MUX_bit_math_h_l173_c3_ebd5_cond;
     REG_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond <= COMB_STAGE0_layer3_node0_MUX_bit_math_h_l190_c3_f1b6_cond;
 end if;
end process;

end arch;
