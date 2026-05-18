vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/axis_infrastructure_v1_1_1
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/axi4stream_vip_v1_1_19

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap axis_infrastructure_v1_1_1 modelsim_lib/msim/axis_infrastructure_v1_1_1
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap axi4stream_vip_v1_1_19 modelsim_lib/msim/axi4stream_vip_v1_1_19

vlog -work xilinx_vip -64 -incr -mfcu  -sv -L axi4stream_vip_v1_1_19 -L xilinx_vip "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work axis_infrastructure_v1_1_1 -64 -incr -mfcu  "+incdir+../../../ipstatic/hdl" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi4stream_vip_v1_1_19 -L xilinx_vip "+incdir+../../../ipstatic/hdl" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_axi_wrapper_1_0/src/axis_slave_vip_0/sim/axis_slave_vip_0_pkg.sv" \

vlog -work axi4stream_vip_v1_1_19 -64 -incr -mfcu  -sv -L axi4stream_vip_v1_1_19 -L xilinx_vip "+incdir+../../../ipstatic/hdl" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/axi4stream_vip_v1_1_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi4stream_vip_v1_1_19 -L xilinx_vip "+incdir+../../../ipstatic/hdl" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_axi_wrapper_1_0/src/axis_slave_vip_0/sim/axis_slave_vip_0.sv" \

vlog -work xil_defaultlib \
"glbl.v"

