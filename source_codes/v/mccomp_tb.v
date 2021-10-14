/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module mccomp_tb;
    reg         clk,clrn,memclk;
    wire [31:0] a,b,alu,adr,tom,fromm,pc,ir;
    wire  [2:0] q;
    mccomp cpu (clk,clrn,q,a,b,alu,adr,tom,fromm,pc,ir,memclk);
    initial begin
              clrn   = 0;
              memclk = 0;
              clk    = 1;
        #1    clrn   = 1;
        #1099 $finish;
    end
    always #1 memclk = !memclk;
    always #2 clk  = !clk;
endmodule
/*
   0 -  28
  40 -  68
  68 -  96
 408 - 436
*/
