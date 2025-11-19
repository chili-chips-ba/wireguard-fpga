library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
entity VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8_top is
port(
 clk : in std_logic;
 ref_toks_0 : in chacha20_state;
 var_dim_0 : in unsigned(3 downto 0);
 return_output : out unsigned(31 downto 0));
end VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8_top;
architecture arch of VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;
signal ref_toks_0_input_reg : chacha20_state := chacha20_state_NULL;
attribute syn_keep of ref_toks_0_input_reg : signal is true;
attribute keep of ref_toks_0_input_reg : signal is "true";
attribute dont_touch of ref_toks_0_input_reg : signal is "true";
signal var_dim_0_input_reg : unsigned(3 downto 0) := to_unsigned(0, 4);
attribute syn_keep of var_dim_0_input_reg : signal is true;
attribute keep of var_dim_0_input_reg : signal is "true";
attribute dont_touch of var_dim_0_input_reg : signal is "true";

signal return_output_output : unsigned(31 downto 0);
signal return_output_output_reg : unsigned(31 downto 0);
attribute syn_keep of return_output_output_reg : signal is true;
attribute keep of return_output_output_reg : signal is "true";
attribute dont_touch of return_output_output_reg : signal is "true";

begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 : entity work.VAR_REF_RD_uint32_t_chacha20_state_state_VAR_d41d_0CLK_763c90e8 port map (
ref_toks_0_input_reg,
var_dim_0_input_reg,
return_output_output);

 -- IO regs
 process(clk) is
 begin
  if rising_edge(clk) then
   ref_toks_0_input_reg <= ref_toks_0;
   var_dim_0_input_reg <= var_dim_0;
   return_output_output_reg <= return_output_output;
  end if;
 end process;
 return_output <= return_output_output_reg;
end arch;
