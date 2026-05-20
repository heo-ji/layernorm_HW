`timescale 1ns / 1ps

module calculator_one_row #(
    parameter DATA_WIDTH                   = 16 ,  //8.8 fixed_point input
    parameter ACCUM_DATA_WIDTH             = 26 , //18.8 fixed_point
    parameter SQUARED_ACCUM_DATA_WIDTH     = 34 , //26.8 fixed_point
    parameter SHIFT_WIDTH                  = 8  ,
    parameter MODEL_DIMENSION_WIDTH        = 11 , 
    parameter FRAC_WIDTH                   = 8  ,    
    parameter SQUARED_MEAN_DATA_WIDTH      = 32 , // 16.16 fixed_point
    parameter VAR_DATA_WIDTH               = 24 ,  //8.16 fixed_point
    parameter LUT_NUM                      = 24 ,
    parameter START_INDEX                  = 16 

)(
    input                                   i_clk,
    input                                   i_reset,

    input                                   i_s_valid,
    output                                  o_s_ready,
    output                                  o_m_valid,
    input                                   i_m_ready,
    input      [MODEL_DIMENSION_WIDTH-1 : 0]    i_d_model,
    input      signed [DATA_WIDTH-1 : 0]    i_data,
    input      signed [4 : 0]               i_shift_value,
    input      signed [FRAC_WIDTH-1 : 0]    i_mult_value,
    output     signed [DATA_WIDTH-1 : 0]    o_invsqrt,
    output     signed [DATA_WIDTH-1 : 0]    o_mean
    //output reg o_done
);

//accum
wire signed [ACCUM_DATA_WIDTH-1 : 0]            w_accum;
wire signed [SQUARED_ACCUM_DATA_WIDTH-1 : 0]    w_squared_accum;
wire                                            w_accum_done;                  
//mean
wire signed [4 : 0]                             w_shift_value; 
wire signed [FRAC_WIDTH-1 : 0]                  w_mult_value;
wire signed [DATA_WIDTH-1 : 0]                  w_mean;
wire signed [SQUARED_MEAN_DATA_WIDTH-1 : 0]     w_squared_mean;
wire                                            w_mean_done;  
//var
wire signed [VAR_DATA_WIDTH-1 : 0]              w_var;
wire                                            w_var_done; 
//invsqrt
wire signed [DATA_WIDTH-1 : 0]                  w_invsqrt;
wire                                            w_invsqrt_done;     

//output
reg signed [DATA_WIDTH-1 : 0]  r_o_mean;
reg signed [DATA_WIDTH-1 : 0]  r_o_invsqrt;
reg                            r_o_m_valid;

//register
reg                                         r_accum_valid;
reg        [MODEL_DIMENSION_WIDTH-1 : 0]    r_accum_cnt;
reg                                         r_accum_fisnish;
reg signed [DATA_WIDTH-1 : 0]               r_data;

//wire i_m_ready = 1'b1;
assign w_shift_value = i_shift_value;
assign w_mult_value  = i_mult_value ;


always @( posedge i_clk ) 
begin
    if(i_reset) begin
            r_accum_valid     <= 1'b0;
            r_data            <= {(DATA_WIDTH){1'b0}};
            r_accum_cnt       <= 0;
            r_accum_fisnish   <= 1'b0;
    end
    else
    begin
        if(o_s_ready) begin
               r_accum_valid    <= i_s_valid;
               r_data           <= i_data;

               if(r_accum_valid == 1'b1)    r_accum_cnt  <=  r_accum_cnt + 1;
               else if (r_accum_cnt == i_d_model) r_accum_cnt  <=  0;
               else                         r_accum_cnt  <=  r_accum_cnt;
               
               r_accum_fisnish <= (r_accum_cnt == (i_d_model-1))? 1'b1 : 1'b0;


        end
    end
end


//compute output
// always @(posedge i_clk )
// begin
//     if (i_reset) 
//     begin
//         r_o_mean <= {(DATA_WIDTH){1'b0}};
//     end

//     else
//     begin
//         if(w_mean_done) r_o_mean <= w_mean;
//     end

//end

// //output compute 
// always @(*) begin
//     if()
//     o_invsqrt   = (w_invsqrt_done) ? w_invsqrt     : {(DATA_WIDTH){1'b0}}   ;  
//     o_mean      = (w_invsqrt_done) ? r_o_mean      : {(DATA_WIDTH){1'b0}}   ;
//     o_m_valid     = (w_invsqrt_done) ? 1'b1          : 1'b0                   ;
// end


//FSM State
localparam  IDLE          = 3'b000;
localparam  CALC_ACCUM    = 3'b001;
localparam  CALC_MEAN     = 3'b010;
localparam  CALC_VAR      = 3'b011;
localparam  CALC_INVSQRT  = 3'b100;
localparam  DONE          = 3'b101;
reg [2:0] c_state , n_state ;

always @( posedge i_clk ) // update next state
begin
        if(i_reset) c_state <= IDLE;
        else c_state <= n_state;
end

always @(*) //compute next state
begin 
    n_state = c_state;
    case(c_state)
        IDLE            : n_state = (r_accum_valid)   ? CALC_ACCUM : c_state;
        CALC_ACCUM      : n_state = (r_accum_fisnish) ? CALC_MEAN : c_state;
        CALC_MEAN       : n_state =                     CALC_VAR ;
        CALC_VAR        : n_state =                     CALC_INVSQRT ;
        CALC_INVSQRT    : n_state =                     DONE; //(w_invsqrt_done)  ? DONE : c_state;
        DONE            : n_state = IDLE;
    endcase
end

always @(posedge i_clk )
begin
    if (i_reset) 
    begin
        r_o_mean <= {(DATA_WIDTH){1'b0}};
        r_o_invsqrt <= {(DATA_WIDTH){1'b0}};
        r_o_m_valid   <= 1'b0;
    end

    else
    begin
        if(c_state == CALC_MEAN)
        begin 
            r_o_mean <= w_mean;
        end
        else if (c_state == DONE) 
        begin 
            r_o_invsqrt   <= w_invsqrt;
            r_o_m_valid     <= 1'b1;
        end
        else if (r_accum_valid)
        begin
            r_o_mean    <= {(DATA_WIDTH){1'b0}};
            r_o_invsqrt <= {(DATA_WIDTH){1'b0}};
            r_o_m_valid   <= 1'b0;
        end
        
    end
end
assign o_invsqrt   = r_o_invsqrt;  
assign o_mean      = r_o_mean;
assign o_m_valid     = r_o_m_valid;

assign o_s_ready = (i_m_ready || ~o_m_valid)&&(c_state == IDLE || c_state == CALC_ACCUM);


accum_one_row #(
    .INPUT_DATA_WIDTH           (DATA_WIDTH) , 
    .ACCUM_DATA_WIDTH           (ACCUM_DATA_WIDTH) , 
    .SQUARED_ACCUM_DATA_WIDTH   (SQUARED_ACCUM_DATA_WIDTH) ,
    .SHIFT_WIDTH                (SHIFT_WIDTH)
) u_accum(
    .i_clk                  (i_clk),
    .i_reset                 (i_reset),
    .i_valid                (r_accum_valid),
    .i_accum_finish         (r_accum_fisnish),
    .i_data                 (r_data), 
    .o_accum                (w_accum), 
    .o_squared_accum        (w_squared_accum), 
    .o_done                 (w_accum_done)
);

mean #(
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH) , 
    .SQUARED_ACCUM_DATA_WIDTH(SQUARED_ACCUM_DATA_WIDTH) ,
    .MEAN_DATA_WIDTH(DATA_WIDTH),
    .SQUARED_MEAN_DATA_WIDTH(SQUARED_MEAN_DATA_WIDTH)
) u_mean(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_valid(w_accum_done),
    .i_shift_value(w_shift_value),
    .i_mult_value(w_mult_value),
    .i_accum(w_accum), 
    .i_squared_accum(w_squared_accum), 
    .o_mean(w_mean), 
    .o_squared_mean(w_squared_mean), 
    .o_done(w_mean_done) 
);

var #(
    .MEAN_DATA_WIDTH(DATA_WIDTH),
    .SQUARED_MEAN_DATA_WIDTH(SQUARED_MEAN_DATA_WIDTH),
    .VAR_DATA_WIDTH(VAR_DATA_WIDTH)
)u_var(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_valid(w_mean_done),
    .i_mean(w_mean), 
    .i_squared_mean(w_squared_mean), 
    .o_var(w_var),
    .o_done(w_var_done) 
);

invsqrt #(
    .VAR_DATA_WIDTH(VAR_DATA_WIDTH),
    .OUT_DATA_WIDTH(DATA_WIDTH),
    .LUT_NUM(LUT_NUM),
    .START_INDEX(START_INDEX)
)u_invsqrt(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_valid(w_var_done), 
    .i_var(w_var),
    .o_invsqrt(w_invsqrt),
    .o_done(w_invsqrt_done) 
);


endmodule