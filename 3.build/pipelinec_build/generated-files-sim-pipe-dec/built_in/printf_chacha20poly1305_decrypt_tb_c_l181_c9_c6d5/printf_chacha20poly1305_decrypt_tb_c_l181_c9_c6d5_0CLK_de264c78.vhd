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
entity printf_chacha20poly1305_decrypt_tb_c_l181_c9_c6d5_0CLK_de264c78 is
port(
 CLOCK_ENABLE : in unsigned(0 downto 0));
end printf_chacha20poly1305_decrypt_tb_c_l181_c9_c6d5_0CLK_de264c78;
architecture arch of printf_chacha20poly1305_decrypt_tb_c_l181_c9_c6d5_0CLK_de264c78 is
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
postponed process(CLOCK_ENABLE) is 
begin

if CLOCK_ENABLE(0) = '1' then
  write(output, "=== ChaCha20-Poly1305 Decryption Test ==="&LF&"");
  --report "=== ChaCha20-Poly1305 Decryption Test ==="&LF&"";
end if;
end postponed process;
-- synthesis translate_on

end arch;
