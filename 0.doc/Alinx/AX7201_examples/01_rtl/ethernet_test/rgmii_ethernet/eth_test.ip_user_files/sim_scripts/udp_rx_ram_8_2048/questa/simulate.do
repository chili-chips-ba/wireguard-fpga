onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib udp_rx_ram_8_2048_opt

do {wave.do}

view wave
view structure
view signals

do {udp_rx_ram_8_2048.udo}

run -all

quit -force
