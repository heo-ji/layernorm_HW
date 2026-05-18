`timescale 1ns / 1ps

module tb_var();

parameter MEAN_DATA_WIDTH           = 16; //8.8 fixed_point
parameter SQUARED_MEAN_DATA_WIDTH   = 32; //16.16 fixed_point
parameter VAR_DATA_WIDTH            = 24;   //8.16  fixed_point

// Inputs
wire                                            ivclk;
reg                                             clk;
reg                                             rstn;
reg                                             valid;
reg signed [MEAN_DATA_WIDTH-1 : 0]              i_mean;
reg signed [SQUARED_MEAN_DATA_WIDTH-1 : 0]      i_squared_mean;

// Outputs
wire  signed [VAR_DATA_WIDTH-1 : 0]             o_var;
wire                                            o_done;

// Instantiate the Unit Under Test (UUT)
var #(
    .MEAN_DATA_WIDTH(MEAN_DATA_WIDTH),
    .SQUARED_MEAN_DATA_WIDTH(SQUARED_MEAN_DATA_WIDTH),
    .VAR_DATA_WIDTH(VAR_DATA_WIDTH)
) uut (
    .i_clk(ivclk), 
    .i_rstn(rstn),
    .i_valid(valid),
    .i_mean(i_mean),
    .i_squared_mean(i_squared_mean),
    .o_var(o_var),
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


// Test vectors
initial begin
    @(posedge rstn);  // Wait for reset to release

    @(posedge clk);
    #5

    /*mean(8.8) = FFEF
    mean2(16.16) = 0001A25C
    var(8.16) = 01A13B
    */
    valid = 1;
    i_mean          = 16'shFF_EF;
    i_squared_mean  = 32'sh0001A25C;
    
    #10
    valid = 0;

    #50 
    $finish;
end
endmodule
