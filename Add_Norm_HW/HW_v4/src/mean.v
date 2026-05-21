`timescale 1ns / 1ps

module mean #(
    parameter FRAC_WIDTH                = 8  ,
    parameter ACCUM_DATA_WIDTH          = 26 , //18.8 fixed_point
    parameter SQUARED_ACCUM_DATA_WIDTH  = 34 , //26.8 fixed_point 
    parameter MEAN_DATA_WIDTH           = 16 , //8.8 fixed_point
    parameter SQUARED_MEAN_DATA_WIDTH   = 2*MEAN_DATA_WIDTH  // 16.16 fixed_point
)(
    input                                                   i_clk,
    input                                                   i_reset,
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
wire signed [ACCUM_DATA_WIDTH + FRAC_WIDTH -1         : 0]    w_mean;// , w_shifted_mean;
wire signed [SQUARED_ACCUM_DATA_WIDTH + FRAC_WIDTH -1 : 0]    w_squared_mean;

assign w_mean = ((i_accum >>> i_shift_value) * i_mult_value); //[ 정수부 : ACCUM_DATA_WIDTH -8 - i_shift_value , 소수부 : 16 ]
assign w_squared_mean = ((i_squared_accum >>> i_shift_value ) * i_mult_value); //[ 정수부 : SQUARED_ACCUM_DATA_WIDTH -8 - i_shift_value , 소수부 : 16 ]


//mean 
//# Q(10.16)-> (8.8) 로 정수부saturation, 소수부(FRAC_WIDTH) 버림
//assign w_shifted_mean = (w_mean >>> FRAC_WIDTH ); //mean 소수부 8bit 버림 (10.8)

// o_mean : w_mean (34bit, 10.16) -> 16bit (8.8)
wire w_mean_overflow = ~w_mean[ACCUM_DATA_WIDTH+FRAC_WIDTH-1] &
                       |w_mean[ACCUM_DATA_WIDTH+FRAC_WIDTH-2 : MEAN_DATA_WIDTH+FRAC_WIDTH-1];
//MSD=0(양수) & (상위 비트에 1 존재?)

wire w_mean_underflow =  w_mean[ACCUM_DATA_WIDTH+FRAC_WIDTH-1] &
                      ~(&w_mean[ACCUM_DATA_WIDTH+FRAC_WIDTH-2 : MEAN_DATA_WIDTH+FRAC_WIDTH-1]);
//MSB=1(음수) & (상위 비트에 0 존재?)

// o_squared_mean : w_squared_mean (42bit, 18.16) -> 32bit (16.16) 로 정수부saturation
wire w_sq_overflow = ~w_squared_mean[SQUARED_ACCUM_DATA_WIDTH+FRAC_WIDTH-1] &
                     |w_squared_mean[SQUARED_ACCUM_DATA_WIDTH+FRAC_WIDTH-2 : SQUARED_MEAN_DATA_WIDTH-1];
wire w_sq_underflow =  w_squared_mean[SQUARED_ACCUM_DATA_WIDTH+FRAC_WIDTH-1] &
                    ~(&w_squared_mean[SQUARED_ACCUM_DATA_WIDTH+FRAC_WIDTH-2 : SQUARED_MEAN_DATA_WIDTH-1]);


always @(posedge i_clk )
begin
    if (i_reset) 
    begin
        o_mean          <= {(MEAN_DATA_WIDTH){1'b0}};
        o_squared_mean  <= {(SQUARED_MEAN_DATA_WIDTH){1'b0}};
        o_done          <= 1'b0;
    end
    else
    begin
        if(i_valid) begin
            o_mean <= w_mean_overflow ? {1'b0, {(MEAN_DATA_WIDTH-1){1'b1}}} :
                      w_mean_underflow ? {1'b1, {(MEAN_DATA_WIDTH-1){1'b0}}} :
                      $signed(w_mean[MEAN_DATA_WIDTH+FRAC_WIDTH-1 : FRAC_WIDTH]);
            //o_mean          <= $signed(w_shifted_mean[MEAN_DATA_WIDTH - 1  :   0]); 
            
            o_squared_mean <= w_sq_overflow ? {1'b0, {(SQUARED_MEAN_DATA_WIDTH-1){1'b1}}} :
                              w_sq_underflow ? {1'b1, {(SQUARED_MEAN_DATA_WIDTH-1){1'b0}}} :
                              $signed(w_squared_mean[SQUARED_MEAN_DATA_WIDTH-1 : 0]);
            //o_squared_mean  <= $signed(w_squared_mean[SQUARED_MEAN_DATA_WIDTH - 1 :   0]);
            
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