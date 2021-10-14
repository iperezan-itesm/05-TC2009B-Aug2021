/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module wallace_24x24_product_tb;
    reg  [23:00] a;
    reg  [23:00] b;
    reg  [47:00] y;
    wire [47:00] z;
    wallace_24x24_product test (a, b, z);
    initial begin
        a = 24'hffffff;
        b = 24'hffffff;
        y = a * b;
        # 10 $finish;
    end
endmodule
