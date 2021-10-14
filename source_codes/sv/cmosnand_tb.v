/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module cmosnand_tb;
    reg  a,b;
    wire f;
    cmosnand not_and (f,a,b);
    initial begin
        a = 0;
        b = 0;
    end
    always #1 a = !a;
    always #2 b = !b;
endmodule
