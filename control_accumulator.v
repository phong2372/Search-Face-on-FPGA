`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2022 04:38:10 AM
// Design Name: 
// Module Name: control_accumulator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2022 03:31:09 PM
// Design Name: 
// Module Name: sum
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module control_accumlator(
    input   wire    bus_clk,
    input   wire    rst,
    output  wire    fifo_host_to_fpga_rden_1st, 
    input   wire    fifo_host_to_fpga_empty_1st,
    output  wire    fifo_host_to_fpga_rden_2nd, 
    input   wire    fifo_host_to_fpga_empty_2nd,
    output  wire    fifo_fpga_to_host_wren, 
    input   wire    fifo_fpga_to_host_full,    
    output  wire    a_valid,
    input   wire    a_ready,
    // output  wire    b_valid,
    // input   wire    b_ready,
    input   wire    result_valid,
    output  wire    result_ready,
    output  wire    fifo_selector,
    output  wire    a_selector,
    // output  wire    sum_reg_en,
    output  wire    waiting_frame_en,
    output  wire    a_last,
    input  wire     result_last
    );
    // Finite-state-machine
    localparam read_fifo_state  = 3'd0;
    localparam adding_state     = 3'd1;
    localparam reconfig_state   = 3'd2;
    localparam write_fifo_state = 3'd3;
    localparam waiting_state    = 3'd4;

    reg     [2:0]   state;
    wire    [2:0]   next_state;
    reg     [7:0]   frame_cnt;
    reg             fifo_selector_reg;
    wire            counter_rst, counter_en, reconfig;
    wire            empty_singal;
    
    assign fifo_selector = fifo_selector_reg;
    assign empty_singal = (fifo_selector == 1'b0) ? fifo_host_to_fpga_empty_1st : fifo_host_to_fpga_empty_2nd;

    // frame_counter
    always @(posedge bus_clk) begin
        if (rst || counter_rst)
            frame_cnt <= 8'd0;
        else if (counter_en)
            frame_cnt <= frame_cnt + 8'd1;
    end
    
    // fifo selector register
    always @(posedge bus_clk) begin
        if (rst)
            fifo_selector_reg <= 1'd0;
        else if (reconfig)
            fifo_selector_reg <= 1'd1;
    end

    // current state
    always @(posedge bus_clk) begin
        if (rst)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // next state
    assign next_state = (state == read_fifo_state) ? 
                            (empty_singal) ? read_fifo_state :
                            (!a_ready /*|| !b_ready*/) ? waiting_state :
                            adding_state :
                        (state == adding_state) ?
                            (frame_cnt < 127) ? read_fifo_state :
                            (fifo_selector == 1'b0) ? reconfig_state:
                            write_fifo_state :
                        (state == reconfig_state) ? read_fifo_state :
                        (state == write_fifo_state) ? 
                            (fifo_fpga_to_host_full || result_last == 1'b0) ? write_fifo_state : 
                            read_fifo_state :
                        (state == waiting_state) ? 
                            (!a_ready /*|| !b_ready*/) ? waiting_state :
                            adding_state : 3'bx;

   assign fifo_host_to_fpga_rden_1st    = (fifo_selector == 1'b0 && state == read_fifo_state) ? 1'b1 : 1'b0;
   assign fifo_host_to_fpga_rden_2nd    = (fifo_selector == 1'b1 && state == read_fifo_state) ? 1'b1 : 1'b0;
   assign fifo_fpga_to_host_wren        = (state == write_fifo_state && result_last == 1'b1) ? 1'b1 : 1'b0;
   assign a_valid                       = (state == adding_state) ? 1'b1 : 1'b0;
//    assign b_valid                       = (state == adding_state) ? 1'b1 : 1'b0;
   assign result_ready                  = (state == reconfig_state) ? 1'b0 : 1'b1;
   assign a_selector                    = (state == waiting_state) ? 1'b1 : 1'b0;
//    assign sum_reg_en                    = result_valid && result_ready;
   assign reconfig                      = (state == reconfig_state) ? 1'b1 : 1'b0;
   assign waiting_frame_en              = (state == waiting_state) ? 1'b1 : 1'b0;
   assign counter_en                    = (state == adding_state) ? 1'b1 : 1'b0;
   assign counter_rst                   = (state == reconfig_state || state == write_fifo_state) ? 1'b1 : 1'b0;
   assign a_last                        = (state == adding_state && frame_cnt == 127 && fifo_selector == 1'b1) ? 1'b1 : 1'b0;

endmodule

module sum(
    input   wire            bus_clk,
    input   wire            rst,
    output  wire            fifo_host_to_fpga_rden_1st, 
    input   wire            fifo_host_to_fpga_empty_1st,
    output  wire            fifo_host_to_fpga_rden_2nd, 
    input   wire            fifo_host_to_fpga_empty_2nd,
    output  wire            fifo_fpga_to_host_wren, 
    input   wire            fifo_fpga_to_host_full,
    input   wire    [31:0]  fifo_host_to_fpga_dout_1st,
    input   wire    [31:0]  fifo_host_to_fpga_dout_2nd,
    output  wire    [31:0]  fifo_fpga_to_host_din
    );
    
    reg  [31:0] sum_reg, waiting_frame;
    wire [31:0] /*adder_result_data,*/ fifo_data, adder_a_tdata;
    wire a_valid, /* b_valid, */ a_ready, /* b_ready, */ result_ready, result_valid, a_last, result_last;
    wire fifo_selector, a_selector, sum_reg_en, waiting_frame_en;

    // assign fifo_fpga_to_host_din = sum_reg;
    assign fifo_data = (fifo_selector == 1'b0) ? fifo_host_to_fpga_dout_1st : fifo_host_to_fpga_dout_2nd;
    assign adder_a_tdata = (a_selector == 1'b0) ? fifo_data : waiting_frame;

    controller control_path(
        .bus_clk(bus_clk),
        .rst(rst),
        .fifo_host_to_fpga_rden_1st(fifo_host_to_fpga_rden_1st), 
        .fifo_host_to_fpga_empty_1st(fifo_host_to_fpga_empty_1st),
        .fifo_host_to_fpga_rden_2nd(fifo_host_to_fpga_rden_2nd), 
        .fifo_host_to_fpga_empty_2nd(fifo_host_to_fpga_empty_2nd),
        .fifo_fpga_to_host_wren(fifo_fpga_to_host_wren), 
        .fifo_fpga_to_host_full(fifo_fpga_to_host_full),    
        .a_valid(a_valid),
        .a_ready(a_ready),
        // .b_valid(b_valid),
        // .b_ready(b_ready),
        .result_valid(result_valid),
        .result_ready(result_ready),
        .fifo_selector(fifo_selector),
        .a_selector(a_selector),
        // .sum_reg_en(sum_reg_en),
        .waiting_frame_en(waiting_frame_en),
        .a_last(a_last),
        .result_last(result_last)
    );

    always @(posedge bus_clk) begin
        if (rst)
            waiting_frame <= 32'd0;
        else if (waiting_frame_en)
            waiting_frame <= fifo_data;
    end
    /*cosine (
        clk, en, rst_n, valid_in, start, ina, inb, size , cosine_done, cosine_out
    );*/
    floating_point_0 accumulator(
        .aclk(bus_clk),
        .s_axis_a_tvalid(a_valid),
        .s_axis_a_tready(a_ready),
        .s_axis_a_tdata(adder_a_tdata),
        .s_axis_a_tlast(a_last),
        .m_axis_result_tvalid(result_valid),
        .m_axis_result_tready(result_ready),
        .m_axis_result_tdata(fifo_fpga_to_host_din),
        .m_axis_result_tlast(result_last)
    );
endmodule
