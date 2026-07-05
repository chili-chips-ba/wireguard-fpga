#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Pipelined (real autopipelining via synthesis tool - takes hours) GHDL/cocotb
# sim of the standalone encrypt design testbench.
# $PIPELINEC must point at PipelineC/src/pipelinec.

rm -rf ./generated-files-sim-pipe/*
$PIPELINEC ./src/chacha20poly1305_encrypt_tb.py --out_dir ./generated-files-sim-pipe --sim --cocotb --ghdl --run 300
