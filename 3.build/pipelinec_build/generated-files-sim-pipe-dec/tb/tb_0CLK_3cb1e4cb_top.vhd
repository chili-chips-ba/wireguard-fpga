library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
use work.global_wires_pkg.all;
entity tb_0CLK_3cb1e4cb_top is
port(
 clk : in std_logic;
 global_to_module : in tb_global_to_module_t;
 module_to_global : out tb_module_to_global_t;
 return_output : out axis128_t_stream_t);
end tb_0CLK_3cb1e4cb_top;
architecture arch of tb_0CLK_3cb1e4cb_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;

signal return_output_output : axis128_t_stream_t;
signal return_output_output_reg : axis128_t_stream_t;
attribute syn_keep of return_output_output_reg : signal is true;
attribute keep of return_output_output_reg : signal is "true";
attribute dont_touch of return_output_output_reg : signal is "true";

signal global_to_module_input_reg : tb_global_to_module_t;
attribute syn_keep of global_to_module_input_reg : signal is true;
attribute keep of global_to_module_input_reg : signal is "true";
attribute dont_touch of global_to_module_input_reg : signal is "true";
signal module_to_global_output : tb_module_to_global_t;
signal module_to_global_output_reg : tb_module_to_global_t;
attribute syn_keep of module_to_global_output_reg : signal is true;
attribute keep of module_to_global_output_reg : signal is "true";
attribute dont_touch of module_to_global_output_reg : signal is "true";
begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
tb_0CLK_3cb1e4cb : entity work.tb_0CLK_3cb1e4cb port map (
clk,
to_unsigned(1,1),
 global_to_module_input_reg,
 module_to_global_output,
return_output_output);

 -- IO regs
 process(clk) is
 begin
  if rising_edge(clk) then
   return_output_output_reg <= return_output_output;
   global_to_module_input_reg <= global_to_module;
   module_to_global_output_reg <= module_to_global_output;
  end if;
 end process;
 return_output <= return_output_output_reg;
 module_to_global <= module_to_global_output_reg;
end arch;
