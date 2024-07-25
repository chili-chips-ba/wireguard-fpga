onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_4096_16i_32o_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_4096_16i_32o.udo}

run -all

quit -force
