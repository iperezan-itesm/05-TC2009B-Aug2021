/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module tff_tb;
    reg  t, clk, clrn;
    wire q;
    tff t_ff (t,clk,clrn,q);
    initial begin
            clk  = 1;
            clrn = 0;
            t    = 1;
        #1  clrn = 1;
        #2  t    = 0;
        #2  t    = 1;
        #10 t    = 0;
        #2  t    = 1;
        #6  $finish; 
    end
    always #1 clk = !clk;
endmodule
