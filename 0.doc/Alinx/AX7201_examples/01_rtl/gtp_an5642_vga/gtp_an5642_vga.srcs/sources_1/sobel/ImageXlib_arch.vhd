--*******************************************************************
-- Copyright(C) 2005 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you
-- a license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as is" solely for use in developing programs and
-- solutions for Xilinx devices. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications are
-- expressly prohibited.
--
-- This copyright and support notice must be retained as part
-- of this text at all times. (c) Copyright 2005 Xilinx, Inc.
-- All rights reserved.
--
--  Title:  ImageXlib_arch.vhd
--  Created:  September 2005
--  Author: Clive Walker
--
-- $RCSfile: ImageXlib_arch.vhd,v $ $Revision: 1.19 $ $Date: 2006/02/14 21:26:44 $
--
-- ************************************************************************      

-- *********************************************
--  *0000*   Dual Port BRAM Macro
--  dp_bram
--
-- *********************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;	

entity dp_bram is
   generic
   (
      data_width           :  integer  := 8;
      mem_size             :  integer  := 1920
	);
   port
	(
	   ce       :  in    std_logic;
      
      din      :  in    std_logic_vector((data_width - 1) downto 0);
	   wr_en    :  in    std_logic;
      wr_clk   :  in    std_logic;
      wr_addr  :  in    std_logic_vector((LOG2_BASE(mem_size) - 1) downto 0);

	   rd_en    :  in    std_logic;      
      rd_clk   :  in    std_logic;
      rd_addr  :  in    std_logic_vector((LOG2_BASE(mem_size) - 1) downto 0);

      dout     :  out   std_logic_vector((data_width - 1) downto 0)

   );
end dp_bram;

architecture rtl of dp_bram is
type     mem_array_type    is array (0 to (mem_size - 1)) of std_logic_vector((data_width - 1) downto 0);							
signal   mem_array         :  mem_array_type  := (others => (others => '0'));
attribute   ram_style      :  string;
attribute   ram_style      of mem_array : signal is "block";

begin

   process (wr_clk)
   begin
      if (wr_clk'event and wr_clk = '1') then
         if (ce = '1') then
            if (wr_en = '1') then
               mem_array(conv_integer('0' & wr_addr)) <= din;
            end if;
         end if;
      end if;
   end process;
   
   process (rd_clk)
   begin
      if (rd_clk'event and rd_clk = '1') then
         if (ce = '1') then
            if (rd_en = '1') then         
               dout <= mem_array(conv_integer('0' & rd_addr));
            end if;
         end if;
      end if;
   end process;
   
end rtl;

----------------------------------------------

-- *********************************************
--  *0001*   Line Buffer Macro
--  linebuffer
--
-- *********************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;	 

entity linebuffer is
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
end linebuffer;

architecture rtl of linebuffer is

type     line_type            is array (0 to (samples_per_line - 1)) of std_logic_vector((data_width - 1) downto 0);
type     column_type          is array (0 to (no_of_lines - 1)) of std_logic_vector((data_width - 1) downto 0);

signal   hi                            :  std_logic := '1';
signal   d_data_in                     :  std_logic_vector((data_width - 1) downto 0);
constant pointer_width                 :  integer := LOG2_BASE(samples_per_line);
signal   t_write_h_pointer             :  std_logic_vector((pointer_width - 1) downto 0);
type     d_mem_dout_type               is array (0 to (no_of_lines - 1)) of column_type;
signal   d_mem_dout                    :  column_type;
signal   d2_mem_dout                   :  column_type;
signal   d_wr_en                       :  std_logic;
signal   d_rd_en                       :  std_logic_vector(no_of_lines  downto 0);
signal   app_wr_en                     :  std_logic_vector(no_of_lines  downto 0);
signal   d_cascade_en                  :  std_logic_vector(no_of_lines downto 0);
signal   mem_wr_en                     :  std_logic;
type     address_array_type            is array (no_of_lines downto 0) of std_logic_vector((pointer_width - 1) downto 0);
signal   d_read_h_pointer              :  address_array_type;
signal   app_rd_h_pointer              :  address_array_type;
signal   app_wr_h_pointer              :  address_array_type;
signal   d2_rd_en                      :  std_logic;
signal   d3_rd_en                      :  std_logic;


begin

write_h_pointer   <= t_write_h_pointer;
read_h_pointer    <= d_read_h_pointer(0);


-- Infer write-side control
wr_clk_process: process(wr_clk)
begin
   if (wr_clk'event and wr_clk = '1') then
      if (ce = '1') then 
         d_wr_en                       <= wr_en;
         d_data_in                     <= data_in; -- Initial register -
         if (wr_rst = '1') then
            t_write_h_pointer     <= (others => '0');
         elsif (d_wr_en = '1') then             
            if (t_write_h_pointer    = conv_std_logic_vector((samples_per_line - 1), pointer_width)) then
               t_write_h_pointer     <= (others => '0');
               last_wr_location     <= '1';
            else
               last_wr_location     <= '0';
               t_write_h_pointer     <= t_write_h_pointer + 1;
            end if;
         end if;
      end if;
   end if;
end process;

-- Infer memories
-- Note that the first line will be written using the write-side clock and enable, but subsequent memories will be 
-- written using the read-side clock and enable.
linebuf1 : entity work.dp_bram 
generic map
(
   data_width     => data_width,
   mem_size       => samples_per_line
)
port map
(
   ce             => ce,
   din            => d_data_in,
   wr_en          => d_wr_en,
   wr_clk         => wr_clk,
   wr_addr        => t_write_h_pointer,
   rd_en          => d_rd_en(0),   
   rd_clk         => rd_clk,
   rd_addr        => app_rd_h_pointer(0),
   dout           => d_mem_dout(0)
);

-- Cascade data from one line to another.
-- Allow for case where the cascade of line-buffers is not required - ie
-- data remains in the existing buffers available for potential reuse.
delay_cascade_en : process(rd_clk)
begin
   if (rd_clk'event and rd_clk = '1') then
      if (ce = '1') then
         d_cascade_en(0)  <= cascade_en;
         cascade_en_delay: for i in 1 to no_of_lines loop
            d_cascade_en(i)   <= d_cascade_en(i-1);
         end loop;
      end if;
   end if;
end process;



mem_array_wr : for i in 1 to (no_of_lines - 1) generate
   linebufn : entity work.dp_bram 
   generic map
   (
      data_width     => data_width,
      mem_size       => samples_per_line
   )
   port map
   (
      ce             => ce,
      din            => d2_mem_dout(i-1),
      wr_en          => app_wr_en(i),
      wr_clk         => rd_clk,
      wr_addr        => app_wr_h_pointer(i),
      rd_en          => d_rd_en(i),   
      rd_clk         => rd_clk,
      rd_addr        => app_rd_h_pointer(i),
      dout           => d_mem_dout(i)
   );

end generate;

define_applied_wr_control : for i in 1 to (no_of_lines - 1) generate
   app_wr_en(i)         <= (d3_rd_en and d_cascade_en(2)) when (feather_outputs = false) 
                                       else (d_rd_en(i+1) and d_cascade_en(i+1)) ;
   app_wr_h_pointer(i)  <= d_read_h_pointer(2) when (feather_outputs = false) else d_read_h_pointer(i+1);
end generate;

----------------------------------------------------------
-- Infer read-side control
rd_clk_process: process(rd_clk)
begin
   if (rd_clk'event and rd_clk = '1') then
      if (ce = '1') then 
         d2_mem_dout                      <= d_mem_dout;
         d_rd_en(0)                       <= rd_en;
         d2_rd_en                         <= d_rd_en(0);
         d3_rd_en                         <= d2_rd_en;
         -- Delay the read-enable for feathered-output case
         delay_rd_en_loop2 : for i in 1 to no_of_lines loop         
            if (feather_outputs = true) then
               d_rd_en(i)                    <= d_rd_en(i-1);
            else
               d_rd_en(i)                    <= rd_en;
            end if;
         end loop;
      
         -- Generate read-pointer
         if (rd_rst = '1') then
            d_read_h_pointer(0)     <= (others => '0');
         elsif (d_rd_en(0) = '1') then       
            if (d_read_h_pointer(0) = conv_std_logic_vector((samples_per_line - 1), pointer_width)) then
               d_read_h_pointer(0)     <= (others => '0');
               last_rd_location        <= '1';
            else
               last_rd_location        <= '0';
               d_read_h_pointer(0)     <= d_read_h_pointer(0) + 1;
            end if;
         end if;

         -- Delay the read-pointer for feathered-output case
         delay_d_read_h_pointer_loop : for i in 1 to no_of_lines loop
---            if (d_rd_en(i) = '1') then       
               d_read_h_pointer(i)           <= d_read_h_pointer(i-1);
---            end if;
         end loop;
      end if;
   end if;
end process;

define_applied_rd_pointer : for i in 0 to (no_of_lines - 1) generate
   app_rd_h_pointer(i) <= d_read_h_pointer(0) when (feather_outputs = false) else d_read_h_pointer(i);
end generate;
   

----------------------------------------------------------
-- Define output.
dout_gen : for i in 0 to (no_of_lines - 1) generate
   data_out(i)((data_width - 1) downto 0)	<= d_mem_dout(i);
end generate;

end rtl;

-- ************************************************************************

-- *********************************************
--  *0002*   Base Single Line Buffer Macro
--  base_single_linebuffer
--
-- *********************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;	 

entity base_single_linebuffer is
   generic
   (
      data_width           :  integer  := 8;
      samples_per_line     :  integer  := 1000
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
      data_out          :  out   std_logic_vector((data_width - 1) downto 0)
   );
end base_single_linebuffer;

architecture rtl of base_single_linebuffer is

signal   hi       :  std_logic := '1';
signal   lo       :  std_logic := '0';
signal   lb_out   :  std_logic_vector_array(0 downto 0);
begin

data_out <= lb_out(0)((data_width - 1) downto 0);

lb1 : entity work.linebuffer
generic map
(
   data_width        => data_width,
   samples_per_line  => samples_per_line,
   no_of_lines       => 1,
   feather_outputs   => false
)
port map
(
   ce                => ce,
   wr_clk            => wr_clk,
   wr_en             => wr_en,
   wr_rst            => wr_rst,
   data_in           => data_in,
   write_h_pointer   => open,
   last_wr_location  => open,
   rd_clk            => rd_clk,
   rd_rst            => rd_rst,   
   rd_en             => rd_en,
   cascade_en        => hi,
   read_h_pointer    => open,
   last_rd_location  => open,
   data_out          => lb_out
);


end rtl;

-- ************************************************************************

-- *********************************************
--  *0003*   Based 2D Line Buffer Macro
--  based_2d_linebuffer
--
-- *********************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;	 

entity base_2d_linebuffer is
   generic
   (
      data_width           :  integer  := 8;
      samples_per_line     :  integer  := 1000;
      no_of_lines          :  integer  := 2 -- In order to make 2D filter....
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
      data_out          :  out   std_logic_vector_array((no_of_lines - 1) downto 0)
   );
end base_2d_linebuffer;

architecture rtl of base_2d_linebuffer is

signal   hi       :  std_logic := '1';
signal   lo       :  std_logic := '0';		  

begin

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
   cascade_en        => hi,
   read_h_pointer    => open,
   last_rd_location  => open,
   data_out          => data_out
);


end rtl;

-- ************************************************************************

-- *********************************************
--  *0004*   Horizontal Pipe Macro
--  h_pipe
--
-- *********************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;

entity h_pipe is
   generic
   (
      num_h_taps              :  integer  := 2;                -- coefs must be an array of at least this length. Extra values in array are ignored.      
      data_width              :  integer  := 8                 -- input width = output width
   );
   port
	(
	   ce                :  in    std_logic;
	   clk               :  in    std_logic;
	   data_in           :  in    std_logic_vector((data_width - 1) downto 0);
	   shift_en          :  in    std_logic;
      data_out          :  out   std_logic_vector_array((num_h_taps - 1) downto 0)
   );
end h_pipe;

architecture rtl of h_pipe is

signal   logic1               :  std_logic   := '1';
signal   logic0               :  std_logic   := '0';
type     hpipe_type           is array(0 to (2*(num_h_taps - 1))) of std_logic_vector((data_width - 1) downto 0);
signal   hpipe                :  hpipe_type;
signal   d_h_pipe_enable      :  std_logic_vector(num_h_taps  downto 0);
begin

d_h_pipe_enable(0)   <= shift_en;
cascade_pipeline_enable : for i in 1 to num_h_taps generate
   d_h_pipe_enable_line : process(clk)
   begin
      if (clk'event and clk = '1') then 
         if (ce = '1') then
            d_h_pipe_enable(i)   <= d_h_pipe_enable(i-1);
         end if;
      end if;
   end process;
end generate;

-- Define location 0 as first input sample (or output of linebuffer).
hpipe(0)                                     <= data_in;
data_out(0)((data_width - 1) downto 0)       <= hpipe(0);

-- Every instance of '2' in this loop should really be a generic parameter.
pipe_shift : for i in 1 to (num_h_taps - 1) generate
   pipes : process(clk)
   begin
      if (clk'event and clk = '1') then
         if (ce = '1') then
            hpipe((2*i)-1)   <= hpipe((2*i) - 2);
            if (d_h_pipe_enable(i+1) = '0') then
               hpipe(2*i)    <= hpipe((2*i)-1);
            end if;
         end if;
      end if;
   end process;
   data_out(i)((data_width - 1) downto 0) <= hpipe(2*i);
end generate;

end rtl;

-- ************************************************************************
-- *0005* Multi-channel (interleaved) h-pipe Marco
-- mc_h_pipe
--
-- ************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;

entity mc_h_pipe is
   generic
   (
      num_channels            :  integer  := 2;
      num_h_taps              :  integer  := 2;
      data_width              :  integer  := 8
   );
   port
	(
	   ce                :  in    std_logic;
	   clk               :  in    std_logic;
	   data_in           :  in    std_logic_vector((data_width - 1) downto 0);
	   shift_en          :  in    std_logic;
      data_out          :  out   std_logic_vector_array((num_h_taps - 1) downto 0)
   );
end mc_h_pipe;

architecture rtl of mc_h_pipe is

signal   logic1               :  std_logic   := '1';
signal   logic0               :  std_logic   := '0';
type     hpipe_type           is array(((num_h_taps - 1)*(num_channels + 1)) downto 0) of std_logic_vector((data_width - 1) downto 0);
signal   hpipe                :  hpipe_type;
signal   d_h_pipe_enable      :  std_logic_vector(num_h_taps  downto 0);
begin

d_h_pipe_enable(0)   <= shift_en;
cascade_pipeline_enable : for i in 1 to num_h_taps generate
   d_h_pipe_enable_line : process(clk)
   begin
      if (clk'event and clk = '1') then   
         if (ce = '1') then            
            d_h_pipe_enable(i)   <= d_h_pipe_enable(i-1);
         end if;
      end if;
   end process;
end generate;

-- Define location 0 as first input sample (or output of linebuffer).
hpipe(0)                                     <= data_in;
data_out(0)((data_width - 1) downto 0)       <= hpipe(0);

pipe_shift : for i in 0 to (num_h_taps - 2) generate
   data_out(i+1)((data_width - 1) downto 0) <= hpipe((num_channels + 1)*(i+1)); -- Work from this principle.

   -- Clock enable all but last location in pipe for each tap
   enabled_pipeline_locations : for j in 0 to (num_channels - 1) generate   
      enabled_pipes : process(clk)
      begin
      if (clk'event and clk = '1') then
         if (ce = '1') then      
            if (d_h_pipe_enable(i) = '1') then
               hpipe((i*(num_channels + 1)) + j + 1)    <= hpipe((i*(num_channels + 1)) + j);
            end if;
         end if;
      end if;
      end process;
   end generate;

   final_pipe_register : process(clk)
   begin
   if (clk'event and clk = '1') then
      if (ce = '1') then
         -- Final register in pipe is not enabled. This is effectively the pipeline register for each tap.
         hpipe((num_channels + 1) * (i+1))    <= hpipe(((num_channels + 1) * (i+1)) - 1);
      end if;
   end if;
   end process;
end generate;
end rtl;   


-- ************************************************************************
-- *0006* Active picture timing delay unit
-- active_delay
--
--
-- For modules that take in standard form chroma, it is assumed that the din_valid 
-- signal will always be aligned with a h_sync signal.
-- H-sync must be continuous, but din_valid must mark only the active lines.
-- All active lines must be contiguous within a field.
-- Even for 4:2:0, all active lines are marked with din_valid = 1
-- 
--                                                          :  
--           __________      __________      __________     :__________      __________    
-- HS_IN    |          |    |          |    |          |    |          |    |          |   
--        --            ----            ----            ----            ----            -- 
--                           __________      __________     :__________     
-- DIN_VALID                |  first   |    |          |    |   last   |   
--          ----------------            ----            ----:            ----------------- 
--                                                          :
-- ************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 
use work.imagexlib_utils.all;

entity active_delay is
   generic
   (
      active_input_samples_per_line       :  integer  := 1920;
      v_delay                             :  integer  := 0;
      h_delay                             :  integer  := 0;
      input_chroma_format                 :  integer  := 0; -- 0 : 4:4:4; 1 : 4:2:2; 2 : 4:2:0
      output_chroma_format                :  integer  := 0  
   );
   port
   (
      ce                      :  in    std_logic;
      clk                     :  in    std_logic;
      vs_in                   :  in    std_logic;
      hs_in                   :  in    std_logic;
      din_valid               :  in    std_logic;
      v_reset_out             :  out   std_logic;
      hs_out                  :  out   std_logic;
      vs_out                  :  out   std_logic;
      dout_valid              :  out   std_logic;
      chroma_420_line_valid   :  out   std_logic
   );
end active_delay;

architecture rtl of active_delay is
signal   d_din_valid                :  std_logic;
signal   d_hs_in                    :  std_logic;
signal   d_vs_in                    :  std_logic;
signal   d2_vs_in                   :  std_logic;
signal   vs_r_edge                  :  std_logic;
constant h_count_width              :  integer := LOG2_BASE(2*active_input_samples_per_line);
signal   input_sample_count         :  std_logic_vector((h_count_width-1) downto 0);
signal   early_dout_valid           :  std_logic;
signal   dout_valid_420_mask        :  std_logic;
signal   dout_valid_mask            :  std_logic;
signal   d_h_count_en               :  std_logic;
signal   d_h_count                  :  std_logic_vector((h_count_width-1) downto 0);
signal   d_valid_data_window        :  std_logic_vector(v_delay downto 0);
signal   d_vs                       :  std_logic_vector(v_delay downto 0);
signal   early_vs_out               :  std_logic;
begin

main_proc : process (clk)
begin
   if (clk'event) and (clk = '1') then
      if (ce = '1') then
         d_din_valid    <= din_valid;
         d_hs_in        <= hs_in;
         d_vs_in        <= vs_in;
         d2_vs_in       <= d_vs_in;
         
         vs_r_edge      <= d_vs_in and not(d2_vs_in);
         v_reset_out    <= d_vs_in and not(d2_vs_in);
         
         -- Need to create a flag which acts as a window indicating the valid data in OUTPUT space,
         -- but based upon what we see in the INPUT. 
         -- The window 'opens' when first high din_valid is found on hs_in rising edge.
         -- For 4:4:4 and 4:2:2, the window 'closes' din_valid is low on a hs_in rising edge
         -- This flag is generated in UNDELAYED space.
         if (vs_r_edge = '1') then
            d_valid_data_window(0)           <= '0';
         elsif ((hs_in = '1') and (d_hs_in = '0')) then -- rising edge of h_sync
            if (din_valid = '1') then
               d_valid_data_window(0)        <= '1';
            else
               d_valid_data_window(0)        <= '0';
            end if;
         end if;

         -- Generate an un-offset h-sample count
         if (vs_r_edge = '1') then
            input_sample_count               <= (others => '0');
         elsif ((hs_in = '1') and (d_hs_in = '0')) then -- rising edge of h_sync
            input_sample_count   <= (others => '0');
         else
            input_sample_count   <= input_sample_count + 1;
         end if;
         
      end if;
   end if;
end process;

-- Delay the valid_data_window by the appropriate number of lines.
-- Also delay vs_in accordingly to give vs_out (horizontally undelayed).
d_vs(0)                    <= d_vs_in;
delay_valid_data_window : for i in 1 to (v_delay) generate
   delay_line_count_proc : process (clk)
   begin
      if (clk'event) and (clk = '1') then
         if (ce = '1') then
            if ((hs_in = '0') and (d_hs_in = '1')) then
               d_valid_data_window(i)  <= d_valid_data_window(i-1);
               d_vs(i)                 <= d_vs(i-1);
            end if;
         end if;
      end if;
   end process;
end generate;

decode_proc : process (clk)
begin
   if (clk'event) and (clk = '1') then
      if (ce = '1') then
         if (vs_r_edge = '1') then
            dout_valid           <= '0';  
            early_dout_valid     <= '0';
            dout_valid_420_mask  <= '1';
            dout_valid_mask      <= '1';
            d_h_count            <= (others => '0');
            d_h_count_en         <= '0';
            vs_out               <= '0';
         else
            if (input_sample_count = conv_std_logic_vector(h_delay-3, h_count_width)) then
               early_dout_valid     <= '1';
               if (d_valid_data_window(v_delay) = '1') then
                  dout_valid_420_mask  <= not(dout_valid_420_mask);
                  dout_valid_mask      <= '0';
               end if;
               early_vs_out         <= d_vs(v_delay);
               d_h_count_en         <= '1';
            elsif (d_h_count = conv_std_logic_vector((active_input_samples_per_line - 1), h_count_width)) then
               early_dout_valid     <= '0';
               dout_valid_mask      <= '1';
               d_h_count_en         <= '0';
               d_h_count            <= (others => '0');               
            else
               if (d_h_count_en = '1') then
                  d_h_count         <= d_h_count + 1;
               end if;
            end if;
            vs_out                  <= early_vs_out;
            hs_out                  <= early_dout_valid;
            chroma_420_line_valid   <= early_dout_valid and not(dout_valid_mask) and not(dout_valid_420_mask);
            dout_valid              <= early_dout_valid and not(dout_valid_mask);
         end if;
      end if;
   end if;
end process;

end rtl;