-- This file is part of the ethernet_mac project.
--
-- For the full copyright and license information, please read the
-- LICENSE.md file that was distributed with this source code.

-- MIIM register definitions

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--use work.ethernet_types.all;
use work.miim_types.all;

package miim_registers is
	-- Register numbers
	constant CONTROL_REG                    : t_register_address := to_register_address(0);
	constant STATUS_REG                     : t_register_address := to_register_address(1);
	constant PHY_ID1_REG                    : t_register_address := to_register_address(2);
	constant PHY_ID2_REG                    : t_register_address := to_register_address(3);
	constant AUTONEG_ADVERTISEMENT_REG      : t_register_address := to_register_address(4);
	constant AUTONEG_LP_BASEPAGEABILITY_REG : t_register_address := to_register_address(5);
	constant AUTONEG_EXPANSION_REG          : t_register_address := to_register_address(6);
	constant AUTONEG_NEXTPAGETX_REG         : t_register_address := to_register_address(7);
	constant AUTONEG_LP_NEXTPAGERECV_REG    : t_register_address := to_register_address(8);
	constant MASTERSLAVE_CTRL_REG           : t_register_address := to_register_address(9);
	constant MASTERSLAVE_STATUS_REG         : t_register_address := to_register_address(10);
	constant PSE_CONTROL_REG                : t_register_address := to_register_address(11);
	constant PSE_STATUS_REG                 : t_register_address := to_register_address(12);
	constant MMD_ACCESSCONTROL_REG          : t_register_address := to_register_address(13);
	constant MMD_ACCESSADDRESSDATA_REG      : t_register_address := to_register_address(14);
	constant EXTENDED_STATUS_REG            : t_register_address := to_register_address(15);
	constant VENDOR_SPECIFIC_REG_BASE       : t_register_address := to_register_address(16);

	-- Register contents of selected registers
	-- See Ethernet specification for the meaning of the fields
	type t_control_register is record
		reset                    : std_ulogic;
		loopback                 : std_ulogic;
		speed_10_100             : std_ulogic;
		speed_1000               : std_ulogic;
		auto_negotiation_enable  : std_ulogic;
		power_down               : std_ulogic;
		isolate                  : std_ulogic;
		restart_auto_negotiation : std_ulogic;
		duplex_mode              : std_ulogic;
		enable_collision_test    : std_ulogic;
		unidirectional_enable    : std_ulogic;
	end record;

	type t_status_register is record
		can_100base_t4            : std_ulogic;
		can_100base_x_fd          : std_ulogic;
		can_100base_x_hd          : std_ulogic;
		can_10mbps_fd             : std_ulogic;
		can_10mbps_hd             : std_ulogic;
		can_100base_t2_fd         : std_ulogic;
		can_100base_t2_hd         : std_ulogic;
		extended_status           : std_ulogic;
		undirectional_ability     : std_ulogic;
		mf_preamble_suppression   : std_ulogic;
		auto_negotiation_complete : std_ulogic;
		remote_fault              : std_ulogic;
		auto_negotiation_ability  : std_ulogic;
		link_status               : std_ulogic;
		jabber_detect             : std_ulogic;
		extended_capability       : std_ulogic;
	end record;

	type t_auto_negotiation_advertisement_register_802_3 is record
		next_page               : std_ulogic;
		remote_fault            : std_ulogic;
		extended_next_page      : std_ulogic;
		asymmetric_pause        : std_ulogic;
		pause                   : std_ulogic;
		advertise_100base_t4    : std_ulogic;
		advertise_100base_tx_fd : std_ulogic;
		advertise_100base_tx_hd : std_ulogic;
		advertise_10base_t_fd   : std_ulogic;
		advertise_10base_t_hd   : std_ulogic;
	end record;

	type auto_negotiation_lp_base_page_ability_register_802_3_t is record
		next_page          : std_ulogic;
		acknowledge        : std_ulogic;
		remote_fault       : std_ulogic;
		extended_next_page : std_ulogic;
		asymmetric_pause   : std_ulogic;
		pause              : std_ulogic;
		can_100base_t4     : std_ulogic;
		can_100base_tx_fd  : std_ulogic;
		can_100base_tx_hd  : std_ulogic;
		can_10base_t_fd    : std_ulogic;
		can_10base_t_hd    : std_ulogic;
	end record;

	type t_master_slave_control_register is record
		test_mode_bits                    : std_ulogic_vector(2 downto 0);
		master_slave_manual_config_enable : std_ulogic;
		master_slave_manual_config_value  : std_ulogic;
		port_type_is_multiport            : std_ulogic;
		advertise_1000base_t_fd           : std_ulogic;
		advertise_1000base_t_hd           : std_ulogic;
	end record;

	type t_master_slave_status_register is record
		master_slave_config_fault      : std_ulogic;
		master_slave_config_resolution : std_ulogic;
		local_receiver_status          : std_ulogic;
		remote_receiver_status         : std_ulogic;
		lp_1000base_t_fd               : std_ulogic;
		lp_1000base_t_hd               : std_ulogic;
		idle_error_count               : unsigned(7 downto 0);
	end record;

	constant AUTO_NEGOTATION_802_3_SELECTOR : std_ulogic_vector(4 downto 0) := "00001";

	-- Selected conversion functions
	-- Register records to 16-bit data values
	function control_register_to_data(reg : in t_control_register) return t_data;
	function auto_negotiation_advertisement_register_802_3_to_data(reg : in t_auto_negotiation_advertisement_register_802_3) return t_data;
	function master_slave_control_register_to_data(reg : in t_master_slave_control_register) return t_data;

	-- 16-bit data values to registers
	function data_to_status_register(data : in t_data) return t_status_register;
	function data_to_master_slave_status_register(data : in t_data) return t_master_slave_status_register;
	function data_to_auto_negotiation_lp_base_page_ability_register(data : in t_data) return auto_negotiation_lp_base_page_ability_register_802_3_t;

end package;

package body miim_registers is
	function control_register_to_data(reg : in t_control_register) return t_data is
		variable data : t_data;
	begin
		data := (
				15     => reg.reset,
				14     => reg.loopback,
				13     => reg.speed_10_100,
				12     => reg.auto_negotiation_enable,
				11     => reg.power_down,
				10     => reg.isolate,
				9      => reg.restart_auto_negotiation,
				8      => reg.duplex_mode,
				7      => reg.enable_collision_test,
				6      => reg.speed_1000,
				5      => reg.unidirectional_enable,
				others => '0'
			);
		return data;
	end function;

	function auto_negotiation_advertisement_register_802_3_to_data(reg : in t_auto_negotiation_advertisement_register_802_3) return t_data is
		variable data : t_data;
	begin
		data := (
				15     => reg.next_page,
				13     => reg.remote_fault,
				12     => reg.extended_next_page,
				11     => reg.asymmetric_pause,
				10     => reg.pause,
				9      => reg.advertise_100base_t4,
				8      => reg.advertise_100base_tx_fd,
				7      => reg.advertise_100base_tx_hd,
				6      => reg.advertise_10base_t_fd,
				5      => reg.advertise_10base_t_hd,
				others => '0'
			);
		data(4 downto 0) := AUTO_NEGOTATION_802_3_SELECTOR;
		return data;
	end function;

	function master_slave_control_register_to_data(reg : in t_master_slave_control_register) return t_data is
		variable data : t_data;
	begin
		data := (
				12     => reg.master_slave_manual_config_enable,
				11     => reg.master_slave_manual_config_value,
				10     => reg.port_type_is_multiport,
				9      => reg.advertise_1000base_t_fd,
				8      => reg.advertise_1000base_t_hd,
				others => '0'
			);
		data(15 downto 13) := reg.test_mode_bits;
		return data;
	end function;

	function data_to_status_register(data : in t_data) return t_status_register is
		variable status : t_status_register;
	begin
		status := (
				can_100base_t4            => data(15),
				can_100base_x_fd          => data(14),
				can_100base_x_hd          => data(13),
				can_10mbps_fd             => data(12),
				can_10mbps_hd             => data(11),
				can_100base_t2_fd         => data(10),
				can_100base_t2_hd         => data(9),
				extended_status           => data(8),
				undirectional_ability     => data(7),
				mf_preamble_suppression   => data(6),
				auto_negotiation_complete => data(5),
				remote_fault              => data(4),
				auto_negotiation_ability  => data(3),
				link_status               => data(2),
				jabber_detect             => data(1),
				extended_capability       => data(0)
			);
		return status;
	end function;

	function data_to_master_slave_status_register(data : in t_data) return t_master_slave_status_register is
		variable status : t_master_slave_status_register;
	begin
		status := (
				master_slave_config_fault      => data(15),
				master_slave_config_resolution => data(14),
				local_receiver_status          => data(13),
				remote_receiver_status         => data(12),
				lp_1000base_t_fd               => data(11),
				lp_1000base_t_hd               => data(10),
				idle_error_count               => unsigned(data(7 downto 0))
			);
		return status;
	end function;

	function data_to_auto_negotiation_lp_base_page_ability_register(data : in t_data) return auto_negotiation_lp_base_page_ability_register_802_3_t is
		variable ability : auto_negotiation_lp_base_page_ability_register_802_3_t;
	begin
		ability := (
				next_page          => data(15),
				acknowledge        => data(14),
				remote_fault       => data(13),
				extended_next_page => data(12),
				asymmetric_pause   => data(11),
				pause              => data(10),
				can_100base_t4     => data(9),
				can_100base_tx_fd  => data(8),
				can_100base_tx_hd  => data(7),
				can_10base_t_fd    => data(6),
				can_10base_t_hd    => data(5)
			);
		return ability;
	end function;

end package body;
