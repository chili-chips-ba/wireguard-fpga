#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Combinational (zero pipeline stages) GHDL/cocotb sim of the shared
# encrypt+decrypt design testbench (both side testbenches run at once).
# $PIPELINEC must point at PipelineC/src/pipelinec.
# NOTE: this sim takes much longer than the standalone ones.

rm -rf ./generated-files-sim-comb-shared/*
$PIPELINEC ./src/chacha20poly1305_encrypt_decrypt_shared_tb.py --out_dir ./generated-files-sim-comb-shared --comb --sim --cocotb --ghdl --run 650
