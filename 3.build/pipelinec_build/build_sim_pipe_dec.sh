#!/bin/bash

rm -rf ./generated-files-sim-pipe/*
rm ./*.py
$PIPELINEC ./src/chacha20poly1305_decrypt_tb.c --out_dir ./generated-files-sim-pipe-dec --sim --cocotb --ghdl --run 250
