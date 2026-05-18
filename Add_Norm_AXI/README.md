## 시뮬레이션 위치
1. gui없이 build파일로 시뮬진행  
: ADD_NORM_AXI.sim\sim_0513  
testbench = tb_layernorm_axi_wrapper_no_gui.sv 파일

```
sim_0513/
├── protoinst_files/
│   └── layernorm_sim.protoinst        ← Vivado Protocol Analyzer 포트 매핑 JSON 
│                                        transaction단위로 볼 수 있도록 VIP의 IF를 protocol instances로
│                                        xsim --protoinst 옵션으로 전달
│
├── build                              ← xsim 4단계 빌드 쉘 스크립트 ('src/모듈 중 var가 SV 예약어라 Verilog 모드로 분리 컴파일)
│                                         Step1 : xvlog (RTL .v, Verilog 모드)
│                                         Step2 : xvlog (VIP 인프라 .v, Verilog 모드)
│                                         Step3 : xvlog --sv (VIP + TB .sv, SV 모드)
│                                         Step4 : xelab  (elaborate)
│                                         Step5 : xsim   (GUI 실행)
│
├── clean                              ← 시뮬레이션 산출물 일괄 삭제 스크립트
│                                         (*.wdb, *.log, .Xil, webtalk 등 제거)
│
├── design_list.f                      ← RTL 및 AXI Wrapper 소스 파일 목록
│
├── testbench_list.f                   ← SV 모드로 컴파일할 파일 목록 VIP와 메인 tb
│                                         · tb_layernorm_axi_wrapper_no_gui.sv  ← TB 본체
│
├── testbench_list_v.f                 ← Verilog 모드로 컴파일할 VIP 인프라 파일 목록
│                                         ('var'가 SV 예약어라 Verilog 모드로 분리 컴파일)
│
├── sim.tcl                            ← Vivado xsim GUI 설정 TCL
│                                         · add_wave / 로 전체 신호 파형 창 추가
│                                         · run all 로 시뮬레이션 끝까지 실행
│
├── tb_layernorm_axi_wrapper_no_gui.sv ← 최상위 테스트벤치 (SystemVerilog)
                                          · MODEL_DIMENSION = 768
                                          · AXI-Stream 데이터폭 = 512 bit
                                          · VIP 3개 인스턴스화:
                                           - u_lite_mst : AXI-Lite Master → 레지스터 W/R
                                           - u_axis_mst : AXIS Master     → 입력 데이터 주입
                                           - u_axis_slv : AXIS Slave      → 출력 결과 수집
                                          · DUT = layernorm_axi_wrapper 연결
   


```



2. gui에서 시뮬 진행 , wrapper를 IP로 불러와서 사용함  
: AXI\ADD_NORM_AXI.sim\sim_1\behav\xsim 에서 시뮬레이션 진행  

testbench = Add_Norm_AXI/ADD_NORM_AXI.srcs/sources_1/tb_layernorm_axi_wrapper.sv  
ㄴ 사용하는 IP의 정보 .xci  

## <design_list.f = 커스텀 IP의 코드 위치>  
1. Add_Norm_AXI/ADD_NORM_AXI.srcs/layernorm_axi_wrapper_1_0/hdl  
ㄴ layernorm_axi_wrapper.v  
ㄴ layernorm_axi_wrapper_slave_lite_v1_0_S00_AXI.v  


2. Add_Norm_AXI/ADD_NORM_AXI.srcs/layernorm_axi_wrapper_1_0/src  
ㄴ layernorm_axi_wrapper.v에서 인스턴스되는 코드들(top_normalization , calculator_one_row , ,,등)  