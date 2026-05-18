`timescale 1ns / 1ps

module tb_mean();

parameter ACCUM_DATA_WIDTH          = 26;
parameter SQUARED_ACCUM_DATA_WIDTH  = 34;
parameter MEAN_DATA_WIDTH           = 16;
parameter SQUARED_MEAN_DATA_WIDTH   = 32;
parameter FRAC_WIDTH                = 8 ;

// Inputs
wire ivclk;
reg clk;
reg rstn;
reg valid;
reg signed [(ACCUM_DATA_WIDTH)-1 : 0]           i_data_accum;
reg signed [(SQUARED_ACCUM_DATA_WIDTH)-1 : 0]   i_data_squared_accum;
reg signed [4 : 0]                             i_shift_value;
reg signed [FRAC_WIDTH-1 : 0]                  i_mult_value;   //0.8 fixed_point

// Outputs
wire signed [MEAN_DATA_WIDTH-1 : 0]         o_mean;
wire signed [SQUARED_MEAN_DATA_WIDTH-1 : 0] o_squared_mean;
wire o_done;

// Instantiate the Unit Under Test (UUT)
mean #(
    .FRAC_WIDTH(FRAC_WIDTH),
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
    .SQUARED_ACCUM_DATA_WIDTH(SQUARED_ACCUM_DATA_WIDTH),
    .MEAN_DATA_WIDTH(MEAN_DATA_WIDTH),
    .SQUARED_MEAN_DATA_WIDTH(SQUARED_MEAN_DATA_WIDTH)
) uut (
    .i_clk(ivclk), 
    .i_rstn(rstn),
    .i_valid(valid),
    .i_shift_value(i_shift_value),
    .i_mult_value(i_mult_value),
    .i_accum(i_data_accum),
    .i_squared_accum(i_data_squared_accum),
    .o_mean(o_mean),
    .o_squared_mean(o_squared_mean),
    .o_done(o_done)
);

// Clock generation
initial begin
    clk = 1;
    forever #5 clk = ~clk;  // Clock period of 10 ns
end

assign ivclk = ~clk;

// Reset process
initial begin
    rstn = 1;
    #10 rstn = 0;  // Apply reset
    #20 rstn = 1;  // Release reset
    valid = 0;
end


// // Test vectors
initial begin
    @(posedge rstn);  // Wait for reset to release

    @(posedge clk);
    #5
    valid = 1;

    //bert base -> % 768
    i_shift_value = 5'd 8;
    i_mult_value  =  8'sb01010101; // 0.33203125 

    i_data_accum = 26'h3FFCF4E;
    i_data_squared_accum = 34'h000004EC45;
    
    #10
    valid = 0;  // Stop the operation after the last data is loaded

    #50 
    $finish;
end



endmodule
