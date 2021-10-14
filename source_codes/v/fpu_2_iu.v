/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
// two-thread cpu with fpu, instruction memory, and data memory
module fpu_2_iu (clrn,memclk,clk,pc0,inst0,ealu0,malu0,walu0,ww0,stl_lw0,
                 stl_lwc10,stl_swc10,stl_fp0,stall0,st0,pc1,inst1,ealu1,
                 malu1,walu1,ww1,stl_lw1,stl_lwc11,stl_swc11,stl_fp1,stall1,
                 st1,wn,wd,cnt_div,cnt_sqrt,e1n,e2n,e3n,e3d,e);
    input         clk, memclk, clrn;               // clocks and reset
    output [31:0] pc0, inst0, ealu0, malu0, walu0;
    output [31:0] pc1, inst1, ealu1, malu1, walu1;
    output [31:0] e3d, wd;
    output  [4:0] e1n, e2n, e3n, wn;
    output        ww0, stl_lw0, stl_lwc10, stl_swc10, stl_fp0, stall0, st0;
    output        ww1, stl_lw1, stl_lwc11, stl_swc11, stl_fp1, stall1, st1;
    output        e;                // for multithreading CPU, not used here
    output  [4:0] cnt_div,cnt_sqrt;
    wire   [31:0] qfa0,qfb0,fa0,fb0,dfa0,dfb0,mmo0,wmo0;
    wire   [31:0] qfa1,qfb1,fa1,fb1,dfa1,dfb1,mmo1,wmo1;
    wire    [4:0] fs0,ft0,fd0,wrn0; 
    wire    [4:0] fs1,ft1,fd1,wrn1; 
    wire    [2:0] fc0;
    wire    [2:0] fc1;
    wire          fwdla0,fwdlb0,fwdfa0,fwdfb0,wf0,fasmds0;
    wire          fwdla1,fwdlb1,fwdfa1,fwdfb1,wf1,fasmds1;
    wire   [31:0] dfa,dfb;                         // fp inputs a and b
    wire    [4:0] fd;                              // fp dest reg #
    wire    [2:0] fc;                              // fp operation code
    wire    [1:0] e1c,e2c,e3c;
    wire          wf;                              // fp regfile we
    wire          stall0,e1w0,e2w0,e3w0,ww0;
    wire          stall1,e1w1,e2w1,e3w1,ww1;
    wire          dt;
    reg           cnt,e1t,e2t,e3t,wt;
    // thread 0
    iu th0 (e1n,e2n,e3n, e1w0,e2w0,e3w0, stall0,st0,
            dfb0,e3d, clk,memclk,clrn,
            fs0,ft0,wmo0,wrn0,wwfpr0,mmo0,fwdla0,fwdlb0,fwdfa0,fwdfb0,
            fd0,fc0,wf0,fasmds0,pc0,inst0,ealu0,malu0,walu0,
            stl_lw0,stl_fp0,stl_lwc10,stl_swc10);
    regfile2w fpr0 (fs0,ft0,wd,wn,ww0,wmo0,wrn0,wwfpr0,
                   ~clk,clrn,qfa0,qfb0);
    mux2x32 fwd_f_load_a0 (qfa0,mmo0,fwdla0,fa0);  // forward lwc1 to fp a
    mux2x32 fwd_f_load_b0 (qfb0,mmo0,fwdlb0,fb0);  // forward lwc1 to fp b
    mux2x32 fwd_f_res_a0  (fa0,e3d,fwdfa0,dfa0);   // forward fp res to fp a
    mux2x32 fwd_f_res_b0  (fb0,e3d,fwdfb0,dfb0);   // forward fp res to fp b
    // thread 1
    iu th1 (e1n,e2n,e3n, e1w1,e2w1,e3w1, stall1,st1,
            dfb1,e3d, clk,memclk,clrn,
            fs1,ft1,wmo1,wrn1,wwfpr1,mmo1,fwdla1,fwdlb1,fwdfa1,fwdfb1,
            fd1,fc1,wf1,fasmds1,pc1,inst1,ealu1,malu1,walu1,
            stl_lw1,stl_fp1,stl_lwc11,stl_swc11);
    regfile2w fpr1 (fs1,ft1,wd,wn,ww1,wmo1,wrn1,wwfpr1,
                   ~clk,clrn,qfa1,qfb1);
    mux2x32 fwd_f_load_a1 (qfa1,mmo1,fwdla1,fa1);  // forward lwc1 to fp a
    mux2x32 fwd_f_load_b1 (qfb1,mmo1,fwdlb1,fb1);  // forward lwc1 to fp b
    mux2x32 fwd_f_res_a1  (fa1,e3d,fwdfa1,dfa1);   // forward fp res to fp a
    mux2x32 fwd_f_res_b1  (fb1,e3d,fwdfb1,dfb1);   // forward fp res to fp b
    // fpu
    wire   [31:0] s_sqrt;                          // fp output
    wire   [25:0] sqrt_x;                          // x_i
    fpu fp_unit (dfa,dfb,fc,wf,fd,1'b1,clk,clrn,
                 e3d,wd,wn,ww,stall,e1n,e1w,e2n,
                 e2w,e3n,e3w,e1c,e2c,e3c,cnt_div,
                 cnt_sqrt,e,1'b1);                 // no dtlb, hit = 1
    // mux: fpu selects thread 0 or thread 1
    assign dfa = dt? dfa1 : dfa0;
    assign dfb = dt? dfb1 : dfb0;
    assign fd  = dt? fd1  : fd0;
    assign wf  = dt? wf1  : wf0;
    assign fc  = dt? fc1  : fc0;
    // demux: for thread 0;        for thread 1
    assign stall0 = stall & ~dt;   assign stall1 = stall &  dt;  // ID stage
    assign   e1w0 =   e1w & ~e1t;  assign   e1w1 =   e1w &  e1t; // E1 stage
    assign   e2w0 =   e2w & ~e2t;  assign   e2w1 =   e2w &  e2t; // E2 stage
    assign   e3w0 =   e3w & ~e3t;  assign   e3w1 =   e3w &  e3t; // E3 stage
    assign    ww0 =    ww & ~wt;   assign    ww1 =    ww &  wt;  // WB stage
    // thread selection
    assign  dt  = ~fasmds0 & fasmds1 | cnt & fasmds1;     // selected thread
    assign  st0 =  cnt & fasmds0 & fasmds1;               // stall thread 0
    assign  st1 = ~cnt & fasmds0 & fasmds1;               // stall thread 1
    // count for thread selection
    always @(negedge clrn or posedge clk) begin
        if (!clrn) begin
            cnt <= 0;
        end else if (e) begin
            cnt <= ~cnt;
        end
    end
    // pipelined thread info
    always @(negedge clrn or posedge clk) begin
        if (!clrn) begin
            e1t <= 0;        e2t <= 0;        e3t <= 0;        wt  <= 0;
        end else if (e) begin
            e1t <= dt;       e2t <= e1t;      e3t <= e2t;      wt  <= e3t;
        end
    end
endmodule
