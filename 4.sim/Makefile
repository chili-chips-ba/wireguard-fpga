#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#=============================================================
SHELL   := /bin/bash

HW_SRC  := $(CURDIR)/../1.hw
BLD_DIR := $(CURDIR)/../3.build
SIM_DIR := $(CURDIR)/../4.sim
TB_NAME := tb

export BLD_DIR SIM_DIR HW_SRC TB_NAME


#------------------------
.PHONY: all
all: clean sim wave

#------------------------
clean:
	rm -rf output

compile:
	verilator \
		--cc \
		--timing \
		--trace-fst \
		--trace-structs \
		--timescale-override 1ps/1ps \
		--exe versimSV.cpp \
		--Mdir ./output \
		\
		-Wall models/config.vlt \
		-f ${HW_SRC}/top.filelist \
		-f ${SIM_DIR}/tb.filelist \
		\
		--top-module ${TB_NAME}

#------------------------
sim: compile
	cd output; \
	make -f V${TB_NAME}.mk  V${TB_NAME}; \
	./V${TB_NAME} | tee sim.log

#------------------------
wave: xml2stems
	cd output; \
	gtkwave --saveonexit \
		--slider-zoom \
		--stems   ../tb.stems \
		--logfile sim.log \
		-rc       ../.gtkwaverc \
		--dump    wave.fst &

#		--wish \
#		--save ../wave.gtkw

#------------------------
wave-alt:
	cd output; \
	surfer.exe -s ../wave.surfer.ron wave.fst &

#------------------------
xml2stems:
	verilator \
		--timing \
		-xml-only \
		-xml-output tb.xml \
		--timescale 1ps/1ps \
		-Wall models/config.vlt \
		-f ${HW_SRC}/top.filelist \
		-f ${SIM_DIR}/tb.filelist \
		--top-module ${TB_NAME}
	xml2stems tb.xml tb.stems

#		models/sdr_sdram/sdr.CHILI.sv \

#------------------------
rtlbrowse: xml2stems
	rtlbrowse tb.stems

#=============================================================
# End-of-File
#=============================================================
