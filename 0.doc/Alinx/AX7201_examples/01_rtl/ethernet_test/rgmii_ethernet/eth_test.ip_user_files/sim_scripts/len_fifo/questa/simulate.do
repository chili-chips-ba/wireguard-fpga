onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib len_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {len_fifo.udo}

run -all

quit -force
