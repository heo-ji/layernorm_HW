import math, random, os

# --- 128-bit bus parameters ---
NUM_ROWS   = 8      # 128 / 16 = 8 parallel rows
D_MODEL    = 768
DATA_WIDTH = 16     # 8.8 fixed-point

VAR_TARGET_MIN = 0.5
VAR_TARGET_MAX = 20

OUT_DIR = os.path.join(os.path.dirname(__file__), "../../trace128")
os.makedirs(OUT_DIR, exist_ok=True)

# --- Fixed-point helpers (identical to layernorm_golden.py) ---
def qformat_value(value, int_bits, frac_bits):
    scale = 2 ** frac_bits
    low   = -(2 ** int_bits)
    high  =  (2 ** int_bits) - 1.0 / scale
    v = math.floor(value * scale) / scale
    return max(low, min(high, v))

def qfloor(value, frac_bits):
    return math.floor(value * (2 ** frac_bits)) / (2 ** frac_bits)

def to_hex(value, total_bits, frac_bits):
    int_val = int(math.floor(value * (2 ** frac_bits)))
    return int_val & ((1 << total_bits) - 1)

def fmt(value, total_bits, frac_bits):
    digits = (total_bits + 3) // 4
    return f"{to_hex(value, total_bits, frac_bits):0{digits}X}"

# --- LUT (same as layernorm_golden.py) ---
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

# --- SW golden (same algorithm as layernorm_golden.py) ---
def sw_qformat_golden(values, lut):
    vals = [qformat_value(v, 8, 8) for v in values]

    acc = qformat_value(sum(vals), 18, 8)

    acc2 = 0.0
    for v in vals:
        x2 = qformat_value(v * v, 16, 8)
        acc2 += x2
    acc2 = qformat_value(acc2, 26, 8)

    # mean: acc >>> 8 * 0.33203125  (1/768 approx, i_shift=8, i_mult=0x55)
    mean = qfloor(acc / 256.0, 8) * 0.33203125
    mean = qformat_value(mean, 8, 8)

    mean2 = qfloor(acc2 / 256.0, 8) * 0.33203125
    mean2 = qformat_value(mean2, 16, 16)

    mean_sq = qformat_value(mean * mean, 16, 16)
    var = qformat_value(mean2 - mean_sq, 8, 16)

    eps     = 1.0 / (2 ** 16)
    v_eps   = qformat_value(var + eps, 8, 16)
    invsqrt = lut.forward(v_eps)

    norm = [qformat_value((v - mean) * invsqrt, 8, 8) for v in vals]

    return dict(acc=acc, acc2=acc2, mean=mean, mean2=mean2,
                var=var, invsqrt=invsqrt, norm=norm)

# --- Generate input rows ---
random.seed(2026)
lut = LUT_InvSqrt()

rows = []
target_vars = []
for _ in range(NUM_ROWS):
    target_var = random.uniform(VAR_TARGET_MIN, VAR_TARGET_MAX)
    sigma = math.sqrt(target_var)
    mu    = random.uniform(-2.0, 2.0)
    raw   = [random.gauss(mu, sigma) for _ in range(D_MODEL)]
    rows.append(raw)
    target_vars.append(target_var)

# --- in_data.txt: 768 lines x 32 hex chars (128-bit packed) ---
with open(os.path.join(OUT_DIR, "in_data.txt"), "w") as f:
    for k in range(D_MODEL):
        packed = 0
        for r in range(NUM_ROWS):
            v_hex = to_hex(rows[r][k], DATA_WIDTH, 8)
            packed |= (v_hex << (r * DATA_WIDTH))
        f.write(f"{packed:032X}\n")

print("[1/2] in_data.txt  (768 lines x 32 hex chars)")

# --- Compute golden ---
results = [sw_qformat_golden(rows[r], lut) for r in range(NUM_ROWS)]

# --- rtl scalar files (8 lines each, same bit widths as 512-bit version) ---
specs = [
    ("rtl_acc.txt",     "acc",     26,  8),
    ("rtl_acc2.txt",    "acc2",    34,  8),
    ("rtl_mean.txt",    "mean",    16,  8),
    ("rtl_mean2.txt",   "mean2",   32, 16),
    ("rtl_var.txt",     "var",     24, 16),
    ("rtl_invsqrt.txt", "invsqrt", 16,  8),
]
for fname, key, total_bits, frac_bits in specs:
    with open(os.path.join(OUT_DIR, fname), "w") as f:
        for r in range(NUM_ROWS):
            f.write(fmt(results[r][key], total_bits, frac_bits) + "\n")

# --- rtl_norm.txt: 768 lines x 32 hex chars ---
with open(os.path.join(OUT_DIR, "rtl_norm.txt"), "w") as f:
    for k in range(D_MODEL):
        packed = 0
        for r in range(NUM_ROWS):
            v_hex = to_hex(results[r]["norm"][k], DATA_WIDTH, 8)
            packed |= (v_hex << (r * DATA_WIDTH))
        f.write(f"{packed:032X}\n")

print("[2/2] rtl_*.txt    (8 lines x scalar, 768 lines x 32 hex chars for norm)")

# --- Summary ---
print(f"\n=== trace128 Summary ===")
print(f"  Bus width : 128-bit  (NUM_ROWS={NUM_ROWS})")
print(f"  D_MODEL   : {D_MODEL} cycles")
print(f"  Output    : {os.path.abspath(OUT_DIR)}")
print(f"\n  {'Row':5s}  {'target_var':>10s}  {'var(fxp)':>10s}  {'mean':>8s}  {'invsqrt':>8s}  LUT")
for r in range(NUM_ROWS):
    res = results[r]
    lut_ok = "OK" if 0.0176849365234375 <= res['var'] <= 34.15852355957031 else "OUT_OF_LUT"
    print(f"  Row[{r:2d}]  {target_vars[r]:10.4f}  {res['var']:10.6f}  "
          f"{res['mean']:8.4f}  {res['invsqrt']:8.4f}  {lut_ok}")
