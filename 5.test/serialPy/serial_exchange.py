#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#-------------------------------------------------------------
# Simple script for sending/receiving data from UART, to Windows PC
# Based on: https://github.com/ZulNs/SerialMonitor/tree/main
#=============================================================
import serial
import time

# Serial port configuration
#ser = serial.Serial('COM10', 115200, 8, 'N', 1)
ser = serial.Serial('COM5', 115200, 8, 'N', 1)

ser.flushInput()
ser.flushOutput()


def receive():
    # Check for incoming data
    if ser.in_waiting > 0:
        # Read data from the serial port
        received_data = ser.read(ser.in_waiting)

        # Display bytes in both Hex and ASCII format
        #print("\nReceived data (HEX)  :", received_data.hex())  
        print("\nReceived data (ASCII):", received_data)


try:
    while True:

        # Prompt user for data to send
        data_to_send = input("\nEnter data to send: ") + '\r\n'
        ser.write(data_to_send.encode('utf-8'))
        #print(f"Sent data: {data_to_send}")

        receive()

except KeyboardInterrupt:
    pass

finally:
    ser.close()  # Close the serial port upon program completion

#=============================================================
# End-of-File
#=============================================================
