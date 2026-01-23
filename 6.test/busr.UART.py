# Copyright (C) 2024-2025 Chili.CHIPS*ba
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba, 2024-2025
#
# SPDX-License-Identifier: BSD-3-Clause

import textwrap
import serial
import struct
import time

C_SOP  = 0x12                           # Enter special mode
C_EOP  = 0x14                           # Exit special mode
C_IMPR = 0x05                           # Enter IMEM programming mode
C_ACK  = 0x06                           # ACK for IMEM programming mode
C_TOUT = 0x07                           # Timeout in IMEM programming mode
C_BUSW = 0x0E                           # Enter DMEM/CSR write data mode
C_BUSR = 0x0F                           # Enter DMEM/CSR read data mode
C_IMWR = 0x1A                           # Enter IMEM write-single-instruction mode

ComPort = serial.Serial('/dev/ttyUSB0')
#ComPort = serial.Serial('COM3')
ComPort.baudrate = 115200               # set Baud rate to 115200, fixed on FPGA side
ComPort.bytesize = serial.EIGHTBITS     # Number of data bits = 8
ComPort.parity   = serial.PARITY_NONE   # No parity
ComPort.stopbits = serial.STOPBITS_ONE  # Number of Stop bits = 1
ComPort.timeout  = 1

ot = ComPort.write(struct.pack('B', int(C_SOP)))         #Send C_SOP to FPGA
print("SOP:   ", hex(C_SOP))

ot = ComPort.write(struct.pack('B', int(0x0F)))          #Send C_BUSR enter DMEM/CSR read data mode
print("CMD:   ", hex(0x0F))

ot = ComPort.write(struct.pack('B', int(0x48)))          #Send ADDR0 to FPGA
print("ADDR0: ", hex(0x48))

ot = ComPort.write(struct.pack('B', int(0x00)))          #Send ADDR1 to FPGA
print("ADDR1: ", hex(0x00))

ot = ComPort.write(struct.pack('B', int(0x00)))          #Send ADDR2 to FPGA
print("ADDR2: ", hex(0x00))

ot = ComPort.write(struct.pack('B', int(0x20)))          #Send ADDR3 to FPGA
print("ADDR3: ", hex(0x20))

it1 = (ComPort.read(1))                                  #Receive DATA0 from FPGA
print(f"DATA0:  {hex(int.from_bytes(it1, byteorder='big'))}")

it2 = (ComPort.read(1))                                  #Receive DATA1 from FPGA
print(f"DATA1:  {hex(int.from_bytes(it2, byteorder='big'))}")

it3 = (ComPort.read(1))                                  #Receive DATA2 from FPGA
print(f"DATA2:  {hex(int.from_bytes(it3, byteorder='big'))}")

it4 = (ComPort.read(1))                                  #Receive DATA3 from FPGA
print(f"DATA3:  {hex(int.from_bytes(it4, byteorder='big'))}")

checksum = 0x48 + 0x00 + 0x00 + 0x20 + int.from_bytes(it1, byteorder='big') + int.from_bytes(it2, byteorder='big') + int.from_bytes(it3, byteorder='big') + int.from_bytes(it4, byteorder='big');
checksum = int(checksum & 0xFF)
print("ECS:   ", hex(checksum))

it1 = (ComPort.read(1))                                  #Receive checksum from FPGA
print(f"RCS:    {hex(int.from_bytes(it1, byteorder='big'))}")

ot = ComPort.write(struct.pack('B', int(C_EOP)))         #Send C_EOP to FPGA
print("EOP:   ", hex(C_EOP))

ComPort.close()

#=============================================================
# End-of-File
#=============================================================
