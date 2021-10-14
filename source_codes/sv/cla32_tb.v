/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module cla32_tb;
    reg  [31:0] a,b;
    reg         ci;
    wire [31:0] s;
    cla32 adder (a,b,ci,s);
    initial begin
            a  = 32'h77777777;
            b  = 32'hffffffff;
            ci = 0;
        #10 a  = 32'haaaaaaaa;
            b  = 32'h55555555;
        #10 a  = 32'hcccccccc;
            b  = 32'hcccccccc;
        #10 a  = 32'h00000000;
            b  = 32'h00000000;
    end
    always #5 ci = !ci;
endmodule
