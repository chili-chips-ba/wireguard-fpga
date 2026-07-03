#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Combinational (zero pipeline stages) GHDL/cocotb sim of the standalone
# decrypt design testbench. $PIPELINEC must point at PipelineC/src/pipelinec.

rm -rf ./generated-files-sim-comb-dec/*
$PIPELINEC ./src/chacha20poly1305_decrypt_tb.py --out_dir ./generated-files-sim-comb-dec --comb --sim --cocotb --ghdl --run 600
