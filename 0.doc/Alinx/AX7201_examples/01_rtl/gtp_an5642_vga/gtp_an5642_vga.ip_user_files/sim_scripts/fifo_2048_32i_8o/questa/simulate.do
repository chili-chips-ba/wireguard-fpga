onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_2048_32i_8o_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_2048_32i_8o.udo}

run -all

quit -force
