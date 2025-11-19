library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
entity uint320_mul_0CLK_babc4282_top is
port(
 clk : in std_logic;
 a : in u320_t;
 b : in u320_t;
 return_output : out u320_t);
end uint320_mul_0CLK_babc4282_top;
architecture arch of uint320_mul_0CLK_babc4282_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;
signal a_input_reg : u320_t := u320_t_NULL;
attribute syn_keep of a_input_reg : signal is true;
attribute keep of a_input_reg : signal is "true";
attribute dont_touch of a_input_reg : signal is "true";
signal b_input_reg : u320_t := u320_t_NULL;
attribute syn_keep of b_input_reg : signal is true;
attribute keep of b_input_reg : signal is "true";
attribute dont_touch of b_input_reg : signal is "true";

signal return_output_output : u320_t;
signal return_output_output_reg : u320_t;
attribute syn_keep of return_output_output_reg : signal is true;
attribute keep of return_output_output_reg : signal is "true";
attribute dont_touch of return_output_output_reg : signal is "true";

begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
uint320_mul_0CLK_babc4282 : entity work.uint320_mul_0CLK_babc4282 port map (
a_input_reg,
b_input_reg,
return_output_output);

 -- IO regs
 process(clk) is
 begin
  if rising_edge(clk) then
   a_input_reg <= a;
   b_input_reg <= b;
   return_output_output_reg <= return_output_output;
  end if;
 end process;
 return_output <= return_output_output_reg;
end arch;
