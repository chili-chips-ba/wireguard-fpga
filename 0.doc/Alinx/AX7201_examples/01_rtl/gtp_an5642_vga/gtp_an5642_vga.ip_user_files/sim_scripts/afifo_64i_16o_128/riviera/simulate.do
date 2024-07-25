onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+afifo_64i_16o_128 -L xil_defaultlib -L xpm -L fifo_generator_v13_2_4 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.afifo_64i_16o_128 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {afifo_64i_16o_128.udo}

run -all

endsim

quit -force
