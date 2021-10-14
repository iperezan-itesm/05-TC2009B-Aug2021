/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module cpu_cache_tlb_memory_tb;
    reg         clk,memclk,clrn;
    wire [31:0] v_pc,pc,inst,ealu,malu,wdi;
    wire [31:0] wd;
    wire  [4:0] wn;
    wire        ww,stall_lw,stall_fp,stall_lwc1,stall_swc1,stall;
    wire [31:0] m_a;
    wire [31:0] m_d_r;
    wire [31:0] m_d_w;
    wire        m_access;
    wire        m_write;
    wire        m_ready;   
    cpu_cache_tlb_memory compsys (clk,memclk,clrn,
                                  v_pc,pc,inst,ealu,malu,wdi,wn,wd,ww,
                                  stall_lw,stall_fp,stall_lwc1,stall_swc1,
                                  stall,m_a,m_d_r,m_d_w,m_access,m_write,
                                  m_ready);
    initial begin
              clk    = 1;
              memclk = 0;
              clrn   = 0;
        #1    clrn   = 1;
        #4999 $finish;
    end
    always #1 memclk = !memclk;
    always #2 clk    = !clk;
endmodule
/* 144
1   004- 148 reset
2   148- 292 reset
3   292- 436 goto user prog
4   436- 580 goto user prog
5  1156-1300 eret
6  4340-4500 cache hit
*/
