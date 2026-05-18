`timescale 1ns / 1ps

module tb_invsqrt;

    // Parameters
    localparam VAR_DATA_WIDTH = 24;  // 8.16 fixed point
    localparam OUT_DATA_WIDTH = 16;  // 8.8 fixed point
    localparam LUT_NUM = 24;

    // Test Bench Signals
    reg                             i_clk;
    reg                             i_rstn;
    reg                             i_valid;
    reg signed [VAR_DATA_WIDTH-1:0] i_var;

    wire signed [OUT_DATA_WIDTH-1:0] o_invsqrt;
    wire                             o_done;

    // Instantiate the Unit Under Test (UUT)
    invsqrt #(
        .VAR_DATA_WIDTH(VAR_DATA_WIDTH),
        .OUT_DATA_WIDTH(OUT_DATA_WIDTH),
        .LUT_NUM(LUT_NUM)
    ) UUT (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_valid(i_valid),
        .i_var(i_var),
        .o_invsqrt(o_invsqrt),
        .o_done(o_done)
    );

    // Clock generation
    always #5 i_clk = ~i_clk;  // 50 MHz Clock

    // Initialize and run tests
    initial begin
        // Initialize signals
        #10
        i_clk = 0;
        i_rstn = 0;
        i_valid = 0;
        i_var = 0;

        // Reset the system
        #20 i_rstn = 1;

        
        // Test Case 1
        #10 i_valid = 1;
        i_var = 24'sh01A13B; //output =00C8
        #10 //i_valid = 1;
        i_var = 24'sh02A133; //output = 009D
        #10 //i_valid = 1;
        i_var = 24'sh03A133;  //output = 0086
        #10 //i_valid = 1;
        i_var = 24'sh04A133; //output = 0076
        #10 //i_valid = 1;
        i_var = 24'sh05A133; //output = 006B
        #10 //i_valid = 1;
        i_var = 24'sh06A133; //output = 0063
        #10 
        i_var = 24'sh1E2A97;

        #60
        $finish;
    end

endmodule
