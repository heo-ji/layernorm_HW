`timescale 1ns / 1ps
/*V = E(X)^2 - E(X^2)*/

module var #(
    parameter MEAN_DATA_WIDTH           = 16 , //8.8 fixed_point
    parameter SQUARED_MEAN_DATA_WIDTH   = 32 , //16.16 fixed_point
    parameter VAR_DATA_WIDTH            = 24  //8.16  fixed_point
)(
    input                                                   i_clk,
    input                                                   i_reset,
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


always @(posedge i_clk ) //calculate variance
begin
    if (i_reset) 
    begin
        o_var <= {(VAR_DATA_WIDTH){1'b0}};
        o_done <= 1'b0;
	end

    else 
    begin
        if(i_valid) 
        begin
            //eliminate variance's upper bit (SQUARED_MEAN_DATA_WIDTH - VAR_DATA_WIDTH )만큼
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
