`timescale 1ns / 1ps

module add#(
    parameter DATA_WIDTH = 16  //8.8 fixed_point =16bit
)(
    input i_clk,
    input i_rstn,

    input i_run, //input valid signal (start signal)
    input signed [DATA_WIDTH-1 : 0] i_bias,
    input signed [DATA_WIDTH-1 : 0] i_data,

    output reg signed [DATA_WIDTH-1 : 0]  o_data,
    output reg o_done
);


wire signed [DATA_WIDTH-1:0] w_add; //8.8
assign w_add = (i_bias + i_data);

always @(posedge i_clk , negedge i_rstn) //capture mean, invsqrt
begin
    if(!i_rstn) begin
        o_data <= {(DATA_WIDTH){1'b0}};
        o_done <= 1'b0;
    end
    else begin
        if(i_run) begin
        o_data <= w_add;
        o_done <= 1'b1;
        end

        else begin
        o_data <= {(DATA_WIDTH){1'b0}};
        o_done <= 1'b0;
        end
    end   
end

endmodule
