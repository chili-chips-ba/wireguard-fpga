#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Pipelined (real autopipelining via synthesis tool - takes hours) native
# Pypeline sim (no cocotb/ghdl) of the shared encrypt+decrypt design
# testbench (both side testbenches run at once). $PIPELINEC must point at
# PipelineC/src/pipelinec.

rm -rf ./generated-files-sim-pipe-shared-native/*
$PIPELINEC ./src/chacha20poly1305_encrypt_decrypt_shared_tb.py --out_dir ./generated-files-sim-pipe-shared-native --sim --run 1200
