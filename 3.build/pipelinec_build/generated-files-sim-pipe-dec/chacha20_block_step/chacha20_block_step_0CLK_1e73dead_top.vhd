library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
entity chacha20_block_step_0CLK_1e73dead_top is
port(
 clk : in std_logic;
 state0 : in chacha20_state;
 return_output : out chacha20_state);
end chacha20_block_step_0CLK_1e73dead_top;
architecture arch of chacha20_block_step_0CLK_1e73dead_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;
signal state0_input_reg : chacha20_state := chacha20_state_NULL;
attribute syn_keep of state0_input_reg : signal is true;
attribute keep of state0_input_reg : signal is "true";
attribute dont_touch of state0_input_reg : signal is "true";

signal return_output_output : chacha20_state;
signal return_output_output_reg : chacha20_state;
attribute syn_keep of return_output_output_reg : signal is true;
attribute keep of return_output_output_reg : signal is "true";
attribute dont_touch of return_output_output_reg : signal is "true";

begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
chacha20_block_step_0CLK_1e73dead : entity work.chacha20_block_step_0CLK_1e73dead port map (
state0_input_reg,
return_output_output);

 -- IO regs
 process(clk) is
 begin
  if rising_edge(clk) then
   state0_input_reg <= state0;
   return_output_output_reg <= return_output_output;
  end if;
 end process;
 return_output <= return_output_output_reg;
end arch;
