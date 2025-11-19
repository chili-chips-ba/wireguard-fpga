library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
entity chacha20_decrypt_loop_body_0CLK_d3613582_top is
port(
 clk : in std_logic;
 inputs : in chacha20_decrypt_loop_body_in_t;
 return_output : out axis512_t);
end chacha20_decrypt_loop_body_0CLK_d3613582_top;
architecture arch of chacha20_decrypt_loop_body_0CLK_d3613582_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;
signal inputs_input_reg : chacha20_decrypt_loop_body_in_t := chacha20_decrypt_loop_body_in_t_NULL;
attribute syn_keep of inputs_input_reg : signal is true;
attribute keep of inputs_input_reg : signal is "true";
attribute dont_touch of inputs_input_reg : signal is "true";

signal return_output_output : axis512_t;
signal return_output_output_reg : axis512_t;
attribute syn_keep of return_output_output_reg : signal is true;
attribute keep of return_output_output_reg : signal is "true";
attribute dont_touch of return_output_output_reg : signal is "true";

begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
chacha20_decrypt_loop_body_0CLK_d3613582 : entity work.chacha20_decrypt_loop_body_0CLK_d3613582 port map (
inputs_input_reg,
return_output_output);

 -- IO regs
 process(clk) is
 begin
  if rising_edge(clk) then
   inputs_input_reg <= inputs;
   return_output_output_reg <= return_output_output;
  end if;
 end process;
 return_output <= return_output_output_reg;
end arch;
