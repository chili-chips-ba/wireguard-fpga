#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# Full build (autopipelining via synthesis tool) of the shared
# encrypt+decrypt hardware top to Verilog.
# $PIPELINEC must point at PipelineC/src/pipelinec.

rm -rf ./generated-files-verilog-shared/*
$PIPELINEC ./src/chacha20poly1305_encrypt_decrypt_shared.py --out_dir ./generated-files-verilog-shared --top chacha20poly1305_encrypt_decrypt_shared --verilog
