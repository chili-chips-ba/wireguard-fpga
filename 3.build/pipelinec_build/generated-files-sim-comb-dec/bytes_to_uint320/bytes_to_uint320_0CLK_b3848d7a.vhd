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
-- Submodules: 1
entity bytes_to_uint320_0CLK_b3848d7a is
port(
 src : in uint8_t_40;
 return_output : out u320_t);
end bytes_to_uint320_0CLK_b3848d7a;
architecture arch of bytes_to_uint320_0CLK_b3848d7a is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- bytes_to_u320_t[poly1305_h_l76_c12_5157]
signal bytes_to_u320_t_poly1305_h_l76_c12_5157_bytes : uint8_t_40;
signal bytes_to_u320_t_poly1305_h_l76_c12_5157_return_output : u320_t;


begin

-- SUBMODULE INSTANCES 
-- bytes_to_u320_t_poly1305_h_l76_c12_5157 : 0 clocks latency
bytes_to_u320_t_poly1305_h_l76_c12_5157 : entity work.bytes_to_u320_t_0CLK_4bbc8984 port map (
bytes_to_u320_t_poly1305_h_l76_c12_5157_bytes,
bytes_to_u320_t_poly1305_h_l76_c12_5157_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 src,
 -- All submodule outputs
 bytes_to_u320_t_poly1305_h_l76_c12_5157_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u320_t;
 variable VAR_src : uint8_t_40;
 variable VAR_bytes_to_u320_t_poly1305_h_l76_c12_5157_bytes : uint8_t_40;
 variable VAR_bytes_to_u320_t_poly1305_h_l76_c12_5157_return_output : u320_t;
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_src := src;

     -- Submodule level 0
     VAR_bytes_to_u320_t_poly1305_h_l76_c12_5157_bytes := VAR_src;
     -- bytes_to_u320_t[poly1305_h_l76_c12_5157] LATENCY=0
     -- Inputs
     bytes_to_u320_t_poly1305_h_l76_c12_5157_bytes <= VAR_bytes_to_u320_t_poly1305_h_l76_c12_5157_bytes;
     -- Outputs
     VAR_bytes_to_u320_t_poly1305_h_l76_c12_5157_return_output := bytes_to_u320_t_poly1305_h_l76_c12_5157_return_output;

     -- Submodule level 1
     VAR_return_output := VAR_bytes_to_u320_t_poly1305_h_l76_c12_5157_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
