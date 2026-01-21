#=============================================================
# Copyright (C) 2026 Chili.CHIPS*ba
#-------------------------------------------------------------
# Script that sends to UART contents to write into IMEM file
#  for the compiled RISC-V 'C' program
#=============================================================

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
ComPort.timeout  = 0.5

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

ot = ComPort.write(struct.pack('B', int(C_SOP)))         #Send C_SOP to FPGA
print("SOP:   ", hex(C_SOP))

ot = ComPort.write(struct.pack('B', int(C_IMPR)))        #Send C_IMPR to enter IMEM programming mode
print("CMD:   ", hex(C_IMPR))

it1 = ComPort.read(32)                                   #Receive residual data from FIFO

ot = ComPort.write(struct.pack('B', int(length & 0xFF))) #Send LowByte Length of DATA to FPGA
print("LEN1:  ", hex(length & 0xFF))

ot = ComPort.write(struct.pack('B', int(length >> 8)))   #Send HighByte Length of DATA to FPGA
print("LEN2:  ", hex(length >> 8))

#checksum = 0
checksum = int(length & 0xFF) + int((length >> 8) & 0xFF)

i = 0
for li in str32:
   i = i + 1
   outfile.write(li)
   outfile.write("\n")

   checksum = checksum + int(li[6:8], 16)
   ot = ComPort.write(struct.pack('B', int(li[6:8], 16)))  #Send DATA0 to FPGA
   print(f'{i:4d}_0: {li[6:8]:2}')

   checksum = checksum + int(li[4:6], 16)
   ot = ComPort.write(struct.pack('B', int(li[4:6], 16)))  #Send DATA1 to FPGA
   print(f'{i:4d}_1: {li[4:6]:2}')

   checksum = checksum + int(li[2:4], 16)
   ot = ComPort.write(struct.pack('B', int(li[2:4], 16)))  #Send DATA2 to FPGA
   print(f'{i:4d}_2: {li[2:4]:2}')

   checksum = checksum + int(li[0:2], 16)
   ot = ComPort.write(struct.pack('B', int(li[0:2], 16)))  #Send DATA3 to FPGA
   print(f'{i:4d}_3: {li[0:2]:2}')

   it1 = (ComPort.read(1))                                 #Receive ACK from FPGA
   print(f"ACK:    {hex(int.from_bytes(it1, byteorder='big'))}")
   if (int.from_bytes(it1, byteorder='big') != C_ACK):
      break


checksum = int(checksum & 0xFF)
print("ECS:   ", hex(checksum))

it1 = (ComPort.read(1))                                   #Receive checksum from FPGA
print(f"RCS:    {hex(int.from_bytes(it1, byteorder='big'))}")

ot = ComPort.write(struct.pack('B', int(C_EOP)))          #Send C_EOP to FPGA
print("EOP:   ", hex(C_EOP))

infile.close()
outfile.close()

ComPort.close()

#=============================================================
# End-of-File
#=============================================================
