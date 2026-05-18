`timescale 1ns / 1ps

module tb_bias();

parameter DATA_WIDTH = 16 ;         //8.8 fixed_point input 
parameter ACCUM_DATA_WIDTH = 26 ;   //18.8 fixed_point
parameter SQUARED_ACCUM_DATA_WIDTH = 34 ; //26.8 fixed_point

parameter MEAN_DATA_WIDTH = 16 ;    //8.8 fixed_point
parameter SQUARED_MEAN_DATA_WIDTH = 26;    //Squared input's mean =  16.10 fixed_point
parameter VAR_DATA_WIDTH = 24;       //8.16fixed_point

// Inputs
wire ivclk;
reg clk;
reg rstn;
reg run;
reg signed [(DATA_WIDTH)-1 : 0] i_data;
reg signed [DATA_WIDTH-1 : 0] i_bias;


//out
wire o_done;
wire signed [DATA_WIDTH-1 : 0] o_data;

reg no_difference;


add#(
    .DATA_WIDTH(DATA_WIDTH)  //8.8 fixed_point =16bit
)u_bias_one_data(
    .i_clk(ivclk),
    .i_rstn(rstn),
    .i_run(run), //"calculator_one_row = invsqrt, mean계산" is done (1cycle)
    .i_bias(i_bias),
    .i_data(i_data),
    .o_data(o_data),
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
    run = 0;
end

integer i = 0;
integer file;
integer file2;
integer fp;

reg [(DATA_WIDTH)-1 : 0] buffer [0:768];  // Buffer to store each line from the file

// Test vectors
initial begin
    // Open the file to read test vectors
    file = $fopen("/home/linuxusr/code/mpw/MPW_2024/Add_Norm/HW/testbench/768weightedout.txt", "r");
    if (file == 0) begin
        $display("Error: failed to open input file.");
        $finish;
    end

    file2 = $fopen("/home/linuxusr/code/mpw/MPW_2024/Add_Norm/HW/testbench/768bias.txt", "r");
    if (file2 == 0) begin
        $display("Error: failed to open file2 file.");
        $finish;
    end

    fp = $fopen("/home/linuxusr/code/mpw/MPW_2024/Add_Norm/HW/testbench/768biasedout.txt", "r");
    if (fp == 0) begin
        $display("Error: failed to open 768norm file.");
        $finish;
    end
    
    
    //Load data from file to buffer
    for (i = 0; i < 768; i = i + 1) begin
        $fscanf(fp, "%h", buffer[i]);
    end
    $fclose(fp);  

    i = 0;  

    @(posedge rstn);  // Wait for reset to release

    @(posedge clk);

    while (i < 768) begin
        run = 1;
        $fscanf(file, "%h", i_data);
        $fscanf(file2, "%h", i_bias);
        i = i + 1;
        @(posedge clk);

    end
    
    run = 0;  // Stop the operation after the last data is loaded
    $fclose(file);
    $fclose(file2);

end
reg [DATA_WIDTH-1:0] ref;
integer idx=0;


always @(posedge clk) begin
   if(o_done) 
   begin
        ref = buffer[idx];

        if (o_data !== ref) no_difference = 1'b0; //norm_software data 와 HW norm(o_data)와의 비교
        else no_difference = 1'b1;

        idx=idx+1;
   end
   else no_difference = 1'bx;

end

endmodule
