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
-- BIN_OP_AND[poly1305_h_l56_c5_aaaf]
signal BIN_OP_AND_poly1305_h_l56_c5_aaaf_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l56_c5_aaaf_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l56_c5_aaaf_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l57_c5_0935]
signal BIN_OP_AND_poly1305_h_l57_c5_0935_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l57_c5_0935_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l57_c5_0935_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l58_c5_127d]
signal BIN_OP_AND_poly1305_h_l58_c5_127d_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l58_c5_127d_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l58_c5_127d_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l59_c5_1ce9]
signal BIN_OP_AND_poly1305_h_l59_c5_1ce9_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l59_c5_1ce9_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l59_c5_1ce9_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l60_c5_047c]
signal BIN_OP_AND_poly1305_h_l60_c5_047c_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l60_c5_047c_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l60_c5_047c_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l61_c5_c7ad]
signal BIN_OP_AND_poly1305_h_l61_c5_c7ad_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l61_c5_c7ad_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l61_c5_c7ad_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l62_c5_09ee]
signal BIN_OP_AND_poly1305_h_l62_c5_09ee_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l62_c5_09ee_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l62_c5_09ee_return_output : unsigned(7 downto 0);

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
-- BIN_OP_AND_poly1305_h_l56_c5_aaaf : 0 clocks latency
BIN_OP_AND_poly1305_h_l56_c5_aaaf : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l56_c5_aaaf_left,
BIN_OP_AND_poly1305_h_l56_c5_aaaf_right,
BIN_OP_AND_poly1305_h_l56_c5_aaaf_return_output);

-- BIN_OP_AND_poly1305_h_l57_c5_0935 : 0 clocks latency
BIN_OP_AND_poly1305_h_l57_c5_0935 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l57_c5_0935_left,
BIN_OP_AND_poly1305_h_l57_c5_0935_right,
BIN_OP_AND_poly1305_h_l57_c5_0935_return_output);

-- BIN_OP_AND_poly1305_h_l58_c5_127d : 0 clocks latency
BIN_OP_AND_poly1305_h_l58_c5_127d : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l58_c5_127d_left,
BIN_OP_AND_poly1305_h_l58_c5_127d_right,
BIN_OP_AND_poly1305_h_l58_c5_127d_return_output);

-- BIN_OP_AND_poly1305_h_l59_c5_1ce9 : 0 clocks latency
BIN_OP_AND_poly1305_h_l59_c5_1ce9 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l59_c5_1ce9_left,
BIN_OP_AND_poly1305_h_l59_c5_1ce9_right,
BIN_OP_AND_poly1305_h_l59_c5_1ce9_return_output);

-- BIN_OP_AND_poly1305_h_l60_c5_047c : 0 clocks latency
BIN_OP_AND_poly1305_h_l60_c5_047c : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l60_c5_047c_left,
BIN_OP_AND_poly1305_h_l60_c5_047c_right,
BIN_OP_AND_poly1305_h_l60_c5_047c_return_output);

-- BIN_OP_AND_poly1305_h_l61_c5_c7ad : 0 clocks latency
BIN_OP_AND_poly1305_h_l61_c5_c7ad : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l61_c5_c7ad_left,
BIN_OP_AND_poly1305_h_l61_c5_c7ad_right,
BIN_OP_AND_poly1305_h_l61_c5_c7ad_return_output);

-- BIN_OP_AND_poly1305_h_l62_c5_09ee : 0 clocks latency
BIN_OP_AND_poly1305_h_l62_c5_09ee : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l62_c5_09ee_left,
BIN_OP_AND_poly1305_h_l62_c5_09ee_right,
BIN_OP_AND_poly1305_h_l62_c5_09ee_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 r,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l56_c5_aaaf_return_output,
 BIN_OP_AND_poly1305_h_l57_c5_0935_return_output,
 BIN_OP_AND_poly1305_h_l58_c5_127d_return_output,
 BIN_OP_AND_poly1305_h_l59_c5_1ce9_return_output,
 BIN_OP_AND_poly1305_h_l60_c5_047c_return_output,
 BIN_OP_AND_poly1305_h_l61_c5_c7ad_return_output,
 BIN_OP_AND_poly1305_h_l62_c5_09ee_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u8_16_t;
 variable VAR_r : u8_16_t;
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_e73e_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_aaaf_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_aaaf_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_aaaf_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_852c_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_0935_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_0935_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_0935_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_8bdf_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_127d_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_127d_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_127d_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_8edb_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_1ce9_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_1ce9_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_1ce9_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_1aef_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_047c_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_047c_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_047c_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_4fb3_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_c7ad_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_c7ad_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_c7ad_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_be9d_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_09ee_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_09ee_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_09ee_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_ef25_return_output : u8_16_t;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_AND_poly1305_h_l56_c5_aaaf_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l60_c5_047c_right := to_unsigned(252, 8);
     VAR_BIN_OP_AND_poly1305_h_l62_c5_09ee_right := to_unsigned(252, 8);
     VAR_BIN_OP_AND_poly1305_h_l59_c5_1ce9_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l57_c5_0935_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l58_c5_127d_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l61_c5_c7ad_right := to_unsigned(252, 8);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_r := r;

     -- Submodule level 0
     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d[poly1305_h_l62_c5_be9d] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_be9d_return_output := VAR_r.bytes(12);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d[poly1305_h_l60_c5_1aef] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_1aef_return_output := VAR_r.bytes(4);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d[poly1305_h_l56_c5_e73e] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_e73e_return_output := VAR_r.bytes(3);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d[poly1305_h_l59_c5_8edb] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_8edb_return_output := VAR_r.bytes(15);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d[poly1305_h_l61_c5_4fb3] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_4fb3_return_output := VAR_r.bytes(8);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d[poly1305_h_l58_c5_8bdf] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_8bdf_return_output := VAR_r.bytes(11);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d[poly1305_h_l57_c5_852c] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_852c_return_output := VAR_r.bytes(7);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l58_c5_127d_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_8bdf_return_output;
     VAR_BIN_OP_AND_poly1305_h_l62_c5_09ee_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_be9d_return_output;
     VAR_BIN_OP_AND_poly1305_h_l59_c5_1ce9_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_8edb_return_output;
     VAR_BIN_OP_AND_poly1305_h_l56_c5_aaaf_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_e73e_return_output;
     VAR_BIN_OP_AND_poly1305_h_l60_c5_047c_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_1aef_return_output;
     VAR_BIN_OP_AND_poly1305_h_l57_c5_0935_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_852c_return_output;
     VAR_BIN_OP_AND_poly1305_h_l61_c5_c7ad_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_4fb3_return_output;
     -- BIN_OP_AND[poly1305_h_l59_c5_1ce9] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l59_c5_1ce9_left <= VAR_BIN_OP_AND_poly1305_h_l59_c5_1ce9_left;
     BIN_OP_AND_poly1305_h_l59_c5_1ce9_right <= VAR_BIN_OP_AND_poly1305_h_l59_c5_1ce9_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l59_c5_1ce9_return_output := BIN_OP_AND_poly1305_h_l59_c5_1ce9_return_output;

     -- BIN_OP_AND[poly1305_h_l61_c5_c7ad] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l61_c5_c7ad_left <= VAR_BIN_OP_AND_poly1305_h_l61_c5_c7ad_left;
     BIN_OP_AND_poly1305_h_l61_c5_c7ad_right <= VAR_BIN_OP_AND_poly1305_h_l61_c5_c7ad_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l61_c5_c7ad_return_output := BIN_OP_AND_poly1305_h_l61_c5_c7ad_return_output;

     -- BIN_OP_AND[poly1305_h_l60_c5_047c] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l60_c5_047c_left <= VAR_BIN_OP_AND_poly1305_h_l60_c5_047c_left;
     BIN_OP_AND_poly1305_h_l60_c5_047c_right <= VAR_BIN_OP_AND_poly1305_h_l60_c5_047c_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l60_c5_047c_return_output := BIN_OP_AND_poly1305_h_l60_c5_047c_return_output;

     -- BIN_OP_AND[poly1305_h_l62_c5_09ee] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l62_c5_09ee_left <= VAR_BIN_OP_AND_poly1305_h_l62_c5_09ee_left;
     BIN_OP_AND_poly1305_h_l62_c5_09ee_right <= VAR_BIN_OP_AND_poly1305_h_l62_c5_09ee_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l62_c5_09ee_return_output := BIN_OP_AND_poly1305_h_l62_c5_09ee_return_output;

     -- BIN_OP_AND[poly1305_h_l57_c5_0935] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l57_c5_0935_left <= VAR_BIN_OP_AND_poly1305_h_l57_c5_0935_left;
     BIN_OP_AND_poly1305_h_l57_c5_0935_right <= VAR_BIN_OP_AND_poly1305_h_l57_c5_0935_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l57_c5_0935_return_output := BIN_OP_AND_poly1305_h_l57_c5_0935_return_output;

     -- BIN_OP_AND[poly1305_h_l56_c5_aaaf] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l56_c5_aaaf_left <= VAR_BIN_OP_AND_poly1305_h_l56_c5_aaaf_left;
     BIN_OP_AND_poly1305_h_l56_c5_aaaf_right <= VAR_BIN_OP_AND_poly1305_h_l56_c5_aaaf_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l56_c5_aaaf_return_output := BIN_OP_AND_poly1305_h_l56_c5_aaaf_return_output;

     -- BIN_OP_AND[poly1305_h_l58_c5_127d] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l58_c5_127d_left <= VAR_BIN_OP_AND_poly1305_h_l58_c5_127d_left;
     BIN_OP_AND_poly1305_h_l58_c5_127d_right <= VAR_BIN_OP_AND_poly1305_h_l58_c5_127d_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l58_c5_127d_return_output := BIN_OP_AND_poly1305_h_l58_c5_127d_return_output;

     -- Submodule level 2
     -- CONST_REF_RD_u8_16_t_u8_16_t_be0a[poly1305_h_l63_c12_ef25] LATENCY=0
     VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_ef25_return_output := CONST_REF_RD_u8_16_t_u8_16_t_be0a(
     VAR_r,
     VAR_BIN_OP_AND_poly1305_h_l56_c5_aaaf_return_output,
     VAR_BIN_OP_AND_poly1305_h_l57_c5_0935_return_output,
     VAR_BIN_OP_AND_poly1305_h_l58_c5_127d_return_output,
     VAR_BIN_OP_AND_poly1305_h_l59_c5_1ce9_return_output,
     VAR_BIN_OP_AND_poly1305_h_l60_c5_047c_return_output,
     VAR_BIN_OP_AND_poly1305_h_l61_c5_c7ad_return_output,
     VAR_BIN_OP_AND_poly1305_h_l62_c5_09ee_return_output);

     -- Submodule level 3
     VAR_return_output := VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_ef25_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
