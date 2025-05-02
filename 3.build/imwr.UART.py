#=============================================================
# Copyright (C) 2024-2025 Chili.CHIPS*ba
#-------------------------------------------------------------
# Script that sends data to DMEM/CSR bus via UART
#=============================================================

import textwrap
import serial
import struct
import time

ComPort = serial.Serial('/dev/ttyUSB0')
#ComPort = serial.Serial('COM3')
ComPort.baudrate = 115200               # set Baud rate to 115200, fixed on FPGA side
ComPort.bytesize = serial.EIGHTBITS     # Number of data bits = 8
ComPort.parity   = serial.PARITY_NONE   # No parity
ComPort.stopbits = serial.STOPBITS_ONE  # Number of Stop bits = 1
ComPort.timeout  = 1

ot = ComPort.write(struct.pack('B', int(0x12)))          #Start Of Packet (DC2)
print("SOP:   ", hex(0x12))

ot = ComPort.write(struct.pack('B', int(0x08)))          #CMD 0x08 enter IMEM write-single-instruction data mode
print("CMD:   ", hex(0x08))

#change 000f47b7 -> 0000f7b7 @ 07c0

ot = ComPort.write(struct.pack('B', int(0xc0)))          #ADDR0
print("ADDR0: ", hex(0xc0))

ot = ComPort.write(struct.pack('B', int(0x07)))          #ADDR1
print("ADDR1: ", hex(0x07))

ot = ComPort.write(struct.pack('B', int(0xb7)))          #DATA0
print("DATA0: ", hex(0xb7))

ot = ComPort.write(struct.pack('B', int(0xf7)))          #DATA1
print("DATA1: ", hex(0xf7))

ot = ComPort.write(struct.pack('B', int(0x00)))          #DATA2
print("DATA2: ", hex(0x00))

ot = ComPort.write(struct.pack('B', int(0x00)))          #DATA3
print("DATA3: ", hex(0x00))

checksum = 0xc8 + 0x07 + 0xb7 + 0xf7 + 0x00 + 0x00;
checksum = int(checksum & 0xFF)
print("ECS:   ", hex(checksum))

it1 = (ComPort.read(1))                                  #for receiving checksum from FPGA
print(f"RCS:    {hex(int.from_bytes(it1, byteorder='big'))}")

ot = ComPort.write(struct.pack('B', int(0x14)))          #End Of Packet (DC4)
print("EOP:   ", hex(0x14))

ComPort.close()                          # Close the Com port

#=============================================================
# End-of-File
#=============================================================
