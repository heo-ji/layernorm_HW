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

parameter integer MODEL_DIMENSION = 768; // 768;   // d_model , 전송 beat 수

//─────────────────────────────────────────────

//
// SCN_BASIC        : 기본 시나리오
//                   input valid 연속, output ready 기본 동작
//
// SCN_VALID_GAP    : input valid bubble 시나리오
//                   Master VIP가 중간중간 valid gap을 넣어서 입력
//
// SCN_BACKPRESSURE : output backpressure 시나리오
//                   Slave VIP가 tready를 일부러 0으로 내려서 출력 stall 확인

localparam int SCN_BASIC        = 0;
localparam int SCN_VALID_GAP    = 1;
localparam int SCN_BACKPRESSURE = 2;

// 테스트 시나리오 선택
parameter int DEFAULT_SCENARIO = SCN_BASIC;
// parameter int DEFAULT_SCENARIO = SCN_VALID_GAP;
//parameter int DEFAULT_SCENARIO = SCN_BACKPRESSURE;

// plusarg로도 변경 가능
// 예: xsim 실행 옵션에 +SCENARIO=0 / +SCENARIO=1 / +SCENARIO=2
int test_scenario;




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
    .s00_axi_aclk(aclk),        .s00_axi_aresetn(aresetn),
    .s00_axi_awaddr(s_awaddr),  .s00_axi_awvalid(s_awvalid), .s00_axi_awready(s_awready),
    .s00_axi_wdata(s_wdata),    .s00_axi_wstrb(s_wstrb),
    .s00_axi_wvalid(s_wvalid),  .s00_axi_wready(s_wready),
    .s00_axi_bresp(s_bresp),    .s00_axi_bvalid(s_bvalid),   .s00_axi_bready(s_bready),
    .s00_axi_araddr(s_araddr),  .s00_axi_arvalid(s_arvalid), .s00_axi_arready(s_arready),
    .s00_axi_rdata(s_rdata),    .s00_axi_rresp(s_rresp),
    .s00_axi_rvalid(s_rvalid),  .s00_axi_rready(s_rready),

    .s00_axis_aclk(aclk),       .s00_axis_aresetn(aresetn),
    .s00_axis_tdata(axis_in_tdata),
    .s00_axis_tvalid(axis_in_tvalid),
    .s00_axis_tready(axis_in_tready),
    .s00_axis_tlast(axis_in_tlast),

    .m00_axis_aclk(aclk),       .m00_axis_aresetn(aresetn),
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
axis_master_vip_0_mst_t     axis_mst_agent;
axis_slave_vip_0_slv_t      axis_slv_agent;
axi_lite_master_vip_0_mst_t lite_agent;

// Backpressure용 ready generator
axi4stream_ready_gen axis_rgen;

// 출력 완료 확인용
integer out_cnt;
logic   output_done;

//─────────────────────────────────────────────
// trace 파일 기반 입력/출력/비교용 변수
//
// trace/in_data.txt  : AXI input stream stimulus
// trace/rtl_norm.txt : 예상되는 output stream, golden
// trace/AXI_norm.txt : AXI system simulation에서 실제 나온 output stream
//
// 512bit packing:
// bits[15:0]     = row0[k]
// bits[31:16]    = row1[k]
// ...
// bits[511:496]  = row31[k]
//─────────────────────────────────────────────
string input_file;
string rtl_norm_file;
string axi_norm_file;

logic [511:0] input_mem    [0:MODEL_DIMENSION-1];
logic [511:0] rtl_norm_mem [0:MODEL_DIMENSION-1];
logic [511:0] axi_norm_mem [0:MODEL_DIMENSION-1];

integer f_axi_norm;
integer file_check_fd;
integer axi_norm_write_cnt;
integer compare_err_cnt;


//─────────────────────────────────────────────
// 시나리오 이름 출력용 function
//─────────────────────────────────────────────
function string scenario_name(input int scn);
    case (scn)
        SCN_BASIC:        scenario_name = "SCN_BASIC : continuous input valid + default output ready";
        SCN_VALID_GAP:    scenario_name = "SCN_VALID_GAP : input valid bubble";
        SCN_BACKPRESSURE: scenario_name = "SCN_BACKPRESSURE : output tready backpressure";
        default:          scenario_name = "UNKNOWN_SCENARIO";
    endcase
endfunction


//─────────────────────────────────────────────
// [추가] VIP Agent 생성 및 start task
// 메인 initial 안을 간단하게 만들기 위해 분리
//─────────────────────────────────────────────
task automatic init_vip_agents();
begin
    // Agent 생성 - new("임의 이름", vip인스턴스.inst.IF)
    // .inst.IF 는 VIP 내부 인터페이스 - 반드시 이 형태로
    axis_mst_agent = new("mst", u_axis_mst.inst.IF);
    axis_slv_agent = new("slv", u_axis_slv.inst.IF);
    lite_agent     = new("lite", u_lite_mst.inst.IF);

    // idle 시 불필요한 X/assertion 방지용. PG277 예시
    // TVALID=0인 idle 구간의 TDATA/TLAST는 의미 없는 값인데,
    // VIP 내부 protocol checker가 이 idle 값을 보고 false assertion을 띄울 수 있음.
    // 이 설정은 idle 구간에서 VIP가 불필요하게 값을 drive하지 않도록 하는 용도.
    ////axis_mst_agent.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE);
    ////axis_slv_agent.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE);

    // start_master() : 이 VIP는 Master로 동작 시작
    // start_slave()  : 이 VIP는 Slave로 동작 시작
    //                  기본적으로 tready를 생성해줌
    axis_mst_agent.start_master();
    axis_slv_agent.start_slave();
    lite_agent.start_master();

    $display("[INIT] VIP agents started");
end
endtask


//─────────────────────────────────────────────
// [추가] Reset task
// 메인 initial 안을 간단하게 만들기 위해 분리
//─────────────────────────────────────────────
task automatic reset_dut();
begin
    aresetn = 0;
    repeat(10) @(posedge aclk);
    #200;
    aresetn = 1;
    repeat(5) @(posedge aclk);

    $display("[RESET] reset released");
end
endtask


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

    if (resp !== XIL_AXI_RESP_OKAY) begin //read response 정상?
        $error("[LITE READ FAIL] resp=%0d", resp);
    end
endtask

//─────────────────────────────────────────────
// trace/in_data.txt, trace/rtl_norm.txt 읽기 task
// in_data.txt  : 입력 stimulus
// rtl_norm.txt : 예상 output golden
//
// $readmemh는 hex 대소문자를 구분하지 않음
//─────────────────────────────────────────────
task automatic load_trace_files();
begin
    input_file    = "trace/in_data.txt";
    rtl_norm_file = "trace/rtl_norm.txt";

    // 실행 위치가 달라질 경우 plusarg로 경로 변경 가능
    // 예: +INPUT_FILE=trace/in_data.txt
    // 예: +RTL_NORM_FILE=trace/rtl_norm.txt
    if ($value$plusargs("INPUT_FILE=%s", input_file)) begin
        $display("[PLUSARG] INPUT_FILE=%s", input_file);
    end

    if ($value$plusargs("RTL_NORM_FILE=%s", rtl_norm_file)) begin
        $display("[PLUSARG] RTL_NORM_FILE=%s", rtl_norm_file);
    end

    // input 파일 존재 확인
    file_check_fd = $fopen(input_file, "r");
    if (file_check_fd == 0) begin
        $fatal(1, "[FILE ERROR] cannot open input file: %s", input_file);
    end
    $fclose(file_check_fd);

    // golden 파일 존재 확인
    file_check_fd = $fopen(rtl_norm_file, "r");
    if (file_check_fd == 0) begin
        $fatal(1, "[FILE ERROR] cannot open rtl_norm golden file: %s", rtl_norm_file);
    end
    $fclose(file_check_fd);

    // 512-bit hex x 768 line 읽기
    $readmemh(input_file,    input_mem);
    $readmemh(rtl_norm_file, rtl_norm_mem);

    $display("[FILE LOAD] input trace loaded    : %s", input_file);
    $display("[FILE LOAD] rtl_norm golden loaded: %s", rtl_norm_file);
end
endtask


//─────────────────────────────────────────────
// trace/AXI_norm.txt open task
//
// AXI output stream은 handshake 기준으로 AXI_norm.txt에 저장
// 기존 golden인 rtl_norm.txt를 덮어쓰면 안 되므로 별도 파일 사용
//─────────────────────────────────────────────
task automatic open_axi_norm_file();
begin
    axi_norm_file = "trace/AXI_norm.txt";

    // 실행 위치가 달라질 경우 plusarg로 경로 변경 가능
    // 예: +AXI_NORM_FILE=trace/AXI_norm.txt
    if ($value$plusargs("AXI_NORM_FILE=%s", axi_norm_file)) begin
        $display("[PLUSARG] AXI_NORM_FILE=%s", axi_norm_file);
    end

    f_axi_norm = $fopen(axi_norm_file, "w");
    if (f_axi_norm == 0) begin
        $fatal(1, "[FILE ERROR] cannot open AXI output file: %s", axi_norm_file);
    end

    axi_norm_write_cnt = 0;

    $display("[FILE OPEN] AXI output file opened: %s", axi_norm_file);
end
endtask

//─────────────────────────────────────────────
// ⑦ AXI-Stream 768(MODEL_DIMENSION) beats 전송 task
//─────────────────────────────────────────────
// AXI-Stream 768(MODEL_DIMENSION) beats 전송 task [continuous stream tvalid]
task send_768_beats();//input [511:0] base_data);
    // transaction: AXI-Stream 한 beat(1사이클)의 데이터 묶음
    axi4stream_transaction trans;
    int i;

    for (i = 0; i < MODEL_DIMENSION ; i++) begin
        // 매 beat마다 transaction 오브젝트 새로 생성
        trans = axis_mst_agent.driver.create_transaction("tx");

        // 데이터 설정
        // set_data_beat(data) : data beat에 값 넣기
        // input_mem[i] = trace/in_data.txt의 i번째 512-bit line
        trans.set_data_beat(input_mem[i]);

        // tlast 설정 : 마지막 beat에만 1
        if (i == MODEL_DIMENSION-1)
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


// AXI-Stream 768(MODEL_DIMENSION) beats 전송 task [input_gap stream tvalid]
task send_768_beats_with_validgap();//input [511:0] base_data);
    // transaction: AXI-Stream 한 beat(1사이클)의 데이터 묶음
    axi4stream_transaction trans;
    int i;

    for (i = 0; i < MODEL_DIMENSION ; i++) begin
        // 매 beat마다 transaction 오브젝트 새로 생성
        trans = axis_mst_agent.driver.create_transaction("tx");

        // 데이터 설정
        // set_data_beat(data) : data beat에 값 넣기
        // input_mem[i] = trace/in_data.txt의 i번째 512-bit line
        trans.set_data_beat(input_mem[i]);

        // tlast 설정 : 마지막 beat에만 1
        if (i == MODEL_DIMENSION-1)
            trans.set_last(1'b1);
        else
            trans.set_last(1'b0);

        // beat 간격
        // 4 beat마다 3 cycle delay
        // 즉, input valid가 중간중간 비는 상황을 만듦
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
// 시나리오별 input 전송 task 선택
// ITER1/ITER2에서 직접 send_768_beats를 주석처리하지 않기 위해 분리
//─────────────────────────────────────────────
task automatic send_input_by_scenario();//input [511:0] base_data);
begin
    case (test_scenario)

        SCN_BASIC: begin
            // 기본 시나리오 : input valid 연속
            send_768_beats();//base_data);
        end

        SCN_VALID_GAP: begin
            // input valid bubble 시나리오 : 중간중간 valid gap 발생
            send_768_beats_with_validgap();//base_data);
        end

        SCN_BACKPRESSURE: begin
            // backpressure 시나리오에서는 input은 continuous로 둠
            // 그래야 output tready stall 효과만 분리해서 볼 수 있음
            send_768_beats();//base_data);
        end

        default: begin
            $error("[AXIS SEND] Unknown scenario=%0d", test_scenario);
        end

    endcase
end
endtask


//─────────────────────────────────────────────
// [추가] 시나리오별 output TREADY 설정 task
// SCN_BASIC / SCN_VALID_GAP    : Slave VIP 기본 ready 사용
// SCN_BACKPRESSURE             : Slave VIP가 tready를 주기적으로 0으로 내림
//─────────────────────────────────────────────
task automatic configure_output_ready(input int scn);
begin
    case (scn)

        SCN_BASIC,
        SCN_VALID_GAP: begin
            // 기본/valid gap 시나리오에서는 output backpressure를 의도하지 않음
            // 별도 ready_gen을 보내지 않으면 Slave VIP의 기본 ready가 사용됨
            $display("[READY] default slave ready policy enabled");
        end

        SCN_BACKPRESSURE: begin
            // 시나리오3 backpressure test
            // valid=1이지만 ready=0인 구간을 만들어서
            // TDATA/TLAST 값이 변하지 않고 고정되는지 확인

            // step1. Slave VIP driver가 ready generator 생성
            axis_rgen = axis_slv_agent.driver.create_ready("axis_rgen");

            // step2. TREADY를 주기적으로 0/1로 흔드는 모드 설정
            // PG277 예시 기준으로 XIL_AXI4STREAM_READY_GEN_OSC 사용
            axis_rgen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_AFTER_VALID_OSC);

            // step3. TREADY=0(Low)인 구간을 10~20 클락으로 길게 설정
            axis_rgen.set_low_time_range(10, 20);

            // step4. TREADY=1(High)인 구간은 1~2 클락으로 짧게 설정
            axis_rgen.set_high_time_range(1, 2);

            // step5. Slave VIP가 위 ready pattern으로 TREADY를 drive
            axis_slv_agent.driver.send_tready(axis_rgen);

            $display("[READY] backpressure enabled: TREADY low=10 cycles, high=2 cycles");
        end

        default: begin
            $error("[READY] Unknown scenario=%0d", scn);
        end

    endcase
end
endtask


//─────────────────────────────────────────────
// [추가] ITER1 DONE 대기 task
// status polling 부분을 메인 initial 밖으로 분리
//─────────────────────────────────────────────
task automatic wait_iter1_done();
    logic [31:0] status;
begin
    status = 0;

    while (status != 32'd1) begin
        @(posedge aclk);
        lite_read(32'h04, status); // slv_reg1 offset = 0x04 // 1 = WAIT_ITER2
    end

    $display(">>> ITER1 DONE, WAIT_ITER2");
end
endtask


//─────────────────────────────────────────────
// [추가] output 완료 대기 task
// 기존 repeat(3000) 방식 대신 TLAST가 실제로 나올 때까지 기다림
// backpressure 시나리오에서는 출력이 늦어질 수 있으므로 이 방식이 더 안전함
//─────────────────────────────────────────────
task automatic wait_output_done(input integer timeout_cycle);
    integer wait_cnt;
begin
    wait_cnt = 0;

    while (!output_done && wait_cnt < timeout_cycle) begin
        @(posedge aclk);
        wait_cnt = wait_cnt + 1;
    end

    if (!output_done) begin
        $fatal(1, "[TIMEOUT] output TLAST not received within %0d cycles", timeout_cycle);
    end
    else begin
        $display(">>> OUTPUT DONE detected");
    end
end
endtask

//─────────────────────────────────────────────
// rtl_norm.txt vs AXI_norm.txt 비교 task
//
// rtl_norm.txt는 rtl_norm_mem에,
// AXI output stream은 axi_norm_mem에 저장해둔 뒤
// 512-bit 값 기준으로 비교함.
//─────────────────────────────────────────────
task automatic compare_axi_norm_with_rtl_norm();
    integer i;
begin
    compare_err_cnt = 0;

    $display("==============================================");
    $display("[COMPARE START] %s vs %s", rtl_norm_file, axi_norm_file);
    $display("==============================================");

    for (i = 0; i < MODEL_DIMENSION; i = i + 1) begin
        if (axi_norm_mem[i] !== rtl_norm_mem[i]) begin
            compare_err_cnt = compare_err_cnt + 1;

            $error("[COMPARE ERROR] beat=%0d actual_AXI=%0128x expected_RTL=%0128x",
                   i, axi_norm_mem[i], rtl_norm_mem[i]);
        end
    end

    if (compare_err_cnt == 0) begin
        $display("[COMPARE PASS] AXI_norm matches rtl_norm. total beats=%0d", MODEL_DIMENSION);
    end
    else begin
        $display("[COMPARE FAIL] mismatch count=%0d / %0d", compare_err_cnt, MODEL_DIMENSION);
        $fatal(1, "[COMPARE FAIL] AXI_norm does not match rtl_norm");
    end

    $display("==============================================");
end
endtask

//─────────────────────────────────────────────
// ⑧ 메인 테스트 시나리오
//─────────────────────────────────────────────
initial begin
    // 기본 시나리오 설정
    test_scenario = DEFAULT_SCENARIO;

    // plusarg로 시나리오 덮어쓰기 가능
    // 예: +SCENARIO=0 / +SCENARIO=1 / +SCENARIO=2
    if ($value$plusargs("SCENARIO=%d", test_scenario)) begin
        $display("[PLUSARG] SCENARIO=%0d", test_scenario);
    end

    $display("==============================================");
    $display("[TEST START] %s", scenario_name(test_scenario));
    $display("==============================================");

    //── 0. VIP Agent 생성 및 start ─────────────
    init_vip_agents();
    //── 0-0. trace/in_data.txt, trace/rtl_norm.txt 읽기 ─────
    load_trace_files();
    //── 0-0-1. trace/AXI_norm.txt 열기 ─────────
    open_axi_norm_file();


    //── 0-1. Reset ─────────────────────────────
    reset_dut();

    //── 0-2. 시나리오별 output ready 설정 ──────
    configure_output_ready(test_scenario);

    //── 1. 설정 레지스터 쓰기 ─────────────────
    lite_write(32'h08, MODEL_DIMENSION); // slv_reg2 offset = 0x08 , d_model = 768
    lite_write(32'h0C, 32'h0855);        // slv_reg3 offset = 0x0C , [i_shift_value = 5'sd8 , i_mult_value = 8'sb01010101;]
                                           // 768로 고정함

    //── 2. ITER1 시작 ─────────────────────────
    lite_write(32'h00, 32'd1); // slv_reg0 , cmd = 1

    //── 3. ITER1 데이터 전송 ──────────────────
    // 기존에는 여기서 send_768_beats / send_768_beats_with_validgap를 주석처리로 선택했음
    // 이제는 test_scenario 값에 따라 자동 선택됨
    send_input_by_scenario();//512'hA5A5);

    //── 4. ITER1 DONE 대기 (status polling) ───
    wait_iter1_done();

    //── 5. ITER2 시작 ─────────────────────────
    lite_write(32'h00, 32'd2); // cmd = 2

    //── 6. ITER2 데이터 전송 ──────────────────
    // 기존에는 여기서 send_768_beats / send_768_beats_with_validgap를 주석처리로 선택했음
    // 이제는 test_scenario 값에 따라 자동 선택됨
    send_input_by_scenario();//512'hA5A5);

    //── 7. 출력 DONE 대기 후 종료 ─────────────
    // MODEL_DIMENSION=768 + backpressure일 때 repeat(3000)은 부족할 수 있음
    // 그래서 TLAST가 실제로 나올 때까지 기다림
    wait_output_done(20000);

    // AXI_norm.txt close
    $fclose(f_axi_norm);
    $display("[FILE CLOSE] AXI output file closed: %s", axi_norm_file);

    compare_axi_norm_with_rtl_norm(); //결과 mem 비교


    repeat(20) @(posedge aclk);

    $display("==============================================");
    $display("[TEST FINISH] %s", scenario_name(test_scenario));
    $display("==============================================");

    $finish;
end


//─────────────────────────────────────────────
// ⑨ 출력 모니터링 (파형 말고 텍스트로도 확인 , MODEL_DIMENSION 번 출력)
//─────────────────────────────────────────────
always @(posedge aclk) begin
    if (axis_out_tvalid && axis_out_tready) begin // 실제 transfer된 beat만 로그 출력 , TVALID/TREADY handshake 정상? 을 체크
        $display("[AXIS OUT_DATA] first row data[15:0] in 32row = %h , tlast = %b",
                  axis_out_tdata[15:0], axis_out_tlast);
    end
end


//─────────────────────────────────────────────
// ⑩ FSM 상태 전환 모니터
// dut 내부 c_state 계층적 참조: 변할 때마다 출력
//─────────────────────────────────────────────
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

//─────────────────────────────────────────────
// ⑪ AXI stream output beat count + AXI_norm.txt 저장
// output_done은 wait_output_done task에서 사용


//out_cnt >= MODEL_DIMENSION : 769번째, 770번째... 같은 초과 output beat 방지
// axis_out_tlast && (out_cnt + 1) != MODEL_DIMENSION : TLAST가 768개째가 아닌 위치에서 나온 경우 확인
// out_cnt == MODEL_DIMENSION-1 && !axis_out_tlast : 768번째 beat인데 TLAST가 안 나온 경우 확인
// wait_output_done timeout : TLAST가 아예 안 나오는 경우 확인


// 저장 기준:
// axi stream out handshake가 발생한 beat만
// 실제 output stream으로 인정하고 trace/AXI_norm.txt에 저장
//
// 저장 format:
// 512-bit 한 줄 = 128 hex digit
// 왼쪽 hex = row31, 오른쪽 hex = row0
//─────────────────────────────────────────────
always @(posedge aclk) begin
    if (!aresetn) begin
        out_cnt            <= 0;
        output_done        <= 1'b0;
        axi_norm_write_cnt <= 0;
    end

    else if (axis_out_tvalid && axis_out_tready) begin

        //출력이 초과상황
        if (out_cnt >= MODEL_DIMENSION) begin
            $error("[AXIS OUT ERROR] output beat exceeded MODEL_DIMENSION. out_cnt=%0d", out_cnt);
            //axi_norm_mem[out_cnt] 같은 배열 저장해서, out_cnt=768일 때 접근하면 out-of-range라서 이 guard가 필요
        end

        else begin
            // AXI output stream 한 beat를 memory에 저장
            axi_norm_mem[out_cnt] = axis_out_tdata;

            // AXI output stream 한 beat를 trace/AXI_norm.txt에 저장
            // %0128x : 512-bit = 128 hex digit, lowercase hex로 저장
            // diff를 쓸 경우 대소문자 무시는 diff -i 사용
            $fwrite(f_axi_norm, "%0128x\n", axis_out_tdata);

            axi_norm_write_cnt <= axi_norm_write_cnt + 1;
        end

        // 마지막 beat 처리
        if (axis_out_tlast) begin
            $display("[AXIS OUT DONE] TOTAL OUT BEATS = %0d, tlast = %b",
                     out_cnt + 1, axis_out_tlast);

            //TLAST가 너무 빨리/너무 늦게 나오는 경우 확인
            if (out_cnt != MODEL_DIMENSION-1) begin //out_cnt는 integer라서 X안봐도 되서 !==대신 !=사용
                $error("[COUNT ERROR] output beat count=%0d, expected=%0d",
                       out_cnt + 1, MODEL_DIMENSION);
            end
            else begin
                $display("[AXI NORM WRITE DONE] %0d lines written to %s",
                         out_cnt + 1, axi_norm_file);
            end

            output_done <= 1'b1;
        end

        // MODEL_DIMENSION번째 beat인데 TLAST가 안 나온 경우
        else if (out_cnt == MODEL_DIMENSION-1) begin
            $error("[TLAST ERROR] expected TLAST=1 at output beat %0d", out_cnt);
        end

        // output beat count 증가
        out_cnt <= out_cnt + 1;
    end
end


//─────────────────────────────────────────────
// ⑫ TLAST assertion
// MODEL_DIMENSION번째 beat에서 stream_out_tlast 안 나오면 에러
//─────────────────────────────────────────────
always @(posedge aclk) begin
    if (!aresetn) begin
        // reset 중에는 check 안 함
    end

    else if (axis_out_tvalid && axis_out_tready) begin

        if (out_cnt == MODEL_DIMENSION-1)
            assert(axis_out_tlast)
            else $error("[TLAST ERROR] expected TLAST=1 at output beat %0d", out_cnt);

        else
            assert(!axis_out_tlast)
            else $error("[TLAST ERROR] unexpected TLAST=1 at output beat %0d", out_cnt);
    end
end


//─────────────────────────────────────────────
// [추가] Backpressure 중 output payload hold assertion
// TVALID=1 && TREADY=0이면 아직 handshake가 안 된 상태
// 따라서 DUT는 TDATA/TLAST를 다음 cycle에도 그대로 유지해야 함
//─────────────────────────────────────────────
property p_axis_out_hold_when_backpressured;
    @(posedge aclk) disable iff (!aresetn)
    (axis_out_tvalid && !axis_out_tready) |=>
        (axis_out_tvalid &&
         $stable(axis_out_tdata) &&
         $stable(axis_out_tlast));
endproperty

assert property (p_axis_out_hold_when_backpressured)
else begin
    $error("[AXIS BACKPRESSURE ERROR] axis_out payload changed while TVALID=1 and TREADY=0");
end


//─────────────────────────────────────────────
// [선택] Deadlock 감지
// m_axis_tvalid=1인데 tready=0 이 N사이클 지속 → 경고
// backpressure 시나리오에서는 어느 정도 stall이 의도된 것이므로 threshold는 넉넉히 설정
//─────────────────────────────────────────────
// parameter integer DEADLOCK_THRESH = 500;
// integer deadlock_cnt;

// always @(posedge aclk) begin
//     if (!aresetn) begin
//         deadlock_cnt <= 0;
//     end

//     else if (axis_out_tvalid && !axis_out_tready) begin
//         deadlock_cnt <= deadlock_cnt + 1;
//     end

//     else begin
//         deadlock_cnt <= 0;
//     end

//     if (deadlock_cnt == DEADLOCK_THRESH) begin
//         $display("[WARNING] POSSIBLE DEADLOCK: tvalid=1 tready=0 상태 %0d사이클 지속!", DEADLOCK_THRESH);
//     end
// end


//─────────────────────────────────────────────
// [선택] 전체 시뮬레이션 타임아웃
// 예상치 못한 무한 대기를 막기 위한 안전장치
//─────────────────────────────────────────────
// parameter integer SIM_TIMEOUT = 100000; // cycle

// initial begin
//     repeat(SIM_TIMEOUT) @(posedge aclk);
//     $fatal(1, "[SIM TIMEOUT] %0d cycles exceeded", SIM_TIMEOUT);
// end


endmodule