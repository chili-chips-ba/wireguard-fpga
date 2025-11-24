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
-- Submodules: 8
entity bytes_to_uint64_t_0CLK_36723c85 is
port(
 bytes : in uint8_t_8;
 return_output : out unsigned(63 downto 0));
end bytes_to_uint64_t_0CLK_36723c85;
architecture arch of bytes_to_uint64_t_0CLK_36723c85 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
function uint64_uint8_0( inp : unsigned;
 x : unsigned) return unsigned is

  --variable inp : unsigned(63 downto 0);
  --variable x : unsigned(7 downto 0);
  variable intermediate : unsigned(63 downto 0);
  variable return_output : unsigned(63 downto 0);

begin

    intermediate := (others => '0');
    intermediate(63 downto 0) := unsigned(inp);
    intermediate(7 downto 0) := x;
    
    return_output := intermediate(63 downto 0) ;
    
    return return_output;

end function;

function uint64_uint8_8( inp : unsigned;
 x : unsigned) return unsigned is

  --variable inp : unsigned(63 downto 0);
  --variable x : unsigned(7 downto 0);
  variable intermediate : unsigned(63 downto 0);
  variable return_output : unsigned(63 downto 0);

begin

    intermediate := (others => '0');
    intermediate(63 downto 0) := unsigned(inp);
    intermediate(15 downto 8) := x;
    
    return_output := intermediate(63 downto 0) ;
    
    return return_output;

end function;

function uint64_uint8_16( inp : unsigned;
 x : unsigned) return unsigned is

  --variable inp : unsigned(63 downto 0);
  --variable x : unsigned(7 downto 0);
  variable intermediate : unsigned(63 downto 0);
  variable return_output : unsigned(63 downto 0);

begin

    intermediate := (others => '0');
    intermediate(63 downto 0) := unsigned(inp);
    intermediate(23 downto 16) := x;
    
    return_output := intermediate(63 downto 0) ;
    
    return return_output;

end function;

function uint64_uint8_24( inp : unsigned;
 x : unsigned) return unsigned is

  --variable inp : unsigned(63 downto 0);
  --variable x : unsigned(7 downto 0);
  variable intermediate : unsigned(63 downto 0);
  variable return_output : unsigned(63 downto 0);

begin

    intermediate := (others => '0');
    intermediate(63 downto 0) := unsigned(inp);
    intermediate(31 downto 24) := x;
    
    return_output := intermediate(63 downto 0) ;
    
    return return_output;

end function;

function uint64_uint8_32( inp : unsigned;
 x : unsigned) return unsigned is

  --variable inp : unsigned(63 downto 0);
  --variable x : unsigned(7 downto 0);
  variable intermediate : unsigned(63 downto 0);
  variable return_output : unsigned(63 downto 0);

begin

    intermediate := (others => '0');
    intermediate(63 downto 0) := unsigned(inp);
    intermediate(39 downto 32) := x;
    
    return_output := intermediate(63 downto 0) ;
    
    return return_output;

end function;

function uint64_uint8_40( inp : unsigned;
 x : unsigned) return unsigned is

  --variable inp : unsigned(63 downto 0);
  --variable x : unsigned(7 downto 0);
  variable intermediate : unsigned(63 downto 0);
  variable return_output : unsigned(63 downto 0);

begin

    intermediate := (others => '0');
    intermediate(63 downto 0) := unsigned(inp);
    intermediate(47 downto 40) := x;
    
    return_output := intermediate(63 downto 0) ;
    
    return return_output;

end function;

function uint64_uint8_48( inp : unsigned;
 x : unsigned) return unsigned is

  --variable inp : unsigned(63 downto 0);
  --variable x : unsigned(7 downto 0);
  variable intermediate : unsigned(63 downto 0);
  variable return_output : unsigned(63 downto 0);

begin

    intermediate := (others => '0');
    intermediate(63 downto 0) := unsigned(inp);
    intermediate(55 downto 48) := x;
    
    return_output := intermediate(63 downto 0) ;
    
    return return_output;

end function;

function uint64_uint8_56( inp : unsigned;
 x : unsigned) return unsigned is

  --variable inp : unsigned(63 downto 0);
  --variable x : unsigned(7 downto 0);
  variable intermediate : unsigned(63 downto 0);
  variable return_output : unsigned(63 downto 0);

begin

    intermediate := (others => '0');
    intermediate(63 downto 0) := unsigned(inp);
    intermediate(63 downto 56) := x;
    
    return_output := intermediate(63 downto 0) ;
    
    return return_output;

end function;


begin

-- SUBMODULE INSTANCES 


-- Combinatorial process for pipeline stages
process (
 -- Inputs
 bytes)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : unsigned(63 downto 0);
 variable VAR_bytes : uint8_t_8;
 variable VAR_rv : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_8_0_d41d_uint64_t_bytes_t_h_l36_c25_9e4b_return_output : unsigned(7 downto 0);
 variable VAR_uint64_uint8_0_uint64_t_bytes_t_h_l36_c6_a8d5_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_8_1_d41d_uint64_t_bytes_t_h_l37_c25_b3e6_return_output : unsigned(7 downto 0);
 variable VAR_uint64_uint8_8_uint64_t_bytes_t_h_l37_c6_eabd_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_8_2_d41d_uint64_t_bytes_t_h_l38_c26_4dd1_return_output : unsigned(7 downto 0);
 variable VAR_uint64_uint8_16_uint64_t_bytes_t_h_l38_c6_a7e5_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_8_3_d41d_uint64_t_bytes_t_h_l39_c26_3d5e_return_output : unsigned(7 downto 0);
 variable VAR_uint64_uint8_24_uint64_t_bytes_t_h_l39_c6_c9ad_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_8_4_d41d_uint64_t_bytes_t_h_l40_c26_b70a_return_output : unsigned(7 downto 0);
 variable VAR_uint64_uint8_32_uint64_t_bytes_t_h_l40_c6_c1e1_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_8_5_d41d_uint64_t_bytes_t_h_l41_c26_4c72_return_output : unsigned(7 downto 0);
 variable VAR_uint64_uint8_40_uint64_t_bytes_t_h_l41_c6_9174_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_8_6_d41d_uint64_t_bytes_t_h_l42_c26_cff0_return_output : unsigned(7 downto 0);
 variable VAR_uint64_uint8_48_uint64_t_bytes_t_h_l42_c6_33a1_return_output : unsigned(63 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_uint8_t_8_7_d41d_uint64_t_bytes_t_h_l43_c26_f548_return_output : unsigned(7 downto 0);
 variable VAR_uint64_uint8_56_uint64_t_bytes_t_h_l43_c6_322e_return_output : unsigned(63 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_bytes := bytes;

     -- Submodule level 0
     -- CONST_REF_RD_uint8_t_uint8_t_8_0_d41d[uint64_t_bytes_t_h_l36_c25_9e4b] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_0_d41d_uint64_t_bytes_t_h_l36_c25_9e4b_return_output := VAR_bytes(0);

     -- CONST_REF_RD_uint8_t_uint8_t_8_1_d41d[uint64_t_bytes_t_h_l37_c25_b3e6] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_1_d41d_uint64_t_bytes_t_h_l37_c25_b3e6_return_output := VAR_bytes(1);

     -- CONST_REF_RD_uint8_t_uint8_t_8_6_d41d[uint64_t_bytes_t_h_l42_c26_cff0] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_6_d41d_uint64_t_bytes_t_h_l42_c26_cff0_return_output := VAR_bytes(6);

     -- CONST_REF_RD_uint8_t_uint8_t_8_5_d41d[uint64_t_bytes_t_h_l41_c26_4c72] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_5_d41d_uint64_t_bytes_t_h_l41_c26_4c72_return_output := VAR_bytes(5);

     -- CONST_REF_RD_uint8_t_uint8_t_8_2_d41d[uint64_t_bytes_t_h_l38_c26_4dd1] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_2_d41d_uint64_t_bytes_t_h_l38_c26_4dd1_return_output := VAR_bytes(2);

     -- CONST_REF_RD_uint8_t_uint8_t_8_3_d41d[uint64_t_bytes_t_h_l39_c26_3d5e] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_3_d41d_uint64_t_bytes_t_h_l39_c26_3d5e_return_output := VAR_bytes(3);

     -- CONST_REF_RD_uint8_t_uint8_t_8_4_d41d[uint64_t_bytes_t_h_l40_c26_b70a] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_4_d41d_uint64_t_bytes_t_h_l40_c26_b70a_return_output := VAR_bytes(4);

     -- CONST_REF_RD_uint8_t_uint8_t_8_7_d41d[uint64_t_bytes_t_h_l43_c26_f548] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_7_d41d_uint64_t_bytes_t_h_l43_c26_f548_return_output := VAR_bytes(7);

     -- Submodule level 1
     -- uint64_uint8_0[uint64_t_bytes_t_h_l36_c6_a8d5] LATENCY=0
     VAR_uint64_uint8_0_uint64_t_bytes_t_h_l36_c6_a8d5_return_output := uint64_uint8_0(
     to_unsigned(0, 64),
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_0_d41d_uint64_t_bytes_t_h_l36_c25_9e4b_return_output);

     -- Submodule level 2
     -- uint64_uint8_8[uint64_t_bytes_t_h_l37_c6_eabd] LATENCY=0
     VAR_uint64_uint8_8_uint64_t_bytes_t_h_l37_c6_eabd_return_output := uint64_uint8_8(
     VAR_uint64_uint8_0_uint64_t_bytes_t_h_l36_c6_a8d5_return_output,
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_1_d41d_uint64_t_bytes_t_h_l37_c25_b3e6_return_output);

     -- Submodule level 3
     -- uint64_uint8_16[uint64_t_bytes_t_h_l38_c6_a7e5] LATENCY=0
     VAR_uint64_uint8_16_uint64_t_bytes_t_h_l38_c6_a7e5_return_output := uint64_uint8_16(
     VAR_uint64_uint8_8_uint64_t_bytes_t_h_l37_c6_eabd_return_output,
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_2_d41d_uint64_t_bytes_t_h_l38_c26_4dd1_return_output);

     -- Submodule level 4
     -- uint64_uint8_24[uint64_t_bytes_t_h_l39_c6_c9ad] LATENCY=0
     VAR_uint64_uint8_24_uint64_t_bytes_t_h_l39_c6_c9ad_return_output := uint64_uint8_24(
     VAR_uint64_uint8_16_uint64_t_bytes_t_h_l38_c6_a7e5_return_output,
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_3_d41d_uint64_t_bytes_t_h_l39_c26_3d5e_return_output);

     -- Submodule level 5
     -- uint64_uint8_32[uint64_t_bytes_t_h_l40_c6_c1e1] LATENCY=0
     VAR_uint64_uint8_32_uint64_t_bytes_t_h_l40_c6_c1e1_return_output := uint64_uint8_32(
     VAR_uint64_uint8_24_uint64_t_bytes_t_h_l39_c6_c9ad_return_output,
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_4_d41d_uint64_t_bytes_t_h_l40_c26_b70a_return_output);

     -- Submodule level 6
     -- uint64_uint8_40[uint64_t_bytes_t_h_l41_c6_9174] LATENCY=0
     VAR_uint64_uint8_40_uint64_t_bytes_t_h_l41_c6_9174_return_output := uint64_uint8_40(
     VAR_uint64_uint8_32_uint64_t_bytes_t_h_l40_c6_c1e1_return_output,
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_5_d41d_uint64_t_bytes_t_h_l41_c26_4c72_return_output);

     -- Submodule level 7
     -- uint64_uint8_48[uint64_t_bytes_t_h_l42_c6_33a1] LATENCY=0
     VAR_uint64_uint8_48_uint64_t_bytes_t_h_l42_c6_33a1_return_output := uint64_uint8_48(
     VAR_uint64_uint8_40_uint64_t_bytes_t_h_l41_c6_9174_return_output,
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_6_d41d_uint64_t_bytes_t_h_l42_c26_cff0_return_output);

     -- Submodule level 8
     -- uint64_uint8_56[uint64_t_bytes_t_h_l43_c6_322e] LATENCY=0
     VAR_uint64_uint8_56_uint64_t_bytes_t_h_l43_c6_322e_return_output := uint64_uint8_56(
     VAR_uint64_uint8_48_uint64_t_bytes_t_h_l42_c6_33a1_return_output,
     VAR_CONST_REF_RD_uint8_t_uint8_t_8_7_d41d_uint64_t_bytes_t_h_l43_c26_f548_return_output);

     -- Submodule level 9
     VAR_return_output := VAR_uint64_uint8_56_uint64_t_bytes_t_h_l43_c6_322e_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
