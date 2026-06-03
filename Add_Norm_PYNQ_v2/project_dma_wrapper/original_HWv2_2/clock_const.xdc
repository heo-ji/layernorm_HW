# constraints.xdc
create_clock -period 10 -name axi_clk [get_ports s00_axi_aclk]
# zynq7000 = negative slack!! in 5.56ns
# 10ns = 100MHz 