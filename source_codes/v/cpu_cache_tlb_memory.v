/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module cpu_cache_tlb_memory (clk,memclk,clrn,v_pc,pc,inst,ealu,malu,wdi,wn,
    wd,ww,stall_lw,stall_fp,stall_lwc1,stall_swc1,stall,m_a,m_d_r,m_d_w,
    m_access,m_write,m_ready);                // cpu + cache + tlb + memory
    input         clk, memclk, clrn;          // clocks and reset
    output [31:0] v_pc;                       // virtual pc
    output [31:0] pc;                         // real pc
    output [31:0] inst;                       // instruction
    output [31:0] ealu;                       // alu output in exe stage
    output [31:0] malu;                       // alu output in mem stage
    output [31:0] wdi;                        // data to iu reg file
    output [31:0] wd;                         // data to fpu reg file
    output  [4:0] wn;                         // fpu reg file's write number
    output        ww;                         // fpu reg file's write enable
    output        stall_lw;                   // stall by lw
    output        stall_fp;                   // stall by fp data dependency
    output        stall_lwc1;                 // stall by lwc1
    output        stall_swc1;                 // stall by swc1
    output        stall;                      // stall by div and sqrt
    output [31:0] m_a;                        // main memory address
    output [31:0] m_d_r;                      // main memory data read
    output [31:0] m_d_w;                      // main memory data write
    output        m_access;                   // main memory access
    output        m_write;                    // main memory write enable
    output        m_ready;                    // main memory ready
    wire          io;                         // inst rom or data i/o
    // cpu
    cpu_cache_tlb cpucachetlb (
        clk,memclk,clrn,v_pc,pc,inst,ealu,malu,wdi,wn,wd,
        ww,stall_lw,stall_fp,stall_lwc1,stall_swc1,stall,
        m_a,m_d_r,m_d_w,m_access,m_write,m_ready,io);
    // i/o, ignored
    wire [31:0]   io_d_r   = 0;               // ignored io here
    wire          io_ready = 1;               // ignored io here
    wire [31:0]   mem_d_r;
    wire          mem_ready;
    wire          mem_access = m_access & ~io;
    wire           io_access = m_access &  io;
    wire          mem_write  = m_write  & ~io;
    wire           io_write  = m_write  &  io;
    assign        m_d_r      = (io) ? io_d_r   : mem_d_r;
    assign        m_ready    = (io) ? io_ready : mem_ready;
    // main memory
    physical_memory mem (m_a,mem_d_r,m_d_w,mem_access,m_write,mem_ready,
                         clk,memclk,clrn);
endmodule
