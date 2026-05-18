transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xil_defaultlib

vmap xilinx_vip riviera/xilinx_vip
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xilinx_vip  -incr -l axi_vip_v1_1_19 -l axi4stream_vip_v1_1_19 "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xil_defaultlib \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xil_defaultlib \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/hdl/layernorm_axi_wrapper_slave_lite_v1_0_S00_AXI.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/accum_one_row.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/calculator_one_row.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/comparator.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/invsqrt.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/invsqrt_LUT.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/mean.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/normalization.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/top_calculator_one_row.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/top_normalization.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/src/var.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/hdl/layernorm_axi_wrapper.v" \
"../../../../ADD_NORM_AXI.gen/sources_1/ip/layernorm_axi_wrapper_0/sim/layernorm_axi_wrapper_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

