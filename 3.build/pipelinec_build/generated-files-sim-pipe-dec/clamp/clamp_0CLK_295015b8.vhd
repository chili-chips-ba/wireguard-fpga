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
-- BIN_OP_AND[poly1305_h_l56_c5_a722]
signal BIN_OP_AND_poly1305_h_l56_c5_a722_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l56_c5_a722_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l56_c5_a722_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l57_c5_5791]
signal BIN_OP_AND_poly1305_h_l57_c5_5791_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l57_c5_5791_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l57_c5_5791_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l58_c5_e092]
signal BIN_OP_AND_poly1305_h_l58_c5_e092_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l58_c5_e092_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l58_c5_e092_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l59_c5_eb83]
signal BIN_OP_AND_poly1305_h_l59_c5_eb83_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l59_c5_eb83_right : unsigned(3 downto 0);
signal BIN_OP_AND_poly1305_h_l59_c5_eb83_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l60_c5_868c]
signal BIN_OP_AND_poly1305_h_l60_c5_868c_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l60_c5_868c_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l60_c5_868c_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l61_c5_9b9a]
signal BIN_OP_AND_poly1305_h_l61_c5_9b9a_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l61_c5_9b9a_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l61_c5_9b9a_return_output : unsigned(7 downto 0);

-- BIN_OP_AND[poly1305_h_l62_c5_c25f]
signal BIN_OP_AND_poly1305_h_l62_c5_c25f_left : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l62_c5_c25f_right : unsigned(7 downto 0);
signal BIN_OP_AND_poly1305_h_l62_c5_c25f_return_output : unsigned(7 downto 0);

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
-- BIN_OP_AND_poly1305_h_l56_c5_a722 : 0 clocks latency
BIN_OP_AND_poly1305_h_l56_c5_a722 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l56_c5_a722_left,
BIN_OP_AND_poly1305_h_l56_c5_a722_right,
BIN_OP_AND_poly1305_h_l56_c5_a722_return_output);

-- BIN_OP_AND_poly1305_h_l57_c5_5791 : 0 clocks latency
BIN_OP_AND_poly1305_h_l57_c5_5791 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l57_c5_5791_left,
BIN_OP_AND_poly1305_h_l57_c5_5791_right,
BIN_OP_AND_poly1305_h_l57_c5_5791_return_output);

-- BIN_OP_AND_poly1305_h_l58_c5_e092 : 0 clocks latency
BIN_OP_AND_poly1305_h_l58_c5_e092 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l58_c5_e092_left,
BIN_OP_AND_poly1305_h_l58_c5_e092_right,
BIN_OP_AND_poly1305_h_l58_c5_e092_return_output);

-- BIN_OP_AND_poly1305_h_l59_c5_eb83 : 0 clocks latency
BIN_OP_AND_poly1305_h_l59_c5_eb83 : entity work.BIN_OP_AND_uint8_t_uint4_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l59_c5_eb83_left,
BIN_OP_AND_poly1305_h_l59_c5_eb83_right,
BIN_OP_AND_poly1305_h_l59_c5_eb83_return_output);

-- BIN_OP_AND_poly1305_h_l60_c5_868c : 0 clocks latency
BIN_OP_AND_poly1305_h_l60_c5_868c : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l60_c5_868c_left,
BIN_OP_AND_poly1305_h_l60_c5_868c_right,
BIN_OP_AND_poly1305_h_l60_c5_868c_return_output);

-- BIN_OP_AND_poly1305_h_l61_c5_9b9a : 0 clocks latency
BIN_OP_AND_poly1305_h_l61_c5_9b9a : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l61_c5_9b9a_left,
BIN_OP_AND_poly1305_h_l61_c5_9b9a_right,
BIN_OP_AND_poly1305_h_l61_c5_9b9a_return_output);

-- BIN_OP_AND_poly1305_h_l62_c5_c25f : 0 clocks latency
BIN_OP_AND_poly1305_h_l62_c5_c25f : entity work.BIN_OP_AND_uint8_t_uint8_t_0CLK_de264c78 port map (
BIN_OP_AND_poly1305_h_l62_c5_c25f_left,
BIN_OP_AND_poly1305_h_l62_c5_c25f_right,
BIN_OP_AND_poly1305_h_l62_c5_c25f_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 r,
 -- All submodule outputs
 BIN_OP_AND_poly1305_h_l56_c5_a722_return_output,
 BIN_OP_AND_poly1305_h_l57_c5_5791_return_output,
 BIN_OP_AND_poly1305_h_l58_c5_e092_return_output,
 BIN_OP_AND_poly1305_h_l59_c5_eb83_return_output,
 BIN_OP_AND_poly1305_h_l60_c5_868c_return_output,
 BIN_OP_AND_poly1305_h_l61_c5_9b9a_return_output,
 BIN_OP_AND_poly1305_h_l62_c5_c25f_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : u8_16_t;
 variable VAR_r : u8_16_t;
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_1d75_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_a722_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_a722_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l56_c5_a722_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_2b06_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_5791_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_5791_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l57_c5_5791_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_f780_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_e092_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_e092_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l58_c5_e092_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_0a15_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_eb83_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_eb83_right : unsigned(3 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l59_c5_eb83_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_02a0_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_868c_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_868c_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l60_c5_868c_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_6783_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_9b9a_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_9b9a_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l61_c5_9b9a_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_54ce_return_output : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_c25f_left : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_c25f_right : unsigned(7 downto 0);
 variable VAR_BIN_OP_AND_poly1305_h_l62_c5_c25f_return_output : unsigned(7 downto 0);
 variable VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_0675_return_output : u8_16_t;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_BIN_OP_AND_poly1305_h_l62_c5_c25f_right := to_unsigned(252, 8);
     VAR_BIN_OP_AND_poly1305_h_l59_c5_eb83_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l57_c5_5791_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l58_c5_e092_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l56_c5_a722_right := to_unsigned(15, 4);
     VAR_BIN_OP_AND_poly1305_h_l61_c5_9b9a_right := to_unsigned(252, 8);
     VAR_BIN_OP_AND_poly1305_h_l60_c5_868c_right := to_unsigned(252, 8);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_r := r;

     -- Submodule level 0
     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d[poly1305_h_l60_c5_02a0] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_02a0_return_output := VAR_r.bytes(4);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d[poly1305_h_l58_c5_f780] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_f780_return_output := VAR_r.bytes(11);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d[poly1305_h_l57_c5_2b06] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_2b06_return_output := VAR_r.bytes(7);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d[poly1305_h_l59_c5_0a15] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_0a15_return_output := VAR_r.bytes(15);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d[poly1305_h_l62_c5_54ce] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_54ce_return_output := VAR_r.bytes(12);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d[poly1305_h_l56_c5_1d75] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_1d75_return_output := VAR_r.bytes(3);

     -- CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d[poly1305_h_l61_c5_6783] LATENCY=0
     VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_6783_return_output := VAR_r.bytes(8);

     -- Submodule level 1
     VAR_BIN_OP_AND_poly1305_h_l58_c5_e092_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_11_d41d_poly1305_h_l58_c5_f780_return_output;
     VAR_BIN_OP_AND_poly1305_h_l62_c5_c25f_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_12_d41d_poly1305_h_l62_c5_54ce_return_output;
     VAR_BIN_OP_AND_poly1305_h_l59_c5_eb83_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_15_d41d_poly1305_h_l59_c5_0a15_return_output;
     VAR_BIN_OP_AND_poly1305_h_l56_c5_a722_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_3_d41d_poly1305_h_l56_c5_1d75_return_output;
     VAR_BIN_OP_AND_poly1305_h_l60_c5_868c_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_4_d41d_poly1305_h_l60_c5_02a0_return_output;
     VAR_BIN_OP_AND_poly1305_h_l57_c5_5791_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_7_d41d_poly1305_h_l57_c5_2b06_return_output;
     VAR_BIN_OP_AND_poly1305_h_l61_c5_9b9a_left := VAR_CONST_REF_RD_uint8_t_u8_16_t_bytes_8_d41d_poly1305_h_l61_c5_6783_return_output;
     -- BIN_OP_AND[poly1305_h_l61_c5_9b9a] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l61_c5_9b9a_left <= VAR_BIN_OP_AND_poly1305_h_l61_c5_9b9a_left;
     BIN_OP_AND_poly1305_h_l61_c5_9b9a_right <= VAR_BIN_OP_AND_poly1305_h_l61_c5_9b9a_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l61_c5_9b9a_return_output := BIN_OP_AND_poly1305_h_l61_c5_9b9a_return_output;

     -- BIN_OP_AND[poly1305_h_l56_c5_a722] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l56_c5_a722_left <= VAR_BIN_OP_AND_poly1305_h_l56_c5_a722_left;
     BIN_OP_AND_poly1305_h_l56_c5_a722_right <= VAR_BIN_OP_AND_poly1305_h_l56_c5_a722_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l56_c5_a722_return_output := BIN_OP_AND_poly1305_h_l56_c5_a722_return_output;

     -- BIN_OP_AND[poly1305_h_l59_c5_eb83] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l59_c5_eb83_left <= VAR_BIN_OP_AND_poly1305_h_l59_c5_eb83_left;
     BIN_OP_AND_poly1305_h_l59_c5_eb83_right <= VAR_BIN_OP_AND_poly1305_h_l59_c5_eb83_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l59_c5_eb83_return_output := BIN_OP_AND_poly1305_h_l59_c5_eb83_return_output;

     -- BIN_OP_AND[poly1305_h_l58_c5_e092] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l58_c5_e092_left <= VAR_BIN_OP_AND_poly1305_h_l58_c5_e092_left;
     BIN_OP_AND_poly1305_h_l58_c5_e092_right <= VAR_BIN_OP_AND_poly1305_h_l58_c5_e092_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l58_c5_e092_return_output := BIN_OP_AND_poly1305_h_l58_c5_e092_return_output;

     -- BIN_OP_AND[poly1305_h_l60_c5_868c] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l60_c5_868c_left <= VAR_BIN_OP_AND_poly1305_h_l60_c5_868c_left;
     BIN_OP_AND_poly1305_h_l60_c5_868c_right <= VAR_BIN_OP_AND_poly1305_h_l60_c5_868c_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l60_c5_868c_return_output := BIN_OP_AND_poly1305_h_l60_c5_868c_return_output;

     -- BIN_OP_AND[poly1305_h_l62_c5_c25f] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l62_c5_c25f_left <= VAR_BIN_OP_AND_poly1305_h_l62_c5_c25f_left;
     BIN_OP_AND_poly1305_h_l62_c5_c25f_right <= VAR_BIN_OP_AND_poly1305_h_l62_c5_c25f_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l62_c5_c25f_return_output := BIN_OP_AND_poly1305_h_l62_c5_c25f_return_output;

     -- BIN_OP_AND[poly1305_h_l57_c5_5791] LATENCY=0
     -- Inputs
     BIN_OP_AND_poly1305_h_l57_c5_5791_left <= VAR_BIN_OP_AND_poly1305_h_l57_c5_5791_left;
     BIN_OP_AND_poly1305_h_l57_c5_5791_right <= VAR_BIN_OP_AND_poly1305_h_l57_c5_5791_right;
     -- Outputs
     VAR_BIN_OP_AND_poly1305_h_l57_c5_5791_return_output := BIN_OP_AND_poly1305_h_l57_c5_5791_return_output;

     -- Submodule level 2
     -- CONST_REF_RD_u8_16_t_u8_16_t_be0a[poly1305_h_l63_c12_0675] LATENCY=0
     VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_0675_return_output := CONST_REF_RD_u8_16_t_u8_16_t_be0a(
     VAR_r,
     VAR_BIN_OP_AND_poly1305_h_l56_c5_a722_return_output,
     VAR_BIN_OP_AND_poly1305_h_l57_c5_5791_return_output,
     VAR_BIN_OP_AND_poly1305_h_l58_c5_e092_return_output,
     VAR_BIN_OP_AND_poly1305_h_l59_c5_eb83_return_output,
     VAR_BIN_OP_AND_poly1305_h_l60_c5_868c_return_output,
     VAR_BIN_OP_AND_poly1305_h_l61_c5_9b9a_return_output,
     VAR_BIN_OP_AND_poly1305_h_l62_c5_c25f_return_output);

     -- Submodule level 3
     VAR_return_output := VAR_CONST_REF_RD_u8_16_t_u8_16_t_be0a_poly1305_h_l63_c12_0675_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
