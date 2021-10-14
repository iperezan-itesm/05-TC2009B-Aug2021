/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module pipelinedcpu_tb;
    reg         clk,clrn;
    wire [31:0] pc,inst,ealu,malu,wdi;
    pipelinedcpu cpu (clk,clrn,pc,inst,ealu,malu,wdi);
    initial begin
             clrn = 0;
             clk  = 1;
        #1   clrn = 1;
        #335 $finish;
    end
    always #2 clk = !clk;
endmodule
/*
   0 -  28
  92 - 120
 120 - 148
*/
