`timescale 1ns / 1ps
//16bit 씩 들어오고 내보냄

module multiply#(
    parameter DATA_WIDTH = 16  //8.8 fixed_point =16bit
)(
    input i_clk,
    input i_rstn,

    input i_run, //input valid signal (start signal)
    input signed [DATA_WIDTH-1 : 0] i_weight,
    input signed [DATA_WIDTH-1 : 0] i_data,

    output reg signed [DATA_WIDTH-1 : 0]  o_data,
    output reg o_done
);


wire signed [(2*DATA_WIDTH)-1:0] w_multiply; //32bit(16.16)
assign w_multiply = (i_weight * i_data);

always @(posedge i_clk , negedge i_rstn) //capture mean, invsqrt
begin
    if(!i_rstn) begin
        o_data <= {(DATA_WIDTH){1'b0}};
        o_done <= 1'b0;
    end
    else begin
        if(i_run) begin
        o_data <= $signed(w_multiply[23:8]);
        o_done <= 1'b1;
        end

        else begin
        o_data <= {(DATA_WIDTH){1'b0}};
        o_done <= 1'b0;
        end
    end   
end

endmodule
