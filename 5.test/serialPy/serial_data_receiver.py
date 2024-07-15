#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#-------------------------------------------------------------
# Simple script for receiving data from UART, to Windows PC
#=============================================================

import serial
import time

# Serial port configuration
#ser = serial.Serial('COM10', 115200, 8, 'N', 1)
ser = serial.Serial('COM5',  115200, 8, 'N', 1)
#set = serial.Serial('/dev/ttyUSB1') # open COM24 on Linux

#ser.baudrate = 115200              # Baud rate is fixed on FPGA side
#ser.bytesize = serial.EIGHTBITS    # Number of data bits = 8
#ser.parity   = serial.PARITY_NONE  # No parity
#ser.stopbits = serial.STOPBITS_ONE # Number of Stop bits = 1

try:
    while True:
        # Wait for incoming data
        if ser.in_waiting > 0:
            # Read data from the serial port
            received_data = ser.read(ser.in_waiting)

            # Display bytes in both Hex and ASCII format
            print("Received data(HEX)  :", received_data.hex())  
            print("Received data(ASCII):", received_data)

except KeyboardInterrupt:
    pass

finally:
    ser.close()  # Close the serial port upon program completion

#=============================================================
# End-of-File
#=============================================================
    
