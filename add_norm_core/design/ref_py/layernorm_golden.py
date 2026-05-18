"""
add_norm_core / design / ref_py / layernorm_golden.py

SW golden reference for LayerNorm HW/SW verification.
Generates trace files compatible with add_norm_tb.v.

Outputs (written to ../trace/):
  in_data.txt     - 768 lines x 512-bit hex  (32 rows packed per cycle)
  sw_acc.txt      - 32 lines: acc     (26-bit, 18.8)
  sw_acc2.txt     - 32 lines: acc2    (34-bit, 26.8)
  sw_mean.txt     - 32 lines: mean    (16-bit,  8.8)
  sw_mean2.txt    - 32 lines: mean2   (32-bit, 16.16)
  sw_var.txt      - 32 lines: var     (24-bit,  8.16)
  sw_invsqrt.txt  - 32 lines: invsqrt (16-bit,  8.8)
  sw_norm.txt     - 768 lines x 512-bit hex  (normalized output)

Packing convention (matches top_calculator_one_row slicing):
  row[r] occupies bits [DATA_WIDTH*(r+1)-1 : DATA_WIDTH*r]
  i.e., row[0] at bits [15:0], row[31] at bits [511:496]
"""

import math
import random
import os

# -------------------------------------------------------
# Parameters -> config 파일에서 변수 가져오기
# -------------------------------------------------------
# NUM_ROWS   = 32
# D_MODEL    = 768
# DATA_WIDTH = 16   # 8.8 fixed-point

# # LUT valid variance range (8.16 format): 0x000487~0x222895 → ~0.018 ~ 34.15
# # To land inside LUT: std_dev ∈ [0.20, 5.80] → var ∈ [0.04, 33.6]
# VAR_TARGET_MIN = 0.01   # minimum target variance per row
# VAR_TARGET_MAX = 0.03   # maximum target variance per row


from config import NUM_ROWS, D_MODEL, DATA_WIDTH, VAR_TARGET_MIN, VAR_TARGET_MAX
import gen_input


# -------------------------------------------------------
# Fixed-point helpers  (identical logic to fxp_fp_sw_golden.py)
# -------------------------------------------------------
def qformat_value(value, int_bits, frac_bits):
    scale = 2 ** frac_bits
    low   = -(2 ** int_bits)
    high  =  (2 ** int_bits) - 1.0 / scale
    v = math.floor(value * scale) / scale
    return max(low, min(high, v))

def qfloor(value, frac_bits):
    return math.floor(value * (2 ** frac_bits)) / (2 ** frac_bits)

def to_hex(value, total_bits, frac_bits):
    """Signed fixed-point float -> unsigned two's-complement int."""
    int_val = int(math.floor(value * (2 ** frac_bits)))
    return int_val & ((1 << total_bits) - 1)

def fmt(value, total_bits, frac_bits):
    digits = (total_bits + 3) // 4
    return f"{to_hex(value, total_bits, frac_bits):0{digits}X}"
    #16진수포맷으로

# -------------------------------------------------------
# LUT  (same tables as HW invsqrt_LUT.v)
# -------------------------------------------------------
class LUT_InvSqrt:
    @staticmethod
    def _signed(hex_val, bits, frac):
        v = hex_val - (1 << bits) if hex_val & (1 << (bits - 1)) else hex_val
        return v / (2 ** frac)

    def __init__(self):
        d_hex = [
            0x000487, 0x00048D, 0x0004A3, 0x0004C9, 0x0004CD, 0x0004FD, 0x00051F, 0x000555,
            0x0005AF, 0x00127D, 0x002113, 0x004049, 0x006A8F, 0x009B74, 0x00CE59, 0x01175C,
            0x018431, 0x023404, 0x03871C, 0x07CDCC, 0x07DED9, 0x1DC36A, 0x1FAD66, 0x222895,
        ]
        s_hex = [
            0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000,
            0x8000, 0xDBC7, 0xEF08, 0xF9F0, 0xFD73, 0xFEAD, 0xFF28, 0xFF73,
            0xFFA9, 0xFFCC, 0xFFE4, 0xFFF5, 0xFFC6, 0xFFFE, 0xFFEA, 0x0000,
        ]
        t_hex = [
            0x27F3, 0x2542, 0x21FD, 0x1E90, 0x1ABB, 0x1723, 0x1308, 0x0EDE,
            0x0ABB, 0x0645, 0x04E2, 0x0379, 0x0297, 0x0214, 0x01CA, 0x018D,
            0x0153, 0x011D, 0x00E8, 0x00AE, 0x021C, 0x005E, 0x02BC, 0x0000,
        ]
        self.d = [self._signed(v, 24, 16) for v in d_hex]
        self.s = [self._signed(v, 16,  8) for v in s_hex]
        self.t = [self._signed(v, 16,  8) for v in t_hex]

    def forward(self, x):
        idx = len(self.d) - 1
        for i, dv in enumerate(self.d):
            if x < dv:
                idx = i
                break
        s_mul_x = qformat_value(self.s[idx] * x, 8, 8)
        return qformat_value(s_mul_x + self.t[idx], 8, 8)

# -------------------------------------------------------
# SW Qformat golden  (single token, D_MODEL values)
# -------------------------------------------------------
def sw_qformat_golden(values, lut):
    vals = [qformat_value(v, 8, 8) for v in values]

    # acc (18.8)
    acc = qformat_value(sum(vals), 18, 8)

    # acc2 (26.8): truncate each x^2 from 16.16 to 16.8, then accumulate
    acc2 = 0.0
    for v in vals:
        x2 = qformat_value(v * v, 16, 8)
        acc2 += x2
    acc2 = qformat_value(acc2, 26, 8)

    # mean (8.8): acc >>> 8 * 0.33203125
    mean = qfloor(acc / 256.0, 8) * 0.33203125
    mean = qformat_value(mean, 8, 8)

    # mean2 (16.16): acc2 >>> 8 * 0.33203125
    mean2 = qfloor(acc2 / 256.0, 8) * 0.33203125
    mean2 = qformat_value(mean2, 16, 16)

    # mean_sq (16.16)
    mean_sq = qformat_value(mean * mean, 16, 16)

    # var (8.16)
    var = qformat_value(mean2 - mean_sq, 8, 16)

    # invsqrt (8.8) via LUT
    eps   = 1.0 / (2 ** 16)
    v_eps = qformat_value(var + eps, 8, 16)
    invsqrt = lut.forward(v_eps)

    # norm (8.8)
    norm = [qformat_value((v - mean) * invsqrt, 8, 8) for v in vals]

    return dict(acc=acc, acc2=acc2, mean=mean, mean2=mean2,
                var=var, invsqrt=invsqrt, norm=norm)

# -------------------------------------------------------
# Main
# -------------------------------------------------------
def main():
    #random.seed(42) #같은 랜덤 값생성할때 #fortest
    lut = LUT_InvSqrt()

    rows, target_vars = gen_input.generate()

    # os.makedirs("../trace", exist_ok=True)

    # # Generate 8.8 inputs: each row gets its own (mu, sigma) so that
    # # the resulting variance differs per row and stays within LUT range.
    # #   target_var ∈ [VAR_TARGET_MIN, VAR_TARGET_MAX]  → var = sigma^2
    # #   sigma = sqrt(target_var)
    # #   mu    = small random offset (simulates non-zero layer mean)
    # rows        = []
    # target_vars = []
    # for _ in range(NUM_ROWS):
    #     target_var = random.uniform(VAR_TARGET_MIN, VAR_TARGET_MAX)
    #     sigma      = math.sqrt(target_var)
    #     mu         = random.uniform(-2.0, 2.0)
    #     raw = [random.gauss(mu, sigma) for _ in range(D_MODEL)]
    #     rows.append(raw)
    #     target_vars.append(target_var)

    # # --------------------------------------------------
    # # in_data.txt: 768 lines, each = 512-bit packed hex
    # # row[r] occupies bits [16*(r+1)-1 : 16*r]
    # # --------------------------------------------------
    # with open("../trace/in_data.txt", "w") as f:
    #     for k in range(D_MODEL):
    #         packed = 0
    #         for r in range(NUM_ROWS):
    #             v_hex = to_hex(rows[r][k], DATA_WIDTH, 8)
    #             packed |= (v_hex << (r * DATA_WIDTH))
    #         f.write(f"{packed:0128X}\n")

    # --------------------------------------------------
    # Run SW golden for each row
    # --------------------------------------------------
    results = [sw_qformat_golden(rows[r], lut) for r in range(NUM_ROWS)]

    # --------------------------------------------------
    # Intermediate SW traces (32 lines each, one per row)
    # --------------------------------------------------
    specs = [
        ("sw_acc.txt",      "acc",     26,  8),
        ("sw_acc2.txt",     "acc2",    34,  8),
        ("sw_mean.txt",     "mean",    16,  8),
        ("sw_mean2.txt",    "mean2",   32, 16),
        ("sw_var.txt",      "var",     24, 16),
        ("sw_invsqrt.txt",  "invsqrt", 16,  8),
    ]
    for fname, key, total_bits, frac_bits in specs:
        with open(f"../trace/{fname}", "w") as f:
            for r in range(NUM_ROWS):
                f.write(fmt(results[r][key], total_bits, frac_bits) + "\n")

    # --------------------------------------------------
    # sw_norm.txt: 768 lines of 512-bit packed hex
    # --------------------------------------------------
    with open("../trace/sw_norm.txt", "w") as f:
        for k in range(D_MODEL):
            packed = 0
            for r in range(NUM_ROWS):
                v_hex = to_hex(results[r]["norm"][k], DATA_WIDTH, 8)
                packed |= (v_hex << (r * DATA_WIDTH))
            f.write(f"{packed:0128X}\n")

    # --------------------------------------------------
    # Summary
    # --------------------------------------------------
    print("[SW Golden] Done. Trace files written to ../trace/")
    print(f"  {'Row':5s}  {'target_var':>10s}  {'sw_var(fxp)':>11s}  {'mean':>8s}  {'invsqrt':>8s}  {'LUT':>10s}")
    for r in range(NUM_ROWS):
        res    = results[r]
        lut_ok = "OK" if 0.0176849365234375 <= res['var'] <= 34.15852355957031 else "OUT_OF_LUT"
        print(f"  Row[{r:2d}]  {target_vars[r]:10.4f}  {res['var']:11.6f}  "
              f"{res['mean']:8.4f}  {res['invsqrt']:8.4f}  {lut_ok}")

if __name__ == "__main__":
    main()
