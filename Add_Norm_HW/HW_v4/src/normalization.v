`timescale 1ns / 1ps

module normalization#(
    parameter FRAC_WIDTH = 8,
    parameter DATA_WIDTH = 16  //8.8 fixed_point =16bit
)(
    input i_clk,
    input i_reset,
    input                                   i_s_valid,
    output                                  o_s_ready,
    output reg                              o_m_valid,
    input                                   i_m_ready,
    input       signed [DATA_WIDTH-1 : 0] i_mean,
    input       signed [DATA_WIDTH-1 : 0] i_invsqrt,
    input       signed [DATA_WIDTH-1 : 0] i_data,
    output reg  signed [DATA_WIDTH-1 : 0]  o_data,
    input  i_data_last,
    output reg o_data_last
);

assign o_s_ready = (i_m_ready || ~o_m_valid);

wire signed [DATA_WIDTH-1:0] w_data_minus_mean; //16bit(8.8)
wire signed [(2*DATA_WIDTH)-1:0] w_multiply_invsqrt; //32bit(16.16)

assign w_data_minus_mean = (i_data - i_mean) ;
assign w_multiply_invsqrt = (w_data_minus_mean * i_invsqrt);



wire w_data_overflow = ~w_multiply_invsqrt[(2*DATA_WIDTH)-1] &
                       |w_multiply_invsqrt[(2*DATA_WIDTH)-2 : DATA_WIDTH+FRAC_WIDTH-1];


wire w_data_underflow =  w_multiply_invsqrt[(2*DATA_WIDTH)-1] &
                      ~(&w_multiply_invsqrt[(2*DATA_WIDTH)-2 : DATA_WIDTH+FRAC_WIDTH-1]);
//MSB=1(음수) & (상위 비트에 0 존재?)


always @(posedge i_clk )
begin
    if(i_reset) begin
        o_data      <= {(DATA_WIDTH){1'b0}};
        o_m_valid   <= 1'b0;
        o_data_last <= 1'b0;
    end
    else begin
        if (o_s_ready) begin
            if(i_s_valid) begin
                o_data <= w_data_overflow ? {1'b0, {(DATA_WIDTH-1){1'b1}}} :
                          w_data_underflow ? {1'b1, {(DATA_WIDTH-1){1'b0}}} :
                          $signed(w_multiply_invsqrt[DATA_WIDTH+FRAC_WIDTH-1 : FRAC_WIDTH]);
                o_m_valid   <= 1'b1;
                o_data_last <= i_data_last;
            end
            else begin
                o_m_valid   <= 1'b0;
                o_data_last <= 1'b0;
            end
        end
    end
end





endmodule
