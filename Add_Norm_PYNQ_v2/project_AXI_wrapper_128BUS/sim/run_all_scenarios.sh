#!/bin/bash
# ================================================================
# run_all_scenarios.sh
# SCN_BASIC(0) / SCN_VALID_GAP(1) / SCN_BACKPRESSURE(2) 순차 실행
# GUI가 뜨고, 닫으면 다음 시나리오로 넘어감
# ================================================================

set -e

PROTOINST=./protoinst_files/layernorm_sim.protoinst

# ══════════════════════════════════════════════════════════════
# SCENARIO 0 : SCN_BASIC
# ══════════════════════════════════════════════════════════════
echo "=============================================="
echo "[SCN 0] SCN_BASIC - Compile"
echo "=============================================="
xvlog --sv -L xilinx_vip -f ./design_list.f
xvlog --sv -L xilinx_vip -f ./testbench_list.f

echo "[SCN 0] SCN_BASIC - Elaborate"
xelab tb_layernorm_axi_wrapper_no_gui -L xilinx_vip -debug all -s tb_layernorm_axi_wrapper_no_gui_sim

echo "[SCN 0] SCN_BASIC - Simulate (GUI) → 창 닫으면 다음 시나리오 시작"
xsim tb_layernorm_axi_wrapper_no_gui_sim \
    -gui \
    -testplusarg SCENARIO=0 \
    -wdb simulate_scn0_basic.wdb \
    -tclbatch sim.tcl \
    -log simulate_scn0_basic.log \
    -protoinst ${PROTOINST}


# ══════════════════════════════════════════════════════════════
# SCENARIO 1 : SCN_VALID_GAP
# ══════════════════════════════════════════════════════════════
echo ""
echo "=============================================="
echo "[SCN 1] SCN_VALID_GAP - Compile"
echo "=============================================="
xvlog --sv -L xilinx_vip -f ./design_list.f
xvlog --sv -L xilinx_vip -f ./testbench_list.f

echo "[SCN 1] SCN_VALID_GAP - Elaborate"
xelab tb_layernorm_axi_wrapper_no_gui -L xilinx_vip -debug all -s tb_layernorm_axi_wrapper_no_gui_sim

echo "[SCN 1] SCN_VALID_GAP - Simulate (GUI) → 창 닫으면 다음 시나리오 시작"
xsim tb_layernorm_axi_wrapper_no_gui_sim \
    -gui \
    -testplusarg SCENARIO=1 \
    -wdb simulate_scn1_valid_gap.wdb \
    -tclbatch sim.tcl \
    -log simulate_scn1_valid_gap.log \
    -protoinst ${PROTOINST}


# ══════════════════════════════════════════════════════════════
# SCENARIO 2 : SCN_BACKPRESSURE
# ══════════════════════════════════════════════════════════════
echo ""
echo "=============================================="
echo "[SCN 2] SCN_BACKPRESSURE - Compile"
echo "=============================================="
xvlog --sv -L xilinx_vip -f ./design_list.f
xvlog --sv -L xilinx_vip -f ./testbench_list.f

echo "[SCN 2] SCN_BACKPRESSURE - Elaborate"
xelab tb_layernorm_axi_wrapper_no_gui -L xilinx_vip -debug all -s tb_layernorm_axi_wrapper_no_gui_sim

echo "[SCN 2] SCN_BACKPRESSURE - Simulate (GUI) → 창 닫으면 완료"
xsim tb_layernorm_axi_wrapper_no_gui_sim \
    -gui \
    -testplusarg SCENARIO=2 \
    -wdb simulate_scn2_backpressure.wdb \
    -tclbatch sim.tcl \
    -log simulate_scn2_backpressure.log \
    -protoinst ${PROTOINST}


echo ""
echo "=============================================="
echo "[SUMMARY] All 3 scenarios done."
echo "  simulate_scn0_basic.log"
echo "  simulate_scn1_valid_gap.log"
echo "  simulate_scn2_backpressure.log"
echo "=============================================="
