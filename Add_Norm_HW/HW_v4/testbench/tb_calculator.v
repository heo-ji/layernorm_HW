`timescale 1ns / 1ps

module tb_calculator();

    parameter DATA_WIDTH                   = 16;  //8.8 fixed_point input
    parameter ACCUM_DATA_WIDTH             = 26; //18.8 fixed_point
    parameter SQUARED_ACCUM_DATA_WIDTH     = 34; //26.8 fixed_point
    parameter SHIFT_WIDTH                  = 8 ;
    parameter MODEL_DIMENSION_WIDTH        = 11;
    parameter FRAC_WIDTH                   = 8 ;   
    parameter SQUARED_MEAN_DATA_WIDTH      = 32; // 16.16 fixed_point
    parameter VAR_DATA_WIDTH               = 24;  //8.16 fixed_point
    parameter LUT_NUM                      = 24;
    parameter START_INDEX                  = 16;
// Inputs
wire i_uut_clk;
reg clk;
reg rstn;
reg i_s_valid;
reg i_m_ready;
reg  [MODEL_DIMENSION_WIDTH-1 : 0]    i_d_model;
reg         signed [(DATA_WIDTH)-1 : 0]  i_data;
reg       signed [4 : 0]               i_shift_value;
reg       signed [FRAC_WIDTH-1 : 0]    i_mult_value;

// Outputs
wire signed [DATA_WIDTH-1 : 0] o_invsqrt;
wire signed [DATA_WIDTH-1 : 0] o_mean;
wire o_m_valid;
wire o_s_ready;

// Instantiate the Unit Under Test (UUT)
calculator_one_row #(
    .DATA_WIDTH(DATA_WIDTH),
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
    .SQUARED_ACCUM_DATA_WIDTH(SQUARED_ACCUM_DATA_WIDTH),
    .SHIFT_WIDTH(SHIFT_WIDTH),
    .MODEL_DIMENSION_WIDTH(MODEL_DIMENSION_WIDTH),
    .FRAC_WIDTH(FRAC_WIDTH),
    .SQUARED_MEAN_DATA_WIDTH(SQUARED_MEAN_DATA_WIDTH),
    .VAR_DATA_WIDTH(VAR_DATA_WIDTH),
    .LUT_NUM(LUT_NUM),
    .START_INDEX(START_INDEX)
) uut (
    .i_clk          (i_uut_clk), // 클럭과 동시에 입력이 들어가는것 방지
    .i_rstn         (rstn),
    .i_s_valid      (i_s_valid),
    .o_s_ready      (o_s_ready),
    .o_m_valid      (o_m_valid),
    .i_m_ready      (i_m_ready),
    .i_d_model      (i_d_model),
    .i_data         (i_data),
    .i_shift_value  (i_shift_value),
    .i_mult_value   (i_mult_value),
    .o_invsqrt      (o_invsqrt),
    .o_mean         (o_mean)
    
);


// Clock generation
initial begin
    clk = 1;
    forever #5 clk = ~clk;  // Clock period of 10 ns
end

assign i_uut_clk = ~clk;

// Reset process
initial begin
    rstn = 1;
    #10 rstn = 0;  // Apply reset
    #20 rstn = 1;  // Release reset
    i_s_valid = 0;
end

initial begin
    @(posedge rstn);
//     768 = >>>8 * 0.33203125 (8'sb01010101)
// 192 = >>>6 * 0.33203125
// 384 = >>>7 * * 0.33203125
// 1024 = >>>12 * 0.25 (8'sb01000000)
// 1280 = >>>8 * 0.19921875 (8'sb 00110011)
// */
    i_d_model = 11'd768;
    i_shift_value = 5'sd8;
    i_mult_value  = 8'sb01010101;

    // i_d_model = 11'd192;
    // i_shift_value = 5'sd6;
    // i_mult_value  = 8'sb01010101;

    // i_d_model = 11'd4;
    // i_shift_value = 5'sd-1;
    // i_mult_value  = 8'sb00100000;

    i_m_ready = 1'b1;
end

integer i = 0;
integer file;

// Test vectors
initial begin
    // Open the file to read test vectors
    file = $fopen("/home/esoc/Workspace/HJH/MPW2024_Add_Norm/HW_v2/testbench/768input.txt", "r");
    if (file == 0) begin
        $display("Error: failed to open input file.");
        $finish;
    end 

    i = 0;  

    @(posedge rstn);  // Wait for reset to release

    @(posedge clk);
    while (i < 768) begin
        i_s_valid = 1;
        $fscanf(file, "%h", i_data);
        i = i + 1;
        @(posedge clk);

        // repeat (5) begin
        //     @(posedge clk);
        // end
    end
    i_s_valid = 0;
    // //test 4개 
    // i_s_valid = 1;
    // i_data  = 16'shC502;
    // @(posedge clk); 
    // i_data  = 16'shDF018;
    // @(posedge clk); 
    // i_data  = 16'sh42FE; 
    // @(posedge clk);
    // i_data  = 16'shF51D;
    // @(posedge clk); 

    $fclose(file);

    @(o_m_valid);
    i_s_valid = 1;
    file = $fopen("/home/esoc/Workspace/HJH/MPW2024_Add_Norm/HW_v2/testbench/768input.txt", "r");
    if (file == 0) begin
        $display("Error: failed to open input file.");
        $finish;
    end 

    i = 0; 
    @(posedge clk);
    while (i < 768) begin
        i_s_valid = 1;
        $fscanf(file, "%h", i_data);
        i = i + 1;
        @(posedge clk);

        // repeat (5) begin
        //     @(posedge clk);
        // end
    end
    $fclose(file);

    i_s_valid = 0;  // Stop the operation after the last data is loaded
    
    // //test
    // @(negedge o_s_ready);
    // #40
    // i_s_valid = 1;
    // i_data = 16'sh0001;


    #800
    $finish;
end

// // Display results
// initial begin
//     $monitor("At time %t, o_done = %b, o_accum = %d, o_s_accum = %d", $time, o_done, o_accum, o_s_accum);
// end

endmodule
