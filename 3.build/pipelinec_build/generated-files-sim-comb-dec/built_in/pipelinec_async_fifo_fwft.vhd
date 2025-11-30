-- This is an async FWFT FIFO with AXIS style flags,
-- a modified copy of this AXIS FIFO:
-- https://github.com/alexforencich/verilog-axis/blob/master/rtl/axis_async_fifo.v
-- Also referenced https://gitlab.com/spade-lang/spade/-/blob/main/stdlib/mem.spade?ref_type=heads#L205

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity pipelinec_async_fifo_fwft is
  generic (
    DATA_WIDTH    : integer := 1;
    DEPTH_LOG2    : integer := 1
  );
  port (
    in_clk            : in  std_logic;
    valid_in  : in  std_logic;
    ready_out  : out std_logic;
    data_in   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    out_clk : in std_logic;
    valid_out  : out std_logic;
    ready_in  : in  std_logic;
    data_out   : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity pipelinec_async_fifo_fwft;

architecture rtl of pipelinec_async_fifo_fwft is

constant ADDR_WIDTH : integer := DEPTH_LOG2;

constant WIDTH : integer := DATA_WIDTH;

constant RAM_PIPELINE : integer := 0; -- TODO make generic again

signal in_por_rst : std_logic := '1';
signal out_por_rst : std_logic := '1';

function bin2gray(b : unsigned(ADDR_WIDTH downto 0)) return unsigned is
  variable rv : unsigned(ADDR_WIDTH downto 0) := (others => '0');
begin
  rv := b xor (b srl 1);
  return rv;
end function;

function gray2bin(g : unsigned(ADDR_WIDTH downto 0)) return unsigned is
  variable rv : unsigned(ADDR_WIDTH downto 0) := (others => '0');
begin
  for i in 0 to ADDR_WIDTH loop
    -- Cant use 'xor' for reduce since no VHDL 2008 in Quartus Lite
    rv(i) := xor_reduce(std_logic_vector(g srl i));
  end loop;
  return rv;
end function;

signal wr_ptr_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
signal wr_ptr_commit_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
signal wr_ptr_gray_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
signal wr_ptr_sync_commit_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
signal rd_ptr_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
signal rd_ptr_gray_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
signal wr_ptr_conv_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
signal rd_ptr_conv_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');

--(* SHREG_EXTRACT = "NO" *)
signal wr_ptr_gray_sync1_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
--(* SHREG_EXTRACT = "NO" *)
signal wr_ptr_gray_sync2_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
--(* SHREG_EXTRACT = "NO" *)
signal wr_ptr_commit_sync_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
--(* SHREG_EXTRACT = "NO" *)
signal rd_ptr_gray_sync1_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');
--(* SHREG_EXTRACT = "NO" *)
signal rd_ptr_gray_sync2_reg : unsigned(ADDR_WIDTH downto 0)  := (others => '0');

signal wr_ptr_update_valid_reg : std_logic  := '0';
signal wr_ptr_update_reg : std_logic  := '0';
--(* SHREG_EXTRACT = "NO" *)
signal wr_ptr_update_sync1_reg : std_logic  := '0';
--(* SHREG_EXTRACT = "NO" *)
signal wr_ptr_update_sync2_reg : std_logic  := '0';
--(* SHREG_EXTRACT = "NO" *)
signal wr_ptr_update_sync3_reg : std_logic  := '0';
--(* SHREG_EXTRACT = "NO" *)
signal wr_ptr_update_ack_sync1_reg : std_logic  := '0';
--(* SHREG_EXTRACT = "NO" *)
signal wr_ptr_update_ack_sync2_reg : std_logic  := '0';

--(* ramstyle = "no_rw_check" *)
type mem_type is array (natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
signal mem              : mem_type(2**ADDR_WIDTH-1 downto 0):= (others => (others => '0'));
signal mem_read_data_valid_reg : std_logic := '0';

--(* shreg_extract = "no" *)
signal output_stream_pipe_reg : mem_type(RAM_PIPELINE+1-1 downto 0) := (others => (others => '0'));
signal valid_out_pipe_reg : std_logic_vector(RAM_PIPELINE+1-1 downto 0) := (others => '0');

signal full : std_logic ;
signal empty : std_logic ;
signal input_stream : std_logic_vector(WIDTH-1 downto 0) ;
signal output_stream : std_logic_vector(WIDTH-1 downto 0) ;
signal ready_in_pipe : std_logic                   ;
signal valid_out_pipe : std_logic                   ;
signal data_out_pipe : std_logic_vector(WIDTH-1 downto 0)  ;
signal ready_in_out : std_logic                   ;
signal valid_out_out : std_logic                   ;
signal data_out_out : std_logic_vector(WIDTH-1 downto 0)  ;
signal pipe_ready : std_logic ;

constant mask : unsigned(ADDR_WIDTH downto 0) := "11" & to_unsigned(0, ADDR_WIDTH-1); -- {2'b11, {ADDR_WIDTH-1{1'b0}}}

-- Need internal copy of signal since no VHDL 2008 in Quartus Lite
signal ready_out_internal : std_logic;

begin

-- full when first TWO MSBs do NOT match, but rest matches
-- (gray code equivalent of first MSB different but rest same)
full <= '1' when wr_ptr_gray_reg = (rd_ptr_gray_sync2_reg xor mask) else '0';
-- empty when pointers match exactly
empty <= '1' when (rd_ptr_gray_reg = wr_ptr_gray_sync2_reg) else '0';

ready_out_internal <= '1' when full='0' and in_por_rst='0' else '0';
ready_out <= ready_out_internal;

input_stream <= data_in;

output_stream <= output_stream_pipe_reg(RAM_PIPELINE+1-1);

valid_out_pipe <= valid_out_pipe_reg(RAM_PIPELINE+1-1);

data_out_pipe <= output_stream;
 
-- Write logic
process (in_clk)
  variable wr_ptr_temp : unsigned(ADDR_WIDTH downto 0) ;
begin
if rising_edge(in_clk) then

    -- normal FIFO mode
    if ready_out_internal='1' and valid_in='1' then
        -- transfer in
        mem(to_integer(wr_ptr_reg(ADDR_WIDTH-1 downto 0))) <= input_stream;
        wr_ptr_temp := wr_ptr_reg + 1;
        wr_ptr_reg <= wr_ptr_temp;
        wr_ptr_commit_reg <= wr_ptr_temp;
        wr_ptr_gray_reg <= bin2gray(wr_ptr_temp);
    end if;

    if in_por_rst='1' then
        wr_ptr_reg <= (others => '0');
        wr_ptr_commit_reg <= (others => '0');
        wr_ptr_gray_reg <= (others => '0');
        wr_ptr_sync_commit_reg <= (others => '0');

        wr_ptr_update_valid_reg <= '0';
        wr_ptr_update_reg <= '0';
    end if;

    in_por_rst <= '0';

end if;
end process;

-- pointer synchronization
process (in_clk)
begin
if rising_edge(in_clk) then
    rd_ptr_gray_sync1_reg <= rd_ptr_gray_reg;
    rd_ptr_gray_sync2_reg <= rd_ptr_gray_sync1_reg;
    wr_ptr_update_ack_sync1_reg <= wr_ptr_update_sync3_reg;
    wr_ptr_update_ack_sync2_reg <= wr_ptr_update_ack_sync1_reg;

    if in_por_rst='1' then
        rd_ptr_gray_sync1_reg <= (others => '0');
        rd_ptr_gray_sync2_reg <= (others => '0');
        wr_ptr_update_ack_sync1_reg <= '0';
        wr_ptr_update_ack_sync2_reg <= '0';
    end if;
end if;
end process;
process (out_clk)
begin
if rising_edge(out_clk) then
    wr_ptr_gray_sync1_reg <= wr_ptr_gray_reg;
    wr_ptr_gray_sync2_reg <= wr_ptr_gray_sync1_reg;
    wr_ptr_update_sync1_reg <= wr_ptr_update_reg;
    wr_ptr_update_sync2_reg <= wr_ptr_update_sync1_reg;
    wr_ptr_update_sync3_reg <= wr_ptr_update_sync2_reg;

    if out_por_rst='1' then
        wr_ptr_gray_sync1_reg <= (others => '0');
        wr_ptr_gray_sync2_reg <= (others => '0');
        wr_ptr_commit_sync_reg <= (others => '0');
        wr_ptr_update_sync1_reg <= '0';
        wr_ptr_update_sync2_reg <= '0';
        wr_ptr_update_sync3_reg <= '0';
    end if;
end if;
end process;

-- Read logic
process (out_clk)
  variable rd_ptr_temp : unsigned(ADDR_WIDTH downto 0) ;
begin
if rising_edge(out_clk) then
    if ready_in_pipe='1' then
        -- output ready; invalidate stage
        valid_out_pipe_reg(RAM_PIPELINE+1-1) <= '0';
    end if;

    --for j in RAM_PIPELINE+1-1 downto 1 loop
    --  if (ready_in_pipe || ((~valid_out_pipe_reg) >> j)) begin
    --    -- output ready or bubble in pipeline; transfer down pipeline
    --    valid_out_pipe_reg[j] <= valid_out_pipe_reg[j-1];
    --    output_stream_pipe_reg[j] <= output_stream_pipe_reg[j-1];
    --    valid_out_pipe_reg[j-1] <= '0';
    --  end
    --end loop;

    if ready_in_pipe='1' or (unsigned(not(valid_out_pipe_reg))>0) then
        -- output ready or bubble in pipeline; read new data from FIFO
        valid_out_pipe_reg(0) <= '0';
        output_stream_pipe_reg(0) <= mem(to_integer(rd_ptr_reg(ADDR_WIDTH-1 downto 0)));
        if empty='0' and out_por_rst='0' and pipe_ready='1' then
            -- not empty, increment pointer
            valid_out_pipe_reg(0) <= '1';
            rd_ptr_temp := rd_ptr_reg + 1;
            rd_ptr_reg <= rd_ptr_temp;
            rd_ptr_gray_reg <= rd_ptr_temp xor (rd_ptr_temp srl 1);
        end if;
    end if;

    if out_por_rst='1' then
        rd_ptr_reg <= (others => '0');
        rd_ptr_gray_reg <= (others => '0');
        valid_out_pipe_reg <= (others => '0');
    end if;

    out_por_rst <= '0';
end if;
end process;

pipe_ready <= '1';

ready_in_pipe <= ready_in_out;
valid_out_out <= valid_out_pipe;

data_out_out <= data_out_pipe;

ready_in_out <= ready_in;
valid_out <= valid_out_out;

data_out <= data_out_out;

end architecture rtl;
