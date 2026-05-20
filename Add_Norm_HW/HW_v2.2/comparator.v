`timescale 1ns / 1ps

module comparator #(
	parameter DATA_WIDTH = 24 //(8.16) variance 
)(
	input signed [DATA_WIDTH-1:0] in_comparand, in_reference,
	output out_signal
	);

	assign out_signal = (in_comparand > in_reference) ? 0:1;

endmodule