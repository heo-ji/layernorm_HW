`timescale 1ns / 1ps

module tb_norm();

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
reg i_s_valid;
reg signed [(DATA_WIDTH)-1 : 0] i_data;
reg signed [DATA_WIDTH-1 : 0] i_invsqrt;
reg signed [DATA_WIDTH-1 : 0] i_mean;


//out
wire o_m_valid;
wire signed [DATA_WIDTH-1 : 0] o_data;

reg no_difference;

normalization#(
    .DATA_WIDTH(DATA_WIDTH)  //8.8 fixed_point =16bit
)u_norm_one_data(
			.i_clk		(	ivclk	 ), 
			.i_rstn		(	rstn	 ),
			.i_s_valid	(	i_s_valid),
            .o_s_ready  (	o_s_ready),
            .o_m_valid  (	o_m_valid),
            .i_m_ready  (	i_m_ready),
            .i_mean	    (   i_mean   ),
            .i_invsqrt	(   i_invsqrt),
			.i_data 	(   i_data   ),
			.o_data	    (   o_data   )
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
    i_s_valid = 0;
end

integer i = 0;
integer file;
integer fp;

reg [(DATA_WIDTH)-1 : 0] buffer [0:768];  // Buffer to store each line from the file

// Test vectors
initial begin
    // Open the file to read test vectors
    file = $fopen("/home/linuxusr/code/mpw/MPW_2024/Add_Norm/HW/testbench/768input.txt", "r");
    if (file == 0) begin
        $display("Error: failed to open input file.");
        $finish;
    end

    fp = $fopen("/home/linuxusr/code/mpw/MPW_2024/Add_Norm/HW/testbench/768norm.txt", "r");
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
    i_invsqrt = 16'sh00C7;
    i_mean = 16'shFFEF;

    while (i < 768) begin
        i_s_valid = 1;
        $fscanf(file, "%h", i_data);
        i = i + 1;
        @(posedge clk);

        // repeat (5) begin
        //     @(posedge clk);
        // end
    end
    
    i_s_valid = 0;  // Stop the operation after the last data is loaded
    $fclose(file);

    
end
reg [DATA_WIDTH-1:0] ref;
integer idx=-1;
always @(o_data) begin
   //@(posedge clk);
    
    ref = buffer[idx];
    if (o_data !== ref) no_difference = 1'b0; //norm_software data 와 HW norm(o_data)와의 비교
    else no_difference = 1'b1;
    idx=idx+1;
end


endmodule
