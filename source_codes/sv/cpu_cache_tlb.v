/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module cpu_cache_tlb (clk,memclk,clrn,v_pc,pc,inst,ealu,malu,wdi,wn,wd,
                      ww,stall_lw,stall_fp,stall_lwc1,stall_swc1,stall,
                      mem_a,mem_data,mem_st_data,mem_access,mem_write,
                      mem_ready,io);          // cpu + cache + tlb
    input         clk, memclk, clrn;          // clocks and reset
    input  [31:0] mem_data;                   // main memory data read
    input         mem_ready;                  // main memory ready
    output [31:0] v_pc;                       // virtual pc
    output [31:0] pc;                         // real pc
    output [31:0] inst;                       // instruction
    output [31:0] ealu;                       // alu output in exe stage
    output [31:0] malu;                       // alu output in mem stage
    output [31:0] wdi;                        // data to iu reg file
    output [31:0] wd;                         // data to fpu reg file
    output [31:0] mem_a;                      // main memory address
    output [31:0] mem_st_data;                // main memory data write
    output  [4:0] wn;                         // fpu reg file's write number
    output        ww;                         // fpu reg file's write enable
    output        stall_lw;                   // stall by lw
    output        stall_fp;                   // stall by fp data dependency
    output        stall_lwc1;                 // stall by lwc1
    output        stall_swc1;                 // stall by swc1
    output        stall;                      // stall by div and sqrt
    output        mem_access;                 // main memory access
    output        mem_write;                  // main memory write enable
    output        io;                         // inst rom or data i/o
    wire   [31:0] e3d;                        // fpu data in e3 stage
    wire   [31:0] qfa,qfb,fa,fb,dfa,dfb;      // for iu
    wire   [31:0] mmo,wmo;
    wire    [4:0] count_div,count_sqrt;
    wire    [4:0] e1n,e2n,e3n,wrn,fs,ft,fd;
    wire    [2:0] fc;
    wire    [1:0] e1c,e2c,e3c;                // for fpu
    wire          fwdla,fwdlb,fwdfa,fwdfb;
    wire          wf,fasmds,e1w,e2w,e3w,wwfpr;
    wire          no_cache_stall,dtlb;
    wire          e;                          // for multithreading CPU
    iu_cache_tlb i_u (e1n,e2n,e3n, e1w,e2w,e3w, stall,1'b0,dfb,e3d,clk,
                  memclk,clrn,no_cache_stall,dtlb,fs,ft,wmo,wrn,wwfpr,mmo,
                  fwdla,fwdlb,fwdfa,fwdfb,fd,fc,wf,fasmds,v_pc,pc,inst,ealu,
                  malu,wdi,stall_lw,stall_fp,stall_lwc1,stall_swc1,mem_a,
                  mem_data,mem_st_data,mem_access,mem_write,mem_ready,io);
    regfile2w fpr (fs,ft,wd,wn,ww,wmo,wrn,wwfpr,~clk,clrn,qfa,qfb);
    mux2x32 fwd_f_load_a (qfa,mmo,fwdla,fa);  // forward lwc1 to fp a
    mux2x32 fwd_f_load_b (qfb,mmo,fwdlb,fb);  // forward lwc1 to fp b
    mux2x32 fwd_f_res_a  (fa,e3d,fwdfa,dfa);  // forward fp res to fp a
    mux2x32 fwd_f_res_b  (fb,e3d,fwdfb,dfb);  // forward fp res to fp b
    fpu  fp_unit (dfa,dfb,fc,wf,fd,no_cache_stall,clk,clrn,e3d,wd,wn,ww,
                  stall,e1n,e1w,e2n,e2w,e3n,e3w,e1c,e2c,e3c,count_div,
                  count_sqrt,e,dtlb);
endmodule
