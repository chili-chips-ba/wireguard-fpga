#!/bin/bash

rm -rf ./generated-files/*
rm ./*.py
$PIPELINEC ./src/chacha20poly1305_encrypt.c --out_dir ./generated-files --top chacha20poly1305_encrypt --verilog
