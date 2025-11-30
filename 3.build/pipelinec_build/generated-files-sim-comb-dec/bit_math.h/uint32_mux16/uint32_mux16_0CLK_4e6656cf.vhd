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
-- layer0_node0_MUX[bit_math_h_l18_c3_9b60]
signal layer0_node0_MUX_bit_math_h_l18_c3_9b60_cond : unsigned(0 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_9b60_iftrue : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_9b60_iffalse : unsigned(31 downto 0);
signal layer0_node0_MUX_bit_math_h_l18_c3_9b60_return_output : unsigned(31 downto 0);

-- layer0_node1_MUX[bit_math_h_l29_c3_676f]
signal layer0_node1_MUX_bit_math_h_l29_c3_676f_cond : unsigned(0 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_676f_iftrue : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_676f_iffalse : unsigned(31 downto 0);
signal layer0_node1_MUX_bit_math_h_l29_c3_676f_return_output : unsigned(31 downto 0);

-- layer0_node2_MUX[bit_math_h_l40_c3_fce9]
signal layer0_node2_MUX_bit_math_h_l40_c3_fce9_cond : unsigned(0 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_fce9_iftrue : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_fce9_iffalse : unsigned(31 downto 0);
signal layer0_node2_MUX_bit_math_h_l40_c3_fce9_return_output : unsigned(31 downto 0);

-- layer0_node3_MUX[bit_math_h_l51_c3_63ce]
signal layer0_node3_MUX_bit_math_h_l51_c3_63ce_cond : unsigned(0 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_63ce_iftrue : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_63ce_iffalse : unsigned(31 downto 0);
signal layer0_node3_MUX_bit_math_h_l51_c3_63ce_return_output : unsigned(31 downto 0);

-- layer0_node4_MUX[bit_math_h_l62_c3_7fd6]
signal layer0_node4_MUX_bit_math_h_l62_c3_7fd6_cond : unsigned(0 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iftrue : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iffalse : unsigned(31 downto 0);
signal layer0_node4_MUX_bit_math_h_l62_c3_7fd6_return_output : unsigned(31 downto 0);

-- layer0_node5_MUX[bit_math_h_l73_c3_7bf8]
signal layer0_node5_MUX_bit_math_h_l73_c3_7bf8_cond : unsigned(0 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iftrue : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iffalse : unsigned(31 downto 0);
signal layer0_node5_MUX_bit_math_h_l73_c3_7bf8_return_output : unsigned(31 downto 0);

-- layer0_node6_MUX[bit_math_h_l84_c3_4955]
signal layer0_node6_MUX_bit_math_h_l84_c3_4955_cond : unsigned(0 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_4955_iftrue : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_4955_iffalse : unsigned(31 downto 0);
signal layer0_node6_MUX_bit_math_h_l84_c3_4955_return_output : unsigned(31 downto 0);

-- layer0_node7_MUX[bit_math_h_l95_c3_c081]
signal layer0_node7_MUX_bit_math_h_l95_c3_c081_cond : unsigned(0 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_c081_iftrue : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_c081_iffalse : unsigned(31 downto 0);
signal layer0_node7_MUX_bit_math_h_l95_c3_c081_return_output : unsigned(31 downto 0);

-- layer1_node0_MUX[bit_math_h_l112_c3_11cb]
signal layer1_node0_MUX_bit_math_h_l112_c3_11cb_cond : unsigned(0 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_11cb_iftrue : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_11cb_iffalse : unsigned(31 downto 0);
signal layer1_node0_MUX_bit_math_h_l112_c3_11cb_return_output : unsigned(31 downto 0);

-- layer1_node1_MUX[bit_math_h_l123_c3_ed82]
signal layer1_node1_MUX_bit_math_h_l123_c3_ed82_cond : unsigned(0 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_ed82_iftrue : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_ed82_iffalse : unsigned(31 downto 0);
signal layer1_node1_MUX_bit_math_h_l123_c3_ed82_return_output : unsigned(31 downto 0);

-- layer1_node2_MUX[bit_math_h_l134_c3_7754]
signal layer1_node2_MUX_bit_math_h_l134_c3_7754_cond : unsigned(0 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_7754_iftrue : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_7754_iffalse : unsigned(31 downto 0);
signal layer1_node2_MUX_bit_math_h_l134_c3_7754_return_output : unsigned(31 downto 0);

-- layer1_node3_MUX[bit_math_h_l145_c3_98a0]
signal layer1_node3_MUX_bit_math_h_l145_c3_98a0_cond : unsigned(0 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_98a0_iftrue : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_98a0_iffalse : unsigned(31 downto 0);
signal layer1_node3_MUX_bit_math_h_l145_c3_98a0_return_output : unsigned(31 downto 0);

-- layer2_node0_MUX[bit_math_h_l162_c3_6fde]
signal layer2_node0_MUX_bit_math_h_l162_c3_6fde_cond : unsigned(0 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_6fde_iftrue : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_6fde_iffalse : unsigned(31 downto 0);
signal layer2_node0_MUX_bit_math_h_l162_c3_6fde_return_output : unsigned(31 downto 0);

-- layer2_node1_MUX[bit_math_h_l173_c3_1e3c]
signal layer2_node1_MUX_bit_math_h_l173_c3_1e3c_cond : unsigned(0 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iftrue : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iffalse : unsigned(31 downto 0);
signal layer2_node1_MUX_bit_math_h_l173_c3_1e3c_return_output : unsigned(31 downto 0);

-- layer3_node0_MUX[bit_math_h_l190_c3_5473]
signal layer3_node0_MUX_bit_math_h_l190_c3_5473_cond : unsigned(0 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_5473_iftrue : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_5473_iffalse : unsigned(31 downto 0);
signal layer3_node0_MUX_bit_math_h_l190_c3_5473_return_output : unsigned(31 downto 0);

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
-- layer0_node0_MUX_bit_math_h_l18_c3_9b60 : 0 clocks latency
layer0_node0_MUX_bit_math_h_l18_c3_9b60 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node0_MUX_bit_math_h_l18_c3_9b60_cond,
layer0_node0_MUX_bit_math_h_l18_c3_9b60_iftrue,
layer0_node0_MUX_bit_math_h_l18_c3_9b60_iffalse,
layer0_node0_MUX_bit_math_h_l18_c3_9b60_return_output);

-- layer0_node1_MUX_bit_math_h_l29_c3_676f : 0 clocks latency
layer0_node1_MUX_bit_math_h_l29_c3_676f : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node1_MUX_bit_math_h_l29_c3_676f_cond,
layer0_node1_MUX_bit_math_h_l29_c3_676f_iftrue,
layer0_node1_MUX_bit_math_h_l29_c3_676f_iffalse,
layer0_node1_MUX_bit_math_h_l29_c3_676f_return_output);

-- layer0_node2_MUX_bit_math_h_l40_c3_fce9 : 0 clocks latency
layer0_node2_MUX_bit_math_h_l40_c3_fce9 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node2_MUX_bit_math_h_l40_c3_fce9_cond,
layer0_node2_MUX_bit_math_h_l40_c3_fce9_iftrue,
layer0_node2_MUX_bit_math_h_l40_c3_fce9_iffalse,
layer0_node2_MUX_bit_math_h_l40_c3_fce9_return_output);

-- layer0_node3_MUX_bit_math_h_l51_c3_63ce : 0 clocks latency
layer0_node3_MUX_bit_math_h_l51_c3_63ce : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node3_MUX_bit_math_h_l51_c3_63ce_cond,
layer0_node3_MUX_bit_math_h_l51_c3_63ce_iftrue,
layer0_node3_MUX_bit_math_h_l51_c3_63ce_iffalse,
layer0_node3_MUX_bit_math_h_l51_c3_63ce_return_output);

-- layer0_node4_MUX_bit_math_h_l62_c3_7fd6 : 0 clocks latency
layer0_node4_MUX_bit_math_h_l62_c3_7fd6 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node4_MUX_bit_math_h_l62_c3_7fd6_cond,
layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iftrue,
layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iffalse,
layer0_node4_MUX_bit_math_h_l62_c3_7fd6_return_output);

-- layer0_node5_MUX_bit_math_h_l73_c3_7bf8 : 0 clocks latency
layer0_node5_MUX_bit_math_h_l73_c3_7bf8 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node5_MUX_bit_math_h_l73_c3_7bf8_cond,
layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iftrue,
layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iffalse,
layer0_node5_MUX_bit_math_h_l73_c3_7bf8_return_output);

-- layer0_node6_MUX_bit_math_h_l84_c3_4955 : 0 clocks latency
layer0_node6_MUX_bit_math_h_l84_c3_4955 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node6_MUX_bit_math_h_l84_c3_4955_cond,
layer0_node6_MUX_bit_math_h_l84_c3_4955_iftrue,
layer0_node6_MUX_bit_math_h_l84_c3_4955_iffalse,
layer0_node6_MUX_bit_math_h_l84_c3_4955_return_output);

-- layer0_node7_MUX_bit_math_h_l95_c3_c081 : 0 clocks latency
layer0_node7_MUX_bit_math_h_l95_c3_c081 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer0_node7_MUX_bit_math_h_l95_c3_c081_cond,
layer0_node7_MUX_bit_math_h_l95_c3_c081_iftrue,
layer0_node7_MUX_bit_math_h_l95_c3_c081_iffalse,
layer0_node7_MUX_bit_math_h_l95_c3_c081_return_output);

-- layer1_node0_MUX_bit_math_h_l112_c3_11cb : 0 clocks latency
layer1_node0_MUX_bit_math_h_l112_c3_11cb : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node0_MUX_bit_math_h_l112_c3_11cb_cond,
layer1_node0_MUX_bit_math_h_l112_c3_11cb_iftrue,
layer1_node0_MUX_bit_math_h_l112_c3_11cb_iffalse,
layer1_node0_MUX_bit_math_h_l112_c3_11cb_return_output);

-- layer1_node1_MUX_bit_math_h_l123_c3_ed82 : 0 clocks latency
layer1_node1_MUX_bit_math_h_l123_c3_ed82 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node1_MUX_bit_math_h_l123_c3_ed82_cond,
layer1_node1_MUX_bit_math_h_l123_c3_ed82_iftrue,
layer1_node1_MUX_bit_math_h_l123_c3_ed82_iffalse,
layer1_node1_MUX_bit_math_h_l123_c3_ed82_return_output);

-- layer1_node2_MUX_bit_math_h_l134_c3_7754 : 0 clocks latency
layer1_node2_MUX_bit_math_h_l134_c3_7754 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node2_MUX_bit_math_h_l134_c3_7754_cond,
layer1_node2_MUX_bit_math_h_l134_c3_7754_iftrue,
layer1_node2_MUX_bit_math_h_l134_c3_7754_iffalse,
layer1_node2_MUX_bit_math_h_l134_c3_7754_return_output);

-- layer1_node3_MUX_bit_math_h_l145_c3_98a0 : 0 clocks latency
layer1_node3_MUX_bit_math_h_l145_c3_98a0 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer1_node3_MUX_bit_math_h_l145_c3_98a0_cond,
layer1_node3_MUX_bit_math_h_l145_c3_98a0_iftrue,
layer1_node3_MUX_bit_math_h_l145_c3_98a0_iffalse,
layer1_node3_MUX_bit_math_h_l145_c3_98a0_return_output);

-- layer2_node0_MUX_bit_math_h_l162_c3_6fde : 0 clocks latency
layer2_node0_MUX_bit_math_h_l162_c3_6fde : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node0_MUX_bit_math_h_l162_c3_6fde_cond,
layer2_node0_MUX_bit_math_h_l162_c3_6fde_iftrue,
layer2_node0_MUX_bit_math_h_l162_c3_6fde_iffalse,
layer2_node0_MUX_bit_math_h_l162_c3_6fde_return_output);

-- layer2_node1_MUX_bit_math_h_l173_c3_1e3c : 0 clocks latency
layer2_node1_MUX_bit_math_h_l173_c3_1e3c : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer2_node1_MUX_bit_math_h_l173_c3_1e3c_cond,
layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iftrue,
layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iffalse,
layer2_node1_MUX_bit_math_h_l173_c3_1e3c_return_output);

-- layer3_node0_MUX_bit_math_h_l190_c3_5473 : 0 clocks latency
layer3_node0_MUX_bit_math_h_l190_c3_5473 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
layer3_node0_MUX_bit_math_h_l190_c3_5473_cond,
layer3_node0_MUX_bit_math_h_l190_c3_5473_iftrue,
layer3_node0_MUX_bit_math_h_l190_c3_5473_iffalse,
layer3_node0_MUX_bit_math_h_l190_c3_5473_return_output);



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
 layer0_node0_MUX_bit_math_h_l18_c3_9b60_return_output,
 layer0_node1_MUX_bit_math_h_l29_c3_676f_return_output,
 layer0_node2_MUX_bit_math_h_l40_c3_fce9_return_output,
 layer0_node3_MUX_bit_math_h_l51_c3_63ce_return_output,
 layer0_node4_MUX_bit_math_h_l62_c3_7fd6_return_output,
 layer0_node5_MUX_bit_math_h_l73_c3_7bf8_return_output,
 layer0_node6_MUX_bit_math_h_l84_c3_4955_return_output,
 layer0_node7_MUX_bit_math_h_l95_c3_c081_return_output,
 layer1_node0_MUX_bit_math_h_l112_c3_11cb_return_output,
 layer1_node1_MUX_bit_math_h_l123_c3_ed82_return_output,
 layer1_node2_MUX_bit_math_h_l134_c3_7754_return_output,
 layer1_node3_MUX_bit_math_h_l145_c3_98a0_return_output,
 layer2_node0_MUX_bit_math_h_l162_c3_6fde_return_output,
 layer2_node1_MUX_bit_math_h_l173_c3_1e3c_return_output,
 layer3_node0_MUX_bit_math_h_l190_c3_5473_return_output)
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
 variable VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output : unsigned(0 downto 0);
 variable VAR_layer0_node0 : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_cond : unsigned(0 downto 0);
 variable VAR_layer0_node1 : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_cond : unsigned(0 downto 0);
 variable VAR_layer0_node2 : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_cond : unsigned(0 downto 0);
 variable VAR_layer0_node3 : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_cond : unsigned(0 downto 0);
 variable VAR_layer0_node4 : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_cond : unsigned(0 downto 0);
 variable VAR_layer0_node5 : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_cond : unsigned(0 downto 0);
 variable VAR_layer0_node6 : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_cond : unsigned(0 downto 0);
 variable VAR_layer0_node7 : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_iftrue : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_iffalse : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_return_output : unsigned(31 downto 0);
 variable VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_cond : unsigned(0 downto 0);
 variable VAR_sel1 : unsigned(0 downto 0);
 variable VAR_uint4_1_1_bit_math_h_l108_c10_e7d4_return_output : unsigned(0 downto 0);
 variable VAR_layer1_node0 : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_cond : unsigned(0 downto 0);
 variable VAR_layer1_node1 : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_cond : unsigned(0 downto 0);
 variable VAR_layer1_node2 : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_cond : unsigned(0 downto 0);
 variable VAR_layer1_node3 : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_iftrue : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_iffalse : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_return_output : unsigned(31 downto 0);
 variable VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_cond : unsigned(0 downto 0);
 variable VAR_sel2 : unsigned(0 downto 0);
 variable VAR_uint4_2_2_bit_math_h_l158_c10_b7ae_return_output : unsigned(0 downto 0);
 variable VAR_layer2_node0 : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_cond : unsigned(0 downto 0);
 variable VAR_layer2_node1 : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iftrue : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iffalse : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_return_output : unsigned(31 downto 0);
 variable VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_cond : unsigned(0 downto 0);
 variable VAR_sel3 : unsigned(0 downto 0);
 variable VAR_uint4_3_3_bit_math_h_l186_c10_21d2_return_output : unsigned(0 downto 0);
 variable VAR_layer3_node0 : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_iftrue : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_iffalse : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_return_output : unsigned(31 downto 0);
 variable VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_cond : unsigned(0 downto 0);
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
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_iffalse := VAR_in0;
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_iftrue := VAR_in1;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iffalse := VAR_in10;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iftrue := VAR_in11;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_iffalse := VAR_in12;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_iftrue := VAR_in13;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_iffalse := VAR_in14;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_iftrue := VAR_in15;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_iffalse := VAR_in2;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_iftrue := VAR_in3;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_iffalse := VAR_in4;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_iftrue := VAR_in5;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_iffalse := VAR_in6;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_iftrue := VAR_in7;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iffalse := VAR_in8;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iftrue := VAR_in9;
     -- uint4_3_3[bit_math_h_l186_c10_21d2] LATENCY=0
     VAR_uint4_3_3_bit_math_h_l186_c10_21d2_return_output := uint4_3_3(
     VAR_sel);

     -- uint4_2_2[bit_math_h_l158_c10_b7ae] LATENCY=0
     VAR_uint4_2_2_bit_math_h_l158_c10_b7ae_return_output := uint4_2_2(
     VAR_sel);

     -- uint4_1_1[bit_math_h_l108_c10_e7d4] LATENCY=0
     VAR_uint4_1_1_bit_math_h_l108_c10_e7d4_return_output := uint4_1_1(
     VAR_sel);

     -- uint4_0_0[bit_math_h_l14_c10_022e] LATENCY=0
     VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output := uint4_0_0(
     VAR_sel);

     -- Submodule level 1
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_cond := VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output;
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_cond := VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output;
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_cond := VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output;
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_cond := VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output;
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_cond := VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output;
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_cond := VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output;
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_cond := VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output;
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_cond := VAR_uint4_0_0_bit_math_h_l14_c10_022e_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_cond := VAR_uint4_1_1_bit_math_h_l108_c10_e7d4_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_cond := VAR_uint4_1_1_bit_math_h_l108_c10_e7d4_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_cond := VAR_uint4_1_1_bit_math_h_l108_c10_e7d4_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_cond := VAR_uint4_1_1_bit_math_h_l108_c10_e7d4_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_cond := VAR_uint4_2_2_bit_math_h_l158_c10_b7ae_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_cond := VAR_uint4_2_2_bit_math_h_l158_c10_b7ae_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_cond := VAR_uint4_3_3_bit_math_h_l186_c10_21d2_return_output;
     -- layer0_node6_MUX[bit_math_h_l84_c3_4955] LATENCY=0
     -- Inputs
     layer0_node6_MUX_bit_math_h_l84_c3_4955_cond <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_cond;
     layer0_node6_MUX_bit_math_h_l84_c3_4955_iftrue <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_iftrue;
     layer0_node6_MUX_bit_math_h_l84_c3_4955_iffalse <= VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_iffalse;
     -- Outputs
     VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_return_output := layer0_node6_MUX_bit_math_h_l84_c3_4955_return_output;

     -- layer0_node2_MUX[bit_math_h_l40_c3_fce9] LATENCY=0
     -- Inputs
     layer0_node2_MUX_bit_math_h_l40_c3_fce9_cond <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_cond;
     layer0_node2_MUX_bit_math_h_l40_c3_fce9_iftrue <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_iftrue;
     layer0_node2_MUX_bit_math_h_l40_c3_fce9_iffalse <= VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_iffalse;
     -- Outputs
     VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_return_output := layer0_node2_MUX_bit_math_h_l40_c3_fce9_return_output;

     -- layer0_node0_MUX[bit_math_h_l18_c3_9b60] LATENCY=0
     -- Inputs
     layer0_node0_MUX_bit_math_h_l18_c3_9b60_cond <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_cond;
     layer0_node0_MUX_bit_math_h_l18_c3_9b60_iftrue <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_iftrue;
     layer0_node0_MUX_bit_math_h_l18_c3_9b60_iffalse <= VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_iffalse;
     -- Outputs
     VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_return_output := layer0_node0_MUX_bit_math_h_l18_c3_9b60_return_output;

     -- layer0_node4_MUX[bit_math_h_l62_c3_7fd6] LATENCY=0
     -- Inputs
     layer0_node4_MUX_bit_math_h_l62_c3_7fd6_cond <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_cond;
     layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iftrue <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iftrue;
     layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iffalse <= VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_iffalse;
     -- Outputs
     VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_return_output := layer0_node4_MUX_bit_math_h_l62_c3_7fd6_return_output;

     -- layer0_node3_MUX[bit_math_h_l51_c3_63ce] LATENCY=0
     -- Inputs
     layer0_node3_MUX_bit_math_h_l51_c3_63ce_cond <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_cond;
     layer0_node3_MUX_bit_math_h_l51_c3_63ce_iftrue <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_iftrue;
     layer0_node3_MUX_bit_math_h_l51_c3_63ce_iffalse <= VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_iffalse;
     -- Outputs
     VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_return_output := layer0_node3_MUX_bit_math_h_l51_c3_63ce_return_output;

     -- layer0_node7_MUX[bit_math_h_l95_c3_c081] LATENCY=0
     -- Inputs
     layer0_node7_MUX_bit_math_h_l95_c3_c081_cond <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_cond;
     layer0_node7_MUX_bit_math_h_l95_c3_c081_iftrue <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_iftrue;
     layer0_node7_MUX_bit_math_h_l95_c3_c081_iffalse <= VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_iffalse;
     -- Outputs
     VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_return_output := layer0_node7_MUX_bit_math_h_l95_c3_c081_return_output;

     -- layer0_node5_MUX[bit_math_h_l73_c3_7bf8] LATENCY=0
     -- Inputs
     layer0_node5_MUX_bit_math_h_l73_c3_7bf8_cond <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_cond;
     layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iftrue <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iftrue;
     layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iffalse <= VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_iffalse;
     -- Outputs
     VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_return_output := layer0_node5_MUX_bit_math_h_l73_c3_7bf8_return_output;

     -- layer0_node1_MUX[bit_math_h_l29_c3_676f] LATENCY=0
     -- Inputs
     layer0_node1_MUX_bit_math_h_l29_c3_676f_cond <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_cond;
     layer0_node1_MUX_bit_math_h_l29_c3_676f_iftrue <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_iftrue;
     layer0_node1_MUX_bit_math_h_l29_c3_676f_iffalse <= VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_iffalse;
     -- Outputs
     VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_return_output := layer0_node1_MUX_bit_math_h_l29_c3_676f_return_output;

     -- Submodule level 2
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_iffalse := VAR_layer0_node0_MUX_bit_math_h_l18_c3_9b60_return_output;
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_iftrue := VAR_layer0_node1_MUX_bit_math_h_l29_c3_676f_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_iffalse := VAR_layer0_node2_MUX_bit_math_h_l40_c3_fce9_return_output;
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_iftrue := VAR_layer0_node3_MUX_bit_math_h_l51_c3_63ce_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_iffalse := VAR_layer0_node4_MUX_bit_math_h_l62_c3_7fd6_return_output;
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_iftrue := VAR_layer0_node5_MUX_bit_math_h_l73_c3_7bf8_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_iffalse := VAR_layer0_node6_MUX_bit_math_h_l84_c3_4955_return_output;
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_iftrue := VAR_layer0_node7_MUX_bit_math_h_l95_c3_c081_return_output;
     -- layer1_node0_MUX[bit_math_h_l112_c3_11cb] LATENCY=0
     -- Inputs
     layer1_node0_MUX_bit_math_h_l112_c3_11cb_cond <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_cond;
     layer1_node0_MUX_bit_math_h_l112_c3_11cb_iftrue <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_iftrue;
     layer1_node0_MUX_bit_math_h_l112_c3_11cb_iffalse <= VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_iffalse;
     -- Outputs
     VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_return_output := layer1_node0_MUX_bit_math_h_l112_c3_11cb_return_output;

     -- layer1_node1_MUX[bit_math_h_l123_c3_ed82] LATENCY=0
     -- Inputs
     layer1_node1_MUX_bit_math_h_l123_c3_ed82_cond <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_cond;
     layer1_node1_MUX_bit_math_h_l123_c3_ed82_iftrue <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_iftrue;
     layer1_node1_MUX_bit_math_h_l123_c3_ed82_iffalse <= VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_iffalse;
     -- Outputs
     VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_return_output := layer1_node1_MUX_bit_math_h_l123_c3_ed82_return_output;

     -- layer1_node3_MUX[bit_math_h_l145_c3_98a0] LATENCY=0
     -- Inputs
     layer1_node3_MUX_bit_math_h_l145_c3_98a0_cond <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_cond;
     layer1_node3_MUX_bit_math_h_l145_c3_98a0_iftrue <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_iftrue;
     layer1_node3_MUX_bit_math_h_l145_c3_98a0_iffalse <= VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_iffalse;
     -- Outputs
     VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_return_output := layer1_node3_MUX_bit_math_h_l145_c3_98a0_return_output;

     -- layer1_node2_MUX[bit_math_h_l134_c3_7754] LATENCY=0
     -- Inputs
     layer1_node2_MUX_bit_math_h_l134_c3_7754_cond <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_cond;
     layer1_node2_MUX_bit_math_h_l134_c3_7754_iftrue <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_iftrue;
     layer1_node2_MUX_bit_math_h_l134_c3_7754_iffalse <= VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_iffalse;
     -- Outputs
     VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_return_output := layer1_node2_MUX_bit_math_h_l134_c3_7754_return_output;

     -- Submodule level 3
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_iffalse := VAR_layer1_node0_MUX_bit_math_h_l112_c3_11cb_return_output;
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_iftrue := VAR_layer1_node1_MUX_bit_math_h_l123_c3_ed82_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iffalse := VAR_layer1_node2_MUX_bit_math_h_l134_c3_7754_return_output;
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iftrue := VAR_layer1_node3_MUX_bit_math_h_l145_c3_98a0_return_output;
     -- layer2_node0_MUX[bit_math_h_l162_c3_6fde] LATENCY=0
     -- Inputs
     layer2_node0_MUX_bit_math_h_l162_c3_6fde_cond <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_cond;
     layer2_node0_MUX_bit_math_h_l162_c3_6fde_iftrue <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_iftrue;
     layer2_node0_MUX_bit_math_h_l162_c3_6fde_iffalse <= VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_iffalse;
     -- Outputs
     VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_return_output := layer2_node0_MUX_bit_math_h_l162_c3_6fde_return_output;

     -- layer2_node1_MUX[bit_math_h_l173_c3_1e3c] LATENCY=0
     -- Inputs
     layer2_node1_MUX_bit_math_h_l173_c3_1e3c_cond <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_cond;
     layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iftrue <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iftrue;
     layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iffalse <= VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_iffalse;
     -- Outputs
     VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_return_output := layer2_node1_MUX_bit_math_h_l173_c3_1e3c_return_output;

     -- Submodule level 4
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_iffalse := VAR_layer2_node0_MUX_bit_math_h_l162_c3_6fde_return_output;
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_iftrue := VAR_layer2_node1_MUX_bit_math_h_l173_c3_1e3c_return_output;
     -- layer3_node0_MUX[bit_math_h_l190_c3_5473] LATENCY=0
     -- Inputs
     layer3_node0_MUX_bit_math_h_l190_c3_5473_cond <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_cond;
     layer3_node0_MUX_bit_math_h_l190_c3_5473_iftrue <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_iftrue;
     layer3_node0_MUX_bit_math_h_l190_c3_5473_iffalse <= VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_iffalse;
     -- Outputs
     VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_return_output := layer3_node0_MUX_bit_math_h_l190_c3_5473_return_output;

     -- Submodule level 5
     VAR_return_output := VAR_layer3_node0_MUX_bit_math_h_l190_c3_5473_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
