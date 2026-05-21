`timescale 1ns / 1ps

module invsqrt_LUT #(
    parameter VAR_DATA_WIDTH = 24, //Qformat=(8.16
    parameter DATA_WIDTH = 16, //Qformat=(8.8)
    parameter LUT_NUM = 24
) (
    input                                       i_clk,
    input                                       i_reset,
    input       signed [VAR_DATA_WIDTH-1 :0]    i_data,
    output reg  signed  [DATA_WIDTH-1    :0]    out_slope,
    output reg  signed  [DATA_WIDTH-1    :0]    out_intercept
);

reg  signed  [DATA_WIDTH-1:0]        w_out_slope;
reg  signed  [DATA_WIDTH-1:0]        w_out_intercept;

always @(posedge i_clk )
begin
    if (i_reset) 
    begin
        out_slope      <= {(DATA_WIDTH){1'b0}};
        out_intercept  <= {(DATA_WIDTH){1'b0}};
    end
    else
    begin
        out_slope      <= w_out_slope;
        out_intercept  <= w_out_intercept;
    end
end

//LUT선언
wire        [LUT_NUM-1          :0] w_signal;
wire signed [VAR_DATA_WIDTH-1   :0] r_division  [LUT_NUM-1:0]; //Qformat=(8.16)
wire signed [DATA_WIDTH-1       :0] r_slope     [LUT_NUM-1:0];        //Qformat=(8.8)
wire signed [DATA_WIDTH-1       :0] r_intercept [LUT_NUM-1:0];    //Qformat=(8.8)

assign r_division[0]  = 24'sh000487;
assign r_division[1]  = 24'sh00048D;
assign r_division[2]  = 24'sh0004A3;
assign r_division[3]  = 24'sh0004C9;
assign r_division[4]  = 24'sh0004CD;
assign r_division[5]  = 24'sh0004FD;
assign r_division[6]  = 24'sh00051F;
assign r_division[7]  = 24'sh000555;
assign r_division[8]  = 24'sh0005AF;
assign r_division[9]  = 24'sh00127D;
assign r_division[10] = 24'sh002113;
assign r_division[11] = 24'sh004049;
assign r_division[12] = 24'sh006A8F;
assign r_division[13] = 24'sh009B74;
assign r_division[14] = 24'sh00CE59;
assign r_division[15] = 24'sh01175C;
assign r_division[16] = 24'sh018431;
assign r_division[17] = 24'sh023404;
assign r_division[18] = 24'sh03871C;
assign r_division[19] = 24'sh07CDCC;
assign r_division[20] = 24'sh07DED9;
assign r_division[21] = 24'sh1DC36A;
assign r_division[22] = 24'sh1FAD66;
assign r_division[23] = 24'sh222895;

assign r_slope[0] =  16'sh8000;
assign r_slope[1] =  16'sh8000;
assign r_slope[2] =  16'sh8000;
assign r_slope[3] =  16'sh8000;
assign r_slope[4] =  16'sh8000;
assign r_slope[5] =  16'sh8000;
assign r_slope[6] =  16'sh8000;
assign r_slope[7] =  16'sh8000;
assign r_slope[8] =  16'sh8000;
assign r_slope[9] =  16'shDBC7;
assign r_slope[10] = 16'shEF08;
assign r_slope[11] = 16'shF9F0;
assign r_slope[12] = 16'shFD73;
assign r_slope[13] = 16'shFEAD;
assign r_slope[14] = 16'shFF28;
assign r_slope[15] = 16'shFF73;
assign r_slope[16] = 16'shFFA9;
assign r_slope[17] = 16'shFFCC;
assign r_slope[18] = 16'shFFE4;
assign r_slope[19] = 16'shFFF5;
assign r_slope[20] = 16'shFFC6;
assign r_slope[21] = 16'shFFFE;
assign r_slope[22] = 16'shFFEA;
assign r_slope[23] = 16'sh0000;

assign r_intercept[0] =  16'sh27F3;
assign r_intercept[1] =  16'sh2542;
assign r_intercept[2] =  16'sh21FD;
assign r_intercept[3] =  16'sh1E90;
assign r_intercept[4] =  16'sh1ABB;
assign r_intercept[5] =  16'sh1723;
assign r_intercept[6] =  16'sh1308;
assign r_intercept[7] =  16'sh0EDE;
assign r_intercept[8] =  16'sh0ABB;
assign r_intercept[9] =  16'sh0645;
assign r_intercept[10] = 16'sh04E2;
assign r_intercept[11] = 16'sh0379;
assign r_intercept[12] = 16'sh0297;
assign r_intercept[13] = 16'sh0214;
assign r_intercept[14] = 16'sh01CA;
assign r_intercept[15] = 16'sh018D;
assign r_intercept[16] = 16'sh0153;
assign r_intercept[17] = 16'sh011D;
assign r_intercept[18] = 16'sh00E8;
assign r_intercept[19] = 16'sh00AE;
assign r_intercept[20] = 16'sh021C;
assign r_intercept[21] = 16'sh005E;
assign r_intercept[22] = 16'sh02BC;
assign r_intercept[23] = 16'sh0000;

    

    //비교기 24개
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_0  (.in_comparand(i_data), .in_reference(r_division[0]), .out_signal(w_signal[0]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_1  (.in_comparand(i_data), .in_reference(r_division[1]), .out_signal(w_signal[1]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_2  (.in_comparand(i_data), .in_reference(r_division[2]), .out_signal(w_signal[2]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_3  (.in_comparand(i_data), .in_reference(r_division[3]), .out_signal(w_signal[3]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_4  (.in_comparand(i_data), .in_reference(r_division[4]), .out_signal(w_signal[4]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_5  (.in_comparand(i_data), .in_reference(r_division[5]), .out_signal(w_signal[5]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_6  (.in_comparand(i_data), .in_reference(r_division[6]), .out_signal(w_signal[6]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_7  (.in_comparand(i_data), .in_reference(r_division[7]), .out_signal(w_signal[7]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_8  (.in_comparand(i_data), .in_reference(r_division[8]), .out_signal(w_signal[8]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_9  (.in_comparand(i_data), .in_reference(r_division[9]), .out_signal(w_signal[9]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_10 (.in_comparand(i_data), .in_reference(r_division[10]), .out_signal(w_signal[10]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_11 (.in_comparand(i_data), .in_reference(r_division[11]), .out_signal(w_signal[11]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_12 (.in_comparand(i_data), .in_reference(r_division[12]), .out_signal(w_signal[12]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_13 (.in_comparand(i_data), .in_reference(r_division[13]), .out_signal(w_signal[13]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_14 (.in_comparand(i_data), .in_reference(r_division[14]), .out_signal(w_signal[14]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_15 (.in_comparand(i_data), .in_reference(r_division[15]), .out_signal(w_signal[15]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_16 (.in_comparand(i_data), .in_reference(r_division[16]), .out_signal(w_signal[16]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_17 (.in_comparand(i_data), .in_reference(r_division[17]), .out_signal(w_signal[17]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_18 (.in_comparand(i_data), .in_reference(r_division[18]), .out_signal(w_signal[18]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_19 (.in_comparand(i_data), .in_reference(r_division[19]), .out_signal(w_signal[19]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_20 (.in_comparand(i_data), .in_reference(r_division[20]), .out_signal(w_signal[20]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_21 (.in_comparand(i_data), .in_reference(r_division[21]), .out_signal(w_signal[21]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_22 (.in_comparand(i_data), .in_reference(r_division[22]), .out_signal(w_signal[22]));
    comparator #(.DATA_WIDTH(VAR_DATA_WIDTH)) comparator_23 (.in_comparand(i_data), .in_reference(r_division[23]), .out_signal(w_signal[23]));




    always @(*) begin
        case (w_signal)
            24'b1111_1111_1111_1111_1111_1111 : begin
                w_out_slope       =     r_slope[0];
                w_out_intercept   = r_intercept[0];
            end
            24'b1111_1111_1111_1111_1111_1110 : begin
                w_out_slope       =     r_slope[1];
                w_out_intercept   = r_intercept[1];
            end
            24'b1111_1111_1111_1111_1111_1100 : begin
                w_out_slope       =     r_slope[2];
                w_out_intercept   = r_intercept[2];
            end
            24'b1111_1111_1111_1111_1111_1000 : begin
                w_out_slope       =     r_slope[3];
                w_out_intercept   = r_intercept[3];
            end
            24'b1111_1111_1111_1111_1111_0000 : begin
                w_out_slope       =     r_slope[4];
                w_out_intercept   = r_intercept[4];
            end
            24'b1111_1111_1111_1111_1110_0000 : begin
                w_out_slope       =     r_slope[5];
                w_out_intercept   = r_intercept[5];
            end
            24'b1111_1111_1111_1111_1100_0000 : begin
                w_out_slope       =     r_slope[6];
                w_out_intercept   = r_intercept[6];
            end
            24'b1111_1111_1111_1111_1000_0000 : begin
                w_out_slope       =     r_slope[7];
                w_out_intercept   = r_intercept[7];
            end
            24'b1111_1111_1111_1111_0000_0000 : begin
                w_out_slope       =     r_slope[8];
                w_out_intercept   = r_intercept[8];
            end
            24'b1111_1111_1111_1110_0000_0000 : begin
                w_out_slope       =     r_slope[9];
                w_out_intercept   = r_intercept[9];
            end
            24'b1111_1111_1111_1100_0000_0000 : begin
                w_out_slope       =     r_slope[10];
                w_out_intercept   = r_intercept[10];
            end
            24'b1111_1111_1111_1000_0000_0000 : begin
                w_out_slope       =     r_slope[11];
                w_out_intercept   = r_intercept[11];
            end
            24'b1111_1111_1111_0000_0000_0000 : begin
                w_out_slope       =     r_slope[12];
                w_out_intercept   = r_intercept[12];
            end
            24'b1111_1111_1110_0000_0000_0000 : begin
                w_out_slope       =     r_slope[13];
                w_out_intercept   = r_intercept[13];
            end
            24'b1111_1111_1100_0000_0000_0000 : begin
                w_out_slope       =     r_slope[14];
                w_out_intercept   = r_intercept[14];
            end
            24'b1111_1111_1000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[15];
                w_out_intercept   = r_intercept[15];
            end
            24'b1111_1111_0000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[16];
                w_out_intercept   = r_intercept[16];
            end
            24'b1111_1110_0000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[17];
                w_out_intercept   = r_intercept[17];
            end
            24'b1111_1100_0000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[18];
                w_out_intercept   = r_intercept[18];
            end
            24'b1111_1000_0000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[19];
                w_out_intercept   = r_intercept[19];
            end
            24'b1111_0000_0000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[20];
                w_out_intercept   = r_intercept[20];
            end
            24'b1110_0000_0000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[21];
                w_out_intercept   = r_intercept[21];
            end
            24'b1100_0000_0000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[22];
                w_out_intercept   = r_intercept[22];
            end
            24'b1000_0000_0000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[23];
                w_out_intercept   = r_intercept[23];
            end
            24'b0000_0000_0000_0000_0000_0000 : begin
                w_out_slope       =     r_slope[23];
                w_out_intercept   = r_intercept[23]; //[0]???
            end

            default : begin
                w_out_slope       = {(DATA_WIDTH){1'b0}};
                w_out_intercept   = {(DATA_WIDTH){1'b0}};
            end
        endcase
    end
    



endmodule