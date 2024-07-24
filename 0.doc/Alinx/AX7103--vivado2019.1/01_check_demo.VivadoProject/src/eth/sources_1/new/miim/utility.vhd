-- This file is part of the ethernet_mac project.
--
-- For the full copyright and license information, please read the
-- LICENSE.md file that was distributed with this source code.

-- Utility functions

library ieee;
use ieee.std_logic_1164.all;

package utility is
	-- Return the reverse of the given vector
	function reverse_vector(a : in std_ulogic_vector) return std_ulogic_vector;
end package;

package body utility is
	function reverse_vector(a : in std_ulogic_vector) return std_ulogic_vector is
		variable result : std_ulogic_vector(a'range);
		alias aa        : std_ulogic_vector(a'reverse_range) is a;
	begin
		for i in aa'range loop
			result(i) := aa(i);
		end loop;
		return result;
	end function;
end package body;
