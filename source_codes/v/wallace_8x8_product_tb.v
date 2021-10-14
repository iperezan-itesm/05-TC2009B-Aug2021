/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module wallace_8x8_product_tb;
    reg  [07:00] a;
    reg  [07:00] b;
    wire [15:00] z;
    wallace_8x8_product test (a,b,z);
    initial begin
           a = 8'h00;
           b = 8'h01;
        #5 a = 8'hff;
           b = 8'h02;
        #5 b = 8'h04;
        #5 b = 8'h08;
        #5 b = 8'h10;
        #5 b = 8'h20;
        #5 b = 8'h40;
        #5 b = 8'hff;
        #5 $finish;
    end
endmodule
