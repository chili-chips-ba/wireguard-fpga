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
-- Submodules: 0
entity BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78 is
port(
 left : in unsigned(1 downto 0);
 right : in unsigned(1 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78;
architecture arch of BIN_OP_EQ_uint2_t_uint2_t_0CLK_de264c78 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;

-- One struct to represent this modules variables
type raw_hdl_variables_t is record
 -- All of the wires in function

  left_resized : std_logic_vector(1 downto 0);
  right_resized : std_logic_vector(1 downto 0);
  return_output_bool : boolean;
  return_output : unsigned(0 downto 0);
  right : unsigned(1 downto 0);
  left :  unsigned(1 downto 0);
end record;

-- Type for this modules register pipeline
type raw_hdl_register_pipeline_t is array(0 to ADDED_PIPELINE_LATENCY) of raw_hdl_variables_t;
  
begin



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right)
is 
 -- Read and write variables to do register transfers per clock
 -- from the previous to next stage
 variable read_pipe : raw_hdl_variables_t;
 variable write_pipe : raw_hdl_variables_t;

 -- This modules self pipeline registers read once per clock
 variable read_raw_hdl_pipeline_regs : raw_hdl_register_pipeline_t;
 variable write_raw_hdl_pipeline_regs : raw_hdl_register_pipeline_t;
  begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
  -- Input to first stage are inputs to function
  if STAGE=0 then
   -- raw hdl mux in inputs
   read_pipe.left := left;
   read_pipe.right := right;
  else
   -- Default read from previous stage
   read_pipe := read_raw_hdl_pipeline_regs(STAGE-1);
  end if;
  -- Default write contents of previous stage
  write_pipe := read_pipe;


    -- COMPARE N bits per clock, 
    -- num_stages = 1


    if STAGE = 0 then     
      write_pipe.return_output_bool := true;
      write_pipe.left_resized := std_logic_vector(resize(write_pipe.left,2));
      write_pipe.right_resized := std_logic_vector(resize(write_pipe.right,2));
     
      -- bits_per_stage_dict[0] = 2
      
        -- Assign output based on range for this stage
        write_pipe.return_output_bool := write_pipe.return_output_bool and (write_pipe.left_resized(1 downto 0) = write_pipe.right_resized(1 downto 0) );
        
      if  write_pipe.return_output_bool then
        write_pipe.return_output := (others => '1');
      else
        write_pipe.return_output := (others => '0');
      end if;
      
    end if;
      -- Write to stage reg
  write_raw_hdl_pipeline_regs(STAGE) := write_pipe;
 end loop;

 -- raw hdl last stage of pipeline return wire to return port/reg
 return_output <= write_raw_hdl_pipeline_regs(ADDED_PIPELINE_LATENCY).return_output;
end process;

end arch;
