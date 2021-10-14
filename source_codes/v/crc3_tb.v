/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module crc3_tb;
    reg        clk,clrn;
    reg        m;
    wire [2:0] crc;
    crc3 crc_3 (clk,clrn,m,crc);
    initial begin
        clk   = 1;
        clrn  = 0;
        #1
        clrn  = 1;
            m = 1;
        #10 m = 1;
        #10 m = 0;
        #10 m = 0;
        #10 m = 0;
        #10 m = 1;
        #10 m = 0;
        #10 m = 1;
        #10 m = 1;
        #10 m = 1;
        #10 m = 1;
        #10 m = 1;
        #10 m = 0;
    end
    always #5 clk = !clk;
endmodule
