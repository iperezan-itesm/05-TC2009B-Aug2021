/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module core2_cache_tlb_memory   // dual-core cpu with cache and tlb + memory
   (v_pc1,pc1,inst1,ealu1,malu1,wdi1,wn1,wd1,ww1,
    stall_lw1,stall_fp1,stall_lwc11,stall_swc11,stall1,
    v_pc2,pc2,inst2,ealu2,malu2,wdi2,wn2,wd2,ww2,
    stall_lw2,stall_fp2,stall_lwc12,stall_swc12,stall2,
    clk,memclk,clrn,m_a,m_d_r,m_d_w,m_access,m_write,m_ready);
    input         clk, memclk, clrn;        // clocks and reset
    output [31:0] v_pc1, v_pc2;             // virtual pc
    output [31:0] pc1, pc2;                 // real pc
    output [31:0] inst1, inst2;             // instruction
    output [31:0] ealu1, ealu2;             // exe stage result
    output [31:0] malu1, malu2;             // mem stage result
    output [31:0] wdi1, wdi2;               // wb  stage result
    output [31:0] wd1, wd2;                 // fp result to be written back
    output  [4:0] wn1, wn2;                 // fp dest register number
    output        ww1, ww2;                 // fp register file write enable
    output        stall_lw1, stall_lw2;     // stall by lw
    output        stall_fp1, stall_fp2;     // stall by fp data hazard
    output        stall_lwc11, stall_lwc12; // stall by lwc1
    output        stall_swc11, stall_swc12; // stall by swc1
    output        stall1, stall2;           // pipeline stall
    output [31:0] m_a;                      // memory address
    output [31:0] m_d_r;                    // memory data read
    output [31:0] m_d_w;                    // memory data write
    output        m_access;                 // memory access
    output        m_write;                  // memory write enable
    output        m_ready;                  // memory ready
    wire          io1,io2;                  // i/o, not used
    wire   [31:0] m_a1,m_a2;
    wire   [31:0] m_d_w1,m_d_w2;
    wire          m_access1,m_access2;
    wire          m_write1,m_write2;
    reg           cnt;                      // counter
    // core1
    cpu_cache_tlb core1
      (clk,memclk,clrn,v_pc1,pc1,inst1,ealu1,malu1,wdi1,wn1,wd1,ww1,
       stall_lw1,stall_fp1,stall_lwc11,stall_swc11,stall1,
       m_a1,m_d_r,m_d_w1,m_access1,m_write1,m_ready1,io1);
    // core2
    cpu_cache_tlb core2
      (clk,memclk,clrn,v_pc2,pc2,inst2,ealu2,malu2,wdi2,wn2,wd2,ww2,
       stall_lw2,stall_fp2,stall_lwc12,stall_swc12,stall2,
       m_a2,m_d_r,m_d_w2,m_access2,m_write2,m_ready2,io2);
    // counter for arbitration on memory access collision
    always @(negedge clrn or posedge clk) begin
        if (!clrn) begin
            cnt <= 0;
        end else if (m_ready) begin
            cnt <= ~cnt;
        end
    end
    wire select1 = ~cnt & m_access1 | cnt & ~m_access2;
    // mux
    assign m_a      =  select1 ? m_a1      : m_a2;
    assign m_d_w    =  select1 ? m_d_w1    : m_d_w2;
    assign m_access =  select1 ? m_access1 : m_access2;
    assign m_write  =  select1 ? m_write1  : m_write2;
    // demux
    assign m_ready1 =  select1 & m_ready;
    assign m_ready2 = ~select1 & m_ready;
    // main memory
    physical_memory mem (m_a,m_d_r,m_d_w,m_access,m_write,m_ready,clk,
                         memclk,clrn);
endmodule
