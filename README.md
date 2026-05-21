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
(E:\대학원_소스코드\HJH_esocPC\Linux_source\mpw./MPW_2024/Add_Norm 하위 폴더와 동일) 

- HW_(v1)
    - accumulate 길이 768로 고정
    - i_run / o_done 인터페이스
    - 파일구성 : Modules , Modules_posedge, testbench, build파일 등

<details>
  <summary>ver1.1</summary>
  #### ./MPW_2024_Add_Norm_HW_v1.1  
    - HW_v1.1  
    - HW_v1이랑 출력 타이밍 다름  
        출력 : c_state == DONE (registered)  
        리셋 : c_state == IDLE  
        실제로 DONE 상태가 된 다음 클락에 출력 (1사이클 늦음)  

    #### ./MPW_2024_Add_Norm_HW_v2_temp
        - 768/32 =24클럭에 adder tree형태로 구성  
        - 폐기
</details>
  
- HW_v2 : overflow 처리 X  
    - accumulate 길이 i_d_model로 동적으로 할당받는 것으로 변경
    - input port (i_d_model,i_shift_value,i_mult_value ) 추가
    - valid/ready handshake로 인터페이스 변경
    - 파일구성 :Modules_sync_reset , Modules, testbench, 등


- HW_v2.1  
    - norm에서 handshake기반수정+overflow처리 + AXI wrapper 까지 확인    
    - "Add_Norm_AXI" 의 소스코드  
- HW_v2.2
    - implementation에서 multi-driven net 오류 수정 (top에서 o_s_ready 를 하나의 신호로 연결한것 수정)
    -  "Add_Norm_PYNQ/layernorm_axi_wrapper_IP_src"소스코드  
    - axi-wrapper top 모듈 및 axi-lite 모듈 존재  
  
- HW_v3 : HW_v2에서 accum만 overflow처리 (근데 dmodel=768까지는 필요없는..듯)  
  (48-bit DSP, 포화 연산)  

- HW_v4 : HW_v2.2에서 모든 부분 overflow처리 완료 .  

## Add_Norm_AXI : AXI+IP with AXI-VIP
[Add_Norm_AXI readme 바로가기](./Add_Norm_AXI/README.md)

## Add_Norm_PYNQ : AXI+IP+ PS+DMA 
- (v1) : local linux  
- v2 : 145server (board : zcu111)  
  **zcu111 AXI data bus = 128로 수정**
    
   ./project_dma_wrapper/project_dma_wrapper.runs/impl_1/ps_dma_ip_wrapper.bit = bitstream위치  
  ㄴ project_dma_wrapper : HW_v2.2 기반  
  ㄴ project_dma_wrapper_v2 : HW_v4 기반  

