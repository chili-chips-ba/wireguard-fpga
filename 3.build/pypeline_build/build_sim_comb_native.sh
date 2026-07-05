#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Combinational (zero pipeline stages) native Pypeline sim (no cocotb/ghdl) of
# the standalone encrypt design testbench. $PIPELINEC must point at
# PipelineC/src/pipelinec.

rm -rf ./generated-files-sim-comb-native/*
$PIPELINEC ./src/chacha20poly1305_encrypt_tb.py --out_dir ./generated-files-sim-comb-native --comb --sim --run 150
