#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#-------------------------------------------------------------
# Script that generates Verilog IMEM contents file for the
# compiled RISC-V 'C' program
#=============================================================

#-------------------------
# 2 modes:
#   1. Default: load main.hex from 3.build
#   2. Tests  : load <tst>.hex from 4.sim
import os
import sys
import struct

inp_file = 'sw_build/main.hex'
out_dir  = './'

if len(sys.argv) == 2:
    inp_file = sys.argv[1]
    out_dir = '../3.build/'
    print("Loading file: "+ sys.argv[1])


out_file = os.path.join(out_dir, 'imem.INIT.vh')
imem_text = ''

def extract_mem_bytes(file_path):
    addr = 0
    imem_values = []
    dmem_values = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('@'):
                continue # Data is separated by @
            hex_temp = line.strip().split()
            # IMEM bytes
            for i in range(0, len(hex_temp), 4):
                hex_sublist = hex_temp[i:i+4]
                hex_sublist.reverse()
                imem_values.extend(hex_sublist)

    return imem_values
file_path = inp_file
imem_values = extract_mem_bytes(file_path)

addr = 0
# Writing to the output file
try:
    with open(out_file, 'w') as imem_SW_file:

        for i in range(0, len(imem_values), 4):
            value = imem_values[i] + imem_values[i+1] + imem_values[i+2] + imem_values[i+3]
            imem_text += f"mem[\'h{addr:04X}] = 32\'h{value};\n"
            #print("Writing to file: " + imem_text + "\n")
            addr += 1
        imem_SW_file.write(imem_text)
except Exception as e:
    print(f"Write file Exception: {e}")
    sys.exit(-1)

print(f"Bin file size: {addr*4} bytes")