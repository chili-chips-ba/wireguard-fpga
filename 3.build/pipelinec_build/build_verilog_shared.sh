#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

rm -rf ./generated-files-verilog-shared/*
rm ./*.py
$PIPELINEC ./src/chacha20poly1305_encrypt_decrypt_shared.c --out_dir ./generated-files-verilog-shared --top chacha20poly1305_encrypt_decrypt_shared --verilog
