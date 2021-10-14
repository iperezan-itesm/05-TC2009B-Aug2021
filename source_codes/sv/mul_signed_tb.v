/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module mul_signed_tb;
    reg   [7:0] a,b;
    wire [15:0] z;
    mul_signed m (a,b,z);
    initial begin
           a  = 8'hff;
           b  = 8'hff;
        #5 a  = 8'h7f;
           b  = 8'h7f;
        #5 a  = 8'h81;
           b  = 8'h81;
        #5 a  = 8'h7e;
           b  = 8'h7e;
        #5 a  = 8'h82;
           b  = 8'h82;
        #5 a  = 8'h7d;
           b  = 8'h7d;
        #5 a  = 8'h83;
           b  = 8'h83;
        #5 a  = 8'h7e;
           b  = 8'h81;
        #5 a  = 8'h82;
           b  = 8'h7d;
        #5 a  = 8'h00;
           b  = 8'h00;
        #5 a  = 8'h01;
           b  = 8'h01;
        #5 a  = 8'h02;
           b  = 8'h02;
        #5 a  = 8'h03;
           b  = 8'h03;
   end
endmodule
