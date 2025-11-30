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
entity MUX_uint1_t_uint8_t_144_uint8_t_144_0CLK_de264c78 is
port(
 cond : in unsigned(0 downto 0);
 iftrue : in uint8_t_144;
 iffalse : in uint8_t_144;
 return_output : out uint8_t_144);
end MUX_uint1_t_uint8_t_144_uint8_t_144_0CLK_de264c78;
architecture arch of MUX_uint1_t_uint8_t_144_uint8_t_144_0CLK_de264c78 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;

-- One struct to represent this modules variables
type raw_hdl_variables_t is record
 -- All of the wires in function
  
  return_output : uint8_t_144;
  cond : unsigned(0 downto 0);
  iftrue : uint8_t_144;
  iffalse : uint8_t_144;
end record;

-- Type for this modules register pipeline
type raw_hdl_register_pipeline_t is array(0 to ADDED_PIPELINE_LATENCY) of raw_hdl_variables_t;
  
begin



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 cond,
 iftrue,
 iffalse)
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
   read_pipe.cond := cond;
   read_pipe.iftrue := iftrue;
   read_pipe.iffalse := iffalse;
  else
   -- Default read from previous stage
   read_pipe := read_raw_hdl_pipeline_regs(STAGE-1);
  end if;
  -- Default write contents of previous stage
  write_pipe := read_pipe;


    if STAGE = 0 then
      -- Assign output based on range for this stage
      if write_pipe.cond=1 then
        write_pipe.return_output := write_pipe.iftrue;
      else
        write_pipe.return_output := write_pipe.iffalse;
      end if;
    end if;     
    -- Write to stage reg
  write_raw_hdl_pipeline_regs(STAGE) := write_pipe;
 end loop;

 -- raw hdl last stage of pipeline return wire to return port/reg
 return_output <= write_raw_hdl_pipeline_regs(ADDED_PIPELINE_LATENCY).return_output;
end process;

end arch;
