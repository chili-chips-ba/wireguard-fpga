#=============================================================
# Copyright (C) 2024-2025 Chili.CHIPS*ba
#-------------------------------------------------------------
# Script that sends data to DMEM/CSR bus via UART
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
ComPort.timeout  = 1

ot = ComPort.write(struct.pack('B', int(C_SOP)))         #Send C_SOP to FPGA
print("SOP:   ", hex(C_SOP))

ot = ComPort.write(struct.pack('B', int(C_IMWR)))        #Send C_IMWR to enter IMEM write-single-instruction data mode
print("CMD:   ", hex(C_IMWR))

#change 000f47b7 -> 0000f7b7 @ 07c0

ot = ComPort.write(struct.pack('B', int(0xc0)))          #Send ADDR0 to FPGA
print("ADDR0: ", hex(0xc0))

ot = ComPort.write(struct.pack('B', int(0x07)))          #Send ADDR1 to FPGA
print("ADDR1: ", hex(0x07))

ot = ComPort.write(struct.pack('B', int(0xb7)))          #Send DATA0 to FPGA
print("DATA0: ", hex(0xb7))

ot = ComPort.write(struct.pack('B', int(0xf7)))          #Send DATA1 to FPGA
print("DATA1: ", hex(0xf7))

ot = ComPort.write(struct.pack('B', int(0x00)))          #Send DATA2 to FPGA
print("DATA2: ", hex(0x00))

ot = ComPort.write(struct.pack('B', int(0x00)))          #Send DATA3 to FPGA
print("DATA3: ", hex(0x00))

checksum = 0xc0 + 0x07 + 0xb7 + 0xf7 + 0x00 + 0x00;
checksum = int(checksum & 0xFF)
print("ECS:   ", hex(checksum))

it1 = (ComPort.read(1))                                  #Receive checksum from FPGA
print(f"RCS:    {hex(int.from_bytes(it1, byteorder='big'))}")

ot = ComPort.write(struct.pack('B', int(C_EOP)))         #Send C_EOP to FPGA
print("EOP:   ", hex(C_EOP))

ComPort.close()                          # Close the Com port

#=============================================================
# End-of-File
#=============================================================
