`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2022 12:01:58 AM
// Design Name: 
// Module Name: tb_controller
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


module tb_controller ();


    reg     bus_clk;
    reg    rst;
    wire    fifo_host_to_fpga_rden_1st; 
    reg    fifo_host_to_fpga_empty_1st;
    wire    fifo_host_to_fpga_rden_2nd; 
    reg    fifo_host_to_fpga_empty_2nd;
    wire    fifo_fpga_to_host_wren;
    reg    fifo_fpga_to_host_full;   
    wire    a_valid;
    reg    a_ready;
    wire    b_valid;
    reg    b_ready;
    reg    result_valid;
    wire    result_ready;
    wire    fifo_selector;
    wire    a_selector;
    wire    waiting_frame_en;
    
    controller DUT(
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
        .b_valid(b_valid),
        .b_ready(b_ready),
        .result_valid(result_valid),
        .result_ready(result_ready),
        .fifo_selector(fifo_selector),
        .a_selector(a_selector),
        .waiting_frame_en(waiting_frame_en)
    );
    integer i;
    initial begin 
        bus_clk = 1'b0;
        rst = 1'b0;
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0;
        a_ready = 1'b0;
        b_ready = 1'b0;
        result_valid = 1'b0;
        #20;
        rst = 1'b1;
        fifo_host_to_fpga_empty_1st = 1'b1;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0;
        a_ready = 1'b0;
        b_ready = 1'b0;
        result_valid = 1'b0;
        #20;
        rst = 1'b0;
        fifo_host_to_fpga_empty_1st = 1'b1;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0;
        a_ready = 1'b0;
        b_ready = 1'b0;
        result_valid = 1'b0;
        #40;
        rst = 1'b0;
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b1;
        fifo_fpga_to_host_full = 1'b0;
        a_ready = 1'b0;
        b_ready = 1'b0;
        result_valid = 1'b0;
        #40;
        fifo_host_to_fpga_empty_1st = 1'b1;
        fifo_host_to_fpga_empty_2nd = 1'b1;
        fifo_fpga_to_host_full = 1'b0;
        a_ready = 1'b0;
        b_ready = 1'b1;
        result_valid = 1'b0;   
        #40;
        
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0;
        a_ready = 1'b1;
        b_ready = 1'b0;
        result_valid = 1'b0;
        #40;
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0;
        a_ready = 1'b0;
        b_ready = 1'b0;
        result_valid = 1'b0;   
        #40;
        for (i=0; i<126; i=i+1) begin
            fifo_host_to_fpga_empty_1st = 1'b0;
            fifo_host_to_fpga_empty_2nd = 1'b0;
            fifo_fpga_to_host_full = 1'b0;
            a_ready = 1'b1;
            b_ready = 1'b1;
            result_valid = 1'b0;       
            #40;
        end
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0;
        a_ready = 1'b1;
        b_ready = 1'b1;
        result_valid = 1'b1;  
        #120;
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0;
        a_ready = 1'b1;
        b_ready = 1'b1;
        result_valid = 1'b1; 
        #40;
 
        #200;
        $finish;
    end
    
    always begin
        #10 bus_clk = ~bus_clk;
    end
    
endmodule 
