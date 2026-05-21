//accumulate one row(=768 value) and calculate 'mean' and '1/squareroot(variance)' * 32
/*

bert_base의 경우
i_d_model = 768
i_shift_value = 5'sd8
i_mult_value = 8'sb01010101
--------------------------------------------
Dividing by model_dimension (0to get the mean value) => Shift and Multiply(0.8 Q-format) operations
x / i_d_model = x >>> i_shift_value * i_mult_value

*** example case ***
x / 768 = x >>>8 * 0.33203125 (8'sb01010101)
x / 192 = x >>>6 * 0.33203125
x / 384 = x >>>7 * * 0.33203125
x / 1024 = x >>>12 * 0.25 (8'sb01000000)
x / 1280 = x >>>8 * 0.19921875 (8'sb 00110011)

*/


`timescale 1ns / 1ps

module top_calculator_one_row#(
    parameter MODULE_NUM 	               = 32,
    parameter DATA_WIDTH                   = 16,  //8.8 fixed_point input
    parameter ACCUM_DATA_WIDTH             = 26, //18.8 fixed_point
    parameter SQUARED_ACCUM_DATA_WIDTH     = 34, //26.8 fixed_point
    parameter SHIFT_WIDTH                  = 8 ,
    parameter MODEL_DIMENSION_WIDTH        = 11,
    parameter FRAC_WIDTH                   = 8 ,   
    parameter SQUARED_MEAN_DATA_WIDTH      = 32, // 16.16 fixed_point
    parameter VAR_DATA_WIDTH               = 24,  //8.16 fixed_point
    parameter LUT_NUM                      = 24,
    parameter START_INDEX                  = 16
)(
    input                                           i_clk, 
    input                                           i_reset, 
    input                                           i_s_valid,
    output                                          o_s_ready,
    output                                          o_m_valid,
    input                                           i_m_ready,
    input   signed  [(DATA_WIDTH*MODULE_NUM)-1 : 0] i_data,
    output  signed  [(DATA_WIDTH*MODULE_NUM)-1 : 0] o_invsqrt,
    output  signed  [(DATA_WIDTH*MODULE_NUM)-1 : 0] o_mean,
    input           [MODEL_DIMENSION_WIDTH-1 : 0]    i_d_model,
    input   signed  [4 : 0]                         i_shift_value,
    input   signed  [FRAC_WIDTH-1 : 0]              i_mult_value
);    
	

wire [MODULE_NUM-1:0]	w_m_valid;
assign o_m_valid = &w_m_valid;

wire [MODULE_NUM-1:0]   w_o_s_ready;
assign o_s_ready = &w_o_s_ready;


genvar i;
generate 
    for (i = 0; i < MODULE_NUM; i = i + 1) begin : gen_calculator
		calculator_one_row #(
		    .DATA_WIDTH(DATA_WIDTH),
            .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
            .SQUARED_ACCUM_DATA_WIDTH(SQUARED_ACCUM_DATA_WIDTH),
            .SHIFT_WIDTH(SHIFT_WIDTH),
            .MODEL_DIMENSION_WIDTH(MODEL_DIMENSION_WIDTH),
            .FRAC_WIDTH(FRAC_WIDTH),
            .SQUARED_MEAN_DATA_WIDTH(SQUARED_MEAN_DATA_WIDTH),
            .VAR_DATA_WIDTH(VAR_DATA_WIDTH),
            .LUT_NUM(LUT_NUM),
            .START_INDEX(START_INDEX)
        ) calculator_module (
            .i_clk          (i_clk          ),
            .i_reset         (i_reset         ),
            .i_s_valid      (i_s_valid      ),
            .o_s_ready      (w_o_s_ready[i] ),
            .o_m_valid      (w_m_valid[i]   ),
            .i_m_ready      (i_m_ready      ),
            .i_d_model      (i_d_model      ),
            .i_data         (i_data[DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]),
            .i_shift_value  (i_shift_value),
            .i_mult_value   (i_mult_value),
            .o_invsqrt      (o_invsqrt[DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]),
            .o_mean         (o_mean[DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]  )
		);
    end
endgenerate



endmodule
