#=============================================================
# Copyright (C) 2024-2025 Chili.CHIPS*ba
#-------------------------------------------------------------
# Script that receives data from DMEM/CSR bus via UART
#=============================================================

import textwrap
import serial
import struct
import time

def hex_dump(data: bytes, length: int, width: int = 16):
    length = min(length, len(data))
    for i in range(0, length, width):
        chunk = data[i:min(i + width, length)]
        hex_bytes = ' '.join(f"{b:02x}" for b in chunk)
        ascii_bytes = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
        print(f"{i:08x}  {hex_bytes:<{width*3}}  {ascii_bytes}")

ComPort = serial.Serial('/dev/ttyUSB0')
#ComPort = serial.Serial('COM3')
ComPort.baudrate = 115200               # set Baud rate to 115200, fixed on FPGA side
ComPort.bytesize = serial.EIGHTBITS     # Number of data bits = 8
ComPort.parity   = serial.PARITY_NONE   # No parity
ComPort.stopbits = serial.STOPBITS_ONE  # Number of Stop bits = 1
ComPort.timeout  = 1

#------------------------------
# Begin communication
#------------------------------

ot = ComPort.write(struct.pack('B', int(0x12)))          #Start Of Packet (DC2)
print(f"SOP:  {0x12:#0{4}x}")

#------------------------------
# Dump DPE routing info
#------------------------------

ot = ComPort.write(struct.pack('B', int(0x07)))          #CMD 0x07 enter DMEM/CSR read data mode
print(f"CMD:  {0x07:#0{4}x}", end = ";  ")

ot = ComPort.write(struct.pack('<I', int(0x10000800)))   #ADDR
print(f"ADDR: {0x10000800:#0{10}x}", end = ";  ")

data = (ComPort.read(4))                                 #for receiving DATA from FPGA
print(f"DATA: {int.from_bytes(data, byteorder='little'):#0{10}x}", end = ";  ")

it1 = (ComPort.read(1))                                  #for receiving checksum from FPGA
print(f"RCS:  {int.from_bytes(it1, byteorder='little'):#0{4}x}")

packet_dst = int(int.from_bytes(data, byteorder='little') & 0xFF);
packet_src = int((int.from_bytes(data, byteorder='little') >> 8) & 0xFF);
packet_bypass_stage = (int.from_bytes(data, byteorder='little') >> 16) & 0xFF;
packet_bypass_all = (int.from_bytes(data, byteorder='little') >> 24) & 0xFF;

print(f"packet->dst:          {packet_dst}")
print(f"packet->src:          {packet_src}")
print(f"packet->bypass_stage: {packet_bypass_stage}")
print(f"packet->bypass_all:   {packet_bypass_all}")

#------------------------------
# Dump packet length
#------------------------------

ot = ComPort.write(struct.pack('B', int(0x07)))          #CMD 0x07 enter DMEM/CSR read data mode
print(f"CMD:  {0x07:#0{4}x}", end = ";  ")

ot = ComPort.write(struct.pack('<I', int(0x10000804)))   #ADDR
print(f"ADDR: {0x10000804:#0{10}x}", end = ";  ")

data = (ComPort.read(4))                                 #for receiving DATA from FPGA
print(f"DATA: {int.from_bytes(data, byteorder='little'):#0{10}x}", end = ";  ")

it1 = (ComPort.read(1))                                  #for receiving checksum from FPGA
print(f"RCS:  {int.from_bytes(it1, byteorder='little'):#0{4}x}")

packet_len = int.from_bytes(data, byteorder='little');

print(f"packet->len:          {packet_len}")


#------------------------------
# Dump packet payload
#------------------------------
packet_payload = bytearray()

for i in range(0, packet_len, 4):
   ot = ComPort.write(struct.pack('B', int(0x07)))          #CMD 0x07 enter DMEM/CSR read data mode
   print(f"CMD:  {0x07:#0{4}x}", end = ";  ")
   
   ot = ComPort.write(struct.pack('<I', int(0x10000808 + i)))   #ADDR
   print(f"ADDR: {(0x10000804 + i):#0{10}x}", end = ";  ")
   
   data = (ComPort.read(4))                                 #for receiving DATA from FPGA
   print(f"DATA: {int.from_bytes(data, byteorder='big'):#0{10}x}", end = ";  ")
     
   it1 = (ComPort.read(1))                                  #for receiving checksum from FPGA
   print(f"RCS:  {int.from_bytes(it1, byteorder='little'):#0{4}x}")
   
   packet_payload += bytearray(data)

print("packet->payload:")
hex_dump(packet_payload, length = packet_len)

#------------------------------
# End communication
#------------------------------

ot = ComPort.write(struct.pack('B', int(0x14)))          #End Of Packet (DC4)
print(f"EOP:  {0x14:#0{4}x}")

ComPort.close()                          # Close the Com port

#=============================================================
# End-of-File
#=============================================================
