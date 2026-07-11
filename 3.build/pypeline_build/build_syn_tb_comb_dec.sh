#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Combinational (zero pipeline stages) GHDL/cocotb sim of the standalone
# decrypt design's synthesizable-style testbench. $PIPELINEC must point at
# PipelineC/src/pipelinec.

rm -rf ./generated-files-syn-tb-comb-dec/*
$PIPELINEC ./src/chacha20poly1305_decrypt_syn_tb.py --out_dir ./generated-files-syn-tb-comb-dec --comb --sim --cocotb --ghdl --run 380
