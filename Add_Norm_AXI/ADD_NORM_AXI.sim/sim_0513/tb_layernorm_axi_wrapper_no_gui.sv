`timescale 1ns/1ps

//─────────────────────────────────────────────
// ① 패키지 import
// Example Design 열면 이 이름들이 정확히 나옴
// IP 이름에 따라 달라짐 - 반드시 확인 필요
//─────────────────────────────────────────────
import axi4stream_vip_pkg::*;
import axi_vip_pkg::*;

// VIP IP 이름이 "axis_master_vip_0"이면 → "axis_master_vip_0_pkg"
// AXI-Stream Master VIP 패키지
// AXI-Stream Slave VIP 패키지
// AXI-Lite Master VIP 패키지
import axis_master_vip_0_pkg::*;
import axis_slave_vip_0_pkg::*;
import axi_lite_master_vip_0_pkg::*;


module tb_layernorm_axi_wrapper_no_gui();

parameter integer MODEL_DIMENSION    = 10; // 768;   // d_model , 전송 beat 수

//─────────────────────────────────────────────
// ② Clock / Reset 생성
// Verilog와 완전히 동일
//─────────────────────────────────────────────
// Clock / Reset
reg aclk    = 0;
reg aresetn = 0;
always #5 aclk = ~aclk;

//─────────────────────────────────────────────
// ③ DUT와 VIP를 연결할 신호 선언
// Verilog wire와 동일, logic 타입 사용 가능
//─────────────────────────────────────────────
// AXI-Lite 신호 (aw, ar, r, w, b)
wire [4:0]  s_awaddr;  wire s_awvalid, s_awready;
wire [31:0] s_wdata;   wire [3:0] s_wstrb; wire s_wvalid, s_wready;
wire [1:0]  s_bresp;   wire s_bvalid, s_bready;
wire [4:0]  s_araddr;  wire s_arvalid, s_arready;
wire [31:0] s_rdata;   wire [1:0] s_rresp; wire s_rvalid, s_rready;

// AXI-Stream 입력 (Master VIP → DUT)
wire [511:0] axis_in_tdata;
wire         axis_in_tvalid, axis_in_tready, axis_in_tlast;

// AXI-Stream 출력 (DUT → Slave VIP)
wire [511:0] axis_out_tdata;
wire         axis_out_tvalid, axis_out_tready, axis_out_tlast;

//─────────────────────────────────────────────
// ④ VIP 인스턴스 - 일반 모듈 인스턴스와 동일
//─────────────────────────────────────────────
// AXI-Lite Master VIP
// AXI-Stream Master VIP (DUT에 데이터 보내는 역할)
// AXI-Stream Slave VIP (DUT 출력 받는 역할)
axi_lite_master_vip_0 u_lite_mst (
    .aclk(aclk), .aresetn(aresetn),
    .m_axi_awaddr(s_awaddr),   .m_axi_awvalid(s_awvalid), .m_axi_awready(s_awready),
    .m_axi_wdata(s_wdata),     .m_axi_wstrb(s_wstrb),
    .m_axi_wvalid(s_wvalid),   .m_axi_wready(s_wready),
    .m_axi_bresp(s_bresp),     .m_axi_bvalid(s_bvalid),   .m_axi_bready(s_bready),
    .m_axi_araddr(s_araddr),   .m_axi_arvalid(s_arvalid), .m_axi_arready(s_arready),
    .m_axi_rdata(s_rdata),     .m_axi_rresp(s_rresp),
    .m_axi_rvalid(s_rvalid),   .m_axi_rready(s_rready)
);

axis_master_vip_0 u_axis_mst (
    .aclk(aclk), .aresetn(aresetn),
    .m_axis_tdata(axis_in_tdata),
    .m_axis_tvalid(axis_in_tvalid),
    .m_axis_tready(axis_in_tready),
    .m_axis_tlast(axis_in_tlast)
);

axis_slave_vip_0 u_axis_slv (
    .aclk(aclk), .aresetn(aresetn),
    .s_axis_tdata(axis_out_tdata),
    .s_axis_tvalid(axis_out_tvalid),
    .s_axis_tready(axis_out_tready),
    .s_axis_tlast(axis_out_tlast)
);

// DUT
layernorm_axi_wrapper dut (
    .s00_axi_aclk(aclk),      .s00_axi_aresetn(aresetn),
    .s00_axi_awaddr(s_awaddr), .s00_axi_awvalid(s_awvalid), .s00_axi_awready(s_awready),
    .s00_axi_wdata(s_wdata),   .s00_axi_wstrb(s_wstrb),
    .s00_axi_wvalid(s_wvalid), .s00_axi_wready(s_wready),
    .s00_axi_bresp(s_bresp),   .s00_axi_bvalid(s_bvalid),   .s00_axi_bready(s_bready),
    .s00_axi_araddr(s_araddr), .s00_axi_arvalid(s_arvalid), .s00_axi_arready(s_arready),
    .s00_axi_rdata(s_rdata),   .s00_axi_rresp(s_rresp),
    .s00_axi_rvalid(s_rvalid), .s00_axi_rready(s_rready),

    .s00_axis_aclk(aclk),      .s00_axis_aresetn(aresetn),
    .s00_axis_tdata(axis_in_tdata),
    .s00_axis_tvalid(axis_in_tvalid),
    .s00_axis_tready(axis_in_tready),
    .s00_axis_tlast(axis_in_tlast),

    .m00_axis_aclk(aclk),      .m00_axis_aresetn(aresetn),
    .m00_axis_tdata(axis_out_tdata),
    .m00_axis_tvalid(axis_out_tvalid),
    .m00_axis_tready(axis_out_tready),
    .m00_axis_tlast(axis_out_tlast)
);

//─────────────────────────────────────────────
// ⑤ Agent 변수 선언
// "이름_mst_t" "이름_slv_t"
//─────────────────────────────────────────────
// Agent 선언
axis_master_vip_0_mst_t    axis_mst_agent;
axis_slave_vip_0_slv_t     axis_slv_agent;
axi_lite_master_vip_0_mst_t lite_agent;

//─────────────────────────────────────────────
// ⑥ AXI-Lite 쓰기/읽기 task 정의
//─────────────────────────────────────────────
// AXI-Lite write task
task lite_write(input [31:0] addr, input [31:0] data);
    // VIP가 제공하는 내장 write 함수
    // prot = 0 (일반 접근), resp는 응답값 받는 변수

    xil_axi_resp_t resp; 
    lite_agent.AXI4LITE_WRITE_BURST(addr, 0, data, resp); // 0-> 일반 access.거의 기본값처럼 씀.
    
    $display("[LITE WRITE] addr=0x%02X data=0x%08X resp=%0d", addr, data, resp); //%02 = 최소 2자리
    
    if (resp !== XIL_AXI_RESP_OKAY) begin //write response 정상?
        $error("[LITE WRITE FAIL] resp=%0d", resp);
    end

endtask

// AXI-Lite read task
task lite_read(input [31:0] addr, output [31:0] data);
    xil_axi_resp_t resp;
    lite_agent.AXI4LITE_READ_BURST(addr, 0, data, resp);
    $display("[LITE READ]  addr=0x%02X data=0x%08X", addr, data);

    if (resp !== XIL_AXI_RESP_OKAY) begin //write response 정상?
        $error("[LITE READ FAIL] resp=%0d", resp);
    end
endtask

//─────────────────────────────────────────────
// ⑦ AXI-Stream 768(MODEL_DIMENSION) beats 전송 task
//─────────────────────────────────────────────
// AXI-Stream 768(MODEL_DIMENSION) beats 전송 task [continuous steam tvalid]
task send_768_beats(input [511:0] base_data);
    // transaction: AXI-Stream 한 beat(1사이클)의 데이터 묶음
    axi4stream_transaction  trans;
    int i;

    for (i = 0; i < MODEL_DIMENSION ; i++) begin
        // 매 beat마다 transaction 오브젝트 새로 생성
        trans = axis_mst_agent.driver.create_transaction("tx");

        // 데이터 설정
        // set_data_beat(0, data) : 0번째 beat에 data 넣기
        trans.set_data_beat(base_data + i);  // beat마다 다른값

        // tlast 설정 : 마지막 beat에만 1
        if (i == MODEL_DIMENSION-1 )
            trans.set_last(1'b1);
        else
            trans.set_last(1'b0);

        // beat 간격 0 사이클 (연속 전송)
        trans.set_delay(0);

        // 전송 큐에 넣기 (실제 신호는 VIP가 자동 생성)
        axis_mst_agent.driver.send(trans);
    end

    $display("[AXIS SEND] with continuous valid : all beats send DONE");
endtask

// AXI-Stream 768(MODEL_DIMENSION) beats 전송 task [input_gap steam tvalid]
task send_768_beats_with_validgap(input [511:0] base_data);
    // transaction: AXI-Stream 한 beat(1사이클)의 데이터 묶음
    axi4stream_transaction  trans;
    int i;

    for (i = 0; i < MODEL_DIMENSION ; i++) begin
        // 매 beat마다 transaction 오브젝트 새로 생성
        trans = axis_mst_agent.driver.create_transaction("tx");

        // 데이터 설정
        // set_data_beat(0, data) : 0번째 beat에 data 넣기
        trans.set_data_beat(base_data + i);  // beat마다 다른값

        // tlast 설정 : 마지막 beat에만 1
        if (i == MODEL_DIMENSION-1 )
            trans.set_last(1'b1);
        else
            trans.set_last(1'b0);

        // beat 간격
        // 4 beat마다 3 cycle delay
        if ((i % 4) == 3)
            trans.set_delay(3);
        else
            trans.set_delay(0);

        // 전송 큐에 넣기 (실제 신호는 VIP가 자동 생성)
        axis_mst_agent.driver.send(trans);
    end

    $display("[AXIS SEND] with input valid gap : all beats send DONE");
endtask


//─────────────────────────────────────────────
// ⑧ 메인 테스트 시나리오
//─────────────────────────────────────────────
initial begin
    // Agent 생성 - new("임의 이름", vip인스턴스.inst.IF)
     // .inst.IF 는 VIP 내부 인터페이스 - 반드시 이 형태로
    axis_mst_agent = new("mst", u_axis_mst.inst.IF);
    axis_slv_agent = new("slv", u_axis_slv.inst.IF);
    lite_agent     = new("lite", u_lite_mst.inst.IF);


    // start_master() : 이 VIP는 Master로 동작 시작
    // start_slave()  : 이 VIP는 Slave로 동작 시작
    //                  (tready 자동으로 1 유지해줌)
    axis_mst_agent.start_master();
    axis_slv_agent.start_slave();
    lite_agent.start_master();

    // Reset
    aresetn = 0;
    repeat(10) @(posedge aclk);
    #200;
    aresetn = 1;
    repeat(5) @(posedge aclk);

    //── 1. 설정 레지스터 쓰기 ─────────────────
    lite_write(32'h08, MODEL_DIMENSION); //slv_reg2 offset = 0x08 , d_model =768
    lite_write(32'h0C, 32'h0855); //slv_reg3 offset = 0x0C , [i_shift_value = 5'sd8 ,i_mult_value  = 8'sb01010101;]
    //768로 고정함
    
    //── 2. ITER1 시작 ─────────────────────────
    lite_write(32'h00, 32'd1); //slv_reg0 , cmd = 1
    //── 3. ITER1 데이터 전송 (MODEL_DIMENSION_768 beats) ──────
    //send_768_beats(512'hA5A5);  // 테스트 데이터
    send_768_beats_with_validgap(512'hA5A5); // 테스트 데이터

    //── 4. ITER1 DONE 대기 (status polling) ───
    begin
        logic [31:0] status;
        status = 0;
        while (status != 32'd1) begin
            @(posedge aclk);
            lite_read(32'h04, status); //slv_reg1 offset = 0x04 // 1 = WAIT_ITER2
        end
        $display(">>> ITER1 DONE,WAIT_ITER2 ");
    end

    //── 5. ITER2 시작 ─────────────────────────
    //── 6. ITER2 데이터 전송 ──────────────────
    lite_write(32'h00, 32'd2); // cmd = 2
    //send_768_beats(512'hA5A5); //같은 테스트 데이터
    send_768_beats_with_validgap(512'hA5A5); // 테스트 데이터


    //── 7. 출력 DONE 대기 후 종료 ─────────────
    repeat(3000) @(posedge aclk);
    $display(">>> 시뮬레이션 종료");
    $finish;
end

//─────────────────────────────────────────────
// ⑨ 출력 모니터링 (파형 말고 텍스트로도 확인 , MODEL_DIMENSION 번 출력)
//─────────────────────────────────────────────
always @(posedge aclk) begin
    if (axis_out_tvalid && axis_out_tready) //실제 transfer된 beat만 로그 출력 , TVALID/TREADY handshake 정상? 을 체크
        $display("[OUT] first row data[15:0] in 32row =%h , tlast=%b",
                  axis_out_tdata[15:0], axis_out_tlast);
end


// //─────────────────────────────────────────────
// // ⑨ 모니터링
// //─────────────────────────────────────────────


// ── ① FSM 상태 전환 모니터 ──────────────────
// dut 내부 c_state 계층적 참조: 변할 때마다 출력
always @(dut.c_state) begin
    case (dut.c_state)
        3'b000: $display("[DUT_FSM] t=%0t ns  IDLE        (status=0)", $time);
        3'b001: $display("[DUT_FSM] t=%0t ns  ITER1       (status=9)", $time);
        3'b010: $display("[DUT_FSM] t=%0t ns  STORE       (status=9)", $time);
        3'b011: $display("[DUT_FSM] t=%0t ns  WAIT_ITER2  (status=1)", $time);
        3'b100: $display("[DUT_FSM] t=%0t ns  ITER2       (status=2)", $time);
        default:$display("[DUT_FSM] t=%0t ns  UNKNOWN=%b",  $time, dut.c_state);
    endcase
end

// // output beat count and display last beat num
integer out_cnt;
always @(posedge aclk) begin
    if (!aresetn)
        out_cnt <= 0;

    else if (axis_out_tvalid && axis_out_tready) begin
        out_cnt <= out_cnt + 1;

        if (axis_out_tlast)
            $display("[OUT DONE] TOTAL OUT BEATS = %0d,  tlast = %b", out_cnt+1, axis_out_tlast );
    end
end

//TLAST assertion (MODEL_DIMENSION에서 stream_out_tlast 안나오면 에러띄움 )
always @(posedge aclk) begin
    if (axis_out_tvalid && axis_out_tready) begin

        if (out_cnt == MODEL_DIMENSION-1)
            assert(axis_out_tlast); //axis_out_tlast==1

        else
            assert(!axis_out_tlast);
    end
end

endmodule

// // ── ② 출력 beat 카운터 + TLAST 타이밍 체크 + 지연 측정 ──
// integer out_beat_cnt;
// integer iter2_start_cycle;
// logic   first_out_flag;

// initial begin
//     out_beat_cnt      = 0;
//     iter2_start_cycle = 0;
//     first_out_flag    = 0;
// end

// // ITER2 진입 시점 기록 (처음 한 번만)
// always @(posedge aclk) begin
//     if (dut.c_state == 3'b100 && iter2_start_cycle == 0)
//         iter2_start_cycle <= $time / 10; // 10ns = 1사이클
// end

// // output beat 카운팅
// always @(posedge aclk) begin
//     if (!aresetn) begin
//         out_beat_cnt   <= 0;
//         first_out_flag <= 0;
//     end
//     else if (axis_out_tvalid && axis_out_tready) begin //output handshake

//         // 첫 output beat 지연 측정
//         if (!first_out_flag) begin
//             first_out_flag <= 1;
//             $display("[LATENCY] ITER2 시작 후 첫 output까지 %0d 사이클",
//                       ($time/10) - iter2_start_cycle);
//         end

//         // 매 beat row0 값 + tlast 출력
//         $display("[OUT #%03d] row0[15:0]=%h  tlast=%b",
//                   out_beat_cnt, axis_out_tdata[15:0], axis_out_tlast);

//         // TLAST 위치 체크
//         if (axis_out_tlast) begin
//             if (out_beat_cnt == MODEL_DIMENSION - 1)
//                 $display("[TLAST OK ] %0d번째 beat에 tlast (정상)", out_beat_cnt + 1);
//             else
//                 $display("[TLAST ERR] %0d번째 beat에 tlast (기대=%0d)", out_beat_cnt + 1, MODEL_DIMENSION);
//             // 다음 iteration 대비 리셋
//             out_beat_cnt   <= 0;
//             first_out_flag <= 0;
//             iter2_start_cycle <= 0;
//         end
//         else begin
//             out_beat_cnt <= out_beat_cnt + 1;
//         end
//     end
// end

// // ── ③ Deadlock 감지 ──────────────────────────
// // m_axis_tvalid=1인데 tready=0 이 N사이클 지속 → 경고
// parameter integer DEADLOCK_THRESH = 200;
// integer deadlock_cnt;
// initial deadlock_cnt = 0;

// always @(posedge aclk) begin
//     if (axis_out_tvalid && !axis_out_tready)
//         deadlock_cnt <= deadlock_cnt + 1;
//     else
//         deadlock_cnt <= 0;

//     if (deadlock_cnt == DEADLOCK_THRESH)
//         $display("[WARNING] DEADLOCK: tvalid=1 tready=0 상태 %0d사이클 지속!", DEADLOCK_THRESH);
// end

// // ── ④ 시뮬레이션 타임아웃 ────────────────────
// parameter integer SIM_TIMEOUT = 100000; // 사이클
// initial begin
//     repeat(SIM_TIMEOUT) @(posedge aclk);
//     $display("[TIMEOUT] %0d 사이클 초과 강제 종료", SIM_TIMEOUT);
//     $finish;
// end

