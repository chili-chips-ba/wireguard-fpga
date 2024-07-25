LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;


entity linebuffer_Wapper is
   generic
   (
      no_of_lines        :  integer  := 3;                -- coefs must be an array of at least this length. Extra values in array are ignored.
      samples_per_line  :  integer  := 1920;              -- Required in order to configure store size
      data_width        :  integer  := 8                -- input width = output width
   );
   port
   (
      ce                :  in    std_logic;
      wr_clk            :  in    std_logic;
      wr_en             :  in    std_logic;
      wr_rst            :  in    std_logic;
      data_in           :  in    std_logic_vector((data_width - 1) downto 0);
      rd_en             :  in    std_logic;
      rd_clk            :  in    std_logic;      
      rd_rst            :  in    std_logic;
      data_out          :  out   std_logic_vector((data_width * no_of_lines- 1) downto 0)
   );
end linebuffer_Wapper;

architecture rtl of linebuffer_Wapper is

component linebuffer is
   generic
   (
      data_width           :  integer  := 8;
      samples_per_line     :  integer  := 1000;
      no_of_lines          :  integer  := 3; -- In order to make 2D filter....
      feather_outputs      :  boolean  := true  
	);
   port
	(
      ce                :  in    std_logic;
      wr_clk            :  in    std_logic;
      wr_en             :  in    std_logic;
      wr_rst            :  in    std_logic;
      data_in           :  in    std_logic_vector((data_width - 1) downto 0);
      write_h_pointer   :  out   std_logic_vector((LOG2_BASE(samples_per_line) - 1) downto 0);
      last_wr_location  :  out   std_logic;
      rd_clk            :  in    std_logic;      
      rd_en             :  in    std_logic;
      rd_rst            :  in    std_logic;
      cascade_en        :  in    std_logic;
      read_h_pointer    :  out   std_logic_vector((LOG2_BASE(samples_per_line) - 1) downto 0);      
      last_rd_location  :  out   std_logic;
      data_out          :  out   std_logic_vector_array((no_of_lines - 1) downto 0)
   );
end component;
	signal out_tmp : std_logic_vector_array((no_of_lines - 1) downto 0);
begin
out_tmp_a : for i in 0 to (no_of_lines - 1) generate
	data_out((data_width * i + data_width - 1) downto data_width * i) <= out_tmp(i)((data_width - 1) downto 0);
end generate;

lb1 : entity work.linebuffer
generic map
(
   data_width        => data_width,
   samples_per_line  => samples_per_line,
   no_of_lines       => no_of_lines,
   feather_outputs   => false
)
port map
(
   ce                => ce,
   wr_clk            => wr_clk,
   wr_rst            => wr_rst,   
   wr_en             => wr_en,
   data_in           => data_in,
   write_h_pointer   => open,
   last_wr_location  => open,
   rd_clk            => rd_clk,
   rd_rst            => rd_rst,   
   rd_en             => rd_en,
   cascade_en        => '1',
   read_h_pointer    => open,
   last_rd_location  => open,
   data_out          => out_tmp
);

end rtl;