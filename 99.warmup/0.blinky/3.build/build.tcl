# Set the base path for the project relative to the current script location
set base_path "../1.hw"

# Read design sources
read_verilog "${base_path}/led_test.v"

# Read constraints from the hardware directory
read_xdc "${base_path}/led.xdc"

# Synthesize the design
synth_design -top "led_test" -part "xc7a200tfbg484-2"

# Place and route
opt_design
place_design
route_design

# Write bitstream, output to the current directory (3.build)
write_bitstream -force "blinky.bit"

