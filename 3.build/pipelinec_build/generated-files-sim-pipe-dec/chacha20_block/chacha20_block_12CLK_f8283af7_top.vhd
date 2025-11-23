library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
entity chacha20_block_12CLK_f8283af7_top is
port(
 clk : in std_logic;
 state : in chacha20_state;
 return_output : out chacha20_state);
end chacha20_block_12CLK_f8283af7_top;
architecture arch of chacha20_block_12CLK_f8283af7_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;
signal state_input_reg : chacha20_state := chacha20_state_NULL;
attribute syn_keep of state_input_reg : signal is true;
attribute keep of state_input_reg : signal is "true";
attribute dont_touch of state_input_reg : signal is "true";

signal return_output_output : chacha20_state;
signal return_output_output_reg : chacha20_state;
attribute syn_keep of return_output_output_reg : signal is true;
attribute keep of return_output_output_reg : signal is "true";
attribute dont_touch of return_output_output_reg : signal is "true";

begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
chacha20_block_12CLK_f8283af7 : entity work.chacha20_block_12CLK_f8283af7 port map (
clk,
state_input_reg,
return_output_output);

 -- IO regs
 process(clk) is
 begin
  if rising_edge(clk) then
   state_input_reg <= state;
   return_output_output_reg <= return_output_output;
  end if;
 end process;
 return_output <= return_output_output_reg;
end arch;
