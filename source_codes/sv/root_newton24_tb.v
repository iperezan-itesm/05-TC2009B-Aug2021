/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module root_newton24_tb;
    reg  [23:0] d;
    reg         fsqrt;
    reg         clk,clrn;
    reg         ena;
    wire [31:0] q;
    wire        busy;
    wire        stall;
    wire  [4:0] count;
    wire [25:0] reg_x;
    root_newton24 rn24 (d,fsqrt,ena,clk,clrn,q,busy,count,reg_x,stall);
    wire [23:0] q24 = q[31:8] + |q[7:0];
    initial begin
             clrn  = 0;
             clk   = 1;
             ena   = 1;
             fsqrt = 0;
             d     = 24'hfffe00;
        #1   clrn  = 1;
        #14  fsqrt = 1;
        #214 fsqrt = 0;
    end
    always #5 clk = !clk;
endmodule
