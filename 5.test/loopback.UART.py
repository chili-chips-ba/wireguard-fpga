# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba, 2024-2025
#
# SPDX-License-Identifier: BSD-3-Clause

import serial
import time

SERIAL_PORT = '/dev/ttyUSB0'
BAUD_RATE = 115200
TIMEOUT = 1
NUM_REPEATS = 1000 
BLOCK_LENGTH = 500

BYTESIZE = serial.EIGHTBITS
PARITY = serial.PARITY_NONE
STOPBITS = serial.STOPBITS_ONE

def create_test_block(length):
    base_seq = [chr(c) for c in range(ord('A'), ord('Z') + 1)]
    full_seq = (base_seq * ((length // len(base_seq)) + 1))[:length]
    return [ch.encode('ascii') for ch in full_seq]

def main():
    test_block = create_test_block(BLOCK_LENGTH)

    try:
        with serial.Serial(
            port=SERIAL_PORT,
            baudrate=BAUD_RATE,
            timeout=TIMEOUT,
            bytesize=BYTESIZE,
            parity=PARITY,
            stopbits=STOPBITS
        ) as ser:

            for i in range(NUM_REPEATS):
                print(f'\nIteration {i+1}/{NUM_REPEATS}')

                for ch in test_block:
                    ser.write(ch)

                response = ser.read(BLOCK_LENGTH)

                expected = b''.join(test_block)

                if response != expected:
                    print(f'  ERROR: Mismatch in received block.')
                    print(f'  Sent:     {expected}')
                    print(f'  Received: {response}')
                    print(f'  Received length: {len(response)}')
                    print('Stopping further transmission.')
                    break
                else:
                    print(f'  SUCCESS: Block received correctly.')

    except serial.SerialException as e:
        print(f'Failed to open serial port {SERIAL_PORT}: {e}')

if __name__ == '__main__':
    main()
