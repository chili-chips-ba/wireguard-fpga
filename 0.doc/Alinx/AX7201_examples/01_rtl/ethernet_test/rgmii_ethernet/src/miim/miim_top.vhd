-- This file is part of the ethernet_mac project.
--
-- For the full copyright and license information, please read the
-- LICENSE.md file that was distributed with this source code.

library ieee;
use ieee.std_logic_1164.all;
use work.miim_types.all;

entity miim_top is
	generic(
		MIIM_PHY_ADDRESS      : t_phy_address := (others => '0');
		MIIM_RESET_WAIT_TICKS : natural       := 0;
		MIIM_POLL_WAIT_TICKS  : natural       := DEFAULT_POLL_WAIT_TICKS;
		MIIM_CLOCK_DIVIDER    : positive      := 50
	);
	port(
		reset_i            : in    std_logic;
		
		-- MII Management Interface
		miim_clock_i       : in    std_logic;
		mdc_o              : out   std_logic;
		mdio_io            : inout std_logic;
		-- Status, synchronous to miim_clock_i
		link_up_o          : out   std_logic;
		speed_o            : out   t_ethernet_speed;
		--speed_o            : out   std_logic_vector(1 downto 0);
		-- Also synchronous to miim_clock_i if used!
		speed_override_i   : in    t_ethernet_speed := SPEED_UNSPECIFIED
		--speed_override_i   : in    std_logic_vector(1 downto 0)
	);
end entity;

architecture rtl of miim_top is
	signal miim_register_address : t_register_address;
	signal miim_phy_address_sig  : t_phy_address;
	signal miim_data_read        : t_data;
	signal miim_data_write       : t_data;
	signal miim_req              : std_ulogic;
	signal miim_ack              : std_ulogic;
	signal miim_wr_en            : std_ulogic;
	signal miim_speed            : t_ethernet_speed;
	signal speed                 : t_ethernet_speed;
	signal link_up               : std_ulogic;
begin


	link_up_o            <= link_up;
	speed_o              <= speed;
	miim_phy_address_sig <= MIIM_PHY_ADDRESS;

	with speed_override_i select speed <=
		miim_speed when SPEED_UNSPECIFIED,
		speed_override_i when others;



	miim_inst : entity work.miim
		generic map(
			CLOCK_DIVIDER => MIIM_CLOCK_DIVIDER
		)
		port map(
			reset_i            => reset_i,
			clock_i            => miim_clock_i,
			register_address_i => miim_register_address,
			phy_address_i      => miim_phy_address_sig,
			data_read_o        => miim_data_read,
			data_write_i       => miim_data_write,
			req_i              => miim_req,
			ack_o              => miim_ack,
			wr_en_i            => miim_wr_en,
			mdc_o              => mdc_o,
			mdio_io            => mdio_io
		);

	miim_control_inst : entity work.miim_control
		generic map(
			RESET_WAIT_TICKS => MIIM_RESET_WAIT_TICKS,
			POLL_WAIT_TICKS  => MIIM_POLL_WAIT_TICKS,
			DEBUG_OUTPUT     => FALSE
		)
		port map(
			reset_i                 => reset_i,
			clock_i                 => miim_clock_i,
			miim_register_address_o => miim_register_address,
			miim_data_read_i        => miim_data_read,
			miim_data_write_o       => miim_data_write,
			miim_req_o              => miim_req,
			miim_ack_i              => miim_ack,
			miim_we_o               => miim_wr_en,
			link_up_o               => link_up,
			speed_o                 => miim_speed,
			debug_fifo_we_o         => open,
			debug_fifo_write_data_o => open
		);

end architecture;

