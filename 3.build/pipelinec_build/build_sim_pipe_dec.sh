#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

rm -rf ./generated-files-sim-pipe-dec/*
rm ./*.py
$PIPELINEC ./src/chacha20poly1305_decrypt_tb.c --out_dir ./generated-files-sim-pipe-dec --sim --cocotb --ghdl --run 250
