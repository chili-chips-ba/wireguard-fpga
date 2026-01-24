// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

module ethernet_phy (
	e1_reset,
	e1_mdc,
	e1_mdio,
	e2_reset,
	e2_mdc,
	e2_mdio,
	e3_reset,
	e3_mdc,
	e3_mdio,
	e4_reset,
	e4_mdc,
	e4_mdio
);
	output wire e1_reset;
	output wire e1_mdc;
	inout wire e1_mdio;
	output wire e2_reset;
	output wire e2_mdc;
	inout wire e2_mdio;
	output wire e3_reset;
	output wire e3_mdc;
	inout wire e3_mdio;
	output wire e4_reset;
	output wire e4_mdc;
	inout wire e4_mdio;
	assign e1_reset = 1'b1;
	assign e2_reset = 1'b1;
	assign e3_reset = 1'b1;
	assign e4_reset = 1'b1;
endmodule