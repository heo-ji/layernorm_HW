`timescale 1ns / 1ps

module tb_overflow;
  // DUT 파라미터
  parameter DSP_MAX                   = 48;
  parameter INPUT_DATA_WIDTH          = 16; 
  parameter ACCUM_DATA_WIDTH          = 26; 
  parameter SQUARED_ACCUM_DATA_WIDTH  = 34; 
  parameter SHIFT_WIDTH               = 8;  

  // 신호 선언
  reg                             i_clk;
  reg                             i_reset;
  reg                             i_valid;
  reg                             i_accum_finish;
  reg  signed [INPUT_DATA_WIDTH-1:0] i_data;
  wire signed [ACCUM_DATA_WIDTH-1:0] o_accum;
  wire signed [SQUARED_ACCUM_DATA_WIDTH-1:0] o_squared_accum;
  wire                            o_done;

  // DUT 인스턴스
  accum_one_row #(
    .DSP_MAX                  (DSP_MAX),
    .INPUT_DATA_WIDTH         (INPUT_DATA_WIDTH),
    .ACCUM_DATA_WIDTH         (ACCUM_DATA_WIDTH),
    .SQUARED_ACCUM_DATA_WIDTH (SQUARED_ACCUM_DATA_WIDTH),
    .SHIFT_WIDTH              (SHIFT_WIDTH)
  ) dut (
    .i_clk           (i_clk),
    .i_reset         (i_reset),
    .i_valid         (i_valid),
    .i_accum_finish  (i_accum_finish),
    .i_data          (i_data),
    .o_accum         (o_accum),
    .o_squared_accum (o_squared_accum),
    .o_done          (o_done)
  );

  // 10 ns 클럭 생성
  initial i_clk = 0;
  always #5 i_clk = ~i_clk;

  initial begin


    // 1) 초기화
    i_reset         = 1;
    i_valid         = 0;
    i_accum_finish  = 0;
    i_data          = 0;
    #20;
    i_reset = 0;
    #10;

    // 2) 오버플로우 테스트: +127.996 (0x7FFF) 1,200 사이클 누적
    i_valid = 1;
    i_data  = 16'sh7FFF;
    repeat (1200) @(posedge i_clk);
    i_valid = 0;
    #10;

    // 결과 확인
    if (o_accum === {1'b0, {(ACCUM_DATA_WIDTH-1){1'b1}}})
      $display(">> Overflow PASS: o_accum = 0x%h", o_accum);
    else
      $display("!! Overflow FAIL: o_accum = 0x%h", o_accum);

    // 3) 언더플로우 테스트를 위해 accum 리셋
    @(posedge i_clk);
    i_accum_finish = 1;
    @(posedge i_clk);
    i_accum_finish = 0;
    #10;

    // 4) 언더플로우 테스트: –128.000 (0x8000) 1,200 사이클 누적
    i_valid = 1;
    i_data  = 16'sh8000;
    repeat (1200) @(posedge i_clk);
    i_valid = 0;
    #10;

    if (o_accum === {1'b1, {(ACCUM_DATA_WIDTH-1){1'b0}}})
      $display(">> Underflow PASS: o_accum = 0x%h", o_accum);
    else
      $display("!! Underflow FAIL: o_accum = 0x%h", o_accum);

    $finish;
  end

endmodule
