# layernorm_HW
e2e-bert-accel-SW 의 layernorm HW 설계  
[HW 구조/timing diagram /functional description 바로가기](./doc/README_HW.md)

# 파일
## add_norm_core : SW-HW mismatch 확인 simulation
```
add_norm_core/
├── design/
│   └── ref_py/
│       └── layernorm_golden.py   ← SW golden + trace 생성
│   └── ref_v/                    ← HW 코드
├── sim/
│   ├── add_norm_tb.v             ← HW trace 캡처
│   ├── listfile.f                ← RTL 파일 목록 (절대경로)
│   └── run.py                    ← 전체 실행 + 비교
└── trace/                        ← 실행 시 자동 생성
```
## Add_Norm_HW : HW 버전별 rtl 코드
- HW_v2 : overflow 처리 X  
- HW_v2.1  
    - norm에서 handshake기반수정+overflow처리 + AXI wrapper 까지 확인    
    - "Add_Norm_AXI" 의 소스코드  
- HW_v2.2
    - implementation에서 multi-driven net 오류 수정 (top에서 o_s_ready 를 하나의 신호로 연결한것 수정)
    -  "Add_Norm_PYNQ/layernorm_axi_wrapper_IP_src"소스코드  
= axi-wrapper top 모듈 및 axi-lite 모듈 존재  
  
- HW_v3 : HW_v2에서 accum만 overflow처리 (근데 dmodel=768까지는 필요없는..듯)  
  
- HW_v4 : HW_v2.2에서 모든 부분 overflow처리 완료 .  

## Add_Norm_AXI : AXI+IP with AXI-VIP
<details>
<summary>README</summary>
<div markdown="1">

#### 시뮬레이션 위치
1. gui없이 build파일로 시뮬진행  
: ADD_NORM_AXI.sim\sim_0513  
testbench = tb_layernorm_axi_wrapper_no_gui.sv 파일  

```
sim_0513/
├── trace/                              ← 512bit*768개의 input 및 output파일 저장위치
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
```
testbench = Add_Norm_AXI/ADD_NORM_AXI.srcs/sources_1/tb_layernorm_axi_wrapper.sv  
ㄴ 사용하는 IP의 정보 .xci  
```
#### <design_list.f = 커스텀 IP의 코드 위치>  
1. Add_Norm_AXI/ADD_NORM_AXI.srcs/layernorm_axi_wrapper_1_0/hdl  
ㄴ layernorm_axi_wrapper.v  
ㄴ layernorm_axi_wrapper_slave_lite_v1_0_S00_AXI.v  


2. Add_Norm_AXI/ADD_NORM_AXI.srcs/layernorm_axi_wrapper_1_0/src  
ㄴ layernorm_axi_wrapper.v에서 인스턴스되는 코드들(top_normalization , calculator_one_row , ,,등)  

</div>
</details>

## Add_Norm_PYNQ : AXI+IP+ PS+DMA 
- (v1) : local linux  
- v2 : 145server (board : zcu111)  
   project_dma_wrapper/project_dma_wrapper.runs/impl_1/ps_dma_ip_wrapper.bit = bitstream위치  
  ㄴ project_dma_wrapper : HW_v2.2 기반  
  ㄴ project_dma_wrapper_v2 : HW_v4 기반  

