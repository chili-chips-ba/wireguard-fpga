#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Combinational (zero pipeline stages) GHDL/cocotb sim of the shared
# encrypt+decrypt design's synthesizable-style testbenches (both side
# testbenches run at once). $PIPELINEC must point at PipelineC/src/pipelinec.
# NOTE: this sim takes much longer than the standalone ones.

rm -rf ./generated-files-syn-tb-comb-shared/*
$PIPELINEC ./src/chacha20poly1305_encrypt_decrypt_shared_syn_tb.py --out_dir ./generated-files-syn-tb-comb-shared --comb --sim --cocotb --ghdl --run 600
