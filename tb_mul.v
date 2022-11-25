`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2022 05:11:53 AM
// Design Name: 
// Module Name: tb_mul
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


module tb_mul();

    reg             bus_clk;
    reg             a_valid;
    wire             a_ready;
    reg             b_valid;
    wire             b_ready;
    reg    [31:0]   adder_a_tdata;
    reg    [31:0]   adder_b_tdata;
    wire             result_valid;
    reg             result_ready; 
    wire    [31:0]   fifo_fpga_to_host_din;
    
    floating_point_mul_1 DUT5(
        .aclk(bus_clk),
        .s_axis_a_tvalid(a_valid),
        .s_axis_a_tready(a_ready),
        .s_axis_a_tdata(adder_a_tdata),
        .s_axis_b_tvalid(b_valid),
        .s_axis_b_tready(b_ready),
        .s_axis_b_tdata(adder_b_tdata),
        .m_axis_result_tvalid(result_valid),
        .m_axis_result_tready(result_ready),
        .m_axis_result_tdata(fifo_fpga_to_host_din)
    );
        integer i;
    initial begin 
        bus_clk = 1'b0;
        a_valid = 1'b0;
        result_ready = 1'b1;
        b_valid = 1'b0; 
        //b_ready = 1'b0; 
        adder_a_tdata = 32'b00111111100110011001100110011010;
        adder_b_tdata = 32'b00111111100110011001100110011010;
        
        #20;
        a_valid = 1'b1;
        result_ready = 1'b1;
        b_valid = 1'b0; 
        //b_ready = 1'b1; 
        adder_a_tdata = 32'b00111111100110011001100110011010;
        adder_b_tdata = 32'b00111111100110011001100110011010;
         
        #10;
         a_valid = 1'b1;        
        b_valid = 1'b1; 
        result_ready = 1'b1;
        //b_ready = 1'b1; 
        adder_a_tdata = 32'b00111111100110011001100110011010;
        adder_b_tdata = 32'b00111111100110011001100110011010;
         
        #20;
        a_valid = 1'b1;
        result_ready = 1'b1;
        b_valid = 1'b1; 
        //b_ready = 1'b1; 
        adder_a_tdata = 32'b00111111100110011001100110011010;
        adder_b_tdata = 32'b00111111100110011001100110011010;
         
        #20;
        a_valid = 1'b1;
        result_ready = 1'b1;
        b_valid = 1'b0; 
        //b_ready = 1'b1; 
        adder_a_tdata = 32'b00111111100110011001100110011010;
        adder_b_tdata = 32'b00111111100110011001100110011010;
        
        #20;
        
        a_valid = 1'b0;
        result_ready = 1'b1;
        b_valid = 1'b0; 
        //b_ready = 1'b1; 
            adder_b_tdata = 32'b00111111100110011001100110011010;   
        adder_a_tdata = 32'b00111111100110011001100110011010;
        #20;
        a_valid = 1'b1;
        result_ready = 1'b1;
        b_valid = 1'b1; 
        //b_ready = 1'b1; 
        adder_a_tdata = 32'b00111111100110011001100110011010;
        adder_b_tdata = 32'b00111111100110011001100110011010;
        #40;
        for (i=0; i<126; i=i+1) begin
            a_valid = 1'b1;
            result_ready = 1'b1;
            b_valid = 1'b1; 
            //b_ready = 1'b1;  
            adder_a_tdata = 32'd1 + i;
            adder_b_tdata = 32'd2 + i;

            #40;
        end
        a_valid = 1'b0;
        result_ready = 1'b1;
        b_valid = 1'b0; 
        //b_ready = 1'b1;  
        adder_a_tdata = 32'b00111111100110011001100110011010;
        adder_b_tdata = 32'b00111111100110011001100110011010; 
        #120;
        a_valid = 1'b1;
        result_ready = 1'b1;
        b_valid = 1'b1; 
        //b_ready = 1'b1; 
        adder_a_tdata = 32'b00111111100110011001100110011010;
        adder_b_tdata = 32'b00111111100110011001100110011010; 
        #40;
 
        #200;
        $finish;
    end
    
    always begin
        #5 bus_clk = ~bus_clk;
    end
endmodule
