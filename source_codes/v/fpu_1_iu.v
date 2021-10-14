/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
// pipelined cpu with fpu, instruction memory, and data memory
module fpu_1_iu (clk,memclk,clrn,pc,inst,ealu,malu,walu,wn,wd,ww,stl_lw,
                 stl_fp,stl_lwc1,stl_swc1,stl,cnt_div,cnt_sqrt,
                 e1n,e2n,e3n,e3d,e);
    input         clk, memclk, clrn;               // clocks and reset
    output [31:0] pc, inst, ealu, malu, walu;
    output [31:0] e3d, wd;
    output  [4:0] e1n, e2n, e3n, wn;
    output        ww, stl_lw, stl_fp, stl_lwc1, stl_swc1, stl;
    output        e;                // for multithreading CPU, not used here
    output  [4:0] cnt_div, cnt_sqrt;               // for testing
    wire   [31:0] qfa,qfb,fa,fb,dfa,dfb,mmo,wmo;   // for iu
    wire    [4:0] fs,ft,fd,wrn; 
    wire    [2:0] fc;
    wire    [1:0] e1c,e2c,e3c;                     // for fpu
    wire          fwdla,fwdlb,fwdfa,fwdfb,wf,fasmds,e1w,e2w,e3w,wwfpr;
    iu i_u (e1n,e2n,e3n, e1w,e2w,e3w,stl,1'b0,     // st = 0
            dfb,e3d, clk,memclk,clrn,
            fs,ft,wmo,wrn,wwfpr,mmo,fwdla,fwdlb,fwdfa,fwdfb,fd,fc,wf,fasmds,
            pc,inst,ealu,malu,walu,                // for testing
            stl_lw,stl_fp,stl_lwc1,stl_swc1);      // for testing
    regfile2w fpr (fs,ft,wd,wn,ww,wmo,wrn,wwfpr,~clk,clrn,qfa,qfb);
    mux2x32 fwd_f_load_a (qfa,mmo,fwdla,fa);       // forward lwc1 to fp a
    mux2x32 fwd_f_load_b (qfb,mmo,fwdlb,fb);       // forward lwc1 to fp b
    mux2x32 fwd_f_res_a  (fa,e3d,fwdfa,dfa);       // forward fp res to fp a
    mux2x32 fwd_f_res_b  (fb,e3d,fwdfb,dfb);       // forward fp res to fp b
    fpu fp_unit (dfa,dfb,fc,wf,fd,1'b1,clk,clrn,e3d,wd,wn,ww,
                 stl,e1n,e1w,e2n,e2w,e3n,e3w,
                 e1c,e2c,e3c,cnt_div,cnt_sqrt,e,1'b1);
endmodule
