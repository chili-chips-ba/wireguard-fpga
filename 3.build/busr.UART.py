#=============================================================
# Copyright (C) 2024-2025 Chili.CHIPS*ba
#-------------------------------------------------------------
# Script that receives data from DMEM/CSR bus via UART
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

ot = ComPort.write(struct.pack('B', int(0x07)))          #CMD 0x07 enter DMEM/CSR read data mode
print("CMD:   ", hex(0x07))

ot = ComPort.write(struct.pack('B', int(0x48)))          #ADDR0
print("ADDR0: ", hex(0x48))

ot = ComPort.write(struct.pack('B', int(0x00)))          #ADDR1
print("ADDR1: ", hex(0x00))

ot = ComPort.write(struct.pack('B', int(0x00)))          #ADDR2
print("ADDR2: ", hex(0x00))

ot = ComPort.write(struct.pack('B', int(0x20)))          #ADDR3
print("ADDR3: ", hex(0x20))

it1 = (ComPort.read(1))                                  #for receiving DATA0 from FPGA
print(f"DATA0:  {hex(int.from_bytes(it1, byteorder='big'))}")

it2 = (ComPort.read(1))                                  #for receiving DATA1 from FPGA
print(f"DATA1:  {hex(int.from_bytes(it2, byteorder='big'))}")

it3 = (ComPort.read(1))                                  #for receiving DATA2 from FPGA
print(f"DATA2:  {hex(int.from_bytes(it3, byteorder='big'))}")

it4 = (ComPort.read(1))                                  #for receiving DATA3 from FPGA
print(f"DATA3:  {hex(int.from_bytes(it4, byteorder='big'))}")

checksum = 0x48 + 0x00 + 0x00 + 0x20 + int.from_bytes(it1, byteorder='big') + int.from_bytes(it2, byteorder='big') + int.from_bytes(it3, byteorder='big') + int.from_bytes(it4, byteorder='big');
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
