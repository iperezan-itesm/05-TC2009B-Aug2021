/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module wallace_24x28_product_tb;
    reg  [23:00] a;
    reg  [27:00] b;
    reg  [51:00] y;
    wire [51:00] z;
    wallace_24x28_product test (a,b,z);
    initial begin
            a = 24'hffffff;
            b = 28'hfffffff;
            y = a * b;
        #10 $finish;
    end
endmodule
