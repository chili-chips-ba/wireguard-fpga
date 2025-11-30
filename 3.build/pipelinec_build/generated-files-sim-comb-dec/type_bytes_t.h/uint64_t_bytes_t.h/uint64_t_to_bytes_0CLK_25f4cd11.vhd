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
-- Submodules: 9
entity uint64_t_to_bytes_0CLK_25f4cd11 is
port(
 x : in unsigned(63 downto 0);
 return_output : out uint8_t_array_8_t);
end uint64_t_to_bytes_0CLK_25f4cd11;
architecture arch of uint64_t_to_bytes_0CLK_25f4cd11 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
function uint64_7_0( x : unsigned) return unsigned is
--variable x : unsigned(63 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(7 downto 0)));
return return_output;
end function;

function uint64_15_8( x : unsigned) return unsigned is
--variable x : unsigned(63 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(15 downto 8)));
return return_output;
end function;

function uint64_23_16( x : unsigned) return unsigned is
--variable x : unsigned(63 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(23 downto 16)));
return return_output;
end function;

function uint64_31_24( x : unsigned) return unsigned is
--variable x : unsigned(63 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(31 downto 24)));
return return_output;
end function;

function uint64_39_32( x : unsigned) return unsigned is
--variable x : unsigned(63 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(39 downto 32)));
return return_output;
end function;

function uint64_47_40( x : unsigned) return unsigned is
--variable x : unsigned(63 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(47 downto 40)));
return return_output;
end function;

function uint64_55_48( x : unsigned) return unsigned is
--variable x : unsigned(63 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(55 downto 48)));
return return_output;
end function;

function uint64_63_56( x : unsigned) return unsigned is
--variable x : unsigned(63 downto 0);
  variable return_output : unsigned(7 downto 0);
begin
return_output := unsigned(std_logic_vector(x(63 downto 56)));
return return_output;
end function;

function CONST_REF_RD_uint8_t_array_8_t_uint8_t_array_8_t_dd58( ref_toks_0 : unsigned;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned;
 ref_toks_4 : unsigned;
 ref_toks_5 : unsigned;
 ref_toks_6 : unsigned;
 ref_toks_7 : unsigned) return uint8_t_array_8_t is
 
  variable base : uint8_t_array_8_t; 
  variable return_output : uint8_t_array_8_t;
begin
      base.data(0) := ref_toks_0;
      base.data(1) := ref_toks_1;
      base.data(2) := ref_toks_2;
      base.data(3) := ref_toks_3;
      base.data(4) := ref_toks_4;
      base.data(5) := ref_toks_5;
      base.data(6) := ref_toks_6;
      base.data(7) := ref_toks_7;

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
 variable VAR_return_output : uint8_t_array_8_t;
 variable VAR_x : unsigned(63 downto 0);
 variable VAR_rv : uint8_t_array_8_t;
 variable VAR_uint64_7_0_uint64_t_bytes_t_h_l11_c14_f4b1_return_output : unsigned(7 downto 0);
 variable VAR_uint64_15_8_uint64_t_bytes_t_h_l12_c14_490c_return_output : unsigned(7 downto 0);
 variable VAR_uint64_23_16_uint64_t_bytes_t_h_l13_c14_4f15_return_output : unsigned(7 downto 0);
 variable VAR_uint64_31_24_uint64_t_bytes_t_h_l14_c14_9752_return_output : unsigned(7 downto 0);
 variable VAR_uint64_39_32_uint64_t_bytes_t_h_l15_c14_3793_return_output : unsigned(7 downto 0);
 variable VAR_uint64_47_40_uint64_t_bytes_t_h_l16_c14_b210_return_output : unsigned(7 downto 0);
 variable VAR_uint64_55_48_uint64_t_bytes_t_h_l17_c14_7afd_return_output : unsigned(7 downto 0);
 variable VAR_uint64_63_56_uint64_t_bytes_t_h_l18_c14_215c_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_array_8_t_uint8_t_array_8_t_dd58_uint64_t_bytes_t_h_l20_c12_fd20_return_output : uint8_t_array_8_t;
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_x := x;

     -- Submodule level 0
     -- uint64_23_16[uint64_t_bytes_t_h_l13_c14_4f15] LATENCY=0
     VAR_uint64_23_16_uint64_t_bytes_t_h_l13_c14_4f15_return_output := uint64_23_16(
     VAR_x);

     -- uint64_55_48[uint64_t_bytes_t_h_l17_c14_7afd] LATENCY=0
     VAR_uint64_55_48_uint64_t_bytes_t_h_l17_c14_7afd_return_output := uint64_55_48(
     VAR_x);

     -- uint64_47_40[uint64_t_bytes_t_h_l16_c14_b210] LATENCY=0
     VAR_uint64_47_40_uint64_t_bytes_t_h_l16_c14_b210_return_output := uint64_47_40(
     VAR_x);

     -- uint64_31_24[uint64_t_bytes_t_h_l14_c14_9752] LATENCY=0
     VAR_uint64_31_24_uint64_t_bytes_t_h_l14_c14_9752_return_output := uint64_31_24(
     VAR_x);

     -- uint64_63_56[uint64_t_bytes_t_h_l18_c14_215c] LATENCY=0
     VAR_uint64_63_56_uint64_t_bytes_t_h_l18_c14_215c_return_output := uint64_63_56(
     VAR_x);

     -- uint64_7_0[uint64_t_bytes_t_h_l11_c14_f4b1] LATENCY=0
     VAR_uint64_7_0_uint64_t_bytes_t_h_l11_c14_f4b1_return_output := uint64_7_0(
     VAR_x);

     -- uint64_39_32[uint64_t_bytes_t_h_l15_c14_3793] LATENCY=0
     VAR_uint64_39_32_uint64_t_bytes_t_h_l15_c14_3793_return_output := uint64_39_32(
     VAR_x);

     -- uint64_15_8[uint64_t_bytes_t_h_l12_c14_490c] LATENCY=0
     VAR_uint64_15_8_uint64_t_bytes_t_h_l12_c14_490c_return_output := uint64_15_8(
     VAR_x);

     -- Submodule level 1
     -- CONST_REF_RD_uint8_t_array_8_t_uint8_t_array_8_t_dd58[uint64_t_bytes_t_h_l20_c12_fd20] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_array_8_t_uint8_t_array_8_t_dd58_uint64_t_bytes_t_h_l20_c12_fd20_return_output := CONST_REF_RD_uint8_t_array_8_t_uint8_t_array_8_t_dd58(
     VAR_uint64_7_0_uint64_t_bytes_t_h_l11_c14_f4b1_return_output,
     VAR_uint64_15_8_uint64_t_bytes_t_h_l12_c14_490c_return_output,
     VAR_uint64_23_16_uint64_t_bytes_t_h_l13_c14_4f15_return_output,
     VAR_uint64_31_24_uint64_t_bytes_t_h_l14_c14_9752_return_output,
     VAR_uint64_39_32_uint64_t_bytes_t_h_l15_c14_3793_return_output,
     VAR_uint64_47_40_uint64_t_bytes_t_h_l16_c14_b210_return_output,
     VAR_uint64_55_48_uint64_t_bytes_t_h_l17_c14_7afd_return_output,
     VAR_uint64_63_56_uint64_t_bytes_t_h_l18_c14_215c_return_output);

     -- Submodule level 2
     VAR_return_output := VAR_CONST_REF_RD_uint8_t_array_8_t_uint8_t_array_8_t_dd58_uint64_t_bytes_t_h_l20_c12_fd20_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
