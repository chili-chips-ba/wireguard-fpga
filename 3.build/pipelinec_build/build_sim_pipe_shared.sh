#!/bin/bash

rm -rf ./generated-files-sim-pipe-shared/*
rm ./*.py
$PIPELINEC ./src/chacha20poly1305_encrypt_decrypt_shared_tb.c --out_dir ./generated-files-sim-pipe-shared --sim --cocotb --ghdl --run 250
