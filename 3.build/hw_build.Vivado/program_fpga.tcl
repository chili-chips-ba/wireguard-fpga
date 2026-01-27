# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
# 
# SPDX-License-Identifier: BSD-3-Clause

# Open a new hardware target
open_hw_manager
connect_hw_server
open_hw_target

# Get the first hardware device in the chain (adjust if multiple devices exist)
set device [lindex [get_hw_devices] 0]

# Set the property of the device to the desired bitfile
set_property PROGRAM.FILE {wireguard.runs/impl_1/top.bit} $device

# Program the hardware device
program_hw_devices $device

# Close the hardware manager (optional)
close_hw_manager
