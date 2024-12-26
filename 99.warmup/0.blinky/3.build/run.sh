#!/bin/bash

# Set the base path for the Vivado installation
VIVADO_BASE_PATH="/home/user/FPGA/tools/"

# Check if the user has set the VIVADO_BASE_PATH environment variable
if [ -n "$VIVADO_BASE_PATH_ENV" ]; then
    VIVADO_BASE_PATH=$VIVADO_BASE_PATH_ENV
fi

# Path to the Vivado settings script
VIVADO_SETTINGS="${VIVADO_BASE_PATH}Xilinx/Vivado/2024.2/settings64.sh"

# Check if the Vivado settings file exists
if [ ! -f "$VIVADO_SETTINGS" ]; then
    echo "Error: Vivado settings file does not exist at $VIVADO_SETTINGS"
    exit 1
fi

# Source Vivado environment settings
source $VIVADO_SETTINGS

# Define the directory containing your TCL scripts
SCRIPT_DIR="."

# Check if the build.tcl exists
if [ ! -f "$SCRIPT_DIR/build.tcl" ]; then
    echo "Error: build.tcl does not exist in $SCRIPT_DIR"
    exit 1
fi

# Check if the program-board.tcl exists
if [ ! -f "$SCRIPT_DIR/program-board.tcl" ]; then
    echo "Error: program-board.tcl does not exist in $SCRIPT_DIR"
    exit 1
fi

# Run the build TCL script with Vivado
vivado -mode batch -source "$SCRIPT_DIR/build.tcl"

# Run the programming TCL script with Vivado
vivado -mode batch -source "$SCRIPT_DIR/program-board.tcl"

