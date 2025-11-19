-- This is a sync FWFT FIFO with AXIS style flags,
-- a modified copy of this AXIS FIFO:
-- https://github.com/alexforencich/verilog-axis/blob/master/rtl/axis_fifo.v

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipelinec_fifo_fwft is
  generic (
    DATA_WIDTH    : integer := 1;
    DEPTH_LOG2    : integer := 1
  );
  port (
    clk            : in  std_logic;
    valid_in  : in  std_logic;
    ready_out  : out std_logic;
    data_in   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    valid_out  : out std_logic;
    ready_in  : in  std_logic;
    data_out   : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity pipelinec_fifo_fwft;

architecture rtl of pipelinec_fifo_fwft is

  constant ADDR_WIDTH : integer := DEPTH_LOG2;
  type mem_type is array (natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal mem              : mem_type(2**ADDR_WIDTH-1 downto 0):= (others => (others => '0'));
  signal wr_ptr_reg       : unsigned(ADDR_WIDTH downto 0) := (others => '0');
  signal wr_ptr_cur_reg   : unsigned(ADDR_WIDTH downto 0) := (others => '0');
  signal rd_ptr_reg       : unsigned(ADDR_WIDTH downto 0) := (others => '0');
  signal mem_read_data_valid_reg : std_logic := '0';
  signal data_out_pipe_reg  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal valid_out_pipe_reg : std_logic := '0';
  signal full             : std_logic;
  signal full_cur         : std_logic;
  signal empty            : std_logic;
  signal full_wr          : std_logic;
  signal valid_out_pipe : std_logic;
  signal data_out_pipe : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal pipe_ready       : std_logic;
  signal por : std_logic := '1';
  signal ready_out_internal : std_logic;
  function make_mask return unsigned is
    variable rv : unsigned(ADDR_WIDTH downto 0) := (others => '0');
  begin
    rv(ADDR_WIDTH) := '1';
    return rv;
  end function;
  constant mask : unsigned(ADDR_WIDTH downto 0) := make_mask; --(ADDR_WIDTH => '1', others => '0');

begin
  por <= '0' when rising_edge(clk);
 
  -- full when first MSB different but rest same
  full <= '1' when wr_ptr_reg = (rd_ptr_reg xor mask) else '0';
  full_cur <= '1' when wr_ptr_cur_reg = (rd_ptr_reg xor mask) else '0';
  -- empty when pointers match exactly
  empty <= '1' when  wr_ptr_reg = rd_ptr_reg else '0';
  -- overflow within packet
  full_wr <= '1' when wr_ptr_reg = (wr_ptr_cur_reg xor mask) else '0';

  ready_out_internal <= not full and not por;
  ready_out <= ready_out_internal;
  
  valid_out_pipe <= valid_out_pipe_reg;
  data_out_pipe <= data_out_pipe_reg;

  -- Write logic
  process (clk)
  begin
    if rising_edge(clk) then
      if por = '1' then
        wr_ptr_reg <= (others => '0');
        wr_ptr_cur_reg <= (others => '0');
      else
        if ready_out_internal = '1' and valid_in = '1' then
          -- transfer in
          -- normal FIFO mode
          mem(to_integer(wr_ptr_reg(ADDR_WIDTH-1 downto 0))) <= data_in;
          wr_ptr_reg <= wr_ptr_reg + 1;
        end if;
      end if;
    end if;
  end process;
 
  -- Read logic
  process (clk)
  begin
    if rising_edge(clk) then
      if por = '1' then
        rd_ptr_reg <= (others => '0');
        valid_out_pipe_reg <= '0';
      else
        if ready_in = '1' then
          -- output ready; invalidate stage
          valid_out_pipe_reg <= '0';
        end if;     
        
        if ready_in = '1' or valid_out_pipe_reg = '0' then
          -- output ready or bubble in pipeline; read new data from FIFO
          valid_out_pipe_reg <= '0';
          data_out_pipe_reg <= mem(to_integer(rd_ptr_reg(ADDR_WIDTH-1 downto 0)));
          if empty = '0' and pipe_ready = '1' then
            -- not empty, increment pointer
            valid_out_pipe_reg <= '1';
            rd_ptr_reg <= rd_ptr_reg + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  pipe_ready <= '1';
  valid_out <= valid_out_pipe;
  data_out <= data_out_pipe;

end architecture rtl;
