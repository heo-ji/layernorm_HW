vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_vip_v1_1_19
vlib modelsim_lib/msim/zynq_ultra_ps_e_vip_v1_0_19
vlib modelsim_lib/msim/lib_pkg_v1_0_4
vlib modelsim_lib/msim/fifo_generator_v13_2_11
vlib modelsim_lib/msim/lib_fifo_v1_0_20
vlib modelsim_lib/msim/lib_srl_fifo_v1_0_4
vlib modelsim_lib/msim/lib_cdc_v1_0_3
vlib modelsim_lib/msim/axi_datamover_v5_1_35
vlib modelsim_lib/msim/axi_sg_v4_1_19
vlib modelsim_lib/msim/axi_dma_v7_1_34
vlib modelsim_lib/msim/xlconstant_v1_1_9
vlib modelsim_lib/msim/proc_sys_reset_v5_0_16
vlib modelsim_lib/msim/smartconnect_v1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_33
vlib modelsim_lib/msim/xlconcat_v2_1_6

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_19 modelsim_lib/msim/axi_vip_v1_1_19
vmap zynq_ultra_ps_e_vip_v1_0_19 modelsim_lib/msim/zynq_ultra_ps_e_vip_v1_0_19
vmap lib_pkg_v1_0_4 modelsim_lib/msim/lib_pkg_v1_0_4
vmap fifo_generator_v13_2_11 modelsim_lib/msim/fifo_generator_v13_2_11
vmap lib_fifo_v1_0_20 modelsim_lib/msim/lib_fifo_v1_0_20
vmap lib_srl_fifo_v1_0_4 modelsim_lib/msim/lib_srl_fifo_v1_0_4
vmap lib_cdc_v1_0_3 modelsim_lib/msim/lib_cdc_v1_0_3
vmap axi_datamover_v5_1_35 modelsim_lib/msim/axi_datamover_v5_1_35
vmap axi_sg_v4_1_19 modelsim_lib/msim/axi_sg_v4_1_19
vmap axi_dma_v7_1_34 modelsim_lib/msim/axi_dma_v7_1_34
vmap xlconstant_v1_1_9 modelsim_lib/msim/xlconstant_v1_1_9
vmap proc_sys_reset_v5_0_16 modelsim_lib/msim/proc_sys_reset_v5_0_16
vmap smartconnect_v1_0 modelsim_lib/msim/smartconnect_v1_0
vmap axi_register_slice_v2_1_33 modelsim_lib/msim/axi_register_slice_v2_1_33
vmap xlconcat_v2_1_6 modelsim_lib/msim/xlconcat_v2_1_6

vlog -work xilinx_vip -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"/home/linuxusr/tools/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/home/linuxusr/tools/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/linuxusr/tools/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ipshared/46ab/accum_one_row.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/calculator_one_row.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/comparator.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/invsqrt.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/invsqrt_LUT.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/layernorm_axi_wrapper_slave_lite_v1_0_S00_AXI.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/mean.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/normalization.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/top_calculator_one_row.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/top_normalization.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/var.v" \
"../../../bd/layernorm_dma_system/ipshared/46ab/layernorm_axi_wrapper.v" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_layernorm_axi_wrapper_0_0/sim/layernorm_dma_system_layernorm_axi_wrapper_0_0.v" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_19 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/8c45/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work zynq_ultra_ps_e_vip_v1_0_19 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_zynq_ultra_ps_e_0_0/sim/layernorm_dma_system_zynq_ultra_ps_e_0_0_vip_wrapper.v" \

vcom -work lib_pkg_v1_0_4 -64 -93  \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/8c68/hdl/lib_pkg_v1_0_rfs.vhd" \

vlog -work fifo_generator_v13_2_11 -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6080/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_11 -64 -93  \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6080/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_11 -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6080/hdl/fifo_generator_v13_2_rfs.v" \

vcom -work lib_fifo_v1_0_20 -64 -93  \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/e160/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_4 -64 -93  \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/1e5a/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_3 -64 -93  \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/2a4f/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_35 -64 -93  \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/4277/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_19 -64 -93  \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/fc5d/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_34 -64 -93  \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/70ff/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_dma_0_1/sim/layernorm_dma_system_axi_dma_0_1.vhd" \

vlog -work xlconstant_v1_1_9 -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/e2d2/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_0/sim/bd_71fe_one_0.v" \

vcom -work proc_sys_reset_v5_0_16 -64 -93  \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0831/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_1/sim/bd_71fe_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/3718/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_2/sim/bd_71fe_arsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_3/sim/bd_71fe_rsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_4/sim/bd_71fe_awsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_5/sim/bd_71fe_wsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_6/sim/bd_71fe_bsw_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f49a/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_7/sim/bd_71fe_s00mmu_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/2da8/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_8/sim/bd_71fe_s00tr_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/63ed/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_9/sim/bd_71fe_s00sic_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/cef3/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_10/sim/bd_71fe_s00a2s_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_11/sim/bd_71fe_sarn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_12/sim/bd_71fe_srn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_13/sim/bd_71fe_s01mmu_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_14/sim/bd_71fe_s01tr_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_15/sim/bd_71fe_s01sic_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_16/sim/bd_71fe_s01a2s_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_17/sim/bd_71fe_sawn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_18/sim/bd_71fe_swn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_19/sim/bd_71fe_sbn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_20/sim/bd_71fe_s02mmu_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_21/sim/bd_71fe_s02tr_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_22/sim/bd_71fe_s02sic_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_23/sim/bd_71fe_s02a2s_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_24/sim/bd_71fe_sarn_1.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_25/sim/bd_71fe_srn_1.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_26/sim/bd_71fe_sawn_1.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_27/sim/bd_71fe_swn_1.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_28/sim/bd_71fe_sbn_1.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/7f4f/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_29/sim/bd_71fe_m00s2a_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_30/sim/bd_71fe_m00arn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_31/sim/bd_71fe_m00rn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_32/sim/bd_71fe_m00awn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_33/sim/bd_71fe_m00wn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_34/sim/bd_71fe_m00bn_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/37bc/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/ip/ip_35/sim/bd_71fe_m00e_0.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/bd_0/sim/bd_71fe.v" \

vlog -work axi_register_slice_v2_1_33 -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/3ee4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_2/sim/layernorm_dma_system_axi_smc_2.v" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_rst_ps8_0_99M_1/sim/layernorm_dma_system_rst_ps8_0_99M_1.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_0/sim/bd_6088_one_0.v" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_1/sim/bd_6088_psr_aclk_0.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_2/sim/bd_6088_arinsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_3/sim/bd_6088_rinsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_4/sim/bd_6088_awinsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_5/sim/bd_6088_winsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_6/sim/bd_6088_binsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_7/sim/bd_6088_aroutsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_8/sim/bd_6088_routsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_9/sim/bd_6088_awoutsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_10/sim/bd_6088_woutsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_11/sim/bd_6088_boutsw_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_12/sim/bd_6088_arni_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_13/sim/bd_6088_rni_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_14/sim/bd_6088_awni_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_15/sim/bd_6088_wni_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_16/sim/bd_6088_bni_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_17/sim/bd_6088_s00mmu_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_18/sim/bd_6088_s00tr_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_19/sim/bd_6088_s00sic_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_20/sim/bd_6088_s00a2s_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_21/sim/bd_6088_sarn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_22/sim/bd_6088_srn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_23/sim/bd_6088_sawn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_24/sim/bd_6088_swn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_25/sim/bd_6088_sbn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_26/sim/bd_6088_m00s2a_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_27/sim/bd_6088_m00arn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_28/sim/bd_6088_m00rn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_29/sim/bd_6088_m00awn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_30/sim/bd_6088_m00wn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_31/sim/bd_6088_m00bn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_32/sim/bd_6088_m00e_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_33/sim/bd_6088_m01s2a_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_34/sim/bd_6088_m01arn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_35/sim/bd_6088_m01rn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_36/sim/bd_6088_m01awn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_37/sim/bd_6088_m01wn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_38/sim/bd_6088_m01bn_0.sv" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/ip/ip_39/sim/bd_6088_m01e_0.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/bd_0/sim/bd_6088.v" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_axi_smc_1_1/sim/layernorm_dma_system_axi_smc_1_1.v" \

vlog -work xlconcat_v2_1_6 -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6120/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/ec67/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/6f8f/hdl" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../layernorm_w_dma.gen/sources_1/bd/layernorm_dma_system/ipshared/0127/hdl/verilog" "+incdir+/home/linuxusr/tools/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/layernorm_dma_system/ip/layernorm_dma_system_xlconcat_0_0/sim/layernorm_dma_system_xlconcat_0_0.v" \
"../../../bd/layernorm_dma_system/sim/layernorm_dma_system.v" \

vlog -work xil_defaultlib \
"glbl.v"

