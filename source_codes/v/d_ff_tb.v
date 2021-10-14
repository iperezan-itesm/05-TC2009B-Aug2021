/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module d_ff_tb;
    reg  prn,clk,d,clrn;
    wire q,qn;
    d_ff dff (prn,clk,d,clrn,q,qn);
    initial begin
           clk  = 0;
           prn  = 1;
           clrn = 0;
           d    = 0;
        #1 clrn = 1;
        #1 prn  = 0;
           d    = 1;
        #1 prn  = 1;
        #1 d    = 0;
        #2 d    = 1;
        #2 d    = 0;
        #1 d    = 1;
        #2 d    = 0;
        #3 d    = 1;
        #2 d    = 0;
        #2 d    = 1;
        #1 d    = 0;
        #2 d    = 1;
        #3 d    = 0;
        #6 $finish; 
    end
    always #5 clk = !clk;
endmodule
