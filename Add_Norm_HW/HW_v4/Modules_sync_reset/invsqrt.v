`timescale 1ns / 1ps

module invsqrt #(
    parameter VAR_DATA_WIDTH    = 24,  //8.16 fixed_point
    parameter OUT_DATA_WIDTH    = 16,  //8.8 fixed_point
    parameter LUT_NUM           = 24,
    parameter START_INDEX       = 16    // for clipping (8.8) from 40bit(16.24)
)(
    input                                     i_clk,
    input                                     i_reset,
    input                                     i_valid,
    input       signed [VAR_DATA_WIDTH-1 : 0] i_var,
    output reg  signed [OUT_DATA_WIDTH-1 : 0] o_invsqrt,
    output reg                                o_done 
);

wire signed [VAR_DATA_WIDTH -1                   :0] w_var;         //8.16
wire signed	[OUT_DATA_WIDTH -1                   :0] w_slope;      //8.8
wire signed	[OUT_DATA_WIDTH -1                   :0] w_intercept;  //8.8
reg  signed [VAR_DATA_WIDTH -1                   :0] r_var;
reg  signed	[OUT_DATA_WIDTH -1                   :0] r_intercept;      //8.8
reg  signed [OUT_DATA_WIDTH+VAR_DATA_WIDTH -1    :0] r_mul;        //16.24
wire signed [OUT_DATA_WIDTH -1                   :0] w_invsqrt;

reg r_LUT_done ; //LUT has 1 clock latency

invsqrt_LUT #(
    .VAR_DATA_WIDTH(VAR_DATA_WIDTH),
    .DATA_WIDTH(OUT_DATA_WIDTH),
    .LUT_NUM(LUT_NUM)
) u_invsqrt_LUT(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_data(w_var),
    .out_slope(w_slope), 
    .out_intercept(w_intercept)
);

//var + eps(=24'sh00_0000_0001 = smallest value_0.16 format )
assign w_var = i_var + $signed({ {(VAR_DATA_WIDTH-1){1'b0}}  ,1'b1  }); 

//FSM State
localparam  IDLE           = 2'b00;
localparam  CALC_LUT       = 2'b01;
localparam  CALC_INVSQRT   = 2'b10;

reg [1:0] c_state , n_state ;

// update next state
always @( posedge i_clk ) 
begin
        if(i_reset) c_state <= IDLE;
        else c_state <= n_state;
end

//compute next_state
always @(*)
begin 
    n_state = c_state;
    case(c_state)
        IDLE            : n_state = (i_valid) ?     CALC_LUT     : c_state;
        CALC_LUT        : n_state = (r_LUT_done)?   CALC_INVSQRT : c_state;
        CALC_INVSQRT    : n_state = IDLE;
    endcase
end


always @(posedge i_clk ) 
begin
    if (i_reset) 
    begin
        r_var       <= {(VAR_DATA_WIDTH){1'b0}};
        r_LUT_done  <= 1'b0;
        r_intercept <= {(OUT_DATA_WIDTH){1'b0}};
        r_mul       <= {(OUT_DATA_WIDTH+VAR_DATA_WIDTH){1'b0}};
    end

    else begin
    if ( c_state == IDLE)
    begin
        r_var       <= w_var;
        r_LUT_done  <= 1'b0;
    end

    else if(c_state == CALC_LUT)
    begin
        r_LUT_done  <= ~ r_LUT_done;
        r_intercept <= w_intercept;
        r_mul       <= w_slope * r_var;

    end

    end
end

//overflow, underflow check
wire w_mul_overflow = ~r_mul[OUT_DATA_WIDTH+VAR_DATA_WIDTH-1] &
                      |r_mul[OUT_DATA_WIDTH+VAR_DATA_WIDTH-2 : START_INDEX+OUT_DATA_WIDTH-1];
wire w_mul_underflow =  r_mul[OUT_DATA_WIDTH+VAR_DATA_WIDTH-1] &
                     ~(&r_mul[OUT_DATA_WIDTH+VAR_DATA_WIDTH-2 : START_INDEX+OUT_DATA_WIDTH-1]);

// r_mul _saturation
// 40bit(16.24) -> (8.8)
wire signed [OUT_DATA_WIDTH-1:0] w_mul_sat;
assign w_mul_sat = w_mul_overflow ? {1'b0, {(OUT_DATA_WIDTH-1){1'b1}}} :
                   w_mul_underflow ? {1'b1, {(OUT_DATA_WIDTH-1){1'b0}}} :
                   $signed(r_mul[START_INDEX+OUT_DATA_WIDTH-1 : START_INDEX]);


wire signed [OUT_DATA_WIDTH : 0] w_sum;

assign w_sum = w_mul_sat + r_intercept;

//sum overflow 처리
wire w_sum_overflow = ~w_sum[OUT_DATA_WIDTH] &  w_sum[OUT_DATA_WIDTH-1];
wire w_sum_underflow =  w_sum[OUT_DATA_WIDTH] & ~w_sum[OUT_DATA_WIDTH-1];

assign w_invsqrt = w_sum_overflow ? {1'b0, {(OUT_DATA_WIDTH-1){1'b1}}} :
                   w_sum_underflow ? {1'b1, {(OUT_DATA_WIDTH-1){1'b0}}} :
                   w_sum[OUT_DATA_WIDTH-1 : 0];

//assign w_invsqrt = $signed(r_mul[START_INDEX + 15 : START_INDEX]) + r_intercept;

always @(*) begin
    if (c_state == CALC_LUT && r_LUT_done)
    begin
        o_invsqrt = w_invsqrt;
        o_done    = 1'b1;
    end
    else begin
        o_invsqrt = {(OUT_DATA_WIDTH){1'b0}};
        o_done = 1'b0;
    end
end

endmodule