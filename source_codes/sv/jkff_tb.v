/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module jkff_tb;
    reg  j, k, clk, clrn;
    wire q;
    jkff jk_ff (j,k,clk,clrn,q);
    initial begin
           clk  = 1;
           clrn = 0;
           j    = 0;
           k    = 0;
        #1 clrn = 1;
           k    = 1;
        #2 k    = 0;
           j    = 1;
        #2 j    = 0;
        #2 k    = 1;
           j    = 1;
        #8 k    = 0;
           j    = 0;
        #2 $finish; 
    end
    always #1 clk = !clk;
endmodule
