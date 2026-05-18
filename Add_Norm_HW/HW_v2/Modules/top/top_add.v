`timescale 1ns / 1ps

module top_add#(
    parameter module_num 	= 32,
	parameter DATA_WIDTH 	= 16
)(
    input i_clk, 
    input i_rstn, 
    input i_start,
    input signed  [(DATA_WIDTH*module_num)-1 : 0] i_bias,
    input signed  [(DATA_WIDTH*module_num)-1 : 0] i_data,
    output signed [(DATA_WIDTH*module_num)-1 : 0] o_data,
    output o_end
);    

wire [module_num-1:0]	w_end;

genvar i;
generate 
    for (i = 0; i < module_num; i = i + 1) begin : gen_normalization_module
		add #(
			.DATA_WIDTH ( DATA_WIDTH )
        ) add_bias_module (
			.i_clk		(	i_clk	 ), 
			.i_rstn		(	i_rstn	 ),
			.i_run	    (	i_start	 ),
            .i_bias	    (   i_bias  [DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]   	),
			.i_data 	(   i_data  [DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]   	),
			.o_data	    (   o_data  [DATA_WIDTH*(i+1)-1 : DATA_WIDTH*i]   	),
			.o_done	    (	w_end[i] )
		);
    end
endgenerate

assign o_end = &w_end;


endmodule
