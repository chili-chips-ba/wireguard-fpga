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
-- BIN_OP_AND[poly1305_h_l56_c5_9a48]
signal BIN_OP_AND_poly1305_h_l56_c5_9a48_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l56_c5_9a48_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l56_c5_9a48_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l57_c5_2fd8]
signal BIN_OP_AND_poly1305_h_l57_c5_2fd8_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l57_c5_2fd8_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l57_c5_2fd8_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l58_c5_4ff6]
signal BIN_OP_AND_poly1305_h_l58_c5_4ff6_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l58_c5_4ff6_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l58_c5_4ff6_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l59_c5_8e70]
signal BIN_OP_AND_poly1305_h_l59_c5_8e70_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l59_c5_8e70_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l59_c5_8e70_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l60_c5_05fa]
signal BIN_OP_AND_poly1305_h_l60_c5_05fa_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l60_c5_05fa_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l60_c5_05fa_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l61_c5_4e5f]
signal BIN_OP_AND_poly1305_h_l61_c5_4e5f_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l61_c5_4e5f_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l61_c5_4e5f_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l62_c5_2a49]
signal BIN_OP_AND_poly1305_h_l62_c5_2a49_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l62_c5_2a49_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l62_c5_2a49_return_output : unsigned(7 downto 0);

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
-- BIN_OP_AND_poly1305_h_l56_c5_9a48 : 0 clocks latency
BIN_OP_AND_poly1305_h_l56_c5_9a48 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l56_c5_9a48_left,
BIN_OP_AND_poly1305_h_l56_c5_9a48_right,
BIN_OP_AND_poly1305_h_l56_c5_9a48_return_output);

-- BIN_OP_AND_poly1305_h_l57_c5_2fd8 : 0 clocks latency
BIN_OP_AND_poly1305_h_l57_c5_2fd8 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l57_c5_2fd8_left,
BIN_OP_AND_poly1305_h_l57_c5_2fd8_right,
BIN_OP_AND_poly1305_h_l57_c5_2fd8_return_output);

-- BIN_OP_AND_poly1305_h_l58_c5_4ff6 : 0 clocks latency
BIN_OP_AND_poly1305_h_l58_c5_4ff6 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l58_c5_4ff6_left,
BIN_OP_AND_poly1305_h_l58_c5_4ff6_right,
BIN_OP_AND_poly1305_h_l58_c5_4ff6_return_output);

-- BIN_OP_AND_poly1305_h_l59_c5_8e70 : 0 clocks latency
BIN_OP_AND_poly1305_h_l59_c5_8e70 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l59_c5_8e70_left,
BIN_OP_AND_poly1305_h_l59_c5_8e70_right,
BIN_OP_AND_poly1305_h_l59_c5_8e70_return_output);

-- BIN_OP_AND_poly1305_h_l60_c5_05fa : 0 clocks latency
BIN_OP_AND_poly1305_h_l60_c5_05fa : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l60_c5_05fa_left,
BIN_OP_AND_poly1305_h_l60_c5_05fa_right,
BIN_OP_AND_poly1305_h_l60_c5_05fa_return_output);

-- BIN_OP_AND_poly1305_h_l61_c5_4e5f : 0 clocks latency
BIN_OP_AND_poly1305_h_l61_c5_4e5f : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l61_c5_4e5f_left,
BIN_OP_AND_poly1305_h_l61_c5_4e5f_right,
BIN_OP_AND_poly1305_h_l61_c5_4e5f_return_output);

-- BIN_OP_AND_poly1305_h_l62_c5_2a49 : 0 clocks latency
BIN_OP_AND_poly1305_h_l62_c5_2a49 : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l62_c5_2a49_left,
BIN_OP_AND_poly1305_h_l62_c5_2a49_right,
BIN_OP_AND_poly1305_h_l62_c5_2a49_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 r,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l56_c5_9a48_return_output,
 BIN_OP_AND_poly1305_h_l57_c5_2fd8_return_output,
 BIN_OP_AND_poly1305_h_l58_c5_4ff6_return_output,
 BIN_OP_AND_poly1305_h_l59_c5_8e70_return_output,
 BIN_OP_AND_poly1305_h_l60_c5_05fa_return_output,
 BIN_OP_AND_poly1305_h_l61_c5_4e5f_return_output,
 BIN_OP_AND_poly1305_h_l62_c5_2a49_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u8_16_t;
 variable VAR_r : u8_16_t;
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_1e99_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_9a48_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_9a48_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_9a48_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_f67f_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_2fd8_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_2fd8_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_2fd8_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_ed98_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_4ff6_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_4ff6_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_4ff6_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_db3e_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_8e70_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_8e70_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_8e70_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_00b9_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_05fa_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_05fa_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_05fa_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_3019_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_4e5f_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_4e5f_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_4e5f_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_dde5_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_2a49_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_2a49_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_2a49_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_9e8a_return_output : u8_16_t;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_AND_poly1305_h_l57_c5_2fd8_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l59_c5_8e70_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l56_c5_9a48_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l60_c5_05fa_right := to_unsigned(252, 8);
     VAR_BIN_OP_AND_poly1305_h_l58_c5_4ff6_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l62_c5_2a49_right := to_unsigned(252, 8);
     VAR_BIN_OP_AND_poly1305_h_l61_c5_4e5f_right := to_unsigned(252, 8);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_r := r;

     -- Submodule level 0
     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d[poly1305_h_l62_c5_dde5] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_dde5_return_output := VAR_r.bytes(12);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d[poly1305_h_l59_c5_db3e] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_db3e_return_output := VAR_r.bytes(15);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d[poly1305_h_l60_c5_00b9] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_00b9_return_output := VAR_r.bytes(4);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d[poly1305_h_l61_c5_3019] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_3019_return_output := VAR_r.bytes(8);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d[poly1305_h_l58_c5_ed98] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_ed98_return_output := VAR_r.bytes(11);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d[poly1305_h_l56_c5_1e99] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_1e99_return_output := VAR_r.bytes(3);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d[poly1305_h_l57_c5_f67f] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_f67f_return_output := VAR_r.bytes(7);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l58_c5_4ff6_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_ed98_return_output;
     VAR_BIN_OP_AND_poly1305_h_l62_c5_2a49_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_dde5_return_output;
     VAR_BIN_OP_AND_poly1305_h_l59_c5_8e70_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_db3e_return_output;
     VAR_BIN_OP_AND_poly1305_h_l56_c5_9a48_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_1e99_return_output;
     VAR_BIN_OP_AND_poly1305_h_l60_c5_05fa_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_00b9_return_output;
     VAR_BIN_OP_AND_poly1305_h_l57_c5_2fd8_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_f67f_return_output;
     VAR_BIN_OP_AND_poly1305_h_l61_c5_4e5f_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_3019_return_output;
     -- BIN_OP_AND[poly1305_h_l57_c5_2fd8] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l57_c5_2fd8_left <= VAR_BIN_OP_AND_poly1305_h_l57_c5_2fd8_left;
     BIN_OP_AND_poly1305_h_l57_c5_2fd8_right <= VAR_BIN_OP_AND_poly1305_h_l57_c5_2fd8_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l57_c5_2fd8_return_output := BIN_OP_AND_poly1305_h_l57_c5_2fd8_return_output;

     -- BIN_OP_AND[poly1305_h_l61_c5_4e5f] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l61_c5_4e5f_left <= VAR_BIN_OP_AND_poly1305_h_l61_c5_4e5f_left;
     BIN_OP_AND_poly1305_h_l61_c5_4e5f_right <= VAR_BIN_OP_AND_poly1305_h_l61_c5_4e5f_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l61_c5_4e5f_return_output := BIN_OP_AND_poly1305_h_l61_c5_4e5f_return_output;

     -- BIN_OP_AND[poly1305_h_l56_c5_9a48] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l56_c5_9a48_left <= VAR_BIN_OP_AND_poly1305_h_l56_c5_9a48_left;
     BIN_OP_AND_poly1305_h_l56_c5_9a48_right <= VAR_BIN_OP_AND_poly1305_h_l56_c5_9a48_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l56_c5_9a48_return_output := BIN_OP_AND_poly1305_h_l56_c5_9a48_return_output;

     -- BIN_OP_AND[poly1305_h_l62_c5_2a49] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l62_c5_2a49_left <= VAR_BIN_OP_AND_poly1305_h_l62_c5_2a49_left;
     BIN_OP_AND_poly1305_h_l62_c5_2a49_right <= VAR_BIN_OP_AND_poly1305_h_l62_c5_2a49_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l62_c5_2a49_return_output := BIN_OP_AND_poly1305_h_l62_c5_2a49_return_output;

     -- BIN_OP_AND[poly1305_h_l58_c5_4ff6] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l58_c5_4ff6_left <= VAR_BIN_OP_AND_poly1305_h_l58_c5_4ff6_left;
     BIN_OP_AND_poly1305_h_l58_c5_4ff6_right <= VAR_BIN_OP_AND_poly1305_h_l58_c5_4ff6_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l58_c5_4ff6_return_output := BIN_OP_AND_poly1305_h_l58_c5_4ff6_return_output;

     -- BIN_OP_AND[poly1305_h_l59_c5_8e70] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l59_c5_8e70_left <= VAR_BIN_OP_AND_poly1305_h_l59_c5_8e70_left;
     BIN_OP_AND_poly1305_h_l59_c5_8e70_right <= VAR_BIN_OP_AND_poly1305_h_l59_c5_8e70_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l59_c5_8e70_return_output := BIN_OP_AND_poly1305_h_l59_c5_8e70_return_output;

     -- BIN_OP_AND[poly1305_h_l60_c5_05fa] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l60_c5_05fa_left <= VAR_BIN_OP_AND_poly1305_h_l60_c5_05fa_left;
     BIN_OP_AND_poly1305_h_l60_c5_05fa_right <= VAR_BIN_OP_AND_poly1305_h_l60_c5_05fa_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l60_c5_05fa_return_output := BIN_OP_AND_poly1305_h_l60_c5_05fa_return_output;

     -- Submodule level 2
     -- CONST_REF_RD_u8_16_t_u8_16_t_be0a[poly1305_h_l63_c12_9e8a] LATENCY=0
     VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_9e8a_return_output := CONST_REF_RD_u8_16_t_u8_16_t_be0a(
     VAR_r,
     VAR_BIN_OP_AND_poly1305_h_l56_c5_9a48_return_output,
     VAR_BIN_OP_AND_poly1305_h_l57_c5_2fd8_return_output,
     VAR_BIN_OP_AND_poly1305_h_l58_c5_4ff6_return_output,
     VAR_BIN_OP_AND_poly1305_h_l59_c5_8e70_return_output,
     VAR_BIN_OP_AND_poly1305_h_l60_c5_05fa_return_output,
     VAR_BIN_OP_AND_poly1305_h_l61_c5_4e5f_return_output,
     VAR_BIN_OP_AND_poly1305_h_l62_c5_2a49_return_output);

     -- Submodule level 3
     VAR_return_output := VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_9e8a_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
