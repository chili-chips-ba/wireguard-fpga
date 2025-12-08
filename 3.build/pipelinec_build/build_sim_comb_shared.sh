#!/bin/bash

rm -rf ./generated-files-sim-comb-shared/*
rm -f ./*.py
$PIPELINEC ./src/chacha20poly1305_encrypt_decrypt_shared_tb.c --out_dir ./generated-files-sim-comb-shared --comb --sim --cocotb --ghdl --run 75
