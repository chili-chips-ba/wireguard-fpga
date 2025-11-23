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
entity printf_chacha20poly1305_decrypt_tb_c_l48_c5_5045_0CLK_de264c78 is
port(
 CLOCK_ENABLE : in unsigned(0 downto 0);
 arg0 : in unsigned(31 downto 0);
 arg1 : in unsigned(7 downto 0);
 arg2 : in unsigned(7 downto 0);
 arg3 : in unsigned(7 downto 0);
 arg4 : in unsigned(7 downto 0);
 arg5 : in unsigned(7 downto 0);
 arg6 : in unsigned(7 downto 0);
 arg7 : in unsigned(7 downto 0);
 arg8 : in unsigned(7 downto 0);
 arg9 : in unsigned(7 downto 0);
 arg10 : in unsigned(7 downto 0);
 arg11 : in unsigned(7 downto 0);
 arg12 : in unsigned(7 downto 0);
 arg13 : in unsigned(7 downto 0);
 arg14 : in unsigned(7 downto 0);
 arg15 : in unsigned(7 downto 0);
 arg16 : in unsigned(7 downto 0);
 arg17 : in unsigned(7 downto 0);
 arg18 : in unsigned(7 downto 0);
 arg19 : in unsigned(7 downto 0);
 arg20 : in unsigned(7 downto 0);
 arg21 : in unsigned(7 downto 0);
 arg22 : in unsigned(7 downto 0);
 arg23 : in unsigned(7 downto 0);
 arg24 : in unsigned(7 downto 0);
 arg25 : in unsigned(7 downto 0);
 arg26 : in unsigned(7 downto 0);
 arg27 : in unsigned(7 downto 0);
 arg28 : in unsigned(7 downto 0);
 arg29 : in unsigned(7 downto 0);
 arg30 : in unsigned(7 downto 0);
 arg31 : in unsigned(7 downto 0);
 arg32 : in unsigned(7 downto 0));
end printf_chacha20poly1305_decrypt_tb_c_l48_c5_5045_0CLK_de264c78;
architecture arch of printf_chacha20poly1305_decrypt_tb_c_l48_c5_5045_0CLK_de264c78 is
  function to_string(bytes : byte_array_t) return string is
    variable rv : string(1 to bytes'length) := (others => NUL);
  begin
    for i in 0 to bytes'length -1 loop
      rv(i+1) := character'val(to_integer(bytes(i)));
    end loop;
    return rv;
  end function;
  
begin
-- synthesis translate_off
-- Postponed so only prints once?
postponed process(CLOCK_ENABLE,
 arg0,
 arg1,
 arg2,
 arg3,
 arg4,
 arg5,
 arg6,
 arg7,
 arg8,
 arg9,
 arg10,
 arg11,
 arg12,
 arg13,
 arg14,
 arg15,
 arg16,
 arg17,
 arg18,
 arg19,
 arg20,
 arg21,
 arg22,
 arg23,
 arg24,
 arg25,
 arg26,
 arg27,
 arg28,
 arg29,
 arg30,
 arg31,
 arg32) is 
begin

if CLOCK_ENABLE(0) = '1' then
  write(output, "AAD ("&integer'image(to_integer(arg0))&" bytes): "&character'val(to_integer(arg1))&""&character'val(to_integer(arg2))&""&character'val(to_integer(arg3))&""&character'val(to_integer(arg4))&""&character'val(to_integer(arg5))&""&character'val(to_integer(arg6))&""&character'val(to_integer(arg7))&""&character'val(to_integer(arg8))&""&character'val(to_integer(arg9))&""&character'val(to_integer(arg10))&""&character'val(to_integer(arg11))&""&character'val(to_integer(arg12))&""&character'val(to_integer(arg13))&""&character'val(to_integer(arg14))&""&character'val(to_integer(arg15))&""&character'val(to_integer(arg16))&""&character'val(to_integer(arg17))&""&character'val(to_integer(arg18))&""&character'val(to_integer(arg19))&""&character'val(to_integer(arg20))&""&character'val(to_integer(arg21))&""&character'val(to_integer(arg22))&""&character'val(to_integer(arg23))&""&character'val(to_integer(arg24))&""&character'val(to_integer(arg25))&""&character'val(to_integer(arg26))&""&character'val(to_integer(arg27))&""&character'val(to_integer(arg28))&""&character'val(to_integer(arg29))&""&character'val(to_integer(arg30))&""&character'val(to_integer(arg31))&""&character'val(to_integer(arg32))&""&LF&"");
  --report "AAD ("&integer'image(to_integer(arg0))&" bytes): "&character'val(to_integer(arg1))&""&character'val(to_integer(arg2))&""&character'val(to_integer(arg3))&""&character'val(to_integer(arg4))&""&character'val(to_integer(arg5))&""&character'val(to_integer(arg6))&""&character'val(to_integer(arg7))&""&character'val(to_integer(arg8))&""&character'val(to_integer(arg9))&""&character'val(to_integer(arg10))&""&character'val(to_integer(arg11))&""&character'val(to_integer(arg12))&""&character'val(to_integer(arg13))&""&character'val(to_integer(arg14))&""&character'val(to_integer(arg15))&""&character'val(to_integer(arg16))&""&character'val(to_integer(arg17))&""&character'val(to_integer(arg18))&""&character'val(to_integer(arg19))&""&character'val(to_integer(arg20))&""&character'val(to_integer(arg21))&""&character'val(to_integer(arg22))&""&character'val(to_integer(arg23))&""&character'val(to_integer(arg24))&""&character'val(to_integer(arg25))&""&character'val(to_integer(arg26))&""&character'val(to_integer(arg27))&""&character'val(to_integer(arg28))&""&character'val(to_integer(arg29))&""&character'val(to_integer(arg30))&""&character'val(to_integer(arg31))&""&character'val(to_integer(arg32))&""&LF&"";
end if;
end postponed process;
-- synthesis translate_on

end arch;
