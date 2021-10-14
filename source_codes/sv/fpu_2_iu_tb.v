/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module fpu_2_iu_tb;
    reg  clk,memclk,clrn;
    wire [31:0] pc0,inst0,ealu0,malu0,walu0;
    wire [31:0] pc1,inst1,ealu1,malu1,walu1;
    wire ww0,stl_lw0,stl_lwc10,stl_swc10,stl_fp0,stall0,st0;
    wire ww1,stl_lw1,stl_lwc11,stl_swc11,stl_fp1,stall1,st1;
    wire e;
    wire [31:0] e3d,wd;
    wire [4:0] e1n,e2n,e3n,wn;
    wire [4:0] cnt_div,cnt_sqrt;
    fpu_2_iu cpu (clrn,memclk,clk,
                  pc0,inst0,ealu0,malu0,walu0,ww0,
                  stl_lw0,stl_lwc10,stl_swc10,stl_fp0,stall0,st0,
                  pc1,inst1,ealu1,malu1,walu1,ww1,
                  stl_lw1,stl_lwc11,stl_swc11,stl_fp1,stall1,st1,
                  wn,wd,cnt_div,cnt_sqrt,e1n,e2n,e3n,e3d,e);
    initial begin
           clrn   = 0;
           memclk = 0;
           clk    = 1;
        #1 clrn   = 1;
    end
    always #1 memclk = !memclk;
    always #2 clk    = !clk;
endmodule
/*
  24 -  53 ns
 144 - 646 ns
*/
