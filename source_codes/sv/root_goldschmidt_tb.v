/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module root_goldschmidt_tb;
    reg  [31:0] d;
    reg         start;
    reg         clk,clrn;
    wire [31:0] q;
    wire        busy;
    wire        ready;
    wire  [2:0] count;
    wire [31:0] xn;
    root_goldschmidt div (d,start,clk,clrn,q,busy,ready,count,xn);
    initial begin
             clrn  = 0;
             start = 0;
             clk   = 1;
             d     = 32'h40000000;
        #35  clrn  = 1;
             start = 1;
        #70  start = 0;
        #455 d     = 32'hc0000000;
        #35  start = 1;
        #70  start = 0;
        #455 d     = 32'hfffe0001;
        #35  start = 1;
        #70  start = 0;
    end
    always #35 clk = !clk;
endmodule
