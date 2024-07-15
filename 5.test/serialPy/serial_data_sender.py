#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#-------------------------------------------------------------
# Simple script for sending data to UART, from Windows PC
#=============================================================

import serial
import time

# Serial port configuration
#ser = serial.Serial('COM10', 115200, 8, 'N', 1)
ser = serial.Serial('COM5', 115200, 8, 'N', 1)

#ser.baudrate = 115200              # Baud rate is fixed on FPGA side
#ser.bytesize = serial.EIGHTBITS    # Number of data bits = 8
#ser.parity   = serial.PARITY_NONE  # No parity
#ser.stopbits = serial.STOPBITS_ONE # Number of Stop bits = 1


try:
    # Modify this according to the data you need to send:
    # --for UART_TEST:
    #data_to_send = b'Mi smo FPGA raja\r\n'
    #data_to_send = b'Mi nismo mehke koze\n'

    # --for CMD Parsing:
    #data_to_send = b'$1,5000\r\n'
    data_to_send = b'$2,1234,1\r\n'

     # send_string ("$3,10,5\r\n");   // DAC#1
     # send_string ("$4,23,73\r\n");  // DAC#2
     #  
     # send_string ("$1,0,0\r\n");    // ADC#1.Corner1
     # send_string ("$2,1,0\r\n");    // ADC#2.Corner2
     #  
     # send_string ("$3,100,10\r\n"); // DAC#1
     # send_string ("$4,3,11\r\n");   // DAC#2
     #  
     # send_string ("$1,3,1\r\n");    // ADC#1
     # send_string ("$2,11,1\r\n");   // ADC#2

    # Sending data
    ser.write(data_to_send)

    print(f"Sent data: {data_to_send}")

except KeyboardInterrupt:
    pass

finally:
    ser.close()  # Close the serial port upon program completion

#=============================================================
# End-of-File
#=============================================================
