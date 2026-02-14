#!/usr/bin/bash

# SPDX-FileCopyrightText: 2024 Simon Southwell
#
# SPDX-License-Identifier: GPL-3.0-or-later

if [ "$FNAME" != "" ]
then
  FNAME=$1
else
  FNAME="main.s"
fi

ONAME=main
STARTADDR=0
DATAADDR=1000
TESTDIR=.

PREFIX=riscv64-unknown-elf-

${PREFIX}as.exe -fpic -march=rv32imafdc -aghlms=$TESTDIR/$ONAME.list -o $TESTDIR/$ONAME.o $TESTDIR/$FNAME
${PREFIX}ld.exe $TESTDIR/$ONAME.o -Ttext $STARTADDR -Tdata $DATAADDR -melf32lriscv -o $ONAME.bin
