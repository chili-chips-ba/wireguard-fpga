#!/bin/bash

rm -rf ./generated-files-sim-pipe/*
rm ./*.py
$PIPELINEC ./src/chacha20poly1305_encrypt_tb.c --out_dir ./generated-files-sim-pipe --sim --cocotb --ghdl --run 250
