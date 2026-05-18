transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+layernorm_axi_wrapper_0  -L xil_defaultlib -L xilinx_vip -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.layernorm_axi_wrapper_0 xil_defaultlib.glbl

do {layernorm_axi_wrapper_0.udo}

run 1000ns

endsim

quit -force
