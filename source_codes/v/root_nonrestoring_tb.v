/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module root_nonrestoring_tb;
    reg  [31:0] d;
    reg         load;
    reg         clk,clrn;
    wire [15:0] q;
    wire [16:0] r;
    wire        busy;
    wire        ready;
    wire  [3:0] count;
    root_nonrestoring rt (d,load,clk,clrn,q,r,busy,ready,count);
    initial begin
            clrn  = 0;
            load  = 0;
            clk   = 1;
            d = 32'hc0000000;
        #5  clrn  = 1;
            load  = 1;
        #10 load  = 0;
    end
    always #5 clk = !clk;
endmodule
