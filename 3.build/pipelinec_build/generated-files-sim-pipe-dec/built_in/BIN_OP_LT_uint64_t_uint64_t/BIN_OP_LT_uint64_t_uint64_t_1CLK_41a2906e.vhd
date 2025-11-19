-- Timing params:
--   Fixed?: False
--   Pipeline Slices: [0.7489757914338914]
--   Input regs?: False
--   Output regs?: False
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.c_structs_pkg.all;
-- Submodules: 3
entity BIN_OP_LT_uint64_t_uint64_t_1CLK_41a2906e is
port(
 clk : in std_logic;
 left : in unsigned(63 downto 0);
 right : in unsigned(63 downto 0);
 return_output : out unsigned(0 downto 0));
end BIN_OP_LT_uint64_t_uint64_t_1CLK_41a2906e;
architecture arch of BIN_OP_LT_uint64_t_uint64_t_1CLK_41a2906e is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 1;
-- All of the wires/regs in function
-- Stage 0
-- Each function instance gets signals
-- BIN_OP_MINUS[BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc]
signal BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_left : signed(64 downto 0);
signal BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_right : signed(64 downto 0);
signal BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_return_output : signed(65 downto 0);

function CAST_TO_int65_t_uint64_t( rhs : unsigned) return signed is

  --variable rhs : unsigned(63 downto 0);
  variable return_output : signed(64 downto 0);

begin

      return_output := signed(std_logic_vector(resize(rhs,65)));
    return return_output;
end function;

function int65_64_64( x : signed) return unsigned is
--variable x : signed(64 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(64- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc : 1 clocks latency
BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc : entity work.BIN_OP_MINUS_int65_t_int65_t_1CLK_9ca18c4f port map (
clk,
BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_left,
BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_right,
BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- Registers
 -- Stage 0
 -- All submodule outputs
 BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(63 downto 0);
 variable VAR_right : unsigned(63 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_left_bot : unsigned(63 downto 0);
 variable VAR_right_bot : unsigned(63 downto 0);
 variable VAR_right_bot_BIN_OP_LT_uint64_t_uint64_t_c_l10_c14_7e77_0 : unsigned(63 downto 0);
 variable VAR_rv : unsigned(0 downto 0);
 variable VAR_sub : signed(64 downto 0);
 variable VAR_sub_BIN_OP_LT_uint64_t_uint64_t_c_l14_c13_aa04_0 : signed(64 downto 0);
 variable VAR_CAST_TO_int65_t_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_7baf_return_output : signed(64 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_left : signed(64 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_right : signed(64 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_return_output : signed(65 downto 0);
 variable VAR_lt_zero : unsigned(0 downto 0);
 variable VAR_int65_64_64_BIN_OP_LT_uint64_t_uint64_t_c_l15_c23_8a57_return_output : unsigned(0 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_right_bot_BIN_OP_LT_uint64_t_uint64_t_c_l10_c14_7e77_0 := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_right := signed(std_logic_vector(resize(VAR_right_bot_BIN_OP_LT_uint64_t_uint64_t_c_l10_c14_7e77_0, 65)));
     -- CAST_TO_int65_t[BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_7baf] LATENCY=0
     VAR_CAST_TO_int65_t_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_7baf_return_output := CAST_TO_int65_t_uint64_t(
     VAR_left);

     -- Submodule level 1
     VAR_BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_left := VAR_CAST_TO_int65_t_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_7baf_return_output;
     -- BIN_OP_MINUS[BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc] LATENCY=1
     -- Inputs
     BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_left <= VAR_BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_left;
     BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_right <= VAR_BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_right;

     -- Write to comb signals
   elsif STAGE = 1 then
     -- Read from prev stage
     -- Submodule outputs
     VAR_BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_return_output := BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_return_output;

     -- Submodule level 0
     VAR_sub_BIN_OP_LT_uint64_t_uint64_t_c_l14_c13_aa04_0 := resize(VAR_BIN_OP_MINUS_BIN_OP_LT_uint64_t_uint64_t_c_l14_c19_45fc_return_output, 65);
     -- int65_64_64[BIN_OP_LT_uint64_t_uint64_t_c_l15_c23_8a57] LATENCY=0
     VAR_int65_64_64_BIN_OP_LT_uint64_t_uint64_t_c_l15_c23_8a57_return_output := int65_64_64(
     VAR_sub_BIN_OP_LT_uint64_t_uint64_t_c_l14_c13_aa04_0);

     -- Submodule level 1
     VAR_return_output := VAR_int65_64_64_BIN_OP_LT_uint64_t_uint64_t_c_l15_c23_8a57_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
     -- Stage 0
 end if;
end process;

end arch;
