`timescale 1ns / 1ps

module normalization#(
    parameter DATA_WIDTH = 16  //8.8 fixed_point =16bit
)(
    input i_clk,
    input i_rstn,
    input                                   i_s_valid,
    output                                  o_s_ready,
    output reg                              o_m_valid,
    input                                   i_m_ready,
    input       signed [DATA_WIDTH-1 : 0] i_mean,
    input       signed [DATA_WIDTH-1 : 0] i_invsqrt,
    input       signed [DATA_WIDTH-1 : 0] i_data,
    output reg  signed [DATA_WIDTH-1 : 0]  o_data
    //output reg o_done
);

//assign o_s_ready = (i_m_ready || ~o_m_valid); //if you want to use this assign statement, modify always block
assign o_s_ready = 1'b1;

wire signed [DATA_WIDTH-1:0] w_data_minus_mean; //16bit(8.8)
wire signed [(2*DATA_WIDTH)-1:0] w_multiply_invsqrt; //32bit(16.16)

assign w_data_minus_mean = (i_data - i_mean) ;
assign w_multiply_invsqrt = (w_data_minus_mean * i_invsqrt);

always @(posedge i_clk , negedge i_rstn)
begin
    if(!i_rstn) begin
        o_data <= {(DATA_WIDTH){1'b0}};
        o_m_valid <= 1'b0;
    end
    else begin
        if(i_s_valid) begin
        o_data <= $signed(w_multiply_invsqrt[DATA_WIDTH+7 :8]); //32bit -> 16bit = eliminate upper 8bit & lower 8bit
        o_m_valid <= 1'b1;
        end

        else begin
        o_data <= {(DATA_WIDTH){1'b0}};
        o_m_valid <= 1'b0;
        end
    end   
end





endmodule
