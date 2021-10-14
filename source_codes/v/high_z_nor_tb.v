/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module high_z_nor_tb;
    reg  in1, in2, in3;
    wire out1;
    high_z_nor hz (in1,in2,in3,out1);
    initial begin
        #0 in1 = 0; in2 = 0; in3 = 0;
        #1 in1 = 1; in2 = 0; in3 = 0;
        #1 in1 = 0; in2 = 1; in3 = 0;
        #1 in1 = 1; in2 = 1; in3 = 0;
        #1 in1 = 0; in2 = 0; in3 = 1;
        #1 in1 = 1; in2 = 0; in3 = 1;
        #1 in1 = 0; in2 = 1; in3 = 1;
        #1 in1 = 1; in2 = 1; in3 = 1;
        #1 in1 = 0; in2 = 0; in3 = 0;
        #1 $finish;
    end
endmodule
