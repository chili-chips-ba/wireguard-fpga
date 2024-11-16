#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/extern_disk/meisq/Xilinx/SDK/2019.1/bin:/home/extern_disk/meisq/Xilinx/Vivado/2019.1/ids_lite/ISE/bin/lin64:/home/extern_disk/meisq/Xilinx/Vivado/2019.1/bin
else
  PATH=/home/extern_disk/meisq/Xilinx/SDK/2019.1/bin:/home/extern_disk/meisq/Xilinx/Vivado/2019.1/ids_lite/ISE/bin/lin64:/home/extern_disk/meisq/Xilinx/Vivado/2019.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/extern_disk/meisq/ax7201/video_ethernet/video_ethernet.runs/camera_fifo_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log camera_fifo.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source camera_fifo.tcl
