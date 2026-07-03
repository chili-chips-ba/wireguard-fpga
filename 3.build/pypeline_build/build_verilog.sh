#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Full build (autopipelining via synthesis tool) of the standalone encrypt
# hardware top to Verilog. $PIPELINEC must point at PipelineC/src/pipelinec.

rm -rf ./generated-files-verilog/*
$PIPELINEC ./src/chacha20poly1305_encrypt.py --out_dir ./generated-files-verilog --top chacha20poly1305_encrypt --verilog
