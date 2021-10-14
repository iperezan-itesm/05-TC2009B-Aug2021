/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module vgac_tb;
    reg [23:0] d_in;
    reg        vga_clk;
    reg        clrn;
    wire [8:0] row_addr;
    wire [9:0] col_addr;
    wire [7:0] r,g,b;
    wire       rdn;
    wire       hs,vs;
    vgac monitor (vga_clk,clrn,d_in,row_addr,col_addr,rdn,r,g,b,hs,vs);
    initial begin
            vga_clk = 1;
            clrn    = 0;
            d_in    = 24'h55aaff;
        #10 clrn    = 1;
    end
    always #10 vga_clk = !vga_clk;
endmodule
/*
  562780 -  563000 ns
 8399900 - 8400120 ns
*/
