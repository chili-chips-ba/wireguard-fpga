
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.c_structs_pkg.all; -- User types

    entity clk_cross_verify_fifo_FIFO is
    port(
      in_clk : in std_logic;

      in_clk_en : in unsigned(0 downto 0);

      write_data : in axis128_t_1;
      write_enable : in unsigned(0 downto 0);
      wr_return_output: out verify_fifo_FIFO_write_t;

      out_clk : in std_logic;

      out_clk_en : in unsigned(0 downto 0);

      read_enable: in unsigned(0 downto 0);
      rd_return_output : out verify_fifo_FIFO_read_t

    );
    end clk_cross_verify_fifo_FIFO;
    architecture arch of clk_cross_verify_fifo_FIFO is
    
      signal full : std_logic;
      signal wr_rst_busy : std_logic;
      signal rd_rst_busy : std_logic;
      signal ready : std_logic;
      signal valid : std_logic;
      signal fifo_rd_enable : std_logic;
      signal fifo_wr_en : std_logic;
      signal wr_power_on_reset : std_logic := '1';
      signal rd_power_on_reset : std_logic := '1';
      signal din_slv : std_logic_vector((axis128_t_1_SLV_LEN)-1 downto 0);
      signal dout_slv : std_logic_vector((axis128_t_1_SLV_LEN)-1 downto 0);
      
    begin
    din_slv <= axis128_t_1_to_slv(write_data);
    rd_return_output.data <= slv_to_axis128_t_1(dout_slv);
pipelinec_fifo_fwft_inst : entity work.pipelinec_fifo_fwft
generic map (
    DEPTH_LOG2 => 7,
    DATA_WIDTH => axis128_t_1_SLV_LEN
)
port map
(
    clk => in_clk,

    valid_in  => write_enable(0) and in_clk_en(0),
    ready_out => wr_return_output.ready(0),
    data_in   => din_slv,
    
    valid_out => rd_return_output.valid(0),
    ready_in  => read_enable(0) and out_clk_en(0),
    data_out  => dout_slv
);
    
    end arch;
    