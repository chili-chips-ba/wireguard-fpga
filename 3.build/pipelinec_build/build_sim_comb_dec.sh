#!/bin/bash

rm -rf ./generated-files-sim-comb/*
rm -f ./*.py
$PIPELINEC ./src/chacha20poly1305_decrypt_tb.c --out_dir ./generated-files-sim-comb-dec --comb --sim --cocotb --ghdl --run 75


