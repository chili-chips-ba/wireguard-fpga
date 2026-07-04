#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Combinational (zero pipeline stages) native Pypeline sim (no cocotb/ghdl) of
# the shared encrypt+decrypt design testbench (both side testbenches run at
# once). $PIPELINEC must point at PipelineC/src/pipelinec.
# NOTE: this sim takes much longer than the standalone ones.

rm -rf ./generated-files-sim-comb-shared-native/*
$PIPELINEC ./src/chacha20poly1305_encrypt_decrypt_shared_tb.py --out_dir ./generated-files-sim-comb-shared-native --comb --sim --run 150
