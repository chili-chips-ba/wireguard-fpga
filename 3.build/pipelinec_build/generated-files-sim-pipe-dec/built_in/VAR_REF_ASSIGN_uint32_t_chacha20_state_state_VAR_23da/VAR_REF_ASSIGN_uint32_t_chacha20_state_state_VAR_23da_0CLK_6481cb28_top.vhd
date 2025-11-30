library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
entity VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28_top is
port(
 clk : in std_logic;
 elem_val : in unsigned(31 downto 0);
 ref_toks_0 : in chacha20_state;
 var_dim_0 : in unsigned(3 downto 0);
 return_output : out uint32_t_array_16_t);
end VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28_top;
architecture arch of VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28_top is
attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;
signal elem_val_input_reg : unsigned(31 downto 0) := to_unsigned(0, 32);
attribute syn_keep of elem_val_input_reg : signal is true;
attribute keep of elem_val_input_reg : signal is "true";
attribute dont_touch of elem_val_input_reg : signal is "true";
signal ref_toks_0_input_reg : chacha20_state := chacha20_state_NULL;
attribute syn_keep of ref_toks_0_input_reg : signal is true;
attribute keep of ref_toks_0_input_reg : signal is "true";
attribute dont_touch of ref_toks_0_input_reg : signal is "true";
signal var_dim_0_input_reg : unsigned(3 downto 0) := to_unsigned(0, 4);
attribute syn_keep of var_dim_0_input_reg : signal is true;
attribute keep of var_dim_0_input_reg : signal is "true";
attribute dont_touch of var_dim_0_input_reg : signal is "true";

signal return_output_output : uint32_t_array_16_t;
signal return_output_output_reg : uint32_t_array_16_t;
attribute syn_keep of return_output_output_reg : signal is true;
attribute keep of return_output_output_reg : signal is "true";
attribute dont_touch of return_output_output_reg : signal is "true";

begin
-- Instantiate entity
-- Top level funcs always synthesized as clock enabled
VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 : entity work.VAR_REF_ASSIGN_uint32_t_chacha20_state_state_VAR_23da_0CLK_6481cb28 port map (
elem_val_input_reg,
ref_toks_0_input_reg,
var_dim_0_input_reg,
return_output_output);

 -- IO regs
 process(clk) is
 begin
  if rising_edge(clk) then
   elem_val_input_reg <= elem_val;
   ref_toks_0_input_reg <= ref_toks_0;
   var_dim_0_input_reg <= var_dim_0;
   return_output_output_reg <= return_output_output;
  end if;
 end process;
 return_output <= return_output_output_reg;
end arch;
