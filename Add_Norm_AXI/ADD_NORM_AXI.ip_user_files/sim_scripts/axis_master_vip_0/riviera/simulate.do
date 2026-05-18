transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+axis_master_vip_0  -L xil_defaultlib -L xilinx_vip -L axis_infrastructure_v1_1_1 -L axi4stream_vip_v1_1_19 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.axis_master_vip_0 xil_defaultlib.glbl

do {axis_master_vip_0.udo}

run 1000ns

endsim

quit -force
