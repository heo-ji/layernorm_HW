`timescale 1ns / 1ps
/*V = E(X)^2 - E(X^2)*/

module var #(
    parameter MEAN_DATA_WIDTH           = 16 , //8.8 fixed_point
    parameter SQUARED_MEAN_DATA_WIDTH   = 32 , //16.16 fixed_point
    parameter VAR_DATA_WIDTH            = 24  //8.16  fixed_point
)(
    input                                                   i_clk,
    input                                                   i_rstn,
    input                                                   i_valid,
    input       signed [MEAN_DATA_WIDTH-1 : 0]              i_mean, 
    input       signed [SQUARED_MEAN_DATA_WIDTH-1 : 0]      i_squared_mean,
    output reg  signed [VAR_DATA_WIDTH-1 : 0]               o_var,
    output reg                                              o_done 
);


wire signed [(2*MEAN_DATA_WIDTH) -1  :0] w_mean;
wire signed [(2*MEAN_DATA_WIDTH) -1  :0] w_var;

assign w_mean =  (i_mean * i_mean);
assign w_var = (i_squared_mean - w_mean);

// assign w_var_upper = w_var[(2*MEAN_DATA_WIDTH)-1 -: SHIFT_WIDTH]; //w_var 's upper-bit
// //assign lower_bits = w_var[VAR_DATA_WIDTH-1:0];


always @(posedge i_clk , negedge i_rstn) //calculate variance
begin
    if (!i_rstn) 
    begin
        o_var <= {(VAR_DATA_WIDTH){1'b0}};
        o_done <= 1'b0;
	end

    else 
    begin
        if(i_valid) 
        begin
            //eliminate variance's upper bit (= 2*MEAN_DATA_WIDTH - VAR_DATA_WIDTH )
            o_var <= $signed(w_var[VAR_DATA_WIDTH - 1 : 0 ]);
            o_done <= 1'b1;
        end
        else
        begin
            o_var <= {(VAR_DATA_WIDTH){1'b0}};
            o_done <= 1'b0;
        end
    end
end


endmodule
