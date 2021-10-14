/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module wallace_26x26_product_tb;
    reg  [25:00] a;
    reg  [25:00] b;
    reg  [51:00] y;
    wire [51:00] z;
    wallace_26x26_product test (a,b,z);
    initial begin
            a = 26'h3ffffff;
            b = 26'h3ffffff;
            y = a * b;
        #10 $finish;
    end
endmodule
