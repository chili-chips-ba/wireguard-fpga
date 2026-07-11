#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Combinational (zero pipeline stages) native Pypeline sim (no cocotb/ghdl) of
# the standalone encrypt design's non-synthesizable testbench
# (@sim_input/@sim_output, 10 on-the-fly random packets up to 1024 bytes --
# only native sim can run this style, see chacha20poly1305_encrypt_tb.py).
# $PIPELINEC must point at PipelineC/src/pipelinec.

rm -rf ./generated-files-sim-comb-native/*
$PIPELINEC ./src/chacha20poly1305_encrypt_tb.py --out_dir ./generated-files-sim-comb-native --comb --sim --run 1150
