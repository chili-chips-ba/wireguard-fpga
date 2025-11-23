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
-- Submodules: 160
entity BIN_OP_MOD_uint32_t_uint5_t_0CLK_29b254e4 is
port(
 left : in unsigned(31 downto 0);
 right : in unsigned(4 downto 0);
 return_output : out unsigned(4 downto 0));
end BIN_OP_MOD_uint32_t_uint5_t_0CLK_29b254e4;
architecture arch of BIN_OP_MOD_uint32_t_uint5_t_0CLK_29b254e4 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_return_output : unsigned(31 downto 0);

-- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001]
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_left : unsigned(31 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_right : unsigned(4 downto 0);
signal BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_return_output : unsigned(0 downto 0);

-- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f]
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_cond : unsigned(0 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iftrue : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iffalse : unsigned(31 downto 0);
signal remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_return_output : unsigned(31 downto 0);

-- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d]
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_left : unsigned(31 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_right : unsigned(4 downto 0);
signal BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_return_output : unsigned(31 downto 0);

function uint32_31_31( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(31- i);
      end loop;
return return_output;
end function;

function uint32_uint1( x : unsigned;
 y : unsigned) return unsigned is

  --variable x : unsigned(31 downto 0);
  --variable y : unsigned(0 downto 0);
  variable return_output : unsigned(32 downto 0);

begin

    return_output := unsigned(std_logic_vector(x)) & unsigned(std_logic_vector(y));
    return return_output;

end function;

function uint32_30_30( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(30- i);
      end loop;
return return_output;
end function;

function uint32_29_29( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(29- i);
      end loop;
return return_output;
end function;

function uint32_28_28( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(28- i);
      end loop;
return return_output;
end function;

function uint32_27_27( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(27- i);
      end loop;
return return_output;
end function;

function uint32_26_26( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(26- i);
      end loop;
return return_output;
end function;

function uint32_25_25( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(25- i);
      end loop;
return return_output;
end function;

function uint32_24_24( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(24- i);
      end loop;
return return_output;
end function;

function uint32_23_23( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(23- i);
      end loop;
return return_output;
end function;

function uint32_22_22( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(22- i);
      end loop;
return return_output;
end function;

function uint32_21_21( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(21- i);
      end loop;
return return_output;
end function;

function uint32_20_20( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(20- i);
      end loop;
return return_output;
end function;

function uint32_19_19( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(19- i);
      end loop;
return return_output;
end function;

function uint32_18_18( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(18- i);
      end loop;
return return_output;
end function;

function uint32_17_17( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(17- i);
      end loop;
return return_output;
end function;

function uint32_16_16( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(16- i);
      end loop;
return return_output;
end function;

function uint32_15_15( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(15- i);
      end loop;
return return_output;
end function;

function uint32_14_14( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(14- i);
      end loop;
return return_output;
end function;

function uint32_13_13( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(13- i);
      end loop;
return return_output;
end function;

function uint32_12_12( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(12- i);
      end loop;
return return_output;
end function;

function uint32_11_11( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(11- i);
      end loop;
return return_output;
end function;

function uint32_10_10( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(10- i);
      end loop;
return return_output;
end function;

function uint32_9_9( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(9- i);
      end loop;
return return_output;
end function;

function uint32_8_8( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(8- i);
      end loop;
return return_output;
end function;

function uint32_7_7( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(7- i);
      end loop;
return return_output;
end function;

function uint32_6_6( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(6- i);
      end loop;
return return_output;
end function;

function uint32_5_5( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(5- i);
      end loop;
return return_output;
end function;

function uint32_4_4( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(4- i);
      end loop;
return return_output;
end function;

function uint32_3_3( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(3- i);
      end loop;
return return_output;
end function;

function uint32_2_2( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(2- i);
      end loop;
return return_output;
end function;

function uint32_1_1( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(1- i);
      end loop;
return return_output;
end function;

function uint32_0_0( x : unsigned) return unsigned is
--variable x : unsigned(31 downto 0);
  variable return_output : unsigned(0 downto 0);
begin
for i in 0 to return_output'length-1 loop
        return_output(i) := x(0- i);
      end loop;
return return_output;
end function;


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37 : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37 : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9 : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9 : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_return_output);

-- BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001 : 0 clocks latency
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001 : entity work.BIN_OP_GTE_uint32_t_uint5_t_0CLK_e595f783 port map (
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_left,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_right,
BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_return_output);

-- remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f : 0 clocks latency
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f : entity work.MUX_uint1_t_uint32_t_uint32_t_0CLK_de264c78 port map (
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_cond,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iftrue,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iffalse,
remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_return_output);

-- BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d : 0 clocks latency
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d : entity work.BIN_OP_MINUS_uint32_t_uint5_t_0CLK_de264c78 port map (
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_left,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_right,
BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 left,
 right,
 -- All submodule outputs
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_return_output,
 BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_return_output,
 remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_return_output,
 BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_left : unsigned(31 downto 0);
 variable VAR_right : unsigned(4 downto 0);
 variable VAR_return_output : unsigned(4 downto 0);
 variable VAR_left_resized : unsigned(31 downto 0);
 variable VAR_right_resized : unsigned(31 downto 0);
 variable VAR_output : unsigned(31 downto 0);
 variable VAR_remainder : unsigned(31 downto 0);
 variable VAR_new_remainder0 : unsigned(0 downto 0);
 variable VAR_uint32_31_31_BIN_OP_MOD_uint32_t_uint5_t_c_l41_c20_1df4_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l42_c3_e3a2 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l42_c15_807c_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_return_output : unsigned(31 downto 0);
 variable VAR_uint32_30_30_BIN_OP_MOD_uint32_t_uint5_t_c_l50_c20_e2a6_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l51_c3_8ff2 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l51_c15_b17b_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_return_output : unsigned(31 downto 0);
 variable VAR_uint32_29_29_BIN_OP_MOD_uint32_t_uint5_t_c_l59_c20_5a05_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l60_c3_029a : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l60_c15_bd3c_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_return_output : unsigned(31 downto 0);
 variable VAR_uint32_28_28_BIN_OP_MOD_uint32_t_uint5_t_c_l68_c20_f5a6_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l69_c3_c05f : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l69_c15_8f71_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_return_output : unsigned(31 downto 0);
 variable VAR_uint32_27_27_BIN_OP_MOD_uint32_t_uint5_t_c_l77_c20_e163_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l78_c3_6ff6 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l78_c15_3005_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_return_output : unsigned(31 downto 0);
 variable VAR_uint32_26_26_BIN_OP_MOD_uint32_t_uint5_t_c_l86_c20_a188_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l87_c3_9188 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l87_c15_ec84_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_return_output : unsigned(31 downto 0);
 variable VAR_uint32_25_25_BIN_OP_MOD_uint32_t_uint5_t_c_l95_c20_ac60_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l96_c3_d01e : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l96_c15_e474_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_return_output : unsigned(31 downto 0);
 variable VAR_uint32_24_24_BIN_OP_MOD_uint32_t_uint5_t_c_l104_c20_63e1_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l105_c3_ab9c : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l105_c15_8ad4_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_return_output : unsigned(31 downto 0);
 variable VAR_uint32_23_23_BIN_OP_MOD_uint32_t_uint5_t_c_l113_c20_f814_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l114_c3_572e : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l114_c15_6eed_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_return_output : unsigned(31 downto 0);
 variable VAR_uint32_22_22_BIN_OP_MOD_uint32_t_uint5_t_c_l122_c20_ac4d_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l123_c3_035e : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l123_c15_bcd9_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_return_output : unsigned(31 downto 0);
 variable VAR_uint32_21_21_BIN_OP_MOD_uint32_t_uint5_t_c_l131_c20_ce6f_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l132_c3_3848 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l132_c15_4d35_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_return_output : unsigned(31 downto 0);
 variable VAR_uint32_20_20_BIN_OP_MOD_uint32_t_uint5_t_c_l140_c20_1d3c_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l141_c3_f4c6 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l141_c15_d6bc_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_return_output : unsigned(31 downto 0);
 variable VAR_uint32_19_19_BIN_OP_MOD_uint32_t_uint5_t_c_l149_c20_f25b_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l150_c3_540e : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l150_c15_86a2_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_return_output : unsigned(31 downto 0);
 variable VAR_uint32_18_18_BIN_OP_MOD_uint32_t_uint5_t_c_l158_c20_27d7_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l159_c3_c3ea : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l159_c15_7c26_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_return_output : unsigned(31 downto 0);
 variable VAR_uint32_17_17_BIN_OP_MOD_uint32_t_uint5_t_c_l167_c20_d53c_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l168_c3_f4ca : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l168_c15_7366_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_return_output : unsigned(31 downto 0);
 variable VAR_uint32_16_16_BIN_OP_MOD_uint32_t_uint5_t_c_l176_c20_b14f_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l177_c3_d89f : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l177_c15_8ce8_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_return_output : unsigned(31 downto 0);
 variable VAR_uint32_15_15_BIN_OP_MOD_uint32_t_uint5_t_c_l185_c20_68a3_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l186_c3_db1f : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l186_c15_661c_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_return_output : unsigned(31 downto 0);
 variable VAR_uint32_14_14_BIN_OP_MOD_uint32_t_uint5_t_c_l194_c20_5123_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l195_c3_ca02 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l195_c15_f025_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_return_output : unsigned(31 downto 0);
 variable VAR_uint32_13_13_BIN_OP_MOD_uint32_t_uint5_t_c_l203_c20_3488_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l204_c3_7db6 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l204_c15_5d39_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_return_output : unsigned(31 downto 0);
 variable VAR_uint32_12_12_BIN_OP_MOD_uint32_t_uint5_t_c_l212_c20_aee9_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l213_c3_4e58 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l213_c15_45a2_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_return_output : unsigned(31 downto 0);
 variable VAR_uint32_11_11_BIN_OP_MOD_uint32_t_uint5_t_c_l221_c20_5834_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l222_c3_0c5f : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l222_c15_bc5a_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_return_output : unsigned(31 downto 0);
 variable VAR_uint32_10_10_BIN_OP_MOD_uint32_t_uint5_t_c_l230_c20_7e09_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l231_c3_7b2a : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l231_c15_9150_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_return_output : unsigned(31 downto 0);
 variable VAR_uint32_9_9_BIN_OP_MOD_uint32_t_uint5_t_c_l239_c20_06e6_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l240_c3_3b64 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l240_c15_71ee_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_return_output : unsigned(31 downto 0);
 variable VAR_uint32_8_8_BIN_OP_MOD_uint32_t_uint5_t_c_l248_c20_9110_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l249_c3_9f1d : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l249_c15_c10b_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_return_output : unsigned(31 downto 0);
 variable VAR_uint32_7_7_BIN_OP_MOD_uint32_t_uint5_t_c_l257_c20_95f8_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l258_c3_fd30 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l258_c15_7cf6_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_return_output : unsigned(31 downto 0);
 variable VAR_uint32_6_6_BIN_OP_MOD_uint32_t_uint5_t_c_l266_c20_7e99_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l267_c3_3460 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l267_c15_ec26_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_return_output : unsigned(31 downto 0);
 variable VAR_uint32_5_5_BIN_OP_MOD_uint32_t_uint5_t_c_l275_c20_040e_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l276_c3_4f72 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l276_c15_3fc9_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_return_output : unsigned(31 downto 0);
 variable VAR_uint32_4_4_BIN_OP_MOD_uint32_t_uint5_t_c_l284_c20_032b_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l285_c3_19f6 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l285_c15_f09f_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_return_output : unsigned(31 downto 0);
 variable VAR_uint32_3_3_BIN_OP_MOD_uint32_t_uint5_t_c_l293_c20_60a7_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l294_c3_2514 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l294_c15_71d7_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_return_output : unsigned(31 downto 0);
 variable VAR_uint32_2_2_BIN_OP_MOD_uint32_t_uint5_t_c_l302_c20_15c2_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l303_c3_7337 : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l303_c15_d1dd_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_return_output : unsigned(31 downto 0);
 variable VAR_uint32_1_1_BIN_OP_MOD_uint32_t_uint5_t_c_l311_c20_69a7_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l312_c3_001f : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l312_c15_f367_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_return_output : unsigned(31 downto 0);
 variable VAR_uint32_0_0_BIN_OP_MOD_uint32_t_uint5_t_c_l320_c20_f65f_return_output : unsigned(0 downto 0);
 variable VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l321_c3_6f4a : unsigned(31 downto 0);
 variable VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l321_c15_2550_return_output : unsigned(32 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_return_output : unsigned(0 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iftrue : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iffalse : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_return_output : unsigned(31 downto 0);
 variable VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_left : unsigned(31 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_right : unsigned(4 downto 0);
 variable VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_return_output : unsigned(31 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_left := left;
     VAR_right := right;

     -- Submodule level 0
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_right := VAR_right;
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_right := VAR_right;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_right := VAR_right;
     -- uint32_0_0[BIN_OP_MOD_uint32_t_uint5_t_c_l320_c20_f65f] LATENCY=0
     VAR_uint32_0_0_BIN_OP_MOD_uint32_t_uint5_t_c_l320_c20_f65f_return_output := uint32_0_0(
     VAR_left);

     -- uint32_15_15[BIN_OP_MOD_uint32_t_uint5_t_c_l185_c20_68a3] LATENCY=0
     VAR_uint32_15_15_BIN_OP_MOD_uint32_t_uint5_t_c_l185_c20_68a3_return_output := uint32_15_15(
     VAR_left);

     -- uint32_29_29[BIN_OP_MOD_uint32_t_uint5_t_c_l59_c20_5a05] LATENCY=0
     VAR_uint32_29_29_BIN_OP_MOD_uint32_t_uint5_t_c_l59_c20_5a05_return_output := uint32_29_29(
     VAR_left);

     -- uint32_24_24[BIN_OP_MOD_uint32_t_uint5_t_c_l104_c20_63e1] LATENCY=0
     VAR_uint32_24_24_BIN_OP_MOD_uint32_t_uint5_t_c_l104_c20_63e1_return_output := uint32_24_24(
     VAR_left);

     -- uint32_7_7[BIN_OP_MOD_uint32_t_uint5_t_c_l257_c20_95f8] LATENCY=0
     VAR_uint32_7_7_BIN_OP_MOD_uint32_t_uint5_t_c_l257_c20_95f8_return_output := uint32_7_7(
     VAR_left);

     -- uint32_18_18[BIN_OP_MOD_uint32_t_uint5_t_c_l158_c20_27d7] LATENCY=0
     VAR_uint32_18_18_BIN_OP_MOD_uint32_t_uint5_t_c_l158_c20_27d7_return_output := uint32_18_18(
     VAR_left);

     -- uint32_6_6[BIN_OP_MOD_uint32_t_uint5_t_c_l266_c20_7e99] LATENCY=0
     VAR_uint32_6_6_BIN_OP_MOD_uint32_t_uint5_t_c_l266_c20_7e99_return_output := uint32_6_6(
     VAR_left);

     -- uint32_21_21[BIN_OP_MOD_uint32_t_uint5_t_c_l131_c20_ce6f] LATENCY=0
     VAR_uint32_21_21_BIN_OP_MOD_uint32_t_uint5_t_c_l131_c20_ce6f_return_output := uint32_21_21(
     VAR_left);

     -- uint32_28_28[BIN_OP_MOD_uint32_t_uint5_t_c_l68_c20_f5a6] LATENCY=0
     VAR_uint32_28_28_BIN_OP_MOD_uint32_t_uint5_t_c_l68_c20_f5a6_return_output := uint32_28_28(
     VAR_left);

     -- uint32_11_11[BIN_OP_MOD_uint32_t_uint5_t_c_l221_c20_5834] LATENCY=0
     VAR_uint32_11_11_BIN_OP_MOD_uint32_t_uint5_t_c_l221_c20_5834_return_output := uint32_11_11(
     VAR_left);

     -- uint32_13_13[BIN_OP_MOD_uint32_t_uint5_t_c_l203_c20_3488] LATENCY=0
     VAR_uint32_13_13_BIN_OP_MOD_uint32_t_uint5_t_c_l203_c20_3488_return_output := uint32_13_13(
     VAR_left);

     -- uint32_27_27[BIN_OP_MOD_uint32_t_uint5_t_c_l77_c20_e163] LATENCY=0
     VAR_uint32_27_27_BIN_OP_MOD_uint32_t_uint5_t_c_l77_c20_e163_return_output := uint32_27_27(
     VAR_left);

     -- uint32_4_4[BIN_OP_MOD_uint32_t_uint5_t_c_l284_c20_032b] LATENCY=0
     VAR_uint32_4_4_BIN_OP_MOD_uint32_t_uint5_t_c_l284_c20_032b_return_output := uint32_4_4(
     VAR_left);

     -- uint32_19_19[BIN_OP_MOD_uint32_t_uint5_t_c_l149_c20_f25b] LATENCY=0
     VAR_uint32_19_19_BIN_OP_MOD_uint32_t_uint5_t_c_l149_c20_f25b_return_output := uint32_19_19(
     VAR_left);

     -- uint32_9_9[BIN_OP_MOD_uint32_t_uint5_t_c_l239_c20_06e6] LATENCY=0
     VAR_uint32_9_9_BIN_OP_MOD_uint32_t_uint5_t_c_l239_c20_06e6_return_output := uint32_9_9(
     VAR_left);

     -- uint32_25_25[BIN_OP_MOD_uint32_t_uint5_t_c_l95_c20_ac60] LATENCY=0
     VAR_uint32_25_25_BIN_OP_MOD_uint32_t_uint5_t_c_l95_c20_ac60_return_output := uint32_25_25(
     VAR_left);

     -- uint32_2_2[BIN_OP_MOD_uint32_t_uint5_t_c_l302_c20_15c2] LATENCY=0
     VAR_uint32_2_2_BIN_OP_MOD_uint32_t_uint5_t_c_l302_c20_15c2_return_output := uint32_2_2(
     VAR_left);

     -- uint32_3_3[BIN_OP_MOD_uint32_t_uint5_t_c_l293_c20_60a7] LATENCY=0
     VAR_uint32_3_3_BIN_OP_MOD_uint32_t_uint5_t_c_l293_c20_60a7_return_output := uint32_3_3(
     VAR_left);

     -- uint32_23_23[BIN_OP_MOD_uint32_t_uint5_t_c_l113_c20_f814] LATENCY=0
     VAR_uint32_23_23_BIN_OP_MOD_uint32_t_uint5_t_c_l113_c20_f814_return_output := uint32_23_23(
     VAR_left);

     -- uint32_16_16[BIN_OP_MOD_uint32_t_uint5_t_c_l176_c20_b14f] LATENCY=0
     VAR_uint32_16_16_BIN_OP_MOD_uint32_t_uint5_t_c_l176_c20_b14f_return_output := uint32_16_16(
     VAR_left);

     -- uint32_5_5[BIN_OP_MOD_uint32_t_uint5_t_c_l275_c20_040e] LATENCY=0
     VAR_uint32_5_5_BIN_OP_MOD_uint32_t_uint5_t_c_l275_c20_040e_return_output := uint32_5_5(
     VAR_left);

     -- uint32_20_20[BIN_OP_MOD_uint32_t_uint5_t_c_l140_c20_1d3c] LATENCY=0
     VAR_uint32_20_20_BIN_OP_MOD_uint32_t_uint5_t_c_l140_c20_1d3c_return_output := uint32_20_20(
     VAR_left);

     -- uint32_31_31[BIN_OP_MOD_uint32_t_uint5_t_c_l41_c20_1df4] LATENCY=0
     VAR_uint32_31_31_BIN_OP_MOD_uint32_t_uint5_t_c_l41_c20_1df4_return_output := uint32_31_31(
     VAR_left);

     -- uint32_12_12[BIN_OP_MOD_uint32_t_uint5_t_c_l212_c20_aee9] LATENCY=0
     VAR_uint32_12_12_BIN_OP_MOD_uint32_t_uint5_t_c_l212_c20_aee9_return_output := uint32_12_12(
     VAR_left);

     -- uint32_8_8[BIN_OP_MOD_uint32_t_uint5_t_c_l248_c20_9110] LATENCY=0
     VAR_uint32_8_8_BIN_OP_MOD_uint32_t_uint5_t_c_l248_c20_9110_return_output := uint32_8_8(
     VAR_left);

     -- uint32_1_1[BIN_OP_MOD_uint32_t_uint5_t_c_l311_c20_69a7] LATENCY=0
     VAR_uint32_1_1_BIN_OP_MOD_uint32_t_uint5_t_c_l311_c20_69a7_return_output := uint32_1_1(
     VAR_left);

     -- uint32_30_30[BIN_OP_MOD_uint32_t_uint5_t_c_l50_c20_e2a6] LATENCY=0
     VAR_uint32_30_30_BIN_OP_MOD_uint32_t_uint5_t_c_l50_c20_e2a6_return_output := uint32_30_30(
     VAR_left);

     -- uint32_17_17[BIN_OP_MOD_uint32_t_uint5_t_c_l167_c20_d53c] LATENCY=0
     VAR_uint32_17_17_BIN_OP_MOD_uint32_t_uint5_t_c_l167_c20_d53c_return_output := uint32_17_17(
     VAR_left);

     -- uint32_26_26[BIN_OP_MOD_uint32_t_uint5_t_c_l86_c20_a188] LATENCY=0
     VAR_uint32_26_26_BIN_OP_MOD_uint32_t_uint5_t_c_l86_c20_a188_return_output := uint32_26_26(
     VAR_left);

     -- uint32_22_22[BIN_OP_MOD_uint32_t_uint5_t_c_l122_c20_ac4d] LATENCY=0
     VAR_uint32_22_22_BIN_OP_MOD_uint32_t_uint5_t_c_l122_c20_ac4d_return_output := uint32_22_22(
     VAR_left);

     -- uint32_10_10[BIN_OP_MOD_uint32_t_uint5_t_c_l230_c20_7e09] LATENCY=0
     VAR_uint32_10_10_BIN_OP_MOD_uint32_t_uint5_t_c_l230_c20_7e09_return_output := uint32_10_10(
     VAR_left);

     -- uint32_14_14[BIN_OP_MOD_uint32_t_uint5_t_c_l194_c20_5123] LATENCY=0
     VAR_uint32_14_14_BIN_OP_MOD_uint32_t_uint5_t_c_l194_c20_5123_return_output := uint32_14_14(
     VAR_left);

     -- Submodule level 1
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l42_c15_807c] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l42_c15_807c_return_output := uint32_uint1(
     to_unsigned(0, 32),
     VAR_uint32_31_31_BIN_OP_MOD_uint32_t_uint5_t_c_l41_c20_1df4_return_output);

     -- Submodule level 2
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l42_c3_e3a2 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l42_c15_807c_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l42_c3_e3a2;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l42_c3_e3a2;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l42_c3_e3a2;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_return_output;

     -- Submodule level 3
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c6_4e08_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l45_c17_0d77_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_return_output;

     -- Submodule level 4
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l51_c15_b17b] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l51_c15_b17b_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l43_c3_573c_return_output,
     VAR_uint32_30_30_BIN_OP_MOD_uint32_t_uint5_t_c_l50_c20_e2a6_return_output);

     -- Submodule level 5
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l51_c3_8ff2 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l51_c15_b17b_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l51_c3_8ff2;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l51_c3_8ff2;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l51_c3_8ff2;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_return_output;

     -- Submodule level 6
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c6_e536_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l54_c17_8219_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_return_output;

     -- Submodule level 7
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l60_c15_bd3c] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l60_c15_bd3c_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l52_c3_4d42_return_output,
     VAR_uint32_29_29_BIN_OP_MOD_uint32_t_uint5_t_c_l59_c20_5a05_return_output);

     -- Submodule level 8
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l60_c3_029a := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l60_c15_bd3c_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l60_c3_029a;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l60_c3_029a;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l60_c3_029a;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_return_output;

     -- Submodule level 9
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c6_2045_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l63_c17_5a8a_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_return_output;

     -- Submodule level 10
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l69_c15_8f71] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l69_c15_8f71_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l61_c3_7eb8_return_output,
     VAR_uint32_28_28_BIN_OP_MOD_uint32_t_uint5_t_c_l68_c20_f5a6_return_output);

     -- Submodule level 11
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l69_c3_c05f := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l69_c15_8f71_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l69_c3_c05f;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l69_c3_c05f;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l69_c3_c05f;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_return_output;

     -- Submodule level 12
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c6_ba2d_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l72_c17_5294_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_return_output;

     -- Submodule level 13
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l78_c15_3005] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l78_c15_3005_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l70_c3_70a6_return_output,
     VAR_uint32_27_27_BIN_OP_MOD_uint32_t_uint5_t_c_l77_c20_e163_return_output);

     -- Submodule level 14
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l78_c3_6ff6 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l78_c15_3005_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l78_c3_6ff6;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l78_c3_6ff6;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l78_c3_6ff6;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_return_output;

     -- Submodule level 15
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c6_6101_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l81_c17_9fb5_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_return_output;

     -- Submodule level 16
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l87_c15_ec84] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l87_c15_ec84_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l79_c3_6a3e_return_output,
     VAR_uint32_26_26_BIN_OP_MOD_uint32_t_uint5_t_c_l86_c20_a188_return_output);

     -- Submodule level 17
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l87_c3_9188 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l87_c15_ec84_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l87_c3_9188;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l87_c3_9188;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l87_c3_9188;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_return_output;

     -- Submodule level 18
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c6_148c_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l90_c17_a506_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_return_output;

     -- Submodule level 19
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l96_c15_e474] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l96_c15_e474_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l88_c3_7d19_return_output,
     VAR_uint32_25_25_BIN_OP_MOD_uint32_t_uint5_t_c_l95_c20_ac60_return_output);

     -- Submodule level 20
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l96_c3_d01e := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l96_c15_e474_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l96_c3_d01e;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l96_c3_d01e;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l96_c3_d01e;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_return_output;

     -- Submodule level 21
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c6_0119_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l99_c17_4355_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_return_output;

     -- Submodule level 22
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l105_c15_8ad4] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l105_c15_8ad4_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l97_c3_55c3_return_output,
     VAR_uint32_24_24_BIN_OP_MOD_uint32_t_uint5_t_c_l104_c20_63e1_return_output);

     -- Submodule level 23
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l105_c3_ab9c := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l105_c15_8ad4_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l105_c3_ab9c;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l105_c3_ab9c;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l105_c3_ab9c;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_return_output;

     -- Submodule level 24
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c6_2e76_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l108_c17_236d_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_return_output;

     -- Submodule level 25
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l114_c15_6eed] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l114_c15_6eed_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l106_c3_1db3_return_output,
     VAR_uint32_23_23_BIN_OP_MOD_uint32_t_uint5_t_c_l113_c20_f814_return_output);

     -- Submodule level 26
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l114_c3_572e := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l114_c15_6eed_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l114_c3_572e;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l114_c3_572e;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l114_c3_572e;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_return_output;

     -- Submodule level 27
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c6_7e1b_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l117_c17_e1ba_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_return_output;

     -- Submodule level 28
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l123_c15_bcd9] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l123_c15_bcd9_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l115_c3_e00b_return_output,
     VAR_uint32_22_22_BIN_OP_MOD_uint32_t_uint5_t_c_l122_c20_ac4d_return_output);

     -- Submodule level 29
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l123_c3_035e := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l123_c15_bcd9_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l123_c3_035e;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l123_c3_035e;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l123_c3_035e;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_return_output;

     -- Submodule level 30
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c6_bde1_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l126_c17_5897_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_return_output;

     -- Submodule level 31
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l132_c15_4d35] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l132_c15_4d35_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l124_c3_6f65_return_output,
     VAR_uint32_21_21_BIN_OP_MOD_uint32_t_uint5_t_c_l131_c20_ce6f_return_output);

     -- Submodule level 32
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l132_c3_3848 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l132_c15_4d35_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l132_c3_3848;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l132_c3_3848;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l132_c3_3848;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_return_output;

     -- Submodule level 33
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c6_e540_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l135_c17_d088_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_return_output;

     -- Submodule level 34
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l141_c15_d6bc] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l141_c15_d6bc_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l133_c3_5276_return_output,
     VAR_uint32_20_20_BIN_OP_MOD_uint32_t_uint5_t_c_l140_c20_1d3c_return_output);

     -- Submodule level 35
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l141_c3_f4c6 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l141_c15_d6bc_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l141_c3_f4c6;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l141_c3_f4c6;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l141_c3_f4c6;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_return_output;

     -- Submodule level 36
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c6_b860_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l144_c17_a07d_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_return_output;

     -- Submodule level 37
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l150_c15_86a2] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l150_c15_86a2_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l142_c3_a5ff_return_output,
     VAR_uint32_19_19_BIN_OP_MOD_uint32_t_uint5_t_c_l149_c20_f25b_return_output);

     -- Submodule level 38
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l150_c3_540e := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l150_c15_86a2_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l150_c3_540e;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l150_c3_540e;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l150_c3_540e;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_return_output;

     -- Submodule level 39
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c6_76ae_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l153_c17_6200_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_return_output;

     -- Submodule level 40
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l159_c15_7c26] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l159_c15_7c26_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l151_c3_f3a7_return_output,
     VAR_uint32_18_18_BIN_OP_MOD_uint32_t_uint5_t_c_l158_c20_27d7_return_output);

     -- Submodule level 41
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l159_c3_c3ea := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l159_c15_7c26_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l159_c3_c3ea;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l159_c3_c3ea;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l159_c3_c3ea;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_return_output;

     -- Submodule level 42
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c6_06e5_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l162_c17_6907_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_return_output;

     -- Submodule level 43
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l168_c15_7366] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l168_c15_7366_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l160_c3_deb3_return_output,
     VAR_uint32_17_17_BIN_OP_MOD_uint32_t_uint5_t_c_l167_c20_d53c_return_output);

     -- Submodule level 44
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l168_c3_f4ca := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l168_c15_7366_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l168_c3_f4ca;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l168_c3_f4ca;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l168_c3_f4ca;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_return_output;

     -- Submodule level 45
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c6_9dfb_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l171_c17_762b_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_return_output;

     -- Submodule level 46
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l177_c15_8ce8] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l177_c15_8ce8_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l169_c3_e529_return_output,
     VAR_uint32_16_16_BIN_OP_MOD_uint32_t_uint5_t_c_l176_c20_b14f_return_output);

     -- Submodule level 47
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l177_c3_d89f := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l177_c15_8ce8_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l177_c3_d89f;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l177_c3_d89f;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l177_c3_d89f;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_return_output;

     -- Submodule level 48
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c6_9c30_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l180_c17_9752_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_return_output;

     -- Submodule level 49
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l186_c15_661c] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l186_c15_661c_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l178_c3_3d1c_return_output,
     VAR_uint32_15_15_BIN_OP_MOD_uint32_t_uint5_t_c_l185_c20_68a3_return_output);

     -- Submodule level 50
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l186_c3_db1f := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l186_c15_661c_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l186_c3_db1f;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l186_c3_db1f;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l186_c3_db1f;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_return_output;

     -- Submodule level 51
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c6_9a51_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l189_c17_c8c3_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_return_output;

     -- Submodule level 52
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l195_c15_f025] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l195_c15_f025_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l187_c3_d849_return_output,
     VAR_uint32_14_14_BIN_OP_MOD_uint32_t_uint5_t_c_l194_c20_5123_return_output);

     -- Submodule level 53
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l195_c3_ca02 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l195_c15_f025_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l195_c3_ca02;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l195_c3_ca02;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l195_c3_ca02;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_return_output;

     -- Submodule level 54
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c6_a1c5_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l198_c17_24bc_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_return_output;

     -- Submodule level 55
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l204_c15_5d39] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l204_c15_5d39_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l196_c3_f2e7_return_output,
     VAR_uint32_13_13_BIN_OP_MOD_uint32_t_uint5_t_c_l203_c20_3488_return_output);

     -- Submodule level 56
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l204_c3_7db6 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l204_c15_5d39_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l204_c3_7db6;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l204_c3_7db6;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l204_c3_7db6;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_return_output;

     -- Submodule level 57
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c6_60e1_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l207_c17_d8ab_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_return_output;

     -- Submodule level 58
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l213_c15_45a2] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l213_c15_45a2_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l205_c3_d21f_return_output,
     VAR_uint32_12_12_BIN_OP_MOD_uint32_t_uint5_t_c_l212_c20_aee9_return_output);

     -- Submodule level 59
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l213_c3_4e58 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l213_c15_45a2_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l213_c3_4e58;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l213_c3_4e58;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l213_c3_4e58;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_return_output;

     -- Submodule level 60
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c6_aa9d_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l216_c17_4a4a_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_return_output;

     -- Submodule level 61
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l222_c15_bc5a] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l222_c15_bc5a_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l214_c3_67b1_return_output,
     VAR_uint32_11_11_BIN_OP_MOD_uint32_t_uint5_t_c_l221_c20_5834_return_output);

     -- Submodule level 62
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l222_c3_0c5f := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l222_c15_bc5a_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l222_c3_0c5f;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l222_c3_0c5f;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l222_c3_0c5f;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_return_output;

     -- Submodule level 63
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c6_8596_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l225_c17_bc1a_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_return_output;

     -- Submodule level 64
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l231_c15_9150] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l231_c15_9150_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l223_c3_ba45_return_output,
     VAR_uint32_10_10_BIN_OP_MOD_uint32_t_uint5_t_c_l230_c20_7e09_return_output);

     -- Submodule level 65
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l231_c3_7b2a := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l231_c15_9150_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l231_c3_7b2a;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l231_c3_7b2a;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l231_c3_7b2a;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_return_output;

     -- Submodule level 66
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c6_d778_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l234_c17_4ec7_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_return_output;

     -- Submodule level 67
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l240_c15_71ee] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l240_c15_71ee_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l232_c3_d9ef_return_output,
     VAR_uint32_9_9_BIN_OP_MOD_uint32_t_uint5_t_c_l239_c20_06e6_return_output);

     -- Submodule level 68
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l240_c3_3b64 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l240_c15_71ee_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l240_c3_3b64;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l240_c3_3b64;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l240_c3_3b64;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_return_output;

     -- Submodule level 69
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c6_de8a_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l243_c17_12c9_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_return_output;

     -- Submodule level 70
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l249_c15_c10b] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l249_c15_c10b_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l241_c3_3d5c_return_output,
     VAR_uint32_8_8_BIN_OP_MOD_uint32_t_uint5_t_c_l248_c20_9110_return_output);

     -- Submodule level 71
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l249_c3_9f1d := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l249_c15_c10b_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l249_c3_9f1d;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l249_c3_9f1d;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l249_c3_9f1d;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_return_output;

     -- Submodule level 72
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c6_b98d_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l252_c17_42f3_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_return_output;

     -- Submodule level 73
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l258_c15_7cf6] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l258_c15_7cf6_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l250_c3_9286_return_output,
     VAR_uint32_7_7_BIN_OP_MOD_uint32_t_uint5_t_c_l257_c20_95f8_return_output);

     -- Submodule level 74
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l258_c3_fd30 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l258_c15_7cf6_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l258_c3_fd30;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l258_c3_fd30;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l258_c3_fd30;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_return_output;

     -- Submodule level 75
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c6_e0b2_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l261_c17_fa07_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_return_output;

     -- Submodule level 76
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l267_c15_ec26] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l267_c15_ec26_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l259_c3_4cc4_return_output,
     VAR_uint32_6_6_BIN_OP_MOD_uint32_t_uint5_t_c_l266_c20_7e99_return_output);

     -- Submodule level 77
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l267_c3_3460 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l267_c15_ec26_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l267_c3_3460;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l267_c3_3460;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l267_c3_3460;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_return_output;

     -- Submodule level 78
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c6_0018_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l270_c17_63c0_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_return_output;

     -- Submodule level 79
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l276_c15_3fc9] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l276_c15_3fc9_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l268_c3_74c5_return_output,
     VAR_uint32_5_5_BIN_OP_MOD_uint32_t_uint5_t_c_l275_c20_040e_return_output);

     -- Submodule level 80
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l276_c3_4f72 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l276_c15_3fc9_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l276_c3_4f72;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l276_c3_4f72;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l276_c3_4f72;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_return_output;

     -- Submodule level 81
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c6_bea4_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l279_c17_dc79_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_return_output;

     -- Submodule level 82
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l285_c15_f09f] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l285_c15_f09f_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l277_c3_0d51_return_output,
     VAR_uint32_4_4_BIN_OP_MOD_uint32_t_uint5_t_c_l284_c20_032b_return_output);

     -- Submodule level 83
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l285_c3_19f6 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l285_c15_f09f_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l285_c3_19f6;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l285_c3_19f6;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l285_c3_19f6;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_return_output;

     -- Submodule level 84
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c6_fd87_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l288_c17_ae03_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_return_output;

     -- Submodule level 85
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l294_c15_71d7] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l294_c15_71d7_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l286_c3_b96a_return_output,
     VAR_uint32_3_3_BIN_OP_MOD_uint32_t_uint5_t_c_l293_c20_60a7_return_output);

     -- Submodule level 86
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l294_c3_2514 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l294_c15_71d7_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l294_c3_2514;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l294_c3_2514;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l294_c3_2514;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_return_output;

     -- Submodule level 87
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c6_c641_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l297_c17_4938_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_return_output;

     -- Submodule level 88
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l303_c15_d1dd] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l303_c15_d1dd_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l295_c3_197a_return_output,
     VAR_uint32_2_2_BIN_OP_MOD_uint32_t_uint5_t_c_l302_c20_15c2_return_output);

     -- Submodule level 89
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l303_c3_7337 := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l303_c15_d1dd_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l303_c3_7337;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l303_c3_7337;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l303_c3_7337;
     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_return_output;

     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_return_output;

     -- Submodule level 90
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c6_d62d_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l306_c17_3a23_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_return_output;

     -- Submodule level 91
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l312_c15_f367] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l312_c15_f367_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l304_c3_b0ce_return_output,
     VAR_uint32_1_1_BIN_OP_MOD_uint32_t_uint5_t_c_l311_c20_69a7_return_output);

     -- Submodule level 92
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l312_c3_001f := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l312_c15_f367_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l312_c3_001f;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l312_c3_001f;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l312_c3_001f;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_return_output;

     -- Submodule level 93
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c6_1536_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l315_c17_b6b9_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_return_output;

     -- Submodule level 94
     -- uint32_uint1[BIN_OP_MOD_uint32_t_uint5_t_c_l321_c15_2550] LATENCY=0
     VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l321_c15_2550_return_output := uint32_uint1(
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l313_c3_6b37_return_output,
     VAR_uint32_0_0_BIN_OP_MOD_uint32_t_uint5_t_c_l320_c20_f65f_return_output);

     -- Submodule level 95
     VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l321_c3_6f4a := resize(VAR_uint32_uint1_BIN_OP_MOD_uint32_t_uint5_t_c_l321_c15_2550_return_output, 32);
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l321_c3_6f4a;
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_left := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l321_c3_6f4a;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iffalse := VAR_remainder_BIN_OP_MOD_uint32_t_uint5_t_c_l321_c3_6f4a;
     -- BIN_OP_MINUS[BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d] LATENCY=0
     -- Inputs
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_left <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_left;
     BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_right <= VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_right;
     -- Outputs
     VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_return_output := BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_return_output;

     -- BIN_OP_GTE[BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001] LATENCY=0
     -- Inputs
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_left <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_left;
     BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_right <= VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_right;
     -- Outputs
     VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_return_output := BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_return_output;

     -- Submodule level 96
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_cond := VAR_BIN_OP_GTE_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c6_f001_return_output;
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iftrue := VAR_BIN_OP_MINUS_BIN_OP_MOD_uint32_t_uint5_t_c_l324_c17_fd6d_return_output;
     -- remainder_MUX[BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f] LATENCY=0
     -- Inputs
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_cond <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_cond;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iftrue <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iftrue;
     remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iffalse <= VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_iffalse;
     -- Outputs
     VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_return_output := remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_return_output;

     -- Submodule level 97
     VAR_return_output := resize(VAR_remainder_MUX_BIN_OP_MOD_uint32_t_uint5_t_c_l322_c3_352f_return_output, 5);
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
