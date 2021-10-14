/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module fmul_tb;
    reg  [31:0] a, b;
    reg   [1:0] rm;
    wire [31:0] s;
    fmul fm (a,b,rm,s);
    initial begin
            rm = 0;
            a  = 32'h3fc00000;
            b  = 32'h3fc00000;
        #10 a  = 32'h00800000;
            b  = 32'h00800000;
        #10 a  = 32'h7f7fffff;
            b  = 32'h7f7fffff;
        #10 a  = 32'h00800000;
            b  = 32'h3f000000;
        #10 a  = 32'h003fffff;
            b  = 32'h40000000;
        #10 a  = 32'h7f800000;
            b  = 32'h00ffffff;
        #10 a  = 32'h7f800000;
            b  = 32'h00000000;
        #10 a  = 32'h7ff000ff;
            b  = 32'h3f80ff00;
    end
endmodule
