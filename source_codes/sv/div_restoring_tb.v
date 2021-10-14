/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module div_restoring_tb;
    reg  [31:0] a;
    reg  [15:0] b;
    reg         start;
    reg         clk,clrn;
    wire [31:0] q;
    wire [15:0] r;
    wire        busy;
    wire        ready;
    wire  [4:0] count;
    div_restoring div (a,b,start,clk,clrn,q,r,busy,ready,count);
    initial begin
             clrn  = 0;
             start = 0;
             clk   = 1;
             a     = 32'h4c7f228a;
             b     = 16'h6a0e;
        #5   clrn  = 1;
             start = 1;
        #10  start = 0;
        #320 start = 1;
        #5   a     = 32'h00ffff00;
             b     = 16'h0004;
        #5   start = 0;
    end
    always #5 clk = !clk;
endmodule
