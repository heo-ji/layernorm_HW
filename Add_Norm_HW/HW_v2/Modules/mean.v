`timescale 1ns / 1ps

module mean #(
    parameter FRAC_WIDTH                = 8  ,
    parameter ACCUM_DATA_WIDTH          = 26 , //18.8 fixed_point
    parameter SQUARED_ACCUM_DATA_WIDTH  = 34 , //26.8 fixed_point 
    parameter MEAN_DATA_WIDTH           = 16 , //8.8 fixed_point
    parameter SQUARED_MEAN_DATA_WIDTH   = 32  // 16.16 fixed_point
)(
    input                                                   i_clk,
    input                                                   i_rstn,
    input                                                   i_valid,
    input      signed   [4 : 0]                             i_shift_value,
    input      signed   [FRAC_WIDTH-1 : 0]                  i_mult_value,   //0.8 fixed_point
    input      signed   [ACCUM_DATA_WIDTH-1 : 0]            i_accum,
    input      signed   [SQUARED_ACCUM_DATA_WIDTH-1 : 0]    i_squared_accum,
    output reg signed   [MEAN_DATA_WIDTH-1 : 0]             o_mean,
    output reg signed   [SQUARED_MEAN_DATA_WIDTH-1 : 0]     o_squared_mean,
    output reg                                              o_done 
);

/*
CALCULATE MEAN  = Accumulate value / d_model

ex) 
% 768 = >>>8 * 0.33203125 (8'sb01010101)
% 192 = >>>6 * 0.33203125
% 384 = >>>7 * * 0.33203125
% 1024 = >>>12 * 0.25  (8'sb01000000)
% 1280 = >>>8 * 0.19921875 (8'sb 00110011)

*/
wire signed [ACCUM_DATA_WIDTH + FRAC_WIDTH -1         : 0]    w_mean , w_shifted_mean;
wire signed [SQUARED_ACCUM_DATA_WIDTH + FRAC_WIDTH -1 : 0]    w_squared_mean;

assign w_mean = ((i_accum >>> i_shift_value) * i_mult_value); //[ 정수부 : ACCUM_DATA_WIDTH -8 - i_shift_value , 소수부 : 16 ]
assign w_squared_mean = ((i_squared_accum >>> i_shift_value ) * i_mult_value); //[ 정수부 : SQUARED_ACCUM_DATA_WIDTH -8 - i_shift_value , 소수부 : 16 ]

assign w_shifted_mean = (w_mean >>> FRAC_WIDTH ); //소수부 8bit 버림


always @(posedge i_clk , negedge i_rstn)
begin
    if (!i_rstn) 
    begin
        o_mean          <= {(MEAN_DATA_WIDTH){1'b0}};
        o_squared_mean  <= {(SQUARED_MEAN_DATA_WIDTH){1'b0}};
        o_done          <= 1'b0;
    end
    else
    begin
        if(i_valid) begin
            o_mean          <= $signed(w_shifted_mean[MEAN_DATA_WIDTH - 1         :   0]); 
            o_squared_mean  <= $signed(w_squared_mean[SQUARED_MEAN_DATA_WIDTH - 1 :   0]);
            o_done          <= 1'b1;
        end
        else begin
            o_mean          <= {(MEAN_DATA_WIDTH){1'b0}};
            o_squared_mean  <= {(SQUARED_MEAN_DATA_WIDTH){1'b0}};
            o_done          <= 1'b0;
        end

    end
end

endmodule