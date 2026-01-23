#!/bin/bash

rm -rf ./generated-files-verilog-decrypt/*
rm ./*.py
$PIPELINEC ./src/chacha20poly1305_decrypt.c --out_dir ./generated-files-verilog-decrypt --top chacha20poly1305_decrypt --verilog
