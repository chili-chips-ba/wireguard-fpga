library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
entity quarter_round_0CLK_638872ab_top is
port(
 clk : in std_logic;
 s : in chacha20_state;
 a : in unsigned(3 downto 0);
 b : in unsigned(3 downto 0);
 c : in unsigned(3 downto 0);
 d : in unsigned(3 downto 0);
 return_output : out chacha20_state);
end quarter_round_0CLK_638872ab_top;
architecture arch of quarter_round_0CLK_638872ab_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;
signal s_input_reg : chacha20_state := chacha20_state_NULL;
attribute syn_keep of s_input_reg : signal is true;
attribute keep of s_input_reg : signal is "true";
attribute dont_touch of s_input_reg : signal is "true";
signal a_input_reg : unsigned(3 downto 0) := to_unsigned(0, 4);
attribute syn_keep of a_input_reg : signal is true;
attribute keep of a_input_reg : signal is "true";
attribute dont_touch of a_input_reg : signal is "true";
signal b_input_reg : unsigned(3 downto 0) := to_unsigned(0, 4);
attribute syn_keep of b_input_reg : signal is true;
attribute keep of b_input_reg : signal is "true";
attribute dont_touch of b_input_reg : signal is "true";
signal c_input_reg : unsigned(3 downto 0) := to_unsigned(0, 4);
attribute syn_keep of c_input_reg : signal is true;
attribute keep of c_input_reg : signal is "true";
attribute dont_touch of c_input_reg : signal is "true";
signal d_input_reg : unsigned(3 downto 0) := to_unsigned(0, 4);
attribute syn_keep of d_input_reg : signal is true;
attribute keep of d_input_reg : signal is "true";
attribute dont_touch of d_input_reg : signal is "true";

signal return_output_output : chacha20_state;
signal return_output_output_reg : chacha20_state;
attribute syn_keep of return_output_output_reg : signal is true;
attribute keep of return_output_output_reg : signal is "true";
attribute dont_touch of return_output_output_reg : signal is "true";

begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
quarter_round_0CLK_638872ab : entity work.quarter_round_0CLK_638872ab port map (
s_input_reg,
a_input_reg,
b_input_reg,
c_input_reg,
d_input_reg,
return_output_output);

 -- IO regs
 process(clk) is
 begin
  if rising_edge(clk) then
   s_input_reg <= s;
   a_input_reg <= a;
   b_input_reg <= b;
   c_input_reg <= c;
   d_input_reg <= d;
   return_output_output_reg <= return_output_output;
  end if;
 end process;
 return_output <= return_output_output_reg;
end arch;
