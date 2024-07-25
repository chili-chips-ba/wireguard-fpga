-- This file is part of the ethernet_mac project.
--
-- For the full copyright and license information, please read the
-- LICENSE.md file that was distributed with this source code.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--use work.ethernet_types.all;
use work.miim_types.all;
use work.miim_registers.all;

entity miim_control is
	generic(
		-- Ticks to wait before writing any registers after reset low
		RESET_WAIT_TICKS : natural := 0;

		-- Ticks to wait between polling the status register
		POLL_WAIT_TICKS  : natural := DEFAULT_POLL_WAIT_TICKS;

		-- Activate debug output
		DEBUG_OUTPUT     : boolean := FALSE

	-- Example for Marvell PHY 88E1111 and 125 MHz MIIM clock:
	-- RESET_WAIT_TICKS => 1250000 (10 ms at 125 MHz, minimum: 5 ms)
	);
	port(
		reset_i                 : in  std_ulogic;
		clock_i                 : in  std_ulogic;

		miim_register_address_o : out t_register_address;
		miim_data_read_i        : in  t_data;
		miim_data_write_o       : out t_data;
		miim_req_o              : out std_ulogic;
		miim_ack_i              : in  std_ulogic;
		miim_we_o               : out std_ulogic;

		speed_o                 : out t_ethernet_speed;
		link_up_o               : out std_ulogic;

		-- Only used if DEBUG_OUTPUT is TRUE
		debug_fifo_we_o         : out std_ulogic;
		debug_fifo_write_data_o : out std_ulogic_vector(7 downto 0)
	);
end entity;

architecture rtl of miim_control is
	signal register_address : t_register_address;

	type t_state is (
		RESET_WAIT,
		WRITE_AUTONEG,
		WRITE_GIGABIT_AUTONEG,
		WRITE_SOFTRESET,
		WAIT_POLL,
		READ_STATUS,
		READ_SPEED_10_100,
		READ_SPEED_1000,
		DEBUG_START,
		DEBUG_WRITE_REGAD,
		DEBUG_WRITE_BYTE1,
		DEBUG_WRITE_BYTE2,
		WAIT_ACK_LOW,
		DEBUG_DONE
	);
	signal state           : t_state := RESET_WAIT;
	signal after_ack_state : t_state;

	-- Initial register write contents

	-- Reset the PHY
	constant control_register_reset : t_control_register := (
		reset                    => '1',
		loopback                 => '0',
		speed_10_100             => '0',
		speed_1000               => '1',
		auto_negotiation_enable  => '1',
		power_down               => '0',
		isolate                  => '0',
		restart_auto_negotiation => '0',
		duplex_mode              => '1',
		enable_collision_test    => '0',
		unidirectional_enable    => '0'
	);

	-- Activate only full-duplex 10/100
	constant auto_negotiation_set_fd : t_auto_negotiation_advertisement_register_802_3 := (
		next_page               => '0',
		remote_fault            => '0',
		extended_next_page      => '0',
		asymmetric_pause        => '0',
		pause                   => '0',
		advertise_100base_t4    => '0',
		advertise_100base_tx_fd => '1',
		advertise_100base_tx_hd => '0',
		advertise_10base_t_fd   => '1',
		advertise_10base_t_hd   => '0'
	);

	-- Activate only full-duplex 1000
	constant master_slave_set_fd : t_master_slave_control_register := (
		test_mode_bits                    => "000",
		master_slave_manual_config_enable => '0',
		master_slave_manual_config_value  => '0',
		port_type_is_multiport            => '0',
		advertise_1000base_t_fd           => '1',
		advertise_1000base_t_hd           => '0'
	);

	signal init_done          : boolean := FALSE;
	signal reset_wait_counter : natural range 0 to RESET_WAIT_TICKS + 1;
	signal poll_wait_counter  : natural range 0 to POLL_WAIT_TICKS + 1;

	signal lp_supports_10  : std_ulogic;
	signal lp_supports_100 : std_ulogic;

begin
	miim_register_address_o <= register_address;

	fsm : process(clock_i)
	begin
		if rising_edge(clock_i) then
			-- Default values
			miim_req_o      <= '0';
			debug_fifo_we_o <= '0';

			if reset_i = '1' then
				state              <= RESET_WAIT;
				link_up_o          <= '0';
				speed_o            <= SPEED_UNSPECIFIED;
				reset_wait_counter <= 0;
				poll_wait_counter  <= 0;
			else
				miim_we_o       <= '0';
				case state is
					-- Initialization
					when RESET_WAIT =>
						-- Keep in mind that zero is a valid (and the default) value for RESET_WAIT_TICKS
						if reset_wait_counter = RESET_WAIT_TICKS then
							state <= WRITE_AUTONEG;
						end if;
						reset_wait_counter <= reset_wait_counter + 1;

					when WRITE_AUTONEG =>
						-- Advertise 100 MBit/10 MBit full-duplex, no PAUSE support
						register_address  <= AUTONEG_ADVERTISEMENT_REG;
						miim_data_write_o <= auto_negotiation_advertisement_register_802_3_to_data(auto_negotiation_set_fd);
						miim_req_o        <= '1';
						miim_we_o         <= '1';
						if miim_ack_i = '1' then
							miim_req_o      <= '0';
							state           <= WAIT_ACK_LOW;
							after_ack_state <= WRITE_GIGABIT_AUTONEG;
						end if;
					when WRITE_GIGABIT_AUTONEG =>
						-- Advertise 1000 MBit full-duplex
						register_address  <= MASTERSLAVE_CTRL_REG;
						miim_data_write_o <= master_slave_control_register_to_data(master_slave_set_fd);
						miim_req_o        <= '1';
						miim_we_o         <= '1';
						if miim_ack_i = '1' then
							miim_req_o      <= '0';
							state           <= WAIT_ACK_LOW;
							after_ack_state <= WRITE_SOFTRESET;
						end if;
					when WRITE_SOFTRESET =>
						-- Reset the PHY to apply the autonegotiation values
						register_address  <= CONTROL_REG;
						miim_data_write_o <= control_register_to_data(control_register_reset);
						miim_req_o        <= '1';
						miim_we_o         <= '1';
						if miim_ack_i = '1' then
							miim_req_o      <= '0';
							init_done       <= TRUE;
							state           <= WAIT_ACK_LOW;
							after_ack_state <= WAIT_POLL;
						end if;

					-- State polling

					when WAIT_POLL =>
						-- Don't poll continuously to reduce unnecessary switching noise
						poll_wait_counter <= poll_wait_counter + 1;
						if poll_wait_counter = POLL_WAIT_TICKS then
							poll_wait_counter <= 0;
							state             <= READ_STATUS;
						end if;
					when READ_STATUS =>
						-- Read status register
						register_address <= STATUS_REG;
						miim_req_o       <= '1';
						if miim_ack_i = '1' then
							-- Link is up when the link status indicator and auto-negotiation is OK
							link_up_o       <= data_to_status_register(miim_data_read_i).link_status and data_to_status_register(miim_data_read_i).auto_negotiation_complete;
							miim_req_o      <= '0';
							state           <= WAIT_ACK_LOW;
							after_ack_state <= READ_SPEED_10_100;
						end if;
					when READ_SPEED_10_100 =>
						-- Read link partner ability register
						register_address <= AUTONEG_LP_BASEPAGEABILITY_REG;
						miim_req_o       <= '1';
						if miim_ack_i = '1' then
							miim_req_o      <= '0';
							lp_supports_10  <= data_to_auto_negotiation_lp_base_page_ability_register(miim_data_read_i).can_10base_t_fd;
							lp_supports_100 <= data_to_auto_negotiation_lp_base_page_ability_register(miim_data_read_i).can_100base_tx_fd;
							state           <= WAIT_ACK_LOW;
							after_ack_state <= READ_SPEED_1000;
						end if;
					when READ_SPEED_1000 =>
						register_address <= MASTERSLAVE_STATUS_REG;
						miim_req_o       <= '1';
						if miim_ack_i = '1' then
							miim_req_o <= '0';
							-- Detect highest supported data rate
							if data_to_master_slave_status_register(miim_data_read_i).lp_1000base_t_fd = '1' then
								speed_o <= SPEED_1000MBPS;
							elsif lp_supports_100 = '1' then
								speed_o <= SPEED_100MBPS;
							elsif lp_supports_10 = '1' then
								speed_o <= SPEED_10MBPS;
							else
								-- Nothing is supported
								speed_o <= SPEED_UNSPECIFIED;
							end if;

							state            <= WAIT_ACK_LOW;
							register_address <= (others => '0');
							if DEBUG_OUTPUT = TRUE then
								after_ack_state <= DEBUG_START;
							else
								after_ack_state <= WAIT_POLL;
							end if;
						end if;

					-- Debug states

					when DEBUG_START =>
						if miim_ack_i = '1' then
							state                   <= DEBUG_WRITE_REGAD;
							debug_fifo_we_o         <= '1';
							debug_fifo_write_data_o <= "000" & std_ulogic_vector(register_address);
						else
							miim_req_o <= '1';
						end if;
					when DEBUG_WRITE_REGAD =>
						debug_fifo_we_o         <= '1';
						debug_fifo_write_data_o <= miim_data_read_i(15 downto 8);
						state                   <= DEBUG_WRITE_BYTE1;
					when DEBUG_WRITE_BYTE1 =>
						debug_fifo_we_o         <= '1';
						debug_fifo_write_data_o <= miim_data_read_i(7 downto 0);
						state                   <= DEBUG_WRITE_BYTE2;
					when DEBUG_WRITE_BYTE2 =>
						if register_address = "11111" then
							register_address <= (others => '0');
							state            <= DEBUG_DONE;
						else
							register_address <= register_address + 1;
							after_ack_state  <= DEBUG_START;
							state            <= WAIT_ACK_LOW;
						end if;
					when DEBUG_DONE =>
						--state         <= WAIT_DEBUG_START;
						state <= WAIT_POLL;

					-- Auxiliary state					
					when WAIT_ACK_LOW =>
						if miim_ack_i = '0' then
							state <= after_ack_state;
						end if;
				end case;
			end if;
		end if;
	end process;

end architecture;

