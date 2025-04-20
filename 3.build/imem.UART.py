#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#-------------------------------------------------------------
# Script that sends to UART contents to write into IMEM file
#  for the compiled RISC-V 'C' program
#=============================================================

import textwrap
import serial
import struct
import time

#ComPort = serial.Serial('/dev/ttyUSB1') # open COM24
ComPort = serial.Serial('COM5')
ComPort.baudrate = 115200 # set Baud rate to 115200, fixed on FPGA side
ComPort.bytesize = serial.EIGHTBITS    # Number of data bits = 8
ComPort.parity   = serial.PARITY_NONE   # No parity
ComPort.stopbits = serial.STOPBITS_ONE  # Number of Stop bits = 1

infile  =open('./sw_build/main.hex','r')
outfile =open('./sw_build/code.hex','w')
length  = 0
str32   = []

for lineno,line in enumerate(infile):
  if('@' in line):
    continue

  else:
    line=textwrap.wrap(line,12)

    for i in range(len(line)):
      li = line[i].replace(' ', '')
      invert = li[6:8]+li[4:6]+li[2:4]+li[0:2]
      str32.append(invert)
      length = length + 1

print("length: ", length)
ot= ComPort.write(struct.pack('B', int(0x23)))        #Start Of Packet

print("SOP: ", hex(0x23))
ot= ComPort.write(struct.pack('B', int(0x07)))        #CMD 0x07 write to register, 0x08 read from register

print("CMD: ", hex(0x07))
ot= ComPort.write(struct.pack('B', int(length&0xFF))) #LowByte Length of DATA

print("LEN1: ", hex(length&0xFF))
ot= ComPort.write(struct.pack('B', int(length>>8)))   #HighByte Length of DATA

print("LEN2: ", hex(length>>8))

checksum = 0

i=0
for li in str32:         #DATA
   i = i + 1
   outfile.write(li)
   outfile.write("\n")

   ot= ComPort.write(struct.pack('B', int(li[6:8], 16)))
   checksum = checksum + int(li[6:8], 16)
   print(f'{i:4d}_0: {li[6:8]:2}')

   ot= ComPort.write(struct.pack('B', int(li[4:6], 16)))
   checksum = checksum + int(li[4:6], 16)
   print(f'{i:4d}_1: {li[4:6]:2}')

   ot= ComPort.write(struct.pack('B', int(li[2:4], 16)))
   checksum = checksum + int(li[2:4], 16)
   print(f'{i:4d}_2: {li[2:4]:2}')

   ot= ComPort.write(struct.pack('B', int(li[0:2], 16)))
   checksum = checksum + int(li[0:2], 16)
   print(f'{i:4d}_3: {li[0:2]:2}')

"""
ot= ComPort.write(struct.pack('B', 1))
checksum = checksum + 1
print(f'DATA1: ', hex(1))

ot= ComPort.write(struct.pack('B', 2))
checksum = checksum + 2
print(f'DATA2: ', hex(2))

ot= ComPort.write(struct.pack('B', 3))
checksum = checksum + 3
print(f'DATA3: ', hex(3))

ot= ComPort.write(struct.pack('B', 6))
checksum = checksum + 6
print(f'DATA4: ', hex(6))
"""

checksum = int(checksum&0xFF)
ot= ComPort.write(struct.pack('B', checksum))  #CheckSum
print(f'CS: ', hex(checksum))

ot= ComPort.write(struct.pack('B', int(0x0D))) #End Of Packet
print("EOP: ", hex(0x0D))

it1=(ComPort.read(1))                          #for receiving data from FPGA
print(f"END: {hex(int.from_bytes(it1, byteorder='big'))}")

infile.close()
outfile.close()

ComPort.close()         # Close the Com port

#=============================================================
# End-of-File
#=============================================================
