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
HW_v4 : 모든 부분 overflow처리 O

### Add_Norm_AXI : AXI+IP + DMA + PS
해당폴더 내부 README.md참고

