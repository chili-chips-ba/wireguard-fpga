#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Full build (autopipelining via synthesis tool) of the standalone decrypt
# hardware top to Verilog. $PIPELINEC must point at PipelineC/src/pipelinec.

rm -rf ./generated-files-verilog-decrypt/*
$PIPELINEC ./src/chacha20poly1305_decrypt.py --out_dir ./generated-files-verilog-decrypt --top chacha20poly1305_decrypt --verilog
