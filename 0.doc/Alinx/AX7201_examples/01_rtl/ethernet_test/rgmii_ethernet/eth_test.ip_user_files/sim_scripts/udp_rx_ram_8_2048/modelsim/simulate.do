onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_3 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.udp_rx_ram_8_2048 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {udp_rx_ram_8_2048.udo}

run -all

quit -force
