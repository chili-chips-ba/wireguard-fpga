#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

rm -rf ./generated-files-verilog/*
rm ./*.py
$PIPELINEC ./src/chacha20poly1305_encrypt.c --out_dir ./generated-files-verilog --top chacha20poly1305_encrypt --verilog
