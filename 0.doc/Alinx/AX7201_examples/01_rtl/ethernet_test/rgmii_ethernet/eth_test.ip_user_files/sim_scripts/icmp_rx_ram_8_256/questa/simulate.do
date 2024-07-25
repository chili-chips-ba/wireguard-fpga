onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib icmp_rx_ram_8_256_opt

do {wave.do}

view wave
view structure
view signals

do {icmp_rx_ram_8_256.udo}

run -all

quit -force
