# Copyright (C) 2024-2025 Chili.CHIPS*ba
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba, 2024-2025
#
# SPDX-License-Identifier: BSD-3-Clause

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
        print(f"{i:04x}  {hex_bytes:<{width*3}}  {ascii_bytes}")

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

address = 0x10000018

#------------------------------
# Begin communication
#------------------------------

ot = ComPort.write(struct.pack('B', int(C_SOP)))                                 #Send C_SOP to FPGA
print(f">> SOP: {C_SOP:#0{4}x}")

#------------------------------
# Dump DPE routing info
#------------------------------

ot = ComPort.write(struct.pack('B', int(C_BUSR)))                                #Send C_BUSR to enter DMEM/CSR read data mode
print(f">> CMD: {C_BUSR:#0{4}x}", end = "  ")

ot = ComPort.write(struct.pack('<I', int(address)))                              #Send ADDR in DMEM to packet
print(f"ADDR: {address:#0{10}x}", end = "  ")

data = (ComPort.read(4))                                                         #Receive DATA from FPGA
print(f"<< DATA: {int.from_bytes(data, byteorder='little'):#0{10}x}", end = "  ")

it1 = (ComPort.read(1))                                                          #for receiving checksum from FPGA
print(f"RCS: {int.from_bytes(it1, byteorder='little'):#0{4}x}")

packet_dst = int(int.from_bytes(data, byteorder='little') & 0xFF);
packet_src = int((int.from_bytes(data, byteorder='little') >> 8) & 0xFF);
packet_bypass_stage = (int.from_bytes(data, byteorder='little') >> 16) & 0xFF;
packet_bypass_all = (int.from_bytes(data, byteorder='little') >> 24) & 0xFF;

print(f"packet.dst:          {packet_dst}")
print(f"packet.src:          {packet_src}")
print(f"packet.bypass_stage: {packet_bypass_stage}")
print(f"packet.bypass_all:   {packet_bypass_all}")

#------------------------------
# Dump packet length
#------------------------------

ot = ComPort.write(struct.pack('B', int(C_BUSR)))                                #Send C_BUSR to enter DMEM/CSR read data mode
print(f">> CMD: {C_BUSR:#0{4}x}", end = "  ")

ot = ComPort.write(struct.pack('<I', int(address + 4)))                          #Send ADDR in DMEM to packet.len
print(f"ADDR: {(address + 4):#0{10}x}", end = "  ")

data = (ComPort.read(4))                                                         #Receive DATA from FPGA
print(f"<< DATA: {int.from_bytes(data, byteorder='little'):#0{10}x}", end = "  ")

it1 = (ComPort.read(1))                                                          #Receive checksum from FPGA
print(f"RCS: {int.from_bytes(it1, byteorder='little'):#0{4}x}")

packet_len = int.from_bytes(data, byteorder='little');

print(f"packet.len:          {packet_len}")


#------------------------------
# Dump packet payload
#------------------------------
packet_payload = bytearray()

for i in range(0, packet_len, 4):
   ot = ComPort.write(struct.pack('B', int(C_BUSR)))                             #Send C_BUSR to enter DMEM/CSR read data mode
   print(f">> CMD: {C_BUSR:#0{4}x}", end = "  ")
   
   ot = ComPort.write(struct.pack('<I', int(address + 8 + i)))                   #Send ADDR in DMEM to packet.payload
   print(f"ADDR: {(address + 8 + i):#0{10}x}", end = "  ")
   
   data = (ComPort.read(4))                                                      #Receive DATA from FPGA
   print(f"<< DATA: {int.from_bytes(data, byteorder='big'):#0{10}x}", end = "  ")
     
   it1 = (ComPort.read(1))                                                       #Receive checksum from FPGA
   print(f"RCS: {int.from_bytes(it1, byteorder='little'):#0{4}x}")
   
   packet_payload += bytearray(data)

print("packet.payload:")
hex_dump(packet_payload, length = packet_len)

#------------------------------
# End communication
#------------------------------

ot = ComPort.write(struct.pack('B', int(C_EOP)))                                 #Send C_EOP to FPGA
print(f">> EOP: {C_EOP:#0{4}x}")

ComPort.close()

#=============================================================
# End-of-File
#=============================================================
