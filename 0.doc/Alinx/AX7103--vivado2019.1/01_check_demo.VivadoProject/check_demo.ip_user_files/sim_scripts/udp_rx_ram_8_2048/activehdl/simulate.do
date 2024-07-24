onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+udp_rx_ram_8_2048 -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_3 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.udp_rx_ram_8_2048 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {udp_rx_ram_8_2048.udo}

run -all

endsim

quit -force
