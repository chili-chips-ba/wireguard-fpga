library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
entity poly1305_mac_loop_body_0CLK_eea59ee4_top is
port(
 clk : in std_logic;
 inputs : in poly1305_mac_loop_body_in_t;
 return_output : out u320_t);
end poly1305_mac_loop_body_0CLK_eea59ee4_top;
architecture arch of poly1305_mac_loop_body_0CLK_eea59ee4_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;
signal inputs_input_reg : poly1305_mac_loop_body_in_t := poly1305_mac_loop_body_in_t_NULL;
attribute syn_keep of inputs_input_reg : signal is true;
attribute keep of inputs_input_reg : signal is "true";
attribute dont_touch of inputs_input_reg : signal is "true";

signal return_output_output : u320_t;
signal return_output_output_reg : u320_t;
attribute syn_keep of return_output_output_reg : signal is true;
attribute keep of return_output_output_reg : signal is "true";
attribute dont_touch of return_output_output_reg : signal is "true";

begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
poly1305_mac_loop_body_0CLK_eea59ee4 : entity work.poly1305_mac_loop_body_0CLK_eea59ee4 port map (
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
