`timescale 1ns / 1ps

module add_norm_tb();

// -------------------------------------------------------
// Parameters
// -------------------------------------------------------
parameter MODULE_NUM                 = 32;
parameter DATA_WIDTH                 = 16;   // 8.8  fixed-point
parameter ACCUM_DATA_WIDTH           = 26;   // 18.8 fixed-point
parameter SQUARED_ACCUM_DATA_WIDTH   = 34;   // 26.8 fixed-point
parameter SHIFT_WIDTH                = 8;
parameter MODEL_DIMENSION_WIDTH      = 11;
parameter FRAC_WIDTH                 = 8;
parameter SQUARED_MEAN_DATA_WIDTH    = 32;   // 16.16 fixed-point
parameter VAR_DATA_WIDTH             = 24;   // 8.16  fixed-point
parameter LUT_NUM                    = 24;
parameter START_INDEX                = 16;
parameter D_MODEL                    = 768;

// -------------------------------------------------------
// Clock / Reset
// -------------------------------------------------------
wire i_uut_clk;
reg  clk;
reg  i_reset;

initial begin
    clk = 1;
    forever #5 clk = ~clk;
end
assign i_uut_clk = ~clk;   // DUT driven on inverted clock (same pattern as tb_calculator.v)

initial begin
    i_reset = 1;
    #30 i_reset = 0;
end

// -------------------------------------------------------
// Calculator I/O
// -------------------------------------------------------
reg                                          i_s_valid_calc;
reg                                          i_m_ready_calc;
reg  signed [(DATA_WIDTH*MODULE_NUM)-1 : 0]  i_data_calc;
wire signed [(DATA_WIDTH*MODULE_NUM)-1 : 0]  o_mean;
wire signed [(DATA_WIDTH*MODULE_NUM)-1 : 0]  o_invsqrt;
wire                                         o_m_valid_calc;
wire                                         o_s_ready_calc;
reg         [MODEL_DIMENSION_WIDTH-1   : 0]  i_d_model;
reg  signed [4                         : 0]  i_shift_value;
reg  signed [FRAC_WIDTH-1              : 0]  i_mult_value;

// -------------------------------------------------------
// Normalization I/O
// -------------------------------------------------------
reg                                          i_s_valid_norm;
reg                                          i_m_ready_norm;
reg  signed [(DATA_WIDTH*MODULE_NUM)-1 : 0]  i_data_norm;
wire signed [(DATA_WIDTH*MODULE_NUM)-1 : 0]  o_norm_data;
wire                                         o_m_valid_norm;
wire                                         o_s_ready_norm;

// -------------------------------------------------------
// DUT Instantiation
// -------------------------------------------------------
top_calculator_one_row #(
    .MODULE_NUM               (MODULE_NUM),
    .DATA_WIDTH               (DATA_WIDTH),
    .ACCUM_DATA_WIDTH         (ACCUM_DATA_WIDTH),
    .SQUARED_ACCUM_DATA_WIDTH (SQUARED_ACCUM_DATA_WIDTH),
    .SHIFT_WIDTH              (SHIFT_WIDTH),
    .MODEL_DIMENSION_WIDTH    (MODEL_DIMENSION_WIDTH),
    .FRAC_WIDTH               (FRAC_WIDTH),
    .SQUARED_MEAN_DATA_WIDTH  (SQUARED_MEAN_DATA_WIDTH),
    .VAR_DATA_WIDTH           (VAR_DATA_WIDTH),
    .LUT_NUM                  (LUT_NUM),
    .START_INDEX              (START_INDEX)
) uut_calc (
    .i_clk         (i_uut_clk),
    .i_reset       (i_reset),
    .i_s_valid     (i_s_valid_calc),
    .o_s_ready     (o_s_ready_calc),
    .o_m_valid     (o_m_valid_calc),
    .i_m_ready     (i_m_ready_calc),
    .i_data        (i_data_calc),
    .o_invsqrt     (o_invsqrt),
    .o_mean        (o_mean),
    .i_d_model     (i_d_model),
    .i_shift_value (i_shift_value),
    .i_mult_value  (i_mult_value)
);

// i_mean / i_invsqrt are held from uut_calc outputs (stable while calc is idle)
top_normalization #(
    .MODULE_NUM (MODULE_NUM),
    .DATA_WIDTH (DATA_WIDTH)
) uut_norm (
    .i_clk     (i_uut_clk),
    .i_reset   (i_reset),
    .i_s_valid (i_s_valid_norm),
    .o_s_ready (o_s_ready_norm),
    .o_m_valid (o_m_valid_norm),
    .i_m_ready (i_m_ready_norm),
    .i_mean    (o_mean),
    .i_invsqrt (o_invsqrt),
    .i_data    (i_data_norm),
    .o_data    (o_norm_data)
);

// -------------------------------------------------------
// File handles
// -------------------------------------------------------
integer f_rtl_acc, f_rtl_acc2;
integer f_rtl_mean, f_rtl_mean2;
integer f_rtl_var, f_rtl_invsqrt;
integer f_rtl_norm;
integer f_in;

// -------------------------------------------------------
// Capture flags (each intermediate fires exactly once)
// -------------------------------------------------------
reg r_acc_captured;
reg r_mean2_captured;
reg r_var_captured;
reg r_final_captured;

initial begin
    r_acc_captured   = 0;
    r_mean2_captured = 0;
    r_var_captured   = 0;
    r_final_captured = 0;
end

// -------------------------------------------------------
// Intermediate capture: acc / acc2
//   Triggered when w_accum_done fires in module[0]
//   (all 32 modules fire simultaneously)
// -------------------------------------------------------
always @(posedge clk) begin
    if (!r_acc_captured && uut_calc.gen_calculator[0].calculator_module.w_accum_done) begin
        r_acc_captured <= 1;
        // --- acc (26-bit, 18.8) ---
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[0].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[1].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[2].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[3].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[4].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[5].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[6].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[7].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[8].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[9].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[10].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[11].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[12].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[13].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[14].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[15].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[16].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[17].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[18].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[19].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[20].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[21].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[22].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[23].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[24].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[25].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[26].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[27].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[28].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[29].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[30].calculator_module.w_accum);
        $fwrite(f_rtl_acc, "%07X\n", uut_calc.gen_calculator[31].calculator_module.w_accum);
        // --- acc2 (34-bit, 26.8) ---
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[0].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[1].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[2].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[3].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[4].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[5].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[6].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[7].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[8].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[9].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[10].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[11].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[12].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[13].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[14].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[15].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[16].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[17].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[18].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[19].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[20].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[21].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[22].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[23].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[24].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[25].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[26].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[27].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[28].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[29].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[30].calculator_module.w_squared_accum);
        $fwrite(f_rtl_acc2, "%09X\n", uut_calc.gen_calculator[31].calculator_module.w_squared_accum);
    end
end

// -------------------------------------------------------
// Intermediate capture: mean2 (squared_mean)
//   Triggered when w_mean_done fires
// -------------------------------------------------------
always @(posedge clk) begin
    if (!r_mean2_captured && uut_calc.gen_calculator[0].calculator_module.w_mean_done) begin
        r_mean2_captured <= 1;
        // --- mean2 (32-bit, 16.16) ---
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[0].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[1].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[2].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[3].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[4].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[5].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[6].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[7].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[8].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[9].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[10].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[11].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[12].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[13].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[14].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[15].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[16].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[17].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[18].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[19].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[20].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[21].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[22].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[23].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[24].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[25].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[26].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[27].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[28].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[29].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[30].calculator_module.w_squared_mean);
        $fwrite(f_rtl_mean2, "%08X\n", uut_calc.gen_calculator[31].calculator_module.w_squared_mean);
    end
end

// -------------------------------------------------------
// Intermediate capture: var
//   Triggered when w_var_done fires
// -------------------------------------------------------
always @(posedge clk) begin
    if (!r_var_captured && uut_calc.gen_calculator[0].calculator_module.w_var_done) begin
        r_var_captured <= 1;
        // --- var (24-bit, 8.16) ---
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[0].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[1].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[2].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[3].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[4].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[5].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[6].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[7].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[8].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[9].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[10].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[11].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[12].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[13].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[14].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[15].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[16].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[17].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[18].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[19].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[20].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[21].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[22].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[23].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[24].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[25].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[26].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[27].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[28].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[29].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[30].calculator_module.w_var);
        $fwrite(f_rtl_var, "%06X\n", uut_calc.gen_calculator[31].calculator_module.w_var);
    end
end

// -------------------------------------------------------
// Final capture: mean / invsqrt from top-level bus
//   Triggered when o_m_valid_calc first asserts
// -------------------------------------------------------
integer j;
always @(posedge clk) begin
    if (!r_final_captured && o_m_valid_calc) begin
        r_final_captured <= 1;
        for (j = 0; j < MODULE_NUM; j = j + 1) begin
            $fwrite(f_rtl_mean,    "%04X\n", o_mean[DATA_WIDTH*(j+1)-1 -: DATA_WIDTH]);
            $fwrite(f_rtl_invsqrt, "%04X\n", o_invsqrt[DATA_WIDTH*(j+1)-1 -: DATA_WIDTH]);
        end
    end
end

// -------------------------------------------------------
// Norm output capture: one 512-bit line per valid output cycle
// -------------------------------------------------------
always @(posedge clk) begin
    if (o_m_valid_norm) begin
        $fwrite(f_rtl_norm, "%0128X\n", o_norm_data);
    end
end

// -------------------------------------------------------
// Main test flow
// -------------------------------------------------------
integer i;

initial begin
    // Initialize control signals
    i_s_valid_calc = 0;
    i_m_ready_calc = 1;
    i_s_valid_norm = 0;
    i_m_ready_norm = 1;
    i_data_calc    = {(DATA_WIDTH*MODULE_NUM){1'b0}};
    i_data_norm    = {(DATA_WIDTH*MODULE_NUM){1'b0}};
    // BERT-base parameters (768 = >>>8 * 0.33203125)
    i_d_model     = 11'd768;
    i_shift_value = 5'sd8;
    i_mult_value  = 8'sb01010101;

    // Open RTL output trace files
    f_rtl_acc     = $fopen("../trace/rtl_acc.txt",     "w");
    f_rtl_acc2    = $fopen("../trace/rtl_acc2.txt",    "w");
    f_rtl_mean    = $fopen("../trace/rtl_mean.txt",    "w");
    f_rtl_mean2   = $fopen("../trace/rtl_mean2.txt",   "w");
    f_rtl_var     = $fopen("../trace/rtl_var.txt",     "w");
    f_rtl_invsqrt = $fopen("../trace/rtl_invsqrt.txt", "w");
    f_rtl_norm    = $fopen("../trace/rtl_norm.txt",    "w");

    if (!f_rtl_acc || !f_rtl_acc2 || !f_rtl_mean || !f_rtl_mean2 ||
        !f_rtl_var || !f_rtl_invsqrt || !f_rtl_norm) begin
        $display("Error: failed to open RTL trace output files.");
        $finish;
    end

    // Wait for reset release
    @(negedge i_reset);
    @(posedge clk);

    // --------------------------------------------------
    // Phase 1: Calculator
    //   Feed D_MODEL cycles of 512-bit input data
    // --------------------------------------------------
    f_in = $fopen("../trace/in_data.txt", "r");
    if (!f_in) begin
        $display("Error: failed to open ../trace/in_data.txt");
        $finish;
    end

    i = 0;
    while (i < D_MODEL) begin
        i_s_valid_calc = 1;
        $fscanf(f_in, "%h", i_data_calc);
        i = i + 1;
        @(posedge clk);
    end
    i_s_valid_calc = 0;
    $fclose(f_in);

    // Wait for calculator to complete (o_m_valid_calc asserts)
    @(posedge o_m_valid_calc);
    repeat(2) @(posedge clk);   // Let outputs fully settle

    // --------------------------------------------------
    // Phase 2: Normalization
    //   o_mean / o_invsqrt held stable from uut_calc
    //   Feed same 512-bit data stream again
    // --------------------------------------------------
    f_in = $fopen("../trace/in_data.txt", "r");
    if (!f_in) begin
        $display("Error: failed to open ../trace/in_data.txt");
        $finish;
    end

    i = 0;
    while (i < D_MODEL) begin
        i_s_valid_norm = 1;
        $fscanf(f_in, "%h", i_data_norm);
        i = i + 1;
        @(posedge clk);
    end
    i_s_valid_norm = 0;
    $fclose(f_in);

    // Wait for all norm outputs to drain (1-cycle pipeline latency + margin)
    repeat(20) @(posedge clk);

    // Close all files
    $fclose(f_rtl_acc);
    $fclose(f_rtl_acc2);
    $fclose(f_rtl_mean);
    $fclose(f_rtl_mean2);
    $fclose(f_rtl_var);
    $fclose(f_rtl_invsqrt);
    $fclose(f_rtl_norm);

    $display("[TB] Simulation complete. RTL trace files written to ../trace/");
    $finish;
end

endmodule
