# LayerNorm FPGA를 이용한 HIL (Hardware-in-the-Loop)

> **IP 코어** (데이터 포맷, 비트폭, 파라미터) → **[`README_HW.md`](README_HW.md)**  
> **PL(AXI Wrapper)부분** (레지스터 맵, FSM, PYNQ 제어 코드) → **[`README_AXI_WRAPPER.md`](README_AXI_WRAPPER.md)**

> **SW 코드 상세 / HIL 실행 방법** →  
[repository [layernorm_FPGA]/README.md 바로가기](https://github.com/heo-ji/layernorm_FPGA)
---

## 1. Overview
Pytorch BERT 모델의 GLUE task inference 중 LayerNorm만 ZCU111 FPGA로 오프로딩,  
나머지 연산은 Host PC SW에서 수행하는 HIL(Hardware in the Loop)환경

```
[Host PC]                          
────────────────────             
BERT forward pass                
  └─ LayerNorm 호출                  
         ↕ TCP (int16)로  → FPGA(ZCU111)에 데이터 전송            
  └─ 나머지 연산 (SW)


[FPGA : ZCU111]
──────────────────────
PS : ps_server.py
↕ AXI DMA
PL : LayerNorm IP

```

이때, BERT SW 모델은 HW 스펙을 그대로 반영한 **SW golden 모델**
: HW스펙에 맞게 SW 값 clipping & precision제한, LUT 연산수행, softmax에선 2-base 수행 등..이루어짐  
: repository **e2e-bert-accel-SW** 의 transformer/src/model/bert

---

## 2. 구성
* **Host PC (SW)      :** PyTorch 기반 BERT 모델 구동, 텐서 연산 처리, TCP로 FPGA에 LayerNorm 연산 요청
* **Target Board (HW) :** Xilinx Zynq UltraScale+ RFSoC ZCU111 보드  
  
* **FPGA PS :** PYNQ 기반 TCP 서버, AXI DMA + AXI-Lite 로 PL IP 제어&데이터 전달
* **FPGA PL :** `layernorm_axi_wrapper` IP, 8.8 fixed-point 기반 LayerNorm 연산

  
* 현재 FPGA bitstream(`Add_Norm_PYNQ_v2/project_dma_wrapper`)은 data bus size = 128bit (MODULE_NUM = 8)으로 구현됨

---

## 3. HIL 동작

### Mode 1 — 실제 HW accuracy 측정

FPGA LayerNorm 출력이 다음 연산 입력으로 그대로 전달
 : HW 오차가 BERT 체인 전체에 누적된 **실제 accuracy**측정


### Mode 2 — SW golden 데이터 유지 + worst-case 입력 텐서값 추출

데이터는 SW golden 결과로 계속 흐르고 (accuracy 영향 없음),  
동시에 FPGA에도 동일 입력을 보내 **HW vs SW 오차 비교** 
inference 완료 후 오차가 가장 큰 입력을 저장하기위함

```
BERT :  [Embedding] → [Attention] → [LayerNorm ← SW golden] → [FFN] → ...
                                                    ↕ 비교 후 오차 계산
                                             [LayerNorm ← FPGA]
                                             → worst-case 유발한 입력텐서 저장
```

---

## 5. 데이터 흐름 요약

```
Host PC                             ZCU111 PS                ZCU111 PL
──────────                          ─────────               ──────────
Bert 모델 forward중 layernorm연산
float32 텐서
  │
  ├─ int16 변환 (×256 clip)
  │ 배치1개
  └─ TCP 전송 ──────────────→       row-major int16 수신                                 
                                    module_num=8(128bit bus의 경우)단위로 잘라서,
                                    chunk.T.flatten()로 column-first
                                    DMA 버퍼에 복사
                                    ITER1 (mean/invsqrt) ──→  LayerNorm IP (pooling)
                                    ITER2 (normalization) 
                                                          ←─  결과 출력
                                    reshape → row-major
                                    module_num=8(128bit bus의 경우)단위를 다시 묶어서
                                    TCP 송신
  TCP 수신
  Batch횟수의 output.append
  └─ int16 → float32 (÷256)
  └─ 다음 연산/레이어로
```
> SW 코드 상세 / 실행 방법* →  [repository [layernorm_FPGA]/README.md 바로가기](https://github.com/heo-ji/layernorm_FPGA)

> 데이터 포맷 상세 (column-first 패킹, beat 구조) → [`README_HW.md`](README_HW.md)
