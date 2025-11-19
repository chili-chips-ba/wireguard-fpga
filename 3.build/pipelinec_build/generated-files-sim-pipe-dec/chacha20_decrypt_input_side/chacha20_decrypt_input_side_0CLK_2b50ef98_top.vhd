library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
use work.global_wires_pkg.all;
entity chacha20_decrypt_input_side_0CLK_2b50ef98_top is
port(
 clk : in std_logic;
 global_to_module : in chacha20_decrypt_input_side_global_to_module_t;
 module_to_global : out chacha20_decrypt_input_side_module_to_global_t);
end chacha20_decrypt_input_side_0CLK_2b50ef98_top;
architecture arch of chacha20_decrypt_input_side_0CLK_2b50ef98_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;


signal global_to_module_input_reg : chacha20_decrypt_input_side_global_to_module_t;
attribute syn_keep of global_to_module_input_reg : signal is true;
attribute keep of global_to_module_input_reg : signal is "true";
attribute dont_touch of global_to_module_input_reg : signal is "true";
signal module_to_global_output : chacha20_decrypt_input_side_module_to_global_t;
signal module_to_global_output_reg : chacha20_decrypt_input_side_module_to_global_t;
attribute syn_keep of module_to_global_output_reg : signal is true;
attribute keep of module_to_global_output_reg : signal is "true";
attribute dont_touch of module_to_global_output_reg : signal is "true";
begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
chacha20_decrypt_input_side_0CLK_2b50ef98 : entity work.chacha20_decrypt_input_side_0CLK_2b50ef98 port map (
clk,
to_unsigned(1,1),
 global_to_module_input_reg,
 module_to_global_output);

 -- IO regs
 process(clk) is
 begin
  if rising_edge(clk) then
   global_to_module_input_reg <= global_to_module;
   module_to_global_output_reg <= module_to_global_output;
  end if;
 end process;
 module_to_global <= module_to_global_output_reg;
end arch;
