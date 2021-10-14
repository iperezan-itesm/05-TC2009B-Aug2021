/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module fpu_1_iu_tb;
    reg         clk,memclk,clrn;
    wire [31:0] pc,inst,ealu,malu,walu;
    wire [31:0] e3d,wd;
    wire [4:0]  e1n,e2n,e3n,wn;
    wire        ww,stl_lw,stl_fp,stl_lwc1,stl_swc1,stl;
    wire        e;
    wire [4:0]  cnt_div,cnt_sqrt;
    fpu_1_iu cpu (clk,memclk,clrn,pc,inst,ealu,malu,walu,wn,
                  wd,ww,stl_lw,stl_fp,stl_lwc1,stl_swc1,
                  stl,cnt_div,cnt_sqrt,e1n,e2n,e3n,e3d,e);
    initial begin
           clrn   = 0;
           memclk = 0;
           clk    = 1;
        #1 clrn   = 1;
    end
    always #1 memclk = !memclk;
    always #2 clk  = !clk;
endmodule
/*
  24 -  52.001 ns
  48 -  76.001 ns
 128 - 412.000 ns
*/
