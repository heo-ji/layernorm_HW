# LayerNorm IP — AXI Wrapper 스펙

> **IP 코어** (모듈 구성, 데이터 포맷, 내부 비트폭) → **[`README_HW.md`](README_HW.md)**  
  
> **FPGA이용한 SW(pytorch glue task) BERT 모델 실행(HIL 환경)** (Host PC ↔ ZCU111 SW 흐름) → **[`README_FPGA_overview.md`](README_FPGA_overview.md)**

---

## 1. FPGA의 PL 구조 = layernorm_axi_wrapper.v

```
layernorm_axi_wrapper (PL)
├── AXI-Lite Slave      ← 제어 레지스터 (cmd, status, d_model, shift, mult)
├── AXI-Stream Slave    ← DMA 입력  (s_axis: tdata WIDTH-bit, tvalid, tready, tlast) 
├── AXI-Stream Master   ← DMA 출력  (m_axis: tdata WIDTH-bit, tvalid, tready, tlast)
└── FSM
    IDLE       : cmd=0 받으면 IDLE , cmd=1 기다림
     → ITER1   : cmd=1 받으면 s_axis → mean/invsqrt 계산 (d_model 사이클)
     → STORE   : mean/invsqrt 레지스터에 저장
     → WAIT_ITER2 : cmd=2 기다림 ( PS 가 status=WAIT_ITER2인지 polling으로 register 값확인)
     → ITER2   : cmd=2 받으면, s_axis → normalization 출력→ m_axis  (d_model 사이클)
     → IDLE    : 마지막 beat가 ps로 전달되면, IDLE

     "마지막 beat가 ps로 전달되면 = m00_axis_tready && m00_axis_tlast"라는 뜻
```
```
전송 beat 수 = `d_model` (예: BERT-base = 768)  
1회 전체 전송량 = `d_model × (TDATA_WIDTH / 8)` bytes
```
---
## 2. AXI-Lite 레지스터 맵

| 레지스터 | 오프셋 | 방향 | 내용 |
|----------|--------|------|------|
| slv_reg0 | `0x00` | PS → PL | **cmd** `[1:0]` : 0=idle, 1=iter1_start, 2=iter2_start |
| slv_reg1 | `0x04` | PL → PS | **status** `[1:0]` : 0=idle, 1=wait_iter2, 2=iter2 진행중, 9=기타 |
| slv_reg2 | `0x08` | PS → PL | **d_model** `[10:0]` (예: BERT-base = 768) |
| slv_reg3 | `0x0C` | PS → PL | `{ shift_value[12:8] , mult_value[7:0] }` |
| slv_reg4 | `0x10` | — | 예비 |


**d_model / shift / mult 값은 IP 파라미터 스펙 참고**  
→ [`README_HW.md` — 4. IP 파라미터 (d_model, shift, mult 값 표)](README_HW.md#4-ip-파라미터-1)

---

## 3. 'FPGA 보드 PS + Xilinx DMA IP + PL 연결' 블록 구조
```
[제어 경로 - AXI-Lite]
PS M_AXI_HPM0 ──► AXI SmartConnect (1M→2S)
                      ├──► AXI DMA (S_AXI_LITE)      ← DMA 레지스터 제어
                      └──► LayerNorm Wrapper (S00_AXI) ← cmd, d_model 등

[데이터 경로 - Xilinx DMA IP이용 (AXI Full, DDR 접근)]
AXI DMA (M_AXI_MM2S) ──► AXI SmartConnect ──► PS S_AXI_HP0  ← DDR 읽기
AXI DMA (M_AXI_S2MM) ──┘                                     ← DDR 쓰기
AXI DMA (M_AXI_SG)


[스트림 경로 - AXI-Stream]
AXI DMA (M_AXIS_MM2S) ──► LayerNorm (S00_AXIS)   ← 입력 데이터
AXI DMA (S_AXIS_S2MM) ◄── LayerNorm (M00_AXIS)   ← 출력 데이터
```
---
## 4. PS의 PL제어 시퀀스 : PYNQ사용의 예시

```python
from pynq import Overlay, allocate 
import numpy as np

######## Overlay = PYNQ IP 인스턴스 이름을 파싱해서 가져옴 ########################
ol    = Overlay("/home/xilinx/layernorm/layernorm_dma.bit") 
#ZCU111 보드 위의 .bit/.hwh 파일이 있는 경로를 적어준다

# PYNQ가 .hwh 파일을 파싱해서
# 블록 디자인의 IP 인스턴스 이름을 그대로 Python 속성으로 생성함
dma   = ol.axi_dma_0
ln_ip = ol.layernorm_axi_wrapper_0

######## 초기화 (서버 시작 시 1회) ########################################
ln_ip.write(0x08, 768)     # d_model
ln_ip.write(0x0C, 0x0855)  # shift=8, mult=0x55  (BERT-base, d_model=768)

######## 데이터 버퍼 할당 ################################################
# allocate = DMA가 접근 가능한 버퍼(물리 주소가 연속된 메모리)를 만들어줌

n = 768 * 8   # d_model × MODULE_NUM (int16 개수) //zcu111보드 databuf = 128
in_buf  = allocate(shape=(n,), dtype=np.int16)   # ← DMA용 물리 연속 메모리
out_buf = allocate(shape=(n,), dtype=np.int16)

######## DMA 데이터 전송 ################################################
try:
    in_buf[:] = 입력데이터   # 버퍼에 데이터 채우기

    ######## ITER1 ##################################
    ln_ip.write(0x00, 1)              # cmd = iter1_start
    dma.sendchannel.transfer(in_buf)  # MM2S: PS → PL  (d_model beats)
    dma.sendchannel.wait()            # DMA 자체의 전송 완료
    while ln_ip.read(0x04) != 1: pass   # status = WAIT_ITER2를 확인 [polling]

    ######## ITER2 ##################################
    ln_ip.write(0x00, 2)                   # cmd = iter2_start
    dma.sendchannel.transfer(in_buf)       # MM2S: PS → PL  (d_model beats)
    dma.recvchannel.transfer(out_buf)      # S2MM: PL → PS
    dma.sendchannel.wait()                 # DMA 자체의 전송 완료
    dma.recvchannel.wait()

    result = np.array(out_buf)   # 결과 일반 numpy로 복사

finally:
    in_buf.freebuffer()    # ← 반드시 해제해야함!!! (allocate 버퍼의 경우)
    out_buf.freebuffer()

```
= ps_server.py (PS의 PL제어) 코드의 일부 → [`README_FPGA_overview.md`](README_FPGA_overview.md)

> **주의사항**  
    1. **.bit랑 .hwh가 같은 폴더& 같은 이름**이어야 PYNQ가 인식함\
    (✅ layernorm_dma.bit + layernorm_dma.hwh)
  2. allocate 버퍼했으면 **반드시 freebuffer()** 

>참고사항  
    1. try/finally 로 감싸는 이유는, DMA 도중 예외가 나도 버퍼가 반드시 해제되도록  
    2. `dma   = ol.axi_dma_0` , `ln_ip = ol.layernorm_axi_wrapper_0`에서  
    "axi_dma_0","layernorm_axi_wrapper_0"는 블록디자인 내부의 IP instance 이름 그대로임.    
    (실제 이름은 `.hwh` 파일 또는 `ol.ip_dict.keys()` 로 확인가능)

---

## 5. 버스 폭 파라미터 변경 시 re-implementation 필요

데이터 버스 폭이 달라지면 아래 두 파라미터를 수정하고 Vivado에서 implement 다시해야함  

```
128 → 512 bit로 바꾸는 경우

Vivado IP Catalog → layernorm_axi_wrapper → 파라미터 수정
    C_S00_AXIS_TDATA_WIDTH : 128   →   512 
    MODULE_NUM             :   8   →    32 
→ Generate Output Products → Synthesize → Implement → Generate Bitstream
```
+ [`bert모델SW실행 → FPGA → accuracy 확인할때 (HIL환경) `](README_FPGA_overview.md)에서도 \
SW 쪽(`run_custom_transformer_with_hw.py`)의 `--module_num` 인수를 함께 변경해야함  

