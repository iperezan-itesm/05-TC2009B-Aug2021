/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module add1_tb;
    reg  a,b,ci;
    wire co,s;
    add1 i1 (a,b,ci,s,co);
    initial begin
           a  = 0;
           b  = 0;
           ci = 0;
        #8 $finish;
    end
    always #4 a  = !a;
    always #2 b  = !b;
    always #1 ci = !ci;
endmodule
