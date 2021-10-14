/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module time_counter_verilog_tb;
    reg        enable,clk;
    wire [3:0] my_counter;
    time_counter_verilog tc (enable,clk,my_counter);
    initial begin
             enable = 0;
             clk    = 1;
        #3   enable = 1;
        #8   enable = 0;
        #2   enable = 1;
        #800 $finish;
    end
    always #1 clk = !clk;
endmodule
