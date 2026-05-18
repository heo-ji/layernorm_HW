transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/axis_infrastructure_v1_1_1
vlib riviera/xil_defaultlib
vlib riviera/axi4stream_vip_v1_1_19

vmap xilinx_vip riviera/xilinx_vip
vmap axis_infrastructure_v1_1_1 riviera/axis_infrastructure_v1_1_1
vmap xil_defaultlib riviera/xil_defaultlib
vmap axi4stream_vip_v1_1_19 riviera/axi4stream_vip_v1_1_19

vlog -work xilinx_vip  -incr "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l axis_infrastructure_v1_1_1 -l xil_defaultlib -l axi4stream_vip_v1_1_19 \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work axis_infrastructure_v1_1_1  -incr -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l axis_infrastructure_v1_1_1 -l xil_defaultlib -l axi4stream_vip_v1_1_19 \
"../../../ipstatic/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr "+incdir+../../../ipstatic/hdl" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l axis_infrastructure_v1_1_1 -l xil_defaultlib -l axi4stream_vip_v1_1_19 \
"../../../../layernorm_axi_wrapper_1_0/src/axis_slave_vip_0/sim/axis_slave_vip_0_pkg.sv" \

vlog -work axi4stream_vip_v1_1_19  -incr "+incdir+../../../ipstatic/hdl" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l axis_infrastructure_v1_1_1 -l xil_defaultlib -l axi4stream_vip_v1_1_19 \
"../../../ipstatic/hdl/axi4stream_vip_v1_1_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr "+incdir+../../../ipstatic/hdl" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l axis_infrastructure_v1_1_1 -l xil_defaultlib -l axi4stream_vip_v1_1_19 \
"../../../../layernorm_axi_wrapper_1_0/src/axis_slave_vip_0/sim/axis_slave_vip_0.sv" \

vlog -work xil_defaultlib \
"glbl.v"

