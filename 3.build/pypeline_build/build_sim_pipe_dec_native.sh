#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Pipelined (real autopipelining via synthesis tool - takes hours) native
# Pypeline sim (no cocotb/ghdl) of the standalone decrypt design testbench.
# $PIPELINEC must point at PipelineC/src/pipelinec.

rm -rf ./generated-files-sim-pipe-dec-native/*
$PIPELINEC ./src/chacha20poly1305_decrypt_tb.py --out_dir ./generated-files-sim-pipe-dec-native --sim --run 600
