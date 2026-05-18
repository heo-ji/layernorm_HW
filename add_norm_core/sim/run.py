#!/usr/bin/env python

import os
import sys
import argparse

TRACE_DIR  = "../trace"
CLEAN_CMD  = "rm -rf xsim.dir xsim_work xvlog.log xvlog.pb xelab.log xelab.pb " \
             "xsim.jou xsim.log webtalk.jou webtalk.log *.wdb *.pb " \
             "../trace"

NUM_ROWS   = 32
DATA_WIDTH = 16  # bits per row in 512-bit bus

# -------------------------------------------------------
# Main
# -------------------------------------------------------
def main():
    args = parse_args()
    if args.clean:
        run_cmd(CLEAN_CMD)
        print("Clean Done!!")
    else:
        run_sim(args)
        check_result()
        print("Success Simulation!!")

# -------------------------------------------------------
# Arguments  (mirrors cnn_core/sim/run.py)
# -------------------------------------------------------
def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-waveform", dest="waveform", action="store_true",
                        help="Open waveform viewer (Vivado GUI)")
    parser.add_argument("-clean",    dest="clean",    action="store_true",
                        help="Clean generated files")
    return parser.parse_args()

# -------------------------------------------------------
# Directory setup
# -------------------------------------------------------
def make_dirs():
    os.system(f"rm -rf {TRACE_DIR}")
    if not os.path.exists(TRACE_DIR):
        os.makedirs(TRACE_DIR)

# -------------------------------------------------------
# Simulation flow
# -------------------------------------------------------
def run_sim(args):
    make_dirs()
    run_sw_golden()
    run_rtl_v(args)

def run_sw_golden():
    run_cmd(f"{sys.executable} ../design/ref_py/layernorm_golden.py")

def run_rtl_v(args):
    run_cmd("xvlog -f ./listfile.f")
    run_cmd("xelab add_norm_tb -debug wave -s add_norm_tb")

    if args.waveform:
        run_cmd("xsim add_norm_tb -gui -wdb add_norm_tb.wdb")
    else:
        run_cmd("xsim add_norm_tb -R")

# -------------------------------------------------------
# Result comparison
# -------------------------------------------------------

# scalar 신호: 32줄 x 짧은 hex → diff로 충분
DIFF_PAIRS = [
    ("acc",     "sw_acc.txt",     "rtl_acc.txt"),
    ("acc2",    "sw_acc2.txt",    "rtl_acc2.txt"),
    ("mean",    "sw_mean.txt",    "rtl_mean.txt"),
    ("mean2",   "sw_mean2.txt",   "rtl_mean2.txt"),
    ("var",     "sw_var.txt",     "rtl_var.txt"),
    ("invsqrt", "sw_invsqrt.txt", "rtl_invsqrt.txt"),
    ("norm", "sw_norm.txt", "rtl_norm.txt"),
]

def check_result():
    # scalar 신호: diff
    for sig_name, sw_file, rtl_file in DIFF_PAIRS:
        sw_path  = f"{TRACE_DIR}/{sw_file}"
        rtl_path = f"{TRACE_DIR}/{rtl_file}"
        ret = os.system(f"diff -i {sw_path} {rtl_path}") #diff -i 는 대소문자 구분 x
        if ret:
            print(f"[{sig_name}] MISMATCH")
        else:
            print(f"[{sig_name}] PASS")

    # norm: 512bit packed → row별 언팩해서 비교 , diff 안보일때
    #check_norm(f"{TRACE_DIR}/sw_norm.txt", f"{TRACE_DIR}/rtl_norm.txt")

def check_norm(sw_path, rtl_path):
    with open(sw_path)  as f: sw_lines  = [l.strip() for l in f if l.strip()]
    with open(rtl_path) as f: rtl_lines = [l.strip() for l in f if l.strip()]

    if len(sw_lines) != len(rtl_lines):
        print(f"[norm] FAIL  line count mismatch  SW={len(sw_lines)}  RTL={len(rtl_lines)}")
        return

    mask = (1 << DATA_WIDTH) - 1
    mismatches = []  # (cycle, row, sw_val, rtl_val)

    for cycle, (sw_h, rtl_h) in enumerate(zip(sw_lines, rtl_lines)):
        sw_packed  = int(sw_h,  16)
        rtl_packed = int(rtl_h, 16)
        if sw_packed == rtl_packed:
            continue
        for row in range(NUM_ROWS):
            sw_val  = (sw_packed  >> (row * DATA_WIDTH)) & mask
            rtl_val = (rtl_packed >> (row * DATA_WIDTH)) & mask
            if sw_val != rtl_val:
                mismatches.append((cycle, row, sw_val, rtl_val))

    if not mismatches:
        print("[norm] PASS")
        return

    print(f"[norm] MISMATCH  ({len(mismatches)} point(s))")
    for cycle, row, sw_val, rtl_val in mismatches[:10]:
        sw_f  = (sw_val  - 0x10000 if sw_val  >= 0x8000 else sw_val)  / 256.0
        rtl_f = (rtl_val - 0x10000 if rtl_val >= 0x8000 else rtl_val) / 256.0
        print(f"  cycle={cycle:4d}  row={row:2d}  "
              f"SW=0x{sw_val:04X}({sw_f:+.4f})  RTL=0x{rtl_val:04X}({rtl_f:+.4f})")
    if len(mismatches) > 10:
        print(f"  ... and {len(mismatches) - 10} more")

# -------------------------------------------------------
def run_cmd(cmd):
    print(cmd)
    if os.system(cmd):
        print("Error: command failed")
        sys.exit(1)

if __name__ == "__main__":
    main()
