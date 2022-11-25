`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2022 04:01:10 AM
// Design Name: 
// Module Name: tb_mac
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


module tb_mac ();


    reg             bus_clk;
    reg             rst;
    reg             fifo_host_to_fpga_empty_1st;
    reg             fifo_host_to_fpga_empty_2nd;
    reg             fifo_fpga_to_host_full;
    reg    [31:0]   fifo_host_to_fpga_dout_1st;
    reg    [31:0]   fifo_host_to_fpga_dout_2nd;
    wire             fifo_host_to_fpga_rden_1st;
    wire             fifo_fpga_to_host_wren; 
    wire             fifo_host_to_fpga_rden_2nd;
    wire    [31:0]   fifo_fpga_to_host_din;
    
    mac_module DUT1(
    .bus_clk(bus_clk),
    .rst(rst),
    .fifo_host_to_fpga_rden_1st(fifo_host_to_fpga_rden_1st), 
    .fifo_host_to_fpga_empty_1st(fifo_host_to_fpga_empty_1st),
    .fifo_host_to_fpga_rden_2nd(fifo_host_to_fpga_rden_2nd), 
    .fifo_host_to_fpga_empty_2nd(fifo_host_to_fpga_empty_2nd),
    .fifo_fpga_to_host_wren(fifo_fpga_to_host_wren), 
    .fifo_fpga_to_host_full(fifo_fpga_to_host_full),
    .fifo_host_to_fpga_dout_1st(fifo_host_to_fpga_dout_1st),
    .fifo_host_to_fpga_dout_2nd(fifo_host_to_fpga_dout_2nd),
    .fifo_fpga_to_host_din(fifo_fpga_to_host_din)
    );
    integer i;
    initial begin 
        bus_clk = 1'b0;
        rst = 1'b0;
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0; 
        fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010;
        fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000;
        
        #20;
        rst = 1'b1;
        fifo_host_to_fpga_empty_1st = 1'b1;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0; 
        fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010;
        fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000;
         
        #20;
        rst = 1'b0;
        fifo_host_to_fpga_empty_1st = 1'b1;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0; 
        fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010;
        fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000;
         
        #40;
        rst = 1'b0;
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b1;
        fifo_fpga_to_host_full = 1'b0; 
        fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010;
        fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000;
         
        #40;
        fifo_host_to_fpga_empty_1st = 1'b1;
        fifo_host_to_fpga_empty_2nd = 1'b1;
        fifo_fpga_to_host_full = 1'b0; 
        fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010;
        fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000;
        
        #40;
        
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0; 
        fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010;
        fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000;
         
        #40;
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0; 
        fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010;
        fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000;
         
        #40;
        for (i=0; i<126; i=i+1) begin
            fifo_host_to_fpga_empty_1st = 1'b0;
            fifo_host_to_fpga_empty_2nd = 1'b0;
            fifo_fpga_to_host_full = 1'b0; 
            fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010*i;
            fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000*i;
                   
            #40;
        end
        fifo_host_to_fpga_empty_1st = 1'b0;
        fifo_host_to_fpga_empty_2nd = 1'b0;
        fifo_fpga_to_host_full = 1'b0; 
        fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010;
        fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000;
        #120;
        fifo_host_to_fpga_empty_1st = 32'b00111111110000000000000000000000;
        fifo_host_to_fpga_empty_2nd = 32'b00111111100110011001100110011010;
        fifo_fpga_to_host_full = 1'b1; 
        fifo_host_to_fpga_dout_1st = 32'b00111111100110011001100110011010;
        fifo_host_to_fpga_dout_2nd = 32'b00111111110000000000000000000000;
        #40;
 
        #200;
        $finish;
    end
    
    always begin
        #10 bus_clk = ~bus_clk;
    end
    
endmodule 

