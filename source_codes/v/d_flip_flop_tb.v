/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module d_flip_flop_tb;
    reg  clk,d;
    wire q,qn;
    d_flip_flop dff (clk,d,q,qn);
    initial begin
           clk = 0;
           d   = 0;
        #2 d   = 1;
        #2 d   = 0;
        #2 d   = 1;
        #2 d   = 0;
        #1 d   = 1;
        #2 d   = 0;
        #3 d   = 1;
        #2 d   = 0;
        #2 d   = 1;
        #1 d   = 0;
        #2 d   = 1;
        #3 d   = 0;
        #6 $finish;
    end
    always #5 clk = !clk;
endmodule
