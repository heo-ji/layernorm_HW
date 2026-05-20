# layernorm_HW
e2e-bert-accel-SW 의 layernorm HW 설계

# 파일
### add_norm_core : SW-HW mismatch 확인 simulation
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
### Add_Norm_HW : HW 버전별 rtl 코드
HW_v2 : overflow 처리 X  
HW_v2.1 : norm에서 handshake기반수정+overflow처리  +  AXI wrapper 까지 확인  = Add_Norm_AXI의 소스코드  
HW_v2.2 : implementation에서 multi-driven net 오류 수정 (top에서 o_s_ready 를 하나의 신호로 연결한것 수정)  = Add_Norm_PYNQ의 "layernorm_axi_wrapper_IP_src"소스코드  
HW_v3 : accum만 overflow처리 (근데 768까지는 필요없는..)

HW_v4 : 모든 부분 overflow처리 O

### Add_Norm_AXI : AXI+IP
해당폴더 내부 README.md참고

### Add_Norm_PYNQ : AXI+IP+ PS+DMA


