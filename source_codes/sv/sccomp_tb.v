/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module sccomp_tb;
    reg         clk,clrn;
    wire [31:0] inst,pc,aluout,memout;
    sccomp cpu (clk,clrn,inst,pc,aluout,memout);
    initial begin
              clrn = 0;
              clk  = 1;
        #1    clrn = 1;
        #1399 $finish;
    end
    always #10 clk = !clk;
endmodule
/*
 1    0 -  140
 2  140 -  280
 3  280 -  420
 4  420 -  560
 5  560 -  700
 6  700 -  840
 7  840 -  980
 8  980 - 1120
 9 1120 - 1260
10 1260 - 1400
*/
