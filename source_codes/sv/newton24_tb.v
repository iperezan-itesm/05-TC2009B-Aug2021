/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module newton24_tb;
    reg  [23:0] a;
    reg  [23:0] b;
    reg         fdiv;
    reg         clk,clrn;
    reg         ena;
    wire [31:0] q;
    wire        busy;
    wire  [4:0] count;
    wire [25:0] reg_x;
    wire        stall;
    newton24 n24 (a,b,fdiv,ena,clk,clrn,q,busy,count,reg_x,stall); 
    wire [23:0] q24 = q[31:8] + |q[7:0];
    initial begin
             clrn = 0;
             clk  = 1;
             ena  = 1;
             fdiv = 0;
             a    = 24'hc00000;
             b    = 24'h800000;
        #1   clrn = 1;
        #14  fdiv = 1;
        #154 fdiv = 0;
    end
    always #5 clk = !clk;
endmodule
