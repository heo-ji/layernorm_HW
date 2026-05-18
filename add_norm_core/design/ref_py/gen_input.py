'''
Generated traces in ../trace/:
  in_data.txt     - 768 lines x 512-bit hex, packed 32 rows per cycle
  sw_acc.txt      - 32 lines, acc      Q18.8
  sw_acc2.txt     - 32 lines, acc2     Q26.8
  sw_mean.txt     - 32 lines, mean     Q8.8
  sw_mean2.txt    - 32 lines, mean2    Q16.16
  sw_var.txt      - 32 lines, var      Q8.16
  sw_invsqrt.txt  - 32 lines, invsqrt  Q8.8
  sw_norm.txt     - 768 lines x 512-bit hex, packed normalized output
'''
import math
import random
import os
# config 파일에서 변수 가져오기
from config import NUM_ROWS, D_MODEL, DATA_WIDTH, VAR_TARGET_MIN, VAR_TARGET_MAX

def to_hex(value, total_bits, frac_bits):
    int_val = int(math.floor(value * (2 ** frac_bits)))
    return int_val & ((1 << total_bits) - 1)

def generate():
    os.makedirs("../trace", exist_ok=True)

    # Generate 8.8 inputs: each row gets its own (mu, sigma) so that
    # the resulting variance differs per row and stays within LUT range.
    #   target_var ∈ [VAR_TARGET_MIN, VAR_TARGET_MAX]  → var = sigma^2
    #   sigma = sqrt(target_var)
    #   mu    = small random offset (simulates non-zero layer mean)
    rows        = []
    target_vars = []
    for _ in range(NUM_ROWS):
        target_var = random.uniform(VAR_TARGET_MIN, VAR_TARGET_MAX)
        sigma      = math.sqrt(target_var)
        mu         = random.uniform(-2.0, 2.0)
        raw = [random.gauss(mu, sigma) for _ in range(D_MODEL)]
        rows.append(raw)
        target_vars.append(target_var)

    # --------------------------------------------------
    # in_data.txt: 768 lines, each = 512-bit packed hex
    # row[r] occupies bits [16*(r+1)-1 : 16*r]
    # --------------------------------------------------
    with open("../trace/in_data.txt", "w") as f:
        for k in range(D_MODEL):
            packed = 0
            for r in range(NUM_ROWS):
                v_hex = to_hex(rows[r][k], DATA_WIDTH, 8)
                packed |= (v_hex << (r * DATA_WIDTH))
            f.write(f"{packed:0128X}\n")


    print("[Input Gen] in_data.txt generated.")
    # rows와 target_vars를 반환하여 layernorm_golden.py에서 바로 쓸 수 있게 함
    return rows, target_vars


if __name__ == "__main__":
    generate()