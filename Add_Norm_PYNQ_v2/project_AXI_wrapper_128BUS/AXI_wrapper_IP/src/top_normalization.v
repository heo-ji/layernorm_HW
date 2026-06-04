`timescale 1ns / 1ps

module top_normalization#(
    parameter MODULE_NUM 	= 32,
	parameter DATA_WIDTH 	= 16
)(
    input i_clk, 
    input i_reset, 
    input                                   i_s_valid,
    output                                  o_s_ready,
    output                                  o_m_valid,
    input                                   i_m_ready,
    input signed  [(DATA_WIDTH*MODULE_NUM)-1 : 0] i_mean,
    input signed  [(DATA_WIDTH*MODULE_NUM)-1 : 0] i_invsqrt,
    input signed  [(DATA_WIDTH*MODULE_NUM)-1 : 0] i_data,
    output signed [(DATA_WIDTH*MODULE_NUM)-1 : 0] o_data,
    input  i_data_last,
    output o_data_last
);    

wire [MODULE_NUM-1:0]	w_m_valid;

assign o_m_valid = &w_m_valid;

genvar i;
generate 
    for (i = 0; i < MODULE_NUM; i = i + 1) begin : gen_normalization_module
		normalization #(
			.DATA_WIDTH ( DATA_WIDTH )
        ) normalization_module (
			.i_clk		(	i_clk	 ), 
			.i_reset		(	i_reset	 ),
			.i_s_valid	(	i_s_valid),
            .o_s_ready  (	o_s_ready),
            .o_m_valid  (	w_m_valid[i]),
            .i_m_ready  (	i_m_ready),
            .i_mean	    (   i_mean   [DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]   	),
            .i_invsqrt	(   i_invsqrt[DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]   	),
			.i_data 	(   i_data   [DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]    ),
			.o_data	    (   o_data   [DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]   	),
            .i_data_last (   i_data_last                                     ),
            .o_data_last (o_data_last)
		);
    end
endgenerate



endmodule
