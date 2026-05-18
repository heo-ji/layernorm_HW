# ── Waveform 설정 ─────────────────────────────────
set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
  if { [llength [get_objects]] > 0 } {
    add_wave /
    set_property needs_save false [current_wave_config]
  } else {
    send_msg_id Add_Wave-1 WARNING "No top level signals found."
  }
}

# ── 시뮬레이션 실행 ───────────────────────────────
# run all 대신 일정 시간만 실행 → Protocol Instances 수동 설정 가능
run all
