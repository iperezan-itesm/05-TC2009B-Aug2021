/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module sc_interrupt_tb;
    reg         clk,clrn,memclk,intr;
    wire [31:0] inst,pc,aluout,memout;
    wire        inta;
    sc_interrupt scint (clk,clrn,inst,pc,aluout,memout,memclk,intr,inta);
    initial begin
             clrn   = 0;
             memclk = 0;
             clk    = 1;
             intr   = 0;
        #5   clrn   = 1;
        #945 intr   = 1;
        #20  intr   = 0;
        #600 $finish;
    end
    always #5  memclk = !memclk;
    always #10 clk  = !clk;
endmodule
/*
1   0-140
2 140-280
3 280-420
4 420-560
5 560-700
6 700-840
7 840-980
8 980-1120
*/
