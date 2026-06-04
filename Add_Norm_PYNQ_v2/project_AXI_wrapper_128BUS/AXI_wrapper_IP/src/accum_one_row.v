`timescale 1ns / 1ps

module accum_one_row#(
    parameter INPUT_DATA_WIDTH          = 16 ,  //8.8 fixed_point  
    parameter ACCUM_DATA_WIDTH          = 26 , //18.8 fixed_point 
    parameter SQUARED_ACCUM_DATA_WIDTH  = 34 , //26.8 fixed_point
    parameter SHIFT_WIDTH               = 8
)(
    input                                           i_clk,
    input                                           i_reset,
    input                                           i_valid,
    input                                           i_accum_finish,
    input  signed [INPUT_DATA_WIDTH-1 : 0]          i_data, 
    output signed [ACCUM_DATA_WIDTH-1 : 0]          o_accum, 
    output signed [SQUARED_ACCUM_DATA_WIDTH-1 : 0]  o_squared_accum, //accumulate "squared value"
    output                                          o_done 
);

wire    signed [(2*INPUT_DATA_WIDTH)-1:0]           w_squared_data;
reg     signed [ACCUM_DATA_WIDTH-1 : 0]             r_accum;
reg     signed [SQUARED_ACCUM_DATA_WIDTH-1 : 0]     r_squared_accum;
reg                                                 r_last_flag;

assign w_squared_data = (i_data * i_data) ;

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
        r_accum         <= {(ACCUM_DATA_WIDTH){1'b0}};
        r_squared_accum <= {(SQUARED_ACCUM_DATA_WIDTH){1'b0}};
    end

    else
    begin
        if(i_valid)
        begin
            r_accum         <= r_accum  + i_data;
            r_squared_accum <= r_squared_accum + (w_squared_data >>> SHIFT_WIDTH) ;
        end
        else if (r_last_flag)
        begin
            r_accum         <= {(ACCUM_DATA_WIDTH){1'b0}};
            r_squared_accum <= {(SQUARED_ACCUM_DATA_WIDTH){1'b0}};
        end
        else
        begin
            r_accum         <= r_accum;
            r_squared_accum <= r_squared_accum;
        end
    end
end

assign o_accum         = r_accum;
assign o_squared_accum = r_squared_accum;
assign o_done          = i_accum_finish;

endmodule
