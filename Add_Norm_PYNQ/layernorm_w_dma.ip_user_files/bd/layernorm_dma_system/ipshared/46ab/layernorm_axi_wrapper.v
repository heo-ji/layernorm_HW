//
//AXI-Stream + FSM + IP 

//FSM (IDLE→ITER1→STORE→ITER2→OUTPUT)

//
//
`timescale 1 ns / 1 ps

	module layernorm_axi_wrapper #
	(
		// Users to add parameters here
        parameter MODULE_NUM 	               = 32,
        parameter DATA_WIDTH                   = 16,  //8.8 fixed_point input
        parameter ACCUM_DATA_WIDTH             = 26, //18.8 fixed_point
        parameter SQUARED_ACCUM_DATA_WIDTH     = 34, //26.8 fixed_point
        parameter SHIFT_WIDTH                  = 8 ,
        parameter MODEL_DIMENSION_WIDTH        = 11,
        parameter FRAC_WIDTH                   = 8 ,   
        parameter SQUARED_MEAN_DATA_WIDTH      = 32, // 16.16 fixed_point
        parameter VAR_DATA_WIDTH               = 24,  //8.16 fixed_point
        parameter LUT_NUM                      = 24,
        parameter START_INDEX                  = 16,
        parameter SHIFT_VALUE_DATA_WIDTH       = 5,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 5,

		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 512,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 512,
		parameter integer C_M00_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,

		// Ports of Axi Slave Bus Interface S00_AXIS
		input wire  s00_axis_aclk,
		input wire  s00_axis_aresetn,
		output wire  s00_axis_tready,
		input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
		input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
		input wire  s00_axis_tlast,
		input wire  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready
	);
	
	//User AXI-LITE register value_wire
	wire [31:0] w_reg0, w_reg1, w_reg2, w_reg3;
    wire [C_S00_AXI_DATA_WIDTH-1:0] w_pl_status;
	
// Instantiation of Axi Bus Interface S00_AXI
// Users output register port o_reg0~3
	layernorm_axi_wrapper_slave_lite_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) layernorm_axi_wrapper_slave_lite_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		.o_reg0(w_reg0),
        .o_reg1(w_reg1),
        .o_reg2(w_reg2),
        .o_reg3(w_reg3),
        .i_pl_status(w_pl_status)
	);
	
	// Users output register port o_reg0~3
	wire [1 : 0 ]  cmd;
	//wire [1 : 0 ]  PL_statue =   
	wire           [MODEL_DIMENSION_WIDTH-1 : 0]    w_d_model;
    wire   signed  [SHIFT_VALUE_DATA_WIDTH-1 : 0]   w_shift_value;
    wire   signed  [FRAC_WIDTH-1 : 0]              w_mult_value;
    
    assign cmd              = w_reg0[ 1:0];
    assign  w_d_model       = w_reg2[MODEL_DIMENSION_WIDTH-1 : 0];
	assign  w_shift_value   = $signed(w_reg3[SHIFT_VALUE_DATA_WIDTH+FRAC_WIDTH-1 : FRAC_WIDTH]);
	assign w_mult_value     = $signed(w_reg3[FRAC_WIDTH-1 : 0]);

	

//// Instantiation of Axi Bus Interface S00_AXIS
//	layernorm_axi_wrapper_slave_stream_v1_0_S00_AXIS # ( 
//		.C_S_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH)
//	) layernorm_axi_wrapper_slave_stream_v1_0_S00_AXIS_inst (
//		.S_AXIS_ACLK(s00_axis_aclk),
//		.S_AXIS_ARESETN(s00_axis_aresetn),
//		.S_AXIS_TREADY(s00_axis_tready),
//		.S_AXIS_TDATA(s00_axis_tdata),
//		.S_AXIS_TSTRB(s00_axis_tstrb),
//		.S_AXIS_TLAST(s00_axis_tlast),
//		.S_AXIS_TVALID(s00_axis_tvalid)
//	);

//// Instantiation of Axi Bus Interface M00_AXIS
//	layernorm_axi_wrapper_master_stream_v1_0_M00_AXIS # ( 
//		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
//		.C_M_START_COUNT(C_M00_AXIS_START_COUNT)
//	) layernorm_axi_wrapper_master_stream_v1_0_M00_AXIS_inst (
//		.M_AXIS_ACLK(m00_axis_aclk),
//		.M_AXIS_ARESETN(m00_axis_aresetn),
//		.M_AXIS_TVALID(m00_axis_tvalid),
//		.M_AXIS_TDATA(m00_axis_tdata),
//		.M_AXIS_TSTRB(m00_axis_tstrb),
//		.M_AXIS_TLAST(m00_axis_tlast),
//		.M_AXIS_TREADY(m00_axis_tready)
//	);

	// Add user logic here
	wire [C_S00_AXIS_TDATA_WIDTH-1:0] w_mean, w_invsqrt;

	reg  [C_S00_AXIS_TDATA_WIDTH-1:0] r_mean;      // iter1 intermediate
    reg  [C_S00_AXIS_TDATA_WIDTH-1:0] r_invsqrt;   // iter1 intermediate
    
    wire w_calc_done;
    wire w_calc_ready;
    wire w_norm_o_s_ready;
    wire w_norm_o_m_valid ;
    wire w_norm_last;
    
     //FSM
    // IDLE → ITER1 → STORE → WAIT_ITER2 → ITER2 → IDLE
    localparam  IDLE        = 3'b000;
    localparam  ITER1       = 3'b001;
    localparam  STORE       = 3'b010;
    localparam  WAIT_ITER2  = 3'b011;
    localparam  ITER2       = 3'b100;
    
    reg [2:0] c_state , n_state ;
    
    // AXI lite register_1 write
    
    assign w_pl_status = (c_state == IDLE)       ? 32'd0 :  // idle
                         (c_state == WAIT_ITER2) ? 32'd1 :  // iter1 done and wait iteration2
                         (c_state == ITER2)      ? 32'd2 :  // computing
                         32'd9;  

    
    
    always @(*)begin //n_state update
        n_state = c_state;

    case (c_state)
        IDLE: begin
            if (cmd == 2'd1)
                n_state = ITER1;
        end

        ITER1: begin
            if (w_calc_done)
                n_state = STORE;
        end

        STORE: begin
            n_state = WAIT_ITER2;
        end

        WAIT_ITER2: begin
            if (cmd == 2'd2)
                n_state = ITER2;
        end

        ITER2: begin
            //!!
            if (m00_axis_tvalid && m00_axis_tready && m00_axis_tlast) //마지막 "transfer" 끝나고 진짜 downstream으로 전달된 순간 IDLE로
                n_state = IDLE; 
        end
        
        default: begin
            n_state = (cmd == 2'd0)? IDLE : c_state;
        end
        
    
 
    
    endcase

    
    end
    
    always @(posedge s00_axi_aclk) begin
        if ( ! s00_axi_aresetn ) begin
            c_state     <= IDLE;
            r_mean      <= {(C_S00_AXIS_TDATA_WIDTH){1'b0}};
            r_invsqrt   <= {(C_S00_AXIS_TDATA_WIDTH){1'b0}};
          end
          
          else begin
             c_state <= n_state;
             
             if (c_state == ITER1 && w_calc_done) begin
                r_mean <= w_mean;
                r_invsqrt <= w_invsqrt;
               end

         end
	 end
    
    //assign s00_axis_tready  = iteration1일때는 w_calc_ready , iteration2일때는 w_norm_o_s_ready;
    // ─── AXI-Stream slave ready (output) 
    assign s00_axis_tready = (c_state == ITER1) ? w_calc_ready :
                             (c_state == ITER2) ? w_norm_o_s_ready :
                               1'b0;
                         
    assign m00_axis_tvalid = (c_state == ITER2) && w_norm_o_m_valid;
    assign m00_axis_tlast  = (c_state == ITER2) && w_norm_last;
    assign m00_axis_tstrb  = {(C_M00_AXIS_TDATA_WIDTH/8){1'b1}}; //m_axis_data all byte is active
    
    
    
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
        
    ) u_calculator (
    .i_clk      (s00_axi_aclk),
    .i_reset    (~s00_axi_aresetn),
    .i_s_valid  (s00_axis_tvalid & (c_state == ITER1)),
    .o_s_ready  (w_calc_ready),
    .i_m_ready  (1'b1),//output is register , no backpressure
    .o_m_valid  (w_calc_done),
    .i_data     (s00_axis_tdata),
    .o_mean     (w_mean),
    .o_invsqrt  (w_invsqrt),
    .i_d_model  (w_d_model),
    .i_shift_value(w_shift_value),
    .i_mult_value (w_mult_value)
);


    top_normalization #(
        .MODULE_NUM (MODULE_NUM),
    .DATA_WIDTH (DATA_WIDTH)
    )
    u_normalization (
    .i_clk      (s00_axi_aclk),
    .i_reset    (~s00_axi_aresetn),
    .i_s_valid  (s00_axis_tvalid & (c_state == ITER2)),
    .o_s_ready  (w_norm_o_s_ready),
    .i_m_ready  (m00_axis_tready),//output is DMA. need backpressure
    .o_m_valid  (w_norm_o_m_valid),
    .i_mean     (r_mean),
    .i_invsqrt  (r_invsqrt),
    .i_data     (s00_axis_tdata),
    .o_data     (m00_axis_tdata),
    .i_data_last (s00_axis_tlast),
    .o_data_last (w_norm_last)
);
    
                     


    
    
	// User logic ends

	endmodule
