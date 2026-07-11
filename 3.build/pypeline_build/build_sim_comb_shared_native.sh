#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Combinational (zero pipeline stages) native Pypeline sim (no cocotb/ghdl) of
# the shared encrypt+decrypt design's non-synthesizable testbenches (both
# side testbenches run at once, @sim_input/@sim_output, on-the-fly random
# packets -- only native sim can run this style, see
# chacha20poly1305_encrypt_decrypt_shared_tb.py). $PIPELINEC must point at
# PipelineC/src/pipelinec.
# NOTE: this sim takes much longer than the standalone ones.

rm -rf ./generated-files-sim-comb-shared-native/*
$PIPELINEC ./src/chacha20poly1305_encrypt_decrypt_shared_tb.py --out_dir ./generated-files-sim-comb-shared-native --comb --sim --run 2400
