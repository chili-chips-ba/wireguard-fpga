#=============================================================
# Copyright (C) 2024-2025 Chili.CHIPS*ba
#-------------------------------------------------------------
# Script that sends to UART contents to write into IMEM file
#  for the compiled RISC-V 'C' program
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

infile  = open('./sw_build/main.hex','r')
outfile = open('./sw_build/code.hex','w')
length  = 0
str32   = []

for lineno,line in enumerate(infile):
  if('@' in line):
    continue

  else:
    line = textwrap.wrap(line,12)

    for i in range(len(line)):
      li = line[i].replace(' ', '')
      invert = li[6:8] + li[4:6] + li[2:4] + li[0:2]
      str32.append(invert)
      length = length + 1

print("Length:", length)

ot = ComPort.write(struct.pack('B', int(0x12)))          #Start Of Packet (DC2)
print("SOP:   ", hex(0x12))

ot = ComPort.write(struct.pack('B', int(0x05)))          #CMD 0x05 enter IMEM programming mode
print("CMD:   ", hex(0x05))

ot = ComPort.write(struct.pack('B', int(length & 0xFF))) #LowByte Length of DATA
print("LEN1:  ", hex(length & 0xFF))

ot = ComPort.write(struct.pack('B', int(length >> 8)))   #HighByte Length of DATA
print("LEN2:  ", hex(length >> 8))

checksum = 0

i = 0
for li in str32:         #DATA
   i = i + 1
   outfile.write(li)
   outfile.write("\n")

   checksum = checksum + int(li[6:8], 16)
   ot = ComPort.write(struct.pack('B', int(li[6:8], 16)))
   print(f'{i:4d}_0: {li[6:8]:2}')
   
   checksum = checksum + int(li[4:6], 16)
   ot = ComPort.write(struct.pack('B', int(li[4:6], 16)))
   print(f'{i:4d}_1: {li[4:6]:2}')
   
   checksum = checksum + int(li[2:4], 16)
   ot = ComPort.write(struct.pack('B', int(li[2:4], 16)))
   print(f'{i:4d}_2: {li[2:4]:2}')
   
   checksum = checksum + int(li[0:2], 16)
   ot = ComPort.write(struct.pack('B', int(li[0:2], 16)))
   print(f'{i:4d}_3: {li[0:2]:2}')

   
checksum = int(checksum & 0xFF)
print("ECS:   ", hex(checksum))

it1 = (ComPort.read(1))                         #for receiving checksum from FPGA
print(f"RCS:    {hex(int.from_bytes(it1, byteorder='big'))}")

ot = ComPort.write(struct.pack('B', int(0x14))) #End Of Packet (DC4)
print("EOP:   ", hex(0x14))

infile.close()
outfile.close()

ComPort.close()                          # Close the Com port

#=============================================================
# End-of-File
#=============================================================
