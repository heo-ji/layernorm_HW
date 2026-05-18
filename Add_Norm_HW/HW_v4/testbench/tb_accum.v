`timescale 1ns / 1ps

module tb_accum();

parameter INPUT_DATA_WIDTH          = 16;
parameter ACCUM_DATA_WIDTH          = 26;
parameter SQUARED_ACCUM_DATA_WIDTH  = 34;
parameter SHIFT_WIDTH               = 8;

// Inputs
wire clk;
reg data_clk;
reg rstn;
reg valid;
reg i_accum_finish;
reg signed [(INPUT_DATA_WIDTH)-1 : 0] i_data;

// Outputs
wire signed [ACCUM_DATA_WIDTH-1 : 0] o_accum;
wire signed [SQUARED_ACCUM_DATA_WIDTH-1 : 0] o_squared_accum;
wire o_done;

// Instantiate the Unit Under Test (UUT)
accum_one_row #(
    .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
    .SQUARED_ACCUM_DATA_WIDTH(SQUARED_ACCUM_DATA_WIDTH),
    .SHIFT_WIDTH(SHIFT_WIDTH)
) uut (
    .i_clk(clk),
    .i_rstn(rstn),
    .i_valid(valid),
    .i_accum_finish(i_accum_finish),
    .i_data(i_data),
    .o_accum(o_accum),
    .o_squared_accum(o_squared_accum),
    .o_done(o_done)
);

// Clock generation
initial begin
    data_clk = 1;
    forever #5 data_clk = ~data_clk;  // Clock period of 10 ns
end
assign clk = ~data_clk;

// Reset process
initial begin
    rstn = 1;
    #10 rstn = 0;  // Apply reset
    #20 rstn = 1;  // Release reset
    valid = 0;
    i_accum_finish = 0;
end

integer i = 0;
integer file1;
integer file2;

// Test vectors
initial begin
    // Open the file to read test vectors
    file1 = $fopen("/home/linuxusr/code/mpw/MPW_2024/Add_Norm/HW_v2/testbench/768input1.txt", "r");
    if (file1 == 0) begin
        $display("Error: failed to open input file1.");
        $finish;
    end

    file2 = $fopen("/home/linuxusr/code/mpw/MPW_2024/Add_Norm/HW_v2/testbench/768input2.txt", "r");
    if (file2 == 0) begin
        $display("Error: failed to open input file2.");
        $finish;
    end

    @(posedge rstn);  // Wait for reset to release

    
    //data load
    @(posedge data_clk);
    while (i < 768) begin
        valid = 1;
        $fscanf(file1, "%h", i_data);
        i = i + 1;
        
        if(i == 768) #5 i_accum_finish = 1;
        else @(posedge data_clk); 

    end
    $fclose(file1);

    #10  
    valid = 0;  // Stop after the last data is loaded
    i_accum_finish = 0;
    i = 0;
    #10 
    //data load
    @(posedge data_clk);
    while (i < 768) begin
        valid = 1;
        $fscanf(file2, "%h", i_data);
        i = i + 1;

        if(i == 768) #5 i_accum_finish = 1;
        else @(posedge data_clk); 
    end
    $fclose(file2);
    #10  
    valid = 0;  // Stop after the last data is loaded
    i_accum_finish = 0;

    #10
    valid=1;
    #10
    valid=0;
    #50 
    $finish;

end

endmodule
