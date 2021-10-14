/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module i2f_tb;
    reg  [31:0] d;
    wire [31:0] a;
    wire        p_lost;
    i2f i_f (d,a,p_lost);
    initial begin
        #00 d = 32'h1fffffff;
        #10 d = 32'h00000001;
        #10 d = 32'h7fffff80;
        #10 d = 32'h7fffffc0;
        #10 d = 32'h80000000;
        #10 d = 32'h80000040;
        #10 d = 32'hffffffff;
        #10 d = 32'h00000000;
    end
endmodule
