# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause
#
# Constraints for nextpnr only, appended to the port lines of
# 1.hw/constraints/top.xdc (see the Makefile).
#
# nextpnr needs both pins of a differential input. Vivado places clk_n from
# clk_p (R4); nextpnr does not. T4 is R4's pair: IO_L13N_T2_MRCC_34.
set_property PACKAGE_PIN T4 [get_ports clk_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_n]
