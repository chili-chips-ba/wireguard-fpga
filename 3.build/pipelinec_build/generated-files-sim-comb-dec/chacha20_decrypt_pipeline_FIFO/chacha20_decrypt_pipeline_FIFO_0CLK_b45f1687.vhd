-- Timing params:
--   Fixed?: False
--   Pipeline Slices: []
--   Input regs?: False
--   Output regs?: False
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.c_structs_pkg.all;
entity chacha20_decrypt_pipeline_FIFO_0CLK_b45f1687 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 ready_for_data_out : in unsigned(0 downto 0);
 data_in : in axis512_t;
 data_in_valid : in unsigned(0 downto 0);
 return_output : out chacha20_decrypt_pipeline_FIFO_t);
end chacha20_decrypt_pipeline_FIFO_0CLK_b45f1687;
architecture arch of chacha20_decrypt_pipeline_FIFO_0CLK_b45f1687 is
constant WIDTH : integer := axis512_t_SLV_LEN;
constant DEPTH_LOG2 : positive := positive(ieee.math_real.ceil(ieee.math_real.log2(real(64))));
signal din_slv : std_logic_vector(WIDTH-1 downto 0);
signal dout_slv : std_logic_vector(WIDTH-1 downto 0);
begin
din_slv <= axis512_t_to_slv(data_in);
return_output.data_out <= slv_to_axis512_t(dout_slv);
pipelinec_fifo_fwft_inst : entity work.pipelinec_fifo_fwft
generic map(
  DEPTH_LOG2 => DEPTH_LOG2,
  DATA_WIDTH => WIDTH
)port map(
  clk => clk,
  data_in => din_slv,
  valid_in => data_in_valid(0) and CLOCK_ENABLE(0),
  ready_out => return_output.data_in_ready(0),
  data_out => dout_slv,
  valid_out => return_output.data_out_valid(0),
  ready_in => ready_for_data_out(0) and CLOCK_ENABLE(0)
);

end arch;
