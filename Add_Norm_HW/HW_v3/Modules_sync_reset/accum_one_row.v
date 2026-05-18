`timescale 1ns / 1ps

module accum_one_row#(
    parameter DSP_MAX = 48,
    parameter INPUT_DATA_WIDTH          = 16 ,  //8.8 fixed_point
    parameter ACCUM_DATA_WIDTH          = 26 , //18.8 fixed_point 
    parameter SQUARED_ACCUM_DATA_WIDTH  = 34 , //26.8 fixed_point
    parameter SHIFT_WIDTH               = 8
)(
    input                                           i_clk,
    input                                           i_reset,
    input                                           i_valid,
    input                                           i_accum_finish,
    input  signed [INPUT_DATA_WIDTH-1       : 0]          i_data, 
    output signed [ACCUM_DATA_WIDTH-1 : 0]          o_accum, 
    output signed [SQUARED_ACCUM_DATA_WIDTH-1 : 0]  o_squared_accum, //accumulate "squared value"
    output                                          o_done 
);

wire    signed [(2*INPUT_DATA_WIDTH)-1:0]             w_squared_data;
wire    signed [DSP_MAX-1 : 0]                  w_ext_sq_data;
wire    signed [DSP_MAX-1 : 0]                  w_ext_i_data;

wire 						                    w_is_overflow;
wire						                    w_is_underflow;
wire 						                    w_is_overflow_sq;
wire						                    w_is_underflow_sq;

reg     signed [DSP_MAX-1 : 0]                  r_accum;
reg     signed [DSP_MAX-1 : 0]                  r_squared_accum;
reg                                             r_last_flag;

assign  w_squared_data = ((i_data * i_data) >>> SHIFT_WIDTH)  ; //하위 소수부 8비트 버림=16.8

assign  w_ext_sq_data = {{(DSP_MAX-(2*INPUT_DATA_WIDTH)){w_squared_data[(2*INPUT_DATA_WIDTH)-1]}},w_squared_data};
assign  w_ext_i_data = {{(DSP_MAX-INPUT_DATA_WIDTH){i_data[INPUT_DATA_WIDTH-1]}},i_data};

//overflow & underflow check
assign  w_is_overflow  = (!r_accum[DSP_MAX-1]) & (|r_accum[DSP_MAX-2 : ACCUM_DATA_WIDTH-1]);
assign  w_is_underflow = (r_accum[DSP_MAX-1]) & (~(&r_accum[DSP_MAX-2 : ACCUM_DATA_WIDTH-1]));
assign  w_is_overflow_sq  = (!r_squared_accum[DSP_MAX-1]) & (|r_squared_accum[DSP_MAX-2 : SQUARED_ACCUM_DATA_WIDTH-1]);
assign  w_is_underflow_sq = (r_squared_accum[DSP_MAX-1]) & (~(&r_squared_accum[DSP_MAX-2 : SQUARED_ACCUM_DATA_WIDTH-1]));

always @(posedge i_clk  ) //when last valid i_data come -> set last_flag 
begin
    if (i_reset) r_last_flag <= 1'b 0;
    else begin
        if(i_accum_finish) r_last_flag <= 1'b 1;
        else               r_last_flag <= 1'b 0;
    end
end

always @(posedge i_clk  )
begin
    if (i_reset) 
    begin
        r_accum         <= {(DSP_MAX){1'b0}};
        r_squared_accum <= {(DSP_MAX){1'b0}};
    end

    else
    begin
        if(i_valid)
        begin
            r_accum         <= r_accum  + w_ext_i_data;
            r_squared_accum <= r_squared_accum + w_ext_sq_data ;
        end
        else if (r_last_flag)
        begin
            r_accum         <= {(DSP_MAX){1'b0}};
            r_squared_accum <= {(DSP_MAX){1'b0}};
        end
        else
        begin
            r_accum         <= r_accum;
            r_squared_accum <= r_squared_accum;
        end
    end
end


assign o_done          = i_accum_finish;

assign o_accum  	    = (w_is_overflow) ? {1'b0, {(ACCUM_DATA_WIDTH-1){1'b1}}} :
                         ((w_is_underflow) ? {1'b1, {(ACCUM_DATA_WIDTH-1){1'b0}}} : r_accum[ACCUM_DATA_WIDTH-1 : 0]);


assign o_squared_accum  = (w_is_overflow_sq) ? {1'b0, {(SQUARED_ACCUM_DATA_WIDTH-1){1'b1}}} :
                         ((w_is_underflow_sq) ? {1'b1, {(SQUARED_ACCUM_DATA_WIDTH-1){1'b0}}} : 
                         r_squared_accum[SQUARED_ACCUM_DATA_WIDTH-1 : 0]);


endmodule
