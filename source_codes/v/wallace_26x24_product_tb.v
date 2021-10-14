/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module wallace_26x24_product_tb;
    reg  [25:00] b;
    reg  [23:00] a;
    reg  [49:00] y;
    wire [49:00] z;
    wallace_26x24_product test (a,b,z);
    initial begin
            b = 26'h3ffffff;
            a = 24'hffffff;
            y = a * b;
        #10 $finish;
    end
endmodule
