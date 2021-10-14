/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module goldschmidt_tb;
    reg  [31:0] a;
    reg  [31:0] b;
    reg         start;
    reg         clk,clrn;
    wire [31:0] q;
    wire        busy;
    wire        ready;
    wire  [2:0] count;
    wire [31:0] yn;
    goldschmidt div (a,b,start,clk,clrn,q,busy,ready,count,yn);
    initial begin
            clrn  = 0;
            start = 0;
            clk   = 1;
            a     = 32'hc0000000;
            b     = 32'h80000000;
        #25 clrn  = 1;
            start = 1;
        #50 start = 0;
    end
    always #25 clk = !clk;
endmodule
