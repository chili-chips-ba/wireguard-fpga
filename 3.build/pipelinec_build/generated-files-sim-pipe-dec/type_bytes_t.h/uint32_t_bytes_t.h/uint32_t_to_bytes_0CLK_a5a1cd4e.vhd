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
-- Submodules: 5
entity uint32_t_to_bytes_0CLK_a5a1cd4e is
port(
 x : in unsigned(31 downto 0);
 return_output : out uint8_t_array_4_t);
end uint32_t_to_bytes_0CLK_a5a1cd4e;
architecture arch of uint32_t_to_bytes_0CLK_a5a1cd4e is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
function uint32_7_0( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(7 downto 0)));
return return_output;
end function;

function uint32_15_8( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(15 downto 8)));
return return_output;
end function;

function uint32_23_16( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(23 downto 16)));
return return_output;
end function;

function uint32_31_24( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(31 downto 24)));
return return_output;
end function;

function CONST_REF_RD_uint8_t_array_4_t_uint8_t_array_4_t_4a68( ref_toks_0 : unsigned;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned) return uint8_t_array_4_t is
 
  variable base : uint8_t_array_4_t; 
  variable return_output : uint8_t_array_4_t;
begin
      base.data(0) := ref_toks_0;
      base.data(1) := ref_toks_1;
      base.data(2) := ref_toks_2;
      base.data(3) := ref_toks_3;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 


-- Combinatorial process for pipeline stages
process (
 -- Inputs
 x)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : uint8_t_array_4_t;
 variable VAR_x : unsigned(31 downto 0);
 variable VAR_rv : uint8_t_array_4_t;
 variable VAR_uint32_7_0_uint32_t_bytes_t_h_l11_c14_d39c_return_output : unsigned(7 downto 0);
 variable VAR_uint32_15_8_uint32_t_bytes_t_h_l12_c14_71c1_return_output : unsigned(7 downto 0);
 variable VAR_uint32_23_16_uint32_t_bytes_t_h_l13_c14_07ec_return_output : unsigned(7 downto 0);
 variable VAR_uint32_31_24_uint32_t_bytes_t_h_l14_c14_8b26_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_array_4_t_uint8_t_array_4_t_4a68_uint32_t_bytes_t_h_l16_c12_c412_return_output : uint8_t_array_4_t;
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_x := x;

     -- Submodule level 0
     -- uint32_23_16[uint32_t_bytes_t_h_l13_c14_07ec] LATENCY=0
     VAR_uint32_23_16_uint32_t_bytes_t_h_l13_c14_07ec_return_output := uint32_23_16(
     VAR_x);

     -- uint32_31_24[uint32_t_bytes_t_h_l14_c14_8b26] LATENCY=0
     VAR_uint32_31_24_uint32_t_bytes_t_h_l14_c14_8b26_return_output := uint32_31_24(
     VAR_x);

     -- uint32_7_0[uint32_t_bytes_t_h_l11_c14_d39c] LATENCY=0
     VAR_uint32_7_0_uint32_t_bytes_t_h_l11_c14_d39c_return_output := uint32_7_0(
     VAR_x);

     -- uint32_15_8[uint32_t_bytes_t_h_l12_c14_71c1] LATENCY=0
     VAR_uint32_15_8_uint32_t_bytes_t_h_l12_c14_71c1_return_output := uint32_15_8(
     VAR_x);

     -- Submodule level 1
     -- CONST_REF_RD_uint8_t_array_4_t_uint8_t_array_4_t_4a68[uint32_t_bytes_t_h_l16_c12_c412] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_array_4_t_uint8_t_array_4_t_4a68_uint32_t_bytes_t_h_l16_c12_c412_return_output := CONST_REF_RD_uint8_t_array_4_t_uint8_t_array_4_t_4a68(
     VAR_uint32_7_0_uint32_t_bytes_t_h_l11_c14_d39c_return_output,
     VAR_uint32_15_8_uint32_t_bytes_t_h_l12_c14_71c1_return_output,
     VAR_uint32_23_16_uint32_t_bytes_t_h_l13_c14_07ec_return_output,
     VAR_uint32_31_24_uint32_t_bytes_t_h_l14_c14_8b26_return_output);

     -- Submodule level 2
     VAR_return_output := VAR_CONST_REF_RD_uint8_t_array_4_t_uint8_t_array_4_t_4a68_uint32_t_bytes_t_h_l16_c12_c412_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
