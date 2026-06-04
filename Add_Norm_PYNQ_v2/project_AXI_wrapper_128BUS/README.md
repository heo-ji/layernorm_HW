
`Add_Norm_AXI`folder 에서 512bit BUS => 128bit으로 수정

`수정 리스트`
layernorm_axi_wrapper.v	             : MODULE_NUM=32→8, TDATA_WIDTH=512→128 
axis_master_vip_0.sv	             : 포트 [511:0]→[127:0], DATA_WIDTH 512→128, tstrb/tkeep 64'B0→16'B0
axis_slave_vip_0.sv	                 : 포트 [511:0]→[127:0], DATA_WIDTH 512→128, tstrb/tkeep 64'B0→16'B0
axis_master_vip_0_pkg.sv             : VIP_DATA_WIDTH 512→128
axis_slave_vip_0_pkg.sv	             : VIP_DATA_WIDTH 512→128
tb_layernorm_axi_wrapper_no_gui.sv   :	신호 폭, mem 폭, trace 경로, fwrite 포맷 등
                                        axis_in/out_tdata, mem 폭	[511:0]→[127:0]
                                        trace파일 trace128/
                                        $fwrite 포맷	%0128x	%032x
                                        $error compare 포맷	%0128x	%032x

```
project_AXI_wrapper_128BUS/
├── sim/
│   ├── build                  
│   ├── clean
│   ├── design_list.f          
│   ├── testbench_list.f       
│   ├── sim.tcl
│   ├── protoinst_files/
│   ├── trace128/           :128bitBUS = [8 , 768] 데이터가 col-wise로 저장됨. 1-line = 8 row의 hex데이터가 총 768-line개 있음
│   └── testbench/
│       └── tb_layernorm_axi_wrapper_no_gui.sv
│
└── AXI_wrapper_IP/
    ├── src/
    │   ├── variance.v         ← var.v → 파일명+모듈명 변경
    │   ├── calculator_one_row.v ← var → variance 인스턴스 수정
    │   └── (나머지 .v, .vh 파일들)
    ├── hdl/
    │   └── (layernorm_axi_wrapper*.v)
    └── ip/
        ├── axi_lite_master_vip_0/
        ├── axis_master_vip_0/
        └── axis_slave_vip_0/
```