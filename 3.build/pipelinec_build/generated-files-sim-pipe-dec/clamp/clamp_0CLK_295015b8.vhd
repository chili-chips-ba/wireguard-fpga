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
entity clamp_0CLK_295015b8 is
port(
 r : in u8_16_t;
 return_output : out u8_16_t);
end clamp_0CLK_295015b8;
architecture arch of clamp_0CLK_295015b8 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- BIN_OP_AND[poly1305_h_l56_c5_ad06]
signal BIN_OP_AND_poly1305_h_l56_c5_ad06_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l56_c5_ad06_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l56_c5_ad06_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l57_c5_f170]
signal BIN_OP_AND_poly1305_h_l57_c5_f170_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l57_c5_f170_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l57_c5_f170_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l58_c5_1237]
signal BIN_OP_AND_poly1305_h_l58_c5_1237_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l58_c5_1237_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l58_c5_1237_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l59_c5_0c0c]
signal BIN_OP_AND_poly1305_h_l59_c5_0c0c_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l59_c5_0c0c_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l59_c5_0c0c_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l60_c5_c82f]
signal BIN_OP_AND_poly1305_h_l60_c5_c82f_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l60_c5_c82f_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l60_c5_c82f_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l61_c5_fe69]
signal BIN_OP_AND_poly1305_h_l61_c5_fe69_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l61_c5_fe69_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l61_c5_fe69_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l62_c5_41b7]
signal BIN_OP_AND_poly1305_h_l62_c5_41b7_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l62_c5_41b7_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l62_c5_41b7_return_output : unsigned(7 downto 0);

function CONST_REF_RD_u8_16_t_u8_16_t_be0a( ref_toks_0 : u8_16_t;
 ref_toks_1 : unsigned;
 ref_toks_2 : unsigned;
 ref_toks_3 : unsigned;
 ref_toks_4 : unsigned;
 ref_toks_5 : unsigned;
 ref_toks_6 : unsigned;
 ref_toks_7 : unsigned) return u8_16_t is
 
  variable base : u8_16_t; 
  variable return_output : u8_16_t;
begin
      base := ref_toks_0;
      base.bytes(3) := ref_toks_1;
      base.bytes(7) := ref_toks_2;
      base.bytes(11) := ref_toks_3;
      base.bytes(15) := ref_toks_4;
      base.bytes(4) := ref_toks_5;
      base.bytes(8) := ref_toks_6;
      base.bytes(12) := ref_toks_7;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_AND_poly1305_h_l56_c5_ad06 : 0 clocks latency
BIN_OP_AND_poly1305_h_l56_c5_ad06 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l56_c5_ad06_left,
BIN_OP_AND_poly1305_h_l56_c5_ad06_right,
BIN_OP_AND_poly1305_h_l56_c5_ad06_return_output);

-- BIN_OP_AND_poly1305_h_l57_c5_f170 : 0 clocks latency
BIN_OP_AND_poly1305_h_l57_c5_f170 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l57_c5_f170_left,
BIN_OP_AND_poly1305_h_l57_c5_f170_right,
BIN_OP_AND_poly1305_h_l57_c5_f170_return_output);

-- BIN_OP_AND_poly1305_h_l58_c5_1237 : 0 clocks latency
BIN_OP_AND_poly1305_h_l58_c5_1237 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l58_c5_1237_left,
BIN_OP_AND_poly1305_h_l58_c5_1237_right,
BIN_OP_AND_poly1305_h_l58_c5_1237_return_output);

-- BIN_OP_AND_poly1305_h_l59_c5_0c0c : 0 clocks latency
BIN_OP_AND_poly1305_h_l59_c5_0c0c : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l59_c5_0c0c_left,
BIN_OP_AND_poly1305_h_l59_c5_0c0c_right,
BIN_OP_AND_poly1305_h_l59_c5_0c0c_return_output);

-- BIN_OP_AND_poly1305_h_l60_c5_c82f : 0 clocks latency
BIN_OP_AND_poly1305_h_l60_c5_c82f : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l60_c5_c82f_left,
BIN_OP_AND_poly1305_h_l60_c5_c82f_right,
BIN_OP_AND_poly1305_h_l60_c5_c82f_return_output);

-- BIN_OP_AND_poly1305_h_l61_c5_fe69 : 0 clocks latency
BIN_OP_AND_poly1305_h_l61_c5_fe69 : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l61_c5_fe69_left,
BIN_OP_AND_poly1305_h_l61_c5_fe69_right,
BIN_OP_AND_poly1305_h_l61_c5_fe69_return_output);

-- BIN_OP_AND_poly1305_h_l62_c5_41b7 : 0 clocks latency
BIN_OP_AND_poly1305_h_l62_c5_41b7 : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l62_c5_41b7_left,
BIN_OP_AND_poly1305_h_l62_c5_41b7_right,
BIN_OP_AND_poly1305_h_l62_c5_41b7_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 r,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l56_c5_ad06_return_output,
 BIN_OP_AND_poly1305_h_l57_c5_f170_return_output,
 BIN_OP_AND_poly1305_h_l58_c5_1237_return_output,
 BIN_OP_AND_poly1305_h_l59_c5_0c0c_return_output,
 BIN_OP_AND_poly1305_h_l60_c5_c82f_return_output,
 BIN_OP_AND_poly1305_h_l61_c5_fe69_return_output,
 BIN_OP_AND_poly1305_h_l62_c5_41b7_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u8_16_t;
 variable VAR_r : u8_16_t;
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_0e48_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_ad06_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_ad06_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_ad06_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_e83a_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_f170_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_f170_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_f170_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_3c10_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_1237_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_1237_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_1237_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_7280_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_0c0c_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_0c0c_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_0c0c_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_704a_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_c82f_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_c82f_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_c82f_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_5199_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_fe69_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_fe69_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_fe69_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_2cf9_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_41b7_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_41b7_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_41b7_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_d7db_return_output : u8_16_t;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_AND_poly1305_h_l59_c5_0c0c_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l61_c5_fe69_right := to_unsigned(252, 8);
     VAR_BIN_OP_AND_poly1305_h_l62_c5_41b7_right := to_unsigned(252, 8);
     VAR_BIN_OP_AND_poly1305_h_l57_c5_f170_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l58_c5_1237_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l56_c5_ad06_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l60_c5_c82f_right := to_unsigned(252, 8);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_r := r;

     -- Submodule level 0
     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d[poly1305_h_l56_c5_0e48] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_0e48_return_output := VAR_r.bytes(3);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d[poly1305_h_l59_c5_7280] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_7280_return_output := VAR_r.bytes(15);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d[poly1305_h_l58_c5_3c10] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_3c10_return_output := VAR_r.bytes(11);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d[poly1305_h_l57_c5_e83a] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_e83a_return_output := VAR_r.bytes(7);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d[poly1305_h_l60_c5_704a] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_704a_return_output := VAR_r.bytes(4);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d[poly1305_h_l61_c5_5199] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_5199_return_output := VAR_r.bytes(8);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d[poly1305_h_l62_c5_2cf9] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_2cf9_return_output := VAR_r.bytes(12);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l58_c5_1237_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_3c10_return_output;
     VAR_BIN_OP_AND_poly1305_h_l62_c5_41b7_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_2cf9_return_output;
     VAR_BIN_OP_AND_poly1305_h_l59_c5_0c0c_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_7280_return_output;
     VAR_BIN_OP_AND_poly1305_h_l56_c5_ad06_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_0e48_return_output;
     VAR_BIN_OP_AND_poly1305_h_l60_c5_c82f_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_704a_return_output;
     VAR_BIN_OP_AND_poly1305_h_l57_c5_f170_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_e83a_return_output;
     VAR_BIN_OP_AND_poly1305_h_l61_c5_fe69_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_5199_return_output;
     -- BIN_OP_AND[poly1305_h_l57_c5_f170] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l57_c5_f170_left <= VAR_BIN_OP_AND_poly1305_h_l57_c5_f170_left;
     BIN_OP_AND_poly1305_h_l57_c5_f170_right <= VAR_BIN_OP_AND_poly1305_h_l57_c5_f170_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l57_c5_f170_return_output := BIN_OP_AND_poly1305_h_l57_c5_f170_return_output;

     -- BIN_OP_AND[poly1305_h_l62_c5_41b7] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l62_c5_41b7_left <= VAR_BIN_OP_AND_poly1305_h_l62_c5_41b7_left;
     BIN_OP_AND_poly1305_h_l62_c5_41b7_right <= VAR_BIN_OP_AND_poly1305_h_l62_c5_41b7_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l62_c5_41b7_return_output := BIN_OP_AND_poly1305_h_l62_c5_41b7_return_output;

     -- BIN_OP_AND[poly1305_h_l56_c5_ad06] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l56_c5_ad06_left <= VAR_BIN_OP_AND_poly1305_h_l56_c5_ad06_left;
     BIN_OP_AND_poly1305_h_l56_c5_ad06_right <= VAR_BIN_OP_AND_poly1305_h_l56_c5_ad06_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l56_c5_ad06_return_output := BIN_OP_AND_poly1305_h_l56_c5_ad06_return_output;

     -- BIN_OP_AND[poly1305_h_l58_c5_1237] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l58_c5_1237_left <= VAR_BIN_OP_AND_poly1305_h_l58_c5_1237_left;
     BIN_OP_AND_poly1305_h_l58_c5_1237_right <= VAR_BIN_OP_AND_poly1305_h_l58_c5_1237_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l58_c5_1237_return_output := BIN_OP_AND_poly1305_h_l58_c5_1237_return_output;

     -- BIN_OP_AND[poly1305_h_l60_c5_c82f] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l60_c5_c82f_left <= VAR_BIN_OP_AND_poly1305_h_l60_c5_c82f_left;
     BIN_OP_AND_poly1305_h_l60_c5_c82f_right <= VAR_BIN_OP_AND_poly1305_h_l60_c5_c82f_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l60_c5_c82f_return_output := BIN_OP_AND_poly1305_h_l60_c5_c82f_return_output;

     -- BIN_OP_AND[poly1305_h_l61_c5_fe69] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l61_c5_fe69_left <= VAR_BIN_OP_AND_poly1305_h_l61_c5_fe69_left;
     BIN_OP_AND_poly1305_h_l61_c5_fe69_right <= VAR_BIN_OP_AND_poly1305_h_l61_c5_fe69_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l61_c5_fe69_return_output := BIN_OP_AND_poly1305_h_l61_c5_fe69_return_output;

     -- BIN_OP_AND[poly1305_h_l59_c5_0c0c] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l59_c5_0c0c_left <= VAR_BIN_OP_AND_poly1305_h_l59_c5_0c0c_left;
     BIN_OP_AND_poly1305_h_l59_c5_0c0c_right <= VAR_BIN_OP_AND_poly1305_h_l59_c5_0c0c_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l59_c5_0c0c_return_output := BIN_OP_AND_poly1305_h_l59_c5_0c0c_return_output;

     -- Submodule level 2
     -- CONST_REF_RD_u8_16_t_u8_16_t_be0a[poly1305_h_l63_c12_d7db] LATENCY=0
     VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_d7db_return_output := CONST_REF_RD_u8_16_t_u8_16_t_be0a(
     VAR_r,
     VAR_BIN_OP_AND_poly1305_h_l56_c5_ad06_return_output,
     VAR_BIN_OP_AND_poly1305_h_l57_c5_f170_return_output,
     VAR_BIN_OP_AND_poly1305_h_l58_c5_1237_return_output,
     VAR_BIN_OP_AND_poly1305_h_l59_c5_0c0c_return_output,
     VAR_BIN_OP_AND_poly1305_h_l60_c5_c82f_return_output,
     VAR_BIN_OP_AND_poly1305_h_l61_c5_fe69_return_output,
     VAR_BIN_OP_AND_poly1305_h_l62_c5_41b7_return_output);

     -- Submodule level 3
     VAR_return_output := VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_d7db_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
