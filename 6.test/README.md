<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba, 2024-2025

SPDX-License-Identifier: BSD-3-Clause
-->

## WireGuard Test Scripts

Here are the scripts for testing certain functionalities of the complete build (HW + SW) and for debugging:
- `loopback.UART.py` - For loopback testing of the UART controller and peripheral hardware (CP2102), the script generates data blocks consisting of repeating characters A–Z and sends them over the serial port to the FPGA. Once the data is received back from the FPGA, it is compared with the originally sent data to verify correctness.
- `imwr.UART.py` - For replacing a single instruction in IMEM (as described in the [UART Data Flow](/1.hw/README.md#uart-data-flow)), the script sends the C_IMWR command followed by a 4-byte address and a 4-byte instruction. This allows precise modification of the program in real time without resetting the CPU.
- `busr.UART.py` - Used for reading data from the DMEM/CSR address space (as described in the [UART Data Flow](/1.hw/README.md#uart-data-flow)). Includes an example of reading the GPIO register.
- `busw.UART.py` - Used for writing data to the DMEM/CSR address space (as described in the [UART Data Flow](/1.hw/README.md#uart-data-flow)). Includes an example of writing to the GPIO register.
- `dump_packet.UART.py` - For reading an entire Ethernet packet (structure `eth_raw_packet_t`) from DMEM, including both hexadecimal and textual display of the payload.