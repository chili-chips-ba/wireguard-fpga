// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause
//
// Yosys techmap for the openXC7 build (Makefile, after synth_xilinx):
// nextpnr-himbaechel has no BEL for BUFGMUX, so build it from what it has.
// A BUFGMUX is a BUFGCTRL used as a 2:1 clock mux (UG472): S0 = ~S, S1 = S,
// both clock enables on, no IGNORE (synchronous, glitch-free switch), I0
// selected out of configuration. verilog-ethernet's gmii_phy_if uses one per
// port to pick the MII TX clock at 10/100 Mb/s.

module BUFGMUX #(
    parameter CLK_SEL_TYPE = "SYNC"
) (
    output O,
    input  I0,
    input  I1,
    input  S
);
  wire s_n;

  INV s_inv (
      .I(S),
      .O(s_n)
  );

  BUFGCTRL #(
      .INIT_OUT    (0),
      .PRESELECT_I0("TRUE"),
      .PRESELECT_I1("FALSE")
  ) _TECHMAP_REPLACE_ (
      .O      (O),
      .I0     (I0),
      .I1     (I1),
      .S0     (s_n),
      .S1     (S),
      .CE0    (1'b1),
      .CE1    (1'b1),
      .IGNORE0(CLK_SEL_TYPE == "ASYNC"),
      .IGNORE1(CLK_SEL_TYPE == "ASYNC")
  );
endmodule
